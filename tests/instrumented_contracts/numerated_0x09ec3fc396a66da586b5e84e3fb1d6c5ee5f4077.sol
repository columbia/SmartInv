1 pragma solidity ^0.4.11;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   uint256 public totalSupply;
11   function balanceOf(address who) public constant returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 
18 /**
19  * @title Ownable
20  * @dev The Ownable contract has an owner address, and provides basic authorization control
21  * functions, this simplifies the implementation of "user permissions".
22  */
23 contract Ownable {
24   address public owner;
25 
26 
27   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
28 
29 
30   /**
31    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
32    * account.
33    */
34   function Ownable() {
35     owner = msg.sender;
36   }
37 
38 
39   /**
40    * @dev Throws if called by any account other than the owner.
41    */
42   modifier onlyOwner() {
43     require(msg.sender == owner);
44     _;
45   }
46 
47 
48   /**
49    * @dev Allows the current owner to transfer control of the contract to a newOwner.
50    * @param newOwner The address to transfer ownership to.
51    */
52   function transferOwnership(address newOwner) onlyOwner public {
53     require(newOwner != address(0));
54     OwnershipTransferred(owner, newOwner);
55     owner = newOwner;
56   }
57 
58 }
59 // Temporarily have SafeMath here until all contracts have been migrated to SafeMathLib version from OpenZeppelin
60 
61 
62 
63 
64 /**
65  * Math operations with safety checks
66  */
67 contract SafeMath {
68   function safeMul(uint a, uint b) internal returns (uint) {
69     uint c = a * b;
70     assert(a == 0 || c / a == b);
71     return c;
72   }
73 
74   function safeDiv(uint a, uint b) internal returns (uint) {
75     assert(b > 0);
76     uint c = a / b;
77     assert(a == b * c + a % b);
78     return c;
79   }
80 
81   function safeSub(uint a, uint b) internal returns (uint) {
82     assert(b <= a);
83     return a - b;
84   }
85 
86   function safeAdd(uint a, uint b) internal returns (uint) {
87     uint c = a + b;
88     assert(c>=a && c>=b);
89     return c;
90   }
91 
92   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
93     return a >= b ? a : b;
94   }
95 
96   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
97     return a < b ? a : b;
98   }
99 
100   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
101     return a >= b ? a : b;
102   }
103 
104   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
105     return a < b ? a : b;
106   }
107 
108 }
109 /**
110  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
111  *
112  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
113  */
114 
115 
116 
117 /**
118  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
119  *
120  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
121  */
122 
123 
124 
125 
126 
127 
128 
129 
130 
131 
132 /**
133  * @title ERC20 interface
134  * @dev see https://github.com/ethereum/EIPs/issues/20
135  */
136 contract ERC20 is ERC20Basic {
137   function allowance(address owner, address spender) public constant returns (uint256);
138   function transferFrom(address from, address to, uint256 value) public returns (bool);
139   function approve(address spender, uint256 value) public returns (bool);
140   event Approval(address indexed owner, address indexed spender, uint256 value);
141 }
142 
143 
144 
145 
146 /**
147  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
148  *
149  * Based on code by FirstBlood:
150  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
151  */
152 contract StandardToken is ERC20, SafeMath {
153 
154   /* Token supply got increased and a new owner received these tokens */
155   event Minted(address receiver, uint amount);
156 
157   /* Actual balances of token holders */
158   mapping(address => uint) balances;
159 
160   /* approve() allowances */
161   mapping (address => mapping (address => uint)) allowed;
162 
163   /* Interface declaration */
164   function isToken() public constant returns (bool weAre) {
165     return true;
166   }
167 
168   function transfer(address _to, uint _value) returns (bool success) {
169     balances[msg.sender] = safeSub(balances[msg.sender], _value);
170     balances[_to] = safeAdd(balances[_to], _value);
171     Transfer(msg.sender, _to, _value);
172     return true;
173   }
174 
175   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
176     uint _allowance = allowed[_from][msg.sender];
177 
178     balances[_to] = safeAdd(balances[_to], _value);
179     balances[_from] = safeSub(balances[_from], _value);
180     allowed[_from][msg.sender] = safeSub(_allowance, _value);
181     Transfer(_from, _to, _value);
182     return true;
183   }
184 
185   function balanceOf(address _owner) constant returns (uint balance) {
186     return balances[_owner];
187   }
188 
189   function approve(address _spender, uint _value) returns (bool success) {
190 
191     // To change the approve amount you first have to reduce the addresses`
192     //  allowance to zero by calling `approve(_spender, 0)` if it is not
193     //  already 0 to mitigate the race condition described here:
194     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
195     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
196 
197     allowed[msg.sender][_spender] = _value;
198     Approval(msg.sender, _spender, _value);
199     return true;
200   }
201 
202   function allowance(address _owner, address _spender) constant returns (uint remaining) {
203     return allowed[_owner][_spender];
204   }
205 
206 }
207 
208 /**
209  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
210  *
211  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
212  */
213 
214 
215 
216 
217 
218 /**
219  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
220  *
221  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
222  */
223 
224 
225 
226 /**
227  * Upgrade agent interface inspired by Lunyr.
228  *
229  * Upgrade agent transfers tokens to a new contract.
230  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
231  */
232 contract UpgradeAgent {
233 
234   uint public originalSupply;
235 
236   /** Interface marker */
237   function isUpgradeAgent() public constant returns (bool) {
238     return true;
239   }
240 
241   function upgradeFrom(address _from, uint256 _value) public;
242 
243 }
244 
245 
246 /**
247  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
248  *
249  * First envisioned by Golem and Lunyr projects.
250  */
251 contract UpgradeableToken is StandardToken {
252 
253   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
254   address public upgradeMaster;
255 
256   /** The next contract where the tokens will be migrated. */
257   UpgradeAgent public upgradeAgent;
258 
259   /** How many tokens we have upgraded by now. */
260   uint256 public totalUpgraded;
261 
262   /**
263    * Upgrade states.
264    *
265    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
266    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
267    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
268    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
269    *
270    */
271   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
272 
273   /**
274    * Somebody has upgraded some of his tokens.
275    */
276   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
277 
278   /**
279    * New upgrade agent available.
280    */
281   event UpgradeAgentSet(address agent);
282 
283   /**
284    * Do not allow construction without upgrade master set.
285    */
286   function UpgradeableToken(address _upgradeMaster) {
287     upgradeMaster = _upgradeMaster;
288   }
289 
290   /**
291    * Allow the token holder to upgrade some of their tokens to a new contract.
292    */
293   function upgrade(uint256 value) public {
294 
295       UpgradeState state = getUpgradeState();
296       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
297         // Called in a bad state
298         throw;
299       }
300 
301       // Validate input value.
302       if (value == 0) throw;
303 
304       balances[msg.sender] = safeSub(balances[msg.sender], value);
305 
306       // Take tokens out from circulation
307       totalSupply = safeSub(totalSupply, value);
308       totalUpgraded = safeAdd(totalUpgraded, value);
309 
310       // Upgrade agent reissues the tokens
311       upgradeAgent.upgradeFrom(msg.sender, value);
312       Upgrade(msg.sender, upgradeAgent, value);
313   }
314 
315   /**
316    * Set an upgrade agent that handles
317    */
318   function setUpgradeAgent(address agent) external {
319 
320       if(!canUpgrade()) {
321         // The token is not yet in a state that we could think upgrading
322         throw;
323       }
324 
325       if (agent == 0x0) throw;
326       // Only a master can designate the next agent
327       if (msg.sender != upgradeMaster) throw;
328       // Upgrade has already begun for an agent
329       if (getUpgradeState() == UpgradeState.Upgrading) throw;
330 
331       upgradeAgent = UpgradeAgent(agent);
332 
333       // Bad interface
334       if(!upgradeAgent.isUpgradeAgent()) throw;
335       // Make sure that token supplies match in source and target
336       if (upgradeAgent.originalSupply() != totalSupply) throw;
337 
338       UpgradeAgentSet(upgradeAgent);
339   }
340 
341   /**
342    * Get the state of the token upgrade.
343    */
344   function getUpgradeState() public constant returns(UpgradeState) {
345     if(!canUpgrade()) return UpgradeState.NotAllowed;
346     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
347     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
348     else return UpgradeState.Upgrading;
349   }
350 
351   /**
352    * Change the upgrade master.
353    *
354    * This allows us to set a new owner for the upgrade mechanism.
355    */
356   function setUpgradeMaster(address master) public {
357       if (master == 0x0) throw;
358       if (msg.sender != upgradeMaster) throw;
359       upgradeMaster = master;
360   }
361 
362   /**
363    * Child contract can enable to provide the condition when the upgrade can begun.
364    */
365   function canUpgrade() public constant returns(bool) {
366      return true;
367   }
368 
369 }
370 
371 /**
372  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
373  *
374  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
375  */
376 
377 
378 
379 
380 
381 
382 
383 /**
384  * Define interface for releasing the token transfer after a successful crowdsale.
385  */
386 contract ReleasableToken is ERC20, Ownable {
387 
388   /* The finalizer contract that allows unlift the transfer limits on this token */
389   address public releaseAgent;
390 
391   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
392   bool public released = false;
393 
394   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
395   mapping (address => bool) public transferAgents;
396 
397   /**
398    * Limit token transfer until the crowdsale is over.
399    *
400    */
401   modifier canTransfer(address _sender) {
402 
403     if(!released) {
404         if(!transferAgents[_sender]) {
405             throw;
406         }
407     }
408 
409     _;
410   }
411 
412   /**
413    * Set the contract that can call release and make the token transferable.
414    *
415    * Design choice. Allow reset the release agent to fix fat finger mistakes.
416    */
417   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
418 
419     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
420     releaseAgent = addr;
421   }
422 
423   /**
424    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
425    */
426   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
427     transferAgents[addr] = state;
428   }
429 
430   /**
431    * One way function to release the tokens to the wild.
432    *
433    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
434    */
435   function releaseTokenTransfer() public onlyReleaseAgent {
436     released = true;
437   }
438 
439   /** The function can be called only before or after the tokens have been releasesd */
440   modifier inReleaseState(bool releaseState) {
441     if(releaseState != released) {
442         throw;
443     }
444     _;
445   }
446 
447   /** The function can be called only by a whitelisted release agent. */
448   modifier onlyReleaseAgent() {
449     if(msg.sender != releaseAgent) {
450         throw;
451     }
452     _;
453   }
454 
455   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
456     // Call StandardToken.transfer()
457    return super.transfer(_to, _value);
458   }
459 
460   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
461     // Call StandardToken.transferForm()
462     return super.transferFrom(_from, _to, _value);
463   }
464 
465 }
466 
467 /**
468  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
469  *
470  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
471  */
472 
473 
474 
475 
476 /**
477  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
478  *
479  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
480  */
481 
482 
483 
484 /**
485  * Safe unsigned safe math.
486  *
487  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
488  *
489  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
490  *
491  * Maintained here until merged to mainline zeppelin-solidity.
492  *
493  */
494 library SafeMathLibExt {
495 
496   function times(uint a, uint b) returns (uint) {
497     uint c = a * b;
498     assert(a == 0 || c / a == b);
499     return c;
500   }
501 
502   function divides(uint a, uint b) returns (uint) {
503     assert(b > 0);
504     uint c = a / b;
505     assert(a == b * c + a % b);
506     return c;
507   }
508 
509   function minus(uint a, uint b) returns (uint) {
510     assert(b <= a);
511     return a - b;
512   }
513 
514   function plus(uint a, uint b) returns (uint) {
515     uint c = a + b;
516     assert(c>=a);
517     return c;
518   }
519 
520 }
521 
522 
523 
524 
525 /**
526  * A token that can increase its supply by another contract.
527  *
528  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
529  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
530  *
531  */
532 contract MintableTokenExt is StandardToken, Ownable {
533 
534   using SafeMathLibExt for uint;
535 
536   bool public mintingFinished = false;
537 
538   /** List of agents that are allowed to create new tokens */
539   mapping (address => bool) public mintAgents;
540 
541   event MintingAgentChanged(address addr, bool state  );
542 
543   /** inPercentageUnit is percents of tokens multiplied to 10 up to percents decimals.
544   * For example, for reserved tokens in percents 2.54%
545   * inPercentageUnit = 254
546   * inPercentageDecimals = 2
547   */
548   struct ReservedTokensData {
549     uint inTokens;
550     uint inPercentageUnit;
551     uint inPercentageDecimals;
552     bool isReserved;
553     bool isDistributed;
554   }
555 
556   mapping (address => ReservedTokensData) public reservedTokensList;
557   address[] public reservedTokensDestinations;
558   uint public reservedTokensDestinationsLen = 0;
559   bool reservedTokensDestinationsAreSet = false;
560 
561   modifier onlyMintAgent() {
562     // Only crowdsale contracts are allowed to mint new tokens
563     if(!mintAgents[msg.sender]) {
564         throw;
565     }
566     _;
567   }
568 
569   /** Make sure we are not done yet. */
570   modifier canMint() {
571     if(mintingFinished) throw;
572     _;
573   }
574 
575   function finalizeReservedAddress(address addr) public onlyMintAgent canMint {
576     ReservedTokensData storage reservedTokensData = reservedTokensList[addr];
577     reservedTokensData.isDistributed = true;
578   }
579 
580   function isAddressReserved(address addr) public constant returns (bool isReserved) {
581     return reservedTokensList[addr].isReserved;
582   }
583 
584   function areTokensDistributedForAddress(address addr) public constant returns (bool isDistributed) {
585     return reservedTokensList[addr].isDistributed;
586   }
587 
588   function getReservedTokens(address addr) public constant returns (uint inTokens) {
589     return reservedTokensList[addr].inTokens;
590   }
591 
592   function getReservedPercentageUnit(address addr) public constant returns (uint inPercentageUnit) {
593     return reservedTokensList[addr].inPercentageUnit;
594   }
595 
596   function getReservedPercentageDecimals(address addr) public constant returns (uint inPercentageDecimals) {
597     return reservedTokensList[addr].inPercentageDecimals;
598   }
599 
600   function setReservedTokensListMultiple(
601     address[] addrs, 
602     uint[] inTokens, 
603     uint[] inPercentageUnit, 
604     uint[] inPercentageDecimals
605   ) public canMint onlyOwner {
606     assert(!reservedTokensDestinationsAreSet);
607     assert(addrs.length == inTokens.length);
608     assert(inTokens.length == inPercentageUnit.length);
609     assert(inPercentageUnit.length == inPercentageDecimals.length);
610     for (uint iterator = 0; iterator < addrs.length; iterator++) {
611       if (addrs[iterator] != address(0)) {
612         setReservedTokensList(addrs[iterator], inTokens[iterator], inPercentageUnit[iterator], inPercentageDecimals[iterator]);
613       }
614     }
615     reservedTokensDestinationsAreSet = true;
616   }
617 
618   /**
619    * Create new tokens and allocate them to an address..
620    *
621    * Only callably by a crowdsale contract (mint agent).
622    */
623   function mint(address receiver, uint amount) onlyMintAgent canMint public {
624     totalSupply = totalSupply.plus(amount);
625     balances[receiver] = balances[receiver].plus(amount);
626 
627     // This will make the mint transaction apper in EtherScan.io
628     // We can remove this after there is a standardized minting event
629     Transfer(0, receiver, amount);
630   }
631 
632   /**
633    * Owner can allow a crowdsale contract to mint new tokens.
634    */
635   function setMintAgent(address addr, bool state) onlyOwner canMint public {
636     mintAgents[addr] = state;
637     MintingAgentChanged(addr, state);
638   }
639 
640   function setReservedTokensList(address addr, uint inTokens, uint inPercentageUnit, uint inPercentageDecimals) private canMint onlyOwner {
641     assert(addr != address(0));
642     if (!isAddressReserved(addr)) {
643       reservedTokensDestinations.push(addr);
644       reservedTokensDestinationsLen++;
645     }
646 
647     reservedTokensList[addr] = ReservedTokensData({
648       inTokens: inTokens, 
649       inPercentageUnit: inPercentageUnit, 
650       inPercentageDecimals: inPercentageDecimals,
651       isReserved: true,
652       isDistributed: false
653     });
654   }
655 }
656 
657 
658 /**
659  * A crowdsaled token.
660  *
661  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
662  *
663  * - The token transfer() is disabled until the crowdsale is over
664  * - The token contract gives an opt-in upgrade path to a new contract
665  * - The same token can be part of several crowdsales through approve() mechanism
666  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
667  *
668  */
669 contract CrowdsaleTokenExt is ReleasableToken, MintableTokenExt, UpgradeableToken {
670 
671   /** Name and symbol were updated. */
672   event UpdatedTokenInformation(string newName, string newSymbol);
673 
674   event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
675 
676   string public name;
677 
678   string public symbol;
679 
680   uint public decimals;
681 
682   /* Minimum ammount of tokens every buyer can buy. */
683   uint public minCap;
684 
685   /**
686    * Construct the token.
687    *
688    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
689    *
690    * @param _name Token name
691    * @param _symbol Token symbol - should be all caps
692    * @param _initialSupply How many tokens we start with
693    * @param _decimals Number of decimal places
694    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
695    */
696   function CrowdsaleTokenExt(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable, uint _globalMinCap)
697     UpgradeableToken(msg.sender) {
698 
699     // Create any address, can be transferred
700     // to team multisig via changeOwner(),
701     // also remember to call setUpgradeMaster()
702     owner = msg.sender;
703 
704     name = _name;
705     symbol = _symbol;
706 
707     totalSupply = _initialSupply;
708 
709     decimals = _decimals;
710 
711     minCap = _globalMinCap;
712 
713     // Create initially all balance on the team multisig
714     balances[owner] = totalSupply;
715 
716     if(totalSupply > 0) {
717       Minted(owner, totalSupply);
718     }
719 
720     // No more new supply allowed after the token creation
721     if(!_mintable) {
722       mintingFinished = true;
723       if(totalSupply == 0) {
724         throw; // Cannot create a token without supply and no minting
725       }
726     }
727   }
728 
729   /**
730    * When token is released to be transferable, enforce no new tokens can be created.
731    */
732   function releaseTokenTransfer() public onlyReleaseAgent {
733     mintingFinished = true;
734     super.releaseTokenTransfer();
735   }
736 
737   /**
738    * Allow upgrade agent functionality kick in only if the crowdsale was success.
739    */
740   function canUpgrade() public constant returns(bool) {
741     return released && super.canUpgrade();
742   }
743 
744   /**
745    * Owner can update token information here.
746    *
747    * It is often useful to conceal the actual token association, until
748    * the token operations, like central issuance or reissuance have been completed.
749    *
750    * This function allows the token owner to rename the token after the operations
751    * have been completed and then point the audience to use the token contract.
752    */
753   function setTokenInformation(string _name, string _symbol) onlyOwner {
754     name = _name;
755     symbol = _symbol;
756 
757     UpdatedTokenInformation(name, symbol);
758   }
759 
760   /**
761    * Claim tokens that were accidentally sent to this contract.
762    *
763    * @param _token The address of the token contract that you want to recover.
764    */
765   function claimTokens(address _token) public onlyOwner {
766     require(_token != address(0));
767 
768     ERC20 token = ERC20(_token);
769     uint balance = token.balanceOf(this);
770     token.transfer(owner, balance);
771 
772     ClaimedTokens(_token, owner, balance);
773   }
774 
775 }