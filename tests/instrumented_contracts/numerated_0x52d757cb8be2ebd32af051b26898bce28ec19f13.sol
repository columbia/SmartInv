1 pragma solidity ^0.4.24;
2 
3 /**
4  * @title SafeMath
5  * @dev Math operations with safety checks that revert on error
6  */
7 library SafeMath {
8     /**
9     * @dev Multiplies two numbers, reverts on overflow.
10     */
11     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
12         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
13         // benefit is lost if 'b' is also tested.
14         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
15         if (a == 0) {
16             return 0;
17         }
18 
19         uint256 c = a * b;
20         require(c / a == b);
21 
22         return c;
23     }
24 
25     /**
26     * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
27     */
28     function div(uint256 a, uint256 b) internal pure returns (uint256) {
29         // Solidity only automatically asserts when dividing by 0
30         require(b > 0);
31         uint256 c = a / b;
32         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33 
34         return c;
35     }
36 
37     /**
38     * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
39     */
40     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
41         require(b <= a);
42         uint256 c = a - b;
43 
44         return c;
45     }
46 
47     /**
48     * @dev Adds two numbers, reverts on overflow.
49     */
50     function add(uint256 a, uint256 b) internal pure returns (uint256) {
51         uint256 c = a + b;
52         require(c >= a);
53 
54         return c;
55     }
56 
57     /**
58     * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
59     * reverts when dividing by zero.
60     */
61     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
62         require(b != 0);
63         return a % b;
64     }
65 }
66 
67 // <ORACLIZE_API>
68 // Release targetted at solc 0.4.25 to silence compiler warning/error messages, compatible down to 0.4.22
69 /*
70 Copyright (c) 2015-2016 Oraclize SRL
71 Copyright (c) 2016 Oraclize LTD
72 Permission is hereby granted, free of charge, to any person obtaining a copy
73 of this software and associated documentation files (the "Software"), to deal
74 in the Software without restriction, including without limitation the rights
75 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
76 copies of the Software, and to permit persons to whom the Software is
77 furnished to do so, subject to the following conditions:
78 The above copyright notice and this permission notice shall be included in
79 all copies or substantial portions of the Software.
80 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
81 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
82 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
83 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
84 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
85 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
86 THE SOFTWARE.
87 */
88 
89 // This api is currently targeted at 0.4.22 to 0.4.25 (stable builds), please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
90 
91 pragma solidity >= 0.4.22 < 0.5;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
92 
93 contract OraclizeI {
94     address public cbAddress;
95     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
96     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
97     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
98     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
99     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
100     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
101     function getPrice(string _datasource) public returns (uint _dsprice);
102     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
103     function setProofType(byte _proofType) external;
104     function setCustomGasPrice(uint _gasPrice) external;
105     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
106 }
107 
108 contract OraclizeAddrResolverI {
109     function getAddress() public returns (address _addr);
110 }
111 
112 /*
113 Begin solidity-cborutils
114 https://github.com/smartcontractkit/solidity-cborutils
115 MIT License
116 Copyright (c) 2018 SmartContract ChainLink, Ltd.
117 Permission is hereby granted, free of charge, to any person obtaining a copy
118 of this software and associated documentation files (the "Software"), to deal
119 in the Software without restriction, including without limitation the rights
120 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
121 copies of the Software, and to permit persons to whom the Software is
122 furnished to do so, subject to the following conditions:
123 The above copyright notice and this permission notice shall be included in all
124 copies or substantial portions of the Software.
125 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
126 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
127 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
128 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
129 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
130 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
131 SOFTWARE.
132  */
133 
134 library Buffer {
135     struct buffer {
136         bytes buf;
137         uint capacity;
138     }
139 
140     function init(buffer memory buf, uint _capacity) internal pure {
141         uint capacity = _capacity;
142         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
143         // Allocate space for the buffer data
144         buf.capacity = capacity;
145         assembly {
146             let ptr := mload(0x40)
147             mstore(buf, ptr)
148             mstore(ptr, 0)
149             mstore(0x40, add(ptr, capacity))
150         }
151     }
152 
153     function resize(buffer memory buf, uint capacity) private pure {
154         bytes memory oldbuf = buf.buf;
155         init(buf, capacity);
156         append(buf, oldbuf);
157     }
158 
159     function max(uint a, uint b) private pure returns(uint) {
160         if(a > b) {
161             return a;
162         }
163         return b;
164     }
165 
166     /**
167      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
168      *      would exceed the capacity of the buffer.
169      * @param buf The buffer to append to.
170      * @param data The data to append.
171      * @return The original buffer.
172      */
173     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
174         if(data.length + buf.buf.length > buf.capacity) {
175             resize(buf, max(buf.capacity, data.length) * 2);
176         }
177 
178         uint dest;
179         uint src;
180         uint len = data.length;
181         assembly {
182             // Memory address of the buffer data
183             let bufptr := mload(buf)
184             // Length of existing buffer data
185             let buflen := mload(bufptr)
186             // Start address = buffer address + buffer length + sizeof(buffer length)
187             dest := add(add(bufptr, buflen), 32)
188             // Update buffer length
189             mstore(bufptr, add(buflen, mload(data)))
190             src := add(data, 32)
191         }
192 
193         // Copy word-length chunks while possible
194         for(; len >= 32; len -= 32) {
195             assembly {
196                 mstore(dest, mload(src))
197             }
198             dest += 32;
199             src += 32;
200         }
201 
202         // Copy remaining bytes
203         uint mask = 256 ** (32 - len) - 1;
204         assembly {
205             let srcpart := and(mload(src), not(mask))
206             let destpart := and(mload(dest), mask)
207             mstore(dest, or(destpart, srcpart))
208         }
209 
210         return buf;
211     }
212 
213     /**
214      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
215      * exceed the capacity of the buffer.
216      * @param buf The buffer to append to.
217      * @param data The data to append.
218      * @return The original buffer.
219      */
220     function append(buffer memory buf, uint8 data) internal pure {
221         if(buf.buf.length + 1 > buf.capacity) {
222             resize(buf, buf.capacity * 2);
223         }
224 
225         assembly {
226             // Memory address of the buffer data
227             let bufptr := mload(buf)
228             // Length of existing buffer data
229             let buflen := mload(bufptr)
230             // Address = buffer address + buffer length + sizeof(buffer length)
231             let dest := add(add(bufptr, buflen), 32)
232             mstore8(dest, data)
233             // Update buffer length
234             mstore(bufptr, add(buflen, 1))
235         }
236     }
237 
238     /**
239      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
240      * exceed the capacity of the buffer.
241      * @param buf The buffer to append to.
242      * @param data The data to append.
243      * @return The original buffer.
244      */
245     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
246         if(len + buf.buf.length > buf.capacity) {
247             resize(buf, max(buf.capacity, len) * 2);
248         }
249 
250         uint mask = 256 ** len - 1;
251         assembly {
252             // Memory address of the buffer data
253             let bufptr := mload(buf)
254             // Length of existing buffer data
255             let buflen := mload(bufptr)
256             // Address = buffer address + buffer length + sizeof(buffer length) + len
257             let dest := add(add(bufptr, buflen), len)
258             mstore(dest, or(and(mload(dest), not(mask)), data))
259             // Update buffer length
260             mstore(bufptr, add(buflen, len))
261         }
262         return buf;
263     }
264 }
265 
266 library CBOR {
267     using Buffer for Buffer.buffer;
268 
269     uint8 private constant MAJOR_TYPE_INT = 0;
270     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
271     uint8 private constant MAJOR_TYPE_BYTES = 2;
272     uint8 private constant MAJOR_TYPE_STRING = 3;
273     uint8 private constant MAJOR_TYPE_ARRAY = 4;
274     uint8 private constant MAJOR_TYPE_MAP = 5;
275     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
276 
277     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
278         if(value <= 23) {
279             buf.append(uint8((major << 5) | value));
280         } else if(value <= 0xFF) {
281             buf.append(uint8((major << 5) | 24));
282             buf.appendInt(value, 1);
283         } else if(value <= 0xFFFF) {
284             buf.append(uint8((major << 5) | 25));
285             buf.appendInt(value, 2);
286         } else if(value <= 0xFFFFFFFF) {
287             buf.append(uint8((major << 5) | 26));
288             buf.appendInt(value, 4);
289         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
290             buf.append(uint8((major << 5) | 27));
291             buf.appendInt(value, 8);
292         }
293     }
294 
295     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
296         buf.append(uint8((major << 5) | 31));
297     }
298 
299     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
300         encodeType(buf, MAJOR_TYPE_INT, value);
301     }
302 
303     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
304         if(value >= 0) {
305             encodeType(buf, MAJOR_TYPE_INT, uint(value));
306         } else {
307             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
308         }
309     }
310 
311     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
312         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
313         buf.append(value);
314     }
315 
316     function encodeString(Buffer.buffer memory buf, string value) internal pure {
317         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
318         buf.append(bytes(value));
319     }
320 
321     function startArray(Buffer.buffer memory buf) internal pure {
322         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
323     }
324 
325     function startMap(Buffer.buffer memory buf) internal pure {
326         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
327     }
328 
329     function endSequence(Buffer.buffer memory buf) internal pure {
330         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
331     }
332 }
333 
334 /*
335 End solidity-cborutils
336  */
337 
338 contract usingOraclize {
339     uint constant day = 60*60*24;
340     uint constant week = 60*60*24*7;
341     uint constant month = 60*60*24*30;
342     byte constant proofType_NONE = 0x00;
343     byte constant proofType_TLSNotary = 0x10;
344     byte constant proofType_Ledger = 0x30;
345     byte constant proofType_Android = 0x40;
346     byte constant proofType_Native = 0xF0;
347     byte constant proofStorage_IPFS = 0x01;
348     uint8 constant networkID_auto = 0;
349     uint8 constant networkID_mainnet = 1;
350     uint8 constant networkID_testnet = 2;
351     uint8 constant networkID_morden = 2;
352     uint8 constant networkID_consensys = 161;
353 
354     OraclizeAddrResolverI OAR;
355 
356     OraclizeI oraclize;
357     modifier oraclizeAPI {
358         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
359             oraclize_setNetwork(networkID_auto);
360 
361         if(address(oraclize) != OAR.getAddress())
362             oraclize = OraclizeI(OAR.getAddress());
363 
364         _;
365     }
366     modifier coupon(string code){
367         oraclize = OraclizeI(OAR.getAddress());
368         _;
369     }
370 
371     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
372       return oraclize_setNetwork();
373       networkID; // silence the warning and remain backwards compatible
374     }
375     function oraclize_setNetwork() internal returns(bool){
376         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
377             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
378             oraclize_setNetworkName("eth_mainnet");
379             return true;
380         }
381         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
382             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
383             oraclize_setNetworkName("eth_ropsten3");
384             return true;
385         }
386         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
387             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
388             oraclize_setNetworkName("eth_kovan");
389             return true;
390         }
391         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
392             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
393             oraclize_setNetworkName("eth_rinkeby");
394             return true;
395         }
396         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
397             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
398             return true;
399         }
400         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
401             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
402             return true;
403         }
404         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
405             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
406             return true;
407         }
408         return false;
409     }
410 
411     function __callback(bytes32 myid, string result) public {
412         __callback(myid, result, new bytes(0));
413     }
414     function __callback(bytes32 myid, string result, bytes proof) public {
415       return;
416       // Following should never be reached with a preceding return, however
417       // this is just a placeholder function, ideally meant to be defined in
418       // child contract when proofs are used
419       myid; result; proof; // Silence compiler warnings
420       oraclize = OraclizeI(0); // Additional compiler silence about making function pure/view.
421     }
422 
423     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
424         return oraclize.getPrice(datasource);
425     }
426 
427     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
428         return oraclize.getPrice(datasource, gaslimit);
429     }
430 
431     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
432         uint price = oraclize.getPrice(datasource);
433         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
434         return oraclize.query.value(price)(0, datasource, arg);
435     }
436     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
437         uint price = oraclize.getPrice(datasource);
438         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
439         return oraclize.query.value(price)(timestamp, datasource, arg);
440     }
441     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
442         uint price = oraclize.getPrice(datasource, gaslimit);
443         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
444         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
445     }
446     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
447         uint price = oraclize.getPrice(datasource, gaslimit);
448         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
449         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
450     }
451     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
452         uint price = oraclize.getPrice(datasource);
453         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
454         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
455     }
456     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
457         uint price = oraclize.getPrice(datasource);
458         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
459         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
460     }
461     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
462         uint price = oraclize.getPrice(datasource, gaslimit);
463         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
464         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
465     }
466     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
467         uint price = oraclize.getPrice(datasource, gaslimit);
468         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
469         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
470     }
471     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
472         uint price = oraclize.getPrice(datasource);
473         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
474         bytes memory args = stra2cbor(argN);
475         return oraclize.queryN.value(price)(0, datasource, args);
476     }
477     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
478         uint price = oraclize.getPrice(datasource);
479         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
480         bytes memory args = stra2cbor(argN);
481         return oraclize.queryN.value(price)(timestamp, datasource, args);
482     }
483     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
484         uint price = oraclize.getPrice(datasource, gaslimit);
485         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
486         bytes memory args = stra2cbor(argN);
487         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
488     }
489     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
490         uint price = oraclize.getPrice(datasource, gaslimit);
491         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
492         bytes memory args = stra2cbor(argN);
493         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
494     }
495     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
496         string[] memory dynargs = new string[](1);
497         dynargs[0] = args[0];
498         return oraclize_query(datasource, dynargs);
499     }
500     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
501         string[] memory dynargs = new string[](1);
502         dynargs[0] = args[0];
503         return oraclize_query(timestamp, datasource, dynargs);
504     }
505     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
506         string[] memory dynargs = new string[](1);
507         dynargs[0] = args[0];
508         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
509     }
510     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
511         string[] memory dynargs = new string[](1);
512         dynargs[0] = args[0];
513         return oraclize_query(datasource, dynargs, gaslimit);
514     }
515 
516     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
517         string[] memory dynargs = new string[](2);
518         dynargs[0] = args[0];
519         dynargs[1] = args[1];
520         return oraclize_query(datasource, dynargs);
521     }
522     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
523         string[] memory dynargs = new string[](2);
524         dynargs[0] = args[0];
525         dynargs[1] = args[1];
526         return oraclize_query(timestamp, datasource, dynargs);
527     }
528     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
529         string[] memory dynargs = new string[](2);
530         dynargs[0] = args[0];
531         dynargs[1] = args[1];
532         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
533     }
534     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
535         string[] memory dynargs = new string[](2);
536         dynargs[0] = args[0];
537         dynargs[1] = args[1];
538         return oraclize_query(datasource, dynargs, gaslimit);
539     }
540     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
541         string[] memory dynargs = new string[](3);
542         dynargs[0] = args[0];
543         dynargs[1] = args[1];
544         dynargs[2] = args[2];
545         return oraclize_query(datasource, dynargs);
546     }
547     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
548         string[] memory dynargs = new string[](3);
549         dynargs[0] = args[0];
550         dynargs[1] = args[1];
551         dynargs[2] = args[2];
552         return oraclize_query(timestamp, datasource, dynargs);
553     }
554     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
555         string[] memory dynargs = new string[](3);
556         dynargs[0] = args[0];
557         dynargs[1] = args[1];
558         dynargs[2] = args[2];
559         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
560     }
561     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
562         string[] memory dynargs = new string[](3);
563         dynargs[0] = args[0];
564         dynargs[1] = args[1];
565         dynargs[2] = args[2];
566         return oraclize_query(datasource, dynargs, gaslimit);
567     }
568 
569     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
570         string[] memory dynargs = new string[](4);
571         dynargs[0] = args[0];
572         dynargs[1] = args[1];
573         dynargs[2] = args[2];
574         dynargs[3] = args[3];
575         return oraclize_query(datasource, dynargs);
576     }
577     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
578         string[] memory dynargs = new string[](4);
579         dynargs[0] = args[0];
580         dynargs[1] = args[1];
581         dynargs[2] = args[2];
582         dynargs[3] = args[3];
583         return oraclize_query(timestamp, datasource, dynargs);
584     }
585     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
586         string[] memory dynargs = new string[](4);
587         dynargs[0] = args[0];
588         dynargs[1] = args[1];
589         dynargs[2] = args[2];
590         dynargs[3] = args[3];
591         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
592     }
593     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
594         string[] memory dynargs = new string[](4);
595         dynargs[0] = args[0];
596         dynargs[1] = args[1];
597         dynargs[2] = args[2];
598         dynargs[3] = args[3];
599         return oraclize_query(datasource, dynargs, gaslimit);
600     }
601     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
602         string[] memory dynargs = new string[](5);
603         dynargs[0] = args[0];
604         dynargs[1] = args[1];
605         dynargs[2] = args[2];
606         dynargs[3] = args[3];
607         dynargs[4] = args[4];
608         return oraclize_query(datasource, dynargs);
609     }
610     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
611         string[] memory dynargs = new string[](5);
612         dynargs[0] = args[0];
613         dynargs[1] = args[1];
614         dynargs[2] = args[2];
615         dynargs[3] = args[3];
616         dynargs[4] = args[4];
617         return oraclize_query(timestamp, datasource, dynargs);
618     }
619     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
620         string[] memory dynargs = new string[](5);
621         dynargs[0] = args[0];
622         dynargs[1] = args[1];
623         dynargs[2] = args[2];
624         dynargs[3] = args[3];
625         dynargs[4] = args[4];
626         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
627     }
628     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
629         string[] memory dynargs = new string[](5);
630         dynargs[0] = args[0];
631         dynargs[1] = args[1];
632         dynargs[2] = args[2];
633         dynargs[3] = args[3];
634         dynargs[4] = args[4];
635         return oraclize_query(datasource, dynargs, gaslimit);
636     }
637     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
638         uint price = oraclize.getPrice(datasource);
639         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
640         bytes memory args = ba2cbor(argN);
641         return oraclize.queryN.value(price)(0, datasource, args);
642     }
643     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
644         uint price = oraclize.getPrice(datasource);
645         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
646         bytes memory args = ba2cbor(argN);
647         return oraclize.queryN.value(price)(timestamp, datasource, args);
648     }
649     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
650         uint price = oraclize.getPrice(datasource, gaslimit);
651         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
652         bytes memory args = ba2cbor(argN);
653         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
654     }
655     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
656         uint price = oraclize.getPrice(datasource, gaslimit);
657         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
658         bytes memory args = ba2cbor(argN);
659         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
660     }
661     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
662         bytes[] memory dynargs = new bytes[](1);
663         dynargs[0] = args[0];
664         return oraclize_query(datasource, dynargs);
665     }
666     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
667         bytes[] memory dynargs = new bytes[](1);
668         dynargs[0] = args[0];
669         return oraclize_query(timestamp, datasource, dynargs);
670     }
671     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
672         bytes[] memory dynargs = new bytes[](1);
673         dynargs[0] = args[0];
674         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
675     }
676     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
677         bytes[] memory dynargs = new bytes[](1);
678         dynargs[0] = args[0];
679         return oraclize_query(datasource, dynargs, gaslimit);
680     }
681 
682     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
683         bytes[] memory dynargs = new bytes[](2);
684         dynargs[0] = args[0];
685         dynargs[1] = args[1];
686         return oraclize_query(datasource, dynargs);
687     }
688     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
689         bytes[] memory dynargs = new bytes[](2);
690         dynargs[0] = args[0];
691         dynargs[1] = args[1];
692         return oraclize_query(timestamp, datasource, dynargs);
693     }
694     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
695         bytes[] memory dynargs = new bytes[](2);
696         dynargs[0] = args[0];
697         dynargs[1] = args[1];
698         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
699     }
700     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
701         bytes[] memory dynargs = new bytes[](2);
702         dynargs[0] = args[0];
703         dynargs[1] = args[1];
704         return oraclize_query(datasource, dynargs, gaslimit);
705     }
706     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
707         bytes[] memory dynargs = new bytes[](3);
708         dynargs[0] = args[0];
709         dynargs[1] = args[1];
710         dynargs[2] = args[2];
711         return oraclize_query(datasource, dynargs);
712     }
713     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
714         bytes[] memory dynargs = new bytes[](3);
715         dynargs[0] = args[0];
716         dynargs[1] = args[1];
717         dynargs[2] = args[2];
718         return oraclize_query(timestamp, datasource, dynargs);
719     }
720     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
721         bytes[] memory dynargs = new bytes[](3);
722         dynargs[0] = args[0];
723         dynargs[1] = args[1];
724         dynargs[2] = args[2];
725         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
726     }
727     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
728         bytes[] memory dynargs = new bytes[](3);
729         dynargs[0] = args[0];
730         dynargs[1] = args[1];
731         dynargs[2] = args[2];
732         return oraclize_query(datasource, dynargs, gaslimit);
733     }
734 
735     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
736         bytes[] memory dynargs = new bytes[](4);
737         dynargs[0] = args[0];
738         dynargs[1] = args[1];
739         dynargs[2] = args[2];
740         dynargs[3] = args[3];
741         return oraclize_query(datasource, dynargs);
742     }
743     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
744         bytes[] memory dynargs = new bytes[](4);
745         dynargs[0] = args[0];
746         dynargs[1] = args[1];
747         dynargs[2] = args[2];
748         dynargs[3] = args[3];
749         return oraclize_query(timestamp, datasource, dynargs);
750     }
751     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
752         bytes[] memory dynargs = new bytes[](4);
753         dynargs[0] = args[0];
754         dynargs[1] = args[1];
755         dynargs[2] = args[2];
756         dynargs[3] = args[3];
757         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
758     }
759     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
760         bytes[] memory dynargs = new bytes[](4);
761         dynargs[0] = args[0];
762         dynargs[1] = args[1];
763         dynargs[2] = args[2];
764         dynargs[3] = args[3];
765         return oraclize_query(datasource, dynargs, gaslimit);
766     }
767     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
768         bytes[] memory dynargs = new bytes[](5);
769         dynargs[0] = args[0];
770         dynargs[1] = args[1];
771         dynargs[2] = args[2];
772         dynargs[3] = args[3];
773         dynargs[4] = args[4];
774         return oraclize_query(datasource, dynargs);
775     }
776     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
777         bytes[] memory dynargs = new bytes[](5);
778         dynargs[0] = args[0];
779         dynargs[1] = args[1];
780         dynargs[2] = args[2];
781         dynargs[3] = args[3];
782         dynargs[4] = args[4];
783         return oraclize_query(timestamp, datasource, dynargs);
784     }
785     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
786         bytes[] memory dynargs = new bytes[](5);
787         dynargs[0] = args[0];
788         dynargs[1] = args[1];
789         dynargs[2] = args[2];
790         dynargs[3] = args[3];
791         dynargs[4] = args[4];
792         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
793     }
794     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
795         bytes[] memory dynargs = new bytes[](5);
796         dynargs[0] = args[0];
797         dynargs[1] = args[1];
798         dynargs[2] = args[2];
799         dynargs[3] = args[3];
800         dynargs[4] = args[4];
801         return oraclize_query(datasource, dynargs, gaslimit);
802     }
803 
804     function oraclize_cbAddress() oraclizeAPI internal returns (address){
805         return oraclize.cbAddress();
806     }
807     function oraclize_setProof(byte proofP) oraclizeAPI internal {
808         return oraclize.setProofType(proofP);
809     }
810     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
811         return oraclize.setCustomGasPrice(gasPrice);
812     }
813 
814     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
815         return oraclize.randomDS_getSessionPubKeyHash();
816     }
817 
818     function getCodeSize(address _addr) view internal returns(uint _size) {
819         assembly {
820             _size := extcodesize(_addr)
821         }
822     }
823 
824     function parseAddr(string _a) internal pure returns (address){
825         bytes memory tmp = bytes(_a);
826         uint160 iaddr = 0;
827         uint160 b1;
828         uint160 b2;
829         for (uint i=2; i<2+2*20; i+=2){
830             iaddr *= 256;
831             b1 = uint160(tmp[i]);
832             b2 = uint160(tmp[i+1]);
833             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
834             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
835             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
836             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
837             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
838             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
839             iaddr += (b1*16+b2);
840         }
841         return address(iaddr);
842     }
843 
844     function strCompare(string _a, string _b) internal pure returns (int) {
845         bytes memory a = bytes(_a);
846         bytes memory b = bytes(_b);
847         uint minLength = a.length;
848         if (b.length < minLength) minLength = b.length;
849         for (uint i = 0; i < minLength; i ++)
850             if (a[i] < b[i])
851                 return -1;
852             else if (a[i] > b[i])
853                 return 1;
854         if (a.length < b.length)
855             return -1;
856         else if (a.length > b.length)
857             return 1;
858         else
859             return 0;
860     }
861 
862     function indexOf(string _haystack, string _needle) internal pure returns (int) {
863         bytes memory h = bytes(_haystack);
864         bytes memory n = bytes(_needle);
865         if(h.length < 1 || n.length < 1 || (n.length > h.length))
866             return -1;
867         else if(h.length > (2**128 -1))
868             return -1;
869         else
870         {
871             uint subindex = 0;
872             for (uint i = 0; i < h.length; i ++)
873             {
874                 if (h[i] == n[0])
875                 {
876                     subindex = 1;
877                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
878                     {
879                         subindex++;
880                     }
881                     if(subindex == n.length)
882                         return int(i);
883                 }
884             }
885             return -1;
886         }
887     }
888 
889     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
890         bytes memory _ba = bytes(_a);
891         bytes memory _bb = bytes(_b);
892         bytes memory _bc = bytes(_c);
893         bytes memory _bd = bytes(_d);
894         bytes memory _be = bytes(_e);
895         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
896         bytes memory babcde = bytes(abcde);
897         uint k = 0;
898         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
899         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
900         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
901         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
902         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
903         return string(babcde);
904     }
905 
906     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
907         return strConcat(_a, _b, _c, _d, "");
908     }
909 
910     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
911         return strConcat(_a, _b, _c, "", "");
912     }
913 
914     function strConcat(string _a, string _b) internal pure returns (string) {
915         return strConcat(_a, _b, "", "", "");
916     }
917 
918     // parseInt
919     function parseInt(string _a) internal pure returns (uint) {
920         return parseInt(_a, 0);
921     }
922 
923     // parseInt(parseFloat*10^_b)
924     function parseInt(string _a, uint _b) internal pure returns (uint) {
925         bytes memory bresult = bytes(_a);
926         uint mint = 0;
927         bool decimals = false;
928         for (uint i=0; i<bresult.length; i++){
929             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
930                 if (decimals){
931                    if (_b == 0) break;
932                     else _b--;
933                 }
934                 mint *= 10;
935                 mint += uint(bresult[i]) - 48;
936             } else if (bresult[i] == 46) decimals = true;
937         }
938         if (_b > 0) mint *= 10**_b;
939         return mint;
940     }
941 
942     function uint2str(uint i) internal pure returns (string){
943         if (i == 0) return "0";
944         uint j = i;
945         uint len;
946         while (j != 0){
947             len++;
948             j /= 10;
949         }
950         bytes memory bstr = new bytes(len);
951         uint k = len - 1;
952         while (i != 0){
953             bstr[k--] = byte(48 + i % 10);
954             i /= 10;
955         }
956         return string(bstr);
957     }
958 
959     using CBOR for Buffer.buffer;
960     function stra2cbor(string[] arr) internal pure returns (bytes) {
961         safeMemoryCleaner();
962         Buffer.buffer memory buf;
963         Buffer.init(buf, 1024);
964         buf.startArray();
965         for (uint i = 0; i < arr.length; i++) {
966             buf.encodeString(arr[i]);
967         }
968         buf.endSequence();
969         return buf.buf;
970     }
971 
972     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
973         safeMemoryCleaner();
974         Buffer.buffer memory buf;
975         Buffer.init(buf, 1024);
976         buf.startArray();
977         for (uint i = 0; i < arr.length; i++) {
978             buf.encodeBytes(arr[i]);
979         }
980         buf.endSequence();
981         return buf.buf;
982     }
983 
984     string oraclize_network_name;
985     function oraclize_setNetworkName(string _network_name) internal {
986         oraclize_network_name = _network_name;
987     }
988 
989     function oraclize_getNetworkName() internal view returns (string) {
990         return oraclize_network_name;
991     }
992 
993     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
994         require((_nbytes > 0) && (_nbytes <= 32));
995         // Convert from seconds to ledger timer ticks
996         _delay *= 10;
997         bytes memory nbytes = new bytes(1);
998         nbytes[0] = byte(_nbytes);
999         bytes memory unonce = new bytes(32);
1000         bytes memory sessionKeyHash = new bytes(32);
1001         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1002         assembly {
1003             mstore(unonce, 0x20)
1004             // the following variables can be relaxed
1005             // check relaxed random contract under ethereum-examples repo
1006             // for an idea on how to override and replace comit hash vars
1007             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1008             mstore(sessionKeyHash, 0x20)
1009             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1010         }
1011         bytes memory delay = new bytes(32);
1012         assembly {
1013             mstore(add(delay, 0x20), _delay)
1014         }
1015 
1016         bytes memory delay_bytes8 = new bytes(8);
1017         copyBytes(delay, 24, 8, delay_bytes8, 0);
1018 
1019         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1020         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1021 
1022         bytes memory delay_bytes8_left = new bytes(8);
1023 
1024         assembly {
1025             let x := mload(add(delay_bytes8, 0x20))
1026             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1027             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1028             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1029             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1030             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1031             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1032             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1033             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1034 
1035         }
1036 
1037         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1038         return queryId;
1039     }
1040 
1041     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1042         oraclize_randomDS_args[queryId] = commitment;
1043     }
1044 
1045     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1046     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1047 
1048     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1049         bool sigok;
1050         address signer;
1051 
1052         bytes32 sigr;
1053         bytes32 sigs;
1054 
1055         bytes memory sigr_ = new bytes(32);
1056         uint offset = 4+(uint(dersig[3]) - 0x20);
1057         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1058         bytes memory sigs_ = new bytes(32);
1059         offset += 32 + 2;
1060         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1061 
1062         assembly {
1063             sigr := mload(add(sigr_, 32))
1064             sigs := mload(add(sigs_, 32))
1065         }
1066 
1067 
1068         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1069         if (address(keccak256(pubkey)) == signer) return true;
1070         else {
1071             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1072             return (address(keccak256(pubkey)) == signer);
1073         }
1074     }
1075 
1076     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1077         bool sigok;
1078 
1079         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1080         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1081         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1082 
1083         bytes memory appkey1_pubkey = new bytes(64);
1084         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1085 
1086         bytes memory tosign2 = new bytes(1+65+32);
1087         tosign2[0] = byte(1); //role
1088         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1089         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1090         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1091         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1092 
1093         if (sigok == false) return false;
1094 
1095 
1096         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1097         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1098 
1099         bytes memory tosign3 = new bytes(1+65);
1100         tosign3[0] = 0xFE;
1101         copyBytes(proof, 3, 65, tosign3, 1);
1102 
1103         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1104         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1105 
1106         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1107 
1108         return sigok;
1109     }
1110 
1111     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1112         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1113         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1114 
1115         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1116         require(proofVerified);
1117 
1118         _;
1119     }
1120 
1121     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1122         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1123         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1124 
1125         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1126         if (proofVerified == false) return 2;
1127 
1128         return 0;
1129     }
1130 
1131     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1132         bool match_ = true;
1133 
1134         require(prefix.length == n_random_bytes);
1135 
1136         for (uint256 i=0; i< n_random_bytes; i++) {
1137             if (content[i] != prefix[i]) match_ = false;
1138         }
1139 
1140         return match_;
1141     }
1142 
1143     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1144 
1145         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1146         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1147         bytes memory keyhash = new bytes(32);
1148         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1149         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(context_name, queryId)))))) return false;
1150 
1151         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1152         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1153 
1154         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1155         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1156 
1157         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1158         // This is to verify that the computed args match with the ones specified in the query.
1159         bytes memory commitmentSlice1 = new bytes(8+1+32);
1160         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1161 
1162         bytes memory sessionPubkey = new bytes(64);
1163         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1164         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1165 
1166         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1167         if (oraclize_randomDS_args[queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))){ //unonce, nbytes and sessionKeyHash match
1168             delete oraclize_randomDS_args[queryId];
1169         } else return false;
1170 
1171 
1172         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1173         bytes memory tosign1 = new bytes(32+8+1+32);
1174         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1175         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1176 
1177         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1178         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1179             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1180         }
1181 
1182         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1183     }
1184 
1185     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1186     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1187         uint minLength = length + toOffset;
1188 
1189         // Buffer too small
1190         require(to.length >= minLength); // Should be a better way?
1191 
1192         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1193         uint i = 32 + fromOffset;
1194         uint j = 32 + toOffset;
1195 
1196         while (i < (32 + fromOffset + length)) {
1197             assembly {
1198                 let tmp := mload(add(from, i))
1199                 mstore(add(to, j), tmp)
1200             }
1201             i += 32;
1202             j += 32;
1203         }
1204 
1205         return to;
1206     }
1207 
1208     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1209     // Duplicate Solidity's ecrecover, but catching the CALL return value
1210     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1211         // We do our own memory management here. Solidity uses memory offset
1212         // 0x40 to store the current end of memory. We write past it (as
1213         // writes are memory extensions), but don't update the offset so
1214         // Solidity will reuse it. The memory used here is only needed for
1215         // this context.
1216 
1217         // FIXME: inline assembly can't access return values
1218         bool ret;
1219         address addr;
1220 
1221         assembly {
1222             let size := mload(0x40)
1223             mstore(size, hash)
1224             mstore(add(size, 32), v)
1225             mstore(add(size, 64), r)
1226             mstore(add(size, 96), s)
1227 
1228             // NOTE: we can reuse the request memory because we deal with
1229             //       the return code
1230             ret := call(3000, 1, 0, size, 128, size, 32)
1231             addr := mload(size)
1232         }
1233 
1234         return (ret, addr);
1235     }
1236 
1237     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1238     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1239         bytes32 r;
1240         bytes32 s;
1241         uint8 v;
1242 
1243         if (sig.length != 65)
1244           return (false, 0);
1245 
1246         // The signature format is a compact form of:
1247         //   {bytes32 r}{bytes32 s}{uint8 v}
1248         // Compact means, uint8 is not padded to 32 bytes.
1249         assembly {
1250             r := mload(add(sig, 32))
1251             s := mload(add(sig, 64))
1252 
1253             // Here we are loading the last 32 bytes. We exploit the fact that
1254             // 'mload' will pad with zeroes if we overread.
1255             // There is no 'mload8' to do this, but that would be nicer.
1256             v := byte(0, mload(add(sig, 96)))
1257 
1258             // Alternative solution:
1259             // 'byte' is not working due to the Solidity parser, so lets
1260             // use the second best option, 'and'
1261             // v := and(mload(add(sig, 65)), 255)
1262         }
1263 
1264         // albeit non-transactional signatures are not specified by the YP, one would expect it
1265         // to match the YP range of [27, 28]
1266         //
1267         // geth uses [0, 1] and some clients have followed. This might change, see:
1268         //  https://github.com/ethereum/go-ethereum/issues/2053
1269         if (v < 27)
1270           v += 27;
1271 
1272         if (v != 27 && v != 28)
1273             return (false, 0);
1274 
1275         return safer_ecrecover(hash, v, r, s);
1276     }
1277 
1278     function safeMemoryCleaner() internal pure {
1279         assembly {
1280             let fmem := mload(0x40)
1281             codecopy(fmem, codesize, sub(msize, fmem))
1282         }
1283     }
1284 
1285 }
1286 // </ORACLIZE_API>
1287 
1288 pragma solidity ^0.4.24;
1289 
1290 /**
1291  * @title Ownable
1292  * @dev The Ownable contract has an owner address, and provides basic authorization control
1293  * functions, this simplifies the implementation of "user permissions".
1294  */
1295 contract Ownable {
1296     address private _owner;
1297 
1298     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1299 
1300     /**
1301      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1302      * account.
1303      */
1304     constructor () internal {
1305         _owner = msg.sender;
1306         emit OwnershipTransferred(address(0), _owner);
1307     }
1308 
1309     /**
1310      * @return the address of the owner.
1311      */
1312     function owner() public view returns (address) {
1313         return _owner;
1314     }
1315 
1316     /**
1317      * @dev Throws if called by any account other than the owner.
1318      */
1319     modifier onlyOwner() {
1320         require(isOwner());
1321         _;
1322     }
1323 
1324     /**
1325      * @return true if `msg.sender` is the owner of the contract.
1326      */
1327     function isOwner() public view returns (bool) {
1328         return msg.sender == _owner;
1329     }
1330 
1331     /**
1332      * @dev Allows the current owner to relinquish control of the contract.
1333      * @notice Renouncing to ownership will leave the contract without an owner.
1334      * It will not be possible to call the functions with the `onlyOwner`
1335      * modifier anymore.
1336      */
1337     function renounceOwnership() public onlyOwner {
1338         emit OwnershipTransferred(_owner, address(0));
1339         _owner = address(0);
1340     }
1341 
1342     /**
1343      * @dev Allows the current owner to transfer control of the contract to a newOwner.
1344      * @param newOwner The address to transfer ownership to.
1345      */
1346     function transferOwnership(address newOwner) public onlyOwner {
1347         _transferOwnership(newOwner);
1348     }
1349 
1350     /**
1351      * @dev Transfers control of the contract to a newOwner.
1352      * @param newOwner The address to transfer ownership to.
1353      */
1354     function _transferOwnership(address newOwner) internal {
1355         require(newOwner != address(0));
1356         emit OwnershipTransferred(_owner, newOwner);
1357         _owner = newOwner;
1358     }
1359 }
1360 
1361 pragma solidity ^0.4.24;
1362 
1363 /**
1364  * @title ERC20 interface
1365  * @dev see https://github.com/ethereum/EIPs/issues/20
1366  */
1367 interface IERC20 {
1368     function totalSupply() external view returns (uint256);
1369 
1370     function balanceOf(address who) external view returns (uint256);
1371 
1372     function allowance(address owner, address spender) external view returns (uint256);
1373 
1374     function transfer(address to, uint256 value) external returns (bool);
1375 
1376     function approve(address spender, uint256 value) external returns (bool);
1377 
1378     function transferFrom(address from, address to, uint256 value) external returns (bool);
1379 
1380     event Transfer(address indexed from, address indexed to, uint256 value);
1381 
1382     event Approval(address indexed owner, address indexed spender, uint256 value);
1383 }
1384 
1385 pragma solidity ^0.4.24;
1386 
1387 /**
1388  * @title ERC20Detailed token
1389  * @dev The decimals are only for visualization purposes.
1390  * All the operations are done using the smallest and indivisible token unit,
1391  * just as on Ethereum all the operations are done in wei.
1392  */
1393 contract ERC20Detailed is IERC20 {
1394     string private _name;
1395     string private _symbol;
1396     uint8 private _decimals;
1397 
1398     constructor (string name, string symbol, uint8 decimals) public {
1399         _name = name;
1400         _symbol = symbol;
1401         _decimals = decimals;
1402     }
1403 
1404     /**
1405      * @return the name of the token.
1406      */
1407     function name() public view returns (string) {
1408         return _name;
1409     }
1410 
1411     /**
1412      * @return the symbol of the token.
1413      */
1414     function symbol() public view returns (string) {
1415         return _symbol;
1416     }
1417 
1418     /**
1419      * @return the number of decimals of the token.
1420      */
1421     function decimals() public view returns (uint8) {
1422         return _decimals;
1423     }
1424 }
1425 
1426 /**
1427  * @title Standard ERC20 token
1428  *
1429  * @dev Implementation of the basic standard token.
1430  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
1431  * Originally based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
1432  *
1433  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
1434  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
1435  * compliant implementations may not do it.
1436  */
1437 contract ERC20 is IERC20 {
1438     using SafeMath for uint256;
1439 
1440     mapping (address => uint256) private _balances;
1441     mapping (address => mapping (address => uint256)) private _allowed;
1442     uint256 private _totalSupply;
1443 
1444     /**
1445     * @dev Total number of tokens in existence
1446     */
1447     function totalSupply() public view returns (uint256) {
1448         return _totalSupply;
1449     }
1450 
1451     /**
1452     * @dev Gets the balance of the specified address.
1453     * @param owner The address to query the balance of.
1454     * @return An uint256 representing the amount owned by the passed address.
1455     */
1456     function balanceOf(address owner) public view returns (uint256) {
1457         return _balances[owner];
1458     }
1459 
1460     /**
1461      * @dev Function to check the amount of tokens that an owner allowed to a spender.
1462      * @param owner address The address which owns the funds.
1463      * @param spender address The address which will spend the funds.
1464      * @return A uint256 specifying the amount of tokens still available for the spender.
1465      */
1466     function allowance(address owner, address spender) public view returns (uint256) {
1467         return _allowed[owner][spender];
1468     }
1469 
1470     /**
1471     * @dev Transfer token for a specified address
1472     * @param to The address to transfer to.
1473     * @param value The amount to be transferred.
1474     */
1475     function transfer(address to, uint256 value) public returns (bool) {
1476         _transfer(msg.sender, to, value);
1477         return true;
1478     }
1479 
1480     /**
1481      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1482      * Beware that changing an allowance with this method brings the risk that someone may use both the old
1483      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1484      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1485      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1486      * @param spender The address which will spend the funds.
1487      * @param value The amount of tokens to be spent.
1488      */
1489     function approve(address spender, uint256 value) public returns (bool) {
1490         require(spender != address(0));
1491 
1492         _allowed[msg.sender][spender] = value;
1493         emit Approval(msg.sender, spender, value);
1494         return true;
1495     }
1496 
1497     /**
1498      * @dev Transfer tokens from one address to another.
1499      * Note that while this function emits an Approval event, this is not required as per the specification,
1500      * and other compliant implementations may not emit the event.
1501      * @param from address The address which you want to send tokens from
1502      * @param to address The address which you want to transfer to
1503      * @param value uint256 the amount of tokens to be transferred
1504      */
1505     function transferFrom(address from, address to, uint256 value) public returns (bool) {
1506         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
1507         _transfer(from, to, value);
1508         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
1509         return true;
1510     }
1511 
1512     /**
1513      * @dev Increase the amount of tokens that an owner allowed to a spender.
1514      * approve should be called when allowed_[_spender] == 0. To increment
1515      * allowed value is better to use this function to avoid 2 calls (and wait until
1516      * the first transaction is mined)
1517      * From MonolithDAO Token.sol
1518      * Emits an Approval event.
1519      * @param spender The address which will spend the funds.
1520      * @param addedValue The amount of tokens to increase the allowance by.
1521      */
1522     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
1523         require(spender != address(0));
1524 
1525         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
1526         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
1527         return true;
1528     }
1529 
1530     /**
1531      * @dev Decrease the amount of tokens that an owner allowed to a spender.
1532      * approve should be called when allowed_[_spender] == 0. To decrement
1533      * allowed value is better to use this function to avoid 2 calls (and wait until
1534      * the first transaction is mined)
1535      * From MonolithDAO Token.sol
1536      * Emits an Approval event.
1537      * @param spender The address which will spend the funds.
1538      * @param subtractedValue The amount of tokens to decrease the allowance by.
1539      */
1540     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
1541         require(spender != address(0));
1542 
1543         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
1544         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
1545         return true;
1546     }
1547 
1548     /**
1549     * @dev Transfer token for a specified addresses
1550     * @param from The address to transfer from.
1551     * @param to The address to transfer to.
1552     * @param value The amount to be transferred.
1553     */
1554     function _transfer(address from, address to, uint256 value) internal {
1555         require(to != address(0));
1556 
1557         _balances[from] = _balances[from].sub(value);
1558         _balances[to] = _balances[to].add(value);
1559         emit Transfer(from, to, value);
1560     }
1561 
1562     /**
1563      * @dev Internal function that mints an amount of the token and assigns it to
1564      * an account. This encapsulates the modification of balances such that the
1565      * proper events are emitted.
1566      * @param account The account that will receive the created tokens.
1567      * @param value The amount that will be created.
1568      */
1569     function _mint(address account, uint256 value) internal {
1570         require(account != address(0));
1571 
1572         _totalSupply = _totalSupply.add(value);
1573         _balances[account] = _balances[account].add(value);
1574         emit Transfer(address(0), account, value);
1575     }
1576 
1577     /**
1578      * @dev Internal function that burns an amount of the token of a given
1579      * account.
1580      * @param account The account whose tokens will be burnt.
1581      * @param value The amount that will be burnt.
1582      */
1583     function _burn(address account, uint256 value) internal {
1584         require(account != address(0));
1585 
1586         _totalSupply = _totalSupply.sub(value);
1587         _balances[account] = _balances[account].sub(value);
1588         emit Transfer(account, address(0), value);
1589     }
1590 }
1591 
1592 contract BonusToken is ERC20, ERC20Detailed, Ownable {
1593 
1594     address public gameAddress;
1595     address public investTokenAddress;
1596     uint public maxLotteryParticipants;
1597 
1598     mapping (address => uint256) public ethLotteryBalances;
1599     address[] public ethLotteryParticipants;
1600     uint256 public ethLotteryBank;
1601     bool public isEthLottery;
1602 
1603     mapping (address => uint256) public tokensLotteryBalances;
1604     address[] public tokensLotteryParticipants;
1605     uint256 public tokensLotteryBank;
1606     bool public isTokensLottery;
1607 
1608     modifier onlyGame() {
1609         require(msg.sender == gameAddress);
1610         _;
1611     }
1612 
1613     modifier tokenIsAvailable {
1614         require(investTokenAddress != address(0));
1615         _;
1616     }
1617 
1618     constructor (address startGameAddress) public ERC20Detailed("Bet Token", "BET", 18) {
1619         setGameAddress(startGameAddress);
1620     }
1621 
1622     function setGameAddress(address newGameAddress) public onlyOwner {
1623         require(newGameAddress != address(0));
1624         gameAddress = newGameAddress;
1625     }
1626 
1627     function buyTokens(address buyer, uint256 tokensAmount) public onlyGame {
1628         _mint(buyer, tokensAmount * 10**18);
1629     }
1630 
1631     function startEthLottery() public onlyGame {
1632         isEthLottery = true;
1633     }
1634 
1635     function startTokensLottery() public onlyGame tokenIsAvailable {
1636         isTokensLottery = true;
1637     }
1638 
1639     function restartEthLottery() public onlyGame {
1640         for (uint i = 0; i < ethLotteryParticipants.length; i++) {
1641             ethLotteryBalances[ethLotteryParticipants[i]] = 0;
1642         }
1643         ethLotteryParticipants = new address[](0);
1644         ethLotteryBank = 0;
1645         isEthLottery = false;
1646     }
1647 
1648     function restartTokensLottery() public onlyGame tokenIsAvailable {
1649         for (uint i = 0; i < tokensLotteryParticipants.length; i++) {
1650             tokensLotteryBalances[tokensLotteryParticipants[i]] = 0;
1651         }
1652         tokensLotteryParticipants = new address[](0);
1653         tokensLotteryBank = 0;
1654         isTokensLottery = false;
1655     }
1656 
1657     function updateEthLotteryBank(uint256 value) public onlyGame {
1658         ethLotteryBank = ethLotteryBank.sub(value);
1659     }
1660 
1661     function updateTokensLotteryBank(uint256 value) public onlyGame {
1662         tokensLotteryBank = tokensLotteryBank.sub(value);
1663     }
1664 
1665     function swapTokens(address account, uint256 tokensToBurnAmount) public {
1666         require(msg.sender == investTokenAddress);
1667         _burn(account, tokensToBurnAmount);
1668     }
1669 
1670     function sendToEthLottery(uint256 value) public {
1671         require(!isEthLottery);
1672         require(ethLotteryParticipants.length < maxLotteryParticipants);
1673         address account = msg.sender;
1674         _burn(account, value);
1675         if (ethLotteryBalances[account] == 0) {
1676             ethLotteryParticipants.push(account);
1677         }
1678         ethLotteryBalances[account] = ethLotteryBalances[account].add(value);
1679         ethLotteryBank = ethLotteryBank.add(value);
1680     }
1681 
1682     function sendToTokensLottery(uint256 value) public tokenIsAvailable {
1683         require(!isTokensLottery);
1684         require(tokensLotteryParticipants.length < maxLotteryParticipants);
1685         address account = msg.sender;
1686         _burn(account, value);
1687         if (tokensLotteryBalances[account] == 0) {
1688             tokensLotteryParticipants.push(account);
1689         }
1690         tokensLotteryBalances[account] = tokensLotteryBalances[account].add(value);
1691         tokensLotteryBank = tokensLotteryBank.add(value);
1692     }
1693 
1694     function ethLotteryParticipants() public view returns(address[]) {
1695         return ethLotteryParticipants;
1696     }
1697 
1698     function tokensLotteryParticipants() public view returns(address[]) {
1699         return tokensLotteryParticipants;
1700     }
1701 
1702     function setInvestTokenAddress(address newInvestTokenAddress) external onlyOwner {
1703         require(newInvestTokenAddress != address(0));
1704         investTokenAddress = newInvestTokenAddress;
1705     }
1706 
1707     function setMaxLotteryParticipants(uint256 participants) external onlyOwner {
1708         maxLotteryParticipants = participants;
1709     }
1710 }
1711 
1712 contract modERC20 is IERC20 {
1713     using SafeMath for uint256;
1714 
1715     uint256 constant public MIN_HOLDERS_BALANCE = 20 ether;
1716 
1717     mapping (address => uint256) private _balances;
1718     mapping (address => mapping (address => uint256)) private _allowed;
1719     uint256 private _totalSupply;
1720 
1721     address public gameAddress;
1722 
1723     address[] internal holders;
1724     mapping(address => bool) internal isUser;
1725 
1726     function getHolders() public view returns (address[]) {
1727         return holders;
1728     }
1729 
1730     /**
1731     * @dev Total number of tokens in existence
1732     */
1733     function totalSupply() public view returns (uint256) {
1734         return _totalSupply;
1735     }
1736 
1737     /**
1738     * @dev Gets the balance of the specified address.
1739     * @param owner The address to query the balance of.
1740     * @return An uint256 representing the amount owned by the passed address.
1741     */
1742     function balanceOf(address owner) public view returns (uint256) {
1743         return _balances[owner];
1744     }
1745 
1746     /**
1747      * @dev Function to check the amount of tokens that an owner allowed to a spender.
1748      * @param owner address The address which owns the funds.
1749      * @param spender address The address which will spend the funds.
1750      * @return A uint256 specifying the amount of tokens still available for the spender.
1751      */
1752     function allowance(address owner, address spender) public view returns (uint256) {
1753         return _allowed[owner][spender];
1754     }
1755 
1756     /**
1757     * @dev Transfer token for a specified address
1758     * @param to The address to transfer to.
1759     * @param value The amount to be transferred.
1760     */
1761     function transfer(address to, uint256 value) public returns (bool) {
1762         _transfer(msg.sender, to, value);
1763         return true;
1764     }
1765 
1766     /**
1767      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1768      * Beware that changing an allowance with this method brings the risk that someone may use both the old
1769      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1770      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1771      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1772      * @param spender The address which will spend the funds.
1773      * @param value The amount of tokens to be spent.
1774      */
1775     function approve(address spender, uint256 value) public returns (bool) {
1776         require(spender != address(0));
1777 
1778         _allowed[msg.sender][spender] = value;
1779         emit Approval(msg.sender, spender, value);
1780         return true;
1781     }
1782 
1783     /**
1784      * @dev Transfer tokens from one address to another.
1785      * Note that while this function emits an Approval event, this is not required as per the specification,
1786      * and other compliant implementations may not emit the event.
1787      * @param from address The address which you want to send tokens from
1788      * @param to address The address which you want to transfer to
1789      * @param value uint256 the amount of tokens to be transferred
1790      */
1791     function transferFrom(address from, address to, uint256 value) public returns (bool) {
1792         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
1793         _transfer(from, to, value);
1794         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
1795         return true;
1796     }
1797 
1798     /**
1799      * @dev Increase the amount of tokens that an owner allowed to a spender.
1800      * approve should be called when allowed_[_spender] == 0. To increment
1801      * allowed value is better to use this function to avoid 2 calls (and wait until
1802      * the first transaction is mined)
1803      * From MonolithDAO Token.sol
1804      * Emits an Approval event.
1805      * @param spender The address which will spend the funds.
1806      * @param addedValue The amount of tokens to increase the allowance by.
1807      */
1808     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
1809         require(spender != address(0));
1810 
1811         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
1812         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
1813         return true;
1814     }
1815 
1816     /**
1817      * @dev Decrease the amount of tokens that an owner allowed to a spender.
1818      * approve should be called when allowed_[_spender] == 0. To decrement
1819      * allowed value is better to use this function to avoid 2 calls (and wait until
1820      * the first transaction is mined)
1821      * From MonolithDAO Token.sol
1822      * Emits an Approval event.
1823      * @param spender The address which will spend the funds.
1824      * @param subtractedValue The amount of tokens to decrease the allowance by.
1825      */
1826     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
1827         require(spender != address(0));
1828 
1829         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
1830         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
1831         return true;
1832     }
1833 
1834     /**
1835     * @dev Transfer token for a specified addresses
1836     * @param from The address to transfer from.
1837     * @param to The address to transfer to.
1838     * @param value The amount to be transferred.
1839     */
1840     function _transfer(address from, address to, uint256 value) internal {
1841         require(to != address(0));
1842 
1843         if (to != gameAddress && from != gameAddress) {
1844             uint256 transferFee = value.div(100);
1845             _burn(from, transferFee);
1846             value = value.sub(transferFee);
1847         }
1848         if (to != gameAddress && _balances[to] == 0 && value >= MIN_HOLDERS_BALANCE) {
1849             holders.push(to);
1850         }
1851         _balances[from] = _balances[from].sub(value);
1852         _balances[to] = _balances[to].add(value);
1853         emit Transfer(from, to, value);
1854     }
1855 
1856     /**
1857      * @dev Internal function that mints an amount of the token and assigns it to
1858      * an account. This encapsulates the modification of balances such that the
1859      * proper events are emitted.
1860      * @param account The account that will receive the created tokens.
1861      * @param value The amount that will be created.
1862      */
1863     function _mint(address account, uint256 value) internal {
1864         require(account != address(0));
1865 
1866         _totalSupply = _totalSupply.add(value);
1867         _balances[account] = _balances[account].add(value);
1868         emit Transfer(address(0), account, value);
1869     }
1870 
1871     /**
1872      * @dev Internal function that burns an amount of the token of a given
1873      * account.
1874      * @param account The account whose tokens will be burnt.
1875      * @param value The amount that will be burnt.
1876      */
1877     function _burn(address account, uint256 value) internal {
1878         require(account != address(0));
1879 
1880         _totalSupply = _totalSupply.sub(value);
1881         _balances[account] = _balances[account].sub(value);
1882         emit Transfer(account, address(0), value);
1883     }
1884 }
1885 
1886 contract InvestToken is modERC20, ERC20Detailed, Ownable {
1887 
1888     uint8 constant public REFERRER_PERCENT = 3;
1889     uint8 constant public CASHBACK_PERCENT = 2;
1890     uint8 constant public HOLDERS_BUY_PERCENT_WITH_REFERRER = 7;
1891     uint8 constant public HOLDERS_BUY_PERCENT_WITH_REFERRER_AND_CASHBACK = 5;
1892     uint8 constant public HOLDERS_BUY_PERCENT = 10;
1893     uint8 constant public HOLDERS_SELL_PERCENT = 5;
1894     uint8 constant public TOKENS_DIVIDER = 10;
1895     uint256 constant public PRICE_INTERVAL = 10000000000;
1896 
1897     uint256 public swapTokensLimit;
1898     uint256 public investDividends;
1899     uint256 public casinoDividends;
1900     mapping(address => uint256) public ethStorage;
1901     mapping(address => address) public referrers;
1902     mapping(address => uint256) public investSize24h;
1903     mapping(address => uint256) public lastInvestTime;
1904     BonusToken public bonusToken;
1905 
1906     uint256 private holdersIndex;
1907     uint256 private totalInvestDividends;
1908     uint256 private totalCasinoDividends;
1909     uint256 private priceCoeff = 105e9;
1910     uint256 private constant a = 5e9;
1911 
1912     event Buy(address indexed buyer, uint256 weiAmount, uint256 tokensAmount, uint256 timestamp);
1913     event Sell(address indexed seller, uint256 weiAmount, uint256 tokensAmount, uint256 timestamp);
1914     event Reinvest(address indexed investor, uint256 weiAmount, uint256 tokensAmount, uint256 timestamp);
1915     event Withdraw(address indexed investor, uint256 weiAmount, uint256 timestamp);
1916     event ReferalsIncome(address indexed recipient, uint256 amount, uint256 timestamp);
1917     event InvestIncome(address indexed recipient, uint256 amount, uint256 timestamp);
1918     event CasinoIncome(address indexed recipient, uint256 amount, uint256 timestamp);
1919 
1920     constructor (address _bonusToken) public ERC20Detailed("Get Token", "GET", 18) {
1921         require(_bonusToken != address (0));
1922         bonusToken = BonusToken(_bonusToken);
1923         swapTokensLimit = 10000;
1924         swapTokensLimit = swapTokensLimit.mul(10 ** uint256(decimals()));
1925     }
1926 
1927     modifier onlyGame() {
1928         require(msg.sender == gameAddress, 'The sender must be a game contract.');
1929         _;
1930     }
1931 
1932     function () public payable {
1933         if (msg.sender != gameAddress) {
1934             address referrer;
1935             if (msg.data.length == 20) {
1936                 referrer = bytesToAddress(bytes(msg.data));
1937             }
1938             buyTokens(referrer);
1939         }
1940     }
1941 
1942     function buyTokens(address referrer) public payable {
1943         uint256 weiAmount = msg.value;
1944         address buyer = msg.sender;
1945         uint256 tokensAmount;
1946         (weiAmount, tokensAmount) = mint(buyer, weiAmount);
1947         uint256 correctWeiAmount = msg.value.sub(weiAmount);
1948         checkInvestTimeAndSize(buyer, correctWeiAmount);
1949         if (!isUser[buyer]) {
1950             if (referrer != address(0) && referrer != buyer) {
1951                 referrers[buyer] = referrer;
1952             }
1953             buyFee(buyer, correctWeiAmount, true);
1954             isUser[buyer] = true;
1955         } else {
1956             buyFee(buyer, correctWeiAmount, false);
1957         }
1958         if (weiAmount > 0) {
1959             buyer.transfer(weiAmount);
1960         }
1961         if (balanceOf(buyer) >= MIN_HOLDERS_BALANCE) {
1962             holders.push(buyer);
1963         }
1964         emit Buy(buyer, correctWeiAmount, tokensAmount, now);
1965     }
1966 
1967     function sellTokens(uint256 tokensAmount) public {
1968         address seller = msg.sender;
1969         _burn(seller, tokensAmount.mul(10 ** uint256(decimals())));
1970         uint256 weiAmount = tokensToEthereum(tokensAmount);
1971         weiAmount = sellFee(weiAmount);
1972         seller.transfer(weiAmount);
1973         emit Sell(seller, weiAmount, tokensAmount, now);
1974     }
1975 
1976     function swapTokens(uint256 tokensAmountToBurn) public {
1977         uint256 tokensAmountToMint = tokensAmountToBurn.div(TOKENS_DIVIDER);
1978         require(tokensAmountToMint <= swapTokensLimit.sub(tokensAmountToMint));
1979         require(bonusToken.balanceOf(msg.sender) >= tokensAmountToBurn, 'Not enough bonus tokens.');
1980         bonusToken.swapTokens(msg.sender, tokensAmountToBurn);
1981         swapTokensLimit = swapTokensLimit.sub(tokensAmountToMint);
1982         priceCoeff = priceCoeff.add(tokensAmountToMint.mul(1e10));
1983         _mint(msg.sender, tokensAmountToMint);
1984     }
1985 
1986     function reinvest(uint256 weiAmount) public {
1987         ethStorage[msg.sender] = ethStorage[msg.sender].sub(weiAmount);
1988         uint256 tokensAmount;
1989         (weiAmount, tokensAmount) = mint(msg.sender, weiAmount);
1990         if (weiAmount > 0) {
1991             ethStorage[msg.sender] = ethStorage[msg.sender].add(weiAmount);
1992         }
1993         emit Reinvest(msg.sender, weiAmount, tokensAmount, now);
1994     }
1995 
1996     function withdraw(uint256 weiAmount) public {
1997         require(weiAmount > 0);
1998         ethStorage[msg.sender] = ethStorage[msg.sender].sub(weiAmount);
1999         msg.sender.transfer(weiAmount);
2000         emit Withdraw(msg.sender, weiAmount, now);
2001     }
2002 
2003     function sendDividendsToHolders(uint holdersIterations) public onlyOwner {
2004         if (holdersIndex == 0) {
2005             totalInvestDividends = investDividends;
2006             totalCasinoDividends = casinoDividends;
2007         }
2008         uint holdersIterationsNumber;
2009         if (holders.length.sub(holdersIndex) < holdersIterations) {
2010             holdersIterationsNumber = holders.length.sub(holdersIndex);
2011         } else {
2012             holdersIterationsNumber = holdersIterations;
2013         }
2014         uint256 holdersBalance = 0;
2015         uint256 weiAmount = 0;
2016         for (uint256 i = 0; i < holdersIterationsNumber; i++) {
2017             holdersBalance = balanceOf(holders[holdersIndex]);
2018             if (holdersBalance >= MIN_HOLDERS_BALANCE) {
2019                 if (totalInvestDividends > 0) {
2020                     weiAmount = holdersBalance.mul(totalInvestDividends).div(totalSupply());
2021                     investDividends = investDividends.sub(weiAmount);
2022                     emit InvestIncome(holders[holdersIndex], weiAmount, now);
2023                     ethStorage[holders[holdersIndex]] = ethStorage[holders[holdersIndex]].add(weiAmount);
2024                 }
2025                 if (totalCasinoDividends > 0) {
2026                     weiAmount = holdersBalance.mul(totalCasinoDividends).div(totalSupply());
2027                     casinoDividends = casinoDividends.sub(weiAmount);
2028                     emit CasinoIncome(holders[holdersIndex], weiAmount, now);
2029                     ethStorage[holders[holdersIndex]] = ethStorage[holders[holdersIndex]].add(weiAmount);
2030                 }
2031             } else {
2032                 deleteTokensHolder(holdersIndex);
2033             }
2034             holdersIndex++;
2035         }
2036         if (holdersIndex == holders.length) {
2037             holdersIndex = 0;
2038         }
2039     }
2040 
2041     function setGameAddress(address newGameAddress) public onlyOwner {
2042         gameAddress = newGameAddress;
2043     }
2044 
2045     function sendToGame(address player, uint256 tokensAmount) public onlyGame returns(bool) {
2046         _transfer(player, gameAddress, tokensAmount);
2047         return true;
2048     }
2049 
2050     function gameDividends(uint256 weiAmount) public onlyGame {
2051         casinoDividends = casinoDividends.add(weiAmount);
2052     }
2053 
2054     function price() public view returns(uint256) {
2055         return priceCoeff.add(a);
2056     }
2057 
2058     function mint(address account, uint256 weiAmount) private returns(uint256, uint256) {
2059         (uint256 tokensToMint, uint256 backPayWeiAmount) = ethereumToTokens(weiAmount);
2060         _mint(account, tokensToMint);
2061         return (backPayWeiAmount, tokensToMint);
2062     }
2063 
2064     function checkInvestTimeAndSize(address account, uint256 weiAmount) private {
2065         if (now - lastInvestTime[account] > 24 hours) {
2066             investSize24h[account] = 0;
2067         }
2068         require(investSize24h[account].add(weiAmount) <= 5 ether, 'Investment limit exceeded for 24 hours.');
2069         investSize24h[account] = investSize24h[account].add(weiAmount);
2070         lastInvestTime[account] = now;
2071     }
2072 
2073     function buyFee(address sender, uint256 weiAmount, bool isFirstInvest) private {
2074         address referrer = referrers[sender];
2075         uint256 holdersWeiAmount;
2076         if (referrer != address(0)) {
2077             uint256 referrerWeiAmount = weiAmount.mul(REFERRER_PERCENT).div(100);
2078             emit ReferalsIncome(referrer, referrerWeiAmount, now);
2079             ethStorage[referrer] = ethStorage[referrer].add(referrerWeiAmount);
2080             if (isFirstInvest) {
2081                 uint256 cashbackWeiAmount = weiAmount.mul(CASHBACK_PERCENT).div(100);
2082                 emit ReferalsIncome(sender, cashbackWeiAmount, now);
2083                 ethStorage[sender] = ethStorage[sender].add(cashbackWeiAmount);
2084                 holdersWeiAmount = weiAmount.mul(HOLDERS_BUY_PERCENT_WITH_REFERRER_AND_CASHBACK).div(100);
2085             } else {
2086                 holdersWeiAmount = weiAmount.mul(HOLDERS_BUY_PERCENT_WITH_REFERRER).div(100);
2087             }
2088         } else {
2089             holdersWeiAmount = weiAmount.mul(HOLDERS_BUY_PERCENT).div(100);
2090         }
2091         addDividends(holdersWeiAmount);
2092     }
2093 
2094     function sellFee(uint256 weiAmount) private returns(uint256) {
2095         uint256 holdersWeiAmount = weiAmount.mul(HOLDERS_SELL_PERCENT).div(100);
2096         addDividends(holdersWeiAmount);
2097         weiAmount = weiAmount.sub(holdersWeiAmount);
2098         return weiAmount;
2099     }
2100 
2101     function addDividends(uint256 weiAmount) private {
2102         investDividends = investDividends.add(weiAmount);
2103     }
2104 
2105     function ethereumToTokens(uint256 weiAmount) private returns(uint256, uint256) {
2106         uint256 b = priceCoeff;
2107         uint256 c = weiAmount;
2108         uint256 D = (b ** 2).add(a.mul(4).mul(c));
2109         uint256 tokensAmount = (sqrt(D).sub(b)).div((a).mul(2));
2110         require(tokensAmount > 0);
2111         uint256 backPayWeiAmount = weiAmount.sub(a.mul(tokensAmount ** 2).add(priceCoeff.mul(tokensAmount)));
2112         priceCoeff = priceCoeff.add(tokensAmount.mul(1e10));
2113         tokensAmount = tokensAmount.mul(10 ** uint256(decimals()));
2114         return (tokensAmount, backPayWeiAmount);
2115     }
2116 
2117     function tokensToEthereum(uint256 tokensAmount) private returns(uint256) {
2118         require(tokensAmount > 0);
2119         uint256 weiAmount = priceCoeff.mul(tokensAmount).sub((tokensAmount ** 2).mul(5).mul(1e9));
2120         priceCoeff = priceCoeff.sub(tokensAmount.mul(1e10));
2121         return weiAmount;
2122     }
2123 
2124     function bytesToAddress(bytes source) private pure returns(address parsedAddress)
2125     {
2126         assembly {
2127             parsedAddress := mload(add(source,0x14))
2128         }
2129         return parsedAddress;
2130     }
2131 
2132     function sqrt(uint256 x) private pure returns (uint256 y) {
2133         uint256 z = (x + 1) / 2;
2134         y = x;
2135         while (z < y) {
2136             y = z;
2137             z = (x / z + z) / 2;
2138         }
2139     }
2140 
2141     function deleteTokensHolder(uint index) private {
2142         holders[index] = holders[holders.length - 1];
2143         delete holders[holders.length - 1];
2144         holders.length--;
2145     }
2146 }
2147 
2148 
2149 contract Game is usingOraclize, Ownable {
2150     using SafeMath for uint;
2151 
2152     uint private constant GAME_COIN_FlIP = 0;
2153     uint private constant GAME_DICE = 1;
2154     uint private constant GAME_TWO_DICE = 2;
2155     uint private constant GAME_ETHEROLL = 3;
2156     uint private constant LOTTERY_FEE = 0.002 ether;
2157     uint private constant BENEFICIAR_FEE_PERCENT = 5;
2158     uint private constant TOKEN_HOLDERS_FEE_PERCENT = 45;
2159     uint private constant MIN_ETH_BET = 0.01 ether;
2160     uint private constant MIN_TOKENS_BET = 0.01 ether;
2161 
2162     struct Query {
2163         uint amount;
2164         address gamer;
2165         uint[] values;
2166         uint prize;
2167         uint range;
2168         uint game;
2169         bool tokens;
2170         uint time;
2171         bool ended;
2172     }
2173     mapping(bytes32 => Query) public queries;
2174     mapping(address => uint) public waitingEthPrizes;
2175     mapping(address => uint) public waitingTokensPrizes;
2176     mapping(address => bool) public isBet;
2177     mapping(address => uint) public betsBalances;
2178     mapping(address => uint) public minEthRanges;
2179     mapping(address => uint) public maxEthRanges;
2180     mapping(address => uint) public minTokensRanges;
2181     mapping(address => uint) public maxTokensRanges;
2182     address[] public holdersInEthLottery;
2183     address[] public holdersInTokensLottery;
2184     address[] public players;
2185     bytes32 public ethLotteryQueryId;
2186     uint public ethLotterySize;
2187     uint public ethLotteryStage;
2188     uint public ethLotteryRound;
2189     uint public lastEthLotteryTime;
2190     bytes32 public tokensLotteryQueryId;
2191     uint public tokensLotterySize;
2192     uint public tokensLotteryStage;
2193     uint public tokensLotteryRound;
2194     uint public lastTokensLotteryTime;
2195     uint public lastSendBonusTokensTime;
2196     uint public callbackGas; // Gas for user __callback function by Oraclize
2197     uint public beneficiarFund;
2198     address public beneficiar;
2199     BonusToken public bonusToken;
2200     InvestToken public investToken;
2201 
2202     uint private playersIndex;
2203 
2204     event PlaceBet(address indexed gamer, bytes32 queryId, bool tokens);
2205     event Bet(address indexed gamer, uint indexed game, bool tokens, uint amount, uint result, uint[] winResult, uint prize, uint timestamp);
2206     event WinLottery(address indexed gamer, uint prize, uint ticketsAmount, uint indexed round, bool tokens);
2207 
2208     modifier valideAddress(address addr) {
2209         require(addr != address(0));
2210         _;
2211     }
2212 
2213     constructor(address startBeneficiarAddress) public valideAddress(startBeneficiarAddress) {
2214         oraclize_setCustomGasPrice(5000000000); // 5 gwei
2215         callbackGas = 300000;
2216         beneficiar = startBeneficiarAddress;
2217     }
2218 
2219     /*
2220     * @param game Game mode (0, 1, 2, 3), watch constants
2221     * @param values User selected numbers, length = 1 for coin flip game
2222     * @param referrer Referrer address (default is 0x0)
2223     *
2224     * NOTE: ALL USER NUMBERS START WITH 0
2225     * NOTE: ALL USER NUMBERS MUST GO ASCENDING
2226     *
2227     * call this function for place bet to coin flip game with number 0 (eagle)
2228     * placeBet(0, [0]);
2229     *
2230     * call this function for place bet to dice game with numbers 1, 2, 3, 4
2231     * placeBet(1, [0, 1, 2, 3]);
2232     *
2233     * call this function for place bet to two dice game with numbers 2, 3, 4, 7, 8, 11, 12
2234     * placeBet(2, [0, 1, 2, 5, 6, 9, 10]);
2235     *
2236     * call this function for place bet to etheroll game with numbers 1-38
2237     * placeBet(3, [37]);
2238     */
2239     function placeBet(uint game, uint[] values, uint tokensAmount) payable external {
2240         uint payAmount;
2241         if (tokensAmount == 0) {
2242             require(msg.value >= MIN_ETH_BET);
2243             payAmount = fee(msg.value, false);
2244         } else {
2245             require(tokensAmount >= MIN_TOKENS_BET);
2246             investToken.sendToGame(msg.sender, tokensAmount);
2247             payAmount = fee(tokensAmount, true);
2248         }
2249         require(game == GAME_COIN_FlIP || game == GAME_DICE || game == GAME_TWO_DICE || game == GAME_ETHEROLL);
2250         require(valideBet(game, values));
2251         uint range;
2252         uint winChance;
2253         if (game == GAME_COIN_FlIP) {
2254             require(values.length == 1);
2255             range = 2;
2256             winChance = 5000;
2257         } else if (game == GAME_DICE) {
2258             require(values.length <= 5);
2259             range = 6;
2260             winChance = 1667;
2261             winChance = winChance.mul(values.length);
2262         } else if (game == GAME_TWO_DICE) {
2263             require(values.length <= 10);
2264             range = 11;
2265             for (uint i = 0; i < values.length; i++) {
2266                 if (values[i] == 0 || values[i] == 10) winChance = winChance.add(278);
2267                 else if (values[i] == 1 || values[i] == 9) winChance = winChance.add(556);
2268                 else if (values[i] == 2 || values[i] == 8) winChance = winChance.add(833);
2269                 else if (values[i] == 3 || values[i] == 7) winChance = winChance.add(1111);
2270                 else if (values[i] == 4 || values[i] == 6) winChance = winChance.add(1389);
2271                 else if (values[i] == 5) winChance = winChance.add(1667);
2272             }
2273         } else if (game == GAME_ETHEROLL) {
2274             require(values.length <= 1);
2275             range = 100;
2276             winChance = uint(100).mul(values[0] + 1);
2277         }
2278         address sender = msg.sender;
2279         if (!isBet[sender]) {
2280             players.push(sender);
2281             isBet[sender] = true;
2282         }
2283         bytes32 queryId = random();
2284         uint prize = payAmount.mul(10000).div(winChance);
2285         if (tokensAmount == 0) {
2286             betsBalances[sender] = betsBalances[sender].add(payAmount);
2287             newQuery(queryId, msg.value, sender, values, prize, range);
2288             queries[queryId].tokens = false;
2289         } else {
2290             newQuery(queryId, tokensAmount, sender, values, prize, range);
2291             queries[queryId].tokens = true;
2292         }
2293         queries[queryId].game = game; // stack
2294         emit PlaceBet(sender, queryId, queries[queryId].tokens);
2295     }
2296 
2297     function ethLottery() external onlyOwner {
2298         require(now - lastEthLotteryTime >= 1 weeks);
2299         require(bonusToken.ethLotteryBank() > 0);
2300         require(ethLotterySize > 0);
2301         if (!bonusToken.isEthLottery()) {
2302             address[] memory lotteryParticipants = bonusToken.ethLotteryParticipants();
2303             for (uint i = 0; i < lotteryParticipants.length; i++) {
2304                 address participant = lotteryParticipants[i];
2305                 uint participantBalance = bonusToken.ethLotteryBalances(participant);
2306                 if (participantBalance > 0) {
2307                     holdersInEthLottery.push(participant);
2308                 }
2309             }
2310             updateEthLotteryRanges();
2311             ethLotteryRound++;
2312         }
2313         bonusToken.startEthLottery();
2314         ethLotteryQueryId = random();
2315     }
2316 
2317     function tokensLottery() external onlyOwner {
2318         require(now - lastTokensLotteryTime >= 1 weeks);
2319         require(bonusToken.tokensLotteryBank() > 0);
2320         require(tokensLotterySize > 0);
2321         if (!bonusToken.isEthLottery()) {
2322             address[] memory lotteryParticipants = bonusToken.tokensLotteryParticipants();
2323             for (uint i = 0; i < lotteryParticipants.length; i++) {
2324                 address participant = lotteryParticipants[i];
2325                 uint participantBalance = bonusToken.tokensLotteryBalances(participant);
2326                 if (participantBalance > 0) {
2327                     holdersInTokensLottery.push(participant);
2328                 }
2329             }
2330             updateTokensLotteryRanges();
2331             tokensLotteryRound++;
2332         }
2333         bonusToken.startTokensLottery();
2334         tokensLotteryQueryId = random();
2335     }
2336 
2337     function sendBonusTokens(uint playersIterations) external onlyOwner {
2338         require(now - lastSendBonusTokensTime >= 24 hours);
2339         uint playersIterationsNumber;
2340         if (players.length.sub(playersIndex) < playersIterations) {
2341             playersIterationsNumber = players.length.sub(playersIndex);
2342         } else {
2343             playersIterationsNumber = playersIterations;
2344         }
2345         uint tokensAmount;
2346         uint betsBalance;
2347         for (uint i; i < playersIterationsNumber; i++) {
2348             address player = players[playersIndex];
2349             tokensAmount = 0;
2350             betsBalance = betsBalances[player];
2351             if (betsBalance >= 1 ether) {
2352                 tokensAmount = betsBalance.div(1 ether).mul(100);
2353                 betsBalance = betsBalance.sub(betsBalance.div(1 ether).mul(1 ether));
2354                 if (tokensAmount > 0) {
2355                     betsBalances[player] = betsBalance;
2356                     bonusToken.buyTokens(player, tokensAmount);
2357                 }
2358             }
2359             playersIndex++;
2360         }
2361         if (playersIndex == players.length) {
2362             playersIndex = 0;
2363             lastSendBonusTokensTime = now;
2364         }
2365     }
2366 
2367     function refundEthPrize() external {
2368         require(waitingEthPrizes[msg.sender] > 0);
2369         require(address(this).balance >= waitingEthPrizes[msg.sender]);
2370         uint weiAmountToSend = waitingEthPrizes[msg.sender];
2371         waitingEthPrizes[msg.sender] = 0;
2372         msg.sender.transfer(weiAmountToSend);
2373     }
2374 
2375     function refundTokensPrize() external {
2376         require(waitingTokensPrizes[msg.sender] > 0);
2377         require(investToken.balanceOf(address(this)) >= waitingTokensPrizes[msg.sender]);
2378         uint tokensAmountToSend = waitingTokensPrizes[msg.sender];
2379         waitingTokensPrizes[msg.sender] = 0;
2380         investToken.transfer(msg.sender, tokensAmountToSend);
2381     }
2382 
2383     function setOraclizeGasPrice(uint gasPrice) external onlyOwner {
2384         oraclize_setCustomGasPrice(gasPrice);
2385     }
2386 
2387     function setOraclizeGasLimit(uint gasLimit) external onlyOwner {
2388         callbackGas = gasLimit;
2389     }
2390 
2391     function setBeneficiar(address newBeneficiar) external onlyOwner valideAddress(newBeneficiar) {
2392         beneficiar = newBeneficiar;
2393     }
2394 
2395     function setInvestToken(address investTokenAddress) external onlyOwner valideAddress(investTokenAddress) {
2396         investToken = InvestToken(investTokenAddress);
2397     }
2398 
2399     function setBonusToken(address bonusTokenAddress) external onlyOwner valideAddress(bonusTokenAddress) {
2400         bonusToken = BonusToken(bonusTokenAddress);
2401     }
2402 
2403     function getFund(uint weiAmount) external onlyOwner {
2404         msg.sender.transfer(weiAmount);
2405     }
2406 
2407     function getBeneficiarFund() external {
2408         require(msg.sender == beneficiar);
2409         uint weiAmountToSend = beneficiarFund;
2410         beneficiarFund = 0;
2411         msg.sender.transfer(weiAmountToSend);
2412     }
2413 
2414     function __callback(bytes32 myId, string result, bytes proof) public {
2415         require((msg.sender == oraclize_cbAddress()));
2416         Query storage query = queries[myId];
2417         require(!query.ended);
2418         uint randomNumber;
2419         uint i;
2420         uint prize;
2421         address tokensHolder;
2422         if (query.gamer != address(0)) {
2423             if (oraclize_randomDS_proofVerify__returnCode(myId, result, proof) != 0) {
2424                 if (!query.tokens) {
2425                     sendEthWin(query.gamer, query.amount);
2426                 } else {
2427                     sendTokensWin(query.gamer, query.amount);
2428                 }
2429             } else {
2430                 randomNumber = uint(keccak256(result)) % query.range;
2431                 bool isWin;
2432                 if (query.game == GAME_ETHEROLL) {
2433                     if (randomNumber <= query.values[0]) {
2434                         if (query.tokens) {
2435                             sendTokensWin(query.gamer, query.prize);
2436                         } else {
2437                             sendEthWin(query.gamer, query.prize);
2438                         }
2439                         isWin = true;
2440                     }
2441                 } else {
2442                     for (i = 0; i < query.values.length; i++) {
2443                         if (randomNumber == query.values[i]) {
2444                             if (query.tokens) {
2445                                 sendTokensWin(query.gamer, query.prize);
2446                             } else {
2447                                 sendEthWin(query.gamer, query.prize);
2448                             }
2449                             isWin = true;
2450                             break;
2451                         }
2452                     }
2453                 }
2454                 uint prizeAmount = 0;
2455                 if (isWin) {
2456                     prizeAmount = query.prize;
2457                 }
2458                 emit Bet(query.gamer, query.game, query.tokens, query.amount, randomNumber, query.values, prizeAmount, now);
2459             }
2460             query.ended = true;
2461         } else if (myId == ethLotteryQueryId) {
2462             require(oraclize_randomDS_proofVerify__returnCode(myId, result, proof) == 0);
2463             randomNumber = uint(keccak256(result)) % bonusToken.ethLotteryBank();
2464             if (ethLotteryStage == 0) {
2465                 prize = ethLotterySize.div(2);
2466             } else if (ethLotteryStage == 1) {
2467                 prize = ethLotterySize.div(4);
2468             } else if (ethLotteryStage == 2) {
2469                 prize = ethLotterySize.mul(12).div(100);
2470             } else if (ethLotteryStage == 3) {
2471                 prize = ethLotterySize.mul(8).div(100);
2472             } else {
2473                 prize = ethLotterySize.div(20);
2474             }
2475             for (i = 0; i < holdersInEthLottery.length; i++) {
2476                 tokensHolder = holdersInEthLottery[i];
2477                 if (randomNumber >= minEthRanges[tokensHolder] && randomNumber < maxEthRanges[tokensHolder]) {
2478                     deleteEthLotteryParticipant(i);
2479                     sendEthWin(tokensHolder, prize);
2480                     emit WinLottery(tokensHolder, prize, bonusToken.ethLotteryBalances(tokensHolder), ethLotteryRound, false);
2481                     ethLotteryStage++;
2482                     updateEthLotteryRanges();
2483                     bonusToken.updateEthLotteryBank(bonusToken.ethLotteryBalances(tokensHolder));
2484                     break;
2485                 }
2486             }
2487             if (ethLotteryStage == 5 || holdersInEthLottery.length == 0) {
2488                 holdersInEthLottery = new address[](0);
2489                 ethLotterySize = 0;
2490                 ethLotteryStage = 0;
2491                 lastEthLotteryTime = now;
2492                 bonusToken.restartEthLottery();
2493             } else {
2494                 ethLotteryQueryId = random();
2495             }
2496         } else if (myId == tokensLotteryQueryId) {
2497             require(oraclize_randomDS_proofVerify__returnCode(myId, result, proof) == 0);
2498             randomNumber = uint(keccak256(result)) % bonusToken.tokensLotteryBank();
2499             if (tokensLotteryStage == 0) {
2500                 prize = tokensLotterySize.div(2);
2501             } else if (tokensLotteryStage == 1) {
2502                 prize = tokensLotterySize.div(4);
2503             } else if (tokensLotteryStage == 2) {
2504                 prize = tokensLotterySize.mul(12).div(100);
2505             } else if (tokensLotteryStage == 3) {
2506                 prize = tokensLotterySize.mul(8).div(100);
2507             } else {
2508                 prize = tokensLotterySize.div(20);
2509             }
2510             for (i = 0; i < holdersInTokensLottery.length; i++) {
2511                 tokensHolder = holdersInTokensLottery[i];
2512                 if (randomNumber >= minTokensRanges[tokensHolder] && randomNumber < maxTokensRanges[tokensHolder]) {
2513                     deleteTokensLotteryParticipant(i);
2514                     sendTokensWin(tokensHolder, prize);
2515                     emit WinLottery(tokensHolder, prize, bonusToken.tokensLotteryBalances(tokensHolder), tokensLotteryRound, true);
2516                     tokensLotteryStage++;
2517                     updateTokensLotteryRanges();
2518                     bonusToken.updateTokensLotteryBank(bonusToken.tokensLotteryBalances(tokensHolder));
2519                     break;
2520                 }
2521             }
2522             if (tokensLotteryStage == 5 || holdersInTokensLottery.length == 0) {
2523                 holdersInTokensLottery = new address[](0);
2524                 tokensLotterySize = 0;
2525                 tokensLotteryStage = 0;
2526                 lastTokensLotteryTime = now;
2527                 bonusToken.restartTokensLottery();
2528             } else {
2529                 tokensLotteryQueryId = random();
2530             }
2531         }
2532     }
2533 
2534     function updateEthLotteryRanges() private {
2535         uint range = 0;
2536         for (uint i = 0; i < holdersInEthLottery.length; i++) {
2537             address participant = holdersInEthLottery[i];
2538             uint participantBalance = bonusToken.ethLotteryBalances(participant);
2539             minEthRanges[participant] = range;
2540             range = range.add(participantBalance);
2541             maxEthRanges[participant] = range;
2542         }
2543     }
2544 
2545     function updateTokensLotteryRanges() private {
2546         uint range = 0;
2547         for (uint i = 0; i < holdersInTokensLottery.length; i++) {
2548             address participant = holdersInTokensLottery[i];
2549             uint participantBalance = bonusToken.tokensLotteryBalances(participant);
2550             minTokensRanges[participant] = range;
2551             range = range.add(participantBalance);
2552             maxTokensRanges[participant] = range;
2553         }
2554     }
2555 
2556     function valideBet(uint game, uint[] values) private pure returns(bool) {
2557         require(values.length > 0);
2558         for (uint i = 0; i < values.length; i++) {
2559             if (i == 0) {
2560                 if (game == GAME_ETHEROLL && values[i] > 96) {
2561                     return false;
2562                 }
2563             }
2564             if (i != values.length - 1) {
2565                 if (values[i + 1] <= values[i]) {
2566                     return false;
2567                 }
2568             }
2569         }
2570         return true;
2571     }
2572 
2573     function fee(uint amount, bool tokens) private returns(uint) {
2574         uint beneficiarFee = amount.mul(BENEFICIAR_FEE_PERCENT).div(1000);
2575         uint tokenHoldersFee = amount.mul(TOKEN_HOLDERS_FEE_PERCENT).div(1000);
2576         if (tokens) {
2577             tokensLotterySize = tokensLotterySize.add(LOTTERY_FEE);
2578             investToken.transfer(beneficiar, beneficiarFee);
2579         } else {
2580             ethLotterySize = ethLotterySize.add(LOTTERY_FEE);
2581             beneficiarFund = beneficiarFund.add(beneficiarFee);
2582             amount = amount.sub(tokenHoldersFee);
2583         }
2584         amount = amount.sub(beneficiarFee).sub(LOTTERY_FEE);
2585         return amount;
2586     }
2587 
2588     function newQuery(bytes32 queryId, uint amount, address gamer, uint[] values, uint prize, uint range) private {
2589         queries[queryId].gamer = gamer;
2590         queries[queryId].amount = amount;
2591         queries[queryId].values = values;
2592         queries[queryId].prize = prize;
2593         queries[queryId].range = range;
2594         queries[queryId].time = now;
2595     }
2596 
2597     function random() private returns(bytes32 queryId) {
2598         require(address(this).balance >= oraclize_getPrice('random', callbackGas));
2599         queryId = oraclize_newRandomDSQuery(0, 4, callbackGas);
2600         require(queryId != 0, 'Oraclize error');
2601     }
2602 
2603     function sendEthWin(address winner, uint weiAmount) private {
2604         if (address(this).balance >= weiAmount) {
2605             winner.transfer(weiAmount);
2606         } else {
2607             waitingEthPrizes[winner] = waitingEthPrizes[winner].add(weiAmount);
2608         }
2609     }
2610 
2611     function sendTokensWin(address winner, uint tokensAmount) private {
2612         if (investToken.balanceOf(address(this)) >= tokensAmount) {
2613             investToken.transfer(winner, tokensAmount);
2614         } else {
2615             waitingTokensPrizes[winner] = waitingTokensPrizes[winner].add(tokensAmount);
2616         }
2617     }
2618 
2619     function deleteEthLotteryParticipant(uint index) private {
2620         holdersInEthLottery[index] = holdersInEthLottery[holdersInEthLottery.length - 1];
2621         delete holdersInEthLottery[holdersInEthLottery.length - 1];
2622         holdersInEthLottery.length--;
2623     }
2624 
2625     function deleteTokensLotteryParticipant(uint index) private {
2626         holdersInTokensLottery[index] = holdersInTokensLottery[holdersInTokensLottery.length - 1];
2627         delete holdersInTokensLottery[holdersInTokensLottery.length - 1];
2628         holdersInTokensLottery.length--;
2629     }
2630 }