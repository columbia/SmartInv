1 pragma solidity 0.5.1;
2 
3 /**
4  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
5  * the optional functions; to access them see `ERC20Detailed`.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a `Transfer` event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through `transferFrom`. This is
30      * zero by default.
31      *
32      * This value changes when `approve` or `transferFrom` are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * > Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an `Approval` event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a `Transfer` event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to `approve`. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 /**
79  * @dev Optional functions from the ERC20 standard.
80  */
81 contract ERC20Detailed is IERC20 {
82     string private _name;
83     string private _symbol;
84     uint8 private _decimals;
85 
86     /**
87      * @dev Sets the values for `name`, `symbol`, and `decimals`. All three of
88      * these values are immutable: they can only be set once during
89      * construction.
90      */
91     constructor (string memory name, string memory symbol, uint8 decimals) public {
92         _name = name;
93         _symbol = symbol;
94         _decimals = decimals;
95     }
96 
97     /**
98      * @dev Returns the name of the token.
99      */
100     function name() public view returns (string memory) {
101         return _name;
102     }
103 
104     /**
105      * @dev Returns the symbol of the token, usually a shorter version of the
106      * name.
107      */
108     function symbol() public view returns (string memory) {
109         return _symbol;
110     }
111 
112     /**
113      * @dev Returns the number of decimals used to get its user representation.
114      * For example, if `decimals` equals `2`, a balance of `505` tokens should
115      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
116      *
117      * Tokens usually opt for a value of 18, imitating the relationship between
118      * Ether and Wei.
119      *
120      * > Note that this information is only used for _display_ purposes: it in
121      * no way affects any of the arithmetic of the contract, including
122      * `IERC20.balanceOf` and `IERC20.transfer`.
123      */
124     function decimals() public view returns (uint8) {
125         return _decimals;
126     }
127 }
128 
129 /**
130  * @dev Wrappers over Solidity's arithmetic operations with added overflow
131  * checks.
132  *
133  * Arithmetic operations in Solidity wrap on overflow. This can easily result
134  * in bugs, because programmers usually assume that an overflow raises an
135  * error, which is the standard behavior in high level programming languages.
136  * `SafeMath` restores this intuition by reverting the transaction when an
137  * operation overflows.
138  *
139  * Using this library instead of the unchecked operations eliminates an entire
140  * class of bugs, so it's recommended to use it always.
141  */
142 library SafeMath {
143     /**
144      * @dev Returns the addition of two unsigned integers, reverting on
145      * overflow.
146      *
147      * Counterpart to Solidity's `+` operator.
148      *
149      * Requirements:
150      * - Addition cannot overflow.
151      */
152     function add(uint256 a, uint256 b) internal pure returns (uint256) {
153         uint256 c = a + b;
154         require(c >= a, "SafeMath: addition overflow");
155 
156         return c;
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting on
161      * overflow (when the result is negative).
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      * - Subtraction cannot overflow.
167      */
168     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
169         require(b <= a, "SafeMath: subtraction overflow");
170         uint256 c = a - b;
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the multiplication of two unsigned integers, reverting on
177      * overflow.
178      *
179      * Counterpart to Solidity's `*` operator.
180      *
181      * Requirements:
182      * - Multiplication cannot overflow.
183      */
184     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
186         // benefit is lost if 'b' is also tested.
187         if (a == 0) {
188             return 0;
189         }
190 
191         uint256 c = a * b;
192         require(c / a == b, "SafeMath: multiplication overflow");
193 
194         return c;
195     }
196 
197     /**
198      * @dev Returns the integer division of two unsigned integers. Reverts on
199      * division by zero. The result is rounded towards zero.
200      *
201      * Counterpart to Solidity's `/` operator. Note: this function uses a
202      * `revert` opcode (which leaves remaining gas untouched) while Solidity
203      * uses an invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      * - The divisor cannot be zero.
207      */
208     function div(uint256 a, uint256 b) internal pure returns (uint256) {
209         // Solidity only automatically asserts when dividing by 0
210         require(b > 0, "SafeMath: division by zero");
211         uint256 c = a / b;
212         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
213 
214         return c;
215     }
216 
217     /**
218      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
219      * Reverts when dividing by zero.
220      *
221      * Counterpart to Solidity's `%` operator. This function uses a `revert`
222      * opcode (which leaves remaining gas untouched) while Solidity uses an
223      * invalid opcode to revert (consuming all remaining gas).
224      *
225      * Requirements:
226      * - The divisor cannot be zero.
227      */
228     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
229         require(b != 0, "SafeMath: modulo by zero");
230         return a % b;
231     }
232 }
233 
234 /**
235  * @dev Implementation of the `IERC20` interface.
236  *
237  * functions revert instead of returning `false` on failure.
238  * This behavior is nonetheless conventional and does not conflict
239  * with the expectations of ERC20 applications.
240  *
241  * Additionally, an `Approval` event is emitted on calls to `transferFrom`.
242  * This allows applications to reconstruct the allowance for all accounts just
243  * by listening to said events. Other implementations of the EIP may not emit
244  * these events, as it isn't required by the specification.
245  *
246  * Finally, the non-standard `decreaseAllowance` and `increaseAllowance`
247  * functions have been added to mitigate the well-known issues around setting
248  * allowances. See `IERC20.approve`.
249  */
250 contract ERC20 is IERC20 {
251     using SafeMath for uint256;
252 
253     mapping (address => uint256) private _balances;
254 
255     mapping (address => mapping (address => uint256)) private _allowances;
256 
257     uint256 private _totalSupply;
258 
259     /**
260      * @dev See `IERC20.totalSupply`.
261      */
262     function totalSupply() public view returns (uint256) {
263         return _totalSupply;
264     }
265 
266     /**
267      * @dev See `IERC20.balanceOf`.
268      */
269     function balanceOf(address account) public view returns (uint256) {
270         return _balances[account];
271     }
272 
273     /**
274      * @dev See `IERC20.transfer`.
275      *
276      * Requirements:
277      *
278      * - `recipient` cannot be the zero address.
279      * - the caller must have a balance of at least `amount`.
280      */
281     function transfer(address recipient, uint256 amount) public returns (bool) {
282         _transfer(msg.sender, recipient, amount);
283         return true;
284     }
285 
286     /**
287      * @dev See `IERC20.allowance`.
288      */
289     function allowance(address owner, address spender) public view returns (uint256) {
290         return _allowances[owner][spender];
291     }
292 
293     /**
294      * @dev See `IERC20.approve`.
295      *
296      * Requirements:
297      *
298      * - `spender` cannot be the zero address.
299      */
300     function approve(address spender, uint256 value) public returns (bool) {
301         _approve(msg.sender, spender, value);
302         return true;
303     }
304 
305     /**
306      * @dev See `IERC20.transferFrom`.
307      *
308      * Emits an `Approval` event indicating the updated allowance. This is not
309      * required by the EIP. See the note at the beginning of `ERC20`;
310      *
311      * Requirements:
312      * - `sender` and `recipient` cannot be the zero address.
313      * - `sender` must have a balance of at least `value`.
314      * - the caller must have allowance for `sender`'s tokens of at least
315      * `amount`.
316      */
317     function transferFrom(address sender, address recipient, uint256 amount) public returns (bool) {
318         _transfer(sender, recipient, amount);
319         _approve(sender, msg.sender, _allowances[sender][msg.sender].sub(amount));
320         return true;
321     }
322 
323     /**
324      * @dev Atomically increases the allowance granted to `spender` by the caller.
325      *
326      * This is an alternative to `approve` that can be used as a mitigation for
327      * problems described in `IERC20.approve`.
328      *
329      * Emits an `Approval` event indicating the updated allowance.
330      *
331      * Requirements:
332      *
333      * - `spender` cannot be the zero address.
334      */
335     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
336         _approve(msg.sender, spender, _allowances[msg.sender][spender].add(addedValue));
337         return true;
338     }
339 
340     /**
341      * @dev Atomically decreases the allowance granted to `spender` by the caller.
342      *
343      * This is an alternative to `approve` that can be used as a mitigation for
344      * problems described in `IERC20.approve`.
345      *
346      * Emits an `Approval` event indicating the updated allowance.
347      *
348      * Requirements:
349      *
350      * - `spender` cannot be the zero address.
351      * - `spender` must have allowance for the caller of at least
352      * `subtractedValue`.
353      */
354     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
355         _approve(msg.sender, spender, _allowances[msg.sender][spender].sub(subtractedValue));
356         return true;
357     }
358 
359     /**
360      * @dev Moves tokens `amount` from `sender` to `recipient`.
361      *
362      * This is internal function is equivalent to `transfer`, and can be used to
363      * e.g. implement automatic token fees, slashing mechanisms, etc.
364      *
365      * Emits a `Transfer` event.
366      *
367      * Requirements:
368      *
369      * - `sender` cannot be the zero address.
370      * - `recipient` cannot be the zero address.
371      * - `sender` must have a balance of at least `amount`.
372      */
373     function _transfer(address sender, address recipient, uint256 amount) internal {
374         require(sender != address(0), "ERC20: transfer from the zero address");
375         require(recipient != address(0), "ERC20: transfer to the zero address");
376 
377         _balances[sender] = _balances[sender].sub(amount);
378         _balances[recipient] = _balances[recipient].add(amount);
379         emit Transfer(sender, recipient, amount);
380     }
381 
382     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
383      * the total supply.
384      *
385      * Emits a `Transfer` event with `from` set to the zero address.
386      *
387      * Requirements
388      *
389      * - `to` cannot be the zero address.
390      */
391     function _mint(address account, uint256 amount) internal {
392         require(account != address(0), "ERC20: mint to the zero address");
393 
394         _totalSupply = _totalSupply.add(amount);
395         _balances[account] = _balances[account].add(amount);
396         emit Transfer(address(0), account, amount);
397     }
398 
399     /**
400      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
401      *
402      * This is internal function is equivalent to `approve`, and can be used to
403      * e.g. set automatic allowances for certain subsystems, etc.
404      *
405      * Emits an `Approval` event.
406      *
407      * Requirements:
408      *
409      * - `owner` cannot be the zero address.
410      * - `spender` cannot be the zero address.
411      */
412     function _approve(address owner, address spender, uint256 value) internal {
413         require(owner != address(0), "ERC20: approve from the zero address");
414         require(spender != address(0), "ERC20: approve to the zero address");
415 
416         _allowances[owner][spender] = value;
417         emit Approval(owner, spender, value);
418     }
419 
420 }
421 
422 /**
423  * @title Roles
424  * @dev Library for managing addresses assigned to a Role.
425  */
426 library Roles {
427     struct Role {
428         mapping (address => bool) bearer;
429     }
430 
431     /**
432      * @dev Give an account access to this role.
433      */
434     function add(Role storage role, address account) internal {
435         require(!has(role, account), "Roles: account already has role");
436         role.bearer[account] = true;
437     }
438 
439     /**
440      * @dev Remove an account's access to this role.
441      */
442     function remove(Role storage role, address account) internal {
443         require(has(role, account), "Roles: account does not have role");
444         role.bearer[account] = false;
445     }
446 
447     /**
448      * @dev Check if an account has this role.
449      * @return bool
450      */
451     function has(Role storage role, address account) internal view returns (bool) {
452         require(account != address(0), "Roles: account is the zero address");
453         return role.bearer[account];
454     }
455 }
456 
457 contract PauserRole {
458     using Roles for Roles.Role;
459 
460     event PauserAdded(address indexed account);
461     event PauserRemoved(address indexed account);
462 
463     Roles.Role private _pausers;
464 
465     constructor () internal {
466         _addPauser(msg.sender);
467     }
468 
469     modifier onlyPauser() {
470         require(isPauser(msg.sender), "PauserRole: caller does not have the Pauser role");
471         _;
472     }
473 
474     function isPauser(address account) public view returns (bool) {
475         return _pausers.has(account);
476     }
477 
478     function addPauser(address account) public onlyPauser {
479         _addPauser(account);
480     }
481 
482     function renouncePauser() public {
483         _removePauser(msg.sender);
484     }
485 
486     function _addPauser(address account) internal {
487         _pausers.add(account);
488         emit PauserAdded(account);
489     }
490 
491     function _removePauser(address account) internal {
492         _pausers.remove(account);
493         emit PauserRemoved(account);
494     }
495 }
496 
497 /**
498  * @dev Contract module which allows children to implement an emergency stop
499  * mechanism that can be triggered by an authorized account.
500  *
501  * This module is used through inheritance. It will make available the
502  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
503  * the functions of your contract. Note that they will not be pausable by
504  * simply including this module, only once the modifiers are put in place.
505  */
506 contract Pausable is PauserRole {
507     /**
508      * @dev Emitted when the pause is triggered by a pauser (`account`).
509      */
510     event Paused(address account);
511 
512     /**
513      * @dev Emitted when the pause is lifted by a pauser (`account`).
514      */
515     event Unpaused(address account);
516 
517     bool private _paused;
518 
519     /**
520      * @dev Initializes the contract in unpaused state. Assigns the Pauser role
521      * to the deployer.
522      */
523     constructor () internal {
524         _paused = false;
525     }
526 
527     /**
528      * @dev Returns true if the contract is paused, and false otherwise.
529      */
530     function paused() public view returns (bool) {
531         return _paused;
532     }
533 
534     /**
535      * @dev Modifier to make a function callable only when the contract is not paused.
536      */
537     modifier whenNotPaused() {
538         require(!_paused, "Pausable: paused");
539         _;
540     }
541 
542     /**
543      * @dev Modifier to make a function callable only when the contract is paused.
544      */
545     modifier whenPaused() {
546         require(_paused, "Pausable: not paused");
547         _;
548     }
549 
550     /**
551      * @dev Called by a pauser to pause, triggers stopped state.
552      */
553     function pause() public onlyPauser whenNotPaused {
554         _paused = true;
555         emit Paused(msg.sender);
556     }
557 
558     /**
559      * @dev Called by a pauser to unpause, returns to normal state.
560      */
561     function unpause() public onlyPauser whenPaused {
562         _paused = false;
563         emit Unpaused(msg.sender);
564     }
565 }
566 
567 /**
568  * @title Pausable token
569  * @dev ERC20 modified with pausable transfers.
570  */
571 contract ERC20Pausable is ERC20, Pausable {
572     function transfer(address to, uint256 value) public whenNotPaused returns (bool) {
573         return super.transfer(to, value);
574     }
575 
576     function transferFrom(address from, address to, uint256 value) public whenNotPaused returns (bool) {
577         return super.transferFrom(from, to, value);
578     }
579 
580     function approve(address spender, uint256 value) public whenNotPaused returns (bool) {
581         return super.approve(spender, value);
582     }
583 
584     function increaseAllowance(address spender, uint addedValue) public whenNotPaused returns (bool) {
585         return super.increaseAllowance(spender, addedValue);
586     }
587 
588     function decreaseAllowance(address spender, uint subtractedValue) public whenNotPaused returns (bool) {
589         return super.decreaseAllowance(spender, subtractedValue);
590     }
591 }
592 
593 
594 /**
595  * @title SKM Protocol ERC20 Token Contract
596  * @author 
597  *
598  * @dev Implementation of the New Ally Token.
599  */
600 contract AllyToken is ERC20Detailed, ERC20Pausable {
601     string  private constant  TOKEN_NAME     = "Ally Token";
602     string  private constant TOKEN_SYMBOL   = "ALY";
603     uint private constant INITIAL_TOKENS = 10000000000;
604     uint8 private constant DECIMALS = 18;
605     uint256 private constant INITIAL_SUPPLY = INITIAL_TOKENS * (10 ** uint256(DECIMALS));
606 
607     address public contract_owner;
608     uint256 public arrayLimit = 150;
609 
610     modifier onlyOwner () {
611         require (msg.sender == contract_owner);
612         _;
613     }
614 
615     constructor()  public
616         ERC20Detailed(TOKEN_NAME,TOKEN_SYMBOL,DECIMALS)
617     {
618         _mint(msg.sender, INITIAL_SUPPLY);
619         contract_owner = msg.sender;
620     }
621 
622     function setBatchTransferLimit(uint256 newLimit) public onlyOwner {
623         require(newLimit != 0);
624         arrayLimit = newLimit;
625     }
626 
627     /**
628     * @dev Batch transfer some tokens to some addresses, address and value is one-on-one.
629     * @param addressList Array of addresses
630     * @param amountList Array of transfer tokens number
631     */
632     function batchTransfer(address[] memory addressList, uint256[] memory amountList) public returns (bool) {
633         uint256 length = addressList.length;
634         require(addressList.length == amountList.length, "Inconsistent array length");
635         require(length > 0 && length <= arrayLimit, "Invalid number of transfer objects");
636         for (uint256 i = 0; i < length; i++) {
637             require(amountList[i] > 0, "The transfer amount cannot be 0");
638             require(addressList[i] != address(0), "Cannot transfer to the zero address");
639             transfer(addressList[i], amountList[i]);
640         }
641         return true;
642     }
643 
644     /**
645     * @dev Batch transfer equal tokens amout to some addresses
646     * @param addressList Array of addresses
647     * @param value Number of transfer tokens amount
648     */
649     function batchTransferSingleValue(address[] memory addressList, uint256 value) public returns (bool) {
650         uint256 length = addressList.length;
651         require(length > 0 && length <= arrayLimit, "Invalid number of transfer objects");
652         require(value > 0, "The transfer amount cannot be 0");
653         for (uint256 i = 0; i < length; i++) {
654             require(addressList[i] != address(0), "Cannot transfer to the zero address");
655             transfer(addressList[i], value);
656         }
657         return true;
658     }
659 }