//
//  GeocodingHandler.m
//  geocoding
//
//  Created by Maurits van Beusekom on 07/06/2020.
//

#import "include/geocoding_ios/GeocodingHandler.h"

@implementation GeocodingHandler

- (void) geocodeFromAddress: (NSString *)address
                     locale: (NSLocale *)locale
                    success: (GeocodingSuccess)successHandler
                    failure: (GeocodingFailure)failureHandler {
    
    if (address == nil) {
        failureHandler(@"ARGUMENT_ERROR", @"Please supply a valid string containing the address to lookup");
        return;
    }
    
    MKLocalSearchRequest *searchRequest = [[MKLocalSearchRequest alloc] init];
    searchRequest.naturalLanguageQuery = address;
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:searchRequest];
    [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            if (error.code == MKErrorPlacemarkNotFound) {
                failureHandler(@"NOT_FOUND", @"Could not find any result for the supplied address or coordinates.");
            } else {
                failureHandler(@"IO_ERROR", error.description);
            }
            return;
        }
        
        if (response == nil || response.mapItems.count == 0) {
            failureHandler(@"NOT_FOUND", @"Could not find any result for the supplied address or coordinates.");
            return;
        }
        
        NSMutableArray<CLPlacemark *> *placemarks = [NSMutableArray array];
        for (MKMapItem *mapItem in response.mapItems) {
            if (mapItem.placemark != nil) {
                [placemarks addObject:mapItem.placemark];
            }
        }
        
        if (placemarks.count == 0) {
            failureHandler(@"NOT_FOUND", @"Could not find any result for the supplied address or coordinates.");
        } else {
            successHandler(placemarks);
        }
    }];
}

- (void) geocodeToAddress: (CLLocation *)location
                   locale: (NSLocale *)locale
                  success: (GeocodingSuccess)successHandler
                  failure: (GeocodingFailure)failureHandler  {
    if (location == nil) {
        failureHandler(@"ARGUMENT_ERROR", @"Please supply a valid location");
        return;
    }
    
    MKLocalSearchRequest *searchRequest = [[MKLocalSearchRequest alloc] init];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(location.coordinate, 100, 100);
    searchRequest.region = region;
    
    MKLocalSearch *search = [[MKLocalSearch alloc] initWithRequest:searchRequest];
    [search startWithCompletionHandler:^(MKLocalSearchResponse * _Nullable response, NSError * _Nullable error) {
        if (error != nil) {
            if (error.code == MKErrorPlacemarkNotFound) {
                failureHandler(@"NOT_FOUND", @"Could not find any result for the supplied address or coordinates.");
            } else {
                failureHandler(@"IO_ERROR", error.description);
            }
            return;
        }
        
        if (response == nil || response.mapItems.count == 0) {
            failureHandler(@"NOT_FOUND", @"Could not find any result for the supplied address or coordinates.");
            return;
        }
        
        NSMutableArray<CLPlacemark *> *placemarks = [NSMutableArray array];
        for (MKMapItem *mapItem in response.mapItems) {
            if (mapItem.placemark != nil) {
                [placemarks addObject:mapItem.placemark];
            }
        }
        
        if (placemarks.count == 0) {
            failureHandler(@"NOT_FOUND", @"Could not find any result for the supplied address or coordinates.");
        } else {
            successHandler(placemarks);
        }
    }];
}

+ (NSString *) languageCode:(NSLocale *)locale {
    return [locale languageCode];
}
@end
