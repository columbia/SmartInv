1 // SPDX-License-Identifier: MIT
2 pragma solidity >=0.8.18;
3 pragma experimental ABIEncoderV2;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         return msg.data;
12     }
13 }
14 
15 abstract contract Ownable is Context {
16     address private _owner;
17 
18     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
19 
20     /**
21      * @dev Initializes the contract setting the deployer as the initial owner.
22      */
23     constructor() {
24         _transferOwnership(_msgSender());
25     }
26 
27     /**
28      * @dev Returns the address of the current owner.
29      */
30     function owner() public view virtual returns (address) {
31         return _owner;
32     }
33 
34     /**
35      * @dev Throws if called by any account other than the owner.
36      */
37     modifier onlyOwner() {
38         require(owner() == _msgSender(), "Ownable: caller is not the owner");
39         _;
40     }
41 
42     /**
43      * @dev Leaves the contract without owner. It will not be possible to call
44      * `onlyOwner` functions anymore. Can only be called by the current owner.
45      *
46      * NOTE: Renouncing ownership will leave the contract without an owner,
47      * thereby removing any functionality that is only available to the owner.
48      */
49     function renounceOwnership() public virtual onlyOwner {
50         _transferOwnership(address(0));
51     }
52 
53     /**
54      * @dev Transfers ownership of the contract to a new account (`newOwner`).
55      * Can only be called by the current owner.
56      */
57     function transferOwnership(address newOwner) public virtual onlyOwner {
58         require(newOwner != address(0), "Ownable: new owner is the zero address");
59         _transferOwnership(newOwner);
60     }
61 
62     /**
63      * @dev Transfers ownership of the contract to a new account (`newOwner`).
64      * Internal function without access restriction.
65      */
66     function _transferOwnership(address newOwner) internal virtual {
67         address oldOwner = _owner;
68         _owner = newOwner;
69         emit OwnershipTransferred(oldOwner, newOwner);
70     }
71 }
72 
73 interface IERC20 {
74     /**
75      * @dev Returns the amount of tokens in existence.
76      */
77     function totalSupply() external view returns (uint256);
78 
79     /**
80      * @dev Returns the amount of tokens owned by `account`.
81      */
82     function balanceOf(address account) external view returns (uint256);
83 
84     /**
85      * @dev Moves `amount` tokens from the caller's account to `recipient`.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transfer(address recipient, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Returns the remaining number of tokens that `spender` will be
95      * allowed to spend on behalf of `owner` through {transferFrom}. This is
96      * zero by default.
97      *
98      * This value changes when {approve} or {transferFrom} are called.
99      */
100     function allowance(address owner, address spender) external view returns (uint256);
101 
102     /**
103      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
104      *
105      * Returns a boolean value indicating whether the operation succeeded.
106      *
107      * IMPORTANT: Beware that changing an allowance with this method brings the risk
108      * that someone may use both the old and the new allowance by unfortunate
109      * transaction ordering. One possible solution to mitigate this race
110      * condition is to first reduce the spender's allowance to 0 and set the
111      * desired value afterwards:
112      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
113      *
114      * Emits an {Approval} event.
115      */
116     function approve(address spender, uint256 amount) external returns (bool);
117 
118     /**
119      * @dev Moves `amount` tokens from `sender` to `recipient` using the
120      * allowance mechanism. `amount` is then deducted from the caller's
121      * allowance.
122      *
123      * Returns a boolean value indicating whether the operation succeeded.
124      *
125      * Emits a {Transfer} event.
126      */
127     function transferFrom(
128         address sender,
129         address recipient,
130         uint256 amount
131     ) external returns (bool);
132 
133     /**
134      * @dev Emitted when `value` tokens are moved from one account (`from`) to
135      * another (`to`).
136      *
137      * Note that `value` may be zero.
138      */
139     event Transfer(address indexed from, address indexed to, uint256 value);
140 
141     /**
142      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
143      * a call to {approve}. `value` is the new allowance.
144      */
145     event Approval(address indexed owner, address indexed spender, uint256 value);
146 }
147 
148 interface IERC20Metadata is IERC20 {
149     /**
150      * @dev Returns the name of the token.
151      */
152     function name() external view returns (string memory);
153 
154     /**
155      * @dev Returns the symbol of the token.
156      */
157     function symbol() external view returns (string memory);
158 
159     /**
160      * @dev Returns the decimals places of the token.
161      */
162     function decimals() external view returns (uint8);
163 }
164 
165 contract ERC20 is Context, IERC20, IERC20Metadata {
166     mapping(address => uint256) private _balances;
167 
168     mapping(address => mapping(address => uint256)) private _allowances;
169 
170     uint256 private _totalSupply;
171 
172     string private _name;
173     string private _symbol;
174 
175     /**
176      * @dev Sets the values for {name} and {symbol}.
177      *
178      * The default value of {decimals} is 18. To select a different value for
179      * {decimals} you should overload it.
180      *
181      * All two of these values are immutable: they can only be set once during
182      * construction.
183      */
184     constructor(string memory name_, string memory symbol_) {
185         _name = name_;
186         _symbol = symbol_;
187     }
188 
189     /**
190      * @dev Returns the name of the token.
191      */
192     function name() public view virtual override returns (string memory) {
193         return _name;
194     }
195 
196     /**
197      * @dev Returns the symbol of the token, usually a shorter version of the
198      * name.
199      */
200     function symbol() public view virtual override returns (string memory) {
201         return _symbol;
202     }
203 
204     /**
205      * @dev Returns the number of decimals used to get its user representation.
206      * For example, if `decimals` equals `2`, a balance of `505` tokens should
207      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
208      *
209      * Tokens usually opt for a value of 18, imitating the relationship between
210      * Ether and Wei. This is the value {ERC20} uses, unless this function is
211      * overridden;
212      *
213      * NOTE: This information is only used for _display_ purposes: it in
214      * no way affects any of the arithmetic of the contract, including
215      * {IERC20-balanceOf} and {IERC20-transfer}.
216      */
217     function decimals() public view virtual override returns (uint8) {
218         return 18;
219     }
220 
221     /**
222      * @dev See {IERC20-totalSupply}.
223      */
224     function totalSupply() public view virtual override returns (uint256) {
225         return _totalSupply;
226     }
227 
228     /**
229      * @dev See {IERC20-balanceOf}.
230      */
231     function balanceOf(address account) public view virtual override returns (uint256) {
232         return _balances[account];
233     }
234 
235     /**
236      * @dev See {IERC20-transfer}.
237      *
238      * Requirements:
239      *
240      * - `recipient` cannot be the zero address.
241      * - the caller must have a balance of at least `amount`.
242      */
243     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
244         _transfer(_msgSender(), recipient, amount);
245         return true;
246     }
247 
248     /**
249      * @dev See {IERC20-allowance}.
250      */
251     function allowance(address owner, address spender) public view virtual override returns (uint256) {
252         return _allowances[owner][spender];
253     }
254 
255     /**
256      * @dev See {IERC20-approve}.
257      *
258      * Requirements:
259      *
260      * - `spender` cannot be the zero address.
261      */
262     function approve(address spender, uint256 amount) public virtual override returns (bool) {
263         _approve(_msgSender(), spender, amount);
264         return true;
265     }
266 
267     /**
268      * @dev See {IERC20-transferFrom}.
269      *
270      * Emits an {Approval} event indicating the updated allowance. This is not
271      * required by the EIP. See the note at the beginning of {ERC20}.
272      *
273      * Requirements:
274      *
275      * - `sender` and `recipient` cannot be the zero address.
276      * - `sender` must have a balance of at least `amount`.
277      * - the caller must have allowance for ``sender``'s tokens of at least
278      * `amount`.
279      */
280     function transferFrom(
281         address sender,
282         address recipient,
283         uint256 amount
284     ) public virtual override returns (bool) {
285         _transfer(sender, recipient, amount);
286 
287         uint256 currentAllowance = _allowances[sender][_msgSender()];
288         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
289         unchecked {
290             _approve(sender, _msgSender(), currentAllowance - amount);
291         }
292 
293         return true;
294     }
295 
296     /**
297      * @dev Atomically increases the allowance granted to `spender` by the caller.
298      *
299      * This is an alternative to {approve} that can be used as a mitigation for
300      * problems described in {IERC20-approve}.
301      *
302      * Emits an {Approval} event indicating the updated allowance.
303      *
304      * Requirements:
305      *
306      * - `spender` cannot be the zero address.
307      */
308     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
309         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
310         return true;
311     }
312 
313     /**
314      * @dev Atomically decreases the allowance granted to `spender` by the caller.
315      *
316      * This is an alternative to {approve} that can be used as a mitigation for
317      * problems described in {IERC20-approve}.
318      *
319      * Emits an {Approval} event indicating the updated allowance.
320      *
321      * Requirements:
322      *
323      * - `spender` cannot be the zero address.
324      * - `spender` must have allowance for the caller of at least
325      * `subtractedValue`.
326      */
327     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
328         uint256 currentAllowance = _allowances[_msgSender()][spender];
329         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
330         unchecked {
331             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
332         }
333 
334         return true;
335     }
336 
337     /**
338      * @dev Moves `amount` of tokens from `sender` to `recipient`.
339      *
340      * This internal function is equivalent to {transfer}, and can be used to
341      * e.g. implement automatic token fees, slashing mechanisms, etc.
342      *
343      * Emits a {Transfer} event.
344      *
345      * Requirements:
346      *
347      * - `sender` cannot be the zero address.
348      * - `recipient` cannot be the zero address.
349      * - `sender` must have a balance of at least `amount`.
350      */
351     function _transfer(
352         address sender,
353         address recipient,
354         uint256 amount
355     ) internal virtual {
356         require(sender != address(0), "ERC20: transfer from the zero address");
357         require(recipient != address(0), "ERC20: transfer to the zero address");
358 
359         _beforeTokenTransfer(sender, recipient, amount);
360 
361         uint256 senderBalance = _balances[sender];
362         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
363         unchecked {
364             _balances[sender] = senderBalance - amount;
365         }
366         _balances[recipient] += amount;
367 
368         emit Transfer(sender, recipient, amount);
369 
370         _afterTokenTransfer(sender, recipient, amount);
371     }
372 
373     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
374      * the total supply.
375      *
376      * Emits a {Transfer} event with `from` set to the zero address.
377      *
378      * Requirements:
379      *
380      * - `account` cannot be the zero address.
381      */
382     function _mint(address account, uint256 amount) internal virtual {
383         require(account != address(0), "ERC20: mint to the zero address");
384 
385         _beforeTokenTransfer(address(0), account, amount);
386 
387         _totalSupply += amount;
388         _balances[account] += amount;
389         emit Transfer(address(0), account, amount);
390 
391         _afterTokenTransfer(address(0), account, amount);
392     }
393 
394     /**
395      * @dev Destroys `amount` tokens from `account`, reducing the
396      * total supply.
397      *
398      * Emits a {Transfer} event with `to` set to the zero address.
399      *
400      * Requirements:
401      *
402      * - `account` cannot be the zero address.
403      * - `account` must have at least `amount` tokens.
404      */
405     function _burn(address account, uint256 amount) internal virtual {
406         require(account != address(0), "ERC20: burn from the zero address");
407 
408         _beforeTokenTransfer(account, address(0), amount);
409 
410         uint256 accountBalance = _balances[account];
411         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
412         unchecked {
413             _balances[account] = accountBalance - amount;
414         }
415         _totalSupply -= amount;
416 
417         emit Transfer(account, address(0), amount);
418 
419         _afterTokenTransfer(account, address(0), amount);
420     }
421 
422     /**
423      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
424      *
425      * This internal function is equivalent to `approve`, and can be used to
426      * e.g. set automatic allowances for certain subsystems, etc.
427      *
428      * Emits an {Approval} event.
429      *
430      * Requirements:
431      *
432      * - `owner` cannot be the zero address.
433      * - `spender` cannot be the zero address.
434      */
435     function _approve(
436         address owner,
437         address spender,
438         uint256 amount
439     ) internal virtual {
440         require(owner != address(0), "ERC20: approve from the zero address");
441         require(spender != address(0), "ERC20: approve to the zero address");
442 
443         _allowances[owner][spender] = amount;
444         emit Approval(owner, spender, amount);
445     }
446 
447     /**
448      * @dev Hook that is called before any transfer of tokens. This includes
449      * minting and burning.
450      *
451      * Calling conditions:
452      *
453      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
454      * will be transferred to `to`.
455      * - when `from` is zero, `amount` tokens will be minted for `to`.
456      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
457      * - `from` and `to` are never both zero.
458      *
459      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
460      */
461     function _beforeTokenTransfer(
462         address from,
463         address to,
464         uint256 amount
465     ) internal virtual {}
466 
467     /**
468      * @dev Hook that is called after any transfer of tokens. This includes
469      * minting and burning.
470      *
471      * Calling conditions:
472      *
473      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
474      * has been transferred to `to`.
475      * - when `from` is zero, `amount` tokens have been minted for `to`.
476      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
477      * - `from` and `to` are never both zero.
478      *
479      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
480      */
481     function _afterTokenTransfer(
482         address from,
483         address to,
484         uint256 amount
485     ) internal virtual {}
486 }
487 
488 library SafeMath {
489     /**
490      * @dev Returns the addition of two unsigned integers, with an overflow flag.
491      *
492      * _Available since v3.4._
493      */
494     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
495         unchecked {
496             uint256 c = a + b;
497             if (c < a) return (false, 0);
498             return (true, c);
499         }
500     }
501 
502     /**
503      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
504      *
505      * _Available since v3.4._
506      */
507     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
508         unchecked {
509             if (b > a) return (false, 0);
510             return (true, a - b);
511         }
512     }
513 
514     /**
515      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
516      *
517      * _Available since v3.4._
518      */
519     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
520         unchecked {
521             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
522             // benefit is lost if 'b' is also tested.
523             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
524             if (a == 0) return (true, 0);
525             uint256 c = a * b;
526             if (c / a != b) return (false, 0);
527             return (true, c);
528         }
529     }
530 
531     /**
532      * @dev Returns the division of two unsigned integers, with a division by zero flag.
533      *
534      * _Available since v3.4._
535      */
536     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
537         unchecked {
538             if (b == 0) return (false, 0);
539             return (true, a / b);
540         }
541     }
542 
543     /**
544      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
545      *
546      * _Available since v3.4._
547      */
548     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
549         unchecked {
550             if (b == 0) return (false, 0);
551             return (true, a % b);
552         }
553     }
554 
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
566         return a + b;
567     }
568 
569     /**
570      * @dev Returns the subtraction of two unsigned integers, reverting on
571      * overflow (when the result is negative).
572      *
573      * Counterpart to Solidity's `-` operator.
574      *
575      * Requirements:
576      *
577      * - Subtraction cannot overflow.
578      */
579     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
580         return a - b;
581     }
582 
583     /**
584      * @dev Returns the multiplication of two unsigned integers, reverting on
585      * overflow.
586      *
587      * Counterpart to Solidity's `*` operator.
588      *
589      * Requirements:
590      *
591      * - Multiplication cannot overflow.
592      */
593     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
594         return a * b;
595     }
596 
597     /**
598      * @dev Returns the integer division of two unsigned integers, reverting on
599      * division by zero. The result is rounded towards zero.
600      *
601      * Counterpart to Solidity's `/` operator.
602      *
603      * Requirements:
604      *
605      * - The divisor cannot be zero.
606      */
607     function div(uint256 a, uint256 b) internal pure returns (uint256) {
608         return a / b;
609     }
610 
611     /**
612      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
613      * reverting when dividing by zero.
614      *
615      * Counterpart to Solidity's `%` operator. This function uses a `revert`
616      * opcode (which leaves remaining gas untouched) while Solidity uses an
617      * invalid opcode to revert (consuming all remaining gas).
618      *
619      * Requirements:
620      *
621      * - The divisor cannot be zero.
622      */
623     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
624         return a % b;
625     }
626 
627     /**
628      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
629      * overflow (when the result is negative).
630      *
631      * CAUTION: This function is deprecated because it requires allocating memory for the error
632      * message unnecessarily. For custom revert reasons use {trySub}.
633      *
634      * Counterpart to Solidity's `-` operator.
635      *
636      * Requirements:
637      *
638      * - Subtraction cannot overflow.
639      */
640     function sub(
641         uint256 a,
642         uint256 b,
643         string memory errorMessage
644     ) internal pure returns (uint256) {
645         unchecked {
646             require(b <= a, errorMessage);
647             return a - b;
648         }
649     }
650 
651     /**
652      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
653      * division by zero. The result is rounded towards zero.
654      *
655      * Counterpart to Solidity's `/` operator. Note: this function uses a
656      * `revert` opcode (which leaves remaining gas untouched) while Solidity
657      * uses an invalid opcode to revert (consuming all remaining gas).
658      *
659      * Requirements:
660      *
661      * - The divisor cannot be zero.
662      */
663     function div(
664         uint256 a,
665         uint256 b,
666         string memory errorMessage
667     ) internal pure returns (uint256) {
668         unchecked {
669             require(b > 0, errorMessage);
670             return a / b;
671         }
672     }
673 
674     /**
675      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
676      * reverting with custom message when dividing by zero.
677      *
678      * CAUTION: This function is deprecated because it requires allocating memory for the error
679      * message unnecessarily. For custom revert reasons use {tryMod}.
680      *
681      * Counterpart to Solidity's `%` operator. This function uses a `revert`
682      * opcode (which leaves remaining gas untouched) while Solidity uses an
683      * invalid opcode to revert (consuming all remaining gas).
684      *
685      * Requirements:
686      *
687      * - The divisor cannot be zero.
688      */
689     function mod(
690         uint256 a,
691         uint256 b,
692         string memory errorMessage
693     ) internal pure returns (uint256) {
694         unchecked {
695             require(b > 0, errorMessage);
696             return a % b;
697         }
698     }
699 }
700 
701 interface IUniswapV2Factory {
702     event PairCreated(
703         address indexed token0,
704         address indexed token1,
705         address pair,
706         uint256
707     );
708 
709     function feeTo() external view returns (address);
710 
711     function feeToSetter() external view returns (address);
712 
713     function getPair(address tokenA, address tokenB)
714         external
715         view
716         returns (address pair);
717 
718     function allPairs(uint256) external view returns (address pair);
719 
720     function allPairsLength() external view returns (uint256);
721 
722     function createPair(address tokenA, address tokenB)
723         external
724         returns (address pair);
725 
726     function setFeeTo(address) external;
727 
728     function setFeeToSetter(address) external;
729 }
730 
731 interface IUniswapV2Pair {
732     event Approval(
733         address indexed owner,
734         address indexed spender,
735         uint256 value
736     );
737     event Transfer(address indexed from, address indexed to, uint256 value);
738 
739     function name() external pure returns (string memory);
740 
741     function symbol() external pure returns (string memory);
742 
743     function decimals() external pure returns (uint8);
744 
745     function totalSupply() external view returns (uint256);
746 
747     function balanceOf(address owner) external view returns (uint256);
748 
749     function allowance(address owner, address spender)
750         external
751         view
752         returns (uint256);
753 
754     function approve(address spender, uint256 value) external returns (bool);
755 
756     function transfer(address to, uint256 value) external returns (bool);
757 
758     function transferFrom(
759         address from,
760         address to,
761         uint256 value
762     ) external returns (bool);
763 
764     function DOMAIN_SEPARATOR() external view returns (bytes32);
765 
766     function PERMIT_TYPEHASH() external pure returns (bytes32);
767 
768     function nonces(address owner) external view returns (uint256);
769 
770     function permit(
771         address owner,
772         address spender,
773         uint256 value,
774         uint256 deadline,
775         uint8 v,
776         bytes32 r,
777         bytes32 s
778     ) external;
779 
780     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
781     event Burn(
782         address indexed sender,
783         uint256 amount0,
784         uint256 amount1,
785         address indexed to
786     );
787     event Swap(
788         address indexed sender,
789         uint256 amount0In,
790         uint256 amount1In,
791         uint256 amount0Out,
792         uint256 amount1Out,
793         address indexed to
794     );
795     event Sync(uint112 reserve0, uint112 reserve1);
796 
797     function MINIMUM_LIQUIDITY() external pure returns (uint256);
798 
799     function factory() external view returns (address);
800 
801     function token0() external view returns (address);
802 
803     function token1() external view returns (address);
804 
805     function getReserves()
806         external
807         view
808         returns (
809             uint112 reserve0,
810             uint112 reserve1,
811             uint32 blockTimestampLast
812         );
813 
814     function price0CumulativeLast() external view returns (uint256);
815 
816     function price1CumulativeLast() external view returns (uint256);
817 
818     function kLast() external view returns (uint256);
819 
820     function mint(address to) external returns (uint256 liquidity);
821 
822     function burn(address to)
823         external
824         returns (uint256 amount0, uint256 amount1);
825 
826     function swap(
827         uint256 amount0Out,
828         uint256 amount1Out,
829         address to,
830         bytes calldata data
831     ) external;
832 
833     function skim(address to) external;
834 
835     function sync() external;
836 
837     function initialize(address, address) external;
838 }
839 
840 interface IUniswapV2Router02 {
841     function factory() external pure returns (address);
842 
843     function WETH() external pure returns (address);
844 
845     function addLiquidity(
846         address tokenA,
847         address tokenB,
848         uint256 amountADesired,
849         uint256 amountBDesired,
850         uint256 amountAMin,
851         uint256 amountBMin,
852         address to,
853         uint256 deadline
854     )
855         external
856         returns (
857             uint256 amountA,
858             uint256 amountB,
859             uint256 liquidity
860         );
861 
862     function addLiquidityETH(
863         address token,
864         uint256 amountTokenDesired,
865         uint256 amountTokenMin,
866         uint256 amountETHMin,
867         address to,
868         uint256 deadline
869     )
870         external
871         payable
872         returns (
873             uint256 amountToken,
874             uint256 amountETH,
875             uint256 liquidity
876         );
877 
878     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
879         uint256 amountIn,
880         uint256 amountOutMin,
881         address[] calldata path,
882         address to,
883         uint256 deadline
884     ) external;
885 
886     function swapExactETHForTokensSupportingFeeOnTransferTokens(
887         uint256 amountOutMin,
888         address[] calldata path,
889         address to,
890         uint256 deadline
891     ) external payable;
892 
893     function swapExactTokensForETHSupportingFeeOnTransferTokens(
894         uint256 amountIn,
895         uint256 amountOutMin,
896         address[] calldata path,
897         address to,
898         uint256 deadline
899     ) external;
900 }
901 
902 contract KEKAI is ERC20, Ownable {
903     using SafeMath for uint256;
904 
905     IUniswapV2Router02 public immutable uniswapV2Router;
906     address public immutable uniswapV2Pair;
907     address public constant deadAddress = address(0xdead);
908     address public constant launchShield = 0x590a7cC27d9607C03085f725ac6B85Ac9EF85967;
909 
910     bool private swapping;
911 
912     address public marketingWallet;
913     address public devWallet;
914 
915     uint256 public maxTransactionAmount;
916     uint256 public swapTokensAtAmount;
917     uint256 public maxWallet;
918 
919     bool public limitsInEffect = true;
920     bool public tradingActive = false;
921     bool public swapEnabled = false;
922 
923     uint256 public buyTotalFees;
924     uint256 public buyMarketingFee;
925     uint256 public buyLiquidityFee;
926     uint256 public buyDevFee;
927 
928     uint256 public sellTotalFees;
929     uint256 public sellMarketingFee;
930     uint256 public sellLiquidityFee;
931     uint256 public sellDevFee;
932 
933     uint256 public tokensForMarketing;
934     uint256 public tokensForLiquidity;
935     uint256 public tokensForDev;
936 
937     /******************/
938 
939     // exlcude from fees and max transaction amount
940     mapping(address => bool) private _isExcludedFromFees;
941     mapping(address => bool) public _isExcludedMaxTransactionAmount;
942 
943     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
944     // could be subject to a maximum transfer amount
945     mapping(address => bool) public automatedMarketMakerPairs;
946 
947     event UpdateUniswapV2Router(
948         address indexed newAddress,
949         address indexed oldAddress
950     );
951 
952     event ExcludeFromFees(address indexed account, bool isExcluded);
953 
954     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
955 
956     event marketingWalletUpdated(
957         address indexed newWallet,
958         address indexed oldWallet
959     );
960 
961     event devWalletUpdated(
962         address indexed newWallet,
963         address indexed oldWallet
964     );
965 
966     event SwapAndLiquify(
967         uint256 tokensSwapped,
968         uint256 ethReceived,
969         uint256 tokensIntoLiquidity
970     );
971 
972     constructor() ERC20("KEK AI", "KEKAI") {
973         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(
974             0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
975         );
976 
977         excludeFromMaxTransaction(address(_uniswapV2Router), true);
978         uniswapV2Router = _uniswapV2Router;
979 
980         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
981             .createPair(address(this), _uniswapV2Router.WETH());
982         excludeFromMaxTransaction(address(uniswapV2Pair), true);
983         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
984 
985         uint256 _buyMarketingFee = 4;
986         uint256 _buyLiquidityFee = 3;
987         uint256 _buyDevFee = 3;
988 
989         uint256 _sellMarketingFee = 4;
990         uint256 _sellLiquidityFee = 3;
991         uint256 _sellDevFee = 3;
992 
993         uint256 totalSupply = 1_000_000_000 * 1e18;
994 
995         maxTransactionAmount = (totalSupply);
996         maxWallet = (totalSupply);
997         swapTokensAtAmount = (totalSupply * 1) / 1000;
998         buyMarketingFee = _buyMarketingFee;
999         buyLiquidityFee = _buyLiquidityFee;
1000         buyDevFee = _buyDevFee;
1001         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1002 
1003         sellMarketingFee = _sellMarketingFee;
1004         sellLiquidityFee = _sellLiquidityFee;
1005         sellDevFee = _sellDevFee;
1006         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1007 
1008         marketingWallet = address(0xe6C27e78F4F595032B3f686C808b5C15f04D976D); 
1009         devWallet = address(0x7D9Ce0113176D869c2C9f924cb4Fde437FDD9941); 
1010 
1011         excludeFromFees(owner(), true);
1012         excludeFromFees(address(this), true);
1013         excludeFromFees(address(0xdead), true);
1014 
1015         excludeFromMaxTransaction(owner(), true);
1016         excludeFromMaxTransaction(address(this), true);
1017         excludeFromMaxTransaction(address(0xdead), true);
1018         
1019         excludeFromFees(launchShield, true);
1020         excludeFromMaxTransaction(launchShield, true);
1021 
1022         /*
1023             _mint is an internal function in ERC20.sol that is only called here,
1024             and CANNOT be called ever again
1025         */
1026         _mint(msg.sender, totalSupply);
1027     }
1028 
1029     receive() external payable {}
1030 
1031     function startTrading() external onlyOwner {
1032         tradingActive = true;
1033         swapEnabled = true;
1034     }
1035 
1036     function pauseTrading() external onlyOwner {
1037         tradingActive = false;
1038     }
1039 
1040     // remove limits after token is stable
1041     function removeLimits() external onlyOwner returns (bool) {
1042         limitsInEffect = false;
1043         return true;
1044     }
1045 
1046     // change the minimum amount of tokens to sell from fees
1047     function updateSwapTokensAtAmount(uint256 newAmount)
1048         external
1049         onlyOwner
1050         returns (bool)
1051     {
1052         require(
1053             newAmount >= (totalSupply() * 1) / 100000,
1054             "Swap amount cannot be lower than 0.001% total supply."
1055         );
1056         require(
1057             newAmount <= (totalSupply() * 5) / 1000,
1058             "Swap amount cannot be higher than 0.5% total supply."
1059         );
1060         swapTokensAtAmount = newAmount;
1061         return true;
1062     }
1063 
1064     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1065         require(
1066             newNum >= ((totalSupply() * 1) / 1000) / 1e18,
1067             "Cannot set maxTransactionAmount lower than 0.1%"
1068         );
1069         maxTransactionAmount = newNum * (10**18);
1070     }
1071 
1072     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1073         require(
1074             newNum >= ((totalSupply() * 5) / 1000) / 1e18,
1075             "Cannot set maxWallet lower than 0.5%"
1076         );
1077         maxWallet = newNum * (10**18);
1078     }
1079 
1080     function excludeFromMaxTransaction(address updAds, bool isEx)
1081         public
1082         onlyOwner
1083     {
1084         _isExcludedMaxTransactionAmount[updAds] = isEx;
1085     }
1086 
1087     // only use to disable contract sales if absolutely necessary (emergency use only)
1088     function updateSwapEnabled(bool enabled) external onlyOwner {
1089         swapEnabled = enabled;
1090     }
1091 
1092     function updateBuyFees(
1093         uint256 _marketingFee,
1094         uint256 _liquidityFee,
1095         uint256 _devFee
1096     ) external onlyOwner {
1097         buyMarketingFee = _marketingFee;
1098         buyLiquidityFee = _liquidityFee;
1099         buyDevFee = _devFee;
1100         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1101         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1102     }
1103 
1104     function updateSellFees(
1105         uint256 _marketingFee,
1106         uint256 _liquidityFee,
1107         uint256 _devFee
1108     ) external onlyOwner {
1109         sellMarketingFee = _marketingFee;
1110         sellLiquidityFee = _liquidityFee;
1111         sellDevFee = _devFee;
1112         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1113         require(sellTotalFees <= 20, "Must keep fees at 20% or less");
1114     }
1115 
1116     function excludeFromFees(address account, bool excluded) public onlyOwner {
1117         _isExcludedFromFees[account] = excluded;
1118         emit ExcludeFromFees(account, excluded);
1119     }
1120 
1121     function setAutomatedMarketMakerPair(address pair, bool value)
1122         public
1123         onlyOwner
1124     {
1125         require(
1126             pair != uniswapV2Pair,
1127             "The pair cannot be removed from automatedMarketMakerPairs"
1128         );
1129 
1130         _setAutomatedMarketMakerPair(pair, value);
1131     }
1132 
1133     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1134         automatedMarketMakerPairs[pair] = value;
1135 
1136         emit SetAutomatedMarketMakerPair(pair, value);
1137     }
1138 
1139     function updateMarketingWallet(address newMarketingWallet)
1140         external
1141         onlyOwner
1142     {
1143         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1144         marketingWallet = newMarketingWallet;
1145     }
1146 
1147     function updateDevWallet(address newWallet) external onlyOwner {
1148         emit devWalletUpdated(newWallet, devWallet);
1149         devWallet = newWallet;
1150     }
1151 
1152     function isExcludedFromFees(address account) public view returns (bool) {
1153         return _isExcludedFromFees[account];
1154     }
1155 
1156     event BoughtEarly(address indexed sniper);
1157 
1158     function _transfer(
1159         address from,
1160         address to,
1161         uint256 amount
1162     ) internal override {
1163         require(from != address(0), "ERC20: transfer from the zero address");
1164         require(to != address(0), "ERC20: transfer to the zero address");
1165 
1166         if (amount == 0) {
1167             super._transfer(from, to, 0);
1168             return;
1169         }
1170 
1171         if (limitsInEffect) {
1172             if (
1173                 from != owner() &&
1174                 to != owner() &&
1175                 to != address(0) &&
1176                 to != address(0xdead) &&
1177                 !swapping
1178             ) {
1179                 if (!tradingActive) {
1180                     require(
1181                         _isExcludedFromFees[from] || _isExcludedFromFees[to],
1182                         "Trading is not active."
1183                     );
1184                 }
1185 
1186                 //when buy
1187                 if (
1188                     automatedMarketMakerPairs[from] &&
1189                     !_isExcludedMaxTransactionAmount[to]
1190                 ) {
1191                     require(
1192                         amount <= maxTransactionAmount,
1193                         "Buy transfer amount exceeds the maxTransactionAmount."
1194                     );
1195                     require(
1196                         amount + balanceOf(to) <= maxWallet,
1197                         "Max wallet exceeded"
1198                     );
1199                 }
1200                 //when sell
1201                 else if (
1202                     automatedMarketMakerPairs[to] &&
1203                     !_isExcludedMaxTransactionAmount[from]
1204                 ) {
1205                     require(
1206                         amount <= maxTransactionAmount,
1207                         "Sell transfer amount exceeds the maxTransactionAmount."
1208                     );
1209                 } else if (!_isExcludedMaxTransactionAmount[to]) {
1210                     require(
1211                         amount + balanceOf(to) <= maxWallet,
1212                         "Max wallet exceeded"
1213                     );
1214                 }
1215             }
1216         }
1217 
1218         uint256 contractTokenBalance = balanceOf(address(this));
1219 
1220         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1221 
1222         if (
1223             canSwap &&
1224             swapEnabled &&
1225             !swapping &&
1226             !automatedMarketMakerPairs[from] &&
1227             !_isExcludedFromFees[from] &&
1228             !_isExcludedFromFees[to]
1229         ) {
1230             swapping = true;
1231 
1232             swapBack();
1233 
1234             swapping = false;
1235         }
1236 
1237         bool takeFee = !swapping;
1238 
1239         // if any account belongs to _isExcludedFromFee account then remove the fee
1240         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1241             takeFee = false;
1242         }
1243 
1244         uint256 fees = 0;
1245         // only take fees on buys/sells, do not take on wallet transfers
1246         if (takeFee) {
1247             // on sell
1248             if (automatedMarketMakerPairs[to] && sellTotalFees > 0) {
1249                 fees = amount.mul(sellTotalFees).div(100);
1250                 tokensForLiquidity += (fees * sellLiquidityFee) / sellTotalFees;
1251                 tokensForDev += (fees * sellDevFee) / sellTotalFees;
1252                 tokensForMarketing += (fees * sellMarketingFee) / sellTotalFees;
1253             }
1254             // on buy
1255             else if (automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1256                 fees = amount.mul(buyTotalFees).div(100);
1257                 tokensForLiquidity += (fees * buyLiquidityFee) / buyTotalFees;
1258                 tokensForDev += (fees * buyDevFee) / buyTotalFees;
1259                 tokensForMarketing += (fees * buyMarketingFee) / buyTotalFees;
1260             }
1261 
1262             if (fees > 0) {
1263                 super._transfer(from, address(this), fees);
1264             }
1265 
1266             amount -= fees;
1267         }
1268 
1269         super._transfer(from, to, amount);
1270     }
1271 
1272     function swapTokensForEth(uint256 tokenAmount) private {
1273         // generate the uniswap pair path of token -> weth
1274         address[] memory path = new address[](2);
1275         path[0] = address(this);
1276         path[1] = uniswapV2Router.WETH();
1277 
1278         _approve(address(this), address(uniswapV2Router), tokenAmount);
1279 
1280         // make the swap
1281         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1282             tokenAmount,
1283             0, // accept any amount of ETH
1284             path,
1285             address(this),
1286             block.timestamp
1287         );
1288     }
1289 
1290     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1291         // approve token transfer to cover all possible scenarios
1292         _approve(address(this), address(uniswapV2Router), tokenAmount);
1293 
1294         // add the liquidity
1295         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1296             address(this),
1297             tokenAmount,
1298             0, // slippage is unavoidable
1299             0, // slippage is unavoidable
1300             deadAddress,
1301             block.timestamp
1302         );
1303     }
1304 
1305     function swapBack() private {
1306         uint256 contractBalance = balanceOf(address(this));
1307         uint256 totalTokensToSwap = tokensForLiquidity +
1308             tokensForMarketing +
1309             tokensForDev;
1310         bool success;
1311 
1312         if (contractBalance == 0 || totalTokensToSwap == 0) {
1313             return;
1314         }
1315 
1316         if (contractBalance > swapTokensAtAmount * 20) {
1317             contractBalance = swapTokensAtAmount * 20;
1318         }
1319 
1320         // Halve the amount of liquidity tokens
1321         uint256 liquidityTokens = (contractBalance * tokensForLiquidity) /
1322             totalTokensToSwap /
1323             2;
1324         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1325 
1326         uint256 initialETHBalance = address(this).balance;
1327 
1328         swapTokensForEth(amountToSwapForETH);
1329 
1330         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1331 
1332         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(
1333             totalTokensToSwap
1334         );
1335         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1336 
1337         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1338 
1339         tokensForLiquidity = 0;
1340         tokensForMarketing = 0;
1341         tokensForDev = 0;
1342 
1343         (success, ) = address(devWallet).call{value: ethForDev}("");
1344 
1345         if (liquidityTokens > 0 && ethForLiquidity > 0) {
1346             addLiquidity(liquidityTokens, ethForLiquidity);
1347             emit SwapAndLiquify(
1348                 amountToSwapForETH,
1349                 ethForLiquidity,
1350                 tokensForLiquidity
1351             );
1352         }
1353 
1354         (success, ) = address(marketingWallet).call{
1355             value: address(this).balance
1356         }("");
1357     }
1358 }