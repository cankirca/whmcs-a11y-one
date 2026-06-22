{if $message = get_flash_message()}
    <div class="alert alert-{if $message.type == "error"}danger{elseif $message.type == 'success'}success{elseif $message.type == 'warning'}warning{else}info{/if}{if isset($align)} text-{$align}{/if}"{if $message.type == "error" or $message.type == "danger"} role="alert"{else} role="status" aria-live="polite"{/if}>
        <span class="sr-only">{if $message.type == "error" or $message.type == "danger"}{lang key='error'}{elseif $message.type == "warning"}{lang key='warning'}{elseif $message.type == "success"}{lang key='success'}{else}{lang key='information'}{/if}: </span>
        {$message.text}
    </div>
{/if}
