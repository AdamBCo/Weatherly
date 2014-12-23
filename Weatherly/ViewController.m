//
//  ViewController.m
//  Weatherly
//
//  Created by Adam Cooper on 12/21/14.
//  Copyright (c) 2014 Adam Cooper. All rights reserved.
//

#import "ViewController.h"
#import "UserLocationManager.h"
#import "CustomActivityIndicator.h"

@interface ViewController () <UIScrollViewDelegate>
@property UserLocationManager *sharedUserLocationManager;

@property (weak, nonatomic) IBOutlet UIButton *temperatureLabel;
@property (weak, nonatomic) IBOutlet UILabel *townLabel;
@property (weak, nonatomic) IBOutlet UILabel *forecastLabel;
@property NSDictionary *weatherJSON;
@property NSString *temperatureFahrenheit;
@property NSString *temperatureCelsius;

@property BOOL isTemperatureInFahrenheit;
@property (strong, nonatomic) IBOutlet CustomActivityIndicator *customActivityView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.sharedUserLocationManager = [UserLocationManager sharedInstance];
    
    self.temperatureLabel.alpha = 0;
    self.forecastLabel.alpha = 0;
    self.townLabel.alpha = 0;
    
    //You need to subtract the radius of the indicatior view.
    [self.view addSubview:self.customActivityView];
    [self.customActivityView startAnimating];
    
    [self getWeatherDataBasedOnCurrentLocationwithCompletion:^{
        NSLog(@"We got weather");
        NSString *place = [self.weatherJSON objectForKey:@"name"];
        [self.townLabel setText:place];
        NSString *forecast = [[[self.weatherJSON objectForKey:@"weather"] objectAtIndex:0] objectForKey:@"main"];
        [self.forecastLabel setText:forecast];
        
        NSString *temperature = [[self.weatherJSON objectForKey:@"main"] objectForKey:@"temp"];
        float celsius = [temperature floatValue] - 273.15;
        float fahrenheit = 1.8*([temperature floatValue] - 273) + 32;
        
        //Degeee SYmbol is Shift+Option + 8
        self.temperatureFahrenheit= [NSString stringWithFormat:@"%.f",fahrenheit];
        self.temperatureCelsius = [NSString stringWithFormat:@"%.f",celsius];
        
        self.isTemperatureInFahrenheit = YES;
        
        [self.temperatureLabel setTitle:self.temperatureFahrenheit forState:UIControlStateNormal];
        
        [self animateLabels];
        
    }];
    
    [self createViewOne];
    [self createViewTwo];
    
    self.scrollView.contentSize = CGSizeMake(self.view.frame.size.width*2, self.scrollView.frame.size.height);
    
    //This is the starting point of the ScrollView
    CGPoint scrollPoint = CGPointMake(0, 0);
    [self.scrollView setContentOffset:scrollPoint animated:YES];
    
    
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    //    CGFloat pageWidth = CGRectGetWidth(self.view.bounds);
    //    CGFloat pageFraction = self.scrollView.contentOffset.x / pageWidth;
    //    self.pageControl.currentPage = roundf(pageFraction);
    
}

-(void)createViewOne{
    
    //    CGFloat originWidth = self.scrollView.frame.size.width;
    CGFloat originHeight = self.scrollView.frame.size.height;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, originHeight)];
    view.backgroundColor = [UIColor clearColor];
    
    self.scrollView.delegate = self;
    [self.scrollView addSubview:view];
    
}

-(void)createViewTwo{
    
    CGFloat originWidth = self.view.frame.size.width;
    CGFloat originHeight = self.view.frame.size.height;
    
    CGFloat scrollHeight = self.scrollView.frame.size.height*.9;
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(self.view.frame.size.width, 0, self.view.frame.size.width, originHeight)];
    view.backgroundColor = [UIColor greenColor];
    
    UIView *squareOne = [[UIView alloc] initWithFrame:CGRectMake(originWidth *.025, originWidth *.025, scrollHeight, scrollHeight)];
    squareOne.layer.borderColor = [UIColor whiteColor].CGColor;
    squareOne.layer.borderWidth = 2.0f;
    [view addSubview:squareOne];
    
    UIView *squareTwo = [[UIView alloc] initWithFrame:CGRectMake(originWidth *.425, originWidth *.025, scrollHeight, scrollHeight)];
    squareTwo.layer.borderColor = [UIColor whiteColor].CGColor;
    squareTwo.layer.borderWidth = 2.0f;
    [view addSubview:squareTwo];
    
    UIView *squareThree = [[UIView alloc] initWithFrame:CGRectMake(originWidth *.825, originWidth *.025, scrollHeight, scrollHeight)];
    squareThree.layer.borderColor = [UIColor whiteColor].CGColor;
    squareThree.layer.borderWidth = 2.0f;
    [view addSubview:squareThree];
    
    UIView *squareFour = [[UIView alloc] initWithFrame:CGRectMake(originWidth *1.255, originWidth *.025, scrollHeight, scrollHeight)];
    squareFour.layer.borderColor = [UIColor whiteColor].CGColor;
    squareFour.layer.borderWidth = 2.0f;
    [view addSubview:squareFour];
    
    self.scrollView.delegate = self;
    [self.scrollView addSubview:view];
    
}





-(void)animateLabels {
    
    //Animate Text Alpha
    [UIView animateWithDuration:2.0 delay:1.8 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.temperatureLabel.alpha = 1;
        self.forecastLabel.alpha = 1;
        self.townLabel.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
    
}

- (IBAction)onTemperatureButtonPressed:(id)sender {
    
    self.isTemperatureInFahrenheit = !self.isTemperatureInFahrenheit;
    
    if (!self.isTemperatureInFahrenheit) {
        [self.temperatureLabel setTitle:self.temperatureFahrenheit forState:UIControlStateNormal];
    } else {
        [self.temperatureLabel setTitle:self.temperatureCelsius forState:UIControlStateNormal];
    }
    
    
}

-(void)getWeatherDataBasedOnCurrentLocationwithCompletion:(void (^)(void))completion{
    
    CLLocation *userLocation = self.sharedUserLocationManager.locationManager.location;
    NSString *currentLatitude = @(userLocation.coordinate.latitude).stringValue;
    NSString *currentLongitude = @(userLocation.coordinate.longitude).stringValue;
    NSString *urlString = [NSString stringWithFormat:@"http://api.openweathermap.org/data/2.5/weather?lat=%@&lon=%@",currentLatitude,currentLongitude];
    NSURL *url = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding: NSUTF8StringEncoding]];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:request queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        NSDictionary *result = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
        
        NSLog(@"The response: %@",result);
        self.weatherJSON = result;
        completion();
    }];
}



@end
