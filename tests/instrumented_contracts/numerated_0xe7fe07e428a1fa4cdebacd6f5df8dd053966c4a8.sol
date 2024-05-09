1 pragma solidity ^0.4.24;
2 /**
3  * Copyright YHT Community.
4  * This software is copyrighted by the YHT community.
5  * Prohibits any unauthorized copying and modification.
6  * It is allowed through ABI calls.
7  */
8 
9 // <ORACLIZE_API>
10 /*
11 Copyright (c) 2015-2016 Oraclize SRL
12 Copyright (c) 2016 Oraclize LTD
13 
14 
15 
16 Permission is hereby granted, free of charge, to any person obtaining a copy
17 of this software and associated documentation files (the "Software"), to deal
18 in the Software without restriction, including without limitation the rights
19 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
20 copies of the Software, and to permit persons to whom the Software is
21 furnished to do so, subject to the following conditions:
22 
23 
24 
25 The above copyright notice and this permission notice shall be included in
26 all copies or substantial portions of the Software.
27 
28 
29 
30 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
31 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
32 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
33 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
34 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
35 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
36 THE SOFTWARE.
37 */
38 
39 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
40 
41 pragma solidity >=0.4.18;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
42 
43 contract OraclizeI {
44     address public cbAddress;
45     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
46     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
47     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
48     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
49     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
50     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
51     function getPrice(string _datasource) public returns (uint _dsprice);
52     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
53     function setProofType(byte _proofType) external;
54     function setCustomGasPrice(uint _gasPrice) external;
55     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
56 }
57 
58 contract OraclizeAddrResolverI {
59     function getAddress() public returns (address _addr);
60 }
61 
62 /*
63 Begin solidity-cborutils
64 
65 https://github.com/smartcontractkit/solidity-cborutils
66 
67 MIT License
68 
69 Copyright (c) 2018 SmartContract ChainLink, Ltd.
70 
71 Permission is hereby granted, free of charge, to any person obtaining a copy
72 of this software and associated documentation files (the "Software"), to deal
73 in the Software without restriction, including without limitation the rights
74 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
75 copies of the Software, and to permit persons to whom the Software is
76 furnished to do so, subject to the following conditions:
77 
78 The above copyright notice and this permission notice shall be included in all
79 copies or substantial portions of the Software.
80 
81 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
82 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
83 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
84 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
85 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
86 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
87 SOFTWARE.
88  */
89 
90 library Buffer {
91     struct buffer {
92         bytes buf;
93         uint capacity;
94     }
95 
96     function init(buffer memory buf, uint _capacity) internal pure {
97         uint capacity = _capacity;
98         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
99         // Allocate space for the buffer data
100         buf.capacity = capacity;
101         assembly {
102             let ptr := mload(0x40)
103             mstore(buf, ptr)
104             mstore(ptr, 0)
105             mstore(0x40, add(ptr, capacity))
106         }
107     }
108 
109     function resize(buffer memory buf, uint capacity) private pure {
110         bytes memory oldbuf = buf.buf;
111         init(buf, capacity);
112         append(buf, oldbuf);
113     }
114 
115     function max(uint a, uint b) private pure returns(uint) {
116         if(a > b) {
117             return a;
118         }
119         return b;
120     }
121 
122     /**
123      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
124      *      would exceed the capacity of the buffer.
125      * @param buf The buffer to append to.
126      * @param data The data to append.
127      * @return The original buffer.
128      */
129     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
130         if(data.length + buf.buf.length > buf.capacity) {
131             resize(buf, max(buf.capacity, data.length) * 2);
132         }
133 
134         uint dest;
135         uint src;
136         uint len = data.length;
137         assembly {
138             // Memory address of the buffer data
139             let bufptr := mload(buf)
140             // Length of existing buffer data
141             let buflen := mload(bufptr)
142             // Start address = buffer address + buffer length + sizeof(buffer length)
143             dest := add(add(bufptr, buflen), 32)
144             // Update buffer length
145             mstore(bufptr, add(buflen, mload(data)))
146             src := add(data, 32)
147         }
148 
149         // Copy word-length chunks while possible
150         for(; len >= 32; len -= 32) {
151             assembly {
152                 mstore(dest, mload(src))
153             }
154             dest += 32;
155             src += 32;
156         }
157 
158         // Copy remaining bytes
159         uint mask = 256 ** (32 - len) - 1;
160         assembly {
161             let srcpart := and(mload(src), not(mask))
162             let destpart := and(mload(dest), mask)
163             mstore(dest, or(destpart, srcpart))
164         }
165 
166         return buf;
167     }
168 
169     /**
170      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
171      * exceed the capacity of the buffer.
172      * @param buf The buffer to append to.
173      * @param data The data to append.
174      * @return The original buffer.
175      */
176     function append(buffer memory buf, uint8 data) internal pure {
177         if(buf.buf.length + 1 > buf.capacity) {
178             resize(buf, buf.capacity * 2);
179         }
180 
181         assembly {
182             // Memory address of the buffer data
183             let bufptr := mload(buf)
184             // Length of existing buffer data
185             let buflen := mload(bufptr)
186             // Address = buffer address + buffer length + sizeof(buffer length)
187             let dest := add(add(bufptr, buflen), 32)
188             mstore8(dest, data)
189             // Update buffer length
190             mstore(bufptr, add(buflen, 1))
191         }
192     }
193 
194     /**
195      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
196      * exceed the capacity of the buffer.
197      * @param buf The buffer to append to.
198      * @param data The data to append.
199      * @return The original buffer.
200      */
201     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
202         if(len + buf.buf.length > buf.capacity) {
203             resize(buf, max(buf.capacity, len) * 2);
204         }
205 
206         uint mask = 256 ** len - 1;
207         assembly {
208             // Memory address of the buffer data
209             let bufptr := mload(buf)
210             // Length of existing buffer data
211             let buflen := mload(bufptr)
212             // Address = buffer address + buffer length + sizeof(buffer length) + len
213             let dest := add(add(bufptr, buflen), len)
214             mstore(dest, or(and(mload(dest), not(mask)), data))
215             // Update buffer length
216             mstore(bufptr, add(buflen, len))
217         }
218         return buf;
219     }
220 }
221 
222 library CBOR {
223     using Buffer for Buffer.buffer;
224 
225     uint8 private constant MAJOR_TYPE_INT = 0;
226     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
227     uint8 private constant MAJOR_TYPE_BYTES = 2;
228     uint8 private constant MAJOR_TYPE_STRING = 3;
229     uint8 private constant MAJOR_TYPE_ARRAY = 4;
230     uint8 private constant MAJOR_TYPE_MAP = 5;
231     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
232 
233     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
234         if(value <= 23) {
235             buf.append(uint8((major << 5) | value));
236         } else if(value <= 0xFF) {
237             buf.append(uint8((major << 5) | 24));
238             buf.appendInt(value, 1);
239         } else if(value <= 0xFFFF) {
240             buf.append(uint8((major << 5) | 25));
241             buf.appendInt(value, 2);
242         } else if(value <= 0xFFFFFFFF) {
243             buf.append(uint8((major << 5) | 26));
244             buf.appendInt(value, 4);
245         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
246             buf.append(uint8((major << 5) | 27));
247             buf.appendInt(value, 8);
248         }
249     }
250 
251     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
252         buf.append(uint8((major << 5) | 31));
253     }
254 
255     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
256         encodeType(buf, MAJOR_TYPE_INT, value);
257     }
258 
259     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
260         if(value >= 0) {
261             encodeType(buf, MAJOR_TYPE_INT, uint(value));
262         } else {
263             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
264         }
265     }
266 
267     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
268         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
269         buf.append(value);
270     }
271 
272     function encodeString(Buffer.buffer memory buf, string value) internal pure {
273         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
274         buf.append(bytes(value));
275     }
276 
277     function startArray(Buffer.buffer memory buf) internal pure {
278         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
279     }
280 
281     function startMap(Buffer.buffer memory buf) internal pure {
282         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
283     }
284 
285     function endSequence(Buffer.buffer memory buf) internal pure {
286         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
287     }
288 }
289 
290 /*
291 End solidity-cborutils
292  */
293 
294 contract usingOraclize {
295     uint constant day = 60*60*24;
296     uint constant week = 60*60*24*7;
297     uint constant month = 60*60*24*30;
298     byte constant proofType_NONE = 0x00;
299     byte constant proofType_TLSNotary = 0x10;
300     byte constant proofType_Ledger = 0x30;
301     byte constant proofType_Android = 0x40;
302     byte constant proofType_Native = 0xF0;
303     byte constant proofStorage_IPFS = 0x01;
304     uint8 constant networkID_auto = 0;
305     uint8 constant networkID_mainnet = 1;
306     uint8 constant networkID_testnet = 2;
307     uint8 constant networkID_morden = 2;
308     uint8 constant networkID_consensys = 161;
309 
310     OraclizeAddrResolverI OAR;
311 
312     OraclizeI oraclize;
313     modifier oraclizeAPI {
314         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
315             oraclize_setNetwork(networkID_auto);
316 
317         if(address(oraclize) != OAR.getAddress())
318             oraclize = OraclizeI(OAR.getAddress());
319 
320         _;
321     }
322     modifier coupon(string code){
323         oraclize = OraclizeI(OAR.getAddress());
324         _;
325     }
326 
327     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
328       return oraclize_setNetwork();
329       networkID; // silence the warning and remain backwards compatible
330     }
331     function oraclize_setNetwork() internal returns(bool){
332         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
333             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
334             oraclize_setNetworkName("eth_mainnet");
335             return true;
336         }
337         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
338             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
339             oraclize_setNetworkName("eth_ropsten3");
340             return true;
341         }
342         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
343             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
344             oraclize_setNetworkName("eth_kovan");
345             return true;
346         }
347         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
348             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
349             oraclize_setNetworkName("eth_rinkeby");
350             return true;
351         }
352         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
353             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
354             return true;
355         }
356         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
357             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
358             return true;
359         }
360         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
361             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
362             return true;
363         }
364         return false;
365     }
366 
367     function __callback(bytes32 myid, string result) public {
368         __callback(myid, result, new bytes(0));
369     }
370     function __callback(bytes32 myid, string result, bytes proof) public {
371       return;
372       myid; result; proof; // Silence compiler warnings
373     }
374 
375     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
376         return oraclize.getPrice(datasource);
377     }
378 
379     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
380         return oraclize.getPrice(datasource, gaslimit);
381     }
382 
383     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
384         uint price = oraclize.getPrice(datasource);
385         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
386         return oraclize.query.value(price)(0, datasource, arg);
387     }
388     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
389         uint price = oraclize.getPrice(datasource);
390         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
391         return oraclize.query.value(price)(timestamp, datasource, arg);
392     }
393     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
394         uint price = oraclize.getPrice(datasource, gaslimit);
395         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
396         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
397     }
398     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
399         uint price = oraclize.getPrice(datasource, gaslimit);
400         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
401         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
402     }
403     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
404         uint price = oraclize.getPrice(datasource);
405         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
406         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
407     }
408     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
409         uint price = oraclize.getPrice(datasource);
410         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
411         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
412     }
413     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
414         uint price = oraclize.getPrice(datasource, gaslimit);
415         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
416         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
417     }
418     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
419         uint price = oraclize.getPrice(datasource, gaslimit);
420         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
421         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
422     }
423     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
424         uint price = oraclize.getPrice(datasource);
425         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
426         bytes memory args = stra2cbor(argN);
427         return oraclize.queryN.value(price)(0, datasource, args);
428     }
429     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
430         uint price = oraclize.getPrice(datasource);
431         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
432         bytes memory args = stra2cbor(argN);
433         return oraclize.queryN.value(price)(timestamp, datasource, args);
434     }
435     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
436         uint price = oraclize.getPrice(datasource, gaslimit);
437         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
438         bytes memory args = stra2cbor(argN);
439         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
440     }
441     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
442         uint price = oraclize.getPrice(datasource, gaslimit);
443         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
444         bytes memory args = stra2cbor(argN);
445         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
446     }
447     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
448         string[] memory dynargs = new string[](1);
449         dynargs[0] = args[0];
450         return oraclize_query(datasource, dynargs);
451     }
452     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
453         string[] memory dynargs = new string[](1);
454         dynargs[0] = args[0];
455         return oraclize_query(timestamp, datasource, dynargs);
456     }
457     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
458         string[] memory dynargs = new string[](1);
459         dynargs[0] = args[0];
460         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
461     }
462     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
463         string[] memory dynargs = new string[](1);
464         dynargs[0] = args[0];
465         return oraclize_query(datasource, dynargs, gaslimit);
466     }
467 
468     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
469         string[] memory dynargs = new string[](2);
470         dynargs[0] = args[0];
471         dynargs[1] = args[1];
472         return oraclize_query(datasource, dynargs);
473     }
474     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
475         string[] memory dynargs = new string[](2);
476         dynargs[0] = args[0];
477         dynargs[1] = args[1];
478         return oraclize_query(timestamp, datasource, dynargs);
479     }
480     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
481         string[] memory dynargs = new string[](2);
482         dynargs[0] = args[0];
483         dynargs[1] = args[1];
484         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
485     }
486     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
487         string[] memory dynargs = new string[](2);
488         dynargs[0] = args[0];
489         dynargs[1] = args[1];
490         return oraclize_query(datasource, dynargs, gaslimit);
491     }
492     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
493         string[] memory dynargs = new string[](3);
494         dynargs[0] = args[0];
495         dynargs[1] = args[1];
496         dynargs[2] = args[2];
497         return oraclize_query(datasource, dynargs);
498     }
499     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
500         string[] memory dynargs = new string[](3);
501         dynargs[0] = args[0];
502         dynargs[1] = args[1];
503         dynargs[2] = args[2];
504         return oraclize_query(timestamp, datasource, dynargs);
505     }
506     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
507         string[] memory dynargs = new string[](3);
508         dynargs[0] = args[0];
509         dynargs[1] = args[1];
510         dynargs[2] = args[2];
511         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
512     }
513     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
514         string[] memory dynargs = new string[](3);
515         dynargs[0] = args[0];
516         dynargs[1] = args[1];
517         dynargs[2] = args[2];
518         return oraclize_query(datasource, dynargs, gaslimit);
519     }
520 
521     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
522         string[] memory dynargs = new string[](4);
523         dynargs[0] = args[0];
524         dynargs[1] = args[1];
525         dynargs[2] = args[2];
526         dynargs[3] = args[3];
527         return oraclize_query(datasource, dynargs);
528     }
529     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
530         string[] memory dynargs = new string[](4);
531         dynargs[0] = args[0];
532         dynargs[1] = args[1];
533         dynargs[2] = args[2];
534         dynargs[3] = args[3];
535         return oraclize_query(timestamp, datasource, dynargs);
536     }
537     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
538         string[] memory dynargs = new string[](4);
539         dynargs[0] = args[0];
540         dynargs[1] = args[1];
541         dynargs[2] = args[2];
542         dynargs[3] = args[3];
543         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
544     }
545     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
546         string[] memory dynargs = new string[](4);
547         dynargs[0] = args[0];
548         dynargs[1] = args[1];
549         dynargs[2] = args[2];
550         dynargs[3] = args[3];
551         return oraclize_query(datasource, dynargs, gaslimit);
552     }
553     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
554         string[] memory dynargs = new string[](5);
555         dynargs[0] = args[0];
556         dynargs[1] = args[1];
557         dynargs[2] = args[2];
558         dynargs[3] = args[3];
559         dynargs[4] = args[4];
560         return oraclize_query(datasource, dynargs);
561     }
562     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
563         string[] memory dynargs = new string[](5);
564         dynargs[0] = args[0];
565         dynargs[1] = args[1];
566         dynargs[2] = args[2];
567         dynargs[3] = args[3];
568         dynargs[4] = args[4];
569         return oraclize_query(timestamp, datasource, dynargs);
570     }
571     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
572         string[] memory dynargs = new string[](5);
573         dynargs[0] = args[0];
574         dynargs[1] = args[1];
575         dynargs[2] = args[2];
576         dynargs[3] = args[3];
577         dynargs[4] = args[4];
578         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
579     }
580     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
581         string[] memory dynargs = new string[](5);
582         dynargs[0] = args[0];
583         dynargs[1] = args[1];
584         dynargs[2] = args[2];
585         dynargs[3] = args[3];
586         dynargs[4] = args[4];
587         return oraclize_query(datasource, dynargs, gaslimit);
588     }
589     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
590         uint price = oraclize.getPrice(datasource);
591         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
592         bytes memory args = ba2cbor(argN);
593         return oraclize.queryN.value(price)(0, datasource, args);
594     }
595     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
596         uint price = oraclize.getPrice(datasource);
597         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
598         bytes memory args = ba2cbor(argN);
599         return oraclize.queryN.value(price)(timestamp, datasource, args);
600     }
601     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
602         uint price = oraclize.getPrice(datasource, gaslimit);
603         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
604         bytes memory args = ba2cbor(argN);
605         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
606     }
607     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
608         uint price = oraclize.getPrice(datasource, gaslimit);
609         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
610         bytes memory args = ba2cbor(argN);
611         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
612     }
613     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
614         bytes[] memory dynargs = new bytes[](1);
615         dynargs[0] = args[0];
616         return oraclize_query(datasource, dynargs);
617     }
618     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
619         bytes[] memory dynargs = new bytes[](1);
620         dynargs[0] = args[0];
621         return oraclize_query(timestamp, datasource, dynargs);
622     }
623     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
624         bytes[] memory dynargs = new bytes[](1);
625         dynargs[0] = args[0];
626         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
627     }
628     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
629         bytes[] memory dynargs = new bytes[](1);
630         dynargs[0] = args[0];
631         return oraclize_query(datasource, dynargs, gaslimit);
632     }
633 
634     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
635         bytes[] memory dynargs = new bytes[](2);
636         dynargs[0] = args[0];
637         dynargs[1] = args[1];
638         return oraclize_query(datasource, dynargs);
639     }
640     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
641         bytes[] memory dynargs = new bytes[](2);
642         dynargs[0] = args[0];
643         dynargs[1] = args[1];
644         return oraclize_query(timestamp, datasource, dynargs);
645     }
646     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
647         bytes[] memory dynargs = new bytes[](2);
648         dynargs[0] = args[0];
649         dynargs[1] = args[1];
650         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
651     }
652     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
653         bytes[] memory dynargs = new bytes[](2);
654         dynargs[0] = args[0];
655         dynargs[1] = args[1];
656         return oraclize_query(datasource, dynargs, gaslimit);
657     }
658     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
659         bytes[] memory dynargs = new bytes[](3);
660         dynargs[0] = args[0];
661         dynargs[1] = args[1];
662         dynargs[2] = args[2];
663         return oraclize_query(datasource, dynargs);
664     }
665     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
666         bytes[] memory dynargs = new bytes[](3);
667         dynargs[0] = args[0];
668         dynargs[1] = args[1];
669         dynargs[2] = args[2];
670         return oraclize_query(timestamp, datasource, dynargs);
671     }
672     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
673         bytes[] memory dynargs = new bytes[](3);
674         dynargs[0] = args[0];
675         dynargs[1] = args[1];
676         dynargs[2] = args[2];
677         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
678     }
679     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
680         bytes[] memory dynargs = new bytes[](3);
681         dynargs[0] = args[0];
682         dynargs[1] = args[1];
683         dynargs[2] = args[2];
684         return oraclize_query(datasource, dynargs, gaslimit);
685     }
686 
687     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
688         bytes[] memory dynargs = new bytes[](4);
689         dynargs[0] = args[0];
690         dynargs[1] = args[1];
691         dynargs[2] = args[2];
692         dynargs[3] = args[3];
693         return oraclize_query(datasource, dynargs);
694     }
695     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
696         bytes[] memory dynargs = new bytes[](4);
697         dynargs[0] = args[0];
698         dynargs[1] = args[1];
699         dynargs[2] = args[2];
700         dynargs[3] = args[3];
701         return oraclize_query(timestamp, datasource, dynargs);
702     }
703     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
704         bytes[] memory dynargs = new bytes[](4);
705         dynargs[0] = args[0];
706         dynargs[1] = args[1];
707         dynargs[2] = args[2];
708         dynargs[3] = args[3];
709         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
710     }
711     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
712         bytes[] memory dynargs = new bytes[](4);
713         dynargs[0] = args[0];
714         dynargs[1] = args[1];
715         dynargs[2] = args[2];
716         dynargs[3] = args[3];
717         return oraclize_query(datasource, dynargs, gaslimit);
718     }
719     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
720         bytes[] memory dynargs = new bytes[](5);
721         dynargs[0] = args[0];
722         dynargs[1] = args[1];
723         dynargs[2] = args[2];
724         dynargs[3] = args[3];
725         dynargs[4] = args[4];
726         return oraclize_query(datasource, dynargs);
727     }
728     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
729         bytes[] memory dynargs = new bytes[](5);
730         dynargs[0] = args[0];
731         dynargs[1] = args[1];
732         dynargs[2] = args[2];
733         dynargs[3] = args[3];
734         dynargs[4] = args[4];
735         return oraclize_query(timestamp, datasource, dynargs);
736     }
737     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
738         bytes[] memory dynargs = new bytes[](5);
739         dynargs[0] = args[0];
740         dynargs[1] = args[1];
741         dynargs[2] = args[2];
742         dynargs[3] = args[3];
743         dynargs[4] = args[4];
744         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
745     }
746     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
747         bytes[] memory dynargs = new bytes[](5);
748         dynargs[0] = args[0];
749         dynargs[1] = args[1];
750         dynargs[2] = args[2];
751         dynargs[3] = args[3];
752         dynargs[4] = args[4];
753         return oraclize_query(datasource, dynargs, gaslimit);
754     }
755 
756     function oraclize_cbAddress() oraclizeAPI internal returns (address){
757         return oraclize.cbAddress();
758     }
759     function oraclize_setProof(byte proofP) oraclizeAPI internal {
760         return oraclize.setProofType(proofP);
761     }
762     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
763         return oraclize.setCustomGasPrice(gasPrice);
764     }
765 
766     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
767         return oraclize.randomDS_getSessionPubKeyHash();
768     }
769 
770     function getCodeSize(address _addr) constant internal returns(uint _size) {
771         assembly {
772             _size := extcodesize(_addr)
773         }
774     }
775 
776     function parseAddr(string _a) internal pure returns (address){
777         bytes memory tmp = bytes(_a);
778         uint160 iaddr = 0;
779         uint160 b1;
780         uint160 b2;
781         for (uint i=2; i<2+2*20; i+=2){
782             iaddr *= 256;
783             b1 = uint160(tmp[i]);
784             b2 = uint160(tmp[i+1]);
785             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
786             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
787             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
788             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
789             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
790             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
791             iaddr += (b1*16+b2);
792         }
793         return address(iaddr);
794     }
795 
796     function strCompare(string _a, string _b) internal pure returns (int) {
797         bytes memory a = bytes(_a);
798         bytes memory b = bytes(_b);
799         uint minLength = a.length;
800         if (b.length < minLength) minLength = b.length;
801         for (uint i = 0; i < minLength; i ++)
802             if (a[i] < b[i])
803                 return -1;
804             else if (a[i] > b[i])
805                 return 1;
806         if (a.length < b.length)
807             return -1;
808         else if (a.length > b.length)
809             return 1;
810         else
811             return 0;
812     }
813 
814     function indexOf(string _haystack, string _needle) internal pure returns (int) {
815         bytes memory h = bytes(_haystack);
816         bytes memory n = bytes(_needle);
817         if(h.length < 1 || n.length < 1 || (n.length > h.length))
818             return -1;
819         else if(h.length > (2**128 -1))
820             return -1;
821         else
822         {
823             uint subindex = 0;
824             for (uint i = 0; i < h.length; i ++)
825             {
826                 if (h[i] == n[0])
827                 {
828                     subindex = 1;
829                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
830                     {
831                         subindex++;
832                     }
833                     if(subindex == n.length)
834                         return int(i);
835                 }
836             }
837             return -1;
838         }
839     }
840 
841     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
842         bytes memory _ba = bytes(_a);
843         bytes memory _bb = bytes(_b);
844         bytes memory _bc = bytes(_c);
845         bytes memory _bd = bytes(_d);
846         bytes memory _be = bytes(_e);
847         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
848         bytes memory babcde = bytes(abcde);
849         uint k = 0;
850         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
851         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
852         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
853         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
854         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
855         return string(babcde);
856     }
857 
858     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
859         return strConcat(_a, _b, _c, _d, "");
860     }
861 
862     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
863         return strConcat(_a, _b, _c, "", "");
864     }
865 
866     function strConcat(string _a, string _b) internal pure returns (string) {
867         return strConcat(_a, _b, "", "", "");
868     }
869 
870     // parseInt
871     function parseInt(string _a) internal pure returns (uint) {
872         return parseInt(_a, 0);
873     }
874 
875     // parseInt(parseFloat*10^_b)
876     function parseInt(string _a, uint _b) internal pure returns (uint) {
877         bytes memory bresult = bytes(_a);
878         uint mint = 0;
879         bool decimals = false;
880         for (uint i=0; i<bresult.length; i++){
881             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
882                 if (decimals){
883                    if (_b == 0) break;
884                     else _b--;
885                 }
886                 mint *= 10;
887                 mint += uint(bresult[i]) - 48;
888             } else if (bresult[i] == 46) decimals = true;
889         }
890         if (_b > 0) mint *= 10**_b;
891         return mint;
892     }
893 
894     function uint2str(uint i) internal pure returns (string){
895         if (i == 0) return "0";
896         uint j = i;
897         uint len;
898         while (j != 0){
899             len++;
900             j /= 10;
901         }
902         bytes memory bstr = new bytes(len);
903         uint k = len - 1;
904         while (i != 0){
905             bstr[k--] = byte(48 + i % 10);
906             i /= 10;
907         }
908         return string(bstr);
909     }
910 
911     using CBOR for Buffer.buffer;
912     function stra2cbor(string[] arr) internal pure returns (bytes) {
913         safeMemoryCleaner();
914         Buffer.buffer memory buf;
915         Buffer.init(buf, 1024);
916         buf.startArray();
917         for (uint i = 0; i < arr.length; i++) {
918             buf.encodeString(arr[i]);
919         }
920         buf.endSequence();
921         return buf.buf;
922     }
923 
924     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
925         safeMemoryCleaner();
926         Buffer.buffer memory buf;
927         Buffer.init(buf, 1024);
928         buf.startArray();
929         for (uint i = 0; i < arr.length; i++) {
930             buf.encodeBytes(arr[i]);
931         }
932         buf.endSequence();
933         return buf.buf;
934     }
935 
936     string oraclize_network_name;
937     function oraclize_setNetworkName(string _network_name) internal {
938         oraclize_network_name = _network_name;
939     }
940 
941     function oraclize_getNetworkName() internal view returns (string) {
942         return oraclize_network_name;
943     }
944 
945     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
946         require((_nbytes > 0) && (_nbytes <= 32));
947         // Convert from seconds to ledger timer ticks
948         _delay *= 10;
949         bytes memory nbytes = new bytes(1);
950         nbytes[0] = byte(_nbytes);
951         bytes memory unonce = new bytes(32);
952         bytes memory sessionKeyHash = new bytes(32);
953         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
954         assembly {
955             mstore(unonce, 0x20)
956             // the following variables can be relaxed
957             // check relaxed random contract under ethereum-examples repo
958             // for an idea on how to override and replace comit hash vars
959             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
960             mstore(sessionKeyHash, 0x20)
961             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
962         }
963         bytes memory delay = new bytes(32);
964         assembly {
965             mstore(add(delay, 0x20), _delay)
966         }
967 
968         bytes memory delay_bytes8 = new bytes(8);
969         copyBytes(delay, 24, 8, delay_bytes8, 0);
970 
971         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
972         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
973 
974         bytes memory delay_bytes8_left = new bytes(8);
975 
976         assembly {
977             let x := mload(add(delay_bytes8, 0x20))
978             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
979             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
980             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
981             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
982             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
983             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
984             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
985             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
986 
987         }
988 
989         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
990         return queryId;
991     }
992 
993     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
994         oraclize_randomDS_args[queryId] = commitment;
995     }
996 
997     mapping(bytes32=>bytes32) oraclize_randomDS_args;
998     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
999 
1000     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1001         bool sigok;
1002         address signer;
1003 
1004         bytes32 sigr;
1005         bytes32 sigs;
1006 
1007         bytes memory sigr_ = new bytes(32);
1008         uint offset = 4+(uint(dersig[3]) - 0x20);
1009         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1010         bytes memory sigs_ = new bytes(32);
1011         offset += 32 + 2;
1012         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1013 
1014         assembly {
1015             sigr := mload(add(sigr_, 32))
1016             sigs := mload(add(sigs_, 32))
1017         }
1018 
1019 
1020         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1021         if (address(keccak256(pubkey)) == signer) return true;
1022         else {
1023             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1024             return (address(keccak256(pubkey)) == signer);
1025         }
1026     }
1027 
1028     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1029         bool sigok;
1030 
1031         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1032         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1033         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1034 
1035         bytes memory appkey1_pubkey = new bytes(64);
1036         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1037 
1038         bytes memory tosign2 = new bytes(1+65+32);
1039         tosign2[0] = byte(1); //role
1040         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1041         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1042         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1043         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1044 
1045         if (sigok == false) return false;
1046 
1047 
1048         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1049         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1050 
1051         bytes memory tosign3 = new bytes(1+65);
1052         tosign3[0] = 0xFE;
1053         copyBytes(proof, 3, 65, tosign3, 1);
1054 
1055         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1056         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1057 
1058         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1059 
1060         return sigok;
1061     }
1062 
1063     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1064         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1065         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1066 
1067         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1068         require(proofVerified);
1069 
1070         _;
1071     }
1072 
1073     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1074         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1075         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1076 
1077         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1078         if (proofVerified == false) return 2;
1079 
1080         return 0;
1081     }
1082 
1083     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1084         bool match_ = true;
1085 
1086         require(prefix.length == n_random_bytes);
1087 
1088         for (uint256 i=0; i< n_random_bytes; i++) {
1089             if (content[i] != prefix[i]) match_ = false;
1090         }
1091 
1092         return match_;
1093     }
1094 
1095     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1096 
1097         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1098         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1099         bytes memory keyhash = new bytes(32);
1100         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1101         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1102 
1103         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1104         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1105 
1106         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1107         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1108 
1109         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1110         // This is to verify that the computed args match with the ones specified in the query.
1111         bytes memory commitmentSlice1 = new bytes(8+1+32);
1112         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1113 
1114         bytes memory sessionPubkey = new bytes(64);
1115         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1116         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1117 
1118         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1119         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1120             delete oraclize_randomDS_args[queryId];
1121         } else return false;
1122 
1123 
1124         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1125         bytes memory tosign1 = new bytes(32+8+1+32);
1126         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1127         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1128 
1129         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1130         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1131             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1132         }
1133 
1134         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1135     }
1136 
1137     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1138     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1139         uint minLength = length + toOffset;
1140 
1141         // Buffer too small
1142         require(to.length >= minLength); // Should be a better way?
1143 
1144         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1145         uint i = 32 + fromOffset;
1146         uint j = 32 + toOffset;
1147 
1148         while (i < (32 + fromOffset + length)) {
1149             assembly {
1150                 let tmp := mload(add(from, i))
1151                 mstore(add(to, j), tmp)
1152             }
1153             i += 32;
1154             j += 32;
1155         }
1156 
1157         return to;
1158     }
1159 
1160     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1161     // Duplicate Solidity's ecrecover, but catching the CALL return value
1162     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1163         // We do our own memory management here. Solidity uses memory offset
1164         // 0x40 to store the current end of memory. We write past it (as
1165         // writes are memory extensions), but don't update the offset so
1166         // Solidity will reuse it. The memory used here is only needed for
1167         // this context.
1168 
1169         // FIXME: inline assembly can't access return values
1170         bool ret;
1171         address addr;
1172 
1173         assembly {
1174             let size := mload(0x40)
1175             mstore(size, hash)
1176             mstore(add(size, 32), v)
1177             mstore(add(size, 64), r)
1178             mstore(add(size, 96), s)
1179 
1180             // NOTE: we can reuse the request memory because we deal with
1181             //       the return code
1182             ret := call(3000, 1, 0, size, 128, size, 32)
1183             addr := mload(size)
1184         }
1185 
1186         return (ret, addr);
1187     }
1188 
1189     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1190     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1191         bytes32 r;
1192         bytes32 s;
1193         uint8 v;
1194 
1195         if (sig.length != 65)
1196           return (false, 0);
1197 
1198         // The signature format is a compact form of:
1199         //   {bytes32 r}{bytes32 s}{uint8 v}
1200         // Compact means, uint8 is not padded to 32 bytes.
1201         assembly {
1202             r := mload(add(sig, 32))
1203             s := mload(add(sig, 64))
1204 
1205             // Here we are loading the last 32 bytes. We exploit the fact that
1206             // 'mload' will pad with zeroes if we overread.
1207             // There is no 'mload8' to do this, but that would be nicer.
1208             v := byte(0, mload(add(sig, 96)))
1209 
1210             // Alternative solution:
1211             // 'byte' is not working due to the Solidity parser, so lets
1212             // use the second best option, 'and'
1213             // v := and(mload(add(sig, 65)), 255)
1214         }
1215 
1216         // albeit non-transactional signatures are not specified by the YP, one would expect it
1217         // to match the YP range of [27, 28]
1218         //
1219         // geth uses [0, 1] and some clients have followed. This might change, see:
1220         //  https://github.com/ethereum/go-ethereum/issues/2053
1221         if (v < 27)
1222           v += 27;
1223 
1224         if (v != 27 && v != 28)
1225             return (false, 0);
1226 
1227         return safer_ecrecover(hash, v, r, s);
1228     }
1229 
1230     function safeMemoryCleaner() internal pure {
1231         assembly {
1232             let fmem := mload(0x40)
1233             codecopy(fmem, codesize, sub(msize, fmem))
1234         }
1235     }
1236 
1237 }
1238 // </ORACLIZE_API>
1239 
1240 
1241 //==============================================================================
1242 // Begin: This part comes from openzeppelin-solidity
1243 //        https://github.com/OpenZeppelin/openzeppelin-solidity
1244 //============================================================================== 
1245 /**
1246  * @title SafeMath
1247  * @dev Math operations with safety checks that throw on error
1248  */
1249 library SafeMath {
1250 
1251   /**
1252   * @dev Multiplies two numbers, throws on overflow.
1253   */
1254   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
1255     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
1256     // benefit is lost if 'b' is also tested.
1257     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1258     if (a == 0) {
1259       return 0;
1260     }
1261 
1262     c = a * b;
1263     assert(c / a == b);
1264     return c;
1265   }
1266 
1267   /**
1268   * @dev Integer division of two numbers, truncating the quotient.
1269   */
1270   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1271     // assert(b > 0); // Solidity automatically throws when dividing by 0
1272     // uint256 c = a / b;
1273     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1274     return a / b;
1275   }
1276 
1277   /**
1278   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1279   */
1280   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1281     assert(b <= a);
1282     return a - b;
1283   }
1284 
1285   /**
1286   * @dev Adds two numbers, throws on overflow.
1287   */
1288   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
1289     c = a + b;
1290     assert(c >= a);
1291     return c;
1292   }
1293 }
1294 
1295 /**
1296  * @title Ownable
1297  * @dev The Ownable contract has an owner address, and provides basic authorization control
1298  * functions, this simplifies the implementation of "user permissions".
1299  */
1300 contract Ownable {
1301   address public owner;
1302 
1303   event OwnershipRenounced(address indexed previousOwner);
1304   event OwnershipTransferred(
1305     address indexed previousOwner,
1306     address indexed newOwner
1307   );
1308 
1309 
1310   /**
1311    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1312    * account.
1313    */
1314   constructor() public {
1315     owner = msg.sender;
1316   }
1317 
1318   /**
1319    * @dev Throws if called by any account other than the owner.
1320    */
1321   modifier onlyOwner() {
1322     require(msg.sender == owner);
1323     _;
1324   }
1325 
1326   /**
1327    * @dev Allows the current owner to relinquish control of the contract.
1328    * @notice Renouncing to ownership will leave the contract without an owner.
1329    * It will not be possible to call the functions with the `onlyOwner`
1330    * modifier anymore.
1331    */
1332   function renounceOwnership() public onlyOwner {
1333     emit OwnershipRenounced(owner);
1334     owner = address(0);
1335   }
1336 
1337   /**
1338    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1339    * @param _newOwner The address to transfer ownership to.
1340    */
1341   function transferOwnership(address _newOwner) public onlyOwner {
1342     _transferOwnership(_newOwner);
1343   }
1344 
1345   /**
1346    * @dev Transfers control of the contract to a newOwner.
1347    * @param _newOwner The address to transfer ownership to.
1348    */
1349   function _transferOwnership(address _newOwner) internal {
1350     require(_newOwner != address(0));
1351     emit OwnershipTransferred(owner, _newOwner);
1352     owner = _newOwner;
1353   }
1354 }
1355 //==============================================================================
1356 // End: This part comes from openzeppelin-solidity
1357 //==============================================================================
1358 
1359 
1360 /**
1361  * @dev YHT interface, for mint and transfer earnings.
1362  */
1363 contract YHTInterface {
1364   function mintToFounder(address to, uint256 amount, uint256 normalAmount) external;
1365   function mintToNormal(address to, uint256 amount, uint256 bonusRoundId) external;
1366   function transferExtraEarnings(address winner) external payable;
1367   function transferBonusEarnings() external payable returns(uint256);
1368   function withdrawForBet(address addr, uint256 value) external;
1369 }
1370 
1371 /**
1372  * The Lottery contract for Printing YHT 
1373  */
1374 contract Lottery is usingOraclize, Ownable {
1375   using SafeMath for uint256;
1376   
1377   /**
1378    * @dev betting information for everyone
1379    */
1380   struct Bet {
1381     uint256 cycleCount;     //number of cycles during a bet, if it not equls Lottery.cycleCount the amount is zero
1382     uint256 amount;         //betting amount
1383   }
1384   
1385   struct BetCycle {
1386     uint256 amount;
1387     uint256 bonusRoundId;
1388   }
1389   
1390   struct Referrer {
1391     uint256 id;
1392     uint256 bindReferrerId;
1393     uint256 bindCycleCount;
1394     uint256 beBindCount;
1395     uint256 earnings;
1396   }
1397 
1398 //settings begin
1399   // 41.77% will assigned to winner   
1400   // 39% will assigned to the people who hold YHT
1401   // 18% will put in the next prize pool 
1402   // 1.23% is fee
1403   uint256 constant private kTenThousand = 10000;                 // all rate is fraction of ten thousand
1404   uint256 constant private kRewardRate = 4177;                   // the winner will get of the prize pool     
1405   uint256 constant private kBonusRate = 3900;                    // assigned to peoples who hold YHT
1406   uint256 constant private kNextInitRate = 1800;                 // put in the next prize pool       
1407   uint256 constant private kFeeRate = 123;                       // fee 123
1408   uint256 constant private kReferrerRate = 700;                  // when bet, the referrer will get 7% of bet amount
1409   uint256 constant private kReferrerEarningsCycleCount = 15;     // promotional earnings only for the specified cycle
1410   uint8[] private kOpenRewardWeekdays = [ 2, 4, 6 ];             // every Tuesday, Thursday, Saturday open reward
1411   uint256 constant private kRandomBeforeTime = 3 minutes;        // before time of call Oraclize query function, at this point in time to compute the gas cost
1412   uint256 constant private kQueryRandomMaxTryCount = 3;          // max fail count of query Oraclize random function, if happen postpone to the next cycle
1413   uint256 constant private kCallbackTimeout = 90 minutes;        // oraclize callback timeout
1414   uint256 constant private kGwei = (10 ** 9);                    // 1 Gwei
1415   uint256 constant private kDefaultGasPrice = 3 * kGwei;         // 3 Gwei
1416   uint256 constant private kMaxGasPrice = 17 * kGwei;            // 17 Gwei
1417   
1418   /**
1419    * @dev YHT amount of output per cycle, distribute by betting proportion
1420    */
1421   uint256 constant private kMintTotalPerCycle = 271828182845904523536028;        
1422   uint256 constant private kMintHalveCycleCount = 314;           // halved production per 314 cycles       
1423   uint256 constant private kMintTotalMin = 100 * (10 ** 18);     // production reduced to 100, no longer output
1424   uint256 constant private kMintFounderAdditionalRate = 382;     // extra 3.82% for each cycle to the founder team
1425   uint256 constant private kQueryUrlCallbackGas = 150000;        // query url callback gas limits
1426   uint256 constant private kQueryRandomCallbackBaseFirstGas = 550000;  //query random callback base first gas limits
1427   uint256 constant private kQueryRandomCallbackBaseGas = 450000; // query random callback base gas limits
1428   uint256 constant private kQueryRandomCallbackPerGas = 918;     // query random callback per people gas limits 
1429 //settings end
1430 
1431   YHTInterface public YHT;
1432   
1433   uint256 public cycleCount_;                                    // current number of cycles
1434   uint256 public nextOpenRewardTime_;                            // next open reward time
1435   
1436   bytes32 private queryId_;                                      // oraclize query id   
1437   uint256 private queryCallbackGasPrice_ = kDefaultGasPrice;     // gas price for oraclize random query callback, init is 3Gwei
1438   uint256 private queryTryCount_;                                // count of query Oraclize function
1439   uint256 public queryRandomTryTime_;                            // query random time
1440   
1441   uint256 public initAmount_;                                    // prize pool initial amount, from 15% of previous cycle
1442   uint256 public betAmount_;                                     // total amount in current cycle, initialization value is 1, so betAmount_ - 1 is actual Amount
1443   uint256 public betCount_;                                      // bet count of current cycle    
1444   uint256 public betTotalGasprice_;                              // bet total gas price, used to guss gasprice
1445   
1446   mapping(address => Bet) public bets_;                          // betting information of everyone
1447   mapping(uint256 => BetCycle) public betCycles_;                // bet cycle information
1448   mapping(uint256 => address) public betAddrs_;                  // all the bet address in current cycle
1449   uint256 public betAddrsCount_;                                 // the bet address count in current cycle    
1450   
1451   mapping(address => Referrer) public referrers_;                // referrer informations
1452   mapping(uint256 => address) public referrerIdToAddrs_;         // id => address
1453   uint256 public nextReferrerId_;                                // referrer id counter      
1454   uint256 public referrerEarnings_;                              // referrer earnings in current cycle
1455 
1456   event GasPriceUpdate(uint256 gasPrice);
1457   event RandomQuery(uint delay, uint N, uint callbackGas, uint256 gasPrice);
1458   event RandomSuccess(bytes data, uint256 tryCount);
1459   event RandomVerifyFailed(bytes data, uint256 tryCount);
1460   
1461   event NewBet(address indexed playerAddress, uint256 value, uint256 betValue, uint256 betAmount, uint256 betAddrsCount, uint256 betCount);
1462   event CycleNew(uint256 cycleCount, uint256 delay, uint256 nextOpenRewardTime, uint256 initAmount);
1463   event Divided(uint256 cycleCount, uint256 betAmount, uint256 initAmount, uint256 win, uint256 next, uint256 earnings);
1464   event LuckyMan(uint256 cycleCount, uint256 openRewardTime, address playerAddress, uint256 betValue, uint256 reward);
1465   event Withdraw(address addr, uint256 value);
1466   event ObtainReferrerEarnings(address indexed referrerAdress, uint256 beBindCount, address playerAddress, uint256 earnings);
1467 
1468   constructor() public {
1469   }
1470 
1471   /**
1472    * @dev make sure only call from Oraclize
1473    */  
1474   modifier onlyOraclize {
1475     require(msg.sender == oraclize_cbAddress());   
1476     _;
1477   }
1478   
1479   /**
1480    * @dev make sure no one can interact with contract until it has been activated.   
1481    */
1482   modifier isActivated() {
1483     require(YHT != address(0)); 
1484     _;
1485   }
1486 
1487   /**
1488   * @dev prevents contracts from interacting 
1489   */
1490   modifier isHuman() {
1491     address addr = msg.sender;
1492     uint256 codeLength;
1493     
1494     assembly {codeLength := extcodesize(addr)}
1495     require(codeLength == 0, "sorry humans only");
1496     _;
1497   }
1498   
1499   /**
1500    * @dev check bet value min and max
1501    */ 
1502   modifier isBetValueLimits(uint256 value) {
1503     require(value >= 1672621637, "too small, not a valid currency");  
1504     require(value < 250000 ether, "so stupid, one thousand SB");  
1505     _;  
1506   }
1507   
1508   /**
1509    * @dev check sender is YHT contract
1510    */ 
1511   modifier isYHT {
1512     require(msg.sender == address(YHT));
1513     _;
1514   }
1515   
1516   /**
1517    * @dev activate contract, this is a one time.
1518     pay some for Oraclize query and code execution
1519    */
1520   function activate(address yht) onlyOwner public payable  {
1521     // can only be ran once
1522     require(YHT == address(0));   
1523     require(msg.value >= 10 finney);
1524 
1525     // activate the contract                      
1526     YHT = YHTInterface(yht);
1527 
1528     // Set the proof of oraclize in order to make secure random number generations
1529     oraclize_setProof(proofType_Ledger);       
1530     // set oraclize call back gas price
1531     oraclize_setCustomGasPrice(queryCallbackGasPrice_); 
1532 
1533     // set first cycle 
1534     cycleCount_ = 1;
1535 
1536     /**
1537      * use 1 as the initialization value, avoid cost or recycle gas in the query callback
1538      */
1539     initAmount_ = 1;
1540     betAmount_ = 1; 
1541     betAddrsCount_ = 1;
1542     betCount_ = 1;
1543     betTotalGasprice_ = 1;
1544     queryTryCount_ = 1;
1545     queryRandomTryTime_ = 1;
1546     referrerEarnings_ = 1;
1547   }
1548 
1549   /**
1550    * @dev check query status, if query callback is not triggered or too later, reactivate
1551    */ 
1552   function check() private {
1553     uint256 nextOpenRewardTime = nextOpenRewardTime_; 
1554     if (nextOpenRewardTime == 0) {
1555       update();      
1556     }
1557     else if (nextOpenRewardTime < now) {
1558       if (now - nextOpenRewardTime > kCallbackTimeout && now - queryRandomTryTime_ > kCallbackTimeout) {
1559         setGasPriceUseTx();  
1560         checkQueryRandom();
1561       }
1562     }
1563   }
1564   
1565   /**
1566    * @dev get next reward time
1567    * @param openRewardWeekdays the weekday to be open reward, from small to big, the sunday is 0
1568    * @param currentTimestamp current time, use it to determine the next lottery time point 
1569    */
1570   function getNextOpenRewardTime(uint8[] openRewardWeekdays, uint256 currentTimestamp) pure public returns(uint) {
1571     uint8 currentWeekday = uint8((currentTimestamp / 1 days + 4) % 7);       
1572     uint256 morningTimestamp = (currentTimestamp - currentTimestamp % 1 days);
1573     
1574     // get number of days offset from next open reward time
1575     uint256 nextDay = 0;
1576     for (uint256 i = 0; i < openRewardWeekdays.length; ++i) {
1577       uint8 openWeekday = openRewardWeekdays[i];
1578       if (openWeekday > currentWeekday) {
1579         nextDay = openWeekday - currentWeekday;
1580         break;
1581       }
1582     }
1583 
1584     // not found offset day 
1585     if (nextDay == 0) {
1586       uint8 firstOpenWeekday = openRewardWeekdays[0];
1587       if (currentWeekday == 0) {      // current time is sunday
1588         assert(firstOpenWeekday == 0);
1589         nextDay = 7;    
1590       } 
1591       else {   
1592         uint8 remainDays = 7 - currentWeekday;      // the rest of the week
1593         nextDay = remainDays + firstOpenWeekday;    // add the first open time
1594       }  
1595     }
1596     
1597     assert(nextDay >= 1 && nextDay <= 7);
1598     uint256 nextOpenTimestamp = morningTimestamp + nextDay * 1 days;
1599     assert(nextOpenTimestamp > currentTimestamp);
1600     return nextOpenTimestamp;
1601   }  
1602   
1603   /**
1604    * @dev register query callback for cycle
1605    */
1606   function update() private {
1607     queryTryCount_ = 1;
1608     uint currentTime = now;  
1609 
1610     // not sure if the previous trigger was made in advance, so add a protection
1611     if (currentTime < nextOpenRewardTime_) {
1612       currentTime = nextOpenRewardTime_;    
1613     }
1614     
1615     nextOpenRewardTime_ = getNextOpenRewardTime(kOpenRewardWeekdays, currentTime);
1616     uint256 delay = nextOpenRewardTime_ - now;
1617     
1618     // before time of call query random function, at this point in time to compute the gas cost
1619     if (delay > kRandomBeforeTime) {
1620       delay -= kRandomBeforeTime;
1621     }
1622 
1623     queryId_ = oraclize_query(delay, "URL", "", kQueryUrlCallbackGas);
1624     emit CycleNew(cycleCount_, delay, nextOpenRewardTime_, initAmount_);
1625   }
1626   
1627   /**
1628    * @dev if has bet do query random, else to next update
1629    */ 
1630   function checkQueryRandom() private {
1631     if (betAmount_ > 1) {
1632       queryRandom();
1633     } 
1634     else {
1635       update();
1636     } 
1637   }
1638   
1639   /**
1640    * @dev set oraclize gas price
1641    */ 
1642   function setQueryCallbackGasPrice(uint256 gasPrice) private {
1643     queryCallbackGasPrice_ = gasPrice;  
1644     oraclize_setCustomGasPrice(gasPrice);       // set oraclize call back gas price
1645     emit GasPriceUpdate(gasPrice);   
1646   }
1647   
1648   /**
1649    * @dev when timeout too long, use tx.gasprice as oraclize callback gas price
1650    */ 
1651   function setGasPriceUseTx() private {
1652     uint256 gasPrice = tx.gasprice;
1653     if (gasPrice < kDefaultGasPrice) {
1654       gasPrice = kDefaultGasPrice;        
1655     } else if (gasPrice > kMaxGasPrice) {
1656       gasPrice = kMaxGasPrice;    
1657     }
1658     setQueryCallbackGasPrice(gasPrice);
1659   }
1660 
1661   /**
1662    * @dev set gas price and try query random
1663    */ 
1664   function updateGasPrice() private {
1665     if (betCount_ > 1) {
1666       uint256 gasPrice =  (betTotalGasprice_ - 1) / (betCount_ - 1);    
1667       assert(gasPrice > 0);
1668       setQueryCallbackGasPrice(gasPrice);    
1669     }
1670   }
1671   
1672   /**
1673    * @dev Oraclize callback
1674    */
1675   function __callback(bytes32 callbackId, string result, bytes proof) onlyOraclize public {
1676     require(callbackId == queryId_, "callbackId is error");  
1677     if (queryTryCount_ == 1) {
1678       updateGasPrice();        
1679       checkQueryRandom();
1680     }
1681     else {
1682       queryRandomCallback(callbackId, result, proof);       
1683     }
1684   }
1685     
1686   /**
1687    * @dev get the query random callback gas cost
1688    */
1689   function getQueryRandomCallbackGas() view private returns(uint256) {
1690     uint256 base = cycleCount_ == 1 ? kQueryRandomCallbackBaseFirstGas : kQueryRandomCallbackBaseGas;  
1691     return base + betAddrsCount_ * kQueryRandomCallbackPerGas;
1692   }
1693 
1694   /**
1695    * @dev compute the gas cost then register query random function
1696    */
1697   function queryRandom() private {
1698     ++queryTryCount_;
1699     queryRandomTryTime_ = now;
1700     
1701     /**
1702      * base code from https://github.com/oraclize/ethereum-examples/blob/master/solidity/random-datasource/randomExample.sol#L44
1703      */
1704     uint256 delay = 0;
1705     uint256 callbackGas = getQueryRandomCallbackGas();   
1706     // number of random bytes we want the datasource to return
1707     // the max range will be 2^(8*N)
1708     uint256 N = 32;
1709     
1710     // generates the oraclize query
1711     queryId_ = oraclize_newRandomDSQuery(delay, N, callbackGas); 
1712     emit RandomQuery(delay, N, callbackGas, queryCallbackGasPrice_);
1713   }
1714   
1715   /**
1716    * @dev Oraclize query random callback
1717    */  
1718   function queryRandomCallback(bytes32 callbackId, string result, bytes proof) private  {
1719     uint256 queryRandomTryCount = queryTryCount_ - 1;   
1720     bytes memory resultBytes = bytes(result);  
1721     
1722     if (resultBytes.length == 0 || oraclize_randomDS_proofVerify__returnCode(callbackId, result, proof) != 0) {
1723       emit RandomVerifyFailed(resultBytes, queryRandomTryCount);
1724       
1725       if (queryRandomTryCount < kQueryRandomMaxTryCount) {
1726          // try again  
1727         queryRandom();     
1728       }
1729       else {
1730         // if fails too many, ostpone to the next query       
1731         update();     
1732       }
1733     } 
1734     else {
1735       emit RandomSuccess(resultBytes, queryRandomTryCount);      
1736       // get correct random result, so do the end action
1737       currentCycleEnd(result);         
1738     }
1739   }
1740     
1741   /**
1742    * @dev ends the cycle, mint tokens and randomly out winner
1743    */
1744   function currentCycleEnd(string randomResult) private {
1745     if (betAmount_ > 1) {
1746       // mint tokens 
1747       mint();
1748       // randomly out winner    
1749       randomWinner(randomResult);
1750     } 
1751     else {
1752       // the amount of betting is zero, to the next query directly   
1753       update();     
1754     }
1755   }
1756   
1757   /**
1758    * @dev get mint count per cycle, halved production per 300 cycles.
1759    */ 
1760   function getMintCountOfCycle(uint256 cycleCount) pure public returns(uint256) {
1761     require(cycleCount > 0);
1762     // halve times
1763     uint256 times = (cycleCount - 1) / kMintHalveCycleCount;
1764     // equivalent to mintTotalPerCycle / 2**times 
1765     uint256 total = kMintTotalPerCycle >> times; 
1766     if (total < kMintTotalMin) {
1767       total = 0;      
1768     }
1769     return total;
1770   }
1771   
1772   /**
1773    * @dev mint tokens, just add total supply and mint extra to founder team.
1774    * mint for normal player will be triggered in the next transaction, can see checkLastMint function
1775    */
1776   function mint() private {
1777     uint256 normalTotal = getMintCountOfCycle(cycleCount_); 
1778     if (normalTotal > 0) {
1779       // extra to the founder team and add total supply
1780       uint256 founderAmount = normalTotal.mul(kMintFounderAdditionalRate) / kTenThousand;
1781       YHT.mintToFounder(owner, founderAmount, normalTotal);
1782     }
1783   }
1784   
1785   /**
1786    * @dev randomly out winner
1787    */
1788   function randomWinner(string randomResult) private {
1789     require(betAmount_ > 1);  
1790 
1791     // the [0, betAmount) range  
1792     uint256 value = uint256(sha3(randomResult)) % (betAmount_ - 1);
1793 
1794     // iteration get winner
1795     uint256 betAddrsCount = betAddrsCount_;
1796     for (uint256 i = 1; i < betAddrsCount; ++i) {
1797       address player = betAddrs_[i];    
1798       assert(player != address(0));
1799       uint256 weight = bets_[player].amount;
1800       if (value < weight) {
1801         // congratulations to the lucky man
1802         luckyWin(player, weight);
1803         return;
1804       }
1805       value -= weight;
1806     }
1807 
1808     // can't get here
1809     assert(false);
1810   }
1811   
1812   /**
1813    * @dev got winner & dividing the earnings & to next cycle
1814    */
1815   function luckyWin(address winner, uint256 betValue) private {
1816     require(betAmount_ > 1);
1817 
1818     // dividing the earnings
1819     uint256 betAmount = betAmount_ - 1; 
1820     uint256 amount = betAmount.add(initAmount_);  
1821     uint256 win = amount.mul(kRewardRate) / kTenThousand;
1822     uint256 next = amount.mul(kNextInitRate) / kTenThousand;
1823     uint256 earnings = amount.mul(kBonusRate) / kTenThousand;
1824     earnings = earnings.sub(referrerEarnings_ - 1);
1825     emit Divided(cycleCount_, betAmount, initAmount_, win, next, earnings);
1826     
1827     // transfer winner earnings
1828     YHT.transferExtraEarnings.value(win)(winner);
1829     emit LuckyMan(cycleCount_, nextOpenRewardTime_, winner, betValue, win);
1830 
1831     // transfer bonus earnings to people who hold YHT
1832     uint256 bonusRoundId = YHT.transferBonusEarnings.value(earnings)();
1833     
1834     // set init amount for next prize pool, clear bet information
1835     initAmount_ = next; 
1836     betCycles_[cycleCount_].amount = betAmount;
1837     betCycles_[cycleCount_].bonusRoundId = bonusRoundId;
1838     
1839     betAmount_ = 1;
1840     betAddrsCount_ = 1;
1841     betCount_ = 1;
1842     betTotalGasprice_ = 1;
1843     referrerEarnings_ = 1;
1844     
1845     // add cycleCount and to next
1846     ++cycleCount_;
1847     update(); 
1848   }
1849   
1850   /**
1851    * @dev player transfer to this contract for betting
1852    */
1853   function() isActivated isHuman isBetValueLimits(msg.value) public payable {
1854     bet(msg.sender, msg.value, 0);
1855   }
1856   
1857   /**
1858    * @dev bet with referrer
1859    */ 
1860   function betWithReferrer(uint256 referrerId) isActivated isHuman isBetValueLimits(msg.value) public payable {
1861     bet(msg.sender, msg.value, referrerId);       
1862   }
1863   
1864   /**
1865    * @dev use earnings to bet
1866    */  
1867   function betFromEarnings(uint256 value, uint256 referrerId) isActivated isHuman isBetValueLimits(value) public {
1868     YHT.withdrawForBet(msg.sender, value);
1869     bet(msg.sender, value, referrerId);
1870   }
1871   
1872   /**
1873    * @dev bet core 
1874    */
1875   function bet(address player, uint256 value, uint256 referrerId) private {
1876     checkMintStatus(player);   
1877     
1878     if (bets_[player].cycleCount == 0) {
1879       // first bet in current cycle, so update information
1880       bets_[player].cycleCount = cycleCount_;
1881       bets_[player].amount = value;
1882       betAddrs_[betAddrsCount_++] = player;
1883 
1884       // check referrer status
1885       checkReferrer(player, referrerId);
1886     } else {
1887       // not first bet in current cycle, add amount
1888       bets_[player].amount = bets_[player].amount.add(value);        
1889     }
1890     
1891     // update total amount in current cycle
1892     betAmount_ = betAmount_.add(value);
1893     
1894     // update bet count
1895     ++betCount_;
1896     
1897     //transfer earnings to referrer
1898     transferReferrerEarnings(player, value);
1899     
1900     //use to guess gas price
1901     betTotalGasprice_ = betTotalGasprice_.add(tx.gasprice);
1902     
1903     // log event
1904     emit NewBet(player, value, bets_[player].amount, betAmount_ - 1, betAddrsCount_ - 1, betCount_ - 1);
1905     
1906     // check status, sometime query maybe failed
1907     check();
1908   }
1909   
1910   /**
1911    * @dev check referrer in first bet, only first bet can bind referrer
1912    */ 
1913   function checkReferrer(address player, uint256 referrerId) private {
1914     if (referrers_[player].id == 0) {
1915       uint256 id = ++nextReferrerId_;       
1916         
1917       address referrerAddr = referrerIdToAddrs_[referrerId];
1918       if (referrerAddr != address(0)) {
1919         referrers_[player].bindReferrerId = referrerId;
1920         referrers_[player].bindCycleCount = cycleCount_;     
1921         ++referrers_[referrerAddr].beBindCount;
1922       }
1923       
1924       referrers_[player].id = id;
1925       referrerIdToAddrs_[id] = player;
1926     }
1927   }
1928   
1929   /**
1930    * @dev transfer earnings to referrer if has bind
1931    */ 
1932   function transferReferrerEarnings(address player, uint256 betValue) private {
1933     uint256 bindReferrerId = referrers_[player].bindReferrerId;
1934     if (bindReferrerId != 0) {
1935       uint256 bindCycleCount =  referrers_[player].bindCycleCount;
1936       // promotional earnings only for the specified cycle
1937       if (cycleCount_ - bindCycleCount < kReferrerEarningsCycleCount) {
1938         address referrerAddr = referrerIdToAddrs_[bindReferrerId];    
1939         assert(referrerAddr != address(0));
1940         uint256 earnings = betValue.mul(kReferrerRate) / kTenThousand; 
1941         referrers_[referrerAddr].earnings = referrers_[referrerAddr].earnings.add(earnings);
1942         referrerEarnings_ = referrerEarnings_.add(earnings); 
1943         emit ObtainReferrerEarnings(referrerAddr, referrers_[referrerAddr].beBindCount, player, earnings);
1944       } else {
1945          // recycling gas
1946          referrers_[player].bindReferrerId = 0;
1947          referrers_[player].bindCycleCount = 0;
1948       }
1949     }
1950   }
1951   
1952   /**
1953    * @dev get referrer earnings    
1954    */ 
1955   function getReferrerEarnings(address addr) view external returns(uint256) {
1956     return referrers_[addr].earnings;       
1957   }
1958   
1959   /**
1960    * @dev withdraw referrer earnings if exists
1961    */ 
1962   function checkReferrerEarnings(address addr) isYHT external {
1963     uint256 earnings = referrers_[addr].earnings;
1964     if (earnings > 0) {
1965        referrers_[addr].earnings = 0;
1966        YHT.transferExtraEarnings.value(earnings)(addr);
1967     }
1968   }
1969   
1970   /**
1971    * @dev get player last mint status
1972    */ 
1973   function getMintStatus(address addr) view private returns(uint256, uint256, bool) {
1974     uint256 lastMinAmount = 0;
1975     uint256 lastBonusRoundId = 0;
1976     bool isExpired = false;
1977       
1978     uint256 lastCycleCount = bets_[addr].cycleCount;   
1979     if (lastCycleCount != 0) {
1980       // if not current cycle, need mint token    
1981       if (lastCycleCount != cycleCount_) {
1982         uint256 lastTotal = getMintCountOfCycle(lastCycleCount);
1983         if (lastTotal > 0) {
1984           lastMinAmount = bets_[addr].amount.mul(lastTotal) / betCycles_[lastCycleCount].amount;
1985           lastBonusRoundId = betCycles_[lastCycleCount].bonusRoundId;
1986           assert(lastBonusRoundId != 0);
1987         }
1988         isExpired = true;
1989       }         
1990     }
1991     
1992     return (lastMinAmount, lastBonusRoundId, isExpired);
1993   }
1994   
1995   /**
1996    * @dev check player last mint status, mint for player if necessary
1997    */ 
1998   function checkMintStatus(address addr) private {
1999     (uint256 lastMinAmount, uint256 lastBonusRoundId, bool isExpired) = getMintStatus(addr);  
2000     if (lastMinAmount > 0) {
2001       YHT.mintToNormal(addr, lastMinAmount, lastBonusRoundId);
2002     }
2003     
2004     if (isExpired) {
2005       bets_[addr].cycleCount = 0;
2006       bets_[addr].amount = 0; 
2007     }
2008   }
2009   
2010   /**
2011    * @dev check last mint used by the YHT contract
2012    */ 
2013   function checkLastMintData(address addr) isYHT external {
2014     checkMintStatus(addr);  
2015   }
2016   
2017   /**
2018    * @dev clear warnings for unused variables
2019    */ 
2020   function unused(bool) pure private {} 
2021   
2022   /**
2023    * @dev get last mint informations used by the YHT contract
2024    */ 
2025   function getLastMintAmount(address addr) view external returns(uint256, uint256) {
2026     (uint256 lastMinAmount, uint256 lastBonusRoundId, bool isExpired) = getMintStatus(addr);
2027     unused(isExpired);
2028     return (lastMinAmount, lastBonusRoundId);
2029   }
2030   
2031  /**
2032   * @dev deposit  
2033   * In extreme cases, the remaining amount may not be able to pay the callback charges, everyone can reactivate
2034   */ 
2035   function deposit() public payable {
2036   }
2037 
2038   /**
2039    * @dev withdraw total fees to the founder team
2040    */
2041   function withdrawFee() onlyOwner public {
2042     uint256 gas = kQueryUrlCallbackGas + getQueryRandomCallbackGas();
2043     
2044     // the use of Oraclize requires the payment of a small fee
2045     uint256 remain = gas * queryCallbackGasPrice_ + 500 finney;   
2046 
2047     // total amount of Prize pool
2048     uint256 amount = (betAmount_ - 1).add(initAmount_); 
2049 
2050     // the balance available
2051     uint256 balance = address(this).balance.sub(amount).sub(remain);
2052     msg.sender.transfer(balance);
2053     emit Withdraw(msg.sender, balance);
2054   }
2055 
2056   /**
2057    * @dev get player bet value
2058    */
2059   function getPlayerBetValue(address addr) view public returns(uint256) {
2060     return bets_[addr].cycleCount == cycleCount_ ? bets_[addr].amount : 0;   
2061   } 
2062   
2063   /**
2064    * @dev get player informations at once
2065    */  
2066   function getPlayerInfos(address addr) view public returns(uint256[7], uint256[5]) {
2067     uint256[7] memory betValues = [
2068        cycleCount_,
2069        nextOpenRewardTime_,
2070        initAmount_,
2071        betAmount_ - 1,
2072        betAddrsCount_ - 1,
2073        betCount_ - 1,
2074        getPlayerBetValue(addr)
2075     ];
2076     uint256[5] memory referrerValues = [
2077       nextReferrerId_,
2078       referrers_[addr].id,
2079       referrers_[addr].bindReferrerId,
2080       referrers_[addr].bindCycleCount,
2081       referrers_[addr].beBindCount
2082     ];
2083     return (betValues, referrerValues);
2084   }
2085 }