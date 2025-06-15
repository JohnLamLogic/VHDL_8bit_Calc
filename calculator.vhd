library ieee; 
use ieee.std_logic_1164.all; 
 
entity calculator is 
    port( 
        Din: in std_logic_vector(7 downto 0);     
        clk: in std_logic;                       
        load: in std_logic_vector(1 downto 0);   
        op: in std_logic_vector(3 downto 0);    
        res: out std_logic_vector(7 downto 0);   
        ov: out std_logic;                      
        segmentSeven_L: out std_logic_vector(6 downto 0);  
        segmentSeven_U: out std_logic_vector(6 downto 0)   
    ); 
end entity calculator; 
 
architecture arch8 of calculator is 
 
    -- Internal Signals for Operand Storage 
    signal internal_X, internal_Y: std_logic_vector(7 downto 0);   
    signal calc_result: std_logic_vector(7 downto 0);   
 
    component register8 
        port( 
            Inp: in std_logic_vector(7 downto 0);  
            clk: in std_logic; 
            load: in std_logic;  
            Outp: out std_logic_vector(7 downto 0) 
        ); 
    end component; 
 
    component calcprocessing 
        port( 
            X, Y: in std_logic_vector(7 downto 0); 
            opcode: in std_logic_vector(3 downto 0); 
            overflow: out std_logic; 
            result: out std_logic_vector(7 downto 0) 
        ); 
    end component; 
 
    component Display 
        port( 
            Input: in std_logic_vector(3 downto 0);  
            segmentSeven: out std_logic_vector(6 downto 0)  
        ); 
    end component; 
 
begin 
    -- Hardcoded Register X to 6 
    regX: register8 
        port map( 
            Inp => "00000110",  
            clk => clk, 
            load => '1',       
            Outp => internal_X 
        ); 
 
    -- Hardcoded Register Y to 5 
    regY: register8 
        port map( 
            Inp => "00000101",  
            clk => clk, 
            load => '1',       
            Outp => internal_Y 
        ); 
 
    -- Calculation Processing 
    calc_inst: calcprocessing 
        port map( 
            X => internal_X,    
            Y => internal_Y,   
            opcode => op,       
            overflow => ov,     
            result => calc_result  
        ); 
 
    -- Assign result to output 
    res <= calc_result; 
 
    -- Lower 4 Bits 
    display_L: Display 
        port map( 
            Input => calc_result(3 downto 0), 
            segmentSeven => segmentSeven_L 
        ); 
 
    -- Upper 4 bits 
    display_U: Display 
        port map( 
            Input => calc_result(7 downto 4), 
            segmentSeven => segmentSeven_U 
        ); 
 
end architecture arch8; 
