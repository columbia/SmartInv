1 // solium-disable linebreak-style
2 pragma solidity ^0.4.24;
3 
4 contract OraclizeI {
5     address public cbAddress;
6     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
7     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
8     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
9     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
10     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
11     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
12     function getPrice(string _datasource) returns (uint _dsprice);
13     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
14     function useCoupon(string _coupon);
15     function setProofType(byte _proofType);
16     function setConfig(bytes32 _config);
17     function setCustomGasPrice(uint _gasPrice);
18     function randomDS_getSessionPubKeyHash() returns(bytes32);
19 }
20 
21 contract OraclizeAddrResolverI {
22     function getAddress() returns (address _addr);
23 }
24 
25 /*
26 Begin solidity-cborutils
27 https://github.com/smartcontractkit/solidity-cborutils
28 MIT License
29 Copyright (c) 2018 SmartContract ChainLink, Ltd.
30 Permission is hereby granted, free of charge, to any person obtaining a copy
31 of this software and associated documentation files (the "Software"), to deal
32 in the Software without restriction, including without limitation the rights
33 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
34 copies of the Software, and to permit persons to whom the Software is
35 furnished to do so, subject to the following conditions:
36 The above copyright notice and this permission notice shall be included in all
37 copies or substantial portions of the Software.
38 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
39 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
40 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
41 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
42 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
43 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
44 SOFTWARE.
45  */
46 
47 library Buffer {
48     struct buffer {
49         bytes buf;
50         uint capacity;
51     }
52 
53     function init(buffer memory buf, uint _capacity) internal constant {
54         uint capacity = _capacity;
55         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
56         // Allocate space for the buffer data
57         buf.capacity = capacity;
58         assembly {
59             let ptr := mload(0x40)
60             mstore(buf, ptr)
61             mstore(ptr, 0)
62             mstore(0x40, add(ptr, capacity))
63         }
64     }
65 
66     function resize(buffer memory buf, uint capacity) private constant {
67         bytes memory oldbuf = buf.buf;
68         init(buf, capacity);
69         append(buf, oldbuf);
70     }
71 
72     function max(uint a, uint b) private constant returns(uint) {
73         if(a > b) {
74             return a;
75         }
76         return b;
77     }
78 
79     /**
80      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
81      *      would exceed the capacity of the buffer.
82      * @param buf The buffer to append to.
83      * @param data The data to append.
84      * @return The original buffer.
85      */
86     function append(buffer memory buf, bytes data) internal constant returns(buffer memory) {
87         if(data.length + buf.buf.length > buf.capacity) {
88             resize(buf, max(buf.capacity, data.length) * 2);
89         }
90 
91         uint dest;
92         uint src;
93         uint len = data.length;
94         assembly {
95             // Memory address of the buffer data
96             let bufptr := mload(buf)
97             // Length of existing buffer data
98             let buflen := mload(bufptr)
99             // Start address = buffer address + buffer length + sizeof(buffer length)
100             dest := add(add(bufptr, buflen), 32)
101             // Update buffer length
102             mstore(bufptr, add(buflen, mload(data)))
103             src := add(data, 32)
104         }
105 
106         // Copy word-length chunks while possible
107         for(; len >= 32; len -= 32) {
108             assembly {
109                 mstore(dest, mload(src))
110             }
111             dest += 32;
112             src += 32;
113         }
114 
115         // Copy remaining bytes
116         uint mask = 256 ** (32 - len) - 1;
117         assembly {
118             let srcpart := and(mload(src), not(mask))
119             let destpart := and(mload(dest), mask)
120             mstore(dest, or(destpart, srcpart))
121         }
122 
123         return buf;
124     }
125 
126     /**
127      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
128      * exceed the capacity of the buffer.
129      * @param buf The buffer to append to.
130      * @param data The data to append.
131      * @return The original buffer.
132      */
133     function append(buffer memory buf, uint8 data) internal constant {
134         if(buf.buf.length + 1 > buf.capacity) {
135             resize(buf, buf.capacity * 2);
136         }
137 
138         assembly {
139             // Memory address of the buffer data
140             let bufptr := mload(buf)
141             // Length of existing buffer data
142             let buflen := mload(bufptr)
143             // Address = buffer address + buffer length + sizeof(buffer length)
144             let dest := add(add(bufptr, buflen), 32)
145             mstore8(dest, data)
146             // Update buffer length
147             mstore(bufptr, add(buflen, 1))
148         }
149     }
150 
151     /**
152      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
153      * exceed the capacity of the buffer.
154      * @param buf The buffer to append to.
155      * @param data The data to append.
156      * @return The original buffer.
157      */
158     function appendInt(buffer memory buf, uint data, uint len) internal constant returns(buffer memory) {
159         if(len + buf.buf.length > buf.capacity) {
160             resize(buf, max(buf.capacity, len) * 2);
161         }
162 
163         uint mask = 256 ** len - 1;
164         assembly {
165             // Memory address of the buffer data
166             let bufptr := mload(buf)
167             // Length of existing buffer data
168             let buflen := mload(bufptr)
169             // Address = buffer address + buffer length + sizeof(buffer length) + len
170             let dest := add(add(bufptr, buflen), len)
171             mstore(dest, or(and(mload(dest), not(mask)), data))
172             // Update buffer length
173             mstore(bufptr, add(buflen, len))
174         }
175         return buf;
176     }
177 }
178 
179 library CBOR {
180     using Buffer for Buffer.buffer;
181 
182     uint8 private constant MAJOR_TYPE_INT = 0;
183     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
184     uint8 private constant MAJOR_TYPE_BYTES = 2;
185     uint8 private constant MAJOR_TYPE_STRING = 3;
186     uint8 private constant MAJOR_TYPE_ARRAY = 4;
187     uint8 private constant MAJOR_TYPE_MAP = 5;
188     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
189 
190     function shl8(uint8 x, uint8 y) private constant returns (uint8) {
191         return x * (2 ** y);
192     }
193 
194     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private constant {
195         if(value <= 23) {
196             buf.append(uint8(shl8(major, 5) | value));
197         } else if(value <= 0xFF) {
198             buf.append(uint8(shl8(major, 5) | 24));
199             buf.appendInt(value, 1);
200         } else if(value <= 0xFFFF) {
201             buf.append(uint8(shl8(major, 5) | 25));
202             buf.appendInt(value, 2);
203         } else if(value <= 0xFFFFFFFF) {
204             buf.append(uint8(shl8(major, 5) | 26));
205             buf.appendInt(value, 4);
206         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
207             buf.append(uint8(shl8(major, 5) | 27));
208             buf.appendInt(value, 8);
209         }
210     }
211 
212     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private constant {
213         buf.append(uint8(shl8(major, 5) | 31));
214     }
215 
216     function encodeUInt(Buffer.buffer memory buf, uint value) internal constant {
217         encodeType(buf, MAJOR_TYPE_INT, value);
218     }
219 
220     function encodeInt(Buffer.buffer memory buf, int value) internal constant {
221         if(value >= 0) {
222             encodeType(buf, MAJOR_TYPE_INT, uint(value));
223         } else {
224             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
225         }
226     }
227 
228     function encodeBytes(Buffer.buffer memory buf, bytes value) internal constant {
229         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
230         buf.append(value);
231     }
232 
233     function encodeString(Buffer.buffer memory buf, string value) internal constant {
234         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
235         buf.append(bytes(value));
236     }
237 
238     function startArray(Buffer.buffer memory buf) internal constant {
239         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
240     }
241 
242     function startMap(Buffer.buffer memory buf) internal constant {
243         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
244     }
245 
246     function endSequence(Buffer.buffer memory buf) internal constant {
247         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
248     }
249 }
250 
251 /*
252 End solidity-cborutils
253  */
254 
255 contract usingOraclize {
256     uint constant day = 60*60*24;
257     uint constant week = 60*60*24*7;
258     uint constant month = 60*60*24*30;
259     byte constant proofType_NONE = 0x00;
260     byte constant proofType_TLSNotary = 0x10;
261     byte constant proofType_Ledger = 0x30;
262     byte constant proofType_Android = 0x40;
263     byte constant proofType_Native = 0xF0;
264     byte constant proofStorage_IPFS = 0x01;
265     uint8 constant networkID_auto = 0;
266     uint8 constant networkID_mainnet = 1;
267     uint8 constant networkID_testnet = 2;
268     uint8 constant networkID_morden = 2;
269     uint8 constant networkID_consensys = 161;
270 
271     OraclizeAddrResolverI OAR;
272 
273     OraclizeI oraclize;
274     modifier oraclizeAPI {
275         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
276             oraclize_setNetwork(networkID_auto);
277 
278         if(address(oraclize) != OAR.getAddress())
279             oraclize = OraclizeI(OAR.getAddress());
280 
281         _;
282     }
283     modifier coupon(string code){
284         oraclize = OraclizeI(OAR.getAddress());
285         oraclize.useCoupon(code);
286         _;
287     }
288 
289     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
290         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
291             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
292             oraclize_setNetworkName("eth_mainnet");
293             return true;
294         }
295         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
296             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
297             oraclize_setNetworkName("eth_ropsten3");
298             return true;
299         }
300         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
301             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
302             oraclize_setNetworkName("eth_kovan");
303             return true;
304         }
305         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
306             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
307             oraclize_setNetworkName("eth_rinkeby");
308             return true;
309         }
310         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
311             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
312             return true;
313         }
314         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
315             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
316             return true;
317         }
318         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
319             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
320             return true;
321         }
322         return false;
323     }
324 
325     function __callback(bytes32 myid, string result) {
326         __callback(myid, result, new bytes(0));
327     }
328     function __callback(bytes32 myid, string result, bytes proof) {
329     }
330 
331     function oraclize_useCoupon(string code) oraclizeAPI internal {
332         oraclize.useCoupon(code);
333     }
334 
335     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
336         return oraclize.getPrice(datasource);
337     }
338 
339     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
340         return oraclize.getPrice(datasource, gaslimit);
341     }
342 
343     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
344         uint price = oraclize.getPrice(datasource);
345         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
346         return oraclize.query.value(price)(0, datasource, arg);
347     }
348     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
349         uint price = oraclize.getPrice(datasource);
350         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
351         return oraclize.query.value(price)(timestamp, datasource, arg);
352     }
353     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
354         uint price = oraclize.getPrice(datasource, gaslimit);
355         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
356         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
357     }
358     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
359         uint price = oraclize.getPrice(datasource, gaslimit);
360         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
361         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
362     }
363     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
364         uint price = oraclize.getPrice(datasource);
365         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
366         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
367     }
368     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
369         uint price = oraclize.getPrice(datasource);
370         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
371         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
372     }
373     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
374         uint price = oraclize.getPrice(datasource, gaslimit);
375         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
376         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
377     }
378     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
379         uint price = oraclize.getPrice(datasource, gaslimit);
380         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
381         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
382     }
383     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
384         uint price = oraclize.getPrice(datasource);
385         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
386         bytes memory args = stra2cbor(argN);
387         return oraclize.queryN.value(price)(0, datasource, args);
388     }
389     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
390         uint price = oraclize.getPrice(datasource);
391         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
392         bytes memory args = stra2cbor(argN);
393         return oraclize.queryN.value(price)(timestamp, datasource, args);
394     }
395     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
396         uint price = oraclize.getPrice(datasource, gaslimit);
397         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
398         bytes memory args = stra2cbor(argN);
399         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
400     }
401     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
402         uint price = oraclize.getPrice(datasource, gaslimit);
403         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
404         bytes memory args = stra2cbor(argN);
405         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
406     }
407     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
408         string[] memory dynargs = new string[](1);
409         dynargs[0] = args[0];
410         return oraclize_query(datasource, dynargs);
411     }
412     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
413         string[] memory dynargs = new string[](1);
414         dynargs[0] = args[0];
415         return oraclize_query(timestamp, datasource, dynargs);
416     }
417     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
418         string[] memory dynargs = new string[](1);
419         dynargs[0] = args[0];
420         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
421     }
422     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
423         string[] memory dynargs = new string[](1);
424         dynargs[0] = args[0];
425         return oraclize_query(datasource, dynargs, gaslimit);
426     }
427 
428     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
429         string[] memory dynargs = new string[](2);
430         dynargs[0] = args[0];
431         dynargs[1] = args[1];
432         return oraclize_query(datasource, dynargs);
433     }
434     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
435         string[] memory dynargs = new string[](2);
436         dynargs[0] = args[0];
437         dynargs[1] = args[1];
438         return oraclize_query(timestamp, datasource, dynargs);
439     }
440     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
441         string[] memory dynargs = new string[](2);
442         dynargs[0] = args[0];
443         dynargs[1] = args[1];
444         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
445     }
446     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
447         string[] memory dynargs = new string[](2);
448         dynargs[0] = args[0];
449         dynargs[1] = args[1];
450         return oraclize_query(datasource, dynargs, gaslimit);
451     }
452     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
453         string[] memory dynargs = new string[](3);
454         dynargs[0] = args[0];
455         dynargs[1] = args[1];
456         dynargs[2] = args[2];
457         return oraclize_query(datasource, dynargs);
458     }
459     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
460         string[] memory dynargs = new string[](3);
461         dynargs[0] = args[0];
462         dynargs[1] = args[1];
463         dynargs[2] = args[2];
464         return oraclize_query(timestamp, datasource, dynargs);
465     }
466     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
467         string[] memory dynargs = new string[](3);
468         dynargs[0] = args[0];
469         dynargs[1] = args[1];
470         dynargs[2] = args[2];
471         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
472     }
473     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
474         string[] memory dynargs = new string[](3);
475         dynargs[0] = args[0];
476         dynargs[1] = args[1];
477         dynargs[2] = args[2];
478         return oraclize_query(datasource, dynargs, gaslimit);
479     }
480 
481     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
482         string[] memory dynargs = new string[](4);
483         dynargs[0] = args[0];
484         dynargs[1] = args[1];
485         dynargs[2] = args[2];
486         dynargs[3] = args[3];
487         return oraclize_query(datasource, dynargs);
488     }
489     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
490         string[] memory dynargs = new string[](4);
491         dynargs[0] = args[0];
492         dynargs[1] = args[1];
493         dynargs[2] = args[2];
494         dynargs[3] = args[3];
495         return oraclize_query(timestamp, datasource, dynargs);
496     }
497     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
498         string[] memory dynargs = new string[](4);
499         dynargs[0] = args[0];
500         dynargs[1] = args[1];
501         dynargs[2] = args[2];
502         dynargs[3] = args[3];
503         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
504     }
505     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
506         string[] memory dynargs = new string[](4);
507         dynargs[0] = args[0];
508         dynargs[1] = args[1];
509         dynargs[2] = args[2];
510         dynargs[3] = args[3];
511         return oraclize_query(datasource, dynargs, gaslimit);
512     }
513     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
514         string[] memory dynargs = new string[](5);
515         dynargs[0] = args[0];
516         dynargs[1] = args[1];
517         dynargs[2] = args[2];
518         dynargs[3] = args[3];
519         dynargs[4] = args[4];
520         return oraclize_query(datasource, dynargs);
521     }
522     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
523         string[] memory dynargs = new string[](5);
524         dynargs[0] = args[0];
525         dynargs[1] = args[1];
526         dynargs[2] = args[2];
527         dynargs[3] = args[3];
528         dynargs[4] = args[4];
529         return oraclize_query(timestamp, datasource, dynargs);
530     }
531     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
532         string[] memory dynargs = new string[](5);
533         dynargs[0] = args[0];
534         dynargs[1] = args[1];
535         dynargs[2] = args[2];
536         dynargs[3] = args[3];
537         dynargs[4] = args[4];
538         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
539     }
540     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
541         string[] memory dynargs = new string[](5);
542         dynargs[0] = args[0];
543         dynargs[1] = args[1];
544         dynargs[2] = args[2];
545         dynargs[3] = args[3];
546         dynargs[4] = args[4];
547         return oraclize_query(datasource, dynargs, gaslimit);
548     }
549     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
550         uint price = oraclize.getPrice(datasource);
551         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
552         bytes memory args = ba2cbor(argN);
553         return oraclize.queryN.value(price)(0, datasource, args);
554     }
555     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
556         uint price = oraclize.getPrice(datasource);
557         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
558         bytes memory args = ba2cbor(argN);
559         return oraclize.queryN.value(price)(timestamp, datasource, args);
560     }
561     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
562         uint price = oraclize.getPrice(datasource, gaslimit);
563         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
564         bytes memory args = ba2cbor(argN);
565         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
566     }
567     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
568         uint price = oraclize.getPrice(datasource, gaslimit);
569         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
570         bytes memory args = ba2cbor(argN);
571         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
572     }
573     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
574         bytes[] memory dynargs = new bytes[](1);
575         dynargs[0] = args[0];
576         return oraclize_query(datasource, dynargs);
577     }
578     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
579         bytes[] memory dynargs = new bytes[](1);
580         dynargs[0] = args[0];
581         return oraclize_query(timestamp, datasource, dynargs);
582     }
583     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
584         bytes[] memory dynargs = new bytes[](1);
585         dynargs[0] = args[0];
586         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
587     }
588     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
589         bytes[] memory dynargs = new bytes[](1);
590         dynargs[0] = args[0];
591         return oraclize_query(datasource, dynargs, gaslimit);
592     }
593 
594     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
595         bytes[] memory dynargs = new bytes[](2);
596         dynargs[0] = args[0];
597         dynargs[1] = args[1];
598         return oraclize_query(datasource, dynargs);
599     }
600     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
601         bytes[] memory dynargs = new bytes[](2);
602         dynargs[0] = args[0];
603         dynargs[1] = args[1];
604         return oraclize_query(timestamp, datasource, dynargs);
605     }
606     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
607         bytes[] memory dynargs = new bytes[](2);
608         dynargs[0] = args[0];
609         dynargs[1] = args[1];
610         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
611     }
612     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
613         bytes[] memory dynargs = new bytes[](2);
614         dynargs[0] = args[0];
615         dynargs[1] = args[1];
616         return oraclize_query(datasource, dynargs, gaslimit);
617     }
618     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
619         bytes[] memory dynargs = new bytes[](3);
620         dynargs[0] = args[0];
621         dynargs[1] = args[1];
622         dynargs[2] = args[2];
623         return oraclize_query(datasource, dynargs);
624     }
625     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
626         bytes[] memory dynargs = new bytes[](3);
627         dynargs[0] = args[0];
628         dynargs[1] = args[1];
629         dynargs[2] = args[2];
630         return oraclize_query(timestamp, datasource, dynargs);
631     }
632     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
633         bytes[] memory dynargs = new bytes[](3);
634         dynargs[0] = args[0];
635         dynargs[1] = args[1];
636         dynargs[2] = args[2];
637         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
638     }
639     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
640         bytes[] memory dynargs = new bytes[](3);
641         dynargs[0] = args[0];
642         dynargs[1] = args[1];
643         dynargs[2] = args[2];
644         return oraclize_query(datasource, dynargs, gaslimit);
645     }
646 
647     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
648         bytes[] memory dynargs = new bytes[](4);
649         dynargs[0] = args[0];
650         dynargs[1] = args[1];
651         dynargs[2] = args[2];
652         dynargs[3] = args[3];
653         return oraclize_query(datasource, dynargs);
654     }
655     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
656         bytes[] memory dynargs = new bytes[](4);
657         dynargs[0] = args[0];
658         dynargs[1] = args[1];
659         dynargs[2] = args[2];
660         dynargs[3] = args[3];
661         return oraclize_query(timestamp, datasource, dynargs);
662     }
663     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
664         bytes[] memory dynargs = new bytes[](4);
665         dynargs[0] = args[0];
666         dynargs[1] = args[1];
667         dynargs[2] = args[2];
668         dynargs[3] = args[3];
669         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
670     }
671     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
672         bytes[] memory dynargs = new bytes[](4);
673         dynargs[0] = args[0];
674         dynargs[1] = args[1];
675         dynargs[2] = args[2];
676         dynargs[3] = args[3];
677         return oraclize_query(datasource, dynargs, gaslimit);
678     }
679     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
680         bytes[] memory dynargs = new bytes[](5);
681         dynargs[0] = args[0];
682         dynargs[1] = args[1];
683         dynargs[2] = args[2];
684         dynargs[3] = args[3];
685         dynargs[4] = args[4];
686         return oraclize_query(datasource, dynargs);
687     }
688     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
689         bytes[] memory dynargs = new bytes[](5);
690         dynargs[0] = args[0];
691         dynargs[1] = args[1];
692         dynargs[2] = args[2];
693         dynargs[3] = args[3];
694         dynargs[4] = args[4];
695         return oraclize_query(timestamp, datasource, dynargs);
696     }
697     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
698         bytes[] memory dynargs = new bytes[](5);
699         dynargs[0] = args[0];
700         dynargs[1] = args[1];
701         dynargs[2] = args[2];
702         dynargs[3] = args[3];
703         dynargs[4] = args[4];
704         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
705     }
706     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
707         bytes[] memory dynargs = new bytes[](5);
708         dynargs[0] = args[0];
709         dynargs[1] = args[1];
710         dynargs[2] = args[2];
711         dynargs[3] = args[3];
712         dynargs[4] = args[4];
713         return oraclize_query(datasource, dynargs, gaslimit);
714     }
715 
716     function oraclize_cbAddress() oraclizeAPI internal returns (address){
717         return oraclize.cbAddress();
718     }
719     function oraclize_setProof(byte proofP) oraclizeAPI internal {
720         return oraclize.setProofType(proofP);
721     }
722     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
723         return oraclize.setCustomGasPrice(gasPrice);
724     }
725     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
726         return oraclize.setConfig(config);
727     }
728 
729     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
730         return oraclize.randomDS_getSessionPubKeyHash();
731     }
732 
733     function getCodeSize(address _addr) constant internal returns(uint _size) {
734         assembly {
735             _size := extcodesize(_addr)
736         }
737     }
738 
739     function parseAddr(string _a) internal returns (address){
740         bytes memory tmp = bytes(_a);
741         uint160 iaddr = 0;
742         uint160 b1;
743         uint160 b2;
744         for (uint i=2; i<2+2*20; i+=2){
745             iaddr *= 256;
746             b1 = uint160(tmp[i]);
747             b2 = uint160(tmp[i+1]);
748             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
749             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
750             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
751             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
752             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
753             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
754             iaddr += (b1*16+b2);
755         }
756         return address(iaddr);
757     }
758 
759     function strCompare(string _a, string _b) internal returns (int) {
760         bytes memory a = bytes(_a);
761         bytes memory b = bytes(_b);
762         uint minLength = a.length;
763         if (b.length < minLength) minLength = b.length;
764         for (uint i = 0; i < minLength; i ++)
765             if (a[i] < b[i])
766                 return -1;
767             else if (a[i] > b[i])
768                 return 1;
769         if (a.length < b.length)
770             return -1;
771         else if (a.length > b.length)
772             return 1;
773         else
774             return 0;
775     }
776 
777     function indexOf(string _haystack, string _needle) internal returns (int) {
778         bytes memory h = bytes(_haystack);
779         bytes memory n = bytes(_needle);
780         if(h.length < 1 || n.length < 1 || (n.length > h.length))
781             return -1;
782         else if(h.length > (2**128 -1))
783             return -1;
784         else
785         {
786             uint subindex = 0;
787             for (uint i = 0; i < h.length; i ++)
788             {
789                 if (h[i] == n[0])
790                 {
791                     subindex = 1;
792                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
793                     {
794                         subindex++;
795                     }
796                     if(subindex == n.length)
797                         return int(i);
798                 }
799             }
800             return -1;
801         }
802     }
803 
804     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
805         bytes memory _ba = bytes(_a);
806         bytes memory _bb = bytes(_b);
807         bytes memory _bc = bytes(_c);
808         bytes memory _bd = bytes(_d);
809         bytes memory _be = bytes(_e);
810         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
811         bytes memory babcde = bytes(abcde);
812         uint k = 0;
813         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
814         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
815         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
816         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
817         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
818         return string(babcde);
819     }
820 
821     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
822         return strConcat(_a, _b, _c, _d, "");
823     }
824 
825     function strConcat(string _a, string _b, string _c) internal returns (string) {
826         return strConcat(_a, _b, _c, "", "");
827     }
828 
829     function strConcat(string _a, string _b) internal returns (string) {
830         return strConcat(_a, _b, "", "", "");
831     }
832 
833     // parseInt
834     function parseInt(string _a) internal returns (uint) {
835         return parseInt(_a, 0);
836     }
837 
838     // parseInt(parseFloat*10^_b)
839     function parseInt(string _a, uint _b) internal returns (uint) {
840         bytes memory bresult = bytes(_a);
841         uint mint = 0;
842         bool decimals = false;
843         for (uint i=0; i<bresult.length; i++){
844             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
845                 if (decimals){
846                    if (_b == 0) break;
847                     else _b--;
848                 }
849                 mint *= 10;
850                 mint += uint(bresult[i]) - 48;
851             } else if (bresult[i] == 46) decimals = true;
852         }
853         if (_b > 0) mint *= 10**_b;
854         return mint;
855     }
856 
857     function uint2str(uint i) internal returns (string){
858         if (i == 0) return "0";
859         uint j = i;
860         uint len;
861         while (j != 0){
862             len++;
863             j /= 10;
864         }
865         bytes memory bstr = new bytes(len);
866         uint k = len - 1;
867         while (i != 0){
868             bstr[k--] = byte(48 + i % 10);
869             i /= 10;
870         }
871         return string(bstr);
872     }
873 
874     using CBOR for Buffer.buffer;
875     function stra2cbor(string[] arr) internal constant returns (bytes) {
876         safeMemoryCleaner();
877         Buffer.buffer memory buf;
878         Buffer.init(buf, 1024);
879         buf.startArray();
880         for (uint i = 0; i < arr.length; i++) {
881             buf.encodeString(arr[i]);
882         }
883         buf.endSequence();
884         return buf.buf;
885     }
886 
887     function ba2cbor(bytes[] arr) internal constant returns (bytes) {
888         safeMemoryCleaner();
889         Buffer.buffer memory buf;
890         Buffer.init(buf, 1024);
891         buf.startArray();
892         for (uint i = 0; i < arr.length; i++) {
893             buf.encodeBytes(arr[i]);
894         }
895         buf.endSequence();
896         return buf.buf;
897     }
898 
899     string oraclize_network_name;
900     function oraclize_setNetworkName(string _network_name) internal {
901         oraclize_network_name = _network_name;
902     }
903 
904     function oraclize_getNetworkName() internal returns (string) {
905         return oraclize_network_name;
906     }
907 
908     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
909         if ((_nbytes == 0)||(_nbytes > 32)) throw;
910 	// Convert from seconds to ledger timer ticks
911         _delay *= 10;
912         bytes memory nbytes = new bytes(1);
913         nbytes[0] = byte(_nbytes);
914         bytes memory unonce = new bytes(32);
915         bytes memory sessionKeyHash = new bytes(32);
916         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
917         assembly {
918             mstore(unonce, 0x20)
919             // the following variables can be relaxed
920             // check relaxed random contract under ethereum-examples repo
921             // for an idea on how to override and replace comit hash vars
922             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
923             mstore(sessionKeyHash, 0x20)
924             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
925         }
926         bytes memory delay = new bytes(32);
927         assembly {
928             mstore(add(delay, 0x20), _delay)
929         }
930 
931         bytes memory delay_bytes8 = new bytes(8);
932         copyBytes(delay, 24, 8, delay_bytes8, 0);
933 
934         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
935         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
936 
937         bytes memory delay_bytes8_left = new bytes(8);
938 
939         assembly {
940             let x := mload(add(delay_bytes8, 0x20))
941             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
942             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
943             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
944             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
945             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
946             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
947             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
948             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
949 
950         }
951 
952         oraclize_randomDS_setCommitment(queryId, sha3(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
953         return queryId;
954     }
955 
956     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
957         oraclize_randomDS_args[queryId] = commitment;
958     }
959 
960     mapping(bytes32=>bytes32) oraclize_randomDS_args;
961     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
962 
963     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
964         bool sigok;
965         address signer;
966 
967         bytes32 sigr;
968         bytes32 sigs;
969 
970         bytes memory sigr_ = new bytes(32);
971         uint offset = 4+(uint(dersig[3]) - 0x20);
972         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
973         bytes memory sigs_ = new bytes(32);
974         offset += 32 + 2;
975         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
976 
977         assembly {
978             sigr := mload(add(sigr_, 32))
979             sigs := mload(add(sigs_, 32))
980         }
981 
982 
983         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
984         if (address(sha3(pubkey)) == signer) return true;
985         else {
986             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
987             return (address(sha3(pubkey)) == signer);
988         }
989     }
990 
991     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
992         bool sigok;
993 
994         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
995         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
996         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
997 
998         bytes memory appkey1_pubkey = new bytes(64);
999         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1000 
1001         bytes memory tosign2 = new bytes(1+65+32);
1002         tosign2[0] = 1; //role
1003         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1004         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1005         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1006         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1007 
1008         if (sigok == false) return false;
1009 
1010 
1011         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1012         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1013 
1014         bytes memory tosign3 = new bytes(1+65);
1015         tosign3[0] = 0xFE;
1016         copyBytes(proof, 3, 65, tosign3, 1);
1017 
1018         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1019         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1020 
1021         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1022 
1023         return sigok;
1024     }
1025 
1026     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1027         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1028         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
1029 
1030         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1031         if (proofVerified == false) throw;
1032 
1033         _;
1034     }
1035 
1036     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1037         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1038         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1039 
1040         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1041         if (proofVerified == false) return 2;
1042 
1043         return 0;
1044     }
1045 
1046     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
1047         bool match_ = true;
1048 
1049 	if (prefix.length != n_random_bytes) throw;
1050 
1051         for (uint256 i=0; i< n_random_bytes; i++) {
1052             if (content[i] != prefix[i]) match_ = false;
1053         }
1054 
1055         return match_;
1056     }
1057 
1058     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1059 
1060         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1061         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1062         bytes memory keyhash = new bytes(32);
1063         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1064         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
1065 
1066         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1067         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1068 
1069         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1070         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1071 
1072         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1073         // This is to verify that the computed args match with the ones specified in the query.
1074         bytes memory commitmentSlice1 = new bytes(8+1+32);
1075         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1076 
1077         bytes memory sessionPubkey = new bytes(64);
1078         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1079         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1080 
1081         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1082         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1083             delete oraclize_randomDS_args[queryId];
1084         } else return false;
1085 
1086 
1087         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1088         bytes memory tosign1 = new bytes(32+8+1+32);
1089         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1090         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1091 
1092         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1093         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1094             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1095         }
1096 
1097         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1098     }
1099 
1100 
1101     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1102     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1103         uint minLength = length + toOffset;
1104 
1105         if (to.length < minLength) {
1106             // Buffer too small
1107             throw; // Should be a better way?
1108         }
1109 
1110         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1111         uint i = 32 + fromOffset;
1112         uint j = 32 + toOffset;
1113 
1114         while (i < (32 + fromOffset + length)) {
1115             assembly {
1116                 let tmp := mload(add(from, i))
1117                 mstore(add(to, j), tmp)
1118             }
1119             i += 32;
1120             j += 32;
1121         }
1122 
1123         return to;
1124     }
1125 
1126     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1127     // Duplicate Solidity's ecrecover, but catching the CALL return value
1128     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1129         // We do our own memory management here. Solidity uses memory offset
1130         // 0x40 to store the current end of memory. We write past it (as
1131         // writes are memory extensions), but don't update the offset so
1132         // Solidity will reuse it. The memory used here is only needed for
1133         // this context.
1134 
1135         // FIXME: inline assembly can't access return values
1136         bool ret;
1137         address addr;
1138 
1139         assembly {
1140             let size := mload(0x40)
1141             mstore(size, hash)
1142             mstore(add(size, 32), v)
1143             mstore(add(size, 64), r)
1144             mstore(add(size, 96), s)
1145 
1146             // NOTE: we can reuse the request memory because we deal with
1147             //       the return code
1148             ret := call(3000, 1, 0, size, 128, size, 32)
1149             addr := mload(size)
1150         }
1151 
1152         return (ret, addr);
1153     }
1154 
1155     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1156     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1157         bytes32 r;
1158         bytes32 s;
1159         uint8 v;
1160 
1161         if (sig.length != 65)
1162           return (false, 0);
1163 
1164         // The signature format is a compact form of:
1165         //   {bytes32 r}{bytes32 s}{uint8 v}
1166         // Compact means, uint8 is not padded to 32 bytes.
1167         assembly {
1168             r := mload(add(sig, 32))
1169             s := mload(add(sig, 64))
1170 
1171             // Here we are loading the last 32 bytes. We exploit the fact that
1172             // 'mload' will pad with zeroes if we overread.
1173             // There is no 'mload8' to do this, but that would be nicer.
1174             v := byte(0, mload(add(sig, 96)))
1175 
1176             // Alternative solution:
1177             // 'byte' is not working due to the Solidity parser, so lets
1178             // use the second best option, 'and'
1179             // v := and(mload(add(sig, 65)), 255)
1180         }
1181 
1182         // albeit non-transactional signatures are not specified by the YP, one would expect it
1183         // to match the YP range of [27, 28]
1184         //
1185         // geth uses [0, 1] and some clients have followed. This might change, see:
1186         //  https://github.com/ethereum/go-ethereum/issues/2053
1187         if (v < 27)
1188           v += 27;
1189 
1190         if (v != 27 && v != 28)
1191             return (false, 0);
1192 
1193         return safer_ecrecover(hash, v, r, s);
1194     }
1195 
1196     function safeMemoryCleaner() internal constant {
1197         assembly {
1198             let fmem := mload(0x40)
1199             codecopy(fmem, codesize, sub(msize, fmem))
1200         }
1201     }
1202 }
1203 
1204 contract AceDice is usingOraclize {
1205   /// *** Constants section
1206   
1207   // Each bet is deducted 1% in favour of the house, but no less than some minimum.
1208   // The lower bound is dictated by gas costs of the settleBet transaction, providing
1209   // headroom for up to 10 Gwei prices.
1210   uint constant HOUSE_EDGE_PERCENT = 2;
1211   uint constant HOUSE_EDGE_MINIMUM_AMOUNT = 0.0004 ether;
1212   
1213   // Bets lower than this amount do not participate in jackpot rolls (and are
1214   // not deducted JACKPOT_FEE).
1215   uint constant MIN_JACKPOT_BET = 0.1 ether;
1216   
1217   // Chance to win jackpot (currently 0.1%) and fee deducted into jackpot fund.
1218   uint constant JACKPOT_MODULO = 1000;
1219   uint constant JACKPOT_FEE = 0.001 ether;
1220   
1221   // There is minimum and maximum bets.
1222   uint constant MIN_BET = 0.01 ether;
1223   uint constant MAX_AMOUNT = 300000 ether;
1224   
1225   // Modulo is a number of equiprobable outcomes in a game:
1226   // - 2 for coin flip
1227   // - 6 for dice
1228   // - 6*6 = 36 for double dice
1229   // - 100 for etheroll
1230   // - 37 for roulette
1231   // etc.
1232   // It's called so because 256-bit entropy is treated like a huge integer and
1233   // the remainder of its division by modulo is considered bet outcome.
1234   // uint constant MAX_MODULO = 100;
1235   
1236   // For modulos below this threshold rolls are checked against a bit mask,
1237   // thus allowing betting on any combination of outcomes. For example, given
1238   // modulo 6 for dice, 101000 mask (base-2, big endian) means betting on
1239   // 4 and 6; for games with modulos higher than threshold (Etheroll), a simple
1240   // limit is used, allowing betting on any outcome in [0, N) range.
1241   //
1242   // The specific value is dictated by the fact that 256-bit intermediate
1243   // multiplication result allows implementing population count efficiently
1244   // for numbers that are up to 42 bits, and 40 is the highest multiple of
1245   // eight below 42.
1246   uint constant MAX_MASK_MODULO = 40;
1247   
1248   // This is a check on bet mask overflow.
1249   uint constant MAX_BET_MASK = 2 ** MAX_MASK_MODULO;
1250   
1251   // EVM BLOCKHASH opcode can query no further than 256 blocks into the
1252   // past. Given that settleBet uses block hash of placeBet as one of
1253   // complementary entropy sources, we cannot process bets older than this
1254   // threshold. On rare occasions AceDice croupier may fail to invoke
1255   // settleBet in this timespan due to technical issues or extreme Ethereum
1256   // congestion; such bets can be refunded via invoking refundBet.
1257   uint constant BET_EXPIRATION_BLOCKS = 250;
1258   
1259   // Some deliberately invalid address to initialize the secret signer with.
1260   // Forces maintainers to invoke setSecretSigner before processing any bets.
1261   address constant DUMMY_ADDRESS = 0xEeeeeEeeeEeEeeEeEeEeeEEEeeeeEeeeeeeeEEeE;
1262   
1263   // Standard contract ownership transfer.
1264   address public owner;
1265   address private nextOwner;
1266   
1267   // Adjustable max bet profit. Used to cap bets against dynamic odds.
1268   uint public maxProfit;
1269   
1270   // The address corresponding to a private key used to sign placeBet commits.
1271   address public secretSigner;
1272   
1273   // Accumulated jackpot fund.
1274   uint128 public jackpotSize;
1275   
1276   uint64 public oraclizeGasLimit;
1277   uint public oraclizeGasPrice;
1278 
1279   uint public todaysRewardSize;
1280 
1281   // Funds that are locked in potentially winning bets. Prevents contract from
1282   // committing to bets it cannot pay out.
1283   uint128 public lockedInBets;
1284   
1285   // A structure representing a single bet.
1286   struct Bet {
1287     // Wager amount in wei.
1288     uint amount;
1289     // Modulo of a game.
1290     // uint8 modulo;
1291     // Number of winning outcomes, used to compute winning payment (* modulo/rollUnder),
1292     // and used instead of mask for games with modulo > MAX_MASK_MODULO.
1293     uint8 rollUnder;
1294     // Block number of placeBet tx.
1295     uint40 placeBlockNumber;
1296     // Bit mask representing winning bet outcomes (see MAX_MASK_MODULO comment).
1297     uint40 mask;
1298     // Address of a gambler, used to pay out winning bets.
1299     address gambler;
1300     // Address of inviter
1301     address inviter;
1302   }
1303 
1304   struct Profile{
1305     // picture index of profile avatar
1306     uint avatarIndex;
1307     // nickname of user
1308     string nickName;
1309   }
1310   
1311   // Mapping from commits to all currently active & processed bets.
1312   mapping (bytes32 => Bet) bets;
1313   // Mapping for accumuldated bet amount and users
1314   mapping (address => uint) accuBetAmount;
1315 
1316   mapping (address => Profile) profiles;
1317   
1318   // Croupier account.
1319   address public croupier;
1320   
1321   // Events that are issued to make statistic recovery easier.
1322   event FailedPayment(address indexed beneficiary, uint amount);
1323   event Payment(address indexed beneficiary, uint amount, uint dice, uint rollUnder, uint betAmount);
1324   event JackpotPayment(address indexed beneficiary, uint amount, uint dice, uint rollUnder, uint betAmount);
1325   event VIPPayback(address indexed beneficiary, uint amount);
1326   
1327   // This event is emitted in placeBet to record commit in the logs.
1328   event Commit(bytes32 commit);
1329 
1330   // 오늘의 랭킹 보상 지급 이벤트
1331   event TodaysRankingPayment(address indexed beneficiary, uint amount);
1332   
1333   // Constructor. Deliberately does not take any parameters.
1334   constructor () public {
1335     owner = msg.sender;
1336     secretSigner = DUMMY_ADDRESS;
1337     croupier = DUMMY_ADDRESS;
1338 
1339     oraclize_setNetwork(networkID_auto);
1340     oraclizeGasLimit = 40000;
1341     oraclizeGasPrice = 13000000000 wei;
1342     /* use TLSNotary for oraclize call */
1343     // oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1344     /* init gas price for callback (default 20 gwei)*/
1345     oraclize_setCustomGasPrice(oraclizeGasPrice);
1346   }
1347   
1348   // Standard modifier on methods invokable only by contract owner.
1349   modifier onlyOwner {
1350     require (msg.sender == owner, "OnlyOwner methods called by non-owner.");
1351     _;
1352   }
1353   
1354   // Standard modifier on methods invokable only by contract owner.
1355   modifier onlyCroupier {
1356     require (msg.sender == croupier, "OnlyCroupier methods called by non-croupier.");
1357     _;
1358   }
1359 
1360     /*
1361      * checks only Oraclize address is calling
1362     */
1363     modifier onlyOraclize {
1364         if (msg.sender != oraclize_cbAddress()) throw;
1365         _;
1366     }
1367   
1368   // Standard contract ownership transfer implementation,
1369   function approveNextOwner(address _nextOwner) external onlyOwner {
1370     require (_nextOwner != owner, "Cannot approve current owner.");
1371     nextOwner = _nextOwner;
1372   }
1373   
1374   function acceptNextOwner() external {
1375     require (msg.sender == nextOwner, "Can only accept preapproved new owner.");
1376     owner = nextOwner;
1377   }
1378   
1379   // Fallback function deliberately left empty. It's primary use case
1380   // is to top up the bank roll.
1381   function () public payable {
1382   }
1383   
1384   // See comment for "secretSigner" variable.
1385   function setSecretSigner(address newSecretSigner) external onlyOwner {
1386     secretSigner = newSecretSigner;
1387   }
1388   
1389   function getSecretSigner() external onlyOwner view returns(address){
1390     return secretSigner;
1391   }
1392   
1393   // Change the croupier address.
1394   function setCroupier(address newCroupier) external onlyOwner {
1395     croupier = newCroupier;
1396   }
1397   
1398   // Change max bet reward. Setting this to zero effectively disables betting.
1399   function setMaxProfit(uint _maxProfit) public onlyOwner {
1400     require (_maxProfit < MAX_AMOUNT, "maxProfit should be a sane number.");
1401     maxProfit = _maxProfit;
1402   }
1403 
1404   function setOraclizeGasLimit(uint64 _limit) public onlyOwner {
1405     oraclizeGasLimit = _limit;
1406   }
1407 
1408   function setOraclizeGasPrice(uint _price) public onlyOwner {
1409     oraclizeGasPrice = _price;
1410     oraclize_setCustomGasPrice(_price);
1411   }
1412   
1413   // This function is used to bump up the jackpot fund. Cannot be used to lower it.
1414   function increaseJackpot(uint increaseAmount) external onlyOwner {
1415     require (increaseAmount <= address(this).balance, "Increase amount larger than balance.");
1416     require (jackpotSize + lockedInBets + increaseAmount <= address(this).balance, "Not enough funds.");
1417     jackpotSize += uint128(increaseAmount);
1418   }
1419   
1420   // Funds withdrawal to cover costs of AceDice operation.
1421   function withdrawFunds(address beneficiary, uint withdrawAmount) external onlyOwner {
1422     require (withdrawAmount <= address(this).balance, "Increase amount larger than balance.");
1423     require (jackpotSize + lockedInBets + withdrawAmount <= address(this).balance, "Not enough funds.");
1424     sendFunds(beneficiary, withdrawAmount, withdrawAmount, 0, 0, 0);
1425   }
1426   
1427   // Contract may be destroyed only when there are no ongoing bets,
1428   // either settled or refunded. All funds are transferred to contract owner.
1429   function kill() external onlyOwner {
1430     require (lockedInBets == 0, "All bets should be processed (settled or refunded) before self-destruct.");
1431     selfdestruct(owner);
1432   }
1433 
1434   /// *** Betting logic
1435   function placeBet(uint betMask) external payable {
1436     
1437     // Validate input data ranges.
1438     uint amount = msg.value;
1439     //require (modulo > 1 && modulo <= MAX_MODULO, "Modulo should be within range.");
1440     require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
1441     // require (betMask > 0 && betMask < MAX_BET_MASK, "Mask should be within range.");
1442     
1443     //verifyCommit(commitLastBlock, commit, v, r, s);
1444     
1445     // uint rollUnder;
1446     uint mask;
1447     
1448     require (betMask > 2 && betMask <= 96, "High modulo range, betMask larger than modulo.");
1449     uint possibleWinAmount;
1450     uint jackpotFee;
1451     
1452     (possibleWinAmount, jackpotFee) = getDiceWinAmount(amount, betMask);
1453     
1454     // Enforce max profit limit.
1455     require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation. ");
1456     
1457     // Lock funds.
1458     lockedInBets += uint128(possibleWinAmount);
1459     jackpotSize += uint128(jackpotFee);
1460     
1461     // Check whether contract has enough funds to process this bet.
1462     require (jackpotSize + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
1463 
1464     bytes32 rngId = oraclize_query("WolframAlpha","random number between 1 and 1000", oraclizeGasLimit);
1465     
1466     // Record commit in logs.
1467     emit Commit(rngId);
1468 
1469     // Store bet parameters on blockchain.
1470     Bet storage bet = bets[rngId];
1471     bet.amount = amount;
1472     // bet.modulo = uint8(modulo);
1473     bet.rollUnder = uint8(betMask);
1474     bet.placeBlockNumber = uint40(block.number);
1475     bet.mask = uint40(mask);
1476     bet.gambler = msg.sender;
1477     
1478     uint accuAmount = accuBetAmount[msg.sender];
1479     accuAmount = accuAmount + amount;
1480     accuBetAmount[msg.sender] = accuAmount;
1481   }
1482 
1483   function placeBetWithInviter(uint betMask, address inviter) external payable {
1484      
1485     uint amount = msg.value;
1486     require (amount >= MIN_BET && amount <= MAX_AMOUNT, "Amount should be within range.");
1487     require (address(this) != inviter && inviter != address(0), "cannot invite myself");
1488     
1489     uint mask;
1490     
1491     require (betMask > 2 && betMask <= 96, "High modulo range, betMask larger than modulo.");
1492     uint possibleWinAmount;
1493     uint jackpotFee;
1494     
1495     (possibleWinAmount, jackpotFee) = getDiceWinAmount(amount, betMask);
1496     
1497     // Enforce max profit limit.
1498     require (possibleWinAmount <= amount + maxProfit, "maxProfit limit violation. ");
1499     
1500     // Lock funds.
1501     lockedInBets += uint128(possibleWinAmount);
1502     jackpotSize += uint128(jackpotFee);
1503     
1504     // Check whether contract has enough funds to process this bet.
1505     require (jackpotSize + lockedInBets <= address(this).balance, "Cannot afford to lose this bet.");
1506 
1507     bytes32 rngId = oraclize_query("WolframAlpha","random number between 1 and 1000", oraclizeGasLimit);
1508     
1509     // Record commit in logs.
1510     emit Commit(rngId);
1511 
1512     // Store bet parameters on blockchain.
1513     Bet storage bet = bets[rngId];
1514     bet.amount = amount;
1515     // bet.modulo = uint8(modulo);
1516     bet.rollUnder = uint8(betMask);
1517     bet.placeBlockNumber = uint40(block.number);
1518     bet.mask = uint40(mask);
1519     bet.gambler = msg.sender;
1520     bet.inviter = inviter;
1521     
1522     uint accuAmount = accuBetAmount[msg.sender];
1523     accuAmount = accuAmount + amount;
1524     accuBetAmount[msg.sender] = accuAmount;
1525     
1526   }
1527 
1528   function __callback(bytes32 _rngId, string _result, bytes proof) onlyOraclize {
1529     Bet storage bet = bets[_rngId];
1530     require (bet.gambler != address(0), "cannot find bet info...");
1531 
1532     uint randomNumber = parseInt(_result);
1533     settleBetCommon(bet, randomNumber);
1534   }
1535 
1536     // Common settlement code for settleBet & settleBetUncleMerkleProof.
1537   function settleBetCommon(Bet storage bet, uint randomNumber) private {
1538     // Fetch bet parameters into local variables (to save gas).
1539     uint amount = bet.amount;
1540     // uint modulo = bet.modulo;
1541     uint rollUnder = bet.rollUnder;
1542     address gambler = bet.gambler;
1543     
1544     // Check that bet is in 'active' state.
1545     require (amount != 0, "Bet should be in an 'active' state");
1546 
1547     applyVIPLevel(gambler, amount);
1548     
1549     // Move bet into 'processed' state already.
1550     bet.amount = 0;
1551     
1552     uint diceWinAmount;
1553     uint _jackpotFee;
1554     (diceWinAmount, _jackpotFee) = getDiceWinAmount(amount, rollUnder);
1555     
1556     uint diceWin = 0;
1557     uint jackpotWin = 0;
1558 
1559     uint dice = randomNumber / 10;
1560     
1561 
1562     // For larger modulos, check inclusion into half-open interval.
1563     if (dice < rollUnder) {
1564       diceWin = diceWinAmount;
1565     }
1566       
1567     // Unlock the bet amount, regardless of the outcome.
1568     lockedInBets -= uint128(diceWinAmount);
1569     
1570     // Roll for a jackpot (if eligible).
1571     if (amount >= MIN_JACKPOT_BET) {
1572       // The second modulo, statistically independent from the "main" dice roll.
1573       // Effectively you are playing two games at once!
1574       // uint jackpotRng = (uint(entropy) / modulo) % JACKPOT_MODULO;
1575       
1576       // Bingo!
1577       if (randomNumber == 0) {
1578         jackpotWin = jackpotSize;
1579         jackpotSize = 0;
1580       }
1581     }
1582     
1583     // Log jackpot win.
1584     if (jackpotWin > 0) {
1585       emit JackpotPayment(gambler, jackpotWin, dice, rollUnder, amount);
1586     }
1587     
1588     if(bet.inviter != address(0)){
1589       // 친구 초대하면 친구한대 15% 때어줌
1590       // uint inviterFee = amount * HOUSE_EDGE_PERCENT / 100 * 15 /100;
1591       bet.inviter.transfer(amount * HOUSE_EDGE_PERCENT / 100 * 15 /100);
1592     }
1593     todaysRewardSize += amount * HOUSE_EDGE_PERCENT / 100 * 9 /100;
1594     // Send the funds to gambler.
1595     sendFunds(gambler, diceWin + jackpotWin == 0 ? 1 wei : diceWin + jackpotWin, diceWin, dice, rollUnder, amount);
1596   }
1597 
1598   function applyVIPLevel(address gambler, uint amount) private {
1599     uint accuAmount = accuBetAmount[gambler];
1600     uint rate;
1601     if(accuAmount >= 30 ether && accuAmount < 150 ether){
1602       rate = 1;
1603     } else if(accuAmount >= 150 ether && accuAmount < 300 ether){
1604       rate = 2;
1605     } else if(accuAmount >= 300 ether && accuAmount < 1500 ether){
1606       rate = 4;
1607     } else if(accuAmount >= 1500 ether && accuAmount < 3000 ether){
1608       rate = 6;
1609     } else if(accuAmount >= 3000 ether && accuAmount < 15000 ether){
1610       rate = 8;
1611     } else if(accuAmount >= 15000 ether && accuAmount < 30000 ether){
1612       rate = 10;
1613     } else if(accuAmount >= 30000 ether && accuAmount < 150000 ether){
1614       rate = 12;
1615     } else if(accuAmount >= 150000 ether){
1616       rate = 15;
1617     } else{
1618       return;
1619     }
1620 
1621     uint vipPayback = amount * rate / 10000;
1622     if(gambler.send(vipPayback)){
1623       emit VIPPayback(gambler, vipPayback);
1624     }
1625   }
1626 
1627   function refundBet(bytes32 rngId) external {
1628     // Check that bet is in 'active' state.
1629     Bet storage bet = bets[rngId];
1630     uint amount = bet.amount;
1631     
1632     require (amount != 0, "Bet should be in an 'active' state");
1633     
1634     // Check that bet has already expired.
1635     require (block.number > bet.placeBlockNumber + BET_EXPIRATION_BLOCKS, "Blockhash can't be queried by EVM.");
1636     
1637     // Move bet into 'processed' state, release funds.
1638     bet.amount = 0;
1639     
1640     uint diceWinAmount;
1641     uint jackpotFee;
1642     (diceWinAmount, jackpotFee) = getDiceWinAmount(amount, bet.rollUnder);
1643     
1644     lockedInBets -= uint128(diceWinAmount);
1645     jackpotSize -= uint128(jackpotFee);
1646     
1647     // Send the refund.
1648     sendFunds(bet.gambler, amount, amount, 0, 0, 0);
1649   }
1650 
1651   function getMyAccuAmount() external view returns (uint){
1652     return accuBetAmount[msg.sender];
1653   }
1654   
1655       
1656   // Get the expected win amount after house edge is subtracted.
1657   function getDiceWinAmount(uint amount, uint rollUnder) private pure returns (uint winAmount, uint jackpotFee) {
1658     require (0 < rollUnder && rollUnder <= 100, "Win probability out of range.");
1659     
1660     jackpotFee = amount >= MIN_JACKPOT_BET ? JACKPOT_FEE : 0;
1661     
1662     uint houseEdge = amount * HOUSE_EDGE_PERCENT / 100;
1663     
1664     if (houseEdge < HOUSE_EDGE_MINIMUM_AMOUNT) {
1665       houseEdge = HOUSE_EDGE_MINIMUM_AMOUNT;
1666     }
1667     
1668     require (houseEdge + jackpotFee <= amount, "Bet doesn't even cover house edge.");
1669     winAmount = (amount - houseEdge - jackpotFee) * 100 / rollUnder;
1670   }
1671       
1672   // Helper routine to process the payment.
1673   function sendFunds(address beneficiary, uint amount, uint successLogAmount, uint dice, uint rollUnder, uint betAmount) private {
1674     if (beneficiary.send(amount)) {
1675       emit Payment(beneficiary, successLogAmount, dice, rollUnder, betAmount);
1676     } else {
1677       emit FailedPayment(beneficiary, amount);
1678     }
1679   }
1680         
1681 
1682   function thisBalance() public view returns(uint) {
1683       return address(this).balance;
1684   }
1685 
1686   function setAvatarIndex(uint index) external{
1687     require (index >=0 && index <= 100, "avatar index should be in range");
1688     Profile storage profile = profiles[msg.sender];
1689     profile.avatarIndex = index;
1690   }
1691 
1692   function setNickName(string nickName) external{
1693     Profile storage profile = profiles[msg.sender];
1694     profile.nickName = nickName;
1695   }
1696 
1697   function getProfile() external view returns(uint, string){
1698     Profile storage profile = profiles[msg.sender];
1699     return (profile.avatarIndex, profile.nickName);
1700   }
1701 
1702   function payTodayReward(address to, uint rate) external onlyOwner {
1703     uint prize = todaysRewardSize * rate / 10000;
1704     todaysRewardSize = todaysRewardSize - prize;
1705     if(to.send(prize)){
1706       emit TodaysRankingPayment(to, prize);
1707     }
1708   }
1709 }