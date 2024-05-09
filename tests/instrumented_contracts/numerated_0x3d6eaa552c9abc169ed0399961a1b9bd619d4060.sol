1 pragma solidity ^0.4.23;
2 
3 
4 contract Ownable {
5   address public owner;
6 
7 
8   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
9 
10 
11   /**
12    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
13    * account.
14    */
15   constructor() public {
16     owner = msg.sender;
17   }
18 
19   /**
20    * @dev Throws if called by any account other than the owner.
21    */
22   modifier onlyOwner() {
23     require(msg.sender == owner);
24     _;
25   }
26 
27   /**
28    * @dev Allows the current owner to transfer control of the contract to a newOwner.
29    * @param newOwner The address to transfer ownership to.
30    */
31   function transferOwnership(address newOwner) public onlyOwner {
32     require(newOwner != address(0));
33     emit OwnershipTransferred(owner, newOwner);
34     owner = newOwner;
35   }
36 
37 }
38 
39 contract ERC20Basic {
40   function totalSupply() public view returns (uint256);
41   function balanceOf(address who) public view returns (uint256);
42   function transfer(address to, uint256 value) public returns (bool);
43   event Transfer(address indexed from, address indexed to, uint256 value);
44 }
45 
46 
47 library SafeMath {
48 
49   /**
50   * @dev Multiplies two numbers, throws on overflow.
51   */
52   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
53     if (a == 0) {
54       return 0;
55     }
56     uint256 c = a * b;
57     assert(c / a == b);
58     return c;
59   }
60 
61   /**
62   * @dev Integer division of two numbers, truncating the quotient.
63   */
64   function div(uint256 a, uint256 b) internal pure returns (uint256) {
65     // assert(b > 0); // Solidity automatically throws when dividing by 0
66     uint256 c = a / b;
67     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
68     return c;
69   }
70 
71   /**
72   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
73   */
74   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
75     assert(b <= a);
76     return a - b;
77   }
78 
79   /**
80   * @dev Adds two numbers, throws on overflow.
81   */
82   function add(uint256 a, uint256 b) internal pure returns (uint256) {
83     uint256 c = a + b;
84     assert(c >= a);
85     return c;
86   }
87   
88   function times(uint a, uint b) public pure returns (uint) {
89     uint c = a * b;
90     assert(a == 0 || c / a == b);
91     return c;
92   }
93 
94   function minus(uint a, uint b) public pure returns (uint) {
95     assert(b <= a);
96     return a - b;
97   }
98 
99   function plus(uint256 a, uint256 b) public pure returns (uint) {
100     uint256 c = a + b;
101     assert(c>=a);
102     return c;
103   }
104   
105 }
106 
107 
108 contract BasicToken is ERC20Basic {
109   using SafeMath for uint256;
110 
111   mapping(address => uint256) balances;
112 
113   uint256 totalSupply_;
114 
115   /**
116   * @dev total number of tokens in existence
117   */
118   function totalSupply() public view returns (uint256) {
119     return totalSupply_;
120   }
121 
122   /**
123   * @dev transfer token for a specified address
124   * @param _to The address to transfer to.
125   * @param _value The amount to be transferred.
126   */
127   function transfer(address _to, uint256 _value) public returns (bool) {
128     require(_to != address(0));
129     require(_value <= balances[msg.sender]);
130 
131     // SafeMath.sub will throw if there is not enough balance.
132     balances[msg.sender] = balances[msg.sender].sub(_value);
133     balances[_to] = balances[_to].add(_value);
134     emit Transfer(msg.sender, _to, _value);
135     return true;
136   }
137 
138   /**
139   * @dev Gets the balance of the specified address.
140   * @param _owner The address to query the the balance of.
141   * @return An uint256 representing the amount owned by the passed address.
142   */
143   function balanceOf(address _owner) public view returns (uint256 balance) {
144     return balances[_owner];
145   }
146 
147 }
148 
149 contract ERC20 is ERC20Basic {
150   function allowance(address owner, address spender) public view returns (uint256);
151   function transferFrom(address from, address to, uint256 value) public returns (bool);
152   function approve(address spender, uint256 value) public returns (bool);
153   event Approval(address indexed owner, address indexed spender, uint256 value);
154 }
155 
156 contract StandardToken is ERC20, BasicToken {
157 
158   mapping (address => mapping (address => uint256)) internal allowed;
159 
160 
161   /**
162    * @dev Transfer tokens from one address to another
163    * @param _from address The address which you want to send tokens from
164    * @param _to address The address which you want to transfer to
165    * @param _value uint256 the amount of tokens to be transferred
166    */
167   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
168     require(_to != address(0));
169     require(_value <= balances[_from]);
170     require(_value <= allowed[_from][msg.sender]);
171 
172     balances[_from] = balances[_from].sub(_value);
173     balances[_to] = balances[_to].add(_value);
174     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
175     Transfer(_from, _to, _value);
176     return true;
177   }
178 
179   /**
180    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
181    *
182    * Beware that changing an allowance with this method brings the risk that someone may use both the old
183    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
184    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
185    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186    * @param _spender The address which will spend the funds.
187    * @param _value The amount of tokens to be spent.
188    */
189   function approve(address _spender, uint256 _value) public returns (bool) {
190     allowed[msg.sender][_spender] = _value;
191     Approval(msg.sender, _spender, _value);
192     return true;
193   }
194 
195   /**
196    * @dev Function to check the amount of tokens that an owner allowed to a spender.
197    * @param _owner address The address which owns the funds.
198    * @param _spender address The address which will spend the funds.
199    * @return A uint256 specifying the amount of tokens still available for the spender.
200    */
201   function allowance(address _owner, address _spender) public view returns (uint256) {
202     return allowed[_owner][_spender];
203   }
204 
205   /**
206    * @dev Increase the amount of tokens that an owner allowed to a spender.
207    *
208    * approve should be called when allowed[_spender] == 0. To increment
209    * allowed value is better to use this function to avoid 2 calls (and wait until
210    * the first transaction is mined)
211    * From MonolithDAO Token.sol
212    * @param _spender The address which will spend the funds.
213    * @param _addedValue The amount of tokens to increase the allowance by.
214    */
215   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
216     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
217     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
218     return true;
219   }
220 
221   /**
222    * @dev Decrease the amount of tokens that an owner allowed to a spender.
223    *
224    * approve should be called when allowed[_spender] == 0. To decrement
225    * allowed value is better to use this function to avoid 2 calls (and wait until
226    * the first transaction is mined)
227    * From MonolithDAO Token.sol
228    * @param _spender The address which will spend the funds.
229    * @param _subtractedValue The amount of tokens to decrease the allowance by.
230    */
231   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
232     uint oldValue = allowed[msg.sender][_spender];
233     if (_subtractedValue > oldValue) {
234       allowed[msg.sender][_spender] = 0;
235     } else {
236       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
237     }
238     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
239     return true;
240   }
241 
242 }
243 
244 contract ERC827 is ERC20 {
245 
246   function approve( address _spender, uint256 _value, bytes _data ) public returns (bool);
247   function transfer( address _to, uint256 _value, bytes _data ) public returns (bool);
248   function transferFrom( address _from, address _to, uint256 _value, bytes _data ) public returns (bool);
249 
250 }
251 
252 
253 contract ERC827Token is ERC827, StandardToken {
254 
255   /**
256      @dev Addition to ERC20 token methods. It allows to
257      approve the transfer of value and execute a call with the sent data.
258 
259      Beware that changing an allowance with this method brings the risk that
260      someone may use both the old and the new allowance by unfortunate
261      transaction ordering. One possible solution to mitigate this race condition
262      is to first reduce the spender's allowance to 0 and set the desired value
263      afterwards:
264      https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
265 
266      @param _spender The address that will spend the funds.
267      @param _value The amount of tokens to be spent.
268      @param _data ABI-encoded contract call to call `_to` address.
269 
270      @return true if the call function was executed successfully
271    */
272   function approve(address _spender, uint256 _value, bytes _data) public returns (bool) {
273     require(_spender != address(this));
274 
275     super.approve(_spender, _value);
276 
277     require(_spender.call(_data));
278 
279     return true;
280   }
281 
282   /**
283      @dev Addition to ERC20 token methods. Transfer tokens to a specified
284      address and execute a call with the sent data on the same transaction
285 
286      @param _to address The address which you want to transfer to
287      @param _value uint256 the amout of tokens to be transfered
288      @param _data ABI-encoded contract call to call `_to` address.
289 
290      @return true if the call function was executed successfully
291    */
292   function transfer(address _to, uint256 _value, bytes _data) public returns (bool) {
293     require(_to != address(this));
294 
295     super.transfer(_to, _value);
296 
297     require(_to.call(_data));
298     return true;
299   }
300 
301   /**
302      @dev Addition to ERC20 token methods. Transfer tokens from one address to
303      another and make a contract call on the same transaction
304 
305      @param _from The address which you want to send tokens from
306      @param _to The address which you want to transfer to
307      @param _value The amout of tokens to be transferred
308      @param _data ABI-encoded contract call to call `_to` address.
309 
310      @return true if the call function was executed successfully
311    */
312   function transferFrom(address _from, address _to, uint256 _value, bytes _data) public returns (bool) {
313     require(_to != address(this));
314 
315     super.transferFrom(_from, _to, _value);
316 
317     require(_to.call(_data));
318     return true;
319   }
320 
321   /**
322    * @dev Addition to StandardToken methods. Increase the amount of tokens that
323    * an owner allowed to a spender and execute a call with the sent data.
324    *
325    * approve should be called when allowed[_spender] == 0. To increment
326    * allowed value is better to use this function to avoid 2 calls (and wait until
327    * the first transaction is mined)
328    * From MonolithDAO Token.sol
329    * @param _spender The address which will spend the funds.
330    * @param _addedValue The amount of tokens to increase the allowance by.
331    * @param _data ABI-encoded contract call to call `_spender` address.
332    */
333   function increaseApproval(address _spender, uint _addedValue, bytes _data) public returns (bool) {
334     require(_spender != address(this));
335 
336     super.increaseApproval(_spender, _addedValue);
337 
338     require(_spender.call(_data));
339 
340     return true;
341   }
342 
343   /**
344    * @dev Addition to StandardToken methods. Decrease the amount of tokens that
345    * an owner allowed to a spender and execute a call with the sent data.
346    *
347    * approve should be called when allowed[_spender] == 0. To decrement
348    * allowed value is better to use this function to avoid 2 calls (and wait until
349    * the first transaction is mined)
350    * From MonolithDAO Token.sol
351    * @param _spender The address which will spend the funds.
352    * @param _subtractedValue The amount of tokens to decrease the allowance by.
353    * @param _data ABI-encoded contract call to call `_spender` address.
354    */
355   function decreaseApproval(address _spender, uint _subtractedValue, bytes _data) public returns (bool) {
356     require(_spender != address(this));
357 
358     super.decreaseApproval(_spender, _subtractedValue);
359 
360     require(_spender.call(_data));
361 
362     return true;
363   }
364 
365 }
366 
367 contract Recoverable is Ownable {
368 
369   /// @dev Empty constructor (for now)
370   constructor() public {
371   }
372 
373   /// @dev This will be invoked by the owner, when owner wants to rescue tokens
374   /// @param token Token which will we rescue to the owner from the contract
375   function recoverTokens(ERC20Basic token) onlyOwner public {
376     token.transfer(owner, tokensToBeReturned(token));
377   }
378 
379   /// @dev Interface function, can be overwritten by the superclass
380   /// @param token Token which balance we will check and return
381   /// @return The amount of tokens (in smallest denominator) the contract owns
382   function tokensToBeReturned(ERC20Basic token) public view returns (uint) {
383     return token.balanceOf(this);
384   }
385 }
386 
387 contract StandardTokenExt is StandardToken, ERC827Token, Recoverable {
388 
389   /* Interface declaration */
390   function isToken() public view returns (bool weAre) {
391     return true;
392   }
393 }
394 
395 contract BurnableToken is StandardTokenExt {
396 
397   // @notice An address for the transfer event where the burned tokens are transferred in a faux Transfer event
398   address public constant BURN_ADDRESS = 0;
399 
400   /** How many tokens we burned */
401   event Burned(address burner, uint burnedAmount);
402 
403   /**
404    * Burn extra tokens from a balance.
405    *
406    */
407   function burn(uint burnAmount) public {
408     address burner = msg.sender;
409     balances[burner] = balances[burner].sub(burnAmount);
410     totalSupply_ = totalSupply_.sub(burnAmount);
411     emit Burned(burner, burnAmount);
412 
413     // Inform the blockchain explores that track the
414     // balances only by a transfer event that the balance in this
415     // address has decreased
416     Transfer(burner, BURN_ADDRESS, burnAmount);
417   }
418 }
419 
420 contract ReleasableToken is StandardTokenExt {
421 
422   /* The finalizer contract that allows unlift the transfer limits on this token */
423   address public releaseAgent;
424 
425   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
426   bool public released = false;
427 
428   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
429   mapping (address => bool) public transferAgents;
430 
431   /**
432    * Limit token transfer until the crowdsale is over.
433    *
434    */
435   modifier canTransfer(address _sender) {
436 
437     if(!released) {
438       if(!transferAgents[_sender]) {
439         revert();
440       }
441     }
442 
443     _;
444   }
445 
446   /**
447    * Set the contract that can call release and make the token transferable.
448    *
449    * Design choice. Allow reset the release agent to fix fat finger mistakes.
450    */
451   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
452 
453     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
454     releaseAgent = addr;
455   }
456 
457   /**
458    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
459    */
460   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
461     transferAgents[addr] = state;
462   }
463 
464   /**
465    * One way function to release the tokens to the wild.
466    *
467    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
468    */
469   function releaseTokenTransfer() public onlyReleaseAgent {
470     released = true;
471   }
472 
473   /** The function can be called only before or after the tokens have been releasesd */
474   modifier inReleaseState(bool releaseState) {
475     if(releaseState != released) {
476       revert();
477     }
478     _;
479   }
480 
481   /** The function can be called only by a whitelisted release agent. */
482   modifier onlyReleaseAgent() {
483     if(msg.sender != releaseAgent) {
484       revert();
485     }
486     _;
487   }
488 
489   function transfer(address _to, uint _value) canTransfer(msg.sender) public returns (bool success) {
490     // Call StandardToken.transfer()
491     return super.transfer(_to, _value);
492   }
493 
494   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) public returns (bool success) {
495     // Call StandardToken.transferForm()
496     return super.transferFrom(_from, _to, _value);
497   }
498 
499 }
500 
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
514 contract UpgradeableToken is StandardTokenExt {
515 
516   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
517   address public upgradeMaster;
518 
519   /** The next contract where the tokens will be migrated. */
520   UpgradeAgent public upgradeAgent;
521 
522   /** How many tokens we have upgraded by now. */
523   uint256 public totalUpgraded;
524 
525   /**
526    * Upgrade states.
527    *
528    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
529    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
530    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
531    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
532    *
533    */
534   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
535 
536   /**
537    * Somebody has upgraded some of his tokens.
538    */
539   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
540 
541   /**
542    * New upgrade agent available.
543    */
544   event UpgradeAgentSet(address agent);
545 
546   /**
547    * Do not allow construction without upgrade master set.
548    */
549   function UpgradeableToken(address _upgradeMaster) public {
550     upgradeMaster = _upgradeMaster;
551   }
552 
553   /**
554    * Allow the token holder to upgrade some of their tokens to a new contract.
555    */
556   function upgrade(uint256 value) public {
557 
558     UpgradeState state = getUpgradeState();
559     if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
560       // Called in a bad state
561       revert();
562     }
563 
564     // Validate input value.
565     if (value == 0) revert();
566 
567     balances[msg.sender] = balances[msg.sender].sub(value);
568 
569     // Take tokens out from circulation
570     totalSupply_ = totalSupply_.sub(value);
571     totalUpgraded = totalUpgraded.add(value);
572 
573     // Upgrade agent reissues the tokens
574     upgradeAgent.upgradeFrom(msg.sender, value);
575     emit Upgrade(msg.sender, upgradeAgent, value);
576   }
577 
578   /**
579    * Set an upgrade agent that handles
580    */
581   function setUpgradeAgent(address agent) external {
582 
583     if(!canUpgrade()) {
584       // The token is not yet in a state that we could think upgrading
585       revert();
586     }
587 
588     if (agent == 0x0) revert();
589     // Only a master can designate the next agent
590     if (msg.sender != upgradeMaster) revert();
591     // Upgrade has already begun for an agent
592     if (getUpgradeState() == UpgradeState.Upgrading) revert();
593 
594     upgradeAgent = UpgradeAgent(agent);
595 
596     // Bad interface
597     if(!upgradeAgent.isUpgradeAgent()) revert();
598     // Make sure that token supplies match in source and target
599     if (upgradeAgent.originalSupply() != totalSupply_) revert();
600 
601     emit UpgradeAgentSet(upgradeAgent);
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
620     if (master == 0x0) revert();
621     if (msg.sender != upgradeMaster) revert();
622     upgradeMaster = master;
623   }
624 
625   /**
626    * Child contract can enable to provide the condition when the upgrade can begun.
627    */
628   function canUpgrade() public view returns(bool) {
629     return true;
630   }
631 
632 }
633 
634 contract MintableToken is StandardTokenExt {
635 
636   using SafeMath for uint;
637 
638   bool public mintingFinished = false;
639 
640   /** List of agents that are allowed to create new tokens */
641   mapping (address => bool) public mintAgents;
642 
643   event MintingAgentChanged(address addr, bool state);
644   event Minted(address receiver, uint amount);
645 
646   /**
647    * Create new tokens and allocate them to an address..
648    *
649    * Only callably by a crowdsale contract (mint agent).
650    */
651   function mint(address receiver, uint amount) onlyMintAgent canMint public {
652     totalSupply_ = totalSupply_.plus(amount);
653     balances[receiver] = balances[receiver].plus(amount);
654 
655     // This will make the mint transaction apper in EtherScan.io
656     // We can remove this after there is a standardized minting event
657     emit Transfer(0, receiver, amount);
658   }
659 
660   /**
661    * Owner can allow a crowdsale contract to mint new tokens.
662    */
663   function setMintAgent(address addr, bool state) onlyOwner canMint public {
664     mintAgents[addr] = state;
665     emit MintingAgentChanged(addr, state);
666   }
667 
668   modifier onlyMintAgent() {
669     // Only crowdsale contracts are allowed to mint new tokens
670     if(!mintAgents[msg.sender]) {
671       revert();
672     }
673     _;
674   }
675 
676   /** Make sure we are not done yet. */
677   modifier canMint() {
678     if(mintingFinished) revert();
679     _;
680   }
681 }
682 
683 
684 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
685 
686   /** Name and symbol were updated. */
687   event UpdatedTokenInformation(string newName, string newSymbol);
688 
689   string public name;
690 
691   string public symbol;
692 
693   uint public decimals;
694 
695   /**
696    * Construct the token.
697    *
698    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
699    *
700    * @param _name Token name
701    * @param _symbol Token symbol - should be all caps
702    * @param _initialSupply How many tokens we start with
703    * @param _decimals Number of decimal places
704    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
705    */
706   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
707     UpgradeableToken(msg.sender) public {
708 
709     // Create any address, can be transferred
710     // to team multisig via changeOwner(),
711     // also remember to call setUpgradeMaster()
712     owner = msg.sender;
713 
714     name = _name;
715     symbol = _symbol;
716 
717     totalSupply_ = _initialSupply;
718 
719     decimals = _decimals;
720 
721     // Create initially all balance on the team multisig
722     balances[owner] = totalSupply_;
723 
724     if(totalSupply_ > 0) {
725       Minted(owner, totalSupply_);
726     }
727 
728     // No more new supply allowed after the token creation
729     if(!_mintable) {
730       mintingFinished = true;
731       if(totalSupply_ == 0) {
732         revert(); // Cannot create a token without supply and no minting
733       }
734     }
735   }
736 
737   /**
738    * When token is released to be transferable, enforce no new tokens can be created.
739    */
740   function releaseTokenTransfer() public onlyReleaseAgent {
741     mintingFinished = true;
742     super.releaseTokenTransfer();
743   }
744 
745   /**
746    * Allow upgrade agent functionality kick in only if the crowdsale was success.
747    */
748   function canUpgrade() public constant returns(bool) {
749     return released && super.canUpgrade();
750   }
751 
752   /**
753    * Owner can update token information here.
754    *
755    * It is often useful to conceal the actual token association, until
756    * the token operations, like central issuance or reissuance have been completed.
757    *
758    * This function allows the token owner to rename the token after the operations
759    * have been completed and then point the audience to use the token contract.
760    */
761   function setTokenInformation(string _name, string _symbol) onlyOwner public {
762     name = _name;
763     symbol = _symbol;
764 
765     emit UpdatedTokenInformation(name, symbol);
766   }
767 
768 }
769 
770 contract Pausable is Ownable {
771   event Pause();
772   event Unpause();
773 
774   bool public paused = false;
775 
776 
777   /**
778    * @dev Modifier to make a function callable only when the contract is not paused.
779    */
780   modifier whenNotPaused() {
781     require(!paused);
782     _;
783   }
784 
785   /**
786    * @dev Modifier to make a function callable only when the contract is paused.
787    */
788   modifier whenPaused() {
789     require(paused);
790     _;
791   }
792 
793   /**
794    * @dev called by the owner to pause, triggers stopped state
795    */
796   function pause() onlyOwner whenNotPaused public {
797     paused = true;
798     emit Pause();
799   }
800 
801   /**
802    * @dev called by the owner to unpause, returns to normal state
803    */
804   function unpause() onlyOwner whenPaused public {
805     paused = false;
806     emit Unpause();
807   }
808 }
809 
810 contract PausableToken is StandardToken, Pausable {
811 
812   function transfer(
813     address _to,
814     uint256 _value
815   )
816     public
817     whenNotPaused
818     returns (bool)
819   {
820     return super.transfer(_to, _value);
821   }
822 
823   function transferFrom(
824     address _from,
825     address _to,
826     uint256 _value
827   )
828     public
829     whenNotPaused
830     returns (bool)
831   {
832     return super.transferFrom(_from, _to, _value);
833   }
834 
835   function approve(
836     address _spender,
837     uint256 _value
838   )
839     public
840     whenNotPaused
841     returns (bool)
842   {
843     return super.approve(_spender, _value);
844   }
845 
846   function increaseApproval(
847     address _spender,
848     uint _addedValue
849   )
850     public
851     whenNotPaused
852     returns (bool success)
853   {
854     return super.increaseApproval(_spender, _addedValue);
855   }
856 
857   function decreaseApproval(
858     address _spender,
859     uint _subtractedValue
860   )
861     public
862     whenNotPaused
863     returns (bool success)
864   {
865     return super.decreaseApproval(_spender, _subtractedValue);
866   }
867 }
868 /**
869  * A crowdsaled token that you can also burn.
870  *
871  */
872 contract HoardCrowdsaleToken is BurnableToken, CrowdsaleToken, PausableToken {
873 
874   function HoardCrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
875     CrowdsaleToken(_name, _symbol, _initialSupply, _decimals, _mintable) public {
876 
877   }
878 }