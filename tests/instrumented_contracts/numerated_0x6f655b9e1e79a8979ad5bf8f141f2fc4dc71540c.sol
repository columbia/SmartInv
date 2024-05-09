1 pragma solidity ^0.4.24;
2 
3 library SafeMath {
4   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
5     if (a == 0) {
6       return 0;
7     }
8     uint256 c = a * b;
9     assert(c / a == b);
10     return c;
11   }
12 
13   function div(uint256 a, uint256 b) internal pure returns (uint256) {
14     // assert(b > 0); // Solidity automatically throws when dividing by 0
15     uint256 c = a / b;
16     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
17     return c;
18   }
19 
20   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
21     assert(b <= a);
22     return a - b;
23   }
24 
25   function add(uint256 a, uint256 b) internal pure returns (uint256) {
26     uint256 c = a + b;
27     assert(c >= a);
28     return c;
29   }
30 }
31 contract ERC20Basic {
32   uint256 public totalSupply;
33   function balanceOf(address who) public constant returns (uint256);
34   function transfer(address to, uint256 value) public returns (bool);
35   event Transfer(address indexed from, address indexed to, uint256 value);
36 }
37 contract ERC20 is ERC20Basic {
38   function allowance(address owner, address spender) public constant returns (uint256);
39   function transferFrom(address from, address to, uint256 value) public returns (bool);
40   function approve(address spender, uint256 value) public returns (bool);
41   event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43 contract BasicToken is ERC20Basic {
44   using SafeMath for uint256;
45 
46   mapping(address => uint256) balances;
47 
48   /**
49   * @dev transfer token for a specified address
50   * @param _to The address to transfer to.
51   * @param _value The amount to be transferred.
52   */
53   function transfer(address _to, uint256 _value) public returns (bool) {
54     require(_to != address(0));
55     require(_value <= balances[msg.sender]);
56 
57     // SafeMath.sub will throw if there is not enough balance.
58     balances[msg.sender] = balances[msg.sender].sub(_value);
59     balances[_to] = balances[_to].add(_value);
60    emit Transfer(msg.sender, _to, _value);
61     return true;
62   }
63 
64   /**
65   * @dev Gets the balance of the specified address.
66   * @param _owner The address to query the the balance of.
67   * @return An uint256 representing the amount owned by the passed address.
68   */
69   function balanceOf(address _owner) public constant returns (uint256 balance) {
70     return balances[_owner];
71   }
72 
73 }
74 // <ORACLIZE_API>
75 /*
76 Copyright (c) 2015-2016 Oraclize SRL
77 Copyright (c) 2016 Oraclize LTD
78 
79 
80 
81 Permission is hereby granted, free of charge, to any person obtaining a copy
82 of this software and associated documentation files (the "Software"), to deal
83 in the Software without restriction, including without limitation the rights
84 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
85 copies of the Software, and to permit persons to whom the Software is
86 furnished to do so, subject to the following conditions:
87 
88 
89 
90 The above copyright notice and this permission notice shall be included in
91 all copies or substantial portions of the Software.
92 
93 
94 
95 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
96 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
97 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
98 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
99 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
100 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
101 THE SOFTWARE.
102 */
103 
104 contract OraclizeI {
105     address public cbAddress;
106     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
107     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
108     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
109     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
110     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
111     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
112     function getPrice(string _datasource) returns (uint _dsprice);
113     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
114     function useCoupon(string _coupon);
115     function setProofType(byte _proofType);
116     function setConfig(bytes32 _config);
117     function setCustomGasPrice(uint _gasPrice);
118     function randomDS_getSessionPubKeyHash() returns(bytes32);
119 }
120 
121 contract OraclizeAddrResolverI {
122     function getAddress() returns (address _addr);
123 }
124 
125 /*
126 Begin solidity-cborutils
127 
128 https://github.com/smartcontractkit/solidity-cborutils
129 
130 MIT License
131 
132 Copyright (c) 2018 SmartContract ChainLink, Ltd.
133 
134 Permission is hereby granted, free of charge, to any person obtaining a copy
135 of this software and associated documentation files (the "Software"), to deal
136 in the Software without restriction, including without limitation the rights
137 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
138 copies of the Software, and to permit persons to whom the Software is
139 furnished to do so, subject to the following conditions:
140 
141 The above copyright notice and this permission notice shall be included in all
142 copies or substantial portions of the Software.
143 
144 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
145 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
146 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
147 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
148 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
149 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
150 SOFTWARE.
151  */
152 
153 library Buffer {
154     struct buffer {
155         bytes buf;
156         uint capacity;
157     }
158 
159     function init(buffer memory buf, uint capacity) internal constant {
160         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
161         // Allocate space for the buffer data
162         buf.capacity = capacity;
163         assembly {
164             let ptr := mload(0x40)
165             mstore(buf, ptr)
166             mstore(0x40, add(ptr, capacity))
167         }
168     }
169 
170     function resize(buffer memory buf, uint capacity) private constant {
171         bytes memory oldbuf = buf.buf;
172         init(buf, capacity);
173         append(buf, oldbuf);
174     }
175 
176     function max(uint a, uint b) private constant returns(uint) {
177         if(a > b) {
178             return a;
179         }
180         return b;
181     }
182 
183     /**
184      * @dev Appends a byte array to the end of the buffer. Reverts if doing so
185      *      would exceed the capacity of the buffer.
186      * @param buf The buffer to append to.
187      * @param data The data to append.
188      * @return The original buffer.
189      */
190     function append(buffer memory buf, bytes data) internal constant returns(buffer memory) {
191         if(data.length + buf.buf.length > buf.capacity) {
192             resize(buf, max(buf.capacity, data.length) * 2);
193         }
194 
195         uint dest;
196         uint src;
197         uint len = data.length;
198         assembly {
199             // Memory address of the buffer data
200             let bufptr := mload(buf)
201             // Length of existing buffer data
202             let buflen := mload(bufptr)
203             // Start address = buffer address + buffer length + sizeof(buffer length)
204             dest := add(add(bufptr, buflen), 32)
205             // Update buffer length
206             mstore(bufptr, add(buflen, mload(data)))
207             src := add(data, 32)
208         }
209 
210         // Copy word-length chunks while possible
211         for(; len >= 32; len -= 32) {
212             assembly {
213                 mstore(dest, mload(src))
214             }
215             dest += 32;
216             src += 32;
217         }
218 
219         // Copy remaining bytes
220         uint mask = 256 ** (32 - len) - 1;
221         assembly {
222             let srcpart := and(mload(src), not(mask))
223             let destpart := and(mload(dest), mask)
224             mstore(dest, or(destpart, srcpart))
225         }
226 
227         return buf;
228     }
229 
230     /**
231      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
232      * exceed the capacity of the buffer.
233      * @param buf The buffer to append to.
234      * @param data The data to append.
235      * @return The original buffer.
236      */
237     function append(buffer memory buf, uint8 data) internal constant {
238         if(buf.buf.length + 1 > buf.capacity) {
239             resize(buf, buf.capacity * 2);
240         }
241 
242         assembly {
243             // Memory address of the buffer data
244             let bufptr := mload(buf)
245             // Length of existing buffer data
246             let buflen := mload(bufptr)
247             // Address = buffer address + buffer length + sizeof(buffer length)
248             let dest := add(add(bufptr, buflen), 32)
249             mstore8(dest, data)
250             // Update buffer length
251             mstore(bufptr, add(buflen, 1))
252         }
253     }
254 
255     /**
256      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
257      * exceed the capacity of the buffer.
258      * @param buf The buffer to append to.
259      * @param data The data to append.
260      * @return The original buffer.
261      */
262     function appendInt(buffer memory buf, uint data, uint len) internal constant returns(buffer memory) {
263         if(len + buf.buf.length > buf.capacity) {
264             resize(buf, max(buf.capacity, len) * 2);
265         }
266 
267         uint mask = 256 ** len - 1;
268         assembly {
269             // Memory address of the buffer data
270             let bufptr := mload(buf)
271             // Length of existing buffer data
272             let buflen := mload(bufptr)
273             // Address = buffer address + buffer length + sizeof(buffer length) + len
274             let dest := add(add(bufptr, buflen), len)
275             mstore(dest, or(and(mload(dest), not(mask)), data))
276             // Update buffer length
277             mstore(bufptr, add(buflen, len))
278         }
279         return buf;
280     }
281 }
282 
283 library CBOR {
284     using Buffer for Buffer.buffer;
285 
286     uint8 private constant MAJOR_TYPE_INT = 0;
287     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
288     uint8 private constant MAJOR_TYPE_BYTES = 2;
289     uint8 private constant MAJOR_TYPE_STRING = 3;
290     uint8 private constant MAJOR_TYPE_ARRAY = 4;
291     uint8 private constant MAJOR_TYPE_MAP = 5;
292     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
293 
294     function shl8(uint8 x, uint8 y) private constant returns (uint8) {
295         return x * (2 ** y);
296     }
297 
298     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private constant {
299         if(value <= 23) {
300             buf.append(uint8(shl8(major, 5) | value));
301         } else if(value <= 0xFF) {
302             buf.append(uint8(shl8(major, 5) | 24));
303             buf.appendInt(value, 1);
304         } else if(value <= 0xFFFF) {
305             buf.append(uint8(shl8(major, 5) | 25));
306             buf.appendInt(value, 2);
307         } else if(value <= 0xFFFFFFFF) {
308             buf.append(uint8(shl8(major, 5) | 26));
309             buf.appendInt(value, 4);
310         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
311             buf.append(uint8(shl8(major, 5) | 27));
312             buf.appendInt(value, 8);
313         }
314     }
315 
316     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private constant {
317         buf.append(uint8(shl8(major, 5) | 31));
318     }
319 
320     function encodeUInt(Buffer.buffer memory buf, uint value) internal constant {
321         encodeType(buf, MAJOR_TYPE_INT, value);
322     }
323 
324     function encodeInt(Buffer.buffer memory buf, int value) internal constant {
325         if(value >= 0) {
326             encodeType(buf, MAJOR_TYPE_INT, uint(value));
327         } else {
328             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
329         }
330     }
331 
332     function encodeBytes(Buffer.buffer memory buf, bytes value) internal constant {
333         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
334         buf.append(value);
335     }
336 
337     function encodeString(Buffer.buffer memory buf, string value) internal constant {
338         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
339         buf.append(bytes(value));
340     }
341 
342     function startArray(Buffer.buffer memory buf) internal constant {
343         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
344     }
345 
346     function startMap(Buffer.buffer memory buf) internal constant {
347         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
348     }
349 
350     function endSequence(Buffer.buffer memory buf) internal constant {
351         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
352     }
353 }
354 
355 /*
356 End solidity-cborutils
357  */
358 
359 contract usingOraclize {
360     uint constant day = 60*60*24;
361     uint constant week = 60*60*24*7;
362     uint constant month = 60*60*24*30;
363     byte constant proofType_NONE = 0x00;
364     byte constant proofType_TLSNotary = 0x10;
365     byte constant proofType_Android = 0x20;
366     byte constant proofType_Ledger = 0x30;
367     byte constant proofType_Native = 0xF0;
368     byte constant proofStorage_IPFS = 0x01;
369     uint8 constant networkID_auto = 0;
370     uint8 constant networkID_mainnet = 1;
371     uint8 constant networkID_testnet = 2;
372     uint8 constant networkID_morden = 2;
373     uint8 constant networkID_consensys = 161;
374 
375     OraclizeAddrResolverI OAR;
376 
377     OraclizeI oraclize;
378     modifier oraclizeAPI {
379         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
380             oraclize_setNetwork(networkID_auto);
381 
382         if(address(oraclize) != OAR.getAddress())
383             oraclize = OraclizeI(OAR.getAddress());
384 
385         _;
386     }
387     modifier coupon(string code){
388         oraclize = OraclizeI(OAR.getAddress());
389         oraclize.useCoupon(code);
390         _;
391     }
392 
393     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
394         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
395             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
396             oraclize_setNetworkName("eth_mainnet");
397             return true;
398         }
399         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
400             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
401             oraclize_setNetworkName("eth_ropsten3");
402             return true;
403         }
404         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
405             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
406             oraclize_setNetworkName("eth_kovan");
407             return true;
408         }
409         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
410             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
411             oraclize_setNetworkName("eth_rinkeby");
412             return true;
413         }
414         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
415             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
416             return true;
417         }
418         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
419             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
420             return true;
421         }
422         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
423             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
424             return true;
425         }
426         return false;
427     }
428 
429     function __callback(bytes32 myid, string result) {
430         __callback(myid, result, new bytes(0));
431     }
432     function __callback(bytes32 myid, string result, bytes proof) {
433     }
434 
435     function oraclize_useCoupon(string code) oraclizeAPI internal {
436         oraclize.useCoupon(code);
437     }
438 
439     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
440         return oraclize.getPrice(datasource);
441     }
442 
443     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
444         return oraclize.getPrice(datasource, gaslimit);
445     }
446 
447     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
448         uint price = oraclize.getPrice(datasource);
449         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
450         return oraclize.query.value(price)(0, datasource, arg);
451     }
452     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
453         uint price = oraclize.getPrice(datasource);
454         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
455         return oraclize.query.value(price)(timestamp, datasource, arg);
456     }
457     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
458         uint price = oraclize.getPrice(datasource, gaslimit);
459         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
460         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
461     }
462     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
463         uint price = oraclize.getPrice(datasource, gaslimit);
464         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
465         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
466     }
467     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
468         uint price = oraclize.getPrice(datasource);
469         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
470         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
471     }
472     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
473         uint price = oraclize.getPrice(datasource);
474         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
475         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
476     }
477     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
478         uint price = oraclize.getPrice(datasource, gaslimit);
479         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
480         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
481     }
482     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
483         uint price = oraclize.getPrice(datasource, gaslimit);
484         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
485         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
486     }
487     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
488         uint price = oraclize.getPrice(datasource);
489         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
490         bytes memory args = stra2cbor(argN);
491         return oraclize.queryN.value(price)(0, datasource, args);
492     }
493     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
494         uint price = oraclize.getPrice(datasource);
495         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
496         bytes memory args = stra2cbor(argN);
497         return oraclize.queryN.value(price)(timestamp, datasource, args);
498     }
499     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
500         uint price = oraclize.getPrice(datasource, gaslimit);
501         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
502         bytes memory args = stra2cbor(argN);
503         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
504     }
505     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
506         uint price = oraclize.getPrice(datasource, gaslimit);
507         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
508         bytes memory args = stra2cbor(argN);
509         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
510     }
511     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
512         string[] memory dynargs = new string[](1);
513         dynargs[0] = args[0];
514         return oraclize_query(datasource, dynargs);
515     }
516     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
517         string[] memory dynargs = new string[](1);
518         dynargs[0] = args[0];
519         return oraclize_query(timestamp, datasource, dynargs);
520     }
521     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
522         string[] memory dynargs = new string[](1);
523         dynargs[0] = args[0];
524         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
525     }
526     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
527         string[] memory dynargs = new string[](1);
528         dynargs[0] = args[0];
529         return oraclize_query(datasource, dynargs, gaslimit);
530     }
531 
532     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
533         string[] memory dynargs = new string[](2);
534         dynargs[0] = args[0];
535         dynargs[1] = args[1];
536         return oraclize_query(datasource, dynargs);
537     }
538     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
539         string[] memory dynargs = new string[](2);
540         dynargs[0] = args[0];
541         dynargs[1] = args[1];
542         return oraclize_query(timestamp, datasource, dynargs);
543     }
544     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
545         string[] memory dynargs = new string[](2);
546         dynargs[0] = args[0];
547         dynargs[1] = args[1];
548         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
549     }
550     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
551         string[] memory dynargs = new string[](2);
552         dynargs[0] = args[0];
553         dynargs[1] = args[1];
554         return oraclize_query(datasource, dynargs, gaslimit);
555     }
556     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
557         string[] memory dynargs = new string[](3);
558         dynargs[0] = args[0];
559         dynargs[1] = args[1];
560         dynargs[2] = args[2];
561         return oraclize_query(datasource, dynargs);
562     }
563     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
564         string[] memory dynargs = new string[](3);
565         dynargs[0] = args[0];
566         dynargs[1] = args[1];
567         dynargs[2] = args[2];
568         return oraclize_query(timestamp, datasource, dynargs);
569     }
570     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
571         string[] memory dynargs = new string[](3);
572         dynargs[0] = args[0];
573         dynargs[1] = args[1];
574         dynargs[2] = args[2];
575         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
576     }
577     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
578         string[] memory dynargs = new string[](3);
579         dynargs[0] = args[0];
580         dynargs[1] = args[1];
581         dynargs[2] = args[2];
582         return oraclize_query(datasource, dynargs, gaslimit);
583     }
584 
585     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
586         string[] memory dynargs = new string[](4);
587         dynargs[0] = args[0];
588         dynargs[1] = args[1];
589         dynargs[2] = args[2];
590         dynargs[3] = args[3];
591         return oraclize_query(datasource, dynargs);
592     }
593     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
594         string[] memory dynargs = new string[](4);
595         dynargs[0] = args[0];
596         dynargs[1] = args[1];
597         dynargs[2] = args[2];
598         dynargs[3] = args[3];
599         return oraclize_query(timestamp, datasource, dynargs);
600     }
601     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
602         string[] memory dynargs = new string[](4);
603         dynargs[0] = args[0];
604         dynargs[1] = args[1];
605         dynargs[2] = args[2];
606         dynargs[3] = args[3];
607         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
608     }
609     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
610         string[] memory dynargs = new string[](4);
611         dynargs[0] = args[0];
612         dynargs[1] = args[1];
613         dynargs[2] = args[2];
614         dynargs[3] = args[3];
615         return oraclize_query(datasource, dynargs, gaslimit);
616     }
617     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
618         string[] memory dynargs = new string[](5);
619         dynargs[0] = args[0];
620         dynargs[1] = args[1];
621         dynargs[2] = args[2];
622         dynargs[3] = args[3];
623         dynargs[4] = args[4];
624         return oraclize_query(datasource, dynargs);
625     }
626     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
627         string[] memory dynargs = new string[](5);
628         dynargs[0] = args[0];
629         dynargs[1] = args[1];
630         dynargs[2] = args[2];
631         dynargs[3] = args[3];
632         dynargs[4] = args[4];
633         return oraclize_query(timestamp, datasource, dynargs);
634     }
635     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
636         string[] memory dynargs = new string[](5);
637         dynargs[0] = args[0];
638         dynargs[1] = args[1];
639         dynargs[2] = args[2];
640         dynargs[3] = args[3];
641         dynargs[4] = args[4];
642         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
643     }
644     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
645         string[] memory dynargs = new string[](5);
646         dynargs[0] = args[0];
647         dynargs[1] = args[1];
648         dynargs[2] = args[2];
649         dynargs[3] = args[3];
650         dynargs[4] = args[4];
651         return oraclize_query(datasource, dynargs, gaslimit);
652     }
653     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
654         uint price = oraclize.getPrice(datasource);
655         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
656         bytes memory args = ba2cbor(argN);
657         return oraclize.queryN.value(price)(0, datasource, args);
658     }
659     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
660         uint price = oraclize.getPrice(datasource);
661         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
662         bytes memory args = ba2cbor(argN);
663         return oraclize.queryN.value(price)(timestamp, datasource, args);
664     }
665     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
666         uint price = oraclize.getPrice(datasource, gaslimit);
667         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
668         bytes memory args = ba2cbor(argN);
669         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
670     }
671     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
672         uint price = oraclize.getPrice(datasource, gaslimit);
673         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
674         bytes memory args = ba2cbor(argN);
675         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
676     }
677     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
678         bytes[] memory dynargs = new bytes[](1);
679         dynargs[0] = args[0];
680         return oraclize_query(datasource, dynargs);
681     }
682     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
683         bytes[] memory dynargs = new bytes[](1);
684         dynargs[0] = args[0];
685         return oraclize_query(timestamp, datasource, dynargs);
686     }
687     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
688         bytes[] memory dynargs = new bytes[](1);
689         dynargs[0] = args[0];
690         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
691     }
692     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
693         bytes[] memory dynargs = new bytes[](1);
694         dynargs[0] = args[0];
695         return oraclize_query(datasource, dynargs, gaslimit);
696     }
697 
698     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
699         bytes[] memory dynargs = new bytes[](2);
700         dynargs[0] = args[0];
701         dynargs[1] = args[1];
702         return oraclize_query(datasource, dynargs);
703     }
704     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
705         bytes[] memory dynargs = new bytes[](2);
706         dynargs[0] = args[0];
707         dynargs[1] = args[1];
708         return oraclize_query(timestamp, datasource, dynargs);
709     }
710     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
711         bytes[] memory dynargs = new bytes[](2);
712         dynargs[0] = args[0];
713         dynargs[1] = args[1];
714         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
715     }
716     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
717         bytes[] memory dynargs = new bytes[](2);
718         dynargs[0] = args[0];
719         dynargs[1] = args[1];
720         return oraclize_query(datasource, dynargs, gaslimit);
721     }
722     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
723         bytes[] memory dynargs = new bytes[](3);
724         dynargs[0] = args[0];
725         dynargs[1] = args[1];
726         dynargs[2] = args[2];
727         return oraclize_query(datasource, dynargs);
728     }
729     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
730         bytes[] memory dynargs = new bytes[](3);
731         dynargs[0] = args[0];
732         dynargs[1] = args[1];
733         dynargs[2] = args[2];
734         return oraclize_query(timestamp, datasource, dynargs);
735     }
736     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
737         bytes[] memory dynargs = new bytes[](3);
738         dynargs[0] = args[0];
739         dynargs[1] = args[1];
740         dynargs[2] = args[2];
741         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
742     }
743     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
744         bytes[] memory dynargs = new bytes[](3);
745         dynargs[0] = args[0];
746         dynargs[1] = args[1];
747         dynargs[2] = args[2];
748         return oraclize_query(datasource, dynargs, gaslimit);
749     }
750 
751     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
752         bytes[] memory dynargs = new bytes[](4);
753         dynargs[0] = args[0];
754         dynargs[1] = args[1];
755         dynargs[2] = args[2];
756         dynargs[3] = args[3];
757         return oraclize_query(datasource, dynargs);
758     }
759     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
760         bytes[] memory dynargs = new bytes[](4);
761         dynargs[0] = args[0];
762         dynargs[1] = args[1];
763         dynargs[2] = args[2];
764         dynargs[3] = args[3];
765         return oraclize_query(timestamp, datasource, dynargs);
766     }
767     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
768         bytes[] memory dynargs = new bytes[](4);
769         dynargs[0] = args[0];
770         dynargs[1] = args[1];
771         dynargs[2] = args[2];
772         dynargs[3] = args[3];
773         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
774     }
775     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
776         bytes[] memory dynargs = new bytes[](4);
777         dynargs[0] = args[0];
778         dynargs[1] = args[1];
779         dynargs[2] = args[2];
780         dynargs[3] = args[3];
781         return oraclize_query(datasource, dynargs, gaslimit);
782     }
783     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
784         bytes[] memory dynargs = new bytes[](5);
785         dynargs[0] = args[0];
786         dynargs[1] = args[1];
787         dynargs[2] = args[2];
788         dynargs[3] = args[3];
789         dynargs[4] = args[4];
790         return oraclize_query(datasource, dynargs);
791     }
792     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
793         bytes[] memory dynargs = new bytes[](5);
794         dynargs[0] = args[0];
795         dynargs[1] = args[1];
796         dynargs[2] = args[2];
797         dynargs[3] = args[3];
798         dynargs[4] = args[4];
799         return oraclize_query(timestamp, datasource, dynargs);
800     }
801     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
802         bytes[] memory dynargs = new bytes[](5);
803         dynargs[0] = args[0];
804         dynargs[1] = args[1];
805         dynargs[2] = args[2];
806         dynargs[3] = args[3];
807         dynargs[4] = args[4];
808         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
809     }
810     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
811         bytes[] memory dynargs = new bytes[](5);
812         dynargs[0] = args[0];
813         dynargs[1] = args[1];
814         dynargs[2] = args[2];
815         dynargs[3] = args[3];
816         dynargs[4] = args[4];
817         return oraclize_query(datasource, dynargs, gaslimit);
818     }
819 
820     function oraclize_cbAddress() oraclizeAPI internal returns (address){
821         return oraclize.cbAddress();
822     }
823     function oraclize_setProof(byte proofP) oraclizeAPI internal {
824         return oraclize.setProofType(proofP);
825     }
826     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
827         return oraclize.setCustomGasPrice(gasPrice);
828     }
829     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
830         return oraclize.setConfig(config);
831     }
832 
833     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
834         return oraclize.randomDS_getSessionPubKeyHash();
835     }
836 
837     function getCodeSize(address _addr) constant internal returns(uint _size) {
838         assembly {
839             _size := extcodesize(_addr)
840         }
841     }
842 
843     function parseAddr(string _a) internal returns (address){
844         bytes memory tmp = bytes(_a);
845         uint160 iaddr = 0;
846         uint160 b1;
847         uint160 b2;
848         for (uint i=2; i<2+2*20; i+=2){
849             iaddr *= 256;
850             b1 = uint160(tmp[i]);
851             b2 = uint160(tmp[i+1]);
852             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
853             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
854             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
855             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
856             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
857             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
858             iaddr += (b1*16+b2);
859         }
860         return address(iaddr);
861     }
862 
863     function strCompare(string _a, string _b) internal returns (int) {
864         bytes memory a = bytes(_a);
865         bytes memory b = bytes(_b);
866         uint minLength = a.length;
867         if (b.length < minLength) minLength = b.length;
868         for (uint i = 0; i < minLength; i ++)
869             if (a[i] < b[i])
870                 return -1;
871             else if (a[i] > b[i])
872                 return 1;
873         if (a.length < b.length)
874             return -1;
875         else if (a.length > b.length)
876             return 1;
877         else
878             return 0;
879     }
880 
881     function indexOf(string _haystack, string _needle) internal returns (int) {
882         bytes memory h = bytes(_haystack);
883         bytes memory n = bytes(_needle);
884         if(h.length < 1 || n.length < 1 || (n.length > h.length))
885             return -1;
886         else if(h.length > (2**128 -1))
887             return -1;
888         else
889         {
890             uint subindex = 0;
891             for (uint i = 0; i < h.length; i ++)
892             {
893                 if (h[i] == n[0])
894                 {
895                     subindex = 1;
896                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
897                     {
898                         subindex++;
899                     }
900                     if(subindex == n.length)
901                         return int(i);
902                 }
903             }
904             return -1;
905         }
906     }
907 
908     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
909         bytes memory _ba = bytes(_a);
910         bytes memory _bb = bytes(_b);
911         bytes memory _bc = bytes(_c);
912         bytes memory _bd = bytes(_d);
913         bytes memory _be = bytes(_e);
914         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
915         bytes memory babcde = bytes(abcde);
916         uint k = 0;
917         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
918         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
919         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
920         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
921         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
922         return string(babcde);
923     }
924 
925     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
926         return strConcat(_a, _b, _c, _d, "");
927     }
928 
929     function strConcat(string _a, string _b, string _c) internal returns (string) {
930         return strConcat(_a, _b, _c, "", "");
931     }
932 
933     function strConcat(string _a, string _b) internal returns (string) {
934         return strConcat(_a, _b, "", "", "");
935     }
936 
937     // parseInt
938     function parseInt(string _a) internal returns (uint) {
939         return parseInt(_a, 0);
940     }
941 
942     // parseInt(parseFloat*10^_b)
943     function parseInt(string _a, uint _b) internal returns (uint) {
944         bytes memory bresult = bytes(_a);
945         uint mint = 0;
946         bool decimals = false;
947         for (uint i=0; i<bresult.length; i++){
948             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
949                 if (decimals){
950                    if (_b == 0) break;
951                     else _b--;
952                 }
953                 mint *= 10;
954                 mint += uint(bresult[i]) - 48;
955             } else if (bresult[i] == 46) decimals = true;
956         }
957         if (_b > 0) mint *= 10**_b;
958         return mint;
959     }
960 
961     function uint2str(uint i) internal returns (string){
962         if (i == 0) return "0";
963         uint j = i;
964         uint len;
965         while (j != 0){
966             len++;
967             j /= 10;
968         }
969         bytes memory bstr = new bytes(len);
970         uint k = len - 1;
971         while (i != 0){
972             bstr[k--] = byte(48 + i % 10);
973             i /= 10;
974         }
975         return string(bstr);
976     }
977 
978     using CBOR for Buffer.buffer;
979     function stra2cbor(string[] arr) internal constant returns (bytes) {
980         Buffer.buffer memory buf;
981         Buffer.init(buf, 1024);
982         buf.startArray();
983         for (uint i = 0; i < arr.length; i++) {
984             buf.encodeString(arr[i]);
985         }
986         buf.endSequence();
987         return buf.buf;
988     }
989 
990     function ba2cbor(bytes[] arr) internal constant returns (bytes) {
991         Buffer.buffer memory buf;
992         Buffer.init(buf, 1024);
993         buf.startArray();
994         for (uint i = 0; i < arr.length; i++) {
995             buf.encodeBytes(arr[i]);
996         }
997         buf.endSequence();
998         return buf.buf;
999     }
1000 
1001     string oraclize_network_name;
1002     function oraclize_setNetworkName(string _network_name) internal {
1003         oraclize_network_name = _network_name;
1004     }
1005 
1006     function oraclize_getNetworkName() internal returns (string) {
1007         return oraclize_network_name;
1008     }
1009 
1010     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1011         if ((_nbytes == 0)||(_nbytes > 32)) throw;
1012   // Convert from seconds to ledger timer ticks
1013         _delay *= 10;
1014         bytes memory nbytes = new bytes(1);
1015         nbytes[0] = byte(_nbytes);
1016         bytes memory unonce = new bytes(32);
1017         bytes memory sessionKeyHash = new bytes(32);
1018         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1019         assembly {
1020             mstore(unonce, 0x20)
1021             // the following variables can be relaxed
1022             // check relaxed random contract under ethereum-examples repo
1023             // for an idea on how to override and replace comit hash vars
1024             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1025             mstore(sessionKeyHash, 0x20)
1026             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1027         }
1028         bytes memory delay = new bytes(32);
1029         assembly {
1030             mstore(add(delay, 0x20), _delay)
1031         }
1032 
1033         bytes memory delay_bytes8 = new bytes(8);
1034         copyBytes(delay, 24, 8, delay_bytes8, 0);
1035 
1036         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1037         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1038 
1039         bytes memory delay_bytes8_left = new bytes(8);
1040 
1041         assembly {
1042             let x := mload(add(delay_bytes8, 0x20))
1043             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1044             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1045             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1046             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1047             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1048             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1049             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1050             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1051 
1052         }
1053 
1054         oraclize_randomDS_setCommitment(queryId, sha3(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1055         return queryId;
1056     }
1057 
1058     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1059         oraclize_randomDS_args[queryId] = commitment;
1060     }
1061 
1062     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1063     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1064 
1065     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1066         bool sigok;
1067         address signer;
1068 
1069         bytes32 sigr;
1070         bytes32 sigs;
1071 
1072         bytes memory sigr_ = new bytes(32);
1073         uint offset = 4+(uint(dersig[3]) - 0x20);
1074         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1075         bytes memory sigs_ = new bytes(32);
1076         offset += 32 + 2;
1077         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1078 
1079         assembly {
1080             sigr := mload(add(sigr_, 32))
1081             sigs := mload(add(sigs_, 32))
1082         }
1083 
1084 
1085         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1086         if (address(sha3(pubkey)) == signer) return true;
1087         else {
1088             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1089             return (address(sha3(pubkey)) == signer);
1090         }
1091     }
1092 
1093     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1094         bool sigok;
1095 
1096         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1097         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1098         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1099 
1100         bytes memory appkey1_pubkey = new bytes(64);
1101         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1102 
1103         bytes memory tosign2 = new bytes(1+65+32);
1104         tosign2[0] = 1; //role
1105         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1106         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1107         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1108         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1109 
1110         if (sigok == false) return false;
1111 
1112 
1113         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1114         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1115 
1116         bytes memory tosign3 = new bytes(1+65);
1117         tosign3[0] = 0xFE;
1118         copyBytes(proof, 3, 65, tosign3, 1);
1119 
1120         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1121         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1122 
1123         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1124 
1125         return sigok;
1126     }
1127 
1128     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1129         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1130         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
1131 
1132         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1133         if (proofVerified == false) throw;
1134 
1135         _;
1136     }
1137 
1138     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1139         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1140         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1141 
1142         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1143         if (proofVerified == false) return 2;
1144 
1145         return 0;
1146     }
1147 
1148     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
1149         bool match_ = true;
1150 
1151   if (prefix.length != n_random_bytes) throw;
1152 
1153         for (uint256 i=0; i< n_random_bytes; i++) {
1154             if (content[i] != prefix[i]) match_ = false;
1155         }
1156 
1157         return match_;
1158     }
1159 
1160     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1161 
1162         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1163         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1164         bytes memory keyhash = new bytes(32);
1165         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1166         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
1167 
1168         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1169         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1170 
1171         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1172         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1173 
1174         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1175         // This is to verify that the computed args match with the ones specified in the query.
1176         bytes memory commitmentSlice1 = new bytes(8+1+32);
1177         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1178 
1179         bytes memory sessionPubkey = new bytes(64);
1180         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1181         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1182 
1183         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1184         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1185             delete oraclize_randomDS_args[queryId];
1186         } else return false;
1187 
1188 
1189         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1190         bytes memory tosign1 = new bytes(32+8+1+32);
1191         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1192         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1193 
1194         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1195         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1196             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1197         }
1198 
1199         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1200     }
1201 
1202 
1203     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1204     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1205         uint minLength = length + toOffset;
1206 
1207         if (to.length < minLength) {
1208             // Buffer too small
1209             throw; // Should be a better way?
1210         }
1211 
1212         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1213         uint i = 32 + fromOffset;
1214         uint j = 32 + toOffset;
1215 
1216         while (i < (32 + fromOffset + length)) {
1217             assembly {
1218                 let tmp := mload(add(from, i))
1219                 mstore(add(to, j), tmp)
1220             }
1221             i += 32;
1222             j += 32;
1223         }
1224 
1225         return to;
1226     }
1227 
1228     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1229     // Duplicate Solidity's ecrecover, but catching the CALL return value
1230     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1231         // We do our own memory management here. Solidity uses memory offset
1232         // 0x40 to store the current end of memory. We write past it (as
1233         // writes are memory extensions), but don't update the offset so
1234         // Solidity will reuse it. The memory used here is only needed for
1235         // this context.
1236 
1237         // FIXME: inline assembly can't access return values
1238         bool ret;
1239         address addr;
1240 
1241         assembly {
1242             let size := mload(0x40)
1243             mstore(size, hash)
1244             mstore(add(size, 32), v)
1245             mstore(add(size, 64), r)
1246             mstore(add(size, 96), s)
1247 
1248             // NOTE: we can reuse the request memory because we deal with
1249             //       the return code
1250             ret := call(3000, 1, 0, size, 128, size, 32)
1251             addr := mload(size)
1252         }
1253 
1254         return (ret, addr);
1255     }
1256 
1257     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1258     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1259         bytes32 r;
1260         bytes32 s;
1261         uint8 v;
1262 
1263         if (sig.length != 65)
1264           return (false, 0);
1265 
1266         // The signature format is a compact form of:
1267         //   {bytes32 r}{bytes32 s}{uint8 v}
1268         // Compact means, uint8 is not padded to 32 bytes.
1269         assembly {
1270             r := mload(add(sig, 32))
1271             s := mload(add(sig, 64))
1272 
1273             // Here we are loading the last 32 bytes. We exploit the fact that
1274             // 'mload' will pad with zeroes if we overread.
1275             // There is no 'mload8' to do this, but that would be nicer.
1276             v := byte(0, mload(add(sig, 96)))
1277 
1278             // Alternative solution:
1279             // 'byte' is not working due to the Solidity parser, so lets
1280             // use the second best option, 'and'
1281             // v := and(mload(add(sig, 65)), 255)
1282         }
1283 
1284         // albeit non-transactional signatures are not specified by the YP, one would expect it
1285         // to match the YP range of [27, 28]
1286         //
1287         // geth uses [0, 1] and some clients have followed. This might change, see:
1288         //  https://github.com/ethereum/go-ethereum/issues/2053
1289         if (v < 27)
1290           v += 27;
1291 
1292         if (v != 27 && v != 28)
1293             return (false, 0);
1294 
1295         return safer_ecrecover(hash, v, r, s);
1296     }
1297 
1298 }
1299 // </ORACLIZE_API>
1300 
1301 /**
1302  * @title Ownable
1303  * @dev The Ownable contract has an owner address, and provides basic authorization control
1304  * functions, this simplifies the implementation of "user permissions".
1305  */
1306 contract Ownable {
1307   address public owner;
1308 
1309   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1310 
1311   /**
1312    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
1313    * account.
1314    */
1315 
1316   function Ownable() public {
1317     owner = msg.sender;
1318   }
1319 
1320   /**
1321    * @dev Throws if called by any account other than the owner.
1322    */
1323   modifier onlyOwner() {
1324     require(msg.sender == owner);
1325     _;
1326   }
1327 
1328   /**
1329    * @dev Allows the current owner to transfer control of the contract to a newOwner.
1330    * @param newOwner The address to transfer ownership to.
1331    */
1332   function transferOwnership(address newOwner) onlyOwner public {
1333     require(newOwner != address(0));
1334     // OwnershipTransferred(owner, newOwner);
1335    emit OwnershipTransferred(owner, newOwner);
1336     owner = newOwner;
1337   }
1338 
1339 }
1340 
1341 contract StandardToken is ERC20, BasicToken {
1342 
1343   mapping (address => mapping (address => uint256)) internal allowed;
1344 
1345   /**
1346    * @dev Transfer tokens from one address to another
1347    * @param _from address The address which you want to send tokens from
1348    * @param _to address The address which you want to transfer to
1349    * @param _value uint256 the amount of tokens to be transferred
1350    */
1351   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
1352     require(_to != address(0));
1353     require(_value <= balances[_from]);
1354     require(_value <= allowed[_from][msg.sender]);
1355 
1356     balances[_from] = balances[_from].sub(_value);
1357     balances[_to] = balances[_to].add(_value);
1358     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
1359    emit Transfer(_from, _to, _value);
1360     return true;
1361   }
1362 
1363   /**
1364    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
1365    *
1366    * Beware that changing an allowance with this method brings the risk that someone may use both the old
1367    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
1368    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
1369    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
1370    * @param _spender The address which will spend the funds.
1371    * @param _value The amount of tokens to be spent.
1372    */
1373   function approve(address _spender, uint256 _value) public returns (bool) {
1374     allowed[msg.sender][_spender] = _value;
1375    emit Approval(msg.sender, _spender, _value);
1376     return true;
1377   }
1378 
1379   /**
1380    * @dev Function to check the amount of tokens that an owner allowed to a spender.
1381    * @param _owner address The address which owns the funds.
1382    * @param _spender address The address which will spend the funds.
1383    * @return A uint256 specifying the amount of tokens still available for the spender.
1384    */
1385   function allowance(address _owner, address _spender) public constant returns (uint256 remaining) {
1386     return allowed[_owner][_spender];
1387   }
1388 
1389   /**
1390    * approve should be called when allowed[_spender] == 0. To increment
1391    * allowed value is better to use this function to avoid 2 calls (and wait until
1392    * the first transaction is mined)
1393    * From MonolithDAO Token.sol
1394    */
1395   function increaseApproval (address _spender, uint _addedValue) public returns (bool success) {
1396     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
1397    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1398     return true;
1399   }
1400 
1401   function decreaseApproval (address _spender, uint _subtractedValue) public returns (bool success) {
1402     uint oldValue = allowed[msg.sender][_spender];
1403     if (_subtractedValue > oldValue) {
1404       allowed[msg.sender][_spender] = 0;
1405     } else {
1406       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
1407     }
1408    emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
1409     return true;
1410   }
1411 
1412 }
1413 
1414 contract TokenFreeze is Ownable, StandardToken {
1415   uint256 public unfreeze_date;
1416   
1417   event FreezeDateChanged(string message, uint256 date);
1418 
1419   function TokenFreeze() public {
1420     unfreeze_date = now;
1421   }
1422 
1423   modifier freezed() {
1424     require(unfreeze_date < now);
1425     _;
1426   }
1427 
1428   function changeFreezeDate(uint256 datetime) onlyOwner public {
1429     require(datetime != 0);
1430     unfreeze_date = datetime;
1431   emit  FreezeDateChanged("Unfreeze Date: ", datetime);
1432   }
1433   
1434   function transferFrom(address _from, address _to, uint256 _value) freezed public returns (bool) {
1435     super.transferFrom(_from, _to, _value);
1436   }
1437 
1438   function transfer(address _to, uint256 _value) freezed public returns (bool) {
1439     super.transfer(_to, _value);
1440   }
1441 
1442 }
1443 
1444 contract Whitelisted  {
1445 
1446   Whitelist.List private _list;
1447   
1448   modifier onlyWhitelisted() {
1449     require(Whitelist.check(_list, msg.sender) == true);
1450     _;
1451   }
1452 
1453   event AddressAdded(address _addr);
1454   event AddressRemoved(address _addr);
1455   
1456   function WhitelistedAddress()
1457   public
1458   {
1459     Whitelist.add(_list, msg.sender);
1460   }
1461 
1462   function WhitelistAddressenable(address _addr)
1463     public
1464   {
1465     Whitelist.add(_list, _addr);
1466     emit AddressAdded(_addr);
1467   }
1468 
1469   function WhitelistAddressdisable(address _addr)
1470     public
1471   {
1472     Whitelist.remove(_list, _addr);
1473    emit AddressRemoved(_addr);
1474   }
1475   
1476   function WhitelistAddressisListed(address _addr)
1477   public
1478   view
1479   returns (bool)
1480   {
1481       return Whitelist.check(_list, _addr);
1482   }
1483 }
1484 
1485 /**
1486  * @title Mintable token
1487  * @dev Simple ERC20 Token example, with mintable token creation
1488  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
1489  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
1490  */
1491 
1492 contract MintableToken is TokenFreeze, Whitelisted {
1493   event Mint(address indexed to, uint256 amount);
1494   event MintFinished();
1495   
1496   string public constant name = "Vertex";
1497   string public constant symbol = "VTEX";
1498   uint8 public constant decimals = 5;  // 18 is the most common number of decimal places
1499   bool public mintingFinished = false;
1500  
1501   mapping (address => bool) public whitelist; 
1502   
1503   modifier canMint() {
1504     require(!mintingFinished);
1505     _;
1506   }
1507 
1508   /**
1509    * @dev Function to mint tokens
1510    * @param _to The address that will receive the minted tokens.
1511    * @param _amount The amount of tokens to mint.
1512    * @return A boolean that indicates if the operation was successful.
1513    */
1514   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
1515     
1516     totalSupply = totalSupply.add(_amount);
1517     require(totalSupply <= 30000000000000);
1518     balances[_to] = balances[_to].add(_amount);
1519     emit  Mint(_to, _amount);
1520     emit Transfer(address(0), _to, _amount);
1521     
1522     return true;
1523   }
1524 
1525   /**
1526    * @dev Function to stop minting new tokens.
1527    * @return True if the operation was successful.
1528    */
1529   function finishMinting() onlyOwner canMint public returns (bool) {
1530     mintingFinished = true;
1531     emit MintFinished();
1532     return true;
1533   }
1534 }
1535 
1536 library Whitelist {
1537   
1538   struct List {
1539     mapping(address => bool) registry;
1540   }
1541   
1542   function add(List storage list, address _addr)
1543     internal
1544   {
1545     list.registry[_addr] = true;
1546   }
1547 
1548   function remove(List storage list, address _addr)
1549     internal
1550   {
1551     list.registry[_addr] = false;
1552   }
1553 
1554   function check(List storage list, address _addr)
1555     view
1556     internal
1557     returns (bool)
1558   {
1559     return list.registry[_addr];
1560   }
1561 }
1562 
1563 
1564 contract WhitelistToken is Whitelisted {
1565 
1566   function onlyWhitelistedCanDo()
1567     onlyWhitelisted
1568     view
1569     external
1570   {    
1571   }
1572 
1573 }
1574 
1575 //For production, change all days to days
1576 //Change and check days and discounts
1577 contract Vertex_Token is Ownable,  Whitelisted, MintableToken, usingOraclize {
1578     using SafeMath for uint256;
1579 
1580     // The token being sold
1581     MintableToken public token;
1582 
1583     // start and end timestamps where investments are allowed (both inclusive)
1584     // uint256 public PrivateSaleStartTime;
1585     // uint256 public PrivateSaleEndTime;
1586     uint256 public ICOStartTime = 1538380800;
1587     uint256 public ICOEndTime = 1548403200;
1588 
1589     uint256 public hardCap = 30000000000000;
1590 
1591     // address where funds are collected
1592     address public wallet;
1593 
1594     // how many token units a buyer gets per wei
1595     uint256 public rate;
1596     uint256 public weiRaised;
1597 
1598     /**
1599     * event for token purchase logging
1600     * @param purchaser who paid for the tokens
1601     * @param beneficiary who got the tokens
1602     * @param value weis paid for purchase
1603     * @param amount amount of tokens purchased
1604     */
1605 
1606     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
1607     event newOraclizeQuery(string description);
1608 
1609     function Vertex_Token(uint256 _rate, address _wallet, uint256 _unfreeze_date)  public {
1610         require(_rate > 0);
1611         require(_wallet != address(0));
1612 
1613         token = createTokenContract();
1614 
1615         rate = _rate;
1616         wallet = _wallet;
1617         
1618         token.changeFreezeDate(_unfreeze_date);
1619     }
1620    
1621     // function startICO() onlyOwner public {
1622     //     require(ICOStartTime == 0);
1623     //     ICOStartTime = now;
1624     //     ICOEndTime = ICOStartTime + 112 days;
1625     // }
1626     // function stopICO() onlyOwner public {
1627     //     require(ICOEndTime > now);
1628     //     ICOEndTime = now;
1629     // }
1630     
1631     function changeTokenFreezeDate(uint256 _new_date) onlyOwner public {
1632         token.changeFreezeDate(_new_date);
1633     }
1634     
1635     function unfreezeTokens() onlyOwner public {
1636         token.changeFreezeDate(now);
1637     }
1638 
1639     // creates the token to be sold.
1640     // override this method to have crowdsale of a specific mintable token.
1641     function createTokenContract() internal returns (MintableToken) {
1642         return new MintableToken();
1643     }
1644 
1645     // fallback function can be used to buy tokens
1646     function () payable public {
1647         buyTokens(msg.sender);
1648     }
1649 
1650     //return token price in cents
1651     function getUSDPrice() public constant returns (uint256 cents_by_token) {
1652         uint256 total_tokens = SafeMath.div(totalTokenSupply(), token.decimals());
1653 
1654         if (total_tokens > 165000000)
1655             return 31;
1656         else if (total_tokens > 150000000)
1657             return 30;
1658         else if (total_tokens > 135000000)
1659             return 29;
1660         else if (total_tokens > 120000000)
1661             return 28;
1662         else if (total_tokens > 105000000)
1663             return 27;
1664         else if (total_tokens > 90000000)
1665             return 26;
1666         else if (total_tokens > 75000000)
1667             return 25;
1668         else if (total_tokens > 60000000)
1669             return 24;
1670         else if (total_tokens > 45000000)
1671             return 23;
1672         else if (total_tokens > 30000000)
1673             return 22;
1674         else if (total_tokens > 15000000)
1675             return 18;
1676         else
1677             return 15;
1678     }
1679     // function calcBonus(uint256 tokens, uint256 ethers) public constant returns (uint256 tokens_with_bonus) {
1680     //     return tokens;
1681     // }
1682     // string 123.45 to 12345 converter
1683     function stringFloatToUnsigned(string _s) payable public returns (string) {
1684         bytes memory _new_s = new bytes(bytes(_s).length - 1);
1685         uint k = 0;
1686 
1687         for (uint i = 0; i < bytes(_s).length; i++) {
1688             if (bytes(_s)[i] == '.') { break; } // 1
1689 
1690             _new_s[k] = bytes(_s)[i];
1691             k++;
1692         }
1693 
1694         return string(_new_s);
1695     }
1696     // callback for oraclize 
1697     function __callback(bytes32 myid, string result) public {
1698         if (msg.sender != oraclize_cbAddress()) revert();
1699         string memory converted = stringFloatToUnsigned(result);
1700         rate = parseInt(converted);
1701         rate = SafeMath.div(1000000000000000000, rate); // price for 1 USD in WEI 
1702     }
1703     // price updater 
1704     function updatePrice() payable public {
1705         oraclize_setProof(proofType_NONE);
1706         if (oraclize_getPrice("URL") > address(this).balance) {
1707          emit newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1708         } else {
1709          emit   newOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1710             oraclize_query("URL", "json(https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD).USD");
1711         }
1712     }
1713     //amy
1714     
1715     
1716      
1717      function withdraw(uint amount) onlyOwner returns(bool) {
1718          require(amount < this.balance);
1719         wallet.transfer(amount);
1720         return true;
1721 
1722     }
1723 
1724    
1725 
1726     function getBalance() public view returns (uint256) {
1727         return address(this).balance;
1728     }
1729     
1730     
1731    //end
1732     // low level token purchase function
1733     function buyTokens(address beneficiary) public payable {
1734         require(beneficiary != address(0));
1735         // require(WhitelistAddressisListed(beneficiary));
1736         require(validPurchase());
1737         require(msg.value >= SafeMath.mul(rate, 50));  // minimum contrib amount 50 USD
1738 
1739         uint256 _convert_rate = SafeMath.div(SafeMath.mul(rate, getUSDPrice()), 100);
1740 
1741         // calculate token amount to be created
1742         uint256 weiAmount = SafeMath.mul(msg.value, 10**uint256(token.decimals()));
1743         uint256 tokens = SafeMath.div(weiAmount, _convert_rate);
1744         require(tokens > 0);
1745         
1746         //do not need bonus of contrib amount calc
1747         // tokens = calcBonus(tokens, msg.value.div(10**uint256(token.decimals())));
1748 
1749         // update state
1750         weiRaised = SafeMath.add(weiRaised, msg.value);
1751 
1752         // token.mint(beneficiary, tokens);
1753         emit TokenPurchase(msg.sender, beneficiary, msg.value, tokens);
1754         updatePrice();
1755         // forwardFunds();
1756     }
1757 
1758 
1759     //to send tokens for bitcoin bakers and bounty
1760     function sendTokens(address _to, uint256 _amount) onlyOwner public {
1761         token.mint(_to, _amount);
1762     }
1763     //change owner for child contract
1764     function transferTokenOwnership(address _newOwner) onlyOwner public {
1765         token.transferOwnership(_newOwner);
1766     }
1767 
1768     // send ether to the fund collection wallet
1769     // override to create custom fund forwarding mechanisms
1770     function forwardFunds() internal {
1771         wallet.transfer(address(this).balance);
1772     }
1773 
1774     // @return true if the transaction can buy tokens
1775     function validPurchase() internal constant returns (bool) {
1776         bool hardCapOk = token.totalSupply() < SafeMath.mul(hardCap, 10**uint256(token.decimals()));
1777        // bool withinPrivateSalePeriod = now >= PrivateSaleStartTime && now <= PrivateSaleEndTime;
1778         bool withinICOPeriod = now >= ICOStartTime && now <= ICOEndTime;
1779         bool nonZeroPurchase = msg.value != 0;
1780         
1781         // private-sale hardcap
1782         uint256 total_tokens = SafeMath.div(totalTokenSupply(), token.decimals());
1783         // if (withinPrivateSalePeriod && total_tokens >= 30000000)
1784         // {
1785         //     stopPrivateSale();
1786         //     return false;
1787         // }
1788         
1789         // return hardCapOk && (withinICOPeriod || withinPrivateSalePeriod) && nonZeroPurchase;
1790          return hardCapOk && withinICOPeriod && nonZeroPurchase;
1791     }
1792     
1793     // total supply of tokens
1794     function totalTokenSupply() public view returns (uint256) {
1795         return token.totalSupply();
1796     }
1797 }