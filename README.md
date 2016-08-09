# 4d-tips-custom-url
Example of handling custom URL scheme in 4D

##How it works

A small cocoa application is used to register and handle a set of custom URLs.

By default, the following schemes are captured: ``d4``, ``fourd``, ``dddd``.

You can customise them by editing ``Info.plist`` of the "url-redirect" app.

<img width="500" alt="2016-08-01 18 32 21" src="https://cloud.githubusercontent.com/assets/1725068/17289833/65394a98-5816-11e6-87d2-537bdb731947.png">

The "url-redirect" app is designed to simply post a distributed notification.

By default, the notification name is ``com.4d.test``.

You can change it in the ``Info.plist`` too; the key name is ``URTargetNotificationIdentifier``.

4D can receive this notification by calling the plugin method to register the same notification:

```
Notification ADD OBSERVER ("com.4d.test")
```

You can register as many notifications as you like, but you can only install one callback method.

```
Notification SET METHOD ("mycallback")
```

In case of a custom URL redirected by the helper app, $1 = the notification name (e.g. "com.4d.test"), $2 = "url", $3 = the full URL

In the case of using "Notification POST" (see Tip below), the callback method will receive three arguments $1 = the notification name (e.g. "com.4d.test"), $2 = the keys separated by "\n", $3 = the values separated by ""\n"

<img width="500" alt="2016-08-01 18 53 21" src="https://cloud.githubusercontent.com/assets/1725068/17290409/4b4ce574-5819-11e6-8e6d-937b4ebb0868.png">


###Tip

You can also post a notification directly from 4D, without using a custom URL. This is a convenient way to let 4D talk to another 4D locally.

```
ARRAY TEXT($keys;3)
ARRAY TEXT($values;3)

$keys{1}:="foo"
$values{1}:="bar"

$keys{2}:="foo2"
$values{2}:="bar2"

Notification POST ("com.4d.test";$keys;$values)
```

###4D Server Client Suggestions
It seems to work best to store the url-redirct.app in the server's Resources folder. That automatically get's populated into clients ~/Library/Cache/4D folder. The url-redirct.app is in the package of the "Notifications.4dbase". Be sure to remove macOS Gatekeeper extended attributes or users will get warnings!
```
xattr -d com.apple.quarantine /path/to/url-redirct.app
```
Copy the "Notification.bundle" from Plugins folder of the "Notifications.4dbase" package to the Server Plugins folder.

In the On Startup method (which only runs on clients) open the url-redirct.app, add observer, and set method of the callback:
```
SET ENVIRONMENT VARIABLE("_4D_OPTION_CURRENT_DIRECTORY";Get 4D folder(Current resources folder))
SET ENVIRONMENT VARIABLE("_4D_OPTION_BLOCKING_EXTERNAL_PROCESS";"FALSE")
LAUNCH EXTERNAL PROCESS("open url-redirct.app")
Notification ADD OBSERVER ("com.4d.test")
Notification SET METHOD ("mycallback")
```

The method "mycallback" will now receive the full url in $3 when a URL is clicked on: e.g. "d4://customer/1/"

##Demo

Run the application. An HTML page is opened.

<img width="500" alt="2016-08-01 19 08" src="https://cloud.githubusercontent.com/assets/1725068/17290834/70b429f6-581b-11e6-811c-8d8e676f2500.png">

Click on a link. An alert is displayed.

Note that the web server is not running.

<img width="500" alt="2016-08-01 19 09 01" src="https://cloud.githubusercontent.com/assets/1725068/17290856/834392a0-581b-11e6-94ea-c1594e15051f.png">
