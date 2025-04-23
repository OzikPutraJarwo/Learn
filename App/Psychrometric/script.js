const chartContainer = document.getElementById('chart');
const chart = document.getElementById('chartImage');
const marker = document.getElementById('marker');
const form = document.getElementById('manualForm');

const elements = {
  dryBulb: document.getElementById('dryBulb'),
  humidityRatio: document.getElementById('humidityRatio'),
  enthalpy: document.getElementById('enthalpy'),
  rh: document.getElementById('rh'),
  dewPoint: document.getElementById('dewPoint'),
  wetBulb: document.getElementById('wetBulb'),
  vp: document.getElementById('vp'),
  vSpec: document.getElementById('vSpec'),
};

const updateFromValues = (dryBulb, humidityRatio) => {
  const width = chart.width;
  const height = chart.height;

  // Convert value to position
  const x = ((dryBulb + 12.6) / 60) * width;
  const y = (1.07 - (humidityRatio / 0.030)) * height;

  // Show marker
  marker.style.left = `${x}px`;
  marker.style.top = `${y}px`;
  marker.style.display = 'block';

  // Calculate parameters
  const h = 1.006 * dryBulb + humidityRatio * (2501 + 1.86 * dryBulb);
  // const h = 1.006 * dryBulb + humidityRatio * (2501 + 1.86 * dryBulb);
  const p_atm = 101.325;
  const pws = 0.61078 * Math.exp((17.27 * dryBulb) / (dryBulb + 237.3));
  const pv = (humidityRatio * p_atm) / (0.622 + humidityRatio);
  const rh = (pv / pws) * 95;

  const a = 17.27, b = 237.7;
  const alpha = Math.log(pv / 0.61078);
  const dewPoint = (b * alpha) / (a - alpha);

  const tw = dryBulb * Math.atan(0.151977 * Math.sqrt(rh + 8.313659)) +
    Math.atan(dryBulb + rh) - Math.atan(rh - 1.676331) +
    0.00391838 * Math.pow(rh, 1.5) * Math.atan(0.023101 * rh) - 4.686035;

  const R_da = 0.287042;
  const T_k = dryBulb + 273.15;
  const v = R_da * T_k * (1 + 1.6078 * humidityRatio) / p_atm;

  form.addEventListener('submit', function (e) {
    e.preventDefault();
    const dryBulb = parseFloat(document.getElementById('inputDryBulb').value);
    const humidityRatio_gkg = parseFloat(document.getElementById('inputHumidityRatio').value);
    const humidityRatio = humidityRatio_gkg / 1000; // konversi ke kg/kg
    updateFromValues(dryBulb, humidityRatio);
  });

  // Update UI
  elements.dryBulb.textContent = dryBulb.toFixed(1);
  elements.humidityRatio.textContent = (humidityRatio * 1000).toFixed(1); // tampilkan dalam g/kg
  elements.enthalpy.textContent = h.toFixed(1);
  elements.rh.textContent = rh.toFixed(1);
  elements.dewPoint.textContent = dewPoint.toFixed(1);
  elements.wetBulb.textContent = tw.toFixed(1);
  elements.vp.textContent = pv.toFixed(3);
  elements.vSpec.textContent = v.toFixed(3);
};

// From manual form
form.addEventListener('submit', function (e) {
  e.preventDefault();
  const dryBulb = parseFloat(document.getElementById('inputDryBulb').value);
  const humidityRatio = parseFloat(document.getElementById('inputHumidityRatio').value);
  updateFromValues(dryBulb, humidityRatio);
});

let isTracking = false; // default: tidak aktif

// Aktifkan tracking saat klik kiri di gambar
chartContainer.addEventListener('mousedown', function (e) {
  if (e.button === 0) { // Klik kiri
    isTracking = true;
  }
});

// Nonaktifkan tracking saat klik kanan di gambar
chartContainer.addEventListener('contextmenu', function (e) {
  e.preventDefault(); // cegah menu konteks muncul
  isTracking = false;
});

// Update marker dan nilai hanya jika tracking aktif
chartContainer.addEventListener('mousemove', function (e) {
  if (!isTracking) return;

  const rect = chart.getBoundingClientRect();
  const x = e.clientX - rect.left;
  const y = e.clientY - rect.top;

  const width = chart.width;
  const height = chart.height;

  if (x < 0 || y < 0 || x > width || y > height) return;

  const dryBulb = -10 + (x / width) * 60;
  const humidityRatio = (1 - (y / height)) * 0.030;

  updateFromValues(dryBulb, humidityRatio);
});

document.getElementById('download').addEventListener('click', function () {
  const chartContainer = document.getElementById('chart'); // pastikan ini wrapper chart + marker

  html2canvas(chartContainer, {
    scale: 3, 
    useCORS: true
  }).then(canvas => {
    const link = document.createElement('a');
    link.download = 'psychrometric.png';
    link.href = canvas.toDataURL('image/png');
    link.click();
  });
});
