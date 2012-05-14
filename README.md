# I18nViz

[![Build Status](https://secure.travis-ci.org/jhilden/i18n_viz.png?branch=master)](http://travis-ci.org/jhilden/i18n_viz)

Gem to visualize i18n strings within a rails/ruby project.

**Problem**:

It is ver difficult for non-developers (e.g. translators and product managers) working with i18n Rails apps to make the connection from a string within the app to the correct i18n key to edit the corresponding translation.  "I would like to tweak the wording of the subtitle on this page, what string do I need to edit?"

**Solution**:

My solution is to hack the i18n keys into the frontend, so that the keys can be displayed as nice overlay tooltips on top of their strings right within the app.

If you you use a translation management app, such as http://webtranslateit.com, you get the additional benefit of clickable links that point you right to the correct string to edit within the translation tool.

More features (like inline editing) are possible in the future.



## Requirements


* i18n gem
* jQuery (tested with 1.6.x and 1.7.x)
* Rails 3.1+
* CoffeeScript

However, with a little bit of manual work, you should be able to get the whole thing to run without Rails and CoffeeScript.  Just let me know if you need help.

## Installation

##### 1. Install the gem

Add the fullowing line to your `Gemfile` and run `bundle install`:


##### 2. Include the assets

You need to include the JavaScript(CoffeeScript) and CSS assets in your app in the environment where you want to use the gem.  There are several ways to do it.  Here I describe two ways of doing it with the Rails asset pipeline:

Either you can simply require the assets in your manifest files:

`app/assets/javascripts/application.js`:

    // = require i18n_viz
    
    
`app/assets/stylesheets/application.css`:

    /* = require i18n_viz.css */
    
Or, if you don't want use the gem in production mode (which makes lots of sense), you can turn your manifest files into ERB templates by adding the `.erb` file extension and only include the assets in non-production environments:


`app/assets/javascripts/application.js.erb`:

    <% require_asset "i18n_viz"  unless Rails.env.production? %>

`app/assets/stylesheets/application.css.erb`:

    <% require_asset "i18n_viz"  unless Rails.env.production? %>


!**Gotcha**:  You need to leave a blank line between your asset pipeline directives (`// require`, `// require_tree`, ...) and the erb line above, otherwise it will NOT work!


If you are not using the asset pipeline, you will need to manually copy over the assets.


#### 3. Create initializer (optional)

In order to provide some custom setting for the I18nViz gem, it might make sense to create and initializer.

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


# How it works

The gem works by overwriting the t() and translate() helpers in your rails app to add the key of the i18n string after the actual translated content:

    en:
      examples:
        my_string: "My internationalized string"
        foo: "bar"
        
    =%span= "#{t("examples.my_string")} : #{t("examples.foo")}" 
    
Will result in

    <span>My internationalized string--examples.my_string-- : bar--examples.foo--</span>
    
The i18n_viz Javascript then parses this and enriches it into:

    <span class="i18n-viz" data-i18nKeys="['examples.my_string', 'examples.foo']">My internationalized string : bar</span>
    
The so enriched elements then get nice little tooltips attached with the i18n keys and possibly links to where they can be found/changed.


## Gotchas & Limitations

#### Works only in the view layer

The keys will currently only work for strings that are translated in the view layer using the `translate()` and `t()` i18n view helpers.  If you translate a string the model layer using `I18n.translate` method directly (e.g. ActiveRecord validations) the keys are not displayed in the frontend.


#### Assigning I18n output to variables

If you should be assigning i18n output directly into variables (e.g. within inline javascript, JS data-attributes, or other variables), the whole `--key--` thing might actually break your application.

For example this usage of a data-attribute:

    de:
      date:
        js_format: "dd.mm.yyyy"
        

    %body{:"data-date-format" => t("date.js_format")}
    
Will result in this broken output:

    <body data-date-format="dd.mm.yyyy--date.js_format--">

In those cases you need to pass an additional parameter `:i18n_viz => false` to the translate method in order to not append the key.

Example:

    %body{:"data-date-format" => t("date.js_format", :i18n_viz => false)}
    
    -----
    
    <body data-date-format="dd.mm.yyyy">


# Thanks

Big thanks to my employer [Railslove](http://railslove.com) for supporting my open source work and to everybody who helped me.


### License

This project is under MIT-LICENSE.
