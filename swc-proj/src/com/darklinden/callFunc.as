package com.darklinden
{
	import flash.external.ExtensionContext;
	
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
		
		public function callFuncShow(path: String, x: Number, y: Number, w: Number, h: Number): Boolean
		{
			var a: Boolean;
			a = context.call("isShow", path, x, y, w, h) as Boolean;
			return a;
		}
	}
}
