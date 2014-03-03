$fn = 100;
module left_piece() {
	color("WhiteSmoke") {
		difference() {
			// cylinder diameter is 15mm
			cylinder(h=35,r=7.5);
			// inner cube width and height is 9mm
			cube([9,9,20], true );
			translate([0,15,30]) {
				rotate([90,0,0]) {
					cylinder(h=30, r=2.5);
				}
			}
		}
	}
}

module right_piece(){
	color("WhiteSmoke") {
		hull() {
			// from heart of bottom_piece to end of right_piece = 35mm
			translate([0,0,28]) {
    			    cube(size=[5,5,1], center=true);
			}
			// right_piece thickness at begin right_piece is 10mm
			// right_piece thickness at end is 5mm
			cube(size=[10,10,1], center=true);
		}
	}
}


module connecting_block_left_piece() {
	rotate([0,0,0]) {
		rotate([0,90,0]) {
			translate([-10,1,4]) {
				//resistor();
			}
		}
	}
	color("WhiteSmoke") {
		translate([0,0,-16]) {
			translate([-3,0,15]) {
				cylinder(h=6,r=6);
			}
		}

		difference(){
			translate([0,0,9]) {			
				cube([10,10,20], true);
			}
			translate([-8,3,8]) {
				rotate([90,0,0]) {
					scale([1,1,2]) {
						long_hole_in_bottom_piece();
					}
				}	
			}
			rotate([0,90,0]) {
				translate([-7,0,-6]) {
					rotate([0,0,30]) {
						linear_extrude(height = 17, center = true, convexity = 10) {
							polygon(points=[	[-4,-2],
										   	[4,-2],
											[0,5]],
					    			paths=[[0,1,2]]);
						}
					}
	 			} 
			}
		
			translate([2,8,8]) {
				rotate([90]) {
					cylinder(20,1.5,1.5);
				}
			}
		}
	}
}


module resistor() { 
	color("LimeGreen") {
		linear_extrude(height=4) {
			polygon(points = [
				[-9.00,-2.00]
				,[-5.00,-2.00]
				,[-4.00,0.00]
				,[-2.00,-4.00]
				,[0.00,0.00]
				,[2.00,-4.00]
				,[4.00,0.00]
				,[6.00,-4.00]
				,[7.00,-2.00]
				,[11.00,-2.00]
				,[11.00,-1.00]
				,[7.00,-1.00]
				,[6.00,-2.00]
				,[4.00,2.00]
				,[2.00,-2.00]
				,[0.00,2.00]
				,[-2.00,-2.00]
				,[-4.00,2.00]
				,[-6.00,-1.00]
				,[-9.00,-1.00]
			]
			,paths = [
				[0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19]]
	          	  );
		}
	}
}

module full_upper_piece(){
	translate([3,0,-4]) {
		left_piece();
	}
	translate([5,0,32]) {
		connecting_block_left_piece();
	}
	translate([5,0,48]) {
		right_piece();
	}
}


module long_hole_in_bottom_piece() {
	hull() {
		translate([0,0,-5]) {
			short_hole_in_bottom_piece();
		}

		short_hole_in_bottom_piece();
		
	}
}

module short_hole_in_bottom_piece() {	
	translate([-6,0,5]) {
		rotate([0,90,0]) {
			cylinder(h=12,r=1.5);
		}
	}
}

module bottom_piece() {
	difference() {
		cylinder(h=50,r1=6,r2=6);
		translate([0,0,9]) {
			long_hole_in_bottom_piece();
		}
		translate([0,0,-2]) {
			short_hole_in_bottom_piece();
		}
		translate([0,0,24]) {
			long_hole_in_bottom_piece();
		}
		translate([-0,0,30]) {
			linear_extrude(height = 51, center = true, convexity = 10)
			polygon(points=[[-4,-2],
						 [4,-2],
						 [0,5]],
			    		paths=[[0,1,2]]);
 			} 
	}

	translate([0,-7,50-1.5]) {
		cube(size=[3,4,3], center=true );
	}
}



module full_key() {
	translate([10,0,40]) {
		rotate([90,180,-90]) {
			color("WhiteSmoke")
				bottom_piece();
		}
	}
	full_upper_piece();
}


rotate([0,-90,90]) {
	full_key();
}