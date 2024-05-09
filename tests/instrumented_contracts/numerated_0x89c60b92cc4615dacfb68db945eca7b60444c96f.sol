1 // Tripterium T10
2 pragma solidity ^0.4.11;
3 
4 
5 /**
6  * @title ERC20Basic
7  * @dev Simpler version of ERC20 interface
8  * @dev see https://github.com/ethereum/EIPs/issues/179
9  */
10 contract ERC20Basic {
11   uint256 public totalSupply;
12   function balanceOf(address who) public constant returns (uint256);
13   function transfer(address to, uint256 value) public returns (bool);
14   event Transfer(address indexed from, address indexed to, uint256 value);
15 }
16 
17 
18 
19 /**
20  * @title Ownable
21  * @dev The Ownable contract has an owner address, and provides basic authorization control
22  * functions, this simplifies the implementation of "user permissions".
23  */
24 contract Ownable {
25   address public owner;
26 
27 
28   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
29 
30 
31   /**
32    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
33    * account.
34    */
35   function Ownable() {
36     owner = msg.sender;
37   }
38 
39 
40   /**
41    * @dev Throws if called by any account other than the owner.
42    */
43   modifier onlyOwner() {
44     require(msg.sender == owner);
45     _;
46   }
47 
48 
49   /**
50    * @dev Allows the current owner to transfer control of the contract to a newOwner.
51    * @param newOwner The address to transfer ownership to.
52    */
53   function transferOwnership(address newOwner) onlyOwner public {
54     require(newOwner != address(0));
55     OwnershipTransferred(owner, newOwner);
56     owner = newOwner;
57   }
58 
59 }
60 // Temporarily have SafeMath here until all contracts have been migrated to SafeMathLib version from OpenZeppelin
61 
62 
63 
64 
65 /**
66  * Math operations with safety checks
67  */
68 contract SafeMath {
69   function safeMul(uint a, uint b) internal returns (uint) {
70     uint c = a * b;
71     assert(a == 0 || c / a == b);
72     return c;
73   }
74 
75   function safeDiv(uint a, uint b) internal returns (uint) {
76     assert(b > 0);
77     uint c = a / b;
78     assert(a == b * c + a % b);
79     return c;
80   }
81 
82   function safeSub(uint a, uint b) internal returns (uint) {
83     assert(b <= a);
84     return a - b;
85   }
86 
87   function safeAdd(uint a, uint b) internal returns (uint) {
88     uint c = a + b;
89     assert(c>=a && c>=b);
90     return c;
91   }
92 
93   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
94     return a >= b ? a : b;
95   }
96 
97   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
98     return a < b ? a : b;
99   }
100 
101   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
102     return a >= b ? a : b;
103   }
104 
105   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
106     return a < b ? a : b;
107   }
108 
109 }
110 /**
111  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
112  *
113  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
114  */
115 
116 
117 
118 /**
119  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
120  *
121  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
122  */
123 
124 
125 
126 
127 
128 
129 
130 
131 
132 
133 /**
134  * @title ERC20 interface
135  * @dev see https://github.com/ethereum/EIPs/issues/20
136  */
137 contract ERC20 is ERC20Basic {
138   function allowance(address owner, address spender) public constant returns (uint256);
139   function transferFrom(address from, address to, uint256 value) public returns (bool);
140   function approve(address spender, uint256 value) public returns (bool);
141   event Approval(address indexed owner, address indexed spender, uint256 value);
142 }
143 
144 
145 
146 
147 /**
148  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
149  *
150  * Based on code by FirstBlood:
151  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
152  */
153 contract StandardToken is ERC20, SafeMath {
154 
155   /* Token supply got increased and a new owner received these tokens */
156   event Minted(address receiver, uint amount);
157 
158   /* Actual balances of token holders */
159   mapping(address => uint) balances;
160 
161   /* approve() allowances */
162   mapping (address => mapping (address => uint)) allowed;
163 
164   /* Interface declaration */
165   function isToken() public constant returns (bool weAre) {
166     return true;
167   }
168 
169   function transfer(address _to, uint _value) returns (bool success) {
170     balances[msg.sender] = safeSub(balances[msg.sender], _value);
171     balances[_to] = safeAdd(balances[_to], _value);
172     Transfer(msg.sender, _to, _value);
173     return true;
174   }
175 
176   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
177     uint _allowance = allowed[_from][msg.sender];
178 
179     balances[_to] = safeAdd(balances[_to], _value);
180     balances[_from] = safeSub(balances[_from], _value);
181     allowed[_from][msg.sender] = safeSub(_allowance, _value);
182     Transfer(_from, _to, _value);
183     return true;
184   }
185 
186   function balanceOf(address _owner) constant returns (uint balance) {
187     return balances[_owner];
188   }
189 
190   function approve(address _spender, uint _value) returns (bool success) {
191 
192     // To change the approve amount you first have to reduce the addresses`
193     //  allowance to zero by calling `approve(_spender, 0)` if it is not
194     //  already 0 to mitigate the race condition described here:
195     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
196     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
197 
198     allowed[msg.sender][_spender] = _value;
199     Approval(msg.sender, _spender, _value);
200     return true;
201   }
202 
203   function allowance(address _owner, address _spender) constant returns (uint remaining) {
204     return allowed[_owner][_spender];
205   }
206 
207 }
208 
209 /**
210  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
211  *
212  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
213  */
214 
215 
216 
217 
218 
219 /**
220  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
221  *
222  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
223  */
224 
225 
226 
227 /**
228  * Upgrade agent interface inspired by Lunyr.
229  *
230  * Upgrade agent transfers tokens to a new contract.
231  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
232  */
233 contract UpgradeAgent {
234 
235   uint public originalSupply;
236 
237   /** Interface marker */
238   function isUpgradeAgent() public constant returns (bool) {
239     return true;
240   }
241 
242   function upgradeFrom(address _from, uint256 _value) public;
243 
244 }
245 
246 
247 /**
248  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
249  *
250  * First envisioned by Golem and Lunyr projects.
251  */
252 contract UpgradeableToken is StandardToken {
253 
254   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
255   address public upgradeMaster;
256 
257   /** The next contract where the tokens will be migrated. */
258   UpgradeAgent public upgradeAgent;
259 
260   /** How many tokens we have upgraded by now. */
261   uint256 public totalUpgraded;
262 
263   /**
264    * Upgrade states.
265    *
266    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
267    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
268    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
269    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
270    *
271    */
272   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
273 
274   /**
275    * Somebody has upgraded some of his tokens.
276    */
277   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
278 
279   /**
280    * New upgrade agent available.
281    */
282   event UpgradeAgentSet(address agent);
283 
284   /**
285    * Do not allow construction without upgrade master set.
286    */
287   function UpgradeableToken(address _upgradeMaster) {
288     upgradeMaster = _upgradeMaster;
289   }
290 
291   /**
292    * Allow the token holder to upgrade some of their tokens to a new contract.
293    */
294   function upgrade(uint256 value) public {
295 
296       UpgradeState state = getUpgradeState();
297       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
298         // Called in a bad state
299         throw;
300       }
301 
302       // Validate input value.
303       if (value == 0) throw;
304 
305       balances[msg.sender] = safeSub(balances[msg.sender], value);
306 
307       // Take tokens out from circulation
308       totalSupply = safeSub(totalSupply, value);
309       totalUpgraded = safeAdd(totalUpgraded, value);
310 
311       // Upgrade agent reissues the tokens
312       upgradeAgent.upgradeFrom(msg.sender, value);
313       Upgrade(msg.sender, upgradeAgent, value);
314   }
315 
316   /**
317    * Set an upgrade agent that handles
318    */
319   function setUpgradeAgent(address agent) external {
320 
321       if(!canUpgrade()) {
322         // The token is not yet in a state that we could think upgrading
323         throw;
324       }
325 
326       if (agent == 0x0) throw;
327       // Only a master can designate the next agent
328       if (msg.sender != upgradeMaster) throw;
329       // Upgrade has already begun for an agent
330       if (getUpgradeState() == UpgradeState.Upgrading) throw;
331 
332       upgradeAgent = UpgradeAgent(agent);
333 
334       // Bad interface
335       if(!upgradeAgent.isUpgradeAgent()) throw;
336       // Make sure that token supplies match in source and target
337       if (upgradeAgent.originalSupply() != totalSupply) throw;
338 
339       UpgradeAgentSet(upgradeAgent);
340   }
341 
342   /**
343    * Get the state of the token upgrade.
344    */
345   function getUpgradeState() public constant returns(UpgradeState) {
346     if(!canUpgrade()) return UpgradeState.NotAllowed;
347     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
348     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
349     else return UpgradeState.Upgrading;
350   }
351 
352   /**
353    * Change the upgrade master.
354    *
355    * This allows us to set a new owner for the upgrade mechanism.
356    */
357   function setUpgradeMaster(address master) public {
358       if (master == 0x0) throw;
359       if (msg.sender != upgradeMaster) throw;
360       upgradeMaster = master;
361   }
362 
363   /**
364    * Child contract can enable to provide the condition when the upgrade can begun.
365    */
366   function canUpgrade() public constant returns(bool) {
367      return true;
368   }
369 
370 }
371 
372 /**
373  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
374  *
375  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
376  */
377 
378 
379 
380 
381 
382 
383 
384 /**
385  * Define interface for releasing the token transfer after a successful crowdsale.
386  */
387 contract ReleasableToken is ERC20, Ownable {
388 
389   /* The finalizer contract that allows unlift the transfer limits on this token */
390   address public releaseAgent;
391 
392   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
393   bool public released = false;
394 
395   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
396   mapping (address => bool) public transferAgents;
397 
398   /**
399    * Limit token transfer until the crowdsale is over.
400    *
401    */
402   modifier canTransfer(address _sender) {
403 
404     if(!released) {
405         if(!transferAgents[_sender]) {
406             throw;
407         }
408     }
409 
410     _;
411   }
412 
413   /**
414    * Set the contract that can call release and make the token transferable.
415    *
416    * Design choice. Allow reset the release agent to fix fat finger mistakes.
417    */
418   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
419 
420     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
421     releaseAgent = addr;
422   }
423 
424   /**
425    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
426    */
427   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
428     transferAgents[addr] = state;
429   }
430 
431   /**
432    * One way function to release the tokens to the wild.
433    *
434    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
435    */
436   function releaseTokenTransfer() public onlyReleaseAgent {
437     released = true;
438   }
439 
440   /** The function can be called only before or after the tokens have been releasesd */
441   modifier inReleaseState(bool releaseState) {
442     if(releaseState != released) {
443         throw;
444     }
445     _;
446   }
447 
448   /** The function can be called only by a whitelisted release agent. */
449   modifier onlyReleaseAgent() {
450     if(msg.sender != releaseAgent) {
451         throw;
452     }
453     _;
454   }
455 
456   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
457     // Call StandardToken.transfer()
458    return super.transfer(_to, _value);
459   }
460 
461   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
462     // Call StandardToken.transferForm()
463     return super.transferFrom(_from, _to, _value);
464   }
465 
466 }
467 
468 /**
469  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
470  *
471  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
472  */
473 
474 
475 
476 
477 /**
478  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
479  *
480  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
481  */
482 
483 
484 
485 /**
486  * Safe unsigned safe math.
487  *
488  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
489  *
490  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
491  *
492  * Maintained here until merged to mainline zeppelin-solidity.
493  *
494  */
495 library SafeMathLibExt {
496 
497   function times(uint a, uint b) returns (uint) {
498     uint c = a * b;
499     assert(a == 0 || c / a == b);
500     return c;
501   }
502 
503   function divides(uint a, uint b) returns (uint) {
504     assert(b > 0);
505     uint c = a / b;
506     assert(a == b * c + a % b);
507     return c;
508   }
509 
510   function minus(uint a, uint b) returns (uint) {
511     assert(b <= a);
512     return a - b;
513   }
514 
515   function plus(uint a, uint b) returns (uint) {
516     uint c = a + b;
517     assert(c>=a);
518     return c;
519   }
520 
521 }
522 
523 
524 
525 
526 /**
527  * A token that can increase its supply by another contract.
528  *
529  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
530  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
531  *
532  */
533 contract MintableTokenExt is StandardToken, Ownable {
534 
535   using SafeMathLibExt for uint;
536 
537   bool public mintingFinished = false;
538 
539   /** List of agents that are allowed to create new tokens */
540   mapping (address => bool) public mintAgents;
541 
542   event MintingAgentChanged(address addr, bool state  );
543 
544   /** inPercentageUnit is percents of tokens multiplied to 10 up to percents decimals.
545   * For example, for reserved tokens in percents 2.54%
546   * inPercentageUnit = 254
547   * inPercentageDecimals = 2
548   */
549   struct ReservedTokensData {
550     uint inTokens;
551     uint inPercentageUnit;
552     uint inPercentageDecimals;
553     bool isReserved;
554     bool isDistributed;
555   }
556 
557   mapping (address => ReservedTokensData) public reservedTokensList;
558   address[] public reservedTokensDestinations;
559   uint public reservedTokensDestinationsLen = 0;
560   bool reservedTokensDestinationsAreSet = false;
561 
562   modifier onlyMintAgent() {
563     // Only crowdsale contracts are allowed to mint new tokens
564     if(!mintAgents[msg.sender]) {
565         throw;
566     }
567     _;
568   }
569 
570   /** Make sure we are not done yet. */
571   modifier canMint() {
572     if(mintingFinished) throw;
573     _;
574   }
575 
576   function finalizeReservedAddress(address addr) public onlyMintAgent canMint {
577     ReservedTokensData storage reservedTokensData = reservedTokensList[addr];
578     reservedTokensData.isDistributed = true;
579   }
580 
581   function isAddressReserved(address addr) public constant returns (bool isReserved) {
582     return reservedTokensList[addr].isReserved;
583   }
584 
585   function areTokensDistributedForAddress(address addr) public constant returns (bool isDistributed) {
586     return reservedTokensList[addr].isDistributed;
587   }
588 
589   function getReservedTokens(address addr) public constant returns (uint inTokens) {
590     return reservedTokensList[addr].inTokens;
591   }
592 
593   function getReservedPercentageUnit(address addr) public constant returns (uint inPercentageUnit) {
594     return reservedTokensList[addr].inPercentageUnit;
595   }
596 
597   function getReservedPercentageDecimals(address addr) public constant returns (uint inPercentageDecimals) {
598     return reservedTokensList[addr].inPercentageDecimals;
599   }
600 
601   function setReservedTokensListMultiple(
602     address[] addrs,
603     uint[] inTokens,
604     uint[] inPercentageUnit,
605     uint[] inPercentageDecimals
606   ) public canMint onlyOwner {
607     assert(!reservedTokensDestinationsAreSet);
608     assert(addrs.length == inTokens.length);
609     assert(inTokens.length == inPercentageUnit.length);
610     assert(inPercentageUnit.length == inPercentageDecimals.length);
611     for (uint iterator = 0; iterator < addrs.length; iterator++) {
612       if (addrs[iterator] != address(0)) {
613         setReservedTokensList(addrs[iterator], inTokens[iterator], inPercentageUnit[iterator], inPercentageDecimals[iterator]);
614       }
615     }
616     reservedTokensDestinationsAreSet = true;
617   }
618 
619   /**
620    * Create new tokens and allocate them to an address..
621    *
622    * Only callably by a crowdsale contract (mint agent).
623    */
624   function mint(address receiver, uint amount) onlyMintAgent canMint public {
625     totalSupply = totalSupply.plus(amount);
626     balances[receiver] = balances[receiver].plus(amount);
627 
628     // This will make the mint transaction apper in EtherScan.io
629     // We can remove this after there is a standardized minting event
630     Transfer(0, receiver, amount);
631   }
632 
633   /**
634    * Owner can allow a crowdsale contract to mint new tokens.
635    */
636   function setMintAgent(address addr, bool state) onlyOwner canMint public {
637     mintAgents[addr] = state;
638     MintingAgentChanged(addr, state);
639   }
640 
641   function setReservedTokensList(address addr, uint inTokens, uint inPercentageUnit, uint inPercentageDecimals) private canMint onlyOwner {
642     assert(addr != address(0));
643     if (!isAddressReserved(addr)) {
644       reservedTokensDestinations.push(addr);
645       reservedTokensDestinationsLen++;
646     }
647 
648     reservedTokensList[addr] = ReservedTokensData({
649       inTokens: inTokens,
650       inPercentageUnit: inPercentageUnit,
651       inPercentageDecimals: inPercentageDecimals,
652       isReserved: true,
653       isDistributed: false
654     });
655   }
656 }
657 
658 
659 /**
660  * A crowdsaled token.
661  *
662  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
663  *
664  * - The token transfer() is disabled until the crowdsale is over
665  * - The token contract gives an opt-in upgrade path to a new contract
666  * - The same token can be part of several crowdsales through approve() mechanism
667  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
668  *
669  */
670 contract CrowdsaleTokenExt is ReleasableToken, MintableTokenExt, UpgradeableToken {
671 
672   /** Name and symbol were updated. */
673   event UpdatedTokenInformation(string newName, string newSymbol);
674 
675   event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
676 
677   string public name;
678 
679   string public symbol;
680 
681   uint public decimals;
682 
683   /* Minimum ammount of tokens every buyer can buy. */
684   uint public minCap;
685 
686   /**
687    * Construct the token.
688    *
689    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
690    *
691    * @param _name Token name
692    * @param _symbol Token symbol - should be all caps
693    * @param _initialSupply How many tokens we start with
694    * @param _decimals Number of decimal places
695    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
696    */
697   function CrowdsaleTokenExt(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable, uint _globalMinCap)
698     UpgradeableToken(msg.sender) {
699 
700     // Create any address, can be transferred
701     // to team multisig via changeOwner(),
702     // also remember to call setUpgradeMaster()
703     owner = msg.sender;
704 
705     name = _name;
706     symbol = _symbol;
707 
708     totalSupply = _initialSupply;
709 
710     decimals = _decimals;
711 
712     minCap = _globalMinCap;
713 
714     // Create initially all balance on the team multisig
715     balances[owner] = totalSupply;
716 
717     if(totalSupply > 0) {
718       Minted(owner, totalSupply);
719     }
720 
721     // No more new supply allowed after the token creation
722     if(!_mintable) {
723       mintingFinished = true;
724       if(totalSupply == 0) {
725         throw; // Cannot create a token without supply and no minting
726       }
727     }
728   }
729 
730   /**
731    * When token is released to be transferable, enforce no new tokens can be created.
732    */
733   function releaseTokenTransfer() public onlyReleaseAgent {
734     mintingFinished = true;
735     super.releaseTokenTransfer();
736   }
737 
738   /**
739    * Allow upgrade agent functionality kick in only if the crowdsale was success.
740    */
741   function canUpgrade() public constant returns(bool) {
742     return released && super.canUpgrade();
743   }
744 
745   /**
746    * Owner can update token information here.
747    *
748    * It is often useful to conceal the actual token association, until
749    * the token operations, like central issuance or reissuance have been completed.
750    *
751    * This function allows the token owner to rename the token after the operations
752    * have been completed and then point the audience to use the token contract.
753    */
754   function setTokenInformation(string _name, string _symbol) onlyOwner {
755     name = _name;
756     symbol = _symbol;
757 
758     UpdatedTokenInformation(name, symbol);
759   }
760 
761   /**
762    * Claim tokens that were accidentally sent to this contract.
763    *
764    * @param _token The address of the token contract that you want to recover.
765    */
766   function claimTokens(address _token) public onlyOwner {
767     require(_token != address(0));
768 
769     ERC20 token = ERC20(_token);
770     uint balance = token.balanceOf(this);
771     token.transfer(owner, balance);
772 
773     ClaimedTokens(_token, owner, balance);
774   }
775 
776 }