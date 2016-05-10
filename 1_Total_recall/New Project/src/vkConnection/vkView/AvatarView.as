package vkConnection.vkView
{
	import flash.display.Bitmap;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import ru.flashpress.tween.display.FPTSprite;
	import ru.flashpress.tween.FPTween;
	import ru.flashpress.tween.events.FPTEvent;
	import ru.flashpress.tween.core.constants.FPTProperties;
	import ru.flashpress.tween.core.constants.FPTEaseTypes;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.net.URLRequest;
	import flash.text.TextField;
	import vkConnection.vkEvents.EventVk;
	import events.GlobalDispatcher;
	import events.GameEvent;
	import events.EventConstants;
	
	
	
	/**
	 * ...
	 * @author ф
	 */
	public class AvatarView extends Sprite 
	{
		[Embed(source = "../../../lib/maskAva.png")]
		private var maskClass:Class;
		private var _container:FPTSprite;
		private var _mask:Bitmap;
		private var _ramka:Bitmap;
		private var _avatar:Bitmap;
		private var _ava:Bitmap;
		private var _sensor:Sprite;
		private var _txt:String;
		private const START_X:int = 145;
		private const FINISH_X:int = 161;
	
		
		
		public function AvatarView() 
		{
			super();
			//_mask = this_mask();
			//addChild(_mask);
			_container = new FPTSprite();
			
			Facade.vkConnect.addEventListener(EventVk.ADD_PLAYER, createAvatar);
			//_container.addEventListener(MouseEvent.CLICK, container_click);
			GlobalDispatcher.listen(EventConstants.SWORD_HIT, hitsContainer);
			_mask = new maskClass();
			_ramka = VkSource.this_mask;
			_container.addChild(_mask);
			Facade.gameStage.addChild(_container);
			_container.x = START_X;
			_container.y = 70;
			GlobalDispatcher.listen(EventConstants.BACK_TO_MENU, removeVkAvatar);
		}
		
		private function removeVkAvatar(e:GameEvent):void
		{
			if (Facade.gameStage.contains(_container))
			{
				Facade.gameStage.removeChild(_container);
			}
			
		}
		
		private function createAvatar(e:EventVk):void 
		{
			
			if (!_avatar) 
			{
				_avatar = e.params.img as Bitmap;
				_avatar.scaleX = _avatar.scaleY =_ramka.scaleX=_ramka.scaleY = 1.1;
				_avatar.smoothing = true;
				_ava = _avatar;
				_container.addChild(_avatar);
				_avatar.x = 30
				_ramka.x= 30;
				_avatar.y =30 
				_ramka.y= 30;
				_container.addChild(_ramka);
				var tf:TextField = new TextField();
				tf.multiline = true;
				tf.textColor = 0xFFFFFF;
				tf.mouseEnabled = false;
				tf.text = '   ' + String(e.params.name) + '\n'
				tf.appendText(String(e.params.surName));//get object with fields:{img,name,surName}
			   _container.addChild(tf);
				_txt = tf.text;
				tf.y = 90;
				tf.x = 25;	
			}
			else
			{
				_container.addChild(_ava);
				_ava.x =_ramka.x= 30;
				_ava.y = _ramka.x = 30;
				_ava.scaleX = _ava.scaleY =_ramka.scaleX=_ramka.scaleY = 1.1;
				var tf1:TextField = new TextField();
				tf1.text = _txt;
				_container.addChild(tf1);
				tf1.y = 90;
				tf1.x = 25;
			}
			
		}
		
		private function hitsContainer(e:GameEvent):void 
		{
			var tw:FPTween = new FPTween( { property:FPTProperties.X, ease: FPTEaseTypes.ELASTIC_IN, duration:0.25, target: _container, finish:FINISH_X} );
			tw.start();
			tw.addEventListener(FPTEvent.FINISH, tw_finish);
		}
		
		private function tw_finish(e:FPTEvent):void 
		{
			var tw:FPTween = new FPTween( { property:FPTProperties.X, ease: FPTEaseTypes.ELASTIC_OUT, duration:0.25, target: _container, finish:START_X } );
			tw.start();
		}
		
		public function destroyAvatar():void
		{
			
		}
		
	}

}







