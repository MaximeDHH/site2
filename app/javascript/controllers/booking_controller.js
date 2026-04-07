import { Controller } from "@hotwired/stimulus"

const PRICES = {
  "Manucure classique": 25,
  "Pose en gel": 45,
  "Nail art": 55,
  "Soin des mains": 35
}

export default class extends Controller {
  static targets = ["service", "date", "timeSlot", "priceDisplay"]

  connect() {
    this.updatePrice()
  }

  updatePrice() {
    const service = this.serviceTarget.value
    const price   = PRICES[service]
    if (price && this.hasPriceDisplayTarget) {
      this.priceDisplayTarget.innerHTML =
        `<span class="price-tag"><i class="fa-solid fa-tag"></i> ${price} €</span>`
    } else if (this.hasPriceDisplayTarget) {
      this.priceDisplayTarget.innerHTML = ""
    }
  }

  async loadSlots() {
    const date = this.dateTarget.value
    if (!date) return

    const slotSelect = this.timeSlotTarget
    slotSelect.innerHTML = '<option value="">Chargement...</option>'

    try {
      const res  = await fetch(`/booking/slots?date=${date}`)
      const data = await res.json()

      if (data.available.length === 0) {
        slotSelect.innerHTML = '<option value="">Aucun créneau disponible ce jour</option>'
        slotSelect.disabled = true
      } else {
        slotSelect.innerHTML = '<option value="">Choisissez un créneau</option>'
        data.available.forEach(slot => {
          const opt = document.createElement("option")
          opt.value = slot
          opt.textContent = slot
          slotSelect.appendChild(opt)
        })
        slotSelect.disabled = false
      }
    } catch {
      slotSelect.innerHTML = '<option value="">Erreur, réessayez</option>'
      slotSelect.disabled = false
    }
  }
}
