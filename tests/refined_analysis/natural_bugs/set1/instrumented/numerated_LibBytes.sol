1 /**
2  * SPDX-License-Identifier: MIT
3  **/
4  
5 pragma solidity =0.7.6;
6 
7 /* 
8 * @author: Malteasy
9 * @title: LibBytes
10 */
11 
12 library LibBytes {
13 
14     /*
15     * @notice From Solidity Bytes Arrays Utils
16     * @author Gonçalo Sá <goncalo.sa@consensys.net>
17     */
18     function toUint8(bytes memory _bytes, uint256 _start) internal pure returns (uint8) {
19         require(_start + 1 >= _start, "toUint8_overflow");
20         require(_bytes.length >= _start + 1 , "toUint8_outOfBounds");
21         uint8 tempUint;
22 
23         assembly {
24             tempUint := mload(add(add(_bytes, 0x1), _start))
25         }
26 
27         return tempUint;
28     }
29 
30     /*
31     * @notice From Solidity Bytes Arrays Utils
32     * @author Gonçalo Sá <goncalo.sa@consensys.net>
33     */
34     function toUint32(bytes memory _bytes, uint256 _start) internal pure returns (uint32) {
35         require(_start + 4 >= _start, "toUint32_overflow");
36         require(_bytes.length >= _start + 4, "toUint32_outOfBounds");
37         uint32 tempUint;
38 
39         assembly {
40             tempUint := mload(add(add(_bytes, 0x4), _start))
41         }
42 
43         return tempUint;
44     }
45 
46     /*
47     * @notice From Solidity Bytes Arrays Utils
48     * @author Gonçalo Sá <goncalo.sa@consensys.net>
49     */
50     function toUint256(bytes memory _bytes, uint256 _start) internal pure returns (uint256) {
51         require(_start + 32 >= _start, "toUint256_overflow");
52         require(_bytes.length >= _start + 32, "toUint256_outOfBounds");
53         uint256 tempUint;
54 
55         assembly {
56             tempUint := mload(add(add(_bytes, 0x20), _start))
57         }
58 
59         return tempUint;
60     }
61 
62     /**
63     * @notice Loads a slice of a calldata bytes array into memory
64     * @param b The calldata bytes array to load from
65     * @param start The start of the slice
66     * @param length The length of the slice
67     */
68     function sliceToMemory(bytes calldata b, uint256 start, uint256 length) internal pure returns (bytes memory) {
69         bytes memory memBytes = new bytes(length);
70         for(uint256 i = 0; i < length; ++i) {
71             memBytes[i] = b[start + i];
72         }
73         return memBytes;
74     }
75 
76     function packAddressAndStem(address _address, int96 stem) internal pure returns (uint256) {
77         return uint256(_address) << 96 | uint96(stem);
78     }
79 
80     function unpackAddressAndStem(uint256 data) internal pure returns(address, int96) {
81         return (address(uint160(data >> 96)), int96(int256(data)));
82     }
83 
84 
85 }