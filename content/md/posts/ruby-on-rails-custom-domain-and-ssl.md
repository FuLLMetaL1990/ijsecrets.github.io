{:title       "Ruby on Rails: Custom Domain and SSL"
 :layout      :post
 :summary     "This guide aims to make a deployed Rails app on Heroku to point to a user-facing endpoint."
 :excerpt     "Make a deployed Rails app on Heroku point to a user-facing endpoint."
 :description "Deploy Rails app on Heroku to a user-facing endpoint."
 :date        "2019-10-27"
 :tags        ["deployment"
               "heroku"
               "namecheap"
               "lets-encrypt"]}

-------------------------------------------------------------------------------

Once we have a deployed Rails app on Heroku, it would more pleasant if users (including us) can have a unique presence on the web.

At the end of this guide, we'll have a unique endpoint using a custom domain from Namecheap with a free SSL from Let’s Encrypt.

-------------------------------------------------------------------------------

Custom Domain
-------------

**Note:** A verified Heroku account is required (see [How to verify your Heroku account](https://devcenter.heroku.com/articles/account-verification#how-to-verify-your-heroku-account)).

### Heroku ###

1. [Login](https://id.heroku.com/login)
2. Go to app's **Settings** (`/apps/<app>/settings`)
3. On **Domains**, click **Add domain**
4. On **Domain name**, type domain (e.g. `<app>.<tld>`)
5. Click **Next**
6. Copy the generated characters from **DNS target**

### Namecheap ###

1. [Login](https://www.namecheap.com/myaccount/login)
2. Go to domain's **Advance DNS** (`/Domains/DomainControlPanel/<domain>/advancedns`)
3. On **HOST RECORDS**, click **ADD NEW RECORD**
4. On **Type**, select `ALIAS Record`
5. On **Host**, type `@`
6. On **Value**, type the generated characters from Heroku
7. Click the checkbox icon to save
8. Remove default **HOST RECORDS**

   - `parkingpage.namecheap.com`
   - `http://www.<domain>/?from`


### www subdomain ###

Do the same steps for `www`, except:

- On **Domain name**, prefix domain with `www.` (e.g. `www.<app>.<tld>`)
- On **Type**, select `CNAME Record`
- On **Host**, type `www`

Visiting the following URLs should go to the `<app>`:

- `<domain>`
- `http://<domain>`

-------------------------------------------------------------------------------

SSL
---

### Heroku ###

1. Go to app's **Resources** (`/apps/<app>/resources`)
2. On **Free Dynos**, click **Change Dyno Type**
3. On **Select Tier**, select **Hobby**, then click **Save**
4. Go back to app's **Settings** (`/apps/<app>/settings`)
5. On **SSL certificates**, click **Configure SSL**
6. Select **Automatically ...**, then click **Continue**
7. Click **I've done this**
8. Click **Continue**

Visiting `https://<domain>` should go to the SSL-enabled `<app>`.

-------------------------------------------------------------------------------

Redirect non-https to https
---------------------------

### Ruby on Rails ###

1. Update `production.rb`:

   ``` ruby
# File: config/environments/production.rb
...
config.force_ssl = true
...
```

Visiting `http://<domain>` should redirect to `https://<domain>`.

-------------------------------------------------------------------------------

Redirect www to non-www
-----------------------

### Ruby on Rails ###

1. Update `config/routes.rb`:

   ``` ruby
# File: config/routes.rb
Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  match '(*any)',
        to: redirect(subdomain: ''),
        via: :all,
        constraints: { subdomain: 'www' }
  ...
end
```

Visiting `www.<domain>` should redirect to `<domain>`.

**Congratulations!** We now have a live Rails app with Custom Domain and SSL :)
