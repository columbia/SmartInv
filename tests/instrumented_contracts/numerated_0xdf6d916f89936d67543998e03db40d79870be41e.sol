1 pragma solidity ^0.5.0;
2 
3 /**
4  * @title ERC20 interface
5  * @dev see https://github.com/ethereum/EIPs/issues/20
6  */
7 interface IERC20 {
8     function transfer(address to, uint256 value) external returns (bool);
9 
10     function approve(address spender, uint256 value) external returns (bool);
11 
12     function transferFrom(address from, address to, uint256 value) external returns (bool);
13 
14     function totalSupply() external view returns (uint256);
15 
16     function balanceOf(address who) external view returns (uint256);
17 
18     function allowance(address owner, address spender) external view returns (uint256);
19 
20     event Transfer(address indexed from, address indexed to, uint256 value);
21 
22     event Approval(address indexed owner, address indexed spender, uint256 value);
23 }
24 
25 /**
26  * @title SafeMath
27  * @dev Unsigned math operations with safety checks that revert on error
28  */
29 library SafeMath {
30     /**
31     * @dev Multiplies two unsigned integers, reverts on overflow.
32     */
33     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
34         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
35         // benefit is lost if 'b' is also tested.
36         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
37         if (a == 0) {
38             return 0;
39         }
40 
41         uint256 c = a * b;
42         require(c / a == b);
43 
44         return c;
45     }
46 
47     /**
48     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
49     */
50     function div(uint256 a, uint256 b) internal pure returns (uint256) {
51         // Solidity only automatically asserts when dividing by 0
52         require(b > 0);
53         uint256 c = a / b;
54         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
55 
56         return c;
57     }
58 
59     /**
60     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
61     */
62     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
63         require(b <= a);
64         uint256 c = a - b;
65 
66         return c;
67     }
68 
69     /**
70     * @dev Adds two unsigned integers, reverts on overflow.
71     */
72     function add(uint256 a, uint256 b) internal pure returns (uint256) {
73         uint256 c = a + b;
74         require(c >= a);
75 
76         return c;
77     }
78 
79     /**
80     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
81     * reverts when dividing by zero.
82     */
83     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
84         require(b != 0);
85         return a % b;
86     }
87 }
88 
89 
90 /**
91  * @title Standard ERC20 token
92  *
93  * @dev Implementation of the basic standard token.
94  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
95  * Originally based on code by FirstBlood:
96  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
97  *
98  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
99  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
100  * compliant implementations may not do it.
101  */
102 contract ERC20 is IERC20 {
103     using SafeMath for uint256;
104 
105     mapping (address => uint256) private _balances;
106 
107     mapping (address => mapping (address => uint256)) private _allowed;
108 
109     uint256 private _totalSupply;
110 
111     /**
112     * @dev Total number of tokens in existence
113     */
114     function totalSupply() public view returns (uint256) {
115         return _totalSupply;
116     }
117 
118     /**
119     * @dev Gets the balance of the specified address.
120     * @param owner The address to query the balance of.
121     * @return An uint256 representing the amount owned by the passed address.
122     */
123     function balanceOf(address owner) public view returns (uint256) {
124         return _balances[owner];
125     }
126 
127     /**
128      * @dev Function to check the amount of tokens that an owner allowed to a spender.
129      * @param owner address The address which owns the funds.
130      * @param spender address The address which will spend the funds.
131      * @return A uint256 specifying the amount of tokens still available for the spender.
132      */
133     function allowance(address owner, address spender) public view returns (uint256) {
134         return _allowed[owner][spender];
135     }
136 
137     /**
138     * @dev Transfer token for a specified address
139     * @param to The address to transfer to.
140     * @param value The amount to be transferred.
141     */
142     function transfer(address to, uint256 value) public returns (bool) {
143         _transfer(msg.sender, to, value);
144         return true;
145     }
146 
147     /**
148      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
149      * Beware that changing an allowance with this method brings the risk that someone may use both the old
150      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
151      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
152      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
153      * @param spender The address which will spend the funds.
154      * @param value The amount of tokens to be spent.
155      */
156     function approve(address spender, uint256 value) public returns (bool) {
157         require(spender != address(0));
158 
159         _allowed[msg.sender][spender] = value;
160         emit Approval(msg.sender, spender, value);
161         return true;
162     }
163 
164     /**
165      * @dev Transfer tokens from one address to another.
166      * Note that while this function emits an Approval event, this is not required as per the specification,
167      * and other compliant implementations may not emit the event.
168      * @param from address The address which you want to send tokens from
169      * @param to address The address which you want to transfer to
170      * @param value uint256 the amount of tokens to be transferred
171      */
172     function transferFrom(address from, address to, uint256 value) public returns (bool) {
173         _allowed[from][msg.sender] = _allowed[from][msg.sender].sub(value);
174         _transfer(from, to, value);
175         emit Approval(from, msg.sender, _allowed[from][msg.sender]);
176         return true;
177     }
178 
179     /**
180      * @dev Increase the amount of tokens that an owner allowed to a spender.
181      * approve should be called when allowed_[_spender] == 0. To increment
182      * allowed value is better to use this function to avoid 2 calls (and wait until
183      * the first transaction is mined)
184      * From MonolithDAO Token.sol
185      * Emits an Approval event.
186      * @param spender The address which will spend the funds.
187      * @param addedValue The amount of tokens to increase the allowance by.
188      */
189     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
190         require(spender != address(0));
191 
192         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].add(addedValue);
193         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
194         return true;
195     }
196 
197     /**
198      * @dev Decrease the amount of tokens that an owner allowed to a spender.
199      * approve should be called when allowed_[_spender] == 0. To decrement
200      * allowed value is better to use this function to avoid 2 calls (and wait until
201      * the first transaction is mined)
202      * From MonolithDAO Token.sol
203      * Emits an Approval event.
204      * @param spender The address which will spend the funds.
205      * @param subtractedValue The amount of tokens to decrease the allowance by.
206      */
207     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
208         require(spender != address(0));
209 
210         _allowed[msg.sender][spender] = _allowed[msg.sender][spender].sub(subtractedValue);
211         emit Approval(msg.sender, spender, _allowed[msg.sender][spender]);
212         return true;
213     }
214 
215     /**
216     * @dev Transfer token for a specified addresses
217     * @param from The address to transfer from.
218     * @param to The address to transfer to.
219     * @param value The amount to be transferred.
220     */
221     function _transfer(address from, address to, uint256 value) internal {
222         require(to != address(0));
223 
224         _balances[from] = _balances[from].sub(value);
225         _balances[to] = _balances[to].add(value);
226         emit Transfer(from, to, value);
227     }
228 
229     /**
230      * @dev Internal function that mints an amount of the token and assigns it to
231      * an account. This encapsulates the modification of balances such that the
232      * proper events are emitted.
233      * @param account The account that will receive the created tokens.
234      * @param value The amount that will be created.
235      */
236     function _mint(address account, uint256 value) internal {
237         require(account != address(0));
238 
239         _totalSupply = _totalSupply.add(value);
240         _balances[account] = _balances[account].add(value);
241         emit Transfer(address(0), account, value);
242     }
243 
244     /**
245      * @dev Internal function that burns an amount of the token of a given
246      * account.
247      * @param account The account whose tokens will be burnt.
248      * @param value The amount that will be burnt.
249      */
250     function _burn(address account, uint256 value) internal {
251         require(account != address(0));
252 
253         _totalSupply = _totalSupply.sub(value);
254         _balances[account] = _balances[account].sub(value);
255         emit Transfer(account, address(0), value);
256     }
257 
258     /**
259      * @dev Internal function that burns an amount of the token of a given
260      * account, deducting from the sender's allowance for said account. Uses the
261      * internal burn function.
262      * Emits an Approval event (reflecting the reduced allowance).
263      * @param account The account whose tokens will be burnt.
264      * @param value The amount that will be burnt.
265      */
266     function _burnFrom(address account, uint256 value) internal {
267         _allowed[account][msg.sender] = _allowed[account][msg.sender].sub(value);
268         _burn(account, value);
269         emit Approval(account, msg.sender, _allowed[account][msg.sender]);
270     }
271 }
272 
273 
274 /**
275  * @title Roles
276  * @dev Library for managing addresses assigned to a Role.
277  */
278 library Roles {
279     struct Role {
280         mapping (address => bool) bearer;
281     }
282 
283     /**
284      * @dev give an account access to this role
285      */
286     function add(Role storage role, address account) internal {
287         require(account != address(0));
288         require(!has(role, account));
289 
290         role.bearer[account] = true;
291     }
292 
293     /**
294      * @dev remove an account's access to this role
295      */
296     function remove(Role storage role, address account) internal {
297         require(account != address(0));
298         require(has(role, account));
299 
300         role.bearer[account] = false;
301     }
302 
303     /**
304      * @dev check if an account has this role
305      * @return bool
306      */
307     function has(Role storage role, address account) internal view returns (bool) {
308         require(account != address(0));
309         return role.bearer[account];
310     }
311 }
312 
313 contract MinterRole {
314     using Roles for Roles.Role;
315 
316     event MinterAdded(address indexed account);
317     event MinterRemoved(address indexed account);
318 
319     Roles.Role private _minters;
320 
321     constructor () internal {
322         _addMinter(msg.sender);
323     }
324 
325     modifier onlyMinter() {
326         require(isMinter(msg.sender));
327         _;
328     }
329 
330     function isMinter(address account) public view returns (bool) {
331         return _minters.has(account);
332     }
333 
334     function addMinter(address account) public onlyMinter {
335         _addMinter(account);
336     }
337 
338     function renounceMinter() public {
339         _removeMinter(msg.sender);
340     }
341 
342     function _addMinter(address account) internal {
343         _minters.add(account);
344         emit MinterAdded(account);
345     }
346 
347     function _removeMinter(address account) internal {
348         _minters.remove(account);
349         emit MinterRemoved(account);
350     }
351 }
352 
353 
354 /**
355  * @title ERC20Mintable
356  * @dev ERC20 minting logic
357  */
358 contract ERC20Mintable is ERC20, MinterRole {
359     /**
360      * @dev Function to mint tokens
361      * @param to The address that will receive the minted tokens.
362      * @param value The amount of tokens to mint.
363      * @return A boolean that indicates if the operation was successful.
364      */
365     function mint(address to, uint256 value) public onlyMinter returns (bool) {
366         _mint(to, value);
367         return true;
368     }
369 }
370 
371 
372 
373 contract PauserRole {
374     using Roles for Roles.Role;
375 
376     event PauserAdded(address indexed account);
377     event PauserRemoved(address indexed account);
378 
379     Roles.Role private _pausers;
380 
381     constructor () internal {
382         _addPauser(msg.sender);
383     }
384 
385     modifier onlyPauser() {
386         require(isPauser(msg.sender));
387         _;
388     }
389 
390     function isPauser(address account) public view returns (bool) {
391         return _pausers.has(account);
392     }
393 
394     function addPauser(address account) public onlyPauser {
395         _addPauser(account);
396     }
397 
398     function renouncePauser() public {
399         _removePauser(msg.sender);
400     }
401 
402     function _addPauser(address account) internal {
403         _pausers.add(account);
404         emit PauserAdded(account);
405     }
406 
407     function _removePauser(address account) internal {
408         _pausers.remove(account);
409         emit PauserRemoved(account);
410     }
411 }
412 
413 /**
414  * @title Pausable
415  * @dev Base contract which allows children to implement an emergency stop mechanism.
416  */
417 contract Pausable is PauserRole {
418     event Paused(address account);
419     event Unpaused(address account);
420 
421     bool private _paused;
422 
423     constructor () internal {
424         _paused = false;
425     }
426 
427     /**
428      * @return true if the contract is paused, false otherwise.
429      */
430     function paused() public view returns (bool) {
431         return _paused;
432     }
433 
434     /**
435      * @dev Modifier to make a function callable only when the contract is not paused.
436      */
437     modifier whenNotPaused() {
438         require(!_paused);
439         _;
440     }
441 
442     /**
443      * @dev Modifier to make a function callable only when the contract is paused.
444      */
445     modifier whenPaused() {
446         require(_paused);
447         _;
448     }
449 
450     /**
451      * @dev called by the owner to pause, triggers stopped state
452      */
453     function pause() public onlyPauser whenNotPaused {
454         _paused = true;
455         emit Paused(msg.sender);
456     }
457 
458     /**
459      * @dev called by the owner to unpause, returns to normal state
460      */
461     function unpause() public onlyPauser whenPaused {
462         _paused = false;
463         emit Unpaused(msg.sender);
464     }
465 }
466 
467 
468 /**
469  * @title Helps contracts guard against reentrancy attacks.
470  * @author Remco Bloemen <remco@2π.com>, Eenae <alexey@mixbytes.io>
471  * @dev If you mark a function `nonReentrant`, you should also
472  * mark it `external`.
473  */
474 contract ReentrancyGuard {
475     /// @dev counter to allow mutex lock with only one SSTORE operation
476     uint256 private _guardCounter;
477 
478     constructor () internal {
479         // The counter starts at one to prevent changing it from zero to a non-zero
480         // value, which is a more expensive operation.
481         _guardCounter = 1;
482     }
483 
484     /**
485      * @dev Prevents a contract from calling itself, directly or indirectly.
486      * Calling a `nonReentrant` function from another `nonReentrant`
487      * function is not supported. It is possible to prevent this from happening
488      * by making the `nonReentrant` function external, and make it call a
489      * `private` function that does the actual work.
490      */
491     modifier nonReentrant() {
492         _guardCounter += 1;
493         uint256 localCounter = _guardCounter;
494         _;
495         require(localCounter == _guardCounter);
496     }
497 }
498 
499 /**
500  * @title Ownable
501  * @dev The Ownable contract has an owner address, and provides basic authorization control
502  * functions, this simplifies the implementation of "user permissions".
503  */
504 contract Ownable {
505     address private _owner;
506 
507     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
508 
509     /**
510      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
511      * account.
512      */
513     constructor () internal {
514         _owner = msg.sender;
515         emit OwnershipTransferred(address(0), _owner);
516     }
517 
518     /**
519      * @return the address of the owner.
520      */
521     function owner() public view returns (address) {
522         return _owner;
523     }
524 
525     /**
526      * @dev Throws if called by any account other than the owner.
527      */
528     modifier onlyOwner() {
529         require(isOwner());
530         _;
531     }
532 
533     /**
534      * @return true if `msg.sender` is the owner of the contract.
535      */
536     function isOwner() public view returns (bool) {
537         return msg.sender == _owner;
538     }
539 
540     /**
541      * @dev Allows the current owner to relinquish control of the contract.
542      * @notice Renouncing to ownership will leave the contract without an owner.
543      * It will not be possible to call the functions with the `onlyOwner`
544      * modifier anymore.
545      */
546     function renounceOwnership() public onlyOwner {
547         emit OwnershipTransferred(_owner, address(0));
548         _owner = address(0);
549     }
550 
551     /**
552      * @dev Allows the current owner to transfer control of the contract to a newOwner.
553      * @param newOwner The address to transfer ownership to.
554      */
555     function transferOwnership(address newOwner) public onlyOwner {
556         _transferOwnership(newOwner);
557     }
558 
559     /**
560      * @dev Transfers control of the contract to a newOwner.
561      * @param newOwner The address to transfer ownership to.
562      */
563     function _transferOwnership(address newOwner) internal {
564         require(newOwner != address(0));
565         emit OwnershipTransferred(_owner, newOwner);
566         _owner = newOwner;
567     }
568 }
569 
570 
571 /**
572  * @title Administrable
573  */
574 contract Administrable is Ownable {
575   mapping (address => bool) public administrators;
576   event AddAdministrator(address administrator);
577   event RemoveAdministrator(address administrator);
578 
579   /**
580    * @dev Throws if an account that is not an admin
581    */
582   modifier onlyAdministrator() {
583     require(msg.sender == owner() || isAdministrator(msg.sender));
584     _;
585   }
586 
587   function isAdministrator(address _address) public view returns (bool) {
588     return administrators[_address];
589   }
590 
591   function addAdministrator(address _address) onlyAdministrator public {
592     emit AddAdministrator(_address);
593     administrators[_address] = true;
594   }
595 
596   function removeAdministrator(address _address) onlyAdministrator public {
597     emit RemoveAdministrator(_address);
598     administrators[_address] = false;
599   }
600 
601 }
602 
603 
604 /**
605  * @title WhiteList
606  * @dev The WhiteList shows who can buy a token
607  */
608 contract WhiteList is Administrable {
609     mapping (address => bool) public whitelist;
610     event AddToWhiteList(address investor);
611     event RemoveFromWhiteList(address investor);
612 
613     function addToWhiteList(address _address) onlyAdministrator public {
614       emit AddToWhiteList(_address);
615       whitelist[_address] = true;
616     }
617 
618     function removeFromWhiteList(address _address) onlyAdministrator public {
619       emit RemoveFromWhiteList(_address);
620       whitelist[_address] = false;
621     }
622 
623     function onWhitelist(address _address) public view returns (bool) {
624       return whitelist[_address];
625     }
626 }
627 
628 
629 contract C50 is ERC20Mintable, Pausable, WhiteList, ReentrancyGuard {
630     string public name = "Cryptocurrency 50 Index";
631     string public symbol = "C50";
632     uint8 public decimals = 18;
633     uint256 public constant INITIAL_SUPPLY = 10000000 * (10 ** uint256(18));
634     uint256 public constant MAX_SUPPLY = 250000000000 * (10 ** uint256(18));
635     uint256 public rate; // How many token units a buyer gets per wei
636     address payable private wallet;  // Address where funds are collected
637     uint256 public weiRaised; // Amount of wei raised
638 
639   /**
640    * Event for token purchase logging
641    * @param purchaser who paid for the tokens
642    * @param beneficiary who got the tokens
643    * @param value weis paid for purchase
644    * @param amount amount of tokens purchased
645    */
646   event TokenPurchase(
647     address indexed purchaser,
648     address indexed beneficiary,
649     uint256 value,
650     uint256 amount
651   );
652 
653   event SetWallet(address wallet);
654   event SetRate(uint256 indexed rate);
655 
656   constructor() public {
657     _mint(msg.sender, INITIAL_SUPPLY);
658     rate = 500;
659     wallet = msg.sender;
660   }
661 
662   //Fallback function
663   function () external payable {
664     buyTokens(msg.sender);
665   }
666 
667   function buyTokens(address _beneficiary) whenNotPaused nonReentrant public payable {
668     uint256 _weiAmount = msg.value;
669     require(_beneficiary != address(0));
670     require(_weiAmount > 0);
671     require(onWhitelist(_beneficiary));
672 
673     // calculate token amount to be created
674     uint256 _amount = _weiAmount.mul(rate);
675 
676     // update state
677 
678     require(totalSupply().add(_amount) <= MAX_SUPPLY);
679     _mint(_beneficiary, _amount);
680     weiRaised = weiRaised.add(_weiAmount);
681 
682     address(wallet).transfer(_weiAmount);
683     emit TokenPurchase(msg.sender, _beneficiary, _weiAmount, _amount);
684   }
685 
686 
687   function setWallet(address payable _wallet) onlyOwner whenNotPaused public {
688     require(_wallet != address(0));
689     wallet = _wallet;
690     emit SetWallet(wallet);
691   }
692 
693 
694   function setRate(uint256 _rate) onlyOwner whenNotPaused public {
695     require(_rate > 0);
696     rate = _rate;
697     emit SetRate(rate);
698   }
699 }