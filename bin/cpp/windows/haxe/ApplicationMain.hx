class ApplicationMain
{

	#if waxe
	static public var frame : wx.Frame;
	static public var autoShowFrame : Bool = true;
	#if nme
	static public var nmeStage : wx.NMEStage;
	#end
	#end
	
	public static function main()
	{
		#if nme
		nme.Lib.setPackage("Vincent Quigley", "InfinityStacker", "com.twinnova.infinitystacker.InfinityStacker", "1.0.0");
		
		#end
		
		#if waxe
		wx.App.boot(function()
		{
			
			frame = wx.Frame.create(null, null, "Infinity Stacker", null, { width: 800, height: 480 });
			
			#if nme
			var stage = wx.NMEStage.create(frame, null, null, { width: 800, height: 480 });
			#end
			
			com.twinnova.infinitystacker.Main.main();
			
			if (autoShowFrame)
			{
				wx.App.setTopWindow(frame);
				frame.shown = true;
			}
		});
		#else
		
		nme.Lib.create(function()
			{ 
				if (800 == 0 && 480 == 0)
				{
					nme.Lib.current.stage.align = nme.display.StageAlign.TOP_LEFT;
					nme.Lib.current.stage.scaleMode = nme.display.StageScaleMode.NO_SCALE;
				}
				
				var hasMain = false;
				
				for (methodName in Type.getClassFields(com.twinnova.infinitystacker.Main))
				{
					if (methodName == "main")
					{
						hasMain = true;
						break;
					}
				}
				
				if (hasMain)
				{
					Reflect.callMethod (com.twinnova.infinitystacker.Main, Reflect.field (com.twinnova.infinitystacker.Main, "main"), []);
				}
				else
				{
					nme.Lib.current.addChild(cast (Type.createInstance(com.twinnova.infinitystacker.Main, []), nme.display.DisplayObject));	
				}
			},
			800, 480, 
			60, 
			0x000000,
			(true ? nme.Lib.HARDWARE : 0) |
			(true ? nme.Lib.RESIZABLE : 0) |
			(false ? nme.Lib.BORDERLESS : 0) |
			(true ? nme.Lib.VSYNC : 0) |
			(false ? nme.Lib.FULLSCREEN : 0) |
			(0 == 4 ? nme.Lib.HW_AA_HIRES : 0) |
			(0 == 2 ? nme.Lib.HW_AA : 0),
			"Infinity Stacker"
			
			, getAsset("icon.png")
			
		);
		#end
		
	}
	
	
	public static function getAsset(inName:String):Dynamic
	{
		#if nme
		
		#end
		return null;
	}
	
	
}