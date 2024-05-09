1 /**
2  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
3  *
4  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
5  */
6 
7 
8 /**
9  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
10  *
11  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
12  */
13 
14 
15 /**
16  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
17  *
18  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
19  */
20 
21 
22 
23 
24 
25 
26 
27 
28 /**
29  * @title ERC20Basic
30  * @dev Simpler version of ERC20 interface
31  * @dev see https://github.com/ethereum/EIPs/issues/179
32  */
33 contract ERC20Basic {
34   uint256 public totalSupply;
35   function balanceOf(address who) constant returns (uint256);
36   function transfer(address to, uint256 value) returns (bool);
37   event Transfer(address indexed from, address indexed to, uint256 value);
38 }
39 
40 
41 
42 /**
43  * @title SafeMath
44  * @dev Math operations with safety checks that throw on error
45  */
46 library SafeMath {
47   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
48     uint256 c = a * b;
49     assert(a == 0 || c / a == b);
50     return c;
51   }
52 
53   function div(uint256 a, uint256 b) internal constant returns (uint256) {
54     // assert(b > 0); // Solidity automatically throws when dividing by 0
55     uint256 c = a / b;
56     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
57     return c;
58   }
59 
60   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
61     assert(b <= a);
62     return a - b;
63   }
64 
65   function add(uint256 a, uint256 b) internal constant returns (uint256) {
66     uint256 c = a + b;
67     assert(c >= a);
68     return c;
69   }
70 }
71 
72 
73 
74 /**
75  * @title Basic token
76  * @dev Basic version of StandardToken, with no allowances. 
77  */
78 contract BasicToken is ERC20Basic {
79   using SafeMath for uint256;
80 
81   mapping(address => uint256) balances;
82 
83   /**
84   * @dev transfer token for a specified address
85   * @param _to The address to transfer to.
86   * @param _value The amount to be transferred.
87   */
88   function transfer(address _to, uint256 _value) returns (bool) {
89     balances[msg.sender] = balances[msg.sender].sub(_value);
90     balances[_to] = balances[_to].add(_value);
91     Transfer(msg.sender, _to, _value);
92     return true;
93   }
94 
95   /**
96   * @dev Gets the balance of the specified address.
97   * @param _owner The address to query the the balance of. 
98   * @return An uint256 representing the amount owned by the passed address.
99   */
100   function balanceOf(address _owner) constant returns (uint256 balance) {
101     return balances[_owner];
102   }
103 
104 }
105 
106 
107 
108 
109 
110 
111 /**
112  * @title ERC20 interface
113  * @dev see https://github.com/ethereum/EIPs/issues/20
114  */
115 contract ERC20 is ERC20Basic {
116   function allowance(address owner, address spender) constant returns (uint256);
117   function transferFrom(address from, address to, uint256 value) returns (bool);
118   function approve(address spender, uint256 value) returns (bool);
119   event Approval(address indexed owner, address indexed spender, uint256 value);
120 }
121 
122 
123 
124 /**
125  * @title Standard ERC20 token
126  *
127  * @dev Implementation of the basic standard token.
128  * @dev https://github.com/ethereum/EIPs/issues/20
129  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
130  */
131 contract StandardToken is ERC20, BasicToken {
132 
133   mapping (address => mapping (address => uint256)) allowed;
134 
135 
136   /**
137    * @dev Transfer tokens from one address to another
138    * @param _from address The address which you want to send tokens from
139    * @param _to address The address which you want to transfer to
140    * @param _value uint256 the amout of tokens to be transfered
141    */
142   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
143     var _allowance = allowed[_from][msg.sender];
144 
145     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
146     // require (_value <= _allowance);
147 
148     balances[_to] = balances[_to].add(_value);
149     balances[_from] = balances[_from].sub(_value);
150     allowed[_from][msg.sender] = _allowance.sub(_value);
151     Transfer(_from, _to, _value);
152     return true;
153   }
154 
155   /**
156    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
157    * @param _spender The address which will spend the funds.
158    * @param _value The amount of tokens to be spent.
159    */
160   function approve(address _spender, uint256 _value) returns (bool) {
161 
162     // To change the approve amount you first have to reduce the addresses`
163     //  allowance to zero by calling `approve(_spender, 0)` if it is not
164     //  already 0 to mitigate the race condition described here:
165     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
166     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
167 
168     allowed[msg.sender][_spender] = _value;
169     Approval(msg.sender, _spender, _value);
170     return true;
171   }
172 
173   /**
174    * @dev Function to check the amount of tokens that an owner allowed to a spender.
175    * @param _owner address The address which owns the funds.
176    * @param _spender address The address which will spend the funds.
177    * @return A uint256 specifing the amount of tokens still available for the spender.
178    */
179   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
180     return allowed[_owner][_spender];
181   }
182 
183 }
184 
185 
186 
187 /**
188  * Standard EIP-20 token with an interface marker.
189  *
190  * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.
191  *
192  */
193 contract StandardTokenExt is StandardToken {
194 
195   /* Interface declaration */
196   function isToken() public constant returns (bool weAre) {
197     return true;
198   }
199 }
200 
201 
202 contract BurnableToken is StandardTokenExt {
203 
204   // @notice An address for the transfer event where the burned tokens are transferred in a faux Transfer event
205   address public constant BURN_ADDRESS = 0;
206 
207   /** How many tokens we burned */
208   event Burned(address burner, uint burnedAmount);
209 
210   /**
211    * Burn extra tokens from a balance.
212    *
213    */
214   function burn(uint burnAmount) {
215     address burner = msg.sender;
216     balances[burner] = balances[burner].sub(burnAmount);
217     totalSupply = totalSupply.sub(burnAmount);
218     Burned(burner, burnAmount);
219 
220     // Inform the blockchain explores that track the
221     // balances only by a transfer event that the balance in this
222     // address has decreased
223     Transfer(burner, BURN_ADDRESS, burnAmount);
224   }
225 }
226 
227 /**
228  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
229  *
230  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
231  */
232 
233 
234 /**
235  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
236  *
237  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
238  */
239 
240 
241 
242 
243 /**
244  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
245  *
246  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
247  */
248 
249 
250 /**
251  * Upgrade agent interface inspired by Lunyr.
252  *
253  * Upgrade agent transfers tokens to a new contract.
254  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
255  */
256 contract UpgradeAgent {
257 
258   uint public originalSupply;
259 
260   /** Interface marker */
261   function isUpgradeAgent() public constant returns (bool) {
262     return true;
263   }
264 
265   function upgradeFrom(address _from, uint256 _value) public;
266 
267 }
268 
269 
270 /**
271  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
272  *
273  * First envisioned by Golem and Lunyr projects.
274  */
275 contract UpgradeableToken is StandardTokenExt {
276 
277   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
278   address public upgradeMaster;
279 
280   /** The next contract where the tokens will be migrated. */
281   UpgradeAgent public upgradeAgent;
282 
283   /** How many tokens we have upgraded by now. */
284   uint256 public totalUpgraded;
285 
286   /**
287    * Upgrade states.
288    *
289    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
290    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
291    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
292    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
293    *
294    */
295   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
296 
297   /**
298    * Somebody has upgraded some of his tokens.
299    */
300   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
301 
302   /**
303    * New upgrade agent available.
304    */
305   event UpgradeAgentSet(address agent);
306 
307   /**
308    * Do not allow construction without upgrade master set.
309    */
310   function UpgradeableToken(address _upgradeMaster) {
311     upgradeMaster = _upgradeMaster;
312   }
313 
314   /**
315    * Allow the token holder to upgrade some of their tokens to a new contract.
316    */
317   function upgrade(uint256 value) public {
318 
319       UpgradeState state = getUpgradeState();
320       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
321         // Called in a bad state
322         throw;
323       }
324 
325       // Validate input value.
326       if (value == 0) throw;
327 
328       balances[msg.sender] = balances[msg.sender].sub(value);
329 
330       // Take tokens out from circulation
331       totalSupply = totalSupply.sub(value);
332       totalUpgraded = totalUpgraded.add(value);
333 
334       // Upgrade agent reissues the tokens
335       upgradeAgent.upgradeFrom(msg.sender, value);
336       Upgrade(msg.sender, upgradeAgent, value);
337   }
338 
339   /**
340    * Set an upgrade agent that handles
341    */
342   function setUpgradeAgent(address agent) external {
343 
344       if(!canUpgrade()) {
345         // The token is not yet in a state that we could think upgrading
346         throw;
347       }
348 
349       if (agent == 0x0) throw;
350       // Only a master can designate the next agent
351       if (msg.sender != upgradeMaster) throw;
352       // Upgrade has already begun for an agent
353       if (getUpgradeState() == UpgradeState.Upgrading) throw;
354 
355       upgradeAgent = UpgradeAgent(agent);
356 
357       // Bad interface
358       if(!upgradeAgent.isUpgradeAgent()) throw;
359       // Make sure that token supplies match in source and target
360       if (upgradeAgent.originalSupply() != totalSupply) throw;
361 
362       UpgradeAgentSet(upgradeAgent);
363   }
364 
365   /**
366    * Get the state of the token upgrade.
367    */
368   function getUpgradeState() public constant returns(UpgradeState) {
369     if(!canUpgrade()) return UpgradeState.NotAllowed;
370     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
371     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
372     else return UpgradeState.Upgrading;
373   }
374 
375   /**
376    * Change the upgrade master.
377    *
378    * This allows us to set a new owner for the upgrade mechanism.
379    */
380   function setUpgradeMaster(address master) public {
381       if (master == 0x0) throw;
382       if (msg.sender != upgradeMaster) throw;
383       upgradeMaster = master;
384   }
385 
386   /**
387    * Child contract can enable to provide the condition when the upgrade can begun.
388    */
389   function canUpgrade() public constant returns(bool) {
390      return true;
391   }
392 
393 }
394 
395 /**
396  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
397  *
398  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
399  */
400 
401 
402 
403 
404 /**
405  * @title Ownable
406  * @dev The Ownable contract has an owner address, and provides basic authorization control
407  * functions, this simplifies the implementation of "user permissions".
408  */
409 contract Ownable {
410   address public owner;
411 
412 
413   /**
414    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
415    * account.
416    */
417   function Ownable() {
418     owner = msg.sender;
419   }
420 
421 
422   /**
423    * @dev Throws if called by any account other than the owner.
424    */
425   modifier onlyOwner() {
426     require(msg.sender == owner);
427     _;
428   }
429 
430 
431   /**
432    * @dev Allows the current owner to transfer control of the contract to a newOwner.
433    * @param newOwner The address to transfer ownership to.
434    */
435   function transferOwnership(address newOwner) onlyOwner {
436     require(newOwner != address(0));      
437     owner = newOwner;
438   }
439 
440 }
441 
442 
443 
444 
445 /**
446  * Define interface for releasing the token transfer after a successful crowdsale.
447  */
448 contract ReleasableToken is ERC20, Ownable {
449 
450   /* The finalizer contract that allows unlift the transfer limits on this token */
451   address public releaseAgent;
452 
453   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
454   bool public released = false;
455 
456   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
457   mapping (address => bool) public transferAgents;
458 
459   /**
460    * Limit token transfer until the crowdsale is over.
461    *
462    */
463   modifier canTransfer(address _sender) {
464 
465     if(!released) {
466         if(!transferAgents[_sender]) {
467             throw;
468         }
469     }
470 
471     _;
472   }
473 
474   /**
475    * Set the contract that can call release and make the token transferable.
476    *
477    * Design choice. Allow reset the release agent to fix fat finger mistakes.
478    */
479   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
480 
481     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
482     releaseAgent = addr;
483   }
484 
485   /**
486    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
487    */
488   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
489     transferAgents[addr] = state;
490   }
491 
492   /**
493    * One way function to release the tokens to the wild.
494    *
495    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
496    */
497   function releaseTokenTransfer() public onlyReleaseAgent {
498     released = true;
499   }
500 
501   /** The function can be called only before or after the tokens have been releasesd */
502   modifier inReleaseState(bool releaseState) {
503     if(releaseState != released) {
504         throw;
505     }
506     _;
507   }
508 
509   /** The function can be called only by a whitelisted release agent. */
510   modifier onlyReleaseAgent() {
511     if(msg.sender != releaseAgent) {
512         throw;
513     }
514     _;
515   }
516 
517   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
518     // Call StandardToken.transfer()
519    return super.transfer(_to, _value);
520   }
521 
522   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
523     // Call StandardToken.transferForm()
524     return super.transferFrom(_from, _to, _value);
525   }
526 
527 }
528 
529 /**
530  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
531  *
532  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
533  */
534 
535 
536 
537 
538 /**
539  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
540  *
541  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
542  */
543 
544 
545 /**
546  * Safe unsigned safe math.
547  *
548  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
549  *
550  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
551  *
552  * Maintained here until merged to mainline zeppelin-solidity.
553  *
554  */
555 library SafeMathLib {
556 
557   function times(uint a, uint b) returns (uint) {
558     uint c = a * b;
559     assert(a == 0 || c / a == b);
560     return c;
561   }
562 
563   function minus(uint a, uint b) returns (uint) {
564     assert(b <= a);
565     return a - b;
566   }
567 
568   function plus(uint a, uint b) returns (uint) {
569     uint c = a + b;
570     assert(c>=a);
571     return c;
572   }
573 
574 }
575 
576 
577 
578 /**
579  * A token that can increase its supply by another contract.
580  *
581  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
582  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
583  *
584  */
585 contract MintableToken is StandardTokenExt, Ownable {
586 
587   using SafeMathLib for uint;
588 
589   bool public mintingFinished = false;
590 
591   /** List of agents that are allowed to create new tokens */
592   mapping (address => bool) public mintAgents;
593 
594   event MintingAgentChanged(address addr, bool state);
595   event Minted(address receiver, uint amount);
596 
597   /**
598    * Create new tokens and allocate them to an address..
599    *
600    * Only callably by a crowdsale contract (mint agent).
601    */
602   function mint(address receiver, uint amount) onlyMintAgent canMint public {
603     totalSupply = totalSupply.plus(amount);
604     balances[receiver] = balances[receiver].plus(amount);
605 
606     // This will make the mint transaction apper in EtherScan.io
607     // We can remove this after there is a standardized minting event
608     Transfer(0, receiver, amount);
609   }
610 
611   /**
612    * Owner can allow a crowdsale contract to mint new tokens.
613    */
614   function setMintAgent(address addr, bool state) onlyOwner canMint public {
615     mintAgents[addr] = state;
616     MintingAgentChanged(addr, state);
617   }
618 
619   modifier onlyMintAgent() {
620     // Only crowdsale contracts are allowed to mint new tokens
621     if(!mintAgents[msg.sender]) {
622         throw;
623     }
624     _;
625   }
626 
627   /** Make sure we are not done yet. */
628   modifier canMint() {
629     if(mintingFinished) throw;
630     _;
631   }
632 }
633 
634 
635 
636 /**
637  * A crowdsaled token.
638  *
639  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
640  *
641  * - The token transfer() is disabled until the crowdsale is over
642  * - The token contract gives an opt-in upgrade path to a new contract
643  * - The same token can be part of several crowdsales through approve() mechanism
644  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
645  *
646  */
647 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
648 
649   /** Name and symbol were updated. */
650   event UpdatedTokenInformation(string newName, string newSymbol);
651 
652   string public name;
653 
654   string public symbol;
655 
656   uint public decimals;
657 
658   /**
659    * Construct the token.
660    *
661    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
662    *
663    * @param _name Token name
664    * @param _symbol Token symbol - should be all caps
665    * @param _initialSupply How many tokens we start with
666    * @param _decimals Number of decimal places
667    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
668    */
669   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
670     UpgradeableToken(msg.sender) {
671 
672     // Create any address, can be transferred
673     // to team multisig via changeOwner(),
674     // also remember to call setUpgradeMaster()
675     owner = msg.sender;
676 
677     name = _name;
678     symbol = _symbol;
679 
680     totalSupply = _initialSupply;
681 
682     decimals = _decimals;
683 
684     // Create initially all balance on the team multisig
685     balances[owner] = totalSupply;
686 
687     if(totalSupply > 0) {
688       Minted(owner, totalSupply);
689     }
690 
691     // No more new supply allowed after the token creation
692     if(!_mintable) {
693       mintingFinished = true;
694       if(totalSupply == 0) {
695         throw; // Cannot create a token without supply and no minting
696       }
697     }
698   }
699 
700   /**
701    * When token is released to be transferable, enforce no new tokens can be created.
702    */
703   function releaseTokenTransfer() public onlyReleaseAgent {
704     mintingFinished = true;
705     super.releaseTokenTransfer();
706   }
707 
708   /**
709    * Allow upgrade agent functionality kick in only if the crowdsale was success.
710    */
711   function canUpgrade() public constant returns(bool) {
712     return released && super.canUpgrade();
713   }
714 
715   /**
716    * Owner can update token information here.
717    *
718    * It is often useful to conceal the actual token association, until
719    * the token operations, like central issuance or reissuance have been completed.
720    *
721    * This function allows the token owner to rename the token after the operations
722    * have been completed and then point the audience to use the token contract.
723    */
724   function setTokenInformation(string _name, string _symbol) onlyOwner {
725     name = _name;
726     symbol = _symbol;
727 
728     UpdatedTokenInformation(name, symbol);
729   }
730 
731 }
732 
733 
734 /**
735  * A crowdsaled token that you can also burn.
736  *
737  */
738 contract BurnableCrowdsaleToken is BurnableToken, CrowdsaleToken {
739 
740   function BurnableCrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
741     CrowdsaleToken(_name, _symbol, _initialSupply, _decimals, _mintable) {
742 
743   }
744 }