1 pragma solidity ^0.4.22;
2 
3 library SafeMath { //standard library for uint
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0 || b == 0){
6         return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
14     assert(b <= a);
15     return a - b;
16   }
17 
18   function add(uint256 a, uint256 b) internal pure returns (uint256) {
19     uint256 c = a + b;
20     assert(c >= a);
21     return c;
22   }
23 
24   function pow(uint256 a, uint256 b) internal pure returns (uint256){ //power function
25     if (b == 0){
26       return 1;
27     }
28     uint256 c = a**b;
29     assert (c >= a);
30     return c;
31   }
32 }
33 
34 //standard contract to identify owner
35 contract Ownable {
36 
37   address public owner;
38 
39   address public newOwner;
40 
41   address public techSupport;
42 
43   address public newTechSupport;
44 
45   modifier onlyOwner() {
46     require(msg.sender == owner);
47     _;
48   }
49 
50   modifier onlyTechSupport() {
51     require(msg.sender == techSupport || msg.sender == owner);
52     _;
53   }
54 
55   function transferOwnership(address _newOwner) public onlyOwner {
56     require(_newOwner != address(0));
57     newOwner = _newOwner;
58   }
59 
60   function acceptOwnership() public {
61     if (msg.sender == newOwner) {
62       owner = newOwner;
63     }
64   }
65 
66   function transferTechSupport (address _newSupport) public{
67     require (msg.sender == owner || msg.sender == techSupport);
68     newTechSupport = _newSupport;
69   }
70 
71   function acceptSupport() public{
72     if(msg.sender == newTechSupport){
73       techSupport = newTechSupport;
74     }
75   }
76 }
77 
78 
79 // <ORACLIZE_API>
80 /*
81 Copyright (c) 2015-2016 Oraclize SRL
82 Copyright (c) 2016 Oraclize LTD
83 Permission is hereby granted, free of charge, to any person obtaining a copy
84 of this software and associated documentation files (the "Software"), to deal
85 in the Software without restriction, including without limitation the rights
86 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
87 copies of the Software, and to permit persons to whom the Software is
88 furnished to do so, subject to the following conditions:
89 The above copyright notice and this permission notice shall be included in
90 all copies or substantial portions of the Software.
91 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
92 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
93 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
94 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
95 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
96 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
97 THE SOFTWARE.
98 */
99 
100 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
101 
102 // pragma solidity >=0.4.18 <=0.4.20;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
103 
104 contract OraclizeI {
105     address public cbAddress;
106     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
107     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
108     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
109     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
110     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
111     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
112     function getPrice(string _datasource) public returns (uint _dsprice);
113     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
114     function setProofType(byte _proofType) external;
115     function setCustomGasPrice(uint _gasPrice) external;
116     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
117 }
118 
119 contract OraclizeAddrResolverI {
120     function getAddress() public returns (address _addr);
121 }
122 
123 /*
124 Begin solidity-cborutils
125 https://github.com/smartcontractkit/solidity-cborutils
126 MIT License
127 Copyright (c) 2018 SmartContract ChainLink, Ltd.
128 Permission is hereby granted, free of charge, to any person obtaining a copy
129 of this software and associated documentation files (the "Software"), to deal
130 in the Software without restriction, including without limitation the rights
131 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
132 copies of the Software, and to permit persons to whom the Software is
133 furnished to do so, subject to the following conditions:
134 The above copyright notice and this permission notice shall be included in all
135 copies or substantial portions of the Software.
136 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
137 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
138 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
139 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
140 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
141 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
142 SOFTWARE.
143  */
144 
145 library Buffer {
146     struct buffer {
147         bytes buf;
148         uint capacity;
149     }
150 
151     function init(buffer memory buf, uint capacity) internal pure {
152         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
153         // Allocate space for the buffer data
154         buf.capacity = capacity;
155         assembly {
156             let ptr := mload(0x40)
157             mstore(buf, ptr)
158             mstore(0x40, add(ptr, capacity))
159         }
160     }
161 
162     function resize(buffer memory buf, uint capacity) private pure {
163         bytes memory oldbuf = buf.buf;
164         init(buf, capacity);
165         append(buf, oldbuf);
166     }
167 
168     function max(uint a, uint b) private pure returns(uint) {
169         if(a > b) {
170             return a;
171         }
172         return b;
173     }
174 
175     /**
176      * @dev Appends a byte array to the end of the buffer. Reverts if doing so
177      *      would exceed the capacity of the buffer.
178      * @param buf The buffer to append to.
179      * @param data The data to append.
180      * @return The original buffer.
181      */
182     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
183         if(data.length + buf.buf.length > buf.capacity) {
184             resize(buf, max(buf.capacity, data.length) * 2);
185         }
186 
187         uint dest;
188         uint src;
189         uint len = data.length;
190         assembly {
191             // Memory address of the buffer data
192             let bufptr := mload(buf)
193             // Length of existing buffer data
194             let buflen := mload(bufptr)
195             // Start address = buffer address + buffer length + sizeof(buffer length)
196             dest := add(add(bufptr, buflen), 32)
197             // Update buffer length
198             mstore(bufptr, add(buflen, mload(data)))
199             src := add(data, 32)
200         }
201 
202         // Copy word-length chunks while possible
203         for(; len >= 32; len -= 32) {
204             assembly {
205                 mstore(dest, mload(src))
206             }
207             dest += 32;
208             src += 32;
209         }
210 
211         // Copy remaining bytes
212         uint mask = 256 ** (32 - len) - 1;
213         assembly {
214             let srcpart := and(mload(src), not(mask))
215             let destpart := and(mload(dest), mask)
216             mstore(dest, or(destpart, srcpart))
217         }
218 
219         return buf;
220     }
221 
222     /**
223      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
224      * exceed the capacity of the buffer.
225      * @param buf The buffer to append to.
226      * @param data The data to append.
227      * @return The original buffer.
228      */
229     function append(buffer memory buf, uint8 data) internal pure {
230         if(buf.buf.length + 1 > buf.capacity) {
231             resize(buf, buf.capacity * 2);
232         }
233 
234         assembly {
235             // Memory address of the buffer data
236             let bufptr := mload(buf)
237             // Length of existing buffer data
238             let buflen := mload(bufptr)
239             // Address = buffer address + buffer length + sizeof(buffer length)
240             let dest := add(add(bufptr, buflen), 32)
241             mstore8(dest, data)
242             // Update buffer length
243             mstore(bufptr, add(buflen, 1))
244         }
245     }
246 
247     /**
248      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
249      * exceed the capacity of the buffer.
250      * @param buf The buffer to append to.
251      * @param data The data to append.
252      * @return The original buffer.
253      */
254     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
255         if(len + buf.buf.length > buf.capacity) {
256             resize(buf, max(buf.capacity, len) * 2);
257         }
258 
259         uint mask = 256 ** len - 1;
260         assembly {
261             // Memory address of the buffer data
262             let bufptr := mload(buf)
263             // Length of existing buffer data
264             let buflen := mload(bufptr)
265             // Address = buffer address + buffer length + sizeof(buffer length) + len
266             let dest := add(add(bufptr, buflen), len)
267             mstore(dest, or(and(mload(dest), not(mask)), data))
268             // Update buffer length
269             mstore(bufptr, add(buflen, len))
270         }
271         return buf;
272     }
273 }
274 
275 library CBOR {
276     using Buffer for Buffer.buffer;
277 
278     uint8 private constant MAJOR_TYPE_INT = 0;
279     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
280     uint8 private constant MAJOR_TYPE_BYTES = 2;
281     uint8 private constant MAJOR_TYPE_STRING = 3;
282     uint8 private constant MAJOR_TYPE_ARRAY = 4;
283     uint8 private constant MAJOR_TYPE_MAP = 5;
284     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
285 
286     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
287         if(value <= 23) {
288             buf.append(uint8((major << 5) | value));
289         } else if(value <= 0xFF) {
290             buf.append(uint8((major << 5) | 24));
291             buf.appendInt(value, 1);
292         } else if(value <= 0xFFFF) {
293             buf.append(uint8((major << 5) | 25));
294             buf.appendInt(value, 2);
295         } else if(value <= 0xFFFFFFFF) {
296             buf.append(uint8((major << 5) | 26));
297             buf.appendInt(value, 4);
298         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
299             buf.append(uint8((major << 5) | 27));
300             buf.appendInt(value, 8);
301         }
302     }
303 
304     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
305         buf.append(uint8((major << 5) | 31));
306     }
307 
308     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
309         encodeType(buf, MAJOR_TYPE_INT, value);
310     }
311 
312     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
313         if(value >= 0) {
314             encodeType(buf, MAJOR_TYPE_INT, uint(value));
315         } else {
316             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
317         }
318     }
319 
320     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
321         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
322         buf.append(value);
323     }
324 
325     function encodeString(Buffer.buffer memory buf, string value) internal pure {
326         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
327         buf.append(bytes(value));
328     }
329 
330     function startArray(Buffer.buffer memory buf) internal pure {
331         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
332     }
333 
334     function startMap(Buffer.buffer memory buf) internal pure {
335         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
336     }
337 
338     function endSequence(Buffer.buffer memory buf) internal pure {
339         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
340     }
341 }
342 
343 /*
344 End solidity-cborutils
345  */
346 
347 contract usingOraclize {
348     uint constant day = 60*60*24;
349     uint constant week = 60*60*24*7;
350     uint constant month = 60*60*24*30;
351     byte constant proofType_NONE = 0x00;
352     byte constant proofType_TLSNotary = 0x10;
353     byte constant proofType_Android = 0x20;
354     byte constant proofType_Ledger = 0x30;
355     byte constant proofType_Native = 0xF0;
356     byte constant proofStorage_IPFS = 0x01;
357     uint8 constant networkID_auto = 0;
358     uint8 constant networkID_mainnet = 1;
359     uint8 constant networkID_testnet = 2;
360     uint8 constant networkID_morden = 2;
361     uint8 constant networkID_consensys = 161;
362 
363     OraclizeAddrResolverI OAR;
364 
365     OraclizeI oraclize;
366     modifier oraclizeAPI {
367         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
368             oraclize_setNetwork(networkID_auto);
369 
370         if(address(oraclize) != OAR.getAddress())
371             oraclize = OraclizeI(OAR.getAddress());
372 
373         _;
374     }
375     modifier coupon(string code){
376         oraclize = OraclizeI(OAR.getAddress());
377         _;
378     }
379 
380     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
381       return oraclize_setNetwork();
382       networkID; // silence the warning and remain backwards compatible
383     }
384     function oraclize_setNetwork() internal returns(bool){
385         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
386             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
387             oraclize_setNetworkName("eth_mainnet");
388             return true;
389         }
390         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
391             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
392             oraclize_setNetworkName("eth_ropsten3");
393             return true;
394         }
395         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
396             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
397             oraclize_setNetworkName("eth_kovan");
398             return true;
399         }
400         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
401             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
402             oraclize_setNetworkName("eth_rinkeby");
403             return true;
404         }
405         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
406             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
407             return true;
408         }
409         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
410             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
411             return true;
412         }
413         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
414             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
415             return true;
416         }
417         return false;
418     }
419 
420     function __callback(bytes32 myid, string result) public {
421         __callback(myid, result, new bytes(0));
422     }
423     function __callback(bytes32 myid, string result, bytes proof) public {
424       return;
425       myid; result; proof; // Silence compiler warnings
426     }
427 
428     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
429         return oraclize.getPrice(datasource);
430     }
431 
432     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
433         return oraclize.getPrice(datasource, gaslimit);
434     }
435 
436     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
437         uint price = oraclize.getPrice(datasource);
438         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
439         return oraclize.query.value(price)(0, datasource, arg);
440     }
441     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
442         uint price = oraclize.getPrice(datasource);
443         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
444         return oraclize.query.value(price)(timestamp, datasource, arg);
445     }
446     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
447         uint price = oraclize.getPrice(datasource, gaslimit);
448         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
449         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
450     }
451     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
452         uint price = oraclize.getPrice(datasource, gaslimit);
453         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
454         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
455     }
456     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
457         uint price = oraclize.getPrice(datasource);
458         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
459         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
460     }
461     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
462         uint price = oraclize.getPrice(datasource);
463         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
464         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
465     }
466     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
467         uint price = oraclize.getPrice(datasource, gaslimit);
468         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
469         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
470     }
471     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
472         uint price = oraclize.getPrice(datasource, gaslimit);
473         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
474         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
475     }
476     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
477         uint price = oraclize.getPrice(datasource);
478         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
479         bytes memory args = stra2cbor(argN);
480         return oraclize.queryN.value(price)(0, datasource, args);
481     }
482     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
483         uint price = oraclize.getPrice(datasource);
484         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
485         bytes memory args = stra2cbor(argN);
486         return oraclize.queryN.value(price)(timestamp, datasource, args);
487     }
488     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
489         uint price = oraclize.getPrice(datasource, gaslimit);
490         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
491         bytes memory args = stra2cbor(argN);
492         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
493     }
494     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
495         uint price = oraclize.getPrice(datasource, gaslimit);
496         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
497         bytes memory args = stra2cbor(argN);
498         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
499     }
500     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
501         string[] memory dynargs = new string[](1);
502         dynargs[0] = args[0];
503         return oraclize_query(datasource, dynargs);
504     }
505     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
506         string[] memory dynargs = new string[](1);
507         dynargs[0] = args[0];
508         return oraclize_query(timestamp, datasource, dynargs);
509     }
510     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
511         string[] memory dynargs = new string[](1);
512         dynargs[0] = args[0];
513         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
514     }
515     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
516         string[] memory dynargs = new string[](1);
517         dynargs[0] = args[0];
518         return oraclize_query(datasource, dynargs, gaslimit);
519     }
520 
521     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
522         string[] memory dynargs = new string[](2);
523         dynargs[0] = args[0];
524         dynargs[1] = args[1];
525         return oraclize_query(datasource, dynargs);
526     }
527     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
528         string[] memory dynargs = new string[](2);
529         dynargs[0] = args[0];
530         dynargs[1] = args[1];
531         return oraclize_query(timestamp, datasource, dynargs);
532     }
533     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
534         string[] memory dynargs = new string[](2);
535         dynargs[0] = args[0];
536         dynargs[1] = args[1];
537         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
538     }
539     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
540         string[] memory dynargs = new string[](2);
541         dynargs[0] = args[0];
542         dynargs[1] = args[1];
543         return oraclize_query(datasource, dynargs, gaslimit);
544     }
545     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
546         string[] memory dynargs = new string[](3);
547         dynargs[0] = args[0];
548         dynargs[1] = args[1];
549         dynargs[2] = args[2];
550         return oraclize_query(datasource, dynargs);
551     }
552     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
553         string[] memory dynargs = new string[](3);
554         dynargs[0] = args[0];
555         dynargs[1] = args[1];
556         dynargs[2] = args[2];
557         return oraclize_query(timestamp, datasource, dynargs);
558     }
559     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
560         string[] memory dynargs = new string[](3);
561         dynargs[0] = args[0];
562         dynargs[1] = args[1];
563         dynargs[2] = args[2];
564         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
565     }
566     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
567         string[] memory dynargs = new string[](3);
568         dynargs[0] = args[0];
569         dynargs[1] = args[1];
570         dynargs[2] = args[2];
571         return oraclize_query(datasource, dynargs, gaslimit);
572     }
573 
574     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
575         string[] memory dynargs = new string[](4);
576         dynargs[0] = args[0];
577         dynargs[1] = args[1];
578         dynargs[2] = args[2];
579         dynargs[3] = args[3];
580         return oraclize_query(datasource, dynargs);
581     }
582     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
583         string[] memory dynargs = new string[](4);
584         dynargs[0] = args[0];
585         dynargs[1] = args[1];
586         dynargs[2] = args[2];
587         dynargs[3] = args[3];
588         return oraclize_query(timestamp, datasource, dynargs);
589     }
590     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
591         string[] memory dynargs = new string[](4);
592         dynargs[0] = args[0];
593         dynargs[1] = args[1];
594         dynargs[2] = args[2];
595         dynargs[3] = args[3];
596         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
597     }
598     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
599         string[] memory dynargs = new string[](4);
600         dynargs[0] = args[0];
601         dynargs[1] = args[1];
602         dynargs[2] = args[2];
603         dynargs[3] = args[3];
604         return oraclize_query(datasource, dynargs, gaslimit);
605     }
606     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
607         string[] memory dynargs = new string[](5);
608         dynargs[0] = args[0];
609         dynargs[1] = args[1];
610         dynargs[2] = args[2];
611         dynargs[3] = args[3];
612         dynargs[4] = args[4];
613         return oraclize_query(datasource, dynargs);
614     }
615     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
616         string[] memory dynargs = new string[](5);
617         dynargs[0] = args[0];
618         dynargs[1] = args[1];
619         dynargs[2] = args[2];
620         dynargs[3] = args[3];
621         dynargs[4] = args[4];
622         return oraclize_query(timestamp, datasource, dynargs);
623     }
624     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
625         string[] memory dynargs = new string[](5);
626         dynargs[0] = args[0];
627         dynargs[1] = args[1];
628         dynargs[2] = args[2];
629         dynargs[3] = args[3];
630         dynargs[4] = args[4];
631         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
632     }
633     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
634         string[] memory dynargs = new string[](5);
635         dynargs[0] = args[0];
636         dynargs[1] = args[1];
637         dynargs[2] = args[2];
638         dynargs[3] = args[3];
639         dynargs[4] = args[4];
640         return oraclize_query(datasource, dynargs, gaslimit);
641     }
642     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
643         uint price = oraclize.getPrice(datasource);
644         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
645         bytes memory args = ba2cbor(argN);
646         return oraclize.queryN.value(price)(0, datasource, args);
647     }
648     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
649         uint price = oraclize.getPrice(datasource);
650         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
651         bytes memory args = ba2cbor(argN);
652         return oraclize.queryN.value(price)(timestamp, datasource, args);
653     }
654     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
655         uint price = oraclize.getPrice(datasource, gaslimit);
656         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
657         bytes memory args = ba2cbor(argN);
658         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
659     }
660     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
661         uint price = oraclize.getPrice(datasource, gaslimit);
662         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
663         bytes memory args = ba2cbor(argN);
664         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
665     }
666     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
667         bytes[] memory dynargs = new bytes[](1);
668         dynargs[0] = args[0];
669         return oraclize_query(datasource, dynargs);
670     }
671     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
672         bytes[] memory dynargs = new bytes[](1);
673         dynargs[0] = args[0];
674         return oraclize_query(timestamp, datasource, dynargs);
675     }
676     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
677         bytes[] memory dynargs = new bytes[](1);
678         dynargs[0] = args[0];
679         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
680     }
681     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
682         bytes[] memory dynargs = new bytes[](1);
683         dynargs[0] = args[0];
684         return oraclize_query(datasource, dynargs, gaslimit);
685     }
686 
687     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
688         bytes[] memory dynargs = new bytes[](2);
689         dynargs[0] = args[0];
690         dynargs[1] = args[1];
691         return oraclize_query(datasource, dynargs);
692     }
693     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
694         bytes[] memory dynargs = new bytes[](2);
695         dynargs[0] = args[0];
696         dynargs[1] = args[1];
697         return oraclize_query(timestamp, datasource, dynargs);
698     }
699     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
700         bytes[] memory dynargs = new bytes[](2);
701         dynargs[0] = args[0];
702         dynargs[1] = args[1];
703         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
704     }
705     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
706         bytes[] memory dynargs = new bytes[](2);
707         dynargs[0] = args[0];
708         dynargs[1] = args[1];
709         return oraclize_query(datasource, dynargs, gaslimit);
710     }
711     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
712         bytes[] memory dynargs = new bytes[](3);
713         dynargs[0] = args[0];
714         dynargs[1] = args[1];
715         dynargs[2] = args[2];
716         return oraclize_query(datasource, dynargs);
717     }
718     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
719         bytes[] memory dynargs = new bytes[](3);
720         dynargs[0] = args[0];
721         dynargs[1] = args[1];
722         dynargs[2] = args[2];
723         return oraclize_query(timestamp, datasource, dynargs);
724     }
725     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
726         bytes[] memory dynargs = new bytes[](3);
727         dynargs[0] = args[0];
728         dynargs[1] = args[1];
729         dynargs[2] = args[2];
730         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
731     }
732     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
733         bytes[] memory dynargs = new bytes[](3);
734         dynargs[0] = args[0];
735         dynargs[1] = args[1];
736         dynargs[2] = args[2];
737         return oraclize_query(datasource, dynargs, gaslimit);
738     }
739 
740     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
741         bytes[] memory dynargs = new bytes[](4);
742         dynargs[0] = args[0];
743         dynargs[1] = args[1];
744         dynargs[2] = args[2];
745         dynargs[3] = args[3];
746         return oraclize_query(datasource, dynargs);
747     }
748     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
749         bytes[] memory dynargs = new bytes[](4);
750         dynargs[0] = args[0];
751         dynargs[1] = args[1];
752         dynargs[2] = args[2];
753         dynargs[3] = args[3];
754         return oraclize_query(timestamp, datasource, dynargs);
755     }
756     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
757         bytes[] memory dynargs = new bytes[](4);
758         dynargs[0] = args[0];
759         dynargs[1] = args[1];
760         dynargs[2] = args[2];
761         dynargs[3] = args[3];
762         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
763     }
764     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
765         bytes[] memory dynargs = new bytes[](4);
766         dynargs[0] = args[0];
767         dynargs[1] = args[1];
768         dynargs[2] = args[2];
769         dynargs[3] = args[3];
770         return oraclize_query(datasource, dynargs, gaslimit);
771     }
772     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
773         bytes[] memory dynargs = new bytes[](5);
774         dynargs[0] = args[0];
775         dynargs[1] = args[1];
776         dynargs[2] = args[2];
777         dynargs[3] = args[3];
778         dynargs[4] = args[4];
779         return oraclize_query(datasource, dynargs);
780     }
781     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
782         bytes[] memory dynargs = new bytes[](5);
783         dynargs[0] = args[0];
784         dynargs[1] = args[1];
785         dynargs[2] = args[2];
786         dynargs[3] = args[3];
787         dynargs[4] = args[4];
788         return oraclize_query(timestamp, datasource, dynargs);
789     }
790     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
791         bytes[] memory dynargs = new bytes[](5);
792         dynargs[0] = args[0];
793         dynargs[1] = args[1];
794         dynargs[2] = args[2];
795         dynargs[3] = args[3];
796         dynargs[4] = args[4];
797         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
798     }
799     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
800         bytes[] memory dynargs = new bytes[](5);
801         dynargs[0] = args[0];
802         dynargs[1] = args[1];
803         dynargs[2] = args[2];
804         dynargs[3] = args[3];
805         dynargs[4] = args[4];
806         return oraclize_query(datasource, dynargs, gaslimit);
807     }
808 
809     function oraclize_cbAddress() oraclizeAPI internal returns (address){
810         return oraclize.cbAddress();
811     }
812     function oraclize_setProof(byte proofP) oraclizeAPI internal {
813         return oraclize.setProofType(proofP);
814     }
815     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
816         return oraclize.setCustomGasPrice(gasPrice);
817     }
818 
819     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
820         return oraclize.randomDS_getSessionPubKeyHash();
821     }
822 
823     function getCodeSize(address _addr) constant internal returns(uint _size) {
824         assembly {
825             _size := extcodesize(_addr)
826         }
827     }
828 
829     function parseAddr(string _a) internal pure returns (address){
830         bytes memory tmp = bytes(_a);
831         uint160 iaddr = 0;
832         uint160 b1;
833         uint160 b2;
834         for (uint i=2; i<2+2*20; i+=2){
835             iaddr *= 256;
836             b1 = uint160(tmp[i]);
837             b2 = uint160(tmp[i+1]);
838             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
839             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
840             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
841             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
842             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
843             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
844             iaddr += (b1*16+b2);
845         }
846         return address(iaddr);
847     }
848 
849     function strCompare(string _a, string _b) internal pure returns (int) {
850         bytes memory a = bytes(_a);
851         bytes memory b = bytes(_b);
852         uint minLength = a.length;
853         if (b.length < minLength) minLength = b.length;
854         for (uint i = 0; i < minLength; i ++)
855             if (a[i] < b[i])
856                 return -1;
857             else if (a[i] > b[i])
858                 return 1;
859         if (a.length < b.length)
860             return -1;
861         else if (a.length > b.length)
862             return 1;
863         else
864             return 0;
865     }
866 
867     function indexOf(string _haystack, string _needle) internal pure returns (int) {
868         bytes memory h = bytes(_haystack);
869         bytes memory n = bytes(_needle);
870         if(h.length < 1 || n.length < 1 || (n.length > h.length))
871             return -1;
872         else if(h.length > (2**128 -1))
873             return -1;
874         else
875         {
876             uint subindex = 0;
877             for (uint i = 0; i < h.length; i ++)
878             {
879                 if (h[i] == n[0])
880                 {
881                     subindex = 1;
882                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
883                     {
884                         subindex++;
885                     }
886                     if(subindex == n.length)
887                         return int(i);
888                 }
889             }
890             return -1;
891         }
892     }
893 
894     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
895         bytes memory _ba = bytes(_a);
896         bytes memory _bb = bytes(_b);
897         bytes memory _bc = bytes(_c);
898         bytes memory _bd = bytes(_d);
899         bytes memory _be = bytes(_e);
900         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
901         bytes memory babcde = bytes(abcde);
902         uint k = 0;
903         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
904         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
905         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
906         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
907         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
908         return string(babcde);
909     }
910 
911     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
912         return strConcat(_a, _b, _c, _d, "");
913     }
914 
915     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
916         return strConcat(_a, _b, _c, "", "");
917     }
918 
919     function strConcat(string _a, string _b) internal pure returns (string) {
920         return strConcat(_a, _b, "", "", "");
921     }
922 
923     // parseInt
924     function parseInt(string _a) internal pure returns (uint) {
925         return parseInt(_a, 0);
926     }
927 
928     // parseInt(parseFloat*10^_b)
929     function parseInt(string _a, uint _b) internal pure returns (uint) {
930         bytes memory bresult = bytes(_a);
931         uint mint = 0;
932         bool decimals = false;
933         for (uint i=0; i<bresult.length; i++){
934             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
935                 if (decimals){
936                    if (_b == 0) break;
937                     else _b--;
938                 }
939                 mint *= 10;
940                 mint += uint(bresult[i]) - 48;
941             } else if (bresult[i] == 46) decimals = true;
942         }
943         if (_b > 0) mint *= 10**_b;
944         return mint;
945     }
946 
947     function uint2str(uint i) internal pure returns (string){
948         if (i == 0) return "0";
949         uint j = i;
950         uint len;
951         while (j != 0){
952             len++;
953             j /= 10;
954         }
955         bytes memory bstr = new bytes(len);
956         uint k = len - 1;
957         while (i != 0){
958             bstr[k--] = byte(48 + i % 10);
959             i /= 10;
960         }
961         return string(bstr);
962     }
963 
964     using CBOR for Buffer.buffer;
965     function stra2cbor(string[] arr) internal pure returns (bytes) {
966         Buffer.buffer memory buf;
967         Buffer.init(buf, 1024);
968         buf.startArray();
969         for (uint i = 0; i < arr.length; i++) {
970             buf.encodeString(arr[i]);
971         }
972         buf.endSequence();
973         return buf.buf;
974     }
975 
976     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
977         Buffer.buffer memory buf;
978         Buffer.init(buf, 1024);
979         buf.startArray();
980         for (uint i = 0; i < arr.length; i++) {
981             buf.encodeBytes(arr[i]);
982         }
983         buf.endSequence();
984         return buf.buf;
985     }
986 
987     string oraclize_network_name;
988     function oraclize_setNetworkName(string _network_name) internal {
989         oraclize_network_name = _network_name;
990     }
991 
992     function oraclize_getNetworkName() internal view returns (string) {
993         return oraclize_network_name;
994     }
995 
996     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
997         require((_nbytes > 0) && (_nbytes <= 32));
998         // Convert from seconds to ledger timer ticks
999         _delay *= 10;
1000         bytes memory nbytes = new bytes(1);
1001         nbytes[0] = byte(_nbytes);
1002         bytes memory unonce = new bytes(32);
1003         bytes memory sessionKeyHash = new bytes(32);
1004         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1005         assembly {
1006             mstore(unonce, 0x20)
1007             // the following variables can be relaxed
1008             // check relaxed random contract under ethereum-examples repo
1009             // for an idea on how to override and replace comit hash vars
1010             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1011             mstore(sessionKeyHash, 0x20)
1012             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1013         }
1014         bytes memory delay = new bytes(32);
1015         assembly {
1016             mstore(add(delay, 0x20), _delay)
1017         }
1018 
1019         bytes memory delay_bytes8 = new bytes(8);
1020         copyBytes(delay, 24, 8, delay_bytes8, 0);
1021 
1022         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1023         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1024 
1025         bytes memory delay_bytes8_left = new bytes(8);
1026 
1027         assembly {
1028             let x := mload(add(delay_bytes8, 0x20))
1029             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1030             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1031             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1032             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1033             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1034             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1035             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1036             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1037 
1038         }
1039 
1040         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1041         return queryId;
1042     }
1043 
1044     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1045         oraclize_randomDS_args[queryId] = commitment;
1046     }
1047 
1048     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1049     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1050 
1051     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1052         bool sigok;
1053         address signer;
1054 
1055         bytes32 sigr;
1056         bytes32 sigs;
1057 
1058         bytes memory sigr_ = new bytes(32);
1059         uint offset = 4+(uint(dersig[3]) - 0x20);
1060         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1061         bytes memory sigs_ = new bytes(32);
1062         offset += 32 + 2;
1063         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1064 
1065         assembly {
1066             sigr := mload(add(sigr_, 32))
1067             sigs := mload(add(sigs_, 32))
1068         }
1069 
1070 
1071         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1072         if (address(keccak256(pubkey)) == signer) return true;
1073         else {
1074             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1075             return (address(keccak256(pubkey)) == signer);
1076         }
1077     }
1078 
1079     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1080         bool sigok;
1081 
1082         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1083         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1084         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1085 
1086         bytes memory appkey1_pubkey = new bytes(64);
1087         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1088 
1089         bytes memory tosign2 = new bytes(1+65+32);
1090         tosign2[0] = byte(1); //role
1091         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1092         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1093         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1094         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1095 
1096         if (sigok == false) return false;
1097 
1098 
1099         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1100         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1101 
1102         bytes memory tosign3 = new bytes(1+65);
1103         tosign3[0] = 0xFE;
1104         copyBytes(proof, 3, 65, tosign3, 1);
1105 
1106         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1107         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1108 
1109         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1110 
1111         return sigok;
1112     }
1113 
1114     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1115         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1116         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1117 
1118         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1119         require(proofVerified);
1120 
1121         _;
1122     }
1123 
1124     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1125         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1126         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1127 
1128         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1129         if (proofVerified == false) return 2;
1130 
1131         return 0;
1132     }
1133 
1134     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1135         bool match_ = true;
1136 
1137         require(prefix.length == n_random_bytes);
1138 
1139         for (uint256 i=0; i< n_random_bytes; i++) {
1140             if (content[i] != prefix[i]) match_ = false;
1141         }
1142 
1143         return match_;
1144     }
1145 
1146     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1147 
1148         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1149         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1150         bytes memory keyhash = new bytes(32);
1151         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1152         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1153 
1154         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1155         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1156 
1157         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1158         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1159 
1160         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1161         // This is to verify that the computed args match with the ones specified in the query.
1162         bytes memory commitmentSlice1 = new bytes(8+1+32);
1163         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1164 
1165         bytes memory sessionPubkey = new bytes(64);
1166         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1167         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1168 
1169         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1170         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1171             delete oraclize_randomDS_args[queryId];
1172         } else return false;
1173 
1174 
1175         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1176         bytes memory tosign1 = new bytes(32+8+1+32);
1177         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1178         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1179 
1180         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1181         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1182             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1183         }
1184 
1185         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1186     }
1187 
1188     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1189     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1190         uint minLength = length + toOffset;
1191 
1192         // Buffer too small
1193         require(to.length >= minLength); // Should be a better way?
1194 
1195         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1196         uint i = 32 + fromOffset;
1197         uint j = 32 + toOffset;
1198 
1199         while (i < (32 + fromOffset + length)) {
1200             assembly {
1201                 let tmp := mload(add(from, i))
1202                 mstore(add(to, j), tmp)
1203             }
1204             i += 32;
1205             j += 32;
1206         }
1207 
1208         return to;
1209     }
1210 
1211     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1212     // Duplicate Solidity's ecrecover, but catching the CALL return value
1213     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1214         // We do our own memory management here. Solidity uses memory offset
1215         // 0x40 to store the current end of memory. We write past it (as
1216         // writes are memory extensions), but don't update the offset so
1217         // Solidity will reuse it. The memory used here is only needed for
1218         // this context.
1219 
1220         // FIXME: inline assembly can't access return values
1221         bool ret;
1222         address addr;
1223 
1224         assembly {
1225             let size := mload(0x40)
1226             mstore(size, hash)
1227             mstore(add(size, 32), v)
1228             mstore(add(size, 64), r)
1229             mstore(add(size, 96), s)
1230 
1231             // NOTE: we can reuse the request memory because we deal with
1232             //       the return code
1233             ret := call(3000, 1, 0, size, 128, size, 32)
1234             addr := mload(size)
1235         }
1236 
1237         return (ret, addr);
1238     }
1239 
1240     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1241     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1242         bytes32 r;
1243         bytes32 s;
1244         uint8 v;
1245 
1246         if (sig.length != 65)
1247           return (false, 0);
1248 
1249         // The signature format is a compact form of:
1250         //   {bytes32 r}{bytes32 s}{uint8 v}
1251         // Compact means, uint8 is not padded to 32 bytes.
1252         assembly {
1253             r := mload(add(sig, 32))
1254             s := mload(add(sig, 64))
1255 
1256             // Here we are loading the last 32 bytes. We exploit the fact that
1257             // 'mload' will pad with zeroes if we overread.
1258             // There is no 'mload8' to do this, but that would be nicer.
1259             v := byte(0, mload(add(sig, 96)))
1260 
1261             // Alternative solution:
1262             // 'byte' is not working due to the Solidity parser, so lets
1263             // use the second best option, 'and'
1264             // v := and(mload(add(sig, 65)), 255)
1265         }
1266 
1267         // albeit non-transactional signatures are not specified by the YP, one would expect it
1268         // to match the YP range of [27, 28]
1269         //
1270         // geth uses [0, 1] and some clients have followed. This might change, see:
1271         //  https://github.com/ethereum/go-ethereum/issues/2053
1272         if (v < 27)
1273           v += 27;
1274 
1275         if (v != 27 && v != 28)
1276             return (false, 0);
1277 
1278         return safer_ecrecover(hash, v, r, s);
1279     }
1280 
1281 }
1282 // </ORACLIZE_API>
1283 
1284 //Abstract Token contract
1285 contract ArtNoyToken{
1286   function setCrowdsaleContract (address) public;
1287   function sendCrowdsaleTokens(address, uint256)  public;
1288   function getOwner()public view returns(address);
1289   function icoSucceed() public;
1290   function endIco () public;
1291 }
1292 
1293 //Crowdsale contract
1294 contract Crowdsale is Ownable, usingOraclize{
1295 
1296   using SafeMath for uint;
1297 
1298   uint public decimals = 18;
1299 
1300   address public distributionAddress;
1301   uint public startingExchangePrice = 1902877214779731;
1302 
1303   // Token contract address
1304   ArtNoyToken public token;
1305 
1306   // Constructor
1307   constructor (address _tokenAddress, address _distributionAddress) public payable{
1308     require (msg.value > 0);
1309     
1310     token = ArtNoyToken(_tokenAddress);
1311     // techSupport = msg.sender;
1312     techSupport = 0x08531Ea431B6adAa46D2e7a75f48A8d9Ce412FDc;
1313 
1314     token.setCrowdsaleContract(this);
1315     owner = token.getOwner();
1316     distributionAddress = _distributionAddress;
1317 
1318     oraclize_setNetwork(networkID_auto);
1319     oraclize = OraclizeI(OAR.getAddress());
1320 
1321     oraclizeBalance = msg.value;
1322 
1323     tokenPrice = startingExchangePrice;
1324     // updateFlag = true;
1325     oraclize_query("URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
1326   }
1327 
1328   uint public ethCollected;
1329   uint public tokensSold;
1330 
1331   uint public minDeposit = 0.01 ether;
1332   uint public tokenPrice; //1usd
1333 
1334   // pre ico functions: 
1335   uint public constant PRE_ICO_START = 1528243201; //1528344001; //1528228860-no; //06/06/2018 UTC-4 UTC-0
1336   uint public constant PRE_ICO_FINISH = 1530403199; //1530417599; //1530388740-no; //30/06/2018 UTC-4 UTC-0
1337   
1338   uint public constant PRE_ICO_MIN_CAP = 0;
1339   uint public constant PRE_ICO_MAX_CAP = 5000000 ether; //tokens
1340   
1341   uint public preIcoTokensSold;
1342 
1343   //end pre ico functions
1344 
1345   //ico functions
1346   uint public constant ICO_START = 1530403201; //1530417601; //1530388860-no; //01/07/2018 UTC-4 UTC-0
1347   uint public constant ICO_FINISH = 1544918399; //1544932799; //1544903940-no; //15/12/2018 UTC-4 UTC-0
1348 
1349   uint public constant ICO_MIN_CAP = 10000 ether; //tokens
1350   uint public constant ICO_MAX_CAP = 55000000 ether; //tokens
1351 
1352   //end ico functions
1353 
1354   mapping (address => uint) contributorsBalances;
1355   
1356   function getCurrentPhase (uint _time) public view returns(uint8){
1357     if(_time == 0){
1358       _time = now;
1359     }
1360     if (PRE_ICO_START < _time && _time <= PRE_ICO_FINISH){
1361       return 1;
1362     }
1363     if (ICO_START < _time && _time <= ICO_FINISH){
1364       return 2;
1365     }
1366     return 0;
1367   }
1368   
1369   function getTimeBasedBonus (uint _time) public view returns(uint) {
1370     if(_time == 0){
1371       _time = now;
1372     }
1373     uint8 phase = getCurrentPhase(_time);
1374     if(phase == 1){
1375       return 20;
1376     }
1377     if(phase == 2){
1378       if (ICO_START + 90 days <= _time){
1379         return 20;
1380       }
1381       if (ICO_START + 180 days <= _time){
1382         return 10;
1383       }
1384       if (ICO_START + 365 days <= _time){ //CHANGE IT
1385         return 5;
1386       }
1387     }
1388     return 0;
1389   }
1390 
1391   event OnSuccessfullyBuy(address indexed _address, uint indexed _etherValue, bool indexed isBought, uint _tokenValue);
1392 
1393   function () public payable {
1394     require (msg.value >= minDeposit);
1395     require (buy(msg.sender, msg.value, now));
1396   }
1397   
1398   function buy (address _address, uint _value, uint _time) internal returns(bool){
1399     uint8 currentPhase = getCurrentPhase(_time);
1400     require (currentPhase != 0);
1401     uint tokensToSend = calculateTokensWithBonus(_value);
1402 
1403     ethCollected = ethCollected.add(_value);
1404     tokensSold = tokensSold.add(tokensToSend);
1405 
1406     if (currentPhase == 1){
1407       require (preIcoTokensSold.add(tokensToSend) <= PRE_ICO_MAX_CAP);
1408       
1409       preIcoTokensSold = preIcoTokensSold.add(tokensToSend);
1410 
1411       distributionAddress.transfer(address(this).balance.sub(oraclizeBalance));
1412     }else{
1413       contributorsBalances[_address] = contributorsBalances[_address].add(_value);
1414 
1415       if(tokensSold >= ICO_MIN_CAP){
1416         if(!areTokensSended){
1417           token.icoSucceed();
1418           areTokensSended = true;
1419         }
1420         distributionAddress.transfer(address(this).balance.sub(oraclizeBalance));
1421       }
1422     }
1423 
1424     emit OnSuccessfullyBuy(_address,_value,true, tokensToSend);
1425     token.sendCrowdsaleTokens(_address, tokensToSend);
1426     return true;
1427   }
1428 
1429   bool public areTokensSended = false; 
1430 
1431   function calculateTokensWithoutBonus (uint _value) public view returns(uint) {
1432     return _value.mul(uint(10).pow(decimals))/(tokenPrice);
1433   }
1434 
1435   function calculateTokensWithBonus (uint _value) public view returns(uint) {
1436     uint buffer = _value.mul(uint(10).pow(decimals))/(tokenPrice);
1437     return buffer.add(buffer.mul(getTimeBasedBonus(now))/100);
1438   }
1439 
1440   function isIcoTrue () public view returns(bool) {
1441     if (tokensSold >= ICO_MIN_CAP){
1442       return true;
1443     }
1444     return false;
1445   }
1446 
1447   function refund () public {
1448     require (now > ICO_FINISH && !isIcoTrue());
1449     require (contributorsBalances[msg.sender] != 0);
1450 
1451     uint balance = contributorsBalances[msg.sender];
1452 
1453     contributorsBalances[msg.sender] = 0;
1454     msg.sender.transfer(balance);
1455   }
1456 
1457   function manualSendEther (address _address, uint _value) public onlyTechSupport {
1458     uint tokensToSend = calculateTokensWithBonus(_value);
1459     
1460     ethCollected = ethCollected.add(_value);
1461     tokensSold = tokensSold.add(tokensToSend);
1462     
1463     token.sendCrowdsaleTokens(_address, tokensToSend);
1464     emit OnSuccessfullyBuy(_address, 0, false, tokensToSend);
1465   }
1466 
1467   function manualSendTokens (address _address, uint _value) public onlyTechSupport {
1468     tokensSold = tokensSold.add(_value);
1469     token.sendCrowdsaleTokens(_address, _value);
1470     emit OnSuccessfullyBuy(_address, 0, false, _value);
1471   }
1472 
1473   event IcoEnded();
1474 
1475   function endIco () public onlyOwner {
1476     require (now > ICO_FINISH);
1477     token.endIco();
1478 
1479     emit IcoEnded();
1480   }
1481   
1482 
1483   // ORACLIZE functions
1484 
1485   uint public oraclizeBalance;
1486   bool public updateFlag = true;
1487   uint public priceUpdateAt;
1488 
1489 
1490   function update() internal {
1491     oraclize_query(86400,"URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
1492     //86400 - 1 day
1493   
1494     oraclizeBalance = oraclizeBalance.sub(oraclize_getPrice("URL")); //request to oraclize
1495   }
1496 
1497   function startOraclize (uint _time) public onlyOwner {
1498     require (_time != 0);
1499     require (!updateFlag);
1500     
1501     updateFlag = true;
1502     oraclize_query(_time,"URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0");
1503     oraclizeBalance = oraclizeBalance.sub(oraclize_getPrice("URL"));
1504   }
1505 
1506   function addEtherForOraclize () public payable {
1507     oraclizeBalance = oraclizeBalance.add(msg.value);
1508   }
1509 
1510   function requestOraclizeBalance () public onlyOwner {
1511     updateFlag = false;
1512     if (address(this).balance >= oraclizeBalance){
1513       owner.transfer(oraclizeBalance);
1514     }else{
1515       owner.transfer(address(this).balance);
1516     }
1517     oraclizeBalance = 0;
1518   }
1519   
1520   function stopOraclize () public onlyOwner {
1521     updateFlag = false;
1522   }
1523     
1524   function __callback(bytes32, string result, bytes) public {
1525     require(msg.sender == oraclize_cbAddress());
1526 
1527     uint256 price = 10 ** 23 / parseInt(result, 5);
1528 
1529     require(price > 0);
1530 
1531     tokenPrice = price;
1532 
1533     priceUpdateAt = block.timestamp;
1534             
1535     if(updateFlag){
1536       update();
1537     }
1538   }
1539   
1540   //end ORACLIZE functions
1541 }