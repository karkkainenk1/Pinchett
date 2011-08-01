<?php
$link = mysql_connect('localhost', 'proto', 'jr89gdslj3r80');

$db = mysql_select_db('proto', $link);

?>
<!DOCTYPE html>
<html>
<head>
<meta name="viewport" content="initial-scale=1.0, user-scalable=no" />
<style type="text/css">
  html { height: 100% }
  body { height: 100%; margin: 0px; padding: 0px }
  #map_canvas { height: 100% }
</style>
<script type="text/javascript"
    src="http://maps.google.com/maps/api/js?sensor=false">
</script>
<script type="text/javascript" src="js/smartinfo.js"></script>
<script type="text/javascript">
  function initialize() {
    var latlng = new google.maps.LatLng(60.176355, 24.936218);
    var myOptions = {
      zoom: 2,
      center: latlng,
      mapTypeId: google.maps.MapTypeId.ROADMAP
    };
    var map = new google.maps.Map(document.getElementById("map_canvas"),
        myOptions);

<?php
$result = mysql_query("SELECT * FROM stories");
$stories = mysql_fetch_array($result);
while($story = mysql_fetch_array($result)) {
	echo "\n";
	$result2 = mysql_query("SELECT * FROM users WHERE id=".$story['user_id']);
	$user = mysql_fetch_array($result2);
	$result3 = mysql_query("SELECT * FROM texts where story_id=".$story['id']." ORDER BY id");

	$content = "<div style=\"margin:10px\"><h3>".$user['name'].": ".$story['headline']."</h3>";
	$content .= "<ul>";
	while($text = mysql_fetch_array($result3)) {
		$result4 = mysql_query("SELECT * FROM users WHERE id=".$text['user_id']);
		$textuser = mysql_fetch_array($result4);
		$content .= "<li>".$textuser['name'].": ".$text['content']."</li>";
	}
	$content .= "</ul></div>";

	$content = str_replace("'", "\"", $content);
	$content = utf8_decode($content);
	$story['headline'] = utf8_decode($story['headline']);
	$story['headline'] = str_replace('"', '', $story['headline']);
	?>
	var marker<?php echo $story['id']; ?> = new google.maps.Marker({
		position: new google.maps.LatLng(<?php echo $story['latitude']; ?>, <?php echo $story['longitude']; ?>),
		map: map,
		title: "<?php echo htmlentities($user['name']); ?>: <?php echo $story['headline']; ?>"
	});
	google.maps.event.addListener(marker<?php echo $story['id']; ?>, 'click', function(e) {
    		var infobox = new SmartInfoWindow({position: marker<?php echo $story['id']; ?>.getPosition(), map: map, content: '<?php echo $content; ?>'});
  	});
	<?php
}
?>

  }

</script>
</head>
<body onload="initialize()">
  <div id="map_canvas" style="width:100%; height:100%"></div>
</body>
</html>
