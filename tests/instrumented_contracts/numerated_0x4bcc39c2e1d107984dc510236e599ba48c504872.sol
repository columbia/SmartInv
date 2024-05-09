1 pragma solidity ^0.4.18;
2 
3 contract Token {
4   function saleTransfer(address _to, uint256 _value) public returns (bool);
5   function burnTokensForSale() public returns (bool);
6 }
7 
8 /**
9  * @title SafeMath
10  * @dev Math operations with safety checks that throw on error
11  */
12 library SafeMath {
13 
14   /**
15   * @dev Multiplies two numbers, throws on overflow.
16   */
17   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18     if (a == 0) {
19       return 0;
20     }
21     uint256 c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35 
36   /**
37   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256) {
48     uint256 c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 /**
55  * @title Crowdsale
56  * @dev Crowdsale is a base contract for managing a token crowdsale,
57  * allowing investors to purchase tokens with ether. This contract implements
58  * such functionality in its most fundamental form and can be extended to provide additional
59  * functionality and/or custom behavior.
60  * The external interface represents the basic interface for purchasing tokens, and conform
61  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
62  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override 
63  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
64  * behavior.
65  */
66 
67  contract OraclizeI {
68     address public cbAddress;
69     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
70     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
71     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
72     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
73     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
74     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
75     function getPrice(string _datasource) public returns (uint _dsprice);
76     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
77     function setProofType(byte _proofType) external;
78     function setCustomGasPrice(uint _gasPrice) external;
79     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
80 }
81 
82 contract OraclizeAddrResolverI {
83     function getAddress() public returns (address _addr);
84 }
85 
86 /*
87 Begin solidity-cborutils
88 https://github.com/smartcontractkit/solidity-cborutils
89 MIT License
90 Copyright (c) 2018 SmartContract ChainLink, Ltd.
91 Permission is hereby granted, free of charge, to any person obtaining a copy
92 of this software and associated documentation files (the "Software"), to deal
93 in the Software without restriction, including without limitation the rights
94 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
95 copies of the Software, and to permit persons to whom the Software is
96 furnished to do so, subject to the following conditions:
97 The above copyright notice and this permission notice shall be included in all
98 copies or substantial portions of the Software.
99 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
100 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
101 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
102 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
103 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
104 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
105 SOFTWARE.
106  */
107 
108 library Buffer {
109     struct buffer {
110         bytes buf;
111         uint capacity;
112     }
113 
114     function init(buffer memory buf, uint capacity) internal pure {
115         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
116         // Allocate space for the buffer data
117         buf.capacity = capacity;
118         assembly {
119             let ptr := mload(0x40)
120             mstore(buf, ptr)
121             mstore(0x40, add(ptr, capacity))
122         }
123     }
124 
125     function resize(buffer memory buf, uint capacity) private pure {
126         bytes memory oldbuf = buf.buf;
127         init(buf, capacity);
128         append(buf, oldbuf);
129     }
130 
131     function max(uint a, uint b) private pure returns(uint) {
132         if(a > b) {
133             return a;
134         }
135         return b;
136     }
137 
138     /**
139      * @dev Appends a byte array to the end of the buffer. Reverts if doing so
140      *      would exceed the capacity of the buffer.
141      * @param buf The buffer to append to.
142      * @param data The data to append.
143      * @return The original buffer.
144      */
145     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
146         if(data.length + buf.buf.length > buf.capacity) {
147             resize(buf, max(buf.capacity, data.length) * 2);
148         }
149 
150         uint dest;
151         uint src;
152         uint len = data.length;
153         assembly {
154             // Memory address of the buffer data
155             let bufptr := mload(buf)
156             // Length of existing buffer data
157             let buflen := mload(bufptr)
158             // Start address = buffer address + buffer length + sizeof(buffer length)
159             dest := add(add(bufptr, buflen), 32)
160             // Update buffer length
161             mstore(bufptr, add(buflen, mload(data)))
162             src := add(data, 32)
163         }
164 
165         // Copy word-length chunks while possible
166         for(; len >= 32; len -= 32) {
167             assembly {
168                 mstore(dest, mload(src))
169             }
170             dest += 32;
171             src += 32;
172         }
173 
174         // Copy remaining bytes
175         uint mask = 256 ** (32 - len) - 1;
176         assembly {
177             let srcpart := and(mload(src), not(mask))
178             let destpart := and(mload(dest), mask)
179             mstore(dest, or(destpart, srcpart))
180         }
181 
182         return buf;
183     }
184 
185     /**
186      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
187      * exceed the capacity of the buffer.
188      * @param buf The buffer to append to.
189      * @param data The data to append.
190      * @return The original buffer.
191      */
192     function append(buffer memory buf, uint8 data) internal pure {
193         if(buf.buf.length + 1 > buf.capacity) {
194             resize(buf, buf.capacity * 2);
195         }
196 
197         assembly {
198             // Memory address of the buffer data
199             let bufptr := mload(buf)
200             // Length of existing buffer data
201             let buflen := mload(bufptr)
202             // Address = buffer address + buffer length + sizeof(buffer length)
203             let dest := add(add(bufptr, buflen), 32)
204             mstore8(dest, data)
205             // Update buffer length
206             mstore(bufptr, add(buflen, 1))
207         }
208     }
209 
210     /**
211      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
212      * exceed the capacity of the buffer.
213      * @param buf The buffer to append to.
214      * @param data The data to append.
215      * @return The original buffer.
216      */
217     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
218         if(len + buf.buf.length > buf.capacity) {
219             resize(buf, max(buf.capacity, len) * 2);
220         }
221 
222         uint mask = 256 ** len - 1;
223         assembly {
224             // Memory address of the buffer data
225             let bufptr := mload(buf)
226             // Length of existing buffer data
227             let buflen := mload(bufptr)
228             // Address = buffer address + buffer length + sizeof(buffer length) + len
229             let dest := add(add(bufptr, buflen), len)
230             mstore(dest, or(and(mload(dest), not(mask)), data))
231             // Update buffer length
232             mstore(bufptr, add(buflen, len))
233         }
234         return buf;
235     }
236 }
237 
238 library CBOR {
239     using Buffer for Buffer.buffer;
240 
241     uint8 private constant MAJOR_TYPE_INT = 0;
242     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
243     uint8 private constant MAJOR_TYPE_BYTES = 2;
244     uint8 private constant MAJOR_TYPE_STRING = 3;
245     uint8 private constant MAJOR_TYPE_ARRAY = 4;
246     uint8 private constant MAJOR_TYPE_MAP = 5;
247     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
248 
249     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
250         if(value <= 23) {
251             buf.append(uint8((major << 5) | value));
252         } else if(value <= 0xFF) {
253             buf.append(uint8((major << 5) | 24));
254             buf.appendInt(value, 1);
255         } else if(value <= 0xFFFF) {
256             buf.append(uint8((major << 5) | 25));
257             buf.appendInt(value, 2);
258         } else if(value <= 0xFFFFFFFF) {
259             buf.append(uint8((major << 5) | 26));
260             buf.appendInt(value, 4);
261         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
262             buf.append(uint8((major << 5) | 27));
263             buf.appendInt(value, 8);
264         }
265     }
266 
267     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
268         buf.append(uint8((major << 5) | 31));
269     }
270 
271     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
272         encodeType(buf, MAJOR_TYPE_INT, value);
273     }
274 
275     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
276         if(value >= 0) {
277             encodeType(buf, MAJOR_TYPE_INT, uint(value));
278         } else {
279             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
280         }
281     }
282 
283     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
284         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
285         buf.append(value);
286     }
287 
288     function encodeString(Buffer.buffer memory buf, string value) internal pure {
289         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
290         buf.append(bytes(value));
291     }
292 
293     function startArray(Buffer.buffer memory buf) internal pure {
294         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
295     }
296 
297     function startMap(Buffer.buffer memory buf) internal pure {
298         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
299     }
300 
301     function endSequence(Buffer.buffer memory buf) internal pure {
302         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
303     }
304 }
305 
306 /*
307 End solidity-cborutils
308  */
309 
310 contract usingOraclize {
311     uint constant day = 60*60*24;
312     uint constant week = 60*60*24*7;
313     uint constant month = 60*60*24*30;
314     byte constant proofType_NONE = 0x00;
315     byte constant proofType_TLSNotary = 0x10;
316     byte constant proofType_Android = 0x20;
317     byte constant proofType_Ledger = 0x30;
318     byte constant proofType_Native = 0xF0;
319     byte constant proofStorage_IPFS = 0x01;
320     uint8 constant networkID_auto = 0;
321     uint8 constant networkID_mainnet = 1;
322     uint8 constant networkID_testnet = 2;
323     uint8 constant networkID_morden = 2;
324     uint8 constant networkID_consensys = 161;
325 
326     OraclizeAddrResolverI OAR;
327 
328     OraclizeI oraclize;
329     modifier oraclizeAPI {
330         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
331             oraclize_setNetwork(networkID_auto);
332 
333         if(address(oraclize) != OAR.getAddress())
334             oraclize = OraclizeI(OAR.getAddress());
335 
336         _;
337     }
338     modifier coupon(string code){
339         oraclize = OraclizeI(OAR.getAddress());
340         _;
341     }
342 
343     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
344       return oraclize_setNetwork();
345       networkID; // silence the warning and remain backwards compatible
346     }
347     function oraclize_setNetwork() internal returns(bool){
348         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
349             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
350             oraclize_setNetworkName("eth_mainnet");
351             return true;
352         }
353         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
354             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
355             oraclize_setNetworkName("eth_ropsten3");
356             return true;
357         }
358         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
359             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
360             oraclize_setNetworkName("eth_kovan");
361             return true;
362         }
363         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
364             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
365             oraclize_setNetworkName("eth_rinkeby");
366             return true;
367         }
368         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
369             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
370             return true;
371         }
372         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
373             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
374             return true;
375         }
376         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
377             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
378             return true;
379         }
380         return false;
381     }
382 
383     function __callback(bytes32 myid, string result) public {
384         __callback(myid, result, new bytes(0));
385     }
386     function __callback(bytes32 myid, string result, bytes proof) public {
387       return;
388       myid; result; proof; // Silence compiler warnings
389     }
390 
391     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
392         return oraclize.getPrice(datasource);
393     }
394 
395     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
396         return oraclize.getPrice(datasource, gaslimit);
397     }
398 
399     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
400         uint price = oraclize.getPrice(datasource);
401         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
402         return oraclize.query.value(price)(0, datasource, arg);
403     }
404     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
405         uint price = oraclize.getPrice(datasource);
406         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
407         return oraclize.query.value(price)(timestamp, datasource, arg);
408     }
409     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
410         uint price = oraclize.getPrice(datasource, gaslimit);
411         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
412         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
413     }
414     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
415         uint price = oraclize.getPrice(datasource, gaslimit);
416         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
417         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
418     }
419     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
420         uint price = oraclize.getPrice(datasource);
421         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
422         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
423     }
424     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
425         uint price = oraclize.getPrice(datasource);
426         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
427         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
428     }
429     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
430         uint price = oraclize.getPrice(datasource, gaslimit);
431         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
432         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
433     }
434     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
435         uint price = oraclize.getPrice(datasource, gaslimit);
436         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
437         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
438     }
439     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
440         uint price = oraclize.getPrice(datasource);
441         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
442         bytes memory args = stra2cbor(argN);
443         return oraclize.queryN.value(price)(0, datasource, args);
444     }
445     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
446         uint price = oraclize.getPrice(datasource);
447         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
448         bytes memory args = stra2cbor(argN);
449         return oraclize.queryN.value(price)(timestamp, datasource, args);
450     }
451     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
452         uint price = oraclize.getPrice(datasource, gaslimit);
453         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
454         bytes memory args = stra2cbor(argN);
455         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
456     }
457     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
458         uint price = oraclize.getPrice(datasource, gaslimit);
459         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
460         bytes memory args = stra2cbor(argN);
461         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
462     }
463     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
464         string[] memory dynargs = new string[](1);
465         dynargs[0] = args[0];
466         return oraclize_query(datasource, dynargs);
467     }
468     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
469         string[] memory dynargs = new string[](1);
470         dynargs[0] = args[0];
471         return oraclize_query(timestamp, datasource, dynargs);
472     }
473     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
474         string[] memory dynargs = new string[](1);
475         dynargs[0] = args[0];
476         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
477     }
478     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
479         string[] memory dynargs = new string[](1);
480         dynargs[0] = args[0];
481         return oraclize_query(datasource, dynargs, gaslimit);
482     }
483 
484     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
485         string[] memory dynargs = new string[](2);
486         dynargs[0] = args[0];
487         dynargs[1] = args[1];
488         return oraclize_query(datasource, dynargs);
489     }
490     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
491         string[] memory dynargs = new string[](2);
492         dynargs[0] = args[0];
493         dynargs[1] = args[1];
494         return oraclize_query(timestamp, datasource, dynargs);
495     }
496     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
497         string[] memory dynargs = new string[](2);
498         dynargs[0] = args[0];
499         dynargs[1] = args[1];
500         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
501     }
502     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
503         string[] memory dynargs = new string[](2);
504         dynargs[0] = args[0];
505         dynargs[1] = args[1];
506         return oraclize_query(datasource, dynargs, gaslimit);
507     }
508     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
509         string[] memory dynargs = new string[](3);
510         dynargs[0] = args[0];
511         dynargs[1] = args[1];
512         dynargs[2] = args[2];
513         return oraclize_query(datasource, dynargs);
514     }
515     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
516         string[] memory dynargs = new string[](3);
517         dynargs[0] = args[0];
518         dynargs[1] = args[1];
519         dynargs[2] = args[2];
520         return oraclize_query(timestamp, datasource, dynargs);
521     }
522     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
523         string[] memory dynargs = new string[](3);
524         dynargs[0] = args[0];
525         dynargs[1] = args[1];
526         dynargs[2] = args[2];
527         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
528     }
529     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
530         string[] memory dynargs = new string[](3);
531         dynargs[0] = args[0];
532         dynargs[1] = args[1];
533         dynargs[2] = args[2];
534         return oraclize_query(datasource, dynargs, gaslimit);
535     }
536 
537     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
538         string[] memory dynargs = new string[](4);
539         dynargs[0] = args[0];
540         dynargs[1] = args[1];
541         dynargs[2] = args[2];
542         dynargs[3] = args[3];
543         return oraclize_query(datasource, dynargs);
544     }
545     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
546         string[] memory dynargs = new string[](4);
547         dynargs[0] = args[0];
548         dynargs[1] = args[1];
549         dynargs[2] = args[2];
550         dynargs[3] = args[3];
551         return oraclize_query(timestamp, datasource, dynargs);
552     }
553     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
554         string[] memory dynargs = new string[](4);
555         dynargs[0] = args[0];
556         dynargs[1] = args[1];
557         dynargs[2] = args[2];
558         dynargs[3] = args[3];
559         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
560     }
561     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
562         string[] memory dynargs = new string[](4);
563         dynargs[0] = args[0];
564         dynargs[1] = args[1];
565         dynargs[2] = args[2];
566         dynargs[3] = args[3];
567         return oraclize_query(datasource, dynargs, gaslimit);
568     }
569     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
570         string[] memory dynargs = new string[](5);
571         dynargs[0] = args[0];
572         dynargs[1] = args[1];
573         dynargs[2] = args[2];
574         dynargs[3] = args[3];
575         dynargs[4] = args[4];
576         return oraclize_query(datasource, dynargs);
577     }
578     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
579         string[] memory dynargs = new string[](5);
580         dynargs[0] = args[0];
581         dynargs[1] = args[1];
582         dynargs[2] = args[2];
583         dynargs[3] = args[3];
584         dynargs[4] = args[4];
585         return oraclize_query(timestamp, datasource, dynargs);
586     }
587     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
588         string[] memory dynargs = new string[](5);
589         dynargs[0] = args[0];
590         dynargs[1] = args[1];
591         dynargs[2] = args[2];
592         dynargs[3] = args[3];
593         dynargs[4] = args[4];
594         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
595     }
596     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
597         string[] memory dynargs = new string[](5);
598         dynargs[0] = args[0];
599         dynargs[1] = args[1];
600         dynargs[2] = args[2];
601         dynargs[3] = args[3];
602         dynargs[4] = args[4];
603         return oraclize_query(datasource, dynargs, gaslimit);
604     }
605     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
606         uint price = oraclize.getPrice(datasource);
607         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
608         bytes memory args = ba2cbor(argN);
609         return oraclize.queryN.value(price)(0, datasource, args);
610     }
611     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
612         uint price = oraclize.getPrice(datasource);
613         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
614         bytes memory args = ba2cbor(argN);
615         return oraclize.queryN.value(price)(timestamp, datasource, args);
616     }
617     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
618         uint price = oraclize.getPrice(datasource, gaslimit);
619         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
620         bytes memory args = ba2cbor(argN);
621         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
622     }
623     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
624         uint price = oraclize.getPrice(datasource, gaslimit);
625         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
626         bytes memory args = ba2cbor(argN);
627         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
628     }
629     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
630         bytes[] memory dynargs = new bytes[](1);
631         dynargs[0] = args[0];
632         return oraclize_query(datasource, dynargs);
633     }
634     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
635         bytes[] memory dynargs = new bytes[](1);
636         dynargs[0] = args[0];
637         return oraclize_query(timestamp, datasource, dynargs);
638     }
639     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
640         bytes[] memory dynargs = new bytes[](1);
641         dynargs[0] = args[0];
642         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
643     }
644     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
645         bytes[] memory dynargs = new bytes[](1);
646         dynargs[0] = args[0];
647         return oraclize_query(datasource, dynargs, gaslimit);
648     }
649 
650     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
651         bytes[] memory dynargs = new bytes[](2);
652         dynargs[0] = args[0];
653         dynargs[1] = args[1];
654         return oraclize_query(datasource, dynargs);
655     }
656     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
657         bytes[] memory dynargs = new bytes[](2);
658         dynargs[0] = args[0];
659         dynargs[1] = args[1];
660         return oraclize_query(timestamp, datasource, dynargs);
661     }
662     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
663         bytes[] memory dynargs = new bytes[](2);
664         dynargs[0] = args[0];
665         dynargs[1] = args[1];
666         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
667     }
668     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
669         bytes[] memory dynargs = new bytes[](2);
670         dynargs[0] = args[0];
671         dynargs[1] = args[1];
672         return oraclize_query(datasource, dynargs, gaslimit);
673     }
674     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
675         bytes[] memory dynargs = new bytes[](3);
676         dynargs[0] = args[0];
677         dynargs[1] = args[1];
678         dynargs[2] = args[2];
679         return oraclize_query(datasource, dynargs);
680     }
681     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
682         bytes[] memory dynargs = new bytes[](3);
683         dynargs[0] = args[0];
684         dynargs[1] = args[1];
685         dynargs[2] = args[2];
686         return oraclize_query(timestamp, datasource, dynargs);
687     }
688     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
689         bytes[] memory dynargs = new bytes[](3);
690         dynargs[0] = args[0];
691         dynargs[1] = args[1];
692         dynargs[2] = args[2];
693         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
694     }
695     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
696         bytes[] memory dynargs = new bytes[](3);
697         dynargs[0] = args[0];
698         dynargs[1] = args[1];
699         dynargs[2] = args[2];
700         return oraclize_query(datasource, dynargs, gaslimit);
701     }
702 
703     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
704         bytes[] memory dynargs = new bytes[](4);
705         dynargs[0] = args[0];
706         dynargs[1] = args[1];
707         dynargs[2] = args[2];
708         dynargs[3] = args[3];
709         return oraclize_query(datasource, dynargs);
710     }
711     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
712         bytes[] memory dynargs = new bytes[](4);
713         dynargs[0] = args[0];
714         dynargs[1] = args[1];
715         dynargs[2] = args[2];
716         dynargs[3] = args[3];
717         return oraclize_query(timestamp, datasource, dynargs);
718     }
719     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
720         bytes[] memory dynargs = new bytes[](4);
721         dynargs[0] = args[0];
722         dynargs[1] = args[1];
723         dynargs[2] = args[2];
724         dynargs[3] = args[3];
725         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
726     }
727     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
728         bytes[] memory dynargs = new bytes[](4);
729         dynargs[0] = args[0];
730         dynargs[1] = args[1];
731         dynargs[2] = args[2];
732         dynargs[3] = args[3];
733         return oraclize_query(datasource, dynargs, gaslimit);
734     }
735     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
736         bytes[] memory dynargs = new bytes[](5);
737         dynargs[0] = args[0];
738         dynargs[1] = args[1];
739         dynargs[2] = args[2];
740         dynargs[3] = args[3];
741         dynargs[4] = args[4];
742         return oraclize_query(datasource, dynargs);
743     }
744     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
745         bytes[] memory dynargs = new bytes[](5);
746         dynargs[0] = args[0];
747         dynargs[1] = args[1];
748         dynargs[2] = args[2];
749         dynargs[3] = args[3];
750         dynargs[4] = args[4];
751         return oraclize_query(timestamp, datasource, dynargs);
752     }
753     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
754         bytes[] memory dynargs = new bytes[](5);
755         dynargs[0] = args[0];
756         dynargs[1] = args[1];
757         dynargs[2] = args[2];
758         dynargs[3] = args[3];
759         dynargs[4] = args[4];
760         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
761     }
762     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
763         bytes[] memory dynargs = new bytes[](5);
764         dynargs[0] = args[0];
765         dynargs[1] = args[1];
766         dynargs[2] = args[2];
767         dynargs[3] = args[3];
768         dynargs[4] = args[4];
769         return oraclize_query(datasource, dynargs, gaslimit);
770     }
771 
772     function oraclize_cbAddress() oraclizeAPI internal returns (address){
773         return oraclize.cbAddress();
774     }
775     function oraclize_setProof(byte proofP) oraclizeAPI internal {
776         return oraclize.setProofType(proofP);
777     }
778     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
779         return oraclize.setCustomGasPrice(gasPrice);
780     }
781 
782     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
783         return oraclize.randomDS_getSessionPubKeyHash();
784     }
785 
786     function getCodeSize(address _addr) constant internal returns(uint _size) {
787         assembly {
788             _size := extcodesize(_addr)
789         }
790     }
791 
792     function parseAddr(string _a) internal pure returns (address){
793         bytes memory tmp = bytes(_a);
794         uint160 iaddr = 0;
795         uint160 b1;
796         uint160 b2;
797         for (uint i=2; i<2+2*20; i+=2){
798             iaddr *= 256;
799             b1 = uint160(tmp[i]);
800             b2 = uint160(tmp[i+1]);
801             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
802             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
803             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
804             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
805             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
806             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
807             iaddr += (b1*16+b2);
808         }
809         return address(iaddr);
810     }
811 
812     function strCompare(string _a, string _b) internal pure returns (int) {
813         bytes memory a = bytes(_a);
814         bytes memory b = bytes(_b);
815         uint minLength = a.length;
816         if (b.length < minLength) minLength = b.length;
817         for (uint i = 0; i < minLength; i ++)
818             if (a[i] < b[i])
819                 return -1;
820             else if (a[i] > b[i])
821                 return 1;
822         if (a.length < b.length)
823             return -1;
824         else if (a.length > b.length)
825             return 1;
826         else
827             return 0;
828     }
829 
830     function indexOf(string _haystack, string _needle) internal pure returns (int) {
831         bytes memory h = bytes(_haystack);
832         bytes memory n = bytes(_needle);
833         if(h.length < 1 || n.length < 1 || (n.length > h.length))
834             return -1;
835         else if(h.length > (2**128 -1))
836             return -1;
837         else
838         {
839             uint subindex = 0;
840             for (uint i = 0; i < h.length; i ++)
841             {
842                 if (h[i] == n[0])
843                 {
844                     subindex = 1;
845                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
846                     {
847                         subindex++;
848                     }
849                     if(subindex == n.length)
850                         return int(i);
851                 }
852             }
853             return -1;
854         }
855     }
856 
857     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
858         bytes memory _ba = bytes(_a);
859         bytes memory _bb = bytes(_b);
860         bytes memory _bc = bytes(_c);
861         bytes memory _bd = bytes(_d);
862         bytes memory _be = bytes(_e);
863         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
864         bytes memory babcde = bytes(abcde);
865         uint k = 0;
866         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
867         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
868         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
869         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
870         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
871         return string(babcde);
872     }
873 
874     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
875         return strConcat(_a, _b, _c, _d, "");
876     }
877 
878     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
879         return strConcat(_a, _b, _c, "", "");
880     }
881 
882     function strConcat(string _a, string _b) internal pure returns (string) {
883         return strConcat(_a, _b, "", "", "");
884     }
885 
886     // parseInt
887     function parseInt(string _a) internal pure returns (uint) {
888         return parseInt(_a, 0);
889     }
890 
891     // parseInt(parseFloat*10^_b)
892     function parseInt(string _a, uint _b) internal pure returns (uint) {
893         bytes memory bresult = bytes(_a);
894         uint mint = 0;
895         bool decimals = false;
896         for (uint i=0; i<bresult.length; i++){
897             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
898                 if (decimals){
899                    if (_b == 0) break;
900                     else _b--;
901                 }
902                 mint *= 10;
903                 mint += uint(bresult[i]) - 48;
904             } else if (bresult[i] == 46) decimals = true;
905         }
906         if (_b > 0) mint *= 10**_b;
907         return mint;
908     }
909 
910     function uint2str(uint i) internal pure returns (string){
911         if (i == 0) return "0";
912         uint j = i;
913         uint len;
914         while (j != 0){
915             len++;
916             j /= 10;
917         }
918         bytes memory bstr = new bytes(len);
919         uint k = len - 1;
920         while (i != 0){
921             bstr[k--] = byte(48 + i % 10);
922             i /= 10;
923         }
924         return string(bstr);
925     }
926 
927     using CBOR for Buffer.buffer;
928     function stra2cbor(string[] arr) internal pure returns (bytes) {
929         Buffer.buffer memory buf;
930         Buffer.init(buf, 1024);
931         buf.startArray();
932         for (uint i = 0; i < arr.length; i++) {
933             buf.encodeString(arr[i]);
934         }
935         buf.endSequence();
936         return buf.buf;
937     }
938 
939     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
940         Buffer.buffer memory buf;
941         Buffer.init(buf, 1024);
942         buf.startArray();
943         for (uint i = 0; i < arr.length; i++) {
944             buf.encodeBytes(arr[i]);
945         }
946         buf.endSequence();
947         return buf.buf;
948     }
949 
950     string oraclize_network_name;
951     function oraclize_setNetworkName(string _network_name) internal {
952         oraclize_network_name = _network_name;
953     }
954 
955     function oraclize_getNetworkName() internal view returns (string) {
956         return oraclize_network_name;
957     }
958 
959     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
960         require((_nbytes > 0) && (_nbytes <= 32));
961         // Convert from seconds to ledger timer ticks
962         _delay *= 10;
963         bytes memory nbytes = new bytes(1);
964         nbytes[0] = byte(_nbytes);
965         bytes memory unonce = new bytes(32);
966         bytes memory sessionKeyHash = new bytes(32);
967         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
968         assembly {
969             mstore(unonce, 0x20)
970             // the following variables can be relaxed
971             // check relaxed random contract under ethereum-examples repo
972             // for an idea on how to override and replace comit hash vars
973             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
974             mstore(sessionKeyHash, 0x20)
975             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
976         }
977         bytes memory delay = new bytes(32);
978         assembly {
979             mstore(add(delay, 0x20), _delay)
980         }
981 
982         bytes memory delay_bytes8 = new bytes(8);
983         copyBytes(delay, 24, 8, delay_bytes8, 0);
984 
985         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
986         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
987 
988         bytes memory delay_bytes8_left = new bytes(8);
989 
990         assembly {
991             let x := mload(add(delay_bytes8, 0x20))
992             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
993             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
994             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
995             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
996             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
997             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
998             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
999             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1000 
1001         }
1002 
1003         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1004         return queryId;
1005     }
1006 
1007     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1008         oraclize_randomDS_args[queryId] = commitment;
1009     }
1010 
1011     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1012     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1013 
1014     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1015         bool sigok;
1016         address signer;
1017 
1018         bytes32 sigr;
1019         bytes32 sigs;
1020 
1021         bytes memory sigr_ = new bytes(32);
1022         uint offset = 4+(uint(dersig[3]) - 0x20);
1023         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1024         bytes memory sigs_ = new bytes(32);
1025         offset += 32 + 2;
1026         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1027 
1028         assembly {
1029             sigr := mload(add(sigr_, 32))
1030             sigs := mload(add(sigs_, 32))
1031         }
1032 
1033 
1034         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1035         if (address(keccak256(pubkey)) == signer) return true;
1036         else {
1037             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1038             return (address(keccak256(pubkey)) == signer);
1039         }
1040     }
1041 
1042     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1043         bool sigok;
1044 
1045         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1046         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1047         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1048 
1049         bytes memory appkey1_pubkey = new bytes(64);
1050         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1051 
1052         bytes memory tosign2 = new bytes(1+65+32);
1053         tosign2[0] = byte(1); //role
1054         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1055         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1056         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1057         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1058 
1059         if (sigok == false) return false;
1060 
1061 
1062         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1063         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1064 
1065         bytes memory tosign3 = new bytes(1+65);
1066         tosign3[0] = 0xFE;
1067         copyBytes(proof, 3, 65, tosign3, 1);
1068 
1069         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1070         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1071 
1072         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1073 
1074         return sigok;
1075     }
1076 
1077     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1078         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1079         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1080 
1081         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1082         require(proofVerified);
1083 
1084         _;
1085     }
1086 
1087     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1088         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1089         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1090 
1091         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1092         if (proofVerified == false) return 2;
1093 
1094         return 0;
1095     }
1096 
1097     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1098         bool match_ = true;
1099 
1100         require(prefix.length == n_random_bytes);
1101 
1102         for (uint256 i=0; i< n_random_bytes; i++) {
1103             if (content[i] != prefix[i]) match_ = false;
1104         }
1105 
1106         return match_;
1107     }
1108 
1109     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1110 
1111         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1112         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1113         bytes memory keyhash = new bytes(32);
1114         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1115         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1116 
1117         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1118         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1119 
1120         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1121         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1122 
1123         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1124         // This is to verify that the computed args match with the ones specified in the query.
1125         bytes memory commitmentSlice1 = new bytes(8+1+32);
1126         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1127 
1128         bytes memory sessionPubkey = new bytes(64);
1129         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1130         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1131 
1132         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1133         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1134             delete oraclize_randomDS_args[queryId];
1135         } else return false;
1136 
1137 
1138         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1139         bytes memory tosign1 = new bytes(32+8+1+32);
1140         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1141         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1142 
1143         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1144         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1145             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1146         }
1147 
1148         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1149     }
1150 
1151     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1152     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1153         uint minLength = length + toOffset;
1154 
1155         // Buffer too small
1156         require(to.length >= minLength); // Should be a better way?
1157 
1158         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1159         uint i = 32 + fromOffset;
1160         uint j = 32 + toOffset;
1161 
1162         while (i < (32 + fromOffset + length)) {
1163             assembly {
1164                 let tmp := mload(add(from, i))
1165                 mstore(add(to, j), tmp)
1166             }
1167             i += 32;
1168             j += 32;
1169         }
1170 
1171         return to;
1172     }
1173 
1174     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1175     // Duplicate Solidity's ecrecover, but catching the CALL return value
1176     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1177         // We do our own memory management here. Solidity uses memory offset
1178         // 0x40 to store the current end of memory. We write past it (as
1179         // writes are memory extensions), but don't update the offset so
1180         // Solidity will reuse it. The memory used here is only needed for
1181         // this context.
1182 
1183         // FIXME: inline assembly can't access return values
1184         bool ret;
1185         address addr;
1186 
1187         assembly {
1188             let size := mload(0x40)
1189             mstore(size, hash)
1190             mstore(add(size, 32), v)
1191             mstore(add(size, 64), r)
1192             mstore(add(size, 96), s)
1193 
1194             // NOTE: we can reuse the request memory because we deal with
1195             //       the return code
1196             ret := call(3000, 1, 0, size, 128, size, 32)
1197             addr := mload(size)
1198         }
1199 
1200         return (ret, addr);
1201     }
1202 
1203     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1204     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1205         bytes32 r;
1206         bytes32 s;
1207         uint8 v;
1208 
1209         if (sig.length != 65)
1210           return (false, 0);
1211 
1212         // The signature format is a compact form of:
1213         //   {bytes32 r}{bytes32 s}{uint8 v}
1214         // Compact means, uint8 is not padded to 32 bytes.
1215         assembly {
1216             r := mload(add(sig, 32))
1217             s := mload(add(sig, 64))
1218 
1219             // Here we are loading the last 32 bytes. We exploit the fact that
1220             // 'mload' will pad with zeroes if we overread.
1221             // There is no 'mload8' to do this, but that would be nicer.
1222             v := byte(0, mload(add(sig, 96)))
1223 
1224             // Alternative solution:
1225             // 'byte' is not working due to the Solidity parser, so lets
1226             // use the second best option, 'and'
1227             // v := and(mload(add(sig, 65)), 255)
1228         }
1229 
1230         // albeit non-transactional signatures are not specified by the YP, one would expect it
1231         // to match the YP range of [27, 28]
1232         //
1233         // geth uses [0, 1] and some clients have followed. This might change, see:
1234         //  https://github.com/ethereum/go-ethereum/issues/2053
1235         if (v < 27)
1236           v += 27;
1237 
1238         if (v != 27 && v != 28)
1239             return (false, 0);
1240 
1241         return safer_ecrecover(hash, v, r, s);
1242     }
1243 
1244 }
1245 // </ORACLIZE_API>
1246 
1247 /**
1248  * @title Ownable
1249  * @dev The Ownable contract has an owner address, and provides basic authorization control
1250  * functions, this simplifies the implementation of "user permissions".
1251  */
1252 contract Ownable {
1253   address public owner;
1254 
1255 
1256   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1257 
1258 
1259   /**
1260    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1261    * account.
1262    */
1263   function Ownable() public {
1264     owner = msg.sender;
1265   }
1266 
1267   /**
1268    * @dev Throws if called by any account other than the owner.
1269    */
1270   modifier onlyOwner() {
1271     require(msg.sender == owner);
1272     _;
1273   }
1274 
1275   /**
1276    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1277    * @param newOwner The address to transfer ownership to.
1278    */
1279   function transferOwnership(address newOwner) public onlyOwner {
1280     require(newOwner != address(0));
1281     OwnershipTransferred(owner, newOwner);
1282     owner = newOwner;
1283   }
1284 
1285 }
1286 
1287 contract PriceTicker is usingOraclize, Ownable {
1288 
1289     uint256 public ethPrice; // 1 Ether price in USD cents.
1290     uint256 constant CUSTOM_GASLIMIT = 150000;
1291     uint256 public updateTime = 0;
1292 
1293     event LogConstructorInitiated(string nextStep);
1294     event newOraclizeQuery(string description);
1295     event newPriceTicker(bytes32 myid, string price, bytes proof);
1296 
1297 
1298     function PriceTicker() public {
1299         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1300         LogConstructorInitiated("Constructor was initiated. Call 'update()' to send the Oraclize Query.");
1301     }
1302 
1303     function __callback(bytes32 myid, string result, bytes proof) public {
1304         if (msg.sender != oraclize_cbAddress()) revert();
1305         ethPrice = parseInt(result, 2);
1306         newPriceTicker(myid, result, proof);
1307         if (updateTime > 0) updateAfter(updateTime);
1308     }
1309 
1310     function update() public onlyOwner {
1311         if (updateTime > 0) updateTime = 0;
1312         if (oraclize_getPrice("URL", CUSTOM_GASLIMIT) > this.balance) {
1313             newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1314         } else {
1315             newOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1316             oraclize_query("URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0", CUSTOM_GASLIMIT);
1317         }
1318     }
1319 
1320     function updatePeriodically(uint256 _updateTime) public onlyOwner {
1321         updateTime = _updateTime;
1322         if (oraclize_getPrice("URL", CUSTOM_GASLIMIT) > this.balance) {
1323             newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1324         } else {
1325             newOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1326             oraclize_query("URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0", CUSTOM_GASLIMIT);
1327         }
1328     }
1329 
1330     function updateAfter(uint256 _updateTime) internal {
1331         if (oraclize_getPrice("URL", CUSTOM_GASLIMIT) > this.balance) {
1332             newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1333         } else {
1334             newOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1335             oraclize_query(_updateTime, "URL", "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0", CUSTOM_GASLIMIT);
1336         }
1337     }
1338 }
1339 
1340 contract Crowdsale is PriceTicker {
1341   using SafeMath for uint256;
1342 
1343   // The token being sold
1344   Token public token;
1345 
1346   // Address where funds are collected
1347   address public wallet;
1348 
1349   // How many token units a buyer gets per wei
1350   uint256 public rate;
1351 
1352   // Amount of wei raised
1353   uint256 public weiRaised;
1354   enum Stages {Pause, Private, PrivateEnd, PreIco, PreIcoEnd, Ico, IcoEnd}
1355   Stages currentStage;
1356   uint256 privateCap = uint256(150000000).mul(1 ether);
1357   uint256 preIcoCap = uint256(100000000).mul(1 ether);
1358   uint256 icoCap = uint256(500000000).mul(1 ether);
1359   uint256 privateTokensSold = 0;
1360   uint256 preIcoTokensSold = 0;
1361   uint256 icoTokensSold = 0;
1362   uint32 privateBonuses = 50;
1363   uint32 preIcoBonuses = 25;
1364   uint256 tokenPrice = 3; // price in USD cents, 1 token = 0.03 USD
1365 
1366   /**
1367    * Event for token purchase logging
1368    * @param purchaser who paid for the tokens
1369    * @param beneficiary who got the tokens
1370    * @param value weis paid for purchase
1371    * @param amount amount of tokens purchased
1372    */
1373   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
1374 
1375   /**
1376    * @param _wallet Address where collected funds will be forwarded to
1377    * @param _token Address of the token being sold
1378    */
1379   function Crowdsale(address _newOwner, address _wallet, Token _token) public {
1380     require(_wallet != address(0));
1381     require(_token != address(0));
1382     update();
1383 
1384     wallet = _wallet;
1385     owner = _newOwner;
1386     token = _token;
1387     currentStage = Stages.Private;
1388   }
1389 
1390   function endPrivate() public onlyOwner {
1391     require(currentStage == Stages.Private);
1392     currentStage = Stages.PrivateEnd;
1393   }
1394 
1395   function startPreIco() public onlyOwner {
1396     require(currentStage == Stages.PrivateEnd);
1397     currentStage = Stages.PreIco;
1398     if (privateTokensSold < privateCap) preIcoCap = preIcoCap.add(privateCap).sub(privateTokensSold);
1399   }
1400 
1401   function endPreIco() public onlyOwner {
1402     require(currentStage == Stages.PreIco);
1403     currentStage = Stages.PreIcoEnd;
1404   }
1405 
1406   function startIco() public onlyOwner {
1407     require(currentStage == Stages.PreIcoEnd);
1408     currentStage = Stages.Ico;
1409     if (preIcoTokensSold < preIcoCap) icoCap = icoCap.add(preIcoCap).sub(preIcoTokensSold);
1410   }
1411 
1412   function endIco() public onlyOwner {
1413     require(currentStage == Stages.Ico);
1414     currentStage = Stages.IcoEnd;
1415     require(token.burnTokensForSale());
1416   }
1417 
1418   function getStage() public view returns (string) {
1419     if (currentStage == Stages.Private) return 'Private sale';
1420     else if (currentStage == Stages.PrivateEnd) return 'Private sale end';
1421     else if (currentStage == Stages.PreIco) return 'Pre ICO';
1422     else if (currentStage == Stages.PreIcoEnd) return 'Pre ICO end';
1423     else if (currentStage == Stages.Ico) return 'ICO';
1424     else if (currentStage == Stages.IcoEnd) return 'ICO end';
1425   }
1426 
1427   // -----------------------------------------
1428   // Crowdsale external interface
1429   // -----------------------------------------
1430 
1431   /**
1432    * @dev fallback function ***DO NOT OVERRIDE***
1433    */
1434   function () external payable {
1435     if (msg.sender != owner) buyTokens(msg.sender);
1436   }
1437 
1438   /**
1439    * @param _beneficiary Address performing the token purchase
1440    */
1441   function buyTokens(address _beneficiary) public payable {
1442     uint256 weiAmount = msg.value;
1443     require(weiAmount > 0);
1444     require(ethPrice > 0);
1445     uint256 usdCents = weiAmount.mul(ethPrice).div(1 ether); 
1446     _preValidatePurchase(_beneficiary, weiAmount, usdCents);
1447 
1448     // calculate token amount to be created
1449     uint256 tokens = _getTokenAmount(usdCents);
1450 
1451     _validateTokensLimits(tokens);
1452 
1453     // update state
1454     weiRaised = weiRaised.add(weiAmount);
1455 
1456     _processPurchase(_beneficiary, tokens);
1457     TokenPurchase(msg.sender, _beneficiary, weiAmount, tokens);
1458     _forwardFunds();
1459   }
1460 
1461   // -----------------------------------------
1462   // Internal interface (extensible)
1463   // -----------------------------------------
1464 
1465   /**
1466    * @dev Validation of an incoming purchase. Use require statemens to revert state when conditions are not met. Use super to concatenate validations.
1467    * @param _beneficiary Address performing the token purchase
1468    * @param _weiAmount Value in wei involved in the purchase
1469    * @param _usdCents Value in usd cents involved in the purchase
1470    */
1471   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount, uint256 _usdCents) internal view {
1472     require(_beneficiary != address(0));
1473     if (currentStage == Stages.Private) {
1474       require(_usdCents >= 2500000); // 25,000 USD in cents
1475       require(_usdCents <= 25000000); // 250,000 USD in cents
1476     } else if(currentStage == Stages.PreIco) {
1477       require(_usdCents >= 240000); // 2,500 USD in cents
1478     } else if(currentStage == Stages.Ico) {
1479       require(_weiAmount > 100 finney); // 0.1 ETH
1480     } else {
1481       revert();
1482     }
1483   }
1484 
1485   /**
1486    * @dev Validation of the capped restrictions.
1487    * @param _tokens tokens amount
1488    */
1489   function _validateTokensLimits(uint256 _tokens) internal {
1490     if (currentStage == Stages.Private) {
1491       privateTokensSold = privateTokensSold.add(_tokens);
1492       require(privateTokensSold <= privateCap);
1493     } else if(currentStage == Stages.PreIco) {
1494       preIcoTokensSold = preIcoTokensSold.add(_tokens);
1495       require(preIcoTokensSold <= preIcoCap);
1496     } else if(currentStage == Stages.Ico) {
1497       icoTokensSold = icoTokensSold.add(_tokens);
1498       require(icoTokensSold <= icoCap);
1499     } else {
1500       revert();
1501     }
1502   }
1503 
1504   /**
1505    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
1506    * @param _beneficiary Address performing the token purchase
1507    * @param _tokenAmount Number of tokens to be emitted
1508    */
1509   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
1510     require(token.saleTransfer(_beneficiary, _tokenAmount));
1511   }
1512 
1513   /**
1514    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
1515    * @param _beneficiary Address receiving the tokens
1516    * @param _tokenAmount Number of tokens to be purchased
1517    */
1518   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
1519     _deliverTokens(_beneficiary, _tokenAmount);
1520   }
1521 
1522   /**
1523    * @param _usdCents Value in usd cents to be converted into tokens
1524    * @return Number of tokens that can be purchased with the specified _usdCents
1525    */
1526   function _getTokenAmount(uint256 _usdCents) internal view returns (uint256) {
1527     uint256 tokens = _usdCents.div(tokenPrice).mul(1 ether);
1528     uint256 bonuses = 0;
1529     if (currentStage == Stages.Private) bonuses = tokens.mul(privateBonuses).div(100);
1530     if (currentStage == Stages.PreIco) bonuses = tokens.mul(preIcoBonuses).div(100);
1531     if (bonuses > 0) tokens = tokens.add(bonuses);
1532 
1533     return tokens;
1534   }
1535 
1536   function transferSoldTokens(address _beneficiary, uint256 _tokenAmount) public onlyOwner {
1537     uint256 tokenAmount = _tokenAmount.mul(1 ether);
1538     _validateTokensLimits(tokenAmount);
1539     require(token.saleTransfer(_beneficiary, tokenAmount));
1540   }
1541 
1542   /**
1543    * @dev Determines how ETH is stored/forwarded on purchases.
1544    */
1545   function _forwardFunds() internal {
1546     wallet.transfer(msg.value);
1547   }
1548 }