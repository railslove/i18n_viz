require 'test_helper'

# capybara
class I18nVizIntegrationTest < ActionDispatch::IntegrationTest
  test 'translate without i18n_viz url parameter' do
    visit "/test"
    
    assert !page.has_content?("--hello--")
    assert !page.has_css?("#i18n_viz_tooltip")
  end

  test 'translate with i18n_viz url parameter' do
    visit "/test?i18n_viz=1"

    assert page.has_content?("--hello--")
    assert !page.has_css?(".i18n-viz")
    assert !page.has_css?("#i18n_viz_tooltip")
  end
end

class I18nVizJavascriptIntegrationTest < ActionDispatch::IntegrationTest
  setup do
    Capybara.current_driver = Capybara.javascript_driver # :selenium by default
  end

  test 'translate without i18n_viz url parameter' do
    visit "/test"

    assert !page.has_content?("--hello--")
    assert !page.has_css?(".i18n-viz")
  end

  test 'translate with i18n_viz url parameter' do
    visit "/test?i18n_viz=1"
    
    assert !page.has_content?("--hello--") # removed by js
    assert page.has_css?(".i18n-viz")
    assert page.has_css?("#i18n_viz_tooltip")
  end
end

    