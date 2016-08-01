# 4d-tips-custom-url
Example of handling custom URL scheme in 4D 

##How it works

A small cocoa application is used to register and handle a set of custom URLs.

By default, the following schemes are captured: ``d4``, ``fourd``, ``dddd``.

You can customise them by editing ``Info.plist`` of the "url-redirect" app.

<img width="418" alt="2016-08-01 18 32 21" src="https://cloud.githubusercontent.com/assets/1725068/17289833/65394a98-5816-11e6-87d2-537bdb731947.png">

The "url-redirect" app is designed to simply post a distributed notification.

By default, the notification name is ``com.4d.test``.

You can change it in the ``Info.plist`` too; the key name is ``URTargetNotificationIdentifier``.

