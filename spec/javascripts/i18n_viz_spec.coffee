require "/application.js"

describe "extractI18nKeysFromText()", () ->

  it "should return i18n key when 1 present", () ->
    expect(window.I18nViz.extractI18nKeysFromText("some text --i18n.key--")).toEqual(["i18n.key"])

  it "should return null with no keys present", () ->
    expect(window.I18nViz.extractI18nKeysFromText("some text --i18n.key-- more text --another.key-- end")).toEqual(["i18n.key", "another.key"])

  it "should return null with no keys present", () ->
    expect(window.I18nViz.extractI18nKeysFromText("some regular test with two dashes -- in the middle")).toBeNull()

describe "jQuery extensions", () ->
  $jquery_element = null

  describe "with i18n jQuery element", () ->
    beforeEach () ->
      $jquery_element = $("<div>some text --i18n.key--</div>")

    describe "$.fn.clearI18nText()", () ->
      it "should clear i18n keys from textnode", () ->
        $jquery_element.clearI18nText()
        expect($jquery_element.text()).toEqual("some text ")

    describe "$.fn.enrichWithI18nData()", () ->
      it "should enrich element with i18n data", () ->
        $jquery_element.enrichWithI18nData()
        expect($jquery_element.hasClass("i18n-viz")).toBeTruthy()
        expect($jquery_element.data("i18n-keys")).toEqual(["i18n.key"])

  describe "with non-i18n jQuery element", () ->
    beforeEach () ->
      $jquery_element = $("<div>some text</div>")

    describe "$.fn.clearI18nText()", () ->
      it "should not change anything", () ->
        text_before = $jquery_element.text()
        $jquery_element.clearI18nText()
        expect($jquery_element.text()).toEqual(text_before)

    describe "$.fn.enrichWithI18nData()", () ->
      it "should not enrich element with i18n data", () ->
        $jquery_element.enrichWithI18nData()
        expect($jquery_element.hasClass("i18n-viz")).toBeFalsy()
        expect($jquery_element.data("i18n-keys")).toBeUndefined()
