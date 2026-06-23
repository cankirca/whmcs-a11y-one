{*
 * A11y One – viewannouncement.tpl override
 * Author: Can Kirca <cankirca@gmail.com>
 * Fixes:
 *   - Single <h1> for the announcement title (moved social-share out of the h1).
 *   - Twitter share link: icon aria-hidden, button has accessible name via
 *     aria-label; moved to its own accessible container.
 *   - target=_blank links get rel="noopener noreferrer" plus an sr-only
 *     "(opens in new window)" notice.
 *   - Facebook inline <script> blocks preserved as-is (WHMCS renders them).
 *   - Decorative calendar/clock icons get aria-hidden="true".
 *   - {$text} left unchanged — author-supplied HTML content.
 *}
<div class="card">
    <div class="card-body extra-padding">

        <div class="d-flex align-items-start justify-content-between flex-wrap gap-2 mb-2">
            <h1 class="mb-0">{$title}</h1>

            {if $twittertweet}
                <div class="announcement-share-twitter">
                    <a href="https://twitter.com/share"
                       class="twitter-share-button"
                       data-count="vertical"
                       data-size="large"
                       data-via="{$twitterusername}"
                       target="_blank"
                       rel="noopener noreferrer"
                       aria-label="{lang key='announcementShareTwitter'}">
                        <i class="fab fa-x-twitter" aria-hidden="true"></i>
                        <span class="sr-only">{lang key='announcementNewWindow'}</span>
                    </a>
                    <script src="https://platform.twitter.com/widgets.js"></script>
                </div>
            {/if}
        </div>

        <ul class="list-inline">
            <li class="list-inline-item text-muted pr-3">
                <i class="far fa-calendar-alt fa-fw" aria-hidden="true"></i>
                <time datetime="{$carbon->createFromTimestamp($timestamp)->format('Y-m-d')}">
                    {$carbon->createFromTimestamp($timestamp)->format('l, jS F, Y')}
                </time>
            </li>
            <li class="list-inline-item text-muted pr-3">
                <i class="far fa-clock fa-fw" aria-hidden="true"></i>
                {$carbon->createFromTimestamp($timestamp)->format('H:ia')}
            </li>
        </ul>

        <div class="py-5">
            {$text}
        </div>

        {if $facebookrecommend}
            <div id="fb-root"></div>
            <script>
                (function(d, s, id) {
                    var js, fjs = d.getElementsByTagName(s)[0];
                    if (d.getElementById(id)) {
                        return;
                    }
                    js = d.createElement(s);
                    js.id = id;
                    js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
                    fjs.parentNode.insertBefore(js, fjs);
                }(document, 'script', 'facebook-jssdk'));
            </script>
            <div class="fb-like" data-href="{fqdnRoutePath('announcement-view', $id, $urlfriendlytitle)}" data-send="true" data-width="450" data-show-faces="true" data-action="recommend">
            </div>
        {/if}
    </div>
</div>

{if $facebookcomments}
    <div class="card">
        <div class="card-body p-5">
            <div id="fb-root">
            </div>
            <script>
                (function(d, s, id) {
                    var js, fjs = d.getElementsByTagName(s)[0];
                    if (d.getElementById(id)) {
                        return;
                    }
                    js = d.createElement(s);
                    js.id = id;
                    js.src = "//connect.facebook.net/en_US/all.js#xfbml=1";
                    fjs.parentNode.insertBefore(js, fjs);
                }(document, 'script', 'facebook-jssdk'));
            </script>
            <fb:comments href="{fqdnRoutePath('announcement-view', $id, $urlfriendlytitle)}" num_posts="5" width="100%"></fb:comments>
        </div>
    </div>
{/if}

<a href="{routePath('announcement-index')}" class="btn btn-default px-4">
    {lang key='clientareabacklink'}
</a>

{if $editLink}
    <a href="{$editLink}" class="btn btn-default px-4 float-right">
        <i class="fas fa-pencil-alt fa-fw" aria-hidden="true"></i>
        {lang key='edit'}
    </a>
{/if}
