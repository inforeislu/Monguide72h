package lu.gouvernement.monguide72h.models

enum class AppLanguage(val code: String, val displayName: String, val flag: String) {
    FR("fr", "Français", "🇫🇷"),
    PT("pt", "Português", "🇵🇹"),
    LU("lu", "Lëtzebuergesch", "🇱🇺"),
    DE("de", "Deutsch", "🇩🇪"),
    EN("en", "English", "🇬🇧"),
    ES("es", "Español", "🇪🇸"),
    IT("it", "Italiano", "🇮🇹");

    companion object {
        fun fromCode(code: String): AppLanguage {
            return entries.firstOrNull { it.code.equals(code, ignoreCase = true) } ?: PT
        }
    }
}
