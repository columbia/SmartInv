1 /**
2 
3 
4 The Monster of Wall Street
5 https://themadoffponzi.com
6 https://t.me/themadoffponzi 
7 
8 
9 */
10 
11 // SPDX-License-Identifier: MIT
12 
13 pragma solidity ^0.8.0;
14 
15 interface IUniswapV2Factory {
16     function createPair(address tokenA, address tokenB)
17         external
18         returns (address pair);
19 }
20 
21 interface IUniswapV2Router01 {
22     function factory() external pure returns (address);
23 
24     function WETH() external pure returns (address);
25 
26     function addLiquidityETH(
27         address token,
28         uint256 amountTokenDesired,
29         uint256 amountTokenMin,
30         uint256 amountETHMin,
31         address to,
32         uint256 deadline
33     )
34         external
35         payable
36         returns (
37             uint256 amountToken,
38             uint256 amountETH,
39             uint256 liquidity
40         );
41 }
42 
43 interface IUniswapV2Router02 is IUniswapV2Router01 {
44     function swapExactTokensForETHSupportingFeeOnTransferTokens(
45         uint256 amountIn,
46         uint256 amountOutMin,
47         address[] calldata path,
48         address to,
49         uint256 deadline
50     ) external;
51 }
52 
53 interface IUniswapV2Pair {
54     function sync() external;
55 }
56 
57 /**
58  * @dev Provides information about the current execution context, including the
59  * sender of the transaction and its data. While these are generally available
60  * via msg.sender and msg.data, they should not be accessed in such a direct
61  * manner, since when dealing with meta-transactions the account sending and
62  * paying for execution may not be the actual sender (as far as an application
63  * is concerned).
64  *
65  * This contract is only required for intermediate, library-like contracts.
66  */
67 abstract contract Context {
68     function _msgSender() internal view virtual returns (address) {
69         return msg.sender;
70     }
71 
72     function _msgData() internal view virtual returns (bytes calldata) {
73         return msg.data;
74     }
75 }
76 
77 /**
78  * @dev Contract module which provides a basic access control mechanism, where
79  * there is an account (an owner) that can be granted exclusive access to
80  * specific functions.
81  *
82  * By default, the owner account will be the one that deploys the contract. This
83  * can later be changed with {transferOwnership}.
84  *
85  * This module is used through inheritance. It will make available the modifier
86  * `onlyOwner`, which can be applied to your functions to restrict their use to
87  * the owner.
88  */
89 abstract contract Ownable is Context {
90     address private _owner;
91 
92     event OwnershipTransferred(
93         address indexed previousOwner,
94         address indexed newOwner
95     );
96 
97     /**
98      * @dev Initializes the contract setting the deployer as the initial owner.
99      */
100     constructor() {
101         _transferOwnership(_msgSender());
102     }
103 
104     /**
105      * @dev Returns the address of the current owner.
106      */
107     function owner() public view virtual returns (address) {
108         return _owner;
109     }
110 
111     /**
112      * @dev Throws if called by any account other than the owner.
113      */
114     modifier onlyOwner() {
115         require(owner() == _msgSender(), "Ownable: caller is not the owner");
116         _;
117     }
118 
119     /**
120      * @dev Leaves the contract without owner. It will not be possible to call
121      * `onlyOwner` functions anymore. Can only be called by the current owner.
122      *
123      * NOTE: Renouncing ownership will leave the contract without an owner,
124      * thereby removing any functionality that is only available to the owner.
125      */
126     function renounceOwnership() public virtual onlyOwner {
127         _transferOwnership(address(0));
128     }
129 
130     /**
131      * @dev Transfers ownership of the contract to a new account (`newOwner`).
132      * Can only be called by the current owner.
133      */
134     function transferOwnership(address newOwner) public virtual onlyOwner {
135         require(
136             newOwner != address(0),
137             "Ownable: new owner is the zero address"
138         );
139         _transferOwnership(newOwner);
140     }
141 
142     /**
143      * @dev Transfers ownership of the contract to a new account (`newOwner`).
144      * Internal function without access restriction.
145      */
146     function _transferOwnership(address newOwner) internal virtual {
147         address oldOwner = _owner;
148         _owner = newOwner;
149         emit OwnershipTransferred(oldOwner, newOwner);
150     }
151 }
152 
153 /**
154  * @dev Interface of the ERC20 standard as defined in the EIP.
155  */
156 interface IERC20 {
157     /**
158      * @dev Returns the amount of tokens in existence.
159      */
160     function totalSupply() external view returns (uint256);
161 
162     /**
163      * @dev Returns the amount of tokens owned by `account`.
164      */
165     function balanceOf(address account) external view returns (uint256);
166 
167     /**
168      * @dev Moves `amount` tokens from the caller's account to `recipient`.
169      *
170      * Returns a boolean value indicating whether the operation succeeded.
171      *
172      * Emits a {Transfer} event.
173      */
174     function transfer(address recipient, uint256 amount)
175         external
176         returns (bool);
177 
178     /**
179      * @dev Returns the remaining number of tokens that `spender` will be
180      * allowed to spend on behalf of `owner` through {transferFrom}. This is
181      * zero by default.
182      *
183      * This value changes when {approve} or {transferFrom} are called.
184      */
185     function allowance(address owner, address spender)
186         external
187         view
188         returns (uint256);
189 
190     /**
191      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
192      *
193      * Returns a boolean value indicating whether the operation succeeded.
194      *
195      * IMPORTANT: Beware that changing an allowance with this method brings the risk
196      * that someone may use both the old and the new allowance by unfortunate
197      * transaction ordering. One possible solution to mitigate this race
198      * condition is to first reduce the spender's allowance to 0 and set the
199      * desired value afterwards:
200      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
201      *
202      * Emits an {Approval} event.
203      */
204     function approve(address spender, uint256 amount) external returns (bool);
205 
206     /**
207      * @dev Moves `amount` tokens from `sender` to `recipient` using the
208      * allowance mechanism. `amount` is then deducted from the caller's
209      * allowance.
210      *
211      * Returns a boolean value indicating whether the operation succeeded.
212      *
213      * Emits a {Transfer} event.
214      */
215     function transferFrom(
216         address sender,
217         address recipient,
218         uint256 amount
219     ) external returns (bool);
220 
221     /**
222      * @dev Emitted when `value` tokens are moved from one account (`from`) to
223      * another (`to`).
224      *
225      * Note that `value` may be zero.
226      */
227     event Transfer(address indexed from, address indexed to, uint256 value);
228 
229     /**
230      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
231      * a call to {approve}. `value` is the new allowance.
232      */
233     event Approval(
234         address indexed owner,
235         address indexed spender,
236         uint256 value
237     );
238 }
239 
240 /**
241  * @dev Interface for the optional metadata functions from the ERC20 standard.
242  *
243  * _Available since v4.1._
244  */
245 interface IERC20Metadata is IERC20 {
246     /**
247      * @dev Returns the name of the token.
248      */
249     function name() external view returns (string memory);
250 
251     /**
252      * @dev Returns the symbol of the token.
253      */
254     function symbol() external view returns (string memory);
255 
256     /**
257      * @dev Returns the decimals places of the token.
258      */
259     function decimals() external view returns (uint8);
260 }
261 
262 /**
263  * @dev Implementation of the {IERC20} interface.
264  *
265  * This implementation is agnostic to the way tokens are created. This means
266  * that a supply mechanism has to be added in a derived contract using {_mint}.
267  * For a generic mechanism see {ERC20PresetMinterPauser}.
268  *
269  * TIP: For a detailed writeup see our guide
270  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
271  * to implement supply mechanisms].
272  *
273  * We have followed general OpenZeppelin Contracts guidelines: functions revert
274  * instead returning `false` on failure. This behavior is nonetheless
275  * conventional and does not conflict with the expectations of ERC20
276  * applications.
277  *
278  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
279  * This allows applications to reconstruct the allowance for all accounts just
280  * by listening to said events. Other implementations of the EIP may not emit
281  * these events, as it isn't required by the specification.
282  *
283  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
284  * functions have been added to mitigate the well-known issues around setting
285  * allowances. See {IERC20-approve}.
286  */
287 contract ERC20 is Context, IERC20, IERC20Metadata {
288     mapping(address => uint256) private _balances;
289 
290     mapping(address => mapping(address => uint256)) private _allowances;
291 
292     uint256 private _totalSupply;
293 
294     string private _name;
295     string private _symbol;
296 
297     /**
298      * @dev Sets the values for {name} and {symbol}.
299      *
300      * The default value of {decimals} is 18. To select a different value for
301      * {decimals} you should overload it.
302      *
303      * All two of these values are immutable: they can only be set once during
304      * construction.
305      */
306     constructor(string memory name_, string memory symbol_) {
307         _name = name_;
308         _symbol = symbol_;
309     }
310 
311     /**
312      * @dev Returns the name of the token.
313      */
314     function name() public view virtual override returns (string memory) {
315         return _name;
316     }
317 
318     /**
319      * @dev Returns the symbol of the token, usually a shorter version of the
320      * name.
321      */
322     function symbol() public view virtual override returns (string memory) {
323         return _symbol;
324     }
325 
326     /**
327      * @dev Returns the number of decimals used to get its user representation.
328      * For example, if `decimals` equals `2`, a balance of `505` tokens should
329      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
330      *
331      * Tokens usually opt for a value of 18, imitating the relationship between
332      * Ether and Wei. This is the value {ERC20} uses, unless this function is
333      * overridden;
334      *
335      * NOTE: This information is only used for _display_ purposes: it in
336      * no way affects any of the arithmetic of the contract, including
337      * {IERC20-balanceOf} and {IERC20-transfer}.
338      */
339     function decimals() public view virtual override returns (uint8) {
340         return 18;
341     }
342 
343     /**
344      * @dev See {IERC20-totalSupply}.
345      */
346     function totalSupply() public view virtual override returns (uint256) {
347         return _totalSupply;
348     }
349 
350     /**
351      * @dev See {IERC20-balanceOf}.
352      */
353     function balanceOf(address account)
354         public
355         view
356         virtual
357         override
358         returns (uint256)
359     {
360         return _balances[account];
361     }
362 
363     /**
364      * @dev See {IERC20-transfer}.
365      *
366      * Requirements:
367      *
368      * - `recipient` cannot be the zero address.
369      * - the caller must have a balance of at least `amount`.
370      */
371     function transfer(address recipient, uint256 amount)
372         public
373         virtual
374         override
375         returns (bool)
376     {
377         _transfer(_msgSender(), recipient, amount);
378         return true;
379     }
380 
381     /**
382      * @dev See {IERC20-allowance}.
383      */
384     function allowance(address owner, address spender)
385         public
386         view
387         virtual
388         override
389         returns (uint256)
390     {
391         return _allowances[owner][spender];
392     }
393 
394     /**
395      * @dev See {IERC20-approve}.
396      *
397      * Requirements:
398      *
399      * - `spender` cannot be the zero address.
400      */
401     function approve(address spender, uint256 amount)
402         public
403         virtual
404         override
405         returns (bool)
406     {
407         _approve(_msgSender(), spender, amount);
408         return true;
409     }
410 
411     /**
412      * @dev See {IERC20-transferFrom}.
413      *
414      * Emits an {Approval} event indicating the updated allowance. This is not
415      * required by the EIP. See the note at the beginning of {ERC20}.
416      *
417      * Requirements:
418      *
419      * - `sender` and `recipient` cannot be the zero address.
420      * - `sender` must have a balance of at least `amount`.
421      * - the caller must have allowance for ``sender``'s tokens of at least
422      * `amount`.
423      */
424     function transferFrom(
425         address sender,
426         address recipient,
427         uint256 amount
428     ) public virtual override returns (bool) {
429         _transfer(sender, recipient, amount);
430 
431         uint256 currentAllowance = _allowances[sender][_msgSender()];
432         require(
433             currentAllowance >= amount,
434             "ERC20: transfer amount exceeds allowance"
435         );
436         unchecked {
437             _approve(sender, _msgSender(), currentAllowance - amount);
438         }
439 
440         return true;
441     }
442 
443     /**
444      * @dev Atomically increases the allowance granted to `spender` by the caller.
445      *
446      * This is an alternative to {approve} that can be used as a mitigation for
447      * problems described in {IERC20-approve}.
448      *
449      * Emits an {Approval} event indicating the updated allowance.
450      *
451      * Requirements:
452      *
453      * - `spender` cannot be the zero address.
454      */
455     function increaseAllowance(address spender, uint256 addedValue)
456         public
457         virtual
458         returns (bool)
459     {
460         _approve(
461             _msgSender(),
462             spender,
463             _allowances[_msgSender()][spender] + addedValue
464         );
465         return true;
466     }
467 
468     /**
469      * @dev Atomically decreases the allowance granted to `spender` by the caller.
470      *
471      * This is an alternative to {approve} that can be used as a mitigation for
472      * problems described in {IERC20-approve}.
473      *
474      * Emits an {Approval} event indicating the updated allowance.
475      *
476      * Requirements:
477      *
478      * - `spender` cannot be the zero address.
479      * - `spender` must have allowance for the caller of at least
480      * `subtractedValue`.
481      */
482     function decreaseAllowance(address spender, uint256 subtractedValue)
483         public
484         virtual
485         returns (bool)
486     {
487         uint256 currentAllowance = _allowances[_msgSender()][spender];
488         require(
489             currentAllowance >= subtractedValue,
490             "ERC20: decreased allowance below zero"
491         );
492         unchecked {
493             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
494         }
495 
496         return true;
497     }
498 
499     /**
500      * @dev Moves `amount` of tokens from `sender` to `recipient`.
501      *
502      * This internal function is equivalent to {transfer}, and can be used to
503      * e.g. implement automatic token fees, slashing mechanisms, etc.
504      *
505      * Emits a {Transfer} event.
506      *
507      * Requirements:
508      *
509      * - `sender` cannot be the zero address.
510      * - `recipient` cannot be the zero address.
511      * - `sender` must have a balance of at least `amount`.
512      */
513     function _transfer(
514         address sender,
515         address recipient,
516         uint256 amount
517     ) internal virtual {
518         require(sender != address(0), "ERC20: transfer from the zero address");
519         require(recipient != address(0), "ERC20: transfer to the zero address");
520 
521         _beforeTokenTransfer(sender, recipient, amount);
522 
523         uint256 senderBalance = _balances[sender];
524         require(
525             senderBalance >= amount,
526             "ERC20: transfer amount exceeds balance"
527         );
528         unchecked {
529             _balances[sender] = senderBalance - amount;
530         }
531         _balances[recipient] += amount;
532 
533         emit Transfer(sender, recipient, amount);
534 
535         _afterTokenTransfer(sender, recipient, amount);
536     }
537 
538     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
539      * the total supply.
540      *
541      * Emits a {Transfer} event with `from` set to the zero address.
542      *
543      * Requirements:
544      *
545      * - `account` cannot be the zero address.
546      */
547     function _mint(address account, uint256 amount) internal virtual {
548         require(account != address(0), "ERC20: mint to the zero address");
549 
550         _beforeTokenTransfer(address(0), account, amount);
551 
552         _totalSupply += amount;
553         _balances[account] += amount;
554         emit Transfer(address(0), account, amount);
555 
556         _afterTokenTransfer(address(0), account, amount);
557     }
558 
559     /**
560      * @dev Destroys `amount` tokens from `account`, reducing the
561      * total supply.
562      *
563      * Emits a {Transfer} event with `to` set to the zero address.
564      *
565      * Requirements:
566      *
567      * - `account` cannot be the zero address.
568      * - `account` must have at least `amount` tokens.
569      */
570     function _burn(address account, uint256 amount) internal virtual {
571         require(account != address(0), "ERC20: burn from the zero address");
572 
573         _beforeTokenTransfer(account, address(0), amount);
574 
575         uint256 accountBalance = _balances[account];
576         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
577         unchecked {
578             _balances[account] = accountBalance - amount;
579         }
580         _totalSupply -= amount;
581 
582         emit Transfer(account, address(0), amount);
583 
584         _afterTokenTransfer(account, address(0), amount);
585     }
586 
587     /**
588      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
589      *
590      * This internal function is equivalent to `approve`, and can be used to
591      * e.g. set automatic allowances for certain subsystems, etc.
592      *
593      * Emits an {Approval} event.
594      *
595      * Requirements:
596      *
597      * - `owner` cannot be the zero address.
598      * - `spender` cannot be the zero address.
599      */
600     function _approve(
601         address owner,
602         address spender,
603         uint256 amount
604     ) internal virtual {
605         require(owner != address(0), "ERC20: approve from the zero address");
606         require(spender != address(0), "ERC20: approve to the zero address");
607 
608         _allowances[owner][spender] = amount;
609         emit Approval(owner, spender, amount);
610     }
611 
612     /**
613      * @dev Hook that is called before any transfer of tokens. This includes
614      * minting and burning.
615      *
616      * Calling conditions:
617      *
618      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
619      * will be transferred to `to`.
620      * - when `from` is zero, `amount` tokens will be minted for `to`.
621      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
622      * - `from` and `to` are never both zero.
623      *
624      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
625      */
626     function _beforeTokenTransfer(
627         address from,
628         address to,
629         uint256 amount
630     ) internal virtual {}
631 
632     /**
633      * @dev Hook that is called after any transfer of tokens. This includes
634      * minting and burning.
635      *
636      * Calling conditions:
637      *
638      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
639      * has been transferred to `to`.
640      * - when `from` is zero, `amount` tokens have been minted for `to`.
641      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
642      * - `from` and `to` are never both zero.
643      *
644      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
645      */
646     function _afterTokenTransfer(
647         address from,
648         address to,
649         uint256 amount
650     ) internal virtual {}
651 }
652 
653 // CAUTION
654 // This version of SafeMath should only be used with Solidity 0.8 or later,
655 // because it relies on the compiler's built in overflow checks.
656 
657 /**
658  * @dev Wrappers over Solidity's arithmetic operations.
659  *
660  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
661  * now has built in overflow checking.
662  */
663 library SafeMath {
664     /**
665      * @dev Returns the addition of two unsigned integers, with an overflow flag.
666      *
667      * _Available since v3.4._
668      */
669     function tryAdd(uint256 a, uint256 b)
670         internal
671         pure
672         returns (bool, uint256)
673     {
674         unchecked {
675             uint256 c = a + b;
676             if (c < a) return (false, 0);
677             return (true, c);
678         }
679     }
680 
681     /**
682      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
683      *
684      * _Available since v3.4._
685      */
686     function trySub(uint256 a, uint256 b)
687         internal
688         pure
689         returns (bool, uint256)
690     {
691         unchecked {
692             if (b > a) return (false, 0);
693             return (true, a - b);
694         }
695     }
696 
697     /**
698      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
699      *
700      * _Available since v3.4._
701      */
702     function tryMul(uint256 a, uint256 b)
703         internal
704         pure
705         returns (bool, uint256)
706     {
707         unchecked {
708             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
709             // benefit is lost if 'b' is also tested.
710             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
711             if (a == 0) return (true, 0);
712             uint256 c = a * b;
713             if (c / a != b) return (false, 0);
714             return (true, c);
715         }
716     }
717 
718     /**
719      * @dev Returns the division of two unsigned integers, with a division by zero flag.
720      *
721      * _Available since v3.4._
722      */
723     function tryDiv(uint256 a, uint256 b)
724         internal
725         pure
726         returns (bool, uint256)
727     {
728         unchecked {
729             if (b == 0) return (false, 0);
730             return (true, a / b);
731         }
732     }
733 
734     /**
735      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
736      *
737      * _Available since v3.4._
738      */
739     function tryMod(uint256 a, uint256 b)
740         internal
741         pure
742         returns (bool, uint256)
743     {
744         unchecked {
745             if (b == 0) return (false, 0);
746             return (true, a % b);
747         }
748     }
749 
750     /**
751      * @dev Returns the addition of two unsigned integers, reverting on
752      * overflow.
753      *
754      * Counterpart to Solidity's `+` operator.
755      *
756      * Requirements:
757      *
758      * - Addition cannot overflow.
759      */
760     function add(uint256 a, uint256 b) internal pure returns (uint256) {
761         return a + b;
762     }
763 
764     /**
765      * @dev Returns the subtraction of two unsigned integers, reverting on
766      * overflow (when the result is negative).
767      *
768      * Counterpart to Solidity's `-` operator.
769      *
770      * Requirements:
771      *
772      * - Subtraction cannot overflow.
773      */
774     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
775         return a - b;
776     }
777 
778     /**
779      * @dev Returns the multiplication of two unsigned integers, reverting on
780      * overflow.
781      *
782      * Counterpart to Solidity's `*` operator.
783      *
784      * Requirements:
785      *
786      * - Multiplication cannot overflow.
787      */
788     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
789         return a * b;
790     }
791 
792     /**
793      * @dev Returns the integer division of two unsigned integers, reverting on
794      * division by zero. The result is rounded towards zero.
795      *
796      * Counterpart to Solidity's `/` operator.
797      *
798      * Requirements:
799      *
800      * - The divisor cannot be zero.
801      */
802     function div(uint256 a, uint256 b) internal pure returns (uint256) {
803         return a / b;
804     }
805 
806     /**
807      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
808      * reverting when dividing by zero.
809      *
810      * Counterpart to Solidity's `%` operator. This function uses a `revert`
811      * opcode (which leaves remaining gas untouched) while Solidity uses an
812      * invalid opcode to revert (consuming all remaining gas).
813      *
814      * Requirements:
815      *
816      * - The divisor cannot be zero.
817      */
818     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
819         return a % b;
820     }
821 
822     /**
823      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
824      * overflow (when the result is negative).
825      *
826      * CAUTION: This function is deprecated because it requires allocating memory for the error
827      * message unnecessarily. For custom revert reasons use {trySub}.
828      *
829      * Counterpart to Solidity's `-` operator.
830      *
831      * Requirements:
832      *
833      * - Subtraction cannot overflow.
834      */
835     function sub(
836         uint256 a,
837         uint256 b,
838         string memory errorMessage
839     ) internal pure returns (uint256) {
840         unchecked {
841             require(b <= a, errorMessage);
842             return a - b;
843         }
844     }
845 
846     /**
847      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
848      * division by zero. The result is rounded towards zero.
849      *
850      * Counterpart to Solidity's `/` operator. Note: this function uses a
851      * `revert` opcode (which leaves remaining gas untouched) while Solidity
852      * uses an invalid opcode to revert (consuming all remaining gas).
853      *
854      * Requirements:
855      *
856      * - The divisor cannot be zero.
857      */
858     function div(
859         uint256 a,
860         uint256 b,
861         string memory errorMessage
862     ) internal pure returns (uint256) {
863         unchecked {
864             require(b > 0, errorMessage);
865             return a / b;
866         }
867     }
868 
869     /**
870      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
871      * reverting with custom message when dividing by zero.
872      *
873      * CAUTION: This function is deprecated because it requires allocating memory for the error
874      * message unnecessarily. For custom revert reasons use {tryMod}.
875      *
876      * Counterpart to Solidity's `%` operator. This function uses a `revert`
877      * opcode (which leaves remaining gas untouched) while Solidity uses an
878      * invalid opcode to revert (consuming all remaining gas).
879      *
880      * Requirements:
881      *
882      * - The divisor cannot be zero.
883      */
884     function mod(
885         uint256 a,
886         uint256 b,
887         string memory errorMessage
888     ) internal pure returns (uint256) {
889         unchecked {
890             require(b > 0, errorMessage);
891             return a % b;
892         }
893     }
894 }
895 
896 contract MWS is ERC20, Ownable {
897     using SafeMath for uint256;
898 
899     IUniswapV2Router02 public immutable uniswapV2Router;
900     address public uniswapV2Pair;
901     address public constant deadAddress = address(0xdead);
902 
903     bool private swapping;
904 
905     address public marketingWallet;
906     address public devWallet;
907 
908     uint256 public maxTransactionAmount;
909     uint256 public swapTokensAtAmount;
910     uint256 public maxWallet;
911 
912     uint256 public percentForLPBurn = 0; // 0 = 0%
913     bool public lpBurnEnabled = true;
914     uint256 public lpBurnFrequency = 36000000 seconds;
915     uint256 public lastLpBurnTime;
916 
917     uint256 public manualBurnFrequency = 30000 minutes;
918     uint256 public lastManualLpBurnTime;
919 
920     bool public limitsInEffect = true;
921     bool public tradingActive = false;
922     bool public swapEnabled = false;
923 
924     // Anti-bot and anti-whale mappings and variables
925     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
926     bool public transferDelayEnabled = true;
927 
928     uint256 public buyTotalFees;
929     uint256 public constant buyMarketingFee = 1;
930     uint256 public constant buyLiquidityFee = 2;
931     uint256 public constant buyDevFee = 0;
932 
933     uint256 public sellTotalFees;
934     uint256 public constant sellMarketingFee = 3;
935     uint256 public constant sellLiquidityFee = 2;
936     uint256 public constant sellDevFee = 0;
937 
938     uint256 public tokensForMarketing;
939     uint256 public tokensForLiquidity;
940     uint256 public tokensForDev;
941 
942     /******************/
943 
944     // exlcude from fees and max transaction amount
945     mapping(address => bool) private _isExcludedFromFees;
946     mapping(address => bool) public _isExcludedMaxTransactionAmount;
947 
948     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
949     // could be subject to a maximum transfer amount
950     mapping(address => bool) public automatedMarketMakerPairs;
951 
952     event UpdateUniswapV2Router(
953         address indexed newAddress,
954         address indexed oldAddress
955     );
956 
957     event ExcludeFromFees(address indexed account, bool isExcluded);
958 
959     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
960 
961     event marketingWalletUpdated(
962         address indexed newWallet,
963         address indexed oldWallet
964     );
965 
966     event devWalletUpdated(
967         address indexed newWallet,
968         address indexed oldWallet
969     );
970 
971     event SwapAndLiquify(
972         uint256 tokensSwapped,
973         uint256 ethReceived,
974         uint256 tokensIntoLiquidity
975     );
976 
977     event AutoNukeLP();
978 
979     event ManualNukeLP();
980 
981     event BoughtEarly(address indexed sniper);
982 
983     constructor() ERC20("The Madoff Ponzi", "MWS") {
984         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
985             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
986         );
987 
988         excludeFromMaxTransaction(address(_uniswapV2Router), true);
989         uniswapV2Router = _uniswapV2Router;
990 
991         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
992             .createPair(address(this), _uniswapV2Router.WETH());
993         excludeFromMaxTransaction(address(uniswapV2Pair), true);
994         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
995 
996         uint256 totalSupply = 1_000_000_000 * 1e18; // 1 billion total supply
997 
998         maxTransactionAmount = 20_000_000 * 1e18; //2% from total supply maxTransactionAmountTxn
999         maxWallet = 20_000_000 * 1e18; // 2% from total supply maxWallet
1000         swapTokensAtAmount = (totalSupply * 3) / 10000; // 0.03% swap wallet
1001 
1002         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1003         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1004 
1005         marketingWallet = address(0x6EcFA264B6E64704f0B9D159977E9cF711aC3aa0); // set as madoff fund
1006         devWallet = address(0x5ea4FC4B9789637960098B51A6602e83587E64ef); // set as dev wallet
1007 
1008         // exclude from paying fees or having max transaction amount
1009         excludeFromFees(owner(), true);
1010         excludeFromFees(address(0x6EcFA264B6E64704f0B9D159977E9cF711aC3aa0), true);
1011         excludeFromFees(address(0xdead), true);
1012 
1013         excludeFromMaxTransaction(owner(), true);
1014         excludeFromMaxTransaction(address(0x6EcFA264B6E64704f0B9D159977E9cF711aC3aa0), true);
1015         excludeFromMaxTransaction(address(0xdead), true);
1016 
1017         /*
1018             _mint is an internal function in ERC20.sol that is only called here,
1019             and CANNOT be called ever again
1020         */
1021         _mint(msg.sender, totalSupply);
1022     }
1023 
1024     receive() external payable {}
1025 
1026     // once enabled, can never be turned off
1027     function startTrading() external onlyOwner {
1028         tradingActive = true;
1029         swapEnabled = true;
1030         lastLpBurnTime = block.timestamp;
1031     }
1032 
1033     // remove limits after token is stable
1034     function removeLimits() external onlyOwner returns (bool) {
1035         limitsInEffect = false;
1036         return true;
1037     }
1038 
1039     // disable Transfer delay - cannot be reenabled
1040     function disableTransferDelay() external onlyOwner returns (bool) {
1041         transferDelayEnabled = false;
1042         return true;
1043     }
1044 
1045     // change the minimum amount of tokens to sell from fees
1046     function updateSwapTokensAtAmount(uint256 newAmount)
1047         external
1048         onlyOwner
1049         returns (bool)
1050     {
1051         require(
1052             newAmount >= (totalSupply() * 1) / 100000,
1053             "Swap amount cannot be lower than 0.001% total supply."
1054         );
1055         require(
1056             newAmount <= (totalSupply() * 5) / 1000,
1057             "Swap amount cannot be higher than 0.5% total supply."
1058         );
1059         swapTokensAtAmount = newAmount;
1060         return true;
1061     }
1062 
1063     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1064         require(
1065             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1066             "Cannot set maxTransactionAmount lower than 0.1%"
1067         );
1068         maxTransactionAmount = newNum * (10**18);
1069     }
1070 
1071     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1072         require(
1073             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1074             "Cannot set maxWallet lower than 0.5%"
1075         );
1076         maxWallet = newNum * (10**18);
1077     }
1078 
1079     function excludeFromMaxTransaction(address updAds, bool isEx)
1080         public
1081         onlyOwner
1082     {
1083         _isExcludedMaxTransactionAmount[updAds] = isEx;
1084     }
1085 
1086     // only use to disable contract sales if absolutely necessary (emergency use only)
1087     function updateSwapEnabled(bool enabled) external onlyOwner {
1088         swapEnabled = enabled;
1089     }
1090 
1091     function excludeFromFees(address account, bool excluded) public onlyOwner {
1092         _isExcludedFromFees[account] = excluded;
1093         emit ExcludeFromFees(account, excluded);
1094     }
1095 
1096     function setAutomatedMarketMakerPair(address pair, bool value)
1097         public
1098         onlyOwner
1099     {
1100         require(
1101             pair != uniswapV2Pair,
1102             "The pair cannot be removed from automatedMarketMakerPairs"
1103         );
1104 
1105         _setAutomatedMarketMakerPair(pair, value);
1106     }
1107 
1108     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1109         automatedMarketMakerPairs[pair] = value;
1110 
1111         emit SetAutomatedMarketMakerPair(pair, value);
1112     }
1113 
1114     function updateMarketingWallet(address newMarketingWallet)
1115         external
1116         onlyOwner
1117     {
1118         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1119         marketingWallet = newMarketingWallet;
1120     }
1121 
1122     function updateDevWallet(address newWallet) external onlyOwner {
1123         emit devWalletUpdated(newWallet, devWallet);
1124         devWallet = newWallet;
1125     }
1126 
1127     function isExcludedFromFees(address account) public view returns (bool) {
1128         return _isExcludedFromFees[account];
1129     }
1130 
1131     function _transfer(
1132         address from,
1133         address to,
1134         uint256 amount
1135     ) internal override {
1136         require(from != address(0), "ERC20: transfer from the zero address");
1137         require(to != address(0), "ERC20: transfer to the zero address");
1138 
1139         if (amount == 0) {
1140             super._transfer(from, to, 0);
1141             return;
1142         }
1143 
1144         if (limitsInEffect) {
1145             if (
1146                 from != owner() &&
1147                 to != owner() &&
1148                 to != address(0) &&
1149                 to != address(0xdead) &&
1150                 !swapping
1151             ) {
1152                 if (!tradingActive) {
1153                     require(
1154                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1155                         "Trading is not active."
1156                     );
1157                 }
1158 
1159                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1160                 if (transferDelayEnabled) {
1161                     if (
1162                         to != owner() &&
1163                         to != address(uniswapV2Router) &&
1164                         to != address(uniswapV2Pair)
1165                     ) {
1166                         require(
1167                             _holderLastTransferTimestamp[tx.origin] <
1168                                 block.number,
1169                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1170                         );
1171                         _holderLastTransferTimestamp[tx.origin] = block.number;
1172                     }
1173                 }
1174 
1175                 //when buy
1176                 if (
1177                     automatedMarketMakerPairs[from] &&
1178                     !_isExcludedMaxTransactionAmount[to]
1179                 ) {
1180                     require(
1181                         amount <= maxTransactionAmount,
1182                         "Buy transfer amount exceeds the maxTransactionAmount."
1183                     );
1184                     require(
1185                         amount + balanceOf(to) <= maxWallet,
1186                         "Max wallet exceeded"
1187                     );
1188                 }
1189                 //when sell
1190                 else if (
1191                     automatedMarketMakerPairs[to] &&
1192                     !_isExcludedMaxTransactionAmount[from]
1193                 ) {
1194                     require(
1195                         amount <= maxTransactionAmount,
1196                         "Sell transfer amount exceeds the maxTransactionAmount."
1197                     );
1198                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1199                     require(
1200                         amount + balanceOf(to) <= maxWallet,
1201                         "Max wallet exceeded"
1202                     );
1203                 }
1204             }
1205         }
1206 
1207         uint256 contractTokenBalance = balanceOf(address(this));
1208 
1209         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1210 
1211         if (
1212             canSwap &&
1213             swapEnabled &&
1214             !swapping &&
1215             !automatedMarketMakerPairs[from] &&
1216             !_isExcludedFromFees[from] &&
1217             !_isExcludedFromFees[to]
1218         ) {
1219             swapping = true;
1220 
1221             swapBack();
1222 
1223             swapping = false;
1224         }
1225 
1226         if (
1227             !swapping &&
1228             automatedMarketMakerPairs[to] &&
1229             lpBurnEnabled &&
1230             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1231             !_isExcludedFromFees[from]
1232         ) {
1233             autoBurnLiquidityPairTokens();
1234         }
1235 
1236         bool takeFee = !swapping;
1237 
1238         // if any account belongs to _isExcludedFromFee account then remove the fee
1239         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1240             takeFee = false;
1241         }
1242 
1243         uint256 fees = 0;
1244         // only take fees on buys/sells, do not take on wallet transfers
1245         if (takeFee) {
1246             // on sell
1247             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1248                 fees = amount.mul(sellTotalFees).div(100);
1249                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1250                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1251                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1252             }
1253             // on buy
1254             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1255                 fees = amount.mul(buyTotalFees).div(100);
1256                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1257                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1258                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1259             }
1260 
1261             if (fees > 0) {
1262                 super._transfer(from, address(this), fees);
1263             }
1264 
1265             amount -= fees;
1266         }
1267 
1268         super._transfer(from, to, amount);
1269     }
1270 
1271     function swapTokensForEth(uint256 tokenAmount) private {
1272         // generate the uniswap pair path of token -> weth
1273         address[] memory path = new address[](2);
1274         path[0] = address(this);
1275         path[1] = uniswapV2Router.WETH();
1276 
1277         _approve(address(this), address(uniswapV2Router), tokenAmount);
1278 
1279         // make the swap
1280         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1281             tokenAmount,
1282             0, // accept any amount of ETH
1283             path,
1284             address(this),
1285             block.timestamp
1286         );
1287     }
1288 
1289     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1290         // approve token transfer to cover all possible scenarios
1291         _approve(address(this), address(uniswapV2Router), tokenAmount);
1292 
1293         // add the liquidity
1294         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1295             address(this),
1296             tokenAmount,
1297             0, // slippage is unavoidable
1298             0, // slippage is unavoidable
1299             deadAddress,
1300             block.timestamp
1301         );
1302     }
1303 
1304     function swapBack() private {
1305         uint256 contractBalance = balanceOf(address(this));
1306         uint256 totalTokensToSwap = tokensForLiquidity +
1307             tokensForMarketing +
1308             tokensForDev;
1309         bool success;
1310 
1311         if (contractBalance == 0 || totalTokensToSwap == 0) {
1312             return;
1313         }
1314 
1315         if (contractBalance > swapTokensAtAmount * 20) {
1316             contractBalance = swapTokensAtAmount * 20;
1317         }
1318 
1319         // Halve the amount of liquidity tokens
1320         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1321             totalTokensToSwap /
1322             2;
1323         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1324 
1325         uint256 initialETHBalance = address(this).balance;
1326 
1327         swapTokensForEth(amountToSwapForETH);
1328 
1329         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1330 
1331         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1332             totalTokensToSwap
1333         );
1334         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1335 
1336         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1337 
1338         tokensForLiquidity = 0;
1339         tokensForMarketing = 0;
1340         tokensForDev = 0;
1341 
1342         (success, ) = address(devWallet).call{value: ethForDev}("");
1343 
1344         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1345             addLiquidity(liquidityTokens, ethForLiquidity);
1346             emit SwapAndLiquify(
1347                 amountToSwapForETH,
1348                 ethForLiquidity,
1349                 tokensForLiquidity
1350             );
1351         }
1352 
1353         (success, ) = address(marketingWallet).call{
1354             value: address(this).balance
1355         }("");
1356     }
1357 
1358     function setAutoLPBurnSettings(
1359         uint256 _frequencyInSeconds,
1360         uint256 _percent,
1361         bool _Enabled
1362     ) external onlyOwner {
1363         require(
1364             _frequencyInSeconds >= 600,
1365             "cannot set buyback more often than every 10 minutes"
1366         );
1367         require(
1368             _percent <= 1000 && _percent >= 0,
1369             "Must set auto LP burn percent between 0% and 10%"
1370         );
1371         lpBurnFrequency = _frequencyInSeconds;
1372         percentForLPBurn = _percent;
1373         lpBurnEnabled = _Enabled;
1374     }
1375 
1376     function autoBurnLiquidityPairTokens() internal returns (bool) {
1377         lastLpBurnTime = block.timestamp;
1378 
1379         // get balance of liquidity pair
1380         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1381 
1382         // calculate amount to burn
1383         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1384             10000
1385         );
1386 
1387         // pull tokens from pancakePair liquidity and move to dead address permanently
1388         if (amountToBurn > 0) {
1389             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1390         }
1391 
1392         //sync price since this is not in a swap transaction!
1393         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1394         pair.sync();
1395         emit AutoNukeLP();
1396         return true;
1397     }
1398 
1399     function manualBurnLiquidityPairTokens(uint256 percent)
1400         external
1401         onlyOwner
1402         returns (bool)
1403     {
1404         require(
1405             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1406             "Must wait for cooldown to finish"
1407         );
1408         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1409         lastManualLpBurnTime = block.timestamp;
1410 
1411         // get balance of liquidity pair
1412         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1413 
1414         // calculate amount to burn
1415         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1416 
1417         // pull tokens from pancakePair liquidity and move to dead address permanently
1418         if (amountToBurn > 0) {
1419             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1420         }
1421 
1422         //sync price since this is not in a swap transaction!
1423         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1424         pair.sync();
1425         emit ManualNukeLP();
1426         return true;
1427     }
1428 }