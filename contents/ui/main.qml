import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import org.kde.plasma.core as PlasmaCore
import org.kde.plasma.plasmoid
import org.kde.plasma.plasma5support as Plasma5Support

PlasmoidItem {
    id: root
    width: 220
    height: 120
    toolTipMainText: "Toggle HDR for Display DP-2"
    Plasmoid.title: "HDR Toggle"

    property string hdrStatus: "Checking…"

    Plasma5Support.DataSource {
        id: execSource
        engine: "executable"

        onNewData: function(source, data) {
            let out = data.stdout || ""
            console.log("HDR status raw output:", out)
            hdrStatus = out.includes("enabled") ? "Enabled" : "Disabled"
        }

        function runCommand(cmd) {
            disconnectSource("") // clear previous sources
            connectSource(cmd)
        }
    }

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 12

        Label {
            text: "HDR Status: " + hdrStatus
            font.pointSize: 12
            Layout.alignment: Qt.AlignHCenter
        }

        Button {
            text: "Toggle HDR"
            onClicked: {
                execSource.runCommand(root.plasmoid.filePath("scripts/hdr_toggle.sh"))
            }
        }
    }

    Timer {
        interval: 3000
        running: true
        repeat: true
        onTriggered: {
            execSource.runCommand("bash -c \"kscreen-doctor -o | awk '/HDR:/ { print $3; exit }'\"")
        }
    }
}
