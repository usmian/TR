package view.toolTip 
{
	import flash.display.Bitmap;
	import flash.display.Graphics;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	 import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;
	/**
	 * ...
	 * @author ф
	 */
	public class ToolTip extends ToolTipBase 
	{
		private var _textField:TextField;
		private var _back:Sprite;
	
		public function ToolTip($dx:int=0, $dy:int=0,$backWidth:int=100,$backHeight:int=100) 
		{
			super($dx, $dy);
			 // создаем текстовое поле
	         	 _textField = new TextField();
                        _textField.autoSize = TextFieldAutoSize.LEFT;
		       	_textField.textColor = 0x0000;
                        _textField.multiline = true;
                        _textField.defaultTextFormat = new TextFormat('Tahoma', 24);
		        //
			_back = new Sprite();
			_back.graphics.lineStyle(0, 0x0);
			_back.graphics.beginFill(0x00FF00);
                        _back.graphics.drawRoundRect(0, 0,$backWidth,$backHeight , 16, 16 );
			_back.alpha = 0.4;
			 this.addChild(_back);
			 this.addChild(_textField);
		}
		protected override function showHint($data:Object):void 
		{
			// отображает полученный текст
			 _textField.htmlText = $data.toString();
		}
	}

}
