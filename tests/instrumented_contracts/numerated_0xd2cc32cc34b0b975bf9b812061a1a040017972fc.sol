1 /**
2  * Copyright (c) 2019 blockimmo AG license@blockimmo.ch
3  * No license
4  */
5 
6 pragma solidity 0.5.4;
7 
8 /**
9  * @title SafeMath
10  * @dev Unsigned math operations with safety checks that revert on error
11  */
12 library SafeMath {
13     /**
14     * @dev Multiplies two unsigned integers, reverts on overflow.
15     */
16     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
17         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
18         // benefit is lost if 'b' is also tested.
19         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
20         if (a == 0) {
21             return 0;
22         }
23 
24         uint256 c = a * b;
25         require(c / a == b);
26 
27         return c;
28     }
29 
30     /**
31     * @dev Integer division of two unsigned integers truncating the quotient, reverts on division by zero.
32     */
33     function div(uint256 a, uint256 b) internal pure returns (uint256) {
34         // Solidity only automatically asserts when dividing by 0
35         require(b > 0);
36         uint256 c = a / b;
37         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
38 
39         return c;
40     }
41 
42     /**
43     * @dev Subtracts two unsigned integers, reverts on overflow (i.e. if subtrahend is greater than minuend).
44     */
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         require(b <= a);
47         uint256 c = a - b;
48 
49         return c;
50     }
51 
52     /**
53     * @dev Adds two unsigned integers, reverts on overflow.
54     */
55     function add(uint256 a, uint256 b) internal pure returns (uint256) {
56         uint256 c = a + b;
57         require(c >= a);
58 
59         return c;
60     }
61 
62     /**
63     * @dev Divides two unsigned integers and returns the remainder (unsigned integer modulo),
64     * reverts when dividing by zero.
65     */
66     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
67         require(b != 0);
68         return a % b;
69     }
70 }
71 
72 /**
73  * @title Ownable
74  * @dev The Ownable contract has an owner address, and provides basic authorization control
75  * functions, this simplifies the implementation of "user permissions".
76  */
77 contract Ownable {
78     address private _owner;
79 
80     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
81 
82     /**
83      * @dev The Ownable constructor sets the original `owner` of the contract to the sender
84      * account.
85      */
86     constructor () internal {
87         _owner = msg.sender;
88         emit OwnershipTransferred(address(0), _owner);
89     }
90 
91     /**
92      * @return the address of the owner.
93      */
94     function owner() public view returns (address) {
95         return _owner;
96     }
97 
98     /**
99      * @dev Throws if called by any account other than the owner.
100      */
101     modifier onlyOwner() {
102         require(isOwner());
103         _;
104     }
105 
106     /**
107      * @return true if `msg.sender` is the owner of the contract.
108      */
109     function isOwner() public view returns (bool) {
110         return msg.sender == _owner;
111     }
112 
113     /**
114      * @dev Allows the current owner to relinquish control of the contract.
115      * @notice Renouncing to ownership will leave the contract without an owner.
116      * It will not be possible to call the functions with the `onlyOwner`
117      * modifier anymore.
118      */
119     function renounceOwnership() public onlyOwner {
120         emit OwnershipTransferred(_owner, address(0));
121         _owner = address(0);
122     }
123 
124     /**
125      * @dev Allows the current owner to transfer control of the contract to a newOwner.
126      * @param newOwner The address to transfer ownership to.
127      */
128     function transferOwnership(address newOwner) public onlyOwner {
129         _transferOwnership(newOwner);
130     }
131 
132     /**
133      * @dev Transfers control of the contract to a newOwner.
134      * @param newOwner The address to transfer ownership to.
135      */
136     function _transferOwnership(address newOwner) internal {
137         require(newOwner != address(0));
138         emit OwnershipTransferred(_owner, newOwner);
139         _owner = newOwner;
140     }
141 }
142 
143 /**
144  * @title ERC20 interface
145  * @dev see https://github.com/ethereum/EIPs/issues/20
146  */
147 interface IERC20 {
148     function transfer(address to, uint256 value) external returns (bool);
149 
150     function approve(address spender, uint256 value) external returns (bool);
151 
152     function transferFrom(address from, address to, uint256 value) external returns (bool);
153 
154     function totalSupply() external view returns (uint256);
155 
156     function balanceOf(address who) external view returns (uint256);
157 
158     function allowance(address owner, address spender) external view returns (uint256);
159 
160     event Transfer(address indexed from, address indexed to, uint256 value);
161 
162     event Approval(address indexed owner, address indexed spender, uint256 value);
163 }
164 
165 /**
166  * @title Standard ERC20 token
167  *
168  * @dev Implementation of the basic standard token.
169  * https://github.com/ethereum/EIPs/blob/master/EIPS/eip-20.md
170  * Originally based on code by FirstBlood:
171  * https://github.com/Firstbloodio/token/blob/master/smart_contract/FirstBloodToken.sol
172  *
173  * This implementation emits additional Approval events, allowing applications to reconstruct the allowance status for
174  * all accounts just by listening to said events. Note that this isn't required by the specification, and other
175  * compliant implementations may not do it.
176  */
177 contract ERC20 is IERC20 {
178     using SafeMath for uint256;
179 
180     mapping (address => uint256) private _balances;
181 
182     mapping (address => mapping (address => uint256)) private _allowed;
183 
184     uint256 private _totalSupply;
185 
186     /**
187     * @dev Total number of tokens in existence
188     */
189     function totalSupply() public view returns (uint256) {
190         return _totalSupply;
191     }
192 
193     /**
194     * @dev Gets the balance of the specified address.
195     * @param owner The address to query the balance of.
196     * @return An uint256 representing the amount owned by the passed address.
197     */
198     function balanceOf(address owner) public view returns (uint256) {
199         return _balances[owner];
200     }
201 
202     /**
203      * @dev Function to check the amount of tokens that an owner allowed to a spender.
204      * @param owner address The address which owns the funds.
205      * @param spender address The address which will spend the funds.
206      * @return A uint256 specifying the amount of tokens still available for the spender.
207      */
208     function allowance(address owner, address spender) public view returns (uint256) {
209         return _allowed[owner][spender];
210     }
211 
212     /**
213     * @dev Transfer token for a specified address
214     * @param to The address to transfer to.
215     * @param value The amount to be transferred.
216     */
217     function transfer(address to, uint256 value) public returns (bool) {
218         _transfer(msg.sender, to, value);
219         return true;
220     }
221 
222     /**
223      * @dev Approve the passed address to spend the specified amount of tokens on behalf of msg.sender.
224      * Beware that changing an allowance with this method brings the risk that someone may use both the old
225      * and the new allowance by unfortunate transaction ordering. One possible solution to mitigate this
226      * race condition is to first reduce the spender's allowance to 0 and set the desired value afterwards:
227      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
228      * @param spender The address which will spend the funds.
229      * @param value The amount of tokens to be spent.
230      */
231     function approve(address spender, uint256 value) public returns (bool) {
232         _approve(msg.sender, spender, value);
233         return true;
234     }
235 
236     /**
237      * @dev Transfer tokens from one address to another.
238      * Note that while this function emits an Approval event, this is not required as per the specification,
239      * and other compliant implementations may not emit the event.
240      * @param from address The address which you want to send tokens from
241      * @param to address The address which you want to transfer to
242      * @param value uint256 the amount of tokens to be transferred
243      */
244     function transferFrom(address from, address to, uint256 value) public returns (bool) {
245         _transfer(from, to, value);
246         _approve(from, msg.sender, _allowed[from][msg.sender].sub(value));
247         return true;
248     }
249 
250     /**
251      * @dev Increase the amount of tokens that an owner allowed to a spender.
252      * approve should be called when allowed_[_spender] == 0. To increment
253      * allowed value is better to use this function to avoid 2 calls (and wait until
254      * the first transaction is mined)
255      * From MonolithDAO Token.sol
256      * Emits an Approval event.
257      * @param spender The address which will spend the funds.
258      * @param addedValue The amount of tokens to increase the allowance by.
259      */
260     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
261         _approve(msg.sender, spender, _allowed[msg.sender][spender].add(addedValue));
262         return true;
263     }
264 
265     /**
266      * @dev Decrease the amount of tokens that an owner allowed to a spender.
267      * approve should be called when allowed_[_spender] == 0. To decrement
268      * allowed value is better to use this function to avoid 2 calls (and wait until
269      * the first transaction is mined)
270      * From MonolithDAO Token.sol
271      * Emits an Approval event.
272      * @param spender The address which will spend the funds.
273      * @param subtractedValue The amount of tokens to decrease the allowance by.
274      */
275     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
276         _approve(msg.sender, spender, _allowed[msg.sender][spender].sub(subtractedValue));
277         return true;
278     }
279 
280     /**
281     * @dev Transfer token for a specified addresses
282     * @param from The address to transfer from.
283     * @param to The address to transfer to.
284     * @param value The amount to be transferred.
285     */
286     function _transfer(address from, address to, uint256 value) internal {
287         require(to != address(0));
288 
289         _balances[from] = _balances[from].sub(value);
290         _balances[to] = _balances[to].add(value);
291         emit Transfer(from, to, value);
292     }
293 
294     /**
295      * @dev Internal function that mints an amount of the token and assigns it to
296      * an account. This encapsulates the modification of balances such that the
297      * proper events are emitted.
298      * @param account The account that will receive the created tokens.
299      * @param value The amount that will be created.
300      */
301     function _mint(address account, uint256 value) internal {
302         require(account != address(0));
303 
304         _totalSupply = _totalSupply.add(value);
305         _balances[account] = _balances[account].add(value);
306         emit Transfer(address(0), account, value);
307     }
308 
309     /**
310      * @dev Internal function that burns an amount of the token of a given
311      * account.
312      * @param account The account whose tokens will be burnt.
313      * @param value The amount that will be burnt.
314      */
315     function _burn(address account, uint256 value) internal {
316         require(account != address(0));
317 
318         _totalSupply = _totalSupply.sub(value);
319         _balances[account] = _balances[account].sub(value);
320         emit Transfer(account, address(0), value);
321     }
322 
323     /**
324      * @dev Approve an address to spend another addresses' tokens.
325      * @param owner The address that owns the tokens.
326      * @param spender The address that will spend the tokens.
327      * @param value The number of tokens that can be spent.
328      */
329     function _approve(address owner, address spender, uint256 value) internal {
330         require(spender != address(0));
331         require(owner != address(0));
332 
333         _allowed[owner][spender] = value;
334         emit Approval(owner, spender, value);
335     }
336 
337     /**
338      * @dev Internal function that burns an amount of the token of a given
339      * account, deducting from the sender's allowance for said account. Uses the
340      * internal burn function.
341      * Emits an Approval event (reflecting the reduced allowance).
342      * @param account The account whose tokens will be burnt.
343      * @param value The amount that will be burnt.
344      */
345     function _burnFrom(address account, uint256 value) internal {
346         _burn(account, value);
347         _approve(account, msg.sender, _allowed[account][msg.sender].sub(value));
348     }
349 }
350 
351 /**
352  * @title ERC20Detailed token
353  * @dev The decimals are only for visualization purposes.
354  * All the operations are done using the smallest and indivisible token unit,
355  * just as on Ethereum all the operations are done in wei.
356  */
357 contract ERC20Detailed is IERC20 {
358     string private _name;
359     string private _symbol;
360     uint8 private _decimals;
361 
362     constructor (string memory name, string memory symbol, uint8 decimals) public {
363         _name = name;
364         _symbol = symbol;
365         _decimals = decimals;
366     }
367 
368     /**
369      * @return the name of the token.
370      */
371     function name() public view returns (string memory) {
372         return _name;
373     }
374 
375     /**
376      * @return the symbol of the token.
377      */
378     function symbol() public view returns (string memory) {
379         return _symbol;
380     }
381 
382     /**
383      * @return the number of decimals of the token.
384      */
385     function decimals() public view returns (uint8) {
386         return _decimals;
387     }
388 }
389 
390 /**
391  * @title SafeERC20
392  * @dev Wrappers around ERC20 operations that throw on failure.
393  * To use this library you can add a `using SafeERC20 for ERC20;` statement to your contract,
394  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
395  */
396 library SafeERC20 {
397     using SafeMath for uint256;
398 
399     function safeTransfer(IERC20 token, address to, uint256 value) internal {
400         require(token.transfer(to, value));
401     }
402 
403     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
404         require(token.transferFrom(from, to, value));
405     }
406 
407     function safeApprove(IERC20 token, address spender, uint256 value) internal {
408         // safeApprove should only be called when setting an initial allowance,
409         // or when resetting it to zero. To increase and decrease it, use
410         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
411         require((value == 0) || (token.allowance(msg.sender, spender) == 0));
412         require(token.approve(spender, value));
413     }
414 
415     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
416         uint256 newAllowance = token.allowance(address(this), spender).add(value);
417         require(token.approve(spender, newAllowance));
418     }
419 
420     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
421         uint256 newAllowance = token.allowance(address(this), spender).sub(value);
422         require(token.approve(spender, newAllowance));
423     }
424 }
425 
426 /**
427  * @title Roles
428  * @dev Library for managing addresses assigned to a Role.
429  */
430 library Roles {
431     struct Role {
432         mapping (address => bool) bearer;
433     }
434 
435     /**
436      * @dev give an account access to this role
437      */
438     function add(Role storage role, address account) internal {
439         require(account != address(0));
440         require(!has(role, account));
441 
442         role.bearer[account] = true;
443     }
444 
445     /**
446      * @dev remove an account's access to this role
447      */
448     function remove(Role storage role, address account) internal {
449         require(account != address(0));
450         require(has(role, account));
451 
452         role.bearer[account] = false;
453     }
454 
455     /**
456      * @dev check if an account has this role
457      * @return bool
458      */
459     function has(Role storage role, address account) internal view returns (bool) {
460         require(account != address(0));
461         return role.bearer[account];
462     }
463 }
464 
465 contract PauserRole {
466     using Roles for Roles.Role;
467 
468     event PauserAdded(address indexed account);
469     event PauserRemoved(address indexed account);
470 
471     Roles.Role private _pausers;
472 
473     constructor () internal {
474         _addPauser(msg.sender);
475     }
476 
477     modifier onlyPauser() {
478         require(isPauser(msg.sender));
479         _;
480     }
481 
482     function isPauser(address account) public view returns (bool) {
483         return _pausers.has(account);
484     }
485 
486     function addPauser(address account) public onlyPauser {
487         _addPauser(account);
488     }
489 
490     function renouncePauser() public {
491         _removePauser(msg.sender);
492     }
493 
494     function _addPauser(address account) internal {
495         _pausers.add(account);
496         emit PauserAdded(account);
497     }
498 
499     function _removePauser(address account) internal {
500         _pausers.remove(account);
501         emit PauserRemoved(account);
502     }
503 }
504 
505 /**
506  * @title Pausable
507  * @dev Base contract which allows children to implement an emergency stop mechanism.
508  */
509 contract Pausable is PauserRole {
510     event Paused(address account);
511     event Unpaused(address account);
512 
513     bool private _paused;
514 
515     constructor () internal {
516         _paused = false;
517     }
518 
519     /**
520      * @return true if the contract is paused, false otherwise.
521      */
522     function paused() public view returns (bool) {
523         return _paused;
524     }
525 
526     /**
527      * @dev Modifier to make a function callable only when the contract is not paused.
528      */
529     modifier whenNotPaused() {
530         require(!_paused);
531         _;
532     }
533 
534     /**
535      * @dev Modifier to make a function callable only when the contract is paused.
536      */
537     modifier whenPaused() {
538         require(_paused);
539         _;
540     }
541 
542     /**
543      * @dev called by the owner to pause, triggers stopped state
544      */
545     function pause() public onlyPauser whenNotPaused {
546         _paused = true;
547         emit Paused(msg.sender);
548     }
549 
550     /**
551      * @dev called by the owner to unpause, returns to normal state
552      */
553     function unpause() public onlyPauser whenPaused {
554         _paused = false;
555         emit Unpaused(msg.sender);
556     }
557 }
558 
559 contract MoneyMarketInterface {
560   function getSupplyBalance(address account, address asset) public view returns (uint);
561   function supply(address asset, uint amount) public returns (uint);
562   function withdraw(address asset, uint requestedAmount) public returns (uint);
563 }
564 
565 contract LoanEscrow is Pausable {
566   using SafeERC20 for IERC20;
567   using SafeMath for uint256;
568 
569   // configurable to any ERC20 (i.e. xCHF)
570   address public constant DAI_ADDRESS = 0x89d24A6b4CcB1B6fAA2625fE562bDD9a23260359;  // 0x9Ad61E35f8309aF944136283157FABCc5AD371E5;
571   IERC20 public dai = IERC20(DAI_ADDRESS);
572 
573   address public constant MONEY_MARKET_ADDRESS = 0x3FDA67f7583380E67ef93072294a7fAc882FD7E7;  // 0x6732c278C58FC90542cce498981844A073D693d7;
574   MoneyMarketInterface public moneyMarket = MoneyMarketInterface(MONEY_MARKET_ADDRESS);
575 
576   event Deposited(address indexed from, uint256 daiAmount);
577   event InterestWithdrawn(address indexed to, uint256 daiAmount);
578   event Pulled(address indexed to, uint256 daiAmount);
579 
580   mapping(address => uint256) public deposits;
581   mapping(address => uint256) public pulls;
582   uint256 public deposited;
583   uint256 public pulled;
584 
585   modifier onlyBlockimmo() {
586     require(msg.sender == blockimmo(), "onlyBlockimmo");
587     _;
588   }
589 
590   function blockimmo() public view returns (address);
591 
592   function withdrawInterest() public onlyBlockimmo {
593     uint256 amountInterest = moneyMarket.getSupplyBalance(address(this), DAI_ADDRESS).add(dai.balanceOf(address(this))).add(pulled).sub(deposited);
594     require(amountInterest > 0, "no interest");
595 
596     uint256 errorCode = moneyMarket.withdraw(DAI_ADDRESS, amountInterest);
597     require(errorCode == 0, "withdraw failed");
598 
599     dai.safeTransfer(msg.sender, amountInterest);
600     emit InterestWithdrawn(msg.sender, amountInterest);
601   }
602 
603   function deposit(address _from, uint256 _amountDai) internal {
604     require(_from != address(0) && _amountDai > 0, "invalid parameter(s)");
605 
606     dai.safeTransferFrom(msg.sender, address(this), _amountDai);
607 
608     if (!paused()) {
609       require(dai.allowance(address(this), MONEY_MARKET_ADDRESS) == 0, "non-zero initial moneyMarket allowance");
610       require(dai.approve(MONEY_MARKET_ADDRESS, _amountDai), "approving moneyMarket failed");
611 
612       uint256 errorCode = moneyMarket.supply(DAI_ADDRESS, _amountDai);
613       require(errorCode == 0, "supply failed");
614       require(dai.allowance(address(this), MONEY_MARKET_ADDRESS) == 0, "allowance not fully consumed by moneyMarket");
615     }
616 
617     deposits[_from] = deposits[_from].add(_amountDai);
618     deposited = deposited.add(_amountDai);
619     emit Deposited(_from, _amountDai);
620   }
621 
622   function pull(address _to, uint256 _amountDai, bool _refund) internal {
623     require(_to != address(0) && _amountDai > 0, "invalid parameter(s)");
624 
625     uint256 errorCode = (_amountDai > dai.balanceOf(address(this))) ? moneyMarket.withdraw(DAI_ADDRESS, _amountDai.sub(dai.balanceOf(address(this)))) : 0;
626     require(errorCode == 0, "withdraw failed");
627 
628     if (_refund) {
629       deposits[_to] = deposits[_to].sub(_amountDai);
630       deposited = deposited.sub(_amountDai);
631     } else {
632       pulls[_to] = pulls[_to].add(_amountDai);
633       pulled = pulled.add(_amountDai);
634     }
635 
636     dai.safeTransfer(_to, _amountDai);
637     emit Pulled(_to, _amountDai);
638   }
639 }
640 
641 /**
642  * @title DividendDistributingToken
643  * @dev An ERC20-compliant token that distributes any Dai it receives to its token holders proportionate to their share.
644  *
645  * Implementation based on: https://blog.pennyether.com/posts/realtime-dividend-token.html#the-token
646  *
647  * The user is responsible for when they transact tokens (transacting before a dividend payout is probably not ideal).
648  *
649  * `TokenizedProperty` inherits from `this` and is the front-facing contract representing the rights / ownership to a property.
650  *
651  * NOTE: if the owner(s) of a `TokenizedProperty` wish to update `LoanEscrow` behavior (i.e. changing the ERC20 token funds are raised in, or changing loan behavior),
652  * some options are: (a) `untokenize` and re-deploy the updated `TokenizedProperty`, or (b) deploy an independent contract acting as the updated dividend distribution vehicle.
653  */
654 contract DividendDistributingToken is ERC20, LoanEscrow {
655   using SafeMath for uint256;
656 
657   uint256 public constant POINTS_PER_DAI = uint256(10) ** 32;
658 
659   uint256 public pointsPerToken = 0;
660   mapping(address => uint256) public credits;
661   mapping(address => uint256) public lastPointsPerToken;
662 
663   event DividendsCollected(address indexed collector, uint256 amount);
664   event DividendsDeposited(address indexed depositor, uint256 amount);
665 
666   function collectOwedDividends() public {
667     creditAccount(msg.sender);
668 
669     uint256 _dai = credits[msg.sender].div(POINTS_PER_DAI);
670     credits[msg.sender] = 0;
671 
672     pull(msg.sender, _dai, false);
673     emit DividendsCollected(msg.sender, _dai);
674   }
675 
676   function depositDividends() public {  // dividends
677     uint256 amount = dai.allowance(msg.sender, address(this));
678 
679     uint256 fee = amount.div(100);
680     dai.safeTransferFrom(msg.sender, blockimmo(), fee);
681 
682     deposit(msg.sender, amount.sub(fee));
683 
684     // partially tokenized properties store the "non-tokenized" part in `this` contract, dividends not disrupted
685     uint256 issued = totalSupply().sub(unissued());
686     pointsPerToken = pointsPerToken.add(amount.sub(fee).mul(POINTS_PER_DAI).div(issued));
687 
688     emit DividendsDeposited(msg.sender, amount);
689   }
690 
691   function unissued() public view returns (uint256) {
692     return balanceOf(address(this));
693   }
694 
695   function creditAccount(address _account) internal {
696     uint256 amount = balanceOf(_account).mul(pointsPerToken.sub(lastPointsPerToken[_account]));
697     credits[_account] = credits[_account].add(amount);
698     lastPointsPerToken[_account] = pointsPerToken;
699   }
700 }
701 
702 contract LandRegistryInterface {
703   function getProperty(string memory _eGrid) public view returns (address property);
704 }
705 
706 contract LandRegistryProxyInterface {
707   function owner() public view returns (address);
708   function landRegistry() public view returns (LandRegistryInterface);
709 }
710 
711 contract WhitelistInterface {
712   function checkRole(address _operator, string memory _permission) public view;
713 }
714 
715 contract WhitelistProxyInterface {
716   function whitelist() public view returns (WhitelistInterface);
717 }
718 
719 /**
720  * @title TokenizedProperty
721  * @dev An asset-backed security token (a property as identified by its E-GRID (a UUID) in the (Swiss) land registry).
722  *
723  * Ownership of `this` must be transferred to `ShareholderDAO` before blockimmo will verify `this` as legitimate in `LandRegistry`.
724  * Until verified legitimate, transferring tokens is not possible (locked).
725  *
726  * Tokens can be freely listed on exchanges (especially decentralized / 0x).
727  *
728  * `this.owner` can make two suggestions that blockimmo will always (try) to take: `setManagementCompany` and `untokenize`.
729  * `this.owner` can also transfer or rescind ownership.
730  * See `ShareholderDAO` documentation for more information...
731  *
732  * Our legal framework requires a `TokenizedProperty` must be possible to `untokenize`.
733  * Un-tokenizing is also the first step to upgrading or an outright sale of `this`.
734  *
735  * For both:
736  *   1. `owner` emits an `UntokenizeRequest`
737  *   2. blockimmo removes `this` from the `LandRegistry`
738  *
739  * Upgrading:
740  *   3. blockimmo migrates `this` to the new `TokenizedProperty` (ie perfectly preserving `this.balances`)
741  *   4. blockimmo attaches `owner` to the property (1)
742  *   5. blockimmo adds the property to `LandRegistry`
743  *
744  * Outright sale:
745  *   3. blockimmo deploys a new `TokenizedProperty` and adds it to the `LandRegistry`
746  *   4. blockimmo configures and deploys a `TokenSale` for the property with `TokenSale.wallet == address(this)`
747  *      (raised Ether distributed to current token holders as a dividend payout)
748  *        - if the sale is unsuccessful, the new property is removed from the `LandRegistry`, and `this` is added back
749  */
750 contract TokenizedProperty is DividendDistributingToken, ERC20Detailed, Ownable {
751   address public constant LAND_REGISTRY_PROXY_ADDRESS = 0xe72AD2A335AE18e6C7cdb6dAEB64b0330883CD56;  // 0x0f5Ea0A652E851678Ebf77B69484bFcD31F9459B;
752   address public constant WHITELIST_PROXY_ADDRESS = 0x7223b032180CDb06Be7a3D634B1E10032111F367;  // 0xEC8bE1A5630364292E56D01129E8ee8A9578d7D8;
753 
754   LandRegistryProxyInterface public registryProxy = LandRegistryProxyInterface(LAND_REGISTRY_PROXY_ADDRESS);
755   WhitelistProxyInterface public whitelistProxy = WhitelistProxyInterface(WHITELIST_PROXY_ADDRESS);
756 
757   uint256 public constant NUM_TOKENS = 1000000;
758 
759   mapping(address => uint256) public lastTransferBlock;
760   mapping(address => uint256) public minTransferAccepted;
761 
762   event MinTransferSet(address indexed account, uint256 minTransfer);
763   event ProposalEmitted(bytes32 indexed hash, string message);
764 
765   modifier isValid() {
766     LandRegistryInterface registry = LandRegistryInterface(registryProxy.landRegistry());
767     require(registry.getProperty(name()) == address(this), "invalid TokenizedProperty");
768     _;
769   }
770 
771   modifier onlyBlockimmo() {
772     require(msg.sender == blockimmo(), "onlyBlockimmo");
773     _;
774   }
775 
776   constructor(string memory _eGrid, string memory _grundstuck) public ERC20Detailed(_eGrid, _grundstuck, 18) {
777     uint256 totalSupply = NUM_TOKENS * (uint256(10) ** decimals());
778     _mint(msg.sender, totalSupply);
779 
780     _approve(address(this), blockimmo(), ~uint256(0));  // enable blockimmo to issue `unissued` tokens in the future
781   }
782 
783   function blockimmo() public view returns (address) {
784     return registryProxy.owner();
785   }
786 
787   function burn(uint256 _value) public isValid {  // buyback
788     _burn(msg.sender, _value);
789   }
790 
791   function mint(address _to, uint256 _value) public isValid onlyBlockimmo returns (bool) {  // equity dilution
792     _mint(_to, _value);
793     return true;
794   }
795 
796   function emitProposal(bytes32 _hash, string memory _message) public isValid onlyOwner {
797     emit ProposalEmitted(_hash, _message);
798   }
799 
800   function setMinTransfer(uint256 _amount) public isValid {
801     minTransferAccepted[msg.sender] = _amount;
802     emit MinTransferSet(msg.sender, _amount);
803   }
804 
805   function transfer(address _to, uint256 _value) public isValid returns (bool) {
806     require(_value >= minTransferAccepted[_to], "_value must exceed _to's minTransferAccepted");
807     transferBookKeeping(msg.sender, _to);
808     return super.transfer(_to, _value);
809   }
810 
811   function transferFrom(address _from, address _to, uint256 _value) public isValid returns (bool) {
812     transferBookKeeping(_from, _to);
813     return super.transferFrom(_from, _to, _value);
814   }
815 
816   function transferBookKeeping(address _from, address _to) internal {
817     whitelistProxy.whitelist().checkRole(_to, "authorized");
818 
819     creditAccount(_from);  // required for dividends...
820     creditAccount(_to);
821 
822     lastTransferBlock[_from] = block.number;  // required for voting...
823     lastTransferBlock[_to] = block.number;
824   }
825 }