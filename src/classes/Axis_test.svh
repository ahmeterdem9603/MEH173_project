class Axis_test;
    virtual tb_ifc v_io;
    //import project_pkg::*;
    
    function new(virtual tb_ifc v_io);
        this.v_io = v_io;
    endfunction
    

    function test_tuser_signal();
        if(v_io.m_axis_tvalid == 1) begin
            if(v_io.m_axis_tuser == 1) begin
                temp_frame_line = framegen_line;
                tuser_cnt = tuser_cnt + 1;
            end
        end
    endfunction

    function test_tvalid_signal();
        if(v_io.m_axis_tvalid == 1) begin
            tvalid_cnt = tvalid_cnt + 1;
        end
        else begin
            if(tvalid_cnt == WIDTH) begin 
                succeed_line_valid_cnt = succeed_line_valid_cnt + 1;
            end
            tvalid_cnt = 0;
        end
    endfunction

    function video_comparator();
        if(v_io.LV == 1) begin
            compared_in[videoin_ind] = v_io.D_IN;//video_in_data;
            videoin_ind = videoin_ind + 1;
        end
        if(v_io.m_axis_tvalid == 1) begin
            compared_out[streamout_ind] = v_io.m_axis_tdata;
            streamout_ind = streamout_ind + 1;
        end
    endfunction
    
    function test_tlast_signal();
        if(v_io.FV == 1) begin
            if(line_no == 0) begin
                if(v_io.LV == 1) begin
                     if(v_io.m_axis_tlast == 1) begin
                        last_cnt = 0;     
                     end
                     else begin
                        if (last_cnt == WIDTH-1 ) begin
                            //$display("\nValidator test is successful. Value = %d , Line no = %d",last_cnt, line_no);
                            line_no = line_no + 1;
                            last_cnt = 0;
                        end
                        else begin  
                            last_cnt = last_cnt + 1;
                        end
                    end                                
                end
            end
            else begin 
                if (v_io.m_axis_tlast == 1) begin
                    last_cnt = 0;     
                end
                else begin    
                    last_cnt = last_cnt + 1;         
                    if (last_cnt == WIDTH + H_B_Porch + H_F_Porch - 1) begin
                        //$display("\nValidator test is successful. Value = %d , Line no = %d",last_cnt, line_no);
                        line_no = line_no + 1;
                    end
    //                else begin
    //                    last_cnt = last_cnt + 1;
    //                end
                end
            end
        end
    endfunction
    
    task stream_test_run();
        test_tuser_signal();
        test_tvalid_signal();
        video_comparator();
        test_tlast_signal();
    endtask
    

endclass : Axis_test