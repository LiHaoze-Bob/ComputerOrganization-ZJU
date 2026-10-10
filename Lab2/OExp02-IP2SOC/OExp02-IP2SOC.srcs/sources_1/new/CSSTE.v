module CSSTE(
    input wire clk_100mhz,
    input wire RSTN,
    input wire [3:0] BTN_y,
    input wire [15:0] SW,
    output wire [15:0] LED_out,
    output wire [7:0] AN,
    output wire [7:0] segment,
    output wire [3:0] Blue,
    output wire [3:0] Green,
    output wire [3:0] Red,
    output wire HSYNC,
    output wire VSYNC
);

    wire rst;
    wire Clk_CPU;
    wire clk_io;
    wire [31:0] clkdiv;
    wire [3:0] BTN_OK;
    wire [15:0] SW_OK;

    wire [31:0] PC_out;
    wire [31:0] Inst_in;
    wire [31:0] Addr_out;
    wire [31:0] Data_out;
    wire [31:0] Data_in;
    wire MemRW;

    wire [9:0] ram_addr;
    wire [31:0] ram_data_in;
    wire [31:0] ram_data_out;
    wire data_ram_we;

    wire GPIOf0000000_we;
    wire GPIOe0000000_we;
    wire counter_we;
    wire [31:0] Peripheral_in;

    wire [1:0] counter_set;
    wire [31:0] counter_out;
    wire counter0_out;
    wire counter1_out;
    wire counter2_out;

    wire [31:0] Disp_num;
    wire [7:0] point_out;
    wire [7:0] LE_out;

    assign clk_io = ~Clk_CPU;

    SCPU U1(
        .clk(Clk_CPU),
        .rst(rst),
        .MIO_ready(1'b0),
        .inst_in(Inst_in),
        .Data_in(Data_in),
        .CPU_MIO(),
        .MemRW(MemRW),
        .PC_out(PC_out),
        .Data_out(Data_out),
        .Addr_out(Addr_out)
    );

    ROM_D U2(
        .a(PC_out[11:2]),
        .spo(Inst_in)
    );

    RAM_B U3(
        .clka(~clk_100mhz),
        .wea(data_ram_we),
        .addra(ram_addr),
        .dina(ram_data_in),
        .douta(ram_data_out)
    );

    MIO_BUS U4(
        .clk(clk_100mhz),
        .rst(rst),
        .BTN(BTN_OK),
        .SW(SW_OK),
        .mem_w(MemRW),
        .Cpu_data2bus(Data_out),
        .addr_bus(Addr_out),
        .ram_data_out(ram_data_out),
        .led_out(LED_out),
        .counter_out(counter_out),
        .counter0_out(counter0_out),
        .counter1_out(counter1_out),
        .counter2_out(counter2_out),
        .Cpu_data4bus(Data_in),
        .ram_data_in(ram_data_in),
        .ram_addr(ram_addr),
        .data_ram_we(data_ram_we),
        .GPIOf0000000_we(GPIOf0000000_we),
        .GPIOe0000000_we(GPIOe0000000_we),
        .counter_we(counter_we),
        .Peripheral_in(Peripheral_in)
    );

    Multi_8CH32 U5(
        .clk(clk_io),
        .rst(rst),
        .EN(GPIOe0000000_we),
        .Test(SW_OK[7:5]),
        .point_in(64'b0),
        .LES(64'b0),
        .Data0(Peripheral_in),
        .data1({2'b00, PC_out[31:2]}),
        .data2(Inst_in),
        .data3(counter_out),
        .data4(Addr_out),
        .data5(Data_out),
        .data6(Data_in),
        .data7(PC_out),
        .point_out(point_out),
        .LE_out(LE_out),
        .Disp_num(Disp_num)
    );

    Seg7_Dev_0 U6(
        .disp_num(Disp_num),
        .point(point_out),
        .les(LE_out),
        .scan(clkdiv[18:16]),
        .AN(AN),
        .segment(segment)
    );

    SPIO U7(
        .clk(clk_io),
        .rst(rst),
        .Start(clkdiv[20]),
        .EN(GPIOf0000000_we),
        .P_Data(Peripheral_in),
        .counter_set(counter_set),
        .LED_out(LED_out),
        .led_clk(),
        .led_sout(),
        .led_clrn(),
        .LED_PEN(),
        .GPIOf0()
    );

    clk_div U8(
        .clk(clk_100mhz),
        .rst(rst),
        .SW2(SW_OK[2]),
        .SW8(SW_OK[8]),
        .STEP(SW_OK[10]),
        .clkdiv(clkdiv),
        .Clk_CPU(Clk_CPU)
    );

    SAnti_jitter U9(
        .clk(clk_100mhz),
        .RSTN(RSTN),
        .readn(1'b0),
        .Key_y(BTN_y),
        .Key_x(),
        .SW(SW),
        .Key_out(),
        .Key_ready(),
        .pulse_out(),
        .BTN_OK(BTN_OK),
        .SW_OK(SW_OK),
        .CR(),
        .rst(rst)
    );

    Counter_x U10(
        .clk(clk_io),
        .rst(rst),
        .clk0(clkdiv[6]),
        .clk1(clkdiv[9]),
        .clk2(clkdiv[11]),
        .counter_we(counter_we),
        .counter_val(Peripheral_in),
        .counter_ch(counter_set),
        .counter0_OUT(counter0_out),
        .counter1_OUT(counter1_out),
        .counter2_OUT(counter2_out),
        .counter_out(counter_out)
    );

    VGA U11(
        .clk_25m(clkdiv[1]),
        .clk_100m(clk_100mhz),
        .rst(rst),
        .pc(PC_out),
        .inst(Inst_in),
        .alu_res(Addr_out),
        .mem_wen(MemRW),
        .dmem_o_data(ram_data_out),
        .dmem_i_data(ram_data_in),
        .dmem_addr(Addr_out),
        .hs(HSYNC),
        .vs(VSYNC),
        .vga_r(Red),
        .vga_g(Green),
        .vga_b(Blue)
    );

endmodule