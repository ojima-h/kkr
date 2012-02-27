$(function($) {
    $('#new_note .field').submit(function(event){
        var tag_list = []
        $(this).find('#new_note_field_tag_table .tag_name_entry')
            .map(function(){
                tag_list += $(this).text();
            });
    });

    $('#tag_list .tag .add_button').click(function(event){
        var tag_info = $(this).siblings('#tag_info').first();
        if (tag_info) {
            var tag = $.parseJSON(tag_info.attr('value')).tag;
            add_tag_to_new_note (tag.id, tag.name, tag.color);
        }
    });
});

function add_tag_to_new_note (id, name, color) {
    var tags = $('#new_note_links .entry:contains(' + name + ')');
    if (tags.length == 0) {
	$('<input type="hidden" name="links[][tag_id]"></input>')
	    .attr('value', id)
	    .appendTo('#new_note .field');
	$('<div class="entry"></div>')
	    .text(name)
	    .css('background-color', color)
	    .appendTo("#new_note_links");
    }
}
function remove_note_from_note_list (id, selector_for_removing) {
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
    // $('#tag_list .tag_list_entry_delete_button')
    // 	.bind('ajax:success', function(event, data, status, xhr){
    // 	    alert('check');
    // 	    $(event.target).parents('.tag_list_entry').remove();
    // 	});
    // $('#note_list .note_list_entry_delete_button')
    // 	.bind('ajax:success', function(event, data, status, xhr){
    // 	    alert('check');
    // 	    $(event.target).parents('.note_entry').remove();
    // 	});
