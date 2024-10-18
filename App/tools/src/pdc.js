const pdfInput = document.getElementById('pdc-input-files');
const fileList = document.getElementById('pdc-file-list');
const combineBtn = document.getElementById('pdc-combine');
const outputFileName = document.getElementById('pdc-file-name');
let pdcfiles = [];
let pdcthumbnails = [];

pdfInput.addEventListener('change', async (event) => {
    const newFiles = Array.from(event.target.files);
    for (const file of newFiles) {
        // Tambahkan file baru ke daftar file yang sudah ada
        pdcfiles.push(file);
        const thumbnailSrc = await createThumbnail(file);
        pdcthumbnails.push(thumbnailSrc);
    }
    displayFiles();
    combineBtn.disabled = pdcfiles.length === 0; // Aktifkan tombol jika ada file
});

function displayFiles() {
    fileList.innerHTML = '';
    for (let i = 0; i < pdcfiles.length; i++) {
        // Hapus item dengan thumbnail undefined
        if (pdcthumbnails[i] === undefined) {
            continue; // Skip this iteration
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

    // Set thumbnail size while keeping aspect ratio
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
    return canvas.toDataURL(); // Return the thumbnail as a data URL
}

function moveFile(index, direction) {
    const newIndex = index + direction;
    if (newIndex < 0 || newIndex >= pdcfiles.length) return;

    // Swap pdcfiles and pdcthumbnails
    [pdcfiles[index], pdcfiles[newIndex]] = [pdcfiles[newIndex], pdcfiles[index]];
    [pdcthumbnails[index], pdcthumbnails[newIndex]] = [pdcthumbnails[newIndex], pdcthumbnails[index]];
    displayFiles(); // Re-render the list
}

function removeFile(index) {
    pdcfiles.splice(index, 1);
    pdcthumbnails.splice(index, 1); // Remove corresponding thumbnail
    displayFiles();
    combineBtn.disabled = pdcfiles.length === 0; // Nonaktifkan tombol jika tidak ada file
}

combineBtn.addEventListener('click', async () => {
    // Hapus item dengan thumbnail undefined sebelum menggabungkan
    pdcfiles = pdcfiles.filter((_, index) => pdcthumbnails[index] !== undefined);
    pdcthumbnails = pdcthumbnails.filter(thumbnail => thumbnail !== undefined);

    if (pdcfiles.length === 0) {
        alert('Silakan pilih file PDF untuk digabungkan.');
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
    a.download = outputFileName.value || 'combined.pdf';
    document.body.appendChild(a);
    a.click();
    document.body.removeChild(a);
    URL.revokeObjectURL(url);
});