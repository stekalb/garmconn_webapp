import QtQuick 2.9
import Ubuntu.Components 1.3
import QtQuick.Window 2.2
import Morph.Web 0.1
import "UCSComponents"
import QtWebEngine 1.7
import Qt.labs.settings 1.0
import QtSystemInfo 5.5
import "config.js" as Conf

MainView {
  id:window
  //
  // ScreenSaver {
  //   id: screenSaver
  //   screenSaverEnabled: !(Qt.application.active)
  // }

  objectName: "mainView"
  //theme.name: "Ubuntu.Components.Themes.SuruDark"
  backgroundColor: Conf.AppBackgroundColor
  applicationName: "gconnectwap.ste-kal"

  property string myTabletUrl: Conf.TabletUrl
  property string myMobileUrl: Conf.MobileUrl
  property string myTabletUA: Conf.TabletUA
  property string myMobileUA: Conf.MobileUA

  property string myUrl: (Screen.devicePixelRatio == 1.625) ? myTabletUrl : myMobileUrl
  //property string myUrl: "http://www.tagesanzeiger.ch"
  property string myUA: (Screen.devicePixelRatio == 1.625) ? myTabletUA : myMobileUA
  //"Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Ubuntu Chromium/67.0.3396.99 Chrome/67.0.3396.99 Safari/537.36"
  WebEngineView {
    id: webview
    anchors {
      fill: parent
    }
    //settings.localStorageEnabled: true
    //settings.allowFileAccessFromFileUrls: true
    //settings.allowUniversalAccessFromFileUrls: true
    //settings.appCacheEnabled: true
    settings.javascriptCanAccessClipboard: true
    settings.fullScreenSupportEnabled: true
    property var currentWebview: webview
    settings.pluginsEnabled: true

    onFullScreenRequested: function(request) {
      mainview.fullScreenRequested(request.toggleOn);
      nav.visible = !nav.visible
      request.accept();
    }
    property string test: writeToLog("DEBUG","my URL:", myUrl);
    property string test2: writeToLog("DEBUG","PixelRatio:", Screen.devicePixelRatio);
    function writeToLog(mylevel,mytext, mymessage){
      console.log("["+mylevel+"]  "+mytext+" "+mymessage)
      return(true);
    }

    profile:  WebEngineProfile {
      id: webContext
      persistentCookiesPolicy: WebEngineProfile.ForcePersistentCookies
      property alias dataPath: webContext.persistentStoragePath
      dataPath: dataLocation
      httpUserAgent: myUA
    }

    anchors {
      fill:parent
      centerIn: parent.verticalCenter
    }

    url: myUrl + "modern/#"
    userScripts: [
      WebEngineScript {
        injectionPoint: WebEngineScript.DocumentCreation
        worldId: WebEngineScript.MainWorld
        name: "QWebChannel"
        sourceUrl: "ubuntutheme.js"
      }
    ]
  }

  RadialBottomEdge {
    id: nav
    visible: true
    actions: [
      RadialAction {
        id: home
        iconName: "home"
        onTriggered: {
          webview.url = myUrl + "modern/#"
        }
        text: qsTr("Home")
      },
      RadialAction {
        id: reload
        iconName: "reload"
        onTriggered: {
          webview.reload()
        }
        text: qsTr("Reload")
      },
      RadialAction {
        id: activities
        iconSource: Qt.resolvedUrl("icons/002_trail.svg")
        onTriggered: {
          webview.url = myUrl + "modern/activities"
        }
        text: qsTr("Activities")
      },
      RadialAction {
        id: running
        iconSource: Qt.resolvedUrl("icons/001_running.svg")
        onTriggered: {
          webview.url = myUrl + "modern/activities?activityType=running"
        }
        text: qsTr("Running")
      },
      RadialAction {
        id: swimming
        iconSource: Qt.resolvedUrl("icons/003_swimming.svg")
        onTriggered: {
          webview.url = myUrl + "modern/activities?activityType=swimming"
        }
        text: qsTr("Swimming")
      },
      RadialAction {
        id: hiking
        iconSource: Qt.resolvedUrl("icons/004_hiking.svg")
        onTriggered: {
          webview.url = myUrl + "modern/activities?activityType=hiking"
        }
        text: qsTr("Hiking")
      },
      RadialAction {
        id: winter
        iconSource: Qt.resolvedUrl("icons/005_skihiking.svg")
        onTriggered: {
          webview.url = myUrl + "modern/activities?activityType=winter_sports"
        }
        text: qsTr("Winter Sports")
      },
      RadialAction {
        id: back
        enabled: webview.canGoBack
        iconName: "go-previous"
        onTriggered: {
          webview.goBack()
        }
        text: qsTr("Back")
      }
    ]
  }

  Connections {
    target: Qt.inputMethod
    onVisibleChanged: nav.visible = !nav.visible
  }
  Connections {
    target: webview

    onIsFullScreenChanged: {
      window.setFullscreen()
      if (currentWebview.isFullScreen) {
        nav.state = "hidden"
      }
      else {
        nav.state = "shown"
      }
    }

  }
  Connections {
    target: window.webview
    onIsFullScreenChanged: window.setFullscreen(window.webview.isFullScreen)
  }

  function setFullscreen(fullscreen) {
    if (!window.forceFullscreen) {
      if (fullscreen) {
        if (window.visibility != Window.FullScreen) {
          internal.currentWindowState = window.visibility
          window.visibility = 5
        }
      } else {
        window.visibility = internal.currentWindowState
      }
    }
  }
}
