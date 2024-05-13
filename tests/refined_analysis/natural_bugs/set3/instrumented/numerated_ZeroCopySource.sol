1 pragma solidity ^0.5.0;
2 
3 /**
4  * @dev Wrappers over decoding and deserialization operation from bytes into bassic types in Solidity for PolyNetwork cross chain utility.
5  *
6  * Decode into basic types in Solidity from bytes easily. It's designed to be used 
7  * for PolyNetwork cross chain application, and the decoding rules on Ethereum chain 
8  * and the encoding rule on other chains should be consistent, and . Here we
9  * follow the underlying deserialization rule with implementation found here: 
10  * https://github.com/polynetwork/poly/blob/master/common/zero_copy_source.go
11  *
12  * Using this library instead of the unchecked serialization method can help reduce
13  * the risk of serious bugs and handfule, so it's recommended to use it.
14  *
15  * Please note that risk can be minimized, yet not eliminated.
16  */
17 library ZeroCopySource {
18     /* @notice              Read next byte as boolean type starting at offset from buff
19     *  @param buff          Source bytes array
20     *  @param offset        The position from where we read the boolean value
21     *  @return              The the read boolean value and new offset
22     */
23     function NextBool(bytes memory buff, uint256 offset) internal pure returns(bool, uint256) {
24         require(offset + 1 <= buff.length && offset < offset + 1, "Offset exceeds limit");
25         // byte === bytes1
26         byte v;
27         assembly{
28             v := mload(add(add(buff, 0x20), offset))
29         }
30         bool value;
31         if (v == 0x01) {
32 		    value = true;
33     	} else if (v == 0x00) {
34             value = false;
35         } else {
36             revert("NextBool value error");
37         }
38         return (value, offset + 1);
39     }
40 
41     /* @notice              Read next byte starting at offset from buff
42     *  @param buff          Source bytes array
43     *  @param offset        The position from where we read the byte value
44     *  @return              The read byte value and new offset
45     */
46     function NextByte(bytes memory buff, uint256 offset) internal pure returns (byte, uint256) {
47         require(offset + 1 <= buff.length && offset < offset + 1, "NextByte, Offset exceeds maximum");
48         byte v;
49         assembly{
50             v := mload(add(add(buff, 0x20), offset))
51         }
52         return (v, offset + 1);
53     }
54 
55     /* @notice              Read next byte as uint8 starting at offset from buff
56     *  @param buff          Source bytes array
57     *  @param offset        The position from where we read the byte value
58     *  @return              The read uint8 value and new offset
59     */
60     function NextUint8(bytes memory buff, uint256 offset) internal pure returns (uint8, uint256) {
61         require(offset + 1 <= buff.length && offset < offset + 1, "NextUint8, Offset exceeds maximum");
62         uint8 v;
63         assembly{
64             let tmpbytes := mload(0x40)
65             let bvalue := mload(add(add(buff, 0x20), offset))
66             mstore8(tmpbytes, byte(0, bvalue))
67             mstore(0x40, add(tmpbytes, 0x01))
68             v := mload(sub(tmpbytes, 0x1f))
69         }
70         return (v, offset + 1);
71     }
72 
73     /* @notice              Read next two bytes as uint16 type starting from offset
74     *  @param buff          Source bytes array
75     *  @param offset        The position from where we read the uint16 value
76     *  @return              The read uint16 value and updated offset
77     */
78     function NextUint16(bytes memory buff, uint256 offset) internal pure returns (uint16, uint256) {
79         require(offset + 2 <= buff.length && offset < offset + 2, "NextUint16, offset exceeds maximum");
80         
81         uint16 v;
82         assembly {
83             let tmpbytes := mload(0x40)
84             let bvalue := mload(add(add(buff, 0x20), offset))
85             mstore8(tmpbytes, byte(0x01, bvalue))
86             mstore8(add(tmpbytes, 0x01), byte(0, bvalue))
87             mstore(0x40, add(tmpbytes, 0x02))
88             v := mload(sub(tmpbytes, 0x1e))
89         }
90         return (v, offset + 2);
91     }
92 
93 
94     /* @notice              Read next four bytes as uint32 type starting from offset
95     *  @param buff          Source bytes array
96     *  @param offset        The position from where we read the uint32 value
97     *  @return              The read uint32 value and updated offset
98     */
99     function NextUint32(bytes memory buff, uint256 offset) internal pure returns (uint32, uint256) {
100         require(offset + 4 <= buff.length && offset < offset + 4, "NextUint32, offset exceeds maximum");
101         uint32 v;
102         assembly {
103             let tmpbytes := mload(0x40)
104             let byteLen := 0x04
105             for {
106                 let tindex := 0x00
107                 let bindex := sub(byteLen, 0x01)
108                 let bvalue := mload(add(add(buff, 0x20), offset))
109             } lt(tindex, byteLen) {
110                 tindex := add(tindex, 0x01)
111                 bindex := sub(bindex, 0x01)
112             }{
113                 mstore8(add(tmpbytes, tindex), byte(bindex, bvalue))
114             }
115             mstore(0x40, add(tmpbytes, byteLen))
116             v := mload(sub(tmpbytes, sub(0x20, byteLen)))
117         }
118         return (v, offset + 4);
119     }
120 
121     /* @notice              Read next eight bytes as uint64 type starting from offset
122     *  @param buff          Source bytes array
123     *  @param offset        The position from where we read the uint64 value
124     *  @return              The read uint64 value and updated offset
125     */
126     function NextUint64(bytes memory buff, uint256 offset) internal pure returns (uint64, uint256) {
127         require(offset + 8 <= buff.length && offset < offset + 8, "NextUint64, offset exceeds maximum");
128         uint64 v;
129         assembly {
130             let tmpbytes := mload(0x40)
131             let byteLen := 0x08
132             for {
133                 let tindex := 0x00
134                 let bindex := sub(byteLen, 0x01)
135                 let bvalue := mload(add(add(buff, 0x20), offset))
136             } lt(tindex, byteLen) {
137                 tindex := add(tindex, 0x01)
138                 bindex := sub(bindex, 0x01)
139             }{
140                 mstore8(add(tmpbytes, tindex), byte(bindex, bvalue))
141             }
142             mstore(0x40, add(tmpbytes, byteLen))
143             v := mload(sub(tmpbytes, sub(0x20, byteLen)))
144         }
145         return (v, offset + 8);
146     }
147 
148     /* @notice              Read next 32 bytes as uint256 type starting from offset,
149                             there are limits considering the numerical limits in multi-chain
150     *  @param buff          Source bytes array
151     *  @param offset        The position from where we read the uint256 value
152     *  @return              The read uint256 value and updated offset
153     */
154     function NextUint255(bytes memory buff, uint256 offset) internal pure returns (uint256, uint256) {
155         require(offset + 32 <= buff.length && offset < offset + 32, "NextUint255, offset exceeds maximum");
156         uint256 v;
157         assembly {
158             let tmpbytes := mload(0x40)
159             let byteLen := 0x20
160             for {
161                 let tindex := 0x00
162                 let bindex := sub(byteLen, 0x01)
163                 let bvalue := mload(add(add(buff, 0x20), offset))
164             } lt(tindex, byteLen) {
165                 tindex := add(tindex, 0x01)
166                 bindex := sub(bindex, 0x01)
167             }{
168                 mstore8(add(tmpbytes, tindex), byte(bindex, bvalue))
169             }
170             mstore(0x40, add(tmpbytes, byteLen))
171             v := mload(tmpbytes)
172         }
173         require(v <= 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff, "Value exceeds the range");
174         return (v, offset + 32);
175     }
176     /* @notice              Read next variable bytes starting from offset,
177                             the decoding rule coming from multi-chain
178     *  @param buff          Source bytes array
179     *  @param offset        The position from where we read the bytes value
180     *  @return              The read variable bytes array value and updated offset
181     */
182     function NextVarBytes(bytes memory buff, uint256 offset) internal pure returns(bytes memory, uint256) {
183         uint len;
184         (len, offset) = NextVarUint(buff, offset);
185         require(offset + len <= buff.length && offset < offset + len, "NextVarBytes, offset exceeds maximum");
186         bytes memory tempBytes;
187         assembly{
188             switch iszero(len)
189             case 0 {
190                 // Get a location of some free memory and store it in tempBytes as
191                 // Solidity does for memory variables.
192                 tempBytes := mload(0x40)
193 
194                 // The first word of the slice result is potentially a partial
195                 // word read from the original array. To read it, we calculate
196                 // the length of that partial word and start copying that many
197                 // bytes into the array. The first word we copy will start with
198                 // data we don't care about, but the last `lengthmod` bytes will
199                 // land at the beginning of the contents of the new array. When
200                 // we're done copying, we overwrite the full first word with
201                 // the actual length of the slice.
202                 let lengthmod := and(len, 31)
203 
204                 // The multiplication in the next line is necessary
205                 // because when slicing multiples of 32 bytes (lengthmod == 0)
206                 // the following copy loop was copying the origin's length
207                 // and then ending prematurely not copying everything it should.
208                 let mc := add(add(tempBytes, lengthmod), mul(0x20, iszero(lengthmod)))
209                 let end := add(mc, len)
210 
211                 for {
212                     // The multiplication in the next line has the same exact purpose
213                     // as the one above.
214                     let cc := add(add(add(buff, lengthmod), mul(0x20, iszero(lengthmod))), offset)
215                 } lt(mc, end) {
216                     mc := add(mc, 0x20)
217                     cc := add(cc, 0x20)
218                 } {
219                     mstore(mc, mload(cc))
220                 }
221 
222                 mstore(tempBytes, len)
223 
224                 //update free-memory pointer
225                 //allocating the array padded to 32 bytes like the compiler does now
226                 mstore(0x40, and(add(mc, 31), not(31)))
227             }
228             //if we want a zero-length slice let's just return a zero-length array
229             default {
230                 tempBytes := mload(0x40)
231 
232                 mstore(0x40, add(tempBytes, 0x20))
233             }
234         }
235 
236         return (tempBytes, offset + len);
237     }
238     /* @notice              Read next 32 bytes starting from offset,
239     *  @param buff          Source bytes array
240     *  @param offset        The position from where we read the bytes value
241     *  @return              The read bytes32 value and updated offset
242     */
243     function NextHash(bytes memory buff, uint256 offset) internal pure returns (bytes32 , uint256) {
244         require(offset + 32 <= buff.length && offset < offset + 32, "NextHash, offset exceeds maximum");
245         bytes32 v;
246         assembly {
247             v := mload(add(buff, add(offset, 0x20)))
248         }
249         return (v, offset + 32);
250     }
251 
252     /* @notice              Read next 20 bytes starting from offset,
253     *  @param buff          Source bytes array
254     *  @param offset        The position from where we read the bytes value
255     *  @return              The read bytes20 value and updated offset
256     */
257     function NextBytes20(bytes memory buff, uint256 offset) internal pure returns (bytes20 , uint256) {
258         require(offset + 20 <= buff.length && offset < offset + 20, "NextBytes20, offset exceeds maximum");
259         bytes20 v;
260         assembly {
261             v := mload(add(buff, add(offset, 0x20)))
262         }
263         return (v, offset + 20);
264     }
265     
266     function NextVarUint(bytes memory buff, uint256 offset) internal pure returns(uint, uint256) {
267         byte v;
268         (v, offset) = NextByte(buff, offset);
269 
270         uint value;
271         if (v == 0xFD) {
272             // return NextUint16(buff, offset);
273             (value, offset) = NextUint16(buff, offset);
274             require(value >= 0xFD && value <= 0xFFFF, "NextUint16, value outside range");
275             return (value, offset);
276         } else if (v == 0xFE) {
277             // return NextUint32(buff, offset);
278             (value, offset) = NextUint32(buff, offset);
279             require(value > 0xFFFF && value <= 0xFFFFFFFF, "NextVarUint, value outside range");
280             return (value, offset);
281         } else if (v == 0xFF) {
282             // return NextUint64(buff, offset);
283             (value, offset) = NextUint64(buff, offset);
284             require(value > 0xFFFFFFFF, "NextVarUint, value outside range");
285             return (value, offset);
286         } else{
287             // return (uint8(v), offset);
288             value = uint8(v);
289             require(value < 0xFD, "NextVarUint, value outside range");
290             return (value, offset);
291         }
292     }
293 }