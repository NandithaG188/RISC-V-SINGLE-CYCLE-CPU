// EcoMender Bot : Task 1B : Color Detection using State Machines
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design a module which will detect colors red, green, and blue using state machine and frequency detection.

Recommended Quartus Version : 20.1
The submitted project file must be 20.1 compatible as the evaluation will be done on Quartus Prime Lite 20.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

// Color Detection
// Inputs : clk_1MHz, cs_out
// Output : filter, color

// Module Declaration
module t1b_cd_fd (
    input clk_1MHz, cs_out,
    output reg [1:0] filter, color
);

// red   -> color = 1;
// green -> color = 2;
// blue  -> color = 3;

//////////////////DO NOT MAKE ANY CHANGES ABOVE THIS LINE //////////////////
// red - 
//blue - 
// green - 

// State encoding for filter control


// Variables to store frequency counts for each color
//reg [15:0] red_count, green_count, blue_count;
reg temp_color;
reg [8:0] timer; // 9-bit counter to count up to 500

// Frequency detection counter
reg [14:0] freq_counter, max_count;

//reg flag;

initial begin // editing this initial block is allowed
    filter = 3; 
    color = 0;
    freq_counter = 0;
    //red_count = 0;
    //green_count = 0;
    //blue_count = 0;
	 max_count = 0;
	 timer = 0;
	 //flag =0;
end


// frequency scaling 


// State machine for filter swapping with timing control
always @(posedge clk_1MHz) begin
    // Check if timer reached the required duration for each filter state
    if (timer >= (filter == 2'b10 ? 1 : 500)) begin
        case (filter)
            2'b10: begin
					 filter = 2'b11;
                timer = 1;
					 max_count <= 0;
    					 // Reset timer
            end
            2'b00: begin
                filter = 2'b01;
                 // Store frequency count for red
                           // Reset frequency counter
					 if(freq_counter == max_count) color = 0;
					 if(freq_counter >= max_count) begin
						max_count <= freq_counter;
						temp_color <= 0; //1
						end
						// Move to the next state
                timer = 1;                   // Reset timer
					 //flag = 1;
            end
            2'b01: begin
                filter = 2'b10;
                   // Store frequency count for blue
                            // Reset frequency counter
					 if(freq_counter == max_count) color = 0;
					 else if(freq_counter > max_count) begin
						max_count <= freq_counter;
						color <= 3;
						end
					 else color <= temp_color + 1;
				   timer = 1;
					//flag= 1;
            end
            2'b11: begin
                filter = 2'b00;
					 if(freq_counter > max_count) begin
						max_count <= freq_counter;
						temp_color <= 1; //2
						end
                timer = 1;
					 //flag = 1;
            end
        endcase
    end
	 else begin
        // Increment timer each clock cycle
        timer = timer + 1;
		//flag = 0;
    end
end


// Edge Detection for cs_out
always @(posedge cs_out) begin
 freq_counter <= freq_counter + 1;
if(timer==1) freq_counter <=0;  // Increment counter on cs_out edge
end


//////////////////DO NOT MAKE ANY CHANGES BELOW THIS LINE //////////////////

endmodule 