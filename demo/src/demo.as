package
{
	import com.danielfreeman.madcomponents.Attributes;
	import com.danielfreeman.madcomponents.UIList;
	
	import com.greensock.TweenLite;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	
	import com.darklinden.callFunc;
	
	[SWF(backgroundColor='#666666', frameRate='60')]
	public class demo extends Sprite
	{
		
		[Embed(source="assets/logo.png")]
		private var clsLogo:Class;
		private var _logo:Bitmap;
		private var _logoContainer:Sprite;
		private var cf: callFunc;
		
		public function demo()
		{
			if (stage){
				init();
			}else{
				addEventListener(Event.ADDED_TO_STAGE, init);
			}
			stage.addEventListener(Event.RESIZE, resizeEventHandler);
		}
		
		
		private function init(e:Event = null):void {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			_logo = new clsLogo as Bitmap;
			_logo.smoothing = true;
			
			_logoContainer = new Sprite;
			_logoContainer.addEventListener(MouseEvent.CLICK, clickLogo);
			
			_logoContainer.addChild(_logo);
			addChild(_logoContainer);
			
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
		}
		
		private function clickLogo(e:MouseEvent):void {
			trace("tap");
			if (!cf) {
				cf = new callFunc();
			}
			
			var b: Boolean = cf.callFuncIsSupported();
			trace(b.toString());
			
			var lcImage:File = File.applicationDirectory.resolvePath("./" + "Assets/logo.png");
			var s: String = lcImage.nativePath;
			
			if (lcImage.exists) {
				trace(s);
				var b1: Boolean = cf.callFuncShow(s, 10, 10, 100, 80);
				trace(b1.toString());
			}
			
//			var cf: callFunc = new callFunc();
//			var a:String = "hello";
//			var b:int = cf.callFuncSum(1, 2);
//			trace(b.toString());
			
			
//			TweenLite.to(_logo, 0.2, {alpha: 0.1,onComplete:loadList});
//			_logoContainer.removeEventListener(MouseEvent.CLICK, clickLogo);
		}
		
		private function loadList():void {
			var iList:UIList = new UIList(this,<list />,new Attributes(0,0,stage.stageWidth,stage.stageHeight));
			iList.xmlData = <data>
								<Alpaca />
								<草泥马 />
								<Elephant />
								<大象 />
								<Lion />
								<Horse />
								<Puma />
								<Panda />
								<Redpanda />
								<Bear />
								<Tiger />
								<Bird />				
							</data>;
			addChild(iList);
		}
		
		private function resizeEventHandler(e:Event):void {
			if (_logoContainer){
				
				if (_logoContainer.width > stage.stageWidth) {
					_logoContainer.width = stage.stageWidth;
				}
				_logoContainer.scaleY = _logoContainer.scaleX;
				
				_logoContainer.x = (stage.stageWidth - _logoContainer.width) * 0.5;
				_logoContainer.y = (stage.stageHeight - _logoContainer.height) * 0.5;
			}
		}
		
	}
}