<?php
/**
 *  This file is part of amfPHP
 *
 * LICENSE
 *
 * This source file is subject to the license that is bundled
 * with this package in the file license.txt.
 * @package Tests_TestData
 */

//uncomment to log request
/*
function getRawPostData(){
    if (isset($GLOBALS['HTTP_RAW_POST_DATA'])) {
        return $GLOBALS['HTTP_RAW_POST_DATA'];
    }else{
        return file_get_contents('php://input');
    }
}
file_put_contents('request.amf', getRawPostData());
*/
/** 
 * a gateway php script like the normal gateway except that it uses test services 
 * @author Ariel Sommeria-klein
 */
require_once dirname(__FILE__) . '/../../Amfphp/ClassLoader.php';
require_once dirname(__FILE__) . '/TestServicesConfig.php';
$config = new TestServicesConfig();
$gateway = Amfphp_Core_HttpRequestGatewayFactory::createGateway($config);
$gateway->service();
$output = $gateway->output();
//uncomment to log response
//file_put_contents('response.amf', $output);



?>
