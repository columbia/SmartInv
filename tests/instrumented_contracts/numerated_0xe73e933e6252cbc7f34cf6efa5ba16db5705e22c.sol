1 pragma solidity ^0.4.21;
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
33 pragma solidity ^0.4.0;//please import oraclizeAPI_pre0.4.sol when solidity < 0.4.0
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
90     function init(buffer memory buf, uint capacity) internal pure {
91         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
92         // Allocate space for the buffer data
93         buf.capacity = capacity;
94         assembly {
95             let ptr := mload(0x40)
96             mstore(buf, ptr)
97             mstore(0x40, add(ptr, capacity))
98         }
99     }
100 
101     function resize(buffer memory buf, uint capacity) private pure {
102         bytes memory oldbuf = buf.buf;
103         init(buf, capacity);
104         append(buf, oldbuf);
105     }
106 
107     function max(uint a, uint b) private pure returns(uint) {
108         if(a > b) {
109             return a;
110         }
111         return b;
112     }
113 
114     /**
115      * @dev Appends a byte array to the end of the buffer. Reverts if doing so
116      *      would exceed the capacity of the buffer.
117      * @param buf The buffer to append to.
118      * @param data The data to append.
119      * @return The original buffer.
120      */
121     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
122         if(data.length + buf.buf.length > buf.capacity) {
123             resize(buf, max(buf.capacity, data.length) * 2);
124         }
125 
126         uint dest;
127         uint src;
128         uint len = data.length;
129         assembly {
130             // Memory address of the buffer data
131             let bufptr := mload(buf)
132             // Length of existing buffer data
133             let buflen := mload(bufptr)
134             // Start address = buffer address + buffer length + sizeof(buffer length)
135             dest := add(add(bufptr, buflen), 32)
136             // Update buffer length
137             mstore(bufptr, add(buflen, mload(data)))
138             src := add(data, 32)
139         }
140 
141         // Copy word-length chunks while possible
142         for(; len >= 32; len -= 32) {
143             assembly {
144                 mstore(dest, mload(src))
145             }
146             dest += 32;
147             src += 32;
148         }
149 
150         // Copy remaining bytes
151         uint mask = 256 ** (32 - len) - 1;
152         assembly {
153             let srcpart := and(mload(src), not(mask))
154             let destpart := and(mload(dest), mask)
155             mstore(dest, or(destpart, srcpart))
156         }
157 
158         return buf;
159     }
160 
161     /**
162      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
163      * exceed the capacity of the buffer.
164      * @param buf The buffer to append to.
165      * @param data The data to append.
166      * @return The original buffer.
167      */
168     function append(buffer memory buf, uint8 data) internal pure {
169         if(buf.buf.length + 1 > buf.capacity) {
170             resize(buf, buf.capacity * 2);
171         }
172 
173         assembly {
174             // Memory address of the buffer data
175             let bufptr := mload(buf)
176             // Length of existing buffer data
177             let buflen := mload(bufptr)
178             // Address = buffer address + buffer length + sizeof(buffer length)
179             let dest := add(add(bufptr, buflen), 32)
180             mstore8(dest, data)
181             // Update buffer length
182             mstore(bufptr, add(buflen, 1))
183         }
184     }
185 
186     /**
187      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
188      * exceed the capacity of the buffer.
189      * @param buf The buffer to append to.
190      * @param data The data to append.
191      * @return The original buffer.
192      */
193     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
194         if(len + buf.buf.length > buf.capacity) {
195             resize(buf, max(buf.capacity, len) * 2);
196         }
197 
198         uint mask = 256 ** len - 1;
199         assembly {
200             // Memory address of the buffer data
201             let bufptr := mload(buf)
202             // Length of existing buffer data
203             let buflen := mload(bufptr)
204             // Address = buffer address + buffer length + sizeof(buffer length) + len
205             let dest := add(add(bufptr, buflen), len)
206             mstore(dest, or(and(mload(dest), not(mask)), data))
207             // Update buffer length
208             mstore(bufptr, add(buflen, len))
209         }
210         return buf;
211     }
212 }
213 
214 library CBOR {
215     using Buffer for Buffer.buffer;
216 
217     uint8 private constant MAJOR_TYPE_INT = 0;
218     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
219     uint8 private constant MAJOR_TYPE_BYTES = 2;
220     uint8 private constant MAJOR_TYPE_STRING = 3;
221     uint8 private constant MAJOR_TYPE_ARRAY = 4;
222     uint8 private constant MAJOR_TYPE_MAP = 5;
223     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
224 
225     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
226         if(value <= 23) {
227             buf.append(uint8((major << 5) | value));
228         } else if(value <= 0xFF) {
229             buf.append(uint8((major << 5) | 24));
230             buf.appendInt(value, 1);
231         } else if(value <= 0xFFFF) {
232             buf.append(uint8((major << 5) | 25));
233             buf.appendInt(value, 2);
234         } else if(value <= 0xFFFFFFFF) {
235             buf.append(uint8((major << 5) | 26));
236             buf.appendInt(value, 4);
237         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
238             buf.append(uint8((major << 5) | 27));
239             buf.appendInt(value, 8);
240         }
241     }
242 
243     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
244         buf.append(uint8((major << 5) | 31));
245     }
246 
247     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
248         encodeType(buf, MAJOR_TYPE_INT, value);
249     }
250 
251     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
252         if(value >= 0) {
253             encodeType(buf, MAJOR_TYPE_INT, uint(value));
254         } else {
255             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
256         }
257     }
258 
259     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
260         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
261         buf.append(value);
262     }
263 
264     function encodeString(Buffer.buffer memory buf, string value) internal pure {
265         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
266         buf.append(bytes(value));
267     }
268 
269     function startArray(Buffer.buffer memory buf) internal pure {
270         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
271     }
272 
273     function startMap(Buffer.buffer memory buf) internal pure {
274         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
275     }
276 
277     function endSequence(Buffer.buffer memory buf) internal pure {
278         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
279     }
280 }
281 
282 /*
283 End solidity-cborutils
284  */
285 
286 contract usingOraclize {
287     uint constant day = 60*60*24;
288     uint constant week = 60*60*24*7;
289     uint constant month = 60*60*24*30;
290     byte constant proofType_NONE = 0x00;
291     byte constant proofType_TLSNotary = 0x10;
292     byte constant proofType_Android = 0x20;
293     byte constant proofType_Ledger = 0x30;
294     byte constant proofType_Native = 0xF0;
295     byte constant proofStorage_IPFS = 0x01;
296     uint8 constant networkID_auto = 0;
297     uint8 constant networkID_mainnet = 1;
298     uint8 constant networkID_testnet = 2;
299     uint8 constant networkID_morden = 2;
300     uint8 constant networkID_consensys = 161;
301 
302     OraclizeAddrResolverI OAR;
303 
304     OraclizeI oraclize;
305     modifier oraclizeAPI {
306         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
307             oraclize_setNetwork(networkID_auto);
308 
309         if(address(oraclize) != OAR.getAddress())
310             oraclize = OraclizeI(OAR.getAddress());
311 
312         _;
313     }
314     modifier coupon(string code){
315         oraclize = OraclizeI(OAR.getAddress());
316         oraclize.useCoupon(code);
317         _;
318     }
319 
320     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
321         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
322             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
323             oraclize_setNetworkName("eth_mainnet");
324             return true;
325         }
326         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
327             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
328             oraclize_setNetworkName("eth_ropsten3");
329             return true;
330         }
331         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
332             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
333             oraclize_setNetworkName("eth_kovan");
334             return true;
335         }
336         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
337             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
338             oraclize_setNetworkName("eth_rinkeby");
339             return true;
340         }
341         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
342             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
343             return true;
344         }
345         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
346             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
347             return true;
348         }
349         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
350             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
351             return true;
352         }
353         return false;
354     }
355 
356     function __callback(bytes32 myid, string result) {
357         __callback(myid, result, new bytes(0));
358     }
359     function __callback(bytes32 myid, string result, bytes proof) {
360     }
361 
362     function oraclize_useCoupon(string code) oraclizeAPI internal {
363         oraclize.useCoupon(code);
364     }
365 
366     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
367         return oraclize.getPrice(datasource);
368     }
369 
370     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
371         return oraclize.getPrice(datasource, gaslimit);
372     }
373 
374     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
375         uint price = oraclize.getPrice(datasource);
376         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
377         return oraclize.query.value(price)(0, datasource, arg);
378     }
379     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
380         uint price = oraclize.getPrice(datasource);
381         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
382         return oraclize.query.value(price)(timestamp, datasource, arg);
383     }
384     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
385         uint price = oraclize.getPrice(datasource, gaslimit);
386         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
387         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
388     }
389     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
390         uint price = oraclize.getPrice(datasource, gaslimit);
391         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
392         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
393     }
394     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
395         uint price = oraclize.getPrice(datasource);
396         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
397         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
398     }
399     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
400         uint price = oraclize.getPrice(datasource);
401         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
402         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
403     }
404     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
405         uint price = oraclize.getPrice(datasource, gaslimit);
406         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
407         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
408     }
409     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
410         uint price = oraclize.getPrice(datasource, gaslimit);
411         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
412         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
413     }
414     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
415         uint price = oraclize.getPrice(datasource);
416         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
417         bytes memory args = stra2cbor(argN);
418         return oraclize.queryN.value(price)(0, datasource, args);
419     }
420     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
421         uint price = oraclize.getPrice(datasource);
422         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
423         bytes memory args = stra2cbor(argN);
424         return oraclize.queryN.value(price)(timestamp, datasource, args);
425     }
426     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
427         uint price = oraclize.getPrice(datasource, gaslimit);
428         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
429         bytes memory args = stra2cbor(argN);
430         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
431     }
432     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
433         uint price = oraclize.getPrice(datasource, gaslimit);
434         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
435         bytes memory args = stra2cbor(argN);
436         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
437     }
438     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
439         string[] memory dynargs = new string[](1);
440         dynargs[0] = args[0];
441         return oraclize_query(datasource, dynargs);
442     }
443     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
444         string[] memory dynargs = new string[](1);
445         dynargs[0] = args[0];
446         return oraclize_query(timestamp, datasource, dynargs);
447     }
448     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
449         string[] memory dynargs = new string[](1);
450         dynargs[0] = args[0];
451         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
452     }
453     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
454         string[] memory dynargs = new string[](1);
455         dynargs[0] = args[0];
456         return oraclize_query(datasource, dynargs, gaslimit);
457     }
458 
459     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
460         string[] memory dynargs = new string[](2);
461         dynargs[0] = args[0];
462         dynargs[1] = args[1];
463         return oraclize_query(datasource, dynargs);
464     }
465     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
466         string[] memory dynargs = new string[](2);
467         dynargs[0] = args[0];
468         dynargs[1] = args[1];
469         return oraclize_query(timestamp, datasource, dynargs);
470     }
471     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
472         string[] memory dynargs = new string[](2);
473         dynargs[0] = args[0];
474         dynargs[1] = args[1];
475         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
476     }
477     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
478         string[] memory dynargs = new string[](2);
479         dynargs[0] = args[0];
480         dynargs[1] = args[1];
481         return oraclize_query(datasource, dynargs, gaslimit);
482     }
483     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
484         string[] memory dynargs = new string[](3);
485         dynargs[0] = args[0];
486         dynargs[1] = args[1];
487         dynargs[2] = args[2];
488         return oraclize_query(datasource, dynargs);
489     }
490     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
491         string[] memory dynargs = new string[](3);
492         dynargs[0] = args[0];
493         dynargs[1] = args[1];
494         dynargs[2] = args[2];
495         return oraclize_query(timestamp, datasource, dynargs);
496     }
497     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
498         string[] memory dynargs = new string[](3);
499         dynargs[0] = args[0];
500         dynargs[1] = args[1];
501         dynargs[2] = args[2];
502         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
503     }
504     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
505         string[] memory dynargs = new string[](3);
506         dynargs[0] = args[0];
507         dynargs[1] = args[1];
508         dynargs[2] = args[2];
509         return oraclize_query(datasource, dynargs, gaslimit);
510     }
511 
512     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
513         string[] memory dynargs = new string[](4);
514         dynargs[0] = args[0];
515         dynargs[1] = args[1];
516         dynargs[2] = args[2];
517         dynargs[3] = args[3];
518         return oraclize_query(datasource, dynargs);
519     }
520     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
521         string[] memory dynargs = new string[](4);
522         dynargs[0] = args[0];
523         dynargs[1] = args[1];
524         dynargs[2] = args[2];
525         dynargs[3] = args[3];
526         return oraclize_query(timestamp, datasource, dynargs);
527     }
528     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
529         string[] memory dynargs = new string[](4);
530         dynargs[0] = args[0];
531         dynargs[1] = args[1];
532         dynargs[2] = args[2];
533         dynargs[3] = args[3];
534         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
535     }
536     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
537         string[] memory dynargs = new string[](4);
538         dynargs[0] = args[0];
539         dynargs[1] = args[1];
540         dynargs[2] = args[2];
541         dynargs[3] = args[3];
542         return oraclize_query(datasource, dynargs, gaslimit);
543     }
544     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
545         string[] memory dynargs = new string[](5);
546         dynargs[0] = args[0];
547         dynargs[1] = args[1];
548         dynargs[2] = args[2];
549         dynargs[3] = args[3];
550         dynargs[4] = args[4];
551         return oraclize_query(datasource, dynargs);
552     }
553     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
554         string[] memory dynargs = new string[](5);
555         dynargs[0] = args[0];
556         dynargs[1] = args[1];
557         dynargs[2] = args[2];
558         dynargs[3] = args[3];
559         dynargs[4] = args[4];
560         return oraclize_query(timestamp, datasource, dynargs);
561     }
562     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
563         string[] memory dynargs = new string[](5);
564         dynargs[0] = args[0];
565         dynargs[1] = args[1];
566         dynargs[2] = args[2];
567         dynargs[3] = args[3];
568         dynargs[4] = args[4];
569         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
570     }
571     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
572         string[] memory dynargs = new string[](5);
573         dynargs[0] = args[0];
574         dynargs[1] = args[1];
575         dynargs[2] = args[2];
576         dynargs[3] = args[3];
577         dynargs[4] = args[4];
578         return oraclize_query(datasource, dynargs, gaslimit);
579     }
580     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
581         uint price = oraclize.getPrice(datasource);
582         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
583         bytes memory args = ba2cbor(argN);
584         return oraclize.queryN.value(price)(0, datasource, args);
585     }
586     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
587         uint price = oraclize.getPrice(datasource);
588         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
589         bytes memory args = ba2cbor(argN);
590         return oraclize.queryN.value(price)(timestamp, datasource, args);
591     }
592     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
593         uint price = oraclize.getPrice(datasource, gaslimit);
594         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
595         bytes memory args = ba2cbor(argN);
596         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
597     }
598     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
599         uint price = oraclize.getPrice(datasource, gaslimit);
600         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
601         bytes memory args = ba2cbor(argN);
602         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
603     }
604     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
605         bytes[] memory dynargs = new bytes[](1);
606         dynargs[0] = args[0];
607         return oraclize_query(datasource, dynargs);
608     }
609     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
610         bytes[] memory dynargs = new bytes[](1);
611         dynargs[0] = args[0];
612         return oraclize_query(timestamp, datasource, dynargs);
613     }
614     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
615         bytes[] memory dynargs = new bytes[](1);
616         dynargs[0] = args[0];
617         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
618     }
619     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
620         bytes[] memory dynargs = new bytes[](1);
621         dynargs[0] = args[0];
622         return oraclize_query(datasource, dynargs, gaslimit);
623     }
624 
625     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
626         bytes[] memory dynargs = new bytes[](2);
627         dynargs[0] = args[0];
628         dynargs[1] = args[1];
629         return oraclize_query(datasource, dynargs);
630     }
631     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
632         bytes[] memory dynargs = new bytes[](2);
633         dynargs[0] = args[0];
634         dynargs[1] = args[1];
635         return oraclize_query(timestamp, datasource, dynargs);
636     }
637     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
638         bytes[] memory dynargs = new bytes[](2);
639         dynargs[0] = args[0];
640         dynargs[1] = args[1];
641         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
642     }
643     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
644         bytes[] memory dynargs = new bytes[](2);
645         dynargs[0] = args[0];
646         dynargs[1] = args[1];
647         return oraclize_query(datasource, dynargs, gaslimit);
648     }
649     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
650         bytes[] memory dynargs = new bytes[](3);
651         dynargs[0] = args[0];
652         dynargs[1] = args[1];
653         dynargs[2] = args[2];
654         return oraclize_query(datasource, dynargs);
655     }
656     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
657         bytes[] memory dynargs = new bytes[](3);
658         dynargs[0] = args[0];
659         dynargs[1] = args[1];
660         dynargs[2] = args[2];
661         return oraclize_query(timestamp, datasource, dynargs);
662     }
663     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
664         bytes[] memory dynargs = new bytes[](3);
665         dynargs[0] = args[0];
666         dynargs[1] = args[1];
667         dynargs[2] = args[2];
668         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
669     }
670     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
671         bytes[] memory dynargs = new bytes[](3);
672         dynargs[0] = args[0];
673         dynargs[1] = args[1];
674         dynargs[2] = args[2];
675         return oraclize_query(datasource, dynargs, gaslimit);
676     }
677 
678     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
679         bytes[] memory dynargs = new bytes[](4);
680         dynargs[0] = args[0];
681         dynargs[1] = args[1];
682         dynargs[2] = args[2];
683         dynargs[3] = args[3];
684         return oraclize_query(datasource, dynargs);
685     }
686     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
687         bytes[] memory dynargs = new bytes[](4);
688         dynargs[0] = args[0];
689         dynargs[1] = args[1];
690         dynargs[2] = args[2];
691         dynargs[3] = args[3];
692         return oraclize_query(timestamp, datasource, dynargs);
693     }
694     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
695         bytes[] memory dynargs = new bytes[](4);
696         dynargs[0] = args[0];
697         dynargs[1] = args[1];
698         dynargs[2] = args[2];
699         dynargs[3] = args[3];
700         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
701     }
702     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
703         bytes[] memory dynargs = new bytes[](4);
704         dynargs[0] = args[0];
705         dynargs[1] = args[1];
706         dynargs[2] = args[2];
707         dynargs[3] = args[3];
708         return oraclize_query(datasource, dynargs, gaslimit);
709     }
710     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
711         bytes[] memory dynargs = new bytes[](5);
712         dynargs[0] = args[0];
713         dynargs[1] = args[1];
714         dynargs[2] = args[2];
715         dynargs[3] = args[3];
716         dynargs[4] = args[4];
717         return oraclize_query(datasource, dynargs);
718     }
719     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
720         bytes[] memory dynargs = new bytes[](5);
721         dynargs[0] = args[0];
722         dynargs[1] = args[1];
723         dynargs[2] = args[2];
724         dynargs[3] = args[3];
725         dynargs[4] = args[4];
726         return oraclize_query(timestamp, datasource, dynargs);
727     }
728     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
729         bytes[] memory dynargs = new bytes[](5);
730         dynargs[0] = args[0];
731         dynargs[1] = args[1];
732         dynargs[2] = args[2];
733         dynargs[3] = args[3];
734         dynargs[4] = args[4];
735         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
736     }
737     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
738         bytes[] memory dynargs = new bytes[](5);
739         dynargs[0] = args[0];
740         dynargs[1] = args[1];
741         dynargs[2] = args[2];
742         dynargs[3] = args[3];
743         dynargs[4] = args[4];
744         return oraclize_query(datasource, dynargs, gaslimit);
745     }
746 
747     function oraclize_cbAddress() oraclizeAPI internal returns (address){
748         return oraclize.cbAddress();
749     }
750     function oraclize_setProof(byte proofP) oraclizeAPI internal {
751         return oraclize.setProofType(proofP);
752     }
753     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
754         return oraclize.setCustomGasPrice(gasPrice);
755     }
756     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
757         return oraclize.setConfig(config);
758     }
759 
760     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
761         return oraclize.randomDS_getSessionPubKeyHash();
762     }
763 
764     function getCodeSize(address _addr) constant internal returns(uint _size) {
765         assembly {
766             _size := extcodesize(_addr)
767         }
768     }
769 
770     function parseAddr(string _a) internal returns (address){
771         bytes memory tmp = bytes(_a);
772         uint160 iaddr = 0;
773         uint160 b1;
774         uint160 b2;
775         for (uint i=2; i<2+2*20; i+=2){
776             iaddr *= 256;
777             b1 = uint160(tmp[i]);
778             b2 = uint160(tmp[i+1]);
779             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
780             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
781             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
782             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
783             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
784             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
785             iaddr += (b1*16+b2);
786         }
787         return address(iaddr);
788     }
789 
790     function strCompare(string _a, string _b) internal returns (int) {
791         bytes memory a = bytes(_a);
792         bytes memory b = bytes(_b);
793         uint minLength = a.length;
794         if (b.length < minLength) minLength = b.length;
795         for (uint i = 0; i < minLength; i ++)
796             if (a[i] < b[i])
797                 return -1;
798             else if (a[i] > b[i])
799                 return 1;
800         if (a.length < b.length)
801             return -1;
802         else if (a.length > b.length)
803             return 1;
804         else
805             return 0;
806     }
807 
808     function indexOf(string _haystack, string _needle) internal returns (int) {
809         bytes memory h = bytes(_haystack);
810         bytes memory n = bytes(_needle);
811         if(h.length < 1 || n.length < 1 || (n.length > h.length))
812             return -1;
813         else if(h.length > (2**128 -1))
814             return -1;
815         else
816         {
817             uint subindex = 0;
818             for (uint i = 0; i < h.length; i ++)
819             {
820                 if (h[i] == n[0])
821                 {
822                     subindex = 1;
823                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
824                     {
825                         subindex++;
826                     }
827                     if(subindex == n.length)
828                         return int(i);
829                 }
830             }
831             return -1;
832         }
833     }
834 
835     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
836         bytes memory _ba = bytes(_a);
837         bytes memory _bb = bytes(_b);
838         bytes memory _bc = bytes(_c);
839         bytes memory _bd = bytes(_d);
840         bytes memory _be = bytes(_e);
841         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
842         bytes memory babcde = bytes(abcde);
843         uint k = 0;
844         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
845         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
846         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
847         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
848         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
849         return string(babcde);
850     }
851 
852     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
853         return strConcat(_a, _b, _c, _d, "");
854     }
855 
856     function strConcat(string _a, string _b, string _c) internal returns (string) {
857         return strConcat(_a, _b, _c, "", "");
858     }
859 
860     function strConcat(string _a, string _b) internal returns (string) {
861         return strConcat(_a, _b, "", "", "");
862     }
863 
864     // parseInt
865     function parseInt(string _a) internal returns (uint) {
866         return parseInt(_a, 0);
867     }
868 
869     // parseInt(parseFloat*10^_b)
870     function parseInt(string _a, uint _b) internal returns (uint) {
871         bytes memory bresult = bytes(_a);
872         uint mint = 0;
873         bool decimals = false;
874         for (uint i=0; i<bresult.length; i++){
875             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
876                 if (decimals){
877                    if (_b == 0) break;
878                     else _b--;
879                 }
880                 mint *= 10;
881                 mint += uint(bresult[i]) - 48;
882             } else if (bresult[i] == 46) decimals = true;
883         }
884         if (_b > 0) mint *= 10**_b;
885         return mint;
886     }
887 
888     function uint2str(uint i) internal returns (string){
889         if (i == 0) return "0";
890         uint j = i;
891         uint len;
892         while (j != 0){
893             len++;
894             j /= 10;
895         }
896         bytes memory bstr = new bytes(len);
897         uint k = len - 1;
898         while (i != 0){
899             bstr[k--] = byte(48 + i % 10);
900             i /= 10;
901         }
902         return string(bstr);
903     }
904 
905     using CBOR for Buffer.buffer;
906     function stra2cbor(string[] arr) internal returns (bytes) {
907         Buffer.buffer memory buf;
908         Buffer.init(buf, 1024);
909         buf.startArray();
910         for (uint i = 0; i < arr.length; i++) {
911             buf.encodeString(arr[i]);
912         }
913         buf.endSequence();
914         return buf.buf;
915     }
916 
917     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
918         Buffer.buffer memory buf;
919         Buffer.init(buf, 1024);
920         buf.startArray();
921         for (uint i = 0; i < arr.length; i++) {
922             buf.encodeBytes(arr[i]);
923         }
924         buf.endSequence();
925         return buf.buf;
926     }
927 
928     string oraclize_network_name;
929     function oraclize_setNetworkName(string _network_name) internal {
930         oraclize_network_name = _network_name;
931     }
932 
933     function oraclize_getNetworkName() internal returns (string) {
934         return oraclize_network_name;
935     }
936 
937     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
938         if ((_nbytes == 0)||(_nbytes > 32)) throw;
939 	// Convert from seconds to ledger timer ticks
940         _delay *= 10;
941         bytes memory nbytes = new bytes(1);
942         nbytes[0] = byte(_nbytes);
943         bytes memory unonce = new bytes(32);
944         bytes memory sessionKeyHash = new bytes(32);
945         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
946         assembly {
947             mstore(unonce, 0x20)
948             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
949             mstore(sessionKeyHash, 0x20)
950             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
951         }
952         bytes memory delay = new bytes(32);
953         assembly {
954             mstore(add(delay, 0x20), _delay)
955         }
956 
957         bytes memory delay_bytes8 = new bytes(8);
958         copyBytes(delay, 24, 8, delay_bytes8, 0);
959 
960         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
961         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
962 
963         bytes memory delay_bytes8_left = new bytes(8);
964 
965         assembly {
966             let x := mload(add(delay_bytes8, 0x20))
967             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
968             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
969             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
970             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
971             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
972             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
973             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
974             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
975 
976         }
977 
978         oraclize_randomDS_setCommitment(queryId, sha3(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
979         return queryId;
980     }
981 
982     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
983         oraclize_randomDS_args[queryId] = commitment;
984     }
985 
986     mapping(bytes32=>bytes32) oraclize_randomDS_args;
987     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
988 
989     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
990         bool sigok;
991         address signer;
992 
993         bytes32 sigr;
994         bytes32 sigs;
995 
996         bytes memory sigr_ = new bytes(32);
997         uint offset = 4+(uint(dersig[3]) - 0x20);
998         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
999         bytes memory sigs_ = new bytes(32);
1000         offset += 32 + 2;
1001         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1002 
1003         assembly {
1004             sigr := mload(add(sigr_, 32))
1005             sigs := mload(add(sigs_, 32))
1006         }
1007 
1008 
1009         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1010         if (address(sha3(pubkey)) == signer) return true;
1011         else {
1012             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1013             return (address(sha3(pubkey)) == signer);
1014         }
1015     }
1016 
1017     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1018         bool sigok;
1019 
1020         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1021         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1022         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1023 
1024         bytes memory appkey1_pubkey = new bytes(64);
1025         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1026 
1027         bytes memory tosign2 = new bytes(1+65+32);
1028         tosign2[0] = 1; //role
1029         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1030         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1031         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1032         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1033 
1034         if (sigok == false) return false;
1035 
1036 
1037         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1038         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1039 
1040         bytes memory tosign3 = new bytes(1+65);
1041         tosign3[0] = 0xFE;
1042         copyBytes(proof, 3, 65, tosign3, 1);
1043 
1044         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1045         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1046 
1047         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1048 
1049         return sigok;
1050     }
1051 
1052     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1053         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1054         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
1055 
1056         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1057         if (proofVerified == false) throw;
1058 
1059         _;
1060     }
1061 
1062     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1063         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1064         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1065 
1066         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1067         if (proofVerified == false) return 2;
1068 
1069         return 0;
1070     }
1071 
1072     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
1073         bool match_ = true;
1074 
1075 	if (prefix.length != n_random_bytes) throw;
1076 
1077         for (uint256 i=0; i< n_random_bytes; i++) {
1078             if (content[i] != prefix[i]) match_ = false;
1079         }
1080 
1081         return match_;
1082     }
1083 
1084     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1085 
1086         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1087         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1088         bytes memory keyhash = new bytes(32);
1089         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1090         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
1091 
1092         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1093         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1094 
1095         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1096         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1097 
1098         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1099         // This is to verify that the computed args match with the ones specified in the query.
1100         bytes memory commitmentSlice1 = new bytes(8+1+32);
1101         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1102 
1103         bytes memory sessionPubkey = new bytes(64);
1104         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1105         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1106 
1107         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1108         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1109             delete oraclize_randomDS_args[queryId];
1110         } else return false;
1111 
1112 
1113         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1114         bytes memory tosign1 = new bytes(32+8+1+32);
1115         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1116         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1117 
1118         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1119         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1120             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1121         }
1122 
1123         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1124     }
1125 
1126 
1127     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1128     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1129         uint minLength = length + toOffset;
1130 
1131         if (to.length < minLength) {
1132             // Buffer too small
1133             throw; // Should be a better way?
1134         }
1135 
1136         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1137         uint i = 32 + fromOffset;
1138         uint j = 32 + toOffset;
1139 
1140         while (i < (32 + fromOffset + length)) {
1141             assembly {
1142                 let tmp := mload(add(from, i))
1143                 mstore(add(to, j), tmp)
1144             }
1145             i += 32;
1146             j += 32;
1147         }
1148 
1149         return to;
1150     }
1151 
1152     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1153     // Duplicate Solidity's ecrecover, but catching the CALL return value
1154     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1155         // We do our own memory management here. Solidity uses memory offset
1156         // 0x40 to store the current end of memory. We write past it (as
1157         // writes are memory extensions), but don't update the offset so
1158         // Solidity will reuse it. The memory used here is only needed for
1159         // this context.
1160 
1161         // FIXME: inline assembly can't access return values
1162         bool ret;
1163         address addr;
1164 
1165         assembly {
1166             let size := mload(0x40)
1167             mstore(size, hash)
1168             mstore(add(size, 32), v)
1169             mstore(add(size, 64), r)
1170             mstore(add(size, 96), s)
1171 
1172             // NOTE: we can reuse the request memory because we deal with
1173             //       the return code
1174             ret := call(3000, 1, 0, size, 128, size, 32)
1175             addr := mload(size)
1176         }
1177 
1178         return (ret, addr);
1179     }
1180 
1181     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1182     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1183         bytes32 r;
1184         bytes32 s;
1185         uint8 v;
1186 
1187         if (sig.length != 65)
1188           return (false, 0);
1189 
1190         // The signature format is a compact form of:
1191         //   {bytes32 r}{bytes32 s}{uint8 v}
1192         // Compact means, uint8 is not padded to 32 bytes.
1193         assembly {
1194             r := mload(add(sig, 32))
1195             s := mload(add(sig, 64))
1196 
1197             // Here we are loading the last 32 bytes. We exploit the fact that
1198             // 'mload' will pad with zeroes if we overread.
1199             // There is no 'mload8' to do this, but that would be nicer.
1200             v := byte(0, mload(add(sig, 96)))
1201 
1202             // Alternative solution:
1203             // 'byte' is not working due to the Solidity parser, so lets
1204             // use the second best option, 'and'
1205             // v := and(mload(add(sig, 65)), 255)
1206         }
1207 
1208         // albeit non-transactional signatures are not specified by the YP, one would expect it
1209         // to match the YP range of [27, 28]
1210         //
1211         // geth uses [0, 1] and some clients have followed. This might change, see:
1212         //  https://github.com/ethereum/go-ethereum/issues/2053
1213         if (v < 27)
1214           v += 27;
1215 
1216         if (v != 27 && v != 28)
1217             return (false, 0);
1218 
1219         return safer_ecrecover(hash, v, r, s);
1220     }
1221 
1222 }
1223 // </ORACLIZE_API>
1224 
1225 
1226 pragma solidity ^0.4.21;
1227 
1228 
1229 /**
1230  * @title SafeMath
1231  * @dev Math operations with safety checks that throw on error
1232  */
1233 library SafeMath {
1234 
1235   /**
1236   * @dev Multiplies two numbers, throws on overflow.
1237   */
1238   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
1239     if (a == 0) {
1240       return 0;
1241     }
1242     c = a * b;
1243     assert(c / a == b);
1244     return c;
1245   }
1246 
1247   /**
1248   * @dev Integer division of two numbers, truncating the quotient.
1249   */
1250   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1251     // assert(b > 0); // Solidity automatically throws when dividing by 0
1252     // uint256 c = a / b;
1253     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1254     return a / b;
1255   }
1256 
1257   /**
1258   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1259   */
1260   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1261     assert(b <= a);
1262     return a - b;
1263   }
1264 
1265   /**
1266   * @dev Adds two numbers, throws on overflow.
1267   */
1268   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
1269     c = a + b;
1270     assert(c >= a);
1271     return c;
1272   }
1273 }
1274 
1275 /**
1276  * @title Ownable
1277  * @dev The Ownable contract has an owner address, and provides basic authorization control
1278  * functions, this simplifies the implementation of "user permissions".
1279  */
1280 contract Ownable {
1281   address public owner;
1282 
1283 
1284   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1285 
1286 
1287   /**
1288    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1289    * account.
1290    */
1291   function Ownable() public {
1292     owner = msg.sender;
1293   }
1294 
1295   /**
1296    * @dev Throws if called by any account other than the owner.
1297    */
1298   modifier onlyOwner() {
1299     require(msg.sender == owner);
1300     _;
1301   }
1302 
1303   /**
1304    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1305    * @param newOwner The address to transfer ownership to.
1306    */
1307   function transferOwnership(address newOwner) public onlyOwner {
1308     require(newOwner != address(0));
1309     emit OwnershipTransferred(owner, newOwner);
1310     owner = newOwner;
1311   }
1312 
1313 }
1314 
1315 /**
1316  * @title Pausable
1317  * @dev Base contract which allows children to implement an emergency stop mechanism.
1318  */
1319 contract Pausable is Ownable {
1320   event Pause();
1321   event Unpause();
1322 
1323   bool public paused = false;
1324 
1325 
1326   /**
1327    * @dev Modifier to make a function callable only when the contract is not paused.
1328    */
1329   modifier whenNotPaused() {
1330     require(!paused);
1331     _;
1332   }
1333 
1334   /**
1335    * @dev Modifier to make a function callable only when the contract is paused.
1336    */
1337   modifier whenPaused() {
1338     require(paused);
1339     _;
1340   }
1341 
1342   /**
1343    * @dev called by the owner to pause, triggers stopped state
1344    */
1345   function pause() onlyOwner whenNotPaused public {
1346     paused = true;
1347     emit Pause();
1348   }
1349 
1350   /**
1351    * @dev called by the owner to unpause, returns to normal state
1352    */
1353   function unpause() onlyOwner whenPaused public {
1354     paused = false;
1355     emit Unpause();
1356   }
1357 }
1358 
1359 interface ETLToken {
1360     function transfer(address receiver, uint amount) external;
1361 }
1362 
1363 contract ETLTokenPresale is Pausable, usingOraclize {
1364     using SafeMath for uint256;
1365 
1366     ETLToken public tokenReward;
1367 
1368     // mappings for future airdrop
1369     mapping (address => uint256) freezeBalances;
1370     mapping (address => uint256) freezeTime;
1371 
1372     uint256 public minimalPrice = 10000000000000; // 0.00001 ETH
1373     uint256 public tokensRaised; // all total amount of tokens
1374     uint256 public ETHUSD; // current ETH price in USD
1375     uint256 public startPresaleTime; // value of time when presale part is started
1376     uint256 public secPerBlock = 14; // 14 seconds per minde block
1377 
1378     uint256 constant public expiredTime = 1546300800; // 1 January 2019
1379     uint256 constant public twoWeeks = 1209600; // 2 weeks = 60*60*24*14 = 1209600 => 1209600 seconds
1380     uint256 constant public tenZero = 10000000000; // for decimals
1381     uint256 constant public loyaltyCap = 200000000000000; // 2 000 000 tokens
1382     uint256 constant public presaleCap = 400000000000000; // 4 000 000 tokens
1383 
1384     bool public presaleFinished = false;
1385     bool public loyaltyPart = true;
1386     bool public oraclizeOn = false;
1387     
1388     event LogPriceUpdated(string price);
1389     event LogNewOraclizeQuery(string description);
1390 
1391     // Modifier to make a function callable only when the Oraclizer is turn off.
1392     modifier whenOraclizeOff() {
1393         require(!oraclizeOn);
1394         _;
1395     }
1396 
1397     // Modifier to make a function callable only when the Oraclizer is turn on.
1398     modifier whenOraclizeOn() {
1399         require(oraclizeOn);
1400         _;
1401     }
1402     
1403     // Modifier to make a function callable only when the presale is not finished.
1404     modifier whenNotFinished() {
1405         require(!presaleFinished);
1406         _;
1407     }
1408 
1409     function ETLTokenPresale(address _tokenReward) public {
1410         tokenReward = ETLToken(_tokenReward);
1411     }
1412 
1413     // View function that shows current bonus value
1414     function getBonus() public view returns (uint256) {
1415         if (loyaltyPart) return 5;
1416         else if (!loyaltyPart && block.number <= startPresaleTime.add(twoWeeks.div(secPerBlock))) return 5;
1417         return 3;
1418     }
1419     
1420     // View function that shows current token price value
1421     function getPrice() public view returns (uint256) {
1422         if (loyaltyPart == true) return 1;
1423         return 8;
1424     }
1425     
1426     // Function activate, when ethers will be recieved to presale smart contract address
1427     function () public payable {
1428         buy(msg.sender);
1429     }
1430 
1431     function buy(address buyer) whenNotPaused whenNotFinished public payable {
1432         require(buyer != address(0));
1433         require(msg.value != 0);
1434         require(msg.value >= minimalPrice);
1435 
1436         uint256 tokens;
1437         
1438         // payment logic of loyalty part
1439         if (loyaltyPart) {
1440             if (tokensRaised >= loyaltyCap) {
1441                 loyaltyPart = false;
1442                 startPresaleTime = block.number;
1443             }
1444             
1445             tokens = msg.value.mul(ETHUSD).div(getPrice()).mul(10).div(tenZero);
1446             tokensRaised = tokensRaised.add(tokens);
1447 
1448             require (tokensRaised <= presaleCap); 
1449 
1450             if (tokensRaised == presaleCap) {
1451                 presaleFinished = true;
1452             }
1453             
1454         // payment logic of presale part
1455         } else {
1456             
1457             tokens = msg.value.mul(ETHUSD).div(getPrice()).mul(10).div(tenZero);
1458             uint256 bonusTokens = tokens.mul(getBonus()).div(10);
1459             freezeBalances[msg.sender] = freezeBalances[msg.sender].add(bonusTokens);
1460             freezeTime[msg.sender] = expiredTime;
1461             tokensRaised = tokensRaised.add(tokens).add(bonusTokens);
1462             
1463             require (tokensRaised <= presaleCap); 
1464 
1465             if (tokensRaised == presaleCap) {
1466                 presaleFinished = true;
1467             }
1468         }
1469         
1470         // transfer tokens to investor
1471         tokenReward.transfer(buyer, tokens);
1472         // transfer ethers to owner
1473         owner.transfer(msg.value);
1474     }
1475 
1476     // Callback for obtaining a new ETH/USD quote price from oraclizer
1477     function __callback(bytes32 myid, string result) whenOraclizeOn {
1478         if (msg.sender != oraclize_cbAddress()) {
1479             revert();
1480         }
1481         ETHUSD = stringToUint(result);
1482         LogPriceUpdated(result);
1483         if (oraclize_getPrice("URL") > this.balance) {
1484             LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1485         } else {
1486             LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1487             oraclize_query(86400, "URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
1488         }
1489     }
1490 
1491     // Obtaining a new ETH/USD quote price from oraclizer
1492     function updatePrice() onlyOwner whenOraclizeOn payable external {
1493         if (oraclize_getPrice("URL") > this.balance) {
1494             LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1495         } else {
1496             LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1497             oraclize_query(86400, "URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
1498         }
1499     }
1500 
1501     // Transfrom string to uint for obtaining a new ETH/USD quote price from oraclizer
1502     function stringToUint(string s) public pure returns (uint result) {
1503         bytes memory b = bytes(s);
1504         uint i;
1505         result = 0;
1506         for (i = 0; i < b.length; i = i.add(1)) {
1507             uint c = uint(b[i]);
1508             if (c == 46) {
1509                 break;
1510             }
1511             if (c >= 48 && c <= 57) {
1512                 result = result.mul(10).add(c.sub(48));
1513                 require(result != 0);
1514             }
1515         }
1516     }
1517     
1518     // Setting a new ETH/USD quote price by owner
1519     function updatePriceManualy(uint256 _ETHUSD) onlyOwner external {
1520         ETHUSD = _ETHUSD;
1521     }
1522 
1523     // Setting a new ETH/USD quote price by owner
1524     function transferFunds() external onlyOwner {
1525         owner.transfer(address(this).balance);
1526     }
1527 
1528     // Allow to set new value of minimal purchase by owner
1529     function updateMinimal(uint256 _minimalPrice) external onlyOwner {
1530         minimalPrice = _minimalPrice;
1531     }
1532 
1533     // Allow to turn Oraclize on by owner
1534     function turnOnOraclize() whenOraclizeOff external onlyOwner {
1535         oraclizeOn = true;
1536     }
1537 
1538     // Allow to turn Oraclize off by owner
1539     function turnOffOraclize() whenOraclizeOn external onlyOwner {
1540         oraclizeOn = false;
1541     }
1542 
1543     // Allow to set new value of seconds to mined block by owner
1544     function updateSecPerBlock(uint256 _secPerBlock) external onlyOwner {
1545         secPerBlock = _secPerBlock;
1546     }
1547 
1548     // Allow to finish loyalty part and start Presale part by owner
1549     function startPresale() external onlyOwner {
1550         loyaltyPart = false;
1551         startPresaleTime = block.number;
1552     }
1553 
1554     // Allow to transfer tokens without any payments by owner
1555     function transferTokens(uint256 _tokens) external onlyOwner {
1556         uint256 tokens = _tokens.mul(100000000); // decimals = 8
1557         tokenReward.transfer(owner, tokens); 
1558     }
1559 
1560     // Allow to airdrop with less than 15 address by owner
1561     function airdrop(address[] _array1, uint256[] _array2) external onlyOwner {
1562         require(_array1.length <= 15);
1563         address[] memory arrayAddress = _array1;
1564         uint256[] memory arrayAmount = _array2;
1565         uint256 arrayLength = arrayAddress.length.sub(1);
1566         uint256 i = 0;
1567        
1568         while (i <= arrayLength) {
1569             tokenReward.transfer(arrayAddress[i], arrayAmount[i]);
1570             i = i.add(1);
1571         }  
1572     }
1573 
1574     // View function that shows time of freezing for future airdrop
1575     function freezeTimeOf(address _investor) public view returns (uint256 balance) {
1576         return freezeTime[_investor];
1577     }
1578 
1579     // View function that shows investor of freezing for future airdrop
1580     function freezeBalancesOf(address _investor) public view returns (uint256 balance) {
1581         return freezeBalances[_investor];
1582     }
1583    
1584     // Allow to send additional ethers to presale contract without getting tokens by owner
1585     function addEther() onlyOwner external payable {
1586        
1587     }
1588 
1589 }