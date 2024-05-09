1 // File: contracts/utils/Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity >=0.6.0 <0.8.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: contracts/token/ERC20/IERC20.sol
29 
30 
31 pragma solidity >=0.6.0 <0.8.0;
32 
33 /**
34  * @dev Interface of the ERC20 standard as defined in the EIP.
35  */
36 interface IERC20 {
37     /**
38      * @dev Returns the amount of tokens in existence.
39      */
40     function totalSupply() external view returns (uint256);
41 
42     /**
43      * @dev Returns the amount of tokens owned by `account`.
44      */
45     function balanceOf(address account) external view returns (uint256);
46 
47     /**
48      * @dev Moves `amount` tokens from the caller's account to `recipient`.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * Emits a {Transfer} event.
53      */
54     function transfer(address recipient, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Returns the remaining number of tokens that `spender` will be
58      * allowed to spend on behalf of `owner` through {transferFrom}. This is
59      * zero by default.
60      *
61      * This value changes when {approve} or {transferFrom} are called.
62      */
63     function allowance(address owner, address spender) external view returns (uint256);
64 
65     /**
66      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * IMPORTANT: Beware that changing an allowance with this method brings the risk
71      * that someone may use both the old and the new allowance by unfortunate
72      * transaction ordering. One possible solution to mitigate this race
73      * condition is to first reduce the spender's allowance to 0 and set the
74      * desired value afterwards:
75      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
76      *
77      * Emits an {Approval} event.
78      */
79     function approve(address spender, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Moves `amount` tokens from `sender` to `recipient` using the
83      * allowance mechanism. `amount` is then deducted from the caller's
84      * allowance.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
91 
92     /**
93      * @dev Emitted when `value` tokens are moved from one account (`from`) to
94      * another (`to`).
95      *
96      * Note that `value` may be zero.
97      */
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 
100     /**
101      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
102      * a call to {approve}. `value` is the new allowance.
103      */
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 // File: contracts/math/SafeMath.sol
108 
109 
110 pragma solidity >=0.6.0 <0.8.0;
111 
112 /**
113  * @dev Wrappers over Solidity's arithmetic operations with added overflow
114  * checks.
115  *
116  * Arithmetic operations in Solidity wrap on overflow. This can easily result
117  * in bugs, because programmers usually assume that an overflow raises an
118  * error, which is the standard behavior in high level programming languages.
119  * `SafeMath` restores this intuition by reverting the transaction when an
120  * operation overflows.
121  *
122  * Using this library instead of the unchecked operations eliminates an entire
123  * class of bugs, so it's recommended to use it always.
124  */
125 library SafeMath {
126     /**
127      * @dev Returns the addition of two unsigned integers, with an overflow flag.
128      */
129     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
130         uint256 c = a + b;
131         if (c < a) return (false, 0);
132         return (true, c);
133     }
134 
135     /**
136      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
137      */
138     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
139         if (b > a) return (false, 0);
140         return (true, a - b);
141     }
142 
143     /**
144      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
145      */
146     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
147         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
148         // benefit is lost if 'b' is also tested.
149         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
150         if (a == 0) return (true, 0);
151         uint256 c = a * b;
152         if (c / a != b) return (false, 0);
153         return (true, c);
154     }
155 
156     /**
157      * @dev Returns the division of two unsigned integers, with a division by zero flag.
158      */
159     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
160         if (b == 0) return (false, 0);
161         return (true, a / b);
162     }
163 
164     /**
165      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
166      */
167     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
168         if (b == 0) return (false, 0);
169         return (true, a % b);
170     }
171 
172     /**
173      * @dev Returns the addition of two unsigned integers, reverting on
174      * overflow.
175      *
176      * Counterpart to Solidity's `+` operator.
177      *
178      * Requirements:
179      *
180      * - Addition cannot overflow.
181      */
182     function add(uint256 a, uint256 b) internal pure returns (uint256) {
183         uint256 c = a + b;
184         require(c >= a, "SafeMath: addition overflow");
185         return c;
186     }
187 
188     /**
189      * @dev Returns the subtraction of two unsigned integers, reverting on
190      * overflow (when the result is negative).
191      *
192      * Counterpart to Solidity's `-` operator.
193      *
194      * Requirements:
195      *
196      * - Subtraction cannot overflow.
197      */
198     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
199         require(b <= a, "SafeMath: subtraction overflow");
200         return a - b;
201     }
202 
203     /**
204      * @dev Returns the multiplication of two unsigned integers, reverting on
205      * overflow.
206      *
207      * Counterpart to Solidity's `*` operator.
208      *
209      * Requirements:
210      *
211      * - Multiplication cannot overflow.
212      */
213     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
214         if (a == 0) return 0;
215         uint256 c = a * b;
216         require(c / a == b, "SafeMath: multiplication overflow");
217         return c;
218     }
219 
220     /**
221      * @dev Returns the integer division of two unsigned integers, reverting on
222      * division by zero. The result is rounded towards zero.
223      *
224      * Counterpart to Solidity's `/` operator. Note: this function uses a
225      * `revert` opcode (which leaves remaining gas untouched) while Solidity
226      * uses an invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      *
230      * - The divisor cannot be zero.
231      */
232     function div(uint256 a, uint256 b) internal pure returns (uint256) {
233         require(b > 0, "SafeMath: division by zero");
234         return a / b;
235     }
236 
237     /**
238      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
239      * reverting when dividing by zero.
240      *
241      * Counterpart to Solidity's `%` operator. This function uses a `revert`
242      * opcode (which leaves remaining gas untouched) while Solidity uses an
243      * invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      *
247      * - The divisor cannot be zero.
248      */
249     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
250         require(b > 0, "SafeMath: modulo by zero");
251         return a % b;
252     }
253 
254     /**
255      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
256      * overflow (when the result is negative).
257      *
258      * CAUTION: This function is deprecated because it requires allocating memory for the error
259      * message unnecessarily. For custom revert reasons use {trySub}.
260      *
261      * Counterpart to Solidity's `-` operator.
262      *
263      * Requirements:
264      *
265      * - Subtraction cannot overflow.
266      */
267     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
268         require(b <= a, errorMessage);
269         return a - b;
270     }
271 
272     /**
273      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
274      * division by zero. The result is rounded towards zero.
275      *
276      * CAUTION: This function is deprecated because it requires allocating memory for the error
277      * message unnecessarily. For custom revert reasons use {tryDiv}.
278      *
279      * Counterpart to Solidity's `/` operator. Note: this function uses a
280      * `revert` opcode (which leaves remaining gas untouched) while Solidity
281      * uses an invalid opcode to revert (consuming all remaining gas).
282      *
283      * Requirements:
284      *
285      * - The divisor cannot be zero.
286      */
287     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
288         require(b > 0, errorMessage);
289         return a / b;
290     }
291 
292     /**
293      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
294      * reverting with custom message when dividing by zero.
295      *
296      * CAUTION: This function is deprecated because it requires allocating memory for the error
297      * message unnecessarily. For custom revert reasons use {tryMod}.
298      *
299      * Counterpart to Solidity's `%` operator. This function uses a `revert`
300      * opcode (which leaves remaining gas untouched) while Solidity uses an
301      * invalid opcode to revert (consuming all remaining gas).
302      *
303      * Requirements:
304      *
305      * - The divisor cannot be zero.
306      */
307     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
308         require(b > 0, errorMessage);
309         return a % b;
310     }
311 }
312 
313 // File: contracts/access/Ownable.sol
314 
315 
316 pragma solidity >=0.6.0 <0.8.0;
317 
318 /**
319  * @dev Contract module which provides a basic access control mechanism, where
320  * there is an account (an owner) that can be granted exclusive access to
321  * specific functions.
322  *
323  * By default, the owner account will be the one that deploys the contract. This
324  * can later be changed with {transferOwnership}.
325  *
326  * This module is used through inheritance. It will make available the modifier
327  * `onlyOwner`, which can be applied to your functions to restrict their use to
328  * the owner.
329  */
330 abstract contract Ownable is Context {
331     address private _owner;
332 
333     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
334 
335     /**
336      * @dev Initializes the contract setting the deployer as the initial owner.
337      */
338     constructor () internal {
339         address msgSender = _msgSender();
340         _owner = msgSender;
341         emit OwnershipTransferred(address(0), msgSender);
342     }
343 
344     /**
345      * @dev Returns the address of the current owner.
346      */
347     function owner() public view returns (address) {
348         return _owner;
349     }
350 
351     /**
352      * @dev Throws if called by any account other than the owner.
353      */
354     modifier onlyOwner() {
355         require(_owner == _msgSender(), "Ownable: caller is not the owner");
356         _;
357     }
358 
359     /**
360      * @dev Leaves the contract without owner. It will not be possible to call
361      * `onlyOwner` functions anymore. Can only be called by the current owner.
362      *
363      * NOTE: Renouncing ownership will leave the contract without an owner,
364      * thereby removing any functionality that is only available to the owner.
365      */
366     function renounceOwnership() public virtual onlyOwner {
367         emit OwnershipTransferred(_owner, address(0));
368         _owner = address(0);
369     }
370 
371     /**
372      * @dev Transfers ownership of the contract to a new account (`newOwner`).
373      * Can only be called by the current owner.
374      */
375     function transferOwnership(address newOwner) public virtual onlyOwner {
376         require(newOwner != address(0), "Ownable: new owner is the zero address");
377         emit OwnershipTransferred(_owner, newOwner);
378         _owner = newOwner;
379     }
380 }
381 
382 // File: contracts/token/ERC20/ERC20.sol
383 
384 
385 pragma solidity >=0.6.0 <0.8.0;
386 
387 
388 
389 
390 
391 /**
392  * @dev Implementation of the {IERC20} interface.
393  *
394  * This implementation is agnostic to the way tokens are created. This means
395  * that a supply mechanism has to be added in a derived contract using {_mint}.
396  * For a generic mechanism see {ERC20PresetMinterPauser}.
397  *
398  * TIP: For a detailed writeup see our guide
399  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
400  * to implement supply mechanisms].
401  *
402  * We have followed general OpenZeppelin guidelines: functions revert instead
403  * of returning `false` on failure. This behavior is nonetheless conventional
404  * and does not conflict with the expectations of ERC20 applications.
405  *
406  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
407  * This allows applications to reconstruct the allowance for all accounts just
408  * by listening to said events. Other implementations of the EIP may not emit
409  * these events, as it isn't required by the specification.
410  *
411  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
412  * functions have been added to mitigate the well-known issues around setting
413  * allowances. See {IERC20-approve}.
414  */
415 contract ERC20 is Context, IERC20, Ownable {
416     using SafeMath for uint256;
417 
418     mapping (address => uint256) private _balances;
419 
420     mapping (address => mapping (address => uint256)) private _allowances;
421 
422     uint256 private _totalSupply;
423 
424     string private _name;
425     string private _symbol;
426     uint8 private _decimals;
427 
428     /**
429      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
430      * a default value of 18.
431      *
432      * To select a different value for {decimals}, use {_setupDecimals}.
433      *
434      * All three of these values are immutable: they can only be set once during
435      * construction.
436      */
437     constructor (string memory name_, string memory symbol_) public {
438         _name = name_;
439         _symbol = symbol_;
440         _decimals = 18;
441     }
442 
443     /**
444      * @dev Returns the name of the token.
445      */
446     function name() public view returns (string memory) {
447         return _name;
448     }
449 
450     /**
451      * @dev Returns the symbol of the token, usually a shorter version of the
452      * name.
453      */
454     function symbol() public view returns (string memory) {
455         return _symbol;
456     }
457 
458     /**
459      * @dev Returns the number of decimals used to get its user representation.
460      * For example, if `decimals` equals `2`, a balance of `505` tokens should
461      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
462      *
463      * Tokens usually opt for a value of 18, imitating the relationship between
464      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
465      * called.
466      *
467      * NOTE: This information is only used for _display_ purposes: it in
468      * no way affects any of the arithmetic of the contract, including
469      * {IERC20-balanceOf} and {IERC20-transfer}.
470      */
471     function decimals() public view returns (uint8) {
472         return _decimals;
473     }
474 
475     /**
476      * @dev See {IERC20-totalSupply}.
477      */
478     function totalSupply() public view override returns (uint256) {
479         return _totalSupply;
480     }
481 
482     /**
483      * @dev See {IERC20-balanceOf}.
484      */
485     function balanceOf(address account) public view override returns (uint256) {
486         return _balances[account];
487     }
488 
489     /**
490      * @dev See {IERC20-transfer}.
491      *
492      * Requirements:
493      *
494      * - `recipient` cannot be the zero address.
495      * - the caller must have a balance of at least `amount`.
496      */
497     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
498         _transfer(_msgSender(), recipient, amount);
499         return true;
500     }
501 
502     /**
503      * @dev See {IERC20-allowance}.
504      */
505     function allowance(address owner, address spender) public view virtual override returns (uint256) {
506         return _allowances[owner][spender];
507     }
508 
509     /**
510      * @dev See {IERC20-approve}.
511      *
512      * Requirements:
513      *
514      * - `spender` cannot be the zero address.
515      */
516     function approve(address spender, uint256 amount) public virtual override returns (bool) {
517         _approve(_msgSender(), spender, amount);
518         return true;
519     }
520 
521     /**
522      * @dev See {IERC20-transferFrom}.
523      *
524      * Emits an {Approval} event indicating the updated allowance. This is not
525      * required by the EIP. See the note at the beginning of {ERC20}.
526      *
527      * Requirements:
528      *
529      * - `sender` and `recipient` cannot be the zero address.
530      * - `sender` must have a balance of at least `amount`.
531      * - the caller must have allowance for ``sender``'s tokens of at least
532      * `amount`.
533      */
534     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
535         _transfer(sender, recipient, amount);
536         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
537         return true;
538     }
539 
540     /**
541      * @dev Atomically increases the allowance granted to `spender` by the caller.
542      *
543      * This is an alternative to {approve} that can be used as a mitigation for
544      * problems described in {IERC20-approve}.
545      *
546      * Emits an {Approval} event indicating the updated allowance.
547      *
548      * Requirements:
549      *
550      * - `spender` cannot be the zero address.
551      */
552     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
553         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
554         return true;
555     }
556 
557     /**
558      * @dev Atomically decreases the allowance granted to `spender` by the caller.
559      *
560      * This is an alternative to {approve} that can be used as a mitigation for
561      * problems described in {IERC20-approve}.
562      *
563      * Emits an {Approval} event indicating the updated allowance.
564      *
565      * Requirements:
566      *
567      * - `spender` cannot be the zero address.
568      * - `spender` must have allowance for the caller of at least
569      * `subtractedValue`.
570      */
571     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
572         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
573         return true;
574     }
575 
576     /**
577      * @dev Moves tokens `amount` from `sender` to `recipient`.
578      *
579      * This is internal function is equivalent to {transfer}, and can be used to
580      * e.g. implement automatic token fees, slashing mechanisms, etc.
581      *
582      * Emits a {Transfer} event.
583      *
584      * Requirements:
585      *
586      * - `sender` cannot be the zero address.
587      * - `recipient` cannot be the zero address.
588      * - `sender` must have a balance of at least `amount`.
589      */
590     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
591         require(sender != address(0), "ERC20: transfer from the zero address");
592         require(recipient != address(0), "ERC20: transfer to the zero address");
593 
594         _beforeTokenTransfer(sender, recipient, amount);
595 
596         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
597         _balances[recipient] = _balances[recipient].add(amount);
598         emit Transfer(sender, recipient, amount);
599     }
600 
601     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
602      * the total supply.
603      *
604      * Emits a {Transfer} event with `from` set to the zero address.
605      *
606      * Requirements:
607      *
608      * - `to` cannot be the zero address.
609      */
610     function mint(address account, uint256 amount) public onlyOwner {
611         require(account != address(0), "ERC20: mint to the zero address");
612 
613         _beforeTokenTransfer(address(0), account, amount);
614 
615         _totalSupply = _totalSupply.add(amount);
616         _balances[account] = _balances[account].add(amount);
617         emit Transfer(address(0), account, amount);
618     }
619 
620     /**
621      * @dev Destroys `amount` tokens from `account`, reducing the
622      * total supply.
623      *
624      * Emits a {Transfer} event with `to` set to the zero address.
625      *
626      * Requirements:
627      *
628      * - `account` cannot be the zero address.
629      * - `account` must have at least `amount` tokens.
630      */
631     function _burn(address account, uint256 amount) internal virtual {
632         require(account != address(0), "ERC20: burn from the zero address");
633 
634         _beforeTokenTransfer(account, address(0), amount);
635 
636         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
637         _totalSupply = _totalSupply.sub(amount);
638         emit Transfer(account, address(0), amount);
639     }
640 
641     /**
642      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
643      *
644      * This internal function is equivalent to `approve`, and can be used to
645      * e.g. set automatic allowances for certain subsystems, etc.
646      *
647      * Emits an {Approval} event.
648      *
649      * Requirements:
650      *
651      * - `owner` cannot be the zero address.
652      * - `spender` cannot be the zero address.
653      */
654     function _approve(address owner, address spender, uint256 amount) internal virtual {
655         require(owner != address(0), "ERC20: approve from the zero address");
656         require(spender != address(0), "ERC20: approve to the zero address");
657 
658         _allowances[owner][spender] = amount;
659         emit Approval(owner, spender, amount);
660     }
661 
662     /**
663      * @dev Sets {decimals} to a value other than the default one of 18.
664      *
665      * WARNING: This function should only be called from the constructor. Most
666      * applications that interact with token contracts will not expect
667      * {decimals} to ever change, and may work incorrectly if it does.
668      */
669     function _setupDecimals(uint8 decimals_) internal virtual {
670         _decimals = decimals_;
671     }
672 
673     /**
674      * @dev Hook that is called before any transfer of tokens. This includes
675      * minting and burning.
676      *
677      * Calling conditions:
678      *
679      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
680      * will be to transferred to `to`.
681      * - when `from` is zero, `amount` tokens will be minted for `to`.
682      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
683      * - `from` and `to` are never both zero.
684      *
685      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
686      */
687     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
688 }