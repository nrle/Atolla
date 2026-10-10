# Spécification fonctionnelle

Comportement à construire, écrit en nos propres mots à partir de la fiche publique de l'app de référence
(fiche App Store, site de l'éditeur, notes de version, fichier de configuration public de la version Mac)
et de l'usage de l'app. Aucun code ni visuel n'en a été repris.

La colonne « Dans AmpFin » vient du README public d'AmpFin. « Non mentionné » veut dire à vérifier dans le code.

## Parité : ce que fait l'app de référence

| Fonction | Détail | Dans AmpFin |
| --- | --- | --- |
| Connexion Jellyfin | URL, choix http / https, identifiants, Quick Connect ; jeton stocké de façon sécurisée ; serveurs anciens (avant 10.8) et récents (10.12 et plus) ; en-tête Authorization attendu par les versions récentes | À vérifier |
| Bibliothèque | Artistes, albums, titres, genres, playlists, favoris ; tri et filtres | Oui (albums, artistes, playlists, mixes d'artistes) |
| Recherche | Globale, et dans « Ajouter à une playlist » | Oui |
| Lecteur | File de lecture, aléatoire, répétition, arrière-plan, contrôles sur l'écran verrouillé, ne coupe pas les autres audios au lancement | Oui (file personnalisée, historique) |
| Normalisation du gain | Niveau sonore homogène entre les titres | Non mentionné |
| Hors ligne | Téléchargement de titres, albums, playlists ; cache des pochettes ; gestion du stockage ; synchronisation des grandes playlists | Oui (albums, playlists, sync auto) |
| Suivi d'écoute | Début, progression et fin envoyés à Jellyfin, compatible avec le plugin last.fm | Oui |
| Classique | Pistes d'un album regroupées par mouvements, désactivable dans les réglages | Non mentionné |
| Paroles | Paroles synchronisées | Oui (Jellyfin 10.9 et plus) |
| Thèmes | Clair, sombre, système | À vérifier |
| Siri | Lire un artiste, une playlist, un album, un titre ; ajouter à une playlist ; aimer ou ne pas aimer un titre | Oui, en partie |
| Raccourcis | Actions de lecture utilisables dans des automatisations | À vérifier |
| CarPlay | Interface dédiée dans une scène CarPlay | Non mentionné |
| Glisser-déposer et partage | Titres et albums | À vérifier |
| Lien profond | Schéma d'URL propre à l'app, utilisable dans Raccourcis | À vérifier |
| Synchronisation en arrière-plan | La bibliothèque se met à jour en tâche de fond | À vérifier |
| Lecture longue durée | Politique de route audio compatible AirPlay 2 | À vérifier |
| Serveurs locaux en http | Autorisés | À vérifier |

## Options de l'abonnement de l'app de référence, offertes ici gratuitement

| Option | Comportement attendu |
| --- | --- |
| Icônes alternatives | Au moins deux icônes au choix, avec nos propres visuels |
| Bibliothèques activables | Choisir quelles bibliothèques musicales Jellyfin alimentent l'accueil, la recherche et la lecture aléatoire |
| Égaliseur 6 bandes | Réglages manuels et préréglages ; l'approche pour un flux en streaming est à expliquer avant de coder |
| Titres ignorés | Marquer un titre pour qu'il soit sauté automatiquement à la lecture |
| Noms d'hôte alternatifs | Plusieurs adresses du serveur (local, domaine, VPN) avec choix automatique de celle qui répond |

## Au-delà de la parité (après la phase 5)

Lecture sans blanc et fondu enchaîné réglable · plusieurs serveurs et comptes · qualité adaptative
selon le réseau · mixes intelligents · scrobbling direct vers last.fm et ListenBrainz · statistiques
d'écoute · AirPlay et Chromecast · minuteur de sommeil · widgets et Apple Watch · Android et desktop.

## Design

L'app de référence est jugée plus agréable qu'AmpFin parce qu'elle reprend les graphismes et les
animations d'Apple Music. C'est la priorité du projet.

Comportement attendu, à reproduire avec des composants natifs SwiftUI et des SF Symbols, sans aucun
visuel, nom ou logo d'Apple ni de l'app de référence :

- Onglets et navigation natifs, recherche intégrée, grands titres.
- Mini-lecteur au-dessus de la barre d'onglets, qui s'ouvre en écran de lecture plein écran par une
  transition fluide.
- Écran de lecture : grande pochette, fond animé aux couleurs de la pochette, commandes en matières système.
- Vue paroles synchronisées avec la ligne courante mise en avant.
- Listes, albums et artistes avec pochettes, menus contextuels et gestes de balayage.
- Animations de ressort, retours haptiques, mode sombre.

## Limites de la version installée par SideStore

Pas d'extension d'app (donc pas de Siri) et pas de CarPlay. Ces deux fonctions du tableau « Parité »
sont livrées en phase 5, avec un compte développeur Apple payant.
