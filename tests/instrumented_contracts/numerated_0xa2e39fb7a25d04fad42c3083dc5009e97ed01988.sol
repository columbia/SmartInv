1 pragma solidity ^0.4.21;
2 /*
3     @KAKUTAN-team
4     Ballons3D www.myethergames.fun
5     26.11.2018
6 */
7 
8 // <ORACLIZE_API>
9 /*
10 Copyright (c) 2015-2016 Oraclize SRL
11 Copyright (c) 2016 Oraclize LTD
12 Permission is hereby granted, free of charge, to any person obtaining a copy
13 of this software and associated documentation files (the "Software"), to deal
14 in the Software without restriction, including without limitation the rights
15 toe, copy, modify, merge, publish, distribute, sublicense, and/or sell
16 copies of the Software, and to permit persons to whom the Software is
17 furnished to do so, subject to the following conditions:
18 The above copyright notice and this permission notice shall be included in
19 all copies or substantial portions of the Software.
20 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
21 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
22 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
23 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER us
24 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
25 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
26 THE SOFTWARE.
27 */
28 
29 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
30 
31 pragma solidity >=0.4.18;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
32 
33 contract OraclizeI {
34     address public cbAddress;
35 
36     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
37 
38     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
39 
40     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
41 
42     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
43 
44     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
45 
46     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
47 
48     function getPrice(string _datasource) public returns (uint _dsprice);
49 
50     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
51 
52     function setProofType(byte _proofType) external;
53 
54     function setCustomGasPrice(uint _gasPrice) external;
55 
56     function randomDS_getSessionPubKeyHash() external constant returns (bytes32);
57 }
58 
59 contract OraclizeAddrResolverI {
60     function getAddress() public returns (address _addr);
61 }
62 
63 /*
64 Begin solidity-cborutils
65 https://github.com/smartcontractkit/solidity-cborutils
66 MIT License
67 Copyright (c) 2018 SmartContract ChainLink, Ltd.
68 Permission is hereby granted, free of charge, to any person obtaining a copy
69 of this software and associated documentation files (the "Software"), to deal
70 in the Software without restriction, including without limitation the rights
71 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
72 copies of the Software, and to permit persons to whom the Software is
73 furnished to do so, subject to the following conditions:
74 The above copyright notice and this permission notice shall be included in all
75 copies or substantial portions of the Software.
76 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
77 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
78 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
79 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
80 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
81 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
82 SOFTWARE.
83  */
84 
85 library Buffer {
86     struct buffer {
87         bytes buf;
88         uint capacity;
89     }
90 
91     function init(buffer memory buf, uint _capacity) internal pure {
92         uint capacity = _capacity;
93         if (capacity % 32 != 0) capacity += 32 - (capacity % 32);
94         // Allocate space for the buffer data
95         buf.capacity = capacity;
96         assembly {
97             let ptr := mload(0x40)
98             mstore(buf, ptr)
99             mstore(ptr, 0)
100             mstore(0x40, add(ptr, capacity))
101         }
102     }
103 
104     function resize(buffer memory buf, uint capacity) private pure {
105         bytes memory oldbuf = buf.buf;
106         init(buf, capacity);
107         append(buf, oldbuf);
108     }
109 
110     function max(uint a, uint b) private pure returns (uint) {
111         if (a > b) {
112             return a;
113         }
114         return b;
115     }
116 
117     /**
118      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
119      *      would exceed the capacity of the buffer.
120      * @param buf The buffer to append to.
121      * @param data The data to append.
122      * @return The original buffer.
123      */
124     function append(buffer memory buf, bytes data) internal pure returns (buffer memory) {
125         if (data.length + buf.buf.length > buf.capacity) {
126             resize(buf, max(buf.capacity, data.length) * 2);
127         }
128 
129         uint dest;
130         uint src;
131         uint len = data.length;
132         assembly {
133         // Memory address of the buffer data
134             let bufptr := mload(buf)
135         // Length of existing buffer data
136             let buflen := mload(bufptr)
137         // Start address = buffer address + buffer length + sizeof(buffer length)
138             dest := add(add(bufptr, buflen), 32)
139         // Update buffer length
140             mstore(bufptr, add(buflen, mload(data)))
141             src := add(data, 32)
142         }
143 
144         // Copy word-length chunks while possible
145         for (; len >= 32; len -= 32) {
146             assembly {
147                 mstore(dest, mload(src))
148             }
149             dest += 32;
150             src += 32;
151         }
152 
153         // Copy remaining bytes
154         uint mask = 256 ** (32 - len) - 1;
155         assembly {
156             let srcpart := and(mload(src), not(mask))
157             let destpart := and(mload(dest), mask)
158             mstore(dest, or(destpart, srcpart))
159         }
160 
161         return buf;
162     }
163 
164     /**
165      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
166      * exceed the capacity of the buffer.
167      * @param buf The buffer to append to.
168      * @param data The data to append.
169      * @return The original buffer.
170      */
171     function append(buffer memory buf, uint8 data) internal pure {
172         if (buf.buf.length + 1 > buf.capacity) {
173             resize(buf, buf.capacity * 2);
174         }
175 
176         assembly {
177         // Memory address of the buffer data
178             let bufptr := mload(buf)
179         // Length of existing buffer data
180             let buflen := mload(bufptr)
181         // Address = buffer address + buffer length + sizeof(buffer length)
182             let dest := add(add(bufptr, buflen), 32)
183             mstore8(dest, data)
184         // Update buffer length
185             mstore(bufptr, add(buflen, 1))
186         }
187     }
188 
189     /**
190      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
191      * exceed the capacity of the buffer.
192      * @param buf The buffer to append to.
193      * @param data The data to append.
194      * @return The original buffer.
195      */
196     function appendInt(buffer memory buf, uint data, uint len) internal pure returns (buffer memory) {
197         if (len + buf.buf.length > buf.capacity) {
198             resize(buf, max(buf.capacity, len) * 2);
199         }
200 
201         uint mask = 256 ** len - 1;
202         assembly {
203         // Memory address of the buffer data
204             let bufptr := mload(buf)
205         // Length of existing buffer data
206             let buflen := mload(bufptr)
207         // Address = buffer address + buffer length + sizeof(buffer length) + len
208             let dest := add(add(bufptr, buflen), len)
209             mstore(dest, or(and(mload(dest), not(mask)), data))
210         // Update buffer length
211             mstore(bufptr, add(buflen, len))
212         }
213         return buf;
214     }
215 }
216 
217 library CBOR {
218     using Buffer for Buffer.buffer;
219 
220     uint8 private constant MAJOR_TYPE_INT = 0;
221     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
222     uint8 private constant MAJOR_TYPE_BYTES = 2;
223     uint8 private constant MAJOR_TYPE_STRING = 3;
224     uint8 private constant MAJOR_TYPE_ARRAY = 4;
225     uint8 private constant MAJOR_TYPE_MAP = 5;
226     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
227 
228     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
229         if (value <= 23) {
230             buf.append(uint8((major << 5) | value));
231         } else if (value <= 0xFF) {
232             buf.append(uint8((major << 5) | 24));
233             buf.appendInt(value, 1);
234         } else if (value <= 0xFFFF) {
235             buf.append(uint8((major << 5) | 25));
236             buf.appendInt(value, 2);
237         } else if (value <= 0xFFFFFFFF) {
238             buf.append(uint8((major << 5) | 26));
239             buf.appendInt(value, 4);
240         } else if (value <= 0xFFFFFFFFFFFFFFFF) {
241             buf.append(uint8((major << 5) | 27));
242             buf.appendInt(value, 8);
243         }
244     }
245 
246     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
247         buf.append(uint8((major << 5) | 31));
248     }
249 
250     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
251         encodeType(buf, MAJOR_TYPE_INT, value);
252     }
253 
254     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
255         if (value >= 0) {
256             encodeType(buf, MAJOR_TYPE_INT, uint(value));
257         } else {
258             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(- 1 - value));
259         }
260     }
261 
262     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
263         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
264         buf.append(value);
265     }
266 
267     function encodeString(Buffer.buffer memory buf, string value) internal pure {
268         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
269         buf.append(bytes(value));
270     }
271 
272     function startArray(Buffer.buffer memory buf) internal pure {
273         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
274     }
275 
276     function startMap(Buffer.buffer memory buf) internal pure {
277         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
278     }
279 
280     function endSequence(Buffer.buffer memory buf) internal pure {
281         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
282     }
283 }
284 
285 /*
286 End solidity-cborutils
287  */
288 
289 contract usingOraclize {
290     uint constant day = 60 * 60 * 24;
291     uint constant week = 60 * 60 * 24 * 7;
292     uint constant month = 60 * 60 * 24 * 30;
293     byte constant proofType_NONE = 0x00;
294     byte constant proofType_TLSNotary = 0x10;
295     byte constant proofType_Ledger = 0x30;
296     byte constant proofType_Android = 0x40;
297     byte constant proofType_Native = 0xF0;
298     byte constant proofStorage_IPFS = 0x01;
299     uint8 constant networkID_auto = 0;
300     uint8 constant networkID_mainnet = 1;
301     uint8 constant networkID_testnet = 2;
302     uint8 constant networkID_morden = 2;
303     uint8 constant networkID_consensys = 161;
304 
305     OraclizeAddrResolverI OAR;
306 
307     OraclizeI oraclize;
308     modifier oraclizeAPI {
309         if ((address(OAR) == 0) || (getCodeSize(address(OAR)) == 0))
310             oraclize_setNetwork(networkID_auto);
311 
312         if (address(oraclize) != OAR.getAddress())
313             oraclize = OraclizeI(OAR.getAddress());
314 
315         _;
316     }
317     modifier coupon(string code){
318         oraclize = OraclizeI(OAR.getAddress());
319         _;
320     }
321 
322     function oraclize_setNetwork(uint8 networkID) internal returns (bool){
323         return oraclize_setNetwork();
324         networkID;
325         // silence the warning and remain backwards compatible
326     }
327 
328     function oraclize_setNetwork() internal returns (bool){
329         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed) > 0) {//mainnet
330             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
331             oraclize_setNetworkName("eth_mainnet");
332             return true;
333         }
334         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1) > 0) {//ropsten testnet
335             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
336             oraclize_setNetworkName("eth_ropsten3");
337             return true;
338         }
339         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e) > 0) {//kovan testnet
340             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
341             oraclize_setNetworkName("eth_kovan");
342             return true;
343         }
344         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48) > 0) {//rinkeby testnet
345             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
346             oraclize_setNetworkName("eth_rinkeby");
347             return true;
348         }
349         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475) > 0) {//ethereum-bridge
350             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
351             return true;
352         }
353         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF) > 0) {//ether.camp ide
354             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
355             return true;
356         }
357         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA) > 0) {//browser-solidity
358             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
359             return true;
360         }
361         return false;
362     }
363 
364     function __callback(bytes32 myid, string result) public {
365         __callback(myid, result, new bytes(0));
366     }
367 
368     function __callback(bytes32 myid, string result, bytes proof) public {
369         return;
370         myid;
371         result;
372         proof;
373         // Silence compiler warnings
374     }
375 
376     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
377         return oraclize.getPrice(datasource);
378     }
379 
380     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
381         return oraclize.getPrice(datasource, gaslimit);
382     }
383 
384     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
385         uint price = oraclize.getPrice(datasource);
386         if (price > 1 ether + tx.gasprice * 200000) return 0;
387         // unexpectedly high price
388         return oraclize.query.value(price)(0, datasource, arg);
389     }
390 
391     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
392         uint price = oraclize.getPrice(datasource);
393         if (price > 1 ether + tx.gasprice * 200000) return 0;
394         // unexpectedly high price
395         return oraclize.query.value(price)(timestamp, datasource, arg);
396     }
397 
398     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
399         uint price = oraclize.getPrice(datasource, gaslimit);
400         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
401         // unexpectedly high price
402         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
403     }
404 
405     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
406         uint price = oraclize.getPrice(datasource, gaslimit);
407         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
408         // unexpectedly high price
409         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
410     }
411 
412     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
413         uint price = oraclize.getPrice(datasource);
414         if (price > 1 ether + tx.gasprice * 200000) return 0;
415         // unexpectedly high price
416         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
417     }
418 
419     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
420         uint price = oraclize.getPrice(datasource);
421         if (price > 1 ether + tx.gasprice * 200000) return 0;
422         // unexpectedly high price
423         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
424     }
425 
426     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
427         uint price = oraclize.getPrice(datasource, gaslimit);
428         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
429         // unexpectedly high price
430         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
431     }
432 
433     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
434         uint price = oraclize.getPrice(datasource, gaslimit);
435         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
436         // unexpectedly high price
437         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
438     }
439 
440     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
441         uint price = oraclize.getPrice(datasource);
442         if (price > 1 ether + tx.gasprice * 200000) return 0;
443         // unexpectedly high price
444         bytes memory args = stra2cbor(argN);
445         return oraclize.queryN.value(price)(0, datasource, args);
446     }
447 
448     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
449         uint price = oraclize.getPrice(datasource);
450         if (price > 1 ether + tx.gasprice * 200000) return 0;
451         // unexpectedly high price
452         bytes memory args = stra2cbor(argN);
453         return oraclize.queryN.value(price)(timestamp, datasource, args);
454     }
455 
456     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
457         uint price = oraclize.getPrice(datasource, gaslimit);
458         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
459         // unexpectedly high price
460         bytes memory args = stra2cbor(argN);
461         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
462     }
463 
464     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
465         uint price = oraclize.getPrice(datasource, gaslimit);
466         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
467         // unexpectedly high price
468         bytes memory args = stra2cbor(argN);
469         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
470     }
471 
472     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
473         string[] memory dynargs = new string[](1);
474         dynargs[0] = args[0];
475         return oraclize_query(datasource, dynargs);
476     }
477 
478     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
479         string[] memory dynargs = new string[](1);
480         dynargs[0] = args[0];
481         return oraclize_query(timestamp, datasource, dynargs);
482     }
483 
484     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
485         string[] memory dynargs = new string[](1);
486         dynargs[0] = args[0];
487         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
488     }
489 
490     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
491         string[] memory dynargs = new string[](1);
492         dynargs[0] = args[0];
493         return oraclize_query(datasource, dynargs, gaslimit);
494     }
495 
496     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
497         string[] memory dynargs = new string[](2);
498         dynargs[0] = args[0];
499         dynargs[1] = args[1];
500         return oraclize_query(datasource, dynargs);
501     }
502 
503     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
504         string[] memory dynargs = new string[](2);
505         dynargs[0] = args[0];
506         dynargs[1] = args[1];
507         return oraclize_query(timestamp, datasource, dynargs);
508     }
509 
510     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
511         string[] memory dynargs = new string[](2);
512         dynargs[0] = args[0];
513         dynargs[1] = args[1];
514         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
515     }
516 
517     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
518         string[] memory dynargs = new string[](2);
519         dynargs[0] = args[0];
520         dynargs[1] = args[1];
521         return oraclize_query(datasource, dynargs, gaslimit);
522     }
523 
524     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
525         string[] memory dynargs = new string[](3);
526         dynargs[0] = args[0];
527         dynargs[1] = args[1];
528         dynargs[2] = args[2];
529         return oraclize_query(datasource, dynargs);
530     }
531 
532     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
533         string[] memory dynargs = new string[](3);
534         dynargs[0] = args[0];
535         dynargs[1] = args[1];
536         dynargs[2] = args[2];
537         return oraclize_query(timestamp, datasource, dynargs);
538     }
539 
540     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
541         string[] memory dynargs = new string[](3);
542         dynargs[0] = args[0];
543         dynargs[1] = args[1];
544         dynargs[2] = args[2];
545         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
546     }
547 
548     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
549         string[] memory dynargs = new string[](3);
550         dynargs[0] = args[0];
551         dynargs[1] = args[1];
552         dynargs[2] = args[2];
553         return oraclize_query(datasource, dynargs, gaslimit);
554     }
555 
556     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
557         string[] memory dynargs = new string[](4);
558         dynargs[0] = args[0];
559         dynargs[1] = args[1];
560         dynargs[2] = args[2];
561         dynargs[3] = args[3];
562         return oraclize_query(datasource, dynargs);
563     }
564 
565     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
566         string[] memory dynargs = new string[](4);
567         dynargs[0] = args[0];
568         dynargs[1] = args[1];
569         dynargs[2] = args[2];
570         dynargs[3] = args[3];
571         return oraclize_query(timestamp, datasource, dynargs);
572     }
573 
574     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
575         string[] memory dynargs = new string[](4);
576         dynargs[0] = args[0];
577         dynargs[1] = args[1];
578         dynargs[2] = args[2];
579         dynargs[3] = args[3];
580         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
581     }
582 
583     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
584         string[] memory dynargs = new string[](4);
585         dynargs[0] = args[0];
586         dynargs[1] = args[1];
587         dynargs[2] = args[2];
588         dynargs[3] = args[3];
589         return oraclize_query(datasource, dynargs, gaslimit);
590     }
591 
592     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
593         string[] memory dynargs = new string[](5);
594         dynargs[0] = args[0];
595         dynargs[1] = args[1];
596         dynargs[2] = args[2];
597         dynargs[3] = args[3];
598         dynargs[4] = args[4];
599         return oraclize_query(datasource, dynargs);
600     }
601 
602     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
603         string[] memory dynargs = new string[](5);
604         dynargs[0] = args[0];
605         dynargs[1] = args[1];
606         dynargs[2] = args[2];
607         dynargs[3] = args[3];
608         dynargs[4] = args[4];
609         return oraclize_query(timestamp, datasource, dynargs);
610     }
611 
612     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
613         string[] memory dynargs = new string[](5);
614         dynargs[0] = args[0];
615         dynargs[1] = args[1];
616         dynargs[2] = args[2];
617         dynargs[3] = args[3];
618         dynargs[4] = args[4];
619         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
620     }
621 
622     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
623         string[] memory dynargs = new string[](5);
624         dynargs[0] = args[0];
625         dynargs[1] = args[1];
626         dynargs[2] = args[2];
627         dynargs[3] = args[3];
628         dynargs[4] = args[4];
629         return oraclize_query(datasource, dynargs, gaslimit);
630     }
631 
632     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
633         uint price = oraclize.getPrice(datasource);
634         if (price > 1 ether + tx.gasprice * 200000) return 0;
635         // unexpectedly high price
636         bytes memory args = ba2cbor(argN);
637         return oraclize.queryN.value(price)(0, datasource, args);
638     }
639 
640     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
641         uint price = oraclize.getPrice(datasource);
642         if (price > 1 ether + tx.gasprice * 200000) return 0;
643         // unexpectedly high price
644         bytes memory args = ba2cbor(argN);
645         return oraclize.queryN.value(price)(timestamp, datasource, args);
646     }
647 
648     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
649         uint price = oraclize.getPrice(datasource, gaslimit);
650         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
651         // unexpectedly high price
652         bytes memory args = ba2cbor(argN);
653         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
654     }
655 
656     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
657         uint price = oraclize.getPrice(datasource, gaslimit);
658         if (price > 1 ether + tx.gasprice * gaslimit) return 0;
659         // unexpectedly high price
660         bytes memory args = ba2cbor(argN);
661         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
662     }
663 
664     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
665         bytes[] memory dynargs = new bytes[](1);
666         dynargs[0] = args[0];
667         return oraclize_query(datasource, dynargs);
668     }
669 
670     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
671         bytes[] memory dynargs = new bytes[](1);
672         dynargs[0] = args[0];
673         return oraclize_query(timestamp, datasource, dynargs);
674     }
675 
676     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
677         bytes[] memory dynargs = new bytes[](1);
678         dynargs[0] = args[0];
679         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
680     }
681 
682     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
683         bytes[] memory dynargs = new bytes[](1);
684         dynargs[0] = args[0];
685         return oraclize_query(datasource, dynargs, gaslimit);
686     }
687 
688     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
689         bytes[] memory dynargs = new bytes[](2);
690         dynargs[0] = args[0];
691         dynargs[1] = args[1];
692         return oraclize_query(datasource, dynargs);
693     }
694 
695     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
696         bytes[] memory dynargs = new bytes[](2);
697         dynargs[0] = args[0];
698         dynargs[1] = args[1];
699         return oraclize_query(timestamp, datasource, dynargs);
700     }
701 
702     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
703         bytes[] memory dynargs = new bytes[](2);
704         dynargs[0] = args[0];
705         dynargs[1] = args[1];
706         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
707     }
708 
709     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
710         bytes[] memory dynargs = new bytes[](2);
711         dynargs[0] = args[0];
712         dynargs[1] = args[1];
713         return oraclize_query(datasource, dynargs, gaslimit);
714     }
715 
716     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
717         bytes[] memory dynargs = new bytes[](3);
718         dynargs[0] = args[0];
719         dynargs[1] = args[1];
720         dynargs[2] = args[2];
721         return oraclize_query(datasource, dynargs);
722     }
723 
724     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
725         bytes[] memory dynargs = new bytes[](3);
726         dynargs[0] = args[0];
727         dynargs[1] = args[1];
728         dynargs[2] = args[2];
729         return oraclize_query(timestamp, datasource, dynargs);
730     }
731 
732     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
733         bytes[] memory dynargs = new bytes[](3);
734         dynargs[0] = args[0];
735         dynargs[1] = args[1];
736         dynargs[2] = args[2];
737         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
738     }
739 
740     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
741         bytes[] memory dynargs = new bytes[](3);
742         dynargs[0] = args[0];
743         dynargs[1] = args[1];
744         dynargs[2] = args[2];
745         return oraclize_query(datasource, dynargs, gaslimit);
746     }
747 
748     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
749         bytes[] memory dynargs = new bytes[](4);
750         dynargs[0] = args[0];
751         dynargs[1] = args[1];
752         dynargs[2] = args[2];
753         dynargs[3] = args[3];
754         return oraclize_query(datasource, dynargs);
755     }
756 
757     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
758         bytes[] memory dynargs = new bytes[](4);
759         dynargs[0] = args[0];
760         dynargs[1] = args[1];
761         dynargs[2] = args[2];
762         dynargs[3] = args[3];
763         return oraclize_query(timestamp, datasource, dynargs);
764     }
765 
766     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
767         bytes[] memory dynargs = new bytes[](4);
768         dynargs[0] = args[0];
769         dynargs[1] = args[1];
770         dynargs[2] = args[2];
771         dynargs[3] = args[3];
772         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
773     }
774 
775     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
776         bytes[] memory dynargs = new bytes[](4);
777         dynargs[0] = args[0];
778         dynargs[1] = args[1];
779         dynargs[2] = args[2];
780         dynargs[3] = args[3];
781         return oraclize_query(datasource, dynargs, gaslimit);
782     }
783 
784     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
785         bytes[] memory dynargs = new bytes[](5);
786         dynargs[0] = args[0];
787         dynargs[1] = args[1];
788         dynargs[2] = args[2];
789         dynargs[3] = args[3];
790         dynargs[4] = args[4];
791         return oraclize_query(datasource, dynargs);
792     }
793 
794     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
795         bytes[] memory dynargs = new bytes[](5);
796         dynargs[0] = args[0];
797         dynargs[1] = args[1];
798         dynargs[2] = args[2];
799         dynargs[3] = args[3];
800         dynargs[4] = args[4];
801         return oraclize_query(timestamp, datasource, dynargs);
802     }
803 
804     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
805         bytes[] memory dynargs = new bytes[](5);
806         dynargs[0] = args[0];
807         dynargs[1] = args[1];
808         dynargs[2] = args[2];
809         dynargs[3] = args[3];
810         dynargs[4] = args[4];
811         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
812     }
813 
814     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
815         bytes[] memory dynargs = new bytes[](5);
816         dynargs[0] = args[0];
817         dynargs[1] = args[1];
818         dynargs[2] = args[2];
819         dynargs[3] = args[3];
820         dynargs[4] = args[4];
821         return oraclize_query(datasource, dynargs, gaslimit);
822     }
823 
824     function oraclize_cbAddress() oraclizeAPI internal returns (address){
825         return oraclize.cbAddress();
826     }
827 
828     function oraclize_setProof(byte proofP) oraclizeAPI internal {
829         return oraclize.setProofType(proofP);
830     }
831 
832     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
833         return oraclize.setCustomGasPrice(gasPrice);
834     }
835 
836     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
837         return oraclize.randomDS_getSessionPubKeyHash();
838     }
839 
840     function getCodeSize(address _addr) constant internal returns (uint _size) {
841         assembly {
842             _size := extcodesize(_addr)
843         }
844     }
845 
846     function parseAddr(string _a) internal pure returns (address){
847         bytes memory tmp = bytes(_a);
848         uint160 iaddr = 0;
849         uint160 b1;
850         uint160 b2;
851         for (uint i = 2; i < 2 + 2 * 20; i += 2) {
852             iaddr *= 256;
853             b1 = uint160(tmp[i]);
854             b2 = uint160(tmp[i + 1]);
855             if ((b1 >= 97) && (b1 <= 102)) b1 -= 87;
856             else if ((b1 >= 65) && (b1 <= 70)) b1 -= 55;
857             else if ((b1 >= 48) && (b1 <= 57)) b1 -= 48;
858             if ((b2 >= 97) && (b2 <= 102)) b2 -= 87;
859             else if ((b2 >= 65) && (b2 <= 70)) b2 -= 55;
860             else if ((b2 >= 48) && (b2 <= 57)) b2 -= 48;
861             iaddr += (b1 * 16 + b2);
862         }
863         return address(iaddr);
864     }
865 
866     function strCompare(string _a, string _b) internal pure returns (int) {
867         bytes memory a = bytes(_a);
868         bytes memory b = bytes(_b);
869         uint minLength = a.length;
870         if (b.length < minLength) minLength = b.length;
871         for (uint i = 0; i < minLength; i ++)
872             if (a[i] < b[i])
873                 return - 1;
874             else if (a[i] > b[i])
875                 return 1;
876         if (a.length < b.length)
877             return - 1;
878         else if (a.length > b.length)
879             return 1;
880         else
881             return 0;
882     }
883 
884     function indexOf(string _haystack, string _needle) internal pure returns (int) {
885         bytes memory h = bytes(_haystack);
886         bytes memory n = bytes(_needle);
887         if (h.length < 1 || n.length < 1 || (n.length > h.length))
888             return - 1;
889         else if (h.length > (2 ** 128 - 1))
890             return - 1;
891         else
892         {
893             uint subindex = 0;
894             for (uint i = 0; i < h.length; i ++)
895             {
896                 if (h[i] == n[0])
897                 {
898                     subindex = 1;
899                     while (subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
900                     {
901                         subindex++;
902                     }
903                     if (subindex == n.length)
904                         return int(i);
905                 }
906             }
907             return - 1;
908         }
909     }
910 
911     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
912         bytes memory _ba = bytes(_a);
913         bytes memory _bb = bytes(_b);
914         bytes memory _bc = bytes(_c);
915         bytes memory _bd = bytes(_d);
916         bytes memory _be = bytes(_e);
917         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
918         bytes memory babcde = bytes(abcde);
919         uint k = 0;
920         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
921         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
922         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
923         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
924         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
925         return string(babcde);
926     }
927 
928     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
929         return strConcat(_a, _b, _c, _d, "");
930     }
931 
932     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
933         return strConcat(_a, _b, _c, "", "");
934     }
935 
936     function strConcat(string _a, string _b) internal pure returns (string) {
937         return strConcat(_a, _b, "", "", "");
938     }
939 
940     // parseInt
941     function parseInt(string _a) internal pure returns (uint) {
942         return parseInt(_a, 0);
943     }
944 
945     // parseInt(parseFloat*10^_b)
946     function parseInt(string _a, uint _b) internal pure returns (uint) {
947         bytes memory bresult = bytes(_a);
948         uint mint = 0;
949         bool decimals = false;
950         for (uint i = 0; i < bresult.length; i++) {
951             if ((bresult[i] >= 48) && (bresult[i] <= 57)) {
952                 if (decimals) {
953                     if (_b == 0) break;
954                     else _b--;
955                 }
956                 mint *= 10;
957                 mint += uint(bresult[i]) - 48;
958             } else if (bresult[i] == 46) decimals = true;
959         }
960         if (_b > 0) mint *= 10 ** _b;
961         return mint;
962     }
963 
964     function uint2str(uint i) internal pure returns (string){
965         if (i == 0) return "0";
966         uint j = i;
967         uint len;
968         while (j != 0) {
969             len++;
970             j /= 10;
971         }
972         bytes memory bstr = new bytes(len);
973         uint k = len - 1;
974         while (i != 0) {
975             bstr[k--] = byte(48 + i % 10);
976             i /= 10;
977         }
978         return string(bstr);
979     }
980 
981     using CBOR for Buffer.buffer;
982     function stra2cbor(string[] arr) internal pure returns (bytes) {
983         safeMemoryCleaner();
984         Buffer.buffer memory buf;
985         Buffer.init(buf, 1024);
986         buf.startArray();
987         for (uint i = 0; i < arr.length; i++) {
988             buf.encodeString(arr[i]);
989         }
990         buf.endSequence();
991         return buf.buf;
992     }
993 
994     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
995         safeMemoryCleaner();
996         Buffer.buffer memory buf;
997         Buffer.init(buf, 1024);
998         buf.startArray();
999         for (uint i = 0; i < arr.length; i++) {
1000             buf.encodeBytes(arr[i]);
1001         }
1002         buf.endSequence();
1003         return buf.buf;
1004     }
1005 
1006     string oraclize_network_name;
1007 
1008     function oraclize_setNetworkName(string _network_name) internal {
1009         oraclize_network_name = _network_name;
1010     }
1011 
1012     function oraclize_getNetworkName() internal view returns (string) {
1013         return oraclize_network_name;
1014     }
1015 
1016     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1017         require((_nbytes > 0) && (_nbytes <= 32));
1018         // Convert from seconds to ledger timer ticks
1019         _delay *= 10;
1020         bytes memory nbytes = new bytes(1);
1021         nbytes[0] = byte(_nbytes);
1022         bytes memory unonce = new bytes(32);
1023         bytes memory sessionKeyHash = new bytes(32);
1024         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1025         assembly {
1026             mstore(unonce, 0x20)
1027         // the following variables can be relaxed
1028         // check relaxed random contract under ethereum-examples repo
1029         // for an idea on how to override and replace comit hash vars
1030             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1031             mstore(sessionKeyHash, 0x20)
1032             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1033         }
1034         bytes memory delay = new bytes(32);
1035         assembly {
1036             mstore(add(delay, 0x20), _delay)
1037         }
1038 
1039         bytes memory delay_bytes8 = new bytes(8);
1040         copyBytes(delay, 24, 8, delay_bytes8, 0);
1041 
1042         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1043         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1044 
1045         bytes memory delay_bytes8_left = new bytes(8);
1046 
1047         assembly {
1048             let x := mload(add(delay_bytes8, 0x20))
1049             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1050             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1051             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1052             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1053             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1054             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1055             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1056             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1057 
1058         }
1059 
1060         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1061         return queryId;
1062     }
1063 
1064     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1065         oraclize_randomDS_args[queryId] = commitment;
1066     }
1067 
1068     mapping(bytes32 => bytes32) oraclize_randomDS_args;
1069     mapping(bytes32 => bool) oraclize_randomDS_sessionKeysHashVerified;
1070 
1071     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1072         bool sigok;
1073         address signer;
1074 
1075         bytes32 sigr;
1076         bytes32 sigs;
1077 
1078         bytes memory sigr_ = new bytes(32);
1079         uint offset = 4 + (uint(dersig[3]) - 0x20);
1080         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1081         bytes memory sigs_ = new bytes(32);
1082         offset += 32 + 2;
1083         sigs_ = copyBytes(dersig, offset + (uint(dersig[offset - 1]) - 0x20), 32, sigs_, 0);
1084 
1085         assembly {
1086             sigr := mload(add(sigr_, 32))
1087             sigs := mload(add(sigs_, 32))
1088         }
1089 
1090 
1091         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1092         if (address(keccak256(pubkey)) == signer) return true;
1093         else {
1094             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1095             return (address(keccak256(pubkey)) == signer);
1096         }
1097     }
1098 
1099     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1100         bool sigok;
1101 
1102         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1103         bytes memory sig2 = new bytes(uint(proof[sig2offset + 1]) + 2);
1104         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1105 
1106         bytes memory appkey1_pubkey = new bytes(64);
1107         copyBytes(proof, 3 + 1, 64, appkey1_pubkey, 0);
1108 
1109         bytes memory tosign2 = new bytes(1 + 65 + 32);
1110         tosign2[0] = byte(1);
1111         //role
1112         copyBytes(proof, sig2offset - 65, 65, tosign2, 1);
1113         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1114         copyBytes(CODEHASH, 0, 32, tosign2, 1 + 65);
1115         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1116 
1117         if (sigok == false) return false;
1118 
1119 
1120         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1121         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1122 
1123         bytes memory tosign3 = new bytes(1 + 65);
1124         tosign3[0] = 0xFE;
1125         copyBytes(proof, 3, 65, tosign3, 1);
1126 
1127         bytes memory sig3 = new bytes(uint(proof[3 + 65 + 1]) + 2);
1128         copyBytes(proof, 3 + 65, sig3.length, sig3, 0);
1129 
1130         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1131 
1132         return sigok;
1133     }
1134 
1135     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1136         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1137         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1138 
1139         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1140         require(proofVerified);
1141 
1142         _;
1143     }
1144 
1145     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1146         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1147         if ((_proof[0] != "L") || (_proof[1] != "P") || (_proof[2] != 1)) return 1;
1148 
1149         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1150         if (proofVerified == false) return 2;
1151 
1152         return 0;
1153     }
1154 
1155     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1156         bool match_ = true;
1157 
1158         require(prefix.length == n_random_bytes);
1159 
1160         for (uint256 i = 0; i < n_random_bytes; i++) {
1161             if (content[i] != prefix[i]) match_ = false;
1162         }
1163 
1164         return match_;
1165     }
1166 
1167     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1168 
1169         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1170         uint ledgerProofLength = 3 + 65 + (uint(proof[3 + 65 + 1]) + 2) + 32;
1171         bytes memory keyhash = new bytes(32);
1172         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1173         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1174 
1175         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength + (32 + 8 + 1 + 32) + 1]) + 2);
1176         copyBytes(proof, ledgerProofLength + (32 + 8 + 1 + 32), sig1.length, sig1, 0);
1177 
1178         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1179         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength + 32 + 8]))) return false;
1180 
1181         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1182         // This is to verify that the computed args match with the ones specified in the query.
1183         bytes memory commitmentSlice1 = new bytes(8 + 1 + 32);
1184         copyBytes(proof, ledgerProofLength + 32, 8 + 1 + 32, commitmentSlice1, 0);
1185 
1186         bytes memory sessionPubkey = new bytes(64);
1187         uint sig2offset = ledgerProofLength + 32 + (8 + 1 + 32) + sig1.length + 65;
1188         copyBytes(proof, sig2offset - 64, 64, sessionPubkey, 0);
1189 
1190         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1191         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)) {//unonce, nbytes and sessionKeyHash match
1192             delete oraclize_randomDS_args[queryId];
1193         } else return false;
1194 
1195 
1196         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1197         bytes memory tosign1 = new bytes(32 + 8 + 1 + 32);
1198         copyBytes(proof, ledgerProofLength, 32 + 8 + 1 + 32, tosign1, 0);
1199         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1200 
1201         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1202         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false) {
1203             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1204         }
1205 
1206         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1207     }
1208 
1209     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1210     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1211         uint minLength = length + toOffset;
1212 
1213         // Buffer too small
1214         require(to.length >= minLength);
1215         // Should be a better way?
1216 
1217         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1218         uint i = 32 + fromOffset;
1219         uint j = 32 + toOffset;
1220 
1221         while (i < (32 + fromOffset + length)) {
1222             assembly {
1223                 let tmp := mload(add(from, i))
1224                 mstore(add(to, j), tmp)
1225             }
1226             i += 32;
1227             j += 32;
1228         }
1229 
1230         return to;
1231     }
1232 
1233     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1234     // Duplicate Solidity's ecrecover, but catching the CALL return value
1235     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1236         // We do our own memory management here. Solidity uses memory offset
1237         // 0x40 to store the current end of memory. We write past it (as
1238         // writes are memory extensions), but don't update the offset so
1239         // Solidity will reuse it. The memory used here is only needed for
1240         // this context.
1241 
1242         // FIXME: inline assembly can't access return values
1243         bool ret;
1244         address addr;
1245 
1246         assembly {
1247             let size := mload(0x40)
1248             mstore(size, hash)
1249             mstore(add(size, 32), v)
1250             mstore(add(size, 64), r)
1251             mstore(add(size, 96), s)
1252 
1253         // NOTE: we can reuse the request memory because we deal with
1254         //       the return code
1255             ret := call(3000, 1, 0, size, 128, size, 32)
1256             addr := mload(size)
1257         }
1258 
1259         return (ret, addr);
1260     }
1261 
1262     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1263     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1264         bytes32 r;
1265         bytes32 s;
1266         uint8 v;
1267 
1268         if (sig.length != 65)
1269             return (false, 0);
1270 
1271         // The signature format is a compact form of:
1272         //   {bytes32 r}{bytes32 s}{uint8 v}
1273         // Compact means, uint8 is not padded to 32 bytes.
1274         assembly {
1275             r := mload(add(sig, 32))
1276             s := mload(add(sig, 64))
1277 
1278         // Here we are loading the last 32 bytes. We exploit the fact that
1279         // 'mload' will pad with zeroes if we overread.
1280         // There is no 'mload8' to do this, but that would be nicer.
1281             v := byte(0, mload(add(sig, 96)))
1282 
1283         // Alternative solution:
1284         // 'byte' is not working due to the Solidity parser, so lets
1285         // use the second best option, 'and'
1286         // v := and(mload(add(sig, 65)), 255)
1287         }
1288 
1289         // albeit non-transactional signatures are not specified by the YP, one would expect it
1290         // to match the YP range of [27, 28]
1291         //
1292         // geth uses [0, 1] and some clients have followed. This might change, see:
1293         //  https://github.com/ethereum/go-ethereum/issues/2053
1294         if (v < 27)
1295             v += 27;
1296 
1297         if (v != 27 && v != 28)
1298             return (false, 0);
1299 
1300         return safer_ecrecover(hash, v, r, s);
1301     }
1302 
1303     function safeMemoryCleaner() internal pure {
1304         assembly {
1305             let fmem := mload(0x40)
1306             codecopy(fmem, codesize, sub(msize, fmem))
1307         }
1308     }
1309 
1310 }
1311 // </ORACLIZE_API>
1312 
1313 
1314 /**
1315  * @title Ownable
1316  * @dev The Ownable contract has an owner address, and provides basic authorization control
1317  * functions, this simplifies the implementation of "user permissions".
1318  */
1319 contract Ownable {
1320     address public owner;
1321 
1322     event OwnershipRenounced(address indexed previousOwner);
1323     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1324 
1325     /**
1326      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1327      * account.
1328      */
1329     constructor() public {
1330         owner = msg.sender;
1331     }
1332 
1333     /**
1334      * @dev Throws if called by any account other than the owner.
1335      */
1336     modifier onlyOwner() {
1337         require(msg.sender == owner);
1338         _;
1339     }
1340 
1341     /**
1342      * @dev Allows the current owner to transfer control of the contract to a newOwner.
1343      * @param _newOwner The address to transfer ownership to.
1344      */
1345     function transferOwnership(address _newOwner) public onlyOwner {
1346         _transferOwnership(_newOwner);
1347     }
1348 
1349     /**
1350      * @dev Transfers control of the contract to a newOwner.
1351      * @param _newOwner The address to transfer ownership to.
1352      */
1353     function _transferOwnership(address _newOwner) internal {
1354         require(_newOwner != address(0));
1355         emit OwnershipTransferred(owner, _newOwner);
1356         owner = _newOwner;
1357     }
1358 }
1359 
1360 /**
1361  * @title SafeMath
1362  * @dev Math operations with safety checks that throw on error
1363  */
1364 library SafeMath {
1365 
1366     /**
1367     * @dev Multiplies two numbers, throws on overflow.
1368     */
1369     function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
1370         // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
1371         // benefit is lost if 'b' is also tested.
1372         if (a == 0) {
1373             return 0;
1374         }
1375 
1376         c = a * b;
1377         assert(c / a == b);
1378         return c;
1379     }
1380 
1381     /**
1382     * @dev Integer division of two numbers, truncating the quotient.
1383     */
1384     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1385         // assert(b > 0); // Solidity automatically throws when dividing by 0
1386         // uint256 c = a / b;
1387         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1388         return a / b;
1389     }
1390 
1391     /**
1392     * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1393     */
1394     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1395         assert(b <= a);
1396         return a - b;
1397     }
1398 
1399     /**
1400     * @dev Adds two numbers, throws on overflow.
1401     */
1402     function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
1403         c = a + b;
1404         assert(c >= a);
1405         return c;
1406     }
1407 }
1408 
1409 library SafeMath16 {
1410     function mul(uint16 a, uint16 b) internal pure returns (uint16) {
1411         if (a == 0) {
1412             return 0;
1413         }
1414         uint16 c = a * b;
1415         assert(c / a == b);
1416         return c;
1417     }
1418 
1419     function div(uint16 a, uint16 b) internal pure returns (uint16) {
1420         // assert(b > 0); // Solidity automatically throws when dividing by 0
1421         uint16 c = a / b;
1422         // assert(a == b * c + a % b); // There is no case in which this doesn’t hold
1423         return c;
1424     }
1425 
1426     function sub(uint16 a, uint16 b) internal pure returns (uint16) {
1427         assert(b <= a);
1428         return a - b;
1429     }
1430 
1431     function add(uint16 a, uint16 b) internal pure returns (uint16) {
1432         uint16 c = a + b;
1433         assert(c >= a);
1434         return c;
1435     }
1436 }
1437 
1438 
1439 /**
1440  * @title ERC20Basic
1441  * @dev Simpler version of ERC20 interface
1442  */
1443 contract ERC20Basic {
1444     function totalSupply() public view returns (uint256);
1445 
1446     function balanceOf(address who) public view returns (uint256);
1447 
1448     function transfer(address to, uint256 value) public returns (bool);
1449 
1450     event Transfer(address indexed from, address indexed to, uint256 value);
1451 }
1452 
1453 /**
1454  * @title ERC20 interface
1455  */
1456 contract ERC20 is ERC20Basic {
1457     function allowance(address owner, address spender) public view returns (uint256);
1458 
1459     function transferFrom(address from, address to, uint256 value) public returns (bool);
1460 
1461     function approve(address spender, uint256 value) public returns (bool);
1462 
1463     event Approval(address indexed owner, address indexed spender, uint256 value);
1464 }
1465 
1466 /**
1467  * @title Basic token
1468  * @dev Basic version of StandardToken, with no allowances.
1469  */
1470 contract BasicToken is ERC20Basic {
1471     using SafeMath for uint256;
1472 
1473     mapping(address => uint256) balances;
1474 
1475     uint256 totalSupply_;
1476 
1477     /**
1478     * @dev Total number of tokens in existence
1479     */
1480     function totalSupply() public view returns (uint256) {
1481         return totalSupply_;
1482     }
1483 
1484     /**
1485     * Internal transfer, only can be called by this contract
1486     */
1487 
1488     function _transfer(address _to, uint _value) internal {
1489         require(_to != address(0));
1490         require(_value <= balances[msg.sender]);
1491 
1492         balances[msg.sender] = balances[msg.sender].sub(_value);
1493         balances[_to] = balances[_to].add(_value);
1494         emit Transfer(msg.sender, _to, _value);
1495     }
1496 
1497     /**
1498     * @dev Transfer token for a specified address
1499     * @param _to The address to transfer to.
1500     * @param _value The amount to be transferred.
1501     */
1502 
1503     function transfer(address _to, uint256 _value) public returns (bool) {
1504         _transfer(_to, _value);
1505         return true;
1506     }
1507 
1508     /**
1509     * @dev Gets the balance of the specified address.
1510     * @param _owner The address to query the the balance of.
1511     * @return An uint256 representing the amount owned by the passed address.
1512     */
1513     function balanceOf(address _owner) public view returns (uint256) {
1514         return balances[_owner];
1515     }
1516 
1517 }
1518 
1519 /**
1520  * @title Standard ERC20 token
1521  *
1522  * @dev Implementation of the basic standard token.
1523  */
1524 contract StandardToken is ERC20, BasicToken {
1525 
1526     mapping(address => mapping(address => uint256)) internal allowed;
1527 
1528 
1529     /**
1530      * @dev Transfer tokens from one address to another
1531      * @param _from address The address which you want to send tokens from
1532      * @param _to address The address which you want to transfer to
1533      * @param _value uint256 the amount of tokens to be transferred
1534      */
1535     function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
1536         require(_to != address(0));
1537         require(_value <= balances[_from]);
1538         require(_value <= allowed[_from][msg.sender]);
1539 
1540         balances[_from] = balances[_from].sub(_value);
1541         balances[_to] = balances[_to].add(_value);
1542         allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1543         emit Transfer(_from, _to, _value);
1544         return true;
1545     }
1546 
1547     /**
1548      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1549      *
1550      * Beware that changing an allowance with this method brings the risk that someone may use both the old
1551      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1552      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1553      * @param _spender The address which will spend the funds.
1554      * @param _value The amount of tokens to be spent.
1555      */
1556     function approve(address _spender, uint256 _value) public returns (bool) {
1557         allowed[msg.sender][_spender] = _value;
1558         emit Approval(msg.sender, _spender, _value);
1559         return true;
1560     }
1561 
1562     /**
1563      * @dev Function to check the amount of tokens that an owner allowed to a spender.
1564      * @param _owner address The address which owns the funds.
1565      * @param _spender address The address which will spend the funds.
1566      * @return A uint256 specifying the amount of tokens still available for the spender.
1567      */
1568     function allowance(address _owner, address _spender) public view returns (uint256) {
1569         return allowed[_owner][_spender];
1570     }
1571 
1572 }
1573 
1574 contract MintableToken is BasicToken, StandardToken, Ownable {
1575 
1576     event Mint(address indexed to, uint256 amount);
1577 
1578     event MintFinished();
1579 
1580     bool public mintingFinished = false;
1581 
1582 
1583     function mint(address _to, uint256 _amount) internal returns (bool) {
1584         require(!mintingFinished);
1585         totalSupply_ = totalSupply_.add(_amount);
1586         balances[_to] = balances[_to].add(_amount);
1587         emit Mint(_to, _amount);
1588         return true;
1589     }
1590 
1591     /**
1592      * @dev Function to stop minting new tokens.
1593      * @return True if the operation was successful.
1594      */
1595     function finishMinting() internal returns (bool) {
1596         require(!mintingFinished);
1597         mintingFinished = true;
1598         emit MintFinished();
1599         return true;
1600     }
1601 
1602 }
1603 
1604 /**
1605  * @title Burnable Token
1606  * @dev Token that can be irreversibly burned (destroyed).
1607  */
1608 contract BurnableToken is MintableToken {
1609 
1610     event Burn(address indexed burner, uint256 value);
1611 
1612     /**
1613      * @dev Burns a specific amount of tokens.
1614      * @param _value The amount of token to be burned.
1615      */
1616     function burn(uint256 _value) public {
1617         _burn(msg.sender, _value);
1618     }
1619 
1620     function _burn(address _who, uint256 _value) internal {
1621         require(_value <= balances[_who]);
1622         // no need to require value <= totalSupply, since that would imply the
1623         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
1624 
1625         balances[_who] = balances[_who].sub(_value);
1626         totalSupply_ = totalSupply_.sub(_value);
1627         emit Burn(_who, _value);
1628         emit Transfer(_who, address(0), _value);
1629     }
1630 }
1631 
1632 contract HeliumToken is BurnableToken {
1633 
1634     string public constant name = "HeliumToken";
1635     string public constant symbol = "HLT";
1636     uint8 public constant decimals = 18;
1637 
1638     uint256 public INITIAL_SUPPLY = 0;
1639 
1640 }
1641 
1642 contract Balloons3D is HeliumToken, usingOraclize {
1643 
1644     using SafeMath for uint256;
1645     using SafeMath16 for uint16;
1646 
1647     address[] public users;
1648     address[] public winners;
1649     uint16[] public balloons;
1650 
1651     uint16 public step;
1652     uint16 public initialNumberOfBalloons;
1653     uint16 public totalBalloons;
1654     uint16 public sold;
1655     uint16 public min;
1656     uint16 public max;
1657     uint16 public winnerDetectionTime;
1658 
1659     uint public feeForTeam;
1660     uint public feeForReferral;
1661     uint public refCount;
1662     uint public withdrawnFromReferrals;
1663     uint public price;
1664     uint public nextPrice;
1665     uint public pot;
1666     uint public attempts;
1667     uint public safeGasLimit;
1668     uint public safeGasPrice;
1669     uint public gasOraclize;
1670     uint public gasPriceOraclize;
1671     uint N;
1672     uint delay;
1673 
1674     address public beneficiary;
1675 
1676     bool public gameIsOver;
1677     bool public canPlay;
1678     bool public canRevealWinner;
1679     bool public oracleFailed;
1680 
1681     struct UserStruct {
1682         uint16 numberOfExploded;
1683         uint balance;
1684         uint index;
1685     }
1686 
1687     mapping(uint16 => address) private ownerOfBalloon;
1688     mapping(address => uint16) private numberOfBalloons;
1689     mapping(address => UserStruct) userStructs;
1690     mapping(address => uint) private totalWinnings;
1691     mapping(address => uint) private ethReferrals;
1692     mapping(uint => mapping(uint => bool)) private participatedIDs;
1693     mapping(uint => mapping(uint => mapping(uint => bool))) private returnedBalloons;
1694     mapping(uint => mapping(uint => bool)) expiredIds;
1695     mapping(uint => uint) private idTrack;
1696 
1697     event OnNewUser(address indexed _address, uint _index);
1698     event OnPurchaseBalloon(address indexed _buyer, address _referredBy, uint16 _id);
1699     event OnWithdrawRefEth(address _to, uint _value);
1700     event OnRevealWinner(address _winner, uint _amount, uint16 _min, uint16 _max, uint16 _data, uint16 _id);
1701     event OnGeneratingRandomNum(string _text);
1702     event OnRandomNumberGenerated(uint _data, uint _randomNumber);
1703     event OnReturned(address indexed _address, uint16 _id);
1704     event OnReturnFailed(address indexed _address, uint16 _id);
1705     event OnPriceChanged(uint _oldPrice, uint _newPrice);
1706     event OnGasLimitChanged(uint _oldGasLimit, uint _newGasLimit);
1707     event OnGasPriceChanged(uint _oldGasPrice, uint _newGasPrice);
1708 
1709     modifier onlyOraclize() {
1710         require(msg.sender == oraclize_cbAddress());
1711         _;
1712     }
1713 
1714     constructor() public {
1715         totalBalloons = 10000;
1716         price = 30000000000000000;
1717         nextPrice = price;
1718         beneficiary = 0xbDcBD634DA96782a1566061f5ceaE5c436681A07;
1719         initialNumberOfBalloons = totalBalloons;
1720         feeForReferral = price.mul(45).div(100);
1721         refCount = 0;
1722         step = 20;
1723         winnerDetectionTime = step;
1724         attempts = 0;
1725         canPlay = true;
1726         gameIsOver = false;
1727         canRevealWinner = false;
1728         oracleFailed = false;
1729         N = 4;
1730         delay = 0;
1731         safeGasLimit = 200000;
1732         safeGasPrice = 20000000000 wei;
1733         gasOraclize = safeGasLimit.add(100000);
1734         gasPriceOraclize = safeGasPrice;
1735         oraclize_setCustomGasPrice(gasPriceOraclize);
1736     }
1737 
1738     function() public payable {
1739         _buyBalloon(msg.sender, msg.value, msg.sender);
1740     }
1741 
1742     function buyBalloon(address _referredBy) public payable {
1743         _buyBalloon(msg.sender, msg.value, _referredBy);
1744     }
1745 
1746     function _buyBalloon(address _sender, uint _value, address _referredBy) internal {
1747         require(!gameIsOver);
1748         require(canPlay);
1749         require(_value == price);
1750         require(totalBalloons > 0);
1751         numberOfBalloons[_sender] = numberOfBalloons[_sender].add(1);
1752         userStructs[_sender].balance = userStructs[_sender].balance.add(_value);
1753         uint16 balloonId = sold;
1754         balloons.push(balloonId);
1755         ownerOfBalloon[balloonId] = _sender;
1756         sold = sold.add(1);
1757         totalBalloons = totalBalloons .sub(1);
1758         idTrack[balloonId] = price;
1759         if (!existUser(_sender)) {
1760             userStructs[_sender].index = users.push(_sender).sub(1);
1761             emit OnNewUser(_sender, userStructs[_sender].index);
1762         }
1763 
1764         if (_referredBy != address(0) && _referredBy != msg.sender) {
1765             if (feeForReferral != price.mul(45).div(100)) {
1766                 feeForReferral = price.mul(45).div(100);
1767             }
1768             mint(_referredBy, feeForReferral);
1769             refCount = refCount.add(1);
1770         }
1771 
1772         if (sold == winnerDetectionTime) {
1773             min = uint16(balloons.length.sub(step));
1774             max = uint16(balloons.length);
1775             canRevealWinner = true;
1776             winnerDetectionTime = winnerDetectionTime.add(step);
1777             attempts = attempts.add(1);
1778             pot = price.mul(step);
1779             feeForTeam = pot.mul(5).div(100);
1780             if (price != nextPrice) {
1781                 canPlay = false;
1782                 price = nextPrice;
1783                 emit OnPriceChanged(price, nextPrice);
1784             }
1785             pingOracle();
1786         }
1787 
1788         if (totalBalloons == 0) {
1789             finishMinting();
1790             gameIsOver = true;
1791         }
1792         emit OnPurchaseBalloon(_sender, _referredBy, balloonId);
1793     }
1794 
1795     function withdraw() public {
1796         require(balanceOf(msg.sender) > 0, "Sorry, you don't have enough HeliumToken");
1797         uint award = balanceOf(msg.sender);
1798         withdrawnFromReferrals = withdrawnFromReferrals.add(award);
1799         ethReferrals[msg.sender] = ethReferrals[msg.sender].add(award);
1800         msg.sender.transfer(award);
1801         burn(balanceOf(msg.sender));
1802         emit OnWithdrawRefEth(msg.sender, award);
1803     }
1804 
1805     function revealWinner(uint16 _balloonIndex, uint _attempts, uint16 _data, uint16 _min, uint16 _max) internal {
1806         require(_balloonIndex < max && _balloonIndex >= min);
1807         uint feeForRefs = feeForReferral.mul(refCount);
1808         uint amountForTeam = feeForTeam.sub(_attempts.mul(gasOraclize.mul(gasPriceOraclize)));
1809         uint amount = pot.sub(feeForRefs).sub(amountForTeam).sub(_attempts.mul(gasOraclize.mul(gasPriceOraclize)));
1810         uint index = winners.push(ownerOfBalloon[_balloonIndex]).sub(1);
1811 
1812         ownerOfBalloon[_balloonIndex].transfer(amount);
1813         beneficiary.transfer(amountForTeam);
1814         totalWinnings[winners[index]] = totalWinnings[winners[index]].add(amount);
1815         participatedIDs[_min][_max] = true;
1816         expiredIds[_min][_max] = true;
1817         refCount = 0;
1818         if (!canPlay) {
1819             canPlay = true;
1820         }
1821 
1822         emit OnRevealWinner(ownerOfBalloon[_balloonIndex], amount, _min, _max, _data, _balloonIndex);
1823     }
1824 
1825     function __callback(bytes32 _queryId, string _result, bytes _proof) public onlyOraclize {
1826         require(canRevealWinner);
1827         require(!expiredIds[min][max]);
1828         if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) != 0) {
1829             oracleFailed = true;
1830         } else {
1831             uint16 data = uint16(keccak256(abi.encodePacked(_result)));
1832             uint16 randomNumber = (data % (max.sub(min))).add(min);
1833             revealWinner(randomNumber, attempts, data, min, max);
1834             oracleFailed = false;
1835             canRevealWinner = false;
1836             attempts = 0;
1837 
1838             emit OnRandomNumberGenerated(data, randomNumber);
1839         }
1840 
1841         if (oracleFailed && canRevealWinner) {
1842             attempts = attempts.add(1);
1843             pingOracle();
1844         }
1845     }
1846 
1847     function pingOracle() private {
1848         oraclize_setProof(proofType_Ledger);
1849         // sets the Ledger authenticity proof in the constructor
1850         bytes32 queryId = oraclize_newRandomDSQuery(delay, N, gasOraclize);
1851         // this function internally generates the correct oraclize_query and returns its queryId
1852         emit OnGeneratingRandomNum("Oraclize was sent for generate random number");
1853     }
1854 
1855     function setPrice(uint _newPrice) public onlyOwner {
1856         require(price != _newPrice);
1857         nextPrice = _newPrice;
1858     }
1859 
1860     function setOraclizeGasLimit(uint _newGasLimit) public onlyOwner {
1861         require(gasOraclize >= safeGasLimit);
1862         uint oldGasLimit = gasOraclize;
1863         gasOraclize = _newGasLimit;
1864         emit OnGasLimitChanged(oldGasLimit, _newGasLimit);
1865     }
1866 
1867     function setOraclizeGasPrice(uint _newGasPrice) public onlyOwner {
1868         require(_newGasPrice >= safeGasPrice);
1869         uint oldGasPrice = gasPriceOraclize;
1870         gasPriceOraclize = _newGasPrice;
1871         oraclize_setCustomGasPrice(_newGasPrice);
1872         emit OnGasPriceChanged(oldGasPrice, _newGasPrice);
1873     }
1874 
1875     function changeStatusGame() public onlyOwner {
1876         require(!canPlay);
1877         canPlay = true;
1878     }
1879 
1880     function refundPendingId(uint16 _id) public {
1881         require(!participatedID(_id));
1882         require(_id < getMaxOfId(_id));
1883         require(getMaxOfId(_id).add(step) < sold);
1884         require(_id <= sold);
1885         require(ownerOfBalloon[_id] == msg.sender);
1886         require(!returnedBalloons[getMinOfId(_id)][getMaxOfId(_id)][_id]);
1887         if (ownerOfBalloon[_id].send(idTrack[_id])) {
1888             returnedBalloons[getMinOfId(_id)][getMaxOfId(_id)][_id] = true;
1889             if (!expiredIds[getMinOfId(_id)][getMaxOfId(_id)]) {
1890                 expiredIds[getMinOfId(_id)][getMaxOfId(_id)] = true;
1891             }
1892             emit OnReturned(ownerOfBalloon[_id], _id);
1893         } else {
1894             emit OnReturnFailed(ownerOfBalloon[_id], _id);
1895         }
1896     }
1897 
1898     function canRefund(uint16 _id) public view returns (bool) {
1899         return (!participatedID(_id) && getMaxOfId(_id).add(step) < sold && !returnedBalloons[getMinOfId(_id)][getMaxOfId(_id)][_id]);
1900     }
1901 
1902     function participatedID(uint16 _id) public view returns (bool) {
1903         uint _min;
1904         uint _max;
1905         if (_id < step) {
1906             _min = 0;
1907             _max = step;
1908         }
1909         else {
1910             uint16 lastDigit = _id % 10;
1911             _min = differenceOfId(_id.sub(lastDigit));
1912             _max = _min + step;
1913         }
1914 
1915         return participatedIDs[_min][_max];
1916     }
1917 
1918     function getMinOfId(uint16 _id) public view returns (uint16) {
1919         uint16 _min;
1920         if (_id < step) {
1921             _min = 0;
1922         } else {
1923             uint16 lastDigit = _id % 10;
1924             _min = differenceOfId(_id.sub(lastDigit));
1925         }
1926         return _min;
1927     }
1928 
1929     function getMaxOfId(uint16 _id) public view returns (uint16) {
1930         uint16 _max;
1931         if (_id < step) {
1932             _max = 20;
1933         } else {
1934             _max = getMinOfId(_id).add(step);
1935         }
1936         return _max;
1937     }
1938 
1939     function differenceOfId(uint16 _id) internal view returns (uint16) {
1940         uint16 minNumber;
1941         if (_id % step == 0) {
1942             minNumber = _id;
1943         } else {
1944             minNumber = _id.sub(10);
1945         }
1946         return minNumber;
1947     }
1948 
1949     function balloonOwner(uint16 _index) public view returns (address) {
1950         return ownerOfBalloon[_index];
1951     }
1952 
1953     function existUser(address _address) public view returns (bool) {
1954         if (users.length == 0) return false;
1955         return (users[userStructs[_address].index] == _address);
1956     }
1957 
1958     function countOfBalloons(address _address) public view returns (uint16) {
1959         return numberOfBalloons[_address];
1960     }
1961 
1962     function currentFund() public view returns (uint) {
1963         return address(this).balance;
1964     }
1965 
1966     function winnersFund() public view returns (uint) {
1967         return currentFund().sub(totalSupply_);
1968     }
1969 
1970     function refPayment() public view returns (uint) {
1971         return balanceOf(msg.sender).mul(feeForReferral);
1972     }
1973 
1974     function usersList() public view returns (address[]) {
1975         return users;
1976     }
1977 
1978     function balloonsList() public view returns (uint16[]) {
1979         return balloons;
1980     }
1981 
1982     function winnersList() public view returns (address[]) {
1983         return winners;
1984     }
1985 
1986     function ethRefs(address _address) public view returns (uint) {
1987         return ethReferrals[_address];
1988     }
1989 
1990     function getTotalWinnings(address _address) public view returns (uint) {
1991         return totalWinnings[_address];
1992     }
1993 
1994 }