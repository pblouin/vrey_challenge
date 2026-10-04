import { Controller } from "@hotwired/stimulus"
import "chart.js"

const Chart = window.Chart
Chart.defaults.font.family = "Inter"

export default class extends Controller {
  static values = { data: Object }

  connect() {
    const canvas = document.createElement("canvas")
    canvas.id = "consumption-chart"
    canvas.dataset.turboPermanent = ""
    this.element.replaceChildren(canvas)

    this.chart = new Chart(canvas, {
      type: "bar",
      data: this.dataValue,
      options: {
        maintainAspectRatio: false,
        datasets: { bar: { borderRadius: 4 } },
        scales: {
          x: { stacked: true, grid: { display: false }, ticks: { maxRotation: 0, autoSkip: this.skipLabels(), autoSkipPadding: 12 } },
          y: { stacked: true, beginAtZero: true }
        },
        plugins: {
          legend: { position: "bottom", labels: { usePointStyle: true } }
        }
      }
    })
  }

  dataValueChanged() {
    if (!this.chart) return

    this.chart.data.labels = this.dataValue.labels
    this.dataValue.datasets.forEach((dataset, index) => {
      this.chart.data.datasets[index] = Object.assign(this.chart.data.datasets[index] || {}, dataset)
    })
    this.chart.data.datasets.length = this.dataValue.datasets.length
    this.chart.options.scales.x.ticks.autoSkip = this.skipLabels()
    this.chart.update()
  }

  skipLabels() {
    const tooManyLabels = this.dataValue.labels.length > 31
    const narrowScreen = this.element.clientWidth < 600

    return tooManyLabels || narrowScreen
  }

  disconnect() {
    this.chart?.destroy()
  }
}
