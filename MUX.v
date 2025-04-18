/**
* Configurable Multiplexers for Data Routing and Signal Selection in the System
*
* SEL: A 2-bit selector signal that determines which input (IN0 to IN3) is routed to the output.
    00: Selects IN0.
    01: Selects IN1.
    10: Selects IN2.
    11: Selects IN3.
IN0, IN1, IN2, IN3: These are the possible data inputs to the multiplexer. Depending on the value of
                    SEL, one of these signals will be assigned to OUT.
OUT: The data output of the multiplexer. Its value is determined by the selected input (IN0, IN1, IN2, or IN3).
*/
module MUX (IN0, IN1, IN2, IN3, SEL, OUT);
    input  wire [`DATA_BUS_LEN-1:0] IN0;
    input  wire [`DATA_BUS_LEN-1:0] IN1;
    input  wire [`DATA_BUS_LEN-1:0] IN2;
    input  wire [`DATA_BUS_LEN-1:0] IN3;
    input  wire [1:0]  SEL;
    output reg  [`DATA_BUS_LEN-1:0] OUT;

always @(*) begin
    case (SEL)
        2'b00: OUT = IN0;
        2'b01: OUT = IN1;
        2'b10: OUT = IN2;
        2'b11: OUT = IN3;
        default: OUT = `DATA_BUS_LEN'b0; // fallback de siguranță
    endcase
end

endmodule
