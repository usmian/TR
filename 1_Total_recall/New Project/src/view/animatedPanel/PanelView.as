package view.animatedPanel 
{
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import ru.flashpress.tween.FPTween;
	import ru.flashpress.tween.anim.group.FPAnimGroup;
	import ru.flashpress.tween.display.FPTSprite;
	import ru.flashpress.tween.core.constants.FPTEaseTypes;
	import ru.flashpress.tween.core.constants.FPTProperties;
	import ru.flashpress.tween.events.FPTEvent;
	import flash.display.DisplayObject;
	import view.animatedPanel.EventConst;
	import view.toolTip.ToolTip;
	/**
	 * ...
	 * @author ф
	 */
	
	
	public class PanelView extends Sprite 
	{
		private var _backGround:DisplayObject;
		private var _removeButton:DisplayObject;
		private var _backImg:DisplayObject;
		private var _animationBackX:FPTween;
		private var _animationBackY:FPTween;
		private var _animationremX:FPTween;
		private var _animationremY:FPTween;
		private var _buttons:Vector.<ButtonView>
		private var _buttonsCount:uint;
		private var _toolBack:ToolTip;
		public function PanelView() 
		{
			_backImg = ButtonsSource.fonBack;
			_backGround = ButtonsSource.background;
			_removeButton = ButtonsSource.removeButton;
			//amount of buttons
			_buttonsCount = 5;
			this.addChild(_backImg);
			this.addChild(_backGround);
			this.addChild(_removeButton);
			_backGround.scaleX = _backGround.scaleY = 0.001;
			//take backround bitmap from source and get it small 
			_backGround.x = 200
			_backGround.y = 20;
			_removeButton.x = _backGround.x + 240;
			_removeButton.y = _backGround.y;
			_removeButton.alpha = 0.8;
			_removeButton.scaleX = _removeButton.scaleY = 0.001;
			
			//begin animation when added to stage
			this.addEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
		}
		
		private function sensor_rollOut(e:MouseEvent):void 
		{
			_removeButton.alpha = 0.8;
		}
		
		private function sensor_rollOver(e:MouseEvent):void 
		{
			_removeButton.alpha = 1;
		}
		
		private function sensor_click(e:MouseEvent):void 
		{
			callBackAnimation();
			disposeIt();
			e.target.mouseEnabled = false;
		}
		
		private function callBackAnimation():void 
		{
			_animationBackX = new FPTween( { duration:1.5, property:FPTProperties.SCALEX, ease:FPTEaseTypes.ELASTIC_IN_OUT, target:_backGround, finish:0.01 } );
			_animationBackY = new FPTween( { duration:1.5, property:FPTProperties.SCALEY, ease:FPTEaseTypes.ELASTIC_IN_OUT, target:_backGround, finish:0.01 } );
			_animationremX = new FPTween( { duration:1.5, property:FPTProperties.SCALEX, ease:FPTEaseTypes.ELASTIC_IN_OUT, target:_removeButton, finish:0.01 } );
			_animationremY = new FPTween( { duration:1.5, property:FPTProperties.SCALEY, ease:FPTEaseTypes.ELASTIC_IN_OUT, target:_removeButton, finish:0.01} );
			_animationBackY.start();
			_animationBackX.start();
			_animationremY.start();
			_animationremX.start();
			_animationBackX.addEventListener(FPTEvent.FINISH, animationBackX_finish);
			
		}
		
		private function animationBackX_finish(e:FPTEvent):void 
		{
		  	dispatchEvent(new ButtonEvent(EventConst.CLICK_BUTTON));
			_animationBackX.removeEventListener(FPTEvent.FINISH, animationBackX_finish);
		}
		
	
		
		private function this_addedToStage(e:Event):void 
		{
			_animationBackX = new FPTween( { duration:1.5, property:FPTProperties.SCALEX, ease:FPTEaseTypes.ELASTIC_IN_OUT, target:_backGround, finish:1 } );
			_animationBackY = new FPTween( { duration:1.5, property:FPTProperties.SCALEY, ease:FPTEaseTypes.ELASTIC_IN_OUT, target:_backGround, finish:1 } );
			_animationremX = new FPTween( { duration:1.5, property:FPTProperties.SCALEX, ease:FPTEaseTypes.ELASTIC_IN_OUT, target:_removeButton, finish:1 } );
			_animationremY = new FPTween( { duration:1.5, property:FPTProperties.SCALEY, ease:FPTEaseTypes.ELASTIC_IN_OUT, target:_removeButton, finish:1 } );
			_animationBackY.start();
			_animationBackX.start();
			_animationremY.start();
			_animationremX.start();
			
			var sensor:Sprite = new Sprite();
			sensor.graphics.beginFill(0x456346, 0);
			sensor.graphics.drawCircle(_removeButton.x+30,_removeButton.y+30,60);
			sensor.graphics.endFill();
			this.addChild(sensor);
			
			sensor.buttonMode = true;
			_toolBack = new ToolTip(20, 20, 55, 40);
			_toolBack.register(sensor, "back");
			sensor.addEventListener(MouseEvent.CLICK, sensor_click);
			sensor.addEventListener(MouseEvent.ROLL_OVER, sensor_rollOver);
			sensor.addEventListener(MouseEvent.ROLL_OUT, sensor_rollOut);
			
			removeEventListener(Event.ADDED_TO_STAGE, this_addedToStage);
			_buttons = new Vector.<ButtonView>;
			var button:ButtonView;
			var yDelta:Number = - 120;
			var index:int = 1;
			
			
			for (var i:int = 0; i < _buttonsCount ; i++) 
			{
				button = new ButtonView();
				button.y = yDelta + 50 * i;
				this.addChild(button);
				button.name = "button"+index;
				index++;
				_buttons.push(button);
				button.addEventListener(EventConst.CLICK_TARGET, button_clickTarget,false,0,true);
			}
			
		}
		
		private function button_clickTarget(e:ButtonEvent):void 
		{
			trace(e.target.name);
		}
		private function disposeIt():void 
		{
			for (var i:int = 0; i < _buttonsCount; i++) 
			{
				trace("dispose");
				var button:ButtonView = _buttons[i];
				button.buttonCallBack();
				button.mouseEnabled = false;
				button.disposeListeners();
			}
		}
		
	}

}
