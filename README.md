# I18nViz

[![Build Status](https://secure.travis-ci.org/jhilden/i18n_viz.png?branch=master)](http://travis-ci.org/jhilden/i18n_viz)

Gem to visualize i18n strings within a rails project.

**Problem**:

For non-developers (e.g. translators and product managers) working with i18n Rails apps, it's very difficult to make the connection from a string within the app to the correct i18n key to edit the corresponding translation.

**Solution**:

Hack the i18n keys into the frontend, so that the keys can be displayed as nice overlay tooltip right within the app.

If you you use a translation management app, such as http://webtranslateit.com, you get the additional benefit of clickable links that point you right to the correct string to edit within the translation tool.



## Requirements

i18n_viz.js currentyl depends on jQuery being alread loaded in your app.  Tested with jQuery 1.6.1

## Installation

##### 1. Install the gem

Add the following line to your Gemfile

    gem 'i18n_viz', :git =>'git://github.com/jhilden/i18n_viz.git'

And run

    bundle install


##### 2. Run install generator

    rails generate i18n_viz:install

This will copy the required assets (i18n_viz.js, i18n_viz.css) to your public directory and create a new initializer in your rails app.


##### 3. Include assets

For example like this in your app's layout:

    - if display_i18n_viz?
      = stylesheet_link_tag("i18n_viz")
      = javascript_tag "var i18n_viz_key_url = '#{I18nViz.key_url}';"
      = javascript_include_tag "i18n_viz"


## How it works

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


## Gotchas

#### `--key--` breaks app (variable assignment)

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




### License

This project is under MIT-LICENSE.
