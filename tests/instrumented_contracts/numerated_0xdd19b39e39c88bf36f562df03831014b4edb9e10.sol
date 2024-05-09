1 pragma solidity ^0.4.18;
2 
3 // File: Ownable.sol
4 
5 /**
6  * @title Ownable
7  * @dev The Ownable contract has an owner address, and provides basic authorization control
8  * functions, this simplifies the implementation of "user permissions".
9  */
10 contract Ownable {
11   address public owner;
12 
13 
14   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
15 
16 
17   /**
18    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
19    * account.
20    */
21   function Ownable() public {
22     owner = msg.sender;
23   }
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33   /**
34    * @dev Allows the current owner to transfer control of the contract to a newOwner.
35    * @param newOwner The address to transfer ownership to.
36    */
37   function transferOwnership(address newOwner) public onlyOwner {
38     require(newOwner != address(0));
39     OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: Pausable.sol
46 
47 /**
48  * @title Pausable
49  * @dev Base contract which allows children to implement an emergency stop mechanism.
50  */
51 contract Pausable is Ownable {
52   event Pause();
53   event Unpause();
54 
55   bool public paused = false;
56 
57 
58   /**
59    * @dev Modifier to make a function callable only when the contract is not paused.
60    */
61   modifier whenNotPaused() {
62     require(!paused);
63     _;
64   }
65 
66   /**
67    * @dev Modifier to make a function callable only when the contract is paused.
68    */
69   modifier whenPaused() {
70     require(paused);
71     _;
72   }
73 
74   /**
75    * @dev called by the owner to pause, triggers stopped state
76    */
77   function pause() onlyOwner whenNotPaused public {
78     paused = true;
79     Pause();
80   }
81 
82   /**
83    * @dev called by the owner to unpause, returns to normal state
84    */
85   function unpause() onlyOwner whenPaused public {
86     paused = false;
87     Unpause();
88   }
89 }
90 
91 // File: ERC20Basic.sol
92 
93 /**
94  * @title ERC20Basic
95  * @dev Simpler version of ERC20 interface
96  * @dev see https://github.com/ethereum/EIPs/issues/179
97  */
98 contract ERC20Basic {
99   function totalSupply() public view returns (uint256);
100   function balanceOf(address who) public view returns (uint256);
101   function transfer(address to, uint256 value) public returns (bool);
102   event Transfer(address indexed from, address indexed to, uint256 value);
103 }
104 
105 // File: SafeMath.sol
106 
107 /**
108  * @title SafeMath
109  * @dev Math operations with safety checks that throw on error
110  */
111 library SafeMath {
112 
113   /**
114   * @dev Multiplies two numbers, throws on overflow.
115   */
116   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
117     if (a == 0) {
118       return 0;
119     }
120     uint256 c = a * b;
121     assert(c / a == b);
122     return c;
123   }
124 
125   /**
126   * @dev Integer division of two numbers, truncating the quotient.
127   */
128   function div(uint256 a, uint256 b) internal pure returns (uint256) {
129     // assert(b > 0); // Solidity automatically throws when dividing by 0
130     uint256 c = a / b;
131     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
132     return c;
133   }
134 
135   /**
136   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
137   */
138   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
139     assert(b <= a);
140     return a - b;
141   }
142 
143   /**
144   * @dev Adds two numbers, throws on overflow.
145   */
146   function add(uint256 a, uint256 b) internal pure returns (uint256) {
147     uint256 c = a + b;
148     assert(c >= a);
149     return c;
150   }
151 }
152 
153 // File: BasicToken.sol
154 
155 /**
156  * @title Basic token
157  * @dev Basic version of StandardToken, with no allowances.
158  */
159 contract BasicToken is ERC20Basic {
160   using SafeMath for uint256;
161 
162   mapping(address => uint256) balances;
163 
164   uint256 totalSupply_;
165 
166   /**
167   * @dev total number of tokens in existence
168   */
169   function totalSupply() public view returns (uint256) {
170     return totalSupply_;
171   }
172 
173   /**
174   * @dev transfer token for a specified address
175   * @param _to The address to transfer to.
176   * @param _value The amount to be transferred.
177   */
178   function transfer(address _to, uint256 _value) public returns (bool) {
179     require(_to != address(0));
180     require(_value <= balances[msg.sender]);
181 
182     // SafeMath.sub will throw if there is not enough balance.
183     balances[msg.sender] = balances[msg.sender].sub(_value);
184     balances[_to] = balances[_to].add(_value);
185     Transfer(msg.sender, _to, _value);
186     return true;
187   }
188 
189   /**
190   * @dev Gets the balance of the specified address.
191   * @param _owner The address to query the the balance of.
192   * @return An uint256 representing the amount owned by the passed address.
193   */
194   function balanceOf(address _owner) public view returns (uint256 balance) {
195     return balances[_owner];
196   }
197 
198 }
199 
200 // File: ERC20.sol
201 
202 /**
203  * @title ERC20 interface
204  * @dev see https://github.com/ethereum/EIPs/issues/20
205  */
206 contract ERC20 is ERC20Basic {
207   function allowance(address owner, address spender) public view returns (uint256);
208   function transferFrom(address from, address to, uint256 value) public returns (bool);
209   function approve(address spender, uint256 value) public returns (bool);
210   event Approval(address indexed owner, address indexed spender, uint256 value);
211 }
212 
213 // File: StandardToken.sol
214 
215 /**
216  * @title Standard ERC20 token
217  *
218  * @dev Implementation of the basic standard token.
219  * @dev https://github.com/ethereum/EIPs/issues/20
220  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
221  */
222 contract StandardToken is ERC20, BasicToken {
223 
224   mapping (address => mapping (address => uint256)) internal allowed;
225 
226 
227   /**
228    * @dev Transfer tokens from one address to another
229    * @param _from address The address which you want to send tokens from
230    * @param _to address The address which you want to transfer to
231    * @param _value uint256 the amount of tokens to be transferred
232    */
233   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
234     require(_to != address(0));
235     require(_value <= balances[_from]);
236     require(_value <= allowed[_from][msg.sender]);
237 
238     balances[_from] = balances[_from].sub(_value);
239     balances[_to] = balances[_to].add(_value);
240     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
241     Transfer(_from, _to, _value);
242     return true;
243   }
244 
245   /**
246    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
247    *
248    * Beware that changing an allowance with this method brings the risk that someone may use both the old
249    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
250    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
251    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
252    * @param _spender The address which will spend the funds.
253    * @param _value The amount of tokens to be spent.
254    */
255   function approve(address _spender, uint256 _value) public returns (bool) {
256     allowed[msg.sender][_spender] = _value;
257     Approval(msg.sender, _spender, _value);
258     return true;
259   }
260 
261   /**
262    * @dev Function to check the amount of tokens that an owner allowed to a spender.
263    * @param _owner address The address which owns the funds.
264    * @param _spender address The address which will spend the funds.
265    * @return A uint256 specifying the amount of tokens still available for the spender.
266    */
267   function allowance(address _owner, address _spender) public view returns (uint256) {
268     return allowed[_owner][_spender];
269   }
270 
271   /**
272    * @dev Increase the amount of tokens that an owner allowed to a spender.
273    *
274    * approve should be called when allowed[_spender] == 0. To increment
275    * allowed value is better to use this function to avoid 2 calls (and wait until
276    * the first transaction is mined)
277    * From MonolithDAO Token.sol
278    * @param _spender The address which will spend the funds.
279    * @param _addedValue The amount of tokens to increase the allowance by.
280    */
281   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
282     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
283     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
284     return true;
285   }
286 
287   /**
288    * @dev Decrease the amount of tokens that an owner allowed to a spender.
289    *
290    * approve should be called when allowed[_spender] == 0. To decrement
291    * allowed value is better to use this function to avoid 2 calls (and wait until
292    * the first transaction is mined)
293    * From MonolithDAO Token.sol
294    * @param _spender The address which will spend the funds.
295    * @param _subtractedValue The amount of tokens to decrease the allowance by.
296    */
297   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
298     uint oldValue = allowed[msg.sender][_spender];
299     if (_subtractedValue > oldValue) {
300       allowed[msg.sender][_spender] = 0;
301     } else {
302       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
303     }
304     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
305     return true;
306   }
307 
308 }
309 
310 // File: PausableToken.sol
311 
312 /**
313  * @title Pausable token
314  * @dev StandardToken modified with pausable transfers.
315  **/
316 contract PausableToken is StandardToken, Pausable {
317 
318   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
319     return super.transfer(_to, _value);
320   }
321 
322   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
323     return super.transferFrom(_from, _to, _value);
324   }
325 
326   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
327     return super.approve(_spender, _value);
328   }
329 
330   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
331     return super.increaseApproval(_spender, _addedValue);
332   }
333 
334   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
335     return super.decreaseApproval(_spender, _subtractedValue);
336   }
337 }
338 
339 // File: MintableToken.sol
340 
341 /**
342  * @title Mintable token
343  * @dev Simple ERC20 Token example, with mintable token creation
344  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
345  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
346  */
347 contract MintableToken is Ownable, PausableToken  {
348   event Mint(address indexed to, uint256 amount);
349   event MintFinished();
350   
351   string public constant name = "Mindmap";
352   string public constant symbol = "MIND";
353   uint8 public constant decimals = 18;  // 18 is the most common number of decimal places
354   
355   bool public mintingFinished = false;
356 
357 
358   modifier canMint() {
359     require(!mintingFinished);
360     _;
361   }
362 
363   /**
364    * @dev Function to mint tokens
365    * @param _to The address that will receive the minted tokens.
366    * @param _amount The amount of tokens to mint.
367    * @return A boolean that indicates if the operation was successful.
368    */
369   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
370     totalSupply_ = totalSupply_.add(_amount);
371     balances[_to] = balances[_to].add(_amount);
372     Mint(_to, _amount);
373     Transfer(address(0), _to, _amount);
374     return true;
375   }
376 
377   /**
378    * @dev Function to stop minting new tokens.
379    * @return True if the operation was successful.
380    */
381   function finishMinting() onlyOwner canMint public returns (bool) {
382     mintingFinished = true;
383     MintFinished();
384     return true;
385   }
386 }
387 
388 // File: oraclizeAPI.sol
389 
390 // <ORACLIZE_API>
391 /*
392 Copyright (c) 2015-2016 Oraclize SRL
393 Copyright (c) 2016 Oraclize LTD
394 
395 
396 
397 Permission is hereby granted, free of charge, to any person obtaining a copy
398 of this software and associated documentation files (the "Software"), to deal
399 in the Software without restriction, including without limitation the rights
400 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
401 copies of the Software, and to permit persons to whom the Software is
402 furnished to do so, subject to the following conditions:
403 
404 
405 
406 The above copyright notice and this permission notice shall be included in
407 all copies or substantial portions of the Software.
408 
409 
410 
411 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
412 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
413 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
414 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
415 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
416 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
417 THE SOFTWARE.
418 */
419 
420 pragma solidity >=0.4.1 <=0.4.20;// Incompatible compiler version... please select one stated within pragma solidity or use different oraclizeAPI version
421 
422 contract OraclizeI {
423     address public cbAddress;
424     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
425     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
426     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
427     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
428     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
429     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
430     function getPrice(string _datasource) returns (uint _dsprice);
431     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
432     function useCoupon(string _coupon);
433     function setProofType(byte _proofType);
434     function setConfig(bytes32 _config);
435     function setCustomGasPrice(uint _gasPrice);
436     function randomDS_getSessionPubKeyHash() returns(bytes32);
437 }
438 
439 contract OraclizeAddrResolverI {
440     function getAddress() returns (address _addr);
441 }
442 
443 /*
444 Begin solidity-cborutils
445 
446 https://github.com/smartcontractkit/solidity-cborutils
447 
448 MIT License
449 
450 Copyright (c) 2018 SmartContract ChainLink, Ltd.
451 
452 Permission is hereby granted, free of charge, to any person obtaining a copy
453 of this software and associated documentation files (the "Software"), to deal
454 in the Software without restriction, including without limitation the rights
455 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
456 copies of the Software, and to permit persons to whom the Software is
457 furnished to do so, subject to the following conditions:
458 
459 The above copyright notice and this permission notice shall be included in all
460 copies or substantial portions of the Software.
461 
462 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
463 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
464 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
465 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
466 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
467 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
468 SOFTWARE.
469  */
470 
471 library Buffer {
472     struct buffer {
473         bytes buf;
474         uint capacity;
475     }
476 
477     function init(buffer memory buf, uint capacity) internal constant {
478         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
479         // Allocate space for the buffer data
480         buf.capacity = capacity;
481         assembly {
482             let ptr := mload(0x40)
483             mstore(buf, ptr)
484             mstore(0x40, add(ptr, capacity))
485         }
486     }
487 
488     function resize(buffer memory buf, uint capacity) private constant {
489         bytes memory oldbuf = buf.buf;
490         init(buf, capacity);
491         append(buf, oldbuf);
492     }
493 
494     function max(uint a, uint b) private constant returns(uint) {
495         if(a > b) {
496             return a;
497         }
498         return b;
499     }
500 
501     /**
502      * @dev Appends a byte array to the end of the buffer. Reverts if doing so
503      *      would exceed the capacity of the buffer.
504      * @param buf The buffer to append to.
505      * @param data The data to append.
506      * @return The original buffer.
507      */
508     function append(buffer memory buf, bytes data) internal constant returns(buffer memory) {
509         if(data.length + buf.buf.length > buf.capacity) {
510             resize(buf, max(buf.capacity, data.length) * 2);
511         }
512 
513         uint dest;
514         uint src;
515         uint len = data.length;
516         assembly {
517             // Memory address of the buffer data
518             let bufptr := mload(buf)
519             // Length of existing buffer data
520             let buflen := mload(bufptr)
521             // Start address = buffer address + buffer length + sizeof(buffer length)
522             dest := add(add(bufptr, buflen), 32)
523             // Update buffer length
524             mstore(bufptr, add(buflen, mload(data)))
525             src := add(data, 32)
526         }
527 
528         // Copy word-length chunks while possible
529         for(; len >= 32; len -= 32) {
530             assembly {
531                 mstore(dest, mload(src))
532             }
533             dest += 32;
534             src += 32;
535         }
536 
537         // Copy remaining bytes
538         uint mask = 256 ** (32 - len) - 1;
539         assembly {
540             let srcpart := and(mload(src), not(mask))
541             let destpart := and(mload(dest), mask)
542             mstore(dest, or(destpart, srcpart))
543         }
544 
545         return buf;
546     }
547 
548     /**
549      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
550      * exceed the capacity of the buffer.
551      * @param buf The buffer to append to.
552      * @param data The data to append.
553      * @return The original buffer.
554      */
555     function append(buffer memory buf, uint8 data) internal constant {
556         if(buf.buf.length + 1 > buf.capacity) {
557             resize(buf, buf.capacity * 2);
558         }
559 
560         assembly {
561             // Memory address of the buffer data
562             let bufptr := mload(buf)
563             // Length of existing buffer data
564             let buflen := mload(bufptr)
565             // Address = buffer address + buffer length + sizeof(buffer length)
566             let dest := add(add(bufptr, buflen), 32)
567             mstore8(dest, data)
568             // Update buffer length
569             mstore(bufptr, add(buflen, 1))
570         }
571     }
572 
573     /**
574      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
575      * exceed the capacity of the buffer.
576      * @param buf The buffer to append to.
577      * @param data The data to append.
578      * @return The original buffer.
579      */
580     function appendInt(buffer memory buf, uint data, uint len) internal constant returns(buffer memory) {
581         if(len + buf.buf.length > buf.capacity) {
582             resize(buf, max(buf.capacity, len) * 2);
583         }
584 
585         uint mask = 256 ** len - 1;
586         assembly {
587             // Memory address of the buffer data
588             let bufptr := mload(buf)
589             // Length of existing buffer data
590             let buflen := mload(bufptr)
591             // Address = buffer address + buffer length + sizeof(buffer length) + len
592             let dest := add(add(bufptr, buflen), len)
593             mstore(dest, or(and(mload(dest), not(mask)), data))
594             // Update buffer length
595             mstore(bufptr, add(buflen, len))
596         }
597         return buf;
598     }
599 }
600 
601 library CBOR {
602     using Buffer for Buffer.buffer;
603 
604     uint8 private constant MAJOR_TYPE_INT = 0;
605     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
606     uint8 private constant MAJOR_TYPE_BYTES = 2;
607     uint8 private constant MAJOR_TYPE_STRING = 3;
608     uint8 private constant MAJOR_TYPE_ARRAY = 4;
609     uint8 private constant MAJOR_TYPE_MAP = 5;
610     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
611 
612     function shl8(uint8 x, uint8 y) private constant returns (uint8) {
613         return x * (2 ** y);
614     }
615 
616     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private constant {
617         if(value <= 23) {
618             buf.append(uint8(shl8(major, 5) | value));
619         } else if(value <= 0xFF) {
620             buf.append(uint8(shl8(major, 5) | 24));
621             buf.appendInt(value, 1);
622         } else if(value <= 0xFFFF) {
623             buf.append(uint8(shl8(major, 5) | 25));
624             buf.appendInt(value, 2);
625         } else if(value <= 0xFFFFFFFF) {
626             buf.append(uint8(shl8(major, 5) | 26));
627             buf.appendInt(value, 4);
628         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
629             buf.append(uint8(shl8(major, 5) | 27));
630             buf.appendInt(value, 8);
631         }
632     }
633 
634     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private constant {
635         buf.append(uint8(shl8(major, 5) | 31));
636     }
637 
638     function encodeUInt(Buffer.buffer memory buf, uint value) internal constant {
639         encodeType(buf, MAJOR_TYPE_INT, value);
640     }
641 
642     function encodeInt(Buffer.buffer memory buf, int value) internal constant {
643         if(value >= 0) {
644             encodeType(buf, MAJOR_TYPE_INT, uint(value));
645         } else {
646             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
647         }
648     }
649 
650     function encodeBytes(Buffer.buffer memory buf, bytes value) internal constant {
651         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
652         buf.append(value);
653     }
654 
655     function encodeString(Buffer.buffer memory buf, string value) internal constant {
656         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
657         buf.append(bytes(value));
658     }
659 
660     function startArray(Buffer.buffer memory buf) internal constant {
661         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
662     }
663 
664     function startMap(Buffer.buffer memory buf) internal constant {
665         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
666     }
667 
668     function endSequence(Buffer.buffer memory buf) internal constant {
669         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
670     }
671 }
672 
673 /*
674 End solidity-cborutils
675  */
676 
677 contract usingOraclize {
678     uint constant day = 60*60*24;
679     uint constant week = 60*60*24*7;
680     uint constant month = 60*60*24*30;
681     byte constant proofType_NONE = 0x00;
682     byte constant proofType_TLSNotary = 0x10;
683     byte constant proofType_Android = 0x20;
684     byte constant proofType_Ledger = 0x30;
685     byte constant proofType_Native = 0xF0;
686     byte constant proofStorage_IPFS = 0x01;
687     uint8 constant networkID_auto = 0;
688     uint8 constant networkID_mainnet = 1;
689     uint8 constant networkID_testnet = 2;
690     uint8 constant networkID_morden = 2;
691     uint8 constant networkID_consensys = 161;
692 
693     OraclizeAddrResolverI OAR;
694 
695     OraclizeI oraclize;
696     modifier oraclizeAPI {
697         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
698             oraclize_setNetwork(networkID_auto);
699 
700         if(address(oraclize) != OAR.getAddress())
701             oraclize = OraclizeI(OAR.getAddress());
702 
703         _;
704     }
705     modifier coupon(string code){
706         oraclize = OraclizeI(OAR.getAddress());
707         oraclize.useCoupon(code);
708         _;
709     }
710 
711     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
712         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
713             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
714             oraclize_setNetworkName("eth_mainnet");
715             return true;
716         }
717         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
718             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
719             oraclize_setNetworkName("eth_ropsten3");
720             return true;
721         }
722         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
723             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
724             oraclize_setNetworkName("eth_kovan");
725             return true;
726         }
727         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
728             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
729             oraclize_setNetworkName("eth_rinkeby");
730             return true;
731         }
732         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
733             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
734             return true;
735         }
736         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
737             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
738             return true;
739         }
740         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
741             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
742             return true;
743         }
744         return false;
745     }
746 
747     function __callback(bytes32 myid, string result) {
748         __callback(myid, result, new bytes(0));
749     }
750     function __callback(bytes32 myid, string result, bytes proof) {
751     }
752 
753     function oraclize_useCoupon(string code) oraclizeAPI internal {
754         oraclize.useCoupon(code);
755     }
756 
757     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
758         return oraclize.getPrice(datasource);
759     }
760 
761     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
762         return oraclize.getPrice(datasource, gaslimit);
763     }
764 
765     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
766         uint price = oraclize.getPrice(datasource);
767         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
768         return oraclize.query.value(price)(0, datasource, arg);
769     }
770     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
771         uint price = oraclize.getPrice(datasource);
772         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
773         return oraclize.query.value(price)(timestamp, datasource, arg);
774     }
775     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
776         uint price = oraclize.getPrice(datasource, gaslimit);
777         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
778         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
779     }
780     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
781         uint price = oraclize.getPrice(datasource, gaslimit);
782         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
783         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
784     }
785     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
786         uint price = oraclize.getPrice(datasource);
787         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
788         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
789     }
790     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
791         uint price = oraclize.getPrice(datasource);
792         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
793         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
794     }
795     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
796         uint price = oraclize.getPrice(datasource, gaslimit);
797         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
798         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
799     }
800     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
801         uint price = oraclize.getPrice(datasource, gaslimit);
802         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
803         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
804     }
805     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
806         uint price = oraclize.getPrice(datasource);
807         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
808         bytes memory args = stra2cbor(argN);
809         return oraclize.queryN.value(price)(0, datasource, args);
810     }
811     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
812         uint price = oraclize.getPrice(datasource);
813         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
814         bytes memory args = stra2cbor(argN);
815         return oraclize.queryN.value(price)(timestamp, datasource, args);
816     }
817     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
818         uint price = oraclize.getPrice(datasource, gaslimit);
819         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
820         bytes memory args = stra2cbor(argN);
821         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
822     }
823     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
824         uint price = oraclize.getPrice(datasource, gaslimit);
825         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
826         bytes memory args = stra2cbor(argN);
827         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
828     }
829     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
830         string[] memory dynargs = new string[](1);
831         dynargs[0] = args[0];
832         return oraclize_query(datasource, dynargs);
833     }
834     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
835         string[] memory dynargs = new string[](1);
836         dynargs[0] = args[0];
837         return oraclize_query(timestamp, datasource, dynargs);
838     }
839     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
840         string[] memory dynargs = new string[](1);
841         dynargs[0] = args[0];
842         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
843     }
844     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
845         string[] memory dynargs = new string[](1);
846         dynargs[0] = args[0];
847         return oraclize_query(datasource, dynargs, gaslimit);
848     }
849 
850     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
851         string[] memory dynargs = new string[](2);
852         dynargs[0] = args[0];
853         dynargs[1] = args[1];
854         return oraclize_query(datasource, dynargs);
855     }
856     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
857         string[] memory dynargs = new string[](2);
858         dynargs[0] = args[0];
859         dynargs[1] = args[1];
860         return oraclize_query(timestamp, datasource, dynargs);
861     }
862     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
863         string[] memory dynargs = new string[](2);
864         dynargs[0] = args[0];
865         dynargs[1] = args[1];
866         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
867     }
868     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
869         string[] memory dynargs = new string[](2);
870         dynargs[0] = args[0];
871         dynargs[1] = args[1];
872         return oraclize_query(datasource, dynargs, gaslimit);
873     }
874     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
875         string[] memory dynargs = new string[](3);
876         dynargs[0] = args[0];
877         dynargs[1] = args[1];
878         dynargs[2] = args[2];
879         return oraclize_query(datasource, dynargs);
880     }
881     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
882         string[] memory dynargs = new string[](3);
883         dynargs[0] = args[0];
884         dynargs[1] = args[1];
885         dynargs[2] = args[2];
886         return oraclize_query(timestamp, datasource, dynargs);
887     }
888     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
889         string[] memory dynargs = new string[](3);
890         dynargs[0] = args[0];
891         dynargs[1] = args[1];
892         dynargs[2] = args[2];
893         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
894     }
895     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
896         string[] memory dynargs = new string[](3);
897         dynargs[0] = args[0];
898         dynargs[1] = args[1];
899         dynargs[2] = args[2];
900         return oraclize_query(datasource, dynargs, gaslimit);
901     }
902 
903     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
904         string[] memory dynargs = new string[](4);
905         dynargs[0] = args[0];
906         dynargs[1] = args[1];
907         dynargs[2] = args[2];
908         dynargs[3] = args[3];
909         return oraclize_query(datasource, dynargs);
910     }
911     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
912         string[] memory dynargs = new string[](4);
913         dynargs[0] = args[0];
914         dynargs[1] = args[1];
915         dynargs[2] = args[2];
916         dynargs[3] = args[3];
917         return oraclize_query(timestamp, datasource, dynargs);
918     }
919     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
920         string[] memory dynargs = new string[](4);
921         dynargs[0] = args[0];
922         dynargs[1] = args[1];
923         dynargs[2] = args[2];
924         dynargs[3] = args[3];
925         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
926     }
927     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
928         string[] memory dynargs = new string[](4);
929         dynargs[0] = args[0];
930         dynargs[1] = args[1];
931         dynargs[2] = args[2];
932         dynargs[3] = args[3];
933         return oraclize_query(datasource, dynargs, gaslimit);
934     }
935     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
936         string[] memory dynargs = new string[](5);
937         dynargs[0] = args[0];
938         dynargs[1] = args[1];
939         dynargs[2] = args[2];
940         dynargs[3] = args[3];
941         dynargs[4] = args[4];
942         return oraclize_query(datasource, dynargs);
943     }
944     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
945         string[] memory dynargs = new string[](5);
946         dynargs[0] = args[0];
947         dynargs[1] = args[1];
948         dynargs[2] = args[2];
949         dynargs[3] = args[3];
950         dynargs[4] = args[4];
951         return oraclize_query(timestamp, datasource, dynargs);
952     }
953     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
954         string[] memory dynargs = new string[](5);
955         dynargs[0] = args[0];
956         dynargs[1] = args[1];
957         dynargs[2] = args[2];
958         dynargs[3] = args[3];
959         dynargs[4] = args[4];
960         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
961     }
962     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
963         string[] memory dynargs = new string[](5);
964         dynargs[0] = args[0];
965         dynargs[1] = args[1];
966         dynargs[2] = args[2];
967         dynargs[3] = args[3];
968         dynargs[4] = args[4];
969         return oraclize_query(datasource, dynargs, gaslimit);
970     }
971     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
972         uint price = oraclize.getPrice(datasource);
973         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
974         bytes memory args = ba2cbor(argN);
975         return oraclize.queryN.value(price)(0, datasource, args);
976     }
977     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
978         uint price = oraclize.getPrice(datasource);
979         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
980         bytes memory args = ba2cbor(argN);
981         return oraclize.queryN.value(price)(timestamp, datasource, args);
982     }
983     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
984         uint price = oraclize.getPrice(datasource, gaslimit);
985         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
986         bytes memory args = ba2cbor(argN);
987         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
988     }
989     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
990         uint price = oraclize.getPrice(datasource, gaslimit);
991         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
992         bytes memory args = ba2cbor(argN);
993         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
994     }
995     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
996         bytes[] memory dynargs = new bytes[](1);
997         dynargs[0] = args[0];
998         return oraclize_query(datasource, dynargs);
999     }
1000     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1001         bytes[] memory dynargs = new bytes[](1);
1002         dynargs[0] = args[0];
1003         return oraclize_query(timestamp, datasource, dynargs);
1004     }
1005     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1006         bytes[] memory dynargs = new bytes[](1);
1007         dynargs[0] = args[0];
1008         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1009     }
1010     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1011         bytes[] memory dynargs = new bytes[](1);
1012         dynargs[0] = args[0];
1013         return oraclize_query(datasource, dynargs, gaslimit);
1014     }
1015 
1016     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1017         bytes[] memory dynargs = new bytes[](2);
1018         dynargs[0] = args[0];
1019         dynargs[1] = args[1];
1020         return oraclize_query(datasource, dynargs);
1021     }
1022     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1023         bytes[] memory dynargs = new bytes[](2);
1024         dynargs[0] = args[0];
1025         dynargs[1] = args[1];
1026         return oraclize_query(timestamp, datasource, dynargs);
1027     }
1028     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1029         bytes[] memory dynargs = new bytes[](2);
1030         dynargs[0] = args[0];
1031         dynargs[1] = args[1];
1032         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1033     }
1034     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1035         bytes[] memory dynargs = new bytes[](2);
1036         dynargs[0] = args[0];
1037         dynargs[1] = args[1];
1038         return oraclize_query(datasource, dynargs, gaslimit);
1039     }
1040     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1041         bytes[] memory dynargs = new bytes[](3);
1042         dynargs[0] = args[0];
1043         dynargs[1] = args[1];
1044         dynargs[2] = args[2];
1045         return oraclize_query(datasource, dynargs);
1046     }
1047     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1048         bytes[] memory dynargs = new bytes[](3);
1049         dynargs[0] = args[0];
1050         dynargs[1] = args[1];
1051         dynargs[2] = args[2];
1052         return oraclize_query(timestamp, datasource, dynargs);
1053     }
1054     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1055         bytes[] memory dynargs = new bytes[](3);
1056         dynargs[0] = args[0];
1057         dynargs[1] = args[1];
1058         dynargs[2] = args[2];
1059         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1060     }
1061     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1062         bytes[] memory dynargs = new bytes[](3);
1063         dynargs[0] = args[0];
1064         dynargs[1] = args[1];
1065         dynargs[2] = args[2];
1066         return oraclize_query(datasource, dynargs, gaslimit);
1067     }
1068 
1069     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1070         bytes[] memory dynargs = new bytes[](4);
1071         dynargs[0] = args[0];
1072         dynargs[1] = args[1];
1073         dynargs[2] = args[2];
1074         dynargs[3] = args[3];
1075         return oraclize_query(datasource, dynargs);
1076     }
1077     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1078         bytes[] memory dynargs = new bytes[](4);
1079         dynargs[0] = args[0];
1080         dynargs[1] = args[1];
1081         dynargs[2] = args[2];
1082         dynargs[3] = args[3];
1083         return oraclize_query(timestamp, datasource, dynargs);
1084     }
1085     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1086         bytes[] memory dynargs = new bytes[](4);
1087         dynargs[0] = args[0];
1088         dynargs[1] = args[1];
1089         dynargs[2] = args[2];
1090         dynargs[3] = args[3];
1091         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1092     }
1093     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1094         bytes[] memory dynargs = new bytes[](4);
1095         dynargs[0] = args[0];
1096         dynargs[1] = args[1];
1097         dynargs[2] = args[2];
1098         dynargs[3] = args[3];
1099         return oraclize_query(datasource, dynargs, gaslimit);
1100     }
1101     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1102         bytes[] memory dynargs = new bytes[](5);
1103         dynargs[0] = args[0];
1104         dynargs[1] = args[1];
1105         dynargs[2] = args[2];
1106         dynargs[3] = args[3];
1107         dynargs[4] = args[4];
1108         return oraclize_query(datasource, dynargs);
1109     }
1110     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1111         bytes[] memory dynargs = new bytes[](5);
1112         dynargs[0] = args[0];
1113         dynargs[1] = args[1];
1114         dynargs[2] = args[2];
1115         dynargs[3] = args[3];
1116         dynargs[4] = args[4];
1117         return oraclize_query(timestamp, datasource, dynargs);
1118     }
1119     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1120         bytes[] memory dynargs = new bytes[](5);
1121         dynargs[0] = args[0];
1122         dynargs[1] = args[1];
1123         dynargs[2] = args[2];
1124         dynargs[3] = args[3];
1125         dynargs[4] = args[4];
1126         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1127     }
1128     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1129         bytes[] memory dynargs = new bytes[](5);
1130         dynargs[0] = args[0];
1131         dynargs[1] = args[1];
1132         dynargs[2] = args[2];
1133         dynargs[3] = args[3];
1134         dynargs[4] = args[4];
1135         return oraclize_query(datasource, dynargs, gaslimit);
1136     }
1137 
1138     function oraclize_cbAddress() oraclizeAPI internal returns (address){
1139         return oraclize.cbAddress();
1140     }
1141     function oraclize_setProof(byte proofP) oraclizeAPI internal {
1142         return oraclize.setProofType(proofP);
1143     }
1144     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
1145         return oraclize.setCustomGasPrice(gasPrice);
1146     }
1147     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
1148         return oraclize.setConfig(config);
1149     }
1150 
1151     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
1152         return oraclize.randomDS_getSessionPubKeyHash();
1153     }
1154 
1155     function getCodeSize(address _addr) constant internal returns(uint _size) {
1156         assembly {
1157             _size := extcodesize(_addr)
1158         }
1159     }
1160 
1161     function parseAddr(string _a) internal returns (address){
1162         bytes memory tmp = bytes(_a);
1163         uint160 iaddr = 0;
1164         uint160 b1;
1165         uint160 b2;
1166         for (uint i=2; i<2+2*20; i+=2){
1167             iaddr *= 256;
1168             b1 = uint160(tmp[i]);
1169             b2 = uint160(tmp[i+1]);
1170             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
1171             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
1172             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
1173             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
1174             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
1175             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
1176             iaddr += (b1*16+b2);
1177         }
1178         return address(iaddr);
1179     }
1180 
1181     function strCompare(string _a, string _b) internal returns (int) {
1182         bytes memory a = bytes(_a);
1183         bytes memory b = bytes(_b);
1184         uint minLength = a.length;
1185         if (b.length < minLength) minLength = b.length;
1186         for (uint i = 0; i < minLength; i ++)
1187             if (a[i] < b[i])
1188                 return -1;
1189             else if (a[i] > b[i])
1190                 return 1;
1191         if (a.length < b.length)
1192             return -1;
1193         else if (a.length > b.length)
1194             return 1;
1195         else
1196             return 0;
1197     }
1198 
1199     function indexOf(string _haystack, string _needle) internal returns (int) {
1200         bytes memory h = bytes(_haystack);
1201         bytes memory n = bytes(_needle);
1202         if(h.length < 1 || n.length < 1 || (n.length > h.length))
1203             return -1;
1204         else if(h.length > (2**128 -1))
1205             return -1;
1206         else
1207         {
1208             uint subindex = 0;
1209             for (uint i = 0; i < h.length; i ++)
1210             {
1211                 if (h[i] == n[0])
1212                 {
1213                     subindex = 1;
1214                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
1215                     {
1216                         subindex++;
1217                     }
1218                     if(subindex == n.length)
1219                         return int(i);
1220                 }
1221             }
1222             return -1;
1223         }
1224     }
1225 
1226     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
1227         bytes memory _ba = bytes(_a);
1228         bytes memory _bb = bytes(_b);
1229         bytes memory _bc = bytes(_c);
1230         bytes memory _bd = bytes(_d);
1231         bytes memory _be = bytes(_e);
1232         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1233         bytes memory babcde = bytes(abcde);
1234         uint k = 0;
1235         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1236         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1237         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1238         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1239         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1240         return string(babcde);
1241     }
1242 
1243     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
1244         return strConcat(_a, _b, _c, _d, "");
1245     }
1246 
1247     function strConcat(string _a, string _b, string _c) internal returns (string) {
1248         return strConcat(_a, _b, _c, "", "");
1249     }
1250 
1251     function strConcat(string _a, string _b) internal returns (string) {
1252         return strConcat(_a, _b, "", "", "");
1253     }
1254 
1255     // parseInt
1256     function parseInt(string _a) internal returns (uint) {
1257         return parseInt(_a, 0);
1258     }
1259 
1260     // parseInt(parseFloat*10^_b)
1261     function parseInt(string _a, uint _b) internal returns (uint) {
1262         bytes memory bresult = bytes(_a);
1263         uint mint = 0;
1264         bool decimals = false;
1265         for (uint i=0; i<bresult.length; i++){
1266             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
1267                 if (decimals){
1268                    if (_b == 0) break;
1269                     else _b--;
1270                 }
1271                 mint *= 10;
1272                 mint += uint(bresult[i]) - 48;
1273             } else if (bresult[i] == 46) decimals = true;
1274         }
1275         if (_b > 0) mint *= 10**_b;
1276         return mint;
1277     }
1278 
1279     function uint2str(uint i) internal returns (string){
1280         if (i == 0) return "0";
1281         uint j = i;
1282         uint len;
1283         while (j != 0){
1284             len++;
1285             j /= 10;
1286         }
1287         bytes memory bstr = new bytes(len);
1288         uint k = len - 1;
1289         while (i != 0){
1290             bstr[k--] = byte(48 + i % 10);
1291             i /= 10;
1292         }
1293         return string(bstr);
1294     }
1295 
1296     using CBOR for Buffer.buffer;
1297     function stra2cbor(string[] arr) internal constant returns (bytes) {
1298         Buffer.buffer memory buf;
1299         Buffer.init(buf, 1024);
1300         buf.startArray();
1301         for (uint i = 0; i < arr.length; i++) {
1302             buf.encodeString(arr[i]);
1303         }
1304         buf.endSequence();
1305         return buf.buf;
1306     }
1307 
1308     function ba2cbor(bytes[] arr) internal constant returns (bytes) {
1309         Buffer.buffer memory buf;
1310         Buffer.init(buf, 1024);
1311         buf.startArray();
1312         for (uint i = 0; i < arr.length; i++) {
1313             buf.encodeBytes(arr[i]);
1314         }
1315         buf.endSequence();
1316         return buf.buf;
1317     }
1318 
1319     string oraclize_network_name;
1320     function oraclize_setNetworkName(string _network_name) internal {
1321         oraclize_network_name = _network_name;
1322     }
1323 
1324     function oraclize_getNetworkName() internal returns (string) {
1325         return oraclize_network_name;
1326     }
1327 
1328     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1329         if ((_nbytes == 0)||(_nbytes > 32)) throw;
1330 	// Convert from seconds to ledger timer ticks
1331         _delay *= 10;
1332         bytes memory nbytes = new bytes(1);
1333         nbytes[0] = byte(_nbytes);
1334         bytes memory unonce = new bytes(32);
1335         bytes memory sessionKeyHash = new bytes(32);
1336         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1337         assembly {
1338             mstore(unonce, 0x20)
1339             // the following variables can be relaxed
1340             // check relaxed random contract under ethereum-examples repo
1341             // for an idea on how to override and replace comit hash vars
1342             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1343             mstore(sessionKeyHash, 0x20)
1344             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1345         }
1346         bytes memory delay = new bytes(32);
1347         assembly {
1348             mstore(add(delay, 0x20), _delay)
1349         }
1350 
1351         bytes memory delay_bytes8 = new bytes(8);
1352         copyBytes(delay, 24, 8, delay_bytes8, 0);
1353 
1354         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1355         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1356 
1357         bytes memory delay_bytes8_left = new bytes(8);
1358 
1359         assembly {
1360             let x := mload(add(delay_bytes8, 0x20))
1361             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1362             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1363             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1364             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1365             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1366             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1367             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1368             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1369 
1370         }
1371 
1372         oraclize_randomDS_setCommitment(queryId, sha3(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1373         return queryId;
1374     }
1375 
1376     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1377         oraclize_randomDS_args[queryId] = commitment;
1378     }
1379 
1380     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1381     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1382 
1383     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1384         bool sigok;
1385         address signer;
1386 
1387         bytes32 sigr;
1388         bytes32 sigs;
1389 
1390         bytes memory sigr_ = new bytes(32);
1391         uint offset = 4+(uint(dersig[3]) - 0x20);
1392         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1393         bytes memory sigs_ = new bytes(32);
1394         offset += 32 + 2;
1395         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1396 
1397         assembly {
1398             sigr := mload(add(sigr_, 32))
1399             sigs := mload(add(sigs_, 32))
1400         }
1401 
1402 
1403         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1404         if (address(sha3(pubkey)) == signer) return true;
1405         else {
1406             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1407             return (address(sha3(pubkey)) == signer);
1408         }
1409     }
1410 
1411     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1412         bool sigok;
1413 
1414         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1415         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1416         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1417 
1418         bytes memory appkey1_pubkey = new bytes(64);
1419         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1420 
1421         bytes memory tosign2 = new bytes(1+65+32);
1422         tosign2[0] = 1; //role
1423         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1424         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1425         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1426         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1427 
1428         if (sigok == false) return false;
1429 
1430 
1431         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1432         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1433 
1434         bytes memory tosign3 = new bytes(1+65);
1435         tosign3[0] = 0xFE;
1436         copyBytes(proof, 3, 65, tosign3, 1);
1437 
1438         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1439         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1440 
1441         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1442 
1443         return sigok;
1444     }
1445 
1446     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1447         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1448         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
1449 
1450         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1451         if (proofVerified == false) throw;
1452 
1453         _;
1454     }
1455 
1456     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1457         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1458         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1459 
1460         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1461         if (proofVerified == false) return 2;
1462 
1463         return 0;
1464     }
1465 
1466     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
1467         bool match_ = true;
1468 
1469 	if (prefix.length != n_random_bytes) throw;
1470 
1471         for (uint256 i=0; i< n_random_bytes; i++) {
1472             if (content[i] != prefix[i]) match_ = false;
1473         }
1474 
1475         return match_;
1476     }
1477 
1478     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1479 
1480         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1481         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1482         bytes memory keyhash = new bytes(32);
1483         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1484         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
1485 
1486         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1487         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1488 
1489         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1490         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1491 
1492         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1493         // This is to verify that the computed args match with the ones specified in the query.
1494         bytes memory commitmentSlice1 = new bytes(8+1+32);
1495         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1496 
1497         bytes memory sessionPubkey = new bytes(64);
1498         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1499         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1500 
1501         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1502         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1503             delete oraclize_randomDS_args[queryId];
1504         } else return false;
1505 
1506 
1507         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1508         bytes memory tosign1 = new bytes(32+8+1+32);
1509         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1510         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1511 
1512         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1513         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1514             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1515         }
1516 
1517         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1518     }
1519 
1520 
1521     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1522     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1523         uint minLength = length + toOffset;
1524 
1525         if (to.length < minLength) {
1526             // Buffer too small
1527             throw; // Should be a better way?
1528         }
1529 
1530         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1531         uint i = 32 + fromOffset;
1532         uint j = 32 + toOffset;
1533 
1534         while (i < (32 + fromOffset + length)) {
1535             assembly {
1536                 let tmp := mload(add(from, i))
1537                 mstore(add(to, j), tmp)
1538             }
1539             i += 32;
1540             j += 32;
1541         }
1542 
1543         return to;
1544     }
1545 
1546     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1547     // Duplicate Solidity's ecrecover, but catching the CALL return value
1548     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1549         // We do our own memory management here. Solidity uses memory offset
1550         // 0x40 to store the current end of memory. We write past it (as
1551         // writes are memory extensions), but don't update the offset so
1552         // Solidity will reuse it. The memory used here is only needed for
1553         // this context.
1554 
1555         // FIXME: inline assembly can't access return values
1556         bool ret;
1557         address addr;
1558 
1559         assembly {
1560             let size := mload(0x40)
1561             mstore(size, hash)
1562             mstore(add(size, 32), v)
1563             mstore(add(size, 64), r)
1564             mstore(add(size, 96), s)
1565 
1566             // NOTE: we can reuse the request memory because we deal with
1567             //       the return code
1568             ret := call(3000, 1, 0, size, 128, size, 32)
1569             addr := mload(size)
1570         }
1571 
1572         return (ret, addr);
1573     }
1574 
1575     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1576     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1577         bytes32 r;
1578         bytes32 s;
1579         uint8 v;
1580 
1581         if (sig.length != 65)
1582           return (false, 0);
1583 
1584         // The signature format is a compact form of:
1585         //   {bytes32 r}{bytes32 s}{uint8 v}
1586         // Compact means, uint8 is not padded to 32 bytes.
1587         assembly {
1588             r := mload(add(sig, 32))
1589             s := mload(add(sig, 64))
1590 
1591             // Here we are loading the last 32 bytes. We exploit the fact that
1592             // 'mload' will pad with zeroes if we overread.
1593             // There is no 'mload8' to do this, but that would be nicer.
1594             v := byte(0, mload(add(sig, 96)))
1595 
1596             // Alternative solution:
1597             // 'byte' is not working due to the Solidity parser, so lets
1598             // use the second best option, 'and'
1599             // v := and(mload(add(sig, 65)), 255)
1600         }
1601 
1602         // albeit non-transactional signatures are not specified by the YP, one would expect it
1603         // to match the YP range of [27, 28]
1604         //
1605         // geth uses [0, 1] and some clients have followed. This might change, see:
1606         //  https://github.com/ethereum/go-ethereum/issues/2053
1607         if (v < 27)
1608           v += 27;
1609 
1610         if (v != 27 && v != 28)
1611             return (false, 0);
1612 
1613         return safer_ecrecover(hash, v, r, s);
1614     }
1615 
1616 }
1617 // </ORACLIZE_API>
1618 
1619 // File: Mindmap.sol
1620 
1621 //For production, change all days to days
1622 //Change and check days and discounts
1623 contract Mindmap_Token is Ownable, usingOraclize {
1624     using SafeMath for uint256;
1625 
1626     // The token being sold
1627     MintableToken public token;
1628 
1629     // start and end timestamps where investments are allowed (both inclusive)
1630     uint256 public PrivateSaleStartTime;
1631     uint256 public PrivateSaleEndTime;
1632     uint256 public PrivateSaleCents = 20;
1633     uint256 public PrivateSaleDays = 28;
1634 
1635     uint256 public PreICOStartTime;
1636     uint256 public PreICOEndTime;
1637     uint256 public PreICODayOneCents = 25;
1638     uint256 public PreICOCents = 30;
1639     uint256 public PreICODays = 31;
1640     uint256 public PreICOEarlyDays = 1;
1641     
1642     uint256 public ICOStartTime;
1643     uint256 public ICOEndTime;
1644     uint256 public ICOCents = 40;
1645     uint256 public ICODays = 60;
1646 
1647     uint256 public DefaultCents = 50;
1648 
1649     uint256 public FirstEtherLimit = 5;
1650     uint256 public FirstBonus = 120;
1651     uint256 public SecondEtherLimit = 10;
1652     uint256 public SecondBonus = 125;
1653     uint256 public ThirdEtherLimit = 15;
1654     uint256 public ThirdBonus = 135;
1655     
1656     uint256 public hardCap = 140000000;
1657     uint256 public purchased = 0;
1658     uint256 public gifted = 0;
1659 
1660     // address where funds are collected
1661     address public wallet;
1662 
1663     // how many token units a buyer gets per wei
1664     uint256 public rate;
1665     uint256 public weiRaised;
1666 
1667     /**
1668     * event for token purchase logging
1669     * @param purchaser who paid for the tokens
1670     * @param beneficiary who got the tokens
1671     * @param value weis paid for purchase
1672     * @param amount amount of tokens purchased
1673     */
1674     event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
1675     event newOraclizeQuery(string description);
1676 
1677     function Mindmap_Token(uint256 _rate, address _wallet) public {
1678         require(_rate > 0);
1679         require(_wallet != address(0));
1680 
1681         token = createTokenContract();
1682 
1683         rate = _rate;
1684         wallet = _wallet;
1685     }
1686 
1687     function startPrivateSale() onlyOwner public {
1688         PrivateSaleStartTime = now;
1689         PrivateSaleEndTime = PrivateSaleStartTime + PrivateSaleDays * 1 days;
1690     }
1691     function stopPrivateSale() onlyOwner public {
1692         PrivateSaleEndTime = now;
1693     }
1694     function startPreICO() onlyOwner public {
1695         PreICOStartTime = now;
1696         PreICOEndTime = PreICOStartTime + PreICODays * 1 days;
1697     }
1698     function stopPreICO() onlyOwner public {
1699         PreICOEndTime = now;
1700     }
1701     function startICO() onlyOwner public {
1702         ICOStartTime = now;
1703         ICOEndTime = ICOStartTime + ICODays * 1 days;
1704     }
1705     function stopICO() onlyOwner public {
1706         ICOEndTime = now;
1707     }
1708 
1709     // creates the token to be sold.
1710     // override this method to have crowdsale of a specific mintable token.
1711     function createTokenContract() internal returns (MintableToken) {
1712         return new MintableToken();
1713     }
1714 
1715     // fallback function can be used to buy tokens
1716     function () payable public {
1717         buyTokens(msg.sender);
1718     }
1719 
1720     //return token price in cents
1721     function getUSDPrice() public constant returns (uint256 cents_by_token) {
1722         if (PrivateSaleStartTime > 0 && PrivateSaleStartTime <= now && now < PrivateSaleEndTime ) 
1723         {
1724             return PrivateSaleCents;
1725         } 
1726         else if (PreICOStartTime > 0 && PreICOStartTime <= now && now < PreICOEndTime)
1727         {
1728             if (now < PreICOStartTime + PreICOEarlyDays * 1 days) 
1729                 return PreICODayOneCents;
1730             else 
1731                 return PreICOCents;
1732         }
1733         else if (ICOStartTime > 0 && ICOStartTime <= now && now < ICOEndTime)
1734         {
1735             return ICOCents;
1736         }
1737         else 
1738         {
1739             return DefaultCents;
1740         }
1741     }
1742     function calcBonus(uint256 tokens, uint256 ethers) public constant returns (uint256 tokens_with_bonus) {
1743         if (ethers >= ThirdEtherLimit)
1744             return tokens.mul(ThirdBonus).div(100);
1745         else if (ethers >= SecondEtherLimit)
1746             return tokens.mul(SecondBonus).div(100);
1747         else if (ethers >= FirstEtherLimit)
1748             return tokens.mul(FirstBonus).div(100);
1749         else
1750             return tokens;
1751     }
1752     // string 123.45 to 12345 converter
1753     function stringFloatToUnsigned(string _s) payable returns (string) {
1754         bytes memory _new_s = new bytes(bytes(_s).length - 1);
1755         uint k = 0;
1756 
1757         for (uint i = 0; i < bytes(_s).length; i++) {
1758             if (bytes(_s)[i] == '.') { break; } // 1
1759 
1760             _new_s[k] = bytes(_s)[i];
1761             k++;
1762         }
1763 
1764         return string(_new_s);
1765     }
1766     // callback for oraclize 
1767     function __callback(bytes32 myid, string result) {
1768          require(msg.sender == oraclize_cbAddress());
1769         string memory converted = stringFloatToUnsigned(result);
1770         rate = parseInt(converted);
1771         rate = SafeMath.div(1000000000000000000, rate); // price for 1 `usd` in `wei` 
1772     }
1773     // price updater 
1774     function updatePrice() payable {
1775         oraclize_setProof(proofType_NONE);
1776         if (oraclize_getPrice("URL") > this.balance) {
1777             newOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
1778         } else {
1779             newOraclizeQuery("Oraclize query was sent, standing by for the answer..");
1780             oraclize_query("URL", "json(https://min-api.cryptocompare.com/data/price?fsym=ETH&tsyms=USD).USD");
1781         }
1782     }
1783     // low level token purchase function
1784     function buyTokens(address beneficiary) public payable {
1785         require(beneficiary != address(0));
1786         require(validPurchase());
1787         require(msg.value >= 50000000000000000);  // minimum contrib amount 0.05 ETH
1788         
1789         updatePrice();
1790 
1791         uint256 _convert_rate = SafeMath.div(SafeMath.mul(rate, getUSDPrice()), 100);
1792 
1793         // calculate token amount to be created
1794         uint256 weiAmount = SafeMath.mul(msg.value, 10**uint256(token.decimals()));
1795         uint256 tokens = SafeMath.div(weiAmount, _convert_rate);
1796         tokens = calcBonus(tokens, msg.value.div(10**uint256(token.decimals())));
1797         require(validTokenAmount(tokens));
1798         // update state
1799         purchased = SafeMath.add(purchased, tokens);
1800         weiRaised = SafeMath.add(weiRaised, msg.value);
1801 
1802         token.mint(beneficiary, tokens);
1803         TokenPurchase(msg.sender, beneficiary, msg.value, tokens);
1804 
1805         forwardFunds();
1806     }
1807 
1808     //to set ico sale values if needed
1809     function setSaleLength(uint256 private_in_days, uint256 preico_early_days, uint256 preico_in_days, uint256 ico_in_days)
1810     onlyOwner public {
1811         PrivateSaleDays = private_in_days;
1812         PreICOEarlyDays = preico_early_days;
1813         PreICODays = preico_in_days;
1814         ICODays = ico_in_days;
1815         if(PrivateSaleEndTime != 0)
1816             PrivateSaleEndTime = PrivateSaleStartTime + PrivateSaleDays * 1 days;
1817         if(PreICOEndTime != 0)
1818             PreICOEndTime = PreICOStartTime + PreICODays * 1 days;
1819         if(ICOEndTime != 0)
1820             ICOEndTime = ICOStartTime + ICODays * 1 days;
1821     }
1822 
1823     function setDiscount(uint256 private_in_cents, uint256 preicodayone_in_cents, uint256 preico_in_cents, uint256 ico_in_cents, uint256 default_in_cents) onlyOwner public {
1824         //values in USD cents
1825         PrivateSaleCents = private_in_cents;
1826         PreICODayOneCents = preicodayone_in_cents;
1827         PreICOCents = preico_in_cents;
1828         ICOCents = ico_in_cents;
1829         DefaultCents = default_in_cents;
1830     }
1831     
1832     function setBonus(uint256 first_ether_limit, uint256 first_bonus, uint256 second_ether_limit, uint256 second_bonus, uint256 third_ether_limit, uint256 third_bonus) onlyOwner public {
1833         //values in Ether and X%+100
1834         FirstEtherLimit = first_ether_limit;
1835         FirstBonus = first_bonus;
1836         SecondEtherLimit = second_ether_limit;
1837         SecondBonus = second_bonus;
1838         ThirdEtherLimit = third_ether_limit;
1839         ThirdBonus = third_bonus;
1840     }
1841 
1842    // Upgrade token functions
1843     function freezeToken() onlyOwner public {
1844         token.pause();
1845     }
1846 
1847 
1848     function unfreezeToken() onlyOwner public {
1849         token.unpause();
1850     }
1851     
1852     //to send tokens for bitcoin bakers and bounty
1853     function sendTokens(address _to, uint256 _amount) onlyOwner public {
1854         require(token.totalSupply() + SafeMath.mul(_amount, 10**uint256(token.decimals())) <= SafeMath.mul(hardCap, 10**uint256(token.decimals())));
1855         gifted =  SafeMath.add(gifted, SafeMath.mul(_amount, 10**uint256(token.decimals())));
1856         token.mint(_to, SafeMath.mul(_amount, 10**uint256(token.decimals())));
1857     }
1858     
1859     //change owner for child contract
1860     function transferTokenOwnership(address _newOwner) onlyOwner public {
1861         token.transferOwnership(_newOwner);
1862     }
1863 
1864     // send ether to the fund collection wallet
1865     // override to create custom fund forwarding mechanisms
1866     function forwardFunds() internal {
1867         wallet.transfer(this.balance);
1868     }
1869     
1870     function validTokenAmount(uint256 tokenAmount) internal constant returns (bool) {
1871         require(tokenAmount > 0);
1872         bool tokenAmountOk = token.totalSupply() - gifted + tokenAmount <= ( SafeMath.mul(SafeMath.div(SafeMath.mul(hardCap,70), 100), 10**uint256(token.decimals())));
1873         return tokenAmountOk;
1874     }
1875 
1876     // @return true if the transaction can buy tokens
1877     function validPurchase() internal constant returns (bool) {
1878         bool hardCapOk = token.totalSupply() - gifted <= ( SafeMath.mul(SafeMath.div(SafeMath.mul(hardCap,70), 100), 10**uint256(token.decimals())));
1879         bool withinPrivateSalePeriod = now >= PrivateSaleStartTime && now <= PrivateSaleEndTime;
1880         bool withinPreICOPeriod = now >= PreICOStartTime && now <= PreICOEndTime;
1881         bool withinICOPeriod = now >= ICOStartTime && now <= ICOEndTime;
1882         bool nonZeroPurchase = msg.value != 0;
1883         return hardCapOk && (withinPreICOPeriod || withinICOPeriod || withinPrivateSalePeriod) && nonZeroPurchase;
1884     }
1885 }