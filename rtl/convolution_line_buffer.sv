module convolution_line_buffer #(
  parameter BUFFER_DEPTH = -1,
  parameter DATA_WIDTH   = -1
)
(
  input  logic                   clk_i    ,
  input  logic                   aresetn_i,

  input  logic [DATA_WIDTH -1:0] data_i   ,
  input  logic                   valid_i  ,

  output logic [DATA_WIDTH -1:0] conv_data_o [BUFFER_DEPTH -1:0],
  output logic                   ready_o
);

//////////////////////
// Local parameters //
//////////////////////

localparam CNT_WIDTH = $clog2(BUFFER_DEPTH);

////////////////////////
// Local declarations //
////////////////////////

logic                    handshake;
logic                    full;
logic [CNT_WIDTH  - 1:0] fill_counter;
logic [DATA_WIDTH - 1:0] shift_reg;

assign handshake = valid_i && ready_o;

always_ff @(posedge clk_i or negedge aresetn_i)
  if (~aresetn_i)
    fill_counter <= {CNT_WIDTH{1'b0}};
  else if (handshake)
    fill_counter <= fill_counter + CNT_WIDTH'(1);
  else if (full)
    fill_counter <= fill_counter - CNT_WIDTH'(1);

always_ff @(posedge clk_i)
  if (handshake)
    shift_reg[0] <= data_i;

generate
  for (genvar buff_idx = 1; buff_idx < BUFFER_DEPTH; ++buff_idx) begin
    always_ff @(posedge clk_i)
      if (handshake)
        shift_reg[buff_idx] <= shift_reg[buff_idx - CNT_WIDTH'(1)];
  end
endgenerate

assign full        = ~ready_o;
assign ready_o     = ~(fill_counter == (BUFFER_DEPTH - 1));
assign conv_data_o = shift_reg;

endmodule: convolution_line_buffer