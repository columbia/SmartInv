1 /**
2  * @title ERC20Basic
3  * @dev Simpler version of ERC20 interface
4  * @dev see https://github.com/ethereum/EIPs/issues/179
5  */
6 contract ERC20Basic {
7   uint256 public totalSupply;
8   function balanceOf(address who) public view returns (uint256);
9   function transfer(address to, uint256 value) public returns (bool);
10   event Transfer(address indexed from, address indexed to, uint256 value);
11 }
12 
13 
14 
15 /**
16  * @title SafeMath
17  * @dev Math operations with safety checks that throw on error
18  */
19 library SafeMath {
20   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
21     if (a == 0) {
22       return 0;
23     }
24     uint256 c = a * b;
25     assert(c / a == b);
26     return c;
27   }
28 
29   function div(uint256 a, uint256 b) internal pure returns (uint256) {
30     // assert(b > 0); // Solidity automatically throws when dividing by 0
31     uint256 c = a / b;
32     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
33     return c;
34   }
35 
36   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
37     assert(b <= a);
38     return a - b;
39   }
40 
41   function add(uint256 a, uint256 b) internal pure returns (uint256) {
42     uint256 c = a + b;
43     assert(c >= a);
44     return c;
45   }
46 }
47 
48 
49 
50 /**
51  * @title Basic token
52  * @dev Basic version of StandardToken, with no allowances.
53  */
54 contract BasicToken is ERC20Basic {
55   using SafeMath for uint256;
56 
57   mapping(address => uint256) balances;
58 
59   /**
60   * @dev transfer token for a specified address
61   * @param _to The address to transfer to.
62   * @param _value The amount to be transferred.
63   */
64   function transfer(address _to, uint256 _value) public returns (bool) {
65     require(_to != address(0));
66     require(_value <= balances[msg.sender]);
67 
68     // SafeMath.sub will throw if there is not enough balance.
69     balances[msg.sender] = balances[msg.sender].sub(_value);
70     balances[_to] = balances[_to].add(_value);
71     Transfer(msg.sender, _to, _value);
72     return true;
73   }
74 
75   /**
76   * @dev Gets the balance of the specified address.
77   * @param _owner The address to query the the balance of.
78   * @return An uint256 representing the amount owned by the passed address.
79   */
80   function balanceOf(address _owner) public view returns (uint256 balance) {
81     return balances[_owner];
82   }
83 
84 }
85 
86 
87 
88 
89 
90 
91 /**
92  * @title ERC20 interface
93  * @dev see https://github.com/ethereum/EIPs/issues/20
94  */
95 contract ERC20 is ERC20Basic {
96   function allowance(address owner, address spender) public view returns (uint256);
97   function transferFrom(address from, address to, uint256 value) public returns (bool);
98   function approve(address spender, uint256 value) public returns (bool);
99   event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 
103 
104 /**
105  * @title Standard ERC20 token
106  *
107  * @dev Implementation of the basic standard token.
108  * @dev https://github.com/ethereum/EIPs/issues/20
109  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
110  */
111 contract StandardToken is ERC20, BasicToken {
112 
113   mapping (address => mapping (address => uint256)) internal allowed;
114 
115 
116   /**
117    * @dev Transfer tokens from one address to another
118    * @param _from address The address which you want to send tokens from
119    * @param _to address The address which you want to transfer to
120    * @param _value uint256 the amount of tokens to be transferred
121    */
122   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
123     require(_to != address(0));
124     require(_value <= balances[_from]);
125     require(_value <= allowed[_from][msg.sender]);
126 
127     balances[_from] = balances[_from].sub(_value);
128     balances[_to] = balances[_to].add(_value);
129     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
130     Transfer(_from, _to, _value);
131     return true;
132   }
133 
134   /**
135    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
136    *
137    * Beware that changing an allowance with this method brings the risk that someone may use both the old
138    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
139    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
140    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141    * @param _spender The address which will spend the funds.
142    * @param _value The amount of tokens to be spent.
143    */
144   function approve(address _spender, uint256 _value) public returns (bool) {
145     allowed[msg.sender][_spender] = _value;
146     Approval(msg.sender, _spender, _value);
147     return true;
148   }
149 
150   /**
151    * @dev Function to check the amount of tokens that an owner allowed to a spender.
152    * @param _owner address The address which owns the funds.
153    * @param _spender address The address which will spend the funds.
154    * @return A uint256 specifying the amount of tokens still available for the spender.
155    */
156   function allowance(address _owner, address _spender) public view returns (uint256) {
157     return allowed[_owner][_spender];
158   }
159 
160   /**
161    * approve should be called when allowed[_spender] == 0. To increment
162    * allowed value is better to use this function to avoid 2 calls (and wait until
163    * the first transaction is mined)
164    * From MonolithDAO Token.sol
165    */
166   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
167     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
168     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
169     return true;
170   }
171 
172   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
173     uint oldValue = allowed[msg.sender][_spender];
174     if (_subtractedValue > oldValue) {
175       allowed[msg.sender][_spender] = 0;
176     } else {
177       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
178     }
179     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
180     return true;
181   }
182 
183 }
184 
185 
186 
187 /**
188  * Standard EIP-20 token with an interface marker.
189  *
190  * @notice Interface marker is used by crowdsale contracts to validate that addresses point a good token contract.
191  *
192  */
193 contract StandardTokenExt is StandardToken {
194 
195   /* Interface declaration */
196   function isToken() public constant returns (bool weAre) {
197     return true;
198   }
199 }
200 
201 
202 contract BurnableToken is StandardTokenExt {
203 
204   // @notice An address for the transfer event where the burned tokens are transferred in a faux Transfer event
205   address public constant BURN_ADDRESS = 0;
206 
207   /** How many tokens we burned */
208   event Burned(address burner, uint burnedAmount);
209 
210   /**
211    * Burn extra tokens from a balance.
212    *
213    */
214   function burn(uint burnAmount) {
215     address burner = msg.sender;
216     balances[burner] = balances[burner].sub(burnAmount);
217     totalSupply = totalSupply.sub(burnAmount);
218     Burned(burner, burnAmount);
219 
220     // Inform the blockchain explores that track the
221     // balances only by a transfer event that the balance in this
222     // address has decreased
223     Transfer(burner, BURN_ADDRESS, burnAmount);
224   }
225 }
226 
227 
228 
229 
230 
231 
232 contract UpgradeAgent {
233 
234   uint public originalSupply;
235 
236   /** Interface marker */
237   function isUpgradeAgent() public constant returns (bool) {
238     return true;
239   }
240 
241   function upgradeFrom(address _from, uint256 _value) public;
242 
243 }
244 
245 
246 contract UpgradeableToken is StandardTokenExt {
247 
248   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
249   address public upgradeMaster;
250 
251   /** The next contract where the tokens will be migrated. */
252   UpgradeAgent public upgradeAgent;
253 
254   /** How many tokens we have upgraded by now. */
255   uint256 public totalUpgraded;
256 
257   /**
258    * Upgrade states.
259    *
260    * - NotAllowed: The child contract has not reached a condition where the upgrade can bgun
261    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
262    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
263    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
264    *
265    */
266   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
267 
268   /**
269    * Somebody has upgraded some of his tokens.
270    */
271   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
272 
273   /**
274    * New upgrade agent available.
275    */
276   event UpgradeAgentSet(address agent);
277 
278   /**
279    * Do not allow construction without upgrade master set.
280    */
281   function UpgradeableToken(address _upgradeMaster) {
282     upgradeMaster = _upgradeMaster;
283   }
284 
285   /**
286    * Allow the token holder to upgrade some of their tokens to a new contract.
287    */
288   function upgrade(uint256 value) public {
289 
290       UpgradeState state = getUpgradeState();
291       require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading); // Called in a bad state
292 
293       // Validate input value.
294       require(value != 0);
295 
296       balances[msg.sender] = balances[msg.sender].sub(value);
297 
298       // Take tokens out from circulation
299       totalSupply = totalSupply.sub(value);
300       totalUpgraded = totalUpgraded.add(value);
301 
302       // Upgrade agent reissues the tokens
303       upgradeAgent.upgradeFrom(msg.sender, value);
304       Upgrade(msg.sender, upgradeAgent, value);
305   }
306 
307   /**
308    * Set an upgrade agent that handles
309    */
310   function setUpgradeAgent(address agent) external {
311 
312       // The token is not yet in a state that we could think upgrading
313       require(canUpgrade());
314 
315       require(agent != 0x0);
316       // Only a master can designate the next agent
317       require(msg.sender == upgradeMaster);
318       // Upgrade has already begun for an agent
319       require(getUpgradeState() != UpgradeState.Upgrading);
320 
321       upgradeAgent = UpgradeAgent(agent);
322 
323       // Bad interface
324       require(upgradeAgent.isUpgradeAgent());
325       // Make sure that token supplies match in source and target
326       require(upgradeAgent.originalSupply() == totalSupply);
327 
328       UpgradeAgentSet(upgradeAgent);
329   }
330 
331   /**
332    * Get the state of the token upgrade.
333    */
334   function getUpgradeState() public constant returns(UpgradeState) {
335     if(!canUpgrade()) return UpgradeState.NotAllowed;
336     else if(address(upgradeAgent) == 0x00) return UpgradeState.WaitingForAgent;
337     else if(totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
338     else return UpgradeState.Upgrading;
339   }
340 
341   /**
342    * Change the upgrade master.
343    *
344    * This allows us to set a new owner for the upgrade mechanism.
345    */
346   function setUpgradeMaster(address master) public {
347       require(master != 0x0);
348       require(msg.sender == upgradeMaster);
349       upgradeMaster = master;
350   }
351 
352   /**
353    * Child contract can enable to provide the condition when the upgrade can begun.
354    */
355   function canUpgrade() public constant returns(bool) {
356      return true;
357   }
358 
359 }
360 
361 
362 
363 
364 /**
365  * @title Ownable
366  * @dev The Ownable contract has an owner address, and provides basic authorization control
367  * functions, this simplifies the implementation of "user permissions".
368  */
369 contract Ownable {
370   address public owner;
371 
372 
373   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
374 
375 
376   /**
377    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
378    * account.
379    */
380   function Ownable() public {
381     owner = msg.sender;
382   }
383 
384 
385   /**
386    * @dev Throws if called by any account other than the owner.
387    */
388   modifier onlyOwner() {
389     require(msg.sender == owner);
390     _;
391   }
392 
393 
394   /**
395    * @dev Allows the current owner to transfer control of the contract to a newOwner.
396    * @param newOwner The address to transfer ownership to.
397    */
398   function transferOwnership(address newOwner) public onlyOwner {
399     require(newOwner != address(0));
400     OwnershipTransferred(owner, newOwner);
401     owner = newOwner;
402   }
403 
404 }
405 
406 
407 
408 contract ReleasableToken is ERC20, Ownable {
409 
410   /* The finalizer contract that allows unlift the transfer limits on this token */
411   address public releaseAgent;
412 
413   /** A crowdsale contract can release us to the wild if ICO success. If false we are are in transfer lock up period.*/
414   bool public released = false;
415 
416   /** Map of agents that are allowed to transfer tokens regardless of the lock down period. These are crowdsale contracts and possible the team multisig itself. */
417   mapping (address => bool) public transferAgents;
418 
419   /**
420    * Limit token transfer until the crowdsale is over.
421    *
422    */
423   modifier canTransfer(address _sender) {
424     require(released || transferAgents[_sender]);
425     _;
426   }
427 
428   /**
429    * Set the contract that can call release and make the token transferable.
430    *
431    * Design choice. Allow reset the release agent to fix fat finger mistakes.
432    */
433   function setReleaseAgent(address addr) onlyOwner inReleaseState(false) public {
434 
435     // We don't do interface check here as we might want to a normal wallet address to act as a release agent
436     releaseAgent = addr;
437   }
438 
439   /**
440    * Owner can allow a particular address (a crowdsale contract) to transfer tokens despite the lock up period.
441    */
442   function setTransferAgent(address addr, bool state) onlyOwner inReleaseState(false) public {
443     transferAgents[addr] = state;
444   }
445 
446   /**
447    * One way function to release the tokens to the wild.
448    *
449    * Can be called only from the release agent that is the final ICO contract. It is only called if the crowdsale has been success (first milestone reached).
450    */
451   function releaseTokenTransfer() public onlyReleaseAgent {
452     released = true;
453   }
454 
455   /** The function can be called only before or after the tokens have been releasesd */
456   modifier inReleaseState(bool releaseState) {
457     require(releaseState == released);
458     _;
459   }
460 
461   /** The function can be called only by a whitelisted release agent. */
462   modifier onlyReleaseAgent() {
463     require(msg.sender == releaseAgent);
464     _;
465   }
466 
467   function transfer(address _to, uint _value) canTransfer(msg.sender) returns (bool success) {
468     // Call StandardToken.transfer()
469    return super.transfer(_to, _value);
470   }
471 
472   function transferFrom(address _from, address _to, uint _value) canTransfer(_from) returns (bool success) {
473     // Call StandardToken.transferForm()
474     return super.transferFrom(_from, _to, _value);
475   }
476 
477 }
478 
479 
480 
481 
482 
483 library SafeMathLib {
484 
485   function times(uint a, uint b) returns (uint) {
486     uint c = a * b;
487     assert(a == 0 || c / a == b);
488     return c;
489   }
490 
491   function minus(uint a, uint b) returns (uint) {
492     assert(b <= a);
493     return a - b;
494   }
495 
496   function plus(uint a, uint b) returns (uint) {
497     uint c = a + b;
498     assert(c>=a);
499     return c;
500   }
501 
502 }
503 
504 
505 
506 contract MintableToken is StandardTokenExt, Ownable {
507 
508   using SafeMathLib for uint;
509 
510   bool public mintingFinished = false;
511 
512   /** List of agents that are allowed to create new tokens */
513   mapping (address => bool) public mintAgents;
514 
515   event MintingAgentChanged(address addr, bool state);
516   event Minted(address receiver, uint amount);
517 
518   /**
519    * Create new tokens and allocate them to an address..
520    *
521    * Only callably by a crowdsale contract (mint agent).
522    */
523   function mint(address receiver, uint amount) onlyMintAgent canMint public {
524     totalSupply = totalSupply.plus(amount);
525     balances[receiver] = balances[receiver].plus(amount);
526 
527     // This will make the mint transaction apper in EtherScan.io
528     // We can remove this after there is a standardized minting event
529     Transfer(0, receiver, amount);
530   }
531 
532   /**
533    * Owner can allow a crowdsale contract to mint new tokens.
534    */
535   function setMintAgent(address addr, bool state) onlyOwner canMint public {
536     mintAgents[addr] = state;
537     MintingAgentChanged(addr, state);
538   }
539 
540   modifier onlyMintAgent() {
541     // Only crowdsale contracts are allowed to mint new tokens
542     require(mintAgents[msg.sender]);
543     _;
544   }
545 
546   /** Make sure we are not done yet. */
547   modifier canMint() {
548     require(!mintingFinished);
549     _;
550   }
551 }
552 
553 
554 contract CrowdsaleToken is ReleasableToken, MintableToken, UpgradeableToken {
555 
556   /** Name and symbol were updated. */
557   event UpdatedTokenInformation(string newName, string newSymbol);
558 
559   string public name;
560 
561   string public symbol;
562 
563   uint public decimals;
564 
565   /**
566    * Construct the token.
567    *
568    * This token must be created through a team multisig wallet, so that it is owned by that wallet.
569    *
570    * @param _name Token name
571    * @param _symbol Token symbol - should be all caps
572    * @param _initialSupply How many tokens we start with
573    * @param _decimals Number of decimal places
574    * @param _mintable Are new tokens created over the crowdsale or do we distribute only the initial supply? Note that when the token becomes transferable the minting always ends.
575    */
576   function CrowdsaleToken(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
577     UpgradeableToken(msg.sender) {
578 
579     // Cannot create a token without supply and no minting
580     require(_mintable || _initialSupply != 0);
581 
582     // Create any address, can be transferred
583     // to team multisig via changeOwner(),
584     // also remember to call setUpgradeMaster()
585     owner = msg.sender;
586 
587     name = _name;
588     symbol = _symbol;
589 
590     totalSupply = _initialSupply;
591 
592     decimals = _decimals;
593 
594     // Create initially all balance on the team multisig
595     balances[owner] = totalSupply;
596 
597     if(totalSupply > 0) {
598       Minted(owner, totalSupply);
599     }
600 
601     // No more new supply allowed after the token creation
602     if(!_mintable) {
603       mintingFinished = true;
604     }
605   }
606 
607   /**
608    * When token is released to be transferable, enforce no new tokens can be created.
609    */
610   function releaseTokenTransfer() public onlyReleaseAgent {
611     mintingFinished = true;
612     super.releaseTokenTransfer();
613   }
614 
615   /**
616    * Allow upgrade agent functionality kick in only if the crowdsale was success.
617    */
618   function canUpgrade() public constant returns(bool) {
619     return released && super.canUpgrade();
620   }
621 
622   /**
623    * Owner can update token information here.
624    *
625    * It is often useful to conceal the actual token association, until
626    * the token operations, like central issuance or reissuance have been completed.
627    *
628    * This function allows the token owner to rename the token after the operations
629    * have been completed and then point the audience to use the token contract.
630    */
631   function setTokenInformation(string _name, string _symbol) onlyOwner {
632     name = _name;
633     symbol = _symbol;
634 
635     UpdatedTokenInformation(name, symbol);
636   }
637 
638 }
639 
640 
641 /**
642  * A crowdsaled token that you can also burn.
643  *
644  */
645 contract AnyCoin is BurnableToken, CrowdsaleToken {
646 
647   function AnyCoin(string _name, string _symbol, uint _initialSupply, uint _decimals, bool _mintable)
648     CrowdsaleToken(_name, _symbol, _initialSupply, _decimals, _mintable) {
649 
650   }
651 }