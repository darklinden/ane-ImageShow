package com.darklinden
{
	import flash.external.ExtensionContext;
	
	import flashx.textLayout.formats.Float;

	public class callFunc
	{
		private var context:ExtensionContext;
		
		public function callFunc()
		{
			context = ExtensionContext.createExtensionContext("com.darklinden.ImageShow","");
		}
		
		public function callFuncIsSupported(): Boolean
		{
			var a: Boolean;
			a = context.call("isSupported") as Boolean;
			return a;
		}
		
		public function callFuncShow(path: String, x: Float, y: Float, w: Float, h: Float): Boolean
		{
			var a: Boolean;
			a = context.call("isShow", path, x, y, w, h) as Boolean;
			return a;
		}
	}
}
