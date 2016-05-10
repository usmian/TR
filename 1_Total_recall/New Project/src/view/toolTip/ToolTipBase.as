package view.toolTip 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.geom.Point;
	import flash.utils.Dictionary;
	import flash.events.MouseEvent;
	import flash.events.Event;
	/**
	 * ...
	 * @author ф
	 */
	public class ToolTipBase extends MovieClip 
	{
		private static var _stageLink:Stage;
		public static function init($stageLink:Stage):void 
		{
			ToolTipBase._stageLink = $stageLink;
		}
	    // на сколько смещать подсказку
        // относительно координат мыши
		protected var delta:Point;
		private var _dictionary:Dictionary;
		public function ToolTipBase($dx:int=0,$dy:int=0):void 
		{
			
			delta = new Point($dx, $dy);
			_dictionary = new Dictionary();
			// делаем окно с подсказкой недоступной для мыши
			this.mouseChildren = this.mouseEnabled = false;
		}
		protected var thisCurrentTarget:DisplayObject;
		protected var currentData:Object;
		
		private function overHandler(e:MouseEvent):void 
		{
			thisCurrentTarget = e.currentTarget as DisplayObject;
			 // добавляем компонент подсказки на stage
			_stageLink.addChild(this);
			trace("this is the"+this);
			setPosition();
            //
            // начинаем случать событие MOUSE_MOVE
            thisCurrentTarget.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
            //
            // определяем data из имеющегося словаря
            currentData = _dictionary[thisCurrentTarget];
            //
            // метод showHint вызывается что бы потомки тоже могли
            // в этот момент сделать необходимые действия
            showHint(currentData);
            //
            // отправляем событие OPEN
            // смысл этого события тот же,
            // что и у метода showHint
           // this.dispatchEvent(new Event(Event.OPEN));
		}
		
		private function moveHandler(e:MouseEvent):void 
		
		{
			      // дергаем updateAfterEvent что бы
            // движение было более плавным
            e.updateAfterEvent();
            // задаем координаты компонента-подсказки
            setPosition();
		}
	    private function setPosition():void
       
		{
            // задаем координаты
            // используя смещение delta
            this.x = _stageLink.mouseX + delta.x;
            this.y = _stageLink.mouseY + delta.y;
        }
		
		private function outHandler(e:MouseEvent):void 
		{
			 // убираем компонент-подсказку со stage
            if (this.parent != null) {
                this.parent.removeChild(this);
            }
            //
            // убиваем слушателя события MOUSE_MOVE
            thisCurrentTarget.removeEventListener(MouseEvent.MOUSE_MOVE, moveHandler)
		}
		
		
		final public function register(target:DisplayObject, data:Object):void 
		{
			target.addEventListener(MouseEvent.ROLL_OVER, overHandler);
			target.addEventListener(MouseEvent.ROLL_OUT, outHandler);
			_dictionary[target] = data;
		}
		
		protected function showHint($data:Object):void 
		{
			//for override
		}
		
		
	}

}