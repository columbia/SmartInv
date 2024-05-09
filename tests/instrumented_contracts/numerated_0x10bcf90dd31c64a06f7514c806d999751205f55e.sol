1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * Interface for defining crowdsale pricing.
6  */
7 contract PricingStrategy {
8 
9     address public tier;
10 
11     /** Interface declaration. */
12     function isPricingStrategy() public pure returns (bool) {
13         return true;
14     }
15 
16     /** Self check if all references are correctly set.
17     *
18     * Checks that pricing strategy matches crowdsale parameters.
19     */
20     function isSane() public pure returns (bool) {
21         return true;
22     }
23 
24     /**
25     * @dev Pricing tells if this is a presale purchase or not.  
26       @return False by default, true if a presale purchaser
27     */
28     function isPresalePurchase() public pure returns (bool) {
29         return false;
30     }
31 
32     /* How many weis one token costs */
33     function updateRate(uint oneTokenInCents) public;
34 
35     /**
36     * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
37     *
38     *
39     * @param value - What is the value of the transaction send in as wei
40     * @param tokensSold - how much tokens have been sold this far
41     * @param decimals - how many decimal units the token has
42     * @return Amount of tokens the investor receives
43     */
44     function calculatePrice(uint value, uint tokensSold, uint decimals) public view returns (uint tokenAmount);
45 
46     function oneTokenInWei(uint tokensSold, uint decimals) public view returns (uint);
47 }
48 
49 /**
50  * Safe unsigned safe math.
51  *
52  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
53  *
54  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
55  *
56  * Maintained here until merged to mainline zeppelin-solidity.
57  *
58  */
59 library SafeMathLibExt {
60 
61     function times(uint a, uint b) public pure returns (uint) {
62         uint c = a * b;
63         assert(a == 0 || c / a == b);
64         return c;
65     }
66 
67     function divides(uint a, uint b) public pure returns (uint) {
68         assert(b > 0);
69         uint c = a / b;
70         assert(a == b * c + a % b);
71         return c;
72     }
73 
74     function minus(uint a, uint b) public pure returns (uint) {
75         assert(b <= a);
76         return a - b;
77     }
78 
79     function plus(uint a, uint b) public pure returns (uint) {
80         uint c = a + b;
81         assert(c >= a);
82         return c;
83     }
84 
85 }
86 
87 contract OraclizeI {
88     address public cbAddress;
89     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
90 
91     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) 
92         external payable returns (bytes32 _id);
93 
94     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) 
95         public payable returns (bytes32 _id);
96 
97     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) 
98         external payable returns (bytes32 _id);
99 
100     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
101 
102     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) 
103         external payable returns (bytes32 _id);
104 
105     function getPrice(string _datasource) public returns (uint _dsprice);
106 
107     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
108 
109     function setProofType(byte _proofType) external;
110 
111     function setCustomGasPrice(uint _gasPrice) external;
112 
113     function randomDS_getSessionPubKeyHash() external view returns(bytes32);
114 }
115 
116 
117 contract OraclizeAddrResolverI {
118     function getAddress() public returns (address _addr);
119 }
120 
121 /*
122 Begin solidity-cborutils
123 
124 https://github.com/smartcontractkit/solidity-cborutils
125 
126 MIT License
127 
128 Copyright (c) 2018 SmartContract ChainLink, Ltd.
129 
130 Permission is hereby granted, free of charge, to any person obtaining a copy
131 of this software and associated documentation files (the "Software"), to deal
132 in the Software without restriction, including without limitation the rights
133 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
134 copies of the Software, and to permit persons to whom the Software is
135 furnished to do so, subject to the following conditions:
136 
137 The above copyright notice and this permission notice shall be included in all
138 copies or substantial portions of the Software.
139 
140 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
141 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
142 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
143 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
144 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
145 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
146 SOFTWARE.
147  */
148 
149 library Buffer {
150     struct buffer {
151         bytes buf;
152         uint capacity;
153     }
154 
155     function init(buffer memory buf, uint _capacity) internal pure {
156         uint capacity = _capacity;
157         if (capacity % 32 != 0) capacity += 32 - (capacity % 32);
158         // Allocate space for the buffer data
159         buf.capacity = capacity;
160         assembly {
161             let ptr := mload(0x40)
162             mstore(buf, ptr)
163             mstore(ptr, 0)
164             mstore(0x40, add(ptr, capacity))
165         }
166     }
167 
168     function resize(buffer memory buf, uint capacity) private pure {
169         bytes memory oldbuf = buf.buf;
170         init(buf, capacity);
171         append(buf, oldbuf);
172     }
173 
174     function max(uint a, uint b) private pure returns(uint) {
175         if (a > b) {
176             return a;
177         }
178         return b;
179     }
180 
181     /**
182      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
183      *      would exceed the capacity of the buffer.
184      * @param buf The buffer to append to.
185      * @param data The data to append.
186      * @return The original buffer.
187      */
188     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
189         if (data.length + buf.buf.length > buf.capacity) {
190             resize(buf, max(buf.capacity, data.length) * 2);
191         }
192 
193         uint dest;
194         uint src;
195         uint len = data.length;
196         assembly {
197             // Memory address of the buffer data
198             let bufptr := mload(buf)
199             // Length of existing buffer data
200             let buflen := mload(bufptr)
201             // Start address = buffer address + buffer length + sizeof(buffer length)
202             dest := add(add(bufptr, buflen), 32)
203             // Update buffer length
204             mstore(bufptr, add(buflen, mload(data)))
205             src := add(data, 32)
206         }
207 
208         // Copy word-length chunks while possible
209         for(; len >= 32; len -= 32) {
210             assembly {
211                 mstore(dest, mload(src))
212             }
213             dest += 32;
214             src += 32;
215         }
216 
217         // Copy remaining bytes
218         uint mask = 256 ** (32 - len) - 1;
219         assembly {
220             let srcpart := and(mload(src), not(mask))
221             let destpart := and(mload(dest), mask)
222             mstore(dest, or(destpart, srcpart))
223         }
224 
225         return buf;
226     }
227 
228     /**
229      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
230      * exceed the capacity of the buffer.
231      * @param buf The buffer to append to.
232      * @param data The data to append.
233      * @return The original buffer.
234      */
235     function append(buffer memory buf, uint8 data) internal pure {
236         if (buf.buf.length + 1 > buf.capacity) {
237             resize(buf, buf.capacity * 2);
238         }
239 
240         assembly {
241             // Memory address of the buffer data
242             let bufptr := mload(buf)
243             // Length of existing buffer data
244             let buflen := mload(bufptr)
245             // Address = buffer address + buffer length + sizeof(buffer length)
246             let dest := add(add(bufptr, buflen), 32)
247             mstore8(dest, data)
248             // Update buffer length
249             mstore(bufptr, add(buflen, 1))
250         }
251     }
252 
253     /**
254      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
255      * exceed the capacity of the buffer.
256      * @param buf The buffer to append to.
257      * @param data The data to append.
258      * @return The original buffer.
259      */
260     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
261         if (len + buf.buf.length > buf.capacity) {
262             resize(buf, max(buf.capacity, len) * 2);
263         }
264 
265         uint mask = 256 ** len - 1;
266         assembly {
267             // Memory address of the buffer data
268             let bufptr := mload(buf)
269             // Length of existing buffer data
270             let buflen := mload(bufptr)
271             // Address = buffer address + buffer length + sizeof(buffer length) + len
272             let dest := add(add(bufptr, buflen), len)
273             mstore(dest, or(and(mload(dest), not(mask)), data))
274             // Update buffer length
275             mstore(bufptr, add(buflen, len))
276         }
277         return buf;
278     }
279 }
280 
281 library CBOR {
282     using Buffer for Buffer.buffer;
283 
284     uint8 private constant MAJOR_TYPE_INT = 0;
285     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
286     uint8 private constant MAJOR_TYPE_BYTES = 2;
287     uint8 private constant MAJOR_TYPE_STRING = 3;
288     uint8 private constant MAJOR_TYPE_ARRAY = 4;
289     uint8 private constant MAJOR_TYPE_MAP = 5;
290     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
291 
292     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
293         if (value <= 23) {
294             buf.append(uint8((major << 5) | value));
295         } else if (value <= 0xFF) {
296             buf.append(uint8((major << 5) | 24));
297             buf.appendInt(value, 1);
298         } else if (value <= 0xFFFF) {
299             buf.append(uint8((major << 5) | 25));
300             buf.appendInt(value, 2);
301         } else if (value <= 0xFFFFFFFF) {
302             buf.append(uint8((major << 5) | 26));
303             buf.appendInt(value, 4);
304         } else if (value <= 0xFFFFFFFFFFFFFFFF) {
305             buf.append(uint8((major << 5) | 27));
306             buf.appendInt(value, 8);
307         }
308     }
309 
310     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
311         buf.append(uint8((major << 5) | 31));
312     }
313 
314     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
315         encodeType(buf, MAJOR_TYPE_INT, value);
316     }
317 
318     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
319         if (value >= 0) {
320             encodeType(buf, MAJOR_TYPE_INT, uint(value));
321         } else {
322             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
323         }
324     }
325 
326     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
327         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
328         buf.append(value);
329     }
330 
331     function encodeString(Buffer.buffer memory buf, string value) internal pure {
332         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
333         buf.append(bytes(value));
334     }
335 
336     function startArray(Buffer.buffer memory buf) internal pure {
337         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
338     }
339 
340     function startMap(Buffer.buffer memory buf) internal pure {
341         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
342     }
343 
344     function endSequence(Buffer.buffer memory buf) internal pure {
345         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
346     }
347 }
348 
349 /*
350 End solidity-cborutils
351  */
352 
353 contract usingOraclize {
354     uint constant day = 60*60*24;
355     uint constant week = 60*60*24*7;
356     uint constant month = 60*60*24*30;
357     byte constant proofType_NONE = 0x00;
358     byte constant proofType_TLSNotary = 0x10;
359     byte constant proofType_Ledger = 0x30;
360     byte constant proofType_Android = 0x40;
361     byte constant proofType_Native = 0xF0;
362     byte constant proofStorage_IPFS = 0x01;
363     uint8 constant networkID_auto = 0;
364     uint8 constant networkID_mainnet = 1;
365     uint8 constant networkID_testnet = 2;
366     uint8 constant networkID_morden = 2;
367     uint8 constant networkID_consensys = 161;
368 
369     OraclizeAddrResolverI OAR;
370 
371     OraclizeI oraclize;
372     modifier oraclizeAPI {
373         if ((address(OAR) == 0)||(getCodeSize(address(OAR)) == 0))
374             oraclize_setNetwork(networkID_auto);
375 
376         if (address(oraclize) != OAR.getAddress())
377             oraclize = OraclizeI(OAR.getAddress());
378 
379         _;
380     }
381     modifier coupon(string code){
382         oraclize = OraclizeI(OAR.getAddress());
383         _;
384     }
385 
386     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
387         return oraclize_setNetwork();
388         networkID; // silence the warning and remain backwards compatible
389     }
390     function oraclize_setNetwork() internal returns(bool){
391         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
392             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
393             oraclize_setNetworkName("eth_mainnet");
394             return true;
395         }
396         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
397             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
398             oraclize_setNetworkName("eth_ropsten3");
399             return true;
400         }
401         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
402             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
403             oraclize_setNetworkName("eth_kovan");
404             return true;
405         }
406         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
407             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
408             oraclize_setNetworkName("eth_rinkeby");
409             return true;
410         }
411         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
412             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
413             return true;
414         }
415         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
416             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
417             return true;
418         }
419         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
420             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
421             return true;
422         }
423         return false;
424     }
425 
426     function __callback(bytes32 myid, string result) public {
427         __callback(myid, result, new bytes(0));
428     }
429     function __callback(bytes32 myid, string result, bytes proof) public {
430         return;
431         myid; result; proof; // Silence compiler warnings
432     }
433 
434     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
435         return oraclize.getPrice(datasource);
436     }
437 
438     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
439         return oraclize.getPrice(datasource, gaslimit);
440     }
441 
442     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
443         uint price = oraclize.getPrice(datasource);
444         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
445         return oraclize.query.value(price)(0, datasource, arg);
446     }
447     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
448         uint price = oraclize.getPrice(datasource);
449         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
450         return oraclize.query.value(price)(timestamp, datasource, arg);
451     }
452     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
453         uint price = oraclize.getPrice(datasource, gaslimit);
454         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
455         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
456     }
457     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
458         uint price = oraclize.getPrice(datasource, gaslimit);
459         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
460         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
461     }
462     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
463         uint price = oraclize.getPrice(datasource);
464         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
465         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
466     }
467     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
468         uint price = oraclize.getPrice(datasource);
469         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
470         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
471     }
472     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
473         uint price = oraclize.getPrice(datasource, gaslimit);
474         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
475         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
476     }
477     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
478         uint price = oraclize.getPrice(datasource, gaslimit);
479         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
480         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
481     }
482     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
483         uint price = oraclize.getPrice(datasource);
484         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
485         bytes memory args = stra2cbor(argN);
486         return oraclize.queryN.value(price)(0, datasource, args);
487     }
488     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
489         uint price = oraclize.getPrice(datasource);
490         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
491         bytes memory args = stra2cbor(argN);
492         return oraclize.queryN.value(price)(timestamp, datasource, args);
493     }
494     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
495         uint price = oraclize.getPrice(datasource, gaslimit);
496         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
497         bytes memory args = stra2cbor(argN);
498         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
499     }
500     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
501         uint price = oraclize.getPrice(datasource, gaslimit);
502         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
503         bytes memory args = stra2cbor(argN);
504         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
505     }
506     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
507         string[] memory dynargs = new string[](1);
508         dynargs[0] = args[0];
509         return oraclize_query(datasource, dynargs);
510     }
511     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
512         string[] memory dynargs = new string[](1);
513         dynargs[0] = args[0];
514         return oraclize_query(timestamp, datasource, dynargs);
515     }
516     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
517         string[] memory dynargs = new string[](1);
518         dynargs[0] = args[0];
519         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
520     }
521     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
522         string[] memory dynargs = new string[](1);
523         dynargs[0] = args[0];
524         return oraclize_query(datasource, dynargs, gaslimit);
525     }
526 
527     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
528         string[] memory dynargs = new string[](2);
529         dynargs[0] = args[0];
530         dynargs[1] = args[1];
531         return oraclize_query(datasource, dynargs);
532     }
533     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
534         string[] memory dynargs = new string[](2);
535         dynargs[0] = args[0];
536         dynargs[1] = args[1];
537         return oraclize_query(timestamp, datasource, dynargs);
538     }
539     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
540         string[] memory dynargs = new string[](2);
541         dynargs[0] = args[0];
542         dynargs[1] = args[1];
543         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
544     }
545     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
546         string[] memory dynargs = new string[](2);
547         dynargs[0] = args[0];
548         dynargs[1] = args[1];
549         return oraclize_query(datasource, dynargs, gaslimit);
550     }
551     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
552         string[] memory dynargs = new string[](3);
553         dynargs[0] = args[0];
554         dynargs[1] = args[1];
555         dynargs[2] = args[2];
556         return oraclize_query(datasource, dynargs);
557     }
558     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
559         string[] memory dynargs = new string[](3);
560         dynargs[0] = args[0];
561         dynargs[1] = args[1];
562         dynargs[2] = args[2];
563         return oraclize_query(timestamp, datasource, dynargs);
564     }
565     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
566         string[] memory dynargs = new string[](3);
567         dynargs[0] = args[0];
568         dynargs[1] = args[1];
569         dynargs[2] = args[2];
570         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
571     }
572     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
573         string[] memory dynargs = new string[](3);
574         dynargs[0] = args[0];
575         dynargs[1] = args[1];
576         dynargs[2] = args[2];
577         return oraclize_query(datasource, dynargs, gaslimit);
578     }
579 
580     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
581         string[] memory dynargs = new string[](4);
582         dynargs[0] = args[0];
583         dynargs[1] = args[1];
584         dynargs[2] = args[2];
585         dynargs[3] = args[3];
586         return oraclize_query(datasource, dynargs);
587     }
588     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
589         string[] memory dynargs = new string[](4);
590         dynargs[0] = args[0];
591         dynargs[1] = args[1];
592         dynargs[2] = args[2];
593         dynargs[3] = args[3];
594         return oraclize_query(timestamp, datasource, dynargs);
595     }
596     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
597         string[] memory dynargs = new string[](4);
598         dynargs[0] = args[0];
599         dynargs[1] = args[1];
600         dynargs[2] = args[2];
601         dynargs[3] = args[3];
602         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
603     }
604     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
605         string[] memory dynargs = new string[](4);
606         dynargs[0] = args[0];
607         dynargs[1] = args[1];
608         dynargs[2] = args[2];
609         dynargs[3] = args[3];
610         return oraclize_query(datasource, dynargs, gaslimit);
611     }
612     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
613         string[] memory dynargs = new string[](5);
614         dynargs[0] = args[0];
615         dynargs[1] = args[1];
616         dynargs[2] = args[2];
617         dynargs[3] = args[3];
618         dynargs[4] = args[4];
619         return oraclize_query(datasource, dynargs);
620     }
621     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
622         string[] memory dynargs = new string[](5);
623         dynargs[0] = args[0];
624         dynargs[1] = args[1];
625         dynargs[2] = args[2];
626         dynargs[3] = args[3];
627         dynargs[4] = args[4];
628         return oraclize_query(timestamp, datasource, dynargs);
629     }
630     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
631         string[] memory dynargs = new string[](5);
632         dynargs[0] = args[0];
633         dynargs[1] = args[1];
634         dynargs[2] = args[2];
635         dynargs[3] = args[3];
636         dynargs[4] = args[4];
637         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
638     }
639     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
640         string[] memory dynargs = new string[](5);
641         dynargs[0] = args[0];
642         dynargs[1] = args[1];
643         dynargs[2] = args[2];
644         dynargs[3] = args[3];
645         dynargs[4] = args[4];
646         return oraclize_query(datasource, dynargs, gaslimit);
647     }
648     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
649         uint price = oraclize.getPrice(datasource);
650         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
651         bytes memory args = ba2cbor(argN);
652         return oraclize.queryN.value(price)(0, datasource, args);
653     }
654     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
655         uint price = oraclize.getPrice(datasource);
656         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
657         bytes memory args = ba2cbor(argN);
658         return oraclize.queryN.value(price)(timestamp, datasource, args);
659     }
660     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
661         uint price = oraclize.getPrice(datasource, gaslimit);
662         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
663         bytes memory args = ba2cbor(argN);
664         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
665     }
666     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
667         uint price = oraclize.getPrice(datasource, gaslimit);
668         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
669         bytes memory args = ba2cbor(argN);
670         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
671     }
672     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
673         bytes[] memory dynargs = new bytes[](1);
674         dynargs[0] = args[0];
675         return oraclize_query(datasource, dynargs);
676     }
677     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
678         bytes[] memory dynargs = new bytes[](1);
679         dynargs[0] = args[0];
680         return oraclize_query(timestamp, datasource, dynargs);
681     }
682     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
683         bytes[] memory dynargs = new bytes[](1);
684         dynargs[0] = args[0];
685         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
686     }
687     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
688         bytes[] memory dynargs = new bytes[](1);
689         dynargs[0] = args[0];
690         return oraclize_query(datasource, dynargs, gaslimit);
691     }
692 
693     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
694         bytes[] memory dynargs = new bytes[](2);
695         dynargs[0] = args[0];
696         dynargs[1] = args[1];
697         return oraclize_query(datasource, dynargs);
698     }
699     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
700         bytes[] memory dynargs = new bytes[](2);
701         dynargs[0] = args[0];
702         dynargs[1] = args[1];
703         return oraclize_query(timestamp, datasource, dynargs);
704     }
705     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
706         bytes[] memory dynargs = new bytes[](2);
707         dynargs[0] = args[0];
708         dynargs[1] = args[1];
709         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
710     }
711     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
712         bytes[] memory dynargs = new bytes[](2);
713         dynargs[0] = args[0];
714         dynargs[1] = args[1];
715         return oraclize_query(datasource, dynargs, gaslimit);
716     }
717     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
718         bytes[] memory dynargs = new bytes[](3);
719         dynargs[0] = args[0];
720         dynargs[1] = args[1];
721         dynargs[2] = args[2];
722         return oraclize_query(datasource, dynargs);
723     }
724     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
725         bytes[] memory dynargs = new bytes[](3);
726         dynargs[0] = args[0];
727         dynargs[1] = args[1];
728         dynargs[2] = args[2];
729         return oraclize_query(timestamp, datasource, dynargs);
730     }
731     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
732         bytes[] memory dynargs = new bytes[](3);
733         dynargs[0] = args[0];
734         dynargs[1] = args[1];
735         dynargs[2] = args[2];
736         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
737     }
738     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
739         bytes[] memory dynargs = new bytes[](3);
740         dynargs[0] = args[0];
741         dynargs[1] = args[1];
742         dynargs[2] = args[2];
743         return oraclize_query(datasource, dynargs, gaslimit);
744     }
745 
746     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
747         bytes[] memory dynargs = new bytes[](4);
748         dynargs[0] = args[0];
749         dynargs[1] = args[1];
750         dynargs[2] = args[2];
751         dynargs[3] = args[3];
752         return oraclize_query(datasource, dynargs);
753     }
754     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
755         bytes[] memory dynargs = new bytes[](4);
756         dynargs[0] = args[0];
757         dynargs[1] = args[1];
758         dynargs[2] = args[2];
759         dynargs[3] = args[3];
760         return oraclize_query(timestamp, datasource, dynargs);
761     }
762     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
763         bytes[] memory dynargs = new bytes[](4);
764         dynargs[0] = args[0];
765         dynargs[1] = args[1];
766         dynargs[2] = args[2];
767         dynargs[3] = args[3];
768         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
769     }
770     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
771         bytes[] memory dynargs = new bytes[](4);
772         dynargs[0] = args[0];
773         dynargs[1] = args[1];
774         dynargs[2] = args[2];
775         dynargs[3] = args[3];
776         return oraclize_query(datasource, dynargs, gaslimit);
777     }
778     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
779         bytes[] memory dynargs = new bytes[](5);
780         dynargs[0] = args[0];
781         dynargs[1] = args[1];
782         dynargs[2] = args[2];
783         dynargs[3] = args[3];
784         dynargs[4] = args[4];
785         return oraclize_query(datasource, dynargs);
786     }
787     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
788         bytes[] memory dynargs = new bytes[](5);
789         dynargs[0] = args[0];
790         dynargs[1] = args[1];
791         dynargs[2] = args[2];
792         dynargs[3] = args[3];
793         dynargs[4] = args[4];
794         return oraclize_query(timestamp, datasource, dynargs);
795     }
796     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
797         bytes[] memory dynargs = new bytes[](5);
798         dynargs[0] = args[0];
799         dynargs[1] = args[1];
800         dynargs[2] = args[2];
801         dynargs[3] = args[3];
802         dynargs[4] = args[4];
803         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
804     }
805     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
806         bytes[] memory dynargs = new bytes[](5);
807         dynargs[0] = args[0];
808         dynargs[1] = args[1];
809         dynargs[2] = args[2];
810         dynargs[3] = args[3];
811         dynargs[4] = args[4];
812         return oraclize_query(datasource, dynargs, gaslimit);
813     }
814 
815     function oraclize_cbAddress() oraclizeAPI internal returns (address){
816         return oraclize.cbAddress();
817     }
818     function oraclize_setProof(byte proofP) oraclizeAPI internal {
819         return oraclize.setProofType(proofP);
820     }
821     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
822         return oraclize.setCustomGasPrice(gasPrice);
823     }
824 
825     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
826         return oraclize.randomDS_getSessionPubKeyHash();
827     }
828 
829     function getCodeSize(address _addr) constant internal returns(uint _size) {
830         assembly {
831             _size := extcodesize(_addr)
832         }
833     }
834 
835     function parseAddr(string _a) internal pure returns (address){
836         bytes memory tmp = bytes(_a);
837         uint160 iaddr = 0;
838         uint160 b1;
839         uint160 b2;
840         for (uint i = 2; i < 2 + 2 * 20; i += 2){
841             iaddr *= 256;
842             b1 = uint160(tmp[i]);
843             b2 = uint160(tmp[i+1]);
844             if ((b1 >= 97) && (b1 <= 102)) b1 -= 87;
845             else if ((b1 >= 65) && (b1 <= 70)) b1 -= 55;
846             else if ((b1 >= 48) && (b1 <= 57)) b1 -= 48;
847             if ((b2 >= 97) && (b2 <= 102)) b2 -= 87;
848             else if ((b2 >= 65) && (b2 <= 70)) b2 -= 55;
849             else if ((b2 >= 48) && (b2 <= 57)) b2 -= 48;
850             iaddr += (b1 * 16 + b2);
851         }
852         return address(iaddr);
853     }
854 
855     function strCompare(string _a, string _b) internal pure returns (int) {
856         bytes memory a = bytes(_a);
857         bytes memory b = bytes(_b);
858         uint minLength = a.length;
859         if (b.length < minLength) minLength = b.length;
860         for (uint i = 0; i < minLength; i ++)
861             if (a[i] < b[i])
862                 return -1;
863             else if (a[i] > b[i])
864                 return 1;
865         if (a.length < b.length)
866             return -1;
867         else if (a.length > b.length)
868             return 1;
869         else
870             return 0;
871     }
872 
873     function indexOf(string _haystack, string _needle) internal pure returns (int) {
874         bytes memory h = bytes(_haystack);
875         bytes memory n = bytes(_needle);
876         if (h.length < 1 || n.length < 1 || (n.length > h.length))
877             return -1;
878         else if (h.length > (2**128 -1))
879             return -1;
880         else
881         {
882             uint subindex = 0;
883             for (uint i = 0; i < h.length; i ++)
884             {
885                 if (h[i] == n[0])
886                 {
887                     subindex = 1;
888                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
889                     {
890                         subindex++;
891                     }
892                     if (subindex == n.length)
893                         return int(i);
894                 }
895             }
896             return -1;
897         }
898     }
899 
900     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
901         bytes memory _ba = bytes(_a);
902         bytes memory _bb = bytes(_b);
903         bytes memory _bc = bytes(_c);
904         bytes memory _bd = bytes(_d);
905         bytes memory _be = bytes(_e);
906         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
907         bytes memory babcde = bytes(abcde);
908         uint k = 0;
909         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
910         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
911         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
912         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
913         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
914         return string(babcde);
915     }
916 
917     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
918         return strConcat(_a, _b, _c, _d, "");
919     }
920 
921     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
922         return strConcat(_a, _b, _c, "", "");
923     }
924 
925     function strConcat(string _a, string _b) internal pure returns (string) {
926         return strConcat(_a, _b, "", "", "");
927     }
928 
929     // parseInt
930     function parseInt(string _a) internal pure returns (uint) {
931         return parseInt(_a, 0);
932     }
933 
934     // parseInt(parseFloat*10^_b)
935     function parseInt(string _a, uint _b) internal pure returns (uint) {
936         bytes memory bresult = bytes(_a);
937         uint mint = 0;
938         bool decimals = false;
939         for (uint i=0; i<bresult.length; i++){
940             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
941                 if (decimals){
942                     if (_b == 0) break;
943                     else _b--;
944                 }
945                 mint *= 10;
946                 mint += uint(bresult[i]) - 48;
947             } else if (bresult[i] == 46) decimals = true;
948         }
949         if (_b > 0) mint *= 10**_b;
950         return mint;
951     }
952 
953     function uint2str(uint i) internal pure returns (string){
954         if (i == 0) return "0";
955         uint j = i;
956         uint len;
957         while (j != 0){
958             len++;
959             j /= 10;
960         }
961         bytes memory bstr = new bytes(len);
962         uint k = len - 1;
963         while (i != 0){
964             bstr[k--] = byte(48 + i % 10);
965             i /= 10;
966         }
967         return string(bstr);
968     }
969 
970     using CBOR for Buffer.buffer;
971     function stra2cbor(string[] arr) internal pure returns (bytes) {
972         safeMemoryCleaner();
973         Buffer.buffer memory buf;
974         Buffer.init(buf, 1024);
975         buf.startArray();
976         for (uint i = 0; i < arr.length; i++) {
977             buf.encodeString(arr[i]);
978         }
979         buf.endSequence();
980         return buf.buf;
981     }
982 
983     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
984         safeMemoryCleaner();
985         Buffer.buffer memory buf;
986         Buffer.init(buf, 1024);
987         buf.startArray();
988         for (uint i = 0; i < arr.length; i++) {
989             buf.encodeBytes(arr[i]);
990         }
991         buf.endSequence();
992         return buf.buf;
993     }
994 
995     string oraclize_network_name;
996     function oraclize_setNetworkName(string _network_name) internal {
997         oraclize_network_name = _network_name;
998     }
999 
1000     function oraclize_getNetworkName() internal view returns (string) {
1001         return oraclize_network_name;
1002     }
1003 
1004     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1005         require((_nbytes > 0) && (_nbytes <= 32));
1006         // Convert from seconds to ledger timer ticks
1007         _delay *= 10;
1008         bytes memory nbytes = new bytes(1);
1009         nbytes[0] = byte(_nbytes);
1010         bytes memory unonce = new bytes(32);
1011         bytes memory sessionKeyHash = new bytes(32);
1012         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1013         assembly {
1014             mstore(unonce, 0x20)
1015             // the following variables can be relaxed
1016             // check relaxed random contract under ethereum-examples repo
1017             // for an idea on how to override and replace comit hash vars
1018             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1019             mstore(sessionKeyHash, 0x20)
1020             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1021         }
1022         bytes memory delay = new bytes(32);
1023         assembly {
1024             mstore(add(delay, 0x20), _delay)
1025         }
1026 
1027         bytes memory delay_bytes8 = new bytes(8);
1028         copyBytes(delay, 24, 8, delay_bytes8, 0);
1029 
1030         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1031         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1032 
1033         bytes memory delay_bytes8_left = new bytes(8);
1034 
1035         assembly {
1036             let x := mload(add(delay_bytes8, 0x20))
1037             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1038             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1039             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1040             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1041             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1042             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1043             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1044             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1045 
1046         }
1047 
1048         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1049         return queryId;
1050     }
1051 
1052     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1053         oraclize_randomDS_args[queryId] = commitment;
1054     }
1055 
1056     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1057     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1058 
1059     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1060         bool sigok;
1061         address signer;
1062 
1063         bytes32 sigr;
1064         bytes32 sigs;
1065 
1066         bytes memory sigr_ = new bytes(32);
1067         uint offset = 4+(uint(dersig[3]) - 0x20);
1068         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1069         bytes memory sigs_ = new bytes(32);
1070         offset += 32 + 2;
1071         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1072 
1073         assembly {
1074             sigr := mload(add(sigr_, 32))
1075             sigs := mload(add(sigs_, 32))
1076         }
1077 
1078 
1079         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1080         if (address(keccak256(pubkey)) == signer) return true;
1081         else {
1082             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1083             return (address(keccak256(pubkey)) == signer);
1084         }
1085     }
1086 
1087     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1088         bool sigok;
1089 
1090         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1091         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1092         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1093 
1094         bytes memory appkey1_pubkey = new bytes(64);
1095         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1096 
1097         bytes memory tosign2 = new bytes(1+65+32);
1098         tosign2[0] = byte(1); //role
1099         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1100         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1101         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1102         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1103 
1104         if (sigok == false) return false;
1105 
1106 
1107         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1108         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1109 
1110         bytes memory tosign3 = new bytes(1+65);
1111         tosign3[0] = 0xFE;
1112         copyBytes(proof, 3, 65, tosign3, 1);
1113 
1114         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1115         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1116 
1117         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1118 
1119         return sigok;
1120     }
1121 
1122     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1123         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1124         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1125 
1126         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1127         require(proofVerified);
1128 
1129         _;
1130     }
1131 
1132     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1133         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1134         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1135 
1136         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1137         if (proofVerified == false) return 2;
1138 
1139         return 0;
1140     }
1141 
1142     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1143         bool match_ = true;
1144 
1145         require(prefix.length == n_random_bytes);
1146 
1147         for (uint256 i = 0; i < n_random_bytes; i++) {
1148             if (content[i] != prefix[i]) match_ = false;
1149         }
1150 
1151         return match_;
1152     }
1153 
1154     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1155 
1156         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1157         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1158         bytes memory keyhash = new bytes(32);
1159         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);        
1160         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1161 
1162         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1163         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1164 
1165         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1166         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1167 
1168         // Step 4: commitment match verification, 
1169         // keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1170         // This is to verify that the computed args match with the ones specified in the query.
1171         bytes memory commitmentSlice1 = new bytes(8+1+32);
1172         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1173 
1174         bytes memory sessionPubkey = new bytes(64);
1175         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1176         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1177 
1178         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1179         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)) { 
1180             //unonce, nbytes and sessionKeyHash match
1181             delete oraclize_randomDS_args[queryId];
1182         } 
1183         else 
1184             return false;
1185 
1186 
1187         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1188         bytes memory tosign1 = new bytes(32+8+1+32);
1189         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1190         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1191 
1192         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1193         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false) {
1194             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1195         }
1196 
1197         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1198     }
1199 
1200     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1201     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) 
1202     internal pure returns (bytes) {
1203         uint minLength = length + toOffset;
1204 
1205         // Buffer too small
1206         require(to.length >= minLength); // Should be a better way?
1207 
1208         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1209         uint i = 32 + fromOffset;
1210         uint j = 32 + toOffset;
1211 
1212         while (i < (32 + fromOffset + length)) {
1213             assembly {
1214                 let tmp := mload(add(from, i))
1215                 mstore(add(to, j), tmp)
1216             }
1217             i += 32;
1218             j += 32;
1219         }
1220 
1221         return to;
1222     }
1223 
1224     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1225     // Duplicate Solidity's ecrecover, but catching the CALL return value
1226     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1227         // We do our own memory management here. Solidity uses memory offset
1228         // 0x40 to store the current end of memory. We write past it (as
1229         // writes are memory extensions), but don't update the offset so
1230         // Solidity will reuse it. The memory used here is only needed for
1231         // this context.
1232 
1233         // FIXME: inline assembly can't access return values
1234         bool ret;
1235         address addr;
1236 
1237         assembly {
1238             let size := mload(0x40)
1239             mstore(size, hash)
1240             mstore(add(size, 32), v)
1241             mstore(add(size, 64), r)
1242             mstore(add(size, 96), s)
1243 
1244             // NOTE: we can reuse the request memory because we deal with
1245             //       the return code
1246             ret := call(3000, 1, 0, size, 128, size, 32)
1247             addr := mload(size)
1248         }
1249 
1250         return (ret, addr);
1251     }
1252 
1253     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1254     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1255         bytes32 r;
1256         bytes32 s;
1257         uint8 v;
1258 
1259         if (sig.length != 65)
1260             return (false, 0);
1261 
1262         // The signature format is a compact form of:
1263         //   {bytes32 r}{bytes32 s}{uint8 v}
1264         // Compact means, uint8 is not padded to 32 bytes.
1265         assembly {
1266             r := mload(add(sig, 32))
1267             s := mload(add(sig, 64))
1268 
1269             // Here we are loading the last 32 bytes. We exploit the fact that
1270             // 'mload' will pad with zeroes if we overread.
1271             // There is no 'mload8' to do this, but that would be nicer.
1272             v := byte(0, mload(add(sig, 96)))
1273 
1274             // Alternative solution:
1275             // 'byte' is not working due to the Solidity parser, so lets
1276             // use the second best option, 'and'
1277             // v := and(mload(add(sig, 65)), 255)
1278         }
1279 
1280         // albeit non-transactional signatures are not specified by the YP, one would expect it
1281         // to match the YP range of [27, 28]
1282         //
1283         // geth uses [0, 1] and some clients have followed. This might change, see:
1284         //  https://github.com/ethereum/go-ethereum/issues/2053
1285         if (v < 27)
1286             v += 27;
1287 
1288         if (v != 27 && v != 28)
1289             return (false, 0);
1290 
1291         return safer_ecrecover(hash, v, r, s);
1292     }
1293 
1294     function safeMemoryCleaner() internal pure {
1295         assembly {
1296             let fmem := mload(0x40)
1297             codecopy(fmem, codesize, sub(msize, fmem))
1298         }
1299     }
1300 
1301 }
1302 
1303 /**
1304  * @title Ownable
1305  * @dev The Ownable contract has an owner address, and provides basic authorization control
1306  * functions, this simplifies the implementation of "user permissions".
1307  */
1308 contract Ownable {
1309     address public owner;
1310 
1311     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1312 
1313     /**
1314     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1315     * account.
1316     */
1317     constructor () public {
1318         owner = msg.sender;
1319     }
1320 
1321     /**
1322     * @dev Throws if called by any account other than the owner.
1323     */
1324     modifier onlyOwner() {
1325         require(msg.sender == owner);
1326         _;
1327     }
1328 
1329     /**
1330     * @dev Allows the current owner to transfer control of the contract to a newOwner.
1331     * @param newOwner The address to transfer ownership to.
1332     */
1333     function transferOwnership(address newOwner) public onlyOwner {
1334         require(newOwner != address(0));
1335         emit OwnershipTransferred(owner, newOwner);
1336         owner = newOwner;
1337     }
1338 }
1339 
1340 /**
1341  * Contract which exposes `ethInCents` which is the Ether price in USD cents.
1342  * E.g. if 1 Ether is sold at 840.32 USD on the markets, the `ethInCents` will
1343  * be `84032`.
1344  *
1345  * This price is supplied by Oraclize callback, which sets the value. Currently
1346  * there is no proof provided for the callback, other then the value and the
1347  * corresponding ID which was generated when this contract called Oraclize.
1348  *
1349  * If this contract runs out of Ether, the callback cycle will interrupt until
1350  * the `update` function is called with a transaction which also replenishes the
1351  * balance of the contract.
1352  */
1353 contract ETHUSD is usingOraclize, Ownable {
1354    
1355     uint256 public ethInCents;
1356 
1357     event LogInfo(string description);
1358     event LogPriceUpdate(uint256 price);
1359     event LogUpdate(address indexed _owner, uint indexed _balance);
1360 
1361     // Constructor
1362     constructor (uint _ethInCents)
1363     public payable {
1364                
1365         ethInCents = _ethInCents;
1366 
1367         emit LogUpdate(owner, address(this).balance);
1368 
1369         // Replace the next line with your version:
1370         oraclize_setNetwork(1);
1371 
1372         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1373         update();
1374     }
1375 
1376     // Fallback function
1377     function() public payable {
1378         
1379     }
1380 
1381     function __callback(bytes32 myid, string result, bytes proof) public {
1382         require(msg.sender == oraclize_cbAddress());
1383 
1384         ethInCents = parseInt(result, 2);
1385         emit LogPriceUpdate(ethInCents);
1386         update();
1387     }
1388 
1389     function getBalance() public view returns (uint _balance) {
1390         return address(this).balance;
1391     }
1392 
1393     function update()
1394     public payable
1395     {
1396         // Check if we have enough remaining funds
1397         if (oraclize_getPrice("URL") > address(this).balance) {
1398             emit LogInfo("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1399         } else {
1400             emit LogInfo("Oraclize query was sent, standing by for the answer..");
1401 
1402             // Using XPath to to fetch the right element in the JSON response
1403             oraclize_query(7200, "URL", "json(https://api.coinbase.com/v2/prices/ETH-USD/spot).data.amount");
1404         }
1405     }
1406 
1407     function instantUpdate()
1408     public payable
1409     onlyOwner {
1410         // Check if we have enough remaining funds
1411         if (oraclize_getPrice("URL") > address(this).balance) {
1412             emit LogInfo("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1413         } else {
1414             emit LogInfo("Oraclize query was sent, standing by for the answer..");
1415 
1416             // Using XPath to to fetch the right element in the JSON response
1417             oraclize_query("URL", "json(https://api.coinbase.com/v2/prices/ETH-USD/spot).data.amount");
1418         }
1419     }
1420 
1421     function setEthInCents(uint _ethInCents)
1422     public onlyOwner {
1423         require(_ethInCents > 0);
1424         ethInCents = _ethInCents;
1425     }
1426 
1427     function withdrawFunds(address _addr) 
1428     public
1429     onlyOwner
1430     {
1431         if (msg.sender != owner) revert();
1432         _addr.transfer(address(this).balance);
1433     } 
1434 
1435 }
1436 
1437 /**
1438  * Fixed crowdsale pricing - everybody gets the same price.
1439  */
1440 contract FlatPricingExt is PricingStrategy, Ownable {
1441     using SafeMathLibExt for uint;
1442 
1443     /* How many weis one token costs */
1444     //uint public oneTokenInWei5; 
1445     uint public oneTokenInCents;
1446     //uint public ethInCents;
1447 
1448     ETHUSD public ethUsdObj;
1449     // Crowdsale rate has been changed
1450     event RateChanged(uint oneTokenInCents);
1451 
1452     constructor(uint _oneTokenInCents, address _ethUSDAddress) public {
1453       
1454         require(_oneTokenInCents > 0);   
1455 
1456         oneTokenInCents = _oneTokenInCents;
1457         ethUsdObj = ETHUSD(_ethUSDAddress); 
1458     }
1459 
1460     modifier onlyTier() {
1461         if (msg.sender != address(tier)) 
1462             revert();
1463         _;
1464     }
1465 
1466     function setTier(address _tier) public onlyOwner {
1467         assert(_tier != address(0));
1468         assert(tier == address(0));
1469         tier = _tier;
1470     }
1471 
1472     function setEthUSD(address _ethUSDAddress) public onlyOwner {
1473         assert(_ethUSDAddress != address(0));
1474         ethUsdObj = ETHUSD(_ethUSDAddress);
1475     }
1476 
1477     function updateRate(uint _oneTokenInCents) public onlyTier {
1478       
1479         require(_oneTokenInCents > 0);  
1480 
1481         oneTokenInCents = _oneTokenInCents;   
1482 
1483         emit RateChanged(oneTokenInCents);
1484     }
1485 
1486     /**
1487     * Calculate the current price for buy in amount.
1488     *
1489     */
1490     function calculatePrice(uint value, uint tokensSold, uint decimals) public view returns (uint) {
1491         uint multiplier = 10 ** decimals;    
1492         uint oneTokenPriceInWei = oneTokenInWei(tokensSold, decimals);
1493         return value.times(multiplier) / oneTokenPriceInWei;
1494     }
1495 
1496     function oneTokenInWei(uint tokensSold, uint decimals) public view returns (uint) {
1497         uint multiplier = 10 ** decimals;
1498         uint ethInCents = getEthInCents();
1499         uint oneTokenInWei5 = oneTokenInCents.times(multiplier).divides(ethInCents);
1500         
1501         uint oneTokenInWei1 = oneTokenInWei5.times(60).divides(100);
1502         uint oneTokenInWei2 = oneTokenInWei5.times(80).divides(100);
1503         uint oneTokenInWei3 = oneTokenInWei5.times(90).divides(100);
1504         uint oneTokenInWei4 = oneTokenInWei5.times(95).divides(100);
1505 
1506         if (tokensSold <= 25000000 * multiplier)
1507             return oneTokenInWei1;
1508         if (tokensSold > 25000000 * multiplier && tokensSold <= 80000000 * multiplier)
1509             return oneTokenInWei2;
1510         if (tokensSold > 80000000 * multiplier && tokensSold <= 120000000 * multiplier)
1511             return oneTokenInWei3;
1512         if (tokensSold > 120000000 * multiplier && tokensSold <= 140000000 * multiplier)
1513             return oneTokenInWei4;
1514         if (tokensSold > 140000000 * multiplier)
1515             return oneTokenInWei5;
1516     }
1517 
1518     function getEthInCents() public view returns (uint) {
1519         return ethUsdObj.ethInCents();
1520     }
1521 
1522 }