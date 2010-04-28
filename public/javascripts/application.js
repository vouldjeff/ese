// Place your application-specific JavaScript functions and classes here
// This file is automatically included by javascript_include_tag :defaults

function uncheck_all_other(element, t) {
    $$('#' + element + ' .checkbox-type-1').each(function(e) {
        e.checked = null;
    });
    $(t).checked = true;
}

function mark_for_destroy(element, type) {
    $(element).next('.should_destroy').value = 1;
    $(element).up('.' + type).fade();
    $(element).up('.' + type).remove();
}
