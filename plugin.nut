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

		fpsCounter = fe.add_text("", 0, fe.layout.height-(fe.layout.height/20), fe.layout.width, fe.layout.height/20);
			fpsCounter.align = Align.MiddleRight;
			fpsCounter.set_rgb(255, 255, 255);
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
