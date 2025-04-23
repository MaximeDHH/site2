import { Application } from "@hotwired/stimulus"

const application = Application.start()

// Configure Stimulus development experience
application.debug = false
window.Stimulus   = application

export { application }


const title = document.querySelector(".section-title");
observer.observe(title);

// Dans le callback du même IntersectionObserver :
if (entry.isIntersecting) {
  section.classList.add("visible");
  title.classList.add("visible");
}
