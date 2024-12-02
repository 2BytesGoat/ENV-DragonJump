extends Node


func format_time(milliseconds: int) -> String:
	var total_seconds = milliseconds / 1000
	var minutes = total_seconds / 60.0
	var seconds = total_seconds % 60
	var ms = milliseconds % 1000 / 10.0  # We want to display two digits for milliseconds
	return "%02d:%02d.%02d"%[minutes, seconds, ms]

func generate_uuid_from_string(input_string: String) -> String:
	# Generate MD5 hash
	var md5_hash = input_string.md5_text()
	
	# Convert the MD5 hash to uppercase and format it as a UUID
	var formatted_uuid = md5_hash.substr(0, 8) + "-" + \
						 md5_hash.substr(8, 4) + "-" + \
						 md5_hash.substr(12, 4) + "-" + \
						 md5_hash.substr(16, 4) + "-" + \
						 md5_hash.substr(20, 12)
	
	return formatted_uuid.to_upper()
