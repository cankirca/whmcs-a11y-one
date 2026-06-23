{*
 * A11y One – markdown-guide.tpl override
 * Author: Can Kirca <cankirca@gmail.com>
 *
 * This fragment is injected inside a modal whose title uses
 * <h4 class="modal-title"> (see a11y-one/includes/modal.tpl).
 * Section sub-headers here are <h5> so heading order (h4 → h5) is
 * preserved.  The parent template used <h4> which would skip a level.
 *}

<h5>{lang key='markdown.emphasis'}</h5>
<pre>
**<strong>{lang key='markdown.bold'}</strong>**
*<em>{lang key='markdown.italics'}</em>*</pre>

<h5>{lang key='markdown.headers'}</h5>
<pre>
# {lang key='markdown.bigHeader'}
## {lang key='markdown.mediumHeader'}
### {lang key='markdown.smallHeader'}
#### {lang key='markdown.tinyHeader'}</pre>

<h5>{lang key='markdown.lists'}</h5>
<pre>
* {lang key='markdown.genericListItem'}
* {lang key='markdown.genericListItem'}
* {lang key='markdown.genericListItem'}

1. {lang key='markdown.numberedListItem'}
2. {lang key='markdown.numberedListItem'}
3. {lang key='markdown.numberedListItem'}</pre>

<h5>{lang key='markdown.links'}</h5>
<pre>[{lang key='markdown.textToDisplay'}]({lang key='markdown.exampleLink'})</pre>

<h5>{lang key='markdown.quotes'}</h5>
<pre>
> {lang key='markdown.thisIsAQuote'}
> {lang key='markdown.quoteMultipleLines'}</pre>

<h5>{lang key='markdown.tables'}</h5>
<pre>
| {lang key='markdown.columnOne'} | {lang key='markdown.columnTwo'} | {lang key='markdown.columnThree'} |
| -------- | -------- | -------- |
| {lang key='markdown.john'}     | {lang key='markdown.doe'}      | {lang key='markdown.male'}     |
| {lang key='markdown.mary'}     | {lang key='markdown.smith'}    | {lang key='markdown.female'}   |

<em>{lang key='markdown.withoutAligning'}</em>

| {lang key='markdown.columnOne'} | {lang key='markdown.columnTwo'} | {lang key='markdown.columnThree'} |
| -------- | -------- | -------- |
| {lang key='markdown.john'} | {lang key='markdown.doe'} | {lang key='markdown.male'} |
| {lang key='markdown.mary'} | {lang key='markdown.smith'} | {lang key='markdown.female'} |</pre>

<h5>{lang key='markdown.displayingCode'}</h5>
<pre>
`var example = "hello!";`

<em>{lang key='markdown.spanningMultipleLines'}</em>

```
var example = "hello!";
alert(example);
```</pre>
