const headerOffset = 5.75 * 16; // 6rem dalam piksel (16px adalah ukuran font dasar)

document.querySelectorAll('[data-scroll]').forEach(anchor => {
    anchor.addEventListener('click', function(e) {
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