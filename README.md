## description
This image is used to quickly deploy a drupal website. Including below features.
1. base on drupal official docker image.
2. php composer supported.
3. drupal console supported
4. drush support
5. install drupal to sqlite by default.
6. install vi/vim.


## usage:
```
## run drupal website
docker run -d -p 8080:80 --name quick-drupal zterry95/drupal-quick
## using composer/drush/drupal console
docker exec -it quick-drupal bash 
drush
```
* Then visit http://localhost:8080 to view drupal website.
> username: admin
> password: admin

