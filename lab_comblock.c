/*
 * AXI ComBlock hardware Test
 *
 *  Created on: Oct 27, 2023
 *      Author: Maynor Ballina, Bruno Valinoti
 *
 *      Description: Firmware for a hardware test with the comblock and arithmetic blocks.
 */

#include <stdio.h>
#include <comblock.h>
#include <sleep.h>

#define TOOL vivado // vivado

//From the xparamiters.h define all the parameters needed
#if TOOL == vivado
    #include "xparameters.h"
    #define AXIL_BASE    XPAR_COMBLOCK_0_AXIL_BASEADDR
    #define AXIF_BASE    XPAR_COMBLOCK_0_AXIF_BASEADDR
    #define IREGS_DEPTH  XPAR_COMBLOCK_0_REGS_IN_DEPTH
    #define OREGS_DEPTH  XPAR_COMBLOCK_0_REGS_OUT_DEPTH
    #define REGS_DEPTH   ((IREGS_DEPTH < OREGS_DEPTH) ? IREGS_DEPTH : OREGS_DEPTH)
    #define DRAM_DEPTH   (1<<XPAR_COMBLOCK_0_DRAM_IO_AWIDTH)
    #define IFIFO_DEPTH  XPAR_COMBLOCK_0_FIFO_IN_DEPTH
    #define OFIFO_DEPTH  XPAR_COMBLOCK_0_FIFO_OUT_DEPTH
    #define FIFO_DEPTH   ((IFIFO_DEPTH < OFIFO_DEPTH) ? IFIFO_DEPTH : OFIFO_DEPTH)
#endif

// ComBlock-related register definitions
#define	CB_DATA_A_REG		CB_OREG0 // variable data a
#define	CB_DATA_B_REG		CB_OREG1 // variable data b
#define	CB_OP_CODE_REG	    CB_OREG2 // operation code register
#define CB_ALU_STATUS_REG	CB_IREG0 // ALU status flag
#define CB_ALU_DATA_O_REG	CB_IREG1 // ALU data operation result
#define	CB_DIV_EXN_REG		CB_IREG2 // Division exn flag
#define CB_DIV_DATA_O_REG	CB_IREG3 // Division data operation result
#define CB_SWS_REG			CB_IREG4 // Read slide switches

//data variables
int data_a, data_b, status, exn, sws, swso, data_out;

int main(){

	// initializing the variables
	data_a = 10;
	data_b = 5;
	status = 0;
	exn = 0;
	swso = 255;

	printf("### Testing the Comblock Registers\n");
	// To execute an operation you will have to determine the type of operation, by
	// writing on the register that is connected to the op_code_i port you can do it.

	// 1. write data in the comblock corresponding registers
	cbWrite(AXIL_BASE, CB_DATA_A_REG, data_a);
	cbWrite(AXIL_BASE, CB_DATA_B_REG, data_b);
	printf("Data in A=%d, B=%d\n",data_a,data_b);

	// Use a comblock register to read the slide switch status
	// This example reads the value of the register, and validates the last value recored
	// only prints when the value changes.
	while(1){
		sws = cbRead(AXIL_BASE, CB_SWS_REG);
		if (sws != swso){
			swso = cbRead(AXIL_BASE, CB_SWS_REG);
			printf("sws value: %d\n",sws);
			if (sws > 8){
				printf("Not valid operation\n");
			} else {
				if (sws == 8){
					exn = cbRead(AXIL_BASE, CB_DIV_EXN_REG);
					printf("operation exn: %d\n", exn);
					data_out = cbRead(AXIL_BASE, CB_DIV_DATA_O_REG);
					printf("division R = %d\n",data_out);
				} else {
					cbWrite(AXIL_BASE, CB_OP_CODE_REG, sws);
					status = cbRead(AXIL_BASE, CB_ALU_STATUS_REG);
					printf("operation status: %d\n", status);
					data_out = cbRead(AXIL_BASE, CB_ALU_DATA_O_REG);
					printf("operation option = %d, result = %d\n",sws,data_out);
				}

			}
		}
		sleep(5);
	}
	return 0;
}
