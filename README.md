# ENVGadgetFW

# ENV Gadget

Compatible Plaforms iOS

# Intro

ENV Gadget is a framework that helps you to easily manage the service end-points, service keys and other constants.

# Configuration

Add your project root directory to the config file named data.json. This file contains what you have needed for your app. This can be service endpoint, authentication keys or others.

# Configuration Structure

The JSON file begins with the list object that includes all child lists. The child list item has three params. These are key, value and selected.

<b>the key keep readable row name,</b>
<b>the value keep row value,</b>
<b>and then selected to keep the state of the currently selected row.</b>

```
{
   "list":[
      {
         "key":"Service URLs",
         "childList":[
            {
               "key":"Live",
               "value":"https://auth.example.com/live/",
               "selected":true
            },
            {
               "key":"Test",
               "value":"https://auth.example.com/test/",
               "selected":false
            },
            {
               "key":"Dev",
               "value":"https://auth.example.com/dev/",
               "selected":false
            }
         ]
      }
   ]
}

```



# Adding Project

Drag and drop the downloaded framework to project root directory

or
```
pod 'ENVGadgetFW', '~> 1.1'

```


And then import framework like below

```
import ENVGadgetFW

```


In-home or main controller call the singleton method below
```
ENVGadgetManager.shared.adjustGadget()
```

if you want the selected row's value, you can call the singleton method below by the row's key
```
let selectedServiceURLs = ENVGadgetManager.shared.getValueBy(key: "Service URLs")
```

# Usage
The framework selection interface is using with a swipe gesture recognizer. This swipe direction should be the right direction and by the two fingers. The Recognizer work anywhere in the app.

👥 Credits

Made with ❤️ at <a target="blank" href="https://loodos.com.tr">Loodos Tech.</a>

# 📄 License
ENV Gadget is available under the MIT license. See the <a target="blank" href="https://raw.githubusercontent.com/batikansosun/ENV_Gadget/master/LICENSE">LICENSE</a> file for more info.
