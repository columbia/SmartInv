1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity 0.7.6;
4 
5 
6 // 
7 /**
8  * @title ERC20Basic
9  * @dev Simpler version of ERC20 interface
10  * @dev see https://github.com/ethereum/EIPs/issues/179
11  */
12 abstract contract ERC20Basic {
13     uint256 public totalSupply;
14     function balanceOf(address who) public view virtual returns (uint256);
15     function transfer(address to, uint256 value) public virtual returns (bool);
16     event Transfer(address indexed from, address indexed to, uint256 value);
17 }
18 
19 // 
20 /**
21  * @title ERC20 interface
22  * @dev see https://github.com/ethereum/EIPs/issues/20
23  */
24 abstract contract ERC20 is ERC20Basic {
25     function allowance(address owner, address spender) public view virtual returns (uint256);
26     function transferFrom(address from, address to, uint256 value) public virtual returns (bool);
27     function approve(address spender, uint256 value) public virtual returns (bool);
28     event Approval(address indexed owner, address indexed spender, uint256 value);
29 }
30 
31 // 
32 /**
33  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
34  *
35  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
36  */
37 /**
38  * Safe unsigned safe math.
39  *
40  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
41  *
42  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
43  *
44  * Maintained here until merged to mainline zeppelin-solidity.
45  *
46  */
47 library SafeMathLibExt {
48 
49     function times(uint a, uint b) public pure returns (uint) {
50         uint c = a * b;
51         assert(a == 0 || c / a == b);
52         return c;
53     }
54 
55     function divides(uint a, uint b) public pure returns (uint) {
56         assert(b > 0);
57         uint c = a / b;
58         assert(a == b * c + a % b);
59         return c;
60     }
61 
62     function minus(uint a, uint b) public pure returns (uint) {
63         assert(b <= a);
64         return a - b;
65     }
66 
67     function plus(uint a, uint b) public pure returns (uint) {
68         uint c = a + b;
69         assert(c >= a);
70         return c;
71     }
72 
73 }
74 
75 // 
76 /**
77  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
78  *
79  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
80  */
81 /**
82  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
83  *
84  * Based on code by FirstBlood:
85  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
86  */
87 contract StandardToken is ERC20 {
88 
89     using SafeMathLibExt for uint256;
90 
91     /* Token supply got increased and a new owner received these tokens */
92     event Minted(address receiver, uint256 amount);
93 
94     /* Actual balances of token holders */
95     mapping(address => uint256) public balances;
96 
97     /* approve() allowances */
98     mapping (address => mapping (address => uint256)) public allowed;
99 
100     /* Interface declaration */
101     function isToken() public pure returns (bool weAre) {
102         return true;
103     }
104 
105     function transfer(address _to, uint256 _value) public virtual override returns (bool success) {
106         balances[msg.sender] = balances[msg.sender].minus(_value);
107         balances[_to] = balances[_to].plus(_value);
108         emit Transfer(msg.sender, _to, _value);
109         return true;
110     }
111 
112     function transferFrom(address _from, address _to, uint256 _value) public virtual override returns (bool success) {
113         uint256 _allowance = allowed[_from][msg.sender];
114 
115         balances[_to] = balances[_to].plus(_value);
116         balances[_from] = balances[_from].minus(_value);
117         allowed[_from][msg.sender] = _allowance.minus(_value);
118         emit Transfer(_from, _to, _value);
119         return true;
120     }
121 
122     function balanceOf(address _owner) public view virtual override returns (uint256 balance) {
123         return balances[_owner];
124     }
125 
126     function approve(address _spender, uint256 _value) public  virtual override returns (bool success) {
127 
128         // To change the approve amount you first have to reduce the addresses`
129         //  allowance to zero by calling `approve(_spender, 0)` if it is not
130         //  already 0 to mitigate the race condition described here:
131         //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
132         // if ((_addedValue != 0) && (allowed[msg.sender][_spender] != 0)) revert();
133         if(_value == 0 ) revert("Cannot approve 0 value");
134         if(_spender == address(0)) revert("Cannot approve for Null aDDRESS");
135         if(allowed[msg.sender][_spender] == 0 ) revert("Spender already approved,instead increase/decrease allowance");
136 
137         allowed[msg.sender][_spender] = _value;
138         emit Approval(msg.sender, _spender, _value);
139         return true;
140     }
141 
142     function increaseAllowance(address _spender, uint256 _addedValue) public virtual returns (bool) {
143         if(_addedValue == 0 ) revert("Cannot add 0 allowance value");
144         if(_spender == address(0)) revert("Cannot allow for Null address");
145 
146         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].plus(allowed[msg.sender][_spender]);
147         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender].plus(allowed[msg.sender][_spender]));
148         return true;
149     }
150 
151     function decreaseAllowance(address _spender, uint256 _subtractedValue) public virtual returns (bool) {
152         if(_subtractedValue == 0 ) revert("Cannot add 0 decrease value");
153         if(_spender == address(0)) revert("Cannot allow for Null address");
154         require(_subtractedValue <= allowed[msg.sender][_spender], "Cannot remove more than allowance!");
155         
156         allowed[msg.sender][_spender] = allowed[msg.sender][_spender].minus(allowed[msg.sender][_spender]);
157         emit Approval(msg.sender, _spender, allowed[msg.sender][_spender].minus(allowed[msg.sender][_spender]));
158         return true;
159     }
160 
161     function allowance(address _owner, address _spender) public view virtual override returns (uint256 remaining) {
162         return allowed[_owner][_spender];
163     }
164 
165 }
166 
167 // 
168 /**
169  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
170  *
171  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
172  */
173 /**
174  * Upgrade agent interface inspired by Lunyr.
175  *
176  * Upgrade agent transfers tokens to a new contract.
177  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
178  */
179 abstract contract UpgradeAgent {
180 
181     uint public originalSupply;
182 
183     /** Interface marker */
184     function isUpgradeAgent() public pure returns (bool) {
185         return true;
186     }
187 
188     function upgradeFrom(address _from, uint256 _value) public virtual;
189 
190 }
191 
192 // 
193 /**
194  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
195  *
196  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
197  */
198 /**
199  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
200  *
201  * First envisioned by Golem and Lunyr projects.
202  */
203 contract UpgradeableToken is StandardToken {
204     using SafeMathLibExt for uint;
205 
206     /** Contract / person who can set the upgrade path. 
207         This can be the same as team multisig wallet, as what it is with its default value. */
208     address public upgradeMaster;
209 
210     /** The next contract where the tokens will be migrated. */
211     UpgradeAgent public upgradeAgent;
212 
213     /** How many tokens we have upgraded by now. */
214     uint256 public totalUpgraded;
215     /**
216     * Upgrade states.
217     *
218     * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
219     * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
220     * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
221     * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
222     *
223     */
224     enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
225 
226     /**
227     * Somebody has upgraded some of his tokens.
228     */
229     event Upgrade(address indexed _from, address indexed _to, uint256 _value);
230 
231     /**
232     * New upgrade agent available.
233     */
234     event UpgradeAgentSet(address agent);
235 
236     /**
237     * New upgrade master available.
238     */   
239     event UpgradeMasterSet(address agent);
240 
241 
242     /**
243     * Do not allow construction without upgrade master set.
244     */
245     constructor(address _upgradeMaster) {
246         require(_upgradeMaster != address(0), "Upgrade Master cannot be Null Address");
247         upgradeMaster = _upgradeMaster;
248     }
249 
250     /**
251     * Allow the token holder to upgrade some of their tokens to a new contract.
252     */
253     function upgrade(uint256 value) public {
254 
255         UpgradeState state = getUpgradeState();
256         if (!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
257             // Called in a bad state
258             revert("Called in bad State");
259         }
260 
261         // Validate input value.
262         if (value == 0) revert("Invalid input value");
263 
264         balances[msg.sender] = balances[msg.sender].minus(value);
265 
266         // Take tokens out from circulation
267         totalSupply = totalSupply.minus(value);
268         totalUpgraded = totalUpgraded.plus(value);
269 
270         // Upgrade agent reissues the tokens
271         upgradeAgent.upgradeFrom(msg.sender, value);
272         emit Upgrade(msg.sender, address(upgradeAgent), value);
273     }
274 
275     /**
276     * Child contract can enable to provide the condition when the upgrade can begun.
277     */
278     function canUpgrade() public virtual returns(bool) {
279         return true;
280     }
281 
282     /**
283     * Set an upgrade agent that handles
284     */
285     function setUpgradeAgent(address agent) external {
286         if (!canUpgrade()) {
287             // The token is not yet in a state that we could think upgrading
288             revert("The token is not yet in a state that we could think upgrading");
289         }
290 
291         if (agent == address(0)) revert("Cannot be Zero Address");
292         // Only a master can designate the next agent
293         if (msg.sender != upgradeMaster) revert("Only a master can designate the next agent");
294         // Upgrade has already begun for an agent
295         if (getUpgradeState() == UpgradeState.Upgrading) revert("Upgrade has already begun for an agent");
296 
297         upgradeAgent = UpgradeAgent(agent);
298 
299         // Bad interface
300         if (!upgradeAgent.isUpgradeAgent()) revert("Bad interface");      
301 
302         emit UpgradeAgentSet(agent);
303     }
304 
305     /**
306     * Get the state of the token upgrade.
307     */
308     function getUpgradeState() public returns(UpgradeState) {
309         if (!canUpgrade()) return UpgradeState.NotAllowed;
310         else if (address(upgradeAgent) == address(0)) return UpgradeState.WaitingForAgent;
311         else if (totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
312         else return UpgradeState.Upgrading;
313     }
314 
315     /**
316     * Change the upgrade master.
317     *
318     * This allows us to set a new owner for the upgrade mechanism.
319     */
320     function setUpgradeMaster(address master) public {
321         if (master == address(0)) revert("Cannot set master contract to 0");
322         if (msg.sender != upgradeMaster) revert("Msg Sender not upgrade master");
323         upgradeMaster = master;
324 
325         emit UpgradeMasterSet(master);
326     }
327 }
328 
329 // 
330 /**
331  * @title Ownable
332  * @dev The Ownable contract has an owner address, and provides basic authorization control
333  * functions, this simplifies the implementation of "user permissions".
334  */
335 contract Ownable {
336     address public owner;
337 
338     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
339 
340     /**
341     * @dev The Ownable constructor sets the original `owner` of the contract to the sender
342     * account.
343     */
344     constructor ()  {
345         owner = msg.sender;
346     }
347 
348     /**
349     * @dev Throws if called by any account other than the owner.
350     */
351     modifier onlyOwner() {
352         require(msg.sender == owner);
353         _;
354     }
355 
356     /**
357     * @dev Allows the current owner to transfer control of the contract to a newOwner.
358     * @param newOwner The address to transfer ownership to.
359     */
360     function transferOwnership(address newOwner) public onlyOwner {
361         require(newOwner != address(0));
362         emit OwnershipTransferred(owner, newOwner);
363         owner = newOwner;
364     }
365 }
366 
367 // 
368 /**
369  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
370  *
371  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
372  */
373 /**
374   * Define interface for releasing the token transfer after a successful crowdsale.
375   */
376 contract ReleasableToken is StandardToken, Ownable {
377     
378     event ReleaseAgentSet(address caller, address agent);
379     event TransferAgentSet(address callet, address agent, bool set);
380     
381     /* The finalizer contract that allows unlift the transfer limits on this token */
382     address public releaseAgent;
383 
384     /** A crowdsale contract can release us to the wild if ICO success. 
385         If false we are are in transfer lock up period.*/
386     bool public released = false;
387 
388     /** Map of agents that are allowed to transfer tokens regardless of the lock down period. 
389         These are crowdsale contracts and possible the team multisig itself. */
390     mapping (address => bool) public transferAgents;
391 
392     
393 
394     /**
395     * Limit token transfer until the crowdsale is over.
396     *
397     */
398     modifier canTransfer(address _sender) {
399 
400         if (!released) {
401             if (!transferAgents[_sender]) {
402                 revert("Not A Transfer Agent");
403             }
404         }
405         _;
406     }
407 
408     /**
409     * Set the contract that can call release and make the token transferable.
410     *
411     * Design choice. Allow reset the release agent to fix fat finger mistakes.
412     */
413     function setReleaseAgent(address addr) public onlyOwner inReleaseState(false) {
414         require(addr != address(0), "Release Agent cannot be Null Address");
415         // We don't do interface check here as we might want to a normal wallet address to act as a release agent
416         releaseAgent = addr;
417 
418         emit ReleaseAgentSet(msg.sender, addr);
419     }
420 
421     /**
422     * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
423     */
424     function setTransferAgent(address addr, bool state) public onlyOwner inReleaseState(false) {
425         transferAgents[addr] = state;
426 
427         emit TransferAgentSet(msg.sender, addr, state);
428     }
429 
430     /**
431     * One way function to release the tokens to the wild.
432     *
433     * Can be called only from the release agent that is the final ICO contract. 
434     * It is only called if the crowdsale has been success (first milestone reached).
435     */
436     function releaseTokenTransfer() public virtual onlyReleaseAgent {
437         released = true;
438     }
439 
440     /** The function can be called only before or after the tokens have been releasesd */
441     modifier inReleaseState(bool releaseState) {
442         if (releaseState != released) {
443             revert("Not in released state");
444         }
445         _;
446     }
447 
448     /** The function can be called only by a whitelisted release agent. */
449     modifier onlyReleaseAgent() {
450         if (msg.sender != releaseAgent) {
451             revert("Not release agent");
452         }
453         _;
454     }
455 
456     function transfer(address _to, uint _value) public virtual override canTransfer(msg.sender) returns (bool success) {
457         // Call StandardToken.transfer()
458         return super.transfer(_to, _value);
459     }
460 
461     function transferFrom(address _from, address _to, uint _value) public virtual override canTransfer(_from) returns (bool success) {
462         // Call StandardToken.transferForm()
463         return super.transferFrom(_from, _to, _value);
464     }
465 
466 }
467 
468 // 
469 /**
470  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
471  *
472  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
473  */
474 /**
475  * A token that can increase its supply by another contract.
476  *
477  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
478  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
479  *
480  */
481 contract MintableTokenExt is StandardToken, Ownable {
482 
483     using SafeMathLibExt for uint;
484 
485     bool public mintingFinished = false;
486 
487     /** List of agents that are allowed to create new tokens */
488     mapping (address => bool) public mintAgents;
489 
490     event MintingAgentChanged(address addr, bool state  );
491     event ReversedTokenListMultipleSet(uint length);
492     event FinalizedReversedAddress(address addr);
493 
494     /** inPercentageUnit is percents of tokens multiplied to 10 up to percents decimals.
495     * For example, for reserved tokens in percents 2.54%
496     * inPercentageUnit = 254
497     * inPercentageDecimals = 2
498     */
499     struct ReservedTokensData {
500         uint inTokens;
501         uint inPercentageUnit;
502         uint inPercentageDecimals;
503         bool isReserved;
504         bool isDistributed;
505         bool isVested;
506     }
507 
508     mapping (address => ReservedTokensData) public reservedTokensList;
509     address[] public reservedTokensDestinations;
510     uint public reservedTokensDestinationsLen = 0;
511     bool private reservedTokensDestinationsAreSet = false;
512 
513     modifier onlyMintAgent() {
514         // Only crowdsale contracts are allowed to mint new tokens
515         if (!mintAgents[msg.sender]) {
516             revert("Only crowdsale contracts are allowed to mint new tokens");
517         }
518         _;
519     }
520 
521     /** Make sure we are not done yet. */
522     modifier canMint() {
523         if (mintingFinished) revert();
524         _;
525     }
526 
527     function finalizeReservedAddress(address addr) public onlyMintAgent canMint {
528         ReservedTokensData storage reservedTokensData = reservedTokensList[addr];
529         reservedTokensData.isDistributed = true;
530 
531         emit FinalizedReversedAddress(addr);
532     }
533 
534     function isAddressReserved(address addr)  public  view virtual returns (bool isReserved) {
535         return reservedTokensList[addr].isReserved;
536     }
537 
538     function areTokensDistributedForAddress(address addr) public view returns (bool isDistributed) {
539         return reservedTokensList[addr].isDistributed;
540     }
541 
542     function getReservedTokens(address addr) public view returns (uint inTokens) {
543         return reservedTokensList[addr].inTokens;
544     }
545 
546     function getReservedPercentageUnit(address addr) public view returns (uint inPercentageUnit) {
547         return reservedTokensList[addr].inPercentageUnit;
548     }
549 
550     function getReservedPercentageDecimals(address addr) public view returns (uint inPercentageDecimals) {
551         return reservedTokensList[addr].inPercentageDecimals;
552     }
553 
554     function getReservedIsVested(address addr) public view returns (bool isVested) {
555         return reservedTokensList[addr].isVested;
556     }
557 
558     function setReservedTokensListMultiple(
559         address[] memory addrs, 
560         uint[] memory inTokens, 
561         uint[] memory inPercentageUnit, 
562         uint[] memory inPercentageDecimals,
563         bool[] memory isVested
564         ) public canMint onlyOwner {
565         assert(!reservedTokensDestinationsAreSet);
566         assert(addrs.length == inTokens.length);
567         assert(inTokens.length == inPercentageUnit.length);
568         assert(inPercentageUnit.length == inPercentageDecimals.length);
569         for (uint iterator = 0; iterator < addrs.length; iterator++) {
570             if (addrs[iterator] != address(0)) {
571                 setReservedTokensList(
572                     addrs[iterator],
573                     inTokens[iterator],
574                     inPercentageUnit[iterator],
575                     inPercentageDecimals[iterator],
576                     isVested[iterator]
577                     );
578             }
579         }
580         reservedTokensDestinationsAreSet = true;
581 
582         emit ReversedTokenListMultipleSet(addrs.length);
583     }
584 
585     /**
586     * Create new tokens and allocate them to an address..
587     *
588     * Only callably by a crowdsale contract (mint agent).
589     */
590     function mint(address receiver, uint amount) public onlyMintAgent canMint {
591         require(receiver != address(0), "Receiver cannot be the Null Address");
592         totalSupply = totalSupply.plus(amount);
593         balances[receiver] = balances[receiver].plus(amount);
594 
595         // This will make the mint transaction apper in EtherScan.io
596         // We can remove this after there is a standardized minting event
597         emit Transfer(address(0), receiver, amount);
598     }
599 
600     /**
601     * Owner can allow a crowdsale contract to mint new tokens.
602     */
603     function setMintAgent(address addr, bool state) public onlyOwner canMint {
604         require(addr != address(0), "Mint Agent Cannot be Null Address");
605         mintAgents[addr] = state;
606         emit MintingAgentChanged(addr, state);
607     }
608 
609     function setReservedTokensList(address addr, uint inTokens, uint inPercentageUnit, uint inPercentageDecimals,bool isVested) 
610     private canMint onlyOwner {
611         assert(addr != address(0));
612         if (!isAddressReserved(addr)) {
613             reservedTokensDestinations.push(addr);
614             reservedTokensDestinationsLen.plus(1);
615         }
616 
617         reservedTokensList[addr] = ReservedTokensData({
618             inTokens: inTokens,
619             inPercentageUnit: inPercentageUnit,
620             inPercentageDecimals: inPercentageDecimals,
621             isReserved: true,
622             isDistributed: false,
623             isVested:isVested
624         });
625     }
626 }
627 
628 // 
629 /**
630  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
631  *
632  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
633  */
634 /**
635  * A crowdsaled token.
636  *
637  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
638  *
639  * - The token transfer() is disabled until the crowdsale is over
640  * - The token contract gives an opt-in upgrade path to a new contract
641  * - The same token can be part of several crowdsales through approve() mechanism
642  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
643  *
644  */
645 contract CrowdsaleTokenExt is ReleasableToken, MintableTokenExt, UpgradeableToken {
646     using SafeMathLibExt for uint256;
647 
648     /** Name and symbol were updated. */
649     event UpdatedTokenInformation(string newName, string newSymbol);
650 
651     event ClaimedTokens(address indexed _token, address indexed _controller, uint256 _amount);
652 
653     string public name;
654 
655     string public symbol;
656 
657     uint public decimals;
658 
659     /* Minimum ammount of tokens every buyer can buy. */
660     uint256 public minCap;
661 
662     /**
663     * Construct the token.
664     *
665     * This token must be created through a team multisig wallet, so that it is owned by that wallet.
666     *
667     * @param _name Token name
668     * @param _symbol Token symbol - should be all caps
669     * @param _initialSupply How many tokens we start with
670     * @param _decimals Number of decimal places
671     * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? 
672     * Note that when the token becomes transferable the minting always ends.
673     */
674     constructor(string memory _name, string memory _symbol, uint256 _initialSupply, uint _decimals, bool _mintable, uint256 _globalMinCap) 
675      UpgradeableToken(msg.sender) {
676 
677         // Create any address, can be transferred
678         // to team multisig via changeOwner(),
679         // also remember to call setUpgradeMaster()
680         owner = msg.sender;
681 
682         name = _name;
683         symbol = _symbol;
684 
685         totalSupply = _initialSupply;
686 
687         decimals = _decimals;
688 
689         minCap = _globalMinCap;
690 
691         // Create initially all balance on the team multisig
692         balances[owner] = totalSupply;
693 
694         if (totalSupply > 0) {
695             emit Minted(owner, totalSupply);
696         }
697 
698         // No more new supply allowed after the token creation
699         if (!_mintable) {
700             mintingFinished = true;
701             if (totalSupply == 0) {
702                 revert("annot create a token without supply and no minting"); // Cannot create a token without supply and no minting
703             }
704         }
705     }
706 
707     /**
708     * When token is released to be transferable, enforce no new tokens can be created.
709     */
710     function releaseTokenTransfer() public virtual override onlyReleaseAgent {
711         mintingFinished = true;
712         super.releaseTokenTransfer();
713     }
714 
715     /**
716     * Allow upgrade agent functionality kick in only if the crowdsale was success.
717     */
718     function canUpgrade() public virtual override returns(bool) {
719         return released && super.canUpgrade();
720     }
721 
722     /**
723     * Owner can update token information here.
724     *
725     * It is often useful to conceal the actual token association, until
726     * the token operations, like central issuance or reissuance have been completed.
727     *
728     * This function allows the token owner to rename the token after the operations
729     * have been completed and then point the audience to use the token contract.
730     */
731     function setTokenInformation(string memory _name, string memory _symbol) external onlyOwner {
732         name = _name;
733         symbol = _symbol;
734 
735         emit UpdatedTokenInformation(name, symbol);
736     }
737 
738     /**
739     * Claim tokens that were accidentally sent to this contract.
740     *
741     * @param _token The address of the token contract that you want to recover.
742     */
743     function claimTokens(address _token) external onlyOwner {
744         require(_token != address(0));
745 
746         ERC20 token = ERC20(_token);
747         uint256 balance = token.balanceOf(address(this));
748         token.transfer(owner, balance);
749 
750         emit ClaimedTokens(_token, owner, balance);
751     }
752 
753     function transferFrom(address _from, address _to, uint256 _value) public virtual override(StandardToken,ReleasableToken) returns (bool success) {
754         uint256 _allowance = allowed[_from][msg.sender];
755 
756         balances[_to] = balances[_to].plus(_value);
757         balances[_from] = balances[_from].minus(_value);
758         allowed[_from][msg.sender] = _allowance.minus(_value);
759         emit Transfer(_from, _to, _value);
760         return true;
761     }
762 
763     function transfer(address _to, uint256 _value) public virtual override(StandardToken,ReleasableToken) canTransfer(msg.sender) returns (bool success) {
764         // Call StandardToken.transfer()
765         return super.transfer(_to, _value);
766     }
767 
768 }
769 
770 // 
771 /**
772  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
773  *
774  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
775  */
776 /**
777  * A crowdsaled token.
778  *
779  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
780  *
781  * - The token transfer() is disabled until the crowdsale is over
782  * - The token contract gives an opt-in upgrade path to a new contract
783  * - The same token can be part of several crowdsales through approve() mechanism
784  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
785  *
786  */
787 contract CrowdsaleTokenExtv1 is CrowdsaleTokenExt {
788     using SafeMathLibExt for uint256;
789 
790     uint256 public originalSupply;
791 
792     address public oldTokenAddress;
793 
794     bool public isUpgradeAgent = false;
795     /**
796     * Construct the token.
797     *
798     * This token must be created through a team multisig wallet, so that it is owned by that wallet.
799     *
800     * @param _name Token name
801     * @param _symbol Token symbol - should be all caps
802     * @param _initialSupply How many tokens we start with
803     * @param _decimals Number of decimal places
804     * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? 
805     * Note that when the token becomes transferable the minting always ends.
806     */
807     constructor(string memory _name, string memory _symbol, uint256 _initialSupply, uint256 _decimals, bool _mintable, 
808     uint256 _globalMinCap, address _oldTokenAddress, uint256 _originalSupply) 
809      CrowdsaleTokenExt(_name, _symbol, _initialSupply, _decimals, _mintable, _globalMinCap) {    
810         originalSupply = _originalSupply;
811         oldTokenAddress = _oldTokenAddress;
812         isUpgradeAgent = true;    
813     }
814 
815     function upgradeFrom(address _from, uint256 value) public {
816         // Make sure the call is from old token contract
817         require(msg.sender == oldTokenAddress);
818         // Validate input value.
819         balances[_from] = balances[_from].plus(value);
820         // Take tokens out from circulation
821         totalSupply = totalSupply.plus(value);
822     }
823 
824 }