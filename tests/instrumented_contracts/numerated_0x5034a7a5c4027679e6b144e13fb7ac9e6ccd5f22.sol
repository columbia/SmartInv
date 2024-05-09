1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 interface IUniswapV2Factory {
6     function createPair(address tokenA, address tokenB)
7         external
8         returns (address pair);
9 }
10 
11 interface IUniswapV2Router01 {
12     function factory() external pure returns (address);
13 
14     function WETH() external pure returns (address);
15 
16     function addLiquidityETH(
17         address token,
18         uint256 amountTokenDesired,
19         uint256 amountTokenMin,
20         uint256 amountETHMin,
21         address to,
22         uint256 deadline
23     )
24         external
25         payable
26         returns (
27             uint256 amountToken,
28             uint256 amountETH,
29             uint256 liquidity
30         );
31 }
32 
33 interface IUniswapV2Router02 is IUniswapV2Router01 {
34     function swapExactTokensForETHSupportingFeeOnTransferTokens(
35         uint256 amountIn,
36         uint256 amountOutMin,
37         address[] calldata path,
38         address to,
39         uint256 deadline
40     ) external;
41 }
42 
43 interface IUniswapV2Pair {
44     function sync() external;
45 }
46 
47 /**
48  * @dev Provides information about the current execution context, including the
49  * sender of the transaction and its data. While these are generally available
50  * via msg.sender and msg.data, they should not be accessed in such a direct
51  * manner, since when dealing with meta-transactions the account sending and
52  * paying for execution may not be the actual sender (as far as an application
53  * is concerned).
54  *
55  * This contract is only required for intermediate, library-like contracts.
56  */
57 abstract contract Context {
58     function _msgSender() internal view virtual returns (address) {
59         return msg.sender;
60     }
61 
62     function _msgData() internal view virtual returns (bytes calldata) {
63         return msg.data;
64     }
65 }
66 
67 /**
68  * @dev Contract module which provides a basic access control mechanism, where
69  * there is an account (an owner) that can be granted exclusive access to
70  * specific functions.
71  *
72  * By default, the owner account will be the one that deploys the contract. This
73  * can later be changed with {transferOwnership}.
74  *
75  * This module is used through inheritance. It will make available the modifier
76  * `onlyOwner`, which can be applied to your functions to restrict their use to
77  * the owner.
78  */
79 abstract contract Ownable is Context {
80     address private _owner;
81 
82     event OwnershipTransferred(
83         address indexed previousOwner,
84         address indexed newOwner
85     );
86 
87     /**
88      * @dev Initializes the contract setting the deployer as the initial owner.
89      */
90     constructor() {
91         _transferOwnership(_msgSender());
92     }
93 
94     /**
95      * @dev Returns the address of the current owner.
96      */
97     function owner() public view virtual returns (address) {
98         return _owner;
99     }
100 
101     /**
102      * @dev Throws if called by any account other than the owner.
103      */
104     modifier onlyOwner() {
105         require(owner() == _msgSender(), "Ownable: caller is not the owner");
106         _;
107     }
108 
109     /**
110      * @dev Leaves the contract without owner. It will not be possible to call
111      * `onlyOwner` functions anymore. Can only be called by the current owner.
112      *
113      * NOTE: Renouncing ownership will leave the contract without an owner,
114      * thereby removing any functionality that is only available to the owner.
115      */
116     function renounceOwnership() public virtual onlyOwner {
117         _transferOwnership(address(0));
118     }
119 
120     /**
121      * @dev Transfers ownership of the contract to a new account (`newOwner`).
122      * Can only be called by the current owner.
123      */
124     function transferOwnership(address newOwner) public virtual onlyOwner {
125         require(
126             newOwner != address(0),
127             "Ownable: new owner is the zero address"
128         );
129         _transferOwnership(newOwner);
130     }
131 
132     /**
133      * @dev Transfers ownership of the contract to a new account (`newOwner`).
134      * Internal function without access restriction.
135      */
136     function _transferOwnership(address newOwner) internal virtual {
137         address oldOwner = _owner;
138         _owner = newOwner;
139         emit OwnershipTransferred(oldOwner, newOwner);
140     }
141 }
142 
143 /**
144  * @dev Interface of the ERC20 standard as defined in the EIP.
145  */
146 interface IERC20 {
147     /**
148      * @dev Returns the amount of tokens in existence.
149      */
150     function totalSupply() external view returns (uint256);
151 
152     /**
153      * @dev Returns the amount of tokens owned by `account`.
154      */
155     function balanceOf(address account) external view returns (uint256);
156 
157     /**
158      * @dev Moves `amount` tokens from the caller's account to `recipient`.
159      *
160      * Returns a boolean value indicating whether the operation succeeded.
161      *
162      * Emits a {Transfer} event.
163      */
164     function transfer(address recipient, uint256 amount)
165         external
166         returns (bool);
167 
168     /**
169      * @dev Returns the remaining number of tokens that `spender` will be
170      * allowed to spend on behalf of `owner` through {transferFrom}. This is
171      * zero by default.
172      *
173      * This value changes when {approve} or {transferFrom} are called.
174      */
175     function allowance(address owner, address spender)
176         external
177         view
178         returns (uint256);
179 
180     /**
181      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
182      *
183      * Returns a boolean value indicating whether the operation succeeded.
184      *
185      * IMPORTANT: Beware that changing an allowance with this method brings the risk
186      * that someone may use both the old and the new allowance by unfortunate
187      * transaction ordering. One possible solution to mitigate this race
188      * condition is to first reduce the spender's allowance to 0 and set the
189      * desired value afterwards:
190      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
191      *
192      * Emits an {Approval} event.
193      */
194     function approve(address spender, uint256 amount) external returns (bool);
195 
196     /**
197      * @dev Moves `amount` tokens from `sender` to `recipient` using the
198      * allowance mechanism. `amount` is then deducted from the caller's
199      * allowance.
200      *
201      * Returns a boolean value indicating whether the operation succeeded.
202      *
203      * Emits a {Transfer} event.
204      */
205     function transferFrom(
206         address sender,
207         address recipient,
208         uint256 amount
209     ) external returns (bool);
210 
211     /**
212      * @dev Emitted when `value` tokens are moved from one account (`from`) to
213      * another (`to`).
214      *
215      * Note that `value` may be zero.
216      */
217     event Transfer(address indexed from, address indexed to, uint256 value);
218 
219     /**
220      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
221      * a call to {approve}. `value` is the new allowance.
222      */
223     event Approval(
224         address indexed owner,
225         address indexed spender,
226         uint256 value
227     );
228 }
229 
230 /**
231  * @dev Interface for the optional metadata functions from the ERC20 standard.
232  *
233  * _Available since v4.1._
234  */
235 interface IERC20Metadata is IERC20 {
236     /**
237      * @dev Returns the name of the token.
238      */
239     function name() external view returns (string memory);
240 
241     /**
242      * @dev Returns the symbol of the token.
243      */
244     function symbol() external view returns (string memory);
245 
246     /**
247      * @dev Returns the decimals places of the token.
248      */
249     function decimals() external view returns (uint8);
250 }
251 
252 /**
253  * @dev Implementation of the {IERC20} interface.
254  *
255  * This implementation is agnostic to the way tokens are created. This means
256  * that a supply mechanism has to be added in a derived contract using {_mint}.
257  * For a generic mechanism see {ERC20PresetMinterPauser}.
258  *
259  * TIP: For a detailed writeup see our guide
260  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
261  * to implement supply mechanisms].
262  *
263  * We have followed general OpenZeppelin Contracts guidelines: functions revert
264  * instead returning `false` on failure. This behavior is nonetheless
265  * conventional and does not conflict with the expectations of ERC20
266  * applications.
267  *
268  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
269  * This allows applications to reconstruct the allowance for all accounts just
270  * by listening to said events. Other implementations of the EIP may not emit
271  * these events, as it isn't required by the specification.
272  *
273  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
274  * functions have been added to mitigate the well-known issues around setting
275  * allowances. See {IERC20-approve}.
276  */
277 contract ERC20 is Context, IERC20, IERC20Metadata {
278     mapping(address => uint256) private _balances;
279 
280     mapping(address => mapping(address => uint256)) private _allowances;
281 
282     uint256 private _totalSupply;
283 
284     string private _name;
285     string private _symbol;
286 
287     /**
288      * @dev Sets the values for {name} and {symbol}.
289      *
290      * The default value of {decimals} is 18. To select a different value for
291      * {decimals} you should overload it.
292      *
293      * All two of these values are immutable: they can only be set once during
294      * construction.
295      */
296     constructor(string memory name_, string memory symbol_) {
297         _name = name_;
298         _symbol = symbol_;
299     }
300 
301     /**
302      * @dev Returns the name of the token.
303      */
304     function name() public view virtual override returns (string memory) {
305         return _name;
306     }
307 
308     /**
309      * @dev Returns the symbol of the token, usually a shorter version of the
310      * name.
311      */
312     function symbol() public view virtual override returns (string memory) {
313         return _symbol;
314     }
315 
316     /**
317      * @dev Returns the number of decimals used to get its user representation.
318      * For example, if `decimals` equals `2`, a balance of `505` tokens should
319      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
320      *
321      * Tokens usually opt for a value of 18, imitating the relationship between
322      * Ether and Wei. This is the value {ERC20} uses, unless this function is
323      * overridden;
324      *
325      * NOTE: This information is only used for _display_ purposes: it in
326      * no way affects any of the arithmetic of the contract, including
327      * {IERC20-balanceOf} and {IERC20-transfer}.
328      */
329     function decimals() public view virtual override returns (uint8) {
330         return 18;
331     }
332 
333     /**
334      * @dev See {IERC20-totalSupply}.
335      */
336     function totalSupply() public view virtual override returns (uint256) {
337         return _totalSupply;
338     }
339 
340     /**
341      * @dev See {IERC20-balanceOf}.
342      */
343     function balanceOf(address account)
344         public
345         view
346         virtual
347         override
348         returns (uint256)
349     {
350         return _balances[account];
351     }
352 
353     /**
354      * @dev See {IERC20-transfer}.
355      *
356      * Requirements:
357      *
358      * - `recipient` cannot be the zero address.
359      * - the caller must have a balance of at least `amount`.
360      */
361     function transfer(address recipient, uint256 amount)
362         public
363         virtual
364         override
365         returns (bool)
366     {
367         _transfer(_msgSender(), recipient, amount);
368         return true;
369     }
370 
371     /**
372      * @dev See {IERC20-allowance}.
373      */
374     function allowance(address owner, address spender)
375         public
376         view
377         virtual
378         override
379         returns (uint256)
380     {
381         return _allowances[owner][spender];
382     }
383 
384     /**
385      * @dev See {IERC20-approve}.
386      *
387      * Requirements:
388      *
389      * - `spender` cannot be the zero address.
390      */
391     function approve(address spender, uint256 amount)
392         public
393         virtual
394         override
395         returns (bool)
396     {
397         _approve(_msgSender(), spender, amount);
398         return true;
399     }
400 
401     /**
402      * @dev See {IERC20-transferFrom}.
403      *
404      * Emits an {Approval} event indicating the updated allowance. This is not
405      * required by the EIP. See the note at the beginning of {ERC20}.
406      *
407      * Requirements:
408      *
409      * - `sender` and `recipient` cannot be the zero address.
410      * - `sender` must have a balance of at least `amount`.
411      * - the caller must have allowance for ``sender``'s tokens of at least
412      * `amount`.
413      */
414     function transferFrom(
415         address sender,
416         address recipient,
417         uint256 amount
418     ) public virtual override returns (bool) {
419         _transfer(sender, recipient, amount);
420 
421         uint256 currentAllowance = _allowances[sender][_msgSender()];
422         require(
423             currentAllowance >= amount,
424             "ERC20: transfer amount exceeds allowance"
425         );
426         unchecked {
427             _approve(sender, _msgSender(), currentAllowance - amount);
428         }
429 
430         return true;
431     }
432 
433     /**
434      * @dev Atomically increases the allowance granted to `spender` by the caller.
435      *
436      * This is an alternative to {approve} that can be used as a mitigation for
437      * problems described in {IERC20-approve}.
438      *
439      * Emits an {Approval} event indicating the updated allowance.
440      *
441      * Requirements:
442      *
443      * - `spender` cannot be the zero address.
444      */
445     function increaseAllowance(address spender, uint256 addedValue)
446         public
447         virtual
448         returns (bool)
449     {
450         _approve(
451             _msgSender(),
452             spender,
453             _allowances[_msgSender()][spender] + addedValue
454         );
455         return true;
456     }
457 
458     /**
459      * @dev Atomically decreases the allowance granted to `spender` by the caller.
460      *
461      * This is an alternative to {approve} that can be used as a mitigation for
462      * problems described in {IERC20-approve}.
463      *
464      * Emits an {Approval} event indicating the updated allowance.
465      *
466      * Requirements:
467      *
468      * - `spender` cannot be the zero address.
469      * - `spender` must have allowance for the caller of at least
470      * `subtractedValue`.
471      */
472     function decreaseAllowance(address spender, uint256 subtractedValue)
473         public
474         virtual
475         returns (bool)
476     {
477         uint256 currentAllowance = _allowances[_msgSender()][spender];
478         require(
479             currentAllowance >= subtractedValue,
480             "ERC20: decreased allowance below zero"
481         );
482         unchecked {
483             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
484         }
485 
486         return true;
487     }
488 
489     /**
490      * @dev Moves `amount` of tokens from `sender` to `recipient`.
491      *
492      * This internal function is equivalent to {transfer}, and can be used to
493      * e.g. implement automatic token fees, slashing mechanisms, etc.
494      *
495      * Emits a {Transfer} event.
496      *
497      * Requirements:
498      *
499      * - `sender` cannot be the zero address.
500      * - `recipient` cannot be the zero address.
501      * - `sender` must have a balance of at least `amount`.
502      */
503     function _transfer(
504         address sender,
505         address recipient,
506         uint256 amount
507     ) internal virtual {
508         require(sender != address(0), "ERC20: transfer from the zero address");
509         require(recipient != address(0), "ERC20: transfer to the zero address");
510 
511         _beforeTokenTransfer(sender, recipient, amount);
512 
513         uint256 senderBalance = _balances[sender];
514         require(
515             senderBalance >= amount,
516             "ERC20: transfer amount exceeds balance"
517         );
518         unchecked {
519             _balances[sender] = senderBalance - amount;
520         }
521         _balances[recipient] += amount;
522 
523         emit Transfer(sender, recipient, amount);
524 
525         _afterTokenTransfer(sender, recipient, amount);
526     }
527 
528     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
529      * the total supply.
530      *
531      * Emits a {Transfer} event with `from` set to the zero address.
532      *
533      * Requirements:
534      *
535      * - `account` cannot be the zero address.
536      */
537     function _mint(address account, uint256 amount) internal virtual {
538         require(account != address(0), "ERC20: mint to the zero address");
539 
540         _beforeTokenTransfer(address(0), account, amount);
541 
542         _totalSupply += amount;
543         _balances[account] += amount;
544         emit Transfer(address(0), account, amount);
545 
546         _afterTokenTransfer(address(0), account, amount);
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
565         uint256 accountBalance = _balances[account];
566         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
567         unchecked {
568             _balances[account] = accountBalance - amount;
569         }
570         _totalSupply -= amount;
571 
572         emit Transfer(account, address(0), amount);
573 
574         _afterTokenTransfer(account, address(0), amount);
575     }
576 
577     /**
578      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
579      *
580      * This internal function is equivalent to `approve`, and can be used to
581      * e.g. set automatic allowances for certain subsystems, etc.
582      *
583      * Emits an {Approval} event.
584      *
585      * Requirements:
586      *
587      * - `owner` cannot be the zero address.
588      * - `spender` cannot be the zero address.
589      */
590     function _approve(
591         address owner,
592         address spender,
593         uint256 amount
594     ) internal virtual {
595         require(owner != address(0), "ERC20: approve from the zero address");
596         require(spender != address(0), "ERC20: approve to the zero address");
597 
598         _allowances[owner][spender] = amount;
599         emit Approval(owner, spender, amount);
600     }
601 
602     /**
603      * @dev Hook that is called before any transfer of tokens. This includes
604      * minting and burning.
605      *
606      * Calling conditions:
607      *
608      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
609      * will be transferred to `to`.
610      * - when `from` is zero, `amount` tokens will be minted for `to`.
611      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
612      * - `from` and `to` are never both zero.
613      *
614      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
615      */
616     function _beforeTokenTransfer(
617         address from,
618         address to,
619         uint256 amount
620     ) internal virtual {}
621 
622     /**
623      * @dev Hook that is called after any transfer of tokens. This includes
624      * minting and burning.
625      *
626      * Calling conditions:
627      *
628      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
629      * has been transferred to `to`.
630      * - when `from` is zero, `amount` tokens have been minted for `to`.
631      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
632      * - `from` and `to` are never both zero.
633      *
634      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
635      */
636     function _afterTokenTransfer(
637         address from,
638         address to,
639         uint256 amount
640     ) internal virtual {}
641 }
642 
643 // CAUTION
644 // This version of SafeMath should only be used with Solidity 0.8 or later,
645 // because it relies on the compiler's built in overflow checks.
646 
647 /**
648  * @dev Wrappers over Solidity's arithmetic operations.
649  *
650  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
651  * now has built in overflow checking.
652  */
653 library SafeMath {
654     /**
655      * @dev Returns the addition of two unsigned integers, with an overflow flag.
656      *
657      * _Available since v3.4._
658      */
659     function tryAdd(uint256 a, uint256 b)
660         internal
661         pure
662         returns (bool, uint256)
663     {
664         unchecked {
665             uint256 c = a + b;
666             if (c < a) return (false, 0);
667             return (true, c);
668         }
669     }
670 
671     /**
672      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
673      *
674      * _Available since v3.4._
675      */
676     function trySub(uint256 a, uint256 b)
677         internal
678         pure
679         returns (bool, uint256)
680     {
681         unchecked {
682             if (b > a) return (false, 0);
683             return (true, a - b);
684         }
685     }
686 
687     /**
688      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
689      *
690      * _Available since v3.4._
691      */
692     function tryMul(uint256 a, uint256 b)
693         internal
694         pure
695         returns (bool, uint256)
696     {
697         unchecked {
698             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
699             // benefit is lost if 'b' is also tested.
700             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
701             if (a == 0) return (true, 0);
702             uint256 c = a * b;
703             if (c / a != b) return (false, 0);
704             return (true, c);
705         }
706     }
707 
708     /**
709      * @dev Returns the division of two unsigned integers, with a division by zero flag.
710      *
711      * _Available since v3.4._
712      */
713     function tryDiv(uint256 a, uint256 b)
714         internal
715         pure
716         returns (bool, uint256)
717     {
718         unchecked {
719             if (b == 0) return (false, 0);
720             return (true, a / b);
721         }
722     }
723 
724     /**
725      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
726      *
727      * _Available since v3.4._
728      */
729     function tryMod(uint256 a, uint256 b)
730         internal
731         pure
732         returns (bool, uint256)
733     {
734         unchecked {
735             if (b == 0) return (false, 0);
736             return (true, a % b);
737         }
738     }
739 
740     /**
741      * @dev Returns the addition of two unsigned integers, reverting on
742      * overflow.
743      *
744      * Counterpart to Solidity's `+` operator.
745      *
746      * Requirements:
747      *
748      * - Addition cannot overflow.
749      */
750     function add(uint256 a, uint256 b) internal pure returns (uint256) {
751         return a + b;
752     }
753 
754     /**
755      * @dev Returns the subtraction of two unsigned integers, reverting on
756      * overflow (when the result is negative).
757      *
758      * Counterpart to Solidity's `-` operator.
759      *
760      * Requirements:
761      *
762      * - Subtraction cannot overflow.
763      */
764     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
765         return a - b;
766     }
767 
768     /**
769      * @dev Returns the multiplication of two unsigned integers, reverting on
770      * overflow.
771      *
772      * Counterpart to Solidity's `*` operator.
773      *
774      * Requirements:
775      *
776      * - Multiplication cannot overflow.
777      */
778     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
779         return a * b;
780     }
781 
782     /**
783      * @dev Returns the integer division of two unsigned integers, reverting on
784      * division by zero. The result is rounded towards zero.
785      *
786      * Counterpart to Solidity's `/` operator.
787      *
788      * Requirements:
789      *
790      * - The divisor cannot be zero.
791      */
792     function div(uint256 a, uint256 b) internal pure returns (uint256) {
793         return a / b;
794     }
795 
796     /**
797      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
798      * reverting when dividing by zero.
799      *
800      * Counterpart to Solidity's `%` operator. This function uses a `revert`
801      * opcode (which leaves remaining gas untouched) while Solidity uses an
802      * invalid opcode to revert (consuming all remaining gas).
803      *
804      * Requirements:
805      *
806      * - The divisor cannot be zero.
807      */
808     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
809         return a % b;
810     }
811 
812     /**
813      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
814      * overflow (when the result is negative).
815      *
816      * CAUTION: This function is deprecated because it requires allocating memory for the error
817      * message unnecessarily. For custom revert reasons use {trySub}.
818      *
819      * Counterpart to Solidity's `-` operator.
820      *
821      * Requirements:
822      *
823      * - Subtraction cannot overflow.
824      */
825     function sub(
826         uint256 a,
827         uint256 b,
828         string memory errorMessage
829     ) internal pure returns (uint256) {
830         unchecked {
831             require(b <= a, errorMessage);
832             return a - b;
833         }
834     }
835 
836     /**
837      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
838      * division by zero. The result is rounded towards zero.
839      *
840      * Counterpart to Solidity's `/` operator. Note: this function uses a
841      * `revert` opcode (which leaves remaining gas untouched) while Solidity
842      * uses an invalid opcode to revert (consuming all remaining gas).
843      *
844      * Requirements:
845      *
846      * - The divisor cannot be zero.
847      */
848     function div(
849         uint256 a,
850         uint256 b,
851         string memory errorMessage
852     ) internal pure returns (uint256) {
853         unchecked {
854             require(b > 0, errorMessage);
855             return a / b;
856         }
857     }
858 
859     /**
860      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
861      * reverting with custom message when dividing by zero.
862      *
863      * CAUTION: This function is deprecated because it requires allocating memory for the error
864      * message unnecessarily. For custom revert reasons use {tryMod}.
865      *
866      * Counterpart to Solidity's `%` operator. This function uses a `revert`
867      * opcode (which leaves remaining gas untouched) while Solidity uses an
868      * invalid opcode to revert (consuming all remaining gas).
869      *
870      * Requirements:
871      *
872      * - The divisor cannot be zero.
873      */
874     function mod(
875         uint256 a,
876         uint256 b,
877         string memory errorMessage
878     ) internal pure returns (uint256) {
879         unchecked {
880             require(b > 0, errorMessage);
881             return a % b;
882         }
883     }
884 }
885 
886 contract VortexOfficial is ERC20, Ownable {
887     using SafeMath for uint256;
888 
889     IUniswapV2Router02 public immutable uniswapV2Router;
890     address public uniswapV2Pair;
891     address public constant deadAddress = address(0xdead);
892 
893     bool private swapping;
894 
895     address public devWallet;
896 
897     uint256 public maxTransactionAmount;
898     uint256 public swapTokensAtAmount;
899     uint256 public maxWallet;
900 
901     uint256 public percentForLPBurn = 20; // 20 = .20%
902     bool public lpBurnEnabled = true;
903     uint256 public lpBurnFrequency = 3600 seconds;
904     uint256 public lastLpBurnTime;
905 
906     uint256 public manualBurnFrequency = 30 minutes;
907     uint256 public lastManualLpBurnTime;
908 
909     bool public limitsInEffect = true;
910     bool public tradingActive = false;
911     bool public swapEnabled = false;
912 
913     // Anti-bot and anti-whale mappings and variables
914     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
915     bool public transferDelayEnabled = true;
916 
917     uint256 public  buyTotalFees;
918     uint256 public  buyBurnFee = 0;
919     uint256 public  buyLiquidityFee = 2;
920     uint256 public  buyDevFee = 2;
921 
922     uint256 public  sellTotalFees;
923     uint256 public  sellBurnFee = 0;
924     uint256 public  sellLiquidityFee = 2;
925     uint256 public  sellDevFee = 2;
926 
927     uint256 public tokensForBurn;
928     uint256 public tokensForLiquidity;
929     uint256 public tokensForDev;
930 
931     /******************/
932 
933     // exlcude from fees and max transaction amount
934     mapping(address => bool) private _isExcludedFromFees;
935     mapping(address => bool) public _isExcludedMaxTransactionAmount;
936 
937     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
938     // could be subject to a maximum transfer amount
939     mapping(address => bool) public automatedMarketMakerPairs;
940 
941     event UpdateUniswapV2Router(
942         address indexed newAddress,
943         address indexed oldAddress
944     );
945 
946     event ExcludeFromFees(address indexed account, bool isExcluded);
947 
948     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
949 
950     event devWalletUpdated(
951         address indexed newWallet,
952         address indexed oldWallet
953     );
954 
955     event SwapAndLiquify(
956         uint256 tokensSwapped,
957         uint256 ethReceived,
958         uint256 tokensIntoLiquidity
959     );
960 
961     event AutoNukeLP();
962 
963     event ManualNukeLP();
964 
965     event BoughtEarly(address indexed sniper);
966 
967     constructor() ERC20("Vortex Official", "VRTX") {
968         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
969             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
970         );
971 
972         excludeFromMaxTransaction(address(_uniswapV2Router), true);
973         uniswapV2Router = _uniswapV2Router;
974 
975         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
976             .createPair(address(this), _uniswapV2Router.WETH());
977         excludeFromMaxTransaction(address(uniswapV2Pair), true);
978         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
979 
980         uint256 totalSupply = 1_000_000_000 * 1e18; // 1 billion total supply
981 
982         maxTransactionAmount = 10_000_000 * 1e18; // 1% from total supply
983         maxWallet = 10_000_000 * 1e18; // 1% from total supply maxWallet
984         swapTokensAtAmount = (totalSupply * 3) / 10000; // 0.03% swap wallet
985 
986         buyTotalFees = buyBurnFee + buyLiquidityFee + buyDevFee;
987         sellTotalFees = sellBurnFee + sellLiquidityFee + sellDevFee;
988 
989         devWallet = address(0x0117240677dC00c38Ac3bF133B9bae49Dbd6d156); // set as dev wallet
990 
991         // exclude from paying fees or having max transaction amount
992         excludeFromFees(owner(), true);
993         excludeFromFees(address(this), true);
994         excludeFromFees(address(0xdead), true);
995 
996         excludeFromMaxTransaction(owner(), true);
997         excludeFromMaxTransaction(address(this), true);
998         excludeFromMaxTransaction(address(0xdead), true);
999 
1000         /*
1001             _mint is an internal function in ERC20.sol that is only called here,
1002             and CANNOT be called ever again
1003         */
1004         _mint(msg.sender, totalSupply);
1005     }
1006 
1007     receive() external payable {}
1008 
1009     // once enabled, can never be turned off
1010     function startTrading() external onlyOwner {
1011         tradingActive = true;
1012         swapEnabled = true;
1013         lastLpBurnTime = block.timestamp;
1014     }
1015 
1016     // remove limits after token is stable
1017     function removeLimits() external onlyOwner returns (bool) {
1018         limitsInEffect = false;
1019         return true;
1020     }
1021 
1022     // disable Transfer delay - cannot be reenabled
1023     function disableTransferDelay() external onlyOwner returns (bool) {
1024         transferDelayEnabled = false;
1025         return true;
1026     }
1027 
1028     // change the minimum amount of tokens to sell from fees
1029     function updateSwapTokensAtAmount(uint256 newAmount)
1030         external
1031         onlyOwner
1032         returns (bool)
1033     {
1034         require(
1035             newAmount >= (totalSupply() * 1) / 100000,
1036             "Swap amount cannot be lower than 0.001% total supply."
1037         );
1038         require(
1039             newAmount <= (totalSupply() * 5) / 1000,
1040             "Swap amount cannot be higher than 0.5% total supply."
1041         );
1042         swapTokensAtAmount = newAmount;
1043         return true;
1044     }
1045 
1046     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1047         require(
1048             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1049             "Cannot set maxTransactionAmount lower than 0.1%"
1050         );
1051         maxTransactionAmount = newNum * (10**18);
1052     }
1053 
1054     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1055         require(
1056             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1057             "Cannot set maxWallet lower than 0.5%"
1058         );
1059         maxWallet = newNum * (10**18);
1060     }
1061 
1062     function excludeFromMaxTransaction(address updAds, bool isEx)
1063         public
1064         onlyOwner
1065     {
1066         _isExcludedMaxTransactionAmount[updAds] = isEx;
1067     }
1068 
1069     // only use to disable contract sales if absolutely necessary (emergency use only)
1070     function updateSwapEnabled(bool enabled) external onlyOwner {
1071         swapEnabled = enabled;
1072     }
1073 
1074     function updateBuyFees(
1075         uint256 _burnFee,
1076         uint256 _liquidityFee,
1077         uint256 _devFee
1078     ) external onlyOwner {
1079         buyBurnFee = _burnFee;
1080         buyLiquidityFee = _liquidityFee;
1081         buyDevFee = _devFee;
1082         buyTotalFees = buyBurnFee + buyLiquidityFee + buyDevFee;
1083         require(buyTotalFees <= 5, "Must keep fees at 5% or less");
1084     }
1085 
1086     function updateSellFees(
1087         uint256 _burnFee,
1088         uint256 _liquidityFee,
1089         uint256 _devFee
1090     ) external onlyOwner {
1091         sellBurnFee = _burnFee;
1092         sellLiquidityFee = _liquidityFee;
1093         sellDevFee = _devFee;
1094         sellTotalFees = sellBurnFee + sellLiquidityFee + sellDevFee;
1095         require(sellTotalFees <= 5, "Must keep fees at  5% or less");
1096     }
1097 
1098     function excludeFromFees(address account, bool excluded) public onlyOwner {
1099         _isExcludedFromFees[account] = excluded;
1100         emit ExcludeFromFees(account, excluded);
1101     }
1102 
1103     function setAutomatedMarketMakerPair(address pair, bool value)
1104         public
1105         onlyOwner
1106     {
1107         require(
1108             pair != uniswapV2Pair,
1109             "The pair cannot be removed from automatedMarketMakerPairs"
1110         );
1111 
1112         _setAutomatedMarketMakerPair(pair, value);
1113     }
1114 
1115     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1116         automatedMarketMakerPairs[pair] = value;
1117 
1118         emit SetAutomatedMarketMakerPair(pair, value);
1119     }
1120 
1121     function updateDevWallet(address newWallet) external onlyOwner {
1122         emit devWalletUpdated(newWallet, devWallet);
1123         devWallet = newWallet;
1124     }
1125 
1126     function isExcludedFromFees(address account) public view returns (bool) {
1127         return _isExcludedFromFees[account];
1128     }
1129 
1130     function _transfer(
1131         address from,
1132         address to,
1133         uint256 amount
1134     ) internal override {
1135         require(from != address(0), "ERC20: transfer from the zero address");
1136         require(to != address(0), "ERC20: transfer to the zero address");
1137 
1138         if (amount == 0) {
1139             super._transfer(from, to, 0);
1140             return;
1141         }
1142 
1143         if (limitsInEffect) {
1144             if (
1145                 from != owner() &&
1146                 to != owner() &&
1147                 to != address(0) &&
1148                 to != address(0xdead) &&
1149                 !swapping
1150             ) {
1151                 if (!tradingActive) {
1152                     require(
1153                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1154                         "Trading is not active."
1155                     );
1156                 }
1157 
1158                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1159                 if (transferDelayEnabled) {
1160                     if (
1161                         to != owner() &&
1162                         to != address(uniswapV2Router) &&
1163                         to != address(uniswapV2Pair)
1164                     ) {
1165                         require(
1166                             _holderLastTransferTimestamp[tx.origin] <
1167                                 block.number,
1168                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1169                         );
1170                         _holderLastTransferTimestamp[tx.origin] = block.number;
1171                     }
1172                 }
1173 
1174                 //when buy
1175                 if (
1176                     automatedMarketMakerPairs[from] &&
1177                     !_isExcludedMaxTransactionAmount[to]
1178                 ) {
1179                     require(
1180                         amount <= maxTransactionAmount,
1181                         "Buy transfer amount exceeds the maxTransactionAmount."
1182                     );
1183                     require(
1184                         amount + balanceOf(to) <= maxWallet,
1185                         "Max wallet exceeded"
1186                     );
1187                 }
1188                 //when sell
1189                 else if (
1190                     automatedMarketMakerPairs[to] &&
1191                     !_isExcludedMaxTransactionAmount[from]
1192                 ) {
1193                     require(
1194                         amount <= maxTransactionAmount,
1195                         "Sell transfer amount exceeds the maxTransactionAmount."
1196                     );
1197                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1198                     require(
1199                         amount + balanceOf(to) <= maxWallet,
1200                         "Max wallet exceeded"
1201                     );
1202                 }
1203             }
1204         }
1205 
1206         uint256 contractTokenBalance = balanceOf(address(this));
1207 
1208         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1209 
1210         if (
1211             canSwap &&
1212             swapEnabled &&
1213             !swapping &&
1214             !automatedMarketMakerPairs[from] &&
1215             !_isExcludedFromFees[from] &&
1216             !_isExcludedFromFees[to]
1217         ) {
1218             swapping = true;
1219 
1220             swapBack();
1221 
1222             swapping = false;
1223         }
1224 
1225         if (
1226             !swapping &&
1227             automatedMarketMakerPairs[to] &&
1228             lpBurnEnabled &&
1229             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1230             !_isExcludedFromFees[from]
1231         ) {
1232             autoBurnLiquidityPairTokens();
1233         }
1234 
1235         bool takeFee = !swapping;
1236 
1237         // if any account belongs to _isExcludedFromFee account then remove the fee
1238         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1239             takeFee = false;
1240         }
1241 
1242         uint256 fees = 0;
1243         // only take fees on buys/sells, do not take on wallet transfers
1244         if (takeFee) {
1245             // on sell
1246             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1247                 fees = amount.mul(sellTotalFees).div(100);
1248                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1249                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1250                 tokensForBurn += (fees * sellBurnFee) / sellTotalFees;
1251             }
1252             // on buy
1253             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1254                 fees = amount.mul(buyTotalFees).div(100);
1255                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1256                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1257                 tokensForBurn += (fees * buyBurnFee) / buyTotalFees;
1258             }
1259 
1260             if (fees > 0) {
1261                 super._transfer(from, address(this), fees);
1262             }
1263 
1264             amount -= fees;
1265         }
1266 
1267         super._transfer(from, to, amount);
1268     }
1269 
1270     function swapTokensForEth(uint256 tokenAmount) private {
1271         // generate the uniswap pair path of token -> weth
1272         address[] memory path = new address[](2);
1273         path[0] = address(this);
1274         path[1] = uniswapV2Router.WETH();
1275 
1276         _approve(address(this), address(uniswapV2Router), tokenAmount);
1277 
1278         // make the swap
1279         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1280             tokenAmount,
1281             0, // accept any amount of ETH
1282             path,
1283             address(this),
1284             block.timestamp
1285         );
1286     }
1287 
1288     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1289         // approve token transfer to cover all possible scenarios
1290         _approve(address(this), address(uniswapV2Router), tokenAmount);
1291 
1292         // add the liquidity
1293         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1294             address(this),
1295             tokenAmount,
1296             0, // slippage is unavoidable
1297             0, // slippage is unavoidable
1298             deadAddress,
1299             block.timestamp
1300         );
1301     }
1302 
1303     function swapBack() private {
1304         uint256 contractBalance = balanceOf(address(this));
1305         uint256 totalTokensToSwap = tokensForLiquidity +
1306             tokensForDev;
1307         bool success;
1308 
1309         if (contractBalance == 0 || totalTokensToSwap == 0) {
1310             return;
1311         }
1312 
1313         if (contractBalance > swapTokensAtAmount * 20) {
1314             contractBalance = swapTokensAtAmount * 20;
1315         }
1316 
1317         // Halve the amount of liquidity tokens
1318         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1319             totalTokensToSwap /
1320             2;
1321         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens).sub(tokensForBurn);
1322 
1323         uint256 initialETHBalance = address(this).balance;
1324 
1325         swapTokensForEth(amountToSwapForETH);
1326 
1327         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1328 
1329         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1330 
1331         uint256 ethForLiquidity = ethBalance - ethForDev;
1332         if (tokensForBurn > 0) {
1333         super._transfer(address(this), address(0xdead), tokensForBurn); 
1334         }
1335 
1336         tokensForLiquidity = 0;
1337         tokensForBurn = 0;
1338         tokensForDev = 0;
1339 
1340 
1341         (success, ) = address(devWallet).call{value: ethForDev}("");
1342 
1343         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1344             addLiquidity(liquidityTokens, ethForLiquidity);
1345             emit SwapAndLiquify(
1346                 amountToSwapForETH,
1347                 ethForLiquidity,
1348                 tokensForLiquidity
1349             );
1350         }
1351     }
1352 
1353     function setAutoLPBurnSettings(
1354         uint256 _frequencyInSeconds,
1355         uint256 _percent,
1356         bool _Enabled
1357     ) external onlyOwner {
1358         require(
1359             _frequencyInSeconds >= 600,
1360             "cannot set buyback more often than every 10 minutes"
1361         );
1362         require(
1363             _percent <= 1000 && _percent >= 0,
1364             "Must set auto LP burn percent between 0% and 10%"
1365         );
1366         lpBurnFrequency = _frequencyInSeconds;
1367         percentForLPBurn = _percent;
1368         lpBurnEnabled = _Enabled;
1369     }
1370 
1371     function autoBurnLiquidityPairTokens() internal returns (bool) {
1372         lastLpBurnTime = block.timestamp;
1373 
1374         // get balance of liquidity pair
1375         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1376 
1377         // calculate amount to burn
1378         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1379             10000
1380         );
1381 
1382         // pull tokens from pancakePair liquidity and move to dead address permanently
1383         if (amountToBurn > 0) {
1384             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1385         }
1386 
1387         //sync price since this is not in a swap transaction!
1388         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1389         pair.sync();
1390         emit AutoNukeLP();
1391         return true;
1392     }
1393 
1394     function manualBurnLiquidityPairTokens(uint256 percent)
1395         external
1396         onlyOwner
1397         returns (bool)
1398     {
1399         require(
1400             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1401             "Must wait for cooldown to finish"
1402         );
1403         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1404         lastManualLpBurnTime = block.timestamp;
1405 
1406         // get balance of liquidity pair
1407         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1408 
1409         // calculate amount to burn
1410         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1411 
1412         // pull tokens from pancakePair liquidity and move to dead address permanently
1413         if (amountToBurn > 0) {
1414             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1415         }
1416 
1417         //sync price since this is not in a swap transaction!
1418         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1419         pair.sync();
1420         emit ManualNukeLP();
1421         return true;
1422     }
1423 }