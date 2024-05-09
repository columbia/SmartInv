1 /**+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
2                             abcLotto: a Block Chain Lottery
3 
4                             Don't trust anyone but the CODE!
5  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
6  /*
7  * This product is protected under license.  Any unauthorized copy, modification, or use without 
8  * express written consent from the creators is prohibited.
9  */
10 
11 
12 // <ORACLIZE_API>
13 /*
14 Copyright (c) 2015-2016 Oraclize SRL
15 Copyright (c) 2016 Oraclize LTD
16 
17 
18 
19 Permission is hereby granted, free of charge, to any person obtaining a copy
20 of this software and associated documentation files (the "Software"), to deal
21 in the Software without restriction, including without limitation the rights
22 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
23 copies of the Software, and to permit persons to whom the Software is
24 furnished to do so, subject to the following conditions:
25 
26 
27 
28 The above copyright notice and this permission notice shall be included in
29 all copies or substantial portions of the Software.
30 
31 
32 
33 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
34 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
35 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
36 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
37 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
38 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
39 THE SOFTWARE.
40 */
41 
42 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
43 
44 pragma solidity >=0.4.18;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
45 
46 contract OraclizeI {
47     address public cbAddress;
48     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
49     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
50     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
51     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
52     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
53     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
54     function getPrice(string _datasource) public returns (uint _dsprice);
55     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
56     function setProofType(byte _proofType) external;
57     function setCustomGasPrice(uint _gasPrice) external;
58     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
59 }
60 
61 contract OraclizeAddrResolverI {
62     function getAddress() public returns (address _addr);
63 }
64 
65 /*
66 Begin solidity-cborutils
67 
68 https://github.com/smartcontractkit/solidity-cborutils
69 
70 MIT License
71 
72 Copyright (c) 2018 SmartContract ChainLink, Ltd.
73 
74 Permission is hereby granted, free of charge, to any person obtaining a copy
75 of this software and associated documentation files (the "Software"), to deal
76 in the Software without restriction, including without limitation the rights
77 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
78 copies of the Software, and to permit persons to whom the Software is
79 furnished to do so, subject to the following conditions:
80 
81 The above copyright notice and this permission notice shall be included in all
82 copies or substantial portions of the Software.
83 
84 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
85 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
86 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
87 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
88 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
89 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
90 SOFTWARE.
91  */
92 
93 library Buffer {
94     struct buffer {
95         bytes buf;
96         uint capacity;
97     }
98 
99     function init(buffer memory buf, uint _capacity) internal pure {
100         uint capacity = _capacity;
101         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
102         // Allocate space for the buffer data
103         buf.capacity = capacity;
104         assembly {
105             let ptr := mload(0x40)
106             mstore(buf, ptr)
107             mstore(ptr, 0)
108             mstore(0x40, add(ptr, capacity))
109         }
110     }
111 
112     function resize(buffer memory buf, uint capacity) private pure {
113         bytes memory oldbuf = buf.buf;
114         init(buf, capacity);
115         append(buf, oldbuf);
116     }
117 
118     function max(uint a, uint b) private pure returns(uint) {
119         if(a > b) {
120             return a;
121         }
122         return b;
123     }
124 
125     /**
126      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
127      *      would exceed the capacity of the buffer.
128      * @param buf The buffer to append to.
129      * @param data The data to append.
130      * @return The original buffer.
131      */
132     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
133         if(data.length + buf.buf.length > buf.capacity) {
134             resize(buf, max(buf.capacity, data.length) * 2);
135         }
136 
137         uint dest;
138         uint src;
139         uint len = data.length;
140         assembly {
141             // Memory address of the buffer data
142             let bufptr := mload(buf)
143             // Length of existing buffer data
144             let buflen := mload(bufptr)
145             // Start address = buffer address + buffer length + sizeof(buffer length)
146             dest := add(add(bufptr, buflen), 32)
147             // Update buffer length
148             mstore(bufptr, add(buflen, mload(data)))
149             src := add(data, 32)
150         }
151 
152         // Copy word-length chunks while possible
153         for(; len >= 32; len -= 32) {
154             assembly {
155                 mstore(dest, mload(src))
156             }
157             dest += 32;
158             src += 32;
159         }
160 
161         // Copy remaining bytes
162         uint mask = 256 ** (32 - len) - 1;
163         assembly {
164             let srcpart := and(mload(src), not(mask))
165             let destpart := and(mload(dest), mask)
166             mstore(dest, or(destpart, srcpart))
167         }
168 
169         return buf;
170     }
171 
172     /**
173      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
174      * exceed the capacity of the buffer.
175      * @param buf The buffer to append to.
176      * @param data The data to append.
177      * @return The original buffer.
178      */
179     function append(buffer memory buf, uint8 data) internal pure {
180         if(buf.buf.length + 1 > buf.capacity) {
181             resize(buf, buf.capacity * 2);
182         }
183 
184         assembly {
185             // Memory address of the buffer data
186             let bufptr := mload(buf)
187             // Length of existing buffer data
188             let buflen := mload(bufptr)
189             // Address = buffer address + buffer length + sizeof(buffer length)
190             let dest := add(add(bufptr, buflen), 32)
191             mstore8(dest, data)
192             // Update buffer length
193             mstore(bufptr, add(buflen, 1))
194         }
195     }
196 
197     /**
198      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
199      * exceed the capacity of the buffer.
200      * @param buf The buffer to append to.
201      * @param data The data to append.
202      * @return The original buffer.
203      */
204     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
205         if(len + buf.buf.length > buf.capacity) {
206             resize(buf, max(buf.capacity, len) * 2);
207         }
208 
209         uint mask = 256 ** len - 1;
210         assembly {
211             // Memory address of the buffer data
212             let bufptr := mload(buf)
213             // Length of existing buffer data
214             let buflen := mload(bufptr)
215             // Address = buffer address + buffer length + sizeof(buffer length) + len
216             let dest := add(add(bufptr, buflen), len)
217             mstore(dest, or(and(mload(dest), not(mask)), data))
218             // Update buffer length
219             mstore(bufptr, add(buflen, len))
220         }
221         return buf;
222     }
223 }
224 
225 library CBOR {
226     using Buffer for Buffer.buffer;
227 
228     uint8 private constant MAJOR_TYPE_INT = 0;
229     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
230     uint8 private constant MAJOR_TYPE_BYTES = 2;
231     uint8 private constant MAJOR_TYPE_STRING = 3;
232     uint8 private constant MAJOR_TYPE_ARRAY = 4;
233     uint8 private constant MAJOR_TYPE_MAP = 5;
234     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
235 
236     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
237         if(value <= 23) {
238             buf.append(uint8((major << 5) | value));
239         } else if(value <= 0xFF) {
240             buf.append(uint8((major << 5) | 24));
241             buf.appendInt(value, 1);
242         } else if(value <= 0xFFFF) {
243             buf.append(uint8((major << 5) | 25));
244             buf.appendInt(value, 2);
245         } else if(value <= 0xFFFFFFFF) {
246             buf.append(uint8((major << 5) | 26));
247             buf.appendInt(value, 4);
248         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
249             buf.append(uint8((major << 5) | 27));
250             buf.appendInt(value, 8);
251         }
252     }
253 
254     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
255         buf.append(uint8((major << 5) | 31));
256     }
257 
258     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
259         encodeType(buf, MAJOR_TYPE_INT, value);
260     }
261 
262     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
263         if(value >= 0) {
264             encodeType(buf, MAJOR_TYPE_INT, uint(value));
265         } else {
266             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
267         }
268     }
269 
270     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
271         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
272         buf.append(value);
273     }
274 
275     function encodeString(Buffer.buffer memory buf, string value) internal pure {
276         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
277         buf.append(bytes(value));
278     }
279 
280     function startArray(Buffer.buffer memory buf) internal pure {
281         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
282     }
283 
284     function startMap(Buffer.buffer memory buf) internal pure {
285         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
286     }
287 
288     function endSequence(Buffer.buffer memory buf) internal pure {
289         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
290     }
291 }
292 
293 /*
294 End solidity-cborutils
295  */
296 
297 contract usingOraclize {
298     uint constant day = 60*60*24;
299     uint constant week = 60*60*24*7;
300     uint constant month = 60*60*24*30;
301     byte constant proofType_NONE = 0x00;
302     byte constant proofType_TLSNotary = 0x10;
303     byte constant proofType_Ledger = 0x30;
304     byte constant proofType_Android = 0x40;
305     byte constant proofType_Native = 0xF0;
306     byte constant proofStorage_IPFS = 0x01;
307     uint8 constant networkID_auto = 0;
308     uint8 constant networkID_mainnet = 1;
309     uint8 constant networkID_testnet = 2;
310     uint8 constant networkID_morden = 2;
311     uint8 constant networkID_consensys = 161;
312 
313     OraclizeAddrResolverI OAR;
314 
315     OraclizeI oraclize;
316     modifier oraclizeAPI {
317         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
318             oraclize_setNetwork(networkID_auto);
319 
320         if(address(oraclize) != OAR.getAddress())
321             oraclize = OraclizeI(OAR.getAddress());
322 
323         _;
324     }
325     modifier coupon(string code){
326         oraclize = OraclizeI(OAR.getAddress());
327         _;
328     }
329 
330     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
331       return oraclize_setNetwork();
332       networkID; // silence the warning and remain backwards compatible
333     }
334     function oraclize_setNetwork() internal returns(bool){
335         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
336             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
337             oraclize_setNetworkName("eth_mainnet");
338             return true;
339         }
340         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
341             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
342             oraclize_setNetworkName("eth_ropsten3");
343             return true;
344         }
345         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
346             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
347             oraclize_setNetworkName("eth_kovan");
348             return true;
349         }
350         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
351             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
352             oraclize_setNetworkName("eth_rinkeby");
353             return true;
354         }
355         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
356             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
357             return true;
358         }
359         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
360             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
361             return true;
362         }
363         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
364             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
365             return true;
366         }
367         return false;
368     }
369 
370     function __callback(bytes32 myid, string result) public {
371         __callback(myid, result, new bytes(0));
372     }
373     function __callback(bytes32 myid, string result, bytes proof) public {
374       return;
375       myid; result; proof; // Silence compiler warnings
376     }
377 
378     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
379         return oraclize.getPrice(datasource);
380     }
381 
382     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
383         return oraclize.getPrice(datasource, gaslimit);
384     }
385 
386     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
387         uint price = oraclize.getPrice(datasource);
388         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
389         return oraclize.query.value(price)(0, datasource, arg);
390     }
391     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
392         uint price = oraclize.getPrice(datasource);
393         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
394         return oraclize.query.value(price)(timestamp, datasource, arg);
395     }
396     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
397         uint price = oraclize.getPrice(datasource, gaslimit);
398         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
399         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
400     }
401     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
402         uint price = oraclize.getPrice(datasource, gaslimit);
403         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
404         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
405     }
406     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
407         uint price = oraclize.getPrice(datasource);
408         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
409         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
410     }
411     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
412         uint price = oraclize.getPrice(datasource);
413         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
414         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
415     }
416     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
417         uint price = oraclize.getPrice(datasource, gaslimit);
418         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
419         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
420     }
421     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
422         uint price = oraclize.getPrice(datasource, gaslimit);
423         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
424         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
425     }
426     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
427         uint price = oraclize.getPrice(datasource);
428         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
429         bytes memory args = stra2cbor(argN);
430         return oraclize.queryN.value(price)(0, datasource, args);
431     }
432     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
433         uint price = oraclize.getPrice(datasource);
434         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
435         bytes memory args = stra2cbor(argN);
436         return oraclize.queryN.value(price)(timestamp, datasource, args);
437     }
438     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
439         uint price = oraclize.getPrice(datasource, gaslimit);
440         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
441         bytes memory args = stra2cbor(argN);
442         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
443     }
444     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
445         uint price = oraclize.getPrice(datasource, gaslimit);
446         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
447         bytes memory args = stra2cbor(argN);
448         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
449     }
450     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
451         string[] memory dynargs = new string[](1);
452         dynargs[0] = args[0];
453         return oraclize_query(datasource, dynargs);
454     }
455     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
456         string[] memory dynargs = new string[](1);
457         dynargs[0] = args[0];
458         return oraclize_query(timestamp, datasource, dynargs);
459     }
460     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
461         string[] memory dynargs = new string[](1);
462         dynargs[0] = args[0];
463         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
464     }
465     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
466         string[] memory dynargs = new string[](1);
467         dynargs[0] = args[0];
468         return oraclize_query(datasource, dynargs, gaslimit);
469     }
470 
471     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
472         string[] memory dynargs = new string[](2);
473         dynargs[0] = args[0];
474         dynargs[1] = args[1];
475         return oraclize_query(datasource, dynargs);
476     }
477     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
478         string[] memory dynargs = new string[](2);
479         dynargs[0] = args[0];
480         dynargs[1] = args[1];
481         return oraclize_query(timestamp, datasource, dynargs);
482     }
483     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
484         string[] memory dynargs = new string[](2);
485         dynargs[0] = args[0];
486         dynargs[1] = args[1];
487         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
488     }
489     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
490         string[] memory dynargs = new string[](2);
491         dynargs[0] = args[0];
492         dynargs[1] = args[1];
493         return oraclize_query(datasource, dynargs, gaslimit);
494     }
495     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
496         string[] memory dynargs = new string[](3);
497         dynargs[0] = args[0];
498         dynargs[1] = args[1];
499         dynargs[2] = args[2];
500         return oraclize_query(datasource, dynargs);
501     }
502     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
503         string[] memory dynargs = new string[](3);
504         dynargs[0] = args[0];
505         dynargs[1] = args[1];
506         dynargs[2] = args[2];
507         return oraclize_query(timestamp, datasource, dynargs);
508     }
509     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
510         string[] memory dynargs = new string[](3);
511         dynargs[0] = args[0];
512         dynargs[1] = args[1];
513         dynargs[2] = args[2];
514         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
515     }
516     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
517         string[] memory dynargs = new string[](3);
518         dynargs[0] = args[0];
519         dynargs[1] = args[1];
520         dynargs[2] = args[2];
521         return oraclize_query(datasource, dynargs, gaslimit);
522     }
523 
524     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
525         string[] memory dynargs = new string[](4);
526         dynargs[0] = args[0];
527         dynargs[1] = args[1];
528         dynargs[2] = args[2];
529         dynargs[3] = args[3];
530         return oraclize_query(datasource, dynargs);
531     }
532     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
533         string[] memory dynargs = new string[](4);
534         dynargs[0] = args[0];
535         dynargs[1] = args[1];
536         dynargs[2] = args[2];
537         dynargs[3] = args[3];
538         return oraclize_query(timestamp, datasource, dynargs);
539     }
540     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
541         string[] memory dynargs = new string[](4);
542         dynargs[0] = args[0];
543         dynargs[1] = args[1];
544         dynargs[2] = args[2];
545         dynargs[3] = args[3];
546         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
547     }
548     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
549         string[] memory dynargs = new string[](4);
550         dynargs[0] = args[0];
551         dynargs[1] = args[1];
552         dynargs[2] = args[2];
553         dynargs[3] = args[3];
554         return oraclize_query(datasource, dynargs, gaslimit);
555     }
556     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
557         string[] memory dynargs = new string[](5);
558         dynargs[0] = args[0];
559         dynargs[1] = args[1];
560         dynargs[2] = args[2];
561         dynargs[3] = args[3];
562         dynargs[4] = args[4];
563         return oraclize_query(datasource, dynargs);
564     }
565     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
566         string[] memory dynargs = new string[](5);
567         dynargs[0] = args[0];
568         dynargs[1] = args[1];
569         dynargs[2] = args[2];
570         dynargs[3] = args[3];
571         dynargs[4] = args[4];
572         return oraclize_query(timestamp, datasource, dynargs);
573     }
574     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
575         string[] memory dynargs = new string[](5);
576         dynargs[0] = args[0];
577         dynargs[1] = args[1];
578         dynargs[2] = args[2];
579         dynargs[3] = args[3];
580         dynargs[4] = args[4];
581         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
582     }
583     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
584         string[] memory dynargs = new string[](5);
585         dynargs[0] = args[0];
586         dynargs[1] = args[1];
587         dynargs[2] = args[2];
588         dynargs[3] = args[3];
589         dynargs[4] = args[4];
590         return oraclize_query(datasource, dynargs, gaslimit);
591     }
592     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
593         uint price = oraclize.getPrice(datasource);
594         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
595         bytes memory args = ba2cbor(argN);
596         return oraclize.queryN.value(price)(0, datasource, args);
597     }
598     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
599         uint price = oraclize.getPrice(datasource);
600         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
601         bytes memory args = ba2cbor(argN);
602         return oraclize.queryN.value(price)(timestamp, datasource, args);
603     }
604     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
605         uint price = oraclize.getPrice(datasource, gaslimit);
606         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
607         bytes memory args = ba2cbor(argN);
608         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
609     }
610     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
611         uint price = oraclize.getPrice(datasource, gaslimit);
612         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
613         bytes memory args = ba2cbor(argN);
614         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
615     }
616     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
617         bytes[] memory dynargs = new bytes[](1);
618         dynargs[0] = args[0];
619         return oraclize_query(datasource, dynargs);
620     }
621     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
622         bytes[] memory dynargs = new bytes[](1);
623         dynargs[0] = args[0];
624         return oraclize_query(timestamp, datasource, dynargs);
625     }
626     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
627         bytes[] memory dynargs = new bytes[](1);
628         dynargs[0] = args[0];
629         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
630     }
631     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
632         bytes[] memory dynargs = new bytes[](1);
633         dynargs[0] = args[0];
634         return oraclize_query(datasource, dynargs, gaslimit);
635     }
636 
637     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
638         bytes[] memory dynargs = new bytes[](2);
639         dynargs[0] = args[0];
640         dynargs[1] = args[1];
641         return oraclize_query(datasource, dynargs);
642     }
643     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
644         bytes[] memory dynargs = new bytes[](2);
645         dynargs[0] = args[0];
646         dynargs[1] = args[1];
647         return oraclize_query(timestamp, datasource, dynargs);
648     }
649     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
650         bytes[] memory dynargs = new bytes[](2);
651         dynargs[0] = args[0];
652         dynargs[1] = args[1];
653         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
654     }
655     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
656         bytes[] memory dynargs = new bytes[](2);
657         dynargs[0] = args[0];
658         dynargs[1] = args[1];
659         return oraclize_query(datasource, dynargs, gaslimit);
660     }
661     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
662         bytes[] memory dynargs = new bytes[](3);
663         dynargs[0] = args[0];
664         dynargs[1] = args[1];
665         dynargs[2] = args[2];
666         return oraclize_query(datasource, dynargs);
667     }
668     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
669         bytes[] memory dynargs = new bytes[](3);
670         dynargs[0] = args[0];
671         dynargs[1] = args[1];
672         dynargs[2] = args[2];
673         return oraclize_query(timestamp, datasource, dynargs);
674     }
675     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
676         bytes[] memory dynargs = new bytes[](3);
677         dynargs[0] = args[0];
678         dynargs[1] = args[1];
679         dynargs[2] = args[2];
680         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
681     }
682     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
683         bytes[] memory dynargs = new bytes[](3);
684         dynargs[0] = args[0];
685         dynargs[1] = args[1];
686         dynargs[2] = args[2];
687         return oraclize_query(datasource, dynargs, gaslimit);
688     }
689 
690     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
691         bytes[] memory dynargs = new bytes[](4);
692         dynargs[0] = args[0];
693         dynargs[1] = args[1];
694         dynargs[2] = args[2];
695         dynargs[3] = args[3];
696         return oraclize_query(datasource, dynargs);
697     }
698     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
699         bytes[] memory dynargs = new bytes[](4);
700         dynargs[0] = args[0];
701         dynargs[1] = args[1];
702         dynargs[2] = args[2];
703         dynargs[3] = args[3];
704         return oraclize_query(timestamp, datasource, dynargs);
705     }
706     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
707         bytes[] memory dynargs = new bytes[](4);
708         dynargs[0] = args[0];
709         dynargs[1] = args[1];
710         dynargs[2] = args[2];
711         dynargs[3] = args[3];
712         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
713     }
714     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
715         bytes[] memory dynargs = new bytes[](4);
716         dynargs[0] = args[0];
717         dynargs[1] = args[1];
718         dynargs[2] = args[2];
719         dynargs[3] = args[3];
720         return oraclize_query(datasource, dynargs, gaslimit);
721     }
722     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
723         bytes[] memory dynargs = new bytes[](5);
724         dynargs[0] = args[0];
725         dynargs[1] = args[1];
726         dynargs[2] = args[2];
727         dynargs[3] = args[3];
728         dynargs[4] = args[4];
729         return oraclize_query(datasource, dynargs);
730     }
731     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
732         bytes[] memory dynargs = new bytes[](5);
733         dynargs[0] = args[0];
734         dynargs[1] = args[1];
735         dynargs[2] = args[2];
736         dynargs[3] = args[3];
737         dynargs[4] = args[4];
738         return oraclize_query(timestamp, datasource, dynargs);
739     }
740     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
741         bytes[] memory dynargs = new bytes[](5);
742         dynargs[0] = args[0];
743         dynargs[1] = args[1];
744         dynargs[2] = args[2];
745         dynargs[3] = args[3];
746         dynargs[4] = args[4];
747         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
748     }
749     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
750         bytes[] memory dynargs = new bytes[](5);
751         dynargs[0] = args[0];
752         dynargs[1] = args[1];
753         dynargs[2] = args[2];
754         dynargs[3] = args[3];
755         dynargs[4] = args[4];
756         return oraclize_query(datasource, dynargs, gaslimit);
757     }
758 
759     function oraclize_cbAddress() oraclizeAPI internal returns (address){
760         return oraclize.cbAddress();
761     }
762     function oraclize_setProof(byte proofP) oraclizeAPI internal {
763         return oraclize.setProofType(proofP);
764     }
765     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
766         return oraclize.setCustomGasPrice(gasPrice);
767     }
768 
769     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
770         return oraclize.randomDS_getSessionPubKeyHash();
771     }
772 
773     function getCodeSize(address _addr) constant internal returns(uint _size) {
774         assembly {
775             _size := extcodesize(_addr)
776         }
777     }
778 
779     function parseAddr(string _a) internal pure returns (address){
780         bytes memory tmp = bytes(_a);
781         uint160 iaddr = 0;
782         uint160 b1;
783         uint160 b2;
784         for (uint i=2; i<2+2*20; i+=2){
785             iaddr *= 256;
786             b1 = uint160(tmp[i]);
787             b2 = uint160(tmp[i+1]);
788             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
789             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
790             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
791             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
792             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
793             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
794             iaddr += (b1*16+b2);
795         }
796         return address(iaddr);
797     }
798 
799     function strCompare(string _a, string _b) internal pure returns (int) {
800         bytes memory a = bytes(_a);
801         bytes memory b = bytes(_b);
802         uint minLength = a.length;
803         if (b.length < minLength) minLength = b.length;
804         for (uint i = 0; i < minLength; i ++)
805             if (a[i] < b[i])
806                 return -1;
807             else if (a[i] > b[i])
808                 return 1;
809         if (a.length < b.length)
810             return -1;
811         else if (a.length > b.length)
812             return 1;
813         else
814             return 0;
815     }
816 
817     function indexOf(string _haystack, string _needle) internal pure returns (int) {
818         bytes memory h = bytes(_haystack);
819         bytes memory n = bytes(_needle);
820         if(h.length < 1 || n.length < 1 || (n.length > h.length))
821             return -1;
822         else if(h.length > (2**128 -1))
823             return -1;
824         else
825         {
826             uint subindex = 0;
827             for (uint i = 0; i < h.length; i ++)
828             {
829                 if (h[i] == n[0])
830                 {
831                     subindex = 1;
832                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
833                     {
834                         subindex++;
835                     }
836                     if(subindex == n.length)
837                         return int(i);
838                 }
839             }
840             return -1;
841         }
842     }
843 
844     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
845         bytes memory _ba = bytes(_a);
846         bytes memory _bb = bytes(_b);
847         bytes memory _bc = bytes(_c);
848         bytes memory _bd = bytes(_d);
849         bytes memory _be = bytes(_e);
850         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
851         bytes memory babcde = bytes(abcde);
852         uint k = 0;
853         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
854         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
855         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
856         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
857         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
858         return string(babcde);
859     }
860 
861     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
862         return strConcat(_a, _b, _c, _d, "");
863     }
864 
865     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
866         return strConcat(_a, _b, _c, "", "");
867     }
868 
869     function strConcat(string _a, string _b) internal pure returns (string) {
870         return strConcat(_a, _b, "", "", "");
871     }
872 
873     // parseInt
874     function parseInt(string _a) internal pure returns (uint) {
875         return parseInt(_a, 0);
876     }
877 
878     // parseInt(parseFloat*10^_b)
879     function parseInt(string _a, uint _b) internal pure returns (uint) {
880         bytes memory bresult = bytes(_a);
881         uint mint = 0;
882         bool decimals = false;
883         for (uint i=0; i<bresult.length; i++){
884             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
885                 if (decimals){
886                    if (_b == 0) break;
887                     else _b--;
888                 }
889                 mint *= 10;
890                 mint += uint(bresult[i]) - 48;
891             } else if (bresult[i] == 46) decimals = true;
892         }
893         if (_b > 0) mint *= 10**_b;
894         return mint;
895     }
896 
897     function uint2str(uint i) internal pure returns (string){
898         if (i == 0) return "0";
899         uint j = i;
900         uint len;
901         while (j != 0){
902             len++;
903             j /= 10;
904         }
905         bytes memory bstr = new bytes(len);
906         uint k = len - 1;
907         while (i != 0){
908             bstr[k--] = byte(48 + i % 10);
909             i /= 10;
910         }
911         return string(bstr);
912     }
913 
914     using CBOR for Buffer.buffer;
915     function stra2cbor(string[] arr) internal pure returns (bytes) {
916         safeMemoryCleaner();
917         Buffer.buffer memory buf;
918         Buffer.init(buf, 1024);
919         buf.startArray();
920         for (uint i = 0; i < arr.length; i++) {
921             buf.encodeString(arr[i]);
922         }
923         buf.endSequence();
924         return buf.buf;
925     }
926 
927     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
928         safeMemoryCleaner();
929         Buffer.buffer memory buf;
930         Buffer.init(buf, 1024);
931         buf.startArray();
932         for (uint i = 0; i < arr.length; i++) {
933             buf.encodeBytes(arr[i]);
934         }
935         buf.endSequence();
936         return buf.buf;
937     }
938 
939     string oraclize_network_name;
940     function oraclize_setNetworkName(string _network_name) internal {
941         oraclize_network_name = _network_name;
942     }
943 
944     function oraclize_getNetworkName() internal view returns (string) {
945         return oraclize_network_name;
946     }
947 
948     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
949         require((_nbytes > 0) && (_nbytes <= 32));
950         // Convert from seconds to ledger timer ticks
951         _delay *= 10;
952         bytes memory nbytes = new bytes(1);
953         nbytes[0] = byte(_nbytes);
954         bytes memory unonce = new bytes(32);
955         bytes memory sessionKeyHash = new bytes(32);
956         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
957         assembly {
958             mstore(unonce, 0x20)
959             // the following variables can be relaxed
960             // check relaxed random contract under ethereum-examples repo
961             // for an idea on how to override and replace comit hash vars
962             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
963             mstore(sessionKeyHash, 0x20)
964             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
965         }
966         bytes memory delay = new bytes(32);
967         assembly {
968             mstore(add(delay, 0x20), _delay)
969         }
970 
971         bytes memory delay_bytes8 = new bytes(8);
972         copyBytes(delay, 24, 8, delay_bytes8, 0);
973 
974         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
975         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
976 
977         bytes memory delay_bytes8_left = new bytes(8);
978 
979         assembly {
980             let x := mload(add(delay_bytes8, 0x20))
981             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
982             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
983             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
984             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
985             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
986             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
987             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
988             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
989 
990         }
991 
992         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
993         return queryId;
994     }
995 
996     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
997         oraclize_randomDS_args[queryId] = commitment;
998     }
999 
1000     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1001     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1002 
1003     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1004         bool sigok;
1005         address signer;
1006 
1007         bytes32 sigr;
1008         bytes32 sigs;
1009 
1010         bytes memory sigr_ = new bytes(32);
1011         uint offset = 4+(uint(dersig[3]) - 0x20);
1012         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1013         bytes memory sigs_ = new bytes(32);
1014         offset += 32 + 2;
1015         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1016 
1017         assembly {
1018             sigr := mload(add(sigr_, 32))
1019             sigs := mload(add(sigs_, 32))
1020         }
1021 
1022 
1023         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1024         if (address(keccak256(pubkey)) == signer) return true;
1025         else {
1026             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1027             return (address(keccak256(pubkey)) == signer);
1028         }
1029     }
1030 
1031     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1032         bool sigok;
1033 
1034         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1035         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1036         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1037 
1038         bytes memory appkey1_pubkey = new bytes(64);
1039         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1040 
1041         bytes memory tosign2 = new bytes(1+65+32);
1042         tosign2[0] = byte(1); //role
1043         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1044         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1045         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1046         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1047 
1048         if (sigok == false) return false;
1049 
1050 
1051         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1052         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1053 
1054         bytes memory tosign3 = new bytes(1+65);
1055         tosign3[0] = 0xFE;
1056         copyBytes(proof, 3, 65, tosign3, 1);
1057 
1058         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1059         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1060 
1061         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1062 
1063         return sigok;
1064     }
1065 
1066     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1067         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1068         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1069 
1070         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1071         require(proofVerified);
1072 
1073         _;
1074     }
1075 
1076     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1077         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1078         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1079 
1080         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1081         if (proofVerified == false) return 2;
1082 
1083         return 0;
1084     }
1085 
1086     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1087         bool match_ = true;
1088 
1089         require(prefix.length == n_random_bytes);
1090 
1091         for (uint256 i=0; i< n_random_bytes; i++) {
1092             if (content[i] != prefix[i]) match_ = false;
1093         }
1094 
1095         return match_;
1096     }
1097 
1098     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1099 
1100         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1101         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1102         bytes memory keyhash = new bytes(32);
1103         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1104         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1105 
1106         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1107         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1108 
1109         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1110         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1111 
1112         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1113         // This is to verify that the computed args match with the ones specified in the query.
1114         bytes memory commitmentSlice1 = new bytes(8+1+32);
1115         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1116 
1117         bytes memory sessionPubkey = new bytes(64);
1118         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1119         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1120 
1121         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1122         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1123             delete oraclize_randomDS_args[queryId];
1124         } else return false;
1125 
1126 
1127         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1128         bytes memory tosign1 = new bytes(32+8+1+32);
1129         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1130         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1131 
1132         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1133         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1134             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1135         }
1136 
1137         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1138     }
1139 
1140     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1141     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1142         uint minLength = length + toOffset;
1143 
1144         // Buffer too small
1145         require(to.length >= minLength); // Should be a better way?
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
1233     function safeMemoryCleaner() internal pure {
1234         assembly {
1235             let fmem := mload(0x40)
1236             codecopy(fmem, codesize, sub(msize, fmem))
1237         }
1238     }
1239 
1240 }
1241 // </ORACLIZE_API>
1242 
1243 /**+++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
1244                           - random seed come from oraclize.
1245                           - random numbers generated mixing with block parameters.
1246  ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++*/
1247 pragma solidity ~0.4.19;
1248 
1249 contract abcLottoI {
1250      uint8 public currentState; //1 - bet period, 2 - freeze period, 3 - draw period.
1251      function nextRound() public;
1252      function freeze() public;    
1253      function unfreeze() public;
1254      function draw() public;
1255      function setJackpot(uint8[5] jackpot) public;
1256 }
1257 
1258 contract abcResolverI{
1259     function getAddress() public view returns (address);
1260 }
1261 
1262 contract abcLottoController is usingOraclize{
1263     using SafeMath for *;
1264     
1265     //contants
1266     uint8 constant MAX_BET_NUM = 16;
1267     
1268     //storage varibles
1269     address public owner;
1270     abcResolverI public resolver;
1271     abcLottoI public lotto; 
1272     
1273     uint public callbackGas = 1000000;
1274     mapping(bytes32=>bool) queryIds;
1275 
1276     //events
1277     event BalanceNotEnough();
1278     event VerifyRandomProofFail(bytes32);
1279     event OnDrawFinished(uint8[5]);
1280     event OnDrawStart();     
1281 
1282     //modifier
1283     modifier abcInterface {
1284         if((address(resolver)==0)||(getCodeSize(address(resolver))==0)){
1285             if(abc_initNetwork())
1286                 lotto = abcLottoI(resolver.getAddress());
1287         }
1288         else{
1289             if(address(lotto) != resolver.getAddress())
1290                 lotto = abcLottoI(resolver.getAddress());
1291         }    
1292 
1293         _;
1294     }
1295 
1296     modifier onlyOwner {
1297         require(msg.sender == owner);
1298         _;
1299     }    
1300     
1301     /**
1302     * @dev constructor
1303     */
1304     constructor() public payable{
1305          owner = msg.sender;
1306     }
1307          
1308     /**
1309     * @dev fallback funtion, this contract should be payable.
1310     */
1311     function() public payable { }
1312     
1313     /**
1314     * @dev init resolver and lotto contract.
1315     */
1316     function abc_initNetwork() internal returns(bool) {
1317         //mainnet
1318          if (getCodeSize(0xde4413799c73a356d83ace2dc9055957c0a5c335)>0){     
1319             resolver = abcResolverI(0xde4413799c73a356d83ace2dc9055957c0a5c335);
1320             return true;
1321          }           
1322      
1323          //others ...
1324 
1325          return false;
1326     }
1327 
1328     /**
1329     * @dev get code size of _addr.
1330     */
1331     function getCodeSize(address _addr) 
1332         constant 
1333         internal 
1334         returns(uint _size) 
1335     {
1336         assembly {
1337             _size := extcodesize(_addr)
1338         }
1339     }    
1340 
1341     /**
1342     * @dev opnen next round. current round must be drawed.
1343     */
1344     function nextround() 
1345         public
1346         onlyOwner
1347         abcInterface
1348     {
1349         lotto.nextRound();
1350     }
1351     
1352     /**
1353      * @dev enter freeze period.
1354     */ 
1355     function freeze() 
1356         public
1357         onlyOwner 
1358         abcInterface 
1359     {
1360         lotto.freeze();
1361     }
1362 
1363     /**
1364      * @dev unfreeze.
1365     */ 
1366     function unfreeze() 
1367         public 
1368         onlyOwner 
1369         abcInterface 
1370     {
1371         lotto.unfreeze();
1372     }
1373     
1374     /**
1375      * @dev main operation to draw.
1376     */ 
1377     function draw() 
1378         public 
1379         onlyOwner 
1380         abcInterface 
1381         payable
1382     {
1383         lotto.draw();     
1384         drawCore();
1385         emit OnDrawStart();  
1386     }       
1387     
1388     /**
1389     * @dev recursive draw while random number generated less.
1390     */ 
1391     function drawCore() internal {
1392         bytes32 _myId;    
1393         uint N = 32; 
1394         uint delay = 0; 
1395             
1396         // set the Ledger authenticity proof 
1397         oraclize_setProof(proofType_Ledger);    
1398             
1399         if(oraclize_getPrice("random",callbackGas) > address(this).balance){
1400             emit BalanceNotEnough();
1401         }else{            
1402             _myId = oraclize_newRandomDSQuery(delay, N, callbackGas);
1403             queryIds[_myId] = true;
1404         }
1405     }     
1406     
1407     /**
1408      * @dev oraclize callback function.
1409     */ 
1410     function __callback(bytes32 _queryId, string _result, bytes _proof) public
1411     { 
1412         if (msg.sender != oraclize_cbAddress()) revert();
1413 
1414         callbackCore1(_queryId, _result, _proof);
1415     }
1416     
1417     /**
1418      * @dev deal with oraclize Ledger callback result.
1419     */ 
1420     function callbackCore1(bytes32 _queryId, string _result, bytes _proof) internal{
1421         delete queryIds[_queryId];
1422         if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) != 0) 
1423         {
1424             // proof verification failed
1425             emit VerifyRandomProofFail(_queryId);
1426             drawCore();
1427         }
1428         else{
1429             bytes32 result = RNG(_result);
1430             if(!revealJackpot(result))
1431                 drawCore();            
1432         }
1433     }
1434 
1435     /**
1436      * @dev reveal jackpot from 32 bytes random.
1437     */     
1438     function revealJackpot(bytes32 random) 
1439         internal 
1440         returns(bool)
1441     {
1442         uint i;
1443         uint j;
1444         uint8[5] memory jackpot;
1445         uint _gen = 0;
1446         
1447         for(i=0; i<32; i++){
1448             if(_gen>=5) break;
1449             uint8 _u = uint8(random[i]) % MAX_BET_NUM + 1;
1450             bool _repeat = false;
1451             for(j=0; j<_gen; j++){
1452                 if(_u == jackpot[j])
1453                     _repeat = true;
1454             }
1455             
1456             if(!_repeat){
1457                 jackpot[_gen] = _u;
1458                 _gen++;
1459             }
1460         }
1461         //recursive draw if random generated less than 5.
1462         if(_gen < 5) return false;
1463         
1464         lotto.setJackpot(jackpot);
1465         emit OnDrawFinished(jackpot);       
1466         return true;
1467     }
1468     
1469     /**
1470      * @dev random number generator.
1471      *      - use a seed from oraclize.
1472      *      - mix with block param.
1473     */ 
1474     function RNG(string seed) 
1475         internal 
1476         view 
1477         returns(bytes32)
1478     {
1479         bytes32 _ret = stringToBytes32(seed);
1480         _ret = keccak256(
1481             abi.encodePacked(
1482                 _ret ^ blockhash(block.number-1)
1483             )
1484         );
1485 
1486         _ret = keccak256(
1487             abi.encodePacked(
1488                 _ret ^ keccak256(
1489                     abi.encodePacked(
1490                         block.difficulty,
1491                         block.gaslimit.add(
1492                             block.timestamp
1493                         ),
1494                         block.coinbase
1495                     )
1496                 )                
1497             )
1498         );
1499 
1500         return _ret;
1501     }
1502     
1503     /**
1504     * @dev set oraclize callback gas.
1505     */    
1506     function setCallbackGas(uint gaslimit) public onlyOwner{
1507         callbackGas = gaslimit;
1508     }
1509 
1510     /**
1511     * @dev transfer extra ether to another.
1512     */     
1513     function transfer(address to, uint amount) public onlyOwner{
1514         require(address(this).balance > amount);
1515         to.transfer(amount);
1516     }
1517 
1518     /**
1519       * @dev set new owner      
1520       * @param newOwner The address to transfer ownership to.
1521     */
1522     function setNewOwner(address newOwner) public onlyOwner{
1523         require(newOwner != address(0x0));
1524         owner = newOwner;
1525     }
1526     
1527     /*
1528     * @dev transfer string to bytes32
1529     */
1530     function stringToBytes32(string _input)
1531         internal
1532         pure
1533         returns(bytes32)
1534     {
1535         bytes memory _temp = bytes(_input);                
1536         bytes32 _ret;
1537         assembly {
1538             _ret := mload(add(_temp, 32))
1539         }
1540         return (_ret);
1541     }   
1542 }
1543 
1544 /**
1545  * @title SafeMath : it's from openzeppelin.
1546  * @dev Math operations with safety checks that throw on error
1547  */
1548 library SafeMath {
1549   /**
1550   * @dev Multiplies two numbers, throws on overflow.
1551   */
1552   function mul(uint256 a, uint256 b) public pure returns (uint256 c) {
1553     if (a == 0) {
1554       return 0;
1555     }
1556     c = a * b;
1557     assert(c / a == b);
1558     return c;
1559   }
1560 
1561   /**
1562   * @dev Integer division of two numbers, truncating the quotient.
1563   */
1564   function div(uint256 a, uint256 b) public pure returns (uint256) {
1565     // assert(b > 0); // Solidity automatically throws when dividing by 0
1566     // uint256 c = a / b;
1567     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1568     return a / b;
1569   }
1570 
1571   /**
1572   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
1573   */
1574   function sub(uint256 a, uint256 b) public pure returns (uint256) {
1575     assert(b <= a);
1576     return a - b;
1577   }
1578 
1579   /**
1580   * @dev Adds two numbers, throws on overflow.
1581   */
1582   function add(uint256 a, uint256 b) public pure returns (uint256 c) {
1583     c = a + b;
1584     assert(c >= a);
1585     return c;
1586   }
1587 }