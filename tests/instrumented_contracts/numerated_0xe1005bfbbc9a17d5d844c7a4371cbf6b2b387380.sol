1 /**
2   * Upgradeable ERC20 Contract of GRN and GRNGRID. 
3   * Follow the official https://t.me/grncommunity for more information.
4   */
5 pragma solidity ^0.4.26;
6 
7 library SafeMath {
8 
9   /**
10   * @dev Multiplies two numbers, throws on overflow.
11   */
12   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
13     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
14     // benefit is lost if 'b' is also tested.
15     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
16     if (_a == 0) {
17       return 0;
18     }
19 
20     c = _a * _b;
21     assert(c / _a == _b);
22     return c;
23   }
24 
25   /**
26   * @dev Integer division of two numbers, truncating the quotient.
27   */
28   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
29     // assert(_b > 0); // Solidity automatically throws when dividing by 0
30     // uint256 c = _a / _b;
31     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
32     return _a / _b;
33   }
34 
35   /**
36   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
37   */
38   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
39     assert(_b <= _a);
40     return _a - _b;
41   }
42 
43   /**
44   * @dev Adds two numbers, throws on overflow.
45   */
46   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
47     c = _a + _b;
48     assert(c >= _a);
49     return c;
50   }
51 }
52 
53 contract Ownable {
54   address public owner;
55 
56 
57   event OwnershipRenounced(address indexed previousOwner);
58   event OwnershipTransferred(
59     address indexed previousOwner,
60     address indexed newOwner
61   );
62 
63 
64   /**
65    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
66    * account.
67    */
68   constructor() public {
69     owner = msg.sender;
70   }
71 
72   /**
73    * @dev Throws if called by any account other than the owner.
74    */
75   modifier onlyOwner() {
76     require(msg.sender == owner);
77     _;
78   }
79 
80   /**
81    * @dev Allows the current owner to relinquish control of the contract.
82    * @notice Renouncing to ownership will leave the contract without an owner.
83    * It will not be possible to call the functions with the `onlyOwner`
84    * modifier anymore.
85    */
86   function renounceOwnership() public onlyOwner {
87     emit OwnershipRenounced(owner);
88     owner = address(0);
89   }
90 
91   /**
92    * @dev Allows the current owner to transfer control of the contract to a newOwner.
93    * @param _newOwner The address to transfer ownership to.
94    */
95   function transferOwnership(address _newOwner) public onlyOwner {
96     _transferOwnership(_newOwner);
97   }
98 
99   /**
100    * @dev Transfers control of the contract to a newOwner.
101    * @param _newOwner The address to transfer ownership to.
102    */
103   function _transferOwnership(address _newOwner) internal {
104     require(_newOwner != address(0));
105     emit OwnershipTransferred(owner, _newOwner);
106     owner = _newOwner;
107   }
108 }
109 
110 contract ERC20Basic {
111   function totalSupply() public view returns (uint256);
112   function balanceOf(address _who) public view returns (uint256);
113   function transfer(address _to, uint256 _value) public returns (bool);
114   event Transfer(address indexed from, address indexed to, uint256 value);
115 }
116 
117 contract BasicToken is ERC20Basic {
118   using SafeMath for uint256;
119 
120   mapping(address => uint256) internal balances;
121 
122   uint256 internal totalSupply_;
123 
124   /**
125   * @dev Total number of tokens in existence
126   */
127   function totalSupply() public view returns (uint256) {
128     return totalSupply_;
129   }
130 
131   /**
132   * @dev Transfer token for a specified address
133   * @param _to The address to transfer to.
134   * @param _value The amount to be transferred.
135   */
136   function transfer(address _to, uint256 _value) public returns (bool) {
137     require(_value <= balances[msg.sender]);
138     require(_to != address(0));
139 
140     balances[msg.sender] = balances[msg.sender].sub(_value);
141     balances[_to] = balances[_to].add(_value);
142     emit Transfer(msg.sender, _to, _value);
143     return true;
144   }
145 
146   /**
147   * @dev Gets the balance of the specified address.
148   * @param _owner The address to query the the balance of.
149   * @return An uint256 representing the amount owned by the passed address.
150   */
151   function balanceOf(address _owner) public view returns (uint256) {
152     return balances[_owner];
153   }
154 
155 }
156 
157 contract ERC20 is ERC20Basic {
158   function allowance(address _owner, address _spender)
159     public view returns (uint256);
160 
161   function transferFrom(address _from, address _to, uint256 _value)
162     public returns (bool);
163 
164   function approve(address _spender, uint256 _value) public returns (bool);
165   event Approval(
166     address indexed owner,
167     address indexed spender,
168     uint256 value
169   );
170 }
171 
172 contract StandardToken is ERC20, BasicToken {
173 
174   mapping (address => mapping (address => uint256)) internal allowed;
175 
176 
177   /**
178    * @dev Transfer tokens from one address to another
179    * @param _from address The address which you want to send tokens from
180    * @param _to address The address which you want to transfer to
181    * @param _value uint256 the amount of tokens to be transferred
182    */
183   function transferFrom(
184     address _from,
185     address _to,
186     uint256 _value
187   )
188     public
189     returns (bool)
190   {
191     require(_value <= balances[_from]);
192     require(_value <= allowed[_from][msg.sender]);
193     require(_to != address(0));
194 
195     balances[_from] = balances[_from].sub(_value);
196     balances[_to] = balances[_to].add(_value);
197     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
198     emit Transfer(_from, _to, _value);
199     return true;
200   }
201 
202   /**
203    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
204    * Beware that changing an allowance with this method brings the risk that someone may use both the old
205    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
206    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
207    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
208    * @param _spender The address which will spend the funds.
209    * @param _value The amount of tokens to be spent.
210    */
211   function approve(address _spender, uint256 _value) public returns (bool) {
212     allowed[msg.sender][_spender] = _value;
213     emit Approval(msg.sender, _spender, _value);
214     return true;
215   }
216 
217   /**
218    * @dev Function to check the amount of tokens that an owner allowed to a spender.
219    * @param _owner address The address which owns the funds.
220    * @param _spender address The address which will spend the funds.
221    * @return A uint256 specifying the amount of tokens still available for the spender.
222    */
223   function allowance(
224     address _owner,
225     address _spender
226    )
227     public
228     view
229     returns (uint256)
230   {
231     return allowed[_owner][_spender];
232   }
233 
234   /**
235    * @dev Increase the amount of tokens that an owner allowed to a spender.
236    * approve should be called when allowed[_spender] == 0. To increment
237    * allowed value is better to use this function to avoid 2 calls (and wait until
238    * the first transaction is mined)
239    * From MonolithDAO Token.sol
240    * @param _spender The address which will spend the funds.
241    * @param _addedValue The amount of tokens to increase the allowance by.
242    */
243   function increaseApproval(
244     address _spender,
245     uint256 _addedValue
246   )
247     public
248     returns (bool)
249   {
250     allowed[msg.sender][_spender] = (
251       allowed[msg.sender][_spender].add(_addedValue));
252     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
253     return true;
254   }
255 
256   /**
257    * @dev Decrease the amount of tokens that an owner allowed to a spender.
258    * approve should be called when allowed[_spender] == 0. To decrement
259    * allowed value is better to use this function to avoid 2 calls (and wait until
260    * the first transaction is mined)
261    * From MonolithDAO Token.sol
262    * @param _spender The address which will spend the funds.
263    * @param _subtractedValue The amount of tokens to decrease the allowance by.
264    */
265   function decreaseApproval(
266     address _spender,
267     uint256 _subtractedValue
268   )
269     public
270     returns (bool)
271   {
272     uint256 oldValue = allowed[msg.sender][_spender];
273     if (_subtractedValue >= oldValue) {
274       allowed[msg.sender][_spender] = 0;
275     } else {
276       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
277     }
278     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
279     return true;
280   }
281 
282 }
283 
284 contract MintableToken is StandardToken, Ownable {
285   event Mint(address indexed to, uint256 amount);
286   event MintFinished();
287 
288   bool public mintingFinished = false;
289 
290 
291   modifier canMint() {
292     require(!mintingFinished);
293     _;
294   }
295 
296   modifier hasMintPermission() {
297     require(msg.sender == owner);
298     _;
299   }
300 
301   /**
302    * @dev Function to mint tokens
303    * @param _to The address that will receive the minted tokens.
304    * @param _amount The amount of tokens to mint.
305    * @return A boolean that indicates if the operation was successful.
306    */
307   function mint(
308     address _to,
309     uint256 _amount
310   )
311     public
312     hasMintPermission
313     canMint
314     returns (bool)
315   {
316     totalSupply_ = totalSupply_.add(_amount);
317     balances[_to] = balances[_to].add(_amount);
318     emit Mint(_to, _amount);
319     emit Transfer(address(0), _to, _amount);
320     return true;
321   }
322 
323   /**
324    * @dev Function to stop minting new tokens.
325    * @return True if the operation was successful.
326    */
327   function finishMinting() public onlyOwner canMint returns (bool) {
328     mintingFinished = true;
329     emit MintFinished();
330     return true;
331   }
332 }
333 
334 contract ReleasableToken is ERC20, Ownable {
335 
336     /* The finalizer contract that allows unlift the transfer limits on this token */
337     address public releaseAgent;
338 
339     /** A crowdsale contract can release us to the wild if the sale is a success. If false we are are in transfer lock up period.*/
340     bool public released = false;
341 
342     /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
343     mapping(address => bool) public transferAgents;
344 
345     /**
346      * Limit token transfer until the crowdsale is over.
347      *
348      */
349     modifier canTransfer(address _sender) {
350         require(released || transferAgents[_sender], "For the token to be able to transfer: it's required that the crowdsale is in released state; or the sender is a transfer agent.");
351         _;
352     }
353 
354     /**
355      * Set the contract that can call release and make the token transferable.
356      *
357      * Design choice. Allow reset the release agent to fix fat finger mistakes.
358      */
359     function setReleaseAgent(address addr) public onlyOwner inReleaseState(false) {
360 
361         // We don't do interface check here as we might want to a normal wallet address to act as a release agent
362         releaseAgent = addr;
363     }
364 
365     /**
366      * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
367      */
368     function setTransferAgent(address addr, bool state) public onlyOwner inReleaseState(false) {
369         transferAgents[addr] = state;
370     }
371 
372     /**
373      * One way function to release the tokens to the wild.
374      *
375      * Can be called only from the release agent that is the final sale contract. It is only called if the crowdsale has been success (first milestone reached).
376      */
377     function releaseTokenTransfer() public onlyReleaseAgent {
378         released = true;
379     }
380 
381     /** The function can be called only before or after the tokens have been released */
382     modifier inReleaseState(bool releaseState) {
383         require(releaseState == released, "It's required that the state to check aligns with the released flag.");
384         _;
385     }
386 
387     /** The function can be called only by a whitelisted release agent. */
388     modifier onlyReleaseAgent() {
389         require(msg.sender == releaseAgent, "Message sender is required to be a release agent.");
390         _;
391     }
392 
393     function transfer(address _to, uint _value) public canTransfer(msg.sender) returns (bool success) {
394         // Call StandardToken.transfer()
395         return super.transfer(_to, _value);
396     }
397 
398     function transferFrom(address _from, address _to, uint _value) public canTransfer(_from) returns (bool success) {
399         // Call StandardToken.transferForm()
400         return super.transferFrom(_from, _to, _value);
401     }
402 
403 }
404 
405 contract UpgradeableToken is StandardToken {
406 
407     using SafeMath for uint256;
408 
409 
410     /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
411     address public upgradeMaster;
412 
413     /** The next contract where the tokens will be migrated. */
414     UpgradeAgent public upgradeAgent;
415 
416     /** How many tokens we have upgraded by now. */
417     uint256 public totalUpgraded;
418 
419     /**
420      * Upgrade states.
421      *
422      * - NotAllowed: The child contract has not reached a condition where the upgrade can begin
423      * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
424      * - ReadyToUpgrade: The agent is set and the balance holders can upgrade their tokens
425      *
426      */
427     enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade}
428 
429     /**
430      * Somebody has upgraded some of his tokens.
431      */
432     event Upgrade(address indexed _from, address indexed _to, uint256 _value);
433 
434     /**
435      * New upgrade agent available.
436      */
437     event UpgradeAgentSet(address agent);
438 
439     /**
440      * Do not allow construction without upgrade master set.
441      */
442     constructor(address _upgradeMaster) public {
443         upgradeMaster = _upgradeMaster;
444     }
445 
446     /**
447      * Allow the token holder to upgrade some of their tokens to a new contract.
448      */
449     function upgrade(uint256 value) public {
450 
451         UpgradeState state = getUpgradeState();
452 
453         require(state == UpgradeState.ReadyToUpgrade, "It's required that the upgrade state is ready.");
454 
455         // Validate input value.
456         require(value > 0, "The upgrade value is required to be above 0.");
457 
458         balances[msg.sender] = balances[msg.sender].sub(value);
459 
460         // Take tokens out from circulation
461         totalSupply_ = totalSupply_.sub(value);
462         totalUpgraded = totalUpgraded.add(value);
463 
464         // Upgrade agent reissues the tokens
465         upgradeAgent.upgradeFrom(msg.sender, value);
466         emit Upgrade(msg.sender, upgradeAgent, value);
467     }
468 
469     /**
470      * Set an upgrade agent that handles
471      */
472     function setUpgradeAgent(address agent) external {
473 
474         require(canUpgrade(), "It's required to be in canUpgrade() condition when setting upgrade agent.");
475 
476         require(agent != address(0), "Agent is required to be an non-empty address when setting upgrade agent.");
477 
478         // Only a master can designate the next agent
479         require(msg.sender == upgradeMaster, "Message sender is required to be the upgradeMaster when setting upgrade agent.");
480 
481         // Upgrade has already begun for an agent
482         require(getUpgradeState() != UpgradeState.ReadyToUpgrade, "Upgrade state is required to not be upgrading when setting upgrade agent.");
483 
484         require(address(upgradeAgent) == address(0), "upgradeAgent once set, cannot be reset");
485 
486         upgradeAgent = UpgradeAgent(agent);
487 
488         // Bad interface
489         require(upgradeAgent.isUpgradeAgent(), "The provided updateAgent contract is required to be compliant to the UpgradeAgent interface method when setting upgrade agent.");
490 
491         // Make sure that token supplies match in source and target
492         require(upgradeAgent.originalSupply() == totalSupply_, "The provided upgradeAgent contract's originalSupply is required to be equivalent to existing contract's totalSupply_ when setting upgrade agent.");
493 
494         emit UpgradeAgentSet(upgradeAgent);
495     }
496 
497     /**
498      * Get the state of the token upgrade.
499      */
500     function getUpgradeState() public view returns (UpgradeState) {
501         if (!canUpgrade()) return UpgradeState.NotAllowed;
502         else if (address(upgradeAgent) == address(0)) return UpgradeState.WaitingForAgent;
503         else return UpgradeState.ReadyToUpgrade;
504     }
505 
506     /**
507      * Change the upgrade master.
508      *
509      * This allows us to set a new owner for the upgrade mechanism.
510      */
511     function setUpgradeMaster(address master) public {
512         require(master != address(0), "The provided upgradeMaster is required to be a non-empty address when setting upgrade master.");
513 
514         require(msg.sender == upgradeMaster, "Message sender is required to be the original upgradeMaster when setting (new) upgrade master.");
515 
516         upgradeMaster = master;
517     }
518 
519     bool canUpgrade_ = true;
520 
521     /**
522      * Child contract can enable to provide the condition when the upgrade can begin.
523      */
524     function canUpgrade() public view returns (bool) {
525         return canUpgrade_;
526     }
527 
528 }
529 
530 contract GRN is ReleasableToken, MintableToken, UpgradeableToken {
531 
532     event UpdatedTokenInformation(string newName, string newSymbol);
533 
534     string public name;
535 
536     string public symbol;
537 
538     uint8 public decimals;
539 
540     address public preSaleReserveWallet;
541     address public gridValidatorWallet;
542     address public capitalReserveWallet;
543 
544     /**
545      * Construct the token.
546      *
547      * This token must be created through a team multisig wallet, so that it is owned by that wallet.
548      *
549      * @param _name Token name
550      * @param _symbol Token symbol - should be all caps
551      * @param _initialSupply How many tokens we start with
552      * @param _decimals Number of decimal places
553      * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
554      */
555     constructor(string _name, string _symbol, uint256 _initialSupply, uint8 _decimals, bool _mintable,
556         address _preSaleReserveWallet,
557         address _gridValidatorWallet,
558         address _capitalReserveWallet
559         )
560     public UpgradeableToken(msg.sender) {
561 
562         // Create any address, can be transferred
563         // to team multisig via changeOwner(),
564         // also remember to call setUpgradeMaster()
565         owner = msg.sender;
566         releaseAgent = owner;
567 
568         name = _name;
569         symbol = _symbol;
570 
571         decimals = _decimals;
572 
573         preSaleReserveWallet = _preSaleReserveWallet; //10% for presale
574         gridValidatorWallet = _gridValidatorWallet; //50% locked untill new blockchain
575         capitalReserveWallet = _capitalReserveWallet; //40% divided as the tokenomics suggest
576 
577 
578         if (_initialSupply > 0) {
579             require((_initialSupply % 100) == 0, "_initialSupply has to be a mulitple of 100");
580             uint256 fiftyPerCent = _initialSupply.mul(5).div(10);
581             uint256 fourtyPerCent = _initialSupply.mul(4).div(10);
582             uint256 tenPerCent = _initialSupply.div(10);
583 
584             mint(preSaleReserveWallet, tenPerCent);
585 
586             mint(gridValidatorWallet, fiftyPerCent);
587 
588             mint(capitalReserveWallet, fourtyPerCent);
589 
590         }
591 
592         // No more new supply allowed after the token creation
593         if (!_mintable) {
594             finishMinting();
595             require(totalSupply_ > 0, "Total supply is required to be above 0 if the token is not mintable.");
596         }
597 
598     }
599 
600     /**
601      * When token is released to be transferable, enforce no new tokens can be created.
602      */
603     function releaseTokenTransfer() public onlyReleaseAgent {
604         mintingFinished = true;
605         super.releaseTokenTransfer();
606     }
607 
608     /**
609      * Allow upgrade agent functionality kick in only if the crowdsale was success.
610      */
611     function canUpgrade() public view returns (bool) {
612         return released && super.canUpgrade();
613     }
614 
615     // Total supply
616     function totalSupply() public view returns (uint) {
617         return totalSupply_.sub(balances[address(0)]);
618     }
619 
620 }
621 
622 contract UpgradeAgent {
623 
624     uint public originalSupply;
625 
626     /** Interface marker */
627     function isUpgradeAgent() public pure returns (bool) {
628         return true;
629     }
630 
631     function upgradeFrom(address _from, uint256 _value) public;
632 
633 }