1 pragma solidity ^0.4.11;
2 /*
3 TRIXCHAIN Powered by POA NETWORK
4 
5 TRIXCHAIN is the first Indonesia Crypto Marketplace , Indonesia with more than 240 Millions Populations and more than 5% Economic Growth every years is a big opportunity for Cryptocurrency.
6 
7 TRIXCHAIN will be the first and the biggest Crypto Marketplace in Indonesia.
8 
9 Name ---------- : TRIXCHAIN 
10 Symbol -------- : TRIX
11 Total Supply - : 100.000.000.000 TRIX
12 Decimals ------ : 18 
13 Contract ------- : 0xda23c8a2f194505fa44f2310d305ba91e0ddcf78
14 CREATOR ------ : 0x64db52750f06456a5315Af1d04D0D3efCB48FF23
15 
16 TOKEN DETAILS
17 
18 Total Supply ---------------- : 100.000.000.000 TRIX
19 Future Development ---- :   35.000.000.000 TRIX
20 Investor ---------------------- :   40.000.000.000 TRIX
21 Foundation ----------------- :     7.000.000.000 TRIX 
22 Team & Advisor ----------- :   15.000.000.000 TRIX 
23 Giveaway -------------------- :     3.000.000.000 TRIX
24 
25 If you’re interest to be an Investor on TRIXCHAIN project , You can Buy TRIXCHAIN Token
26 
27 Send ETH to TRIX CREATOR Address "0x64db52750f06456a5315Af1d04D0D3efCB48FF23”
28 
29 You’ll get 40.000.000 TRIX for 1 ETH , minimum contribution 0.01 ETH
30 TRIX will list on exchange after we get fund from investor, our first target TRIX will list on Hotbit , Cryptopia , Mercatox , idex , and Indodax.
31 
32 We also giveaway TRIX to random address to build a strong Community 
33 
34 Official Group --- : https://t.me/trixchain
35 Channel ----------- : https://t.me/trixofficialchannel
36 
37 Official website , Official twitter  will launch on December 2018 
38 
39 */
40 
41 contract ERC20Basic {
42   uint256 public totalSupply;
43   function balanceOf(address who) public constant returns (uint256);
44   function transfer(address to, uint256 value) public returns (bool);
45   event Transfer(address indexed from, address indexed to, uint256 value);
46 }
47 
48 
49 
50 /**
51  * @title Ownable
52  * @dev The Ownable contract has an owner address, and provides basic authorization control
53  * functions, this simplifies the implementation of "user permissions".
54  */
55 contract Ownable {
56   address public owner;
57 
58 
59   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61 
62   /**
63    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
64    * account.
65    */
66   function Ownable() {
67     owner = msg.sender;
68   }
69 
70 
71   /**
72    * @dev Throws if called by any account other than the owner.
73    */
74   modifier onlyOwner() {
75     require(msg.sender == owner);
76     _;
77   }
78 
79 
80   /**
81    * @dev Allows the current owner to transfer control of the contract to a newOwner.
82    * @param newOwner The address to transfer ownership to.
83    */
84   function transferOwnership(address newOwner) onlyOwner public {
85     require(newOwner != address(0));
86     OwnershipTransferred(owner, newOwner);
87     owner = newOwner;
88   }
89 
90 }
91 
92 
93 
94 /**
95  * Math operations with safety checks
96  */
97 contract SafeMath {
98   function safeMul(uint a, uint b) internal returns (uint) {
99     uint c = a * b;
100     assert(a == 0 || c / a == b);
101     return c;
102   }
103 
104   function safeDiv(uint a, uint b) internal returns (uint) {
105     assert(b > 0);
106     uint c = a / b;
107     assert(a == b * c + a % b);
108     return c;
109   }
110 
111   function safeSub(uint a, uint b) internal returns (uint) {
112     assert(b <= a);
113     return a - b;
114   }
115 
116   function safeAdd(uint a, uint b) internal returns (uint) {
117     uint c = a + b;
118     assert(c>=a && c>=b);
119     return c;
120   }
121 
122   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
123     return a >= b ? a : b;
124   }
125 
126   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
127     return a < b ? a : b;
128   }
129 
130   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
131     return a >= b ? a : b;
132   }
133 
134   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
135     return a < b ? a : b;
136   }
137 
138 }
139 
140 contract ERC20 is ERC20Basic {
141   function allowance(address owner, address spender) public constant returns (uint256);
142   function transferFrom(address from, address to, uint256 value) public returns (bool);
143   function approve(address spender, uint256 value) public returns (bool);
144   event Approval(address indexed owner, address indexed spender, uint256 value);
145 }
146 
147 contract StandardToken is ERC20, SafeMath {
148 
149   /* Token supply got increased and a new owner received these tokens */
150   event Minted(address receiver, uint amount);
151 
152   /* Actual balances of token holders */
153   mapping(address => uint) balances;
154 
155   /* approve() allowances */
156   mapping (address => mapping (address => uint)) allowed;
157 
158   /* Interface declaration */
159   function isToken() public constant returns (bool weAre) {
160     return true;
161   }
162 
163   function transfer(address _to, uint _value) returns (bool success) {
164     balances[msg.sender] = safeSub(balances[msg.sender], _value);
165     balances[_to] = safeAdd(balances[_to], _value);
166     Transfer(msg.sender, _to, _value);
167     return true;
168   }
169 
170   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
171     uint _allowance = allowed[_from][msg.sender];
172 
173     balances[_to] = safeAdd(balances[_to], _value);
174     balances[_from] = safeSub(balances[_from], _value);
175     allowed[_from][msg.sender] = safeSub(_allowance, _value);
176     Transfer(_from, _to, _value);
177     return true;
178   }
179 
180   function balanceOf(address _owner) constant returns (uint balance) {
181     return balances[_owner];
182   }
183 
184   function approve(address _spender, uint _value) returns (bool success) {
185 
186     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
187 
188     allowed[msg.sender][_spender] = _value;
189     Approval(msg.sender, _spender, _value);
190     return true;
191   }
192 
193   function allowance(address _owner, address _spender) constant returns (uint remaining) {
194     return allowed[_owner][_spender];
195   }
196 
197 }
198 
199 
200 /**
201  * Upgrade agent interface inspired by Lunyr.
202  *
203  * Upgrade agent transfers tokens to a new contract.
204  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
205  */
206 contract UpgradeAgent {
207 
208   uint public originalSupply;
209 
210   /** Interface marker */
211   function isUpgradeAgent() public constant returns (bool) {
212     return true;
213   }
214 
215   function upgradeFrom(address _from, uint256 _value) public;
216 
217 }
218 
219 
220 /**
221  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
222  *
223  * First envisioned by Golem and Lunyr projects.
224  */
225 contract UpgradeableToken is StandardToken {
226 
227   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
228   address public upgradeMaster;
229 
230   /** The next contract where the tokens will be migrated. */
231   UpgradeAgent public upgradeAgent;
232 
233   /** How many tokens we have upgraded by now. */
234   uint256 public totalUpgraded;
235 
236   /**
237    * Upgrade states.
238    *
239    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
240    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
241    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
242    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
243    *
244    */
245   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
246 
247   /**
248    * Somebody has upgraded some of his tokens.
249    */
250   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
251 
252   /**
253    * New upgrade agent available.
254    */
255   event UpgradeAgentSet(address agent);
256 
257   /**
258    * Do not allow construction without upgrade master set.
259    */
260   function UpgradeableToken(address _upgradeMaster) {
261     upgradeMaster = _upgradeMaster;
262   }
263 
264   /**
265    * Allow the token holder to upgrade some of their tokens to a new contract.
266    */
267   function upgrade(uint256 value) public {
268 
269       UpgradeState state = getUpgradeState();
270       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
271         // Called in a bad state
272         throw;
273       }
274 
275       // Validate input value.
276       if (value == 0) throw;
277 
278       balances[msg.sender] = safeSub(balances[msg.sender], value);
279 
280       // Take tokens out from circulation
281       totalSupply = safeSub(totalSupply, value);
282       totalUpgraded = safeAdd(totalUpgraded, value);
283 
284       // Upgrade agent reissues the tokens
285       upgradeAgent.upgradeFrom(msg.sender, value);
286       Upgrade(msg.sender, upgradeAgent, value);
287   }
288 
289   /**
290    * Set an upgrade agent that handles
291    */
292   function setUpgradeAgent(address agent) external {
293 
294       if(!canUpgrade()) {
295         // The token is not yet in a state that we could think upgrading
296         throw;
297       }
298 
299       if (agent == 0x0) throw;
300       // Only a master can designate the next agent
301       if (msg.sender != upgradeMaster) throw;
302       // Upgrade has already begun for an agent
303       if (getUpgradeState() == UpgradeState.Upgrading) throw;
304 
305       upgradeAgent = UpgradeAgent(agent);
306 
307       // Bad interface
308       if(!upgradeAgent.isUpgradeAgent()) throw;
309       // Make sure that token supplies match in source and target
310       if (upgradeAgent.originalSupply() != totalSupply) throw;
311 
312       UpgradeAgentSet(upgradeAgent);
313   }
314 
315   /**
316    * Get the state of the token upgrade.
317    */
318   function getUpgradeState() public constant returns(UpgradeState) {
319     if(!canUpgrade()) return UpgradeState.NotAllowed;
320     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
321     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
322     else return UpgradeState.Upgrading;
323   }
324 
325   /**
326    * Change the upgrade master.
327    *
328    * This allows us to set a new owner for the upgrade mechanism.
329    */
330   function setUpgradeMaster(address master) public {
331       if (master == 0x0) throw;
332       if (msg.sender != upgradeMaster) throw;
333       upgradeMaster = master;
334   }
335 
336   /**
337    * Child contract can enable to provide the condition when the upgrade can begun.
338    */
339   function canUpgrade() public constant returns(bool) {
340      return true;
341   }
342 
343 }
344 
345 /**
346  * Define interface for releasing the token transfer after a successful crowdsale.
347  */
348 contract ReleasableToken is ERC20, Ownable {
349 
350   /* The finalizer contract that allows unlift the transfer limits on this token */
351   address public releaseAgent;
352 
353   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
354   bool public released = false;
355 
356   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
357   mapping (address => bool) public transferAgents;
358 
359   /**
360    * Limit token transfer until the crowdsale is over.
361    *
362    */
363   modifier canTransfer(address _sender) {
364 
365     if(!released) {
366         if(!transferAgents[_sender]) {
367             throw;
368         }
369     }
370 
371     _;
372   }
373 
374   /**
375    * Set the contract that can call release and make the token transferable.
376    *
377    * Design choice. Allow reset the release agent to fix fat finger mistakes.
378    */
379   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
380 
381     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
382     releaseAgent = addr;
383   }
384 
385   /**
386    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
387    */
388   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
389     transferAgents[addr] = state;
390   }
391 
392   /**
393    * One way function to release the tokens to the wild.
394    *
395    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
396    */
397   function releaseTokenTransfer() public onlyReleaseAgent {
398     released = true;
399   }
400 
401   /** The function can be called only before or after the tokens have been releasesd */
402   modifier inReleaseState(bool releaseState) {
403     if(releaseState != released) {
404         throw;
405     }
406     _;
407   }
408 
409   /** The function can be called only by a whitelisted release agent. */
410   modifier onlyReleaseAgent() {
411     if(msg.sender != releaseAgent) {
412         throw;
413     }
414     _;
415   }
416 
417   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
418     // Call StandardToken.transfer()
419    return super.transfer(_to, _value);
420   }
421 
422   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
423     // Call StandardToken.transferForm()
424     return super.transferFrom(_from, _to, _value);
425   }
426 
427 }
428 
429 library SafeMathLibExt {
430 
431   function times(uint a, uint b) returns (uint) {
432     uint c = a * b;
433     assert(a == 0 || c / a == b);
434     return c;
435   }
436 
437   function divides(uint a, uint b) returns (uint) {
438     assert(b > 0);
439     uint c = a / b;
440     assert(a == b * c + a % b);
441     return c;
442   }
443 
444   function minus(uint a, uint b) returns (uint) {
445     assert(b <= a);
446     return a - b;
447   }
448 
449   function plus(uint a, uint b) returns (uint) {
450     uint c = a + b;
451     assert(c>=a);
452     return c;
453   }
454 
455 }
456 
457 
458 
459 
460 /**
461  * A token that can increase its supply by another contract.
462  *
463  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
464  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
465  *
466  */
467 contract MintableTokenExt is StandardToken, Ownable {
468 
469   using SafeMathLibExt for uint;
470 
471   bool public mintingFinished = false;
472 
473   /** List of agents that are allowed to create new tokens */
474   mapping (address => bool) public mintAgents;
475 
476   event MintingAgentChanged(address addr, bool state  );
477 
478   /** inPercentageUnit is percents of tokens multiplied to 10 up to percents decimals.
479   * For example, for reserved tokens in percents 2.54%
480   * inPercentageUnit = 254
481   * inPercentageDecimals = 2
482   */
483   struct ReservedTokensData {
484     uint inTokens;
485     uint inPercentageUnit;
486     uint inPercentageDecimals;
487     bool isReserved;
488     bool isDistributed;
489   }
490 
491   mapping (address => ReservedTokensData) public reservedTokensList;
492   address[] public reservedTokensDestinations;
493   uint public reservedTokensDestinationsLen = 0;
494   bool reservedTokensDestinationsAreSet = false;
495 
496   modifier onlyMintAgent() {
497     // Only crowdsale contracts are allowed to mint new tokens
498     if(!mintAgents[msg.sender]) {
499         throw;
500     }
501     _;
502   }
503 
504   /** Make sure we are not done yet. */
505   modifier canMint() {
506     if(mintingFinished) throw;
507     _;
508   }
509 
510   function finalizeReservedAddress(address addr) public onlyMintAgent canMint {
511     ReservedTokensData storage reservedTokensData = reservedTokensList[addr];
512     reservedTokensData.isDistributed = true;
513   }
514 
515   function isAddressReserved(address addr) public constant returns (bool isReserved) {
516     return reservedTokensList[addr].isReserved;
517   }
518 
519   function areTokensDistributedForAddress(address addr) public constant returns (bool isDistributed) {
520     return reservedTokensList[addr].isDistributed;
521   }
522 
523   function getReservedTokens(address addr) public constant returns (uint inTokens) {
524     return reservedTokensList[addr].inTokens;
525   }
526 
527   function getReservedPercentageUnit(address addr) public constant returns (uint inPercentageUnit) {
528     return reservedTokensList[addr].inPercentageUnit;
529   }
530 
531   function getReservedPercentageDecimals(address addr) public constant returns (uint inPercentageDecimals) {
532     return reservedTokensList[addr].inPercentageDecimals;
533   }
534 
535   function setReservedTokensListMultiple(
536     address[] addrs, 
537     uint[] inTokens, 
538     uint[] inPercentageUnit, 
539     uint[] inPercentageDecimals
540   ) public canMint onlyOwner {
541     assert(!reservedTokensDestinationsAreSet);
542     assert(addrs.length == inTokens.length);
543     assert(inTokens.length == inPercentageUnit.length);
544     assert(inPercentageUnit.length == inPercentageDecimals.length);
545     for (uint iterator = 0; iterator < addrs.length; iterator++) {
546       if (addrs[iterator] != address(0)) {
547         setReservedTokensList(addrs[iterator], inTokens[iterator], inPercentageUnit[iterator], inPercentageDecimals[iterator]);
548       }
549     }
550     reservedTokensDestinationsAreSet = true;
551   }
552 
553   /**
554    * Create new tokens and allocate them to an address..
555    *
556    * Only callably by a crowdsale contract (mint agent).
557    */
558   function mint(address receiver, uint amount) onlyMintAgent canMint public {
559     totalSupply = totalSupply.plus(amount);
560     balances[receiver] = balances[receiver].plus(amount);
561 
562     // This will make the mint transaction apper in EtherScan.io
563     // We can remove this after there is a standardized minting event
564     Transfer(0, receiver, amount);
565   }
566 
567   /**
568    * Owner can allow a crowdsale contract to mint new tokens.
569    */
570   function setMintAgent(address addr, bool state) onlyOwner canMint public {
571     mintAgents[addr] = state;
572     MintingAgentChanged(addr, state);
573   }
574 
575   function setReservedTokensList(address addr, uint inTokens, uint inPercentageUnit, uint inPercentageDecimals) private canMint onlyOwner {
576     assert(addr != address(0));
577     if (!isAddressReserved(addr)) {
578       reservedTokensDestinations.push(addr);
579       reservedTokensDestinationsLen++;
580     }
581 
582     reservedTokensList[addr] = ReservedTokensData({
583       inTokens: inTokens, 
584       inPercentageUnit: inPercentageUnit, 
585       inPercentageDecimals: inPercentageDecimals,
586       isReserved: true,
587       isDistributed: false
588     });
589   }
590 }
591 
592 
593 /**
594  * A crowdsaled token.
595  *
596  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
597  *
598  * - The token transfer() is disabled until the crowdsale is over
599  * - The token contract gives an opt-in upgrade path to a new contract
600  * - The same token can be part of several crowdsales through approve() mechanism
601  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
602  *
603  */
604 contract CrowdsaleTokenExt is ReleasableToken, MintableTokenExt, UpgradeableToken {
605 
606   /** Name and symbol were updated. */
607   event UpdatedTokenInformation(string newName, string newSymbol);
608 
609   event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
610 
611   string public name;
612 
613   string public symbol;
614 
615   uint public decimals;
616 
617   /* Minimum ammount of tokens every buyer can buy. */
618   uint public minCap;
619 
620   /**
621    * Construct the token.
622    *
623    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
624    *
625    * @param _name Token name
626    * @param _symbol Token symbol - should be all caps
627    * @param _initialSupply How many tokens we start with
628    * @param _decimals Number of decimal places
629    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
630    */
631   function CrowdsaleTokenExt(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable, uint _globalMinCap)
632     UpgradeableToken(msg.sender) {
633 
634     // Create any address, can be transferred
635     // to team multisig via changeOwner(),
636     // also remember to call setUpgradeMaster()
637     owner = msg.sender;
638 
639     name = _name;
640     symbol = _symbol;
641 
642     totalSupply = _initialSupply;
643 
644     decimals = _decimals;
645 
646     minCap = _globalMinCap;
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
695   /**
696    * Claim tokens that were accidentally sent to this contract.
697    *
698    * @param _token The address of the token contract that you want to recover.
699    */
700   function claimTokens(address _token) public onlyOwner {
701     require(_token != address(0));
702 
703     ERC20 token = ERC20(_token);
704     uint balance = token.balanceOf(this);
705     token.transfer(owner, balance);
706 
707     ClaimedTokens(_token, owner, balance);
708   }
709 
710 }