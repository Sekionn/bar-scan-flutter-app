import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'app_language.dart';
import 'language_controller.dart';

class AppLocalizations {
  const AppLocalizations(this.language);

  final AppLanguage language;

  static AppLocalizations of(BuildContext context) {
    return AppLocalizations(context.watch<LanguageController>().language);
  }

  static AppLocalizations read(BuildContext context) {
    return AppLocalizations(context.read<LanguageController>().language);
  }

  String get languageName => _text('Dansk', 'English');
  String get switchLanguage => _text('Skift til engelsk', 'Switch to Danish');
  String get loginIntro => _text(
    'Log ind for at starte en butikssegmentscanning.',
    'Sign in to begin a store segment scan.',
  );
  String get checkingLogin =>
      _text('Kontrollerer login...', 'Checking login...');
  String get username => _text('Brugernavn', 'Username');
  String get password => _text('Adgangskode', 'Password');
  String get logIn => _text('Log ind', 'Log in');
  String get loggingIn => _text('Logger ind', 'Logging in');
  String get invalidLogin => _text(
    'Ugyldigt brugernavn eller adgangskode.',
    'Invalid username or password.',
  );
  String loginHttpFailed(int statusCode) => _text(
    'Login mislykkedes med HTTP $statusCode.',
    'Login failed with HTTP $statusCode.',
  );
  String get loginFailed => _text(
    'Login mislykkedes. Tjek forbindelsen og prøv igen.',
    'Login failed. Check the connection and try again.',
  );
  String get privacyTermsSupport => _text(
    'Privatliv, vilkår og support',
    'Privacy, terms & support',
  );
  String get legalSupport => _text('Jura og support', 'Legal & support');
  String get privacyPolicy => _text('Privatlivspolitik', 'Privacy policy');
  String get privacyBody => _text(
    'Bar\'scan gemmer kontooplysninger, butiksadgang og scannede stregkodeoptællinger, så butikker kan synkronisere og gennemgå lagerdata.',
    'Bar\'scan stores account details, shop access, and scanned barcode counts so stores can sync and review inventory data.',
  );
  String get terms => _text('Vilkår', 'Terms');
  String get termsBody => _text(
    'Servicevilkårene beskriver adgang, acceptabel brug, abonnementer, support og driftsansvar.',
    'The service terms describe access, acceptable use, subscriptions, support, and operational responsibilities.',
  );
  String get support => _text('Support', 'Support');
  String get supportBody => _text(
    'Kontakt support for hjælp til login, data, drift eller anmodninger om kontosletning.',
    'For login help, data questions, operational issues, or account deletion requests, contact support.',
  );
  String get accountDeletion => _text('Kontosletning', 'Account deletion');
  String get accountDeletionBody => _text(
    'Kontosletning håndteres af support, så ejerskab af virksomhed/butik og gemte lagerdata kan gennemgås, før adgang fjernes.',
    'Account deletion is handled by support so company/shop ownership and retained inventory records can be reviewed before access is removed.',
  );
  String contact(String value) => _text('Kontakt $value', 'Contact $value');
  String get storeSegment => _text('Butikssegment', 'Store segment');
  String get chooseShelf => _text('Vælg hyldenummer', 'Choose the shelf number');
  String get shelfSentAsOrigin => _text(
    'Denne værdi sendes som shelfOfOrigin.',
    'This value is sent as shelfOfOrigin.',
  );
  String get shelfNumber => _text('Hyldenummer', 'Shelf number');
  String get startScanning => _text('Start scanning', 'Start scanning');
  String shelf(String segment) => _text('Hylde $segment', 'Shelf $segment');
  String userShelf(String username, String segment) =>
      _text('$username - hylde $segment', '$username - shelf $segment');
  String get scannedProducts => _text('Scannede produkter', 'Scanned products');
  String get logOut => _text('Log ud', 'Log out');
  String get noProductsWaiting => _text(
    'Ingen produkter venter på synkronisering.',
    'No products waiting to sync.',
  );
  String syncedProducts(int count) => _text(
    "Synkroniserede $count ${count == 1 ? 'produkt' : 'produkter'}.",
    "Synced $count product${count == 1 ? '' : 's'}.",
  );
  String get syncStopped => _text(
    'Synkronisering stoppede. Tjek RabbitMQ-forbindelsen og prøv igen.',
    'Sync stopped. Check RabbitMQ connection and try again.',
  );
  String get synchronizing => _text(
    'Synkroniserer. Hold appen åben.',
    'Synchronizing. Please keep the app open.',
  );
  String get synchronize => _text('Synkroniser', 'Synchronize');
  String get stopScanning => _text('Stop scanning', 'Stop scanning');
  String get scan => _text('Scan', 'Scan');
  String get holdBarcodeSteady =>
      _text('Hold stregkoden stille.', 'Hold the barcode steady.');
  String get tapScanWhenReady =>
      _text('Tryk Scan, når du er klar.', 'Tap Scan when you are ready.');
  String get scanUpdated => _text('Scan opdateret.', 'Scan updated.');
  String get shelfLabel => _text('Hylde', 'Shelf');
  String get amountLabel => _text('Antal', 'Amount');
  String get editScan => _text('Rediger scan', 'Edit scan');
  String get barcode => _text('Stregkode', 'Barcode');
  String get amount => _text('Antal', 'Amount');
  String get amountCounted => _text('Optalt antal', 'Amount counted');
  String get cancel => _text('Annuller', 'Cancel');
  String get save => _text('Gem', 'Save');
  String get confirmBarcode => _text('Bekræft stregkode', 'Confirm barcode');
  String get add => _text('Tilføj', 'Add');
  String get required => _text('Påkrævet', 'Required');
  String get enterNumber => _text('Indtast et tal', 'Enter a number');
  String get enterWholeNumber =>
      _text('Indtast et heltal', 'Enter a whole number');
  String get enterZeroOrHigher =>
      _text('Indtast 0 eller højere', 'Enter 0 or higher');

  String _text(String da, String en) => language == AppLanguage.da ? da : en;
}
