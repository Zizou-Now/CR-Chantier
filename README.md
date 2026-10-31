# CR Chantier

Application mobile pour rédiger les comptes rendus de réunion de chantier : notes en vrac, photos légendées, compte rendu structuré, suivi des actions, recherche, export .html et .md.

L'interface est une page web (`www/index.html`) emballée en application Android avec [Capacitor](https://capacitorjs.com). Les données (projets, réunions, actions) restent sur le téléphone, les photos aussi.

## Obtenir l'APK sans rien installer (GitHub Actions)

1. Crée un dépôt vide sur GitHub (par exemple `cr-chantier`).
2. Dans ce dossier :
   ```bash
   git init
   git add .
   git commit -m "Première version"
   git branch -M main
   git remote add origin https://github.com/<ton-compte>/cr-chantier.git
   git push -u origin main
   ```
3. Sur GitHub, ouvre l'onglet **Actions**, puis le workflow **Build APK**. Il se lance à chaque push (le premier prend 5 à 10 minutes).
4. Quand il est vert, ouvre l'exécution et télécharge `cr-chantier-apk` en bas de page. C'est un zip qui contient `app-debug.apk`.
5. Envoie l'APK sur le téléphone, ouvre-le et autorise l'installation depuis cette source. Android affiche un avertissement : c'est normal pour une application qui ne vient pas du Play Store.

Pour publier une version téléchargeable depuis l'onglet **Releases**, pousse un tag :

```bash
git tag v0.1.0
git push origin v0.1.0
```

## Construire en local (facultatif)

Prérequis : Node 22, JDK 21 et Android Studio (ou le SDK Android).

```bash
npm install
npx cap add android        # une seule fois, crée le dossier android/
bash scripts/patch-android.sh
npx cap sync android
cd android && ./gradlew assembleDebug
```

L'APK est dans `android/app/build/outputs/apk/debug/app-debug.apk`. `npx cap open android` ouvre le projet dans Android Studio.

Pour tester l'interface seule, ouvre `www/index.html` dans un navigateur.

## Rédaction assistée par Claude

Le bouton « Rédiger le compte rendu » appelle l'API Anthropic avec **ta propre clé**.

1. Crée une clé sur <https://console.anthropic.com>.
2. Dans l'application : **Projets**, section « Rédaction assistée », colle la clé et enregistre.

La clé est stockée uniquement sur le téléphone. Sans clé, tout le reste fonctionne. Chaque rédaction est facturée sur ton compte API. Quiconque utilise l'application doit mettre sa propre clé : ne l'intègre jamais dans le code du dépôt.

## Limites de cette version

- **Pas de partage entre téléphones** : chaque installation a ses propres données. Les collègues reçoivent le compte rendu par l'export (.html, partagé via la feuille de partage Android).
- **Pas de sauvegarde automatique** : désinstaller l'application efface les données. Une fonction d'export et d'import de sauvegarde est la prochaine étape logique.
- **APK de debug** : signé avec une clé de test, suffisant pour un usage interne. Pour le Play Store, il faut un APK ou AAB signé avec ta clé de publication.
- **Icône par défaut** de Capacitor. Pour la remplacer, utilise `@capacitor/assets` avec une image `assets/icon.png`.

## Structure

```
www/index.html                 l'application (HTML, CSS, JavaScript)
capacitor.config.json          identifiant et nom de l'application Android
package.json                   dépendances Capacitor
scripts/patch-android.sh       ajoute la permission caméra au manifeste
.github/workflows/build-apk.yml   construction automatique de l'APK
```
