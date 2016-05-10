package view 
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import ru.flashpress.tween.FPTween;
	import view.animatedPanel.ButtonEvent;
	import view.animatedPanel.PanelView;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.filters.GlowFilter;
	import flash.text.TextField;
	import superClasses.BaseClass;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import events.GlobalDispatcher;
	import events.GameEvent;
	import ru.flashpress.mc.display.FPMovieClip;
	import ru.flashpress.mc.events.FPMCEvent;
	import ru.flashpress.tween.display.FPTSprite;
	import ru.flashpress.tween.core.constants.FPTEaseTypes;
	import ru.flashpress.tween.core.constants.FPTProperties;
	
	import ru.flashpress.tween.events.FPTEvent;
	import flash.text.TextFormat;
	import events.*;
	import view.animatedPanel.ButtonView;
	import view.animatedPanel.ButtonsSource;
	import view.toolTip.ToolTip;
	import view.toolTip.ToolTipBase;
	import view.animatedPanel.EventConst;
	import flash.filters.BlurFilter;
	import flash.geom.Rectangle;
	
	/**
	 * ...
	 * @author ф
	 */
	public class MainView extends BaseClass
	{
		private const DAMAGE_TXT_X:int = -550;
		private const DAMAGE_TXT_Y:int = 95;
		private const FINISH_D_TXT:int = 300;
		private const BOT_POSITION_X:int = 70;
		private const BOT_POSITION_Y:int = 330;
		private const LIFE_BAR_X:int = 195;
		private const LIFE_BAR_Y:int = 97;
		
		private var _screens:gameScreen;
		private var _tempSymbolsCont:MovieClip;
		private var _clipsList:Vector.<MovieClip>;
		private var _clipsActiveList:Vector.<MovieClip>;
		//
		private var _bot:FPMovieClip;
		//
		private var _lifeTextCont:FPTSprite;
		private var _lifeTxtField:TextField;
		private var _botCreate:Boolean;
		private var _loadScreen:MovieClip;
		private var _lifeBar:MovieClip;
		private var _animPanel:Sprite;
		private var _gameOver:Sprite;
		private var _toolButtonStart:ToolTip;
		private var _toolLife:ToolTip;
		private var _toolBot:ToolTip;
		private var _toolBack:ToolTip;
		private var _toolLifeTxt:ToolTip;
		//
	        private var _lifeFrame:int;
		private var _lifeTxt:int;
		private var _blurPause:BlurFilter;
		public function MainView() 
		{
			
			super();//call to constructor BaseClass for func on Register
			
		}
		override protected function onRegister():void //already call in constructor BaseClass
		{
			//bot creating
			  _botCreate = false;
			  _bot = new FPMovieClip(bot);
			   lifeUpdatesInit();
			//
			  _lifeBar = new lifebar();
			//   
			  ToolTipBase.init(Facade.gameStage);
			  toolTipInit();
			//
			  _gameOver = new GameOverView();
			  _screens = new gameScreen();//view of Main menu and Game 
			  _lifeFrame = 0;
			  _toolButtonStart.register(_screens.getChildByName("opt_butN") as DisplayObject,'внутри - анимированная панель'+ "\n"+'с кнопками');
			  _tempSymbolsCont = new temp();
			  _loadScreen = new loadScreen();
			   Facade.gameStage.addChild(_screens);
		           Facade.gameStage.addChild(_loadScreen);
			// 
			//add to existing stage
			//
			  _clipsActiveList = new Vector.<MovieClip>;//init _clipsActiveList for items which opened
			//
	       	          _screens.addEventListener(MouseEvent.CLICK, screens_click);//select and click for menu buttons and interactive items
	         	  _screens.addEventListener(MouseEvent.MOUSE_OVER, screens_over);
			//
		          _bot.addEventListener(FPMCEvent.RASTERIZATION_PROGRESS, bot_rasterizationProgress);
			  _bot.addEventListener(FPMCEvent.RASTERIZATION_COMPLETE, bot_rasterizationComplete);
				
	    }
		
		private function lifeUpdatesInit():void 
		{
			_lifeTextCont = new FPTSprite();
			_lifeTxtField = new TextField();
			_lifeTxtField.selectable = false;
			_lifeTxtField.defaultTextFormat = new TextFormat('Arial', 33, 0x9428FF,true);
			_lifeTxtField.text ="-"+ String(Settings.DAMAGE);
			_lifeTextCont.addChild(_lifeTxtField);
			_lifeTextCont.x = DAMAGE_TXT_X;
			_lifeTextCont.y = DAMAGE_TXT_Y;
		}
		
		private function toolTipInit():void 
		{
			_toolButtonStart = new ToolTip( -180, 20, 370, 70)
			_toolLife = new ToolTip(20, 20, 185, 30);
			_toolBot = new ToolTip(20, 20, 185, 30);
			_toolBack = new ToolTip(-170, 20, 365, 30);
			_toolLifeTxt = new ToolTip(-170, 20, 400, 60);
		}
		private function animPanel_select(e:ButtonEvent):void 
		{
			trace("KILL");
			Facade.gameStage.removeChild(_animPanel);
			Facade.gameStage.addChild(_screens);
		}
		
		public function onReadyRasterization():void
		{
		   Facade.gameStage.removeChild(_loadScreen);
		   _bot.gotoAndPlay('idle');
		   _bot.y = BOT_POSITION_Y;
		   _bot.x = BOT_POSITION_X;
                   _botCreate = true;
		}
		
		private function bot_rasterizationProgress(e:FPMCEvent):void 
		{
		    
			var percent:Number = Math.floor(e.currentFrame/e.totalFrames*100); 
			(_loadScreen.getChildByName('loadTf') as TextField).text = percent + "%";
			
		}
		
		private function bot_rasterizationComplete(e:FPMCEvent):void 
		{
			GlobalDispatcher.dispatch(new GameEvent(EventConstants.READY_TO_START));
			_bot.removeEventListener(FPMCEvent.RASTERIZATION_PROGRESS, bot_rasterizationProgress);
			_bot.removeEventListener(FPMCEvent.RASTERIZATION_COMPLETE, bot_rasterizationComplete);
		}
		
		private function screens_enterFrame(e:Event):void //animations for different states of knight
		{
		   if (_screens.contains(_bot) && _bot.currentLabel == 'idle_end'||_bot.currentLabel == 'attack_end'||_bot.currentLabel=='wound_end') 
		   {
			   _bot.gotoAndPlay('idle');
		   }
		   if (_screens.contains(_bot) && _bot.currentLabel == 'die_end')
		   {
			   _bot.gotoAndStop('stop_die');
		   }
		   
		}
			
		private function screens_over(e:MouseEvent):void 
		{
			
			switch (e.target.name) 
			{
	        		case "back_c": 
				  e.target.buttonMode = true;  
				  
				break;
		       	       case "instance1":
				  e.target.buttonMode = false;
				  
		         	    break;
				default:
			}
		}
		
		public function onReadyToDrawView(e:GameEvent):void 
		{
		  
			trace("Ready_to_Draw");
			var symbols:Vector.<uint> = e.params as Vector.<uint>;//if dont set e.params to vector we will catch error!
			
			for (var i:uint = 0; i <symbols.length ; i++) 
			{
				forBuildSymbol(symbols[i]);//call this function twice to set same color items
				//forBuildSymbol(symbols[i]);//arg is number of frame
			}
			
			refreshItemsList();//write color items mc to _clipsList
			_screens.addEventListener(Event.ENTER_FRAME, screens_enterFrame);//observe states of knight
			onAllItemsDrawedView();	
		}
		private function createDamageTxt():void 
		{
			_lifeTextCont.x =DAMAGE_TXT_X;
			_lifeTextCont.y =DAMAGE_TXT_Y;
			Facade.gameStage.addChild(_lifeTextCont);
			_lifeTextCont.alpha = 0;
		}
		
		private function forBuildSymbol($index:uint):void 
		{
			var symb:MovieClip = new symbol();
			//	
			symb.name = "symbol";	
			symb.gotoAndStop($index);//0- 1 случайное значение 1 индекс 2 случ значения 2 -6...7-3
			symb.x = _screens.symbolsContainer.getChildAt(0).x;
			symb.y = _screens.symbolsContainer.getChildAt(0).y;
			//
			_screens.symbolsContainer.getChildAt(0).alpha = 0;//turn dummys to tempContainer and add color Items to left space on screen
			_tempSymbolsCont.addChild(_screens.symbolsContainer.getChildAt(0)); //symbolsContainer - пустой мувиклип внутри _скринс в который добавляются нужные мувики(определяется как var)
			_screens.symbolsContainer.addChild(symb);//определяем верхний клип в контейнере и в его координаты пишем случайную карту затем удаляем клип и так пока не кончатся
		}
			
		private function onAllItemsDrawedView():void//
			{
				trace("items drawed");
				for (var i:uint = 0; i <_clipsList.length ; i++) 
				{
					_clipsList[i].back_c.gotoAndStop("free");//open item	
				}
				delay(Settings.DELAY_START, onAllItemsHided);//for 1500 milliseconds
				_screens.mouseChildren = false;//blocked to click and avoid error with timer
			}
		
		private function onAllItemsHided(for_args:Object=null):void //BaseClass function _callback create empty argument
				{
					_screens.mouseChildren = true;
					
					trace("items Hided");
					
					for (var i:uint = 0; i <_clipsList.length ; i++) 
					{
						_clipsList[i].back_c.gotoAndStop("back");//hide item
					}
				}
		
		public function onPermittToAdd($itemOpen:MovieClip):void 
		{
			_clipsActiveList.push($itemOpen);//get color $item from model and push it to massive active items
			 $itemOpen.back_c.gotoAndStop("free");//click for back and show color item		
		}
	
		public function onResultTurnView($resultTurn:Boolean):void 
		{
			delay(Settings.DELAY,resultHandler,$resultTurn);//e turn to _args ->resultHandler(e)
			
		}
	
		private function resultHandler($resultTurn:Boolean):void 
		{
			if ($resultTurn as Boolean)//from model.chekItems():Boolean 
			{
				for (var i:int = 0; i <_clipsActiveList.length ; i++) 
				{
					_clipsActiveList[i].parent.removeChild(_clipsActiveList[i]);//vector movieClip remove color item			
				}
				_bot.gotoAndPlay("wound");//beat a knight
				
				(_screens.getChildByName("textScore") as TextField).text = String(Facade.gameModel.getScoreTxt());//get score and set it to TextField
				GlobalDispatcher.dispatch(new GameEvent(EventConstants.END_TURN));
			}
			else 
			{
				for ( var j:int = 0; j < _clipsActiveList.length; j++) 
				{
					_clipsActiveList[j].back_c.gotoAndStop("back");//close item
				}
				_bot.gotoAndPlay("attack");
				// SET LIFE FROM MODEL
				 animText();
				 delay(Settings.DELAY_HIT, updateLifeBar);
				//
				//
				(_screens.getChildByName("textScore") as TextField).text = String(Facade.gameModel.getScoreTxt());
			}
			_clipsActiveList.length = 0;//reset massive
			refreshItemsList();//write to _symbolList new color items which stay after turn
			//call to end turn in model which set IDLE_STATE
		}
		
		private function updateLifeBar($for_args:Object=null):void 
		{
			_lifeBar.gotoAndStop(_lifeFrame);
			//for repair null error
			if (_screens.contains(_lifeBar)) 
			{
				//need to spread to different dunction
				GlobalDispatcher.dispatch(new GameEvent(EventConstants.SWORD_HIT));
				(_screens.getChildByName("lifeTxtCount")as TextField).text=String(_lifeTxt);	
			}			
		}
		
		private function animText():void 
		{
			
			var twA:FPTween = new FPTween({ duration:1.7, property:FPTProperties.ALPHA, ease:FPTEaseTypes.STRONG_IN_OUT, target: _lifeTextCont, finish:1 });
			var tw:FPTween = new FPTween({ duration:1.7, property:FPTProperties.X, ease:FPTEaseTypes.ELASTIC_OUT, target: _lifeTextCont, finish:FINISH_D_TXT });
			tw.start();
			twA.start();
			tw.addEventListener(FPTEvent.FINISH, tw_finish);
			twA.addEventListener(FPTEvent.FINISH, twA_finish);
			
		}
		
		private function twA_finish(e:FPTEvent):void 
		{
			_lifeTextCont.alpha = 0;
			 GlobalDispatcher.dispatch(new GameEvent(EventConstants.END_TURN));
		}
		
		private function tw_finish(e:FPTEvent):void 
		{
			_lifeTextCont.x = DAMAGE_TXT_X;
		}
		
		public function lifeUpdateView($obj:Object):void 
		{
			var obj:Object = { };
			obj = $obj;
			_lifeFrame = obj.frame;
			_lifeTxt = obj.txt;
		
		}
		public function onCounterView($movesCounter:uint):void 
		{
			(_screens.getChildByName("textMove") as TextField).text = String($movesCounter);
			(_screens.getChildByName("textScore") as TextField).text = String(Facade.gameModel.getScoreTxt());	
		}
	
		private function refreshItemsList():void 
		{
			
			_clipsList.length = 0;
			
			for (var i:uint = 0; i <_screens.symbolsContainer.numChildren ; i++) 
			{
				_clipsList.push(_screens.symbolsContainer.getChildAt(i));//push to clips list all color items contained in symbolContainer
			}
			if (_screens.symbolsContainer.numChildren==0 && _screens.contains(_bot)) 
			{
				_bot.gotoAndPlay('die');
				_screens.mouseChildren = false;
				(_screens.getChildByName("textScore") as TextField).text = String(Facade.gameModel.getScoreTxt());
			}
		}
	
		private function screens_click(e:MouseEvent):void 
		  {
			
		switch (e.target.name) 
		   	 {
			case "start_butN"://start button on 'menu' _screen
			
				startGame();
			break;
			
			case "back_btnN"://back button on 'game' _screen
			   
				backToMenu();
			break;
			case "opt_butN"://options button on 'menu' _screen
			
				options();	
			break;
			case "back_c"://back card  
				var event:GameEvent = new GameEvent(EventConstants.CLICK_TO_CARD, e.target.parent)
				GlobalDispatcher.dispatch(event);//диспатчим клик по итему и сохраняем конкретный итем в параметре ивента parent!!потому что таргет бэк а парент цвет	    
				trace("current Card is "+e.target.parent.currentLabel);
	         	   }
		  }
	
		  private function startGame():void 
		  {
			  _clipsList = new Vector.<MovieClip>;
			  _clipsList.length = 0;
			  
				  _screens.gotoAndStop("game");
				  if (_botCreate) 
				  {
					   MyApp.getVk();
					  _screens.addChild(_bot);
					  _screens.addChild(_lifeBar);
					  _lifeBar.gotoAndStop(0);
					   addTollTips();
					  //
					  _lifeBar.x = LIFE_BAR_X;
					  _lifeBar.y = LIFE_BAR_Y;
					  _bot.gotoAndPlay('idle');
					  //
					  GlobalDispatcher.dispatch(new GameEvent(EventConstants.START_GAME));
				  }	
			 createDamageTxt();
		  }
		  
		 
		  public function turnButtonsOff($turnOff:Boolean):void 
		  {
			  if ($turnOff) 
			  {
				  _screens.mouseChildren = false;
			  }
			  else 
			  {
				  _screens.mouseChildren = true;
			  }
			  
		  }
	
		  public function backToMenu():void 
		   {
			   
			   _screens.gotoAndStop("menu");
			   if (_screens.contains(_bot)) 
			   {           
			           _screens.removeEventListener(Event.ENTER_FRAME, screens_enterFrame);
			           _screens.removeChild(_bot);  
			   }
			   if (_screens.contains(_lifeBar)) 
			   {
				   _screens.removeChild(_lifeBar);
				   
			   }
			   if (Facade.gameStage.contains(_gameOver)) 
			   {
				   Facade.gameStage.removeChild(_gameOver);
			   }
			 _toolButtonStart = new ToolTip( -180, 20, 370, 70);
			 _toolButtonStart.register(_screens.getChildByName("opt_butN") as DisplayObject,'внутри - анимированная панель'+ "\n"+'с кнопками');
			  //
		         _tempSymbolsCont.lenght = 0;
		         _clipsList.length = 0;
			 Facade.gameStage.removeChild(_lifeTextCont); 
			 //
			 GlobalDispatcher.dispatch(new GameEvent(EventConstants.BACK_TO_MENU));   
		   }
	           private function addTollTips():void 
		   {
			  if (_screens.contains(_lifeBar)) 
			  {
				  _toolLife.register(_lifeBar, "Уровень жизни");
				  _toolBot.register(_bot, "Это ваш враг");
				  _toolBack.register(_screens.getChildByName("textMove") as DisplayObject, "Открываем карты-считаем ходы");
				  _toolLifeTxt.register(_screens.getChildByName("lifeTxtCount") as DisplayObject, "Когда уровень жизни падает до 0"+ "\n" +"       -происходит гейм овер");//TODO text!!!!!!!!!!!!!!!!!!!!!!!!!!!!
			  } 
		   }
		   public function gameOverView():void 
		   {
			   Facade.gameStage.addChild(_gameOver);
		   }
		   
		   private function refresh():void 
			{   
					_clipsList.length = 0;
					 GlobalDispatcher.dispatch(new GameEvent(EventConstants.START_GAME));
			}
	
	        	public function nextLevel():void 
			{
				backToMenu();
			}
 
			private function options():void 
			  {
				//_screens.gotoAndStop("options");
				_animPanel = new PanelView();
				_animPanel.addEventListener(EventConst.CLICK_BUTTON, animPanel_select);
				Facade.gameStage.removeChild(_screens);
				//
				Facade.gameStage.addChild(_animPanel);
				//Facade.gameController.removeListenersController();//for remove all listeners which calls in controller
			  }
			}
			
          }

		

		
	
	
	

	
 


	





