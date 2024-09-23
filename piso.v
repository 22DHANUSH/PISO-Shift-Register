module piso (
    input wire clk,
    input wire g_rst,
    input wire enable,
    input wire [31:0] par_ser_data,
    output reg tx_serial_out
);

// Intermediate Signal Declarations
reg tx_success;
reg [1:0] state;
reg [31:0] temp_data;
reg [5:0] count;  // 6-bit count

// Parameter Declarations
parameter [1:0] idle = 2'd0,
                load = 2'd1,
                slz  = 2'd2,
                slz_comp = 2'd3;

// Always block to determine next state
always @(posedge clk, posedge g_rst)
begin
    if (g_rst)
        state <= idle;
    else
    begin
        case (state)
          idle:
            begin
                if (enable)
                    state <= load;
                else
                    state <= idle;
            end

          load:
            begin
                state <= slz;
            end

          slz:
            begin
                if (count < 32)
                    state <= slz;
                else
                    state <= slz_comp;
            end
          
          slz_comp:
            begin
                if (tx_success)
                    state <= idle;
                else
                    state <= slz_comp;
            end

          default:
            begin
                state <= idle;
            end
        endcase
    end
end

// Block to determine output
always @(posedge clk, posedge g_rst)
begin
    if (g_rst)
    begin
        temp_data <= 32'd0;
        tx_serial_out <= 1'b0;
        count <= 6'd0;  // Reset count to 6 bits
        tx_success <= 1'b0;
    end
    else
    begin
        case (state)

          idle: 
            begin
                if (enable) 
                begin
                    temp_data <= 32'd0;
                    tx_serial_out <= 1'b0;
                    count <= 6'd0;
                    tx_success <= 1'b0;
                end
            end

          load: 
            begin
                temp_data <= par_ser_data;
                tx_serial_out <= 1'b0;
                tx_success <= 1'b0;
            end

          slz: 
            begin
                if (count < 32) 
                begin
                    tx_serial_out <= temp_data[31];
                    temp_data <= {temp_data[30:0], 1'b0};
                    count <= count + 6'd1;
                    $display("%d", count);
                    tx_success <= 1'b0;
                end
                else 
                begin
                    temp_data <= 32'd0;
                    tx_serial_out <= 1'b0;
                    count <= 6'd0;
                    tx_success <= 1'b0;
                end
            end

          slz_comp: 
            begin
                tx_serial_out <= 1'b0;  // Set to 0 instead of 'X'
                temp_data <= 32'd0;
                count <= 5'd0;
                tx_success <= 1'b1;
            end
        endcase
    end
end
endmodule
