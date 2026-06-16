# koko&me — Rapport d'avancement Flutter
**Synthèse des modifications et fonctionnalités développées**
*17 mai 2026*

---

## 1. Présentation du projet

**koko&me** est une application mobile Flutter d'apprentissage de l'anglais des affaires (Business English). Elle propose un parcours gamifié structuré en **6 départements thématiques**, chacun contenant des leçons, quiz et challenges.

| Département | Thème | Couleur |
|---|---|---|
| Management | Leadership & Strategy | Teal `#52EBE9` |
| Human Resources | Hiring & People Skills | Purple `#8689E8` |
| Finance | Reports & Budgets | Gold `#EBB04B` |
| Marketing | Campaigns & Pitch | Pink `#FF6B9D` |
| Tech & IT | Dev, Agile & Product | Green `#4ECDA0` |
| Legal | Contracts & Compliance | Lavender `#9B8EC4` |

**Stack technique :**
- Framework : Flutter / Dart
- Police : Nunito (Google Fonts)
- Navigation : `PageRouteBuilder` avec transitions personnalisées (Fade, Slide)
- Dessin vectoriel : `CustomPainter`
- Analyse SVG : Python (extraction coordonnées M x y des paths Bézier)

---

## 2. Fichiers créés

### 2.1 `lib/screens/auth_screen.dart` ★ NOUVEAU

Écran d'inscription/connexion entièrement fidèle au design Figma SVG *Inscription*.
Le texte a été décodé depuis les chemins Bézier du SVG (Figma exporte le texte en `<path>`, pas en `<text>`).

**Composants :**
- Titre **"Join koko&me"** en `RichText` bicolore (blanc + teal), 40 px Nunito W900
- Sous-titre "Create your account" en gris `#B6B6B6`
- Champ e-mail — h=55, bg `#3B2063`, ombre intérieure `#190733`, icône envelope
- Bouton **"Sign up"** — dégradé horizontal `#501794 → #3E70A1`, h=50, rx=15
- Séparateur teal 0.5 px pleine largeur
- "or continue with" aligné à gauche (12 px, `#A4A4A4`)
- Bouton **Google** — icône `CustomPainter` 4 couleurs (4 arcs + barre horizontale)
- Bouton **Facebook** — badge circulaire `#1877F2` + « f » blanc
- Bouton **LinkedIn** — badge circulaire `#0A66C2` + « in » blanc
- Footer "By registering you agree to our **Terms and Conditions** and **Privacy Policy**" (liens teal soulignés)
- "Already have an account? **Log in**" avec lien teal
- Toutes les actions naviguent vers `JungleMapScreen`

**Couleurs extraites du SVG :**

| Rôle | Hex |
|---|---|
| Fond général | `#232337` |
| Input background | `#3B2063` |
| Input shadow | `#190733` |
| Gradient start | `#501794` |
| Gradient end | `#3E70A1` |
| Teal | `#52EBE9` |
| Gray texte 1 | `#B6B6B6` |
| Gray texte 2 | `#A4A4A4` |
| Facebook | `#1877F2` |
| LinkedIn | `#0A66C2` |

---

### 2.2 `lib/screens/profile_screen.dart` ★ NOUVEAU

Écran profil utilisateur fidèle au design Figma SVG *Profile* (canvas 393×1442 px).
Les positions et couleurs ont été extraites par analyse Python des coordonnées `M x y` des paths SVG.

**Composants (de haut en bas) :**
- **Top bar** : bouton retour + logo "koko&me" + icône settings (container `#43435C`, rx=13)
- **Avatar** : cercle 180 px, fond `#8689E8` (violet), lettre "A", ombre violette diffuse
- **Nom** : "Alex Johnson" en teal `#52EBE9`, 28 px Nunito W800
- **Sous-titre** : "Business English Learner" en gris `#66667E`
- **Carte stats** (`#43435C`) : 620 XP / 7 Streak / 12 Lessons avec séparateurs verticaux
- **Section Achievements** — 3 badge pills :
  - 🟡 Jaune `#EBB04B` : "Advanced"
  - 🔴 Rouge `#EB4B66` : "B2"
  - 🩵 Teal foncé `#0B5E60` : "Business Pro" (texte teal `#52EBE9`)
- **Graphique "Your Progress"** — `CustomPainter` teal :
  - 7 points de données (Mon–Sun), coordonnées issues des cercles SVG
  - Courbe cubique interpolée avec `cubicTo`
  - Labels des jours en gris en bas du graphique
- **Bouton "Edit Profile"** — dégradé `#501794 → #3E70A1`, h=41, rx=10
- **4 barres de progression** (`ClipRRect` + `FractionallySizedBox`) :
  - Vocabulary — Teal — 82 %
  - Grammar — Jaune — 82 %
  - Speaking — Violet — 82 %
  - Writing — Rouge — 82 %
- **Section Friends** — 4 avatars circulaires (J / M / S / +4)
- Scroll complet avec `BouncingScrollPhysics`

---

## 3. Fichiers modifiés

### 3.1 `lib/models/department.dart`

| Modification | Détail |
|---|---|
| `LessonState.locked → active` | Tous les cours des 6 départements déverrouillés |
| Suppression `imagePath` HR | Remplacé par l'icône déjà définie sur le modèle |
| Management | Conserve 2 leçons en état `done` (Formal Emails, Pro Meetings) |

---

### 3.2 `lib/data/lesson_data.dart`

Suppression de **9 tirets em-dash** `" — "` dans les définitions du vocabulaire, remplacés par une virgule simple :

| Mot | Avant | Après |
|---|---|---|
| AOB | `Any Other Business — last item...` | `Any Other Business, last item...` |
| ROI | `Return On Investment — profit vs cost` | `Return On Investment, profit vs cost` |
| Capex | `Capital Expenditure — long-term spending` | `Capital Expenditure, long-term spending` |
| Opex | `Operational Expenditure — daily costs` | `Operational Expenditure, daily costs` |
| CTA | `Call To Action — prompts...` | `Call To Action, prompts...` |
| PR | `Pull Request — propose...` | `Pull Request, propose...` |
| LGTM | `Looks Good To Me — approval signal` | `Looks Good To Me, approval signal` |
| MVP | `Minimum Viable Product — simplest...` | `Minimum Viable Product, simplest...` |
| NDA | `Non-Disclosure Agreement — keeps info secret` | `Non-Disclosure Agreement, keeps info secret` |

---

### 3.3 `lib/screens/intro_screen.dart`

- Ajout de l'import `auth_screen.dart`
- Bouton "Log in" de la barre de navigation :
  - **Avant** : naviguait directement vers `JungleMapScreen`
  - **Après** : navigue vers `AuthScreen` avec `FadeTransition` (500 ms)
- Correction du lint `unnecessary_underscores` dans `_FeatureCard` — `errorBuilder: (_, __, ___)` → `(ctx2, e2, st2)`

---

### 3.4 `lib/screens/jungle_map_screen.dart`

- Ajout de l'import `profile_screen.dart`
- `_getRole()` : suppression du fallback `NodeRole.secondary` → tous les nœuds s'affichent en `active`
- `_TopBar` : ajout du callback `onProfile` (en plus de `onBack`)
- `CircleAvatar "A"` enveloppé dans un `GestureDetector` → navigue vers `ProfileScreen` avec `SlideTransition` (350 ms, depuis la droite)

---

## 4. Architecture de navigation

```
SplashScreen
    └─▶ OnboardingScreen
            └─▶ IntroScreen
                    ├─ [bouton "Log in"] ──▶ AuthScreen ──▶ JungleMapScreen
                    └─ [bouton "Sign up"] ─▶ AuthScreen ──▶ JungleMapScreen

JungleMapScreen
    ├─ [nœud département] ──▶ DeptEntryScreen
    │                               └─▶ DepartmentScreen
    │                                       └─▶ LessonScreen
    │                                       └─▶ WordMatchScreen
    │                                       └─▶ WordCatcherScreen
    │                                       └─▶ GameQuizScreen
    │                                       └─▶ VisualNovelScreen
    │                                       └─▶ ManagementTestScreen
    │
    └─ [avatar "A"] ──▶ ProfileScreen
```

---

## 5. Résolution de problèmes techniques

### 5.1 Décodage du texte SVG Figma
- **Problème** : Figma exporte le texte sous forme de chemins Bézier (`<path d="M x y ...">`) et non de balises `<text>` lisibles.
- **Solution** : Script Python extrayant toutes les coordonnées `M x y` de chaque `<path>`, groupées par position Y (ligne de texte) puis triées par X (ordre des caractères). La couleur `fill` identifie la sémantique (blanc = titre, teal = lien, gris = sous-titre).

### 5.2 Corrections de lint Flutter
- `unnecessary_underscores` : `(_, __, ___)` → `(ctx2, e2, st2)` dans `auth_screen.dart` et `intro_screen.dart`
- `unused_field` : suppression du champ `_obscure` non utilisé dans la première version de l'écran auth

### 5.3 Correction de couleur SVG
- Le Figma utilisait la couleur LinkedIn `#0A66C2` pour le bouton Facebook → corrigé en `#1877F2` (bleu officiel Facebook)

### 5.4 Alignements fidèles au SVG
- "or continue with" : aligné à **gauche** (x=39 dans le SVG), pas centré
- Boutons sociaux : padding horizontal +10 px (x=58 vs x=39 dans le SVG)
- Divider : hauteur 0.5 px, opacité 0.55 (SVG `stroke-width="0.5"`)
- Graphique profil : 7 data points normalisés depuis les cercles SVG (cx/cy → `Offset` 0–1)

---

## 6. État actuel du projet

| Fonctionnalité | Statut |
|---|---|
| Écran Splash | ✅ |
| Écran Onboarding | ✅ |
| Écran Intro + navigation vers Auth | ✅ |
| Écran Auth / Inscription (fidèle SVG) | ✅ |
| Carte Jungle Map (6 depts déverrouillés) | ✅ |
| Nœuds de département actifs (plus de grisé) | ✅ |
| Écran d'entrée Département | ✅ |
| Écran Département + liste leçons | ✅ |
| Écran Leçon | ✅ |
| Jeu WordMatch | ✅ |
| Jeu WordCatcher | ✅ |
| Jeu GameQuiz | ✅ |
| Jeu VisualNovel | ✅ |
| Management Test Screen | ✅ |
| Écran Profil utilisateur (fidèle SVG) | ✅ |
| Navigation avatar A → ProfileScreen | ✅ |

**`flutter analyze` : 0 erreur, 0 warning** ✅

---
