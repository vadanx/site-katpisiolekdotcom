# Site Katpisiolekdotcom

Site Katpisiolekdotcom is a website built using Hugo to showcase a professional photography portfolio.

----

## Guide

### Install
- [git](https://git-scm.com/)
- [hugo](https://gohugo.io)

### Update

#### Images

Image files:

1. must be JPEGs

2. use the regular expression pattern `^(?<priority>[0-9]+)-(?<tag>[a-z-]+)\.jpg$` ([example](https://regex101.com/r/jd3Suc/1))

Regular expression pattern groups:

* `priority`: determines how high an image displays

* `tag`: determines which gallery an image displays in

Add new image files to directory `assets/images/`.

#### Categories

In order to update which categories are displayed, update `menu.main` inside `config.yaml`.

### Test

Run the following script:

```console
scripts/site-test.sh
```

### Deploy

Add, commit and push your changes:

```console
git add --all

git commit --message "Updating the website"

git push
```
