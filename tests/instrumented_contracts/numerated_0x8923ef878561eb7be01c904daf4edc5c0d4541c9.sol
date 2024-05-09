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
12  * Math operations with safety checks
13  */
14 contract SafeMath {
15     function safeMul(uint a, uint b) internal returns (uint) {
16         uint c = a * b;
17         assert(a == 0 || c / a == b);
18         return c;
19     }
20 
21     function safeDiv(uint a, uint b) internal returns (uint) {
22         assert(b > 0);
23         uint c = a / b;
24         assert(a == b * c + a % b);
25         return c;
26     }
27 
28     function safeSub(uint a, uint b) internal returns (uint) {
29         assert(b <= a);
30         return a - b;
31     }
32 
33     function safeAdd(uint a, uint b) internal returns (uint) {
34         uint c = a + b;
35         assert(c>=a && c>=b);
36         return c;
37     }
38 
39     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
40         return a >= b ? a : b;
41     }
42 
43     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
44         return a < b ? a : b;
45     }
46 
47     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
48         return a >= b ? a : b;
49     }
50 
51     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
52         return a < b ? a : b;
53     }
54 
55 }
56 /**
57  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
58  *
59  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
60  */
61 
62 
63 /**
64  * @title Ownable
65  * @dev The Ownable contract has an owner address, and provides basic authorization control
66  * functions, this simplifies the implementation of "user permissions".
67  */
68 contract Ownable {
69     address public owner;
70 
71 
72     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
73 
74 
75     /**
76      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
77      * account.
78      */
79     function Ownable() {
80         owner = msg.sender;
81     }
82 
83 
84     /**
85      * @dev Throws if called by any account other than the owner.
86      */
87     modifier onlyOwner() {
88         require(msg.sender == owner);
89         _;
90     }
91 
92 
93     /**
94      * @dev Allows the current owner to transfer control of the contract to a newOwner.
95      * @param newOwner The address to transfer ownership to.
96      */
97     function transferOwnership(address newOwner) onlyOwner public {
98         require(newOwner != address(0));
99         OwnershipTransferred(owner, newOwner);
100         owner = newOwner;
101     }
102 
103 }
104 
105 
106 // Created using ICO Wizard https://github.com/oraclesorg/ico-wizard by Oracles Network
107 
108 /*
109  * Haltable
110  *
111  * Abstract contract that allows children to implement an
112  * emergency stop mechanism. Differs from Pausable by causing a throw when in halt mode.
113  *
114  *
115  * Originally envisioned in FirstBlood ICO contract.
116  */
117 contract Haltable is Ownable {
118     bool public halted;
119 
120     modifier stopInEmergency {
121         if (halted) throw;
122         _;
123     }
124 
125     modifier stopNonOwnersInEmergency {
126         if (halted && msg.sender != owner) throw;
127         _;
128     }
129 
130     modifier onlyInEmergency {
131         if (!halted) throw;
132         _;
133     }
134 
135     // called by the owner on emergency, triggers stopped state
136     function halt() external onlyOwner {
137         halted = true;
138     }
139 
140     // called by the owner on end of emergency, returns to normal state
141     function unhalt() external onlyOwner onlyInEmergency {
142         halted = false;
143     }
144 
145 }
146 
147 
148 /**
149  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
150  *
151  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
152  */
153 
154 /**
155  * @title ERC20Basic
156  * @dev Simpler version of ERC20 interface
157  * @dev see https://github.com/ethereum/EIPs/issues/179
158  */
159 contract ERC20Basic {
160     uint256 public totalSupply;
161     function balanceOf(address who) public constant returns (uint256);
162     function transfer(address to, uint256 value) public returns (bool);
163     event Transfer(address indexed from, address indexed to, uint256 value);
164 }
165 
166 
167 
168 /**
169  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
170  *
171  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
172  */
173 
174 
175 
176 /**
177  * @title ERC20 interface
178  * @dev see https://github.com/ethereum/EIPs/issues/20
179  */
180 contract ERC20 is ERC20Basic {
181     function allowance(address owner, address spender) public constant returns (uint256);
182     function transferFrom(address from, address to, uint256 value) public returns (bool);
183     function approve(address spender, uint256 value) public returns (bool);
184     event Approval(address indexed owner, address indexed spender, uint256 value);
185 }
186 
187 
188 
189 /**
190  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
191  *
192  * Based on code by FirstBlood:
193  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
194  */
195 contract StandardToken is ERC20, SafeMath {
196 
197     /* Token supply got increased and a new owner received these tokens */
198     event Minted(address receiver, uint amount);
199 
200     /* Actual balances of token holders */
201     mapping(address => uint) balances;
202 
203     /* approve() allowances */
204     mapping (address => mapping (address => uint)) allowed;
205 
206     /* Interface declaration */
207     function isToken() public constant returns (bool weAre) {
208         return true;
209     }
210 
211     function transfer(address _to, uint _value) returns (bool success) {
212         balances[msg.sender] = safeSub(balances[msg.sender], _value);
213         balances[_to] = safeAdd(balances[_to], _value);
214         Transfer(msg.sender, _to, _value);
215         return true;
216     }
217 
218     function transferFrom(address _from, address _to, uint _value) returns (bool success) {
219         uint _allowance = allowed[_from][msg.sender];
220 
221         balances[_to] = safeAdd(balances[_to], _value);
222         balances[_from] = safeSub(balances[_from], _value);
223         allowed[_from][msg.sender] = safeSub(_allowance, _value);
224         Transfer(_from, _to, _value);
225         return true;
226     }
227 
228     function balanceOf(address _owner) constant returns (uint balance) {
229         return balances[_owner];
230     }
231 
232     function approve(address _spender, uint _value) returns (bool success) {
233 
234         // To change the approve amount you first have to reduce the addresses`
235         //  allowance to zero by calling `approve(_spender, 0)` if it is not
236         //  already 0 to mitigate the race condition described here:
237         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238         require ((_value != 0) && (allowed[msg.sender][_spender] != 0));
239 
240         allowed[msg.sender][_spender] = _value;
241         Approval(msg.sender, _spender, _value);
242         return true;
243     }
244 
245     function allowance(address _owner, address _spender) constant returns (uint remaining) {
246         return allowed[_owner][_spender];
247     }
248 
249 }
250 
251 /**
252  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
253  *
254  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
255  */
256 
257 
258 
259 
260 
261 /**
262  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
263  *
264  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
265  */
266 
267 
268 
269 /**
270  * Upgrade agent interface inspired by Lunyr.
271  *
272  * Upgrade agent transfers tokens to a new contract.
273  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
274  */
275 contract UpgradeAgent {
276 
277     uint public originalSupply;
278 
279     /** Interface marker */
280     function isUpgradeAgent() public constant returns (bool) {
281         return true;
282     }
283 
284     function upgradeFrom(address _from, uint256 _value) public;
285 
286 }
287 
288 
289 /**
290  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
291  *
292  * First envisioned by Golem and Lunyr projects.
293  */
294 contract UpgradeableToken is StandardToken {
295 
296     /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
297     address public upgradeMaster;
298 
299     /** The next contract where the tokens will be migrated. */
300     UpgradeAgent public upgradeAgent;
301 
302     /** How many tokens we have upgraded by now. */
303     uint256 public totalUpgraded;
304 
305     /**
306      * Upgrade states.
307      *
308      * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
309      * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
310      * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
311      * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
312      *
313      */
314     enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
315 
316     /**
317      * Somebody has upgraded some of his tokens.
318      */
319     event Upgrade(address indexed _from, address indexed _to, uint256 _value);
320 
321     /**
322      * New upgrade agent available.
323      */
324     event UpgradeAgentSet(address agent);
325 
326     /**
327      * Do not allow construction without upgrade master set.
328      */
329     function UpgradeableToken(address _upgradeMaster) {
330         upgradeMaster = _upgradeMaster;
331     }
332 
333     /**
334      * Allow the token holder to upgrade some of their tokens to a new contract.
335      */
336     function upgrade(uint256 value) public {
337 
338         UpgradeState state = getUpgradeState();
339         require(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading));
340 
341         // Validate input value.
342         require (value == 0);
343 
344         balances[msg.sender] = safeSub(balances[msg.sender], value);
345 
346         // Take tokens out from circulation
347         totalSupply = safeSub(totalSupply, value);
348         totalUpgraded = safeAdd(totalUpgraded, value);
349 
350         // Upgrade agent reissues the tokens
351         upgradeAgent.upgradeFrom(msg.sender, value);
352         Upgrade(msg.sender, upgradeAgent, value);
353     }
354 
355     /**
356      * Set an upgrade agent that handles
357      */
358     function setUpgradeAgent(address agent) external {
359 
360         require(!canUpgrade()); // The token is not yet in a state that we could think upgrading;
361 
362         require(agent == 0x0);
363         // Only a master can designate the next agent
364         require(msg.sender != upgradeMaster);
365         // Upgrade has already begun for an agent
366         require(getUpgradeState() == UpgradeState.Upgrading);
367 
368         upgradeAgent = UpgradeAgent(agent);
369 
370         // Bad interface
371         require(!upgradeAgent.isUpgradeAgent());
372         // Make sure that token supplies match in source and target
373         require(upgradeAgent.originalSupply() != totalSupply);
374 
375         UpgradeAgentSet(upgradeAgent);
376     }
377 
378     /**
379      * Get the state of the token upgrade.
380      */
381     function getUpgradeState() public constant returns(UpgradeState) {
382         if(!canUpgrade()) return UpgradeState.NotAllowed;
383         else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
384         else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
385         else return UpgradeState.Upgrading;
386     }
387 
388     /**
389      * Change the upgrade master.
390      *
391      * This allows us to set a new owner for the upgrade mechanism.
392      */
393     function setUpgradeMaster(address master) public {
394         require(master == 0x0);
395         require(msg.sender != upgradeMaster);
396         upgradeMaster = master;
397     }
398 
399     /**
400      * Child contract can enable to provide the condition when the upgrade can begun.
401      */
402     function canUpgrade() public constant returns(bool) {
403         return true;
404     }
405 
406 }
407 
408 /**
409  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
410  *
411  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
412  */
413 
414 
415 
416 
417 /**
418  * A token that can increase its supply by another contract.
419  *
420  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
421  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
422  *
423  */
424 contract MintableTokenExt is StandardToken, Ownable {
425 
426     using SMathLib for uint;
427 
428     bool public mintingFinished = false;
429 
430     /** List of agents that are allowed to create new tokens */
431     mapping (address => bool) public mintAgents;
432 
433     event MintingAgentChanged(address addr, bool state  );
434 
435     /** inPercentageUnit is percents of tokens multiplied to 10 up to percents decimals.
436     * For example, for reserved tokens in percents 2.54%
437     * inPercentageUnit = 254
438     * inPercentageDecimals = 2
439     */
440     struct ReservedTokensData {
441         uint inTokens;
442         uint inPercentageUnit;
443         uint inPercentageDecimals;
444     }
445 
446     mapping (address => ReservedTokensData) public reservedTokensList;
447     address[] public reservedTokensDestinations;
448     uint public reservedTokensDestinationsLen = 0;
449 
450     function setReservedTokensList(address addr, uint inTokens, uint inPercentageUnit, uint inPercentageDecimals) onlyOwner {
451         reservedTokensDestinations.push(addr);
452         reservedTokensDestinationsLen++;
453         reservedTokensList[addr] = ReservedTokensData({inTokens:inTokens, inPercentageUnit:inPercentageUnit, inPercentageDecimals: inPercentageDecimals});
454     }
455 
456     function getReservedTokensListValInTokens(address addr) constant returns (uint inTokens) {
457         return reservedTokensList[addr].inTokens;
458     }
459 
460     function getReservedTokensListValInPercentageUnit(address addr) constant returns (uint inPercentageUnit) {
461         return reservedTokensList[addr].inPercentageUnit;
462     }
463 
464     function getReservedTokensListValInPercentageDecimals(address addr) constant returns (uint inPercentageDecimals) {
465         return reservedTokensList[addr].inPercentageDecimals;
466     }
467 
468     function setReservedTokensListMultiple(address[] addrs, uint[] inTokens, uint[] inPercentageUnit, uint[] inPercentageDecimals) onlyOwner {
469         for (uint iterator = 0; iterator < addrs.length; iterator++) {
470             setReservedTokensList(addrs[iterator], inTokens[iterator], inPercentageUnit[iterator], inPercentageDecimals[iterator]);
471         }
472     }
473 
474     /**
475      * Create new tokens and allocate them to an address..
476      *
477      * Only callably by a crowdsale contract (mint agent).
478      */
479     function mint(address receiver, uint amount) onlyMintAgent canMint public {
480         totalSupply = totalSupply.plus(amount);
481         balances[receiver] = balances[receiver].plus(amount);
482 
483         // This will make the mint transaction apper in EtherScan.io
484         // We can remove this after there is a standardized minting event
485         Transfer(0, receiver, amount);
486     }
487 
488     /**
489      * Owner can allow a crowdsale contract to mint new tokens.
490      */
491     function setMintAgent(address addr, bool state) onlyOwner canMint public {
492         mintAgents[addr] = state;
493         MintingAgentChanged(addr, state);
494     }
495 
496     modifier onlyMintAgent() {
497         // Only crowdsale contracts are allowed to mint new tokens
498         if(!mintAgents[msg.sender]) {
499             revert();
500         }
501         _;
502     }
503 
504     /** Make sure we are not done yet. */
505     modifier canMint() {
506         if(mintingFinished) {
507             revert();
508         }
509         _;
510     }
511 }
512 /**
513  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
514  *
515  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
516  */
517 
518 
519 
520 /**
521  * Define interface for releasing the token transfer after a successful crowdsale.
522  */
523 contract ReleasableToken is ERC20, Ownable {
524 
525     /* The finalizer contract that allows unlift the transfer limits on this token */
526     address public releaseAgent;
527 
528     /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
529     bool public released = false;
530 
531     /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
532     mapping (address => bool) public transferAgents;
533 
534     /**
535      * Limit token transfer until the crowdsale is over.
536      *
537      */
538     modifier canTransfer(address _sender) {
539 
540         if(!released) {
541             if(!transferAgents[_sender]) {
542                 revert();
543             }
544         }
545 
546         _;
547     }
548 
549     /**
550      * Set the contract that can call release and make the token transferable.
551      *
552      * Design choice. Allow reset the release agent to fix fat finger mistakes.
553      */
554     function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
555 
556         // We don't do interface check here as we might want to a normal wallet address to act as a release agent
557         releaseAgent = addr;
558     }
559 
560     /**
561      * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
562      */
563     function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
564         transferAgents[addr] = state;
565     }
566 
567     /**
568      * One way function to release the tokens to the wild.
569      *
570      * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
571      */
572     function releaseTokenTransfer() public onlyReleaseAgent {
573         released = true;
574     }
575 
576     /** The function can be called only before or after the tokens have been releasesd */
577     modifier inReleaseState(bool releaseState) {
578         if(releaseState != released) {
579             revert();
580         }
581         _;
582     }
583 
584     /** The function can be called only by a whitelisted release agent. */
585     modifier onlyReleaseAgent() {
586         if(msg.sender != releaseAgent) {
587             revert();
588         }
589         _;
590     }
591 
592     function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
593         // Call StandardToken.transfer()
594         return super.transfer(_to, _value);
595     }
596 
597     function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
598         // Call StandardToken.transferForm()
599         return super.transferFrom(_from, _to, _value);
600     }
601 
602 }
603 
604 /**
605  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
606  *
607  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
608  */
609 
610 
611 
612 
613 
614 
615 contract BurnableToken is StandardToken {
616 
617     using SMathLib for uint;
618     event Burn(address indexed burner, uint256 value);
619 
620     /**
621      * @dev Burns a specific amount of tokens.
622      * @param _value The amount of token to be burned.
623      */
624     function burn(uint256 _value) public {
625         require(_value <= balances[msg.sender]);
626         // no need to require value <= totalSupply, since that would imply the
627         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
628 
629         address burner = msg.sender;
630         balances[burner] = balances[burner].minus(_value);
631         totalSupply = totalSupply.minus(_value);
632         Burn(burner, _value);
633     }
634 }
635 
636 
637 
638 
639 /**
640  * A crowdsaled token.
641  *
642  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
643  *
644  * - The token transfer() is disabled until the crowdsale is over
645  * - The token contract gives an opt-in upgrade path to a new contract
646  * - The same token can be part of several crowdsales through approve() mechanism
647  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
648  *
649  */
650 contract CrowdsaleTokenExt is ReleasableToken, MintableTokenExt, BurnableToken, UpgradeableToken {
651 
652     /** Name and symbol were updated. */
653     event UpdatedTokenInformation(string newName, string newSymbol);
654 
655     string public name;
656 
657     string public symbol;
658 
659     uint public decimals;
660 
661     /* Minimum ammount of tokens every buyer can buy. */
662     uint public minCap;
663 
664 
665     /**
666      * Construct the token.
667      *
668      * This token must be created through a team multisig wallet, so that it is owned by that wallet.
669      *
670      * @param _name Token name
671      * @param _symbol Token symbol - should be all caps
672      * @param _initialSupply How many tokens we start with
673      * @param _decimals Number of decimal places
674      * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
675      */
676     function CrowdsaleTokenExt(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable, uint _globalMinCap)
677     UpgradeableToken(msg.sender) {
678 
679         // Create any address, can be transferred
680         // to team multisig via changeOwner(),
681         // also remember to call setUpgradeMaster()
682         owner = msg.sender;
683 
684         name = _name;
685         symbol = _symbol;
686 
687         totalSupply = _initialSupply;
688 
689         decimals = _decimals;
690 
691         minCap = _globalMinCap;
692 
693         // Create initially all balance on the team multisig
694         balances[owner] = totalSupply;
695 
696         if(totalSupply > 0) {
697             Minted(owner, totalSupply);
698         }
699 
700         // No more new supply allowed after the token creation
701         if(!_mintable) {
702             mintingFinished = true;
703             if(totalSupply == 0) {
704                 revert(); // Cannot create a token without supply and no minting
705             }
706         }
707     }
708 
709     /**
710      * When token is released to be transferable, enforce no new tokens can be created.
711      */
712     function releaseTokenTransfer() public onlyReleaseAgent {
713         super.releaseTokenTransfer();
714     }
715 
716     /**
717      * Allow upgrade agent functionality kick in only if the crowdsale was success.
718      */
719     function canUpgrade() public constant returns(bool) {
720         return released && super.canUpgrade();
721     }
722 
723     /**
724      * Owner can update token information here.
725      *
726      * It is often useful to conceal the actual token association, until
727      * the token operations, like central issuance or reissuance have been completed.
728      *
729      * This function allows the token owner to rename the token after the operations
730      * have been completed and then point the audience to use the token contract.
731      */
732     function setTokenInformation(string _name, string _symbol) onlyOwner {
733         name = _name;
734         symbol = _symbol;
735 
736         UpdatedTokenInformation(name, symbol);
737     }
738 
739 }
740 
741 
742 contract MjtToken is CrowdsaleTokenExt {
743 
744     uint public ownersProductCommissionInPerc = 5;
745 
746     uint public operatorProductCommissionInPerc = 25;
747 
748     event IndependentSellerJoined(address sellerWallet, uint amountOfTokens, address operatorWallet);
749     event OwnersProductAdded(address ownersWallet, uint amountOfTokens, address operatorWallet);
750     event OperatorProductCommissionChanged(uint _value);
751     event OwnersProductCommissionChanged(uint _value);
752 
753 
754     function setOperatorCommission(uint _value) public onlyOwner {
755         require(_value >= 0);
756         operatorProductCommissionInPerc = _value;
757         OperatorProductCommissionChanged(_value);
758     }
759 
760     function setOwnersCommission(uint _value) public onlyOwner {
761         require(_value >= 0);
762         ownersProductCommissionInPerc = _value;
763         OwnersProductCommissionChanged(_value);
764     }
765 
766 
767     /**
768      * Method called when new seller joined the program
769      * To avoid value lost after division, amountOfTokens must be multiple of 100
770      */
771     function independentSellerJoined(address sellerWallet, uint amountOfTokens, address operatorWallet) public onlyOwner canMint {
772         require(amountOfTokens > 100);
773         require(sellerWallet != address(0));
774         require(operatorWallet != address(0));
775 
776         uint operatorCommission = amountOfTokens.divides(100).times(operatorProductCommissionInPerc);
777         uint sellerAmount = amountOfTokens.minus(operatorCommission);
778 
779         if (operatorCommission > 0) {
780             mint(operatorWallet, operatorCommission);
781         }
782 
783         if (sellerAmount > 0) {
784             mint(sellerWallet, sellerAmount);
785         }
786         IndependentSellerJoined(sellerWallet, amountOfTokens, operatorWallet);
787     }
788 
789 
790     /**
791     * Method called when owners add their own product
792     * To avoid value lost after division, amountOfTokens must be multiple of 100
793     */
794     function ownersProductAdded(address ownersWallet, uint amountOfTokens, address operatorWallet) public onlyOwner canMint {
795         require(amountOfTokens > 100);
796         require(ownersWallet != address(0));
797         require(operatorWallet != address(0));
798 
799         uint ownersComission = amountOfTokens.divides(100).times(ownersProductCommissionInPerc);
800         uint operatorAmount = amountOfTokens.minus(ownersComission);
801 
802 
803         if (ownersComission > 0) {
804             mint(ownersWallet, ownersComission);
805         }
806 
807         if (operatorAmount > 0) {
808             mint(operatorWallet, operatorAmount);
809         }
810 
811         OwnersProductAdded(ownersWallet, amountOfTokens, operatorWallet);
812     }
813 
814     function MjtToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable, uint _globalMinCap)
815     CrowdsaleTokenExt(_name, _symbol, _initialSupply, _decimals, _mintable, _globalMinCap) {}
816 
817 }
818 
819 
820 
821 
822 /**
823  * Finalize agent defines what happens at the end of succeseful crowdsale.
824  *
825  * - Allocate tokens for founders, bounties and community
826  * - Make tokens transferable
827  * - etc.
828  */
829 contract FinalizeAgent {
830 
831     function isFinalizeAgent() public constant returns(bool) {
832         return true;
833     }
834 
835     /** Return true if we can run finalizeCrowdsale() properly.
836      *
837      * This is a safety check function that doesn't allow crowdsale to begin
838      * unless the finalizer has been set up properly.
839      */
840     function isSane() public constant returns (bool);
841 
842     /** Called once by crowdsale finalize() if the sale was success. */
843     function finalizeCrowdsale();
844 
845 }
846 
847 /**
848  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
849  *
850  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
851  */
852 
853 
854 /**
855  * Interface for defining crowdsale pricing.
856  */
857 contract PricingStrategy {
858 
859     /** Interface declaration. */
860     function isPricingStrategy() public constant returns (bool) {
861         return true;
862     }
863 
864     /** Self check if all references are correctly set.
865      *
866      * Checks that pricing strategy matches crowdsale parameters.
867      */
868     function isSane(address crowdsale) public constant returns (bool) {
869         return true;
870     }
871 
872     /**
873      * @dev Pricing tells if this is a presale purchase or not.
874        @param purchaser Address of the purchaser
875        @return False by default, true if a presale purchaser
876      */
877     function isPresalePurchase(address purchaser) public constant returns (bool) {
878         return false;
879     }
880 
881     /**
882      * When somebody tries to buy tokens for X eth, calculate how many tokens they get.
883      *
884      *
885      * @param value - What is the value of the transaction send in as wei
886      * @param tokensSold - how much tokens have been sold this far
887      * @param weiRaised - how much money has been raised this far in the main token sale - this number excludes presale
888      * @param msgSender - who is the investor of this transaction
889      * @param decimals - how many decimal units the token has
890      * @return Amount of tokens the investor receives
891      */
892     function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint tokenAmount);
893 }
894 
895 
896 
897 /// @dev Time milestone based pricing with special support for pre-ico deals.
898 contract MilestonePricing is PricingStrategy, Ownable {
899 
900     using SMathLib for uint;
901 
902     uint public constant MAX_MILESTONE = 10;
903 
904     // This contains all pre-ICO addresses, and their prices (weis per token)
905     mapping (address => uint) public preicoAddresses;
906 
907     /**
908     * Define pricing schedule using milestones.
909     */
910     struct Milestone {
911 
912         // UNIX timestamp when this milestone kicks in
913         uint time;
914 
915         // How many tokens per satoshi you will get after this milestone has been passed
916         uint price;
917     }
918 
919     // Store milestones in a fixed array, so that it can be seen in a blockchain explorer
920     // Milestone 0 is always (0, 0)
921     // (TODO: change this when we confirm dynamic arrays are explorable)
922     Milestone[10] public milestones;
923 
924     // How many active milestones we have
925     uint public milestoneCount;
926 
927     /// @dev Contruction, creating a list of milestones
928     /// @param _milestones uint[] milestones Pairs of (time, price)
929     function MilestonePricing(uint[] _milestones) {
930         // Need to have tuples, length check
931         if(_milestones.length % 2 == 1 || _milestones.length >= MAX_MILESTONE*2) {
932             throw;
933         }
934 
935         milestoneCount = _milestones.length / 2;
936 
937         uint lastTimestamp = 0;
938 
939         for(uint i=0; i<_milestones.length/2; i++) {
940             milestones[i].time = _milestones[i*2];
941             milestones[i].price = _milestones[i*2+1];
942 
943             // No invalid steps
944             if((lastTimestamp != 0) && (milestones[i].time <= lastTimestamp)) {
945                 throw;
946             }
947 
948             lastTimestamp = milestones[i].time;
949         }
950 
951         // Last milestone price must be zero, terminating the crowdale
952         if(milestones[milestoneCount-1].price != 0) {
953             throw;
954         }
955     }
956 
957     /// @dev This is invoked once for every pre-ICO address, set pricePerToken
958     ///      to 0 to disable
959     /// @param preicoAddress PresaleFundCollector address
960     /// @param pricePerToken How many weis one token cost for pre-ico investors
961     function setPreicoAddress(address preicoAddress, uint pricePerToken)
962     public
963     onlyOwner
964     {
965         preicoAddresses[preicoAddress] = pricePerToken;
966     }
967 
968     /// @dev Iterate through milestones. You reach end of milestones when price = 0
969     /// @return tuple (time, price)
970     function getMilestone(uint n) public constant returns (uint, uint) {
971         return (milestones[n].time, milestones[n].price);
972     }
973 
974     function getFirstMilestone() private constant returns (Milestone) {
975         return milestones[0];
976     }
977 
978     function getLastMilestone() private constant returns (Milestone) {
979         return milestones[milestoneCount-1];
980     }
981 
982     function getPricingStartsAt() public constant returns (uint) {
983         return getFirstMilestone().time;
984     }
985 
986     function getPricingEndsAt() public constant returns (uint) {
987         return getLastMilestone().time;
988     }
989 
990     function isSane(address _crowdsale) public constant returns(bool) {
991         CrowdsaleExt crowdsale = CrowdsaleExt(_crowdsale);
992         return crowdsale.startsAt() == getPricingStartsAt() && crowdsale.endsAt() == getPricingEndsAt();
993     }
994 
995     /// @dev Get the current milestone or bail out if we are not in the milestone periods.
996     /// @return {[type]} [description]
997     function getCurrentMilestone() private constant returns (Milestone) {
998         uint i;
999 
1000         for(i=0; i<milestones.length; i++) {
1001             if(now < milestones[i].time) {
1002                 return milestones[i-1];
1003             }
1004         }
1005     }
1006 
1007     /// @dev Get the current price.
1008     /// @return The current price or 0 if we are outside milestone period
1009     function getCurrentPrice() public constant returns (uint result) {
1010         return getCurrentMilestone().price;
1011     }
1012 
1013     /// @dev Calculate the current price for buy in amount.
1014     function calculatePrice(uint value, uint weiRaised, uint tokensSold, address msgSender, uint decimals) public constant returns (uint) {
1015 
1016         uint multiplier = 10 ** decimals;
1017 
1018         // This investor is coming through pre-ico
1019         if(preicoAddresses[msgSender] > 0) {
1020             return value.times(multiplier) / preicoAddresses[msgSender];
1021         }
1022 
1023         uint price = getCurrentPrice();
1024         return value.times(multiplier) / price;
1025     }
1026 
1027     function isPresalePurchase(address purchaser) public constant returns (bool) {
1028         if(preicoAddresses[purchaser] > 0)
1029             return true;
1030         else
1031             return false;
1032     }
1033 
1034     function() payable {
1035         throw; // No money on this contract
1036     }
1037 
1038 }
1039 
1040 
1041 
1042 /**
1043  * A token that defines fractional units as decimals.
1044  */
1045 contract FractionalERC20Ext is ERC20 {
1046 
1047     uint public decimals;
1048     uint public minCap;
1049 
1050 }
1051 
1052 
1053 
1054 /**
1055  * Abstract base contract for token sales.
1056  *
1057  * Handle
1058  * - start and end dates
1059  * - accepting investments
1060  * - minimum funding goal and refund
1061  * - various statistics during the crowdfund
1062  * - different pricing strategies
1063  * - different investment policies (require server side customer id, allow only whitelisted addresses)
1064  *
1065  */
1066 contract CrowdsaleExt is Haltable {
1067 
1068     /* Max investment count when we are still allowed to change the multisig address */
1069     uint public MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE = 5;
1070 
1071     using SMathLib for uint;
1072 
1073     /* The token we are selling */
1074     FractionalERC20Ext public token;
1075 
1076     /* How we are going to price our offering */
1077     MilestonePricing public pricingStrategy;
1078 
1079     /* Post-success callback */
1080     FinalizeAgent public finalizeAgent;
1081 
1082     /* tokens will be transfered from this address */
1083     address public multisigWallet;
1084 
1085     /* if the funding goal is not reached, investors may withdraw their funds */
1086     uint public minimumFundingGoal;
1087 
1088     /* the UNIX timestamp start date of the crowdsale */
1089     uint public startsAt;
1090 
1091     /* the UNIX timestamp end date of the crowdsale */
1092     uint public endsAt;
1093 
1094     /* the number of tokens already sold through this contract*/
1095     uint public tokensSold = 0;
1096 
1097     /* How many wei of funding we have raised */
1098     uint public weiRaised = 0;
1099 
1100     /* Calculate incoming funds from presale contracts and addresses */
1101     uint public presaleWeiRaised = 0;
1102 
1103     /* How many distinct addresses have invested */
1104     uint public investorCount = 0;
1105 
1106     /* How much wei we have returned back to the contract after a failed crowdfund. */
1107     uint public loadedRefund = 0;
1108 
1109     /* How much wei we have given back to investors.*/
1110     uint public weiRefunded = 0;
1111 
1112     /* Has this crowdsale been finalized */
1113     bool public finalized;
1114 
1115     /* Do we need to have unique contributor id for each customer */
1116     bool public requireCustomerId;
1117 
1118     bool public isWhiteListed;
1119 
1120     address[] public joinedCrowdsales;
1121     uint public joinedCrowdsalesLen = 0;
1122 
1123     address public lastCrowdsale;
1124 
1125     /**
1126       * Do we verify that contributor has been cleared on the server side (accredited investors only).
1127       * This method was first used in FirstBlood crowdsale to ensure all contributors have accepted terms on sale (on the web).
1128       */
1129     bool public requiredSignedAddress;
1130 
1131     /* Server side address that signed allowed contributors (Ethereum addresses) that can participate the crowdsale */
1132     address public signerAddress;
1133 
1134     /** How much ETH each address has invested to this crowdsale */
1135     mapping (address => uint256) public investedAmountOf;
1136 
1137     /** How much tokens this crowdsale has credited for each investor address */
1138     mapping (address => uint256) public tokenAmountOf;
1139 
1140     struct WhiteListData {
1141         bool status;
1142         uint minCap;
1143         uint maxCap;
1144     }
1145 
1146     //is crowdsale updatable
1147     bool public isUpdatable;
1148 
1149     /** Addresses that are allowed to invest even before ICO offical opens. For testing, for ICO partners, etc. */
1150     mapping (address => WhiteListData) public earlyParticipantWhitelist;
1151 
1152     /** This is for manul testing for the interaction from owner wallet. You can set it to any value and inspect this in blockchain explorer to see that crowdsale interaction works. */
1153     uint public ownerTestValue;
1154 
1155     /** State machine
1156      *
1157      * - Preparing: All contract initialization calls and variables have not been set yet
1158      * - Prefunding: We have not passed start time yet
1159      * - Funding: Active crowdsale
1160      * - Success: Minimum funding goal reached
1161      * - Failure: Minimum funding goal not reached before ending time
1162      * - Finalized: The finalized has been called and succesfully executed
1163      * - Refunding: Refunds are loaded on the contract for reclaim.
1164      */
1165     enum State{Unknown, Preparing, PreFunding, Funding, Success, Failure, Finalized, Refunding}
1166 
1167     // A new investment was made
1168     event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
1169 
1170     // Refund was processed for a contributor
1171     event Refund(address investor, uint weiAmount);
1172 
1173     // The rules were changed what kind of investments we accept
1174     event InvestmentPolicyChanged(bool newRequireCustomerId, bool newRequiredSignedAddress, address newSignerAddress);
1175 
1176     // Address early participation whitelist status changed
1177     event Whitelisted(address addr, bool status);
1178 
1179     // Crowdsale start time has been changed
1180     event StartsAtChanged(uint newStartsAt);
1181 
1182     // Crowdsale end time has been changed
1183     event EndsAtChanged(uint newEndsAt);
1184 
1185     function CrowdsaleExt(address _token, MilestonePricing _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, bool _isUpdatable, bool _isWhiteListed) {
1186 
1187         owner = msg.sender;
1188 
1189         token = FractionalERC20Ext(_token);
1190 
1191         setPricingStrategy(_pricingStrategy);
1192 
1193         multisigWallet = _multisigWallet;
1194         if(multisigWallet == 0) {
1195             throw;
1196         }
1197 
1198         if(_start == 0) {
1199             throw;
1200         }
1201 
1202         startsAt = _start;
1203 
1204         if(_end == 0) {
1205             throw;
1206         }
1207 
1208         endsAt = _end;
1209 
1210         // Don't mess the dates
1211         if(startsAt >= endsAt) {
1212             throw;
1213         }
1214 
1215         // Minimum funding goal can be zero
1216         minimumFundingGoal = _minimumFundingGoal;
1217 
1218         isUpdatable = _isUpdatable;
1219 
1220         isWhiteListed = _isWhiteListed;
1221     }
1222 
1223     /**
1224      * Don't expect to just send in money and get tokens.
1225      */
1226     function() payable {
1227         throw;
1228     }
1229 
1230     /**
1231      * Make an investment.
1232      *
1233      * Crowdsale must be running for one to invest.
1234      * We must have not pressed the emergency brake.
1235      *
1236      * @param receiver The Ethereum address who receives the tokens
1237      * @param customerId (optional) UUID v4 to track the successful payments on the server side
1238      *
1239      */
1240     function investInternal(address receiver, uint128 customerId) stopInEmergency private {
1241 
1242         // Determine if it's a good time to accept investment from this participant
1243         if(getState() == State.PreFunding) {
1244             // Are we whitelisted for early deposit
1245             throw;
1246         } else if(getState() == State.Funding) {
1247             // Retail participants can only come in when the crowdsale is running
1248             // pass
1249             if(isWhiteListed) {
1250                 if(!earlyParticipantWhitelist[receiver].status) {
1251                     throw;
1252                 }
1253             }
1254         } else {
1255             // Unwanted state
1256             throw;
1257         }
1258 
1259         uint weiAmount = msg.value;
1260 
1261         // Account presale sales separately, so that they do not count against pricing tranches
1262         uint tokenAmount = pricingStrategy.calculatePrice(weiAmount, weiRaised - presaleWeiRaised, tokensSold, msg.sender, token.decimals());
1263 
1264         if(tokenAmount == 0) {
1265             // Dust transaction
1266             throw;
1267         }
1268 
1269         if(isWhiteListed) {
1270             if(tokenAmount < earlyParticipantWhitelist[receiver].minCap && tokenAmountOf[receiver] == 0) {
1271                 // tokenAmount < minCap for investor
1272                 throw;
1273             }
1274             if(tokenAmount > earlyParticipantWhitelist[receiver].maxCap) {
1275                 // tokenAmount > maxCap for investor
1276                 throw;
1277             }
1278 
1279             // Check that we did not bust the investor's cap
1280             if (isBreakingInvestorCap(receiver, tokenAmount)) {
1281                 throw;
1282             }
1283         } else {
1284             if(tokenAmount < token.minCap() && tokenAmountOf[receiver] == 0) {
1285                 throw;
1286             }
1287         }
1288 
1289         if(investedAmountOf[receiver] == 0) {
1290             // A new investor
1291             investorCount++;
1292         }
1293 
1294         // Update investor
1295         investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
1296         tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
1297 
1298         // Update totals
1299         weiRaised = weiRaised.plus(weiAmount);
1300         tokensSold = tokensSold.plus(tokenAmount);
1301 
1302         if(pricingStrategy.isPresalePurchase(receiver)) {
1303             presaleWeiRaised = presaleWeiRaised.plus(weiAmount);
1304         }
1305 
1306         // Check that we did not bust the cap
1307         if(isBreakingCap(weiAmount, tokenAmount, weiRaised, tokensSold)) {
1308             throw;
1309         }
1310 
1311         assignTokens(receiver, tokenAmount);
1312 
1313         // Pocket the money
1314         if(!multisigWallet.send(weiAmount)) throw;
1315 
1316         if (isWhiteListed) {
1317             uint num = 0;
1318             for (var i = 0; i < joinedCrowdsalesLen; i++) {
1319                 if (this == joinedCrowdsales[i])
1320                     num = i;
1321             }
1322 
1323             if (num + 1 < joinedCrowdsalesLen) {
1324                 for (var j = num + 1; j < joinedCrowdsalesLen; j++) {
1325                     CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
1326                     crowdsale.updateEarlyParicipantWhitelist(msg.sender, this, tokenAmount);
1327                 }
1328             }
1329         }
1330 
1331         // Tell us invest was success
1332         Invested(receiver, weiAmount, tokenAmount, customerId);
1333     }
1334 
1335     /**
1336      * Preallocate tokens for the early investors.
1337      *
1338      * Preallocated tokens have been sold before the actual crowdsale opens.
1339      * This function mints the tokens and moves the crowdsale needle.
1340      *
1341      * Investor count is not handled; it is assumed this goes for multiple investors
1342      * and the token distribution happens outside the smart contract flow.
1343      *
1344      * No money is exchanged, as the crowdsale team already have received the payment.
1345      *
1346      * @param fullTokens tokens as full tokens - decimal places added internally
1347      * @param weiPrice Price of a single full token in wei
1348      *
1349      */
1350     function preallocate(address receiver, uint fullTokens, uint weiPrice) public onlyOwner {
1351 
1352         uint tokenAmount = fullTokens * 10**token.decimals();
1353         uint weiAmount = weiPrice * fullTokens; // This can be also 0, we give out tokens for free
1354 
1355         weiRaised = weiRaised.plus(weiAmount);
1356         tokensSold = tokensSold.plus(tokenAmount);
1357 
1358         investedAmountOf[receiver] = investedAmountOf[receiver].plus(weiAmount);
1359         tokenAmountOf[receiver] = tokenAmountOf[receiver].plus(tokenAmount);
1360 
1361         assignTokens(receiver, tokenAmount);
1362 
1363         // Tell us invest was success
1364         Invested(receiver, weiAmount, tokenAmount, 0);
1365     }
1366 
1367     /**
1368      * Allow anonymous contributions to this crowdsale.
1369      */
1370     function investWithSignedAddress(address addr, uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
1371         bytes32 hash = sha256(addr);
1372         if (ecrecover(hash, v, r, s) != signerAddress) throw;
1373         if(customerId == 0) throw;  // UUIDv4 sanity check
1374         investInternal(addr, customerId);
1375     }
1376 
1377     /**
1378      * Track who is the customer making the payment so we can send thank you email.
1379      */
1380     function investWithCustomerId(address addr, uint128 customerId) public payable {
1381         if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
1382         if(customerId == 0) throw;  // UUIDv4 sanity check
1383         investInternal(addr, customerId);
1384     }
1385 
1386     /**
1387      * Allow anonymous contributions to this crowdsale.
1388      */
1389     function invest(address addr) public payable {
1390         if(requireCustomerId) throw; // Crowdsale needs to track participants for thank you email
1391         if(requiredSignedAddress) throw; // Crowdsale allows only server-side signed participants
1392         investInternal(addr, 0);
1393     }
1394 
1395     /**
1396      * Invest to tokens, recognize the payer and clear his address.
1397      *
1398      */
1399     function buyWithSignedAddress(uint128 customerId, uint8 v, bytes32 r, bytes32 s) public payable {
1400         investWithSignedAddress(msg.sender, customerId, v, r, s);
1401     }
1402 
1403     /**
1404      * Invest to tokens, recognize the payer.
1405      *
1406      */
1407     function buyWithCustomerId(uint128 customerId) public payable {
1408         investWithCustomerId(msg.sender, customerId);
1409     }
1410 
1411     /**
1412      * The basic entry point to participate the crowdsale process.
1413      *
1414      * Pay for funding, get invested tokens back in the sender address.
1415      */
1416     function buy() public payable {
1417         invest(msg.sender);
1418     }
1419 
1420     /**
1421      * Finalize a succcesful crowdsale.
1422      *
1423      * The owner can triggre a call the contract that provides post-crowdsale actions, like releasing the tokens.
1424      */
1425     function finalize() public inState(State.Success) onlyOwner stopInEmergency {
1426 
1427         // Already finalized
1428         if(finalized) {
1429             throw;
1430         }
1431 
1432         // Finalizing is optional. We only call it if we are given a finalizing agent.
1433         if(address(finalizeAgent) != 0) {
1434             finalizeAgent.finalizeCrowdsale();
1435         }
1436 
1437         finalized = true;
1438     }
1439 
1440     /**
1441      * Allow to (re)set finalize agent.
1442      *
1443      * Design choice: no state restrictions on setting this, so that we can fix fat finger mistakes.
1444      */
1445     function setFinalizeAgent(FinalizeAgent addr) onlyOwner {
1446         finalizeAgent = addr;
1447 
1448         // Don't allow setting bad agent
1449         if(!finalizeAgent.isFinalizeAgent()) {
1450             throw;
1451         }
1452     }
1453 
1454     /**
1455      * Set policy do we need to have server-side customer ids for the investments.
1456      *
1457      */
1458     function setRequireCustomerId(bool value) onlyOwner {
1459         requireCustomerId = value;
1460         InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
1461     }
1462 
1463     /**
1464      * Set policy if all investors must be cleared on the server side first.
1465      *
1466      * This is e.g. for the accredited investor clearing.
1467      *
1468      */
1469     function setRequireSignedAddress(bool value, address _signerAddress) onlyOwner {
1470         requiredSignedAddress = value;
1471         signerAddress = _signerAddress;
1472         InvestmentPolicyChanged(requireCustomerId, requiredSignedAddress, signerAddress);
1473     }
1474 
1475     /**
1476      * Allow addresses to do early participation.
1477      *
1478      * TODO: Fix spelling error in the name
1479      */
1480     function setEarlyParicipantWhitelist(address addr, bool status, uint minCap, uint maxCap) onlyOwner {
1481         if (!isWhiteListed) throw;
1482         earlyParticipantWhitelist[addr] = WhiteListData({status:status, minCap:minCap, maxCap:maxCap});
1483         Whitelisted(addr, status);
1484     }
1485 
1486     function setEarlyParicipantsWhitelist(address[] addrs, bool[] statuses, uint[] minCaps, uint[] maxCaps) onlyOwner {
1487         if (!isWhiteListed) throw;
1488         for (uint iterator = 0; iterator < addrs.length; iterator++) {
1489             setEarlyParicipantWhitelist(addrs[iterator], statuses[iterator], minCaps[iterator], maxCaps[iterator]);
1490         }
1491     }
1492 
1493     function updateEarlyParicipantWhitelist(address addr, address contractAddr, uint tokensBought) {
1494         if (tokensBought < earlyParticipantWhitelist[addr].minCap) throw;
1495         if (!isWhiteListed) throw;
1496         if (addr != msg.sender && contractAddr != msg.sender) throw;
1497         uint newMaxCap = earlyParticipantWhitelist[addr].maxCap;
1498         newMaxCap = newMaxCap.minus(tokensBought);
1499         earlyParticipantWhitelist[addr] = WhiteListData({status:earlyParticipantWhitelist[addr].status, minCap:0, maxCap:newMaxCap});
1500     }
1501 
1502     function updateJoinedCrowdsales(address addr) onlyOwner {
1503         joinedCrowdsales[joinedCrowdsalesLen++] = addr;
1504     }
1505 
1506     function setLastCrowdsale(address addr) onlyOwner {
1507         lastCrowdsale = addr;
1508     }
1509 
1510     function clearJoinedCrowdsales() onlyOwner {
1511         joinedCrowdsalesLen = 0;
1512     }
1513 
1514     function updateJoinedCrowdsalesMultiple(address[] addrs) onlyOwner {
1515         clearJoinedCrowdsales();
1516         for (uint iter = 0; iter < addrs.length; iter++) {
1517             if(joinedCrowdsalesLen == joinedCrowdsales.length) {
1518                 joinedCrowdsales.length += 1;
1519             }
1520             joinedCrowdsales[joinedCrowdsalesLen++] = addrs[iter];
1521             if (iter == addrs.length - 1)
1522                 setLastCrowdsale(addrs[iter]);
1523         }
1524     }
1525 
1526     function setStartsAt(uint time) onlyOwner {
1527         if (finalized) throw;
1528 
1529         if (!isUpdatable) throw;
1530 
1531         if(now > time) {
1532             throw; // Don't change past
1533         }
1534 
1535         if(time > endsAt) {
1536             throw;
1537         }
1538 
1539         CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
1540         if (lastCrowdsaleCntrct.finalized()) throw;
1541 
1542         startsAt = time;
1543         StartsAtChanged(startsAt);
1544     }
1545 
1546     /**
1547      * Allow crowdsale owner to close early or extend the crowdsale.
1548      *
1549      * This is useful e.g. for a manual soft cap implementation:
1550      * - after X amount is reached determine manual closing
1551      *
1552      * This may put the crowdsale to an invalid state,
1553      * but we trust owners know what they are doing.
1554      *
1555      */
1556     function setEndsAt(uint time) onlyOwner {
1557         if (finalized) throw;
1558 
1559         if (!isUpdatable) throw;
1560 
1561         if(now > time) {
1562             throw; // Don't change past
1563         }
1564 
1565         if(startsAt > time) {
1566             throw;
1567         }
1568 
1569         CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
1570         if (lastCrowdsaleCntrct.finalized()) throw;
1571 
1572         uint num = 0;
1573         for (var i = 0; i < joinedCrowdsalesLen; i++) {
1574             if (this == joinedCrowdsales[i])
1575                 num = i;
1576         }
1577 
1578         if (num + 1 < joinedCrowdsalesLen) {
1579             for (var j = num + 1; j < joinedCrowdsalesLen; j++) {
1580                 CrowdsaleExt crowdsale = CrowdsaleExt(joinedCrowdsales[j]);
1581                 if (time > crowdsale.startsAt()) throw;
1582             }
1583         }
1584 
1585         endsAt = time;
1586         EndsAtChanged(endsAt);
1587     }
1588 
1589     /**
1590      * Allow to (re)set pricing strategy.
1591      *
1592      * Design choice: no state restrictions on the set, so that we can fix fat finger mistakes.
1593      */
1594     function setPricingStrategy(MilestonePricing _pricingStrategy) onlyOwner {
1595         pricingStrategy = _pricingStrategy;
1596 
1597         // Don't allow setting bad agent
1598         if(!pricingStrategy.isPricingStrategy()) {
1599             throw;
1600         }
1601     }
1602 
1603     /**
1604      * Allow to change the team multisig address in the case of emergency.
1605      *
1606      * This allows to save a deployed crowdsale wallet in the case the crowdsale has not yet begun
1607      * (we have done only few test transactions). After the crowdsale is going
1608      * then multisig address stays locked for the safety reasons.
1609      */
1610     function setMultisig(address addr) public onlyOwner {
1611 
1612         // Change
1613         if(investorCount > MAX_INVESTMENTS_BEFORE_MULTISIG_CHANGE) {
1614             throw;
1615         }
1616 
1617         multisigWallet = addr;
1618     }
1619 
1620     /**
1621      * Allow load refunds back on the contract for the refunding.
1622      *
1623      * The team can transfer the funds back on the smart contract in the case the minimum goal was not reached..
1624      */
1625     function loadRefund() public payable inState(State.Failure) {
1626         if(msg.value == 0) throw;
1627         loadedRefund = loadedRefund.plus(msg.value);
1628     }
1629 
1630     /**
1631      * Investors can claim refund.
1632      *
1633      * Note that any refunds from proxy buyers should be handled separately,
1634      * and not through this contract.
1635      */
1636     function refund() public inState(State.Refunding) {
1637         uint256 weiValue = investedAmountOf[msg.sender];
1638         if (weiValue == 0) throw;
1639         investedAmountOf[msg.sender] = 0;
1640         weiRefunded = weiRefunded.plus(weiValue);
1641         Refund(msg.sender, weiValue);
1642         if (!msg.sender.send(weiValue)) throw;
1643     }
1644 
1645     /**
1646      * @return true if the crowdsale has raised enough money to be a successful.
1647      */
1648     function isMinimumGoalReached() public constant returns (bool reached) {
1649         return weiRaised >= minimumFundingGoal;
1650     }
1651 
1652     /**
1653      * Check if the contract relationship looks good.
1654      */
1655     function isFinalizerSane() public constant returns (bool sane) {
1656         return finalizeAgent.isSane();
1657     }
1658 
1659     /**
1660      * Check if the contract relationship looks good.
1661      */
1662     function isPricingSane() public constant returns (bool sane) {
1663         return pricingStrategy.isSane(address(this));
1664     }
1665 
1666     /**
1667      * Crowdfund state machine management.
1668      *
1669      * We make it a function and do not assign the result to a variable, so there is no chance of the variable being stale.
1670      */
1671     function getState() public constant returns (State) {
1672         if(finalized) return State.Finalized;
1673         else if (address(finalizeAgent) == 0) return State.Preparing;
1674         else if (!finalizeAgent.isSane()) return State.Preparing;
1675         else if (!pricingStrategy.isSane(address(this))) return State.Preparing;
1676         else if (block.timestamp < startsAt) return State.PreFunding;
1677         else if (block.timestamp <= endsAt && !isCrowdsaleFull()) return State.Funding;
1678         else if (isMinimumGoalReached()) return State.Success;
1679         else if (!isMinimumGoalReached() && weiRaised > 0 && loadedRefund >= weiRaised) return State.Refunding;
1680         else return State.Failure;
1681     }
1682 
1683     /** This is for manual testing of multisig wallet interaction */
1684     function setOwnerTestValue(uint val) onlyOwner {
1685         ownerTestValue = val;
1686     }
1687 
1688     /** Interface marker. */
1689     function isCrowdsale() public constant returns (bool) {
1690         return true;
1691     }
1692 
1693     //
1694     // Modifiers
1695     //
1696 
1697     /** Modified allowing execution only if the crowdsale is currently running.  */
1698     modifier inState(State state) {
1699         if(getState() != state) throw;
1700         _;
1701     }
1702 
1703 
1704     //
1705     // Abstract functions
1706     //
1707 
1708     /**
1709      * Check if the current invested breaks our cap rules.
1710      *
1711      *
1712      * The child contract must define their own cap setting rules.
1713      * We allow a lot of flexibility through different capping strategies (ETH, token count)
1714      * Called from invest().
1715      *
1716      * @param weiAmount The amount of wei the investor tries to invest in the current transaction
1717      * @param tokenAmount The amount of tokens we try to give to the investor in the current transaction
1718      * @param weiRaisedTotal What would be our total raised balance after this transaction
1719      * @param tokensSoldTotal What would be our total sold tokens count after this transaction
1720      *
1721      * @return true if taking this investment would break our cap rules
1722      */
1723     function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken);
1724 
1725     function isBreakingInvestorCap(address receiver, uint tokenAmount) constant returns (bool limitBroken);
1726 
1727     /**
1728      * Check if the current crowdsale is full and we can no longer sell any tokens.
1729      */
1730     function isCrowdsaleFull() public constant returns (bool);
1731 
1732     /**
1733      * Create new tokens or transfer issued tokens to the investor depending on the cap model.
1734      */
1735     function assignTokens(address receiver, uint tokenAmount) private;
1736 }
1737 
1738 
1739 /**
1740  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
1741  *
1742  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
1743  */
1744 
1745 
1746 contract MintedTokenCappedCrowdsaleExt is CrowdsaleExt {
1747 
1748     /* Maximum amount of tokens this crowdsale can sell. */
1749     uint public maximumSellableTokens;
1750 
1751     function MintedTokenCappedCrowdsaleExt(address _token, MilestonePricing _pricingStrategy, address _multisigWallet, uint _start, uint _end, uint _minimumFundingGoal, uint _maximumSellableTokens, bool _isUpdatable, bool _isWhiteListed) CrowdsaleExt(_token, _pricingStrategy, _multisigWallet, _start, _end, _minimumFundingGoal, _isUpdatable, _isWhiteListed) {
1752         maximumSellableTokens = _maximumSellableTokens;
1753     }
1754 
1755     // Crowdsale maximumSellableTokens has been changed
1756     event MaximumSellableTokensChanged(uint newMaximumSellableTokens);
1757 
1758     /**
1759      * Called from invest() to confirm if the curret investment does not break our cap rule.
1760      */
1761     function isBreakingCap(uint weiAmount, uint tokenAmount, uint weiRaisedTotal, uint tokensSoldTotal) constant returns (bool limitBroken) {
1762         return tokensSoldTotal > maximumSellableTokens;
1763     }
1764 
1765     function isBreakingInvestorCap(address addr, uint tokenAmount) constant returns (bool limitBroken) {
1766         if (!isWhiteListed) throw;
1767         uint maxCap = earlyParticipantWhitelist[addr].maxCap;
1768         return (tokenAmountOf[addr].plus(tokenAmount)) > maxCap;
1769     }
1770 
1771     function isCrowdsaleFull() public constant returns (bool) {
1772         return tokensSold >= maximumSellableTokens;
1773     }
1774 
1775     /**
1776      * Dynamically create tokens and assign them to the investor.
1777      */
1778     function assignTokens(address receiver, uint tokenAmount) private {
1779         CrowdsaleTokenExt mintableToken = CrowdsaleTokenExt(token);
1780         mintableToken.mint(receiver, tokenAmount);
1781     }
1782 
1783     function setMaximumSellableTokens(uint tokens) onlyOwner {
1784         if (finalized) throw;
1785 
1786         if (!isUpdatable) throw;
1787 
1788         CrowdsaleExt lastCrowdsaleCntrct = CrowdsaleExt(lastCrowdsale);
1789         if (lastCrowdsaleCntrct.finalized()) throw;
1790 
1791         maximumSellableTokens = tokens;
1792         MaximumSellableTokensChanged(maximumSellableTokens);
1793     }
1794 }
1795 
1796 /**
1797  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
1798  *
1799  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
1800  */
1801 
1802 
1803 
1804 /**
1805  * Safe unsigned safe math.
1806  *
1807  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
1808  *
1809  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
1810  *
1811  * Maintained here until merged to mainline zeppelin-solidity.
1812  *
1813  */
1814 library SMathLib {
1815 
1816     function times(uint a, uint b) returns (uint) {
1817         uint c = a * b;
1818         assert(a == 0 || c / a == b);
1819         return c;
1820     }
1821 
1822     function divides(uint a, uint b) returns (uint) {
1823         assert(b > 0);
1824         uint c = a / b;
1825         assert(a == b * c + a % b);
1826         return c;
1827     }
1828 
1829     function minus(uint a, uint b) returns (uint) {
1830         assert(b <= a);
1831         return a - b;
1832     }
1833 
1834     function plus(uint a, uint b) returns (uint) {
1835         uint c = a + b;
1836         assert(c>=a);
1837         return c;
1838     }
1839 
1840 }
1841 
1842 
1843 
1844 /**
1845  * Collect funds from presale investors, buy tokens for them in a single transaction and distribute out tokens.
1846  *
1847  * - Collect funds from pre-sale investors
1848  * - Send funds to the crowdsale when it opens
1849  * - Allow owner to set the crowdsale
1850  * - Have refund after X days as a safety hatch if the crowdsale doesn't materilize
1851  * - Allow unlimited investors
1852  * - Tokens are distributed on PreICOProxyBuyer smart contract first
1853  * - The original investors can claim their tokens from the smart contract after the token transfer has been released
1854  * - All functions can be halted by owner if something goes wrong
1855  *
1856  */
1857 contract PreICOProxyBuyer is Ownable, Haltable {
1858     using SMathLib for uint;
1859 
1860     /** How many investors we have now */
1861     uint public investorCount;
1862 
1863     /** How many wei we have raised totla. */
1864     uint public weiRaised;
1865 
1866     /** Who are our investors (iterable) */
1867     address[] public investors;
1868 
1869     /** How much they have invested */
1870     mapping(address => uint) public balances;
1871 
1872     /** How many tokens investors have claimed */
1873     mapping(address => uint) public claimed;
1874 
1875     /** When our refund freeze is over (UNIT timestamp) */
1876     uint public freezeEndsAt;
1877 
1878     /** What is the minimum buy in */
1879     uint public weiMinimumLimit;
1880 
1881     /** What is the maximum buy in */
1882     uint public weiMaximumLimit;
1883 
1884     /** How many weis total we are allowed to collect. */
1885     uint public weiCap;
1886 
1887     /** How many tokens were bought */
1888     uint public tokensBought;
1889 
1890     /** How many investors have claimed their tokens */
1891     uint public claimCount;
1892 
1893     uint public totalClaimed;
1894 
1895     /** If timeLock > 0, claiming is possible only after the time has passed **/
1896     uint public timeLock;
1897 
1898     /** This is used to signal that we want the refund **/
1899     bool public forcedRefund;
1900 
1901     /** Our ICO contract where we will move the funds */
1902     CrowdsaleExt public crowdsale;
1903 
1904     /** What is our current state. */
1905     enum State{Unknown, Funding, Distributing, Refunding}
1906 
1907     /** Somebody loaded their investment money */
1908     event Invested(address investor, uint weiAmount, uint tokenAmount, uint128 customerId);
1909 
1910     /** Refund claimed */
1911     event Refunded(address investor, uint value);
1912 
1913     /** We executed our buy */
1914     event TokensBoughts(uint count);
1915 
1916     /** We distributed tokens to an investor */
1917     event Distributed(address investor, uint count);
1918 
1919     /**
1920      * Create presale contract where lock up period is given days
1921      */
1922     function PreICOProxyBuyer(address _owner, uint _freezeEndsAt, uint _weiMinimumLimit, uint _weiMaximumLimit, uint _weiCap) {
1923 
1924         owner = _owner;
1925 
1926         // Give argument
1927         if(_freezeEndsAt == 0) {
1928             throw;
1929         }
1930 
1931         // Give argument
1932         if(_weiMinimumLimit == 0) {
1933             throw;
1934         }
1935 
1936         if(_weiMaximumLimit == 0) {
1937             throw;
1938         }
1939 
1940         weiMinimumLimit = _weiMinimumLimit;
1941         weiMaximumLimit = _weiMaximumLimit;
1942         weiCap = _weiCap;
1943         freezeEndsAt = _freezeEndsAt;
1944     }
1945 
1946     /**
1947      * Get the token we are distributing.
1948      */
1949     function getToken() public constant returns(FractionalERC20Ext) {
1950         if(address(crowdsale) == 0)  {
1951             throw;
1952         }
1953 
1954         return crowdsale.token();
1955     }
1956 
1957     /**
1958      * Participate to a presale.
1959      */
1960     function invest(uint128 customerId) private {
1961 
1962         // Cannot invest anymore through crowdsale when moving has begun
1963         if(getState() != State.Funding) throw;
1964 
1965         if(msg.value == 0) throw; // No empty buys
1966 
1967         address investor = msg.sender;
1968 
1969         bool existing = balances[investor] > 0;
1970 
1971         balances[investor] = balances[investor].plus(msg.value);
1972 
1973         // Need to satisfy minimum and maximum limits
1974         if(balances[investor] < weiMinimumLimit || balances[investor] > weiMaximumLimit) {
1975             throw;
1976         }
1977 
1978         // This is a new investor
1979         if(!existing) {
1980             investors.push(investor);
1981             investorCount++;
1982         }
1983 
1984         weiRaised = weiRaised.plus(msg.value);
1985         if(weiRaised > weiCap) {
1986             throw;
1987         }
1988 
1989         // We will use the same event form the Crowdsale for compatibility reasons
1990         // despite not having a token amount.
1991         Invested(investor, msg.value, 0, customerId);
1992     }
1993 
1994     function buyWithCustomerId(uint128 customerId) public stopInEmergency payable {
1995         invest(customerId);
1996     }
1997 
1998     function buy() public stopInEmergency payable {
1999         invest(0x0);
2000     }
2001 
2002 
2003     /**
2004      * Load funds to the crowdsale for all investors.
2005      *
2006      *
2007      */
2008     function buyForEverybody() stopNonOwnersInEmergency public {
2009 
2010         if(getState() != State.Funding) {
2011             // Only allow buy once
2012             throw;
2013         }
2014 
2015         // Crowdsale not yet set
2016         if(address(crowdsale) == 0) throw;
2017 
2018         // Buy tokens on the contract
2019         crowdsale.invest.value(weiRaised)(address(this));
2020 
2021         // Record how many tokens we got
2022         tokensBought = getToken().balanceOf(address(this));
2023 
2024         if(tokensBought == 0) {
2025             // Did not get any tokens
2026             throw;
2027         }
2028 
2029         TokensBoughts(tokensBought);
2030     }
2031 
2032     /**
2033      * How may tokens each investor gets.
2034      */
2035     function getClaimAmount(address investor) public constant returns (uint) {
2036 
2037         // Claims can be only made if we manage to buy tokens
2038         if(getState() != State.Distributing) {
2039             throw;
2040         }
2041         return balances[investor].times(tokensBought) / weiRaised;
2042     }
2043 
2044     /**
2045      * How many tokens remain unclaimed for an investor.
2046      */
2047     function getClaimLeft(address investor) public constant returns (uint) {
2048         return getClaimAmount(investor).minus(claimed[investor]);
2049     }
2050 
2051     /**
2052      * Claim all remaining tokens for this investor.
2053      */
2054     function claimAll() {
2055         claim(getClaimLeft(msg.sender));
2056     }
2057 
2058     /**
2059      * Claim N bought tokens to the investor as the msg sender.
2060      *
2061      */
2062     function claim(uint amount) stopInEmergency {
2063         require (now > timeLock);
2064 
2065         address investor = msg.sender;
2066 
2067         if(amount == 0) {
2068             throw;
2069         }
2070 
2071         if(getClaimLeft(investor) < amount) {
2072             // Woops we cannot get more than we have left
2073             throw;
2074         }
2075 
2076         // We track who many investor have (partially) claimed their tokens
2077         if(claimed[investor] == 0) {
2078             claimCount++;
2079         }
2080 
2081         claimed[investor] = claimed[investor].plus(amount);
2082         totalClaimed = totalClaimed.plus(amount);
2083         getToken().transfer(investor, amount);
2084 
2085         Distributed(investor, amount);
2086     }
2087 
2088     /**
2089      * ICO never happened. Allow refund.
2090      */
2091     function refund() stopInEmergency {
2092 
2093         // Trying to ask refund too soon
2094         if(getState() != State.Refunding) throw;
2095 
2096         address investor = msg.sender;
2097         if(balances[investor] == 0) throw;
2098         uint amount = balances[investor];
2099         delete balances[investor];
2100         if(!(investor.call.value(amount)())) throw;
2101         Refunded(investor, amount);
2102     }
2103 
2104     /**
2105      * Set the target crowdsale where we will move presale funds when the crowdsale opens.
2106      */
2107     function setCrowdsale(CrowdsaleExt _crowdsale) public onlyOwner {
2108         crowdsale = _crowdsale;
2109 
2110         // Check interface
2111         if(!crowdsale.isCrowdsale()) true;
2112     }
2113 
2114     /// @dev Setting timelock (delay) for claiming
2115     /// @param _timeLock Time after which claiming is possible
2116     function setTimeLock(uint _timeLock) public onlyOwner {
2117         timeLock = _timeLock;
2118     }
2119 
2120     /// @dev This is used in the first case scenario, this will force the state
2121     ///      to refunding. This can be also used when the ICO fails to meet the cap.
2122     function forceRefund() public onlyOwner {
2123         forcedRefund = true;
2124     }
2125 
2126     /// @dev This should be used if the Crowdsale fails, to receive the refuld money.
2127     ///      we can't use Crowdsale's refund, since our default function does not
2128     ///      accept money in.
2129     function loadRefund() public payable {
2130         if(getState() != State.Refunding) throw;
2131     }
2132 
2133     /**
2134      * Resolve the contract umambigious state.
2135      */
2136     function getState() public view returns(State) {
2137         if (forcedRefund)
2138             return State.Refunding;
2139 
2140         if(tokensBought == 0) {
2141             if(now >= freezeEndsAt) {
2142                 return State.Refunding;
2143             } else {
2144                 return State.Funding;
2145             }
2146         } else {
2147             return State.Distributing;
2148         }
2149     }
2150 
2151     /** Interface marker. */
2152     function isPresale() public constant returns (bool) {
2153         return true;
2154     }
2155 
2156     /** Explicitly call function from your wallet. */
2157     function() payable {
2158         throw;
2159     }
2160 }