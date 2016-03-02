# These helper methods can be called in your template to set variables to be used in the layout
# This module should be included in all views globally,
# to do so you may need to add this line to your ApplicationController
#   helper :layout
module LayoutHelper
  def title(page_title, show_title = true)
    content_for(:title) { h(page_title.to_s) }
    @show_title = show_title
  end

  def meta_description(description)
    content_for(:description) { h(description.to_s) }
  end

  def show_title?
    @show_title
  end

  def stylesheet(*args)
    content_for(:head) { stylesheet_link_tag(*args) }
  end

  def javascript(*args)
    content_for(:head) { javascript_include_tag(*args) }
  end

  def content_nav(template = nil)
    template = @content_nav_template if template.nil? && !@content_nav_template.nil?
    content_for(:content_nav) { render template.to_s rescue nil } if template && !content_for?(:content_nav)
  end

  def copyright_author
    @copyright_author ||= 'K&R Software, LLC.'
  end

  def copyright_year
    @copyright_year ||= begin
      start_year = 2012
      start_year.tap do |year|
        year.to_s << '-' << Time.zone.now.year.to_s if Time.zone.now.year > year
      end
    end
  end
end
