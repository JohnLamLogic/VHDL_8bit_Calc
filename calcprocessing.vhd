library ieee; 
use ieee.std_logic_1164.all; 
use ieee.std_logic_signed.all; 
 
entity calcprocessing is 
    port( 
        X, Y: in std_logic_vector(7 downto 0); 
        opcode: in std_logic_vector(3 downto 0); 
        overflow: out std_logic; 
        result: out std_logic_vector(7 downto 0) 
    ); 
end calcprocessing; 
 
architecture behav of calcprocessing is 
 
    -- Internal Signals 
    signal negX: std_logic_vector(7 downto 0); 
    signal temp_result_add, temp_result_sub, temp_result_dec: std_logic_vector(7 downto 0); 
    signal carry_out_add, carry_out_sub, carry_out_dec: std_logic; 
 
    -- Component Declarations 
    component adder8 
        port( 
            A, B: in std_logic_vector(7 downto 0); 
            Cin: in std_logic; 
            S: out std_logic_vector(7 downto 0); 
            Co: out std_logic 
        ); 
    end component; 
 
begin 
 
    -- Invert X to create -X (two's complement) 
    invX: entity work.inverter port map(A => X, Y => negX); 
 
    -- Component Instantiations 
    addXY: adder8 port map(A => X, B => Y, Cin => '0', S => temp_result_add, Co => carry_out_add); 
    addYNegX: adder8 port map(A => Y, B => negX, Cin => '1', S => temp_result_sub, Co => carry_out_sub); 
    addYNeg1: adder8 port map(A => Y, B => "11111111", Cin => '0', S => temp_result_dec, Co => carry_out_dec); -- -1 in two's complement 
 
    -- Process to Select the Correct Output 
    process (X, Y, opcode, temp_result_add, temp_result_sub, temp_result_dec) 
    begin 
        -- Default values to prevent latches 
        overflow <= '0'; 
        result <= (others => '0'); 
 
        case opcode is 
            when "0011" =>  -- X + Y 
                result <= temp_result_add; 
                overflow <= (X(7) and Y(7) and not temp_result_add(7)) or 
                            (not X(7) and not Y(7) and temp_result_add(7)); 
 
            when "1000" =>  -- Y - X (Y + (-X)) 
                result <= temp_result_sub; 
                overflow <= (Y(7) and not X(7) and not temp_result_sub(7)) or 
                            (not Y(7) and X(7) and temp_result_sub(7)); 
 
            when "1001" =>  -- Y - 1 (Y + (-1)) 
                result <= temp_result_dec; 
                --overflow logic can be added here if needed 
 
            when others => 
                result <= (others => '0'); 
                overflow <= '0'; 
        end case; 
    end process; 
 
end behav; 
