1 /*
2  ______   _________  ___   ___   _______    _______             ________  ______      
3 /_____/\ /________/\/__/\ /__/\ /______/\  /______/\           /_______/\/_____/\     
4 \::::_\/_\__.::.__\/\::\ \\  \ \\::::__\/__\::::__\/__         \__.::._\/\:::_ \ \    
5  \:\/___/\  \::\ \   \::\/_\ .\ \\:\ /____/\\:\ /____/\  ___      \::\ \  \:\ \ \ \   
6   \::___\/_  \::\ \   \:: ___::\ \\:\\_  _\/ \:\\_  _\/ /__/\     _\::\ \__\:\ \ \ \  
7    \:\____/\  \::\ \   \: \ \\::\ \\:\_\ \ \  \:\_\ \ \ \::\ \   /__\::\__/\\:\_\ \ \ 
8     \_____\/   \__\/    \__\/ \::\/ \_____\/   \_____\/  \:_\/   \________\/ \_____\/ 
9   ______ _______ _    _    _____  ____   ____  _____     _____          __  __ ______  _____ 
10  |  ____|__   __| |  | |  / ____|/ __ \ / __ \|  __ \   / ____|   /\   |  \/  |  ____|/ ____|
11  | |__     | |  | |__| | | |  __| |  | | |  | | |  | | | |  __   /  \  | \  / | |__  | (___  
12  |  __|    | |  |  __  | | | |_ | |  | | |  | | |  | | | | |_ | / /\ \ | |\/| |  __|  \___ \ 
13  | |____   | |  | |  | | | |__| | |__| | |__| | |__| | | |__| |/ ____ \| |  | | |____ ____) |
14  |______|  |_|  |_|  |_|  \_____|\____/ \____/|_____/   \_____/_/    \_\_|  |_|______|_____/ 
15                                                                                              
16                                                          BY : LmsSky@Gmail.com
17 */                            
18 
19 pragma solidity ^0.4.25;
20 
21 
22 contract safeApi{
23     
24    modifier safe(){
25         address _addr = msg.sender;
26         require (_addr == tx.origin,'Error Action!');
27         uint256 _codeLength;
28         assembly {_codeLength := extcodesize(_addr)}
29         require(_codeLength == 0, "Sender not authorized!");
30             _;
31     }
32 
33 
34     
35  function toBytes(uint256 _num) internal returns (bytes _ret) {
36    assembly {
37         _ret := mload(0x10)
38         mstore(_ret, 0x20)
39         mstore(add(_ret, 0x20), _num)
40     }
41 }
42 
43 function subStr(string _s, uint start, uint end) internal pure returns (string){
44         bytes memory s = bytes(_s);
45         string memory copy = new string(end - start);
46 //        string memory copy = new string(5);
47           uint k = 0;
48         for (uint i = start; i < end; i++){ 
49             bytes(copy)[k++] = bytes(_s)[i];
50         }
51         return copy;
52     }
53      
54 
55  function safePercent(uint256 a,uint256 b) 
56       internal
57       constant
58       returns(uint256)
59       {
60         assert(a>0 && a <=100);
61         return  div(mul(b,a),100);
62       }
63       
64   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
65     uint256 c = a * b;
66     assert(a == 0 || c / a == b);
67     return c;
68   }
69  
70   function div(uint256 a, uint256 b) internal pure returns (uint256) {
71     // assert(b > 0); // Solidity automatically throws when dividing by 0∂
72     uint256 c = a / b;
73     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
74     return c;
75   }
76  
77   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
78     assert(b <= a);
79     return a - b;
80   }
81  
82   function add(uint256 a, uint256 b) internal pure returns (uint256) {
83     uint256 c = a + b;
84     assert(c >= a);
85     return c;
86   }
87 
88 }
89 
90 contract OraclizeI {
91     address public cbAddress;
92     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
93     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
94     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
95     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
96     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
97     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
98     function getPrice(string _datasource) public returns (uint _dsprice);
99     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
100     function setProofType(byte _proofType) external;
101     function setCustomGasPrice(uint _gasPrice) external;
102     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
103 }
104 
105 contract OraclizeAddrResolverI {
106     function getAddress() public returns (address _addr);
107 }
108 
109 /*
110 Begin solidity-cborutils
111 https://github.com/smartcontractkit/solidity-cborutils
112 MIT License
113 Copyright (c) 2018 SmartContract ChainLink, Ltd.
114 Permission is hereby granted, free of charge, to any person obtaining a copy
115 of this software and associated documentation files (the "Software"), to deal
116 in the Software without restriction, including without limitation the rights
117 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
118 copies of the Software, and to permit persons to whom the Software is
119 furnished to do so, subject to the following conditions:
120 The above copyright notice and this permission notice shall be included in all
121 copies or substantial portions of the Software.
122 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
123 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
124 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
125 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
126 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
127 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
128 SOFTWARE.
129  */
130 
131 library Buffer {
132     struct buffer {
133         bytes buf;
134         uint capacity;
135     }
136 
137     function init(buffer memory buf, uint _capacity) internal pure {
138         uint capacity = _capacity;
139         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
140         // Allocate space for the buffer data
141         buf.capacity = capacity;
142         assembly {
143             let ptr := mload(0x40)
144             mstore(buf, ptr)
145             mstore(ptr, 0)
146             mstore(0x40, add(ptr, capacity))
147         }
148     }
149 
150     function resize(buffer memory buf, uint capacity) private pure {
151         bytes memory oldbuf = buf.buf;
152         init(buf, capacity);
153         append(buf, oldbuf);
154     }
155 
156     function max(uint a, uint b) private pure returns(uint) {
157         if(a > b) {
158             return a;
159         }
160         return b;
161     }
162 
163     /**
164      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
165      *      would exceed the capacity of the buffer.
166      * @param buf The buffer to append to.
167      * @param data The data to append.
168      * @return The original buffer.
169      */
170     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
171         if(data.length + buf.buf.length > buf.capacity) {
172             resize(buf, max(buf.capacity, data.length) * 2);
173         }
174 
175         uint dest;
176         uint src;
177         uint len = data.length;
178         assembly {
179             // Memory address of the buffer data
180             let bufptr := mload(buf)
181             // Length of existing buffer data
182             let buflen := mload(bufptr)
183             // Start address = buffer address + buffer length + sizeof(buffer length)
184             dest := add(add(bufptr, buflen), 32)
185             // Update buffer length
186             mstore(bufptr, add(buflen, mload(data)))
187             src := add(data, 32)
188         }
189 
190         // Copy word-length chunks while possible
191         for(; len >= 32; len -= 32) {
192             assembly {
193                 mstore(dest, mload(src))
194             }
195             dest += 32;
196             src += 32;
197         }
198 
199         // Copy remaining bytes
200         uint mask = 256 ** (32 - len) - 1;
201         assembly {
202             let srcpart := and(mload(src), not(mask))
203             let destpart := and(mload(dest), mask)
204             mstore(dest, or(destpart, srcpart))
205         }
206 
207         return buf;
208     }
209 
210     /**
211      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
212      * exceed the capacity of the buffer.
213      * @param buf The buffer to append to.
214      * @param data The data to append.
215      * @return The original buffer.
216      */
217     function append(buffer memory buf, uint8 data) internal pure {
218         if(buf.buf.length + 1 > buf.capacity) {
219             resize(buf, buf.capacity * 2);
220         }
221 
222         assembly {
223             // Memory address of the buffer data
224             let bufptr := mload(buf)
225             // Length of existing buffer data
226             let buflen := mload(bufptr)
227             // Address = buffer address + buffer length + sizeof(buffer length)
228             let dest := add(add(bufptr, buflen), 32)
229             mstore8(dest, data)
230             // Update buffer length
231             mstore(bufptr, add(buflen, 1))
232         }
233     }
234 
235     /**
236      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
237      * exceed the capacity of the buffer.
238      * @param buf The buffer to append to.
239      * @param data The data to append.
240      * @return The original buffer.
241      */
242     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
243         if(len + buf.buf.length > buf.capacity) {
244             resize(buf, max(buf.capacity, len) * 2);
245         }
246 
247         uint mask = 256 ** len - 1;
248         assembly {
249             // Memory address of the buffer data
250             let bufptr := mload(buf)
251             // Length of existing buffer data
252             let buflen := mload(bufptr)
253             // Address = buffer address + buffer length + sizeof(buffer length) + len
254             let dest := add(add(bufptr, buflen), len)
255             mstore(dest, or(and(mload(dest), not(mask)), data))
256             // Update buffer length
257             mstore(bufptr, add(buflen, len))
258         }
259         return buf;
260     }
261 }
262 
263 library CBOR {
264     using Buffer for Buffer.buffer;
265 
266     uint8 private constant MAJOR_TYPE_INT = 0;
267     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
268     uint8 private constant MAJOR_TYPE_BYTES = 2;
269     uint8 private constant MAJOR_TYPE_STRING = 3;
270     uint8 private constant MAJOR_TYPE_ARRAY = 4;
271     uint8 private constant MAJOR_TYPE_MAP = 5;
272     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
273 
274     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
275         if(value <= 23) {
276             buf.append(uint8((major << 5) | value));
277         } else if(value <= 0xFF) {
278             buf.append(uint8((major << 5) | 24));
279             buf.appendInt(value, 1);
280         } else if(value <= 0xFFFF) {
281             buf.append(uint8((major << 5) | 25));
282             buf.appendInt(value, 2);
283         } else if(value <= 0xFFFFFFFF) {
284             buf.append(uint8((major << 5) | 26));
285             buf.appendInt(value, 4);
286         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
287             buf.append(uint8((major << 5) | 27));
288             buf.appendInt(value, 8);
289         }
290     }
291 
292     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
293         buf.append(uint8((major << 5) | 31));
294     }
295 
296     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
297         encodeType(buf, MAJOR_TYPE_INT, value);
298     }
299 
300     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
301         if(value >= 0) {
302             encodeType(buf, MAJOR_TYPE_INT, uint(value));
303         } else {
304             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
305         }
306     }
307 
308     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
309         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
310         buf.append(value);
311     }
312 
313     function encodeString(Buffer.buffer memory buf, string value) internal pure {
314         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
315         buf.append(bytes(value));
316     }
317 
318     function startArray(Buffer.buffer memory buf) internal pure {
319         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
320     }
321 
322     function startMap(Buffer.buffer memory buf) internal pure {
323         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
324     }
325 
326     function endSequence(Buffer.buffer memory buf) internal pure {
327         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
328     }
329 }
330 
331 /*
332 End solidity-cborutils
333  */
334 
335 contract usingOraclize {
336     uint constant day = 60*60*24;
337     uint constant week = 60*60*24*7;
338     uint constant month = 60*60*24*30;
339     byte constant proofType_NONE = 0x00;
340     byte constant proofType_TLSNotary = 0x10;
341     byte constant proofType_Ledger = 0x30;
342     byte constant proofType_Android = 0x40;
343     byte constant proofType_Native = 0xF0;
344     byte constant proofStorage_IPFS = 0x01;
345     uint8 constant networkID_auto = 0;
346     uint8 constant networkID_mainnet = 1;
347     uint8 constant networkID_testnet = 2;
348     uint8 constant networkID_morden = 2;
349     uint8 constant networkID_consensys = 161;
350 
351     OraclizeAddrResolverI OAR;
352 
353     OraclizeI oraclize;
354     modifier oraclizeAPI {
355         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
356             oraclize_setNetwork(networkID_auto);
357 
358         if(address(oraclize) != OAR.getAddress())
359             oraclize = OraclizeI(OAR.getAddress());
360 
361         _;
362     }
363     modifier coupon(string code){
364         oraclize = OraclizeI(OAR.getAddress());
365         _;
366     }
367 
368     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
369       return oraclize_setNetwork();
370       networkID; // silence the warning and remain backwards compatible
371     }
372     function oraclize_setNetwork() internal returns(bool){
373         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
374             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
375             oraclize_setNetworkName("eth_mainnet");
376             return true;
377         }
378         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
379             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
380             oraclize_setNetworkName("eth_ropsten3");
381             return true;
382         }
383         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
384             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
385             oraclize_setNetworkName("eth_kovan");
386             return true;
387         }
388         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
389             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
390             oraclize_setNetworkName("eth_rinkeby");
391             return true;
392         }
393         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
394             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
395             return true;
396         }
397         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
398             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
399             return true;
400         }
401         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
402             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
403             return true;
404         }
405         return false;
406     }
407 
408     function __callback(bytes32 myid, string result) public {
409         __callback(myid, result, new bytes(0));
410     }
411     function __callback(bytes32 myid, string result, bytes proof) public {
412       return;
413       myid; result; proof; // Silence compiler warnings
414     }
415 
416     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
417         return oraclize.getPrice(datasource);
418     }
419 
420     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
421         return oraclize.getPrice(datasource, gaslimit);
422     }
423 
424     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
425         uint price = oraclize.getPrice(datasource);
426         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
427         return oraclize.query.value(price)(0, datasource, arg);
428     }
429     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
430         uint price = oraclize.getPrice(datasource);
431         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
432         return oraclize.query.value(price)(timestamp, datasource, arg);
433     }
434     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
435         uint price = oraclize.getPrice(datasource, gaslimit);
436         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
437         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
438     }
439     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
440         uint price = oraclize.getPrice(datasource, gaslimit);
441         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
442         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
443     }
444     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
445         uint price = oraclize.getPrice(datasource);
446         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
447         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
448     }
449     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
450         uint price = oraclize.getPrice(datasource);
451         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
452         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
453     }
454     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
455         uint price = oraclize.getPrice(datasource, gaslimit);
456         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
457         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
458     }
459     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
460         uint price = oraclize.getPrice(datasource, gaslimit);
461         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
462         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
463     }
464     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
465         uint price = oraclize.getPrice(datasource);
466         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
467         bytes memory args = stra2cbor(argN);
468         return oraclize.queryN.value(price)(0, datasource, args);
469     }
470     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
471         uint price = oraclize.getPrice(datasource);
472         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
473         bytes memory args = stra2cbor(argN);
474         return oraclize.queryN.value(price)(timestamp, datasource, args);
475     }
476     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
477         uint price = oraclize.getPrice(datasource, gaslimit);
478         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
479         bytes memory args = stra2cbor(argN);
480         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
481     }
482     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
483         uint price = oraclize.getPrice(datasource, gaslimit);
484         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
485         bytes memory args = stra2cbor(argN);
486         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
487     }
488     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
489         string[] memory dynargs = new string[](1);
490         dynargs[0] = args[0];
491         return oraclize_query(datasource, dynargs);
492     }
493     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
494         string[] memory dynargs = new string[](1);
495         dynargs[0] = args[0];
496         return oraclize_query(timestamp, datasource, dynargs);
497     }
498     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
499         string[] memory dynargs = new string[](1);
500         dynargs[0] = args[0];
501         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
502     }
503     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
504         string[] memory dynargs = new string[](1);
505         dynargs[0] = args[0];
506         return oraclize_query(datasource, dynargs, gaslimit);
507     }
508 
509     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
510         string[] memory dynargs = new string[](2);
511         dynargs[0] = args[0];
512         dynargs[1] = args[1];
513         return oraclize_query(datasource, dynargs);
514     }
515     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
516         string[] memory dynargs = new string[](2);
517         dynargs[0] = args[0];
518         dynargs[1] = args[1];
519         return oraclize_query(timestamp, datasource, dynargs);
520     }
521     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
522         string[] memory dynargs = new string[](2);
523         dynargs[0] = args[0];
524         dynargs[1] = args[1];
525         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
526     }
527     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
528         string[] memory dynargs = new string[](2);
529         dynargs[0] = args[0];
530         dynargs[1] = args[1];
531         return oraclize_query(datasource, dynargs, gaslimit);
532     }
533     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
534         string[] memory dynargs = new string[](3);
535         dynargs[0] = args[0];
536         dynargs[1] = args[1];
537         dynargs[2] = args[2];
538         return oraclize_query(datasource, dynargs);
539     }
540     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
541         string[] memory dynargs = new string[](3);
542         dynargs[0] = args[0];
543         dynargs[1] = args[1];
544         dynargs[2] = args[2];
545         return oraclize_query(timestamp, datasource, dynargs);
546     }
547     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
548         string[] memory dynargs = new string[](3);
549         dynargs[0] = args[0];
550         dynargs[1] = args[1];
551         dynargs[2] = args[2];
552         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
553     }
554     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
555         string[] memory dynargs = new string[](3);
556         dynargs[0] = args[0];
557         dynargs[1] = args[1];
558         dynargs[2] = args[2];
559         return oraclize_query(datasource, dynargs, gaslimit);
560     }
561 
562     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
563         string[] memory dynargs = new string[](4);
564         dynargs[0] = args[0];
565         dynargs[1] = args[1];
566         dynargs[2] = args[2];
567         dynargs[3] = args[3];
568         return oraclize_query(datasource, dynargs);
569     }
570     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
571         string[] memory dynargs = new string[](4);
572         dynargs[0] = args[0];
573         dynargs[1] = args[1];
574         dynargs[2] = args[2];
575         dynargs[3] = args[3];
576         return oraclize_query(timestamp, datasource, dynargs);
577     }
578     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
579         string[] memory dynargs = new string[](4);
580         dynargs[0] = args[0];
581         dynargs[1] = args[1];
582         dynargs[2] = args[2];
583         dynargs[3] = args[3];
584         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
585     }
586     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
587         string[] memory dynargs = new string[](4);
588         dynargs[0] = args[0];
589         dynargs[1] = args[1];
590         dynargs[2] = args[2];
591         dynargs[3] = args[3];
592         return oraclize_query(datasource, dynargs, gaslimit);
593     }
594     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
595         string[] memory dynargs = new string[](5);
596         dynargs[0] = args[0];
597         dynargs[1] = args[1];
598         dynargs[2] = args[2];
599         dynargs[3] = args[3];
600         dynargs[4] = args[4];
601         return oraclize_query(datasource, dynargs);
602     }
603     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
604         string[] memory dynargs = new string[](5);
605         dynargs[0] = args[0];
606         dynargs[1] = args[1];
607         dynargs[2] = args[2];
608         dynargs[3] = args[3];
609         dynargs[4] = args[4];
610         return oraclize_query(timestamp, datasource, dynargs);
611     }
612     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
613         string[] memory dynargs = new string[](5);
614         dynargs[0] = args[0];
615         dynargs[1] = args[1];
616         dynargs[2] = args[2];
617         dynargs[3] = args[3];
618         dynargs[4] = args[4];
619         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
620     }
621     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
622         string[] memory dynargs = new string[](5);
623         dynargs[0] = args[0];
624         dynargs[1] = args[1];
625         dynargs[2] = args[2];
626         dynargs[3] = args[3];
627         dynargs[4] = args[4];
628         return oraclize_query(datasource, dynargs, gaslimit);
629     }
630     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
631         uint price = oraclize.getPrice(datasource);
632         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
633         bytes memory args = ba2cbor(argN);
634         return oraclize.queryN.value(price)(0, datasource, args);
635     }
636     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
637         uint price = oraclize.getPrice(datasource);
638         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
639         bytes memory args = ba2cbor(argN);
640         return oraclize.queryN.value(price)(timestamp, datasource, args);
641     }
642     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
643         uint price = oraclize.getPrice(datasource, gaslimit);
644         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
645         bytes memory args = ba2cbor(argN);
646         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
647     }
648     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
649         uint price = oraclize.getPrice(datasource, gaslimit);
650         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
651         bytes memory args = ba2cbor(argN);
652         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
653     }
654     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
655         bytes[] memory dynargs = new bytes[](1);
656         dynargs[0] = args[0];
657         return oraclize_query(datasource, dynargs);
658     }
659     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
660         bytes[] memory dynargs = new bytes[](1);
661         dynargs[0] = args[0];
662         return oraclize_query(timestamp, datasource, dynargs);
663     }
664     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
665         bytes[] memory dynargs = new bytes[](1);
666         dynargs[0] = args[0];
667         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
668     }
669     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
670         bytes[] memory dynargs = new bytes[](1);
671         dynargs[0] = args[0];
672         return oraclize_query(datasource, dynargs, gaslimit);
673     }
674 
675     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
676         bytes[] memory dynargs = new bytes[](2);
677         dynargs[0] = args[0];
678         dynargs[1] = args[1];
679         return oraclize_query(datasource, dynargs);
680     }
681     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
682         bytes[] memory dynargs = new bytes[](2);
683         dynargs[0] = args[0];
684         dynargs[1] = args[1];
685         return oraclize_query(timestamp, datasource, dynargs);
686     }
687     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
688         bytes[] memory dynargs = new bytes[](2);
689         dynargs[0] = args[0];
690         dynargs[1] = args[1];
691         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
692     }
693     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
694         bytes[] memory dynargs = new bytes[](2);
695         dynargs[0] = args[0];
696         dynargs[1] = args[1];
697         return oraclize_query(datasource, dynargs, gaslimit);
698     }
699     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
700         bytes[] memory dynargs = new bytes[](3);
701         dynargs[0] = args[0];
702         dynargs[1] = args[1];
703         dynargs[2] = args[2];
704         return oraclize_query(datasource, dynargs);
705     }
706     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
707         bytes[] memory dynargs = new bytes[](3);
708         dynargs[0] = args[0];
709         dynargs[1] = args[1];
710         dynargs[2] = args[2];
711         return oraclize_query(timestamp, datasource, dynargs);
712     }
713     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
714         bytes[] memory dynargs = new bytes[](3);
715         dynargs[0] = args[0];
716         dynargs[1] = args[1];
717         dynargs[2] = args[2];
718         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
719     }
720     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
721         bytes[] memory dynargs = new bytes[](3);
722         dynargs[0] = args[0];
723         dynargs[1] = args[1];
724         dynargs[2] = args[2];
725         return oraclize_query(datasource, dynargs, gaslimit);
726     }
727 
728     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
729         bytes[] memory dynargs = new bytes[](4);
730         dynargs[0] = args[0];
731         dynargs[1] = args[1];
732         dynargs[2] = args[2];
733         dynargs[3] = args[3];
734         return oraclize_query(datasource, dynargs);
735     }
736     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
737         bytes[] memory dynargs = new bytes[](4);
738         dynargs[0] = args[0];
739         dynargs[1] = args[1];
740         dynargs[2] = args[2];
741         dynargs[3] = args[3];
742         return oraclize_query(timestamp, datasource, dynargs);
743     }
744     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
745         bytes[] memory dynargs = new bytes[](4);
746         dynargs[0] = args[0];
747         dynargs[1] = args[1];
748         dynargs[2] = args[2];
749         dynargs[3] = args[3];
750         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
751     }
752     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
753         bytes[] memory dynargs = new bytes[](4);
754         dynargs[0] = args[0];
755         dynargs[1] = args[1];
756         dynargs[2] = args[2];
757         dynargs[3] = args[3];
758         return oraclize_query(datasource, dynargs, gaslimit);
759     }
760     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
761         bytes[] memory dynargs = new bytes[](5);
762         dynargs[0] = args[0];
763         dynargs[1] = args[1];
764         dynargs[2] = args[2];
765         dynargs[3] = args[3];
766         dynargs[4] = args[4];
767         return oraclize_query(datasource, dynargs);
768     }
769     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
770         bytes[] memory dynargs = new bytes[](5);
771         dynargs[0] = args[0];
772         dynargs[1] = args[1];
773         dynargs[2] = args[2];
774         dynargs[3] = args[3];
775         dynargs[4] = args[4];
776         return oraclize_query(timestamp, datasource, dynargs);
777     }
778     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
779         bytes[] memory dynargs = new bytes[](5);
780         dynargs[0] = args[0];
781         dynargs[1] = args[1];
782         dynargs[2] = args[2];
783         dynargs[3] = args[3];
784         dynargs[4] = args[4];
785         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
786     }
787     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
788         bytes[] memory dynargs = new bytes[](5);
789         dynargs[0] = args[0];
790         dynargs[1] = args[1];
791         dynargs[2] = args[2];
792         dynargs[3] = args[3];
793         dynargs[4] = args[4];
794         return oraclize_query(datasource, dynargs, gaslimit);
795     }
796 
797     function oraclize_cbAddress() oraclizeAPI internal returns (address){
798         return oraclize.cbAddress();
799     }
800     function oraclize_setProof(byte proofP) oraclizeAPI internal {
801         return oraclize.setProofType(proofP);
802     }
803     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
804         return oraclize.setCustomGasPrice(gasPrice);
805     }
806 
807     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
808         return oraclize.randomDS_getSessionPubKeyHash();
809     }
810 
811     function getCodeSize(address _addr) constant internal returns(uint _size) {
812         assembly {
813             _size := extcodesize(_addr)
814         }
815     }
816 
817     function parseAddr(string _a) internal pure returns (address){
818         bytes memory tmp = bytes(_a);
819         uint160 iaddr = 0;
820         uint160 b1;
821         uint160 b2;
822         for (uint i=2; i<2+2*20; i+=2){
823             iaddr *= 256;
824             b1 = uint160(tmp[i]);
825             b2 = uint160(tmp[i+1]);
826             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
827             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
828             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
829             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
830             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
831             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
832             iaddr += (b1*16+b2);
833         }
834         return address(iaddr);
835     }
836 
837     function strCompare(string _a, string _b) internal pure returns (int) {
838         bytes memory a = bytes(_a);
839         bytes memory b = bytes(_b);
840         uint minLength = a.length;
841         if (b.length < minLength) minLength = b.length;
842         for (uint i = 0; i < minLength; i ++)
843             if (a[i] < b[i])
844                 return -1;
845             else if (a[i] > b[i])
846                 return 1;
847         if (a.length < b.length)
848             return -1;
849         else if (a.length > b.length)
850             return 1;
851         else
852             return 0;
853     }
854 
855     function indexOf(string _haystack, string _needle) internal pure returns (int) {
856         bytes memory h = bytes(_haystack);
857         bytes memory n = bytes(_needle);
858         if(h.length < 1 || n.length < 1 || (n.length > h.length))
859             return -1;
860         else if(h.length > (2**128 -1))
861             return -1;
862         else
863         {
864             uint subindex = 0;
865             for (uint i = 0; i < h.length; i ++)
866             {
867                 if (h[i] == n[0])
868                 {
869                     subindex = 1;
870                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
871                     {
872                         subindex++;
873                     }
874                     if(subindex == n.length)
875                         return int(i);
876                 }
877             }
878             return -1;
879         }
880     }
881 
882     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
883         bytes memory _ba = bytes(_a);
884         bytes memory _bb = bytes(_b);
885         bytes memory _bc = bytes(_c);
886         bytes memory _bd = bytes(_d);
887         bytes memory _be = bytes(_e);
888         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
889         bytes memory babcde = bytes(abcde);
890         uint k = 0;
891         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
892         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
893         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
894         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
895         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
896         return string(babcde);
897     }
898 
899     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
900         return strConcat(_a, _b, _c, _d, "");
901     }
902 
903     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
904         return strConcat(_a, _b, _c, "", "");
905     }
906 
907     function strConcat(string _a, string _b) internal pure returns (string) {
908         return strConcat(_a, _b, "", "", "");
909     }
910 
911     // parseInt
912     function parseInt(string _a) internal pure returns (uint) {
913         return parseInt(_a, 0);
914     }
915 
916     // parseInt(parseFloat*10^_b)
917     function parseInt(string _a, uint _b) internal pure returns (uint) {
918         bytes memory bresult = bytes(_a);
919         uint mint = 0;
920         bool decimals = false;
921         for (uint i=0; i<bresult.length; i++){
922             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
923                 if (decimals){
924                    if (_b == 0) break;
925                     else _b--;
926                 }
927                 mint *= 10;
928                 mint += uint(bresult[i]) - 48;
929             } else if (bresult[i] == 46) decimals = true;
930         }
931         if (_b > 0) mint *= 10**_b;
932         return mint;
933     }
934 
935     function uint2str(uint i) internal pure returns (string){
936         if (i == 0) return "0";
937         uint j = i;
938         uint len;
939         while (j != 0){
940             len++;
941             j /= 10;
942         }
943         bytes memory bstr = new bytes(len);
944         uint k = len - 1;
945         while (i != 0){
946             bstr[k--] = byte(48 + i % 10);
947             i /= 10;
948         }
949         return string(bstr);
950     }
951 
952     using CBOR for Buffer.buffer;
953     function stra2cbor(string[] arr) internal pure returns (bytes) {
954         safeMemoryCleaner();
955         Buffer.buffer memory buf;
956         Buffer.init(buf, 1024);
957         buf.startArray();
958         for (uint i = 0; i < arr.length; i++) {
959             buf.encodeString(arr[i]);
960         }
961         buf.endSequence();
962         return buf.buf;
963     }
964 
965     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
966         safeMemoryCleaner();
967         Buffer.buffer memory buf;
968         Buffer.init(buf, 1024);
969         buf.startArray();
970         for (uint i = 0; i < arr.length; i++) {
971             buf.encodeBytes(arr[i]);
972         }
973         buf.endSequence();
974         return buf.buf;
975     }
976 
977     string oraclize_network_name;
978     function oraclize_setNetworkName(string _network_name) internal {
979         oraclize_network_name = _network_name;
980     }
981 
982     function oraclize_getNetworkName() internal view returns (string) {
983         return oraclize_network_name;
984     }
985 
986     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
987         require((_nbytes > 0) && (_nbytes <= 32));
988         // Convert from seconds to ledger timer ticks
989         _delay *= 10;
990         bytes memory nbytes = new bytes(1);
991         nbytes[0] = byte(_nbytes);
992         bytes memory unonce = new bytes(32);
993         bytes memory sessionKeyHash = new bytes(32);
994         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
995         assembly {
996             mstore(unonce, 0x20)
997             // the following variables can be relaxed
998             // check relaxed random contract under ethereum-examples repo
999             // for an idea on how to override and replace comit hash vars
1000             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1001             mstore(sessionKeyHash, 0x20)
1002             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1003         }
1004         bytes memory delay = new bytes(32);
1005         assembly {
1006             mstore(add(delay, 0x20), _delay)
1007         }
1008 
1009         bytes memory delay_bytes8 = new bytes(8);
1010         copyBytes(delay, 24, 8, delay_bytes8, 0);
1011 
1012         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1013         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1014 
1015         bytes memory delay_bytes8_left = new bytes(8);
1016 
1017         assembly {
1018             let x := mload(add(delay_bytes8, 0x20))
1019             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1020             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1021             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1022             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1023             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1024             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1025             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1026             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1027 
1028         }
1029 
1030         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1031         return queryId;
1032     }
1033 
1034     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1035         oraclize_randomDS_args[queryId] = commitment;
1036     }
1037 
1038     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1039     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1040 
1041     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1042         bool sigok;
1043         address signer;
1044 
1045         bytes32 sigr;
1046         bytes32 sigs;
1047 
1048         bytes memory sigr_ = new bytes(32);
1049         uint offset = 4+(uint(dersig[3]) - 0x20);
1050         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1051         bytes memory sigs_ = new bytes(32);
1052         offset += 32 + 2;
1053         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1054 
1055         assembly {
1056             sigr := mload(add(sigr_, 32))
1057             sigs := mload(add(sigs_, 32))
1058         }
1059 
1060 
1061         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1062         if (address(keccak256(pubkey)) == signer) return true;
1063         else {
1064             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1065             return (address(keccak256(pubkey)) == signer);
1066         }
1067     }
1068 
1069     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1070         bool sigok;
1071 
1072         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1073         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1074         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1075 
1076         bytes memory appkey1_pubkey = new bytes(64);
1077         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1078 
1079         bytes memory tosign2 = new bytes(1+65+32);
1080         tosign2[0] = byte(1); //role
1081         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1082         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1083         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1084         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1085 
1086         if (sigok == false) return false;
1087 
1088 
1089         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1090         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1091 
1092         bytes memory tosign3 = new bytes(1+65);
1093         tosign3[0] = 0xFE;
1094         copyBytes(proof, 3, 65, tosign3, 1);
1095 
1096         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1097         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1098 
1099         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1100 
1101         return sigok;
1102     }
1103 
1104     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1105         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1106         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1107 
1108         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1109         require(proofVerified);
1110 
1111         _;
1112     }
1113 
1114     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1115         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1116         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1117 
1118         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1119         if (proofVerified == false) return 2;
1120 
1121         return 0;
1122     }
1123 
1124     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1125         bool match_ = true;
1126 
1127         require(prefix.length == n_random_bytes);
1128 
1129         for (uint256 i=0; i< n_random_bytes; i++) {
1130             if (content[i] != prefix[i]) match_ = false;
1131         }
1132 
1133         return match_;
1134     }
1135 
1136     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1137 
1138         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1139         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1140         bytes memory keyhash = new bytes(32);
1141         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1142         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1143 
1144         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1145         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1146 
1147         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1148         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1149 
1150         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1151         // This is to verify that the computed args match with the ones specified in the query.
1152         bytes memory commitmentSlice1 = new bytes(8+1+32);
1153         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1154 
1155         bytes memory sessionPubkey = new bytes(64);
1156         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1157         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1158 
1159         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1160         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1161             delete oraclize_randomDS_args[queryId];
1162         } else return false;
1163 
1164 
1165         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1166         bytes memory tosign1 = new bytes(32+8+1+32);
1167         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1168         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1169 
1170         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1171         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1172             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1173         }
1174 
1175         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1176     }
1177 
1178     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1179     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1180         uint minLength = length + toOffset;
1181 
1182         // Buffer too small
1183         require(to.length >= minLength); // Should be a better way?
1184 
1185         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1186         uint i = 32 + fromOffset;
1187         uint j = 32 + toOffset;
1188 
1189         while (i < (32 + fromOffset + length)) {
1190             assembly {
1191                 let tmp := mload(add(from, i))
1192                 mstore(add(to, j), tmp)
1193             }
1194             i += 32;
1195             j += 32;
1196         }
1197 
1198         return to;
1199     }
1200 
1201     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1202     // Duplicate Solidity's ecrecover, but catching the CALL return value
1203     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1204         // We do our own memory management here. Solidity uses memory offset
1205         // 0x40 to store the current end of memory. We write past it (as
1206         // writes are memory extensions), but don't update the offset so
1207         // Solidity will reuse it. The memory used here is only needed for
1208         // this context.
1209 
1210         // FIXME: inline assembly can't access return values
1211         bool ret;
1212         address addr;
1213 
1214         assembly {
1215             let size := mload(0x40)
1216             mstore(size, hash)
1217             mstore(add(size, 32), v)
1218             mstore(add(size, 64), r)
1219             mstore(add(size, 96), s)
1220 
1221             // NOTE: we can reuse the request memory because we deal with
1222             //       the return code
1223             ret := call(3000, 1, 0, size, 128, size, 32)
1224             addr := mload(size)
1225         }
1226 
1227         return (ret, addr);
1228     }
1229 
1230     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1231     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1232         bytes32 r;
1233         bytes32 s;
1234         uint8 v;
1235 
1236         if (sig.length != 65)
1237           return (false, 0);
1238 
1239         // The signature format is a compact form of:
1240         //   {bytes32 r}{bytes32 s}{uint8 v}
1241         // Compact means, uint8 is not padded to 32 bytes.
1242         assembly {
1243             r := mload(add(sig, 32))
1244             s := mload(add(sig, 64))
1245 
1246             // Here we are loading the last 32 bytes. We exploit the fact that
1247             // 'mload' will pad with zeroes if we overread.
1248             // There is no 'mload8' to do this, but that would be nicer.
1249             v := byte(0, mload(add(sig, 96)))
1250 
1251             // Alternative solution:
1252             // 'byte' is not working due to the Solidity parser, so lets
1253             // use the second best option, 'and'
1254             // v := and(mload(add(sig, 65)), 255)
1255         }
1256 
1257         // albeit non-transactional signatures are not specified by the YP, one would expect it
1258         // to match the YP range of [27, 28]
1259         //
1260         // geth uses [0, 1] and some clients have followed. This might change, see:
1261         //  https://github.com/ethereum/go-ethereum/issues/2053
1262         if (v < 27)
1263           v += 27;
1264 
1265         if (v != 27 && v != 28)
1266             return (false, 0);
1267 
1268         return safer_ecrecover(hash, v, r, s);
1269     }
1270 
1271     function safeMemoryCleaner() internal pure {
1272         assembly {
1273             let fmem := mload(0x40)
1274             codecopy(fmem, codesize, sub(msize, fmem))
1275         }
1276     }
1277 
1278 }
1279 
1280 contract gameLotto is safeApi,usingOraclize{
1281     mapping(bytes32=>bool)  validQueryId;
1282     struct player
1283     {
1284         uint id;
1285         address addr;
1286         uint balance;
1287         uint ticket;
1288         uint affNumLevel_1;
1289         uint affNumLevel_2;
1290         uint timeStamp;
1291         mapping(uint=> playerRecord) index;
1292     }
1293     
1294     struct playerRecord{
1295         mapping(uint=>uint) numberOfTickets;
1296         uint8 betNumbers;
1297         uint32 betTickets;
1298         bool isReceive;
1299     }
1300     
1301     
1302     struct  gameConfig
1303     {
1304         uint unitPrice;
1305         uint singleLimit;
1306         uint ticketNum;
1307         uint lotteryPoolPct;
1308         uint prize_1;
1309         uint prize_2;
1310         uint prize_3;
1311         uint lotteryInterval;
1312         uint level1Rewards;
1313         uint level2Rewards;
1314         uint minBetNum;
1315         uint betMaxNumber;
1316         uint receiveAwardPct;
1317     }
1318     
1319     struct lotteryRecord{
1320         uint index;
1321         uint number;
1322         uint prize2number;
1323         uint prize3number;
1324         uint betOfNumber;
1325         uint prize1Wei;
1326         uint prize2Wei;
1327         uint prize3Wei;
1328         uint time;
1329     }
1330     
1331     struct gameInfo{
1332         uint nextLottery;
1333         uint totalTicket;
1334         uint useTicket;
1335         uint index;
1336         uint prizePool;
1337         mapping (uint => lotteryRecord) lotteryResult;
1338     }
1339     
1340     event Lottery(
1341       uint number,
1342       uint nextLottery,
1343       uint indexed index
1344    );
1345    
1346    event Bet(
1347       address indexed addr,
1348       uint indexed index,
1349       uint number,
1350       uint use
1351    );
1352    
1353     event Buy(
1354        address indexed addr,
1355        uint number,
1356        uint value
1357    );
1358    
1359     mapping (uint => player)  player_;
1360     mapping (address => uint)  playAddr_;
1361     mapping (uint => uint)  playAff_;
1362 
1363     mapping (uint => mapping(uint => uint))  indexNumberTicket_;
1364     mapping (uint => mapping(uint => uint[]))  playIndexBetNumber_;
1365 
1366     
1367      gameConfig  gameConfig_;
1368      gameInfo  gameInfo_;
1369      address  admin__;
1370 
1371      uint  autoPlayId_=123456;
1372      uint constant CUSTOM_GASLIMIT = 250000;
1373 
1374      bool betSwitch=true;
1375     constructor() public {
1376         admin__ = msg.sender;
1377         gameConfig_.unitPrice=0.01 ether;
1378         gameConfig_.singleLimit=1000;//One-time ticket limit
1379         gameConfig_.ticketNum=3;//unitPrice Number of tickets
1380         gameConfig_.lotteryPoolPct=60;//% Draw Prize Pool Use pct
1381         gameConfig_.prize_1=55;//%First prize pct
1382         gameConfig_.prize_2=30;//%Second prize pct
1383         gameConfig_.prize_3=15;//%Third prize pct
1384         gameConfig_.lotteryInterval=86400 seconds;//Draw Interval 1 day
1385         gameConfig_.level1Rewards=4;//%Inviter Level 1
1386         gameConfig_.level2Rewards=1;//%Inviter Level 2
1387         gameConfig_.minBetNum=10;//Minimum number of lottery tickets
1388         gameConfig_.betMaxNumber=20;//The number of bets per person per period
1389         gameConfig_.receiveAwardPct=5;//%
1390         gameInfo_.nextLottery=1542286800;//Next draw time stamp
1391         gameInfo_.index=1;//Lottery Round
1392         getPlayId(admin__);
1393     }
1394    
1395     
1396 function getMyInfo()external view returns(uint,uint,uint,uint,uint,uint){ 
1397           uint _pid=playAddr_[msg.sender];
1398        player memory _p=player_[_pid];
1399        return(
1400             _pid,
1401             _p.balance,
1402             _p.affNumLevel_1,
1403             _p.affNumLevel_2,
1404             _p.timeStamp,
1405             _p.ticket
1406         );
1407   }
1408     
1409     /* Buy lottery tickets */
1410     function buy(uint _number,address level1,address level2)
1411     safe() 
1412     external
1413     payable {
1414         require(msg.value>=gameConfig_.unitPrice,'Please pay the correct eth');
1415         require(_number>0 && _number<=gameConfig_.singleLimit ,'limited single purchase');
1416         uint sendWei= gameConfig_.unitPrice * _number ;
1417         require(msg.value == sendWei ,'Please pay the correct eth!');
1418         uint pid=getPlayId(msg.sender);
1419         addAff(pid,sendWei,level1,level2);//Inviter dividend
1420         addTicket(pid,_number);//Increase lottery
1421         emit Buy(msg.sender,_number,sendWei);
1422     }
1423     
1424   //Can recharge the prize pool ETH
1425   function payment() external payable safe() returns(uint){
1426       if(msg.value>0){
1427       uint pool=gameInfo_.prizePool;
1428       gameInfo_.prizePool=add(pool,msg.value);
1429       }
1430   }
1431   
1432  
1433     /* Lottery bet */
1434     function bet(uint _number,uint16 _use) safe() external{
1435          require(_number >=12 && _number<=9876,'Please enter a correct number (2-4 digits)');
1436          require(_use >=1 && _use<=1000,'Please enter a correct integer (1-1000)');
1437          require(now<gameInfo_.nextLottery,'Please wait for the draw before you can continue to bet');
1438          require(betSwitch==true,'Error Action');
1439           uint pid=playAddr_[msg.sender];
1440           require(pid>0);
1441           player storage _p=player_[pid];
1442           uint _index=gameInfo_.index;
1443           playerRecord  storage _pIndex=_p.index[_index];
1444           require(_p.ticket>=_use,'No tickets available');
1445            _p.ticket-=_use;
1446           if(indexNumberTicket_[_index][_number]==0){
1447               require(_pIndex.betNumbers <= gameConfig_.betMaxNumber,'Limited number of bet numbers');
1448              _pIndex.betNumbers++;
1449           }
1450          _pIndex.betTickets +=_use;
1451          indexNumberTicket_[_index][_number]+=_use;
1452          //The number of times the player purchased this number in this period
1453           _pIndex.numberOfTickets[_number] +=_use;
1454           gameInfo_.lotteryResult[_index].betOfNumber+=_use;
1455          emit  Bet(msg.sender,_index,_number,_use);
1456     }
1457 
1458     function addAff(uint pid,uint sendWei,address level1,address level2) private{
1459         require(sendWei>0);
1460         uint adminId=playAddr_[admin__];
1461         uint level1Pid=playAff_[pid];
1462         uint level2Pid=playAff_[level1Pid];
1463         address myAddr=msg.sender;
1464         uint adminWei=safePercent(10,sendWei);
1465         if(level1Pid==0){
1466                address  _errorAddr=address(0);
1467             if(myAddr == level1 || myAddr ==level2 || level1== _errorAddr || level1==level2){
1468                 playAff_[pid]=adminId;
1469             }else{
1470                level1Pid=getPlayId(level1);
1471                playAff_[pid]=level1Pid;
1472                player_[level1Pid].affNumLevel_1++;
1473                level2Pid=getPlayId(level2);
1474                if(level2Pid>0){
1475                   player_[level2Pid].affNumLevel_2++;
1476                   if( playAff_[level1Pid]==0)
1477                     playAff_[level1Pid]=level2Pid;
1478                }
1479          }
1480       }
1481      if(level1Pid != adminId)
1482         {
1483              uint level1Amount=safePercent(gameConfig_.level1Rewards,sendWei);
1484              player_[level1Pid].balance = add(player_[level1Pid].balance,level1Amount);
1485              adminWei=sub(adminWei,level1Amount);   
1486              if(level2Pid>0){
1487                      uint level2Amount=safePercent(gameConfig_.level2Rewards,sendWei);
1488                     adminWei=sub(adminWei,level2Amount);
1489                     player_[level2Pid].balance=add(player_[level2Pid].balance,level2Amount);
1490               } 
1491         
1492             require(adminWei>0);
1493         }
1494       player_[adminId].balance=add(player_[adminId].balance,adminWei);
1495   }
1496     
1497     
1498     function  addTicket(uint pid,uint _number) private{
1499          require(player_[pid].id > 0);
1500          uint addTicketNum=mul(_number,gameConfig_.ticketNum);
1501          require(addTicketNum > 0);
1502          player_[pid].ticket=add(player_[pid].ticket,addTicketNum);
1503          gameInfo_.prizePool=add(gameInfo_.prizePool,mul(addTicketNum,0.003 ether));//Join the prize pool
1504          gameInfo_.totalTicket=add(gameInfo_.totalTicket,addTicketNum);
1505     }
1506     
1507     
1508     function withdraw(uint pid) safe() external{
1509         require(playAddr_[msg.sender] == pid,'Error Action');
1510         require(player_[pid].addr == msg.sender,'Error Action');
1511         require(player_[pid].balance >0,'Insufficient balance');
1512         uint balance =player_[pid].balance;
1513         player_[pid].balance=0;
1514         return player_[pid].addr.transfer(balance);
1515     }
1516     
1517     function __callback(bytes32 myid, string result) safe() public  {
1518             require (validQueryId[myid] == true);
1519             delete validQueryId[myid];
1520             require(msg.sender == oraclize_cbAddress(),'Error');
1521             require(now > gameInfo_.nextLottery,'Not yet in the draw time');
1522           __lottery(result);
1523     }
1524     
1525     /* The administrator opens the lottery program */
1526     function lottery(uint _days, uint gwei,uint gasLimit) safe() external payable{
1527     
1528      require(msg.sender==admin__,'Only an admin can draw a lottery');
1529      require(now > gameInfo_.nextLottery,'Not yet in the draw time');
1530      require(gameInfo_.lotteryResult[gameInfo_.index].time==0);
1531      if(gameInfo_.lotteryResult[gameInfo_.index].betOfNumber<gameConfig_.minBetNum
1532      || gameInfo_.prizePool<=0
1533      ){
1534              //Extended draw time
1535             gameInfo_.nextLottery=add(gameInfo_.nextLottery,mul(gameConfig_.lotteryInterval,_days));
1536             emit Lottery(0,gameInfo_.nextLottery,gameInfo_.index);
1537             return;
1538      }
1539         uint _gasLimit=gasLimit;//CUSTOM_GASLIMIT;
1540         if(gasLimit==0 || gasLimit>3000000){
1541             _gasLimit=CUSTOM_GASLIMIT;//
1542          }
1543         uint _gwei;
1544        if(gwei==0 || gwei>50){
1545            _gwei=10100000000;//7.1GWEI
1546         }else{
1547            _gwei=mul(1000000000,gwei);
1548         }
1549       oraclize_setCustomGasPrice(_gwei);//Gwei
1550       uint pushPrice=oraclize.getPrice("URL",_gasLimit);
1551       require(address(this).balance>=pushPrice,'Oraclize query was NOT sent, please add some ETH to cover for the query fee');
1552        //Execute the lottery program
1553      bytes32 queryId =
1554         oraclize_query("URL", "html(https://www.random.org/integer-sets/?sets=1&num=4&min=1&max=9&order=random&format=plain&rnd=new).xpath(translate(normalize-space(text()),' ',''))",_gasLimit);
1555         gameInfo_.prizePool=sub(gameInfo_.prizePool,pushPrice);
1556        validQueryId[queryId]=true;
1557        betSwitch=false;//Close Bet
1558     }
1559     
1560    /* Lottery */
1561      function __lottery(string strNumber) private{
1562         
1563            uint  _number=parseInt(strNumber);
1564            require(_number >=1234 && _number<=9876,'Error 11');
1565             
1566             uint _now=now;
1567             uint _index=gameInfo_.index;
1568             require(_now>gameInfo_.lotteryResult[_index-1].time,'Error 12');
1569           gameInfo_.nextLottery=add(gameInfo_.nextLottery,gameConfig_.lotteryInterval);
1570          // gameInfo_.nextLottery=_now + 600;
1571           lotteryRecord memory _gli=gameInfo_.lotteryResult[_index];
1572           _gli.number=_number;
1573           _gli.time=_now;
1574           _gli.index=gameInfo_.index;
1575           gameInfo_.index++;
1576        
1577           updateGameInfo(_number,_index,_gli);
1578           betSwitch=true;//open bet
1579        emit Lottery(_number,gameInfo_.nextLottery,gameInfo_.index);
1580     }
1581     
1582  function updateGameInfo(uint _number,uint index,lotteryRecord _gli) private{
1583         
1584         string memory  strNumber=uint2str(_number);
1585         string memory  secondPrize=subStr(strNumber,1,4);
1586         _gli.prize2number=parseInt(secondPrize);
1587         require(_gli.prize2number>100 && _gli.prize2number<999);
1588         string memory  thirdPrize=subStr(strNumber,2,4);
1589     
1590         _gli.prize3number=parseInt(thirdPrize);
1591         
1592         require( _gli.prize3number>10 &&  _gli.prize3number<99);
1593         //The prize pool of this Index
1594         uint indexPrizePool = safePercent(gameConfig_.lotteryPoolPct,gameInfo_.prizePool);
1595         require(indexPrizePool>0,'ERROR 1');
1596       
1597         uint prize1Pool=safePercent(gameConfig_.prize_1,indexPrizePool);
1598         uint prize2Pool=safePercent(gameConfig_.prize_2,indexPrizePool);
1599         uint prize3Pool=safePercent(gameConfig_.prize_3,indexPrizePool);
1600         
1601         require(add(add(prize1Pool,prize2Pool),prize3Pool)<=indexPrizePool,'ERROR 2');
1602         uint prize1Num=indexNumberTicket_[index][_number];
1603         uint prize2Num=indexNumberTicket_[index][_gli.prize2number];
1604         uint prize3Num=indexNumberTicket_[index][_gli.prize3number];
1605         uint actualCost=0;
1606         if(prize1Num>0){
1607           _gli.prize1Wei=div(prize1Pool,prize1Num);
1608           actualCost = prize1Pool;
1609         }
1610         if(prize2Num>0){
1611          _gli.prize2Wei=div(prize2Pool,prize2Num);
1612          actualCost = add(actualCost,prize2Pool);
1613         }
1614         if(prize3Num>0){
1615           _gli.prize3Wei=div(prize3Pool,prize3Num);
1616           actualCost = add(actualCost,prize3Pool);
1617         }
1618         //Bonus deduction
1619         gameInfo_.prizePool=sub(gameInfo_.prizePool,actualCost);
1620         gameInfo_.lotteryResult[index]=_gli;
1621     }
1622     
1623     function viewAwardInfo(uint _index) safe() external view 
1624     returns(uint,uint,uint,uint,uint,uint,uint,bool){
1625         
1626         uint pid=playAddr_[msg.sender];
1627         require(pid>0,'Error Action 2');
1628          uint index=_index;
1629          uint prize1Num=gameInfo_.lotteryResult[index].number;
1630          uint prize2Num= gameInfo_.lotteryResult[index].prize2number;
1631          uint prize3Num= gameInfo_.lotteryResult[index].prize3number;
1632         
1633         return(
1634               player_[pid].index[index].numberOfTickets[prize1Num],
1635               gameInfo_.lotteryResult[index].prize1Wei,
1636              player_[pid].index[index].numberOfTickets[prize2Num],
1637              gameInfo_.lotteryResult[index].prize2Wei,
1638              player_[pid].index[index].numberOfTickets[prize3Num],
1639              gameInfo_.lotteryResult[index].prize3Wei,
1640              player_[pid].index[index].betTickets,
1641              player_[pid].index[index].isReceive
1642             );
1643     }
1644     
1645         //2020.01.01 Used to update the game
1646    function updateGame() external safe() {
1647         uint time=1577808000;
1648         require(now > time,'Time has not arrived');
1649         require(msg.sender == admin__,'Error');
1650         selfdestruct(admin__);
1651     }
1652     
1653     //Receive your own bonus
1654     function receiveAward(uint index) safe() external{
1655         
1656         uint pid=playAddr_[msg.sender];
1657         require(pid>0,'Error Action 2');
1658         
1659         lotteryRecord storage _gli=gameInfo_.lotteryResult[index];
1660         
1661         require(_gli.time > 0,'Error Action 3');
1662          playerRecord storage _pi=player_[pid].index[index];
1663         require(_pi.isReceive==false,'Error Action 4');
1664         
1665         _pi.isReceive=true;
1666         
1667         
1668         uint prize1Num=_gli.number;
1669         uint sendWei=0;
1670         
1671         if(_pi.numberOfTickets[prize1Num] > 0){
1672             
1673           sendWei = mul(_gli.prize1Wei,_pi.numberOfTickets[prize1Num]);
1674         }
1675         
1676          uint prize2Num= _gli.prize2number;
1677         
1678         if(_pi.numberOfTickets[prize2Num]> 0){
1679             sendWei = add(sendWei,mul(_gli.prize2Wei,_pi.numberOfTickets[prize2Num]));
1680         }
1681         
1682         uint prize3Num= _gli.prize3number;
1683         
1684         if(player_[pid].index[index].numberOfTickets[prize3Num]> 0){
1685              sendWei = add(sendWei,mul(_gli.prize3Wei,_pi.numberOfTickets[prize3Num]));
1686          }
1687             require(sendWei>0,'Error Action 5');
1688             uint adminAmount=safePercent(gameConfig_.receiveAwardPct,sendWei);
1689             sendWei=sub(sendWei,adminAmount);
1690             uint adminId=player_[playAddr_[admin__]].id;
1691             player_[adminId].balance=add(player_[adminId].balance,adminAmount);
1692         player_[pid].addr.transfer(sendWei);
1693     }
1694  
1695     
1696     function getLotteryInfo(uint index)  external view 
1697     returns(uint,uint,uint,uint,uint,uint,uint,uint,uint,uint,uint,uint,uint){
1698               
1699                  uint showIndex=index;
1700               if(index<=0 || index > gameInfo_.index)
1701                  showIndex=gameInfo_.index;
1702                 
1703                 
1704              if(showIndex >1 && gameInfo_.lotteryResult[showIndex].time==0)
1705                 showIndex--;
1706                 
1707         return(
1708                 gameInfo_.index,
1709                 gameInfo_.nextLottery,
1710                 gameInfo_.lotteryResult[showIndex].number,
1711                 gameInfo_.lotteryResult[showIndex].betOfNumber,
1712                 gameInfo_.prizePool,
1713                 0,
1714                 indexNumberTicket_[showIndex][gameInfo_.lotteryResult[showIndex].number],
1715                  gameInfo_.lotteryResult[showIndex].prize1Wei,
1716                 indexNumberTicket_[showIndex][gameInfo_.lotteryResult[showIndex].prize2number],
1717                  gameInfo_.lotteryResult[showIndex].prize2Wei,
1718                  indexNumberTicket_[showIndex][gameInfo_.lotteryResult[showIndex].prize3number],
1719                  gameInfo_.lotteryResult[showIndex].prize3Wei,
1720                  gameInfo_.lotteryResult[showIndex].time
1721             );
1722 }
1723     
1724     function getprizePool() view external returns(uint){
1725         return gameInfo_.prizePool;
1726     }
1727     
1728     function getPlayId(address addr) private returns(uint){
1729         if(address(0) ==addr)
1730             return 0;
1731         if(playAddr_[addr] >0){
1732          return playAddr_[addr];
1733         }
1734               autoPlayId_++;
1735               playAddr_[addr]=autoPlayId_;
1736               player memory _p;
1737               _p.id=autoPlayId_;
1738               _p.addr=addr;
1739               _p.timeStamp=now;
1740               player_[autoPlayId_]=_p;
1741               return autoPlayId_;
1742    }
1743 
1744 }