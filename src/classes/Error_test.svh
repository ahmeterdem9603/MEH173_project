class Error_test;
    virtual tb_ifc v_io;
    //import project_pkg::*;
    
    function new(virtual tb_ifc v_io);
        this.v_io = v_io;
    endfunction
    
	function err_tuser_test();
		if (tuser_cnt == 1) begin
			if (temp_frame_line == V_B_Porch) begin
				$display("\nAXI-Stream tuser signal test is successful. temp_frame_line = %d, tuser_cnt = %d",temp_frame_line, tuser_cnt);
			end
			else begin 
				$display("\nAXI-Stream tuser signal different location failed. temp_frame_line = %d, tuser_cnt = %d",temp_frame_line, tuser_cnt);
			end
		end
		else begin
			$display("\nAXI-Stream tuser signal number test is failed. temp_frame_line = %d, tuser_cnt = %d",temp_frame_line, tuser_cnt);
		end
	endfunction


	function err_tvalid_test();
		if(succeed_line_valid_cnt == HEIGTH) begin
			$display("\nAXI-Stream tvalid signal test is successful. succeed_line_valid_cnt = %d", succeed_line_valid_cnt);
		end
		else begin
			$display("\nAXI-Stream tvalid signal test is failed. succeed_line_valid_cnt = %d", succeed_line_valid_cnt);
		end
	endfunction

	function err_comparator_test();
		if(videoin_ind == HEIGTH*WIDTH && streamout_ind == HEIGTH*WIDTH) begin
			for (int a=0; a<HEIGTH*WIDTH; a++) begin
				diff_compared = diff_compared + (compared_in[a] - compared_out[a]);
	//            $display("\n%d. diff_compared value = %d", a, diff_compared);     
			end
			
			if(diff_compared == 0) begin
				$display("\nVideo compared test is successful.");
			end
			else begin
				$display("\nVideo compared test is failed. diff_compared value = %d", diff_compared);
			end
		end
	endfunction

	function err_tlast_signal();
		if(line_no == HEIGTH) begin
			err_tlast_flag = 0;
			$display("\nAXI-Stream tlast signal test is successful. tlast line no = %d", line_no);
		end
		else begin
			err_tlast_flag = 1;
			$display("\nAXI-Stream tlast signal test is failed. tlast line no = %d", line_no);
		end
	endfunction
    
    task test_run();
        err_tuser_test();
        err_tvalid_test();
        err_comparator_test();
        err_tlast_signal();
    endtask
   
endclass : Error_test