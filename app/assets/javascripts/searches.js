function add_section(link, association, content) {
  var new_id = new Date().getTime();
  var regexp = new RegExp("new_" + association, "g");
  content = $(content.replace(regexp, new_id));
  content.hide();
  $(link).parents('div.panel').find('ul.list-group').append(content);
  content.slideDown();
};

function delete_section(link)
{
  var section = $(link).parents('li.list-group-item');
  $(section).find('input.destroy').val(1);
  section.slideUp();
};

function delete_location(location_id)
{
  checkbox = "#search_locations_attributes_" + location_id + "__destroy";
  panel    = "#search_locations_panel_" + location_id;
  $(checkbox)[0].value = true;
  $(panel).slideUp();
};

function add_location()
{
  template  = "#search_locations_panel_0";
  new_panel = $(template).dup;
  new_panel.get('')
};
