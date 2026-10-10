# Manet open source — descriptif et roadmap

Oct 8, 2026 · @Léo Vernier

Nom provisoire du projet : Atolla, d'après la méduse Atolla wyvillei. Ce document décrit ce que fait Manet (client Jellyfin pour iOS) et donne un plan pour construire un client open source équivalent, puis supérieur, en Swift avec Xcode.

## Cadre et choix de départ

- **Objectif** : un lecteur de musique Jellyfin open source, natif iOS, qui reprend tout ce que fait Manet et ajoute ce qui lui manque.
- **« Reverse engineering » ici** : on reproduit le *comportement* observable de l'app (écrans, fonctions, flux) et on s'appuie sur l'API Jellyfin, qui est publique et documentée. Pas besoin de décompiler Manet.
- **À ne pas copier** :  le nom et le logo de Manet (éditeur : Tilo Software AB). Donne à ton app son propre nom et sa propre identité visuelle.
- **Stack recommandée pour Replit** : aucune. Replit ne compile pas d'app iOS native. La stack retenue est Swift et SwiftUI. Xcode n'étant pas disponible sur ton Mac, le code s'écrit dans VS Code avec Codex, GitHub Actions compile l'app dans le cloud et SideStore l'installe sur ton iPhone.
- **Limites à connaître** : CarPlay demande une autorisation d'Apple, non garantie ; l'égaliseur sur un flux en streaming demande un traitement audio sur mesure ; AmpFin n'est plus maintenu, donc la première phase sert à le remettre d'aplomb sur un Jellyfin récent. Installée par SideStore, l'app n'a ni Siri ni CarPlay : ils attendent un compte développeur payant. Le README d'AmpFin indique aussi que la diffusion de builds compilés soi-même n'est pas autorisée par sa licence : l'IPA reste pour ton usage personnel, et il faut clarifier ce point avec son auteur avant toute publication.
- **Avant de repartir de zéro** : on part d'un fork d'AmpFin (Swift, SwiftUI, SwiftData). Il a déjà le hors ligne, les paroles synchronisées, Siri, les playlists, la file de lecture et les rapports d'écoute. Sa licence est la MPL 2.0 avec la clause « Commons » : le code hérité reste sous cette licence et l'app ne peut pas être vendue, ce qui convient à une app gratuite. Références de comportement : Swiftly Music (MPL 2.0, natif, mais jeune : un seul commit) et Finamp.

## Descriptif de Manet

Manet est un lecteur de musique natif iOS (et macOS) qui streame une bibliothèque Jellyfin, gratuit avec un abonnement optionnel Manet+. Les informations ci-dessous viennent de la fiche App Store et de ses notes de version ; les écrans exacts sont à compléter avec ton usage de l'app.

**Note sur l'interface** : Manet reproduit presque à la perfection l'interface d'Apple Music. C'est un point central du projet : l'app doit donner la même impression de lecteur natif iOS. On reprend les principes (mini-lecteur, écran de lecture plein écran, vue paroles, navigation par onglets), pas le nom, le logo ni les ressources graphiques d'Apple.

Après test d'AmpFin, les deux apps se ressemblent beaucoup fonctionnellement, mais Manet est plus agréable à utiliser grâce à ses graphismes et ses animations façon Apple Music. Le design est donc la priorité de la phase 3 : il vient surtout de composants SwiftUI natifs bien utilisés, pas d'images.

| Domaine | Ce que fait Manet |
| --- | --- |
| Connexion | Se connecte à un serveur Jellyfin avec un compte ; sélecteur de protocole (http/https) à la connexion ; compatible avec les serveurs anciens (avant 10.8) et récents (10.12+) |
| Lecture | Streaming de pistes, albums, artistes et playlists ; file de lecture ; lecture en arrière-plan ; ne coupe pas les autres audios au lancement ; normalisation du gain et paroles intégrées |
| Hors ligne | Téléchargement de musique pour écoute sans réseau ; cache des pochettes pour l'affichage hors ligne |
| Playlists | Synchronisation des playlists, y compris les grandes ; ajout d'un titre à une playlist avec barre de recherche |
| Musique classique | Regroupement des pistes d'un album par mouvements, désactivable dans les réglages |
| Siri | Commandes vocales pour jouer un artiste, une playlist, un album ou un titre |
| CarPlay | Interface dédiée pour contrôler la lecture en voiture |
| Raccourcis | Actions Shortcuts pour lancer la lecture dans des automatisations |
| Suivi d'écoute | Rapport de lecture envoyé à Jellyfin, utilisé par l'intégration last.fm |
| Apparence | Thème clair, sombre ou système ; design natif iOS (adapté à Liquid Glass) |
| Manet+ (payant) | Deux icônes d'app alternatives ; activation ou désactivation de bibliothèques musicales (ex. une bibliothèque de Noël) ; égaliseur 6 bandes ; titres ignorés, sautés automatiquement en lecture ; nom d'hôte alternatif avec bascule via Raccourcis (cité dans d'anciennes notes de version) ; soutien au développeur |

### Ce que révèle l'Info.plist de la version Mac (1.0.12)

Le fichier de configuration public de l'app (Info.plist, lu dans le DMG fourni) confirme et complète le descriptif. Aucun code ni visuel n'a été extrait.

| Élément | Ce que ça indique pour la spec |
| --- | --- |
| macOS 15 minimum, build 1704, compilé avec Xcode 26.3 | App SwiftUI/UIKit récente, une même base pour iPhone, iPad et Mac |
| Intents Siri : lire un média, ajouter un média, mettre à jour l'affinité (j'aime / je n'aime pas), catégorie musique | Siri sert aussi à ajouter à une playlist et à aimer un titre, pas seulement à lancer la lecture |
| Scène CarPlay dédiée (CPTemplateApplicationScene) | Interface CarPlay à part, chargée dans une scène propre |
| Tâche d'arrière-plan « SyncLibrary » | Synchronisation de la bibliothèque en tâche de fond |
| Politique de route audio « LongFormAudio » | Lecture longue durée compatible AirPlay 2 |
| Types exportés « TrackId » et « AlbumId » | Glisser-déposer et partage de titres et d'albums |
| Schéma d'URL manet:// | Liens profonds vers l'app, utiles pour Raccourcis |
| Connexions HTTP non sécurisées autorisées | Prise en charge des serveurs Jellyfin locaux en http |
| Plusieurs scènes ; iPhone en portrait, iPad dans toutes les orientations | Fenêtres multiples sur iPad et Mac ; pas de mode paysage sur iPhone |

### Points à compléter toi-même

Ouvre Manet et note, pour chaque onglet, la liste des écrans, les gestes (balayage, appui long), l'écran lecture en cours et les réglages. Colle ces notes dans Replit : elles valent plus que n'importe quelle description externe, car elles couvrent l'ergonomie que je ne peux pas voir d'ici.

## Spécification de la version open source

Le produit vise d'abord la parité avec Manet, puis des fonctions que Manet n'annonce pas. Le niveau « Parité » forme le MVP ; « Au-delà » est ce qui rend l'app plus puissante.

| Fonction | Niveau | Détail |
| --- | --- | --- |
| Connexion Jellyfin | Parité | URL, protocole, identifiants, Quick Connect ; stockage sécurisé du jeton |
| Bibliothèque | Parité | Artistes, albums, titres, genres, playlists, favoris ; tri et filtres |
| Recherche | Parité | Recherche globale et dans « Ajouter à une playlist » |
| Lecteur | Parité | File de lecture, aléatoire, répétition, lecture en arrière-plan, contrôles écran verrouillé, normalisation du gain |
| Mode hors ligne | Parité | Téléchargement de titres, albums, playlists ; cache des pochettes ; gestion du stockage |
| Suivi d'écoute | Parité | Rapport de lecture à Jellyfin (début, progression, fin) |
| Classique | Parité | Regroupement par mouvements, désactivable |
| Thèmes | Parité | Clair, sombre, système |
| Siri, Raccourcis, CarPlay | Parité | Plus tard : demandent du code natif et l'accord d'Apple |
| Lecture sans blanc | Au-delà | Gapless et fondu enchaîné réglable |
| Égaliseur | Parité | Égaliseur 6 bandes comme Manet+, avec préréglages ; gratuit ici |
| Paroles | Parité | Paroles synchronisées lues depuis Jellyfin quand elles existent |
| Multi-serveurs | Au-delà | Plusieurs serveurs et comptes, bascule auto réseau local / distant (gratuite, pas réservée à un abonnement) |
| Qualité adaptative | Au-delà | Transcodage choisi selon Wi-Fi ou mobile, plafond de débit |
| Mixes intelligents | Au-delà | Mix instantané à partir d'un titre, d'un artiste ou d'un album |
| Scrobbling direct | Au-delà | last.fm et ListenBrainz sans passer par un plugin serveur |
| Statistiques | Au-delà | Titres et artistes les plus écoutés, historique |
| Diffusion | Au-delà | AirPlay et Chromecast |
| Minuteur de sommeil | Au-delà | Arrêt après X minutes ou à la fin de l'album |
| Widgets et Apple Watch | Au-delà | Lecture en cours sur l'écran d'accueil et au poignet |
| Plateformes | Au-delà | Android (Android Auto) et desktop après iOS |

### Options de Manet+ à offrir gratuitement

Tout ce que Manet réserve à Manet+ est inclus dans la version open source :

- **Icônes alternatives** : au moins deux icônes au choix, avec nos propres visuels.
- **Bibliothèques activables** : choisir quelles bibliothèques musicales Jellyfin alimentent l'accueil, la recherche et la lecture aléatoire.
- **Égaliseur 6 bandes** : réglages manuels et préréglages.
- **Titres ignorés** : marquer un titre pour qu'il soit sauté automatiquement en lecture.
- **Noms d'hôte alternatifs** : plusieurs adresses du serveur (local, domaine, VPN), avec choix automatique de celle qui répond.

Ajouts issus de l'Info.plist, à intégrer aussi :

- **Siri complet** : lire, ajouter à une playlist, aimer ou ne pas aimer un titre.
- **Synchronisation en arrière-plan** de la bibliothèque.
- **Glisser-déposer et partage** de titres et d'albums.
- **Lien profond** (schéma d'URL propre à ton app) pour Raccourcis.

## Architecture technique

&#91;embedded content: architecture · serveur Jellyfin et app mobile\]

L'app interroge l'API Jellyfin pour parcourir la bibliothèque, lit le flux audio en direct, et télécharge des fichiers pour le hors ligne. Endpoints à faire utiliser par Replit (à vérifier dans la doc OpenAPI de ton serveur) :

- Connexion : `/Users/AuthenticateByName`, `/QuickConnect`
- Bibliothèque : `/Items` (filtrer sur les types musicaux), `/Items/{id}/Images/Primary`
- Lecture : `/Audio/{id}/universal`
- Suivi d'écoute : `/Sessions/Playing`, `/Sessions/Playing/Progress`, `/Sessions/Playing/Stopped`
- Bonus : `/Items/{id}/InstantMix`, `/Audio/{id}/Lyrics`

## Roadmap

&#91;embedded content: roadmap · 6 phases, 6 portes de validation\]

Ne passe à la phase suivante qu'une fois la porte franchie, testée sur ton iPhone. Les phases 1 à 3 donnent un MVP utilisable ; la phase 5 (Siri, CarPlay) attend un compte développeur payant.

## Prompts à donner à l'agent de code

Ces prompts se donnent un par un, dans l'ordre, à Codex lancé dans le dossier du projet. Le fichier AGENTS.md du kit contient déjà les règles du projet : Codex le lit seul. Valide chaque phase sur ton iPhone avant la suivante.

### Phase 1 : fork et compilation cloud

```text
Lis AGENTS.md et SPEC.md. Le workflow .github/workflows/build.yml doit produire un IPA non signé de l'app. Lance-le, lis les logs, corrige le nom du schéma et les erreurs jusqu'à ce qu'il réussisse. Renomme ensuite l'app en Atolla (nom affiché, préfixe de bundle identifier, icône provisoire) en gardant la licence et les mentions d'origine. Dis-moi comment installer l'IPA avec SideStore et quoi tester.
```

### Phase 2 : mise à niveau Jellyfin

```text
Teste la connexion à mon serveur Jellyfin. Vérifie l'authentification (en-tête Authorization des versions 10.12 et plus récentes), le choix http / https, la lecture, les pochettes et les rapports d'écoute. Corrige tout ce qui casse, ajoute des tests pour la couche API et résume ce qui a changé.
```

### Phase 3 : design façon Apple Music, puis parité

```text
Priorité au design. Garde AmpFinKit (logique, API, lecteur) et refais la couche d'interface écran par écran, en suivant la section « Design » d'AGENTS.md : d'abord la navigation et le mini-lecteur, puis l'écran de lecture plein écran avec un fond animé tiré de la pochette, puis les listes, la recherche et les paroles. Un écran par commit, et le workflow doit rester vert. Ensuite, compare l'app au tableau « Parité » de SPEC.md et implémente les lignes manquantes : classique par mouvements, normalisation du gain, thèmes, recherche dans « Ajouter à une playlist », lien profond.
```

### Phase 4 : options Manet+ offertes

```text
Implémente les options de la section « Options de l'abonnement de l'app de référence, offertes ici gratuitement » de SPEC.md : bibliothèques activables, titres ignorés (sautés à la lecture), deux icônes alternatives, noms d'hôte alternatifs avec choix automatique, puis l'égaliseur 6 bandes. Pour l'égaliseur, explique d'abord l'approche choisie pour un flux en streaming, puis code. Un commit par fonction.
```

### Phase 5 : CarPlay, Siri, Raccourcis (compte développeur payant)

```text
Cette phase demande un compte développeur payant. Prépare CarPlay (scène dédiée : bibliothèque, playlists, récents, lecture en cours), l'extension Siri (lire, ajouter à une playlist, aimer un titre), les actions Raccourcis et le glisser-déposer de titres et d'albums. Pour CarPlay, prépare la configuration et dis-moi précisément quelle autorisation demander à Apple. Ces fonctions ne seront testables qu'après une installation signée.
```

### Phase 6 : publication du code

```text
Prépare la publication du code : README (installation, fonctions, captures de notre app), fichier de licence avec les mentions MPL 2.0 et Commons Clause d'AmpFin, remerciements, recherche de secrets oubliés dans le code. Ne publie ni IPA ni release tant que la licence d'AmpFin n'est pas clarifiée : liste-moi ce qu'il faut demander à son auteur.
```
