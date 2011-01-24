package flexUnitTests
{
	import flash.events.AsyncErrorEvent;
	import flash.events.DataEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.NetStatusEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.NetConnection;
	import flash.net.ObjectEncoding;
	import flash.net.Responder;
	
	import flexunit.framework.TestCase;
	
	import org.amfphp.test.EnhancedNetConnection;
	import org.amfphp.test.ExternalizableDummy;
	import org.amfphp.test.ObjEvent;
	
	public class AuthenticationTests extends TestCase
	{
		private var _nc:EnhancedNetConnection;
		
		[Before]
		override public function setUp():void
		{
			
			_nc = new EnhancedNetConnection();
			_nc.connect(TestConfig.NC_GATEWAY_URL);
			
		}
		
		[After]
		override public function tearDown():void
		{
		}

		
		/**
		 * test in 2 calls: logout(to make sure no credentials are set), then try to access method
		 * note: simehow when debugging this messes up. Only run without breakpoints
		 * */
		public function testAccessingUnauthorizedMethod():void{
			_nc.addEventListener(EnhancedNetConnection.EVENT_ONSTATUS, addAsync(verifyAccessDenied, 1000));
			_nc.addEventListener(EnhancedNetConnection.EVENT_ONRESULT, afterLogoutTryToAccessAdminMethod);
			_nc.simpleCall("AuthenticationService/logout");	
			
		}
		
		
		private function afterLogoutTryToAccessAdminMethod(event:ObjEvent):void{
			_nc.simpleCall("AuthenticationService/adminMethod");	
		} 
		
		public function verifyAccessDenied(event:ObjEvent):void{
			assertTrue(event.obj.faultString.indexOf("User not authenticated") != -1);
			
		}
		
		public function testAccessingProtectedMethodStep2WithCredentialsHeader():void{
			_nc.addEventListener(EnhancedNetConnection.EVENT_ONRESULT, addAsync(verifyAccessGranted, 500));
			_nc.addHeader("Credentials", true, {userid:"admin", password:"adminPassword"});
			_nc.simpleCall("AuthenticationService/adminMethod");	
		}
		
		public function verifyAccessGranted(event:ObjEvent):void{
			assertEquals("ok", event.obj);
			
		}
		

		
		
		
		
	}
}