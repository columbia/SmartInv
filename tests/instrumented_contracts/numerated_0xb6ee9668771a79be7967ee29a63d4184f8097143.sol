1 pragma solidity ^0.4.11;
2 
3 // File: contracts/SafeMathLib.sol
4 
5 /**
6  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
7  *
8  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
9  */
10 
11 pragma solidity ^0.4.6;
12 
13 /**
14  * Safe unsigned safe math.
15  *
16  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
17  *
18  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
19  *
20  * Maintained here until merged to mainline zeppelin-solidity.
21  *
22  */
23 library SafeMathLib {
24 
25   function times(uint a, uint b) returns (uint) {
26     uint c = a * b;
27     assert(a == 0 || c / a == b);
28     return c;
29   }
30 
31   function minus(uint a, uint b) returns (uint) {
32     assert(b <= a);
33     return a - b;
34   }
35 
36   function plus(uint a, uint b) returns (uint) {
37     uint c = a + b;
38     assert(c>=a);
39     return c;
40   }
41 
42 }
43 
44 // File: contracts/zeppelin/contracts/math/SafeMath.sol
45 
46 /**
47  * @title SafeMath
48  * @dev Math operations with safety checks that throw on error
49  */
50 library SafeMath {
51   function mul(uint256 a, uint256 b) internal constant returns (uint256) {
52     uint256 c = a * b;
53     assert(a == 0 || c / a == b);
54     return c;
55   }
56 
57   function div(uint256 a, uint256 b) internal constant returns (uint256) {
58     // assert(b > 0); // Solidity automatically throws when dividing by 0
59     uint256 c = a / b;
60     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
61     return c;
62   }
63 
64   function sub(uint256 a, uint256 b) internal constant returns (uint256) {
65     assert(b <= a);
66     return a - b;
67   }
68 
69   function add(uint256 a, uint256 b) internal constant returns (uint256) {
70     uint256 c = a + b;
71     assert(c >= a);
72     return c;
73   }
74 }
75 
76 // File: contracts/zeppelin/contracts/token/ERC20Basic.sol
77 
78 /**
79  * @title ERC20Basic
80  * @dev Simpler version of ERC20 interface
81  * @dev see https://github.com/ethereum/EIPs/issues/179
82  */
83 contract ERC20Basic {
84   uint256 public totalSupply;
85   function balanceOf(address who) constant returns (uint256);
86   function transfer(address to, uint256 value) returns (bool);
87   event Transfer(address indexed from, address indexed to, uint256 value);
88 }
89 
90 // File: contracts/zeppelin/contracts/token/BasicToken.sol
91 
92 /**
93  * @title Basic token
94  * @dev Basic version of StandardToken, with no allowances.
95  */
96 contract BasicToken is ERC20Basic {
97   using SafeMath for uint256;
98 
99   mapping(address => uint256) balances;
100 
101   /**
102   * @dev transfer token for a specified address
103   * @param _to The address to transfer to.
104   * @param _value The amount to be transferred.
105   */
106   function transfer(address _to, uint256 _value) returns (bool) {
107     balances[msg.sender] = balances[msg.sender].sub(_value);
108     balances[_to] = balances[_to].add(_value);
109     Transfer(msg.sender, _to, _value);
110     return true;
111   }
112 
113   /**
114   * @dev Gets the balance of the specified address.
115   * @param _owner The address to query the the balance of.
116   * @return An uint256 representing the amount owned by the passed address.
117   */
118   function balanceOf(address _owner) constant returns (uint256 balance) {
119     return balances[_owner];
120   }
121 
122 }
123 
124 // File: contracts/zeppelin/contracts/token/ERC20.sol
125 
126 /**
127  * @title ERC20 interface
128  * @dev see https://github.com/ethereum/EIPs/issues/20
129  */
130 contract ERC20 is ERC20Basic {
131   function allowance(address owner, address spender) constant returns (uint256);
132   function transferFrom(address from, address to, uint256 value) returns (bool);
133   function approve(address spender, uint256 value) returns (bool);
134   event Approval(address indexed owner, address indexed spender, uint256 value);
135 }
136 
137 // File: contracts/zeppelin/contracts/token/StandardToken.sol
138 
139 /**
140  * @title Standard ERC20 token
141  *
142  * @dev Implementation of the basic standard token.
143  * @dev https://github.com/ethereum/EIPs/issues/20
144  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
145  */
146 contract StandardToken is ERC20, BasicToken {
147 
148   mapping (address => mapping (address => uint256)) allowed;
149 
150 
151   /**
152    * @dev Transfer tokens from one address to another
153    * @param _from address The address which you want to send tokens from
154    * @param _to address The address which you want to transfer to
155    * @param _value uint256 the amout of tokens to be transfered
156    */
157   function transferFrom(address _from, address _to, uint256 _value) returns (bool) {
158     var _allowance = allowed[_from][msg.sender];
159 
160     // Check is not needed because sub(_allowance, _value) will already throw if this condition is not met
161     // require (_value <= _allowance);
162 
163     balances[_to] = balances[_to].add(_value);
164     balances[_from] = balances[_from].sub(_value);
165     allowed[_from][msg.sender] = _allowance.sub(_value);
166     Transfer(_from, _to, _value);
167     return true;
168   }
169 
170   /**
171    * @dev Aprove the passed address to spend the specified amount of tokens on behalf of msg.sender.
172    * @param _spender The address which will spend the funds.
173    * @param _value The amount of tokens to be spent.
174    */
175   function approve(address _spender, uint256 _value) returns (bool) {
176 
177     // To change the approve amount you first have to reduce the addresses`
178     //  allowance to zero by calling `approve(_spender, 0)` if it is not
179     //  already 0 to mitigate the race condition described here:
180     //  https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
181     require((_value == 0) || (allowed[msg.sender][_spender] == 0));
182 
183     allowed[msg.sender][_spender] = _value;
184     Approval(msg.sender, _spender, _value);
185     return true;
186   }
187 
188   /**
189    * @dev Function to check the amount of tokens that an owner allowed to a spender.
190    * @param _owner address The address which owns the funds.
191    * @param _spender address The address which will spend the funds.
192    * @return A uint256 specifing the amount of tokens still available for the spender.
193    */
194   function allowance(address _owner, address _spender) constant returns (uint256 remaining) {
195     return allowed[_owner][_spender];
196   }
197 
198 }
199 
200 // File: contracts/StandardTokenExt.sol
201 
202 /**
203  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
204  *
205  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
206  */
207 
208 pragma solidity ^0.4.14;
209 
210 
211 
212 
213 /**
214  * Standard EIP-20 token with an interface marker.
215  *
216  * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.
217  *
218  */
219 contract StandardTokenExt is StandardToken {
220 
221   /* Interface declaration */
222   function isToken() public constant returns (bool weAre) {
223     return true;
224   }
225 }
226 
227 // File: contracts/zeppelin/contracts/ownership/Ownable.sol
228 
229 /**
230  * @title Ownable
231  * @dev The Ownable contract has an owner address, and provides basic authorization control
232  * functions, this simplifies the implementation of "user permissions".
233  */
234 contract Ownable {
235   address public owner;
236 
237 
238   /**
239    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
240    * account.
241    */
242   function Ownable() {
243     owner = msg.sender;
244   }
245 
246 
247   /**
248    * @dev Throws if called by any account other than the owner.
249    */
250   modifier onlyOwner() {
251     require(msg.sender == owner);
252     _;
253   }
254 
255 
256   /**
257    * @dev Allows the current owner to transfer control of the contract to a newOwner.
258    * @param newOwner The address to transfer ownership to.
259    */
260   function transferOwnership(address newOwner) onlyOwner {
261     require(newOwner != address(0));
262     owner = newOwner;
263   }
264 
265 }
266 
267 // File: contracts/MintableToken.sol
268 
269 /**
270  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
271  *
272  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
273  */
274 
275 
276 
277 
278 
279 
280 pragma solidity ^0.4.6;
281 
282 /**
283  * A token that can increase its supply by another contract.
284  *
285  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
286  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
287  *
288  */
289 contract MintableToken is StandardTokenExt, Ownable {
290 
291   using SafeMathLib for uint;
292 
293   bool public mintingFinished = false;
294 
295   /** List of agents that are allowed to create new tokens */
296   mapping (address => bool) public mintAgents;
297 
298   event MintingAgentChanged(address addr, bool state);
299   event Minted(address receiver, uint amount);
300 
301   /**
302    * Create new tokens and allocate them to an address..
303    *
304    * Only callably by a crowdsale contract (mint agent).
305    */
306   function mint(address receiver, uint amount) onlyMintAgent canMint public {
307     totalSupply = totalSupply.plus(amount);
308     balances[receiver] = balances[receiver].plus(amount);
309 
310     // This will make the mint transaction apper in EtherScan.io
311     // We can remove this after there is a standardized minting event
312     Transfer(0, receiver, amount);
313   }
314 
315   /**
316    * Owner can allow a crowdsale contract to mint new tokens.
317    */
318   function setMintAgent(address addr, bool state) onlyOwner canMint public {
319     mintAgents[addr] = state;
320     MintingAgentChanged(addr, state);
321   }
322 
323   modifier onlyMintAgent() {
324     // Only crowdsale contracts are allowed to mint new tokens
325     if(!mintAgents[msg.sender]) {
326         throw;
327     }
328     _;
329   }
330 
331   /** Make sure we are not done yet. */
332   modifier canMint() {
333     if(mintingFinished) throw;
334     _;
335   }
336 }
337 
338 // File: contracts/ReleasableToken.sol
339 
340 /**
341  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
342  *
343  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
344  */
345 
346 pragma solidity ^0.4.8;
347 
348 
349 
350 
351 
352 /**
353  * Define interface for releasing the token transfer after a successful crowdsale.
354  */
355 contract ReleasableToken is ERC20, Ownable {
356 
357   /* The finalizer contract that allows unlift the transfer limits on this token */
358   address public releaseAgent;
359 
360   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
361   bool public released = false;
362 
363   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
364   mapping (address => bool) public transferAgents;
365 
366   /**
367    * Limit token transfer until the crowdsale is over.
368    *
369    */
370   modifier canTransfer(address _sender) {
371 
372     if(!released) {
373         if(!transferAgents[_sender]) {
374             throw;
375         }
376     }
377 
378     _;
379   }
380 
381   /**
382    * Set the contract that can call release and make the token transferable.
383    *
384    * Design choice. Allow reset the release agent to fix fat finger mistakes.
385    */
386   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
387 
388     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
389     releaseAgent = addr;
390   }
391 
392   /**
393    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
394    */
395   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
396     transferAgents[addr] = state;
397   }
398 
399   /**
400    * One way function to release the tokens to the wild.
401    *
402    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
403    */
404   function releaseTokenTransfer() public onlyReleaseAgent {
405     released = true;
406   }
407 
408   /** The function can be called only before or after the tokens have been releasesd */
409   modifier inReleaseState(bool releaseState) {
410     if(releaseState != released) {
411         throw;
412     }
413     _;
414   }
415 
416   /** The function can be called only by a whitelisted release agent. */
417   modifier onlyReleaseAgent() {
418     if(msg.sender != releaseAgent) {
419         throw;
420     }
421     _;
422   }
423 
424   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
425     // Call StandardToken.transfer()
426    return super.transfer(_to, _value);
427   }
428 
429   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
430     // Call StandardToken.transferForm()
431     return super.transferFrom(_from, _to, _value);
432   }
433 
434 }
435 
436 // File: contracts/UpgradeAgent.sol
437 
438 /**
439  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
440  *
441  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
442  */
443 
444 pragma solidity ^0.4.6;
445 
446 /**
447  * Upgrade agent interface inspired by Lunyr.
448  *
449  * Upgrade agent transfers tokens to a new contract.
450  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
451  */
452 contract UpgradeAgent {
453 
454   uint public originalSupply;
455 
456   /** Interface marker */
457   function isUpgradeAgent() public constant returns (bool) {
458     return true;
459   }
460 
461   function upgradeFrom(address _from, uint256 _value) public;
462 
463 }
464 
465 // File: contracts/UpgradeableToken.sol
466 
467 /**
468  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
469  *
470  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
471  */
472 
473 pragma solidity ^0.4.8;
474 
475 
476 
477 
478 
479 /**
480  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
481  *
482  * First envisioned by Golem and Lunyr projects.
483  */
484 contract UpgradeableToken is StandardTokenExt {
485 
486   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
487   address public upgradeMaster;
488 
489   /** The next contract where the tokens will be migrated. */
490   UpgradeAgent public upgradeAgent;
491 
492   /** How many tokens we have upgraded by now. */
493   uint256 public totalUpgraded;
494 
495   /**
496    * Upgrade states.
497    *
498    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
499    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
500    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
501    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
502    *
503    */
504   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
505 
506   /**
507    * Somebody has upgraded some of his tokens.
508    */
509   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
510 
511   /**
512    * New upgrade agent available.
513    */
514   event UpgradeAgentSet(address agent);
515 
516   /**
517    * Do not allow construction without upgrade master set.
518    */
519   function UpgradeableToken(address _upgradeMaster) {
520     upgradeMaster = _upgradeMaster;
521   }
522 
523   /**
524    * Allow the token holder to upgrade some of their tokens to a new contract.
525    */
526   function upgrade(uint256 value) public {
527 
528       UpgradeState state = getUpgradeState();
529       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
530         // Called in a bad state
531         throw;
532       }
533 
534       // Validate input value.
535       if (value == 0) throw;
536 
537       balances[msg.sender] = balances[msg.sender].sub(value);
538 
539       // Take tokens out from circulation
540       totalSupply = totalSupply.sub(value);
541       totalUpgraded = totalUpgraded.add(value);
542 
543       // Upgrade agent reissues the tokens
544       upgradeAgent.upgradeFrom(msg.sender, value);
545       Upgrade(msg.sender, upgradeAgent, value);
546   }
547 
548   /**
549    * Set an upgrade agent that handles
550    */
551   function setUpgradeAgent(address agent) external {
552 
553       if(!canUpgrade()) {
554         // The token is not yet in a state that we could think upgrading
555         throw;
556       }
557 
558       if (agent == 0x0) throw;
559       // Only a master can designate the next agent
560       if (msg.sender != upgradeMaster) throw;
561       // Upgrade has already begun for an agent
562       if (getUpgradeState() == UpgradeState.Upgrading) throw;
563 
564       upgradeAgent = UpgradeAgent(agent);
565 
566       // Bad interface
567       if(!upgradeAgent.isUpgradeAgent()) throw;
568       // Make sure that token supplies match in source and target
569       if (upgradeAgent.originalSupply() != totalSupply) throw;
570 
571       UpgradeAgentSet(upgradeAgent);
572   }
573 
574   /**
575    * Get the state of the token upgrade.
576    */
577   function getUpgradeState() public constant returns(UpgradeState) {
578     if(!canUpgrade()) return UpgradeState.NotAllowed;
579     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
580     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
581     else return UpgradeState.Upgrading;
582   }
583 
584   /**
585    * Change the upgrade master.
586    *
587    * This allows us to set a new owner for the upgrade mechanism.
588    */
589   function setUpgradeMaster(address master) public {
590       if (master == 0x0) throw;
591       if (msg.sender != upgradeMaster) throw;
592       upgradeMaster = master;
593   }
594 
595   /**
596    * Child contract can enable to provide the condition when the upgrade can begun.
597    */
598   function canUpgrade() public constant returns(bool) {
599      return true;
600   }
601 
602 }
603 
604 // File: contracts/CrowdsaleToken.sol
605 
606 /**
607  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
608  *
609  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
610  */
611 
612 pragma solidity ^0.4.8;
613 
614 
615 
616 
617 
618 
619 /**
620  * A crowdsaled token.
621  *
622  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
623  *
624  * - The token transfer() is disabled until the crowdsale is over
625  * - The token contract gives an opt-in upgrade path to a new contract
626  * - The same token can be part of several crowdsales through approve() mechanism
627  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
628  *
629  */
630 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
631 
632   /** Name and symbol were updated. */
633   event UpdatedTokenInformation(string newName, string newSymbol);
634 
635   string public name;
636 
637   string public symbol;
638 
639   uint public decimals;
640 
641   /**
642    * Construct the token.
643    *
644    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
645    *
646    * @param _name Token name
647    * @param _symbol Token symbol - should be all caps
648    * @param _initialSupply How many tokens we start with
649    * @param _decimals Number of decimal places
650    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
651    */
652   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
653     UpgradeableToken(msg.sender) {
654 
655     // Create any address, can be transferred
656     // to team multisig via changeOwner(),
657     // also remember to call setUpgradeMaster()
658     owner = msg.sender;
659 
660     name = _name;
661     symbol = _symbol;
662 
663     totalSupply = _initialSupply;
664 
665     decimals = _decimals;
666 
667     // Create initially all balance on the team multisig
668     balances[owner] = totalSupply;
669 
670     if(totalSupply > 0) {
671       Minted(owner, totalSupply);
672     }
673 
674     // No more new supply allowed after the token creation
675     if(!_mintable) {
676       mintingFinished = true;
677       if(totalSupply == 0) {
678         throw; // Cannot create a token without supply and no minting
679       }
680     }
681   }
682 
683   /**
684    * When token is released to be transferable, enforce no new tokens can be created.
685    */
686   function releaseTokenTransfer() public onlyReleaseAgent {
687     mintingFinished = true;
688     super.releaseTokenTransfer();
689   }
690 
691   /**
692    * Allow upgrade agent functionality kick in only if the crowdsale was success.
693    */
694   function canUpgrade() public constant returns(bool) {
695     return released && super.canUpgrade();
696   }
697 
698   /**
699    * Owner can update token information here.
700    *
701    * It is often useful to conceal the actual token association, until
702    * the token operations, like central issuance or reissuance have been completed.
703    *
704    * This function allows the token owner to rename the token after the operations
705    * have been completed and then point the audience to use the token contract.
706    */
707   function setTokenInformation(string _name, string _symbol) onlyOwner {
708     name = _name;
709     symbol = _symbol;
710 
711     UpdatedTokenInformation(name, symbol);
712   }
713 
714 }
715 
716 // File: contracts/CargoXToken.sol
717 
718 /**
719  * Copyright 2018 CargoX.io (https://cargox.io)
720  *
721  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
722  */
723  pragma solidity ^0.4.8;
724 
725 
726 
727 
728 /**
729  * A CargoX token.
730  *
731  */
732 contract CargoXToken is CrowdsaleToken {
733 
734   function CargoXToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
735     CrowdsaleToken(_name, _symbol, _initialSupply, _decimals, _mintable) {
736   }
737 
738 }