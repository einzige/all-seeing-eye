
/*
 *= require_self
 *= require rainbow
 *= require rainbow/ruby
 *= require rainbow/javascript
 *= require rainbow/coffeescript
 *= require rainbow/css
 *= require rainbow/html
 *= require rainbow/generic
 */



$(document).ready(function() {


    $('.file .tbody').each(function() {
        var round_column = $(this).find('th.eye:first');
        round_column.css("border-top-right-radius", "10px");
        round_column.css("border-top-left-radius", "10px");

        round_column = $(this).find('.past_gutter:eq(1)');
        round_column.css("border-top-right-radius", "10px");

        round_column = $(this).find('.future_gutter:eq(1)');
        round_column.css("border-top-left-radius", "10px");

        round_column = $(this).find('th.eye:last');
        round_column.css("border-bottom-right-radius", "10px");
        round_column.css("border-bottom-left-radius", "10px");

        round_column = $(this).find('.past_gutter:last');
        round_column.css("border-bottom-right-radius", "10px");

        round_column = $(this).find('.future_gutter:last');
        round_column.css("border-bottom-left-radius", "10px");
    })

    var pressed;
    var released;

    $('.file th').mousedown(function(e) {
        pressed = $(this).parent('tr');
        pressed.addClass('commented');
        $('.file tr').bind('selectstart', function(event) { event.preventDefault(); });
        $('.file th').bind('mouseover', function() {
            $(this).parent('tr').addClass('commented');
        });
        e.stopPropagation();

    });

    $('.file th').mouseup(function(e) {
        released = $(this).parent('tr');

        $('.file tr').unbind('selectstart');
        $('.file th').unbind('mouseover');

        var pid = pressed.index();
        var rid = released.index();

        var t = pressed.parents('table');

        var i = pid > rid ? rid : pid;
        var n = pid > rid ? pid : rid;

        for(; i <= n; i++) {
            console.log($(t.find('tr')[i]).attr('id'));
        }

        console.log(pid, rid);

        pressed = undefined;
        released = undefined;
        e.stopPropagation();
    });


});
