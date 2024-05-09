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
31 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
32 
33 pragma solidity >=0.4.18;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
34 
35 contract OraclizeI {
36     address public cbAddress;
37     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
38     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
39     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
40     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
41     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
42     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
43     function getPrice(string _datasource) public returns (uint _dsprice);
44     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
45     function setProofType(byte _proofType) external;
46     function setCustomGasPrice(uint _gasPrice) external;
47     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
48 }
49 
50 contract OraclizeAddrResolverI {
51     function getAddress() public returns (address _addr);
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
88     function init(buffer memory buf, uint _capacity) internal pure {
89         uint capacity = _capacity;
90         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
91         // Allocate space for the buffer data
92         buf.capacity = capacity;
93         assembly {
94             let ptr := mload(0x40)
95             mstore(buf, ptr)
96             mstore(ptr, 0)
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
115      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
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
162      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
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
187      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
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
292     byte constant proofType_Ledger = 0x30;
293     byte constant proofType_Android = 0x40;
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
316         _;
317     }
318 
319     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
320       return oraclize_setNetwork();
321       networkID; // silence the warning and remain backwards compatible
322     }
323     function oraclize_setNetwork() internal returns(bool){
324         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
325             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
326             oraclize_setNetworkName("eth_mainnet");
327             return true;
328         }
329         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
330             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
331             oraclize_setNetworkName("eth_ropsten3");
332             return true;
333         }
334         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
335             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
336             oraclize_setNetworkName("eth_kovan");
337             return true;
338         }
339         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
340             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
341             oraclize_setNetworkName("eth_rinkeby");
342             return true;
343         }
344         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
345             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
346             return true;
347         }
348         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
349             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
350             return true;
351         }
352         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
353             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
354             return true;
355         }
356         return false;
357     }
358 
359     function __callback(bytes32 myid, string result) public {
360         __callback(myid, result, new bytes(0));
361     }
362     function __callback(bytes32 myid, string result, bytes proof) public {
363       return;
364       myid; result; proof; // Silence compiler warnings
365     }
366 
367     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
368         return oraclize.getPrice(datasource);
369     }
370 
371     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
372         return oraclize.getPrice(datasource, gaslimit);
373     }
374 
375     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
376         uint price = oraclize.getPrice(datasource);
377         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
378         return oraclize.query.value(price)(0, datasource, arg);
379     }
380     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
381         uint price = oraclize.getPrice(datasource);
382         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
383         return oraclize.query.value(price)(timestamp, datasource, arg);
384     }
385     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
386         uint price = oraclize.getPrice(datasource, gaslimit);
387         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
388         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
389     }
390     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
391         uint price = oraclize.getPrice(datasource, gaslimit);
392         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
393         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
394     }
395     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
396         uint price = oraclize.getPrice(datasource);
397         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
398         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
399     }
400     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
401         uint price = oraclize.getPrice(datasource);
402         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
403         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
404     }
405     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
406         uint price = oraclize.getPrice(datasource, gaslimit);
407         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
408         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
409     }
410     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
411         uint price = oraclize.getPrice(datasource, gaslimit);
412         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
413         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
414     }
415     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
416         uint price = oraclize.getPrice(datasource);
417         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
418         bytes memory args = stra2cbor(argN);
419         return oraclize.queryN.value(price)(0, datasource, args);
420     }
421     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
422         uint price = oraclize.getPrice(datasource);
423         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
424         bytes memory args = stra2cbor(argN);
425         return oraclize.queryN.value(price)(timestamp, datasource, args);
426     }
427     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
428         uint price = oraclize.getPrice(datasource, gaslimit);
429         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
430         bytes memory args = stra2cbor(argN);
431         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
432     }
433     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
434         uint price = oraclize.getPrice(datasource, gaslimit);
435         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
436         bytes memory args = stra2cbor(argN);
437         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
438     }
439     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
440         string[] memory dynargs = new string[](1);
441         dynargs[0] = args[0];
442         return oraclize_query(datasource, dynargs);
443     }
444     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
445         string[] memory dynargs = new string[](1);
446         dynargs[0] = args[0];
447         return oraclize_query(timestamp, datasource, dynargs);
448     }
449     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
450         string[] memory dynargs = new string[](1);
451         dynargs[0] = args[0];
452         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
453     }
454     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
455         string[] memory dynargs = new string[](1);
456         dynargs[0] = args[0];
457         return oraclize_query(datasource, dynargs, gaslimit);
458     }
459 
460     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
461         string[] memory dynargs = new string[](2);
462         dynargs[0] = args[0];
463         dynargs[1] = args[1];
464         return oraclize_query(datasource, dynargs);
465     }
466     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
467         string[] memory dynargs = new string[](2);
468         dynargs[0] = args[0];
469         dynargs[1] = args[1];
470         return oraclize_query(timestamp, datasource, dynargs);
471     }
472     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
473         string[] memory dynargs = new string[](2);
474         dynargs[0] = args[0];
475         dynargs[1] = args[1];
476         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
477     }
478     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
479         string[] memory dynargs = new string[](2);
480         dynargs[0] = args[0];
481         dynargs[1] = args[1];
482         return oraclize_query(datasource, dynargs, gaslimit);
483     }
484     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
485         string[] memory dynargs = new string[](3);
486         dynargs[0] = args[0];
487         dynargs[1] = args[1];
488         dynargs[2] = args[2];
489         return oraclize_query(datasource, dynargs);
490     }
491     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
492         string[] memory dynargs = new string[](3);
493         dynargs[0] = args[0];
494         dynargs[1] = args[1];
495         dynargs[2] = args[2];
496         return oraclize_query(timestamp, datasource, dynargs);
497     }
498     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
499         string[] memory dynargs = new string[](3);
500         dynargs[0] = args[0];
501         dynargs[1] = args[1];
502         dynargs[2] = args[2];
503         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
504     }
505     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
506         string[] memory dynargs = new string[](3);
507         dynargs[0] = args[0];
508         dynargs[1] = args[1];
509         dynargs[2] = args[2];
510         return oraclize_query(datasource, dynargs, gaslimit);
511     }
512 
513     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
514         string[] memory dynargs = new string[](4);
515         dynargs[0] = args[0];
516         dynargs[1] = args[1];
517         dynargs[2] = args[2];
518         dynargs[3] = args[3];
519         return oraclize_query(datasource, dynargs);
520     }
521     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
522         string[] memory dynargs = new string[](4);
523         dynargs[0] = args[0];
524         dynargs[1] = args[1];
525         dynargs[2] = args[2];
526         dynargs[3] = args[3];
527         return oraclize_query(timestamp, datasource, dynargs);
528     }
529     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
530         string[] memory dynargs = new string[](4);
531         dynargs[0] = args[0];
532         dynargs[1] = args[1];
533         dynargs[2] = args[2];
534         dynargs[3] = args[3];
535         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
536     }
537     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
538         string[] memory dynargs = new string[](4);
539         dynargs[0] = args[0];
540         dynargs[1] = args[1];
541         dynargs[2] = args[2];
542         dynargs[3] = args[3];
543         return oraclize_query(datasource, dynargs, gaslimit);
544     }
545     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
546         string[] memory dynargs = new string[](5);
547         dynargs[0] = args[0];
548         dynargs[1] = args[1];
549         dynargs[2] = args[2];
550         dynargs[3] = args[3];
551         dynargs[4] = args[4];
552         return oraclize_query(datasource, dynargs);
553     }
554     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
555         string[] memory dynargs = new string[](5);
556         dynargs[0] = args[0];
557         dynargs[1] = args[1];
558         dynargs[2] = args[2];
559         dynargs[3] = args[3];
560         dynargs[4] = args[4];
561         return oraclize_query(timestamp, datasource, dynargs);
562     }
563     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
564         string[] memory dynargs = new string[](5);
565         dynargs[0] = args[0];
566         dynargs[1] = args[1];
567         dynargs[2] = args[2];
568         dynargs[3] = args[3];
569         dynargs[4] = args[4];
570         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
571     }
572     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
573         string[] memory dynargs = new string[](5);
574         dynargs[0] = args[0];
575         dynargs[1] = args[1];
576         dynargs[2] = args[2];
577         dynargs[3] = args[3];
578         dynargs[4] = args[4];
579         return oraclize_query(datasource, dynargs, gaslimit);
580     }
581     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
582         uint price = oraclize.getPrice(datasource);
583         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
584         bytes memory args = ba2cbor(argN);
585         return oraclize.queryN.value(price)(0, datasource, args);
586     }
587     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
588         uint price = oraclize.getPrice(datasource);
589         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
590         bytes memory args = ba2cbor(argN);
591         return oraclize.queryN.value(price)(timestamp, datasource, args);
592     }
593     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
594         uint price = oraclize.getPrice(datasource, gaslimit);
595         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
596         bytes memory args = ba2cbor(argN);
597         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
598     }
599     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
600         uint price = oraclize.getPrice(datasource, gaslimit);
601         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
602         bytes memory args = ba2cbor(argN);
603         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
604     }
605     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
606         bytes[] memory dynargs = new bytes[](1);
607         dynargs[0] = args[0];
608         return oraclize_query(datasource, dynargs);
609     }
610     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
611         bytes[] memory dynargs = new bytes[](1);
612         dynargs[0] = args[0];
613         return oraclize_query(timestamp, datasource, dynargs);
614     }
615     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
616         bytes[] memory dynargs = new bytes[](1);
617         dynargs[0] = args[0];
618         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
619     }
620     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
621         bytes[] memory dynargs = new bytes[](1);
622         dynargs[0] = args[0];
623         return oraclize_query(datasource, dynargs, gaslimit);
624     }
625 
626     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
627         bytes[] memory dynargs = new bytes[](2);
628         dynargs[0] = args[0];
629         dynargs[1] = args[1];
630         return oraclize_query(datasource, dynargs);
631     }
632     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
633         bytes[] memory dynargs = new bytes[](2);
634         dynargs[0] = args[0];
635         dynargs[1] = args[1];
636         return oraclize_query(timestamp, datasource, dynargs);
637     }
638     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
639         bytes[] memory dynargs = new bytes[](2);
640         dynargs[0] = args[0];
641         dynargs[1] = args[1];
642         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
643     }
644     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
645         bytes[] memory dynargs = new bytes[](2);
646         dynargs[0] = args[0];
647         dynargs[1] = args[1];
648         return oraclize_query(datasource, dynargs, gaslimit);
649     }
650     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
651         bytes[] memory dynargs = new bytes[](3);
652         dynargs[0] = args[0];
653         dynargs[1] = args[1];
654         dynargs[2] = args[2];
655         return oraclize_query(datasource, dynargs);
656     }
657     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
658         bytes[] memory dynargs = new bytes[](3);
659         dynargs[0] = args[0];
660         dynargs[1] = args[1];
661         dynargs[2] = args[2];
662         return oraclize_query(timestamp, datasource, dynargs);
663     }
664     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
665         bytes[] memory dynargs = new bytes[](3);
666         dynargs[0] = args[0];
667         dynargs[1] = args[1];
668         dynargs[2] = args[2];
669         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
670     }
671     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
672         bytes[] memory dynargs = new bytes[](3);
673         dynargs[0] = args[0];
674         dynargs[1] = args[1];
675         dynargs[2] = args[2];
676         return oraclize_query(datasource, dynargs, gaslimit);
677     }
678 
679     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
680         bytes[] memory dynargs = new bytes[](4);
681         dynargs[0] = args[0];
682         dynargs[1] = args[1];
683         dynargs[2] = args[2];
684         dynargs[3] = args[3];
685         return oraclize_query(datasource, dynargs);
686     }
687     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
688         bytes[] memory dynargs = new bytes[](4);
689         dynargs[0] = args[0];
690         dynargs[1] = args[1];
691         dynargs[2] = args[2];
692         dynargs[3] = args[3];
693         return oraclize_query(timestamp, datasource, dynargs);
694     }
695     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
696         bytes[] memory dynargs = new bytes[](4);
697         dynargs[0] = args[0];
698         dynargs[1] = args[1];
699         dynargs[2] = args[2];
700         dynargs[3] = args[3];
701         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
702     }
703     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
704         bytes[] memory dynargs = new bytes[](4);
705         dynargs[0] = args[0];
706         dynargs[1] = args[1];
707         dynargs[2] = args[2];
708         dynargs[3] = args[3];
709         return oraclize_query(datasource, dynargs, gaslimit);
710     }
711     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
712         bytes[] memory dynargs = new bytes[](5);
713         dynargs[0] = args[0];
714         dynargs[1] = args[1];
715         dynargs[2] = args[2];
716         dynargs[3] = args[3];
717         dynargs[4] = args[4];
718         return oraclize_query(datasource, dynargs);
719     }
720     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
721         bytes[] memory dynargs = new bytes[](5);
722         dynargs[0] = args[0];
723         dynargs[1] = args[1];
724         dynargs[2] = args[2];
725         dynargs[3] = args[3];
726         dynargs[4] = args[4];
727         return oraclize_query(timestamp, datasource, dynargs);
728     }
729     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
730         bytes[] memory dynargs = new bytes[](5);
731         dynargs[0] = args[0];
732         dynargs[1] = args[1];
733         dynargs[2] = args[2];
734         dynargs[3] = args[3];
735         dynargs[4] = args[4];
736         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
737     }
738     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
739         bytes[] memory dynargs = new bytes[](5);
740         dynargs[0] = args[0];
741         dynargs[1] = args[1];
742         dynargs[2] = args[2];
743         dynargs[3] = args[3];
744         dynargs[4] = args[4];
745         return oraclize_query(datasource, dynargs, gaslimit);
746     }
747 
748     function oraclize_cbAddress() oraclizeAPI internal returns (address){
749         return oraclize.cbAddress();
750     }
751     function oraclize_setProof(byte proofP) oraclizeAPI internal {
752         return oraclize.setProofType(proofP);
753     }
754     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
755         return oraclize.setCustomGasPrice(gasPrice);
756     }
757 
758     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
759         return oraclize.randomDS_getSessionPubKeyHash();
760     }
761 
762     function getCodeSize(address _addr) constant internal returns(uint _size) {
763         assembly {
764             _size := extcodesize(_addr)
765         }
766     }
767 
768     function parseAddr(string _a) internal pure returns (address){
769         bytes memory tmp = bytes(_a);
770         uint160 iaddr = 0;
771         uint160 b1;
772         uint160 b2;
773         for (uint i=2; i<2+2*20; i+=2){
774             iaddr *= 256;
775             b1 = uint160(tmp[i]);
776             b2 = uint160(tmp[i+1]);
777             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
778             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
779             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
780             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
781             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
782             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
783             iaddr += (b1*16+b2);
784         }
785         return address(iaddr);
786     }
787 
788     function strCompare(string _a, string _b) internal pure returns (int) {
789         bytes memory a = bytes(_a);
790         bytes memory b = bytes(_b);
791         uint minLength = a.length;
792         if (b.length < minLength) minLength = b.length;
793         for (uint i = 0; i < minLength; i ++)
794             if (a[i] < b[i])
795                 return -1;
796             else if (a[i] > b[i])
797                 return 1;
798         if (a.length < b.length)
799             return -1;
800         else if (a.length > b.length)
801             return 1;
802         else
803             return 0;
804     }
805 
806     function indexOf(string _haystack, string _needle) internal pure returns (int) {
807         bytes memory h = bytes(_haystack);
808         bytes memory n = bytes(_needle);
809         if(h.length < 1 || n.length < 1 || (n.length > h.length))
810             return -1;
811         else if(h.length > (2**128 -1))
812             return -1;
813         else
814         {
815             uint subindex = 0;
816             for (uint i = 0; i < h.length; i ++)
817             {
818                 if (h[i] == n[0])
819                 {
820                     subindex = 1;
821                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
822                     {
823                         subindex++;
824                     }
825                     if(subindex == n.length)
826                         return int(i);
827                 }
828             }
829             return -1;
830         }
831     }
832 
833     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
834         bytes memory _ba = bytes(_a);
835         bytes memory _bb = bytes(_b);
836         bytes memory _bc = bytes(_c);
837         bytes memory _bd = bytes(_d);
838         bytes memory _be = bytes(_e);
839         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
840         bytes memory babcde = bytes(abcde);
841         uint k = 0;
842         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
843         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
844         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
845         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
846         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
847         return string(babcde);
848     }
849 
850     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
851         return strConcat(_a, _b, _c, _d, "");
852     }
853 
854     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
855         return strConcat(_a, _b, _c, "", "");
856     }
857 
858     function strConcat(string _a, string _b) internal pure returns (string) {
859         return strConcat(_a, _b, "", "", "");
860     }
861 
862     // parseInt
863     function parseInt(string _a) internal pure returns (uint) {
864         return parseInt(_a, 0);
865     }
866 
867     // parseInt(parseFloat*10^_b)
868     function parseInt(string _a, uint _b) internal pure returns (uint) {
869         bytes memory bresult = bytes(_a);
870         uint mint = 0;
871         bool decimals = false;
872         for (uint i=0; i<bresult.length; i++){
873             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
874                 if (decimals){
875                    if (_b == 0) break;
876                     else _b--;
877                 }
878                 mint *= 10;
879                 mint += uint(bresult[i]) - 48;
880             } else if (bresult[i] == 46) decimals = true;
881         }
882         if (_b > 0) mint *= 10**_b;
883         return mint;
884     }
885 
886     function uint2str(uint i) internal pure returns (string){
887         if (i == 0) return "0";
888         uint j = i;
889         uint len;
890         while (j != 0){
891             len++;
892             j /= 10;
893         }
894         bytes memory bstr = new bytes(len);
895         uint k = len - 1;
896         while (i != 0){
897             bstr[k--] = byte(48 + i % 10);
898             i /= 10;
899         }
900         return string(bstr);
901     }
902 
903     using CBOR for Buffer.buffer;
904     function stra2cbor(string[] arr) internal pure returns (bytes) {
905         safeMemoryCleaner();
906         Buffer.buffer memory buf;
907         Buffer.init(buf, 1024);
908         buf.startArray();
909         for (uint i = 0; i < arr.length; i++) {
910             buf.encodeString(arr[i]);
911         }
912         buf.endSequence();
913         return buf.buf;
914     }
915 
916     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
917         safeMemoryCleaner();
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
933     function oraclize_getNetworkName() internal view returns (string) {
934         return oraclize_network_name;
935     }
936 
937     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
938         require((_nbytes > 0) && (_nbytes <= 32));
939         // Convert from seconds to ledger timer ticks
940         _delay *= 10;
941         bytes memory nbytes = new bytes(1);
942         nbytes[0] = byte(_nbytes);
943         bytes memory unonce = new bytes(32);
944         bytes memory sessionKeyHash = new bytes(32);
945         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
946         assembly {
947             mstore(unonce, 0x20)
948             // the following variables can be relaxed
949             // check relaxed random contract under ethereum-examples repo
950             // for an idea on how to override and replace comit hash vars
951             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
952             mstore(sessionKeyHash, 0x20)
953             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
954         }
955         bytes memory delay = new bytes(32);
956         assembly {
957             mstore(add(delay, 0x20), _delay)
958         }
959 
960         bytes memory delay_bytes8 = new bytes(8);
961         copyBytes(delay, 24, 8, delay_bytes8, 0);
962 
963         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
964         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
965 
966         bytes memory delay_bytes8_left = new bytes(8);
967 
968         assembly {
969             let x := mload(add(delay_bytes8, 0x20))
970             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
971             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
972             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
973             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
974             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
975             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
976             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
977             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
978 
979         }
980 
981         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
982         return queryId;
983     }
984 
985     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
986         oraclize_randomDS_args[queryId] = commitment;
987     }
988 
989     mapping(bytes32=>bytes32) oraclize_randomDS_args;
990     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
991 
992     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
993         bool sigok;
994         address signer;
995 
996         bytes32 sigr;
997         bytes32 sigs;
998 
999         bytes memory sigr_ = new bytes(32);
1000         uint offset = 4+(uint(dersig[3]) - 0x20);
1001         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1002         bytes memory sigs_ = new bytes(32);
1003         offset += 32 + 2;
1004         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1005 
1006         assembly {
1007             sigr := mload(add(sigr_, 32))
1008             sigs := mload(add(sigs_, 32))
1009         }
1010 
1011 
1012         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1013         if (address(keccak256(pubkey)) == signer) return true;
1014         else {
1015             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1016             return (address(keccak256(pubkey)) == signer);
1017         }
1018     }
1019 
1020     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1021         bool sigok;
1022 
1023         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1024         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1025         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1026 
1027         bytes memory appkey1_pubkey = new bytes(64);
1028         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1029 
1030         bytes memory tosign2 = new bytes(1+65+32);
1031         tosign2[0] = byte(1); //role
1032         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1033         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1034         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1035         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1036 
1037         if (sigok == false) return false;
1038 
1039 
1040         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1041         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1042 
1043         bytes memory tosign3 = new bytes(1+65);
1044         tosign3[0] = 0xFE;
1045         copyBytes(proof, 3, 65, tosign3, 1);
1046 
1047         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1048         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1049 
1050         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1051 
1052         return sigok;
1053     }
1054 
1055     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1056         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1057         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1058 
1059         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1060         require(proofVerified);
1061 
1062         _;
1063     }
1064 
1065     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1066         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1067         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1068 
1069         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1070         if (proofVerified == false) return 2;
1071 
1072         return 0;
1073     }
1074 
1075     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1076         bool match_ = true;
1077 
1078         require(prefix.length == n_random_bytes);
1079 
1080         for (uint256 i=0; i< n_random_bytes; i++) {
1081             if (content[i] != prefix[i]) match_ = false;
1082         }
1083 
1084         return match_;
1085     }
1086 
1087     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1088 
1089         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1090         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1091         bytes memory keyhash = new bytes(32);
1092         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1093         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1094 
1095         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1096         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1097 
1098         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1099         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1100 
1101         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1102         // This is to verify that the computed args match with the ones specified in the query.
1103         bytes memory commitmentSlice1 = new bytes(8+1+32);
1104         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1105 
1106         bytes memory sessionPubkey = new bytes(64);
1107         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1108         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1109 
1110         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1111         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1112             delete oraclize_randomDS_args[queryId];
1113         } else return false;
1114 
1115 
1116         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1117         bytes memory tosign1 = new bytes(32+8+1+32);
1118         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1119         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1120 
1121         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1122         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1123             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1124         }
1125 
1126         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1127     }
1128 
1129     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1130     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1131         uint minLength = length + toOffset;
1132 
1133         // Buffer too small
1134         require(to.length >= minLength); // Should be a better way?
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
1222     function safeMemoryCleaner() internal pure {
1223         assembly {
1224             let fmem := mload(0x40)
1225             codecopy(fmem, codesize, sub(msize, fmem))
1226         }
1227     }
1228 
1229 }
1230 // </ORACLIZE_API>
1231 /**
1232  * @title SafeMath
1233  * @dev Math operations with safety checks that throw on error
1234  */
1235 library SafeMath {
1236   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1237     uint256 c = a * b;
1238     assert(a == 0 || c / a == b);
1239     return c;
1240   }
1241 
1242   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1243     // assert(b > 0); // Solidity automatically throws when dividing by 0 uint256 c = a / b;
1244     uint256 c = a / b;
1245     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1246     return c;
1247   }
1248 
1249   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1250     assert(b <= a);
1251     return a - b;
1252   }
1253 
1254   function add(uint256 a, uint256 b) internal pure returns (uint256) {
1255     uint256 c = a + b;
1256     assert(c >= a);
1257     return c;
1258   }
1259 }
1260 
1261 /**
1262  * @title Crowdsale
1263  * @dev Crowdsale is a base contract for managing a token crowdsale.
1264  * Crowdsales have a start and end timestamps, where investors can make
1265  * token purchases and the crowdsale will assign them tokens based
1266  * on a token per ETH rate. Funds collected are forwarded 
1267  to a wallet
1268  * as they arrive.
1269  */
1270 interface token { function transfer(address , uint ) external; }
1271 contract Crowdsale is usingOraclize {
1272   using SafeMath for uint256;
1273 
1274   // address where funds are collected
1275   address public wallet;
1276   // token address
1277   address public addressOfTokenUsedAsReward;
1278 
1279   token tokenReward;
1280 
1281 
1282   // amount of raised money in wei
1283   uint256 public weiRaised;
1284   uint public price = 100;
1285 
1286   /**
1287    * event for token purchase logging
1288    * @param purchaser who paid for the tokens
1289    * @param beneficiary who got the tokens
1290    * @param value weis paid for purchase
1291    * @param amount amount of tokens purchased
1292    */
1293   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
1294 
1295 
1296   constructor () public {
1297     //You will change this to your wallet where you need the ETH 
1298     wallet = 0xf466972B885E59D04f10d122cc38E0258e098bDB;
1299     //Here will come the checksum address of token we got
1300     addressOfTokenUsedAsReward = 0x62bf50192b3ef428e24Bc8d10f0c2A6Eabe80E08;
1301 
1302 
1303     tokenReward = token(addressOfTokenUsedAsReward);
1304   }
1305 
1306   bool public started = true;
1307 
1308   function startSale() public {
1309     require (msg.sender == wallet);
1310     started = true;
1311   }
1312 
1313   function stopSale() public {
1314     require (msg.sender == wallet);
1315     started = false;
1316   }
1317 
1318 
1319   function changeWallet(address _wallet) public {
1320     require (msg.sender == wallet);
1321     wallet = _wallet;
1322   }
1323 
1324   // one token = _price cents
1325   function setPrice(uint _price) public {
1326     require (msg.sender == wallet && _price != 0);
1327     price = _price;
1328   }
1329 
1330   // fallback function can be used to buy tokens
1331   function () public payable {
1332     buyTokens(msg.sender);
1333   }
1334   mapping (bytes32 => address) public idToBeneficiary;
1335   mapping (bytes32 => uint) public idToWeiAmount;
1336   event newOraclizeQuery(string description);
1337   
1338   function __callback(bytes32 myid, string result) public {
1339     require (msg.sender == oraclize_cbAddress());
1340     address beneficiary = idToBeneficiary[myid];
1341     uint weiAmount = idToWeiAmount[myid];
1342     uint ethToCents = parseInt(result,2);
1343     
1344     uint tokens = weiAmount.mul(ethToCents)/price;
1345     
1346     tokenReward.transfer(beneficiary, tokens);
1347     emit TokenPurchase(beneficiary, beneficiary, weiAmount, tokens);
1348 
1349   }
1350 
1351   // low level token purchase function
1352   function buyTokens(address beneficiary) public payable {
1353     require(beneficiary != 0x0);
1354     require(validPurchase());
1355 
1356     uint256 weiAmount = msg.value;
1357 
1358 
1359     // update state
1360     weiRaised = weiRaised.add(weiAmount);
1361     
1362     emit newOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1363     bytes32 queryId = oraclize_query("URL", "json(https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD).USD");
1364     
1365     idToBeneficiary[queryId] = beneficiary;
1366     idToWeiAmount[queryId] = weiAmount;
1367     
1368     forwardFunds();
1369   }
1370 
1371   // send ether to the fund collection wallet
1372   // override to create custom fund forwarding mechanisms
1373   function forwardFunds() internal {
1374     wallet.transfer(address(this).balance);
1375   }
1376 
1377   // @return true if the transaction can buy tokens
1378   function validPurchase() internal constant returns (bool) {
1379     bool withinPeriod = started;
1380     bool nonZeroPurchase = msg.value != 0;
1381     return withinPeriod && nonZeroPurchase;
1382   }
1383 
1384   function withdrawTokens(uint256 _amount) public {
1385     require (msg.sender==wallet);
1386     tokenReward.transfer(wallet,_amount);
1387   }
1388 }