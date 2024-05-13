1 /*
2  SPDX-License-Identifier: MIT
3 */
4 
5 pragma solidity =0.7.6;
6 pragma experimental ABIEncoderV2;
7 
8 import {LibDiamond} from "./LibDiamond.sol";
9 
10 /**
11  * @title Lib Function
12  * @author Publius
13  **/
14 
15 library LibFunction {
16     /**
17      * @notice Checks The return value of a any function call for success, if not returns the error returned in `results`
18      * @param success Whether the corresponding function call succeeded
19      * @param result The return data of the corresponding function call
20     **/
21     function checkReturn(bool success, bytes memory result) internal pure {
22         if (!success) {
23             // Next 5 lines from https://ethereum.stackexchange.com/a/83577
24             // Also, used in Uniswap V3 https://github.com/Uniswap/v3-periphery/blob/main/contracts/base/Multicall.sol#L17
25             if (result.length < 68) revert();
26             assembly {
27                 result := add(result, 0x04)
28             }
29             revert(abi.decode(result, (string)));
30         }
31     }
32 
33     /**
34      * @notice Gets the facet address for a given selector
35      * @param selector The function selector to fetch the facet address for
36      * @dev Fails if no set facet address
37      * @return facet The facet address
38     **/
39     function facetForSelector(bytes4 selector)
40         internal
41         view
42         returns (address facet)
43     {
44         LibDiamond.DiamondStorage storage ds = LibDiamond.diamondStorage();
45         facet = ds.selectorToFacetAndPosition[selector].facetAddress;
46         require(facet != address(0), "Diamond: Function does not exist");
47     }
48 
49     /** @notice Use a Clipboard on callData to copy return values stored as returnData from any Advanced Calls
50      * that have already been executed and paste them into the callData of the next Advanced Call, in a customizable manner
51      * @param callData The callData bytes of next Advanced Call to paste onto
52      * @param clipboard 0, 1 or n encoded paste operations and encoded ether value if using Pipeline
53      * -------------------------------------------------------------------------------------
54      * Clipboard stores the bytes:
55      * [ Type   | Use Ether Flag*  | Type data      | Ether Value (only if flag == 1)*]
56      * [ 1 byte | 1 byte           | n bytes        | 0 or 32 bytes                   ]
57      * * Use Ether Flag and Ether Value are processed in Pipeline.sol (Not used in Farm). See Pipeline.getEthValue for ussage.
58      * Type: 0x00, 0x01 or 0x002
59      *  - 0x00: 0 Paste Operations (Logic in Pipeline.sol and FarmFacet.sol)
60      *  - 0x01: 1 Paste Operation
61      *  - 0x02: n Paste Operations
62      * Type Data: There are two types with type data: 0x01, 0x02
63      *  Type 1 (0x01): Copy 1 bytes32 from a previous function return value
64      *       [ pasteParams ]
65      *       [ 32 bytes ]
66      *      Note: Should be encoded with ['bytes2', 'uint80', 'uint80', 'uint80']  where the first two bytes are Type and Send Ether Flag if using Pipeline
67      *  Type 2 (0x02): Copy n bytes32 from a previous function return value
68      *       [ Padding      | pasteParams[] ]
69      *       [ 32 bytes     | 32 + 32 * n   ]
70      *        * The first 32 bytes are the length of the array.
71      * -------------------------------------------------------------------------------------
72      * @param returnData A list of return values from previously executed Advanced Calls
73      @return data The function call return datas
74     **/
75     function useClipboard(
76         bytes calldata callData,
77         bytes calldata clipboard,
78         bytes[] memory returnData
79     ) internal pure returns (bytes memory data) {
80         bytes1 typeId = clipboard[0];
81         if (typeId == 0x01) {
82             bytes32 pasteParams = abi.decode(clipboard, (bytes32));
83             data = LibFunction.pasteAdvancedBytes(callData, returnData, pasteParams);
84         } else if (typeId == 0x02) {
85             (, bytes32[] memory pasteParams) = abi.decode(
86                 clipboard,
87                 (uint256, bytes32[])
88             );
89             data = callData;
90             for (uint256 i; i < pasteParams.length; i++)
91                 data = LibFunction.pasteAdvancedBytes(data, returnData, pasteParams[i]);
92         } else {
93             revert("Function: Advanced Type not supported");
94         }
95     }
96 
97     /**
98      * @notice Copies 32 bytes from returnData into callData determined by pasteParams
99      * @param callData The callData bytes of the next function call
100      * @param returnData A list of bytes corresponding to return data from previous function calls in the transaction
101      * @param pasteParams Denotes which data should be copied and where it should be pasted
102      * Should be in the following format
103      * [2 bytes | 10 bytes         | 10 bytes  | 10 bytes   ]
104      * [ N/A    | returnDataIndex  | copyIndex | pasteIndex ]
105      * @return pastedData the calldata for the next function call with bytes pasted from returnData
106      **/
107     function pasteAdvancedBytes(
108         bytes memory callData,
109         bytes[] memory returnData,
110         bytes32 pasteParams
111     ) internal pure returns (bytes memory pastedData) {
112         // Shift `pasteParams` right 22 bytes to insolated reduceDataIndex
113         bytes memory copyData = returnData[uint256((pasteParams << 16) >> 176)];
114         pastedData = paste32Bytes(
115             copyData,
116             callData,
117             uint256((pasteParams << 96) >> 176), // Isolate copyIndex
118             uint256((pasteParams << 176) >> 176) // Isolate pasteIndex
119         );
120     }
121 
122     /**
123      * @notice Copy 32 Bytes from copyData at copyIndex and paste into pasteData at pasteIndex
124      * @param copyData The data bytes to copy from
125      * @param pasteData The data bytes to paste into
126      * @param copyIndex The index in copyData to copying from
127      * @param pasteIndex The index in pasteData to paste into
128      * @return pastedData The data with the copied with 32 bytes
129     **/
130     function paste32Bytes(
131         bytes memory copyData,
132         bytes memory pasteData,
133         uint256 copyIndex,
134         uint256 pasteIndex
135     ) internal pure returns (bytes memory pastedData) {
136         assembly {
137             mstore(add(pasteData, pasteIndex), mload(add(copyData, copyIndex)))
138         }
139         pastedData = pasteData;
140     }
141 }
