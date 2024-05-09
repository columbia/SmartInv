1 /*
2 Copyright (c) 2018 WiseWolf Ltd
3 Developed by https://adoriasoft.com
4 */
5 
6 pragma solidity ^0.4.23;
7 
8 // File: contracts/Ownable.sol
9 
10 /**
11  * @title Ownable
12  * @dev The Ownable contract has an owner address, and provides basic authorization control
13  * functions, this simplifies the implementation of "user permissions".
14  */
15 contract Ownable {
16   address public owner;
17 
18 
19   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   constructor() public {
27     owner = msg.sender;
28   }
29 
30   /**
31    * @dev Throws if called by any account other than the owner.
32    */
33   modifier onlyOwner() {
34     require(msg.sender == owner);
35     _;
36   }
37 
38   /**
39    * @dev Allows the current owner to transfer control of the contract to a newOwner.
40    * @param newOwner The address to transfer ownership to.
41    */
42   function transferOwnership(address newOwner) public onlyOwner {
43     require(newOwner != address(0));
44     emit OwnershipTransferred(owner, newOwner);
45     owner = newOwner;
46   }
47 
48 }
49 
50 // File: contracts/SafeMath.sol
51 
52 /**
53  * @title SafeMath
54  * @dev Math operations with safety checks that throw on error
55  */
56 library SafeMath {
57 
58   /**
59   * @dev Multiplies two numbers, throws on overflow.
60   */
61   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
62     if (a == 0) {
63       return 0;
64     }
65     c = a * b;
66     assert(c / a == b);
67     return c;
68   }
69 
70   /**
71   * @dev Integer division of two numbers, truncating the quotient.
72   */
73   function div(uint256 a, uint256 b) internal pure returns (uint256) {
74     // assert(b > 0); // Solidity automatically throws when dividing by 0
75     // uint256 c = a / b;
76     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
77     return a / b;
78   }
79 
80   /**
81   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
82   */
83   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
84     assert(b <= a);
85     return a - b;
86   }
87 
88   /**
89   * @dev Adds two numbers, throws on overflow.
90   */
91   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
92     c = a + b;
93     assert(c >= a);
94     return c;
95   }
96 }
97 
98 // File: contracts/RefundVault.sol
99 
100 /**
101  * @title RefundVault
102  * @dev This contract is used for storing funds while a crowdsale
103  * is in progress. Supports refunding the money if crowdsale fails,
104  * and forwarding it if crowdsale is successful.
105  */
106 contract RefundVault {
107   using SafeMath for uint256;
108 
109   enum State { Active, Refunding, Released}
110 
111   mapping (address => uint256) public vault_deposited;
112   address public vault_wallet;
113   State public vault_state;
114   uint256 totalDeposited = 0;
115   uint256 public refundDeadline;
116 
117   event DepositReleased();
118   event RefundsEnabled();
119   event RefundsDisabled();
120   event Refunded(address indexed beneficiary, uint256 weiAmount);
121 
122   constructor() public {
123     vault_state = State.Active;
124   }
125 
126   function vault_deposit(address investor, uint256 _value) internal {
127     require(vault_state == State.Active);
128     vault_deposited[investor] = vault_deposited[investor].add(_value);
129     totalDeposited = totalDeposited.add(_value);
130   }
131 
132   function vault_releaseDeposit() internal {
133     vault_state = State.Released;
134     emit DepositReleased();
135     if (totalDeposited > 0) {
136         uint256 localTotalDeposited = totalDeposited;
137         totalDeposited = 0;
138         vault_wallet.transfer(localTotalDeposited);
139     }
140   }
141 
142   function vault_enableRefunds() internal {
143     require(vault_state == State.Active);
144     refundDeadline = now + 90 days;
145     vault_state = State.Refunding;
146     emit RefundsEnabled();
147   }
148 
149   function vault_refund(address investor) internal {
150     require(vault_state == State.Refunding);
151     uint256 depositedValue = vault_deposited[investor];
152     require(depositedValue > 0);
153     
154     vault_deposited[investor] = 0;
155     emit Refunded(investor, depositedValue);
156     totalDeposited = totalDeposited.sub(depositedValue);
157     if(depositedValue != 0) {
158         investor.transfer(depositedValue);
159     }
160   }
161 }
162 
163 // File: contracts/ERC20Basic.sol
164 
165 /**
166  * @title ERC20Basic
167  * @dev Simpler version of ERC20 interface
168  * @dev see https://github.com/ethereum/EIPs/issues/179
169  */
170 contract ERC20Basic {
171   function totalSupply() public view returns (uint256);
172   function balanceOf(address who) public view returns (uint256);
173   function transfer(address to, uint256 value) public returns (bool);
174   event Transfer(address indexed from, address indexed to, uint256 value);
175 }
176 
177 // File: contracts/BasicToken.sol
178 
179 /**
180  * @title Basic token
181  * @dev Basic version of StandardToken, with no allowances.
182  */
183 contract BasicToken is ERC20Basic {
184   using SafeMath for uint256;
185 
186   mapping(address => uint256) balances;
187 
188   uint256 totalSupply_;
189 
190   /**
191   * @dev total number of tokens in existence
192   */
193   function totalSupply() public view returns (uint256) {
194     return totalSupply_;
195   }
196 
197   /**
198   * @dev transfer token for a specified address
199   * @param _to The address to transfer to.
200   * @param _value The amount to be transferred.
201   */
202   function transfer(address _to, uint256 _value) public returns (bool) {
203     require(_to != address(0));
204     require(_value <= balances[msg.sender]);
205 
206     balances[msg.sender] = balances[msg.sender].sub(_value);
207     balances[_to] = balances[_to].add(_value);
208     emit Transfer(msg.sender, _to, _value);
209     return true;
210   }
211 
212   /**
213   * @dev Gets the balance of the specified address.
214   * @param _owner The address to query the the balance of.
215   * @return An uint256 representing the amount owned by the passed address.
216   */
217   function balanceOf(address _owner) public view returns (uint256) {
218     return balances[_owner];
219   }
220 
221 }
222 
223 // File: contracts/BurnableToken.sol
224 
225 /**
226  * @title Burnable Token
227  * @dev Token that can be irreversibly burned (destroyed).
228  */
229 contract BurnableToken is BasicToken {
230 
231   event Burn(address indexed burner, uint256 value);
232 
233   /**
234    * @dev Burns a specific amount of tokens.
235    * @param _value The amount of token to be burned.
236    */
237   function burn(uint256 _value) public {
238     _burn(msg.sender, _value);
239   }
240 
241   function _burn(address _who, uint256 _value) internal {
242     require(_value <= balances[_who]);
243     // no need to require value <= totalSupply, since that would imply the
244     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
245 
246     balances[_who] = balances[_who].sub(_value);
247     totalSupply_ = totalSupply_.sub(_value);
248     emit Burn(_who, _value);
249     emit Transfer(_who, address(0), _value);
250   }
251 }
252 
253 // File: contracts/ERC20.sol
254 
255 /**
256  * @title ERC20 interface
257  * @dev see https://github.com/ethereum/EIPs/issues/20
258  */
259 contract ERC20 is ERC20Basic {
260   function allowance(address owner, address spender) public view returns (uint256);
261   function transferFrom(address from, address to, uint256 value) public returns (bool);
262   function approve(address spender, uint256 value) public returns (bool);
263   event Approval(address indexed owner, address indexed spender, uint256 value);
264 }
265 
266 // File: contracts/ERC223.sol
267 
268 /*
269   ERC223 additions to ERC20
270 
271   Interface wise is ERC20 + data paramenter to transfer and transferFrom.
272  */
273 
274 //import "github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC20.sol";
275 
276 
277 contract ERC223 is ERC20 {
278   function transfer(address to, uint value, bytes data) public returns (bool ok);
279   function transferFrom(address from, address to, uint value, bytes data) public returns (bool ok);
280   
281   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
282 }
283 
284 // File: contracts/ERC223Receiver.sol
285 
286 /*
287 Base class contracts willing to accept ERC223 token transfers must conform to.
288 
289 Sender: msg.sender to the token contract, the address originating the token transfer.
290           - For user originated transfers sender will be equal to tx.origin
291           - For contract originated transfers, tx.origin will be the user that made the tx that produced the transfer.
292 Origin: the origin address from whose balance the tokens are sent
293           - For transfer(), origin = msg.sender
294           - For transferFrom() origin = _from to token contract
295 Value is the amount of tokens sent
296 Data is arbitrary data sent with the token transfer. Simulates ether tx.data
297 
298 From, origin and value shouldn't be trusted unless the token contract is trusted.
299 If sender == tx.origin, it is safe to trust it regardless of the token.
300 */
301 
302 contract ERC223Receiver {
303   function tokenFallback(address _from, uint _value, bytes _data) public;
304 }
305 
306 // File: contracts/Pausable.sol
307 
308 /**
309  * @title Pausable
310  * @dev Base contract which allows children to implement an emergency stop mechanism.
311  */
312 contract Pausable is Ownable {
313   event Pause();
314   event Unpause();
315 
316   bool public paused = false;
317 
318 
319   /**
320    * @dev Modifier to make a function callable only when the contract is not paused.
321    */
322   modifier whenNotPaused() {
323     require(!paused);
324     _;
325   }
326 
327   /**
328    * @dev Modifier to make a function callable only when the contract is paused.
329    */
330   modifier whenPaused() {
331     require(paused);
332     _;
333   }
334 
335   /**
336    * @dev called by the owner to pause, triggers stopped state
337    */
338   function pause() onlyOwner whenNotPaused public {
339     paused = true;
340     emit Pause();
341   }
342 
343   /**
344    * @dev called by the owner to unpause, returns to normal state
345    */
346   function unpause() onlyOwner whenPaused public {
347     paused = false;
348     emit Unpause();
349   }
350 }
351 
352 // File: contracts/StandardToken.sol
353 
354 /**
355  * @title Standard ERC20 token
356  *
357  * @dev Implementation of the basic standard token.
358  * @dev https://github.com/ethereum/EIPs/issues/20
359  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
360  */
361 contract StandardToken is ERC20, BasicToken {
362 
363   mapping (address => mapping (address => uint256)) internal allowed;
364 
365 
366   /**
367    * @dev Transfer tokens from one address to another
368    * @param _from address The address which you want to send tokens from
369    * @param _to address The address which you want to transfer to
370    * @param _value uint256 the amount of tokens to be transferred
371    */
372   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
373     require(_to != address(0));
374     require(_value <= balances[_from]);
375     require(_value <= allowed[_from][msg.sender]);
376 
377     balances[_from] = balances[_from].sub(_value);
378     balances[_to] = balances[_to].add(_value);
379     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
380     emit Transfer(_from, _to, _value);
381     return true;
382   }
383 
384   /**
385    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
386    *
387    * Beware that changing an allowance with this method brings the risk that someone may use both the old
388    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
389    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
390    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
391    * @param _spender The address which will spend the funds.
392    * @param _value The amount of tokens to be spent.
393    */
394   function approve(address _spender, uint256 _value) public returns (bool) {
395     allowed[msg.sender][_spender] = _value;
396     emit Approval(msg.sender, _spender, _value);
397     return true;
398   }
399 
400   /**
401    * @dev Function to check the amount of tokens that an owner allowed to a spender.
402    * @param _owner address The address which owns the funds.
403    * @param _spender address The address which will spend the funds.
404    * @return A uint256 specifying the amount of tokens still available for the spender.
405    */
406   function allowance(address _owner, address _spender) public view returns (uint256) {
407     return allowed[_owner][_spender];
408   }
409 
410   /**
411    * @dev Increase the amount of tokens that an owner allowed to a spender.
412    *
413    * approve should be called when allowed[_spender] == 0. To increment
414    * allowed value is better to use this function to avoid 2 calls (and wait until
415    * the first transaction is mined)
416    * From MonolithDAO Token.sol
417    * @param _spender The address which will spend the funds.
418    * @param _addedValue The amount of tokens to increase the allowance by.
419    */
420   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
421     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
422     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
423     return true;
424   }
425 
426   /**
427    * @dev Decrease the amount of tokens that an owner allowed to a spender.
428    *
429    * approve should be called when allowed[_spender] == 0. To decrement
430    * allowed value is better to use this function to avoid 2 calls (and wait until
431    * the first transaction is mined)
432    * From MonolithDAO Token.sol
433    * @param _spender The address which will spend the funds.
434    * @param _subtractedValue The amount of tokens to decrease the allowance by.
435    */
436   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
437     uint oldValue = allowed[msg.sender][_spender];
438     if (_subtractedValue > oldValue) {
439       allowed[msg.sender][_spender] = 0;
440     } else {
441       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
442     }
443     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
444     return true;
445   }
446 
447 }
448 
449 // File: contracts/PausableToken.sol
450 
451 /**
452  * @title Pausable token
453  * @dev StandardToken modified with pausable transfers.
454  **/
455 contract PausableToken is StandardToken, Pausable {
456 
457   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
458     return super.transfer(_to, _value);
459   }
460 
461   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
462     return super.transferFrom(_from, _to, _value);
463   }
464 
465   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
466     return super.approve(_spender, _value);
467   }
468 
469   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
470     return super.increaseApproval(_spender, _addedValue);
471   }
472 
473   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
474     return super.decreaseApproval(_spender, _subtractedValue);
475   }
476 }
477 
478 // File: contracts/Pausable223Token.sol
479 
480 /* ERC223 additions to ERC20 */
481 
482 
483 
484 //import "github.com/OpenZeppelin/zeppelin-solidity/contracts/token/StandardToken.sol";
485 
486 
487 contract Pausable223Token is ERC223, PausableToken {
488   //function that is called when a user or another contract wants to transfer funds
489   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
490     //filtering if the target is a contract with bytecode inside it
491     if (!super.transfer(_to, _value)) revert(); // do a normal token transfer
492     if (isContract(_to)) contractFallback(msg.sender, _to, _value, _data);
493     emit Transfer(msg.sender, _to, _value, _data);
494     return true;
495   }
496 
497   function transferFrom(address _from, address _to, uint _value, bytes _data) public returns (bool success) {
498     if (!super.transferFrom(_from, _to, _value)) revert(); // do a normal token transfer
499     if (isContract(_to)) contractFallback(_from, _to, _value, _data);
500     emit Transfer(_from, _to, _value, _data);
501     return true;
502   }
503 
504   function transfer(address _to, uint _value) public returns (bool success) {
505     return transfer(_to, _value, new bytes(0));
506   }
507 
508   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
509     return transferFrom(_from, _to, _value, new bytes(0));
510   }
511 
512   //function that is called when transaction target is a contract
513   function contractFallback(address _origin, address _to, uint _value, bytes _data) private {
514     ERC223Receiver reciever = ERC223Receiver(_to);
515     reciever.tokenFallback(_origin, _value, _data);
516   }
517 
518   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
519   function isContract(address _addr) private view returns (bool is_contract) {
520     // retrieve the size of the code on target address, this needs assembly
521     uint length;
522     assembly { length := extcodesize(_addr) }
523     return length > 0;
524   }
525 }
526 
527 // File: contracts/WOLF.sol
528 
529 /*
530 Copyright (c) 2018 WiseWolf Ltd
531 Developed by https://adoriasoft.com
532 */
533 
534 pragma solidity ^0.4.23;
535 
536 
537 
538 
539 
540 
541 contract WOLF is BurnableToken, Pausable223Token
542 {
543     string public constant name = "WiseWolf";
544     string public constant symbol = "WOLF";
545     uint8 public constant decimals = 18;
546     uint public constant DECIMALS_MULTIPLIER = 10**uint(decimals);
547     
548     function increaseSupply(uint value, address to) public onlyOwner returns (bool) {
549         totalSupply_ = totalSupply_.add(value);
550         balances[to] = balances[to].add(value);
551         emit Transfer(address(0), to, value);
552         return true;
553     }
554 
555     
556     function transferOwnership(address newOwner) public onlyOwner {
557         require(newOwner != address(0));
558         uint256 localOwnerBalance = balances[owner];
559         balances[newOwner] = balances[newOwner].add(localOwnerBalance);
560         balances[owner] = 0;
561         emit Transfer(owner, newOwner, localOwnerBalance);
562         super.transferOwnership(newOwner);
563     }
564     
565     constructor () public payable {
566       totalSupply_ = 1300000000 * DECIMALS_MULTIPLIER; //1000000000 + 20% bounty + 5% referal bonus + 5% team motivation
567       balances[owner] = totalSupply_;
568       emit Transfer(0x0, owner, totalSupply_);
569     }
570 }
571 
572 // File: contracts/oraclizeAPI.sol
573 
574 // <ORACLIZE_API>
575 /*
576 Copyright (c) 2015-2016 Oraclize SRL
577 Copyright (c) 2016 Oraclize LTD
578 
579 
580 
581 Permission is hereby granted, free of charge, to any person obtaining a copy
582 of this software and associated documentation files (the "Software"), to deal
583 in the Software without restriction, including without limitation the rights
584 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
585 copies of the Software, and to permit persons to whom the Software is
586 furnished to do so, subject to the following conditions:
587 
588 
589 
590 The above copyright notice and this permission notice shall be included in
591 all copies or substantial portions of the Software.
592 
593 
594 
595 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
596 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
597 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
598 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
599 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
600 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
601 THE SOFTWARE.
602 */
603 
604 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
605 pragma solidity ^0.4.18;
606 
607 contract OraclizeI {
608     address public cbAddress;
609     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
610     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
611     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
612     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
613     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
614     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
615     function getPrice(string _datasource) public returns (uint _dsprice);
616     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
617     function setProofType(byte _proofType) external;
618     function setCustomGasPrice(uint _gasPrice) external;
619     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
620 }
621 
622 contract OraclizeAddrResolverI {
623     function getAddress() public returns (address _addr);
624 }
625 
626 /*
627 Begin solidity-cborutils
628 
629 https://github.com/smartcontractkit/solidity-cborutils
630 
631 MIT License
632 
633 Copyright (c) 2018 SmartContract ChainLink, Ltd.
634 
635 Permission is hereby granted, free of charge, to any person obtaining a copy
636 of this software and associated documentation files (the "Software"), to deal
637 in the Software without restriction, including without limitation the rights
638 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
639 copies of the Software, and to permit persons to whom the Software is
640 furnished to do so, subject to the following conditions:
641 
642 The above copyright notice and this permission notice shall be included in all
643 copies or substantial portions of the Software.
644 
645 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
646 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
647 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
648 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
649 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
650 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
651 SOFTWARE.
652  */
653 
654 library Buffer {
655     struct buffer {
656         bytes buf;
657         uint capacity;
658     }
659 
660     function init(buffer memory buf, uint capacity) internal pure {
661         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
662         // Allocate space for the buffer data
663         buf.capacity = capacity;
664         assembly {
665             let ptr := mload(0x40)
666             mstore(buf, ptr)
667             mstore(0x40, add(ptr, capacity))
668         }
669     }
670 
671     function resize(buffer memory buf, uint capacity) private pure {
672         bytes memory oldbuf = buf.buf;
673         init(buf, capacity);
674         append(buf, oldbuf);
675     }
676 
677     function max(uint a, uint b) private pure returns(uint) {
678         if(a > b) {
679             return a;
680         }
681         return b;
682     }
683 
684     /**
685      * @dev Appends a byte array to the end of the buffer. Reverts if doing so
686      *      would exceed the capacity of the buffer.
687      * @param buf The buffer to append to.
688      * @param data The data to append.
689      * @return The original buffer.
690      */
691     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
692         if(data.length + buf.buf.length > buf.capacity) {
693             resize(buf, max(buf.capacity, data.length) * 2);
694         }
695 
696         uint dest;
697         uint src;
698         uint len = data.length;
699         assembly {
700             // Memory address of the buffer data
701             let bufptr := mload(buf)
702             // Length of existing buffer data
703             let buflen := mload(bufptr)
704             // Start address = buffer address + buffer length + sizeof(buffer length)
705             dest := add(add(bufptr, buflen), 32)
706             // Update buffer length
707             mstore(bufptr, add(buflen, mload(data)))
708             src := add(data, 32)
709         }
710 
711         // Copy word-length chunks while possible
712         for(; len >= 32; len -= 32) {
713             assembly {
714                 mstore(dest, mload(src))
715             }
716             dest += 32;
717             src += 32;
718         }
719 
720         // Copy remaining bytes
721         uint mask = 256 ** (32 - len) - 1;
722         assembly {
723             let srcpart := and(mload(src), not(mask))
724             let destpart := and(mload(dest), mask)
725             mstore(dest, or(destpart, srcpart))
726         }
727 
728         return buf;
729     }
730 
731     /**
732      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
733      * exceed the capacity of the buffer.
734      * @param buf The buffer to append to.
735      * @param data The data to append.
736      * @return The original buffer.
737      */
738     function append(buffer memory buf, uint8 data) internal pure {
739         if(buf.buf.length + 1 > buf.capacity) {
740             resize(buf, buf.capacity * 2);
741         }
742 
743         assembly {
744             // Memory address of the buffer data
745             let bufptr := mload(buf)
746             // Length of existing buffer data
747             let buflen := mload(bufptr)
748             // Address = buffer address + buffer length + sizeof(buffer length)
749             let dest := add(add(bufptr, buflen), 32)
750             mstore8(dest, data)
751             // Update buffer length
752             mstore(bufptr, add(buflen, 1))
753         }
754     }
755 
756     /**
757      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
758      * exceed the capacity of the buffer.
759      * @param buf The buffer to append to.
760      * @param data The data to append.
761      * @return The original buffer.
762      */
763     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
764         if(len + buf.buf.length > buf.capacity) {
765             resize(buf, max(buf.capacity, len) * 2);
766         }
767 
768         uint mask = 256 ** len - 1;
769         assembly {
770             // Memory address of the buffer data
771             let bufptr := mload(buf)
772             // Length of existing buffer data
773             let buflen := mload(bufptr)
774             // Address = buffer address + buffer length + sizeof(buffer length) + len
775             let dest := add(add(bufptr, buflen), len)
776             mstore(dest, or(and(mload(dest), not(mask)), data))
777             // Update buffer length
778             mstore(bufptr, add(buflen, len))
779         }
780         return buf;
781     }
782 }
783 
784 library CBOR {
785     using Buffer for Buffer.buffer;
786 
787     uint8 private constant MAJOR_TYPE_INT = 0;
788     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
789     uint8 private constant MAJOR_TYPE_BYTES = 2;
790     uint8 private constant MAJOR_TYPE_STRING = 3;
791     uint8 private constant MAJOR_TYPE_ARRAY = 4;
792     uint8 private constant MAJOR_TYPE_MAP = 5;
793     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
794 
795     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
796         if(value <= 23) {
797             buf.append(uint8((major << 5) | value));
798         } else if(value <= 0xFF) {
799             buf.append(uint8((major << 5) | 24));
800             buf.appendInt(value, 1);
801         } else if(value <= 0xFFFF) {
802             buf.append(uint8((major << 5) | 25));
803             buf.appendInt(value, 2);
804         } else if(value <= 0xFFFFFFFF) {
805             buf.append(uint8((major << 5) | 26));
806             buf.appendInt(value, 4);
807         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
808             buf.append(uint8((major << 5) | 27));
809             buf.appendInt(value, 8);
810         }
811     }
812 
813     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
814         buf.append(uint8((major << 5) | 31));
815     }
816 
817     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
818         encodeType(buf, MAJOR_TYPE_INT, value);
819     }
820 
821     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
822         if(value >= 0) {
823             encodeType(buf, MAJOR_TYPE_INT, uint(value));
824         } else {
825             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
826         }
827     }
828 
829     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
830         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
831         buf.append(value);
832     }
833 
834     function encodeString(Buffer.buffer memory buf, string value) internal pure {
835         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
836         buf.append(bytes(value));
837     }
838 
839     function startArray(Buffer.buffer memory buf) internal pure {
840         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
841     }
842 
843     function startMap(Buffer.buffer memory buf) internal pure {
844         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
845     }
846 
847     function endSequence(Buffer.buffer memory buf) internal pure {
848         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
849     }
850 }
851 
852 /*
853 End solidity-cborutils
854  */
855 
856 contract usingOraclize {
857     uint constant day = 60*60*24;
858     uint constant week = 60*60*24*7;
859     uint constant month = 60*60*24*30;
860     byte constant proofType_NONE = 0x00;
861     byte constant proofType_TLSNotary = 0x10;
862     byte constant proofType_Android = 0x20;
863     byte constant proofType_Ledger = 0x30;
864     byte constant proofType_Native = 0xF0;
865     byte constant proofStorage_IPFS = 0x01;
866     uint8 constant networkID_auto = 0;
867     uint8 constant networkID_mainnet = 1;
868     uint8 constant networkID_testnet = 2;
869     uint8 constant networkID_morden = 2;
870     uint8 constant networkID_consensys = 161;
871 
872     OraclizeAddrResolverI OAR;
873 
874     OraclizeI oraclize;
875     modifier oraclizeAPI {
876         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
877             oraclize_setNetwork(networkID_auto);
878 
879         if(address(oraclize) != OAR.getAddress())
880             oraclize = OraclizeI(OAR.getAddress());
881 
882         _;
883     }
884     modifier coupon(string code){
885         oraclize = OraclizeI(OAR.getAddress());
886         _;
887     }
888 
889     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
890       return oraclize_setNetwork();
891       networkID; // silence the warning and remain backwards compatible
892     }
893     function oraclize_setNetwork() internal returns(bool){
894         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
895             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
896             oraclize_setNetworkName("eth_mainnet");
897             return true;
898         }
899         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
900             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
901             oraclize_setNetworkName("eth_ropsten3");
902             return true;
903         }
904         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
905             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
906             oraclize_setNetworkName("eth_kovan");
907             return true;
908         }
909         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
910             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
911             oraclize_setNetworkName("eth_rinkeby");
912             return true;
913         }
914         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
915             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
916             return true;
917         }
918         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
919             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
920             return true;
921         }
922         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
923             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
924             return true;
925         }
926         return false;
927     }
928 
929     function __callback(bytes32 myid, string result) public {
930         __callback(myid, result, new bytes(0));
931     }
932     function __callback(bytes32 myid, string result, bytes proof) public pure {
933       return;
934       myid; result; proof; // Silence compiler warnings
935     }
936 
937     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
938         return oraclize.getPrice(datasource);
939     }
940 
941     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
942         return oraclize.getPrice(datasource, gaslimit);
943     }
944 
945     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
946         uint price = oraclize.getPrice(datasource);
947         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
948         return oraclize.query.value(price)(0, datasource, arg);
949     }
950     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
951         uint price = oraclize.getPrice(datasource);
952         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
953         return oraclize.query.value(price)(timestamp, datasource, arg);
954     }
955     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
956         uint price = oraclize.getPrice(datasource, gaslimit);
957         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
958         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
959     }
960     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
961         uint price = oraclize.getPrice(datasource, gaslimit);
962         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
963         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
964     }
965     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
966         uint price = oraclize.getPrice(datasource);
967         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
968         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
969     }
970     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
971         uint price = oraclize.getPrice(datasource);
972         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
973         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
974     }
975     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
976         uint price = oraclize.getPrice(datasource, gaslimit);
977         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
978         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
979     }
980     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
981         uint price = oraclize.getPrice(datasource, gaslimit);
982         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
983         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
984     }
985     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
986         uint price = oraclize.getPrice(datasource);
987         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
988         bytes memory args = stra2cbor(argN);
989         return oraclize.queryN.value(price)(0, datasource, args);
990     }
991     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
992         uint price = oraclize.getPrice(datasource);
993         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
994         bytes memory args = stra2cbor(argN);
995         return oraclize.queryN.value(price)(timestamp, datasource, args);
996     }
997     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
998         uint price = oraclize.getPrice(datasource, gaslimit);
999         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1000         bytes memory args = stra2cbor(argN);
1001         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
1002     }
1003     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1004         uint price = oraclize.getPrice(datasource, gaslimit);
1005         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1006         bytes memory args = stra2cbor(argN);
1007         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
1008     }
1009     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
1010         string[] memory dynargs = new string[](1);
1011         dynargs[0] = args[0];
1012         return oraclize_query(datasource, dynargs);
1013     }
1014     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
1015         string[] memory dynargs = new string[](1);
1016         dynargs[0] = args[0];
1017         return oraclize_query(timestamp, datasource, dynargs);
1018     }
1019     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1020         string[] memory dynargs = new string[](1);
1021         dynargs[0] = args[0];
1022         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1023     }
1024     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1025         string[] memory dynargs = new string[](1);
1026         dynargs[0] = args[0];
1027         return oraclize_query(datasource, dynargs, gaslimit);
1028     }
1029 
1030     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
1031         string[] memory dynargs = new string[](2);
1032         dynargs[0] = args[0];
1033         dynargs[1] = args[1];
1034         return oraclize_query(datasource, dynargs);
1035     }
1036     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
1037         string[] memory dynargs = new string[](2);
1038         dynargs[0] = args[0];
1039         dynargs[1] = args[1];
1040         return oraclize_query(timestamp, datasource, dynargs);
1041     }
1042     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1043         string[] memory dynargs = new string[](2);
1044         dynargs[0] = args[0];
1045         dynargs[1] = args[1];
1046         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1047     }
1048     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1049         string[] memory dynargs = new string[](2);
1050         dynargs[0] = args[0];
1051         dynargs[1] = args[1];
1052         return oraclize_query(datasource, dynargs, gaslimit);
1053     }
1054     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
1055         string[] memory dynargs = new string[](3);
1056         dynargs[0] = args[0];
1057         dynargs[1] = args[1];
1058         dynargs[2] = args[2];
1059         return oraclize_query(datasource, dynargs);
1060     }
1061     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
1062         string[] memory dynargs = new string[](3);
1063         dynargs[0] = args[0];
1064         dynargs[1] = args[1];
1065         dynargs[2] = args[2];
1066         return oraclize_query(timestamp, datasource, dynargs);
1067     }
1068     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1069         string[] memory dynargs = new string[](3);
1070         dynargs[0] = args[0];
1071         dynargs[1] = args[1];
1072         dynargs[2] = args[2];
1073         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1074     }
1075     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1076         string[] memory dynargs = new string[](3);
1077         dynargs[0] = args[0];
1078         dynargs[1] = args[1];
1079         dynargs[2] = args[2];
1080         return oraclize_query(datasource, dynargs, gaslimit);
1081     }
1082 
1083     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1084         string[] memory dynargs = new string[](4);
1085         dynargs[0] = args[0];
1086         dynargs[1] = args[1];
1087         dynargs[2] = args[2];
1088         dynargs[3] = args[3];
1089         return oraclize_query(datasource, dynargs);
1090     }
1091     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1092         string[] memory dynargs = new string[](4);
1093         dynargs[0] = args[0];
1094         dynargs[1] = args[1];
1095         dynargs[2] = args[2];
1096         dynargs[3] = args[3];
1097         return oraclize_query(timestamp, datasource, dynargs);
1098     }
1099     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1100         string[] memory dynargs = new string[](4);
1101         dynargs[0] = args[0];
1102         dynargs[1] = args[1];
1103         dynargs[2] = args[2];
1104         dynargs[3] = args[3];
1105         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1106     }
1107     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1108         string[] memory dynargs = new string[](4);
1109         dynargs[0] = args[0];
1110         dynargs[1] = args[1];
1111         dynargs[2] = args[2];
1112         dynargs[3] = args[3];
1113         return oraclize_query(datasource, dynargs, gaslimit);
1114     }
1115     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1116         string[] memory dynargs = new string[](5);
1117         dynargs[0] = args[0];
1118         dynargs[1] = args[1];
1119         dynargs[2] = args[2];
1120         dynargs[3] = args[3];
1121         dynargs[4] = args[4];
1122         return oraclize_query(datasource, dynargs);
1123     }
1124     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1125         string[] memory dynargs = new string[](5);
1126         dynargs[0] = args[0];
1127         dynargs[1] = args[1];
1128         dynargs[2] = args[2];
1129         dynargs[3] = args[3];
1130         dynargs[4] = args[4];
1131         return oraclize_query(timestamp, datasource, dynargs);
1132     }
1133     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1134         string[] memory dynargs = new string[](5);
1135         dynargs[0] = args[0];
1136         dynargs[1] = args[1];
1137         dynargs[2] = args[2];
1138         dynargs[3] = args[3];
1139         dynargs[4] = args[4];
1140         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1141     }
1142     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1143         string[] memory dynargs = new string[](5);
1144         dynargs[0] = args[0];
1145         dynargs[1] = args[1];
1146         dynargs[2] = args[2];
1147         dynargs[3] = args[3];
1148         dynargs[4] = args[4];
1149         return oraclize_query(datasource, dynargs, gaslimit);
1150     }
1151     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1152         uint price = oraclize.getPrice(datasource);
1153         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1154         bytes memory args = ba2cbor(argN);
1155         return oraclize.queryN.value(price)(0, datasource, args);
1156     }
1157     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1158         uint price = oraclize.getPrice(datasource);
1159         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1160         bytes memory args = ba2cbor(argN);
1161         return oraclize.queryN.value(price)(timestamp, datasource, args);
1162     }
1163     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1164         uint price = oraclize.getPrice(datasource, gaslimit);
1165         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1166         bytes memory args = ba2cbor(argN);
1167         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
1168     }
1169     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1170         uint price = oraclize.getPrice(datasource, gaslimit);
1171         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1172         bytes memory args = ba2cbor(argN);
1173         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
1174     }
1175     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1176         bytes[] memory dynargs = new bytes[](1);
1177         dynargs[0] = args[0];
1178         return oraclize_query(datasource, dynargs);
1179     }
1180     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1181         bytes[] memory dynargs = new bytes[](1);
1182         dynargs[0] = args[0];
1183         return oraclize_query(timestamp, datasource, dynargs);
1184     }
1185     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1186         bytes[] memory dynargs = new bytes[](1);
1187         dynargs[0] = args[0];
1188         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1189     }
1190     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1191         bytes[] memory dynargs = new bytes[](1);
1192         dynargs[0] = args[0];
1193         return oraclize_query(datasource, dynargs, gaslimit);
1194     }
1195 
1196     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1197         bytes[] memory dynargs = new bytes[](2);
1198         dynargs[0] = args[0];
1199         dynargs[1] = args[1];
1200         return oraclize_query(datasource, dynargs);
1201     }
1202     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1203         bytes[] memory dynargs = new bytes[](2);
1204         dynargs[0] = args[0];
1205         dynargs[1] = args[1];
1206         return oraclize_query(timestamp, datasource, dynargs);
1207     }
1208     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1209         bytes[] memory dynargs = new bytes[](2);
1210         dynargs[0] = args[0];
1211         dynargs[1] = args[1];
1212         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1213     }
1214     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1215         bytes[] memory dynargs = new bytes[](2);
1216         dynargs[0] = args[0];
1217         dynargs[1] = args[1];
1218         return oraclize_query(datasource, dynargs, gaslimit);
1219     }
1220     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1221         bytes[] memory dynargs = new bytes[](3);
1222         dynargs[0] = args[0];
1223         dynargs[1] = args[1];
1224         dynargs[2] = args[2];
1225         return oraclize_query(datasource, dynargs);
1226     }
1227     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1228         bytes[] memory dynargs = new bytes[](3);
1229         dynargs[0] = args[0];
1230         dynargs[1] = args[1];
1231         dynargs[2] = args[2];
1232         return oraclize_query(timestamp, datasource, dynargs);
1233     }
1234     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1235         bytes[] memory dynargs = new bytes[](3);
1236         dynargs[0] = args[0];
1237         dynargs[1] = args[1];
1238         dynargs[2] = args[2];
1239         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1240     }
1241     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1242         bytes[] memory dynargs = new bytes[](3);
1243         dynargs[0] = args[0];
1244         dynargs[1] = args[1];
1245         dynargs[2] = args[2];
1246         return oraclize_query(datasource, dynargs, gaslimit);
1247     }
1248 
1249     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1250         bytes[] memory dynargs = new bytes[](4);
1251         dynargs[0] = args[0];
1252         dynargs[1] = args[1];
1253         dynargs[2] = args[2];
1254         dynargs[3] = args[3];
1255         return oraclize_query(datasource, dynargs);
1256     }
1257     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1258         bytes[] memory dynargs = new bytes[](4);
1259         dynargs[0] = args[0];
1260         dynargs[1] = args[1];
1261         dynargs[2] = args[2];
1262         dynargs[3] = args[3];
1263         return oraclize_query(timestamp, datasource, dynargs);
1264     }
1265     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1266         bytes[] memory dynargs = new bytes[](4);
1267         dynargs[0] = args[0];
1268         dynargs[1] = args[1];
1269         dynargs[2] = args[2];
1270         dynargs[3] = args[3];
1271         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1272     }
1273     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1274         bytes[] memory dynargs = new bytes[](4);
1275         dynargs[0] = args[0];
1276         dynargs[1] = args[1];
1277         dynargs[2] = args[2];
1278         dynargs[3] = args[3];
1279         return oraclize_query(datasource, dynargs, gaslimit);
1280     }
1281     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1282         bytes[] memory dynargs = new bytes[](5);
1283         dynargs[0] = args[0];
1284         dynargs[1] = args[1];
1285         dynargs[2] = args[2];
1286         dynargs[3] = args[3];
1287         dynargs[4] = args[4];
1288         return oraclize_query(datasource, dynargs);
1289     }
1290     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1291         bytes[] memory dynargs = new bytes[](5);
1292         dynargs[0] = args[0];
1293         dynargs[1] = args[1];
1294         dynargs[2] = args[2];
1295         dynargs[3] = args[3];
1296         dynargs[4] = args[4];
1297         return oraclize_query(timestamp, datasource, dynargs);
1298     }
1299     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1300         bytes[] memory dynargs = new bytes[](5);
1301         dynargs[0] = args[0];
1302         dynargs[1] = args[1];
1303         dynargs[2] = args[2];
1304         dynargs[3] = args[3];
1305         dynargs[4] = args[4];
1306         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1307     }
1308     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1309         bytes[] memory dynargs = new bytes[](5);
1310         dynargs[0] = args[0];
1311         dynargs[1] = args[1];
1312         dynargs[2] = args[2];
1313         dynargs[3] = args[3];
1314         dynargs[4] = args[4];
1315         return oraclize_query(datasource, dynargs, gaslimit);
1316     }
1317 
1318     function oraclize_cbAddress() oraclizeAPI internal returns (address){
1319         return oraclize.cbAddress();
1320     }
1321     function oraclize_setProof(byte proofP) oraclizeAPI internal {
1322         return oraclize.setProofType(proofP);
1323     }
1324     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
1325         return oraclize.setCustomGasPrice(gasPrice);
1326     }
1327 
1328     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
1329         return oraclize.randomDS_getSessionPubKeyHash();
1330     }
1331 
1332     function getCodeSize(address _addr) constant internal returns(uint _size) {
1333         assembly {
1334             _size := extcodesize(_addr)
1335         }
1336     }
1337 
1338     function parseAddr(string _a) internal pure returns (address){
1339         bytes memory tmp = bytes(_a);
1340         uint160 iaddr = 0;
1341         uint160 b1;
1342         uint160 b2;
1343         for (uint i=2; i<2+2*20; i+=2){
1344             iaddr *= 256;
1345             b1 = uint160(tmp[i]);
1346             b2 = uint160(tmp[i+1]);
1347             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
1348             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
1349             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
1350             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
1351             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
1352             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
1353             iaddr += (b1*16+b2);
1354         }
1355         return address(iaddr);
1356     }
1357 
1358     function strCompare(string _a, string _b) internal pure returns (int) {
1359         bytes memory a = bytes(_a);
1360         bytes memory b = bytes(_b);
1361         uint minLength = a.length;
1362         if (b.length < minLength) minLength = b.length;
1363         for (uint i = 0; i < minLength; i ++)
1364             if (a[i] < b[i])
1365                 return -1;
1366             else if (a[i] > b[i])
1367                 return 1;
1368         if (a.length < b.length)
1369             return -1;
1370         else if (a.length > b.length)
1371             return 1;
1372         else
1373             return 0;
1374     }
1375 
1376     function indexOf(string _haystack, string _needle) internal pure returns (int) {
1377         bytes memory h = bytes(_haystack);
1378         bytes memory n = bytes(_needle);
1379         if(h.length < 1 || n.length < 1 || (n.length > h.length))
1380             return -1;
1381         else if(h.length > (2**128 -1))
1382             return -1;
1383         else
1384         {
1385             uint subindex = 0;
1386             for (uint i = 0; i < h.length; i ++)
1387             {
1388                 if (h[i] == n[0])
1389                 {
1390                     subindex = 1;
1391                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
1392                     {
1393                         subindex++;
1394                     }
1395                     if(subindex == n.length)
1396                         return int(i);
1397                 }
1398             }
1399             return -1;
1400         }
1401     }
1402 
1403     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
1404         bytes memory _ba = bytes(_a);
1405         bytes memory _bb = bytes(_b);
1406         bytes memory _bc = bytes(_c);
1407         bytes memory _bd = bytes(_d);
1408         bytes memory _be = bytes(_e);
1409         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1410         bytes memory babcde = bytes(abcde);
1411         uint k = 0;
1412         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1413         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1414         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1415         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1416         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1417         return string(babcde);
1418     }
1419 
1420     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
1421         return strConcat(_a, _b, _c, _d, "");
1422     }
1423 
1424     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
1425         return strConcat(_a, _b, _c, "", "");
1426     }
1427 
1428     function strConcat(string _a, string _b) internal pure returns (string) {
1429         return strConcat(_a, _b, "", "", "");
1430     }
1431 
1432     // parseInt
1433     function parseInt(string _a) internal pure returns (uint) {
1434         return parseInt(_a, 0);
1435     }
1436 
1437     // parseInt(parseFloat*10^_b)
1438     function parseInt(string _a, uint _b) internal pure returns (uint) {
1439         bytes memory bresult = bytes(_a);
1440         uint mint = 0;
1441         bool decimals = false;
1442         for (uint i=0; i<bresult.length; i++){
1443             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
1444                 if (decimals){
1445                    if (_b == 0) break;
1446                     else _b--;
1447                 }
1448                 mint *= 10;
1449                 mint += uint(bresult[i]) - 48;
1450             } else if (bresult[i] == 46) decimals = true;
1451         }
1452         if (_b > 0) mint *= 10**_b;
1453         return mint;
1454     }
1455 
1456     function uint2str(uint i) internal pure returns (string){
1457         if (i == 0) return "0";
1458         uint j = i;
1459         uint len;
1460         while (j != 0){
1461             len++;
1462             j /= 10;
1463         }
1464         bytes memory bstr = new bytes(len);
1465         uint k = len - 1;
1466         while (i != 0){
1467             bstr[k--] = byte(48 + i % 10);
1468             i /= 10;
1469         }
1470         return string(bstr);
1471     }
1472 
1473     using CBOR for Buffer.buffer;
1474     function stra2cbor(string[] arr) internal pure returns (bytes) {
1475         Buffer.buffer memory buf;
1476         Buffer.init(buf, 1024);
1477         buf.startArray();
1478         for (uint i = 0; i < arr.length; i++) {
1479             buf.encodeString(arr[i]);
1480         }
1481         buf.endSequence();
1482         return buf.buf;
1483     }
1484 
1485     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
1486         Buffer.buffer memory buf;
1487         Buffer.init(buf, 1024);
1488         buf.startArray();
1489         for (uint i = 0; i < arr.length; i++) {
1490             buf.encodeBytes(arr[i]);
1491         }
1492         buf.endSequence();
1493         return buf.buf;
1494     }
1495 
1496     string oraclize_network_name;
1497     function oraclize_setNetworkName(string _network_name) internal {
1498         oraclize_network_name = _network_name;
1499     }
1500 
1501     function oraclize_getNetworkName() internal view returns (string) {
1502         return oraclize_network_name;
1503     }
1504 
1505     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1506         require((_nbytes > 0) && (_nbytes <= 32));
1507         // Convert from seconds to ledger timer ticks
1508         _delay *= 10;
1509         bytes memory nbytes = new bytes(1);
1510         nbytes[0] = byte(_nbytes);
1511         bytes memory unonce = new bytes(32);
1512         bytes memory sessionKeyHash = new bytes(32);
1513         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1514         assembly {
1515             mstore(unonce, 0x20)
1516             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1517             mstore(sessionKeyHash, 0x20)
1518             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1519         }
1520         bytes memory delay = new bytes(32);
1521         assembly {
1522             mstore(add(delay, 0x20), _delay)
1523         }
1524 
1525         bytes memory delay_bytes8 = new bytes(8);
1526         copyBytes(delay, 24, 8, delay_bytes8, 0);
1527 
1528         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1529         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1530 
1531         bytes memory delay_bytes8_left = new bytes(8);
1532 
1533         assembly {
1534             let x := mload(add(delay_bytes8, 0x20))
1535             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1536             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1537             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1538             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1539             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1540             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1541             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1542             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1543 
1544         }
1545 
1546         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1547         return queryId;
1548     }
1549 
1550     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1551         oraclize_randomDS_args[queryId] = commitment;
1552     }
1553 
1554     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1555     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1556 
1557     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1558         bool sigok;
1559         address signer;
1560 
1561         bytes32 sigr;
1562         bytes32 sigs;
1563 
1564         bytes memory sigr_ = new bytes(32);
1565         uint offset = 4+(uint(dersig[3]) - 0x20);
1566         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1567         bytes memory sigs_ = new bytes(32);
1568         offset += 32 + 2;
1569         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1570 
1571         assembly {
1572             sigr := mload(add(sigr_, 32))
1573             sigs := mload(add(sigs_, 32))
1574         }
1575 
1576 
1577         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1578         if (address(keccak256(pubkey)) == signer) return true;
1579         else {
1580             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1581             return (address(keccak256(pubkey)) == signer);
1582         }
1583     }
1584 
1585     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1586         bool sigok;
1587 
1588         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1589         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1590         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1591 
1592         bytes memory appkey1_pubkey = new bytes(64);
1593         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1594 
1595         bytes memory tosign2 = new bytes(1+65+32);
1596         tosign2[0] = byte(1); //role
1597         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1598         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1599         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1600         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1601 
1602         if (sigok == false) return false;
1603 
1604 
1605         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1606         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1607 
1608         bytes memory tosign3 = new bytes(1+65);
1609         tosign3[0] = 0xFE;
1610         copyBytes(proof, 3, 65, tosign3, 1);
1611 
1612         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1613         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1614 
1615         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1616 
1617         return sigok;
1618     }
1619 
1620     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1621         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1622         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1623 
1624         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1625         require(proofVerified);
1626 
1627         _;
1628     }
1629 
1630     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1631         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1632         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1633 
1634         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1635         if (proofVerified == false) return 2;
1636 
1637         return 0;
1638     }
1639 
1640     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1641         bool match_ = true;
1642 
1643         require(prefix.length == n_random_bytes);
1644 
1645         for (uint256 i=0; i< n_random_bytes; i++) {
1646             if (content[i] != prefix[i]) match_ = false;
1647         }
1648 
1649         return match_;
1650     }
1651 
1652     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1653 
1654         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1655         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1656         bytes memory keyhash = new bytes(32);
1657         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1658         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1659 
1660         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1661         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1662 
1663         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1664         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1665 
1666         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1667         // This is to verify that the computed args match with the ones specified in the query.
1668         bytes memory commitmentSlice1 = new bytes(8+1+32);
1669         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1670 
1671         bytes memory sessionPubkey = new bytes(64);
1672         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1673         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1674 
1675         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1676         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1677             delete oraclize_randomDS_args[queryId];
1678         } else return false;
1679 
1680 
1681         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1682         bytes memory tosign1 = new bytes(32+8+1+32);
1683         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1684         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1685 
1686         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1687         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1688             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1689         }
1690 
1691         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1692     }
1693 
1694     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1695     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1696         uint minLength = length + toOffset;
1697 
1698         // Buffer too small
1699         require(to.length >= minLength); // Should be a better way?
1700 
1701         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1702         uint i = 32 + fromOffset;
1703         uint j = 32 + toOffset;
1704 
1705         while (i < (32 + fromOffset + length)) {
1706             assembly {
1707                 let tmp := mload(add(from, i))
1708                 mstore(add(to, j), tmp)
1709             }
1710             i += 32;
1711             j += 32;
1712         }
1713 
1714         return to;
1715     }
1716 
1717     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1718     // Duplicate Solidity's ecrecover, but catching the CALL return value
1719     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1720         // We do our own memory management here. Solidity uses memory offset
1721         // 0x40 to store the current end of memory. We write past it (as
1722         // writes are memory extensions), but don't update the offset so
1723         // Solidity will reuse it. The memory used here is only needed for
1724         // this context.
1725 
1726         // FIXME: inline assembly can't access return values
1727         bool ret;
1728         address addr;
1729 
1730         assembly {
1731             let size := mload(0x40)
1732             mstore(size, hash)
1733             mstore(add(size, 32), v)
1734             mstore(add(size, 64), r)
1735             mstore(add(size, 96), s)
1736 
1737             // NOTE: we can reuse the request memory because we deal with
1738             //       the return code
1739             ret := call(3000, 1, 0, size, 128, size, 32)
1740             addr := mload(size)
1741         }
1742 
1743         return (ret, addr);
1744     }
1745 
1746     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1747     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1748         bytes32 r;
1749         bytes32 s;
1750         uint8 v;
1751 
1752         if (sig.length != 65)
1753           return (false, 0);
1754 
1755         // The signature format is a compact form of:
1756         //   {bytes32 r}{bytes32 s}{uint8 v}
1757         // Compact means, uint8 is not padded to 32 bytes.
1758         assembly {
1759             r := mload(add(sig, 32))
1760             s := mload(add(sig, 64))
1761 
1762             // Here we are loading the last 32 bytes. We exploit the fact that
1763             // 'mload' will pad with zeroes if we overread.
1764             // There is no 'mload8' to do this, but that would be nicer.
1765             v := byte(0, mload(add(sig, 96)))
1766 
1767             // Alternative solution:
1768             // 'byte' is not working due to the Solidity parser, so lets
1769             // use the second best option, 'and'
1770             // v := and(mload(add(sig, 65)), 255)
1771         }
1772 
1773         // albeit non-transactional signatures are not specified by the YP, one would expect it
1774         // to match the YP range of [27, 28]
1775         //
1776         // geth uses [0, 1] and some clients have followed. This might change, see:
1777         //  https://github.com/ethereum/go-ethereum/issues/2053
1778         if (v < 27)
1779           v += 27;
1780 
1781         if (v != 27 && v != 28)
1782             return (false, 0);
1783 
1784         return safer_ecrecover(hash, v, r, s);
1785     }
1786 
1787 }
1788 // </ORACLIZE_API>
1789 
1790 // File: contracts/wolfsale.sol
1791 
1792 /*
1793 Copyright (c) 2018 WiseWolf Ltd
1794 Developed by https://adoriasoft.com
1795 */
1796 
1797 pragma solidity ^0.4.23;
1798 
1799 
1800 
1801 
1802 
1803 
1804 
1805 contract WolfSale is usingOraclize, Ownable, RefundVault
1806 {
1807     uint8 public constant decimals = 18;
1808     uint public constant DECIMALS_MULTIPLIER = 10**uint(decimals);
1809 
1810     WOLF public token;
1811     address tokensSaleHolder;
1812 
1813     uint public  ICOstarttime;
1814     uint public  ICOendtime;
1815     
1816     uint public  minimumInvestmentInWei;
1817     uint public  maximumInvestmentInWei;
1818     address saleMainAddress;
1819     address saleSecondAddress;
1820 
1821 
1822 
1823     uint256 public  softcapInTokens;
1824     uint256 public  hardcapInTokens;
1825     
1826     uint256 public totaltokensold = 0;
1827     
1828     uint public USDETH = 683;
1829     uint public PriceOf1000TokensInUSD;
1830     
1831     //RefundVault public vault;
1832     bool public isFinalized = false;
1833     event Finalized();
1834     
1835     event newOraclizeQuery(string description);
1836     event newETHUSDPrice(string price);
1837     
1838     function finalize() public {
1839         require(!isFinalized);
1840         require(ICOendtime < now);
1841         finalization();
1842         emit Finalized();
1843         isFinalized = true;
1844     }
1845   
1846     function depositFunds() internal {
1847         vault_deposit(msg.sender, msg.value * 70 / 100);
1848     }
1849     
1850     // if crowdsale is unsuccessful, investors can claim refunds here
1851     function claimRefund() public {
1852         require(isFinalized);
1853         require(!goalReached());
1854         
1855         uint256 refundedTokens = token.balanceOf(msg.sender);
1856         require(token.transferFrom(msg.sender, tokensSaleHolder, refundedTokens));
1857         totaltokensold = totaltokensold.sub(refundedTokens);
1858 
1859         vault_refund(msg.sender);
1860     }
1861     
1862     // vault finalization task, called when owner calls finalize()
1863     function finalization() internal {
1864         if (goalReached()) {
1865             vault_releaseDeposit();
1866         } else {
1867             vault_enableRefunds();
1868             
1869         }
1870     }
1871     
1872     function releaseUnclaimedFunds() onlyOwner public {
1873         require(vault_state == State.Refunding && now >= refundDeadline);
1874         vault_releaseDeposit();
1875     }
1876 
1877     function goalReached() public view returns (bool) {
1878         return totaltokensold >= softcapInTokens;
1879     }    
1880     
1881     function __callback(bytes32 /* myid */, string result) public {
1882         require (msg.sender == oraclize_cbAddress());
1883 
1884         emit newETHUSDPrice(result);
1885 
1886         USDETH = parseInt(result, 0);
1887         if ((now < ICOendtime) && (totaltokensold < hardcapInTokens))
1888         {
1889             UpdateUSDETHPriceAfter(day); //update every 24 hours
1890         }
1891         
1892     }
1893     
1894 
1895   function UpdateUSDETHPriceAfter (uint delay) private {
1896       
1897     emit newOraclizeQuery("Update of USD/ETH price requested");
1898     oraclize_query(delay, "URL", "json(https://api.etherscan.io/api?module=stats&action=ethprice&apikey=YourApiKeyToken).result.ethusd");
1899        
1900   }
1901 
1902 
1903   
1904 
1905   constructor (address _tokenContract, address _tokensSaleHolder,
1906                 address _saleMainAddress, address _saleSecondAddress,
1907                 uint _ICOstarttime, uint _ICOendtime,
1908                 uint _minimumInvestment, uint _maximumInvestment, uint _PriceOf1000TokensInUSD,
1909                 uint256 _softcapInTokens, uint256 _hardcapInTokens) public payable {
1910                     
1911     token = WOLF(_tokenContract);
1912     tokensSaleHolder = _tokensSaleHolder;
1913 
1914     saleMainAddress = _saleMainAddress;
1915     saleSecondAddress = _saleSecondAddress; 
1916     vault_wallet = saleMainAddress;
1917     
1918     ICOstarttime = _ICOstarttime;
1919     ICOendtime = _ICOendtime;
1920 
1921     minimumInvestmentInWei = _minimumInvestment;
1922     maximumInvestmentInWei = _maximumInvestment;
1923     PriceOf1000TokensInUSD = _PriceOf1000TokensInUSD;
1924 
1925     softcapInTokens = _softcapInTokens;
1926     hardcapInTokens = _hardcapInTokens;
1927     
1928     UpdateUSDETHPriceAfter(0);
1929   }
1930   
1931   function RefillOraclize() public payable onlyOwner {
1932       UpdateUSDETHPriceAfter(0);
1933   }
1934 
1935   function  RedeemOraclize ( uint _amount) public onlyOwner {
1936       require(address(this).balance > _amount);
1937       owner.transfer(_amount);
1938   } 
1939 
1940   
1941 
1942   function () public payable {
1943        if (msg.sender != owner) {
1944           buy();
1945        }
1946   }
1947   
1948   function ICOactive() public view returns (bool success) {
1949       if (ICOstarttime < now && now < ICOendtime && totaltokensold < hardcapInTokens) {
1950           return true;
1951       }
1952       
1953       return false;
1954   }
1955   
1956   function buy() internal {
1957       
1958       require (msg.value >= minimumInvestmentInWei && msg.value <= maximumInvestmentInWei);
1959       require (ICOactive());
1960       
1961       uint256 NumberOfTokensToGive = msg.value.mul(USDETH).mul(1000).div(PriceOf1000TokensInUSD);
1962      
1963       if(now <= ICOstarttime + week) {
1964 
1965           NumberOfTokensToGive = NumberOfTokensToGive.mul(120).div(100);
1966 
1967       } else if(now <= ICOstarttime + 2*week){
1968           
1969           NumberOfTokensToGive = NumberOfTokensToGive.mul(115).div(100);
1970       
1971       } else if(now <= ICOstarttime + 3*week){
1972           
1973           NumberOfTokensToGive = NumberOfTokensToGive.mul(110).div(100);
1974           
1975       } else if(now <= ICOstarttime + 4*week){
1976 
1977           NumberOfTokensToGive = NumberOfTokensToGive.mul(105).div(100);
1978       }
1979       
1980       uint256 localTotaltokensold = totaltokensold;
1981       require(localTotaltokensold + NumberOfTokensToGive <= hardcapInTokens);
1982       totaltokensold = localTotaltokensold.add(NumberOfTokensToGive);
1983       
1984       require(token.transferFrom(tokensSaleHolder, msg.sender, NumberOfTokensToGive));
1985 
1986       saleSecondAddress.transfer(msg.value * 30 / 100);
1987       
1988       if(!goalReached() && (RefundVault.State.Active == vault_state)) {
1989           depositFunds();
1990       } else {
1991           if(RefundVault.State.Active == vault_state) { vault_releaseDeposit(); }
1992           saleMainAddress.transfer(msg.value * 70 / 100);
1993       }
1994   }
1995 }