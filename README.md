# BackEnd Fiscal Cidadão [![Build Status](https://travis-ci.org/ivaldi/brimir.png)](https://travis-ci.org/ivaldi/brimir) [![Coverage Status](https://coveralls.io/repos/ivaldi/brimir/badge.png)](https://coveralls.io/r/ivaldi/brimir)
======

## TODO Back End

1. Add lat e long e demais campos pro ticket do Fiscal Cidadão no model do backend
2. Colocar o geocoder pra a partir da latitude e api do google descobrir municipio, bairro e endereço
3. Criar a regra de roteamento apartir do label
4. Criar emails padrão para disparo
5. Testar servidor de email do governo
6. Dashboard com mapa de cada 'evento'
7. Enviar Push a cada alteração de status

## TODO API

1. Logar [OK]
2. Criar Ticket com Usuario [Ok]
3. Criar Ticket Anonimo [Ok]
4. Enviar imagem Base64 (string) [ok]

5. GET Lista dos Meus tickets
6. GET Historico das Mensagens de Cada Ticket
7. POST Adicionar mais informações


## TODO Mobile

1. Wire frame e Flow [Ok]

1. Tela Principal
2. Enviar Anonimo
3. Logar
4. Enviar logado
5. Lista De Tickets Abertos
6. Historico de um Tickets
7. Envio de novas informações pro ticket.


## Fluxo Base

a) Cada aplicativo tem um label especifico que é inserido via API, chegou com label roteia pro time.

b) a partir da long e lat roda o geocoder e adiciona o enderço do evento

c) com o municipio e o tipo de ocorrencia o motor de regra roteia pra uma determinada equipe





Installation
------------
Brimir is a rather simple Ruby on Rails application. The only difficulty in setting things up is how to get incoming email to work. See the next section for details.

Any Rails application needs a web server with Ruby support first. We use Phusion Passenger (`mod_rails`) ourselves, but you can also use Thin, Puma or Unicorn. Phusion Passenger can be installed for Nginx or Apache, you can chose wichever you like best. The installation differs depending on your distribution, so have a look at their [Nginx installation manual](https://www.phusionpassenger.com/documentation/Users%20guide%20Nginx.html) or their [Apache installation manual](https://www.phusionpassenger.com/documentation/Users%20guide%20Apache.html).

After setting up a webserver, you have to create a database for Brimir and modify the config file in `config/database.yml` to reflect the details. Set your details under the production section. We advise to use `adapter: postgresql` or `adapter: mysql2` for production usage, because those are the only two adapters and database servers we test. *If you plan to use MySQL, make sure you use utf8 as your charset and collation.*

Next up: configuring your outgoing email address and url. This can be set in `config/environments/production.rb` by adding the following lines *before* the keyword `end`:

    config.action_mailer.default_options = { from: 'brimir@yoururl.com' }

    config.action_mailer.default_url_options = { host: 'brimir.yoururl.com' }

Now install the required gems by running the following command if you want **PostgreSQL support**:

    bundle install --without sqlite mysql development test --deployment

Run the following command to install gems if you want **MySQL support**:

    bundle install --without sqlite postgresql development test --deployment

Generate a secret\_key\_base in the secrets.yml file:

    LINUX: sed -i "s/<%= ENV\[\"SECRET_KEY_BASE\"\] %>/`bin/rake secret`/g" config/secrets.yml
    MAC: sed -i "" "s/<%= ENV\[\"SECRET_KEY_BASE\"\] %>/`bin/rake secret`/g" config/secrets.yml

Next, load the database schema and precompile assets:

    bin/rake db:schema:load RAILS_ENV=production
    bin/rake assets:precompile RAILS_ENV=production

If you want to use LDAP, configure config/ldap.yml accordingly, then change the auth strategy in your application config in file config/application.rb:

    config.devise_authentication_strategy = :ldap_authenticatable

(Optional for LDAP) Last thing left to do before logging in is making a user and adding some statuses. You can do this by running:

    bin/rails console production
    u = User.new({ email: 'rmhulle@gmail.com', password: 'rmh25051985', password_confirmation: 'rmh25051985' }); u.agent = true; u.save!

t = Tenant.new({ domain: 'b55f8da2.ngrok.io', from: 'support@b55f8da2.ngrok.io', default_time_zone: "Brasilia", ignore_user_agent_locale: false, default_locale: "pt-BR")




Updating
--------
First download the new code in the same directory by unpacking a release tarball or by running `git pull` (when you cloned the repo earlier). After updating code run the following commands to install necessary gem updates, migrate the database and regenerate precompiled assets.

    bundle install
    bin/rake db:migrate RAILS_ENV=production
    bin/rake assets:precompile RAILS_ENV=production

Don't forget to restart your application server (`touch tmp/restart.txt` for Passenger).

Customization
-------------
Some applicant level configuration can be set through `config/settings.yml`

Brimir is available in several languages. By default, it will use the locale corresponding to the user browser agent, if it was among the supported locales. If you want to change this and force certain locale, you can do that by setting:   `ignore_user_agent_locale: true`  in  `config/settings.yml`

Incoming email
--------------
Incoming emails can be posted to the tickets url by using the script found in scripts/post-mail. Create an alias in your `/etc/aliases` file like this:

    brimir: "|/bin/sh /path/to/your/brimir/repo/script/post-mail http://yoururl.com/tickets.json"

Now sending an email to brimir@yoururl.com should start curl and post the email to your brimir installation.

Contributing
------------
We appreciate all contributions! If you would like to contribute, please follow these steps:
- Fork the repo.
- Create a branch with a name that describes the change.
- Make your changes in the branch.
- Submit a pull-request to merge your feature-branch in our master branch.

Requested features
------------------
Some users have made requests for the following features. If you would like to contribute, you could add any of these.
- Allowing customers to update ticket status, with correct email notifications.
- Switchable property to support threads by using special tags in the subject line instead of relying on mail headers.
- Support for hosted incoming mail services (Sendgrid, Mandrill), possibly using griddler gem.
- Ability to sign in using a Single Sign On functionality based on Shared Token or JWT.
- Private note addition to tickets.
- Automated replies based on the current rule system.
- Remove user functionality, without losing ticket and reply information.
- Adding knowledge base functionality.
- Welcome mail for new users (after mailing a ticket for example) with their password.
- Set priority, assignee and labels on the create ticket form.
- Assign tickets to groups of users
- When replying, select a response from pre-defined canned responses and modify to your needs
- TicketsController#create should limit access to IP and be user/pass protected
- TicketsController#new should be configurable as open-to-the-world or not
- Integration with OpsWeekly
- Social media integration such as FreshDesk and Zoho have (reply to requests via social media)
- Ticket creation api (and improving existing api)
- Unread ticket status per user.
- Ticket search that also searches in from field and replies.
- Mark tickets as duplicate, linking it to the duplicated ticket.
- Ability to rename tickets (change their subject).
- Ability to rename labels.
- Improve rule form to allow only valid statuses (#150).
- A better WYSIWYG editor, for example QuilJS (#172).
- Timed rules, such as re-assigning when no reply is added withing 24 hours (#203).
- Desktop notifications using web notifications (#218).
- Custom ticket statuses, all via database. (#217)
- Filter on to/cc/bcc without verified addresses. (#227)
- Add captcha for non-signed in ticket creation. (#228)
- IMAP or POP3 pull mechanism for new tickets. (#249)

License
-------
Brimir is licensed under the GNU Affero General Public License Version 3.

IMG base64

data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAAH4AAAAuCAYAAADura1/AAAAGXRFWHRTb2Z0d2FyZQBBZG9iZSBJbWFnZVJlYWR5ccllPAAAA2hpVFh0WE1MOmNvbS5hZG9iZS54bXAAAAAAADw/eHBhY2tldCBiZWdpbj0i77u/IiBpZD0iVzVNME1wQ2VoaUh6cmVTek5UY3prYzlkIj8+IDx4OnhtcG1ldGEgeG1sbnM6eD0iYWRvYmU6bnM6bWV0YS8iIHg6eG1wdGs9IkFkb2JlIFhNUCBDb3JlIDUuMy1jMDExIDY2LjE0NTY2MSwgMjAxMi8wMi8wNi0xNDo1NjoyNyAgICAgICAgIj4gPHJkZjpSREYgeG1sbnM6cmRmPSJodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjIj4gPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9IiIgeG1sbnM6eG1wTU09Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC9tbS8iIHhtbG5zOnN0UmVmPSJodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvc1R5cGUvUmVzb3VyY2VSZWYjIiB4bWxuczp4bXA9Imh0dHA6Ly9ucy5hZG9iZS5jb20veGFwLzEuMC8iIHhtcE1NOk9yaWdpbmFsRG9jdW1lbnRJRD0ieG1wLmRpZDowNjgwMTE3NDA3MjA2ODExODA4M0YyNjQ0QTY5QjQ5OCIgeG1wTU06RG9jdW1lbnRJRD0ieG1wLmRpZDpFNERCRDdGQUUyNDIxMUU1QTQ3QzhDQUVEQ0RFQkRDRCIgeG1wTU06SW5zdGFuY2VJRD0ieG1wLmlpZDpFNERCRDdGOUUyNDIxMUU1QTQ3QzhDQUVEQ0RFQkRDRCIgeG1wOkNyZWF0b3JUb29sPSJBZG9iZSBQaG90b3Nob3AgQ1M2IChNYWNpbnRvc2gpIj4gPHhtcE1NOkRlcml2ZWRGcm9tIHN0UmVmOmluc3RhbmNlSUQ9InhtcC5paWQ6MDE4MDExNzQwNzIwNjgxMTgwODNDQzEzNjU2QzE3NUIiIHN0UmVmOmRvY3VtZW50SUQ9InhtcC5kaWQ6MDY4MDExNzQwNzIwNjgxMTgwODNGMjY0NEE2OUI0OTgiLz4gPC9yZGY6RGVzY3Jp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
