1 // Created using ICO Wizard https://github.com/oraclesorg/ico-wizard by Oracles Network
2 pragma solidity ^0.4.11;
3 
4 
5 // Created using ICO Wizard https://github.com/oraclesorg/ico-wizard by Oracles Network
6 /**
7  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
8  *
9  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
10  */
11 
12 /**
13  * Safe unsigned safe math.
14  *
15  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
16  *
17  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
18  *
19  * Maintained here until merged to mainline zeppelin-solidity.
20  *
21  */
22 library SMathLib {
23 
24     function times(uint a, uint b) returns (uint) {
25         uint c = a * b;
26         assert(a == 0 || c / a == b);
27         return c;
28     }
29 
30     function divides(uint a, uint b) returns (uint) {
31         assert(b > 0);
32         uint c = a / b;
33         assert(a == b * c + a % b);
34         return c;
35     }
36 
37     function minus(uint a, uint b) returns (uint) {
38         assert(b <= a);
39         return a - b;
40     }
41 
42     function plus(uint a, uint b) returns (uint) {
43         uint c = a + b;
44         assert(c>=a);
45         return c;
46     }
47 
48 }
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56     address public owner;
57 
58 
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61 
62     /**
63      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64      * account.
65      */
66     function Ownable() {
67         owner = msg.sender;
68     }
69 
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(msg.sender == owner);
76         _;
77     }
78 
79 
80     /**
81      * @dev Allows the current owner to transfer control of the contract to a newOwner.
82      * @param newOwner The address to transfer ownership to.
83      */
84     function transferOwnership(address newOwner) onlyOwner public {
85         require(newOwner != address(0));
86         OwnershipTransferred(owner, newOwner);
87         owner = newOwner;
88     }
89 
90 }
91 // Temporarily have SafeMath here until all contracts have been migrated to SafeMathLib version from OpenZeppelin
92 
93 /**
94  * Math operations with safety checks
95  */
96 contract SafeMath {
97     function safeMul(uint a, uint b) internal returns (uint) {
98         uint c = a * b;
99         assert(a == 0 || c / a == b);
100         return c;
101     }
102 
103     function safeDiv(uint a, uint b) internal returns (uint) {
104         assert(b > 0);
105         uint c = a / b;
106         assert(a == b * c + a % b);
107         return c;
108     }
109 
110     function safeSub(uint a, uint b) internal returns (uint) {
111         assert(b <= a);
112         return a - b;
113     }
114 
115     function safeAdd(uint a, uint b) internal returns (uint) {
116         uint c = a + b;
117         assert(c>=a && c>=b);
118         return c;
119     }
120 
121     function max64(uint64 a, uint64 b) internal constant returns (uint64) {
122         return a >= b ? a : b;
123     }
124 
125     function min64(uint64 a, uint64 b) internal constant returns (uint64) {
126         return a < b ? a : b;
127     }
128 
129     function max256(uint256 a, uint256 b) internal constant returns (uint256) {
130         return a >= b ? a : b;
131     }
132 
133     function min256(uint256 a, uint256 b) internal constant returns (uint256) {
134         return a < b ? a : b;
135     }
136 
137 }
138 /**
139  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
140  *
141  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
142  */
143 
144 
145 
146 /**
147  * @title ERC20Basic
148  * @dev Simpler version of ERC20 interface
149  * @dev see https://github.com/ethereum/EIPs/issues/179
150  */
151 contract ERC20Basic {
152     uint256 public totalSupply;
153     function balanceOf(address who) public constant returns (uint256);
154     function transfer(address to, uint256 value) public returns (bool);
155     event Transfer(address indexed from, address indexed to, uint256 value);
156 }
157 
158 
159 
160 /**
161  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
162  *
163  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
164  */
165 
166 
167 
168 /**
169  * @title ERC20 interface
170  * @dev see https://github.com/ethereum/EIPs/issues/20
171  */
172 contract ERC20 is ERC20Basic {
173     function allowance(address owner, address spender) public constant returns (uint256);
174     function transferFrom(address from, address to, uint256 value) public returns (bool);
175     function approve(address spender, uint256 value) public returns (bool);
176     event Approval(address indexed owner, address indexed spender, uint256 value);
177 }
178 
179 
180 
181 
182 /**
183  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
184  *
185  * Based on code by FirstBlood:
186  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
187  */
188 contract StandardToken is ERC20, SafeMath {
189 
190     /* Token supply got increased and a new owner received these tokens */
191     event Minted(address receiver, uint amount);
192 
193     /* Actual balances of token holders */
194     mapping(address => uint) balances;
195 
196     /* approve() allowances */
197     mapping (address => mapping (address => uint)) allowed;
198 
199     /* Interface declaration */
200     function isToken() public constant returns (bool weAre) {
201         return true;
202     }
203 
204     function transfer(address _to, uint _value) returns (bool success) {
205         balances[msg.sender] = safeSub(balances[msg.sender], _value);
206         balances[_to] = safeAdd(balances[_to], _value);
207         Transfer(msg.sender, _to, _value);
208         return true;
209     }
210 
211     function transferFrom(address _from, address _to, uint _value) returns (bool success) {
212         uint _allowance = allowed[_from][msg.sender];
213 
214         balances[_to] = safeAdd(balances[_to], _value);
215         balances[_from] = safeSub(balances[_from], _value);
216         allowed[_from][msg.sender] = safeSub(_allowance, _value);
217         Transfer(_from, _to, _value);
218         return true;
219     }
220 
221     function balanceOf(address _owner) constant returns (uint balance) {
222         return balances[_owner];
223     }
224 
225     function approve(address _spender, uint _value) returns (bool success) {
226 
227         // To change the approve amount you first have to reduce the addresses`
228         //  allowance to zero by calling `approve(_spender, 0)` if it is not
229         //  already 0 to mitigate the race condition described here:
230         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231         require ((_value != 0) && (allowed[msg.sender][_spender] != 0));
232 
233         allowed[msg.sender][_spender] = _value;
234         Approval(msg.sender, _spender, _value);
235         return true;
236     }
237 
238     function allowance(address _owner, address _spender) constant returns (uint remaining) {
239         return allowed[_owner][_spender];
240     }
241 
242 }
243 
244 /**
245  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
246  *
247  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
248  */
249 
250 
251 
252 
253 
254 /**
255  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
256  *
257  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
258  */
259 
260 
261 
262 /**
263  * Upgrade agent interface inspired by Lunyr.
264  *
265  * Upgrade agent transfers tokens to a new contract.
266  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
267  */
268 contract UpgradeAgent {
269 
270     uint public originalSupply;
271 
272     /** Interface marker */
273     function isUpgradeAgent() public constant returns (bool) {
274         return true;
275     }
276 
277     function upgradeFrom(address _from, uint256 _value) public;
278 
279 }
280 
281 
282 /**
283  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
284  *
285  * First envisioned by Golem and Lunyr projects.
286  */
287 contract UpgradeableToken is StandardToken {
288 
289     /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
290     address public upgradeMaster;
291 
292     /** The next contract where the tokens will be migrated. */
293     UpgradeAgent public upgradeAgent;
294 
295     /** How many tokens we have upgraded by now. */
296     uint256 public totalUpgraded;
297 
298     /**
299      * Upgrade states.
300      *
301      * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
302      * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
303      * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
304      * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
305      *
306      */
307     enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
308 
309     /**
310      * Somebody has upgraded some of his tokens.
311      */
312     event Upgrade(address indexed _from, address indexed _to, uint256 _value);
313 
314     /**
315      * New upgrade agent available.
316      */
317     event UpgradeAgentSet(address agent);
318 
319     /**
320      * Do not allow construction without upgrade master set.
321      */
322     function UpgradeableToken(address _upgradeMaster) {
323         upgradeMaster = _upgradeMaster;
324     }
325 
326     /**
327      * Allow the token holder to upgrade some of their tokens to a new contract.
328      */
329     function upgrade(uint256 value) public {
330 
331         UpgradeState state = getUpgradeState();
332         require(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading));
333 
334         // Validate input value.
335         require (value == 0);
336 
337         balances[msg.sender] = safeSub(balances[msg.sender], value);
338 
339         // Take tokens out from circulation
340         totalSupply = safeSub(totalSupply, value);
341         totalUpgraded = safeAdd(totalUpgraded, value);
342 
343         // Upgrade agent reissues the tokens
344         upgradeAgent.upgradeFrom(msg.sender, value);
345         Upgrade(msg.sender, upgradeAgent, value);
346     }
347 
348     /**
349      * Set an upgrade agent that handles
350      */
351     function setUpgradeAgent(address agent) external {
352 
353         require(!canUpgrade()); // The token is not yet in a state that we could think upgrading;
354 
355         require(agent == 0x0);
356         // Only a master can designate the next agent
357         require(msg.sender != upgradeMaster);
358         // Upgrade has already begun for an agent
359         require(getUpgradeState() == UpgradeState.Upgrading);
360 
361         upgradeAgent = UpgradeAgent(agent);
362 
363         // Bad interface
364         require(!upgradeAgent.isUpgradeAgent());
365         // Make sure that token supplies match in source and target
366         require(upgradeAgent.originalSupply() != totalSupply);
367 
368         UpgradeAgentSet(upgradeAgent);
369     }
370 
371     /**
372      * Get the state of the token upgrade.
373      */
374     function getUpgradeState() public constant returns(UpgradeState) {
375         if(!canUpgrade()) return UpgradeState.NotAllowed;
376         else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
377         else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
378         else return UpgradeState.Upgrading;
379     }
380 
381     /**
382      * Change the upgrade master.
383      *
384      * This allows us to set a new owner for the upgrade mechanism.
385      */
386     function setUpgradeMaster(address master) public {
387         require(master == 0x0);
388         require(msg.sender != upgradeMaster);
389         upgradeMaster = master;
390     }
391 
392     /**
393      * Child contract can enable to provide the condition when the upgrade can begun.
394      */
395     function canUpgrade() public constant returns(bool) {
396         return true;
397     }
398 
399 }
400 
401 /**
402  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
403  *
404  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
405  */
406 
407 
408 
409 
410 /**
411  * A token that can increase its supply by another contract.
412  *
413  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
414  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
415  *
416  */
417 contract MintableTokenExt is StandardToken, Ownable {
418 
419     using SMathLib for uint;
420 
421     bool public mintingFinished = false;
422 
423     /** List of agents that are allowed to create new tokens */
424     mapping (address => bool) public mintAgents;
425 
426     event MintingAgentChanged(address addr, bool state  );
427 
428     /** inPercentageUnit is percents of tokens multiplied to 10 up to percents decimals.
429     * For example, for reserved tokens in percents 2.54%
430     * inPercentageUnit = 254
431     * inPercentageDecimals = 2
432     */
433     struct ReservedTokensData {
434         uint inTokens;
435         uint inPercentageUnit;
436         uint inPercentageDecimals;
437     }
438 
439     mapping (address => ReservedTokensData) public reservedTokensList;
440     address[] public reservedTokensDestinations;
441     uint public reservedTokensDestinationsLen = 0;
442 
443     function setReservedTokensList(address addr, uint inTokens, uint inPercentageUnit, uint inPercentageDecimals) onlyOwner {
444         reservedTokensDestinations.push(addr);
445         reservedTokensDestinationsLen++;
446         reservedTokensList[addr] = ReservedTokensData({inTokens:inTokens, inPercentageUnit:inPercentageUnit, inPercentageDecimals: inPercentageDecimals});
447     }
448 
449     function getReservedTokensListValInTokens(address addr) constant returns (uint inTokens) {
450         return reservedTokensList[addr].inTokens;
451     }
452 
453     function getReservedTokensListValInPercentageUnit(address addr) constant returns (uint inPercentageUnit) {
454         return reservedTokensList[addr].inPercentageUnit;
455     }
456 
457     function getReservedTokensListValInPercentageDecimals(address addr) constant returns (uint inPercentageDecimals) {
458         return reservedTokensList[addr].inPercentageDecimals;
459     }
460 
461     function setReservedTokensListMultiple(address[] addrs, uint[] inTokens, uint[] inPercentageUnit, uint[] inPercentageDecimals) onlyOwner {
462         for (uint iterator = 0; iterator < addrs.length; iterator++) {
463             setReservedTokensList(addrs[iterator], inTokens[iterator], inPercentageUnit[iterator], inPercentageDecimals[iterator]);
464         }
465     }
466 
467     /**
468      * Create new tokens and allocate them to an address..
469      *
470      * Only callably by a crowdsale contract (mint agent).
471      */
472     function mint(address receiver, uint amount) onlyMintAgent canMint public {
473         totalSupply = totalSupply.plus(amount);
474         balances[receiver] = balances[receiver].plus(amount);
475 
476         // This will make the mint transaction apper in EtherScan.io
477         // We can remove this after there is a standardized minting event
478         Transfer(0, receiver, amount);
479     }
480 
481     /**
482      * Owner can allow a crowdsale contract to mint new tokens.
483      */
484     function setMintAgent(address addr, bool state) onlyOwner canMint public {
485         mintAgents[addr] = state;
486         MintingAgentChanged(addr, state);
487     }
488 
489     modifier onlyMintAgent() {
490         // Only crowdsale contracts are allowed to mint new tokens
491         if(!mintAgents[msg.sender]) {
492             revert();
493         }
494         _;
495     }
496 
497     /** Make sure we are not done yet. */
498     modifier canMint() {
499         if(mintingFinished) {
500             revert();
501         }
502         _;
503     }
504 }
505 /**
506  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
507  *
508  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
509  */
510 
511 
512 
513 /**
514  * Define interface for releasing the token transfer after a successful crowdsale.
515  */
516 contract ReleasableToken is ERC20, Ownable {
517 
518     /* The finalizer contract that allows unlift the transfer limits on this token */
519     address public releaseAgent;
520 
521     /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
522     bool public released = false;
523 
524     /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
525     mapping (address => bool) public transferAgents;
526 
527     /**
528      * Limit token transfer until the crowdsale is over.
529      *
530      */
531     modifier canTransfer(address _sender) {
532 
533         if(!released) {
534             if(!transferAgents[_sender]) {
535                 revert();
536             }
537         }
538 
539         _;
540     }
541 
542     /**
543      * Set the contract that can call release and make the token transferable.
544      *
545      * Design choice. Allow reset the release agent to fix fat finger mistakes.
546      */
547     function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
548 
549         // We don't do interface check here as we might want to a normal wallet address to act as a release agent
550         releaseAgent = addr;
551     }
552 
553     /**
554      * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
555      */
556     function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
557         transferAgents[addr] = state;
558     }
559 
560     /**
561      * One way function to release the tokens to the wild.
562      *
563      * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
564      */
565     function releaseTokenTransfer() public onlyReleaseAgent {
566         released = true;
567     }
568 
569     /** The function can be called only before or after the tokens have been releasesd */
570     modifier inReleaseState(bool releaseState) {
571         if(releaseState != released) {
572             revert();
573         }
574         _;
575     }
576 
577     /** The function can be called only by a whitelisted release agent. */
578     modifier onlyReleaseAgent() {
579         if(msg.sender != releaseAgent) {
580             revert();
581         }
582         _;
583     }
584 
585     function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
586         // Call StandardToken.transfer()
587         return super.transfer(_to, _value);
588     }
589 
590     function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
591         // Call StandardToken.transferForm()
592         return super.transferFrom(_from, _to, _value);
593     }
594 
595 }
596 
597 /**
598  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
599  *
600  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
601  */
602 
603 
604 
605 
606 
607 
608 contract BurnableToken is StandardToken {
609 
610     using SMathLib for uint;
611     event Burn(address indexed burner, uint256 value);
612 
613     /**
614      * @dev Burns a specific amount of tokens.
615      * @param _value The amount of token to be burned.
616      */
617     function burn(uint256 _value) public {
618         require(_value <= balances[msg.sender]);
619         // no need to require value <= totalSupply, since that would imply the
620         // sender's balance is greater than the totalSupply, which *should* be an assertion failure
621 
622         address burner = msg.sender;
623         balances[burner] = balances[burner].minus(_value);
624         totalSupply = totalSupply.minus(_value);
625         Burn(burner, _value);
626     }
627 }
628 
629 
630 
631 
632 /**
633  * A crowdsaled token.
634  *
635  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
636  *
637  * - The token transfer() is disabled until the crowdsale is over
638  * - The token contract gives an opt-in upgrade path to a new contract
639  * - The same token can be part of several crowdsales through approve() mechanism
640  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
641  *
642  */
643 contract CrowdsaleTokenExt is ReleasableToken, MintableTokenExt, BurnableToken, UpgradeableToken {
644 
645     /** Name and symbol were updated. */
646     event UpdatedTokenInformation(string newName, string newSymbol);
647 
648     string public name;
649 
650     string public symbol;
651 
652     uint public decimals;
653 
654     /* Minimum ammount of tokens every buyer can buy. */
655     uint public minCap;
656 
657 
658     /**
659      * Construct the token.
660      *
661      * This token must be created through a team multisig wallet, so that it is owned by that wallet.
662      *
663      * @param _name Token name
664      * @param _symbol Token symbol - should be all caps
665      * @param _initialSupply How many tokens we start with
666      * @param _decimals Number of decimal places
667      * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
668      */
669     function CrowdsaleTokenExt(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable, uint _globalMinCap)
670     UpgradeableToken(msg.sender) {
671 
672         // Create any address, can be transferred
673         // to team multisig via changeOwner(),
674         // also remember to call setUpgradeMaster()
675         owner = msg.sender;
676 
677         name = _name;
678         symbol = _symbol;
679 
680         totalSupply = _initialSupply;
681 
682         decimals = _decimals;
683 
684         minCap = _globalMinCap;
685 
686         // Create initially all balance on the team multisig
687         balances[owner] = totalSupply;
688 
689         if(totalSupply > 0) {
690             Minted(owner, totalSupply);
691         }
692 
693         // No more new supply allowed after the token creation
694         if(!_mintable) {
695             mintingFinished = true;
696             if(totalSupply == 0) {
697                 revert(); // Cannot create a token without supply and no minting
698             }
699         }
700     }
701 
702     /**
703      * When token is released to be transferable, enforce no new tokens can be created.
704      */
705     function releaseTokenTransfer() public onlyReleaseAgent {
706         super.releaseTokenTransfer();
707     }
708 
709     /**
710      * Allow upgrade agent functionality kick in only if the crowdsale was success.
711      */
712     function canUpgrade() public constant returns(bool) {
713         return released && super.canUpgrade();
714     }
715 
716     /**
717      * Owner can update token information here.
718      *
719      * It is often useful to conceal the actual token association, until
720      * the token operations, like central issuance or reissuance have been completed.
721      *
722      * This function allows the token owner to rename the token after the operations
723      * have been completed and then point the audience to use the token contract.
724      */
725     function setTokenInformation(string _name, string _symbol) onlyOwner {
726         name = _name;
727         symbol = _symbol;
728 
729         UpdatedTokenInformation(name, symbol);
730     }
731 
732 }
733 
734 
735 contract MjtToken is CrowdsaleTokenExt {
736 
737     uint public ownersProductCommissionInPerc = 5;
738 
739     uint public operatorProductCommissionInPerc = 25;
740 
741     event IndependentSellerJoined(address sellerWallet, uint amountOfTokens, address operatorWallet);
742     event OwnersProductAdded(address ownersWallet, uint amountOfTokens, address operatorWallet);
743     event OperatorProductCommissionChanged(uint _value);
744     event OwnersProductCommissionChanged(uint _value);
745 
746 
747     function setOperatorCommission(uint _value) public onlyOwner {
748         require(_value >= 0);
749         operatorProductCommissionInPerc = _value;
750         OperatorProductCommissionChanged(_value);
751     }
752 
753     function setOwnersCommission(uint _value) public onlyOwner {
754         require(_value >= 0);
755         ownersProductCommissionInPerc = _value;
756         OwnersProductCommissionChanged(_value);
757     }
758 
759 
760     /**
761      * Method called when new seller joined the program
762      * To avoid value lost after division, amountOfTokens must be multiple of 100
763      */
764     function independentSellerJoined(address sellerWallet, uint amountOfTokens, address operatorWallet) public onlyOwner canMint {
765         require(amountOfTokens > 100);
766         require(sellerWallet != address(0));
767         require(operatorWallet != address(0));
768 
769         uint operatorCommission = amountOfTokens.divides(100).times(operatorProductCommissionInPerc);
770         uint sellerAmount = amountOfTokens.minus(operatorCommission);
771 
772         if (operatorCommission > 0) {
773             mint(operatorWallet, operatorCommission);
774         }
775 
776         if (sellerAmount > 0) {
777             mint(sellerWallet, sellerAmount);
778         }
779         IndependentSellerJoined(sellerWallet, amountOfTokens, operatorWallet);
780     }
781 
782 
783     /**
784     * Method called when owners add their own product
785     * To avoid value lost after division, amountOfTokens must be multiple of 100
786     */
787     function ownersProductAdded(address ownersWallet, uint amountOfTokens, address operatorWallet) public onlyOwner canMint {
788         require(amountOfTokens > 100);
789         require(ownersWallet != address(0));
790         require(operatorWallet != address(0));
791 
792         uint ownersComission = amountOfTokens.divides(100).times(ownersProductCommissionInPerc);
793         uint operatorAmount = amountOfTokens.minus(ownersComission);
794 
795 
796         if (ownersComission > 0) {
797             mint(ownersWallet, ownersComission);
798         }
799 
800         if (operatorAmount > 0) {
801             mint(operatorWallet, operatorAmount);
802         }
803 
804         OwnersProductAdded(ownersWallet, amountOfTokens, operatorWallet);
805     }
806 
807     function MjtToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable, uint _globalMinCap)
808     CrowdsaleTokenExt(_name, _symbol, _initialSupply, _decimals, _mintable, _globalMinCap) {}
809 
810 }