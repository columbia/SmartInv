1 pragma solidity ^0.4.11;
2 contract ERC20Basic {
3   uint256 public totalSupply;
4   function balanceOf(address who) public constant returns (uint256);
5   function transfer(address to, uint256 value) public returns (bool);
6   event Transfer(address indexed from, address indexed to, uint256 value);
7 }
8 
9 
10 
11 
12 contract Ownable {
13   address public owner;
14 
15 
16   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   function Ownable() {
24     owner = msg.sender;
25   }
26 
27 
28   /**
29    * @dev Throws if called by any account other than the owner.
30    */
31   modifier onlyOwner() {
32     require(msg.sender == owner);
33     _;
34   }
35 
36 
37   /**
38    * @dev Allows the current owner to transfer control of the contract to a newOwner.
39    * @param newOwner The address to transfer ownership to.
40    */
41   function transferOwnership(address newOwner) onlyOwner public {
42     require(newOwner != address(0));
43     OwnershipTransferred(owner, newOwner);
44     owner = newOwner;
45   }
46 
47 }
48 // Temporarily have SafeMath here until all contracts have been migrated to SafeMathLib version from OpenZeppelin
49 
50 
51 
52 
53 /**
54  * Math operations with safety checks
55  */
56 contract SafeMath {
57   function safeMul(uint a, uint b) internal returns (uint) {
58     uint c = a * b;
59     assert(a == 0 || c / a == b);
60     return c;
61   }
62 
63   function safeDiv(uint a, uint b) internal returns (uint) {
64     assert(b > 0);
65     uint c = a / b;
66     assert(a == b * c + a % b);
67     return c;
68   }
69 
70   function safeSub(uint a, uint b) internal returns (uint) {
71     assert(b <= a);
72     return a - b;
73   }
74 
75   function safeAdd(uint a, uint b) internal returns (uint) {
76     uint c = a + b;
77     assert(c>=a && c>=b);
78     return c;
79   }
80 
81   function max64(uint64 a, uint64 b) internal constant returns (uint64) {
82     return a >= b ? a : b;
83   }
84 
85   function min64(uint64 a, uint64 b) internal constant returns (uint64) {
86     return a < b ? a : b;
87   }
88 
89   function max256(uint256 a, uint256 b) internal constant returns (uint256) {
90     return a >= b ? a : b;
91   }
92 
93   function min256(uint256 a, uint256 b) internal constant returns (uint256) {
94     return a < b ? a : b;
95   }
96 
97 }
98 
99 
100 
101 contract ERC20 is ERC20Basic {
102   function allowance(address owner, address spender) public constant returns (uint256);
103   function transferFrom(address from, address to, uint256 value) public returns (bool);
104   function approve(address spender, uint256 value) public returns (bool);
105   event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 
109 
110 
111 contract StandardToken is ERC20, SafeMath {
112 
113   /* Token supply got increased and a new owner received these tokens */
114   event Minted(address receiver, uint amount);
115 
116   /* Actual balances of token holders */
117   mapping(address => uint) balances;
118 
119   /* approve() allowances */
120   mapping (address => mapping (address => uint)) allowed;
121 
122   /* Interface declaration */
123   function isToken() public constant returns (bool weAre) {
124     return true;
125   }
126 
127   function transfer(address _to, uint _value) returns (bool success) {
128     balances[msg.sender] = safeSub(balances[msg.sender], _value);
129     balances[_to] = safeAdd(balances[_to], _value);
130     Transfer(msg.sender, _to, _value);
131     return true;
132   }
133 
134   function transferFrom(address _from, address _to, uint _value) returns (bool success) {
135     uint _allowance = allowed[_from][msg.sender];
136 
137     balances[_to] = safeAdd(balances[_to], _value);
138     balances[_from] = safeSub(balances[_from], _value);
139     allowed[_from][msg.sender] = safeSub(_allowance, _value);
140     Transfer(_from, _to, _value);
141     return true;
142   }
143 
144   function balanceOf(address _owner) constant returns (uint balance) {
145     return balances[_owner];
146   }
147 
148   function approve(address _spender, uint _value) returns (bool success) {
149 
150     // To change the approve amount you first have to reduce the addresses`
151     //  allowance to zero by calling `approve(_spender, 0)` if it is not
152     //  already 0 to mitigate the race condition described here:
153     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154     if ((_value != 0) && (allowed[msg.sender][_spender] != 0)) throw;
155 
156     allowed[msg.sender][_spender] = _value;
157     Approval(msg.sender, _spender, _value);
158     return true;
159   }
160 
161   function allowance(address _owner, address _spender) constant returns (uint remaining) {
162     return allowed[_owner][_spender];
163   }
164 
165 }
166 
167 
168 contract UpgradeAgent {
169 
170   uint public originalSupply;
171 
172   /** Interface marker */
173   function isUpgradeAgent() public constant returns (bool) {
174     return true;
175   }
176 
177   function upgradeFrom(address _from, uint256 _value) public;
178 
179 }
180 
181 
182 
183 contract UpgradeableToken is StandardToken {
184 
185   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
186   address public upgradeMaster;
187 
188   /** The next contract where the tokens will be migrated. */
189   UpgradeAgent public upgradeAgent;
190 
191   /** How many tokens we have upgraded by now. */
192   uint256 public totalUpgraded;
193 
194   /**
195    * Upgrade states.
196    *
197    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
198    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
199    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
200    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
201    *
202    */
203   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
204 
205   /**
206    * Somebody has upgraded some of his tokens.
207    */
208   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
209 
210   /**
211    * New upgrade agent available.
212    */
213   event UpgradeAgentSet(address agent);
214 
215   /**
216    * Do not allow construction without upgrade master set.
217    */
218   function UpgradeableToken(address _upgradeMaster) {
219     upgradeMaster = _upgradeMaster;
220   }
221 
222   /**
223    * Allow the token holder to upgrade some of their tokens to a new contract.
224    */
225   function upgrade(uint256 value) public {
226 
227       UpgradeState state = getUpgradeState();
228       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
229         // Called in a bad state
230         throw;
231       }
232 
233       // Validate input value.
234       if (value == 0) throw;
235 
236       balances[msg.sender] = safeSub(balances[msg.sender], value);
237 
238       // Take tokens out from circulation
239       totalSupply = safeSub(totalSupply, value);
240       totalUpgraded = safeAdd(totalUpgraded, value);
241 
242       // Upgrade agent reissues the tokens
243       upgradeAgent.upgradeFrom(msg.sender, value);
244       Upgrade(msg.sender, upgradeAgent, value);
245   }
246 
247   /**
248    * Set an upgrade agent that handles
249    */
250   function setUpgradeAgent(address agent) external {
251 
252       if(!canUpgrade()) {
253         // The token is not yet in a state that we could think upgrading
254         throw;
255       }
256 
257       if (agent == 0x0) throw;
258       // Only a master can designate the next agent
259       if (msg.sender != upgradeMaster) throw;
260       // Upgrade has already begun for an agent
261       if (getUpgradeState() == UpgradeState.Upgrading) throw;
262 
263       upgradeAgent = UpgradeAgent(agent);
264 
265       // Bad interface
266       if(!upgradeAgent.isUpgradeAgent()) throw;
267       // Make sure that token supplies match in source and target
268       if (upgradeAgent.originalSupply() != totalSupply) throw;
269 
270       UpgradeAgentSet(upgradeAgent);
271   }
272 
273   /**
274    * Get the state of the token upgrade.
275    */
276   function getUpgradeState() public constant returns(UpgradeState) {
277     if(!canUpgrade()) return UpgradeState.NotAllowed;
278     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
279     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
280     else return UpgradeState.Upgrading;
281   }
282 
283   /**
284    * Change the upgrade master.
285    *
286    * This allows us to set a new owner for the upgrade mechanism.
287    */
288   function setUpgradeMaster(address master) public {
289       if (master == 0x0) throw;
290       if (msg.sender != upgradeMaster) throw;
291       upgradeMaster = master;
292   }
293 
294   /**
295    * Child contract can enable to provide the condition when the upgrade can begun.
296    */
297   function canUpgrade() public constant returns(bool) {
298      return true;
299   }
300 
301 }
302 
303 /**
304  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
305  *
306  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
307  */
308 
309 
310 
311 
312 
313 
314 
315 /**
316  * Define interface for releasing the token transfer after a successful crowdsale.
317  */
318 contract ReleasableToken is ERC20, Ownable {
319 
320   /* The finalizer contract that allows unlift the transfer limits on this token */
321   address public releaseAgent;
322 
323   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
324   bool public released = false;
325 
326   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
327   mapping (address => bool) public transferAgents;
328 
329   /**
330    * Limit token transfer until the crowdsale is over.
331    *
332    */
333   modifier canTransfer(address _sender) {
334 
335     if(!released) {
336         if(!transferAgents[_sender]) {
337             throw;
338         }
339     }
340 
341     _;
342   }
343 
344   /**
345    * Set the contract that can call release and make the token transferable.
346    *
347    * Design choice. Allow reset the release agent to fix fat finger mistakes.
348    */
349   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
350 
351     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
352     releaseAgent = addr;
353   }
354 
355   /**
356    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
357    */
358   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
359     transferAgents[addr] = state;
360   }
361 
362   /**
363    * One way function to release the tokens to the wild.
364    *
365    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
366    */
367   function releaseTokenTransfer() public onlyReleaseAgent {
368     released = true;
369   }
370 
371   /** The function can be called only before or after the tokens have been releasesd */
372   modifier inReleaseState(bool releaseState) {
373     if(releaseState != released) {
374         throw;
375     }
376     _;
377   }
378 
379   /** The function can be called only by a whitelisted release agent. */
380   modifier onlyReleaseAgent() {
381     if(msg.sender != releaseAgent) {
382         throw;
383     }
384     _;
385   }
386 
387   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
388     // Call StandardToken.transfer()
389    return super.transfer(_to, _value);
390   }
391 
392   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
393     // Call StandardToken.transferForm()
394     return super.transferFrom(_from, _to, _value);
395   }
396 
397 }
398 
399 
400 library SafeMathLibExt {
401 
402   function times(uint a, uint b) returns (uint) {
403     uint c = a * b;
404     assert(a == 0 || c / a == b);
405     return c;
406   }
407 
408   function divides(uint a, uint b) returns (uint) {
409     assert(b > 0);
410     uint c = a / b;
411     assert(a == b * c + a % b);
412     return c;
413   }
414 
415   function minus(uint a, uint b) returns (uint) {
416     assert(b <= a);
417     return a - b;
418   }
419 
420   function plus(uint a, uint b) returns (uint) {
421     uint c = a + b;
422     assert(c>=a);
423     return c;
424   }
425 
426 }
427 
428 
429 
430 
431 contract MintableTokenExt is StandardToken, Ownable {
432 
433   using SafeMathLibExt for uint;
434 
435   bool public mintingFinished = false;
436 
437   /** List of agents that are allowed to create new tokens */
438   mapping (address => bool) public mintAgents;
439 
440   event MintingAgentChanged(address addr, bool state  );
441 
442   /** inPercentageUnit is percents of tokens multiplied to 10 up to percents decimals.
443   * For example, for reserved tokens in percents 2.54%
444   * inPercentageUnit = 254
445   * inPercentageDecimals = 2
446   */
447   struct ReservedTokensData {
448     uint inTokens;
449     uint inPercentageUnit;
450     uint inPercentageDecimals;
451     bool isReserved;
452     bool isDistributed;
453   }
454 
455   mapping (address => ReservedTokensData) public reservedTokensList;
456   address[] public reservedTokensDestinations;
457   uint public reservedTokensDestinationsLen = 0;
458   bool reservedTokensDestinationsAreSet = false;
459 
460   modifier onlyMintAgent() {
461     // Only crowdsale contracts are allowed to mint new tokens
462     if(!mintAgents[msg.sender]) {
463         throw;
464     }
465     _;
466   }
467 
468   /** Make sure we are not done yet. */
469   modifier canMint() {
470     if(mintingFinished) throw;
471     _;
472   }
473 
474   function finalizeReservedAddress(address addr) public onlyMintAgent canMint {
475     ReservedTokensData storage reservedTokensData = reservedTokensList[addr];
476     reservedTokensData.isDistributed = true;
477   }
478 
479   function isAddressReserved(address addr) public constant returns (bool isReserved) {
480     return reservedTokensList[addr].isReserved;
481   }
482 
483   function areTokensDistributedForAddress(address addr) public constant returns (bool isDistributed) {
484     return reservedTokensList[addr].isDistributed;
485   }
486 
487   function getReservedTokens(address addr) public constant returns (uint inTokens) {
488     return reservedTokensList[addr].inTokens;
489   }
490 
491   function getReservedPercentageUnit(address addr) public constant returns (uint inPercentageUnit) {
492     return reservedTokensList[addr].inPercentageUnit;
493   }
494 
495   function getReservedPercentageDecimals(address addr) public constant returns (uint inPercentageDecimals) {
496     return reservedTokensList[addr].inPercentageDecimals;
497   }
498 
499   function setReservedTokensListMultiple(
500     address[] addrs, 
501     uint[] inTokens, 
502     uint[] inPercentageUnit, 
503     uint[] inPercentageDecimals
504   ) public canMint onlyOwner {
505     assert(!reservedTokensDestinationsAreSet);
506     assert(addrs.length == inTokens.length);
507     assert(inTokens.length == inPercentageUnit.length);
508     assert(inPercentageUnit.length == inPercentageDecimals.length);
509     for (uint iterator = 0; iterator < addrs.length; iterator++) {
510       if (addrs[iterator] != address(0)) {
511         setReservedTokensList(addrs[iterator], inTokens[iterator], inPercentageUnit[iterator], inPercentageDecimals[iterator]);
512       }
513     }
514     reservedTokensDestinationsAreSet = true;
515   }
516 
517   /**
518    * Create new tokens and allocate them to an address..
519    *
520    * Only callably by a crowdsale contract (mint agent).
521    */
522   function mint(address receiver, uint amount) onlyMintAgent canMint public {
523     totalSupply = totalSupply.plus(amount);
524     balances[receiver] = balances[receiver].plus(amount);
525 
526     // This will make the mint transaction apper in EtherScan.io
527     // We can remove this after there is a standardized minting event
528     Transfer(0, receiver, amount);
529   }
530 
531   /**
532    * Owner can allow a crowdsale contract to mint new tokens.
533    */
534   function setMintAgent(address addr, bool state) onlyOwner canMint public {
535     mintAgents[addr] = state;
536     MintingAgentChanged(addr, state);
537   }
538 
539   function setReservedTokensList(address addr, uint inTokens, uint inPercentageUnit, uint inPercentageDecimals) private canMint onlyOwner {
540     assert(addr != address(0));
541     if (!isAddressReserved(addr)) {
542       reservedTokensDestinations.push(addr);
543       reservedTokensDestinationsLen++;
544     }
545 
546     reservedTokensList[addr] = ReservedTokensData({
547       inTokens: inTokens, 
548       inPercentageUnit: inPercentageUnit, 
549       inPercentageDecimals: inPercentageDecimals,
550       isReserved: true,
551       isDistributed: false
552     });
553   }
554 }
555 
556 
557 contract CrowdsaleTokenExt is ReleasableToken, MintableTokenExt, UpgradeableToken {
558 
559   /** Name and symbol were updated. */
560   event UpdatedTokenInformation(string newName, string newSymbol);
561 
562   event ClaimedTokens(address indexed _token, address indexed _controller, uint _amount);
563 
564   string public name;
565 
566   string public symbol;
567 
568   uint public decimals;
569 
570   /* Minimum ammount of tokens every buyer can buy. */
571   uint public minCap;
572 
573   /**
574    * Construct the token.
575    *
576    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
577    *
578    * @param _name Token name
579    * @param _symbol Token symbol - should be all caps
580    * @param _initialSupply How many tokens we start with
581    * @param _decimals Number of decimal places
582    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
583    */
584   function CrowdsaleTokenExt(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable, uint _globalMinCap)
585     UpgradeableToken(msg.sender) {
586 
587     // Create any address, can be transferred
588     // to team multisig via changeOwner(),
589     // also remember to call setUpgradeMaster()
590     owner = msg.sender;
591 
592     name = _name;
593     symbol = _symbol;
594 
595     totalSupply = _initialSupply;
596 
597     decimals = _decimals;
598 
599     minCap = _globalMinCap;
600 
601     // Create initially all balance on the team multisig
602     balances[owner] = totalSupply;
603 
604     if(totalSupply > 0) {
605       Minted(owner, totalSupply);
606     }
607 
608     // No more new supply allowed after the token creation
609     if(!_mintable) {
610       mintingFinished = true;
611       if(totalSupply == 0) {
612         throw; // Cannot create a token without supply and no minting
613       }
614     }
615   }
616 
617   /**
618    * When token is released to be transferable, enforce no new tokens can be created.
619    */
620   function releaseTokenTransfer() public onlyReleaseAgent {
621     mintingFinished = true;
622     super.releaseTokenTransfer();
623   }
624 
625   /**
626    * Allow upgrade agent functionality kick in only if the crowdsale was success.
627    */
628   function canUpgrade() public constant returns(bool) {
629     return released && super.canUpgrade();
630   }
631 
632   
633   function setTokenInformation(string _name, string _symbol) onlyOwner {
634     name = _name;
635     symbol = _symbol;
636 
637     UpdatedTokenInformation(name, symbol);
638   }
639 
640   /**
641    * Claim tokens that were accidentally sent to this contract.
642    *
643    * @param _token The address of the token contract that you want to recover.
644    */
645   function claimTokens(address _token) public onlyOwner {
646     require(_token != address(0));
647 
648     ERC20 token = ERC20(_token);
649     uint balance = token.balanceOf(this);
650     token.transfer(owner, balance);
651 
652     ClaimedTokens(_token, owner, balance);
653   }
654 
655 }