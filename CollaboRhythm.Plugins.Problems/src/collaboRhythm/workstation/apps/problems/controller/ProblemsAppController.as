package collaboRhythm.workstation.apps.problems.controller
{
	import collaboRhythm.workstation.apps.problems.model.ProblemsHealthRecordService;
	import collaboRhythm.workstation.apps.problems.model.ProblemsModel;
	import collaboRhythm.workstation.apps.problems.view.ProblemsFullView;
	import collaboRhythm.workstation.apps.problems.view.ProblemsWidgetView;
	import collaboRhythm.workstation.controller.apps.WorkstationAppControllerBase;
	
	import mx.core.IVisualElementContainer;
	import mx.core.UIComponent;
	
	public class ProblemsAppController extends WorkstationAppControllerBase
	{
		private var _widgetView:ProblemsWidgetView;
		private var _fullView:ProblemsFullView;
			
		public override function get widgetView():UIComponent
		{
			return _widgetView;
		}
		
		public override function set widgetView(value:UIComponent):void
		{
			_widgetView = value as ProblemsWidgetView;
		}
		
		public override function get fullView():UIComponent
		{
			return _fullView;
		}
		
		public override function set fullView(value:UIComponent):void
		{
			_fullView = value as ProblemsFullView;
		}

		public function ProblemsAppController(widgetParentContainer:IVisualElementContainer, fullParentContainer:IVisualElementContainer)
		{
			super(widgetParentContainer, fullParentContainer);
		}
		
		protected override function createWidgetView():UIComponent
		{
			var newWidgetView:ProblemsWidgetView = new ProblemsWidgetView();
			if (_user != null)
				newWidgetView.model = _user.getAppData(ProblemsModel.PROBLEMS_KEY, ProblemsModel) as ProblemsModel;
			return newWidgetView;
		}
		
		protected override function createFullView():UIComponent
		{
			var newFullView:ProblemsFullView = new ProblemsFullView();
			if (_user != null)
				newFullView.model = _user.getAppData(ProblemsModel.PROBLEMS_KEY, ProblemsModel) as ProblemsModel;
			return newFullView;
		}
		
		private function get problemsModel():ProblemsModel
		{
			if (_user != null)
			{
				if (_user.appData[ProblemsModel.PROBLEMS_KEY] == null)
				{
					_user.appData[ProblemsModel.PROBLEMS_KEY] = new ProblemsModel();
				}
				return _user.getAppData(ProblemsModel.PROBLEMS_KEY, ProblemsModel) as ProblemsModel;
			}
			return null;
		}
		
		public override function initialize():void
		{
			super.initialize();
			if (problemsModel.initialized == false)
			{
				var problemsHealthRecordService:ProblemsHealthRecordService = new ProblemsHealthRecordService(_healthRecordService.consumerKey, _healthRecordService.consumerSecret, _healthRecordService.baseURL);
				problemsHealthRecordService.copyLoginResults(_healthRecordService);
				problemsHealthRecordService.loadProblems(_user);
			}
			if (_widgetView)
				(_widgetView as ProblemsWidgetView).model = problemsModel;

			if (_fullView)
				_fullView.model = problemsModel;
		}
	}
}