// Main Func

const setActive = (navClass, sectionId) => {
	document.querySelectorAll('main section, nav .item').forEach(el => el.classList.remove('active'));
	document.querySelector(`nav .${navClass}`).classList.add('active');
	document.getElementById(sectionId).classList.add('active');
};

['home', 'unit-converter', 'bulk-file-renamer', 'pdf-combiner', 'image-converter', 'image-compressor', 'qr-generator', 'doi-to-apa', 'file-analyzer'].forEach(name => {
	document.querySelectorAll(`.${name}`).forEach(el => {
		el.addEventListener('click', () => setActive(name, name));
	});
});

const fileInputs = document.querySelectorAll('input[type="file"]');

fileInputs.forEach(fileInput => {
	const dropContainer = fileInput.parentElement;

	dropContainer.addEventListener("dragover", (e) => {
		e.preventDefault();
	}, false);

	dropContainer.addEventListener("dragenter", () => {
		dropContainer.classList.add("drag-active");
	});

	dropContainer.addEventListener("dragleave", () => {
		dropContainer.classList.remove("drag-active");
	});

	dropContainer.addEventListener("drop", (e) => {
		e.preventDefault();
		dropContainer.classList.remove("drag-active");
		fileInput.files = e.dataTransfer.files;
		fileInput.dispatchEvent(new Event('change'));
	});
});

function showMessage(message) {
	const popMessage = document.getElementById('pop-message');
	const messageParagraph = popMessage.querySelector('p');
	messageParagraph.textContent = message;
	popMessage.classList.add('show');
	setTimeout(() => {
			popMessage.classList.remove('show');
	}, 3000);
}

// Load script on click

function loadScript(selector, src) {
	let scriptLoaded = false;
	document.querySelectorAll(selector).forEach(el => {
			el.addEventListener('click', () => {
					if (!scriptLoaded) {
							const script = document.createElement('script');
							script.src = src;
							document.body.appendChild(script);
							scriptLoaded = true;
					}
			});
	});
}

loadScript(".pdf-combiner", "https://cdnjs.cloudflare.com/ajax/libs/pdf-lib/1.17.1/pdf-lib.min.js");
loadScript(".pdf-combiner", "https://cdnjs.cloudflare.com/ajax/libs/pdf.js/2.10.377/pdf.min.js");
loadScript(".pdf-combiner", "./src/pdc.js");
loadScript(".qr-generator", "https://unpkg.com/qr-code-styling@1.5.0/lib/qr-code-styling.js");

function copyAll(selector) {
	const text = Array.from(document.querySelectorAll(selector))
			.filter(el => el.offsetWidth > 0 && el.offsetHeight > 0)
			.map(el => el.innerText)
			.join('\n');
	if (text) {
			const textarea = document.createElement('textarea');
			textarea.value = text;
			document.body.appendChild(textarea);
			textarea.select();
			document.execCommand('copy');
			document.body.removeChild(textarea);
			showMessage("Copied!");
	}
}
// Bulk File Renamer

let renamedFiles = [];
let rules = [];

let bfrInputFiles = document.getElementById('bfr-input-files'),
	bfrClearFiles = document.getElementById('bfr-files-clear'),
	bfrInsertSave = document.getElementById('bfr-insert-save'),
	bfrRemoveSave = document.getElementById('bfr-remove-save'),
	bfrReplaceSave = document.getElementById('bfr-replace-save'),
	bfrRulesRemove = document.getElementById('bfr-rules-remove');

bfrInputFiles.addEventListener('change', bfrAddFiles);
bfrClearFiles.addEventListener('click', bfrClearAllFiles);
bfrInsertSave.addEventListener('click', bfrInsert);
bfrRemoveSave.addEventListener('click', bfrRemove);
bfrReplaceSave.addEventListener('click', bfrReplace);
bfrRulesRemove.addEventListener('click', bfrRemoveAllRules);

function bfrAddFiles() {
	const files = bfrInputFiles.files;
	const newFiles = Array.from(files);
	renamedFiles = renamedFiles.concat(newFiles.map(file => ({ name: file.name, originalFile: file })));
	bfrUpdateFiles();
}

function bfrInsert() {
	const insertText = document.getElementById('bfr-insert-text').value;
	const insertPosition = document.getElementById('bfr-insert-position').value;
	const insertOption = document.getElementById('bfr-insert-option').value;
	if (insertText) {
		const rule = { type: 'insert', text: insertText, position: parseInt(insertPosition), option: insertOption };
		rules.push(rule);
		bfrUpdateRules();
		insertText.value = '';
		insertPosition.value = '';
		bfrUpdateFiles();
	} else {
		showMessage('Please fill in the text to insert.');
	}
}

function bfrRemove() {
	const removeText = document.getElementById('bfr-remove-text').value;
	const caseSensitive = document.getElementById('bfr-remove-cs').checked;
	if (removeText) {
		const rule = { type: 'remove', text: removeText, caseSensitive };
		rules.push(rule);
		bfrUpdateRules();
		removeText.value = '';
		bfrUpdateFiles();
	} else {
		showMessage('Please fill in the text to remove.');
	}
}

function bfrReplace() {
	const from = document.getElementById('bfr-replace-from').value;
	const to = document.getElementById('bfr-replace-to').value;
	if (from && to) {
		const rule = { type: 'replace', from, to };
		rules.push(rule);
		bfrUpdateRules();
		from.value = '';
		to.value = '';
		bfrUpdateFiles();
	} else {
		showMessage('Please fill in both fields to add a replace rule.');
	}
}

function bfrUpdateRules() {
	const rulesList = document.getElementById('bfr-rules-list');
	rulesList.innerHTML = '';
	rules.forEach((rule, index) => {
		const listItem = document.createElement('div');
		if (rule.type === 'replace') {
			listItem.innerHTML = `<span>Replace</span> <span>${rule.from || ''} → ${rule.to || ''}</span>`;
		} else if (rule.type === 'insert') {
			listItem.innerHTML = `<span>Insert</span> <span>${rule.text + ' | ' + rule.option + ' <sub>(' + rule.position + ')</sub>  ' || ''}</span>`;
		} else if (rule.type === 'remove') {
			listItem.innerHTML = `<span>Remove</span> <span>${rule.text} ${rule.caseSensitive ? '<sub>(CS)</sub>' : ''}</span>`;
		}
		listItem.dataset.index = index;
		const checkbox = document.createElement('span');
		checkbox.setAttribute("onclick", "bfrRemoveSelectedRules()");
		checkbox.innerHTML = `<input type="checkbox"/><svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"> <path d="M16 8L8 16M8 8L16 16" stroke-width="2" stroke-linecap="round"/> </svg>`;
		listItem.append(checkbox);
		rulesList.appendChild(listItem);
	});
	bfrRulesRemove.style.display = rules.length > 0 ? 'block' : 'none';
}

function bfrRemoveSelectedRules() {
	const selectedCheckboxes = document.querySelectorAll('#bfr-rules-list input[type="checkbox"]:checked');
	const indicesToRemove = Array.from(selectedCheckboxes).map(checkbox => {
		const listItem = checkbox.closest('div');
		return parseInt(listItem.dataset.index);
	});
	rules = rules.filter((rule, index) => !indicesToRemove.includes(index));
	bfrUpdateRules();
	bfrUpdateFiles();
}

function bfrRemoveAllRules() {
	document.querySelectorAll('#bfr-rules-list input[type="checkbox"]').forEach(checkbox => {
		checkbox.checked = true;
	})
	bfrRemoveSelectedRules();
}

function bfrUpdateFiles() {
	const tbody = document.getElementById('bfr-files-table');
	tbody.innerHTML = '';
	renamedFiles.forEach(file => {
		const fileName = file.name.substring(0, file.name.lastIndexOf('.')) || file.name;
		const fileExt = file.name.substring(file.name.lastIndexOf('.'));
		let newFileName = fileName;
		rules.forEach(rule => {
			if (rule.type === 'insert') {
				const position = rule.position - 1;
				const words = newFileName.split(' ');
				if (rule.option === 'Prefix') {
					if (position >= 0 && position < words.length) {
						words.splice(position, 0, rule.text);
					}
				} else if (rule.option === 'Suffix') {
					if (position >= 0 && position < words.length) {
						words.splice(words.length - position, 0, rule.text);
					}
				}
				newFileName = words.join(' ');
			} else if (rule.type === 'remove') {
				if (rule.caseSensitive) {
					newFileName = newFileName.replace(new RegExp(rule.text, 'g'), '');
				} else {
					newFileName = newFileName.replace(new RegExp(rule.text, 'gi'), '');
				}
			} else if (rule.type === 'replace') {
				newFileName = newFileName.replace(new RegExp(rule.from, 'g'), rule.to);
			}
		});
		file.newName = newFileName + fileExt;
		const row = tbody.insertRow();
		const originalCell = row.insertCell(0);
		const renamedCell = row.insertCell(1);
		const selectCell = row.insertCell(2);
		selectCell.setAttribute("onclick", "bfrRemoveSelectedFiles()");
		selectCell.innerHTML = `<input type='checkbox'/><svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"> <path d="M16 8L8 16M8 8L16 16" stroke-width="2" stroke-linecap="round"/> </svg>`;
		originalCell.textContent = file.name;
		renamedCell.textContent = file.newName;
	});
	document.getElementById('bfr-files-empty').style.display = 'none';
	document.getElementById('bfr-files-tables').style.display = renamedFiles.length > 0 ? 'block' : 'none';
	document.getElementById('bfr-files-download').style.display = renamedFiles.length > 0 ? 'grid' : 'none';
	document.getElementById('bfr-files-clear').style.display = renamedFiles.length > 0 ? 'grid' : 'none';
}

function bfrClearAllFiles() {
	renamedFiles = [];
	document.getElementById('bfr-files-table').innerHTML = '';
	rules = [];
	bfrUpdateRules();
	document.getElementById('bfr-files-empty').style.display = 'block';
	document.getElementById('bfr-files-tables').style.display = 'none';
	document.getElementById('bfr-files-download').style.display = 'none';
	document.getElementById('bfr-files-clear').style.display = 'none';
}

function bfrRemoveSelectedFiles() {
	const selectedCheckboxes = document.querySelectorAll('#bfr-files-table input[type="checkbox"]:checked');
	const filesToRemove = Array.from(selectedCheckboxes).map(checkbox => {
		const row = checkbox.closest('tr');
		const originalFileName = row.cells[1].textContent;
		return renamedFiles.find(file => file.name === originalFileName);
	});
	renamedFiles = renamedFiles.filter(file => !filesToRemove.includes(file));
	bfrUpdateFiles();
};

document.getElementById('bfr-files-download').onclick = () => {
	renamedFiles.forEach(file => {
		const blob = new Blob([file.originalFile], { type: file.originalFile.type });
		const url = URL.createObjectURL(blob);
		const a = document.createElement('a');
		a.href = url;
		a.download = file.newName || file.name;
		document.body.appendChild(a);
		a.click();
		document.body.removeChild(a);
		URL.revokeObjectURL(url);
	});
};

document.querySelectorAll('.rule-insert, .rule-remove, .rule-replace').forEach(rule => {
	rule.addEventListener('click', () => {
		document.querySelectorAll('.rule-insert, .rule-remove, .rule-replace, .set-insert, .set-remove, .set-replace').forEach(el => el.classList.remove('active'));
		rule.classList.add('active');
		document.querySelector(`.set-${rule.classList[0].split('-')[1]}`).classList.add('active');
	});
});
// PDF Combiner

const pdfInput = document.getElementById('pdc-input-files');
const fileList = document.getElementById('pdc-file-list');
const combineBtn = document.getElementById('pdc-combine');
const outputFileName = document.getElementById('pdc-file-name');
let pdcfiles = [];
let pdcthumbnails = [];

pdfInput.addEventListener('change', async (event) => {
    fileList.innerHTML = "Loading...";
    const newFiles = Array.from(event.target.files);
    for (const file of newFiles) {
        pdcfiles.push(file);
        const thumbnailSrc = await createThumbnail(file);
        pdcthumbnails.push(thumbnailSrc);
    }
    displayFiles();
    combineBtn.disabled = pdcfiles.length === 0; 
});

function displayFiles() {
    fileList.innerHTML = '';
    for (let i = 0; i < pdcfiles.length; i++) {
        if (pdcthumbnails[i] === undefined) {
            continue;
        }

        const fileItem = document.createElement('div');
        fileItem.className = 'file-item';

        fileItem.innerHTML = `
            <img src="${pdcthumbnails[i]}" class="thumbnail" alt="Thumbnail">
            <span>${pdcfiles[i].name}</span>
            <div>
                <button onclick="moveFile(${i}, -1)"><svg viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"> <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M16 13l-6-6-6 6"/> </svg></button>
                <button onclick="moveFile(${i}, 1)"><svg viewBox="0 0 20 20" xmlns="http://www.w3.org/2000/svg"> <path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M4 7l6 6 6-6"/> </svg></button>
                <button onclick="removeFile(${i})"><svg viewBox="0 0 24 24" fill="none" xmlns="http://www.w3.org/2000/svg"> <path d="M16 8L8 16M8 8L16 16" stroke-width="2" stroke-linecap="round"/></button>
            </div>
        `;
        fileList.appendChild(fileItem);
    }
}

async function createThumbnail(file) {
    const pdfData = await file.arrayBuffer();
    const pdfDoc = await pdfjsLib.getDocument({ data: pdfData }).promise;
    const page = await pdfDoc.getPage(1);
    const viewport = page.getViewport({ scale: 1 });

    const scale = 200 / Math.max(viewport.width, viewport.height);
    const scaledViewport = page.getViewport({ scale });

    const canvas = document.createElement('canvas');
    canvas.width = scaledViewport.width;
    canvas.height = scaledViewport.height;
    const context = canvas.getContext('2d');

    const renderContext = {
        canvasContext: context,
        viewport: scaledViewport,
    };
    await page.render(renderContext).promise;
    return canvas.toDataURL();
}

function moveFile(index, direction) {
    const newIndex = index + direction;
    if (newIndex < 0 || newIndex >= pdcfiles.length) return;

    [pdcfiles[index], pdcfiles[newIndex]] = [pdcfiles[newIndex], pdcfiles[index]];
    [pdcthumbnails[index], pdcthumbnails[newIndex]] = [pdcthumbnails[newIndex], pdcthumbnails[index]];
    displayFiles(); 
}

function removeFile(index) {
    pdcfiles.splice(index, 1);
    pdcthumbnails.splice(index, 1);
    displayFiles();
    combineBtn.disabled = pdcfiles.length === 0;
}

combineBtn.addEventListener('click', async () => {
    pdcfiles = pdcfiles.filter((_, index) => pdcthumbnails[index] !== undefined);
    pdcthumbnails = pdcthumbnails.filter(thumbnail => thumbnail !== undefined);

    if (pdcfiles.length === 0) {
				showMessage("Upload file first!");
        return;
    }

    const pdfDoc = await PDFLib.PDFDocument.create();
    pdfDoc.setTitle('Kode Jarwo');
    pdfDoc.setAuthor('Kode Jarwo');

    for (const file of pdcfiles) {
        const fileData = await file.arrayBuffer();
        const pdfToMerge = await PDFLib.PDFDocument.load(fileData);
        const copiedPages = await pdfDoc.copyPages(pdfToMerge, pdfToMerge.getPageIndices());
        copiedPages.forEach((page) => pdfDoc.addPage(page));
    }

    const pdfBytes = await pdfDoc.save();
    const blob = new Blob([pdfBytes], { type: 'application/pdf' });
    const url = URL.createObjectURL(blob);
    const a = document.createElement('a');
    a.href = url;
    a.download = outputFileName.value || 'combined-by-kodejarwo.pdf';
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
});
// DOI to APA

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
        .then(data => {
          displayCitation(data.message, citationList);
          console.log(data.message);
        })
        .catch(error => {
          const errorItem = document.createElement('div');
          errorItem.className = 'dta-error';
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
  const URL = item.URL ? item.URL : '';

  const citation = `${authors}. ${year}. ${title}. ${journal}, ${volume}${issue ? `(${issue})` : ''}, ${page}. ${URL}`;

  const citationItem = document.createElement('div');
  citationItem.className = 'dta-citation';
  citationItem.textContent = citation.replace("Year not available. ","").replace("..",".");

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
    <span>Publisher: ${item.publisher}</span>
    <span>ISSN: ${item.ISSN}</span>
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
