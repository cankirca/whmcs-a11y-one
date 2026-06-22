<div class="alert alert-{if $type eq "error"}danger{elseif $type}{$type}{else}info{/if}{if $textcenter} text-center{/if}{if $additionalClasses} {$additionalClasses}{/if}{if $hide} w-hidden{/if}"{if $idname} id="{$idname}"{/if}{if $type eq "error" or $type eq "danger" or $type eq "warning"} role="alert"{else} role="status" aria-live="polite"{/if}>
<span class="sr-only">{if $type eq "error" or $type eq "danger" or $type eq "warning"}{lang key='error'}{elseif $type eq "success"}{lang key='success'}{else}{lang key='information'}{/if}: </span>
{if $errorshtml}
    <strong>{lang key='clientareaerrors'}</strong>
    <ul>
        {$errorshtml}
    </ul>
{else}
    {if $title}
        <h2>{$title}</h2>
    {/if}
    {$msg}
{/if}
</div>
