1 pragma solidity 0.4.25;
2 
3 ////////////////////////////////////////////////////////////////////////////////
4 //
5 // Eth17 - Factory Contract
6 //
7 ////////////////////////////////////////////////////////////////////////////////
8 
9 // IMPORTS - now flattened for Etherscan verification
10 // import "github.com/oraclize/ethereum-api/oraclizeAPI.sol";
11 // import "github.com/OpenZeppelin/openzeppelin-solidity/contracts/math/SafeMath.sol";
12 
13 /**
14  * @title SafeMath
15  * @dev Math operations with safety checks that revert on error
16  */
17 library SafeMath {
18 
19   /**
20   * @dev Multiplies two numbers, reverts on overflow.
21   */
22   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
23     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
24     // benefit is lost if 'b' is also tested.
25     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
26     if (a == 0) {
27       return 0;
28     }
29 
30     uint256 c = a * b;
31     require(c / a == b);
32 
33     return c;
34   }
35 
36   /**
37   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
38   */
39   function div(uint256 a, uint256 b) internal pure returns (uint256) {
40     require(b > 0); // Solidity only automatically asserts when dividing by 0
41     uint256 c = a / b;
42     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
43 
44     return c;
45   }
46 
47   /**
48   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
49   */
50   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
51     require(b <= a);
52     uint256 c = a - b;
53 
54     return c;
55   }
56 
57   /**
58   * @dev Adds two numbers, reverts on overflow.
59   */
60   function add(uint256 a, uint256 b) internal pure returns (uint256) {
61     uint256 c = a + b;
62     require(c >= a);
63 
64     return c;
65   }
66 
67   /**
68   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
69   * reverts when dividing by zero.
70   */
71   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
72     require(b != 0);
73     return a % b;
74   }
75 }
76 
77 contract OraclizeI {
78     address public cbAddress;
79     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
80     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
81     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
82     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
83     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
84     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
85     function getPrice(string _datasource) public returns (uint _dsprice);
86     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
87     function setProofType(byte _proofType) external;
88     function setCustomGasPrice(uint _gasPrice) external;
89     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
90 }
91 
92 contract OraclizeAddrResolverI {
93     function getAddress() public returns (address _addr);
94 }
95 
96 library Buffer {
97     struct buffer {
98         bytes buf;
99         uint capacity;
100     }
101 
102     function init(buffer memory buf, uint _capacity) internal pure {
103         uint capacity = _capacity;
104         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
105         // Allocate space for the buffer data
106         buf.capacity = capacity;
107         assembly {
108             let ptr := mload(0x40)
109             mstore(buf, ptr)
110             mstore(ptr, 0)
111             mstore(0x40, add(ptr, capacity))
112         }
113     }
114 
115     function resize(buffer memory buf, uint capacity) private pure {
116         bytes memory oldbuf = buf.buf;
117         init(buf, capacity);
118         append(buf, oldbuf);
119     }
120 
121     function max(uint a, uint b) private pure returns(uint) {
122         if(a > b) {
123             return a;
124         }
125         return b;
126     }
127 
128     /**
129      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
130      *      would exceed the capacity of the buffer.
131      * @param buf The buffer to append to.
132      * @param data The data to append.
133      * @return The original buffer.
134      */
135     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
136         if(data.length + buf.buf.length > buf.capacity) {
137             resize(buf, max(buf.capacity, data.length) * 2);
138         }
139 
140         uint dest;
141         uint src;
142         uint len = data.length;
143         assembly {
144             // Memory address of the buffer data
145             let bufptr := mload(buf)
146             // Length of existing buffer data
147             let buflen := mload(bufptr)
148             // Start address = buffer address + buffer length + sizeof(buffer length)
149             dest := add(add(bufptr, buflen), 32)
150             // Update buffer length
151             mstore(bufptr, add(buflen, mload(data)))
152             src := add(data, 32)
153         }
154 
155         // Copy word-length chunks while possible
156         for(; len >= 32; len -= 32) {
157             assembly {
158                 mstore(dest, mload(src))
159             }
160             dest += 32;
161             src += 32;
162         }
163 
164         // Copy remaining bytes
165         uint mask = 256 ** (32 - len) - 1;
166         assembly {
167             let srcpart := and(mload(src), not(mask))
168             let destpart := and(mload(dest), mask)
169             mstore(dest, or(destpart, srcpart))
170         }
171 
172         return buf;
173     }
174 
175     /**
176      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
177      * exceed the capacity of the buffer.
178      * @param buf The buffer to append to.
179      * @param data The data to append.
180      * @return The original buffer.
181      */
182     function append(buffer memory buf, uint8 data) internal pure {
183         if(buf.buf.length + 1 > buf.capacity) {
184             resize(buf, buf.capacity * 2);
185         }
186 
187         assembly {
188             // Memory address of the buffer data
189             let bufptr := mload(buf)
190             // Length of existing buffer data
191             let buflen := mload(bufptr)
192             // Address = buffer address + buffer length + sizeof(buffer length)
193             let dest := add(add(bufptr, buflen), 32)
194             mstore8(dest, data)
195             // Update buffer length
196             mstore(bufptr, add(buflen, 1))
197         }
198     }
199 
200     /**
201      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
202      * exceed the capacity of the buffer.
203      * @param buf The buffer to append to.
204      * @param data The data to append.
205      * @return The original buffer.
206      */
207     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
208         if(len + buf.buf.length > buf.capacity) {
209             resize(buf, max(buf.capacity, len) * 2);
210         }
211 
212         uint mask = 256 ** len - 1;
213         assembly {
214             // Memory address of the buffer data
215             let bufptr := mload(buf)
216             // Length of existing buffer data
217             let buflen := mload(bufptr)
218             // Address = buffer address + buffer length + sizeof(buffer length) + len
219             let dest := add(add(bufptr, buflen), len)
220             mstore(dest, or(and(mload(dest), not(mask)), data))
221             // Update buffer length
222             mstore(bufptr, add(buflen, len))
223         }
224         return buf;
225     }
226 }
227 
228 library CBOR {
229     using Buffer for Buffer.buffer;
230 
231     uint8 private constant MAJOR_TYPE_INT = 0;
232     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
233     uint8 private constant MAJOR_TYPE_BYTES = 2;
234     uint8 private constant MAJOR_TYPE_STRING = 3;
235     uint8 private constant MAJOR_TYPE_ARRAY = 4;
236     uint8 private constant MAJOR_TYPE_MAP = 5;
237     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
238 
239     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
240         if(value <= 23) {
241             buf.append(uint8((major << 5) | value));
242         } else if(value <= 0xFF) {
243             buf.append(uint8((major << 5) | 24));
244             buf.appendInt(value, 1);
245         } else if(value <= 0xFFFF) {
246             buf.append(uint8((major << 5) | 25));
247             buf.appendInt(value, 2);
248         } else if(value <= 0xFFFFFFFF) {
249             buf.append(uint8((major << 5) | 26));
250             buf.appendInt(value, 4);
251         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
252             buf.append(uint8((major << 5) | 27));
253             buf.appendInt(value, 8);
254         }
255     }
256 
257     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
258         buf.append(uint8((major << 5) | 31));
259     }
260 
261     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
262         encodeType(buf, MAJOR_TYPE_INT, value);
263     }
264 
265     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
266         if(value >= 0) {
267             encodeType(buf, MAJOR_TYPE_INT, uint(value));
268         } else {
269             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
270         }
271     }
272 
273     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
274         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
275         buf.append(value);
276     }
277 
278     function encodeString(Buffer.buffer memory buf, string value) internal pure {
279         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
280         buf.append(bytes(value));
281     }
282 
283     function startArray(Buffer.buffer memory buf) internal pure {
284         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
285     }
286 
287     function startMap(Buffer.buffer memory buf) internal pure {
288         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
289     }
290 
291     function endSequence(Buffer.buffer memory buf) internal pure {
292         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
293     }
294 }
295 
296 /*
297 End solidity-cborutils
298  */
299 
300 contract usingOraclize {
301     uint constant day = 60*60*24;
302     uint constant week = 60*60*24*7;
303     uint constant month = 60*60*24*30;
304     byte constant proofType_NONE = 0x00;
305     byte constant proofType_TLSNotary = 0x10;
306     byte constant proofType_Ledger = 0x30;
307     byte constant proofType_Android = 0x40;
308     byte constant proofType_Native = 0xF0;
309     byte constant proofStorage_IPFS = 0x01;
310     uint8 constant networkID_auto = 0;
311     uint8 constant networkID_mainnet = 1;
312     uint8 constant networkID_testnet = 2;
313     uint8 constant networkID_morden = 2;
314     uint8 constant networkID_consensys = 161;
315 
316     OraclizeAddrResolverI OAR;
317 
318     OraclizeI oraclize;
319     modifier oraclizeAPI {
320         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
321             oraclize_setNetwork(networkID_auto);
322 
323         if(address(oraclize) != OAR.getAddress())
324             oraclize = OraclizeI(OAR.getAddress());
325 
326         _;
327     }
328     modifier coupon(string code){
329         oraclize = OraclizeI(OAR.getAddress());
330         _;
331     }
332 
333     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
334       return oraclize_setNetwork();
335       networkID; // silence the warning and remain backwards compatible
336     }
337     function oraclize_setNetwork() internal returns(bool){
338         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
339             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
340             oraclize_setNetworkName("eth_mainnet");
341             return true;
342         }
343         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
344             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
345             oraclize_setNetworkName("eth_ropsten3");
346             return true;
347         }
348         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
349             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
350             oraclize_setNetworkName("eth_kovan");
351             return true;
352         }
353         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
354             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
355             oraclize_setNetworkName("eth_rinkeby");
356             return true;
357         }
358         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
359             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
360             return true;
361         }
362         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
363             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
364             return true;
365         }
366         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
367             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
368             return true;
369         }
370         return false;
371     }
372 
373     function __callback(bytes32 myid, string result) public {
374         __callback(myid, result, new bytes(0));
375     }
376     function __callback(bytes32 myid, string result, bytes proof) public {
377       return;
378       myid; result; proof; // Silence compiler warnings
379     }
380 
381     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
382         return oraclize.getPrice(datasource);
383     }
384 
385     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
386         return oraclize.getPrice(datasource, gaslimit);
387     }
388 
389     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
390         uint price = oraclize.getPrice(datasource);
391         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
392         return oraclize.query.value(price)(0, datasource, arg);
393     }
394     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
395         uint price = oraclize.getPrice(datasource);
396         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
397         return oraclize.query.value(price)(timestamp, datasource, arg);
398     }
399     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
400         uint price = oraclize.getPrice(datasource, gaslimit);
401         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
402         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
403     }
404     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
405         uint price = oraclize.getPrice(datasource, gaslimit);
406         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
407         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
408     }
409     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
410         uint price = oraclize.getPrice(datasource);
411         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
412         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
413     }
414     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
415         uint price = oraclize.getPrice(datasource);
416         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
417         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
418     }
419     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
420         uint price = oraclize.getPrice(datasource, gaslimit);
421         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
422         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
423     }
424     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
425         uint price = oraclize.getPrice(datasource, gaslimit);
426         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
427         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
428     }
429     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
430         uint price = oraclize.getPrice(datasource);
431         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
432         bytes memory args = stra2cbor(argN);
433         return oraclize.queryN.value(price)(0, datasource, args);
434     }
435     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
436         uint price = oraclize.getPrice(datasource);
437         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
438         bytes memory args = stra2cbor(argN);
439         return oraclize.queryN.value(price)(timestamp, datasource, args);
440     }
441     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
442         uint price = oraclize.getPrice(datasource, gaslimit);
443         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
444         bytes memory args = stra2cbor(argN);
445         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
446     }
447     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
448         uint price = oraclize.getPrice(datasource, gaslimit);
449         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
450         bytes memory args = stra2cbor(argN);
451         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
452     }
453     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
454         string[] memory dynargs = new string[](1);
455         dynargs[0] = args[0];
456         return oraclize_query(datasource, dynargs);
457     }
458     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
459         string[] memory dynargs = new string[](1);
460         dynargs[0] = args[0];
461         return oraclize_query(timestamp, datasource, dynargs);
462     }
463     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
464         string[] memory dynargs = new string[](1);
465         dynargs[0] = args[0];
466         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
467     }
468     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
469         string[] memory dynargs = new string[](1);
470         dynargs[0] = args[0];
471         return oraclize_query(datasource, dynargs, gaslimit);
472     }
473 
474     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
475         string[] memory dynargs = new string[](2);
476         dynargs[0] = args[0];
477         dynargs[1] = args[1];
478         return oraclize_query(datasource, dynargs);
479     }
480     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
481         string[] memory dynargs = new string[](2);
482         dynargs[0] = args[0];
483         dynargs[1] = args[1];
484         return oraclize_query(timestamp, datasource, dynargs);
485     }
486     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
487         string[] memory dynargs = new string[](2);
488         dynargs[0] = args[0];
489         dynargs[1] = args[1];
490         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
491     }
492     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
493         string[] memory dynargs = new string[](2);
494         dynargs[0] = args[0];
495         dynargs[1] = args[1];
496         return oraclize_query(datasource, dynargs, gaslimit);
497     }
498     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
499         string[] memory dynargs = new string[](3);
500         dynargs[0] = args[0];
501         dynargs[1] = args[1];
502         dynargs[2] = args[2];
503         return oraclize_query(datasource, dynargs);
504     }
505     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
506         string[] memory dynargs = new string[](3);
507         dynargs[0] = args[0];
508         dynargs[1] = args[1];
509         dynargs[2] = args[2];
510         return oraclize_query(timestamp, datasource, dynargs);
511     }
512     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
513         string[] memory dynargs = new string[](3);
514         dynargs[0] = args[0];
515         dynargs[1] = args[1];
516         dynargs[2] = args[2];
517         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
518     }
519     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
520         string[] memory dynargs = new string[](3);
521         dynargs[0] = args[0];
522         dynargs[1] = args[1];
523         dynargs[2] = args[2];
524         return oraclize_query(datasource, dynargs, gaslimit);
525     }
526 
527     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
528         string[] memory dynargs = new string[](4);
529         dynargs[0] = args[0];
530         dynargs[1] = args[1];
531         dynargs[2] = args[2];
532         dynargs[3] = args[3];
533         return oraclize_query(datasource, dynargs);
534     }
535     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
536         string[] memory dynargs = new string[](4);
537         dynargs[0] = args[0];
538         dynargs[1] = args[1];
539         dynargs[2] = args[2];
540         dynargs[3] = args[3];
541         return oraclize_query(timestamp, datasource, dynargs);
542     }
543     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
544         string[] memory dynargs = new string[](4);
545         dynargs[0] = args[0];
546         dynargs[1] = args[1];
547         dynargs[2] = args[2];
548         dynargs[3] = args[3];
549         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
550     }
551     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
552         string[] memory dynargs = new string[](4);
553         dynargs[0] = args[0];
554         dynargs[1] = args[1];
555         dynargs[2] = args[2];
556         dynargs[3] = args[3];
557         return oraclize_query(datasource, dynargs, gaslimit);
558     }
559     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
560         string[] memory dynargs = new string[](5);
561         dynargs[0] = args[0];
562         dynargs[1] = args[1];
563         dynargs[2] = args[2];
564         dynargs[3] = args[3];
565         dynargs[4] = args[4];
566         return oraclize_query(datasource, dynargs);
567     }
568     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
569         string[] memory dynargs = new string[](5);
570         dynargs[0] = args[0];
571         dynargs[1] = args[1];
572         dynargs[2] = args[2];
573         dynargs[3] = args[3];
574         dynargs[4] = args[4];
575         return oraclize_query(timestamp, datasource, dynargs);
576     }
577     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
578         string[] memory dynargs = new string[](5);
579         dynargs[0] = args[0];
580         dynargs[1] = args[1];
581         dynargs[2] = args[2];
582         dynargs[3] = args[3];
583         dynargs[4] = args[4];
584         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
585     }
586     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
587         string[] memory dynargs = new string[](5);
588         dynargs[0] = args[0];
589         dynargs[1] = args[1];
590         dynargs[2] = args[2];
591         dynargs[3] = args[3];
592         dynargs[4] = args[4];
593         return oraclize_query(datasource, dynargs, gaslimit);
594     }
595     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
596         uint price = oraclize.getPrice(datasource);
597         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
598         bytes memory args = ba2cbor(argN);
599         return oraclize.queryN.value(price)(0, datasource, args);
600     }
601     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
602         uint price = oraclize.getPrice(datasource);
603         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
604         bytes memory args = ba2cbor(argN);
605         return oraclize.queryN.value(price)(timestamp, datasource, args);
606     }
607     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
608         uint price = oraclize.getPrice(datasource, gaslimit);
609         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
610         bytes memory args = ba2cbor(argN);
611         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
612     }
613     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
614         uint price = oraclize.getPrice(datasource, gaslimit);
615         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
616         bytes memory args = ba2cbor(argN);
617         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
618     }
619     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
620         bytes[] memory dynargs = new bytes[](1);
621         dynargs[0] = args[0];
622         return oraclize_query(datasource, dynargs);
623     }
624     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
625         bytes[] memory dynargs = new bytes[](1);
626         dynargs[0] = args[0];
627         return oraclize_query(timestamp, datasource, dynargs);
628     }
629     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
630         bytes[] memory dynargs = new bytes[](1);
631         dynargs[0] = args[0];
632         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
633     }
634     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
635         bytes[] memory dynargs = new bytes[](1);
636         dynargs[0] = args[0];
637         return oraclize_query(datasource, dynargs, gaslimit);
638     }
639 
640     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
641         bytes[] memory dynargs = new bytes[](2);
642         dynargs[0] = args[0];
643         dynargs[1] = args[1];
644         return oraclize_query(datasource, dynargs);
645     }
646     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
647         bytes[] memory dynargs = new bytes[](2);
648         dynargs[0] = args[0];
649         dynargs[1] = args[1];
650         return oraclize_query(timestamp, datasource, dynargs);
651     }
652     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
653         bytes[] memory dynargs = new bytes[](2);
654         dynargs[0] = args[0];
655         dynargs[1] = args[1];
656         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
657     }
658     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
659         bytes[] memory dynargs = new bytes[](2);
660         dynargs[0] = args[0];
661         dynargs[1] = args[1];
662         return oraclize_query(datasource, dynargs, gaslimit);
663     }
664     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
665         bytes[] memory dynargs = new bytes[](3);
666         dynargs[0] = args[0];
667         dynargs[1] = args[1];
668         dynargs[2] = args[2];
669         return oraclize_query(datasource, dynargs);
670     }
671     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
672         bytes[] memory dynargs = new bytes[](3);
673         dynargs[0] = args[0];
674         dynargs[1] = args[1];
675         dynargs[2] = args[2];
676         return oraclize_query(timestamp, datasource, dynargs);
677     }
678     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
679         bytes[] memory dynargs = new bytes[](3);
680         dynargs[0] = args[0];
681         dynargs[1] = args[1];
682         dynargs[2] = args[2];
683         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
684     }
685     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
686         bytes[] memory dynargs = new bytes[](3);
687         dynargs[0] = args[0];
688         dynargs[1] = args[1];
689         dynargs[2] = args[2];
690         return oraclize_query(datasource, dynargs, gaslimit);
691     }
692 
693     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
694         bytes[] memory dynargs = new bytes[](4);
695         dynargs[0] = args[0];
696         dynargs[1] = args[1];
697         dynargs[2] = args[2];
698         dynargs[3] = args[3];
699         return oraclize_query(datasource, dynargs);
700     }
701     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
702         bytes[] memory dynargs = new bytes[](4);
703         dynargs[0] = args[0];
704         dynargs[1] = args[1];
705         dynargs[2] = args[2];
706         dynargs[3] = args[3];
707         return oraclize_query(timestamp, datasource, dynargs);
708     }
709     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
710         bytes[] memory dynargs = new bytes[](4);
711         dynargs[0] = args[0];
712         dynargs[1] = args[1];
713         dynargs[2] = args[2];
714         dynargs[3] = args[3];
715         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
716     }
717     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
718         bytes[] memory dynargs = new bytes[](4);
719         dynargs[0] = args[0];
720         dynargs[1] = args[1];
721         dynargs[2] = args[2];
722         dynargs[3] = args[3];
723         return oraclize_query(datasource, dynargs, gaslimit);
724     }
725     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
726         bytes[] memory dynargs = new bytes[](5);
727         dynargs[0] = args[0];
728         dynargs[1] = args[1];
729         dynargs[2] = args[2];
730         dynargs[3] = args[3];
731         dynargs[4] = args[4];
732         return oraclize_query(datasource, dynargs);
733     }
734     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
735         bytes[] memory dynargs = new bytes[](5);
736         dynargs[0] = args[0];
737         dynargs[1] = args[1];
738         dynargs[2] = args[2];
739         dynargs[3] = args[3];
740         dynargs[4] = args[4];
741         return oraclize_query(timestamp, datasource, dynargs);
742     }
743     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
744         bytes[] memory dynargs = new bytes[](5);
745         dynargs[0] = args[0];
746         dynargs[1] = args[1];
747         dynargs[2] = args[2];
748         dynargs[3] = args[3];
749         dynargs[4] = args[4];
750         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
751     }
752     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
753         bytes[] memory dynargs = new bytes[](5);
754         dynargs[0] = args[0];
755         dynargs[1] = args[1];
756         dynargs[2] = args[2];
757         dynargs[3] = args[3];
758         dynargs[4] = args[4];
759         return oraclize_query(datasource, dynargs, gaslimit);
760     }
761 
762     function oraclize_cbAddress() oraclizeAPI internal returns (address){
763         return oraclize.cbAddress();
764     }
765     function oraclize_setProof(byte proofP) oraclizeAPI internal {
766         return oraclize.setProofType(proofP);
767     }
768     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
769         return oraclize.setCustomGasPrice(gasPrice);
770     }
771 
772     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
773         return oraclize.randomDS_getSessionPubKeyHash();
774     }
775 
776     function getCodeSize(address _addr) constant internal returns(uint _size) {
777         assembly {
778             _size := extcodesize(_addr)
779         }
780     }
781 
782     function parseAddr(string _a) internal pure returns (address){
783         bytes memory tmp = bytes(_a);
784         uint160 iaddr = 0;
785         uint160 b1;
786         uint160 b2;
787         for (uint i=2; i<2+2*20; i+=2){
788             iaddr *= 256;
789             b1 = uint160(tmp[i]);
790             b2 = uint160(tmp[i+1]);
791             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
792             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
793             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
794             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
795             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
796             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
797             iaddr += (b1*16+b2);
798         }
799         return address(iaddr);
800     }
801 
802     function strCompare(string _a, string _b) internal pure returns (int) {
803         bytes memory a = bytes(_a);
804         bytes memory b = bytes(_b);
805         uint minLength = a.length;
806         if (b.length < minLength) minLength = b.length;
807         for (uint i = 0; i < minLength; i ++)
808             if (a[i] < b[i])
809                 return -1;
810             else if (a[i] > b[i])
811                 return 1;
812         if (a.length < b.length)
813             return -1;
814         else if (a.length > b.length)
815             return 1;
816         else
817             return 0;
818     }
819 
820     function indexOf(string _haystack, string _needle) internal pure returns (int) {
821         bytes memory h = bytes(_haystack);
822         bytes memory n = bytes(_needle);
823         if(h.length < 1 || n.length < 1 || (n.length > h.length))
824             return -1;
825         else if(h.length > (2**128 -1))
826             return -1;
827         else
828         {
829             uint subindex = 0;
830             for (uint i = 0; i < h.length; i ++)
831             {
832                 if (h[i] == n[0])
833                 {
834                     subindex = 1;
835                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
836                     {
837                         subindex++;
838                     }
839                     if(subindex == n.length)
840                         return int(i);
841                 }
842             }
843             return -1;
844         }
845     }
846 
847     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
848         bytes memory _ba = bytes(_a);
849         bytes memory _bb = bytes(_b);
850         bytes memory _bc = bytes(_c);
851         bytes memory _bd = bytes(_d);
852         bytes memory _be = bytes(_e);
853         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
854         bytes memory babcde = bytes(abcde);
855         uint k = 0;
856         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
857         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
858         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
859         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
860         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
861         return string(babcde);
862     }
863 
864     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
865         return strConcat(_a, _b, _c, _d, "");
866     }
867 
868     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
869         return strConcat(_a, _b, _c, "", "");
870     }
871 
872     function strConcat(string _a, string _b) internal pure returns (string) {
873         return strConcat(_a, _b, "", "", "");
874     }
875 
876     // parseInt
877     function parseInt(string _a) internal pure returns (uint) {
878         return parseInt(_a, 0);
879     }
880 
881     // parseInt(parseFloat*10^_b)
882     function parseInt(string _a, uint _b) internal pure returns (uint) {
883         bytes memory bresult = bytes(_a);
884         uint mint = 0;
885         bool decimals = false;
886         for (uint i=0; i<bresult.length; i++){
887             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
888                 if (decimals){
889                    if (_b == 0) break;
890                     else _b--;
891                 }
892                 mint *= 10;
893                 mint += uint(bresult[i]) - 48;
894             } else if (bresult[i] == 46) decimals = true;
895         }
896         if (_b > 0) mint *= 10**_b;
897         return mint;
898     }
899 
900     function uint2str(uint i) internal pure returns (string){
901         if (i == 0) return "0";
902         uint j = i;
903         uint len;
904         while (j != 0){
905             len++;
906             j /= 10;
907         }
908         bytes memory bstr = new bytes(len);
909         uint k = len - 1;
910         while (i != 0){
911             bstr[k--] = byte(48 + i % 10);
912             i /= 10;
913         }
914         return string(bstr);
915     }
916 
917     using CBOR for Buffer.buffer;
918     function stra2cbor(string[] arr) internal pure returns (bytes) {
919         safeMemoryCleaner();
920         Buffer.buffer memory buf;
921         Buffer.init(buf, 1024);
922         buf.startArray();
923         for (uint i = 0; i < arr.length; i++) {
924             buf.encodeString(arr[i]);
925         }
926         buf.endSequence();
927         return buf.buf;
928     }
929 
930     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
931         safeMemoryCleaner();
932         Buffer.buffer memory buf;
933         Buffer.init(buf, 1024);
934         buf.startArray();
935         for (uint i = 0; i < arr.length; i++) {
936             buf.encodeBytes(arr[i]);
937         }
938         buf.endSequence();
939         return buf.buf;
940     }
941 
942     string oraclize_network_name;
943     function oraclize_setNetworkName(string _network_name) internal {
944         oraclize_network_name = _network_name;
945     }
946 
947     function oraclize_getNetworkName() internal view returns (string) {
948         return oraclize_network_name;
949     }
950 
951     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
952         require((_nbytes > 0) && (_nbytes <= 32));
953         // Convert from seconds to ledger timer ticks
954         _delay *= 10;
955         bytes memory nbytes = new bytes(1);
956         nbytes[0] = byte(_nbytes);
957         bytes memory unonce = new bytes(32);
958         bytes memory sessionKeyHash = new bytes(32);
959         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
960         assembly {
961             mstore(unonce, 0x20)
962             // the following variables can be relaxed
963             // check relaxed random contract under ethereum-examples repo
964             // for an idea on how to override and replace comit hash vars
965             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
966             mstore(sessionKeyHash, 0x20)
967             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
968         }
969         bytes memory delay = new bytes(32);
970         assembly {
971             mstore(add(delay, 0x20), _delay)
972         }
973 
974         bytes memory delay_bytes8 = new bytes(8);
975         copyBytes(delay, 24, 8, delay_bytes8, 0);
976 
977         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
978         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
979 
980         bytes memory delay_bytes8_left = new bytes(8);
981 
982         assembly {
983             let x := mload(add(delay_bytes8, 0x20))
984             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
985             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
986             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
987             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
988             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
989             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
990             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
991             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
992 
993         }
994 
995         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
996         return queryId;
997     }
998 
999     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1000         oraclize_randomDS_args[queryId] = commitment;
1001     }
1002 
1003     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1004     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1005 
1006     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1007         bool sigok;
1008         address signer;
1009 
1010         bytes32 sigr;
1011         bytes32 sigs;
1012 
1013         bytes memory sigr_ = new bytes(32);
1014         uint offset = 4+(uint(dersig[3]) - 0x20);
1015         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1016         bytes memory sigs_ = new bytes(32);
1017         offset += 32 + 2;
1018         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1019 
1020         assembly {
1021             sigr := mload(add(sigr_, 32))
1022             sigs := mload(add(sigs_, 32))
1023         }
1024 
1025 
1026         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1027         if (address(keccak256(pubkey)) == signer) return true;
1028         else {
1029             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1030             return (address(keccak256(pubkey)) == signer);
1031         }
1032     }
1033 
1034     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1035         bool sigok;
1036 
1037         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1038         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1039         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1040 
1041         bytes memory appkey1_pubkey = new bytes(64);
1042         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1043 
1044         bytes memory tosign2 = new bytes(1+65+32);
1045         tosign2[0] = byte(1); //role
1046         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1047         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1048         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1049         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1050 
1051         if (sigok == false) return false;
1052 
1053 
1054         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1055         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1056 
1057         bytes memory tosign3 = new bytes(1+65);
1058         tosign3[0] = 0xFE;
1059         copyBytes(proof, 3, 65, tosign3, 1);
1060 
1061         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1062         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1063 
1064         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1065 
1066         return sigok;
1067     }
1068 
1069     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1070         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1071         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1072 
1073         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1074         require(proofVerified);
1075 
1076         _;
1077     }
1078 
1079     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1080         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1081         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1082 
1083         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1084         if (proofVerified == false) return 2;
1085 
1086         return 0;
1087     }
1088 
1089     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1090         bool match_ = true;
1091 
1092         require(prefix.length == n_random_bytes);
1093 
1094         for (uint256 i=0; i< n_random_bytes; i++) {
1095             if (content[i] != prefix[i]) match_ = false;
1096         }
1097 
1098         return match_;
1099     }
1100 
1101     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1102 
1103         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1104         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1105         bytes memory keyhash = new bytes(32);
1106         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1107         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1108 
1109         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1110         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1111 
1112         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1113         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1114 
1115         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1116         // This is to verify that the computed args match with the ones specified in the query.
1117         bytes memory commitmentSlice1 = new bytes(8+1+32);
1118         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1119 
1120         bytes memory sessionPubkey = new bytes(64);
1121         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1122         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1123 
1124         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1125         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1126             delete oraclize_randomDS_args[queryId];
1127         } else return false;
1128 
1129 
1130         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1131         bytes memory tosign1 = new bytes(32+8+1+32);
1132         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1133         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1134 
1135         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1136         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1137             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1138         }
1139 
1140         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1141     }
1142 
1143     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1144     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1145         uint minLength = length + toOffset;
1146 
1147         // Buffer too small
1148         require(to.length >= minLength); // Should be a better way?
1149 
1150         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1151         uint i = 32 + fromOffset;
1152         uint j = 32 + toOffset;
1153 
1154         while (i < (32 + fromOffset + length)) {
1155             assembly {
1156                 let tmp := mload(add(from, i))
1157                 mstore(add(to, j), tmp)
1158             }
1159             i += 32;
1160             j += 32;
1161         }
1162 
1163         return to;
1164     }
1165 
1166     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1167     // Duplicate Solidity's ecrecover, but catching the CALL return value
1168     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1169         // We do our own memory management here. Solidity uses memory offset
1170         // 0x40 to store the current end of memory. We write past it (as
1171         // writes are memory extensions), but don't update the offset so
1172         // Solidity will reuse it. The memory used here is only needed for
1173         // this context.
1174 
1175         // FIXME: inline assembly can't access return values
1176         bool ret;
1177         address addr;
1178 
1179         assembly {
1180             let size := mload(0x40)
1181             mstore(size, hash)
1182             mstore(add(size, 32), v)
1183             mstore(add(size, 64), r)
1184             mstore(add(size, 96), s)
1185 
1186             // NOTE: we can reuse the request memory because we deal with
1187             //       the return code
1188             ret := call(3000, 1, 0, size, 128, size, 32)
1189             addr := mload(size)
1190         }
1191 
1192         return (ret, addr);
1193     }
1194 
1195     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1196     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1197         bytes32 r;
1198         bytes32 s;
1199         uint8 v;
1200 
1201         if (sig.length != 65)
1202           return (false, 0);
1203 
1204         // The signature format is a compact form of:
1205         //   {bytes32 r}{bytes32 s}{uint8 v}
1206         // Compact means, uint8 is not padded to 32 bytes.
1207         assembly {
1208             r := mload(add(sig, 32))
1209             s := mload(add(sig, 64))
1210 
1211             // Here we are loading the last 32 bytes. We exploit the fact that
1212             // 'mload' will pad with zeroes if we overread.
1213             // There is no 'mload8' to do this, but that would be nicer.
1214             v := byte(0, mload(add(sig, 96)))
1215 
1216             // Alternative solution:
1217             // 'byte' is not working due to the Solidity parser, so lets
1218             // use the second best option, 'and'
1219             // v := and(mload(add(sig, 65)), 255)
1220         }
1221 
1222         // albeit non-transactional signatures are not specified by the YP, one would expect it
1223         // to match the YP range of [27, 28]
1224         //
1225         // geth uses [0, 1] and some clients have followed. This might change, see:
1226         //  https://github.com/ethereum/go-ethereum/issues/2053
1227         if (v < 27)
1228           v += 27;
1229 
1230         if (v != 27 && v != 28)
1231             return (false, 0);
1232 
1233         return safer_ecrecover(hash, v, r, s);
1234     }
1235 
1236     function safeMemoryCleaner() internal pure {
1237         assembly {
1238             let fmem := mload(0x40)
1239             codecopy(fmem, codesize, sub(msize, fmem))
1240         }
1241     }
1242 
1243 }
1244 // </ORACLIZE_API>
1245 
1246 
1247 
1248 
1249 ////////////////////////////////////////////////////////////////////////////////
1250 // Eth17 - Master Contract that holds the Factory address and Eth funds
1251 ////////////////////////////////////////////////////////////////////////////////
1252 //
1253     contract Master {
1254         function factoryContractAddress() public pure returns(address) {}
1255         function transferEth() public pure {}
1256     }
1257 //
1258 ////////////////////////////////////////////////////////////////////////////////
1259 
1260 
1261 
1262 ////////////////////////////////////////////////////////////////////////////////
1263 // Eth17 - Factory Contract - generates the game contracts
1264 ////////////////////////////////////////////////////////////////////////////////
1265 
1266     contract Factory {
1267         using SafeMath for uint256;
1268 
1269     address public admin;
1270     address public thisContractAddress;
1271     address[] public contracts;
1272     address public latestSpawnedContract;
1273     address public masterAddress;
1274     address public devWallet;
1275     
1276     // ENUM 
1277     Factory factory;
1278     Master master;
1279     
1280   
1281     modifier onlyAdmin { 
1282         require(msg.sender == admin
1283         ); 
1284         _; 
1285     }
1286     
1287     modifier onlyContract { 
1288         require(msg.sender == thisContractAddress
1289         ); 
1290         _; 
1291     }
1292     
1293     modifier adminOrSpawned { 
1294         require(
1295         msg.sender == admin ||
1296         msg.sender == latestSpawnedContract ||
1297         msg.sender == thisContractAddress
1298         ); 
1299         _; 
1300     }
1301 
1302     constructor() public payable {
1303         admin = msg.sender;
1304         thisContractAddress = address(this);
1305         
1306         ////////////////////////////////////////////////////////////////////////
1307         // SET MASTER PRIOR TO FACTORY DEPLOYMENT
1308         //
1309            masterAddress = 0x2fd1C5Be712511454DbAE356c100f2004F243998;
1310            devWallet = 0x77a0732111e426a68064d7f34B812a0E5D317d9c;
1311         //
1312         ////////////////////////////////////////////////////////////////////////
1313         
1314         master = Master(masterAddress);
1315     }
1316     
1317         // FALLBACK
1318     function () private payable {}
1319     
1320 //    function setMasterAddress(address _address) onlyAdmin public {
1321 //    masterAddress = address(_address);
1322 //    master = Master(masterAddress);
1323 //    }
1324     
1325     function setDevWalletAddress(address _address) onlyAdmin public {
1326     devWallet = address(_address);
1327     master = Master(masterAddress);
1328     }
1329     
1330 
1331     function thisContractBalance() public view returns(uint) {
1332       return address(this).balance;
1333     }
1334   
1335 
1336 	function withdrawAll() onlyAdmin public {
1337 	    address(admin).transfer(address(this).balance);
1338 	}
1339 
1340     function getContractCount() public view returns(uint contractCount) {
1341         return contracts.length;
1342     }
1343   
1344     function latestSpawnedContract() public view returns(address) {
1345         return address(contracts[contracts.length.sub(1)]);
1346     }
1347     
1348     function previousContract() public view returns(address) {
1349         if(getContractCount() == 2) {
1350             return address(contracts[0]);
1351         } 
1352         else
1353         return address(contracts[contracts.length.sub(2)]);
1354     }
1355 
1356     
1357     function firstSpawn() onlyAdmin public {
1358         Eth17 eth17 = new Eth17();
1359         contracts.push(eth17);
1360     }
1361     
1362     
1363     function newSpawn() public {
1364         require (msg.sender == address(contracts[contracts.length.sub(1)]));
1365         Eth17 eth17 = new Eth17();
1366         contracts.push(eth17);
1367     }
1368   
1369     function transferEth() public {
1370         require (msg.sender == address(contracts[contracts.length.sub(2)]));
1371         require (address(this).balance >= 1 ether);
1372         address(contracts[contracts.length.sub(1)]).transfer(address(this).balance);
1373         if (address(this).balance == 0) {
1374         // pull eth from master address contract if this contract is empty
1375         master.transferEth();
1376         }
1377     }
1378     
1379     // transfer Eth but retain 1 eth (nobody guessed correctly)
1380     function transferEthSeventeenGuesses() public {
1381         require (msg.sender == address(contracts[contracts.length.sub(2)]));
1382         require (address(this).balance >= 1 ether);
1383         address(contracts[contracts.length.sub(1)]).transfer(address(this).balance - 1 ether);
1384         if (address(this).balance == 0) {
1385         // pull eth from master address contract if this contract is empty
1386         master.transferEth();
1387         }
1388     }
1389 }
1390 
1391 ////////////////////////////////////////////////////////////////////////////////
1392 ////////////////////////////////////////////////////////////////////////////////
1393 
1394 
1395 
1396 ////////////////////////////////////////////////////////////////////////////////
1397 // ETH17 - Spawned Game contracts
1398 ////////////////////////////////////////////////////////////////////////////////
1399 
1400 contract Eth17 is usingOraclize {       
1401     using SafeMath for uint256;
1402 
1403     // VARIABLES
1404     
1405     address public thisContractAddress;   
1406     address public admin;
1407     address public masterAddress;
1408     address public factoryAddress;
1409     address public devWallet;
1410     
1411     bool public mutex;
1412     bool public contractHasBeenSpawned;
1413     bool public newGameStarted;
1414     bool public newGameStartedError;
1415     
1416     // 60 minute countdown timer
1417     uint public timeReset = 3600;
1418 
1419     // private number (public for testing)
1420     uint private random;
1421     
1422     bool public guessedCorrectly;
1423     uint public theCorrectNumber;
1424     uint public randomPublic;
1425     bool public randomNumberRetrieved;
1426     bool public gameAbandoned;
1427     
1428     address public lastGuessAddress;
1429     uint public gameEnd;
1430     
1431     // number range
1432     uint public lowValue = 1;
1433     uint public highValue = 1000000;
1434     
1435     uint public nextGuess = 1;
1436     
1437     // cost of guess - expressed in wei
1438     uint public guess1 = 0;
1439     uint public guess2 = 2500000000000000;
1440     uint public guess3 = 5000000000000000;
1441     uint public guess4 = 6000000000000000;
1442     uint public guess5 = 7000000000000000;
1443     uint public guess6 = 8000000000000000;
1444     uint public guess7 = 9000000000000000;
1445     uint public guess8 = 10000000000000000;
1446     uint public guess9 = 20000000000000000;
1447     uint public guess10 = 30000000000000000;
1448     uint public guess11 = 40000000000000000;
1449     uint public guess12 = 50000000000000000;
1450     uint public guess13 = 60000000000000000;
1451     uint public guess14 = 70000000000000000;
1452     uint public guess15 = 80000000000000000;
1453     uint public guess16 = 90000000000000000;
1454     uint public guess17 = 100000000000000000;
1455     
1456     // Note: The maximum amount in the contract can be 1.5875 eth (inc. the seeded 1 eth)
1457     // The 17th guesser automatically gets their eth refunded in the event 
1458     // of an incorrect guess (0.1 eth)
1459     // The Devs claim 0.2875 per game if all guesses are unsuccessful 
1460     // therefore each subsequent game will grow by 0.2 eth
1461     
1462     // MODIFIERS
1463     modifier onlyAdmin { 
1464         require(msg.sender == admin
1465         ); 
1466         _; 
1467     }
1468     
1469     modifier onlyDev { 
1470         require(msg.sender == devWallet
1471         ); 
1472         _; 
1473     }
1474     
1475     modifier onlyContract { 
1476         require(msg.sender == thisContractAddress
1477         ); 
1478         _; 
1479     }
1480     
1481     modifier adminOrLastGuessAddress { 
1482         require(
1483             msg.sender == admin ||
1484             msg.sender == lastGuessAddress
1485         ); 
1486         _; 
1487     }
1488     
1489     modifier adminOrThisContract { 
1490         require(
1491             msg.sender == admin ||
1492             msg.sender == thisContractAddress
1493         ); 
1494         _; 
1495     }
1496     
1497     
1498     // ENUM 
1499     Factory factory;
1500     Master master;
1501     
1502     
1503     constructor() public payable {
1504         admin = msg.sender;
1505         thisContractAddress = address(this);
1506         
1507         ////////////////////////////////////////////////////////////////////////
1508         // REMEMBER TO SET THIS PRIOR TO DEPLOYMENT AS MASTER 
1509         //
1510            masterAddress = 0x2fd1C5Be712511454DbAE356c100f2004F243998;
1511         //
1512         ////////////////////////////////////////////////////////////////////////
1513         
1514         master = Master(masterAddress);
1515         factory = Factory(master.factoryContractAddress());
1516         factoryAddress = factory.thisContractAddress();
1517         devWallet = factory.devWallet();
1518         getRandom();
1519     }
1520     
1521     
1522     // FALLBACK
1523     function () private payable {}
1524     
1525     function thisContractBalance() public view returns(uint) {
1526         return address(this).balance;
1527     }
1528     
1529     function currentRange() public view returns(uint) {
1530         return highValue.sub(lowValue);
1531     }
1532     
1533     function startNewGame() public {
1534         require(!mutex);
1535         require(newGameStarted == false);
1536         mutex = true;
1537         require (nextGuess > 1);
1538         require (nextGuess < 17);
1539         require (guessedCorrectly == false);
1540         require (now > gameEnd);
1541         require (gameEnd > 0);
1542         require (address(this).balance > 0);
1543         require (lastGuessAddress != 0x0);
1544         showRandomNumber();
1545         spawnNewContract();
1546         address(lastGuessAddress).transfer(address(this).balance);
1547         newGameStarted = true;
1548         mutex = false;
1549     }
1550     
1551     function startNewGameError() public {
1552         require(!mutex);
1553         require(newGameStartedError == false);
1554         require(randomNumberRetrieved == false);
1555         require (nextGuess == 1);
1556         mutex = true;
1557         // spawn another new contract because this contract 
1558         // did not contain a random number
1559         spawnNewContractSeventeenGuesses();
1560         newGameStartedError = true;
1561         mutex = false;
1562     }
1563     
1564 
1565     function guessNumber(uint _guess) public payable {
1566         require(randomNumberRetrieved == true);
1567         require(!mutex);
1568         mutex = true;
1569         
1570         // if nobody guesses correctly in 17 guesses
1571         if (nextGuess == 17) {
1572             require (msg.value == costOfNextGuess());
1573             lastGuessAddress = msg.sender;
1574             address(msg.sender).transfer(guess17);              // amount refunded
1575             address(devWallet).transfer(0.2875 ether);
1576             address(admin).transfer(address(this).balance);     // remainder sent to master 
1577             nextGuess ++;
1578             showRandomNumber();
1579             spawnNewContractSeventeenGuesses();
1580             mutex = false;   
1581         }
1582         
1583         // if there have been less than 17 guesses
1584         else if (nextGuess != 17) {
1585             require (random != 0);
1586             require (nextGuess < 18);
1587             require (msg.value == costOfNextGuess());
1588             require (_guess >= lowValue);
1589             require (_guess <= highValue);
1590     
1591                 // if the player guesses correctly!!
1592                 if (_guess == random) {
1593                 require (msg.value == costOfNextGuess());
1594                 guessedCorrectly = true;
1595                 nextGuess ++;
1596                 showRandomNumber();
1597                 spawnNewContract();
1598                 // player wins full amount
1599                 address(msg.sender).transfer(address(this).balance);     
1600                 mutex = false;
1601                 }
1602         
1603                 else if (_guess < random) {
1604                 require (msg.value == costOfNextGuess());
1605                 lowValue = _guess + 1;
1606                 nextGuess ++;
1607                 gameEnd = now.add(timeReset);
1608                 lastGuessAddress = msg.sender;
1609                 mutex = false;
1610                 }
1611         
1612                 else if (_guess > random) {
1613                 require (msg.value == costOfNextGuess());
1614                 highValue = _guess - 1;
1615                 nextGuess ++;
1616                 gameEnd = now.add(timeReset);
1617                 lastGuessAddress = msg.sender;
1618                 mutex = false;
1619                 }
1620         }        
1621         
1622             else revert();
1623     }
1624     
1625  
1626     function costOfNextGuess() public view returns(uint) {
1627         if (nextGuess == 1) { return guess1; }
1628         if (nextGuess == 2) { return guess2; }
1629         if (nextGuess == 3) { return guess3; }
1630         if (nextGuess == 4) { return guess4; }
1631         if (nextGuess == 5) { return guess5; }
1632         if (nextGuess == 6) { return guess6; }
1633         if (nextGuess == 7) { return guess7; }
1634         if (nextGuess == 8) { return guess8; }
1635         if (nextGuess == 9) { return guess9; }
1636         if (nextGuess == 10) { return guess10; }
1637         if (nextGuess == 11) { return guess11; }
1638         if (nextGuess == 12) { return guess12; }
1639         if (nextGuess == 13) { return guess13; }
1640         if (nextGuess == 14) { return guess14; }
1641         if (nextGuess == 15) { return guess15; }
1642         if (nextGuess == 16) { return guess16; }
1643         if (nextGuess == 17) { return guess17; }
1644     }
1645         
1646 
1647 ////////////////////////////////////////////////////////////////////////////////
1648 // Oraclize Query data 
1649 ////////////////////////////////////////////////////////////////////////////////
1650 
1651     event newRandomNumber_bytes(bytes);
1652     event newRandomNumber_uint(uint);
1653     
1654 //
1655     function getRandom() private {
1656         oraclize_setProof(proofType_Ledger); // sets the Ledger authenticity proof in the constructor
1657         // update(); // let's ask for N random bytes immediately when the contract is created!
1658         
1659         uint N = 7; // number of random bytes we want the datasource to return
1660         uint delay = 0; // number of seconds to wait before the execution takes place
1661         uint callbackGas = 200000; // amount of gas we want Oraclize to set for the callback function
1662         bytes32 queryId = oraclize_newRandomDSQuery(delay, N, callbackGas); // this function internally generates the correct oraclize_query and returns its queryId
1663      
1664     }
1665     
1666     // the callback function is called by Oraclize when the result is ready
1667     // the oraclize_randomDS_proofVerify modifier prevents an invalid proof to execute this function code:
1668     // the proof validity is fully verified on-chain
1669     function __callback(bytes32 _queryId, string _result, bytes _proof) 
1670     { 
1671         require (msg.sender == oraclize_cbAddress());
1672         
1673         if (oraclize_randomDS_proofVerify__returnCode(_queryId, _result, _proof) != 0) {
1674             // the proof verification has failed, do we need to take any action here? (depends on the use case)
1675                 gameAbandoned = true; 
1676 
1677         } else {
1678             // the proof verification has passed
1679             // now that we know that the random number was safely generated, let's use it..
1680             
1681             // newRandomNumber_bytes(bytes(_result)); // this is the resulting random number (bytes)
1682             
1683             // for simplicity of use, let's also convert the random bytes to uint if we need
1684             uint maxRange = 1000000; // this is the highest uint we want to get. It should never be greater than 2^(8*N), where N is the number of random bytes we had asked the datasource to return
1685             random = uint(sha3(_result)) % maxRange; // this is an efficient way to get the uint out in the [0, maxRange] range
1686             randomNumberRetrieved = true;
1687 
1688         }
1689 
1690     }
1691     
1692 
1693    function spawnNewContract() public {
1694        require (contractHasBeenSpawned == false);
1695        require (
1696            // up to the 16th guess
1697            nextGuess >= 17 || 
1698             guessedCorrectly == true || 
1699             gameAbandoned == true ||
1700             (now > gameEnd && nextGuess > 1)
1701             );
1702        factory.newSpawn();                  // call master to generate new contract
1703        factory.transferEth();               // transfer eth from master to new contract
1704        contractHasBeenSpawned = true;
1705     }
1706     
1707      
1708     function spawnNewContractSeventeenGuesses() public {
1709        require (contractHasBeenSpawned == false);
1710        require (
1711            nextGuess == 18 || 
1712             guessedCorrectly == true || 
1713             gameAbandoned == true ||
1714             randomNumberRetrieved == false ||
1715             (now > gameEnd && nextGuess > 1)
1716             );
1717        factory.newSpawn();                  // call master to generate new contract
1718        factory.transferEthSeventeenGuesses();               // transfer eth from master to new contract
1719        contractHasBeenSpawned = true;
1720     }
1721    
1722     
1723     function showRandomNumber() public {
1724         require (
1725             // All 17 guesses used
1726             nextGuess == 18 || 
1727             // Somone guessed correctly
1728             guessedCorrectly == true || 
1729             // game finished and at least one guess was made
1730             (now > gameEnd && nextGuess > 1)
1731             ); 
1732         
1733         //expose the private random number
1734         makeRandomPublic();
1735     }
1736     
1737     function makeRandomPublic() private {
1738         // copy the private number to the public uint
1739         randomPublic = random;                  
1740     }
1741     
1742 
1743     
1744 }