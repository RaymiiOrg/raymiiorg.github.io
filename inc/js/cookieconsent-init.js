window.addEventListener('load', function () {
    // obtain cookieconsent plugin
    var cookieconsent = initCookieConsent();

    // run plugin with config object
    cookieconsent.run({
        autorun: true,
        current_lang: 'en',
        autoclear_cookies: false,
        hide_from_bots: false,
        page_scripts: true,

        onFirstAction: function(user_preferences, cookie){
            // callback triggered only once
        },

        onAccept: function (cookie) {
            // ... cookieconsent accepted
        },

        onChange: function (cookie, changed_preferences) {
            // ... cookieconsent preferences were changed
        },

        languages: {
            en: {
                consent_modal: {
                    title: 'Cookie popup',
                    description: 'Hi, this website uses cookies to understand how you interact with it and to serve advertisements. <a aria-label="Cookie policy" class="cc-link" href="/s/static/Cookie_Privacy_Policy.html">Read more</a>',
                    primary_btn: {
                        text: 'Accept',
                        role: 'accept_all'              // 'accept_selected' or 'accept_all'
                    },
                    secondary_btn: {
                        text: 'Settings',
                        role: 'settings'                // 'settings' or 'accept_necessary'
                    }
                },
                settings_modal: {
                    title: 'Cookie preferences',
                    save_settings_btn: 'Save settings',
                    accept_all_btn: 'Accept all',
                    reject_all_btn: 'Reject all',       // optional, [v.2.5.0 +]
                    cookie_table_headers: [
                        {col1: 'Name'},
                        {col2: 'Domain'},
                        {col3: 'Expiration'},
                        {col4: 'Description'},
                        {col5: 'Type'}
                    ],
                    blocks: [
                        {
                            title: 'Cookie usage',
                            description: 'This site use cookies to track website statistics and serve advertisements. You can choose for each category to opt-in/out whenever you want.'
                        }, {
                            title: 'Analytics cookies',
                            description: 'These cookies collect information about how you use the website, which pages you visited and which links you clicked on.',
                            toggle: {
                                value: 'analytics',
                                enabled: true,
                                readonly: false
                            },
                            cookie_table: [
                                {
                                    col1: '^_ga',
                                    col2: 'google.com',
                                    col3: '2 years',
                                    col4: 'Google Analytics 1',
                                    col5: 'Permanent cookie',
                                    is_regex: true
                                },
                                {
                                    col1: '_gid',
                                    col2: 'google.com',
                                    col3: '1 day',
                                    col4: 'Google Analytics 2',
                                    col5: 'Permanent cookie'
                                }
                            ]
                        }, 
                        {
                            title: 'Advertisement & Marketing',
                            description: 'Marketing cookies are used for tracking browsing activity and to customise and display ads that are relevant and engaging.',
                            toggle: {
                                value: 'ads',
                                enabled: true,
                                readonly: false
                            },
                            cookie_table: [
                                {
                                    col1: '__gpi',
                                    col2: 'google.com',
                                    col3: '13 months',
                                    col4: 'Google Ads',
                                    col5: 'Permanent cookie',
                                    is_regex: true
                                },
                                {
                                    col1: '__gsas',
                                    col2: 'google.com',
                                    col3: '3 months',
                                    col4: 'Google Ads',
                                    col5: 'Permanent cookie'
                                },{
                                    col1: '__gpi_optout',
                                    col2: 'google.com',
                                    col3: '13 months',
                                    col4: 'Google Ads',
                                    col5: 'Permanent cookie'
                                },{
                                    col1: 'NID',
                                    col2: 'google.com',
                                    col3: '6 months',
                                    col4: 'Google Ads',
                                    col5: 'Permanent cookie'
                                },{
                                    col1: 'DSID',
                                    col2: 'google.com',
                                    col3: '2 weeks',
                                    col4: 'Google Ads',
                                    col5: 'Permanent cookie'
                                },{
                                    col1: 'id',
                                    col2: 'google.com',
                                    col3: '13 months',
                                    col4: 'Google Ads',
                                    col5: 'Permanent cookie'
                                },{
                                    col1: ' __gads',
                                    col2: 'google.com',
                                    col3: '13 months',
                                    col4: 'Google Ads',
                                    col5: 'Permanent cookie'
                                },{
                                    col1: 'GED_PLAYLIST_ACTIVITY',
                                    col2: 'google.com',
                                    col3: '-',
                                    col4: 'Google Ads',
                                    col5: 'Session cookie'
                                }
                            ]
                        }, {
                            title: 'More information',
                            description: 'For any queries in relation to my policy on cookies and your choices, please <a class="cc-link" href="/s/static/Cookie_Privacy_Policy.html">see the cookie policy for information and contact data</a>.',
                        }
                    ]
                }
            }
        }
    });
});