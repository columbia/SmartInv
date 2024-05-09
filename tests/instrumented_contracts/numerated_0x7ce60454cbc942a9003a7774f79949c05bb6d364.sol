1 /*! UBETS.ME | (c) 2019 UBETS TECHNOLOGIES LTD, author @ubetsmesupport | License: MIT */
2 
3 pragma solidity 0.4.25;
4 
5 // <ORACLIZE_API>
6     // Release targetted at solc 0.4.25 to silence compiler warning/error messages, compatible down to 0.4.22
7     /*
8     Copyright (c) 2015-2016 Oraclize SRL
9     Copyright (c) 2016 Oraclize LTD
10 
11 
12     Permission is hereby granted, free of charge, to any person obtaining a copy
13     of this software and associated documentation files (the "Software"), to deal
14     in the Software without restriction, including without limitation the rights
15     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
16     copies of the Software, and to permit persons to whom the Software is
17     furnished to do so, subject to the following conditions:
18 
19 
20 
21     The above copyright notice and this permission notice shall be included in
22     all copies or substantial portions of the Software.
23 
24 
25 
26     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
27     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
28     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
29     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
30     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
31     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
32     THE SOFTWARE.
33     */
34 
35     // This api is currently targeted at 0.4.22 to 0.4.25 (stable builds), please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
36 
37     contract OraclizeI {
38         address public cbAddress;
39         function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
40         function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
41         function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
42         function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
43         function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
44         function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
45         function getPrice(string _datasource) public returns (uint _dsprice);
46         function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
47         function setProofType(byte _proofType) external;
48         function setCustomGasPrice(uint _gasPrice) external;
49         function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
50     }
51 
52     contract OraclizeAddrResolverI {
53         function getAddress() public returns (address _addr);
54     }
55 
56     /*
57     Begin solidity-cborutils
58 
59     https://github.com/smartcontractkit/solidity-cborutils
60 
61     MIT License
62 
63     Copyright (c) 2018 SmartContract ChainLink, Ltd.
64 
65     Permission is hereby granted, free of charge, to any person obtaining a copy
66     of this software and associated documentation files (the "Software"), to deal
67     in the Software without restriction, including without limitation the rights
68     to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
69     copies of the Software, and to permit persons to whom the Software is
70     furnished to do so, subject to the following conditions:
71 
72     The above copyright notice and this permission notice shall be included in all
73     copies or substantial portions of the Software.
74 
75     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
76     IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
77     FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
78     AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
79     LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
80     OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
81     SOFTWARE.
82     */
83 
84     library Buffer {
85         struct buffer {
86             bytes buf;
87             uint capacity;
88         }
89 
90         function init(buffer memory buf, uint _capacity) internal pure {
91             uint capacity = _capacity;
92             if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
93             // Allocate space for the buffer data
94             buf.capacity = capacity;
95             assembly {
96                 let ptr := mload(0x40)
97                 mstore(buf, ptr)
98                 mstore(ptr, 0)
99                 mstore(0x40, add(ptr, capacity))
100             }
101         }
102 
103         function resize(buffer memory buf, uint capacity) private pure {
104             bytes memory oldbuf = buf.buf;
105             init(buf, capacity);
106             append(buf, oldbuf);
107         }
108 
109         function max(uint a, uint b) private pure returns(uint) {
110             if(a > b) {
111                 return a;
112             }
113             return b;
114         }
115 
116         /**
117         * @dev Appends a byte array to the end of the buffer. Resizes if doing so
118         *      would exceed the capacity of the buffer.
119         * @param buf The buffer to append to.
120         * @param data The data to append.
121         * @return The original buffer.
122         */
123         function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
124             if(data.length + buf.buf.length > buf.capacity) {
125                 resize(buf, max(buf.capacity, data.length) * 2);
126             }
127 
128             uint dest;
129             uint src;
130             uint len = data.length;
131             assembly {
132                 // Memory address of the buffer data
133                 let bufptr := mload(buf)
134                 // Length of existing buffer data
135                 let buflen := mload(bufptr)
136                 // Start address = buffer address + buffer length + sizeof(buffer length)
137                 dest := add(add(bufptr, buflen), 32)
138                 // Update buffer length
139                 mstore(bufptr, add(buflen, mload(data)))
140                 src := add(data, 32)
141             }
142 
143             // Copy word-length chunks while possible
144             for(; len >= 32; len -= 32) {
145                 assembly {
146                     mstore(dest, mload(src))
147                 }
148                 dest += 32;
149                 src += 32;
150             }
151 
152             // Copy remaining bytes
153             uint mask = 256 ** (32 - len) - 1;
154             assembly {
155                 let srcpart := and(mload(src), not(mask))
156                 let destpart := and(mload(dest), mask)
157                 mstore(dest, or(destpart, srcpart))
158             }
159 
160             return buf;
161         }
162 
163         /**
164         * @dev Appends a byte to the end of the buffer. Resizes if doing so would
165         * exceed the capacity of the buffer.
166         * @param buf The buffer to append to.
167         * @param data The data to append.
168         * @return The original buffer.
169         */
170         function append(buffer memory buf, uint8 data) internal pure {
171             if(buf.buf.length + 1 > buf.capacity) {
172                 resize(buf, buf.capacity * 2);
173             }
174 
175             assembly {
176                 // Memory address of the buffer data
177                 let bufptr := mload(buf)
178                 // Length of existing buffer data
179                 let buflen := mload(bufptr)
180                 // Address = buffer address + buffer length + sizeof(buffer length)
181                 let dest := add(add(bufptr, buflen), 32)
182                 mstore8(dest, data)
183                 // Update buffer length
184                 mstore(bufptr, add(buflen, 1))
185             }
186         }
187 
188         /**
189         * @dev Appends a byte to the end of the buffer. Resizes if doing so would
190         * exceed the capacity of the buffer.
191         * @param buf The buffer to append to.
192         * @param data The data to append.
193         * @return The original buffer.
194         */
195         function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
196             if(len + buf.buf.length > buf.capacity) {
197                 resize(buf, max(buf.capacity, len) * 2);
198             }
199 
200             uint mask = 256 ** len - 1;
201             assembly {
202                 // Memory address of the buffer data
203                 let bufptr := mload(buf)
204                 // Length of existing buffer data
205                 let buflen := mload(bufptr)
206                 // Address = buffer address + buffer length + sizeof(buffer length) + len
207                 let dest := add(add(bufptr, buflen), len)
208                 mstore(dest, or(and(mload(dest), not(mask)), data))
209                 // Update buffer length
210                 mstore(bufptr, add(buflen, len))
211             }
212             return buf;
213         }
214     }
215 
216     library CBOR {
217         using Buffer for Buffer.buffer;
218 
219         uint8 private constant MAJOR_TYPE_INT = 0;
220         uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
221         uint8 private constant MAJOR_TYPE_BYTES = 2;
222         uint8 private constant MAJOR_TYPE_STRING = 3;
223         uint8 private constant MAJOR_TYPE_ARRAY = 4;
224         uint8 private constant MAJOR_TYPE_MAP = 5;
225         uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
226 
227         function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
228             if(value <= 23) {
229                 buf.append(uint8((major << 5) | value));
230             } else if(value <= 0xFF) {
231                 buf.append(uint8((major << 5) | 24));
232                 buf.appendInt(value, 1);
233             } else if(value <= 0xFFFF) {
234                 buf.append(uint8((major << 5) | 25));
235                 buf.appendInt(value, 2);
236             } else if(value <= 0xFFFFFFFF) {
237                 buf.append(uint8((major << 5) | 26));
238                 buf.appendInt(value, 4);
239             } else if(value <= 0xFFFFFFFFFFFFFFFF) {
240                 buf.append(uint8((major << 5) | 27));
241                 buf.appendInt(value, 8);
242             }
243         }
244 
245         function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
246             buf.append(uint8((major << 5) | 31));
247         }
248 
249         function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
250             encodeType(buf, MAJOR_TYPE_INT, value);
251         }
252 
253         function encodeInt(Buffer.buffer memory buf, int value) internal pure {
254             if(value >= 0) {
255                 encodeType(buf, MAJOR_TYPE_INT, uint(value));
256             } else {
257                 encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
258             }
259         }
260 
261         function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
262             encodeType(buf, MAJOR_TYPE_BYTES, value.length);
263             buf.append(value);
264         }
265 
266         function encodeString(Buffer.buffer memory buf, string value) internal pure {
267             encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
268             buf.append(bytes(value));
269         }
270 
271         function startArray(Buffer.buffer memory buf) internal pure {
272             encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
273         }
274 
275         function startMap(Buffer.buffer memory buf) internal pure {
276             encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
277         }
278 
279         function endSequence(Buffer.buffer memory buf) internal pure {
280             encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
281         }
282     }
283 
284     /*
285     End solidity-cborutils
286     */
287 
288     contract usingOraclize {
289         uint constant day = 60*60*24;
290         uint constant week = 60*60*24*7;
291         uint constant month = 60*60*24*30;
292         byte constant proofType_NONE = 0x00;
293         byte constant proofType_TLSNotary = 0x10;
294         byte constant proofType_Ledger = 0x30;
295         byte constant proofType_Android = 0x40;
296         byte constant proofType_Native = 0xF0;
297         byte constant proofStorage_IPFS = 0x01;
298         uint8 constant networkID_auto = 0;
299         uint8 constant networkID_mainnet = 1;
300         uint8 constant networkID_testnet = 2;
301         uint8 constant networkID_morden = 2;
302         uint8 constant networkID_consensys = 161;
303 
304         OraclizeAddrResolverI OAR;
305 
306         OraclizeI oraclize;
307         modifier oraclizeAPI {
308             if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
309                 oraclize_setNetwork(networkID_auto);
310 
311             if(address(oraclize) != OAR.getAddress())
312                 oraclize = OraclizeI(OAR.getAddress());
313 
314             _;
315         }
316         modifier coupon(string code){
317             oraclize = OraclizeI(OAR.getAddress());
318             _;
319         }
320 
321         function oraclize_setNetwork(uint8 networkID) internal returns(bool){
322         return oraclize_setNetwork();
323         networkID; // silence the warning and remain backwards compatible
324         }
325         function oraclize_setNetwork() internal returns(bool){
326             if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
327                 OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
328                 oraclize_setNetworkName("eth_mainnet");
329                 return true;
330             }
331             if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
332                 OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
333                 oraclize_setNetworkName("eth_ropsten3");
334                 return true;
335             }
336             if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
337                 OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
338                 oraclize_setNetworkName("eth_kovan");
339                 return true;
340             }
341             if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
342                 OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
343                 oraclize_setNetworkName("eth_rinkeby");
344                 return true;
345             }
346             if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
347                 OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
348                 return true;
349             }
350             if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
351                 OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
352                 return true;
353             }
354             if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
355                 OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
356                 return true;
357             }
358             return false;
359         }
360 
361         function __callback(bytes32 myid, string result) public {
362             __callback(myid, result, new bytes(0));
363         }
364         function __callback(bytes32 myid, string result, bytes proof) public {
365         return;
366         // Following should never be reached with a preceding return, however
367         // this is just a placeholder function, ideally meant to be defined in
368         // child contract when proofs are used
369         myid; result; proof; // Silence compiler warnings
370         oraclize = OraclizeI(0); // Additional compiler silence about making function pure/view. 
371         }
372 
373         function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
374             return oraclize.getPrice(datasource);
375         }
376 
377         function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
378             return oraclize.getPrice(datasource, gaslimit);
379         }
380 
381 
382         function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
383             uint price = oraclize.getPrice(datasource);
384             if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
385             return oraclize.query.value(price)(0, datasource, arg);
386         }
387         function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
388             uint price = oraclize.getPrice(datasource);
389             if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
390             return oraclize.query.value(price)(timestamp, datasource, arg);
391         }
392         function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
393             uint price = oraclize.getPrice(datasource, gaslimit);
394             if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
395             return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
396         }
397         function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
398             uint price = oraclize.getPrice(datasource, gaslimit);
399             if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
400             return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
401         }
402         function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
403             uint price = oraclize.getPrice(datasource);
404             if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
405             return oraclize.query2.value(price)(0, datasource, arg1, arg2);
406         }
407         function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
408             uint price = oraclize.getPrice(datasource);
409             if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
410             return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
411         }
412         function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
413             uint price = oraclize.getPrice(datasource, gaslimit);
414             if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
415             return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
416         }
417         function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
418             uint price = oraclize.getPrice(datasource, gaslimit);
419             if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
420             return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
421         }
422         function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
423             uint price = oraclize.getPrice(datasource);
424             if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
425             bytes memory args = stra2cbor(argN);
426             return oraclize.queryN.value(price)(0, datasource, args);
427         }
428         function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
429             uint price = oraclize.getPrice(datasource);
430             if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
431             bytes memory args = stra2cbor(argN);
432             return oraclize.queryN.value(price)(timestamp, datasource, args);
433         }
434         function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
435             uint price = oraclize.getPrice(datasource, gaslimit);
436             if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
437             bytes memory args = stra2cbor(argN);
438             return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
439         }
440         function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
441             uint price = oraclize.getPrice(datasource, gaslimit);
442             if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
443             bytes memory args = stra2cbor(argN);
444             return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
445         }
446         function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
447             string[] memory dynargs = new string[](1);
448             dynargs[0] = args[0];
449             return oraclize_query(datasource, dynargs);
450         }
451         function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
452             string[] memory dynargs = new string[](1);
453             dynargs[0] = args[0];
454             return oraclize_query(timestamp, datasource, dynargs);
455         }
456         function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
457             string[] memory dynargs = new string[](1);
458             dynargs[0] = args[0];
459             return oraclize_query(timestamp, datasource, dynargs, gaslimit);
460         }
461         function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
462             string[] memory dynargs = new string[](1);
463             dynargs[0] = args[0];
464             return oraclize_query(datasource, dynargs, gaslimit);
465         }
466 
467         function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
468             string[] memory dynargs = new string[](2);
469             dynargs[0] = args[0];
470             dynargs[1] = args[1];
471             return oraclize_query(datasource, dynargs);
472         }
473         function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
474             string[] memory dynargs = new string[](2);
475             dynargs[0] = args[0];
476             dynargs[1] = args[1];
477             return oraclize_query(timestamp, datasource, dynargs);
478         }
479         function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
480             string[] memory dynargs = new string[](2);
481             dynargs[0] = args[0];
482             dynargs[1] = args[1];
483             return oraclize_query(timestamp, datasource, dynargs, gaslimit);
484         }
485         function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
486             string[] memory dynargs = new string[](2);
487             dynargs[0] = args[0];
488             dynargs[1] = args[1];
489             return oraclize_query(datasource, dynargs, gaslimit);
490         }
491         function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
492             string[] memory dynargs = new string[](3);
493             dynargs[0] = args[0];
494             dynargs[1] = args[1];
495             dynargs[2] = args[2];
496             return oraclize_query(datasource, dynargs);
497         }
498         function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
499             string[] memory dynargs = new string[](3);
500             dynargs[0] = args[0];
501             dynargs[1] = args[1];
502             dynargs[2] = args[2];
503             return oraclize_query(timestamp, datasource, dynargs);
504         }
505         function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
506             string[] memory dynargs = new string[](3);
507             dynargs[0] = args[0];
508             dynargs[1] = args[1];
509             dynargs[2] = args[2];
510             return oraclize_query(timestamp, datasource, dynargs, gaslimit);
511         }
512         function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
513             string[] memory dynargs = new string[](3);
514             dynargs[0] = args[0];
515             dynargs[1] = args[1];
516             dynargs[2] = args[2];
517             return oraclize_query(datasource, dynargs, gaslimit);
518         }
519 
520         function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
521             string[] memory dynargs = new string[](4);
522             dynargs[0] = args[0];
523             dynargs[1] = args[1];
524             dynargs[2] = args[2];
525             dynargs[3] = args[3];
526             return oraclize_query(datasource, dynargs);
527         }
528         function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
529             string[] memory dynargs = new string[](4);
530             dynargs[0] = args[0];
531             dynargs[1] = args[1];
532             dynargs[2] = args[2];
533             dynargs[3] = args[3];
534             return oraclize_query(timestamp, datasource, dynargs);
535         }
536         function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
537             string[] memory dynargs = new string[](4);
538             dynargs[0] = args[0];
539             dynargs[1] = args[1];
540             dynargs[2] = args[2];
541             dynargs[3] = args[3];
542             return oraclize_query(timestamp, datasource, dynargs, gaslimit);
543         }
544         function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
545             string[] memory dynargs = new string[](4);
546             dynargs[0] = args[0];
547             dynargs[1] = args[1];
548             dynargs[2] = args[2];
549             dynargs[3] = args[3];
550             return oraclize_query(datasource, dynargs, gaslimit);
551         }
552         function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
553             string[] memory dynargs = new string[](5);
554             dynargs[0] = args[0];
555             dynargs[1] = args[1];
556             dynargs[2] = args[2];
557             dynargs[3] = args[3];
558             dynargs[4] = args[4];
559             return oraclize_query(datasource, dynargs);
560         }
561         function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
562             string[] memory dynargs = new string[](5);
563             dynargs[0] = args[0];
564             dynargs[1] = args[1];
565             dynargs[2] = args[2];
566             dynargs[3] = args[3];
567             dynargs[4] = args[4];
568             return oraclize_query(timestamp, datasource, dynargs);
569         }
570         function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
571             string[] memory dynargs = new string[](5);
572             dynargs[0] = args[0];
573             dynargs[1] = args[1];
574             dynargs[2] = args[2];
575             dynargs[3] = args[3];
576             dynargs[4] = args[4];
577             return oraclize_query(timestamp, datasource, dynargs, gaslimit);
578         }
579         function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
580             string[] memory dynargs = new string[](5);
581             dynargs[0] = args[0];
582             dynargs[1] = args[1];
583             dynargs[2] = args[2];
584             dynargs[3] = args[3];
585             dynargs[4] = args[4];
586             return oraclize_query(datasource, dynargs, gaslimit);
587         }
588         function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
589             uint price = oraclize.getPrice(datasource);
590             if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
591             bytes memory args = ba2cbor(argN);
592             return oraclize.queryN.value(price)(0, datasource, args);
593         }
594         function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
595             uint price = oraclize.getPrice(datasource);
596             if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
597             bytes memory args = ba2cbor(argN);
598             return oraclize.queryN.value(price)(timestamp, datasource, args);
599         }
600         function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
601             uint price = oraclize.getPrice(datasource, gaslimit);
602             if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
603             bytes memory args = ba2cbor(argN);
604             return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
605         }
606         function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
607             uint price = oraclize.getPrice(datasource, gaslimit);
608             if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
609             bytes memory args = ba2cbor(argN);
610             return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
611         }
612         function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
613             bytes[] memory dynargs = new bytes[](1);
614             dynargs[0] = args[0];
615             return oraclize_query(datasource, dynargs);
616         }
617         function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
618             bytes[] memory dynargs = new bytes[](1);
619             dynargs[0] = args[0];
620             return oraclize_query(timestamp, datasource, dynargs);
621         }
622         function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
623             bytes[] memory dynargs = new bytes[](1);
624             dynargs[0] = args[0];
625             return oraclize_query(timestamp, datasource, dynargs, gaslimit);
626         }
627         function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
628             bytes[] memory dynargs = new bytes[](1);
629             dynargs[0] = args[0];
630             return oraclize_query(datasource, dynargs, gaslimit);
631         }
632 
633         function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
634             bytes[] memory dynargs = new bytes[](2);
635             dynargs[0] = args[0];
636             dynargs[1] = args[1];
637             return oraclize_query(datasource, dynargs);
638         }
639         function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
640             bytes[] memory dynargs = new bytes[](2);
641             dynargs[0] = args[0];
642             dynargs[1] = args[1];
643             return oraclize_query(timestamp, datasource, dynargs);
644         }
645         function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
646             bytes[] memory dynargs = new bytes[](2);
647             dynargs[0] = args[0];
648             dynargs[1] = args[1];
649             return oraclize_query(timestamp, datasource, dynargs, gaslimit);
650         }
651         function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
652             bytes[] memory dynargs = new bytes[](2);
653             dynargs[0] = args[0];
654             dynargs[1] = args[1];
655             return oraclize_query(datasource, dynargs, gaslimit);
656         }
657         function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
658             bytes[] memory dynargs = new bytes[](3);
659             dynargs[0] = args[0];
660             dynargs[1] = args[1];
661             dynargs[2] = args[2];
662             return oraclize_query(datasource, dynargs);
663         }
664         function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
665             bytes[] memory dynargs = new bytes[](3);
666             dynargs[0] = args[0];
667             dynargs[1] = args[1];
668             dynargs[2] = args[2];
669             return oraclize_query(timestamp, datasource, dynargs);
670         }
671         function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
672             bytes[] memory dynargs = new bytes[](3);
673             dynargs[0] = args[0];
674             dynargs[1] = args[1];
675             dynargs[2] = args[2];
676             return oraclize_query(timestamp, datasource, dynargs, gaslimit);
677         }
678         function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
679             bytes[] memory dynargs = new bytes[](3);
680             dynargs[0] = args[0];
681             dynargs[1] = args[1];
682             dynargs[2] = args[2];
683             return oraclize_query(datasource, dynargs, gaslimit);
684         }
685 
686         function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
687             bytes[] memory dynargs = new bytes[](4);
688             dynargs[0] = args[0];
689             dynargs[1] = args[1];
690             dynargs[2] = args[2];
691             dynargs[3] = args[3];
692             return oraclize_query(datasource, dynargs);
693         }
694         function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
695             bytes[] memory dynargs = new bytes[](4);
696             dynargs[0] = args[0];
697             dynargs[1] = args[1];
698             dynargs[2] = args[2];
699             dynargs[3] = args[3];
700             return oraclize_query(timestamp, datasource, dynargs);
701         }
702         function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
703             bytes[] memory dynargs = new bytes[](4);
704             dynargs[0] = args[0];
705             dynargs[1] = args[1];
706             dynargs[2] = args[2];
707             dynargs[3] = args[3];
708             return oraclize_query(timestamp, datasource, dynargs, gaslimit);
709         }
710         function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
711             bytes[] memory dynargs = new bytes[](4);
712             dynargs[0] = args[0];
713             dynargs[1] = args[1];
714             dynargs[2] = args[2];
715             dynargs[3] = args[3];
716             return oraclize_query(datasource, dynargs, gaslimit);
717         }
718         function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
719             bytes[] memory dynargs = new bytes[](5);
720             dynargs[0] = args[0];
721             dynargs[1] = args[1];
722             dynargs[2] = args[2];
723             dynargs[3] = args[3];
724             dynargs[4] = args[4];
725             return oraclize_query(datasource, dynargs);
726         }
727         function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
728             bytes[] memory dynargs = new bytes[](5);
729             dynargs[0] = args[0];
730             dynargs[1] = args[1];
731             dynargs[2] = args[2];
732             dynargs[3] = args[3];
733             dynargs[4] = args[4];
734             return oraclize_query(timestamp, datasource, dynargs);
735         }
736         function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
737             bytes[] memory dynargs = new bytes[](5);
738             dynargs[0] = args[0];
739             dynargs[1] = args[1];
740             dynargs[2] = args[2];
741             dynargs[3] = args[3];
742             dynargs[4] = args[4];
743             return oraclize_query(timestamp, datasource, dynargs, gaslimit);
744         }
745         function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
746             bytes[] memory dynargs = new bytes[](5);
747             dynargs[0] = args[0];
748             dynargs[1] = args[1];
749             dynargs[2] = args[2];
750             dynargs[3] = args[3];
751             dynargs[4] = args[4];
752             return oraclize_query(datasource, dynargs, gaslimit);
753         }
754 
755         function oraclize_cbAddress() oraclizeAPI internal returns (address){
756             return oraclize.cbAddress();
757         }
758         function oraclize_setProof(byte proofP) oraclizeAPI internal {
759             return oraclize.setProofType(proofP);
760         }
761         function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
762             return oraclize.setCustomGasPrice(gasPrice);
763         }
764 
765         function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
766             return oraclize.randomDS_getSessionPubKeyHash();
767         }
768 
769         function getCodeSize(address _addr) view internal returns(uint _size) {
770             assembly {
771                 _size := extcodesize(_addr)
772             }
773         }
774 
775         function parseAddr(string _a) internal pure returns (address){
776             bytes memory tmp = bytes(_a);
777             uint160 iaddr = 0;
778             uint160 b1;
779             uint160 b2;
780             for (uint i=2; i<2+2*20; i+=2){
781                 iaddr *= 256;
782                 b1 = uint160(tmp[i]);
783                 b2 = uint160(tmp[i+1]);
784                 if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
785                 else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
786                 else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
787                 if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
788                 else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
789                 else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
790                 iaddr += (b1*16+b2);
791             }
792             return address(iaddr);
793         }
794 
795         function strCompare(string _a, string _b) internal pure returns (int) {
796             bytes memory a = bytes(_a);
797             bytes memory b = bytes(_b);
798             uint minLength = a.length;
799             if (b.length < minLength) minLength = b.length;
800             for (uint i = 0; i < minLength; i ++)
801                 if (a[i] < b[i])
802                     return -1;
803                 else if (a[i] > b[i])
804                     return 1;
805             if (a.length < b.length)
806                 return -1;
807             else if (a.length > b.length)
808                 return 1;
809             else
810                 return 0;
811         }
812 
813         function indexOf(string _haystack, string _needle) internal pure returns (int) {
814             bytes memory h = bytes(_haystack);
815             bytes memory n = bytes(_needle);
816             if(h.length < 1 || n.length < 1 || (n.length > h.length))
817                 return -1;
818             else if(h.length > (2**128 -1))
819                 return -1;
820             else
821             {
822                 uint subindex = 0;
823                 for (uint i = 0; i < h.length; i ++)
824                 {
825                     if (h[i] == n[0])
826                     {
827                         subindex = 1;
828                         while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
829                         {
830                             subindex++;
831                         }
832                         if(subindex == n.length)
833                             return int(i);
834                     }
835                 }
836                 return -1;
837             }
838         }
839 
840         function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
841             bytes memory _ba = bytes(_a);
842             bytes memory _bb = bytes(_b);
843             bytes memory _bc = bytes(_c);
844             bytes memory _bd = bytes(_d);
845             bytes memory _be = bytes(_e);
846             string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
847             bytes memory babcde = bytes(abcde);
848             uint k = 0;
849             for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
850             for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
851             for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
852             for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
853             for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
854             return string(babcde);
855         }
856 
857         function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
858             return strConcat(_a, _b, _c, _d, "");
859         }
860 
861         function strConcat(string _a, string _b, string _c) internal pure returns (string) {
862             return strConcat(_a, _b, _c, "", "");
863         }
864 
865         function strConcat(string _a, string _b) internal pure returns (string) {
866             return strConcat(_a, _b, "", "", "");
867         }
868 
869         // parseInt
870         function parseInt(string _a) internal pure returns (uint) {
871             return parseInt(_a, 0);
872         }
873 
874         // parseInt(parseFloat*10^_b)
875         function parseInt(string _a, uint _b) internal pure returns (uint) {
876             bytes memory bresult = bytes(_a);
877             uint mint = 0;
878             bool decimals = false;
879             for (uint i=0; i<bresult.length; i++){
880                 if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
881                     if (decimals){
882                     if (_b == 0) break;
883                         else _b--;
884                     }
885                     mint *= 10;
886                     mint += uint(bresult[i]) - 48;
887                 } else if (bresult[i] == 46) decimals = true;
888             }
889             if (_b > 0) mint *= 10**_b;
890             return mint;
891         }
892 
893         function uint2str(uint i) internal pure returns (string){
894             if (i == 0) return "0";
895             uint j = i;
896             uint len;
897             while (j != 0){
898                 len++;
899                 j /= 10;
900             }
901             bytes memory bstr = new bytes(len);
902             uint k = len - 1;
903             while (i != 0){
904                 bstr[k--] = byte(48 + i % 10);
905                 i /= 10;
906             }
907             return string(bstr);
908         }
909 
910         using CBOR for Buffer.buffer;
911         function stra2cbor(string[] arr) internal pure returns (bytes) {
912             safeMemoryCleaner();
913             Buffer.buffer memory buf;
914             Buffer.init(buf, 1024);
915             buf.startArray();
916             for (uint i = 0; i < arr.length; i++) {
917                 buf.encodeString(arr[i]);
918             }
919             buf.endSequence();
920             return buf.buf;
921         }
922 
923         function ba2cbor(bytes[] arr) internal pure returns (bytes) {
924             safeMemoryCleaner();
925             Buffer.buffer memory buf;
926             Buffer.init(buf, 1024);
927             buf.startArray();
928             for (uint i = 0; i < arr.length; i++) {
929                 buf.encodeBytes(arr[i]);
930             }
931             buf.endSequence();
932             return buf.buf;
933         }
934 
935         string oraclize_network_name;
936         function oraclize_setNetworkName(string _network_name) internal {
937             oraclize_network_name = _network_name;
938         }
939 
940         function oraclize_getNetworkName() internal view returns (string) {
941             return oraclize_network_name;
942         }
943 
944         function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
945             require((_nbytes > 0) && (_nbytes <= 32));
946             // Convert from seconds to ledger timer ticks
947             _delay *= 10;
948             bytes memory nbytes = new bytes(1);
949             nbytes[0] = byte(_nbytes);
950             bytes memory unonce = new bytes(32);
951             bytes memory sessionKeyHash = new bytes(32);
952             bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
953             assembly {
954                 mstore(unonce, 0x20)
955                 // the following variables can be relaxed
956                 // check relaxed random contract under ethereum-examples repo
957                 // for an idea on how to override and replace comit hash vars
958                 mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
959                 mstore(sessionKeyHash, 0x20)
960                 mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
961             }
962             bytes memory delay = new bytes(32);
963             assembly {
964                 mstore(add(delay, 0x20), _delay)
965             }
966 
967             bytes memory delay_bytes8 = new bytes(8);
968             copyBytes(delay, 24, 8, delay_bytes8, 0);
969 
970             bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
971             bytes32 queryId = oraclize_query("random", args, _customGasLimit);
972 
973             bytes memory delay_bytes8_left = new bytes(8);
974 
975             assembly {
976                 let x := mload(add(delay_bytes8, 0x20))
977                 mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
978                 mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
979                 mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
980                 mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
981                 mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
982                 mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
983                 mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
984                 mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
985 
986             }
987 
988             oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
989             return queryId;
990         }
991 
992         function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
993             oraclize_randomDS_args[queryId] = commitment;
994         }
995 
996         mapping(bytes32=>bytes32) oraclize_randomDS_args;
997         mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
998 
999         function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1000             bool sigok;
1001             address signer;
1002 
1003             bytes32 sigr;
1004             bytes32 sigs;
1005 
1006             bytes memory sigr_ = new bytes(32);
1007             uint offset = 4+(uint(dersig[3]) - 0x20);
1008             sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1009             bytes memory sigs_ = new bytes(32);
1010             offset += 32 + 2;
1011             sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1012 
1013             assembly {
1014                 sigr := mload(add(sigr_, 32))
1015                 sigs := mload(add(sigs_, 32))
1016             }
1017 
1018 
1019             (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1020             if (address(keccak256(pubkey)) == signer) return true;
1021             else {
1022                 (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1023                 return (address(keccak256(pubkey)) == signer);
1024             }
1025         }
1026 
1027         function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1028             bool sigok;
1029 
1030             // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1031             bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1032             copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1033 
1034             bytes memory appkey1_pubkey = new bytes(64);
1035             copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1036 
1037             bytes memory tosign2 = new bytes(1+65+32);
1038             tosign2[0] = byte(1); //role
1039             copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1040             bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1041             copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1042             sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1043 
1044             if (sigok == false) return false;
1045 
1046 
1047             // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1048             bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1049 
1050             bytes memory tosign3 = new bytes(1+65);
1051             tosign3[0] = 0xFE;
1052             copyBytes(proof, 3, 65, tosign3, 1);
1053 
1054             bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1055             copyBytes(proof, 3+65, sig3.length, sig3, 0);
1056 
1057             sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1058 
1059             return sigok;
1060         }
1061 
1062         modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1063             // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1064             require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1065 
1066             bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1067             require(proofVerified);
1068 
1069             _;
1070         }
1071 
1072         function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1073             // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1074             if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1075 
1076             bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1077             if (proofVerified == false) return 2;
1078 
1079             return 0;
1080         }
1081 
1082         function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1083             bool match_ = true;
1084 
1085             require(prefix.length == n_random_bytes);
1086 
1087             for (uint256 i=0; i< n_random_bytes; i++) {
1088                 if (content[i] != prefix[i]) match_ = false;
1089             }
1090 
1091             return match_;
1092         }
1093 
1094         function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1095 
1096             // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1097             uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1098             bytes memory keyhash = new bytes(32);
1099             copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1100             if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(context_name, queryId)))))) return false;
1101 
1102             bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1103             copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1104 
1105             // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1106             if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1107 
1108             // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1109             // This is to verify that the computed args match with the ones specified in the query.
1110             bytes memory commitmentSlice1 = new bytes(8+1+32);
1111             copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1112 
1113             bytes memory sessionPubkey = new bytes(64);
1114             uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1115             copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1116 
1117             bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1118             if (oraclize_randomDS_args[queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))){ //unonce, nbytes and sessionKeyHash match
1119                 delete oraclize_randomDS_args[queryId];
1120             } else return false;
1121 
1122 
1123             // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1124             bytes memory tosign1 = new bytes(32+8+1+32);
1125             copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1126             if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1127 
1128             // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1129             if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1130                 oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1131             }
1132 
1133             return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1134         }
1135 
1136         // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1137         function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1138             uint minLength = length + toOffset;
1139 
1140             // Buffer too small
1141             require(to.length >= minLength); // Should be a better way?
1142 
1143             // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1144             uint i = 32 + fromOffset;
1145             uint j = 32 + toOffset;
1146 
1147             while (i < (32 + fromOffset + length)) {
1148                 assembly {
1149                     let tmp := mload(add(from, i))
1150                     mstore(add(to, j), tmp)
1151                 }
1152                 i += 32;
1153                 j += 32;
1154             }
1155 
1156             return to;
1157         }
1158 
1159         // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1160         // Duplicate Solidity's ecrecover, but catching the CALL return value
1161         function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1162             // We do our own memory management here. Solidity uses memory offset
1163             // 0x40 to store the current end of memory. We write past it (as
1164             // writes are memory extensions), but don't update the offset so
1165             // Solidity will reuse it. The memory used here is only needed for
1166             // this context.
1167 
1168             // FIXME: inline assembly can't access return values
1169             bool ret;
1170             address addr;
1171 
1172             assembly {
1173                 let size := mload(0x40)
1174                 mstore(size, hash)
1175                 mstore(add(size, 32), v)
1176                 mstore(add(size, 64), r)
1177                 mstore(add(size, 96), s)
1178 
1179                 // NOTE: we can reuse the request memory because we deal with
1180                 //       the return code
1181                 ret := call(3000, 1, 0, size, 128, size, 32)
1182                 addr := mload(size)
1183             }
1184 
1185             return (ret, addr);
1186         }
1187 
1188         // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1189         function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1190             bytes32 r;
1191             bytes32 s;
1192             uint8 v;
1193 
1194             if (sig.length != 65)
1195             return (false, 0);
1196 
1197             // The signature format is a compact form of:
1198             //   {bytes32 r}{bytes32 s}{uint8 v}
1199             // Compact means, uint8 is not padded to 32 bytes.
1200             assembly {
1201                 r := mload(add(sig, 32))
1202                 s := mload(add(sig, 64))
1203 
1204                 // Here we are loading the last 32 bytes. We exploit the fact that
1205                 // 'mload' will pad with zeroes if we overread.
1206                 // There is no 'mload8' to do this, but that would be nicer.
1207                 v := byte(0, mload(add(sig, 96)))
1208 
1209                 // Alternative solution:
1210                 // 'byte' is not working due to the Solidity parser, so lets
1211                 // use the second best option, 'and'
1212                 // v := and(mload(add(sig, 65)), 255)
1213             }
1214 
1215             // albeit non-transactional signatures are not specified by the YP, one would expect it
1216             // to match the YP range of [27, 28]
1217             //
1218             // geth uses [0, 1] and some clients have followed. This might change, see:
1219             //  https://github.com/ethereum/go-ethereum/issues/2053
1220             if (v < 27)
1221             v += 27;
1222 
1223             if (v != 27 && v != 28)
1224                 return (false, 0);
1225 
1226             return safer_ecrecover(hash, v, r, s);
1227         }
1228 
1229         function safeMemoryCleaner() internal pure {
1230             assembly {
1231                 let fmem := mload(0x40)
1232                 codecopy(fmem, codesize, sub(msize, fmem))
1233             }
1234         }
1235 
1236     }
1237 // </ORACLIZE_API>
1238 
1239 
1240 contract UBets is usingOraclize {
1241     address public owner;
1242 
1243     struct Game {
1244         uint bet;
1245         uint max_players;
1246         bool finish;
1247         address[] players;
1248         uint[] numbers;
1249         uint[] uniq_numbers;
1250     }
1251 
1252     uint public min_bet = 0.1 ether;
1253     uint constant public min_players = 2;
1254     uint public max_players = 10;
1255     uint constant public min_number = 0;
1256     uint constant public max_number = 9;
1257     uint public oraclize_gas_limit = 350000;
1258 
1259     uint public commision = 10;
1260     uint public referer_commision = 1;
1261 
1262     Game[] public games;
1263     mapping(bytes32 => uint) public await_finish;
1264     mapping(uint => uint) public await_finish_block;
1265     mapping(address => address) public referers;
1266 
1267     event NewGame(uint indexed game_id, address indexed author, uint bet, uint max_players);
1268     event Bet(uint indexed game_id, address indexed addr, uint index, uint number);
1269     event Play(uint indexed game_id, bytes32 indexed id);
1270     event Winner(uint indexed game_id, address indexed winner, uint index, uint win);
1271     event RefererPayout(uint indexed game_id, address indexed winner, address indexed referer, uint payout);
1272     event GameOver(uint indexed game_id, uint[] numbers);
1273     event Refund(uint indexed game_id, address indexed addr, uint bet);
1274     event RefundGame(uint indexed game_id);
1275 
1276     modifier onlyOwner() {
1277         require(msg.sender == owner, "Access denied");
1278         _;
1279     }
1280 
1281     constructor() public {
1282         owner = msg.sender;
1283         oraclize_setProof(proofType_Ledger);
1284     }
1285 
1286     function() payable external {
1287         revert();
1288     }
1289 
1290     function donate() payable external {
1291         
1292     }
1293 
1294     function inArray(uint[] memory arr, uint number) private pure returns(bool) {
1295         for(uint i = 0; i < arr.length; i++) {
1296             if(arr[i] == number) return true;
1297         }
1298         
1299         return false;
1300     }
1301     
1302     function __callback(bytes32 id, string res, bytes memory proof) public {
1303         require(msg.sender == oraclize_cbAddress(), "Permission denied");
1304         require(oraclize_randomDS_proofVerify__returnCode(id, res, proof) == 0, "No proof random number");
1305         require(await_finish_block[await_finish[id]] < block.number, "No proof block");
1306 
1307         Game storage game = games[await_finish[id]];
1308 
1309         require(game.bet > 0, "Game not found");
1310         require(!game.finish, "Game over");
1311 
1312         uint seed = uint(keccak256(abi.encodePacked(res)));
1313 
1314         uint[] memory numbers = new uint[](game.uniq_numbers.length > 1 ? game.uniq_numbers.length - 1 : 1);
1315         for(uint i = 0; i < numbers.length; i++) {
1316             numbers[i] = game.uniq_numbers[seed % game.uniq_numbers.length];
1317             seed = seed / game.uniq_numbers.length;
1318         }
1319 
1320         _finishGame(await_finish[id], numbers);
1321 
1322         delete await_finish_block[await_finish[id]];
1323         delete await_finish[id];
1324     }
1325 
1326     function _joinGame(uint game_id, address player, uint bet, uint number, address referer) private {
1327         require(games[game_id].bet > 0, "Game not found");
1328 
1329         Game storage game = games[game_id];
1330 
1331         require(!game.finish, "Game over");
1332         require(bet == game.bet, "Insufficient funds");
1333         require(game.max_players > game.players.length, "Bets are no longer accepted");
1334         require(number >= min_number && number <= max_number, "Number does not match the interval");
1335         require(!(game.max_players == game.players.length - 1 && game.uniq_numbers.length < 2 && inArray(game.uniq_numbers, number)), "Number already exists");
1336 
1337         for(uint i = 0; i < game.numbers.length; i++) {
1338             if(game.numbers[i] == number && game.players[i] == player) revert("Number already exists");
1339         }
1340 
1341         game.players.push(player);
1342         game.numbers.push(number);
1343 
1344         if(!inArray(game.uniq_numbers, number)) {
1345             game.uniq_numbers.push(number);
1346         }
1347 
1348         if(referer != address(0) && referers[player] == address(0)) {
1349             referers[player] = referer;
1350         }
1351 
1352         emit Bet(game_id, player, game.players.length - 1, number);
1353 
1354         if(game.max_players == game.players.length) {
1355             _playGame(game_id);
1356         }
1357     }
1358 
1359     function _playGame(uint game_id) private {
1360         require(games[game_id].bet > 0, "Game not found");
1361         require(!games[game_id].finish, "Game over");
1362         require(games[game_id].max_players == games[game_id].players.length, "The game has free slots");
1363         require(oraclize_getPrice("random", oraclize_gas_limit) <= address(this).balance, "Insufficient funds");
1364 
1365         bytes32 id = oraclize_newRandomDSQuery(0, 32, oraclize_gas_limit);
1366         
1367         await_finish[id] = game_id;
1368         await_finish_block[game_id] = block.number;
1369 
1370         emit Play(game_id, id);
1371     }
1372 
1373     function _finishGame(uint game_id, uint[] memory numbers) private {
1374         require(games[game_id].bet > 0, "Game not found");
1375 
1376         Game storage game = games[game_id];
1377 
1378         require(!game.finish, "Game over");
1379         require(game.max_players == game.players.length, "The game has free slots");
1380         require(numbers.length == (game.uniq_numbers.length > 1 ? game.uniq_numbers.length - 1 : 1), "Incorect winning numbers");
1381         
1382         uint bank = game.bet * game.max_players;
1383         uint bank_use = oraclize_getPrice("random", oraclize_gas_limit);
1384         uint num_payout = (bank * (100 - commision) / 100) / numbers.length;
1385         
1386         for(uint n = 0; n < numbers.length; n++) {
1387             uint num_w = 0;
1388 
1389             for(uint j = 0; j < game.numbers.length; j++) {
1390                 if(numbers[n] == game.numbers[j]) {
1391                     num_w++;
1392                 }
1393             }
1394 
1395             uint payout = num_payout / num_w;
1396 
1397             for(uint p = 0; p < game.players.length; p++) {
1398                 if(numbers[n] == game.numbers[p]) {
1399                     game.players[p].send(payout);
1400                     bank_use += payout;
1401 
1402                     emit Winner(game_id, game.players[p], p, payout);
1403 
1404                     if(referers[game.players[p]] != address(0) && referer_commision > 0) {
1405                         uint referer_payout = payout * referer_commision / 100;
1406 
1407                         referers[game.players[p]].send(referer_payout);
1408                         bank_use += referer_payout;
1409                         
1410                         emit RefererPayout(game_id, game.players[p], referers[game.players[p]], referer_payout);
1411                     }
1412                 }
1413             }
1414         }
1415 
1416         if(bank > bank_use) {
1417             owner.transfer(bank - bank_use);
1418         }
1419 
1420         game.finish = true;
1421 
1422         emit GameOver(game_id, numbers);
1423     }
1424 
1425     function newGame(uint players, uint number, address referer) payable external {
1426         require(msg.value >= min_bet, "Min bet of 0.1 ether");
1427         require(players >= min_players && players <= max_players, "Players does not match the interval");
1428         require(number >= min_number && number <= max_number, "Number does not match the interval");
1429 
1430         address[] memory players_arr;
1431         uint[] memory numbers_arr;
1432         uint[] memory uniq_numbers;
1433 
1434         games.push(Game({
1435             bet: msg.value,
1436             max_players: players,
1437             finish: false,
1438             players: players_arr,
1439             numbers: numbers_arr,
1440             uniq_numbers: uniq_numbers
1441         }));
1442 
1443         emit NewGame(games.length - 1, msg.sender, msg.value, players);
1444 
1445         _joinGame(games.length - 1, msg.sender, msg.value, number, referer);
1446     }
1447 
1448     function joinGame(uint game_id, uint number, address referer) payable external {
1449         _joinGame(game_id, msg.sender, msg.value, number, referer);
1450     }
1451     
1452     function refundGame(uint game_id) onlyOwner external {
1453         require(games[game_id].bet > 0, "Game not found");
1454         require(await_finish_block[game_id] == 0 || await_finish_block[game_id] < block.number - 1000, "Game not found");
1455 
1456         Game storage game = games[game_id];
1457 
1458         require(!game.finish, "Game over");
1459 
1460         game.finish = true;
1461 
1462         for(uint i = 0; i < game.players.length; i++) {
1463             game.players[i].send(game.bet);
1464 
1465             emit Refund(game_id, game.players[i], game.bet);
1466         }
1467 
1468         emit RefundGame(game_id);
1469     }
1470  
1471     function setOraclizeGasLimit(uint value) onlyOwner external {
1472         require(value >= 21000 && value <= 5000000, "Value does not match the interval");
1473 
1474         oraclize_gas_limit = value;
1475     }
1476 
1477     function setOraclizeGasPrice(uint value) onlyOwner external {
1478         require(value >= 1000000000 && value <= 100000000000, "Value does not match the interval");
1479 
1480         oraclize_setCustomGasPrice(value);
1481     }
1482 
1483     function setOwner(address value) onlyOwner external {
1484         require(value != address(0), "Zero address");
1485         
1486         owner = value;
1487     }
1488 }