1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Wrappers over encoding and serialization operation into bytes from bassic types in Solidity for PolyNetwork cross chain utility.
5  *
6  * Encode basic types in Solidity into bytes easily. It's designed to be used 
7  * for PolyNetwork cross chain application, and the encoding rules on Ethereum chain 
8  * and the decoding rules on other chains should be consistent. Here we  
9  * follow the underlying serialization rule with implementation found here: 
10  * https://github.com/polynetwork/poly/blob/master/common/zero_copy_sink.go
11  *
12  * Using this library instead of the unchecked serialization method can help reduce
13  * the risk of serious bugs and handfule, so it's recommended to use it.
14  *
15  * Please note that risk can be minimized, yet not eliminated.
16  */
17 library ZeroCopySink {
18     /* @notice          Convert boolean value into bytes
19     *  @param b         The boolean value
20     *  @return          Converted bytes array
21     */
22     function WriteBool(bool b) internal pure returns (bytes memory) {
23         bytes memory buff;
24         assembly{
25             buff := mload(0x40)
26             mstore(buff, 1)
27             switch iszero(b)
28             case 1 {
29                 mstore(add(buff, 0x20), shl(248, 0x00))
30                 // mstore8(add(buff, 0x20), 0x00)
31             }
32             default {
33                 mstore(add(buff, 0x20), shl(248, 0x01))
34                 // mstore8(add(buff, 0x20), 0x01)
35             }
36             mstore(0x40, add(buff, 0x21))
37         }
38         return buff;
39     }
40 
41     /* @notice          Convert byte value into bytes
42     *  @param b         The byte value
43     *  @return          Converted bytes array
44     */
45     function WriteByte(byte b) internal pure returns (bytes memory) {
46         return WriteUint8(uint8(b));
47     }
48 
49     /* @notice          Convert uint8 value into bytes
50     *  @param v         The uint8 value
51     *  @return          Converted bytes array
52     */
53     function WriteUint8(uint8 v) internal pure returns (bytes memory) {
54         bytes memory buff;
55         assembly{
56             buff := mload(0x40)
57             mstore(buff, 1)
58             mstore(add(buff, 0x20), shl(248, v))
59             // mstore(add(buff, 0x20), byte(0x1f, v))
60             mstore(0x40, add(buff, 0x21))
61         }
62         return buff;
63     }
64 
65     /* @notice          Convert uint16 value into bytes
66     *  @param v         The uint16 value
67     *  @return          Converted bytes array
68     */
69     function WriteUint16(uint16 v) internal pure returns (bytes memory) {
70         bytes memory buff;
71 
72         assembly{
73             buff := mload(0x40)
74             let byteLen := 0x02
75             mstore(buff, byteLen)
76             for {
77                 let mindex := 0x00
78                 let vindex := 0x1f
79             } lt(mindex, byteLen) {
80                 mindex := add(mindex, 0x01)
81                 vindex := sub(vindex, 0x01)
82             }{
83                 mstore8(add(add(buff, 0x20), mindex), byte(vindex, v))
84             }
85             mstore(0x40, add(buff, 0x22))
86         }
87         return buff;
88     }
89     
90     /* @notice          Convert uint32 value into bytes
91     *  @param v         The uint32 value
92     *  @return          Converted bytes array
93     */
94     function WriteUint32(uint32 v) internal pure returns(bytes memory) {
95         bytes memory buff;
96         assembly{
97             buff := mload(0x40)
98             let byteLen := 0x04
99             mstore(buff, byteLen)
100             for {
101                 let mindex := 0x00
102                 let vindex := 0x1f
103             } lt(mindex, byteLen) {
104                 mindex := add(mindex, 0x01)
105                 vindex := sub(vindex, 0x01)
106             }{
107                 mstore8(add(add(buff, 0x20), mindex), byte(vindex, v))
108             }
109             mstore(0x40, add(buff, 0x24))
110         }
111         return buff;
112     }
113 
114     /* @notice          Convert uint64 value into bytes
115     *  @param v         The uint64 value
116     *  @return          Converted bytes array
117     */
118     function WriteUint64(uint64 v) internal pure returns(bytes memory) {
119         bytes memory buff;
120 
121         assembly{
122             buff := mload(0x40)
123             let byteLen := 0x08
124             mstore(buff, byteLen)
125             for {
126                 let mindex := 0x00
127                 let vindex := 0x1f
128             } lt(mindex, byteLen) {
129                 mindex := add(mindex, 0x01)
130                 vindex := sub(vindex, 0x01)
131             }{
132                 mstore8(add(add(buff, 0x20), mindex), byte(vindex, v))
133             }
134             mstore(0x40, add(buff, 0x28))
135         }
136         return buff;
137     }
138 
139     /* @notice          Convert limited uint256 value into bytes
140     *  @param v         The uint256 value
141     *  @return          Converted bytes array
142     */
143     function WriteUint255(uint256 v) internal pure returns (bytes memory) {
144         require(v <= 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, "Value exceeds uint255 range");
145         bytes memory buff;
146 
147         assembly{
148             buff := mload(0x40)
149             let byteLen := 0x20
150             mstore(buff, byteLen)
151             for {
152                 let mindex := 0x00
153                 let vindex := 0x1f
154             } lt(mindex, byteLen) {
155                 mindex := add(mindex, 0x01)
156                 vindex := sub(vindex, 0x01)
157             }{
158                 mstore8(add(add(buff, 0x20), mindex), byte(vindex, v))
159             }
160             mstore(0x40, add(buff, 0x40))
161         }
162         return buff;
163     }
164 
165     /* @notice          Encode bytes format data into bytes
166     *  @param data      The bytes array data
167     *  @return          Encoded bytes array
168     */
169     function WriteVarBytes(bytes memory data) internal pure returns (bytes memory) {
170         uint64 l = uint64(data.length);
171         return abi.encodePacked(WriteVarUint(l), data);
172     }
173 
174     function WriteVarUint(uint64 v) internal pure returns (bytes memory) {
175         if (v < 0xFD){
176     		return WriteUint8(uint8(v));
177     	} else if (v <= 0xFFFF) {
178     		return abi.encodePacked(WriteByte(0xFD), WriteUint16(uint16(v)));
179     	} else if (v <= 0xFFFFFFFF) {
180             return abi.encodePacked(WriteByte(0xFE), WriteUint32(uint32(v)));
181     	} else {
182     		return abi.encodePacked(WriteByte(0xFF), WriteUint64(uint64(v)));
183     	}
184     }
185 }