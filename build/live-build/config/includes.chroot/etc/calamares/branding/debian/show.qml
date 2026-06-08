/* Calamares Slideshow */
import QtQuick 2.0;
import calamares.slideshow 1.0;

Presentation {
    id: presentation

    Timer {
        interval: 20000
        running: presentation.activatedInCalamares
        repeat: true
        onTriggered: presentation.goToNextSlide()
    }

    Slide {
        anchors.fill: parent

        Text {
            anchors.centerIn: parent
            text: "Installing JonasOS..."
            font.pixelSize: 24
            color: "#cdd6f4"
        }
    }
}
