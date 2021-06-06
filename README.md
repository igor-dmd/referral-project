### Referral Project

This is a small API application that provides some endpoints and business logic to allow customer creation and a referral process.


##### Prerequisites

- Git
- Ruby [2.7.0]
- Rails [6.1.3]
- PostgreSQL [13.3.3]

##### 1. Check out the repository

```bash
git clone git@github.com:igor-dmd/referral-project.git
```

##### 2. Change the DB credentials under the config/application.yml file

Enter you PostgreSQL credentials (user and password) on the application.yml correspondent fields.

```yml
# The credentials used for the database connection
DB_USERNAME: ''
DB_PASSWORD: ''
```

Other configuration information can also be modified in this file.

##### 3. Create and setup the database

Run the following commands to create and setup the database.

```bash
bundle exec rake db:create
bundle exec rake db:migrate
```

##### 4. Start the Rails server

You can start the rails server using the command given below.

```bash
bundle exec rails s
```

And now you can visit the site with the URL http://localhost:3000

##### [OPTIONAL] Run the tests

You can run the test suite with the following command.

```bash
bundle exec rails test
```