1 pragma solidity ^0.4.18;
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
38     OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 
42 }
43 
44 
45 
46 /**
47  * @title ERC20Basic
48  * @dev Simpler version of ERC20 interface
49  * @dev see https://github.com/ethereum/EIPs/issues/179
50  */
51 contract ERC20Basic {
52   function totalSupply() public view returns (uint256);
53   function balanceOf(address who) public view returns (uint256);
54   function transfer(address to, uint256 value) public returns (bool);
55   event Transfer(address indexed from, address indexed to, uint256 value);
56 }
57 
58 
59 
60 /**
61  * @title SafeMath
62  * @dev Math operations with safety checks that throw on error
63  */
64 library SafeMath {
65 
66   /**
67   * @dev Multiplies two numbers, throws on overflow.
68   */
69   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
70     if (a == 0) {
71       return 0;
72     }
73     uint256 c = a * b;
74     assert(c / a == b);
75     return c;
76   }
77 
78   /**
79   * @dev Integer division of two numbers, truncating the quotient.
80   */
81   function div(uint256 a, uint256 b) internal pure returns (uint256) {
82     // assert(b > 0); // Solidity automatically throws when dividing by 0
83     uint256 c = a / b;
84     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
85     return c;
86   }
87 
88   /**
89   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
90   */
91   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
92     assert(b <= a);
93     return a - b;
94   }
95 
96   /**
97   * @dev Adds two numbers, throws on overflow.
98   */
99   function add(uint256 a, uint256 b) internal pure returns (uint256) {
100     uint256 c = a + b;
101     assert(c >= a);
102     return c;
103   }
104 }
105 
106 
107 
108 
109 
110 
111 
112 /**
113  * @title ERC20 interface
114  * @dev see https://github.com/ethereum/EIPs/issues/20
115  */
116 contract ERC20 is ERC20Basic {
117   function allowance(address owner, address spender) public view returns (uint256);
118   function transferFrom(address from, address to, uint256 value) public returns (bool);
119   function approve(address spender, uint256 value) public returns (bool);
120   event Approval(address indexed owner, address indexed spender, uint256 value);
121 }
122 
123 
124 
125 
126 
127 
128 
129 
130 /**
131  * @title Basic token
132  * @dev Basic version of StandardToken, with no allowances.
133  */
134 contract BasicToken is ERC20Basic {
135   using SafeMath for uint256;
136 
137   mapping(address => uint256) balances;
138 
139   uint256 totalSupply_;
140 
141   /**
142   * @dev total number of tokens in existence
143   */
144   function totalSupply() public view returns (uint256) {
145     return totalSupply_;
146   }
147 
148   /**
149   * @dev transfer token for a specified address
150   * @param _to The address to transfer to.
151   * @param _value The amount to be transferred.
152   */
153   function transfer(address _to, uint256 _value) public returns (bool) {
154     require(_to != address(0));
155     require(_value <= balances[msg.sender]);
156 
157     // SafeMath.sub will throw if there is not enough balance.
158     balances[msg.sender] = balances[msg.sender].sub(_value);
159     balances[_to] = balances[_to].add(_value);
160     Transfer(msg.sender, _to, _value);
161     return true;
162   }
163 
164   /**
165   * @dev Gets the balance of the specified address.
166   * @param _owner The address to query the the balance of.
167   * @return An uint256 representing the amount owned by the passed address.
168   */
169   function balanceOf(address _owner) public view returns (uint256 balance) {
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
207     Transfer(_from, _to, _value);
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
223     Approval(msg.sender, _spender, _value);
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
249     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
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
270     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
271     return true;
272   }
273 
274 }
275 
276 
277 
278 
279 
280 
281 
282 /**
283    @title ERC827 interface, an extension of ERC20 token standard
284 
285    Interface of a ERC827 token, following the ERC20 standard with extra
286    methods to transfer value and data and execute calls in transfers and
287    approvals.
288  */
289 contract ERC827 is ERC20 {
290 
291   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
292   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
293   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
294 
295 }
296 
297 
298 
299 
300 
301 
302 /**
303    @title ERC827, an extension of ERC20 token standard
304 
305    Implementation the ERC827, following the ERC20 standard with extra
306    methods to transfer value and data and execute calls in transfers and
307    approvals.
308    Uses OpenZeppelin StandardToken.
309  */
310 contract ERC827Token is ERC827, StandardToken {
311 
312   /**
313      @dev Addition to ERC20 token methods. It allows to
314      approve the transfer of value and execute a call with the sent data.
315 
316      Beware that changing an allowance with this method brings the risk that
317      someone may use both the old and the new allowance by unfortunate
318      transaction ordering. One possible solution to mitigate this race condition
319      is to first reduce the spender's allowance to 0 and set the desired value
320      afterwards:
321      https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
322 
323      @param _spender The address that will spend the funds.
324      @param _value The amount of tokens to be spent.
325      @param _data ABI-encoded contract call to call `_to` address.
326 
327      @return true if the call function was executed successfully
328    */
329   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
330     require(_spender != address(this));
331 
332     super.approve(_spender, _value);
333 
334     require(_spender.call(_data));
335 
336     return true;
337   }
338 
339   /**
340      @dev Addition to ERC20 token methods. Transfer tokens to a specified
341      address and execute a call with the sent data on the same transaction
342 
343      @param _to address The address which you want to transfer to
344      @param _value uint256 the amout of tokens to be transfered
345      @param _data ABI-encoded contract call to call `_to` address.
346 
347      @return true if the call function was executed successfully
348    */
349   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
350     require(_to != address(this));
351 
352     super.transfer(_to, _value);
353 
354     require(_to.call(_data));
355     return true;
356   }
357 
358   /**
359      @dev Addition to ERC20 token methods. Transfer tokens from one address to
360      another and make a contract call on the same transaction
361 
362      @param _from The address which you want to send tokens from
363      @param _to The address which you want to transfer to
364      @param _value The amout of tokens to be transferred
365      @param _data ABI-encoded contract call to call `_to` address.
366 
367      @return true if the call function was executed successfully
368    */
369   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
370     require(_to != address(this));
371 
372     super.transferFrom(_from, _to, _value);
373 
374     require(_to.call(_data));
375     return true;
376   }
377 
378   /**
379    * @dev Addition to StandardToken methods. Increase the amount of tokens that
380    * an owner allowed to a spender and execute a call with the sent data.
381    *
382    * approve should be called when allowed[_spender] == 0. To increment
383    * allowed value is better to use this function to avoid 2 calls (and wait until
384    * the first transaction is mined)
385    * From MonolithDAO Token.sol
386    * @param _spender The address which will spend the funds.
387    * @param _addedValue The amount of tokens to increase the allowance by.
388    * @param _data ABI-encoded contract call to call `_spender` address.
389    */
390   function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
391     require(_spender != address(this));
392 
393     super.increaseApproval(_spender, _addedValue);
394 
395     require(_spender.call(_data));
396 
397     return true;
398   }
399 
400   /**
401    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
402    * an owner allowed to a spender and execute a call with the sent data.
403    *
404    * approve should be called when allowed[_spender] == 0. To decrement
405    * allowed value is better to use this function to avoid 2 calls (and wait until
406    * the first transaction is mined)
407    * From MonolithDAO Token.sol
408    * @param _spender The address which will spend the funds.
409    * @param _subtractedValue The amount of tokens to decrease the allowance by.
410    * @param _data ABI-encoded contract call to call `_spender` address.
411    */
412   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
413     require(_spender != address(this));
414 
415     super.decreaseApproval(_spender, _subtractedValue);
416 
417     require(_spender.call(_data));
418 
419     return true;
420   }
421 
422 }
423 
424 
425 /**
426  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
427  *
428  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
429  */
430 
431 
432 
433 
434 
435 
436 contract Recoverable is Ownable {
437 
438   /// @dev Empty constructor (for now)
439   function Recoverable() {
440   }
441 
442   /// @dev This will be invoked by the owner, when owner wants to rescue tokens
443   /// @param token Token which will we rescue to the owner from the contract
444   function recoverTokens(ERC20Basic token) onlyOwner public {
445     token.transfer(owner, tokensToBeReturned(token));
446   }
447 
448   /// @dev Interface function, can be overwritten by the superclass
449   /// @param token Token which balance we will check and return
450   /// @return The amount of tokens (in smallest denominator) the contract owns
451   function tokensToBeReturned(ERC20Basic token) public returns (uint) {
452     return token.balanceOf(this);
453   }
454 }
455 
456 /**
457  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
458  *
459  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
460  */
461 
462 
463 
464 
465 
466 
467 
468 
469 /**
470  * Standard EIP-20 token with an interface marker.
471  *
472  * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.
473  *
474  */
475 contract StandardTokenExt is StandardToken, ERC827Token, Recoverable {
476 
477   /* Interface declaration */
478   function isToken() public constant returns (bool weAre) {
479     return true;
480   }
481 }
482 
483 // <ORACLIZE_API>
484 /*
485 Copyright (c) 2015-2016 Oraclize SRL
486 Copyright (c) 2016 Oraclize LTD
487 
488 
489 
490 Permission is hereby granted, free of charge, to any person obtaining a copy
491 of this software and associated documentation files (the "Software"), to deal
492 in the Software without restriction, including without limitation the rights
493 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
494 copies of the Software, and to permit persons to whom the Software is
495 furnished to do so, subject to the following conditions:
496 
497 
498 
499 The above copyright notice and this permission notice shall be included in
500 all copies or substantial portions of the Software.
501 
502 
503 
504 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
505 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
506 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
507 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
508 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
509 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
510 THE SOFTWARE.
511 */
512 
513 
514 
515 contract OraclizeI {
516     address public cbAddress;
517     function query(uint _timestamp, string _datasource, string _arg) payable returns (bytes32 _id);
518     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) payable returns (bytes32 _id);
519     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) payable returns (bytes32 _id);
520     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) payable returns (bytes32 _id);
521     function queryN(uint _timestamp, string _datasource, bytes _argN) payable returns (bytes32 _id);
522     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) payable returns (bytes32 _id);
523     function getPrice(string _datasource) returns (uint _dsprice);
524     function getPrice(string _datasource, uint gaslimit) returns (uint _dsprice);
525     function useCoupon(string _coupon);
526     function setProofType(byte _proofType);
527     function setConfig(bytes32 _config);
528     function setCustomGasPrice(uint _gasPrice);
529     function randomDS_getSessionPubKeyHash() returns(bytes32);
530 }
531 
532 contract OraclizeAddrResolverI {
533     function getAddress() returns (address _addr);
534 }
535 
536 /*
537 Begin solidity-cborutils
538 
539 https://github.com/smartcontractkit/solidity-cborutils
540 
541 MIT License
542 
543 Copyright (c) 2018 SmartContract ChainLink, Ltd.
544 
545 Permission is hereby granted, free of charge, to any person obtaining a copy
546 of this software and associated documentation files (the "Software"), to deal
547 in the Software without restriction, including without limitation the rights
548 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
549 copies of the Software, and to permit persons to whom the Software is
550 furnished to do so, subject to the following conditions:
551 
552 The above copyright notice and this permission notice shall be included in all
553 copies or substantial portions of the Software.
554 
555 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
556 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
557 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
558 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
559 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
560 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
561 SOFTWARE.
562  */
563 
564 library Buffer {
565     struct buffer {
566         bytes buf;
567         uint capacity;
568     }
569 
570     function init(buffer memory buf, uint _capacity) internal constant {
571         uint capacity = _capacity;
572         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
573         // Allocate space for the buffer data
574         buf.capacity = capacity;
575         assembly {
576             let ptr := mload(0x40)
577             mstore(buf, ptr)
578             mstore(ptr, 0)
579             mstore(0x40, add(ptr, capacity))
580         }
581     }
582 
583     function resize(buffer memory buf, uint capacity) private constant {
584         bytes memory oldbuf = buf.buf;
585         init(buf, capacity);
586         append(buf, oldbuf);
587     }
588 
589     function max(uint a, uint b) private constant returns(uint) {
590         if(a > b) {
591             return a;
592         }
593         return b;
594     }
595 
596     /**
597      * @dev Appends a byte array to the end of the buffer. Resizes if doing so
598      *      would exceed the capacity of the buffer.
599      * @param buf The buffer to append to.
600      * @param data The data to append.
601      * @return The original buffer.
602      */
603     function append(buffer memory buf, bytes data) internal constant returns(buffer memory) {
604         if(data.length + buf.buf.length > buf.capacity) {
605             resize(buf, max(buf.capacity, data.length) * 2);
606         }
607 
608         uint dest;
609         uint src;
610         uint len = data.length;
611         assembly {
612             // Memory address of the buffer data
613             let bufptr := mload(buf)
614             // Length of existing buffer data
615             let buflen := mload(bufptr)
616             // Start address = buffer address + buffer length + sizeof(buffer length)
617             dest := add(add(bufptr, buflen), 32)
618             // Update buffer length
619             mstore(bufptr, add(buflen, mload(data)))
620             src := add(data, 32)
621         }
622 
623         // Copy word-length chunks while possible
624         for(; len >= 32; len -= 32) {
625             assembly {
626                 mstore(dest, mload(src))
627             }
628             dest += 32;
629             src += 32;
630         }
631 
632         // Copy remaining bytes
633         uint mask = 256 ** (32 - len) - 1;
634         assembly {
635             let srcpart := and(mload(src), not(mask))
636             let destpart := and(mload(dest), mask)
637             mstore(dest, or(destpart, srcpart))
638         }
639 
640         return buf;
641     }
642 
643     /**
644      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
645      * exceed the capacity of the buffer.
646      * @param buf The buffer to append to.
647      * @param data The data to append.
648      * @return The original buffer.
649      */
650     function append(buffer memory buf, uint8 data) internal constant {
651         if(buf.buf.length + 1 > buf.capacity) {
652             resize(buf, buf.capacity * 2);
653         }
654 
655         assembly {
656             // Memory address of the buffer data
657             let bufptr := mload(buf)
658             // Length of existing buffer data
659             let buflen := mload(bufptr)
660             // Address = buffer address + buffer length + sizeof(buffer length)
661             let dest := add(add(bufptr, buflen), 32)
662             mstore8(dest, data)
663             // Update buffer length
664             mstore(bufptr, add(buflen, 1))
665         }
666     }
667 
668     /**
669      * @dev Appends a byte to the end of the buffer. Resizes if doing so would
670      * exceed the capacity of the buffer.
671      * @param buf The buffer to append to.
672      * @param data The data to append.
673      * @return The original buffer.
674      */
675     function appendInt(buffer memory buf, uint data, uint len) internal constant returns(buffer memory) {
676         if(len + buf.buf.length > buf.capacity) {
677             resize(buf, max(buf.capacity, len) * 2);
678         }
679 
680         uint mask = 256 ** len - 1;
681         assembly {
682             // Memory address of the buffer data
683             let bufptr := mload(buf)
684             // Length of existing buffer data
685             let buflen := mload(bufptr)
686             // Address = buffer address + buffer length + sizeof(buffer length) + len
687             let dest := add(add(bufptr, buflen), len)
688             mstore(dest, or(and(mload(dest), not(mask)), data))
689             // Update buffer length
690             mstore(bufptr, add(buflen, len))
691         }
692         return buf;
693     }
694 }
695 
696 library CBOR {
697     using Buffer for Buffer.buffer;
698 
699     uint8 private constant MAJOR_TYPE_INT = 0;
700     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
701     uint8 private constant MAJOR_TYPE_BYTES = 2;
702     uint8 private constant MAJOR_TYPE_STRING = 3;
703     uint8 private constant MAJOR_TYPE_ARRAY = 4;
704     uint8 private constant MAJOR_TYPE_MAP = 5;
705     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
706 
707     function shl8(uint8 x, uint8 y) private constant returns (uint8) {
708         return x * (2 ** y);
709     }
710 
711     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private constant {
712         if(value <= 23) {
713             buf.append(uint8(shl8(major, 5) | value));
714         } else if(value <= 0xFF) {
715             buf.append(uint8(shl8(major, 5) | 24));
716             buf.appendInt(value, 1);
717         } else if(value <= 0xFFFF) {
718             buf.append(uint8(shl8(major, 5) | 25));
719             buf.appendInt(value, 2);
720         } else if(value <= 0xFFFFFFFF) {
721             buf.append(uint8(shl8(major, 5) | 26));
722             buf.appendInt(value, 4);
723         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
724             buf.append(uint8(shl8(major, 5) | 27));
725             buf.appendInt(value, 8);
726         }
727     }
728 
729     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private constant {
730         buf.append(uint8(shl8(major, 5) | 31));
731     }
732 
733     function encodeUInt(Buffer.buffer memory buf, uint value) internal constant {
734         encodeType(buf, MAJOR_TYPE_INT, value);
735     }
736 
737     function encodeInt(Buffer.buffer memory buf, int value) internal constant {
738         if(value >= 0) {
739             encodeType(buf, MAJOR_TYPE_INT, uint(value));
740         } else {
741             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
742         }
743     }
744 
745     function encodeBytes(Buffer.buffer memory buf, bytes value) internal constant {
746         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
747         buf.append(value);
748     }
749 
750     function encodeString(Buffer.buffer memory buf, string value) internal constant {
751         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
752         buf.append(bytes(value));
753     }
754 
755     function startArray(Buffer.buffer memory buf) internal constant {
756         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
757     }
758 
759     function startMap(Buffer.buffer memory buf) internal constant {
760         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
761     }
762 
763     function endSequence(Buffer.buffer memory buf) internal constant {
764         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
765     }
766 }
767 
768 /*
769 End solidity-cborutils
770  */
771 
772 contract usingOraclize {
773     uint constant day = 60*60*24;
774     uint constant week = 60*60*24*7;
775     uint constant month = 60*60*24*30;
776     byte constant proofType_NONE = 0x00;
777     byte constant proofType_TLSNotary = 0x10;
778     byte constant proofType_Ledger = 0x30;
779     byte constant proofType_Android = 0x40;
780     byte constant proofType_Native = 0xF0;
781     byte constant proofStorage_IPFS = 0x01;
782     uint8 constant networkID_auto = 0;
783     uint8 constant networkID_mainnet = 1;
784     uint8 constant networkID_testnet = 2;
785     uint8 constant networkID_morden = 2;
786     uint8 constant networkID_consensys = 161;
787 
788     OraclizeAddrResolverI OAR;
789 
790     OraclizeI oraclize;
791     modifier oraclizeAPI {
792         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
793             oraclize_setNetwork(networkID_auto);
794 
795         if(address(oraclize) != OAR.getAddress())
796             oraclize = OraclizeI(OAR.getAddress());
797 
798         _;
799     }
800     modifier coupon(string code){
801         oraclize = OraclizeI(OAR.getAddress());
802         oraclize.useCoupon(code);
803         _;
804     }
805 
806     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
807         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
808             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
809             oraclize_setNetworkName("eth_mainnet");
810             return true;
811         }
812         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
813             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
814             oraclize_setNetworkName("eth_ropsten3");
815             return true;
816         }
817         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
818             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
819             oraclize_setNetworkName("eth_kovan");
820             return true;
821         }
822         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
823             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
824             oraclize_setNetworkName("eth_rinkeby");
825             return true;
826         }
827         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
828             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
829             return true;
830         }
831         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
832             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
833             return true;
834         }
835         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
836             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
837             return true;
838         }
839         return false;
840     }
841 
842     function __callback(bytes32 myid, string result) {
843         __callback(myid, result, new bytes(0));
844     }
845     function __callback(bytes32 myid, string result, bytes proof) {
846     }
847 
848     function oraclize_useCoupon(string code) oraclizeAPI internal {
849         oraclize.useCoupon(code);
850     }
851 
852     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
853         return oraclize.getPrice(datasource);
854     }
855 
856     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
857         return oraclize.getPrice(datasource, gaslimit);
858     }
859 
860     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
861         uint price = oraclize.getPrice(datasource);
862         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
863         return oraclize.query.value(price)(0, datasource, arg);
864     }
865     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
866         uint price = oraclize.getPrice(datasource);
867         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
868         return oraclize.query.value(price)(timestamp, datasource, arg);
869     }
870     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
871         uint price = oraclize.getPrice(datasource, gaslimit);
872         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
873         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
874     }
875     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
876         uint price = oraclize.getPrice(datasource, gaslimit);
877         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
878         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
879     }
880     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
881         uint price = oraclize.getPrice(datasource);
882         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
883         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
884     }
885     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
886         uint price = oraclize.getPrice(datasource);
887         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
888         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
889     }
890     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
891         uint price = oraclize.getPrice(datasource, gaslimit);
892         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
893         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
894     }
895     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
896         uint price = oraclize.getPrice(datasource, gaslimit);
897         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
898         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
899     }
900     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
901         uint price = oraclize.getPrice(datasource);
902         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
903         bytes memory args = stra2cbor(argN);
904         return oraclize.queryN.value(price)(0, datasource, args);
905     }
906     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
907         uint price = oraclize.getPrice(datasource);
908         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
909         bytes memory args = stra2cbor(argN);
910         return oraclize.queryN.value(price)(timestamp, datasource, args);
911     }
912     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
913         uint price = oraclize.getPrice(datasource, gaslimit);
914         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
915         bytes memory args = stra2cbor(argN);
916         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
917     }
918     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
919         uint price = oraclize.getPrice(datasource, gaslimit);
920         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
921         bytes memory args = stra2cbor(argN);
922         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
923     }
924     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
925         string[] memory dynargs = new string[](1);
926         dynargs[0] = args[0];
927         return oraclize_query(datasource, dynargs);
928     }
929     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
930         string[] memory dynargs = new string[](1);
931         dynargs[0] = args[0];
932         return oraclize_query(timestamp, datasource, dynargs);
933     }
934     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
935         string[] memory dynargs = new string[](1);
936         dynargs[0] = args[0];
937         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
938     }
939     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
940         string[] memory dynargs = new string[](1);
941         dynargs[0] = args[0];
942         return oraclize_query(datasource, dynargs, gaslimit);
943     }
944 
945     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
946         string[] memory dynargs = new string[](2);
947         dynargs[0] = args[0];
948         dynargs[1] = args[1];
949         return oraclize_query(datasource, dynargs);
950     }
951     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
952         string[] memory dynargs = new string[](2);
953         dynargs[0] = args[0];
954         dynargs[1] = args[1];
955         return oraclize_query(timestamp, datasource, dynargs);
956     }
957     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
958         string[] memory dynargs = new string[](2);
959         dynargs[0] = args[0];
960         dynargs[1] = args[1];
961         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
962     }
963     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
964         string[] memory dynargs = new string[](2);
965         dynargs[0] = args[0];
966         dynargs[1] = args[1];
967         return oraclize_query(datasource, dynargs, gaslimit);
968     }
969     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
970         string[] memory dynargs = new string[](3);
971         dynargs[0] = args[0];
972         dynargs[1] = args[1];
973         dynargs[2] = args[2];
974         return oraclize_query(datasource, dynargs);
975     }
976     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
977         string[] memory dynargs = new string[](3);
978         dynargs[0] = args[0];
979         dynargs[1] = args[1];
980         dynargs[2] = args[2];
981         return oraclize_query(timestamp, datasource, dynargs);
982     }
983     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
984         string[] memory dynargs = new string[](3);
985         dynargs[0] = args[0];
986         dynargs[1] = args[1];
987         dynargs[2] = args[2];
988         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
989     }
990     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
991         string[] memory dynargs = new string[](3);
992         dynargs[0] = args[0];
993         dynargs[1] = args[1];
994         dynargs[2] = args[2];
995         return oraclize_query(datasource, dynargs, gaslimit);
996     }
997 
998     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
999         string[] memory dynargs = new string[](4);
1000         dynargs[0] = args[0];
1001         dynargs[1] = args[1];
1002         dynargs[2] = args[2];
1003         dynargs[3] = args[3];
1004         return oraclize_query(datasource, dynargs);
1005     }
1006     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1007         string[] memory dynargs = new string[](4);
1008         dynargs[0] = args[0];
1009         dynargs[1] = args[1];
1010         dynargs[2] = args[2];
1011         dynargs[3] = args[3];
1012         return oraclize_query(timestamp, datasource, dynargs);
1013     }
1014     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1015         string[] memory dynargs = new string[](4);
1016         dynargs[0] = args[0];
1017         dynargs[1] = args[1];
1018         dynargs[2] = args[2];
1019         dynargs[3] = args[3];
1020         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1021     }
1022     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1023         string[] memory dynargs = new string[](4);
1024         dynargs[0] = args[0];
1025         dynargs[1] = args[1];
1026         dynargs[2] = args[2];
1027         dynargs[3] = args[3];
1028         return oraclize_query(datasource, dynargs, gaslimit);
1029     }
1030     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1031         string[] memory dynargs = new string[](5);
1032         dynargs[0] = args[0];
1033         dynargs[1] = args[1];
1034         dynargs[2] = args[2];
1035         dynargs[3] = args[3];
1036         dynargs[4] = args[4];
1037         return oraclize_query(datasource, dynargs);
1038     }
1039     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1040         string[] memory dynargs = new string[](5);
1041         dynargs[0] = args[0];
1042         dynargs[1] = args[1];
1043         dynargs[2] = args[2];
1044         dynargs[3] = args[3];
1045         dynargs[4] = args[4];
1046         return oraclize_query(timestamp, datasource, dynargs);
1047     }
1048     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1049         string[] memory dynargs = new string[](5);
1050         dynargs[0] = args[0];
1051         dynargs[1] = args[1];
1052         dynargs[2] = args[2];
1053         dynargs[3] = args[3];
1054         dynargs[4] = args[4];
1055         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1056     }
1057     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1058         string[] memory dynargs = new string[](5);
1059         dynargs[0] = args[0];
1060         dynargs[1] = args[1];
1061         dynargs[2] = args[2];
1062         dynargs[3] = args[3];
1063         dynargs[4] = args[4];
1064         return oraclize_query(datasource, dynargs, gaslimit);
1065     }
1066     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1067         uint price = oraclize.getPrice(datasource);
1068         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1069         bytes memory args = ba2cbor(argN);
1070         return oraclize.queryN.value(price)(0, datasource, args);
1071     }
1072     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1073         uint price = oraclize.getPrice(datasource);
1074         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1075         bytes memory args = ba2cbor(argN);
1076         return oraclize.queryN.value(price)(timestamp, datasource, args);
1077     }
1078     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1079         uint price = oraclize.getPrice(datasource, gaslimit);
1080         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1081         bytes memory args = ba2cbor(argN);
1082         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
1083     }
1084     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1085         uint price = oraclize.getPrice(datasource, gaslimit);
1086         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1087         bytes memory args = ba2cbor(argN);
1088         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
1089     }
1090     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1091         bytes[] memory dynargs = new bytes[](1);
1092         dynargs[0] = args[0];
1093         return oraclize_query(datasource, dynargs);
1094     }
1095     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1096         bytes[] memory dynargs = new bytes[](1);
1097         dynargs[0] = args[0];
1098         return oraclize_query(timestamp, datasource, dynargs);
1099     }
1100     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1101         bytes[] memory dynargs = new bytes[](1);
1102         dynargs[0] = args[0];
1103         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1104     }
1105     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1106         bytes[] memory dynargs = new bytes[](1);
1107         dynargs[0] = args[0];
1108         return oraclize_query(datasource, dynargs, gaslimit);
1109     }
1110 
1111     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1112         bytes[] memory dynargs = new bytes[](2);
1113         dynargs[0] = args[0];
1114         dynargs[1] = args[1];
1115         return oraclize_query(datasource, dynargs);
1116     }
1117     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1118         bytes[] memory dynargs = new bytes[](2);
1119         dynargs[0] = args[0];
1120         dynargs[1] = args[1];
1121         return oraclize_query(timestamp, datasource, dynargs);
1122     }
1123     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1124         bytes[] memory dynargs = new bytes[](2);
1125         dynargs[0] = args[0];
1126         dynargs[1] = args[1];
1127         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1128     }
1129     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1130         bytes[] memory dynargs = new bytes[](2);
1131         dynargs[0] = args[0];
1132         dynargs[1] = args[1];
1133         return oraclize_query(datasource, dynargs, gaslimit);
1134     }
1135     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1136         bytes[] memory dynargs = new bytes[](3);
1137         dynargs[0] = args[0];
1138         dynargs[1] = args[1];
1139         dynargs[2] = args[2];
1140         return oraclize_query(datasource, dynargs);
1141     }
1142     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1143         bytes[] memory dynargs = new bytes[](3);
1144         dynargs[0] = args[0];
1145         dynargs[1] = args[1];
1146         dynargs[2] = args[2];
1147         return oraclize_query(timestamp, datasource, dynargs);
1148     }
1149     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1150         bytes[] memory dynargs = new bytes[](3);
1151         dynargs[0] = args[0];
1152         dynargs[1] = args[1];
1153         dynargs[2] = args[2];
1154         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1155     }
1156     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1157         bytes[] memory dynargs = new bytes[](3);
1158         dynargs[0] = args[0];
1159         dynargs[1] = args[1];
1160         dynargs[2] = args[2];
1161         return oraclize_query(datasource, dynargs, gaslimit);
1162     }
1163 
1164     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1165         bytes[] memory dynargs = new bytes[](4);
1166         dynargs[0] = args[0];
1167         dynargs[1] = args[1];
1168         dynargs[2] = args[2];
1169         dynargs[3] = args[3];
1170         return oraclize_query(datasource, dynargs);
1171     }
1172     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1173         bytes[] memory dynargs = new bytes[](4);
1174         dynargs[0] = args[0];
1175         dynargs[1] = args[1];
1176         dynargs[2] = args[2];
1177         dynargs[3] = args[3];
1178         return oraclize_query(timestamp, datasource, dynargs);
1179     }
1180     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1181         bytes[] memory dynargs = new bytes[](4);
1182         dynargs[0] = args[0];
1183         dynargs[1] = args[1];
1184         dynargs[2] = args[2];
1185         dynargs[3] = args[3];
1186         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1187     }
1188     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1189         bytes[] memory dynargs = new bytes[](4);
1190         dynargs[0] = args[0];
1191         dynargs[1] = args[1];
1192         dynargs[2] = args[2];
1193         dynargs[3] = args[3];
1194         return oraclize_query(datasource, dynargs, gaslimit);
1195     }
1196     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1197         bytes[] memory dynargs = new bytes[](5);
1198         dynargs[0] = args[0];
1199         dynargs[1] = args[1];
1200         dynargs[2] = args[2];
1201         dynargs[3] = args[3];
1202         dynargs[4] = args[4];
1203         return oraclize_query(datasource, dynargs);
1204     }
1205     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1206         bytes[] memory dynargs = new bytes[](5);
1207         dynargs[0] = args[0];
1208         dynargs[1] = args[1];
1209         dynargs[2] = args[2];
1210         dynargs[3] = args[3];
1211         dynargs[4] = args[4];
1212         return oraclize_query(timestamp, datasource, dynargs);
1213     }
1214     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1215         bytes[] memory dynargs = new bytes[](5);
1216         dynargs[0] = args[0];
1217         dynargs[1] = args[1];
1218         dynargs[2] = args[2];
1219         dynargs[3] = args[3];
1220         dynargs[4] = args[4];
1221         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1222     }
1223     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1224         bytes[] memory dynargs = new bytes[](5);
1225         dynargs[0] = args[0];
1226         dynargs[1] = args[1];
1227         dynargs[2] = args[2];
1228         dynargs[3] = args[3];
1229         dynargs[4] = args[4];
1230         return oraclize_query(datasource, dynargs, gaslimit);
1231     }
1232 
1233     function oraclize_cbAddress() oraclizeAPI internal returns (address){
1234         return oraclize.cbAddress();
1235     }
1236     function oraclize_setProof(byte proofP) oraclizeAPI internal {
1237         return oraclize.setProofType(proofP);
1238     }
1239     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
1240         return oraclize.setCustomGasPrice(gasPrice);
1241     }
1242     function oraclize_setConfig(bytes32 config) oraclizeAPI internal {
1243         return oraclize.setConfig(config);
1244     }
1245 
1246     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
1247         return oraclize.randomDS_getSessionPubKeyHash();
1248     }
1249 
1250     function getCodeSize(address _addr) constant internal returns(uint _size) {
1251         assembly {
1252             _size := extcodesize(_addr)
1253         }
1254     }
1255 
1256     function parseAddr(string _a) internal returns (address){
1257         bytes memory tmp = bytes(_a);
1258         uint160 iaddr = 0;
1259         uint160 b1;
1260         uint160 b2;
1261         for (uint i=2; i<2+2*20; i+=2){
1262             iaddr *= 256;
1263             b1 = uint160(tmp[i]);
1264             b2 = uint160(tmp[i+1]);
1265             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
1266             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
1267             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
1268             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
1269             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
1270             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
1271             iaddr += (b1*16+b2);
1272         }
1273         return address(iaddr);
1274     }
1275 
1276     function strCompare(string _a, string _b) internal returns (int) {
1277         bytes memory a = bytes(_a);
1278         bytes memory b = bytes(_b);
1279         uint minLength = a.length;
1280         if (b.length < minLength) minLength = b.length;
1281         for (uint i = 0; i < minLength; i ++)
1282             if (a[i] < b[i])
1283                 return -1;
1284             else if (a[i] > b[i])
1285                 return 1;
1286         if (a.length < b.length)
1287             return -1;
1288         else if (a.length > b.length)
1289             return 1;
1290         else
1291             return 0;
1292     }
1293 
1294     function indexOf(string _haystack, string _needle) internal returns (int) {
1295         bytes memory h = bytes(_haystack);
1296         bytes memory n = bytes(_needle);
1297         if(h.length < 1 || n.length < 1 || (n.length > h.length))
1298             return -1;
1299         else if(h.length > (2**128 -1))
1300             return -1;
1301         else
1302         {
1303             uint subindex = 0;
1304             for (uint i = 0; i < h.length; i ++)
1305             {
1306                 if (h[i] == n[0])
1307                 {
1308                     subindex = 1;
1309                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
1310                     {
1311                         subindex++;
1312                     }
1313                     if(subindex == n.length)
1314                         return int(i);
1315                 }
1316             }
1317             return -1;
1318         }
1319     }
1320 
1321     function strConcat(string _a, string _b, string _c, string _d, string _e) internal returns (string) {
1322         bytes memory _ba = bytes(_a);
1323         bytes memory _bb = bytes(_b);
1324         bytes memory _bc = bytes(_c);
1325         bytes memory _bd = bytes(_d);
1326         bytes memory _be = bytes(_e);
1327         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1328         bytes memory babcde = bytes(abcde);
1329         uint k = 0;
1330         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1331         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1332         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1333         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1334         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1335         return string(babcde);
1336     }
1337 
1338     function strConcat(string _a, string _b, string _c, string _d) internal returns (string) {
1339         return strConcat(_a, _b, _c, _d, "");
1340     }
1341 
1342     function strConcat(string _a, string _b, string _c) internal returns (string) {
1343         return strConcat(_a, _b, _c, "", "");
1344     }
1345 
1346     function strConcat(string _a, string _b) internal returns (string) {
1347         return strConcat(_a, _b, "", "", "");
1348     }
1349 
1350     // parseInt
1351     function parseInt(string _a) internal returns (uint) {
1352         return parseInt(_a, 0);
1353     }
1354 
1355     // parseInt(parseFloat*10^_b)
1356     function parseInt(string _a, uint _b) internal returns (uint) {
1357         bytes memory bresult = bytes(_a);
1358         uint mint = 0;
1359         bool decimals = false;
1360         for (uint i=0; i<bresult.length; i++){
1361             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
1362                 if (decimals){
1363                    if (_b == 0) break;
1364                     else _b--;
1365                 }
1366                 mint *= 10;
1367                 mint += uint(bresult[i]) - 48;
1368             } else if (bresult[i] == 46) decimals = true;
1369         }
1370         if (_b > 0) mint *= 10**_b;
1371         return mint;
1372     }
1373 
1374     function uint2str(uint i) internal returns (string){
1375         if (i == 0) return "0";
1376         uint j = i;
1377         uint len;
1378         while (j != 0){
1379             len++;
1380             j /= 10;
1381         }
1382         bytes memory bstr = new bytes(len);
1383         uint k = len - 1;
1384         while (i != 0){
1385             bstr[k--] = byte(48 + i % 10);
1386             i /= 10;
1387         }
1388         return string(bstr);
1389     }
1390 
1391     using CBOR for Buffer.buffer;
1392     function stra2cbor(string[] arr) internal constant returns (bytes) {
1393         safeMemoryCleaner();
1394         Buffer.buffer memory buf;
1395         Buffer.init(buf, 1024);
1396         buf.startArray();
1397         for (uint i = 0; i < arr.length; i++) {
1398             buf.encodeString(arr[i]);
1399         }
1400         buf.endSequence();
1401         return buf.buf;
1402     }
1403 
1404     function ba2cbor(bytes[] arr) internal constant returns (bytes) {
1405         safeMemoryCleaner();
1406         Buffer.buffer memory buf;
1407         Buffer.init(buf, 1024);
1408         buf.startArray();
1409         for (uint i = 0; i < arr.length; i++) {
1410             buf.encodeBytes(arr[i]);
1411         }
1412         buf.endSequence();
1413         return buf.buf;
1414     }
1415 
1416     string oraclize_network_name;
1417     function oraclize_setNetworkName(string _network_name) internal {
1418         oraclize_network_name = _network_name;
1419     }
1420 
1421     function oraclize_getNetworkName() internal returns (string) {
1422         return oraclize_network_name;
1423     }
1424 
1425     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1426         if ((_nbytes == 0)||(_nbytes > 32)) throw;
1427 	// Convert from seconds to ledger timer ticks
1428         _delay *= 10;
1429         bytes memory nbytes = new bytes(1);
1430         nbytes[0] = byte(_nbytes);
1431         bytes memory unonce = new bytes(32);
1432         bytes memory sessionKeyHash = new bytes(32);
1433         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1434         assembly {
1435             mstore(unonce, 0x20)
1436             // the following variables can be relaxed
1437             // check relaxed random contract under ethereum-examples repo
1438             // for an idea on how to override and replace comit hash vars
1439             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1440             mstore(sessionKeyHash, 0x20)
1441             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1442         }
1443         bytes memory delay = new bytes(32);
1444         assembly {
1445             mstore(add(delay, 0x20), _delay)
1446         }
1447 
1448         bytes memory delay_bytes8 = new bytes(8);
1449         copyBytes(delay, 24, 8, delay_bytes8, 0);
1450 
1451         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1452         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1453 
1454         bytes memory delay_bytes8_left = new bytes(8);
1455 
1456         assembly {
1457             let x := mload(add(delay_bytes8, 0x20))
1458             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1459             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1460             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1461             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1462             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1463             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1464             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1465             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1466 
1467         }
1468 
1469         oraclize_randomDS_setCommitment(queryId, sha3(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1470         return queryId;
1471     }
1472 
1473     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1474         oraclize_randomDS_args[queryId] = commitment;
1475     }
1476 
1477     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1478     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1479 
1480     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1481         bool sigok;
1482         address signer;
1483 
1484         bytes32 sigr;
1485         bytes32 sigs;
1486 
1487         bytes memory sigr_ = new bytes(32);
1488         uint offset = 4+(uint(dersig[3]) - 0x20);
1489         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1490         bytes memory sigs_ = new bytes(32);
1491         offset += 32 + 2;
1492         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1493 
1494         assembly {
1495             sigr := mload(add(sigr_, 32))
1496             sigs := mload(add(sigs_, 32))
1497         }
1498 
1499 
1500         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1501         if (address(sha3(pubkey)) == signer) return true;
1502         else {
1503             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1504             return (address(sha3(pubkey)) == signer);
1505         }
1506     }
1507 
1508     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1509         bool sigok;
1510 
1511         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1512         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1513         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1514 
1515         bytes memory appkey1_pubkey = new bytes(64);
1516         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1517 
1518         bytes memory tosign2 = new bytes(1+65+32);
1519         tosign2[0] = 1; //role
1520         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1521         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1522         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1523         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1524 
1525         if (sigok == false) return false;
1526 
1527 
1528         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1529         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1530 
1531         bytes memory tosign3 = new bytes(1+65);
1532         tosign3[0] = 0xFE;
1533         copyBytes(proof, 3, 65, tosign3, 1);
1534 
1535         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1536         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1537 
1538         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1539 
1540         return sigok;
1541     }
1542 
1543     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1544         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1545         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) throw;
1546 
1547         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1548         if (proofVerified == false) throw;
1549 
1550         _;
1551     }
1552 
1553     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1554         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1555         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1556 
1557         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1558         if (proofVerified == false) return 2;
1559 
1560         return 0;
1561     }
1562 
1563     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal returns (bool){
1564         bool match_ = true;
1565 
1566 	if (prefix.length != n_random_bytes) throw;
1567 
1568         for (uint256 i=0; i< n_random_bytes; i++) {
1569             if (content[i] != prefix[i]) match_ = false;
1570         }
1571 
1572         return match_;
1573     }
1574 
1575     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1576 
1577         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1578         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1579         bytes memory keyhash = new bytes(32);
1580         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1581         if (!(sha3(keyhash) == sha3(sha256(context_name, queryId)))) return false;
1582 
1583         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1584         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1585 
1586         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1587         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1588 
1589         // Step 4: commitment match verification, sha3(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1590         // This is to verify that the computed args match with the ones specified in the query.
1591         bytes memory commitmentSlice1 = new bytes(8+1+32);
1592         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1593 
1594         bytes memory sessionPubkey = new bytes(64);
1595         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1596         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1597 
1598         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1599         if (oraclize_randomDS_args[queryId] == sha3(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1600             delete oraclize_randomDS_args[queryId];
1601         } else return false;
1602 
1603 
1604         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1605         bytes memory tosign1 = new bytes(32+8+1+32);
1606         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1607         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1608 
1609         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1610         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1611             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1612         }
1613 
1614         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1615     }
1616 
1617 
1618     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1619     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal returns (bytes) {
1620         uint minLength = length + toOffset;
1621 
1622         if (to.length < minLength) {
1623             // Buffer too small
1624             throw; // Should be a better way?
1625         }
1626 
1627         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1628         uint i = 32 + fromOffset;
1629         uint j = 32 + toOffset;
1630 
1631         while (i < (32 + fromOffset + length)) {
1632             assembly {
1633                 let tmp := mload(add(from, i))
1634                 mstore(add(to, j), tmp)
1635             }
1636             i += 32;
1637             j += 32;
1638         }
1639 
1640         return to;
1641     }
1642 
1643     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1644     // Duplicate Solidity's ecrecover, but catching the CALL return value
1645     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1646         // We do our own memory management here. Solidity uses memory offset
1647         // 0x40 to store the current end of memory. We write past it (as
1648         // writes are memory extensions), but don't update the offset so
1649         // Solidity will reuse it. The memory used here is only needed for
1650         // this context.
1651 
1652         // FIXME: inline assembly can't access return values
1653         bool ret;
1654         address addr;
1655 
1656         assembly {
1657             let size := mload(0x40)
1658             mstore(size, hash)
1659             mstore(add(size, 32), v)
1660             mstore(add(size, 64), r)
1661             mstore(add(size, 96), s)
1662 
1663             // NOTE: we can reuse the request memory because we deal with
1664             //       the return code
1665             ret := call(3000, 1, 0, size, 128, size, 32)
1666             addr := mload(size)
1667         }
1668 
1669         return (ret, addr);
1670     }
1671 
1672     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1673     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1674         bytes32 r;
1675         bytes32 s;
1676         uint8 v;
1677 
1678         if (sig.length != 65)
1679           return (false, 0);
1680 
1681         // The signature format is a compact form of:
1682         //   {bytes32 r}{bytes32 s}{uint8 v}
1683         // Compact means, uint8 is not padded to 32 bytes.
1684         assembly {
1685             r := mload(add(sig, 32))
1686             s := mload(add(sig, 64))
1687 
1688             // Here we are loading the last 32 bytes. We exploit the fact that
1689             // 'mload' will pad with zeroes if we overread.
1690             // There is no 'mload8' to do this, but that would be nicer.
1691             v := byte(0, mload(add(sig, 96)))
1692 
1693             // Alternative solution:
1694             // 'byte' is not working due to the Solidity parser, so lets
1695             // use the second best option, 'and'
1696             // v := and(mload(add(sig, 65)), 255)
1697         }
1698 
1699         // albeit non-transactional signatures are not specified by the YP, one would expect it
1700         // to match the YP range of [27, 28]
1701         //
1702         // geth uses [0, 1] and some clients have followed. This might change, see:
1703         //  https://github.com/ethereum/go-ethereum/issues/2053
1704         if (v < 27)
1705           v += 27;
1706 
1707         if (v != 27 && v != 28)
1708             return (false, 0);
1709 
1710         return safer_ecrecover(hash, v, r, s);
1711     }
1712 
1713     function safeMemoryCleaner() internal constant {
1714         assembly {
1715             let fmem := mload(0x40)
1716             codecopy(fmem, codesize, sub(msize, fmem))
1717         }
1718     }
1719 }
1720 // </ORACLIZE_API>
1721 
1722 
1723 contract LoteoGame is Recoverable, usingOraclize {
1724   using SafeMath for uint256;
1725 
1726   StandardTokenExt public ticketToken;
1727   StandardTokenExt public bonusToken;
1728   uint256 public interval;
1729   uint256 public firstGameTime;
1730   address public ticketVault;
1731   address public bonusVault;
1732   address public serviceVault;
1733   address public feeVault;
1734 
1735   struct  Game {
1736     uint256 endTime;
1737     mapping(uint256 => address) tickets;
1738     uint256 ticketsBought;
1739     uint256 ticketsUsed;
1740     address winner;
1741     uint256 prize;
1742     uint256 seed;
1743     mapping(address => uint256) ticketsByUser;
1744   }
1745 
1746   mapping(uint256 => Game) public games;
1747   uint256 public gameIndex;
1748   uint256 public maxOneTimeBuy = 100;
1749   uint256 public silencePeriod = 1800;
1750   uint256 public ticketCostInWei = 10000000000000000;
1751   uint256 public feesInWei = 0;
1752   string private apiKey = "1aed91d9";
1753 
1754   event GameResolved(string result, address winner, uint256 prize);
1755 
1756   mapping (address => bool) public priceAgents;
1757 
1758   modifier onlyPriceAgent() {
1759     if(!priceAgents[msg.sender]) {
1760       revert();
1761     }
1762     _;
1763   }
1764 
1765   function setPriceAgent(address addr, bool state) onlyOwner public {
1766     priceAgents[addr] = state;
1767   }
1768 
1769   function LoteoGame(address _ticketToken, address _bonusToken, uint256 _interval, uint256 _firstGameTime, uint256 _seed) {
1770     if (now > _firstGameTime) revert();
1771     ticketToken = StandardTokenExt(_ticketToken);
1772     bonusToken = StandardTokenExt(_bonusToken);
1773     interval = _interval;
1774     firstGameTime = _firstGameTime;
1775     gameIndex = 0;
1776     games[gameIndex].endTime = firstGameTime;
1777     games[gameIndex].seed = _seed;
1778   }
1779 
1780   function() payable public {
1781   }
1782 
1783   function PRIZE_POOL() public view returns (string) {
1784     uint256 prizeInWei = games[gameIndex].ticketsBought.mul(ticketCostInWei);
1785     uint256 whole = prizeInWei.div(1 ether);
1786     uint256 fraction = prizeInWei.div(1 finney) - (whole.mul(1000));
1787     string memory fractionString = uint2str(fraction);
1788     if (fraction < 10) {
1789       fractionString = strConcat('00', fractionString);
1790     } else if (fraction < 100) {
1791       fractionString = strConcat('0', fractionString);
1792     }
1793     return strConcat(uint2str(whole), '.', fractionString);
1794   }
1795 
1796   function LOTEU() public view returns (uint256) {
1797     return (games[gameIndex].ticketsUsed.sub(games[gameIndex].ticketsBought).mul(100));
1798   }
1799 
1800   function LOTEU_total() public view returns (uint256) {
1801     return bonusToken.balanceOf(bonusVault);
1802   }
1803 
1804   function blockchain_FEES() public view returns (string) {
1805     uint256 whole = feesInWei.div(1 ether);
1806     uint256 fraction = feesInWei.div(1 finney) - (whole.mul(1000));
1807     string memory fractionString = uint2str(fraction);
1808     if (fraction < 10) {
1809       fractionString = strConcat('00', fractionString);
1810     } else if (fraction < 100) {
1811       fractionString = strConcat('0', fractionString);
1812     }
1813     return strConcat(uint2str(whole), '.', fractionString);
1814   }
1815 
1816   function setTicketVault(address vault) public onlyOwner {
1817     ticketVault = vault;
1818   }
1819 
1820   function setBonusVault(address vault) public onlyOwner {
1821     bonusVault = vault;
1822   }
1823 
1824   function setServiceVault(address vault) public onlyOwner {
1825     serviceVault = vault;
1826   }
1827 
1828   function setFeeVault(address vault) public onlyOwner {
1829     feeVault = vault;
1830   }
1831 
1832   function setVaults(address _ticketVault, address _bonusVault, address _serviceVault, address _feeVault) public onlyOwner {
1833     ticketVault = _ticketVault;
1834     bonusVault = _bonusVault;
1835     serviceVault = _serviceVault;
1836     feeVault = _feeVault;
1837   }
1838 
1839   function setApiKey(string _apiKey) public onlyOwner {
1840     apiKey = _apiKey;
1841   }
1842 
1843   function setPrice(uint256 price) public onlyPriceAgent {
1844     ticketCostInWei = price;
1845   }
1846 
1847   function setFees(uint fees) public onlyPriceAgent {
1848     feesInWei = fees;
1849   }
1850 
1851   function getTicketsForUser(address user) public view returns (uint256) {
1852     return games[gameIndex].ticketsByUser[user];
1853   }
1854 
1855   function useTickets(uint256 amount, bool bonusTicketsUsed) public {
1856     if (amount > maxOneTimeBuy) revert();
1857     if (now > games[gameIndex].endTime.sub(silencePeriod)) revert();
1858     ticketToken.transferFrom(msg.sender, ticketVault, amount);
1859     if (bonusTicketsUsed) {
1860       bonusToken.transferFrom(msg.sender, ticketVault, amount.mul(10000000000));
1861     }
1862     games[gameIndex].ticketsBought = games[gameIndex].ticketsBought.add(amount);
1863     uint256 amountToUse = amount;
1864     if (bonusTicketsUsed) {
1865       amountToUse = amountToUse.mul(2);
1866     }
1867     uint256 position = games[gameIndex].ticketsUsed;
1868     for (uint256 i = 0; i < amountToUse; i++) {
1869       games[gameIndex].tickets[position] = msg.sender;
1870       position++;
1871     }
1872     games[gameIndex].ticketsUsed = games[gameIndex].ticketsUsed.add(amountToUse);
1873     games[gameIndex].ticketsByUser[msg.sender] = games[gameIndex].ticketsByUser[msg.sender].add(amountToUse);
1874   }
1875 
1876   function useTicketsForUser(address user, uint256 amount, bool bonusTicketsUsed) public onlyPriceAgent {
1877     if (amount > maxOneTimeBuy) revert();
1878     if (now > games[gameIndex].endTime.sub(silencePeriod)) revert();
1879     ticketToken.transferFrom(user, ticketVault, amount);
1880     if (bonusTicketsUsed) {
1881       bonusToken.transferFrom(user, ticketVault, amount.mul(10000000000));
1882     }
1883     games[gameIndex].ticketsBought = games[gameIndex].ticketsBought.add(amount);
1884     uint256 amountToUse = amount;
1885     if (bonusTicketsUsed) {
1886       amountToUse = amountToUse.mul(2);
1887     }
1888     uint256 position = games[gameIndex].ticketsUsed;
1889     for (uint256 i = 0; i < amountToUse; i++) {
1890       games[gameIndex].tickets[position] = user;
1891       position++;
1892     }
1893     games[gameIndex].ticketsUsed = games[gameIndex].ticketsUsed.add(amountToUse);
1894     games[gameIndex].ticketsByUser[user] = games[gameIndex].ticketsByUser[user].add(amountToUse);
1895   }
1896 
1897   function __callback(bytes32 myid, string result) {
1898     if (now < games[gameIndex].endTime) revert();
1899     if (msg.sender != oraclize_cbAddress()) revert();
1900     uint256 random = parseInt(result);
1901     random = (games[gameIndex].seed.add(random)) % games[gameIndex].ticketsUsed;
1902     if (random >= games[gameIndex].ticketsUsed) revert();
1903     address winner = games[gameIndex].tickets[random];
1904     games[gameIndex].winner = winner;
1905     gameIndex++;
1906     games[gameIndex].seed = random;
1907     games[gameIndex].endTime = games[gameIndex - 1].endTime.add(interval);
1908     uint256 totalBank = ticketCostInWei.mul(games[gameIndex - 1].ticketsBought).sub(feesInWei);
1909     uint256 prize = totalBank.div(100).mul(75);
1910     uint256 service = prize.div(3);
1911     games[gameIndex - 1].prize = prize;
1912     GameResolved(result, winner, prize);
1913     if (!feeVault.send(feesInWei)) revert();
1914     if (!winner.send(prize)) revert();
1915     if (!serviceVault.send(service)) revert();
1916   }
1917 
1918   function resolveGame() public {
1919     if (now < games[gameIndex].endTime) revert();
1920     if (games[gameIndex].ticketsUsed > 0) {
1921       oraclize_query("URL", strConcat('json(https://playloteo.com/api/random-number?secret=', apiKey, '&min=0&max=', uint2str(uint(games[gameIndex].ticketsUsed) - 1), ').randomNumber'), 1000000);
1922     } else {
1923       gameIndex++;
1924       games[gameIndex].seed = games[gameIndex - 1].seed;
1925       games[gameIndex].endTime = games[gameIndex - 1].endTime.add(interval);
1926     }
1927   }
1928 
1929 }