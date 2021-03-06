#if !macro
import Main;
import haxe.Resource;
import flash.display.Bitmap;
import flash.display.BitmapData;
import flash.display.ILoader;
import flash.events.Event;
import flash.media.Sound;
import flash.net.IURLLoader;
import flash.net.URLRequest;
import flash.net.URLLoaderDataFormat;
import flash.Lib;
import js.html.Element;
import js.html.AudioElement;

class ApplicationMain {
	#if (openfl >= "2.1")
	public static var config:lime.app.Config = {
		antialiasing: Std.int(0),
		background: Std.int(16777215),
		borderless: false,
		depthBuffer: false,
		fps: Std.int(60),
		fullscreen: false,
		height: Std.int(480),
		orientation: "portrait",
		resizable: true,
		stencilBuffer: false,
		title: "WhatDoWeDO",
		vsync: true,
		width: Std.int(640),
	};
	#end
	private static var completed:Int;
	private static var preloader:flixel.system.FlxPreloader;
	private static var total:Int;

	public static var loaders:Map<String, ILoader>;
	public static var urlLoaders:Map<String, IURLLoader>;
	private static var loaderStack:Array<String>;
	private static var urlLoaderStack:Array<String>;
	// Embed data preloading
	@:noCompletion public static var embeds:Int = 0;
	@:noCompletion public static function loadEmbed(o:Element) {
		embeds++;
		var f = null;
		f = function(_) {
			o.removeEventListener("load", f);
			if (--embeds == 0) preload();
		}
		o.addEventListener("load", f);
	}
	
	public static function main() {
		if (embeds == 0) preload();
	}

	private static function preload() {
		completed = 0;
		loaders = new Map<String, ILoader>();
		urlLoaders = new Map<String, IURLLoader>();
		total = 0;
		
		flash.Lib.current.loaderInfo = flash.display.LoaderInfo.create (null);
		
		flash.Lib.stage.frameRate = 60;
		// preloader:
		Lib.current.addChild(preloader = new flixel.system.FlxPreloader());
		preloader.onInit();
		
		// assets:
		loadBinary("assets/data/data-goes-here.txt");
		loadBinary("assets/images/images-go-here.txt");
		loadFile("assets/images/img_char.png");
		loadFile("assets/images/img_item_cell.png");
		loadFile("assets/images/img_scene.png");
		loadBinary("assets/music/music-goes-here.txt");
		loadBinary("assets/sounds/sounds-go-here.txt");
		loadSound("assets/sounds/beep.mp3");
		loadSound("assets/sounds/flixel.mp3");
		loadSound("assets/sounds/beep.ogg");
		loadSound("assets/sounds/flixel.ogg");
		
		// bitmaps:
		var resourcePrefix = "NME_:bitmap_";
		for (resourceName in Resource.listNames()) {
			if (StringTools.startsWith (resourceName, resourcePrefix)) {
				var type = Type.resolveClass(StringTools.replace (resourceName.substring(resourcePrefix.length), "_", "."));
				if (type != null) {
					total++;
					#if bitfive_logLoading
						flash.Lib.trace("Loading " + Std.string(type));
					#end
					var instance = Type.createInstance (type, [ 0, 0, true, 0x00FFFFFF, bitmapClass_onComplete ]);
				}
			}
		}
		
		if (total != 0) {
			loaderStack = [];
			for (p in loaders.keys()) loaderStack.push(p);
			urlLoaderStack = [];
			for (p in urlLoaders.keys()) urlLoaderStack.push(p);
			// launch 8 loaders at once:
			for (i in 0 ... 8) nextLoader();
		} else begin();
	}
	
	private static function nextLoader() {
		if (loaderStack.length != 0) {
			var p = loaderStack.shift(), o = loaders.get(p);
			#if bitfive_logLoading
				flash.Lib.trace("Loading " + p);
				o.contentLoaderInfo.addEventListener("complete", function(e) {
					flash.Lib.trace("Loaded " + p);
					loader_onComplete(e);
				});
			#else
				o.contentLoaderInfo.addEventListener("complete", loader_onComplete);
			#end
			o.load(new URLRequest(p));
		} else if (urlLoaderStack.length != 0) {
			var p = urlLoaderStack.shift(), o = urlLoaders.get(p);
			#if bitfive_logLoading
				flash.Lib.trace("Loading " + p);
				o.addEventListener("complete", function(e) {
					flash.Lib.trace("Loaded " + p);
					loader_onComplete(e);
				});
			#else
				o.addEventListener("complete", loader_onComplete);
			#end
			o.load(new URLRequest(p));
		}
	}
	
	private static function loadFile(p:String):Void {
		loaders.set(p, new flash.display.Loader());
		total++;
	}
	
	private static function loadBinary(p:String):Void {
		var o = new flash.net.URLLoader();
		o.dataFormat = URLLoaderDataFormat.BINARY;
		urlLoaders.set(p, o);
		total++;
	}
	
	private static function loadSound(p:String):Void {
		return;
		var i:Int = p.lastIndexOf("."), // extension separator location
			c:Dynamic = untyped flash.media.Sound, // sound class
			s:String, // perceived sound filename (*.mp3)
			o:AudioElement, // audio node
			m:Bool = Lib.mobile,
			f:Dynamic->Void = null, // event listener
			q:String = "canplaythrough"; // preload event
		// not a valid sound path:
		if (i == -1) return;
		// wrong audio type:
		if (!c.canPlayType || !c.canPlayType(p.substr(i + 1))) return;
		// form perceived path:
		s = p.substr(0, i) + ".mp3";
		// already loaded?
		if (c.library.exists(s)) return;
		#if bitfive_logLoading
			flash.Lib.trace("Loading " + p);
		#end
		total++;
		c.library.set(s, o = untyped __js__("new Audio(p)"));
		f = function(_) {
			#if bitfive_logLoading
				flash.Lib.trace("Loaded " + p);
			#end
			if (!m) o.removeEventListener(q, f);
			preloader.onUpdate(++completed, total);
			if (completed == total) begin();
		};
		// do not auto-preload sounds on mobile:
		if (m) f(null); else o.addEventListener(q, f);
	}

	private static function begin():Void {
		preloader.addEventListener(Event.COMPLETE, preloader_onComplete);
		preloader.onLoaded();
	}
	
	private static function bitmapClass_onComplete(instance:BitmapData):Void {
		completed++;
		var classType = Type.getClass (instance);
		Reflect.setField(classType, "preload", instance);
		if (completed == total) begin();
	}

	private static function loader_onComplete(event:Event):Void {
		completed ++;
		preloader.onUpdate (completed, total);
		if (completed == total) begin();
		else nextLoader();
	}

	private static function preloader_onComplete(event:Event):Void {
		preloader.removeEventListener(Event.COMPLETE, preloader_onComplete);
		Lib.current.removeChild(preloader);
		preloader = null;
		if (untyped Main.main == null) {
			var o = new DocumentClass();
			if (Std.is(o, flash.display.DisplayObject)) Lib.current.addChild(cast o);
		} else untyped Main.main();
	}
}

@:build(DocumentClass.build())
class DocumentClass extends Main {
	@:keep public function new() {
		super();
	}
}

#else // macro
import haxe.macro.Context;
import haxe.macro.Expr;

class DocumentClass {
	
	macro public static function build ():Array<Field> {
		var classType = Context.getLocalClass().get();
		var searchTypes = classType;
		while (searchTypes.superClass != null) {
			if(searchTypes.pack.length == 2
			&& searchTypes.pack[1] == "display"
			&& searchTypes.name == "DisplayObject") {
				var fields = Context.getBuildFields();
				var method = macro {
					return flash.Lib.current.stage;
				}
				fields.push( {
					name: "get_stage",
					access: [ APrivate, AOverride ],
					kind: FFun( {
						args: [],
						expr: method,
						params: [],
						ret: macro :flash.display.Stage
					}), pos: Context.currentPos() });
				return fields;
			}
			searchTypes = searchTypes.superClass.t.get();
		}
		return null;
	}
	
}
#end