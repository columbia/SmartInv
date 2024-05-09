1 pragma solidity 0.4.21;
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
24   /**
25    * @dev Throws if called by any account other than the owner.
26    */
27   modifier onlyOwner() {
28     require(msg.sender == owner);
29     _;
30   }
31 
32   /**
33    * @dev Allows the current owner to transfer control of the contract to a newOwner.
34    * @param newOwner The address to transfer ownership to.
35    */
36   function transferOwnership(address newOwner) public onlyOwner {
37     require(newOwner != address(0));
38     emit OwnershipTransferred(owner, newOwner);
39     owner = newOwner;
40   }
41 }
42 
43 
44 /**
45  * @title Pausable
46  * @dev Base contract which allows children to implement an emergency stop mechanism.
47  */
48 contract Pausable is Ownable {
49   event Pause();
50   event Unpause();
51 
52   bool public paused = false;
53 
54 
55   /**
56    * @dev Modifier to make a function callable only when the contract is not paused.
57    */
58   modifier whenNotPaused() {
59     require(!paused);
60     _;
61   }
62 
63   /**
64    * @dev Modifier to make a function callable only when the contract is paused.
65    */
66   modifier whenPaused() {
67     require(paused);
68     _;
69   }
70 
71   /**
72    * @dev called by the owner to pause, triggers stopped state
73    */
74   function pause() onlyOwner whenNotPaused public {
75     paused = true;
76     emit Pause();
77   }
78 
79   /**
80    * @dev called by the owner to unpause, returns to normal state
81    */
82   function unpause() onlyOwner whenPaused public {
83     paused = false;
84     emit Unpause();
85   }
86 }
87 
88 
89 /**
90  * @title SafeMath
91  * @dev Math operations with safety checks that throw on error
92  */
93 library SafeMath {
94 
95   /**
96   * @dev Multiplies two numbers, throws on overflow.
97   */
98   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
99     if (a == 0) {
100       return 0;
101     }
102     uint256 c = a * b;
103     assert(c / a == b);
104     return c;
105   }
106 
107   /**
108   * @dev Integer division of two numbers, truncating the quotient.
109   */
110   function div(uint256 a, uint256 b) internal pure returns (uint256) {
111     // assert(b > 0); // Solidity automatically throws when dividing by 0
112     uint256 c = a / b;
113     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
114     return c;
115   }
116 
117   /**
118   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
119   */
120   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
121     assert(b <= a);
122     return a - b;
123   }
124 
125   /**
126   * @dev Adds two numbers, throws on overflow.
127   */
128   function add(uint256 a, uint256 b) internal pure returns (uint256) {
129     uint256 c = a + b;
130     assert(c >= a);
131     return c;
132   }
133 }
134 
135 
136 /**
137  * @title ERC20Basic
138  * @dev Simpler version of ERC20 interface
139  * @dev see https://github.com/ethereum/EIPs/issues/179
140  */
141 contract ERC20Basic {
142   function totalSupply() public view returns (uint256);
143   function balanceOf(address who) public view returns (uint256);
144   function transfer(address to, uint256 value) public returns (bool);
145   event Transfer(address indexed from, address indexed to, uint256 value);
146 }
147 
148 
149 /**
150  * @title Basic token
151  * @dev Basic version of StandardToken, with no allowances.
152  */
153 contract BasicToken is ERC20Basic {
154   using SafeMath for uint256;
155 
156   mapping(address => uint256) balances;
157 
158   uint256 totalSupply_;
159 
160   /**
161   * @dev total number of tokens in existence
162   */
163   function totalSupply() public view returns (uint256) {
164     return totalSupply_;
165   }
166 
167   /**
168   * @dev transfer token for a specified address
169   * @param _to The address to transfer to.
170   * @param _value The amount to be transferred.
171   */
172   function transfer(address _to, uint256 _value) public returns (bool) {
173     require(_to != address(0));
174     require(_value <= balances[msg.sender]);
175 
176     // SafeMath.sub will throw if there is not enough balance.
177     balances[msg.sender] = balances[msg.sender].sub(_value);
178     balances[_to] = balances[_to].add(_value);
179     emit Transfer(msg.sender, _to, _value);
180     return true;
181   }
182 
183   /**
184   * @dev Gets the balance of the specified address.
185   * @param _owner The address to query the the balance of.
186   * @return An uint256 representing the amount owned by the passed address.
187   */
188   function balanceOf(address _owner) public view returns (uint256 balance) {
189     return balances[_owner];
190   }
191 }
192 
193 
194 /**
195  * @title ERC20 interface
196  * @dev see https://github.com/ethereum/EIPs/issues/20
197  */
198 contract ERC20 is ERC20Basic {
199   function allowance(address owner, address spender) public view returns (uint256);
200   function transferFrom(address from, address to, uint256 value) public returns (bool);
201   function approve(address spender, uint256 value) public returns (bool);
202   event Approval(address indexed owner, address indexed spender, uint256 value);
203 }
204 
205 
206 /**
207  * @title Standard ERC20 token
208  *
209  * @dev Implementation of the basic standard token.
210  * @dev https://github.com/ethereum/EIPs/issues/20
211  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
212  */
213 contract StandardToken is ERC20, BasicToken {
214 
215   mapping (address => mapping (address => uint256)) internal allowed;
216 
217 
218   /**
219    * @dev Transfer tokens from one address to another
220    * @param _from address The address which you want to send tokens from
221    * @param _to address The address which you want to transfer to
222    * @param _value uint256 the amount of tokens to be transferred
223    */
224   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
225     require(_to != address(0));
226     require(_value <= balances[_from]);
227     require(_value <= allowed[_from][msg.sender]);
228 
229     balances[_from] = balances[_from].sub(_value);
230     balances[_to] = balances[_to].add(_value);
231     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
232     emit Transfer(_from, _to, _value);
233     return true;
234   }
235 
236   /**
237    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
238    *
239    * Beware that changing an allowance with this method brings the risk that someone may use both the old
240    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
241    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
242    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
243    * @param _spender The address which will spend the funds.
244    * @param _value The amount of tokens to be spent.
245    */
246   function approve(address _spender, uint256 _value) public returns (bool) {
247     allowed[msg.sender][_spender] = _value;
248     emit Approval(msg.sender, _spender, _value);
249     return true;
250   }
251 
252   /**
253    * @dev Function to check the amount of tokens that an owner allowed to a spender.
254    * @param _owner address The address which owns the funds.
255    * @param _spender address The address which will spend the funds.
256    * @return A uint256 specifying the amount of tokens still available for the spender.
257    */
258   function allowance(address _owner, address _spender) public view returns (uint256) {
259     return allowed[_owner][_spender];
260   }
261 
262   /**
263    * @dev Increase the amount of tokens that an owner allowed to a spender.
264    *
265    * approve should be called when allowed[_spender] == 0. To increment
266    * allowed value is better to use this function to avoid 2 calls (and wait until
267    * the first transaction is mined)
268    * From MonolithDAO Token.sol
269    * @param _spender The address which will spend the funds.
270    * @param _addedValue The amount of tokens to increase the allowance by.
271    */
272   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
273     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
274     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
275     return true;
276   }
277 
278   /**
279    * @dev Decrease the amount of tokens that an owner allowed to a spender.
280    *
281    * approve should be called when allowed[_spender] == 0. To decrement
282    * allowed value is better to use this function to avoid 2 calls (and wait until
283    * the first transaction is mined)
284    * From MonolithDAO Token.sol
285    * @param _spender The address which will spend the funds.
286    * @param _subtractedValue The amount of tokens to decrease the allowance by.
287    */
288   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
289     uint oldValue = allowed[msg.sender][_spender];
290     if (_subtractedValue > oldValue) {
291       allowed[msg.sender][_spender] = 0;
292     } else {
293       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
294     }
295     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
296     return true;
297   }
298 
299 }
300 
301 
302 /**
303  * @title Pausable token
304  * @dev StandardToken modified with pausable transfers.
305  **/
306 contract PausableToken is StandardToken, Pausable {
307 
308   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
309     return super.transfer(_to, _value);
310   }
311 
312   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
313     return super.transferFrom(_from, _to, _value);
314   }
315 
316   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
317     return super.approve(_spender, _value);
318   }
319 
320   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
321     return super.increaseApproval(_spender, _addedValue);
322   }
323 
324   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
325     return super.decreaseApproval(_spender, _subtractedValue);
326   }
327 }
328 
329 contract MintableAndPausableToken is PausableToken {
330     uint8 public constant decimals = 18;
331     bool public mintingFinished = false;
332     
333     event Mint(address indexed to, uint256 amount);
334     event MintFinished();
335     event MintStarted();
336 
337     modifier canMint() {
338         require(!mintingFinished);
339         _;
340     }
341 
342     modifier cannotMint() {
343         require(mintingFinished);
344         _;
345     }
346 
347     function mint(address _to, uint256 _amount)
348         external
349         onlyOwner
350         canMint
351         whenNotPaused
352         returns (bool)
353     {
354         totalSupply_ = totalSupply_.add(_amount);
355         balances[_to] = balances[_to].add(_amount);
356         emit Mint(_to, _amount);
357         emit Transfer(address(0), _to, _amount);
358         return true;
359     }
360 
361     function finishMinting() external onlyOwner canMint returns (bool) {
362         mintingFinished = true;
363         emit MintFinished();
364         return true;
365     }
366 
367     function startMinting() external onlyOwner cannotMint returns (bool) {
368         mintingFinished = false;
369         emit MintStarted();
370         return true;
371     }
372 }
373 
374 
375 
376 /**
377  * Token upgrader interface inspired by Lunyr.
378  *
379  * Token upgrader transfers previous version tokens to a newer version.
380  * Token upgrader itself can be the token contract, or just a middle man contract doing the heavy lifting.
381  */
382 contract TokenUpgrader {
383     uint public originalSupply;
384 
385     /** Interface marker */
386     function isTokenUpgrader() external pure returns (bool) {
387         return true;
388     }
389 
390     function upgradeFrom(address _from, uint256 _value) public {}
391 }
392 
393 
394 /**
395  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
396  *
397  * First envisioned by Golem and Lunyr projects.
398  */
399 
400 
401 contract UpgradeableToken is MintableAndPausableToken {
402     // Contract or person who can set the upgrade path.
403     address public upgradeMaster;
404     
405     // Bollean value needs to be true to start upgrades
406     bool private upgradesAllowed;
407 
408     // The next contract where the tokens will be migrated.
409     TokenUpgrader public tokenUpgrader;
410 
411     // How many tokens we have upgraded by now.
412     uint public totalUpgraded;
413 
414     /**
415     * Upgrade states.
416     * - NotAllowed: The child contract has not reached a condition where the upgrade can begin
417     * - Waiting: Token allows upgrade, but we don't have a new token version
418     * - ReadyToUpgrade: The token version is set, but not a single token has been upgraded yet
419     * - Upgrading: Token upgrader is set and the balance holders can upgrade their tokens
420     */
421     enum UpgradeState { NotAllowed, Waiting, ReadyToUpgrade, Upgrading }
422 
423     // Somebody has upgraded some of his tokens.
424     event Upgrade(address indexed _from, address indexed _to, uint256 _value);
425 
426     // New token version available.
427     event TokenUpgraderIsSet(address _newToken);
428 
429     modifier onlyUpgradeMaster {
430         // Only a master can designate the next token
431         require(msg.sender == upgradeMaster);
432         _;
433     }
434 
435     modifier notInUpgradingState {
436         // Upgrade has already begun for token
437         require(getUpgradeState() != UpgradeState.Upgrading);
438         _;
439     }
440 
441     // Do not allow construction without upgrade master set.
442     function UpgradeableToken(address _upgradeMaster) public {
443         upgradeMaster = _upgradeMaster;
444     }
445 
446     // set a token upgrader
447     function setTokenUpgrader(address _newToken)
448         external
449         onlyUpgradeMaster
450         notInUpgradingState
451     {
452         require(canUpgrade());
453         require(_newToken != address(0));
454 
455         tokenUpgrader = TokenUpgrader(_newToken);
456 
457         // Handle bad interface
458         require(tokenUpgrader.isTokenUpgrader());
459 
460         // Make sure that token supplies match in source and target
461         require(tokenUpgrader.originalSupply() == totalSupply_);
462 
463         emit TokenUpgraderIsSet(tokenUpgrader);
464     }
465 
466     // Allow the token holder to upgrade some of their tokens to a new contract.
467     function upgrade(uint _value) external {
468         UpgradeState state = getUpgradeState();
469         
470         // Check upgrate state 
471         require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading);
472         // Validate input value
473         require(_value != 0);
474 
475         balances[msg.sender] = balances[msg.sender].sub(_value);
476 
477         // Take tokens out from circulation
478         totalSupply_ = totalSupply_.sub(_value);
479         totalUpgraded = totalUpgraded.add(_value);
480 
481         // Token Upgrader reissues the tokens
482         tokenUpgrader.upgradeFrom(msg.sender, _value);
483         emit Upgrade(msg.sender, tokenUpgrader, _value);
484     }
485 
486     /**
487     * Change the upgrade master.
488     * This allows us to set a new owner for the upgrade mechanism.
489     */
490     function setUpgradeMaster(address _newMaster) external onlyUpgradeMaster {
491         require(_newMaster != address(0));
492         upgradeMaster = _newMaster;
493     }
494 
495     // To be overriden to add functionality
496     function allowUpgrades() external onlyUpgradeMaster () {
497         upgradesAllowed = true;
498     }
499 
500     // To be overriden to add functionality
501     function rejectUpgrades() external onlyUpgradeMaster () {
502         require(!(totalUpgraded > 0));
503         upgradesAllowed = false;
504     }
505 
506     // Get the state of the token upgrade.
507     function getUpgradeState() public view returns(UpgradeState) {
508         if (!canUpgrade()) return UpgradeState.NotAllowed;
509         else if (address(tokenUpgrader) == address(0)) return UpgradeState.Waiting;
510         else if (totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
511         else return UpgradeState.Upgrading;
512     }
513 
514     // To be overriden to add functionality
515     function canUpgrade() public view returns(bool) {
516         return upgradesAllowed;
517     }
518 }
519 
520 
521 contract Token is UpgradeableToken {
522     string public name = "Ydentity";
523     string public symbol = "YDY";
524     uint8 public constant decimals = 18;
525 
526     // For patient incentive programs
527     uint256 public INITIAL_SUPPLY;
528 
529     event UpdatedTokenInformation(string newName, string newSymbol);
530 
531     function Token(address ydyWallet, address _upgradeMaster, uint256 _INITIAL_SUPPLY)
532         public
533         UpgradeableToken(_upgradeMaster)
534     {
535         INITIAL_SUPPLY = _INITIAL_SUPPLY * (10 ** uint256(decimals));
536         totalSupply_ = INITIAL_SUPPLY;
537         balances[ydyWallet] = INITIAL_SUPPLY;
538         emit Transfer(address(0), ydyWallet, INITIAL_SUPPLY);
539     }
540 
541     /**
542     * Owner can update token information here
543     */
544     function setTokenInformation(string _name, string _symbol) external onlyOwner {
545         name = _name;
546         symbol = _symbol;
547 
548         emit UpdatedTokenInformation(name, symbol);
549     }
550 
551 }