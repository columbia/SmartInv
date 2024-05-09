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
109 
110 
111 /**
112  * @title ERC20 interface
113  * @dev see https://github.com/ethereum/EIPs/issues/20
114  */
115 contract ERC20 is ERC20Basic {
116   function allowance(address owner, address spender) public constant returns (uint256);
117   function transferFrom(address from, address to, uint256 value) public returns (bool);
118   function approve(address spender, uint256 value) public returns (bool);
119   event Approval(address indexed owner, address indexed spender, uint256 value);
120 }
121 
122 
123 
124 
125 /**
126  * Standard ERC20 token with Short Hand Attack and approve() race condition mitigation.
127  *
128  * Based on code by FirstBlood:
129  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
130  */
131 contract StandardToken is ERC20, SafeMath {
132 
133   /* Token supply got increased and a new owner received these tokens */
134   event Minted(address receiver, uint amount);
135 
136   /* Actual balances of token holders */
137   mapping(address => uint) balances;
138 
139   /* approve() allowances */
140   mapping (address => mapping (address => uint)) allowed;
141 
142   /* Interface declaration */
143   function isToken() public constant returns (bool weAre) {
144     return true;
145   }
146 
147   function transfer(address _to, uint _value) returns (bool success) {
148     balances[msg.sender] = safeSub(balances[msg.sender], _value);
149     balances[_to] = safeAdd(balances[_to], _value);
150     Transfer(msg.sender, _to, _value);
151     return true;
152   }
153 
154   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
155     uint _allowance = allowed[_from][msg.sender];
156 
157     balances[_to] = safeAdd(balances[_to], _value);
158     balances[_from] = safeSub(balances[_from], _value);
159     allowed[_from][msg.sender] = safeSub(_allowance, _value);
160     Transfer(_from, _to, _value);
161     return true;
162   }
163 
164   function balanceOf(address _owner) constant returns (uint balance) {
165     return balances[_owner];
166   }
167 
168   function approve(address _spender, uint _value) returns (bool success) {
169 
170     // To change the approve amount you first have to reduce the addresses`
171     //  allowance to zero by calling `approve(_spender, 0)` if it is not
172     //  already 0 to mitigate the race condition described here:
173     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
174     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
175 
176     allowed[msg.sender][_spender] = _value;
177     Approval(msg.sender, _spender, _value);
178     return true;
179   }
180 
181   function allowance(address _owner, address _spender) constant returns (uint remaining) {
182     return allowed[_owner][_spender];
183   }
184 
185 }
186 
187 
188 /**
189  * Upgrade agent interface inspired by Lunyr.
190  *
191  * Upgrade agent transfers tokens to a new contract.
192  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
193  */
194 contract UpgradeAgent {
195 
196   uint public originalSupply;
197 
198   /** Interface marker */
199   function isUpgradeAgent() public constant returns (bool) {
200     return true;
201   }
202 
203   function upgradeFrom(address _from, uint256 _value) public;
204 
205 }
206 
207 
208 /**
209  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
210  *
211  * First envisioned by Golem and Lunyr projects.
212  */
213 contract UpgradeableToken is StandardToken {
214 
215   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
216   address public upgradeMaster;
217 
218   /** The next contract where the tokens will be migrated. */
219   UpgradeAgent public upgradeAgent;
220 
221   /** How many tokens we have upgraded by now. */
222   uint256 public totalUpgraded;
223 
224   /**
225    * Upgrade states.
226    *
227    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
228    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
229    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
230    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
231    *
232    */
233   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
234 
235   /**
236    * Somebody has upgraded some of his tokens.
237    */
238   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
239 
240   /**
241    * New upgrade agent available.
242    */
243   event UpgradeAgentSet(address agent);
244 
245   /**
246    * Do not allow construction without upgrade master set.
247    */
248   function UpgradeableToken(address _upgradeMaster) {
249     upgradeMaster = _upgradeMaster;
250   }
251 
252   /**
253    * Allow the token holder to upgrade some of their tokens to a new contract.
254    */
255   function upgrade(uint256 value) public {
256 
257       UpgradeState state = getUpgradeState();
258       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
259         // Called in a bad state
260         throw;
261       }
262 
263       // Validate input value.
264       if (value == 0) throw;
265 
266       balances[msg.sender] = safeSub(balances[msg.sender], value);
267 
268       // Take tokens out from circulation
269       totalSupply = safeSub(totalSupply, value);
270       totalUpgraded = safeAdd(totalUpgraded, value);
271 
272       // Upgrade agent reissues the tokens
273       upgradeAgent.upgradeFrom(msg.sender, value);
274       Upgrade(msg.sender, upgradeAgent, value);
275   }
276 
277   /**
278    * Set an upgrade agent that handles
279    */
280   function setUpgradeAgent(address agent) external {
281 
282       if(!canUpgrade()) {
283         // The token is not yet in a state that we could think upgrading
284         throw;
285       }
286 
287       if (agent == 0x0) throw;
288       // Only a master can designate the next agent
289       if (msg.sender != upgradeMaster) throw;
290       // Upgrade has already begun for an agent
291       if (getUpgradeState() == UpgradeState.Upgrading) throw;
292 
293       upgradeAgent = UpgradeAgent(agent);
294 
295       // Bad interface
296       if(!upgradeAgent.isUpgradeAgent()) throw;
297       // Make sure that token supplies match in source and target
298       if (upgradeAgent.originalSupply() != totalSupply) throw;
299 
300       UpgradeAgentSet(upgradeAgent);
301   }
302 
303   /**
304    * Get the state of the token upgrade.
305    */
306   function getUpgradeState() public constant returns(UpgradeState) {
307     if(!canUpgrade()) return UpgradeState.NotAllowed;
308     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
309     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
310     else return UpgradeState.Upgrading;
311   }
312 
313   /**
314    * Change the upgrade master.
315    *
316    * This allows us to set a new owner for the upgrade mechanism.
317    */
318   function setUpgradeMaster(address master) public {
319       if (master == 0x0) throw;
320       if (msg.sender != upgradeMaster) throw;
321       upgradeMaster = master;
322   }
323 
324   /**
325    * Child contract can enable to provide the condition when the upgrade can begun.
326    */
327   function canUpgrade() public constant returns(bool) {
328      return true;
329   }
330 
331 }
332 
333 
334 /**
335  * Define interface for releasing the token transfer after a successful crowdsale.
336  */
337 contract ReleasableToken is ERC20, Ownable {
338 
339   /* The finalizer contract that allows unlift the transfer limits on this token */
340   address public releaseAgent;
341 
342   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
343   bool public released = false;
344 
345   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
346   mapping (address => bool) public transferAgents;
347 
348   /**
349    * Limit token transfer until the crowdsale is over.
350    *
351    */
352   modifier canTransfer(address _sender) {
353 
354     if(!released) {
355         if(!transferAgents[_sender]) {
356             throw;
357         }
358     }
359 
360     _;
361   }
362 
363   /**
364    * Set the contract that can call release and make the token transferable.
365    *
366    * Design choice. Allow reset the release agent to fix fat finger mistakes.
367    */
368   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
369 
370     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
371     releaseAgent = addr;
372   }
373 
374   /**
375    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
376    */
377   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
378     transferAgents[addr] = state;
379   }
380 
381   /**
382    * One way function to release the tokens to the wild.
383    *
384    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
385    */
386   function releaseTokenTransfer() public onlyReleaseAgent {
387     released = true;
388   }
389 
390   /** The function can be called only before or after the tokens have been releasesd */
391   modifier inReleaseState(bool releaseState) {
392     if(releaseState != released) {
393         throw;
394     }
395     _;
396   }
397 
398   /** The function can be called only by a whitelisted release agent. */
399   modifier onlyReleaseAgent() {
400     if(msg.sender != releaseAgent) {
401         throw;
402     }
403     _;
404   }
405 
406   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
407     // Call StandardToken.transfer()
408    return super.transfer(_to, _value);
409   }
410 
411   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
412     // Call StandardToken.transferForm()
413     return super.transferFrom(_from, _to, _value);
414   }
415 
416 }
417 
418 
419 /**
420  * Safe unsigned safe math.
421  *
422  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
423  *
424  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
425  *
426  * Maintained here until merged to mainline zeppelin-solidity.
427  *
428  */
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
604 contract IXIRCOIN is ReleasableToken, MintableTokenExt, UpgradeableToken {
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
631   function IXIRCOIN(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable, uint _globalMinCap)
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