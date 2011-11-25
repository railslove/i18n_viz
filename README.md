# I18nViz

Gem to visualize i18n strings within a rails project.

More description coming soon ...

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

### License

This project is under MIT-LICENSE.
