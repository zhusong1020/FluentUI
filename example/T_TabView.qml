﻿import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import QtQuick.Window
import FluentUI

FluScrollablePage{

    title:"TabView"
    leftPadding:10
    rightPadding:10
    bottomPadding:20

    property var colors : [FluColors.Yellow,FluColors.Orange,FluColors.Red,FluColors.Magenta,FluColors.Purple,FluColors.Blue,FluColors.Teal,FluColors.Green]

    Component{
        id:com_page
        Rectangle{
            anchors.fill: parent
            color: argument
        }
    }

    function newTab(){
        tab_view.appendTab("qrc:/res/image/favicon.ico","Document "+tab_view.count(),com_page,colors[Math.floor(Math.random() * 8)].dark)
    }

    Component.onCompleted: {
        newTab()
        newTab()
        newTab()
    }

    FluArea{
        width: parent.width
        Layout.topMargin: 20
        height: 50
        paddings: 10
        RowLayout{
            spacing: 14
            FluDropDownButton{
                id:btn_tab_width_behavior
                Layout.preferredWidth: 140
                text:"Equal"
                items:[
                    FluMenuItem{
                        text:"Equal"
                        onClicked: {
                            btn_tab_width_behavior.text = text
                            tab_view.tabWidthBehavior = FluTabView.Equal
                        }
                    },
                    FluMenuItem{
                        text:"SizeToContent"
                        onClicked: {
                            btn_tab_width_behavior.text = text
                            tab_view.tabWidthBehavior = FluTabView.SizeToContent
                        }
                    },
                    FluMenuItem{
                        text:"Compact"
                        onClicked: {
                            btn_tab_width_behavior.text = text
                            tab_view.tabWidthBehavior = FluTabView.Compact
                        }
                    }
                ]
            }
            FluDropDownButton{
                id:btn_close_button_visibility
                text:"Always"
                 Layout.preferredWidth: 120
                items:[
                    FluMenuItem{
                        text:"Nerver"
                        onClicked: {
                            btn_close_button_visibility.text = text
                            tab_view.closeButtonVisibility = FluTabView.Nerver
                        }
                    },
                    FluMenuItem{
                        text:"Always"
                        onClicked: {
                            btn_close_button_visibility.text = text
                            tab_view.closeButtonVisibility = FluTabView.Always
                        }
                    },
                    FluMenuItem{
                        text:"OnHover"
                        onClicked: {
                            btn_close_button_visibility.text = text
                            tab_view.closeButtonVisibility = FluTabView.OnHover
                        }
                    }
                ]
            }
        }
    }

    FluArea{
        width: parent.width
        Layout.topMargin: 5
        height: 400
        paddings: 10
        FluTabView{
            id:tab_view
            onNewPressed:{
                newTab()
            }
        }
    }

}
