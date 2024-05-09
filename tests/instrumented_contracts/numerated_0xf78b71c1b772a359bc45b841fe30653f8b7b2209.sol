1 pragma solidity ^0.4.24;
2 
3 /*******************************************************************************
4  *                                                                             *
5  *                        SHITCOIN INC PROUDLY PRESENTS                        *
6  *                                                                             *
7  *          _____ _     _ _            _   __          __        _     _       * 
8  *         / ____| |   (_| |          (_)  \ \        / /       | |   | |      *
9  *        | (___ | |__  _| |_ ___ ___  _ _ _\ \  /\  / ___  _ __| | __| |      *
10  *         \___ \| '_ \| | __/ __/ _ \| | '_ \ \/  \/ / _ \| '__| |/ _` |      *
11  *         ____) | | | | | || (_| (_) | | | | \  /\  | (_) | |  | | (_| |      *
12  *        |_____/|_| |_|_|\__\___\___/|_|_| |_|\/  \/ \___/|_|  |_|\__,_|💩    *
13  *                                                                             *
14  * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * * *
15  *                                                                             *
16  *  Shitcoin World is the home of the Hodlers, mysterious creatures with the   *
17  *                   ability to generate Original Shitcoins™.                  *
18  *                                                                             *
19  *     Please refer to the Shitcoin World FAQ website for more information     *
20  *                        https://shitcoinworld.com/faq                        *
21  *                                                                             *
22  *      For the latest news and updates, visit https://shitcoinworld.com       *
23  *                                                                             *
24  *******************************************************************************
25 
26                                         yyyyso+:.      ```..```             
27                                        yds+syyhhdho..://////////:-`             
28     STEP INTO                        `:hdysssssoso///:::::::::::://:.           
29       SHITCOIN KINGDOM       `.--:+shdhyysssssso://:::::://::://::://:`         
30                         -/syhdhhhyssoosssssssso:/::::://::::::::/::::+:`        
31                      `/hdyso/////++ossssssssss///://:::::/::::::/:::::+-        
32                     .ydysyssyhhhhhhhhyyyyyyyyy//:/:::::::::::::///::::+:        
33                   `-hddhhhyyysssssssssssssssss///://:::::::::::::/::::/-        
34                ./ydhyysoooossssssssssssssssssso+o/::::/:::::::::::/::/:`        
35              :ydhs+//::/+ossssssssssssssssssssssssoo+/::::://::://://-`         
36  -:-.       odho/::::+ssssssssssssssssssssssssssssssssso+:::::::///:.      .-:- 
37 +dhhdy/`   .ddso::/osssssssyyyyyyyyyyyyyyyyyyyyyyyyyyyyyysso/////oo     `/ydhhd+
38 odys+shh/  .ddyyyyhhhhhhhyyyyyyyssssssssssssssssyyyyyyhhhhhhhyyyydh    /hhoosydo
39 :dhys+/sdy--odddhyysooosssssssyysssssssssssssssssyyyssssssssyyhhddh/.-yho/osyhd:
40  sdyyso+oyddyysso////+ossss/::ohhhhyssssssssssy+::+hhhhssso+//+ossyhddy+ossyydo 
41  `hdyyssooydhssssssssssssh.   `yddddysssssssyh:    sddddyssssooossshdyossssydh` 
42   :dhysssssshdssssssssssydh+/+ydhyhdhssssssshdh+:/sddhhdhsssssssssdhssssssyhd:  
43   oddyysssssshyssssssssssddddddd/`/dysssssssydddddddo`:dyssssssssyhsssssssydo   
44  +dhddyssssssysssssssssssshdddddddhyssssoosssshdddddddhssssssssssyyssssssydds   
45 `hdyydhsssssssssssosssssssssssyysssssso/:/+sssssssysssssssssossossssssssshddd-  
46 .ddyyhhsssssssssssyssssssssssssssssssssssssssssssssssssssssyysssssssssssshhhd:  
47 .ddyyyyssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssyydd.  
48  ydyyyyssssssssssssssssssssssssyysssssssssssssssyysssssssssssssssssssssssyhds   
49  :dhyyyyssssssssssssssssssssssyddhsssssssssssssyddysssssssssssssssssssssyhdy`   
50   /ddyyyyssssssssssssssssssssssydddhyssssssssydddyssssssssssssssssssssyyhdo`    
51    .oddhyyyssssssssssssssssssssssyhddddddddddddhsssssssssssssssssssyyhhds.      
52      `:oyhdhhhyyssssssssssssssssssssssyyyyyysssssssssssssssssssyhhhdhs/`        
53           `-:/osyhdhhhhyyyyyyssssssssssssssssssssssssyyyyhhhdhyso/-.            
54                   ``.-://+oosssyyyyhhhhhhhhhhhhyyyssso++/:-.`
55                   
56 */
57 
58 // File: openzeppelin-solidity/contracts/token/ERC20/ERC20.sol
59 
60 /**
61  * @title ERC20 interface
62  * @dev see https://github.com/ethereum/EIPs/issues/20
63  */
64 contract ERC20 {
65   function totalSupply() public view returns (uint256);
66 
67   function balanceOf(address _who) public view returns (uint256);
68 
69   function allowance(address _owner, address _spender)
70     public view returns (uint256);
71 
72   function transfer(address _to, uint256 _value) public returns (bool);
73 
74   function approve(address _spender, uint256 _value)
75     public returns (bool);
76 
77   function transferFrom(address _from, address _to, uint256 _value)
78     public returns (bool);
79 
80   event Transfer(
81     address indexed from,
82     address indexed to,
83     uint256 value
84   );
85 
86   event Approval(
87     address indexed owner,
88     address indexed spender,
89     uint256 value
90   );
91 }
92 
93 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
94 
95 /**
96  * @title SafeMath
97  * @dev Math operations with safety checks that revert on error
98  */
99 library SafeMath {
100 
101   /**
102   * @dev Multiplies two numbers, reverts on overflow.
103   */
104   function mul(uint256 _a, uint256 _b) internal pure returns (uint256) {
105     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
106     // benefit is lost if 'b' is also tested.
107     // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
108     if (_a == 0) {
109       return 0;
110     }
111 
112     uint256 c = _a * _b;
113     require(c / _a == _b);
114 
115     return c;
116   }
117 
118   /**
119   * @dev Integer division of two numbers truncating the quotient, reverts on division by zero.
120   */
121   function div(uint256 _a, uint256 _b) internal pure returns (uint256) {
122     require(_b > 0); // Solidity only automatically asserts when dividing by 0
123     uint256 c = _a / _b;
124     // assert(_a == _b * c + _a % _b); // There is no case in which this doesn't hold
125 
126     return c;
127   }
128 
129   /**
130   * @dev Subtracts two numbers, reverts on overflow (i.e. if subtrahend is greater than minuend).
131   */
132   function sub(uint256 _a, uint256 _b) internal pure returns (uint256) {
133     require(_b <= _a);
134     uint256 c = _a - _b;
135 
136     return c;
137   }
138 
139   /**
140   * @dev Adds two numbers, reverts on overflow.
141   */
142   function add(uint256 _a, uint256 _b) internal pure returns (uint256) {
143     uint256 c = _a + _b;
144     require(c >= _a);
145 
146     return c;
147   }
148 
149   /**
150   * @dev Divides two numbers and returns the remainder (unsigned integer modulo),
151   * reverts when dividing by zero.
152   */
153   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
154     require(b != 0);
155     return a % b;
156   }
157 }
158 
159 // File: openzeppelin-solidity/contracts/token/ERC20/StandardToken.sol
160 
161 /**
162  * @title Standard ERC20 token
163  *
164  * @dev Implementation of the basic standard token.
165  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
166  * Based on code by FirstBlood: https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
167  */
168 contract StandardToken is ERC20 {
169   using SafeMath for uint256;
170 
171   mapping (address => uint256) private balances;
172 
173   mapping (address => mapping (address => uint256)) private allowed;
174 
175   uint256 private totalSupply_;
176 
177   /**
178   * @dev Total number of tokens in existence
179   */
180   function totalSupply() public view returns (uint256) {
181     return totalSupply_;
182   }
183 
184   /**
185   * @dev Gets the balance of the specified address.
186   * @param _owner The address to query the the balance of.
187   * @return An uint256 representing the amount owned by the passed address.
188   */
189   function balanceOf(address _owner) public view returns (uint256) {
190     return balances[_owner];
191   }
192 
193   /**
194    * @dev Function to check the amount of tokens that an owner allowed to a spender.
195    * @param _owner address The address which owns the funds.
196    * @param _spender address The address which will spend the funds.
197    * @return A uint256 specifying the amount of tokens still available for the spender.
198    */
199   function allowance(
200     address _owner,
201     address _spender
202    )
203     public
204     view
205     returns (uint256)
206   {
207     return allowed[_owner][_spender];
208   }
209 
210   /**
211   * @dev Transfer token for a specified address
212   * @param _to The address to transfer to.
213   * @param _value The amount to be transferred.
214   */
215   function transfer(address _to, uint256 _value) public returns (bool) {
216     require(_value <= balances[msg.sender]);
217     require(_to != address(0));
218 
219     balances[msg.sender] = balances[msg.sender].sub(_value);
220     balances[_to] = balances[_to].add(_value);
221     emit Transfer(msg.sender, _to, _value);
222     return true;
223   }
224 
225   /**
226    * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
227    * Beware that changing an allowance with this method brings the risk that someone may use both the old
228    * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
229    * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
230    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
231    * @param _spender The address which will spend the funds.
232    * @param _value The amount of tokens to be spent.
233    */
234   function approve(address _spender, uint256 _value) public returns (bool) {
235     allowed[msg.sender][_spender] = _value;
236     emit Approval(msg.sender, _spender, _value);
237     return true;
238   }
239 
240   /**
241    * @dev Transfer tokens from one address to another
242    * @param _from address The address which you want to send tokens from
243    * @param _to address The address which you want to transfer to
244    * @param _value uint256 the amount of tokens to be transferred
245    */
246   function transferFrom(
247     address _from,
248     address _to,
249     uint256 _value
250   )
251     public
252     returns (bool)
253   {
254     require(_value <= balances[_from]);
255     require(_value <= allowed[_from][msg.sender]);
256     require(_to != address(0));
257 
258     balances[_from] = balances[_from].sub(_value);
259     balances[_to] = balances[_to].add(_value);
260     allowed[_from][msg.sender] = allowed[_from][msg.sender].sub(_value);
261     emit Transfer(_from, _to, _value);
262     return true;
263   }
264 
265   /**
266    * @dev Increase the amount of tokens that an owner allowed to a spender.
267    * approve should be called when allowed[_spender] == 0. To increment
268    * allowed value is better to use this function to avoid 2 calls (and wait until
269    * the first transaction is mined)
270    * From MonolithDAO Token.sol
271    * @param _spender The address which will spend the funds.
272    * @param _addedValue The amount of tokens to increase the allowance by.
273    */
274   function increaseApproval(
275     address _spender,
276     uint256 _addedValue
277   )
278     public
279     returns (bool)
280   {
281     allowed[msg.sender][_spender] = (
282       allowed[msg.sender][_spender].add(_addedValue));
283     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
284     return true;
285   }
286 
287   /**
288    * @dev Decrease the amount of tokens that an owner allowed to a spender.
289    * approve should be called when allowed[_spender] == 0. To decrement
290    * allowed value is better to use this function to avoid 2 calls (and wait until
291    * the first transaction is mined)
292    * From MonolithDAO Token.sol
293    * @param _spender The address which will spend the funds.
294    * @param _subtractedValue The amount of tokens to decrease the allowance by.
295    */
296   function decreaseApproval(
297     address _spender,
298     uint256 _subtractedValue
299   )
300     public
301     returns (bool)
302   {
303     uint256 oldValue = allowed[msg.sender][_spender];
304     if (_subtractedValue >= oldValue) {
305       allowed[msg.sender][_spender] = 0;
306     } else {
307       allowed[msg.sender][_spender] = oldValue.sub(_subtractedValue);
308     }
309     emit Approval(msg.sender, _spender, allowed[msg.sender][_spender]);
310     return true;
311   }
312 
313   /**
314    * @dev Internal function that mints an amount of the token and assigns it to
315    * an account. This encapsulates the modification of balances such that the
316    * proper events are emitted.
317    * @param _account The account that will receive the created tokens.
318    * @param _amount The amount that will be created.
319    */
320   function _mint(address _account, uint256 _amount) internal {
321     require(_account != 0);
322     totalSupply_ = totalSupply_.add(_amount);
323     balances[_account] = balances[_account].add(_amount);
324     emit Transfer(address(0), _account, _amount);
325   }
326 
327   /**
328    * @dev Internal function that burns an amount of the token of a given
329    * account.
330    * @param _account The account whose tokens will be burnt.
331    * @param _amount The amount that will be burnt.
332    */
333   function _burn(address _account, uint256 _amount) internal {
334     require(_account != 0);
335     require(_amount <= balances[_account]);
336 
337     totalSupply_ = totalSupply_.sub(_amount);
338     balances[_account] = balances[_account].sub(_amount);
339     emit Transfer(_account, address(0), _amount);
340   }
341 
342   /**
343    * @dev Internal function that burns an amount of the token of a given
344    * account, deducting from the sender's allowance for said account. Uses the
345    * internal _burn function.
346    * @param _account The account whose tokens will be burnt.
347    * @param _amount The amount that will be burnt.
348    */
349   function _burnFrom(address _account, uint256 _amount) internal {
350     require(_amount <= allowed[_account][msg.sender]);
351 
352     // Should https://github.com/OpenZeppelin/zeppelin-solidity/issues/707 be accepted,
353     // this function needs to emit an event with the updated approval.
354     allowed[_account][msg.sender] = allowed[_account][msg.sender].sub(_amount);
355     _burn(_account, _amount);
356   }
357 }
358 
359 // File: openzeppelin-solidity/contracts/ownership/Ownable.sol
360 
361 /**
362  * @title Ownable
363  * @dev The Ownable contract has an owner address, and provides basic authorization control
364  * functions, this simplifies the implementation of "user permissions".
365  */
366 contract Ownable {
367   address public owner;
368 
369 
370   event OwnershipRenounced(address indexed previousOwner);
371   event OwnershipTransferred(
372     address indexed previousOwner,
373     address indexed newOwner
374   );
375 
376 
377   /**
378    * @dev The Ownable constructor sets the original `owner` of the contract to the sender
379    * account.
380    */
381   constructor() public {
382     owner = msg.sender;
383   }
384 
385   /**
386    * @dev Throws if called by any account other than the owner.
387    */
388   modifier onlyOwner() {
389     require(msg.sender == owner);
390     _;
391   }
392 
393   /**
394    * @dev Allows the current owner to relinquish control of the contract.
395    * @notice Renouncing to ownership will leave the contract without an owner.
396    * It will not be possible to call the functions with the `onlyOwner`
397    * modifier anymore.
398    */
399   function renounceOwnership() public onlyOwner {
400     emit OwnershipRenounced(owner);
401     owner = address(0);
402   }
403 
404   /**
405    * @dev Allows the current owner to transfer control of the contract to a newOwner.
406    * @param _newOwner The address to transfer ownership to.
407    */
408   function transferOwnership(address _newOwner) public onlyOwner {
409     _transferOwnership(_newOwner);
410   }
411 
412   /**
413    * @dev Transfers control of the contract to a newOwner.
414    * @param _newOwner The address to transfer ownership to.
415    */
416   function _transferOwnership(address _newOwner) internal {
417     require(_newOwner != address(0));
418     emit OwnershipTransferred(owner, _newOwner);
419     owner = _newOwner;
420   }
421 }
422 
423 // File: openzeppelin-solidity/contracts/lifecycle/Pausable.sol
424 
425 /**
426  * @title Pausable
427  * @dev Base contract which allows children to implement an emergency stop mechanism.
428  */
429 contract Pausable is Ownable {
430   event Pause();
431   event Unpause();
432 
433   bool public paused = false;
434 
435 
436   /**
437    * @dev Modifier to make a function callable only when the contract is not paused.
438    */
439   modifier whenNotPaused() {
440     require(!paused);
441     _;
442   }
443 
444   /**
445    * @dev Modifier to make a function callable only when the contract is paused.
446    */
447   modifier whenPaused() {
448     require(paused);
449     _;
450   }
451 
452   /**
453    * @dev called by the owner to pause, triggers stopped state
454    */
455   function pause() public onlyOwner whenNotPaused {
456     paused = true;
457     emit Pause();
458   }
459 
460   /**
461    * @dev called by the owner to unpause, returns to normal state
462    */
463   function unpause() public onlyOwner whenPaused {
464     paused = false;
465     emit Unpause();
466   }
467 }
468 
469 // File: openzeppelin-solidity/contracts/token/ERC20/PausableToken.sol
470 
471 /**
472  * @title Pausable token
473  * @dev StandardToken modified with pausable transfers.
474  **/
475 contract PausableToken is StandardToken, Pausable {
476 
477   function transfer(
478     address _to,
479     uint256 _value
480   )
481     public
482     whenNotPaused
483     returns (bool)
484   {
485     return super.transfer(_to, _value);
486   }
487 
488   function transferFrom(
489     address _from,
490     address _to,
491     uint256 _value
492   )
493     public
494     whenNotPaused
495     returns (bool)
496   {
497     return super.transferFrom(_from, _to, _value);
498   }
499 
500   function approve(
501     address _spender,
502     uint256 _value
503   )
504     public
505     whenNotPaused
506     returns (bool)
507   {
508     return super.approve(_spender, _value);
509   }
510 
511   function increaseApproval(
512     address _spender,
513     uint _addedValue
514   )
515     public
516     whenNotPaused
517     returns (bool success)
518   {
519     return super.increaseApproval(_spender, _addedValue);
520   }
521 
522   function decreaseApproval(
523     address _spender,
524     uint _subtractedValue
525   )
526     public
527     whenNotPaused
528     returns (bool success)
529   {
530     return super.decreaseApproval(_spender, _subtractedValue);
531   }
532 }
533 
534 // File: openzeppelin-solidity/contracts/token/ERC20/MintableToken.sol
535 
536 /**
537  * @title Mintable token
538  * @dev Simple ERC20 Token example, with mintable token creation
539  * Based on code by TokenMarketNet: https://github.com/TokenMarketNet/ico/blob/master/contracts/MintableToken.sol
540  */
541 contract MintableToken is StandardToken, Ownable {
542   event Mint(address indexed to, uint256 amount);
543   event MintFinished();
544 
545   bool public mintingFinished = false;
546 
547 
548   modifier canMint() {
549     require(!mintingFinished);
550     _;
551   }
552 
553   modifier hasMintPermission() {
554     require(msg.sender == owner);
555     _;
556   }
557 
558   /**
559    * @dev Function to mint tokens
560    * @param _to The address that will receive the minted tokens.
561    * @param _amount The amount of tokens to mint.
562    * @return A boolean that indicates if the operation was successful.
563    */
564   function mint(
565     address _to,
566     uint256 _amount
567   )
568     public
569     hasMintPermission
570     canMint
571     returns (bool)
572   {
573     _mint(_to, _amount);
574     emit Mint(_to, _amount);
575     return true;
576   }
577 
578   /**
579    * @dev Function to stop minting new tokens.
580    * @return True if the operation was successful.
581    */
582   function finishMinting() public onlyOwner canMint returns (bool) {
583     mintingFinished = true;
584     emit MintFinished();
585     return true;
586   }
587 }
588 
589 // File: 💩.sol
590 
591 contract OriginalShitcoin is PausableToken, MintableToken {
592   string public name = "Original Shitcoin™";
593   string public symbol = "💩";
594   uint8 public decimals = 8;
595 }