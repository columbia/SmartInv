1 pragma solidity ^0.4.23;
2 
3 /**
4  * @title Ownable
5  * @dev The Ownable contract has an owner address, and provides basic authorization control
6  * functions, this simplifies the implementation of "user permissions".
7  */
8 contract Ownable {
9   address public owner;
10 
11 
12   event OwnershipRenounced(address indexed previousOwner);
13   event OwnershipTransferred(
14     address indexed previousOwner,
15     address indexed newOwner
16   );
17 
18 
19   /**
20    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
21    * account.
22    */
23   constructor() public {
24     owner = msg.sender;
25   }
26 
27   /**
28    * @dev Throws if called by any account other than the owner.
29    */
30   modifier onlyOwner() {
31     require(msg.sender == owner);
32     _;
33   }
34 
35   /**
36    * @dev Allows the current owner to relinquish control of the contract.
37    */
38   function renounceOwnership() public onlyOwner {
39     emit OwnershipRenounced(owner);
40     owner = address(0);
41   }
42 
43   /**
44    * @dev Allows the current owner to transfer control of the contract to a newOwner.
45    * @param _newOwner The address to transfer ownership to.
46    */
47   function transferOwnership(address _newOwner) public onlyOwner {
48     _transferOwnership(_newOwner);
49   }
50 
51   /**
52    * @dev Transfers control of the contract to a newOwner.
53    * @param _newOwner The address to transfer ownership to.
54    */
55   function _transferOwnership(address _newOwner) internal {
56     require(_newOwner != address(0));
57     emit OwnershipTransferred(owner, _newOwner);
58     owner = _newOwner;
59   }
60 }
61 
62 /**
63  * @title Pausable
64  * @dev Base contract which allows children to implement an emergency stop mechanism.
65  */
66 contract Pausable is Ownable {
67   event Pause();
68   event Unpause();
69 
70   bool public paused = false;
71 
72 
73   /**
74    * @dev Modifier to make a function callable only when the contract is not paused.
75    */
76   modifier whenNotPaused() {
77     require(!paused);
78     _;
79   }
80 
81   /**
82    * @dev Modifier to make a function callable only when the contract is paused.
83    */
84   modifier whenPaused() {
85     require(paused);
86     _;
87   }
88 
89   /**
90    * @dev called by the owner to pause, triggers stopped state
91    */
92   function pause() onlyOwner whenNotPaused public {
93     paused = true;
94     emit Pause();
95   }
96 
97   /**
98    * @dev called by the owner to unpause, returns to normal state
99    */
100   function unpause() onlyOwner whenPaused public {
101     paused = false;
102     emit Unpause();
103   }
104 }
105 
106 /**
107  * @title ERC20Basic
108  * @dev Simpler version of ERC20 interface
109  * @dev see https://github.com/ethereum/EIPs/issues/179
110  */
111 contract ERC20Basic {
112   function totalSupply() public view returns (uint256);
113   function balanceOf(address who) public view returns (uint256);
114   function transfer(address to, uint256 value) public returns (bool);
115   event Transfer(address indexed from, address indexed to, uint256 value);
116 }
117 
118 /**
119  * @title ERC20 interface
120  * @dev see https://github.com/ethereum/EIPs/issues/20
121  */
122 contract ERC20 is ERC20Basic {
123   function allowance(address owner, address spender)
124     public view returns (uint256);
125 
126   function transferFrom(address from, address to, uint256 value)
127     public returns (bool);
128 
129   function approve(address spender, uint256 value) public returns (bool);
130   event Approval(
131     address indexed owner,
132     address indexed spender,
133     uint256 value
134   );
135 }
136 
137 /**
138  * @title DetailedERC20 token
139  * @dev The decimals are only for visualization purposes.
140  * All the operations are done using the smallest and indivisible token unit,
141  * just as on Ethereum all the operations are done in wei.
142  */
143 contract DetailedERC20 is ERC20 {
144   string public name;
145   string public symbol;
146   uint8 public decimals;
147 
148   constructor(string _name, string _symbol, uint8 _decimals) public {
149     name = _name;
150     symbol = _symbol;
151     decimals = _decimals;
152   }
153 }
154 
155 /**
156  * @title SafeMath
157  * @dev Math operations with safety checks that throw on error
158  */
159 library SafeMath {
160 
161   /**
162   * @dev Multiplies two numbers, throws on overflow.
163   */
164   function mul(uint256 a, uint256 b) internal pure returns (uint256 c) {
165     // Gas optimization: this is cheaper than asserting 'a' not being zero, but the
166     // benefit is lost if 'b' is also tested.
167     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
168     if (a == 0) {
169       return 0;
170     }
171 
172     c = a * b;
173     assert(c / a == b);
174     return c;
175   }
176 
177   /**
178   * @dev Integer division of two numbers, truncating the quotient.
179   */
180   function div(uint256 a, uint256 b) internal pure returns (uint256) {
181     // assert(b > 0); // Solidity automatically throws when dividing by 0
182     // uint256 c = a / b;
183     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
184     return a / b;
185   }
186 
187   /**
188   * @dev Subtracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
189   */
190   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
191     assert(b <= a);
192     return a - b;
193   }
194 
195   /**
196   * @dev Adds two numbers, throws on overflow.
197   */
198   function add(uint256 a, uint256 b) internal pure returns (uint256 c) {
199     c = a + b;
200     assert(c >= a);
201     return c;
202   }
203 }
204 
205 /**
206  * @title Basic token
207  * @dev Basic version of StandardToken, with no allowances.
208  */
209 contract BasicToken is ERC20Basic {
210   using SafeMath for uint256;
211 
212   mapping(address => uint256) balances;
213 
214   uint256 totalSupply_;
215 
216   /**
217   * @dev total number of tokens in existence
218   */
219   function totalSupply() public view returns (uint256) {
220     return totalSupply_;
221   }
222 
223   /**
224   * @dev transfer token for a specified address
225   * @param _to The address to transfer to.
226   * @param _value The amount to be transferred.
227   */
228   function transfer(address _to, uint256 _value) public returns (bool) {
229     require(_to != address(0));
230     require(_value <= balances[msg.sender]);
231 
232     balances[msg.sender] = balances[msg.sender].sub(_value);
233     balances[_to] = balances[_to].add(_value);
234     emit Transfer(msg.sender, _to, _value);
235     return true;
236   }
237 
238   /**
239   * @dev Gets the balance of the specified address.
240   * @param _owner The address to query the the balance of.
241   * @return An uint256 representing the amount owned by the passed address.
242   */
243   function balanceOf(address _owner) public view returns (uint256) {
244     return balances[_owner];
245   }
246 
247 }
248 
249 /**
250  * @title Burnable Token
251  * @dev Token that can be irreversibly burned (destroyed).
252  */
253 contract BurnableToken is BasicToken {
254 
255   event Burn(address indexed burner, uint256 value);
256 
257   /**
258    * @dev Burns a specific amount of tokens.
259    * @param _value The amount of token to be burned.
260    */
261   function burn(uint256 _value) public {
262     _burn(msg.sender, _value);
263   }
264 
265   function _burn(address _who, uint256 _value) internal {
266     require(_value <= balances[_who]);
267     // no need to require value <= totalSupply, since that would imply the
268     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
269 
270     balances[_who] = balances[_who].sub(_value);
271     totalSupply_ = totalSupply_.sub(_value);
272     emit Burn(_who, _value);
273     emit Transfer(_who, address(0), _value);
274   }
275 }
276 
277 contract BablosTokenInterface is ERC20 {
278   bool public frozen;
279   function burn(uint256 _value) public;
280   function setSale(address _sale) public;
281   function thaw() external;
282 }
283 
284 /**
285  * @title Standard ERC20 token
286  *
287  * @dev Implementation of the basic standard token.
288  * @dev https://github.com/ethereum/EIPs/issues/20
289  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
290  */
291 contract StandardToken is ERC20, BasicToken {
292 
293   mapping (address => mapping (address => uint256)) internal allowed;
294 
295 
296   /**
297    * @dev Transfer tokens from one address to another
298    * @param _from address The address which you want to send tokens from
299    * @param _to address The address which you want to transfer to
300    * @param _value uint256 the amount of tokens to be transferred
301    */
302   function transferFrom(
303     address _from,
304     address _to,
305     uint256 _value
306   )
307     public
308     returns (bool)
309   {
310     require(_to != address(0));
311     require(_value <= balances[_from]);
312     require(_value <= allowed[_from][msg.sender]);
313 
314     balances[_from] = balances[_from].sub(_value);
315     balances[_to] = balances[_to].add(_value);
316     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
317     emit Transfer(_from, _to, _value);
318     return true;
319   }
320 
321   /**
322    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
323    *
324    * Beware that changing an allowance with this method brings the risk that someone may use both the old
325    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
326    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
327    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
328    * @param _spender The address which will spend the funds.
329    * @param _value The amount of tokens to be spent.
330    */
331   function approve(address _spender, uint256 _value) public returns (bool) {
332     allowed[msg.sender][_spender] = _value;
333     emit Approval(msg.sender, _spender, _value);
334     return true;
335   }
336 
337   /**
338    * @dev Function to check the amount of tokens that an owner allowed to a spender.
339    * @param _owner address The address which owns the funds.
340    * @param _spender address The address which will spend the funds.
341    * @return A uint256 specifying the amount of tokens still available for the spender.
342    */
343   function allowance(
344     address _owner,
345     address _spender
346    )
347     public
348     view
349     returns (uint256)
350   {
351     return allowed[_owner][_spender];
352   }
353 
354   /**
355    * @dev Increase the amount of tokens that an owner allowed to a spender.
356    *
357    * approve should be called when allowed[_spender] == 0. To increment
358    * allowed value is better to use this function to avoid 2 calls (and wait until
359    * the first transaction is mined)
360    * From MonolithDAO Token.sol
361    * @param _spender The address which will spend the funds.
362    * @param _addedValue The amount of tokens to increase the allowance by.
363    */
364   function increaseApproval(
365     address _spender,
366     uint _addedValue
367   )
368     public
369     returns (bool)
370   {
371     allowed[msg.sender][_spender] = (
372       allowed[msg.sender][_spender].add(_addedValue));
373     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
374     return true;
375   }
376 
377   /**
378    * @dev Decrease the amount of tokens that an owner allowed to a spender.
379    *
380    * approve should be called when allowed[_spender] == 0. To decrement
381    * allowed value is better to use this function to avoid 2 calls (and wait until
382    * the first transaction is mined)
383    * From MonolithDAO Token.sol
384    * @param _spender The address which will spend the funds.
385    * @param _subtractedValue The amount of tokens to decrease the allowance by.
386    */
387   function decreaseApproval(
388     address _spender,
389     uint _subtractedValue
390   )
391     public
392     returns (bool)
393   {
394     uint oldValue = allowed[msg.sender][_spender];
395     if (_subtractedValue > oldValue) {
396       allowed[msg.sender][_spender] = 0;
397     } else {
398       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
399     }
400     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
401     return true;
402   }
403 
404 }
405 
406 contract DividendInterface {
407   function putProfit() public payable;
408   function dividendBalanceOf(address _account) public view returns (uint256);
409   function hasDividends() public view returns (bool);
410   function claimDividends() public returns (uint256);
411   function claimedDividendsOf(address _account) public view returns (uint256);
412   function saveUnclaimedDividends(address _account) public;
413 }
414 
415 contract BasicDividendToken is StandardToken, Ownable {
416   using SafeMath for uint256;
417 
418   DividendInterface public dividends;
419 
420   /**
421   * @dev set dividend contract
422   * @param _dividends The dividend contract address
423   */
424   function setDividends(DividendInterface _dividends) public onlyOwner {
425     dividends = _dividends;
426   }
427 
428   /**
429   * @dev transfer token for a specified address
430   * @param _to The address to transfer to.
431   * @param _value The amount to be transferred.
432   */
433   function transfer(address _to, uint256 _value) public returns (bool) {
434     require(_to != address(0));
435     require(_value <= balances[msg.sender]);
436 
437     if (dividends != address(0) && dividends.hasDividends()) {
438       dividends.saveUnclaimedDividends(msg.sender);
439       dividends.saveUnclaimedDividends(_to);
440     }
441 
442     return super.transfer(_to, _value);
443   }
444 
445   /**
446    * @dev Transfer tokens from one address to another
447    * @param _from address The address which you want to send tokens from
448    * @param _to address The address which you want to transfer to
449    * @param _value uint256 the amount of tokens to be transferred
450    */
451   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
452     require(_to != address(0));
453     require(_value <= balances[_from]);
454     require(_value <= allowed[_from][msg.sender]);
455 
456     if (dividends != address(0) && dividends.hasDividends()) {
457       dividends.saveUnclaimedDividends(_from);
458       dividends.saveUnclaimedDividends(_to);
459     }
460 
461     balances[_from] = balances[_from].sub(_value);
462     balances[_to] = balances[_to].add(_value);
463     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
464     emit Transfer(_from, _to, _value);
465     return true;
466   }
467 }
468 
469 /**
470  * Upgrade agent interface inspired by Lunyr.
471  *
472  * Upgrade agent transfers tokens to a new contract.
473  * Upgrade agent itself can be the token contract, or just a middle man contract doing the heavy lifting.
474  */
475 contract UpgradeAgent {
476 
477   uint256 public originalSupply;
478 
479   /** Interface marker */
480   function isUpgradeAgent() public pure returns (bool) {
481     return true;
482   }
483 
484   function upgradeFrom(address _from, uint256 _value) public;
485 }
486 
487 /**
488  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
489  *
490  * First envisioned by Golem and Lunyr projects.
491  */
492 contract UpgradeableToken is StandardToken {
493   using SafeMath for uint256;
494 
495   /** Contract / person who can set the upgrade path. This can be the same as team multisig wallet, as what it is with its default value. */
496   address public upgradeMaster;
497 
498   /** The next contract where the tokens will be migrated. */
499   UpgradeAgent public upgradeAgent;
500 
501   /** How many tokens we have upgraded by now. */
502   uint256 public totalUpgraded;
503 
504   /**
505    * Upgrade states.
506    *
507    * - NotAllowed: The child contract has not reached a condition where the upgrade can begun
508    * - WaitingForAgent: Token allows upgrade, but we don't have a new agent yet
509    * - ReadyToUpgrade: The agent is set, but not a single token has been upgraded yet
510    * - Upgrading: Upgrade agent is set and the balance holders can upgrade their tokens
511    *
512    */
513   enum UpgradeState {Unknown, NotAllowed, WaitingForAgent, ReadyToUpgrade, Upgrading}
514 
515   /**
516    * Somebody has upgraded some of his tokens.
517    */
518   event Upgrade(address indexed _from, address indexed _to, uint256 _value);
519 
520   /**
521    * New upgrade agent available.
522    */
523   event UpgradeAgentSet(address agent);
524 
525   /**
526    * Do not allow construction without upgrade master set.
527    */
528   constructor (address _upgradeMaster) public {
529     upgradeMaster = _upgradeMaster;
530   }
531 
532   /**
533    * Allow the token holder to upgrade some of their tokens to a new contract.
534    */
535   function upgrade(uint256 value) public {
536     require(value > 0);
537     require(balances[msg.sender] >= value);
538     UpgradeState state = getUpgradeState();
539     require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading);
540     
541     balances[msg.sender] = balances[msg.sender].sub(value);
542     // Take tokens out from circulation
543     totalSupply_ = totalSupply_.sub(value);
544     totalUpgraded = totalUpgraded.add(value);
545 
546     // Upgrade agent reissues the tokens
547     upgradeAgent.upgradeFrom(msg.sender, value);
548     emit Upgrade(msg.sender, upgradeAgent, value);
549   }
550 
551   /**
552    * Set an upgrade agent that handles
553    */
554   function setUpgradeAgent(address agent) external {
555     require(agent != address(0));
556     require(canUpgrade());
557     // Only a master can designate the next agent
558     require(msg.sender == upgradeMaster);
559     // Upgrade has already begun for an agent
560     require(getUpgradeState() != UpgradeState.Upgrading);
561 
562     upgradeAgent = UpgradeAgent(agent);
563 
564     // Bad interface
565     require(upgradeAgent.isUpgradeAgent());
566     // Make sure that token supplies match in source and target
567     require(upgradeAgent.originalSupply() == totalSupply_);
568 
569     emit UpgradeAgentSet(upgradeAgent);
570   }
571 
572   /**
573    * Get the state of the token upgrade.
574    */
575   function getUpgradeState() public view returns(UpgradeState) {
576     if (!canUpgrade()) {
577       return UpgradeState.NotAllowed;
578     } else if (upgradeAgent == address(0)) { 
579       return UpgradeState.WaitingForAgent; 
580     } else if (totalUpgraded == 0) {
581       return UpgradeState.ReadyToUpgrade;
582     }
583     return UpgradeState.Upgrading;
584   }
585 
586   /**
587    * Change the upgrade master.
588    *
589    * This allows us to set a new owner for the upgrade mechanism.
590    */
591   function setUpgradeMaster(address master) public {
592     require(master != address(0));
593     require(msg.sender == upgradeMaster);
594     upgradeMaster = master;
595   }
596 
597   /**
598    * Child contract can enable to provide the condition when the upgrade can begun.
599    */
600   function canUpgrade() public pure returns(bool) {
601     return true;
602   }
603 }
604 
605 contract BablosToken is BablosTokenInterface, BasicDividendToken, UpgradeableToken, DetailedERC20, BurnableToken, Pausable {
606   using SafeMath for uint256;
607 
608   /// @notice set of sale account which can freeze tokens
609   address public sale;
610 
611   /// @notice when true - all tokens are frozen and only sales or contract owner can move their tokens
612   ///         when false - all tokens are unfrozen and can be moved by their owners
613   bool public frozen = true;
614 
615   /// @dev makes transfer possible if tokens are unfrozen OR if the caller is a sale account
616   modifier saleOrUnfrozen() {
617     require((frozen == false) || msg.sender == sale || msg.sender == owner);
618     _;
619   }
620 
621   /// @dev allowance to call method only if the caller is a sale account
622   modifier onlySale() {
623     require(msg.sender == sale);
624     _;
625   }
626 
627   constructor(string _name, string _symbol, uint8 _decimals, uint256 _totalSupply) 
628       public 
629       UpgradeableToken(msg.sender)
630       DetailedERC20(_name, _symbol, _decimals) 
631   {
632     totalSupply_ = _totalSupply;
633     balances[msg.sender] = totalSupply_;
634   }
635 
636   /**
637   * @dev transfer token for a specified address
638   * @param _to The address to transfer to.
639   * @param _value The amount to be transferred.
640   */
641   function transfer(address _to, uint256 _value)
642       public 
643       whenNotPaused 
644       saleOrUnfrozen
645       returns (bool) 
646   {
647     super.transfer(_to, _value);
648   }
649 
650   /**
651    * @dev Transfer tokens from one address to another
652    * @param _from address The address which you want to send tokens from
653    * @param _to address The address which you want to transfer to
654    * @param _value uint256 the amount of tokens to be transferred
655    */
656   function transferFrom(address _from, address _to, uint256 _value)
657       public
658       whenNotPaused
659       saleOrUnfrozen
660       returns (bool) 
661   {
662     super.transferFrom(_from, _to, _value);
663   }
664 
665   function setSale(address _sale) public onlyOwner {
666     frozen = true;
667     sale = _sale;
668   }
669 
670   /// @notice Make transfer of tokens available to everyone
671   function thaw() external onlySale {
672     frozen = false;
673   }
674 }