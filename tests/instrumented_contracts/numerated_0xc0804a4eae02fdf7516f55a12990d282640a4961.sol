1 // SPDX-License-Identifier: MIT
2 
3 /*
4 Website: https://www.openpool.org
5 
6 Twitter: https://twitter.com/OpenPoolOrg
7 */
8 
9 pragma solidity ^0.8.6;
10 
11 library SafeMath {
12     /**
13      * @dev Returns the addition of two unsigned integers, reverting on
14      * overflow.
15      *
16      * Counterpart to Solidity's `+` operator.
17      *
18      * Requirements:
19      *
20      * - Addition cannot overflow.
21      */
22     function add(uint256 a, uint256 b) internal pure returns (uint256) {
23         uint256 c = a + b;
24         require(c >= a, "SafeMath: addition overflow");
25 
26         return c;
27     }
28 
29     /**
30      * @dev Returns the subtraction of two unsigned integers, reverting on
31      * overflow (when the result is negative).
32      *
33      * Counterpart to Solidity's `-` operator.
34      *
35      * Requirements:
36      *
37      * - Subtraction cannot overflow.
38      */
39     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
40         return sub(a, b, "SafeMath: subtraction overflow");
41     }
42 
43     /**
44      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
45      * overflow (when the result is negative).
46      *
47      * Counterpart to Solidity's `-` operator.
48      *
49      * Requirements:
50      *
51      * - Subtraction cannot overflow.
52      */
53     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
54         require(b <= a, errorMessage);
55         uint256 c = a - b;
56 
57         return c;
58     }
59 
60     /**
61      * @dev Returns the multiplication of two unsigned integers, reverting on
62      * overflow.
63      *
64      * Counterpart to Solidity's `*` operator.
65      *
66      * Requirements:
67      *
68      * - Multiplication cannot overflow.
69      */
70     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
71         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
72         // benefit is lost if 'b' is also tested.
73         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
74         if (a == 0) {
75             return 0;
76         }
77 
78         uint256 c = a * b;
79         require(c / a == b, "SafeMath: multiplication overflow");
80 
81         return c;
82     }
83 
84     /**
85      * @dev Returns the integer division of two unsigned integers. Reverts on
86      * division by zero. The result is rounded towards zero.
87      *
88      * Counterpart to Solidity's `/` operator. Note: this function uses a
89      * `revert` opcode (which leaves remaining gas untouched) while Solidity
90      * uses an invalid opcode to revert (consuming all remaining gas).
91      *
92      * Requirements:
93      *
94      * - The divisor cannot be zero.
95      */
96     function div(uint256 a, uint256 b) internal pure returns (uint256) {
97         return div(a, b, "SafeMath: division by zero");
98     }
99 
100     /**
101      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
102      * division by zero. The result is rounded towards zero.
103      *
104      * Counterpart to Solidity's `/` operator. Note: this function uses a
105      * `revert` opcode (which leaves remaining gas untouched) while Solidity
106      * uses an invalid opcode to revert (consuming all remaining gas).
107      *
108      * Requirements:
109      *
110      * - The divisor cannot be zero.
111      */
112     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
113         require(b > 0, errorMessage);
114         uint256 c = a / b;
115         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
116 
117         return c;
118     }
119 
120     /**
121      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
122      * Reverts when dividing by zero.
123      *
124      * Counterpart to Solidity's `%` operator. This function uses a `revert`
125      * opcode (which leaves remaining gas untouched) while Solidity uses an
126      * invalid opcode to revert (consuming all remaining gas).
127      *
128      * Requirements:
129      *
130      * - The divisor cannot be zero.
131      */
132     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
133         return mod(a, b, "SafeMath: modulo by zero");
134     }
135 
136     /**
137      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
138      * Reverts with custom message when dividing by zero.
139      *
140      * Counterpart to Solidity's `%` operator. This function uses a `revert`
141      * opcode (which leaves remaining gas untouched) while Solidity uses an
142      * invalid opcode to revert (consuming all remaining gas).
143      *
144      * Requirements:
145      *
146      * - The divisor cannot be zero.
147      */
148     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
149         require(b != 0, errorMessage);
150         return a % b;
151     }
152 }
153 
154 /**
155  * @title SafeMathInt
156  * @dev Math operations for int256 with overflow safety checks.
157  */
158 library SafeMathInt {
159     int256 private constant MIN_INT256 = int256(1) << 255;
160     int256 private constant MAX_INT256 = ~(int256(1) << 255);
161 
162     /**
163      * @dev Multiplies two int256 variables and fails on overflow.
164      */
165     function mul(int256 a, int256 b) internal pure returns (int256) {
166         int256 c = a * b;
167 
168         // Detect overflow when multiplying MIN_INT256 with -1
169         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
170         require((b == 0) || (c / b == a));
171         return c;
172     }
173 
174     /**
175      * @dev Division of two int256 variables and fails on overflow.
176      */
177     function div(int256 a, int256 b) internal pure returns (int256) {
178         // Prevent overflow when dividing MIN_INT256 by -1
179         require(b != -1 || a != MIN_INT256);
180 
181         // Solidity already throws when dividing by 0.
182         return a / b;
183     }
184 
185     /**
186      * @dev Subtracts two int256 variables and fails on overflow.
187      */
188     function sub(int256 a, int256 b) internal pure returns (int256) {
189         int256 c = a - b;
190         require((b >= 0 && c <= a) || (b < 0 && c > a));
191         return c;
192     }
193 
194     /**
195      * @dev Adds two int256 variables and fails on overflow.
196      */
197     function add(int256 a, int256 b) internal pure returns (int256) {
198         int256 c = a + b;
199         require((b >= 0 && c >= a) || (b < 0 && c < a));
200         return c;
201     }
202 
203     /**
204      * @dev Converts to absolute value, and fails on overflow.
205      */
206     function abs(int256 a) internal pure returns (int256) {
207         require(a != MIN_INT256);
208         return a < 0 ? -a : a;
209     }
210 
211 
212     function toUint256Safe(int256 a) internal pure returns (uint256) {
213         require(a >= 0);
214         return uint256(a);
215     }
216 }
217 
218 /**
219  * @title SafeMathUint
220  * @dev Math operations with safety checks that revert on error
221  */
222 library SafeMathUint {
223   function toInt256Safe(uint256 a) internal pure returns (int256) {
224     int256 b = int256(a);
225     require(b >= 0);
226     return b;
227   }
228 }
229 
230 /**
231  * @dev Provides information about the current execution context, including the
232  * sender of the transaction and its data. While these are generally available
233  * via msg.sender and msg.data, they should not be accessed in such a direct
234  * manner, since when dealing with meta-transactions the account sending and
235  * paying for execution may not be the actual sender (as far as an application
236  * is concerned).
237  *
238  * This contract is only required for intermediate, library-like contracts.
239  */
240 abstract contract Context {
241     function _msgSender() internal view virtual returns (address) {
242         return msg.sender;
243     }
244 
245     function _msgData() internal view virtual returns (bytes calldata) {
246         return msg.data;
247     }
248 }
249 
250 /**
251  * @dev Interface of the ERC20 standard as defined in the EIP.
252  */
253 interface IERC20 {
254     /**
255      * @dev Emitted when `value` tokens are moved from one account (`from`) to
256      * another (`to`).
257      *
258      * Note that `value` may be zero.
259      */
260     event Transfer(address indexed from, address indexed to, uint256 value);
261 
262     /**
263      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
264      * a call to {approve}. `value` is the new allowance.
265      */
266     event Approval(address indexed owner, address indexed spender, uint256 value);
267 
268     /**
269      * @dev Returns the amount of tokens in existence.
270      */
271     function totalSupply() external view returns (uint256);
272 
273     /**
274      * @dev Returns the amount of tokens owned by `account`.
275      */
276     function balanceOf(address account) external view returns (uint256);
277 
278     /**
279      * @dev Moves `amount` tokens from the caller's account to `to`.
280      *
281      * Returns a boolean value indicating whether the operation succeeded.
282      *
283      * Emits a {Transfer} event.
284      */
285     function transfer(address to, uint256 amount) external returns (bool);
286 
287     /**
288      * @dev Returns the remaining number of tokens that `spender` will be
289      * allowed to spend on behalf of `owner` through {transferFrom}. This is
290      * zero by default.
291      *
292      * This value changes when {approve} or {transferFrom} are called.
293      */
294     function allowance(address owner, address spender) external view returns (uint256);
295 
296     /**
297      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
298      *
299      * Returns a boolean value indicating whether the operation succeeded.
300      *
301      * IMPORTANT: Beware that changing an allowance with this method brings the risk
302      * that someone may use both the old and the new allowance by unfortunate
303      * transaction ordering. One possible solution to mitigate this race
304      * condition is to first reduce the spender's allowance to 0 and set the
305      * desired value afterwards:
306      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
307      *
308      * Emits an {Approval} event.
309      */
310     function approve(address spender, uint256 amount) external returns (bool);
311 
312     /**
313      * @dev Moves `amount` tokens from `from` to `to` using the
314      * allowance mechanism. `amount` is then deducted from the caller's
315      * allowance.
316      *
317      * Returns a boolean value indicating whether the operation succeeded.
318      *
319      * Emits a {Transfer} event.
320      */
321     function transferFrom(address from, address to, uint256 amount) external returns (bool);
322 }
323 
324 /**
325  * @dev Contract module which provides a basic access control mechanism, where
326  * there is an account (an owner) that can be granted exclusive access to
327  * specific functions.
328  *
329  * By default, the owner account will be the one that deploys the contract. This
330  * can later be changed with {transferOwnership}.
331  *
332  * This module is used through inheritance. It will make available the modifier
333  * `onlyOwner`, which can be applied to your functions to restrict their use to
334  * the owner.
335  */
336 abstract contract Ownable is Context {
337     address private _owner;
338 
339     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
340 
341     /**
342      * @dev Initializes the contract setting the deployer as the initial owner.
343      */
344     constructor() {
345         _transferOwnership(_msgSender());
346     }
347 
348     /**
349      * @dev Throws if called by any account other than the owner.
350      */
351     modifier onlyOwner() {
352         _checkOwner();
353         _;
354     }
355 
356     /**
357      * @dev Returns the address of the current owner.
358      */
359     function owner() public view virtual returns (address) {
360         return _owner;
361     }
362 
363     /**
364      * @dev Throws if the sender is not the owner.
365      */
366     function _checkOwner() internal view virtual {
367         require(owner() == _msgSender(), "Ownable: caller is not the owner");
368     }
369 
370     /**
371      * @dev Leaves the contract without owner. It will not be possible to call
372      * `onlyOwner` functions. Can only be called by the current owner.
373      *
374      * NOTE: Renouncing ownership will leave the contract without an owner,
375      * thereby disabling any functionality that is only available to the owner.
376      */
377     function renounceOwnership() public virtual onlyOwner {
378         _transferOwnership(address(0));
379     }
380 
381     /**
382      * @dev Transfers ownership of the contract to a new account (`newOwner`).
383      * Can only be called by the current owner.
384      */
385     function transferOwnership(address newOwner) public virtual onlyOwner {
386         require(newOwner != address(0), "Ownable: new owner is the zero address");
387         _transferOwnership(newOwner);
388     }
389 
390     /**
391      * @dev Transfers ownership of the contract to a new account (`newOwner`).
392      * Internal function without access restriction.
393      */
394     function _transferOwnership(address newOwner) internal virtual {
395         address oldOwner = _owner;
396         _owner = newOwner;
397         emit OwnershipTransferred(oldOwner, newOwner);
398     }
399 }
400 
401 /**
402  * @dev Interface for the optional metadata functions from the ERC20 standard.
403  *
404  * _Available since v4.1._
405  */
406 interface IERC20Metadata is IERC20 {
407     /**
408      * @dev Returns the name of the token.
409      */
410     function name() external view returns (string memory);
411 
412     /**
413      * @dev Returns the symbol of the token.
414      */
415     function symbol() external view returns (string memory);
416 
417     /**
418      * @dev Returns the decimals places of the token.
419      */
420     function decimals() external view returns (uint8);
421 }
422 
423 /**
424  * @dev Implementation of the {IERC20} interface.
425  *
426  * This implementation is agnostic to the way tokens are created. This means
427  * that a supply mechanism has to be added in a derived contract using {_mint}.
428  * For a generic mechanism see {ERC20PresetMinterPauser}.
429  *
430  * TIP: For a detailed writeup see our guide
431  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
432  * to implement supply mechanisms].
433  *
434  * The default value of {decimals} is 18. To change this, you should override
435  * this function so it returns a different value.
436  *
437  * We have followed general OpenZeppelin Contracts guidelines: functions revert
438  * instead returning `false` on failure. This behavior is nonetheless
439  * conventional and does not conflict with the expectations of ERC20
440  * applications.
441  *
442  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
443  * This allows applications to reconstruct the allowance for all accounts just
444  * by listening to said events. Other implementations of the EIP may not emit
445  * these events, as it isn't required by the specification.
446  *
447  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
448  * functions have been added to mitigate the well-known issues around setting
449  * allowances. See {IERC20-approve}.
450  */
451 contract ERC20 is Context, IERC20, IERC20Metadata {
452     mapping(address => uint256) private _balances;
453 
454     mapping(address => mapping(address => uint256)) private _allowances;
455 
456     uint256 private _totalSupply;
457 
458     string private _name;
459     string private _symbol;
460 
461     /**
462      * @dev Sets the values for {name} and {symbol}.
463      *
464      * All two of these values are immutable: they can only be set once during
465      * construction.
466      */
467     constructor(string memory name_, string memory symbol_) {
468         _name = name_;
469         _symbol = symbol_;
470     }
471 
472     /**
473      * @dev Returns the name of the token.
474      */
475     function name() public view virtual override returns (string memory) {
476         return _name;
477     }
478 
479     /**
480      * @dev Returns the symbol of the token, usually a shorter version of the
481      * name.
482      */
483     function symbol() public view virtual override returns (string memory) {
484         return _symbol;
485     }
486 
487     /**
488      * @dev Returns the number of decimals used to get its user representation.
489      * For example, if `decimals` equals `2`, a balance of `505` tokens should
490      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
491      *
492      * Tokens usually opt for a value of 18, imitating the relationship between
493      * Ether and Wei. This is the default value returned by this function, unless
494      * it's overridden.
495      *
496      * NOTE: This information is only used for _display_ purposes: it in
497      * no way affects any of the arithmetic of the contract, including
498      * {IERC20-balanceOf} and {IERC20-transfer}.
499      */
500     function decimals() public view virtual override returns (uint8) {
501         return 18;
502     }
503 
504     /**
505      * @dev See {IERC20-totalSupply}.
506      */
507     function totalSupply() public view virtual override returns (uint256) {
508         return _totalSupply;
509     }
510 
511     /**
512      * @dev See {IERC20-balanceOf}.
513      */
514     function balanceOf(address account) public view virtual override returns (uint256) {
515         return _balances[account];
516     }
517 
518     /**
519      * @dev See {IERC20-transfer}.
520      *
521      * Requirements:
522      *
523      * - `to` cannot be the zero address.
524      * - the caller must have a balance of at least `amount`.
525      */
526     function transfer(address to, uint256 amount) public virtual override returns (bool) {
527         address owner = _msgSender();
528         _transfer(owner, to, amount);
529         return true;
530     }
531 
532     /**
533      * @dev See {IERC20-allowance}.
534      */
535     function allowance(address owner, address spender) public view virtual override returns (uint256) {
536         return _allowances[owner][spender];
537     }
538 
539     /**
540      * @dev See {IERC20-approve}.
541      *
542      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
543      * `transferFrom`. This is semantically equivalent to an infinite approval.
544      *
545      * Requirements:
546      *
547      * - `spender` cannot be the zero address.
548      */
549     function approve(address spender, uint256 amount) public virtual override returns (bool) {
550         address owner = _msgSender();
551         _approve(owner, spender, amount);
552         return true;
553     }
554 
555     /**
556      * @dev See {IERC20-transferFrom}.
557      *
558      * Emits an {Approval} event indicating the updated allowance. This is not
559      * required by the EIP. See the note at the beginning of {ERC20}.
560      *
561      * NOTE: Does not update the allowance if the current allowance
562      * is the maximum `uint256`.
563      *
564      * Requirements:
565      *
566      * - `from` and `to` cannot be the zero address.
567      * - `from` must have a balance of at least `amount`.
568      * - the caller must have allowance for ``from``'s tokens of at least
569      * `amount`.
570      */
571     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
572         address spender = _msgSender();
573         _spendAllowance(from, spender, amount);
574         _transfer(from, to, amount);
575         return true;
576     }
577 
578     /**
579      * @dev Atomically increases the allowance granted to `spender` by the caller.
580      *
581      * This is an alternative to {approve} that can be used as a mitigation for
582      * problems described in {IERC20-approve}.
583      *
584      * Emits an {Approval} event indicating the updated allowance.
585      *
586      * Requirements:
587      *
588      * - `spender` cannot be the zero address.
589      */
590     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
591         address owner = _msgSender();
592         _approve(owner, spender, allowance(owner, spender) + addedValue);
593         return true;
594     }
595 
596     /**
597      * @dev Atomically decreases the allowance granted to `spender` by the caller.
598      *
599      * This is an alternative to {approve} that can be used as a mitigation for
600      * problems described in {IERC20-approve}.
601      *
602      * Emits an {Approval} event indicating the updated allowance.
603      *
604      * Requirements:
605      *
606      * - `spender` cannot be the zero address.
607      * - `spender` must have allowance for the caller of at least
608      * `subtractedValue`.
609      */
610     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
611         address owner = _msgSender();
612         uint256 currentAllowance = allowance(owner, spender);
613         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
614         unchecked {
615             _approve(owner, spender, currentAllowance - subtractedValue);
616         }
617 
618         return true;
619     }
620 
621     /**
622      * @dev Moves `amount` of tokens from `from` to `to`.
623      *
624      * This internal function is equivalent to {transfer}, and can be used to
625      * e.g. implement automatic token fees, slashing mechanisms, etc.
626      *
627      * Emits a {Transfer} event.
628      *
629      * Requirements:
630      *
631      * - `from` cannot be the zero address.
632      * - `to` cannot be the zero address.
633      * - `from` must have a balance of at least `amount`.
634      */
635     function _transfer(address from, address to, uint256 amount) internal virtual {
636         require(from != address(0), "ERC20: transfer from the zero address");
637         require(to != address(0), "ERC20: transfer to the zero address");
638 
639         _beforeTokenTransfer(from, to, amount);
640 
641         uint256 fromBalance = _balances[from];
642         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
643         unchecked {
644             _balances[from] = fromBalance - amount;
645             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
646             // decrementing then incrementing.
647             _balances[to] += amount;
648         }
649 
650         emit Transfer(from, to, amount);
651 
652         _afterTokenTransfer(from, to, amount);
653     }
654 
655     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
656      * the total supply.
657      *
658      * Emits a {Transfer} event with `from` set to the zero address.
659      *
660      * Requirements:
661      *
662      * - `account` cannot be the zero address.
663      */
664     function _mint(address account, uint256 amount) internal virtual {
665         require(account != address(0), "ERC20: mint to the zero address");
666 
667         _beforeTokenTransfer(address(0), account, amount);
668 
669         _totalSupply += amount;
670         unchecked {
671             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
672             _balances[account] += amount;
673         }
674         emit Transfer(address(0), account, amount);
675 
676         _afterTokenTransfer(address(0), account, amount);
677     }
678 
679     /**
680      * @dev Destroys `amount` tokens from `account`, reducing the
681      * total supply.
682      *
683      * Emits a {Transfer} event with `to` set to the zero address.
684      *
685      * Requirements:
686      *
687      * - `account` cannot be the zero address.
688      * - `account` must have at least `amount` tokens.
689      */
690     function _burn(address account, uint256 amount) internal virtual {
691         require(account != address(0), "ERC20: burn from the zero address");
692 
693         _beforeTokenTransfer(account, address(0), amount);
694 
695         uint256 accountBalance = _balances[account];
696         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
697         unchecked {
698             _balances[account] = accountBalance - amount;
699             // Overflow not possible: amount <= accountBalance <= totalSupply.
700             _totalSupply -= amount;
701         }
702 
703         emit Transfer(account, address(0), amount);
704 
705         _afterTokenTransfer(account, address(0), amount);
706     }
707 
708     /**
709      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
710      *
711      * This internal function is equivalent to `approve`, and can be used to
712      * e.g. set automatic allowances for certain subsystems, etc.
713      *
714      * Emits an {Approval} event.
715      *
716      * Requirements:
717      *
718      * - `owner` cannot be the zero address.
719      * - `spender` cannot be the zero address.
720      */
721     function _approve(address owner, address spender, uint256 amount) internal virtual {
722         require(owner != address(0), "ERC20: approve from the zero address");
723         require(spender != address(0), "ERC20: approve to the zero address");
724 
725         _allowances[owner][spender] = amount;
726         emit Approval(owner, spender, amount);
727     }
728 
729     /**
730      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
731      *
732      * Does not update the allowance amount in case of infinite allowance.
733      * Revert if not enough allowance is available.
734      *
735      * Might emit an {Approval} event.
736      */
737     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
738         uint256 currentAllowance = allowance(owner, spender);
739         if (currentAllowance != type(uint256).max) {
740             require(currentAllowance >= amount, "ERC20: insufficient allowance");
741             unchecked {
742                 _approve(owner, spender, currentAllowance - amount);
743             }
744         }
745     }
746 
747     /**
748      * @dev Hook that is called before any transfer of tokens. This includes
749      * minting and burning.
750      *
751      * Calling conditions:
752      *
753      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
754      * will be transferred to `to`.
755      * - when `from` is zero, `amount` tokens will be minted for `to`.
756      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
757      * - `from` and `to` are never both zero.
758      *
759      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
760      */
761     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
762 
763     /**
764      * @dev Hook that is called after any transfer of tokens. This includes
765      * minting and burning.
766      *
767      * Calling conditions:
768      *
769      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
770      * has been transferred to `to`.
771      * - when `from` is zero, `amount` tokens have been minted for `to`.
772      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
773      * - `from` and `to` are never both zero.
774      *
775      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
776      */
777     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
778 }
779 
780 interface DividendPayingTokenInterface {
781   /// @notice View the amount of dividend in wei that an address can withdraw.
782   /// @param _owner The address of a token holder.
783   /// @return The amount of dividend in wei that `_owner` can withdraw.
784   function dividendOf(address _owner) external view returns(uint256);
785 
786   /// @notice Withdraws the ether distributed to the sender.
787   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
788   ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
789   function withdrawDividend() external;
790   
791   /// @notice View the amount of dividend in wei that an address can withdraw.
792   /// @param _owner The address of a token holder.
793   /// @return The amount of dividend in wei that `_owner` can withdraw.
794   function withdrawableDividendOf(address _owner) external view returns(uint256);
795 
796   /// @notice View the amount of dividend in wei that an address has withdrawn.
797   /// @param _owner The address of a token holder.
798   /// @return The amount of dividend in wei that `_owner` has withdrawn.
799   function withdrawnDividendOf(address _owner) external view returns(uint256);
800 
801   /// @notice View the amount of dividend in wei that an address has earned in total.
802   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
803   /// @param _owner The address of a token holder.
804   /// @return The amount of dividend in wei that `_owner` has earned in total.
805   function accumulativeDividendOf(address _owner) external view returns(uint256);
806 
807 
808   /// @dev This event MUST emit when ether is distributed to token holders.
809   /// @param from The address which sends ether to this contract.
810   /// @param weiAmount The amount of distributed ether in wei.
811   event DividendsDistributed(
812     address indexed from,
813     uint256 weiAmount
814   );
815 
816   /// @dev This event MUST emit when an address withdraws their dividend.
817   /// @param to The address which withdraws ether from this contract.
818   /// @param weiAmount The amount of withdrawn ether in wei.
819   event DividendWithdrawn(
820     address indexed to,
821     uint256 weiAmount
822   );
823   
824 }
825 
826 interface IPair {
827     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
828     function token0() external view returns (address);
829 
830 }
831 
832 interface IFactory{
833         function createPair(address tokenA, address tokenB) external returns (address pair);
834         function getPair(address tokenA, address tokenB) external view returns (address pair);
835 }
836 
837 interface IUniswapRouter {
838     function factory() external pure returns (address);
839     function WETH() external pure returns (address);
840     function addLiquidityETH(
841         address token,
842         uint amountTokenDesired,
843         uint amountTokenMin,
844         uint amountETHMin,
845         address to,
846         uint deadline
847     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
848     
849     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
850         uint amountIn,
851         uint amountOutMin,
852         address[] calldata path,
853         address to,
854         uint deadline
855     ) external;
856     
857     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
858         external
859         payable
860         returns (uint[] memory amounts);
861     
862     function swapExactTokensForETHSupportingFeeOnTransferTokens(
863         uint amountIn,
864         uint amountOutMin,
865         address[] calldata path,
866         address to,
867         uint deadline) external;
868 }
869 
870 contract DividendPayingToken is ERC20, DividendPayingTokenInterface, Ownable {
871 
872   using SafeMath for uint256;
873   using SafeMathUint for uint256;
874   using SafeMathInt for int256;
875 
876   address public LP_Token;
877 
878 
879   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
880   // For more discussion about choosing the value of `magnitude`,
881   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
882   uint256 constant internal magnitude = 2**128;
883 
884   uint256 internal magnifiedDividendPerShare;
885 
886   // About dividendCorrection:
887   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
888   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
889   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
890   //   `dividendOf(_user)` should not be changed,
891   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
892   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
893   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
894   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
895   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
896   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
897   mapping(address => int256) internal magnifiedDividendCorrections;
898   mapping(address => uint256) internal withdrawnDividends;
899 
900   uint256 public totalDividendsDistributed;
901   uint256 public totalDividendsWithdrawn;
902 
903   constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {}
904 
905   function distributeLPDividends(uint256 amount) public onlyOwner{
906     require(totalSupply() > 0);
907 
908     if (amount > 0) {
909       magnifiedDividendPerShare = magnifiedDividendPerShare.add(
910         (amount).mul(magnitude) / totalSupply()
911       );
912       emit DividendsDistributed(msg.sender, amount);
913 
914       totalDividendsDistributed = totalDividendsDistributed.add(amount);
915     }
916   }
917 
918   /// @notice Withdraws the ether distributed to the sender.
919   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
920   function withdrawDividend() public virtual override {
921     _withdrawDividendOfUser(payable(msg.sender));
922   }
923 
924   /// @notice Withdraws the ether distributed to the sender.
925   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
926  function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
927     uint256 _withdrawableDividend = withdrawableDividendOf(user);
928     if (_withdrawableDividend > 0) {
929       withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
930       totalDividendsWithdrawn += _withdrawableDividend;
931       emit DividendWithdrawn(user, _withdrawableDividend);
932       bool success = IERC20(LP_Token).transfer(user, _withdrawableDividend);
933 
934       if(!success) {
935         withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
936         totalDividendsWithdrawn -= _withdrawableDividend;
937         return 0;
938       }
939 
940       return _withdrawableDividend;
941     }
942 
943     return 0;
944   }
945 
946   /// @notice View the amount of dividend in wei that an address can withdraw.
947   /// @param _owner The address of a token holder.
948   /// @return The amount of dividend in wei that `_owner` can withdraw.
949   function dividendOf(address _owner) public view override returns(uint256) {
950     return withdrawableDividendOf(_owner);
951   }
952 
953   /// @notice View the amount of dividend in wei that an address can withdraw.
954   /// @param _owner The address of a token holder.
955   /// @return The amount of dividend in wei that `_owner` can withdraw.
956   function withdrawableDividendOf(address _owner) public view override returns(uint256) {
957     return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
958   }
959 
960   /// @notice View the amount of dividend in wei that an address has withdrawn.
961   /// @param _owner The address of a token holder.
962   /// @return The amount of dividend in wei that `_owner` has withdrawn.
963   function withdrawnDividendOf(address _owner) public view override returns(uint256) {
964     return withdrawnDividends[_owner];
965   }
966 
967 
968   /// @notice View the amount of dividend in wei that an address has earned in total.
969   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
970   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
971   /// @param _owner The address of a token holder.
972   /// @return The amount of dividend in wei that `_owner` has earned in total.
973   function accumulativeDividendOf(address _owner) public view override returns(uint256) {
974     return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
975       .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
976   }
977 
978   /// @dev Internal function that transfer tokens from one address to another.
979   /// Update magnifiedDividendCorrections to keep dividends unchanged.
980   /// @param from The address to transfer from.
981   /// @param to The address to transfer to.
982   /// @param value The amount to be transferred.
983   function _transfer(address from, address to, uint256 value) internal virtual override {
984     require(false);
985 
986     int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
987     magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
988     magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
989   }
990 
991   /// @dev Internal function that mints tokens to an account.
992   /// Update magnifiedDividendCorrections to keep dividends unchanged.
993   /// @param account The account that will receive the created tokens.
994   /// @param value The amount that will be created.
995   function _mint(address account, uint256 value) internal override {
996     super._mint(account, value);
997 
998     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
999       .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
1000   }
1001 
1002   /// @dev Internal function that burns an amount of the token of a given account.
1003   /// Update magnifiedDividendCorrections to keep dividends unchanged.
1004   /// @param account The account whose tokens will be burnt.
1005   /// @param value The amount that will be burnt.
1006   function _burn(address account, uint256 value) internal override {
1007     super._burn(account, value);
1008 
1009     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1010       .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
1011   }
1012 
1013   function _setBalance(address account, uint256 newBalance) internal {
1014     uint256 currentBalance = balanceOf(account);
1015 
1016     if(newBalance > currentBalance) {
1017       uint256 mintAmount = newBalance.sub(currentBalance);
1018       _mint(account, mintAmount);
1019     } else if(newBalance < currentBalance) {
1020       uint256 burnAmount = currentBalance.sub(newBalance);
1021       _burn(account, burnAmount);
1022     }
1023   }
1024 }
1025 
1026 contract OpenPool is ERC20, Ownable {
1027     IUniswapRouter public router;
1028     address public pair;
1029 
1030     bool private swapping;
1031     bool public swapEnabled = true;
1032     bool public claimEnabled;
1033     bool public tradingEnabled;
1034 
1035     OpenPoolDividendTracker public dividendTracker;
1036 
1037     address public devWallet;
1038 
1039     uint256 public swapTokensAtAmount;
1040     uint256 public maxBuyAmount;
1041     uint256 public maxSellAmount;
1042     uint256 public maxWallet;
1043 
1044     struct Taxes {
1045         uint256 liquidity;
1046         uint256 dev;
1047     }
1048 
1049     Taxes public buyTaxes = Taxes(10, 10);
1050     Taxes public sellTaxes = Taxes(10, 10);
1051 
1052     uint256 public totalBuyTax = 20;
1053     uint256 public totalSellTax = 20;
1054 
1055     mapping(address => bool) public _isBot;
1056 
1057     mapping(address => bool) private _isExcludedFromFees;
1058     mapping(address => bool) public automatedMarketMakerPairs;
1059     mapping(address => bool) private _isExcludedFromMaxWallet;
1060 
1061     ///////////////
1062     //   Events  //
1063     ///////////////
1064 
1065     event ExcludeFromFees(address indexed account, bool isExcluded);
1066     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1067     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1068     event GasForProcessingUpdated(
1069         uint256 indexed newValue,
1070         uint256 indexed oldValue
1071     );
1072     event SendDividends(uint256 tokensSwapped, uint256 amount);
1073     event ProcessedDividendTracker(
1074         uint256 iterations,
1075         uint256 claims,
1076         uint256 lastProcessedIndex,
1077         bool indexed automatic,
1078         uint256 gas,
1079         address indexed processor
1080     );
1081 
1082     constructor(address _developerwallet) ERC20("OpenPool", "OPL") {
1083         dividendTracker = new OpenPoolDividendTracker();
1084         setDevWallet(_developerwallet);
1085 
1086         IUniswapRouter _router = IUniswapRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1087         address _pair = IFactory(_router.factory()).createPair(
1088             address(this),
1089             _router.WETH()
1090         );
1091 
1092         router = _router;
1093         pair = _pair;
1094         setSwapTokensAtAmount(200000); 
1095         updateMaxWalletAmount(1000000);
1096         setMaxBuyAndSell(500000, 500000);
1097 
1098         _setAutomatedMarketMakerPair(_pair, true);
1099 
1100         dividendTracker.updateLP_Token(pair);
1101 
1102         dividendTracker.excludeFromDividends(address(dividendTracker), true);
1103         dividendTracker.excludeFromDividends(address(this), true);
1104         dividendTracker.excludeFromDividends(owner(), true);
1105         dividendTracker.excludeFromDividends(address(0xdead), true);
1106         dividendTracker.excludeFromDividends(address(_router), true);
1107 
1108         excludeFromMaxWallet(address(_pair), true);
1109         excludeFromMaxWallet(address(this), true);
1110         excludeFromMaxWallet(address(_router), true);
1111 
1112         excludeFromFees(owner(), true);
1113         excludeFromFees(address(this), true);
1114 
1115         _mint(owner(), 100000000 * (10**18));
1116     }
1117 
1118     receive() external payable {}
1119 
1120     function updateDividendTracker(address newAddress) public onlyOwner {
1121         OpenPoolDividendTracker newDividendTracker = OpenPoolDividendTracker(
1122             payable(newAddress)
1123         );
1124         newDividendTracker.excludeFromDividends(
1125             address(newDividendTracker),
1126             true
1127         );
1128         newDividendTracker.excludeFromDividends(address(this), true);
1129         newDividendTracker.excludeFromDividends(owner(), true);
1130         newDividendTracker.excludeFromDividends(address(router), true);
1131         dividendTracker = newDividendTracker;
1132     }
1133 
1134     /// @notice Manual claim the dividends
1135     function claim() external {
1136         require(claimEnabled, "Claim not enabled");
1137         dividendTracker.processAccount(payable(msg.sender));
1138     }
1139 
1140     function updateMaxWalletAmount(uint256 newNum) public onlyOwner {
1141         require(newNum >= 1000000, "Cannot set maxWallet lower than 1%");
1142         maxWallet = newNum * 10**18;
1143     }
1144 
1145     function setMaxBuyAndSell(uint256 maxBuy, uint256 maxSell)
1146         public
1147         onlyOwner
1148     {
1149         require(maxBuy >= 500000, "Cannot set maxbuy lower than 0.5% ");
1150         require(maxSell >= 500000, "Cannot set maxsell lower than 0.5% ");
1151         maxBuyAmount = maxBuy * 10**18;
1152         maxSellAmount = maxSell * 10**18;
1153     }
1154 
1155     function setSwapTokensAtAmount(uint256 amount) public onlyOwner {
1156         swapTokensAtAmount = amount * 10**18;
1157     }
1158 
1159     function excludeFromMaxWallet(address account, bool excluded)
1160         public
1161         onlyOwner
1162     {
1163         _isExcludedFromMaxWallet[account] = excluded;
1164     }
1165 
1166     /// @notice Withdraw tokens sent by mistake.
1167     /// @param tokenAddress The address of the token to withdraw
1168     function rescueETH20Tokens(address tokenAddress) external onlyOwner {
1169         IERC20(tokenAddress).transfer(
1170             owner(),
1171             IERC20(tokenAddress).balanceOf(address(this))
1172         );
1173     }
1174 
1175     /// @notice Send remaining ETH to dev
1176     /// @dev It will send all ETH to dev
1177     function forceSend() external onlyOwner {
1178         uint256 ETHbalance = address(this).balance;
1179         (bool success, ) = payable(devWallet).call{value: ETHbalance}("");
1180         require(success);
1181     }
1182 
1183     function trackerRescueETH20Tokens(address tokenAddress) external onlyOwner {
1184         dividendTracker.trackerRescueETH20Tokens(msg.sender, tokenAddress);
1185     }
1186 
1187     function updateRouter(address newRouter) external onlyOwner {
1188         router = IUniswapRouter(newRouter);
1189     }
1190 
1191     /////////////////////////////////
1192     // Exclude / Include functions //
1193     /////////////////////////////////
1194 
1195     function excludeFromFees(address account, bool excluded) public onlyOwner {
1196         require(
1197             _isExcludedFromFees[account] != excluded,
1198             "Account is already the value of 'excluded'"
1199         );
1200         _isExcludedFromFees[account] = excluded;
1201 
1202         emit ExcludeFromFees(account, excluded);
1203     }
1204 
1205     /// @dev "true" to exlcude, "false" to include
1206     function excludeFromDividends(address account, bool value)
1207         public
1208         onlyOwner
1209     {
1210         dividendTracker.excludeFromDividends(account, value);
1211     }
1212 
1213     function setDevWallet(address newWallet) public onlyOwner {
1214         devWallet = newWallet;
1215     }
1216 
1217     function setBuyTaxes(uint256 _liquidity, uint256 _dev) external onlyOwner {
1218         require(_liquidity + _dev <= 20, "Fee must be <= 20%");
1219         buyTaxes = Taxes(_liquidity, _dev);
1220         totalBuyTax = _liquidity + _dev;
1221     }
1222 
1223     function setSellTaxes(uint256 _liquidity, uint256 _dev) external onlyOwner {
1224         require(_liquidity + _dev <= 20, "Fee must be <= 20%");
1225         sellTaxes = Taxes(_liquidity, _dev);
1226         totalSellTax = _liquidity + _dev;
1227     }
1228 
1229     /// @notice Enable or disable internal swaps
1230     /// @dev Set "true" to enable internal swaps for liquidity, treasury and dividends
1231     function setSwapEnabled(bool _enabled) external onlyOwner {
1232         swapEnabled = _enabled;
1233     }
1234 
1235     function activateTrading() external onlyOwner {
1236         require(!tradingEnabled, "Trading already enabled");
1237         tradingEnabled = true;
1238     }
1239 
1240     function setClaimEnabled(bool state) external onlyOwner {
1241         claimEnabled = state;
1242     }
1243 
1244     /// @param bot The bot address
1245     /// @param value "true" to blacklist, "false" to unblacklist
1246     function setBot(address bot, bool value) external onlyOwner {
1247         require(_isBot[bot] != value);
1248         _isBot[bot] = value;
1249     }
1250 
1251     function setLP_Token(address _lpToken) external onlyOwner {
1252         dividendTracker.updateLP_Token(_lpToken);
1253     }
1254 
1255     /// @dev Set new pairs created due to listing in new DEX
1256     function setAutomatedMarketMakerPair(address newPair, bool value)
1257         external
1258         onlyOwner
1259     {
1260         _setAutomatedMarketMakerPair(newPair, value);
1261     }
1262 
1263     function _setAutomatedMarketMakerPair(address newPair, bool value) private {
1264         require(
1265             automatedMarketMakerPairs[newPair] != value,
1266             "Automated market maker pair is already set to that value"
1267         );
1268         automatedMarketMakerPairs[newPair] = value;
1269 
1270         if (value) {
1271             dividendTracker.excludeFromDividends(newPair, true);
1272         }
1273 
1274         emit SetAutomatedMarketMakerPair(newPair, value);
1275     }
1276 
1277     //////////////////////
1278     // Getter Functions //
1279     //////////////////////
1280 
1281     function getTotalDividendsDistributed() external view returns (uint256) {
1282         return dividendTracker.totalDividendsDistributed();
1283     }
1284 
1285     function isExcludedFromFees(address account) public view returns (bool) {
1286         return _isExcludedFromFees[account];
1287     }
1288 
1289     function withdrawableDividendOf(address account)
1290         public
1291         view
1292         returns (uint256)
1293     {
1294         return dividendTracker.withdrawableDividendOf(account);
1295     }
1296 
1297     function dividendTokenBalanceOf(address account)
1298         public
1299         view
1300         returns (uint256)
1301     {
1302         return dividendTracker.balanceOf(account);
1303     }
1304 
1305     function getAccountInfo(address account)
1306         external
1307         view
1308         returns (
1309             address,
1310             uint256,
1311             uint256,
1312             uint256,
1313             uint256
1314         )
1315     {
1316         return dividendTracker.getAccount(account);
1317     }
1318 
1319     ////////////////////////
1320     // Transfer Functions //
1321     ////////////////////////
1322 
1323     function _transfer(
1324         address from,
1325         address to,
1326         uint256 amount
1327     ) internal override {
1328         require(from != address(0), "ERC20: transfer from the zero address");
1329         require(to != address(0), "ERC20: transfer to the zero address");
1330 
1331         if (
1332             !_isExcludedFromFees[from] && !_isExcludedFromFees[to] && !swapping
1333         ) {
1334             require(tradingEnabled, "Trading not active");
1335             if (automatedMarketMakerPairs[to]) {
1336                 require(
1337                     amount <= maxSellAmount,
1338                     "You are exceeding maxSellAmount"
1339                 );
1340             } else if (automatedMarketMakerPairs[from])
1341                 require(
1342                     amount <= maxBuyAmount,
1343                     "You are exceeding maxBuyAmount"
1344                 );
1345             if (!_isExcludedFromMaxWallet[to]) {
1346                 require(
1347                     amount + balanceOf(to) <= maxWallet,
1348                     "Unable to exceed Max Wallet"
1349                 );
1350             }
1351         }
1352 
1353         if (amount == 0) {
1354             super._transfer(from, to, 0);
1355             return;
1356         }
1357 
1358         uint256 contractTokenBalance = balanceOf(address(this));
1359         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1360 
1361         if (
1362             canSwap &&
1363             !swapping &&
1364             swapEnabled &&
1365             automatedMarketMakerPairs[to] &&
1366             !_isExcludedFromFees[from] &&
1367             !_isExcludedFromFees[to]
1368         ) {
1369             swapping = true;
1370 
1371             if (totalSellTax > 0) {
1372                 swapAndLiquify(swapTokensAtAmount);
1373             }
1374 
1375             swapping = false;
1376         }
1377 
1378         bool takeFee = !swapping;
1379 
1380         // if any account belongs to _isExcludedFromFee account then remove the fee
1381         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1382             takeFee = false;
1383         }
1384 
1385         if (!automatedMarketMakerPairs[to] && !automatedMarketMakerPairs[from])
1386             takeFee = false;
1387 
1388         if (takeFee) {
1389             uint256 feeAmt;
1390             if (automatedMarketMakerPairs[to])
1391                 feeAmt = (amount * totalSellTax) / 100;
1392             else if (automatedMarketMakerPairs[from])
1393                 feeAmt = (amount * totalBuyTax) / 100;
1394 
1395             amount = amount - feeAmt;
1396             super._transfer(from, address(this), feeAmt);
1397         }
1398         super._transfer(from, to, amount);
1399 
1400         try dividendTracker.setBalance(from, balanceOf(from)) {} catch {}
1401         try dividendTracker.setBalance(to, balanceOf(to)) {} catch {}
1402     }
1403 
1404     function swapAndLiquify(uint256 tokens) private {
1405         uint256 toSwapForLiq = ((tokens * sellTaxes.liquidity) / totalSellTax) / 2;
1406         uint256 tokensToAddLiquidityWith = ((tokens * sellTaxes.liquidity) / totalSellTax) / 2;
1407         uint256 toSwapForDev = (tokens * sellTaxes.dev) / totalSellTax;
1408 
1409         swapTokensForETH(toSwapForLiq);
1410 
1411         uint256 currentbalance = address(this).balance;
1412 
1413         if (currentbalance > 0) {
1414             // Add liquidity to uni
1415             addLiquidity(tokensToAddLiquidityWith, currentbalance);
1416         }
1417 
1418         swapTokensForETH(toSwapForDev);
1419 
1420         uint256 EthTaxBalance = address(this).balance;
1421 
1422         // Send ETH to dev
1423         uint256 devAmt = EthTaxBalance;
1424 
1425         if (devAmt > 0) {
1426             (bool success, ) = payable(devWallet).call{value: devAmt}("");
1427             require(success, "Failed to send ETH to dev wallet");
1428         }
1429 
1430         uint256 lpBalance = IERC20(pair).balanceOf(address(this));
1431 
1432         //Send LP to dividends
1433         uint256 dividends = lpBalance;
1434 
1435         if (dividends > 0) {
1436             bool success = IERC20(pair).transfer(
1437                 address(dividendTracker),
1438                 dividends
1439             );
1440             if (success) {
1441                 dividendTracker.distributeLPDividends(dividends);
1442                 emit SendDividends(tokens, dividends);
1443             }
1444         }
1445     }
1446 
1447     // transfers LP from the owners wallet to holders // must approve this contract, on pair contract before calling
1448     function ManualLiquidityDistribution(uint256 amount) public onlyOwner {
1449         bool success = IERC20(pair).transferFrom(
1450             msg.sender,
1451             address(dividendTracker),
1452             amount
1453         );
1454         if (success) {
1455             dividendTracker.distributeLPDividends(amount);
1456         }
1457     }
1458 
1459     function swapTokensForETH(uint256 tokenAmount) private {
1460         address[] memory path = new address[](2);
1461         path[0] = address(this);
1462         path[1] = router.WETH();
1463 
1464         _approve(address(this), address(router), tokenAmount);
1465 
1466         // make the swap
1467         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1468             tokenAmount,
1469             0, // accept any amount of ETH
1470             path,
1471             address(this),
1472             block.timestamp
1473         );
1474     }
1475 
1476     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1477         // approve token transfer to cover all possible scenarios
1478         _approve(address(this), address(router), tokenAmount);
1479 
1480         // add the liquidity
1481         router.addLiquidityETH{value: ethAmount}(
1482             address(this),
1483             tokenAmount,
1484             0, // slippage is unavoidable
1485             0, // slippage is unavoidable
1486             address(this),
1487             block.timestamp
1488         );
1489     }
1490 }
1491 
1492 contract OpenPoolDividendTracker is Ownable, DividendPayingToken {
1493     struct AccountInfo {
1494         address account;
1495         uint256 withdrawableDividends;
1496         uint256 totalDividends;
1497         uint256 lastClaimTime;
1498     }
1499 
1500     mapping(address => bool) public excludedFromDividends;
1501 
1502     mapping(address => uint256) public lastClaimTimes;
1503 
1504     event ExcludeFromDividends(address indexed account, bool value);
1505     event Claim(address indexed account, uint256 amount);
1506 
1507     constructor()
1508         DividendPayingToken("OpenPool_Dividend_Tracker", "OpenPool_Dividend_Tracker")
1509     {}
1510 
1511     function trackerRescueETH20Tokens(address recipient, address tokenAddress)
1512         external
1513         onlyOwner
1514     {
1515         IERC20(tokenAddress).transfer(
1516             recipient,
1517             IERC20(tokenAddress).balanceOf(address(this))
1518         );
1519     }
1520 
1521     function updateLP_Token(address _lpToken) external onlyOwner {
1522         LP_Token = _lpToken;
1523     }
1524 
1525     function _transfer(
1526         address,
1527         address,
1528         uint256
1529     ) internal pure override {
1530         require(false, "OpenPool_Dividend_Tracker: No transfers allowed");
1531     }
1532 
1533     function excludeFromDividends(address account, bool value)
1534         external
1535         onlyOwner
1536     {
1537         require(excludedFromDividends[account] != value);
1538         excludedFromDividends[account] = value;
1539         if (value == true) {
1540             _setBalance(account, 0);
1541         } else {
1542             _setBalance(account, balanceOf(account));
1543         }
1544         emit ExcludeFromDividends(account, value);
1545     }
1546 
1547     function getAccount(address account)
1548         public
1549         view
1550         returns (
1551             address,
1552             uint256,
1553             uint256,
1554             uint256,
1555             uint256
1556         )
1557     {
1558         AccountInfo memory info;
1559         info.account = account;
1560         info.withdrawableDividends = withdrawableDividendOf(account);
1561         info.totalDividends = accumulativeDividendOf(account);
1562         info.lastClaimTime = lastClaimTimes[account];
1563         return (
1564             info.account,
1565             info.withdrawableDividends,
1566             info.totalDividends,
1567             info.lastClaimTime,
1568             totalDividendsWithdrawn
1569         );
1570     }
1571 
1572     function setBalance(address account, uint256 newBalance)
1573         external
1574         onlyOwner
1575     {
1576         if (excludedFromDividends[account]) {
1577             return;
1578         }
1579         _setBalance(account, newBalance);
1580     }
1581 
1582     function processAccount(address payable account)
1583         external
1584         onlyOwner
1585         returns (bool)
1586     {
1587         uint256 amount = _withdrawDividendOfUser(account);
1588 
1589         if (amount > 0) {
1590             lastClaimTimes[account] = block.timestamp;
1591             emit Claim(account, amount);
1592             return true;
1593         }
1594         return false;
1595     }
1596 }