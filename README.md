#OPLocationKit - tomorrow's CoreLocation improvements, today

OPLocationKit was built to encapsulate all of the fancy functionality we needed while building location based apps (e.g. [Cloud Assassin](http://www.cloudassass.in)). The interface you will work mostly with is the `OPLocationCenter` singleton, which can be fired up when your app starts to being querying for location. You can configure the class to automatically geocode your location into a hiearchy of neighborhoods, county, city, etc. (using Google's geocode API), as well as find nearby venues (using Foursquare's API). This data is deserialized into corresponding `OPGoogleGeocodeResult` and `OPFoursquareVenue` classes.

##Example usage

When your app starts up you can configure the `OPLocationCenter` singleton and begin pinging for location data:

	[OPLocationCenter sharedLocationCenter].foursquareConsumerKey = @"";
	[OPLocationCenter sharedLocationCenter].foursquareConsumerSecret = @"";
	[OPLocationCenter sharedLocationCenter].geocodesLocation = YES;
	[OPLocationCenter sharedLocationCenter].findsFoursquareVenues = YES;
	
	// listen for geocoding updates
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(geocodeUpdate) name:kOPLocationCenterGoogleGeocodeUpdateNotification object:nil];
	
	// listen for Foursquare venue updates
	[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(venueUpdate) name:kOPLocationCenterFoursquareVenueUpdateNotification object:nil];
	
	// ... later in your code
	-(void) geocodeUpdate {
		NSLog(@"%@", [OPLocationCenter sharedLocationCenter].geocodedResults);
	}
	-(void) venueUpdate {
		NSLog(@"%@", [OPLocationCenter sharedLocationCenter].foursquareVenues);
	}

##Dependencies

* [AFNetworking](http://www.github.com)
* [BlocksKit](http://www.github.com)
* [OPExtensionKit](http://www.github.com)

##Installation

We love [CocoaPods](http://github.com/cocoapods/cocoapods), so we recommend you use it.

##Demo

Checkout [OPKitDemo](http://www.opetopic.com) for a demo application using OPExtensionKit, among other things.
