# I18nViz

[![Build Status](https://secure.travis-ci.org/jhilden/i18n_viz.png?branch=master)](http://travis-ci.org/jhilden/i18n_viz)

Gem to visualize i18n strings within anay rails/ruby project using the commonly used [i18n](https://github.com/svenfuchs/i18n) gem.

**Problem**:

It is very difficult for non-developers (e.g. translators and product managers) working with i18n Rails apps to make the connection from a string within the app to the correct i18n key to edit the corresponding translation.  "I would like to tweak the wording of the subtitle on this page, what string do I need to edit?"

**Solution**:

My solution is to hack the i18n keys into the frontend, so that the keys can be displayed as nice overlay tooltips on top of their strings right within the app.

If you you use a translation management service, such as http://webtranslateit.com, https://lingohub.com, http://localeapp.com/, you get the additional benefit of clickable links that point you right to the correct string to edit within your translation tool.


## Requirements

* [i18n](https://github.com/svenfuchs/i18n) gem
* jQuery
* Rails 3.1+
* CoffeeScript

However, with just a little bit of manual work, you should be able to get the whole thing to run without Rails and CoffeeScript.  Just let me know if you need help.

## Installation

##### 1. Install the gem

Add the following line to your `Gemfile` and run `bundle install`:

    gem 'i18n_viz'

##### 2. Include the assets

You need to include the JavaScript (CoffeeScript) and CSS assets in your app in the environment where you want to use the gem.  There are several ways to do it.  Here I describe two ways of doing it with the Rails asset pipeline:

Either you can simply require the assets in your manifest files:

`app/assets/javascripts/application.js`:

    // = require i18n_viz
    
    
`app/assets/stylesheets/application.css`:

    /* = require i18n_viz.css */
    
Or, if you don't want use the gem in production mode (which does makes some sense), you can turn your manifest files into ERB templates by adding the `.erb` file extension and only include the assets in non-production environments:


`app/assets/javascripts/application.js.erb`:

    <% require_asset "i18n_viz"  unless Rails.env.production? %>

`app/assets/stylesheets/application.css.erb`:

    <% require_asset "i18n_viz"  unless Rails.env.production? %>


!**Gotcha**:  You need to leave a blank line between your asset pipeline directives (`// require`, `// require_tree`, ...) and the erb line above, otherwise it will NOT work!


#### 3. Create an initializer (optional)

In order to provide some custom setting for the I18nViz gem, it might make sense to create an initializer.

E.g. `config/initializers/i18n_viz.rb`:

    # encoding: utf-8
    unless defined?(I18nViz).nil?
      # determine under which condition the gem should be active (e.g. only in non-production environments)
      I18nViz.enabled = !Rails.env.production?
        
      # Link to display in the I18nViz tooltip
      # e.g. pointing to that particular string in your apps translation tool (webtranslateit.com, localeapp.com, ...)
      # the i18n key will be appended to this URL
      I18nViz.external_tool_url = "https://webtranslateit.com/en/projects/1234567/locales/en..de/strings?utf8=✓&s="
    end

#### 4. Browse to http://localhost:3000?i18n_viz=true

Add the `i18n_viz=true` parameter to visualize the translatable segments.



## How it works

The gem works by overwriting the `t()` and `translate()` helpers in your rails app to add the key of the i18n string after the actual translated content:

    en:
      examples:
        my_string: "My internationalized string"
        foo: "bar"
        
    %span= "#{t("examples.my_string")} : #{t("examples.foo")}" 
    
Will result in

    <span>My internationalized string--examples.my_string-- : bar--examples.foo--</span>
    
The i18n_viz Javascript then parses this and enriches it into:

    <span class="i18n-viz" data-i18nKeys="['examples.my_string', 'examples.foo']">My internationalized string : bar</span>
    
The so enriched elements then get nice little tooltips attached with the i18n keys and possibly links to where they can be found/changed.

#### Translations with :scope option
  
Sometimes you don't want to manualy add scope to each of you translations in view template, and just pass scope. 
    
    t('contact', :scope => :menu) results with 'menu.contact' key. 

This gem will correctly read this key and display 'menu.contact' in the tooltip. 

## Gotchas & Limitations

#### Works only in the view layer

The keys will currently only work for strings that are translated in the view layer using the `translate()` and `t()` i18n view helpers.  If you translate a string the model layer using `I18n.translate` method directly (e.g. in ActiveRecord validations) the keys are not displayed in the frontend.


#### Disable i18n_viz if you require certain strings to remain untouched

For certain special strings within your app, the added `--key--` could potentially break your custom logic.  For those cases you need to call the `t()` method the additional `i18n_viz: false` parameter.

Example cases include:

**Iterating overy keys**

    de:
      types:
        foo: "Foo"
        bar: "Bar"

    - t("types").each do |key, string|
        .. do something wit the key ..

**JS data-attributes**

    de:
      date:
        js_format: "dd.mm.yyyy"
        

    %body{:"data-date-format" => t("date.js_format")}
    
Will result in this broken output:

    <body data-date-format="dd.mm.yyyy--date.js_format--">


## Thanks

Big thanks to my employer [Railslove](http://railslove.com) for supporting my open source work and to everybody who helped me.


## License

This project is under MIT-LICENSE.
