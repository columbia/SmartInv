1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/access/Ownable.sol
2 
3 //SPDX-License-Identifier: MIT
4 
5 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/utils/Context.sol
6 
7 
8 
9 pragma solidity >=0.6.0 <0.8.0;
10 
11 /*
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with GSN meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address payable) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/token/ERC20/ERC20.sol
33 
34 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/token/ERC20/IERC20.sol
35 
36 
37 
38 pragma solidity >=0.6.0 <0.8.0;
39 
40 /**
41  * @dev Interface of the ERC20 standard as defined in the EIP.
42  */
43 interface IERC20 {
44     /**
45      * @dev Returns the amount of tokens in existence.
46      */
47     function totalSupply() external view returns (uint256);
48 
49     /**
50      * @dev Returns the amount of tokens owned by `account`.
51      */
52     function balanceOf(address account) external view returns (uint256);
53 
54     /**
55      * @dev Moves `amount` tokens from the caller's account to `recipient`.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transfer(address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Returns the remaining number of tokens that `spender` will be
65      * allowed to spend on behalf of `owner` through {transferFrom}. This is
66      * zero by default.
67      *
68      * This value changes when {approve} or {transferFrom} are called.
69      */
70     function allowance(address owner, address spender) external view returns (uint256);
71 
72     /**
73      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * IMPORTANT: Beware that changing an allowance with this method brings the risk
78      * that someone may use both the old and the new allowance by unfortunate
79      * transaction ordering. One possible solution to mitigate this race
80      * condition is to first reduce the spender's allowance to 0 and set the
81      * desired value afterwards:
82      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
83      *
84      * Emits an {Approval} event.
85      */
86     function approve(address spender, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Moves `amount` tokens from `sender` to `recipient` using the
90      * allowance mechanism. `amount` is then deducted from the caller's
91      * allowance.
92      *
93      * Returns a boolean value indicating whether the operation succeeded.
94      *
95      * Emits a {Transfer} event.
96      */
97     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
98 
99     /**
100      * @dev Emitted when `value` tokens are moved from one account (`from`) to
101      * another (`to`).
102      *
103      * Note that `value` may be zero.
104      */
105     event Transfer(address indexed from, address indexed to, uint256 value);
106 
107     /**
108      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
109      * a call to {approve}. `value` is the new allowance.
110      */
111     event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 pragma solidity >=0.6.0 <0.8.0;
115 
116 
117 
118 
119 /**
120  * @dev Implementation of the {IERC20} interface.
121  *
122  * This implementation is agnostic to the way tokens are created. This means
123  * that a supply mechanism has to be added in a derived contract using {_mint}.
124  * For a generic mechanism see {ERC20PresetMinterPauser}.
125  *
126  * TIP: For a detailed writeup see our guide
127  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
128  * to implement supply mechanisms].
129  *
130  * We have followed general OpenZeppelin guidelines: functions revert instead
131  * of returning `false` on failure. This behavior is nonetheless conventional
132  * and does not conflict with the expectations of ERC20 applications.
133  *
134  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
135  * This allows applications to reconstruct the allowance for all accounts just
136  * by listening to said events. Other implementations of the EIP may not emit
137  * these events, as it isn't required by the specification.
138  *
139  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
140  * functions have been added to mitigate the well-known issues around setting
141  * allowances. See {IERC20-approve}.
142  */
143 contract ERC20 is Context, IERC20 {
144     using SafeMath for uint256;
145 
146     mapping (address => uint256) private _balances;
147 
148     mapping (address => mapping (address => uint256)) private _allowances;
149 
150     uint256 private _totalSupply;
151 
152     string private _name;
153     string private _symbol;
154     uint8 private _decimals;
155 
156     /**
157      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
158      * a default value of 18.
159      *
160      * To select a different value for {decimals}, use {_setupDecimals}.
161      *
162      * All three of these values are immutable: they can only be set once during
163      * construction.
164      */
165     constructor (string memory name_, string memory symbol_) public {
166         _name = name_;
167         _symbol = symbol_;
168         _decimals = 18;
169     }
170 
171     /**
172      * @dev Returns the name of the token.
173      */
174     function name() public view virtual returns (string memory) {
175         return _name;
176     }
177 
178     /**
179      * @dev Returns the symbol of the token, usually a shorter version of the
180      * name.
181      */
182     function symbol() public view virtual returns (string memory) {
183         return _symbol;
184     }
185 
186     /**
187      * @dev Returns the number of decimals used to get its user representation.
188      * For example, if `decimals` equals `2`, a balance of `505` tokens should
189      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
190      *
191      * Tokens usually opt for a value of 18, imitating the relationship between
192      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
193      * called.
194      *
195      * NOTE: This information is only used for _display_ purposes: it in
196      * no way affects any of the arithmetic of the contract, including
197      * {IERC20-balanceOf} and {IERC20-transfer}.
198      */
199     function decimals() public view virtual returns (uint8) {
200         return _decimals;
201     }
202 
203     /**
204      * @dev See {IERC20-totalSupply}.
205      */
206     function totalSupply() public view virtual override returns (uint256) {
207         return _totalSupply;
208     }
209 
210     /**
211      * @dev See {IERC20-balanceOf}.
212      */
213     function balanceOf(address account) public view virtual override returns (uint256) {
214         return _balances[account];
215     }
216 
217     /**
218      * @dev See {IERC20-transfer}.
219      *
220      * Requirements:
221      *
222      * - `recipient` cannot be the zero address.
223      * - the caller must have a balance of at least `amount`.
224      */
225     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
226         _transfer(_msgSender(), recipient, amount);
227         return true;
228     }
229 
230     /**
231      * @dev See {IERC20-allowance}.
232      */
233     function allowance(address owner, address spender) public view virtual override returns (uint256) {
234         return _allowances[owner][spender];
235     }
236 
237     /**
238      * @dev See {IERC20-approve}.
239      *
240      * Requirements:
241      *
242      * - `spender` cannot be the zero address.
243      */
244     function approve(address spender, uint256 amount) public virtual override returns (bool) {
245         _approve(_msgSender(), spender, amount);
246         return true;
247     }
248 
249     /**
250      * @dev See {IERC20-transferFrom}.
251      *
252      * Emits an {Approval} event indicating the updated allowance. This is not
253      * required by the EIP. See the note at the beginning of {ERC20}.
254      *
255      * Requirements:
256      *
257      * - `sender` and `recipient` cannot be the zero address.
258      * - `sender` must have a balance of at least `amount`.
259      * - the caller must have allowance for ``sender``'s tokens of at least
260      * `amount`.
261      */
262     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
263         _transfer(sender, recipient, amount);
264         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
265         return true;
266     }
267 
268     /**
269      * @dev Atomically increases the allowance granted to `spender` by the caller.
270      *
271      * This is an alternative to {approve} that can be used as a mitigation for
272      * problems described in {IERC20-approve}.
273      *
274      * Emits an {Approval} event indicating the updated allowance.
275      *
276      * Requirements:
277      *
278      * - `spender` cannot be the zero address.
279      */
280     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
281         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
282         return true;
283     }
284 
285     /**
286      * @dev Atomically decreases the allowance granted to `spender` by the caller.
287      *
288      * This is an alternative to {approve} that can be used as a mitigation for
289      * problems described in {IERC20-approve}.
290      *
291      * Emits an {Approval} event indicating the updated allowance.
292      *
293      * Requirements:
294      *
295      * - `spender` cannot be the zero address.
296      * - `spender` must have allowance for the caller of at least
297      * `subtractedValue`.
298      */
299     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
300         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
301         return true;
302     }
303 
304     /**
305      * @dev Moves tokens `amount` from `sender` to `recipient`.
306      *
307      * This is internal function is equivalent to {transfer}, and can be used to
308      * e.g. implement automatic token fees, slashing mechanisms, etc.
309      *
310      * Emits a {Transfer} event.
311      *
312      * Requirements:
313      *
314      * - `sender` cannot be the zero address.
315      * - `recipient` cannot be the zero address.
316      * - `sender` must have a balance of at least `amount`.
317      */
318     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
319         require(sender != address(0), "ERC20: transfer from the zero address");
320         require(recipient != address(0), "ERC20: transfer to the zero address");
321 
322         _beforeTokenTransfer(sender, recipient, amount);
323 
324         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
325         _balances[recipient] = _balances[recipient].add(amount);
326         emit Transfer(sender, recipient, amount);
327     }
328 
329     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
330      * the total supply.
331      *
332      * Emits a {Transfer} event with `from` set to the zero address.
333      *
334      * Requirements:
335      *
336      * - `to` cannot be the zero address.
337      */
338     function _mint(address account, uint256 amount) internal virtual {
339         require(account != address(0), "ERC20: mint to the zero address");
340 
341         _beforeTokenTransfer(address(0), account, amount);
342 
343         _totalSupply = _totalSupply.add(amount);
344         _balances[account] = _balances[account].add(amount);
345         emit Transfer(address(0), account, amount);
346     }
347 
348     /**
349      * @dev Destroys `amount` tokens from `account`, reducing the
350      * total supply.
351      *
352      * Emits a {Transfer} event with `to` set to the zero address.
353      *
354      * Requirements:
355      *
356      * - `account` cannot be the zero address.
357      * - `account` must have at least `amount` tokens.
358      */
359     function _burn(address account, uint256 amount) internal virtual {
360         require(account != address(0), "ERC20: burn from the zero address");
361 
362         _beforeTokenTransfer(account, address(0), amount);
363 
364         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
365         _totalSupply = _totalSupply.sub(amount);
366         emit Transfer(account, address(0), amount);
367     }
368 
369     /**
370      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
371      *
372      * This internal function is equivalent to `approve`, and can be used to
373      * e.g. set automatic allowances for certain subsystems, etc.
374      *
375      * Emits an {Approval} event.
376      *
377      * Requirements:
378      *
379      * - `owner` cannot be the zero address.
380      * - `spender` cannot be the zero address.
381      */
382     function _approve(address owner, address spender, uint256 amount) internal virtual {
383         require(owner != address(0), "ERC20: approve from the zero address");
384         require(spender != address(0), "ERC20: approve to the zero address");
385 
386         _allowances[owner][spender] = amount;
387         emit Approval(owner, spender, amount);
388     }
389 
390     /**
391      * @dev Sets {decimals} to a value other than the default one of 18.
392      *
393      * WARNING: This function should only be called from the constructor. Most
394      * applications that interact with token contracts will not expect
395      * {decimals} to ever change, and may work incorrectly if it does.
396      */
397     function _setupDecimals(uint8 decimals_) internal virtual {
398         _decimals = decimals_;
399     }
400 
401     /**
402      * @dev Hook that is called before any transfer of tokens. This includes
403      * minting and burning.
404      *
405      * Calling conditions:
406      *
407      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
408      * will be to transferred to `to`.
409      * - when `from` is zero, `amount` tokens will be minted for `to`.
410      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
411      * - `from` and `to` are never both zero.
412      *
413      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
414      */
415     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
416 }
417 
418 
419 pragma solidity >=0.6.0 <0.8.0;
420 
421 /**
422  * @dev Contract module which provides a basic access control mechanism, where
423  * there is an account (an owner) that can be granted exclusive access to
424  * specific functions.
425  *
426  * By default, the owner account will be the one that deploys the contract. This
427  * can later be changed with {transferOwnership}.
428  *
429  * This module is used through inheritance. It will make available the modifier
430  * `onlyOwner`, which can be applied to your functions to restrict their use to
431  * the owner.
432  */
433 abstract contract Ownable is Context {
434     address private _owner;
435 
436     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
437 
438     /**
439      * @dev Initializes the contract setting the deployer as the initial owner.
440      */
441     constructor () internal {
442         address msgSender = _msgSender();
443         _owner = msgSender;
444         emit OwnershipTransferred(address(0), msgSender);
445     }
446 
447     /**
448      * @dev Returns the address of the current owner.
449      */
450     function owner() public view virtual returns (address) {
451         return _owner;
452     }
453 
454     /**
455      * @dev Throws if called by any account other than the owner.
456      */
457     modifier onlyOwner() {
458         require(owner() == _msgSender(), "Ownable: caller is not the owner");
459         _;
460     }
461 
462     /**
463      * @dev Leaves the contract without owner. It will not be possible to call
464      * `onlyOwner` functions anymore. Can only be called by the current owner.
465      *
466      * NOTE: Renouncing ownership will leave the contract without an owner,
467      * thereby removing any functionality that is only available to the owner.
468      */
469     function renounceOwnership() public virtual onlyOwner {
470         emit OwnershipTransferred(_owner, address(0));
471         _owner = address(0);
472     }
473 
474     /**
475      * @dev Transfers ownership of the contract to a new account (`newOwner`).
476      * Can only be called by the current owner.
477      */
478     function transferOwnership(address newOwner) public virtual onlyOwner {
479         require(newOwner != address(0), "Ownable: new owner is the zero address");
480         emit OwnershipTransferred(_owner, newOwner);
481         _owner = newOwner;
482     }
483 }
484 
485 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/token/ERC20/ERC20Capped.sol
486 
487 
488 
489 pragma solidity >=0.6.0 <0.8.0;
490 
491 
492 /**
493  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
494  */
495 abstract contract ERC20Capped is ERC20 {
496     using SafeMath for uint256;
497 
498     uint256 private _cap;
499 
500     /**
501      * @dev Sets the value of the `cap`. This value is immutable, it can only be
502      * set once during construction.
503      */
504     constructor (uint256 cap_) internal {
505         require(cap_ > 0, "ERC20Capped: cap is 0");
506         _cap = cap_;
507     }
508 
509     /**
510      * @dev Returns the cap on the token's total supply.
511      */
512     function cap() public view virtual returns (uint256) {
513         return _cap;
514     }
515 
516     /**
517      * @dev See {ERC20-_beforeTokenTransfer}.
518      *
519      * Requirements:
520      *
521      * - minted tokens must not cause the total supply to go over the cap.
522      */
523     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
524         super._beforeTokenTransfer(from, to, amount);
525 
526         if (from == address(0)) { // When minting tokens
527             require(totalSupply().add(amount) <= cap(), "ERC20Capped: cap exceeded");
528         }
529     }
530 }
531 
532 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/math/SafeMath.sol
533 
534 
535 
536 pragma solidity >=0.6.0 <0.8.0;
537 
538 /**
539  * @dev Wrappers over Solidity's arithmetic operations with added overflow
540  * checks.
541  *
542  * Arithmetic operations in Solidity wrap on overflow. This can easily result
543  * in bugs, because programmers usually assume that an overflow raises an
544  * error, which is the standard behavior in high level programming languages.
545  * `SafeMath` restores this intuition by reverting the transaction when an
546  * operation overflows.
547  *
548  * Using this library instead of the unchecked operations eliminates an entire
549  * class of bugs, so it's recommended to use it always.
550  */
551 library SafeMath {
552     /**
553      * @dev Returns the addition of two unsigned integers, with an overflow flag.
554      *
555      * _Available since v3.4._
556      */
557     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
558         uint256 c = a + b;
559         if (c < a) return (false, 0);
560         return (true, c);
561     }
562 
563     /**
564      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
565      *
566      * _Available since v3.4._
567      */
568     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
569         if (b > a) return (false, 0);
570         return (true, a - b);
571     }
572 
573     /**
574      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
575      *
576      * _Available since v3.4._
577      */
578     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
579         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
580         // benefit is lost if 'b' is also tested.
581         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
582         if (a == 0) return (true, 0);
583         uint256 c = a * b;
584         if (c / a != b) return (false, 0);
585         return (true, c);
586     }
587 
588     /**
589      * @dev Returns the division of two unsigned integers, with a division by zero flag.
590      *
591      * _Available since v3.4._
592      */
593     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
594         if (b == 0) return (false, 0);
595         return (true, a / b);
596     }
597 
598     /**
599      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
600      *
601      * _Available since v3.4._
602      */
603     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
604         if (b == 0) return (false, 0);
605         return (true, a % b);
606     }
607 
608     /**
609      * @dev Returns the addition of two unsigned integers, reverting on
610      * overflow.
611      *
612      * Counterpart to Solidity's `+` operator.
613      *
614      * Requirements:
615      *
616      * - Addition cannot overflow.
617      */
618     function add(uint256 a, uint256 b) internal pure returns (uint256) {
619         uint256 c = a + b;
620         require(c >= a, "SafeMath: addition overflow");
621         return c;
622     }
623 
624     /**
625      * @dev Returns the subtraction of two unsigned integers, reverting on
626      * overflow (when the result is negative).
627      *
628      * Counterpart to Solidity's `-` operator.
629      *
630      * Requirements:
631      *
632      * - Subtraction cannot overflow.
633      */
634     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
635         require(b <= a, "SafeMath: subtraction overflow");
636         return a - b;
637     }
638 
639     /**
640      * @dev Returns the multiplication of two unsigned integers, reverting on
641      * overflow.
642      *
643      * Counterpart to Solidity's `*` operator.
644      *
645      * Requirements:
646      *
647      * - Multiplication cannot overflow.
648      */
649     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
650         if (a == 0) return 0;
651         uint256 c = a * b;
652         require(c / a == b, "SafeMath: multiplication overflow");
653         return c;
654     }
655 
656     /**
657      * @dev Returns the integer division of two unsigned integers, reverting on
658      * division by zero. The result is rounded towards zero.
659      *
660      * Counterpart to Solidity's `/` operator. Note: this function uses a
661      * `revert` opcode (which leaves remaining gas untouched) while Solidity
662      * uses an invalid opcode to revert (consuming all remaining gas).
663      *
664      * Requirements:
665      *
666      * - The divisor cannot be zero.
667      */
668     function div(uint256 a, uint256 b) internal pure returns (uint256) {
669         require(b > 0, "SafeMath: division by zero");
670         return a / b;
671     }
672 
673     /**
674      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
675      * reverting when dividing by zero.
676      *
677      * Counterpart to Solidity's `%` operator. This function uses a `revert`
678      * opcode (which leaves remaining gas untouched) while Solidity uses an
679      * invalid opcode to revert (consuming all remaining gas).
680      *
681      * Requirements:
682      *
683      * - The divisor cannot be zero.
684      */
685     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
686         require(b > 0, "SafeMath: modulo by zero");
687         return a % b;
688     }
689 
690     /**
691      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
692      * overflow (when the result is negative).
693      *
694      * CAUTION: This function is deprecated because it requires allocating memory for the error
695      * message unnecessarily. For custom revert reasons use {trySub}.
696      *
697      * Counterpart to Solidity's `-` operator.
698      *
699      * Requirements:
700      *
701      * - Subtraction cannot overflow.
702      */
703     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
704         require(b <= a, errorMessage);
705         return a - b;
706     }
707 
708     /**
709      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
710      * division by zero. The result is rounded towards zero.
711      *
712      * CAUTION: This function is deprecated because it requires allocating memory for the error
713      * message unnecessarily. For custom revert reasons use {tryDiv}.
714      *
715      * Counterpart to Solidity's `/` operator. Note: this function uses a
716      * `revert` opcode (which leaves remaining gas untouched) while Solidity
717      * uses an invalid opcode to revert (consuming all remaining gas).
718      *
719      * Requirements:
720      *
721      * - The divisor cannot be zero.
722      */
723     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
724         require(b > 0, errorMessage);
725         return a / b;
726     }
727 
728     /**
729      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
730      * reverting with custom message when dividing by zero.
731      *
732      * CAUTION: This function is deprecated because it requires allocating memory for the error
733      * message unnecessarily. For custom revert reasons use {tryMod}.
734      *
735      * Counterpart to Solidity's `%` operator. This function uses a `revert`
736      * opcode (which leaves remaining gas untouched) while Solidity uses an
737      * invalid opcode to revert (consuming all remaining gas).
738      *
739      * Requirements:
740      *
741      * - The divisor cannot be zero.
742      */
743     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
744         require(b > 0, errorMessage);
745         return a % b;
746     }
747 }
748 
749 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/release-v3.4/contracts/token/ERC20/ERC20Burnable.sol
750 
751 
752 
753 pragma solidity >=0.6.0 <0.8.0;
754 
755 
756 
757 /**
758  * @dev Extension of {ERC20} that allows token holders to destroy both their own
759  * tokens and those that they have an allowance for, in a way that can be
760  * recognized off-chain (via event analysis).
761  */
762 abstract contract ERC20Burnable is Context, ERC20 {
763     using SafeMath for uint256;
764 
765     /**
766      * @dev Destroys `amount` tokens from the caller.
767      *
768      * See {ERC20-_burn}.
769      */
770     function burn(uint256 amount) public virtual {
771         _burn(_msgSender(), amount);
772     }
773 
774     /**
775      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
776      * allowance.
777      *
778      * See {ERC20-_burn} and {ERC20-allowance}.
779      *
780      * Requirements:
781      *
782      * - the caller must have allowance for ``accounts``'s tokens of at least
783      * `amount`.
784      */
785     function burnFrom(address account, uint256 amount) public virtual {
786         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
787 
788         _approve(account, _msgSender(), decreasedAllowance);
789         _burn(account, amount);
790     }
791 }
792 
793 // File: DMOD.sol
794 
795 
796 pragma solidity ^0.7.1; 
797 
798 
799 
800 
801 contract DMOD is ERC20Burnable, ERC20Capped, Ownable{
802   constructor(address dmodMultiSig)
803         public
804         ERC20("Demodyfi Token", "DMOD")
805         ERC20Capped(100000000 * 10**18)
806     {
807         transferOwnership(dmodMultiSig);
808     }
809 
810     function mint(address recipient, uint256 amount) public onlyOwner {
811         _mint(recipient, amount);
812     }
813 
814     function _beforeTokenTransfer(
815         address from,
816         address to,
817         uint256 amount
818     ) internal virtual override(ERC20Capped, ERC20) {
819         ERC20Capped._beforeTokenTransfer(from, to, amount);
820     }
821 }