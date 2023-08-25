module data_mux_module_FSM (
    input wire clk,                   // Internal clock operating at 100 MHz
    input wire symbol_clk,            // External symbol clock
    input wire rst,
    input wire [2:0] mode,            // Mode input
    input wire [31:0] switch_clk_cycles, // Number of clk cycles to switch data streams
    input wire [31:0] DS1,            // Data stream 1
    input wire [31:0] DS2,            // Data stream 2
    input wire [31:0] DS3,            // Data stream 3
    output wire [31:0] output_data    // Output data stream
);
    
// Register to store the mode input
reg [2:0] mode_reg;
// Counter to keep track of clock cycles for switching data streams
reg [31:0] switch_counter1 = 0,switch_counter2=0;

// Register to store the current data being output
reg [31:0] current_data;
// Flags and temp registers
reg data1_flag=1,data2_flag,data3_flag,start;
reg [1:0]temp_reg=0;

//state definitions
   parameter IDLE = 2'b00;
   parameter MODE1 = 2'b01;
   parameter MODE2 = 2'b10;
   parameter MODE3 = 2'b11;
//symbol clock domain process to initiate the start signal
always @(posedge symbol_clk)
 start<=1;
//state machine for FSM
   reg [1:0] state = IDLE;

   always @(posedge symbol_clk)
      if (rst) begin
         state <= IDLE;

      end
      else
         case (state)
            IDLE : begin
               if (mode==3'b001)
                 state <= MODE1;
               else if (mode==3'b010)
                  state <= MODE2;
               else if(mode==3'b011)
                  state <= MODE2;
               else
                  state <= IDLE;     
            end
            MODE1 : begin
               if (mode==3'b001)
                 state <= MODE1;
               else if (mode==3'b010)
                  state <= MODE2;
               else if(mode==3'b011)
                  state <= MODE3;
               else
                  state <= MODE1;
            end
            MODE2 : begin
               if (mode==3'b001)
                 state <= MODE1;
               else if (mode==3'b010)
                  state <= MODE2;
               else if(mode==3'b011)
                  state <= MODE3;
               else
                  state <= MODE2;
            end
            MODE3 : begin
               if (mode==3'b001)
                 state <= MODE1;
               else if (mode==3'b010)
                  state <= MODE2;
               else if(mode==3'b011)
                  state <= MODE3;
               else
                  state <= MODE3;
            end
         endcase
         
         
         
//clock domain process for switching data streams        
always @(posedge clk) begin

    if(rst==1)
        begin
         switch_counter1<= 0;
         switch_counter2<=0;
         data1_flag<=1;
        end
    else
        begin
        
        
        case (state)
        IDLE: begin
                    switch_counter1<= 0;
                    switch_counter2<=0;
                    data1_flag<=1;temp_reg<=0; 
                end
        MODE1: begin
                    switch_counter1<= 0;
                    switch_counter2<=0;
                    data1_flag<=1;temp_reg<=0; 
                end
        MODE2: begin
                    switch_counter2<=0;
                temp_reg<=0;
            if(switch_counter1<switch_clk_cycles) begin
                switch_counter1<=switch_counter1+1'b1;
                end
            else
               switch_counter1<=0; 
            if(switch_counter1==switch_clk_cycles-1)
                begin
                data1_flag<=~data1_flag;
                switch_counter1<=0;
                end
                end
        MODE3: begin
                    switch_counter1<=0;
                data1_flag<=1;
            if(switch_counter2<switch_clk_cycles) begin
                switch_counter2<=switch_counter2+1'b1;
                end
            else
               switch_counter2<=0;
            
            if(switch_counter2==switch_clk_cycles-1)
            begin
               switch_counter2<=0;
               temp_reg=temp_reg+1;
               if(temp_reg==3)
                temp_reg<=0;
            end
                end 
        default: current_data <= 0; 
    endcase
    
    end
end

//symbol clock domain process to select data streams
always @(*) begin
    // Use a case statement to determine the output data based on the mode input
    case (state)
        IDLE: begin
                    current_data <= 0; // Mode 1: Output data from DS1
                end
        MODE1: begin
                    current_data <= DS1; // Mode 1: Output data from DS1
                end
        MODE2: begin
                    if(data1_flag==1)
                    current_data <= DS1;// Mode 2: Alternate between DS1 and DS2
                    else 
                    current_data <= DS2;
                end
        MODE3: begin
                    if(temp_reg==0)
                    current_data <= DS1;
                    else if(temp_reg==1)
                    current_data <= DS2;
                    else if(temp_reg==2)
                    current_data <= DS3;
                end // Mode 3: Cycle through DS1, DS2, and DS3
        default: current_data <= 0; // Default case: No data output
    endcase
end

// Assign the current_data to the output port
assign output_data = current_data;

endmodule
