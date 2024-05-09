1 pragma solidity ^0.4.17;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9     address public owner;
10 
11 
12     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
13 
14 
15     /**
16      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
17      * account.
18      */
19     function Ownable() public {
20         owner = msg.sender;
21     }
22 
23 
24     /**
25      * @dev Throws if called by any account other than the owner.
26      */
27     modifier onlyOwner() {
28         require(msg.sender == owner);
29         _;
30     }
31 
32 
33     /**
34      * @dev Allows the current owner to transfer control of the contract to a newOwner.
35      * @param newOwner The address to transfer ownership to.
36      */
37     function transferOwnership(address newOwner) public onlyOwner {
38         require(newOwner != address(0));
39         OwnershipTransferred(owner, newOwner);
40         owner = newOwner;
41     }
42 }
43 
44 /**
45  * @title SafeMath
46  * @dev Math operations with safety checks that throw on error
47  */
48 contract SafeMath {
49     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
50         uint256 c = a * b;
51         assert(a == 0 || c / a == b);
52         return c;
53     }
54 
55     function div(uint256 a, uint256 b) internal pure returns (uint256) {
56         // assert(b > 0); // Solidity automatically throws when dividing by 0
57         uint256 c = a / b;
58         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
59         return c;
60     }
61 
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         assert(b <= a);
64         return a - b;
65     }
66 
67     function add(uint256 a, uint256 b) internal pure returns (uint256) {
68         uint256 c = a + b;
69         assert(c >= a);
70         return c;
71     }
72 }
73 
74 contract OraclizeI {
75     address public cbAddress;
76     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
77     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
78     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
79     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
80     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
81     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
82     function getPrice(string _datasource) returns (uint _dsprice);
83     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
84     function useCoupon(string _coupon);
85     function setProofType(byte _proofType);
86     function setConfig(bytes32 _config);
87     function setCustomGasPrice(uint _gasPrice);
88     function randomDS_getSessionPubKeyHash() returns(bytes32);
89 }
90 
91 contract OraclizeAddrResolverI {
92     function getAddress() returns (address _addr);
93 }
94 
95 /*
96 Begin solidity-cborutils
97 https://github.com/smartcontractkit/solidity-cborutils
98 MIT License
99 Copyright (c) 2018 SmartContract ChainLink, Ltd.
100 Permission is hereby granted, free of charge, to any person obtaining a copy
101 of this software and associated documentation files (the "Software"), to deal
102 in the Software without restriction, including without limitation the rights
103 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
104 copies of the Software, and to permit persons to whom the Software is
105 furnished to do so, subject to the following conditions:
106 The above copyright notice and this permission notice shall be included in all
107 copies or substantial portions of the Software.
108 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
109 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
110 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
111 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
112 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
113 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
114 SOFTWARE.
115  */
116 
117 library Buffer {
118     struct buffer {
119         bytes buf;
120         uint capacity;
121     }
122 
123     function init(buffer memory buf, uint capacity) internal constant {
124         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
125         // Allocate space for the buffer data
126         buf.capacity = capacity;
127         assembly {
128             let ptr := mload(0x40)
129             mstore(buf, ptr)
130             mstore(0x40, add(ptr, capacity))
131         }
132     }
133 
134     function resize(buffer memory buf, uint capacity) private constant {
135         bytes memory oldbuf = buf.buf;
136         init(buf, capacity);
137         append(buf, oldbuf);
138     }
139 
140     function max(uint a, uint b) private constant returns(uint) {
141         if(a > b) {
142             return a;
143         }
144         return b;
145     }
146 
147     /**
148      * @dev Appends a byte array to the end of the buffer. Reverts if doing so
149      *      would exceed the capacity of the buffer.
150      * @param buf The buffer to append to.
151      * @param data The data to append.
152      * @return The original buffer.
153      */
154     function append(buffer memory buf, bytes data) internal constant returns(buffer memory) {
155         if(data.length + buf.buf.length > buf.capacity) {
156             resize(buf, max(buf.capacity, data.length) * 2);
157         }
158 
159         uint dest;
160         uint src;
161         uint len = data.length;
162         assembly {
163         // Memory address of the buffer data
164             let bufptr := mload(buf)
165         // Length of existing buffer data
166             let buflen := mload(bufptr)
167         // Start address = buffer address + buffer length + sizeof(buffer length)
168             dest := add(add(bufptr, buflen), 32)
169         // Update buffer length
170             mstore(bufptr, add(buflen, mload(data)))
171             src := add(data, 32)
172         }
173 
174         // Copy word-length chunks while possible
175         for(; len >= 32; len -= 32) {
176             assembly {
177                 mstore(dest, mload(src))
178             }
179             dest += 32;
180             src += 32;
181         }
182 
183         // Copy remaining bytes
184         uint mask = 256 ** (32 - len) - 1;
185         assembly {
186             let srcpart := and(mload(src), not(mask))
187             let destpart := and(mload(dest), mask)
188             mstore(dest, or(destpart, srcpart))
189         }
190 
191         return buf;
192     }
193 
194     /**
195      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
196      * exceed the capacity of the buffer.
197      * @param buf The buffer to append to.
198      * @param data The data to append.
199      * @return The original buffer.
200      */
201     function append(buffer memory buf, uint8 data) internal constant {
202         if(buf.buf.length + 1 > buf.capacity) {
203             resize(buf, buf.capacity * 2);
204         }
205 
206         assembly {
207         // Memory address of the buffer data
208             let bufptr := mload(buf)
209         // Length of existing buffer data
210             let buflen := mload(bufptr)
211         // Address = buffer address + buffer length + sizeof(buffer length)
212             let dest := add(add(bufptr, buflen), 32)
213             mstore8(dest, data)
214         // Update buffer length
215             mstore(bufptr, add(buflen, 1))
216         }
217     }
218 
219     /**
220      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
221      * exceed the capacity of the buffer.
222      * @param buf The buffer to append to.
223      * @param data The data to append.
224      * @return The original buffer.
225      */
226     function appendInt(buffer memory buf, uint data, uint len) internal constant returns(buffer memory) {
227         if(len + buf.buf.length > buf.capacity) {
228             resize(buf, max(buf.capacity, len) * 2);
229         }
230 
231         uint mask = 256 ** len - 1;
232         assembly {
233         // Memory address of the buffer data
234             let bufptr := mload(buf)
235         // Length of existing buffer data
236             let buflen := mload(bufptr)
237         // Address = buffer address + buffer length + sizeof(buffer length) + len
238             let dest := add(add(bufptr, buflen), len)
239             mstore(dest, or(and(mload(dest), not(mask)), data))
240         // Update buffer length
241             mstore(bufptr, add(buflen, len))
242         }
243         return buf;
244     }
245 }
246 
247 library CBOR {
248     using Buffer for Buffer.buffer;
249 
250     uint8 private constant MAJOR_TYPE_INT = 0;
251     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
252     uint8 private constant MAJOR_TYPE_BYTES = 2;
253     uint8 private constant MAJOR_TYPE_STRING = 3;
254     uint8 private constant MAJOR_TYPE_ARRAY = 4;
255     uint8 private constant MAJOR_TYPE_MAP = 5;
256     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
257 
258     function shl8(uint8 x, uint8 y) private constant returns (uint8) {
259         return x * (2 ** y);
260     }
261 
262     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private constant {
263         if(value <= 23) {
264             buf.append(uint8(shl8(major, 5) | value));
265         } else if(value <= 0xFF) {
266             buf.append(uint8(shl8(major, 5) | 24));
267             buf.appendInt(value, 1);
268         } else if(value <= 0xFFFF) {
269             buf.append(uint8(shl8(major, 5) | 25));
270             buf.appendInt(value, 2);
271         } else if(value <= 0xFFFFFFFF) {
272             buf.append(uint8(shl8(major, 5) | 26));
273             buf.appendInt(value, 4);
274         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
275             buf.append(uint8(shl8(major, 5) | 27));
276             buf.appendInt(value, 8);
277         }
278     }
279 
280     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private constant {
281         buf.append(uint8(shl8(major, 5) | 31));
282     }
283 
284     function encodeUInt(Buffer.buffer memory buf, uint value) internal constant {
285         encodeType(buf, MAJOR_TYPE_INT, value);
286     }
287 
288     function encodeInt(Buffer.buffer memory buf, int value) internal constant {
289         if(value >= 0) {
290             encodeType(buf, MAJOR_TYPE_INT, uint(value));
291         } else {
292             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
293         }
294     }
295 
296     function encodeBytes(Buffer.buffer memory buf, bytes value) internal constant {
297         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
298         buf.append(value);
299     }
300 
301     function encodeString(Buffer.buffer memory buf, string value) internal constant {
302         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
303         buf.append(bytes(value));
304     }
305 
306     function startArray(Buffer.buffer memory buf) internal constant {
307         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
308     }
309 
310     function startMap(Buffer.buffer memory buf) internal constant {
311         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
312     }
313 
314     function endSequence(Buffer.buffer memory buf) internal constant {
315         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
316     }
317 }
318 
319 /*
320 End solidity-cborutils
321  */
322 
323 contract usingOraclize {
324     uint constant day = 60*60*24;
325     uint constant week = 60*60*24*7;
326     uint constant month = 60*60*24*30;
327     byte constant proofType_NONE = 0x00;
328     byte constant proofType_TLSNotary = 0x10;
329     byte constant proofType_Android = 0x20;
330     byte constant proofType_Ledger = 0x30;
331     byte constant proofType_Native = 0xF0;
332     byte constant proofStorage_IPFS = 0x01;
333     uint8 constant networkID_auto = 0;
334     uint8 constant networkID_mainnet = 1;
335     uint8 constant networkID_testnet = 2;
336     uint8 constant networkID_morden = 2;
337     uint8 constant networkID_consensys = 161;
338 
339     OraclizeAddrResolverI OAR;
340 
341     OraclizeI oraclize;
342     modifier oraclizeAPI {
343         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
344             oraclize_setNetwork(networkID_auto);
345 
346         if(address(oraclize) != OAR.getAddress())
347             oraclize = OraclizeI(OAR.getAddress());
348 
349         _;
350     }
351     modifier coupon(string code){
352         oraclize = OraclizeI(OAR.getAddress());
353         oraclize.useCoupon(code);
354         _;
355     }
356 
357     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
358         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
359             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
360             oraclize_setNetworkName("eth_mainnet");
361             return true;
362         }
363         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
364             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
365             oraclize_setNetworkName("eth_ropsten3");
366             return true;
367         }
368         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
369             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
370             oraclize_setNetworkName("eth_kovan");
371             return true;
372         }
373         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
374             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
375             oraclize_setNetworkName("eth_rinkeby");
376             return true;
377         }
378         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
379             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
380             return true;
381         }
382         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
383             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
384             return true;
385         }
386         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
387             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
388             return true;
389         }
390         return false;
391     }
392 
393     function __callback(bytes32 myid, string result) {
394         __callback(myid, result, new bytes(0));
395     }
396     function __callback(bytes32 myid, string result, bytes proof) {
397     }
398 
399     function oraclize_useCoupon(string code) oraclizeAPI internal {
400         oraclize.useCoupon(code);
401     }
402 
403     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
404         return oraclize.getPrice(datasource);
405     }
406 
407     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
408         return oraclize.getPrice(datasource, gaslimit);
409     }
410 
411     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
412         uint price = oraclize.getPrice(datasource);
413         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
414         return oraclize.query.value(price)(0, datasource, arg);
415     }
416     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
417         uint price = oraclize.getPrice(datasource);
418         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
419         return oraclize.query.value(price)(timestamp, datasource, arg);
420     }
421     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
422         uint price = oraclize.getPrice(datasource, gaslimit);
423         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
424         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
425     }
426     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
427         uint price = oraclize.getPrice(datasource, gaslimit);
428         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
429         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
430     }
431     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
432         uint price = oraclize.getPrice(datasource);
433         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
434         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
435     }
436     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
437         uint price = oraclize.getPrice(datasource);
438         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
439         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
440     }
441     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
442         uint price = oraclize.getPrice(datasource, gaslimit);
443         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
444         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
445     }
446     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
447         uint price = oraclize.getPrice(datasource, gaslimit);
448         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
449         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
450     }
451     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
452         uint price = oraclize.getPrice(datasource);
453         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
454         bytes memory args = stra2cbor(argN);
455         return oraclize.queryN.value(price)(0, datasource, args);
456     }
457     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
458         uint price = oraclize.getPrice(datasource);
459         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
460         bytes memory args = stra2cbor(argN);
461         return oraclize.queryN.value(price)(timestamp, datasource, args);
462     }
463     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
464         uint price = oraclize.getPrice(datasource, gaslimit);
465         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
466         bytes memory args = stra2cbor(argN);
467         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
468     }
469     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
470         uint price = oraclize.getPrice(datasource, gaslimit);
471         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
472         bytes memory args = stra2cbor(argN);
473         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
474     }
475     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
476         string[] memory dynargs = new string[](1);
477         dynargs[0] = args[0];
478         return oraclize_query(datasource, dynargs);
479     }
480     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
481         string[] memory dynargs = new string[](1);
482         dynargs[0] = args[0];
483         return oraclize_query(timestamp, datasource, dynargs);
484     }
485     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
486         string[] memory dynargs = new string[](1);
487         dynargs[0] = args[0];
488         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
489     }
490     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
491         string[] memory dynargs = new string[](1);
492         dynargs[0] = args[0];
493         return oraclize_query(datasource, dynargs, gaslimit);
494     }
495 
496     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
497         string[] memory dynargs = new string[](2);
498         dynargs[0] = args[0];
499         dynargs[1] = args[1];
500         return oraclize_query(datasource, dynargs);
501     }
502     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
503         string[] memory dynargs = new string[](2);
504         dynargs[0] = args[0];
505         dynargs[1] = args[1];
506         return oraclize_query(timestamp, datasource, dynargs);
507     }
508     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
509         string[] memory dynargs = new string[](2);
510         dynargs[0] = args[0];
511         dynargs[1] = args[1];
512         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
513     }
514     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
515         string[] memory dynargs = new string[](2);
516         dynargs[0] = args[0];
517         dynargs[1] = args[1];
518         return oraclize_query(datasource, dynargs, gaslimit);
519     }
520     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
521         string[] memory dynargs = new string[](3);
522         dynargs[0] = args[0];
523         dynargs[1] = args[1];
524         dynargs[2] = args[2];
525         return oraclize_query(datasource, dynargs);
526     }
527     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
528         string[] memory dynargs = new string[](3);
529         dynargs[0] = args[0];
530         dynargs[1] = args[1];
531         dynargs[2] = args[2];
532         return oraclize_query(timestamp, datasource, dynargs);
533     }
534     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
535         string[] memory dynargs = new string[](3);
536         dynargs[0] = args[0];
537         dynargs[1] = args[1];
538         dynargs[2] = args[2];
539         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
540     }
541     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
542         string[] memory dynargs = new string[](3);
543         dynargs[0] = args[0];
544         dynargs[1] = args[1];
545         dynargs[2] = args[2];
546         return oraclize_query(datasource, dynargs, gaslimit);
547     }
548 
549     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
550         string[] memory dynargs = new string[](4);
551         dynargs[0] = args[0];
552         dynargs[1] = args[1];
553         dynargs[2] = args[2];
554         dynargs[3] = args[3];
555         return oraclize_query(datasource, dynargs);
556     }
557     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
558         string[] memory dynargs = new string[](4);
559         dynargs[0] = args[0];
560         dynargs[1] = args[1];
561         dynargs[2] = args[2];
562         dynargs[3] = args[3];
563         return oraclize_query(timestamp, datasource, dynargs);
564     }
565     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
566         string[] memory dynargs = new string[](4);
567         dynargs[0] = args[0];
568         dynargs[1] = args[1];
569         dynargs[2] = args[2];
570         dynargs[3] = args[3];
571         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
572     }
573     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
574         string[] memory dynargs = new string[](4);
575         dynargs[0] = args[0];
576         dynargs[1] = args[1];
577         dynargs[2] = args[2];
578         dynargs[3] = args[3];
579         return oraclize_query(datasource, dynargs, gaslimit);
580     }
581     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
582         string[] memory dynargs = new string[](5);
583         dynargs[0] = args[0];
584         dynargs[1] = args[1];
585         dynargs[2] = args[2];
586         dynargs[3] = args[3];
587         dynargs[4] = args[4];
588         return oraclize_query(datasource, dynargs);
589     }
590     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
591         string[] memory dynargs = new string[](5);
592         dynargs[0] = args[0];
593         dynargs[1] = args[1];
594         dynargs[2] = args[2];
595         dynargs[3] = args[3];
596         dynargs[4] = args[4];
597         return oraclize_query(timestamp, datasource, dynargs);
598     }
599     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
600         string[] memory dynargs = new string[](5);
601         dynargs[0] = args[0];
602         dynargs[1] = args[1];
603         dynargs[2] = args[2];
604         dynargs[3] = args[3];
605         dynargs[4] = args[4];
606         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
607     }
608     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
609         string[] memory dynargs = new string[](5);
610         dynargs[0] = args[0];
611         dynargs[1] = args[1];
612         dynargs[2] = args[2];
613         dynargs[3] = args[3];
614         dynargs[4] = args[4];
615         return oraclize_query(datasource, dynargs, gaslimit);
616     }
617     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
618         uint price = oraclize.getPrice(datasource);
619         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
620         bytes memory args = ba2cbor(argN);
621         return oraclize.queryN.value(price)(0, datasource, args);
622     }
623     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
624         uint price = oraclize.getPrice(datasource);
625         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
626         bytes memory args = ba2cbor(argN);
627         return oraclize.queryN.value(price)(timestamp, datasource, args);
628     }
629     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
630         uint price = oraclize.getPrice(datasource, gaslimit);
631         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
632         bytes memory args = ba2cbor(argN);
633         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
634     }
635     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
636         uint price = oraclize.getPrice(datasource, gaslimit);
637         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
638         bytes memory args = ba2cbor(argN);
639         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
640     }
641     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
642         bytes[] memory dynargs = new bytes[](1);
643         dynargs[0] = args[0];
644         return oraclize_query(datasource, dynargs);
645     }
646     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
647         bytes[] memory dynargs = new bytes[](1);
648         dynargs[0] = args[0];
649         return oraclize_query(timestamp, datasource, dynargs);
650     }
651     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
652         bytes[] memory dynargs = new bytes[](1);
653         dynargs[0] = args[0];
654         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
655     }
656     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
657         bytes[] memory dynargs = new bytes[](1);
658         dynargs[0] = args[0];
659         return oraclize_query(datasource, dynargs, gaslimit);
660     }
661 
662     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
663         bytes[] memory dynargs = new bytes[](2);
664         dynargs[0] = args[0];
665         dynargs[1] = args[1];
666         return oraclize_query(datasource, dynargs);
667     }
668     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
669         bytes[] memory dynargs = new bytes[](2);
670         dynargs[0] = args[0];
671         dynargs[1] = args[1];
672         return oraclize_query(timestamp, datasource, dynargs);
673     }
674     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
675         bytes[] memory dynargs = new bytes[](2);
676         dynargs[0] = args[0];
677         dynargs[1] = args[1];
678         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
679     }
680     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
681         bytes[] memory dynargs = new bytes[](2);
682         dynargs[0] = args[0];
683         dynargs[1] = args[1];
684         return oraclize_query(datasource, dynargs, gaslimit);
685     }
686     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
687         bytes[] memory dynargs = new bytes[](3);
688         dynargs[0] = args[0];
689         dynargs[1] = args[1];
690         dynargs[2] = args[2];
691         return oraclize_query(datasource, dynargs);
692     }
693     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
694         bytes[] memory dynargs = new bytes[](3);
695         dynargs[0] = args[0];
696         dynargs[1] = args[1];
697         dynargs[2] = args[2];
698         return oraclize_query(timestamp, datasource, dynargs);
699     }
700     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
701         bytes[] memory dynargs = new bytes[](3);
702         dynargs[0] = args[0];
703         dynargs[1] = args[1];
704         dynargs[2] = args[2];
705         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
706     }
707     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
708         bytes[] memory dynargs = new bytes[](3);
709         dynargs[0] = args[0];
710         dynargs[1] = args[1];
711         dynargs[2] = args[2];
712         return oraclize_query(datasource, dynargs, gaslimit);
713     }
714 
715     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
716         bytes[] memory dynargs = new bytes[](4);
717         dynargs[0] = args[0];
718         dynargs[1] = args[1];
719         dynargs[2] = args[2];
720         dynargs[3] = args[3];
721         return oraclize_query(datasource, dynargs);
722     }
723     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
724         bytes[] memory dynargs = new bytes[](4);
725         dynargs[0] = args[0];
726         dynargs[1] = args[1];
727         dynargs[2] = args[2];
728         dynargs[3] = args[3];
729         return oraclize_query(timestamp, datasource, dynargs);
730     }
731     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
732         bytes[] memory dynargs = new bytes[](4);
733         dynargs[0] = args[0];
734         dynargs[1] = args[1];
735         dynargs[2] = args[2];
736         dynargs[3] = args[3];
737         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
738     }
739     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
740         bytes[] memory dynargs = new bytes[](4);
741         dynargs[0] = args[0];
742         dynargs[1] = args[1];
743         dynargs[2] = args[2];
744         dynargs[3] = args[3];
745         return oraclize_query(datasource, dynargs, gaslimit);
746     }
747     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
748         bytes[] memory dynargs = new bytes[](5);
749         dynargs[0] = args[0];
750         dynargs[1] = args[1];
751         dynargs[2] = args[2];
752         dynargs[3] = args[3];
753         dynargs[4] = args[4];
754         return oraclize_query(datasource, dynargs);
755     }
756     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
757         bytes[] memory dynargs = new bytes[](5);
758         dynargs[0] = args[0];
759         dynargs[1] = args[1];
760         dynargs[2] = args[2];
761         dynargs[3] = args[3];
762         dynargs[4] = args[4];
763         return oraclize_query(timestamp, datasource, dynargs);
764     }
765     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
766         bytes[] memory dynargs = new bytes[](5);
767         dynargs[0] = args[0];
768         dynargs[1] = args[1];
769         dynargs[2] = args[2];
770         dynargs[3] = args[3];
771         dynargs[4] = args[4];
772         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
773     }
774     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
775         bytes[] memory dynargs = new bytes[](5);
776         dynargs[0] = args[0];
777         dynargs[1] = args[1];
778         dynargs[2] = args[2];
779         dynargs[3] = args[3];
780         dynargs[4] = args[4];
781         return oraclize_query(datasource, dynargs, gaslimit);
782     }
783 
784     function oraclize_cbAddress() oraclizeAPI internal returns (address){
785         return oraclize.cbAddress();
786     }
787     function oraclize_setProof(byte proofP) oraclizeAPI internal {
788         return oraclize.setProofType(proofP);
789     }
790     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
791         return oraclize.setCustomGasPrice(gasPrice);
792     }
793     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
794         return oraclize.setConfig(config);
795     }
796 
797     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
798         return oraclize.randomDS_getSessionPubKeyHash();
799     }
800 
801     function getCodeSize(address _addr) constant internal returns(uint _size) {
802         assembly {
803             _size := extcodesize(_addr)
804         }
805     }
806 
807     function parseAddr(string _a) internal returns (address){
808         bytes memory tmp = bytes(_a);
809         uint160 iaddr = 0;
810         uint160 b1;
811         uint160 b2;
812         for (uint i=2; i<2+2*20; i+=2){
813             iaddr *= 256;
814             b1 = uint160(tmp[i]);
815             b2 = uint160(tmp[i+1]);
816             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
817             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
818             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
819             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
820             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
821             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
822             iaddr += (b1*16+b2);
823         }
824         return address(iaddr);
825     }
826 
827     function strCompare(string _a, string _b) internal returns (int) {
828         bytes memory a = bytes(_a);
829         bytes memory b = bytes(_b);
830         uint minLength = a.length;
831         if (b.length < minLength) minLength = b.length;
832         for (uint i = 0; i < minLength; i ++)
833             if (a[i] < b[i])
834                 return -1;
835             else if (a[i] > b[i])
836                 return 1;
837         if (a.length < b.length)
838             return -1;
839         else if (a.length > b.length)
840             return 1;
841         else
842             return 0;
843     }
844 
845     function indexOf(string _haystack, string _needle) internal returns (int) {
846         bytes memory h = bytes(_haystack);
847         bytes memory n = bytes(_needle);
848         if(h.length < 1 || n.length < 1 || (n.length > h.length))
849             return -1;
850         else if(h.length > (2**128 -1))
851             return -1;
852         else
853         {
854             uint subindex = 0;
855             for (uint i = 0; i < h.length; i ++)
856             {
857                 if (h[i] == n[0])
858                 {
859                     subindex = 1;
860                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
861                     {
862                         subindex++;
863                     }
864                     if(subindex == n.length)
865                         return int(i);
866                 }
867             }
868             return -1;
869         }
870     }
871 
872     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
873         bytes memory _ba = bytes(_a);
874         bytes memory _bb = bytes(_b);
875         bytes memory _bc = bytes(_c);
876         bytes memory _bd = bytes(_d);
877         bytes memory _be = bytes(_e);
878         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
879         bytes memory babcde = bytes(abcde);
880         uint k = 0;
881         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
882         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
883         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
884         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
885         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
886         return string(babcde);
887     }
888 
889     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
890         return strConcat(_a, _b, _c, _d, "");
891     }
892 
893     function strConcat(string _a, string _b, string _c) internal returns (string) {
894         return strConcat(_a, _b, _c, "", "");
895     }
896 
897     function strConcat(string _a, string _b) internal returns (string) {
898         return strConcat(_a, _b, "", "", "");
899     }
900 
901     // parseInt
902     function parseInt(string _a) internal returns (uint) {
903         return parseInt(_a, 0);
904     }
905 
906     // parseInt(parseFloat*10^_b)
907     function parseInt(string _a, uint _b) internal returns (uint) {
908         bytes memory bresult = bytes(_a);
909         uint mint = 0;
910         bool decimals = false;
911         for (uint i=0; i<bresult.length; i++){
912             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
913                 if (decimals){
914                     if (_b == 0) break;
915                     else _b--;
916                 }
917                 mint *= 10;
918                 mint += uint(bresult[i]) - 48;
919             } else if (bresult[i] == 46) decimals = true;
920         }
921         if (_b > 0) mint *= 10**_b;
922         return mint;
923     }
924 
925     function uint2str(uint i) internal returns (string){
926         if (i == 0) return "0";
927         uint j = i;
928         uint len;
929         while (j != 0){
930             len++;
931             j /= 10;
932         }
933         bytes memory bstr = new bytes(len);
934         uint k = len - 1;
935         while (i != 0){
936             bstr[k--] = byte(48 + i % 10);
937             i /= 10;
938         }
939         return string(bstr);
940     }
941 
942     using CBOR for Buffer.buffer;
943     function stra2cbor(string[] arr) internal constant returns (bytes) {
944         Buffer.buffer memory buf;
945         Buffer.init(buf, 1024);
946         buf.startArray();
947         for (uint i = 0; i < arr.length; i++) {
948             buf.encodeString(arr[i]);
949         }
950         buf.endSequence();
951         return buf.buf;
952     }
953 
954     function ba2cbor(bytes[] arr) internal constant returns (bytes) {
955         Buffer.buffer memory buf;
956         Buffer.init(buf, 1024);
957         buf.startArray();
958         for (uint i = 0; i < arr.length; i++) {
959             buf.encodeBytes(arr[i]);
960         }
961         buf.endSequence();
962         return buf.buf;
963     }
964 
965     string oraclize_network_name;
966     function oraclize_setNetworkName(string _network_name) internal {
967         oraclize_network_name = _network_name;
968     }
969 
970     function oraclize_getNetworkName() internal returns (string) {
971         return oraclize_network_name;
972     }
973 
974     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
975         if ((_nbytes == 0)||(_nbytes > 32)) throw;
976         // Convert from seconds to ledger timer ticks
977         _delay *= 10;
978         bytes memory nbytes = new bytes(1);
979         nbytes[0] = byte(_nbytes);
980         bytes memory unonce = new bytes(32);
981         bytes memory sessionKeyHash = new bytes(32);
982         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
983         assembly {
984             mstore(unonce, 0x20)
985         // the following variables can be relaxed
986         // check relaxed random contract under ethereum-examples repo
987         // for an idea on how to override and replace comit hash vars
988             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
989             mstore(sessionKeyHash, 0x20)
990             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
991         }
992         bytes memory delay = new bytes(32);
993         assembly {
994             mstore(add(delay, 0x20), _delay)
995         }
996 
997         bytes memory delay_bytes8 = new bytes(8);
998         copyBytes(delay, 24, 8, delay_bytes8, 0);
999 
1000         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1001         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1002 
1003         bytes memory delay_bytes8_left = new bytes(8);
1004 
1005         assembly {
1006             let x := mload(add(delay_bytes8, 0x20))
1007             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1008             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1009             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1010             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1011             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1012             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1013             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1014             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1015 
1016         }
1017 
1018         oraclize_randomDS_setCommitment(queryId, sha3(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1019         return queryId;
1020     }
1021 
1022     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1023         oraclize_randomDS_args[queryId] = commitment;
1024     }
1025 
1026     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1027     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1028 
1029     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1030         bool sigok;
1031         address signer;
1032 
1033         bytes32 sigr;
1034         bytes32 sigs;
1035 
1036         bytes memory sigr_ = new bytes(32);
1037         uint offset = 4+(uint(dersig[3]) - 0x20);
1038         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1039         bytes memory sigs_ = new bytes(32);
1040         offset += 32 + 2;
1041         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1042 
1043         assembly {
1044             sigr := mload(add(sigr_, 32))
1045             sigs := mload(add(sigs_, 32))
1046         }
1047 
1048 
1049         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1050         if (address(sha3(pubkey)) == signer) return true;
1051         else {
1052             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1053             return (address(sha3(pubkey)) == signer);
1054         }
1055     }
1056 
1057     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1058         bool sigok;
1059 
1060         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1061         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1062         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1063 
1064         bytes memory appkey1_pubkey = new bytes(64);
1065         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1066 
1067         bytes memory tosign2 = new bytes(1+65+32);
1068         tosign2[0] = 1; //role
1069         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1070         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1071         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1072         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1073 
1074         if (sigok == false) return false;
1075 
1076 
1077         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1078         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1079 
1080         bytes memory tosign3 = new bytes(1+65);
1081         tosign3[0] = 0xFE;
1082         copyBytes(proof, 3, 65, tosign3, 1);
1083 
1084         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1085         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1086 
1087         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1088 
1089         return sigok;
1090     }
1091 
1092     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1093         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1094         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
1095 
1096         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1097         if (proofVerified == false) throw;
1098 
1099         _;
1100     }
1101 
1102     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1103         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1104         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1105 
1106         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1107         if (proofVerified == false) return 2;
1108 
1109         return 0;
1110     }
1111 
1112     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
1113         bool match_ = true;
1114 
1115         if (prefix.length != n_random_bytes) throw;
1116 
1117         for (uint256 i=0; i< n_random_bytes; i++) {
1118             if (content[i] != prefix[i]) match_ = false;
1119         }
1120 
1121         return match_;
1122     }
1123 
1124     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1125 
1126         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1127         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1128         bytes memory keyhash = new bytes(32);
1129         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1130         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
1131 
1132         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1133         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1134 
1135         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1136         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1137 
1138         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1139         // This is to verify that the computed args match with the ones specified in the query.
1140         bytes memory commitmentSlice1 = new bytes(8+1+32);
1141         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1142 
1143         bytes memory sessionPubkey = new bytes(64);
1144         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1145         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1146 
1147         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1148         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1149             delete oraclize_randomDS_args[queryId];
1150         } else return false;
1151 
1152 
1153         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1154         bytes memory tosign1 = new bytes(32+8+1+32);
1155         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1156         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1157 
1158         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1159         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1160             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1161         }
1162 
1163         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1164     }
1165 
1166 
1167     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1168     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1169         uint minLength = length + toOffset;
1170 
1171         if (to.length < minLength) {
1172             // Buffer too small
1173             throw; // Should be a better way?
1174         }
1175 
1176         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1177         uint i = 32 + fromOffset;
1178         uint j = 32 + toOffset;
1179 
1180         while (i < (32 + fromOffset + length)) {
1181             assembly {
1182                 let tmp := mload(add(from, i))
1183                 mstore(add(to, j), tmp)
1184             }
1185             i += 32;
1186             j += 32;
1187         }
1188 
1189         return to;
1190     }
1191 
1192     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1193     // Duplicate Solidity's ecrecover, but catching the CALL return value
1194     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1195         // We do our own memory management here. Solidity uses memory offset
1196         // 0x40 to store the current end of memory. We write past it (as
1197         // writes are memory extensions), but don't update the offset so
1198         // Solidity will reuse it. The memory used here is only needed for
1199         // this context.
1200 
1201         // FIXME: inline assembly can't access return values
1202         bool ret;
1203         address addr;
1204 
1205         assembly {
1206             let size := mload(0x40)
1207             mstore(size, hash)
1208             mstore(add(size, 32), v)
1209             mstore(add(size, 64), r)
1210             mstore(add(size, 96), s)
1211 
1212         // NOTE: we can reuse the request memory because we deal with
1213         //       the return code
1214             ret := call(3000, 1, 0, size, 128, size, 32)
1215             addr := mload(size)
1216         }
1217 
1218         return (ret, addr);
1219     }
1220 
1221     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1222     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1223         bytes32 r;
1224         bytes32 s;
1225         uint8 v;
1226 
1227         if (sig.length != 65)
1228             return (false, 0);
1229 
1230         // The signature format is a compact form of:
1231         //   {bytes32 r}{bytes32 s}{uint8 v}
1232         // Compact means, uint8 is not padded to 32 bytes.
1233         assembly {
1234             r := mload(add(sig, 32))
1235             s := mload(add(sig, 64))
1236 
1237         // Here we are loading the last 32 bytes. We exploit the fact that
1238         // 'mload' will pad with zeroes if we overread.
1239         // There is no 'mload8' to do this, but that would be nicer.
1240             v := byte(0, mload(add(sig, 96)))
1241 
1242         // Alternative solution:
1243         // 'byte' is not working due to the Solidity parser, so lets
1244         // use the second best option, 'and'
1245         // v := and(mload(add(sig, 65)), 255)
1246         }
1247 
1248         // albeit non-transactional signatures are not specified by the YP, one would expect it
1249         // to match the YP range of [27, 28]
1250         //
1251         // geth uses [0, 1] and some clients have followed. This might change, see:
1252         //  https://github.com/ethereum/go-ethereum/issues/2053
1253         if (v < 27)
1254             v += 27;
1255 
1256         if (v != 27 && v != 28)
1257             return (false, 0);
1258 
1259         return safer_ecrecover(hash, v, r, s);
1260     }
1261 
1262 }
1263 // </ORACLIZE_API>
1264 
1265 contract BlackDice is usingOraclize, Ownable, SafeMath {
1266     
1267     struct DiceBet {
1268         address player;
1269         address referee;
1270         uint odd;
1271         uint stake;
1272         uint rng;
1273         uint profit;
1274         uint win;
1275         bool paid;
1276     }
1277     
1278     struct Ref {
1279         uint refCnt;
1280         uint balance;
1281     }
1282     
1283     mapping (bytes32 => DiceBet) public bets;
1284     mapping (address => Ref) public refWallet;
1285     mapping (address => uint) pendingWallet;
1286     mapping (uint => uint) maxBetAmounts;
1287     
1288     bytes32[] public queryIds;
1289     uint public constant baseNumber = 1000;
1290     uint public totalBets;
1291     uint public totalUserProfit;
1292     uint public totalUserLost;
1293     uint public totalWins;
1294     uint public totalLosts;
1295     uint public houseEdge;
1296     uint public refShare;
1297     uint public balance;
1298     uint public maxPendingBalances;
1299     uint public minBetAmount;
1300     uint public gasOraclize;
1301     uint public gasPriceOraclize;
1302     
1303     event DiceRolled(address _address, bytes32 _queryId, uint _amount, uint _odd, address _referee);
1304     event UserWin(address _address, bytes32 _queryId, uint _amount, uint _odd, uint _randomResult, uint _profit, address _referee);
1305     event UserLose(address _address, bytes32 _queryId, uint _amount, uint _odd, uint _randomResult, uint _lost);
1306     event HouseDeposited(uint _amount);
1307     event HouseWithdrawed(address _withdraw, uint _amount);
1308     event PaidPendingBalance(address _holder, uint _amount);
1309     event PaidRefBalance(address _holder, uint _amount);
1310     event ResetHouseEdge();
1311     
1312     modifier onlyOraclize() {
1313         require (msg.sender == oraclize_cbAddress());
1314         _;
1315     }
1316 
1317     function SmartDice() public {
1318         oraclize_setNetwork(networkID_auto);
1319         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1320         houseEdge = 96;
1321         refShare = 1;
1322         gasOraclize = 500000;
1323         minBetAmount = 100 finney;
1324         maxBetAmounts[10] = 500 finney;
1325         maxBetAmounts[20] = 1 ether;
1326         maxBetAmounts[30] = 2 ether;
1327         maxBetAmounts[40] = 4 ether;
1328         maxBetAmounts[50] = 3 ether;
1329         maxBetAmounts[60] = 2 ether;
1330         gasPriceOraclize = 20000000000 wei;
1331         oraclize_setCustomGasPrice(gasPriceOraclize);
1332     }
1333 
1334     function __callback(bytes32 myId, string result, bytes proof) public onlyOraclize {
1335         require(bets[myId].player != address(0x0));
1336         require(bets[myId].win == 2);
1337         
1338         bets[myId].rng = uint(keccak256(parseInt(result), proof)) % baseNumber + 1;
1339         maxPendingBalances = sub(maxPendingBalances, bets[myId].profit);
1340         
1341         if (bets[myId].rng < bets[myId].odd * 10) { 
1342             /// player win
1343             bets[myId].win = 1;
1344             totalWins = totalWins + 1;
1345             
1346             uint refAmt = 0;
1347             if (bets[myId].referee != address(0x0)) {
1348                 refAmt = bets[myId].profit * refShare / 100;
1349                 refWallet[bets[myId].referee].refCnt ++;
1350                 refWallet[bets[myId].referee].balance = add(refWallet[bets[myId].referee].balance, refAmt);
1351             }
1352             
1353             balance = sub(balance, bets[myId].profit);
1354             totalUserProfit = totalUserProfit + bets[myId].profit;
1355             
1356             uint amtToSend = add(bets[myId].profit, bets[myId].stake) - refAmt;
1357             bets[myId].paid = true;
1358             
1359             if (!bets[myId].player.send(amtToSend)) {
1360                 bets[myId].paid = false;
1361                 pendingWallet[bets[myId].player] = add(pendingWallet[bets[myId].player], amtToSend);
1362             }
1363             
1364             UserWin(bets[myId].player, myId, bets[myId].stake, bets[myId].odd, bets[myId].rng, bets[myId].profit - refAmt, bets[myId].referee);
1365         } else {
1366             /// player defeated
1367             bets[myId].win = 0;
1368             
1369             balance = sub(balance, 1);
1370             totalUserLost = totalUserLost + bets[myId].stake;
1371             totalLosts = totalLosts + 1;
1372             bets[myId].profit = 0;
1373             bets[myId].paid = true;
1374             
1375             if (!bets[myId].player.send(1)) {
1376                 bets[myId].paid = false;
1377                 pendingWallet[bets[myId].player] = add(pendingWallet[bets[myId].player], 1);
1378             }
1379             
1380             balance = add(balance, bets[myId].stake);
1381             
1382             UserLose(bets[myId].player, myId, bets[myId].stake, bets[myId].odd, bets[myId].rng, bets[myId].stake);
1383         }
1384     }
1385     
1386     function rollDice(uint _odd, address _referee) public payable returns (bytes32) {
1387         require(_odd <= 60 && _odd > 0);
1388         require(maxBetAmounts[_odd] > 0 && msg.value <= maxBetAmounts[_odd]);
1389         require(msg.sender != _referee);
1390         
1391         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("URL", gasOraclize);
1392         if (minBetAmount + oraclizeFee >= msg.value) revert();
1393         
1394         string memory payload = strConcat('\n{"jsonrpc":"2.0","method":"generateIntegers","params":{"apiKey":"14a9ea18-183d-4f06-95ad-de43293dbe0c","n":1,"min":1,"max":', uint2str(baseNumber),  ',"replacement":true,"base":10},"id":"1"}');
1395         bytes32 queryId = oraclize_query("URL", "json(https://api.random.org/json-rpc/1/invoke).result.random.data.0", payload, gasOraclize);
1396         
1397         uint stake = msg.value - oraclizeFee;
1398         uint profit = stake * houseEdge / _odd - stake;
1399         
1400         bets[queryId] = DiceBet(msg.sender, _referee, _odd, stake, 0, profit, 2, false);
1401         queryIds.push(queryId);
1402         
1403         maxPendingBalances = add(maxPendingBalances, profit);
1404         if (maxPendingBalances > balance) revert();
1405         
1406         totalBets += 1;
1407         
1408         DiceRolled(msg.sender, queryId, stake, _odd, _referee);
1409         return queryId;
1410     }
1411     
1412     function getPendingBalance(address holder) public view returns (uint) {
1413         return pendingWallet[holder];
1414     }
1415     
1416     function setOraclizeGasLimit(uint amount) public onlyOwner {
1417         gasOraclize = amount;
1418     }
1419     
1420     function setOraclizeGasPrice(uint price) public onlyOwner {
1421         gasPriceOraclize = price;
1422         oraclize_setCustomGasPrice(price);
1423     }
1424     
1425     function getMinBetAmount() public constant returns (uint) {
1426         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("URL", gasOraclize);
1427         return oraclizeFee + minBetAmount;
1428     }
1429     
1430     function getMaxBetAmount(uint odd) public constant returns (uint) {
1431         uint totalBalance = address(this).balance;
1432         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("URL", gasOraclize);
1433         return totalBalance * odd * 100 / (houseEdge * (100 - odd)) + oraclizeFee;
1434     }
1435     
1436     function getBetCount() public constant returns (uint) {
1437         return queryIds.length;
1438     }
1439     
1440     function getBet(uint _id) public constant returns (address, uint, uint, uint, uint, uint, bool) {
1441         require(_id < queryIds.length);
1442         bytes32 qId = queryIds[_id];
1443         if (bets[qId].stake > 0) {
1444             DiceBet memory bet = bets[qId];
1445             return (bet.player, bet.stake, bet.odd, bet.rng, bet.profit, bet.win, bet.paid);
1446         }
1447     }
1448     
1449     function getRefWallet() public constant returns (uint, uint) {
1450         return (refWallet[msg.sender].refCnt, refWallet[msg.sender].balance);
1451     }
1452     
1453     function getContractData() public constant returns (uint, uint, uint, uint, uint, uint, uint, uint) {
1454         uint totalBalance = address(this).balance;
1455         uint oraclizeFee = OraclizeI(OAR.getAddress()).getPrice("URL", gasOraclize);
1456         return (totalBalance, oraclizeFee, totalBets, totalUserProfit, totalUserLost, totalWins, totalLosts, houseEdge);
1457     }
1458     
1459     function setMinBetAmount(uint amount) public onlyOwner {
1460         minBetAmount = amount;
1461     }
1462     
1463     function setMaxBetAmount(uint odd, uint amount) public onlyOwner {
1464         require(maxBetAmounts[odd] > 0);
1465         maxBetAmounts[odd] = amount;
1466     }
1467     
1468     function setHouseEdge(uint value) public onlyOwner {
1469         houseEdge = value;
1470         
1471         ResetHouseEdge();
1472     }
1473     
1474     function setRefShare(uint value) public onlyOwner {
1475         refShare = value;
1476     }
1477 
1478     function depositBalance() public payable onlyOwner {
1479         balance = add(balance, msg.value);
1480         
1481         HouseDeposited(msg.value);
1482     }
1483     
1484     function resetBalance() public onlyOwner {
1485         balance = address(this).balance;
1486     }
1487     
1488     function withdrawBalance(address withdraw, uint amount) public onlyOwner {
1489         require(withdraw != address(0));
1490         balance = sub(this.balance(), amount);
1491         if (!withdraw.send(amount)) revert();
1492         
1493         HouseWithdrawed(withdraw, amount);
1494     }
1495     
1496     function withdrawPendingBalance(address holder) public onlyOwner {
1497         require(holder != address(0));
1498         require(pendingWallet[holder] != 0);
1499         uint amount = pendingWallet[holder];
1500         pendingWallet[holder] = 0;
1501         balance = sub(balance, amount);
1502         if (!holder.send(amount)) revert();
1503         
1504         PaidPendingBalance(holder, amount);
1505     }
1506     
1507     function withdrawRefBalance() public {
1508         require(refWallet[msg.sender].balance > 0);
1509         uint amount = refWallet[msg.sender].balance;
1510         refWallet[msg.sender].balance = 0;
1511         balance = sub(balance, amount);
1512         if (!msg.sender.send(amount)) revert();
1513         
1514         PaidRefBalance(msg.sender, amount);
1515     }
1516     
1517     function destroy() public onlyOwner {
1518         selfdestruct(owner);
1519     }
1520 }