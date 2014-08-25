window.init_choice_question_listeners = ->
  
  $('.add-choice-button').unbind('click').click ->
    question_id = $(this).data('question-id')
    url = $(this).data('url')
    $.post(url, {'question_id' : question_id}, (response) ->
      $('.edit-choice-form-list').append(response)
      init_choice_question_listeners()
    );

    return false

  $('.choice-delete').unbind('click').click ->
    choice_id = $(this).data('id')
    url = $(this).data('delete-url')
    $.post(url, {'id' : choice_id}, (data) -> 
      if eval(data)
        $("#choice-form-item-" + choice_id).slideUp(300)
    );
    return false

  $('.choice-save').unbind('click').click ->
    choice_id = $(this).data('choice-id')
    url = $(this).data('save-url')
    form = $('#edit_quiz_choice_' + choice_id)
    data = form.serializeArray()
    $.post(url, data)
    return false

  $('.choice-is-answer').change ->
    # only one checkbox may be checked at a time
    # the checkboxes are in different forms so we
    # can't just use radio buttons
    $('.choice-is-answer').prop('checked', false)
    $(this).prop('checked', true)

  $('.choice-question-save').click ->
    # submit all the above forms when the button is pressed
    $('.edit_quiz_choice').submit()
    $('.edit_choice_question').submit()
    return false

  # (re-)enable tooltips for any element type
  $("*[rel=tooltip]").tooltip()





$ ->
  init_choice_question_listeners()