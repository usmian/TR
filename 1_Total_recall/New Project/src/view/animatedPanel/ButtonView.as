package view.animatedPanel 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import ru.flashpress.tween.FPTween;
	import ru.flashpress.tween.anim.group.FPAnimGroup;
	import ru.flashpress.tween.display.FPTSprite;
	import ru.flashpress.tween.core.constants.FPTEaseTypes;
	import ru.flashpress.tween.core.constants.FPTProperties;
	import flash.filters.GlowFilter;
	import flash.filters.BlurFilter;
	/**
	 * ...
	 * @author ф
	 */
	public class ButtonView extends Sprite 
	{
		
		
		private var _disabledButton:DisplayObject;
		private var _defaultButton:DisplayObject;
		private var _downButton:DisplayObject;
		
		private var _index:uint;
		
		private var _stateContainer:FPTSprite;
		private var _currentState:DisplayObject;
	    
		private var _animationButX:FPTween;
		private var _animationPlayX:FPTween;
		private var _animationPlayY:FPTween;

	    private var _sensor:Sprite=new Sprite();
		private const BUTTONX:uint = 267;
	
		public function ButtonView()//($index:int) 
		
		{
			//this._index = $index;
			//_backGround.alpha = 0;
			_stateContainer = new FPTSprite();
			 this.addChild(_stateContainer);
			_stateContainer.x = -800;
			_stateContainer.y =200 //stage.stageWidth / 5;
			_disabledButton = ButtonsSource.blockedButton;
			_defaultButton = ButtonsSource.defaultButton;
			_downButton = ButtonsSource.downButton;
			//state container for bitmaps from source BitmapData
			_currentState = _disabledButton;
			_stateContainer.addChild(_currentState);
			//sensor
			_sensor.graphics.beginFill(0x456346, 0);
			_sensor.graphics.drawRoundRect(BUTTONX,_stateContainer.y,_stateContainer.width, _stateContainer.height, 10, 10);
			_sensor.graphics.endFill();
			this.addChild(_sensor);
			
			_sensor.buttonMode = true;
			_sensor.addEventListener(MouseEvent.CLICK, sensor_click);
			_sensor.addEventListener(MouseEvent.ROLL_OVER, onOverHandler);
                        _sensor.addEventListener(MouseEvent.ROLL_OUT, onOutHandler);
                        _sensor.addEventListener(MouseEvent.MOUSE_DOWN, onDownHandler);
                        _sensor.addEventListener(MouseEvent.MOUSE_UP, onUpHandler);
			
		
			
		 	this.addEventListener(Event.ADDED_TO_STAGE,animation)
			//mmask();//for mask background
		}

	    
		private function animation(e:Event):void 
		{
			
		    _animationButX = new FPTween( { duration:2, property:FPTProperties.X, ease:FPTEaseTypes.ELASTIC_IN_OUT, target:_stateContainer, finish:BUTTONX } );
			_animationButX.start();
			removeEventListener(Event.ADDED_TO_STAGE, animation);
			
		}
		
		private var _isOver:Boolean;
		private var _isDown:Boolean;
		
		private function onUpHandler(e:MouseEvent):void 
		{
		     changeState();
			_isDown = false;
		}
		
		private function onDownHandler(e:MouseEvent):void 
		{
		     changeState();
		    _isDown = true;
			
		}
		
		private function changeState():void 
		{
			if (_currentState!=null) 
			{
				if (_stateContainer.contains(_currentState)) 
				{
					_stateContainer.removeChild(_currentState);
				}
				_currentState = null;
			}
			//
			if (_isDown) 
			{
				_currentState = _downButton;
			}
			else
			{
				//save 
				_currentState = _isOver ? _defaultButton : _downButton; 
			}
			if (_currentState!=null) 
			{
				_stateContainer.addChild(_currentState);
			}
		}
		
		private function onOutHandler(e:MouseEvent):void 
		{
			removeFilter(_stateContainer);
			_animationPlayX = new FPTween( { duration:0.1, property:FPTProperties.SCALEX, ease:FPTEaseTypes.SIN_IN, target:_stateContainer, finish:1 } );
			_animationPlayY = new FPTween( { duration:0.1, property:FPTProperties.SCALEY, ease:FPTEaseTypes.SIN_IN, target:_stateContainer, finish:1 } );
			_animationPlayX.start();
			_animationPlayY.start();
			_isOver = false;
		}
		
		private function onOverHandler(e:MouseEvent):void 
		{
			 applyFilter(_stateContainer);
			_animationPlayX = new FPTween( { duration:0.1, property:FPTProperties.SCALEX, ease:FPTEaseTypes.SIN_IN, target:_stateContainer, finish:1.07 } );
			_animationPlayY = new FPTween( { duration:0.1, property:FPTProperties.SCALEY, ease:FPTEaseTypes.SIN_IN, target:_stateContainer, finish:1.07 } );
			_animationPlayX.start();
			_animationPlayY.start();
			_isOver = true;
		}
		
		private function sensor_click(e:MouseEvent):void 
		{
	     	//throw index of button
			dispatchEvent(new ButtonEvent(EventConst.CLICK_TARGET, e.target));
			
		}
		private function applyFilter(mc:DisplayObject):void
		{
			var filterArray:Array = new Array();
			var gFilter:GlowFilter = new GlowFilter;
			gFilter.color = 0XFDFDFD;
			gFilter.blurX = 20;
			gFilter.blurY = 20;
			filterArray.push(gFilter);
			mc.filters = filterArray;
		}
		
		
		private function removeFilter(mc:DisplayObject):void
		{
			mc.filters = new Array();
		
		}
		public function buttonCallBack():void 
		{
			_animationButX = new FPTween( { duration:2, property:FPTProperties.X, ease:FPTEaseTypes.ELASTIC_IN_OUT, target:_stateContainer, finish:-800 } );
			_animationButX.start();
		}
		public function disposeListeners():void
		{
			
			_sensor.removeEventListener(MouseEvent.CLICK, sensor_click);
			_sensor.removeEventListener(MouseEvent.ROLL_OVER, onOverHandler);
                        _sensor.removeEventListener(MouseEvent.ROLL_OUT, onOutHandler);
                        _sensor.removeEventListener(MouseEvent.MOUSE_DOWN, onDownHandler);
                        _sensor.removeEventListener(MouseEvent.MOUSE_UP, onUpHandler);
			_sensor = null;
		}
	}

}

/*	private function mmask():void 
{
		var mask:Sprite = new Sprite();
		
		mask.graphics.beginFill(0xFFFFFF, 0.5);
		mask.graphics.drawRoundRect(_backGround.x, _backGround.y, _backGround.width, _backGround.height, 10, 10);
		mask.graphics.endFill();
		this.addChild(mask);
		mask.mouseEnabled = false;
}*/










