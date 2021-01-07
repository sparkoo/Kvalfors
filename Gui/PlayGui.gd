extends Control

func playerDistanceUpdate(distance):
	$Distance.text = "%s m" % int(distance)
