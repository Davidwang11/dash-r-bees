# How to deploy a Dash-R app to Heroku

This repo contains the necessary files for deploying a Dash-R app to Heroku.
The deployed app is hosted here https://dashr-heroku-deployment-demo.herokuapp.com/.

Steps to reproduce:


1. `git clone https://github.com/Davidwang11/dash-r-bees.git`
2. `cd dash-r-bees`
3. `heroku create --stack container your-heroku-site`
4. `git push heroku main`
5. Wait ~15 min for the build to finish.
6. `heroku ps:scale web=1`
7. Navigate to `https://you-heroku-site.herokuapp.com` in your browser
8. https://dsci532ia2tianweiwang.herokuapp.com/