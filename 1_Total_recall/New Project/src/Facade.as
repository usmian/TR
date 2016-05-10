package 
{
	import controller.MainController;
	import flash.display.Stage;
	import model.MainModel;
	import view.MainView;
	import view.PopUpView;
	import view.animatedPanel.ButtonView;
	import view.animatedPanel.PanelView;
	import vkConnection.vkView.VkClass;
	import vkConnection.vkView.AvatarView;
	/**
	 * ...
	 * @author ф
	 */
	public class Facade 
	{
	   
	   public static var gameStage:Stage ;//must stay first
	   public static var gameModel:MainModel;
	   public static var gameController:MainController;
	   public static var gameView:MainView;
	   public static var vkView:AvatarView;
	   public static var vkConnect:VkClass;
	   public static var popUp:PopUpView;
	   public static var animPanel:PanelView;
	   
	}

}
