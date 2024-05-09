1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         return msg.data;
21     }
22 }
23 
24 /**
25  * @dev Interface of the ERC20 standard as defined in the EIP.
26  */
27 interface IERC20 {
28     /**
29      * @dev Emitted when `value` tokens are moved from one account (`from`) to
30      * another (`to`).
31      *
32      * Note that `value` may be zero.
33      */
34     event Transfer(address indexed from, address indexed to, uint256 value);
35 
36     /**
37      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
38      * a call to {approve}. `value` is the new allowance.
39      */
40     event Approval(address indexed owner, address indexed spender, uint256 value);
41 
42     /**
43      * @dev Returns the amount of tokens in existence.
44      */
45     function totalSupply() external view returns (uint256);
46 
47     /**
48      * @dev Returns the amount of tokens owned by `account`.
49      */
50     function balanceOf(address account) external view returns (uint256);
51 
52     /**
53      * @dev Moves `amount` tokens from the caller's account to `to`.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transfer(address to, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Returns the remaining number of tokens that `spender` will be
63      * allowed to spend on behalf of `owner` through {transferFrom}. This is
64      * zero by default.
65      *
66      * This value changes when {approve} or {transferFrom} are called.
67      */
68     function allowance(address owner, address spender) external view returns (uint256);
69 
70     /**
71      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * IMPORTANT: Beware that changing an allowance with this method brings the risk
76      * that someone may use both the old and the new allowance by unfortunate
77      * transaction ordering. One possible solution to mitigate this race
78      * condition is to first reduce the spender's allowance to 0 and set the
79      * desired value afterwards:
80      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
81      *
82      * Emits an {Approval} event.
83      */
84     function approve(address spender, uint256 amount) external returns (bool);
85 
86     /**
87      * @dev Moves `amount` tokens from `from` to `to` using the
88      * allowance mechanism. `amount` is then deducted from the caller's
89      * allowance.
90      *
91      * Returns a boolean value indicating whether the operation succeeded.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transferFrom(address from, address to, uint256 amount) external returns (bool);
96 }
97 
98 
99 /**
100  * @dev Contract module which provides a basic access control mechanism, where
101  * there is an account (an owner) that can be granted exclusive access to
102  * specific functions.
103  *
104  * By default, the owner account will be the one that deploys the contract. This
105  * can later be changed with {transferOwnership}.
106  *
107  * This module is used through inheritance. It will make available the modifier
108  * `onlyOwner`, which can be applied to your functions to restrict their use to
109  * the owner.
110  */
111 abstract contract Ownable is Context {
112     address private _owner;
113 
114     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
115 
116     /**
117      * @dev Initializes the contract setting the deployer as the initial owner.
118      */
119     constructor() {
120         _transferOwnership(_msgSender());
121     }
122 
123     /**
124      * @dev Throws if called by any account other than the owner.
125      */
126     modifier onlyOwner() {
127         _checkOwner();
128         _;
129     }
130 
131     /**
132      * @dev Returns the address of the current owner.
133      */
134     function owner() public view virtual returns (address) {
135         return _owner;
136     }
137 
138     /**
139      * @dev Throws if the sender is not the owner.
140      */
141     function _checkOwner() internal view virtual {
142         require(owner() == _msgSender(), "Ownable: caller is not the owner");
143     }
144 
145     /**
146      * @dev Leaves the contract without owner. It will not be possible to call
147      * `onlyOwner` functions. Can only be called by the current owner.
148      *
149      * NOTE: Renouncing ownership will leave the contract without an owner,
150      * thereby disabling any functionality that is only available to the owner.
151      */
152     function renounceOwnership() public virtual onlyOwner {
153         _transferOwnership(address(0));
154     }
155 
156     /**
157      * @dev Transfers ownership of the contract to a new account (`newOwner`).
158      * Can only be called by the current owner.
159      */
160     function transferOwnership(address newOwner) public virtual onlyOwner {
161         require(newOwner != address(0), "Ownable: new owner is the zero address");
162         _transferOwnership(newOwner);
163     }
164 
165     /**
166      * @dev Transfers ownership of the contract to a new account (`newOwner`).
167      * Internal function without access restriction.
168      */
169     function _transferOwnership(address newOwner) internal virtual {
170         address oldOwner = _owner;
171         _owner = newOwner;
172         emit OwnershipTransferred(oldOwner, newOwner);
173     }
174 }
175 /**
176  * @dev Interface for the optional metadata functions from the ERC20 standard.
177  *
178  * _Available since v4.1._
179  */
180 interface IERC20Metadata is IERC20 {
181     /**
182      * @dev Returns the name of the token.
183      */
184     function name() external view returns (string memory);
185 
186     /**
187      * @dev Returns the symbol of the token.
188      */
189     function symbol() external view returns (string memory);
190 
191     /**
192      * @dev Returns the decimals places of the token.
193      */
194     function decimals() external view returns (uint8);
195 }
196 
197 /**
198  * @dev Implementation of the {IERC20} interface.
199  *
200  * This implementation is agnostic to the way tokens are created. This means
201  * that a supply mechanism has to be added in a derived contract using {_mint}.
202  * For a generic mechanism see {ERC20PresetMinterPauser}.
203  *
204  * TIP: For a detailed writeup see our guide
205  * https://forum.openzeppelin.com/t/how-to-implement-erc20-supply-mechanisms/226[How
206  * to implement supply mechanisms].
207  *
208  * The default value of {decimals} is 18. To change this, you should override
209  * this function so it returns a different value.
210  *
211  * We have followed general OpenZeppelin Contracts guidelines: functions revert
212  * instead returning `false` on failure. This behavior is nonetheless
213  * conventional and does not conflict with the expectations of ERC20
214  * applications.
215  *
216  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
217  * This allows applications to reconstruct the allowance for all accounts just
218  * by listening to said events. Other implementations of the EIP may not emit
219  * these events, as it isn't required by the specification.
220  *
221  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
222  * functions have been added to mitigate the well-known issues around setting
223  * allowances. See {IERC20-approve}.
224  */
225 contract ERC20 is Context, IERC20, IERC20Metadata {
226     mapping(address => uint256) private _balances;
227 
228     mapping(address => mapping(address => uint256)) private _allowances;
229 
230     uint256 private _totalSupply;
231 
232     string private _name;
233     string private _symbol;
234 
235     /**
236      * @dev Sets the values for {name} and {symbol}.
237      *
238      * All two of these values are immutable: they can only be set once during
239      * construction.
240      */
241     constructor(string memory name_, string memory symbol_) {
242         _name = name_;
243         _symbol = symbol_;
244     }
245 
246     /**
247      * @dev Returns the name of the token.
248      */
249     function name() public view virtual override returns (string memory) {
250         return _name;
251     }
252 
253     /**
254      * @dev Returns the symbol of the token, usually a shorter version of the
255      * name.
256      */
257     function symbol() public view virtual override returns (string memory) {
258         return _symbol;
259     }
260 
261     /**
262      * @dev Returns the number of decimals used to get its user representation.
263      * For example, if `decimals` equals `2`, a balance of `505` tokens should
264      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
265      *
266      * Tokens usually opt for a value of 18, imitating the relationship between
267      * Ether and Wei. This is the default value returned by this function, unless
268      * it's overridden.
269      *
270      * NOTE: This information is only used for _display_ purposes: it in
271      * no way affects any of the arithmetic of the contract, including
272      * {IERC20-balanceOf} and {IERC20-transfer}.
273      */
274     function decimals() public view virtual override returns (uint8) {
275         return 18;
276     }
277 
278     /**
279      * @dev See {IERC20-totalSupply}.
280      */
281     function totalSupply() public view virtual override returns (uint256) {
282         return _totalSupply;
283     }
284 
285     /**
286      * @dev See {IERC20-balanceOf}.
287      */
288     function balanceOf(address account) public view virtual override returns (uint256) {
289         return _balances[account];
290     }
291 
292     /**
293      * @dev See {IERC20-transfer}.
294      *
295      * Requirements:
296      *
297      * - `to` cannot be the zero address.
298      * - the caller must have a balance of at least `amount`.
299      */
300     function transfer(address to, uint256 amount) public virtual override returns (bool) {
301         address owner = _msgSender();
302         _transfer(owner, to, amount);
303         return true;
304     }
305 
306     /**
307      * @dev See {IERC20-allowance}.
308      */
309     function allowance(address owner, address spender) public view virtual override returns (uint256) {
310         return _allowances[owner][spender];
311     }
312 
313     /**
314      * @dev See {IERC20-approve}.
315      *
316      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
317      * `transferFrom`. This is semantically equivalent to an infinite approval.
318      *
319      * Requirements:
320      *
321      * - `spender` cannot be the zero address.
322      */
323     function approve(address spender, uint256 amount) public virtual override returns (bool) {
324         address owner = _msgSender();
325         _approve(owner, spender, amount);
326         return true;
327     }
328 
329     /**
330      * @dev See {IERC20-transferFrom}.
331      *
332      * Emits an {Approval} event indicating the updated allowance. This is not
333      * required by the EIP. See the note at the beginning of {ERC20}.
334      *
335      * NOTE: Does not update the allowance if the current allowance
336      * is the maximum `uint256`.
337      *
338      * Requirements:
339      *
340      * - `from` and `to` cannot be the zero address.
341      * - `from` must have a balance of at least `amount`.
342      * - the caller must have allowance for ``from``'s tokens of at least
343      * `amount`.
344      */
345     function transferFrom(address from, address to, uint256 amount) public virtual override returns (bool) {
346         address spender = _msgSender();
347         _spendAllowance(from, spender, amount);
348         _transfer(from, to, amount);
349         return true;
350     }
351 
352     /**
353      * @dev Atomically increases the allowance granted to `spender` by the caller.
354      *
355      * This is an alternative to {approve} that can be used as a mitigation for
356      * problems described in {IERC20-approve}.
357      *
358      * Emits an {Approval} event indicating the updated allowance.
359      *
360      * Requirements:
361      *
362      * - `spender` cannot be the zero address.
363      */
364     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
365         address owner = _msgSender();
366         _approve(owner, spender, allowance(owner, spender) + addedValue);
367         return true;
368     }
369 
370     /**
371      * @dev Atomically decreases the allowance granted to `spender` by the caller.
372      *
373      * This is an alternative to {approve} that can be used as a mitigation for
374      * problems described in {IERC20-approve}.
375      *
376      * Emits an {Approval} event indicating the updated allowance.
377      *
378      * Requirements:
379      *
380      * - `spender` cannot be the zero address.
381      * - `spender` must have allowance for the caller of at least
382      * `subtractedValue`.
383      */
384     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
385         address owner = _msgSender();
386         uint256 currentAllowance = allowance(owner, spender);
387         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
388         unchecked {
389             _approve(owner, spender, currentAllowance - subtractedValue);
390         }
391 
392         return true;
393     }
394 
395     /**
396      * @dev Moves `amount` of tokens from `from` to `to`.
397      *
398      * This internal function is equivalent to {transfer}, and can be used to
399      * e.g. implement automatic token fees, slashing mechanisms, etc.
400      *
401      * Emits a {Transfer} event.
402      *
403      * Requirements:
404      *
405      * - `from` cannot be the zero address.
406      * - `to` cannot be the zero address.
407      * - `from` must have a balance of at least `amount`.
408      */
409     function _transfer(address from, address to, uint256 amount) internal virtual {
410         require(from != address(0), "ERC20: transfer from the zero address");
411         require(to != address(0), "ERC20: transfer to the zero address");
412 
413         _beforeTokenTransfer(from, to, amount);
414 
415         uint256 fromBalance = _balances[from];
416         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
417         unchecked {
418             _balances[from] = fromBalance - amount;
419             // Overflow not possible: the sum of all balances is capped by totalSupply, and the sum is preserved by
420             // decrementing then incrementing.
421             _balances[to] += amount;
422         }
423 
424         emit Transfer(from, to, amount);
425 
426         _afterTokenTransfer(from, to, amount);
427     }
428 
429     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
430      * the total supply.
431      *
432      * Emits a {Transfer} event with `from` set to the zero address.
433      *
434      * Requirements:
435      *
436      * - `account` cannot be the zero address.
437      */
438     function _mint(address account, uint256 amount) internal virtual {
439         require(account != address(0), "ERC20: mint to the zero address");
440 
441         _beforeTokenTransfer(address(0), account, amount);
442 
443         _totalSupply += amount;
444         unchecked {
445             // Overflow not possible: balance + amount is at most totalSupply + amount, which is checked above.
446             _balances[account] += amount;
447         }
448         emit Transfer(address(0), account, amount);
449 
450         _afterTokenTransfer(address(0), account, amount);
451     }
452 
453     /**
454      * @dev Destroys `amount` tokens from `account`, reducing the
455      * total supply.
456      *
457      * Emits a {Transfer} event with `to` set to the zero address.
458      *
459      * Requirements:
460      *
461      * - `account` cannot be the zero address.
462      * - `account` must have at least `amount` tokens.
463      */
464     function _burn(address account, uint256 amount) internal virtual {
465         require(account != address(0), "ERC20: burn from the zero address");
466 
467         _beforeTokenTransfer(account, address(0), amount);
468 
469         uint256 accountBalance = _balances[account];
470         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
471         unchecked {
472             _balances[account] = accountBalance - amount;
473             // Overflow not possible: amount <= accountBalance <= totalSupply.
474             _totalSupply -= amount;
475         }
476 
477         emit Transfer(account, address(0), amount);
478 
479         _afterTokenTransfer(account, address(0), amount);
480     }
481 
482     /**
483      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
484      *
485      * This internal function is equivalent to `approve`, and can be used to
486      * e.g. set automatic allowances for certain subsystems, etc.
487      *
488      * Emits an {Approval} event.
489      *
490      * Requirements:
491      *
492      * - `owner` cannot be the zero address.
493      * - `spender` cannot be the zero address.
494      */
495     function _approve(address owner, address spender, uint256 amount) internal virtual {
496         require(owner != address(0), "ERC20: approve from the zero address");
497         require(spender != address(0), "ERC20: approve to the zero address");
498 
499         _allowances[owner][spender] = amount;
500         emit Approval(owner, spender, amount);
501     }
502 
503     /**
504      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
505      *
506      * Does not update the allowance amount in case of infinite allowance.
507      * Revert if not enough allowance is available.
508      *
509      * Might emit an {Approval} event.
510      */
511     function _spendAllowance(address owner, address spender, uint256 amount) internal virtual {
512         uint256 currentAllowance = allowance(owner, spender);
513         if (currentAllowance != type(uint256).max) {
514             require(currentAllowance >= amount, "ERC20: insufficient allowance");
515             unchecked {
516                 _approve(owner, spender, currentAllowance - amount);
517             }
518         }
519     }
520 
521     /**
522      * @dev Hook that is called before any transfer of tokens. This includes
523      * minting and burning.
524      *
525      * Calling conditions:
526      *
527      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
528      * will be transferred to `to`.
529      * - when `from` is zero, `amount` tokens will be minted for `to`.
530      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
531      * - `from` and `to` are never both zero.
532      *
533      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
534      */
535     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual {}
536 
537     /**
538      * @dev Hook that is called after any transfer of tokens. This includes
539      * minting and burning.
540      *
541      * Calling conditions:
542      *
543      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
544      * has been transferred to `to`.
545      * - when `from` is zero, `amount` tokens have been minted for `to`.
546      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
547      * - `from` and `to` are never both zero.
548      *
549      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
550      */
551     function _afterTokenTransfer(address from, address to, uint256 amount) internal virtual {}
552 }
553 
554 library SafeMath {
555     /**
556      * @dev Returns the addition of two unsigned integers, reverting on
557      * overflow.
558      *
559      * Counterpart to Solidity's `+` operator.
560      *
561      * Requirements:
562      *
563      * - Addition cannot overflow.
564      */
565     function add(uint256 a, uint256 b) internal pure returns (uint256) {
566         uint256 c = a + b;
567         require(c >= a, "SafeMath: addition overflow");
568 
569         return c;
570     }
571 
572     /**
573      * @dev Returns the subtraction of two unsigned integers, reverting on
574      * overflow (when the result is negative).
575      *
576      * Counterpart to Solidity's `-` operator.
577      *
578      * Requirements:
579      *
580      * - Subtraction cannot overflow.
581      */
582     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
583         return sub(a, b, "SafeMath: subtraction overflow");
584     }
585 
586     /**
587      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
588      * overflow (when the result is negative).
589      *
590      * Counterpart to Solidity's `-` operator.
591      *
592      * Requirements:
593      *
594      * - Subtraction cannot overflow.
595      */
596     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
597         require(b <= a, errorMessage);
598         uint256 c = a - b;
599 
600         return c;
601     }
602 
603     /**
604      * @dev Returns the multiplication of two unsigned integers, reverting on
605      * overflow.
606      *
607      * Counterpart to Solidity's `*` operator.
608      *
609      * Requirements:
610      *
611      * - Multiplication cannot overflow.
612      */
613     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
614         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
615         // benefit is lost if 'b' is also tested.
616         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
617         if (a == 0) {
618             return 0;
619         }
620 
621         uint256 c = a * b;
622         require(c / a == b, "SafeMath: multiplication overflow");
623 
624         return c;
625     }
626 
627     /**
628      * @dev Returns the integer division of two unsigned integers. Reverts on
629      * division by zero. The result is rounded towards zero.
630      *
631      * Counterpart to Solidity's `/` operator. Note: this function uses a
632      * `revert` opcode (which leaves remaining gas untouched) while Solidity
633      * uses an invalid opcode to revert (consuming all remaining gas).
634      *
635      * Requirements:
636      *
637      * - The divisor cannot be zero.
638      */
639     function div(uint256 a, uint256 b) internal pure returns (uint256) {
640         return div(a, b, "SafeMath: division by zero");
641     }
642 
643     /**
644      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
645      * division by zero. The result is rounded towards zero.
646      *
647      * Counterpart to Solidity's `/` operator. Note: this function uses a
648      * `revert` opcode (which leaves remaining gas untouched) while Solidity
649      * uses an invalid opcode to revert (consuming all remaining gas).
650      *
651      * Requirements:
652      *
653      * - The divisor cannot be zero.
654      */
655     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
656         require(b > 0, errorMessage);
657         uint256 c = a / b;
658         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
659 
660         return c;
661     }
662 
663     /**
664      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
665      * Reverts when dividing by zero.
666      *
667      * Counterpart to Solidity's `%` operator. This function uses a `revert`
668      * opcode (which leaves remaining gas untouched) while Solidity uses an
669      * invalid opcode to revert (consuming all remaining gas).
670      *
671      * Requirements:
672      *
673      * - The divisor cannot be zero.
674      */
675     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
676         return mod(a, b, "SafeMath: modulo by zero");
677     }
678 
679     /**
680      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
681      * Reverts with custom message when dividing by zero.
682      *
683      * Counterpart to Solidity's `%` operator. This function uses a `revert`
684      * opcode (which leaves remaining gas untouched) while Solidity uses an
685      * invalid opcode to revert (consuming all remaining gas).
686      *
687      * Requirements:
688      *
689      * - The divisor cannot be zero.
690      */
691     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
692         require(b != 0, errorMessage);
693         return a % b;
694     }
695 }
696 
697 /**
698  * @title SafeMathInt
699  * @dev Math operations for int256 with overflow safety checks.
700  */
701 library SafeMathInt {
702     int256 private constant MIN_INT256 = int256(1) << 255;
703     int256 private constant MAX_INT256 = ~(int256(1) << 255);
704 
705     /**
706      * @dev Multiplies two int256 variables and fails on overflow.
707      */
708     function mul(int256 a, int256 b) internal pure returns (int256) {
709         int256 c = a * b;
710 
711         // Detect overflow when multiplying MIN_INT256 with -1
712         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
713         require((b == 0) || (c / b == a));
714         return c;
715     }
716 
717     /**
718      * @dev Division of two int256 variables and fails on overflow.
719      */
720     function div(int256 a, int256 b) internal pure returns (int256) {
721         // Prevent overflow when dividing MIN_INT256 by -1
722         require(b != -1 || a != MIN_INT256);
723 
724         // Solidity already throws when dividing by 0.
725         return a / b;
726     }
727 
728     /**
729      * @dev Subtracts two int256 variables and fails on overflow.
730      */
731     function sub(int256 a, int256 b) internal pure returns (int256) {
732         int256 c = a - b;
733         require((b >= 0 && c <= a) || (b < 0 && c > a));
734         return c;
735     }
736 
737     /**
738      * @dev Adds two int256 variables and fails on overflow.
739      */
740     function add(int256 a, int256 b) internal pure returns (int256) {
741         int256 c = a + b;
742         require((b >= 0 && c >= a) || (b < 0 && c < a));
743         return c;
744     }
745 
746     /**
747      * @dev Converts to absolute value, and fails on overflow.
748      */
749     function abs(int256 a) internal pure returns (int256) {
750         require(a != MIN_INT256);
751         return a < 0 ? -a : a;
752     }
753 
754 
755     function toUint256Safe(int256 a) internal pure returns (uint256) {
756         require(a >= 0);
757         return uint256(a);
758     }
759 }
760 
761 /**
762  * @title SafeMathUint
763  * @dev Math operations with safety checks that revert on error
764  */
765 library SafeMathUint {
766   function toInt256Safe(uint256 a) internal pure returns (int256) {
767     int256 b = int256(a);
768     require(b >= 0);
769     return b;
770   }
771 }
772 
773 interface DividendPayingTokenInterface {
774   /// @notice View the amount of dividend in wei that an address can withdraw.
775   /// @param _owner The address of a token holder.
776   /// @return The amount of dividend in wei that `_owner` can withdraw.
777   function dividendOf(address _owner) external view returns(uint256);
778 
779   /// @notice Withdraws the ether distributed to the sender.
780   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
781   ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
782   function withdrawDividend() external;
783   
784   /// @notice View the amount of dividend in wei that an address can withdraw.
785   /// @param _owner The address of a token holder.
786   /// @return The amount of dividend in wei that `_owner` can withdraw.
787   function withdrawableDividendOf(address _owner) external view returns(uint256);
788 
789   /// @notice View the amount of dividend in wei that an address has withdrawn.
790   /// @param _owner The address of a token holder.
791   /// @return The amount of dividend in wei that `_owner` has withdrawn.
792   function withdrawnDividendOf(address _owner) external view returns(uint256);
793 
794   /// @notice View the amount of dividend in wei that an address has earned in total.
795   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
796   /// @param _owner The address of a token holder.
797   /// @return The amount of dividend in wei that `_owner` has earned in total.
798   function accumulativeDividendOf(address _owner) external view returns(uint256);
799 
800 
801   /// @dev This event MUST emit when ether is distributed to token holders.
802   /// @param from The address which sends ether to this contract.
803   /// @param weiAmount The amount of distributed ether in wei.
804   event DividendsDistributed(
805     address indexed from,
806     uint256 weiAmount
807   );
808 
809   /// @dev This event MUST emit when an address withdraws their dividend.
810   /// @param to The address which withdraws ether from this contract.
811   /// @param weiAmount The amount of withdrawn ether in wei.
812   event DividendWithdrawn(
813     address indexed to,
814     uint256 weiAmount
815   );
816   
817 }
818 
819 interface IPair {
820     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
821     function token0() external view returns (address);
822 
823 }
824 
825 interface IFactory{
826         function createPair(address tokenA, address tokenB) external returns (address pair);
827         function getPair(address tokenA, address tokenB) external view returns (address pair);
828 }
829 
830 interface IUniswapRouter {
831     function factory() external pure returns (address);
832     function WETH() external pure returns (address);
833     function addLiquidityETH(
834         address token,
835         uint amountTokenDesired,
836         uint amountTokenMin,
837         uint amountETHMin,
838         address to,
839         uint deadline
840     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
841     
842     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
843         uint amountIn,
844         uint amountOutMin,
845         address[] calldata path,
846         address to,
847         uint deadline
848     ) external;
849     
850     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
851         external
852         payable
853         returns (uint[] memory amounts);
854     
855     function swapExactTokensForETHSupportingFeeOnTransferTokens(
856         uint amountIn,
857         uint amountOutMin,
858         address[] calldata path,
859         address to,
860         uint deadline) external;
861 }
862 
863 contract DividendPayingToken is ERC20, DividendPayingTokenInterface, Ownable {
864 
865   using SafeMath for uint256;
866   using SafeMathUint for uint256;
867   using SafeMathInt for int256;
868 
869   address public LP_Token;
870 
871 
872   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
873   // For more discussion about choosing the value of `magnitude`,
874   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
875   uint256 constant internal magnitude = 2**128;
876 
877   uint256 internal magnifiedDividendPerShare;
878 
879   // About dividendCorrection:
880   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
881   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
882   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
883   //   `dividendOf(_user)` should not be changed,
884   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
885   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
886   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
887   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
888   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
889   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
890   mapping(address => int256) internal magnifiedDividendCorrections;
891   mapping(address => uint256) internal withdrawnDividends;
892 
893   uint256 public totalDividendsDistributed;
894   uint256 public totalDividendsWithdrawn;
895 
896   constructor(string memory _name, string memory _symbol) ERC20(_name, _symbol) {}
897 
898   function distributeLPDividends(uint256 amount) public onlyOwner{
899     require(totalSupply() > 0);
900 
901     if (amount > 0) {
902       magnifiedDividendPerShare = magnifiedDividendPerShare.add(
903         (amount).mul(magnitude) / totalSupply()
904       );
905       emit DividendsDistributed(msg.sender, amount);
906 
907       totalDividendsDistributed = totalDividendsDistributed.add(amount);
908     }
909   }
910 
911   /// @notice Withdraws the ether distributed to the sender.
912   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
913   function withdrawDividend() public virtual override {
914     _withdrawDividendOfUser(payable(msg.sender));
915   }
916 
917   /// @notice Withdraws the ether distributed to the sender.
918   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
919  function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
920     uint256 _withdrawableDividend = withdrawableDividendOf(user);
921     if (_withdrawableDividend > 0) {
922       withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
923       totalDividendsWithdrawn += _withdrawableDividend;
924       emit DividendWithdrawn(user, _withdrawableDividend);
925       bool success = IERC20(LP_Token).transfer(user, _withdrawableDividend);
926 
927       if(!success) {
928         withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
929         totalDividendsWithdrawn -= _withdrawableDividend;
930         return 0;
931       }
932 
933       return _withdrawableDividend;
934     }
935 
936     return 0;
937   }
938 
939 
940   /// @notice View the amount of dividend in wei that an address can withdraw.
941   /// @param _owner The address of a token holder.
942   /// @return The amount of dividend in wei that `_owner` can withdraw.
943   function dividendOf(address _owner) public view override returns(uint256) {
944     return withdrawableDividendOf(_owner);
945   }
946 
947   /// @notice View the amount of dividend in wei that an address can withdraw.
948   /// @param _owner The address of a token holder.
949   /// @return The amount of dividend in wei that `_owner` can withdraw.
950   function withdrawableDividendOf(address _owner) public view override returns(uint256) {
951     return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
952   }
953 
954   /// @notice View the amount of dividend in wei that an address has withdrawn.
955   /// @param _owner The address of a token holder.
956   /// @return The amount of dividend in wei that `_owner` has withdrawn.
957   function withdrawnDividendOf(address _owner) public view override returns(uint256) {
958     return withdrawnDividends[_owner];
959   }
960 
961 
962   /// @notice View the amount of dividend in wei that an address has earned in total.
963   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
964   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
965   /// @param _owner The address of a token holder.
966   /// @return The amount of dividend in wei that `_owner` has earned in total.
967   function accumulativeDividendOf(address _owner) public view override returns(uint256) {
968     return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
969       .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
970   }
971 
972   /// @dev Internal function that transfer tokens from one address to another.
973   /// Update magnifiedDividendCorrections to keep dividends unchanged.
974   /// @param from The address to transfer from.
975   /// @param to The address to transfer to.
976   /// @param value The amount to be transferred.
977   function _transfer(address from, address to, uint256 value) internal virtual override {
978     require(false);
979 
980     int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
981     magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
982     magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
983   }
984 
985   /// @dev Internal function that mints tokens to an account.
986   /// Update magnifiedDividendCorrections to keep dividends unchanged.
987   /// @param account The account that will receive the created tokens.
988   /// @param value The amount that will be created.
989   function _mint(address account, uint256 value) internal override {
990     super._mint(account, value);
991 
992     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
993       .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
994   }
995 
996   /// @dev Internal function that burns an amount of the token of a given account.
997   /// Update magnifiedDividendCorrections to keep dividends unchanged.
998   /// @param account The account whose tokens will be burnt.
999   /// @param value The amount that will be burnt.
1000   function _burn(address account, uint256 value) internal override {
1001     super._burn(account, value);
1002 
1003     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1004       .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
1005   }
1006 
1007   function _setBalance(address account, uint256 newBalance) internal {
1008     uint256 currentBalance = balanceOf(account);
1009 
1010     if(newBalance > currentBalance) {
1011       uint256 mintAmount = newBalance.sub(currentBalance);
1012       _mint(account, mintAmount);
1013     } else if(newBalance < currentBalance) {
1014       uint256 burnAmount = currentBalance.sub(newBalance);
1015       _burn(account, burnAmount);
1016     }
1017   }
1018 }
1019 
1020 
1021 contract RLPDividendTracker is Ownable, DividendPayingToken {
1022     struct AccountInfo {
1023         address account;
1024         uint256 withdrawableDividends;
1025         uint256 totalDividends;
1026         uint256 lastClaimTime;
1027     }
1028 
1029     mapping(address => bool) public excludedFromDividends;
1030 
1031     mapping(address => uint256) public lastClaimTimes;
1032 
1033     event ExcludeFromDividends(address indexed account, bool value);
1034     event Claim(address indexed account, uint256 amount);
1035 
1036     constructor()
1037         DividendPayingToken("Linq_Dividend_Tracker", "Linq_Dividend_Tracker")
1038     {}
1039 
1040     function trackerRescueETH20Tokens(address recipient, address tokenAddress)
1041         external
1042         onlyOwner
1043     {
1044         IERC20(tokenAddress).transfer(
1045             recipient,
1046             IERC20(tokenAddress).balanceOf(address(this))
1047         );
1048     }
1049 
1050     function updateLP_Token(address _lpToken) external onlyOwner {
1051         LP_Token = _lpToken;
1052     }
1053 
1054     function _transfer(
1055         address,
1056         address,
1057         uint256
1058     ) internal pure override {
1059         require(false, "Linq_Dividend_Tracker: No transfers allowed");
1060     }
1061 
1062     function excludeFromDividends(address account, bool value)
1063         external
1064         onlyOwner
1065     {
1066         require(excludedFromDividends[account] != value);
1067         excludedFromDividends[account] = value;
1068         if (value == true) {
1069             _setBalance(account, 0);
1070         } else {
1071             _setBalance(account, balanceOf(account));
1072         }
1073         emit ExcludeFromDividends(account, value);
1074     }
1075 
1076     function getAccount(address account)
1077         public
1078         view
1079         returns (
1080             address,
1081             uint256,
1082             uint256,
1083             uint256,
1084             uint256
1085         )
1086     {
1087         AccountInfo memory info;
1088         info.account = account;
1089         info.withdrawableDividends = withdrawableDividendOf(account);
1090         info.totalDividends = accumulativeDividendOf(account);
1091         info.lastClaimTime = lastClaimTimes[account];
1092         return (
1093             info.account,
1094             info.withdrawableDividends,
1095             info.totalDividends,
1096             info.lastClaimTime,
1097             totalDividendsWithdrawn
1098         );
1099     }
1100 
1101     function setBalance(address account, uint256 newBalance)
1102         external
1103         onlyOwner
1104     {
1105         if (excludedFromDividends[account]) {
1106             return;
1107         }
1108         _setBalance(account, newBalance);
1109     }
1110 
1111     function processAccount(address payable account)
1112         external
1113         onlyOwner
1114         returns (bool)
1115     {
1116         uint256 amount = _withdrawDividendOfUser(account);
1117 
1118         if (amount > 0) {
1119             lastClaimTimes[account] = block.timestamp;
1120             emit Claim(account, amount);
1121             return true;
1122         }
1123         return false;
1124     }
1125 }
1126 
1127 contract RLP is ERC20, Ownable {
1128     IUniswapRouter public router;
1129     address public pair;
1130 
1131     bool private swapping;
1132     bool public swapEnabled = true;
1133     bool public claimEnabled;
1134     bool public tradingEnabled;
1135 
1136     RLPDividendTracker public dividendTracker;
1137 
1138     address public marketingWallet;
1139 
1140     uint256 public swapTokensAtAmount;
1141     uint256 public maxBuyAmount;
1142     uint256 public maxSellAmount;
1143     uint256 public maxWallet;
1144 
1145     struct Taxes {
1146         uint256 liquidity;
1147         uint256 marketing;
1148         uint256 burn;
1149     }
1150 
1151     Taxes public buyTaxes = Taxes(3, 2, 1);
1152     Taxes public sellTaxes = Taxes(3, 2, 1);
1153 
1154     uint256 public totalBuyTax = 6;
1155     uint256 public totalSellTax = 6;
1156 
1157     mapping(address => bool) public _isBot;
1158 
1159     mapping(address => bool) private _isExcludedFromFees;
1160     mapping(address => bool) public automatedMarketMakerPairs;
1161     mapping(address => bool) private _isExcludedFromMaxWallet;
1162 
1163     ///////////////
1164     //   Events  //
1165     ///////////////
1166 
1167     event ExcludeFromFees(address indexed account, bool isExcluded);
1168     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1169     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1170     event GasForProcessingUpdated(
1171         uint256 indexed newValue,
1172         uint256 indexed oldValue
1173     );
1174     event SendDividends(uint256 tokensSwapped, uint256 amount);
1175     event ProcessedDividendTracker(
1176         uint256 iterations,
1177         uint256 claims,
1178         uint256 lastProcessedIndex,
1179         bool indexed automatic,
1180         uint256 gas,
1181         address indexed processor
1182     );
1183 
1184     constructor(address _marketingWallet) ERC20("Reflection LP", "RLP") {
1185         dividendTracker = new RLPDividendTracker();
1186         setMarketingWallet(_marketingWallet);
1187 
1188         IUniswapRouter _router = IUniswapRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1189         address _pair = IFactory(_router.factory()).createPair(
1190             address(this),
1191             _router.WETH()
1192         );
1193 
1194         router = _router;
1195         pair = _pair;
1196         setSwapTokensAtAmount(300000); //
1197         updateMaxWalletAmount(2000000);
1198         setMaxBuyAndSell(2000000, 2000000);
1199 
1200         _setAutomatedMarketMakerPair(_pair, true);
1201 
1202         dividendTracker.updateLP_Token(pair);
1203 
1204         dividendTracker.excludeFromDividends(address(dividendTracker), true);
1205         dividendTracker.excludeFromDividends(address(this), true);
1206         dividendTracker.excludeFromDividends(owner(), true);
1207         dividendTracker.excludeFromDividends(address(0xdead), true);
1208         dividendTracker.excludeFromDividends(address(_router), true);
1209 
1210         excludeFromMaxWallet(address(_pair), true);
1211         excludeFromMaxWallet(address(this), true);
1212         excludeFromMaxWallet(address(_router), true);
1213 
1214         excludeFromFees(owner(), true);
1215         excludeFromFees(address(this), true);
1216 
1217         _mint(owner(), 100000000 * (10**18));
1218     }
1219 
1220     receive() external payable {}
1221 
1222     function updateDividendTracker(address newAddress) public onlyOwner {
1223         RLPDividendTracker newDividendTracker = RLPDividendTracker(
1224             payable(newAddress)
1225         );
1226         newDividendTracker.excludeFromDividends(
1227             address(newDividendTracker),
1228             true
1229         );
1230         newDividendTracker.excludeFromDividends(address(this), true);
1231         newDividendTracker.excludeFromDividends(owner(), true);
1232         newDividendTracker.excludeFromDividends(address(router), true);
1233         dividendTracker = newDividendTracker;
1234     }
1235 
1236     /// @notice Manual claim the dividends
1237     function claim() external {
1238         require(claimEnabled, "Claim not enabled");
1239         dividendTracker.processAccount(payable(msg.sender));
1240     }
1241 
1242     function updateMaxWalletAmount(uint256 newNum) public onlyOwner {
1243         require(newNum >= 1000000, "Cannot set maxWallet lower than 1%");
1244         maxWallet = newNum * 10**18;
1245     }
1246 
1247     function setMaxBuyAndSell(uint256 maxBuy, uint256 maxSell)
1248         public
1249         onlyOwner
1250     {
1251         require(maxBuy >= 1000000, "Cannot set maxbuy lower than 1% ");
1252         require(maxSell >= 500000, "Cannot set maxsell lower than 0.5% ");
1253         maxBuyAmount = maxBuy * 10**18;
1254         maxSellAmount = maxSell * 10**18;
1255     }
1256 
1257     function setSwapTokensAtAmount(uint256 amount) public onlyOwner {
1258         swapTokensAtAmount = amount * 10**18;
1259     }
1260 
1261     function excludeFromMaxWallet(address account, bool excluded)
1262         public
1263         onlyOwner
1264     {
1265         _isExcludedFromMaxWallet[account] = excluded;
1266     }
1267 
1268     /// @notice Withdraw tokens sent by mistake.
1269     /// @param tokenAddress The address of the token to withdraw
1270     function rescueETH20Tokens(address tokenAddress) external onlyOwner {
1271         IERC20(tokenAddress).transfer(
1272             owner(),
1273             IERC20(tokenAddress).balanceOf(address(this))
1274         );
1275     }
1276 
1277     /// @notice Send remaining ETH to dev
1278     /// @dev It will send all ETH to dev
1279     function forceSend() external onlyOwner {
1280         uint256 ETHbalance = address(this).balance;
1281         (bool success, ) = payable(marketingWallet).call{value: ETHbalance}("");
1282         require(success);
1283     }
1284 
1285     function trackerRescueETH20Tokens(address tokenAddress) external onlyOwner {
1286         dividendTracker.trackerRescueETH20Tokens(msg.sender, tokenAddress);
1287     }
1288 
1289     function updateRouter(address newRouter) external onlyOwner {
1290         router = IUniswapRouter(newRouter);
1291     }
1292 
1293     /////////////////////////////////
1294     // Exclude / Include functions //
1295     /////////////////////////////////
1296 
1297     function excludeFromFees(address account, bool excluded) public onlyOwner {
1298         require(
1299             _isExcludedFromFees[account] != excluded,
1300             "Account is already the value of 'excluded'"
1301         );
1302         _isExcludedFromFees[account] = excluded;
1303 
1304         emit ExcludeFromFees(account, excluded);
1305     }
1306 
1307     /// @dev "true" to exlcude, "false" to include
1308     function excludeFromDividends(address account, bool value)
1309         public
1310         onlyOwner
1311     {
1312         dividendTracker.excludeFromDividends(account, value);
1313     }
1314 
1315     function setMarketingWallet(address newWallet) public onlyOwner {
1316         marketingWallet = newWallet;
1317     }
1318 
1319     function setBuyTaxes(uint256 _liquidity, uint256 _marketing, uint256 _burn) external onlyOwner {
1320         require(_liquidity + _marketing + _burn <= 20, "Fee must be <= 20%");
1321         buyTaxes = Taxes(_liquidity, _marketing, _burn);
1322         totalBuyTax = _liquidity + _marketing + _burn;
1323     }
1324 
1325     function setSellTaxes(uint256 _liquidity, uint256 _marketing, uint256 _burn) external onlyOwner {
1326         require(_liquidity + _marketing + _burn <= 20, "Fee must be <= 20%");
1327         sellTaxes = Taxes(_liquidity, _marketing, _burn);
1328         totalSellTax = _liquidity + _marketing + _burn;
1329     }
1330 
1331     /// @notice Enable or disable internal swaps
1332     /// @dev Set "true" to enable internal swaps for liquidity, treasury and dividends
1333     function setSwapEnabled(bool _enabled) external onlyOwner {
1334         swapEnabled = _enabled;
1335     }
1336 
1337     function activateTrading() external onlyOwner {
1338         require(!tradingEnabled, "Trading already enabled");
1339         tradingEnabled = true;
1340     }
1341 
1342     function setClaimEnabled(bool state) external onlyOwner {
1343         claimEnabled = state;
1344     }
1345 
1346     /// @param bot The bot address
1347     /// @param value "true" to blacklist, "false" to unblacklist
1348     function setBot(address bot, bool value) external onlyOwner {
1349         require(_isBot[bot] != value);
1350         _isBot[bot] = value;
1351     }
1352 
1353     function setLP_Token(address _lpToken) external onlyOwner {
1354         dividendTracker.updateLP_Token(_lpToken);
1355     }
1356 
1357     /// @dev Set new pairs created due to listing in new DEX
1358     function setAutomatedMarketMakerPair(address newPair, bool value)
1359         external
1360         onlyOwner
1361     {
1362         _setAutomatedMarketMakerPair(newPair, value);
1363     }
1364 
1365     function _setAutomatedMarketMakerPair(address newPair, bool value) private {
1366         require(
1367             automatedMarketMakerPairs[newPair] != value,
1368             "Automated market maker pair is already set to that value"
1369         );
1370         automatedMarketMakerPairs[newPair] = value;
1371 
1372         if (value) {
1373             dividendTracker.excludeFromDividends(newPair, true);
1374         }
1375 
1376         emit SetAutomatedMarketMakerPair(newPair, value);
1377     }
1378 
1379     //////////////////////
1380     // Getter Functions //
1381     //////////////////////
1382 
1383     function getTotalDividendsDistributed() external view returns (uint256) {
1384         return dividendTracker.totalDividendsDistributed();
1385     }
1386 
1387     function isExcludedFromFees(address account) public view returns (bool) {
1388         return _isExcludedFromFees[account];
1389     }
1390 
1391     function withdrawableDividendOf(address account)
1392         public
1393         view
1394         returns (uint256)
1395     {
1396         return dividendTracker.withdrawableDividendOf(account);
1397     }
1398 
1399     function dividendTokenBalanceOf(address account)
1400         public
1401         view
1402         returns (uint256)
1403     {
1404         return dividendTracker.balanceOf(account);
1405     }
1406 
1407     function getAccountInfo(address account)
1408         external
1409         view
1410         returns (
1411             address,
1412             uint256,
1413             uint256,
1414             uint256,
1415             uint256
1416         )
1417     {
1418         return dividendTracker.getAccount(account);
1419     }
1420 
1421     ////////////////////////
1422     // Transfer Functions //
1423     ////////////////////////
1424 
1425     function _transfer(
1426         address from,
1427         address to,
1428         uint256 amount
1429     ) internal override {
1430         require(from != address(0), "ERC20: transfer from the zero address");
1431         require(to != address(0), "ERC20: transfer to the zero address");
1432 
1433         if (
1434             !_isExcludedFromFees[from] && !_isExcludedFromFees[to] && !swapping
1435         ) {
1436             require(tradingEnabled, "Trading not active");
1437             if (automatedMarketMakerPairs[to]) {
1438                 require(
1439                     amount <= maxSellAmount,
1440                     "You are exceeding maxSellAmount"
1441                 );
1442             } else if (automatedMarketMakerPairs[from])
1443                 require(
1444                     amount <= maxBuyAmount,
1445                     "You are exceeding maxBuyAmount"
1446                 );
1447             if (!_isExcludedFromMaxWallet[to]) {
1448                 require(
1449                     amount + balanceOf(to) <= maxWallet,
1450                     "Unable to exceed Max Wallet"
1451                 );
1452             }
1453         }
1454 
1455         if (amount == 0) {
1456             super._transfer(from, to, 0);
1457             return;
1458         }
1459 
1460         uint256 contractTokenBalance = balanceOf(address(this));
1461         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1462 
1463         if (
1464             canSwap &&
1465             !swapping &&
1466             swapEnabled &&
1467             automatedMarketMakerPairs[to] &&
1468             !_isExcludedFromFees[from] &&
1469             !_isExcludedFromFees[to]
1470         ) {
1471             swapping = true;
1472 
1473             if (totalSellTax > 0) {
1474                 swapAndLiquify(swapTokensAtAmount);
1475             }
1476 
1477             swapping = false;
1478         }
1479 
1480         bool takeFee = !swapping;
1481 
1482         // if any account belongs to _isExcludedFromFee account then remove the fee
1483         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1484             takeFee = false;
1485         }
1486 
1487         if (!automatedMarketMakerPairs[to] && !automatedMarketMakerPairs[from])
1488             takeFee = false;
1489 
1490         if (takeFee) {
1491             uint256 feeAmt;
1492             if (automatedMarketMakerPairs[to])
1493                 feeAmt = (amount * totalSellTax) / 100;
1494             else if (automatedMarketMakerPairs[from])
1495                 feeAmt = (amount * totalBuyTax) / 100;
1496 
1497             amount = amount - feeAmt;
1498             super._transfer(from, address(this), feeAmt);
1499         }
1500         super._transfer(from, to, amount);
1501 
1502         try dividendTracker.setBalance(from, balanceOf(from)) {} catch {}
1503         try dividendTracker.setBalance(to, balanceOf(to)) {} catch {}
1504     }
1505 
1506     function swapAndLiquify(uint256 tokens) private {
1507         uint256 toSwapForLiq = ((tokens * sellTaxes.liquidity) / totalSellTax) / 2;
1508         uint256 tokensToAddLiquidityWith = ((tokens * sellTaxes.liquidity) / totalSellTax) / 2;
1509         uint256 toSwapForMarketing = (tokens * sellTaxes.marketing) / totalSellTax;
1510 
1511         uint256 toBurn = (tokens * sellTaxes.burn) / totalSellTax;
1512 
1513         swapTokensForETH(toSwapForLiq);
1514 
1515         uint256 currentbalance = address(this).balance;
1516 
1517         if (currentbalance > 0) {
1518             // Add liquidity to uni
1519             addLiquidity(tokensToAddLiquidityWith, currentbalance);
1520         }
1521 
1522         swapTokensForETH(toSwapForMarketing);
1523 
1524         uint256 EthTaxBalance = address(this).balance;
1525 
1526         // Send ETH to dev
1527         uint256 devAmt = EthTaxBalance;
1528 
1529         if (devAmt > 0) {
1530             (bool success, ) = payable(marketingWallet).call{value: devAmt}("");
1531             require(success, "Failed to send ETH to dev wallet");
1532         }
1533 
1534         uint256 lpBalance = IERC20(pair).balanceOf(address(this));
1535 
1536         //Send LP to dividends
1537         uint256 dividends = lpBalance;
1538 
1539         if (dividends > 0) {
1540             bool success = IERC20(pair).transfer(
1541                 address(dividendTracker),
1542                 dividends
1543             );
1544             if (success) {
1545                 dividendTracker.distributeLPDividends(dividends);
1546                 emit SendDividends(tokens, dividends);
1547             }
1548         }
1549 
1550         if (toBurn > 0) {
1551             _burn(address(this), toBurn);
1552         }
1553     }
1554 
1555     // transfers LP from the owners wallet to holders // must approve this contract, on pair contract before calling
1556     function ManualLiquidityDistribution(uint256 amount) public onlyOwner {
1557         bool success = IERC20(pair).transferFrom(
1558             msg.sender,
1559             address(dividendTracker),
1560             amount
1561         );
1562         if (success) {
1563             dividendTracker.distributeLPDividends(amount);
1564         }
1565     }
1566 
1567     function swapTokensForETH(uint256 tokenAmount) private {
1568         address[] memory path = new address[](2);
1569         path[0] = address(this);
1570         path[1] = router.WETH();
1571 
1572         _approve(address(this), address(router), tokenAmount);
1573 
1574         // make the swap
1575         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1576             tokenAmount,
1577             0, // accept any amount of ETH
1578             path,
1579             address(this),
1580             block.timestamp
1581         );
1582     }
1583 
1584     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1585         // approve token transfer to cover all possible scenarios
1586         _approve(address(this), address(router), tokenAmount);
1587 
1588         // add the liquidity
1589         router.addLiquidityETH{value: ethAmount}(
1590             address(this),
1591             tokenAmount,
1592             0, // slippage is unavoidable
1593             0, // slippage is unavoidable
1594             address(this),
1595             block.timestamp
1596         );
1597     }
1598 }