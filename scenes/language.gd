extends HBoxContainer

enum Language {ENGLISH, SPANISH}
@onready var language_option: OptionButton = $OptionButton

func _ready():
	var locale = TranslationServer.get_locale()
	match locale:
		"en", "en_US", "en_GB":
			language_option.select(Language.ENGLISH)
		"es", "es_ES", "en_MX":
			language_option.select(Language.SPANISH)
		_:
			language_option.select(Language.ENGLISH)
func _on_option_button_item_selected(index: int) -> void:
	match index:
		Language.ENGLISH:
			TranslationServer.set_locale("en")
		Language.SPANISH:
			TranslationServer.set_locale("es")
