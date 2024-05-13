1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.7.6;
4 
5 /**
6  * @author Brean
7  * @dev Provides a set of functions to operate with Base64 strings.
8  * @title Base64 is a 0.7.6 variation of Open Zeppelin's Base64.
9  *
10  */
11 library LibBytes64 {
12     /**
13      * @dev Base64 Encoding/Decoding Table
14      */
15     string internal constant _TABLE = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/";
16 
17     /**
18      * @dev Converts a `bytes` to its Bytes64 `string` representation.
19      */
20     function encode(bytes memory data) internal pure returns (string memory) {
21         /**
22          * Inspired by Brecht Devos (Brechtpd) implementation - MIT licence
23          * https://github.com/Brechtpd/base64/blob/e78d9fd951e7b0977ddca77d92dc85183770daf4/base64.sol
24          */
25         if (data.length == 0) return "";
26 
27         // Loads the table into memory
28         string memory table = _TABLE;
29 
30         // Encoding takes 3 bytes chunks of binary data from `bytes` data parameter
31         // and split into 4 numbers of 6 bits.
32         // The final Base64 length should be `bytes` data length multiplied by 4/3 rounded up
33         // - `data.length + 2`  -> Round up
34         // - `/ 3`              -> Number of 3-bytes chunks
35         // - `4 *`              -> 4 characters for each chunk
36         string memory result = new string(4 * ((data.length + 2) / 3));
37 
38         assembly {
39             // Prepare the lookup table (skip the first "length" byte)
40             let tablePtr := add(table, 1)
41 
42             // Prepare result pointer, jump over length
43             let resultPtr := add(result, 32)
44 
45             // Run over the input, 3 bytes at a time
46             for {
47                 let dataPtr := data
48                 let endPtr := add(data, mload(data))
49             } lt(dataPtr, endPtr) {
50 
51             } {
52                 // Advance 3 bytes
53                 dataPtr := add(dataPtr, 3)
54                 let input := mload(dataPtr)
55 
56                 // To write each character, shift the 3 bytes (18 bits) chunk
57                 // 4 times in blocks of 6 bits for each character (18, 12, 6, 0)
58                 // and apply logical AND with 0x3F which is the number of
59                 // the previous character in the ASCII table prior to the Base64 Table
60                 // The result is then added to the table to get the character to write,
61                 // and finally write it in the result pointer but with a left shift
62                 // of 256 (1 byte) - 8 (1 ASCII char) = 248 bits
63 
64                 mstore8(resultPtr, mload(add(tablePtr, and(shr(18, input), 0x3F))))
65                 resultPtr := add(resultPtr, 1) // Advance
66 
67                 mstore8(resultPtr, mload(add(tablePtr, and(shr(12, input), 0x3F))))
68                 resultPtr := add(resultPtr, 1) // Advance
69 
70                 mstore8(resultPtr, mload(add(tablePtr, and(shr(6, input), 0x3F))))
71                 resultPtr := add(resultPtr, 1) // Advance
72 
73                 mstore8(resultPtr, mload(add(tablePtr, and(input, 0x3F))))
74                 resultPtr := add(resultPtr, 1) // Advance
75             }
76 
77             // When data `bytes` is not exactly 3 bytes long
78             // it is padded with `=` characters at the end
79             switch mod(mload(data), 3)
80             case 1 {
81                 mstore8(sub(resultPtr, 1), 0x3d)
82                 mstore8(sub(resultPtr, 2), 0x3d)
83             }
84             case 2 {
85                 mstore8(sub(resultPtr, 1), 0x3d)
86             }
87         }
88 
89         return result;
90     }
91 }