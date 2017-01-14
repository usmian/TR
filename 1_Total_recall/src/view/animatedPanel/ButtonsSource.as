package view.animatedPanel 
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	/**
	 * ...
	 * @author ф
	 */
	public class ButtonsSource 
	{
		
		[Embed(source = "../../../lib/button_src/onBack.png")]
		private static var backClass:Class;
		[Embed(source = "../../../lib/button_src/onClick.png")]
		private static var defaultClass:Class;
		[Embed(source = "../../../lib/button_src/onDown.png")]
		private static var clickClass:Class;
		[Embed(source="../../../lib/button_src/onBlocked.png")]
		private static var blockClass:Class;
		[Embed(source = "../../../lib/button_src/onRemove.png")]
		private static var removeClass:Class;
		[Embed(source = "../../../lib/button_src/fonBack.png")]
		private static var fonClass:Class;
		private static var backData:BitmapData;
		private static var defaultData:BitmapData;
		private static var clickData:BitmapData;
		private static var blockData:BitmapData;
		private static var removeData:BitmapData;
		private static var fonData:BitmapData;
		
		public static function get background():DisplayObject
		{
			if (backData==null) 
			{
				var bitmap:Bitmap = new backClass();
				backData = bitmap.bitmapData;
			}
			return new Bitmap(backData);
		}
		
		public static function get defaultButton():DisplayObject
		{
			if (defaultData==null) 
			{
				var bitmap:Bitmap = new defaultClass();
				defaultData = bitmap.bitmapData;
			}
			return new Bitmap(defaultData);
		}
		
		public static function get downButton():DisplayObject
		{
			if (clickData==null) 
			{
				var bitmap:Bitmap = new clickClass();
				clickData = bitmap.bitmapData;
			}
			return new Bitmap(clickData);
		}
		
		public static function get blockedButton():DisplayObject
		{
			if (blockData==null) 
			{
				var bitmap:Bitmap = new blockClass();
				blockData = bitmap.bitmapData;
			}
			return new Bitmap(blockData);
		}
		public static function get removeButton():DisplayObject
		{
			if (removeData==null) 
			{
				var bitmap:Bitmap = new removeClass();
				removeData = bitmap.bitmapData;
			}
			return new Bitmap(removeData);
		}
		public static function get fonBack():DisplayObject
		{
			if (fonData==null) 
			{
				var bitmap:Bitmap = new fonClass();
				fonData = bitmap.bitmapData;
			}
			return new Bitmap(fonData);
		}
	}

}