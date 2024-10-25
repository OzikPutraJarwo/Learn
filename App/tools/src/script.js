// Main Func

const setActive = (navClass, sectionId) => {
	document.querySelectorAll('main section, nav .item').forEach(el => el.classList.remove('active'));
	document.querySelector(`nav .${navClass}`).classList.add('active');
	document.getElementById(sectionId).classList.add('active');
};

['home', 'unit-converter', 'bulk-file-renamer', 'pdf-combiner', 'image-converter', 'image-compressor', 'image-watermark', 'qr-generator', 'doi-to-apa', 'file-analyzer'].forEach(name => {
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

// Function per Features

let bfrInputFiles = document.getElementById('bfr-input-files');
function bfrAddFiles() {
	const files = bfrInputFiles.files;
	const newFiles = Array.from(files);
	renamedFiles = renamedFiles.concat(newFiles.map(file => ({ name: file.name, originalFile: file })));
	bfrUpdateFiles();
};

let iwmupload = document.getElementById('iwm-input-files');
let iwmcanvas = document.getElementById('iwm-canvas');
let imwuploadedImage = new Image();
iwmupload.addEventListener('change', (e) => {
  const file = e.target.files[0];
  if (file) {
    const reader = new FileReader();
    reader.onload = (event) => {
      imwuploadedImage.src = event.target.result;
      imwuploadedImage.onload = () => {
        iwmcanvas.width = imwuploadedImage.width;
        iwmcanvas.height = imwuploadedImage.height;
        posX = iwmcanvas.width / 2;
        posY = iwmcanvas.height / 2;
        drawImageWithWatermark();
      };
    };
    reader.readAsDataURL(file);
  }
});

const pdfInput = document.getElementById('pdc-input-files');
const pdcfileList = document.getElementById('pdc-file-list');
const combineBtn = document.getElementById('pdc-combine');
const outputFileName = document.getElementById('pdc-file-name');
let pdcfiles = [];
let pdcthumbnails = [];
pdfInput.addEventListener('change', async (event) => {
	pdcfileList.innerHTML = "Loading...";
	const newFiles = Array.from(event.target.files);
	for (const file of newFiles) {
			pdcfiles.push(file);
			const thumbnailSrc = await createThumbnail(file);
			pdcthumbnails.push(thumbnailSrc);
	}
	displayFiles();
	combineBtn.disabled = pdcfiles.length === 0; 
});

const qrgInputs = document.querySelectorAll(`
  #qrg-width,#qrg-height,#qrg-data,#qrg-margin,
  #qrg-bgselector,#qrg-bgcolor,#qrg-bggradA,#qrg-bggradB,#qrg-bggradT,#qrg-bggradR,
  #qrg-qrdensity,#qrg-qrmode,#qrg-qrerror,
  #qrg-imgbgdot,#qrg-imgsize,#qrg-imgmargin,
  #qrg-dotsselector,#qrg-dotscolor,#qrg-dotsgradA,#qrg-dotsgradB,#qrg-dotsgradT,#qrg-dotsgradR,#qrg-dotstype,
  #qrg-csselector,#qrg-cscolor,#qrg-csgradA,#qrg-csgradB,#qrg-csgradT,#qrg-csgradR,#qrg-cstype,
  #qrg-cdselector,#qrg-cdcolor,#qrg-cdgradA,#qrg-cdgradB,#qrg-cdgradT,#qrg-cdgradR,#qrg-cdtype
  `);
const qrgvalues = {};
qrgInputs.forEach(input => {
  qrgvalues[input.id] = input.value;
  input.addEventListener("input", () => {
    qrgvalues[input.id] = input.value;
    console.log(`${input.id}: ${qrgvalues[input.id]}`);
    generateQR();
  });
});