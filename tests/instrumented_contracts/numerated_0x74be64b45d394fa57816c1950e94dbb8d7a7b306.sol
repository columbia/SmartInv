1 /*
2 
3 https://t.me/GiveWellInu
4 
5 VB tweet - https://twitter.com/vitalikbuterin/status/1590473524220952577?s=46&t=M-p6nvBmOjFV_I4z8IjOrg
6 
7 Taxes are 3% on buys and 3% on sells. 2% per swap goes to GiveWell.org, 1% per swap will be added to the LP.
8 
9 Their ETH wallet address can be found here: (0x7cF2eBb5Ca55A8bd671A020F8BDbAF07f60F26C1)
10 https://www.givewell.org/about/donate/cryptocurrency 
11 
12 As of the time of this launch over 13ETH ($16K USD) has already been donated to GiveWell by the GINU team.
13 
14 http://Twitter.com/GiveWell_Inu
15 
16 */
17 
18 // SPDX-License-Identifier: Unlicensed
19 
20 pragma solidity 0.8.9;
21 
22 abstract contract Context {
23     function _msgSender() internal view virtual returns (address) {
24         return msg.sender;
25     }
26 
27     function _msgData() internal view virtual returns (bytes calldata) {
28         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
29         return msg.data;
30     }
31 }
32 
33 interface IUniswapV2Pair {
34     event Approval(address indexed owner, address indexed spender, uint value);
35     event Transfer(address indexed from, address indexed to, uint value);
36 
37     function name() external pure returns (string memory);
38     function symbol() external pure returns (string memory);
39     function decimals() external pure returns (uint8);
40     function totalSupply() external view returns (uint);
41     function balanceOf(address owner) external view returns (uint);
42     function allowance(address owner, address spender) external view returns (uint);
43 
44     function approve(address spender, uint value) external returns (bool);
45     function transfer(address to, uint value) external returns (bool);
46     function transferFrom(address from, address to, uint value) external returns (bool);
47 
48     function DOMAIN_SEPARATOR() external view returns (bytes32);
49     function PERMIT_TYPEHASH() external pure returns (bytes32);
50     function nonces(address owner) external view returns (uint);
51 
52     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
53 
54     event Mint(address indexed sender, uint amount0, uint amount1);
55     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
56     event Swap(
57         address indexed sender,
58         uint amount0In,
59         uint amount1In,
60         uint amount0Out,
61         uint amount1Out,
62         address indexed to
63     );
64     event Sync(uint112 reserve0, uint112 reserve1);
65 
66     function MINIMUM_LIQUIDITY() external pure returns (uint);
67     function factory() external view returns (address);
68     function token0() external view returns (address);
69     function token1() external view returns (address);
70     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
71     function price0CumulativeLast() external view returns (uint);
72     function price1CumulativeLast() external view returns (uint);
73     function kLast() external view returns (uint);
74 
75     function mint(address to) external returns (uint liquidity);
76     function burn(address to) external returns (uint amount0, uint amount1);
77     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
78     function skim(address to) external;
79     function sync() external;
80 
81     function initialize(address, address) external;
82 }
83 
84 interface IUniswapV2Factory {
85     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
86 
87     function feeTo() external view returns (address);
88     function feeToSetter() external view returns (address);
89 
90     function getPair(address tokenA, address tokenB) external view returns (address pair);
91     function allPairs(uint) external view returns (address pair);
92     function allPairsLength() external view returns (uint);
93 
94     function createPair(address tokenA, address tokenB) external returns (address pair);
95 
96     function setFeeTo(address) external;
97     function setFeeToSetter(address) external;
98 }
99 
100 interface IERC20 {
101     /**
102      * @dev Returns the amount of tokens in existence.
103      */
104     function totalSupply() external view returns (uint256);
105 
106     /**
107      * @dev Returns the amount of tokens owned by `account`.
108      */
109     function balanceOf(address account) external view returns (uint256);
110 
111     /**
112      * @dev Moves `amount` tokens from the caller's account to `recipient`.
113      *
114      * Returns a boolean value indicating whether the operation succeeded.
115      *
116      * Emits a {Transfer} event.
117      */
118     function transfer(address recipient, uint256 amount) external returns (bool);
119 
120     /**
121      * @dev Returns the remaining number of tokens that `spender` will be
122      * allowed to spend on behalf of `owner` through {transferFrom}. This is
123      * zero by default.
124      *
125      * This value changes when {approve} or {transferFrom} are called.
126      */
127     function allowance(address owner, address spender) external view returns (uint256);
128 
129     /**
130      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
131      *
132      * Returns a boolean value indicating whether the operation succeeded.
133      *
134      * IMPORTANT: Beware that changing an allowance with this method brings the risk
135      * that someone may use both the old and the new allowance by unfortunate
136      * transaction ordering. One possible solution to mitigate this race
137      * condition is to first reduce the spender's allowance to 0 and set the
138      * desired value afterwards:
139      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
140      *
141      * Emits an {Approval} event.
142      */
143     function approve(address spender, uint256 amount) external returns (bool);
144 
145     /**
146      * @dev Moves `amount` tokens from `sender` to `recipient` using the
147      * allowance mechanism. `amount` is then deducted from the caller's
148      * allowance.
149      *
150      * Returns a boolean value indicating whether the operation succeeded.
151      *
152      * Emits a {Transfer} event.
153      */
154     function transferFrom(
155         address sender,
156         address recipient,
157         uint256 amount
158     ) external returns (bool);
159 
160     /**
161      * @dev Emitted when `value` tokens are moved from one account (`from`) to
162      * another (`to`).
163      *
164      * Note that `value` may be zero.
165      */
166     event Transfer(address indexed from, address indexed to, uint256 value);
167 
168     /**
169      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
170      * a call to {approve}. `value` is the new allowance.
171      */
172     event Approval(address indexed owner, address indexed spender, uint256 value);
173 }
174 
175 interface IERC20Metadata is IERC20 {
176     /**
177      * @dev Returns the name of the token.
178      */
179     function name() external view returns (string memory);
180 
181     /**
182      * @dev Returns the symbol of the token.
183      */
184     function symbol() external view returns (string memory);
185 
186     /**
187      * @dev Returns the decimals places of the token.
188      */
189     function decimals() external view returns (uint8);
190 }
191 
192 
193 contract ERC20 is Context, IERC20, IERC20Metadata {
194     using SafeMath for uint256;
195 
196     mapping(address => uint256) private _balances;
197 
198     mapping(address => mapping(address => uint256)) private _allowances;
199 
200     uint256 private _totalSupply;
201 
202     string private _name;
203     string private _symbol;
204 
205     /**
206      * @dev Sets the values for {name} and {symbol}.
207      *
208      * The default value of {decimals} is 18. To select a different value for
209      * {decimals} you should overload it.
210      *
211      * All two of these values are immutable: they can only be set once during
212      * construction.
213      */
214     constructor(string memory name_, string memory symbol_) {
215         _name = name_;
216         _symbol = symbol_;
217     }
218 
219     /**
220      * @dev Returns the name of the token.
221      */
222     function name() public view virtual override returns (string memory) {
223         return _name;
224     }
225 
226     /**
227      * @dev Returns the symbol of the token, usually a shorter version of the
228      * name.
229      */
230     function symbol() public view virtual override returns (string memory) {
231         return _symbol;
232     }
233 
234     /**
235      * @dev Returns the number of decimals used to get its user representation.
236      * For example, if `decimals` equals `2`, a balance of `505` tokens should
237      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
238      *
239      * Tokens usually opt for a value of 18, imitating the relationship between
240      * Ether and Wei. This is the value {ERC20} uses, unless this function is
241      * overridden;
242      *
243      * NOTE: This information is only used for _display_ purposes: it in
244      * no way affects any of the arithmetic of the contract, including
245      * {IERC20-balanceOf} and {IERC20-transfer}.
246      */
247     function decimals() public view virtual override returns (uint8) {
248         return 9;
249     }
250 
251     /**
252      * @dev See {IERC20-totalSupply}.
253      */
254     function totalSupply() public view virtual override returns (uint256) {
255         return _totalSupply;
256     }
257 
258     /**
259      * @dev See {IERC20-balanceOf}.
260      */
261     function balanceOf(address account) public view virtual override returns (uint256) {
262         return _balances[account];
263     }
264 
265     /**
266      * @dev See {IERC20-transfer}.
267      *
268      * Requirements:
269      *
270      * - `recipient` cannot be the zero address.
271      * - the caller must have a balance of at least `amount`.
272      */
273     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
274         _transfer(_msgSender(), recipient, amount);
275         return true;
276     }
277 
278     /**
279      * @dev See {IERC20-allowance}.
280      */
281     function allowance(address owner, address spender) public view virtual override returns (uint256) {
282         return _allowances[owner][spender];
283     }
284 
285     /**
286      * @dev See {IERC20-approve}.
287      *
288      * Requirements:
289      *
290      * - `spender` cannot be the zero address.
291      */
292     function approve(address spender, uint256 amount) public virtual override returns (bool) {
293         _approve(_msgSender(), spender, amount);
294         return true;
295     }
296 
297     /**
298      * @dev See {IERC20-transferFrom}.
299      *
300      * Emits an {Approval} event indicating the updated allowance. This is not
301      * required by the EIP. See the note at the beginning of {ERC20}.
302      *
303      * Requirements:
304      *
305      * - `sender` and `recipient` cannot be the zero address.
306      * - `sender` must have a balance of at least `amount`.
307      * - the caller must have allowance for ``sender``'s tokens of at least
308      * `amount`.
309      */
310     function transferFrom(
311         address sender,
312         address recipient,
313         uint256 amount
314     ) public virtual override returns (bool) {
315         _transfer(sender, recipient, amount);
316         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
317         return true;
318     }
319 
320     /**
321      * @dev Atomically increases the allowance granted to `spender` by the caller.
322      *
323      * This is an alternative to {approve} that can be used as a mitigation for
324      * problems described in {IERC20-approve}.
325      *
326      * Emits an {Approval} event indicating the updated allowance.
327      *
328      * Requirements:
329      *
330      * - `spender` cannot be the zero address.
331      */
332     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
333         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
334         return true;
335     }
336 
337     /**
338      * @dev Atomically decreases the allowance granted to `spender` by the caller.
339      *
340      * This is an alternative to {approve} that can be used as a mitigation for
341      * problems described in {IERC20-approve}.
342      *
343      * Emits an {Approval} event indicating the updated allowance.
344      *
345      * Requirements:
346      *
347      * - `spender` cannot be the zero address.
348      * - `spender` must have allowance for the caller of at least
349      * `subtractedValue`.
350      */
351     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
352         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
353         return true;
354     }
355 
356     /**
357      * @dev Moves tokens `amount` from `sender` to `recipient`.
358      *
359      * This is internal function is equivalent to {transfer}, and can be used to
360      * e.g. implement automatic token fees, slashing mechanisms, etc.
361      *
362      * Emits a {Transfer} event.
363      *
364      * Requirements:
365      *
366      * - `sender` cannot be the zero address.
367      * - `recipient` cannot be the zero address.
368      * - `sender` must have a balance of at least `amount`.
369      */
370     function _transfer(
371         address sender,
372         address recipient,
373         uint256 amount
374     ) internal virtual {
375         require(sender != address(0), "ERC20: transfer from the zero address");
376         require(recipient != address(0), "ERC20: transfer to the zero address");
377 
378         _beforeTokenTransfer(sender, recipient, amount);
379 
380         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
381         _balances[recipient] = _balances[recipient].add(amount);
382         emit Transfer(sender, recipient, amount);
383     }
384 
385     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
386      * the total supply.
387      *
388      * Emits a {Transfer} event with `from` set to the zero address.
389      *
390      * Requirements:
391      *
392      * - `account` cannot be the zero address.
393      */
394     function _mint(address account, uint256 amount) internal virtual {
395         require(account != address(0), "ERC20: mint to the zero address");
396 
397         _beforeTokenTransfer(address(0), account, amount);
398 
399         _totalSupply = _totalSupply.add(amount);
400         _balances[account] = _balances[account].add(amount);
401         emit Transfer(address(0), account, amount);
402     }
403 
404     /**
405      * @dev Destroys `amount` tokens from `account`, reducing the
406      * total supply.
407      *
408      * Emits a {Transfer} event with `to` set to the zero address.
409      *
410      * Requirements:
411      *
412      * - `account` cannot be the zero address.
413      * - `account` must have at least `amount` tokens.
414      */
415     function _burn(address account, uint256 amount) internal virtual {
416         require(account != address(0), "ERC20: burn from the zero address");
417 
418         _beforeTokenTransfer(account, address(0), amount);
419 
420         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
421         _totalSupply = _totalSupply.sub(amount);
422         emit Transfer(account, address(0), amount);
423     }
424 
425     /**
426      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
427      *
428      * This internal function is equivalent to `approve`, and can be used to
429      * e.g. set automatic allowances for certain subsystems, etc.
430      *
431      * Emits an {Approval} event.
432      *
433      * Requirements:
434      *
435      * - `owner` cannot be the zero address.
436      * - `spender` cannot be the zero address.
437      */
438     function _approve(
439         address owner,
440         address spender,
441         uint256 amount
442     ) internal virtual {
443         require(owner != address(0), "ERC20: approve from the zero address");
444         require(spender != address(0), "ERC20: approve to the zero address");
445 
446         _allowances[owner][spender] = amount;
447         emit Approval(owner, spender, amount);
448     }
449 
450     /**
451      * @dev Hook that is called before any transfer of tokens. This includes
452      * minting and burning.
453      *
454      * Calling conditions:
455      *
456      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
457      * will be to transferred to `to`.
458      * - when `from` is zero, `amount` tokens will be minted for `to`.
459      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
460      * - `from` and `to` are never both zero.
461      *
462      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
463      */
464     function _beforeTokenTransfer(
465         address from,
466         address to,
467         uint256 amount
468     ) internal virtual {}
469 }
470 
471 library SafeMath {
472     /**
473      * @dev Returns the addition of two unsigned integers, reverting on
474      * overflow.
475      *
476      * Counterpart to Solidity's `+` operator.
477      *
478      * Requirements:
479      *
480      * - Addition cannot overflow.
481      */
482     function add(uint256 a, uint256 b) internal pure returns (uint256) {
483         uint256 c = a + b;
484         require(c >= a, "SafeMath: addition overflow");
485 
486         return c;
487     }
488 
489     /**
490      * @dev Returns the subtraction of two unsigned integers, reverting on
491      * overflow (when the result is negative).
492      *
493      * Counterpart to Solidity's `-` operator.
494      *
495      * Requirements:
496      *
497      * - Subtraction cannot overflow.
498      */
499     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
500         return sub(a, b, "SafeMath: subtraction overflow");
501     }
502 
503     /**
504      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
505      * overflow (when the result is negative).
506      *
507      * Counterpart to Solidity's `-` operator.
508      *
509      * Requirements:
510      *
511      * - Subtraction cannot overflow.
512      */
513     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
514         require(b <= a, errorMessage);
515         uint256 c = a - b;
516 
517         return c;
518     }
519 
520     /**
521      * @dev Returns the multiplication of two unsigned integers, reverting on
522      * overflow.
523      *
524      * Counterpart to Solidity's `*` operator.
525      *
526      * Requirements:
527      *
528      * - Multiplication cannot overflow.
529      */
530     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
531         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
532         // benefit is lost if 'b' is also tested.
533         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
534         if (a == 0) {
535             return 0;
536         }
537 
538         uint256 c = a * b;
539         require(c / a == b, "SafeMath: multiplication overflow");
540 
541         return c;
542     }
543 
544     /**
545      * @dev Returns the integer division of two unsigned integers. Reverts on
546      * division by zero. The result is rounded towards zero.
547      *
548      * Counterpart to Solidity's `/` operator. Note: this function uses a
549      * `revert` opcode (which leaves remaining gas untouched) while Solidity
550      * uses an invalid opcode to revert (consuming all remaining gas).
551      *
552      * Requirements:
553      *
554      * - The divisor cannot be zero.
555      */
556     function div(uint256 a, uint256 b) internal pure returns (uint256) {
557         return div(a, b, "SafeMath: division by zero");
558     }
559 
560     /**
561      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
562      * division by zero. The result is rounded towards zero.
563      *
564      * Counterpart to Solidity's `/` operator. Note: this function uses a
565      * `revert` opcode (which leaves remaining gas untouched) while Solidity
566      * uses an invalid opcode to revert (consuming all remaining gas).
567      *
568      * Requirements:
569      *
570      * - The divisor cannot be zero.
571      */
572     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
573         require(b > 0, errorMessage);
574         uint256 c = a / b;
575         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
576 
577         return c;
578     }
579 
580     /**
581      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
582      * Reverts when dividing by zero.
583      *
584      * Counterpart to Solidity's `%` operator. This function uses a `revert`
585      * opcode (which leaves remaining gas untouched) while Solidity uses an
586      * invalid opcode to revert (consuming all remaining gas).
587      *
588      * Requirements:
589      *
590      * - The divisor cannot be zero.
591      */
592     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
593         return mod(a, b, "SafeMath: modulo by zero");
594     }
595 
596     /**
597      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
598      * Reverts with custom message when dividing by zero.
599      *
600      * Counterpart to Solidity's `%` operator. This function uses a `revert`
601      * opcode (which leaves remaining gas untouched) while Solidity uses an
602      * invalid opcode to revert (consuming all remaining gas).
603      *
604      * Requirements:
605      *
606      * - The divisor cannot be zero.
607      */
608     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
609         require(b != 0, errorMessage);
610         return a % b;
611     }
612 }
613 
614 contract Ownable is Context {
615     address private _owner;
616 
617     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
618     
619     /**
620      * @dev Initializes the contract setting the deployer as the initial owner.
621      */
622     constructor () {
623         address msgSender = _msgSender();
624         _owner = msgSender;
625         emit OwnershipTransferred(address(0), msgSender);
626     }
627 
628     /**
629      * @dev Returns the address of the current owner.
630      */
631     function owner() public view returns (address) {
632         return _owner;
633     }
634 
635     /**
636      * @dev Throws if called by any account other than the owner.
637      */
638     modifier onlyOwner() {
639         require(_owner == _msgSender(), "Ownable: caller is not the owner");
640         _;
641     }
642 
643     /**
644      * @dev Leaves the contract without owner. It will not be possible to call
645      * `onlyOwner` functions anymore. Can only be called by the current owner.
646      *
647      * NOTE: Renouncing ownership will leave the contract without an owner,
648      * thereby removing any functionality that is only available to the owner.
649      */
650     function renounceOwnership() public virtual onlyOwner {
651         emit OwnershipTransferred(_owner, address(0));
652         _owner = address(0);
653     }
654 
655     /**
656      * @dev Transfers ownership of the contract to a new account (`newOwner`).
657      * Can only be called by the current owner.
658      */
659     function transferOwnership(address newOwner) public virtual onlyOwner {
660         require(newOwner != address(0), "Ownable: new owner is the zero address");
661         emit OwnershipTransferred(_owner, newOwner);
662         _owner = newOwner;
663     }
664 }
665 
666 
667 
668 library SafeMathInt {
669     int256 private constant MIN_INT256 = int256(1) << 255;
670     int256 private constant MAX_INT256 = ~(int256(1) << 255);
671 
672     /**
673      * @dev Multiplies two int256 variables and fails on overflow.
674      */
675     function mul(int256 a, int256 b) internal pure returns (int256) {
676         int256 c = a * b;
677 
678         // Detect overflow when multiplying MIN_INT256 with -1
679         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
680         require((b == 0) || (c / b == a));
681         return c;
682     }
683 
684     /**
685      * @dev Division of two int256 variables and fails on overflow.
686      */
687     function div(int256 a, int256 b) internal pure returns (int256) {
688         // Prevent overflow when dividing MIN_INT256 by -1
689         require(b != -1 || a != MIN_INT256);
690 
691         // Solidity already throws when dividing by 0.
692         return a / b;
693     }
694 
695     /**
696      * @dev Subtracts two int256 variables and fails on overflow.
697      */
698     function sub(int256 a, int256 b) internal pure returns (int256) {
699         int256 c = a - b;
700         require((b >= 0 && c <= a) || (b < 0 && c > a));
701         return c;
702     }
703 
704     /**
705      * @dev Adds two int256 variables and fails on overflow.
706      */
707     function add(int256 a, int256 b) internal pure returns (int256) {
708         int256 c = a + b;
709         require((b >= 0 && c >= a) || (b < 0 && c < a));
710         return c;
711     }
712 
713     /**
714      * @dev Converts to absolute value, and fails on overflow.
715      */
716     function abs(int256 a) internal pure returns (int256) {
717         require(a != MIN_INT256);
718         return a < 0 ? -a : a;
719     }
720 
721 
722     function toUint256Safe(int256 a) internal pure returns (uint256) {
723         require(a >= 0);
724         return uint256(a);
725     }
726 }
727 
728 library SafeMathUint {
729   function toInt256Safe(uint256 a) internal pure returns (int256) {
730     int256 b = int256(a);
731     require(b >= 0);
732     return b;
733   }
734 }
735 
736 
737 interface IUniswapV2Router01 {
738     function factory() external pure returns (address);
739     function WETH() external pure returns (address);
740 
741     function addLiquidity(
742         address tokenA,
743         address tokenB,
744         uint amountADesired,
745         uint amountBDesired,
746         uint amountAMin,
747         uint amountBMin,
748         address to,
749         uint deadline
750     ) external returns (uint amountA, uint amountB, uint liquidity);
751     function addLiquidityETH(
752         address token,
753         uint amountTokenDesired,
754         uint amountTokenMin,
755         uint amountETHMin,
756         address to,
757         uint deadline
758     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
759     function removeLiquidity(
760         address tokenA,
761         address tokenB,
762         uint liquidity,
763         uint amountAMin,
764         uint amountBMin,
765         address to,
766         uint deadline
767     ) external returns (uint amountA, uint amountB);
768     function removeLiquidityETH(
769         address token,
770         uint liquidity,
771         uint amountTokenMin,
772         uint amountETHMin,
773         address to,
774         uint deadline
775     ) external returns (uint amountToken, uint amountETH);
776     function removeLiquidityWithPermit(
777         address tokenA,
778         address tokenB,
779         uint liquidity,
780         uint amountAMin,
781         uint amountBMin,
782         address to,
783         uint deadline,
784         bool approveMax, uint8 v, bytes32 r, bytes32 s
785     ) external returns (uint amountA, uint amountB);
786     function removeLiquidityETHWithPermit(
787         address token,
788         uint liquidity,
789         uint amountTokenMin,
790         uint amountETHMin,
791         address to,
792         uint deadline,
793         bool approveMax, uint8 v, bytes32 r, bytes32 s
794     ) external returns (uint amountToken, uint amountETH);
795     function swapExactTokensForTokens(
796         uint amountIn,
797         uint amountOutMin,
798         address[] calldata path,
799         address to,
800         uint deadline
801     ) external returns (uint[] memory amounts);
802     function swapTokensForExactTokens(
803         uint amountOut,
804         uint amountInMax,
805         address[] calldata path,
806         address to,
807         uint deadline
808     ) external returns (uint[] memory amounts);
809     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
810         external
811         payable
812         returns (uint[] memory amounts);
813     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
814         external
815         returns (uint[] memory amounts);
816     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
817         external
818         returns (uint[] memory amounts);
819     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
820         external
821         payable
822         returns (uint[] memory amounts);
823 
824     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
825     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
826     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
827     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
828     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
829 }
830 
831 interface IUniswapV2Router02 is IUniswapV2Router01 {
832     function removeLiquidityETHSupportingFeeOnTransferTokens(
833         address token,
834         uint liquidity,
835         uint amountTokenMin,
836         uint amountETHMin,
837         address to,
838         uint deadline
839     ) external returns (uint amountETH);
840     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
841         address token,
842         uint liquidity,
843         uint amountTokenMin,
844         uint amountETHMin,
845         address to,
846         uint deadline,
847         bool approveMax, uint8 v, bytes32 r, bytes32 s
848     ) external returns (uint amountETH);
849 
850     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
851         uint amountIn,
852         uint amountOutMin,
853         address[] calldata path,
854         address to,
855         uint deadline
856     ) external;
857     function swapExactETHForTokensSupportingFeeOnTransferTokens(
858         uint amountOutMin,
859         address[] calldata path,
860         address to,
861         uint deadline
862     ) external payable;
863     function swapExactTokensForETHSupportingFeeOnTransferTokens(
864         uint amountIn,
865         uint amountOutMin,
866         address[] calldata path,
867         address to,
868         uint deadline
869     ) external;
870 }
871 
872 contract GiveWellInuV2 is ERC20, Ownable {
873     using SafeMath for uint256;
874 
875     IUniswapV2Router02 public immutable uniswapV2Router;
876     address public immutable uniswapV2Pair;
877     address public constant deadAddress = address(0xdead);
878 
879     bool private swapping;
880 
881     address public devWallet;
882     address public GiveWellWallet;
883 
884     uint8 constant _decimals = 9;
885     
886     uint256 public maxTransactionAmount;
887     uint256 public swapTokensAtAmount;
888     uint256 public maxWallet;
889 
890     bool public limitsInEffect = true;
891     bool public tradingActive = false;
892     bool public swapEnabled = false;
893 
894     bool public transferDelayEnabled = false;
895 
896     uint256 public buyTotalFees;
897     uint256 public buyLiquidityFee;
898     uint256 public buyGiveWellWalletFee;
899     
900     uint256 public sellTotalFees;
901     uint256 public sellLiquidityFee;
902     uint256 public sellGiveWellWalletFee;
903     
904     uint256 public tokensForLiquidity;
905     uint256 public tokensForGiveWellWallet;
906 
907     uint256 public walletDigit;
908     uint256 public transDigit;
909     uint256 public supply;
910     
911     /******************/
912 
913     // exlcude from fees and max transaction amount
914     mapping (address => bool) private _isExcludedFromFees;
915     mapping (address => bool) public _isExcludedMaxTransactionAmount;
916 
917     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
918     // could be subject to a maximum transfer amount
919     mapping (address => bool) public automatedMarketMakerPairs;
920 
921     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
922 
923     event ExcludeFromFees(address indexed account, bool isExcluded);
924 
925     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
926 
927     constructor() ERC20("GiveWell Inu", "GINU") {
928 
929         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
930         
931         excludeFromMaxTransaction(address(_uniswapV2Router), true);
932         uniswapV2Router = _uniswapV2Router;
933         
934         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
935         excludeFromMaxTransaction(address(uniswapV2Pair), true);
936         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
937         
938         uint256 _buyLiquidityFee = 1;
939         uint256 _buyGiveWellWalletFee = 2;
940 
941         uint256 _sellLiquidityFee = 1;
942         uint256 _sellGiveWellWalletFee = 2;
943         
944         uint256 totalSupply = 4 * 1e9 * 10 ** _decimals;
945         supply += totalSupply;
946         
947         walletDigit = 25;
948         transDigit = 25;
949 
950         maxTransactionAmount = supply * transDigit / 1000;
951         swapTokensAtAmount = supply * 75 / 100000; // 0.075% swap wallet;
952         maxWallet = supply * walletDigit / 1000;
953 
954         buyLiquidityFee = _buyLiquidityFee;
955         buyGiveWellWalletFee = _buyGiveWellWalletFee;
956         buyTotalFees = buyLiquidityFee + buyGiveWellWalletFee;
957         
958         sellLiquidityFee = _sellLiquidityFee;
959         sellGiveWellWalletFee = _sellGiveWellWalletFee;
960         sellTotalFees = sellLiquidityFee + sellGiveWellWalletFee;
961         
962         GiveWellWallet = 0x7cF2eBb5Ca55A8bd671A020F8BDbAF07f60F26C1; //set as GiveWell wallet
963 
964         // exclude from paying fees or having max transaction amount
965         excludeFromFees(owner(), true);
966         excludeFromFees(address(this), true);
967         excludeFromFees(address(0xdead), true);
968         
969         excludeFromMaxTransaction(owner(), true);
970         excludeFromMaxTransaction(address(this), true);
971         excludeFromMaxTransaction(address(0xdead), true);
972 
973         _approve(owner(), address(uniswapV2Router), totalSupply);
974 
975         _mint(msg.sender, 4 * 1e9 * 10 ** _decimals);
976 
977         tradingActive = false;
978         swapEnabled = false;
979 
980     }
981 
982     receive() external payable {
983 
984   	}
985 
986         // once enabled, can never be turned off
987     function enableTrading() external onlyOwner {
988         tradingActive = true;
989         swapEnabled = true;
990     }
991 
992     // remove limits after token is stable
993     function removeLimits() external onlyOwner returns (bool){
994         limitsInEffect = false;
995         return true;
996     }
997     
998      // change the minimum amount of tokens to sell from fees
999     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1000   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1001   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1002   	    swapTokensAtAmount = newAmount;
1003   	    return true;
1004   	}
1005     
1006     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1007         require(newNum >= (totalSupply() * 1 / 1000)/(10 ** _decimals), "Cannot set maxTransactionAmount lower than 0.1%");
1008         maxTransactionAmount = newNum * (10** _decimals);
1009     }
1010 
1011     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1012         require(newNum >= (totalSupply() * 5 / 1000)/(10 ** _decimals), "Cannot set maxWallet lower than 0.5%");
1013         maxWallet = newNum * (10** _decimals);
1014     }
1015     
1016     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1017         _isExcludedMaxTransactionAmount[updAds] = isEx;
1018     }
1019 
1020     function updateBuyFees(uint256 _liquidityFee, uint _buyGiveWellWalletFee) external onlyOwner {
1021         buyLiquidityFee = _liquidityFee;
1022         buyGiveWellWalletFee = _buyGiveWellWalletFee;
1023         buyTotalFees = buyLiquidityFee + buyGiveWellWalletFee;
1024         require(buyTotalFees <= 3, "Must keep fees at 3% or less");
1025     }
1026     
1027     function updateSellFees(uint256 _liquidityFee, uint _sellGiveWellWalletFee) external onlyOwner {
1028         sellLiquidityFee = _liquidityFee;
1029         sellGiveWellWalletFee = _sellGiveWellWalletFee;
1030         sellTotalFees = sellLiquidityFee + sellGiveWellWalletFee;
1031         require(sellTotalFees <= 3, "Must keep fees at 3% or less");
1032     }
1033 
1034     function excludeFromFees(address account, bool excluded) public onlyOwner {
1035         _isExcludedFromFees[account] = excluded;
1036         emit ExcludeFromFees(account, excluded);
1037     }
1038 
1039     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1040         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1041 
1042         _setAutomatedMarketMakerPair(pair, value);
1043     }
1044 
1045     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1046         automatedMarketMakerPairs[pair] = value;
1047 
1048         emit SetAutomatedMarketMakerPair(pair, value);
1049     }
1050 
1051     function updateDevWallet(address newWallet) external onlyOwner {
1052         devWallet = newWallet;
1053     }
1054 
1055     function updateGiveWellWallet(address newWallet) external onlyOwner {
1056         GiveWellWallet = newWallet;
1057     }
1058     
1059 
1060     function isExcludedFromFees(address account) public view returns(bool) {
1061         return _isExcludedFromFees[account];
1062     }
1063 
1064     function updateLimits() private {
1065         maxTransactionAmount = supply * transDigit / 100;
1066         swapTokensAtAmount = supply * 5 / 10000; // 0.05% swap wallet;
1067         maxWallet = supply * walletDigit / 100;
1068     }
1069 
1070 
1071     
1072     function _transfer(
1073         address from,
1074         address to,
1075         uint256 amount
1076     ) internal override {
1077         require(from != address(0), "ERC20: transfer from the zero address");
1078         require(to != address(0), "ERC20: transfer to the zero address");
1079         
1080          if(amount == 0) {
1081             super._transfer(from, to, 0);
1082             return;
1083         }
1084         
1085         if(limitsInEffect){
1086             if (
1087                 from != owner() &&
1088                 to != owner() &&
1089                 to != address(0) &&
1090                 to != address(0xdead) &&
1091                 !swapping
1092             ){
1093                 if(!tradingActive){
1094                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1095                 }
1096 
1097 
1098                 //when buy
1099                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1100                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1101                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1102                 }
1103                 
1104                 //when sell
1105                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1106                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1107                 }
1108                 else if(!_isExcludedMaxTransactionAmount[to]){
1109                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1110                 }
1111             }
1112         }
1113         
1114         
1115         
1116 		uint256 contractTokenBalance = balanceOf(address(this));
1117         
1118         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1119 
1120         if( 
1121             canSwap &&
1122             swapEnabled &&
1123             !swapping &&
1124             !automatedMarketMakerPairs[from] &&
1125             !_isExcludedFromFees[from] &&
1126             !_isExcludedFromFees[to]
1127         ) {
1128             swapping = true;
1129             
1130             swapBack();
1131 
1132             swapping = false;
1133         }
1134         
1135         bool takeFee = !swapping;
1136 
1137         // if any account belongs to _isExcludedFromFee account then remove the fee
1138         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1139             takeFee = false;
1140         }
1141         
1142         uint256 fees = 0;
1143         // only take fees on buys/sells, do not take on wallet transfers
1144         if(takeFee){
1145             // on sell
1146             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1147                 fees = amount.mul(sellTotalFees).div(100);
1148                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1149                 tokensForGiveWellWallet += fees * sellGiveWellWalletFee / sellTotalFees;
1150             }
1151             // on buy
1152             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1153         	    fees = amount.mul(buyTotalFees).div(100);
1154         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1155                 tokensForGiveWellWallet += fees * buyGiveWellWalletFee / buyTotalFees;
1156             }
1157             
1158             if(fees > 0){
1159                 super._transfer(from, address(this), fees);
1160             }
1161         	
1162         	amount -= fees;
1163         }
1164 
1165         super._transfer(from, to, amount);
1166     }
1167 
1168     function swapTokensForEth(uint256 tokenAmount) private {
1169 
1170         // generate the uniswap pair path of token -> weth
1171         address[] memory path = new address[](2);
1172         path[0] = address(this);
1173         path[1] = uniswapV2Router.WETH();
1174 
1175         _approve(address(this), address(uniswapV2Router), tokenAmount);
1176 
1177         // make the swap
1178         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1179             tokenAmount,
1180             0, // accept any amount of ETH
1181             path,
1182             address(this),
1183             block.timestamp
1184         );
1185         
1186     }
1187     
1188     
1189     
1190     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1191         // approve token transfer to cover all possible scenarios
1192         _approve(address(this), address(uniswapV2Router), tokenAmount);
1193 
1194         // add the liquidity
1195         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1196             address(this),
1197             tokenAmount,
1198             0, // slippage is unavoidable
1199             0, // slippage is unavoidable
1200             deadAddress,
1201             block.timestamp
1202         );
1203     }
1204 
1205     function swapBack() private {
1206         uint256 contractBalance = balanceOf(address(this));
1207         uint256 totalTokensToSwap = tokensForLiquidity + tokensForGiveWellWallet;
1208         bool success;
1209         
1210         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1211 
1212         if(contractBalance > swapTokensAtAmount * 5){
1213           contractBalance = swapTokensAtAmount * 5;
1214         }
1215         
1216         // Halve the amount of liquidity tokens
1217         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1218         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1219         
1220         uint256 initialETHBalance = address(this).balance;
1221 
1222         swapTokensForEth(amountToSwapForETH); 
1223         
1224         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1225         
1226         uint256 ethForGiveWell = ethBalance.mul(tokensForGiveWellWallet).div(totalTokensToSwap);
1227         
1228         uint256 ethForLiquidity = ethBalance - ethForGiveWell;
1229         
1230         
1231         tokensForLiquidity = 0;
1232         tokensForGiveWellWallet = 0;
1233         
1234         if(liquidityTokens > 0 && ethForLiquidity > 0){
1235             addLiquidity(liquidityTokens, ethForLiquidity);
1236         }
1237         
1238         (success,) = address(GiveWellWallet).call{value: address(this).balance}("");
1239     }
1240 
1241 
1242 }