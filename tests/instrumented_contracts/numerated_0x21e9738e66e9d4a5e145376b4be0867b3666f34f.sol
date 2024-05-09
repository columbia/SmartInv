1 pragma solidity ^0.4.23;
2 
3 // File: contracts/Ownable.sol
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
21   constructor() public {
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
39     emit OwnershipTransferred(owner, newOwner);
40     owner = newOwner;
41   }
42 
43 }
44 
45 // File: contracts/SafeMath.sol
46 
47 /**
48  * @title SafeMath
49  * @dev Math operations with safety checks that throw on error
50  */
51 library SafeMath {
52 
53   /**
54   * @dev Multiplies two numbers, throws on overflow.
55   */
56   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
57     if (a == 0) {
58       return 0;
59     }
60     c = a * b;
61     assert(c / a == b);
62     return c;
63   }
64 
65   /**
66   * @dev Integer division of two numbers, truncating the quotient.
67   */
68   function div(uint256 a, uint256 b) internal pure returns (uint256) {
69     // assert(b > 0); // Solidity automatically throws when dividing by 0
70     // uint256 c = a / b;
71     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
72     return a / b;
73   }
74 
75   /**
76   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
77   */
78   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   /**
84   * @dev Adds two numbers, throws on overflow.
85   */
86   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
87     c = a + b;
88     assert(c >= a);
89     return c;
90   }
91 }
92 
93 // File: contracts/RefundVault.sol
94 
95 /**
96  * @title RefundVault
97  * @dev This contract is used for storing funds while a crowdsale
98  * is in progress. Supports refunding the money if crowdsale fails,
99  * and forwarding it if crowdsale is successful.
100  */
101 contract RefundVault {
102   using SafeMath for uint256;
103 
104   enum State { Active, Refunding, Released}
105 
106   mapping (address => uint256) public vault_deposited;
107   address public vault_wallet;
108   State public vault_state;
109   uint256 totalDeposited = 0;
110   uint256 public refundDeadline;
111 
112   event DepositReleased();
113   event RefundsEnabled();
114   event RefundsDisabled();
115   event Refunded(address indexed beneficiary, uint256 weiAmount);
116 
117   constructor() public {
118     vault_state = State.Active;
119   }
120 
121   function vault_deposit(address investor, uint256 _value) internal {
122     require(vault_state == State.Active);
123     vault_deposited[investor] = vault_deposited[investor].add(_value);
124     totalDeposited = totalDeposited.add(_value);
125   }
126 
127   function vault_releaseDeposit() internal {
128     vault_state = State.Released;
129     emit DepositReleased();
130     if (totalDeposited > 0) {
131         uint256 localTotalDeposited = totalDeposited;
132         totalDeposited = 0;
133         vault_wallet.transfer(localTotalDeposited);
134     }
135   }
136 
137   function vault_enableRefunds() internal {
138     require(vault_state == State.Active);
139     refundDeadline = now + 90 days;
140     vault_state = State.Refunding;
141     emit RefundsEnabled();
142   }
143 
144   function vault_refund(address investor) internal {
145     require(vault_state == State.Refunding);
146     uint256 depositedValue = vault_deposited[investor];
147     require(depositedValue > 0);
148     
149     vault_deposited[investor] = 0;
150     emit Refunded(investor, depositedValue);
151     totalDeposited = totalDeposited.sub(depositedValue);
152     if(depositedValue != 0) {
153         investor.transfer(depositedValue);
154     }
155   }
156 }
157 
158 // File: contracts/ERC20Basic.sol
159 
160 /**
161  * @title ERC20Basic
162  * @dev Simpler version of ERC20 interface
163  * @dev see https://github.com/ethereum/EIPs/issues/179
164  */
165 contract ERC20Basic {
166   function totalSupply() public view returns (uint256);
167   function balanceOf(address who) public view returns (uint256);
168   function transfer(address to, uint256 value) public returns (bool);
169   event Transfer(address indexed from, address indexed to, uint256 value);
170 }
171 
172 // File: contracts/BasicToken.sol
173 
174 /**
175  * @title Basic token
176  * @dev Basic version of StandardToken, with no allowances.
177  */
178 contract BasicToken is ERC20Basic {
179   using SafeMath for uint256;
180 
181   mapping(address => uint256) balances;
182 
183   uint256 totalSupply_;
184 
185   /**
186   * @dev total number of tokens in existence
187   */
188   function totalSupply() public view returns (uint256) {
189     return totalSupply_;
190   }
191 
192   /**
193   * @dev transfer token for a specified address
194   * @param _to The address to transfer to.
195   * @param _value The amount to be transferred.
196   */
197   function transfer(address _to, uint256 _value) public returns (bool) {
198     require(_to != address(0));
199     require(_value <= balances[msg.sender]);
200 
201     balances[msg.sender] = balances[msg.sender].sub(_value);
202     balances[_to] = balances[_to].add(_value);
203     emit Transfer(msg.sender, _to, _value);
204     return true;
205   }
206 
207   /**
208   * @dev Gets the balance of the specified address.
209   * @param _owner The address to query the the balance of.
210   * @return An uint256 representing the amount owned by the passed address.
211   */
212   function balanceOf(address _owner) public view returns (uint256) {
213     return balances[_owner];
214   }
215 
216 }
217 
218 // File: contracts/BurnableToken.sol
219 
220 /**
221  * @title Burnable Token
222  * @dev Token that can be irreversibly burned (destroyed).
223  */
224 contract BurnableToken is BasicToken {
225 
226   event Burn(address indexed burner, uint256 value);
227 
228   /**
229    * @dev Burns a specific amount of tokens.
230    * @param _value The amount of token to be burned.
231    */
232   function burn(uint256 _value) public {
233     _burn(msg.sender, _value);
234   }
235 
236   function _burn(address _who, uint256 _value) internal {
237     require(_value <= balances[_who]);
238     // no need to require value <= totalSupply, since that would imply the
239     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
240 
241     balances[_who] = balances[_who].sub(_value);
242     totalSupply_ = totalSupply_.sub(_value);
243     emit Burn(_who, _value);
244     emit Transfer(_who, address(0), _value);
245   }
246 }
247 
248 // File: contracts/ERC20.sol
249 
250 /**
251  * @title ERC20 interface
252  * @dev see https://github.com/ethereum/EIPs/issues/20
253  */
254 contract ERC20 is ERC20Basic {
255   function allowance(address owner, address spender) public view returns (uint256);
256   function transferFrom(address from, address to, uint256 value) public returns (bool);
257   function approve(address spender, uint256 value) public returns (bool);
258   event Approval(address indexed owner, address indexed spender, uint256 value);
259 }
260 
261 // File: contracts/ERC223.sol
262 
263 /*
264   ERC223 additions to ERC20
265 
266   Interface wise is ERC20 + data paramenter to transfer and transferFrom.
267  */
268 
269 //import "github.com/OpenZeppelin/zeppelin-solidity/contracts/token/ERC20.sol";
270 
271 
272 contract ERC223 is ERC20 {
273   function transfer(address to, uint value, bytes data) public returns (bool ok);
274   function transferFrom(address from, address to, uint value, bytes data) public returns (bool ok);
275   
276   event Transfer(address indexed from, address indexed to, uint value, bytes indexed data);
277 }
278 
279 // File: contracts/ERC223Receiver.sol
280 
281 /*
282 Base class contracts willing to accept ERC223 token transfers must conform to.
283 
284 Sender: msg.sender to the token contract, the address originating the token transfer.
285           - For user originated transfers sender will be equal to tx.origin
286           - For contract originated transfers, tx.origin will be the user that made the tx that produced the transfer.
287 Origin: the origin address from whose balance the tokens are sent
288           - For transfer(), origin = msg.sender
289           - For transferFrom() origin = _from to token contract
290 Value is the amount of tokens sent
291 Data is arbitrary data sent with the token transfer. Simulates ether tx.data
292 
293 From, origin and value shouldn't be trusted unless the token contract is trusted.
294 If sender == tx.origin, it is safe to trust it regardless of the token.
295 */
296 
297 contract ERC223Receiver {
298   function tokenFallback(address _from, uint _value, bytes _data) public;
299 }
300 
301 // File: contracts/Pausable.sol
302 
303 /**
304  * @title Pausable
305  * @dev Base contract which allows children to implement an emergency stop mechanism.
306  */
307 contract Pausable is Ownable {
308   event Pause();
309   event Unpause();
310 
311   bool public paused = false;
312 
313 
314   /**
315    * @dev Modifier to make a function callable only when the contract is not paused.
316    */
317   modifier whenNotPaused() {
318     require(!paused);
319     _;
320   }
321 
322   /**
323    * @dev Modifier to make a function callable only when the contract is paused.
324    */
325   modifier whenPaused() {
326     require(paused);
327     _;
328   }
329 
330   /**
331    * @dev called by the owner to pause, triggers stopped state
332    */
333   function pause() onlyOwner whenNotPaused public {
334     paused = true;
335     emit Pause();
336   }
337 
338   /**
339    * @dev called by the owner to unpause, returns to normal state
340    */
341   function unpause() onlyOwner whenPaused public {
342     paused = false;
343     emit Unpause();
344   }
345 }
346 
347 // File: contracts/StandardToken.sol
348 
349 /**
350  * @title Standard ERC20 token
351  *
352  * @dev Implementation of the basic standard token.
353  * @dev https://github.com/ethereum/EIPs/issues/20
354  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
355  */
356 contract StandardToken is ERC20, BasicToken {
357 
358   mapping (address => mapping (address => uint256)) internal allowed;
359 
360 
361   /**
362    * @dev Transfer tokens from one address to another
363    * @param _from address The address which you want to send tokens from
364    * @param _to address The address which you want to transfer to
365    * @param _value uint256 the amount of tokens to be transferred
366    */
367   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
368     require(_to != address(0));
369     require(_value <= balances[_from]);
370     require(_value <= allowed[_from][msg.sender]);
371 
372     balances[_from] = balances[_from].sub(_value);
373     balances[_to] = balances[_to].add(_value);
374     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
375     emit Transfer(_from, _to, _value);
376     return true;
377   }
378 
379   /**
380    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
381    *
382    * Beware that changing an allowance with this method brings the risk that someone may use both the old
383    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
384    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
385    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
386    * @param _spender The address which will spend the funds.
387    * @param _value The amount of tokens to be spent.
388    */
389   function approve(address _spender, uint256 _value) public returns (bool) {
390     allowed[msg.sender][_spender] = _value;
391     emit Approval(msg.sender, _spender, _value);
392     return true;
393   }
394 
395   /**
396    * @dev Function to check the amount of tokens that an owner allowed to a spender.
397    * @param _owner address The address which owns the funds.
398    * @param _spender address The address which will spend the funds.
399    * @return A uint256 specifying the amount of tokens still available for the spender.
400    */
401   function allowance(address _owner, address _spender) public view returns (uint256) {
402     return allowed[_owner][_spender];
403   }
404 
405   /**
406    * @dev Increase the amount of tokens that an owner allowed to a spender.
407    *
408    * approve should be called when allowed[_spender] == 0. To increment
409    * allowed value is better to use this function to avoid 2 calls (and wait until
410    * the first transaction is mined)
411    * From MonolithDAO Token.sol
412    * @param _spender The address which will spend the funds.
413    * @param _addedValue The amount of tokens to increase the allowance by.
414    */
415   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
416     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
417     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
418     return true;
419   }
420 
421   /**
422    * @dev Decrease the amount of tokens that an owner allowed to a spender.
423    *
424    * approve should be called when allowed[_spender] == 0. To decrement
425    * allowed value is better to use this function to avoid 2 calls (and wait until
426    * the first transaction is mined)
427    * From MonolithDAO Token.sol
428    * @param _spender The address which will spend the funds.
429    * @param _subtractedValue The amount of tokens to decrease the allowance by.
430    */
431   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
432     uint oldValue = allowed[msg.sender][_spender];
433     if (_subtractedValue > oldValue) {
434       allowed[msg.sender][_spender] = 0;
435     } else {
436       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
437     }
438     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
439     return true;
440   }
441 
442 }
443 
444 // File: contracts/PausableToken.sol
445 
446 /**
447  * @title Pausable token
448  * @dev StandardToken modified with pausable transfers.
449  **/
450 contract PausableToken is StandardToken, Pausable {
451 
452   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
453     return super.transfer(_to, _value);
454   }
455 
456   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
457     return super.transferFrom(_from, _to, _value);
458   }
459 
460   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
461     return super.approve(_spender, _value);
462   }
463 
464   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
465     return super.increaseApproval(_spender, _addedValue);
466   }
467 
468   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
469     return super.decreaseApproval(_spender, _subtractedValue);
470   }
471 }
472 
473 // File: contracts/Pausable223Token.sol
474 
475 /* ERC223 additions to ERC20 */
476 
477 
478 
479 //import "github.com/OpenZeppelin/zeppelin-solidity/contracts/token/StandardToken.sol";
480 
481 
482 contract Pausable223Token is ERC223, PausableToken {
483   //function that is called when a user or another contract wants to transfer funds
484   function transfer(address _to, uint _value, bytes _data) public returns (bool success) {
485     //filtering if the target is a contract with bytecode inside it
486     if (!super.transfer(_to, _value)) revert(); // do a normal token transfer
487     if (isContract(_to)) contractFallback(msg.sender, _to, _value, _data);
488     emit Transfer(msg.sender, _to, _value, _data);
489     return true;
490   }
491 
492   function transferFrom(address _from, address _to, uint _value, bytes _data) public returns (bool success) {
493     if (!super.transferFrom(_from, _to, _value)) revert(); // do a normal token transfer
494     if (isContract(_to)) contractFallback(_from, _to, _value, _data);
495     emit Transfer(_from, _to, _value, _data);
496     return true;
497   }
498 
499   function transfer(address _to, uint _value) public returns (bool success) {
500     return transfer(_to, _value, new bytes(0));
501   }
502 
503   function transferFrom(address _from, address _to, uint _value) public returns (bool success) {
504     return transferFrom(_from, _to, _value, new bytes(0));
505   }
506 
507   //function that is called when transaction target is a contract
508   function contractFallback(address _origin, address _to, uint _value, bytes _data) private {
509     ERC223Receiver reciever = ERC223Receiver(_to);
510     reciever.tokenFallback(_origin, _value, _data);
511   }
512 
513   //assemble the given address bytecode. If bytecode exists then the _addr is a contract.
514   function isContract(address _addr) private view returns (bool is_contract) {
515     // retrieve the size of the code on target address, this needs assembly
516     uint length;
517     assembly { length := extcodesize(_addr) }
518     return length > 0;
519   }
520 }
521 
522 // File: contracts/WOLF.sol
523 
524 /*
525 Copyright (c) 2018 WiseWolf Ltd
526 Developed by https://adoriasoft.com
527 */
528 
529 pragma solidity ^0.4.23;
530 
531 
532 
533 
534 
535 
536 contract WOLF is BurnableToken, Pausable223Token
537 {
538     string public constant name = "TestToken";
539     string public constant symbol = "TTK";
540     uint8 public constant decimals = 18;
541     uint public constant DECIMALS_MULTIPLIER = 10**uint(decimals);
542     
543     function increaseSupply(uint value, address to) public onlyOwner returns (bool) {
544         totalSupply_ = totalSupply_.add(value);
545         balances[to] = balances[to].add(value);
546         emit Transfer(address(0), to, value);
547         return true;
548     }
549 
550     
551     function transferOwnership(address newOwner) public onlyOwner {
552         require(newOwner != address(0));
553         uint256 localOwnerBalance = balances[owner];
554         balances[newOwner] = balances[newOwner].add(localOwnerBalance);
555         balances[owner] = 0;
556         emit Transfer(owner, newOwner, localOwnerBalance);
557         super.transferOwnership(newOwner);
558     }
559     
560     constructor () public payable {
561       totalSupply_ = 1300000000 * DECIMALS_MULTIPLIER; //1000000000 + 20% bounty + 5% referal bonus + 5% team motivation
562       balances[owner] = totalSupply_;
563       emit Transfer(0x0, owner, totalSupply_);
564     }
565 }
566 
567 // File: contracts/oraclizeAPI.sol
568 
569 // <ORACLIZE_API>
570 /*
571 Copyright (c) 2015-2016 Oraclize SRL
572 Copyright (c) 2016 Oraclize LTD
573 
574 
575 
576 Permission is hereby granted, free of charge, to any person obtaining a copy
577 of this software and associated documentation files (the "Software"), to deal
578 in the Software without restriction, including without limitation the rights
579 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
580 copies of the Software, and to permit persons to whom the Software is
581 furnished to do so, subject to the following conditions:
582 
583 
584 
585 The above copyright notice and this permission notice shall be included in
586 all copies or substantial portions of the Software.
587 
588 
589 
590 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
591 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
592 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL THE
593 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
594 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
595 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
596 THE SOFTWARE.
597 */
598 
599 // This api is currently targeted at 0.4.18, please import oraclizeAPI_pre0.4.sol or oraclizeAPI_0.4 where necessary
600 pragma solidity ^0.4.18;
601 
602 contract OraclizeI {
603     address public cbAddress;
604     function query(uint _timestamp, string _datasource, string _arg) external payable returns (bytes32 _id);
605     function query_withGasLimit(uint _timestamp, string _datasource, string _arg, uint _gaslimit) external payable returns (bytes32 _id);
606     function query2(uint _timestamp, string _datasource, string _arg1, string _arg2) public payable returns (bytes32 _id);
607     function query2_withGasLimit(uint _timestamp, string _datasource, string _arg1, string _arg2, uint _gaslimit) external payable returns (bytes32 _id);
608     function queryN(uint _timestamp, string _datasource, bytes _argN) public payable returns (bytes32 _id);
609     function queryN_withGasLimit(uint _timestamp, string _datasource, bytes _argN, uint _gaslimit) external payable returns (bytes32 _id);
610     function getPrice(string _datasource) public returns (uint _dsprice);
611     function getPrice(string _datasource, uint gaslimit) public returns (uint _dsprice);
612     function setProofType(byte _proofType) external;
613     function setCustomGasPrice(uint _gasPrice) external;
614     function randomDS_getSessionPubKeyHash() external constant returns(bytes32);
615 }
616 
617 contract OraclizeAddrResolverI {
618     function getAddress() public returns (address _addr);
619 }
620 
621 /*
622 Begin solidity-cborutils
623 
624 https://github.com/smartcontractkit/solidity-cborutils
625 
626 MIT License
627 
628 Copyright (c) 2018 SmartContract ChainLink, Ltd.
629 
630 Permission is hereby granted, free of charge, to any person obtaining a copy
631 of this software and associated documentation files (the "Software"), to deal
632 in the Software without restriction, including without limitation the rights
633 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
634 copies of the Software, and to permit persons to whom the Software is
635 furnished to do so, subject to the following conditions:
636 
637 The above copyright notice and this permission notice shall be included in all
638 copies or substantial portions of the Software.
639 
640 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
641 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
642 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
643 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
644 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
645 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
646 SOFTWARE.
647  */
648 
649 library Buffer {
650     struct buffer {
651         bytes buf;
652         uint capacity;
653     }
654 
655     function init(buffer memory buf, uint capacity) internal pure {
656         if(capacity % 32 != 0) capacity += 32 - (capacity % 32);
657         // Allocate space for the buffer data
658         buf.capacity = capacity;
659         assembly {
660             let ptr := mload(0x40)
661             mstore(buf, ptr)
662             mstore(0x40, add(ptr, capacity))
663         }
664     }
665 
666     function resize(buffer memory buf, uint capacity) private pure {
667         bytes memory oldbuf = buf.buf;
668         init(buf, capacity);
669         append(buf, oldbuf);
670     }
671 
672     function max(uint a, uint b) private pure returns(uint) {
673         if(a > b) {
674             return a;
675         }
676         return b;
677     }
678 
679     /**
680      * @dev Appends a byte array to the end of the buffer. Reverts if doing so
681      *      would exceed the capacity of the buffer.
682      * @param buf The buffer to append to.
683      * @param data The data to append.
684      * @return The original buffer.
685      */
686     function append(buffer memory buf, bytes data) internal pure returns(buffer memory) {
687         if(data.length + buf.buf.length > buf.capacity) {
688             resize(buf, max(buf.capacity, data.length) * 2);
689         }
690 
691         uint dest;
692         uint src;
693         uint len = data.length;
694         assembly {
695             // Memory address of the buffer data
696             let bufptr := mload(buf)
697             // Length of existing buffer data
698             let buflen := mload(bufptr)
699             // Start address = buffer address + buffer length + sizeof(buffer length)
700             dest := add(add(bufptr, buflen), 32)
701             // Update buffer length
702             mstore(bufptr, add(buflen, mload(data)))
703             src := add(data, 32)
704         }
705 
706         // Copy word-length chunks while possible
707         for(; len >= 32; len -= 32) {
708             assembly {
709                 mstore(dest, mload(src))
710             }
711             dest += 32;
712             src += 32;
713         }
714 
715         // Copy remaining bytes
716         uint mask = 256 ** (32 - len) - 1;
717         assembly {
718             let srcpart := and(mload(src), not(mask))
719             let destpart := and(mload(dest), mask)
720             mstore(dest, or(destpart, srcpart))
721         }
722 
723         return buf;
724     }
725 
726     /**
727      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
728      * exceed the capacity of the buffer.
729      * @param buf The buffer to append to.
730      * @param data The data to append.
731      * @return The original buffer.
732      */
733     function append(buffer memory buf, uint8 data) internal pure {
734         if(buf.buf.length + 1 > buf.capacity) {
735             resize(buf, buf.capacity * 2);
736         }
737 
738         assembly {
739             // Memory address of the buffer data
740             let bufptr := mload(buf)
741             // Length of existing buffer data
742             let buflen := mload(bufptr)
743             // Address = buffer address + buffer length + sizeof(buffer length)
744             let dest := add(add(bufptr, buflen), 32)
745             mstore8(dest, data)
746             // Update buffer length
747             mstore(bufptr, add(buflen, 1))
748         }
749     }
750 
751     /**
752      * @dev Appends a byte to the end of the buffer. Reverts if doing so would
753      * exceed the capacity of the buffer.
754      * @param buf The buffer to append to.
755      * @param data The data to append.
756      * @return The original buffer.
757      */
758     function appendInt(buffer memory buf, uint data, uint len) internal pure returns(buffer memory) {
759         if(len + buf.buf.length > buf.capacity) {
760             resize(buf, max(buf.capacity, len) * 2);
761         }
762 
763         uint mask = 256 ** len - 1;
764         assembly {
765             // Memory address of the buffer data
766             let bufptr := mload(buf)
767             // Length of existing buffer data
768             let buflen := mload(bufptr)
769             // Address = buffer address + buffer length + sizeof(buffer length) + len
770             let dest := add(add(bufptr, buflen), len)
771             mstore(dest, or(and(mload(dest), not(mask)), data))
772             // Update buffer length
773             mstore(bufptr, add(buflen, len))
774         }
775         return buf;
776     }
777 }
778 
779 library CBOR {
780     using Buffer for Buffer.buffer;
781 
782     uint8 private constant MAJOR_TYPE_INT = 0;
783     uint8 private constant MAJOR_TYPE_NEGATIVE_INT = 1;
784     uint8 private constant MAJOR_TYPE_BYTES = 2;
785     uint8 private constant MAJOR_TYPE_STRING = 3;
786     uint8 private constant MAJOR_TYPE_ARRAY = 4;
787     uint8 private constant MAJOR_TYPE_MAP = 5;
788     uint8 private constant MAJOR_TYPE_CONTENT_FREE = 7;
789 
790     function encodeType(Buffer.buffer memory buf, uint8 major, uint value) private pure {
791         if(value <= 23) {
792             buf.append(uint8((major << 5) | value));
793         } else if(value <= 0xFF) {
794             buf.append(uint8((major << 5) | 24));
795             buf.appendInt(value, 1);
796         } else if(value <= 0xFFFF) {
797             buf.append(uint8((major << 5) | 25));
798             buf.appendInt(value, 2);
799         } else if(value <= 0xFFFFFFFF) {
800             buf.append(uint8((major << 5) | 26));
801             buf.appendInt(value, 4);
802         } else if(value <= 0xFFFFFFFFFFFFFFFF) {
803             buf.append(uint8((major << 5) | 27));
804             buf.appendInt(value, 8);
805         }
806     }
807 
808     function encodeIndefiniteLengthType(Buffer.buffer memory buf, uint8 major) private pure {
809         buf.append(uint8((major << 5) | 31));
810     }
811 
812     function encodeUInt(Buffer.buffer memory buf, uint value) internal pure {
813         encodeType(buf, MAJOR_TYPE_INT, value);
814     }
815 
816     function encodeInt(Buffer.buffer memory buf, int value) internal pure {
817         if(value >= 0) {
818             encodeType(buf, MAJOR_TYPE_INT, uint(value));
819         } else {
820             encodeType(buf, MAJOR_TYPE_NEGATIVE_INT, uint(-1 - value));
821         }
822     }
823 
824     function encodeBytes(Buffer.buffer memory buf, bytes value) internal pure {
825         encodeType(buf, MAJOR_TYPE_BYTES, value.length);
826         buf.append(value);
827     }
828 
829     function encodeString(Buffer.buffer memory buf, string value) internal pure {
830         encodeType(buf, MAJOR_TYPE_STRING, bytes(value).length);
831         buf.append(bytes(value));
832     }
833 
834     function startArray(Buffer.buffer memory buf) internal pure {
835         encodeIndefiniteLengthType(buf, MAJOR_TYPE_ARRAY);
836     }
837 
838     function startMap(Buffer.buffer memory buf) internal pure {
839         encodeIndefiniteLengthType(buf, MAJOR_TYPE_MAP);
840     }
841 
842     function endSequence(Buffer.buffer memory buf) internal pure {
843         encodeIndefiniteLengthType(buf, MAJOR_TYPE_CONTENT_FREE);
844     }
845 }
846 
847 /*
848 End solidity-cborutils
849  */
850 
851 contract usingOraclize {
852     uint constant day = 60*60*24;
853     uint constant week = 60*60*24*7;
854     uint constant month = 60*60*24*30;
855     byte constant proofType_NONE = 0x00;
856     byte constant proofType_TLSNotary = 0x10;
857     byte constant proofType_Android = 0x20;
858     byte constant proofType_Ledger = 0x30;
859     byte constant proofType_Native = 0xF0;
860     byte constant proofStorage_IPFS = 0x01;
861     uint8 constant networkID_auto = 0;
862     uint8 constant networkID_mainnet = 1;
863     uint8 constant networkID_testnet = 2;
864     uint8 constant networkID_morden = 2;
865     uint8 constant networkID_consensys = 161;
866 
867     OraclizeAddrResolverI OAR;
868 
869     OraclizeI oraclize;
870     modifier oraclizeAPI {
871         if((address(OAR)==0)||(getCodeSize(address(OAR))==0))
872             oraclize_setNetwork(networkID_auto);
873 
874         if(address(oraclize) != OAR.getAddress())
875             oraclize = OraclizeI(OAR.getAddress());
876 
877         _;
878     }
879     modifier coupon(string code){
880         oraclize = OraclizeI(OAR.getAddress());
881         _;
882     }
883 
884     function oraclize_setNetwork(uint8 networkID) internal returns(bool){
885       return oraclize_setNetwork();
886       networkID; // silence the warning and remain backwards compatible
887     }
888     function oraclize_setNetwork() internal returns(bool){
889         if (getCodeSize(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed)>0){ //mainnet
890             OAR = OraclizeAddrResolverI(0x1d3B2638a7cC9f2CB3D298A3DA7a90B67E5506ed);
891             oraclize_setNetworkName("eth_mainnet");
892             return true;
893         }
894         if (getCodeSize(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1)>0){ //ropsten testnet
895             OAR = OraclizeAddrResolverI(0xc03A2615D5efaf5F49F60B7BB6583eaec212fdf1);
896             oraclize_setNetworkName("eth_ropsten3");
897             return true;
898         }
899         if (getCodeSize(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e)>0){ //kovan testnet
900             OAR = OraclizeAddrResolverI(0xB7A07BcF2Ba2f2703b24C0691b5278999C59AC7e);
901             oraclize_setNetworkName("eth_kovan");
902             return true;
903         }
904         if (getCodeSize(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48)>0){ //rinkeby testnet
905             OAR = OraclizeAddrResolverI(0x146500cfd35B22E4A392Fe0aDc06De1a1368Ed48);
906             oraclize_setNetworkName("eth_rinkeby");
907             return true;
908         }
909         if (getCodeSize(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475)>0){ //ethereum-bridge
910             OAR = OraclizeAddrResolverI(0x6f485C8BF6fc43eA212E93BBF8ce046C7f1cb475);
911             return true;
912         }
913         if (getCodeSize(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF)>0){ //ether.camp ide
914             OAR = OraclizeAddrResolverI(0x20e12A1F859B3FeaE5Fb2A0A32C18F5a65555bBF);
915             return true;
916         }
917         if (getCodeSize(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA)>0){ //browser-solidity
918             OAR = OraclizeAddrResolverI(0x51efaF4c8B3C9AfBD5aB9F4bbC82784Ab6ef8fAA);
919             return true;
920         }
921         return false;
922     }
923 
924     function __callback(bytes32 myid, string result) public {
925         __callback(myid, result, new bytes(0));
926     }
927     function __callback(bytes32 myid, string result, bytes proof) public pure {
928       return;
929       myid; result; proof; // Silence compiler warnings
930     }
931 
932     function oraclize_getPrice(string datasource) oraclizeAPI internal returns (uint){
933         return oraclize.getPrice(datasource);
934     }
935 
936     function oraclize_getPrice(string datasource, uint gaslimit) oraclizeAPI internal returns (uint){
937         return oraclize.getPrice(datasource, gaslimit);
938     }
939 
940     function oraclize_query(string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
941         uint price = oraclize.getPrice(datasource);
942         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
943         return oraclize.query.value(price)(0, datasource, arg);
944     }
945     function oraclize_query(uint timestamp, string datasource, string arg) oraclizeAPI internal returns (bytes32 id){
946         uint price = oraclize.getPrice(datasource);
947         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
948         return oraclize.query.value(price)(timestamp, datasource, arg);
949     }
950     function oraclize_query(uint timestamp, string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
951         uint price = oraclize.getPrice(datasource, gaslimit);
952         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
953         return oraclize.query_withGasLimit.value(price)(timestamp, datasource, arg, gaslimit);
954     }
955     function oraclize_query(string datasource, string arg, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
956         uint price = oraclize.getPrice(datasource, gaslimit);
957         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
958         return oraclize.query_withGasLimit.value(price)(0, datasource, arg, gaslimit);
959     }
960     function oraclize_query(string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
961         uint price = oraclize.getPrice(datasource);
962         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
963         return oraclize.query2.value(price)(0, datasource, arg1, arg2);
964     }
965     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2) oraclizeAPI internal returns (bytes32 id){
966         uint price = oraclize.getPrice(datasource);
967         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
968         return oraclize.query2.value(price)(timestamp, datasource, arg1, arg2);
969     }
970     function oraclize_query(uint timestamp, string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
971         uint price = oraclize.getPrice(datasource, gaslimit);
972         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
973         return oraclize.query2_withGasLimit.value(price)(timestamp, datasource, arg1, arg2, gaslimit);
974     }
975     function oraclize_query(string datasource, string arg1, string arg2, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
976         uint price = oraclize.getPrice(datasource, gaslimit);
977         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
978         return oraclize.query2_withGasLimit.value(price)(0, datasource, arg1, arg2, gaslimit);
979     }
980     function oraclize_query(string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
981         uint price = oraclize.getPrice(datasource);
982         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
983         bytes memory args = stra2cbor(argN);
984         return oraclize.queryN.value(price)(0, datasource, args);
985     }
986     function oraclize_query(uint timestamp, string datasource, string[] argN) oraclizeAPI internal returns (bytes32 id){
987         uint price = oraclize.getPrice(datasource);
988         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
989         bytes memory args = stra2cbor(argN);
990         return oraclize.queryN.value(price)(timestamp, datasource, args);
991     }
992     function oraclize_query(uint timestamp, string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
993         uint price = oraclize.getPrice(datasource, gaslimit);
994         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
995         bytes memory args = stra2cbor(argN);
996         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
997     }
998     function oraclize_query(string datasource, string[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
999         uint price = oraclize.getPrice(datasource, gaslimit);
1000         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1001         bytes memory args = stra2cbor(argN);
1002         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
1003     }
1004     function oraclize_query(string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
1005         string[] memory dynargs = new string[](1);
1006         dynargs[0] = args[0];
1007         return oraclize_query(datasource, dynargs);
1008     }
1009     function oraclize_query(uint timestamp, string datasource, string[1] args) oraclizeAPI internal returns (bytes32 id) {
1010         string[] memory dynargs = new string[](1);
1011         dynargs[0] = args[0];
1012         return oraclize_query(timestamp, datasource, dynargs);
1013     }
1014     function oraclize_query(uint timestamp, string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1015         string[] memory dynargs = new string[](1);
1016         dynargs[0] = args[0];
1017         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1018     }
1019     function oraclize_query(string datasource, string[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1020         string[] memory dynargs = new string[](1);
1021         dynargs[0] = args[0];
1022         return oraclize_query(datasource, dynargs, gaslimit);
1023     }
1024 
1025     function oraclize_query(string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
1026         string[] memory dynargs = new string[](2);
1027         dynargs[0] = args[0];
1028         dynargs[1] = args[1];
1029         return oraclize_query(datasource, dynargs);
1030     }
1031     function oraclize_query(uint timestamp, string datasource, string[2] args) oraclizeAPI internal returns (bytes32 id) {
1032         string[] memory dynargs = new string[](2);
1033         dynargs[0] = args[0];
1034         dynargs[1] = args[1];
1035         return oraclize_query(timestamp, datasource, dynargs);
1036     }
1037     function oraclize_query(uint timestamp, string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1038         string[] memory dynargs = new string[](2);
1039         dynargs[0] = args[0];
1040         dynargs[1] = args[1];
1041         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1042     }
1043     function oraclize_query(string datasource, string[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1044         string[] memory dynargs = new string[](2);
1045         dynargs[0] = args[0];
1046         dynargs[1] = args[1];
1047         return oraclize_query(datasource, dynargs, gaslimit);
1048     }
1049     function oraclize_query(string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
1050         string[] memory dynargs = new string[](3);
1051         dynargs[0] = args[0];
1052         dynargs[1] = args[1];
1053         dynargs[2] = args[2];
1054         return oraclize_query(datasource, dynargs);
1055     }
1056     function oraclize_query(uint timestamp, string datasource, string[3] args) oraclizeAPI internal returns (bytes32 id) {
1057         string[] memory dynargs = new string[](3);
1058         dynargs[0] = args[0];
1059         dynargs[1] = args[1];
1060         dynargs[2] = args[2];
1061         return oraclize_query(timestamp, datasource, dynargs);
1062     }
1063     function oraclize_query(uint timestamp, string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1064         string[] memory dynargs = new string[](3);
1065         dynargs[0] = args[0];
1066         dynargs[1] = args[1];
1067         dynargs[2] = args[2];
1068         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1069     }
1070     function oraclize_query(string datasource, string[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1071         string[] memory dynargs = new string[](3);
1072         dynargs[0] = args[0];
1073         dynargs[1] = args[1];
1074         dynargs[2] = args[2];
1075         return oraclize_query(datasource, dynargs, gaslimit);
1076     }
1077 
1078     function oraclize_query(string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1079         string[] memory dynargs = new string[](4);
1080         dynargs[0] = args[0];
1081         dynargs[1] = args[1];
1082         dynargs[2] = args[2];
1083         dynargs[3] = args[3];
1084         return oraclize_query(datasource, dynargs);
1085     }
1086     function oraclize_query(uint timestamp, string datasource, string[4] args) oraclizeAPI internal returns (bytes32 id) {
1087         string[] memory dynargs = new string[](4);
1088         dynargs[0] = args[0];
1089         dynargs[1] = args[1];
1090         dynargs[2] = args[2];
1091         dynargs[3] = args[3];
1092         return oraclize_query(timestamp, datasource, dynargs);
1093     }
1094     function oraclize_query(uint timestamp, string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1095         string[] memory dynargs = new string[](4);
1096         dynargs[0] = args[0];
1097         dynargs[1] = args[1];
1098         dynargs[2] = args[2];
1099         dynargs[3] = args[3];
1100         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1101     }
1102     function oraclize_query(string datasource, string[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1103         string[] memory dynargs = new string[](4);
1104         dynargs[0] = args[0];
1105         dynargs[1] = args[1];
1106         dynargs[2] = args[2];
1107         dynargs[3] = args[3];
1108         return oraclize_query(datasource, dynargs, gaslimit);
1109     }
1110     function oraclize_query(string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1111         string[] memory dynargs = new string[](5);
1112         dynargs[0] = args[0];
1113         dynargs[1] = args[1];
1114         dynargs[2] = args[2];
1115         dynargs[3] = args[3];
1116         dynargs[4] = args[4];
1117         return oraclize_query(datasource, dynargs);
1118     }
1119     function oraclize_query(uint timestamp, string datasource, string[5] args) oraclizeAPI internal returns (bytes32 id) {
1120         string[] memory dynargs = new string[](5);
1121         dynargs[0] = args[0];
1122         dynargs[1] = args[1];
1123         dynargs[2] = args[2];
1124         dynargs[3] = args[3];
1125         dynargs[4] = args[4];
1126         return oraclize_query(timestamp, datasource, dynargs);
1127     }
1128     function oraclize_query(uint timestamp, string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1129         string[] memory dynargs = new string[](5);
1130         dynargs[0] = args[0];
1131         dynargs[1] = args[1];
1132         dynargs[2] = args[2];
1133         dynargs[3] = args[3];
1134         dynargs[4] = args[4];
1135         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1136     }
1137     function oraclize_query(string datasource, string[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1138         string[] memory dynargs = new string[](5);
1139         dynargs[0] = args[0];
1140         dynargs[1] = args[1];
1141         dynargs[2] = args[2];
1142         dynargs[3] = args[3];
1143         dynargs[4] = args[4];
1144         return oraclize_query(datasource, dynargs, gaslimit);
1145     }
1146     function oraclize_query(string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1147         uint price = oraclize.getPrice(datasource);
1148         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1149         bytes memory args = ba2cbor(argN);
1150         return oraclize.queryN.value(price)(0, datasource, args);
1151     }
1152     function oraclize_query(uint timestamp, string datasource, bytes[] argN) oraclizeAPI internal returns (bytes32 id){
1153         uint price = oraclize.getPrice(datasource);
1154         if (price > 1 ether + tx.gasprice*200000) return 0; // unexpectedly high price
1155         bytes memory args = ba2cbor(argN);
1156         return oraclize.queryN.value(price)(timestamp, datasource, args);
1157     }
1158     function oraclize_query(uint timestamp, string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1159         uint price = oraclize.getPrice(datasource, gaslimit);
1160         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1161         bytes memory args = ba2cbor(argN);
1162         return oraclize.queryN_withGasLimit.value(price)(timestamp, datasource, args, gaslimit);
1163     }
1164     function oraclize_query(string datasource, bytes[] argN, uint gaslimit) oraclizeAPI internal returns (bytes32 id){
1165         uint price = oraclize.getPrice(datasource, gaslimit);
1166         if (price > 1 ether + tx.gasprice*gaslimit) return 0; // unexpectedly high price
1167         bytes memory args = ba2cbor(argN);
1168         return oraclize.queryN_withGasLimit.value(price)(0, datasource, args, gaslimit);
1169     }
1170     function oraclize_query(string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1171         bytes[] memory dynargs = new bytes[](1);
1172         dynargs[0] = args[0];
1173         return oraclize_query(datasource, dynargs);
1174     }
1175     function oraclize_query(uint timestamp, string datasource, bytes[1] args) oraclizeAPI internal returns (bytes32 id) {
1176         bytes[] memory dynargs = new bytes[](1);
1177         dynargs[0] = args[0];
1178         return oraclize_query(timestamp, datasource, dynargs);
1179     }
1180     function oraclize_query(uint timestamp, string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1181         bytes[] memory dynargs = new bytes[](1);
1182         dynargs[0] = args[0];
1183         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1184     }
1185     function oraclize_query(string datasource, bytes[1] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1186         bytes[] memory dynargs = new bytes[](1);
1187         dynargs[0] = args[0];
1188         return oraclize_query(datasource, dynargs, gaslimit);
1189     }
1190 
1191     function oraclize_query(string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1192         bytes[] memory dynargs = new bytes[](2);
1193         dynargs[0] = args[0];
1194         dynargs[1] = args[1];
1195         return oraclize_query(datasource, dynargs);
1196     }
1197     function oraclize_query(uint timestamp, string datasource, bytes[2] args) oraclizeAPI internal returns (bytes32 id) {
1198         bytes[] memory dynargs = new bytes[](2);
1199         dynargs[0] = args[0];
1200         dynargs[1] = args[1];
1201         return oraclize_query(timestamp, datasource, dynargs);
1202     }
1203     function oraclize_query(uint timestamp, string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1204         bytes[] memory dynargs = new bytes[](2);
1205         dynargs[0] = args[0];
1206         dynargs[1] = args[1];
1207         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1208     }
1209     function oraclize_query(string datasource, bytes[2] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1210         bytes[] memory dynargs = new bytes[](2);
1211         dynargs[0] = args[0];
1212         dynargs[1] = args[1];
1213         return oraclize_query(datasource, dynargs, gaslimit);
1214     }
1215     function oraclize_query(string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1216         bytes[] memory dynargs = new bytes[](3);
1217         dynargs[0] = args[0];
1218         dynargs[1] = args[1];
1219         dynargs[2] = args[2];
1220         return oraclize_query(datasource, dynargs);
1221     }
1222     function oraclize_query(uint timestamp, string datasource, bytes[3] args) oraclizeAPI internal returns (bytes32 id) {
1223         bytes[] memory dynargs = new bytes[](3);
1224         dynargs[0] = args[0];
1225         dynargs[1] = args[1];
1226         dynargs[2] = args[2];
1227         return oraclize_query(timestamp, datasource, dynargs);
1228     }
1229     function oraclize_query(uint timestamp, string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1230         bytes[] memory dynargs = new bytes[](3);
1231         dynargs[0] = args[0];
1232         dynargs[1] = args[1];
1233         dynargs[2] = args[2];
1234         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1235     }
1236     function oraclize_query(string datasource, bytes[3] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1237         bytes[] memory dynargs = new bytes[](3);
1238         dynargs[0] = args[0];
1239         dynargs[1] = args[1];
1240         dynargs[2] = args[2];
1241         return oraclize_query(datasource, dynargs, gaslimit);
1242     }
1243 
1244     function oraclize_query(string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1245         bytes[] memory dynargs = new bytes[](4);
1246         dynargs[0] = args[0];
1247         dynargs[1] = args[1];
1248         dynargs[2] = args[2];
1249         dynargs[3] = args[3];
1250         return oraclize_query(datasource, dynargs);
1251     }
1252     function oraclize_query(uint timestamp, string datasource, bytes[4] args) oraclizeAPI internal returns (bytes32 id) {
1253         bytes[] memory dynargs = new bytes[](4);
1254         dynargs[0] = args[0];
1255         dynargs[1] = args[1];
1256         dynargs[2] = args[2];
1257         dynargs[3] = args[3];
1258         return oraclize_query(timestamp, datasource, dynargs);
1259     }
1260     function oraclize_query(uint timestamp, string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1261         bytes[] memory dynargs = new bytes[](4);
1262         dynargs[0] = args[0];
1263         dynargs[1] = args[1];
1264         dynargs[2] = args[2];
1265         dynargs[3] = args[3];
1266         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1267     }
1268     function oraclize_query(string datasource, bytes[4] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1269         bytes[] memory dynargs = new bytes[](4);
1270         dynargs[0] = args[0];
1271         dynargs[1] = args[1];
1272         dynargs[2] = args[2];
1273         dynargs[3] = args[3];
1274         return oraclize_query(datasource, dynargs, gaslimit);
1275     }
1276     function oraclize_query(string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1277         bytes[] memory dynargs = new bytes[](5);
1278         dynargs[0] = args[0];
1279         dynargs[1] = args[1];
1280         dynargs[2] = args[2];
1281         dynargs[3] = args[3];
1282         dynargs[4] = args[4];
1283         return oraclize_query(datasource, dynargs);
1284     }
1285     function oraclize_query(uint timestamp, string datasource, bytes[5] args) oraclizeAPI internal returns (bytes32 id) {
1286         bytes[] memory dynargs = new bytes[](5);
1287         dynargs[0] = args[0];
1288         dynargs[1] = args[1];
1289         dynargs[2] = args[2];
1290         dynargs[3] = args[3];
1291         dynargs[4] = args[4];
1292         return oraclize_query(timestamp, datasource, dynargs);
1293     }
1294     function oraclize_query(uint timestamp, string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1295         bytes[] memory dynargs = new bytes[](5);
1296         dynargs[0] = args[0];
1297         dynargs[1] = args[1];
1298         dynargs[2] = args[2];
1299         dynargs[3] = args[3];
1300         dynargs[4] = args[4];
1301         return oraclize_query(timestamp, datasource, dynargs, gaslimit);
1302     }
1303     function oraclize_query(string datasource, bytes[5] args, uint gaslimit) oraclizeAPI internal returns (bytes32 id) {
1304         bytes[] memory dynargs = new bytes[](5);
1305         dynargs[0] = args[0];
1306         dynargs[1] = args[1];
1307         dynargs[2] = args[2];
1308         dynargs[3] = args[3];
1309         dynargs[4] = args[4];
1310         return oraclize_query(datasource, dynargs, gaslimit);
1311     }
1312 
1313     function oraclize_cbAddress() oraclizeAPI internal returns (address){
1314         return oraclize.cbAddress();
1315     }
1316     function oraclize_setProof(byte proofP) oraclizeAPI internal {
1317         return oraclize.setProofType(proofP);
1318     }
1319     function oraclize_setCustomGasPrice(uint gasPrice) oraclizeAPI internal {
1320         return oraclize.setCustomGasPrice(gasPrice);
1321     }
1322 
1323     function oraclize_randomDS_getSessionPubKeyHash() oraclizeAPI internal returns (bytes32){
1324         return oraclize.randomDS_getSessionPubKeyHash();
1325     }
1326 
1327     function getCodeSize(address _addr) constant internal returns(uint _size) {
1328         assembly {
1329             _size := extcodesize(_addr)
1330         }
1331     }
1332 
1333     function parseAddr(string _a) internal pure returns (address){
1334         bytes memory tmp = bytes(_a);
1335         uint160 iaddr = 0;
1336         uint160 b1;
1337         uint160 b2;
1338         for (uint i=2; i<2+2*20; i+=2){
1339             iaddr *= 256;
1340             b1 = uint160(tmp[i]);
1341             b2 = uint160(tmp[i+1]);
1342             if ((b1 >= 97)&&(b1 <= 102)) b1 -= 87;
1343             else if ((b1 >= 65)&&(b1 <= 70)) b1 -= 55;
1344             else if ((b1 >= 48)&&(b1 <= 57)) b1 -= 48;
1345             if ((b2 >= 97)&&(b2 <= 102)) b2 -= 87;
1346             else if ((b2 >= 65)&&(b2 <= 70)) b2 -= 55;
1347             else if ((b2 >= 48)&&(b2 <= 57)) b2 -= 48;
1348             iaddr += (b1*16+b2);
1349         }
1350         return address(iaddr);
1351     }
1352 
1353     function strCompare(string _a, string _b) internal pure returns (int) {
1354         bytes memory a = bytes(_a);
1355         bytes memory b = bytes(_b);
1356         uint minLength = a.length;
1357         if (b.length < minLength) minLength = b.length;
1358         for (uint i = 0; i < minLength; i ++)
1359             if (a[i] < b[i])
1360                 return -1;
1361             else if (a[i] > b[i])
1362                 return 1;
1363         if (a.length < b.length)
1364             return -1;
1365         else if (a.length > b.length)
1366             return 1;
1367         else
1368             return 0;
1369     }
1370 
1371     function indexOf(string _haystack, string _needle) internal pure returns (int) {
1372         bytes memory h = bytes(_haystack);
1373         bytes memory n = bytes(_needle);
1374         if(h.length < 1 || n.length < 1 || (n.length > h.length))
1375             return -1;
1376         else if(h.length > (2**128 -1))
1377             return -1;
1378         else
1379         {
1380             uint subindex = 0;
1381             for (uint i = 0; i < h.length; i ++)
1382             {
1383                 if (h[i] == n[0])
1384                 {
1385                     subindex = 1;
1386                     while(subindex < n.length && (i + subindex) < h.length && h[i + subindex] == n[subindex])
1387                     {
1388                         subindex++;
1389                     }
1390                     if(subindex == n.length)
1391                         return int(i);
1392                 }
1393             }
1394             return -1;
1395         }
1396     }
1397 
1398     function strConcat(string _a, string _b, string _c, string _d, string _e) internal pure returns (string) {
1399         bytes memory _ba = bytes(_a);
1400         bytes memory _bb = bytes(_b);
1401         bytes memory _bc = bytes(_c);
1402         bytes memory _bd = bytes(_d);
1403         bytes memory _be = bytes(_e);
1404         string memory abcde = new string(_ba.length + _bb.length + _bc.length + _bd.length + _be.length);
1405         bytes memory babcde = bytes(abcde);
1406         uint k = 0;
1407         for (uint i = 0; i < _ba.length; i++) babcde[k++] = _ba[i];
1408         for (i = 0; i < _bb.length; i++) babcde[k++] = _bb[i];
1409         for (i = 0; i < _bc.length; i++) babcde[k++] = _bc[i];
1410         for (i = 0; i < _bd.length; i++) babcde[k++] = _bd[i];
1411         for (i = 0; i < _be.length; i++) babcde[k++] = _be[i];
1412         return string(babcde);
1413     }
1414 
1415     function strConcat(string _a, string _b, string _c, string _d) internal pure returns (string) {
1416         return strConcat(_a, _b, _c, _d, "");
1417     }
1418 
1419     function strConcat(string _a, string _b, string _c) internal pure returns (string) {
1420         return strConcat(_a, _b, _c, "", "");
1421     }
1422 
1423     function strConcat(string _a, string _b) internal pure returns (string) {
1424         return strConcat(_a, _b, "", "", "");
1425     }
1426 
1427     // parseInt
1428     function parseInt(string _a) internal pure returns (uint) {
1429         return parseInt(_a, 0);
1430     }
1431 
1432     // parseInt(parseFloat*10^_b)
1433     function parseInt(string _a, uint _b) internal pure returns (uint) {
1434         bytes memory bresult = bytes(_a);
1435         uint mint = 0;
1436         bool decimals = false;
1437         for (uint i=0; i<bresult.length; i++){
1438             if ((bresult[i] >= 48)&&(bresult[i] <= 57)){
1439                 if (decimals){
1440                    if (_b == 0) break;
1441                     else _b--;
1442                 }
1443                 mint *= 10;
1444                 mint += uint(bresult[i]) - 48;
1445             } else if (bresult[i] == 46) decimals = true;
1446         }
1447         if (_b > 0) mint *= 10**_b;
1448         return mint;
1449     }
1450 
1451     function uint2str(uint i) internal pure returns (string){
1452         if (i == 0) return "0";
1453         uint j = i;
1454         uint len;
1455         while (j != 0){
1456             len++;
1457             j /= 10;
1458         }
1459         bytes memory bstr = new bytes(len);
1460         uint k = len - 1;
1461         while (i != 0){
1462             bstr[k--] = byte(48 + i % 10);
1463             i /= 10;
1464         }
1465         return string(bstr);
1466     }
1467 
1468     using CBOR for Buffer.buffer;
1469     function stra2cbor(string[] arr) internal pure returns (bytes) {
1470         Buffer.buffer memory buf;
1471         Buffer.init(buf, 1024);
1472         buf.startArray();
1473         for (uint i = 0; i < arr.length; i++) {
1474             buf.encodeString(arr[i]);
1475         }
1476         buf.endSequence();
1477         return buf.buf;
1478     }
1479 
1480     function ba2cbor(bytes[] arr) internal pure returns (bytes) {
1481         Buffer.buffer memory buf;
1482         Buffer.init(buf, 1024);
1483         buf.startArray();
1484         for (uint i = 0; i < arr.length; i++) {
1485             buf.encodeBytes(arr[i]);
1486         }
1487         buf.endSequence();
1488         return buf.buf;
1489     }
1490 
1491     string oraclize_network_name;
1492     function oraclize_setNetworkName(string _network_name) internal {
1493         oraclize_network_name = _network_name;
1494     }
1495 
1496     function oraclize_getNetworkName() internal view returns (string) {
1497         return oraclize_network_name;
1498     }
1499 
1500     function oraclize_newRandomDSQuery(uint _delay, uint _nbytes, uint _customGasLimit) internal returns (bytes32){
1501         require((_nbytes > 0) && (_nbytes <= 32));
1502         // Convert from seconds to ledger timer ticks
1503         _delay *= 10;
1504         bytes memory nbytes = new bytes(1);
1505         nbytes[0] = byte(_nbytes);
1506         bytes memory unonce = new bytes(32);
1507         bytes memory sessionKeyHash = new bytes(32);
1508         bytes32 sessionKeyHash_bytes32 = oraclize_randomDS_getSessionPubKeyHash();
1509         assembly {
1510             mstore(unonce, 0x20)
1511             mstore(add(unonce, 0x20), xor(blockhash(sub(number, 1)), xor(coinbase, timestamp)))
1512             mstore(sessionKeyHash, 0x20)
1513             mstore(add(sessionKeyHash, 0x20), sessionKeyHash_bytes32)
1514         }
1515         bytes memory delay = new bytes(32);
1516         assembly {
1517             mstore(add(delay, 0x20), _delay)
1518         }
1519 
1520         bytes memory delay_bytes8 = new bytes(8);
1521         copyBytes(delay, 24, 8, delay_bytes8, 0);
1522 
1523         bytes[4] memory args = [unonce, nbytes, sessionKeyHash, delay];
1524         bytes32 queryId = oraclize_query("random", args, _customGasLimit);
1525 
1526         bytes memory delay_bytes8_left = new bytes(8);
1527 
1528         assembly {
1529             let x := mload(add(delay_bytes8, 0x20))
1530             mstore8(add(delay_bytes8_left, 0x27), div(x, 0x100000000000000000000000000000000000000000000000000000000000000))
1531             mstore8(add(delay_bytes8_left, 0x26), div(x, 0x1000000000000000000000000000000000000000000000000000000000000))
1532             mstore8(add(delay_bytes8_left, 0x25), div(x, 0x10000000000000000000000000000000000000000000000000000000000))
1533             mstore8(add(delay_bytes8_left, 0x24), div(x, 0x100000000000000000000000000000000000000000000000000000000))
1534             mstore8(add(delay_bytes8_left, 0x23), div(x, 0x1000000000000000000000000000000000000000000000000000000))
1535             mstore8(add(delay_bytes8_left, 0x22), div(x, 0x10000000000000000000000000000000000000000000000000000))
1536             mstore8(add(delay_bytes8_left, 0x21), div(x, 0x100000000000000000000000000000000000000000000000000))
1537             mstore8(add(delay_bytes8_left, 0x20), div(x, 0x1000000000000000000000000000000000000000000000000))
1538 
1539         }
1540 
1541         oraclize_randomDS_setCommitment(queryId, keccak256(delay_bytes8_left, args[1], sha256(args[0]), args[2]));
1542         return queryId;
1543     }
1544 
1545     function oraclize_randomDS_setCommitment(bytes32 queryId, bytes32 commitment) internal {
1546         oraclize_randomDS_args[queryId] = commitment;
1547     }
1548 
1549     mapping(bytes32=>bytes32) oraclize_randomDS_args;
1550     mapping(bytes32=>bool) oraclize_randomDS_sessionKeysHashVerified;
1551 
1552     function verifySig(bytes32 tosignh, bytes dersig, bytes pubkey) internal returns (bool){
1553         bool sigok;
1554         address signer;
1555 
1556         bytes32 sigr;
1557         bytes32 sigs;
1558 
1559         bytes memory sigr_ = new bytes(32);
1560         uint offset = 4+(uint(dersig[3]) - 0x20);
1561         sigr_ = copyBytes(dersig, offset, 32, sigr_, 0);
1562         bytes memory sigs_ = new bytes(32);
1563         offset += 32 + 2;
1564         sigs_ = copyBytes(dersig, offset+(uint(dersig[offset-1]) - 0x20), 32, sigs_, 0);
1565 
1566         assembly {
1567             sigr := mload(add(sigr_, 32))
1568             sigs := mload(add(sigs_, 32))
1569         }
1570 
1571 
1572         (sigok, signer) = safer_ecrecover(tosignh, 27, sigr, sigs);
1573         if (address(keccak256(pubkey)) == signer) return true;
1574         else {
1575             (sigok, signer) = safer_ecrecover(tosignh, 28, sigr, sigs);
1576             return (address(keccak256(pubkey)) == signer);
1577         }
1578     }
1579 
1580     function oraclize_randomDS_proofVerify__sessionKeyValidity(bytes proof, uint sig2offset) internal returns (bool) {
1581         bool sigok;
1582 
1583         // Step 6: verify the attestation signature, APPKEY1 must sign the sessionKey from the correct ledger app (CODEHASH)
1584         bytes memory sig2 = new bytes(uint(proof[sig2offset+1])+2);
1585         copyBytes(proof, sig2offset, sig2.length, sig2, 0);
1586 
1587         bytes memory appkey1_pubkey = new bytes(64);
1588         copyBytes(proof, 3+1, 64, appkey1_pubkey, 0);
1589 
1590         bytes memory tosign2 = new bytes(1+65+32);
1591         tosign2[0] = byte(1); //role
1592         copyBytes(proof, sig2offset-65, 65, tosign2, 1);
1593         bytes memory CODEHASH = hex"fd94fa71bc0ba10d39d464d0d8f465efeef0a2764e3887fcc9df41ded20f505c";
1594         copyBytes(CODEHASH, 0, 32, tosign2, 1+65);
1595         sigok = verifySig(sha256(tosign2), sig2, appkey1_pubkey);
1596 
1597         if (sigok == false) return false;
1598 
1599 
1600         // Step 7: verify the APPKEY1 provenance (must be signed by Ledger)
1601         bytes memory LEDGERKEY = hex"7fb956469c5c9b89840d55b43537e66a98dd4811ea0a27224272c2e5622911e8537a2f8e86a46baec82864e98dd01e9ccc2f8bc5dfc9cbe5a91a290498dd96e4";
1602 
1603         bytes memory tosign3 = new bytes(1+65);
1604         tosign3[0] = 0xFE;
1605         copyBytes(proof, 3, 65, tosign3, 1);
1606 
1607         bytes memory sig3 = new bytes(uint(proof[3+65+1])+2);
1608         copyBytes(proof, 3+65, sig3.length, sig3, 0);
1609 
1610         sigok = verifySig(sha256(tosign3), sig3, LEDGERKEY);
1611 
1612         return sigok;
1613     }
1614 
1615     modifier oraclize_randomDS_proofVerify(bytes32 _queryId, string _result, bytes _proof) {
1616         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1617         require((_proof[0] == "L") && (_proof[1] == "P") && (_proof[2] == 1));
1618 
1619         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1620         require(proofVerified);
1621 
1622         _;
1623     }
1624 
1625     function oraclize_randomDS_proofVerify__returnCode(bytes32 _queryId, string _result, bytes _proof) internal returns (uint8){
1626         // Step 1: the prefix has to match 'LP\x01' (Ledger Proof version 1)
1627         if ((_proof[0] != "L")||(_proof[1] != "P")||(_proof[2] != 1)) return 1;
1628 
1629         bool proofVerified = oraclize_randomDS_proofVerify__main(_proof, _queryId, bytes(_result), oraclize_getNetworkName());
1630         if (proofVerified == false) return 2;
1631 
1632         return 0;
1633     }
1634 
1635     function matchBytes32Prefix(bytes32 content, bytes prefix, uint n_random_bytes) internal pure returns (bool){
1636         bool match_ = true;
1637 
1638         require(prefix.length == n_random_bytes);
1639 
1640         for (uint256 i=0; i< n_random_bytes; i++) {
1641             if (content[i] != prefix[i]) match_ = false;
1642         }
1643 
1644         return match_;
1645     }
1646 
1647     function oraclize_randomDS_proofVerify__main(bytes proof, bytes32 queryId, bytes result, string context_name) internal returns (bool){
1648 
1649         // Step 2: the unique keyhash has to match with the sha256 of (context name + queryId)
1650         uint ledgerProofLength = 3+65+(uint(proof[3+65+1])+2)+32;
1651         bytes memory keyhash = new bytes(32);
1652         copyBytes(proof, ledgerProofLength, 32, keyhash, 0);
1653         if (!(keccak256(keyhash) == keccak256(sha256(context_name, queryId)))) return false;
1654 
1655         bytes memory sig1 = new bytes(uint(proof[ledgerProofLength+(32+8+1+32)+1])+2);
1656         copyBytes(proof, ledgerProofLength+(32+8+1+32), sig1.length, sig1, 0);
1657 
1658         // Step 3: we assume sig1 is valid (it will be verified during step 5) and we verify if 'result' is the prefix of sha256(sig1)
1659         if (!matchBytes32Prefix(sha256(sig1), result, uint(proof[ledgerProofLength+32+8]))) return false;
1660 
1661         // Step 4: commitment match verification, keccak256(delay, nbytes, unonce, sessionKeyHash) == commitment in storage.
1662         // This is to verify that the computed args match with the ones specified in the query.
1663         bytes memory commitmentSlice1 = new bytes(8+1+32);
1664         copyBytes(proof, ledgerProofLength+32, 8+1+32, commitmentSlice1, 0);
1665 
1666         bytes memory sessionPubkey = new bytes(64);
1667         uint sig2offset = ledgerProofLength+32+(8+1+32)+sig1.length+65;
1668         copyBytes(proof, sig2offset-64, 64, sessionPubkey, 0);
1669 
1670         bytes32 sessionPubkeyHash = sha256(sessionPubkey);
1671         if (oraclize_randomDS_args[queryId] == keccak256(commitmentSlice1, sessionPubkeyHash)){ //unonce, nbytes and sessionKeyHash match
1672             delete oraclize_randomDS_args[queryId];
1673         } else return false;
1674 
1675 
1676         // Step 5: validity verification for sig1 (keyhash and args signed with the sessionKey)
1677         bytes memory tosign1 = new bytes(32+8+1+32);
1678         copyBytes(proof, ledgerProofLength, 32+8+1+32, tosign1, 0);
1679         if (!verifySig(sha256(tosign1), sig1, sessionPubkey)) return false;
1680 
1681         // verify if sessionPubkeyHash was verified already, if not.. let's do it!
1682         if (oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] == false){
1683             oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash] = oraclize_randomDS_proofVerify__sessionKeyValidity(proof, sig2offset);
1684         }
1685 
1686         return oraclize_randomDS_sessionKeysHashVerified[sessionPubkeyHash];
1687     }
1688 
1689     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1690     function copyBytes(bytes from, uint fromOffset, uint length, bytes to, uint toOffset) internal pure returns (bytes) {
1691         uint minLength = length + toOffset;
1692 
1693         // Buffer too small
1694         require(to.length >= minLength); // Should be a better way?
1695 
1696         // NOTE: the offset 32 is added to skip the `size` field of both bytes variables
1697         uint i = 32 + fromOffset;
1698         uint j = 32 + toOffset;
1699 
1700         while (i < (32 + fromOffset + length)) {
1701             assembly {
1702                 let tmp := mload(add(from, i))
1703                 mstore(add(to, j), tmp)
1704             }
1705             i += 32;
1706             j += 32;
1707         }
1708 
1709         return to;
1710     }
1711 
1712     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1713     // Duplicate Solidity's ecrecover, but catching the CALL return value
1714     function safer_ecrecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s) internal returns (bool, address) {
1715         // We do our own memory management here. Solidity uses memory offset
1716         // 0x40 to store the current end of memory. We write past it (as
1717         // writes are memory extensions), but don't update the offset so
1718         // Solidity will reuse it. The memory used here is only needed for
1719         // this context.
1720 
1721         // FIXME: inline assembly can't access return values
1722         bool ret;
1723         address addr;
1724 
1725         assembly {
1726             let size := mload(0x40)
1727             mstore(size, hash)
1728             mstore(add(size, 32), v)
1729             mstore(add(size, 64), r)
1730             mstore(add(size, 96), s)
1731 
1732             // NOTE: we can reuse the request memory because we deal with
1733             //       the return code
1734             ret := call(3000, 1, 0, size, 128, size, 32)
1735             addr := mload(size)
1736         }
1737 
1738         return (ret, addr);
1739     }
1740 
1741     // the following function has been written by Alex Beregszaszi (@axic), use it under the terms of the MIT license
1742     function ecrecovery(bytes32 hash, bytes sig) internal returns (bool, address) {
1743         bytes32 r;
1744         bytes32 s;
1745         uint8 v;
1746 
1747         if (sig.length != 65)
1748           return (false, 0);
1749 
1750         // The signature format is a compact form of:
1751         //   {bytes32 r}{bytes32 s}{uint8 v}
1752         // Compact means, uint8 is not padded to 32 bytes.
1753         assembly {
1754             r := mload(add(sig, 32))
1755             s := mload(add(sig, 64))
1756 
1757             // Here we are loading the last 32 bytes. We exploit the fact that
1758             // 'mload' will pad with zeroes if we overread.
1759             // There is no 'mload8' to do this, but that would be nicer.
1760             v := byte(0, mload(add(sig, 96)))
1761 
1762             // Alternative solution:
1763             // 'byte' is not working due to the Solidity parser, so lets
1764             // use the second best option, 'and'
1765             // v := and(mload(add(sig, 65)), 255)
1766         }
1767 
1768         // albeit non-transactional signatures are not specified by the YP, one would expect it
1769         // to match the YP range of [27, 28]
1770         //
1771         // geth uses [0, 1] and some clients have followed. This might change, see:
1772         //  https://github.com/ethereum/go-ethereum/issues/2053
1773         if (v < 27)
1774           v += 27;
1775 
1776         if (v != 27 && v != 28)
1777             return (false, 0);
1778 
1779         return safer_ecrecover(hash, v, r, s);
1780     }
1781 
1782 }
1783 // </ORACLIZE_API>
1784 
1785 // File: contracts/wolfsale.sol
1786 
1787 /*
1788 Copyright (c) 2018 WiseWolf Ltd
1789 Developed by https://adoriasoft.com
1790 */
1791 
1792 pragma solidity ^0.4.23;
1793 
1794 
1795 
1796 
1797 
1798 
1799 
1800 contract WolfSale is usingOraclize, Ownable, RefundVault
1801 {
1802     uint8 public constant decimals = 18;
1803     uint public constant DECIMALS_MULTIPLIER = 10**uint(decimals);
1804 
1805     WOLF public token;
1806     address tokensSaleHolder;
1807 
1808     uint public  ICOstarttime;
1809     uint public  ICOendtime;
1810     
1811     uint public  minimumInvestmentInWei;
1812     uint public  maximumInvestmentInWei;
1813     address saleMainAddress;
1814     address saleSecondAddress;
1815 
1816 
1817 
1818     uint256 public  softcapInTokens;
1819     uint256 public  hardcapInTokens;
1820     
1821     uint256 public totaltokensold = 0;
1822     
1823     uint public USDETH = 683;
1824     uint public PriceOf1000TokensInUSD;
1825     
1826     //RefundVault public vault;
1827     bool public isFinalized = false;
1828     event Finalized();
1829     
1830     event newOraclizeQuery(string description);
1831     event newETHUSDPrice(string price);
1832     
1833     function finalize() public {
1834         require(!isFinalized);
1835         require(ICOendtime < now);
1836         finalization();
1837         emit Finalized();
1838         isFinalized = true;
1839     }
1840   
1841     function depositFunds() internal {
1842         vault_deposit(msg.sender, msg.value * 70 / 100);
1843     }
1844     
1845     // if crowdsale is unsuccessful, investors can claim refunds here
1846     function claimRefund() public {
1847         require(isFinalized);
1848         require(!goalReached());
1849         
1850         uint256 refundedTokens = token.balanceOf(msg.sender);
1851         require(token.transferFrom(msg.sender, tokensSaleHolder, refundedTokens));
1852         totaltokensold = totaltokensold.sub(refundedTokens);
1853 
1854         vault_refund(msg.sender);
1855     }
1856     
1857     // vault finalization task, called when owner calls finalize()
1858     function finalization() internal {
1859         if (goalReached()) {
1860             vault_releaseDeposit();
1861         } else {
1862             vault_enableRefunds();
1863             
1864         }
1865     }
1866     
1867     function releaseUnclaimedFunds() onlyOwner public {
1868         require(vault_state == State.Refunding && now >= refundDeadline);
1869         vault_releaseDeposit();
1870     }
1871 
1872     function goalReached() public view returns (bool) {
1873         return totaltokensold >= softcapInTokens;
1874     }    
1875     
1876     function __callback(bytes32 /* myid */, string result) public {
1877         require (msg.sender == oraclize_cbAddress());
1878 
1879         emit newETHUSDPrice(result);
1880 
1881         USDETH = parseInt(result, 0);
1882         if ((now < ICOendtime) && (totaltokensold < hardcapInTokens))
1883         {
1884             UpdateUSDETHPriceAfter(day); //update every 24 hours
1885         }
1886         
1887     }
1888     
1889 
1890   function UpdateUSDETHPriceAfter (uint delay) private {
1891       
1892     emit newOraclizeQuery("Update of USD/ETH price requested");
1893     oraclize_query(delay, "URL", "json(https://api.etherscan.io/api?module=stats&action=ethprice&apikey=YourApiKeyToken).result.ethusd");
1894        
1895   }
1896 
1897 
1898   
1899 
1900   constructor (address _tokenContract, address _tokensSaleHolder,
1901                 address _saleMainAddress, address _saleSecondAddress,
1902                 uint _ICOstarttime, uint _ICOendtime,
1903                 uint _minimumInvestment, uint _maximumInvestment, uint _PriceOf1000TokensInUSD,
1904                 uint256 _softcapInTokens, uint256 _hardcapInTokens) public payable {
1905                     
1906     token = WOLF(_tokenContract);
1907     tokensSaleHolder = _tokensSaleHolder;
1908 
1909     saleMainAddress = _saleMainAddress; /* 0x7CC8DD8F0E62Bb793D072D291134d2cC164AaBb6 */
1910     saleSecondAddress = _saleSecondAddress; /* 0x3597a7FacD5061F903309E911f2a6E534460b281 */
1911     vault_wallet = saleMainAddress;
1912     
1913     ICOstarttime = _ICOstarttime;
1914     ICOendtime = _ICOendtime;
1915 
1916     minimumInvestmentInWei = _minimumInvestment;
1917     maximumInvestmentInWei = _maximumInvestment;
1918     PriceOf1000TokensInUSD = _PriceOf1000TokensInUSD;
1919 
1920     softcapInTokens = _softcapInTokens;
1921     hardcapInTokens = _hardcapInTokens;
1922     
1923     UpdateUSDETHPriceAfter(0);
1924   }
1925   
1926   function RefillOraclize() public payable onlyOwner {
1927       UpdateUSDETHPriceAfter(0);
1928   }
1929 
1930   function  RedeemOraclize ( uint _amount) public onlyOwner {
1931       require(address(this).balance > _amount);
1932       owner.transfer(_amount);
1933   } 
1934 
1935   
1936 
1937   function () public payable {
1938        if (msg.sender != owner) {
1939           buy();
1940        }
1941   }
1942   
1943   function ICOactive() public view returns (bool success) {
1944       if (ICOstarttime < now && now < ICOendtime && totaltokensold < hardcapInTokens) {
1945           return true;
1946       }
1947       
1948       return false;
1949   }
1950   
1951   function buy() internal {
1952       
1953       require (msg.value >= minimumInvestmentInWei && msg.value <= maximumInvestmentInWei);
1954       require (ICOactive());
1955       
1956       uint256 NumberOfTokensToGive = msg.value.mul(USDETH).mul(1000).div(PriceOf1000TokensInUSD);
1957      
1958       if(now <= ICOstarttime + week) {
1959 
1960           NumberOfTokensToGive = NumberOfTokensToGive.mul(120).div(100);
1961 
1962       } else if(now <= ICOstarttime + 2*week){
1963           
1964           NumberOfTokensToGive = NumberOfTokensToGive.mul(115).div(100);
1965       
1966       } else if(now <= ICOstarttime + 3*week){
1967           
1968           NumberOfTokensToGive = NumberOfTokensToGive.mul(110).div(100);
1969           
1970       } else if(now <= ICOstarttime + 4*week){
1971 
1972           NumberOfTokensToGive = NumberOfTokensToGive.mul(105).div(100);
1973       }
1974       
1975       uint256 localTotaltokensold = totaltokensold;
1976       require(localTotaltokensold + NumberOfTokensToGive <= hardcapInTokens);
1977       totaltokensold = localTotaltokensold.add(NumberOfTokensToGive);
1978       
1979       require(token.transferFrom(tokensSaleHolder, msg.sender, NumberOfTokensToGive));
1980 
1981       saleSecondAddress.transfer(msg.value * 30 / 100);
1982       
1983       if(!goalReached() && (RefundVault.State.Active == vault_state)) {
1984           depositFunds();
1985       } else {
1986           if(RefundVault.State.Active == vault_state) { vault_releaseDeposit(); }
1987           saleMainAddress.transfer(msg.value * 70 / 100);
1988       }
1989   }
1990 }