package vkConnection.vkView 
{
	import view.toolTip.ToolTip;
	import vkConnection.vkEvents.EventVk;
	import flash.display.DisplayObject;
	import flash.display.Loader;
	import flash.display.Sprite;
	import flash.net.URLRequest;
	import flash.net.URLLoader;
	import flash.text.TextField;
	import vk.APIConnection;
	import vk.*;
	import flash.events.Event;
	import flash.display.Bitmap;
	import vkConnection.vkView.AvatarView;
	import flash.events.MouseEvent;
	import events.GlobalDispatcher;
	import events.GameEvent;
	import events.EventConstants;
	/**
	 * ...
	 * @author ф
	 */
	public class VkClass extends Sprite 
	{
		private var VK:APIConnection ;
		private var flashVars:Object;
		private var _stateLoad:Boolean;
		private var api_id:Number;
        private var viewer_id:Number;
        private var sid:String;
        private var secret:String;
		private var myName:String;
		private var mySurname:String;
		private var _toolT:ToolTip;
		private var loader:Loader;
		private var _scopeFriends:Array;
		private var _deltaY:Number =-50;
		private var _sensor:Sprite;
		private const ZERO_POINT:int = 560;
		
		
		public function VkClass() 
		{		
			loader = new Loader();	
			flashVars = Facade.gameStage.loaderInfo.parameters as Object;
			_scopeFriends = new Array;			
		
		/*flashVars['api_id'] = 5236999;
        flashVars['viewer_id'] = 159626623;
        flashVars['sid'] = "ba63eb0064c9df977a4537adb99f6f940e3dcf5606dbd09a5ddd2f6fa2b92e273d7f00fac7e87b5f4790c";
        flashVars['secret'] = "3299ab1dbb";*/
		
        api_id = flashVars['api_id'];
		viewer_id = flashVars['viewer_id'];
		sid = flashVars['sid'];
		secret = flashVars['secret'];
		
		VK = new APIConnection(flashVars);
		if (VK) 
		{
			 onAdded();//aon click to start button
		}
		GlobalDispatcher.listen(EventConstants.BACK_TO_MENU, onRemoved);          
		}
		
		private function onAdded():void
		{
		if (!_stateLoad) 
		{
			VK.api('friends.get', {fields:'first_name,last_name,photo_50',https:1}, loadFriendsScope, onErr);//писок друзей first_name,last_name
		}	
		    VK.api('users.get', {fields:'photo_50',https:1}, loadPlayerAvatar, onErr);
			
			if (!_sensor) 
			{
				_sensor = new Sprite();
				_sensor.graphics.beginFill(0x456346, 0);
				_sensor.graphics.drawRect(ZERO_POINT,90,60,440);
				_sensor.graphics.endFill();
				_sensor.buttonMode = true;
				_toolT = new ToolTip(-220, 20, 220, 30);
				_toolT.register(_sensor, 'Пригласить друзей');
				 Facade.gameStage.addChild(_sensor);
				_sensor.addEventListener(MouseEvent.CLICK, sensor_click);
			}
			
		}
		
		private function sensor_click(e:MouseEvent):void 
		{
			//invite friends
			VK.callMethod('showInviteBox');
		}
		private function onRemoved(e:GameEvent):void
		{
		   if (Facade.gameStage.contains(_sensor)) 
		   {
			   _sensor.removeEventListener(MouseEvent.CLICK, sensor_click);
			   Facade.gameStage.removeChild(_sensor);   
			   removeFriends();
		   }
		}
		
		private function removeFriends():void 
		{
			
			var lenght:int = _scopeFriends.length;
			for (var i:int = 0; i < lenght; i++) 
			{
				Facade.gameStage.removeChild(_scopeFriends[i]);
			}
			VkSource.destroy();
		
		}
		private function loadFriendsScope(data:Object):void 
		{
			
			if (!_stateLoad) 
			{
				for (var i:int = 0; i <5 ; i++) 
				{
					var loader:Loader = new Loader();
					loader.load(new URLRequest(data[i].photo_50));
					loader.contentLoaderInfo.addEventListener(Event.COMPLETE, im_complete);
				}
				_stateLoad = true;
				_deltaY = -50;
			}		
		}
			
			
		private function im_complete(e:Event):void 
		{
			var image2:Bitmap = e.target.content;
			image2.smoothing = true;
			var mask:Bitmap = VkSource.this_mask;
			Facade.gameStage.addChild(image2);
			Facade.gameStage.addChild(mask);
			_deltaY += 70;
			image2.x = ZERO_POINT;
			mask.x = ZERO_POINT - 2;
			image2.y = 80 +_deltaY; 
			mask.y = 80 +_deltaY - 1;	 
		   _scopeFriends.push(image2);
			 
		}
		
		
		public function  destroyVkConnection():void
		{
			flashVars = Facade.gameStage.loaderInfo.parameters as Object;
			api_id = flashVars['api_id'];
			viewer_id = flashVars['viewer_id'];
			sid = flashVars['sid'];
			secret = flashVars['secret'];
			VK = new APIConnection(flashVars);
			//destroy all vk connections 
			VK = null;
			flashVars = null;
			
		}
			
		private function loadPlayerAvatar(data:Object):void 
		{
			loader.load(new URLRequest(String(data[0].photo_50)));
			trace(data[0].photo_50);
			myName = data[0].first_name;
			mySurname =data[0].last_name;
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, loader_complete);
		}
		private function onErr(data:Object):void 
		{
			trace(data.error_msg);
		}
			
		private function loader_complete(e:Event):void 
		{
			 var image1:Bitmap = e.target.content as Bitmap;
			 dispatchEvent(new EventVk(EventVk.ADD_PLAYER,{img: image1,name:myName,surName:mySurname}));
			
			 /*var mask:Bitmap = WindowView.this_mask;
		     addChild(image1);
			 addChild(mask);
		     
			 image1.x =mask.x = stage.stageWidth/2;
			 image1.y =mask.y = stage.stageHeight/2;*/
			
		}
	}

}
			
		