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
15 /**
16  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
17  *
18  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
19  */
20 
21 
22 
23 
24 
25 
26 
27 
28 /**
29  * @title ERC20Basic
30  * @dev Simpler version of ERC20 interface
31  * @dev see https://github.com/ethereum/EIPs/issues/179
32  */
33 contract ERC20Basic {
34   uint256 public totalSupply;
35   function balanceOf(address who) public view returns (uint256);
36   function transfer(address to, uint256 value) public returns (bool);
37   event Transfer(address indexed from, address indexed to, uint256 value);
38 }
39 
40 
41 
42 /**
43  * @title SafeMath
44  * @dev Math operations with safety checks that throw on error
45  */
46 library SafeMath {
47   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
48     if (a == 0) {
49       return 0;
50     }
51     uint256 c = a * b;
52     assert(c / a == b);
53     return c;
54   }
55 
56   function div(uint256 a, uint256 b) internal pure returns (uint256) {
57     // assert(b > 0); // Solidity automatically throws when dividing by 0
58     uint256 c = a / b;
59     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
60     return c;
61   }
62 
63   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
64     assert(b <= a);
65     return a - b;
66   }
67 
68   function add(uint256 a, uint256 b) internal pure returns (uint256) {
69     uint256 c = a + b;
70     assert(c >= a);
71     return c;
72   }
73 }
74 
75 
76 
77 /**
78  * @title Basic token
79  * @dev Basic version of StandardToken, with no allowances.
80  */
81 contract BasicToken is ERC20Basic {
82   using SafeMath for uint256;
83 
84   mapping(address => uint256) balances;
85 
86   /**
87   * @dev transfer token for a specified address
88   * @param _to The address to transfer to.
89   * @param _value The amount to be transferred.
90   */
91   function transfer(address _to, uint256 _value) public returns (bool) {
92     require(_to != address(0));
93     require(_value <= balances[msg.sender]);
94 
95     // SafeMath.sub will throw if there is not enough balance.
96     balances[msg.sender] = balances[msg.sender].sub(_value);
97     balances[_to] = balances[_to].add(_value);
98     Transfer(msg.sender, _to, _value);
99     return true;
100   }
101 
102   /**
103   * @dev Gets the balance of the specified address.
104   * @param _owner The address to query the the balance of.
105   * @return An uint256 representing the amount owned by the passed address.
106   */
107   function balanceOf(address _owner) public view returns (uint256 balance) {
108     return balances[_owner];
109   }
110 
111 }
112 
113 
114 
115 
116 
117 
118 /**
119  * @title ERC20 interface
120  * @dev see https://github.com/ethereum/EIPs/issues/20
121  */
122 contract ERC20 is ERC20Basic {
123   function allowance(address owner, address spender) public view returns (uint256);
124   function transferFrom(address from, address to, uint256 value) public returns (bool);
125   function approve(address spender, uint256 value) public returns (bool);
126   event Approval(address indexed owner, address indexed spender, uint256 value);
127 }
128 
129 
130 
131 /**
132  * @title Standard ERC20 token
133  *
134  * @dev Implementation of the basic standard token.
135  * @dev https://github.com/ethereum/EIPs/issues/20
136  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
137  */
138 contract StandardToken is ERC20, BasicToken {
139 
140   mapping (address => mapping (address => uint256)) internal allowed;
141 
142 
143   /**
144    * @dev Transfer tokens from one address to another
145    * @param _from address The address which you want to send tokens from
146    * @param _to address The address which you want to transfer to
147    * @param _value uint256 the amount of tokens to be transferred
148    */
149   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
150     require(_to != address(0));
151     require(_value <= balances[_from]);
152     require(_value <= allowed[_from][msg.sender]);
153 
154     balances[_from] = balances[_from].sub(_value);
155     balances[_to] = balances[_to].add(_value);
156     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
157     Transfer(_from, _to, _value);
158     return true;
159   }
160 
161   /**
162    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
163    *
164    * Beware that changing an allowance with this method brings the risk that someone may use both the old
165    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
166    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
167    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
168    * @param _spender The address which will spend the funds.
169    * @param _value The amount of tokens to be spent.
170    */
171   function approve(address _spender, uint256 _value) public returns (bool) {
172     allowed[msg.sender][_spender] = _value;
173     Approval(msg.sender, _spender, _value);
174     return true;
175   }
176 
177   /**
178    * @dev Function to check the amount of tokens that an owner allowed to a spender.
179    * @param _owner address The address which owns the funds.
180    * @param _spender address The address which will spend the funds.
181    * @return A uint256 specifying the amount of tokens still available for the spender.
182    */
183   function allowance(address _owner, address _spender) public view returns (uint256) {
184     return allowed[_owner][_spender];
185   }
186 
187   /**
188    * approve should be called when allowed[_spender] == 0. To increment
189    * allowed value is better to use this function to avoid 2 calls (and wait until
190    * the first transaction is mined)
191    * From MonolithDAO Token.sol
192    */
193   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
194     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
195     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
196     return true;
197   }
198 
199   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
200     uint oldValue = allowed[msg.sender][_spender];
201     if (_subtractedValue > oldValue) {
202       allowed[msg.sender][_spender] = 0;
203     } else {
204       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
205     }
206     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
207     return true;
208   }
209 
210 }
211 
212 
213 
214 /**
215  * Standard EIP-20 token with an interface marker.
216  *
217  * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.
218  *
219  */
220 contract StandardTokenExt is StandardToken {
221 
222   /* Interface declaration */
223   function isToken() public constant returns (bool weAre) {
224     return true;
225   }
226 }
227 
228 
229 contract BurnableToken is StandardTokenExt {
230 
231   // @notice An address for the transfer event where the burned tokens are transferred in a faux Transfer event
232   address public constant BURN_ADDRESS = 0;
233 
234   /** How many tokens we burned */
235   event Burned(address burner, uint burnedAmount);
236 
237   /**
238    * Burn extra tokens from a balance.
239    *
240    */
241   function burn(uint burnAmount) {
242     address burner = msg.sender;
243     balances[burner] = balances[burner].sub(burnAmount);
244     totalSupply = totalSupply.sub(burnAmount);
245     Burned(burner, burnAmount);
246 
247     // Inform the blockchain explores that track the
248     // balances only by a transfer event that the balance in this
249     // address has decreased
250     Transfer(burner, BURN_ADDRESS, burnAmount);
251   }
252 }
253 
254 /**
255  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
256  *
257  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
258  */
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
269 
270 /**
271  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
272  *
273  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
274  */
275 
276 
277 /**
278  * Upgrade agent interface inspired by Lunyr.
279  *
280  * Upgrade agent transfers tokens to a new contract.
281  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
282  */
283 contract UpgradeAgent {
284 
285   uint public originalSupply;
286 
287   /** Interface marker */
288   function isUpgradeAgent() public constant returns (bool) {
289     return true;
290   }
291 
292   function upgradeFrom(address _from, uint256 _value) public;
293 
294 }
295 
296 
297 /**
298  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
299  *
300  * First envisioned by Golem and Lunyr projects.
301  */
302 contract UpgradeableToken is StandardTokenExt {
303 
304   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
305   address public upgradeMaster;
306 
307   /** The next contract where the tokens will be migrated. */
308   UpgradeAgent public upgradeAgent;
309 
310   /** How many tokens we have upgraded by now. */
311   uint256 public totalUpgraded;
312 
313   /**
314    * Upgrade states.
315    *
316    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
317    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
318    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
319    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
320    *
321    */
322   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
323 
324   /**
325    * Somebody has upgraded some of his tokens.
326    */
327   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
328 
329   /**
330    * New upgrade agent available.
331    */
332   event UpgradeAgentSet(address agent);
333 
334   /**
335    * Do not allow construction without upgrade master set.
336    */
337   function UpgradeableToken(address _upgradeMaster) {
338     upgradeMaster = _upgradeMaster;
339   }
340 
341   /**
342    * Allow the token holder to upgrade some of their tokens to a new contract.
343    */
344   function upgrade(uint256 value) public {
345 
346       UpgradeState state = getUpgradeState();
347       if(!(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading)) {
348         // Called in a bad state
349         throw;
350       }
351 
352       // Validate input value.
353       if (value == 0) throw;
354 
355       balances[msg.sender] = balances[msg.sender].sub(value);
356 
357       // Take tokens out from circulation
358       totalSupply = totalSupply.sub(value);
359       totalUpgraded = totalUpgraded.add(value);
360 
361       // Upgrade agent reissues the tokens
362       upgradeAgent.upgradeFrom(msg.sender, value);
363       Upgrade(msg.sender, upgradeAgent, value);
364   }
365 
366   /**
367    * Set an upgrade agent that handles
368    */
369   function setUpgradeAgent(address agent) external {
370 
371       if(!canUpgrade()) {
372         // The token is not yet in a state that we could think upgrading
373         throw;
374       }
375 
376       if (agent == 0x0) throw;
377       // Only a master can designate the next agent
378       if (msg.sender != upgradeMaster) throw;
379       // Upgrade has already begun for an agent
380       if (getUpgradeState() == UpgradeState.Upgrading) throw;
381 
382       upgradeAgent = UpgradeAgent(agent);
383 
384       // Bad interface
385       if(!upgradeAgent.isUpgradeAgent()) throw;
386       // Make sure that token supplies match in source and target
387       if (upgradeAgent.originalSupply() != totalSupply) throw;
388 
389       UpgradeAgentSet(upgradeAgent);
390   }
391 
392   /**
393    * Get the state of the token upgrade.
394    */
395   function getUpgradeState() public constant returns(UpgradeState) {
396     if(!canUpgrade()) return UpgradeState.NotAllowed;
397     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
398     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
399     else return UpgradeState.Upgrading;
400   }
401 
402   /**
403    * Change the upgrade master.
404    *
405    * This allows us to set a new owner for the upgrade mechanism.
406    */
407   function setUpgradeMaster(address master) public {
408       if (master == 0x0) throw;
409       if (msg.sender != upgradeMaster) throw;
410       upgradeMaster = master;
411   }
412 
413   /**
414    * Child contract can enable to provide the condition when the upgrade can begun.
415    */
416   function canUpgrade() public constant returns(bool) {
417      return true;
418   }
419 
420 }
421 
422 /**
423  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
424  *
425  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
426  */
427 
428 
429 
430 
431 /**
432  * @title Ownable
433  * @dev The Ownable contract has an owner address, and provides basic authorization control
434  * functions, this simplifies the implementation of "user permissions".
435  */
436 contract Ownable {
437   address public owner;
438 
439 
440   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
441 
442 
443   /**
444    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
445    * account.
446    */
447   function Ownable() public {
448     owner = msg.sender;
449   }
450 
451 
452   /**
453    * @dev Throws if called by any account other than the owner.
454    */
455   modifier onlyOwner() {
456     require(msg.sender == owner);
457     _;
458   }
459 
460 
461   /**
462    * @dev Allows the current owner to transfer control of the contract to a newOwner.
463    * @param newOwner The address to transfer ownership to.
464    */
465   function transferOwnership(address newOwner) public onlyOwner {
466     require(newOwner != address(0));
467     OwnershipTransferred(owner, newOwner);
468     owner = newOwner;
469   }
470 
471 }
472 
473 
474 
475 
476 /**
477  * Define interface for releasing the token transfer after a successful crowdsale.
478  */
479 contract ReleasableToken is ERC20, Ownable {
480 
481   /* The finalizer contract that allows unlift the transfer limits on this token */
482   address public releaseAgent;
483 
484   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
485   bool public released = false;
486 
487   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
488   mapping (address => bool) public transferAgents;
489 
490   /**
491    * Limit token transfer until the crowdsale is over.
492    *
493    */
494   modifier canTransfer(address _sender) {
495 
496     if(!released) {
497         if(!transferAgents[_sender]) {
498             throw;
499         }
500     }
501 
502     _;
503   }
504 
505   /**
506    * Set the contract that can call release and make the token transferable.
507    *
508    * Design choice. Allow reset the release agent to fix fat finger mistakes.
509    */
510   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
511 
512     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
513     releaseAgent = addr;
514   }
515 
516   /**
517    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
518    */
519   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
520     transferAgents[addr] = state;
521   }
522 
523   /**
524    * One way function to release the tokens to the wild.
525    *
526    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
527    */
528   function releaseTokenTransfer() public onlyReleaseAgent {
529     released = true;
530   }
531 
532   /** The function can be called only before or after the tokens have been releasesd */
533   modifier inReleaseState(bool releaseState) {
534     if(releaseState != released) {
535         throw;
536     }
537     _;
538   }
539 
540   /** The function can be called only by a whitelisted release agent. */
541   modifier onlyReleaseAgent() {
542     if(msg.sender != releaseAgent) {
543         throw;
544     }
545     _;
546   }
547 
548   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
549     // Call StandardToken.transfer()
550    return super.transfer(_to, _value);
551   }
552 
553   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
554     // Call StandardToken.transferForm()
555     return super.transferFrom(_from, _to, _value);
556   }
557 
558 }
559 
560 /**
561  * This smart contract code is Copyright 2017 TokenMarket Ltd. For more information see https://tokenmarket.net
562  *
563  * Licensed under the Apache License, version 2.0: https://github.com/TokenMarketNet/ico/blob/master/LICENSE.txt
564  */
565 
566 
567 
568 
569 
570 /**
571  * Safe unsigned safe math.
572  *
573  * https://blog.aragon.one/library-driven-development-in-solidity-2bebcaf88736#.750gwtwli
574  *
575  * Originally from https://raw.githubusercontent.com/AragonOne/zeppelin-solidity/master/contracts/SafeMathLib.sol
576  *
577  * Maintained here until merged to mainline zeppelin-solidity.
578  *
579  */
580 library SafeMathLib {
581 
582   function times(uint a, uint b) returns (uint) {
583     uint c = a * b;
584     assert(a == 0 || c / a == b);
585     return c;
586   }
587 
588   function minus(uint a, uint b) returns (uint) {
589     assert(b <= a);
590     return a - b;
591   }
592 
593   function plus(uint a, uint b) returns (uint) {
594     uint c = a + b;
595     assert(c>=a);
596     return c;
597   }
598 
599 }
600 
601 
602 
603 /**
604  * A token that can increase its supply by another contract.
605  *
606  * This allows uncapped crowdsale by dynamically increasing the supply when money pours in.
607  * Only mint agents, contracts whitelisted by owner, can mint new tokens.
608  *
609  */
610 contract MintableToken is StandardTokenExt, Ownable {
611 
612   using SafeMathLib for uint;
613 
614   bool public mintingFinished = false;
615 
616   /** List of agents that are allowed to create new tokens */
617   mapping (address => bool) public mintAgents;
618 
619   event MintingAgentChanged(address addr, bool state);
620   event Minted(address receiver, uint amount);
621 
622   /**
623    * Create new tokens and allocate them to an address..
624    *
625    * Only callably by a crowdsale contract (mint agent).
626    */
627   function mint(address receiver, uint amount) onlyMintAgent canMint public {
628     totalSupply = totalSupply.plus(amount);
629     balances[receiver] = balances[receiver].plus(amount);
630 
631     // This will make the mint transaction apper in EtherScan.io
632     // We can remove this after there is a standardized minting event
633     Transfer(0, receiver, amount);
634   }
635 
636   /**
637    * Owner can allow a crowdsale contract to mint new tokens.
638    */
639   function setMintAgent(address addr, bool state) onlyOwner canMint public {
640     mintAgents[addr] = state;
641     MintingAgentChanged(addr, state);
642   }
643 
644   modifier onlyMintAgent() {
645     // Only crowdsale contracts are allowed to mint new tokens
646     if(!mintAgents[msg.sender]) {
647         throw;
648     }
649     _;
650   }
651 
652   /** Make sure we are not done yet. */
653   modifier canMint() {
654     if(mintingFinished) throw;
655     _;
656   }
657 }
658 
659 
660 
661 /**
662  * A crowdsaled token.
663  *
664  * An ERC-20 token designed specifically for crowdsales with investor protection and further development path.
665  *
666  * - The token transfer() is disabled until the crowdsale is over
667  * - The token contract gives an opt-in upgrade path to a new contract
668  * - The same token can be part of several crowdsales through approve() mechanism
669  * - The token can be capped (supply set in the constructor) or uncapped (crowdsale contract can mint new tokens)
670  *
671  */
672 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
673 
674   /** Name and symbol were updated. */
675   event UpdatedTokenInformation(string newName, string newSymbol);
676 
677   string public name;
678 
679   string public symbol;
680 
681   uint public decimals;
682 
683   /**
684    * Construct the token.
685    *
686    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
687    *
688    * @param _name Token name
689    * @param _symbol Token symbol - should be all caps
690    * @param _initialSupply How many tokens we start with
691    * @param _decimals Number of decimal places
692    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
693    */
694   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
695     UpgradeableToken(msg.sender) {
696 
697     // Create any address, can be transferred
698     // to team multisig via changeOwner(),
699     // also remember to call setUpgradeMaster()
700     owner = msg.sender;
701 
702     name = _name;
703     symbol = _symbol;
704 
705     totalSupply = _initialSupply;
706 
707     decimals = _decimals;
708 
709     // Create initially all balance on the team multisig
710     balances[owner] = totalSupply;
711 
712     if(totalSupply > 0) {
713       Minted(owner, totalSupply);
714     }
715 
716     // No more new supply allowed after the token creation
717     if(!_mintable) {
718       mintingFinished = true;
719       if(totalSupply == 0) {
720         throw; // Cannot create a token without supply and no minting
721       }
722     }
723   }
724 
725   /**
726    * When token is released to be transferable, enforce no new tokens can be created.
727    */
728   function releaseTokenTransfer() public onlyReleaseAgent {
729     mintingFinished = true;
730     super.releaseTokenTransfer();
731   }
732 
733   /**
734    * Allow upgrade agent functionality kick in only if the crowdsale was success.
735    */
736   function canUpgrade() public constant returns(bool) {
737     return released && super.canUpgrade();
738   }
739 
740   /**
741    * Owner can update token information here.
742    *
743    * It is often useful to conceal the actual token association, until
744    * the token operations, like central issuance or reissuance have been completed.
745    *
746    * This function allows the token owner to rename the token after the operations
747    * have been completed and then point the audience to use the token contract.
748    */
749   function setTokenInformation(string _name, string _symbol) onlyOwner {
750     name = _name;
751     symbol = _symbol;
752 
753     UpdatedTokenInformation(name, symbol);
754   }
755 
756 }
757 
758 
759 /**
760  * A crowdsaled token that you can also burn.
761  *
762  */
763 contract BurnableCrowdsaleToken is BurnableToken, CrowdsaleToken {
764 
765   function BurnableCrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
766     CrowdsaleToken(_name, _symbol, _initialSupply, _decimals, _mintable) {
767 
768   }
769 }