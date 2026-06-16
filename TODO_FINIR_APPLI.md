# koko&me — Ce qui reste à faire pour finir l'appli
*Analyse du 17 mai 2026*

---

## 🔴 CRITIQUE — Bloquant pour une vraie utilisation

### 1. Zéro persistance des données
`DeptProgress` est 100% in-memory. Si l'utilisateur ferme l'app, tout est perdu :
XP, leçons complétées, streak.

**Ce qu'il faut faire :**
- Ajouter `shared_preferences` ou `Hive` (base locale)
- Sauvegarder à chaque complétion de leçon / jeu
- Recharger au démarrage de l'app

---

### 2. Scénarios Visual Novel incomplets (5 départements sur 6)
`vn_data.dart` définit des backgrounds pour 6 départements dans l'enum `VnBg`,
mais seul **Management** a ses 9 scènes entièrement rédigées.
Les 5 autres ont les décors définis mais aucun script — la VN crasherait ou serait vide.

**Départements sans script VN :**
- ❌ Human Resources
- ❌ Finance
- ❌ Marketing
- ❌ Tech & IT
- ❌ Legal

**Ce qu'il faut faire :**
- Rédiger ~8-9 scènes `VnScene` par département dans `vn_data.dart`
- Ajouter les images de backgrounds correspondantes dans `assets/images/`

---

### 3. La progression ne se reflète pas sur la carte Jungle
Les `LessonState` dans `department.dart` sont des `const` statiques.
Même si l'utilisateur complète une leçon, les nœuds de la jungle map
ne passent jamais en `done` au runtime.
Le système `DeptProgress` et les nœuds visuels ne sont pas reliés.

**Ce qu'il faut faire :**
- Connecter `DeptProgress.getStars()` à l'affichage des nœuds
- Rendre `allDepartments` mutable ou passer par un state management (Provider / Riverpod)
- Mettre à jour le nœud en `done` après validation d'un jeu

---

### 4. XP et Streak codés en dur
La top bar de la jungle map affiche `620 XP` et `7` en dur dans le code.
Ces valeurs ne viennent d'aucun calcul réel et ne changent jamais.

**Ce qu'il faut faire :**
- Créer un `UserProgress` singleton (ou provider) avec XP total et streak courant
- Incrémenter l'XP à chaque leçon/jeu complété
- Calculer le streak via la date de dernière session (stockée localement)
- Brancher ces valeurs sur la top bar et l'écran profil

---

## 🟠 IMPORTANT — Fonctionnalités incomplètes

### 5. Authentification factice
Google, Facebook, LinkedIn, "Sign up" et "Log in" naviguent tous directement
vers `JungleMapScreen` sans aucune logique réelle.

**Ce qu'il faut faire :**
- Choisir un backend : Firebase Auth (recommandé) ou Supabase
- Implémenter email/password au minimum
- Les OAuth sociaux (Google/Facebook/LinkedIn) nécessitent des app credentials
- Stocker l'utilisateur connecté et son profil

---

### 6. Profil non éditable
Le bouton "Edit Profile" a un `onTap: () {}` vide.
L'engrenage Settings aussi.
Le nom, la photo et les stats sont tous hardcodés (`"Alex Johnson"`, `620`, `7`, `12`).

**Ce qu'il faut faire :**
- Créer un écran d'édition de profil (nom, photo, objectif)
- Créer l'écran Settings (notifications, langue, déconnexion)
- Brancher les stats réelles depuis `UserProgress`

---

### 7. Test Screen uniquement pour Management
`DeptEntryScreen` propose un bouton "Tester" qui lance `ManagementTestScreen`,
mais ce screen est câblé uniquement pour Management.
Les 5 autres départements n'ont pas leur test équivalent.

**Ce qu'il faut faire :**
- Soit généraliser `ManagementTestScreen` pour accepter n'importe quel département
- Soit créer un screen de test générique paramétrable par département

---

### 8. Amis / Leaderboard statiques
La section "Friends" dans le profil est 4 avatars hardcodés (J, M, S, +4).
Aucune logique sociale réelle.

**Ce qu'il faut faire :**
- Connecter à un backend avec liste d'amis
- Afficher un vrai classement (XP, streak)
- Ou simplifier : supprimer la section si le social n'est pas dans le scope

---

## 🟡 POLISH — Partiellement fonctionnel

### 9. Correspondance vocab ↔ leçons cassée par les noms
`lessonVocab` utilise les noms de leçons comme clés (`'Formal Emails'`, etc.).
Si le nom dans `department.dart` ne correspond pas exactement,
le jeu affiche le `fallbackVocab` générique au lieu du vrai contenu.

**Bug connu :** `'Presenting KPIs '` en Finance a un espace en trop → fallback silencieux.

**Ce qu'il faut faire :**
- Passer par un `id` de leçon plutôt que le `name` comme clé du map
- Auditer tous les noms de leçons vs clés de `lessonVocab`

---

### 10. Onboarding déconnecté du flux Auth
`OnboardingScreen._launch()` navigue directement vers `JungleMapScreen`,
court-circuitant `IntroScreen` et `AuthScreen` qui ont été ajoutés après.

**Flux actuel (cassé) :**
```
OnboardingScreen → JungleMapScreen  ← bypass total de l'auth
```

**Flux attendu :**
```
OnboardingScreen → IntroScreen → AuthScreen → JungleMapScreen
```

**Ce qu'il faut faire :**
- Modifier `_launch()` dans `OnboardingScreen` pour naviguer vers `IntroScreen`
- Ou supprimer l'onboarding si l'auth est le vrai point d'entrée

---

### 11. Assets visuels probablement manquants
Les `VnBg` enums (`elevator`, `boardroom`, `mktOpenSpace`...) référencent
des images de fond qui n'existent probablement pas encore dans `assets/images/`.
La VN s'affiche avec un fond vide ou planterait.

**Ce qu'il faut faire :**
- Créer ou sourcer les images de backgrounds par département
- Vérifier que `koko.png` et `jungle_map_bg.png` sont bien présents et de bonne résolution

---

## ⚪ BONUS — Pas encore créé

| Fonctionnalité | Effort estimé |
|---|---|
| Écran Settings (engrenage profil) | Faible |
| Notifications / rappels streak | Moyen |
| Vrai onboarding (choix objectif, niveau) | Moyen |
| Audio / prononciation | Élevé |
| Tests unitaires & widget tests | Élevé |
| Configuration App Store / Play Store | Moyen |
| Icône app + splash screen brandé | Faible |
| Mode hors-ligne complet | Élevé |

---

## Résumé par priorité

```
🔴 CRITIQUE  (faire en premier)
    → Persistence locale (SharedPreferences / Hive)
    → Scripts VN pour les 5 départements manquants
    → Connexion progression runtime ↔ nœuds de la carte
    → XP et streak dynamiques

🟠 IMPORTANT (faire ensuite)
    → Authentification réelle (Firebase Auth recommandé)
    → Profil éditable + écran Settings
    → Test screen généralisé pour tous les départements

🟡 POLISH (avant release)
    → Fix clés vocab (espace en trop Finance)
    → Corriger le flux Onboarding → Intro → Auth
    → Vérifier tous les assets images

⚪ BONUS (post-launch ou scope étendu)
    → Notifications, audio, social, tests, store
```

---

**En l'état :** l'app est une démo navigable très avancée visuellement,
mais sans couche de données persistante ni contenu complet pour les 5 départements non-Management.

