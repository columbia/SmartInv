1 pragma solidity ^0.5.7;
2 
3 
4 /**
5  * @title ERC20 interface
6  * @dev see https://eips.ethereum.org/EIPS/eip-20
7  */
8 interface IERC20 {
9     function transfer(address to, uint256 value) external returns (bool);
10 
11     function approve(address spender, uint256 value) external returns (bool);
12 
13     function transferFrom(address from, address to, uint256 value) external returns (bool);
14 
15     function totalSupply() external view returns (uint256);
16 
17     function balanceOf(address who) external view returns (uint256);
18 
19     function allowance(address owner, address spender) external view returns (uint256);
20 
21     event Transfer(address indexed from, address indexed to, uint256 value);
22 
23     event Approval(address indexed owner, address indexed spender, uint256 value);
24     
25     event Freeze(address indexed from, uint256 value);
26     
27     event Unfreeze(address indexed from, uint256 value);
28 }
29 
30 
31 
32 /**
33  * @title SafeMath
34  * @dev Unsigned math operations with safety checks that revert on error.
35  */
36 library SafeMath {
37     /**
38      * @dev Multiplies two unsigned integers, reverts on overflow.
39      */
40     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
41         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
42         // benefit is lost if 'b' is also tested.
43         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
44         if (a == 0) {
45             return 0;
46         }
47 
48         uint256 c = a * b;
49         require(c / a == b);
50 
51         return c;
52     }
53 
54     /**
55      * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
56      */
57     function div(uint256 a, uint256 b) internal pure returns (uint256) {
58         // Solidity only automatically asserts when dividing by 0
59         require(b > 0);
60         uint256 c = a / b;
61         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
62 
63         return c;
64     }
65 
66     /**
67      * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
68      */
69     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
70         require(b <= a);
71         uint256 c = a - b;
72 
73         return c;
74     }
75 
76     /**
77      * @dev Adds two unsigned integers, reverts on overflow.
78      */
79     function add(uint256 a, uint256 b) internal pure returns (uint256) {
80         uint256 c = a + b;
81         require(c >= a);
82 
83         return c;
84     }
85 
86     /**
87      * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
88      * reverts when dividing by zero.
89      */
90     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
91         require(b != 0);
92         return a % b;
93     }
94 }
95 
96 contract Context {
97     // Empty internal constructor, to prevent people from mistakenly deploying
98     // an instance of this contract, which should be used via inheritance.
99     constructor () internal { }
100     // solhint-disable-previous-line no-empty-blocks
101 
102     function _msgSender() internal view returns (address payable) {
103         return msg.sender;
104     }
105 
106     function _msgData() internal view returns (bytes memory) {
107         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
108         return msg.data;
109     }
110 }
111 
112 /**
113  * @title Standard ERC20 token
114  *
115  * @dev Implementation of the basic standard token.
116  * https://eips.ethereum.org/EIPS/eip-20
117  * Originally based on code by FirstBlood:
118  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
119  *
120  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
121  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
122  * compliant implementations may not do it.
123  */
124 contract ERC20 is IERC20 {
125     using SafeMath for uint256;
126 
127     mapping (address => uint256) private _balances;
128 
129     mapping (address => mapping (address => uint256)) private _allowed;
130     
131     mapping (address => uint256) private _freezeOf;
132     
133     uint256 private _totalSupply;
134 
135     /**
136      * @dev Total number of tokens in existence.
137      */
138     function totalSupply() public view returns (uint256) {
139         return _totalSupply;
140     }
141 
142     /**
143      * @dev Gets the balance of the specified address.
144      * @param owner The address to query the balance of.
145      * @return A uint256 representing the amount owned by the passed address.
146      */
147     function balanceOf(address owner) public view returns (uint256) {
148         return _balances[owner];
149     }
150     
151     /**
152      * @dev Gets the balance of the specified freeze address.
153      * @param owner The address to query the balance of.
154      * @return A uint256 representing the amount owned by the freeze address.
155      */
156     function freezeOf(address owner) public view returns (uint256) {
157         return _freezeOf[owner];
158     }
159 
160     /**
161      * @dev Function to check the amount of tokens that an owner allowed to a spender.
162      * @param owner address The address which owns the funds.
163      * @param spender address The address which will spend the funds.
164      * @return A uint256 specifying the amount of tokens still available for the spender.
165      */
166     function allowance(address owner, address spender) public view returns (uint256) {
167         return _allowed[owner][spender];
168     }
169 
170     /**
171      * @dev Transfer token to a specified address.
172      * @param to The address to transfer to.
173      * @param value The amount to be transferred.
174      */
175     function transfer(address to, uint256 value) public returns (bool) {
176         _transfer(msg.sender, to, value);
177         return true;
178     }
179 
180     /**
181      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
182      * Beware that changing an allowance with this method brings the risk that someone may use both the old
183      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
184      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
185      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
186      * @param spender The address which will spend the funds.
187      * @param value The amount of tokens to be spent.
188      */
189     function approve(address spender, uint256 value) public returns (bool) {
190         _approve(msg.sender, spender, value);
191         return true;
192     }
193 
194     /**
195      * @dev Transfer tokens from one address to another.
196      * Note that while this function emits an Approval event, this is not required as per the specification,
197      * and other compliant implementations may not emit the event.
198      * @param from address The address which you want to send tokens from
199      * @param to address The address which you want to transfer to
200      * @param value uint256 the amount of tokens to be transferred
201      */
202     function transferFrom(address from, address to, uint256 value) public returns (bool) {
203         _transfer(from, to, value);
204         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
205         return true;
206     }
207 
208     /**
209      * @dev Increase the amount of tokens that an owner allowed to a spender.
210      * approve should be called when _allowed[msg.sender][spender] == 0. To increment
211      * allowed value is better to use this function to avoid 2 calls (and wait until
212      * the first transaction is mined)
213      * From MonolithDAO Token.sol
214      * Emits an Approval event.
215      * @param spender The address which will spend the funds.
216      * @param addedValue The amount of tokens to increase the allowance by.
217      */
218     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
219         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
220         return true;
221     }
222 
223     /**
224      * @dev Decrease the amount of tokens that an owner allowed to a spender.
225      * approve should be called when _allowed[msg.sender][spender] == 0. To decrement
226      * allowed value is better to use this function to avoid 2 calls (and wait until
227      * the first transaction is mined)
228      * From MonolithDAO Token.sol
229      * Emits an Approval event.
230      * @param spender The address which will spend the funds.
231      * @param subtractedValue The amount of tokens to decrease the allowance by.
232      */
233     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
234         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
235         return true;
236     }
237 
238     /**
239      * @dev Transfer token for a specified addresses.
240      * @param from The address to transfer from.
241      * @param to The address to transfer to.
242      * @param value The amount to be transferred.
243      */
244     function _transfer(address from, address to, uint256 value) internal {
245         require(to != address(0));
246 
247         _balances[from] = _balances[from].sub(value);
248         _balances[to] = _balances[to].add(value);
249         emit Transfer(from, to, value);
250     }
251 
252     /**
253      * @dev Internal function that mints an amount of the token and assigns it to
254      * an account. This encapsulates the modification of balances such that the
255      * proper events are emitted.
256      * @param account The account that will receive the created tokens.
257      * @param value The amount that will be created.
258      */
259     function _mint(address account, uint256 value) internal {
260         require(account != address(0));
261         _totalSupply = _totalSupply.add(value);
262         _balances[account] = _balances[account].add(value);
263         emit Transfer(address(0), account, value);
264     }
265 
266     /**
267      * @dev Internal function that burns an amount of the token of a given
268      * account.
269      * @param account The account whose tokens will be burnt.
270      * @param value The amount that will be burnt.
271      */
272     function _burn(address account, uint256 value) internal {
273         require(account != address(0));
274         
275         _totalSupply = _totalSupply.sub(value);
276         _balances[account] = _balances[account].sub(value);
277         emit Transfer(account, address(0), value);
278     }
279     
280     function _freeze(uint256 value) internal {
281         require(_balances[msg.sender]>=value); // Check if the sender has enough
282         require(value > 0);
283         _balances[msg.sender] = _balances[msg.sender].sub(value);
284         _freezeOf[msg.sender] = _freezeOf[msg.sender].add(value);
285         emit Freeze(msg.sender, value);
286     }
287     
288     function _unfreeze(uint256 value) internal{
289         require(_freezeOf[msg.sender]>=value); 
290         require(value > 0);
291         _freezeOf[msg.sender] = _freezeOf[msg.sender].sub(value); 
292         _balances[msg.sender] = _balances[msg.sender].add(value);
293         emit Unfreeze(msg.sender, value);
294 
295     }
296     
297     /**
298      * @dev Approve an address to spend another addresses' tokens.
299      * @param owner The address that owns the tokens.
300      * @param spender The address that will spend the tokens.
301      * @param value The number of tokens that can be spent.
302      */
303     function _approve(address owner, address spender, uint256 value) internal {
304         require(spender != address(0));
305         require(owner != address(0));
306 
307         _allowed[owner][spender] = value;
308         emit Approval(owner, spender, value);
309     }
310 
311 }
312 
313 
314 /**
315  * @title ERC20Detailed token
316  * @dev The decimals are only for visualization purposes.
317  * All the operations are done using the smallest and indivisible token unit,
318  * just as on Ethereum all the operations are done in wei.
319  */
320 contract ERC20Detailed is IERC20 {
321     string private _name;
322     string private _symbol;
323     uint8 private _decimals;
324 
325     constructor (string memory name, string memory symbol, uint8 decimals) public {
326         _name = name;
327         _symbol = symbol;
328         _decimals = decimals;
329     }
330 
331     /**
332      * @return the name of the token.
333      */
334     function name() public view returns (string memory) {
335         return _name;
336     }
337 
338     /**
339      * @return the symbol of the token.
340      */
341     function symbol() public view returns (string memory) {
342         return _symbol;
343     }
344 
345     /**
346      * @return the number of decimals of the token.
347      */
348     function decimals() public view returns (uint8) {
349         return _decimals;
350     }
351 }
352 
353 /**
354  * @title Roles
355  * @dev Library for managing addresses assigned to a Role.
356  */
357 library Roles {
358     struct Role {
359         mapping (address => bool) bearer;
360     }
361 
362     /**
363      * @dev Give an account access to this role.
364      */
365     function add(Role storage role, address account) internal {
366         require(!has(role, account));
367 
368         role.bearer[account] = true;
369     }
370 
371     /**
372      * @dev Remove an account's access to this role.
373      */
374     function remove(Role storage role, address account) internal {
375         require(has(role, account));
376 
377         role.bearer[account] = false;
378     }
379 
380     /**
381      * @dev Check if an account has this role.
382      * @return bool
383      */
384     function has(Role storage role, address account) internal view returns (bool) {
385         require(account != address(0));
386         return role.bearer[account];
387     }
388 }
389 
390 
391 contract PauserRole {
392     using Roles for Roles.Role;
393 
394     event PauserAdded(address indexed account);
395     event PauserRemoved(address indexed account);
396 
397     Roles.Role private _pausers;
398 
399     constructor () internal {
400         _addPauser(msg.sender);
401     }
402 
403     modifier onlyPauser() {
404         require(isPauser(msg.sender));
405         _;
406     }
407 
408     function isPauser(address account) public view returns (bool) {
409         return _pausers.has(account);
410     }
411 
412     function addPauser(address account) public onlyPauser {
413         _addPauser(account);
414     }
415 
416     function renouncePauser() public {
417         _removePauser(msg.sender);
418     }
419 
420     function _addPauser(address account) internal {
421         _pausers.add(account);
422         emit PauserAdded(account);
423     }
424 
425     function _removePauser(address account) internal {
426         _pausers.remove(account);
427         emit PauserRemoved(account);
428     }
429 }
430 
431 contract Ownable is Context {
432     address private _owner;
433 
434     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
435 
436     /**
437      * @dev Initializes the contract setting the deployer as the initial owner.
438      */
439     constructor () internal {
440         address msgSender = _msgSender();
441         _owner = msgSender;
442         emit OwnershipTransferred(address(0), msgSender);
443     }
444 
445     /**
446      * @dev Returns the address of the current owner.
447      */
448     function owner() public view returns (address) {
449         return _owner;
450     }
451 
452     /**
453      * @dev Throws if called by any account other than the owner.
454      */
455     modifier onlyOwner() {
456         require(isOwner(), "Ownable: caller is not the owner");
457         _;
458     }
459 
460     /**
461      * @dev Returns true if the caller is the current owner.
462      */
463     function isOwner() public view returns (bool) {
464         return _msgSender() == _owner;
465     }
466 
467     /**
468      * @dev Leaves the contract without owner. It will not be possible to call
469      * `onlyOwner` functions anymore. Can only be called by the current owner.
470      *
471      * NOTE: Renouncing ownership will leave the contract without an owner,
472      * thereby removing any functionality that is only available to the owner.
473      */
474     function renounceOwnership() public onlyOwner {
475         emit OwnershipTransferred(_owner, address(0));
476         _owner = address(0);
477     }
478 
479     /**
480      * @dev Transfers ownership of the contract to a new account (`newOwner`).
481      * Can only be called by the current owner.
482      */
483     function transferOwnership(address newOwner) public onlyOwner {
484         _transferOwnership(newOwner);
485     }
486 
487     /**
488      * @dev Transfers ownership of the contract to a new account (`newOwner`).
489      */
490     function _transferOwnership(address newOwner) internal {
491         require(newOwner != address(0), "Ownable: new owner is the zero address");
492         emit OwnershipTransferred(_owner, newOwner);
493         _owner = newOwner;
494     }
495 }
496 
497 
498 /**
499  * @title Pausable
500  * @dev Base contract which allows children to implement an emergency stop mechanism.
501  */
502 contract Pausable is PauserRole {
503     event Paused(address account);
504     event Unpaused(address account);
505 
506     bool private _paused;
507 
508     constructor () internal {
509         _paused = false;
510     }
511 
512     /**
513      * @return True if the contract is paused, false otherwise.
514      */
515     function paused() public view returns (bool) {
516         return _paused;
517     }
518 
519     /**
520      * @dev Modifier to make a function callable only when the contract is not paused.
521      */
522     modifier whenNotPaused() {
523         require(!_paused);
524         _;
525     }
526 
527     /**
528      * @dev Modifier to make a function callable only when the contract is paused.
529      */
530     modifier whenPaused() {
531         require(_paused);
532         _;
533     }
534 
535     /**
536      * @dev Called by a pauser to pause, triggers stopped state.
537      */
538     function pause() public onlyPauser whenNotPaused {
539         _paused = true;
540         emit Paused(msg.sender);
541     }
542 
543     /**
544      * @dev Called by a pauser to unpause, returns to normal state.
545      */
546     function unpause() public onlyPauser whenPaused {
547         _paused = false;
548         emit Unpaused(msg.sender);
549     }
550 }
551 
552 /**
553  * @title Pausable
554  * @dev Base contract which allows children to implement an emergency stop mechanism.
555  */
556 contract Lockable is PauserRole{
557     
558 
559     mapping (address => bool) private lockers;
560     
561 
562     event LockAccount(address account, bool islock);
563     
564     
565     /**
566      * @dev Check if the account is locked.
567      * @param account specific account address.
568      */
569     function isLock(address account) public view returns (bool) {
570         return lockers[account];
571     }
572     
573     /**
574      * @dev Lock or thaw account address
575      * @param account specific account address.
576      * @param islock true lock, false thaw.
577      */
578     function lock(address account, bool islock)  public onlyPauser {
579         lockers[account] = islock;
580         emit LockAccount(account, islock);
581     }
582     
583 }
584 
585 
586 
587 
588 /**
589  * @title Pausable token
590  * @dev ERC20 modified with pausable transfers. 
591  */
592 contract ERC20Pausable is ERC20, Pausable,Lockable {
593     
594     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
595         require(!isLock(msg.sender));
596         require(!isLock(to));
597         return super.transfer(to, value);
598     }
599 
600     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
601         require(!isLock(msg.sender));
602         require(!isLock(from));
603         require(!isLock(to));
604         return super.transferFrom(from, to, value);
605     }
606 
607     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
608         require(!isLock(msg.sender));
609         require(!isLock(spender));
610         return super.approve(spender, value);
611     }
612 
613     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
614         require(!isLock(msg.sender));
615         require(!isLock(spender));
616         return super.increaseAllowance(spender, addedValue);
617     }
618 
619     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
620         require(!isLock(msg.sender));
621         require(!isLock(spender));
622         return super.decreaseAllowance(spender, subtractedValue);
623     }
624 }
625 
626 
627 contract HooToken is ERC20, ERC20Detailed, ERC20Pausable, Ownable {
628     // metadata
629     string public constant tokenName = "HooToken";
630     string public constant tokenSymbol = "HOO";
631     uint8 public constant decimalUnits = 8;
632     uint256 public constant initialSupply = 1000000000;
633     // address private _owner;
634     
635     constructor(address _addr) ERC20Pausable()  ERC20Detailed(tokenName, tokenSymbol, decimalUnits) ERC20() Ownable()  public {
636         require(initialSupply > 0);
637         _mint(_addr, initialSupply * (10 ** uint256(decimals())));
638     }
639     
640     function mint(uint256 value) public whenNotPaused onlyOwner{
641         _mint(msg.sender, value * (10 ** uint256(decimals())));
642     }
643     
644     /**
645      * @dev Burns a specific amount of tokens.
646      * @param value The amount of token to be burned.
647      */
648     function burn(uint256 value) public whenNotPaused {
649         require(!isLock(msg.sender));
650         _burn(msg.sender, value);
651     }
652     
653     /**
654      * @dev Freeze a specific amount of tokens.
655      * @param value The amount of token to be Freeze.
656      */
657     function freeze(uint256 value) public whenNotPaused {
658         require(!isLock(msg.sender));
659         _freeze(value);
660     }
661     
662         /**
663      * @dev unFreeze a specific amount of tokens.
664      * @param value The amount of token to be unFreeze.
665      */
666     function unfreeze(uint256 value) public whenNotPaused {
667         require(!isLock(msg.sender));
668         _unfreeze(value);
669     }
670     
671 }