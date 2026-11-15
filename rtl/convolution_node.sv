module convolution_node #(
  parameter  DATA_WIDTH = -1,
  localparam MULT_WIDTH = (DATA_WIDTH << 1)
)
(
  input  logic                    clk_i      ,

  input  logic [DATA_WIDTH - 1:0] pixel_i    ,
  input  logic                    pixel_en_i ,

  input  logic [DATA_WIDTH - 1:0] weight_i   ,
  input  logic                    weight_en_i,

  output logic [MULT_WIDTH - 1:0] mult_o
);

  ////////////////////////
  // Local declarations //
  ////////////////////////

  logic [DATA_WIDTH - 1:0] weight_ff;
  logic [DATA_WIDTH - 1:0] pixel_ff;

  always_ff @(posedge clk_i)
    if (weight_en_i)
      weight_ff <= weight_i;

  always_ff @(posedge clk_i)
    if (pixel_en_i)
      pixel_ff <= pixel_i;

  assign mult_o = weight_ff * pixel_ff;

endmodule: convolution_node