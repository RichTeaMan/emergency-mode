class_name TextLoad

static func load_success_sass() -> Array[String]:
	return load_text("res://resources/success_sass.txt")

static func load_fail_sass() -> Array[String]:
	return load_text("res://resources/fail_sass.txt")

static func load_text(path: String) -> Array[String]:
	var lines: Array[String] = []

	var file = FileAccess.open(path, FileAccess.READ)
	while !file.eof_reached():
		var line = file.get_line()
		if !line.is_empty():
			lines.append(line)
	file.close()
	return lines

static func random_element(list: Array):
	return list[randi() % list.size()]
