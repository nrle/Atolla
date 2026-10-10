# Atolla — client Jellyfin pour la musique, sur iOS

Ce fichier est lu par l'agent de code au début de chaque session. Il contient les règles du projet.
Le détail des fonctions à construire est dans `SPEC.md`.

## Objectif

App iOS native (Swift, SwiftUI), gratuite et open source, qui streame une bibliothèque musicale Jellyfin.
Elle doit égaler le comportement de l'app commerciale Manet, offrir gratuitement ce que Manet réserve à son
abonnement, puis aller plus loin. Le projet est un fork d'AmpFin (dépôt archivé, Swift/SwiftUI/SwiftData).

**Priorité n°1 : le design.** Manet est jugé plus agréable qu'AmpFin parce qu'il reprend les graphismes et
les animations d'Apple Music. Atolla doit donner la même impression à l'usage.

## Règles légales (non négociables)

- Ne copie aucun code, aucune image, aucune icône et aucun texte de Manet. Ne décompile aucune app.
  Le comportement attendu est décrit dans `SPEC.md`, et uniquement là.
- N'utilise aucun visuel, logo ou nom d'Apple ou de Manet. SwiftUI et les SF Symbols sont autorisés.
- Code hérité d'AmpFin : garde le fichier `LICENSE` (MPL 2.0 avec la clause Commons), les en-têtes de
  fichiers et les mentions d'origine. Les nouveaux fichiers portent l'en-tête MPL 2.0.
- La clause Commons interdit de vendre l'app : aucun achat intégré, aucun paiement, aucune publicité.
- Le README d'AmpFin indique que la diffusion de builds compilés soi-même n'est pas autorisée par sa
  licence. Ne publie donc aucun IPA, aucune release et aucune build TestFlight tant que le propriétaire
  du projet n'a pas clarifié ce point avec l'auteur d'AmpFin. L'IPA produit par le workflow est pour
  un usage personnel.
- Le nom, l'icône et l'identité visuelle de l'app sont les nôtres. Pas de nom contenant « Manet » ou « AmpFin ».
- Parle uniquement à l'API officielle de Jellyfin.

## Environnement : pas de Xcode en local

Le Mac du propriétaire est trop ancien pour Xcode. La compilation se fait donc dans le cloud.

- Le workflow `.github/workflows/build.yml` compile l'app sur un Mac distant (GitHub Actions) et publie
  un IPA non signé. Le propriétaire l'installe avec SideStore et teste sur son iPhone.
- Boucle de travail : modifie le code, commit, push, puis attends le résultat du workflow. Si `gh` est
  installé : `gh run watch`, puis `gh run view --log-failed` en cas d'échec. Sinon, demande au
  propriétaire de coller les logs. Corrige jusqu'à ce que le workflow réussisse.
- Ne dis jamais qu'une fonction est terminée tant que le workflow n'est pas vert.
- Il n'y a ni simulateur ni aperçu SwiftUI. Écris du code simple, relis-le avant de pousser (imports,
  types, `#available`) et avance par petites étapes.
- SideStore ne gère pas les extensions d'app ni CarPlay. Le workflow retire donc les extensions
  (dossier `PlugIns`) et la fonction « Siri » ne marche pas dans cette version. Ne travaille pas sur
  Siri, CarPlay ni TestFlight avant la phase 5.

## Stack

Swift, SwiftUI, SwiftData, AVFoundation. Cible : iOS 18 ou plus récent ; utilise les API plus récentes
avec `#available` et un repli pour iOS 18. Garde `AmpFinKit` (logique, API, lecteur). La couche
d'interface (dossier `Multiplatform`) peut être refaite écran par écran. Ne déplace pas de fichiers
sans raison. Confirme en phase 1 où se trouvent l'API, le lecteur, les téléchargements et l'interface,
et note-le dans ce fichier.

### Architecture vérifiée (phase 1)

- API Jellyfin et session : `AmpFinKit/Sources/AFNetwork`.
- Lecture, file et rapports d'écoute : `AmpFinKit/Sources/AFPlayback`.
- Téléchargements et bibliothèque hors ligne : `AmpFinKit/Sources/AFOffline`.
- Interface SwiftUI iPhone/iPad : `Multiplatform`.
- L'extension Siri est présente dans `Siri Extension`, mais retirée de l'IPA SideStore.

## Design façon Apple Music

Ce que ressent l'utilisateur vient surtout de composants natifs bien utilisés, pas d'images :

- Navigation native : barre d'onglets système, `NavigationStack`, recherche intégrée, grands titres.
- Mini-lecteur au-dessus de la barre d'onglets, qui s'ouvre en écran de lecture plein écran avec une
  transition fluide (transition zoom, `matchedTransitionSource` et `navigationTransition`).
- Écran de lecture : grande pochette qui réagit à la lecture (elle rétrécit en pause), fond dégradé
  animé tiré des couleurs de la pochette (`MeshGradient`), commandes dans des matières système.
- Sheets avec détents (`presentationDetents`), animations de ressort, retours haptiques
  (`sensoryFeedback`), SF Symbols animés (`symbolEffect`).
- Paroles synchronisées plein écran, ligne courante mise en avant, défilement doux.
- Sous iOS 26 : effets « Liquid Glass » (`glassEffect`) et accessoire de barre d'onglets pour le
  mini-lecteur ; vérifie la disponibilité des API dans la documentation d'Apple et prévois un repli iOS 18.
- Mode sombre, Dynamic Type, accessibilité VoiceOver.

## Méthode de travail

1. Travaille une phase à la fois, dans l'ordre de la roadmap ci-dessous.
2. Avant de coder une fonction, lis le code existant concerné et dis si elle existe, est partielle ou manque.
3. Une fonction ou un écran par commit, avec des commits petits. Messages de commit et commentaires de code en anglais.
4. Termine chaque réponse par « À tester sur l'iPhone » : trois à cinq actions précises.
5. N'écris jamais d'URL de serveur, d'identifiant ni de jeton dans le code ou dans git.
6. Si le comportement attendu n'est pas dans `SPEC.md`, pose la question au lieu de deviner.
7. Textes de l'interface en français et en anglais (fichiers de localisation).

## Roadmap et portes de validation

| Phase | Contenu | Porte |
| --- | --- | --- |
| 1 | Fork, workflow de compilation cloud, renommage, installation par SideStore | L'app tourne sur l'iPhone et se connecte au serveur |
| 2 | Mise à niveau Jellyfin : connexion, lecture, rapports d'écoute | Jellyfin enregistre l'écoute |
| 3 | Design façon Apple Music, puis parité avec Manet (tableau « Parité » de `SPEC.md`) | MVP : à l'usage, aussi agréable que Manet |
| 4 | Options Manet+ offertes | Chaque option validée sur le serveur de test |
| 5 | CarPlay, Siri, Raccourcis, glisser-déposer (compte développeur payant) | Siri et CarPlay pilotent la lecture |
| 6 | Publication du code : README, licence, remerciements | Un tiers peut construire l'app depuis le dépôt |

## Commandes utiles

```bash
gh workflow run build.yml        # lancer la compilation
gh run watch                     # suivre le résultat
gh run view --log-failed         # lire les erreurs
gh run download -n Atolla-ipa    # récupérer l'IPA
```
