1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.4;
3 
4 import "../../@ensdomains/buffer/0.1.0/Buffer.sol";
5 
6 /**
7 * @dev A library for populating CBOR encoded payload in Solidity.
8 *
9 * https://datatracker.ietf.org/doc/html/rfc7049
10 *
11 * The library offers various write* and start* methods to encode values of different types.
12 * The resulted buffer can be obtained with data() method.
13 * Encoding of primitive types is staightforward, whereas encoding of sequences can result
14 * in an invalid CBOR if start/write/end flow is violated.
15 * For the purpose of gas saving, the library does not verify start/write/end flow internally,
16 * except for nested start/end pairs.
17 */
18 
19 library CBOR {
20     using Buffer for Buffer.buffer;
21 
22     struct CBORBuffer {
23         Buffer.buffer buf;
24         uint256 depth;
25     }
26 
27     uint8 private constant MAJOR_TYPE_INT = 0;
28     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
29     uint8 private constant MAJOR_TYPE_BYTES = 2;
30     uint8 private constant MAJOR_TYPE_STRING = 3;
31     uint8 private constant MAJOR_TYPE_ARRAY = 4;
32     uint8 private constant MAJOR_TYPE_MAP = 5;
33     uint8 private constant MAJOR_TYPE_TAG = 6;
34     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
35 
36     uint8 private constant TAG_TYPE_BIGNUM = 2;
37     uint8 private constant TAG_TYPE_NEGATIVE_BIGNUM = 3;
38 
39     uint8 private constant CBOR_FALSE = 20;
40     uint8 private constant CBOR_TRUE = 21;
41     uint8 private constant CBOR_NULL = 22;
42     uint8 private constant CBOR_UNDEFINED = 23;
43 
44     function create(uint256 capacity) internal pure returns(CBORBuffer memory cbor) {
45         Buffer.init(cbor.buf, capacity);
46         cbor.depth = 0;
47         return cbor;
48     }
49 
50     function data(CBORBuffer memory buf) internal pure returns(bytes memory) {
51         require(buf.depth == 0, "Invalid CBOR");
52         return buf.buf.buf;
53     }
54 
55     function writeUInt256(CBORBuffer memory buf, uint256 value) internal pure {
56         buf.buf.appendUint8(uint8((MAJOR_TYPE_TAG << 5) | TAG_TYPE_BIGNUM));
57         writeBytes(buf, abi.encode(value));
58     }
59 
60     function writeInt256(CBORBuffer memory buf, int256 value) internal pure {
61         if (value < 0) {
62             buf.buf.appendUint8(
63                 uint8((MAJOR_TYPE_TAG << 5) | TAG_TYPE_NEGATIVE_BIGNUM)
64             );
65             writeBytes(buf, abi.encode(uint256(-1 - value)));
66         } else {
67             writeUInt256(buf, uint256(value));
68         }
69     }
70 
71     function writeUInt64(CBORBuffer memory buf, uint64 value) internal pure {
72         writeFixedNumeric(buf, MAJOR_TYPE_INT, value);
73     }
74 
75     function writeInt64(CBORBuffer memory buf, int64 value) internal pure {
76         if(value >= 0) {
77             writeFixedNumeric(buf, MAJOR_TYPE_INT, uint64(value));
78         } else{
79             writeFixedNumeric(buf, MAJOR_TYPE_NEGATIVE_INT, uint64(-1 - value));
80         }
81     }
82 
83     function writeBytes(CBORBuffer memory buf, bytes memory value) internal pure {
84         writeFixedNumeric(buf, MAJOR_TYPE_BYTES, uint64(value.length));
85         buf.buf.append(value);
86     }
87 
88     function writeString(CBORBuffer memory buf, string memory value) internal pure {
89         writeFixedNumeric(buf, MAJOR_TYPE_STRING, uint64(bytes(value).length));
90         buf.buf.append(bytes(value));
91     }
92 
93     function writeBool(CBORBuffer memory buf, bool value) internal pure {
94         writeContentFree(buf, value ? CBOR_TRUE : CBOR_FALSE);
95     }
96 
97     function writeNull(CBORBuffer memory buf) internal pure {
98         writeContentFree(buf, CBOR_NULL);
99     }
100 
101     function writeUndefined(CBORBuffer memory buf) internal pure {
102         writeContentFree(buf, CBOR_UNDEFINED);
103     }
104 
105     function startArray(CBORBuffer memory buf) internal pure {
106         writeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
107         buf.depth += 1;
108     }
109 
110     function startFixedArray(CBORBuffer memory buf, uint64 length) internal pure {
111         writeDefiniteLengthType(buf, MAJOR_TYPE_ARRAY, length);
112     }
113 
114     function startMap(CBORBuffer memory buf) internal pure {
115         writeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
116         buf.depth += 1;
117     }
118 
119     function startFixedMap(CBORBuffer memory buf, uint64 length) internal pure {
120         writeDefiniteLengthType(buf, MAJOR_TYPE_MAP, length);
121     }
122 
123     function endSequence(CBORBuffer memory buf) internal pure {
124         writeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
125         buf.depth -= 1;
126     }
127 
128     function writeKVString(CBORBuffer memory buf, string memory key, string memory value) internal pure {
129         writeString(buf, key);
130         writeString(buf, value);
131     }
132 
133     function writeKVBytes(CBORBuffer memory buf, string memory key, bytes memory value) internal pure {
134         writeString(buf, key);
135         writeBytes(buf, value);
136     }
137 
138     function writeKVUInt256(CBORBuffer memory buf, string memory key, uint256 value) internal pure {
139         writeString(buf, key);
140         writeUInt256(buf, value);
141     }
142 
143     function writeKVInt256(CBORBuffer memory buf, string memory key, int256 value) internal pure {
144         writeString(buf, key);
145         writeInt256(buf, value);
146     }
147 
148     function writeKVUInt64(CBORBuffer memory buf, string memory key, uint64 value) internal pure {
149         writeString(buf, key);
150         writeUInt64(buf, value);
151     }
152 
153     function writeKVInt64(CBORBuffer memory buf, string memory key, int64 value) internal pure {
154         writeString(buf, key);
155         writeInt64(buf, value);
156     }
157 
158     function writeKVBool(CBORBuffer memory buf, string memory key, bool value) internal pure {
159         writeString(buf, key);
160         writeBool(buf, value);
161     }
162 
163     function writeKVNull(CBORBuffer memory buf, string memory key) internal pure {
164         writeString(buf, key);
165         writeNull(buf);
166     }
167 
168     function writeKVUndefined(CBORBuffer memory buf, string memory key) internal pure {
169         writeString(buf, key);
170         writeUndefined(buf);
171     }
172 
173     function writeKVMap(CBORBuffer memory buf, string memory key) internal pure {
174         writeString(buf, key);
175         startMap(buf);
176     }
177 
178     function writeKVArray(CBORBuffer memory buf, string memory key) internal pure {
179         writeString(buf, key);
180         startArray(buf);
181     }
182 
183     function writeFixedNumeric(
184         CBORBuffer memory buf,
185         uint8 major,
186         uint64 value
187     ) private pure {
188         if (value <= 23) {
189             buf.buf.appendUint8(uint8((major << 5) | value));
190         } else if (value <= 0xFF) {
191             buf.buf.appendUint8(uint8((major << 5) | 24));
192             buf.buf.appendInt(value, 1);
193         } else if (value <= 0xFFFF) {
194             buf.buf.appendUint8(uint8((major << 5) | 25));
195             buf.buf.appendInt(value, 2);
196         } else if (value <= 0xFFFFFFFF) {
197             buf.buf.appendUint8(uint8((major << 5) | 26));
198             buf.buf.appendInt(value, 4);
199         } else {
200             buf.buf.appendUint8(uint8((major << 5) | 27));
201             buf.buf.appendInt(value, 8);
202         }
203     }
204 
205     function writeIndefiniteLengthType(CBORBuffer memory buf, uint8 major)
206         private
207         pure
208     {
209         buf.buf.appendUint8(uint8((major << 5) | 31));
210     }
211 
212     function writeDefiniteLengthType(CBORBuffer memory buf, uint8 major, uint64 length)
213         private
214         pure
215     {
216         writeFixedNumeric(buf, major, length);
217     }
218 
219     function writeContentFree(CBORBuffer memory buf, uint8 value) private pure {
220         buf.buf.appendUint8(uint8((MAJOR_TYPE_CONTENT_FREE << 5) | value));
221     }
222 }