//
//  VPortObject.h
//  ThreadPortTest
//
//  Created by wang on 2019/10/22.
//  Copyright © 2019 Vincent. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VPortObject : NSObject
- (void)portLaunchThreadWithPort:(NSPort *)port;
@end

