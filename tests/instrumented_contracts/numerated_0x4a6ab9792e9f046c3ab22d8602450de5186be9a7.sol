1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.6.0 <0.8.0;
3 
4 /**
5  * @dev Wrappers over Solidity's arithmetic operations with added overflow
6  * checks.
7  *
8  * Arithmetic operations in Solidity wrap on overflow. This can easily result
9  * in bugs, because programmers usually assume that an overflow raises an
10  * error, which is the standard behavior in high level programming languages.
11  * `SafeMath` restores this intuition by reverting the transaction when an
12  * operation overflows.
13  *
14  * Using this library instead of the unchecked operations eliminates an entire
15  * class of bugs, so it's recommended to use it always.
16  */
17 library SafeMath {
18     /**
19      * @dev Returns the addition of two unsigned integers, reverting on
20      * overflow.
21      *
22      * Counterpart to Solidity's `+` operator.
23      *
24      * Requirements:
25      *
26      * - Addition cannot overflow.
27      */
28     function add(uint256 a, uint256 b) internal pure returns (uint256) {
29         uint256 c = a + b;
30         require(c >= a, "SafeMath: addition overflow");
31 
32         return c;
33     }
34 
35     /**
36      * @dev Returns the subtraction of two unsigned integers, reverting on
37      * overflow (when the result is negative).
38      *
39      * Counterpart to Solidity's `-` operator.
40      *
41      * Requirements:
42      *
43      * - Subtraction cannot overflow.
44      */
45     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
46         return sub(a, b, "SafeMath: subtraction overflow");
47     }
48 
49     /**
50      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
51      * overflow (when the result is negative).
52      *
53      * Counterpart to Solidity's `-` operator.
54      *
55      * Requirements:
56      *
57      * - Subtraction cannot overflow.
58      */
59     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
60         require(b <= a, errorMessage);
61         uint256 c = a - b;
62 
63         return c;
64     }
65 
66     /**
67      * @dev Returns the multiplication of two unsigned integers, reverting on
68      * overflow.
69      *
70      * Counterpart to Solidity's `*` operator.
71      *
72      * Requirements:
73      *
74      * - Multiplication cannot overflow.
75      */
76     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
77         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
78         // benefit is lost if 'b' is also tested.
79         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
80         if (a == 0) {
81             return 0;
82         }
83 
84         uint256 c = a * b;
85         require(c / a == b, "SafeMath: multiplication overflow");
86 
87         return c;
88     }
89 
90     /**
91      * @dev Returns the integer division of two unsigned integers. Reverts on
92      * division by zero. The result is rounded towards zero.
93      *
94      * Counterpart to Solidity's `/` operator. Note: this function uses a
95      * `revert` opcode (which leaves remaining gas untouched) while Solidity
96      * uses an invalid opcode to revert (consuming all remaining gas).
97      *
98      * Requirements:
99      *
100      * - The divisor cannot be zero.
101      */
102     function div(uint256 a, uint256 b) internal pure returns (uint256) {
103         return div(a, b, "SafeMath: division by zero");
104     }
105 
106     /**
107      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
108      * division by zero. The result is rounded towards zero.
109      *
110      * Counterpart to Solidity's `/` operator. Note: this function uses a
111      * `revert` opcode (which leaves remaining gas untouched) while Solidity
112      * uses an invalid opcode to revert (consuming all remaining gas).
113      *
114      * Requirements:
115      *
116      * - The divisor cannot be zero.
117      */
118     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
119         require(b > 0, errorMessage);
120         uint256 c = a / b;
121         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
122 
123         return c;
124     }
125 
126     /**
127      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
128      * Reverts when dividing by zero.
129      *
130      * Counterpart to Solidity's `%` operator. This function uses a `revert`
131      * opcode (which leaves remaining gas untouched) while Solidity uses an
132      * invalid opcode to revert (consuming all remaining gas).
133      *
134      * Requirements:
135      *
136      * - The divisor cannot be zero.
137      */
138     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
139         return mod(a, b, "SafeMath: modulo by zero");
140     }
141 
142     /**
143      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
144      * Reverts with custom message when dividing by zero.
145      *
146      * Counterpart to Solidity's `%` operator. This function uses a `revert`
147      * opcode (which leaves remaining gas untouched) while Solidity uses an
148      * invalid opcode to revert (consuming all remaining gas).
149      *
150      * Requirements:
151      *
152      * - The divisor cannot be zero.
153      */
154     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b != 0, errorMessage);
156         return a % b;
157     }
158 }
159 
160 /**
161  * @dev Interface of the ERC20 standard as defined in the EIP.
162  */
163 interface IERC20 {
164     /**
165      * @dev Returns the amount of tokens in existence.
166      */
167     function totalSupply() external view returns (uint256);
168 
169     /**
170      * @dev Returns the amount of tokens owned by `account`.
171      */
172     function balanceOf(address account) external view returns (uint256);
173 
174     /**
175      * @dev Moves `amount` tokens from the caller's account to `recipient`.
176      *
177      * Returns a boolean value indicating whether the operation succeeded.
178      *
179      * Emits a {Transfer} event.
180      */
181     function transfer(address recipient, uint256 amount) external returns (bool);
182 
183     /**
184      * @dev Returns the remaining number of tokens that `spender` will be
185      * allowed to spend on behalf of `owner` through {transferFrom}. This is
186      * zero by default.
187      *
188      * This value changes when {approve} or {transferFrom} are called.
189      */
190     function allowance(address owner, address spender) external view returns (uint256);
191 
192     /**
193      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
194      *
195      * Returns a boolean value indicating whether the operation succeeded.
196      *
197      * IMPORTANT: Beware that changing an allowance with this method brings the risk
198      * that someone may use both the old and the new allowance by unfortunate
199      * transaction ordering. One possible solution to mitigate this race
200      * condition is to first reduce the spender's allowance to 0 and set the
201      * desired value afterwards:
202      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
203      *
204      * Emits an {Approval} event.
205      */
206     function approve(address spender, uint256 amount) external returns (bool);
207 
208     /**
209      * @dev Moves `amount` tokens from `sender` to `recipient` using the
210      * allowance mechanism. `amount` is then deducted from the caller's
211      * allowance.
212      *
213      * Returns a boolean value indicating whether the operation succeeded.
214      *
215      * Emits a {Transfer} event.
216      */
217     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
218 
219     /**
220      * @dev Emitted when `value` tokens are moved from one account (`from`) to
221      * another (`to`).
222      *
223      * Note that `value` may be zero.
224      */
225     event Transfer(address indexed from, address indexed to, uint256 value);
226 
227     /**
228      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
229      * a call to {approve}. `value` is the new allowance.
230      */
231     event Approval(address indexed owner, address indexed spender, uint256 value);
232 }
233 
234 /*
235  * @dev Provides information about the current execution context, including the
236  * sender of the transaction and its data. While these are generally available
237  * via msg.sender and msg.data, they should not be accessed in such a direct
238  * manner, since when dealing with GSN meta-transactions the account sending and
239  * paying for execution may not be the actual sender (as far as an application
240  * is concerned).
241  *
242  * This contract is only required for intermediate, library-like contracts.
243  */
244 abstract contract Context {
245     function _msgSender() internal view virtual returns (address payable) {
246         return msg.sender;
247     }
248 
249     function _msgData() internal view virtual returns (bytes memory) {
250         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
251         return msg.data;
252     }
253 }
254 
255 /**
256  * @dev Contract module which provides a basic access control mechanism, where
257  * there is an account (an owner) that can be granted exclusive access to
258  * specific functions.
259  *
260  * By default, the owner account will be the one that deploys the contract. This
261  * can later be changed with {transferOwnership}.
262  *
263  * This module is used through inheritance. It will make available the modifier
264  * `onlyOwner`, which can be applied to your functions to restrict their use to
265  * the owner.
266  */
267 abstract contract Ownable is Context {
268     address private _owner;
269 
270     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
271 
272     /**
273      * @dev Initializes the contract setting the deployer as the initial owner.
274      */
275     constructor () internal {
276         address msgSender = _msgSender();
277         _owner = msgSender;
278         emit OwnershipTransferred(address(0), msgSender);
279     }
280 
281     /**
282      * @dev Returns the address of the current owner.
283      */
284     function owner() public view returns (address) {
285         return _owner;
286     }
287 
288     /**
289      * @dev Throws if called by any account other than the owner.
290      */
291     modifier onlyOwner() {
292         require(_owner == _msgSender(), "Ownable: caller is not the owner");
293         _;
294     }
295 
296     /**
297      * @dev Leaves the contract without owner. It will not be possible to call
298      * `onlyOwner` functions anymore. Can only be called by the current owner.
299      *
300      * NOTE: Renouncing ownership will leave the contract without an owner,
301      * thereby removing any functionality that is only available to the owner.
302      */
303     function renounceOwnership() public virtual onlyOwner {
304         emit OwnershipTransferred(_owner, address(0));
305         _owner = address(0);
306     }
307 
308     /**
309      * @dev Transfers ownership of the contract to a new account (`newOwner`).
310      * Can only be called by the current owner.
311      */
312     function transferOwnership(address newOwner) public virtual onlyOwner {
313         require(newOwner != address(0), "Ownable: new owner is the zero address");
314         emit OwnershipTransferred(_owner, newOwner);
315         _owner = newOwner;
316     }
317 }
318 
319 
320 /**
321  * @dev Implementation of the {IERC20} interface.
322  *
323  * This implementation is agnostic to the way tokens are created. This means
324  * that a supply mechanism has to be added in a derived contract using {_mint}.
325  * For a generic mechanism see {ERC20PresetMinterPauser}.
326  *
327  * TIP: For a detailed writeup see our guide
328  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
329  * to implement supply mechanisms].
330  *
331  * We have followed general OpenZeppelin guidelines: functions revert instead
332  * of returning `false` on failure. This behavior is nonetheless conventional
333  * and does not conflict with the expectations of ERC20 applications.
334  *
335  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
336  * This allows applications to reconstruct the allowance for all accounts just
337  * by listening to said events. Other implementations of the EIP may not emit
338  * these events, as it isn't required by the specification.
339  *
340  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
341  * functions have been added to mitigate the well-known issues around setting
342  * allowances. See {IERC20-approve}.
343  */
344 contract ERC20 is Context, IERC20 {
345     using SafeMath for uint256;
346 
347     mapping (address => uint256) private _balances;
348 
349     mapping (address => mapping (address => uint256)) private _allowances;
350 
351     uint256 private _totalSupply;
352 
353     string private _name;
354     string private _symbol;
355     uint8 private _decimals;
356 
357     /**
358      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
359      * a default value of 18.
360      *
361      * To select a different value for {decimals}, use {_setupDecimals}.
362      *
363      * All three of these values are immutable: they can only be set once during
364      * construction.
365      */
366     constructor (string memory name_, string memory symbol_) public {
367         _name = name_;
368         _symbol = symbol_;
369         _decimals = 18;
370     }
371 
372     /**
373      * @dev Returns the name of the token.
374      */
375     function name() public view returns (string memory) {
376         return _name;
377     }
378 
379     /**
380      * @dev Returns the symbol of the token, usually a shorter version of the
381      * name.
382      */
383     function symbol() public view returns (string memory) {
384         return _symbol;
385     }
386 
387     /**
388      * @dev Returns the number of decimals used to get its user representation.
389      * For example, if `decimals` equals `2`, a balance of `505` tokens should
390      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
391      *
392      * Tokens usually opt for a value of 18, imitating the relationship between
393      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
394      * called.
395      *
396      * NOTE: This information is only used for _display_ purposes: it in
397      * no way affects any of the arithmetic of the contract, including
398      * {IERC20-balanceOf} and {IERC20-transfer}.
399      */
400     function decimals() public view returns (uint8) {
401         return _decimals;
402     }
403 
404     /**
405      * @dev See {IERC20-totalSupply}.
406      */
407     function totalSupply() public view override returns (uint256) {
408         return _totalSupply;
409     }
410 
411     /**
412      * @dev See {IERC20-balanceOf}.
413      */
414     function balanceOf(address account) public view override returns (uint256) {
415         return _balances[account];
416     }
417 
418     /**
419      * @dev See {IERC20-transfer}.
420      *
421      * Requirements:
422      *
423      * - `recipient` cannot be the zero address.
424      * - the caller must have a balance of at least `amount`.
425      */
426     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
427         _transfer(_msgSender(), recipient, amount);
428         return true;
429     }
430 
431     /**
432      * @dev See {IERC20-allowance}.
433      */
434     function allowance(address owner, address spender) public view virtual override returns (uint256) {
435         return _allowances[owner][spender];
436     }
437 
438     /**
439      * @dev See {IERC20-approve}.
440      *
441      * Requirements:
442      *
443      * - `spender` cannot be the zero address.
444      */
445     function approve(address spender, uint256 amount) public virtual override returns (bool) {
446         _approve(_msgSender(), spender, amount);
447         return true;
448     }
449 
450     /**
451      * @dev See {IERC20-transferFrom}.
452      *
453      * Emits an {Approval} event indicating the updated allowance. This is not
454      * required by the EIP. See the note at the beginning of {ERC20}.
455      *
456      * Requirements:
457      *
458      * - `sender` and `recipient` cannot be the zero address.
459      * - `sender` must have a balance of at least `amount`.
460      * - the caller must have allowance for ``sender``'s tokens of at least
461      * `amount`.
462      */
463     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
464         _transfer(sender, recipient, amount);
465         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
466         return true;
467     }
468 
469     /**
470      * @dev Atomically increases the allowance granted to `spender` by the caller.
471      *
472      * This is an alternative to {approve} that can be used as a mitigation for
473      * problems described in {IERC20-approve}.
474      *
475      * Emits an {Approval} event indicating the updated allowance.
476      *
477      * Requirements:
478      *
479      * - `spender` cannot be the zero address.
480      */
481     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
482         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
483         return true;
484     }
485 
486     /**
487      * @dev Atomically decreases the allowance granted to `spender` by the caller.
488      *
489      * This is an alternative to {approve} that can be used as a mitigation for
490      * problems described in {IERC20-approve}.
491      *
492      * Emits an {Approval} event indicating the updated allowance.
493      *
494      * Requirements:
495      *
496      * - `spender` cannot be the zero address.
497      * - `spender` must have allowance for the caller of at least
498      * `subtractedValue`.
499      */
500     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
501         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
502         return true;
503     }
504 
505     /**
506      * @dev Moves tokens `amount` from `sender` to `recipient`.
507      *
508      * This is internal function is equivalent to {transfer}, and can be used to
509      * e.g. implement automatic token fees, slashing mechanisms, etc.
510      *
511      * Emits a {Transfer} event.
512      *
513      * Requirements:
514      *
515      * - `sender` cannot be the zero address.
516      * - `recipient` cannot be the zero address.
517      * - `sender` must have a balance of at least `amount`.
518      */
519     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
520         require(sender != address(0), "ERC20: transfer from the zero address");
521         require(recipient != address(0), "ERC20: transfer to the zero address");
522 
523         _beforeTokenTransfer(sender, recipient, amount);
524 
525         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
526         _balances[recipient] = _balances[recipient].add(amount);
527         emit Transfer(sender, recipient, amount);
528     }
529 
530     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
531      * the total supply.
532      *
533      * Emits a {Transfer} event with `from` set to the zero address.
534      *
535      * Requirements:
536      *
537      * - `to` cannot be the zero address.
538      */
539     function _mint(address account, uint256 amount) internal virtual {
540         require(account != address(0), "ERC20: mint to the zero address");
541 
542         _beforeTokenTransfer(address(0), account, amount);
543 
544         _totalSupply = _totalSupply.add(amount);
545         _balances[account] = _balances[account].add(amount);
546         emit Transfer(address(0), account, amount);
547     }
548 
549     /**
550      * @dev Destroys `amount` tokens from `account`, reducing the
551      * total supply.
552      *
553      * Emits a {Transfer} event with `to` set to the zero address.
554      *
555      * Requirements:
556      *
557      * - `account` cannot be the zero address.
558      * - `account` must have at least `amount` tokens.
559      */
560     function _burn(address account, uint256 amount) internal virtual {
561         require(account != address(0), "ERC20: burn from the zero address");
562 
563         _beforeTokenTransfer(account, address(0), amount);
564 
565         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
566         _totalSupply = _totalSupply.sub(amount);
567         emit Transfer(account, address(0), amount);
568     }
569 
570     /**
571      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
572      *
573      * This internal function is equivalent to `approve`, and can be used to
574      * e.g. set automatic allowances for certain subsystems, etc.
575      *
576      * Emits an {Approval} event.
577      *
578      * Requirements:
579      *
580      * - `owner` cannot be the zero address.
581      * - `spender` cannot be the zero address.
582      */
583     function _approve(address owner, address spender, uint256 amount) internal virtual {
584         require(owner != address(0), "ERC20: approve from the zero address");
585         require(spender != address(0), "ERC20: approve to the zero address");
586 
587         _allowances[owner][spender] = amount;
588         emit Approval(owner, spender, amount);
589     }
590 
591     /**
592      * @dev Sets {decimals} to a value other than the default one of 18.
593      *
594      * WARNING: This function should only be called from the constructor. Most
595      * applications that interact with token contracts will not expect
596      * {decimals} to ever change, and may work incorrectly if it does.
597      */
598     function _setupDecimals(uint8 decimals_) internal {
599         _decimals = decimals_;
600     }
601 
602     /**
603      * @dev Hook that is called before any transfer of tokens. This includes
604      * minting and burning.
605      *
606      * Calling conditions:
607      *
608      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
609      * will be to transferred to `to`.
610      * - when `from` is zero, `amount` tokens will be minted for `to`.
611      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
612      * - `from` and `to` are never both zero.
613      *
614      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
615      */
616     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
617 }
618 
619 contract POLVEN is Context, Ownable, ERC20 {
620     uint256 constant hardCap = 26789000 ether;
621     uint256 constant timelock6months = 5089910 ether;
622     uint256 constant timelock12months = 5089910 ether;
623     uint256 constant timelock24months = 4286240 ether;
624     uint256 constant timelock36months = 4286240 ether;
625     uint256 public unlocked = 8036700 ether;
626     uint256 public startTime;
627     uint8 public period;
628 
629     /**
630      * @dev Sets the values for {name} and {symbol} in inherited contract
631      * Sets addresses for Owner
632      */
633     constructor (address _ownerAddress) public ERC20('POLVEN', 'POLVEN') {
634         require(_ownerAddress != address(0));
635         transferOwnership(_ownerAddress);
636         startTime = now;
637     }
638 
639     /**
640      * @dev Minting tokens to the specified address (only Minter).
641      */
642     function mint(address _receiverAddress, uint256 _value) public onlyOwner {
643         require(_receiverAddress != address(0), "Receiver can not have zero address");
644         require(_value > 0, "Value should be greater than zero");
645         require(_checkTimelockSchedule(_value), "Value exceeds timelock limit");
646         unlocked = unlocked.sub(_value);
647         _mint(_receiverAddress, _value);
648     }
649 
650     /**
651      * @dev Minting tokens to the specified address (only Minter).
652      */
653     function _getTimelockLimit() internal view returns (uint8, uint256) {
654         uint256 timeDiff = now - startTime;
655         uint256 _unlockedLocal = unlocked;
656         uint8 _periodLocal = period;
657         if (timeDiff >= 183 days && _periodLocal == 0) {
658             _periodLocal = 1;
659             _unlockedLocal = _unlockedLocal.add(timelock6months);
660         }
661         if (timeDiff >= 365 days && _periodLocal == 1) {
662             _periodLocal = 2;
663             _unlockedLocal = _unlockedLocal.add(timelock12months);
664         }
665         if (timeDiff >= 730 days && _periodLocal == 2) {
666             _periodLocal = 3;
667             _unlockedLocal = _unlockedLocal.add(timelock24months);
668         }
669         if (timeDiff >= 1095 days && _periodLocal == 3) {
670             _periodLocal = 4;
671             _unlockedLocal = _unlockedLocal.add(timelock36months);
672         }
673 
674         return (_periodLocal, _unlockedLocal);
675     }
676 
677     /**
678      * @dev Minting tokens to the specified address (only Minter).
679      */
680     function _checkTimelockSchedule(uint256 _value) internal returns (bool) {
681         (period, unlocked) = _getTimelockLimit();
682         return _value <= unlocked;
683     }
684 }