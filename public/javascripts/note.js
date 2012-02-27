$(function($) {
    $('.add_link').click(function(){
        $(this).parent().prev('table').append(
            '<tr>\
               <td><input id="links__tag_name" name="links[][tag_name]" size="30" type="text" value=""></td>\
               <td><input id="links__value" name="links[][value]" size="30" type="text" value=""></td>\
               <td><input id="links__id" name="links[][id]" type="hidden" value="0"></td>\
               <td></td>\
             </tr>');
    });
    
    $('.delete_link')
    	.bind("ajax:success", function (event, data, status, xhr) {
            $(this).parents('tr').remove();
    	});
});

