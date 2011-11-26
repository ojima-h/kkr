$(function($) {
    $('.note_list_entry_link_button').click(function(event){
	$(event.target).nextAll('.note_tags').each(function(){
	    var data = $.parseJSON($(this).find('input').attr('value'));
	    var name = $(this).text();
	    var id = data.tag.id;
	    var color = data.tag.color;
	    add_tag_to_home_new_note(id, name, color);
	});
	$('#home_new_note_field').find('textarea').focus();
    });						    
});

function add_tag_to_home_new_note (id, name, color) {
    var tags = $('#home_new_note_tags').find('.home_new_note_tags_entry');
    var dup_tags = tags.filter( function (index) {
	return $(this).html() == name;
    });
    if (dup_tags.length == 0) {
	$('<input type="hidden" name="tag[]"></input>')
	    .attr('value', id)
	    .appendTo('#home_new_note_field');
	$('<div class="home_new_note_tags_entry"></div>')
	    .text(name)
	    .css('background-color', color)
	    .appendTo("#home_new_note_tags");
    }
}
function remove_note_from_home_note_list (id, selector_for_removing) {
    $.ajax({
	url: "notes/" + id + ".xml",
	type: 'DELETE',
	dataType: 'xml',
	statusCode: {
	    200: function (data) {
		$(selector_for_removing).remove();
	    }
	}
    })
    return false;
}
    
/* 非同期通信サンプル */
    // $("#new_tag")
    // 	.bind("ajax:success", function (event, data, status, xhr) {
    // 	    $('#tag_list_add_button input')
    // 		.each(function() {$(this).val("")});
    // 	    $('#tag_list_add_button')
    // 		.after(data);
    // 	});
    // $('#home_tag_list .tag_list_entry_delete_button')
    // 	.bind('ajax:success', function(event, data, status, xhr){
    // 	    alert('check');
    // 	    $(event.target).parents('.tag_list_entry').remove();
    // 	});
    // $('#home_note_list .note_list_entry_delete_button')
    // 	.bind('ajax:success', function(event, data, status, xhr){
    // 	    alert('check');
    // 	    $(event.target).parents('.note_entry').remove();
    // 	});
