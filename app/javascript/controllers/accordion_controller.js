import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["item"]

  toggle(event) {
    event.preventDefault()
    const details = event.currentTarget.closest("details")
    const isOpen = details.hasAttribute("open")

    // Ferme tous les items
    this.itemTargets.forEach(item => item.removeAttribute("open"))

    // Ouvre celui cliqué (sauf s'il était déjà ouvert)
    if (!isOpen) {
      details.setAttribute("open", "")
    }
  }
}
