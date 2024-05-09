1 /**
2  * This smart contract code is based on BurnableCrowdsaleToken contract by TokenMarket Ltd. 
3  * Modifications made by Enhanced Society include
4  * - UpgradeAgent to allow from Upgrade from an older token version
5  * - MintingFinished Disabled to allow issuing tokens post release
6  * - Whitelist to verify sender & reciever are allowed to transfer tokens.
7  */
8 
9 
10 pragma solidity ^0.4.18;
11 
12 library SafeMath {
13 
14   /**
15   * @dev Multiplies two numbers, throws on overflow.
16   */
17   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
18     if (a == 0) {
19       return 0;
20     }
21     uint256 c = a * b;
22     assert(c / a == b);
23     return c;
24   }
25 
26   /**
27   * @dev Integer division of two numbers, truncating the quotient.
28   */
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35 
36   /**
37   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
38   */
39   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40     assert(b <= a);
41     return a - b;
42   }
43 
44   /**
45   * @dev Adds two numbers, throws on overflow.
46   */
47   function add(uint256 a, uint256 b) internal pure returns (uint256) {
48     uint256 c = a + b;
49     assert(c >= a);
50     return c;
51   }
52 }
53 
54 contract UpgradeAgent {
55 
56   uint public originalSupply;
57 
58   /** Interface marker */
59   function isUpgradeAgent() public constant returns (bool) {
60     return true;
61   }
62 
63   function upgradeFrom(address _from, uint256 _value) public;
64   
65 
66 }
67 
68 contract ERC20Basic {
69   function totalSupply() public view returns (uint256);
70   function balanceOf(address who) public view returns (uint256);
71   function transfer(address to, uint256 value) public returns (bool);
72   event Transfer(address indexed from, address indexed to, uint256 value);
73 }
74 
75 library SafeMathLib {
76 
77   function times(uint a, uint b) returns (uint) {
78     uint c = a * b;
79     assert(a == 0 || c / a == b);
80     return c;
81   }
82 
83   function minus(uint a, uint b) returns (uint) {
84     assert(b <= a);
85     return a - b;
86   }
87 
88   function plus(uint a, uint b) returns (uint) {
89     uint c = a + b;
90     assert(c>=a);
91     return c;
92   }
93 
94 }
95 
96 contract ERC20 is ERC20Basic {
97   function allowance(address owner, address spender) public view returns (uint256);
98   function transferFrom(address from, address to, uint256 value) public returns (bool);
99   function approve(address spender, uint256 value) public returns (bool);
100   event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 contract Ownable {
104   address public owner;
105 
106 
107   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
108 
109 
110   /**
111    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
112    * account.
113    */
114   function Ownable() public {
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
127    * @dev Allows the current owner to transfer control of the contract to a newOwner.
128    * @param newOwner The address to transfer ownership to.
129    */
130   function transferOwnership(address newOwner) public onlyOwner {
131     require(newOwner != address(0));
132     OwnershipTransferred(owner, newOwner);
133     owner = newOwner;
134   }
135 
136 }
137 
138 contract Recoverable is Ownable {
139 
140   /// @dev Empty constructor (for now)
141   function Recoverable() {
142   }
143 
144   /// @dev This will be invoked by the owner, when owner wants to rescue tokens
145   /// @param token Token which will we rescue to the owner from the contract
146   function recoverTokens(ERC20Basic token) onlyOwner public {
147     token.transfer(owner, tokensToBeReturned(token));
148   }
149 
150   /// @dev Interface function, can be overwritten by the superclass
151   /// @param token Token which balance we will check and return
152   /// @return The amount of tokens (in smallest denominator) the contract owns
153   function tokensToBeReturned(ERC20Basic token) public returns (uint) {
154     return token.balanceOf(this);
155   }
156 }
157 
158 contract Whitelist is Ownable {
159   mapping(address => bool) public whitelist;
160   
161   event WhitelistedAddressAdded(address addr);
162   event WhitelistedAddressRemoved(address addr);
163 
164   /**
165    * @dev Throws if called by any account that's not whitelisted.
166    */
167   modifier onlyWhitelisted() {
168     require(whitelist[msg.sender]);
169     _;
170   }
171 
172   /**
173    * @dev add an address to the whitelist
174    * @param addr address
175    * @return true if the address was added to the whitelist, false if the address was already in the whitelist 
176    */
177   function addAddressToWhitelist(address addr) onlyOwner public returns(bool success) {
178     if (!whitelist[addr]) {
179       whitelist[addr] = true;
180       WhitelistedAddressAdded(addr);
181       success = true; 
182     }
183   }
184 
185   /**
186    * @dev add addresses to the whitelist
187    * @param addrs addresses
188    * @return true if at least one address was added to the whitelist, 
189    * false if all addresses were already in the whitelist  
190    */
191   function addAddressesToWhitelist(address[] addrs) onlyOwner public returns(bool success) {
192     for (uint256 i = 0; i < addrs.length; i++) {
193       if (addAddressToWhitelist(addrs[i])) {
194         success = true;
195       }
196     }
197   }
198 
199   /**
200    * @dev remove an address from the whitelist
201    * @param addr address
202    * @return true if the address was removed from the whitelist, 
203    * false if the address wasn't in the whitelist in the first place 
204    */
205   function removeAddressFromWhitelist(address addr) onlyOwner public returns(bool success) {
206     if (whitelist[addr]) {
207       whitelist[addr] = false;
208       WhitelistedAddressRemoved(addr);
209       success = true;
210     }
211   }
212 
213   /**
214    * @dev remove addresses from the whitelist
215    * @param addrs addresses
216    * @return true if at least one address was removed from the whitelist, 
217    * false if all addresses weren't in the whitelist in the first place
218    */
219   function removeAddressesFromWhitelist(address[] addrs) onlyOwner public returns(bool success) {
220     for (uint256 i = 0; i < addrs.length; i++) {
221       if (removeAddressFromWhitelist(addrs[i])) {
222         success = true;
223       }
224     }
225   }
226 
227 }
228 
229 contract BasicToken is ERC20Basic, Whitelist {
230   using SafeMath for uint256;
231 
232   mapping(address => uint256) balances;
233 
234   uint256 totalSupply_;
235 
236   /**
237   * @dev total number of tokens in existence
238   */
239   function totalSupply() public view returns (uint256) {
240     return totalSupply_;
241   }
242 
243   /**
244   * @dev transfer token for a specified address
245   * @param _to The address to transfer to.
246   * @param _value The amount to be transferred.
247   */
248   function transfer(address _to, uint256 _value) public returns (bool) {
249     require(_to != address(0));
250     require(_value <= balances[msg.sender]);
251     require(whitelist[msg.sender] && whitelist[_to]); //introduced for by Enhanced Society for whitelisting
252 
253     // SafeMath.sub will throw if there is not enough balance.
254     balances[msg.sender] = balances[msg.sender].sub(_value);
255     balances[_to] = balances[_to].add(_value);
256     Transfer(msg.sender, _to, _value);
257     return true;
258   }
259 
260   /**
261   * @dev Gets the balance of the specified address.
262   * @param _owner The address to query the the balance of.
263   * @return An uint256 representing the amount owned by the passed address.
264   */
265   function balanceOf(address _owner) public view returns (uint256 balance) {
266     return balances[_owner];
267   }
268 
269 }
270 
271 contract StandardToken is ERC20, BasicToken {
272 
273   mapping (address => mapping (address => uint256)) internal allowed;
274 
275 
276   /**
277    * @dev Transfer tokens from one address to another
278    * @param _from address The address which you want to send tokens from
279    * @param _to address The address which you want to transfer to
280    * @param _value uint256 the amount of tokens to be transferred
281    */
282   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
283     require(_to != address(0));
284     require(_value <= balances[_from]);
285     require(_value <= allowed[_from][msg.sender]);
286 
287     balances[_from] = balances[_from].sub(_value);
288     balances[_to] = balances[_to].add(_value);
289     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
290     Transfer(_from, _to, _value);
291     return true;
292   }
293 
294   /**
295    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
296    *
297    * Beware that changing an allowance with this method brings the risk that someone may use both the old
298    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
299    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
300    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
301    * @param _spender The address which will spend the funds.
302    * @param _value The amount of tokens to be spent.
303    */
304   function approve(address _spender, uint256 _value) public returns (bool) {
305     allowed[msg.sender][_spender] = _value;
306     Approval(msg.sender, _spender, _value);
307     return true;
308   }
309 
310   /**
311    * @dev Function to check the amount of tokens that an owner allowed to a spender.
312    * @param _owner address The address which owns the funds.
313    * @param _spender address The address which will spend the funds.
314    * @return A uint256 specifying the amount of tokens still available for the spender.
315    */
316   function allowance(address _owner, address _spender) public view returns (uint256) {
317     return allowed[_owner][_spender];
318   }
319 
320   /**
321    * @dev Increase the amount of tokens that an owner allowed to a spender.
322    *
323    * approve should be called when allowed[_spender] == 0. To increment
324    * allowed value is better to use this function to avoid 2 calls (and wait until
325    * the first transaction is mined)
326    * From MonolithDAO Token.sol
327    * @param _spender The address which will spend the funds.
328    * @param _addedValue The amount of tokens to increase the allowance by.
329    */
330   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
331     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
332     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
333     return true;
334   }
335 
336   /**
337    * @dev Decrease the amount of tokens that an owner allowed to a spender.
338    *
339    * approve should be called when allowed[_spender] == 0. To decrement
340    * allowed value is better to use this function to avoid 2 calls (and wait until
341    * the first transaction is mined)
342    * From MonolithDAO Token.sol
343    * @param _spender The address which will spend the funds.
344    * @param _subtractedValue The amount of tokens to decrease the allowance by.
345    */
346   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
347     uint oldValue = allowed[msg.sender][_spender];
348     if (_subtractedValue > oldValue) {
349       allowed[msg.sender][_spender] = 0;
350     } else {
351       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
352     }
353     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
354     return true;
355   }
356 
357 }
358 
359 contract StandardTokenExt is StandardToken, Recoverable {
360 
361   /* Interface declaration */
362   function isToken() public constant returns (bool weAre) {
363     return true;
364   }
365 }
366 
367 contract UpgradeableToken is StandardTokenExt {
368 
369   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
370   address public upgradeMaster;
371 
372   /** The next contract where the tokens will be migrated. */
373   UpgradeAgent public upgradeAgent;
374 
375   /** How many tokens we have upgraded by now. */
376   uint256 public totalUpgraded;
377 
378   /**
379    * Upgrade states.
380    *
381    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
382    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
383    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
384    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
385    *
386    */
387   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
388 
389   /**
390    * Somebody has upgraded some of his tokens.
391    */
392   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
393 
394   /**
395    * New upgrade agent available.
396    */
397   event UpgradeAgentSet(address agent);
398 
399   /**
400    * Do not allow construction without upgrade master set.
401    */
402   function UpgradeableToken(address _upgradeMaster) {
403     upgradeMaster = _upgradeMaster;
404   }
405 
406   /**
407    * Allow the token holder to upgrade some of their tokens to a new contract.
408    */
409   function upgrade(uint256 value) public {
410 
411       UpgradeState state = getUpgradeState();
412       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
413         // Called in a bad state
414         throw;
415       }
416 
417       // Validate input value.
418       if (value == 0) throw;
419 
420       balances[msg.sender] = balances[msg.sender].sub(value);
421 
422       // Take tokens out from circulation
423       totalSupply_ = totalSupply_.sub(value);
424       totalUpgraded = totalUpgraded.add(value);
425 
426       // Upgrade agent reissues the tokens
427       upgradeAgent.upgradeFrom(msg.sender, value);
428       Upgrade(msg.sender, upgradeAgent, value);
429   }
430 
431   /**
432    * Set an upgrade agent that handles
433    */
434   function setUpgradeAgent(address agent) external {
435 
436       if(!canUpgrade()) {
437         // The token is not yet in a state that we could think upgrading
438         throw;
439       }
440 
441       if (agent == 0x0) throw;
442       // Only a master can designate the next agent
443       if (msg.sender != upgradeMaster) throw;
444       // Upgrade has already begun for an agent
445       if (getUpgradeState() == UpgradeState.Upgrading) throw;
446 
447       upgradeAgent = UpgradeAgent(agent);
448 
449       // Bad interface
450       if(!upgradeAgent.isUpgradeAgent()) throw;
451       // Make sure that token supplies match in source and target
452       if (upgradeAgent.originalSupply() != totalSupply_) throw;
453 
454       UpgradeAgentSet(upgradeAgent);
455   }
456 
457   /**
458    * Get the state of the token upgrade.
459    */
460   function getUpgradeState() public constant returns(UpgradeState) {
461     if(!canUpgrade()) return UpgradeState.NotAllowed;
462     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
463     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
464     else return UpgradeState.Upgrading;
465   }
466 
467   /**
468    * Change the upgrade master.
469    *
470    * This allows us to set a new owner for the upgrade mechanism.
471    */
472   function setUpgradeMaster(address master) public {
473       if (master == 0x0) throw;
474       if (msg.sender != upgradeMaster) throw;
475       upgradeMaster = master;
476   }
477 
478   /**
479    * Child contract can enable to provide the condition when the upgrade can begun.
480    */
481   function canUpgrade() public constant returns(bool) {
482      return true;
483   }
484 
485 }
486 
487 contract BurnableToken is StandardTokenExt {
488 
489   // @notice An address for the transfer event where the burned tokens are transferred in a faux Transfer event
490   address public constant BURN_ADDRESS = 0;
491 
492   /** How many tokens we burned */
493   event Burned(address burner, uint burnedAmount);
494 
495   /**
496    * Burn extra tokens from a balance.
497    *
498    */
499   function burn(uint burnAmount) {
500     address burner = msg.sender;
501     balances[burner] = balances[burner].sub(burnAmount);
502     totalSupply_ = totalSupply_.sub(burnAmount);
503     Burned(burner, burnAmount);
504 
505     // Inform the blockchain explores that track the
506     // balances only by a transfer event that the balance in this
507     // address has decreased
508     Transfer(burner, BURN_ADDRESS, burnAmount);
509   }
510 }
511 
512 contract MintableToken is StandardTokenExt {
513 
514   using SafeMathLib for uint;
515 
516   bool public mintingFinished = false;
517 
518   /** List of agents that are allowed to create new tokens */
519   mapping (address => bool) public mintAgents;
520 
521   event MintingAgentChanged(address addr, bool state);
522   event Minted(address receiver, uint amount);
523 
524   /**
525    * Create new tokens and allocate them to an address..
526    *
527    * Only callably by a crowdsale contract (mint agent).
528    */
529   function mint(address receiver, uint amount) onlyMintAgent canMint public {
530     totalSupply_ = totalSupply_.plus(amount);
531     balances[receiver] = balances[receiver].plus(amount);
532 
533     // This will make the mint transaction apper in EtherScan.io
534     // We can remove this after there is a standardized minting event
535     Transfer(0, receiver, amount);
536   }
537 
538   /**
539    * Owner can allow a crowdsale contract to mint new tokens.
540    */
541   function setMintAgent(address addr, bool state) onlyOwner canMint public {
542     mintAgents[addr] = state;
543     MintingAgentChanged(addr, state);
544   }
545 
546   modifier onlyMintAgent() {
547     // Only crowdsale contracts are allowed to mint new tokens
548     if(!mintAgents[msg.sender]) {
549         throw;
550     }
551     _;
552   }
553 
554   /** Make sure we are not done yet. */
555   modifier canMint() {
556     if(mintingFinished) throw;
557     _;
558   }
559 }
560 
561 contract ReleasableToken is StandardTokenExt {
562 
563   /* The finalizer contract that allows unlift the transfer limits on this token */
564   address public releaseAgent;
565 
566   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
567   bool public released = false;
568 
569   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
570   mapping (address => bool) public transferAgents;
571 
572   /**
573    * Limit token transfer until the crowdsale is over.
574    *
575    */
576   modifier canTransfer(address _sender) {
577 
578     if(!released) {
579         if(!transferAgents[_sender]) {
580             throw;
581         }
582     }
583 
584     _;
585   }
586 
587   /**
588    * Set the contract that can call release and make the token transferable.
589    *
590    * Design choice. Allow reset the release agent to fix fat finger mistakes.
591    */
592   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
593 
594     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
595     releaseAgent = addr;
596   }
597 
598   /**
599    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
600    */
601   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
602     transferAgents[addr] = state;
603   }
604 
605   /**
606    * One way function to release the tokens to the wild.
607    *
608    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
609    */
610   function releaseTokenTransfer() public onlyReleaseAgent {
611     released = true;
612   }
613 
614   /** The function can be called only before or after the tokens have been releasesd */
615   modifier inReleaseState(bool releaseState) {
616     if(releaseState != released) {
617         throw;
618     }
619     _;
620   }
621 
622   /** The function can be called only by a whitelisted release agent. */
623   modifier onlyReleaseAgent() {
624     if(msg.sender != releaseAgent) {
625         throw;
626     }
627     _;
628   }
629 
630   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
631     // Call StandardToken.transfer()
632    return super.transfer(_to, _value);
633   }
634 
635   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
636     // Call StandardToken.transferForm()
637     return super.transferFrom(_from, _to, _value);
638   }
639 
640 }
641 
642 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
643 
644   /** Name and symbol were updated. */
645   event UpdatedTokenInformation(string newName, string newSymbol);
646 
647   string public name;
648 
649   string public symbol;
650 
651   uint public decimals;
652 
653   /**
654    * Construct the token.
655    *
656    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
657    *
658    * @param _name Token name
659    * @param _symbol Token symbol - should be all caps
660    * @param _initialSupply How many tokens we start with
661    * @param _decimals Number of decimal places
662    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
663    */
664   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
665     UpgradeableToken(msg.sender) {
666 
667     // Create any address, can be transferred
668     // to team multisig via changeOwner(),
669     // also remember to call setUpgradeMaster()
670     owner = msg.sender;
671 
672     name = _name;
673     symbol = _symbol;
674 
675     totalSupply_ = _initialSupply;
676 
677     decimals = _decimals;
678 
679     // Create initially all balance on the team multisig
680     balances[owner] = totalSupply_;
681 
682     if(totalSupply_ > 0) {
683       Minted(owner, totalSupply_);
684     }
685 
686     // No more new supply allowed after the token creation
687     if(!_mintable) {
688       mintingFinished = true;
689       if(totalSupply_ == 0) {
690         throw; // Cannot create a token without supply and no minting
691       }
692     }
693   }
694 
695   /**
696    * When token is released to be transferable, enforce no new tokens can be created.
697    */
698   function releaseTokenTransfer() public onlyReleaseAgent {
699     // mintingFinished = true;   // Introduced by enhanced society for seurity tokens to be minted after releaseTokenTransfer
700     super.releaseTokenTransfer();
701   }
702 
703   /**
704    * Allow upgrade agent functionality kick in only if the crowdsale was success.
705    */
706   function canUpgrade() public constant returns(bool) {
707     return released && super.canUpgrade();
708   }
709 
710   /**
711    * Owner can update token information here.
712    *
713    * It is often useful to conceal the actual token association, until
714    * the token operations, like central issuance or reissuance have been completed.
715    *
716    * This function allows the token owner to rename the token after the operations
717    * have been completed and then point the audience to use the token contract.
718    */
719   function setTokenInformation(string _name, string _symbol) onlyOwner {
720     name = _name;
721     symbol = _symbol;
722 
723     UpdatedTokenInformation(name, symbol);
724   }
725 
726 }
727 
728 contract EnhancedToken is BurnableToken, CrowdsaleToken, UpgradeAgent {
729   using SafeMathLib for uint;
730 
731   UpgradeableToken public oldToken;
732 
733   uint public originalSupply;    
734 
735   function EnhancedToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable, UpgradeableToken _oldToken)
736     CrowdsaleToken(_name, _symbol, _initialSupply, _decimals, _mintable) {
737             oldToken = _oldToken;
738 
739     // Let's not set bad old token
740     if(address(oldToken) == 0) {
741       throw;
742     }
743 
744     // Let's make sure we have something to migrate
745     originalSupply = _oldToken.totalSupply();
746     if(originalSupply == 0) {
747       throw;
748     }
749 
750   }
751   
752   
753   function upgradeFrom(address _from, uint256 _value) public {
754     if (msg.sender != address(oldToken)) throw; // only upgrade from oldToken
755 
756     // Mint new tokens to the migrator
757     totalSupply_ = totalSupply_.plus(_value);
758     balances[_from] = balances[_from].plus(_value);
759     Transfer(0, _from, _value);
760   }
761 }