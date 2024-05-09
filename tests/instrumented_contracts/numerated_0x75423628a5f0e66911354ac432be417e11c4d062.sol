1 /**
2  * @title ERC20Basic
3  * @dev Simpler version of ERC20 interface
4  * @dev see https://github.com/ethereum/EIPs/issues/179
5  */
6 contract ERC20Basic {
7   uint256 public totalSupply;
8   function balanceOf(address who) public constant returns (uint256);
9   function transfer(address to, uint256 value) public returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11 }
12 
13 
14 
15 /**
16  * @title Ownable
17  * @dev The Ownable contract has an owner address, and provides basic authorization control
18  * functions, this simplifies the implementation of "user permissions".
19  */
20 contract Ownable {
21   address public owner;
22 
23 
24   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
25 
26 
27   /**
28    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
29    * account.
30    */
31   function Ownable() {
32     owner = msg.sender;
33   }
34 
35 
36   /**
37    * @dev Throws if called by any account other than the owner.
38    */
39   modifier onlyOwner() {
40     require(msg.sender == owner);
41     _;
42   }
43 
44 
45   /**
46    * @dev Allows the current owner to transfer control of the contract to a newOwner.
47    * @param newOwner The address to transfer ownership to.
48    */
49   function transferOwnership(address newOwner) onlyOwner public {
50     require(newOwner != address(0));
51     OwnershipTransferred(owner, newOwner);
52     owner = newOwner;
53   }
54 
55 }
56 // Temporarily have SafeMath here until all contracts have been migrated to SafeMathLib version from OpenZeppelin
57 
58 
59 
60 
61 /**
62  * Math operations with safety checks
63  */
64 contract SafeMath {
65   function safeMul(uint a, uint b) internal returns (uint) {
66     uint c = a * b;
67     assert(a == 0 || c / a == b);
68     return c;
69   }
70 
71   function safeDiv(uint a, uint b) internal returns (uint) {
72     assert(b > 0);
73     uint c = a / b;
74     assert(a == b * c + a % b);
75     return c;
76   }
77 
78   function safeSub(uint a, uint b) internal returns (uint) {
79     assert(b <= a);
80     return a - b;
81   }
82 
83   function safeAdd(uint a, uint b) internal returns (uint) {
84     uint c = a + b;
85     assert(c>=a && c>=b);
86     return c;
87   }
88 
89   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
90     return a >= b ? a : b;
91   }
92 
93   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
94     return a < b ? a : b;
95   }
96 
97   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
98     return a >= b ? a : b;
99   }
100 
101   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
102     return a < b ? a : b;
103   }
104 
105 }
106 /**
107  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
108  *
109  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
110  */
111 
112 
113 
114 /**
115  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
116  *
117  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
118  */
119 
120 
121 
122 
123 
124 
125 
126 
127 
128 
129 /**
130  * @title ERC20 interface
131  * @dev see https://github.com/ethereum/EIPs/issues/20
132  */
133 contract ERC20 is ERC20Basic {
134   function allowance(address owner, address spender) public constant returns (uint256);
135   function transferFrom(address from, address to, uint256 value) public returns (bool);
136   function approve(address spender, uint256 value) public returns (bool);
137   event Approval(address indexed owner, address indexed spender, uint256 value);
138 }
139 
140 
141 
142 
143 /**
144  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
145  *
146  * Based on code by FirstBlood:
147  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
148  */
149 contract StandardToken is ERC20, SafeMath {
150 
151   /* Token supply got increased and a new owner received these tokens */
152   event Minted(address receiver, uint amount);
153 
154   /* Actual balances of token holders */
155   mapping(address => uint) balances;
156 
157   /* approve() allowances */
158   mapping (address => mapping (address => uint)) allowed;
159 
160   /* Interface declaration */
161   function isToken() public constant returns (bool weAre) {
162     return true;
163   }
164 
165   function transfer(address _to, uint _value) returns (bool success) {
166     balances[msg.sender] = safeSub(balances[msg.sender], _value);
167     balances[_to] = safeAdd(balances[_to], _value);
168     Transfer(msg.sender, _to, _value);
169     return true;
170   }
171 
172   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
173     uint _allowance = allowed[_from][msg.sender];
174 
175     balances[_to] = safeAdd(balances[_to], _value);
176     balances[_from] = safeSub(balances[_from], _value);
177     allowed[_from][msg.sender] = safeSub(_allowance, _value);
178     Transfer(_from, _to, _value);
179     return true;
180   }
181 
182   function balanceOf(address _owner) constant returns (uint balance) {
183     return balances[_owner];
184   }
185 
186   function approve(address _spender, uint _value) returns (bool success) {
187 
188     // To change the approve amount you first have to reduce the addresses`
189     //  allowance to zero by calling `approve(_spender, 0)` if it is not
190     //  already 0 to mitigate the race condition described here:
191     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
192     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
193 
194     allowed[msg.sender][_spender] = _value;
195     Approval(msg.sender, _spender, _value);
196     return true;
197   }
198 
199   function allowance(address _owner, address _spender) constant returns (uint remaining) {
200     return allowed[_owner][_spender];
201   }
202 
203 }
204 
205 /**
206  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
207  *
208  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
209  */
210 
211 
212 
213 
214 
215 /**
216  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
217  *
218  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
219  */
220 
221 
222 
223 /**
224  * Upgrade agent interface inspired by Lunyr.
225  *
226  * Upgrade agent transfers tokens to a new contract.
227  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
228  */
229 contract UpgradeAgent {
230 
231   uint public originalSupply;
232 
233   /** Interface marker */
234   function isUpgradeAgent() public constant returns (bool) {
235     return true;
236   }
237 
238   function upgradeFrom(address _from, uint256 _value) public;
239 
240 }
241 
242 
243 /**
244  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
245  *
246  * First envisioned by Golem and Lunyr projects.
247  */
248 contract UpgradeableToken is StandardToken {
249 
250   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
251   address public upgradeMaster;
252 
253   /** The next contract where the tokens will be migrated. */
254   UpgradeAgent public upgradeAgent;
255 
256   /** How many tokens we have upgraded by now. */
257   uint256 public totalUpgraded;
258 
259   /**
260    * Upgrade states.
261    *
262    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
263    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
264    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
265    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
266    *
267    */
268   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
269 
270   /**
271    * Somebody has upgraded some of his tokens.
272    */
273   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
274 
275   /**
276    * New upgrade agent available.
277    */
278   event UpgradeAgentSet(address agent);
279 
280   /**
281    * Do not allow construction without upgrade master set.
282    */
283   function UpgradeableToken(address _upgradeMaster) {
284     upgradeMaster = _upgradeMaster;
285   }
286 
287   /**
288    * Allow the token holder to upgrade some of their tokens to a new contract.
289    */
290   function upgrade(uint256 value) public {
291 
292       UpgradeState state = getUpgradeState();
293       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
294         // Called in a bad state
295         throw;
296       }
297 
298       // Validate input value.
299       if (value == 0) throw;
300 
301       balances[msg.sender] = safeSub(balances[msg.sender], value);
302 
303       // Take tokens out from circulation
304       totalSupply = safeSub(totalSupply, value);
305       totalUpgraded = safeAdd(totalUpgraded, value);
306 
307       // Upgrade agent reissues the tokens
308       upgradeAgent.upgradeFrom(msg.sender, value);
309       Upgrade(msg.sender, upgradeAgent, value);
310   }
311 
312   /**
313    * Set an upgrade agent that handles
314    */
315   function setUpgradeAgent(address agent) external {
316 
317       if(!canUpgrade()) {
318         // The token is not yet in a state that we could think upgrading
319         throw;
320       }
321 
322       if (agent == 0x0) throw;
323       // Only a master can designate the next agent
324       if (msg.sender != upgradeMaster) throw;
325       // Upgrade has already begun for an agent
326       if (getUpgradeState() == UpgradeState.Upgrading) throw;
327 
328       upgradeAgent = UpgradeAgent(agent);
329 
330       // Bad interface
331       if(!upgradeAgent.isUpgradeAgent()) throw;
332       // Make sure that token supplies match in source and target
333       if (upgradeAgent.originalSupply() != totalSupply) throw;
334 
335       UpgradeAgentSet(upgradeAgent);
336   }
337 
338   /**
339    * Get the state of the token upgrade.
340    */
341   function getUpgradeState() public constant returns(UpgradeState) {
342     if(!canUpgrade()) return UpgradeState.NotAllowed;
343     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
344     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
345     else return UpgradeState.Upgrading;
346   }
347 
348   /**
349    * Change the upgrade master.
350    *
351    * This allows us to set a new owner for the upgrade mechanism.
352    */
353   function setUpgradeMaster(address master) public {
354       if (master == 0x0) throw;
355       if (msg.sender != upgradeMaster) throw;
356       upgradeMaster = master;
357   }
358 
359   /**
360    * Child contract can enable to provide the condition when the upgrade can begun.
361    */
362   function canUpgrade() public constant returns(bool) {
363      return true;
364   }
365 
366 }
367 
368 /**
369  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
370  *
371  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
372  */
373 
374 
375 
376 
377 
378 
379 
380 /**
381  * Define interface for releasing the token transfer after a successful crowdsale.
382  */
383 contract ReleasableToken is ERC20, Ownable {
384 
385   /* The finalizer contract that allows unlift the transfer limits on this token */
386   address public releaseAgent;
387 
388   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
389   bool public released = false;
390 
391   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
392   mapping (address => bool) public transferAgents;
393 
394   /**
395    * Limit token transfer until the crowdsale is over.
396    *
397    */
398   modifier canTransfer(address _sender) {
399 
400     if(!released) {
401         if(!transferAgents[_sender]) {
402             throw;
403         }
404     }
405 
406     _;
407   }
408 
409   /**
410    * Set the contract that can call release and make the token transferable.
411    *
412    * Design choice. Allow reset the release agent to fix fat finger mistakes.
413    */
414   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
415 
416     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
417     releaseAgent = addr;
418   }
419 
420   /**
421    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
422    */
423   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
424     transferAgents[addr] = state;
425   }
426 
427   /**
428    * One way function to release the tokens to the wild.
429    *
430    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
431    */
432   function releaseTokenTransfer() public onlyReleaseAgent {
433     released = true;
434   }
435 
436   /** The function can be called only before or after the tokens have been releasesd */
437   modifier inReleaseState(bool releaseState) {
438     if(releaseState != released) {
439         throw;
440     }
441     _;
442   }
443 
444   /** The function can be called only by a whitelisted release agent. */
445   modifier onlyReleaseAgent() {
446     if(msg.sender != releaseAgent) {
447         throw;
448     }
449     _;
450   }
451 
452   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
453     // Call StandardToken.transfer()
454    return super.transfer(_to, _value);
455   }
456 
457   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
458     // Call StandardToken.transferForm()
459     return super.transferFrom(_from, _to, _value);
460   }
461 
462 }
463 
464 /**
465  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
466  *
467  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
468  */
469 
470 
471 
472 
473 /**
474  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
475  *
476  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
477  */
478 
479 
480 
481 /**
482  * Safe unsigned safe math.
483  *
484  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
485  *
486  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
487  *
488  * Maintained here until merged to mainline zeppelin-solidity.
489  *
490  */
491 library SafeMathLibExt {
492 
493   function times(uint a, uint b) returns (uint) {
494     uint c = a * b;
495     assert(a == 0 || c / a == b);
496     return c;
497   }
498 
499   function divides(uint a, uint b) returns (uint) {
500     assert(b > 0);
501     uint c = a / b;
502     assert(a == b * c + a % b);
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
517 }
518 
519 
520 
521 
522 /**
523  * A token that can increase its supply by another contract.
524  *
525  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
526  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
527  *
528  */
529 contract MintableTokenExt is StandardToken, Ownable {
530 
531   using SafeMathLibExt for uint;
532 
533   bool public mintingFinished = false;
534 
535   /** List of agents that are allowed to create new tokens */
536   mapping (address => bool) public mintAgents;
537 
538   event MintingAgentChanged(address addr, bool state  );
539 
540   /** inPercentageUnit is percents of tokens multiplied to 10 up to percents decimals.
541   * For example, for reserved tokens in percents 2.54%
542   * inPercentageUnit = 254
543   * inPercentageDecimals = 2
544   */
545   struct ReservedTokensData {
546     uint inTokens;
547     uint inPercentageUnit;
548     uint inPercentageDecimals;
549     bool isReserved;
550     bool isDistributed;
551   }
552 
553   mapping (address => ReservedTokensData) public reservedTokensList;
554   address[] public reservedTokensDestinations;
555   uint public reservedTokensDestinationsLen = 0;
556   bool reservedTokensDestinationsAreSet = false;
557 
558   modifier onlyMintAgent() {
559     // Only crowdsale contracts are allowed to mint new tokens
560     if(!mintAgents[msg.sender]) {
561         throw;
562     }
563     _;
564   }
565 
566   /** Make sure we are not done yet. */
567   modifier canMint() {
568     if(mintingFinished) throw;
569     _;
570   }
571 
572   function finalizeReservedAddress(address addr) public onlyMintAgent canMint {
573     ReservedTokensData storage reservedTokensData = reservedTokensList[addr];
574     reservedTokensData.isDistributed = true;
575   }
576 
577   function isAddressReserved(address addr) public constant returns (bool isReserved) {
578     return reservedTokensList[addr].isReserved;
579   }
580 
581   function areTokensDistributedForAddress(address addr) public constant returns (bool isDistributed) {
582     return reservedTokensList[addr].isDistributed;
583   }
584 
585   function getReservedTokens(address addr) public constant returns (uint inTokens) {
586     return reservedTokensList[addr].inTokens;
587   }
588 
589   function getReservedPercentageUnit(address addr) public constant returns (uint inPercentageUnit) {
590     return reservedTokensList[addr].inPercentageUnit;
591   }
592 
593   function getReservedPercentageDecimals(address addr) public constant returns (uint inPercentageDecimals) {
594     return reservedTokensList[addr].inPercentageDecimals;
595   }
596 
597   function setReservedTokensListMultiple(
598     address[] addrs, 
599     uint[] inTokens, 
600     uint[] inPercentageUnit, 
601     uint[] inPercentageDecimals
602   ) public canMint onlyOwner {
603     assert(!reservedTokensDestinationsAreSet);
604     assert(addrs.length == inTokens.length);
605     assert(inTokens.length == inPercentageUnit.length);
606     assert(inPercentageUnit.length == inPercentageDecimals.length);
607     for (uint iterator = 0; iterator < addrs.length; iterator++) {
608       if (addrs[iterator] != address(0)) {
609         setReservedTokensList(addrs[iterator], inTokens[iterator], inPercentageUnit[iterator], inPercentageDecimals[iterator]);
610       }
611     }
612     reservedTokensDestinationsAreSet = true;
613   }
614 
615   /**
616    * Create new tokens and allocate them to an address..
617    *
618    * Only callably by a crowdsale contract (mint agent).
619    */
620   function mint(address receiver, uint amount) onlyMintAgent canMint public {
621     totalSupply = totalSupply.plus(amount);
622     balances[receiver] = balances[receiver].plus(amount);
623 
624     // This will make the mint transaction apper in EtherScan.io
625     // We can remove this after there is a standardized minting event
626     Transfer(0, receiver, amount);
627   }
628 
629   /**
630    * Owner can allow a crowdsale contract to mint new tokens.
631    */
632   function setMintAgent(address addr, bool state) onlyOwner canMint public {
633     mintAgents[addr] = state;
634     MintingAgentChanged(addr, state);
635   }
636 
637   function setReservedTokensList(address addr, uint inTokens, uint inPercentageUnit, uint inPercentageDecimals) private canMint onlyOwner {
638     assert(addr != address(0));
639     if (!isAddressReserved(addr)) {
640       reservedTokensDestinations.push(addr);
641       reservedTokensDestinationsLen++;
642     }
643 
644     reservedTokensList[addr] = ReservedTokensData({
645       inTokens: inTokens, 
646       inPercentageUnit: inPercentageUnit, 
647       inPercentageDecimals: inPercentageDecimals,
648       isReserved: true,
649       isDistributed: false
650     });
651   }
652 }
653 
654 
655 /**
656  * A crowdsaled token.
657  *
658  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
659  *
660  * - The token transfer() is disabled until the crowdsale is over
661  * - The token contract gives an opt-in upgrade path to a new contract
662  * - The same token can be part of several crowdsales through approve() mechanism
663  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
664  *
665  */
666 contract CrowdsaleTokenExt is ReleasableToken, MintableTokenExt, UpgradeableToken {
667 
668   /** Name and symbol were updated. */
669   event UpdatedTokenInformation(string newName, string newSymbol);
670 
671   event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
672 
673   string public name;
674 
675   string public symbol;
676 
677   uint public decimals;
678 
679   /* Minimum ammount of tokens every buyer can buy. */
680   uint public minCap;
681 
682   /**
683    * Construct the token.
684    *
685    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
686    *
687    * @param _name Token name
688    * @param _symbol Token symbol - should be all caps
689    * @param _initialSupply How many tokens we start with
690    * @param _decimals Number of decimal places
691    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
692    */
693   function CrowdsaleTokenExt(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable, uint _globalMinCap)
694     UpgradeableToken(msg.sender) {
695 
696     // Create any address, can be transferred
697     // to team multisig via changeOwner(),
698     // also remember to call setUpgradeMaster()
699     owner = msg.sender;
700 
701     name = _name;
702     symbol = _symbol;
703 
704     totalSupply = _initialSupply;
705 
706     decimals = _decimals;
707 
708     minCap = _globalMinCap;
709 
710     // Create initially all balance on the team multisig
711     balances[owner] = totalSupply;
712 
713     if(totalSupply > 0) {
714       Minted(owner, totalSupply);
715     }
716 
717     // No more new supply allowed after the token creation
718     if(!_mintable) {
719       mintingFinished = true;
720       if(totalSupply == 0) {
721         throw; // Cannot create a token without supply and no minting
722       }
723     }
724   }
725 
726   /**
727    * When token is released to be transferable, enforce no new tokens can be created.
728    */
729   function releaseTokenTransfer() public onlyReleaseAgent {
730     mintingFinished = true;
731     super.releaseTokenTransfer();
732   }
733 
734   /**
735    * Allow upgrade agent functionality kick in only if the crowdsale was success.
736    */
737   function canUpgrade() public constant returns(bool) {
738     return released && super.canUpgrade();
739   }
740 
741   /**
742    * Owner can update token information here.
743    *
744    * It is often useful to conceal the actual token association, until
745    * the token operations, like central issuance or reissuance have been completed.
746    *
747    * This function allows the token owner to rename the token after the operations
748    * have been completed and then point the audience to use the token contract.
749    */
750   function setTokenInformation(string _name, string _symbol) onlyOwner {
751     name = _name;
752     symbol = _symbol;
753 
754     UpdatedTokenInformation(name, symbol);
755   }
756 
757   /**
758    * Claim tokens that were accidentally sent to this contract.
759    *
760    * @param _token The address of the token contract that you want to recover.
761    */
762   function claimTokens(address _token) public onlyOwner {
763     require(_token != address(0));
764 
765     ERC20 token = ERC20(_token);
766     uint balance = token.balanceOf(this);
767     token.transfer(owner, balance);
768 
769     ClaimedTokens(_token, owner, balance);
770   }
771 
772 }