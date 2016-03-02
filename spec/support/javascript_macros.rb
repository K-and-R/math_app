module JavascriptMacros

  def accept_js_confirm
    if page.driver.browser.respond_to?(:switch_to)
      page.driver.browser.switch_to.alert.accept
    elsif page.driver.browser.respond_to?(:accept_js_confirms)
      sleep 1 # prevent test from failing by waiting for popup
      page.driver.browser.accept_js_confirms
    else
      raise "Unsupported driver '#{page.driver.class}'"
    end
  end
  
  def reject_js_confirm
    if page.driver.browser.respond_to?(:switch_to)
      if page.driver.browser.switch_to.alert.respond_to?(:dismiss)
        page.driver.browser.switch_to.alert.dismiss
      elsif page.driver.browser.switch_to.alert.respond_to?(:reject)
        page.driver.browser.switch_to.alert.reject
      else
        raise "Unsupported driver '#{page.driver.class}'"
      end
    elsif page.driver.browser.respond_to?(:reject_js_confirms)
      sleep 1 # prevent test from failing by waiting for popup
      page.driver.browser.reject_js_confirms
    else
      raise "Unsupported driver '#{page.driver.class}'"
    end
  end

end
