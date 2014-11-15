/*
    Copyright (C) 2014 Andrea Scarpino <me@andreascarpino.it>
    All rights reserved.

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
*/

import QtQuick 2.0
import Sailfish.Silica 1.0

Page {

    property int startX
    property int startY
    property int finishX
    property int finishY

    readonly property real defaultStrokeSize: 5
    readonly property string defaultStrokeColor: "#000000"
    readonly property string defaultFillColor: "#ffffff"

    Column {
        anchors.fill: parent

        Row {
            id: menu
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 3
            // Workaround: we don't want the Slider animation!
            height: 95

            IconButton {
                icon.source: "image://theme/icon-camera-focus"
                anchors.verticalCenter: parent.verticalCenter

                // default value for the rubber
                property real prevLineWidth: 20;

                onClicked: {
                    if (canvas.strokeStyle === defaultStrokeColor) {
                        canvas.strokeStyle = defaultFillColor;
                    } else {
                        canvas.strokeStyle = defaultStrokeColor;
                    }

                    var currentLineWidth = size.value;
                    size.value = prevLineWidth;
                    prevLineWidth = currentLineWidth;
                }
            }

            Slider {
                id: size
                minimumValue: 1
                maximumValue: 30
                stepSize: 1
                value: defaultStrokeSize
                valueText: value
                width: 400
                // Workaround: we don't want the Slider animation!
                height: 120

                onValueChanged: {
                    valueText = canvas.lineWidth = value;
                }
            }

            IconButton {
                icon.source: "image://theme/icon-m-clear"
                anchors.verticalCenter: parent.verticalCenter

                onClicked: {
                    canvas.clear();
                }
            }
        }

        Rectangle {
            height: parent.height - menu.height
            width: parent.width

            Canvas {
                id: canvas
                anchors.fill: parent
                antialiasing: true

                property real lineWidth: defaultStrokeSize
                property string strokeStyle: defaultStrokeColor

                onLineWidthChanged: requestPaint()

                function clear()
                {
                    var ctx = getContext("2d");
                    ctx.fillRect(0, 0, width, height);
                    requestPaint();
                }

                onPaint: {
                    var ctx = getContext("2d");
                    ctx.fillStyle = defaultFillColor;
                    ctx.lineCap = "round";
                    ctx.lineJoin = "round";
                    ctx.lineWidth = lineWidth;
                    ctx.miterLimit = 1;
                    ctx.strokeStyle = strokeStyle;

                    ctx.beginPath();
                    ctx.moveTo(startX, startY);
                    ctx.lineTo(finishX, finishY);
                    ctx.closePath();
                    ctx.stroke();

                    startX = finishX;
                    startY = finishY;
                }

                MouseArea {
                    anchors.fill: parent

                    onPressed: {
                        startX = finishX = mouseX;
                        startY = finishY = mouseY;
                    }

                    onMouseXChanged: {
                        finishX = mouseX;
                        parent.requestPaint();
                    }

                    onMouseYChanged: {
                        finishY = mouseY;
                        parent.requestPaint();
                    }
                }
            }
        }
    }
}
