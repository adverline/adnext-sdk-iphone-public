AdNext SDK iOS
=================

AdNext SDK permet l'affichage de publicités de la régie Adverline sur iPhone, iPad et iPod Touch tournant sur iOs 6 et supérieur.

Celui-ci a été développé dans un soucis de simplification de l'intégration tout en permettant une customisation la plus poussée possible.

Pour fonctionner, vous devez posséder une clef d'application fournie par la régie.

Si vous n'en disposez pas encore, vous pouvez nous contacter par le site internet : http://www.adverline.com/fr/contact/

##Bien démarrer##

Tout d'abord, téléchargez le projet complet du SDK.

Dans celui-ci vous trouverez un projet d'exemple, vous permettant de tester la majeur partie des fonctionnalités/customisations.

Une fois dézippé, glissez/déposez le dossier AdnextSDK-iOs/AdnextSDK-iOs à l'intèrieur de votre projet.

Un seul et même objet du SDK vous permet de traiter de la même manière les bannières ainsi que les interstitiels plein écran.

###Bannières###
Les bannières occupent une petite portion de l'écran. Elles visent à inciter les internautes à cliquer dessus pour accéder à un contenu plus riche en plein écran, tel qu'un site Web ou la page d'une plate-forme de téléchargement d'applications. Ce guide explique comment activer une application de sorte qu'elle diffuse une bannière.

###Interstitiels###
Les interstitiels présentent immédiatement du contenu HTML5 enrichi ou des "applications Web" à des points de transition clés, tels qu'au lancement de l'application, à la diffusion d'une annonce vidéo pré-roll ou au chargement d'un niveau de jeu. Les applications Web reposent sur une navigation intégrée dans l'application associée à un bouton de fermeture plutôt qu'à une barre de navigation. Autrement dit, le contenu fournit son propre schéma de navigation interne. Généralement, les annonces interstitielles sont plus chères. Elles sont également soumises à des contraintes d'impression.

##Ajouter un objet AdvAdView##

Les applications iOS sont constituées d'objets UIView. Il s'agit d'instances Objective-C qui apparaissent sous forme de zones de texte, de boutons ou d'autres options aux yeux de l'utilisateur. AdvAdView est une sous-classe UIView qui diffuse les annonces HTML5 de petit format, des images ou des vidéo, lesquelles réagissent lorsque l'internaute appuie dessus.

Comme pour les objets UIView, les objets AdvAdView sont faciles à créer dans le code.

Voici les sept étapes de code à suivre pour ajouter une bannière :


* Importez AdvAdView.h.
* Déclarez une instance AdvAdView dans le contrôleur UIViewController de votre application.
* Créez-la.
* Définissez l'ID du bloc d'annonces.
* Définissez le "contrôleur de vue racine".
* Ajoutez la vue à l'interface.
* Chargez-y une annonce.
* Nous vous recommandons de procéder au niveau UIViewController de l'application.


		// AdExampleViewController.h

		// Importez la définition de AdvAdView à partir du SDK.
		#import "AdvAdView.h"

		@interface BannerExampleViewController : UIViewController {
 		 // Déclarez-en une comme variable d'instance.
  			AdvAdView *adView_;
		}

		@end
		
L'instruction suivante permet d'effectuer la configuration des bannières dans l'accroche d'initialisation viewDidLoad du contrôleur de vue.		
		
		@implementation ViewController

		- (void)viewDidLoad
		{
		    [super viewDidLoad];
    
		    // Créez une vue à la taille standard en haut de l'écran.
		    // Les constantes AdSize disponibles sont expliquées dans GADAdSize.h.
		    adView_ = [[AdvAdView alloc] init];
    
		    // Définissez l'ID du bloc d'annonces.
		    adView_.adId = MY_BANNER_UNIT_ID;
		    adView_.format = AdvAdFormatBanner;
    
		    // Spécifiez le contrôleur UIViewController que l'exécution doit restaurer après avoir renvoyé
		    // l'utilisateur à l'emplacement de destination de l'annonce et ajoutez-le à la hiérarchie de la vue.
		    adView_.rootViewController = self;
    
		    // Initiez une demande générique afin d'y charger une annonce.
		    [adView_ loadRequest:[AdvAdRequest requestWithSection:@""] forCurrentView:self.view];
		}
		@end











