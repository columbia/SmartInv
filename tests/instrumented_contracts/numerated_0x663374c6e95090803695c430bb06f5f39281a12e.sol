1 pragma solidity ^0.4.18;
2 
3 
4 /**
5  * @title Ownable
6  * @dev The Ownable contract has an owner address, and provides basic authorization control
7  * functions, this simplifies the implementation of "user permissions".
8  */
9 contract Ownable {
10   address public owner;
11 
12 
13   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
14 
15 
16   /**
17    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
18    * account.
19    */
20   function Ownable() public {
21     owner = msg.sender;
22   }
23 
24 
25   /**
26    * @dev Throws if called by any account other than the owner.
27    */
28   modifier onlyOwner() {
29     require(msg.sender == owner);
30     _;
31   }
32 
33 
34   /**
35    * @dev Allows the current owner to transfer control of the contract to a newOwner.
36    * @param newOwner The address to transfer ownership to.
37    */
38   function transferOwnership(address newOwner) public onlyOwner {
39     require(newOwner != address(0));
40     OwnershipTransferred(owner, newOwner);
41     owner = newOwner;
42   }
43 
44 }
45 
46 
47 
48 /**
49  * @title ERC20Basic
50  * @dev Simpler version of ERC20 interface
51  * @dev see https://github.com/ethereum/EIPs/issues/179
52  */
53 contract ERC20Basic {
54   uint256 public totalSupply;
55   function balanceOf(address who) public view returns (uint256);
56   function transfer(address to, uint256 value) public returns (bool);
57   event Transfer(address indexed from, address indexed to, uint256 value);
58 }
59 /**
60  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
61  *
62  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
63  */
64 
65 
66 
67 
68 /**
69  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
70  *
71  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
72  */
73 
74 
75 
76 /**
77  * Safe unsigned safe math.
78  *
79  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
80  *
81  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
82  *
83  * Maintained here until merged to mainline zeppelin-solidity.
84  *
85  */
86 library SafeMathLib {
87 
88   function times(uint a, uint b) returns (uint) {
89     uint c = a * b;
90     assert(a == 0 || c / a == b);
91     return c;
92   }
93 
94   function minus(uint a, uint b) returns (uint) {
95     assert(b <= a);
96     return a - b;
97   }
98 
99   function plus(uint a, uint b) returns (uint) {
100     uint c = a + b;
101     assert(c>=a);
102     return c;
103   }
104 
105 }
106 
107 
108 
109 
110 /**
111  * @title SafeMath
112  * @dev Math operations with safety checks that throw on error
113  */
114 library SafeMath {
115   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
116     if (a == 0) {
117       return 0;
118     }
119     uint256 c = a * b;
120     assert(c / a == b);
121     return c;
122   }
123 
124   function div(uint256 a, uint256 b) internal pure returns (uint256) {
125     // assert(b > 0); // Solidity automatically throws when dividing by 0
126     uint256 c = a / b;
127     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
128     return c;
129   }
130 
131   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
132     assert(b <= a);
133     return a - b;
134   }
135 
136   function add(uint256 a, uint256 b) internal pure returns (uint256) {
137     uint256 c = a + b;
138     assert(c >= a);
139     return c;
140   }
141 }
142 
143 
144 
145 
146 
147 
148 
149 
150 /**
151  * @title ERC20 interface
152  * @dev see https://github.com/ethereum/EIPs/issues/20
153  */
154 contract ERC20 is ERC20Basic {
155   function allowance(address owner, address spender) public view returns (uint256);
156   function transferFrom(address from, address to, uint256 value) public returns (bool);
157   function approve(address spender, uint256 value) public returns (bool);
158   event Approval(address indexed owner, address indexed spender, uint256 value);
159 }
160 
161 
162 
163 
164 
165 
166 
167 
168 /**
169  * @title Basic token
170  * @dev Basic version of StandardToken, with no allowances.
171  */
172 contract BasicToken is ERC20Basic {
173   using SafeMath for uint256;
174 
175   mapping(address => uint256) balances;
176 
177   /**
178   * @dev transfer token for a specified address
179   * @param _to The address to transfer to.
180   * @param _value The amount to be transferred.
181   */
182   function transfer(address _to, uint256 _value) public returns (bool) {
183     require(_to != address(0));
184     require(_value <= balances[msg.sender]);
185 
186     // SafeMath.sub will throw if there is not enough balance.
187     balances[msg.sender] = balances[msg.sender].sub(_value);
188     balances[_to] = balances[_to].add(_value);
189     Transfer(msg.sender, _to, _value);
190     return true;
191   }
192 
193   /**
194   * @dev Gets the balance of the specified address.
195   * @param _owner The address to query the the balance of.
196   * @return An uint256 representing the amount owned by the passed address.
197   */
198   function balanceOf(address _owner) public view returns (uint256 balance) {
199     return balances[_owner];
200   }
201 
202 }
203 
204 
205 
206 
207 
208 
209 
210 
211 /**
212  * @title Standard ERC20 token
213  *
214  * @dev Implementation of the basic standard token.
215  * @dev https://github.com/ethereum/EIPs/issues/20
216  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
217  */
218 contract StandardToken is ERC20, BasicToken {
219 
220   mapping (address => mapping (address => uint256)) internal allowed;
221 
222 
223   /**
224    * @dev Transfer tokens from one address to another
225    * @param _from address The address which you want to send tokens from
226    * @param _to address The address which you want to transfer to
227    * @param _value uint256 the amount of tokens to be transferred
228    */
229   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
230     require(_to != address(0));
231     require(_value <= balances[_from]);
232     require(_value <= allowed[_from][msg.sender]);
233 
234     balances[_from] = balances[_from].sub(_value);
235     balances[_to] = balances[_to].add(_value);
236     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
237     Transfer(_from, _to, _value);
238     return true;
239   }
240 
241   /**
242    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
243    *
244    * Beware that changing an allowance with this method brings the risk that someone may use both the old
245    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
246    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
247    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
248    * @param _spender The address which will spend the funds.
249    * @param _value The amount of tokens to be spent.
250    */
251   function approve(address _spender, uint256 _value) public returns (bool) {
252     allowed[msg.sender][_spender] = _value;
253     Approval(msg.sender, _spender, _value);
254     return true;
255   }
256 
257   /**
258    * @dev Function to check the amount of tokens that an owner allowed to a spender.
259    * @param _owner address The address which owns the funds.
260    * @param _spender address The address which will spend the funds.
261    * @return A uint256 specifying the amount of tokens still available for the spender.
262    */
263   function allowance(address _owner, address _spender) public view returns (uint256) {
264     return allowed[_owner][_spender];
265   }
266 
267   /**
268    * approve should be called when allowed[_spender] == 0. To increment
269    * allowed value is better to use this function to avoid 2 calls (and wait until
270    * the first transaction is mined)
271    * From MonolithDAO Token.sol
272    */
273   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
274     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
275     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
276     return true;
277   }
278 
279   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
280     uint oldValue = allowed[msg.sender][_spender];
281     if (_subtractedValue > oldValue) {
282       allowed[msg.sender][_spender] = 0;
283     } else {
284       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
285     }
286     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
287     return true;
288   }
289 
290 }
291 
292 
293 /**
294  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
295  *
296  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
297  */
298 
299 
300 
301 
302 
303 
304 contract Recoverable is Ownable {
305 
306   /// @dev Empty constructor (for now)
307   function Recoverable() {
308   }
309 
310   /// @dev This will be invoked by the owner, when owner wants to rescue tokens
311   /// @param token Token which will we rescue to the owner from the contract
312   function recoverTokens(ERC20Basic token) onlyOwner public {
313     token.transfer(owner, tokensToBeReturned(token));
314   }
315 
316   /// @dev Interface function, can be overwritten by the superclass
317   /// @param token Token which balance we will check and return
318   /// @return The amount of tokens (in smallest denominator) the contract owns
319   function tokensToBeReturned(ERC20Basic token) public returns (uint) {
320     return token.balanceOf(this);
321   }
322 }
323 
324 /**
325  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
326  *
327  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
328  */
329 
330 
331 
332 
333 
334 
335 
336 /**
337  * Standard EIP-20 token with an interface marker.
338  *
339  * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.
340  *
341  */
342 contract StandardTokenExt is Recoverable, StandardToken {
343 
344   /* Interface declaration */
345   function isToken() public constant returns (bool weAre) {
346     return true;
347   }
348 }
349 
350 /**
351  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
352  *
353  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
354  */
355 
356 
357 
358 /**
359  * Upgrade agent interface inspired by Lunyr.
360  *
361  * Upgrade agent transfers tokens to a new contract.
362  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
363  */
364 contract UpgradeAgent {
365 
366   uint public originalSupply;
367 
368   /** Interface marker */
369   function isUpgradeAgent() public constant returns (bool) {
370     return true;
371   }
372 
373   function upgradeFrom(address _from, uint256 _value) public;
374 
375 }
376 
377 /**
378  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
379  *
380  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
381  */
382 
383 
384 
385 
386 
387 
388 
389 /**
390  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
391  *
392  * First envisioned by Golem and Lunyr projects.
393  */
394 contract UpgradeableToken is StandardTokenExt {
395 
396   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
397   address public upgradeMaster;
398 
399   /** The next contract where the tokens will be migrated. */
400   UpgradeAgent public upgradeAgent;
401 
402   /** How many tokens we have upgraded by now. */
403   uint256 public totalUpgraded;
404 
405   /**
406    * Upgrade states.
407    *
408    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
409    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
410    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
411    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
412    *
413    */
414   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
415 
416   /**
417    * Somebody has upgraded some of his tokens.
418    */
419   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
420 
421   /**
422    * New upgrade agent available.
423    */
424   event UpgradeAgentSet(address agent);
425 
426   /**
427    * Do not allow construction without upgrade master set.
428    */
429   function UpgradeableToken(address _upgradeMaster) {
430     upgradeMaster = _upgradeMaster;
431   }
432 
433   /**
434    * Allow the token holder to upgrade some of their tokens to a new contract.
435    */
436   function upgrade(uint256 value) public {
437 
438       UpgradeState state = getUpgradeState();
439       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
440         // Called in a bad state
441         throw;
442       }
443 
444       // Validate input value.
445       if (value == 0) throw;
446 
447       balances[msg.sender] = balances[msg.sender].sub(value);
448 
449       // Take tokens out from circulation
450       totalSupply = totalSupply.sub(value);
451       totalUpgraded = totalUpgraded.add(value);
452 
453       // Upgrade agent reissues the tokens
454       upgradeAgent.upgradeFrom(msg.sender, value);
455       Upgrade(msg.sender, upgradeAgent, value);
456   }
457 
458   /**
459    * Set an upgrade agent that handles
460    */
461   function setUpgradeAgent(address agent) external {
462 
463       if(!canUpgrade()) {
464         // The token is not yet in a state that we could think upgrading
465         throw;
466       }
467 
468       if (agent == 0x0) throw;
469       // Only a master can designate the next agent
470       if (msg.sender != upgradeMaster) throw;
471       // Upgrade has already begun for an agent
472       if (getUpgradeState() == UpgradeState.Upgrading) throw;
473 
474       upgradeAgent = UpgradeAgent(agent);
475 
476       // Bad interface
477       if(!upgradeAgent.isUpgradeAgent()) throw;
478       // Make sure that token supplies match in source and target
479       if (upgradeAgent.originalSupply() != totalSupply) throw;
480 
481       UpgradeAgentSet(upgradeAgent);
482   }
483 
484   /**
485    * Get the state of the token upgrade.
486    */
487   function getUpgradeState() public constant returns(UpgradeState) {
488     if(!canUpgrade()) return UpgradeState.NotAllowed;
489     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
490     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
491     else return UpgradeState.Upgrading;
492   }
493 
494   /**
495    * Change the upgrade master.
496    *
497    * This allows us to set a new owner for the upgrade mechanism.
498    */
499   function setUpgradeMaster(address master) public {
500       if (master == 0x0) throw;
501       if (msg.sender != upgradeMaster) throw;
502       upgradeMaster = master;
503   }
504 
505   /**
506    * Child contract can enable to provide the condition when the upgrade can begun.
507    */
508   function canUpgrade() public constant returns(bool) {
509      return true;
510   }
511 
512 }
513 
514 /**
515  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
516  *
517  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
518  */
519 
520 
521 
522 
523 
524 
525 /**
526  * Define interface for releasing the token transfer after a successful crowdsale.
527  */
528 contract ReleasableToken is StandardTokenExt {
529 
530   /* The finalizer contract that allows unlift the transfer limits on this token */
531   address public releaseAgent;
532 
533   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
534   bool public released = false;
535 
536   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
537   mapping (address => bool) public transferAgents;
538 
539   /**
540    * Limit token transfer until the crowdsale is over.
541    *
542    */
543   modifier canTransfer(address _sender) {
544 
545     if(!released) {
546         if(!transferAgents[_sender]) {
547             throw;
548         }
549     }
550 
551     _;
552   }
553 
554   /**
555    * Set the contract that can call release and make the token transferable.
556    *
557    * Design choice. Allow reset the release agent to fix fat finger mistakes.
558    */
559   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
560 
561     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
562     releaseAgent = addr;
563   }
564 
565   /**
566    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
567    */
568   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
569     transferAgents[addr] = state;
570   }
571 
572   /**
573    * One way function to release the tokens to the wild.
574    *
575    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
576    */
577   function releaseTokenTransfer() public onlyReleaseAgent {
578     released = true;
579   }
580 
581   /** The function can be called only before or after the tokens have been releasesd */
582   modifier inReleaseState(bool releaseState) {
583     if(releaseState != released) {
584         throw;
585     }
586     _;
587   }
588 
589   /** The function can be called only by a whitelisted release agent. */
590   modifier onlyReleaseAgent() {
591     if(msg.sender != releaseAgent) {
592         throw;
593     }
594     _;
595   }
596 
597   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
598     // Call StandardToken.transfer()
599    return super.transfer(_to, _value);
600   }
601 
602   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
603     // Call StandardToken.transferForm()
604     return super.transferFrom(_from, _to, _value);
605   }
606 
607 }
608 
609 /**
610  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
611  *
612  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
613  */
614 
615 
616 
617 
618 
619 
620 
621 /**
622  * A token that can increase its supply by another contract.
623  *
624  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
625  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
626  *
627  */
628 contract MintableToken is StandardTokenExt {
629 
630   using SafeMathLib for uint;
631 
632   bool public mintingFinished = false;
633 
634   /** List of agents that are allowed to create new tokens */
635   mapping (address => bool) public mintAgents;
636 
637   event MintingAgentChanged(address addr, bool state);
638   event Minted(address receiver, uint amount);
639 
640   /**
641    * Create new tokens and allocate them to an address..
642    *
643    * Only callably by a crowdsale contract (mint agent).
644    */
645   function mint(address receiver, uint amount) onlyMintAgent canMint public {
646     totalSupply = totalSupply.plus(amount);
647     balances[receiver] = balances[receiver].plus(amount);
648 
649     // This will make the mint transaction apper in EtherScan.io
650     // We can remove this after there is a standardized minting event
651     Transfer(0, receiver, amount);
652   }
653 
654   /**
655    * Owner can allow a crowdsale contract to mint new tokens.
656    */
657   function setMintAgent(address addr, bool state) onlyOwner canMint public {
658     mintAgents[addr] = state;
659     MintingAgentChanged(addr, state);
660   }
661 
662   modifier onlyMintAgent() {
663     // Only crowdsale contracts are allowed to mint new tokens
664     if(!mintAgents[msg.sender]) {
665         throw;
666     }
667     _;
668   }
669 
670   /** Make sure we are not done yet. */
671   modifier canMint() {
672     if(mintingFinished) throw;
673     _;
674   }
675 }
676 
677 
678 
679 /**
680  * A crowdsaled token.
681  *
682  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
683  *
684  * - The token transfer() is disabled until the crowdsale is over
685  * - The token contract gives an opt-in upgrade path to a new contract
686  * - The same token can be part of several crowdsales through approve() mechanism
687  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
688  *
689  */
690 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
691 
692   /** Name and symbol were updated. */
693   event UpdatedTokenInformation(string newName, string newSymbol);
694 
695   string public name;
696 
697   string public symbol;
698 
699   uint public decimals;
700 
701   /**
702    * Construct the token.
703    *
704    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
705    *
706    * @param _name Token name
707    * @param _symbol Token symbol - should be all caps
708    * @param _initialSupply How many tokens we start with
709    * @param _decimals Number of decimal places
710    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
711    */
712   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
713     UpgradeableToken(msg.sender) {
714 
715     // Create any address, can be transferred
716     // to team multisig via changeOwner(),
717     // also remember to call setUpgradeMaster()
718     owner = msg.sender;
719 
720     name = _name;
721     symbol = _symbol;
722 
723     totalSupply = _initialSupply;
724 
725     decimals = _decimals;
726 
727     // Create initially all balance on the team multisig
728     balances[owner] = totalSupply;
729 
730     if(totalSupply > 0) {
731       Minted(owner, totalSupply);
732     }
733 
734     // No more new supply allowed after the token creation
735     if(!_mintable) {
736       mintingFinished = true;
737       if(totalSupply == 0) {
738         throw; // Cannot create a token without supply and no minting
739       }
740     }
741   }
742 
743   /**
744    * When token is released to be transferable, enforce no new tokens can be created.
745    */
746   function releaseTokenTransfer() public onlyReleaseAgent {
747     mintingFinished = true;
748     super.releaseTokenTransfer();
749   }
750 
751   /**
752    * Allow upgrade agent functionality kick in only if the crowdsale was success.
753    */
754   function canUpgrade() public constant returns(bool) {
755     return released && super.canUpgrade();
756   }
757 
758   /**
759    * Owner can update token information here.
760    *
761    * It is often useful to conceal the actual token association, until
762    * the token operations, like central issuance or reissuance have been completed.
763    *
764    * This function allows the token owner to rename the token after the operations
765    * have been completed and then point the audience to use the token contract.
766    */
767   function setTokenInformation(string _name, string _symbol) onlyOwner {
768     name = _name;
769     symbol = _symbol;
770 
771     UpdatedTokenInformation(name, symbol);
772   }
773 
774 }