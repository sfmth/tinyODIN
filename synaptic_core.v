// Copyright (C) 2019-2022, Université catholique de Louvain (UCLouvain, Belgium), University of Zürich (UZH, Switzerland),
//         Katholieke Universiteit Leuven (KU Leuven, Belgium), and Delft University of Technology (TU Delft, Netherlands).
// SPDX-License-Identifier: Apache-2.0 WITH SHL-2.1
//
// Licensed under the Solderpad Hardware License v 2.1 (the “License”); you may not use this file except in compliance
// with the License, or, at your option, the Apache License version 2.0. You may obtain a copy of the License at
// https://solderpad.org/licenses/SHL-2.1/
//
// Unless required by applicable law or agreed to in writing, any work distributed under the License is distributed on
// an “AS IS” BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied. See the License for the
// specific language governing permissions and limitations under the License.
//
//------------------------------------------------------------------------------
//
// "synaptic_core.v" - File containing the time-multiplexed synaptic array based on 4-bit-weight fixed synapses
//                     (as opposed to ODIN, which had 3-bit-weight synapses with SDSP online learning)
// 
// Project: tinyODIN - A low-cost digital spiking neuromorphic processor adapted from ODIN.
//
// Author:  C. Frenkel, Delft University of Technology
//
// Cite/paper: C. Frenkel, M. Lefebvre, J.-D. Legat and D. Bol, "A 0.086-mm² 12.7-pJ/SOP 64k-Synapse 256-Neuron Online-Learning
//             Digital Spiking Neuromorphic Processor in 28-nm CMOS," IEEE Transactions on Biomedical Circuits and Systems,
//             vol. 13, no. 1, pp. 145-158, 2019.
//
//------------------------------------------------------------------------------


module synaptic_core #(
    parameter N = 256,
    parameter M = 8
)(
    
    // Global inputs ------------------------------------------
    input  wire           CLK,
    
    // Inputs from controller ---------------------------------
    input  wire [2*M-1:0] CTRL_PROG_DATA,
    input  wire [2*M-1:0] CTRL_SPI_ADDR,
    
    // Outputs ------------------------------------------------
    output wire [   31:0] synarray_wdata,
    input wire [   31:0] SYNARRAY_RDATA
);

    // Internal regs and wires definitions
    
    genvar i;
    

    // Updated or configured weights to be written to the synaptic memory

    generate
        for (i=0; i<4; i=i+1) begin
            assign synarray_wdata[(i<<3)+7:(i<<3)] = (i == CTRL_SPI_ADDR[14:13])
                                                   ? ((CTRL_PROG_DATA[M-1:0] & ~CTRL_PROG_DATA[2*M-1:M]) | (SYNARRAY_RDATA[(i<<3)+7:(i<<3)] & CTRL_PROG_DATA[2*M-1:M]))
                                                   : SYNARRAY_RDATA[(i<<3)+7:(i<<3)];
        end
    endgenerate
    
    
    // Synaptic memory wrapper




endmodule





