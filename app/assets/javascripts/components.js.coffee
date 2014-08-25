window.init_components_listeners = ->
  $("[id^=editable-components-]").sortable(
    #axis: 'y'
    handle: '.handle'
    connectWith: '.editable-components'
    update: (event, ui) ->

      # change the section if the item has been moved between sections
      if ui['sender'] != null
        sec_id = $(this).data('id')
        comp_id = ui['item'].data('id')
        $.post(ui['item'].data('change-section-url'), {
            'component_id': comp_id,
            'section_id': sec_id
          }, (response) ->
            #console.log(response)
        );
      
      # update the order of the list
      $.post($(this).data('update-url'), $(this).sortable('serialize'))

    start: (event, ui) ->
      $('.editable-component').removeClass('with-color')
      $('.editable-component').addClass('without-color')
      (ui['item']).addClass('active')
    stop: (event, ui) ->
      $('.editable-component').addClass('with-color')
      $('.editable-component').removeClass('without-color')
      (ui['item']).removeClass('active')
  );

  $('.component-delete').unbind('click').click ->
    if ( confirm("Are you sure you want to delete the lesson entitled " + $(this).data('component-name') + "?") )
          $.post($(this).data('delete-url'), {
            'id': $(this).data('id')
            });
          $(this).parent().parent().slideUp('slow')
    return false;

  $('.component-edit').unbind('click').click ->
    $(this).parent().parent().children('.component-edit-form-container').slideToggle(400)

  $('.component-cancel').unbind('click').click ->
    $(this).parent().parent().slideUp(400)
    return false;

  $('.component-save').unbind('click').click ->
    comp_id = $(this).data('id')
    url = $(this).data('update-url')
    submitComponent(comp_id, url)
    return false;

  # $('#component_name').unbind('keyup input paste').bind('keyup input paste', ->
  #   # uncomment if you want to actively update the component name
  #   # comp_id = $(this).data('id')
  #   # $('#component_name_' + comp_id).html($(this).attr("value"))
  # );

  $('.component-description-field').keydown (event) ->
    if (event.keyCode == 13) # keyCode for enter/return
      comp_id = $(this).data('id')
      url = $(this).parent().attr('action')
      submitComponent(comp_id, url)
      return false

  $('.component-name-field').keydown (event) ->
    if (event.keyCode == 13) # keyCode for enter/return
      comp_id = $(this).data('id')
      url = $(this).parent().attr('action')
      submitComponent(comp_id, url)
      return false

  $('.new-lesson-button').unbind('click').click ->
    sec_id = $(this).data('section-id')
    $.post($(this).data('url'), {
        'section_id': sec_id
      }, (response) ->
        section = $('#editable-components-' + sec_id).append(response)
        init_components_listeners()

        # get the edit form of the newly created component
        comp_li = section.children().last()
        form_container = comp_li.children('.component-edit-form-container')
        showComponentEditForm form_container
        
    );
    return false;

  # enable tooltips for any element type
  $("*[rel=tooltip]").tooltip()
  $('*[rel="popover"]').popover()
    

$ ->
  init_components_listeners()

submitComponent = (comp_id, url) ->
  form = $('#edit_component_' + comp_id)
  data = form.serializeArray()
  $.ajax( url,
          type: 'PUT',
          data: data,
          success: (response) ->
    
            # the response will either be "true" or "false"
            if eval(response)
              # print a status message
              $("#component_status_" + comp_id).html("Updated successfully!").fadeIn(300, ->
                  $(this).delay(2000).fadeOut(200)
                );
              # update the name on screen
              new_name = form.children("#component_name").attr('value')
              $('#component_name_' + comp_id).html(new_name)
              form.parent().slideUp(600)
            else
              $("#component_status_" + comp_id).html("There was a problem. Try again.").fadeIn(300, ->
                  $(this).delay(2000).fadeOut(200)
                );

          );

showComponentEditForm = (form_container) ->
  # show the edit form container...
  form_container.fadeIn('fast')

  form = form_container.children('form')
  name_field = form.children('.component-name-field')
  console.log(name_field)

  # set the focus..
  setTimeout( ->
    name_field.focus();
  , 300 );
