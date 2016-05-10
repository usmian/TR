package vkConnection.vkView 
{
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author ф
	 */
	public class VkSource 
	{
		[Embed(source="../../../lib/mask2.png")]
		private static var maskClass:Class;
		private static var _maskData:BitmapData;
		
		public static function get this_mask():Bitmap
		
		{
			if (_maskData==null) 
			{
				var bitmap:Bitmap = new maskClass();
				_maskData = bitmap.bitmapData;
			}
			return new Bitmap(_maskData);
		}
		public static function destroy():void 
		{
			_maskData.dispose();
			_maskData = null;
		}
	}

}