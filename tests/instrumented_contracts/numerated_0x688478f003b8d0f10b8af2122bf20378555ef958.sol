1 pragma solidity ^0.4.25;
2 
3 /**
4  * @title ERC20Basic
5  * @dev Simpler version of ERC20 interface
6  * @dev see https://github.com/ethereum/EIPs/issues/179
7  */
8 contract ERC20Basic {
9   function totalSupply() public view returns (uint256);
10   function balanceOf(address who) public view returns (uint256);
11   function transfer(address to, uint256 value) public returns (bool);
12   event Transfer(address indexed from, address indexed to, uint256 value);
13 }
14 
15 
16 /**
17  * @title ERC20 interface
18  * @dev see https://github.com/ethereum/EIPs/issues/20
19  */
20 contract ERC20 is ERC20Basic {
21   function allowance(address owner, address spender)
22     public view returns (uint256);
23 
24   function transferFrom(address from, address to, uint256 value)
25     public returns (bool);
26 
27   function approve(address spender, uint256 value) public returns (bool);
28   event Approval(
29     address indexed owner,
30     address indexed spender,
31     uint256 value
32   );
33 }
34 
35 
36 /**
37  * Safe unsigned safe math.
38  */
39 library SafeMathLib {
40 
41   function times(uint a, uint b) public pure returns (uint) {
42     uint c = a * b;
43     assert(a == 0 || c / a == b);
44     return c;
45   }
46 
47   function minus(uint a, uint b) public pure returns (uint) {
48     assert(b <= a);
49     return a - b;
50   }
51 
52   function plus(uint a, uint b) public pure returns (uint) {
53     uint c = a + b;
54     assert(c>=a);
55     return c;
56   }
57 
58 }
59 
60 
61 /**
62  * @title SafeMath
63  * @dev Math operations with safety checks that throw on error
64  */
65 library SafeMath {
66 
67   /**
68   * @dev Multiplies two numbers, throws on overflow.
69   */
70   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
71     if (a == 0) {
72       return 0;
73     }
74     c = a * b;
75     assert(c / a == b);
76     return c;
77   }
78 
79   /**
80   * @dev Integer division of two numbers, truncating the quotient.
81   */
82   function div(uint256 a, uint256 b) internal pure returns (uint256) {
83     // assert(b > 0); // Solidity automatically throws when dividing by 0
84     // uint256 c = a / b;
85     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
86     return a / b;
87   }
88 
89   /**
90   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
91   */
92   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
93     assert(b <= a);
94     return a - b;
95   }
96 
97   /**
98   * @dev Adds two numbers, throws on overflow.
99   */
100   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
101     c = a + b;
102     assert(c >= a);
103     return c;
104   }
105 }
106 
107 
108 /**
109  * @title Basic token
110  * @dev Basic version of StandardToken, with no allowances.
111  */
112 contract BasicToken is ERC20Basic {
113   using SafeMath for uint256;
114 
115   mapping(address => uint256) balances;
116 
117   uint256 totalSupply_;
118 
119   /**
120   * @dev total number of tokens in existence
121   */
122   function totalSupply() public view returns (uint256) {
123     return totalSupply_;
124   }
125 
126   /**
127   * @dev transfer token for a specified address
128   * @param _to The address to transfer to.
129   * @param _value The amount to be transferred.
130   */
131   function transfer(address _to, uint256 _value) public returns (bool) {
132     require(_to != address(0));
133     require(_value <= balances[msg.sender]);
134 
135     balances[msg.sender] = balances[msg.sender].sub(_value);
136     balances[_to] = balances[_to].add(_value);
137     emit Transfer(msg.sender, _to, _value);
138     return true;
139   }
140 
141   /**
142   * @dev Gets the balance of the specified address.
143   * @param _owner The address to query the the balance of.
144   * @return An uint256 representing the amount owned by the passed address.
145   */
146   function balanceOf(address _owner) public view returns (uint256) {
147     return balances[_owner];
148   }
149 
150 }
151 
152 
153 /**
154  * @title Standard ERC20 token
155  *
156  * @dev Implementation of the basic standard token.
157  * @dev https://github.com/ethereum/EIPs/issues/20
158  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
159  */
160 contract StandardToken is ERC20, BasicToken {
161 
162   mapping (address => mapping (address => uint256)) internal allowed;
163 
164 
165   /**
166    * @dev Transfer tokens from one address to another
167    * @param _from address The address which you want to send tokens from
168    * @param _to address The address which you want to transfer to
169    * @param _value uint256 the amount of tokens to be transferred
170    */
171   function transferFrom(
172     address _from,
173     address _to,
174     uint256 _value
175   )
176     public
177     returns (bool)
178   {
179     require(_to != address(0));
180     require(_value <= balances[_from]);
181     require(_value <= allowed[_from][msg.sender]);
182 
183     balances[_from] = balances[_from].sub(_value);
184     balances[_to] = balances[_to].add(_value);
185     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
186     emit Transfer(_from, _to, _value);
187     return true;
188   }
189 
190   /**
191    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
192    *
193    * Beware that changing an allowance with this method brings the risk that someone may use both the old
194    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
195    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
196    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
197    * @param _spender The address which will spend the funds.
198    * @param _value The amount of tokens to be spent.
199    */
200   function approve(address _spender, uint256 _value) public returns (bool) {
201     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
202     allowed[msg.sender][_spender] = _value;
203     emit Approval(msg.sender, _spender, _value);
204     return true;
205   }
206 
207   /**
208    * @dev Function to check the amount of tokens that an owner allowed to a spender.
209    * @param _owner address The address which owns the funds.
210    * @param _spender address The address which will spend the funds.
211    * @return A uint256 specifying the amount of tokens still available for the spender.
212    */
213   function allowance(
214     address _owner,
215     address _spender
216    )
217     public
218     view
219     returns (uint256)
220   {
221     return allowed[_owner][_spender];
222   }
223 
224   /**
225    * @dev Increase the amount of tokens that an owner allowed to a spender.
226    *
227    * approve should be called when allowed[_spender] == 0. To increment
228    * allowed value is better to use this function to avoid 2 calls (and wait until
229    * the first transaction is mined)
230    * From MonolithDAO Token.sol
231    * @param _spender The address which will spend the funds.
232    * @param _addedValue The amount of tokens to increase the allowance by.
233    */
234   function increaseApproval(
235     address _spender,
236     uint _addedValue
237   )
238     public
239     returns (bool)
240   {
241     allowed[msg.sender][_spender] = (
242       allowed[msg.sender][_spender].add(_addedValue));
243     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
244     return true;
245   }
246 
247   /**
248    * @dev Decrease the amount of tokens that an owner allowed to a spender.
249    *
250    * approve should be called when allowed[_spender] == 0. To decrement
251    * allowed value is better to use this function to avoid 2 calls (and wait until
252    * the first transaction is mined)
253    * From MonolithDAO Token.sol
254    * @param _spender The address which will spend the funds.
255    * @param _subtractedValue The amount of tokens to decrease the allowance by.
256    */
257   function decreaseApproval(
258     address _spender,
259     uint _subtractedValue
260   )
261     public
262     returns (bool)
263   {
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
277 /**
278  * @title Ownable
279  * @dev The Ownable contract has an owner address, and provides basic authorization control
280  * functions, this simplifies the implementation of "user permissions".
281  */
282 contract Ownable {
283   address public owner;
284 
285 
286   event OwnershipRenounced(address indexed previousOwner);
287   event OwnershipTransferred(
288     address indexed previousOwner,
289     address indexed newOwner
290   );
291 
292 
293   /**
294    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
295    * account.
296    */
297   constructor() public {
298     owner = msg.sender;
299   }
300 
301   /**
302    * @dev Throws if called by any account other than the owner.
303    */
304   modifier onlyOwner() {
305     require(msg.sender == owner);
306     _;
307   }
308 
309   /**
310    * @dev Allows the current owner to transfer control of the contract to a newOwner.
311    * @param newOwner The address to transfer ownership to.
312    */
313   function transferOwnership(address newOwner) public onlyOwner {
314     require(newOwner != address(0));
315     emit OwnershipTransferred(owner, newOwner);
316     owner = newOwner;
317   }
318 
319   /**
320    * @dev Allows the current owner to relinquish control of the contract.
321    */
322   function renounceOwnership() public onlyOwner {
323     emit OwnershipRenounced(owner);
324     owner = address(0);
325   }
326 }
327 
328 
329 contract Recoverable is Ownable {
330 
331   /// @dev Empty constructor (for now)
332   constructor() public {
333   }
334 
335   /// @dev This will be invoked by the owner, when owner wants to rescue tokens
336   /// @param token Token which will we rescue to the owner from the contract
337   function recoverTokens(ERC20Basic token) onlyOwner public {
338     token.transfer(owner, tokensToBeReturned(token));
339   }
340 
341   /// @dev Interface function, can be overwritten by the superclass
342   /// @param token Token which balance we will check and return
343   /// @return The amount of tokens (in smallest denominator) the contract owns
344   function tokensToBeReturned(ERC20Basic token) public view returns (uint) {
345     return token.balanceOf(this);
346   }
347 }
348 
349 
350 /**
351  * Standard EIP-20 token with an interface marker.
352  *
353  * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.
354  *
355  */
356 contract StandardTokenExt is StandardToken, Recoverable {
357 
358   /* Interface declaration */
359   function isToken() public pure returns (bool weAre) {
360     return true;
361   }
362 }
363 
364 /**
365  * A token that can increase its supply by another contract.
366  *
367  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
368  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
369  *
370  */
371 contract MintableToken is StandardTokenExt {
372 
373   using SafeMathLib for uint;
374 
375   bool public mintingFinished = false;
376 
377   /** List of agents that are allowed to create new tokens */
378   mapping (address => bool) public mintAgents;
379 
380   event MintingAgentChanged(address addr, bool state);
381   event Minted(address receiver, uint amount);
382 
383   /**
384    * Create new tokens and allocate them to an address..
385    *
386    * Only callably by a crowdsale contract (mint agent).
387    */
388   function mint(address receiver, uint amount) onlyMintAgent canMint public {
389     totalSupply_ = totalSupply_.plus(amount);
390     balances[receiver] = balances[receiver].plus(amount);
391 
392     // This will make the mint transaction apper in EtherScan.io
393     // We can remove this after there is a standardized minting event
394     emit Transfer(0, receiver, amount);
395   }
396 
397   /**
398    * Owner can allow a crowdsale contract to mint new tokens.
399    */
400   function setMintAgent(address addr, bool state) onlyOwner canMint public {
401     mintAgents[addr] = state;
402     emit MintingAgentChanged(addr, state);
403   }
404 
405   modifier onlyMintAgent() {
406     // Only crowdsale contracts are allowed to mint new tokens
407     require(mintAgents[msg.sender]);
408     _;
409   }
410 
411   /** Make sure we are not done yet. */
412   modifier canMint() {
413     require(!mintingFinished);
414     _;
415   }
416 }
417 
418 
419 /**
420  * Define interface for releasing the token transfer after a successful crowdsale.
421  */
422 contract ReleasableToken is StandardTokenExt {
423 
424   /* The finalizer contract that allows unlift the transfer limits on this token */
425   address public releaseAgent;
426 
427   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
428   bool public released = false;
429 
430   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
431   mapping (address => bool) public transferAgents;
432 
433   /**
434    * Limit token transfer until the crowdsale is over.
435    *
436    */
437   modifier canTransfer(address _sender) {
438 
439     require(released || transferAgents[_sender]);
440     _;
441   }
442 
443   /**
444    * Set the contract that can call release and make the token transferable.
445    *
446    * Design choice. Allow reset the release agent to fix fat finger mistakes.
447    */
448   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
449 
450     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
451     releaseAgent = addr;
452   }
453 
454   /**
455    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
456    */
457   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
458     transferAgents[addr] = state;
459   }
460 
461   /**
462    * One way function to release the tokens to the wild.
463    *
464    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
465    */
466   function releaseTokenTransfer() public onlyReleaseAgent {
467     released = true;
468   }
469 
470   /** The function can be called only before or after the tokens have been releasesd */
471   modifier inReleaseState(bool releaseState) {
472     require(releaseState == released);
473     _;
474   }
475 
476   /** The function can be called only by a whitelisted release agent. */
477   modifier onlyReleaseAgent() {
478     require(msg.sender == releaseAgent);
479     _;
480   }
481 
482   function transfer(address _to, uint _value) canTransfer(msg.sender) public returns (bool success) {
483     // Call StandardToken.transfer()
484    return super.transfer(_to, _value);
485   }
486 
487   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) public returns (bool success) {
488     // Call StandardToken.transferForm()
489     return super.transferFrom(_from, _to, _value);
490   }
491 
492 }
493 
494 
495 /**
496  * Upgrade agent interface inspired by Lunyr.
497  *
498  * Upgrade agent transfers tokens to a new contract.
499  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
500  */
501 contract UpgradeAgent {
502 
503   uint public originalSupply;
504 
505   /** Interface marker */
506   function isUpgradeAgent() public pure returns (bool) {
507     return true;
508   }
509 
510   function upgradeFrom(address _from, uint256 _value) public;
511 
512 }
513 
514 
515 /**
516  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
517  *
518  * First envisioned by Golem and Lunyr projects.
519  */
520 contract UpgradeableToken is StandardTokenExt {
521 
522   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
523   address public upgradeMaster;
524 
525   /** The next contract where the tokens will be migrated. */
526   UpgradeAgent public upgradeAgent;
527 
528   /** How many tokens we have upgraded by now. */
529   uint256 public totalUpgraded;
530 
531   /**
532    * Upgrade states.
533    *
534    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
535    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
536    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
537    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
538    *
539    */
540   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
541 
542   /**
543    * Somebody has upgraded some of his tokens.
544    */
545   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
546 
547   /**
548    * New upgrade agent available.
549    */
550   event UpgradeAgentSet(address agent);
551 
552   /**
553    * Do not allow construction without upgrade master set.
554    */
555   constructor(address _upgradeMaster) public {
556     upgradeMaster = _upgradeMaster;
557   }
558 
559   /**
560    * Allow the token holder to upgrade some of their tokens to a new contract.
561    */
562   function upgrade(uint256 value) public {
563 
564       UpgradeState state = getUpgradeState();
565       require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading);
566 
567       // Validate input value.
568       require(value > 0);
569 
570       balances[msg.sender] = balances[msg.sender].sub(value);
571 
572       // Take tokens out from circulation
573       totalSupply_ = totalSupply_.sub(value);
574       totalUpgraded = totalUpgraded.add(value);
575 
576       // Upgrade agent reissues the tokens
577       upgradeAgent.upgradeFrom(msg.sender, value);
578       emit Upgrade(msg.sender, upgradeAgent, value);
579   }
580 
581   /**
582    * Set an upgrade agent that handles
583    */
584   function setUpgradeAgent(address agent) external {
585 
586       require(canUpgrade());
587 
588       require(agent != 0x0);
589       // Only a master can designate the next agent
590       require(msg.sender == upgradeMaster);
591       // Upgrade has already begun for an agent
592       require(getUpgradeState() != UpgradeState.Upgrading);
593 
594       upgradeAgent = UpgradeAgent(agent);
595 
596       // Bad interface
597       require(upgradeAgent.isUpgradeAgent());
598       // Make sure that token supplies match in source and target
599       require(upgradeAgent.originalSupply() == totalSupply_);
600 
601       emit UpgradeAgentSet(upgradeAgent);
602   }
603 
604   /**
605    * Get the state of the token upgrade.
606    */
607   function getUpgradeState() public view returns(UpgradeState) {
608     if(!canUpgrade()) return UpgradeState.NotAllowed;
609     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
610     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
611     else return UpgradeState.Upgrading;
612   }
613 
614   /**
615    * Change the upgrade master.
616    *
617    * This allows us to set a new owner for the upgrade mechanism.
618    */
619   function setUpgradeMaster(address master) public {
620       require(master != 0x0);
621       require(msg.sender == upgradeMaster);
622       upgradeMaster = master;
623   }
624 
625   /**
626    * Child contract can enable to provide the condition when the upgrade can begun.
627    */
628   function canUpgrade() public view returns(bool) {
629      return true;
630   }
631 
632 }
633 
634 /**
635  * BOLTT ERC20 Token
636  *
637  * An ERC-20 token designed specifically for multiple crowdsales with investor protection and further development path.
638  *
639  * - The token transfer() is disabled until the crowdsale is over
640  * - The token contract gives an opt-in upgrade path to a new contract
641  * - The same token can be part of several crowdsales through approve() mechanism
642  *
643  * BOLTT Sports Technology
644  */
645 contract BolttCoin is ReleasableToken, MintableToken, UpgradeableToken {
646 
647   /** Name and symbol were updated. */
648   event UpdatedTokenInformation(string newName, string newSymbol);
649 
650   /** Transfer to Waves chain */
651   event WavesTransfer(address indexed _from, string wavesAddress, uint256 amount);
652 
653   string public name;
654 
655   string public symbol;
656 
657   uint public decimals;
658 
659   address public wavesReserve;
660 
661   /**
662    * Construct BolttCoin
663    *
664    * @param _name Token name
665    * @param _symbol Token symbol - should be all caps
666    * @param _initialSupply How many tokens we start with
667    * @param _decimals Number of decimal places
668    * @param _wavesReserve The waves reserve address
669    */
670   constructor(string memory _name, string memory _symbol, uint _initialSupply, uint _decimals, address _wavesReserve)
671     UpgradeableToken(msg.sender) public {
672     require(_wavesReserve != address(0));
673 
674     owner = msg.sender;
675 
676     name = _name;
677     symbol = _symbol;
678 
679     totalSupply_ = _initialSupply;
680 
681     decimals = _decimals;
682 
683     wavesReserve = _wavesReserve;
684 
685     // Create initially all balance on the team multisig
686     balances[owner] = totalSupply_;
687 
688     if(totalSupply_ > 0) {
689       emit Minted(owner, totalSupply_);
690       mintingFinished = true;
691     }
692   }
693 
694   /**
695    * Allow releasing token transfer
696    */
697   function releaseTokenTransfer() public onlyReleaseAgent {
698     super.releaseTokenTransfer();
699   }
700 
701   /**
702    * Allow upgrade agent functionality kick in only if the crowdsale was success.
703    */
704   function canUpgrade() public view returns(bool) {
705     return released && super.canUpgrade();
706   }
707 
708   /**
709    * Update token information
710    */
711   function setTokenInformation(string memory _name, string memory _symbol) public onlyOwner {
712     name = _name;
713     symbol = _symbol;
714 
715     emit UpdatedTokenInformation(name, symbol);
716   }
717 
718   function moveToWaves(string memory wavesAddress, uint256 amount) public {
719       require(transfer(wavesReserve, amount));
720       emit WavesTransfer(msg.sender, wavesAddress, amount);
721   }
722 
723 }