
/**
 * @file mb.v
 * @breif verilog implementation of Modbus slaver protocal.
 * @details Verilog implementation of FreeModbus.
 * @details FreeModbus Libary: A portable Modbus implementation for Modbus ASCII/RTU.
 * @auther denghb
 * @date 20190113
 * @version 1.0
 * @license GNU General Public License (GPL) 3.0 
 *
 *________________________________________________________
 * History:
 *  <Date>      |   <version>   |     <Author>      |     <Description>
 *  20190113    |   1.0	        |     denghb        |     first created
 *________________________________________________________
**/


//`define MB_RTU 0
`define MB_ASCII 1
//`define MB_TCP 2



module mb(

    // inputs
    inMBInit,
    inMBClose,
    inMBEnable,
    inMBDisable,
    inMBPoll,
    inMBSetSlaveID,
    inMBRegisterCB,
    inMBRegInputCB,
    inMBRegHoldingCB,
    inMBRegCoilsCB,
    inMBRegDiscreteCB,
    
    // inouts
	
	
    // outputs
	
);  


parameter BaudRate = 115200;
parameter SlaveAddress = 8'h0A;
parameter EV_READY = 0;
parameter EV_FRAME_RECEIVED = 1;
parameter EV_EXECUTE = 2;
parameter EV_FRAME_SENT =3;


`ifdef MB_RTU
    /**
     * @brief MB_RTU code here
    **/
    assign eMode = MB_RTU;
    
`elsif MB_ASCII
    /**
     * @brief MB_ASCII code here
    **/
    assign eMode = MB_ASCII;
    
    
    
`elseif MB_TCP
    /**
     * @brief MB_TCP code here
    **/
    assign eMode = MB_TCP;

`endif
 
 
    /**
     * @brief MB protocal Event State Machine
    **/
    always @ ( posedge clk or negedge rst_n )
    begin
        if ( !rst_n )
            xEventInQueue <= 0;
        else if ( xMBPortEventPost )
            xEventInQueue <= 1;
        else if ( xMBPortEventGet )
            xEventInQueue <= 0;
    end
    always @ ( posedge clk or negedge rst_n )
    begin
        if ( !rst_n )
            eQueuedEvent <= EV_READY;
        else if ( xMBPortEventPost )
            eQueuedEvent <= eEvent;
    end
    always @ ( posedge clk or negedge rst_n )
    begin
        if ( !rst_n )
            xMBPortEventPost <= 0;
        else if ( xMBPortEventPost )
            xMBPortEventPost <= 1;
    always @ ( posedge clk or negedge rst_n )
    begin
        if ( !rst_n )
            xMBPortEventGet <= 0;
        else if ( xMBPortEventPost )
            xMBPortEventGet <= 1;
    end
    always @ ( posedge clk or negedge rst_n )
    begin
        if ( !rst_n )
            eEvent <= EV_READY;
        else if ( UARTRxISR && ( eRcvState == STATE_RX_WAIT_EOF ) && ucByte == ucMBLFCharacter )
            eEvent <= EV_FRAME_RECEIVED;
        else if ( inMBPoll && UARTRxISR && ( usRcvBufferPos >= MB_SER_PDU_SIZE_MIN ) && ( prvucMBLRC( ( UCHAR * ) ucASCIIBuf, usRcvBufferPos ) == 0 ) && ( ( ucRcvAddress == ucMBAddress ) || ( ucRcvAddress == MB_ADDRESS_BROADCAST ) ) )
            eEvent <= EV_EXECUTE;
        else if ( inMBPoll && UARTTxISR && ( eSndState == STATE_TX_NOTIFY ) )
            eEvent <= EV_FRAME_SENT;
    end
    always @ (posedge clk or negedge rst_n)
    begin
        if ( !rst_n )
            eRcvState <= STATE_RX_IDLE;
        else if ( UARTRxISR && ( ucByte == ':' ) )
            eRcvState <= STATE_RX_RCV;
        else if ( UARTRxISR && ( ucByte == MB_ASCII_DEFAULT_CR ) )
            eRcvState <= STATE_RX_WAIT_EOF;
        else if (UARTRxISR && xMBPortEventPost)
            eRcvState <= STATE_RX_IDLE;
    end
    always @ (posedge clk or negedge rst_n)
    begin
        if (!rst_n)
            eSndState <= STATE_TX_IDLE;
        else if (xMBPortEventPost)
            eSndState <= STATE_TX_START;
        else if (xMBPortEventPost)
            eSndState <= STATE_TX_DATA;
        else if (xMBPortEventPost)
            eSndState <= STATE_TX_END;
        else if ()
            eSndState <= STATE_TX_NOTIFY;
        else if ()
            eSndState <= STATE_TX_IDLE;
    end
    always @ (posedge clk or negedge rst_n)
    begin
        if (!rst_n)
            eBytePos <= BYTE_HIGH_NIBBLE;
        else if ()
            eBytePos <= BYTE_HIGH_NIBBLE;
        else if ()
            eBytePos <= BYTE_LOW_NIBBLE;
    end
    always @ (posedge clk or negedge rst_n)
    begin
        if (!rst_n)
            eMBErrorCode <= MB_ENOERR;
    end
    always @ (posedge clk or negedge rst_n)
    begin
        if (!rst_n)
            xRxEnable <= FALSE;
        else if ()
            xRxEnable <= TRUE;
        else if ()
            xRxEnable <= FALSE;
    end
    always @ (posedge clk or negedge rst_n)
    begin
        if (!rst_n)
            xTxEnable <= FALSE;
        else if ()
            xTxEnable <= TRUE;
        else if ()
            xTxEnable <= FALSE;
    end
    
    portserial U_portserial_0(
    
    );
    
    porttimer U_porttimer_0(
    
    );
    
    
endmodule
