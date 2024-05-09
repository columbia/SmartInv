1 pragma solidity ^0.4.25;
2 
3 contract ERC20Basic {
4   function totalSupply() public view returns (uint256);
5   function balanceOf(address who) public view returns (uint256);
6   function transfer(address to, uint256 value) public returns (bool);
7   event Transfer(address indexed from, address indexed to, uint256 value);
8 }
9 
10 /**
11  * @title ERC20 interface
12  * @dev see https://github.com/ethereum/EIPs/issues/20
13  */
14 contract ERC20 is ERC20Basic {
15   function allowance(address owner, address spender) public view returns (uint256);
16   function transferFrom(address from, address to, uint256 value) public returns (bool);
17   function approve(address spender, uint256 value) public returns (bool);
18   event Approval(address indexed owner, address indexed spender, uint256 value);
19 }
20 
21 /**
22  * @title SafeMath
23  * @dev Math operations with safety checks that throw on error
24  */
25 library SafeMath {
26 
27   /**
28   * @dev Multiplies two numbers, throws on overflow.
29   */
30   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
31     if (a == 0) {
32       return 0;
33     }
34     c = a * b;
35     assert(c / a == b);
36     return c;
37   }
38 
39   /**
40   * @dev Integer division of two numbers, truncating the quotient.
41   */
42   function div(uint256 a, uint256 b) internal pure returns (uint256) {
43     // assert(b > 0); // Solidity automatically throws when dividing by 0
44     // uint256 c = a / b;
45     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
46     return a / b;
47   }
48 
49   /**
50   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
51   */
52   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
53     assert(b <= a);
54     return a - b;
55   }
56 
57   /**
58   * @dev Adds two numbers, throws on overflow.
59   */
60   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
61     c = a + b;
62     assert(c >= a);
63     return c;
64   }
65 }
66 
67 /**
68  * @title Basic token
69  * @dev Basic version of StandardToken, with no allowances.
70  */
71 contract BasicToken is ERC20Basic {
72   using SafeMath for uint256;
73 
74   mapping(address => uint256) balances;
75 
76   uint256 totalSupply_;
77 
78   /**
79   * @dev total number of tokens in existence
80   */
81   function totalSupply() public view returns (uint256) {
82     return totalSupply_;
83   }
84 
85   /**
86   * @dev transfer token for a specified address
87   * @param _to The address to transfer to.
88   * @param _value The amount to be transferred.
89   */
90   function transfer(address _to, uint256 _value) public returns (bool) {
91     require(_to != address(0));
92     require(_value <= balances[msg.sender]);
93 
94     balances[msg.sender] = balances[msg.sender].sub(_value);
95     balances[_to] = balances[_to].add(_value);
96     emit Transfer(msg.sender, _to, _value);
97     return true;
98   }
99 
100   /**
101   * @dev Gets the balance of the specified address.
102   * @param _owner The address to query the the balance of.
103   * @return An uint256 representing the amount owned by the passed address.
104   */
105   function balanceOf(address _owner) public view returns (uint256) {
106     return balances[_owner];
107   }
108 
109 }
110 
111 /**
112  * @title Standard ERC20 token
113  *
114  * @dev Implementation of the basic standard token.
115  * @dev https://github.com/ethereum/EIPs/issues/20
116  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
117  */
118 contract StandardToken is ERC20, BasicToken {
119 
120   mapping (address => mapping (address => uint256)) internal allowed;
121 
122 
123   /**
124    * @dev Transfer tokens from one address to another
125    * @param _from address The address which you want to send tokens from
126    * @param _to address The address which you want to transfer to
127    * @param _value uint256 the amount of tokens to be transferred
128    */
129   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
130     require(_to != address(0));
131     require(_value <= balances[_from]);
132     require(_value <= allowed[_from][msg.sender]);
133 
134     balances[_from] = balances[_from].sub(_value);
135     balances[_to] = balances[_to].add(_value);
136     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
137     emit Transfer(_from, _to, _value);
138     return true;
139   }
140 
141   /**
142    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
143    *
144    * Beware that changing an allowance with this method brings the risk that someone may use both the old
145    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
146    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
147    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
148    * @param _spender The address which will spend the funds.
149    * @param _value The amount of tokens to be spent.
150    */
151   function approve(address _spender, uint256 _value) public returns (bool) {
152     allowed[msg.sender][_spender] = _value;
153     emit Approval(msg.sender, _spender, _value);
154     return true;
155   }
156 
157   /**
158    * @dev Function to check the amount of tokens that an owner allowed to a spender.
159    * @param _owner address The address which owns the funds.
160    * @param _spender address The address which will spend the funds.
161    * @return A uint256 specifying the amount of tokens still available for the spender.
162    */
163   function allowance(address _owner, address _spender) public view returns (uint256) {
164     return allowed[_owner][_spender];
165   }
166 
167   /**
168    * @dev Increase the amount of tokens that an owner allowed to a spender.
169    *
170    * approve should be called when allowed[_spender] == 0. To increment
171    * allowed value is better to use this function to avoid 2 calls (and wait until
172    * the first transaction is mined)
173    * From MonolithDAO Token.sol
174    * @param _spender The address which will spend the funds.
175    * @param _addedValue The amount of tokens to increase the allowance by.
176    */
177   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
178     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
179     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
180     return true;
181   }
182 
183   /**
184    * @dev Decrease the amount of tokens that an owner allowed to a spender.
185    *
186    * approve should be called when allowed[_spender] == 0. To decrement
187    * allowed value is better to use this function to avoid 2 calls (and wait until
188    * the first transaction is mined)
189    * From MonolithDAO Token.sol
190    * @param _spender The address which will spend the funds.
191    * @param _subtractedValue The amount of tokens to decrease the allowance by.
192    */
193   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
194     uint oldValue = allowed[msg.sender][_spender];
195     if (_subtractedValue > oldValue) {
196       allowed[msg.sender][_spender] = 0;
197     } else {
198       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
199     }
200     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
201     return true;
202   }
203 
204 }
205 
206 // <ORACLIZE_API>
207 // Release targetted at solc 0.4.25 to silence compiler warning/error messages, compatible down to 0.4.22
208 /*
209 Copyright (c) 2015-2016 Oraclize SRL
210 Copyright (c) 2016 Oraclize LTD
211 
212 
213 
214 Permission is hereby granted, free of charge, to any person obtaining a copy
215 of this software and associated documentation files (the "Software"), to deal
216 in the Software without restriction, including without limitation the rights
217 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
218 copies of the Software, and to permit persons to whom the Software is
219 furnished to do so, subject to the following conditions:
220 
221 
222 
223 The above copyright notice and this permission notice shall be included in
224 all copies or substantial portions of the Software.
225 
226 
227 
228 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
229 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
230 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
231 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
232 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
233 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
234 THE SOFTWARE.
235 */
236 
237 // This api is currently targeted at 0.4.22 to 0.4.25 (stable builds), please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
238 
239 pragma solidity >=0.4.22;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
240 
241 contract OraclizeI {
242     address public cbAddress;
243     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
244     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
245     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
246     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
247     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
248     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
249     function getPrice(string _datasource) public returns (uint _dsprice);
250     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
251     function setProofType(byte _proofType) external;
252     function setCustomGasPrice(uint _gasPrice) external;
253     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
254 }
255 
256 contract OraclizeAddrResolverI {
257     function getAddress() public returns (address _addr);
258 }
259 
260 /*
261 Begin solidity-cborutils
262 
263 https://github.com/smartcontractkit/solidity-cborutils
264 
265 MIT License
266 
267 Copyright (c) 2018 SmartContract ChainLink, Ltd.
268 
269 Permission is hereby granted, free of charge, to any person obtaining a copy
270 of this software and associated documentation files (the "Software"), to deal
271 in the Software without restriction, including without limitation the rights
272 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
273 copies of the Software, and to permit persons to whom the Software is
274 furnished to do so, subject to the following conditions:
275 
276 The above copyright notice and this permission notice shall be included in all
277 copies or substantial portions of the Software.
278 
279 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
280 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
281 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
282 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
283 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
284 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
285 SOFTWARE.
286  */
287 
288 library Buffer {
289     struct buffer {
290         bytes buf;
291         uint capacity;
292     }
293 
294     function init(buffer memory buf, uint _capacity) internal pure {
295         uint capacity = _capacity;
296         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
297         // Allocate space for the buffer data
298         buf.capacity = capacity;
299         assembly {
300             let ptr := mload(0x40)
301             mstore(buf, ptr)
302             mstore(ptr, 0)
303             mstore(0x40, add(ptr, capacity))
304         }
305     }
306 
307     function resize(buffer memory buf, uint capacity) private pure {
308         bytes memory oldbuf = buf.buf;
309         init(buf, capacity);
310         append(buf, oldbuf);
311     }
312 
313     function max(uint a, uint b) private pure returns(uint) {
314         if(a > b) {
315             return a;
316         }
317         return b;
318     }
319 
320     /**
321      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
322      *      would exceed the capacity of the buffer.
323      * @param buf The buffer to append to.
324      * @param data The data to append.
325      * @return The original buffer.
326      */
327     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
328         if(data.length + buf.buf.length > buf.capacity) {
329             resize(buf, max(buf.capacity, data.length) * 2);
330         }
331 
332         uint dest;
333         uint src;
334         uint len = data.length;
335         assembly {
336             // Memory address of the buffer data
337             let bufptr := mload(buf)
338             // Length of existing buffer data
339             let buflen := mload(bufptr)
340             // Start address = buffer address + buffer length + sizeof(buffer length)
341             dest := add(add(bufptr, buflen), 32)
342             // Update buffer length
343             mstore(bufptr, add(buflen, mload(data)))
344             src := add(data, 32)
345         }
346 
347         // Copy word-length chunks while possible
348         for(; len >= 32; len -= 32) {
349             assembly {
350                 mstore(dest, mload(src))
351             }
352             dest += 32;
353             src += 32;
354         }
355 
356         // Copy remaining bytes
357         uint mask = 256 ** (32 - len) - 1;
358         assembly {
359             let srcpart := and(mload(src), not(mask))
360             let destpart := and(mload(dest), mask)
361             mstore(dest, or(destpart, srcpart))
362         }
363 
364         return buf;
365     }
366 
367     /**
368      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
369      * exceed the capacity of the buffer.
370      * @param buf The buffer to append to.
371      * @param data The data to append.
372      * @return The original buffer.
373      */
374     function append(buffer memory buf, uint8 data) internal pure {
375         if(buf.buf.length + 1 > buf.capacity) {
376             resize(buf, buf.capacity * 2);
377         }
378 
379         assembly {
380             // Memory address of the buffer data
381             let bufptr := mload(buf)
382             // Length of existing buffer data
383             let buflen := mload(bufptr)
384             // Address = buffer address + buffer length + sizeof(buffer length)
385             let dest := add(add(bufptr, buflen), 32)
386             mstore8(dest, data)
387             // Update buffer length
388             mstore(bufptr, add(buflen, 1))
389         }
390     }
391 
392     /**
393      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
394      * exceed the capacity of the buffer.
395      * @param buf The buffer to append to.
396      * @param data The data to append.
397      * @return The original buffer.
398      */
399     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
400         if(len + buf.buf.length > buf.capacity) {
401             resize(buf, max(buf.capacity, len) * 2);
402         }
403 
404         uint mask = 256 ** len - 1;
405         assembly {
406             // Memory address of the buffer data
407             let bufptr := mload(buf)
408             // Length of existing buffer data
409             let buflen := mload(bufptr)
410             // Address = buffer address + buffer length + sizeof(buffer length) + len
411             let dest := add(add(bufptr, buflen), len)
412             mstore(dest, or(and(mload(dest), not(mask)), data))
413             // Update buffer length
414             mstore(bufptr, add(buflen, len))
415         }
416         return buf;
417     }
418 }
419 
420 library CBOR {
421     using Buffer for Buffer.buffer;
422 
423     uint8 private constant MAJOR_TYPE_INT = 0;
424     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
425     uint8 private constant MAJOR_TYPE_BYTES = 2;
426     uint8 private constant MAJOR_TYPE_STRING = 3;
427     uint8 private constant MAJOR_TYPE_ARRAY = 4;
428     uint8 private constant MAJOR_TYPE_MAP = 5;
429     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
430 
431     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
432         if(value <= 23) {
433             buf.append(uint8((major << 5) | value));
434         } else if(value <= 0xFF) {
435             buf.append(uint8((major << 5) | 24));
436             buf.appendInt(value, 1);
437         } else if(value <= 0xFFFF) {
438             buf.append(uint8((major << 5) | 25));
439             buf.appendInt(value, 2);
440         } else if(value <= 0xFFFFFFFF) {
441             buf.append(uint8((major << 5) | 26));
442             buf.appendInt(value, 4);
443         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
444             buf.append(uint8((major << 5) | 27));
445             buf.appendInt(value, 8);
446         }
447     }
448 
449     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
450         buf.append(uint8((major << 5) | 31));
451     }
452 
453     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
454         encodeType(buf, MAJOR_TYPE_INT, value);
455     }
456 
457     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
458         if(value >= 0) {
459             encodeType(buf, MAJOR_TYPE_INT, uint(value));
460         } else {
461             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
462         }
463     }
464 
465     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
466         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
467         buf.append(value);
468     }
469 
470     function encodeString(Buffer.buffer memory buf, string value) internal pure {
471         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
472         buf.append(bytes(value));
473     }
474 
475     function startArray(Buffer.buffer memory buf) internal pure {
476         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
477     }
478 
479     function startMap(Buffer.buffer memory buf) internal pure {
480         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
481     }
482 
483     function endSequence(Buffer.buffer memory buf) internal pure {
484         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
485     }
486 }
487 
488 /*
489 End solidity-cborutils
490  */
491 
492 contract usingOraclize {
493     uint constant day = 60*60*24;
494     uint constant week = 60*60*24*7;
495     uint constant month = 60*60*24*30;
496     byte constant proofType_NONE = 0x00;
497     byte constant proofType_TLSNotary = 0x10;
498     byte constant proofType_Ledger = 0x30;
499     byte constant proofType_Android = 0x40;
500     byte constant proofType_Native = 0xF0;
501     byte constant proofStorage_IPFS = 0x01;
502     uint8 constant networkID_auto = 0;
503     uint8 constant networkID_mainnet = 1;
504     uint8 constant networkID_testnet = 2;
505     uint8 constant networkID_morden = 2;
506     uint8 constant networkID_consensys = 161;
507 
508     OraclizeAddrResolverI OAR;
509 
510     OraclizeI oraclize;
511     modifier oraclizeAPI {
512         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
513             oraclize_setNetwork(networkID_auto);
514 
515         if(address(oraclize) != OAR.getAddress())
516             oraclize = OraclizeI(OAR.getAddress());
517 
518         _;
519     }
520     modifier coupon(string code){
521         oraclize = OraclizeI(OAR.getAddress());
522         _;
523     }
524 
525     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
526       return oraclize_setNetwork();
527       networkID; // silence the warning and remain backwards compatible
528     }
529     function oraclize_setNetwork() internal returns(bool){
530         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
531             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
532             oraclize_setNetworkName("eth_mainnet");
533             return true;
534         }
535         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
536             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
537             oraclize_setNetworkName("eth_ropsten3");
538             return true;
539         }
540         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
541             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
542             oraclize_setNetworkName("eth_kovan");
543             return true;
544         }
545         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
546             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
547             oraclize_setNetworkName("eth_rinkeby");
548             return true;
549         }
550         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
551             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
552             return true;
553         }
554         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
555             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
556             return true;
557         }
558         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
559             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
560             return true;
561         }
562         return false;
563     }
564 
565     function __callback(bytes32 myid, string result) public {
566         __callback(myid, result, new bytes(0));
567     }
568     function __callback(bytes32 myid, string result, bytes proof) public {
569       return;
570       // Following should never be reached with a preceding return, however
571       // this is just a placeholder function, ideally meant to be defined in
572       // child contract when proofs are used
573       myid; result; proof; // Silence compiler warnings
574       oraclize = OraclizeI(0); // Additional compiler silence about making function pure/view.
575     }
576 
577     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
578         return oraclize.getPrice(datasource);
579     }
580 
581     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
582         return oraclize.getPrice(datasource, gaslimit);
583     }
584 
585     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
586         uint price = oraclize.getPrice(datasource);
587         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
588         return oraclize.query.value(price)(0, datasource, arg);
589     }
590     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
591         uint price = oraclize.getPrice(datasource);
592         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
593         return oraclize.query.value(price)(timestamp, datasource, arg);
594     }
595     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
596         uint price = oraclize.getPrice(datasource, gaslimit);
597         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
598         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
599     }
600     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
601         uint price = oraclize.getPrice(datasource, gaslimit);
602         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
603         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
604     }
605     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
606         uint price = oraclize.getPrice(datasource);
607         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
608         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
609     }
610     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
611         uint price = oraclize.getPrice(datasource);
612         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
613         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
614     }
615     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
616         uint price = oraclize.getPrice(datasource, gaslimit);
617         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
618         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
619     }
620     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
621         uint price = oraclize.getPrice(datasource, gaslimit);
622         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
623         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
624     }
625     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
626         uint price = oraclize.getPrice(datasource);
627         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
628         bytes memory args = stra2cbor(argN);
629         return oraclize.queryN.value(price)(0, datasource, args);
630     }
631     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
632         uint price = oraclize.getPrice(datasource);
633         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
634         bytes memory args = stra2cbor(argN);
635         return oraclize.queryN.value(price)(timestamp, datasource, args);
636     }
637     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
638         uint price = oraclize.getPrice(datasource, gaslimit);
639         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
640         bytes memory args = stra2cbor(argN);
641         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
642     }
643     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
644         uint price = oraclize.getPrice(datasource, gaslimit);
645         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
646         bytes memory args = stra2cbor(argN);
647         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
648     }
649     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
650         string[] memory dynargs = new string[](1);
651         dynargs[0] = args[0];
652         return oraclize_query(datasource, dynargs);
653     }
654     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
655         string[] memory dynargs = new string[](1);
656         dynargs[0] = args[0];
657         return oraclize_query(timestamp, datasource, dynargs);
658     }
659     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
660         string[] memory dynargs = new string[](1);
661         dynargs[0] = args[0];
662         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
663     }
664     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
665         string[] memory dynargs = new string[](1);
666         dynargs[0] = args[0];
667         return oraclize_query(datasource, dynargs, gaslimit);
668     }
669 
670     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
671         string[] memory dynargs = new string[](2);
672         dynargs[0] = args[0];
673         dynargs[1] = args[1];
674         return oraclize_query(datasource, dynargs);
675     }
676     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
677         string[] memory dynargs = new string[](2);
678         dynargs[0] = args[0];
679         dynargs[1] = args[1];
680         return oraclize_query(timestamp, datasource, dynargs);
681     }
682     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
683         string[] memory dynargs = new string[](2);
684         dynargs[0] = args[0];
685         dynargs[1] = args[1];
686         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
687     }
688     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
689         string[] memory dynargs = new string[](2);
690         dynargs[0] = args[0];
691         dynargs[1] = args[1];
692         return oraclize_query(datasource, dynargs, gaslimit);
693     }
694     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
695         string[] memory dynargs = new string[](3);
696         dynargs[0] = args[0];
697         dynargs[1] = args[1];
698         dynargs[2] = args[2];
699         return oraclize_query(datasource, dynargs);
700     }
701     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
702         string[] memory dynargs = new string[](3);
703         dynargs[0] = args[0];
704         dynargs[1] = args[1];
705         dynargs[2] = args[2];
706         return oraclize_query(timestamp, datasource, dynargs);
707     }
708     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
709         string[] memory dynargs = new string[](3);
710         dynargs[0] = args[0];
711         dynargs[1] = args[1];
712         dynargs[2] = args[2];
713         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
714     }
715     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
716         string[] memory dynargs = new string[](3);
717         dynargs[0] = args[0];
718         dynargs[1] = args[1];
719         dynargs[2] = args[2];
720         return oraclize_query(datasource, dynargs, gaslimit);
721     }
722 
723     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
724         string[] memory dynargs = new string[](4);
725         dynargs[0] = args[0];
726         dynargs[1] = args[1];
727         dynargs[2] = args[2];
728         dynargs[3] = args[3];
729         return oraclize_query(datasource, dynargs);
730     }
731     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
732         string[] memory dynargs = new string[](4);
733         dynargs[0] = args[0];
734         dynargs[1] = args[1];
735         dynargs[2] = args[2];
736         dynargs[3] = args[3];
737         return oraclize_query(timestamp, datasource, dynargs);
738     }
739     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
740         string[] memory dynargs = new string[](4);
741         dynargs[0] = args[0];
742         dynargs[1] = args[1];
743         dynargs[2] = args[2];
744         dynargs[3] = args[3];
745         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
746     }
747     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
748         string[] memory dynargs = new string[](4);
749         dynargs[0] = args[0];
750         dynargs[1] = args[1];
751         dynargs[2] = args[2];
752         dynargs[3] = args[3];
753         return oraclize_query(datasource, dynargs, gaslimit);
754     }
755     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
756         string[] memory dynargs = new string[](5);
757         dynargs[0] = args[0];
758         dynargs[1] = args[1];
759         dynargs[2] = args[2];
760         dynargs[3] = args[3];
761         dynargs[4] = args[4];
762         return oraclize_query(datasource, dynargs);
763     }
764     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
765         string[] memory dynargs = new string[](5);
766         dynargs[0] = args[0];
767         dynargs[1] = args[1];
768         dynargs[2] = args[2];
769         dynargs[3] = args[3];
770         dynargs[4] = args[4];
771         return oraclize_query(timestamp, datasource, dynargs);
772     }
773     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
774         string[] memory dynargs = new string[](5);
775         dynargs[0] = args[0];
776         dynargs[1] = args[1];
777         dynargs[2] = args[2];
778         dynargs[3] = args[3];
779         dynargs[4] = args[4];
780         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
781     }
782     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
783         string[] memory dynargs = new string[](5);
784         dynargs[0] = args[0];
785         dynargs[1] = args[1];
786         dynargs[2] = args[2];
787         dynargs[3] = args[3];
788         dynargs[4] = args[4];
789         return oraclize_query(datasource, dynargs, gaslimit);
790     }
791     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
792         uint price = oraclize.getPrice(datasource);
793         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
794         bytes memory args = ba2cbor(argN);
795         return oraclize.queryN.value(price)(0, datasource, args);
796     }
797     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
798         uint price = oraclize.getPrice(datasource);
799         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
800         bytes memory args = ba2cbor(argN);
801         return oraclize.queryN.value(price)(timestamp, datasource, args);
802     }
803     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
804         uint price = oraclize.getPrice(datasource, gaslimit);
805         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
806         bytes memory args = ba2cbor(argN);
807         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
808     }
809     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
810         uint price = oraclize.getPrice(datasource, gaslimit);
811         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
812         bytes memory args = ba2cbor(argN);
813         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
814     }
815     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
816         bytes[] memory dynargs = new bytes[](1);
817         dynargs[0] = args[0];
818         return oraclize_query(datasource, dynargs);
819     }
820     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
821         bytes[] memory dynargs = new bytes[](1);
822         dynargs[0] = args[0];
823         return oraclize_query(timestamp, datasource, dynargs);
824     }
825     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
826         bytes[] memory dynargs = new bytes[](1);
827         dynargs[0] = args[0];
828         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
829     }
830     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
831         bytes[] memory dynargs = new bytes[](1);
832         dynargs[0] = args[0];
833         return oraclize_query(datasource, dynargs, gaslimit);
834     }
835 
836     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
837         bytes[] memory dynargs = new bytes[](2);
838         dynargs[0] = args[0];
839         dynargs[1] = args[1];
840         return oraclize_query(datasource, dynargs);
841     }
842     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
843         bytes[] memory dynargs = new bytes[](2);
844         dynargs[0] = args[0];
845         dynargs[1] = args[1];
846         return oraclize_query(timestamp, datasource, dynargs);
847     }
848     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
849         bytes[] memory dynargs = new bytes[](2);
850         dynargs[0] = args[0];
851         dynargs[1] = args[1];
852         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
853     }
854     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
855         bytes[] memory dynargs = new bytes[](2);
856         dynargs[0] = args[0];
857         dynargs[1] = args[1];
858         return oraclize_query(datasource, dynargs, gaslimit);
859     }
860     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
861         bytes[] memory dynargs = new bytes[](3);
862         dynargs[0] = args[0];
863         dynargs[1] = args[1];
864         dynargs[2] = args[2];
865         return oraclize_query(datasource, dynargs);
866     }
867     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
868         bytes[] memory dynargs = new bytes[](3);
869         dynargs[0] = args[0];
870         dynargs[1] = args[1];
871         dynargs[2] = args[2];
872         return oraclize_query(timestamp, datasource, dynargs);
873     }
874     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
875         bytes[] memory dynargs = new bytes[](3);
876         dynargs[0] = args[0];
877         dynargs[1] = args[1];
878         dynargs[2] = args[2];
879         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
880     }
881     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
882         bytes[] memory dynargs = new bytes[](3);
883         dynargs[0] = args[0];
884         dynargs[1] = args[1];
885         dynargs[2] = args[2];
886         return oraclize_query(datasource, dynargs, gaslimit);
887     }
888 
889     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
890         bytes[] memory dynargs = new bytes[](4);
891         dynargs[0] = args[0];
892         dynargs[1] = args[1];
893         dynargs[2] = args[2];
894         dynargs[3] = args[3];
895         return oraclize_query(datasource, dynargs);
896     }
897     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
898         bytes[] memory dynargs = new bytes[](4);
899         dynargs[0] = args[0];
900         dynargs[1] = args[1];
901         dynargs[2] = args[2];
902         dynargs[3] = args[3];
903         return oraclize_query(timestamp, datasource, dynargs);
904     }
905     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
906         bytes[] memory dynargs = new bytes[](4);
907         dynargs[0] = args[0];
908         dynargs[1] = args[1];
909         dynargs[2] = args[2];
910         dynargs[3] = args[3];
911         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
912     }
913     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
914         bytes[] memory dynargs = new bytes[](4);
915         dynargs[0] = args[0];
916         dynargs[1] = args[1];
917         dynargs[2] = args[2];
918         dynargs[3] = args[3];
919         return oraclize_query(datasource, dynargs, gaslimit);
920     }
921     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
922         bytes[] memory dynargs = new bytes[](5);
923         dynargs[0] = args[0];
924         dynargs[1] = args[1];
925         dynargs[2] = args[2];
926         dynargs[3] = args[3];
927         dynargs[4] = args[4];
928         return oraclize_query(datasource, dynargs);
929     }
930     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
931         bytes[] memory dynargs = new bytes[](5);
932         dynargs[0] = args[0];
933         dynargs[1] = args[1];
934         dynargs[2] = args[2];
935         dynargs[3] = args[3];
936         dynargs[4] = args[4];
937         return oraclize_query(timestamp, datasource, dynargs);
938     }
939     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
940         bytes[] memory dynargs = new bytes[](5);
941         dynargs[0] = args[0];
942         dynargs[1] = args[1];
943         dynargs[2] = args[2];
944         dynargs[3] = args[3];
945         dynargs[4] = args[4];
946         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
947     }
948     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
949         bytes[] memory dynargs = new bytes[](5);
950         dynargs[0] = args[0];
951         dynargs[1] = args[1];
952         dynargs[2] = args[2];
953         dynargs[3] = args[3];
954         dynargs[4] = args[4];
955         return oraclize_query(datasource, dynargs, gaslimit);
956     }
957 
958     function oraclize_cbAddress() oraclizeAPI internal returns (address){
959         return oraclize.cbAddress();
960     }
961     function oraclize_setProof(byte proofP) oraclizeAPI internal {
962         return oraclize.setProofType(proofP);
963     }
964     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
965         return oraclize.setCustomGasPrice(gasPrice);
966     }
967 
968     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
969         return oraclize.randomDS_getSessionPubKeyHash();
970     }
971 
972     function getCodeSize(address _addr) view internal returns(uint _size) {
973         assembly {
974             _size := extcodesize(_addr)
975         }
976     }
977 
978     function parseAddr(string _a) internal pure returns (address){
979         bytes memory tmp = bytes(_a);
980         uint160 iaddr = 0;
981         uint160 b1;
982         uint160 b2;
983         for (uint i=2; i<2+2*20; i+=2){
984             iaddr *= 256;
985             b1 = uint160(tmp[i]);
986             b2 = uint160(tmp[i+1]);
987             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
988             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
989             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
990             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
991             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
992             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
993             iaddr += (b1*16+b2);
994         }
995         return address(iaddr);
996     }
997 
998     function strCompare(string _a, string _b) internal pure returns (int) {
999         bytes memory a = bytes(_a);
1000         bytes memory b = bytes(_b);
1001         uint minLength = a.length;
1002         if (b.length < minLength) minLength = b.length;
1003         for (uint i = 0; i < minLength; i ++)
1004             if (a[i] < b[i])
1005                 return -1;
1006             else if (a[i] > b[i])
1007                 return 1;
1008         if (a.length < b.length)
1009             return -1;
1010         else if (a.length > b.length)
1011             return 1;
1012         else
1013             return 0;
1014     }
1015 
1016     function indexOf(string _haystack, string _needle) internal pure returns (int) {
1017         bytes memory h = bytes(_haystack);
1018         bytes memory n = bytes(_needle);
1019         if(h.length < 1 || n.length < 1 || (n.length > h.length))
1020             return -1;
1021         else if(h.length > (2**128 -1))
1022             return -1;
1023         else
1024         {
1025             uint subindex = 0;
1026             for (uint i = 0; i < h.length; i ++)
1027             {
1028                 if (h[i] == n[0])
1029                 {
1030                     subindex = 1;
1031                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
1032                     {
1033                         subindex++;
1034                     }
1035                     if(subindex == n.length)
1036                         return int(i);
1037                 }
1038             }
1039             return -1;
1040         }
1041     }
1042 
1043     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
1044         bytes memory _ba = bytes(_a);
1045         bytes memory _bb = bytes(_b);
1046         bytes memory _bc = bytes(_c);
1047         bytes memory _bd = bytes(_d);
1048         bytes memory _be = bytes(_e);
1049         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1050         bytes memory babcde = bytes(abcde);
1051         uint k = 0;
1052         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1053         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1054         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1055         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1056         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1057         return string(babcde);
1058     }
1059 
1060     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
1061         return strConcat(_a, _b, _c, _d, "");
1062     }
1063 
1064     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
1065         return strConcat(_a, _b, _c, "", "");
1066     }
1067 
1068     function strConcat(string _a, string _b) internal pure returns (string) {
1069         return strConcat(_a, _b, "", "", "");
1070     }
1071 
1072     // parseInt
1073     function parseInt(string _a) internal pure returns (uint) {
1074         return parseInt(_a, 0);
1075     }
1076 
1077     // parseInt(parseFloat*10^_b)
1078     function parseInt(string _a, uint _b) internal pure returns (uint) {
1079         bytes memory bresult = bytes(_a);
1080         uint mint = 0;
1081         bool decimals = false;
1082         for (uint i=0; i<bresult.length; i++){
1083             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
1084                 if (decimals){
1085                    if (_b == 0) break;
1086                     else _b--;
1087                 }
1088                 mint *= 10;
1089                 mint += uint(bresult[i]) - 48;
1090             } else if (bresult[i] == 46) decimals = true;
1091         }
1092         if (_b > 0) mint *= 10**_b;
1093         return mint;
1094     }
1095 
1096     function uint2str(uint i) internal pure returns (string){
1097         if (i == 0) return "0";
1098         uint j = i;
1099         uint len;
1100         while (j != 0){
1101             len++;
1102             j /= 10;
1103         }
1104         bytes memory bstr = new bytes(len);
1105         uint k = len - 1;
1106         while (i != 0){
1107             bstr[k--] = byte(48 + i % 10);
1108             i /= 10;
1109         }
1110         return string(bstr);
1111     }
1112 
1113     using CBOR for Buffer.buffer;
1114     function stra2cbor(string[] arr) internal pure returns (bytes) {
1115         safeMemoryCleaner();
1116         Buffer.buffer memory buf;
1117         Buffer.init(buf, 1024);
1118         buf.startArray();
1119         for (uint i = 0; i < arr.length; i++) {
1120             buf.encodeString(arr[i]);
1121         }
1122         buf.endSequence();
1123         return buf.buf;
1124     }
1125 
1126     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
1127         safeMemoryCleaner();
1128         Buffer.buffer memory buf;
1129         Buffer.init(buf, 1024);
1130         buf.startArray();
1131         for (uint i = 0; i < arr.length; i++) {
1132             buf.encodeBytes(arr[i]);
1133         }
1134         buf.endSequence();
1135         return buf.buf;
1136     }
1137 
1138     string oraclize_network_name;
1139     function oraclize_setNetworkName(string _network_name) internal {
1140         oraclize_network_name = _network_name;
1141     }
1142 
1143     function oraclize_getNetworkName() internal view returns (string) {
1144         return oraclize_network_name;
1145     }
1146 
1147     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1148         require((_nbytes > 0) && (_nbytes <= 32));
1149         // Convert from seconds to ledger timer ticks
1150         _delay *= 10;
1151         bytes memory nbytes = new bytes(1);
1152         nbytes[0] = byte(_nbytes);
1153         bytes memory unonce = new bytes(32);
1154         bytes memory sessionKeyHash = new bytes(32);
1155         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1156         assembly {
1157             mstore(unonce, 0x20)
1158             // the following variables can be relaxed
1159             // check relaxed random contract under ethereum-examples repo
1160             // for an idea on how to override and replace comit hash vars
1161             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1162             mstore(sessionKeyHash, 0x20)
1163             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1164         }
1165         bytes memory delay = new bytes(32);
1166         assembly {
1167             mstore(add(delay, 0x20), _delay)
1168         }
1169 
1170         bytes memory delay_bytes8 = new bytes(8);
1171         copyBytes(delay, 24, 8, delay_bytes8, 0);
1172 
1173         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1174         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1175 
1176         bytes memory delay_bytes8_left = new bytes(8);
1177 
1178         assembly {
1179             let x := mload(add(delay_bytes8, 0x20))
1180             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1181             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1182             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1183             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1184             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1185             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1186             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1187             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1188 
1189         }
1190 
1191         oraclize_randomDS_setCommitment(queryId, keccak256(abi.encodePacked(delay_bytes8_left, args[1], sha256(args[0]), args[2])));
1192         return queryId;
1193     }
1194 
1195     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1196         oraclize_randomDS_args[queryId] = commitment;
1197     }
1198 
1199     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1200     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1201 
1202     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1203         bool sigok;
1204         address signer;
1205 
1206         bytes32 sigr;
1207         bytes32 sigs;
1208 
1209         bytes memory sigr_ = new bytes(32);
1210         uint offset = 4+(uint(dersig[3]) - 0x20);
1211         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1212         bytes memory sigs_ = new bytes(32);
1213         offset += 32 + 2;
1214         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1215 
1216         assembly {
1217             sigr := mload(add(sigr_, 32))
1218             sigs := mload(add(sigs_, 32))
1219         }
1220 
1221 
1222         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1223         if (address(keccak256(pubkey)) == signer) return true;
1224         else {
1225             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1226             return (address(keccak256(pubkey)) == signer);
1227         }
1228     }
1229 
1230     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1231         bool sigok;
1232 
1233         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1234         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1235         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1236 
1237         bytes memory appkey1_pubkey = new bytes(64);
1238         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1239 
1240         bytes memory tosign2 = new bytes(1+65+32);
1241         tosign2[0] = byte(1); //role
1242         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1243         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1244         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1245         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1246 
1247         if (sigok == false) return false;
1248 
1249 
1250         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1251         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1252 
1253         bytes memory tosign3 = new bytes(1+65);
1254         tosign3[0] = 0xFE;
1255         copyBytes(proof, 3, 65, tosign3, 1);
1256 
1257         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1258         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1259 
1260         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1261 
1262         return sigok;
1263     }
1264 
1265     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1266         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1267         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1268 
1269         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1270         require(proofVerified);
1271 
1272         _;
1273     }
1274 
1275     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1276         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1277         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1278 
1279         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1280         if (proofVerified == false) return 2;
1281 
1282         return 0;
1283     }
1284 
1285     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1286         bool match_ = true;
1287 
1288         require(prefix.length == n_random_bytes);
1289 
1290         for (uint256 i=0; i< n_random_bytes; i++) {
1291             if (content[i] != prefix[i]) match_ = false;
1292         }
1293 
1294         return match_;
1295     }
1296 
1297     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1298 
1299         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1300         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1301         bytes memory keyhash = new bytes(32);
1302         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1303         if (!(keccak256(keyhash) == keccak256(abi.encodePacked(sha256(abi.encodePacked(context_name, queryId)))))) return false;
1304 
1305         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1306         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1307 
1308         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1309         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1310 
1311         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1312         // This is to verify that the computed args match with the ones specified in the query.
1313         bytes memory commitmentSlice1 = new bytes(8+1+32);
1314         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1315 
1316         bytes memory sessionPubkey = new bytes(64);
1317         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1318         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1319 
1320         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1321         if (oraclize_randomDS_args[queryId] == keccak256(abi.encodePacked(commitmentSlice1, sessionPubkeyHash))){ //unonce, nbytes and sessionKeyHash match
1322             delete oraclize_randomDS_args[queryId];
1323         } else return false;
1324 
1325 
1326         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1327         bytes memory tosign1 = new bytes(32+8+1+32);
1328         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1329         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1330 
1331         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1332         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1333             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1334         }
1335 
1336         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1337     }
1338 
1339     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1340     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1341         uint minLength = length + toOffset;
1342 
1343         // Buffer too small
1344         require(to.length >= minLength); // Should be a better way?
1345 
1346         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1347         uint i = 32 + fromOffset;
1348         uint j = 32 + toOffset;
1349 
1350         while (i < (32 + fromOffset + length)) {
1351             assembly {
1352                 let tmp := mload(add(from, i))
1353                 mstore(add(to, j), tmp)
1354             }
1355             i += 32;
1356             j += 32;
1357         }
1358 
1359         return to;
1360     }
1361 
1362     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1363     // Duplicate Solidity's ecrecover, but catching the CALL return value
1364     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1365         // We do our own memory management here. Solidity uses memory offset
1366         // 0x40 to store the current end of memory. We write past it (as
1367         // writes are memory extensions), but don't update the offset so
1368         // Solidity will reuse it. The memory used here is only needed for
1369         // this context.
1370 
1371         // FIXME: inline assembly can't access return values
1372         bool ret;
1373         address addr;
1374 
1375         assembly {
1376             let size := mload(0x40)
1377             mstore(size, hash)
1378             mstore(add(size, 32), v)
1379             mstore(add(size, 64), r)
1380             mstore(add(size, 96), s)
1381 
1382             // NOTE: we can reuse the request memory because we deal with
1383             //       the return code
1384             ret := call(3000, 1, 0, size, 128, size, 32)
1385             addr := mload(size)
1386         }
1387 
1388         return (ret, addr);
1389     }
1390 
1391     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1392     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1393         bytes32 r;
1394         bytes32 s;
1395         uint8 v;
1396 
1397         if (sig.length != 65)
1398           return (false, 0);
1399 
1400         // The signature format is a compact form of:
1401         //   {bytes32 r}{bytes32 s}{uint8 v}
1402         // Compact means, uint8 is not padded to 32 bytes.
1403         assembly {
1404             r := mload(add(sig, 32))
1405             s := mload(add(sig, 64))
1406 
1407             // Here we are loading the last 32 bytes. We exploit the fact that
1408             // 'mload' will pad with zeroes if we overread.
1409             // There is no 'mload8' to do this, but that would be nicer.
1410             v := byte(0, mload(add(sig, 96)))
1411 
1412             // Alternative solution:
1413             // 'byte' is not working due to the Solidity parser, so lets
1414             // use the second best option, 'and'
1415             // v := and(mload(add(sig, 65)), 255)
1416         }
1417 
1418         // albeit non-transactional signatures are not specified by the YP, one would expect it
1419         // to match the YP range of [27, 28]
1420         //
1421         // geth uses [0, 1] and some clients have followed. This might change, see:
1422         //  https://github.com/ethereum/go-ethereum/issues/2053
1423         if (v < 27)
1424           v += 27;
1425 
1426         if (v != 27 && v != 28)
1427             return (false, 0);
1428 
1429         return safer_ecrecover(hash, v, r, s);
1430     }
1431 
1432     function safeMemoryCleaner() internal pure {
1433         assembly {
1434             let fmem := mload(0x40)
1435             codecopy(fmem, codesize, sub(msize, fmem))
1436         }
1437     }
1438 
1439 }
1440 // </ORACLIZE_API>
1441 
1442 contract BayanToken is StandardToken, usingOraclize{
1443 
1444     /* Public variables of the token */
1445 
1446     /*
1447     NOTE:
1448     The following variables are OPTIONAL vanities. One does not have to include them.
1449     They allow one to customise the token contract & in no way influences the core functionality.
1450     Some wallets/interfaces might not even bother to look at this information.
1451     */
1452     string public name;                   //token name
1453     uint8 public decimals;                //How many decimals to show. ie. There could 1000 base units with 3 decimals. Meaning 0.980 SBX = 980 base units. It's like comparing 1 wei to 1 ether.
1454     string public symbol;                 //An identifier: eg SBX
1455     string public version = 'H1.0';       //human 0.1 standard. Just an arbitrary versioning scheme.
1456     string private confirmationUrl;
1457     uint256 private minRedeem;
1458     string requestUrl;
1459 
1460     struct Redeem {
1461         address sender;
1462         string email;
1463         uint256 amount;
1464         bool confirmed;
1465         string state;
1466         uint timestamp;
1467         string id;
1468     }
1469 
1470     mapping(bytes32 => Redeem) private proposedRedeem;
1471 
1472     constructor() public {
1473         totalSupply_ = 20000000000;                        // Update total supply (100000 for example)
1474         balances[msg.sender] = totalSupply_;               // Give the creator all initial tokens (100000 for example)
1475         emit Transfer(address(0), msg.sender, totalSupply_);
1476         name = "Bayan Token";                                   // Set the name for display purposes
1477         decimals = 2;                            // Amount of decimals for display purposes
1478         symbol = "BYT";                               // Set the symbol for display purposes
1479         confirmationUrl = "https://api.bizcloud.io/api/reg";
1480         minRedeem = 10;
1481     }
1482 
1483     /* contract must have eth to send oraclize query */
1484     function() public payable {}
1485 
1486     /* Approves and then calls the receiving contract */
1487     function approveAndCall(address _spender, uint256 _value, bytes _extraData) public returns (bool success) {
1488         allowed[msg.sender][_spender] = _value;
1489         emit Approval(msg.sender, _spender, _value);
1490 
1491         //call the receiveApproval function on the contract you want to be notified. This crafts the function signature manually so one doesn't have to include a contract in here just for this.
1492         //receiveApproval(address _from, uint256 _value, address _tokenContract, bytes _extraData)
1493         //it is assumed that when does this that the call *should* succeed, otherwise one would use vanilla approve instead.
1494         if(!_spender.call(bytes4(bytes32(keccak256("receiveApproval(address,uint256,address,bytes)"))), msg.sender, _value, this, _extraData)) { revert(); }
1495         return true;
1496     }
1497 
1498     event Burn(address indexed burner, uint256 value);
1499 
1500   /**
1501    * @dev Burns a specific amount of tokens.
1502    * @param _value The amount of token to be burned.
1503    */
1504   function burn(uint256 _value) public {
1505     _burn(msg.sender, _value);
1506   }
1507 
1508   function _burn(address _who, uint256 _value) internal {
1509     require(_value <= balances[_who]);
1510     // no need to require value <= totalSupply, since that would imply the
1511     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
1512 
1513     balances[_who] = balances[_who].sub(_value);
1514     totalSupply_ = totalSupply_.sub(_value);
1515     emit Burn(_who, _value);
1516     emit Transfer(_who, address(0), _value);
1517   }
1518 
1519   event newRedeemProposed(bytes32 _index);
1520   event newRedeemConfirmed(bytes32 _index);
1521   event newRedeemFailed(bytes32 _index);
1522 
1523   function __callback(bytes32 queryId, string result) public {
1524     //if (msg.sender != oraclize_cbAddress()) revert();
1525 
1526     uint256 resultInt = parseInt(result);
1527     Redeem storage redeem = proposedRedeem[queryId];
1528     redeem.confirmed = true;
1529 
1530     if (resultInt > 0){
1531         _burn(redeem.sender, redeem.amount);
1532         redeem.state = "success";
1533         emit newRedeemConfirmed(queryId);
1534      }else{
1535          redeem.state = "failed";
1536          emit newRedeemFailed(queryId);
1537     }
1538   }
1539 
1540   function redeem(string email, uint256 amount, string params) payable public returns (bytes32) {
1541     require(amount >= minRedeem);
1542     require(amount <= balances[msg.sender]);
1543 
1544     requestUrl = strConcat("json(", confirmationUrl, ").result");
1545     bytes32 queryId = oraclize_query("URL", requestUrl, params);
1546 
1547     proposedRedeem[queryId] = Redeem(msg.sender, email, amount, false, "pending", now, params);
1548     emit newRedeemProposed(queryId);
1549 
1550     return queryId;
1551   }
1552 
1553   function getRedeemState(bytes32 queryId) public view returns (string){
1554       return proposedRedeem[queryId].state;
1555   }
1556 
1557   function getRedeemAddress(bytes32 queryId) public view returns (address){
1558       return proposedRedeem[queryId].sender;
1559   }
1560 
1561 }