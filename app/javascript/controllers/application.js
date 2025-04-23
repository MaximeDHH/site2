import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }

document.addEventListener("scroll", () => {
  const header = document.querySelector("header");

  // Si on a scrollé un peu (plus que 0px), on ajoute la classe 'scrolled'
  if (window.scrollY > 0) {
    header.classList.add("scrolled");
    header.classList.remove("transparent");
  } else {
    header.classList.remove("scrolled");
    header.classList.add("transparent");
  }
});

const title = document.querySelector(".section-title");
observer.observe(title);

// Dans le callback du même IntersectionObserver :
if (entry.isIntersecting) {
  section.classList.add("visible");
  title.classList.add("visible");
}
