1 // SPDX-License-Identifier: UNLICENSED
2 
3 pragma solidity 0.8.6;
4 
5 /**
6  * @dev Wrappers over Solidity's arithmetic operations with added overflow
7  * checks.
8  *
9  * Arithmetic operations in Solidity wrap on overflow. This can easily result
10  * in bugs, because programmers usually assume that an overflow raises an
11  * error, which is the standard behavior in high level programming languages.
12  * `SafeMath` restores this intuition by reverting the transaction when an
13  * operation overflows.
14  *
15  * Using this library instead of the unchecked operations eliminates an entire
16  * class of bugs, so it's recommended to use it always.
17  */
18 library SafeMath {
19     /**
20      * @dev Returns the addition of two unsigned integers, with an overflow flag.
21      *
22      * _Available since v3.4._
23      */
24     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
25         uint256 c = a + b;
26         if (c < a) return (false, 0);
27         return (true, c);
28     }
29 
30     /**
31      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
32      *
33      * _Available since v3.4._
34      */
35     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
36         if (b > a) return (false, 0);
37         return (true, a - b);
38     }
39 
40     /**
41      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
42      *
43      * _Available since v3.4._
44      */
45     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
46         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
47         // benefit is lost if 'b' is also tested.
48         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
49         if (a == 0) return (true, 0);
50         uint256 c = a * b;
51         if (c / a != b) return (false, 0);
52         return (true, c);
53     }
54 
55     /**
56      * @dev Returns the division of two unsigned integers, with a division by zero flag.
57      *
58      * _Available since v3.4._
59      */
60     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
61         if (b == 0) return (false, 0);
62         return (true, a / b);
63     }
64 
65     /**
66      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
67      *
68      * _Available since v3.4._
69      */
70     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
71         if (b == 0) return (false, 0);
72         return (true, a % b);
73     }
74 
75     /**
76      * @dev Returns the addition of two unsigned integers, reverting on
77      * overflow.
78      *
79      * Counterpart to Solidity's `+` operator.
80      *
81      * Requirements:
82      *
83      * - Addition cannot overflow.
84      */
85     function add(uint256 a, uint256 b) internal pure returns (uint256) {
86         uint256 c = a + b;
87         require(c >= a, "SafeMath: addition overflow");
88         return c;
89     }
90 
91     /**
92      * @dev Returns the subtraction of two unsigned integers, reverting on
93      * overflow (when the result is negative).
94      *
95      * Counterpart to Solidity's `-` operator.
96      *
97      * Requirements:
98      *
99      * - Subtraction cannot overflow.
100      */
101     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
102         require(b <= a, "SafeMath: subtraction overflow");
103         return a - b;
104     }
105 
106     /**
107      * @dev Returns the multiplication of two unsigned integers, reverting on
108      * overflow.
109      *
110      * Counterpart to Solidity's `*` operator.
111      *
112      * Requirements:
113      *
114      * - Multiplication cannot overflow.
115      */
116     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
117         if (a == 0) return 0;
118         uint256 c = a * b;
119         require(c / a == b, "SafeMath: multiplication overflow");
120         return c;
121     }
122 
123     /**
124      * @dev Returns the integer division of two unsigned integers, reverting on
125      * division by zero. The result is rounded towards zero.
126      *
127      * Counterpart to Solidity's `/` operator. Note: this function uses a
128      * `revert` opcode (which leaves remaining gas untouched) while Solidity
129      * uses an invalid opcode to revert (consuming all remaining gas).
130      *
131      * Requirements:
132      *
133      * - The divisor cannot be zero.
134      */
135     function div(uint256 a, uint256 b) internal pure returns (uint256) {
136         require(b > 0, "SafeMath: division by zero");
137         return a / b;
138     }
139 
140     /**
141      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
142      * reverting when dividing by zero.
143      *
144      * Counterpart to Solidity's `%` operator. This function uses a `revert`
145      * opcode (which leaves remaining gas untouched) while Solidity uses an
146      * invalid opcode to revert (consuming all remaining gas).
147      *
148      * Requirements:
149      *
150      * - The divisor cannot be zero.
151      */
152     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
153         require(b > 0, "SafeMath: modulo by zero");
154         return a % b;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * CAUTION: This function is deprecated because it requires allocating memory for the error
162      * message unnecessarily. For custom revert reasons use {trySub}.
163      *
164      * Counterpart to Solidity's `-` operator.
165      *
166      * Requirements:
167      *
168      * - Subtraction cannot overflow.
169      */
170     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
171         require(b <= a, errorMessage);
172         return a - b;
173     }
174 
175     /**
176      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
177      * division by zero. The result is rounded towards zero.
178      *
179      * CAUTION: This function is deprecated because it requires allocating memory for the error
180      * message unnecessarily. For custom revert reasons use {tryDiv}.
181      *
182      * Counterpart to Solidity's `/` operator. Note: this function uses a
183      * `revert` opcode (which leaves remaining gas untouched) while Solidity
184      * uses an invalid opcode to revert (consuming all remaining gas).
185      *
186      * Requirements:
187      *
188      * - The divisor cannot be zero.
189      */
190     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
191         require(b > 0, errorMessage);
192         return a / b;
193     }
194 
195     /**
196      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
197      * reverting with custom message when dividing by zero.
198      *
199      * CAUTION: This function is deprecated because it requires allocating memory for the error
200      * message unnecessarily. For custom revert reasons use {tryMod}.
201      *
202      * Counterpart to Solidity's `%` operator. This function uses a `revert`
203      * opcode (which leaves remaining gas untouched) while Solidity uses an
204      * invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
211         require(b > 0, errorMessage);
212         return a % b;
213     }
214 }
215 
216 
217 /**
218  * @dev Interface of the ERC20 standard as defined in the EIP.
219  */
220 interface IERC20 {
221     /**
222      * @dev Returns the amount of tokens in existence.
223      */
224     function totalSupply() external view returns (uint256);
225 
226     /**
227      * @dev Returns the amount of tokens owned by `account`.
228      */
229     function balanceOf(address account) external view returns (uint256);
230 
231     /**
232      * @dev Moves `amount` tokens from the caller's account to `recipient`.
233      *
234      * Returns a boolean value indicating whether the operation succeeded.
235      *
236      * Emits a {Transfer} event.
237      */
238     function transfer(address recipient, uint256 amount) external returns (bool);
239 
240     /**
241      * @dev Returns the remaining number of tokens that `spender` will be
242      * allowed to spend on behalf of `owner` through {transferFrom}. This is
243      * zero by default.
244      *
245      * This value changes when {approve} or {transferFrom} are called.
246      */
247     function allowance(address owner, address spender) external view returns (uint256);
248 
249     /**
250      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
251      *
252      * Returns a boolean value indicating whether the operation succeeded.
253      *
254      * IMPORTANT: Beware that changing an allowance with this method brings the risk
255      * that someone may use both the old and the new allowance by unfortunate
256      * transaction ordering. One possible solution to mitigate this race
257      * condition is to first reduce the spender's allowance to 0 and set the
258      * desired value afterwards:
259      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
260      *
261      * Emits an {Approval} event.
262      */
263     function approve(address spender, uint256 amount) external returns (bool);
264 
265     /**
266      * @dev Moves `amount` tokens from `sender` to `recipient` using the
267      * allowance mechanism. `amount` is then deducted from the caller's
268      * allowance.
269      *
270      * Returns a boolean value indicating whether the operation succeeded.
271      *
272      * Emits a {Transfer} event.
273      */
274     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
275 
276     /**
277      * @dev Emitted when `value` tokens are moved from one account (`from`) to
278      * another (`to`).
279      *
280      * Note that `value` may be zero.
281      */
282     event Transfer(address indexed from, address indexed to, uint256 value);
283 
284     /**
285      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
286      * a call to {approve}. `value` is the new allowance.
287      */
288     event Approval(address indexed owner, address indexed spender, uint256 value);
289 }
290 
291 
292 /** 
293  * @dev Provides information about the current execution context, including the
294  * sender of the transaction and its data. While these are generally available
295  * via msg.sender and msg.data, they should not be accessed in such a direct
296  * manner, since when dealing with GSN meta-transactions the account sending and
297  * paying for execution may not be the actual sender (as far as an application
298  * is concerned).
299  *
300  * This contract is only required for intermediate, library-like contracts.
301  */
302 abstract contract Context {
303     function _msgSender() internal view virtual returns (address payable) {
304         return payable(msg.sender);
305     }
306 
307     function _msgData() internal view virtual returns (bytes memory) {
308         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
309         return msg.data;
310     }
311 }
312 
313 
314 
315 /**
316  * @dev Implementation of the {IERC20} interface.
317  *
318  * This implementation is agnostic to the way tokens are created. This means
319  * that a supply mechanism has to be added in a derived contract using {_mint}.
320  * For a generic mechanism see {ERC20PresetMinterPauser}.
321  *
322  * TIP: For a detailed writeup see our guide
323  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
324  * to implement supply mechanisms].
325  *
326  * We have followed general OpenZeppelin guidelines: functions revert instead
327  * of returning `false` on failure. This behavior is nonetheless conventional
328  * and does not conflict with the expectations of ERC20 applications.
329  *
330  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
331  * This allows applications to reconstruct the allowance for all accounts just
332  * by listening to said events. Other implementations of the EIP may not emit
333  * these events, as it isn't required by the specification.
334  *
335  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
336  * functions have been added to mitigate the well-known issues around setting
337  * allowances. See {IERC20-approve}.
338  */
339 contract ERC20 is Context, IERC20 {
340     using SafeMath for uint256;
341 
342     mapping (address => uint256) private _balances;
343 
344     mapping (address => mapping (address => uint256)) private _allowances;
345 
346     uint256 private _totalSupply;
347 
348     string private _name;
349     string private _symbol;
350     uint8 private _decimals;
351 
352     /**
353      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
354      * a default value of 18.
355      *
356      * To select a different value for {decimals}, use {_setupDecimals}.
357      *
358      * All three of these values are immutable: they can only be set once during
359      * construction.
360      */
361     constructor (string memory name_, string memory symbol_) {
362         _name = name_;
363         _symbol = symbol_;
364         _decimals = 18;
365     }
366 
367     /**
368      * @dev Returns the name of the token.
369      */
370     function name() public view virtual returns (string memory) {
371         return _name;
372     }
373 
374     /**
375      * @dev Returns the symbol of the token, usually a shorter version of the
376      * name.
377      */
378     function symbol() public view virtual returns (string memory) {
379         return _symbol;
380     }
381 
382     /**
383      * @dev Returns the number of decimals used to get its user representation.
384      * For example, if `decimals` equals `2`, a balance of `505` tokens should
385      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
386      *
387      * Tokens usually opt for a value of 18, imitating the relationship between
388      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
389      * called.
390      *
391      * NOTE: This information is only used for _display_ purposes: it in
392      * no way affects any of the arithmetic of the contract, including
393      * {IERC20-balanceOf} and {IERC20-transfer}.
394      */
395     function decimals() public view virtual returns (uint8) {
396         return _decimals;
397     }
398 
399     /**
400      * @dev See {IERC20-totalSupply}.
401      */
402     function totalSupply() public view virtual override returns (uint256) {
403         return _totalSupply;
404     }
405 
406     /**
407      * @dev See {IERC20-balanceOf}.
408      */
409     function balanceOf(address account) public view virtual override returns (uint256) {
410         return _balances[account];
411     }
412 
413     /**
414      * @dev See {IERC20-transfer}.
415      *
416      * Requirements:
417      *
418      * - `recipient` cannot be the zero address.
419      * - the caller must have a balance of at least `amount`.
420      */
421     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
422         _transfer(_msgSender(), recipient, amount);
423         return true;
424     }
425 
426     /**
427      * @dev See {IERC20-allowance}.
428      */
429     function allowance(address owner, address spender) public view virtual override returns (uint256) {
430         return _allowances[owner][spender];
431     }
432 
433     /**
434      * @dev See {IERC20-approve}.
435      *
436      * Requirements:
437      *
438      * - `spender` cannot be the zero address.
439      */
440     function approve(address spender, uint256 amount) public virtual override returns (bool) {
441         _approve(_msgSender(), spender, amount);
442         return true;
443     }
444 
445     /**
446      * @dev See {IERC20-transferFrom}.
447      *
448      * Emits an {Approval} event indicating the updated allowance. This is not
449      * required by the EIP. See the note at the beginning of {ERC20}.
450      *
451      * Requirements:
452      *
453      * - `sender` and `recipient` cannot be the zero address.
454      * - `sender` must have a balance of at least `amount`.
455      * - the caller must have allowance for ``sender``'s tokens of at least
456      * `amount`.
457      */
458     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
459         _transfer(sender, recipient, amount);
460         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
461         return true;
462     }
463 
464     /**
465      * @dev Atomically increases the allowance granted to `spender` by the caller.
466      *
467      * This is an alternative to {approve} that can be used as a mitigation for
468      * problems described in {IERC20-approve}.
469      *
470      * Emits an {Approval} event indicating the updated allowance.
471      *
472      * Requirements:
473      *
474      * - `spender` cannot be the zero address.
475      */
476     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
477         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
478         return true;
479     }
480 
481     /**
482      * @dev Atomically decreases the allowance granted to `spender` by the caller.
483      *
484      * This is an alternative to {approve} that can be used as a mitigation for
485      * problems described in {IERC20-approve}.
486      *
487      * Emits an {Approval} event indicating the updated allowance.
488      *
489      * Requirements:
490      *
491      * - `spender` cannot be the zero address.
492      * - `spender` must have allowance for the caller of at least
493      * `subtractedValue`.
494      */
495     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
496         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
497         return true;
498     }
499 
500     /**
501      * @dev Moves tokens `amount` from `sender` to `recipient`.
502      *
503      * This is internal function is equivalent to {transfer}, and can be used to
504      * e.g. implement automatic token fees, slashing mechanisms, etc.
505      *
506      * Emits a {Transfer} event.
507      *
508      * Requirements:
509      *
510      * - `sender` cannot be the zero address.
511      * - `recipient` cannot be the zero address.
512      * - `sender` must have a balance of at least `amount`.
513      */
514     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
515         require(sender != address(0), "ERC20: transfer from the zero address");
516         require(recipient != address(0), "ERC20: transfer to the zero address");
517 
518         _beforeTokenTransfer(sender, recipient, amount);
519 
520         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
521         _balances[recipient] = _balances[recipient].add(amount);
522         emit Transfer(sender, recipient, amount);
523     }
524 
525     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
526      * the total supply.
527      *
528      * Emits a {Transfer} event with `from` set to the zero address.
529      *
530      * Requirements:
531      *
532      * - `to` cannot be the zero address.
533      */
534     function _mint(address account, uint256 amount) internal virtual {
535         require(account != address(0), "ERC20: mint to the zero address");
536 
537         _beforeTokenTransfer(address(0), account, amount);
538 
539         _totalSupply = _totalSupply.add(amount);
540         _balances[account] = _balances[account].add(amount);
541         emit Transfer(address(0), account, amount);
542     }
543 
544     /**
545      * @dev Destroys `amount` tokens from `account`, reducing the
546      * total supply.
547      *
548      * Emits a {Transfer} event with `to` set to the zero address.
549      *
550      * Requirements:
551      *
552      * - `account` cannot be the zero address.
553      * - `account` must have at least `amount` tokens.
554      */
555     function _burn(address account, uint256 amount) internal virtual {
556         require(account != address(0), "ERC20: burn from the zero address");
557 
558         _beforeTokenTransfer(account, address(0), amount);
559 
560         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
561         _totalSupply = _totalSupply.sub(amount);
562         emit Transfer(account, address(0), amount);
563     }
564 
565     /**
566      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
567      *
568      * This internal function is equivalent to `approve`, and can be used to
569      * e.g. set automatic allowances for certain subsystems, etc.
570      *
571      * Emits an {Approval} event.
572      *
573      * Requirements:
574      *
575      * - `owner` cannot be the zero address.
576      * - `spender` cannot be the zero address.
577      */
578     function _approve(address owner, address spender, uint256 amount) internal virtual {
579         require(owner != address(0), "ERC20: approve from the zero address");
580         require(spender != address(0), "ERC20: approve to the zero address");
581 
582         _allowances[owner][spender] = amount;
583         emit Approval(owner, spender, amount);
584     }
585 
586     /**
587      * @dev Sets {decimals} to a value other than the default one of 18.
588      *
589      * WARNING: This function should only be called from the constructor. Most
590      * applications that interact with token contracts will not expect
591      * {decimals} to ever change, and may work incorrectly if it does.
592      */
593     function _setupDecimals(uint8 decimals_) internal virtual {
594         _decimals = decimals_;
595     }
596 
597     /**
598      * @dev Hook that is called before any transfer of tokens. This includes
599      * minting and burning.
600      *
601      * Calling conditions:
602      *
603      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
604      * will be to transferred to `to`.
605      * - when `from` is zero, `amount` tokens will be minted for `to`.
606      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
607      * - `from` and `to` are never both zero.
608      *
609      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
610      */
611     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
612 }
613 
614 /**
615  * @dev Contract module which provides a basic access control mechanism, where
616  * there is an account (an owner) that can be granted exclusive access to
617  * specific functions.
618  *
619  * By default, the owner account will be the one that deploys the contract. This
620  * can later be changed with {transferOwnership}.
621  *
622  * This module is used through inheritance. It will make available the modifier
623  * `onlyOwner`, which can be applied to your functions to restrict their use to
624  * the owner.
625  */
626 abstract contract Ownable is Context {
627     address private _owner;
628 
629     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
630 
631     /**
632      * @dev Initializes the contract setting the deployer as the initial owner.
633      */
634     constructor () {
635         address msgSender = _msgSender();
636         _owner = msgSender;
637         emit OwnershipTransferred(address(0), msgSender);
638     }
639 
640     /**
641      * @dev Returns the address of the current owner.
642      */
643     function owner() public view virtual returns (address) {
644         return _owner;
645     }
646 
647     /**
648      * @dev Throws if called by any account other than the owner.
649      */
650     modifier onlyOwner() {
651         require(owner() == _msgSender(), "Ownable: caller is not the owner");
652         _;
653     }
654 
655     /**
656      * @dev Leaves the contract without owner. It will not be possible to call
657      * `onlyOwner` functions anymore. Can only be called by the current owner.
658      *
659      * NOTE: Renouncing ownership will leave the contract without an owner,
660      * thereby removing any functionality that is only available to the owner.
661      */
662     function renounceOwnership() public virtual onlyOwner {
663         emit OwnershipTransferred(_owner, address(0));
664         _owner = address(0);
665     }
666 
667     /**
668      * @dev Transfers ownership of the contract to a new account (`newOwner`).
669      * Can only be called by the current owner.
670      */
671     function transferOwnership(address newOwner) public virtual onlyOwner {
672         require(newOwner != address(0), "Ownable: new owner is the zero address");
673         emit OwnershipTransferred(_owner, newOwner);
674         _owner = newOwner;
675     }
676 }
677 
678 contract ShiryoinuFounder is ERC20("Shiryoinu Founder", "ShiryoF"), Ownable {
679 
680     constructor() {
681        _setupDecimals(0);
682        _mint(address(msg.sender), 1000000);// aidrop  for existing holders
683     }
684 
685     function getOwner() external view returns (address) {
686         return owner();
687     }
688     
689     function mint(address _to, uint256 _amount) public onlyOwner {
690         _mint(_to, _amount);
691     }
692 
693     function website() external pure returns (string memory) {
694         return "https://shiryoinu.com";
695     }
696 
697 }