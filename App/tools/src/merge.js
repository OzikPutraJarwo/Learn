const fs = require('fs');
const path = require('path');

const filesToMerge = [
    'script.js',
    'bfr.js',
    'pdc.js',
    'dta.js'
];

const outputFile = 'merged.js';

function mergeFiles(files, output) {
    const writeStream = fs.createWriteStream(output);

    files.forEach(file => {
        const filePath = path.resolve(__dirname, file);
        if (fs.existsSync(filePath)) {
            const data = fs.readFileSync(filePath, 'utf8');
            writeStream.write(data + '\n'); 
        } else {
            console.error(`File tidak ditemukan: ${file}`);
        }
    });

    writeStream.end();
    writeStream.on('finish', () => {
        console.log(`File berhasil digabungkan menjadi: ${output}`);
    });
}

mergeFiles(filesToMerge, outputFile);