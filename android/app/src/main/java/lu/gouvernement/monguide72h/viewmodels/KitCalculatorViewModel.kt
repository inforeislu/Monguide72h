package lu.gouvernement.monguide72h.viewmodels

import android.content.Context
import androidx.compose.runtime.State
import androidx.compose.runtime.mutableIntStateOf
import androidx.compose.runtime.mutableStateListOf
import androidx.lifecycle.ViewModel
import lu.gouvernement.monguide72h.models.KitItem
import kotlin.math.ceil

class KitCalculatorViewModel(context: Context? = null) : ViewModel() {
    private val prefs = context?.getSharedPreferences("monguide72h_prefs", Context.MODE_PRIVATE)

    val adults = mutableIntStateOf(prefs?.getInt("calc_adults", 2) ?: 2)
    val children = mutableIntStateOf(prefs?.getInt("calc_children", 1) ?: 1)
    val babies = mutableIntStateOf(prefs?.getInt("calc_babies", 0) ?: 0)
    val pets = mutableIntStateOf(prefs?.getInt("calc_pets", 1) ?: 1)

    val days: Int = 3

    val items = mutableStateListOf<KitItem>()

    init {
        loadDefaultItems()
    }

    val totalPersons: Int
        get() = adults.intValue + children.intValue + babies.intValue

    val totalWaterLitres: Int
        get() = (totalPersons * 3 * days) + (pets.intValue * 1 * days)

    val totalWaterBottles: Int
        get() = ceil(totalWaterLitres / 1.5).toInt()

    val totalMeals: Int
        get() = totalPersons * 3 * days

    val progressPercentage: Float
        get() {
            if (items.isEmpty()) return 0f
            val completed = items.count { it.isChecked }
            return completed.toFloat() / items.size.toFloat()
        }

    fun setAdults(count: Int) {
        adults.intValue = count.coerceAtLeast(1)
        prefs?.edit()?.putInt("calc_adults", adults.intValue)?.apply()
    }

    fun setChildren(count: Int) {
        children.intValue = count.coerceAtLeast(0)
        prefs?.edit()?.putInt("calc_children", children.intValue)?.apply()
    }

    fun setBabies(count: Int) {
        babies.intValue = count.coerceAtLeast(0)
        prefs?.edit()?.putInt("calc_babies", babies.intValue)?.apply()
    }

    fun setPets(count: Int) {
        pets.intValue = count.coerceAtLeast(0)
        prefs?.edit()?.putInt("calc_pets", pets.intValue)?.apply()
    }

    fun toggleItem(id: String) {
        val index = items.indexOfFirst { it.id == id }
        if (index != -1) {
            val item = items[index]
            items[index] = item.copy(isChecked = !item.isChecked)
        }
    }

    private fun loadDefaultItems() {
        items.clear()
        items.addAll(
            listOf(
                KitItem("water", "item_water", "Alimenter"),
                KitItem("food", "item_food", "Alimenter"),
                KitItem("stove", "item_stove", "Alimenter"),
                KitItem("utensils", "item_utensils", "Alimenter"),
                KitItem("warmth", "item_warmth", "Chaleur"),
                KitItem("torch", "item_torch", "Lumière"),
                KitItem("candles", "item_candles", "Lumière"),
                KitItem("firstaid", "item_firstaid", "Santé"),
                KitItem("meds", "item_meds", "Santé"),
                KitItem("iodine", "item_iodine", "Santé"),
                KitItem("hygiene", "item_hygiene", "Santé"),
                KitItem("radio", "item_radio", "Info"),
                KitItem("powerbank", "item_powerbank", "Info"),
                KitItem("cash", "item_cash", "Docs"),
                KitItem("docs", "item_docs", "Docs"),
                KitItem("planpaper", "item_planpaper", "Docs")
            )
        )
    }
}
