﻿import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Window 2.15
import FluentUI 1.0

Rectangle {

    id:root

    property color dividerColor: FluTheme.isDark ? Qt.rgba(77/255,77/255,77/255,1) : Qt.rgba(239/255,239/255,239/255,1)
    property color hoverColor: FluTheme.isDark ? Qt.rgba(68/255,68/255,68/255,1) : Qt.rgba(251/255,251/255,251/255,1)
    property color normalColor: FluTheme.isDark ? Qt.rgba(61/255,61/255,61/255,1) : Qt.rgba(254/255,254/255,254/255,1)
    property var window : Window.window

    property bool showYear: true

    color: {
        if(mouse_area.containsMouse){
            return hoverColor
        }
        return normalColor
    }
    height: 30
    width: 300
    radius: 4
    border.width: 1
    border.color: dividerColor

    MouseArea{
        id:mouse_area
        hoverEnabled: true
        anchors.fill: parent
        onClicked: {
            popup.showPopup()
        }
    }

    Rectangle{
        id:divider_1
        width: 1
        x:  parent.width/3
        height: parent.height
        color: dividerColor
        visible: showYear
    }


    Rectangle{
        id:divider_2
        width: 1
        x: showYear ? parent.width*2/3 :  parent.width/2
        height: parent.height
        color: dividerColor
    }

    FluText{
        id:text_year
        anchors{
            left: parent.left
            right: divider_1.left
            top: parent.top
            bottom: parent.bottom
        }
        visible: showYear
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text:"年"
    }


    FluText{
        id:text_month
        anchors{
            left: showYear ? divider_1.right : parent.left
            right: divider_2.left
            top: parent.top
            bottom: parent.bottom
        }
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text:"月"
    }


    FluText{
        id:text_day
        anchors{
            left: divider_2.right
            right: parent.right
            top: parent.top
            bottom: parent.bottom
        }
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
        text:"日"
    }

    Popup{
        id:popup
        background: Rectangle{
            width: 300
            radius: 4
            color: FluTheme.isDark ? Qt.rgba(51/255,48/255,48/255,1) : Qt.rgba(248/255,250/255,253/255,1)
            height: 340
            MouseArea{
                anchors.fill: parent
            }
            FluShadow{
                radius: 4
            }

            RowLayout{
                id:layout_content
                spacing: 0
                width: parent.width
                height: 300

                Component{
                    id:list_delegate

                    Item{
                        height:38
                        width:getListView().width

                        function getListView(){
                            if(type === 0)
                                return list_view_1
                            if(type === 1)
                                return list_view_2
                            if(type === 2)
                                return list_view_3
                        }


                        Rectangle{
                            anchors.fill: parent
                            anchors.topMargin: 2
                            anchors.bottomMargin: 2
                            anchors.leftMargin: 5
                            anchors.rightMargin: 5
                            color:  {
                                if(getListView().currentIndex === position){
                                    if(FluTheme.isDark){
                                        return  item_mouse.containsMouse ? Qt.darker(FluTheme.primaryColor.lighter,1.1) : FluTheme.primaryColor.lighter
                                    }else{
                                        return  item_mouse.containsMouse ? Qt.lighter(FluTheme.primaryColor.dark,1.1): FluTheme.primaryColor.dark
                                    }
                                }
                                if(item_mouse.containsMouse){
                                    return FluTheme.isDark ? Qt.rgba(63/255,60/255,61/255,1) : Qt.rgba(237/255,237/255,242/255,1)
                                }
                                return FluTheme.isDark ? Qt.rgba(51/255,48/255,48/255,1) : Qt.rgba(0,0,0,0)
                            }
                            radius: 3
                            MouseArea{
                                id:item_mouse
                                anchors.fill: parent
                                hoverEnabled: true
                                onClicked: {
                                    getListView().currentIndex = position
                                    if(type === 0){
                                        text_year.text = model
                                        list_view_2.model = generateMonthArray(1,12)
                                        text_month.text = list_view_2.model[list_view_2.currentIndex]

                                        list_view_3.model = generateMonthDaysArray(list_view_1.model[list_view_1.currentIndex],list_view_2.model[list_view_2.currentIndex])
                                        text_day.text = list_view_3.model[list_view_3.currentIndex]
                                    }
                                    if(type === 1){
                                        text_month.text = model
                                        list_view_3.model = generateMonthDaysArray(list_view_1.model[list_view_1.currentIndex],list_view_2.model[list_view_2.currentIndex])
                                        text_day.text = list_view_3.model[list_view_3.currentIndex]

                                    }
                                    if(type === 2){
                                        text_day.text = model
                                    }
                                }
                            }
                            FluText{
                                text:model
                                color: {
                                    if(getListView().currentIndex === position){
                                        if(FluTheme.isDark){
                                            return Qt.rgba(0,0,0,1)
                                        }else{
                                            return Qt.rgba(1,1,1,1)
                                        }
                                    }else{
                                        return FluTheme.isDark ? "#FFFFFF" : "#1A1A1A"
                                    }
                                }
                                anchors.centerIn: parent
                            }
                        }
                    }
                }

                ListView{
                    id:list_view_1
                    width: 100
                    height: parent.height
                    boundsBehavior:Flickable.StopAtBounds
                    ScrollBar.vertical: FluScrollBar {}
                    model: generateYearArray(1924,2048)
                    clip: true
                    visible: showYear
                    delegate: Loader{
                        property var model: modelData
                        property int type:0
                        property int position:index
                        sourceComponent: list_delegate
                    }
                    onCurrentIndexChanged: {
                        if(currentIndex!==-1){
                            list_view_1.positionViewAtIndex(currentIndex, ListView.NoPosition)
                        }
                    }
                }
                Rectangle{
                    width: 1
                    height: parent.height
                    color: dividerColor
                }
                ListView{
                    id:list_view_2
                    width: showYear ? 100 : 150
                    height: parent.height
                    clip: true
                    ScrollBar.vertical: FluScrollBar {}
                    boundsBehavior:Flickable.StopAtBounds
                    delegate: Loader{
                        property var model: modelData
                        property int type:1
                        property int position:index
                        sourceComponent: list_delegate
                    }
                    onCurrentIndexChanged: {
                        if(currentIndex!==-1){
                            list_view_2.positionViewAtIndex(currentIndex, ListView.NoPosition)
                        }
                    }
                }
                Rectangle{
                    width: 1
                    height: parent.height
                    color: dividerColor
                }
                ListView{
                    id:list_view_3
                    width:  showYear ? 100 : 150
                    height: parent.height
                    clip: true
                    ScrollBar.vertical: FluScrollBar {}
                    Layout.alignment: Qt.AlignVCenter
                    boundsBehavior:Flickable.StopAtBounds
                    delegate: Loader{
                        property var model: modelData
                        property int type:2
                        property int position:index
                        sourceComponent: list_delegate
                    }
                    onCurrentIndexChanged: {
                        list_view_3.positionViewAtIndex(currentIndex, ListView.NoPosition)
                    }
                }
            }

            Rectangle{
                width: parent.width
                height: 1
                anchors.top: layout_content.bottom
                color: dividerColor
            }

            Rectangle{
                id:layout_actions
                height: 40
                radius: 5
                color: FluTheme.isDark ? Qt.rgba(32/255,32/255,32/255,1) : Qt.rgba(243/255,243/255,243/255,1)
                anchors{
                    bottom:parent.bottom
                    left: parent.left
                    right: parent.right
                }

                Item {
                    id:divider
                    width: 1
                    height: parent.height
                    anchors.centerIn: parent
                }

                FluButton{
                    anchors{
                        left: parent.left
                        leftMargin: 20
                        rightMargin: 10
                        right: divider.left
                        verticalCenter: parent.verticalCenter
                    }
                    text: "取消"
                    onClicked: {
                        popup.close()
                    }
                }

                FluFilledButton{
                    anchors{
                        right: parent.right
                        left: divider.right
                        rightMargin: 20
                        leftMargin: 10
                        verticalCenter: parent.verticalCenter
                    }
                    text: "确定"
                    onClicked: {
                        changeFlag = false
                        popup.close()
                    }
                }

            }

        }
        y:35
        function showPopup() {
            changeFlag = true
            rowData[0] = text_year.text
            rowData[1] = text_month.text
            rowData[2] = text_day.text

            const now = new Date();
            var year = text_year.text === "年"? now.getFullYear() : Number(text_year.text);
            var month = text_month.text === "月"? now.getMonth() + 1 : Number(text_month.text);
            var day =  text_day.text === "日" ? now.getDate() : Number(text_day.text);

            list_view_1.currentIndex = list_view_1.model.indexOf(year)
            text_year.text = year

            list_view_2.model = generateMonthArray(1,12)
            list_view_2.currentIndex = list_view_2.model.indexOf(month)
            text_month.text = month

            list_view_3.model = generateMonthDaysArray(year,month)
            list_view_3.currentIndex = list_view_3.model.indexOf(day)
            text_day.text = day

            var pos = root.mapToItem(null, 0, 0)
            if(window.height>pos.y+35+340){
                popup.y = 35
            }else{
                popup.y = window.height-(pos.y+340)
            }
            popup.open()
        }

        onClosed: {
            if(changeFlag){
                text_year.text = rowData[0]
                text_month.text = rowData[1]
                text_day.text = rowData[2]
            }
        }
    }

    property bool changeFlag: true
    readonly property var rowData: ["","",""]

    function generateYearArray(startYear, endYear) {
        const yearArray = [];
        for (let year = startYear; year <= endYear; year++) {
            yearArray.push(year);
        }
        return yearArray;
    }

    function generateMonthArray(startMonth, endMonth) {
        const monthArray = [];
        for (let month = startMonth; month <= endMonth; month++) {
            monthArray.push(month);
        }
        return monthArray;
    }

    function generateMonthDaysArray(year, month) {
        const monthDaysArray = [];
        const lastDayOfMonth = new Date(year, month, 0).getDate();
        for (let day = 1; day <= lastDayOfMonth; day++) {
            monthDaysArray.push(day);
        }
        return monthDaysArray;
    }


}
