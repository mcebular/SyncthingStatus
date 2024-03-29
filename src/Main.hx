package ;

import Util.getAboutString;
import hx.widgets.*;
import hx.widgets.StandardPaths.FileLayout;
import hx.widgets.styles.MessageDialogStyle;


@:buildXml('<include name="../Build.xml" />')
class Main {

    public static final APP_NAME = "SyncthingStatus";
    public static final APP_VERSION = "v2.0-rc.2";

    public static function main() {
        trace(getAboutString());
        var app = new App();
        app.init();
        app.name = APP_NAME;

        new StandardPaths().fileLayout = FileLayout.XDG;

        var configHandler = new AppConfigHandler();
        var settingsFrame:SettingsFrame = new SettingsFrame(null, configHandler);

        try {
            configHandler.init();
            settingsFrame.init();
        } catch (exception) {
            MessageDialog.messageBox("An exception occured when starting Syncthing Status:\n" + exception.message, APP_NAME + " could not start", MessageDialogStyle.OK | MessageDialogStyle.ICON_EXCLAMATION, settingsFrame);
            return;
        }

        var apiClient = new ApiClient(configHandler);
        var iconHandler = new TaskBarIconHandler(app, settingsFrame, configHandler);
        
        var statusCheckTimer = new StatusCheckTimer(app, settingsFrame, apiClient, iconHandler);
        statusCheckTimer.start();

        app.run();
        app.exit();
    }
}
