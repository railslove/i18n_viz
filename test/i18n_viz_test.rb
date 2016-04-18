# encoding: utf-8
require 'test_helper'

class I18nVizIntegrationTest < ActionDispatch::IntegrationTest
  test 'translate without i18n_viz url parameter' do
    visit "/test"

    assert !page.has_content?("--hello--")
    assert !page.has_css?("#i18n_viz_tooltip")
    assert !page.has_selector?("body > script", visible: false)
    assert !page.has_selector?("body > style", visible: false)
  end

  test 'translate with i18n_viz url parameter' do
    visit "/test?i18n_viz=1"

    assert page.has_selector? "body > script", visible: false
    assert page.has_selector?("body > style", visible: false)
    assert page.has_content?("--hello--")
    assert !page.has_css?(".i18n-viz")
    assert !page.has_css?("#i18n_viz_tooltip")

    assert page.has_content?("bar")
    assert !page.has_content?("--foo--")

    assert page.has_content?("foo")
  end

  test 'translate with i18n_viz as a cookie' do
    page.driver.browser.set_cookie("i18n_viz=true")

    visit "/test"

    assert page.has_selector? "body > script", visible: false
    assert page.has_selector?("body > style", visible: false)
    assert page.has_content?("--hello--")
    assert !page.has_css?(".i18n-viz")
    assert !page.has_css?("#i18n_viz_tooltip")

    assert page.has_content?("bar")
    assert !page.has_content?("--foo--")

    assert page.has_content?("foo")
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

    assert !page.has_content?("--hello--") # should be removed by js
    assert page.has_css?(".i18n-viz")

    first('.i18n-viz').hover

    assert page.has_link?('hello', :href => "https://webtranslateit.com/en/projects/xxx/locales/en..de/strings?utf8=✓&s=hello")
    assert page.has_css?("#i18n_viz_tooltip")
  end
end

class I18nVizDynamicUrlTest < ActionDispatch::IntegrationTest
  setup do
    Capybara.current_driver = Capybara.javascript_driver # :selenium by default

    # monkey patch external_tool_url
    I18nViz::Middleware.class_eval do
      alias orig_external_tool_url external_tool_url
      def external_tool_url
        lambda { |e|
            locale = e['action_dispatch.request.parameters']['locale'] || I18n.default_locale
            "http://example.com/#{locale}/?s="
        }
      end
    end
  end

  teardown do
    # revert monkey patch
    I18nViz::Middleware.class_eval do
      alias external_tool_url orig_external_tool_url
    end
  end

  test 'dynamic external url with English locale' do
    visit "/test?i18n_viz=1"

    assert page.has_css?(".i18n-viz")
    first('.i18n-viz').hover

    assert page.has_link?('hello', :href => "http://example.com/en/?s=hello")
  end

  test 'dynamic external url with Bulgarian locale' do
    visit "/test?i18n_viz=1&locale=bg"

    assert page.has_css?(".i18n-viz")
    first('.i18n-viz').hover

    assert page.has_link?('hello', :href => "http://example.com/bg/?s=hello")
  end
end
