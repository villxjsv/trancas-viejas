/**
 * TRANCAS VIEJAS - Archivo JavaScript Principal
 * Contiene la lógica del menú móvil accesible y el visor
 * de imágenes (lightbox) de la galería.
 */

document.addEventListener('DOMContentLoaded', () => {

    // ==========================================
    // 1. NAVEGACIÓN Y MENÚ MÓVIL ACCESIBLE
    // ==========================================
    const menuToggle = document.querySelector('.menu-toggle');
    const siteNav = document.querySelector('.site-nav');
    const navLinks = document.querySelectorAll('.nav-list a');

    if (menuToggle && siteNav) {
        /**
         * Alterna el estado del menú móvil y actualiza los atributos ARIA para lectores de pantalla.
         */
        const toggleMenu = () => {
            const isOpen = siteNav.classList.contains('is-open');

            if (isOpen) {
                siteNav.classList.remove('is-open');
                menuToggle.setAttribute('aria-expanded', 'false');
                menuToggle.setAttribute('aria-label', 'Mostrar menú');
            } else {
                siteNav.classList.add('is-open');
                menuToggle.setAttribute('aria-expanded', 'true');
                menuToggle.setAttribute('aria-label', 'Ocultar menú');
            }
        };

        // Evento de clic en el botón de hamburguesa
        menuToggle.addEventListener('click', toggleMenu);

        // Cierre del menú al seleccionar cualquier enlace de la lista
        navLinks.forEach(link => {
            link.addEventListener('click', () => {
                if (siteNav.classList.contains('is-open')) {
                    toggleMenu();
                }
            });
        });
    }

    // ==========================================
    // 2. LIGHTBOX (VISOR DE IMÁGENES DE LA GALERÍA)
    // ==========================================
    const galleryImages = Array.from(
        document.querySelectorAll('.gallery-card-image img')
    );

    if (galleryImages.length > 0) {

        // Creamos el visor una sola vez y lo añadimos al final del <body>.
        const lightbox = document.createElement('div');
        lightbox.className = 'lightbox';
        lightbox.setAttribute('role', 'dialog');
        lightbox.setAttribute('aria-modal', 'true');
        lightbox.setAttribute('aria-label', 'Visor de imágenes de la galería');
        lightbox.hidden = true;

        lightbox.innerHTML = `
            <button class="lightbox-close" type="button" aria-label="Cerrar">&times;</button>
            <button class="lightbox-prev" type="button" aria-label="Imagen anterior">&#10094;</button>
            <figure class="lightbox-figure">
                <img class="lightbox-img" alt="">
                <figcaption class="lightbox-caption"></figcaption>
            </figure>
            <button class="lightbox-next" type="button" aria-label="Imagen siguiente">&#10095;</button>
        `;

        document.body.appendChild(lightbox);

        const lbImg = lightbox.querySelector('.lightbox-img');
        const lbCaption = lightbox.querySelector('.lightbox-caption');
        const closeBtn = lightbox.querySelector('.lightbox-close');
        const prevBtn = lightbox.querySelector('.lightbox-prev');
        const nextBtn = lightbox.querySelector('.lightbox-next');

        let currentIndex = 0;
        let lastFocused = null;
        let closeTimer = null;

        const show = (index) => {
            currentIndex = (index + galleryImages.length) % galleryImages.length;

            const source = galleryImages[currentIndex];
            lbImg.src = source.currentSrc || source.src;
            lbImg.alt = source.alt || '';

            lbCaption.textContent = source.alt || '';

            const single = galleryImages.length < 2;
            prevBtn.hidden = single;
            nextBtn.hidden = single;
        };

        const open = (index, trigger) => {
            lastFocused = trigger || null;

            if (closeTimer) {
                window.clearTimeout(closeTimer);
                closeTimer = null;
            }

            show(index);

            lightbox.hidden = false;
            requestAnimationFrame(() => lightbox.classList.add('is-open'));

            document.body.style.overflow = 'hidden';
            closeBtn.focus();
        };

        const close = () => {
            lightbox.classList.remove('is-open');
            document.body.style.overflow = '';

            closeTimer = window.setTimeout(() => {
                lightbox.hidden = true;
                lbImg.removeAttribute('src');
            }, 220);

            if (lastFocused) {
                lastFocused.focus();
            }
        };

        // Hacemos cada foto de la galería "ampliable" (ratón y teclado).
        galleryImages.forEach((img, index) => {
            img.classList.add('is-zoomable');
            img.setAttribute('tabindex', '0');
            img.setAttribute('role', 'button');
            img.setAttribute('aria-label', 'Ampliar imagen: ' + (img.alt || ''));

            img.addEventListener('click', () => open(index, img));
            img.addEventListener('keydown', (e) => {
                if (e.key === 'Enter' || e.key === ' ') {
                    e.preventDefault();
                    open(index, img);
                }
            });
        });

        closeBtn.addEventListener('click', close);
        prevBtn.addEventListener('click', () => show(currentIndex - 1));
        nextBtn.addEventListener('click', () => show(currentIndex + 1));

        // Clic en el fondo (fuera de la foto) para cerrar.
        lightbox.addEventListener('click', (e) => {
            if (e.target === lightbox || e.target.classList.contains('lightbox-figure')) {
                close();
            }
        });

        // Teclado: Escape cierra, flechas navegan.
        document.addEventListener('keydown', (e) => {
            if (lightbox.hidden) return;

            if (e.key === 'Escape') {
                close();
            } else if (e.key === 'ArrowLeft') {
                show(currentIndex - 1);
            } else if (e.key === 'ArrowRight') {
                show(currentIndex + 1);
            }
        });
    }

});
