1 contract ERC20Basic {
2   uint256 public totalSupply;
3   function balanceOf(address who) public constant returns (uint256);
4   function transfer(address to, uint256 value) public returns (bool);
5   event Transfer(address indexed from, address indexed to, uint256 value);
6 }
7 
8 
9 
10 /**
11  * @title Ownable
12  * @dev The Ownable contract has an owner address, and provides basic authorization control
13  * functions, this simplifies the implementation of "user permissions".
14  */
15 contract Ownable {
16   address public owner;
17 
18 
19   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21 
22   /**
23    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
24    * account.
25    */
26   function Ownable() {
27     owner = msg.sender;
28   }
29 
30 
31   /**
32    * @dev Throws if called by any account other than the owner.
33    */
34   modifier onlyOwner() {
35     require(msg.sender == owner);
36     _;
37   }
38 
39 
40   /**
41    * @dev Allows the current owner to transfer control of the contract to a newOwner.
42    * @param newOwner The address to transfer ownership to.
43    */
44   function transferOwnership(address newOwner) onlyOwner public {
45     require(newOwner != address(0));
46     OwnershipTransferred(owner, newOwner);
47     owner = newOwner;
48   }
49 
50 }
51 // Temporarily have SafeMath here until all contracts have been migrated to SafeMathLib version from OpenZeppelin
52 
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
101 /**
102  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
103  *
104  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
105  */
106 
107 
108 
109 /**
110  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
111  *
112  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
113  */
114 
115 
116 
117 
118 
119 
120 
121 
122 
123 
124 /**
125  * @title ERC20 interface
126  * @dev see https://github.com/ethereum/EIPs/issues/20
127  */
128 contract ERC20 is ERC20Basic {
129   function allowance(address owner, address spender) public constant returns (uint256);
130   function transferFrom(address from, address to, uint256 value) public returns (bool);
131   function approve(address spender, uint256 value) public returns (bool);
132   event Approval(address indexed owner, address indexed spender, uint256 value);
133 }
134 
135 
136 
137 
138 /**
139  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
140  *
141  * Based on code by FirstBlood:
142  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
143  */
144 contract StandardToken is ERC20, SafeMath {
145 
146   /* Token supply got increased and a new owner received these tokens */
147   event Minted(address receiver, uint amount);
148 
149   /* Actual balances of token holders */
150   mapping(address => uint) balances;
151 
152   /* approve() allowances */
153   mapping (address => mapping (address => uint)) allowed;
154 
155   /* Interface declaration */
156   function isToken() public constant returns (bool weAre) {
157     return true;
158   }
159 
160   function transfer(address _to, uint _value) returns (bool success) {
161     balances[msg.sender] = safeSub(balances[msg.sender], _value);
162     balances[_to] = safeAdd(balances[_to], _value);
163     Transfer(msg.sender, _to, _value);
164     return true;
165   }
166 
167   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
168     uint _allowance = allowed[_from][msg.sender];
169 
170     balances[_to] = safeAdd(balances[_to], _value);
171     balances[_from] = safeSub(balances[_from], _value);
172     allowed[_from][msg.sender] = safeSub(_allowance, _value);
173     Transfer(_from, _to, _value);
174     return true;
175   }
176 
177   function balanceOf(address _owner) constant returns (uint balance) {
178     return balances[_owner];
179   }
180 
181   function approve(address _spender, uint _value) returns (bool success) {
182 
183     // To change the approve amount you first have to reduce the addresses`
184     //  allowance to zero by calling `approve(_spender, 0)` if it is not
185     //  already 0 to mitigate the race condition described here:
186     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
187     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
188 
189     allowed[msg.sender][_spender] = _value;
190     Approval(msg.sender, _spender, _value);
191     return true;
192   }
193 
194   function allowance(address _owner, address _spender) constant returns (uint remaining) {
195     return allowed[_owner][_spender];
196   }
197 
198 }
199 
200 /**
201  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
202  *
203  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
204  */
205 
206 
207 
208 
209 
210 /**
211  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
212  *
213  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
214  */
215 
216 
217 
218 /**
219  * Upgrade agent interface inspired by Lunyr.
220  *
221  * Upgrade agent transfers tokens to a new contract.
222  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
223  */
224 contract UpgradeAgent {
225 
226   uint public originalSupply;
227 
228   /** Interface marker */
229   function isUpgradeAgent() public constant returns (bool) {
230     return true;
231   }
232 
233   function upgradeFrom(address _from, uint256 _value) public;
234 
235 }
236 
237 
238 /**
239  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
240  *
241  * First envisioned by Golem and Lunyr projects.
242  */
243 contract UpgradeableToken is StandardToken {
244 
245   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
246   address public upgradeMaster;
247 
248   /** The next contract where the tokens will be migrated. */
249   UpgradeAgent public upgradeAgent;
250 
251   /** How many tokens we have upgraded by now. */
252   uint256 public totalUpgraded;
253 
254   /**
255    * Upgrade states.
256    *
257    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
258    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
259    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
260    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
261    *
262    */
263   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
264 
265   /**
266    * Somebody has upgraded some of his tokens.
267    */
268   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
269 
270   /**
271    * New upgrade agent available.
272    */
273   event UpgradeAgentSet(address agent);
274 
275   /**
276    * Do not allow construction without upgrade master set.
277    */
278   function UpgradeableToken(address _upgradeMaster) {
279     upgradeMaster = _upgradeMaster;
280   }
281 
282   /**
283    * Allow the token holder to upgrade some of their tokens to a new contract.
284    */
285   function upgrade(uint256 value) public {
286 
287       UpgradeState state = getUpgradeState();
288       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
289         // Called in a bad state
290         throw;
291       }
292 
293       // Validate input value.
294       if (value == 0) throw;
295 
296       balances[msg.sender] = safeSub(balances[msg.sender], value);
297 
298       // Take tokens out from circulation
299       totalSupply = safeSub(totalSupply, value);
300       totalUpgraded = safeAdd(totalUpgraded, value);
301 
302       // Upgrade agent reissues the tokens
303       upgradeAgent.upgradeFrom(msg.sender, value);
304       Upgrade(msg.sender, upgradeAgent, value);
305   }
306 
307   /**
308    * Set an upgrade agent that handles
309    */
310   function setUpgradeAgent(address agent) external {
311 
312       if(!canUpgrade()) {
313         // The token is not yet in a state that we could think upgrading
314         throw;
315       }
316 
317       if (agent == 0x0) throw;
318       // Only a master can designate the next agent
319       if (msg.sender != upgradeMaster) throw;
320       // Upgrade has already begun for an agent
321       if (getUpgradeState() == UpgradeState.Upgrading) throw;
322 
323       upgradeAgent = UpgradeAgent(agent);
324 
325       // Bad interface
326       if(!upgradeAgent.isUpgradeAgent()) throw;
327       // Make sure that token supplies match in source and target
328       if (upgradeAgent.originalSupply() != totalSupply) throw;
329 
330       UpgradeAgentSet(upgradeAgent);
331   }
332 
333   /**
334    * Get the state of the token upgrade.
335    */
336   function getUpgradeState() public constant returns(UpgradeState) {
337     if(!canUpgrade()) return UpgradeState.NotAllowed;
338     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
339     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
340     else return UpgradeState.Upgrading;
341   }
342 
343   /**
344    * Change the upgrade master.
345    *
346    * This allows us to set a new owner for the upgrade mechanism.
347    */
348   function setUpgradeMaster(address master) public {
349       if (master == 0x0) throw;
350       if (msg.sender != upgradeMaster) throw;
351       upgradeMaster = master;
352   }
353 
354   /**
355    * Child contract can enable to provide the condition when the upgrade can begun.
356    */
357   function canUpgrade() public constant returns(bool) {
358      return true;
359   }
360 
361 }
362 
363 /**
364  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
365  *
366  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
367  */
368 
369 
370 
371 
372 
373 
374 
375 /**
376  * Define interface for releasing the token transfer after a successful crowdsale.
377  */
378 contract ReleasableToken is ERC20, Ownable {
379 
380   /* The finalizer contract that allows unlift the transfer limits on this token */
381   address public releaseAgent;
382 
383   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
384   bool public released = false;
385 
386   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
387   mapping (address => bool) public transferAgents;
388 
389   /**
390    * Limit token transfer until the crowdsale is over.
391    *
392    */
393   modifier canTransfer(address _sender) {
394 
395     if(!released) {
396         if(!transferAgents[_sender]) {
397             throw;
398         }
399     }
400 
401     _;
402   }
403 
404   /**
405    * Set the contract that can call release and make the token transferable.
406    *
407    * Design choice. Allow reset the release agent to fix fat finger mistakes.
408    */
409   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
410 
411     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
412     releaseAgent = addr;
413   }
414 
415   /**
416    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
417    */
418   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
419     transferAgents[addr] = state;
420   }
421 
422   /**
423    * One way function to release the tokens to the wild.
424    *
425    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
426    */
427   function releaseTokenTransfer() public onlyReleaseAgent {
428     released = true;
429   }
430 
431   /** The function can be called only before or after the tokens have been releasesd */
432   modifier inReleaseState(bool releaseState) {
433     if(releaseState != released) {
434         throw;
435     }
436     _;
437   }
438 
439   /** The function can be called only by a whitelisted release agent. */
440   modifier onlyReleaseAgent() {
441     if(msg.sender != releaseAgent) {
442         throw;
443     }
444     _;
445   }
446 
447   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
448     // Call StandardToken.transfer()
449    return super.transfer(_to, _value);
450   }
451 
452   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
453     // Call StandardToken.transferForm()
454     return super.transferFrom(_from, _to, _value);
455   }
456 
457 }
458 
459 /**
460  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
461  *
462  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
463  */
464 
465 
466 
467 
468 /**
469  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
470  *
471  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
472  */
473 
474 
475 
476 /**
477  * Safe unsigned safe math.
478  *
479  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
480  *
481  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
482  *
483  * Maintained here until merged to mainline zeppelin-solidity.
484  *
485  */
486 library SafeMathLibExt {
487 
488   function times(uint a, uint b) returns (uint) {
489     uint c = a * b;
490     assert(a == 0 || c / a == b);
491     return c;
492   }
493 
494   function divides(uint a, uint b) returns (uint) {
495     assert(b > 0);
496     uint c = a / b;
497     assert(a == b * c + a % b);
498     return c;
499   }
500 
501   function minus(uint a, uint b) returns (uint) {
502     assert(b <= a);
503     return a - b;
504   }
505 
506   function plus(uint a, uint b) returns (uint) {
507     uint c = a + b;
508     assert(c>=a);
509     return c;
510   }
511 
512 }
513 
514 
515 
516 
517 /**
518  * A token that can increase its supply by another contract.
519  *
520  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
521  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
522  *
523  */
524 contract MintableTokenExt is StandardToken, Ownable {
525 
526   using SafeMathLibExt for uint;
527 
528   bool public mintingFinished = false;
529 
530   /** List of agents that are allowed to create new tokens */
531   mapping (address => bool) public mintAgents;
532 
533   event MintingAgentChanged(address addr, bool state  );
534 
535   /** inPercentageUnit is percents of tokens multiplied to 10 up to percents decimals.
536   * For example, for reserved tokens in percents 2.54%
537   * inPercentageUnit = 254
538   * inPercentageDecimals = 2
539   */
540   struct ReservedTokensData {
541     uint inTokens;
542     uint inPercentageUnit;
543     uint inPercentageDecimals;
544     bool isReserved;
545     bool isDistributed;
546   }
547 
548   mapping (address => ReservedTokensData) public reservedTokensList;
549   address[] public reservedTokensDestinations;
550   uint public reservedTokensDestinationsLen = 0;
551   bool reservedTokensDestinationsAreSet = false;
552 
553   modifier onlyMintAgent() {
554     // Only crowdsale contracts are allowed to mint new tokens
555     if(!mintAgents[msg.sender]) {
556         throw;
557     }
558     _;
559   }
560 
561   /** Make sure we are not done yet. */
562   modifier canMint() {
563     if(mintingFinished) throw;
564     _;
565   }
566 
567   function finalizeReservedAddress(address addr) public onlyMintAgent canMint {
568     ReservedTokensData storage reservedTokensData = reservedTokensList[addr];
569     reservedTokensData.isDistributed = true;
570   }
571 
572   function isAddressReserved(address addr) public constant returns (bool isReserved) {
573     return reservedTokensList[addr].isReserved;
574   }
575 
576   function areTokensDistributedForAddress(address addr) public constant returns (bool isDistributed) {
577     return reservedTokensList[addr].isDistributed;
578   }
579 
580   function getReservedTokens(address addr) public constant returns (uint inTokens) {
581     return reservedTokensList[addr].inTokens;
582   }
583 
584   function getReservedPercentageUnit(address addr) public constant returns (uint inPercentageUnit) {
585     return reservedTokensList[addr].inPercentageUnit;
586   }
587 
588   function getReservedPercentageDecimals(address addr) public constant returns (uint inPercentageDecimals) {
589     return reservedTokensList[addr].inPercentageDecimals;
590   }
591 
592   function setReservedTokensListMultiple(
593     address[] addrs, 
594     uint[] inTokens, 
595     uint[] inPercentageUnit, 
596     uint[] inPercentageDecimals
597   ) public canMint onlyOwner {
598     assert(!reservedTokensDestinationsAreSet);
599     assert(addrs.length == inTokens.length);
600     assert(inTokens.length == inPercentageUnit.length);
601     assert(inPercentageUnit.length == inPercentageDecimals.length);
602     for (uint iterator = 0; iterator < addrs.length; iterator++) {
603       if (addrs[iterator] != address(0)) {
604         setReservedTokensList(addrs[iterator], inTokens[iterator], inPercentageUnit[iterator], inPercentageDecimals[iterator]);
605       }
606     }
607     reservedTokensDestinationsAreSet = true;
608   }
609 
610   /**
611    * Create new tokens and allocate them to an address..
612    *
613    * Only callably by a crowdsale contract (mint agent).
614    */
615   function mint(address receiver, uint amount) onlyMintAgent canMint public {
616     totalSupply = totalSupply.plus(amount);
617     balances[receiver] = balances[receiver].plus(amount);
618 
619     // This will make the mint transaction apper in EtherScan.io
620     // We can remove this after there is a standardized minting event
621     Transfer(0, receiver, amount);
622   }
623 
624   /**
625    * Owner can allow a crowdsale contract to mint new tokens.
626    */
627   function setMintAgent(address addr, bool state) onlyOwner canMint public {
628     mintAgents[addr] = state;
629     MintingAgentChanged(addr, state);
630   }
631 
632   function setReservedTokensList(address addr, uint inTokens, uint inPercentageUnit, uint inPercentageDecimals) private canMint onlyOwner {
633     assert(addr != address(0));
634     if (!isAddressReserved(addr)) {
635       reservedTokensDestinations.push(addr);
636       reservedTokensDestinationsLen++;
637     }
638 
639     reservedTokensList[addr] = ReservedTokensData({
640       inTokens: inTokens, 
641       inPercentageUnit: inPercentageUnit, 
642       inPercentageDecimals: inPercentageDecimals,
643       isReserved: true,
644       isDistributed: false
645     });
646   }
647 }
648 
649 
650 /**
651  * A crowdsaled token.
652  *
653  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
654  *
655  * - The token transfer() is disabled until the crowdsale is over
656  * - The token contract gives an opt-in upgrade path to a new contract
657  * - The same token can be part of several crowdsales through approve() mechanism
658  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
659  *
660  */
661 contract CrowdsaleTokenExt is ReleasableToken, MintableTokenExt, UpgradeableToken {
662 
663   /** Name and symbol were updated. */
664   event UpdatedTokenInformation(string newName, string newSymbol);
665 
666   event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
667 
668   string public name;
669 
670   string public symbol;
671 
672   uint public decimals;
673 
674   /* Minimum ammount of tokens every buyer can buy. */
675   uint public minCap;
676 
677   /**
678    * Construct the token.
679    *
680    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
681    *
682    * @param _name Token name
683    * @param _symbol Token symbol - should be all caps
684    * @param _initialSupply How many tokens we start with
685    * @param _decimals Number of decimal places
686    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
687    */
688   function CrowdsaleTokenExt(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable, uint _globalMinCap)
689     UpgradeableToken(msg.sender) {
690 
691     // Create any address, can be transferred
692     // to team multisig via changeOwner(),
693     // also remember to call setUpgradeMaster()
694     owner = msg.sender;
695 
696     name = _name;
697     symbol = _symbol;
698 
699     totalSupply = _initialSupply;
700 
701     decimals = _decimals;
702 
703     minCap = _globalMinCap;
704 
705     // Create initially all balance on the team multisig
706     balances[owner] = totalSupply;
707 
708     if(totalSupply > 0) {
709       Minted(owner, totalSupply);
710     }
711 
712     // No more new supply allowed after the token creation
713     if(!_mintable) {
714       mintingFinished = true;
715       if(totalSupply == 0) {
716         throw; // Cannot create a token without supply and no minting
717       }
718     }
719   }
720 
721   /**
722    * When token is released to be transferable, enforce no new tokens can be created.
723    */
724   function releaseTokenTransfer() public onlyReleaseAgent {
725     mintingFinished = true;
726     super.releaseTokenTransfer();
727   }
728 
729   /**
730    * Allow upgrade agent functionality kick in only if the crowdsale was success.
731    */
732   function canUpgrade() public constant returns(bool) {
733     return released && super.canUpgrade();
734   }
735 
736   /**
737    * Owner can update token information here.
738    *
739    * It is often useful to conceal the actual token association, until
740    * the token operations, like central issuance or reissuance have been completed.
741    *
742    * This function allows the token owner to rename the token after the operations
743    * have been completed and then point the audience to use the token contract.
744    */
745   function setTokenInformation(string _name, string _symbol) onlyOwner {
746     name = _name;
747     symbol = _symbol;
748 
749     UpdatedTokenInformation(name, symbol);
750   }
751 
752   /**
753    * Claim tokens that were accidentally sent to this contract.
754    *
755    * @param _token The address of the token contract that you want to recover.
756    */
757   function claimTokens(address _token) public onlyOwner {
758     require(_token != address(0));
759 
760     ERC20 token = ERC20(_token);
761     uint balance = token.balanceOf(this);
762     token.transfer(owner, balance);
763 
764     ClaimedTokens(_token, owner, balance);
765   }
766 
767 }