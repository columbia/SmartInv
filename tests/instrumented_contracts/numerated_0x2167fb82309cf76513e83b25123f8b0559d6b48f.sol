1 /**
2  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
3  *
4  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
5  */
6 
7 
8 /**
9  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
10  *
11  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
12  */
13 
14 
15 
16 
17 
18 
19 /**
20  * @title ERC20Basic
21  * @dev Simpler version of ERC20 interface
22  * @dev see https://github.com/ethereum/EIPs/issues/179
23  */
24 contract ERC20Basic {
25   uint256 public totalSupply;
26   function balanceOf(address who) constant returns (uint256);
27   function transfer(address to, uint256 value) returns (bool);
28   event Transfer(address indexed from, address indexed to, uint256 value);
29 }
30 
31 
32 
33 /**
34  * @title ERC20 interface
35  * @dev see https://github.com/ethereum/EIPs/issues/20
36  */
37 contract ERC20 is ERC20Basic {
38   function allowance(address owner, address spender) constant returns (uint256);
39   function transferFrom(address from, address to, uint256 value) returns (bool);
40   function approve(address spender, uint256 value) returns (bool);
41   event Approval(address indexed owner, address indexed spender, uint256 value);
42 }
43 
44 /**
45  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
46  *
47  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
48  */
49 
50 
51 
52 
53 
54 
55 
56 
57 
58 /**
59  * @title SafeMath
60  * @dev Math operations with safety checks that throw on error
61  */
62 library SafeMath {
63   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
64     uint256 c = a * b;
65     assert(a == 0 || c / a == b);
66     return c;
67   }
68 
69   function div(uint256 a, uint256 b) internal constant returns (uint256) {
70     // assert(b > 0); // Solidity automatically throws when dividing by 0
71     uint256 c = a / b;
72     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
73     return c;
74   }
75 
76   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
77     assert(b <= a);
78     return a - b;
79   }
80 
81   function add(uint256 a, uint256 b) internal constant returns (uint256) {
82     uint256 c = a + b;
83     assert(c >= a);
84     return c;
85   }
86 }
87 
88 
89 
90 /**
91  * @title Basic token
92  * @dev Basic version of StandardToken, with no allowances. 
93  */
94 contract BasicToken is ERC20Basic {
95   using SafeMath for uint256;
96 
97   mapping(address => uint256) balances;
98 
99   /**
100   * @dev transfer token for a specified address
101   * @param _to The address to transfer to.
102   * @param _value The amount to be transferred.
103   */
104   function transfer(address _to, uint256 _value) returns (bool) {
105     balances[msg.sender] = balances[msg.sender].sub(_value);
106     balances[_to] = balances[_to].add(_value);
107     Transfer(msg.sender, _to, _value);
108     return true;
109   }
110 
111   /**
112   * @dev Gets the balance of the specified address.
113   * @param _owner The address to query the the balance of. 
114   * @return An uint256 representing the amount owned by the passed address.
115   */
116   function balanceOf(address _owner) constant returns (uint256 balance) {
117     return balances[_owner];
118   }
119 
120 }
121 
122 
123 
124 
125 /**
126  * @title Standard ERC20 token
127  *
128  * @dev Implementation of the basic standard token.
129  * @dev https://github.com/ethereum/EIPs/issues/20
130  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
131  */
132 contract StandardToken is ERC20, BasicToken {
133 
134   mapping (address => mapping (address => uint256)) allowed;
135 
136 
137   /**
138    * @dev Transfer tokens from one address to another
139    * @param _from address The address which you want to send tokens from
140    * @param _to address The address which you want to transfer to
141    * @param _value uint256 the amout of tokens to be transfered
142    */
143   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
144     var _allowance = allowed[_from][msg.sender];
145 
146     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
147     // require (_value <= _allowance);
148 
149     balances[_to] = balances[_to].add(_value);
150     balances[_from] = balances[_from].sub(_value);
151     allowed[_from][msg.sender] = _allowance.sub(_value);
152     Transfer(_from, _to, _value);
153     return true;
154   }
155 
156   /**
157    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
158    * @param _spender The address which will spend the funds.
159    * @param _value The amount of tokens to be spent.
160    */
161   function approve(address _spender, uint256 _value) returns (bool) {
162 
163     // To change the approve amount you first have to reduce the addresses`
164     //  allowance to zero by calling `approve(_spender, 0)` if it is not
165     //  already 0 to mitigate the race condition described here:
166     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
168 
169     allowed[msg.sender][_spender] = _value;
170     Approval(msg.sender, _spender, _value);
171     return true;
172   }
173 
174   /**
175    * @dev Function to check the amount of tokens that an owner allowed to a spender.
176    * @param _owner address The address which owns the funds.
177    * @param _spender address The address which will spend the funds.
178    * @return A uint256 specifing the amount of tokens still available for the spender.
179    */
180   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
181     return allowed[_owner][_spender];
182   }
183 
184 }
185 
186 
187 
188 /**
189  * Standard EIP-20 token with an interface marker.
190  *
191  * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.
192  *
193  */
194 contract StandardTokenExt is StandardToken {
195 
196   /* Interface declaration */
197   function isToken() public constant returns (bool weAre) {
198     return true;
199   }
200 }
201 
202 /**
203  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
204  *
205  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
206  */
207 
208 
209 /**
210  * Upgrade agent interface inspired by Lunyr.
211  *
212  * Upgrade agent transfers tokens to a new contract.
213  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
214  */
215 contract UpgradeAgent {
216 
217   uint public originalSupply;
218 
219   /** Interface marker */
220   function isUpgradeAgent() public constant returns (bool) {
221     return true;
222   }
223 
224   function upgradeFrom(address _from, uint256 _value) public;
225 
226 }
227 
228 
229 /**
230  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
231  *
232  * First envisioned by Golem and Lunyr projects.
233  */
234 contract UpgradeableToken is StandardTokenExt {
235 
236   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
237   address public upgradeMaster;
238 
239   /** The next contract where the tokens will be migrated. */
240   UpgradeAgent public upgradeAgent;
241 
242   /** How many tokens we have upgraded by now. */
243   uint256 public totalUpgraded;
244 
245   /**
246    * Upgrade states.
247    *
248    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
249    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
250    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
251    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
252    *
253    */
254   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
255 
256   /**
257    * Somebody has upgraded some of his tokens.
258    */
259   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
260 
261   /**
262    * New upgrade agent available.
263    */
264   event UpgradeAgentSet(address agent);
265 
266   /**
267    * Do not allow construction without upgrade master set.
268    */
269   function UpgradeableToken(address _upgradeMaster) {
270     upgradeMaster = _upgradeMaster;
271   }
272 
273   /**
274    * Allow the token holder to upgrade some of their tokens to a new contract.
275    */
276   function upgrade(uint256 value) public {
277 
278       UpgradeState state = getUpgradeState();
279       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
280         // Called in a bad state
281         throw;
282       }
283 
284       // Validate input value.
285       if (value == 0) throw;
286 
287       balances[msg.sender] = balances[msg.sender].sub(value);
288 
289       // Take tokens out from circulation
290       totalSupply = totalSupply.sub(value);
291       totalUpgraded = totalUpgraded.add(value);
292 
293       // Upgrade agent reissues the tokens
294       upgradeAgent.upgradeFrom(msg.sender, value);
295       Upgrade(msg.sender, upgradeAgent, value);
296   }
297 
298   /**
299    * Set an upgrade agent that handles
300    */
301   function setUpgradeAgent(address agent) external {
302 
303       if(!canUpgrade()) {
304         // The token is not yet in a state that we could think upgrading
305         throw;
306       }
307 
308       if (agent == 0x0) throw;
309       // Only a master can designate the next agent
310       if (msg.sender != upgradeMaster) throw;
311       // Upgrade has already begun for an agent
312       if (getUpgradeState() == UpgradeState.Upgrading) throw;
313 
314       upgradeAgent = UpgradeAgent(agent);
315 
316       // Bad interface
317       if(!upgradeAgent.isUpgradeAgent()) throw;
318       // Make sure that token supplies match in source and target
319       if (upgradeAgent.originalSupply() != totalSupply) throw;
320 
321       UpgradeAgentSet(upgradeAgent);
322   }
323 
324   /**
325    * Get the state of the token upgrade.
326    */
327   function getUpgradeState() public constant returns(UpgradeState) {
328     if(!canUpgrade()) return UpgradeState.NotAllowed;
329     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
330     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
331     else return UpgradeState.Upgrading;
332   }
333 
334   /**
335    * Change the upgrade master.
336    *
337    * This allows us to set a new owner for the upgrade mechanism.
338    */
339   function setUpgradeMaster(address master) public {
340       if (master == 0x0) throw;
341       if (msg.sender != upgradeMaster) throw;
342       upgradeMaster = master;
343   }
344 
345   /**
346    * Child contract can enable to provide the condition when the upgrade can begun.
347    */
348   function canUpgrade() public constant returns(bool) {
349      return true;
350   }
351 
352 }
353 
354 /**
355  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
356  *
357  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
358  */
359 
360 
361 
362 
363 /**
364  * @title Ownable
365  * @dev The Ownable contract has an owner address, and provides basic authorization control
366  * functions, this simplifies the implementation of "user permissions".
367  */
368 contract Ownable {
369   address public owner;
370 
371 
372   /**
373    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
374    * account.
375    */
376   function Ownable() {
377     owner = msg.sender;
378   }
379 
380 
381   /**
382    * @dev Throws if called by any account other than the owner.
383    */
384   modifier onlyOwner() {
385     require(msg.sender == owner);
386     _;
387   }
388 
389 
390   /**
391    * @dev Allows the current owner to transfer control of the contract to a newOwner.
392    * @param newOwner The address to transfer ownership to.
393    */
394   function transferOwnership(address newOwner) onlyOwner {
395     require(newOwner != address(0));      
396     owner = newOwner;
397   }
398 
399 }
400 
401 
402 
403 
404 /**
405  * Define interface for releasing the token transfer after a successful crowdsale.
406  */
407 contract ReleasableToken is ERC20, Ownable {
408 
409   /* The finalizer contract that allows unlift the transfer limits on this token */
410   address public releaseAgent;
411 
412   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
413   bool public released = false;
414 
415   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
416   mapping (address => bool) public transferAgents;
417 
418   /**
419    * Limit token transfer until the crowdsale is over.
420    *
421    */
422   modifier canTransfer(address _sender) {
423 
424     if(!released) {
425         if(!transferAgents[_sender]) {
426             throw;
427         }
428     }
429 
430     _;
431   }
432 
433   /**
434    * Set the contract that can call release and make the token transferable.
435    *
436    * Design choice. Allow reset the release agent to fix fat finger mistakes.
437    */
438   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
439 
440     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
441     releaseAgent = addr;
442   }
443 
444   /**
445    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
446    */
447   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
448     transferAgents[addr] = state;
449   }
450 
451   /**
452    * One way function to release the tokens to the wild.
453    *
454    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
455    */
456   function releaseTokenTransfer() public onlyReleaseAgent {
457     released = true;
458   }
459 
460   /** The function can be called only before or after the tokens have been releasesd */
461   modifier inReleaseState(bool releaseState) {
462     if(releaseState != released) {
463         throw;
464     }
465     _;
466   }
467 
468   /** The function can be called only by a whitelisted release agent. */
469   modifier onlyReleaseAgent() {
470     if(msg.sender != releaseAgent) {
471         throw;
472     }
473     _;
474   }
475 
476   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
477     // Call StandardToken.transfer()
478    return super.transfer(_to, _value);
479   }
480 
481   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
482     // Call StandardToken.transferForm()
483     return super.transferFrom(_from, _to, _value);
484   }
485 
486 }
487 
488 /**
489  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
490  *
491  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
492  */
493 
494 
495 
496 
497 /**
498  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
499  *
500  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
501  */
502 
503 
504 /**
505  * Safe unsigned safe math.
506  *
507  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
508  *
509  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
510  *
511  * Maintained here until merged to mainline zeppelin-solidity.
512  *
513  */
514 library SafeMathLib {
515 
516   function times(uint a, uint b) returns (uint) {
517     uint c = a * b;
518     assert(a == 0 || c / a == b);
519     return c;
520   }
521 
522   function minus(uint a, uint b) returns (uint) {
523     assert(b <= a);
524     return a - b;
525   }
526 
527   function plus(uint a, uint b) returns (uint) {
528     uint c = a + b;
529     assert(c>=a);
530     return c;
531   }
532 
533 }
534 
535 
536 
537 /**
538  * A token that can increase its supply by another contract.
539  *
540  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
541  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
542  *
543  */
544 contract MintableToken is StandardTokenExt, Ownable {
545 
546   using SafeMathLib for uint;
547 
548   bool public mintingFinished = false;
549 
550   /** List of agents that are allowed to create new tokens */
551   mapping (address => bool) public mintAgents;
552 
553   event MintingAgentChanged(address addr, bool state);
554   event Minted(address receiver, uint amount);
555 
556   /**
557    * Create new tokens and allocate them to an address..
558    *
559    * Only callably by a crowdsale contract (mint agent).
560    */
561   function mint(address receiver, uint amount) onlyMintAgent canMint public {
562     totalSupply = totalSupply.plus(amount);
563     balances[receiver] = balances[receiver].plus(amount);
564 
565     // This will make the mint transaction apper in EtherScan.io
566     // We can remove this after there is a standardized minting event
567     Transfer(0, receiver, amount);
568   }
569 
570   /**
571    * Owner can allow a crowdsale contract to mint new tokens.
572    */
573   function setMintAgent(address addr, bool state) onlyOwner canMint public {
574     mintAgents[addr] = state;
575     MintingAgentChanged(addr, state);
576   }
577 
578   modifier onlyMintAgent() {
579     // Only crowdsale contracts are allowed to mint new tokens
580     if(!mintAgents[msg.sender]) {
581         throw;
582     }
583     _;
584   }
585 
586   /** Make sure we are not done yet. */
587   modifier canMint() {
588     if(mintingFinished) throw;
589     _;
590   }
591 }
592 
593 
594 
595 /**
596  * A crowdsaled token.
597  *
598  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
599  *
600  * - The token transfer() is disabled until the crowdsale is over
601  * - The token contract gives an opt-in upgrade path to a new contract
602  * - The same token can be part of several crowdsales through approve() mechanism
603  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
604  *
605  */
606 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
607 
608   /** Name and symbol were updated. */
609   event UpdatedTokenInformation(string newName, string newSymbol);
610 
611   string public name;
612 
613   string public symbol;
614 
615   uint public decimals;
616 
617   /**
618    * Construct the token.
619    *
620    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
621    *
622    * @param _name Token name
623    * @param _symbol Token symbol - should be all caps
624    * @param _initialSupply How many tokens we start with
625    * @param _decimals Number of decimal places
626    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
627    */
628   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
629     UpgradeableToken(msg.sender) {
630 
631     // Create any address, can be transferred
632     // to team multisig via changeOwner(),
633     // also remember to call setUpgradeMaster()
634     owner = msg.sender;
635 
636     name = _name;
637     symbol = _symbol;
638 
639     totalSupply = _initialSupply;
640 
641     decimals = _decimals;
642 
643     // Create initially all balance on the team multisig
644     balances[owner] = totalSupply;
645 
646     if(totalSupply > 0) {
647       Minted(owner, totalSupply);
648     }
649 
650     // No more new supply allowed after the token creation
651     if(!_mintable) {
652       mintingFinished = true;
653       if(totalSupply == 0) {
654         throw; // Cannot create a token without supply and no minting
655       }
656     }
657   }
658 
659   /**
660    * When token is released to be transferable, enforce no new tokens can be created.
661    */
662   function releaseTokenTransfer() public onlyReleaseAgent {
663     mintingFinished = true;
664     super.releaseTokenTransfer();
665   }
666 
667   /**
668    * Allow upgrade agent functionality kick in only if the crowdsale was success.
669    */
670   function canUpgrade() public constant returns(bool) {
671     return released && super.canUpgrade();
672   }
673 
674   /**
675    * Owner can update token information here.
676    *
677    * It is often useful to conceal the actual token association, until
678    * the token operations, like central issuance or reissuance have been completed.
679    *
680    * This function allows the token owner to rename the token after the operations
681    * have been completed and then point the audience to use the token contract.
682    */
683   function setTokenInformation(string _name, string _symbol) onlyOwner {
684     name = _name;
685     symbol = _symbol;
686 
687     UpdatedTokenInformation(name, symbol);
688   }
689 
690 }