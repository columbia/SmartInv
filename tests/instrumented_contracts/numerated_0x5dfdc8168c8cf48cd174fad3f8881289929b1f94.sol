1 // <ORACLIZE_API>
2 /*
3 Copyright (c) 2015-2016 Oraclize SRL
4 Copyright (c) 2016 Oraclize LTD
5 
6 
7 
8 Permission is hereby granted, free of charge, to any person obtaining a copy
9 of this software and associated documentation files (the "Software"), to deal
10 in the Software without restriction, including without limitation the rights
11 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
12 copies of the Software, and to permit persons to whom the Software is
13 furnished to do so, subject to the following conditions:
14 
15 
16 
17 The above copyright notice and this permission notice shall be included in
18 all copies or substantial portions of the Software.
19 
20 
21 
22 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
23 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
24 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
25 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
26 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
27 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
28 THE SOFTWARE.
29 */
30 
31 pragma solidity >=0.4.1;//please import oraclizeAPI_pre0.4.sol when solidity < 0.4.x
32 
33 contract OraclizeI {
34     address public cbAddress;
35     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
36     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
37     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
38     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
39     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
40     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
41     function getPrice(string _datasource) returns (uint _dsprice);
42     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
43     function useCoupon(string _coupon);
44     function setProofType(byte _proofType);
45     function setConfig(bytes32 _config);
46     function setCustomGasPrice(uint _gasPrice);
47     function randomDS_getSessionPubKeyHash() returns(bytes32);
48 }
49 
50 contract OraclizeAddrResolverI {
51     function getAddress() returns (address _addr);
52 }
53 
54 /*
55 Begin solidity-cborutils
56 
57 https://github.com/smartcontractkit/solidity-cborutils
58 
59 MIT License
60 
61 Copyright (c) 2018 SmartContract ChainLink, Ltd.
62 
63 Permission is hereby granted, free of charge, to any person obtaining a copy
64 of this software and associated documentation files (the "Software"), to deal
65 in the Software without restriction, including without limitation the rights
66 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
67 copies of the Software, and to permit persons to whom the Software is
68 furnished to do so, subject to the following conditions:
69 
70 The above copyright notice and this permission notice shall be included in all
71 copies or substantial portions of the Software.
72 
73 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
74 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
75 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
76 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
77 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
78 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
79 SOFTWARE.
80  */
81 
82 library Buffer {
83     struct buffer {
84         bytes buf;
85         uint capacity;
86     }
87 
88     function init(buffer memory buf, uint capacity) internal constant {
89         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
90         // Allocate space for the buffer data
91         buf.capacity = capacity;
92         assembly {
93             let ptr := mload(0x40)
94             mstore(buf, ptr)
95             mstore(0x40, add(ptr, capacity))
96         }
97     }
98 
99     function resize(buffer memory buf, uint capacity) private constant {
100         bytes memory oldbuf = buf.buf;
101         init(buf, capacity);
102         append(buf, oldbuf);
103     }
104 
105     function max(uint a, uint b) private constant returns(uint) {
106         if(a > b) {
107             return a;
108         }
109         return b;
110     }
111 
112     /**
113      * @dev Appends a byte array to the end of the buffer. Reverts if doing so
114      *      would exceed the capacity of the buffer.
115      * @param buf The buffer to append to.
116      * @param data The data to append.
117      * @return The original buffer.
118      */
119     function append(buffer memory buf, bytes data) internal constant returns(buffer memory) {
120         if(data.length + buf.buf.length > buf.capacity) {
121             resize(buf, max(buf.capacity, data.length) * 2);
122         }
123 
124         uint dest;
125         uint src;
126         uint len = data.length;
127         assembly {
128             // Memory address of the buffer data
129             let bufptr := mload(buf)
130             // Length of existing buffer data
131             let buflen := mload(bufptr)
132             // Start address = buffer address + buffer length + sizeof(buffer length)
133             dest := add(add(bufptr, buflen), 32)
134             // Update buffer length
135             mstore(bufptr, add(buflen, mload(data)))
136             src := add(data, 32)
137         }
138 
139         // Copy word-length chunks while possible
140         for(; len >= 32; len -= 32) {
141             assembly {
142                 mstore(dest, mload(src))
143             }
144             dest += 32;
145             src += 32;
146         }
147 
148         // Copy remaining bytes
149         uint mask = 256 ** (32 - len) - 1;
150         assembly {
151             let srcpart := and(mload(src), not(mask))
152             let destpart := and(mload(dest), mask)
153             mstore(dest, or(destpart, srcpart))
154         }
155 
156         return buf;
157     }
158 
159     /**
160      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
161      * exceed the capacity of the buffer.
162      * @param buf The buffer to append to.
163      * @param data The data to append.
164      * @return The original buffer.
165      */
166     function append(buffer memory buf, uint8 data) internal constant {
167         if(buf.buf.length + 1 > buf.capacity) {
168             resize(buf, buf.capacity * 2);
169         }
170 
171         assembly {
172             // Memory address of the buffer data
173             let bufptr := mload(buf)
174             // Length of existing buffer data
175             let buflen := mload(bufptr)
176             // Address = buffer address + buffer length + sizeof(buffer length)
177             let dest := add(add(bufptr, buflen), 32)
178             mstore8(dest, data)
179             // Update buffer length
180             mstore(bufptr, add(buflen, 1))
181         }
182     }
183 
184     /**
185      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
186      * exceed the capacity of the buffer.
187      * @param buf The buffer to append to.
188      * @param data The data to append.
189      * @return The original buffer.
190      */
191     function appendInt(buffer memory buf, uint data, uint len) internal constant returns(buffer memory) {
192         if(len + buf.buf.length > buf.capacity) {
193             resize(buf, max(buf.capacity, len) * 2);
194         }
195 
196         uint mask = 256 ** len - 1;
197         assembly {
198             // Memory address of the buffer data
199             let bufptr := mload(buf)
200             // Length of existing buffer data
201             let buflen := mload(bufptr)
202             // Address = buffer address + buffer length + sizeof(buffer length) + len
203             let dest := add(add(bufptr, buflen), len)
204             mstore(dest, or(and(mload(dest), not(mask)), data))
205             // Update buffer length
206             mstore(bufptr, add(buflen, len))
207         }
208         return buf;
209     }
210 }
211 
212 library CBOR {
213     using Buffer for Buffer.buffer;
214 
215     uint8 private constant MAJOR_TYPE_INT = 0;
216     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
217     uint8 private constant MAJOR_TYPE_BYTES = 2;
218     uint8 private constant MAJOR_TYPE_STRING = 3;
219     uint8 private constant MAJOR_TYPE_ARRAY = 4;
220     uint8 private constant MAJOR_TYPE_MAP = 5;
221     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
222 
223     function shl8(uint8 x, uint8 y) private constant returns (uint8) {
224         return x * (2 ** y);
225     }
226 
227     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private constant {
228         if(value <= 23) {
229             buf.append(uint8(shl8(major, 5) | value));
230         } else if(value <= 0xFF) {
231             buf.append(uint8(shl8(major, 5) | 24));
232             buf.appendInt(value, 1);
233         } else if(value <= 0xFFFF) {
234             buf.append(uint8(shl8(major, 5) | 25));
235             buf.appendInt(value, 2);
236         } else if(value <= 0xFFFFFFFF) {
237             buf.append(uint8(shl8(major, 5) | 26));
238             buf.appendInt(value, 4);
239         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
240             buf.append(uint8(shl8(major, 5) | 27));
241             buf.appendInt(value, 8);
242         }
243     }
244 
245     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private constant {
246         buf.append(uint8(shl8(major, 5) | 31));
247     }
248 
249     function encodeUInt(Buffer.buffer memory buf, uint value) internal constant {
250         encodeType(buf, MAJOR_TYPE_INT, value);
251     }
252 
253     function encodeInt(Buffer.buffer memory buf, int value) internal constant {
254         if(value >= 0) {
255             encodeType(buf, MAJOR_TYPE_INT, uint(value));
256         } else {
257             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
258         }
259     }
260 
261     function encodeBytes(Buffer.buffer memory buf, bytes value) internal constant {
262         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
263         buf.append(value);
264     }
265 
266     function encodeString(Buffer.buffer memory buf, string value) internal constant {
267         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
268         buf.append(bytes(value));
269     }
270 
271     function startArray(Buffer.buffer memory buf) internal constant {
272         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
273     }
274 
275     function startMap(Buffer.buffer memory buf) internal constant {
276         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
277     }
278 
279     function endSequence(Buffer.buffer memory buf) internal constant {
280         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
281     }
282 }
283 
284 /*
285 End solidity-cborutils
286  */
287 
288 contract usingOraclize {
289     uint constant day = 60*60*24;
290     uint constant week = 60*60*24*7;
291     uint constant month = 60*60*24*30;
292     byte constant proofType_NONE = 0x00;
293     byte constant proofType_TLSNotary = 0x10;
294     byte constant proofType_Android = 0x20;
295     byte constant proofType_Ledger = 0x30;
296     byte constant proofType_Native = 0xF0;
297     byte constant proofStorage_IPFS = 0x01;
298     uint8 constant networkID_auto = 0;
299     uint8 constant networkID_mainnet = 1;
300     uint8 constant networkID_testnet = 2;
301     uint8 constant networkID_morden = 2;
302     uint8 constant networkID_consensys = 161;
303 
304     OraclizeAddrResolverI OAR;
305 
306     OraclizeI oraclize;
307     modifier oraclizeAPI {
308         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
309             oraclize_setNetwork(networkID_auto);
310 
311         if(address(oraclize) != OAR.getAddress())
312             oraclize = OraclizeI(OAR.getAddress());
313 
314         _;
315     }
316     modifier coupon(string code){
317         oraclize = OraclizeI(OAR.getAddress());
318         oraclize.useCoupon(code);
319         _;
320     }
321 
322     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
323         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
324             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
325             oraclize_setNetworkName("eth_mainnet");
326             return true;
327         }
328         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
329             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
330             oraclize_setNetworkName("eth_ropsten3");
331             return true;
332         }
333         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
334             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
335             oraclize_setNetworkName("eth_kovan");
336             return true;
337         }
338         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
339             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
340             oraclize_setNetworkName("eth_rinkeby");
341             return true;
342         }
343         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
344             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
345             return true;
346         }
347         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
348             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
349             return true;
350         }
351         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
352             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
353             return true;
354         }
355         return false;
356     }
357 
358     function __callback(bytes32 myid, string result) {
359         __callback(myid, result, new bytes(0));
360     }
361     function __callback(bytes32 myid, string result, bytes proof) {
362     }
363 
364     function oraclize_useCoupon(string code) oraclizeAPI internal {
365         oraclize.useCoupon(code);
366     }
367 
368     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
369         return oraclize.getPrice(datasource);
370     }
371 
372     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
373         return oraclize.getPrice(datasource, gaslimit);
374     }
375 
376     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
377         uint price = oraclize.getPrice(datasource);
378         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
379         return oraclize.query.value(price)(0, datasource, arg);
380     }
381     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
382         uint price = oraclize.getPrice(datasource);
383         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
384         return oraclize.query.value(price)(timestamp, datasource, arg);
385     }
386     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
387         uint price = oraclize.getPrice(datasource, gaslimit);
388         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
389         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
390     }
391     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
392         uint price = oraclize.getPrice(datasource, gaslimit);
393         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
394         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
395     }
396     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
397         uint price = oraclize.getPrice(datasource);
398         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
399         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
400     }
401     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
402         uint price = oraclize.getPrice(datasource);
403         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
404         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
405     }
406     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
407         uint price = oraclize.getPrice(datasource, gaslimit);
408         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
409         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
410     }
411     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
412         uint price = oraclize.getPrice(datasource, gaslimit);
413         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
414         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
415     }
416     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
417         uint price = oraclize.getPrice(datasource);
418         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
419         bytes memory args = stra2cbor(argN);
420         return oraclize.queryN.value(price)(0, datasource, args);
421     }
422     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
423         uint price = oraclize.getPrice(datasource);
424         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
425         bytes memory args = stra2cbor(argN);
426         return oraclize.queryN.value(price)(timestamp, datasource, args);
427     }
428     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
429         uint price = oraclize.getPrice(datasource, gaslimit);
430         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
431         bytes memory args = stra2cbor(argN);
432         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
433     }
434     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
435         uint price = oraclize.getPrice(datasource, gaslimit);
436         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
437         bytes memory args = stra2cbor(argN);
438         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
439     }
440     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
441         string[] memory dynargs = new string[](1);
442         dynargs[0] = args[0];
443         return oraclize_query(datasource, dynargs);
444     }
445     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
446         string[] memory dynargs = new string[](1);
447         dynargs[0] = args[0];
448         return oraclize_query(timestamp, datasource, dynargs);
449     }
450     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
451         string[] memory dynargs = new string[](1);
452         dynargs[0] = args[0];
453         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
454     }
455     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
456         string[] memory dynargs = new string[](1);
457         dynargs[0] = args[0];
458         return oraclize_query(datasource, dynargs, gaslimit);
459     }
460 
461     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
462         string[] memory dynargs = new string[](2);
463         dynargs[0] = args[0];
464         dynargs[1] = args[1];
465         return oraclize_query(datasource, dynargs);
466     }
467     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
468         string[] memory dynargs = new string[](2);
469         dynargs[0] = args[0];
470         dynargs[1] = args[1];
471         return oraclize_query(timestamp, datasource, dynargs);
472     }
473     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
474         string[] memory dynargs = new string[](2);
475         dynargs[0] = args[0];
476         dynargs[1] = args[1];
477         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
478     }
479     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
480         string[] memory dynargs = new string[](2);
481         dynargs[0] = args[0];
482         dynargs[1] = args[1];
483         return oraclize_query(datasource, dynargs, gaslimit);
484     }
485     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
486         string[] memory dynargs = new string[](3);
487         dynargs[0] = args[0];
488         dynargs[1] = args[1];
489         dynargs[2] = args[2];
490         return oraclize_query(datasource, dynargs);
491     }
492     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
493         string[] memory dynargs = new string[](3);
494         dynargs[0] = args[0];
495         dynargs[1] = args[1];
496         dynargs[2] = args[2];
497         return oraclize_query(timestamp, datasource, dynargs);
498     }
499     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
500         string[] memory dynargs = new string[](3);
501         dynargs[0] = args[0];
502         dynargs[1] = args[1];
503         dynargs[2] = args[2];
504         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
505     }
506     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
507         string[] memory dynargs = new string[](3);
508         dynargs[0] = args[0];
509         dynargs[1] = args[1];
510         dynargs[2] = args[2];
511         return oraclize_query(datasource, dynargs, gaslimit);
512     }
513 
514     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
515         string[] memory dynargs = new string[](4);
516         dynargs[0] = args[0];
517         dynargs[1] = args[1];
518         dynargs[2] = args[2];
519         dynargs[3] = args[3];
520         return oraclize_query(datasource, dynargs);
521     }
522     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
523         string[] memory dynargs = new string[](4);
524         dynargs[0] = args[0];
525         dynargs[1] = args[1];
526         dynargs[2] = args[2];
527         dynargs[3] = args[3];
528         return oraclize_query(timestamp, datasource, dynargs);
529     }
530     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
531         string[] memory dynargs = new string[](4);
532         dynargs[0] = args[0];
533         dynargs[1] = args[1];
534         dynargs[2] = args[2];
535         dynargs[3] = args[3];
536         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
537     }
538     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
539         string[] memory dynargs = new string[](4);
540         dynargs[0] = args[0];
541         dynargs[1] = args[1];
542         dynargs[2] = args[2];
543         dynargs[3] = args[3];
544         return oraclize_query(datasource, dynargs, gaslimit);
545     }
546     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
547         string[] memory dynargs = new string[](5);
548         dynargs[0] = args[0];
549         dynargs[1] = args[1];
550         dynargs[2] = args[2];
551         dynargs[3] = args[3];
552         dynargs[4] = args[4];
553         return oraclize_query(datasource, dynargs);
554     }
555     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
556         string[] memory dynargs = new string[](5);
557         dynargs[0] = args[0];
558         dynargs[1] = args[1];
559         dynargs[2] = args[2];
560         dynargs[3] = args[3];
561         dynargs[4] = args[4];
562         return oraclize_query(timestamp, datasource, dynargs);
563     }
564     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
565         string[] memory dynargs = new string[](5);
566         dynargs[0] = args[0];
567         dynargs[1] = args[1];
568         dynargs[2] = args[2];
569         dynargs[3] = args[3];
570         dynargs[4] = args[4];
571         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
572     }
573     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
574         string[] memory dynargs = new string[](5);
575         dynargs[0] = args[0];
576         dynargs[1] = args[1];
577         dynargs[2] = args[2];
578         dynargs[3] = args[3];
579         dynargs[4] = args[4];
580         return oraclize_query(datasource, dynargs, gaslimit);
581     }
582     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
583         uint price = oraclize.getPrice(datasource);
584         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
585         bytes memory args = ba2cbor(argN);
586         return oraclize.queryN.value(price)(0, datasource, args);
587     }
588     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
589         uint price = oraclize.getPrice(datasource);
590         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
591         bytes memory args = ba2cbor(argN);
592         return oraclize.queryN.value(price)(timestamp, datasource, args);
593     }
594     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
595         uint price = oraclize.getPrice(datasource, gaslimit);
596         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
597         bytes memory args = ba2cbor(argN);
598         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
599     }
600     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
601         uint price = oraclize.getPrice(datasource, gaslimit);
602         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
603         bytes memory args = ba2cbor(argN);
604         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
605     }
606     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
607         bytes[] memory dynargs = new bytes[](1);
608         dynargs[0] = args[0];
609         return oraclize_query(datasource, dynargs);
610     }
611     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
612         bytes[] memory dynargs = new bytes[](1);
613         dynargs[0] = args[0];
614         return oraclize_query(timestamp, datasource, dynargs);
615     }
616     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
617         bytes[] memory dynargs = new bytes[](1);
618         dynargs[0] = args[0];
619         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
620     }
621     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
622         bytes[] memory dynargs = new bytes[](1);
623         dynargs[0] = args[0];
624         return oraclize_query(datasource, dynargs, gaslimit);
625     }
626 
627     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
628         bytes[] memory dynargs = new bytes[](2);
629         dynargs[0] = args[0];
630         dynargs[1] = args[1];
631         return oraclize_query(datasource, dynargs);
632     }
633     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
634         bytes[] memory dynargs = new bytes[](2);
635         dynargs[0] = args[0];
636         dynargs[1] = args[1];
637         return oraclize_query(timestamp, datasource, dynargs);
638     }
639     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
640         bytes[] memory dynargs = new bytes[](2);
641         dynargs[0] = args[0];
642         dynargs[1] = args[1];
643         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
644     }
645     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
646         bytes[] memory dynargs = new bytes[](2);
647         dynargs[0] = args[0];
648         dynargs[1] = args[1];
649         return oraclize_query(datasource, dynargs, gaslimit);
650     }
651     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
652         bytes[] memory dynargs = new bytes[](3);
653         dynargs[0] = args[0];
654         dynargs[1] = args[1];
655         dynargs[2] = args[2];
656         return oraclize_query(datasource, dynargs);
657     }
658     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
659         bytes[] memory dynargs = new bytes[](3);
660         dynargs[0] = args[0];
661         dynargs[1] = args[1];
662         dynargs[2] = args[2];
663         return oraclize_query(timestamp, datasource, dynargs);
664     }
665     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
666         bytes[] memory dynargs = new bytes[](3);
667         dynargs[0] = args[0];
668         dynargs[1] = args[1];
669         dynargs[2] = args[2];
670         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
671     }
672     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
673         bytes[] memory dynargs = new bytes[](3);
674         dynargs[0] = args[0];
675         dynargs[1] = args[1];
676         dynargs[2] = args[2];
677         return oraclize_query(datasource, dynargs, gaslimit);
678     }
679 
680     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
681         bytes[] memory dynargs = new bytes[](4);
682         dynargs[0] = args[0];
683         dynargs[1] = args[1];
684         dynargs[2] = args[2];
685         dynargs[3] = args[3];
686         return oraclize_query(datasource, dynargs);
687     }
688     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
689         bytes[] memory dynargs = new bytes[](4);
690         dynargs[0] = args[0];
691         dynargs[1] = args[1];
692         dynargs[2] = args[2];
693         dynargs[3] = args[3];
694         return oraclize_query(timestamp, datasource, dynargs);
695     }
696     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
697         bytes[] memory dynargs = new bytes[](4);
698         dynargs[0] = args[0];
699         dynargs[1] = args[1];
700         dynargs[2] = args[2];
701         dynargs[3] = args[3];
702         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
703     }
704     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
705         bytes[] memory dynargs = new bytes[](4);
706         dynargs[0] = args[0];
707         dynargs[1] = args[1];
708         dynargs[2] = args[2];
709         dynargs[3] = args[3];
710         return oraclize_query(datasource, dynargs, gaslimit);
711     }
712     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
713         bytes[] memory dynargs = new bytes[](5);
714         dynargs[0] = args[0];
715         dynargs[1] = args[1];
716         dynargs[2] = args[2];
717         dynargs[3] = args[3];
718         dynargs[4] = args[4];
719         return oraclize_query(datasource, dynargs);
720     }
721     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
722         bytes[] memory dynargs = new bytes[](5);
723         dynargs[0] = args[0];
724         dynargs[1] = args[1];
725         dynargs[2] = args[2];
726         dynargs[3] = args[3];
727         dynargs[4] = args[4];
728         return oraclize_query(timestamp, datasource, dynargs);
729     }
730     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
731         bytes[] memory dynargs = new bytes[](5);
732         dynargs[0] = args[0];
733         dynargs[1] = args[1];
734         dynargs[2] = args[2];
735         dynargs[3] = args[3];
736         dynargs[4] = args[4];
737         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
738     }
739     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
740         bytes[] memory dynargs = new bytes[](5);
741         dynargs[0] = args[0];
742         dynargs[1] = args[1];
743         dynargs[2] = args[2];
744         dynargs[3] = args[3];
745         dynargs[4] = args[4];
746         return oraclize_query(datasource, dynargs, gaslimit);
747     }
748 
749     function oraclize_cbAddress() oraclizeAPI internal returns (address){
750         return oraclize.cbAddress();
751     }
752     function oraclize_setProof(byte proofP) oraclizeAPI internal {
753         return oraclize.setProofType(proofP);
754     }
755     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
756         return oraclize.setCustomGasPrice(gasPrice);
757     }
758     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
759         return oraclize.setConfig(config);
760     }
761 
762     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
763         return oraclize.randomDS_getSessionPubKeyHash();
764     }
765 
766     function getCodeSize(address _addr) constant internal returns(uint _size) {
767         assembly {
768             _size := extcodesize(_addr)
769         }
770     }
771 
772     function parseAddr(string _a) internal returns (address){
773         bytes memory tmp = bytes(_a);
774         uint160 iaddr = 0;
775         uint160 b1;
776         uint160 b2;
777         for (uint i=2; i<2+2*20; i+=2){
778             iaddr *= 256;
779             b1 = uint160(tmp[i]);
780             b2 = uint160(tmp[i+1]);
781             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
782             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
783             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
784             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
785             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
786             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
787             iaddr += (b1*16+b2);
788         }
789         return address(iaddr);
790     }
791 
792     function strCompare(string _a, string _b) internal returns (int) {
793         bytes memory a = bytes(_a);
794         bytes memory b = bytes(_b);
795         uint minLength = a.length;
796         if (b.length < minLength) minLength = b.length;
797         for (uint i = 0; i < minLength; i ++)
798             if (a[i] < b[i])
799                 return -1;
800             else if (a[i] > b[i])
801                 return 1;
802         if (a.length < b.length)
803             return -1;
804         else if (a.length > b.length)
805             return 1;
806         else
807             return 0;
808     }
809 
810     function indexOf(string _haystack, string _needle) internal returns (int) {
811         bytes memory h = bytes(_haystack);
812         bytes memory n = bytes(_needle);
813         if(h.length < 1 || n.length < 1 || (n.length > h.length))
814             return -1;
815         else if(h.length > (2**128 -1))
816             return -1;
817         else
818         {
819             uint subindex = 0;
820             for (uint i = 0; i < h.length; i ++)
821             {
822                 if (h[i] == n[0])
823                 {
824                     subindex = 1;
825                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
826                     {
827                         subindex++;
828                     }
829                     if(subindex == n.length)
830                         return int(i);
831                 }
832             }
833             return -1;
834         }
835     }
836 
837     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
838         bytes memory _ba = bytes(_a);
839         bytes memory _bb = bytes(_b);
840         bytes memory _bc = bytes(_c);
841         bytes memory _bd = bytes(_d);
842         bytes memory _be = bytes(_e);
843         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
844         bytes memory babcde = bytes(abcde);
845         uint k = 0;
846         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
847         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
848         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
849         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
850         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
851         return string(babcde);
852     }
853 
854     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
855         return strConcat(_a, _b, _c, _d, "");
856     }
857 
858     function strConcat(string _a, string _b, string _c) internal returns (string) {
859         return strConcat(_a, _b, _c, "", "");
860     }
861 
862     function strConcat(string _a, string _b) internal returns (string) {
863         return strConcat(_a, _b, "", "", "");
864     }
865 
866     // parseInt
867     function parseInt(string _a) internal returns (uint) {
868         return parseInt(_a, 0);
869     }
870 
871     // parseInt(parseFloat*10^_b)
872     function parseInt(string _a, uint _b) internal returns (uint) {
873         bytes memory bresult = bytes(_a);
874         uint mint = 0;
875         bool decimals = false;
876         for (uint i=0; i<bresult.length; i++){
877             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
878                 if (decimals){
879                    if (_b == 0) break;
880                     else _b--;
881                 }
882                 mint *= 10;
883                 mint += uint(bresult[i]) - 48;
884             } else if (bresult[i] == 46) decimals = true;
885         }
886         if (_b > 0) mint *= 10**_b;
887         return mint;
888     }
889 
890     function uint2str(uint i) internal returns (string){
891         if (i == 0) return "0";
892         uint j = i;
893         uint len;
894         while (j != 0){
895             len++;
896             j /= 10;
897         }
898         bytes memory bstr = new bytes(len);
899         uint k = len - 1;
900         while (i != 0){
901             bstr[k--] = byte(48 + i % 10);
902             i /= 10;
903         }
904         return string(bstr);
905     }
906 
907     using CBOR for Buffer.buffer;
908     function stra2cbor(string[] arr) internal constant returns (bytes) {
909         Buffer.buffer memory buf;
910         Buffer.init(buf, 1024);
911         buf.startArray();
912         for (uint i = 0; i < arr.length; i++) {
913             buf.encodeString(arr[i]);
914         }
915         buf.endSequence();
916         return buf.buf;
917     }
918 
919     function ba2cbor(bytes[] arr) internal constant returns (bytes) {
920         Buffer.buffer memory buf;
921         Buffer.init(buf, 1024);
922         buf.startArray();
923         for (uint i = 0; i < arr.length; i++) {
924             buf.encodeBytes(arr[i]);
925         }
926         buf.endSequence();
927         return buf.buf;
928     }
929 
930     string oraclize_network_name;
931     function oraclize_setNetworkName(string _network_name) internal {
932         oraclize_network_name = _network_name;
933     }
934 
935     function oraclize_getNetworkName() internal returns (string) {
936         return oraclize_network_name;
937     }
938 
939     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
940         if ((_nbytes == 0)||(_nbytes > 32)) throw;
941 	// Convert from seconds to ledger timer ticks
942         _delay *= 10;
943         bytes memory nbytes = new bytes(1);
944         nbytes[0] = byte(_nbytes);
945         bytes memory unonce = new bytes(32);
946         bytes memory sessionKeyHash = new bytes(32);
947         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
948         assembly {
949             mstore(unonce, 0x20)
950             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
951             mstore(sessionKeyHash, 0x20)
952             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
953         }
954         bytes memory delay = new bytes(32);
955         assembly {
956             mstore(add(delay, 0x20), _delay)
957         }
958 
959         bytes memory delay_bytes8 = new bytes(8);
960         copyBytes(delay, 24, 8, delay_bytes8, 0);
961 
962         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
963         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
964 
965         bytes memory delay_bytes8_left = new bytes(8);
966 
967         assembly {
968             let x := mload(add(delay_bytes8, 0x20))
969             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
970             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
971             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
972             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
973             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
974             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
975             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
976             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
977 
978         }
979 
980         oraclize_randomDS_setCommitment(queryId, sha3(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
981         return queryId;
982     }
983 
984     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
985         oraclize_randomDS_args[queryId] = commitment;
986     }
987 
988     mapping(bytes32=>bytes32) oraclize_randomDS_args;
989     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
990 
991     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
992         bool sigok;
993         address signer;
994 
995         bytes32 sigr;
996         bytes32 sigs;
997 
998         bytes memory sigr_ = new bytes(32);
999         uint offset = 4+(uint(dersig[3]) - 0x20);
1000         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1001         bytes memory sigs_ = new bytes(32);
1002         offset += 32 + 2;
1003         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1004 
1005         assembly {
1006             sigr := mload(add(sigr_, 32))
1007             sigs := mload(add(sigs_, 32))
1008         }
1009 
1010 
1011         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1012         if (address(sha3(pubkey)) == signer) return true;
1013         else {
1014             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1015             return (address(sha3(pubkey)) == signer);
1016         }
1017     }
1018 
1019     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1020         bool sigok;
1021 
1022         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1023         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1024         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1025 
1026         bytes memory appkey1_pubkey = new bytes(64);
1027         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1028 
1029         bytes memory tosign2 = new bytes(1+65+32);
1030         tosign2[0] = 1; //role
1031         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1032         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1033         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1034         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1035 
1036         if (sigok == false) return false;
1037 
1038 
1039         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1040         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1041 
1042         bytes memory tosign3 = new bytes(1+65);
1043         tosign3[0] = 0xFE;
1044         copyBytes(proof, 3, 65, tosign3, 1);
1045 
1046         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1047         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1048 
1049         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1050 
1051         return sigok;
1052     }
1053 
1054     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1055         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1056         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
1057 
1058         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1059         if (proofVerified == false) throw;
1060 
1061         _;
1062     }
1063 
1064     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1065         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1066         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1067 
1068         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1069         if (proofVerified == false) return 2;
1070 
1071         return 0;
1072     }
1073 
1074     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
1075         bool match_ = true;
1076 
1077 	if (prefix.length != n_random_bytes) throw;
1078 
1079         for (uint256 i=0; i< n_random_bytes; i++) {
1080             if (content[i] != prefix[i]) match_ = false;
1081         }
1082 
1083         return match_;
1084     }
1085 
1086     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1087 
1088         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1089         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1090         bytes memory keyhash = new bytes(32);
1091         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1092         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
1093 
1094         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1095         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1096 
1097         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1098         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1099 
1100         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1101         // This is to verify that the computed args match with the ones specified in the query.
1102         bytes memory commitmentSlice1 = new bytes(8+1+32);
1103         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1104 
1105         bytes memory sessionPubkey = new bytes(64);
1106         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1107         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1108 
1109         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1110         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1111             delete oraclize_randomDS_args[queryId];
1112         } else return false;
1113 
1114 
1115         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1116         bytes memory tosign1 = new bytes(32+8+1+32);
1117         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1118         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1119 
1120         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1121         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1122             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1123         }
1124 
1125         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1126     }
1127 
1128 
1129     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1130     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1131         uint minLength = length + toOffset;
1132 
1133         if (to.length < minLength) {
1134             // Buffer too small
1135             throw; // Should be a better way?
1136         }
1137 
1138         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1139         uint i = 32 + fromOffset;
1140         uint j = 32 + toOffset;
1141 
1142         while (i < (32 + fromOffset + length)) {
1143             assembly {
1144                 let tmp := mload(add(from, i))
1145                 mstore(add(to, j), tmp)
1146             }
1147             i += 32;
1148             j += 32;
1149         }
1150 
1151         return to;
1152     }
1153 
1154     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1155     // Duplicate Solidity's ecrecover, but catching the CALL return value
1156     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1157         // We do our own memory management here. Solidity uses memory offset
1158         // 0x40 to store the current end of memory. We write past it (as
1159         // writes are memory extensions), but don't update the offset so
1160         // Solidity will reuse it. The memory used here is only needed for
1161         // this context.
1162 
1163         // FIXME: inline assembly can't access return values
1164         bool ret;
1165         address addr;
1166 
1167         assembly {
1168             let size := mload(0x40)
1169             mstore(size, hash)
1170             mstore(add(size, 32), v)
1171             mstore(add(size, 64), r)
1172             mstore(add(size, 96), s)
1173 
1174             // NOTE: we can reuse the request memory because we deal with
1175             //       the return code
1176             ret := call(3000, 1, 0, size, 128, size, 32)
1177             addr := mload(size)
1178         }
1179 
1180         return (ret, addr);
1181     }
1182 
1183     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1184     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1185         bytes32 r;
1186         bytes32 s;
1187         uint8 v;
1188 
1189         if (sig.length != 65)
1190           return (false, 0);
1191 
1192         // The signature format is a compact form of:
1193         //   {bytes32 r}{bytes32 s}{uint8 v}
1194         // Compact means, uint8 is not padded to 32 bytes.
1195         assembly {
1196             r := mload(add(sig, 32))
1197             s := mload(add(sig, 64))
1198 
1199             // Here we are loading the last 32 bytes. We exploit the fact that
1200             // 'mload' will pad with zeroes if we overread.
1201             // There is no 'mload8' to do this, but that would be nicer.
1202             v := byte(0, mload(add(sig, 96)))
1203 
1204             // Alternative solution:
1205             // 'byte' is not working due to the Solidity parser, so lets
1206             // use the second best option, 'and'
1207             // v := and(mload(add(sig, 65)), 255)
1208         }
1209 
1210         // albeit non-transactional signatures are not specified by the YP, one would expect it
1211         // to match the YP range of [27, 28]
1212         //
1213         // geth uses [0, 1] and some clients have followed. This might change, see:
1214         //  https://github.com/ethereum/go-ethereum/issues/2053
1215         if (v < 27)
1216           v += 27;
1217 
1218         if (v != 27 && v != 28)
1219             return (false, 0);
1220 
1221         return safer_ecrecover(hash, v, r, s);
1222     }
1223 
1224 }
1225 // </ORACLIZE_API>
1226 
1227 /**
1228  * @title Ownable
1229  * @dev The Ownable contract has an owner address, and provides basic authorization control
1230  * functions, this simplifies the implementation of "user permissions".
1231  */
1232 contract Ownable {
1233   address public owner;
1234 
1235   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1236 
1237   /**
1238    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1239    * account.
1240    */
1241   constructor() public {
1242     owner = msg.sender;
1243   }
1244 
1245   /**
1246    * @dev Throws if called by any account other than the owner.
1247    */
1248   modifier onlyOwner() {
1249     require(msg.sender == owner);
1250     _;
1251   }
1252 
1253   /**
1254    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1255    * @param newOwner The address to transfer ownership to.
1256    */
1257   function transferOwnership(address newOwner) public onlyOwner {
1258     require(newOwner != address(0));
1259     emit OwnershipTransferred(owner, newOwner);
1260     owner = newOwner;
1261   }
1262 }
1263 
1264 /**
1265  * @title SafeMath
1266  * @dev Math operations with safety checks that throw on error
1267  */
1268 library SafeMath {
1269 
1270   /**
1271   * @dev Multiplies two numbers, throws on overflow.
1272   */
1273   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1274     if (a == 0) {
1275       return 0;
1276     }
1277     uint256 c = a * b;
1278     assert(c / a == b);
1279     return c;
1280   }
1281 
1282   /**
1283   * @dev Integer division of two numbers, truncating the quotient.
1284   */
1285   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1286     // assert(b > 0); // Solidity automatically throws when dividing by 0
1287     // uint256 c = a / b;
1288     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1289     return a / b;
1290   }
1291 
1292   /**
1293   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1294   */
1295   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1296     assert(b <= a);
1297     return a - b;
1298   }
1299 
1300   /**
1301   * @dev Adds two numbers, throws on overflow.
1302   */
1303   function add(uint256 a, uint256 b) internal pure returns (uint256) {
1304     uint256 c = a + b;
1305     assert(c >= a);
1306     return c;
1307   }
1308 }
1309 
1310 contract Dice is usingOraclize, Ownable {
1311   using SafeMath for uint256;
1312 
1313   uint256 constant INVALID_ROLL = 0;
1314 
1315   // Depends on slider
1316   uint256 constant MIN_ROLL = 1;
1317   uint256 constant MAX_ROLL = 100;
1318   bytes32 constant DEFAULT_BYTES32 = 0x0000000000000000000000000000000000000000000000000000000000000000;
1319 
1320   // This governs how much gas we'll have for the oraclize callback
1321   uint256 constant ORACLIZE_GAS_COST = 500000;
1322 
1323   // Tuneable by admin
1324   uint256 public maxBet = 0.5 ether;
1325 
1326   struct GameData {
1327     address player;
1328     uint256 odds; // represents the roll under which all winning rolls must lie
1329     uint256 wager;
1330     uint256 trueWager;
1331     uint256 roll; // only populated when game is complete
1332     uint256 maxProfit; // max profit calculated at roll time
1333   }
1334 
1335   mapping(bytes32 => GameData) _queryToGameData;
1336 
1337   // For display purposes only
1338   uint256 public completedGames = 0;
1339 
1340   event RollCompleted(
1341     address indexed player,
1342     uint256 wager,
1343     uint256 trueWager,
1344     uint256 odds,
1345     uint256 roll,
1346     uint256 totalPayout
1347   );
1348 
1349   event RollSubmitted(
1350     address indexed player,
1351     uint256 odds,
1352     uint256 trueWager
1353   );
1354 
1355   event PlayerPaidOut(
1356     address indexed player,
1357     uint256 payout
1358   );
1359 
1360   constructor() public {}
1361 
1362   ////////////////
1363   // ADMIN ACTIONS
1364   ////////////////
1365 
1366   function withdrawBalance() external onlyOwner {
1367     uint256 balance = address(this).balance;
1368 
1369     // No withdrawal necessary if <= 0 balance
1370     require(balance > 0);
1371 
1372     msg.sender.transfer(balance);
1373   }
1374 
1375   function addBalance() external payable {}
1376 
1377   function setMaxBet(uint256 newMax) external onlyOwner {
1378     maxBet = newMax;
1379   }
1380 
1381   ///////////////
1382   // USER ACTIONS
1383   ///////////////
1384 
1385   // NOTE: Currently 5% of contract balance. Can be tuned
1386   function getMaxProfit() public view returns(uint256) {
1387     return address(this).balance / 20;
1388   }
1389 
1390   function rollDice(uint256 odds) external payable {
1391     // Cannot send a bet along > maxBet
1392     require(msg.value <= maxBet);
1393 
1394     uint256 queryPrice = oraclize_getPrice("URL");
1395 
1396     // player's wager
1397     require(msg.value > queryPrice);
1398     uint256 wagerAfterQuery = msg.value.sub(queryPrice);
1399     uint256 fee = _computeRollFee(wagerAfterQuery);
1400     uint256 trueWager = wagerAfterQuery.sub(fee);
1401 
1402     // NOTE: Can probably simplify this to something static
1403     string memory queryStr = _getQueryStr(MIN_ROLL, MAX_ROLL);
1404 
1405     // TODO: When we need to encrypt random.org encryption key, this will need to become a 'nested' query
1406     bytes32 qId = oraclize_query("URL", queryStr, ORACLIZE_GAS_COST);
1407 
1408     emit RollSubmitted(msg.sender, odds, trueWager);
1409 
1410     _queryToGameData[qId] = GameData(
1411       msg.sender,
1412       odds,
1413       msg.value,
1414       trueWager,
1415       INVALID_ROLL,
1416       getMaxProfit()
1417     );
1418   }
1419 
1420   // NOTE: 1%, can be modified!
1421   function _computeRollFee(uint256 wagerAfterQuery) private pure returns (uint256) {
1422     return SafeMath.div(wagerAfterQuery, 100);
1423   }
1424 
1425   // NOTE: Doesn't use API key so that we don't have to do all the fancy encryption stuff.
1426   function _getQueryStr(uint256 min, uint256 max) internal returns(string) {
1427     return strConcat("https://www.random.org/integers/?num=1&min=", uint2str(min), "&max=", uint2str(max), "&col=1&base=10&format=plain&rnd=new");
1428   }
1429 
1430   function __callback(bytes32 qId, string result, bytes proof) public {
1431     // Must be called by oraclize
1432     require(msg.sender == oraclize_cbAddress());
1433 
1434     GameData memory game = _queryToGameData[qId];
1435 
1436     // Game must not already have a roll associated with it
1437     require(game.roll == INVALID_ROLL);
1438 
1439     // Payout player
1440     uint256 roll = _resultToRoll(result);
1441     uint256 payout = _calculatePayout(qId, roll);
1442     address player = game.player;
1443     if (payout > 0) {
1444       player.transfer(payout);
1445       emit PlayerPaidOut(player, payout);
1446     }
1447 
1448     // TODO: Delete game in the future to save space
1449     game.roll = roll;
1450 
1451     // game completed!
1452     completedGames = completedGames.add(1);
1453     emit RollCompleted(player, game.wager, game.trueWager, game.odds, roll, payout);
1454   }
1455 
1456   function _calculatePayout(bytes32 qId, uint256 roll) internal view returns(uint256) {
1457     GameData memory game = _queryToGameData[qId];
1458 
1459     uint256 odds = game.odds;
1460     if (roll >= odds) {
1461       return 0;
1462     } else {
1463       uint256 wager = game.trueWager;
1464       uint256 maxProfit = game.maxProfit;
1465 
1466       // payout = wager + winningsMultiple * wager
1467       // winnings = (100 - x) / x
1468       uint256 probabilityOdds = odds.sub(1);
1469       uint256 invOdds = MAX_ROLL.sub(probabilityOdds);
1470       uint256 winnings = wager.mul(invOdds).div(probabilityOdds);
1471       uint256 defaultWinnings = wager.add(winnings);
1472 
1473       uint256 availableBalance = _getAvailableBalance() ;
1474       if (defaultWinnings > availableBalance) {
1475         return availableBalance;
1476       }
1477 
1478       else if (winnings > maxProfit) {
1479         return wager.add(maxProfit);
1480       }
1481 
1482       else {
1483         return defaultWinnings;
1484       }
1485     }
1486   }
1487 
1488   // NOTE: Set to less than total balance so contract balance can't ever be drained
1489   function _getAvailableBalance() internal returns(uint256) {
1490     return address(this).balance;
1491   }
1492 
1493   function _resultToRoll(string result) internal returns(uint256) {
1494     return parseInt(result);
1495   }
1496 }