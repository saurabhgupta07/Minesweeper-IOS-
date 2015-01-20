//
//  MyView.m
//  Minesweeper
//
//  Created by Saurabh Gupta on 10/7/14.
//  Copyright (c) 2014 Saurabh Gupta. All rights reserved.
//

/*Values in the grid
 * -1 denoted Mine
 * numbers 0-8 denote number of mines near a specific box.
 * -2 is the a flagged Mine
 * (0->8)+25 is a flagged number
 * (0->8)+100 is an opened number
 */
 
 

#import "MyView.h"

@interface MyView()
@property (nonatomic, assign) CGFloat dw, dh;  // width and height of cell
@property (nonatomic, assign) CGFloat x, y;    // touch point coordinates
@property (nonatomic, assign) int row, col;    // selected cell in cell grid
@property (nonatomic, assign) int gridSize;
@property (nonatomic,assign)  int noOfMines;
@property (nonatomic,assign) int flagCount;
@property (weak, nonatomic) IBOutlet UITextField *noOfFlags;



@end

@implementation MyView


int gameGrid[16][16];
int posToBeShown[16][16];
bool mineHit = false,gameStarted = false, numberHit = false;
bool gameWon = false;
int shiftBy;

@synthesize dw,dh,x,y,row,col, gridSize,noOfMines,flagCount;

-(id) initWithFrame:(CGRect)frame{
    
    NSLog(@"Init with frame ");
    
    return self = [super initWithFrame : frame];

}

-(void) drawRect:(CGRect)rect

{
    NSLog(@"Draw rect");
    gridSize = 16;
    CGContextRef context = UIGraphicsGetCurrentContext(); // get the current graphics
    CGRect bounds = [self bounds];
    CGFloat width  = CGRectGetWidth(bounds);
    CGFloat height = CGRectGetHeight(bounds);
    height = height-(height-width);
    dw = width/gridSize;
    dh = height/gridSize;
   shiftBy =5;
    NSLog( @"view (width,height) = (%g,%g)", width, height );
    
    NSLog( @"cell (width,height) = (%g,%g)", dw, dh );
    [[UIColor lightGrayColor]setFill];
    CGRect rect1 = CGRectMake (0, shiftBy*dh, width,height);
    UIRectFill(rect1);
    CGContextBeginPath(context);
    
    for(int i=0 ;i<=gridSize;i++){
        CGContextMoveToPoint(context,i*dw,dw*shiftBy);
        CGContextAddLineToPoint(context, i*dw,height+dw*shiftBy);
    }
    
    for(int i= shiftBy; i<=gridSize+shiftBy ;i++){
        CGContextMoveToPoint(context,0,i*dh);
        CGContextAddLineToPoint(context, width,i*dh);
        
        
    }
    
    [[UIColor blackColor]setStroke];
    CGContextDrawPath( context, kCGPathStroke );
    noOfMines = gridSize*gridSize*0.2;
    
    _noOfFlags.text = [NSString stringWithFormat:@"%d",flagCount];
    if(gameWon){
        UIAlertView *alertGameWon = [[UIAlertView alloc] initWithTitle: @"Winner" message: @"Congratulations you have succesfully finished the game." delegate: self cancelButtonTitle:@"Dismiss" otherButtonTitles:nil];
        [alertGameWon show];
        
    }
    
    
    if(mineHit){
        [self displayMines];
        //mineHit = false;
        UIAlertView *alertGameOver = [[UIAlertView alloc] initWithTitle: @"Game Over" message: @"You Lose. Start a New Game to play again." delegate: self cancelButtonTitle:@"Dismiss" otherButtonTitles:@"New Game",nil];
        [alertGameOver show];
    }
    if(numberHit){
        [self showNumbers];
        
        
    }
    if(!gameStarted)
    {
        flagCount = noOfMines;
        [self setMines];
        [self setGrid];
    }
    for(int i=0;i<16;i++){
        for(int j=0;j<16;j++){
            if(gameGrid[i][j] == -2 || (gameGrid[i][j]>=25 && gameGrid[i][j]<100))
            {
                UIImage *image = [UIImage imageNamed:@"flag"];
                CGRect rectPos = CGRectMake (dw*i,dh*(j+shiftBy), self.dw, self.dh);
                [image drawInRect:rectPos];
                
            }
            
        }
        
    }

}


-(void) setGrid{
    
           for(int i=0;i<16;i++)
    {
        for(int j=0;j<16;j++)
        {
            if(gameGrid[i][j]==-1)
            {
                if(i>0 && j>0 && gameGrid[i-1][j-1]!=-1)
                    gameGrid[i-1][j-1]++;
                if(i>0 && gameGrid[i-1][j]!=-1)
                    gameGrid[i-1][j]++;
                if(i>0&&j<15 && gameGrid[i-1][j+1]!=-1)
                    gameGrid[i-1][j+1]++;
                if(j>0 && gameGrid[i][j-1]!=-1)
                    gameGrid[i][j-1]++;
                if(j<15 && gameGrid[i][j+1]!=-1)
                    gameGrid[i][j+1]++;
                if(i<15 && j>0 && gameGrid[i+1][j-1]!=-1)
                    gameGrid[i+1][j-1]++;
                if(i<15 && gameGrid[i+1][j]!=-1)
                    gameGrid[i+1][j]++;
                if(i<15 && j<15 &&  gameGrid[i+1][j+1]!=-1)
                gameGrid[i+1][j+1]++;
                
                
            }
            
        }
    }
    
    
    
    
}

-(void) setMines{
    
    for(int i=0;i<16;i++)
    {
        for(int j=0;j<16;j++)
        gameGrid[i][j]=0;
        
    }

    
    
    for(int i=0;i<noOfMines;i++){
        
        int x1 =  arc4random()%gridSize;
        int y1 = arc4random()%gridSize;
        
        
        gameGrid[x1][y1] =-1;
        NSLog(@"Mines %d %d",x1,y1);
        
        
    }
    
    
    

}
-(void) displayMines{
    
    UIImage* image;
    
    for(int i =0;i<16;i++){
        for(int j=0;j<16;j++){
            if(gameGrid[i][j]==-1){
                image = [UIImage imageNamed:@"mine"];
                CGRect rectPos = CGRectMake (dw*i,dh*(j+shiftBy), self.dw, self.dh);
                [image drawInRect:rectPos];
                
            
                
            }
            if(gameGrid[i][j]==-2){
                image = [UIImage imageNamed:@"mine"];
                CGRect rectPos = CGRectMake (dw*i,dh*(j+shiftBy), self.dw, self.dh);
                [image drawInRect:rectPos];
                
            }
            
        }
        
    }
    
    
}

- (void) displayNumbers:(int) xPos : (int) yPos
{
    int start_x,start_y, end_x,end_y;
    int minesDetected=0;
    
    if(gameGrid[xPos][yPos]!=-1 && gameGrid[xPos][yPos]<25 && gameGrid[xPos][yPos]!=-2)
    {
    
    if(xPos==0)
      start_x = xPos;
    else
    start_x = xPos-1;
    if(yPos==0)
    start_y = yPos;
    else
    start_y = yPos-1;
    
    if(xPos==15)
    end_x = xPos;
    else
    end_x = xPos+1;
    
    if(yPos==15)
    end_y = yPos;
    else
    end_y = yPos+1;
    
    for (int i=start_x; i<=end_x; i++) {
        for(int j= start_y ; j<=end_y ; j++)
        {
            if(gameGrid[i][j]== -1 && gameGrid[xPos][yPos]!=-2){
                minesDetected++;
            }
            
        }
    }
    if(minesDetected == 0){
        gameGrid[xPos][yPos]=100; // Empty square is marked 100 to show it is displayed in grid
        posToBeShown[xPos][yPos] =1;
        for (int i=start_x; i<=end_x; i++) {
        for(int j= start_y ; j<=end_y ; j++)
        {
            [self displayNumbers:i :j];
        }
    
    }    }
    
    else
    {
        gameGrid[xPos][yPos]=gameGrid[xPos][yPos] + 100; // numbers from 1-8 are increased by 100 as they have been showed in the grid
        posToBeShown[xPos][yPos] =1;
    }
}
    
}

-(void) showNumbers{
    
    for(int i=0;i<16;i++)
     for(int j=0;j<16;j++){
     if(posToBeShown[i][j]==1){
     
     
     
     CGRect rectPos = CGRectMake (dw*i,dh*(j+shiftBy), self.dw, self.dh);
     NSString *val = [NSString stringWithFormat:@"%d",gameGrid[i][j]];
     if(gameGrid[i][j]>100)
         
      {
     
         val = [NSString stringWithFormat:@"%d",gameGrid[i][j]-100]; // done to get the correct image
      }
         
         if(gameGrid[i][j]!=100 && gameGrid[i][j]>0){
     NSString *imageName = [@"number" stringByAppendingString:val];
     UIImage* image = [UIImage imageNamed:imageName];
     [image drawInRect:rectPos];
             
            
    
         }
         else{
             [[UIColor grayColor]setFill];
              UIRectFill(rectPos);
           
         }
         
     
     }
     
     }

}



// Checking if mine has been hit
-(BOOL) checkMineHit : (int) xPos : (int) yPos
{
    
    for(int i=0;i<16;i++){
        for(int j=0; j<16;j++){
            if(gameGrid[i][j]==-1)
                if(xPos==i && yPos==j)
            {
                NSLog(@"Mine Hit");
                mineHit = true;
                return true;
            }
        }
    }
    return false;
    
}

-(BOOL) checkForWiningCondition{
    
    for(int i=0;i<16;i++){
        for(int j=0;j<16;j++){
            if(gameGrid[i][j]==-2 || gameGrid[i][j]>=100)
            continue;
            else
            return false;
        }
            }
    return true;

    
    
}
- (IBAction)createNewGame:(id)sender {
    
    mineHit = false;
    gameStarted = false;
    gameWon = false;
    
    numberHit = false;
    for(int i=0;i<16;i++)
    {
        for(int j=0;j<16;j++){
            
            gameGrid[i][j]=0;
            posToBeShown[i][j]=0;
        }
        
        
    }
    flagCount = 0;
    [self setNeedsDisplay];

    
}
- (void) tapSingleHandler: (UITapGestureRecognizer *) sender
{
    gameStarted = true;
    if(gameWon || mineHit)
    return;
    
    if ( sender.state == UIGestureRecognizerStateEnded )
    {
        CGPoint xy;
        xy = [sender locationInView: self];
        int xPos = xy.x/dw;     // position of taps in terms of grid
        int yPos = xy.y/dh-shiftBy;
        if(flagCount>0){
        if(gameGrid[xPos][yPos] <100)// done to disable tap on already opened boxes
        {
            
        
        if(gameGrid[xPos][yPos] == -1) //Mine is flagged
            {flagCount--;
                gameGrid[xPos][yPos] = -2;}
        
        else if(gameGrid[xPos][yPos] == -2) //Mine is unflagged
            {
                gameGrid[xPos][yPos] = -1;
                flagCount++;
            }
        
        else if(gameGrid[xPos][yPos]>=25 && gameGrid[xPos][yPos]<100) //number from 0-8 is unflagged
            {
                flagCount++;
                gameGrid[xPos][yPos] = gameGrid[xPos][yPos]-25;
            }
        
        else if(gameGrid[xPos][yPos]>=0 && gameGrid[xPos][yPos]<=8) //number from 0-8 is flagged
            {
                flagCount--;
                gameGrid[xPos][yPos] = gameGrid[xPos][yPos]+25;
            }
        
        
        else{}
        
        
        
        [self setNeedsDisplay];
        }
        if([self checkForWiningCondition]){
            gameWon = true;
            [self setNeedsDisplay];
        }
        }
        
    }
    
}

- (void) tapDoubleHandler: (UITapGestureRecognizer *) sender
{
    gameStarted = true;
    if(gameWon || mineHit)
    return;
    
    if ( sender.state == UIGestureRecognizerStateEnded )
    {
               CGPoint xy;
        xy = [sender locationInView: self];
        int xPos = xy.x/dw;     // position of taps in terms of grid
        int yPos = xy.y/dh-shiftBy;
        NSLog(@"XPos : %d YPos :%d %d",xPos,yPos,gameGrid[xPos][yPos]);
        
        
            if(gameGrid[xPos][yPos]<25 && gameGrid[xPos][yPos] >=-1)   // done to disable double taps on already opened boxes and also on flags that have been set
            {
                
                if([self checkMineHit:xPos :yPos])
                [self setNeedsDisplay];
                else
                {
                    
                    numberHit = true;
                    [self displayNumbers:xPos :yPos];
                    [self setNeedsDisplay];
                    
                }
            }
            
        if([self checkForWiningCondition]){
            gameWon = true;
            [self setNeedsDisplay];
        }
        
        
    }
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    NSLog(@"New Game");
    
    if(buttonIndex==1)//user clicked new game;
    {
        
        
        mineHit = false;
        gameStarted = false;
        gameWon = false;
        
        numberHit = false;
        for(int i=0;i<16;i++)
        {
            for(int j=0;j<16;j++){
                
                gameGrid[i][j]=0;
                posToBeShown[i][j]=0;
            }
            
            
        }
        flagCount = 0;
        [self setNeedsDisplay];    }

}


@end

