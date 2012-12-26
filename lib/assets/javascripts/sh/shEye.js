/**
 * Determines if specified line number is in the highlighted list.
 */
SyntaxHighlighter.Highlighter.prototype.isLineRemoved = function(lineNumber)
{
    var list = this.getParam('removed', []);

    if (typeof(list) != 'object' && list.push == null)
        list = [ list ];

    return list.indexOf(lineNumber.toString()) != -1;
};

/**
 * Generates HTML markup for a single line of code while determining alternating line style.
 * @param {Integer} lineNumber	Line number.
 * @param {String} code Line	HTML markup.
 * @return {String}				Returns HTML markup.
 */
SyntaxHighlighter.Highlighter.prototype.getLineHtml = function(lineIndex, lineNumber, code)
{
    var classes = [
        'line',
        'number' + lineNumber,
        'index' + lineIndex,
        'alt' + (lineNumber % 2 == 0 ? 1 : 2).toString()
    ];

    if (this.isLineHighlighted(lineNumber))
        classes.push('highlighted');

    if (this.isLineRemoved(lineNumber))
        classes.push('removed_line');

    if (lineNumber == 0)
        classes.push('break');

    return '<div class="' + classes.join(' ') + '">' + code + '</div>';
};