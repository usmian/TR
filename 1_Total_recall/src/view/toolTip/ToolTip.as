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
		//[Embed(source = "../../lib/pause.png")]
		//private var cl:Class;
		//private var im:Bitmap = new cl();
		
		public function ToolTip($dx:int=0, $dy:int=0,$backWidth:int=100,$backHeight:int=100) 
		{
			super($dx, $dy);
			 // создаем текстовое поле
            
			 _textField = new TextField();
			
			
			
			//_back.addChild(im);
			//im.y = 150;
			//im.x = 30;
			
            _textField.autoSize = TextFieldAutoSize.LEFT;
           // _textField.background = true;
			//_textField.alpha = 0.9;
			//_textField.backgroundColor = 0x3423;
			//_textField.borderColor = 0x5634524;
			_textField.textColor = 0x0000;
			
           // _textField.border = true;
            _textField.multiline = true;
			
            _textField.defaultTextFormat = new TextFormat('Tahoma', 24);
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