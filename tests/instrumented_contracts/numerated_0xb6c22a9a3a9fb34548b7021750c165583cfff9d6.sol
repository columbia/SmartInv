1 // File: 0.4-contracts/proxy_deployment/ICore.sol
2 
3 pragma solidity ^0.4.24;
4 
5 interface ICore {
6     function tokenSold(uint256 _tokenId) external;
7     function lastHorseSex() external view returns (bytes32);
8     function exists(uint256 _tokenId) external view returns (bool);
9     function balanceOf(address _owner) external view returns (uint256);
10     function ownerOf(uint256 _tokenId) external view returns (address);
11     function approve(address _approved, uint256 _tokenId) external payable;
12     function getApproved(uint256 _tokenId) external view returns (address);
13     function setApprovalForAll(address _to, bool _approved) external;
14     function getHorseSex(uint256 _horse) external view returns (bytes32);
15     function getTimestamp(uint256 _horse) external view returns (uint256);
16     function getBaseValue(uint256 _horse) external view returns (uint256);
17     function getBloodline(uint256 _horse) external view returns (bytes32);
18     function setBaseValue(uint256 _horseId, uint256 _baseValue) external;
19     function transferFrom(address _from, address _to, uint256 _tokenId) external payable;
20     function safeTransferFrom(address _from, address _to, uint256 _tokenId) external payable;
21     function isTokenApproved(address _spender, uint256 _tokenId) external view returns (bool);
22     function mintToken(address _owner, string _hash, uint256 _batchNumber) external payable returns (uint256);
23     function mintCustomHorse(address _owner, string _hash, uint256 _genotype, bytes32 _gender) external returns (uint256);
24     function createOffspring(address _owner, string _hash, uint256 _male, uint256 _female) external payable returns (uint256);
25     function getHorseData( uint256 _horse ) external view returns (string, bytes32, uint256, uint256, uint256, uint256, bytes32, bytes32);
26 }
27 
28 // File: 0.4-contracts/proxy_deployment/IBreedTypes.sol
29 
30 pragma solidity ^0.4.24;
31 
32 interface IBreedTypes {
33     function populateMatrix() external;
34     function getBreedType(uint256 _id) external view returns(bytes32);
35     function generateBreedType(uint256 _id, uint256 _father, uint256 _mother) external;
36     function setBreedingAddress(address _breeding) external;
37 }
38 
39 // File: 0.4-contracts/proxy_deployment/usingOraclize.sol
40 
41 // <ORACLIZE_API>
42 // Release targetted at solc 0.4.25 to silence compiler warning/error messages, compatible down to 0.4.22
43 /*
44 Copyright (c) 2015-2016 Oraclize SRL
45 Copyright (c) 2016 Oraclize LTD
46 
47 
48 
49 Permission is hereby granted, free of charge, to any person obtaining a copy
50 of this software and associated documentation files (the "Software"), to deal
51 in the Software without restriction, including without limitation the rights
52 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
53 copies of the Software, and to permit persons to whom the Software is
54 furnished to do so, subject to the following conditions:
55 
56 
57 
58 The above copyright notice and this permission notice shall be included in
59 all copies or substantial portions of the Software.
60 
61 
62 
63 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
64 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
65 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
66 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
67 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
68 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
69 THE SOFTWARE.
70 */
71 
72 // This api is currently targeted at 0.4.22 to 0.4.25 (stable builds), please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
73 
74 pragma solidity >= 0.4.22 < 0.5;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
75 
76 contract OraclizeI {
77     address public cbAddress;
78     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
79     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
80     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
81     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
82     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
83     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
84     function getPrice(string _datasource) public returns (uint _dsprice);
85     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
86     function setProofType(byte _proofType) external;
87     function setCustomGasPrice(uint _gasPrice) external;
88     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
89 }
90 
91 contract OraclizeAddrResolverI {
92     function getAddress() public returns (address _addr);
93 }
94 
95 /*
96 Begin solidity-cborutils
97 
98 https://github.com/smartcontractkit/solidity-cborutils
99 
100 MIT License
101 
102 Copyright (c) 2018 SmartContract ChainLink, Ltd.
103 
104 Permission is hereby granted, free of charge, to any person obtaining a copy
105 of this software and associated documentation files (the "Software"), to deal
106 in the Software without restriction, including without limitation the rights
107 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
108 copies of the Software, and to permit persons to whom the Software is
109 furnished to do so, subject to the following conditions:
110 
111 The above copyright notice and this permission notice shall be included in all
112 copies or substantial portions of the Software.
113 
114 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
115 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
116 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
117 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
118 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
119 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
120 SOFTWARE.
121  */
122 
123 library Buffer {
124     struct buffer {
125         bytes buf;
126         uint capacity;
127     }
128 
129     function init(buffer memory buf, uint _capacity) internal pure {
130         uint capacity = _capacity;
131         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
132         // Allocate space for the buffer data
133         buf.capacity = capacity;
134         assembly {
135             let ptr := mload(0x40)
136             mstore(buf, ptr)
137             mstore(ptr, 0)
138             mstore(0x40, add(ptr, capacity))
139         }
140     }
141 
142     function resize(buffer memory buf, uint capacity) private pure {
143         bytes memory oldbuf = buf.buf;
144         init(buf, capacity);
145         append(buf, oldbuf);
146     }
147 
148     function max(uint a, uint b) private pure returns(uint) {
149         if(a > b) {
150             return a;
151         }
152         return b;
153     }
154 
155     /**
156      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
157      *      would exceed the capacity of the buffer.
158      * @param buf The buffer to append to.
159      * @param data The data to append.
160      * @return The original buffer.
161      */
162     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
163         if(data.length + buf.buf.length > buf.capacity) {
164             resize(buf, max(buf.capacity, data.length) * 2);
165         }
166 
167         uint dest;
168         uint src;
169         uint len = data.length;
170         assembly {
171             // Memory address of the buffer data
172             let bufptr := mload(buf)
173             // Length of existing buffer data
174             let buflen := mload(bufptr)
175             // Start address = buffer address + buffer length + sizeof(buffer length)
176             dest := add(add(bufptr, buflen), 32)
177             // Update buffer length
178             mstore(bufptr, add(buflen, mload(data)))
179             src := add(data, 32)
180         }
181 
182         // Copy word-length chunks while possible
183         for(; len >= 32; len -= 32) {
184             assembly {
185                 mstore(dest, mload(src))
186             }
187             dest += 32;
188             src += 32;
189         }
190 
191         // Copy remaining bytes
192         uint mask = 256 ** (32 - len) - 1;
193         assembly {
194             let srcpart := and(mload(src), not(mask))
195             let destpart := and(mload(dest), mask)
196             mstore(dest, or(destpart, srcpart))
197         }
198 
199         return buf;
200     }
201 
202     /**
203      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
204      * exceed the capacity of the buffer.
205      * @param buf The buffer to append to.
206      * @param data The data to append.
207      * @return The original buffer.
208      */
209     function append(buffer memory buf, uint8 data) internal pure {
210         if(buf.buf.length + 1 > buf.capacity) {
211             resize(buf, buf.capacity * 2);
212         }
213 
214         assembly {
215             // Memory address of the buffer data
216             let bufptr := mload(buf)
217             // Length of existing buffer data
218             let buflen := mload(bufptr)
219             // Address = buffer address + buffer length + sizeof(buffer length)
220             let dest := add(add(bufptr, buflen), 32)
221             mstore8(dest, data)
222             // Update buffer length
223             mstore(bufptr, add(buflen, 1))
224         }
225     }
226 
227     /**
228      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
229      * exceed the capacity of the buffer.
230      * @param buf The buffer to append to.
231      * @param data The data to append.
232      * @return The original buffer.
233      */
234     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
235         if(len + buf.buf.length > buf.capacity) {
236             resize(buf, max(buf.capacity, len) * 2);
237         }
238 
239         uint mask = 256 ** len - 1;
240         assembly {
241             // Memory address of the buffer data
242             let bufptr := mload(buf)
243             // Length of existing buffer data
244             let buflen := mload(bufptr)
245             // Address = buffer address + buffer length + sizeof(buffer length) + len
246             let dest := add(add(bufptr, buflen), len)
247             mstore(dest, or(and(mload(dest), not(mask)), data))
248             // Update buffer length
249             mstore(bufptr, add(buflen, len))
250         }
251         return buf;
252     }
253 }
254 
255 library CBOR {
256     using Buffer for Buffer.buffer;
257 
258     uint8 private constant MAJOR_TYPE_INT = 0;
259     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
260     uint8 private constant MAJOR_TYPE_BYTES = 2;
261     uint8 private constant MAJOR_TYPE_STRING = 3;
262     uint8 private constant MAJOR_TYPE_ARRAY = 4;
263     uint8 private constant MAJOR_TYPE_MAP = 5;
264     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
265 
266     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
267         if(value <= 23) {
268             buf.append(uint8((major << 5) | value));
269         } else if(value <= 0xFF) {
270             buf.append(uint8((major << 5) | 24));
271             buf.appendInt(value, 1);
272         } else if(value <= 0xFFFF) {
273             buf.append(uint8((major << 5) | 25));
274             buf.appendInt(value, 2);
275         } else if(value <= 0xFFFFFFFF) {
276             buf.append(uint8((major << 5) | 26));
277             buf.appendInt(value, 4);
278         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
279             buf.append(uint8((major << 5) | 27));
280             buf.appendInt(value, 8);
281         }
282     }
283 
284     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
285         buf.append(uint8((major << 5) | 31));
286     }
287 
288     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
289         encodeType(buf, MAJOR_TYPE_INT, value);
290     }
291 
292     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
293         if(value >= 0) {
294             encodeType(buf, MAJOR_TYPE_INT, uint(value));
295         } else {
296             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
297         }
298     }
299 
300     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
301         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
302         buf.append(value);
303     }
304 
305     function encodeString(Buffer.buffer memory buf, string value) internal pure {
306         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
307         buf.append(bytes(value));
308     }
309 
310     function startArray(Buffer.buffer memory buf) internal pure {
311         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
312     }
313 
314     function startMap(Buffer.buffer memory buf) internal pure {
315         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
316     }
317 
318     function endSequence(Buffer.buffer memory buf) internal pure {
319         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
320     }
321 }
322 
323 /*
324 End solidity-cborutils
325  */
326 
327 contract usingOraclize {
328     uint constant day = 60*60*24;
329     uint constant week = 60*60*24*7;
330     uint constant month = 60*60*24*30;
331     byte constant proofType_NONE = 0x00;
332     byte constant proofType_TLSNotary = 0x10;
333     byte constant proofType_Ledger = 0x30;
334     byte constant proofType_Android = 0x40;
335     byte constant proofType_Native = 0xF0;
336     byte constant proofStorage_IPFS = 0x01;
337     uint8 constant networkID_auto = 0;
338     uint8 constant networkID_mainnet = 1;
339     uint8 constant networkID_testnet = 2;
340     uint8 constant networkID_morden = 2;
341     uint8 constant networkID_consensys = 161;
342 
343     OraclizeAddrResolverI OAR;
344 
345     OraclizeI oraclize;
346     modifier oraclizeAPI {
347         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
348             oraclize_setNetwork(networkID_auto);
349 
350         if(address(oraclize) != OAR.getAddress())
351             oraclize = OraclizeI(OAR.getAddress());
352 
353         _;
354     }
355     modifier coupon(string code){
356         oraclize = OraclizeI(OAR.getAddress());
357         _;
358     }
359 
360     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
361       return oraclize_setNetwork();
362       networkID; // silence the warning and remain backwards compatible
363     }
364     function oraclize_setNetwork() internal returns(bool){
365         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
366             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
367             oraclize_setNetworkName("eth_mainnet");
368             return true;
369         }
370         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
371             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
372             oraclize_setNetworkName("eth_ropsten3");
373             return true;
374         }
375         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
376             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
377             oraclize_setNetworkName("eth_kovan");
378             return true;
379         }
380         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
381             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
382             oraclize_setNetworkName("eth_rinkeby");
383             return true;
384         }
385         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
386             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
387             return true;
388         }
389         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
390             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
391             return true;
392         }
393         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
394             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
395             return true;
396         }
397         return false;
398     }
399 
400     function __callback(bytes32 myid, string result) public {
401         __callback(myid, result, new bytes(0));
402     }
403     function __callback(bytes32 myid, string result, bytes proof) public {
404       return;
405       // Following should never be reached with a preceding return, however
406       // this is just a placeholder function, ideally meant to be defined in
407       // child contract when proofs are used
408       myid; result; proof; // Silence compiler warnings
409       oraclize = OraclizeI(0); // Additional compiler silence about making function pure/view.
410     }
411 
412     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
413         return oraclize.getPrice(datasource);
414     }
415 
416     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
417         return oraclize.getPrice(datasource, gaslimit);
418     }
419 
420     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
421         uint price = oraclize.getPrice(datasource);
422         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
423         return oraclize.query.value(price)(0, datasource, arg);
424     }
425     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
426         uint price = oraclize.getPrice(datasource);
427         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
428         return oraclize.query.value(price)(timestamp, datasource, arg);
429     }
430     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
431         uint price = oraclize.getPrice(datasource, gaslimit);
432         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
433         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
434     }
435     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
436         uint price = oraclize.getPrice(datasource, gaslimit);
437         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
438         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
439     }
440     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
441         uint price = oraclize.getPrice(datasource);
442         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
443         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
444     }
445     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
446         uint price = oraclize.getPrice(datasource);
447         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
448         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
449     }
450     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
451         uint price = oraclize.getPrice(datasource, gaslimit);
452         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
453         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
454     }
455     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
456         uint price = oraclize.getPrice(datasource, gaslimit);
457         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
458         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
459     }
460     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
461         uint price = oraclize.getPrice(datasource);
462         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
463         bytes memory args = stra2cbor(argN);
464         return oraclize.queryN.value(price)(0, datasource, args);
465     }
466     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
467         uint price = oraclize.getPrice(datasource);
468         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
469         bytes memory args = stra2cbor(argN);
470         return oraclize.queryN.value(price)(timestamp, datasource, args);
471     }
472     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
473         uint price = oraclize.getPrice(datasource, gaslimit);
474         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
475         bytes memory args = stra2cbor(argN);
476         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
477     }
478     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
479         uint price = oraclize.getPrice(datasource, gaslimit);
480         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
481         bytes memory args = stra2cbor(argN);
482         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
483     }
484     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
485         string[] memory dynargs = new string[](1);
486         dynargs[0] = args[0];
487         return oraclize_query(datasource, dynargs);
488     }
489     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
490         string[] memory dynargs = new string[](1);
491         dynargs[0] = args[0];
492         return oraclize_query(timestamp, datasource, dynargs);
493     }
494     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
495         string[] memory dynargs = new string[](1);
496         dynargs[0] = args[0];
497         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
498     }
499     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
500         string[] memory dynargs = new string[](1);
501         dynargs[0] = args[0];
502         return oraclize_query(datasource, dynargs, gaslimit);
503     }
504 
505     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
506         string[] memory dynargs = new string[](2);
507         dynargs[0] = args[0];
508         dynargs[1] = args[1];
509         return oraclize_query(datasource, dynargs);
510     }
511     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
512         string[] memory dynargs = new string[](2);
513         dynargs[0] = args[0];
514         dynargs[1] = args[1];
515         return oraclize_query(timestamp, datasource, dynargs);
516     }
517     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
518         string[] memory dynargs = new string[](2);
519         dynargs[0] = args[0];
520         dynargs[1] = args[1];
521         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
522     }
523     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
524         string[] memory dynargs = new string[](2);
525         dynargs[0] = args[0];
526         dynargs[1] = args[1];
527         return oraclize_query(datasource, dynargs, gaslimit);
528     }
529     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
530         string[] memory dynargs = new string[](3);
531         dynargs[0] = args[0];
532         dynargs[1] = args[1];
533         dynargs[2] = args[2];
534         return oraclize_query(datasource, dynargs);
535     }
536     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
537         string[] memory dynargs = new string[](3);
538         dynargs[0] = args[0];
539         dynargs[1] = args[1];
540         dynargs[2] = args[2];
541         return oraclize_query(timestamp, datasource, dynargs);
542     }
543     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
544         string[] memory dynargs = new string[](3);
545         dynargs[0] = args[0];
546         dynargs[1] = args[1];
547         dynargs[2] = args[2];
548         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
549     }
550     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
551         string[] memory dynargs = new string[](3);
552         dynargs[0] = args[0];
553         dynargs[1] = args[1];
554         dynargs[2] = args[2];
555         return oraclize_query(datasource, dynargs, gaslimit);
556     }
557 
558     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
559         string[] memory dynargs = new string[](4);
560         dynargs[0] = args[0];
561         dynargs[1] = args[1];
562         dynargs[2] = args[2];
563         dynargs[3] = args[3];
564         return oraclize_query(datasource, dynargs);
565     }
566     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
567         string[] memory dynargs = new string[](4);
568         dynargs[0] = args[0];
569         dynargs[1] = args[1];
570         dynargs[2] = args[2];
571         dynargs[3] = args[3];
572         return oraclize_query(timestamp, datasource, dynargs);
573     }
574     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
575         string[] memory dynargs = new string[](4);
576         dynargs[0] = args[0];
577         dynargs[1] = args[1];
578         dynargs[2] = args[2];
579         dynargs[3] = args[3];
580         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
581     }
582     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
583         string[] memory dynargs = new string[](4);
584         dynargs[0] = args[0];
585         dynargs[1] = args[1];
586         dynargs[2] = args[2];
587         dynargs[3] = args[3];
588         return oraclize_query(datasource, dynargs, gaslimit);
589     }
590     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
591         string[] memory dynargs = new string[](5);
592         dynargs[0] = args[0];
593         dynargs[1] = args[1];
594         dynargs[2] = args[2];
595         dynargs[3] = args[3];
596         dynargs[4] = args[4];
597         return oraclize_query(datasource, dynargs);
598     }
599     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
600         string[] memory dynargs = new string[](5);
601         dynargs[0] = args[0];
602         dynargs[1] = args[1];
603         dynargs[2] = args[2];
604         dynargs[3] = args[3];
605         dynargs[4] = args[4];
606         return oraclize_query(timestamp, datasource, dynargs);
607     }
608     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
609         string[] memory dynargs = new string[](5);
610         dynargs[0] = args[0];
611         dynargs[1] = args[1];
612         dynargs[2] = args[2];
613         dynargs[3] = args[3];
614         dynargs[4] = args[4];
615         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
616     }
617     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
618         string[] memory dynargs = new string[](5);
619         dynargs[0] = args[0];
620         dynargs[1] = args[1];
621         dynargs[2] = args[2];
622         dynargs[3] = args[3];
623         dynargs[4] = args[4];
624         return oraclize_query(datasource, dynargs, gaslimit);
625     }
626     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
627         uint price = oraclize.getPrice(datasource);
628         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
629         bytes memory args = ba2cbor(argN);
630         return oraclize.queryN.value(price)(0, datasource, args);
631     }
632     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
633         uint price = oraclize.getPrice(datasource);
634         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
635         bytes memory args = ba2cbor(argN);
636         return oraclize.queryN.value(price)(timestamp, datasource, args);
637     }
638     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
639         uint price = oraclize.getPrice(datasource, gaslimit);
640         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
641         bytes memory args = ba2cbor(argN);
642         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
643     }
644     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
645         uint price = oraclize.getPrice(datasource, gaslimit);
646         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
647         bytes memory args = ba2cbor(argN);
648         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
649     }
650     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
651         bytes[] memory dynargs = new bytes[](1);
652         dynargs[0] = args[0];
653         return oraclize_query(datasource, dynargs);
654     }
655     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
656         bytes[] memory dynargs = new bytes[](1);
657         dynargs[0] = args[0];
658         return oraclize_query(timestamp, datasource, dynargs);
659     }
660     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
661         bytes[] memory dynargs = new bytes[](1);
662         dynargs[0] = args[0];
663         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
664     }
665     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
666         bytes[] memory dynargs = new bytes[](1);
667         dynargs[0] = args[0];
668         return oraclize_query(datasource, dynargs, gaslimit);
669     }
670 
671     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
672         bytes[] memory dynargs = new bytes[](2);
673         dynargs[0] = args[0];
674         dynargs[1] = args[1];
675         return oraclize_query(datasource, dynargs);
676     }
677     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
678         bytes[] memory dynargs = new bytes[](2);
679         dynargs[0] = args[0];
680         dynargs[1] = args[1];
681         return oraclize_query(timestamp, datasource, dynargs);
682     }
683     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
684         bytes[] memory dynargs = new bytes[](2);
685         dynargs[0] = args[0];
686         dynargs[1] = args[1];
687         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
688     }
689     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
690         bytes[] memory dynargs = new bytes[](2);
691         dynargs[0] = args[0];
692         dynargs[1] = args[1];
693         return oraclize_query(datasource, dynargs, gaslimit);
694     }
695     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
696         bytes[] memory dynargs = new bytes[](3);
697         dynargs[0] = args[0];
698         dynargs[1] = args[1];
699         dynargs[2] = args[2];
700         return oraclize_query(datasource, dynargs);
701     }
702     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
703         bytes[] memory dynargs = new bytes[](3);
704         dynargs[0] = args[0];
705         dynargs[1] = args[1];
706         dynargs[2] = args[2];
707         return oraclize_query(timestamp, datasource, dynargs);
708     }
709     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
710         bytes[] memory dynargs = new bytes[](3);
711         dynargs[0] = args[0];
712         dynargs[1] = args[1];
713         dynargs[2] = args[2];
714         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
715     }
716     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
717         bytes[] memory dynargs = new bytes[](3);
718         dynargs[0] = args[0];
719         dynargs[1] = args[1];
720         dynargs[2] = args[2];
721         return oraclize_query(datasource, dynargs, gaslimit);
722     }
723 
724     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
725         bytes[] memory dynargs = new bytes[](4);
726         dynargs[0] = args[0];
727         dynargs[1] = args[1];
728         dynargs[2] = args[2];
729         dynargs[3] = args[3];
730         return oraclize_query(datasource, dynargs);
731     }
732     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
733         bytes[] memory dynargs = new bytes[](4);
734         dynargs[0] = args[0];
735         dynargs[1] = args[1];
736         dynargs[2] = args[2];
737         dynargs[3] = args[3];
738         return oraclize_query(timestamp, datasource, dynargs);
739     }
740     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
741         bytes[] memory dynargs = new bytes[](4);
742         dynargs[0] = args[0];
743         dynargs[1] = args[1];
744         dynargs[2] = args[2];
745         dynargs[3] = args[3];
746         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
747     }
748     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
749         bytes[] memory dynargs = new bytes[](4);
750         dynargs[0] = args[0];
751         dynargs[1] = args[1];
752         dynargs[2] = args[2];
753         dynargs[3] = args[3];
754         return oraclize_query(datasource, dynargs, gaslimit);
755     }
756     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
757         bytes[] memory dynargs = new bytes[](5);
758         dynargs[0] = args[0];
759         dynargs[1] = args[1];
760         dynargs[2] = args[2];
761         dynargs[3] = args[3];
762         dynargs[4] = args[4];
763         return oraclize_query(datasource, dynargs);
764     }
765     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
766         bytes[] memory dynargs = new bytes[](5);
767         dynargs[0] = args[0];
768         dynargs[1] = args[1];
769         dynargs[2] = args[2];
770         dynargs[3] = args[3];
771         dynargs[4] = args[4];
772         return oraclize_query(timestamp, datasource, dynargs);
773     }
774     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
775         bytes[] memory dynargs = new bytes[](5);
776         dynargs[0] = args[0];
777         dynargs[1] = args[1];
778         dynargs[2] = args[2];
779         dynargs[3] = args[3];
780         dynargs[4] = args[4];
781         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
782     }
783     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
784         bytes[] memory dynargs = new bytes[](5);
785         dynargs[0] = args[0];
786         dynargs[1] = args[1];
787         dynargs[2] = args[2];
788         dynargs[3] = args[3];
789         dynargs[4] = args[4];
790         return oraclize_query(datasource, dynargs, gaslimit);
791     }
792 
793     function oraclize_cbAddress() oraclizeAPI internal returns (address){
794         return oraclize.cbAddress();
795     }
796     function oraclize_setProof(byte proofP) oraclizeAPI internal {
797         return oraclize.setProofType(proofP);
798     }
799     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
800         return oraclize.setCustomGasPrice(gasPrice);
801     }
802 
803     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
804         return oraclize.randomDS_getSessionPubKeyHash();
805     }
806 
807     function getCodeSize(address _addr) view internal returns(uint _size) {
808         assembly {
809             _size := extcodesize(_addr)
810         }
811     }
812 
813     function parseAddr(string _a) internal pure returns (address){
814         bytes memory tmp = bytes(_a);
815         uint160 iaddr = 0;
816         uint160 b1;
817         uint160 b2;
818         for (uint i=2; i<2+2*20; i+=2){
819             iaddr *= 256;
820             b1 = uint160(tmp[i]);
821             b2 = uint160(tmp[i+1]);
822             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
823             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
824             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
825             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
826             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
827             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
828             iaddr += (b1*16+b2);
829         }
830         return address(iaddr);
831     }
832 
833     function strCompare(string _a, string _b) internal pure returns (int) {
834         bytes memory a = bytes(_a);
835         bytes memory b = bytes(_b);
836         uint minLength = a.length;
837         if (b.length < minLength) minLength = b.length;
838         for (uint i = 0; i < minLength; i ++)
839             if (a[i] < b[i])
840                 return -1;
841             else if (a[i] > b[i])
842                 return 1;
843         if (a.length < b.length)
844             return -1;
845         else if (a.length > b.length)
846             return 1;
847         else
848             return 0;
849     }
850 
851     function indexOf(string _haystack, string _needle) internal pure returns (int) {
852         bytes memory h = bytes(_haystack);
853         bytes memory n = bytes(_needle);
854         if(h.length < 1 || n.length < 1 || (n.length > h.length))
855             return -1;
856         else if(h.length > (2**128 -1))
857             return -1;
858         else
859         {
860             uint subindex = 0;
861             for (uint i = 0; i < h.length; i ++)
862             {
863                 if (h[i] == n[0])
864                 {
865                     subindex = 1;
866                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
867                     {
868                         subindex++;
869                     }
870                     if(subindex == n.length)
871                         return int(i);
872                 }
873             }
874             return -1;
875         }
876     }
877 
878     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
879         bytes memory _ba = bytes(_a);
880         bytes memory _bb = bytes(_b);
881         bytes memory _bc = bytes(_c);
882         bytes memory _bd = bytes(_d);
883         bytes memory _be = bytes(_e);
884         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
885         bytes memory babcde = bytes(abcde);
886         uint k = 0;
887         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
888         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
889         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
890         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
891         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
892         return string(babcde);
893     }
894 
895     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
896         return strConcat(_a, _b, _c, _d, "");
897     }
898 
899     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
900         return strConcat(_a, _b, _c, "", "");
901     }
902 
903     function strConcat(string _a, string _b) internal pure returns (string) {
904         return strConcat(_a, _b, "", "", "");
905     }
906 
907     // parseInt
908     function parseInt(string _a) internal pure returns (uint) {
909         return parseInt(_a, 0);
910     }
911 
912     // parseInt(parseFloat*10^_b)
913     function parseInt(string _a, uint _b) internal pure returns (uint) {
914         bytes memory bresult = bytes(_a);
915         uint mint = 0;
916         bool decimals = false;
917         for (uint i=0; i<bresult.length; i++){
918             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
919                 if (decimals){
920                    if (_b == 0) break;
921                     else _b--;
922                 }
923                 mint *= 10;
924                 mint += uint(bresult[i]) - 48;
925             } else if (bresult[i] == 46) decimals = true;
926         }
927         if (_b > 0) mint *= 10**_b;
928         return mint;
929     }
930 
931     function uint2str(uint i) internal pure returns (string){
932         if (i == 0) return "0";
933         uint j = i;
934         uint len;
935         while (j != 0){
936             len++;
937             j /= 10;
938         }
939         bytes memory bstr = new bytes(len);
940         uint k = len - 1;
941         while (i != 0){
942             bstr[k--] = byte(48 + i % 10);
943             i /= 10;
944         }
945         return string(bstr);
946     }
947 
948     using CBOR for Buffer.buffer;
949     function stra2cbor(string[] arr) internal pure returns (bytes) {
950         safeMemoryCleaner();
951         Buffer.buffer memory buf;
952         Buffer.init(buf, 1024);
953         buf.startArray();
954         for (uint i = 0; i < arr.length; i++) {
955             buf.encodeString(arr[i]);
956         }
957         buf.endSequence();
958         return buf.buf;
959     }
960 
961     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
962         safeMemoryCleaner();
963         Buffer.buffer memory buf;
964         Buffer.init(buf, 1024);
965         buf.startArray();
966         for (uint i = 0; i < arr.length; i++) {
967             buf.encodeBytes(arr[i]);
968         }
969         buf.endSequence();
970         return buf.buf;
971     }
972 
973     string oraclize_network_name;
974     function oraclize_setNetworkName(string _network_name) internal {
975         oraclize_network_name = _network_name;
976     }
977 
978     function oraclize_getNetworkName() internal view returns (string) {
979         return oraclize_network_name;
980     }
981 
982     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
983         require((_nbytes > 0) && (_nbytes <= 32));
984         // Convert from seconds to ledger timer ticks
985         _delay *= 10;
986         bytes memory nbytes = new bytes(1);
987         nbytes[0] = byte(_nbytes);
988         bytes memory unonce = new bytes(32);
989         bytes memory sessionKeyHash = new bytes(32);
990         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
991         assembly {
992             mstore(unonce, 0x20)
993             // the following variables can be relaxed
994             // check relaxed random contract under ethereum-examples repo
995             // for an idea on how to override and replace comit hash vars
996             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
997             mstore(sessionKeyHash, 0x20)
998             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
999         }
1000         bytes memory delay = new bytes(32);
1001         assembly {
1002             mstore(add(delay, 0x20), _delay)
1003         }
1004 
1005         bytes memory delay_bytes8 = new bytes(8);
1006         copyBytes(delay, 24, 8, delay_bytes8, 0);
1007 
1008         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1009         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1010 
1011         bytes memory delay_bytes8_left = new bytes(8);
1012 
1013         assembly {
1014             let x := mload(add(delay_bytes8, 0x20))
1015             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1016             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1017             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1018             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1019             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1020             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1021             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1022             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1023 
1024         }
1025 
1026         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1027         return queryId;
1028     }
1029 
1030     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1031         oraclize_randomDS_args[queryId] = commitment;
1032     }
1033 
1034     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1035     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1036 
1037     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1038         bool sigok;
1039         address signer;
1040 
1041         bytes32 sigr;
1042         bytes32 sigs;
1043 
1044         bytes memory sigr_ = new bytes(32);
1045         uint offset = 4+(uint(dersig[3]) - 0x20);
1046         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1047         bytes memory sigs_ = new bytes(32);
1048         offset += 32 + 2;
1049         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1050 
1051         assembly {
1052             sigr := mload(add(sigr_, 32))
1053             sigs := mload(add(sigs_, 32))
1054         }
1055 
1056 
1057         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1058         if (address(keccak256(pubkey)) == signer) return true;
1059         else {
1060             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1061             return (address(keccak256(pubkey)) == signer);
1062         }
1063     }
1064 
1065     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1066         bool sigok;
1067 
1068         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1069         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1070         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1071 
1072         bytes memory appkey1_pubkey = new bytes(64);
1073         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1074 
1075         bytes memory tosign2 = new bytes(1+65+32);
1076         tosign2[0] = byte(1); //role
1077         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1078         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1079         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1080         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1081 
1082         if (sigok == false) return false;
1083 
1084 
1085         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1086         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1087 
1088         bytes memory tosign3 = new bytes(1+65);
1089         tosign3[0] = 0xFE;
1090         copyBytes(proof, 3, 65, tosign3, 1);
1091 
1092         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1093         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1094 
1095         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1096 
1097         return sigok;
1098     }
1099 
1100     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1101         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1102         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1103 
1104         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1105         require(proofVerified);
1106 
1107         _;
1108     }
1109 
1110     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1111         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1112         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1113 
1114         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1115         if (proofVerified == false) return 2;
1116 
1117         return 0;
1118     }
1119 
1120     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1121         bool match_ = true;
1122 
1123         require(prefix.length == n_random_bytes);
1124 
1125         for (uint256 i=0; i< n_random_bytes; i++) {
1126             if (content[i] != prefix[i]) match_ = false;
1127         }
1128 
1129         return match_;
1130     }
1131 
1132     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1133 
1134         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1135         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1136         bytes memory keyhash = new bytes(32);
1137         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1138         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(context_name, queryId)))))) return false;
1139 
1140         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1141         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1142 
1143         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1144         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1145 
1146         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1147         // This is to verify that the computed args match with the ones specified in the query.
1148         bytes memory commitmentSlice1 = new bytes(8+1+32);
1149         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1150 
1151         bytes memory sessionPubkey = new bytes(64);
1152         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1153         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1154 
1155         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1156         if (oraclize_randomDS_args[queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))){ //unonce, nbytes and sessionKeyHash match
1157             delete oraclize_randomDS_args[queryId];
1158         } else return false;
1159 
1160 
1161         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1162         bytes memory tosign1 = new bytes(32+8+1+32);
1163         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1164         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1165 
1166         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1167         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1168             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1169         }
1170 
1171         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1172     }
1173 
1174     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1175     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1176         uint minLength = length + toOffset;
1177 
1178         // Buffer too small
1179         require(to.length >= minLength); // Should be a better way?
1180 
1181         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1182         uint i = 32 + fromOffset;
1183         uint j = 32 + toOffset;
1184 
1185         while (i < (32 + fromOffset + length)) {
1186             assembly {
1187                 let tmp := mload(add(from, i))
1188                 mstore(add(to, j), tmp)
1189             }
1190             i += 32;
1191             j += 32;
1192         }
1193 
1194         return to;
1195     }
1196 
1197     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1198     // Duplicate Solidity's ecrecover, but catching the CALL return value
1199     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1200         // We do our own memory management here. Solidity uses memory offset
1201         // 0x40 to store the current end of memory. We write past it (as
1202         // writes are memory extensions), but don't update the offset so
1203         // Solidity will reuse it. The memory used here is only needed for
1204         // this context.
1205 
1206         // FIXME: inline assembly can't access return values
1207         bool ret;
1208         address addr;
1209 
1210         assembly {
1211             let size := mload(0x40)
1212             mstore(size, hash)
1213             mstore(add(size, 32), v)
1214             mstore(add(size, 64), r)
1215             mstore(add(size, 96), s)
1216 
1217             // NOTE: we can reuse the request memory because we deal with
1218             //       the return code
1219             ret := call(3000, 1, 0, size, 128, size, 32)
1220             addr := mload(size)
1221         }
1222 
1223         return (ret, addr);
1224     }
1225 
1226     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1227     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1228         bytes32 r;
1229         bytes32 s;
1230         uint8 v;
1231 
1232         if (sig.length != 65)
1233           return (false, 0);
1234 
1235         // The signature format is a compact form of:
1236         //   {bytes32 r}{bytes32 s}{uint8 v}
1237         // Compact means, uint8 is not padded to 32 bytes.
1238         assembly {
1239             r := mload(add(sig, 32))
1240             s := mload(add(sig, 64))
1241 
1242             // Here we are loading the last 32 bytes. We exploit the fact that
1243             // 'mload' will pad with zeroes if we overread.
1244             // There is no 'mload8' to do this, but that would be nicer.
1245             v := byte(0, mload(add(sig, 96)))
1246 
1247             // Alternative solution:
1248             // 'byte' is not working due to the Solidity parser, so lets
1249             // use the second best option, 'and'
1250             // v := and(mload(add(sig, 65)), 255)
1251         }
1252 
1253         // albeit non-transactional signatures are not specified by the YP, one would expect it
1254         // to match the YP range of [27, 28]
1255         //
1256         // geth uses [0, 1] and some clients have followed. This might change, see:
1257         //  https://github.com/ethereum/go-ethereum/issues/2053
1258         if (v < 27)
1259           v += 27;
1260 
1261         if (v != 27 && v != 28)
1262             return (false, 0);
1263 
1264         return safer_ecrecover(hash, v, r, s);
1265     }
1266 
1267     function safeMemoryCleaner() internal pure {
1268         assembly {
1269             let fmem := mload(0x40)
1270             codecopy(fmem, codesize, sub(msize, fmem))
1271         }
1272     }
1273 
1274 }
1275 // </ORACLIZE_API>
1276 
1277 // File: 0.4-contracts/proxy_deployment/Roles.sol
1278 
1279 pragma solidity ^0.4.24;
1280 
1281 /**
1282  * @title Roles
1283  * @dev Library for managing addresses assigned to a Role.
1284  */
1285 library Roles {
1286     struct Role {
1287         mapping (address => bool) bearer;
1288     }
1289 
1290     /**
1291      * @dev give an account access to this role
1292      */
1293     function add(Role storage role, address account) internal {
1294         require(account != address(0), "add: invalid account address");
1295         require(!has(role, account), "add: account is already added");
1296 
1297         role.bearer[account] = true;
1298     }
1299 
1300     /**
1301      * @dev remove an account's access to this role
1302      */
1303     function remove(Role storage role, address account) internal {
1304         require(account != address(0), "remove: invalid account address");
1305         require(has(role, account), "add: account is not defined");
1306 
1307         role.bearer[account] = false;
1308     }
1309 
1310     /**
1311      * @dev check if an account has this role
1312      * @return bool
1313      */
1314     function has(Role storage role, address account) internal view returns (bool) {
1315         require(account != address(0), "has: invalid account address");
1316         return role.bearer[account];
1317     }
1318 }
1319 
1320 // File: 0.4-contracts/proxy_deployment/StudServiceAdmin.sol
1321 
1322 pragma solidity ^0.4.24;
1323 
1324 
1325 contract StudServiceAdmin {
1326     using Roles for Roles.Role;
1327 
1328     event StudServiceAdminAdded(address indexed account);
1329     event StudServiceAdminRemoved(address indexed account);
1330 
1331     Roles.Role private _StudServiceAdmins;
1332 
1333     constructor () internal {
1334         _addStudServiceAdmin(msg.sender);
1335     }
1336 
1337     modifier onlyStudServiceAdmin() {
1338         require(isStudServiceAdmin(msg.sender));
1339         _;
1340     }
1341 
1342     function isStudServiceAdmin(address account) public view returns (bool) {
1343         return _StudServiceAdmins.has(account);
1344     }
1345 
1346     function addStudServiceAdmin(address account) public onlyStudServiceAdmin {
1347         _addStudServiceAdmin(account);
1348     }
1349 
1350     function renounceStudServiceAdmin() public onlyStudServiceAdmin {
1351         _removeStudServiceAdmin(msg.sender);
1352     }
1353 
1354     function _addStudServiceAdmin(address account) internal {
1355         _StudServiceAdmins.add(account);
1356         emit StudServiceAdminAdded(account);
1357     }
1358 
1359     function _removeStudServiceAdmin(address account) internal {
1360         _StudServiceAdmins.remove(account);
1361         emit StudServiceAdminRemoved(account);
1362     }
1363 }
1364 
1365 // File: openzeppelin-eth/contracts/math/SafeMath.sol
1366 
1367 pragma solidity ^0.4.24;
1368 
1369 
1370 /**
1371  * @title SafeMath
1372  * @dev Math operations with safety checks that revert on error
1373  */
1374 library SafeMath {
1375 
1376   /**
1377   * @dev Multiplies two numbers, reverts on overflow.
1378   */
1379   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1380     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1381     // benefit is lost if 'b' is also tested.
1382     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1383     if (a == 0) {
1384       return 0;
1385     }
1386 
1387     uint256 c = a * b;
1388     require(c / a == b);
1389 
1390     return c;
1391   }
1392 
1393   /**
1394   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
1395   */
1396   function div(uint256 a, uint256 b) internal pure returns (uint256) {
1397     require(b > 0); // Solidity only automatically asserts when dividing by 0
1398     uint256 c = a / b;
1399     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1400 
1401     return c;
1402   }
1403 
1404   /**
1405   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
1406   */
1407   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1408     require(b <= a);
1409     uint256 c = a - b;
1410 
1411     return c;
1412   }
1413 
1414   /**
1415   * @dev Adds two numbers, reverts on overflow.
1416   */
1417   function add(uint256 a, uint256 b) internal pure returns (uint256) {
1418     uint256 c = a + b;
1419     require(c >= a);
1420 
1421     return c;
1422   }
1423 
1424   /**
1425   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
1426   * reverts when dividing by zero.
1427   */
1428   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1429     require(b != 0);
1430     return a % b;
1431   }
1432 }
1433 
1434 // File: 0.4-contracts/proxy_deployment/StudServiceV3.sol
1435 
1436 pragma solidity ^0.4.24;
1437 
1438 
1439 
1440 
1441 
1442 
1443 /*
1444  * @description StudServiceV3 introducing the updated model with getters and fixes. Refer to StudServiceV2 for the old one.
1445  */
1446 contract StudServiceV3 is StudServiceAdmin, usingOraclize {
1447     using SafeMath for uint256;
1448 
1449     uint256 private _baseFee;
1450     uint256[] private _horsesInStud;
1451     string private _oraclizeUrl;
1452 
1453     ICore private _core;
1454     IBreedTypes private _breedTypes;
1455 
1456     struct StudInfo {
1457         bool inStud;
1458         uint256 matingPrice;
1459         uint256 duration;
1460         uint256 studCreatedAt;
1461     }
1462 
1463     mapping(uint256 => bool) private _timeframes;
1464     mapping(uint256 => StudInfo) private _studs;
1465     mapping(uint256 => uint256) private _horseIndex;
1466     mapping(uint256 => bool) private _currentlyInStud;
1467     mapping(bytes32 => uint256) private _bloodlineWeights;
1468     mapping(bytes32 => uint256) private _breedTypeWeights;
1469 
1470     event HorseInStud(
1471         uint256 horseId,
1472         uint256 matingPrice,
1473         uint256 duration,
1474         uint256 timestamp
1475     );
1476     event HorseDisabledFromStud(uint256 horseId, uint256 timestamp);
1477     event HorseRemovedFromStud(uint256 horseId, uint256 timestamp);
1478 
1479     modifier onlyHorseOwner(uint256 horseId) {
1480         require(msg.sender == _core.ownerOf(horseId), "SS notOwnerOfHorse");
1481         _;
1482     }
1483 
1484     /*
1485      *  @dev We only remove the horse from the mapping ONCE the '__callback' is called, this is for a reason.
1486      *  For Studs we use Oraclize as a service for queries in the future but we also have a function
1487      *  to manually remove the horse from stud but this does not cancel the
1488      *  query that was already sent, so the horse is blocked from being in Stud again until the
1489      *  callback is called and effectively removing it from stud.
1490      *
1491      *  Main case: User puts horse in stud, horse is manually removed, horse is put in stud
1492      *  again thus creating another query, this time the user decides to leave the horse
1493      *  for the whole period of time but the first query which couldn't be cancelled is
1494      *  executed, calling the '__callback' function and removing the horse from Stud and leaving
1495      *  yet another query in air.
1496      */
1497 
1498     constructor (ICore core, IBreedTypes breedTypes) public {
1499         // Set core and breedtypes contracts
1500         _core = core;
1501         _breedTypes = breedTypes;
1502 
1503         // Nakamoto - Szabo - Finney - Buterin
1504         _bloodlineWeights[bytes32("N")] = 180;
1505         _bloodlineWeights[bytes32("S")] = 120;
1506         _bloodlineWeights[bytes32("F")] = 40;
1507         _bloodlineWeights[bytes32("B")] = 15;
1508 
1509         // Genesis - Legendary - Exclusive - Elite - Cross - Pacer
1510         _breedTypeWeights[bytes32("genesis")] = 180;
1511         _breedTypeWeights[bytes32("legendary")] = 150;
1512         _breedTypeWeights[bytes32("exclusive")] = 120;
1513         _breedTypeWeights[bytes32("elite")] = 90;
1514         _breedTypeWeights[bytes32("cross")] = 80;
1515         _breedTypeWeights[bytes32("pacer")] = 60;
1516 
1517         _timeframes[86400] = true;
1518         _timeframes[259200] = true;
1519         _timeframes[604800] = true;
1520 
1521         _baseFee = 0.05 ether;
1522         _oraclizeUrl = "json(https://api.zed.run/api/v1/remove_horse_stud).horse_id";
1523 
1524         // OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
1525     }
1526 
1527     function() external payable {
1528         // empty fallback method
1529     }
1530 
1531     /*      USERS PUBLIC METHODS      */
1532 
1533     /*
1534      *  @dev We don't need to check here if the horse is on sale or not, this is done by default because
1535      *  the horse is transferred to another address (Core) when the user puts the horse on auction,
1536      *  this means they won't be able to place them here as they're not the owner of the horse
1537      */
1538 
1539     function putInStud(uint256 horseId, uint256 matingPrice, uint256 duration)
1540         external
1541         payable
1542         onlyHorseOwner(horseId)
1543     {
1544         require(
1545             msg.value >= oraclize_getPrice("URL"),
1546             "SS oraclizePriceNotMet"
1547         );
1548 
1549         _putInstud(horseId, matingPrice, duration);
1550 
1551         emit HorseInStud(horseId, matingPrice, duration, block.timestamp);
1552     }
1553 
1554     function removeFromStud(uint256 horseId) external onlyHorseOwner(horseId) {
1555         require(isHorseInStud(horseId), "SS horseIsNotInStud");
1556 
1557         // The horse will be removed from Stud (Will not be visible) but whoever is the owner will have
1558         // to wait for the initial cooldown or that '__callback' is called to be able to put the horse
1559         // in stud again, unless 'removeHorseOWN/1' is called by the 'owner'.
1560         _deleteHorseFromStud(horseId);
1561 
1562         emit HorseDisabledFromStud(horseId, block.timestamp);
1563     }
1564 
1565     function __callback(bytes32 _id, string _result) public {
1566         require(msg.sender == oraclize_cbAddress(), "SS notOraclize");
1567 
1568         // manually remove the horse from stud since removeFromStud/1 allows only the owner
1569         uint256 horseId = parseInt(_result);
1570         _disableHorseFromStud(horseId);
1571 
1572         emit HorseRemovedFromStud(horseId, block.timestamp);
1573     }
1574 
1575     /*      ADMIN RESTRICTED METHOD      */
1576 
1577     function adminPutInStud(
1578         uint256 horseId,
1579         uint256 matingPrice,
1580         uint256 duration
1581     ) external payable onlyStudServiceAdmin {
1582         require(
1583             msg.value >= oraclize_getPrice("URL"),
1584             "SS oraclizePriceNotMet"
1585         );
1586 
1587         _putInstud(horseId, matingPrice, duration);
1588         emit HorseInStud(horseId, matingPrice, duration, block.timestamp);
1589     }
1590 
1591     function adminRemoveHorseFromstud(uint256 horseId)
1592         external
1593         onlyStudServiceAdmin
1594     {
1595         _disableHorseFromStud(horseId);
1596 
1597         emit HorseRemovedFromStud(horseId, block.timestamp);
1598     }
1599 
1600     function makeAvailableForStud(uint256 horseId)
1601         external
1602         onlyStudServiceAdmin
1603     {
1604         _currentlyInStud[horseId] = false;
1605     }
1606 
1607     function setBreedTypesAddress(IBreedTypes breedTypes)
1608         external
1609         onlyStudServiceAdmin
1610     {
1611         require(
1612             address(breedTypes) != address(0),
1613             "setBreedTypesAddress: invalid breedtypes contract address"
1614         );
1615         _breedTypes = breedTypes;
1616     }
1617 
1618     function setCoreAddress(ICore core) external onlyStudServiceAdmin {
1619         require(
1620             address(core) != address(0),
1621             "setCoreAddress: invalid core contract address"
1622         );
1623         _core = core;
1624     }
1625 
1626     /*      ADMIN SETTERS      */
1627 
1628     function setBreedTypeWeight(bytes32 breedType, uint256 weight)
1629         external
1630         onlyStudServiceAdmin
1631     {
1632         _breedTypeWeights[breedType] = weight;
1633     }
1634 
1635     function setBloodlineWeight(bytes32 bloodType, uint256 weight)
1636         external
1637         onlyStudServiceAdmin
1638     {
1639         _bloodlineWeights[bloodType] = weight;
1640     }
1641 
1642     function setBaseFee(uint256 baseFee) external onlyStudServiceAdmin {
1643         _baseFee = baseFee;
1644     }
1645 
1646     function setOraclizeUrl(string newUrl) external onlyStudServiceAdmin {
1647         _oraclizeUrl = newUrl;
1648     }
1649 
1650     function addTimeFrame(uint256 secondsFrame) external onlyStudServiceAdmin {
1651         require(secondsFrame > 0, "addTimeFrame: invalid seconds frame");
1652         require(
1653             !_timeframes[secondsFrame],
1654             "addTimeFrame: seconds frame already active"
1655         );
1656 
1657         _timeframes[secondsFrame] = true;
1658     }
1659 
1660     function removeTimeFrame(uint256 secondsFrame)
1661         external
1662         onlyStudServiceAdmin
1663     {
1664         require(
1665             _timeframes[secondsFrame],
1666             "removeTimeFrame: seconds frame is not found"
1667         );
1668 
1669         _timeframes[secondsFrame] = false;
1670     }
1671 
1672     /*      PUBLIC GETTERS      */
1673 
1674     function getMinimumBreedPrice(uint256 horseId)
1675         public
1676         view
1677         returns (uint256)
1678     {
1679         bytes32 breedType;
1680         bytes32 breedTypeFromContract = _breedTypes.getBreedType(horseId);
1681 
1682         // If the horse exists and the returned value from breed type is the default one (0x00000...)
1683         // it means it is a genesis horse. Otherwise we will just stick to the value returned by the call
1684         if (breedTypeFromContract == bytes32(0)) {
1685             breedType = bytes32("genesis");
1686         } else {
1687             breedType = breedTypeFromContract;
1688         }
1689 
1690         // Get horse data
1691         bytes32 bloodline = _core.getBloodline(horseId);
1692         uint256 bloodlineWeight = _bloodlineWeights[bloodline]
1693             .mul(0.80 ether)
1694             .div(100);
1695         uint256 breedWeight = _breedTypeWeights[breedType].mul(0.20 ether).div(
1696             100
1697         );
1698 
1699         return bloodlineWeight.add(breedWeight).mul(_baseFee).div(1 ether);
1700     }
1701 
1702     function isTimeframeExist(uint256 duration) external view returns (bool) {
1703         return _timeframes[duration];
1704     }
1705 
1706     function getStudInfo(uint256 horseId)
1707         external
1708         view
1709         returns (bool, uint256, uint256, uint256)
1710     {
1711         StudInfo memory stud = _studs[horseId];
1712         return (
1713             stud.inStud,
1714             stud.matingPrice,
1715             stud.duration,
1716             stud.studCreatedAt
1717         );
1718     }
1719 
1720     function getHorseIndex(uint256 horseId) external view returns (uint256) {
1721         return _horseIndex[horseId];
1722     }
1723 
1724     function getBreedTypeWeight(bytes32 breedType)
1725         external
1726         view
1727         returns (uint256)
1728     {
1729         return _breedTypeWeights[breedType];
1730     }
1731 
1732     function getBloodLineWeight(bytes32 bloodLine)
1733         external
1734         view
1735         returns (uint256)
1736     {
1737         return _bloodlineWeights[bloodLine];
1738     }
1739 
1740     function getQueryPrice() external view returns (uint256) {
1741         return oraclize_getPrice("URL");
1742     }
1743 
1744     function getHorsesInStud() external view returns (uint256[]) {
1745         return _horsesInStud;
1746     }
1747 
1748     function getMatingPrice(uint256 horseId) external view returns (uint256) {
1749         return _studs[horseId].matingPrice;
1750     }
1751 
1752     function getStudTime(uint256 horseId) external view returns (uint256) {
1753         return _studs[horseId].duration;
1754     }
1755 
1756     function getOraclizeUrl() external view returns (string) {
1757         return _oraclizeUrl;
1758     }
1759 
1760     function getBaseFee() external view returns (uint256) {
1761         return _baseFee;
1762     }
1763 
1764     function getCore() external view returns (address) {
1765         return address(_core);
1766     }
1767 
1768     function getBreedTypes() external view returns (address) {
1769         return address(_breedTypes);
1770     }
1771 
1772     function isHorseInStud(uint256 horseId) public view returns (bool) {
1773         return _studs[horseId].inStud;
1774     }
1775 
1776     function isCurentlyInStud(uint256 horseId) external view returns (bool) {
1777         return _currentlyInStud[horseId];
1778     }
1779 
1780     /*      PRIVATE     */
1781 
1782     function _putInstud(uint256 horseId, uint256 matingPrice, uint256 duration)
1783         private
1784     {
1785         // We're checking the horse exists because we're relying on the breed type for genesis to be a default value.
1786         // this way we don't get false positives for horses that don't exist
1787         require(_core.exists(horseId), "SS horseDoesNotExist");
1788         require(
1789             bytes32("M") == _core.getHorseSex(horseId),
1790             "SS horseIsNotMale"
1791         );
1792         require(!_currentlyInStud[horseId], "SS horseIsInStud");
1793 
1794         uint256 _minimumBreedPrice = getMinimumBreedPrice(horseId);
1795         require(
1796             matingPrice >= _minimumBreedPrice,
1797             "SS matingPriceLowerThanMinimumBreedPrice"
1798         );
1799 
1800         // if we happen to receive another time we're going to default to 1 day.
1801         uint256 _duration = 86400;
1802 
1803         // if sender is admin, any time frame will be available
1804         // if sender is not admin, and specified timeframe does not exist, fallback to default
1805         if (_timeframes[duration] || isStudServiceAdmin(msg.sender)) {
1806             _duration = duration;
1807         }
1808 
1809         _studs[horseId] = StudInfo(
1810             true,
1811             matingPrice,
1812             _duration,
1813             block.timestamp
1814         );
1815         _horseIndex[horseId] = _horsesInStud.push(horseId) - 1;
1816 
1817         _sendOraclizeQuery(_duration, horseId);
1818         _currentlyInStud[horseId] = true;
1819     }
1820 
1821     function _sendOraclizeQuery(uint256 duration, uint256 horseId) private {
1822         string memory payload = strConcat("{\"stud_info\":", uint2str(horseId), "}");
1823         oraclize_query(duration, "URL", _oraclizeUrl, payload);
1824     }
1825 
1826     function _disableHorseFromStud(uint256 horseId) private {
1827         // manually remove the horse from stud since removeFromStud/1 allows only the owner
1828         if (isHorseInStud(horseId)) {
1829             _deleteHorseFromStud(horseId);
1830         }
1831 
1832         // put horse state to false on Stud
1833         if (_currentlyInStud[horseId]) {
1834             _currentlyInStud[horseId] = false;
1835         }
1836     }
1837 
1838     /*
1839      *  @dev We move the last horse to the index of the horse we're about to remove
1840      *  then delete the last horse from the list.
1841      */
1842     function _deleteHorseFromStud(uint256 horseId) private {
1843         uint256 index = _horseIndex[horseId];
1844         uint256 lastHorseIndex = _horsesInStud.length - 1;
1845         uint256 lastHorse = _horsesInStud[lastHorseIndex];
1846 
1847         // We need to reassign the index of the last horse, otherwise it'd be out of bounds
1848         // and the transaction will fail.
1849         _horsesInStud[index] = lastHorse;
1850         _horseIndex[lastHorse] = index;
1851 
1852         delete _horsesInStud[lastHorseIndex];
1853         delete _studs[horseId];
1854 
1855         _horsesInStud.length--;
1856     }
1857 }