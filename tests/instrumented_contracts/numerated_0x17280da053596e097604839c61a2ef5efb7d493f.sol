1 pragma solidity ^0.4.25;
2 
3 library SafeMath {
4 
5   /**
6   * @dev Multiplies two numbers, throws on overflow.
7   */
8   function mul(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
9     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
10     // benefit is lost if 'b' is also tested.
11     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
12     if (_a == 0) {
13       return 0;
14     }
15 
16     c = _a * _b;
17     require(c / _a == _b);
18     return c;
19   }
20 
21   /**
22   * @dev Integer division of two numbers, truncating the quotient.
23   */
24   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
25     // assert(_b > 0); // Solidity automatically throws when dividing by 0
26     // uint256 c = _a / _b;
27     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
28     return _a / _b;
29   }
30 
31   /**
32   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
33   */
34   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
35     require(_b <= _a);
36     return _a - _b;
37   }
38 
39   /**
40   * @dev Adds two numbers, throws on overflow.
41   */
42   function add(uint256 _a, uint256 _b) internal pure returns (uint256 c) {
43     c = _a + _b;
44     require(c >= _a);
45     return c;
46   }
47 }
48 
49 contract Ownable {
50   address public owner;
51 
52 
53   event OwnershipRenounced(address indexed previousOwner);
54   event OwnershipTransferred(
55     address indexed previousOwner,
56     address indexed newOwner
57   );
58 
59 
60   /**
61    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
62    * account.
63    */
64   constructor() public {
65     owner = msg.sender;
66   }
67 
68   /**
69    * @dev Throws if called by any account other than the owner.
70    */
71   modifier onlyOwner() {
72     require(msg.sender == owner);
73     _;
74   }
75 
76   /**
77    * @dev Allows the current owner to relinquish control of the contract.
78    * @notice Renouncing to ownership will leave the contract without an owner.
79    * It will not be possible to call the functions with the `onlyOwner`
80    * modifier anymore.
81    */
82   function renounceOwnership() public onlyOwner {
83     emit OwnershipRenounced(owner);
84     owner = address(0);
85   }
86 
87   /**
88    * @dev Allows the current owner to transfer control of the contract to a newOwner.
89    * @param _newOwner The address to transfer ownership to.
90    */
91   function transferOwnership(address _newOwner) public onlyOwner {
92     _transferOwnership(_newOwner);
93   }
94 
95   /**
96    * @dev Transfers control of the contract to a newOwner.
97    * @param _newOwner The address to transfer ownership to.
98    */
99   function _transferOwnership(address _newOwner) internal {
100     require(_newOwner != address(0));
101     emit OwnershipTransferred(owner, _newOwner);
102     owner = _newOwner;
103   }
104 }
105 
106 contract ERC20Basic {
107   function totalSupply() public view returns (uint256);
108   function balanceOf(address _who) public view returns (uint256);
109   function transfer(address _to, uint256 _value) public returns (bool);
110   event Transfer(address indexed from, address indexed to, uint256 value);
111 }
112 
113 contract BasicToken is ERC20Basic {
114   using SafeMath for uint256;
115 
116   mapping(address => uint256) internal balances;
117 
118   uint256 internal totalSupply_;
119 
120   /**
121   * @dev Total number of tokens in existence
122   */
123   function totalSupply() public view returns (uint256) {
124     return totalSupply_;
125   }
126 
127   /**
128   * @dev Transfer token for a specified address
129   * @param _to The address to transfer to.
130   * @param _value The amount to be transferred.
131   */
132   function transfer(address _to, uint256 _value) public returns (bool) {
133     require(_value <= balances[msg.sender]);
134     require(_to != address(0));
135 
136     balances[msg.sender] = balances[msg.sender].sub(_value);
137     balances[_to] = balances[_to].add(_value);
138     emit Transfer(msg.sender, _to, _value);
139     return true;
140   }
141 
142   /**
143   * @dev Gets the balance of the specified address.
144   * @param _owner The address to query the the balance of.
145   * @return An uint256 representing the amount owned by the passed address.
146   */
147   function balanceOf(address _owner) public view returns (uint256) {
148     return balances[_owner];
149   }
150 
151 }
152 
153 contract ERC20 is ERC20Basic {
154   function allowance(address _owner, address _spender)
155     public view returns (uint256);
156 
157   function transferFrom(address _from, address _to, uint256 _value)
158     public returns (bool);
159 
160   function approve(address _spender, uint256 _value) public returns (bool);
161   event Approval(
162     address indexed owner,
163     address indexed spender,
164     uint256 value
165   );
166 }
167 
168 contract StandardToken is ERC20, BasicToken {
169 
170   mapping (address => mapping (address => uint256)) internal allowed;
171 
172 
173   /**
174    * @dev Transfer tokens from one address to another
175    * @param _from address The address which you want to send tokens from
176    * @param _to address The address which you want to transfer to
177    * @param _value uint256 the amount of tokens to be transferred
178    */
179   function transferFrom(
180     address _from,
181     address _to,
182     uint256 _value
183   )
184     public
185     returns (bool)
186   {
187     require(_value <= balances[_from]);
188     require(_value <= allowed[_from][msg.sender]);
189     require(_to != address(0));
190 
191     balances[_from] = balances[_from].sub(_value);
192     balances[_to] = balances[_to].add(_value);
193     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
194     emit Transfer(_from, _to, _value);
195     return true;
196   }
197 
198   /**
199    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
200    * Beware that changing an allowance with this method brings the risk that someone may use both the old
201    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
202    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
203    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
204    * @param _spender The address which will spend the funds.
205    * @param _value The amount of tokens to be spent.
206    */
207   function approve(address _spender, uint256 _value) public returns (bool) {
208     allowed[msg.sender][_spender] = _value;
209     emit Approval(msg.sender, _spender, _value);
210     return true;
211   }
212 
213   /**
214    * @dev Function to check the amount of tokens that an owner allowed to a spender.
215    * @param _owner address The address which owns the funds.
216    * @param _spender address The address which will spend the funds.
217    * @return A uint256 specifying the amount of tokens still available for the spender.
218    */
219   function allowance(
220     address _owner,
221     address _spender
222    )
223     public
224     view
225     returns (uint256)
226   {
227     return allowed[_owner][_spender];
228   }
229 
230   /**
231    * @dev Increase the amount of tokens that an owner allowed to a spender.
232    * approve should be called when allowed[_spender] == 0. To increment
233    * allowed value is better to use this function to avoid 2 calls (and wait until
234    * the first transaction is mined)
235    * From MonolithDAO Token.sol
236    * @param _spender The address which will spend the funds.
237    * @param _addedValue The amount of tokens to increase the allowance by.
238    */
239   function increaseApproval(
240     address _spender,
241     uint256 _addedValue
242   )
243     public
244     returns (bool)
245   {
246     allowed[msg.sender][_spender] = (
247       allowed[msg.sender][_spender].add(_addedValue));
248     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
249     return true;
250   }
251 
252   /**
253    * @dev Decrease the amount of tokens that an owner allowed to a spender.
254    * approve should be called when allowed[_spender] == 0. To decrement
255    * allowed value is better to use this function to avoid 2 calls (and wait until
256    * the first transaction is mined)
257    * From MonolithDAO Token.sol
258    * @param _spender The address which will spend the funds.
259    * @param _subtractedValue The amount of tokens to decrease the allowance by.
260    */
261   function decreaseApproval(
262     address _spender,
263     uint256 _subtractedValue
264   )
265     public
266     returns (bool)
267   {
268     uint256 oldValue = allowed[msg.sender][_spender];
269     if (_subtractedValue >= oldValue) {
270       allowed[msg.sender][_spender] = 0;
271     } else {
272       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
273     }
274     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
275     return true;
276   }
277 
278 }
279 
280 contract MintableToken is StandardToken, Ownable {
281   event Mint(address indexed to, uint256 amount);
282   event MintFinished();
283 
284   bool public mintingFinished = false;
285 
286 
287   modifier canMint() {
288     require(!mintingFinished);
289     _;
290   }
291 
292   modifier hasMintPermission() {
293     require(msg.sender == owner);
294     _;
295   }
296 
297   /**
298    * @dev Function to mint tokens
299    * @param _to The address that will receive the minted tokens.
300    * @param _amount The amount of tokens to mint.
301    * @return A boolean that indicates if the operation was successful.
302    */
303   function mint(
304     address _to,
305     uint256 _amount
306   )
307     public
308     hasMintPermission
309     canMint
310     returns (bool)
311   {
312     totalSupply_ = totalSupply_.add(_amount);
313     balances[_to] = balances[_to].add(_amount);
314     emit Mint(_to, _amount);
315     emit Transfer(address(0), _to, _amount);
316     return true;
317   }
318 
319   /**
320    * @dev Function to stop minting new tokens.
321    * @return True if the operation was successful.
322    */
323   function finishMinting() public onlyOwner canMint returns (bool) {
324     mintingFinished = true;
325     emit MintFinished();
326     return true;
327   }
328 }
329 
330 contract ReleasableToken is ERC20, Ownable {
331 
332     /* The finalizer contract that allows unlift the transfer limits on this token */
333     address public releaseAgent;
334 
335     /** A crowdsale contract can release us to the wild if the sale is a success. If false we are are in transfer lock up period.*/
336     bool public released = false;
337 
338     /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
339     mapping(address => bool) public transferAgents;
340 
341     /**
342      * Limit token transfer until the crowdsale is over.
343      *
344      */
345     modifier canTransfer(address _sender) {
346         require(released || transferAgents[_sender], "For the token to be able to transfer: it's required that the crowdsale is in released state; or the sender is a transfer agent.");
347         _;
348     }
349 
350     /**
351      * Set the contract that can call release and make the token transferable.
352      *
353      * Design choice. Allow reset the release agent to fix fat finger mistakes.
354      */
355     function setReleaseAgent(address addr) public onlyOwner inReleaseState(false) {
356 
357         // We don't do interface check here as we might want to a normal wallet address to act as a release agent
358         releaseAgent = addr;
359     }
360 
361     /**
362      * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
363      */
364     function setTransferAgent(address addr, bool state) public onlyOwner inReleaseState(false) {
365         transferAgents[addr] = state;
366     }
367 
368     /**
369      * One way function to release the tokens to the wild.
370      *
371      * Can be called only from the release agent that is the final sale contract. It is only called if the crowdsale has been success (first milestone reached).
372      */
373     function releaseTokenTransfer() public onlyReleaseAgent {
374         released = true;
375     }
376 
377     /** The function can be called only before or after the tokens have been released */
378     modifier inReleaseState(bool releaseState) {
379         require(releaseState == released, "It's required that the state to check aligns with the released flag.");
380         _;
381     }
382 
383     /** The function can be called only by a whitelisted release agent. */
384     modifier onlyReleaseAgent() {
385         require(msg.sender == releaseAgent, "Message sender is required to be a release agent.");
386         _;
387     }
388 
389     function transfer(address _to, uint _value) public canTransfer(msg.sender) returns (bool success) {
390         // Call StandardToken.transfer()
391         return super.transfer(_to, _value);
392     }
393 
394     function transferFrom(address _from, address _to, uint _value) public canTransfer(_from) returns (bool success) {
395         // Call StandardToken.transferForm()
396         return super.transferFrom(_from, _to, _value);
397     }
398 
399 }
400 
401 contract UpgradeableToken is StandardToken {
402 
403     using SafeMath for uint256;
404 
405 
406     /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
407     address public upgradeMaster;
408 
409     /** The next contract where the tokens will be migrated. */
410     UpgradeAgent public upgradeAgent;
411 
412     /** How many tokens we have upgraded by now. */
413     uint256 public totalUpgraded;
414 
415     /**
416      * Upgrade states.
417      *
418      * - NotAllowed: The child contract has not reached a condition where the upgrade can begin
419      * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
420      * - ReadyToUpgrade: The agent is set and the balance holders can upgrade their tokens
421      *
422      */
423     enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade}
424 
425     /**
426      * Somebody has upgraded some of his tokens.
427      */
428     event Upgrade(address indexed _from, address indexed _to, uint256 _value);
429 
430     /**
431      * New upgrade agent available.
432      */
433     event UpgradeAgentSet(address agent);
434 
435     /**
436      * Do not allow construction without upgrade master set.
437      */
438     constructor(address _upgradeMaster) public {
439         upgradeMaster = _upgradeMaster;
440     }
441 
442     /**
443      * Allow the token holder to upgrade some of their tokens to a new contract.
444      */
445     function upgrade(uint256 value) public {
446 
447         UpgradeState state = getUpgradeState();
448 
449         require(state == UpgradeState.ReadyToUpgrade, "It's required that the upgrade state is ready.");
450 
451         // Validate input value.
452         require(value > 0, "The upgrade value is required to be above 0.");
453 
454         balances[msg.sender] = balances[msg.sender].sub(value);
455 
456         // Take tokens out from circulation
457         totalSupply_ = totalSupply_.sub(value);
458         totalUpgraded = totalUpgraded.add(value);
459 
460         // Upgrade agent reissues the tokens
461         upgradeAgent.upgradeFrom(msg.sender, value);
462         emit Upgrade(msg.sender, upgradeAgent, value);
463     }
464 
465     /**
466      * Set an upgrade agent that handles
467      */
468     function setUpgradeAgent(address agent) external {
469 
470         require(canUpgrade(), "It's required to be in canUpgrade() condition when setting upgrade agent.");
471 
472         require(agent != address(0), "Agent is required to be an non-empty address when setting upgrade agent.");
473 
474         // Only a master can designate the next agent
475         require(msg.sender == upgradeMaster, "Message sender is required to be the upgradeMaster when setting upgrade agent.");
476 
477         // Upgrade has already begun for an agent
478         require(getUpgradeState() != UpgradeState.ReadyToUpgrade, "Upgrade state is required to not be upgrading when setting upgrade agent.");
479 
480         require(address(upgradeAgent) == address(0), "upgradeAgent once set, cannot be reset");
481 
482         upgradeAgent = UpgradeAgent(agent);
483 
484         // Bad interface
485         require(upgradeAgent.isUpgradeAgent(), "The provided updateAgent contract is required to be compliant to the UpgradeAgent interface method when setting upgrade agent.");
486 
487         // Make sure that token supplies match in source and target
488         require(upgradeAgent.originalSupply() == totalSupply_, "The provided upgradeAgent contract's originalSupply is required to be equivalent to existing contract's totalSupply_ when setting upgrade agent.");
489 
490         emit UpgradeAgentSet(upgradeAgent);
491     }
492 
493     /**
494      * Get the state of the token upgrade.
495      */
496     function getUpgradeState() public view returns (UpgradeState) {
497         if (!canUpgrade()) return UpgradeState.NotAllowed;
498         else if (address(upgradeAgent) == address(0)) return UpgradeState.WaitingForAgent;
499         else return UpgradeState.ReadyToUpgrade;
500     }
501 
502     /**
503      * Change the upgrade master.
504      *
505      * This allows us to set a new owner for the upgrade mechanism.
506      */
507     function setUpgradeMaster(address master) public {
508         require(master != address(0), "The provided upgradeMaster is required to be a non-empty address when setting upgrade master.");
509 
510         require(msg.sender == upgradeMaster, "Message sender is required to be the original upgradeMaster when setting (new) upgrade master.");
511 
512         upgradeMaster = master;
513     }
514 
515     bool canUpgrade_ = true;
516 
517     /**
518      * Child contract can enable to provide the condition when the upgrade can begin.
519      */
520     function canUpgrade() public view returns (bool) {
521         return canUpgrade_;
522     }
523 }
524 
525 contract Jobchain is ReleasableToken, MintableToken, UpgradeableToken {
526 
527     event UpdatedTokenInformation(string newName, string newSymbol);
528 
529     string public name;
530 
531     string public symbol;
532 
533     uint8 public decimals;
534 
535     address public VerificationNodesWallet;
536     address public LaunchIncentiveWallet;
537     address public capitalReserveWallet;
538     address public ecosystemdevelopmentWallet;
539     address public InitialFundingWallet;
540 
541     /**
542      * Construct the token.
543      *
544      * This token must be created through a team multisig wallet, so that it is owned by that wallet.
545      *
546      * @param _name Token name
547      * @param _symbol Token symbol - should be all caps
548      * @param _initialSupply How many tokens we start with
549      * @param _decimals Number of decimal places
550      * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
551      */
552     constructor(string _name, string _symbol, uint256 _initialSupply, uint8 _decimals, bool _mintable,
553         address _VerificationNodesWallet,
554         address _LaunchIncentiveWallet,
555         address _capitalReserveWallet,
556         address _ecosystemdevelopmentWallet,
557         address _InitialFundingWallet)
558     public UpgradeableToken(msg.sender) {
559 
560         // Create any address, can be transferred
561         // to team multisig via changeOwner(),
562         // also remember to call setUpgradeMaster()
563         owner = msg.sender;
564         releaseAgent = owner;
565 
566         name = _name;
567         symbol = _symbol;
568 
569         decimals = _decimals;
570 
571         VerificationNodesWallet = _VerificationNodesWallet;
572         LaunchIncentiveWallet = _LaunchIncentiveWallet;
573         capitalReserveWallet = _capitalReserveWallet;
574         ecosystemdevelopmentWallet = _ecosystemdevelopmentWallet;
575         InitialFundingWallet = _InitialFundingWallet;
576 
577         if (_initialSupply > 0) {
578             require((_initialSupply % 10) == 0, "_initialSupply has to be a mulitple of 10");
579             uint256 twentyfivePerCent = _initialSupply.mul(25).div(100);
580             uint256 twentyPerCent = _initialSupply.mul(2).div(10);
581             uint256 tenPerCent = _initialSupply.div(10);
582 
583             mint(VerificationNodesWallet, twentyPerCent);
584 
585             mint(LaunchIncentiveWallet, twentyfivePerCent);
586 
587             mint(capitalReserveWallet, twentyfivePerCent);
588 
589             mint(ecosystemdevelopmentWallet, twentyPerCent);
590 
591             mint(InitialFundingWallet, tenPerCent);
592 
593         }
594 
595         // No more new supply allowed after the token creation
596         if (!_mintable) {
597             finishMinting();
598             require(totalSupply_ > 0, "Total supply is required to be above 0 if the token is not mintable.");
599         }
600 
601     }
602 
603     /**
604      * When token is released to be transferable, enforce no new tokens can be created.
605      */
606     function releaseTokenTransfer() public onlyReleaseAgent {
607         mintingFinished = true;
608         super.releaseTokenTransfer();
609     }
610 
611     /**
612      * Allow upgrade agent functionality kick in only if the crowdsale was success.
613      */
614     function canUpgrade() public view returns (bool) {
615         return released && super.canUpgrade();
616     }
617 
618     // Total supply
619     function totalSupply() public view returns (uint) {
620         return totalSupply_.sub(balances[address(0)]);
621     }
622 
623 }
624 
625 contract UpgradeAgent {
626 
627     uint public originalSupply;
628 
629     /** Interface marker */
630     function isUpgradeAgent() public pure returns (bool) {
631         return true;
632     }
633 
634     function upgradeFrom(address _from, uint256 _value) public;
635 
636 }