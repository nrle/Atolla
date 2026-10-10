# Atolla — client Jellyfin pour la musique, sur iOS

Ce fichier est lu par l'agent de code au début de chaque session. Il contient les règles du projet.
Le détail des fonctions à construire est dans `SPEC.md`.

## Objectif

App iOS native (Swift, SwiftUI), gratuite et open source, qui streame une bibliothèque musicale Jellyfin.
Elle doit égaler le comportement de l'app commerciale Manet, offrir gratuitement ce que Manet réserve à son
abonnement, puis aller plus loin. Le projet est un fork d'AmpFin (dépôt archivé, Swift/SwiftUI/SwiftData).

## Règles légales (non négociables)

- Ne copie aucun code, aucune image, aucune icône et aucun texte de Manet. Ne décompile aucune app.
  Le comportement attendu est décrit dans `SPEC.md`, et uniquement là.
- N'utilise aucun visuel, logo ou nom d'Apple ou de Manet. SwiftUI et les SF Symbols sont autorisés.
- Code hérité d'AmpFin : garde le fichier `LICENSE` (MPL 2.0 avec la clause Commons), les en-têtes de
  fichiers et les mentions d'origine. Les nouveaux fichiers portent l'en-tête MPL 2.0.
- La clause Commons interdit de vendre l'app : aucun achat intégré, aucun paiement, aucune publicité.
- Le nom, l'icône et l'identité visuelle de l'app sont les nôtres. Pas de nom contenant « Manet » ou « AmpFin ».
- Parle uniquement à l'API officielle de Jellyfin.

## Stack

Swift, SwiftUI, SwiftData, AVFoundation, extension Siri existante. Cible : iOS 18 ou plus récent.
Respecte l'architecture du dépôt (dossiers `AmpFinKit`, `Multiplatform`, `Siri Extension`, d'après sa
structure publique) : ne la réécris pas et ne déplace pas de fichiers sans raison. Confirme en phase 1
où se trouvent l'API, le lecteur, les téléchargements et l'interface, et note-le dans ce fichier.

## Méthode de travail

1. Travaille une phase à la fois, dans l'ordre de la roadmap ci-dessous.
2. Avant de coder une fonction, lis le code existant concerné et dis si elle existe, est partielle ou manque.
3. Une fonction par commit, avec des commits petits. Messages de commit et commentaires de code en anglais.
4. Après chaque changement, compile avec `xcodebuild` et lance les tests s'il y en a. Ne dis jamais
   qu'une fonction est terminée si le projet ne compile pas.
5. Termine chaque réponse par « À tester sur l'iPhone » : trois à cinq actions précises.
6. N'écris jamais d'URL de serveur, d'identifiant ni de jeton dans le code ou dans git.
7. Si le comportement attendu n'est pas dans `SPEC.md`, pose la question au lieu de deviner.
8. Textes de l'interface en français et en anglais (fichiers de localisation).

## Roadmap et portes de validation

| Phase | Contenu | Porte |
| --- | --- | --- |
| 1 | Fork, compilation, renommage, installation sur iPhone | L'app tourne sur l'iPhone et se connecte au serveur |
| 2 | Mise à niveau Jellyfin : connexion, lecture, rapports d'écoute | Jellyfin enregistre l'écoute |
| 3 | Parité avec Manet (tableau « Parité » de `SPEC.md`) | MVP : parité de base |
| 4 | Options Manet+ offertes | Chaque option validée sur le serveur de test |
| 5 | CarPlay, Siri complet, glisser-déposer | Siri et CarPlay pilotent la lecture |
| 6 | Release : README, licence, remerciements, TestFlight | Un tiers installe l'app et s'y connecte |

## Commandes utiles

```bash
xcodebuild -list                                   # trouver le projet et les schémas
xcodebuild -project AmpFin.xcodeproj -scheme <schéma> -destination 'generic/platform=iOS Simulator' build
xcodebuild test -project AmpFin.xcodeproj -scheme <schéma> -destination 'generic/platform=iOS Simulator'
```

Adapte le nom du projet et du schéma après le renommage de la phase 1.
