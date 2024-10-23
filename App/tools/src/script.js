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