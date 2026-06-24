{*
 * downloadscat.tpl — A11y One override
 * Author: Can Kirca
 *
 * Accessibility fixes:
 *   - Search input gets a real <label for> (sr-only)
 *   - Category card links get aria-label from category name
 *   - Decorative folder/download icons aria-hidden
 *   - File type image (from {$download.type}) rendered aria-hidden — title is the accessible name
 *   - Lock icon aria-hidden; sr-only text conveys the restriction
 *   - Back link uses real downloads index URL — no javascript:history.go(-1)
 *}
{* Clear page heading — category name from breadcrumb last item. *}
{foreach $breadcrumb as $a11yBc}{if $a11yBc@last}<h1 class="h3 mb-4">{$a11yBc.label|strip_tags|escape|trim}</h1>{/if}{/foreach}
<form role="form" method="post" action="{routePath('download-search')}">
    <div class="input-group input-group-lg kb-search margin-bottom">
        <label for="inputDownloadsSearch" class="sr-only">{lang key='a11yDownloadsSearchLabel'}</label>
        <input type="text" name="search" id="inputDownloadsSearch" class="form-control font-weight-light" placeholder="{lang key='downloadssearch'}" value="{$search}" />
        <div class="input-group-append">
            <button type="submit" id="btnDownloadsSearch" class="btn btn-primary btn-input-padded-responsive">
                {lang key='search'}
            </button>
        </div>
    </div>
</form>

{if $dlcats}
    <div class="row">
        {foreach $dlcats as $category}
            <div class="col-xl-6">
                <div class="card kb-category mb-4">
                    <a href="{routePath('download-by-cat', {$category.id}, {$category.urlfriendlyname})}"
                       class="card-body"
                       aria-label="{$category.name|escape}">
                        <span class="h5 m-0" aria-hidden="true">
                            <i class="fal fa-folder fa-fw" aria-hidden="true"></i>
                            {$category.name}
                            <span class="badge badge-info float-right">
                                {lang key="downloads.numDownload{if $kbcat.numarticles != 1}s{/if}" num=$category.numarticles}
                            </span>
                        </span>
                        <p class="m-0 text-muted" aria-hidden="true"><small>{$category.description}</small></p>
                    </a>
                </div>
            </div>
        {/foreach}
    </div>
{/if}

<div class="card">
    <div class="card-body">
        <h3 class="card-title m-0">
            <i class="fal fa-download fa-fw" aria-hidden="true"></i>
            {lang key='downloadsfiles'}
        </h3>
    </div>
    <div class="list-group list-group-flush">
        {foreach $downloads as $download}
            <a href="{$download.link}" class="list-group-item kb-article-item">
                {*
                 * File type image from {$download.type}: suppress its alt so the title
                 * is the sole accessible name for the link.
                 *}
                {$download.type|replace:'alt="':' role="presentation" alt="'}
                {$download.title}
                {if $download.clientsonly}
                    <div class="float-md-right">
                        <span class="label label-danger">
                            <i class="fas fa-lock fa-fw" aria-hidden="true"></i>
                            <span class="sr-only">{lang key='a11yDownloadsClientsOnly'}</span>
                            <span aria-hidden="true">{lang key='restricted'}</span>
                        </span>
                    </div>
                {/if}
                <small>
                    {$download.description}
                    <br>
                    <strong>{lang key='downloadsfilesize'}: {$download.filesize}</strong>
                </small>
            </a>
        {foreachelse}
            <div class="list-group-item">
                {lang key='downloadsnone'}
            </div>
        {/foreach}
    </div>
</div>

{* Back link uses the downloads index URL — no javascript: href *}
<a href="{routePath('download-index')}" class="btn btn-default px-4">
    {lang key='clientareabacklink'}
</a>
