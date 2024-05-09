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
27 /**
28  * @title ERC20Basic
29  * @dev Simpler version of ERC20 interface
30  * @dev see https://github.com/ethereum/EIPs/issues/179
31  */
32 contract ERC20Basic {
33   uint256 public totalSupply;
34   function balanceOf(address who) public constant returns (uint256);
35   function transfer(address to, uint256 value) public returns (bool);
36   event Transfer(address indexed from, address indexed to, uint256 value);
37 }
38 
39 
40 
41 /**
42  * @title ERC20 interface
43  * @dev see https://github.com/ethereum/EIPs/issues/20
44  */
45 contract ERC20 is ERC20Basic {
46   function allowance(address owner, address spender) public constant returns (uint256);
47   function transferFrom(address from, address to, uint256 value) public returns (bool);
48   function approve(address spender, uint256 value) public returns (bool);
49   event Approval(address indexed owner, address indexed spender, uint256 value);
50 }
51 
52 // Temporarily have SafeMath here until all contracts have been migrated to SafeMathLib version from OpenZeppelin
53 
54 
55 
56 /**
57  * Math operations with safety checks
58  */
59 contract SafeMath {
60   function safeMul(uint a, uint b) internal returns (uint) {
61     uint c = a * b;
62     assert(a == 0 || c / a == b);
63     return c;
64   }
65 
66   function safeDiv(uint a, uint b) internal returns (uint) {
67     assert(b > 0);
68     uint c = a / b;
69     assert(a == b * c + a % b);
70     return c;
71   }
72 
73   function safeSub(uint a, uint b) internal returns (uint) {
74     assert(b <= a);
75     return a - b;
76   }
77 
78   function safeAdd(uint a, uint b) internal returns (uint) {
79     uint c = a + b;
80     assert(c>=a && c>=b);
81     return c;
82   }
83 
84   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
85     return a >= b ? a : b;
86   }
87 
88   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
89     return a < b ? a : b;
90   }
91 
92   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
93     return a >= b ? a : b;
94   }
95 
96   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
97     return a < b ? a : b;
98   }
99 
100 }
101 
102 
103 
104 /**
105  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
106  *
107  * Based on code by FirstBlood:
108  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
109  */
110 contract StandardToken is ERC20, SafeMath {
111 
112   /* Token supply got increased and a new owner received these tokens */
113   event Minted(address receiver, uint amount);
114 
115   /* Actual balances of token holders */
116   mapping(address => uint) balances;
117 
118   /* approve() allowances */
119   mapping (address => mapping (address => uint)) allowed;
120 
121   /* Interface declaration */
122   function isToken() public constant returns (bool weAre) {
123     return true;
124   }
125 
126   function transfer(address _to, uint _value) returns (bool success) {
127     balances[msg.sender] = safeSub(balances[msg.sender], _value);
128     balances[_to] = safeAdd(balances[_to], _value);
129     Transfer(msg.sender, _to, _value);
130     return true;
131   }
132 
133   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
134     uint _allowance = allowed[_from][msg.sender];
135 
136     balances[_to] = safeAdd(balances[_to], _value);
137     balances[_from] = safeSub(balances[_from], _value);
138     allowed[_from][msg.sender] = safeSub(_allowance, _value);
139     Transfer(_from, _to, _value);
140     return true;
141   }
142 
143   function balanceOf(address _owner) constant returns (uint balance) {
144     return balances[_owner];
145   }
146 
147   function approve(address _spender, uint _value) returns (bool success) {
148 
149     // To change the approve amount you first have to reduce the addresses`
150     //  allowance to zero by calling `approve(_spender, 0)` if it is not
151     //  already 0 to mitigate the race condition described here:
152     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
154 
155     allowed[msg.sender][_spender] = _value;
156     Approval(msg.sender, _spender, _value);
157     return true;
158   }
159 
160   function allowance(address _owner, address _spender) constant returns (uint remaining) {
161     return allowed[_owner][_spender];
162   }
163 
164 }
165 
166 
167 
168 contract BurnableToken is StandardToken {
169 
170   address public constant BURN_ADDRESS = 0;
171 
172   /** How many tokens we burned */
173   event Burned(address burner, uint burnedAmount);
174 
175   /**
176    * Burn extra tokens from a balance.
177    *
178    */
179   function burn(uint burnAmount) {
180     address burner = msg.sender;
181     balances[burner] = safeSub(balances[burner], burnAmount);
182     totalSupply = safeSub(totalSupply, burnAmount);
183     Burned(burner, burnAmount);
184   }
185 }
186 
187 /**
188  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
189  *
190  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
191  */
192 
193 
194 
195 /**
196  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
197  *
198  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
199  */
200 
201 
202 
203 
204 /**
205  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
206  *
207  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
208  */
209 
210 
211 /**
212  * Upgrade agent interface inspired by Lunyr.
213  *
214  * Upgrade agent transfers tokens to a new contract.
215  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
216  */
217 contract UpgradeAgent {
218 
219   uint public originalSupply;
220 
221   /** Interface marker */
222   function isUpgradeAgent() public constant returns (bool) {
223     return true;
224   }
225 
226   function upgradeFrom(address _from, uint256 _value) public;
227 
228 }
229 
230 
231 /**
232  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
233  *
234  * First envisioned by Golem and Lunyr projects.
235  */
236 contract UpgradeableToken is StandardToken {
237 
238   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
239   address public upgradeMaster;
240 
241   /** The next contract where the tokens will be migrated. */
242   UpgradeAgent public upgradeAgent;
243 
244   /** How many tokens we have upgraded by now. */
245   uint256 public totalUpgraded;
246 
247   /**
248    * Upgrade states.
249    *
250    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
251    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
252    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
253    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
254    *
255    */
256   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
257 
258   /**
259    * Somebody has upgraded some of his tokens.
260    */
261   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
262 
263   /**
264    * New upgrade agent available.
265    */
266   event UpgradeAgentSet(address agent);
267 
268   /**
269    * Do not allow construction without upgrade master set.
270    */
271   function UpgradeableToken(address _upgradeMaster) {
272     upgradeMaster = _upgradeMaster;
273   }
274 
275   /**
276    * Allow the token holder to upgrade some of their tokens to a new contract.
277    */
278   function upgrade(uint256 value) public {
279 
280       UpgradeState state = getUpgradeState();
281       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
282         // Called in a bad state
283         throw;
284       }
285 
286       // Validate input value.
287       if (value == 0) throw;
288 
289       balances[msg.sender] = safeSub(balances[msg.sender], value);
290 
291       // Take tokens out from circulation
292       totalSupply = safeSub(totalSupply, value);
293       totalUpgraded = safeAdd(totalUpgraded, value);
294 
295       // Upgrade agent reissues the tokens
296       upgradeAgent.upgradeFrom(msg.sender, value);
297       Upgrade(msg.sender, upgradeAgent, value);
298   }
299 
300   /**
301    * Set an upgrade agent that handles
302    */
303   function setUpgradeAgent(address agent) external {
304 
305       if(!canUpgrade()) {
306         // The token is not yet in a state that we could think upgrading
307         throw;
308       }
309 
310       if (agent == 0x0) throw;
311       // Only a master can designate the next agent
312       if (msg.sender != upgradeMaster) throw;
313       // Upgrade has already begun for an agent
314       if (getUpgradeState() == UpgradeState.Upgrading) throw;
315 
316       upgradeAgent = UpgradeAgent(agent);
317 
318       // Bad interface
319       if(!upgradeAgent.isUpgradeAgent()) throw;
320       // Make sure that token supplies match in source and target
321       if (upgradeAgent.originalSupply() != totalSupply) throw;
322 
323       UpgradeAgentSet(upgradeAgent);
324   }
325 
326   /**
327    * Get the state of the token upgrade.
328    */
329   function getUpgradeState() public constant returns(UpgradeState) {
330     if(!canUpgrade()) return UpgradeState.NotAllowed;
331     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
332     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
333     else return UpgradeState.Upgrading;
334   }
335 
336   /**
337    * Change the upgrade master.
338    *
339    * This allows us to set a new owner for the upgrade mechanism.
340    */
341   function setUpgradeMaster(address master) public {
342       if (master == 0x0) throw;
343       if (msg.sender != upgradeMaster) throw;
344       upgradeMaster = master;
345   }
346 
347   /**
348    * Child contract can enable to provide the condition when the upgrade can begun.
349    */
350   function canUpgrade() public constant returns(bool) {
351      return true;
352   }
353 
354 }
355 
356 /**
357  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
358  *
359  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
360  */
361 
362 
363 
364 
365 /**
366  * @title Ownable
367  * @dev The Ownable contract has an owner address, and provides basic authorization control
368  * functions, this simplifies the implementation of "user permissions".
369  */
370 contract Ownable {
371   address public owner;
372 
373 
374   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
375 
376 
377   /**
378    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
379    * account.
380    */
381   function Ownable() {
382     owner = msg.sender;
383   }
384 
385 
386   /**
387    * @dev Throws if called by any account other than the owner.
388    */
389   modifier onlyOwner() {
390     require(msg.sender == owner);
391     _;
392   }
393 
394 
395   /**
396    * @dev Allows the current owner to transfer control of the contract to a newOwner.
397    * @param newOwner The address to transfer ownership to.
398    */
399   function transferOwnership(address newOwner) onlyOwner public {
400     require(newOwner != address(0));
401     OwnershipTransferred(owner, newOwner);
402     owner = newOwner;
403   }
404 
405 }
406 
407 
408 
409 
410 /**
411  * Define interface for releasing the token transfer after a successful crowdsale.
412  */
413 contract ReleasableToken is ERC20, Ownable {
414 
415   /* The finalizer contract that allows unlift the transfer limits on this token */
416   address public releaseAgent;
417 
418   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
419   bool public released = false;
420 
421   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
422   mapping (address => bool) public transferAgents;
423 
424   /**
425    * Limit token transfer until the crowdsale is over.
426    *
427    */
428   modifier canTransfer(address _sender) {
429 
430     if(!released) {
431         if(!transferAgents[_sender]) {
432             throw;
433         }
434     }
435 
436     _;
437   }
438 
439   /**
440    * Set the contract that can call release and make the token transferable.
441    *
442    * Design choice. Allow reset the release agent to fix fat finger mistakes.
443    */
444   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
445 
446     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
447     releaseAgent = addr;
448   }
449 
450   /**
451    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
452    */
453   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
454     transferAgents[addr] = state;
455   }
456 
457   /**
458    * One way function to release the tokens to the wild.
459    *
460    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
461    */
462   function releaseTokenTransfer() public onlyReleaseAgent {
463     released = true;
464   }
465 
466   /** The function can be called only before or after the tokens have been releasesd */
467   modifier inReleaseState(bool releaseState) {
468     if(releaseState != released) {
469         throw;
470     }
471     _;
472   }
473 
474   /** The function can be called only by a whitelisted release agent. */
475   modifier onlyReleaseAgent() {
476     if(msg.sender != releaseAgent) {
477         throw;
478     }
479     _;
480   }
481 
482   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
483     // Call StandardToken.transfer()
484    return super.transfer(_to, _value);
485   }
486 
487   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
488     // Call StandardToken.transferForm()
489     return super.transferFrom(_from, _to, _value);
490   }
491 
492 }
493 
494 /**
495  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
496  *
497  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
498  */
499 
500 
501 
502 
503 /**
504  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
505  *
506  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
507  */
508 
509 
510 /**
511  * Safe unsigned safe math.
512  *
513  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
514  *
515  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
516  *
517  * Maintained here until merged to mainline zeppelin-solidity.
518  *
519  */
520 library SafeMathLib {
521 
522   function times(uint a, uint b) returns (uint) {
523     uint c = a * b;
524     assert(a == 0 || c / a == b);
525     return c;
526   }
527 
528   function minus(uint a, uint b) returns (uint) {
529     assert(b <= a);
530     return a - b;
531   }
532 
533   function plus(uint a, uint b) returns (uint) {
534     uint c = a + b;
535     assert(c>=a);
536     return c;
537   }
538 
539 }
540 
541 
542 
543 /**
544  * A token that can increase its supply by another contract.
545  *
546  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
547  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
548  *
549  */
550 contract MintableToken is StandardToken, Ownable {
551 
552   using SafeMathLib for uint;
553 
554   bool public mintingFinished = false;
555 
556   /** List of agents that are allowed to create new tokens */
557   mapping (address => bool) public mintAgents;
558 
559   event MintingAgentChanged(address addr, bool state  );
560 
561   /**
562    * Create new tokens and allocate them to an address..
563    *
564    * Only callably by a crowdsale contract (mint agent).
565    */
566   function mint(address receiver, uint amount) onlyMintAgent canMint public {
567     totalSupply = totalSupply.plus(amount);
568     balances[receiver] = balances[receiver].plus(amount);
569 
570     // This will make the mint transaction apper in EtherScan.io
571     // We can remove this after there is a standardized minting event
572     Transfer(0, receiver, amount);
573   }
574 
575   /**
576    * Owner can allow a crowdsale contract to mint new tokens.
577    */
578   function setMintAgent(address addr, bool state) onlyOwner canMint public {
579     mintAgents[addr] = state;
580     MintingAgentChanged(addr, state);
581   }
582 
583   modifier onlyMintAgent() {
584     // Only crowdsale contracts are allowed to mint new tokens
585     if(!mintAgents[msg.sender]) {
586         throw;
587     }
588     _;
589   }
590 
591   /** Make sure we are not done yet. */
592   modifier canMint() {
593     if(mintingFinished) throw;
594     _;
595   }
596 }
597 
598 
599 
600 /**
601  * A crowdsaled token.
602  *
603  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
604  *
605  * - The token transfer() is disabled until the crowdsale is over
606  * - The token contract gives an opt-in upgrade path to a new contract
607  * - The same token can be part of several crowdsales through approve() mechanism
608  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
609  *
610  */
611 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
612 
613   /** Name and symbol were updated. */
614   event UpdatedTokenInformation(string newName, string newSymbol);
615 
616   string public name;
617 
618   string public symbol;
619 
620   uint public decimals;
621 
622   /**
623    * Construct the token.
624    *
625    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
626    *
627    * @param _name Token name
628    * @param _symbol Token symbol - should be all caps
629    * @param _initialSupply How many tokens we start with
630    * @param _decimals Number of decimal places
631    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
632    */
633   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
634     UpgradeableToken(msg.sender) {
635 
636     // Create any address, can be transferred
637     // to team multisig via changeOwner(),
638     // also remember to call setUpgradeMaster()
639     owner = msg.sender;
640 
641     name = _name;
642     symbol = _symbol;
643 
644     totalSupply = _initialSupply;
645 
646     decimals = _decimals;
647 
648     // Create initially all balance on the team multisig
649     balances[owner] = totalSupply;
650 
651     if(totalSupply > 0) {
652       Minted(owner, totalSupply);
653     }
654 
655     // No more new supply allowed after the token creation
656     if(!_mintable) {
657       mintingFinished = true;
658       if(totalSupply == 0) {
659         throw; // Cannot create a token without supply and no minting
660       }
661     }
662   }
663 
664   /**
665    * When token is released to be transferable, enforce no new tokens can be created.
666    */
667   function releaseTokenTransfer() public onlyReleaseAgent {
668     mintingFinished = true;
669     super.releaseTokenTransfer();
670   }
671 
672   /**
673    * Allow upgrade agent functionality kick in only if the crowdsale was success.
674    */
675   function canUpgrade() public constant returns(bool) {
676     return released && super.canUpgrade();
677   }
678 
679   /**
680    * Owner can update token information here.
681    *
682    * It is often useful to conceal the actual token association, until
683    * the token operations, like central issuance or reissuance have been completed.
684    *
685    * This function allows the token owner to rename the token after the operations
686    * have been completed and then point the audience to use the token contract.
687    */
688   function setTokenInformation(string _name, string _symbol) onlyOwner {
689     name = _name;
690     symbol = _symbol;
691 
692     UpdatedTokenInformation(name, symbol);
693   }
694 
695 }
696 
697 
698 /**
699  * A crowdsaled token that you can also burn.
700  *
701  */
702 contract BurnableCrowdsaleToken is BurnableToken, CrowdsaleToken {
703 
704   function BurnableCrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
705     CrowdsaleToken(_name, _symbol, _initialSupply, _decimals, _mintable) {
706 
707   }
708 }