package lu.gouvernement.monguide72h.models

enum class SirenType(val id: String, val durationLabel: String) {
    MONTHLY_TEST("test", "60 SECONDES"),
    WARNING("alert", "2 MINUTES"),
    NATIONAL_ALARM("alarm", "60 SECONDES"),
    ALL_CLEAR("end", "60 SECONDES (12s / PAUSE)");
}
