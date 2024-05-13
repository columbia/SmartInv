1 //SPDX-License-Identifier: MIT
2 pragma solidity =0.7.6;
3 pragma experimental ABIEncoderV2;
4 
5 /**
6  * @title IPipeline
7  * @author Publius
8  * @notice Pipeline Interface – Pipeline creates a sandbox to execute any series of function calls on any series of protocols through \term{Pipe} functions. 
9  * Any assets left in Pipeline between transactions can be transferred out by any account. 
10  * Users Pipe a series of PipeCalls that each execute a function call to another protocol through Pipeline. 
11  **/
12 
13 // PipeCalls specify a function call to be executed by Pipeline. 
14 // Pipeline supports 2 types of PipeCalls: PipeCall and AdvancedPipeCall.
15 
16 // PipeCall makes a function call with a static target address and callData.
17 struct PipeCall {
18     address target;
19     bytes data;
20 }
21 
22 // AdvancedPipeCall makes a function call with a static target address and both static and dynamic callData.
23 // AdvancedPipeCalls support sending Ether in calls.
24 // [ PipeCall Type | Send Ether Flag | PipeCall Type data | Ether Value (only if flag == 1)]
25 // [ 1 byte        | 1 byte          | n bytes        | 0 or 32 bytes                      ]
26 // See LibFunction.useClipboard for more details.
27 struct AdvancedPipeCall {
28     address target;
29     bytes callData;
30     bytes clipboard;
31 }
32 
33 interface IPipeline {
34 
35     function pipe(PipeCall calldata p)
36         external
37         payable
38         returns (bytes memory result);
39 
40     function multiPipe(PipeCall[] calldata pipes)
41         external
42         payable
43         returns (bytes[] memory results);
44 
45     function advancedPipe(AdvancedPipeCall[] calldata pipes)
46         external
47         payable
48         returns (bytes[] memory results);
49 
50 }
