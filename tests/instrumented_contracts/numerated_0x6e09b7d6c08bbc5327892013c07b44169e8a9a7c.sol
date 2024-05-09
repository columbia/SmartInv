1 pragma solidity 0.4.24;
2 
3 
4 /**
5  * @title SafeMath
6  * @dev Math operations with safety checks that throw on error
7  */
8 library SafeMath {
9 
10   /**
11   * @dev Multiplies two numbers, throws on overflow.
12   */
13   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
14     if (a == 0) {
15       return 0;
16     }
17     uint256 c = a * b;
18     assert(c / a == b);
19     return c;
20   }
21 
22   /**
23   * @dev Integer division of two numbers, truncating the quotient.
24   */
25   function div(uint256 a, uint256 b) internal pure returns (uint256) {
26     // assert(b > 0); // Solidity automatically throws when dividing by 0
27     uint256 c = a / b;
28     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
29     return c;
30   }
31 
32   /**
33   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
34   */
35   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
36     assert(b <= a);
37     return a - b;
38   }
39 
40   /**
41   * @dev Adds two numbers, throws on overflow.
42   */
43   function add(uint256 a, uint256 b) internal pure returns (uint256) {
44     uint256 c = a + b;
45     assert(c >= a);
46     return c;
47   }
48 }
49 
50 
51 /**
52  * @title ERC20Basic
53  * @dev Simpler version of ERC20 interface
54  * @dev see https://github.com/ethereum/EIPs/issues/179
55  */
56 contract ERC20Basic {
57   function totalSupply() public view returns (uint256);
58   function balanceOf(address who) public view returns (uint256);
59   function transfer(address to, uint256 value) public returns (bool);
60   event Transfer(address indexed from, address indexed to, uint256 value);
61 }
62 
63 
64 /**
65  * @title Basic token
66  * @dev Basic version of StandardToken, with no allowances.
67  */
68 contract BasicToken is ERC20Basic {
69   using SafeMath for uint256;
70 
71   mapping(address => uint256) balances;
72 
73   uint256 totalSupply_;
74 
75   /**
76   * @dev total number of tokens in existence
77   */
78   function totalSupply() public view returns (uint256) {
79     return totalSupply_;
80   }
81 
82   /**
83   * @dev transfer token for a specified address
84   * @param _to The address to transfer to.
85   * @param _value The amount to be transferred.
86   */
87   function transfer(address _to, uint256 _value) public returns (bool) {
88     require(_to != address(0));
89     require(_value <= balances[msg.sender]);
90 
91     // SafeMath.sub will throw if there is not enough balance.
92     balances[msg.sender] = balances[msg.sender].sub(_value);
93     balances[_to] = balances[_to].add(_value);
94     emit Transfer(msg.sender, _to, _value);
95     return true;
96   }
97 
98   /**
99   * @dev Gets the balance of the specified address.
100   * @param _owner The address to query the the balance of.
101   * @return An uint256 representing the amount owned by the passed address.
102   */
103   function balanceOf(address _owner) public view returns (uint256 balance) {
104     return balances[_owner];
105   }
106 
107 }
108 
109 
110 /**
111  * @title Burnable Token
112  * @dev Token that can be irreversibly burned (destroyed).
113  */
114 contract BurnableToken is BasicToken {
115 
116   event Burn(address indexed burner, uint256 value);
117 
118   /**
119    * @dev Burns a specific amount of tokens.
120    * @param _value The amount of token to be burned.
121    */
122   function burn(uint256 _value) public {
123     require(_value <= balances[msg.sender]);
124     // no need to require value <= totalSupply, since that would imply the
125     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
126 
127     address burner = msg.sender;
128     balances[burner] = balances[burner].sub(_value);
129     totalSupply_ = totalSupply_.sub(_value);
130     emit Burn(burner, _value);
131   }
132 }
133 
134 
135 
136 
137 /**
138  * @title ERC20 interface
139  * @dev see https://github.com/ethereum/EIPs/issues/20
140  */
141 contract ERC20 is ERC20Basic {
142   function allowance(address owner, address spender) public view returns (uint256);
143   function transferFrom(address from, address to, uint256 value) public returns (bool);
144   function approve(address spender, uint256 value) public returns (bool);
145   event Approval(address indexed owner, address indexed spender, uint256 value);
146 }
147 
148 
149 
150 /**
151  * @title Standard ERC20 token
152  *
153  * @dev Implementation of the basic standard token.
154  * @dev https://github.com/ethereum/EIPs/issues/20
155  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
156  */
157 contract StandardToken is ERC20, BasicToken {
158 
159   mapping (address => mapping (address => uint256)) internal allowed;
160 
161 
162   /**
163    * @dev Transfer tokens from one address to another
164    * @param _from address The address which you want to send tokens from
165    * @param _to address The address which you want to transfer to
166    * @param _value uint256 the amount of tokens to be transferred
167    */
168   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
169     require(_to != address(0));
170     require(_value <= balances[_from]);
171     require(_value <= allowed[_from][msg.sender]);
172 
173     balances[_from] = balances[_from].sub(_value);
174     balances[_to] = balances[_to].add(_value);
175     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
176     emit Transfer(_from, _to, _value);
177     return true;
178   }
179 
180   /**
181    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
182    *
183    * Beware that changing an allowance with this method brings the risk that someone may use both the old
184    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
185    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
186    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
187    * @param _spender The address which will spend the funds.
188    * @param _value The amount of tokens to be spent.
189    */
190   function approve(address _spender, uint256 _value) public returns (bool) {
191     allowed[msg.sender][_spender] = _value;
192     emit Approval(msg.sender, _spender, _value);
193     return true;
194   }
195 
196   /**
197    * @dev Function to check the amount of tokens that an owner allowed to a spender.
198    * @param _owner address The address which owns the funds.
199    * @param _spender address The address which will spend the funds.
200    * @return A uint256 specifying the amount of tokens still available for the spender.
201    */
202   function allowance(address _owner, address _spender) public view returns (uint256) {
203     return allowed[_owner][_spender];
204   }
205 
206   /**
207    * @dev Increase the amount of tokens that an owner allowed to a spender.
208    *
209    * approve should be called when allowed[_spender] == 0. To increment
210    * allowed value is better to use this function to avoid 2 calls (and wait until
211    * the first transaction is mined)
212    * From MonolithDAO Token.sol
213    * @param _spender The address which will spend the funds.
214    * @param _addedValue The amount of tokens to increase the allowance by.
215    */
216   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
217     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
218     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
219     return true;
220   }
221 
222   /**
223    * @dev Decrease the amount of tokens that an owner allowed to a spender.
224    *
225    * approve should be called when allowed[_spender] == 0. To decrement
226    * allowed value is better to use this function to avoid 2 calls (and wait until
227    * the first transaction is mined)
228    * From MonolithDAO Token.sol
229    * @param _spender The address which will spend the funds.
230    * @param _subtractedValue The amount of tokens to decrease the allowance by.
231    */
232   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
233     uint oldValue = allowed[msg.sender][_spender];
234     if (_subtractedValue > oldValue) {
235       allowed[msg.sender][_spender] = 0;
236     } else {
237       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
238     }
239     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
240     return true;
241   }
242 
243 }
244 
245 
246 
247 /**
248  * @title Ownable
249  * @dev The Ownable contract has an owner address, and provides basic authorization control
250  * functions, this simplifies the implementation of "user permissions".
251  */
252 contract Ownable {
253   address public owner;
254 
255 
256   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
257 
258 
259   /**
260    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
261    * account.
262    */
263   constructor() public {
264     owner = msg.sender;
265   }
266 
267   /**
268    * @dev Throws if called by any account other than the owner.
269    */
270   modifier onlyOwner() {
271     require(msg.sender == owner);
272     _;
273   }
274 
275   /**
276    * @dev Allows the current owner to transfer control of the contract to a newOwner.
277    * @param newOwner The address to transfer ownership to.
278    */
279   function transferOwnership(address newOwner) public onlyOwner {
280     require(newOwner != address(0));
281     emit OwnershipTransferred(owner, newOwner);
282     owner = newOwner;
283   }
284 
285 }
286 
287 
288 /**
289  * @title Pausable
290  * @dev Base contract which allows children to implement an emergency stop mechanism.
291  */
292 contract Pausable is Ownable {
293   event Pause();
294   event Unpause();
295 
296   bool public paused = false;
297 
298 
299   /**
300    * @dev Modifier to make a function callable only when the contract is not paused.
301    */
302   modifier whenNotPaused() {
303     require(!paused);
304     _;
305   }
306 
307   /**
308    * @dev Modifier to make a function callable only when the contract is paused.
309    */
310   modifier whenPaused() {
311     require(paused);
312     _;
313   }
314 
315   /**
316    * @dev called by the owner to pause, triggers stopped state
317    */
318   function pause() onlyOwner whenNotPaused public {
319     paused = true;
320     emit Pause();
321   }
322 
323   /**
324    * @dev called by the owner to unpause, returns to normal state
325    */
326   function unpause() onlyOwner whenPaused public {
327     paused = false;
328     emit Unpause();
329   }
330 }
331 
332 
333 /**
334  * @title Pausable token
335  * @dev StandardToken modified with pausable transfers.
336  **/
337 contract PausableToken is StandardToken, Pausable {
338 
339   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
340     return super.transfer(_to, _value);
341   }
342 
343   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
344     return super.transferFrom(_from, _to, _value);
345   }
346 
347   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
348     return super.approve(_spender, _value);
349   }
350 
351   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
352     return super.increaseApproval(_spender, _addedValue);
353   }
354 
355   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
356     return super.decreaseApproval(_spender, _subtractedValue);
357   }
358 }
359 
360 
361 contract MintableAndPausableToken is PausableToken {
362     uint8 public constant decimals = 18;
363     uint256 public maxTokenSupply = 2000000000 * 10 ** uint256(decimals);
364 
365     bool public mintingFinished = false;
366     
367     event Mint(address indexed to, uint256 amount);
368     event MintFinished();
369     event MintStarted();
370 
371     modifier canMint() {
372         require(!mintingFinished);
373         _;
374     }
375 
376     modifier checkMaxSupply(uint256 _amount) {
377         require(maxTokenSupply >= totalSupply_.add(_amount));
378         _;
379     }
380 
381     modifier cannotMint() {
382         require(mintingFinished);
383         _;
384     }
385 
386     function mint(address _to, uint256 _amount)
387         external
388         onlyOwner
389         canMint
390         checkMaxSupply (_amount)
391         whenNotPaused
392         returns (bool)
393     {
394         totalSupply_ = totalSupply_.add(_amount);
395         balances[_to] = balances[_to].add(_amount);
396         emit Mint(_to, _amount);
397         emit Transfer(address(0), _to, _amount);
398         return true;
399     }
400 
401     function finishMinting() external onlyOwner canMint returns (bool) {
402         mintingFinished = true;
403         emit MintFinished();
404         return true;
405     }
406 
407     function startMinting() external onlyOwner cannotMint returns (bool) {
408         mintingFinished = false;
409         emit MintStarted();
410         return true;
411     }
412 }
413 
414 
415 /**
416  * Token upgrader interface inspired by Lunyr.
417  *
418  * Token upgrader transfers previous version tokens to a newer version.
419  * Token upgrader itself can be the token contract, or just a middle man contract doing the heavy lifting.
420  */
421 contract TokenUpgrader {
422     uint public originalSupply;
423 
424     /** Interface marker */
425     function isTokenUpgrader() external pure returns (bool) {
426         return true;
427     }
428 
429     function upgradeFrom(address _from, uint256 _value) public {}
430 }
431 
432 
433 /**
434  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
435  *
436  * First envisioned by Golem and Lunyr projects.
437  */
438 
439 
440 contract UpgradeableToken is MintableAndPausableToken {
441     // Contract or person who can set the upgrade path.
442     address public upgradeMaster;
443     
444     // Bollean value needs to be true to start upgrades
445     bool private upgradesAllowed;
446 
447     // The next contract where the tokens will be migrated.
448     TokenUpgrader public tokenUpgrader;
449 
450     // How many tokens we have upgraded by now.
451     uint public totalUpgraded;
452 
453     /**
454     * Upgrade states.
455     * - NotAllowed: The child contract has not reached a condition where the upgrade can begin
456     * - Waiting: Token allows upgrade, but we don't have a new token version
457     * - ReadyToUpgrade: The token version is set, but not a single token has been upgraded yet
458     * - Upgrading: Token upgrader is set and the balance holders can upgrade their tokens
459     */
460     enum UpgradeState { NotAllowed, Waiting, ReadyToUpgrade, Upgrading }
461 
462     // Somebody has upgraded some of his tokens.
463     event Upgrade(address indexed _from, address indexed _to, uint256 _value);
464 
465     // New token version available.
466     event TokenUpgraderIsSet(address _newToken);
467 
468     modifier onlyUpgradeMaster {
469         // Only a master can designate the next token
470         require(msg.sender == upgradeMaster);
471         _;
472     }
473 
474     modifier notInUpgradingState {
475         // Upgrade has already begun for token
476         require(getUpgradeState() != UpgradeState.Upgrading);
477         _;
478     }
479 
480     // Do not allow construction without upgrade master set.
481     constructor(address _upgradeMaster) public {
482         upgradeMaster = _upgradeMaster;
483     }
484 
485     // set a token upgrader
486     function setTokenUpgrader(address _newToken)
487         external
488         onlyUpgradeMaster
489         notInUpgradingState
490     {
491         require(canUpgrade());
492         require(_newToken != address(0));
493 
494         tokenUpgrader = TokenUpgrader(_newToken);
495 
496         // Handle bad interface
497         require(tokenUpgrader.isTokenUpgrader());
498 
499         // Make sure that token supplies match in source and target
500         require(tokenUpgrader.originalSupply() == totalSupply_);
501 
502         emit TokenUpgraderIsSet(tokenUpgrader);
503     }
504 
505     // Allow the token holder to upgrade some of their tokens to a new contract.
506     function upgrade(uint _value) external {
507         UpgradeState state = getUpgradeState();
508         
509         // Check upgrate state 
510         require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading);
511         // Validate input value
512         require(_value != 0);
513 
514         balances[msg.sender] = balances[msg.sender].sub(_value);
515 
516         // Take tokens out from circulation
517         totalSupply_ = totalSupply_.sub(_value);
518         totalUpgraded = totalUpgraded.add(_value);
519 
520         // Token Upgrader reissues the tokens
521         tokenUpgrader.upgradeFrom(msg.sender, _value);
522         emit Upgrade(msg.sender, tokenUpgrader, _value);
523     }
524 
525     /**
526     * Change the upgrade master.
527     * This allows us to set a new owner for the upgrade mechanism.
528     */
529     function setUpgradeMaster(address _newMaster) external onlyUpgradeMaster {
530         require(_newMaster != address(0));
531         upgradeMaster = _newMaster;
532     }
533 
534     // To be overriden to add functionality
535     function allowUpgrades() external onlyUpgradeMaster () {
536         upgradesAllowed = true;
537     }
538 
539     // To be overriden to add functionality
540     function rejectUpgrades() external onlyUpgradeMaster () {
541         require(!(totalUpgraded > 0));
542         upgradesAllowed = false;
543     }
544 
545     // Get the state of the token upgrade.
546     function getUpgradeState() public view returns(UpgradeState) {
547         if (!canUpgrade()) return UpgradeState.NotAllowed;
548         else if (address(tokenUpgrader) == address(0)) return UpgradeState.Waiting;
549         else if (totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
550         else return UpgradeState.Upgrading;
551     }
552 
553     // To be overriden to add functionality
554     function canUpgrade() public view returns(bool) {
555         return upgradesAllowed;
556     }
557 }
558 
559 
560 contract Token is UpgradeableToken, BurnableToken {
561     string public name = "KEYOTO";
562     string public symbol = "KEYO";
563 
564     // For patient incentive programs
565     uint256 public INITIAL_SUPPLY;
566 
567     event UpdatedTokenInformation(string newName, string newSymbol);
568 
569     constructor (address kpoWallet, address _upgradeMaster, uint256 _INITIAL_SUPPLY)
570         public
571         UpgradeableToken(_upgradeMaster)
572     {
573         require(maxTokenSupply >= _INITIAL_SUPPLY * (10 ** uint256(decimals)));
574         INITIAL_SUPPLY = _INITIAL_SUPPLY * (10 ** uint256(decimals));
575         totalSupply_ = INITIAL_SUPPLY;
576         balances[kpoWallet] = INITIAL_SUPPLY;
577         emit Transfer(address(0), kpoWallet, INITIAL_SUPPLY);
578     }
579 
580     /**
581     * Owner can update token information here
582     */
583     function setTokenInformation(string _name, string _symbol) external onlyOwner {
584         name = _name;
585         symbol = _symbol;
586 
587         emit UpdatedTokenInformation(name, symbol);
588     }
589 
590     /**
591     * Owner can burn token here
592     */
593     function burn(uint256 _value) public onlyOwner {
594         super.burn(_value);
595     }
596 }