1 /**
2  *Submitted for verification at Etherscan.io on 2022-08-19
3 */
4 
5 /**
6     *Telegram:https://t.me/collieInu_Official
7     *linktr: https://linktr.ee/collieinu_token
8     *TikTok: https://www.tiktok.com/@collie_inu_token
9     *Facebook: Collie inu token 
10     *Twitter: https://twitter.com/Collieinu_token
11     *Instagram: https://www.instagram.com/Collie_inu_token/
12     *Snapchat: Collieinu_token
13     *reddit: Collieinu_token
14     *Website: https://collieinu.net
15 */
16 
17 // SPDX-License-Identifier: MIT                                                                               
18                                                     
19 pragma solidity 0.8.9;
20 
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes calldata) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 interface IUniswapV2Pair {
33     event Approval(address indexed owner, address indexed spender, uint value);
34     event Transfer(address indexed from, address indexed to, uint value);
35 
36     function name() external pure returns (string memory);
37     function symbol() external pure returns (string memory);
38     function decimals() external pure returns (uint8);
39     function totalSupply() external view returns (uint);
40     function balanceOf(address owner) external view returns (uint);
41     function allowance(address owner, address spender) external view returns (uint);
42 
43     function approve(address spender, uint value) external returns (bool);
44     function transfer(address to, uint value) external returns (bool);
45     function transferFrom(address from, address to, uint value) external returns (bool);
46 
47     function DOMAIN_SEPARATOR() external view returns (bytes32);
48     function PERMIT_TYPEHASH() external pure returns (bytes32);
49     function nonces(address owner) external view returns (uint);
50 
51     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
52 
53     event Mint(address indexed sender, uint amount0, uint amount1);
54     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
55     event Swap(
56         address indexed sender,
57         uint amount0In,
58         uint amount1In,
59         uint amount0Out,
60         uint amount1Out,
61         address indexed to
62     );
63     event Sync(uint112 reserve0, uint112 reserve1);
64 
65     function MINIMUM_LIQUIDITY() external pure returns (uint);
66     function factory() external view returns (address);
67     function token0() external view returns (address);
68     function token1() external view returns (address);
69     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
70     function price0CumulativeLast() external view returns (uint);
71     function price1CumulativeLast() external view returns (uint);
72     function kLast() external view returns (uint);
73 
74     function mint(address to) external returns (uint liquidity);
75     function burn(address to) external returns (uint amount0, uint amount1);
76     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
77     function skim(address to) external;
78     function sync() external;
79 
80     function initialize(address, address) external;
81 }
82 
83 interface IUniswapV2Factory {
84     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
85 
86     function feeTo() external view returns (address);
87     function feeToSetter() external view returns (address);
88 
89     function getPair(address tokenA, address tokenB) external view returns (address pair);
90     function allPairs(uint) external view returns (address pair);
91     function allPairsLength() external view returns (uint);
92 
93     function createPair(address tokenA, address tokenB) external returns (address pair);
94 
95     function setFeeTo(address) external;
96     function setFeeToSetter(address) external;
97 }
98 
99 interface IERC20 {
100     /**
101      * @dev Returns the amount of tokens in existence.
102      */
103     function totalSupply() external view returns (uint256);
104 
105     /**
106      * @dev Returns the amount of tokens owned by `account`.
107      */
108     function balanceOf(address account) external view returns (uint256);
109 
110     /**
111      * @dev Moves `amount` tokens from the caller's account to `recipient`.
112      *
113      * Returns a boolean value indicating whether the operation succeeded.
114      *
115      * Emits a {Transfer} event.
116      */
117     function transfer(address recipient, uint256 amount) external returns (bool);
118 
119     /**
120      * @dev Returns the remaining number of tokens that `spender` will be
121      * allowed to spend on behalf of `owner` through {transferFrom}. This is
122      * zero by default.
123      *
124      * This value changes when {approve} or {transferFrom} are called.
125      */
126     function allowance(address owner, address spender) external view returns (uint256);
127 
128     /**
129      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
130      *
131      * Returns a boolean value indicating whether the operation succeeded.
132      *
133      * IMPORTANT: Beware that changing an allowance with this method brings the risk
134      * that someone may use both the old and the new allowance by unfortunate
135      * transacgtion ordering. One possible solution to mitigate this race
136      * condition is to first reduce the spender's allowance to 0 and set the
137      * desired value afterwards:
138      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
139      *
140      * Emits an {Approval} event.
141      */
142     function approve(address spender, uint256 amount) external returns (bool);
143 
144     /**
145      * @dev Moves `amount` tokens from `sender` to `recipient` using the
146      * allowance mechanism. `amount` is then deducted from the caller's
147      * allowance.
148      *
149      * Returns a boolean value indicating whether the operation succeeded.
150      *
151      * Emits a {Transfer} event.
152      */
153     function transferFrom(
154         address sender,
155         address recipient,
156         uint256 amount
157     ) external returns (bool);
158 
159     /**
160      * @dev Emitted when `value` tokens are moved from one account (`from`) to
161      * another (`to`).
162      *
163      * Note that `value` may be zero.
164      */
165     event Transfer(address indexed from, address indexed to, uint256 value);
166 
167     /**
168      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
169      * a call to {approve}. `value` is the new allowance.
170      */
171     event Approval(address indexed owner, address indexed spender, uint256 value);
172 }
173 
174 interface IERC20Metadata is IERC20 {
175     /**
176      * @dev Returns the name of the token.
177      */
178     function name() external view returns (string memory);
179 
180     /**
181      * @dev Returns the symbol of the token.
182      */
183     function symbol() external view returns (string memory);
184 
185     /**
186      * @dev Returns the decimals places of the token.
187      */
188     function decimals() external view returns (uint8);
189 }
190 
191 
192 contract ERC20 is Context, IERC20, IERC20Metadata {
193     using SafeMath for uint256;
194 
195     mapping(address => uint256) private _balances;
196 
197     mapping(address => mapping(address => uint256)) private _allowances;
198 
199     uint256 private _totalSupply;
200 
201     string private _name;
202     string private _symbol;
203 
204     /**
205      * @dev Sets the values for {name} and {symbol}.
206      *
207      * The default value of {decimals} is 18. To select a different value for
208      * {decimals} you should overload it.
209      *
210      * All two of these values are immutable: they can only be set once during
211      * construction.
212      */
213     constructor(string memory name_, string memory symbol_) {
214         _name = name_;
215         _symbol = symbol_;
216     }
217 
218     /**
219      * @dev Returns the name of the token.
220      */
221     function name() public view virtual override returns (string memory) {
222         return _name;
223     }
224 
225     /**
226      * @dev Returns the symbol of the token, usually a shorter version of the
227      * name.
228      */
229     function symbol() public view virtual override returns (string memory) {
230         return _symbol;
231     }
232 
233     /**
234      * @dev Returns the number of decimals used to get its user representation.
235      * For example, if `decimals` equals `2`, a balance of `505` tokens should
236      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
237      *
238      * Tokens usually opt for a value of 18, imitating the relationship between
239      * Ether and Wei. This is the value {ERC20} uses, unless this function is
240      * overridden;
241      *
242      * NOTE: This information is only used for _display_ purposes: it in
243      * no way affects any of the arithmetic of the contract, including
244      * {IERC20-balanceOf} and {IERC20-transfer}.
245      */
246     function decimals() public view virtual override returns (uint8) {
247         return 18;
248     }
249 
250     /**
251      * @dev See {IERC20-totalSupply}.
252      */
253     function totalSupply() public view virtual override returns (uint256) {
254         return _totalSupply;
255     }
256 
257     /**
258      * @dev See {IERC20-balanceOf}.
259      */
260     function balanceOf(address account) public view virtual override returns (uint256) {
261         return _balances[account];
262     }
263 
264     /**
265      * @dev See {IERC20-transfer}.
266      *
267      * Requirements:
268      *
269      * - `recipient` cannot be the zero address.
270      * - the caller must have a balance of at least `amount`.
271      */
272     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
273         _transfer(_msgSender(), recipient, amount);
274         return true;
275     }
276 
277     /**
278      * @dev See {IERC20-allowance}.
279      */
280     function allowance(address owner, address spender) public view virtual override returns (uint256) {
281         return _allowances[owner][spender];
282     }
283 
284     /**
285      * @dev See {IERC20-approve}.
286      *
287      * Requirements:
288      *
289      * - `spender` cannot be the zero address.
290      */
291     function approve(address spender, uint256 amount) public virtual override returns (bool) {
292         _approve(_msgSender(), spender, amount);
293         return true;
294     }
295 
296     /**
297      * @dev See {IERC20-transferFrom}.
298      *
299      * Emits an {Approval} event indicating the updated allowance. This is not
300      * required by the EIP. See the note at the beginning of {ERC20}.
301      *
302      * Requirements:
303      *
304      * - `sender` and `recipient` cannot be the zero address.
305      * - `sender` must have a balance of at least `amount`.
306      * - the caller must have allowance for ``sender``'s tokens of at least
307      * `amount`.
308      */
309     function transferFrom(
310         address sender,
311         address recipient,
312         uint256 amount
313     ) public virtual override returns (bool) {
314         _transfer(sender, recipient, amount);
315         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
316         return true;
317     }
318 
319     /**
320      * @dev Atomically increases the allowance granted to `spender` by the caller.
321      *
322      * This is an alternative to {approve} that can be used as a mitigation for
323      * problems described in {IERC20-approve}.
324      *
325      * Emits an {Approval} event indicating the updated allowance.
326      *
327      * Requirements:
328      *
329      * - `spender` cannot be the zero address.
330      */
331     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
332         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
333         return true;
334     }
335 
336     /**
337      * @dev Atomically decreases the allowance granted to `spender` by the caller.
338      *
339      * This is an alternative to {approve} that can be used as a mitigation for
340      * problems described in {IERC20-approve}.
341      *
342      * Emits an {Approval} event indicating the updated allowance.
343      *
344      * Requirements:
345      *
346      * - `spender` cannot be the zero address.
347      * - `spender` must have allowance for the caller of at least
348      * `subtractedValue`.
349      */
350     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
351         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
352         return true;
353     }
354 
355     /**
356      * @dev Moves tokens `amount` from `sender` to `recipient`.
357      *
358      * This is internal function is equivalent to {transfer}, and can be used to
359      * e.g. implement automatic token fees, slashing mechanisms, etc.
360      *
361      * Emits a {Transfer} event.
362      *
363      * Requirements:
364      *
365      * - `sender` cannot be the zero address.
366      * - `recipient` cannot be the zero address.
367      * - `sender` must have a balance of at least `amount`.
368      */
369     function _transfer(
370         address sender,
371         address recipient,
372         uint256 amount
373     ) internal virtual {
374         require(sender != address(0), "ERC20: transfer from the zero address");
375         require(recipient != address(0), "ERC20: transfer to the zero address");
376 
377         _beforeTokenTransfer(sender, recipient, amount);
378 
379         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
380         _balances[recipient] = _balances[recipient].add(amount);
381         emit Transfer(sender, recipient, amount);
382     }
383 
384     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
385      * the total supply.
386      *
387      * Emits a {Transfer} event with `from` set to the zero address.
388      *
389      * Requirements:
390      *
391      * - `account` cannot be the zero address.
392      */
393     function _mint(address account, uint256 amount) internal virtual {
394         require(account != address(0), "ERC20: mint to the zero address");
395 
396         _beforeTokenTransfer(address(0), account, amount);
397 
398         _totalSupply = _totalSupply.add(amount);
399         _balances[account] = _balances[account].add(amount);
400         emit Transfer(address(0), account, amount);
401     }
402 
403     /**
404      * @dev Destroys `amount` tokens from `account`, reducing the
405      * total supply.
406      *
407      * Emits a {Transfer} event with `to` set to the zero address.
408      *
409      * Requirements:
410      *
411      * - `account` cannot be the zero address.
412      * - `account` must have at least `amount` tokens.
413      */
414     function _burn(address account, uint256 amount) internal virtual {
415         require(account != address(0), "ERC20: burn from the zero address");
416 
417         _beforeTokenTransfer(account, address(0), amount);
418 
419         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
420         _totalSupply = _totalSupply.sub(amount);
421         emit Transfer(account, address(0), amount);
422     }
423 
424     /**
425      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
426      *
427      * This internal function is equivalent to `approve`, and can be used to
428      * e.g. set automatic allowances for certain subsystems, etc.
429      *
430      * Emits an {Approval} event.
431      *
432      * Requirements:
433      *
434      * - `owner` cannot be the zero address.
435      * - `spender` cannot be the zero address.
436      */
437     function _approve(
438         address owner,
439         address spender,
440         uint256 amount
441     ) internal virtual {
442         require(owner != address(0), "ERC20: approve from the zero address");
443         require(spender != address(0), "ERC20: approve to the zero address");
444 
445         _allowances[owner][spender] = amount;
446         emit Approval(owner, spender, amount);
447     }
448 
449     /**
450      * @dev Hook that is called before any transfer of tokens. This includes
451      * minting and burning.
452      *
453      * Calling conditions:
454      *
455      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
456      * will be to transferred to `to`.
457      * - when `from` is zero, `amount` tokens will be minted for `to`.
458      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
459      * - `from` and `to` are never both zero.
460      *
461      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
462      */
463     function _beforeTokenTransfer(
464         address from,
465         address to,
466         uint256 amount
467     ) internal virtual {}
468 }
469 
470 library SafeMath {
471     /**
472      * @dev Returns the addition of two unsigned integers, reverting on
473      * overflow.
474      *
475      * Counterpart to Solidity's `+` operator.
476      *
477      * Requirements:
478      *
479      * - Addition cannot overflow.
480      */
481     function add(uint256 a, uint256 b) internal pure returns (uint256) {
482         uint256 c = a + b;
483         require(c >= a, "SafeMath: addition overflow");
484 
485         return c;
486     }
487 
488     /**
489      * @dev Returns the subtraction of two unsigned integers, reverting on
490      * overflow (when the result is negative).
491      *
492      * Counterpart to Solidity's `-` operator.
493      *
494      * Requirements:
495      *
496      * - Subtraction cannot overflow.
497      */
498     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
499         return sub(a, b, "SafeMath: subtraction overflow");
500     }
501 
502     /**
503      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
504      * overflow (when the result is negative).
505      *
506      * Counterpart to Solidity's `-` operator.
507      *
508      * Requirements:
509      *
510      * - Subtraction cannot overflow.
511      */
512     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
513         require(b <= a, errorMessage);
514         uint256 c = a - b;
515 
516         return c;
517     }
518 
519     /**
520      * @dev Returns the multiplication of two unsigned integers, reverting on
521      * overflow.
522      *
523      * Counterpart to Solidity's `*` operator.
524      *
525      * Requirements:
526      *
527      * - Multiplication cannot overflow.
528      */
529     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
530         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
531         // benefit is lost if 'b' is also tested.
532         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
533         if (a == 0) {
534             return 0;
535         }
536 
537         uint256 c = a * b;
538         require(c / a == b, "SafeMath: multiplication overflow");
539 
540         return c;
541     }
542 
543     /**
544      * @dev Returns the integer division of two unsigned integers. Reverts on
545      * division by zero. The result is rounded towards zero.
546      *
547      * Counterpart to Solidity's `/` operator. Note: this function uses a
548      * `revert` opcode (which leaves remaining gas untouched) while Solidity
549      * uses an invalid opcode to revert (consuming all remaining gas).
550      *
551      * Requirements:
552      *
553      * - The divisor cannot be zero.
554      */
555     function div(uint256 a, uint256 b) internal pure returns (uint256) {
556         return div(a, b, "SafeMath: division by zero");
557     }
558 
559     /**
560      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
561      * division by zero. The result is rounded towards zero.
562      *
563      * Counterpart to Solidity's `/` operator. Note: this function uses a
564      * `revert` opcode (which leaves remaining gas untouched) while Solidity
565      * uses an invalid opcode to revert (consuming all remaining gas).
566      *
567      * Requirements:
568      *
569      * - The divisor cannot be zero.
570      */
571     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
572         require(b > 0, errorMessage);
573         uint256 c = a / b;
574         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
575 
576         return c;
577     }
578 
579     /**
580      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
581      * Reverts when dividing by zero.
582      *
583      * Counterpart to Solidity's `%` operator. This function uses a `revert`
584      * opcode (which leaves remaining gas untouched) while Solidity uses an
585      * invalid opcode to revert (consuming all remaining gas).
586      *
587      * Requirements:
588      *
589      * - The divisor cannot be zero.
590      */
591     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
592         return mod(a, b, "SafeMath: modulo by zero");
593     }
594 
595     /**
596      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
597      * Reverts with custom message when dividing by zero.
598      *
599      * Counterpart to Solidity's `%` operator. This function uses a `revert`
600      * opcode (which leaves remaining gas untouched) while Solidity uses an
601      * invalid opcode to revert (consuming all remaining gas).
602      *
603      * Requirements:
604      *
605      * - The divisor cannot be zero.
606      */
607     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
608         require(b != 0, errorMessage);
609         return a % b;
610     }
611 }
612 
613 contract Ownable is Context {
614     address private _owner;
615 
616     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
617     
618     /**
619      * @dev Initializes the contract setting the deployer as the initial owner.
620      */
621     constructor () {
622         address msgSender = _msgSender();
623         _owner = msgSender;
624         emit OwnershipTransferred(address(0), msgSender);
625     }
626 
627     /**
628      * @dev Returns the address of the current owner.
629      */
630     function owner() public view returns (address) {
631         return _owner;
632     }
633 
634     /**
635      * @dev Throws if called by any account other than the owner.
636      */
637     modifier onlyOwner() {
638         require(_owner == _msgSender(), "Ownable: caller is not the owner");
639         _;
640     }
641 
642     /**
643      * @dev Leaves the contract without owner. It will not be possible to call
644      * `onlyOwner` functions anymore. Can only be called by the current owner.
645      *
646      * NOTE: Renouncing ownership will leave the contract without an owner,
647      * thereby removing any functionality that is only available to the owner.
648      */
649     function renounceOwnership() public virtual onlyOwner {
650         emit OwnershipTransferred(_owner, address(0));
651         _owner = address(0);
652     }
653 
654     /**
655      * @dev Transfers ownership of the contract to a new account (`newOwner`).
656      * Can only be called by the current owner.
657      */
658     function transferOwnership(address newOwner) public virtual onlyOwner {
659         require(newOwner != address(0), "Ownable: new owner is the zero address");
660         emit OwnershipTransferred(_owner, newOwner);
661         _owner = newOwner;
662     }
663 }
664 
665 
666 
667 library SafeMathInt {
668     int256 private constant MIN_INT256 = int256(1) << 255;
669     int256 private constant MAX_INT256 = ~(int256(1) << 255);
670 
671     /**
672      * @dev Multiplies two int256 variables and fails on overflow.
673      */
674     function mul(int256 a, int256 b) internal pure returns (int256) {
675         int256 c = a * b;
676 
677         // Detect overflow when multiplying MIN_INT256 with -1
678         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
679         require((b == 0) || (c / b == a));
680         return c;
681     }
682 
683     /**
684      * @dev Division of two int256 variables and fails on overflow.
685      */
686     function div(int256 a, int256 b) internal pure returns (int256) {
687         // Prevent overflow when dividing MIN_INT256 by -1
688         require(b != -1 || a != MIN_INT256);
689 
690         // Solidity already throws when dividing by 0.
691         return a / b;
692     }
693 
694     /**
695      * @dev Subtracts two int256 variables and fails on overflow.
696      */
697     function sub(int256 a, int256 b) internal pure returns (int256) {
698         int256 c = a - b;
699         require((b >= 0 && c <= a) || (b < 0 && c > a));
700         return c;
701     }
702 
703     /**
704      * @dev Adds two int256 variables and fails on overflow.
705      */
706     function add(int256 a, int256 b) internal pure returns (int256) {
707         int256 c = a + b;
708         require((b >= 0 && c >= a) || (b < 0 && c < a));
709         return c;
710     }
711 
712     /**
713      * @dev Converts to absolute value, and fails on overflow.
714      */
715     function abs(int256 a) internal pure returns (int256) {
716         require(a != MIN_INT256);
717         return a < 0 ? -a : a;
718     }
719 
720 
721     function toUint256Safe(int256 a) internal pure returns (uint256) {
722         require(a >= 0);
723         return uint256(a);
724     }
725 }
726 
727 library SafeMathUint {
728   function toInt256Safe(uint256 a) internal pure returns (int256) {
729     int256 b = int256(a);
730     require(b >= 0);
731     return b;
732   }
733 }
734 
735 
736 interface IUniswapV2Router01 {
737     function factory() external pure returns (address);
738     function WETH() external pure returns (address);
739 
740     function addLiquidity(
741         address tokenA,
742         address tokenB,
743         uint amountADesired,
744         uint amountBDesired,
745         uint amountAMin,
746         uint amountBMin,
747         address to,
748         uint deadline
749     ) external returns (uint amountA, uint amountB, uint liquidity);
750     function addLiquidityETH(
751         address token,
752         uint amountTokenDesired,
753         uint amountTokenMin,
754         uint amountETHMin,
755         address to,
756         uint deadline
757     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
758     function removeLiquidity(
759         address tokenA,
760         address tokenB,
761         uint liquidity,
762         uint amountAMin,
763         uint amountBMin,
764         address to,
765         uint deadline
766     ) external returns (uint amountA, uint amountB);
767     function removeLiquidityETH(
768         address token,
769         uint liquidity,
770         uint amountTokenMin,
771         uint amountETHMin,
772         address to,
773         uint deadline
774     ) external returns (uint amountToken, uint amountETH);
775     function removeLiquidityWithPermit(
776         address tokenA,
777         address tokenB,
778         uint liquidity,
779         uint amountAMin,
780         uint amountBMin,
781         address to,
782         uint deadline,
783         bool approveMax, uint8 v, bytes32 r, bytes32 s
784     ) external returns (uint amountA, uint amountB);
785     function removeLiquidityETHWithPermit(
786         address token,
787         uint liquidity,
788         uint amountTokenMin,
789         uint amountETHMin,
790         address to,
791         uint deadline,
792         bool approveMax, uint8 v, bytes32 r, bytes32 s
793     ) external returns (uint amountToken, uint amountETH);
794     function swapExactTokensForTokens(
795         uint amountIn,
796         uint amountOutMin,
797         address[] calldata path,
798         address to,
799         uint deadline
800     ) external returns (uint[] memory amounts);
801     function swapTokensForExactTokens(
802         uint amountOut,
803         uint amountInMax,
804         address[] calldata path,
805         address to,
806         uint deadline
807     ) external returns (uint[] memory amounts);
808     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
809         external
810         payable
811         returns (uint[] memory amounts);
812     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
813         external
814         returns (uint[] memory amounts);
815     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
816         external
817         returns (uint[] memory amounts);
818     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
819         external
820         payable
821         returns (uint[] memory amounts);
822 
823     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
824     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
825     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
826     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
827     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
828 }
829 
830 interface IUniswapV2Router02 is IUniswapV2Router01 {
831     function removeLiquidityETHSupportingFeeOnTransferTokens(
832         address token,
833         uint liquidity,
834         uint amountTokenMin,
835         uint amountETHMin,
836         address to,
837         uint deadline
838     ) external returns (uint amountETH);
839     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
840         address token,
841         uint liquidity,
842         uint amountTokenMin,
843         uint amountETHMin,
844         address to,
845         uint deadline,
846         bool approveMax, uint8 v, bytes32 r, bytes32 s
847     ) external returns (uint amountETH);
848 
849     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
850         uint amountIn,
851         uint amountOutMin,
852         address[] calldata path,
853         address to,
854         uint deadline
855     ) external;
856     function swapExactETHForTokensSupportingFeeOnTransferTokens(
857         uint amountOutMin,
858         address[] calldata path,
859         address to,
860         uint deadline
861     ) external payable;
862     function swapExactTokensForETHSupportingFeeOnTransferTokens(
863         uint amountIn,
864         uint amountOutMin,
865         address[] calldata path,
866         address to,
867         uint deadline
868     ) external;
869 }
870 
871 contract CollieInu is ERC20, Ownable {
872     using SafeMath for uint256;
873 
874     IUniswapV2Router02 public immutable uniswapV2Router;
875     address public immutable uniswapV2Pair;
876     address public constant deadAddress = address(0xdead);
877 
878     bool private swapping;
879 
880     address public marketingWallet;
881     address public devWallet;
882     
883     uint256 public maxTransactionAmount;
884     uint256 public swapTokensAtAmount;
885     uint256 public maxWallet;
886     
887     uint256 public percentForLPBurn = 25; // 25 = .25%
888     bool public lpBurnEnabled = true;
889     uint256 public lpBurnFrequency = 3600 seconds;
890     uint256 public lastLpBurnTime;
891     
892     uint256 public manualBurnFrequency = 30 minutes;
893     uint256 public lastManualLpBurnTime;
894 
895     bool public limitsInEffect = true;
896     bool public tradingActive = false;
897     bool public swapEnabled = false;
898     
899      // Anti-bot and anti-whale mappings and variables
900     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
901     bool public transferDelayEnabled = true;
902 
903     uint256 public buyTotalFees;
904     uint256 public buyMarketingFee;
905     uint256 public buyLiquidityFee;
906     uint256 public buyDevFee;
907     
908     uint256 public sellTotalFees;
909     uint256 public sellMarketingFee;
910     uint256 public sellLiquidityFee;
911     uint256 public sellDevFee;
912     
913     uint256 public tokensForMarketing;
914     uint256 public tokensForLiquidity;
915     uint256 public tokensForDev;
916     
917     /******************/
918 
919     // exlcude from fees and max transaction amount
920     mapping (address => bool) private _isExcludedFromFees;
921     mapping (address => bool) public _isExcludedMaxTransactionAmount;
922 
923     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
924     // could be subject to a maximum transfer amount
925     mapping (address => bool) public automatedMarketMakerPairs;
926 
927     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
928 
929     event ExcludeFromFees(address indexed account, bool isExcluded);
930 
931     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
932 
933     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
934     
935     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
936 
937     event SwapAndLiquify(
938         uint256 tokensSwapped,
939         uint256 ethReceived,
940         uint256 tokensIntoLiquidity
941     );
942     
943     event AutoNukeLP();
944     
945     event ManualNukeLP();
946 
947     constructor() ERC20("COLLIE INU", "COLLIE") {
948         
949         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
950         
951         excludeFromMaxTransaction(address(_uniswapV2Router), true);
952         uniswapV2Router = _uniswapV2Router;
953         
954         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
955         excludeFromMaxTransaction(address(uniswapV2Pair), true);
956         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
957         
958         uint256 _buyMarketingFee = 5;
959         uint256 _buyLiquidityFee = 3;
960         uint256 _buyDevFee = 2;
961 
962         uint256 _sellMarketingFee = 4;
963         uint256 _sellLiquidityFee = 4;
964         uint256 _sellDevFee = 2;
965         
966         uint256 totalSupply = 1 * 1e12 * 1e18;
967         
968         //maxTransactionAmount = totalSupply * 5 / 1000; // 0.5% maxTransactionAmountTxn
969         maxTransactionAmount = 5000000000 * 1e18;
970         maxWallet = totalSupply * 5 / 1000; // 0.50% maxWallet
971         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.050% swap wallet
972 
973         buyMarketingFee = _buyMarketingFee;
974         buyLiquidityFee = _buyLiquidityFee;
975         buyDevFee = _buyDevFee;
976         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
977         
978         sellMarketingFee = _sellMarketingFee;
979         sellLiquidityFee = _sellLiquidityFee;
980         sellDevFee = _sellDevFee;
981         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
982         
983         marketingWallet = address(owner()); // set as marketing wallet
984         devWallet = address(owner()); // set as dev wallet
985 
986         // exclude from paying fees or having max transaction amount
987         excludeFromFees(owner(), true);
988         excludeFromFees(address(this), true);
989         excludeFromFees(address(0xdead), true);
990         
991         excludeFromMaxTransaction(owner(), true);
992         excludeFromMaxTransaction(address(this), true);
993         excludeFromMaxTransaction(address(0xdead), true);
994         
995         /*
996             _mint is an internal function in ERC20.sol that is only called here,
997             and CANNOT be called ever again
998         */
999         _mint(msg.sender, totalSupply);
1000     }
1001 
1002     receive() external payable {
1003 
1004   	}
1005 
1006     // once enabled, can never be turned off
1007     function enableTrading() external onlyOwner {
1008         tradingActive = true;
1009         swapEnabled = true;
1010         lastLpBurnTime = block.timestamp;
1011     }
1012     
1013     // remove limits after token is stable
1014     function removeLimits() external onlyOwner returns (bool){
1015         limitsInEffect = false;
1016         return true;
1017     }
1018     
1019     // disable Transfer delay - cannot be reenabled
1020     function disableTransferDelay() external onlyOwner returns (bool){
1021         transferDelayEnabled = false;
1022         return true;
1023     }
1024     
1025      // change the minimum amount of tokens to sell from fees
1026     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1027   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1028   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1029   	    swapTokensAtAmount = newAmount;
1030   	    return true;
1031   	}
1032     
1033     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1034         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1035         maxTransactionAmount = newNum * (10**18);
1036     }
1037 
1038     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1039         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1040         maxWallet = newNum * (10**18);
1041     }
1042     
1043     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1044         _isExcludedMaxTransactionAmount[updAds] = isEx;
1045     }
1046     
1047     // only use to disable contract sales if absolutely necessary (emergency use only)
1048     function updateSwapEnabled(bool enabled) external onlyOwner(){
1049         swapEnabled = enabled;
1050     }
1051     
1052     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1053         buyMarketingFee = _marketingFee;
1054         buyLiquidityFee = _liquidityFee;
1055         buyDevFee = _devFee;
1056         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1057         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1058     }
1059     
1060     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1061         sellMarketingFee = _marketingFee;
1062         sellLiquidityFee = _liquidityFee;
1063         sellDevFee = _devFee;
1064         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1065         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1066     }
1067 
1068     function excludeFromFees(address account, bool excluded) public onlyOwner {
1069         _isExcludedFromFees[account] = excluded;
1070         emit ExcludeFromFees(account, excluded);
1071     }
1072 
1073     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1074         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1075 
1076         _setAutomatedMarketMakerPair(pair, value);
1077     }
1078 
1079     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1080         automatedMarketMakerPairs[pair] = value;
1081 
1082         emit SetAutomatedMarketMakerPair(pair, value);
1083     }
1084 
1085     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1086         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1087         marketingWallet = newMarketingWallet;
1088     }
1089     
1090     function updateDevWallet(address newWallet) external onlyOwner {
1091         emit devWalletUpdated(newWallet, devWallet);
1092         devWallet = newWallet;
1093     }
1094     
1095     
1096 
1097     function isExcludedFromFees(address account) public view returns(bool) {
1098         return _isExcludedFromFees[account];
1099     }
1100 
1101         //Use this in case BNB are sent to the contract by mistake
1102     function rescueBNB(uint256 weiAmount) external onlyOwner{
1103         require(address(this).balance >= weiAmount, "insufficient BNB balance");
1104         payable(msg.sender).transfer(weiAmount);
1105     }
1106 
1107     function rescueAnyBEP20Tokens(address _tokenAddr, address _to, uint _amount) public onlyOwner {
1108         IERC20(_tokenAddr).transfer(_to, _amount);
1109     }
1110 
1111     
1112     event BoughtEarly(address indexed sniper);
1113 
1114     function _transfer(
1115         address from,
1116         address to,
1117         uint256 amount
1118     ) internal override {
1119         require(from != address(0), "ERC20: transfer from the zero address");
1120         require(to != address(0), "ERC20: transfer to the zero address");
1121         
1122          if(amount == 0) {
1123             super._transfer(from, to, 0);
1124             return;
1125         }
1126         
1127         if(limitsInEffect){
1128             if (
1129                 from != owner() &&
1130                 to != owner() &&
1131                 to != address(0) &&
1132                 to != address(0xdead) &&
1133                 !swapping
1134             ){
1135                 if(!tradingActive){
1136                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1137                 }
1138 
1139                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1140                 if (transferDelayEnabled){
1141                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1142                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1143                         _holderLastTransferTimestamp[tx.origin] = block.number;
1144                     }
1145                 }
1146                  
1147                 //when buy
1148                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1149                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1150                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1151                 }
1152                 
1153                 //when sell
1154                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1155                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1156                 }
1157                 else if(!_isExcludedMaxTransactionAmount[to]){
1158                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1159                 }
1160             }
1161         }
1162         
1163         
1164         
1165 		uint256 contractTokenBalance = balanceOf(address(this));
1166         
1167         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1168 
1169         if( 
1170             canSwap &&
1171             swapEnabled &&
1172             !swapping &&
1173             !automatedMarketMakerPairs[from] &&
1174             !_isExcludedFromFees[from] &&
1175             !_isExcludedFromFees[to]
1176         ) {
1177             swapping = true;
1178             
1179             swapBack();
1180 
1181             swapping = false;
1182         }
1183         
1184         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1185             autoBurnLiquidityPairTokens();
1186         }
1187 
1188         bool takeFee = !swapping;
1189 
1190         // if any account belongs to _isExcludedFromFee account then remove the fee
1191         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1192             takeFee = false;
1193         }
1194         
1195         uint256 fees = 0;
1196         // only take fees on buys/sells, do not take on wallet transfers
1197         if(takeFee){
1198             // on sell
1199             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1200                 fees = amount.mul(sellTotalFees).div(100);
1201                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1202                 tokensForDev += fees * sellDevFee / sellTotalFees;
1203                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1204             }
1205             // on buy
1206             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1207         	    fees = amount.mul(buyTotalFees).div(100);
1208         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1209                 tokensForDev += fees * buyDevFee / buyTotalFees;
1210                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1211             }
1212             
1213             if(fees > 0){    
1214                 super._transfer(from, address(this), fees);
1215             }
1216         	
1217         	amount -= fees;
1218         }
1219 
1220         super._transfer(from, to, amount);
1221     }
1222 
1223     function swapTokensForEth(uint256 tokenAmount) private {
1224 
1225         // generate the uniswap pair path of token -> weth
1226         address[] memory path = new address[](2);
1227         path[0] = address(this);
1228         path[1] = uniswapV2Router.WETH();
1229 
1230         _approve(address(this), address(uniswapV2Router), tokenAmount);
1231 
1232         // make the swap
1233         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1234             tokenAmount,
1235             0, // accept any amount of ETH
1236             path,
1237             address(this),
1238             block.timestamp
1239         );
1240         
1241     }
1242     
1243     
1244     
1245     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1246         // approve token transfer to cover all possible scenarios
1247         _approve(address(this), address(uniswapV2Router), tokenAmount);
1248 
1249         // add the liquidity
1250         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1251             address(this),
1252             tokenAmount,
1253             0, // slippage is unavoidable
1254             0, // slippage is unavoidable
1255             deadAddress,
1256             block.timestamp
1257         );
1258     }
1259 
1260     function swapBack() private {
1261         uint256 contractBalance = balanceOf(address(this));
1262         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1263         bool success;
1264         
1265         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1266 
1267         if(contractBalance > swapTokensAtAmount * 20){
1268           contractBalance = swapTokensAtAmount * 20;
1269         }
1270         
1271         // Halve the amount of liquidity tokens
1272         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1273         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1274         
1275         uint256 initialETHBalance = address(this).balance;
1276 
1277         swapTokensForEth(amountToSwapForETH); 
1278         
1279         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1280         
1281         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1282         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1283         
1284         
1285         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1286         
1287         
1288         tokensForLiquidity = 0;
1289         tokensForMarketing = 0;
1290         tokensForDev = 0;
1291         
1292         (success,) = address(devWallet).call{value: ethForDev}("");
1293         
1294         if(liquidityTokens > 0 && ethForLiquidity > 0){
1295             addLiquidity(liquidityTokens, ethForLiquidity);
1296             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1297         }
1298         
1299         
1300         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1301     }
1302     
1303     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1304         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1305         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1306         lpBurnFrequency = _frequencyInSeconds;
1307         percentForLPBurn = _percent;
1308         lpBurnEnabled = _Enabled;
1309     }
1310     
1311     function autoBurnLiquidityPairTokens() internal returns (bool){
1312         
1313         lastLpBurnTime = block.timestamp;
1314         
1315         // get balance of liquidity pair
1316         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1317         
1318         // calculate amount to burn
1319         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1320         
1321         // pull tokens from pancakePair liquidity and move to dead address permanently
1322         if (amountToBurn > 0){
1323             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1324         }
1325         
1326         //sync price since this is not in a swap transaction!
1327         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1328         pair.sync();
1329         emit AutoNukeLP();
1330         return true;
1331     }
1332 }