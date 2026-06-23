{*
 * downloads.tpl — A11y One override
 * Author: Can Kirca
 *
 * Accessibility fixes:
 *   - Search input gets a real <label for> (sr-only)
 *   - Category card links get aria-label from category name
 *   - Decorative folder icons marked aria-hidden
 *   - File type image rendered aria-hidden (decorative — title is the accessible name)
 *   - Lock icon (clients-only) aria-hidden; sr-only text conveys the restriction
 *}
{if empty($dlcats)}
    {include file="$template/includes/alert.tpl" type="info" msg="{lang key='downloadsnone'}" textcenter=true}
{else}
    <form role="form" method="post" action="{routePath('download-search')}">
        <div class="input-group input-group-lg kb-search margin-bottom">
            <label for="inputDownloadsSearch" class="sr-only">{lang key='a11yDownloadsSearchLabel'}</label>
            <input type="text" name="search" id="inputDownloadsSearch" class="form-control font-weight-light" placeholder="{lang key='downloadssearch'}" />
            <div class="input-group-append">
                <button type="submit" id="btnDownloadsSearch" class="btn btn-primary btn-input-padded-responsive">
                    {lang key='search'}
                </button>
            </div>
        </div>
    </form>

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

    {if $mostdownloads}
        <div class="card">
            <div class="card-body">
                <h3 class="card-title m-0">
                    <i class="fal fa-star fa-fw" aria-hidden="true"></i>
                    {lang key='downloadspopular'}
                </h3>
            </div>
            <div class="list-group list-group-flush">
                {foreach $mostdownloads as $download}
                    <a href="{$download.link}" class="list-group-item kb-article-item">
                        {*
                         * File type image from {$download.type}: render as aria-hidden
                         * since the title already provides the accessible name.
                         * {$download.type} outputs <img src="..." alt="..."> — we suppress
                         * its alt via the replace modifier to use role=presentation.
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
                {/foreach}
            </div>
        </div>
    {/if}
{/if}
