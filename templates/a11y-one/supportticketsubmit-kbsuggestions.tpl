{*
    A11y One — accessible KB suggestions fragment (AJAX-injected into the
    #autoAnswerSuggestions live region on the ticket compose form).
    Author: Can Kirca <cankirca@gmail.com> — https://github.com/cankirca

    Accessibility changes vs parent twenty-one:
      - Decorative file icon marked aria-hidden="true".
      - Each suggestion link opens in a new tab (target="_blank"); an sr-only
        "(opens in new window)" note is appended so AT users are warned, and
        rel="noopener" is added for security.
    The announcing live region (role="region" aria-label aria-live) lives on the
    #autoAnswerSuggestions container in supportticketsubmit-steptwo.tpl, so the
    injected content here is announced when it lands.
*}
<h3 class="card-title">{lang key='kbsuggestions'}</h3>

<p>{lang key='kbsuggestionsexplanation'}</p>

<div class="kbarticles list-group mb-3">
    {foreach $kbarticles as $kbarticle}
        <div class="list-group-item kb-article-item">
            <a href="knowledgebase.php?action=displayarticle&id={$kbarticle.id}" target="_blank" rel="noopener">
                <i class="fal fa-file-alt fa-fw text-black-50" aria-hidden="true"></i>
                {$kbarticle.title}
                <small>{$kbarticle.article}...</small>
                <span class="sr-only">({lang key='a11yOpensInNewWindow'})</span>
            </a>
        </div>
    {/foreach}
</div>
