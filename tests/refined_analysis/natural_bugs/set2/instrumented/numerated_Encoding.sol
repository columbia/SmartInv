1 // SPDX-License-Identifier: MIT OR Apache-2.0
2 pragma solidity >=0.6.11;
3 
4 library Encoding {
5     // ============ Constants ============
6 
7     bytes private constant NIBBLE_LOOKUP = "0123456789abcdef";
8 
9     // ============ Internal Functions ============
10 
11     /**
12      * @notice Encode a uint32 in its DECIMAL representation, with leading
13      * zeroes.
14      * @param _num The number to encode
15      * @return _encoded The encoded number, suitable for use in abi.
16      * encodePacked
17      */
18     function decimalUint32(uint32 _num)
19         internal
20         pure
21         returns (uint80 _encoded)
22     {
23         uint80 ASCII_0 = 0x30;
24         // all over/underflows are impossible
25         // this will ALWAYS produce 10 decimal characters
26         for (uint8 i = 0; i < 10; i += 1) {
27             _encoded |= ((_num % 10) + ASCII_0) << (i * 8);
28             _num = _num / 10;
29         }
30     }
31 
32     /**
33      * @notice Encodes the uint256 to hex. `first` contains the encoded top 16 bytes.
34      * `second` contains the encoded lower 16 bytes.
35      * @param _bytes The 32 bytes as uint256
36      * @return _firstHalf The top 16 bytes
37      * @return _secondHalf The bottom 16 bytes
38      */
39     function encodeHex(uint256 _bytes)
40         internal
41         pure
42         returns (uint256 _firstHalf, uint256 _secondHalf)
43     {
44         for (uint8 i = 31; i > 15; i -= 1) {
45             uint8 _b = uint8(_bytes >> (i * 8));
46             _firstHalf |= _byteHex(_b);
47             if (i != 16) {
48                 _firstHalf <<= 16;
49             }
50         }
51         // abusing underflow here =_=
52         for (uint8 i = 15; i < 255; i -= 1) {
53             uint8 _b = uint8(_bytes >> (i * 8));
54             _secondHalf |= _byteHex(_b);
55             if (i != 0) {
56                 _secondHalf <<= 16;
57             }
58         }
59     }
60 
61     /**
62      * @notice Returns the encoded hex character that represents the lower 4 bits of the argument.
63      * @param _byte The byte
64      * @return _char The encoded hex character
65      */
66     function _nibbleHex(uint8 _byte) private pure returns (uint8 _char) {
67         uint8 _nibble = _byte & 0x0f; // keep bottom 4, 0 top 4
68         _char = uint8(NIBBLE_LOOKUP[_nibble]);
69     }
70 
71     /**
72      * @notice Returns a uint16 containing the hex-encoded byte.
73      * @param _byte The byte
74      * @return _encoded The hex-encoded byte
75      */
76     function _byteHex(uint8 _byte) private pure returns (uint16 _encoded) {
77         _encoded |= _nibbleHex(_byte >> 4); // top 4 bits
78         _encoded <<= 8;
79         _encoded |= _nibbleHex(_byte); // lower 4 bits
80     }
81 }
