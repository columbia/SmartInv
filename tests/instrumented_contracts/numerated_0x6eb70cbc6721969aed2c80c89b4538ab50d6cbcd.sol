1 pragma solidity 0.4.23;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 
45 /**
46  * @title SafeMath
47  * @dev Math operations with safety checks that throw on error
48  */
49 library SafeMath {
50 
51   /**
52   * @dev Multiplies two numbers, throws on overflow.
53   */
54   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
55     if (a == 0) {
56       return 0;
57     }
58     c = a * b;
59     assert(c / a == b);
60     return c;
61   }
62 
63   /**
64   * @dev Integer division of two numbers, truncating the quotient.
65   */
66   function div(uint256 a, uint256 b) internal pure returns (uint256) {
67     // assert(b > 0); // Solidity automatically throws when dividing by 0
68     // uint256 c = a / b;
69     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
70     return a / b;
71   }
72 
73   /**
74   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
75   */
76   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   /**
82   * @dev Adds two numbers, throws on overflow.
83   */
84   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
85     c = a + b;
86     assert(c >= a);
87     return c;
88   }
89 }
90 
91 
92 /**
93  * @title ERC20Basic
94  * @dev Simpler version of ERC20 interface
95  * @dev see https://github.com/ethereum/EIPs/issues/179
96  */
97 contract ERC20Basic {
98   function totalSupply() public view returns (uint256);
99   function balanceOf(address who) public view returns (uint256);
100   function transfer(address to, uint256 value) public returns (bool);
101   event Transfer(address indexed from, address indexed to, uint256 value);
102 }
103 
104 
105 /**
106  * @title ERC20 interface
107  * @dev see https://github.com/ethereum/EIPs/issues/20
108  */
109 contract ERC20 is ERC20Basic {
110   function allowance(address owner, address spender) public view returns (uint256);
111   function transferFrom(address from, address to, uint256 value) public returns (bool);
112   function approve(address spender, uint256 value) public returns (bool);
113   event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 
117 
118 
119 contract DetailedERC20 is ERC20 {
120   string public name;
121   string public symbol;
122   uint8 public decimals;
123 
124   function DetailedERC20(string _name, string _symbol, uint8 _decimals) public {
125     name = _name;
126     symbol = _symbol;
127     decimals = _decimals;
128   }
129 }
130 
131 /**
132  * @title Basic token
133  * @dev Basic version of StandardToken, with no allowances.
134  */
135 contract BasicToken is ERC20Basic {
136   using SafeMath for uint256;
137 
138   mapping(address => uint256) balances;
139 
140   uint256 totalSupply_;
141 
142   /**
143   * @dev total number of tokens in existence
144   */
145   function totalSupply() public view returns (uint256) {
146     return totalSupply_;
147   }
148 
149   /**
150   * @dev transfer token for a specified address
151   * @param _to The address to transfer to.
152   * @param _value The amount to be transferred.
153   */
154   function transfer(address _to, uint256 _value) public returns (bool) {
155     require(_to != address(0));
156     require(_value <= balances[msg.sender]);
157 
158     balances[msg.sender] = balances[msg.sender].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     emit Transfer(msg.sender, _to, _value);
161     return true;
162   }
163 
164   /**
165   * @dev Gets the balance of the specified address.
166   * @param _owner The address to query the the balance of.
167   * @return An uint256 representing the amount owned by the passed address.
168   */
169   function balanceOf(address _owner) public view returns (uint256) {
170     return balances[_owner];
171   }
172 
173 }
174 
175 
176 
177 
178 
179 
180 
181 /**
182  * @title Standard ERC20 token
183  *
184  * @dev Implementation of the basic standard token.
185  * @dev https://github.com/ethereum/EIPs/issues/20
186  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
187  */
188 contract StandardToken is ERC20, BasicToken {
189 
190   mapping (address => mapping (address => uint256)) internal allowed;
191 
192 
193   /**
194    * @dev Transfer tokens from one address to another
195    * @param _from address The address which you want to send tokens from
196    * @param _to address The address which you want to transfer to
197    * @param _value uint256 the amount of tokens to be transferred
198    */
199   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
200     require(_to != address(0));
201     require(_value <= balances[_from]);
202     require(_value <= allowed[_from][msg.sender]);
203 
204     balances[_from] = balances[_from].sub(_value);
205     balances[_to] = balances[_to].add(_value);
206     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
207     emit Transfer(_from, _to, _value);
208     return true;
209   }
210 
211   /**
212    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
213    *
214    * Beware that changing an allowance with this method brings the risk that someone may use both the old
215    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
216    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
217    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
218    * @param _spender The address which will spend the funds.
219    * @param _value The amount of tokens to be spent.
220    */
221   function approve(address _spender, uint256 _value) public returns (bool) {
222     allowed[msg.sender][_spender] = _value;
223     emit Approval(msg.sender, _spender, _value);
224     return true;
225   }
226 
227   /**
228    * @dev Function to check the amount of tokens that an owner allowed to a spender.
229    * @param _owner address The address which owns the funds.
230    * @param _spender address The address which will spend the funds.
231    * @return A uint256 specifying the amount of tokens still available for the spender.
232    */
233   function allowance(address _owner, address _spender) public view returns (uint256) {
234     return allowed[_owner][_spender];
235   }
236 
237   /**
238    * @dev Increase the amount of tokens that an owner allowed to a spender.
239    *
240    * approve should be called when allowed[_spender] == 0. To increment
241    * allowed value is better to use this function to avoid 2 calls (and wait until
242    * the first transaction is mined)
243    * From MonolithDAO Token.sol
244    * @param _spender The address which will spend the funds.
245    * @param _addedValue The amount of tokens to increase the allowance by.
246    */
247   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
248     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
249     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
250     return true;
251   }
252 
253   /**
254    * @dev Decrease the amount of tokens that an owner allowed to a spender.
255    *
256    * approve should be called when allowed[_spender] == 0. To decrement
257    * allowed value is better to use this function to avoid 2 calls (and wait until
258    * the first transaction is mined)
259    * From MonolithDAO Token.sol
260    * @param _spender The address which will spend the funds.
261    * @param _subtractedValue The amount of tokens to decrease the allowance by.
262    */
263   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
264     uint oldValue = allowed[msg.sender][_spender];
265     if (_subtractedValue > oldValue) {
266       allowed[msg.sender][_spender] = 0;
267     } else {
268       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
269     }
270     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
271     return true;
272   }
273 
274 }
275 
276 
277 
278 /**
279  * @title Burnable Token
280  * @dev Token that can be irreversibly burned (destroyed).
281  */
282 contract BurnableToken is BasicToken {
283 
284   event Burn(address indexed burner, uint256 value);
285 
286   /**
287    * @dev Burns a specific amount of tokens.
288    * @param _value The amount of token to be burned.
289    */
290   function burn(uint256 _value) public {
291     _burn(msg.sender, _value);
292   }
293 
294   function _burn(address _who, uint256 _value) internal {
295     require(_value <= balances[_who]);
296     // no need to require value <= totalSupply, since that would imply the
297     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
298 
299     balances[_who] = balances[_who].sub(_value);
300     totalSupply_ = totalSupply_.sub(_value);
301     emit Burn(_who, _value);
302     emit Transfer(_who, address(0), _value);
303   }
304 }
305 
306 
307 
308 
309 /**
310  * @title Mintable token
311  * @dev Simple ERC20 Token example, with mintable token creation
312  * @dev Issue: * https://github.com/OpenZeppelin/zeppelin-solidity/issues/120
313  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
314  */
315 contract MintableToken is StandardToken, Ownable {
316   event Mint(address indexed to, uint256 amount);
317   event MintFinished();
318 
319   bool public mintingFinished = false;
320 
321 
322   modifier canMint() {
323     require(!mintingFinished);
324     _;
325   }
326 
327   /**
328    * @dev Function to mint tokens
329    * @param _to The address that will receive the minted tokens.
330    * @param _amount The amount of tokens to mint.
331    * @return A boolean that indicates if the operation was successful.
332    */
333   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
334     totalSupply_ = totalSupply_.add(_amount);
335     balances[_to] = balances[_to].add(_amount);
336     emit Mint(_to, _amount);
337     emit Transfer(address(0), _to, _amount);
338     return true;
339   }
340 
341   /**
342    * @dev Function to stop minting new tokens.
343    * @return True if the operation was successful.
344    */
345   function finishMinting() onlyOwner canMint public returns (bool) {
346     mintingFinished = true;
347     emit MintFinished();
348     return true;
349   }
350 }
351 
352 
353 
354 
355 
356 
357 
358 /**
359  * @title Capped token
360  * @dev Mintable token with a token cap.
361  */
362 contract CappedToken is MintableToken {
363 
364   uint256 public cap;
365 
366   function CappedToken(uint256 _cap) public {
367     require(_cap > 0);
368     cap = _cap;
369   }
370 
371   /**
372    * @dev Function to mint tokens
373    * @param _to The address that will receive the minted tokens.
374    * @param _amount The amount of tokens to mint.
375    * @return A boolean that indicates if the operation was successful.
376    */
377   function mint(address _to, uint256 _amount) onlyOwner canMint public returns (bool) {
378     require(totalSupply_.add(_amount) <= cap);
379 
380     return super.mint(_to, _amount);
381   }
382 
383 }
384 
385 /**
386  * @title SafeERC20
387  * @dev Wrappers around ERC20 operations that throw on failure.
388  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
389  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
390  */
391 library SafeERC20 {
392   function safeTransfer(ERC20Basic token, address to, uint256 value) internal {
393     assert(token.transfer(to, value));
394   }
395 
396   function safeTransferFrom(
397     ERC20 token,
398     address from,
399     address to,
400     uint256 value
401   )
402     internal
403   {
404     assert(token.transferFrom(from, to, value));
405   }
406 
407   function safeApprove(ERC20 token, address spender, uint256 value) internal {
408     assert(token.approve(spender, value));
409   }
410 }
411 
412 
413 /**
414  * @title Token for Monoreto ICO
415  * @dev Monoreto ICO needs an ERC20 token
416  */
417 contract MonoretoToken is CappedToken {
418     using SafeMath for uint256;
419 
420     string public constant name = "Monoreto Token";
421     string public constant symbol = "MNR";
422     uint8 public constant decimals = 18;
423 
424     function MonoretoToken(uint256 _cap) public
425         CappedToken(_cap) {
426 
427     }
428 
429     bool public capAdjusted = false;
430 
431     function adjustCap() public onlyOwner {
432         require(!capAdjusted);
433         capAdjusted = true;
434 
435         uint256 percentToAdjust = 6;
436         uint256 oneHundredPercent = 100;
437         cap = totalSupply().mul(oneHundredPercent).div(percentToAdjust);
438     }
439 }
440 
441 // <ORACLIZE_API>
442 /*
443 Copyright (c) 2015-2016 Oraclize SRL
444 Copyright (c) 2016 Oraclize LTD
445 
446 
447 
448 Permission is hereby granted, free of charge, to any person obtaining a copy
449 of this software and associated documentation files (the "Software"), to deal
450 in the Software without restriction, including without limitation the rights
451 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
452 copies of the Software, and to permit persons to whom the Software is
453 furnished to do so, subject to the following conditions:
454 
455 
456 
457 The above copyright notice and this permission notice shall be included in
458 all copies or substantial portions of the Software.
459 
460 
461 
462 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
463 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
464 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
465 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
466 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
467 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
468 THE SOFTWARE.
469 */
470 
471 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
472 
473 
474 
475 contract OraclizeI {
476     address public cbAddress;
477     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
478     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
479     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
480     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
481     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
482     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
483     function getPrice(string _datasource) public returns (uint _dsprice);
484     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
485     function setProofType(byte _proofType) external;
486     function setCustomGasPrice(uint _gasPrice) external;
487     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
488 }
489 
490 contract OraclizeAddrResolverI {
491     function getAddress() public returns (address _addr);
492 }
493 
494 /*
495 Begin solidity-cborutils
496 
497 https://github.com/smartcontractkit/solidity-cborutils
498 
499 MIT License
500 
501 Copyright (c) 2018 SmartContract ChainLink, Ltd.
502 
503 Permission is hereby granted, free of charge, to any person obtaining a copy
504 of this software and associated documentation files (the "Software"), to deal
505 in the Software without restriction, including without limitation the rights
506 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
507 copies of the Software, and to permit persons to whom the Software is
508 furnished to do so, subject to the following conditions:
509 
510 The above copyright notice and this permission notice shall be included in all
511 copies or substantial portions of the Software.
512 
513 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
514 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
515 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
516 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
517 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
518 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
519 SOFTWARE.
520  */
521 
522 library Buffer {
523     struct buffer {
524         bytes buf;
525         uint capacity;
526     }
527 
528     function init(buffer memory buf, uint _capacity) internal pure {
529         uint capacity = _capacity;
530         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
531         // Allocate space for the buffer data
532         buf.capacity = capacity;
533         assembly {
534             let ptr := mload(0x40)
535             mstore(buf, ptr)
536             mstore(ptr, 0)
537             mstore(0x40, add(ptr, capacity))
538         }
539     }
540 
541     function resize(buffer memory buf, uint capacity) private pure {
542         bytes memory oldbuf = buf.buf;
543         init(buf, capacity);
544         append(buf, oldbuf);
545     }
546 
547     function max(uint a, uint b) private pure returns(uint) {
548         if(a > b) {
549             return a;
550         }
551         return b;
552     }
553 
554     /**
555      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
556      *      would exceed the capacity of the buffer.
557      * @param buf The buffer to append to.
558      * @param data The data to append.
559      * @return The original buffer.
560      */
561     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
562         if(data.length + buf.buf.length > buf.capacity) {
563             resize(buf, max(buf.capacity, data.length) * 2);
564         }
565 
566         uint dest;
567         uint src;
568         uint len = data.length;
569         assembly {
570             // Memory address of the buffer data
571             let bufptr := mload(buf)
572             // Length of existing buffer data
573             let buflen := mload(bufptr)
574             // Start address = buffer address + buffer length + sizeof(buffer length)
575             dest := add(add(bufptr, buflen), 32)
576             // Update buffer length
577             mstore(bufptr, add(buflen, mload(data)))
578             src := add(data, 32)
579         }
580 
581         // Copy word-length chunks while possible
582         for(; len >= 32; len -= 32) {
583             assembly {
584                 mstore(dest, mload(src))
585             }
586             dest += 32;
587             src += 32;
588         }
589 
590         // Copy remaining bytes
591         uint mask = 256 ** (32 - len) - 1;
592         assembly {
593             let srcpart := and(mload(src), not(mask))
594             let destpart := and(mload(dest), mask)
595             mstore(dest, or(destpart, srcpart))
596         }
597 
598         return buf;
599     }
600 
601     /**
602      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
603      * exceed the capacity of the buffer.
604      * @param buf The buffer to append to.
605      * @param data The data to append.
606      * @return The original buffer.
607      */
608     function append(buffer memory buf, uint8 data) internal pure {
609         if(buf.buf.length + 1 > buf.capacity) {
610             resize(buf, buf.capacity * 2);
611         }
612 
613         assembly {
614             // Memory address of the buffer data
615             let bufptr := mload(buf)
616             // Length of existing buffer data
617             let buflen := mload(bufptr)
618             // Address = buffer address + buffer length + sizeof(buffer length)
619             let dest := add(add(bufptr, buflen), 32)
620             mstore8(dest, data)
621             // Update buffer length
622             mstore(bufptr, add(buflen, 1))
623         }
624     }
625 
626     /**
627      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
628      * exceed the capacity of the buffer.
629      * @param buf The buffer to append to.
630      * @param data The data to append.
631      * @return The original buffer.
632      */
633     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
634         if(len + buf.buf.length > buf.capacity) {
635             resize(buf, max(buf.capacity, len) * 2);
636         }
637 
638         uint mask = 256 ** len - 1;
639         assembly {
640             // Memory address of the buffer data
641             let bufptr := mload(buf)
642             // Length of existing buffer data
643             let buflen := mload(bufptr)
644             // Address = buffer address + buffer length + sizeof(buffer length) + len
645             let dest := add(add(bufptr, buflen), len)
646             mstore(dest, or(and(mload(dest), not(mask)), data))
647             // Update buffer length
648             mstore(bufptr, add(buflen, len))
649         }
650         return buf;
651     }
652 }
653 
654 library CBOR {
655     using Buffer for Buffer.buffer;
656 
657     uint8 private constant MAJOR_TYPE_INT = 0;
658     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
659     uint8 private constant MAJOR_TYPE_BYTES = 2;
660     uint8 private constant MAJOR_TYPE_STRING = 3;
661     uint8 private constant MAJOR_TYPE_ARRAY = 4;
662     uint8 private constant MAJOR_TYPE_MAP = 5;
663     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
664 
665     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
666         if(value <= 23) {
667             buf.append(uint8((major << 5) | value));
668         } else if(value <= 0xFF) {
669             buf.append(uint8((major << 5) | 24));
670             buf.appendInt(value, 1);
671         } else if(value <= 0xFFFF) {
672             buf.append(uint8((major << 5) | 25));
673             buf.appendInt(value, 2);
674         } else if(value <= 0xFFFFFFFF) {
675             buf.append(uint8((major << 5) | 26));
676             buf.appendInt(value, 4);
677         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
678             buf.append(uint8((major << 5) | 27));
679             buf.appendInt(value, 8);
680         }
681     }
682 
683     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
684         buf.append(uint8((major << 5) | 31));
685     }
686 
687     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
688         encodeType(buf, MAJOR_TYPE_INT, value);
689     }
690 
691     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
692         if(value >= 0) {
693             encodeType(buf, MAJOR_TYPE_INT, uint(value));
694         } else {
695             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
696         }
697     }
698 
699     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
700         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
701         buf.append(value);
702     }
703 
704     function encodeString(Buffer.buffer memory buf, string value) internal pure {
705         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
706         buf.append(bytes(value));
707     }
708 
709     function startArray(Buffer.buffer memory buf) internal pure {
710         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
711     }
712 
713     function startMap(Buffer.buffer memory buf) internal pure {
714         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
715     }
716 
717     function endSequence(Buffer.buffer memory buf) internal pure {
718         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
719     }
720 }
721 
722 /*
723 End solidity-cborutils
724  */
725 
726 contract usingOraclize {
727     uint constant day = 60*60*24;
728     uint constant week = 60*60*24*7;
729     uint constant month = 60*60*24*30;
730     byte constant proofType_NONE = 0x00;
731     byte constant proofType_TLSNotary = 0x10;
732     byte constant proofType_Ledger = 0x30;
733     byte constant proofType_Android = 0x40;
734     byte constant proofType_Native = 0xF0;
735     byte constant proofStorage_IPFS = 0x01;
736     uint8 constant networkID_auto = 0;
737     uint8 constant networkID_mainnet = 1;
738     uint8 constant networkID_testnet = 2;
739     uint8 constant networkID_morden = 2;
740     uint8 constant networkID_consensys = 161;
741 
742     OraclizeAddrResolverI OAR;
743 
744     OraclizeI oraclize;
745     modifier oraclizeAPI {
746         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
747             oraclize_setNetwork(networkID_auto);
748 
749         if(address(oraclize) != OAR.getAddress())
750             oraclize = OraclizeI(OAR.getAddress());
751 
752         _;
753     }
754     modifier coupon(string code){
755         oraclize = OraclizeI(OAR.getAddress());
756         _;
757     }
758 
759     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
760       return oraclize_setNetwork();
761       networkID; // silence the warning and remain backwards compatible
762     }
763     function oraclize_setNetwork() internal returns(bool){
764         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
765             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
766             oraclize_setNetworkName("eth_mainnet");
767             return true;
768         }
769         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
770             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
771             oraclize_setNetworkName("eth_ropsten3");
772             return true;
773         }
774         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
775             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
776             oraclize_setNetworkName("eth_kovan");
777             return true;
778         }
779         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
780             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
781             oraclize_setNetworkName("eth_rinkeby");
782             return true;
783         }
784         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
785             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
786             return true;
787         }
788         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
789             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
790             return true;
791         }
792         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
793             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
794             return true;
795         }
796         return false;
797     }
798 
799     function __callback(bytes32 myid, string result) public {
800         __callback(myid, result, new bytes(0));
801     }
802     function __callback(bytes32 myid, string result, bytes proof) public {
803       return;
804       myid; result; proof; // Silence compiler warnings
805     }
806 
807     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
808         return oraclize.getPrice(datasource);
809     }
810 
811     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
812         return oraclize.getPrice(datasource, gaslimit);
813     }
814 
815     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
816         uint price = oraclize.getPrice(datasource);
817         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
818         return oraclize.query.value(price)(0, datasource, arg);
819     }
820     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
821         uint price = oraclize.getPrice(datasource);
822         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
823         return oraclize.query.value(price)(timestamp, datasource, arg);
824     }
825     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
826         uint price = oraclize.getPrice(datasource, gaslimit);
827         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
828         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
829     }
830     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
831         uint price = oraclize.getPrice(datasource, gaslimit);
832         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
833         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
834     }
835     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
836         uint price = oraclize.getPrice(datasource);
837         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
838         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
839     }
840     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
841         uint price = oraclize.getPrice(datasource);
842         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
843         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
844     }
845     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
846         uint price = oraclize.getPrice(datasource, gaslimit);
847         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
848         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
849     }
850     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
851         uint price = oraclize.getPrice(datasource, gaslimit);
852         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
853         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
854     }
855     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
856         uint price = oraclize.getPrice(datasource);
857         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
858         bytes memory args = stra2cbor(argN);
859         return oraclize.queryN.value(price)(0, datasource, args);
860     }
861     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
862         uint price = oraclize.getPrice(datasource);
863         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
864         bytes memory args = stra2cbor(argN);
865         return oraclize.queryN.value(price)(timestamp, datasource, args);
866     }
867     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
868         uint price = oraclize.getPrice(datasource, gaslimit);
869         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
870         bytes memory args = stra2cbor(argN);
871         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
872     }
873     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
874         uint price = oraclize.getPrice(datasource, gaslimit);
875         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
876         bytes memory args = stra2cbor(argN);
877         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
878     }
879     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
880         string[] memory dynargs = new string[](1);
881         dynargs[0] = args[0];
882         return oraclize_query(datasource, dynargs);
883     }
884     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
885         string[] memory dynargs = new string[](1);
886         dynargs[0] = args[0];
887         return oraclize_query(timestamp, datasource, dynargs);
888     }
889     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
890         string[] memory dynargs = new string[](1);
891         dynargs[0] = args[0];
892         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
893     }
894     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
895         string[] memory dynargs = new string[](1);
896         dynargs[0] = args[0];
897         return oraclize_query(datasource, dynargs, gaslimit);
898     }
899 
900     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
901         string[] memory dynargs = new string[](2);
902         dynargs[0] = args[0];
903         dynargs[1] = args[1];
904         return oraclize_query(datasource, dynargs);
905     }
906     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
907         string[] memory dynargs = new string[](2);
908         dynargs[0] = args[0];
909         dynargs[1] = args[1];
910         return oraclize_query(timestamp, datasource, dynargs);
911     }
912     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
913         string[] memory dynargs = new string[](2);
914         dynargs[0] = args[0];
915         dynargs[1] = args[1];
916         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
917     }
918     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
919         string[] memory dynargs = new string[](2);
920         dynargs[0] = args[0];
921         dynargs[1] = args[1];
922         return oraclize_query(datasource, dynargs, gaslimit);
923     }
924     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
925         string[] memory dynargs = new string[](3);
926         dynargs[0] = args[0];
927         dynargs[1] = args[1];
928         dynargs[2] = args[2];
929         return oraclize_query(datasource, dynargs);
930     }
931     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
932         string[] memory dynargs = new string[](3);
933         dynargs[0] = args[0];
934         dynargs[1] = args[1];
935         dynargs[2] = args[2];
936         return oraclize_query(timestamp, datasource, dynargs);
937     }
938     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
939         string[] memory dynargs = new string[](3);
940         dynargs[0] = args[0];
941         dynargs[1] = args[1];
942         dynargs[2] = args[2];
943         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
944     }
945     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
946         string[] memory dynargs = new string[](3);
947         dynargs[0] = args[0];
948         dynargs[1] = args[1];
949         dynargs[2] = args[2];
950         return oraclize_query(datasource, dynargs, gaslimit);
951     }
952 
953     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
954         string[] memory dynargs = new string[](4);
955         dynargs[0] = args[0];
956         dynargs[1] = args[1];
957         dynargs[2] = args[2];
958         dynargs[3] = args[3];
959         return oraclize_query(datasource, dynargs);
960     }
961     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
962         string[] memory dynargs = new string[](4);
963         dynargs[0] = args[0];
964         dynargs[1] = args[1];
965         dynargs[2] = args[2];
966         dynargs[3] = args[3];
967         return oraclize_query(timestamp, datasource, dynargs);
968     }
969     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
970         string[] memory dynargs = new string[](4);
971         dynargs[0] = args[0];
972         dynargs[1] = args[1];
973         dynargs[2] = args[2];
974         dynargs[3] = args[3];
975         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
976     }
977     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
978         string[] memory dynargs = new string[](4);
979         dynargs[0] = args[0];
980         dynargs[1] = args[1];
981         dynargs[2] = args[2];
982         dynargs[3] = args[3];
983         return oraclize_query(datasource, dynargs, gaslimit);
984     }
985     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
986         string[] memory dynargs = new string[](5);
987         dynargs[0] = args[0];
988         dynargs[1] = args[1];
989         dynargs[2] = args[2];
990         dynargs[3] = args[3];
991         dynargs[4] = args[4];
992         return oraclize_query(datasource, dynargs);
993     }
994     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
995         string[] memory dynargs = new string[](5);
996         dynargs[0] = args[0];
997         dynargs[1] = args[1];
998         dynargs[2] = args[2];
999         dynargs[3] = args[3];
1000         dynargs[4] = args[4];
1001         return oraclize_query(timestamp, datasource, dynargs);
1002     }
1003     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1004         string[] memory dynargs = new string[](5);
1005         dynargs[0] = args[0];
1006         dynargs[1] = args[1];
1007         dynargs[2] = args[2];
1008         dynargs[3] = args[3];
1009         dynargs[4] = args[4];
1010         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1011     }
1012     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1013         string[] memory dynargs = new string[](5);
1014         dynargs[0] = args[0];
1015         dynargs[1] = args[1];
1016         dynargs[2] = args[2];
1017         dynargs[3] = args[3];
1018         dynargs[4] = args[4];
1019         return oraclize_query(datasource, dynargs, gaslimit);
1020     }
1021     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1022         uint price = oraclize.getPrice(datasource);
1023         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1024         bytes memory args = ba2cbor(argN);
1025         return oraclize.queryN.value(price)(0, datasource, args);
1026     }
1027     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1028         uint price = oraclize.getPrice(datasource);
1029         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1030         bytes memory args = ba2cbor(argN);
1031         return oraclize.queryN.value(price)(timestamp, datasource, args);
1032     }
1033     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1034         uint price = oraclize.getPrice(datasource, gaslimit);
1035         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1036         bytes memory args = ba2cbor(argN);
1037         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
1038     }
1039     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1040         uint price = oraclize.getPrice(datasource, gaslimit);
1041         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1042         bytes memory args = ba2cbor(argN);
1043         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
1044     }
1045     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1046         bytes[] memory dynargs = new bytes[](1);
1047         dynargs[0] = args[0];
1048         return oraclize_query(datasource, dynargs);
1049     }
1050     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1051         bytes[] memory dynargs = new bytes[](1);
1052         dynargs[0] = args[0];
1053         return oraclize_query(timestamp, datasource, dynargs);
1054     }
1055     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1056         bytes[] memory dynargs = new bytes[](1);
1057         dynargs[0] = args[0];
1058         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1059     }
1060     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1061         bytes[] memory dynargs = new bytes[](1);
1062         dynargs[0] = args[0];
1063         return oraclize_query(datasource, dynargs, gaslimit);
1064     }
1065 
1066     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1067         bytes[] memory dynargs = new bytes[](2);
1068         dynargs[0] = args[0];
1069         dynargs[1] = args[1];
1070         return oraclize_query(datasource, dynargs);
1071     }
1072     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1073         bytes[] memory dynargs = new bytes[](2);
1074         dynargs[0] = args[0];
1075         dynargs[1] = args[1];
1076         return oraclize_query(timestamp, datasource, dynargs);
1077     }
1078     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1079         bytes[] memory dynargs = new bytes[](2);
1080         dynargs[0] = args[0];
1081         dynargs[1] = args[1];
1082         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1083     }
1084     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1085         bytes[] memory dynargs = new bytes[](2);
1086         dynargs[0] = args[0];
1087         dynargs[1] = args[1];
1088         return oraclize_query(datasource, dynargs, gaslimit);
1089     }
1090     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1091         bytes[] memory dynargs = new bytes[](3);
1092         dynargs[0] = args[0];
1093         dynargs[1] = args[1];
1094         dynargs[2] = args[2];
1095         return oraclize_query(datasource, dynargs);
1096     }
1097     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1098         bytes[] memory dynargs = new bytes[](3);
1099         dynargs[0] = args[0];
1100         dynargs[1] = args[1];
1101         dynargs[2] = args[2];
1102         return oraclize_query(timestamp, datasource, dynargs);
1103     }
1104     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1105         bytes[] memory dynargs = new bytes[](3);
1106         dynargs[0] = args[0];
1107         dynargs[1] = args[1];
1108         dynargs[2] = args[2];
1109         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1110     }
1111     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1112         bytes[] memory dynargs = new bytes[](3);
1113         dynargs[0] = args[0];
1114         dynargs[1] = args[1];
1115         dynargs[2] = args[2];
1116         return oraclize_query(datasource, dynargs, gaslimit);
1117     }
1118 
1119     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1120         bytes[] memory dynargs = new bytes[](4);
1121         dynargs[0] = args[0];
1122         dynargs[1] = args[1];
1123         dynargs[2] = args[2];
1124         dynargs[3] = args[3];
1125         return oraclize_query(datasource, dynargs);
1126     }
1127     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1128         bytes[] memory dynargs = new bytes[](4);
1129         dynargs[0] = args[0];
1130         dynargs[1] = args[1];
1131         dynargs[2] = args[2];
1132         dynargs[3] = args[3];
1133         return oraclize_query(timestamp, datasource, dynargs);
1134     }
1135     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1136         bytes[] memory dynargs = new bytes[](4);
1137         dynargs[0] = args[0];
1138         dynargs[1] = args[1];
1139         dynargs[2] = args[2];
1140         dynargs[3] = args[3];
1141         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1142     }
1143     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1144         bytes[] memory dynargs = new bytes[](4);
1145         dynargs[0] = args[0];
1146         dynargs[1] = args[1];
1147         dynargs[2] = args[2];
1148         dynargs[3] = args[3];
1149         return oraclize_query(datasource, dynargs, gaslimit);
1150     }
1151     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1152         bytes[] memory dynargs = new bytes[](5);
1153         dynargs[0] = args[0];
1154         dynargs[1] = args[1];
1155         dynargs[2] = args[2];
1156         dynargs[3] = args[3];
1157         dynargs[4] = args[4];
1158         return oraclize_query(datasource, dynargs);
1159     }
1160     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1161         bytes[] memory dynargs = new bytes[](5);
1162         dynargs[0] = args[0];
1163         dynargs[1] = args[1];
1164         dynargs[2] = args[2];
1165         dynargs[3] = args[3];
1166         dynargs[4] = args[4];
1167         return oraclize_query(timestamp, datasource, dynargs);
1168     }
1169     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1170         bytes[] memory dynargs = new bytes[](5);
1171         dynargs[0] = args[0];
1172         dynargs[1] = args[1];
1173         dynargs[2] = args[2];
1174         dynargs[3] = args[3];
1175         dynargs[4] = args[4];
1176         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1177     }
1178     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1179         bytes[] memory dynargs = new bytes[](5);
1180         dynargs[0] = args[0];
1181         dynargs[1] = args[1];
1182         dynargs[2] = args[2];
1183         dynargs[3] = args[3];
1184         dynargs[4] = args[4];
1185         return oraclize_query(datasource, dynargs, gaslimit);
1186     }
1187 
1188     function oraclize_cbAddress() oraclizeAPI internal returns (address){
1189         return oraclize.cbAddress();
1190     }
1191     function oraclize_setProof(byte proofP) oraclizeAPI internal {
1192         return oraclize.setProofType(proofP);
1193     }
1194     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
1195         return oraclize.setCustomGasPrice(gasPrice);
1196     }
1197 
1198     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
1199         return oraclize.randomDS_getSessionPubKeyHash();
1200     }
1201 
1202     function getCodeSize(address _addr) constant internal returns(uint _size) {
1203         assembly {
1204             _size := extcodesize(_addr)
1205         }
1206     }
1207 
1208     function parseAddr(string _a) internal pure returns (address){
1209         bytes memory tmp = bytes(_a);
1210         uint160 iaddr = 0;
1211         uint160 b1;
1212         uint160 b2;
1213         for (uint i=2; i<2+2*20; i+=2){
1214             iaddr *= 256;
1215             b1 = uint160(tmp[i]);
1216             b2 = uint160(tmp[i+1]);
1217             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
1218             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
1219             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
1220             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
1221             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
1222             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
1223             iaddr += (b1*16+b2);
1224         }
1225         return address(iaddr);
1226     }
1227 
1228     function strCompare(string _a, string _b) internal pure returns (int) {
1229         bytes memory a = bytes(_a);
1230         bytes memory b = bytes(_b);
1231         uint minLength = a.length;
1232         if (b.length < minLength) minLength = b.length;
1233         for (uint i = 0; i < minLength; i ++)
1234             if (a[i] < b[i])
1235                 return -1;
1236             else if (a[i] > b[i])
1237                 return 1;
1238         if (a.length < b.length)
1239             return -1;
1240         else if (a.length > b.length)
1241             return 1;
1242         else
1243             return 0;
1244     }
1245 
1246     function indexOf(string _haystack, string _needle) internal pure returns (int) {
1247         bytes memory h = bytes(_haystack);
1248         bytes memory n = bytes(_needle);
1249         if(h.length < 1 || n.length < 1 || (n.length > h.length))
1250             return -1;
1251         else if(h.length > (2**128 -1))
1252             return -1;
1253         else
1254         {
1255             uint subindex = 0;
1256             for (uint i = 0; i < h.length; i ++)
1257             {
1258                 if (h[i] == n[0])
1259                 {
1260                     subindex = 1;
1261                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
1262                     {
1263                         subindex++;
1264                     }
1265                     if(subindex == n.length)
1266                         return int(i);
1267                 }
1268             }
1269             return -1;
1270         }
1271     }
1272 
1273     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
1274         bytes memory _ba = bytes(_a);
1275         bytes memory _bb = bytes(_b);
1276         bytes memory _bc = bytes(_c);
1277         bytes memory _bd = bytes(_d);
1278         bytes memory _be = bytes(_e);
1279         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1280         bytes memory babcde = bytes(abcde);
1281         uint k = 0;
1282         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1283         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1284         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1285         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1286         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1287         return string(babcde);
1288     }
1289 
1290     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
1291         return strConcat(_a, _b, _c, _d, "");
1292     }
1293 
1294     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
1295         return strConcat(_a, _b, _c, "", "");
1296     }
1297 
1298     function strConcat(string _a, string _b) internal pure returns (string) {
1299         return strConcat(_a, _b, "", "", "");
1300     }
1301 
1302     // parseInt
1303     function parseInt(string _a) internal pure returns (uint) {
1304         return parseInt(_a, 0);
1305     }
1306 
1307     // parseInt(parseFloat*10^_b)
1308     function parseInt(string _a, uint _b) internal pure returns (uint) {
1309         bytes memory bresult = bytes(_a);
1310         uint mint = 0;
1311         bool decimals = false;
1312         for (uint i=0; i<bresult.length; i++){
1313             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
1314                 if (decimals){
1315                    if (_b == 0) break;
1316                     else _b--;
1317                 }
1318                 mint *= 10;
1319                 mint += uint(bresult[i]) - 48;
1320             } else if (bresult[i] == 46) decimals = true;
1321         }
1322         if (_b > 0) mint *= 10**_b;
1323         return mint;
1324     }
1325 
1326     function uint2str(uint i) internal pure returns (string){
1327         if (i == 0) return "0";
1328         uint j = i;
1329         uint len;
1330         while (j != 0){
1331             len++;
1332             j /= 10;
1333         }
1334         bytes memory bstr = new bytes(len);
1335         uint k = len - 1;
1336         while (i != 0){
1337             bstr[k--] = byte(48 + i % 10);
1338             i /= 10;
1339         }
1340         return string(bstr);
1341     }
1342 
1343     using CBOR for Buffer.buffer;
1344     function stra2cbor(string[] arr) internal pure returns (bytes) {
1345         safeMemoryCleaner();
1346         Buffer.buffer memory buf;
1347         Buffer.init(buf, 1024);
1348         buf.startArray();
1349         for (uint i = 0; i < arr.length; i++) {
1350             buf.encodeString(arr[i]);
1351         }
1352         buf.endSequence();
1353         return buf.buf;
1354     }
1355 
1356     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
1357         safeMemoryCleaner();
1358         Buffer.buffer memory buf;
1359         Buffer.init(buf, 1024);
1360         buf.startArray();
1361         for (uint i = 0; i < arr.length; i++) {
1362             buf.encodeBytes(arr[i]);
1363         }
1364         buf.endSequence();
1365         return buf.buf;
1366     }
1367 
1368     string oraclize_network_name;
1369     function oraclize_setNetworkName(string _network_name) internal {
1370         oraclize_network_name = _network_name;
1371     }
1372 
1373     function oraclize_getNetworkName() internal view returns (string) {
1374         return oraclize_network_name;
1375     }
1376 
1377     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1378         require((_nbytes > 0) && (_nbytes <= 32));
1379         // Convert from seconds to ledger timer ticks
1380         _delay *= 10;
1381         bytes memory nbytes = new bytes(1);
1382         nbytes[0] = byte(_nbytes);
1383         bytes memory unonce = new bytes(32);
1384         bytes memory sessionKeyHash = new bytes(32);
1385         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1386         assembly {
1387             mstore(unonce, 0x20)
1388             // the following variables can be relaxed
1389             // check relaxed random contract under ethereum-examples repo
1390             // for an idea on how to override and replace comit hash vars
1391             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1392             mstore(sessionKeyHash, 0x20)
1393             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1394         }
1395         bytes memory delay = new bytes(32);
1396         assembly {
1397             mstore(add(delay, 0x20), _delay)
1398         }
1399 
1400         bytes memory delay_bytes8 = new bytes(8);
1401         copyBytes(delay, 24, 8, delay_bytes8, 0);
1402 
1403         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1404         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1405 
1406         bytes memory delay_bytes8_left = new bytes(8);
1407 
1408         assembly {
1409             let x := mload(add(delay_bytes8, 0x20))
1410             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1411             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1412             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1413             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1414             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1415             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1416             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1417             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1418 
1419         }
1420 
1421         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1422         return queryId;
1423     }
1424 
1425     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1426         oraclize_randomDS_args[queryId] = commitment;
1427     }
1428 
1429     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1430     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1431 
1432     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1433         bool sigok;
1434         address signer;
1435 
1436         bytes32 sigr;
1437         bytes32 sigs;
1438 
1439         bytes memory sigr_ = new bytes(32);
1440         uint offset = 4+(uint(dersig[3]) - 0x20);
1441         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1442         bytes memory sigs_ = new bytes(32);
1443         offset += 32 + 2;
1444         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1445 
1446         assembly {
1447             sigr := mload(add(sigr_, 32))
1448             sigs := mload(add(sigs_, 32))
1449         }
1450 
1451 
1452         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1453         if (address(keccak256(pubkey)) == signer) return true;
1454         else {
1455             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1456             return (address(keccak256(pubkey)) == signer);
1457         }
1458     }
1459 
1460     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1461         bool sigok;
1462 
1463         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1464         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1465         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1466 
1467         bytes memory appkey1_pubkey = new bytes(64);
1468         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1469 
1470         bytes memory tosign2 = new bytes(1+65+32);
1471         tosign2[0] = byte(1); //role
1472         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1473         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1474         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1475         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1476 
1477         if (sigok == false) return false;
1478 
1479 
1480         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1481         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1482 
1483         bytes memory tosign3 = new bytes(1+65);
1484         tosign3[0] = 0xFE;
1485         copyBytes(proof, 3, 65, tosign3, 1);
1486 
1487         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1488         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1489 
1490         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1491 
1492         return sigok;
1493     }
1494 
1495     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1496         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1497         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1498 
1499         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1500         require(proofVerified);
1501 
1502         _;
1503     }
1504 
1505     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1506         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1507         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1508 
1509         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1510         if (proofVerified == false) return 2;
1511 
1512         return 0;
1513     }
1514 
1515     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1516         bool match_ = true;
1517 
1518         require(prefix.length == n_random_bytes);
1519 
1520         for (uint256 i=0; i< n_random_bytes; i++) {
1521             if (content[i] != prefix[i]) match_ = false;
1522         }
1523 
1524         return match_;
1525     }
1526 
1527     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1528 
1529         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1530         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1531         bytes memory keyhash = new bytes(32);
1532         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1533         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1534 
1535         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1536         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1537 
1538         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1539         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1540 
1541         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1542         // This is to verify that the computed args match with the ones specified in the query.
1543         bytes memory commitmentSlice1 = new bytes(8+1+32);
1544         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1545 
1546         bytes memory sessionPubkey = new bytes(64);
1547         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1548         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1549 
1550         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1551         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1552             delete oraclize_randomDS_args[queryId];
1553         } else return false;
1554 
1555 
1556         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1557         bytes memory tosign1 = new bytes(32+8+1+32);
1558         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1559         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1560 
1561         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1562         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1563             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1564         }
1565 
1566         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1567     }
1568 
1569     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1570     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1571         uint minLength = length + toOffset;
1572 
1573         // Buffer too small
1574         require(to.length >= minLength); // Should be a better way?
1575 
1576         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1577         uint i = 32 + fromOffset;
1578         uint j = 32 + toOffset;
1579 
1580         while (i < (32 + fromOffset + length)) {
1581             assembly {
1582                 let tmp := mload(add(from, i))
1583                 mstore(add(to, j), tmp)
1584             }
1585             i += 32;
1586             j += 32;
1587         }
1588 
1589         return to;
1590     }
1591 
1592     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1593     // Duplicate Solidity's ecrecover, but catching the CALL return value
1594     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1595         // We do our own memory management here. Solidity uses memory offset
1596         // 0x40 to store the current end of memory. We write past it (as
1597         // writes are memory extensions), but don't update the offset so
1598         // Solidity will reuse it. The memory used here is only needed for
1599         // this context.
1600 
1601         // FIXME: inline assembly can't access return values
1602         bool ret;
1603         address addr;
1604 
1605         assembly {
1606             let size := mload(0x40)
1607             mstore(size, hash)
1608             mstore(add(size, 32), v)
1609             mstore(add(size, 64), r)
1610             mstore(add(size, 96), s)
1611 
1612             // NOTE: we can reuse the request memory because we deal with
1613             //       the return code
1614             ret := call(3000, 1, 0, size, 128, size, 32)
1615             addr := mload(size)
1616         }
1617 
1618         return (ret, addr);
1619     }
1620 
1621     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1622     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1623         bytes32 r;
1624         bytes32 s;
1625         uint8 v;
1626 
1627         if (sig.length != 65)
1628           return (false, 0);
1629 
1630         // The signature format is a compact form of:
1631         //   {bytes32 r}{bytes32 s}{uint8 v}
1632         // Compact means, uint8 is not padded to 32 bytes.
1633         assembly {
1634             r := mload(add(sig, 32))
1635             s := mload(add(sig, 64))
1636 
1637             // Here we are loading the last 32 bytes. We exploit the fact that
1638             // 'mload' will pad with zeroes if we overread.
1639             // There is no 'mload8' to do this, but that would be nicer.
1640             v := byte(0, mload(add(sig, 96)))
1641 
1642             // Alternative solution:
1643             // 'byte' is not working due to the Solidity parser, so lets
1644             // use the second best option, 'and'
1645             // v := and(mload(add(sig, 65)), 255)
1646         }
1647 
1648         // albeit non-transactional signatures are not specified by the YP, one would expect it
1649         // to match the YP range of [27, 28]
1650         //
1651         // geth uses [0, 1] and some clients have followed. This might change, see:
1652         //  https://github.com/ethereum/go-ethereum/issues/2053
1653         if (v < 27)
1654           v += 27;
1655 
1656         if (v != 27 && v != 28)
1657             return (false, 0);
1658 
1659         return safer_ecrecover(hash, v, r, s);
1660     }
1661 
1662     function safeMemoryCleaner() internal pure {
1663         assembly {
1664             let fmem := mload(0x40)
1665             codecopy(fmem, codesize, sub(msize, fmem))
1666         }
1667     }
1668 
1669 }
1670 // </ORACLIZE_API>
1671 
1672 
1673 
1674 
1675 
1676 
1677 /**
1678  * @title Exchange interactor for Monoreto ICO.
1679  * 
1680  */
1681 contract ExchangeInteractor is usingOraclize, Ownable {
1682     using SafeMath for uint256;
1683 
1684     // 4 hours
1685     uint256 constant queryTimePeriod = 14400;
1686 
1687     uint256 public usdEthRate;
1688     string public jsonPath = "json(https://api.kraken.com/0/public/Ticker?pair=ETHUSD).result.XETHZUSD.c.0";
1689 
1690     event NewRate(string rate);
1691     event NewUsdEthRate(uint256 rate);
1692     event NewQuery(string comment);
1693     event EthReceived(uint256 eth);
1694 
1695     function ExchangeInteractor(uint256 _initialUsdEthRate) public {
1696         require(_initialUsdEthRate > 0);
1697 
1698         usdEthRate = _initialUsdEthRate;
1699 
1700         oraclize_setProof(proofType_TLSNotary | proofStorage_IPFS);
1701         updatePrice();
1702     }
1703 
1704     /**
1705      * @dev when using oraclize, ETH are withdrawed from contract address
1706      * so it should have a feature of receivind ETH.
1707      */
1708     function () public payable {
1709         EthReceived(msg.value);
1710         
1711         //updatePrice();
1712     }
1713 
1714     function __callback(bytes32 myid, string result, bytes proof) public {
1715         require(msg.sender == oraclize_cbAddress());
1716         usdEthRate = parseInt(result, 5).div(100000);
1717         NewUsdEthRate(usdEthRate);
1718         updatePrice();
1719     }
1720 
1721     function updatePrice() public {
1722 	    if (oraclize.getPrice("URL") > this.balance) {
1723             NewQuery("Insufficient funds");
1724         } else {
1725             // "json(https://api.kraken.com/0/public/Ticker?pair=ETHXBT).result.XETHXXBT.c.0"
1726             oraclize_query(queryTimePeriod, "URL", jsonPath);
1727         }
1728     }
1729 
1730     function setJsonPath(string _jsonPath) external onlyOwner {
1731         jsonPath = _jsonPath;
1732     }
1733 
1734     function close() public onlyOwner {
1735         selfdestruct(owner);
1736     }
1737 }
1738 
1739 
1740 
1741 
1742 
1743 
1744 
1745 /**
1746  * @title Crowdsale
1747  * @dev Crowdsale is a base contract for managing a token crowdsale,
1748  * allowing investors to purchase tokens with ether. This contract implements
1749  * such functionality in its most fundamental form and can be extended to provide additional
1750  * functionality and/or custom behavior.
1751  * The external interface represents the basic interface for purchasing tokens, and conform
1752  * the base architecture for crowdsales. They are *not* intended to be modified / overriden.
1753  * The internal interface conforms the extensible and modifiable surface of crowdsales. Override
1754  * the methods to add functionality. Consider using 'super' where appropiate to concatenate
1755  * behavior.
1756  */
1757 contract Crowdsale {
1758   using SafeMath for uint256;
1759 
1760   // The token being sold
1761   ERC20 public token;
1762 
1763   // Address where funds are collected
1764   address public wallet;
1765 
1766   // How many token units a buyer gets per wei
1767   uint256 public rate;
1768 
1769   // Amount of wei raised
1770   uint256 public weiRaised;
1771 
1772   /**
1773    * Event for token purchase logging
1774    * @param purchaser who paid for the tokens
1775    * @param beneficiary who got the tokens
1776    * @param value weis paid for purchase
1777    * @param amount amount of tokens purchased
1778    */
1779   event TokenPurchase(address indexed purchaser, address indexed beneficiary, uint256 value, uint256 amount);
1780 
1781   /**
1782    * @param _rate Number of token units a buyer gets per wei
1783    * @param _wallet Address where collected funds will be forwarded to
1784    * @param _token Address of the token being sold
1785    */
1786   function Crowdsale(uint256 _rate, address _wallet, ERC20 _token) public {
1787     require(_rate > 0);
1788     require(_wallet != address(0));
1789     require(_token != address(0));
1790 
1791     rate = _rate;
1792     wallet = _wallet;
1793     token = _token;
1794   }
1795 
1796   // -----------------------------------------
1797   // Crowdsale external interface
1798   // -----------------------------------------
1799 
1800   /**
1801    * @dev fallback function ***DO NOT OVERRIDE***
1802    */
1803   function () external payable {
1804     buyTokens(msg.sender);
1805   }
1806 
1807   /**
1808    * @dev low level token purchase ***DO NOT OVERRIDE***
1809    * @param _beneficiary Address performing the token purchase
1810    */
1811   function buyTokens(address _beneficiary) public payable {
1812 
1813     uint256 weiAmount = msg.value;
1814     _preValidatePurchase(_beneficiary, weiAmount);
1815 
1816     // calculate token amount to be created
1817     uint256 tokens = _getTokenAmount(weiAmount);
1818 
1819     // update state
1820     weiRaised = weiRaised.add(weiAmount);
1821 
1822     _processPurchase(_beneficiary, tokens);
1823     emit TokenPurchase(
1824       msg.sender,
1825       _beneficiary,
1826       weiAmount,
1827       tokens
1828     );
1829 
1830     _updatePurchasingState(_beneficiary, weiAmount);
1831 
1832     _forwardFunds();
1833     _postValidatePurchase(_beneficiary, weiAmount);
1834   }
1835 
1836   // -----------------------------------------
1837   // Internal interface (extensible)
1838   // -----------------------------------------
1839 
1840   /**
1841    * @dev Validation of an incoming purchase. Use require statements to revert state when conditions are not met. Use super to concatenate validations.
1842    * @param _beneficiary Address performing the token purchase
1843    * @param _weiAmount Value in wei involved in the purchase
1844    */
1845   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
1846     require(_beneficiary != address(0));
1847     require(_weiAmount != 0);
1848   }
1849 
1850   /**
1851    * @dev Validation of an executed purchase. Observe state and use revert statements to undo rollback when valid conditions are not met.
1852    * @param _beneficiary Address performing the token purchase
1853    * @param _weiAmount Value in wei involved in the purchase
1854    */
1855   function _postValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
1856     // optional override
1857   }
1858 
1859   /**
1860    * @dev Source of tokens. Override this method to modify the way in which the crowdsale ultimately gets and sends its tokens.
1861    * @param _beneficiary Address performing the token purchase
1862    * @param _tokenAmount Number of tokens to be emitted
1863    */
1864   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
1865     token.transfer(_beneficiary, _tokenAmount);
1866   }
1867 
1868   /**
1869    * @dev Executed when a purchase has been validated and is ready to be executed. Not necessarily emits/sends tokens.
1870    * @param _beneficiary Address receiving the tokens
1871    * @param _tokenAmount Number of tokens to be purchased
1872    */
1873   function _processPurchase(address _beneficiary, uint256 _tokenAmount) internal {
1874     _deliverTokens(_beneficiary, _tokenAmount);
1875   }
1876 
1877   /**
1878    * @dev Override for extensions that require an internal state to check for validity (current user contributions, etc.)
1879    * @param _beneficiary Address receiving the tokens
1880    * @param _weiAmount Value in wei involved in the purchase
1881    */
1882   function _updatePurchasingState(address _beneficiary, uint256 _weiAmount) internal {
1883     // optional override
1884   }
1885 
1886   /**
1887    * @dev Override to extend the way in which ether is converted to tokens.
1888    * @param _weiAmount Value in wei to be converted into tokens
1889    * @return Number of tokens that can be purchased with the specified _weiAmount
1890    */
1891   function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
1892     return _weiAmount.mul(rate);
1893   }
1894 
1895   /**
1896    * @dev Determines how ETH is stored/forwarded on purchases.
1897    */
1898   function _forwardFunds() internal {
1899     wallet.transfer(msg.value);
1900   }
1901 }
1902 
1903 
1904 
1905 
1906 
1907 
1908 /**
1909  * @title CappedCrowdsale
1910  * @dev Crowdsale with a limit for total contributions.
1911  */
1912 contract CappedCrowdsale is Crowdsale {
1913   using SafeMath for uint256;
1914 
1915   uint256 public cap;
1916 
1917   /**
1918    * @dev Constructor, takes maximum amount of wei accepted in the crowdsale.
1919    * @param _cap Max amount of wei to be contributed
1920    */
1921   function CappedCrowdsale(uint256 _cap) public {
1922     require(_cap > 0);
1923     cap = _cap;
1924   }
1925 
1926   /**
1927    * @dev Checks whether the cap has been reached. 
1928    * @return Whether the cap was reached
1929    */
1930   function capReached() public view returns (bool) {
1931     return weiRaised >= cap;
1932   }
1933 
1934   /**
1935    * @dev Extend parent behavior requiring purchase to respect the funding cap.
1936    * @param _beneficiary Token purchaser
1937    * @param _weiAmount Amount of wei contributed
1938    */
1939   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
1940     super._preValidatePurchase(_beneficiary, _weiAmount);
1941     require(weiRaised.add(_weiAmount) <= cap);
1942   }
1943 
1944 }
1945 
1946 
1947 
1948 
1949 
1950 
1951 /**
1952  * @title TimedCrowdsale
1953  * @dev Crowdsale accepting contributions only within a time frame.
1954  */
1955 contract TimedCrowdsale is Crowdsale {
1956   using SafeMath for uint256;
1957 
1958   uint256 public openingTime;
1959   uint256 public closingTime;
1960 
1961   /**
1962    * @dev Reverts if not in crowdsale time range.
1963    */
1964   modifier onlyWhileOpen {
1965     // solium-disable-next-line security/no-block-members
1966     require(block.timestamp >= openingTime && block.timestamp <= closingTime);
1967     _;
1968   }
1969 
1970   /**
1971    * @dev Constructor, takes crowdsale opening and closing times.
1972    * @param _openingTime Crowdsale opening time
1973    * @param _closingTime Crowdsale closing time
1974    */
1975   function TimedCrowdsale(uint256 _openingTime, uint256 _closingTime) public {
1976     // solium-disable-next-line security/no-block-members
1977     require(_openingTime >= block.timestamp);
1978     require(_closingTime >= _openingTime);
1979 
1980     openingTime = _openingTime;
1981     closingTime = _closingTime;
1982   }
1983 
1984   /**
1985    * @dev Checks whether the period in which the crowdsale is open has already elapsed.
1986    * @return Whether crowdsale period has elapsed
1987    */
1988   function hasClosed() public view returns (bool) {
1989     // solium-disable-next-line security/no-block-members
1990     return block.timestamp > closingTime;
1991   }
1992 
1993   /**
1994    * @dev Extend parent behavior requiring to be within contributing period
1995    * @param _beneficiary Token purchaser
1996    * @param _weiAmount Amount of wei contributed
1997    */
1998   function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
1999     super._preValidatePurchase(_beneficiary, _weiAmount);
2000   }
2001 
2002 }
2003 
2004 
2005 
2006 
2007 
2008 
2009 /**
2010  * @title MintedCrowdsale
2011  * @dev Extension of Crowdsale contract whose tokens are minted in each purchase.
2012  * Token ownership should be transferred to MintedCrowdsale for minting. 
2013  */
2014 contract MintedCrowdsale is Crowdsale {
2015 
2016   /**
2017    * @dev Overrides delivery by minting tokens upon purchase.
2018    * @param _beneficiary Token purchaser
2019    * @param _tokenAmount Number of tokens to be minted
2020    */
2021   function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
2022     require(MintableToken(token).mint(_beneficiary, _tokenAmount));
2023   }
2024 }
2025 
2026 
2027 
2028 
2029 
2030 
2031 
2032 /**
2033  * @title FinalizableCrowdsale
2034  * @dev Extension of Crowdsale where an owner can do extra work
2035  * after finishing.
2036  */
2037 contract FinalizableCrowdsale is TimedCrowdsale, Ownable {
2038   using SafeMath for uint256;
2039 
2040   bool public isFinalized = false;
2041 
2042   event Finalized();
2043 
2044   /**
2045    * @dev Must be called after crowdsale ends, to do some extra finalization
2046    * work. Calls the contract's finalization function.
2047    */
2048   function finalize() onlyOwner public {
2049     require(!isFinalized);
2050     require(hasClosed());
2051 
2052     finalization();
2053     emit Finalized();
2054 
2055     isFinalized = true;
2056   }
2057 
2058   /**
2059    * @dev Can be overridden to add finalization logic. The overriding function
2060    * should call super.finalization() to ensure the chain of finalization is
2061    * executed entirely.
2062    */
2063   function finalization() internal {
2064   }
2065 
2066 }
2067 
2068 
2069 
2070 
2071 
2072 
2073 
2074 
2075 /**
2076  * @title RefundableCrowdsale
2077  * @dev Extension of Crowdsale contract that adds a funding goal, and
2078  * the possibility of users getting a refund if goal is not met.
2079  * Uses a RefundVault as the crowdsale's vault.
2080  */
2081 contract RefundableCrowdsale is FinalizableCrowdsale {
2082   using SafeMath for uint256;
2083 
2084   // minimum amount of funds to be raised in weis
2085   uint256 public goal;
2086 
2087   // refund vault used to hold funds while crowdsale is running
2088   RefundVault public vault;
2089 
2090   /**
2091    * @dev Constructor, creates RefundVault.
2092    * @param _goal Funding goal
2093    */
2094   function RefundableCrowdsale(uint256 _goal) public {
2095     require(_goal > 0);
2096     vault = new RefundVault(wallet);
2097     goal = _goal;
2098   }
2099 
2100   /**
2101    * @dev Investors can claim refunds here if crowdsale is unsuccessful
2102    */
2103   function claimRefund() public {
2104     require(isFinalized);
2105     require(!goalReached());
2106 
2107     vault.refund(msg.sender);
2108   }
2109 
2110   /**
2111    * @dev Checks whether funding goal was reached.
2112    * @return Whether funding goal was reached
2113    */
2114   function goalReached() public view returns (bool) {
2115     return weiRaised >= goal;
2116   }
2117 
2118   /**
2119    * @dev vault finalization task, called when owner calls finalize()
2120    */
2121   function finalization() internal {
2122     if (goalReached()) {
2123       vault.close();
2124     } else {
2125       vault.enableRefunds();
2126     }
2127 
2128     super.finalization();
2129   }
2130 
2131   /**
2132    * @dev Overrides Crowdsale fund forwarding, sending funds to vault.
2133    */
2134   function _forwardFunds() internal {
2135     vault.deposit.value(msg.value)(msg.sender);
2136   }
2137 
2138 }
2139 
2140 
2141 
2142 
2143 
2144 
2145 /**
2146  * @title RefundVault
2147  * @dev This contract is used for storing funds while a crowdsale
2148  * is in progress. Supports refunding the money if crowdsale fails,
2149  * and forwarding it if crowdsale is successful.
2150  */
2151 contract RefundVault is Ownable {
2152   using SafeMath for uint256;
2153 
2154   enum State { Active, Refunding, Closed }
2155 
2156   mapping (address => uint256) public deposited;
2157   address public wallet;
2158   State public state;
2159 
2160   event Closed();
2161   event RefundsEnabled();
2162   event Refunded(address indexed beneficiary, uint256 weiAmount);
2163 
2164   /**
2165    * @param _wallet Vault address
2166    */
2167   function RefundVault(address _wallet) public {
2168     require(_wallet != address(0));
2169     wallet = _wallet;
2170     state = State.Active;
2171   }
2172 
2173   /**
2174    * @param investor Investor address
2175    */
2176   function deposit(address investor) onlyOwner public payable {
2177     require(state == State.Active);
2178     deposited[investor] = deposited[investor].add(msg.value);
2179   }
2180 
2181   function close() onlyOwner public {
2182     require(state == State.Active);
2183     state = State.Closed;
2184     emit Closed();
2185     wallet.transfer(address(this).balance);
2186   }
2187 
2188   function enableRefunds() onlyOwner public {
2189     require(state == State.Active);
2190     state = State.Refunding;
2191     emit RefundsEnabled();
2192   }
2193 
2194   /**
2195    * @param investor Investor address
2196    */
2197   function refund(address investor) public {
2198     require(state == State.Refunding);
2199     uint256 depositedValue = deposited[investor];
2200     deposited[investor] = 0;
2201     investor.transfer(depositedValue);
2202     emit Refunded(investor, depositedValue);
2203   }
2204 }
2205 
2206 
2207 
2208 
2209 
2210 
2211 
2212 
2213 
2214 
2215 
2216 /**
2217  * @title Base contract for Monoreto PreICO and ICO
2218  */
2219 contract BaseMonoretoCrowdsale is CappedCrowdsale, RefundableCrowdsale, MintedCrowdsale {
2220 
2221     using SafeMath for uint256;
2222 
2223     uint256 public usdMnr;
2224     uint256 public tokensPurchased;
2225     uint256 public tokenTarget;
2226 
2227     uint256 public dollarsReceived = 0;
2228 
2229     /** 
2230      * @dev USDMNR must be set as actual_value * CENT_DECIMALS
2231      * @dev example: value 0.2$ per token must be set as 0.2 * CENT_DECIMALS
2232      */
2233     uint256 public constant CENT_DECIMALS = 1e18;
2234 
2235     // original contract owner, needed for transfering the ownership of token back after the end of crowdsale
2236     address internal deployer;
2237     ExchangeInteractor public rateReceiver;
2238 
2239     function BaseMonoretoCrowdsale(uint256 _tokenTarget, uint256 _usdEth, uint256 _usdMnr, ExchangeInteractor interactor) public
2240     {
2241         require(_tokenTarget > 0);
2242         require(_usdEth > 0);
2243         require(_usdMnr > 0);
2244 
2245         tokenTarget = _tokenTarget;
2246         usdMnr = _usdMnr;
2247 
2248         deployer = msg.sender;
2249         rateReceiver = interactor;
2250     }
2251 
2252     function setUsdMnr(uint256 _usdMnr) external onlyOwner {
2253         usdMnr = _usdMnr;
2254     }
2255 
2256     function hasClosed() public view returns (bool) {
2257         return super.hasClosed() || capReached();
2258     }
2259 
2260     // If amount of wei sent is less than the threshold, revert.
2261     uint256 public constant ETHER_THRESHOLD = 100 finney;
2262 
2263     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
2264         require(_beneficiary != address(0));
2265         require(_weiAmount != 0);
2266         require(!capReached());
2267 
2268         require(dollarsReceived.add(calculateDollarAmountFromTokens(_getTokenAmount(_weiAmount))) <= cap);
2269         require(_weiAmount >= ETHER_THRESHOLD);
2270     }
2271 
2272     function _deliverTokens(address _beneficiary, uint256 _tokenAmount) internal {
2273         dollarsReceived = dollarsReceived.add(calculateDollarAmountFromTokens(_tokenAmount));
2274         super._deliverTokens(_beneficiary, _tokenAmount);
2275     }
2276 
2277 
2278     function _getTokenAmount(uint256 _weiAmount) internal view returns(uint256) {
2279         return super._getTokenAmount(_weiAmount).mul(rateReceiver.usdEthRate()).mul(calculateCentsMultiplier());
2280     }
2281 
2282     function goalReached() public view returns (bool) {
2283         return dollarsReceived >= goal;
2284     }
2285 
2286     function capReached() public view returns (bool) {
2287         return dollarsReceived >= cap;
2288     }
2289 
2290     /**
2291      * @dev overriden template method from FinalizableCrowdsale.
2292      * Returns the ownership of token to the original owner.
2293      * The child contract should call super.finalization() 
2294      * AFTER executing its own finalizing actions.
2295      */
2296     function finalization() internal {
2297         super.finalization();
2298 
2299         MonoretoToken castToken = MonoretoToken(token);
2300         castToken.transferOwnership(deployer);
2301     }
2302 
2303     function calculateCentsMultiplier() internal view returns (uint256) {
2304         return CENT_DECIMALS.div(usdMnr);
2305     }
2306 
2307     function calculateDollarAmountFromTokens(uint256 _tokenAmount) internal view returns (uint256) {
2308         return _tokenAmount.div(calculateCentsMultiplier());
2309     }
2310 
2311 }
2312 
2313 contract TimeBonusCrowdsale is TimedCrowdsale, Ownable {
2314     bool private bonusesSet = false;
2315 
2316     uint256[] private bonusTimes;
2317     uint256[] private bonusTimesPercents;
2318 
2319     uint256 private constant ONE_HUNDRED_PERCENT = 100;
2320 
2321     function TimeBonusCrowdsale(uint256 openingTime, uint256 closingTime) public
2322         TimedCrowdsale(openingTime, closingTime)
2323     {
2324 
2325     }
2326 
2327     /**
2328      * The function for setting the time bonuses;
2329      * Preconditions: 
2330      * 1) this function may be called only by the contract owner
2331      * 2) lengths of times array and values array must be the same;
2332      * 3) Times array must be ordered
2333      */
2334     function setTimeBonuses(uint256[] times, uint256[] values) external onlyOwner {
2335         require(times.length == values.length);
2336 
2337         for (uint256 i = 1; i < times.length; i++) {
2338             uint256 prevI = i.sub(1);
2339             require(times[prevI] < times[i]);
2340         }
2341 
2342         bonusTimes = times;
2343         bonusTimesPercents = values;
2344 
2345         bonusesSet = true;
2346     }
2347 
2348     function getBonusTimes() external view returns(uint256[]) {
2349         return bonusTimes;
2350     }
2351 
2352     function getBonusTimesPercents() external view returns(uint256[]) {
2353         return bonusTimesPercents;
2354     }
2355 
2356     /**
2357      * Overrides the Crowdsale method. Bonuses must be set for TimeBonusCrowdsale
2358      */
2359     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
2360         require(bonusesSet);
2361         super._preValidatePurchase(_beneficiary, _weiAmount);
2362     }
2363 
2364     /**
2365      * @dev overrides the crowdsale method, adjusts token amount wrt time bonuses
2366      */
2367     function _getTokenAmount(uint256 _weiAmount) internal view returns (uint256) {
2368         return super._getTokenAmount(_weiAmount).mul(computeBonusValueInPercents()).div(ONE_HUNDRED_PERCENT);
2369     }
2370 
2371     /**
2372      * @dev computes the bonus percent corresponding the current time
2373      * bonuses must be set, of course.
2374      */
2375     function computeBonusValueInPercents() internal view returns(uint256) {
2376         for (uint i = 0; i < bonusTimes.length; i++) {
2377             if (now.sub(openingTime) <= bonusTimes[i]) return bonusTimesPercents[i];
2378         }
2379 
2380         return ONE_HUNDRED_PERCENT;
2381     }
2382 }
2383 
2384 
2385 contract MonoretoPreIcoStep is TimeBonusCrowdsale, BaseMonoretoCrowdsale {
2386 
2387     function MonoretoPreIcoStep(uint256 _openTime, uint256 _closeTime, uint256 _goal, uint256 _cap,
2388         uint256 _centMnrRate, uint256 _tokenTarget, address _ownerWallet, MonoretoToken _token, ExchangeInteractor _interactor) public
2389         TimeBonusCrowdsale(_openTime, _closeTime)
2390         BaseMonoretoCrowdsale(_tokenTarget, 1, _centMnrRate, _interactor)
2391         CappedCrowdsale(_cap)
2392         RefundableCrowdsale(_goal)
2393         FinalizableCrowdsale()
2394 	TimedCrowdsale(_openTime, _closeTime)
2395 	Crowdsale(1, _ownerWallet, _token)
2396     {
2397         require(_goal <= _cap);
2398     }
2399 
2400     function calculateDollarAmountFromTokens(uint256 _tokenAmount) internal view returns (uint256) {
2401         return _tokenAmount.div(calculateCentsMultiplier()).div(computeBonusValueInPercents()).mul(100);
2402     }
2403 
2404 }
2405 
2406 /**
2407  * @title Base contract for Simplified Monoreto PreICO and ICO.
2408  * @dev The difference between this and regular base contract
2409  * is that this contract is without softcap 
2410  */
2411 contract BaseMonoretoSimpleCrowdsale is CappedCrowdsale, FinalizableCrowdsale, MintedCrowdsale {
2412 
2413     using SafeMath for uint256;
2414 
2415     uint256 public usdMnr;
2416     uint256 public tokensPurchased;
2417     uint256 public tokenTarget;
2418 
2419     /** 
2420      * @dev USDMNR must be set as actual_value * CENT_DECIMALS
2421      * @dev example: value 0.2$ per token must be set as 0.2 * CENT_DECIMALS
2422      */
2423     uint256 public constant CENT_DECIMALS = 100;
2424 
2425     // original contract owner, needed for transfering the ownership of token back after the end of crowdsale
2426     address internal deployer;
2427     ExchangeInteractor public rateReceiver;
2428 
2429     function BaseMonoretoSimpleCrowdsale(uint256 _tokenTarget, uint256 _usdEth, uint256 _usdMnr) public
2430     {
2431         require(_tokenTarget > 0);
2432         require(_usdEth > 0);
2433         require(_usdMnr > 0);
2434 
2435         tokenTarget = _tokenTarget;
2436         usdMnr = _usdMnr;
2437 
2438         deployer = msg.sender;
2439         rateReceiver = new ExchangeInteractor(_usdEth);
2440     }
2441 
2442     function setUsdMnr(uint256 _usdMnr) external onlyOwner {
2443         usdMnr = _usdMnr;
2444     }
2445 
2446     function hasClosed() public view returns (bool) {
2447         return super.hasClosed() || capReached();
2448     }
2449 
2450     // If amount of wei sent is less than the threshold, revert.
2451     uint256 public constant ETHER_THRESHOLD = 100 finney;
2452 
2453     function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal {
2454         uint256 tokenAmountOfRequest = _getTokenAmount(_weiAmount);
2455 
2456         require(_beneficiary != address(0));
2457         require(_weiAmount >= ETHER_THRESHOLD);
2458         require(!capReached());
2459 
2460         //require(dollarsReceived.add(calculateDollarAmountFromTokens(tokenAmountOfRequest)) <= cap);
2461     }
2462 
2463     function _getTokenAmount(uint256 _weiAmount) internal view returns(uint256) {
2464         return super._getTokenAmount(_weiAmount).mul(rateReceiver.usdEthRate()).mul(calculateCentsMultiplier());
2465     }
2466 
2467     function capReached() public view returns (bool) {
2468         return calculateCurrentDollarAmount() >= cap;
2469     }
2470 
2471     /**
2472      * @dev overriden template method from FinalizableCrowdsale.
2473      * Returns the ownership of token to the original owner.
2474      * Any contract that inherits from this should call super.finalization() 
2475      * AFTER executing its own finalizing actions.
2476      */
2477     function finalization() internal {
2478         super.finalization();
2479 
2480         MonoretoToken castToken = MonoretoToken(token);
2481         castToken.transferOwnership(deployer);
2482     }
2483 
2484     function calculateCentsMultiplier() internal view returns (uint256) {
2485         return CENT_DECIMALS.div(usdMnr);
2486     }
2487 
2488     function calculateDollarAmountFromTokens(uint256 _tokenAmount) internal view returns (uint256) {
2489         return _tokenAmount.div(calculateCentsMultiplier());
2490     }
2491     
2492     function calculateCurrentDollarAmount() public view returns (uint256) {
2493         return weiRaised.mul(rateReceiver.usdEthRate()).div(10 ** 18);
2494     }
2495 }
2496 
2497 contract SimplifiedMonoretoPreIcoStep is BaseMonoretoSimpleCrowdsale {
2498     function SimplifiedMonoretoPreIcoStep(uint256 _openTime, uint256 _closeTime, uint256 _cap,
2499         uint256 _centWeiRate, uint256 _centMnrRate,
2500         uint256 _tokenTarget, address _ownerWallet, MonoretoToken _token) public
2501         BaseMonoretoSimpleCrowdsale(_tokenTarget, _centWeiRate, _centMnrRate)
2502         CappedCrowdsale(_cap)
2503         FinalizableCrowdsale()
2504 	TimedCrowdsale(_openTime, _closeTime)
2505 	Crowdsale(1, _ownerWallet, _token)
2506     {
2507     }
2508 }