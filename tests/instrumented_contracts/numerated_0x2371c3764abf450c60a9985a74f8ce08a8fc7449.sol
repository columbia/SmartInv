1 // File: zeppelin-solidity/contracts/ownership/Ownable.sol
2 
3 pragma solidity ^0.4.24;
4 
5 
6 /**
7  * @title Ownable
8  * @dev The Ownable contract has an owner address, and provides basic authorization control
9  * functions, this simplifies the implementation of "user permissions".
10  */
11 contract Ownable {
12   address public owner;
13 
14 
15   event OwnershipRenounced(address indexed previousOwner);
16   event OwnershipTransferred(
17     address indexed previousOwner,
18     address indexed newOwner
19   );
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
39    * @dev Allows the current owner to relinquish control of the contract.
40    * @notice Renouncing to ownership will leave the contract without an owner.
41    * It will not be possible to call the functions with the `onlyOwner`
42    * modifier anymore.
43    */
44   function renounceOwnership() public onlyOwner {
45     emit OwnershipRenounced(owner);
46     owner = address(0);
47   }
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param _newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address _newOwner) public onlyOwner {
54     _transferOwnership(_newOwner);
55   }
56 
57   /**
58    * @dev Transfers control of the contract to a newOwner.
59    * @param _newOwner The address to transfer ownership to.
60    */
61   function _transferOwnership(address _newOwner) internal {
62     require(_newOwner != address(0));
63     emit OwnershipTransferred(owner, _newOwner);
64     owner = _newOwner;
65   }
66 }
67 
68 // File: zeppelin-solidity/contracts/lifecycle/Destructible.sol
69 
70 pragma solidity ^0.4.24;
71 
72 
73 
74 /**
75  * @title Destructible
76  * @dev Base contract that can be destroyed by owner. All funds in contract will be sent to the owner.
77  */
78 contract Destructible is Ownable {
79   /**
80    * @dev Transfers the current balance to the owner and terminates the contract.
81    */
82   function destroy() public onlyOwner {
83     selfdestruct(owner);
84   }
85 
86   function destroyAndSend(address _recipient) public onlyOwner {
87     selfdestruct(_recipient);
88   }
89 }
90 
91 // File: zeppelin-solidity/contracts/token/ERC20/ERC20Basic.sol
92 
93 pragma solidity ^0.4.24;
94 
95 
96 /**
97  * @title ERC20Basic
98  * @dev Simpler version of ERC20 interface
99  * See https://github.com/ethereum/EIPs/issues/179
100  */
101 contract ERC20Basic {
102   function totalSupply() public view returns (uint256);
103   function balanceOf(address _who) public view returns (uint256);
104   function transfer(address _to, uint256 _value) public returns (bool);
105   event Transfer(address indexed from, address indexed to, uint256 value);
106 }
107 
108 // File: zeppelin-solidity/contracts/math/SafeMath.sol
109 
110 pragma solidity ^0.4.24;
111 
112 
113 /**
114  * @title SafeMath
115  * @dev Math operations with safety checks that throw on error
116  */
117 library SafeMath {
118 
119   /**
120   * @dev Multiplies two numbers, throws on overflow.
121   */
122   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
123     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
124     // benefit is lost if 'b' is also tested.
125     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
126     if (_a == 0) {
127       return 0;
128     }
129 
130     c = _a * _b;
131     assert(c / _a == _b);
132     return c;
133   }
134 
135   /**
136   * @dev Integer division of two numbers, truncating the quotient.
137   */
138   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
139     // assert(_b > 0); // Solidity automatically throws when dividing by 0
140     // uint256 c = _a / _b;
141     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
142     return _a / _b;
143   }
144 
145   /**
146   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
147   */
148   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
149     assert(_b <= _a);
150     return _a - _b;
151   }
152 
153   /**
154   * @dev Adds two numbers, throws on overflow.
155   */
156   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
157     c = _a + _b;
158     assert(c >= _a);
159     return c;
160   }
161 }
162 
163 // File: zeppelin-solidity/contracts/token/ERC20/BasicToken.sol
164 
165 pragma solidity ^0.4.24;
166 
167 
168 
169 
170 /**
171  * @title Basic token
172  * @dev Basic version of StandardToken, with no allowances.
173  */
174 contract BasicToken is ERC20Basic {
175   using SafeMath for uint256;
176 
177   mapping(address => uint256) internal balances;
178 
179   uint256 internal totalSupply_;
180 
181   /**
182   * @dev Total number of tokens in existence
183   */
184   function totalSupply() public view returns (uint256) {
185     return totalSupply_;
186   }
187 
188   /**
189   * @dev Transfer token for a specified address
190   * @param _to The address to transfer to.
191   * @param _value The amount to be transferred.
192   */
193   function transfer(address _to, uint256 _value) public returns (bool) {
194     require(_value <= balances[msg.sender]);
195     require(_to != address(0));
196 
197     balances[msg.sender] = balances[msg.sender].sub(_value);
198     balances[_to] = balances[_to].add(_value);
199     emit Transfer(msg.sender, _to, _value);
200     return true;
201   }
202 
203   /**
204   * @dev Gets the balance of the specified address.
205   * @param _owner The address to query the the balance of.
206   * @return An uint256 representing the amount owned by the passed address.
207   */
208   function balanceOf(address _owner) public view returns (uint256) {
209     return balances[_owner];
210   }
211 
212 }
213 
214 // File: zeppelin-solidity/contracts/token/ERC20/ERC20.sol
215 
216 pragma solidity ^0.4.24;
217 
218 
219 
220 /**
221  * @title ERC20 interface
222  * @dev see https://github.com/ethereum/EIPs/issues/20
223  */
224 contract ERC20 is ERC20Basic {
225   function allowance(address _owner, address _spender)
226     public view returns (uint256);
227 
228   function transferFrom(address _from, address _to, uint256 _value)
229     public returns (bool);
230 
231   function approve(address _spender, uint256 _value) public returns (bool);
232   event Approval(
233     address indexed owner,
234     address indexed spender,
235     uint256 value
236   );
237 }
238 
239 // File: zeppelin-solidity/contracts/token/ERC20/StandardToken.sol
240 
241 pragma solidity ^0.4.24;
242 
243 
244 
245 
246 /**
247  * @title Standard ERC20 token
248  *
249  * @dev Implementation of the basic standard token.
250  * https://github.com/ethereum/EIPs/issues/20
251  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
252  */
253 contract StandardToken is ERC20, BasicToken {
254 
255   mapping (address => mapping (address => uint256)) internal allowed;
256 
257 
258   /**
259    * @dev Transfer tokens from one address to another
260    * @param _from address The address which you want to send tokens from
261    * @param _to address The address which you want to transfer to
262    * @param _value uint256 the amount of tokens to be transferred
263    */
264   function transferFrom(
265     address _from,
266     address _to,
267     uint256 _value
268   )
269     public
270     returns (bool)
271   {
272     require(_value <= balances[_from]);
273     require(_value <= allowed[_from][msg.sender]);
274     require(_to != address(0));
275 
276     balances[_from] = balances[_from].sub(_value);
277     balances[_to] = balances[_to].add(_value);
278     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
279     emit Transfer(_from, _to, _value);
280     return true;
281   }
282 
283   /**
284    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
285    * Beware that changing an allowance with this method brings the risk that someone may use both the old
286    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
287    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
288    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
289    * @param _spender The address which will spend the funds.
290    * @param _value The amount of tokens to be spent.
291    */
292   function approve(address _spender, uint256 _value) public returns (bool) {
293     allowed[msg.sender][_spender] = _value;
294     emit Approval(msg.sender, _spender, _value);
295     return true;
296   }
297 
298   /**
299    * @dev Function to check the amount of tokens that an owner allowed to a spender.
300    * @param _owner address The address which owns the funds.
301    * @param _spender address The address which will spend the funds.
302    * @return A uint256 specifying the amount of tokens still available for the spender.
303    */
304   function allowance(
305     address _owner,
306     address _spender
307    )
308     public
309     view
310     returns (uint256)
311   {
312     return allowed[_owner][_spender];
313   }
314 
315   /**
316    * @dev Increase the amount of tokens that an owner allowed to a spender.
317    * approve should be called when allowed[_spender] == 0. To increment
318    * allowed value is better to use this function to avoid 2 calls (and wait until
319    * the first transaction is mined)
320    * From MonolithDAO Token.sol
321    * @param _spender The address which will spend the funds.
322    * @param _addedValue The amount of tokens to increase the allowance by.
323    */
324   function increaseApproval(
325     address _spender,
326     uint256 _addedValue
327   )
328     public
329     returns (bool)
330   {
331     allowed[msg.sender][_spender] = (
332       allowed[msg.sender][_spender].add(_addedValue));
333     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
334     return true;
335   }
336 
337   /**
338    * @dev Decrease the amount of tokens that an owner allowed to a spender.
339    * approve should be called when allowed[_spender] == 0. To decrement
340    * allowed value is better to use this function to avoid 2 calls (and wait until
341    * the first transaction is mined)
342    * From MonolithDAO Token.sol
343    * @param _spender The address which will spend the funds.
344    * @param _subtractedValue The amount of tokens to decrease the allowance by.
345    */
346   function decreaseApproval(
347     address _spender,
348     uint256 _subtractedValue
349   )
350     public
351     returns (bool)
352   {
353     uint256 oldValue = allowed[msg.sender][_spender];
354     if (_subtractedValue >= oldValue) {
355       allowed[msg.sender][_spender] = 0;
356     } else {
357       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
358     }
359     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
360     return true;
361   }
362 
363 }
364 
365 // File: zeppelin-solidity/contracts/lifecycle/Pausable.sol
366 
367 pragma solidity ^0.4.24;
368 
369 
370 
371 /**
372  * @title Pausable
373  * @dev Base contract which allows children to implement an emergency stop mechanism.
374  */
375 contract Pausable is Ownable {
376   event Pause();
377   event Unpause();
378 
379   bool public paused = false;
380 
381 
382   /**
383    * @dev Modifier to make a function callable only when the contract is not paused.
384    */
385   modifier whenNotPaused() {
386     require(!paused);
387     _;
388   }
389 
390   /**
391    * @dev Modifier to make a function callable only when the contract is paused.
392    */
393   modifier whenPaused() {
394     require(paused);
395     _;
396   }
397 
398   /**
399    * @dev called by the owner to pause, triggers stopped state
400    */
401   function pause() public onlyOwner whenNotPaused {
402     paused = true;
403     emit Pause();
404   }
405 
406   /**
407    * @dev called by the owner to unpause, returns to normal state
408    */
409   function unpause() public onlyOwner whenPaused {
410     paused = false;
411     emit Unpause();
412   }
413 }
414 
415 // File: zeppelin-solidity/contracts/token/ERC20/PausableToken.sol
416 
417 pragma solidity ^0.4.24;
418 
419 
420 
421 
422 /**
423  * @title Pausable token
424  * @dev StandardToken modified with pausable transfers.
425  **/
426 contract PausableToken is StandardToken, Pausable {
427 
428   function transfer(
429     address _to,
430     uint256 _value
431   )
432     public
433     whenNotPaused
434     returns (bool)
435   {
436     return super.transfer(_to, _value);
437   }
438 
439   function transferFrom(
440     address _from,
441     address _to,
442     uint256 _value
443   )
444     public
445     whenNotPaused
446     returns (bool)
447   {
448     return super.transferFrom(_from, _to, _value);
449   }
450 
451   function approve(
452     address _spender,
453     uint256 _value
454   )
455     public
456     whenNotPaused
457     returns (bool)
458   {
459     return super.approve(_spender, _value);
460   }
461 
462   function increaseApproval(
463     address _spender,
464     uint _addedValue
465   )
466     public
467     whenNotPaused
468     returns (bool success)
469   {
470     return super.increaseApproval(_spender, _addedValue);
471   }
472 
473   function decreaseApproval(
474     address _spender,
475     uint _subtractedValue
476   )
477     public
478     whenNotPaused
479     returns (bool success)
480   {
481     return super.decreaseApproval(_spender, _subtractedValue);
482   }
483 }
484 
485 // File: zeppelin-solidity/contracts/token/ERC20/DetailedERC20.sol
486 
487 pragma solidity ^0.4.24;
488 
489 
490 
491 /**
492  * @title DetailedERC20 token
493  * @dev The decimals are only for visualization purposes.
494  * All the operations are done using the smallest and indivisible token unit,
495  * just as on Ethereum all the operations are done in wei.
496  */
497 contract DetailedERC20 is ERC20 {
498   string public name;
499   string public symbol;
500   uint8 public decimals;
501 
502   constructor(string _name, string _symbol, uint8 _decimals) public {
503     name = _name;
504     symbol = _symbol;
505     decimals = _decimals;
506   }
507 }
508 
509 // File: zeppelin-solidity/contracts/token/ERC20/MintableToken.sol
510 
511 pragma solidity ^0.4.24;
512 
513 
514 
515 
516 /**
517  * @title Mintable token
518  * @dev Simple ERC20 Token example, with mintable token creation
519  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
520  */
521 contract MintableToken is StandardToken, Ownable {
522   event Mint(address indexed to, uint256 amount);
523   event MintFinished();
524 
525   bool public mintingFinished = false;
526 
527 
528   modifier canMint() {
529     require(!mintingFinished);
530     _;
531   }
532 
533   modifier hasMintPermission() {
534     require(msg.sender == owner);
535     _;
536   }
537 
538   /**
539    * @dev Function to mint tokens
540    * @param _to The address that will receive the minted tokens.
541    * @param _amount The amount of tokens to mint.
542    * @return A boolean that indicates if the operation was successful.
543    */
544   function mint(
545     address _to,
546     uint256 _amount
547   )
548     public
549     hasMintPermission
550     canMint
551     returns (bool)
552   {
553     totalSupply_ = totalSupply_.add(_amount);
554     balances[_to] = balances[_to].add(_amount);
555     emit Mint(_to, _amount);
556     emit Transfer(address(0), _to, _amount);
557     return true;
558   }
559 
560   /**
561    * @dev Function to stop minting new tokens.
562    * @return True if the operation was successful.
563    */
564   function finishMinting() public onlyOwner canMint returns (bool) {
565     mintingFinished = true;
566     emit MintFinished();
567     return true;
568   }
569 }
570 
571 // File: zeppelin-solidity/contracts/token/ERC20/CappedToken.sol
572 
573 pragma solidity ^0.4.24;
574 
575 
576 
577 /**
578  * @title Capped token
579  * @dev Mintable token with a token cap.
580  */
581 contract CappedToken is MintableToken {
582 
583   uint256 public cap;
584 
585   constructor(uint256 _cap) public {
586     require(_cap > 0);
587     cap = _cap;
588   }
589 
590   /**
591    * @dev Function to mint tokens
592    * @param _to The address that will receive the minted tokens.
593    * @param _amount The amount of tokens to mint.
594    * @return A boolean that indicates if the operation was successful.
595    */
596   function mint(
597     address _to,
598     uint256 _amount
599   )
600     public
601     returns (bool)
602   {
603     require(totalSupply_.add(_amount) <= cap);
604 
605     return super.mint(_to, _amount);
606   }
607 
608 }
609 
610 // File: contracts/InsightsNetwork1.sol
611 
612 pragma solidity ^0.4.4;
613 
614 contract InsightsNetwork1 {
615   address public owner; // Creator
616   address public successor; // May deactivate contract
617   mapping (address => uint) public balances;    // Who has what
618   mapping (address => uint) public unlockTimes; // When balances unlock
619   bool public active;
620   uint256 _totalSupply; // Sum of minted tokens
621 
622   string public constant name = "INS";
623   string public constant symbol = "INS";
624   uint8 public constant decimals = 0;
625 
626   function InsightsNetwork1() {
627     owner = msg.sender;
628     active = true;
629   }
630 
631   function register(address newTokenHolder, uint issueAmount) { // Mint tokens and assign to new owner
632     require(active);
633     require(msg.sender == owner);   // Only creator can register
634     require(balances[newTokenHolder] == 0); // Accounts can only be registered once
635 
636     _totalSupply += issueAmount;
637     Mint(newTokenHolder, issueAmount);  // Trigger event
638 
639     require(balances[newTokenHolder] < (balances[newTokenHolder] + issueAmount));   // Overflow check
640     balances[newTokenHolder] += issueAmount;
641     Transfer(address(0), newTokenHolder, issueAmount);  // Trigger event
642 
643     uint currentTime = block.timestamp; // seconds since the Unix epoch
644     uint unlockTime = currentTime + 365*24*60*60; // one year out from the current time
645     assert(unlockTime > currentTime); // check for overflow
646     unlockTimes[newTokenHolder] = unlockTime;
647   }
648 
649   function totalSupply() constant returns (uint256) {   // ERC20 compliance
650     return _totalSupply;
651   }
652 
653   function transfer(address _to, uint256 _value) returns (bool success) {   // ERC20 compliance
654     return false;
655   }
656 
657   function transferFrom(address _from, address _to, uint256 _value) returns (bool success) {    // ERC20 compliance
658     return false;
659   }
660 
661   function approve(address _spender, uint256 _value) returns (bool success) {   // ERC20 compliance
662     return false;
663   }
664 
665   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {   // ERC20 compliance
666     return 0;   // No transfer allowance
667   }
668 
669   function balanceOf(address _owner) constant returns (uint256 balance) {   // ERC20 compliance
670     return balances[_owner];
671   }
672 
673   function getUnlockTime(address _accountHolder) constant returns (uint256) {
674     return unlockTimes[_accountHolder];
675   }
676 
677   event Mint(address indexed _to, uint256 _amount);
678   event Transfer(address indexed _from, address indexed _to, uint256 _value);
679   event Approval(address indexed _owner, address indexed _spender, uint256 _value);
680 
681   function makeSuccessor(address successorAddr) {
682     require(active);
683     require(msg.sender == owner);
684     //require(successorAddr == address(0));
685     successor = successorAddr;
686   }
687 
688   function deactivate() {
689     require(active);
690     require(msg.sender == owner || (successor != address(0) && msg.sender == successor));   // Called by creator or successor
691     active = false;
692   }
693 }
694 
695 // File: contracts/InsightsNetwork2Base.sol
696 
697 pragma solidity ^0.4.18;
698 
699 
700 
701 
702 
703 
704 contract InsightsNetwork2Base is DetailedERC20("Insights Network", "INSTAR", 18), PausableToken, CappedToken{
705 
706     uint256 constant ATTOTOKEN_FACTOR = 10**18;
707 
708     address public predecessor;
709     address public successor;
710 
711     uint constant MAX_LENGTH = 1024;
712     uint constant MAX_PURCHASES = 64;
713     
714     mapping (address => uint256[]) public lockedBalances;
715     mapping (address => uint256[]) public unlockTimes;
716     mapping (address => bool) public imported;
717 
718     event Import(address indexed account, uint256 amount, uint256 unlockTime);    
719 
720     function InsightsNetwork2Base() public CappedToken(300*1000000*ATTOTOKEN_FACTOR) {
721         paused = true;
722         mintingFinished = true;
723     }
724 
725     function activate(address _predecessor) public onlyOwner {
726         require(predecessor == 0);
727         require(_predecessor != 0);
728         require(predecessorDeactivated(_predecessor));
729         predecessor = _predecessor;
730         unpause();
731         mintingFinished = false;
732     }
733 
734     function lockedBalanceOf(address account) public view returns (uint256 balance) {
735         uint256 amount;
736         for (uint256 index = 0; index < lockedBalances[account].length; index++)
737             if (unlockTimes[account][index] > now)
738                 amount += lockedBalances[account][index];
739         return amount;
740     }
741 
742     function mintBatch(address[] accounts, uint256[] amounts) public onlyOwner canMint returns (bool) {
743         require(accounts.length == amounts.length);
744         require(accounts.length <= MAX_LENGTH);
745         for (uint index = 0; index < accounts.length; index++)
746             require(mint(accounts[index], amounts[index]));
747         return true;
748     }
749 
750     function mintUnlockTime(address account, uint256 amount, uint256 unlockTime) public onlyOwner canMint returns (bool) {
751         require(unlockTime > now);
752         require(lockedBalances[account].length < MAX_PURCHASES);
753         lockedBalances[account].push(amount);
754         unlockTimes[account].push(unlockTime);
755         return super.mint(account, amount);
756     }
757 
758     function mintUnlockTimeBatch(address[] accounts, uint256[] amounts, uint256 unlockTime) public onlyOwner canMint returns (bool) {
759         require(accounts.length == amounts.length);
760         require(accounts.length <= MAX_LENGTH);
761         for (uint index = 0; index < accounts.length; index++)
762             require(mintUnlockTime(accounts[index], amounts[index], unlockTime));
763         return true;
764     }
765 
766     function mintLockPeriod(address account, uint256 amount, uint256 lockPeriod) public onlyOwner canMint returns (bool) {
767         return mintUnlockTime(account, amount, now + lockPeriod);
768     }
769 
770     function mintLockPeriodBatch(address[] accounts, uint256[] amounts, uint256 lockPeriod) public onlyOwner canMint returns (bool) {
771         return mintUnlockTimeBatch(accounts, amounts, now + lockPeriod);
772     }
773 
774     function importBalance(address account) public onlyOwner canMint returns (bool);
775 
776     function importBalanceBatch(address[] accounts) public onlyOwner canMint returns (bool) {
777         require(accounts.length <= MAX_LENGTH);
778         for (uint index = 0; index < accounts.length; index++)
779             require(importBalance(accounts[index]));
780         return true;
781     }
782 
783     function transfer(address to, uint256 value) public returns (bool) {
784         require(value <= balances[msg.sender] - lockedBalanceOf(msg.sender));
785         return super.transfer(to, value);
786     }
787 
788     function transferFrom(address from, address to, uint256 value) public returns (bool) {
789         require(value <= balances[from] - lockedBalanceOf(from));
790         return super.transferFrom(from, to, value);
791     }
792 
793     function selfDestruct(address _successor) public onlyOwner whenPaused {
794         require(mintingFinished);
795         successor = _successor;
796         selfdestruct(owner);
797     }
798 
799     function predecessorDeactivated(address _predecessor) internal view onlyOwner returns (bool);
800 
801 }
802 
803 // File: contracts/InsightsNetwork3.sol
804 
805 pragma solidity ^0.4.18;
806 
807 
808 
809 contract InsightsNetwork3 is InsightsNetwork2Base {
810 
811     function importBalance(address account) public onlyOwner canMint returns (bool) {
812         require(!imported[account]);
813         InsightsNetwork2Base source = InsightsNetwork2Base(predecessor);
814         uint256 amount = source.balanceOf(account);
815         require(amount > 0);
816         imported[account] = true;
817         uint256 mintAmount = amount - source.lockedBalanceOf(account);
818         if (mintAmount > 0) {
819             Import(account, mintAmount, now);
820             assert(mint(account, mintAmount));
821             amount -= mintAmount;
822         }
823         for (uint index = 0; amount > 0; index++) {
824             uint256 unlockTime = source.unlockTimes(account, index);
825             if ( unlockTime > now ) {
826                 mintAmount = source.lockedBalances(account, index);
827                 Import(account, mintAmount, unlockTime);
828                 assert(mintUnlockTime(account, mintAmount, unlockTime));
829                 amount -= mintAmount;
830             }
831         }
832         return true;
833     }
834 
835     function predecessorDeactivated(address _predecessor) internal view onlyOwner returns (bool) {
836         return InsightsNetwork2Base(_predecessor).paused() && InsightsNetwork2Base(_predecessor).mintingFinished();
837     }
838 
839 }
840 
841 // File: contracts/InsightsNetworkMigrationToEOS.sol
842 
843 pragma solidity ^0.4.24;
844 
845 
846 
847 
848 contract InsightsNetworkMigrationToEOS is Destructible, Pausable {
849 
850     InsightsNetwork3 public tokenContract;
851 
852     mapping(address => string) public eosPublicKeys;
853     mapping(address => uint256) public changeTime;
854 
855     uint256 public constant gracePeriod = 24 * 60 * 60;
856 
857     event Register(address indexed account);
858     event Reject(address indexed account);
859 
860     constructor(address _tokenContractAddr) public {
861         tokenContract = InsightsNetwork3(_tokenContractAddr);
862         paused = true;
863     }
864 
865     function register(string eosPublicKey) public whenNotPaused {
866         require(tokenContract.balanceOf(msg.sender) > 0);
867 
868         require(bytes(eosPublicKey).length == 53 && bytes(eosPublicKey)[0] == "E" && bytes(eosPublicKey)[1] == "O" && bytes(eosPublicKey)[2] == "S");
869         require(bytes(eosPublicKeys[msg.sender]).length == 0);
870 
871         eosPublicKeys[msg.sender] = eosPublicKey;
872         changeTime[msg.sender] = block.timestamp;
873 
874         emit Register(msg.sender);
875     }
876 
877     function reject() public whenNotPaused {
878         require(bytes(eosPublicKeys[msg.sender]).length > 0);
879         require((changeTime[msg.sender] + gracePeriod) > block.timestamp);
880 
881         delete eosPublicKeys[msg.sender];
882         delete changeTime[msg.sender];
883 
884         emit Reject(msg.sender);
885     }
886 }