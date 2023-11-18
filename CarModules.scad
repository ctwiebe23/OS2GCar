/**
 * Creates a cube of the given vectors with rounded
 * edges of the given radius.  By default all edges
 * are rounded, but passing values into x/y/z will
 * specifiy certain faces on that axis for inclusion
 *
 * Positive values fillet edges on the positive face,
 * negative values fillet edges on the negative face,
 * a value of zero flattens both faces on the indicated
 * axis
 *
 * @para v (vector)
 * @para r (num)
 * @para x (num)
 * @para y (num)
 * @para z (num)
 */
module fcube(v,r,x,y,z) {
    c = 0.0001;
    m = min(v)/2;
    
    radius = (r > m) ? m :
             (r > 0) ? r :
                       c ;
    
    /**
     * Converts the given number (an axis from initial 
     * declaration) into a list of 2 booleans based on
     * its sign
     * 
     * @para axis (num)
     * @returns [bool,bool]
     */
    function getFaces(axis) = 
             (axis == undef) ? [true ,true ] :
             (axis > 0)      ? [true ,false] :
             (axis < 0)      ? [false,true ] :
                               [false,false] ;
    
    /**
     * Compares the 2 given boolean lists (created by 
     * getFaces) to create a single boolean list of 
     * size 4
     *
     * @para arr ([bool,bool])
     * @para brr ([bool,bool])     
     * @returns [bool,bool,bool,bool] 
     */
    function getEdges(arr,brr) = [(arr[0] && brr[0]),
                                  (arr[1] && brr[0]),
                                  (arr[0] && brr[1]),
                                  (arr[1] && brr[1])];
              
    /**
     * Creates a pillar of height v[index] (v being the
     * vector of the parent module) translated to the 
     * given position (pos).  If condition is true the
     * pillar is round, else it is square
     *
     * @para pos (vector)
     * @para index (num)
     * @para condition (bool)
     */
    module pillar(pos,index,condition) {
        if(condition) {
        translate(pos)
            cylinder(v[index],r = radius,center = true);
        } else {
            xpos = (pos[0] > 0) ? pos[0] + radius/2 :
                                  pos[0] - radius/2 ;
            ypos = (pos[1] > 0) ? pos[1] + radius/2 :
                                  pos[1] - radius/2 ;
                
        translate([xpos,ypos,0])
            cube([radius,radius,v[index]],true);
        }
    }
    
    /**
     * Creates a beam along the axis specified by the 
     * given index of a vector.  Boolean paramaters
     * specify whether an edge is to be rounded or not
     * 
     * @para index (num)
     * @para topRight  (bool)
     * @para downRight (bool)
     * @para topLeft   (bool)
     * @para downLeft  (bool)
     */
    module beam(index,topRight,downRight,
                      topLeft ,downLeft) {
        direction = (index == 0) ? [0,-90,0] :
                    (index == 1) ? [90, 0,0] :
                                   [0,180,0] ;
                
        xpos = ((index == 0) ? v[2] : 
                               v[0] ) / 2 - radius + c ;
        ypos = ((index == 1) ? v[2] : 
                               v[1] ) / 2 - radius + c ;
        
        rotate(direction)
        hull() {
            pillar([ xpos, ypos,0],index,topRight );
            pillar([-xpos, ypos,0],index,downRight);
            pillar([ xpos,-ypos,0],index,topLeft  );
            pillar([-xpos,-ypos,0],index,downLeft );
        }
    }
    
    frontBack = getFaces(x);
    leftRight = getFaces(y);
    topDown   = getFaces(z);
    
    xedge = getEdges(topDown,  leftRight);
    yedge = getEdges(frontBack,topDown  );
    zedge = getEdges(leftRight,frontBack);
    
    intersection() {
        beam(0,xedge[0],xedge[1],xedge[2],xedge[3]);
        beam(1,yedge[0],yedge[1],yedge[2],yedge[3]);
        beam(2,zedge[2],zedge[0],zedge[3],zedge[1]);
    }
}