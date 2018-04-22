/**
* Name: myproject
* Author: civic
* Description: 
* Tags: Tag1, Tag2, TagN
*/

model myproject

/* Insert your model definition here */

global {
	int number_of_people <- 50;
	int number_of_rats <- 20;
	
	init{
		create people number:number_of_people;
		create rats number:number_of_rats; 
	}
	
}

species people skills:[moving]	{
	bool is_infected <- false;
	
	reflex moving {
		do wander;
	}
	
	aspect base {
		draw circle(2) color: (is_infected)? #red : #green; 
	}
}

species rats skills:[moving] {
	bool is_infected <- flip(0.50);
	int attack_range <- 5;
	
	reflex moving {
		do wander;
	}
	
	reflex attack when: !empty(people at_distance attack_range){
		ask people at_distance attack_range{
			if (self.is_infected) {
				myself.is_infected <- true;
				}
			else if(myself.is_infected){
				self.is_infected <- true;
			}	
			}
		} 
	
	aspect base {
		draw circle(1) color: (is_infected)? #red : #green; 
	}
}

experiment my_experiment type:gui {
	parameter "Number of People:" var: number_of_people;
	parameter "Number of Rats:" var: number_of_rats;
	
	output {
		display my_disiplay {
			species people aspect:base;
			species rats aspect:base;
		}
		
		display my_chart {
			chart "Number of infected people "{
				data "infected people" value: length (people where (each.is_infected = true)); 
			}
		}
	}
}