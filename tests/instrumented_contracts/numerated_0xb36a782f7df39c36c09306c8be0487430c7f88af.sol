1 pragma solidity ^0.4.18;
2 
3 // <ORACLIZE_API>
4 /*
5 Copyright (c) 2015-2016 Oraclize SRL
6 Copyright (c) 2016 Oraclize LTD
7 
8 
9 
10 Permission is hereby granted, free of charge, to any person obtaining a copy
11 of this software and associated documentation files (the "Software"), to deal
12 in the Software without restriction, including without limitation the rights
13 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
14 copies of the Software, and to permit persons to whom the Software is
15 furnished to do so, subject to the following conditions:
16 
17 
18 
19 The above copyright notice and this permission notice shall be included in
20 all copies or substantial portions of the Software.
21 
22 
23 
24 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
25 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
26 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
27 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
28 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
29 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
30 THE SOFTWARE.
31 */
32 
33 pragma solidity >= 0.4.1 < 0.5;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
34 
35 contract OraclizeI {
36     address public cbAddress;
37     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
38     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
39     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
40     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
41     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
42     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
43     function getPrice(string _datasource) returns (uint _dsprice);
44     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
45     function useCoupon(string _coupon);
46     function setProofType(byte _proofType);
47     function setConfig(bytes32 _config);
48     function setCustomGasPrice(uint _gasPrice);
49     function randomDS_getSessionPubKeyHash() returns(bytes32);
50 }
51 
52 contract OraclizeAddrResolverI {
53     function getAddress() returns (address _addr);
54 }
55 
56 /*
57 Begin solidity-cborutils
58 
59 https://github.com/smartcontractkit/solidity-cborutils
60 
61 MIT License
62 
63 Copyright (c) 2018 SmartContract ChainLink, Ltd.
64 
65 Permission is hereby granted, free of charge, to any person obtaining a copy
66 of this software and associated documentation files (the "Software"), to deal
67 in the Software without restriction, including without limitation the rights
68 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
69 copies of the Software, and to permit persons to whom the Software is
70 furnished to do so, subject to the following conditions:
71 
72 The above copyright notice and this permission notice shall be included in all
73 copies or substantial portions of the Software.
74 
75 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
76 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
77 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
78 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
79 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
80 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
81 SOFTWARE.
82  */
83 
84 library Buffer {
85     struct buffer {
86         bytes buf;
87         uint capacity;
88     }
89 
90     function init(buffer memory buf, uint _capacity) internal constant {
91         uint capacity = _capacity;
92         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
93         // Allocate space for the buffer data
94         buf.capacity = capacity;
95         assembly {
96             let ptr := mload(0x40)
97             mstore(buf, ptr)
98             mstore(ptr, 0)
99             mstore(0x40, add(ptr, capacity))
100         }
101     }
102 
103     function resize(buffer memory buf, uint capacity) private constant {
104         bytes memory oldbuf = buf.buf;
105         init(buf, capacity);
106         append(buf, oldbuf);
107     }
108 
109     function max(uint a, uint b) private constant returns(uint) {
110         if(a > b) {
111             return a;
112         }
113         return b;
114     }
115 
116     /**
117      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
118      *      would exceed the capacity of the buffer.
119      * @param buf The buffer to append to.
120      * @param data The data to append.
121      * @return The original buffer.
122      */
123     function append(buffer memory buf, bytes data) internal constant returns(buffer memory) {
124         if(data.length + buf.buf.length > buf.capacity) {
125             resize(buf, max(buf.capacity, data.length) * 2);
126         }
127 
128         uint dest;
129         uint src;
130         uint len = data.length;
131         assembly {
132             // Memory address of the buffer data
133             let bufptr := mload(buf)
134             // Length of existing buffer data
135             let buflen := mload(bufptr)
136             // Start address = buffer address + buffer length + sizeof(buffer length)
137             dest := add(add(bufptr, buflen), 32)
138             // Update buffer length
139             mstore(bufptr, add(buflen, mload(data)))
140             src := add(data, 32)
141         }
142 
143         // Copy word-length chunks while possible
144         for(; len >= 32; len -= 32) {
145             assembly {
146                 mstore(dest, mload(src))
147             }
148             dest += 32;
149             src += 32;
150         }
151 
152         // Copy remaining bytes
153         uint mask = 256 ** (32 - len) - 1;
154         assembly {
155             let srcpart := and(mload(src), not(mask))
156             let destpart := and(mload(dest), mask)
157             mstore(dest, or(destpart, srcpart))
158         }
159 
160         return buf;
161     }
162 
163     /**
164      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
165      * exceed the capacity of the buffer.
166      * @param buf The buffer to append to.
167      * @param data The data to append.
168      * @return The original buffer.
169      */
170     function append(buffer memory buf, uint8 data) internal constant {
171         if(buf.buf.length + 1 > buf.capacity) {
172             resize(buf, buf.capacity * 2);
173         }
174 
175         assembly {
176             // Memory address of the buffer data
177             let bufptr := mload(buf)
178             // Length of existing buffer data
179             let buflen := mload(bufptr)
180             // Address = buffer address + buffer length + sizeof(buffer length)
181             let dest := add(add(bufptr, buflen), 32)
182             mstore8(dest, data)
183             // Update buffer length
184             mstore(bufptr, add(buflen, 1))
185         }
186     }
187 
188     /**
189      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
190      * exceed the capacity of the buffer.
191      * @param buf The buffer to append to.
192      * @param data The data to append.
193      * @return The original buffer.
194      */
195     function appendInt(buffer memory buf, uint data, uint len) internal constant returns(buffer memory) {
196         if(len + buf.buf.length > buf.capacity) {
197             resize(buf, max(buf.capacity, len) * 2);
198         }
199 
200         uint mask = 256 ** len - 1;
201         assembly {
202             // Memory address of the buffer data
203             let bufptr := mload(buf)
204             // Length of existing buffer data
205             let buflen := mload(bufptr)
206             // Address = buffer address + buffer length + sizeof(buffer length) + len
207             let dest := add(add(bufptr, buflen), len)
208             mstore(dest, or(and(mload(dest), not(mask)), data))
209             // Update buffer length
210             mstore(bufptr, add(buflen, len))
211         }
212         return buf;
213     }
214 }
215 
216 library CBOR {
217     using Buffer for Buffer.buffer;
218 
219     uint8 private constant MAJOR_TYPE_INT = 0;
220     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
221     uint8 private constant MAJOR_TYPE_BYTES = 2;
222     uint8 private constant MAJOR_TYPE_STRING = 3;
223     uint8 private constant MAJOR_TYPE_ARRAY = 4;
224     uint8 private constant MAJOR_TYPE_MAP = 5;
225     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
226 
227     function shl8(uint8 x, uint8 y) private constant returns (uint8) {
228         return x * (2 ** y);
229     }
230 
231     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private constant {
232         if(value <= 23) {
233             buf.append(uint8(shl8(major, 5) | value));
234         } else if(value <= 0xFF) {
235             buf.append(uint8(shl8(major, 5) | 24));
236             buf.appendInt(value, 1);
237         } else if(value <= 0xFFFF) {
238             buf.append(uint8(shl8(major, 5) | 25));
239             buf.appendInt(value, 2);
240         } else if(value <= 0xFFFFFFFF) {
241             buf.append(uint8(shl8(major, 5) | 26));
242             buf.appendInt(value, 4);
243         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
244             buf.append(uint8(shl8(major, 5) | 27));
245             buf.appendInt(value, 8);
246         }
247     }
248 
249     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private constant {
250         buf.append(uint8(shl8(major, 5) | 31));
251     }
252 
253     function encodeUInt(Buffer.buffer memory buf, uint value) internal constant {
254         encodeType(buf, MAJOR_TYPE_INT, value);
255     }
256 
257     function encodeInt(Buffer.buffer memory buf, int value) internal constant {
258         if(value >= 0) {
259             encodeType(buf, MAJOR_TYPE_INT, uint(value));
260         } else {
261             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
262         }
263     }
264 
265     function encodeBytes(Buffer.buffer memory buf, bytes value) internal constant {
266         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
267         buf.append(value);
268     }
269 
270     function encodeString(Buffer.buffer memory buf, string value) internal constant {
271         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
272         buf.append(bytes(value));
273     }
274 
275     function startArray(Buffer.buffer memory buf) internal constant {
276         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
277     }
278 
279     function startMap(Buffer.buffer memory buf) internal constant {
280         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
281     }
282 
283     function endSequence(Buffer.buffer memory buf) internal constant {
284         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
285     }
286 }
287 
288 /*
289 End solidity-cborutils
290  */
291 
292 contract usingOraclize {
293     uint constant day = 60*60*24;
294     uint constant week = 60*60*24*7;
295     uint constant month = 60*60*24*30;
296     byte constant proofType_NONE = 0x00;
297     byte constant proofType_TLSNotary = 0x10;
298     byte constant proofType_Ledger = 0x30;
299     byte constant proofType_Android = 0x40;
300     byte constant proofType_Native = 0xF0;
301     byte constant proofStorage_IPFS = 0x01;
302     uint8 constant networkID_auto = 0;
303     uint8 constant networkID_mainnet = 1;
304     uint8 constant networkID_testnet = 2;
305     uint8 constant networkID_morden = 2;
306     uint8 constant networkID_consensys = 161;
307 
308     OraclizeAddrResolverI OAR;
309 
310     OraclizeI oraclize;
311     modifier oraclizeAPI {
312         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
313             oraclize_setNetwork(networkID_auto);
314 
315         if(address(oraclize) != OAR.getAddress())
316             oraclize = OraclizeI(OAR.getAddress());
317 
318         _;
319     }
320     modifier coupon(string code){
321         oraclize = OraclizeI(OAR.getAddress());
322         oraclize.useCoupon(code);
323         _;
324     }
325 
326     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
327         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
328             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
329             oraclize_setNetworkName("eth_mainnet");
330             return true;
331         }
332         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
333             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
334             oraclize_setNetworkName("eth_ropsten3");
335             return true;
336         }
337         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
338             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
339             oraclize_setNetworkName("eth_kovan");
340             return true;
341         }
342         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
343             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
344             oraclize_setNetworkName("eth_rinkeby");
345             return true;
346         }
347         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
348             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
349             return true;
350         }
351         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
352             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
353             return true;
354         }
355         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
356             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
357             return true;
358         }
359         return false;
360     }
361 
362     function __callback(bytes32 myid, string result) {
363         __callback(myid, result, new bytes(0));
364     }
365     function __callback(bytes32 myid, string result, bytes proof) {
366     }
367 
368     function oraclize_useCoupon(string code) oraclizeAPI internal {
369         oraclize.useCoupon(code);
370     }
371 
372     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
373         return oraclize.getPrice(datasource);
374     }
375 
376     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
377         return oraclize.getPrice(datasource, gaslimit);
378     }
379 
380     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
381         uint price = oraclize.getPrice(datasource);
382         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
383         return oraclize.query.value(price)(0, datasource, arg);
384     }
385     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
386         uint price = oraclize.getPrice(datasource);
387         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
388         return oraclize.query.value(price)(timestamp, datasource, arg);
389     }
390     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
391         uint price = oraclize.getPrice(datasource, gaslimit);
392         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
393         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
394     }
395     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
396         uint price = oraclize.getPrice(datasource, gaslimit);
397         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
398         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
399     }
400     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
401         uint price = oraclize.getPrice(datasource);
402         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
403         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
404     }
405     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
406         uint price = oraclize.getPrice(datasource);
407         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
408         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
409     }
410     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
411         uint price = oraclize.getPrice(datasource, gaslimit);
412         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
413         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
414     }
415     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
416         uint price = oraclize.getPrice(datasource, gaslimit);
417         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
418         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
419     }
420     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
421         uint price = oraclize.getPrice(datasource);
422         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
423         bytes memory args = stra2cbor(argN);
424         return oraclize.queryN.value(price)(0, datasource, args);
425     }
426     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
427         uint price = oraclize.getPrice(datasource);
428         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
429         bytes memory args = stra2cbor(argN);
430         return oraclize.queryN.value(price)(timestamp, datasource, args);
431     }
432     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
433         uint price = oraclize.getPrice(datasource, gaslimit);
434         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
435         bytes memory args = stra2cbor(argN);
436         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
437     }
438     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
439         uint price = oraclize.getPrice(datasource, gaslimit);
440         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
441         bytes memory args = stra2cbor(argN);
442         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
443     }
444     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
445         string[] memory dynargs = new string[](1);
446         dynargs[0] = args[0];
447         return oraclize_query(datasource, dynargs);
448     }
449     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
450         string[] memory dynargs = new string[](1);
451         dynargs[0] = args[0];
452         return oraclize_query(timestamp, datasource, dynargs);
453     }
454     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
455         string[] memory dynargs = new string[](1);
456         dynargs[0] = args[0];
457         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
458     }
459     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
460         string[] memory dynargs = new string[](1);
461         dynargs[0] = args[0];
462         return oraclize_query(datasource, dynargs, gaslimit);
463     }
464 
465     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
466         string[] memory dynargs = new string[](2);
467         dynargs[0] = args[0];
468         dynargs[1] = args[1];
469         return oraclize_query(datasource, dynargs);
470     }
471     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
472         string[] memory dynargs = new string[](2);
473         dynargs[0] = args[0];
474         dynargs[1] = args[1];
475         return oraclize_query(timestamp, datasource, dynargs);
476     }
477     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
478         string[] memory dynargs = new string[](2);
479         dynargs[0] = args[0];
480         dynargs[1] = args[1];
481         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
482     }
483     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
484         string[] memory dynargs = new string[](2);
485         dynargs[0] = args[0];
486         dynargs[1] = args[1];
487         return oraclize_query(datasource, dynargs, gaslimit);
488     }
489     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
490         string[] memory dynargs = new string[](3);
491         dynargs[0] = args[0];
492         dynargs[1] = args[1];
493         dynargs[2] = args[2];
494         return oraclize_query(datasource, dynargs);
495     }
496     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
497         string[] memory dynargs = new string[](3);
498         dynargs[0] = args[0];
499         dynargs[1] = args[1];
500         dynargs[2] = args[2];
501         return oraclize_query(timestamp, datasource, dynargs);
502     }
503     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
504         string[] memory dynargs = new string[](3);
505         dynargs[0] = args[0];
506         dynargs[1] = args[1];
507         dynargs[2] = args[2];
508         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
509     }
510     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
511         string[] memory dynargs = new string[](3);
512         dynargs[0] = args[0];
513         dynargs[1] = args[1];
514         dynargs[2] = args[2];
515         return oraclize_query(datasource, dynargs, gaslimit);
516     }
517 
518     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
519         string[] memory dynargs = new string[](4);
520         dynargs[0] = args[0];
521         dynargs[1] = args[1];
522         dynargs[2] = args[2];
523         dynargs[3] = args[3];
524         return oraclize_query(datasource, dynargs);
525     }
526     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
527         string[] memory dynargs = new string[](4);
528         dynargs[0] = args[0];
529         dynargs[1] = args[1];
530         dynargs[2] = args[2];
531         dynargs[3] = args[3];
532         return oraclize_query(timestamp, datasource, dynargs);
533     }
534     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
535         string[] memory dynargs = new string[](4);
536         dynargs[0] = args[0];
537         dynargs[1] = args[1];
538         dynargs[2] = args[2];
539         dynargs[3] = args[3];
540         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
541     }
542     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
543         string[] memory dynargs = new string[](4);
544         dynargs[0] = args[0];
545         dynargs[1] = args[1];
546         dynargs[2] = args[2];
547         dynargs[3] = args[3];
548         return oraclize_query(datasource, dynargs, gaslimit);
549     }
550     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
551         string[] memory dynargs = new string[](5);
552         dynargs[0] = args[0];
553         dynargs[1] = args[1];
554         dynargs[2] = args[2];
555         dynargs[3] = args[3];
556         dynargs[4] = args[4];
557         return oraclize_query(datasource, dynargs);
558     }
559     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
560         string[] memory dynargs = new string[](5);
561         dynargs[0] = args[0];
562         dynargs[1] = args[1];
563         dynargs[2] = args[2];
564         dynargs[3] = args[3];
565         dynargs[4] = args[4];
566         return oraclize_query(timestamp, datasource, dynargs);
567     }
568     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
569         string[] memory dynargs = new string[](5);
570         dynargs[0] = args[0];
571         dynargs[1] = args[1];
572         dynargs[2] = args[2];
573         dynargs[3] = args[3];
574         dynargs[4] = args[4];
575         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
576     }
577     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
578         string[] memory dynargs = new string[](5);
579         dynargs[0] = args[0];
580         dynargs[1] = args[1];
581         dynargs[2] = args[2];
582         dynargs[3] = args[3];
583         dynargs[4] = args[4];
584         return oraclize_query(datasource, dynargs, gaslimit);
585     }
586     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
587         uint price = oraclize.getPrice(datasource);
588         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
589         bytes memory args = ba2cbor(argN);
590         return oraclize.queryN.value(price)(0, datasource, args);
591     }
592     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
593         uint price = oraclize.getPrice(datasource);
594         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
595         bytes memory args = ba2cbor(argN);
596         return oraclize.queryN.value(price)(timestamp, datasource, args);
597     }
598     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
599         uint price = oraclize.getPrice(datasource, gaslimit);
600         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
601         bytes memory args = ba2cbor(argN);
602         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
603     }
604     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
605         uint price = oraclize.getPrice(datasource, gaslimit);
606         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
607         bytes memory args = ba2cbor(argN);
608         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
609     }
610     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
611         bytes[] memory dynargs = new bytes[](1);
612         dynargs[0] = args[0];
613         return oraclize_query(datasource, dynargs);
614     }
615     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
616         bytes[] memory dynargs = new bytes[](1);
617         dynargs[0] = args[0];
618         return oraclize_query(timestamp, datasource, dynargs);
619     }
620     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
621         bytes[] memory dynargs = new bytes[](1);
622         dynargs[0] = args[0];
623         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
624     }
625     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
626         bytes[] memory dynargs = new bytes[](1);
627         dynargs[0] = args[0];
628         return oraclize_query(datasource, dynargs, gaslimit);
629     }
630 
631     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
632         bytes[] memory dynargs = new bytes[](2);
633         dynargs[0] = args[0];
634         dynargs[1] = args[1];
635         return oraclize_query(datasource, dynargs);
636     }
637     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
638         bytes[] memory dynargs = new bytes[](2);
639         dynargs[0] = args[0];
640         dynargs[1] = args[1];
641         return oraclize_query(timestamp, datasource, dynargs);
642     }
643     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
644         bytes[] memory dynargs = new bytes[](2);
645         dynargs[0] = args[0];
646         dynargs[1] = args[1];
647         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
648     }
649     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
650         bytes[] memory dynargs = new bytes[](2);
651         dynargs[0] = args[0];
652         dynargs[1] = args[1];
653         return oraclize_query(datasource, dynargs, gaslimit);
654     }
655     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
656         bytes[] memory dynargs = new bytes[](3);
657         dynargs[0] = args[0];
658         dynargs[1] = args[1];
659         dynargs[2] = args[2];
660         return oraclize_query(datasource, dynargs);
661     }
662     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
663         bytes[] memory dynargs = new bytes[](3);
664         dynargs[0] = args[0];
665         dynargs[1] = args[1];
666         dynargs[2] = args[2];
667         return oraclize_query(timestamp, datasource, dynargs);
668     }
669     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
670         bytes[] memory dynargs = new bytes[](3);
671         dynargs[0] = args[0];
672         dynargs[1] = args[1];
673         dynargs[2] = args[2];
674         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
675     }
676     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
677         bytes[] memory dynargs = new bytes[](3);
678         dynargs[0] = args[0];
679         dynargs[1] = args[1];
680         dynargs[2] = args[2];
681         return oraclize_query(datasource, dynargs, gaslimit);
682     }
683 
684     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
685         bytes[] memory dynargs = new bytes[](4);
686         dynargs[0] = args[0];
687         dynargs[1] = args[1];
688         dynargs[2] = args[2];
689         dynargs[3] = args[3];
690         return oraclize_query(datasource, dynargs);
691     }
692     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
693         bytes[] memory dynargs = new bytes[](4);
694         dynargs[0] = args[0];
695         dynargs[1] = args[1];
696         dynargs[2] = args[2];
697         dynargs[3] = args[3];
698         return oraclize_query(timestamp, datasource, dynargs);
699     }
700     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
701         bytes[] memory dynargs = new bytes[](4);
702         dynargs[0] = args[0];
703         dynargs[1] = args[1];
704         dynargs[2] = args[2];
705         dynargs[3] = args[3];
706         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
707     }
708     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
709         bytes[] memory dynargs = new bytes[](4);
710         dynargs[0] = args[0];
711         dynargs[1] = args[1];
712         dynargs[2] = args[2];
713         dynargs[3] = args[3];
714         return oraclize_query(datasource, dynargs, gaslimit);
715     }
716     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
717         bytes[] memory dynargs = new bytes[](5);
718         dynargs[0] = args[0];
719         dynargs[1] = args[1];
720         dynargs[2] = args[2];
721         dynargs[3] = args[3];
722         dynargs[4] = args[4];
723         return oraclize_query(datasource, dynargs);
724     }
725     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
726         bytes[] memory dynargs = new bytes[](5);
727         dynargs[0] = args[0];
728         dynargs[1] = args[1];
729         dynargs[2] = args[2];
730         dynargs[3] = args[3];
731         dynargs[4] = args[4];
732         return oraclize_query(timestamp, datasource, dynargs);
733     }
734     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
735         bytes[] memory dynargs = new bytes[](5);
736         dynargs[0] = args[0];
737         dynargs[1] = args[1];
738         dynargs[2] = args[2];
739         dynargs[3] = args[3];
740         dynargs[4] = args[4];
741         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
742     }
743     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
744         bytes[] memory dynargs = new bytes[](5);
745         dynargs[0] = args[0];
746         dynargs[1] = args[1];
747         dynargs[2] = args[2];
748         dynargs[3] = args[3];
749         dynargs[4] = args[4];
750         return oraclize_query(datasource, dynargs, gaslimit);
751     }
752 
753     function oraclize_cbAddress() oraclizeAPI internal returns (address){
754         return oraclize.cbAddress();
755     }
756     function oraclize_setProof(byte proofP) oraclizeAPI internal {
757         return oraclize.setProofType(proofP);
758     }
759     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
760         return oraclize.setCustomGasPrice(gasPrice);
761     }
762     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
763         return oraclize.setConfig(config);
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
776     function parseAddr(string _a) internal returns (address){
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
796     function strCompare(string _a, string _b) internal returns (int) {
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
814     function indexOf(string _haystack, string _needle) internal returns (int) {
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
841     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
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
858     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
859         return strConcat(_a, _b, _c, _d, "");
860     }
861 
862     function strConcat(string _a, string _b, string _c) internal returns (string) {
863         return strConcat(_a, _b, _c, "", "");
864     }
865 
866     function strConcat(string _a, string _b) internal returns (string) {
867         return strConcat(_a, _b, "", "", "");
868     }
869 
870     // parseInt
871     function parseInt(string _a) internal returns (uint) {
872         return parseInt(_a, 0);
873     }
874 
875     // parseInt(parseFloat*10^_b)
876     function parseInt(string _a, uint _b) internal returns (uint) {
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
894     function uint2str(uint i) internal returns (string){
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
912     function stra2cbor(string[] arr) internal constant returns (bytes) {
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
924     function ba2cbor(bytes[] arr) internal constant returns (bytes) {
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
941     function oraclize_getNetworkName() internal returns (string) {
942         return oraclize_network_name;
943     }
944 
945     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
946         if ((_nbytes == 0)||(_nbytes > 32)) throw;
947     // Convert from seconds to ledger timer ticks
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
989         oraclize_randomDS_setCommitment(queryId, sha3(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
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
1021         if (address(sha3(pubkey)) == signer) return true;
1022         else {
1023             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1024             return (address(sha3(pubkey)) == signer);
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
1039         tosign2[0] = 1; //role
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
1065         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
1066 
1067         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1068         if (proofVerified == false) throw;
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
1083     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
1084         bool match_ = true;
1085 
1086     if (prefix.length != n_random_bytes) throw;
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
1101         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
1102 
1103         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1104         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1105 
1106         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1107         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1108 
1109         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1110         // This is to verify that the computed args match with the ones specified in the query.
1111         bytes memory commitmentSlice1 = new bytes(8+1+32);
1112         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1113 
1114         bytes memory sessionPubkey = new bytes(64);
1115         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1116         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1117 
1118         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1119         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
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
1137 
1138     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1139     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1140         uint minLength = length + toOffset;
1141 
1142         if (to.length < minLength) {
1143             // Buffer too small
1144             throw; // Should be a better way?
1145         }
1146 
1147         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1148         uint i = 32 + fromOffset;
1149         uint j = 32 + toOffset;
1150 
1151         while (i < (32 + fromOffset + length)) {
1152             assembly {
1153                 let tmp := mload(add(from, i))
1154                 mstore(add(to, j), tmp)
1155             }
1156             i += 32;
1157             j += 32;
1158         }
1159 
1160         return to;
1161     }
1162 
1163     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1164     // Duplicate Solidity's ecrecover, but catching the CALL return value
1165     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1166         // We do our own memory management here. Solidity uses memory offset
1167         // 0x40 to store the current end of memory. We write past it (as
1168         // writes are memory extensions), but don't update the offset so
1169         // Solidity will reuse it. The memory used here is only needed for
1170         // this context.
1171 
1172         // FIXME: inline assembly can't access return values
1173         bool ret;
1174         address addr;
1175 
1176         assembly {
1177             let size := mload(0x40)
1178             mstore(size, hash)
1179             mstore(add(size, 32), v)
1180             mstore(add(size, 64), r)
1181             mstore(add(size, 96), s)
1182 
1183             // NOTE: we can reuse the request memory because we deal with
1184             //       the return code
1185             ret := call(3000, 1, 0, size, 128, size, 32)
1186             addr := mload(size)
1187         }
1188 
1189         return (ret, addr);
1190     }
1191 
1192     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1193     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1194         bytes32 r;
1195         bytes32 s;
1196         uint8 v;
1197 
1198         if (sig.length != 65)
1199           return (false, 0);
1200 
1201         // The signature format is a compact form of:
1202         //   {bytes32 r}{bytes32 s}{uint8 v}
1203         // Compact means, uint8 is not padded to 32 bytes.
1204         assembly {
1205             r := mload(add(sig, 32))
1206             s := mload(add(sig, 64))
1207 
1208             // Here we are loading the last 32 bytes. We exploit the fact that
1209             // 'mload' will pad with zeroes if we overread.
1210             // There is no 'mload8' to do this, but that would be nicer.
1211             v := byte(0, mload(add(sig, 96)))
1212 
1213             // Alternative solution:
1214             // 'byte' is not working due to the Solidity parser, so lets
1215             // use the second best option, 'and'
1216             // v := and(mload(add(sig, 65)), 255)
1217         }
1218 
1219         // albeit non-transactional signatures are not specified by the YP, one would expect it
1220         // to match the YP range of [27, 28]
1221         //
1222         // geth uses [0, 1] and some clients have followed. This might change, see:
1223         //  https://github.com/ethereum/go-ethereum/issues/2053
1224         if (v < 27)
1225           v += 27;
1226 
1227         if (v != 27 && v != 28)
1228             return (false, 0);
1229 
1230         return safer_ecrecover(hash, v, r, s);
1231     }
1232 
1233     function safeMemoryCleaner() internal constant {
1234         assembly {
1235             let fmem := mload(0x40)
1236             codecopy(fmem, codesize, sub(msize, fmem))
1237         }
1238     }
1239 }
1240 // </ORACLIZE_API>
1241 /*
1242  * @title String & slice utility library for Solidity contracts.
1243  * @author Nick Johnson <arachnid@notdot.net>
1244  *
1245  * @dev Functionality in this library is largely implemented using an
1246  *      abstraction called a 'slice'. A slice represents a part of a string -
1247  *      anything from the entire string to a single character, or even no
1248  *      characters at all (a 0-length slice). Since a slice only has to specify
1249  *      an offset and a length, copying and manipulating slices is a lot less
1250  *      expensive than copying and manipulating the strings they reference.
1251  *
1252  *      To further reduce gas costs, most functions on slice that need to return
1253  *      a slice modify the original one instead of allocating a new one; for
1254  *      instance, `s.split(".")` will return the text up to the first '.',
1255  *      modifying s to only contain the remainder of the string after the '.'.
1256  *      In situations where you do not want to modify the original slice, you
1257  *      can make a copy first with `.copy()`, for example:
1258  *      `s.copy().split(".")`. Try and avoid using this idiom in loops; since
1259  *      Solidity has no memory management, it will result in allocating many
1260  *      short-lived slices that are later discarded.
1261  *
1262  *      Functions that return two slices come in two versions: a non-allocating
1263  *      version that takes the second slice as an argument, modifying it in
1264  *      place, and an allocating version that allocates and returns the second
1265  *      slice; see `nextRune` for example.
1266  *
1267  *      Functions that have to copy string data will return strings rather than
1268  *      slices; these can be cast back to slices for further processing if
1269  *      required.
1270  *
1271  *      For convenience, some functions are provided with non-modifying
1272  *      variants that create a new slice and return both; for instance,
1273  *      `s.splitNew('.')` leaves s unmodified, and returns two values
1274  *      corresponding to the left and right parts of the string.
1275  */
1276 
1277 pragma solidity ^0.4.14;
1278 
1279 library strings {
1280     struct slice {
1281         uint _len;
1282         uint _ptr;
1283     }
1284 
1285     function memcpy(uint dest, uint src, uint len) private pure {
1286         // Copy word-length chunks while possible
1287         for(; len >= 32; len -= 32) {
1288             assembly {
1289                 mstore(dest, mload(src))
1290             }
1291             dest += 32;
1292             src += 32;
1293         }
1294 
1295         // Copy remaining bytes
1296         uint mask = 256 ** (32 - len) - 1;
1297         assembly {
1298             let srcpart := and(mload(src), not(mask))
1299             let destpart := and(mload(dest), mask)
1300             mstore(dest, or(destpart, srcpart))
1301         }
1302     }
1303 
1304     /*
1305      * @dev Returns a slice containing the entire string.
1306      * @param self The string to make a slice from.
1307      * @return A newly allocated slice containing the entire string.
1308      */
1309     function toSlice(string memory self) internal pure returns (slice memory) {
1310         uint ptr;
1311         assembly {
1312             ptr := add(self, 0x20)
1313         }
1314         return slice(bytes(self).length, ptr);
1315     }
1316 
1317     /*
1318      * @dev Returns the length of a null-terminated bytes32 string.
1319      * @param self The value to find the length of.
1320      * @return The length of the string, from 0 to 32.
1321      */
1322     function len(bytes32 self) internal pure returns (uint) {
1323         uint ret;
1324         if (self == 0)
1325             return 0;
1326         if (self & 0xffffffffffffffffffffffffffffffff == 0) {
1327             ret += 16;
1328             self = bytes32(uint(self) / 0x100000000000000000000000000000000);
1329         }
1330         if (self & 0xffffffffffffffff == 0) {
1331             ret += 8;
1332             self = bytes32(uint(self) / 0x10000000000000000);
1333         }
1334         if (self & 0xffffffff == 0) {
1335             ret += 4;
1336             self = bytes32(uint(self) / 0x100000000);
1337         }
1338         if (self & 0xffff == 0) {
1339             ret += 2;
1340             self = bytes32(uint(self) / 0x10000);
1341         }
1342         if (self & 0xff == 0) {
1343             ret += 1;
1344         }
1345         return 32 - ret;
1346     }
1347 
1348     /*
1349      * @dev Returns a slice containing the entire bytes32, interpreted as a
1350      *      null-terminated utf-8 string.
1351      * @param self The bytes32 value to convert to a slice.
1352      * @return A new slice containing the value of the input argument up to the
1353      *         first null.
1354      */
1355     function toSliceB32(bytes32 self) internal pure returns (slice memory ret) {
1356         // Allocate space for `self` in memory, copy it there, and point ret at it
1357         assembly {
1358             let ptr := mload(0x40)
1359             mstore(0x40, add(ptr, 0x20))
1360             mstore(ptr, self)
1361             mstore(add(ret, 0x20), ptr)
1362         }
1363         ret._len = len(self);
1364     }
1365 
1366     /*
1367      * @dev Returns a new slice containing the same data as the current slice.
1368      * @param self The slice to copy.
1369      * @return A new slice containing the same data as `self`.
1370      */
1371     function copy(slice memory self) internal pure returns (slice memory) {
1372         return slice(self._len, self._ptr);
1373     }
1374 
1375     /*
1376      * @dev Copies a slice to a new string.
1377      * @param self The slice to copy.
1378      * @return A newly allocated string containing the slice's text.
1379      */
1380     function toString(slice memory self) internal pure returns (string memory) {
1381         string memory ret = new string(self._len);
1382         uint retptr;
1383         assembly { retptr := add(ret, 32) }
1384 
1385         memcpy(retptr, self._ptr, self._len);
1386         return ret;
1387     }
1388 
1389     /*
1390      * @dev Returns the length in runes of the slice. Note that this operation
1391      *      takes time proportional to the length of the slice; avoid using it
1392      *      in loops, and call `slice.empty()` if you only need to know whether
1393      *      the slice is empty or not.
1394      * @param self The slice to operate on.
1395      * @return The length of the slice in runes.
1396      */
1397     function len(slice memory self) internal pure returns (uint l) {
1398         // Starting at ptr-31 means the LSB will be the byte we care about
1399         uint ptr = self._ptr - 31;
1400         uint end = ptr + self._len;
1401         for (l = 0; ptr < end; l++) {
1402             uint8 b;
1403             assembly { b := and(mload(ptr), 0xFF) }
1404             if (b < 0x80) {
1405                 ptr += 1;
1406             } else if(b < 0xE0) {
1407                 ptr += 2;
1408             } else if(b < 0xF0) {
1409                 ptr += 3;
1410             } else if(b < 0xF8) {
1411                 ptr += 4;
1412             } else if(b < 0xFC) {
1413                 ptr += 5;
1414             } else {
1415                 ptr += 6;
1416             }
1417         }
1418     }
1419 
1420     /*
1421      * @dev Returns true if the slice is empty (has a length of 0).
1422      * @param self The slice to operate on.
1423      * @return True if the slice is empty, False otherwise.
1424      */
1425     function empty(slice memory self) internal pure returns (bool) {
1426         return self._len == 0;
1427     }
1428 
1429     /*
1430      * @dev Returns a positive number if `other` comes lexicographically after
1431      *      `self`, a negative number if it comes before, or zero if the
1432      *      contents of the two slices are equal. Comparison is done per-rune,
1433      *      on unicode codepoints.
1434      * @param self The first slice to compare.
1435      * @param other The second slice to compare.
1436      * @return The result of the comparison.
1437      */
1438     function compare(slice memory self, slice memory other) internal pure returns (int) {
1439         uint shortest = self._len;
1440         if (other._len < self._len)
1441             shortest = other._len;
1442 
1443         uint selfptr = self._ptr;
1444         uint otherptr = other._ptr;
1445         for (uint idx = 0; idx < shortest; idx += 32) {
1446             uint a;
1447             uint b;
1448             assembly {
1449                 a := mload(selfptr)
1450                 b := mload(otherptr)
1451             }
1452             if (a != b) {
1453                 // Mask out irrelevant bytes and check again
1454                 uint256 mask = uint256(-1); // 0xffff...
1455                 if(shortest < 32) {
1456                   mask = ~(2 ** (8 * (32 - shortest + idx)) - 1);
1457                 }
1458                 uint256 diff = (a & mask) - (b & mask);
1459                 if (diff != 0)
1460                     return int(diff);
1461             }
1462             selfptr += 32;
1463             otherptr += 32;
1464         }
1465         return int(self._len) - int(other._len);
1466     }
1467 
1468     /*
1469      * @dev Returns true if the two slices contain the same text.
1470      * @param self The first slice to compare.
1471      * @param self The second slice to compare.
1472      * @return True if the slices are equal, false otherwise.
1473      */
1474     function equals(slice memory self, slice memory other) internal pure returns (bool) {
1475         return compare(self, other) == 0;
1476     }
1477 
1478     /*
1479      * @dev Extracts the first rune in the slice into `rune`, advancing the
1480      *      slice to point to the next rune and returning `self`.
1481      * @param self The slice to operate on.
1482      * @param rune The slice that will contain the first rune.
1483      * @return `rune`.
1484      */
1485     function nextRune(slice memory self, slice memory rune) internal pure returns (slice memory) {
1486         rune._ptr = self._ptr;
1487 
1488         if (self._len == 0) {
1489             rune._len = 0;
1490             return rune;
1491         }
1492 
1493         uint l;
1494         uint b;
1495         // Load the first byte of the rune into the LSBs of b
1496         assembly { b := and(mload(sub(mload(add(self, 32)), 31)), 0xFF) }
1497         if (b < 0x80) {
1498             l = 1;
1499         } else if(b < 0xE0) {
1500             l = 2;
1501         } else if(b < 0xF0) {
1502             l = 3;
1503         } else {
1504             l = 4;
1505         }
1506 
1507         // Check for truncated codepoints
1508         if (l > self._len) {
1509             rune._len = self._len;
1510             self._ptr += self._len;
1511             self._len = 0;
1512             return rune;
1513         }
1514 
1515         self._ptr += l;
1516         self._len -= l;
1517         rune._len = l;
1518         return rune;
1519     }
1520 
1521     /*
1522      * @dev Returns the first rune in the slice, advancing the slice to point
1523      *      to the next rune.
1524      * @param self The slice to operate on.
1525      * @return A slice containing only the first rune from `self`.
1526      */
1527     function nextRune(slice memory self) internal pure returns (slice memory ret) {
1528         nextRune(self, ret);
1529     }
1530 
1531     /*
1532      * @dev Returns the number of the first codepoint in the slice.
1533      * @param self The slice to operate on.
1534      * @return The number of the first codepoint in the slice.
1535      */
1536     function ord(slice memory self) internal pure returns (uint ret) {
1537         if (self._len == 0) {
1538             return 0;
1539         }
1540 
1541         uint word;
1542         uint length;
1543         uint divisor = 2 ** 248;
1544 
1545         // Load the rune into the MSBs of b
1546         assembly { word:= mload(mload(add(self, 32))) }
1547         uint b = word / divisor;
1548         if (b < 0x80) {
1549             ret = b;
1550             length = 1;
1551         } else if(b < 0xE0) {
1552             ret = b & 0x1F;
1553             length = 2;
1554         } else if(b < 0xF0) {
1555             ret = b & 0x0F;
1556             length = 3;
1557         } else {
1558             ret = b & 0x07;
1559             length = 4;
1560         }
1561 
1562         // Check for truncated codepoints
1563         if (length > self._len) {
1564             return 0;
1565         }
1566 
1567         for (uint i = 1; i < length; i++) {
1568             divisor = divisor / 256;
1569             b = (word / divisor) & 0xFF;
1570             if (b & 0xC0 != 0x80) {
1571                 // Invalid UTF-8 sequence
1572                 return 0;
1573             }
1574             ret = (ret * 64) | (b & 0x3F);
1575         }
1576 
1577         return ret;
1578     }
1579 
1580     /*
1581      * @dev Returns the keccak-256 hash of the slice.
1582      * @param self The slice to hash.
1583      * @return The hash of the slice.
1584      */
1585     function keccak(slice memory self) internal pure returns (bytes32 ret) {
1586         assembly {
1587             ret := keccak256(mload(add(self, 32)), mload(self))
1588         }
1589     }
1590 
1591     /*
1592      * @dev Returns true if `self` starts with `needle`.
1593      * @param self The slice to operate on.
1594      * @param needle The slice to search for.
1595      * @return True if the slice starts with the provided text, false otherwise.
1596      */
1597     function startsWith(slice memory self, slice memory needle) internal pure returns (bool) {
1598         if (self._len < needle._len) {
1599             return false;
1600         }
1601 
1602         if (self._ptr == needle._ptr) {
1603             return true;
1604         }
1605 
1606         bool equal;
1607         assembly {
1608             let length := mload(needle)
1609             let selfptr := mload(add(self, 0x20))
1610             let needleptr := mload(add(needle, 0x20))
1611             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1612         }
1613         return equal;
1614     }
1615 
1616     /*
1617      * @dev If `self` starts with `needle`, `needle` is removed from the
1618      *      beginning of `self`. Otherwise, `self` is unmodified.
1619      * @param self The slice to operate on.
1620      * @param needle The slice to search for.
1621      * @return `self`
1622      */
1623     function beyond(slice memory self, slice memory needle) internal pure returns (slice memory) {
1624         if (self._len < needle._len) {
1625             return self;
1626         }
1627 
1628         bool equal = true;
1629         if (self._ptr != needle._ptr) {
1630             assembly {
1631                 let length := mload(needle)
1632                 let selfptr := mload(add(self, 0x20))
1633                 let needleptr := mload(add(needle, 0x20))
1634                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1635             }
1636         }
1637 
1638         if (equal) {
1639             self._len -= needle._len;
1640             self._ptr += needle._len;
1641         }
1642 
1643         return self;
1644     }
1645 
1646     /*
1647      * @dev Returns true if the slice ends with `needle`.
1648      * @param self The slice to operate on.
1649      * @param needle The slice to search for.
1650      * @return True if the slice starts with the provided text, false otherwise.
1651      */
1652     function endsWith(slice memory self, slice memory needle) internal pure returns (bool) {
1653         if (self._len < needle._len) {
1654             return false;
1655         }
1656 
1657         uint selfptr = self._ptr + self._len - needle._len;
1658 
1659         if (selfptr == needle._ptr) {
1660             return true;
1661         }
1662 
1663         bool equal;
1664         assembly {
1665             let length := mload(needle)
1666             let needleptr := mload(add(needle, 0x20))
1667             equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1668         }
1669 
1670         return equal;
1671     }
1672 
1673     /*
1674      * @dev If `self` ends with `needle`, `needle` is removed from the
1675      *      end of `self`. Otherwise, `self` is unmodified.
1676      * @param self The slice to operate on.
1677      * @param needle The slice to search for.
1678      * @return `self`
1679      */
1680     function until(slice memory self, slice memory needle) internal pure returns (slice memory) {
1681         if (self._len < needle._len) {
1682             return self;
1683         }
1684 
1685         uint selfptr = self._ptr + self._len - needle._len;
1686         bool equal = true;
1687         if (selfptr != needle._ptr) {
1688             assembly {
1689                 let length := mload(needle)
1690                 let needleptr := mload(add(needle, 0x20))
1691                 equal := eq(keccak256(selfptr, length), keccak256(needleptr, length))
1692             }
1693         }
1694 
1695         if (equal) {
1696             self._len -= needle._len;
1697         }
1698 
1699         return self;
1700     }
1701 
1702     // Returns the memory address of the first byte of the first occurrence of
1703     // `needle` in `self`, or the first byte after `self` if not found.
1704     function findPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
1705         uint ptr = selfptr;
1706         uint idx;
1707 
1708         if (needlelen <= selflen) {
1709             if (needlelen <= 32) {
1710                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
1711 
1712                 bytes32 needledata;
1713                 assembly { needledata := and(mload(needleptr), mask) }
1714 
1715                 uint end = selfptr + selflen - needlelen;
1716                 bytes32 ptrdata;
1717                 assembly { ptrdata := and(mload(ptr), mask) }
1718 
1719                 while (ptrdata != needledata) {
1720                     if (ptr >= end)
1721                         return selfptr + selflen;
1722                     ptr++;
1723                     assembly { ptrdata := and(mload(ptr), mask) }
1724                 }
1725                 return ptr;
1726             } else {
1727                 // For long needles, use hashing
1728                 bytes32 hash;
1729                 assembly { hash := keccak256(needleptr, needlelen) }
1730 
1731                 for (idx = 0; idx <= selflen - needlelen; idx++) {
1732                     bytes32 testHash;
1733                     assembly { testHash := keccak256(ptr, needlelen) }
1734                     if (hash == testHash)
1735                         return ptr;
1736                     ptr += 1;
1737                 }
1738             }
1739         }
1740         return selfptr + selflen;
1741     }
1742 
1743     // Returns the memory address of the first byte after the last occurrence of
1744     // `needle` in `self`, or the address of `self` if not found.
1745     function rfindPtr(uint selflen, uint selfptr, uint needlelen, uint needleptr) private pure returns (uint) {
1746         uint ptr;
1747 
1748         if (needlelen <= selflen) {
1749             if (needlelen <= 32) {
1750                 bytes32 mask = bytes32(~(2 ** (8 * (32 - needlelen)) - 1));
1751 
1752                 bytes32 needledata;
1753                 assembly { needledata := and(mload(needleptr), mask) }
1754 
1755                 ptr = selfptr + selflen - needlelen;
1756                 bytes32 ptrdata;
1757                 assembly { ptrdata := and(mload(ptr), mask) }
1758 
1759                 while (ptrdata != needledata) {
1760                     if (ptr <= selfptr)
1761                         return selfptr;
1762                     ptr--;
1763                     assembly { ptrdata := and(mload(ptr), mask) }
1764                 }
1765                 return ptr + needlelen;
1766             } else {
1767                 // For long needles, use hashing
1768                 bytes32 hash;
1769                 assembly { hash := keccak256(needleptr, needlelen) }
1770                 ptr = selfptr + (selflen - needlelen);
1771                 while (ptr >= selfptr) {
1772                     bytes32 testHash;
1773                     assembly { testHash := keccak256(ptr, needlelen) }
1774                     if (hash == testHash)
1775                         return ptr + needlelen;
1776                     ptr -= 1;
1777                 }
1778             }
1779         }
1780         return selfptr;
1781     }
1782 
1783     /*
1784      * @dev Modifies `self` to contain everything from the first occurrence of
1785      *      `needle` to the end of the slice. `self` is set to the empty slice
1786      *      if `needle` is not found.
1787      * @param self The slice to search and modify.
1788      * @param needle The text to search for.
1789      * @return `self`.
1790      */
1791     function find(slice memory self, slice memory needle) internal pure returns (slice memory) {
1792         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1793         self._len -= ptr - self._ptr;
1794         self._ptr = ptr;
1795         return self;
1796     }
1797 
1798     /*
1799      * @dev Modifies `self` to contain the part of the string from the start of
1800      *      `self` to the end of the first occurrence of `needle`. If `needle`
1801      *      is not found, `self` is set to the empty slice.
1802      * @param self The slice to search and modify.
1803      * @param needle The text to search for.
1804      * @return `self`.
1805      */
1806     function rfind(slice memory self, slice memory needle) internal pure returns (slice memory) {
1807         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1808         self._len = ptr - self._ptr;
1809         return self;
1810     }
1811 
1812     /*
1813      * @dev Splits the slice, setting `self` to everything after the first
1814      *      occurrence of `needle`, and `token` to everything before it. If
1815      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1816      *      and `token` is set to the entirety of `self`.
1817      * @param self The slice to split.
1818      * @param needle The text to search for in `self`.
1819      * @param token An output parameter to which the first token is written.
1820      * @return `token`.
1821      */
1822     function split(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
1823         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr);
1824         token._ptr = self._ptr;
1825         token._len = ptr - self._ptr;
1826         if (ptr == self._ptr + self._len) {
1827             // Not found
1828             self._len = 0;
1829         } else {
1830             self._len -= token._len + needle._len;
1831             self._ptr = ptr + needle._len;
1832         }
1833         return token;
1834     }
1835 
1836     /*
1837      * @dev Splits the slice, setting `self` to everything after the first
1838      *      occurrence of `needle`, and returning everything before it. If
1839      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1840      *      and the entirety of `self` is returned.
1841      * @param self The slice to split.
1842      * @param needle The text to search for in `self`.
1843      * @return The part of `self` up to the first occurrence of `delim`.
1844      */
1845     function split(slice memory self, slice memory needle) internal pure returns (slice memory token) {
1846         split(self, needle, token);
1847     }
1848 
1849     /*
1850      * @dev Splits the slice, setting `self` to everything before the last
1851      *      occurrence of `needle`, and `token` to everything after it. If
1852      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1853      *      and `token` is set to the entirety of `self`.
1854      * @param self The slice to split.
1855      * @param needle The text to search for in `self`.
1856      * @param token An output parameter to which the first token is written.
1857      * @return `token`.
1858      */
1859     function rsplit(slice memory self, slice memory needle, slice memory token) internal pure returns (slice memory) {
1860         uint ptr = rfindPtr(self._len, self._ptr, needle._len, needle._ptr);
1861         token._ptr = ptr;
1862         token._len = self._len - (ptr - self._ptr);
1863         if (ptr == self._ptr) {
1864             // Not found
1865             self._len = 0;
1866         } else {
1867             self._len -= token._len + needle._len;
1868         }
1869         return token;
1870     }
1871 
1872     /*
1873      * @dev Splits the slice, setting `self` to everything before the last
1874      *      occurrence of `needle`, and returning everything after it. If
1875      *      `needle` does not occur in `self`, `self` is set to the empty slice,
1876      *      and the entirety of `self` is returned.
1877      * @param self The slice to split.
1878      * @param needle The text to search for in `self`.
1879      * @return The part of `self` after the last occurrence of `delim`.
1880      */
1881     function rsplit(slice memory self, slice memory needle) internal pure returns (slice memory token) {
1882         rsplit(self, needle, token);
1883     }
1884 
1885     /*
1886      * @dev Counts the number of nonoverlapping occurrences of `needle` in `self`.
1887      * @param self The slice to search.
1888      * @param needle The text to search for in `self`.
1889      * @return The number of occurrences of `needle` found in `self`.
1890      */
1891     function count(slice memory self, slice memory needle) internal pure returns (uint cnt) {
1892         uint ptr = findPtr(self._len, self._ptr, needle._len, needle._ptr) + needle._len;
1893         while (ptr <= self._ptr + self._len) {
1894             cnt++;
1895             ptr = findPtr(self._len - (ptr - self._ptr), ptr, needle._len, needle._ptr) + needle._len;
1896         }
1897     }
1898 
1899     /*
1900      * @dev Returns True if `self` contains `needle`.
1901      * @param self The slice to search.
1902      * @param needle The text to search for in `self`.
1903      * @return True if `needle` is found in `self`, false otherwise.
1904      */
1905     function contains(slice memory self, slice memory needle) internal pure returns (bool) {
1906         return rfindPtr(self._len, self._ptr, needle._len, needle._ptr) != self._ptr;
1907     }
1908 
1909     /*
1910      * @dev Returns a newly allocated string containing the concatenation of
1911      *      `self` and `other`.
1912      * @param self The first slice to concatenate.
1913      * @param other The second slice to concatenate.
1914      * @return The concatenation of the two strings.
1915      */
1916     function concat(slice memory self, slice memory other) internal pure returns (string memory) {
1917         string memory ret = new string(self._len + other._len);
1918         uint retptr;
1919         assembly { retptr := add(ret, 32) }
1920         memcpy(retptr, self._ptr, self._len);
1921         memcpy(retptr + self._len, other._ptr, other._len);
1922         return ret;
1923     }
1924 
1925     /*
1926      * @dev Joins an array of slices, using `self` as a delimiter, returning a
1927      *      newly allocated string.
1928      * @param self The delimiter to use.
1929      * @param parts A list of slices to join.
1930      * @return A newly allocated string containing all the slices in `parts`,
1931      *         joined with `self`.
1932      */
1933     function join(slice memory self, slice[] memory parts) internal pure returns (string memory) {
1934         if (parts.length == 0)
1935             return "";
1936 
1937         uint length = self._len * (parts.length - 1);
1938         for(uint i = 0; i < parts.length; i++)
1939             length += parts[i]._len;
1940 
1941         string memory ret = new string(length);
1942         uint retptr;
1943         assembly { retptr := add(ret, 32) }
1944 
1945         for(i = 0; i < parts.length; i++) {
1946             memcpy(retptr, parts[i]._ptr, parts[i]._len);
1947             retptr += parts[i]._len;
1948             if (i < parts.length - 1) {
1949                 memcpy(retptr, self._ptr, self._len);
1950                 retptr += self._len;
1951             }
1952         }
1953 
1954         return ret;
1955     }
1956 }
1957 pragma solidity ^0.4.18;
1958 
1959 
1960 
1961 contract DSSafeAddSub {
1962     function safeToAdd(uint a, uint b) internal pure  returns (bool) {
1963         return (a + b >= a);
1964     }
1965     function safeAdd(uint a, uint b) internal pure returns (uint) {
1966         if (!safeToAdd(a, b)) revert();
1967         return a + b;
1968     }
1969 
1970     function safeToSubtract(uint a, uint b) internal pure returns (bool) {
1971         return (b <= a);
1972     }
1973 
1974     function safeSub(uint a, uint b) internal pure returns (uint) {
1975         if (!safeToSubtract(a, b)) revert();
1976         return a - b;
1977     } 
1978 }
1979 
1980 contract Etheroll is usingOraclize, DSSafeAddSub {
1981     
1982      using strings for *;
1983 
1984     /*
1985      * checks player profit, bet size and player number is within range
1986     */
1987     modifier betIsValid(uint _betSize, uint _playerSize) {      
1988         if(((((_betSize * (10-_playerSize)) / _playerSize+_betSize))*houseEdge/houseEdgeDivisor)-_betSize > maxProfit || _betSize < minBet || _playerSize < minNumber || _playerSize > maxNumber) throw;        
1989         _;
1990     }
1991 
1992     /*
1993      * checks game is currently active
1994     */
1995     modifier gameIsActive {
1996         if(gamePaused == true) throw;
1997         _;
1998     }    
1999 
2000     /*
2001      * checks payouts are currently active
2002     */
2003     modifier payoutsAreActive {
2004         if(payoutsPaused == true) throw;
2005         _;
2006     }    
2007 
2008     /*
2009      * checks only Oraclize address is calling
2010     */
2011     modifier onlyOraclize {
2012         if (msg.sender != oraclize_cbAddress()) throw;
2013         _;
2014     }
2015 
2016     /*
2017      * checks only owner address is calling
2018     */
2019     modifier onlyOwner {
2020          if (msg.sender != owner) throw;
2021          _;
2022     }
2023 
2024     /*
2025      * checks only treasury address is calling
2026     */
2027     modifier onlyTreasury {
2028          if (msg.sender != treasury) throw;
2029          _;
2030     }    
2031 
2032     /*
2033      * game vars
2034     */ 
2035     uint constant public maxProfitDivisor = 1000000;
2036     uint constant public houseEdgeDivisor = 1000;    
2037     uint constant public maxNumber = 9; 
2038     uint constant public minNumber = 1;
2039     bool public gamePaused;
2040     uint32 public gasForOraclize;
2041     address public owner;
2042     bool public payoutsPaused; 
2043     address public treasury;
2044     uint public contractBalance;
2045     uint public houseEdge;
2046     uint public maxProfit;   
2047     uint public maxProfitAsPercentOfHouse;                    
2048     uint public minBet; 
2049     //init discontinued contract data       
2050     uint public totalBets = 0;
2051     uint public maxPendingPayouts;
2052     //init discontinued contract data   
2053     uint public totalWeiWon = 0;
2054     uint public totalWeiReturn = 0;
2055     //init discontinued contract data     
2056     uint public totalWeiWagered = 0; 
2057     uint public randomQueryID;
2058     string public fullurl;
2059     string public lastresult;
2060 
2061     /*
2062      * player vars
2063     */
2064     mapping (bytes32 => address) playerAddress;
2065     mapping (bytes32 => address) playerTempAddress;
2066     mapping (bytes32 => bytes32) playerBetId;
2067     mapping (bytes32 => uint) playerBetValue;
2068     mapping (bytes32 => uint) playerTempBetValue;               
2069     mapping (bytes32 => uint) playerDieResult;
2070     //mapping (bytes32 => uint) playerNumber;
2071     mapping (bytes32 => uint[]) playerNumbers;
2072     mapping (address => uint) playerPendingWithdrawals;      
2073     mapping (bytes32 => uint) playerProfit;
2074     mapping (bytes32 => uint) playerTempReward;           
2075 
2076     /*
2077      * events
2078     */
2079     /* log bets + output to web3 for precise 'payout on win' field in UI */
2080     event LogBet(bytes32 indexed BetID, address indexed PlayerAddress, uint indexed RewardValue, uint ProfitValue, uint BetValue, uint[] PlayerNumbers, uint RandomQueryID);      
2081     /* output to web3 UI on bet result*/
2082     /* Status: 0=lose, 1=win, 2=win + failed send, 3=refund, 4=refund + failed send*/
2083     event LogResult(uint indexed ResultSerialNumber, bytes32 indexed BetID, address indexed PlayerAddress, uint[] PlayerNumbers, uint DiceResult, uint Value, int Status, bytes Proof);   
2084     /* log manual refunds */
2085     event LogRefund(bytes32 indexed BetID, address indexed PlayerAddress, uint indexed RefundValue);
2086     /* log owner transfers */
2087     event LogOwnerTransfer(address indexed SentToAddress, uint indexed AmountTransferred);               
2088 
2089 
2090     /*
2091      * init
2092     */
2093     function Etheroll() {
2094 
2095         owner = msg.sender;
2096         treasury = msg.sender;
2097         oraclize_setNetwork(networkID_auto);        
2098         /* use TLSNotary for oraclize call */
2099         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
2100         /* init 990 = 99% (1% houseEdge)*/
2101         ownerSetHouseEdge(990);
2102         /* init 10,000 = 1%  */
2103         ownerSetMaxProfitAsPercentOfHouse(100000);
2104         /* init min bet (0.2 ether) */
2105         ownerSetMinBet(200000000000000000);        
2106         /* init gas for oraclize */        
2107         gasForOraclize = 235000;  
2108         /* init gas price for callback (default 15 gwei)*/
2109         oraclize_setCustomGasPrice(10000000000 wei);              
2110 
2111     }
2112 
2113     /*
2114      * public function
2115      * player submit bet
2116      * only if game is active & bet is valid can query oraclize and set player vars     
2117     */
2118     function playerRollDice(uint [] rollUnders) public 
2119         payable
2120         gameIsActive
2121         betIsValid(msg.value, rollUnders.length)
2122     {       
2123 
2124         /*
2125         * assign partially encrypted query to oraclize
2126         * only the apiKey is encrypted 
2127         * integer query is in plain text
2128         */       
2129         randomQueryID += 1;
2130         //"ef2b0f21-2540-4c3c-8d5e-589cf32798ca"}}
2131         string memory queryString1 = "[URL] ['json(https://api.random.org/json-rpc/1/invoke).result.random[\"serialNumber\", \"data\"]', '\\n{\"jsonrpc\":\"2.0\",\"method\":\"generateSignedIntegers\",\"id\":\"";
2132         
2133         string memory queryString2 = uint2str(randomQueryID);
2134         
2135         string memory queryString3 = "\",\"params\":{\"n\":\"1\",\"min\":1,\"max\":10,\"replacement\":true,\"base\":10,\"apiKey\":${[decrypt] BL/jeGhTwv6YbYUIlSe8hAkV3C7Y0gW1VCuF+6ElAf7T6p4HutwjJD+f2A2sce9G7lq7JNoGfSk+fdyOZj8VIiFnLiiqY89NqhVW5i3HmAmwbFCGfzGx+K46jYygXSKkb4TTSuTpGLoncDJomPlepWMgUGPH3pKdQg==}}']";
2136      
2137         string memory queryString1_2 = queryString1.toSlice().concat(queryString2.toSlice());
2138 
2139         string memory queryString1_2_3 = queryString1_2.toSlice().concat(queryString3.toSlice());
2140         
2141         fullurl = queryString1_2_3;
2142         bytes32 rngId = oraclize_query("nested", queryString1_2_3, gasForOraclize);  
2143         /* map bet id to this oraclize query */
2144         playerBetId[rngId] = rngId;
2145         /* map player lucky number to this oraclize query */
2146         playerNumbers[rngId] = rollUnders;
2147         /* map value of wager to this oraclize query */
2148         playerBetValue[rngId] = msg.value;
2149         /* map player address to this oraclize query */
2150         playerAddress[rngId] = msg.sender;
2151         /* safely map player profit to this oraclize query */                     
2152         playerProfit[rngId] = ((((msg.value * (10-rollUnders.length)) / rollUnders.length+msg.value))*houseEdge/houseEdgeDivisor)-msg.value;        
2153         /* safely increase maxPendingPayouts liability - calc all pending payouts under assumption they win */
2154         maxPendingPayouts = safeAdd(maxPendingPayouts, playerProfit[rngId]);
2155         /* check contract can payout on win */
2156         if(maxPendingPayouts >= contractBalance) throw;
2157         /* provides accurate numbers for web3 and allows for manual refunds in case of no oraclize __callback */
2158         LogBet(playerBetId[rngId], playerAddress[rngId], safeAdd(playerBetValue[rngId], playerProfit[rngId]), playerProfit[rngId], playerBetValue[rngId], playerNumbers[rngId], randomQueryID);          
2159 
2160     }   
2161 
2162     /*
2163     * semi-public function - only oraclize can call
2164     */
2165     /*TLSNotary for oraclize call */
2166     function __callback(bytes32 myid, string result, bytes proof) public   
2167         onlyOraclize
2168         payoutsAreActive
2169     {  
2170 
2171         lastresult = result;
2172         /* player address mapped to query id does not exist */
2173         if (playerAddress[myid]==0x0) throw;
2174         
2175         /* keep oraclize honest by retrieving the serialNumber from random.org result */
2176         var sl_result = result.toSlice();
2177         sl_result.beyond("[".toSlice()).until("]".toSlice());
2178         uint serialNumberOfResult = parseInt(sl_result.split(', '.toSlice()).toString());          
2179 
2180         playerDieResult[myid] = parseInt(sl_result.beyond("[".toSlice()).until("]".toSlice()).toString());        
2181         /* get the playerAddress for this query id */
2182         playerTempAddress[myid] = playerAddress[myid];
2183         /* delete playerAddress for this query id */
2184         delete playerAddress[myid];
2185 
2186         /* map the playerProfit for this query id */
2187         playerTempReward[myid] = playerProfit[myid];
2188         /* set  playerProfit for this query id to 0 */
2189         playerProfit[myid] = 0; 
2190 
2191         /* safely reduce maxPendingPayouts liability */
2192         maxPendingPayouts = safeSub(maxPendingPayouts, playerTempReward[myid]);         
2193 
2194         /* map the playerBetValue for this query id */
2195         playerTempBetValue[myid] = playerBetValue[myid];
2196         /* set  playerBetValue for this query id to 0 */
2197         playerBetValue[myid] = 0; 
2198 
2199         /* total number of bets */
2200         totalBets += 1;
2201 
2202         /* total wagered */
2203         totalWeiWagered += playerTempBetValue[myid];                                                           
2204 
2205         /*
2206         * refund
2207         * if result is 0 result is empty or no proof refund original bet value
2208         * if refund fails save refund value to playerPendingWithdrawals
2209         */
2210         if(playerDieResult[myid] == 0 || bytes(result).length == 0)
2211         // || bytes(proof).length == 0)
2212         {                                                     
2213 
2214              LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumbers[myid], playerDieResult[myid], playerTempBetValue[myid], 3, proof);            
2215 
2216             /*
2217             * send refund - external call to an untrusted contract
2218             * if send fails map refund value to playerPendingWithdrawals[address]
2219             * for withdrawal later via playerWithdrawPendingTransactions
2220             */
2221             if(!playerTempAddress[myid].send(playerTempBetValue[myid])){
2222                 LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumbers[myid], playerDieResult[myid], playerTempBetValue[myid], 4, proof);              
2223                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
2224                 playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], playerTempBetValue[myid]);                        
2225             }
2226 
2227             return;
2228         }
2229 
2230         /*
2231         * pay winner
2232         * update contract balance to calculate new max bet
2233         * send reward
2234         * if send of reward fails save value to playerPendingWithdrawals        
2235         */
2236         bool hitted=false;
2237         for(uint8 i=0;i<playerNumbers[myid].length;i++)
2238         {
2239             if(playerNumbers[myid][i] == playerDieResult[myid])
2240             {
2241                 hitted=true;
2242                 break;
2243             }
2244         }
2245         //if(playerDieResult[myid] < playerNumbers[myid][0])
2246         if(hitted)
2247         { 
2248 
2249             /* safely reduce contract balance by player profit */
2250             contractBalance = safeSub(contractBalance, playerTempReward[myid]); 
2251 
2252             /* update total wei won */
2253             totalWeiWon = safeAdd(totalWeiWon, playerTempReward[myid]);              
2254 
2255             /* safely calculate payout via profit plus original wager */
2256             playerTempReward[myid] = safeAdd(playerTempReward[myid], playerTempBetValue[myid]); 
2257 
2258             /* update total wei return */
2259             totalWeiReturn = safeAdd(totalWeiReturn, playerTempReward[myid]);
2260 
2261             LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumbers[myid], playerDieResult[myid], playerTempReward[myid], 1, proof);                            
2262 
2263             /* update maximum profit */
2264             setMaxProfit();
2265             
2266             /*
2267             * send win - external call to an untrusted contract
2268             * if send fails map reward value to playerPendingWithdrawals[address]
2269             * for withdrawal later via playerWithdrawPendingTransactions
2270             */
2271             if(!playerTempAddress[myid].send(playerTempReward[myid])){
2272                 LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumbers[myid], playerDieResult[myid], playerTempReward[myid], 2, proof);                   
2273                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */
2274                 playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], playerTempReward[myid]);                               
2275             }
2276 
2277             return;
2278 
2279         }
2280 
2281         /*
2282         * no win
2283         * send 1 wei to a losing bet
2284         * update contract balance to calculate new max bet
2285         */
2286         //if(playerDieResult[myid] >= playerNumbers[myid][0])
2287         else{
2288 
2289             LogResult(serialNumberOfResult, playerBetId[myid], playerTempAddress[myid], playerNumbers[myid], playerDieResult[myid], playerTempBetValue[myid], 0, proof);                                
2290 
2291             /*  
2292             *  safe adjust contractBalance
2293             *  setMaxProfit
2294             *  send 1 wei to losing bet
2295             */
2296             contractBalance = safeAdd(contractBalance, (playerTempBetValue[myid]-1));                                                                         
2297 
2298             /* update maximum profit */
2299             setMaxProfit(); 
2300 
2301             /*
2302             * send 1 wei - external call to an untrusted contract                  
2303             */
2304             if(!playerTempAddress[myid].send(1)){
2305                 /* if send failed let player withdraw via playerWithdrawPendingTransactions */                
2306                playerPendingWithdrawals[playerTempAddress[myid]] = safeAdd(playerPendingWithdrawals[playerTempAddress[myid]], 1);                                
2307             }                                   
2308 
2309             return;
2310 
2311         }
2312 
2313     }
2314     
2315     /*
2316     * public function
2317     * in case of a failed refund or win send
2318     */
2319     function playerWithdrawPendingTransactions() public 
2320         payoutsAreActive
2321         returns (bool)
2322      {
2323         uint withdrawAmount = playerPendingWithdrawals[msg.sender];
2324         playerPendingWithdrawals[msg.sender] = 0;
2325         /* external call to untrusted contract */
2326         if (msg.sender.call.value(withdrawAmount)()) {
2327             return true;
2328         } else {
2329             /* if send failed revert playerPendingWithdrawals[msg.sender] = 0; */
2330             /* player can try to withdraw again later */
2331             playerPendingWithdrawals[msg.sender] = withdrawAmount;
2332             return false;
2333         }
2334     }
2335 
2336     /* check for pending withdrawals  */
2337     function playerGetPendingTxByAddress(address addressToCheck) public constant returns (uint) {
2338         return playerPendingWithdrawals[addressToCheck];
2339     }
2340 
2341     /*
2342     * internal function
2343     * sets max profit
2344     */
2345     function setMaxProfit() internal {
2346         maxProfit = (contractBalance*maxProfitAsPercentOfHouse)/maxProfitDivisor;  
2347     }      
2348 
2349     /*
2350     * owner/treasury address only functions
2351     */
2352     function ()
2353         payable
2354         onlyTreasury
2355     {
2356         /* safely update contract balance */
2357         contractBalance = safeAdd(contractBalance, msg.value);        
2358         /* update the maximum profit */
2359         setMaxProfit();
2360     } 
2361 
2362     /* set gas price for oraclize callback */
2363     function ownerSetCallbackGasPrice(uint newCallbackGasPrice) public 
2364         onlyOwner
2365     {
2366         oraclize_setCustomGasPrice(newCallbackGasPrice);
2367     }     
2368 
2369     /* set gas limit for oraclize query */
2370     function ownerSetOraclizeSafeGas(uint32 newSafeGasToOraclize) public 
2371         onlyOwner
2372     {
2373         gasForOraclize = newSafeGasToOraclize;
2374     }
2375 
2376     /* only owner adjust contract balance variable (only used for max profit calc) */
2377     function ownerUpdateContractBalance(uint newContractBalanceInWei) public 
2378         onlyOwner
2379     {        
2380        contractBalance = newContractBalanceInWei;
2381     }    
2382 
2383     /* only owner address can set houseEdge */
2384     function ownerSetHouseEdge(uint newHouseEdge) public 
2385         onlyOwner
2386     {
2387         houseEdge = newHouseEdge;
2388     }
2389 
2390     /* only owner address can set maxProfitAsPercentOfHouse */
2391     function ownerSetMaxProfitAsPercentOfHouse(uint newMaxProfitAsPercent) public 
2392         onlyOwner
2393     {
2394         /* restrict each bet to a maximum profit of 1% contractBalance */
2395         if(newMaxProfitAsPercent > 900000) throw;
2396         maxProfitAsPercentOfHouse = newMaxProfitAsPercent;
2397         setMaxProfit();
2398     }
2399 
2400     /* only owner address can set minBet */
2401     function ownerSetMinBet(uint newMinimumBet) public 
2402         onlyOwner
2403     {
2404         minBet = newMinimumBet;
2405     }       
2406 
2407     /* only owner address can transfer ether */
2408     function ownerTransferEther(address sendTo, uint amount) public 
2409         onlyOwner
2410     {        
2411         /* safely update contract balance when sending out funds*/
2412         contractBalance = safeSub(contractBalance, amount);     
2413         /* update max profit */
2414         setMaxProfit();
2415         if(!sendTo.send(amount)) throw;
2416         LogOwnerTransfer(sendTo, amount); 
2417     }
2418     
2419     /* only owner address can transfer ether */
2420     function ownerTransferAllEther() public 
2421         onlyOwner
2422     {        
2423         /* safely update contract balance when sending out funds*/
2424         contractBalance = 0;//safeSub(contractBalance, this.balance);     
2425         /* update max profit */
2426         setMaxProfit();
2427         if(!owner.send(this.balance)) revert();
2428         LogOwnerTransfer(owner, this.balance); 
2429     }
2430 
2431     /* only owner address can do manual refund
2432     * used only if bet placed + oraclize failed to __callback
2433     * filter LogBet by address and/or playerBetId:
2434     * LogBet(playerBetId[rngId], playerAddress[rngId], safeAdd(playerBetValue[rngId], playerProfit[rngId]), playerProfit[rngId], playerBetValue[rngId], playerNumber[rngId]);
2435     * check the following logs do not exist for playerBetId and/or playerAddress[rngId] before refunding:
2436     * LogResult or LogRefund
2437     * if LogResult exists player should use the withdraw pattern playerWithdrawPendingTransactions 
2438     */
2439     function ownerRefundPlayer(bytes32 originalPlayerBetId, address sendTo, uint originalPlayerProfit, uint originalPlayerBetValue) public 
2440         onlyOwner
2441     {        
2442         /* safely reduce pendingPayouts by playerProfit[rngId] */
2443         maxPendingPayouts = safeSub(maxPendingPayouts, originalPlayerProfit);
2444         /* send refund */
2445         if(!sendTo.send(originalPlayerBetValue)) throw;
2446         /* log refunds */
2447         LogRefund(originalPlayerBetId, sendTo, originalPlayerBetValue);        
2448     }    
2449 
2450     /* only owner address can set emergency pause #1 */
2451     function ownerPauseGame(bool newStatus) public 
2452         onlyOwner
2453     {
2454         gamePaused = newStatus;
2455     }
2456 
2457     /* only owner address can set emergency pause #2 */
2458     function ownerPausePayouts(bool newPayoutStatus) public 
2459         onlyOwner
2460     {
2461         payoutsPaused = newPayoutStatus;
2462     } 
2463 
2464     /* only owner address can set treasury address */
2465     function ownerSetTreasury(address newTreasury) public 
2466         onlyOwner
2467     {
2468         treasury = newTreasury;
2469     }         
2470 
2471     /* only owner address can set owner address */
2472     function ownerChangeOwner(address newOwner) public 
2473         onlyOwner
2474     {
2475         owner = newOwner;
2476     }
2477 
2478     /* only owner address can suicide - emergency */
2479     function ownerkill() public 
2480         onlyOwner
2481     {
2482         suicide(owner);
2483     }    
2484 
2485 
2486 }