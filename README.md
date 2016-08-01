# 4d-tips-custom-url
Example of handling custom URL scheme in 4D 

##How it works

A small cocoa application is used to register and handle a set of custom URLs.

By default, the following schemes are captured: ``d4``, ``fourd``, ``dddd``.

You can customise them by editing ``Info.plist`` of the "url-redirect" app.

<img alt="2016-08-01 18 32 21" src="https://cloud.githubusercontent.com/assets/1725068/17289833/65394a98-5816-11e6-87d2-537bdb731947.png">

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

the callback method will receive three arguments; the notification name, and serialized array of userInfo keys and values. 

<img width="400" alt="2016-08-01 18 53 21" src="https://cloud.githubusercontent.com/assets/1725068/17290409/4b4ce574-5819-11e6-8e6d-937b4ebb0868.png">

In case of a custom URL redirected by the helper app, only 1 key-value pair is posted, where the key is "url" and the value is the URL.

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

##Demo

Run the application. An HTML page is opened.

<img width="504" alt="2016-08-01 19 08" src="https://cloud.githubusercontent.com/assets/1725068/17290834/70b429f6-581b-11e6-811c-8d8e676f2500.png">

Click on a link. An alert is displayed. 

Note that the web server is not running.

<img width="504" alt="2016-08-01 19 09 01" src="https://cloud.githubusercontent.com/assets/1725068/17290856/834392a0-581b-11e6-94ea-c1594e15051f.png">
