/**
 * TRANCAS VIEJAS - Archivo JavaScript Principal
 * Contiene la lógica del menú móvil accesible y la prevención del envío del formulario de contacto.
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

        // Accesibilidad: Cierre del menú mediante la tecla Escape
        document.addEventListener('keydown', (e) => {
            if (e.key === 'Escape' && siteNav.classList.contains('is-open')) {
                toggleMenu();
                menuToggle.focus(); // Retorna el foco al botón de menú para usuarios de teclado
            }
        });
    }

    // ==========================================
    // 2. FORMULARIO DE CONTACTO (MANEJO VISUAL)
    // ==========================================
    const contactForm = document.getElementById('contact-form');
    
    if (contactForm) {
        contactForm.addEventListener('submit', (e) => {
            e.preventDefault();
        });
    }

});