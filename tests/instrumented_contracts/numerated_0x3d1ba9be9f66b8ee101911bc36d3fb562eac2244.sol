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
25 /*
26  * ERC20 interface
27  * see https://github.com/ethereum/EIPs/issues/20
28  */
29 contract ERC20 {
30   uint public totalSupply;
31   function balanceOf(address who) constant returns (uint);
32   function allowance(address owner, address spender) constant returns (uint);
33 
34   function transfer(address to, uint value) returns (bool ok);
35   function transferFrom(address from, address to, uint value) returns (bool ok);
36   function approve(address spender, uint value) returns (bool ok);
37   event Transfer(address indexed from, address indexed to, uint value);
38   event Approval(address indexed owner, address indexed spender, uint value);
39 }
40 
41 
42 
43 /**
44  * Math operations with safety checks
45  */
46 contract SafeMath {
47   function safeMul(uint a, uint b) internal returns (uint) {
48     uint c = a * b;
49     assert(a == 0 || c / a == b);
50     return c;
51   }
52 
53   function safeDiv(uint a, uint b) internal returns (uint) {
54     assert(b > 0);
55     uint c = a / b;
56     assert(a == b * c + a % b);
57     return c;
58   }
59 
60   function safeSub(uint a, uint b) internal returns (uint) {
61     assert(b <= a);
62     return a - b;
63   }
64 
65   function safeAdd(uint a, uint b) internal returns (uint) {
66     uint c = a + b;
67     assert(c>=a && c>=b);
68     return c;
69   }
70 
71   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
72     return a >= b ? a : b;
73   }
74 
75   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
76     return a < b ? a : b;
77   }
78 
79   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
80     return a >= b ? a : b;
81   }
82 
83   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
84     return a < b ? a : b;
85   }
86 
87   function assert(bool assertion) internal {
88     if (!assertion) {
89       throw;
90     }
91   }
92 }
93 
94 
95 
96 /**
97  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
98  *
99  * Based on code by FirstBlood:
100  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
101  */
102 contract StandardToken is ERC20, SafeMath {
103 
104   /* Token supply got increased and a new owner received these tokens */
105   event Minted(address receiver, uint amount);
106 
107   /* Actual balances of token holders */
108   mapping(address => uint) balances;
109 
110   /* approve() allowances */
111   mapping (address => mapping (address => uint)) allowed;
112 
113   /* Interface declaration */
114   function isToken() public constant returns (bool weAre) {
115     return true;
116   }
117 
118   function transfer(address _to, uint _value) returns (bool success) {
119     balances[msg.sender] = safeSub(balances[msg.sender], _value);
120     balances[_to] = safeAdd(balances[_to], _value);
121     Transfer(msg.sender, _to, _value);
122     return true;
123   }
124 
125   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
126     uint _allowance = allowed[_from][msg.sender];
127 
128     balances[_to] = safeAdd(balances[_to], _value);
129     balances[_from] = safeSub(balances[_from], _value);
130     allowed[_from][msg.sender] = safeSub(_allowance, _value);
131     Transfer(_from, _to, _value);
132     return true;
133   }
134 
135   function balanceOf(address _owner) constant returns (uint balance) {
136     return balances[_owner];
137   }
138 
139   function approve(address _spender, uint _value) returns (bool success) {
140 
141     // To change the approve amount you first have to reduce the addresses`
142     //  allowance to zero by calling `approve(_spender, 0)` if it is not
143     //  already 0 to mitigate the race condition described here:
144     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
145     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
146 
147     allowed[msg.sender][_spender] = _value;
148     Approval(msg.sender, _spender, _value);
149     return true;
150   }
151 
152   function allowance(address _owner, address _spender) constant returns (uint remaining) {
153     return allowed[_owner][_spender];
154   }
155 
156 }
157 
158 
159 
160 contract BurnableToken is StandardToken {
161 
162   address public constant BURN_ADDRESS = 0;
163 
164   /** How many tokens we burned */
165   event Burned(address burner, uint burnedAmount);
166 
167   /**
168    * Burn extra tokens from a balance.
169    *
170    */
171   function burn(uint burnAmount) {
172     address burner = msg.sender;
173     balances[burner] = safeSub(balances[burner], burnAmount);
174     totalSupply = safeSub(totalSupply, burnAmount);
175     Burned(burner, burnAmount);
176   }
177 }
178 
179 /**
180  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
181  *
182  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
183  */
184 
185 
186 
187 /**
188  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
189  *
190  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
191  */
192 
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
203 /**
204  * Upgrade agent interface inspired by Lunyr.
205  *
206  * Upgrade agent transfers tokens to a new contract.
207  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
208  */
209 contract UpgradeAgent {
210 
211   uint public originalSupply;
212 
213   /** Interface marker */
214   function isUpgradeAgent() public constant returns (bool) {
215     return true;
216   }
217 
218   function upgradeFrom(address _from, uint256 _value) public;
219 
220 }
221 
222 
223 /**
224  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
225  *
226  * First envisioned by Golem and Lunyr projects.
227  */
228 contract UpgradeableToken is StandardToken {
229 
230   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
231   address public upgradeMaster;
232 
233   /** The next contract where the tokens will be migrated. */
234   UpgradeAgent public upgradeAgent;
235 
236   /** How many tokens we have upgraded by now. */
237   uint256 public totalUpgraded;
238 
239   /**
240    * Upgrade states.
241    *
242    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
243    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
244    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
245    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
246    *
247    */
248   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
249 
250   /**
251    * Somebody has upgraded some of his tokens.
252    */
253   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
254 
255   /**
256    * New upgrade agent available.
257    */
258   event UpgradeAgentSet(address agent);
259 
260   /**
261    * Do not allow construction without upgrade master set.
262    */
263   function UpgradeableToken(address _upgradeMaster) {
264     upgradeMaster = _upgradeMaster;
265   }
266 
267   /**
268    * Allow the token holder to upgrade some of their tokens to a new contract.
269    */
270   function upgrade(uint256 value) public {
271 
272       UpgradeState state = getUpgradeState();
273       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
274         // Called in a bad state
275         throw;
276       }
277 
278       // Validate input value.
279       if (value == 0) throw;
280 
281       balances[msg.sender] = safeSub(balances[msg.sender], value);
282 
283       // Take tokens out from circulation
284       totalSupply = safeSub(totalSupply, value);
285       totalUpgraded = safeAdd(totalUpgraded, value);
286 
287       // Upgrade agent reissues the tokens
288       upgradeAgent.upgradeFrom(msg.sender, value);
289       Upgrade(msg.sender, upgradeAgent, value);
290   }
291 
292   /**
293    * Set an upgrade agent that handles
294    */
295   function setUpgradeAgent(address agent) external {
296 
297       if(!canUpgrade()) {
298         // The token is not yet in a state that we could think upgrading
299         throw;
300       }
301 
302       if (agent == 0x0) throw;
303       // Only a master can designate the next agent
304       if (msg.sender != upgradeMaster) throw;
305       // Upgrade has already begun for an agent
306       if (getUpgradeState() == UpgradeState.Upgrading) throw;
307 
308       upgradeAgent = UpgradeAgent(agent);
309 
310       // Bad interface
311       if(!upgradeAgent.isUpgradeAgent()) throw;
312       // Make sure that token supplies match in source and target
313       if (upgradeAgent.originalSupply() != totalSupply) throw;
314 
315       UpgradeAgentSet(upgradeAgent);
316   }
317 
318   /**
319    * Get the state of the token upgrade.
320    */
321   function getUpgradeState() public constant returns(UpgradeState) {
322     if(!canUpgrade()) return UpgradeState.NotAllowed;
323     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
324     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
325     else return UpgradeState.Upgrading;
326   }
327 
328   /**
329    * Change the upgrade master.
330    *
331    * This allows us to set a new owner for the upgrade mechanism.
332    */
333   function setUpgradeMaster(address master) public {
334       if (master == 0x0) throw;
335       if (msg.sender != upgradeMaster) throw;
336       upgradeMaster = master;
337   }
338 
339   /**
340    * Child contract can enable to provide the condition when the upgrade can begun.
341    */
342   function canUpgrade() public constant returns(bool) {
343      return true;
344   }
345 
346 }
347 
348 /**
349  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
350  *
351  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
352  */
353 
354 
355 
356 
357 /*
358  * Ownable
359  *
360  * Base contract with an owner.
361  * Provides onlyOwner modifier, which prevents function from running if it is called by anyone other than the owner.
362  */
363 contract Ownable {
364   address public owner;
365 
366   function Ownable() {
367     owner = msg.sender;
368   }
369 
370   modifier onlyOwner() {
371     if (msg.sender != owner) {
372       throw;
373     }
374     _;
375   }
376 
377   function transferOwnership(address newOwner) onlyOwner {
378     if (newOwner != address(0)) {
379       owner = newOwner;
380     }
381   }
382 
383 }
384 
385 
386 
387 
388 /**
389  * Define interface for releasing the token transfer after a successful crowdsale.
390  */
391 contract ReleasableToken is ERC20, Ownable {
392 
393   /* The finalizer contract that allows unlift the transfer limits on this token */
394   address public releaseAgent;
395 
396   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
397   bool public released = false;
398 
399   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
400   mapping (address => bool) public transferAgents;
401 
402   /**
403    * Limit token transfer until the crowdsale is over.
404    *
405    */
406   modifier canTransfer(address _sender) {
407 
408     if(!released) {
409         if(!transferAgents[_sender]) {
410             throw;
411         }
412     }
413 
414     _;
415   }
416 
417   /**
418    * Set the contract that can call release and make the token transferable.
419    *
420    * Design choice. Allow reset the release agent to fix fat finger mistakes.
421    */
422   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
423 
424     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
425     releaseAgent = addr;
426   }
427 
428   /**
429    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
430    */
431   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
432     transferAgents[addr] = state;
433   }
434 
435   /**
436    * One way function to release the tokens to the wild.
437    *
438    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
439    */
440   function releaseTokenTransfer() public onlyReleaseAgent {
441     released = true;
442   }
443 
444   /** The function can be called only before or after the tokens have been releasesd */
445   modifier inReleaseState(bool releaseState) {
446     if(releaseState != released) {
447         throw;
448     }
449     _;
450   }
451 
452   /** The function can be called only by a whitelisted release agent. */
453   modifier onlyReleaseAgent() {
454     if(msg.sender != releaseAgent) {
455         throw;
456     }
457     _;
458   }
459 
460   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
461     // Call StandardToken.transfer()
462    return super.transfer(_to, _value);
463   }
464 
465   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
466     // Call StandardToken.transferForm()
467     return super.transferFrom(_from, _to, _value);
468   }
469 
470 }
471 
472 /**
473  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
474  *
475  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
476  */
477 
478 
479 
480 
481 /**
482  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
483  *
484  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
485  */
486 
487 
488 /**
489  * Safe unsigned safe math.
490  *
491  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
492  *
493  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
494  *
495  * Maintained here until merged to mainline zeppelin-solidity.
496  *
497  */
498 library SafeMathLib {
499 
500   function times(uint a, uint b) returns (uint) {
501     uint c = a * b;
502     assert(a == 0 || c / a == b);
503     return c;
504   }
505 
506   function minus(uint a, uint b) returns (uint) {
507     assert(b <= a);
508     return a - b;
509   }
510 
511   function plus(uint a, uint b) returns (uint) {
512     uint c = a + b;
513     assert(c>=a);
514     return c;
515   }
516 
517   function assert(bool assertion) private {
518     if (!assertion) throw;
519   }
520 }
521 
522 
523 
524 /**
525  * A token that can increase its supply by another contract.
526  *
527  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
528  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
529  *
530  */
531 contract MintableToken is StandardToken, Ownable {
532 
533   using SafeMathLib for uint;
534 
535   bool public mintingFinished = false;
536 
537   /** List of agents that are allowed to create new tokens */
538   mapping (address => bool) public mintAgents;
539 
540   event MintingAgentChanged(address addr, bool state  );
541 
542   /**
543    * Create new tokens and allocate them to an address..
544    *
545    * Only callably by a crowdsale contract (mint agent).
546    */
547   function mint(address receiver, uint amount) onlyMintAgent canMint public {
548     totalSupply = totalSupply.plus(amount);
549     balances[receiver] = balances[receiver].plus(amount);
550 
551     // This will make the mint transaction apper in EtherScan.io
552     // We can remove this after there is a standardized minting event
553     Transfer(0, receiver, amount);
554   }
555 
556   /**
557    * Owner can allow a crowdsale contract to mint new tokens.
558    */
559   function setMintAgent(address addr, bool state) onlyOwner canMint public {
560     mintAgents[addr] = state;
561     MintingAgentChanged(addr, state);
562   }
563 
564   modifier onlyMintAgent() {
565     // Only crowdsale contracts are allowed to mint new tokens
566     if(!mintAgents[msg.sender]) {
567         throw;
568     }
569     _;
570   }
571 
572   /** Make sure we are not done yet. */
573   modifier canMint() {
574     if(mintingFinished) throw;
575     _;
576   }
577 }
578 
579 
580 
581 /**
582  * A crowdsaled token.
583  *
584  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
585  *
586  * - The token transfer() is disabled until the crowdsale is over
587  * - The token contract gives an opt-in upgrade path to a new contract
588  * - The same token can be part of several crowdsales through approve() mechanism
589  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
590  *
591  */
592 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
593 
594   /** Name and symbol were updated. */
595   event UpdatedTokenInformation(string newName, string newSymbol);
596 
597   string public name;
598 
599   string public symbol;
600 
601   uint public decimals;
602 
603   /**
604    * Construct the token.
605    *
606    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
607    *
608    * @param _name Token name
609    * @param _symbol Token symbol - should be all caps
610    * @param _initialSupply How many tokens we start with
611    * @param _decimals Number of decimal places
612    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
613    */
614   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
615     UpgradeableToken(msg.sender) {
616 
617     // Create any address, can be transferred
618     // to team multisig via changeOwner(),
619     // also remember to call setUpgradeMaster()
620     owner = msg.sender;
621 
622     name = _name;
623     symbol = _symbol;
624 
625     totalSupply = _initialSupply;
626 
627     decimals = _decimals;
628 
629     // Create initially all balance on the team multisig
630     balances[owner] = totalSupply;
631 
632     if(totalSupply > 0) {
633       Minted(owner, totalSupply);
634     }
635 
636     // No more new supply allowed after the token creation
637     if(!_mintable) {
638       mintingFinished = true;
639       if(totalSupply == 0) {
640         throw; // Cannot create a token without supply and no minting
641       }
642     }
643   }
644 
645   /**
646    * When token is released to be transferable, enforce no new tokens can be created.
647    */
648   function releaseTokenTransfer() public onlyReleaseAgent {
649     mintingFinished = true;
650     super.releaseTokenTransfer();
651   }
652 
653   /**
654    * Allow upgrade agent functionality kick in only if the crowdsale was success.
655    */
656   function canUpgrade() public constant returns(bool) {
657     return released && super.canUpgrade();
658   }
659 
660   /**
661    * Owner can update token information here.
662    *
663    * It is often useful to conceal the actual token association, until
664    * the token operations, like central issuance or reissuance have been completed.
665    *
666    * This function allows the token owner to rename the token after the operations
667    * have been completed and then point the audience to use the token contract.
668    */
669   function setTokenInformation(string _name, string _symbol) onlyOwner {
670     name = _name;
671     symbol = _symbol;
672 
673     UpdatedTokenInformation(name, symbol);
674   }
675 
676 }
677 
678 
679 /**
680  * A crowdsaled token that you can also burn.
681  *
682  */
683 contract BurnableCrowdsaleToken is BurnableToken, CrowdsaleToken {
684 
685   function BurnableCrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
686     CrowdsaleToken(_name, _symbol, _initialSupply, _decimals, _mintable) {
687 
688   }
689 }