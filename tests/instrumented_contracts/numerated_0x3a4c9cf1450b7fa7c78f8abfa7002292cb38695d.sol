1 pragma solidity ^0.4.24;
2 
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/20
7  */
8 interface IERC20 {
9   function totalSupply() external view returns (uint256);
10 
11   function balanceOf(address who) external view returns (uint256);
12 
13   function allowance(address owner, address spender)
14     external view returns (uint256);
15 
16   function transfer(address to, uint256 value) external returns (bool);
17 
18   function approve(address spender, uint256 value)
19     external returns (bool);
20 
21   function transferFrom(address from, address to, uint256 value)
22     external returns (bool);
23 
24   event Transfer(
25     address indexed from,
26     address indexed to,
27     uint256 value
28   );
29 
30   event Approval(
31     address indexed owner,
32     address indexed spender,
33     uint256 value
34   );
35 }
36 
37 
38 /**
39  * @title SafeMath
40  * @dev Math operations with safety checks that revert on error
41  */
42 library SafeMath {
43 
44   /**
45   * @dev Multiplies two numbers, reverts on overflow.
46   */
47   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
48     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
49     // benefit is lost if 'b' is also tested.
50     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
51     if (_a == 0) {
52       return 0;
53     }
54 
55     uint256 c = _a * _b;
56     require(c / _a == _b);
57 
58     return c;
59   }
60 
61   /**
62   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
63   */
64   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
65     require(_b > 0); // Solidity only automatically asserts when dividing by 0
66     uint256 c = _a / _b;
67     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
68 
69     return c;
70   }
71 
72   /**
73   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
74   */
75   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
76     require(_b <= _a);
77     uint256 c = _a - _b;
78 
79     return c;
80   }
81 
82   /**
83   * @dev Adds two numbers, reverts on overflow.
84   */
85   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
86     uint256 c = _a + _b;
87     require(c >= _a);
88 
89     return c;
90   }
91 
92 }
93 
94 /**
95  * @title Ownable
96  * @dev The Ownable contract has an owner address, and provides basic authorization control
97  * functions, this simplifies the implementation of "user permissions".
98  */
99 contract Ownable {
100   address public owner;
101 
102 
103   event OwnershipRenounced(address indexed previousOwner);
104   event OwnershipTransferred(
105     address indexed previousOwner,
106     address indexed newOwner
107   );
108 
109 
110   /**
111    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
112    * account.
113    */
114   constructor() public {
115     owner = msg.sender;
116   }
117 
118   /**
119    * @dev Throws if called by any account other than the owner.
120    */
121   modifier onlyOwner() {
122     require(msg.sender == owner);
123     _;
124   }
125 
126   /**
127    * @dev Allows the current owner to relinquish control of the contract.
128    * @notice Renouncing to ownership will leave the contract without an owner.
129    * It will not be possible to call the functions with the `onlyOwner`
130    * modifier anymore.
131    */
132   function renounceOwnership() public onlyOwner {
133     emit OwnershipRenounced(owner);
134     owner = address(0);
135   }
136 
137   /**
138    * @dev Allows the current owner to transfer control of the contract to a newOwner.
139    * @param _newOwner The address to transfer ownership to.
140    */
141   function transferOwnership(address _newOwner) public onlyOwner {
142     require(_newOwner != address(0));
143     emit OwnershipTransferred(owner, _newOwner);
144     owner = _newOwner;
145   }
146 }
147 
148 
149 /**
150  * This smart contract code is proposed by TokenMarket Ltd. For more information see https://tokenmarket.net
151  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
152  */
153 
154 /**
155  * Upgrade agent interface inspired by Lunyr.
156  *
157  * Upgrade agent transfers tokens to a new contract.
158  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
159  */
160 contract UpgradeAgent {
161 
162   uint public originalSupply;
163 
164   /** Interface marker */
165   function isUpgradeAgent() public pure returns (bool) {
166     return true;
167   }
168 
169   function upgradeFrom(address _from, uint256 _value) public;
170 
171 }
172 
173 /**
174  * @title Standard ERC20 token
175  *
176  * @dev Implementation of the basic standard token.
177  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
178  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
179  */
180 contract StandardToken is IERC20 {
181   using SafeMath for uint256;
182 
183   mapping (address => uint256) private _balances;
184 
185   mapping (address => mapping (address => uint256)) private _allowed;
186 
187   uint256 private _totalSupply;
188 
189   /**
190   * @dev Total number of tokens in existence
191   */
192   function totalSupply() public view returns (uint256) {
193     return _totalSupply;
194   }
195 
196   /**
197   * @dev Gets the balance of the specified address.
198   * @param owner The address to query the balance of.
199   * @return An uint256 representing the amount owned by the passed address.
200   */
201   function balanceOf(address owner) public view returns (uint256) {
202     return _balances[owner];
203   }
204 
205   /**
206    * @dev Function to check the amount of tokens that an owner allowed to a spender.
207    * @param owner address The address which owns the funds.
208    * @param spender address The address which will spend the funds.
209    * @return A uint256 specifying the amount of tokens still available for the spender.
210    */
211   function allowance(
212     address owner,
213     address spender
214    )
215     public
216     view
217     returns (uint256)
218   {
219     return _allowed[owner][spender];
220   }
221 
222   /**
223   * @dev Transfer token for a specified address
224   * @param to The address to transfer to.
225   * @param value The amount to be transferred.
226   */
227   function transfer(address to, uint256 value) public returns (bool) {
228     _transfer(msg.sender, to, value);
229     return true;
230   }
231 
232   /**
233    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
234    * Beware that changing an allowance with this method brings the risk that someone may use both the old
235    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
236    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
237    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238    * @param spender The address which will spend the funds.
239    * @param value The amount of tokens to be spent.
240    */
241   function approve(address spender, uint256 value) public returns (bool) {
242     require(spender != address(0));
243 
244     _allowed[msg.sender][spender] = value;
245     emit Approval(msg.sender, spender, value);
246     return true;
247   }
248 
249   /**
250    * @dev Transfer tokens from one address to another
251    * @param from address The address which you want to send tokens from
252    * @param to address The address which you want to transfer to
253    * @param value uint256 the amount of tokens to be transferred
254    */
255   function transferFrom(
256     address from,
257     address to,
258     uint256 value
259   )
260     public
261     returns (bool)
262   {
263     _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
264     _transfer(from, to, value);
265     return true;
266   }
267 
268   /**
269    * @dev Increase the amount of tokens that an owner allowed to a spender.
270    * approve should be called when allowed_[_spender] == 0. To increment
271    * allowed value is better to use this function to avoid 2 calls (and wait until
272    * the first transaction is mined)
273    * From MonolithDAO Token.sol
274    * @param spender The address which will spend the funds.
275    * @param addedValue The amount of tokens to increase the allowance by.
276    */
277   function increaseAllowance(
278     address spender,
279     uint256 addedValue
280   )
281     public
282     returns (bool)
283   {
284     require(spender != address(0));
285 
286     _allowed[msg.sender][spender] = (
287       _allowed[msg.sender][spender].add(addedValue));
288     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
289     return true;
290   }
291 
292   /**
293    * @dev Decrease the amount of tokens that an owner allowed to a spender.
294    * approve should be called when allowed_[_spender] == 0. To decrement
295    * allowed value is better to use this function to avoid 2 calls (and wait until
296    * the first transaction is mined)
297    * From MonolithDAO Token.sol
298    * @param spender The address which will spend the funds.
299    * @param subtractedValue The amount of tokens to decrease the allowance by.
300    */
301   function decreaseAllowance(
302     address spender,
303     uint256 subtractedValue
304   )
305     public
306     returns (bool)
307   {
308     require(spender != address(0));
309 
310     _allowed[msg.sender][spender] = (
311       _allowed[msg.sender][spender].sub(subtractedValue));
312     emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
313     return true;
314   }
315 
316   /**
317   * @dev Transfer token for a specified addresses
318   * @param from The address to transfer from.
319   * @param to The address to transfer to.
320   * @param value The amount to be transferred.
321   */
322   function _transfer(address from, address to, uint256 value) internal {
323     require(to != address(0));
324 
325     _balances[from] = _balances[from].sub(value);
326     _balances[to] = _balances[to].add(value);
327     emit Transfer(from, to, value);
328   }
329 
330   /**
331    * @dev Internal function that mints an amount of the token and assigns it to
332    * an account. This encapsulates the modification of balances such that the
333    * proper events are emitted.
334    * @param account The account that will receive the created tokens.
335    * @param value The amount that will be created.
336    */
337   function _mint(address account, uint256 value) internal {
338     require(account != address(0));
339 
340     _totalSupply = _totalSupply.add(value);
341     _balances[account] = _balances[account].add(value);
342     emit Transfer(address(0), account, value);
343   }
344 
345   /**
346    * @dev Internal function that burns an amount of the token of a given
347    * account.
348    * @param account The account whose tokens will be burnt.
349    * @param value The amount that will be burnt.
350    */
351   function _burn(address account, uint256 value) internal {
352     require(account != address(0));
353 
354     _totalSupply = _totalSupply.sub(value);
355     _balances[account] = _balances[account].sub(value);
356     emit Transfer(account, address(0), value);
357   }
358   
359 }
360 
361 contract Recoverable is Ownable {
362 
363   /// @dev Empty constructor (for now)
364   constructor() public {
365   }
366 
367   /// @dev This will be invoked by the owner, when owner wants to rescue tokens
368   /// @param token Token which will we rescue to the owner from the contract
369   function recoverTokens(IERC20 token) onlyOwner public {
370     token.transfer(owner, tokensToBeReturned(token));
371   }
372 
373   /// @dev Interface function, can be overwritten by the superclass
374   /// @param token Token which balance we will check and return
375   /// @return The amount of tokens (in smallest denominator) the contract owns
376   function tokensToBeReturned(IERC20 token) public view returns (uint) {
377     return token.balanceOf(this);
378   }
379 }
380 
381 /**
382  * @title Burnable Token
383  * @dev Token that can be irreversibly burned (destroyed).
384  */
385 contract BurnableToken is StandardToken, Ownable {
386 
387   event BurningAgentAdded(address indexed account);
388   event BurningAgentRemoved(address indexed account);
389   
390   
391   /* special burning agents */
392   mapping (address => bool) public isBurningAgent;
393   
394   /**
395    * limit burning by only special agents
396    */
397   modifier canBurn() {
398     require(isBurningAgent[msg.sender]);
399     _;
400   }
401   
402   /**
403    * function to add or remove burning agent
404    */
405   function setBurningAgent(address _address, bool _status) public onlyOwner {
406     require(_address != address(0));
407     isBurningAgent[_address] = _status;
408     if(_status) {
409         emit BurningAgentAdded(_address);
410     } else {
411         emit BurningAgentRemoved(_address);
412     }
413   }
414   
415   /**
416    * @dev Burns a specific amount of tokens.
417    * @param _value The amount of token to be burned.
418    */
419   function burn(
420       uint256 _value
421   ) 
422     public 
423     canBurn
424     returns (bool)
425   {
426     _burn(msg.sender, _value);
427     return true;
428   }
429   
430 }
431 
432 
433 /**
434  * @title Mintable Token
435  * @dev Token that can be  minted (created).
436  */
437 contract MintableToken is StandardToken, Ownable {
438 
439   event MinterAdded(address indexed account);
440   event MinterRemoved(address indexed account);
441 
442   uint256 mintLockPeriod = 1575158399; // 30 Nov. 2019, 23:59:59 GMT
443 
444   /* special minting agents */
445   mapping (address => bool) public isMinter;
446   
447   /**
448    * limit minting by only special agents
449    */
450   modifier canMint() {
451     require(isMinter[msg.sender]);
452     _;
453   }
454   
455   /**
456    * function to add or remove minting agent
457    */
458   function setMintingAgent(address _address, bool _status) public onlyOwner {
459     require(_address != address(0));
460     //one more condition can be added which makes sure set address can be a contract only
461     isMinter[_address] = _status;
462     if(_status) {
463         emit MinterAdded(_address);
464     } else {
465         emit MinterRemoved(_address);
466     }
467   }
468 
469   /**
470    * @dev Function to mint tokens
471    * @param _to The address that will receive the minted tokens.
472    * @param _value The amount of tokens to mint.
473    * @return A boolean that indicates if the operation was successful.
474    */
475   function mint(
476     address _to,
477     uint256 _value
478   )
479     public
480     canMint
481     returns (bool)
482   {
483     require(block.timestamp > mintLockPeriod);
484     _mint(_to, _value);
485     return true;
486   }
487 }
488 
489 
490 /**
491  * @title Pausable
492  * @dev Base contract which allows children to implement an emergency stop mechanism.
493  */
494 contract Pausable is Ownable {
495   event Paused();
496   event Unpaused();
497 
498   bool public paused = false;
499 
500 
501   /**
502    * @dev Modifier to make a function callable only when the contract is not paused.
503    */
504   modifier whenNotPaused() {
505     require(!paused);
506     _;
507   }
508 
509   /**
510    * @dev Modifier to make a function callable only when the contract is paused.
511    */
512   modifier whenPaused() {
513     require(paused);
514     _;
515   }
516 
517   /**
518    * @dev called by the owner to pause, triggers stopped state
519    */
520   function pause() public onlyOwner whenNotPaused {
521     paused = true;
522     emit Paused();
523   }
524 
525   /**
526    * @dev called by the owner to unpause, returns to normal state
527    */
528   function unpause() public onlyOwner whenPaused {
529     paused = false;
530     emit Unpaused();
531   }
532 }
533 
534 
535 
536 /**
537  * @title Pausable token
538  * @dev StandardToken modified with pausable transfers.
539  **/
540 contract PausableToken is StandardToken, Pausable {
541 
542   function transfer(
543     address to,
544     uint256 value
545   )
546     public
547     whenNotPaused
548     returns (bool)
549   {
550     return super.transfer(to, value);
551   }
552 
553   function transferFrom(
554     address from,
555     address to,
556     uint256 value
557   )
558     public
559     whenNotPaused
560     returns (bool)
561   {
562     return super.transferFrom(from, to, value);
563   }
564 
565   function approve(
566     address spender,
567     uint256 value
568   )
569     public
570     whenNotPaused
571     returns (bool)
572   {
573     return super.approve(spender, value);
574   }
575 
576   function increaseAllowance(
577     address spender,
578     uint addedValue
579   )
580     public
581     whenNotPaused
582     returns (bool success)
583   {
584     return super.increaseAllowance(spender, addedValue);
585   }
586 
587   function decreaseAllowance(
588     address spender,
589     uint subtractedValue
590   )
591     public
592     whenNotPaused
593     returns (bool success)
594   {
595     return super.decreaseAllowance(spender, subtractedValue);
596   }
597 }
598 
599 /**
600  * This smart contract code iwas written by tokenmarket.net
601  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
602  * Define interface for releasing the token transfer after a successful crowdsale.
603  */
604 contract ReleasableToken is StandardToken, Ownable {
605 
606   /* The finalizer contract that allows unlift the transfer limits on this token */
607   address public releaseAgent;
608 
609   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
610   bool public released = false;
611 
612   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
613   mapping (address => bool) public transferAgents;
614 
615   /**
616    * Limit token transfer until the crowdsale is over.
617    *
618    */
619   modifier canTransfer(address _sender) {
620 
621     if(!released) {
622         if(!transferAgents[_sender]) {
623             revert();
624         }
625     }
626 
627     _;
628   }
629   
630   // setting release agent as Owner
631   constructor() public {
632       releaseAgent = msg.sender;
633   }
634 
635   /**
636    * Set the contract that can call release and make the token transferable.
637    *
638    * Design choice. Allow reset the release agent to fix fat finger mistakes.
639    */
640   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
641 
642     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
643     releaseAgent = addr;
644   }
645 
646   /**
647    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
648    */
649   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
650     transferAgents[addr] = state;
651   }
652 
653   /**
654    * One way function to release the tokens to the wild.
655    *
656    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
657    */
658   function releaseTokenTransfer() public onlyReleaseAgent {
659     released = true;
660   }
661 
662   /** The function can be called only before or after the tokens have been releasesd */
663   modifier inReleaseState(bool releaseState) {
664     if(releaseState != released) {
665         revert();
666     }
667     _;
668   }
669 
670   /** The function can be called only by a whitelisted release agent. */
671   modifier onlyReleaseAgent() {
672     if(msg.sender != releaseAgent) {
673         revert();
674     }
675     _;
676   }
677 
678   function transfer(address _to, uint _value) canTransfer(msg.sender) public returns (bool success) {
679     // Call StandardToken.transfer()
680    return super.transfer(_to, _value);
681   }
682 
683   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) public returns (bool success) {
684     // Call StandardToken.transferForm()
685     return super.transferFrom(_from, _to, _value);
686   }
687 
688 }
689 
690 
691 /**
692  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
693  *
694  * First envisioned by Golem and Lunyr projects.
695  */
696 contract UpgradeableToken is StandardToken {
697 
698   using SafeMath for uint;
699   
700   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
701   address public upgradeMaster;
702 
703   /** The next contract where the tokens will be migrated. */
704   UpgradeAgent public upgradeAgent;
705 
706   /** How many tokens we have upgraded by now. */
707   uint256 public totalUpgraded;
708 
709   /**
710    * Upgrade states.
711    *
712    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
713    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
714    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
715    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
716    *
717    */
718   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
719 
720   /**
721    * Somebody has upgraded some of his tokens.
722    */
723   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
724 
725   /**
726    * New upgrade agent available.
727    */
728   event UpgradeAgentSet(address agent);
729 
730   /**
731    * Do not allow construction without upgrade master set.
732    */
733   constructor() public {
734     upgradeMaster = msg.sender;
735   }
736 
737   /**
738    * Allow the token holder to upgrade some of their tokens to a new contract.
739    */
740   function upgrade(uint256 value) public {
741     UpgradeState state = getUpgradeState();
742     require((state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading));
743 
744     // Validate input value.
745     require (value != 0);
746     
747     //burn the token and reduce the supply
748     _burn(msg.sender, value);
749 
750     totalUpgraded = totalUpgraded.add(value);
751 
752     // Upgrade agent reissues the tokens
753     upgradeAgent.upgradeFrom(msg.sender, value);
754     emit Upgrade(msg.sender, upgradeAgent, value);
755   }
756 
757   /**
758    * Set an upgrade agent that handles
759    */
760   function setUpgradeAgent(address agent) external {
761     require(canUpgrade());
762 
763     require(agent != address(0));
764     // Only a master can designate the next agent
765     require(msg.sender == upgradeMaster);
766     // Upgrade has already begun for an agent
767     require(getUpgradeState() != UpgradeState.Upgrading);
768 
769     upgradeAgent = UpgradeAgent(agent);
770 
771     // Bad interface
772     require(upgradeAgent.isUpgradeAgent());
773     // Make sure that token supplies match in source and target
774     require(upgradeAgent.originalSupply() == totalSupply());
775 
776     emit UpgradeAgentSet(upgradeAgent);
777   }
778 
779   /**
780    * Get the state of the token upgrade.
781    */
782   function getUpgradeState() public constant returns(UpgradeState) {
783     if(!canUpgrade()) return UpgradeState.NotAllowed;
784     else if(address(upgradeAgent) == address(0)) return UpgradeState.WaitingForAgent;
785     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
786     else return UpgradeState.Upgrading;
787   }
788 
789   /**
790    * Change the upgrade master.
791    *
792    * This allows us to set a new owner for the upgrade mechanism.
793    */
794   function setUpgradeMaster(address master) public {
795     require(master != 0x0);
796     require(msg.sender == upgradeMaster);
797     upgradeMaster = master;
798   }
799 
800   /**
801    * Child contract can enable to provide the condition when the upgrade can begun.
802    */
803   function canUpgrade() public pure returns(bool) {
804      return true;
805   }
806 
807 }
808 
809 
810 /**
811  * TrustEdToken smart contract.
812  *
813  * We mix in recoverable, releasable, pausable, burnable, mintable and upgradeable traits.
814  *
815  * Token supply is created in the token contract creation and allocated to owner.
816  * The owner can then transfer from its supply to crowdsale participants.
817  * The owner, or anybody, can burn any excessive tokens they are holding.
818  *
819  */
820 contract TrustEdToken is ReleasableToken, PausableToken, Recoverable, BurnableToken, UpgradeableToken, MintableToken {
821 
822   // Token meta information
823   string public name;
824   string public symbol;
825   uint256 public decimals;
826   
827   uint256 TOTAL_SUPPLY;
828 
829   /** Name and symbol were updated. */
830   event UpdatedTokenInformation(string newName, string newSymbol);
831 
832   constructor() public {
833     name = "TrustEd Token";
834     symbol = "TED";
835     decimals = 18;
836     
837     TOTAL_SUPPLY = 1720000000 * (10**decimals); //1.72 billion total supply
838     _mint(msg.sender, TOTAL_SUPPLY);
839 
840   }
841 
842   /**
843    * Owner can update token information here.
844    *
845    * It is often useful to conceal the actual token association, until
846    * the token operations, like central issuance or reissuance have been completed.
847    * In this case the initial token can be supplied with empty name and symbol information.
848    *
849    * This function allows the token owner to rename the token after the operations
850    * have been completed and then point the audience to use the token contract.
851    */
852   function setTokenInformation(string _name, string _symbol) onlyOwner external{
853     name = _name;
854     symbol = _symbol;
855     emit UpdatedTokenInformation(name, symbol);
856   }
857 
858 }