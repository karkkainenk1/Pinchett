<?php

class thumbComponent extends Object {
	function createThumb($filename, $newWidth, $newHeight) {
		$fullFilename = '/var/www/proto/app/webroot/img/userpics/'.basename($filename);
		$image = imagecreatefromjpeg($fullFilename);
		list($width, $height) = getimagesize($fullFilename);
		$widthRatio = $newWidth/$width;
		$heightRatio = $newHeight/$height;
		if($widthRatio > $heightRatio) {
			$newHeight = $height*$widthRatio;
		} else {
			$newWidth = $width*$heightRatio;
		}
		$image_p = imagecreatetruecolor($newWidth, $newHeight);
		imagecopyresampled($image_p, $image, 0, 0, 0, 0, $newWidth, $newHeight, $width, $height);
		imagejpeg($image_p, null, 100);
	}

	function createCutThumb($filename, $newWidth, $newHeight) {
		$fullFilename = '/var/www/proto/app/webroot/img/userpics/'.basename($filename);
		$image = imagecreatefromjpeg($fullFilename);
		list($width, $height) = getimagesize($fullFilename);
		$widthRatio = $newWidth/$width;
		$heightRatio = $newHeight/$height;
		$startx = 0;
		$starty = 0;
		if($widthRatio > $heightRatio) {
			$starty = (int)((($height*$widthRatio - $newHeight)/2)/$widthRatio);
			$height = $height-2*$starty;
		} else {
			$startx = (int)((($width*$heightRatio - $newWidth)/2)/$heightRatio);
			$width = $width-2*$startx;
		}
		$image_p = imagecreatetruecolor($newWidth, $newHeight);
		imagecopyresampled($image_p, $image, 0, 0, $startx, $starty, $newWidth, $newHeight, $width, $height);
		imagejpeg($image_p, null, 100);
	}
}
