// QR Code Generator

const qrginputs = document.querySelectorAll("#qrg-width,#qrg-height,#qrg-data,#qrg-margin,#qrg-qrdensity,#qrg-qrmode,#qrg-qrerror,#qrg-imgbgdot,#qrg-imgsize,#qrg-imgmargin,#qrg-dotscolor,#qrg-dotstype,#qrg-bgcolor,#qrg-cscolor,#qrg-cstype,#qrg-cdcolor,#qrg-cdtype");
const qrgvalues = {};

qrginputs.forEach(input => {
  qrgvalues[input.id] = input.value;
  input.addEventListener("input", () => {
    qrgvalues[input.id] = input.value;
    console.log(`${input.id}: ${qrgvalues[input.id]}`);
    generateQR();
  });
});

let qrgImageFix;
document.getElementById("qrg-image").addEventListener("change", function (event) {
  const file = event.target.files[0];
  if (file) {
    const reader = new FileReader();
    reader.onload = function (e) {
      qrgImageFix = e.target.result;
      generateQR();
    };
    reader.readAsDataURL(file);
  };
});

let downloadQR = function(){};

function generateQR() {
  const qrCode = new QRCodeStyling({
    width: qrgvalues['qrg-width'] || 300,
    height: qrgvalues['qrg-height'] || 300,
    type: "svg",
    data: qrgvalues['qrg-data'] || "https://www.kodejarwo.com/",
    image: qrgImageFix || "",
    margin: qrgvalues['qrg-margin'] || 0,
    qrOptions: {
      typeNumber: qrgvalues['qrg-qrdensity'] || 0, // 0 - 40
      mode: qrgvalues['qrg-qrmode'] || "", // "Numeric" "Alphanumeric" "Byte" "Kanji"
      errorCorrectionLevel: qrgvalues['qrg-qrerror'] || "Q" // "L" "M" "Q" "H"
    },
    imageOptions: {
      hideBackgroundDots: qrgvalues['qrg-imgbgdot'] || true, // boolean
      imageSize: qrgvalues['qrg-imgsize'] || 0.4,
      margin: qrgvalues['qrg-imgmargin'] || 20,
      crossOrigin: "anonymous", // "anonymous" "use-credentials"
      saveAsBlob: false // boolean
    },
    dotsOptions: {
      color: qrgvalues['qrg-dotscolor'] || "#000",
      gradient: "",
      type: qrgvalues['qrg-dotstype'].toLowerCase() || "square", // 'rounded' 'dots' 'classy' 'classy-rounded' 'square' 'extra-rounded'
      roundSize: true // boolean
    },
    backgroundOptions: {
      color: qrgvalues['qrg-bgcolor'] || "#e9ebee",
      gradient: ''
    },
    cornersSquareOptions: {
      color: qrgvalues['qrg-cscolor'] || "",
      gradient: "",
      type: qrgvalues['qrg-cstype'].toLowerCase() || "" // 'dot' 'square' 'extra-rounded'
    },
    cornersDotOptions: {
      color: qrgvalues['qrg-cdcolor'] || "",
      gradient: "",
      type: qrgvalues['qrg-cdtype'].toLowerCase() || "" // 'dot' 'square' 'extra-rounded'
    }
  });
  document.getElementById('qrg-canvas').innerHTML = "";
  qrCode.append(document.getElementById('qrg-canvas'));

  downloadQR = function() {
    let filename = document.getElementById('qrg-filename').value || "QR by Kode Jarwo";
    let fileextension = document.getElementById('qrg-fileextension').value.toLowerCase() || "png";
    qrCode.download({
        name: filename,
        extension: fileextension // 'png' 'jpeg' 'webp' 'svg'
    });
  };
  
};

generateQR();

