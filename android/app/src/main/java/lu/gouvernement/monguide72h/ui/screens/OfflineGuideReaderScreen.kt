package lu.gouvernement.monguide72h.ui.screens

import android.content.Intent
import android.net.Uri
import androidx.compose.animation.AnimatedVisibility
import androidx.compose.foundation.background
import androidx.compose.foundation.clickable
import androidx.compose.foundation.layout.*
import androidx.compose.foundation.lazy.LazyColumn
import androidx.compose.foundation.lazy.items
import androidx.compose.foundation.shape.RoundedCornerShape
import androidx.compose.material.icons.Icons
import androidx.compose.material.icons.filled.*
import androidx.compose.material3.*
import androidx.compose.runtime.*
import androidx.compose.ui.Alignment
import androidx.compose.ui.Modifier
import androidx.compose.ui.draw.clip
import androidx.compose.ui.graphics.Color
import androidx.compose.ui.platform.LocalContext
import androidx.compose.ui.text.font.FontWeight
import androidx.compose.ui.unit.dp
import androidx.compose.ui.unit.sp
import lu.gouvernement.monguide72h.localization.LocalizationManager
import lu.gouvernement.monguide72h.models.OfflineGuideRepository
import lu.gouvernement.monguide72h.models.OfficialGuideChapter
import lu.gouvernement.monguide72h.models.OfficialGuideSection
import lu.gouvernement.monguide72h.ui.theme.*

@Composable
fun OfflineGuideReaderScreen(onBack: () -> Unit) {
    val currentLang by LocalizationManager.currentLanguage
    val chapters = remember(currentLang) {
        OfflineGuideRepository.getChapters(currentLang)
    }

    LazyColumn(
        modifier = Modifier
            .fillMaxSize()
            .background(DarkBackground)
            .padding(horizontal = 16.dp),
        verticalArrangement = Arrangement.spacedBy(16.dp),
        contentPadding = PaddingValues(vertical = 16.dp)
    ) {
        // Back Header
        item {
            Row(
                verticalAlignment = Alignment.CenterVertically,
                modifier = Modifier.fillMaxWidth()
            ) {
                IconButton(onClick = onBack) {
                    Icon(Icons.Default.ArrowBack, contentDescription = "Back", tint = Color.White)
                }
                Spacer(modifier = Modifier.width(8.dp))
                Column {
                    Text(
                        text = LocalizationManager.tr("offline_guide_title"),
                        fontSize = 18.sp,
                        fontWeight = FontWeight.Bold,
                        color = Color.White
                    )
                    Text(
                        text = LocalizationManager.tr("offline_ready_sub"),
                        fontSize = 11.sp,
                        color = LuxLightBlue
                    )
                }
            }
        }

        items(chapters, key = { it.id }) { chapter ->
            ChapterAccordionCard(chapter = chapter)
        }
    }
}

@Composable
fun ChapterAccordionCard(chapter: OfficialGuideChapter) {
    var isExpanded by remember { mutableStateOf(chapter.id == 1) }

    Card(
        colors = CardDefaults.cardColors(containerColor = DarkSurface),
        shape = RoundedCornerShape(12.dp)
    ) {
        Column(modifier = Modifier.padding(16.dp)) {
            Row(
                modifier = Modifier
                    .fillMaxWidth()
                    .clickable { isExpanded = !isExpanded },
                horizontalArrangement = Arrangement.SpaceBetween,
                verticalAlignment = Alignment.CenterVertically
            ) {
                Column(modifier = Modifier.weight(1f)) {
                    Text(
                        text = chapter.titleKey,
                        fontSize = 16.sp,
                        fontWeight = FontWeight.Bold,
                        color = Color.White
                    )
                    Spacer(modifier = Modifier.height(2.dp))
                    Text(
                        text = chapter.subtitleKey,
                        fontSize = 12.sp,
                        color = TextSecondary
                    )
                }

                Icon(
                    imageVector = if (isExpanded) Icons.Default.ExpandLess else Icons.Default.ExpandMore,
                    contentDescription = null,
                    tint = LuxLightBlue
                )
            }

            AnimatedVisibility(visible = isExpanded) {
                Column(
                    modifier = Modifier.padding(top = 16.dp),
                    verticalArrangement = Arrangement.spacedBy(14.dp)
                ) {
                    chapter.sections.forEach { section ->
                        SectionContent(section = section)
                    }
                }
            }
        }
    }
}

@Composable
fun SectionContent(section: OfficialGuideSection) {
    val context = LocalContext.current

    Column(
        modifier = Modifier
            .fillMaxWidth()
            .clip(RoundedCornerShape(8.dp))
            .background(DarkCard)
            .padding(14.dp)
    ) {
        Text(
            text = section.titleKey,
            fontSize = 14.sp,
            fontWeight = FontWeight.Bold,
            color = Color.White
        )

        section.subtitleKey?.let {
            Text(
                text = it,
                fontSize = 12.sp,
                color = LuxLightBlue,
                modifier = Modifier.padding(top = 2.dp, bottom = 8.dp)
            )
        }

        section.paragraphs.forEach { para ->
            Text(
                text = para,
                fontSize = 13.sp,
                color = TextPrimary,
                lineHeight = 18.sp,
                modifier = Modifier.padding(vertical = 4.dp)
            )
        }

        if (section.bulletPoints.isNotEmpty()) {
            Spacer(modifier = Modifier.height(4.dp))
            section.bulletPoints.forEach { point ->
                Row(modifier = Modifier.padding(vertical = 2.dp)) {
                    Text(text = "•", color = LuxLightBlue, fontWeight = FontWeight.Bold, modifier = Modifier.padding(end = 6.dp))
                    Text(text = point, color = TextPrimary, fontSize = 12.sp, lineHeight = 17.sp)
                }
            }
        }

        section.alertNotice?.let { notice ->
            Spacer(modifier = Modifier.height(8.dp))
            Surface(
                color = Color(0xFF451A1A),
                shape = RoundedCornerShape(6.dp)
            ) {
                Text(
                    text = notice,
                    color = Color(0xFFFCA5A5),
                    fontSize = 11.sp,
                    fontWeight = FontWeight.SemiBold,
                    modifier = Modifier.padding(8.dp)
                )
            }
        }

        section.referenceWebsite?.let { url ->
            Spacer(modifier = Modifier.height(8.dp))
            Text(
                text = "🌐 $url",
                color = LuxLightBlue,
                fontSize = 11.sp,
                fontWeight = FontWeight.Bold,
                modifier = Modifier.clickable {
                    val fullUrl = if (url.startsWith("http")) url else "https://$url"
                    val intent = Intent(Intent.ACTION_VIEW, Uri.parse(fullUrl))
                    context.startActivity(intent)
                }
            )
        }
    }
}
