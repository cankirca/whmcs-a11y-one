{*
 * knowledgebasearticle.tpl — A11y One override
 * Author: Can Kirca
 *
 * Accessibility fixes:
 *   - Single <h1> for article title only (print button moved outside)
 *   - Print rendered as <button type="button"> (no href="#" onclick)
 *     with aria-label; JS behaviour wired in a11y-one.js
 *   - Back link uses real KB index URL — no javascript:history.go(-1)
 *   - Vote buttons: fieldset/legend group; icons aria-hidden; aria-pressed
 *     managed by a11y-one.js after vote submission
 *   - Related-article link icons aria-hidden; title is the accessible name
 *   - Decorative icons aria-hidden throughout
 *}
{if $kbarticle.voted}
    {include file="$template/includes/alert.tpl" type="success alert-bordered-left" msg="{lang key="knowledgebaseArticleRatingThanks"}" textcenter=true}
{/if}

<div class="card">
    <div class="card-body">
        {* Print button is outside <h1> so the heading contains only the title *}
        <div class="d-flex justify-content-between align-items-start mb-2">
            <h1 class="h2 mb-0">{$kbarticle.title}</h1>
            <button type="button" class="btn btn-default btn-sm ml-2 btn-print-article"
                    aria-label="{lang key='a11yKbPrint'}">
                <i class="fas fa-print" aria-hidden="true"></i>
                <span class="d-none d-sm-inline">{lang key='print'}</span>
            </button>
        </div>

        <ul class="list-inline">
            {if $kbarticle.tags}
                <li class="list-inline-item text-sm pr-3 text-muted">
                    <i class="fas fa-tag mr-1" aria-hidden="true"></i>
                    <span class="badge badge-pill badge-info">
                        <i class="fas fa-code mr-1" aria-hidden="true"></i>
                        {$kbarticle.tags}
                    </span>
                </li>
            {/if}
            <li class="list-inline-item text-sm pr-3 text-muted">
                <i class="fas fa-thumbs-up mr-2" aria-hidden="true"></i>{$kbarticle.useful}
            </li>
        </ul>

        <hr>

        <article>
            {$kbarticle.text}
        </article>

        {if !$kbarticle.voted}
            <hr>
            {* Vote group — fieldset/legend provides a named grouping for the two buttons *}
            <fieldset class="kb-rate-article-group border-0 p-0 m-0">
                <legend class="col-form-label pt-0 font-weight-bold">
                    {lang key='knowledgebasehelpful'}
                </legend>
                <form action="{routePath('knowledgebase-article-view', {$kbarticle.id}, {$kbarticle.urlfriendlytitle})}" method="post" class="d-flex justify-content-between">
                    <input type="hidden" name="useful" value="vote">
                    <div>
                        <button class="btn btn-sm btn-secondary px-4"
                                type="submit"
                                name="vote"
                                value="yes"
                                aria-label="{lang key='a11yKbVoteYes'}">
                            <i class="fas fa-thumbs-up" aria-hidden="true"></i>
                            {lang key='knowledgebaseyes'}
                        </button>
                        <button class="btn btn-sm btn-secondary px-4"
                                type="submit"
                                name="vote"
                                value="no"
                                aria-label="{lang key='a11yKbVoteNo'}">
                            <i class="fas fa-thumbs-down" aria-hidden="true"></i>
                            {lang key='knowledgebaseno'}
                        </button>
                    </div>
                </form>
            </fieldset>
        {/if}

    </div>
</div>

{if $kbarticles}
    <div class="card">
        <div class="card-body">
            <h3 class="card-title m-0">
                <i class="fal fa-folder-open fa-fw" aria-hidden="true"></i>
                {lang key='knowledgebaserelated'}
            </h3>
        </div>
        <div class="list-group list-group-flush">
            {foreach $kbarticles as $kbarticle}
                <a href="{routePath('knowledgebase-article-view', {$kbarticle.id}, {$kbarticle.urlfriendlytitle})}" class="list-group-item kb-article-item" data-id="{$kbarticle.id}">
                    <i class="fal fa-file-alt fa-fw text-black-50" aria-hidden="true"></i>
                    {$kbarticle.title}
                    {if $kbarticle.editLink}
                        <button class="btn btn-sm btn-default show-on-card-hover" id="btnEditArticle-{$kbarticle.id}" data-url="{$kbarticle.editLink}" type="button">
                            {lang key="edit"}
                        </button>
                    {/if}
                    <small>{$kbarticle.article|truncate:100:"..."}</small>
                </a>
            {foreachelse}
                <div class="list-group-item">
                    {lang key='knowledgebasenoarticles'}
                </div>
            {/foreach}
        </div>
    </div>
{/if}

{if $kbarticle.editLink}
    <a href="{$kbarticle.editLink}" class="btn btn-default btn-sm float-right">
        <i class="fas fa-pencil-alt fa-fw" aria-hidden="true"></i>
        {lang key='edit'}
    </a>
{/if}

{* Back link uses the KB index URL — no javascript: href *}
<a href="{routePath('knowledgebase-index')}" class="btn btn-default px-4">
    {lang key='clientareabacklink'}
</a>
