# Mise en route (compilation dans le cloud)

À lire en premier. Ton Mac est trop ancien pour Xcode, donc l'app se compile sur un Mac distant fourni
par GitHub, et tu l'installes sur ton iPhone avec SideStore.

## Le principe

1. Tu écris le code dans VS Code, avec Codex.
2. Tu pousses le code sur GitHub (`git push`).
3. GitHub Actions compile l'app sur un Mac distant et produit un fichier `Atolla.ipa` non signé.
4. Tu télécharges l'IPA et tu l'installes avec SideStore, qui la signe avec ton compte Apple gratuit.
   SideStore la renouvelle ensuite automatiquement.

## Ce qu'il te faut

- Un compte GitHub, Git, VS Code et Codex (extension ou ligne de commande).
- `gh`, l'outil en ligne de commande de GitHub, est facultatif mais très utile : il permet à Codex de
  lancer la compilation et de lire les erreurs seul. Sans lui, tu colles les logs à la main.
- SideStore sur ton iPhone, en version stable (celle qui a fonctionné pour toi), avec ton fichier
  d'appairage déjà en place.
- Ton serveur Jellyfin et un compte de test. Garde ses identifiants hors du dépôt.

## Limites de cette voie

- **Pas de Siri, de CarPlay ni de TestFlight** : SideStore ne sait pas signer les extensions d'app ni
  CarPlay. Ces fonctions arrivent en phase 5, avec un compte développeur Apple payant (99 $ par an).
- **Pas de simulateur ni d'aperçus** : chaque test passe par une compilation (quelques minutes) puis
  une installation sur l'iPhone.
- **Licence** : le README d'AmpFin dit que la diffusion de builds compilés soi-même n'est pas
  autorisée par sa licence. L'IPA est donc pour ton usage personnel. Ne la partage pas, et écris à
  l'auteur d'AmpFin avant de publier une release.
- Je n'ai pas testé le workflow : la première exécution peut demander un ajustement (nom du schéma).
- Les minutes de compilation sur Mac sont gratuites pour les dépôts publics d'après ce que je sais.
  Vérifie la tarification de GitHub, car un dépôt privé en consomme beaucoup plus vite.

## Installation en 8 étapes

1. Sur GitHub, ouvre https://github.com/rasmuslos/AmpFin et clique sur **Fork**. Renomme le fork « atolla ».
2. Dans ton fork, ouvre l'onglet **Actions** et active les workflows (ils sont désactivés par défaut sur un fork).
3. Clone-le : `git clone https://github.com/TON_COMPTE/atolla.git`, puis ouvre le dossier dans VS Code.
4. Copie à la racine du dépôt les fichiers `AGENTS.md`, `SPEC.md` et le dossier `.github` de ce kit,
   puis : `git add . && git commit -m "Add project brief, spec and build workflow" && git push`
5. Dans **Actions**, lance « Build unsigned IPA » (bouton *Run workflow*). Lis l'étape « Show Xcode
   version and schemes » : si le nom du schéma n'est pas `AmpFin`, corrige la variable `SCHEME` du workflow.
6. Quand le workflow est vert, télécharge l'artefact `Atolla-ipa` (fichier zip contenant `Atolla.ipa`).
7. Sur ton iPhone, ouvre SideStore, appuie sur **+** et choisis l'IPA (transfère-le d'abord sur l'iPhone).
8. Lance Codex dans le dossier du projet, et donne-lui le prompt de la phase 1.

## Les prompts, dans l'ordre

Codex lit `AGENTS.md` tout seul au début de chaque session.

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
