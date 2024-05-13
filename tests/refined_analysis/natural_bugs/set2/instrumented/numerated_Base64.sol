1 // SPDX-License-Identifier: MIT
2 pragma solidity =0.8.4;
3 
4 /// @title Base64
5 /// @author Brecht Devos - <brecht@loopring.org>
6 /// @notice Provides a function for encoding some bytes in base64
7 library Base64 {
8     string internal constant TABLE = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/';
9 
10     function encode(bytes memory data) internal pure returns (string memory) {
11         if (data.length == 0) return '';
12         
13         // load the table into memory
14         string memory table = TABLE;
15 
16         // multiply by 4/3 rounded up
17         uint256 encodedLen = 4 * ((data.length + 2) / 3);
18 
19         // add some extra buffer at the end required for the writing
20         string memory result = new string(encodedLen + 32);
21 
22         assembly {
23             // set the actual output length
24             mstore(result, encodedLen)
25             
26             // prepare the lookup table
27             let tablePtr := add(table, 1)
28             
29             // input ptr
30             let dataPtr := data
31             let endPtr := add(dataPtr, mload(data))
32             
33             // result ptr, jump over length
34             let resultPtr := add(result, 32)
35             
36             // run over the input, 3 bytes at a time
37             for {} lt(dataPtr, endPtr) {}
38             {
39                dataPtr := add(dataPtr, 3)
40                
41                // read 3 bytes
42                let input := mload(dataPtr)
43                
44                // write 4 characters
45                mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(18, input), 0x3F)))))
46                resultPtr := add(resultPtr, 1)
47                mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr(12, input), 0x3F)))))
48                resultPtr := add(resultPtr, 1)
49                mstore(resultPtr, shl(248, mload(add(tablePtr, and(shr( 6, input), 0x3F)))))
50                resultPtr := add(resultPtr, 1)
51                mstore(resultPtr, shl(248, mload(add(tablePtr, and(        input,  0x3F)))))
52                resultPtr := add(resultPtr, 1)
53             }
54             
55             // padding with '='
56             switch mod(mload(data), 3)
57             case 1 { mstore(sub(resultPtr, 2), shl(240, 0x3d3d)) }
58             case 2 { mstore(sub(resultPtr, 1), shl(248, 0x3d)) }
59         }
60         
61         return result;
62     }
63 }
