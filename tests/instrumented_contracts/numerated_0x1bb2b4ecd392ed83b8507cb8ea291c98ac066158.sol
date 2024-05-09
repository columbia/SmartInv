1 // ---Trixchain Powered by POA Network---
2 pragma solidity ^0.4.11;
3 /*
4 Name         : Trixchain
5 Symbol       : TRIX
6 Total Supply : 1.000.000.000.000 TRIX
7 Decimals     : 18 
8 Contract     : 0x1bb2b4ecd392ed83b8507cb8ea291c98ac066158
9 
10 Chat Group   : https://t.me/joinchat/Jc2Vrkb0C11mxRmFnVploQ
11 Channel      : https://t.me/trixchainchannel
12 
13 TOKENSALE DETAILS
14 
15 Total Supply ---------: 1.000.000.000.000 TRIX
16 Tokensale             : 250.000.000.000 TRIX
17 Future Project -------: 250.000.000.000 TRIX
18 Foundation            : 75.000.000.000 TRIX 
19 Team -----------------: 25.000.000.000 TRIX 
20 Monthly Holder Reward : 400.000.000.000 TRIX 
21 
22 *With Our Mecanism , All TRIX Holder will get monthly reward for more than 20 Years* 
23 After Tokensale Finished TRIX will list on exchange, our first target TRIX will list on Okex , Hotbit , Cryptopia , Mercatox , idex 
24 
25 Official website , Official twitter and official twitter will launch on December 2018 
26 -----------------------------
27 TOKENSALE PHASE 1 
28 TOKENSALE CONTRACT ADDRESS for PHASE 1 
29 "  0x5df18eF4055c807082797b44A09323e31e66AeF6  "
30 
31 DATE : Oct 3,2018  to  Nov 3,2018
32 Rate 1 ETH = 50.000.000 TRIX + Bonus 100%
33 No Minimum Contribution
34 How to Contribute : 
35 Use Myetherwallet :
36 Send ETH to TOKENSALE CONTRACT ADDRESS for PHASE 1 
37 Example : Send 1 ETH to 0x5df18eF4055c807082797b44A09323e31e66AeF6 
38 Gas Price always check on ethgasstation.info
39 Gas Limits : 150.000
40 Data : 0xa6f2ae3a
41 Warning You Should input the Data "0xa6f2ae3a" or you will fail send the transaction 
42 Use Metamask :
43 Open Your Metamask and access the link below :
44 https://wizard.oracles.org/invest?addr=0x5df18eF4055c807082797b44A09323e31e66AeF6&networkID=1
45 
46 ------------------------------
47 
48 TOKENSALE PHASE 2
49 TOKENSALE CONTRACT ADDRESS for PHASE 2 
50 "  0xba2D53ef55876F2247FBAA669c10bf9F2800D61E  "
51 
52 DATE : Nov 4,2018 to Dec 15,2018 
53 Rate 1 ETH = 50.000.000 TRIX + Bonus 50%
54 No Minimum Contribution
55 How to Contribute : 
56 Use Myetherwallet :
57 Send ETH to TOKENSALE CONTRACT ADDRESS for PHASE 2 
58 Example : Send 1 ETH to 0xba2D53ef55876F2247FBAA669c10bf9F2800D61E 
59 Gas Price always check on ethgasstation.info
60 Gas Limits : 150.000
61 Data : 0xa6f2ae3a
62 Warning You Should input the Data "0xa6f2ae3a" or you will fail send the transaction 
63 Use Metamask :
64 Open Your Metamask and access the link below :
65 https://wizard.oracles.org/invest?addr=0xba2D53ef55876F2247FBAA669c10bf9F2800D61E&networkID=1
66 
67 ------------------------------
68 
69 TOKENSALE PHASE 3 
70 TOKENSALE CONTRACT ADDRESS for PHASE 3 
71 "  0x1e1B917E8F1F882f481A1c7CFB0a5b1C75946Cef  "
72 
73 DATE : Dec 16,2018  to  Jan 30,2019
74 Rate 1 ETH = 50.000.000 TRIX (no bonus)
75 No Minimum Contribution
76 How to Contribute : 
77 Use Myetherwallet :
78 Send ETH to TOKENSALE CONTRACT ADDRESS for PHASE 3 
79 Example : Send 1 ETH to 0x1e1B917E8F1F882f481A1c7CFB0a5b1C75946Cef 
80 Gas Price always check on ethgasstation.info
81 Gas Limits : 150.000
82 Data : 0xa6f2ae3a
83 Warning You Should input the Data "0xa6f2ae3a" or you will fail send the transaction 
84 Use Metamask :
85 Open Your Metamask and access the link below :
86 https://wizard.oracles.org/invest?addr=0x1e1B917E8F1F882f481A1c7CFB0a5b1C75946Cef&networkID=1
87 
88 ------------------------------
89 
90 */
91 
92 contract ERC20Basic {
93   uint256 public totalSupply;
94   function balanceOf(address who) public constant returns (uint256);
95   function transfer(address to, uint256 value) public returns (bool);
96   event Transfer(address indexed from, address indexed to, uint256 value);
97 }
98 
99 contract Ownable {
100   address public owner;
101 
102 
103   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
104 
105   function Ownable() {
106     owner = msg.sender;
107   }
108 
109   modifier onlyOwner() {
110     require(msg.sender == owner);
111     _;
112   }
113 
114   function transferOwnership(address newOwner) onlyOwner public {
115     require(newOwner != address(0));
116     OwnershipTransferred(owner, newOwner);
117     owner = newOwner;
118   }
119 
120 }
121 
122 /**
123  * Math operations with safety checks
124  */
125 contract SafeMath {
126   function safeMul(uint a, uint b) internal returns (uint) {
127     uint c = a * b;
128     assert(a == 0 || c / a == b);
129     return c;
130   }
131 
132   function safeDiv(uint a, uint b) internal returns (uint) {
133     assert(b > 0);
134     uint c = a / b;
135     assert(a == b * c + a % b);
136     return c;
137   }
138 
139   function safeSub(uint a, uint b) internal returns (uint) {
140     assert(b <= a);
141     return a - b;
142   }
143 
144   function safeAdd(uint a, uint b) internal returns (uint) {
145     uint c = a + b;
146     assert(c>=a && c>=b);
147     return c;
148   }
149 
150   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
151     return a >= b ? a : b;
152   }
153 
154   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
155     return a < b ? a : b;
156   }
157 
158   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
159     return a >= b ? a : b;
160   }
161 
162   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
163     return a < b ? a : b;
164   }
165 
166 }
167 
168 
169 contract ERC20 is ERC20Basic {
170   function allowance(address owner, address spender) public constant returns (uint256);
171   function transferFrom(address from, address to, uint256 value) public returns (bool);
172   function approve(address spender, uint256 value) public returns (bool);
173   event Approval(address indexed owner, address indexed spender, uint256 value);
174 }
175 
176 
177 contract StandardToken is ERC20, SafeMath {
178 
179   /* Token supply got increased and a new owner received these tokens */
180   event Minted(address receiver, uint amount);
181 
182   /* Actual balances of token holders */
183   mapping(address => uint) balances;
184 
185   /* approve() allowances */
186   mapping (address => mapping (address => uint)) allowed;
187 
188   /* Interface declaration */
189   function isToken() public constant returns (bool weAre) {
190     return true;
191   }
192 
193   function transfer(address _to, uint _value) returns (bool success) {
194     balances[msg.sender] = safeSub(balances[msg.sender], _value);
195     balances[_to] = safeAdd(balances[_to], _value);
196     Transfer(msg.sender, _to, _value);
197     return true;
198   }
199 
200   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
201     uint _allowance = allowed[_from][msg.sender];
202 
203     balances[_to] = safeAdd(balances[_to], _value);
204     balances[_from] = safeSub(balances[_from], _value);
205     allowed[_from][msg.sender] = safeSub(_allowance, _value);
206     Transfer(_from, _to, _value);
207     return true;
208   }
209 
210   function balanceOf(address _owner) constant returns (uint balance) {
211     return balances[_owner];
212   }
213 
214   function approve(address _spender, uint _value) returns (bool success) {
215 
216     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
217 
218     allowed[msg.sender][_spender] = _value;
219     Approval(msg.sender, _spender, _value);
220     return true;
221   }
222 
223   function allowance(address _owner, address _spender) constant returns (uint remaining) {
224     return allowed[_owner][_spender];
225   }
226 
227 }
228 
229 
230 contract UpgradeAgent {
231 
232   uint public originalSupply;
233 
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
259   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
260 
261   /**
262    * Somebody has upgraded some of his tokens.
263    */
264   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
265 
266   /**
267    * New upgrade agent available.
268    */
269   event UpgradeAgentSet(address agent);
270 
271   /**
272    * Do not allow construction without upgrade master set.
273    */
274   function UpgradeableToken(address _upgradeMaster) {
275     upgradeMaster = _upgradeMaster;
276   }
277 
278   /**
279    * Allow the token holder to upgrade some of their tokens to a new contract.
280    */
281   function upgrade(uint256 value) public {
282 
283       UpgradeState state = getUpgradeState();
284       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
285         // Called in a bad state
286         throw;
287       }
288 
289       // Validate input value.
290       if (value == 0) throw;
291 
292       balances[msg.sender] = safeSub(balances[msg.sender], value);
293 
294       // Take tokens out from circulation
295       totalSupply = safeSub(totalSupply, value);
296       totalUpgraded = safeAdd(totalUpgraded, value);
297 
298       // Upgrade agent reissues the tokens
299       upgradeAgent.upgradeFrom(msg.sender, value);
300       Upgrade(msg.sender, upgradeAgent, value);
301   }
302 
303   /**
304    * Set an upgrade agent that handles
305    */
306   function setUpgradeAgent(address agent) external {
307 
308       if(!canUpgrade()) {
309         // The token is not yet in a state that we could think upgrading
310         throw;
311       }
312 
313       if (agent == 0x0) throw;
314       // Only a master can designate the next agent
315       if (msg.sender != upgradeMaster) throw;
316       // Upgrade has already begun for an agent
317       if (getUpgradeState() == UpgradeState.Upgrading) throw;
318 
319       upgradeAgent = UpgradeAgent(agent);
320 
321       // Bad interface
322       if(!upgradeAgent.isUpgradeAgent()) throw;
323       // Make sure that token supplies match in source and target
324       if (upgradeAgent.originalSupply() != totalSupply) throw;
325 
326       UpgradeAgentSet(upgradeAgent);
327   }
328 
329   /**
330    * Get the state of the token upgrade.
331    */
332   function getUpgradeState() public constant returns(UpgradeState) {
333     if(!canUpgrade()) return UpgradeState.NotAllowed;
334     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
335     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
336     else return UpgradeState.Upgrading;
337   }
338 
339   /**
340    * Change the upgrade master.
341    *
342    * This allows us to set a new owner for the upgrade mechanism.
343    */
344   function setUpgradeMaster(address master) public {
345       if (master == 0x0) throw;
346       if (msg.sender != upgradeMaster) throw;
347       upgradeMaster = master;
348   }
349 
350   /**
351    * Child contract can enable to provide the condition when the upgrade can begun.
352    */
353   function canUpgrade() public constant returns(bool) {
354      return true;
355   }
356 
357 }
358 
359 
360 /**
361  * Define interface for releasing the token transfer after a successful crowdsale.
362  */
363 contract ReleasableToken is ERC20, Ownable {
364 
365   /* The finalizer contract that allows unlift the transfer limits on this token */
366   address public releaseAgent;
367 
368   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
369   bool public released = false;
370 
371   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
372   mapping (address => bool) public transferAgents;
373 
374   /**
375    * Limit token transfer until the crowdsale is over.
376    *
377    */
378   modifier canTransfer(address _sender) {
379 
380     if(!released) {
381         if(!transferAgents[_sender]) {
382             throw;
383         }
384     }
385 
386     _;
387   }
388 
389   /**
390    * Set the contract that can call release and make the token transferable.
391    *
392    * Design choice. Allow reset the release agent to fix fat finger mistakes.
393    */
394   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
395 
396     releaseAgent = addr;
397   }
398 
399   /**
400    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
401    */
402   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
403     transferAgents[addr] = state;
404   }
405 
406   /**
407    * One way function to release the tokens to the wild.
408    *
409    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
410    */
411   function releaseTokenTransfer() public onlyReleaseAgent {
412     released = true;
413   }
414 
415   /** The function can be called only before or after the tokens have been releasesd */
416   modifier inReleaseState(bool releaseState) {
417     if(releaseState != released) {
418         throw;
419     }
420     _;
421   }
422 
423   /** The function can be called only by a whitelisted release agent. */
424   modifier onlyReleaseAgent() {
425     if(msg.sender != releaseAgent) {
426         throw;
427     }
428     _;
429   }
430 
431   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
432     // Call StandardToken.transfer()
433    return super.transfer(_to, _value);
434   }
435 
436   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
437     // Call StandardToken.transferForm()
438     return super.transferFrom(_from, _to, _value);
439   }
440 
441 }
442 
443 library SafeMathLibExt {
444 
445   function times(uint a, uint b) returns (uint) {
446     uint c = a * b;
447     assert(a == 0 || c / a == b);
448     return c;
449   }
450 
451   function divides(uint a, uint b) returns (uint) {
452     assert(b > 0);
453     uint c = a / b;
454     assert(a == b * c + a % b);
455     return c;
456   }
457 
458   function minus(uint a, uint b) returns (uint) {
459     assert(b <= a);
460     return a - b;
461   }
462 
463   function plus(uint a, uint b) returns (uint) {
464     uint c = a + b;
465     assert(c>=a);
466     return c;
467   }
468 
469 }
470 
471 
472 
473 
474 /**
475  * A token that can increase its supply by another contract.
476  *
477  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
478  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
479  *
480  */
481 contract MintableTokenExt is StandardToken, Ownable {
482 
483   using SafeMathLibExt for uint;
484 
485   bool public mintingFinished = false;
486 
487   /** List of agents that are allowed to create new tokens */
488   mapping (address => bool) public mintAgents;
489 
490   event MintingAgentChanged(address addr, bool state  );
491 
492   /** inPercentageUnit is percents of tokens multiplied to 10 up to percents decimals.
493   * For example, for reserved tokens in percents 2.54%
494   * inPercentageUnit = 254
495   * inPercentageDecimals = 2
496   */
497   struct ReservedTokensData {
498     uint inTokens;
499     uint inPercentageUnit;
500     uint inPercentageDecimals;
501     bool isReserved;
502     bool isDistributed;
503   }
504 
505   mapping (address => ReservedTokensData) public reservedTokensList;
506   address[] public reservedTokensDestinations;
507   uint public reservedTokensDestinationsLen = 0;
508   bool reservedTokensDestinationsAreSet = false;
509 
510   modifier onlyMintAgent() {
511     // Only crowdsale contracts are allowed to mint new tokens
512     if(!mintAgents[msg.sender]) {
513         throw;
514     }
515     _;
516   }
517 
518   /** Make sure we are not done yet. */
519   modifier canMint() {
520     if(mintingFinished) throw;
521     _;
522   }
523 
524   function finalizeReservedAddress(address addr) public onlyMintAgent canMint {
525     ReservedTokensData storage reservedTokensData = reservedTokensList[addr];
526     reservedTokensData.isDistributed = true;
527   }
528 
529   function isAddressReserved(address addr) public constant returns (bool isReserved) {
530     return reservedTokensList[addr].isReserved;
531   }
532 
533   function areTokensDistributedForAddress(address addr) public constant returns (bool isDistributed) {
534     return reservedTokensList[addr].isDistributed;
535   }
536 
537   function getReservedTokens(address addr) public constant returns (uint inTokens) {
538     return reservedTokensList[addr].inTokens;
539   }
540 
541   function getReservedPercentageUnit(address addr) public constant returns (uint inPercentageUnit) {
542     return reservedTokensList[addr].inPercentageUnit;
543   }
544 
545   function getReservedPercentageDecimals(address addr) public constant returns (uint inPercentageDecimals) {
546     return reservedTokensList[addr].inPercentageDecimals;
547   }
548 
549   function setReservedTokensListMultiple(
550     address[] addrs, 
551     uint[] inTokens, 
552     uint[] inPercentageUnit, 
553     uint[] inPercentageDecimals
554   ) public canMint onlyOwner {
555     assert(!reservedTokensDestinationsAreSet);
556     assert(addrs.length == inTokens.length);
557     assert(inTokens.length == inPercentageUnit.length);
558     assert(inPercentageUnit.length == inPercentageDecimals.length);
559     for (uint iterator = 0; iterator < addrs.length; iterator++) {
560       if (addrs[iterator] != address(0)) {
561         setReservedTokensList(addrs[iterator], inTokens[iterator], inPercentageUnit[iterator], inPercentageDecimals[iterator]);
562       }
563     }
564     reservedTokensDestinationsAreSet = true;
565   }
566 
567   /**
568    * Create new tokens and allocate them to an address..
569    *
570    * Only callably by a crowdsale contract (mint agent).
571    */
572   function mint(address receiver, uint amount) onlyMintAgent canMint public {
573     totalSupply = totalSupply.plus(amount);
574     balances[receiver] = balances[receiver].plus(amount);
575 
576     // This will make the mint transaction apper in EtherScan.io
577     // We can remove this after there is a standardized minting event
578     Transfer(0, receiver, amount);
579   }
580 
581   /**
582    * Owner can allow a crowdsale contract to mint new tokens.
583    */
584   function setMintAgent(address addr, bool state) onlyOwner canMint public {
585     mintAgents[addr] = state;
586     MintingAgentChanged(addr, state);
587   }
588 
589   function setReservedTokensList(address addr, uint inTokens, uint inPercentageUnit, uint inPercentageDecimals) private canMint onlyOwner {
590     assert(addr != address(0));
591     if (!isAddressReserved(addr)) {
592       reservedTokensDestinations.push(addr);
593       reservedTokensDestinationsLen++;
594     }
595 
596     reservedTokensList[addr] = ReservedTokensData({
597       inTokens: inTokens, 
598       inPercentageUnit: inPercentageUnit, 
599       inPercentageDecimals: inPercentageDecimals,
600       isReserved: true,
601       isDistributed: false
602     });
603   }
604 }
605 
606 
607 /**
608  * A crowdsaled token.
609  *
610  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
611  *
612  * - The token transfer() is disabled until the crowdsale is over
613  * - The token contract gives an opt-in upgrade path to a new contract
614  * - The same token can be part of several crowdsales through approve() mechanism
615  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
616  *
617  */
618 contract CrowdsaleTokenExt is ReleasableToken, MintableTokenExt, UpgradeableToken {
619 
620   /** Name and symbol were updated. */
621   event UpdatedTokenInformation(string newName, string newSymbol);
622 
623   event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
624 
625   string public name;
626 
627   string public symbol;
628 
629   uint public decimals;
630 
631   /* Minimum ammount of tokens every buyer can buy. */
632   uint public minCap;
633 
634   /**
635    * Construct the token.
636    *
637    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
638    *
639    * @param _name Token name
640    * @param _symbol Token symbol - should be all caps
641    * @param _initialSupply How many tokens we start with
642    * @param _decimals Number of decimal places
643    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
644    */
645   function CrowdsaleTokenExt(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable, uint _globalMinCap)
646     UpgradeableToken(msg.sender) {
647 
648     // Create any address, can be transferred
649     // to team multisig via changeOwner(),
650     // also remember to call setUpgradeMaster()
651     owner = msg.sender;
652 
653     name = _name;
654     symbol = _symbol;
655 
656     totalSupply = _initialSupply;
657 
658     decimals = _decimals;
659 
660     minCap = _globalMinCap;
661 
662     // Create initially all balance on the team multisig
663     balances[owner] = totalSupply;
664 
665     if(totalSupply > 0) {
666       Minted(owner, totalSupply);
667     }
668 
669     // No more new supply allowed after the token creation
670     if(!_mintable) {
671       mintingFinished = true;
672       if(totalSupply == 0) {
673         throw; // Cannot create a token without supply and no minting
674       }
675     }
676   }
677 
678   /**
679    * When token is released to be transferable, enforce no new tokens can be created.
680    */
681   function releaseTokenTransfer() public onlyReleaseAgent {
682     mintingFinished = true;
683     super.releaseTokenTransfer();
684   }
685 
686   /**
687    * Allow upgrade agent functionality kick in only if the crowdsale was success.
688    */
689   function canUpgrade() public constant returns(bool) {
690     return released && super.canUpgrade();
691   }
692 
693   /**
694    * Owner can update token information here.
695    *
696    * It is often useful to conceal the actual token association, until
697    * the token operations, like central issuance or reissuance have been completed.
698    *
699    * This function allows the token owner to rename the token after the operations
700    * have been completed and then point the audience to use the token contract.
701    */
702   function setTokenInformation(string _name, string _symbol) onlyOwner {
703     name = _name;
704     symbol = _symbol;
705 
706     UpdatedTokenInformation(name, symbol);
707   }
708 
709   /**
710    * Claim tokens that were accidentally sent to this contract.
711    *
712    * @param _token The address of the token contract that you want to recover.
713    */
714   function claimTokens(address _token) public onlyOwner {
715     require(_token != address(0));
716 
717     ERC20 token = ERC20(_token);
718     uint balance = token.balanceOf(this);
719     token.transfer(owner, balance);
720 
721     ClaimedTokens(_token, owner, balance);
722   }
723 
724 }