# Elastic Beanstalk

This is a guide to deploy and connect to your app with [Amazon Elastic Beanstalk](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/Welcome.html).

## What do you need to deploy or connect

You need the following files to be able to deploy:
  - `.elasticbeanstalk/config.yml` inside your project's directory
  - The private ssh key (a file with `.pem` extension) indicated in the [.elasticbeanstalk/config.yml](.elasticbeanstalk/config.yml) file under the `global/default_ec2_keyname` key. You need to add this file to your `~/.ssh` directory with 600 permissions (`chmod 600 <file-name>.pem`).
  - The `~/.aws/config` file with the following format:

    ```
      [default]
      region = us-east-1
      [profile utilityapi]
      aws_access_key_id = <your-access-key>
      aws_secret_access_key = <your-secret-access-key>
    ```
    The `profile` name should match with the one in the [.elasticbeanstalk/config.yml](.elasticbeanstalk/config.yml) file under the `global/profile` key. The two keys should be those provided by the [Amazon IAM Service](https://aws.amazon.com/documentation/iam/).

## How to deploy or connect

First you need to install the Elastic Beanstalk CLI following [this](http://docs.aws.amazon.com/elasticbeanstalk/latest/dg/eb-cli3-install.html) link.

You can deploy to the different environments running the following:

```bash
    > eb deploy <environment>
```

You can connect to the EC2 instance by running the following:

```bash
    > eb ssh <environment>
```

Where *environment* is the name of the environment that you can find in the [.elasticbeanstalk/config.yml](.elasticbeanstalk/config.yml) file under the `environment` key

### Logs

You can find all the standard logs under the `/var/log/` folder. To see the last activity run:

```bash
    > tail -80f /var/log/eb-activity.log
```

Access the Rails server log by running the following:

- For a _staging_ environment

```bash
    > /var/app/current/logs/staging.log
```

- For _production_ environment

```bash
    > tail -80f /var/log/puma/puma.log
```

Access the Sidekiq log by running the following:

```bash
    > tail -80f /var/app/containerfiles/logs/sidekiq.log
```

### Rails Console

To run `rails c` first connect to to the EC2 instance and `cd /var/app/current`. Then run `sudo script/aws-console`

## Configuration files

You can find the Elastic Beanstalk files in the [.ebextensions](.ebextensions) folder.

# Heroku

If you want to deploy your app using [Heroku](https://www.heroku.com) you need to do the following:

- Add the Heroku Git URL to your remotes

```bash
  git remote add heroku-prod your-git-url
```

- Configure the Heroku build packs and specify an order to run the npm-related steps first

```bash
  heroku buildpacks:clear
  heroku buildpacks:set heroku/nodejs
  heroku buildpacks:add heroku/ruby --index 2
```

- Push to Heroku

```bash
	git push heroku-prod your-branch:master
```
