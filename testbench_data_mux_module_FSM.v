 
module testbench_data_mux_module_FSM;
    reg clk = 0;                     // Internal clock
    reg symbol_clk = 0;              // External symbol clock
    reg [2:0] mode;                  // Mode input
    reg rst;
    reg [31:0] switch_clk_cycles;    // Number of clk cycles to switch data streams
    reg [31:0] DS1, DS2, DS3;        // Data streams
    wire [31:0] output_data;         // Output data stream
    parameter CLK_PERIOD=10,SYS_CLK_PERIOD=120;
    // Instantiate the data_mux_module
    data_mux_module_FSM data_mux_inst (
        .clk(clk),
        .symbol_clk(symbol_clk),
        .rst(rst),
        .mode(mode),
        .switch_clk_cycles(switch_clk_cycles),
        .DS1(DS1),
        .DS2(DS2),
        .DS3(DS3),
        .output_data(output_data)
    );

    // Clock generation
    always #(CLK_PERIOD/2) clk = ~clk;

    initial 
        begin

        @(posedge clk)  symbol_clk = 1;
        forever #(SYS_CLK_PERIOD/2) symbol_clk=~symbol_clk;
        end
    initial
     begin
        clk = 0;                     // Initialize clock signal
        rst=1;
        #10;
        rst=0;
        mode = 3'b01;               // Set mode input to 0 (Mode 0)
        switch_clk_cycles = (SYS_CLK_PERIOD/CLK_PERIOD); 
        DS1 = 32'hA5A5A5A5;          // Assign value to DS1
        DS2 = 32'habababab;          // Assign value to DS2
        DS3 = 32'hF0F0F0F0;          // Assign value to DS3
        #65;
        @(posedge symbol_clk);
        DS1 = 32'h11111111;          // Assign value to DS1
        DS2 = 32'h22222222;          // Assign value to DS2
        DS3 = 32'h33333333;         // Assign value to DS3
        #80;                       
         mode = 3'b010;             // Set mode input to 1 (Mode 1)
        @(posedge symbol_clk);
         
        switch_clk_cycles = (SYS_CLK_PERIOD/CLK_PERIOD)/2; 
        DS1 = 32'hA5A5A5A5;          // Assign value to DS1
        DS2 = 32'habababab;          // Assign value to DS2
        DS3 = 32'hF0F0F0F0;          // Assign value to DS3

        @(posedge symbol_clk);
        DS1 = 32'h11111111;          // Assign value to DS1
        DS2 = 32'h22222222;          // Assign value to DS2
        DS3 = 32'h33333333;         // Assign value to DS3
        #150;mode = 3'b011;                      
        @(posedge symbol_clk);
        
        switch_clk_cycles = (SYS_CLK_PERIOD/CLK_PERIOD)/3; 
        DS1 = 32'hA5A5A5A5;          // Assign value to DS1
        DS2 = 32'habababab;          // Assign value to DS2
        DS3 = 32'hF0F0F0F0;          // Assign value to DS3
        
        @(posedge symbol_clk);
        DS1 = 32'h11111111;          // Assign value to DS1
        DS2 = 32'h22222222;          // Assign value to DS2
        DS3 = 32'h33333333;         // Assign value to DS3
        #500;
        $finish;                     // Finish the simulation
    end
endmodule
