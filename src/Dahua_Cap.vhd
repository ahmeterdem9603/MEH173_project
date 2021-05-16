----------------------------------------------------------------------------------
-- Company: Asisguard   
-- Engineer: Ahmet Haydar ERDEM
-- 
-- Create Date: 03/18/2021 03:16:12 PM
-- Design Name: 
-- Module Name: dahua_cap - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity dahua_cap is
    Generic(
        WIDTH  : integer := 640;
        HEIGTH : integer := 480
           );  
    Port ( 
        resetn        : in  STD_LOGIC;
        pclk          : in  STD_LOGIC;
        FV            : in  STD_LOGIC;
        LV            : in  STD_LOGIC;
        m_axis_tvalid : out STD_LOGIC;
        m_axis_tready : in  STD_LOGIC;
        m_axis_tdata  : out STD_LOGIC_VECTOR(15 downto 0);
        D_IN          : in  STD_LOGIC_VECTOR(15 downto 0);
        
        m_axis_tuser  : out STD_LOGIC;
        m_aclk        : out STD_LOGIC;
        m_axis_tlast  : out STD_LOGIC 
         );
end dahua_cap;

architecture Behavioral of dahua_cap is

    type state_type is (IDLE, ACTIVE, WAIT_FRAME, WAIT_LINE);
    signal state : state_type;
    
    signal Y_data     : STD_LOGIC_VECTOR(7 downto 0);
    signal U_data     : STD_LOGIC_VECTOR(7 downto 0);
    signal V_data     : STD_LOGIC_VECTOR(7 downto 0);
    signal temp_data  : STD_LOGIC_VECTOR(15 downto 0);
    signal line_count : STD_LOGIC_VECTOR(15 downto 0);
    signal pix_count  : STD_LOGIC_VECTOR(15 downto 0);  
    signal active_vid : STD_LOGIC; 
    signal temp_clk   : STD_LOGIC;
    
begin

    temp_data       <= D_IN;
    m_axis_tdata    <= temp_data;
    m_axis_tvalid   <= active_vid;   
    temp_clk        <= pclk;
    m_aclk          <= temp_clk;

    process(pclk) is
    begin
		if (resetn = '0') then
            state <= IDLE;

        elsif rising_edge(pclk) then 
            if m_axis_tready = '1' then
                case (state) is
                    when IDLE =>
                        if resetn = '1' then
                            state <= WAIT_FRAME;
                        else
                            state <= IDLE;
                            line_count <= (others => '0');
                            pix_count  <= (others => '0');
                            active_vid <= '0';
                        end if;
                
                    when WAIT_FRAME =>                       
                        if FV = '0' and LV = '0' then
                            state <= ACTIVE;
                            --reset all signal values
                            line_count <= (others => '0');
                            pix_count  <= (others => '0');
                            active_vid <= '0';
                        else
                            state <= WAIT_FRAME;
                        end if;
             
                    when ACTIVE =>                   
                        if FV = '1' and LV = '1' then 
                            state <= ACTIVE;
                            active_vid <= '1';
                    
                            if unsigned(line_count) = 0 then
                                m_axis_tuser <= '1';
                            else
                                m_axis_tuser <= '0';
                            end if;
                    
                        elsif FV = '1' and LV = '0' then  

                        else
                            state <= ACTIVE;
                            active_vid <= '0';
                        end if;
                
                    when WAIT_LINE =>                                       
                        if FV = '0' and LV = '0' then
                            state <= WAIT_FRAME;
                            pix_count <= (others => '0');
                        elsif FV = '1' and LV = '0' then
                            state <= WAIT_LINE;
                            pix_count <= (others => '0');
                        else 
                            state <= ACTIVE;
                        end if;
                
                    when others =>
                        state <= IDLE;
                end case;  
          
                if active_vid = '1' then
                    m_axis_tuser <= '0';
            
                    if unsigned(pix_count) < WIDTH-1 then
                        pix_count <= STD_LOGIC_VECTOR(unsigned(pix_count) + 1);
                    else
                        pix_count <= (others => '0');
                    end if;
            
                    if unsigned(pix_count) = WIDTH-1 then
                        line_count <= STD_LOGIC_VECTOR(unsigned(line_count) + 1);  
                        state <= WAIT_LINE;
                        pix_count  <= (others => '0');
                        active_vid <= '0';
                    end if;         
                            
                    if unsigned(pix_count) = WIDTH - 2 then
                        m_axis_tlast <= '1';
                    else
                        m_axis_tlast <= '0';     
                    end if;
                end if;  
            else
                m_axis_tlast <= '0'; 
                m_axis_tuser <= '0'; 
                active_vid <= '0';
                state <= WAIT_FRAME;    
            end if;
            

           
        end if;  
    end process;
end Behavioral;
