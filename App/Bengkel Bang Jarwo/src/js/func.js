const headerOffset = 5.75 * 16; // 6rem dalam piksel (16px adalah ukuran font dasar)

document.querySelectorAll('[data-scroll]').forEach(anchor => {
    anchor.addEventListener('click', function (e) {
        e.preventDefault();
        const targetId = this.getAttribute('data-scroll');
        const targetElement = document.querySelector(targetId);
        const elementPosition = targetElement.getBoundingClientRect().top + window.pageYOffset;
        const offsetPosition = elementPosition - headerOffset;

        window.scrollTo({
            top: offsetPosition,
            behavior: 'smooth'
        });
    });
});

document.querySelector('#order .kirim-pesan').addEventListener('click', function () {
    var nama = encodeURIComponent(document.querySelector('#order input').value);
    var pesan = encodeURIComponent(document.querySelector('#order textarea').value);
    window.open('https://api.whatsapp.com/send?phone=6285654141926&text=Halo%20Bang%20Jarwo,%20saya%20' + nama + '%20ingin%20bertanya.%0A%0A' + pesan + '%0A%0ATerima%20kasih.');
});