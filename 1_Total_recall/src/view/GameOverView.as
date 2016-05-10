package view 
{
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import ru.flashpress.tween.FPTween;
	import ru.flashpress.tween.display.FPTSprite;
	import ru.flashpress.tween.core.constants.FPTProperties;
	import ru.flashpress.tween.core.constants.FPTEaseTypes;
	import ru.flashpress.tween.events.FPTEvent;
	import events.*;
	/**
	 * ...
	 * @author ф
	 */
	public class GameOverView extends Sprite
	{
		[Embed(source="../../lib/button_src/onOver.png")]
		private var _imgClass:Class;
		private var _imageOver:Bitmap;
		private var _isOver:Boolean;
		private var _container:FPTSprite;
		private var _animationOnX:FPTween;
		private var _animationOnY:FPTween;
		private var _animationOffX:FPTween;
		private var _animationOffY:FPTween;
		
		public function GameOverView() 
		{
			_container = new FPTSprite();
			_imageOver = new _imgClass();
			_container.addChild(_imageOver);
			_container.scaleX = _container.scaleY = 0.01;
   	   	   	this.addChild(_container);
			
			_container.addEventListener(Event.ADDED_TO_STAGE, container_addedToStage);
			_container.addEventListener(MouseEvent.CLICK, container_click);
		}
		
		private function container_click(e:MouseEvent):void 
		{
			if (_isOver) 
			{
				_animationOffX = new FPTween( { duration:0.01, property:FPTProperties.SCALEX, ease:FPTEaseTypes.BACK_OUT, target:_container, finish:0.01 } );
				_animationOffY = new FPTween( { duration:0.01, property:FPTProperties.SCALEY, ease:FPTEaseTypes.BACK_OUT, target:_container, finish:0.01 } );
				_animationOffX.start();
				_animationOffY.start();
				_isOver = false;	
			}
			
			if (_animationOffX) 
			{
				_animationOffX.addEventListener(FPTEvent.FINISH, animationOffX_finish);	
			}
		}
		
		private function animationOffX_finish(e:FPTEvent):void 
		{
			Facade.gameView.turnButtonsOff(false);
			_animationOffX.removeEventListener(FPTEvent.FINISH, animationOffX_finish);
			GlobalDispatcher.dispatch(new GameEvent(EventConstants.HIDE_POPUP));
			
		}
		
		private function container_addedToStage(e:Event):void 
		{
			_animationOnX = new FPTween( { duration:0.5, property:FPTProperties.SCALEX, ease:FPTEaseTypes.BACK_OUT, target:_container, finish:1 } );
			_animationOnY = new FPTween( { duration:0.5, property:FPTProperties.SCALEY, ease:FPTEaseTypes.BACK_OUT, target:_container, finish:1 } );
			_animationOnX.start();
			_animationOnY.start();
			_animationOnX.addEventListener(FPTEvent.FINISH, animationOnX_finish);
			 removeEventListener(Event.ADDED_TO_STAGE, container_addedToStage);
		}
		
		private function animationOnX_finish(e:FPTEvent):void 
		{
			_isOver = true;
			_animationOnX.removeEventListener(FPTEvent.FINISH, animationOnX_finish);
		}
		
		
	}

}