class I18nVizTooltip {
  constructor () {
    this.element = document.createElement('div')
    this.element.className = 'i18n_viz_tooltip'
    this.hide()
    
    document.body.appendChild(this.element)
  }

  moveTo (elementPosition) {
    var top = elementPosition.top - this.element.offsetHeight
    if (top < 0) {
      top = elementPosition.top + elementPosition.height + 10
    }
    this.element.style.top = parseInt(top, 10).toString()+'px'
    this.element.style.left = parseInt(elementPosition.left, 10).toString()+'px'
  } 

  setI18nKeys (i18nKeys) {
    this.i18nKeys = i18nKeys
  }

  show () {
    this._clearContent()
    this._renderContent()
    this.element.style.display = 'block'
  }

  hide () {
    this.element.style.display = 'none'
  }

  _clearContent () {
    this.element.innerHTML = ''
  }

  _renderContent () {
    this.i18nKeys.forEach((key) => {
      var keyElement
      if (window.I18nViz.external_tool_url) {
        keyElement = document.createElement('a')
        keyElement.setAttribute('href', window.I18nViz.external_tool_url + key)
        keyElement.setAttribute('target', '_blank')
      } else {
        keyElement = document.createElement('span')
      }
      keyElement.textContent = key
      this.element.appendChild(keyElement)
    })
  }
}

class I18nVizElement {
  constructor (element, options) {
    this.element = element
    this.matchesIn = options.matchesIn
    this.tooltip = window.I18nViz.tooltip
    this.i18nKeys = this._extractI18nKeys()
    this._handleMouseEnter = this._handleMouseEnter.bind(this)
    this._style()
    this.element.addEventListener('mouseenter', this._handleMouseEnter)
  }

  _style () {
    this.element.className = [this.element.className, 'i18n-viz'].join(' ')
  }

  _dimensions () {
    var rect = this.element.getBoundingClientRect()
    return {
      top: rect.top,
      left: rect.left,
      height: this.element.offsetHeight
    }
  }

  _handleMouseEnter (event) {    
    this.tooltip.setI18nKeys(this.i18nKeys)
    this.tooltip.moveTo(this._dimensions())
    this.tooltip.show()
  }

  _elementText () {
    if (this.type === 'input') {
      return this.element.value + this.element.getAttribute('placeholder')
    } else {
      return this.element.textContent 
    }     
  }

  // receives text and returns extracted i18n keys as array
  _extractI18nKeys () {
    let keys = this._elementText().match(window.I18nViz.global_regex)
    if (keys) {
      keys.forEach(function(value, index) {
        return keys[index] = value.replace(/--/g, "")
      })
      return keys
    } else {
      return null
    }
  }

  _clear () {
    if (this.type === 'input') {
      this.element.value = this._replaceI18nTextIn(this.element.value)
      this.element.setAttribute('placeholder', this._replaceI18nTextIn(this.element.getAttribute('placeholder')))
  }

  _replaceI18nTextIn (text) {
    return text.replace(window.I18nViz.global_regex, '')
  }
}

class I18nVizInitializer {
  constructor () {
    this.elements = []
    this.instances = []
  }

  init () {
    var elements = document.body.getElementsByTagName('*')

    for (var i = 0; i < elements.length; ++i) {
      const matchesIn = {
        value: window.I18nViz.regex.test(elements[i].value),
        placeholder: window.I18nViz.regex.test(elements[i].getAttribute('placeholder')),
        textContent: window.I18nViz.regex.test(elements[i].textContent)
      }

      // reduce?
      let matchesArray = []
      matchesIn.forEach((key, value) => { matchesArray.push(key) })

      if (any(matchesArray)) {
        this.elements.push(elements[i])
        this.instances.push(new I18nVizElement(element, {matchesIn: matchesArray}))
      }
    }
  }

  clearAllI18nText () {
    var textNodesIterator = document.createNodeIterator(
      document.body,
      NodeFilter.SHOW_TEXT // Only consider nodes that are text nodes (nodeType 3)
    )
    var currentNode
    while (currentNode = textNodesIterator.nextNode()) {
      currentNode.textContent = currentNode.textContent.replace(window.I18nViz.global_regex, '')
    }
  }
}

document.addEventListener('DOMContentLoaded', (_event) => {
  window.I18nViz.tooltip = new I18nVizTooltip
  const initializer = new I18nVizInitializer
  initializer.init()
  window.I18nViz.initializer = initializer
})
