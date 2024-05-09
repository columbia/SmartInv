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
15 
16 
17 
18 
19 /**
20  * @title ERC20Basic
21  * @dev Simpler version of ERC20 interface
22  * @dev see https://github.com/ethereum/EIPs/issues/179
23  */
24 contract ERC20Basic {
25   uint256 public totalSupply;
26   function balanceOf(address who) constant returns (uint256);
27   function transfer(address to, uint256 value) returns (bool);
28   event Transfer(address indexed from, address indexed to, uint256 value);
29 }
30 
31 
32 
33 /**
34  * @title ERC20 interface
35  * @dev see https://github.com/ethereum/EIPs/issues/20
36  */
37 contract ERC20 is ERC20Basic {
38   function allowance(address owner, address spender) constant returns (uint256);
39   function transferFrom(address from, address to, uint256 value) returns (bool);
40   function approve(address spender, uint256 value) returns (bool);
41   event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43 
44 /**
45  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
46  *
47  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
48  */
49 
50 
51 
52 
53 
54 
55 
56 
57 
58 /**
59  * @title SafeMath
60  * @dev Math operations with safety checks that throw on error
61  */
62 library SafeMath {
63   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
64     uint256 c = a * b;
65     assert(a == 0 || c / a == b);
66     return c;
67   }
68 
69   function div(uint256 a, uint256 b) internal constant returns (uint256) {
70     // assert(b > 0); // Solidity automatically throws when dividing by 0
71     uint256 c = a / b;
72     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
73     return c;
74   }
75 
76   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   function add(uint256 a, uint256 b) internal constant returns (uint256) {
82     uint256 c = a + b;
83     assert(c >= a);
84     return c;
85   }
86 }
87 
88 
89 
90 /**
91  * @title Basic token
92  * @dev Basic version of StandardToken, with no allowances. 
93  */
94 contract BasicToken is ERC20Basic {
95   using SafeMath for uint256;
96 
97   mapping(address => uint256) balances;
98 
99   /**
100   * @dev transfer token for a specified address
101   * @param _to The address to transfer to.
102   * @param _value The amount to be transferred.
103   */
104   function transfer(address _to, uint256 _value) returns (bool) {
105     balances[msg.sender] = balances[msg.sender].sub(_value);
106     balances[_to] = balances[_to].add(_value);
107     Transfer(msg.sender, _to, _value);
108     return true;
109   }
110 
111   /**
112   * @dev Gets the balance of the specified address.
113   * @param _owner The address to query the the balance of. 
114   * @return An uint256 representing the amount owned by the passed address.
115   */
116   function balanceOf(address _owner) constant returns (uint256 balance) {
117     return balances[_owner];
118   }
119 
120 }
121 
122 
123 
124 
125 /**
126  * @title Standard ERC20 token
127  *
128  * @dev Implementation of the basic standard token.
129  * @dev https://github.com/ethereum/EIPs/issues/20
130  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
131  */
132 contract StandardToken is ERC20, BasicToken {
133 
134   mapping (address => mapping (address => uint256)) allowed;
135 
136 
137   /**
138    * @dev Transfer tokens from one address to another
139    * @param _from address The address which you want to send tokens from
140    * @param _to address The address which you want to transfer to
141    * @param _value uint256 the amout of tokens to be transfered
142    */
143   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
144     var _allowance = allowed[_from][msg.sender];
145 
146     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
147     // require (_value <= _allowance);
148 
149     balances[_to] = balances[_to].add(_value);
150     balances[_from] = balances[_from].sub(_value);
151     allowed[_from][msg.sender] = _allowance.sub(_value);
152     Transfer(_from, _to, _value);
153     return true;
154   }
155 
156   /**
157    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
158    * @param _spender The address which will spend the funds.
159    * @param _value The amount of tokens to be spent.
160    */
161   function approve(address _spender, uint256 _value) returns (bool) {
162 
163     // To change the approve amount you first have to reduce the addresses`
164     //  allowance to zero by calling `approve(_spender, 0)` if it is not
165     //  already 0 to mitigate the race condition described here:
166     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
168 
169     allowed[msg.sender][_spender] = _value;
170     Approval(msg.sender, _spender, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Function to check the amount of tokens that an owner allowed to a spender.
176    * @param _owner address The address which owns the funds.
177    * @param _spender address The address which will spend the funds.
178    * @return A uint256 specifing the amount of tokens still available for the spender.
179    */
180   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
181     return allowed[_owner][_spender];
182   }
183 
184 }
185 
186 /**
187  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
188  *
189  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
190  */
191 
192 
193 
194 
195 /**
196  * @title Ownable
197  * @dev The Ownable contract has an owner address, and provides basic authorization control
198  * functions, this simplifies the implementation of "user permissions".
199  */
200 contract Ownable {
201   address public owner;
202 
203 
204   /**
205    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
206    * account.
207    */
208   function Ownable() {
209     owner = msg.sender;
210   }
211 
212 
213   /**
214    * @dev Throws if called by any account other than the owner.
215    */
216   modifier onlyOwner() {
217     require(msg.sender == owner);
218     _;
219   }
220 
221 
222   /**
223    * @dev Allows the current owner to transfer control of the contract to a newOwner.
224    * @param newOwner The address to transfer ownership to.
225    */
226   function transferOwnership(address newOwner) onlyOwner {
227     require(newOwner != address(0));      
228     owner = newOwner;
229   }
230 
231 }
232 
233 
234 
235 contract Recoverable is Ownable {
236 
237   /// @dev Empty constructor (for now)
238   function Recoverable() {
239   }
240 
241   /// @dev This will be invoked by the owner, when owner wants to rescue tokens
242   /// @param token Token which will we rescue to the owner from the contract
243   function recoverTokens(ERC20Basic token) onlyOwner public {
244     token.transfer(owner, tokensToBeReturned(token));
245   }
246 
247   /// @dev Interface function, can be overwritten by the superclass
248   /// @param token Token which balance we will check and return
249   /// @return The amount of tokens (in smallest denominator) the contract owns
250   function tokensToBeReturned(ERC20Basic token) public returns (uint) {
251     return token.balanceOf(this);
252   }
253 
254   /// @dev This will be invoked by the owner, when owner wants to rescue ethers
255   function recoverEthers() onlyOwner public {
256     owner.transfer(this.balance);
257   }
258 }
259 
260 
261 
262 /**
263  * Standard EIP-20 token with an interface marker.
264  *
265  * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.
266  *
267  */
268 contract StandardTokenExt is Recoverable, StandardToken {
269 
270   /* Interface declaration */
271   function isToken() public constant returns (bool weAre) {
272     return true;
273   }
274 }
275 
276 /**
277  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
278  *
279  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
280  */
281 
282 
283 /**
284  * Upgrade agent interface inspired by Lunyr.
285  *
286  * Upgrade agent transfers tokens to a new contract.
287  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
288  */
289 contract UpgradeAgent {
290 
291   uint public originalSupply;
292 
293   /** Interface marker */
294   function isUpgradeAgent() public constant returns (bool) {
295     return true;
296   }
297 
298   function upgradeFrom(address _from, uint256 _value) public;
299 
300 }
301 
302 
303 /**
304  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
305  *
306  * First envisioned by Golem and Lunyr projects.
307  */
308 contract UpgradeableToken is StandardTokenExt {
309 
310   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
311   address public upgradeMaster;
312 
313   /** The next contract where the tokens will be migrated. */
314   UpgradeAgent public upgradeAgent;
315 
316   /** How many tokens we have upgraded by now. */
317   uint256 public totalUpgraded;
318 
319   /**
320    * Upgrade states.
321    *
322    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
323    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
324    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
325    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
326    *
327    */
328   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
329 
330   /**
331    * Somebody has upgraded some of his tokens.
332    */
333   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
334 
335   /**
336    * New upgrade agent available.
337    */
338   event UpgradeAgentSet(address agent);
339 
340   /**
341    * Do not allow construction without upgrade master set.
342    */
343   function UpgradeableToken(address _upgradeMaster) {
344     upgradeMaster = _upgradeMaster;
345   }
346 
347   /**
348    * Allow the token holder to upgrade some of their tokens to a new contract.
349    */
350   function upgrade(uint256 value) public {
351 
352       UpgradeState state = getUpgradeState();
353       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
354         // Called in a bad state
355         throw;
356       }
357 
358       // Validate input value.
359       if (value == 0) throw;
360 
361       balances[msg.sender] = balances[msg.sender].sub(value);
362 
363       // Take tokens out from circulation
364       totalSupply = totalSupply.sub(value);
365       totalUpgraded = totalUpgraded.add(value);
366 
367       // Upgrade agent reissues the tokens
368       upgradeAgent.upgradeFrom(msg.sender, value);
369       Upgrade(msg.sender, upgradeAgent, value);
370   }
371 
372   /**
373    * Set an upgrade agent that handles
374    */
375   function setUpgradeAgent(address agent) external {
376 
377       if(!canUpgrade()) {
378         // The token is not yet in a state that we could think upgrading
379         throw;
380       }
381 
382       if (agent == 0x0) throw;
383       // Only a master can designate the next agent
384       if (msg.sender != upgradeMaster) throw;
385       // Upgrade has already begun for an agent
386       if (getUpgradeState() == UpgradeState.Upgrading) throw;
387 
388       upgradeAgent = UpgradeAgent(agent);
389 
390       // Bad interface
391       if(!upgradeAgent.isUpgradeAgent()) throw;
392       // Make sure that token supplies match in source and target
393       if (upgradeAgent.originalSupply() != totalSupply) throw;
394 
395       UpgradeAgentSet(upgradeAgent);
396   }
397 
398   /**
399    * Get the state of the token upgrade.
400    */
401   function getUpgradeState() public constant returns(UpgradeState) {
402     if(!canUpgrade()) return UpgradeState.NotAllowed;
403     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
404     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
405     else return UpgradeState.Upgrading;
406   }
407 
408   /**
409    * Change the upgrade master.
410    *
411    * This allows us to set a new owner for the upgrade mechanism.
412    */
413   function setUpgradeMaster(address master) public {
414       if (master == 0x0) throw;
415       if (msg.sender != upgradeMaster) throw;
416       upgradeMaster = master;
417   }
418 
419   /**
420    * Child contract can enable to provide the condition when the upgrade can begun.
421    */
422   function canUpgrade() public constant returns(bool) {
423      return true;
424   }
425 
426 }
427 
428 /**
429  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
430  *
431  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
432  */
433 
434 
435 
436 
437 
438 /**
439  * Define interface for releasing the token transfer after a successful crowdsale.
440  */
441 contract ReleasableToken is StandardTokenExt {
442 
443   /* The finalizer contract that allows unlift the transfer limits on this token */
444   address public releaseAgent;
445 
446   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
447   bool public released = false;
448 
449   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
450   mapping (address => bool) public transferAgents;
451 
452   /**
453    * Limit token transfer until the crowdsale is over.
454    *
455    */
456   modifier canTransfer(address _sender) {
457 
458     if(!released) {
459         if(!transferAgents[_sender]) {
460             throw;
461         }
462     }
463 
464     _;
465   }
466 
467   /**
468    * Set the contract that can call release and make the token transferable.
469    *
470    * Design choice. Allow reset the release agent to fix fat finger mistakes.
471    */
472   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
473 
474     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
475     releaseAgent = addr;
476   }
477 
478   /**
479    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
480    */
481   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
482     transferAgents[addr] = state;
483   }
484 
485   /**
486    * One way function to release the tokens to the wild.
487    *
488    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
489    */
490   function releaseTokenTransfer() public onlyReleaseAgent {
491     released = true;
492   }
493 
494   /** The function can be called only before or after the tokens have been releasesd */
495   modifier inReleaseState(bool releaseState) {
496     if(releaseState != released) {
497         throw;
498     }
499     _;
500   }
501 
502   /** The function can be called only by a whitelisted release agent. */
503   modifier onlyReleaseAgent() {
504     if(msg.sender != releaseAgent) {
505         throw;
506     }
507     _;
508   }
509 
510   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
511     // Call StandardToken.transfer()
512    return super.transfer(_to, _value);
513   }
514 
515   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
516     // Call StandardToken.transferForm()
517     return super.transferFrom(_from, _to, _value);
518   }
519 
520 }
521 
522 /**
523  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
524  *
525  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
526  */
527 
528 
529 
530 /**
531  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
532  *
533  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
534  */
535 
536 
537 /**
538  * Safe unsigned safe math.
539  *
540  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
541  *
542  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
543  *
544  * Maintained here until merged to mainline zeppelin-solidity.
545  *
546  */
547 library SafeMathLib {
548 
549   function times(uint a, uint b) returns (uint) {
550     uint c = a * b;
551     assert(a == 0 || c / a == b);
552     return c;
553   }
554 
555   function minus(uint a, uint b) returns (uint) {
556     assert(b <= a);
557     return a - b;
558   }
559 
560   function plus(uint a, uint b) returns (uint) {
561     uint c = a + b;
562     assert(c>=a);
563     return c;
564   }
565 
566 }
567 
568 
569 
570 /**
571  * A token that can increase its supply by another contract.
572  *
573  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
574  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
575  *
576  */
577 contract MintableToken is StandardTokenExt {
578 
579   using SafeMathLib for uint;
580 
581   bool public mintingFinished = false;
582 
583   /** List of agents that are allowed to create new tokens */
584   mapping (address => bool) public mintAgents;
585 
586   event MintingAgentChanged(address addr, bool state);
587   event Minted(address receiver, uint amount);
588 
589   /**
590    * Create new tokens and allocate them to an address..
591    *
592    * Only callably by a crowdsale contract (mint agent).
593    */
594   function mint(address receiver, uint amount) onlyMintAgent canMint public {
595     totalSupply = totalSupply.plus(amount);
596     balances[receiver] = balances[receiver].plus(amount);
597 
598     // This will make the mint transaction apper in EtherScan.io
599     // We can remove this after there is a standardized minting event
600     Transfer(0, receiver, amount);
601   }
602 
603   /**
604    * Owner can allow a crowdsale contract to mint new tokens.
605    */
606   function setMintAgent(address addr, bool state) onlyOwner canMint public {
607     mintAgents[addr] = state;
608     MintingAgentChanged(addr, state);
609   }
610 
611   modifier onlyMintAgent() {
612     // Only crowdsale contracts are allowed to mint new tokens
613     if(!mintAgents[msg.sender]) {
614         throw;
615     }
616     _;
617   }
618 
619   /** Make sure we are not done yet. */
620   modifier canMint() {
621     if(mintingFinished) throw;
622     _;
623   }
624 }
625 
626 
627 
628 /**
629  * A crowdsaled token.
630  *
631  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
632  *
633  * - The token transfer() is disabled until the crowdsale is over
634  * - The token contract gives an opt-in upgrade path to a new contract
635  * - The same token can be part of several crowdsales through approve() mechanism
636  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
637  *
638  */
639 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
640 
641   /** Name and symbol were updated. */
642   event UpdatedTokenInformation(string newName, string newSymbol);
643 
644   string public name;
645 
646   string public symbol;
647 
648   uint public decimals;
649 
650   /**
651    * Construct the token.
652    *
653    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
654    *
655    * @param _name Token name
656    * @param _symbol Token symbol - should be all caps
657    * @param _initialSupply How many tokens we start with
658    * @param _decimals Number of decimal places
659    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
660    */
661   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
662     UpgradeableToken(msg.sender) {
663 
664     // Create any address, can be transferred
665     // to team multisig via changeOwner(),
666     // also remember to call setUpgradeMaster()
667     owner = msg.sender;
668 
669     name = _name;
670     symbol = _symbol;
671 
672     totalSupply = _initialSupply;
673 
674     decimals = _decimals;
675 
676     // Create initially all balance on the team multisig
677     balances[owner] = totalSupply;
678 
679     if(totalSupply > 0) {
680       Minted(owner, totalSupply);
681     }
682 
683     // No more new supply allowed after the token creation
684     if(!_mintable) {
685       mintingFinished = true;
686       if(totalSupply == 0) {
687         throw; // Cannot create a token without supply and no minting
688       }
689     }
690   }
691 
692   /**
693    * When token is released to be transferable, enforce no new tokens can be created.
694    */
695   function releaseTokenTransfer() public onlyReleaseAgent {
696     mintingFinished = true;
697     super.releaseTokenTransfer();
698   }
699 
700   /**
701    * Allow upgrade agent functionality kick in only if the crowdsale was success.
702    */
703   function canUpgrade() public constant returns(bool) {
704     return released && super.canUpgrade();
705   }
706 
707   /**
708    * Owner can update token information here.
709    *
710    * It is often useful to conceal the actual token association, until
711    * the token operations, like central issuance or reissuance have been completed.
712    *
713    * This function allows the token owner to rename the token after the operations
714    * have been completed and then point the audience to use the token contract.
715    */
716   function setTokenInformation(string _name, string _symbol) onlyOwner {
717     name = _name;
718     symbol = _symbol;
719 
720     UpdatedTokenInformation(name, symbol);
721   }
722 
723 }