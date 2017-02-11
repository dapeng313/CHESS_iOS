//
//  TreeTableViewCell.m
//  HRMS
//
//  Created by Apollo on 1/18/17.
//  Copyright © 2017 Apollo. All rights reserved.
//

#import "TreeTableViewCell.h"

@implementation TreeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) layoutSubviews {
    [super layoutSubviews];

    self.indentationWidth = 20.f; // 每个缩进级别的距离

    [[self textLabel] setFont: [UIFont systemFontOfSize:15]];
    [[self textLabel] setTextColor: [UIColor darkGrayColor]];

    self.imageView.frame = CGRectMake(self.imageView.frame.origin.x + (self.indentationLevel * self.indentationWidth) , self.imageView.frame.origin.y,
                                      self.imageView.frame.size.width, self.imageView.frame.size.height);

}

@end
