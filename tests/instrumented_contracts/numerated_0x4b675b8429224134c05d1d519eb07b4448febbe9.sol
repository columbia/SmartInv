1 pragma solidity ^0.4.26;
2 
3 // <ORACLIZE_API>
4 /*
5 Copyright (c) 2015-2016 Oraclize SRL
6 Copyright (c) 2016 Oraclize LTD
7 Permission is hereby granted, free of charge, to any person obtaining a copy
8 of this software and associated documentation files (the "Software"), to deal
9 in the Software without restriction, including without limitation the rights
10 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
11 copies of the Software, and to permit persons to whom the Software is
12 furnished to do so, subject to the following conditions:
13 The above copyright notice and this permission notice shall be included in
14 all copies or substantial portions of the Software.
15 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
16 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
17 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
18 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
19 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
20 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
21 THE SOFTWARE.
22 */
23 
24 pragma solidity >= 0.4.1 < 0.5;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
25 
26 contract OraclizeI {
27     address public cbAddress;
28     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
29     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
30     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
31     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
32     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
33     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
34     function getPrice(string _datasource) returns (uint _dsprice);
35     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
36     function useCoupon(string _coupon);
37     function setProofType(byte _proofType);
38     function setConfig(bytes32 _config);
39     function setCustomGasPrice(uint _gasPrice);
40     function randomDS_getSessionPubKeyHash() returns(bytes32);
41 }
42 
43 contract OraclizeAddrResolverI {
44     function getAddress() returns (address _addr);
45 }
46 
47 /*
48 Begin solidity-cborutils
49 https://github.com/smartcontractkit/solidity-cborutils
50 MIT License
51 Copyright (c) 2018 SmartContract ChainLink, Ltd.
52 Permission is hereby granted, free of charge, to any person obtaining a copy
53 of this software and associated documentation files (the "Software"), to deal
54 in the Software without restriction, including without limitation the rights
55 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
56 copies of the Software, and to permit persons to whom the Software is
57 furnished to do so, subject to the following conditions:
58 The above copyright notice and this permission notice shall be included in all
59 copies or substantial portions of the Software.
60 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
61 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
62 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
63 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
64 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
65 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
66 SOFTWARE.
67  */
68 
69 library Buffer {
70     struct buffer {
71         bytes buf;
72         uint capacity;
73     }
74 
75     function init(buffer memory buf, uint _capacity) internal constant {
76         uint capacity = _capacity;
77         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
78         // Allocate space for the buffer data
79         buf.capacity = capacity;
80         assembly {
81             let ptr := mload(0x40)
82             mstore(buf, ptr)
83             mstore(ptr, 0)
84             mstore(0x40, add(ptr, capacity))
85         }
86     }
87 
88     function resize(buffer memory buf, uint capacity) private constant {
89         bytes memory oldbuf = buf.buf;
90         init(buf, capacity);
91         append(buf, oldbuf);
92     }
93 
94     function max(uint a, uint b) private constant returns(uint) {
95         if(a > b) {
96             return a;
97         }
98         return b;
99     }
100 
101     /**
102      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
103      *      would exceed the capacity of the buffer.
104      * @param buf The buffer to append to.
105      * @param data The data to append.
106      * @return The original buffer.
107      */
108     function append(buffer memory buf, bytes data) internal constant returns(buffer memory) {
109         if(data.length + buf.buf.length > buf.capacity) {
110             resize(buf, max(buf.capacity, data.length) * 2);
111         }
112 
113         uint dest;
114         uint src;
115         uint len = data.length;
116         assembly {
117             // Memory address of the buffer data
118             let bufptr := mload(buf)
119             // Length of existing buffer data
120             let buflen := mload(bufptr)
121             // Start address = buffer address + buffer length + sizeof(buffer length)
122             dest := add(add(bufptr, buflen), 32)
123             // Update buffer length
124             mstore(bufptr, add(buflen, mload(data)))
125             src := add(data, 32)
126         }
127 
128         // Copy word-length chunks while possible
129         for(; len >= 32; len -= 32) {
130             assembly {
131                 mstore(dest, mload(src))
132             }
133             dest += 32;
134             src += 32;
135         }
136 
137         // Copy remaining bytes
138         uint mask = 256 ** (32 - len) - 1;
139         assembly {
140             let srcpart := and(mload(src), not(mask))
141             let destpart := and(mload(dest), mask)
142             mstore(dest, or(destpart, srcpart))
143         }
144 
145         return buf;
146     }
147 
148     /**
149      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
150      * exceed the capacity of the buffer.
151      * @param buf The buffer to append to.
152      * @param data The data to append.
153      * @return The original buffer.
154      */
155     function append(buffer memory buf, uint8 data) internal constant {
156         if(buf.buf.length + 1 > buf.capacity) {
157             resize(buf, buf.capacity * 2);
158         }
159 
160         assembly {
161             // Memory address of the buffer data
162             let bufptr := mload(buf)
163             // Length of existing buffer data
164             let buflen := mload(bufptr)
165             // Address = buffer address + buffer length + sizeof(buffer length)
166             let dest := add(add(bufptr, buflen), 32)
167             mstore8(dest, data)
168             // Update buffer length
169             mstore(bufptr, add(buflen, 1))
170         }
171     }
172 
173     /**
174      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
175      * exceed the capacity of the buffer.
176      * @param buf The buffer to append to.
177      * @param data The data to append.
178      * @return The original buffer.
179      */
180     function appendInt(buffer memory buf, uint data, uint len) internal constant returns(buffer memory) {
181         if(len + buf.buf.length > buf.capacity) {
182             resize(buf, max(buf.capacity, len) * 2);
183         }
184 
185         uint mask = 256 ** len - 1;
186         assembly {
187             // Memory address of the buffer data
188             let bufptr := mload(buf)
189             // Length of existing buffer data
190             let buflen := mload(bufptr)
191             // Address = buffer address + buffer length + sizeof(buffer length) + len
192             let dest := add(add(bufptr, buflen), len)
193             mstore(dest, or(and(mload(dest), not(mask)), data))
194             // Update buffer length
195             mstore(bufptr, add(buflen, len))
196         }
197         return buf;
198     }
199 }
200 
201 library CBOR {
202     using Buffer for Buffer.buffer;
203 
204     uint8 private constant MAJOR_TYPE_INT = 0;
205     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
206     uint8 private constant MAJOR_TYPE_BYTES = 2;
207     uint8 private constant MAJOR_TYPE_STRING = 3;
208     uint8 private constant MAJOR_TYPE_ARRAY = 4;
209     uint8 private constant MAJOR_TYPE_MAP = 5;
210     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
211 
212     function shl8(uint8 x, uint8 y) private constant returns (uint8) {
213         return x * (2 ** y);
214     }
215 
216     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private constant {
217         if(value <= 23) {
218             buf.append(uint8(shl8(major, 5) | value));
219         } else if(value <= 0xFF) {
220             buf.append(uint8(shl8(major, 5) | 24));
221             buf.appendInt(value, 1);
222         } else if(value <= 0xFFFF) {
223             buf.append(uint8(shl8(major, 5) | 25));
224             buf.appendInt(value, 2);
225         } else if(value <= 0xFFFFFFFF) {
226             buf.append(uint8(shl8(major, 5) | 26));
227             buf.appendInt(value, 4);
228         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
229             buf.append(uint8(shl8(major, 5) | 27));
230             buf.appendInt(value, 8);
231         }
232     }
233 
234     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private constant {
235         buf.append(uint8(shl8(major, 5) | 31));
236     }
237 
238     function encodeUInt(Buffer.buffer memory buf, uint value) internal constant {
239         encodeType(buf, MAJOR_TYPE_INT, value);
240     }
241 
242     function encodeInt(Buffer.buffer memory buf, int value) internal constant {
243         if(value >= 0) {
244             encodeType(buf, MAJOR_TYPE_INT, uint(value));
245         } else {
246             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
247         }
248     }
249 
250     function encodeBytes(Buffer.buffer memory buf, bytes value) internal constant {
251         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
252         buf.append(value);
253     }
254 
255     function encodeString(Buffer.buffer memory buf, string value) internal constant {
256         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
257         buf.append(bytes(value));
258     }
259 
260     function startArray(Buffer.buffer memory buf) internal constant {
261         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
262     }
263 
264     function startMap(Buffer.buffer memory buf) internal constant {
265         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
266     }
267 
268     function endSequence(Buffer.buffer memory buf) internal constant {
269         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
270     }
271 }
272 
273 /*
274 End solidity-cborutils
275  */
276 
277 contract usingOraclize {
278     uint constant day = 60*60*24;
279     uint constant week = 60*60*24*7;
280     uint constant month = 60*60*24*30;
281     byte constant proofType_NONE = 0x00;
282     byte constant proofType_TLSNotary = 0x10;
283     byte constant proofType_Ledger = 0x30;
284     byte constant proofType_Android = 0x40;
285     byte constant proofType_Native = 0xF0;
286     byte constant proofStorage_IPFS = 0x01;
287     uint8 constant networkID_auto = 0;
288     uint8 constant networkID_mainnet = 1;
289     uint8 constant networkID_testnet = 2;
290     uint8 constant networkID_morden = 2;
291     uint8 constant networkID_consensys = 161;
292 
293     OraclizeAddrResolverI OAR;
294 
295     OraclizeI oraclize;
296     modifier oraclizeAPI {
297         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
298             oraclize_setNetwork(networkID_auto);
299 
300         if(address(oraclize) != OAR.getAddress())
301             oraclize = OraclizeI(OAR.getAddress());
302 
303         _;
304     }
305     modifier coupon(string code){
306         oraclize = OraclizeI(OAR.getAddress());
307         oraclize.useCoupon(code);
308         _;
309     }
310 
311     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
312         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
313             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
314             oraclize_setNetworkName("eth_mainnet");
315             return true;
316         }
317         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
318             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
319             oraclize_setNetworkName("eth_ropsten3");
320             return true;
321         }
322         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
323             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
324             oraclize_setNetworkName("eth_kovan");
325             return true;
326         }
327         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
328             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
329             oraclize_setNetworkName("eth_rinkeby");
330             return true;
331         }
332         if (getCodeSize(0xa2998EFD205FB9D4B4963aFb70778D6354ad3A41)>0){ //goerli testnet
333             OAR = OraclizeAddrResolverI(0xa2998EFD205FB9D4B4963aFb70778D6354ad3A41);
334             oraclize_setNetworkName("eth_goerli");
335             return true;
336         }
337         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
338             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
339             return true;
340         }
341         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
342             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
343             return true;
344         }
345         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
346             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
347             return true;
348         }
349         return false;
350     }
351 
352     function __callback(bytes32 myid, string result) {
353         __callback(myid, result, new bytes(0));
354     }
355     function __callback(bytes32 myid, string result, bytes proof) {
356     }
357 
358     function oraclize_useCoupon(string code) oraclizeAPI internal {
359         oraclize.useCoupon(code);
360     }
361 
362     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
363         return oraclize.getPrice(datasource);
364     }
365 
366     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
367         return oraclize.getPrice(datasource, gaslimit);
368     }
369 
370     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
371         uint price = oraclize.getPrice(datasource);
372         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
373         return oraclize.query.value(price)(0, datasource, arg);
374     }
375     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
376         uint price = oraclize.getPrice(datasource);
377         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
378         return oraclize.query.value(price)(timestamp, datasource, arg);
379     }
380     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
381         uint price = oraclize.getPrice(datasource, gaslimit);
382         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
383         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
384     }
385     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
386         uint price = oraclize.getPrice(datasource, gaslimit);
387         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
388         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
389     }
390     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
391         uint price = oraclize.getPrice(datasource);
392         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
393         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
394     }
395     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
396         uint price = oraclize.getPrice(datasource);
397         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
398         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
399     }
400     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
401         uint price = oraclize.getPrice(datasource, gaslimit);
402         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
403         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
404     }
405     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
406         uint price = oraclize.getPrice(datasource, gaslimit);
407         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
408         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
409     }
410     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
411         uint price = oraclize.getPrice(datasource);
412         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
413         bytes memory args = stra2cbor(argN);
414         return oraclize.queryN.value(price)(0, datasource, args);
415     }
416     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
417         uint price = oraclize.getPrice(datasource);
418         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
419         bytes memory args = stra2cbor(argN);
420         return oraclize.queryN.value(price)(timestamp, datasource, args);
421     }
422     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
423         uint price = oraclize.getPrice(datasource, gaslimit);
424         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
425         bytes memory args = stra2cbor(argN);
426         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
427     }
428     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
429         uint price = oraclize.getPrice(datasource, gaslimit);
430         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
431         bytes memory args = stra2cbor(argN);
432         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
433     }
434     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
435         string[] memory dynargs = new string[](1);
436         dynargs[0] = args[0];
437         return oraclize_query(datasource, dynargs);
438     }
439     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
440         string[] memory dynargs = new string[](1);
441         dynargs[0] = args[0];
442         return oraclize_query(timestamp, datasource, dynargs);
443     }
444     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
445         string[] memory dynargs = new string[](1);
446         dynargs[0] = args[0];
447         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
448     }
449     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
450         string[] memory dynargs = new string[](1);
451         dynargs[0] = args[0];
452         return oraclize_query(datasource, dynargs, gaslimit);
453     }
454 
455     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
456         string[] memory dynargs = new string[](2);
457         dynargs[0] = args[0];
458         dynargs[1] = args[1];
459         return oraclize_query(datasource, dynargs);
460     }
461     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
462         string[] memory dynargs = new string[](2);
463         dynargs[0] = args[0];
464         dynargs[1] = args[1];
465         return oraclize_query(timestamp, datasource, dynargs);
466     }
467     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
468         string[] memory dynargs = new string[](2);
469         dynargs[0] = args[0];
470         dynargs[1] = args[1];
471         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
472     }
473     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
474         string[] memory dynargs = new string[](2);
475         dynargs[0] = args[0];
476         dynargs[1] = args[1];
477         return oraclize_query(datasource, dynargs, gaslimit);
478     }
479     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
480         string[] memory dynargs = new string[](3);
481         dynargs[0] = args[0];
482         dynargs[1] = args[1];
483         dynargs[2] = args[2];
484         return oraclize_query(datasource, dynargs);
485     }
486     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
487         string[] memory dynargs = new string[](3);
488         dynargs[0] = args[0];
489         dynargs[1] = args[1];
490         dynargs[2] = args[2];
491         return oraclize_query(timestamp, datasource, dynargs);
492     }
493     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
494         string[] memory dynargs = new string[](3);
495         dynargs[0] = args[0];
496         dynargs[1] = args[1];
497         dynargs[2] = args[2];
498         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
499     }
500     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
501         string[] memory dynargs = new string[](3);
502         dynargs[0] = args[0];
503         dynargs[1] = args[1];
504         dynargs[2] = args[2];
505         return oraclize_query(datasource, dynargs, gaslimit);
506     }
507 
508     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
509         string[] memory dynargs = new string[](4);
510         dynargs[0] = args[0];
511         dynargs[1] = args[1];
512         dynargs[2] = args[2];
513         dynargs[3] = args[3];
514         return oraclize_query(datasource, dynargs);
515     }
516     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
517         string[] memory dynargs = new string[](4);
518         dynargs[0] = args[0];
519         dynargs[1] = args[1];
520         dynargs[2] = args[2];
521         dynargs[3] = args[3];
522         return oraclize_query(timestamp, datasource, dynargs);
523     }
524     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
525         string[] memory dynargs = new string[](4);
526         dynargs[0] = args[0];
527         dynargs[1] = args[1];
528         dynargs[2] = args[2];
529         dynargs[3] = args[3];
530         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
531     }
532     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
533         string[] memory dynargs = new string[](4);
534         dynargs[0] = args[0];
535         dynargs[1] = args[1];
536         dynargs[2] = args[2];
537         dynargs[3] = args[3];
538         return oraclize_query(datasource, dynargs, gaslimit);
539     }
540     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
541         string[] memory dynargs = new string[](5);
542         dynargs[0] = args[0];
543         dynargs[1] = args[1];
544         dynargs[2] = args[2];
545         dynargs[3] = args[3];
546         dynargs[4] = args[4];
547         return oraclize_query(datasource, dynargs);
548     }
549     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
550         string[] memory dynargs = new string[](5);
551         dynargs[0] = args[0];
552         dynargs[1] = args[1];
553         dynargs[2] = args[2];
554         dynargs[3] = args[3];
555         dynargs[4] = args[4];
556         return oraclize_query(timestamp, datasource, dynargs);
557     }
558     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
559         string[] memory dynargs = new string[](5);
560         dynargs[0] = args[0];
561         dynargs[1] = args[1];
562         dynargs[2] = args[2];
563         dynargs[3] = args[3];
564         dynargs[4] = args[4];
565         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
566     }
567     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
568         string[] memory dynargs = new string[](5);
569         dynargs[0] = args[0];
570         dynargs[1] = args[1];
571         dynargs[2] = args[2];
572         dynargs[3] = args[3];
573         dynargs[4] = args[4];
574         return oraclize_query(datasource, dynargs, gaslimit);
575     }
576     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
577         uint price = oraclize.getPrice(datasource);
578         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
579         bytes memory args = ba2cbor(argN);
580         return oraclize.queryN.value(price)(0, datasource, args);
581     }
582     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
583         uint price = oraclize.getPrice(datasource);
584         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
585         bytes memory args = ba2cbor(argN);
586         return oraclize.queryN.value(price)(timestamp, datasource, args);
587     }
588     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
589         uint price = oraclize.getPrice(datasource, gaslimit);
590         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
591         bytes memory args = ba2cbor(argN);
592         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
593     }
594     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
595         uint price = oraclize.getPrice(datasource, gaslimit);
596         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
597         bytes memory args = ba2cbor(argN);
598         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
599     }
600     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
601         bytes[] memory dynargs = new bytes[](1);
602         dynargs[0] = args[0];
603         return oraclize_query(datasource, dynargs);
604     }
605     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
606         bytes[] memory dynargs = new bytes[](1);
607         dynargs[0] = args[0];
608         return oraclize_query(timestamp, datasource, dynargs);
609     }
610     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
611         bytes[] memory dynargs = new bytes[](1);
612         dynargs[0] = args[0];
613         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
614     }
615     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
616         bytes[] memory dynargs = new bytes[](1);
617         dynargs[0] = args[0];
618         return oraclize_query(datasource, dynargs, gaslimit);
619     }
620 
621     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
622         bytes[] memory dynargs = new bytes[](2);
623         dynargs[0] = args[0];
624         dynargs[1] = args[1];
625         return oraclize_query(datasource, dynargs);
626     }
627     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
628         bytes[] memory dynargs = new bytes[](2);
629         dynargs[0] = args[0];
630         dynargs[1] = args[1];
631         return oraclize_query(timestamp, datasource, dynargs);
632     }
633     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
634         bytes[] memory dynargs = new bytes[](2);
635         dynargs[0] = args[0];
636         dynargs[1] = args[1];
637         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
638     }
639     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
640         bytes[] memory dynargs = new bytes[](2);
641         dynargs[0] = args[0];
642         dynargs[1] = args[1];
643         return oraclize_query(datasource, dynargs, gaslimit);
644     }
645     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
646         bytes[] memory dynargs = new bytes[](3);
647         dynargs[0] = args[0];
648         dynargs[1] = args[1];
649         dynargs[2] = args[2];
650         return oraclize_query(datasource, dynargs);
651     }
652     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
653         bytes[] memory dynargs = new bytes[](3);
654         dynargs[0] = args[0];
655         dynargs[1] = args[1];
656         dynargs[2] = args[2];
657         return oraclize_query(timestamp, datasource, dynargs);
658     }
659     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
660         bytes[] memory dynargs = new bytes[](3);
661         dynargs[0] = args[0];
662         dynargs[1] = args[1];
663         dynargs[2] = args[2];
664         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
665     }
666     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
667         bytes[] memory dynargs = new bytes[](3);
668         dynargs[0] = args[0];
669         dynargs[1] = args[1];
670         dynargs[2] = args[2];
671         return oraclize_query(datasource, dynargs, gaslimit);
672     }
673 
674     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
675         bytes[] memory dynargs = new bytes[](4);
676         dynargs[0] = args[0];
677         dynargs[1] = args[1];
678         dynargs[2] = args[2];
679         dynargs[3] = args[3];
680         return oraclize_query(datasource, dynargs);
681     }
682     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
683         bytes[] memory dynargs = new bytes[](4);
684         dynargs[0] = args[0];
685         dynargs[1] = args[1];
686         dynargs[2] = args[2];
687         dynargs[3] = args[3];
688         return oraclize_query(timestamp, datasource, dynargs);
689     }
690     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
691         bytes[] memory dynargs = new bytes[](4);
692         dynargs[0] = args[0];
693         dynargs[1] = args[1];
694         dynargs[2] = args[2];
695         dynargs[3] = args[3];
696         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
697     }
698     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
699         bytes[] memory dynargs = new bytes[](4);
700         dynargs[0] = args[0];
701         dynargs[1] = args[1];
702         dynargs[2] = args[2];
703         dynargs[3] = args[3];
704         return oraclize_query(datasource, dynargs, gaslimit);
705     }
706     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
707         bytes[] memory dynargs = new bytes[](5);
708         dynargs[0] = args[0];
709         dynargs[1] = args[1];
710         dynargs[2] = args[2];
711         dynargs[3] = args[3];
712         dynargs[4] = args[4];
713         return oraclize_query(datasource, dynargs);
714     }
715     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
716         bytes[] memory dynargs = new bytes[](5);
717         dynargs[0] = args[0];
718         dynargs[1] = args[1];
719         dynargs[2] = args[2];
720         dynargs[3] = args[3];
721         dynargs[4] = args[4];
722         return oraclize_query(timestamp, datasource, dynargs);
723     }
724     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
725         bytes[] memory dynargs = new bytes[](5);
726         dynargs[0] = args[0];
727         dynargs[1] = args[1];
728         dynargs[2] = args[2];
729         dynargs[3] = args[3];
730         dynargs[4] = args[4];
731         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
732     }
733     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
734         bytes[] memory dynargs = new bytes[](5);
735         dynargs[0] = args[0];
736         dynargs[1] = args[1];
737         dynargs[2] = args[2];
738         dynargs[3] = args[3];
739         dynargs[4] = args[4];
740         return oraclize_query(datasource, dynargs, gaslimit);
741     }
742 
743     function oraclize_cbAddress() oraclizeAPI internal returns (address){
744         return oraclize.cbAddress();
745     }
746     function oraclize_setProof(byte proofP) oraclizeAPI internal {
747         return oraclize.setProofType(proofP);
748     }
749     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
750         return oraclize.setCustomGasPrice(gasPrice);
751     }
752     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
753         return oraclize.setConfig(config);
754     }
755 
756     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
757         return oraclize.randomDS_getSessionPubKeyHash();
758     }
759 
760     function getCodeSize(address _addr) constant internal returns(uint _size) {
761         assembly {
762             _size := extcodesize(_addr)
763         }
764     }
765 
766     function parseAddr(string _a) internal returns (address){
767         bytes memory tmp = bytes(_a);
768         uint160 iaddr = 0;
769         uint160 b1;
770         uint160 b2;
771         for (uint i=2; i<2+2*20; i+=2){
772             iaddr *= 256;
773             b1 = uint160(tmp[i]);
774             b2 = uint160(tmp[i+1]);
775             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
776             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
777             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
778             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
779             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
780             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
781             iaddr += (b1*16+b2);
782         }
783         return address(iaddr);
784     }
785 
786     function strCompare(string _a, string _b) internal returns (int) {
787         bytes memory a = bytes(_a);
788         bytes memory b = bytes(_b);
789         uint minLength = a.length;
790         if (b.length < minLength) minLength = b.length;
791         for (uint i = 0; i < minLength; i ++)
792             if (a[i] < b[i])
793                 return -1;
794             else if (a[i] > b[i])
795                 return 1;
796         if (a.length < b.length)
797             return -1;
798         else if (a.length > b.length)
799             return 1;
800         else
801             return 0;
802     }
803 
804     function indexOf(string _haystack, string _needle) internal returns (int) {
805         bytes memory h = bytes(_haystack);
806         bytes memory n = bytes(_needle);
807         if(h.length < 1 || n.length < 1 || (n.length > h.length))
808             return -1;
809         else if(h.length > (2**128 -1))
810             return -1;
811         else
812         {
813             uint subindex = 0;
814             for (uint i = 0; i < h.length; i ++)
815             {
816                 if (h[i] == n[0])
817                 {
818                     subindex = 1;
819                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
820                     {
821                         subindex++;
822                     }
823                     if(subindex == n.length)
824                         return int(i);
825                 }
826             }
827             return -1;
828         }
829     }
830 
831     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
832         bytes memory _ba = bytes(_a);
833         bytes memory _bb = bytes(_b);
834         bytes memory _bc = bytes(_c);
835         bytes memory _bd = bytes(_d);
836         bytes memory _be = bytes(_e);
837         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
838         bytes memory babcde = bytes(abcde);
839         uint k = 0;
840         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
841         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
842         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
843         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
844         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
845         return string(babcde);
846     }
847 
848     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
849         return strConcat(_a, _b, _c, _d, "");
850     }
851 
852     function strConcat(string _a, string _b, string _c) internal returns (string) {
853         return strConcat(_a, _b, _c, "", "");
854     }
855 
856     function strConcat(string _a, string _b) internal returns (string) {
857         return strConcat(_a, _b, "", "", "");
858     }
859 
860     // parseInt
861     function parseInt(string _a) internal returns (uint) {
862         return parseInt(_a, 0);
863     }
864 
865     // parseInt(parseFloat*10^_b)
866     function parseInt(string _a, uint _b) internal returns (uint) {
867         bytes memory bresult = bytes(_a);
868         uint mint = 0;
869         bool decimals = false;
870         for (uint i=0; i<bresult.length; i++){
871             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
872                 if (decimals){
873                    if (_b == 0) break;
874                     else _b--;
875                 }
876                 mint *= 10;
877                 mint += uint(bresult[i]) - 48;
878             } else if (bresult[i] == 46) decimals = true;
879         }
880         if (_b > 0) mint *= 10**_b;
881         return mint;
882     }
883 
884     function uint2str(uint i) internal returns (string){
885         if (i == 0) return "0";
886         uint j = i;
887         uint len;
888         while (j != 0){
889             len++;
890             j /= 10;
891         }
892         bytes memory bstr = new bytes(len);
893         uint k = len - 1;
894         while (i != 0){
895             bstr[k--] = byte(48 + i % 10);
896             i /= 10;
897         }
898         return string(bstr);
899     }
900 
901     using CBOR for Buffer.buffer;
902     function stra2cbor(string[] arr) internal constant returns (bytes) {
903         safeMemoryCleaner();
904         Buffer.buffer memory buf;
905         Buffer.init(buf, 1024);
906         buf.startArray();
907         for (uint i = 0; i < arr.length; i++) {
908             buf.encodeString(arr[i]);
909         }
910         buf.endSequence();
911         return buf.buf;
912     }
913 
914     function ba2cbor(bytes[] arr) internal constant returns (bytes) {
915         safeMemoryCleaner();
916         Buffer.buffer memory buf;
917         Buffer.init(buf, 1024);
918         buf.startArray();
919         for (uint i = 0; i < arr.length; i++) {
920             buf.encodeBytes(arr[i]);
921         }
922         buf.endSequence();
923         return buf.buf;
924     }
925 
926     string oraclize_network_name;
927     function oraclize_setNetworkName(string _network_name) internal {
928         oraclize_network_name = _network_name;
929     }
930 
931     function oraclize_getNetworkName() internal returns (string) {
932         return oraclize_network_name;
933     }
934 
935     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
936         if ((_nbytes == 0)||(_nbytes > 32)) throw;
937 	// Convert from seconds to ledger timer ticks
938         _delay *= 10;
939         bytes memory nbytes = new bytes(1);
940         nbytes[0] = byte(_nbytes);
941         bytes memory unonce = new bytes(32);
942         bytes memory sessionKeyHash = new bytes(32);
943         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
944         assembly {
945             mstore(unonce, 0x20)
946             // the following variables can be relaxed
947             // check relaxed random contract under ethereum-examples repo
948             // for an idea on how to override and replace comit hash vars
949             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
950             mstore(sessionKeyHash, 0x20)
951             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
952         }
953         bytes memory delay = new bytes(32);
954         assembly {
955             mstore(add(delay, 0x20), _delay)
956         }
957 
958         bytes memory delay_bytes8 = new bytes(8);
959         copyBytes(delay, 24, 8, delay_bytes8, 0);
960 
961         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
962         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
963 
964         bytes memory delay_bytes8_left = new bytes(8);
965 
966         assembly {
967             let x := mload(add(delay_bytes8, 0x20))
968             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
969             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
970             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
971             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
972             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
973             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
974             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
975             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
976 
977         }
978 
979         oraclize_randomDS_setCommitment(queryId, sha3(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
980         return queryId;
981     }
982 
983     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
984         oraclize_randomDS_args[queryId] = commitment;
985     }
986 
987     mapping(bytes32=>bytes32) oraclize_randomDS_args;
988     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
989 
990     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
991         bool sigok;
992         address signer;
993 
994         bytes32 sigr;
995         bytes32 sigs;
996 
997         bytes memory sigr_ = new bytes(32);
998         uint offset = 4+(uint(dersig[3]) - 0x20);
999         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1000         bytes memory sigs_ = new bytes(32);
1001         offset += 32 + 2;
1002         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1003 
1004         assembly {
1005             sigr := mload(add(sigr_, 32))
1006             sigs := mload(add(sigs_, 32))
1007         }
1008 
1009 
1010         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1011         if (address(sha3(pubkey)) == signer) return true;
1012         else {
1013             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1014             return (address(sha3(pubkey)) == signer);
1015         }
1016     }
1017 
1018     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1019         bool sigok;
1020 
1021         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1022         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1023         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1024 
1025         bytes memory appkey1_pubkey = new bytes(64);
1026         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1027 
1028         bytes memory tosign2 = new bytes(1+65+32);
1029         tosign2[0] = 1; //role
1030         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1031         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1032         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1033         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1034 
1035         if (sigok == false) return false;
1036 
1037 
1038         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1039         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1040 
1041         bytes memory tosign3 = new bytes(1+65);
1042         tosign3[0] = 0xFE;
1043         copyBytes(proof, 3, 65, tosign3, 1);
1044 
1045         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1046         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1047 
1048         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1049 
1050         return sigok;
1051     }
1052 
1053     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1054         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1055         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
1056 
1057         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1058         if (proofVerified == false) throw;
1059 
1060         _;
1061     }
1062 
1063     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1064         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1065         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1066 
1067         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1068         if (proofVerified == false) return 2;
1069 
1070         return 0;
1071     }
1072 
1073     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
1074         bool match_ = true;
1075 
1076 	if (prefix.length != n_random_bytes) throw;
1077 
1078         for (uint256 i=0; i< n_random_bytes; i++) {
1079             if (content[i] != prefix[i]) match_ = false;
1080         }
1081 
1082         return match_;
1083     }
1084 
1085     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1086 
1087         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1088         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1089         bytes memory keyhash = new bytes(32);
1090         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1091         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
1092 
1093         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1094         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1095 
1096         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1097         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1098 
1099         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1100         // This is to verify that the computed args match with the ones specified in the query.
1101         bytes memory commitmentSlice1 = new bytes(8+1+32);
1102         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1103 
1104         bytes memory sessionPubkey = new bytes(64);
1105         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1106         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1107 
1108         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1109         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1110             delete oraclize_randomDS_args[queryId];
1111         } else return false;
1112 
1113 
1114         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1115         bytes memory tosign1 = new bytes(32+8+1+32);
1116         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1117         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1118 
1119         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1120         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1121             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1122         }
1123 
1124         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1125     }
1126 
1127 
1128     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1129     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1130         uint minLength = length + toOffset;
1131 
1132         if (to.length < minLength) {
1133             // Buffer too small
1134             throw; // Should be a better way?
1135         }
1136 
1137         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1138         uint i = 32 + fromOffset;
1139         uint j = 32 + toOffset;
1140 
1141         while (i < (32 + fromOffset + length)) {
1142             assembly {
1143                 let tmp := mload(add(from, i))
1144                 mstore(add(to, j), tmp)
1145             }
1146             i += 32;
1147             j += 32;
1148         }
1149 
1150         return to;
1151     }
1152 
1153     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1154     // Duplicate Solidity's ecrecover, but catching the CALL return value
1155     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1156         // We do our own memory management here. Solidity uses memory offset
1157         // 0x40 to store the current end of memory. We write past it (as
1158         // writes are memory extensions), but don't update the offset so
1159         // Solidity will reuse it. The memory used here is only needed for
1160         // this context.
1161 
1162         // FIXME: inline assembly can't access return values
1163         bool ret;
1164         address addr;
1165 
1166         assembly {
1167             let size := mload(0x40)
1168             mstore(size, hash)
1169             mstore(add(size, 32), v)
1170             mstore(add(size, 64), r)
1171             mstore(add(size, 96), s)
1172 
1173             // NOTE: we can reuse the request memory because we deal with
1174             //       the return code
1175             ret := call(3000, 1, 0, size, 128, size, 32)
1176             addr := mload(size)
1177         }
1178 
1179         return (ret, addr);
1180     }
1181 
1182     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1183     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1184         bytes32 r;
1185         bytes32 s;
1186         uint8 v;
1187 
1188         if (sig.length != 65)
1189           return (false, 0);
1190 
1191         // The signature format is a compact form of:
1192         //   {bytes32 r}{bytes32 s}{uint8 v}
1193         // Compact means, uint8 is not padded to 32 bytes.
1194         assembly {
1195             r := mload(add(sig, 32))
1196             s := mload(add(sig, 64))
1197 
1198             // Here we are loading the last 32 bytes. We exploit the fact that
1199             // 'mload' will pad with zeroes if we overread.
1200             // There is no 'mload8' to do this, but that would be nicer.
1201             v := byte(0, mload(add(sig, 96)))
1202 
1203             // Alternative solution:
1204             // 'byte' is not working due to the Solidity parser, so lets
1205             // use the second best option, 'and'
1206             // v := and(mload(add(sig, 65)), 255)
1207         }
1208 
1209         // albeit non-transactional signatures are not specified by the YP, one would expect it
1210         // to match the YP range of [27, 28]
1211         //
1212         // geth uses [0, 1] and some clients have followed. This might change, see:
1213         //  https://github.com/ethereum/go-ethereum/issues/2053
1214         if (v < 27)
1215           v += 27;
1216 
1217         if (v != 27 && v != 28)
1218             return (false, 0);
1219 
1220         return safer_ecrecover(hash, v, r, s);
1221     }
1222 
1223     function safeMemoryCleaner() internal constant {
1224         assembly {
1225             let fmem := mload(0x40)
1226             codecopy(fmem, codesize, sub(msize, fmem))
1227         }
1228     }
1229 }
1230 // </ORACLIZE_API>
1231 
1232 library SafeMath {
1233   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1234     if (a == 0) {
1235       return 0;
1236     }
1237     uint256 c = a * b;
1238     assert(c / a == b);
1239     return c;
1240   }
1241   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1242 // assert(b > 0); // Solidity automatically throws when dividing by 0
1243     uint256 c = a / b;
1244 // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1245     return c;
1246   }
1247   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1248     assert(b <= a);
1249     return a - b;
1250   }
1251   function add(uint256 a, uint256 b) internal pure returns (uint256) {
1252     uint256 c = a + b;
1253     assert(c >= a);
1254     return c;
1255   }
1256 }
1257  
1258 contract Ownable {
1259   address public owner;
1260  
1261   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1262  
1263   constructor() public {
1264     owner = msg.sender;
1265   }
1266   modifier onlyOwner() {
1267     require(msg.sender == owner);
1268     _;
1269   }
1270   function transferOwnership(address newOwner) public onlyOwner {
1271     require(newOwner != address(0));
1272     emit OwnershipTransferred(owner, newOwner);
1273     owner = newOwner;
1274   }
1275  
1276 }
1277  
1278 contract VfSE_Lottery_3 is Ownable, usingOraclize {
1279   using SafeMath for uint256;
1280   address[] private players;
1281   address[] public winners;
1282   uint256[] public payments;
1283   uint256 private feeValue;
1284   address public lastWinner;
1285   address public authorizedToDraw;
1286   address[] private last10Winners = [0,0,0,0,0,0,0,0,0,0];  
1287   uint256 public lastPayOut;
1288   uint256 public amountRised;
1289   address public house;
1290   uint256 public round;
1291   uint256 public playValue;
1292   uint256 public roundEnds;
1293   uint256 public roundDuration = 1 days;
1294   bool public stopped;
1295   mapping (address => uint256) public payOuts;
1296   uint256 private _seed;
1297  
1298  
1299   function bitSlice(uint256 n, uint256 bits, uint256 slot) private pure returns(uint256) {
1300     uint256 offset = slot * bits;
1301     uint256 mask = uint256((2**bits) - 1) << offset;
1302     return uint256((n & mask) >> offset);
1303   }
1304  
1305   function maxRandom() private returns (uint256 randomNumber) {
1306     bytes32 myrng = oraclize_query("WolframAlpha", "random number between 1 and 2^64");
1307     _seed = uint256(keccak256(_seed, myrng));
1308     return _seed;
1309   }
1310  
1311  
1312   function random(uint256 upper) private returns (uint256 randomNumber) {
1313     return maxRandom() % upper;
1314   }
1315    
1316   function setHouseAddress(address _house) onlyOwner public {
1317     house = _house;
1318   }
1319  
1320   function setAuthorizedToDraw(address _authorized) onlyOwner public {
1321     authorizedToDraw = _authorized;
1322   }
1323  
1324   function setFee(uint256 _fee) onlyOwner public {
1325     feeValue = _fee;
1326   }
1327  
1328   function setPlayValue(uint256 _amount) onlyOwner public {
1329     playValue = _amount;
1330   }
1331  
1332   function stopLottery(bool _stop) onlyOwner public {
1333     stopped = _stop;
1334   }
1335  
1336   function produceRandom(uint256 upper) private returns (uint256) {
1337     uint256 rand = random(upper);
1338     //output = rand;
1339     return rand;
1340   }
1341  
1342   function getPayOutAmount() private view returns (uint256) {
1343     //uint256 balance = address(this).balance;
1344     uint256 fee = amountRised.mul(feeValue).div(100);
1345     return (amountRised - fee);
1346   }
1347  
1348   function draw() private {
1349     require(now > roundEnds);
1350     uint256 howMuchBets = players.length;
1351     uint256 k;
1352     lastWinner = players[produceRandom(howMuchBets)];
1353     lastPayOut = getPayOutAmount();
1354    
1355     winners.push(lastWinner);
1356     if (winners.length > 9) {
1357       for (uint256 i = (winners.length - 10); i < winners.length; i++) {
1358         last10Winners[k] = winners[i];
1359         k += 1;
1360       }
1361     }
1362  
1363     payments.push(lastPayOut);
1364     payOuts[lastWinner] += lastPayOut;
1365     lastWinner.transfer(lastPayOut);
1366    
1367     players.length = 0;
1368     round += 1;
1369     amountRised = 0;
1370     roundEnds = now + roundDuration;
1371    
1372     emit NewWinner(lastWinner, lastPayOut);
1373   }
1374  
1375   function drawNow() public {
1376     require(authorizedToDraw == msg.sender);
1377     draw();
1378   }
1379  
1380   function play() payable public {
1381     require (msg.value == playValue);
1382     require (!stopped);
1383  
1384     if (now > roundEnds) {
1385       if (players.length < 2) {
1386         roundEnds = now + roundDuration;
1387       } else {
1388         draw();
1389       }
1390     }
1391     players.push(msg.sender);
1392     amountRised = amountRised.add(msg.value);
1393   }
1394  
1395   function() payable public {
1396     play();
1397   }
1398  
1399   constructor() public {
1400     house = msg.sender;
1401     authorizedToDraw = msg.sender;
1402     feeValue = 10;
1403     playValue = 1000 finney;
1404   }
1405    
1406   function getBalance() onlyOwner public {
1407     uint256 thisBalance = address(this).balance;
1408     house.transfer(thisBalance - amountRised);
1409   }
1410  
1411   function getPlayersCount() public view returns (uint256) {
1412     return players.length;
1413   }
1414  
1415   function getWinnerCount() public view returns (uint256) {
1416     return winners.length;
1417   }
1418  
1419   function getPlayers() public view returns (address[]) {
1420     return players;
1421   }
1422  
1423   function last10() public view returns (address[]) {
1424     if (winners.length < 11) {
1425       return winners;
1426     } else {
1427       return last10Winners;
1428     }
1429   }
1430   event NewWinner(address _winner, uint256 _amount);
1431 }