document.getElementById('dta-form').addEventListener('submit', function (event) {
  event.preventDefault();

  const doiList = document.getElementById('dta-doi').value.trim().split('\n').map(doi => doi.trim());
  const citationList = document.getElementById('dta-list');
  const dtaOutput = document.querySelector("#doi-to-apa .output");

  dtaOutput.classList.remove('hide');

  citationList.innerHTML = ''; 

  doiList.forEach(doi => {
    if (doi) {
      fetch(`https://api.crossref.org/works/${encodeURIComponent(doi)}`)
        .then(response => {
          if (!response.ok) throw new Error(`Article not found for: ${doi}`);
          return response.json();
        })
        .then(data => displayCitation(data.message, citationList))
        .catch(error => {
          const errorItem = document.createElement('li');
          errorItem.className = 'error';
          errorItem.textContent = error.message;
          citationList.appendChild(errorItem);
        });
    }
  });
});

function displayCitation(item, citationList) {
  const authors = item.author.map((author, index) => {
    if (index === 0) {
      return `${author.family} ${author.given.charAt(0)}.`;
    }
    return `${author.given.charAt(0)}. ${author.family}`;
  }).join(', ');

  const year = item['published-print'] ? item['published-print']['date-parts'][0][0] : 'Year not available';
  const title = item.title[0].replace(/<[^>]*>/g, '');
  const journal = item['container-title'][0].replace(/<[^>]*>/g, '');
  const volume = item.volume ? item.volume : '';
  const issue = item.issue ? item.issue : '';
  const page = item.page ? item.page : '';

  const citation = `${authors}. ${year}. ${title}. ${journal}, ${volume}${issue ? `(${issue})` : ''}, ${page}.`;

  const citationItem = document.createElement('div');
  citationItem.className = 'dta-citation';
  citationItem.textContent = citation;

  const infoDiv = document.createElement('div');
  infoDiv.className = 'dta-info';
  infoDiv.innerHTML = `
    <span>Title: ${title}</span>
    <span>Authors: ${authors}</span>
    <span>Year: ${year}</span>
    <span>Journal: ${journal}</span>
    <span>Volume: ${volume}</span>
    <span>Issue: ${issue}</span>
    <span>Page: ${page}</span>
    <span>DOI: ${item.DOI}</span>
  `.trim();

  citationItem.addEventListener('click', function () {
    if (infoDiv.style.display === 'none' || infoDiv.style.display === '') {
      infoDiv.style.display = 'block';
    } else {
      infoDiv.style.display = 'none';
    }
  });

  citationList.appendChild(citationItem);
  citationList.appendChild(infoDiv);
}