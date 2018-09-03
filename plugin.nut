// Layout User Options
class UserConfig </ help="A plugin that helps to debug layouts." /> {
	</ label="Reload Layout Key",
		help="The key that triggers the layout to reload.",
		options="Custom1, Custom2, Custom3, Custom4, Custom5, Custom6",
		order=1 />
	reloadKey="Custom1";
	</ label="Toggle Frame Rate Key",
		help="The key that toggles visibility of the layout frame rate.",
		options="Custom1, Custom2, Custom3, Custom4, Custom5, Custom6",
		order=2 />
	fpsKey="Custom2";
	</ label="Frame Rate Counter Color",
		help="The color of the layout frame rate counter.",
		options="Black, White",
		order=3 />
	fpsCounterColor="White";
	</ label="Frame Rate Counter Position",
		help="The position of the layout frame rate counter.",
		options="TL, TR, BL, BR",
		order=4 />
	fpsCounterPosition="BR";
}

// Debug
class Debug {
	config = null;

	reloadKey = null;

	fpsCounter = null;
	fpsDraw = null;
	fpsKey = null;
	fpsLow = null;
	fpsStartTime = null;

	constructor() {
		config = fe.get_config();

		reloadKey = config["reloadKey"].tolower();
		fe.add_signal_handler(this, "reload");

		fpsCounter = fe.add_text("", 0, 0, fe.layout.width, fe.layout.height/20);
			switch (config["fpsCounterPosition"].tolower()) {
				case "tl":
					fpsCounter.set_pos(0, 0);
					fpsCounter.align = Align.MiddleLeft
					break;
				case "tr":
					fpsCounter.set_pos(0, 0);
					fpsCounter.align = Align.MiddleRight;
					break;
				case "bl":
					fpsCounter.set_pos(0, fe.layout.height-(fe.layout.height/20));
					fpsCounter.align = Align.MiddleLeft;
					break;
				default:
					fpsCounter.set_pos(0, fe.layout.height-(fe.layout.height/20));
					fpsCounter.align = Align.MiddleRight;
					break;
			}
			switch (config["fpsCounterColor"].tolower()) {
				case "black":
					fpsCounter.set_rgb(0, 0, 0);
					break;
				default:
					fpsCounter.set_rgb(255, 255, 255);
					break;
			}
		fpsDraw = fe.add_text("", 0, 0, 1, 1);
		fpsKey = config["fpsKey"].tolower();
		fpsStartTime = 0;
		fe.add_signal_handler(this, "fpsToggle");
		fe.add_ticks_callback(this, "fps");
	}

	// Reload Layout on Key Press
	function reload(str) {
		if (str == reloadKey) fe.signal("reload");
		return false;
	}

	function fpsToggle(str) {
		if (str == fpsKey) {
			fpsCounter.visible ? fpsCounter.visible = false : fpsCounter.visible = true;
		}
	}

	// Calculate Frames Per Second
	function fps(ttime) {
		fpsDraw.x++;

		if (fpsDraw.x == 10) {
			local rate = 10000/(ttime-fpsStartTime);

			if ((fpsLow == null) || (rate < fpsLow)) fpsLow = rate;

			fpsCounter.msg = rate + " / " + fpsLow;
			fpsStartTime = ttime;
			fpsDraw.x = 0;
		}
	}
}
fe.plugin["Debug"] <- Debug();
