import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["tab", "panel"]

  connect() {
    this.showPanel(0)
  }

  switch(event) {
    const index = this.tabTargets.indexOf(event.currentTarget)
    this.showPanel(index)
  }

  showPanel(index) {
    this.tabTargets.forEach((tab, i) => {
      tab.classList.toggle("is-active", i === index)
    })
    this.panelTargets.forEach((panel, i) => {
      panel.hidden = i !== index
    })
  }
}
