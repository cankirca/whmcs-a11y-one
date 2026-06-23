{*
 * knowledgebasecat.tpl — A11y One override
 * Author: Can Kirca
 *
 * Accessibility fixes:
 *   - Search input gets a real <label for> (sr-only)
 *   - Category card links get aria-label from category name
 *   - Decorative icons marked aria-hidden
 *   - Back button uses real KB index URL, not javascript:history.go(-1)
 *}
<form role="form" method="post" action="{routePath('knowledgebase-search')}" class="mb-4">
    <div class="input-group input-group-lg kb-search">
        <label for="inputKnowledgebaseSearch" class="sr-only">{lang key='a11yKbSearchLabel'}</label>
        <input type="text" id="inputKnowledgebaseSearch" name="search" class="form-control font-weight-light" placeholder="{lang key='clientHomeSearchKb'}" value="{$searchterm|escape}" />
        <div class="input-group-append">
            <button type="submit" id="btnKnowledgebaseSearch" class="btn btn-primary btn-input-padded-responsive">
                {lang key='search'}
            </button>
        </div>
    </div>
</form>

{if $kbcats}
    <div class="row">
        {foreach $kbcats as $category}
            <div class="col-xl-6">
                <div class="card kb-category mb-4">
                    <a href="{routePath('knowledgebase-category-view', {$category.id}, {$category.urlfriendlyname})}"
                       class="card-body"
                       data-id="{$category.id}"
                       aria-label="{$category.name|escape}">
                        <span class="h5 m-0" aria-hidden="true">
                            <span class="badge badge-info float-right">
                                {lang key="knowledgebase.numArticle{if $category.numarticles != 1}s{/if}" num=$category.numarticles}
                            </span>
                            <i class="fal fa-folder fa-fw" aria-hidden="true"></i>
                            {$category.name}
                            {if $category.editLink}
                                <button class="btn btn-sm btn-default show-on-card-hover" id="btnEditCategory-{$category.id}" data-url="{$category.editLink}" type="button">
                                    {lang key="edit"}
                                </button>
                            {/if}
                        </span>
                        <p class="m-0 text-muted" aria-hidden="true"><small>{$category.description}</small></p>
                    </a>
                </div>
            </div>
        {/foreach}
    </div>
{/if}

{if $kbarticles || !$kbcats}
    <div class="card">
        <div class="card-body">
            <h3 class="card-title m-0">
                <i class="fal fa-folder-open fa-fw" aria-hidden="true"></i>
                {if $tag}
                    {lang key='kbviewingarticlestagged'} '{$tag}'
                {else}
                    {lang key='knowledgebasearticles'}
                {/if}
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

{* Real URL back link — no javascript: href *}
<a href="{routePath('knowledgebase-index')}" class="btn btn-default px-4">
    {lang key='clientareabacklink'}
</a>

{if $kbcurrentcat.editLink}
    <a href="{$kbcurrentcat.editLink}" class="btn btn-default px-4 float-right">
        <i class="fas fa-pencil-alt fa-fw" aria-hidden="true"></i>
        {lang key='edit'}
    </a>
{/if}
