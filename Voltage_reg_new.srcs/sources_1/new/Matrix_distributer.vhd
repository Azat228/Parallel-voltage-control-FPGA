library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Matrix_Distributor is
    Generic (
        -- AXI�ӿڵĲ���
        C_S_AXI_DATA_WIDTH    : integer := 32;
        C_S_AXI_ADDR_WIDTH    : integer := 12;  -- ֧�����10������ÿ��10x10��ÿ��Ԫ��8λ
        
        -- �������ò���
        MATRIX_SIZE           : integer := 10;
        NUM_ROWS              : integer :=1;
        MAX_MATRICES          : integer := 10;
        BITS_PER_ELEMENT      : integer := 8
    );
    Port (
        -- ϵͳʱ�Ӻ͸�λ�ź�
        sys_clk               : in  STD_LOGIC;
        sys_rst_n             : in  STD_LOGIC;
        
        -- AXI Lite�ӿ�
        s_axi_aclk            : in  STD_LOGIC;
        s_axi_aresetn         : in  STD_LOGIC;
        
        -- д��ַͨ��
        s_axi_awaddr          : in  STD_LOGIC_VECTOR(C_S_AXI_ADDR_WIDTH-1 downto 0);
        s_axi_awprot          : in  STD_LOGIC_VECTOR(2 downto 0);
        s_axi_awvalid         : in  STD_LOGIC;
        s_axi_awready         : out STD_LOGIC;
        
        -- д����ͨ��
        s_axi_wdata           : in  STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH-1 downto 0);
        s_axi_wstrb           : in  STD_LOGIC_VECTOR((C_S_AXI_DATA_WIDTH/8)-1 downto 0);
        s_axi_wvalid          : in  STD_LOGIC;
        s_axi_wready          : out STD_LOGIC;
        
        -- д��Ӧͨ��
        s_axi_bresp           : out STD_LOGIC_VECTOR(1 downto 0);
        s_axi_bvalid          : out STD_LOGIC;
        s_axi_bready          : in  STD_LOGIC;
        
        -- ����ַͨ��
        s_axi_araddr          : in  STD_LOGIC_VECTOR(C_S_AXI_ADDR_WIDTH-1 downto 0);
        s_axi_arprot          : in  STD_LOGIC_VECTOR(2 downto 0);
        s_axi_arvalid         : in  STD_LOGIC;
        s_axi_arready         : out STD_LOGIC;
        
        -- ������ͨ��
        s_axi_rdata           : out STD_LOGIC_VECTOR(C_S_AXI_DATA_WIDTH-1 downto 0);
        s_axi_rresp           : out STD_LOGIC_VECTOR(1 downto 0);
        s_axi_rvalid          : out STD_LOGIC;
        s_axi_rready          : in  STD_LOGIC;
        
        -- PMOD�˿ڣ���������������ݣ���������
        pmod_out_0 : out STD_LOGIC;
        pmod_out_1 : out STD_LOGIC;
        pmod_out_2 : out STD_LOGIC;
        pmod_out_3 : out STD_LOGIC;
        pmod_out_4 : out STD_LOGIC;
        pmod_out_5 : out STD_LOGIC;
        pmod_out_6 : out STD_LOGIC;
        pmod_out_7 : out STD_LOGIC;
        pmod_out_8 : out STD_LOGIC;
        pmod_out_9 : out STD_LOGIC
    );
end Matrix_Distributor;

architecture Behavioral of Matrix_Distributor is
    -- ��������
    constant AXI_RESP_OK      : std_logic_vector(1 downto 0) := "00";
    constant AXI_RESP_ERROR   : std_logic_vector(1 downto 0) := "10";
    
    -- ���Ͷ��� - ʹ��BRAM�Ѻõĵ�ά����ʵ�־���
    type matrix_t is array (0 to MATRIX_SIZE*MATRIX_SIZE-1) of integer range 0 to 255;
    type matrix_array_t is array (0 to MAX_MATRICES-1) of matrix_t;
    
    -- �������ݴ洢
    signal matrix_decimal : matrix_array_t := (others => (others => 0));
    signal matrix_count : integer range 0 to MAX_MATRICES := 0;
    
    -- ״̬������
    type state_t is (IDLE, DISTRIBUTE);
    signal state : state_t := IDLE;
    
    -- ������������ź�
    signal matrix_output_enable : std_logic := '0';
    signal current_row : integer range 0 to NUM_ROWS-1 := 0;
    signal current_col : integer range 0 to MATRIX_SIZE-1 := 0;
    signal current_bit : integer range 0 to BITS_PER_ELEMENT-1 := 0;
    
    -- ��������ź� - ÿ������һλ
    signal serial_out : std_logic_vector(MAX_MATRICES-1 downto 0) := (others => '0');
    
    -- AXI�����ź�
    signal axi_awready : std_logic := '0';
    signal axi_wready  : std_logic := '0';
    signal axi_bvalid  : std_logic := '0';
    signal axi_arready : std_logic := '0';
    signal axi_rvalid  : std_logic := '0';
    signal axi_rdata   : std_logic_vector(C_S_AXI_DATA_WIDTH-1 downto 0) := (others => '0');
    signal axi_bresp   : std_logic_vector(1 downto 0) := AXI_RESP_OK;
    signal axi_rresp   : std_logic_vector(1 downto 0) := AXI_RESP_OK;
    
    -- ��ַ�����ź�
    signal axi_awaddr_reg : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    signal axi_araddr_reg : std_logic_vector(C_S_AXI_ADDR_WIDTH-1 downto 0);
    
    -- ���ƼĴ��� (0x00)
    signal ctrl_reg : std_logic_vector(31 downto 0) := (others => '0');
    -- ״̬�Ĵ��� (0x04)
    signal status_reg : std_logic_vector(31 downto 0) := (others => '0');
    
begin
    -- AXI�ӿ��������
    s_axi_awready <= axi_awready;
    s_axi_wready  <= axi_wready;
    s_axi_bresp   <= axi_bresp;
    s_axi_bvalid  <= axi_bvalid;
    s_axi_arready <= axi_arready;
    s_axi_rdata   <= axi_rdata;
    s_axi_rresp   <= axi_rresp;
    s_axi_rvalid  <= axi_rvalid;
    
    -- �������ֱ��ӳ�䵽PMOD�˿�
    pmod_out_0 <= serial_out(0);
    pmod_out_1 <= serial_out(1);
    pmod_out_2 <= serial_out(2);
    pmod_out_3 <= serial_out(3);
    pmod_out_4 <= serial_out(4);
    pmod_out_5 <= serial_out(5);
    pmod_out_6 <= serial_out(6);
    pmod_out_7 <= serial_out(7);
    pmod_out_8 <= serial_out(8);
    pmod_out_9 <= serial_out(9);
    
    -- д��ַͨ������
    process(s_axi_aclk)
    begin
        if rising_edge(s_axi_aclk) then
            if s_axi_aresetn = '0' then
                axi_awready <= '0';
                axi_awaddr_reg <= (others => '0');
            else
                if (axi_awready = '0' and s_axi_awvalid = '1' and s_axi_wvalid = '1' and axi_bvalid = '0') then
                    axi_awready <= '1';
                    axi_awaddr_reg <= s_axi_awaddr;
                else
                    axi_awready <= '0';
                end if;
            end if;
        end if;
    end process;
    
    -- д����ͨ������
    process(s_axi_aclk)
        variable matrix_idx : integer;
        variable row_idx : integer;
        variable col_idx : integer;
        variable index : integer;
        variable addr_offset : integer;
    begin
        if rising_edge(s_axi_aclk) then
            if s_axi_aresetn = '0' then
                axi_wready <= '0';
                axi_bvalid <= '0';
                axi_bresp <= AXI_RESP_OK;
                matrix_count <= 0;
                ctrl_reg <= (others => '0');
                
                -- ��ʼ������Ϊȫ0
                for i in 0 to MAX_MATRICES-1 loop
                    for idx in 0 to MATRIX_SIZE*NUM_ROWS-1 loop
                        matrix_decimal(i)(idx) <= 0;
                    end loop;
                end loop;
            else
                -- ����д�������Ӧ
                if (axi_bvalid = '1' and s_axi_bready = '1') then
                    axi_bvalid <= '0';
                end if;
                
                -- ��������д��
                if (axi_wready = '0' and s_axi_wvalid = '1' and s_axi_awvalid = '1' and axi_awready = '0' and axi_bvalid = '0') then
                    axi_wready <= '1';
                    
                    -- �����ַ����
                    addr_offset := to_integer(unsigned(s_axi_awaddr(11 downto 2)));
                    
                    -- ����ǿ��ƼĴ������Ǿ������ݵ�ַ
                    if addr_offset = 0 then
                        -- ���ƼĴ��� (0x00)
                        if s_axi_wstrb(0) = '1' then
                            ctrl_reg(7 downto 0) <= s_axi_wdata(7 downto 0);
                        end if;
                        if s_axi_wstrb(1) = '1' then
                            ctrl_reg(15 downto 8) <= s_axi_wdata(15 downto 8);
                        end if;
                        if s_axi_wstrb(2) = '1' then
                            ctrl_reg(23 downto 16) <= s_axi_wdata(23 downto 16);
                        end if;
                        if s_axi_wstrb(3) = '1' then
                            ctrl_reg(31 downto 24) <= s_axi_wdata(31 downto 24);
                        end if;
                    elsif addr_offset = 1 then
                        -- ״̬�Ĵ�����ֻ���ģ�����д��
                        null;
                    else
                        -- �������ݵ�ַ
                        -- ��������������к���
                        matrix_idx := to_integer(unsigned(s_axi_awaddr(11 downto 7))); -- 5λ���ھ������� (0-31)
                        row_idx := to_integer(unsigned(s_axi_awaddr(6 downto 4)));    -- 3λ���������� (0-7)
                        col_idx := to_integer(unsigned(s_axi_awaddr(3 downto 2)));    -- 2λ���������� (0-3)
                        
                        -- д��������ݣ�ÿ���Ĵ������Դ洢���4������Ԫ�أ�
                        if matrix_idx < MAX_MATRICES and row_idx < NUM_ROWS and col_idx*4 < MATRIX_SIZE then
                            if s_axi_wstrb(0) = '1' and col_idx*4 < MATRIX_SIZE then
                                index := row_idx * MATRIX_SIZE + col_idx*4;
                                matrix_decimal(matrix_idx)(index) <= 
                                    to_integer(unsigned(s_axi_wdata(7 downto 0)));
                            end if;
                            
                            if s_axi_wstrb(1) = '1' and col_idx*4+1 < MATRIX_SIZE then
                                index := row_idx * MATRIX_SIZE + col_idx*4+1;
                                matrix_decimal(matrix_idx)(index) <= 
                                    to_integer(unsigned(s_axi_wdata(15 downto 8)));
                            end if;
                            
                            if s_axi_wstrb(2) = '1' and col_idx*4+2 < MATRIX_SIZE then
                                index := row_idx * MATRIX_SIZE + col_idx*4+2;
                                matrix_decimal(matrix_idx)(index) <= 
                                    to_integer(unsigned(s_axi_wdata(23 downto 16)));
                            end if;
                            
                            if s_axi_wstrb(3) = '1' and col_idx*4+3 < MATRIX_SIZE then
                                index := row_idx * MATRIX_SIZE + col_idx*4+3;
                                matrix_decimal(matrix_idx)(index) <= 
                                    to_integer(unsigned(s_axi_wdata(31 downto 24)));
                            end if;
                            
                            -- ���¾������
                            if matrix_idx >= matrix_count then
                                matrix_count <= matrix_idx + 1;
                            end if;
                        end if;
                    end if;
                    
                    -- Ϊ��һ��д����׼��
                    axi_bresp <= AXI_RESP_OK;
                    axi_bvalid <= '1';
                else
                    axi_wready <= '0';
                end if;
            end if;
        end if;
    end process;
    
    -- ����ַͨ������
    process(s_axi_aclk)
    begin
        if rising_edge(s_axi_aclk) then
            if s_axi_aresetn = '0' then
                axi_arready <= '0';
                axi_araddr_reg <= (others => '0');
            else
                if (axi_arready = '0' and s_axi_arvalid = '1' and axi_rvalid = '0') then
                    axi_arready <= '1';
                    axi_araddr_reg <= s_axi_araddr;
                else
                    axi_arready <= '0';
                end if;
            end if;
        end if;
    end process;
    
    -- ������ͨ������
    process(s_axi_aclk)
        variable matrix_idx : integer;
        variable row_idx : integer;
        variable col_idx : integer;
        variable index : integer;
        variable addr_offset : integer;
    begin
        if rising_edge(s_axi_aclk) then
            if s_axi_aresetn = '0' then
                axi_rvalid <= '0';
                axi_rdata <= (others => '0');
                axi_rresp <= AXI_RESP_OK;
            else
                if (axi_rvalid = '1' and s_axi_rready = '1') then
                    axi_rvalid <= '0';
                end if;
                
                if (axi_arready = '1' and s_axi_arvalid = '1' and axi_rvalid = '0') then
                    -- �����ַƫ��
                    addr_offset := to_integer(unsigned(axi_araddr_reg(11 downto 2)));
                    
                    -- ����ǿ��ƼĴ������Ǿ������ݵ�ַ
                    if addr_offset = 0 then
                        -- ���ƼĴ��� (0x00)
                        axi_rdata <= ctrl_reg;
                    elsif addr_offset = 1 then
                        -- ״̬�Ĵ��� (0x04)
                        -- ״̬�Ĵ�������:
                        -- [31:24] ����
                        -- [23:16] ��ǰ״̬ (0-IDLE, 1-DISTRIBUTE)
                        -- [15:8]  ��ǰ��
                        -- [7:0]   ��ǰ��
                        axi_rdata <= (others => '0');
                        case state is
                            when IDLE => axi_rdata(23 downto 16) <= x"00";
                            when DISTRIBUTE => axi_rdata(23 downto 16) <= x"02";
                            when others => axi_rdata(23 downto 16) <= x"FF";
                        end case;
                        axi_rdata(15 downto 8) <= std_logic_vector(to_unsigned(current_row, 8));
                        axi_rdata(7 downto 0) <= std_logic_vector(to_unsigned(current_col, 8));
                    else
                        -- �������ݵ�ַ
                        matrix_idx := to_integer(unsigned(axi_araddr_reg(11 downto 7))); -- 5λ���ھ�������
                        row_idx := to_integer(unsigned(axi_araddr_reg(6 downto 4)));    -- 3λ����������
                        col_idx := to_integer(unsigned(axi_araddr_reg(3 downto 2)));    -- 2λ����������
                        
                        axi_rdata <= (others => '0');
                        
                        -- ��ȡ��������
                        if matrix_idx < MAX_MATRICES and row_idx < NUM_ROWS then
                            if col_idx*4 < MATRIX_SIZE then
                                index := row_idx * MATRIX_SIZE + col_idx*4;
                                axi_rdata(7 downto 0) <= std_logic_vector(to_unsigned(
                                    matrix_decimal(matrix_idx)(index), 8));
                            end if;
                            
                            if col_idx*4+1 < MATRIX_SIZE then
                                index := row_idx * MATRIX_SIZE + col_idx*4+1;
                                axi_rdata(15 downto 8) <= std_logic_vector(to_unsigned(
                                    matrix_decimal(matrix_idx)(index), 8));
                            end if;
                            
                            if col_idx*4+2 < MATRIX_SIZE then
                                index := row_idx * MATRIX_SIZE + col_idx*4+2;
                                axi_rdata(23 downto 16) <= std_logic_vector(to_unsigned(
                                    matrix_decimal(matrix_idx)(index), 8));
                            end if;
                            
                            if col_idx*4+3 < MATRIX_SIZE then
                                index := row_idx * MATRIX_SIZE + col_idx*4+3;
                                axi_rdata(31 downto 24) <= std_logic_vector(to_unsigned(
                                    matrix_decimal(matrix_idx)(index), 8));
                            end if;
                        end if;
                    end if;
                    
                    axi_rresp <= AXI_RESP_OK;
                    axi_rvalid <= '1';
                end if;
            end if;
        end if;
    end process;
    
    -- ��״̬�������ƾ���ַ�
    process(sys_clk)
    begin
        if rising_edge(sys_clk) then
            if sys_rst_n = '0' then
                state <= IDLE;
                matrix_output_enable <= '0';
                current_row <= 0;
                current_col <= 0;
                current_bit <= BITS_PER_ELEMENT-1; -- ��MSB��ʼ���
            else
                case state is
                    when IDLE =>
                        -- �����ƼĴ���������λ
                        if ctrl_reg(0) = '1' and matrix_count > 0 then
                            state <= DISTRIBUTE;
                            matrix_output_enable <= '1';
                            current_row <= 0;
                            current_col <= 0;
                            current_bit <= BITS_PER_ELEMENT-1; -- ��MSB��ʼ���
                        end if;
                        
                    when DISTRIBUTE =>
                        -- ����Ƿ���Ҫֹͣ�ַ�
                        if ctrl_reg(0) = '0' then
                            state <= IDLE;
                            matrix_output_enable <= '0';
                        else
                            -- ����λ��������������������
                            if current_bit > 0 then
                                current_bit <= current_bit - 1;
                            else
                                current_bit <= BITS_PER_ELEMENT-1; -- ����ΪMSB
                                if current_col < MATRIX_SIZE-1 then
                                    current_col <= current_col + 1;
                                else
                                    current_col <= 0;
                                    if current_row < NUM_ROWS-1 then
                                        current_row <= current_row + 1;
                                    else
                                        current_row <= 0; -- �ص�������ʼλ��
                                    end if;
                                end if;
                            end if;
                        end if;
                        
                    when others =>
                        state <= IDLE;
                end case;
            end if;
        end if;
    end process;
    
    -- ��������������ݵ�PMOD�˿�
    process(sys_clk)
        variable index : integer;
        variable bit_value : std_logic;
        variable temp_vector : std_logic_vector(BITS_PER_ELEMENT-1 downto 0);
    begin
        if rising_edge(sys_clk) then
            if sys_rst_n = '0' then
                serial_out <= (others => '0');
            elsif matrix_output_enable = '1' then
                -- ���㵱ǰ�����Ԫ������
                index := current_row * MATRIX_SIZE + current_col;
                
                -- Ϊÿ�������������λ
                for i in 0 to MAX_MATRICES-1 loop
                    if i < matrix_count then
                        -- ��ȡ��ǰԪ�صĵ�ǰλ��ֵ
                        temp_vector := std_logic_vector(to_unsigned(matrix_decimal(i)(index), BITS_PER_ELEMENT));
                        bit_value := temp_vector(current_bit);
                        serial_out(i) <= bit_value;
                    else
                        serial_out(i) <= '0';
                    end if;
                end loop;
            else
                serial_out <= (others => '0');
            end if;
        end if;
    end process;
    
end Behavioral;
