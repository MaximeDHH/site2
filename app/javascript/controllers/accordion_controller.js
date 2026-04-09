import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["header", "body"]

  toggle(event) {
    const header = event.currentTarget
    const index  = this.headerTargets.indexOf(header)
    const body   = this.bodyTargets[index]
    const isOpen = header.classList.contains("is-open")

    // ferme tout
    this.headerTargets.forEach(h => h.classList.remove("is-open"))
    this.bodyTargets.forEach(b => b.classList.remove("is-open"))

    // ouvre celui cliqué (sauf s'il était déjà ouvert)
    if (!isOpen) {
      header.classList.add("is-open")
      body.classList.add("is-open")
    }
  }
}
