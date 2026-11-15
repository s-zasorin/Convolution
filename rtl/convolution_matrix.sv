module convolution_matrix #(
  parameter  CONV_WIDTH  = -1,
  parameter  CONV_HEIGHT = -1,
  parameter  DATA_WIDTH  = -1,
  localparam MULT_WIDTH  = (DATA_WIDTH << 1)
)
(
  input  logic                    clk_i    ,
  input  logic                    aresetn_i,

  input  logic [DATA_WIDTH  -1:0] data_i [CONV_HEIGHT -1:0],
  input  logic [CONV_HEIGHT -1:0] valid_i                  ,

  output logic [MULT_WIDTH  -1:0] data_o
);

////////////////////////
// Local declarations //
////////////////////////

logic [DATA_WIDTH  -1:0] line_buffer_data [CONV_WIDTH -1:0][CONV_HEIGHT -1:0];
logic [MULT_WIDTH  -1:0] mult_data        [CONV_WIDTH -1:0][CONV_HEIGHT -1:0];
logic [CONV_HEIGHT -1:0] line_ready;

generate
  for (genvar height_idx = 0; height_idx < CONV_HEIGHT; ++height_idx) begin
    for (genvar width_idx = 0; width_idx < CONV_WIDTH; ++width_idx) begin
      convolution_node #(
        .DATA_WIDTH()
      ) i_conv_node (
        .clk_i      (clk_i),
        .pixel_i    (line_buffer_data[height_idx][width_idx]),
        .pixel_en_i (line_ready),

        .weight_i   (),
        .weight_en_i(),

        .mult_o     (mult_data[height_idx][width_idx])
      );
    end
  end
endgenerate

generate
  for (genvar height_idx = 0; height_idx < CONV_HEIGHT; ++heoght_idx) begin
    convolution_line_buffer #(
      .BUFFER_DEPTH (CONV_WIDTH),
      .DATA_WIDTH   (DATA_WIDTH)
    ) (
      .clk_i      (clk_i                       ),
      .aresetn_i  (aresetn_i                   ),

      .data_i     (data_i          [height_idx]),
      .valid_i    (valid_i         [height_idx]),

      .conv_data_o(line_buffer_data[height_idx]),
      .ready_o    (line_ready      [height_idx])
    )
  end
endgenerate
endmodule: convolution_matrix