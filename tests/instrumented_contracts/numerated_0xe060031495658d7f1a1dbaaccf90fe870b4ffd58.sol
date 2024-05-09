1 // telegram : https://t.me/EverythingAppERC
2 
3 
4 /**
5  * SPDX-License-Identifier: MIT
6  */
7 pragma solidity =0.8.16;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes calldata) {
15         return msg.data;
16     }
17 }
18 
19 abstract contract Ownable is Context {
20     address private _owner;
21 
22     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
23 
24     /**
25      * @dev Initializes the contract setting the deployer as the initial owner.
26      */
27     constructor() {
28         _transferOwnership(_msgSender());
29     }
30 
31     /**
32      * @dev Returns the address of the current owner.
33      */
34     function owner() public view virtual returns (address) {
35         return _owner;
36     }
37 
38     /**
39      * @dev Throws if called by any account other than the owner.
40      */
41     modifier onlyOwner() {
42         require(owner() == _msgSender(), "Ownable: caller is not the owner");
43         _;
44     }
45 
46     /**
47      * @dev Leaves the contract without owner. It will not be possible to call
48      * `onlyOwner` functions anymore. Can only be called by the current owner.
49      *
50      * NOTE: Renouncing ownership will leave the contract without an owner,
51      * thereby removing any functionality that is only available to the owner.
52      */
53     function renounceOwnership() public virtual onlyOwner {
54         _transferOwnership(address(0));
55     }
56 
57     /**
58      * @dev Transfers ownership of the contract to a new account (`newOwner`).
59      * Can only be called by the current owner.
60      */
61     function transferOwnership(address newOwner) public virtual onlyOwner {
62         require(newOwner != address(0), "Ownable: new owner is the zero address");
63         _transferOwnership(newOwner);
64     }
65 
66     /**
67      * @dev Transfers ownership of the contract to a new account (`newOwner`).
68      * Internal function without access restriction.
69      */
70     function _transferOwnership(address newOwner) internal virtual {
71         address oldOwner = _owner;
72         _owner = newOwner;
73         emit OwnershipTransferred(oldOwner, newOwner);
74     }
75 }
76 
77 interface IERC20 {
78     /**
79      * @dev Returns the amount of tokens in existence.
80      */
81     function totalSupply() external view returns (uint256);
82 
83     /**
84      * @dev Returns the amount of tokens owned by `account`.
85      */
86     function balanceOf(address account) external view returns (uint256);
87 
88     /**
89      * @dev Moves `amount` tokens from the caller's account to `recipient`.
90      *
91      * Returns a boolean value indicating whether the operation succeeded.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transfer(address recipient, uint256 amount) external returns (bool);
96 
97     /**
98      * @dev Returns the remaining number of tokens that `spender` will be
99      * allowed to spend on behalf of `owner` through {transferFrom}. This is
100      * zero by default.
101      *
102      * This value changes when {approve} or {transferFrom} are called.
103      */
104     function allowance(address owner, address spender) external view returns (uint256);
105 
106     /**
107      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
108      *
109      * Returns a boolean value indicating whether the operation succeeded.
110      *
111      * IMPORTANT: Beware that changing an allowance with this method brings the risk
112      * that someone may use both the old and the new allowance by unfortunate
113      * transaction ordering. One possible solution to mitigate this race
114      * condition is to first reduce the spender's allowance to 0 and set the
115      * desired value afterwards:
116      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
117      *
118      * Emits an {Approval} event.
119      */
120     function approve(address spender, uint256 amount) external returns (bool);
121 
122     /**
123      * @dev Moves `amount` tokens from `sender` to `recipient` using the
124      * allowance mechanism. `amount` is then deducted from the caller's
125      * allowance.
126      *
127      * Returns a boolean value indicating whether the operation succeeded.
128      *
129      * Emits a {Transfer} event.
130      */
131     function transferFrom(
132         address sender,
133         address recipient,
134         uint256 amount
135     ) external returns (bool);
136 
137     /**
138      * @dev Emitted when `value` tokens are moved from one account (`from`) to
139      * another (`to`).
140      *
141      * Note that `value` may be zero.
142      */
143     event Transfer(address indexed from, address indexed to, uint256 value);
144 
145     /**
146      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
147      * a call to {approve}. `value` is the new allowance.
148      */
149     event Approval(address indexed owner, address indexed spender, uint256 value);
150 }
151 
152 interface IERC20Metadata is IERC20 {
153     /**
154      * @dev Returns the name of the token.
155      */
156     function name() external view returns (string memory);
157 
158     /**
159      * @dev Returns the symbol of the token.
160      */
161     function symbol() external view returns (string memory);
162 
163     /**
164      * @dev Returns the decimals places of the token.
165      */
166     function decimals() external view returns (uint8);
167 }
168 
169 contract ERC20 is Context, IERC20, IERC20Metadata {
170     mapping(address => uint256) private _balances;
171 
172     mapping(address => mapping(address => uint256)) private _allowances;
173 
174     uint256 private _totalSupply;
175 
176     string private _name;
177     string private _symbol;
178 
179     /**
180      * @dev Sets the values for {name} and {symbol}.
181      *
182      * The default value of {decimals} is 18. To select a different value for
183      * {decimals} you should overload it.
184      *
185      * All two of these values are immutable: they can only be set once during
186      * construction.
187      */
188     constructor(string memory name_, string memory symbol_) {
189         _name = name_;
190         _symbol = symbol_;
191     }
192 
193     /**
194      * @dev Returns the name of the token.
195      */
196     function name() public view virtual override returns (string memory) {
197         return _name;
198     }
199 
200     /**
201      * @dev Returns the symbol of the token, usually a shorter version of the
202      * name.
203      */
204     function symbol() public view virtual override returns (string memory) {
205         return _symbol;
206     }
207 
208     /**
209      * @dev Returns the number of decimals used to get its user representation.
210      * For example, if `decimals` equals `2`, a balance of `505` tokens should
211      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
212      *
213      * Tokens usually opt for a value of 18, imitating the relationship between
214      * Ether and Wei. This is the value {ERC20} uses, unless this function is
215      * overridden;
216      *
217      * NOTE: This information is only used for _display_ purposes: it in
218      * no way affects any of the arithmetic of the contract, including
219      * {IERC20-balanceOf} and {IERC20-transfer}.
220      */
221     function decimals() public view virtual override returns (uint8) {
222         return 18;
223     }
224 
225     /**
226      * @dev See {IERC20-totalSupply}.
227      */
228     function totalSupply() public view virtual override returns (uint256) {
229         return _totalSupply;
230     }
231 
232     /**
233      * @dev See {IERC20-balanceOf}.
234      */
235     function balanceOf(address account) public view virtual override returns (uint256) {
236         return _balances[account];
237     }
238 
239     /**
240      * @dev See {IERC20-transfer}.
241      *
242      * Requirements:
243      *
244      * - `recipient` cannot be the zero address.
245      * - the caller must have a balance of at least `amount`.
246      */
247     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
248         _transfer(_msgSender(), recipient, amount);
249         return true;
250     }
251 
252     /**
253      * @dev See {IERC20-allowance}.
254      */
255     function allowance(address owner, address spender) public view virtual override returns (uint256) {
256         return _allowances[owner][spender];
257     }
258 
259     /**
260      * @dev See {IERC20-approve}.
261      *
262      * Requirements:
263      *
264      * - `spender` cannot be the zero address.
265      */
266     function approve(address spender, uint256 amount) public virtual override returns (bool) {
267         _approve(_msgSender(), spender, amount);
268         return true;
269     }
270 
271     /**
272      * @dev See {IERC20-transferFrom}.
273      *
274      * Emits an {Approval} event indicating the updated allowance. This is not
275      * required by the EIP. See the note at the beginning of {ERC20}.
276      *
277      * Requirements:
278      *
279      * - `sender` and `recipient` cannot be the zero address.
280      * - `sender` must have a balance of at least `amount`.
281      * - the caller must have allowance for ``sender``'s tokens of at least
282      * `amount`.
283      */
284     function transferFrom(
285         address sender,
286         address recipient,
287         uint256 amount
288     ) public virtual override returns (bool) {
289         _transfer(sender, recipient, amount);
290 
291         uint256 currentAllowance = _allowances[sender][_msgSender()];
292         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
293         unchecked {
294             _approve(sender, _msgSender(), currentAllowance - amount);
295         }
296 
297         return true;
298     }
299 
300     /**
301      * @dev Atomically increases the allowance granted to `spender` by the caller.
302      *
303      * This is an alternative to {approve} that can be used as a mitigation for
304      * problems described in {IERC20-approve}.
305      *
306      * Emits an {Approval} event indicating the updated allowance.
307      *
308      * Requirements:
309      *
310      * - `spender` cannot be the zero address.
311      */
312     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
313         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
314         return true;
315     }
316 
317     /**
318      * @dev Atomically decreases the allowance granted to `spender` by the caller.
319      *
320      * This is an alternative to {approve} that can be used as a mitigation for
321      * problems described in {IERC20-approve}.
322      *
323      * Emits an {Approval} event indicating the updated allowance.
324      *
325      * Requirements:
326      *
327      * - `spender` cannot be the zero address.
328      * - `spender` must have allowance for the caller of at least
329      * `subtractedValue`.
330      */
331     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
332         uint256 currentAllowance = _allowances[_msgSender()][spender];
333         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
334         unchecked {
335             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
336         }
337 
338         return true;
339     }
340 
341     /**
342      * @dev Moves `amount` of tokens from `sender` to `recipient`.
343      *
344      * This internal function is equivalent to {transfer}, and can be used to
345      * e.g. implement automatic token fees, slashing mechanisms, etc.
346      *
347      * Emits a {Transfer} event.
348      *
349      * Requirements:
350      *
351      * - `sender` cannot be the zero address.
352      * - `recipient` cannot be the zero address.
353      * - `sender` must have a balance of at least `amount`.
354      */
355     function _transfer(
356         address sender,
357         address recipient,
358         uint256 amount
359     ) internal virtual {
360         require(sender != address(0), "ERC20: transfer from the zero address");
361         require(recipient != address(0), "ERC20: transfer to the zero address");
362 
363         _beforeTokenTransfer(sender, recipient, amount);
364 
365         uint256 senderBalance = _balances[sender];
366         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
367         unchecked {
368             _balances[sender] = senderBalance - amount;
369         }
370         _balances[recipient] += amount;
371 
372         emit Transfer(sender, recipient, amount);
373 
374         _afterTokenTransfer(sender, recipient, amount);
375     }
376 
377     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
378      * the total supply.
379      *
380      * Emits a {Transfer} event with `from` set to the zero address.
381      *
382      * Requirements:
383      *
384      * - `account` cannot be the zero address.
385      */
386     function _mint(address account, uint256 amount) internal virtual {
387         require(account != address(0), "ERC20: mint to the zero address");
388 
389         _beforeTokenTransfer(address(0), account, amount);
390 
391         _totalSupply += amount;
392         _balances[account] += amount;
393         emit Transfer(address(0), account, amount);
394 
395         _afterTokenTransfer(address(0), account, amount);
396     }
397 
398     /**
399      * @dev Destroys `amount` tokens from `account`, reducing the
400      * total supply.
401      *
402      * Emits a {Transfer} event with `to` set to the zero address.
403      *
404      * Requirements:
405      *
406      * - `account` cannot be the zero address.
407      * - `account` must have at least `amount` tokens.
408      */
409     function _burn(address account, uint256 amount) internal virtual {
410         require(account != address(0), "ERC20: burn from the zero address");
411 
412         _beforeTokenTransfer(account, address(0), amount);
413 
414         uint256 accountBalance = _balances[account];
415         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
416         unchecked {
417             _balances[account] = accountBalance - amount;
418         }
419         _totalSupply -= amount;
420 
421         emit Transfer(account, address(0), amount);
422 
423         _afterTokenTransfer(account, address(0), amount);
424     }
425 
426     /**
427      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
428      *
429      * This internal function is equivalent to `approve`, and can be used to
430      * e.g. set automatic allowances for certain subsystems, etc.
431      *
432      * Emits an {Approval} event.
433      *
434      * Requirements:
435      *
436      * - `owner` cannot be the zero address.
437      * - `spender` cannot be the zero address.
438      */
439     function _approve(
440         address owner,
441         address spender,
442         uint256 amount
443     ) internal virtual {
444         require(owner != address(0), "ERC20: approve from the zero address");
445         require(spender != address(0), "ERC20: approve to the zero address");
446 
447         _allowances[owner][spender] = amount;
448         emit Approval(owner, spender, amount);
449     }
450 
451     /**
452      * @dev Hook that is called before any transfer of tokens. This includes
453      * minting and burning.
454      *
455      * Calling conditions:
456      *
457      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
458      * will be transferred to `to`.
459      * - when `from` is zero, `amount` tokens will be minted for `to`.
460      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
461      * - `from` and `to` are never both zero.
462      *
463      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
464      */
465     function _beforeTokenTransfer(
466         address from,
467         address to,
468         uint256 amount
469     ) internal virtual {}
470 
471     /**
472      * @dev Hook that is called after any transfer of tokens. This includes
473      * minting and burning.
474      *
475      * Calling conditions:
476      *
477      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
478      * has been transferred to `to`.
479      * - when `from` is zero, `amount` tokens have been minted for `to`.
480      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
481      * - `from` and `to` are never both zero.
482      *
483      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
484      */
485     function _afterTokenTransfer(
486         address from,
487         address to,
488         uint256 amount
489     ) internal virtual {}
490 }
491 
492 library SafeMath {
493     /**
494      * @dev Returns the addition of two unsigned integers, with an overflow flag.
495      *
496      * _Available since v3.4._
497      */
498     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
499         unchecked {
500             uint256 c = a + b;
501             if (c < a) return (false, 0);
502             return (true, c);
503         }
504     }
505 
506     /**
507      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
508      *
509      * _Available since v3.4._
510      */
511     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
512         unchecked {
513             if (b > a) return (false, 0);
514             return (true, a - b);
515         }
516     }
517 
518     /**
519      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
520      *
521      * _Available since v3.4._
522      */
523     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
524         unchecked {
525             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
526             // benefit is lost if 'b' is also tested.
527             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
528             if (a == 0) return (true, 0);
529             uint256 c = a * b;
530             if (c / a != b) return (false, 0);
531             return (true, c);
532         }
533     }
534 
535     /**
536      * @dev Returns the division of two unsigned integers, with a division by zero flag.
537      *
538      * _Available since v3.4._
539      */
540     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
541         unchecked {
542             if (b == 0) return (false, 0);
543             return (true, a / b);
544         }
545     }
546 
547     /**
548      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
549      *
550      * _Available since v3.4._
551      */
552     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
553         unchecked {
554             if (b == 0) return (false, 0);
555             return (true, a % b);
556         }
557     }
558 
559     /**
560      * @dev Returns the addition of two unsigned integers, reverting on
561      * overflow.
562      *
563      * Counterpart to Solidity's `+` operator.
564      *
565      * Requirements:
566      *
567      * - Addition cannot overflow.
568      */
569     function add(uint256 a, uint256 b) internal pure returns (uint256) {
570         return a + b;
571     }
572 
573     /**
574      * @dev Returns the subtraction of two unsigned integers, reverting on
575      * overflow (when the result is negative).
576      *
577      * Counterpart to Solidity's `-` operator.
578      *
579      * Requirements:
580      *
581      * - Subtraction cannot overflow.
582      */
583     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
584         return a - b;
585     }
586 
587     /**
588      * @dev Returns the multiplication of two unsigned integers, reverting on
589      * overflow.
590      *
591      * Counterpart to Solidity's `*` operator.
592      *
593      * Requirements:
594      *
595      * - Multiplication cannot overflow.
596      */
597     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
598         return a * b;
599     }
600 
601     /**
602      * @dev Returns the integer division of two unsigned integers, reverting on
603      * division by zero. The result is rounded towards zero.
604      *
605      * Counterpart to Solidity's `/` operator.
606      *
607      * Requirements:
608      *
609      * - The divisor cannot be zero.
610      */
611     function div(uint256 a, uint256 b) internal pure returns (uint256) {
612         return a / b;
613     }
614 
615     /**
616      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
617      * reverting when dividing by zero.
618      *
619      * Counterpart to Solidity's `%` operator. This function uses a `revert`
620      * opcode (which leaves remaining gas untouched) while Solidity uses an
621      * invalid opcode to revert (consuming all remaining gas).
622      *
623      * Requirements:
624      *
625      * - The divisor cannot be zero.
626      */
627     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
628         return a % b;
629     }
630 
631     /**
632      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
633      * overflow (when the result is negative).
634      *
635      * CAUTION: This function is deprecated because it requires allocating memory for the error
636      * message unnecessarily. For custom revert reasons use {trySub}.
637      *
638      * Counterpart to Solidity's `-` operator.
639      *
640      * Requirements:
641      *
642      * - Subtraction cannot overflow.
643      */
644     function sub(
645         uint256 a,
646         uint256 b,
647         string memory errorMessage
648     ) internal pure returns (uint256) {
649         unchecked {
650             require(b <= a, errorMessage);
651             return a - b;
652         }
653     }
654 
655     /**
656      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
657      * division by zero. The result is rounded towards zero.
658      *
659      * Counterpart to Solidity's `/` operator. Note: this function uses a
660      * `revert` opcode (which leaves remaining gas untouched) while Solidity
661      * uses an invalid opcode to revert (consuming all remaining gas).
662      *
663      * Requirements:
664      *
665      * - The divisor cannot be zero.
666      */
667     function div(
668         uint256 a,
669         uint256 b,
670         string memory errorMessage
671     ) internal pure returns (uint256) {
672         unchecked {
673             require(b > 0, errorMessage);
674             return a / b;
675         }
676     }
677 
678     /**
679      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
680      * reverting with custom message when dividing by zero.
681      *
682      * CAUTION: This function is deprecated because it requires allocating memory for the error
683      * message unnecessarily. For custom revert reasons use {tryMod}.
684      *
685      * Counterpart to Solidity's `%` operator. This function uses a `revert`
686      * opcode (which leaves remaining gas untouched) while Solidity uses an
687      * invalid opcode to revert (consuming all remaining gas).
688      *
689      * Requirements:
690      *
691      * - The divisor cannot be zero.
692      */
693     function mod(
694         uint256 a,
695         uint256 b,
696         string memory errorMessage
697     ) internal pure returns (uint256) {
698         unchecked {
699             require(b > 0, errorMessage);
700             return a % b;
701         }
702     }
703 }
704 
705 interface IUniswapV2Factory {
706     event PairCreated(
707         address indexed token0,
708         address indexed token1,
709         address pair,
710         uint256
711     );
712 
713     function feeTo() external view returns (address);
714 
715     function feeToSetter() external view returns (address);
716 
717     function getPair(address tokenA, address tokenB)
718         external
719         view
720         returns (address pair);
721 
722     function allPairs(uint256) external view returns (address pair);
723 
724     function allPairsLength() external view returns (uint256);
725 
726     function createPair(address tokenA, address tokenB)
727         external
728         returns (address pair);
729 
730     function setFeeTo(address) external;
731 
732     function setFeeToSetter(address) external;
733 }
734 
735 interface IUniswapV2Pair {
736     event Approval(
737         address indexed owner,
738         address indexed spender,
739         uint256 value
740     );
741     event Transfer(address indexed from, address indexed to, uint256 value);
742 
743     function name() external pure returns (string memory);
744 
745     function symbol() external pure returns (string memory);
746 
747     function decimals() external pure returns (uint8);
748 
749     function totalSupply() external view returns (uint256);
750 
751     function balanceOf(address owner) external view returns (uint256);
752 
753     function allowance(address owner, address spender)
754         external
755         view
756         returns (uint256);
757 
758     function approve(address spender, uint256 value) external returns (bool);
759 
760     function transfer(address to, uint256 value) external returns (bool);
761 
762     function transferFrom(
763         address from,
764         address to,
765         uint256 value
766     ) external returns (bool);
767 
768     function DOMAIN_SEPARATOR() external view returns (bytes32);
769 
770     function PERMIT_TYPEHASH() external pure returns (bytes32);
771 
772     function nonces(address owner) external view returns (uint256);
773 
774     function permit(
775         address owner,
776         address spender,
777         uint256 value,
778         uint256 deadline,
779         uint8 v,
780         bytes32 r,
781         bytes32 s
782     ) external;
783 
784     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
785     event Burn(
786         address indexed sender,
787         uint256 amount0,
788         uint256 amount1,
789         address indexed to
790     );
791     event Swap(
792         address indexed sender,
793         uint256 amount0In,
794         uint256 amount1In,
795         uint256 amount0Out,
796         uint256 amount1Out,
797         address indexed to
798     );
799     event Sync(uint112 reserve0, uint112 reserve1);
800 
801     function MINIMUM_LIQUIDITY() external pure returns (uint256);
802 
803     function factory() external view returns (address);
804 
805     function token0() external view returns (address);
806 
807     function token1() external view returns (address);
808 
809     function getReserves()
810         external
811         view
812         returns (
813             uint112 reserve0,
814             uint112 reserve1,
815             uint32 blockTimestampLast
816         );
817 
818     function price0CumulativeLast() external view returns (uint256);
819 
820     function price1CumulativeLast() external view returns (uint256);
821 
822     function kLast() external view returns (uint256);
823 
824     function mint(address to) external returns (uint256 liquidity);
825 
826     function burn(address to)
827         external
828         returns (uint256 amount0, uint256 amount1);
829 
830     function swap(
831         uint256 amount0Out,
832         uint256 amount1Out,
833         address to,
834         bytes calldata data
835     ) external;
836 
837     function skim(address to) external;
838 
839     function sync() external;
840 
841     function initialize(address, address) external;
842 }
843 
844 interface IUniswapV2Router02 {
845     function factory() external pure returns (address);
846 
847     function WETH() external pure returns (address);
848 
849     function addLiquidity(
850         address tokenA,
851         address tokenB,
852         uint256 amountADesired,
853         uint256 amountBDesired,
854         uint256 amountAMin,
855         uint256 amountBMin,
856         address to,
857         uint256 deadline
858     )
859         external
860         returns (
861             uint256 amountA,
862             uint256 amountB,
863             uint256 liquidity
864         );
865 
866     function addLiquidityETH(
867         address token,
868         uint256 amountTokenDesired,
869         uint256 amountTokenMin,
870         uint256 amountETHMin,
871         address to,
872         uint256 deadline
873     )
874         external
875         payable
876         returns (
877             uint256 amountToken,
878             uint256 amountETH,
879             uint256 liquidity
880         );
881 
882     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
883         uint256 amountIn,
884         uint256 amountOutMin,
885         address[] calldata path,
886         address to,
887         uint256 deadline
888     ) external;
889 
890     function swapExactETHForTokensSupportingFeeOnTransferTokens(
891         uint256 amountOutMin,
892         address[] calldata path,
893         address to,
894         uint256 deadline
895     ) external payable;
896 
897     function swapExactTokensForETHSupportingFeeOnTransferTokens(
898         uint256 amountIn,
899         uint256 amountOutMin,
900         address[] calldata path,
901         address to,
902         uint256 deadline
903     ) external;
904 }
905 
906 contract X is ERC20, Ownable {
907     using SafeMath for uint256;
908 
909     IUniswapV2Router02 public immutable uniswapV2Router;
910     address public immutable uniswapV2Pair;
911     address public constant deadAddress = address(0xdead);
912 
913     bool private swapping;
914 
915     address public marketingWallet;
916     address public devWallet;
917     address public lpWallet;
918 
919     uint256 public swapTokensAtAmount;
920     uint256 public maxTokensForSwapback;
921 
922     uint256 public maxTransactionAmount;
923     uint256 public maxWallet;
924 
925     uint256 public percentForLPBurn = 25;
926     bool public lpBurnEnabled = true;
927     uint256 public lpBurnFrequency = 3600 seconds;
928     uint256 public lastLpBurnTime;
929 
930     uint256 public manualBurnFrequency = 30 minutes;
931     uint256 public lastManualLpBurnTime;
932 
933     bool public limitsInEffect = true;
934     bool public tradingActive = false;
935     bool public swapEnabled = false;
936 
937     // Anti-bot and anti-whale mappings and variables
938     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
939     bool public transferDelayEnabled = true;
940 
941     uint256 public buyTotalFees;
942     uint256 public buyMarketingFee;
943     uint256 public buyLiquidityFee;
944     uint256 public buyDevFee;
945 
946     uint256 public sellTotalFees;
947     uint256 public sellMarketingFee;
948     uint256 public sellLiquidityFee;
949     uint256 public sellDevFee;
950 
951     uint256 public tokensForMarketing;
952     uint256 public tokensForLiquidity;
953     uint256 public tokensForDev;
954 
955     /******************/
956 
957     // exlcude from fees and max transaction amount
958     mapping(address => bool) private _isExcludedFromFees;
959     mapping(address => bool) public _isExcludedMaxTransactionAmount;
960 
961     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
962     // could be subject to a maximum transfer amount
963     mapping(address => bool) public automatedMarketMakerPairs;
964 
965     event UpdateUniswapV2Router(
966         address indexed newAddress,
967         address indexed oldAddress
968     );
969 
970     event ExcludeFromFees(address indexed account, bool isExcluded);
971 
972     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
973 
974     event marketingWalletUpdated(
975         address indexed newWallet,
976         address indexed oldWallet
977     );
978 
979     event devWalletUpdated(
980         address indexed newWallet,
981         address indexed oldWallet
982     );
983 
984     event SwapAndLiquify(
985         uint256 tokensSwapped,
986         uint256 ethReceived,
987         uint256 tokensIntoLiquidity
988     );
989 
990     constructor() ERC20("The Everything App", "X") {
991         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
992             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
993         );
994 
995         excludeFromMaxTransaction(address(_uniswapV2Router), true);
996         uniswapV2Router = _uniswapV2Router;
997 
998         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
999             .createPair(address(this), _uniswapV2Router.WETH());
1000         excludeFromMaxTransaction(address(uniswapV2Pair), true);
1001         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1002 
1003         uint256 _buyMarketingFee = 30;
1004         uint256 _buyLiquidityFee = 0;
1005         uint256 _buyDevFee = 0;
1006 
1007         uint256 _sellMarketingFee = 40;
1008         uint256 _sellLiquidityFee = 0;
1009         uint256 _sellDevFee = 0;
1010 
1011         uint256 totalSupply = 1000000000 * 1e18;
1012 
1013         maxTransactionAmount = (totalSupply * 2) / 100; // 1% of total supply
1014         maxWallet = (totalSupply * 2) / 100; // 1% of total supply
1015 
1016         swapTokensAtAmount = (totalSupply * 5) / 10000; // 0.05% swapback trigger
1017         maxTokensForSwapback = (totalSupply * 6) / 1000; // 0.6% max swapback
1018 
1019         buyMarketingFee = _buyMarketingFee;
1020         buyLiquidityFee = _buyLiquidityFee;
1021         buyDevFee = _buyDevFee;
1022         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1023 
1024         sellMarketingFee = _sellMarketingFee;
1025         sellLiquidityFee = _sellLiquidityFee;
1026         sellDevFee = _sellDevFee;
1027         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1028 
1029         marketingWallet = address(0x359c90DF33fE2c7fD31209D5b2b23B34c8FA4C38); 
1030         devWallet = address(0x359c90DF33fE2c7fD31209D5b2b23B34c8FA4C38);
1031         lpWallet = msg.sender;
1032 
1033         // exclude from paying fees or having max transaction amount
1034         excludeFromFees(owner(), true);
1035         excludeFromFees(address(this), true);
1036         excludeFromFees(address(0xdead), true);
1037         excludeFromFees(marketingWallet, true);
1038 
1039         excludeFromMaxTransaction(owner(), true);
1040         excludeFromMaxTransaction(address(this), true);
1041         excludeFromMaxTransaction(address(0xdead), true);
1042         excludeFromMaxTransaction(marketingWallet, true);
1043 
1044         /*
1045             _mint is an internal function in ERC20.sol that is only called here,
1046             and CANNOT be called ever again
1047         */
1048         _mint(msg.sender, totalSupply);
1049     }
1050 
1051     receive() external payable {}
1052 
1053     /// @notice Launches the token and enables trading. Irriversable.
1054     function enableTrading() external onlyOwner {
1055         tradingActive = true;
1056         swapEnabled = true;
1057         lastLpBurnTime = block.timestamp;
1058     }
1059 
1060     /// @notice Removes the max wallet and max transaction limits
1061     function removeLimits() external onlyOwner returns (bool) {
1062         limitsInEffect = false;
1063         return true;
1064     }
1065 
1066     /// @notice Disables the Same wallet block transfer delay
1067     function disableTransferDelay() external onlyOwner returns (bool) {
1068         transferDelayEnabled = false;
1069         return true;
1070     }
1071 
1072     /// @notice Changes the minimum balance of tokens the contract must have before swapping tokens for ETH
1073     /// @param newAmount Base 100000, so 0.5% = 500.
1074     function updateSwapTokensAtAmount(uint256 newAmount)
1075         external
1076         onlyOwner
1077         returns (bool)
1078     {
1079         require(
1080             newAmount >= 1,
1081             "Swap amount cannot be lower than 0.001% total supply."
1082         );
1083         require(
1084             newAmount <= 500,
1085             "Swap amount cannot be higher than 0.5% total supply."
1086         );
1087         require(
1088             newAmount <= maxTokensForSwapback,
1089             "Swap amount cannot be higher than maxTokensForSwapback"
1090         );
1091         swapTokensAtAmount = newAmount * totalSupply()/ 100000;
1092         return true;
1093     }
1094 
1095     /// @notice Changes the maximum amount of tokens the contract can swap for ETH
1096     /// @param newAmount Base 10000, so 0.5% = 50.
1097     function updateMaxTokensForSwapback(uint256 newAmount)
1098         external
1099         onlyOwner
1100         returns (bool)
1101     {
1102         require(
1103             newAmount >= swapTokensAtAmount,
1104             "Swap amount cannot be lower than swapTokensAtAmount"
1105         );
1106         maxTokensForSwapback = newAmount * totalSupply()/ 100000;
1107         return true;
1108     }
1109 
1110     /// @notice Changes the maximum amount of tokens that can be bought or sold in a single transaction
1111     /// @param newNum Base 1000, so 1% = 10
1112     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1113         require(
1114             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1115             "Cannot set maxTransactionAmount lower than 0.1%"
1116         );
1117         maxTransactionAmount = newNum * (10**18);
1118     }
1119 
1120     /// @notice Changes the maximum amount of tokens a wallet can hold
1121     /// @param newNum Base 1000, so 1% = 10
1122     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1123         require(
1124             newNum >= 5,
1125             "Cannot set maxWallet lower than 0.5%"
1126         );
1127         maxWallet = newNum * totalSupply()/1000;
1128     }
1129 
1130 
1131     /// @notice Sets if a wallet is excluded from the max wallet and tx limits
1132     /// @param updAds The wallet to update
1133     /// @param isEx If the wallet is excluded or not
1134     function excludeFromMaxTransaction(address updAds, bool isEx)
1135         public
1136         onlyOwner
1137     {
1138         _isExcludedMaxTransactionAmount[updAds] = isEx;
1139     }
1140 
1141     /// @notice Sets if the contract can sell tokens
1142     /// @param enabled set to false to disable selling
1143     function updateSwapEnabled(bool enabled) external onlyOwner {
1144         swapEnabled = enabled;
1145     }
1146     
1147     /// @notice Sets the fees for buys
1148     /// @param _marketingFee The fee for the marketing wallet
1149     /// @param _liquidityFee The fee for the liquidity pool
1150     /// @param _devFee The fee for the dev wallet
1151     function updateBuyFees(
1152         uint256 _marketingFee,
1153         uint256 _liquidityFee,
1154         uint256 _devFee
1155     ) external onlyOwner {
1156         buyMarketingFee = _marketingFee;
1157         buyLiquidityFee = _liquidityFee;
1158         buyDevFee = _devFee;
1159         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1160         require(buyTotalFees <= 20, "Must keep fees at 11% or less");
1161     }
1162 
1163     /// @notice Sets the fees for sells
1164     /// @param _marketingFee The fee for the marketing wallet
1165     /// @param _liquidityFee The fee for the liquidity pool
1166     /// @param _devFee The fee for the dev wallet
1167     function updateSellFees(
1168         uint256 _marketingFee,
1169         uint256 _liquidityFee,
1170         uint256 _devFee
1171     ) external onlyOwner {
1172         sellMarketingFee = _marketingFee;
1173         sellLiquidityFee = _liquidityFee;
1174         sellDevFee = _devFee;
1175         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1176         require(sellTotalFees <= 20, "Must keep fees at 11% or less");
1177     }
1178 
1179     /// @notice Sets if a wallet is excluded from fees
1180     /// @param account The wallet to update
1181     /// @param excluded If the wallet is excluded or not
1182     function excludeFromFees(address account, bool excluded) public onlyOwner {
1183         _isExcludedFromFees[account] = excluded;
1184         emit ExcludeFromFees(account, excluded);
1185     }
1186 
1187     /// @notice Sets an address as a new liquidity pair. You probably dont want to do this.
1188     /// @param pair The new pair
1189     function setAutomatedMarketMakerPair(address pair, bool value)
1190         public
1191         onlyOwner
1192     {
1193         require(
1194             pair != uniswapV2Pair,
1195             "The pair cannot be removed from automatedMarketMakerPairs"
1196         );
1197 
1198         _setAutomatedMarketMakerPair(pair, value);
1199     }
1200 
1201     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1202         automatedMarketMakerPairs[pair] = value;
1203 
1204         emit SetAutomatedMarketMakerPair(pair, value);
1205     }
1206 
1207     function updateMarketingWallet(address newMarketingWallet)
1208         external
1209         onlyOwner
1210     {
1211         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1212         marketingWallet = newMarketingWallet;
1213     }
1214 
1215     function updateLPWallet(address newLPWallet)
1216         external
1217         onlyOwner
1218     {
1219         lpWallet = newLPWallet;
1220     }
1221 
1222     function updateDevWallet(address newWallet) external onlyOwner {
1223         emit devWalletUpdated(newWallet, devWallet);
1224         devWallet = newWallet;
1225     }
1226 
1227     function isExcludedFromFees(address account) public view returns (bool) {
1228         return _isExcludedFromFees[account];
1229     }
1230 
1231     event BoughtEarly(address indexed sniper);
1232 
1233     function _transfer(
1234         address from,
1235         address to,
1236         uint256 amount
1237     ) internal override {
1238         require(from != address(0), "ERC20: transfer from the zero address");
1239         require(to != address(0), "ERC20: transfer to the zero address");
1240 
1241         if (amount == 0) {
1242             super._transfer(from, to, 0);
1243             return;
1244         }
1245 
1246         if (limitsInEffect) {
1247             if (
1248                 from != owner() &&
1249                 to != owner() &&
1250                 to != address(0) &&
1251                 to != address(0xdead) &&
1252                 !swapping
1253             ) {
1254                 if (!tradingActive) {
1255                     require(
1256                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1257                         "Trading is not active."
1258                     );
1259                 }
1260 
1261                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.
1262                 if (transferDelayEnabled) {
1263                     if (
1264                         to != owner() &&
1265                         to != address(uniswapV2Router) &&
1266                         to != address(uniswapV2Pair)
1267                     ) {
1268                         require(
1269                             _holderLastTransferTimestamp[tx.origin] <
1270                                 block.number,
1271                             "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed."
1272                         );
1273                         _holderLastTransferTimestamp[tx.origin] = block.number;
1274                     }
1275                 }
1276 
1277                 //when buy
1278                 if (
1279                     automatedMarketMakerPairs[from] &&
1280                     !_isExcludedMaxTransactionAmount[to]
1281                 ) {
1282                     require(
1283                         amount <= maxTransactionAmount,
1284                         "Buy transfer amount exceeds the maxTransactionAmount."
1285                     );
1286                     require(
1287                         amount + balanceOf(to) <= maxWallet,
1288                         "Max wallet exceeded"
1289                     );
1290                 }
1291                 //when sell
1292                 else if (
1293                     automatedMarketMakerPairs[to] &&
1294                     !_isExcludedMaxTransactionAmount[from]
1295                 ) {
1296                     require(
1297                         amount <= maxTransactionAmount,
1298                         "Sell transfer amount exceeds the maxTransactionAmount."
1299                     );
1300                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1301                     require(
1302                         amount + balanceOf(to) <= maxWallet,
1303                         "Max wallet exceeded"
1304                     );
1305                 }
1306             }
1307         }
1308 
1309         uint256 contractTokenBalance = balanceOf(address(this));
1310 
1311         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1312 
1313         if (
1314             canSwap &&
1315             swapEnabled &&
1316             !swapping &&
1317             !automatedMarketMakerPairs[from] &&
1318             !_isExcludedFromFees[from] &&
1319             !_isExcludedFromFees[to]
1320         ) {
1321             swapping = true;
1322 
1323             swapBack();
1324 
1325             swapping = false;
1326         }
1327 
1328         if (
1329             !swapping &&
1330             automatedMarketMakerPairs[to] &&
1331             lpBurnEnabled &&
1332             block.timestamp >= lastLpBurnTime + lpBurnFrequency &&
1333             !_isExcludedFromFees[from]
1334         ) {
1335             autoBurnLiquidityPairTokens();
1336         }
1337 
1338         bool takeFee = !swapping;
1339 
1340         // if any account belongs to _isExcludedFromFee account then remove the fee
1341         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1342             takeFee = false;
1343         }
1344 
1345         uint256 fees = 0;
1346         // only take fees on buys/sells, do not take on wallet transfers
1347         if (takeFee) {
1348             // on sell
1349             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1350                 fees = amount.mul(sellTotalFees).div(100);
1351                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1352                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1353                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1354             }
1355             // on buy
1356             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1357                 fees = amount.mul(buyTotalFees).div(100);
1358                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1359                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1360                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1361             }
1362 
1363             if (fees > 0) {
1364                 super._transfer(from, address(this), fees);
1365             }
1366 
1367             amount -= fees;
1368         }
1369 
1370         super._transfer(from, to, amount);
1371     }
1372 
1373     function swapTokensForEth(uint256 tokenAmount) private {
1374         // generate the uniswap pair path of token -> weth
1375         address[] memory path = new address[](2);
1376         path[0] = address(this);
1377         path[1] = uniswapV2Router.WETH();
1378 
1379         _approve(address(this), address(uniswapV2Router), tokenAmount);
1380 
1381         // make the swap
1382         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1383             tokenAmount,
1384             0, // accept any amount of ETH
1385             path,
1386             address(this),
1387             block.timestamp
1388         );
1389     }
1390 
1391     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1392         // approve token transfer to cover all possible scenarios
1393         _approve(address(this), address(uniswapV2Router), tokenAmount);
1394 
1395         // add the liquidity
1396         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1397             address(this),
1398             tokenAmount,
1399             0, // slippage is unavoidable
1400             0, // slippage is unavoidable
1401             lpWallet,
1402             block.timestamp
1403         );
1404     }
1405 
1406     function swapBack() private {
1407         uint256 contractBalance = balanceOf(address(this));
1408         uint256 totalTokensToSwap = tokensForLiquidity +
1409             tokensForMarketing +
1410             tokensForDev;
1411         bool success;
1412 
1413         if (contractBalance == 0 || totalTokensToSwap == 0) {
1414             return;
1415         }
1416 
1417         if (contractBalance > maxTokensForSwapback) {
1418             contractBalance = maxTokensForSwapback;
1419         }
1420 
1421         // Halve the amount of liquidity tokens
1422         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1423             totalTokensToSwap /
1424             2;
1425         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1426 
1427         uint256 initialETHBalance = address(this).balance;
1428 
1429         swapTokensForEth(amountToSwapForETH);
1430 
1431         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1432 
1433         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1434             totalTokensToSwap
1435         );
1436         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1437 
1438         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1439 
1440         tokensForLiquidity = 0;
1441         tokensForMarketing = 0;
1442         tokensForDev = 0;
1443 
1444         (success, ) = address(devWallet).call{value: ethForDev}("");
1445 
1446         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1447             addLiquidity(liquidityTokens, ethForLiquidity);
1448             emit SwapAndLiquify(
1449                 amountToSwapForETH,
1450                 ethForLiquidity,
1451                 tokensForLiquidity
1452             );
1453         }
1454 
1455         (success, ) = address(marketingWallet).call{
1456             value: address(this).balance
1457         }("");
1458     }
1459 
1460     function setAutoLPBurnSettings(
1461         uint256 _frequencyInSeconds,
1462         uint256 _percent,
1463         bool _Enabled
1464     ) external onlyOwner {
1465         require(
1466             _frequencyInSeconds >= 600,
1467             "cannot set buyback more often than every 10 minutes"
1468         );
1469         require(
1470             _percent <= 1000 && _percent >= 0,
1471             "Must set auto LP burn percent between 0% and 10%"
1472         );
1473         lpBurnFrequency = _frequencyInSeconds;
1474         percentForLPBurn = _percent;
1475         lpBurnEnabled = _Enabled;
1476     }
1477 
1478     function autoBurnLiquidityPairTokens() internal returns (bool) {
1479         lastLpBurnTime = block.timestamp;
1480 
1481         // get balance of liquidity pair
1482         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1483 
1484         // calculate amount to burn
1485         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(
1486             10000
1487         );
1488 
1489         // pull tokens from pancakePair liquidity and move to dead address permanently
1490         if (amountToBurn > 0) {
1491             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1492         }
1493 
1494         //sync price since this is not in a swap transaction!
1495         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1496         pair.sync();
1497         return true;
1498     }
1499 
1500     function manualBurnLiquidityPairTokens(uint256 percent)
1501         external
1502         onlyOwner
1503         returns (bool)
1504     {
1505         require(
1506             block.timestamp > lastManualLpBurnTime + manualBurnFrequency,
1507             "Must wait for cooldown to finish"
1508         );
1509         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1510         lastManualLpBurnTime = block.timestamp;
1511 
1512         // get balance of liquidity pair
1513         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1514 
1515         // calculate amount to burn
1516         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1517 
1518         // pull tokens from pancakePair liquidity and move to dead address permanently
1519         if (amountToBurn > 0) {
1520             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1521         }
1522 
1523         //sync price since this is not in a swap transaction!
1524         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1525         pair.sync();
1526         return true;
1527     }
1528 }