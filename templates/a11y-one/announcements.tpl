{*
 * A11y One – announcements.tpl override
 * Author: Can Kirca <cankirca@gmail.com>
 * Fixes:
 *   - Announcement titles are <h2> (not <h1>); the page already carries
 *     one <h1> from the layout / breadcrumb header area.
 *   - Decorative icons get aria-hidden="true".
 *   - Date/meta associated visually and semantically with each announcement.
 *   - "Continue reading" arrow icon is aria-hidden.
 *   - Pagination active item gets aria-current="page".
 *}
<div class="card">
    <div class="card-body">
        <h1 class="card-title">{lang key="announcementstitle"}</h1>

        <div class="announcements">
            {foreach $announcements as $announcement}
                <div class="announcement">
                    <h2>
                        <a href="{routePath('announcement-view', $announcement.id, $announcement.urlfriendlytitle)}">
                            {$announcement.title}
                        </a>
                        {if $announcement.editLink}
                            <a href="{$announcement.editLink}" class="btn btn-default btn-sm show-on-hover">
                                <i class="fas fa-pencil-alt fa-fw" aria-hidden="true"></i>
                                {lang key='edit'}
                            </a>
                        {/if}
                    </h2>

                    <ul class="list-inline">
                        <li class="list-inline-item text-muted pr-3">
                            <i class="far fa-calendar-alt fa-fw" aria-hidden="true"></i>
                            <time datetime="{$carbon->createFromTimestamp($announcement.timestamp)->format('Y-m-d')}">
                                {$carbon->createFromTimestamp($announcement.timestamp)->format('jS F Y')}
                            </time>
                        </li>
                    </ul>

                    <article>
                        {if $announcement.text|strip_tags|strlen < 350}
                            {$announcement.text}
                        {else}
                            {$announcement.summary}
                        {/if}
                    </article>

                    <a href="{routePath('announcement-view', $announcement.id, $announcement.urlfriendlytitle)}" class="btn btn-default btn-sm">
                        {lang key="announcementscontinue"}
                        <i class="far fa-arrow-right" aria-hidden="true"></i>
                    </a>
                </div>
            {foreachelse}
                {include file="$template/includes/alert.tpl" type="info" msg="{lang key='noannouncements'}" textcenter=true}
            {/foreach}
        </div>

    </div>
</div>

{if $prevpage || $nextpage}
    <nav aria-label="{lang key='announcementsnavlabel'}">
        <ul class="pagination">
            {foreach $pagination as $item}
                <li class="page-item{if $item.disabled} disabled{/if}{if $item.active} active{/if}">
                    <a class="page-link" href="{$item.link}"{if $item.active} aria-current="page"{/if}>{$item.text}</a>
                </li>
            {/foreach}
        </ul>
    </nav>
{/if}

{if $announcementsFbRecommend}
    <script>
        (function(d, s, id) {
            var js, fjs = d.getElementsByTagName(s)[0];
            if (d.getElementById(id)) {
                return;
            }
            js = d.createElement(s); js.id = id;
            js.src = "//connect.facebook.net/{lang key='locale'}/all.js#xfbml=1";
            fjs.parentNode.insertBefore(js, fjs);
        }(document, 'script', 'facebook-jssdk'));
    </script>
{/if}
