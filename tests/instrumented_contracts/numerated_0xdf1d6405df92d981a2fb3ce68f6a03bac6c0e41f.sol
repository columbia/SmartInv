1 pragma solidity 0.4.21;
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
65  * @title ERC20 interface
66  * @dev see https://github.com/ethereum/EIPs/issues/20
67  */
68 contract ERC20 is ERC20Basic {
69   function allowance(address owner, address spender) public view returns (uint256);
70   function transferFrom(address from, address to, uint256 value) public returns (bool);
71   function approve(address spender, uint256 value) public returns (bool);
72   event Approval(address indexed owner, address indexed spender, uint256 value);
73 }
74 
75 
76 /**
77  * @title Basic token
78  * @dev Basic version of StandardToken, with no allowances.
79  */
80 contract BasicToken is ERC20Basic {
81   using SafeMath for uint256;
82 
83   mapping(address => uint256) balances;
84 
85   uint256 totalSupply_;
86 
87   /**
88   * @dev total number of tokens in existence
89   */
90   function totalSupply() public view returns (uint256) {
91     return totalSupply_;
92   }
93 
94   /**
95   * @dev transfer token for a specified address
96   * @param _to The address to transfer to.
97   * @param _value The amount to be transferred.
98   */
99   function transfer(address _to, uint256 _value) public returns (bool) {
100     require(_to != address(0));
101     require(_value <= balances[msg.sender]);
102 
103     // SafeMath.sub will throw if there is not enough balance.
104     balances[msg.sender] = balances[msg.sender].sub(_value);
105     balances[_to] = balances[_to].add(_value);
106     emit Transfer(msg.sender, _to, _value);
107     return true;
108   }
109 
110   /**
111   * @dev Gets the balance of the specified address.
112   * @param _owner The address to query the the balance of.
113   * @return An uint256 representing the amount owned by the passed address.
114   */
115   function balanceOf(address _owner) public view returns (uint256 balance) {
116     return balances[_owner];
117   }
118 
119 }
120 
121 
122 /**
123  * @title Burnable Token
124  * @dev Token that can be irreversibly burned (destroyed).
125  */
126 contract BurnableToken is BasicToken {
127 
128   event Burn(address indexed burner, uint256 value);
129 
130   /**
131    * @dev Burns a specific amount of tokens.
132    * @param _value The amount of token to be burned.
133    */
134   function burn(uint256 _value) public {
135     require(_value <= balances[msg.sender]);
136     // no need to require value <= totalSupply, since that would imply the
137     // sender's balance is greater than the totalSupply, which *should* be an assertion failure
138 
139     address burner = msg.sender;
140     balances[burner] = balances[burner].sub(_value);
141     totalSupply_ = totalSupply_.sub(_value);
142     emit Burn(burner, _value);
143   }
144 }
145 
146 
147 /**
148  * @title Standard ERC20 token
149  *
150  * @dev Implementation of the basic standard token.
151  * @dev https://github.com/ethereum/EIPs/issues/20
152  * @dev Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
153  */
154 contract StandardToken is ERC20, BasicToken {
155 
156   mapping (address => mapping (address => uint256)) internal allowed;
157 
158 
159   /**
160    * @dev Transfer tokens from one address to another
161    * @param _from address The address which you want to send tokens from
162    * @param _to address The address which you want to transfer to
163    * @param _value uint256 the amount of tokens to be transferred
164    */
165   function transferFrom(address _from, address _to, uint256 _value) public returns (bool) {
166     require(_to != address(0));
167     require(_value <= balances[_from]);
168     require(_value <= allowed[_from][msg.sender]);
169 
170     balances[_from] = balances[_from].sub(_value);
171     balances[_to] = balances[_to].add(_value);
172     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
173     emit Transfer(_from, _to, _value);
174     return true;
175   }
176 
177   /**
178    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
179    *
180    * Beware that changing an allowance with this method brings the risk that someone may use both the old
181    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
182    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
183    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
184    * @param _spender The address which will spend the funds.
185    * @param _value The amount of tokens to be spent.
186    */
187   function approve(address _spender, uint256 _value) public returns (bool) {
188     allowed[msg.sender][_spender] = _value;
189     emit Approval(msg.sender, _spender, _value);
190     return true;
191   }
192 
193   /**
194    * @dev Function to check the amount of tokens that an owner allowed to a spender.
195    * @param _owner address The address which owns the funds.
196    * @param _spender address The address which will spend the funds.
197    * @return A uint256 specifying the amount of tokens still available for the spender.
198    */
199   function allowance(address _owner, address _spender) public view returns (uint256) {
200     return allowed[_owner][_spender];
201   }
202 
203   /**
204    * @dev Increase the amount of tokens that an owner allowed to a spender.
205    *
206    * approve should be called when allowed[_spender] == 0. To increment
207    * allowed value is better to use this function to avoid 2 calls (and wait until
208    * the first transaction is mined)
209    * From MonolithDAO Token.sol
210    * @param _spender The address which will spend the funds.
211    * @param _addedValue The amount of tokens to increase the allowance by.
212    */
213   function increaseApproval(address _spender, uint _addedValue) public returns (bool) {
214     allowed[msg.sender][_spender] = allowed[msg.sender][_spender].add(_addedValue);
215     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
216     return true;
217   }
218 
219   /**
220    * @dev Decrease the amount of tokens that an owner allowed to a spender.
221    *
222    * approve should be called when allowed[_spender] == 0. To decrement
223    * allowed value is better to use this function to avoid 2 calls (and wait until
224    * the first transaction is mined)
225    * From MonolithDAO Token.sol
226    * @param _spender The address which will spend the funds.
227    * @param _subtractedValue The amount of tokens to decrease the allowance by.
228    */
229   function decreaseApproval(address _spender, uint _subtractedValue) public returns (bool) {
230     uint oldValue = allowed[msg.sender][_spender];
231     if (_subtractedValue > oldValue) {
232       allowed[msg.sender][_spender] = 0;
233     } else {
234       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
235     }
236     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
237     return true;
238   }
239 
240 }
241 
242 
243 /**
244  * @title Ownable
245  * @dev The Ownable contract has an owner address, and provides basic authorization control
246  * functions, this simplifies the implementation of "user permissions".
247  */
248 contract Ownable {
249   address public owner;
250 
251 
252   event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
253 
254 
255   /**
256    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
257    * account.
258    */
259   function Ownable() public {
260     owner = msg.sender;
261   }
262 
263   /**
264    * @dev Throws if called by any account other than the owner.
265    */
266   modifier onlyOwner() {
267     require(msg.sender == owner);
268     _;
269   }
270 
271   /**
272    * @dev Allows the current owner to transfer control of the contract to a newOwner.
273    * @param newOwner The address to transfer ownership to.
274    */
275   function transferOwnership(address newOwner) public onlyOwner {
276     require(newOwner != address(0));
277     emit OwnershipTransferred(owner, newOwner);
278     owner = newOwner;
279   }
280 
281 }
282 
283 
284 /**
285  * @title Pausable
286  * @dev Base contract which allows children to implement an emergency stop mechanism.
287  */
288 contract Pausable is Ownable {
289   event Pause();
290   event Unpause();
291 
292   bool public paused = false;
293 
294 
295   /**
296    * @dev Modifier to make a function callable only when the contract is not paused.
297    */
298   modifier whenNotPaused() {
299     require(!paused);
300     _;
301   }
302 
303   /**
304    * @dev Modifier to make a function callable only when the contract is paused.
305    */
306   modifier whenPaused() {
307     require(paused);
308     _;
309   }
310 
311   /**
312    * @dev called by the owner to pause, triggers stopped state
313    */
314   function pause() onlyOwner whenNotPaused public {
315     paused = true;
316     emit Pause();
317   }
318 
319   /**
320    * @dev called by the owner to unpause, returns to normal state
321    */
322   function unpause() onlyOwner whenPaused public {
323     paused = false;
324     emit Unpause();
325   }
326 }
327 
328 
329 /**
330  * @title Pausable token
331  * @dev StandardToken modified with pausable transfers.
332  **/
333 contract PausableToken is StandardToken, Pausable {
334 
335   function transfer(address _to, uint256 _value) public whenNotPaused returns (bool) {
336     return super.transfer(_to, _value);
337   }
338 
339   function transferFrom(address _from, address _to, uint256 _value) public whenNotPaused returns (bool) {
340     return super.transferFrom(_from, _to, _value);
341   }
342 
343   function approve(address _spender, uint256 _value) public whenNotPaused returns (bool) {
344     return super.approve(_spender, _value);
345   }
346 
347   function increaseApproval(address _spender, uint _addedValue) public whenNotPaused returns (bool success) {
348     return super.increaseApproval(_spender, _addedValue);
349   }
350 
351   function decreaseApproval(address _spender, uint _subtractedValue) public whenNotPaused returns (bool success) {
352     return super.decreaseApproval(_spender, _subtractedValue);
353   }
354 }
355 
356 
357 
358 contract DistributableAndPausableToken is PausableToken {
359     uint256 public distributedToken;
360     address public vraWallet;
361 
362     event Distribute(address indexed to, uint256 amount);
363     event Mint(address indexed to, uint256 amount);
364 
365     function distributeTokens(address _to, uint256 _amount) 
366         external
367         onlyOwner
368         returns (bool)
369     {
370         require(_to != address(0));
371         require(_amount > 0);
372         require(balances[vraWallet].sub(_amount) >= 0);
373         balances[vraWallet] = balances[vraWallet].sub(_amount);
374         balances[_to] = balances[_to].add(_amount);
375         distributedToken = distributedToken.add(_amount);
376         emit Distribute(_to, _amount);
377         emit Transfer(address(0), _to, _amount);
378         return true;
379     }
380 
381     function getDistributedToken() public constant returns (uint256) {
382         return distributedToken;
383     }
384 
385 }
386 
387 
388 /**
389  * Token upgrader interface inspired by Lunyr.
390  *
391  * Token upgrader transfers previous version tokens to a newer version.
392  * Token upgrader itself can be the token contract, or just a middle man contract doing the heavy lifting.
393  */
394 contract TokenUpgrader {
395     uint public originalSupply;
396 
397     /** Interface marker */
398     function isTokenUpgrader() external pure returns (bool) {
399         return true;
400     }
401 
402     function upgradeFrom(address _from, uint256 _value) public {}
403 }
404 
405 
406 /**
407  * A token upgrade mechanism where users can opt-in amount of tokens to the next smart contract revision.
408  *
409  * First envisioned by Golem and Lunyr projects.
410  */
411 
412 contract UpgradeableToken is DistributableAndPausableToken {
413     // Contract or person who can set the upgrade path.
414     address public upgradeMaster;
415     
416     // Bollean value needs to be true to start upgrades
417     bool private upgradesAllowed;
418 
419     // The next contract where the tokens will be migrated.
420     TokenUpgrader public tokenUpgrader;
421 
422     // How many tokens we have upgraded by now.
423     uint public totalUpgraded;
424 
425     /**
426     * Upgrade states.
427     * - NotAllowed: The child contract has not reached a condition where the upgrade can begin
428     * - Waiting: Token allows upgrade, but we don't have a new token version
429     * - ReadyToUpgrade: The token version is set, but not a single token has been upgraded yet
430     * - Upgrading: Token upgrader is set and the balance holders can upgrade their tokens
431     */
432     enum UpgradeState { NotAllowed, Waiting, ReadyToUpgrade, Upgrading }
433 
434     // Somebody has upgraded some of his tokens.
435     event Upgrade(address indexed _from, address indexed _to, uint256 _value);
436 
437     // New token version available.
438     event TokenUpgraderIsSet(address _newToken);
439 
440     modifier onlyUpgradeMaster {
441         // Only a master can designate the next token
442         require(msg.sender == upgradeMaster);
443         _;
444     }
445 
446     modifier notInUpgradingState {
447         // Upgrade has already begun for token
448         require(getUpgradeState() != UpgradeState.Upgrading);
449         _;
450     }
451 
452     // Do not allow construction without upgrade master set.
453     function UpgradeableToken(address _upgradeMaster) public {
454         upgradeMaster = _upgradeMaster;
455     }
456 
457     // set a token upgrader
458     function setTokenUpgrader(address _newToken)
459         external
460         onlyUpgradeMaster
461         notInUpgradingState
462     {
463         require(canUpgrade());
464         require(_newToken != address(0));
465 
466         tokenUpgrader = TokenUpgrader(_newToken);
467 
468         // Handle bad interface
469         require(tokenUpgrader.isTokenUpgrader());
470 
471         // Make sure that token supplies match in source and target
472         require(tokenUpgrader.originalSupply() == totalSupply_);
473 
474         emit TokenUpgraderIsSet(tokenUpgrader);
475     }
476 
477     // Allow the token holder to upgrade some of their tokens to a new contract.
478     function upgrade(uint _value) external {
479         UpgradeState state = getUpgradeState();
480         
481         // Check upgrate state 
482         require(state == UpgradeState.ReadyToUpgrade || state == UpgradeState.Upgrading);
483         // Validate input value
484         require(_value != 0);
485 
486         balances[msg.sender] = balances[msg.sender].sub(_value);
487 
488         // Take tokens out from circulation
489         totalSupply_ = totalSupply_.sub(_value);
490         totalUpgraded = totalUpgraded.add(_value);
491 
492         // Token Upgrader reissues the tokens
493         tokenUpgrader.upgradeFrom(msg.sender, _value);
494         emit Upgrade(msg.sender, tokenUpgrader, _value);
495     }
496 
497     /**
498     * Change the upgrade master.
499     * This allows us to set a new owner for the upgrade mechanism.
500     */
501     function setUpgradeMaster(address _newMaster) external onlyUpgradeMaster {
502         require(_newMaster != address(0));
503         upgradeMaster = _newMaster;
504     }
505 
506     // To be overriden to add functionality
507     function allowUpgrades() external onlyUpgradeMaster () {
508         upgradesAllowed = true;
509     }
510 
511     // To be overriden to add functionality
512     function rejectUpgrades() external onlyUpgradeMaster () {
513         require(!(totalUpgraded > 0));
514         upgradesAllowed = false;
515     }
516 
517     // Get the state of the token upgrade.
518     function getUpgradeState() public view returns(UpgradeState) {
519         if (!canUpgrade()) return UpgradeState.NotAllowed;
520         else if (address(tokenUpgrader) == address(0)) return UpgradeState.Waiting;
521         else if (totalUpgraded == 0) return UpgradeState.ReadyToUpgrade;
522         else return UpgradeState.Upgrading;
523     }
524 
525     // To be overriden to add functionality
526     function canUpgrade() public view returns(bool) {
527         return upgradesAllowed;
528     }
529 }
530 
531 
532 contract Token is UpgradeableToken, BurnableToken {
533     using SafeMath for uint256;
534     
535     string public name = "VERA";
536     string public symbol = "VRA";
537     uint256 public maxTokenSupply;
538     string public constant TERMS_AND_CONDITION =  "THE DIGITAL TOKENS REPRESENTED BY THIS BLOCKCHAIN LEDGER RECORD HAVE BEEN ACQUIRED FOR INVESTMENT UNDER CERTAIN SECURITIES EXEMPTIONS AND HAVE NOT BEEN REGISTERED UNDER THE U.S. SECURITIES ACT OF 1933, AS AMENDED (THE 'ACT'). UNTIL THE EXPIRATION OF THIS RESTRICTIVE LEGEND, SUCH TOKENS MAY NOT BE OFFERED, SOLD, ASSIGNED, TRANSFERRED, PLEDGED, ENCUMBERED OR OTHERWISE DISPOSED OF TO ANOTHER U.S. PERSON IN THE ABSENCE OF A REGISTRATION OR AN EXEMPTION THEREFROM UNDER THE ACT AND ANY APPLICABLE U.S. STATE SECURITIES LAWS. THE APPLICABLE RESTRICTED PERIOD (PER RULE 144 PROMULGATED UNDER THE ACT) IS ONE YEAR FROM THE ISSUANCE OF THE TOKENS. ANY PARTIES, INCLUDING EXCHANGES AND THE ORIGINAL ACQUIRERS OF THESE TOKENS, MAY BE HELD LIABLE FOR ANY UNAUTHORIZED TRANSFERS OR SALES OF THESE TOKENS DURING THE RESTRICTIVE PERIOD, AND ANY HOLDER OR ACQUIRER OF THESE TOKENS AGREES, AS A CONDITION OF SUCH HOLDING, THAT THE TOKEN GENERATOR/ISSUER (THE 'COMPANY') SHALL BE FREE OF ANY LIABILITY IN CONNECTION WITH SUCH UNAUTHORIZED TRANSACTIONS. REQUESTS TO TRANSFER THESE TOKENS DURING THE RESTRICTIVE PERIOD WITH LEGAL JUSTIFICATION MAY BE MADE BY WRITTEN REQUEST OF THE HOLDER OF THESE TOKENS TO THE COMPANY, WITH NO GUARANTEE OF APPROVAL.";
539     uint8 public constant decimals = 18;
540 
541     event UpdatedTokenInformation(string newName, string newSymbol);
542 
543     function Token(address _vraWallet, address _upgradeMaster, uint256 _maxTokenSupply)
544         public
545         UpgradeableToken(_upgradeMaster)
546     {
547         maxTokenSupply = _maxTokenSupply.mul(10 ** uint256(decimals));
548         vraWallet = _vraWallet;
549         totalSupply_ = maxTokenSupply;
550         balances[vraWallet] = totalSupply_;
551         pause();
552         emit Mint(vraWallet, totalSupply_);
553         emit Transfer(address(0), vraWallet, totalSupply_);
554     }
555 
556     /**
557     * Owner can update token information here
558     */
559     function setTokenInformation(string _name, string _symbol) external onlyOwner {
560         name = _name;
561         symbol = _symbol;
562 
563         emit UpdatedTokenInformation(name, symbol);
564     }
565 
566     /**
567     * Owner can burn token here
568     */
569     function burn(uint256 _value) public onlyOwner {
570         super.burn(_value);
571     }
572 
573 }