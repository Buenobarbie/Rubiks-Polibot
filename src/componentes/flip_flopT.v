module flip_flopT (
    input clk, 
    input clear, 
    input t, 
    output reg q
); 

    always @ (posedge clk) begin 
      if (clear)
        q <= 1'b0;
      
        if(t)else
          q <= ~q; 
        else 
          q <= q; 
    end 
endmodule