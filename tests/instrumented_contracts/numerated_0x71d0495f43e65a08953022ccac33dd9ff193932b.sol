1 pragma solidity ^0.4.19;
2 
3 
4 /**
5  * @title ERC20Basic
6  * @dev Simpler version of ERC20 interface
7  * @dev see https://github.com/ethereum/EIPs/issues/179
8  */
9 contract ERC20Basic {
10   function totalSupply() public view returns (uint256);
11   function balanceOf(address who) public view returns (uint256);
12   function transfer(address to, uint256 value) public returns (bool);
13   event Transfer(address indexed from, address indexed to, uint256 value);
14 }
15 
16 
17 /**
18  * @title SafeMath
19  * @dev Math operations with safety checks that throw on error
20  */
21 library SafeMath {
22 
23   /**
24   * @dev Multiplies two numbers, throws on overflow.
25   */
26   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
27     if (a == 0) {
28       return 0;
29     }
30     uint256 c = a * b;
31     assert(c / a == b);
32     return c;
33   }
34 
35   /**
36   * @dev Integer division of two numbers, truncating the quotient.
37   */
38   function div(uint256 a, uint256 b) internal pure returns (uint256) {
39     // assert(b > 0); // Solidity automatically throws when dividing by 0
40     uint256 c = a / b;
41     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
42     return c;
43   }
44 
45   /**
46   * @dev Substracts two numbers, throws on overflow (i.e. if subtrahend is greater than minuend).
47   */
48   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
49     assert(b <= a);
50     return a - b;
51   }
52 
53   /**
54   * @dev Adds two numbers, throws on overflow.
55   */
56   function add(uint256 a, uint256 b) internal pure returns (uint256) {
57     uint256 c = a + b;
58     assert(c >= a);
59     return c;
60   }
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
94     Transfer(msg.sender, _to, _value);
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
111  * @title ERC20 interface
112  * @dev see https://github.com/ethereum/EIPs/issues/20
113  */
114 contract ERC20 is ERC20Basic {
115   function allowance(address owner, address spender) public view returns (uint256);
116   function transferFrom(address from, address to, uint256 value) public returns (bool);
117   function approve(address spender, uint256 value) public returns (bool);
118   event Approval(address indexed owner, address indexed spender, uint256 value);
119 }
120 
121 
122 /**
123  * @title Standard ERC20 token
124  *
125  * @dev Implementation of the basic standard token.
126  * @dev https://github.com/ethereum/EIPs/issues/20
127  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
128  */
129 contract StandardToken is ERC20, BasicToken {
130 
131   mapping (address => mapping (address => uint256)) internal allowed;
132 
133 
134   /**
135    * @dev Transfer tokens from one address to another
136    * @param _from address The address which you want to send tokens from
137    * @param _to address The address which you want to transfer to
138    * @param _value uint256 the amount of tokens to be transferred
139    */
140   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
141     require(_to != address(0));
142     require(_value <= balances[_from]);
143     require(_value <= allowed[_from][msg.sender]);
144 
145     balances[_from] = balances[_from].sub(_value);
146     balances[_to] = balances[_to].add(_value);
147     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
148     Transfer(_from, _to, _value);
149     return true;
150   }
151 
152   /**
153    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
154    *
155    * Beware that changing an allowance with this method brings the risk that someone may use both the old
156    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
157    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
158    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
159    * @param _spender The address which will spend the funds.
160    * @param _value The amount of tokens to be spent.
161    */
162   function approve(address _spender, uint256 _value) public returns (bool) {
163     allowed[msg.sender][_spender] = _value;
164     Approval(msg.sender, _spender, _value);
165     return true;
166   }
167 
168   /**
169    * @dev Function to check the amount of tokens that an owner allowed to a spender.
170    * @param _owner address The address which owns the funds.
171    * @param _spender address The address which will spend the funds.
172    * @return A uint256 specifying the amount of tokens still available for the spender.
173    */
174   function allowance(address _owner, address _spender) public view returns (uint256) {
175     return allowed[_owner][_spender];
176   }
177 
178   /**
179    * @dev Increase the amount of tokens that an owner allowed to a spender.
180    *
181    * approve should be called when allowed[_spender] == 0. To increment
182    * allowed value is better to use this function to avoid 2 calls (and wait until
183    * the first transaction is mined)
184    * From MonolithDAO Token.sol
185    * @param _spender The address which will spend the funds.
186    * @param _addedValue The amount of tokens to increase the allowance by.
187    */
188   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
189     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
190     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
191     return true;
192   }
193 
194   /**
195    * @dev Decrease the amount of tokens that an owner allowed to a spender.
196    *
197    * approve should be called when allowed[_spender] == 0. To decrement
198    * allowed value is better to use this function to avoid 2 calls (and wait until
199    * the first transaction is mined)
200    * From MonolithDAO Token.sol
201    * @param _spender The address which will spend the funds.
202    * @param _subtractedValue The amount of tokens to decrease the allowance by.
203    */
204   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
205     uint oldValue = allowed[msg.sender][_spender];
206     if (_subtractedValue > oldValue) {
207       allowed[msg.sender][_spender] = 0;
208     } else {
209       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
210     }
211     Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
212     return true;
213   }
214 
215 }
216 
217 
218 /**
219  * @title Ownable
220  * @dev The Ownable contract has an owner address, and provides basic authorization control
221  * functions, this simplifies the implementation of "user permissions".
222  */
223 contract Ownable {
224   address public owner;
225 
226 
227   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
228 
229 
230   /**
231    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
232    * account.
233    */
234   function Ownable() public {
235     owner = msg.sender;
236   }
237 
238   /**
239    * @dev Throws if called by any account other than the owner.
240    */
241   modifier onlyOwner() {
242     require(msg.sender == owner);
243     _;
244   }
245 
246   /**
247    * @dev Allows the current owner to transfer control of the contract to a newOwner.
248    * @param newOwner The address to transfer ownership to.
249    */
250   function transferOwnership(address newOwner) public onlyOwner {
251     require(newOwner != address(0));
252     OwnershipTransferred(owner, newOwner);
253     owner = newOwner;
254   }
255 
256 }
257 
258 
259 /**
260  * @title Pausable
261  * @dev Base contract which allows children to implement an emergency stop mechanism.
262  */
263 contract Pausable is Ownable {
264   event Pause();
265   event Unpause();
266 
267   bool public paused = false;
268 
269 
270   /**
271    * @dev Modifier to make a function callable only when the contract is not paused.
272    */
273   modifier whenNotPaused() {
274     require(!paused);
275     _;
276   }
277 
278   /**
279    * @dev Modifier to make a function callable only when the contract is paused.
280    */
281   modifier whenPaused() {
282     require(paused);
283     _;
284   }
285 
286   /**
287    * @dev called by the owner to pause, triggers stopped state
288    */
289   function pause() onlyOwner whenNotPaused public {
290     paused = true;
291     Pause();
292   }
293 
294   /**
295    * @dev called by the owner to unpause, returns to normal state
296    */
297   function unpause() onlyOwner whenPaused public {
298     paused = false;
299     Unpause();
300   }
301 }
302 
303 
304 /**
305  * @title Pausable token
306  * @dev StandardToken modified with pausable transfers.
307  **/
308 contract PausableToken is StandardToken, Pausable {
309 
310   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
311     return super.transfer(_to, _value);
312   }
313 
314   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
315     return super.transferFrom(_from, _to, _value);
316   }
317 
318   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
319     return super.approve(_spender, _value);
320   }
321 
322   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
323     return super.increaseApproval(_spender, _addedValue);
324   }
325 
326   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
327     return super.decreaseApproval(_spender, _subtractedValue);
328   }
329 }
330 
331 
332 contract MintableAndPausableToken is PausableToken {
333     event Mint(address indexed to, uint256 amount);
334     event MintFinished();
335     event MintStarted();
336 
337     bool public mintingFinished = false;
338 
339     modifier canMint() {
340         require(!mintingFinished);
341         _;
342     }
343 
344     modifier cannotMint() {
345         require(mintingFinished);
346         _;
347     }
348 
349     function mint(address _to, uint256 _amount)
350         public
351         onlyOwner
352         canMint
353         whenNotPaused
354         returns (bool)
355     {
356         totalSupply_ = totalSupply_.add(_amount);
357         balances[_to] = balances[_to].add(_amount);
358         Mint(_to, _amount);
359         Transfer(address(0), _to, _amount);
360         return true;
361     }
362 
363     function finishMinting() public onlyOwner canMint returns (bool) {
364         mintingFinished = true;
365         MintFinished();
366         return true;
367     }
368 
369     function startMinting() public onlyOwner cannotMint returns (bool) {
370         mintingFinished = false;
371         MintStarted();
372         return true;
373     }
374 }
375 
376 
377 /**
378  * Token upgrader interface inspired by Lunyr.
379  *
380  * Token upgrader transfers previous version tokens to a newer version.
381  * Token upgrader itself can be the token contract, or just a middle man contract doing the heavy lifting.
382  */
383 contract TokenUpgrader {
384     uint public originalSupply;
385 
386     /** Interface marker */
387     function isTokenUpgrader() public pure returns (bool) {
388         return true;
389     }
390 
391     function upgradeFrom(address _from, uint256 _value) public {}
392 }
393 
394 
395 contract UpgradeableToken is MintableAndPausableToken {
396     // Contract or person who can set the upgrade path.
397     address public upgradeMaster;
398     
399     // Bollean value needs to be true to start upgrades
400     bool private upgradesAllowed;
401 
402     // The next contract where the tokens will be migrated.
403     TokenUpgrader public tokenUpgrader;
404 
405     // How many tokens we have upgraded by now.
406     uint public totalUpgraded;
407 
408     /**
409     * Upgrade states.
410     * - NotAllowed: The child contract has not reached a condition where the upgrade can begin
411     * - Waiting: Token allows upgrade, but we don't have a new token version
412     * - ReadyToUpgrade: The token version is set, but not a single token has been upgraded yet
413     * - Upgrading: Token upgrader is set and the balance holders can upgrade their tokens
414     */
415     enum UpgradeState { Unknown, NotAllowed, Waiting, ReadyToUpgrade, Upgrading }
416 
417     // Somebody has upgraded some of his tokens.
418     event Upgrade(address indexed _from, address indexed _to, uint256 _value);
419 
420     // New token version available.
421     event TokenUpgraderIsSet(address _newToken);
422 
423     modifier onlyUpgradeMaster {
424         // Only a master can designate the next token
425         require(msg.sender == upgradeMaster);
426         _;
427     }
428 
429     modifier notInUpgradingState {
430         // Upgrade has already begun for token
431         require(getUpgradeState() != UpgradeState.Upgrading);
432         _;
433     }
434 
435     // Do not allow construction without upgrade master set.
436     function UpgradeableToken(address _upgradeMaster) public {
437         upgradeMaster = _upgradeMaster;
438     }
439 
440     // set a token upgrader
441     function setTokenUpgrader(address _newToken)
442         external
443         onlyUpgradeMaster
444         notInUpgradingState
445     {
446         require(canUpgrade());
447         require(_newToken != 0x0);
448 
449         tokenUpgrader = TokenUpgrader(_newToken);
450 
451         // Handle bad interface
452         require(tokenUpgrader.isTokenUpgrader());
453 
454         // Make sure that token supplies match in source and target
455         require(tokenUpgrader.originalSupply() == totalSupply_);
456 
457         TokenUpgraderIsSet(tokenUpgrader);
458     }
459 
460     // Allow the token holder to upgrade some of their tokens to a new contract.
461     function upgrade(uint _value) public {
462         UpgradeState state = getUpgradeState();
463         require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading);
464 
465         // Validate input value.
466         require(_value != 0);
467 
468         balances[msg.sender] = balances[msg.sender].sub(_value);
469 
470         // Take tokens out from circulation
471         totalSupply_ = totalSupply_.sub(_value);
472         totalUpgraded = totalUpgraded.add(_value);
473 
474         // Token Upgrader reissues the tokens
475         tokenUpgrader.upgradeFrom(msg.sender, _value);
476         Upgrade(msg.sender, tokenUpgrader, _value);
477     }
478 
479     // Get the state of the token upgrade.
480     function getUpgradeState() public view returns(UpgradeState) {
481         if (!canUpgrade()) return UpgradeState.NotAllowed;
482         else if (address(tokenUpgrader) == address(0)) return UpgradeState.Waiting;
483         else if (totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
484         else if (totalUpgraded > 0) return UpgradeState.Upgrading;
485         return UpgradeState.Unknown;
486     }
487 
488     /**
489     * Change the upgrade master.
490     * This allows us to set a new owner for the upgrade mechanism.
491     */
492     function setUpgradeMaster(address _newMaster) public onlyUpgradeMaster {
493         require(_newMaster != 0x0);
494         upgradeMaster = _newMaster;
495     }
496 
497     // To be overriden to add functionality
498     function allowUpgrades() public onlyUpgradeMaster {
499         upgradesAllowed = true;
500     }
501 
502     // To be overriden to add functionality
503     function canUpgrade() public view returns(bool) {
504         return upgradesAllowed;
505     }
506 }
507 
508 
509 contract Token is UpgradeableToken {
510     string public name = "AMCHART";
511     string public symbol = "AMC";
512     uint8 public constant decimals = 18;
513 
514     // For patient incentive programs
515     uint256 public constant INITIAL_SUPPLY = 5000000 * (10 ** uint256(decimals));
516 
517     event UpdatedTokenInformation(string newName, string newSymbol);
518 
519     function Token(address amcWallet, address _upgradeMaster)
520         public
521         UpgradeableToken(_upgradeMaster)
522     {
523         totalSupply_ = INITIAL_SUPPLY;
524         balances[amcWallet] = INITIAL_SUPPLY;
525         Transfer(0x0, amcWallet, INITIAL_SUPPLY);
526     }
527 
528     /**
529     * Owner can update token information here
530     */
531     function setTokenInformation(string _name, string _symbol) public onlyOwner {
532         name = _name;
533         symbol = _symbol;
534 
535         UpdatedTokenInformation(name, symbol);
536     }
537 }