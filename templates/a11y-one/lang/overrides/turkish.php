<?php
/**
 * A11y One — Turkish language keys (REFERENCE COPY).
 *
 * WHMCS does NOT auto-load theme-level lang/overrides. To activate these
 * strings, MERGE the keys below into your site-level file:
 *     <whmcs>/lang/overrides/turkish.php
 * (create it if absent). See docs/a11y-one/README.md → Installation.
 *
 * Author: Can Kirca <cankirca@gmail.com> — https://github.com/cankirca
 * License: MIT
 */

$_LANG['skipToMainContent']          = 'Ana içeriğe geç';
$_LANG['userLogin']['showPassword']  = 'Parolayı göster';
$_LANG['userLogin']['hidePassword']  = 'Parolayı gizle';
$_LANG['a11yPwWeak']                 = 'Zayıf';
$_LANG['a11yPwFair']                 = 'Orta';
$_LANG['a11yPwStrong']               = 'Güçlü';
$_LANG['warning']                    = 'Uyarı';
$_LANG['tablesearch']                = 'Ara:';
$_LANG['a11yCollapse']               = 'Daralt';
$_LANG['a11yExpand']                 = 'Genişlet';
$_LANG['a11yPanel']                  = 'panel';
$_LANG['a11yRowsPerPage']            = 'Sayfa başına satır';
$_LANG['a11yTablePagination']        = 'Tablo sayfalama';
$_LANG['a11yPrevPage']               = 'Önceki sayfa';
$_LANG['a11yNextPage']               = 'Sonraki sayfa';
$_LANG['a11yFirstPage']              = 'İlk sayfa';
$_LANG['a11yLastPage']               = 'Son sayfa';
$_LANG['a11yPage']                   = 'Sayfa';
$_LANG['a11ySearch']                 = 'Ara';
$_LANG['a11yCopyToClipboard']        = 'Panoya kopyala';
$_LANG['a11yCopied']                 = 'Kopyalandı';
$_LANG['a11ySortable']               = 'sıralanabilir';
$_LANG['a11ySortedAsc']              = 'artan sırada sıralı';
$_LANG['a11ySortedDesc']             = 'azalan sırada sıralı';
$_LANG['a11yNotSorted']              = 'sıralanmamış';

// Header chrome (topbar / navbar) accessible names
$_LANG['a11ySwitchAccount']          = 'Hesap değiştir';
$_LANG['a11yMenu']                   = 'Menü';
$_LANG['a11yItemsInCart']            = 'sepetteki ürün';
$_LANG['a11yDevLicenseNotice']       = 'Geliştirme lisansı bildirimi';

// WS-F support tickets — list, submit flow, markdown editor, file upload
$_LANG['ticketStatusUnread']         = 'okunmamış';
$_LANG['ticketStatusRead']           = 'okunmuş';
$_LANG['a11yOpensInNewWindow']       = 'yeni pencerede açılır';
$_LANG['a11yMdeEditor']              = 'Mesaj (Markdown düzenleyici)';
$_LANG['a11yMdeBold']                = 'Kalın';
$_LANG['a11yMdeItalic']              = 'İtalik';
$_LANG['a11yMdeHeading']             = 'Başlık';
$_LANG['a11yMdeUrl']                 = 'Bağlantı ekle';
$_LANG['a11yMdeImage']               = 'Görsel ekle';
$_LANG['a11yMdeList']                = 'Madde işaretli liste';
$_LANG['a11yMdeListO']               = 'Numaralı liste';
$_LANG['a11yMdeCode']                = 'Kod';
$_LANG['a11yMdeQuote']               = 'Alıntı';
$_LANG['a11yMdePreview']             = 'Önizlemeyi aç/kapat';
$_LANG['a11yMdeHelp']                = 'Markdown biçimlendirme yardımı';
$_LANG['a11yMdeFullscreen']          = 'Tam ekranı aç/kapat';
$_LANG['a11yMdeToolbar']             = 'Metin biçimlendirme';
$_LANG['a11yFileAttachment']         = 'Ek dosya';
$_LANG['a11yFileAttachmentAdded']    = 'Ek dosya alanı eklendi';

// WS-F Task 3 viewticket — accessible star rating
$_LANG['a11yRateThisReply']          = 'Bu destek yanıtını değerlendirin';
$_LANG['a11yStarSingular']           = ':count yıldız';
$_LANG['a11yStarPlural']             = ':count yıldız';

// WS-F Task 4 ticketfeedback — accessible 1–10 rating radios
$_LANG['a11yFeedbackOutOf10']        = '10 üzerinden';

// WS-F Task 5 — KB + downloads accessible labels
$_LANG['a11yKbSearchLabel']          = 'Bilgi bankasında ara';
$_LANG['a11yKbPrint']                = 'Bu makaleyi yazdır';
$_LANG['a11yKbVoteYes']              = 'Evet, bu makale yardımcı oldu';
$_LANG['a11yKbVoteNo']               = 'Hayır, bu makale yardımcı olmadı';
$_LANG['a11yDownloadsSearchLabel']   = 'İndirmelerde ara';
$_LANG['a11yDownloadsClientsOnly']   = 'Yalnızca müşteriler';

// WS-D Task 1: Products / services
$_LANG['productDetails']['hookOutputLabel']   = 'Ek hizmet bilgisi';
$_LANG['metrics']['tableCaption']             = 'Hizmet kullanım metrikleri';
$_LANG['metrics']['pricingTableCaption']      = 'Fiyatlandırma kademeleri';

// WS-D Task 2: Cancel + Upgrade flow
$_LANG['a11yCancelTypeGroup']        = 'İptal zamanlaması';
$_LANG['a11yCancelDomainLabel']      = 'İlişkili alan adını iptal et';
$_LANG['a11yUpgradeBillingCycleFor'] = '%s için fatura dönemi';
$_LANG['a11yUpgradeSummaryCaption']  = 'Yükseltme siparişi özeti';
$_LANG['a11yUpgradePromoLabel']      = 'Promosyon kodu';
$_LANG['a11yUpgradePaymentLabel']    = 'Ödeme yöntemi';
$_LANG['a11yUpgradeConfirm']         = 'Yükseltmeyi onayla';
$_LANG['a11yUpgradeConfigGroup']     = 'Yapılandır: %s';
$_LANG['a11yUpgradeBillingLabel']    = 'Fatura dönemi';
$_LANG['a11yUpgradeQtyLabel']        = 'Miktar';

// WS-D Task 3: SSL (managessl + configure ×3) + subscription-manage
$_LANG['a11ySslValidationType']      = 'Doğrulama türü';
$_LANG['a11ySslApproverEmailGroup']  = 'Onaylayıcı e-posta adresi seçin';

// WS-C: Billing — faturalar, teklifler, fatura görüntüleme, ödeme
$_LANG['a11ySecurePaymentFrame']     = 'Güvenli ödeme formu';
$_LANG['a11yQuoteActions']           = 'İşlemler';

/* === WS-E Domains === */
$_LANG['a11yDomainTableCaption']      = 'Alan adlarınız';
$_LANG['a11yDomainSelectAll']         = 'Tüm alan adlarını seç';
$_LANG['a11yDomainSelectRow']         = 'Alan adını seç';
$_LANG['a11yDomainBulkActions']       = 'Toplu işlemler';
$_LANG['a11yDomainSelectedCount']     = '%s alan adı seçildi';
$_LANG['a11yDomainVisitSite']         = 'Siteyi ziyaret et';
$_LANG['a11yDomainAddNewRecord']      = 'Yeni DNS kaydı satırı ekle';
$_LANG['a11yDomainAddNewForwarder']   = 'Yeni e-posta yönlendirmesi satırı ekle';
$_LANG['a11yDomainForwardingAt']      = 'Alan adında, şuraya yönlendirir';
$_LANG['a11yDomainCopyEpp']           = 'EPP kodunu panoya kopyala';
$_LANG['a11yDomainNsChoice']          = 'Ad sunucusu seçimi';
$_LANG['a11yDomainPricingCaption']    = 'Uzantıya göre alan adı fiyatlandırması';
$_LANG['a11yDomainCurrencyLabel']     = 'Para birimi';
$_LANG['a11yDomainEnabled']           = 'etkin';
$_LANG['a11yDomainDisabled']          = 'devre dışı';
$_LANG['a11yDomainBulkNsAffect']      = 'Bu değişiklik aşağıdaki alan adlarını etkiler';
$_LANG['a11yDomainBulkContactAffect'] = 'Bu değişiklik aşağıdaki alan adlarını etkiler';

// WS-B: Hesap / Profil / Güvenlik / Kişiler / Kullanıcılar
$_LANG['wsb']['required']              = 'zorunlu';
$_LANG['wsb']['ssoToggleLabel']        = 'Tek oturum açmayı etkinleştir';
$_LANG['wsb']['marketingOptInLabel']   = 'Posta listemize katılın';
$_LANG['wsb']['inviteEmailLabel']      = 'E-posta adresiyle kullanıcı davet et';
$_LANG['wsb']['permissionsGroupLabel'] = 'Davet izinleri';
$_LANG['wsb']['emailStatusNotVerified'] = 'E-posta adresi doğrulanmamış';
$_LANG['wsb']['emailStatusVerified']   = 'E-posta adresi doğrulandı';
$_LANG['wsb']['subUserTableCaption']   = 'Alt hesap kullanıcıları ve bekleyen davetler';

/* === WS-G Dashboard / Misc / Errors / OAuth / Standalone === */

// clientareaemails — tablo başlığı + eylemler sütun başlığı
$_LANG['a11yEmailsTableCaption']     = 'E-posta geçmişiniz';
$_LANG['a11yEmailsActions']          = 'İşlemler';

// 3dsecure — iframe başlığı
$_LANG['a11y3dSecureFrame']          = '3D Secure kimlik doğrulama';

// oauth/login-twofactorauth — yedek kod giriş etiketi
$_LANG['a11yBackupCodeLabel']        = 'Yedek kod';

// oauth/error — ekran okuyucu h1
$_LANG['a11yOauthError']             = 'OAuth hatası';

// forwardpage — canlı bölge + noscript
$_LANG['a11yRedirectingPlease']      = 'Yönlendiriliyor, lütfen bekleyin…';
$_LANG['a11yJsRequiredForPayment']   = 'Ödeme yönlendirmesini tamamlamak için JavaScript gereklidir. Lütfen JavaScript\'i etkinleştirip sayfayı yeniden yükleyin.';

/* === WS-Z Axe sweep fixes === */
$_LANG['a11yDomainSearchLabel']      = 'Alan adı ara';

/* === WS-H Cart === */
$_LANG['a11yCartConfigOptionsGroup'] = 'Yapılandırılabilir seçenekler';
$_LANG['a11yCartDomainOptionGroup']  = 'Alan adı kayıt seçeneği';
$_LANG['a11yCartNameserversGroup']   = 'Özel ad sunucuları';
$_LANG['a11yCartDomainAddonsGroup']  = 'Alan adı ek hizmetleri';
$_LANG['a11yCartPaymentMethodGroup'] = 'Ödeme yöntemi';
$_LANG['a11yCartCreditCardGroup']    = 'Kredi kartı bilgileri';
$_LANG['a11yCartApplyCreditGroup']   = 'Hesap bakiyesi';
$_LANG['a11yCartDomainResults']      = 'Alan adı arama sonuçları';
$_LANG['a11yCartOrderSummaryRegion'] = 'Sipariş özeti';
$_LANG['a11yCartAddDomainToCart']    = '%s sepete ekle';
$_LANG['a11yCartDomainAdded']        = '%s sepete eklendi';
$_LANG['a11yCartDomainUnavailable']  = '%s kullanılamıyor';
$_LANG['a11yCartQuantityFor']        = '%s için miktar';
$_LANG['a11yCartPromoCodeLabel']     = 'Promosyon kodu';
$_LANG['a11yCartRegistrantContact']  = 'Alan adı kayıt sahibi iletişim';
$_LANG['a11yCartSecurityQuestion']   = 'Güvenlik sorusu';
$_LANG['a11yCartAccountSelect']      = 'Bu sipariş için hesap seçin';
$_LANG['a11yCartCvvHelp']            = 'Bu nedir?';

/* === WS-F Task 6: Announcements / server status === */
$_LANG['announcementsnavlabel']      = 'Duyuru gezintisi';
$_LANG['announcementShareTwitter']   = 'X (Twitter) üzerinde paylaş, yeni pencerede açılır';
$_LANG['announcementNewWindow']      = '(yeni pencerede açılır)';
$_LANG['serverstatusChecking']       = 'Kontrol ediliyor…';
$_LANG['networkIssuesNavLabel']      = 'Ağ sorunları gezintisi';

/* === WS-I Affiliates === */
$_LANG['a11yAffiliatesCommissionSummary'] = 'Komisyon ve bakiye özeti';
$_LANG['a11yAffiliatesReferralsList']     = 'Yönlendirmeler listesi';
