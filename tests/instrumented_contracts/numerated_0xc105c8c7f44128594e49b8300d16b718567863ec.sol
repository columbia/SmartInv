1 /**
2  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
3  *
4  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
5  */
6 
7 pragma solidity ^0.4.11;
8 
9 
10 
11 /**
12  * Safe unsigned safe math.
13  *
14  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
15  *
16  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
17  *
18  * Maintained here until merged to mainline zeppelin-solidity.
19  *
20  */
21 library SMathLib {
22 
23     function times(uint a, uint b) returns (uint) {
24         uint c = a * b;
25         assert(a == 0 || c / a == b);
26         return c;
27     }
28 
29     function divides(uint a, uint b) returns (uint) {
30         assert(b > 0);
31         uint c = a / b;
32         assert(a == b * c + a % b);
33         return c;
34     }
35 
36     function minus(uint a, uint b) returns (uint) {
37         assert(b <= a);
38         return a - b;
39     }
40 
41     function plus(uint a, uint b) returns (uint) {
42         uint c = a + b;
43         assert(c>=a);
44         return c;
45     }
46 
47 }
48 
49 /**
50  * Math operations with safety checks
51  */
52 contract SafeMath {
53     function safeMul(uint a, uint b) internal returns (uint) {
54         uint c = a * b;
55         assert(a == 0 || c / a == b);
56         return c;
57     }
58 
59     function safeDiv(uint a, uint b) internal returns (uint) {
60         assert(b > 0);
61         uint c = a / b;
62         assert(a == b * c + a % b);
63         return c;
64     }
65 
66     function safeSub(uint a, uint b) internal returns (uint) {
67         assert(b <= a);
68         return a - b;
69     }
70 
71     function safeAdd(uint a, uint b) internal returns (uint) {
72         uint c = a + b;
73         assert(c>=a && c>=b);
74         return c;
75     }
76 
77     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
78         return a >= b ? a : b;
79     }
80 
81     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
82         return a < b ? a : b;
83     }
84 
85     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
86         return a >= b ? a : b;
87     }
88 
89     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
90         return a < b ? a : b;
91     }
92 
93 }
94 /**
95  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
96  *
97  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
98  */
99 
100 
101 /**
102  * @title Ownable
103  * @dev The Ownable contract has an owner address, and provides basic authorization control
104  * functions, this simplifies the implementation of "user permissions".
105  */
106 contract Ownable {
107     address public owner;
108 
109 
110     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
111 
112 
113     /**
114      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
115      * account.
116      */
117     function Ownable() {
118         owner = msg.sender;
119     }
120 
121 
122     /**
123      * @dev Throws if called by any account other than the owner.
124      */
125     modifier onlyOwner() {
126         require(msg.sender == owner);
127         _;
128     }
129 
130 
131     /**
132      * @dev Allows the current owner to transfer control of the contract to a newOwner.
133      * @param newOwner The address to transfer ownership to.
134      */
135     function transferOwnership(address newOwner) onlyOwner public {
136         require(newOwner != address(0));
137         OwnershipTransferred(owner, newOwner);
138         owner = newOwner;
139     }
140 
141 }
142 
143 
144 // Created using ICO Wizard https://github.com/oraclesorg/ico-wizard by Oracles Network
145 
146 /*
147  * Haltable
148  *
149  * Abstract contract that allows children to implement an
150  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
151  *
152  *
153  * Originally envisioned in FirstBlood ICO contract.
154  */
155 contract Haltable is Ownable {
156     bool public halted;
157 
158     modifier stopInEmergency {
159         if (halted) throw;
160         _;
161     }
162 
163     modifier stopNonOwnersInEmergency {
164         if (halted && msg.sender != owner) throw;
165         _;
166     }
167 
168     modifier onlyInEmergency {
169         if (!halted) throw;
170         _;
171     }
172 
173     // called by the owner on emergency, triggers stopped state
174     function halt() external onlyOwner {
175         halted = true;
176     }
177 
178     // called by the owner on end of emergency, returns to normal state
179     function unhalt() external onlyOwner onlyInEmergency {
180         halted = false;
181     }
182 
183 }
184 
185 
186 /**
187  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
188  *
189  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
190  */
191 
192 /**
193  * @title ERC20Basic
194  * @dev Simpler version of ERC20 interface
195  * @dev see https://github.com/ethereum/EIPs/issues/179
196  */
197 contract ERC20Basic {
198     uint256 public totalSupply;
199     function balanceOf(address who) public constant returns (uint256);
200     function transfer(address to, uint256 value) public returns (bool);
201     event Transfer(address indexed from, address indexed to, uint256 value);
202 }
203 
204 
205 
206 /**
207  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
208  *
209  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
210  */
211 
212 
213 
214 /**
215  * @title ERC20 interface
216  * @dev see https://github.com/ethereum/EIPs/issues/20
217  */
218 contract ERC20 is ERC20Basic {
219     function allowance(address owner, address spender) public constant returns (uint256);
220     function transferFrom(address from, address to, uint256 value) public returns (bool);
221     function approve(address spender, uint256 value) public returns (bool);
222     event Approval(address indexed owner, address indexed spender, uint256 value);
223 }
224 
225 
226 
227 /**
228  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
229  *
230  * Based on code by FirstBlood:
231  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
232  */
233 contract StandardToken is ERC20, SafeMath {
234 
235     /* Token supply got increased and a new owner received these tokens */
236     event Minted(address receiver, uint amount);
237 
238     /* Actual balances of token holders */
239     mapping(address => uint) balances;
240 
241     /* approve() allowances */
242     mapping (address => mapping (address => uint)) allowed;
243 
244     /* Interface declaration */
245     function isToken() public constant returns (bool weAre) {
246         return true;
247     }
248 
249     function transfer(address _to, uint _value) returns (bool success) {
250         balances[msg.sender] = safeSub(balances[msg.sender], _value);
251         balances[_to] = safeAdd(balances[_to], _value);
252         Transfer(msg.sender, _to, _value);
253         return true;
254     }
255 
256     function transferFrom(address _from, address _to, uint _value) returns (bool success) {
257         uint _allowance = allowed[_from][msg.sender];
258 
259         balances[_to] = safeAdd(balances[_to], _value);
260         balances[_from] = safeSub(balances[_from], _value);
261         allowed[_from][msg.sender] = safeSub(_allowance, _value);
262         Transfer(_from, _to, _value);
263         return true;
264     }
265 
266     function balanceOf(address _owner) constant returns (uint balance) {
267         return balances[_owner];
268     }
269 
270     function approve(address _spender, uint _value) returns (bool success) {
271 
272         // To change the approve amount you first have to reduce the addresses`
273         //  allowance to zero by calling `approve(_spender, 0)` if it is not
274         //  already 0 to mitigate the race condition described here:
275         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
276         require ((_value != 0) && (allowed[msg.sender][_spender] != 0));
277 
278         allowed[msg.sender][_spender] = _value;
279         Approval(msg.sender, _spender, _value);
280         return true;
281     }
282 
283     function allowance(address _owner, address _spender) constant returns (uint remaining) {
284         return allowed[_owner][_spender];
285     }
286 
287 }
288 
289 /**
290  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
291  *
292  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
293  */
294 
295 
296 
297 
298 
299 /**
300  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
301  *
302  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
303  */
304 
305 
306 
307 /**
308  * Upgrade agent interface inspired by Lunyr.
309  *
310  * Upgrade agent transfers tokens to a new contract.
311  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
312  */
313 contract UpgradeAgent {
314 
315     uint public originalSupply;
316 
317     /** Interface marker */
318     function isUpgradeAgent() public constant returns (bool) {
319         return true;
320     }
321 
322     function upgradeFrom(address _from, uint256 _value) public;
323 
324 }
325 
326 
327 /**
328  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
329  *
330  * First envisioned by Golem and Lunyr projects.
331  */
332 contract UpgradeableToken is StandardToken {
333 
334     /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
335     address public upgradeMaster;
336 
337     /** The next contract where the tokens will be migrated. */
338     UpgradeAgent public upgradeAgent;
339 
340     /** How many tokens we have upgraded by now. */
341     uint256 public totalUpgraded;
342 
343     /**
344      * Upgrade states.
345      *
346      * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
347      * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
348      * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
349      * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
350      *
351      */
352     enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
353 
354     /**
355      * Somebody has upgraded some of his tokens.
356      */
357     event Upgrade(address indexed _from, address indexed _to, uint256 _value);
358 
359     /**
360      * New upgrade agent available.
361      */
362     event UpgradeAgentSet(address agent);
363 
364     /**
365      * Do not allow construction without upgrade master set.
366      */
367     function UpgradeableToken(address _upgradeMaster) {
368         upgradeMaster = _upgradeMaster;
369     }
370 
371     /**
372      * Allow the token holder to upgrade some of their tokens to a new contract.
373      */
374     function upgrade(uint256 value) public {
375 
376         UpgradeState state = getUpgradeState();
377         require(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading));
378 
379         // Validate input value.
380         require (value == 0);
381 
382         balances[msg.sender] = safeSub(balances[msg.sender], value);
383 
384         // Take tokens out from circulation
385         totalSupply = safeSub(totalSupply, value);
386         totalUpgraded = safeAdd(totalUpgraded, value);
387 
388         // Upgrade agent reissues the tokens
389         upgradeAgent.upgradeFrom(msg.sender, value);
390         Upgrade(msg.sender, upgradeAgent, value);
391     }
392 
393     /**
394      * Set an upgrade agent that handles
395      */
396     function setUpgradeAgent(address agent) external {
397 
398         require(!canUpgrade()); // The token is not yet in a state that we could think upgrading;
399 
400         require(agent == 0x0);
401         // Only a master can designate the next agent
402         require(msg.sender != upgradeMaster);
403         // Upgrade has already begun for an agent
404         require(getUpgradeState() == UpgradeState.Upgrading);
405 
406         upgradeAgent = UpgradeAgent(agent);
407 
408         // Bad interface
409         require(!upgradeAgent.isUpgradeAgent());
410         // Make sure that token supplies match in source and target
411         require(upgradeAgent.originalSupply() != totalSupply);
412 
413         UpgradeAgentSet(upgradeAgent);
414     }
415 
416     /**
417      * Get the state of the token upgrade.
418      */
419     function getUpgradeState() public constant returns(UpgradeState) {
420         if(!canUpgrade()) return UpgradeState.NotAllowed;
421         else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
422         else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
423         else return UpgradeState.Upgrading;
424     }
425 
426     /**
427      * Change the upgrade master.
428      *
429      * This allows us to set a new owner for the upgrade mechanism.
430      */
431     function setUpgradeMaster(address master) public {
432         require(master == 0x0);
433         require(msg.sender != upgradeMaster);
434         upgradeMaster = master;
435     }
436 
437     /**
438      * Child contract can enable to provide the condition when the upgrade can begun.
439      */
440     function canUpgrade() public constant returns(bool) {
441         return true;
442     }
443 
444 }
445 
446 /**
447  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
448  *
449  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
450  */
451 
452 
453 
454 
455 /**
456  * A token that can increase its supply by another contract.
457  *
458  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
459  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
460  *
461  */
462 contract MintableTokenExt is StandardToken, Ownable {
463 
464     using SMathLib for uint;
465 
466     bool public mintingFinished = false;
467 
468     /** List of agents that are allowed to create new tokens */
469     mapping (address => bool) public mintAgents;
470 
471     event MintingAgentChanged(address addr, bool state  );
472 
473     /** inPercentageUnit is percents of tokens multiplied to 10 up to percents decimals.
474     * For example, for reserved tokens in percents 2.54%
475     * inPercentageUnit = 254
476     * inPercentageDecimals = 2
477     */
478     struct ReservedTokensData {
479         uint inTokens;
480         uint inPercentageUnit;
481         uint inPercentageDecimals;
482     }
483 
484     mapping (address => ReservedTokensData) public reservedTokensList;
485     address[] public reservedTokensDestinations;
486     uint public reservedTokensDestinationsLen = 0;
487 
488     function setReservedTokensList(address addr, uint inTokens, uint inPercentageUnit, uint inPercentageDecimals) onlyOwner {
489         reservedTokensDestinations.push(addr);
490         reservedTokensDestinationsLen++;
491         reservedTokensList[addr] = ReservedTokensData({inTokens:inTokens, inPercentageUnit:inPercentageUnit, inPercentageDecimals: inPercentageDecimals});
492     }
493 
494     function getReservedTokensListValInTokens(address addr) constant returns (uint inTokens) {
495         return reservedTokensList[addr].inTokens;
496     }
497 
498     function getReservedTokensListValInPercentageUnit(address addr) constant returns (uint inPercentageUnit) {
499         return reservedTokensList[addr].inPercentageUnit;
500     }
501 
502     function getReservedTokensListValInPercentageDecimals(address addr) constant returns (uint inPercentageDecimals) {
503         return reservedTokensList[addr].inPercentageDecimals;
504     }
505 
506     function setReservedTokensListMultiple(address[] addrs, uint[] inTokens, uint[] inPercentageUnit, uint[] inPercentageDecimals) onlyOwner {
507         for (uint iterator = 0; iterator < addrs.length; iterator++) {
508             setReservedTokensList(addrs[iterator], inTokens[iterator], inPercentageUnit[iterator], inPercentageDecimals[iterator]);
509         }
510     }
511 
512     /**
513      * Create new tokens and allocate them to an address..
514      *
515      * Only callably by a crowdsale contract (mint agent).
516      */
517     function mint(address receiver, uint amount) onlyMintAgent canMint public {
518         totalSupply = totalSupply.plus(amount);
519         balances[receiver] = balances[receiver].plus(amount);
520 
521         // This will make the mint transaction apper in EtherScan.io
522         // We can remove this after there is a standardized minting event
523         Transfer(0, receiver, amount);
524     }
525 
526     /**
527      * Owner can allow a crowdsale contract to mint new tokens.
528      */
529     function setMintAgent(address addr, bool state) onlyOwner canMint public {
530         mintAgents[addr] = state;
531         MintingAgentChanged(addr, state);
532     }
533 
534     modifier onlyMintAgent() {
535         // Only crowdsale contracts are allowed to mint new tokens
536         if(!mintAgents[msg.sender]) {
537             revert();
538         }
539         _;
540     }
541 
542     /** Make sure we are not done yet. */
543     modifier canMint() {
544         if(mintingFinished) {
545             revert();
546         }
547         _;
548     }
549 }
550 /**
551  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
552  *
553  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
554  */
555 
556 
557 
558 /**
559  * Define interface for releasing the token transfer after a successful crowdsale.
560  */
561 contract ReleasableToken is ERC20, Ownable {
562 
563     /* The finalizer contract that allows unlift the transfer limits on this token */
564     address public releaseAgent;
565 
566     /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
567     bool public released = false;
568 
569     /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
570     mapping (address => bool) public transferAgents;
571 
572     /**
573      * Limit token transfer until the crowdsale is over.
574      *
575      */
576     modifier canTransfer(address _sender) {
577 
578         if(!released) {
579             if(!transferAgents[_sender]) {
580                 revert();
581             }
582         }
583 
584         _;
585     }
586 
587     /**
588      * Set the contract that can call release and make the token transferable.
589      *
590      * Design choice. Allow reset the release agent to fix fat finger mistakes.
591      */
592     function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
593 
594         // We don't do interface check here as we might want to a normal wallet address to act as a release agent
595         releaseAgent = addr;
596     }
597 
598     /**
599      * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
600      */
601     function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
602         transferAgents[addr] = state;
603     }
604 
605     /**
606      * One way function to release the tokens to the wild.
607      *
608      * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
609      */
610     function releaseTokenTransfer() public onlyReleaseAgent {
611         released = true;
612     }
613 
614     /** The function can be called only before or after the tokens have been releasesd */
615     modifier inReleaseState(bool releaseState) {
616         if(releaseState != released) {
617             revert();
618         }
619         _;
620     }
621 
622     /** The function can be called only by a whitelisted release agent. */
623     modifier onlyReleaseAgent() {
624         if(msg.sender != releaseAgent) {
625             revert();
626         }
627         _;
628     }
629 
630     function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
631         // Call StandardToken.transfer()
632         return super.transfer(_to, _value);
633     }
634 
635     function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
636         // Call StandardToken.transferForm()
637         return super.transferFrom(_from, _to, _value);
638     }
639 
640 }
641 
642 /**
643  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
644  *
645  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
646  */
647 
648 
649 
650 
651 
652 
653 contract BurnableToken is StandardToken {
654 
655     using SMathLib for uint;
656     event Burn(address indexed burner, uint256 value);
657 
658     /**
659      * @dev Burns a specific amount of tokens.
660      * @param _value The amount of token to be burned.
661      */
662     function burn(uint256 _value) public {
663         require(_value <= balances[msg.sender]);
664         // no need to require value <= totalSupply, since that would imply the
665         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
666 
667         address burner = msg.sender;
668         balances[burner] = balances[burner].minus(_value);
669         totalSupply = totalSupply.minus(_value);
670         Burn(burner, _value);
671     }
672 }
673 
674 
675 
676 
677 /**
678  * A crowdsaled token.
679  *
680  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
681  *
682  * - The token transfer() is disabled until the crowdsale is over
683  * - The token contract gives an opt-in upgrade path to a new contract
684  * - The same token can be part of several crowdsales through approve() mechanism
685  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
686  *
687  */
688 contract CrowdsaleTokenExt is ReleasableToken, MintableTokenExt, BurnableToken, UpgradeableToken {
689 
690     /** Name and symbol were updated. */
691     event UpdatedTokenInformation(string newName, string newSymbol);
692 
693     string public name;
694 
695     string public symbol;
696 
697     uint public decimals;
698 
699     /* Minimum ammount of tokens every buyer can buy. */
700     uint public minCap;
701 
702 
703     /**
704      * Construct the token.
705      *
706      * This token must be created through a team multisig wallet, so that it is owned by that wallet.
707      *
708      * @param _name Token name
709      * @param _symbol Token symbol - should be all caps
710      * @param _initialSupply How many tokens we start with
711      * @param _decimals Number of decimal places
712      * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
713      */
714     function CrowdsaleTokenExt(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable, uint _globalMinCap)
715     UpgradeableToken(msg.sender) {
716 
717         // Create any address, can be transferred
718         // to team multisig via changeOwner(),
719         // also remember to call setUpgradeMaster()
720         owner = msg.sender;
721 
722         name = _name;
723         symbol = _symbol;
724 
725         totalSupply = _initialSupply;
726 
727         decimals = _decimals;
728 
729         minCap = _globalMinCap;
730 
731         // Create initially all balance on the team multisig
732         balances[owner] = totalSupply;
733 
734         if(totalSupply > 0) {
735             Minted(owner, totalSupply);
736         }
737 
738         // No more new supply allowed after the token creation
739         if(!_mintable) {
740             mintingFinished = true;
741             if(totalSupply == 0) {
742                 revert(); // Cannot create a token without supply and no minting
743             }
744         }
745     }
746 
747     /**
748      * When token is released to be transferable, enforce no new tokens can be created.
749      */
750     function releaseTokenTransfer() public onlyReleaseAgent {
751         super.releaseTokenTransfer();
752     }
753 
754     /**
755      * Allow upgrade agent functionality kick in only if the crowdsale was success.
756      */
757     function canUpgrade() public constant returns(bool) {
758         return released && super.canUpgrade();
759     }
760 
761     /**
762      * Owner can update token information here.
763      *
764      * It is often useful to conceal the actual token association, until
765      * the token operations, like central issuance or reissuance have been completed.
766      *
767      * This function allows the token owner to rename the token after the operations
768      * have been completed and then point the audience to use the token contract.
769      */
770     function setTokenInformation(string _name, string _symbol) onlyOwner {
771         name = _name;
772         symbol = _symbol;
773 
774         UpdatedTokenInformation(name, symbol);
775     }
776 
777 }
778 
779 
780 contract MjtToken is CrowdsaleTokenExt {
781 
782     uint public ownersProductCommissionInPerc = 5;
783 
784     uint public operatorProductCommissionInPerc = 25;
785 
786     event IndependentSellerJoined(address sellerWallet, uint amountOfTokens, address operatorWallet);
787     event OwnersProductAdded(address ownersWallet, uint amountOfTokens, address operatorWallet);
788     event OperatorProductCommissionChanged(uint _value);
789     event OwnersProductCommissionChanged(uint _value);
790 
791 
792     function setOperatorCommission(uint _value) public onlyOwner {
793         require(_value >= 0);
794         operatorProductCommissionInPerc = _value;
795         OperatorProductCommissionChanged(_value);
796     }
797 
798     function setOwnersCommission(uint _value) public onlyOwner {
799         require(_value >= 0);
800         ownersProductCommissionInPerc = _value;
801         OwnersProductCommissionChanged(_value);
802     }
803 
804 
805     /**
806      * Method called when new seller joined the program
807      * To avoid value lost after division, amountOfTokens must be multiple of 100
808      */
809     function independentSellerJoined(address sellerWallet, uint amountOfTokens, address operatorWallet) public onlyOwner canMint {
810         require(amountOfTokens > 100);
811         require(sellerWallet != address(0));
812         require(operatorWallet != address(0));
813 
814         uint operatorCommission = amountOfTokens.divides(100).times(operatorProductCommissionInPerc);
815         uint sellerAmount = amountOfTokens.minus(operatorCommission);
816 
817         if (operatorCommission > 0) {
818             mint(operatorWallet, operatorCommission);
819         }
820 
821         if (sellerAmount > 0) {
822             mint(sellerWallet, sellerAmount);
823         }
824         IndependentSellerJoined(sellerWallet, amountOfTokens, operatorWallet);
825     }
826 
827 
828     /**
829     * Method called when owners add their own product
830     * To avoid value lost after division, amountOfTokens must be multiple of 100
831     */
832     function ownersProductAdded(address ownersWallet, uint amountOfTokens, address operatorWallet) public onlyOwner canMint {
833         require(amountOfTokens > 100);
834         require(ownersWallet != address(0));
835         require(operatorWallet != address(0));
836 
837         uint ownersComission = amountOfTokens.divides(100).times(ownersProductCommissionInPerc);
838         uint operatorAmount = amountOfTokens.minus(ownersComission);
839 
840 
841         if (ownersComission > 0) {
842             mint(ownersWallet, ownersComission);
843         }
844 
845         if (operatorAmount > 0) {
846             mint(operatorWallet, operatorAmount);
847         }
848 
849         OwnersProductAdded(ownersWallet, amountOfTokens, operatorWallet);
850     }
851 
852     function MjtToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable, uint _globalMinCap)
853     CrowdsaleTokenExt(_name, _symbol, _initialSupply, _decimals, _mintable, _globalMinCap) {}
854 
855 }
856 
857 
858 
859 
860 /**
861  * Finalize agent defines what happens at the end of succeseful crowdsale.
862  *
863  * - Allocate tokens for founders, bounties and community
864  * - Make tokens transferable
865  * - etc.
866  */
867 contract FinalizeAgent {
868 
869     function isFinalizeAgent() public constant returns(bool) {
870         return true;
871     }
872 
873     /** Return true if we can run finalizeCrowdsale() properly.
874      *
875      * This is a safety check function that doesn't allow crowdsale to begin
876      * unless the finalizer has been set up properly.
877      */
878     function isSane() public constant returns (bool);
879 
880     /** Called once by crowdsale finalize() if the sale was success. */
881     function finalizeCrowdsale();
882 
883 }
884 
885 /**
886  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
887  *
888  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
889  */
890 
891 
892 /**
893  * Interface for defining crowdsale pricing.
894  */
895 contract PricingStrategy {
896 
897     /** Interface declaration. */
898     function isPricingStrategy() public constant returns (bool) {
899         return true;
900     }
901 
902     /** Self check if all references are correctly set.
903      *
904      * Checks that pricing strategy matches crowdsale parameters.
905      */
906     function isSane(address crowdsale) public constant returns (bool) {
907         return true;
908     }
909 
910     /**
911      * @dev Pricing tells if this is a presale purchase or not.
912        @param purchaser Address of the purchaser
913        @return False by default, true if a presale purchaser
914      */
915     function isPresalePurchase(address purchaser) public constant returns (bool) {
916         return false;
917     }
918 
919     /**
920      * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
921      *
922      *
923      * @param value - What is the value of the transaction send in as wei
924      * @param tokensSold - how much tokens have been sold this far
925      * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
926      * @param msgSender - who is the investor of this transaction
927      * @param decimals - how many decimal units the token has
928      * @return Amount of tokens the investor receives
929      */
930     function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
931 }
932 
933 
934 
935 /// @dev Time milestone based pricing with special support for pre-ico deals.
936 contract MilestonePricing is PricingStrategy, Ownable {
937 
938     using SMathLib for uint;
939 
940     uint public constant MAX_MILESTONE = 10;
941 
942     // This contains all pre-ICO addresses, and their prices (weis per token)
943     mapping (address => uint) public preicoAddresses;
944 
945     /**
946     * Define pricing schedule using milestones.
947     */
948     struct Milestone {
949 
950         // UNIX timestamp when this milestone kicks in
951         uint time;
952 
953         // How many tokens per satoshi you will get after this milestone has been passed
954         uint price;
955     }
956 
957     // Store milestones in a fixed array, so that it can be seen in a blockchain explorer
958     // Milestone 0 is always (0, 0)
959     // (TODO: change this when we confirm dynamic arrays are explorable)
960     Milestone[10] public milestones;
961 
962     // How many active milestones we have
963     uint public milestoneCount;
964 
965     /// @dev Contruction, creating a list of milestones
966     /// @param _milestones uint[] milestones Pairs of (time, price)
967     function MilestonePricing(uint[] _milestones) {
968         // Need to have tuples, length check
969         if(_milestones.length % 2 == 1 || _milestones.length >= MAX_MILESTONE*2) {
970             throw;
971         }
972 
973         milestoneCount = _milestones.length / 2;
974 
975         uint lastTimestamp = 0;
976 
977         for(uint i=0; i<_milestones.length/2; i++) {
978             milestones[i].time = _milestones[i*2];
979             milestones[i].price = _milestones[i*2+1];
980 
981             // No invalid steps
982             if((lastTimestamp != 0) && (milestones[i].time <= lastTimestamp)) {
983                 throw;
984             }
985 
986             lastTimestamp = milestones[i].time;
987         }
988 
989         // Last milestone price must be zero, terminating the crowdale
990         if(milestones[milestoneCount-1].price != 0) {
991             throw;
992         }
993     }
994 
995     /// @dev This is invoked once for every pre-ICO address, set pricePerToken
996     ///      to 0 to disable
997     /// @param preicoAddress PresaleFundCollector address
998     /// @param pricePerToken How many weis one token cost for pre-ico investors
999     function setPreicoAddress(address preicoAddress, uint pricePerToken)
1000     public
1001     onlyOwner
1002     {
1003         preicoAddresses[preicoAddress] = pricePerToken;
1004     }
1005 
1006     /// @dev Iterate through milestones. You reach end of milestones when price = 0
1007     /// @return tuple (time, price)
1008     function getMilestone(uint n) public constant returns (uint, uint) {
1009         return (milestones[n].time, milestones[n].price);
1010     }
1011 
1012     function getFirstMilestone() private constant returns (Milestone) {
1013         return milestones[0];
1014     }
1015 
1016     function getLastMilestone() private constant returns (Milestone) {
1017         return milestones[milestoneCount-1];
1018     }
1019 
1020     function getPricingStartsAt() public constant returns (uint) {
1021         return getFirstMilestone().time;
1022     }
1023 
1024     function getPricingEndsAt() public constant returns (uint) {
1025         return getLastMilestone().time;
1026     }
1027 
1028     function isSane(address _crowdsale) public constant returns(bool) {
1029         CrowdsaleExt crowdsale = CrowdsaleExt(_crowdsale);
1030         return crowdsale.startsAt() == getPricingStartsAt() && crowdsale.endsAt() == getPricingEndsAt();
1031     }
1032 
1033     /// @dev Get the current milestone or bail out if we are not in the milestone periods.
1034     /// @return {[type]} [description]
1035     function getCurrentMilestone() private constant returns (Milestone) {
1036         uint i;
1037 
1038         for(i=0; i<milestones.length; i++) {
1039             if(now < milestones[i].time) {
1040                 return milestones[i-1];
1041             }
1042         }
1043     }
1044 
1045     /// @dev Get the current price.
1046     /// @return The current price or 0 if we are outside milestone period
1047     function getCurrentPrice() public constant returns (uint result) {
1048         return getCurrentMilestone().price;
1049     }
1050 
1051     /// @dev Calculate the current price for buy in amount.
1052     function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint) {
1053 
1054         uint multiplier = 10 ** decimals;
1055 
1056         // This investor is coming through pre-ico
1057         if(preicoAddresses[msgSender] > 0) {
1058             return value.times(multiplier) / preicoAddresses[msgSender];
1059         }
1060 
1061         uint price = getCurrentPrice();
1062         return value.times(multiplier) / price;
1063     }
1064 
1065     function isPresalePurchase(address purchaser) public constant returns (bool) {
1066         if(preicoAddresses[purchaser] > 0)
1067             return true;
1068         else
1069             return false;
1070     }
1071 
1072     function() payable {
1073         throw; // No money on this contract
1074     }
1075 
1076 }
1077 
1078 
1079 
1080 /**
1081  * A token that defines fractional units as decimals.
1082  */
1083 contract FractionalERC20Ext is ERC20 {
1084 
1085     uint public decimals;
1086     uint public minCap;
1087 
1088 }
1089 
1090 
1091 
1092 /**
1093  * Abstract base contract for token sales.
1094  *
1095  * Handle
1096  * - start and end dates
1097  * - accepting investments
1098  * - minimum funding goal and refund
1099  * - various statistics during the crowdfund
1100  * - different pricing strategies
1101  * - different investment policies (require server side customer id, allow only whitelisted addresses)
1102  *
1103  */
1104 contract CrowdsaleExt is Haltable {
1105 
1106     /* Max investment count when we are still allowed to change the multisig address */
1107     uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
1108 
1109     using SMathLib for uint;
1110 
1111     /* The token we are selling */
1112     FractionalERC20Ext public token;
1113 
1114     /* How we are going to price our offering */
1115     MilestonePricing public pricingStrategy;
1116 
1117     /* Post-success callback */
1118     FinalizeAgent public finalizeAgent;
1119 
1120     /* tokens will be transfered from this address */
1121     address public multisigWallet;
1122 
1123     /* if the funding goal is not reached, investors may withdraw their funds */
1124     uint public minimumFundingGoal;
1125 
1126     /* the UNIX timestamp start date of the crowdsale */
1127     uint public startsAt;
1128 
1129     /* the UNIX timestamp end date of the crowdsale */
1130     uint public endsAt;
1131 
1132     /* the number of tokens already sold through this contract*/
1133     uint public tokensSold = 0;
1134 
1135     /* How many wei of funding we have raised */
1136     uint public weiRaised = 0;
1137 
1138     /* Calculate incoming funds from presale contracts and addresses */
1139     uint public presaleWeiRaised = 0;
1140 
1141     /* How many distinct addresses have invested */
1142     uint public investorCount = 0;
1143 
1144     /* How much wei we have returned back to the contract after a failed crowdfund. */
1145     uint public loadedRefund = 0;
1146 
1147     /* How much wei we have given back to investors.*/
1148     uint public weiRefunded = 0;
1149 
1150     /* Has this crowdsale been finalized */
1151     bool public finalized;
1152 
1153     /* Do we need to have unique contributor id for each customer */
1154     bool public requireCustomerId;
1155 
1156     bool public isWhiteListed;
1157 
1158     address[] public joinedCrowdsales;
1159     uint public joinedCrowdsalesLen = 0;
1160 
1161     address public lastCrowdsale;
1162 
1163     /**
1164       * Do we verify that contributor has been cleared on the server side (accredited investors only).
1165       * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
1166       */
1167     bool public requiredSignedAddress;
1168 
1169     /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
1170     address public signerAddress;
1171 
1172     /** How much ETH each address has invested to this crowdsale */
1173     mapping (address => uint256) public investedAmountOf;
1174 
1175     /** How much tokens this crowdsale has credited for each investor address */
1176     mapping (address => uint256) public tokenAmountOf;
1177 
1178     struct WhiteListData {
1179         bool status;
1180         uint minCap;
1181         uint maxCap;
1182     }
1183 
1184     //is crowdsale updatable
1185     bool public isUpdatable;
1186 
1187     /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
1188     mapping (address => WhiteListData) public earlyParticipantWhitelist;
1189 
1190     /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
1191     uint public ownerTestValue;
1192 
1193     /** State machine
1194      *
1195      * - Preparing: All contract initialization calls and variables have not been set yet
1196      * - Prefunding: We have not passed start time yet
1197      * - Funding: Active crowdsale
1198      * - Success: Minimum funding goal reached
1199      * - Failure: Minimum funding goal not reached before ending time
1200      * - Finalized: The finalized has been called and succesfully executed
1201      * - Refunding: Refunds are loaded on the contract for reclaim.
1202      */
1203     enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
1204 
1205     // A new investment was made
1206     event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
1207 
1208     // Refund was processed for a contributor
1209     event Refund(address investor, uint weiAmount);
1210 
1211     // The rules were changed what kind of investments we accept
1212     event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
1213 
1214     // Address early participation whitelist status changed
1215     event Whitelisted(address addr, bool status);
1216 
1217     // Crowdsale start time has been changed
1218     event StartsAtChanged(uint newStartsAt);
1219 
1220     // Crowdsale end time has been changed
1221     event EndsAtChanged(uint newEndsAt);
1222 
1223     function CrowdsaleExt(address _token, MilestonePricing _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, bool _isUpdatable, bool _isWhiteListed) {
1224 
1225         owner = msg.sender;
1226 
1227         token = FractionalERC20Ext(_token);
1228 
1229         setPricingStrategy(_pricingStrategy);
1230 
1231         multisigWallet = _multisigWallet;
1232         if(multisigWallet == 0) {
1233             throw;
1234         }
1235 
1236         if(_start == 0) {
1237             throw;
1238         }
1239 
1240         startsAt = _start;
1241 
1242         if(_end == 0) {
1243             throw;
1244         }
1245 
1246         endsAt = _end;
1247 
1248         // Don't mess the dates
1249         if(startsAt >= endsAt) {
1250             throw;
1251         }
1252 
1253         // Minimum funding goal can be zero
1254         minimumFundingGoal = _minimumFundingGoal;
1255 
1256         isUpdatable = _isUpdatable;
1257 
1258         isWhiteListed = _isWhiteListed;
1259     }
1260 
1261 
1262     function() payable {
1263         invest(msg.sender);
1264     }
1265 
1266     /**
1267      * Make an investment.
1268      *
1269      * Crowdsale must be running for one to invest.
1270      * We must have not pressed the emergency brake.
1271      *
1272      * @param receiver The Ethereum address who receives the tokens
1273      * @param customerId (optional) UUID v4 to track the successful payments on the server side
1274      *
1275      */
1276     function investInternal(address receiver, uint128 customerId) stopInEmergency private {
1277 
1278         // Determine if it's a good time to accept investment from this participant
1279         if(getState() == State.PreFunding) {
1280             // Are we whitelisted for early deposit
1281             throw;
1282         } else if(getState() == State.Funding) {
1283             // Retail participants can only come in when the crowdsale is running
1284             // pass
1285             if(isWhiteListed) {
1286                 if(!earlyParticipantWhitelist[receiver].status) {
1287                     throw;
1288                 }
1289             }
1290         } else {
1291             // Unwanted state
1292             throw;
1293         }
1294 
1295         uint weiAmount = msg.value;
1296 
1297         // Account presale sales separately, so that they do not count against pricing tranches
1298         uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
1299 
1300         if(tokenAmount == 0) {
1301             // Dust transaction
1302             throw;
1303         }
1304 
1305         if(isWhiteListed) {
1306             if(tokenAmount < earlyParticipantWhitelist[receiver].minCap && tokenAmountOf[receiver] == 0) {
1307                 // tokenAmount < minCap for investor
1308                 throw;
1309             }
1310             if(tokenAmount > earlyParticipantWhitelist[receiver].maxCap) {
1311                 // tokenAmount > maxCap for investor
1312                 throw;
1313             }
1314 
1315             // Check that we did not bust the investor's cap
1316             if (isBreakingInvestorCap(receiver, tokenAmount)) {
1317                 throw;
1318             }
1319         } else {
1320             if(tokenAmount < token.minCap() && tokenAmountOf[receiver] == 0) {
1321                 throw;
1322             }
1323         }
1324 
1325         if(investedAmountOf[receiver] == 0) {
1326             // A new investor
1327             investorCount++;
1328         }
1329 
1330         // Update investor
1331         investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
1332         tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
1333 
1334         // Update totals
1335         weiRaised = weiRaised.plus(weiAmount);
1336         tokensSold = tokensSold.plus(tokenAmount);
1337 
1338         if(pricingStrategy.isPresalePurchase(receiver)) {
1339             presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
1340         }
1341 
1342         // Check that we did not bust the cap
1343         if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
1344             throw;
1345         }
1346 
1347         assignTokens(receiver, tokenAmount);
1348 
1349         // Pocket the money
1350         if(!multisigWallet.send(weiAmount)) throw;
1351 
1352         if (isWhiteListed) {
1353             uint num = 0;
1354             for (var i = 0; i < joinedCrowdsalesLen; i++) {
1355                 if (this == joinedCrowdsales[i])
1356                     num = i;
1357             }
1358 
1359             if (num + 1 < joinedCrowdsalesLen) {
1360                 for (var j = num + 1; j < joinedCrowdsalesLen; j++) {
1361                     CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
1362                     crowdsale.updateEarlyParicipantWhitelist(msg.sender, this, tokenAmount);
1363                 }
1364             }
1365         }
1366 
1367         // Tell us invest was success
1368         Invested(receiver, weiAmount, tokenAmount, customerId);
1369     }
1370 
1371     /**
1372      * Preallocate tokens for the early investors.
1373      *
1374      * Preallocated tokens have been sold before the actual crowdsale opens.
1375      * This function mints the tokens and moves the crowdsale needle.
1376      *
1377      * Investor count is not handled; it is assumed this goes for multiple investors
1378      * and the token distribution happens outside the smart contract flow.
1379      *
1380      * No money is exchanged, as the crowdsale team already have received the payment.
1381      *
1382      * @param fullTokens tokens as full tokens - decimal places added internally
1383      * @param weiPrice Price of a single full token in wei
1384      *
1385      */
1386     function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
1387 
1388         uint tokenAmount = fullTokens * 10**token.decimals();
1389         uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
1390 
1391         weiRaised = weiRaised.plus(weiAmount);
1392         tokensSold = tokensSold.plus(tokenAmount);
1393 
1394         investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
1395         tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
1396 
1397         assignTokens(receiver, tokenAmount);
1398 
1399         // Tell us invest was success
1400         Invested(receiver, weiAmount, tokenAmount, 0);
1401     }
1402 
1403     /**
1404      * Allow anonymous contributions to this crowdsale.
1405      */
1406     function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
1407         bytes32 hash = sha256(addr);
1408         if (ecrecover(hash, v, r, s) != signerAddress) throw;
1409         if(customerId == 0) throw;  // UUIDv4 sanity check
1410         investInternal(addr, customerId);
1411     }
1412 
1413     /**
1414      * Track who is the customer making the payment so we can send thank you email.
1415      */
1416     function investWithCustomerId(address addr, uint128 customerId) public payable {
1417         if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
1418         if(customerId == 0) throw;  // UUIDv4 sanity check
1419         investInternal(addr, customerId);
1420     }
1421 
1422     /**
1423      * Allow anonymous contributions to this crowdsale.
1424      */
1425     function invest(address addr) public payable {
1426         if(requireCustomerId) throw; // Crowdsale needs to track participants for thank you email
1427         if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
1428         investInternal(addr, 0);
1429     }
1430 
1431     /**
1432      * Invest to tokens, recognize the payer and clear his address.
1433      *
1434      */
1435     function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
1436         investWithSignedAddress(msg.sender, customerId, v, r, s);
1437     }
1438 
1439     /**
1440      * Invest to tokens, recognize the payer.
1441      *
1442      */
1443     function buyWithCustomerId(uint128 customerId) public payable {
1444         investWithCustomerId(msg.sender, customerId);
1445     }
1446 
1447     /**
1448      * The basic entry point to participate the crowdsale process.
1449      *
1450      * Pay for funding, get invested tokens back in the sender address.
1451      */
1452     function buy() public payable {
1453         invest(msg.sender);
1454     }
1455 
1456     /**
1457      * Finalize a succcesful crowdsale.
1458      *
1459      * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
1460      */
1461     function finalize() public inState(State.Success) onlyOwner stopInEmergency {
1462 
1463         // Already finalized
1464         if(finalized) {
1465             throw;
1466         }
1467 
1468         // Finalizing is optional. We only call it if we are given a finalizing agent.
1469         if(address(finalizeAgent) != 0) {
1470             finalizeAgent.finalizeCrowdsale();
1471         }
1472 
1473         finalized = true;
1474     }
1475 
1476     /**
1477      * Allow to (re)set finalize agent.
1478      *
1479      * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
1480      */
1481     function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
1482         finalizeAgent = addr;
1483 
1484         // Don't allow setting bad agent
1485         if(!finalizeAgent.isFinalizeAgent()) {
1486             throw;
1487         }
1488     }
1489 
1490     /**
1491      * Set policy do we need to have server-side customer ids for the investments.
1492      *
1493      */
1494     function setRequireCustomerId(bool value) onlyOwner {
1495         requireCustomerId = value;
1496         InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
1497     }
1498 
1499     /**
1500      * Set policy if all investors must be cleared on the server side first.
1501      *
1502      * This is e.g. for the accredited investor clearing.
1503      *
1504      */
1505     function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
1506         requiredSignedAddress = value;
1507         signerAddress = _signerAddress;
1508         InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
1509     }
1510 
1511     /**
1512      * Allow addresses to do early participation.
1513      *
1514      * TODO: Fix spelling error in the name
1515      */
1516     function setEarlyParicipantWhitelist(address addr, bool status, uint minCap, uint maxCap) onlyOwner {
1517         if (!isWhiteListed) throw;
1518         earlyParticipantWhitelist[addr] = WhiteListData({status:status, minCap:minCap, maxCap:maxCap});
1519         Whitelisted(addr, status);
1520     }
1521 
1522     function setEarlyParicipantsWhitelist(address[] addrs, bool[] statuses, uint[] minCaps, uint[] maxCaps) onlyOwner {
1523         if (!isWhiteListed) throw;
1524         for (uint iterator = 0; iterator < addrs.length; iterator++) {
1525             setEarlyParicipantWhitelist(addrs[iterator], statuses[iterator], minCaps[iterator], maxCaps[iterator]);
1526         }
1527     }
1528 
1529     function updateEarlyParicipantWhitelist(address addr, address contractAddr, uint tokensBought) {
1530         if (tokensBought < earlyParticipantWhitelist[addr].minCap) throw;
1531         if (!isWhiteListed) throw;
1532         if (addr != msg.sender && contractAddr != msg.sender) throw;
1533         uint newMaxCap = earlyParticipantWhitelist[addr].maxCap;
1534         newMaxCap = newMaxCap.minus(tokensBought);
1535         earlyParticipantWhitelist[addr] = WhiteListData({status:earlyParticipantWhitelist[addr].status, minCap:0, maxCap:newMaxCap});
1536     }
1537 
1538     function updateJoinedCrowdsales(address addr) onlyOwner {
1539         joinedCrowdsales[joinedCrowdsalesLen++] = addr;
1540     }
1541 
1542     function setLastCrowdsale(address addr) onlyOwner {
1543         lastCrowdsale = addr;
1544     }
1545 
1546     function clearJoinedCrowdsales() onlyOwner {
1547         joinedCrowdsalesLen = 0;
1548     }
1549 
1550     function updateJoinedCrowdsalesMultiple(address[] addrs) onlyOwner {
1551         clearJoinedCrowdsales();
1552         for (uint iter = 0; iter < addrs.length; iter++) {
1553             if(joinedCrowdsalesLen == joinedCrowdsales.length) {
1554                 joinedCrowdsales.length += 1;
1555             }
1556             joinedCrowdsales[joinedCrowdsalesLen++] = addrs[iter];
1557             if (iter == addrs.length - 1)
1558                 setLastCrowdsale(addrs[iter]);
1559         }
1560     }
1561 
1562     function setStartsAt(uint time) onlyOwner {
1563         if (finalized) throw;
1564 
1565         if (!isUpdatable) throw;
1566 
1567         if(now > time) {
1568             throw; // Don't change past
1569         }
1570 
1571         if(time > endsAt) {
1572             throw;
1573         }
1574 
1575         CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
1576         if (lastCrowdsaleCntrct.finalized()) throw;
1577 
1578         startsAt = time;
1579         StartsAtChanged(startsAt);
1580     }
1581 
1582     /**
1583      * Allow crowdsale owner to close early or extend the crowdsale.
1584      *
1585      * This is useful e.g. for a manual soft cap implementation:
1586      * - after X amount is reached determine manual closing
1587      *
1588      * This may put the crowdsale to an invalid state,
1589      * but we trust owners know what they are doing.
1590      *
1591      */
1592     function setEndsAt(uint time) onlyOwner {
1593         if (finalized) throw;
1594 
1595         if (!isUpdatable) throw;
1596 
1597         if(now > time) {
1598             throw; // Don't change past
1599         }
1600 
1601         if(startsAt > time) {
1602             throw;
1603         }
1604 
1605         CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
1606         if (lastCrowdsaleCntrct.finalized()) throw;
1607 
1608         uint num = 0;
1609         for (var i = 0; i < joinedCrowdsalesLen; i++) {
1610             if (this == joinedCrowdsales[i])
1611                 num = i;
1612         }
1613 
1614         if (num + 1 < joinedCrowdsalesLen) {
1615             for (var j = num + 1; j < joinedCrowdsalesLen; j++) {
1616                 CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
1617                 if (time > crowdsale.startsAt()) throw;
1618             }
1619         }
1620 
1621         endsAt = time;
1622         EndsAtChanged(endsAt);
1623     }
1624 
1625     /**
1626      * Allow to (re)set pricing strategy.
1627      *
1628      * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
1629      */
1630     function setPricingStrategy(MilestonePricing _pricingStrategy) onlyOwner {
1631         pricingStrategy = _pricingStrategy;
1632 
1633         // Don't allow setting bad agent
1634         if(!pricingStrategy.isPricingStrategy()) {
1635             throw;
1636         }
1637     }
1638 
1639     /**
1640      * Allow to change the team multisig address in the case of emergency.
1641      *
1642      * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
1643      * (we have done only few test transactions). After the crowdsale is going
1644      * then multisig address stays locked for the safety reasons.
1645      */
1646     function setMultisig(address addr) public onlyOwner {
1647 
1648         // Change
1649         if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
1650             throw;
1651         }
1652 
1653         multisigWallet = addr;
1654     }
1655 
1656     /**
1657      * Allow load refunds back on the contract for the refunding.
1658      *
1659      * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
1660      */
1661     function loadRefund() public payable inState(State.Failure) {
1662         if(msg.value == 0) throw;
1663         loadedRefund = loadedRefund.plus(msg.value);
1664     }
1665 
1666     /**
1667      * Investors can claim refund.
1668      *
1669      * Note that any refunds from proxy buyers should be handled separately,
1670      * and not through this contract.
1671      */
1672     function refund() public inState(State.Refunding) {
1673         uint256 weiValue = investedAmountOf[msg.sender];
1674         if (weiValue == 0) throw;
1675         investedAmountOf[msg.sender] = 0;
1676         weiRefunded = weiRefunded.plus(weiValue);
1677         Refund(msg.sender, weiValue);
1678         if (!msg.sender.send(weiValue)) throw;
1679     }
1680 
1681     /**
1682      * @return true if the crowdsale has raised enough money to be a successful.
1683      */
1684     function isMinimumGoalReached() public constant returns (bool reached) {
1685         return weiRaised >= minimumFundingGoal;
1686     }
1687 
1688     /**
1689      * Check if the contract relationship looks good.
1690      */
1691     function isFinalizerSane() public constant returns (bool sane) {
1692         return finalizeAgent.isSane();
1693     }
1694 
1695     /**
1696      * Check if the contract relationship looks good.
1697      */
1698     function isPricingSane() public constant returns (bool sane) {
1699         return pricingStrategy.isSane(address(this));
1700     }
1701 
1702     /**
1703      * Crowdfund state machine management.
1704      *
1705      * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
1706      */
1707     function getState() public constant returns (State) {
1708         if(finalized) return State.Finalized;
1709         else if (address(finalizeAgent) == 0) return State.Preparing;
1710         else if (!finalizeAgent.isSane()) return State.Preparing;
1711         else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
1712         else if (block.timestamp < startsAt) return State.PreFunding;
1713         else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
1714         else if (isMinimumGoalReached()) return State.Success;
1715         else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
1716         else return State.Failure;
1717     }
1718 
1719     /** This is for manual testing of multisig wallet interaction */
1720     function setOwnerTestValue(uint val) onlyOwner {
1721         ownerTestValue = val;
1722     }
1723 
1724     /** Interface marker. */
1725     function isCrowdsale() public constant returns (bool) {
1726         return true;
1727     }
1728 
1729     //
1730     // Modifiers
1731     //
1732 
1733     /** Modified allowing execution only if the crowdsale is currently running.  */
1734     modifier inState(State state) {
1735         if(getState() != state) throw;
1736         _;
1737     }
1738 
1739 
1740     //
1741     // Abstract functions
1742     //
1743 
1744     /**
1745      * Check if the current invested breaks our cap rules.
1746      *
1747      *
1748      * The child contract must define their own cap setting rules.
1749      * We allow a lot of flexibility through different capping strategies (ETH, token count)
1750      * Called from invest().
1751      *
1752      * @param weiAmount The amount of wei the investor tries to invest in the current transaction
1753      * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
1754      * @param weiRaisedTotal What would be our total raised balance after this transaction
1755      * @param tokensSoldTotal What would be our total sold tokens count after this transaction
1756      *
1757      * @return true if taking this investment would break our cap rules
1758      */
1759     function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
1760 
1761     function isBreakingInvestorCap(address receiver, uint tokenAmount) constant returns (bool limitBroken);
1762 
1763     /**
1764      * Check if the current crowdsale is full and we can no longer sell any tokens.
1765      */
1766     function isCrowdsaleFull() public constant returns (bool);
1767 
1768     /**
1769      * Create new tokens or transfer issued tokens to the investor depending on the cap model.
1770      */
1771     function assignTokens(address receiver, uint tokenAmount) private;
1772 }
1773 
1774 
1775 /**
1776  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
1777  *
1778  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
1779  */
1780 
1781 
1782 contract MintedTokenCappedCrowdsaleExt is CrowdsaleExt {
1783 
1784     /* Maximum amount of tokens this crowdsale can sell. */
1785     uint public maximumSellableTokens;
1786 
1787     function MintedTokenCappedCrowdsaleExt(address _token, MilestonePricing _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, uint _maximumSellableTokens, bool _isUpdatable, bool _isWhiteListed) CrowdsaleExt(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal, _isUpdatable, _isWhiteListed) {
1788         maximumSellableTokens = _maximumSellableTokens;
1789     }
1790 
1791     // Crowdsale maximumSellableTokens has been changed
1792     event MaximumSellableTokensChanged(uint newMaximumSellableTokens);
1793 
1794     /**
1795      * Called from invest() to confirm if the curret investment does not break our cap rule.
1796      */
1797     function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
1798         return tokensSoldTotal > maximumSellableTokens;
1799     }
1800 
1801     function isBreakingInvestorCap(address addr, uint tokenAmount) constant returns (bool limitBroken) {
1802         if (!isWhiteListed) throw;
1803         uint maxCap = earlyParticipantWhitelist[addr].maxCap;
1804         return (tokenAmountOf[addr].plus(tokenAmount)) > maxCap;
1805     }
1806 
1807     function isCrowdsaleFull() public constant returns (bool) {
1808         return tokensSold >= maximumSellableTokens;
1809     }
1810 
1811     /**
1812      * Dynamically create tokens and assign them to the investor.
1813      */
1814     function assignTokens(address receiver, uint tokenAmount) private {
1815         CrowdsaleTokenExt mintableToken = CrowdsaleTokenExt(token);
1816         mintableToken.mint(receiver, tokenAmount);
1817     }
1818 
1819     function setMaximumSellableTokens(uint tokens) onlyOwner {
1820         if (finalized) throw;
1821 
1822         if (!isUpdatable) throw;
1823 
1824         CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
1825         if (lastCrowdsaleCntrct.finalized()) throw;
1826 
1827         maximumSellableTokens = tokens;
1828         MaximumSellableTokensChanged(maximumSellableTokens);
1829     }
1830 }
1831 
1832 /**
1833  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
1834  *
1835  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
1836  */