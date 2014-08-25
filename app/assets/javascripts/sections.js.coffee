window.init_sections_listeners = ->
  $('.section-delete').unbind('click').click ->
    if ( confirm("Are you sure you want to delete the section entitled " + $(this).data('section-name') + "?") )
          $.post($(this).data('delete-url'), {
            'id': $(this).data('id')
            });
          $(this).parent().parent().slideUp('slow')
    return false;

  $('.section-edit').unbind('click').click ->
    switchSectionInfoToEdit($(this).parent())
    return false;

  $('.section-save').unbind('click').click (event) ->
    sec_id = $(this).data('section-id')
    new_name = $('#input-section-name-' + sec_id).val()
    $('#section-name-' + sec_id).html(new_name)
    switchSectionEditToInfo($(this).parent().parent().parent())
    return true;

  $('.new-section-button').unbind('click').click ->
    course_id = $(this).data('course-id')
    $.post($(this).data('url'), {
        'course_id': course_id
      }, (response) ->
        # append the html for the new section
        parent = $('.sections-for-editable-components').append(response)
        
        # automatically set the new section to edit mode
        new_section = parent.children().last()
        switchSectionInfoToEdit(new_section.children('.holder'))

        # reinitialize the listeners for the new element(s)
        init_sections_listeners()
        init_components_listeners()

        # scroll the window automatically to show the newly added section...
        new_pos = $('.sections-for-editable-components').position().top + $('.sections-for-editable-components').height()
        scrollWindow(new_pos)
    );
    return false;

  # enable tooltips for any element type
  $("*[rel=tooltip]").tooltip()


$ ->
  init_sections_listeners()

switchSectionInfoToEdit = (section) ->
  # hide the name and edit & delete buttons
  # show the form and save button
  section.children('.section-edit-form-container').fadeIn(400)
  section.children('.editable-components-section-name').hide()
  section.children('.section-delete').hide()
  section.children('.section-edit').hide()
  
  # set the focus automatically
  form = section.children('.section-edit-form-container').children().first()
  name_field = form.children('.section-name-field')
  setTimeout( ->
      name_field.focus();
    , 400 );


switchSectionEditToInfo = (section) ->
  # hide the form and save button
  # show the edit & delete buttons and the name
  section.children('.section-edit-form-container').hide()
  section.children('.editable-components-section-name').fadeIn(400)
  section.children('.section-delete').fadeIn(400)
  section.children('.section-edit').fadeIn(400)



