1 //SPDX-License-Identifier: MIT
2 pragma solidity =0.7.6;
3 pragma experimental ABIEncoderV2;
4 
5 import "../interfaces/IPipeline.sol";
6 import "../libraries/LibFunction.sol";
7 import "@openzeppelin/contracts/token/ERC1155/ERC1155Holder.sol";
8 import "@openzeppelin/contracts/token/ERC721/ERC721Holder.sol";
9 
10 /**
11  * @title Pipeline
12  * @author Publius
13  * @notice Pipeline creates a sandbox to execute any series of function calls on any series of protocols through Pipe functions.
14  * Any assets left in Pipeline between transactions can be transferred out by any account.
15  * Users Pipe a series of PipeCalls that each execute a function call to another protocol through Pipeline.
16  * https://evmpipeline.org
17  **/
18 
19 contract Pipeline is IPipeline, ERC1155Holder, ERC721Holder {
20 
21     /**
22      * @dev So Pipeline can receive Ether.
23      */
24     receive() external payable {}
25 
26     /**
27      * @dev Returns the current version of Pipeline.
28      */
29     function version() external pure returns (string memory) {
30         return "1.0.1";
31     }
32 
33     /**
34      * @notice Execute a single PipeCall.
35      * Supports sending Ether through msg.value
36      * @param p PipeCall to execute
37      * @return result return value of PipeCall
38     **/
39     function pipe(PipeCall calldata p)
40         external
41         payable
42         override
43         returns (bytes memory result)
44     {
45         result = _pipe(p.target, p.data, msg.value);
46     }
47     
48     /**
49      * @notice Execute a list of executes a list of PipeCalls.
50      * @param pipes list of PipeCalls to execute
51      * @return results list of return values for each PipeCall
52     **/
53     function multiPipe(PipeCall[] calldata pipes)
54         external
55         payable
56         override
57         returns (bytes[] memory results)
58     {
59         results = new bytes[](pipes.length);
60         for (uint256 i = 0; i < pipes.length; i++) {
61             results[i] = _pipe(pipes[i].target, pipes[i].data, 0);
62         }
63     }
64 
65     /**
66      * @notice Execute a list of AdvancedPipeCalls.
67      * @param pipes list of AdvancedPipeCalls to execute
68      * @return results list of return values for each AdvancedPipeCalls
69     **/
70     function advancedPipe(AdvancedPipeCall[] calldata pipes)
71         external
72         payable
73         override
74         returns (bytes[] memory results) {
75             results = new bytes[](pipes.length);
76             for (uint256 i = 0; i < pipes.length; ++i) {
77                 results[i] = _advancedPipe(pipes[i], results);
78             }
79         }
80 
81     // Execute function call using calldata
82     function _pipe(
83         address target,
84         bytes calldata data,
85         uint256 value
86     ) private returns (bytes memory result) {
87         bool success;
88         (success, result) = target.call{value: value}(data);
89         LibFunction.checkReturn(success, result);
90     }
91 
92     // Execute function call using memory
93     function _pipeMem(
94         address target,
95         bytes memory data,
96         uint256 value
97     ) private returns (bytes memory result) {
98         bool success;
99         (success, result) = target.call{value: value}(data);
100         LibFunction.checkReturn(success, result);
101     }
102 
103     // Execute an AdvancedPipeCall
104     function _advancedPipe(
105         AdvancedPipeCall calldata p,
106         bytes[] memory returnData
107     ) private returns (bytes memory result) {
108         uint256 value = getEthValue(p.clipboard);
109         // 0x00 -> Normal pipe: Standard function call
110         // else > Advanced pipe: Copy return data into function call through buildAdvancedCalldata
111         if (p.clipboard[0] == 0x00) {
112             result = _pipe(p.target, p.callData, value);
113         } else {
114             result = LibFunction.useClipboard(p.callData, p.clipboard, returnData);
115             result = _pipeMem(p.target, result, value);
116         }
117     }
118 
119     // Extracts Ether value from a Clipboard
120     // clipboard[1] indicates whether there is an Ether value in the advanced data
121     // if 0x00 -> No Ether value, return 0
122     // else -> return the last 32 bytes of clipboard
123     function getEthValue(bytes calldata clipboard) private pure returns (uint256 value) {
124         if (clipboard[1] == 0x00) return 0;
125         assembly { value := calldataload(sub(add(clipboard.offset, clipboard.length), 32))}
126     }
127 }