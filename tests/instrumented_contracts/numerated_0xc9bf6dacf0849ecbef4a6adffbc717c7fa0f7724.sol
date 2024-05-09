1 // (C) 2017 TokenMarket Ltd. (https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt) Commit: d9e308ff22556a8f40909b1f89ec0f759d1337e0
2 /**
3  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
4  *
5  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
6  */
7 
8 
9 /**
10  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
11  *
12  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
13  */
14 
15 
16 /**
17  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
18  *
19  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
20  */
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
43  * @title ERC20 interface
44  * @dev see https://github.com/ethereum/EIPs/issues/20
45  */
46 contract ERC20 is ERC20Basic {
47   function allowance(address owner, address spender) constant returns (uint256);
48   function transferFrom(address from, address to, uint256 value) returns (bool);
49   function approve(address spender, uint256 value) returns (bool);
50   event Approval(address indexed owner, address indexed spender, uint256 value);
51 }
52 
53 // Temporarily have SafeMath here until all contracts have been migrated to SafeMathLib version from OpenZeppelin
54 
55 
56 
57 /**
58  * Math operations with safety checks
59  */
60 contract SafeMath {
61   function safeMul(uint a, uint b) internal returns (uint) {
62     uint c = a * b;
63     assert(a == 0 || c / a == b);
64     return c;
65   }
66 
67   function safeDiv(uint a, uint b) internal returns (uint) {
68     assert(b > 0);
69     uint c = a / b;
70     assert(a == b * c + a % b);
71     return c;
72   }
73 
74   function safeSub(uint a, uint b) internal returns (uint) {
75     assert(b <= a);
76     return a - b;
77   }
78 
79   function safeAdd(uint a, uint b) internal returns (uint) {
80     uint c = a + b;
81     assert(c>=a && c>=b);
82     return c;
83   }
84 
85   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
86     return a >= b ? a : b;
87   }
88 
89   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
90     return a < b ? a : b;
91   }
92 
93   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
94     return a >= b ? a : b;
95   }
96 
97   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
98     return a < b ? a : b;
99   }
100 
101 }
102 
103 
104 
105 /**
106  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
107  *
108  * Based on code by FirstBlood:
109  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
110  */
111 contract StandardToken is ERC20, SafeMath {
112 
113   /* Token supply got increased and a new owner received these tokens */
114   event Minted(address receiver, uint amount);
115 
116   /* Actual balances of token holders */
117   mapping(address => uint) balances;
118 
119   /* approve() allowances */
120   mapping (address => mapping (address => uint)) allowed;
121 
122   /* Interface declaration */
123   function isToken() public constant returns (bool weAre) {
124     return true;
125   }
126 
127   function transfer(address _to, uint _value) returns (bool success) {
128     balances[msg.sender] = safeSub(balances[msg.sender], _value);
129     balances[_to] = safeAdd(balances[_to], _value);
130     Transfer(msg.sender, _to, _value);
131     return true;
132   }
133 
134   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
135     uint _allowance = allowed[_from][msg.sender];
136 
137     balances[_to] = safeAdd(balances[_to], _value);
138     balances[_from] = safeSub(balances[_from], _value);
139     allowed[_from][msg.sender] = safeSub(_allowance, _value);
140     Transfer(_from, _to, _value);
141     return true;
142   }
143 
144   function balanceOf(address _owner) constant returns (uint balance) {
145     return balances[_owner];
146   }
147 
148   function approve(address _spender, uint _value) returns (bool success) {
149 
150     // To change the approve amount you first have to reduce the addresses`
151     //  allowance to zero by calling `approve(_spender, 0)` if it is not
152     //  already 0 to mitigate the race condition described here:
153     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
155 
156     allowed[msg.sender][_spender] = _value;
157     Approval(msg.sender, _spender, _value);
158     return true;
159   }
160 
161   function allowance(address _owner, address _spender) constant returns (uint remaining) {
162     return allowed[_owner][_spender];
163   }
164 
165 }
166 
167 
168 
169 contract BurnableToken is StandardToken {
170 
171   address public constant BURN_ADDRESS = 0;
172 
173   /** How many tokens we burned */
174   event Burned(address burner, uint burnedAmount);
175 
176   /**
177    * Burn extra tokens from a balance.
178    *
179    */
180   function burn(uint burnAmount) {
181     address burner = msg.sender;
182     balances[burner] = safeSub(balances[burner], burnAmount);
183     totalSupply = safeSub(totalSupply, burnAmount);
184     Burned(burner, burnAmount);
185   }
186 }
187 
188 /**
189  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
190  *
191  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
192  */
193 
194 
195 
196 /**
197  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
198  *
199  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
200  */
201 
202 
203 
204 
205 /**
206  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
207  *
208  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
209  */
210 
211 
212 /**
213  * Upgrade agent interface inspired by Lunyr.
214  *
215  * Upgrade agent transfers tokens to a new contract.
216  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
217  */
218 contract UpgradeAgent {
219 
220   uint public originalSupply;
221 
222   /** Interface marker */
223   function isUpgradeAgent() public constant returns (bool) {
224     return true;
225   }
226 
227   function upgradeFrom(address _from, uint256 _value) public;
228 
229 }
230 
231 
232 /**
233  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
234  *
235  * First envisioned by Golem and Lunyr projects.
236  */
237 contract UpgradeableToken is StandardToken {
238 
239   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
240   address public upgradeMaster;
241 
242   /** The next contract where the tokens will be migrated. */
243   UpgradeAgent public upgradeAgent;
244 
245   /** How many tokens we have upgraded by now. */
246   uint256 public totalUpgraded;
247 
248   /**
249    * Upgrade states.
250    *
251    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
252    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
253    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
254    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
255    *
256    */
257   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
258 
259   /**
260    * Somebody has upgraded some of his tokens.
261    */
262   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
263 
264   /**
265    * New upgrade agent available.
266    */
267   event UpgradeAgentSet(address agent);
268 
269   /**
270    * Do not allow construction without upgrade master set.
271    */
272   function UpgradeableToken(address _upgradeMaster) {
273     upgradeMaster = _upgradeMaster;
274   }
275 
276   /**
277    * Allow the token holder to upgrade some of their tokens to a new contract.
278    */
279   function upgrade(uint256 value) public {
280 
281       UpgradeState state = getUpgradeState();
282       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
283         // Called in a bad state
284         throw;
285       }
286 
287       // Validate input value.
288       if (value == 0) throw;
289 
290       balances[msg.sender] = safeSub(balances[msg.sender], value);
291 
292       // Take tokens out from circulation
293       totalSupply = safeSub(totalSupply, value);
294       totalUpgraded = safeAdd(totalUpgraded, value);
295 
296       // Upgrade agent reissues the tokens
297       upgradeAgent.upgradeFrom(msg.sender, value);
298       Upgrade(msg.sender, upgradeAgent, value);
299   }
300 
301   /**
302    * Set an upgrade agent that handles
303    */
304   function setUpgradeAgent(address agent) external {
305 
306       if(!canUpgrade()) {
307         // The token is not yet in a state that we could think upgrading
308         throw;
309       }
310 
311       if (agent == 0x0) throw;
312       // Only a master can designate the next agent
313       if (msg.sender != upgradeMaster) throw;
314       // Upgrade has already begun for an agent
315       if (getUpgradeState() == UpgradeState.Upgrading) throw;
316 
317       upgradeAgent = UpgradeAgent(agent);
318 
319       // Bad interface
320       if(!upgradeAgent.isUpgradeAgent()) throw;
321       // Make sure that token supplies match in source and target
322       if (upgradeAgent.originalSupply() != totalSupply) throw;
323 
324       UpgradeAgentSet(upgradeAgent);
325   }
326 
327   /**
328    * Get the state of the token upgrade.
329    */
330   function getUpgradeState() public constant returns(UpgradeState) {
331     if(!canUpgrade()) return UpgradeState.NotAllowed;
332     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
333     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
334     else return UpgradeState.Upgrading;
335   }
336 
337   /**
338    * Change the upgrade master.
339    *
340    * This allows us to set a new owner for the upgrade mechanism.
341    */
342   function setUpgradeMaster(address master) public {
343       if (master == 0x0) throw;
344       if (msg.sender != upgradeMaster) throw;
345       upgradeMaster = master;
346   }
347 
348   /**
349    * Child contract can enable to provide the condition when the upgrade can begun.
350    */
351   function canUpgrade() public constant returns(bool) {
352      return true;
353   }
354 
355 }
356 
357 /**
358  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
359  *
360  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
361  */
362 
363 
364 
365 
366 /**
367  * @title Ownable
368  * @dev The Ownable contract has an owner address, and provides basic authorization control
369  * functions, this simplifies the implementation of "user permissions".
370  */
371 contract Ownable {
372   address public owner;
373 
374 
375   /**
376    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
377    * account.
378    */
379   function Ownable() {
380     owner = msg.sender;
381   }
382 
383 
384   /**
385    * @dev Throws if called by any account other than the owner.
386    */
387   modifier onlyOwner() {
388     require(msg.sender == owner);
389     _;
390   }
391 
392 
393   /**
394    * @dev Allows the current owner to transfer control of the contract to a newOwner.
395    * @param newOwner The address to transfer ownership to.
396    */
397   function transferOwnership(address newOwner) onlyOwner {
398     require(newOwner != address(0));      
399     owner = newOwner;
400   }
401 
402 }
403 
404 
405 
406 
407 /**
408  * Define interface for releasing the token transfer after a successful crowdsale.
409  */
410 contract ReleasableToken is ERC20, Ownable {
411 
412   /* The finalizer contract that allows unlift the transfer limits on this token */
413   address public releaseAgent;
414 
415   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
416   bool public released = false;
417 
418   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
419   mapping (address => bool) public transferAgents;
420 
421   /**
422    * Limit token transfer until the crowdsale is over.
423    *
424    */
425   modifier canTransfer(address _sender) {
426 
427     if(!released) {
428         if(!transferAgents[_sender]) {
429             throw;
430         }
431     }
432 
433     _;
434   }
435 
436   /**
437    * Set the contract that can call release and make the token transferable.
438    *
439    * Design choice. Allow reset the release agent to fix fat finger mistakes.
440    */
441   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
442 
443     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
444     releaseAgent = addr;
445   }
446 
447   /**
448    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
449    */
450   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
451     transferAgents[addr] = state;
452   }
453 
454   /**
455    * One way function to release the tokens to the wild.
456    *
457    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
458    */
459   function releaseTokenTransfer() public onlyReleaseAgent {
460     released = true;
461   }
462 
463   /** The function can be called only before or after the tokens have been releasesd */
464   modifier inReleaseState(bool releaseState) {
465     if(releaseState != released) {
466         throw;
467     }
468     _;
469   }
470 
471   /** The function can be called only by a whitelisted release agent. */
472   modifier onlyReleaseAgent() {
473     if(msg.sender != releaseAgent) {
474         throw;
475     }
476     _;
477   }
478 
479   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
480     // Call StandardToken.transfer()
481    return super.transfer(_to, _value);
482   }
483 
484   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
485     // Call StandardToken.transferForm()
486     return super.transferFrom(_from, _to, _value);
487   }
488 
489 }
490 
491 /**
492  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
493  *
494  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
495  */
496 
497 
498 
499 
500 /**
501  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
502  *
503  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
504  */
505 
506 
507 /**
508  * Safe unsigned safe math.
509  *
510  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
511  *
512  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
513  *
514  * Maintained here until merged to mainline zeppelin-solidity.
515  *
516  */
517 library SafeMathLib {
518 
519   function times(uint a, uint b) returns (uint) {
520     uint c = a * b;
521     assert(a == 0 || c / a == b);
522     return c;
523   }
524 
525   function minus(uint a, uint b) returns (uint) {
526     assert(b <= a);
527     return a - b;
528   }
529 
530   function plus(uint a, uint b) returns (uint) {
531     uint c = a + b;
532     assert(c>=a);
533     return c;
534   }
535 
536 }
537 
538 
539 
540 /**
541  * A token that can increase its supply by another contract.
542  *
543  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
544  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
545  *
546  */
547 contract MintableToken is StandardToken, Ownable {
548 
549   using SafeMathLib for uint;
550 
551   bool public mintingFinished = false;
552 
553   /** List of agents that are allowed to create new tokens */
554   mapping (address => bool) public mintAgents;
555 
556   event MintingAgentChanged(address addr, bool state  );
557 
558   /**
559    * Create new tokens and allocate them to an address..
560    *
561    * Only callably by a crowdsale contract (mint agent).
562    */
563   function mint(address receiver, uint amount) onlyMintAgent canMint public {
564     totalSupply = totalSupply.plus(amount);
565     balances[receiver] = balances[receiver].plus(amount);
566 
567     // This will make the mint transaction apper in EtherScan.io
568     // We can remove this after there is a standardized minting event
569     Transfer(0, receiver, amount);
570   }
571 
572   /**
573    * Owner can allow a crowdsale contract to mint new tokens.
574    */
575   function setMintAgent(address addr, bool state) onlyOwner canMint public {
576     mintAgents[addr] = state;
577     MintingAgentChanged(addr, state);
578   }
579 
580   modifier onlyMintAgent() {
581     // Only crowdsale contracts are allowed to mint new tokens
582     if(!mintAgents[msg.sender]) {
583         throw;
584     }
585     _;
586   }
587 
588   /** Make sure we are not done yet. */
589   modifier canMint() {
590     if(mintingFinished) throw;
591     _;
592   }
593 }
594 
595 
596 
597 /**
598  * A crowdsaled token.
599  *
600  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
601  *
602  * - The token transfer() is disabled until the crowdsale is over
603  * - The token contract gives an opt-in upgrade path to a new contract
604  * - The same token can be part of several crowdsales through approve() mechanism
605  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
606  *
607  */
608 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
609 
610   /** Name and symbol were updated. */
611   event UpdatedTokenInformation(string newName, string newSymbol);
612 
613   string public name;
614 
615   string public symbol;
616 
617   uint public decimals;
618 
619   /**
620    * Construct the token.
621    *
622    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
623    *
624    * @param _name Token name
625    * @param _symbol Token symbol - should be all caps
626    * @param _initialSupply How many tokens we start with
627    * @param _decimals Number of decimal places
628    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
629    */
630   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
631     UpgradeableToken(msg.sender) {
632 
633     // Create any address, can be transferred
634     // to team multisig via changeOwner(),
635     // also remember to call setUpgradeMaster()
636     owner = msg.sender;
637 
638     name = _name;
639     symbol = _symbol;
640 
641     totalSupply = _initialSupply;
642 
643     decimals = _decimals;
644 
645     // Create initially all balance on the team multisig
646     balances[owner] = totalSupply;
647 
648     if(totalSupply > 0) {
649       Minted(owner, totalSupply);
650     }
651 
652     // No more new supply allowed after the token creation
653     if(!_mintable) {
654       mintingFinished = true;
655       if(totalSupply == 0) {
656         throw; // Cannot create a token without supply and no minting
657       }
658     }
659   }
660 
661   /**
662    * When token is released to be transferable, enforce no new tokens can be created.
663    */
664   function releaseTokenTransfer() public onlyReleaseAgent {
665     mintingFinished = true;
666     super.releaseTokenTransfer();
667   }
668 
669   /**
670    * Allow upgrade agent functionality kick in only if the crowdsale was success.
671    */
672   function canUpgrade() public constant returns(bool) {
673     return released && super.canUpgrade();
674   }
675 
676   /**
677    * Owner can update token information here.
678    *
679    * It is often useful to conceal the actual token association, until
680    * the token operations, like central issuance or reissuance have been completed.
681    *
682    * This function allows the token owner to rename the token after the operations
683    * have been completed and then point the audience to use the token contract.
684    */
685   function setTokenInformation(string _name, string _symbol) onlyOwner {
686     name = _name;
687     symbol = _symbol;
688 
689     UpdatedTokenInformation(name, symbol);
690   }
691 
692 }
693 
694 
695 /**
696  * A crowdsaled token that you can also burn.
697  *
698  */
699 contract BurnableCrowdsaleToken is BurnableToken, CrowdsaleToken {
700 
701   function BurnableCrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
702     CrowdsaleToken(_name, _symbol, _initialSupply, _decimals, _mintable) {
703 
704   }
705 }