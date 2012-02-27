$(function($) {
    $('.add_manipulation').click(function(){
        $(this).parent().prev('table').append(
            '<tr>\
               <td>\
                 <select id="manipulations__sort" name="manipulations[][sort]">\
                   <option value="append">append</option>\
                   <option value="delete">delete</option>\
                   <option value="modify">modify</option>\
                   <option value="subst">subst</option>\
                   <option value="attach">attach</option>\
                 </select>\
               </td>\
               <td><input id="manipulations__object" name="manipulations[][object]" size="30" type="text" value=""></td>\
               <td><input id="manipulations__value" name="manipulations[][value]" size="30" type="text" value=""></td>\
               <td><input id="manipulations__id" name="manipulations[][id]" type="hidden" value="0"></td>\
               <td></td>\
             </tr>');
    });
    
    $('.delete_manipulation')
    	.bind("ajax:success", function (event, data, status, xhr) {
            $(this).parents('tr').remove();
    	});
});

