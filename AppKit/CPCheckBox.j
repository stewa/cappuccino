/*
 * CPCheckBox.j
 * AppKit
 *
 * Created by Francisco Tolmasky.
 * Copyright 2009, 280 North, Inc.
 *
 * This library is free software; you can redistribute it and/or
 * modify it under the terms of the GNU Lesser General Public
 * License as published by the Free Software Foundation; either
 * version 2.1 of the License, or (at your option) any later version.
 *
 * This library is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU
 * Lesser General Public License for more details.
 *
 * You should have received a copy of the GNU Lesser General Public
 * License along with this library; if not, write to the Free Software
 * Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA
 */

@import "CPButton.j"


CPCheckBoxImageOffset = 4.0;

@implementation CPCheckBox : CPButton
{
}

+ (id)checkBoxWithTitle:(CPString)aTitle theme:(CPTheme)aTheme
{
    return [self buttonWithTitle:aTitle theme:aTheme];
}

+ (id)checkBoxWithTitle:(CPString)aTitle
{
    return [self buttonWithTitle:aTitle];
}

+ (CPString)defaultThemeClass
{
    return @"check-box";
}

+ (Class)_binderClassForBinding:(CPString)theBinding
{
    if (theBinding === CPValueBinding)
        return [_CPCheckBoxValueBinder class];

    return [super _binderClassForBinding:theBinding];
}

- (id)initWithFrame:(CGRect)aFrame
{
    self = [super initWithFrame:aFrame];

    if (self)
    {
        [self setHighlightsBy:CPContentsCellMask];
        [self setShowsStateBy:CPContentsCellMask];

        // Defaults?
        [self setImagePosition:CPImageLeft];
        [self setAlignment:CPLeftTextAlignment];

        [self setBordered:NO];
    }

    return self;
}

- (void)takeStateFromKeyPath:(CPString)aKeyPath ofObjects:(CPArray)objects
{
    var count = objects.length,
        value = [objects[0] valueForKeyPath:aKeyPath] ? CPOnState : CPOffState;

    [self setAllowsMixedState:NO];
    [self setState:value];

    while (count-- > 1)
    {
        if (value !== ([objects[count] valueForKeyPath:aKeyPath] ? CPOnState : CPOffState))
        {
            [self setAllowsMixedState:YES];
            [self setState:CPMixedState];
        }
    }
}

- (void)takeValueFromKeyPath:(CPString)aKeyPath ofObjects:(CPArray)objects
{
    [self takeStateFromKeyPath:aKeyPath ofObjects:objects];
}

@end

@implementation _CPCheckBoxValueBinder : CPBinder
{
}

- (void)setValue:(id)aValue forBinding:(CPString)aBinding
{
    var newValue = aValue;
    if ( CPIsControllerMarker(aValue) || aValue === nil )
    {
        var options = [_info objectForKey:CPOptionsKey],
            newValue = CPOffState;
        if (aValue === CPMultipleValuesMarker)
        {
            if ([options containsKey:CPMultipleValuesPlaceholderBindingOption])
                newValue = [_source setState:[options valueForKey:CPMultipleValuesPlaceholderBindingOption]];
            else
                newValue = CPMixedState;
        }
        else if (aValue === CPNoSelectionMarker)
        {
            if ([options containsKey:CPNoSelectionPlaceholderBindingOption]);
                newVaue = [options valueForKey:CPNoSelectionPlaceholderBindingOption];
         }
         else if (aValue === CPNotApplicableMarker)
         {
             if ([options containsKey:CPNotApplicablePlaceholderBindingOption])
                newValue = [options valueForKey:CPNotApplicablePlaceholderBindingOption];
         }
         else
         {
            if ([options containsKey:CPNullPlaceholderBindingOption])
                newValue = [options valueForKey:CPNullPlaceholderBindingOption];
         }
     }

     [_source setAllowsMixedState:(newValue === CPMixedState)];
     [_source setState:newValue];
}

@end
