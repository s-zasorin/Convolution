module convolution_top #(
  parameter DATA_WIDTH  = -1,
  parameter CONV_HEIGHT = -1,
  parameter CONV_WIDTH  = -1,
  parameter IMAGE_WIDTH = -1
)
(
  // System interface
  input logic clk_i                  ,
  input logic aresetn_i              ,

  // APB interface
  input  logic        s_apb_psel_i   ,
  input  logic        s_apb_penable_i,
  input  logic        s_apb_pwrite_i ,
  input  logic [5 :0] s_apb_paddr_i  ,
  input  logic [31:0] s_apb_pwdata_i ,
  output logic        s_apb_pready_o ,
  output logic [31:0] s_apb_prdata_o ,
  output logic        s_apb_pslverr_o
);

logic rst_n;
reset_sync i_sync_reset
(
  .clk_i    (clk_i    ),
  .aresetn_i(aresetn_i),
  .rstn_o   (rst_n    )
);

// Regblock interface
CSR_CONV_pkg::CSR_CONV__in_t  conv_hwif_in;
CSR_CONV_pkg::CSR_CONV__out_t conv_hwif_out;

CSR_CONV i_regblock (
  .clk          (clk_i          ),
  .rst          (~rst_n         ),

  .s_apb_psel   (s_apb_psel_i   ),
  .s_apb_penable(s_apb_penable_i),
  .s_apb_pwrite (s_apb_pwrite_i ),
  .s_apb_paddr  (s_apb_paddr_i  ),
  .s_apb_pwdata (s_apb_pwdata_i ),
  .s_apb_pready (s_apb_pready_o ),
  .s_apb_prdata (s_apb_prdata_o ),
  .s_apb_pslverr(s_apb_pslverr_o),

  .hwif_in      (conv_hwif_in   ),
  .hwif_out     (conv_hwif_out  )
);

endmodule: convolution_top