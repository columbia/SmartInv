1 /*    Welcome To XMOSTAR
2 LAUNCHPAD | INCUBATOR | STAKING AS A SERVICE
3 
4 A sophisticated community driven launchpad!
5 
6 With unique tokenomic features:
7 Total Supply : 1,000,000,000 $XMO
8 Buy Tax : 10% | Sell Tax : 12% 
9 Max TX : 0.25% | Wallet Cap : 2%
10 Anti pre & post-IDO swing traders dump prevention :
11 > Double buy/sell tax for 24hr before and 24hr after IDO participation round.
12 The Stabilizer : Weekly buyback & burn feature.
13 
14 Join Us Now:
15 Website : https://xmostar.com/
16 Telegram : https://t.me/xmostar
17 */
18 
19 // SPDX-License-Identifier: MIT                                                                                                                                                             
20                                                     
21 pragma solidity 0.8.9;
22 
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes calldata) {
29         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30         return msg.data;
31     }
32 }
33 
34 interface IUniswapV2Pair {
35     event Approval(address indexed owner, address indexed spender, uint value);
36     event Transfer(address indexed from, address indexed to, uint value);
37 
38     function name() external pure returns (string memory);
39     function symbol() external pure returns (string memory);
40     function decimals() external pure returns (uint8);
41     function totalSupply() external view returns (uint);
42     function balanceOf(address owner) external view returns (uint);
43     function allowance(address owner, address spender) external view returns (uint);
44 
45     function approve(address spender, uint value) external returns (bool);
46     function transfer(address to, uint value) external returns (bool);
47     function transferFrom(address from, address to, uint value) external returns (bool);
48 
49     function DOMAIN_SEPARATOR() external view returns (bytes32);
50     function PERMIT_TYPEHASH() external pure returns (bytes32);
51     function nonces(address owner) external view returns (uint);
52 
53     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
54 
55     event Mint(address indexed sender, uint amount0, uint amount1);
56     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
57     event Swap(
58         address indexed sender,
59         uint amount0In,
60         uint amount1In,
61         uint amount0Out,
62         uint amount1Out,
63         address indexed to
64     );
65     event Sync(uint112 reserve0, uint112 reserve1);
66 
67     function MINIMUM_LIQUIDITY() external pure returns (uint);
68     function factory() external view returns (address);
69     function token0() external view returns (address);
70     function token1() external view returns (address);
71     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
72     function price0CumulativeLast() external view returns (uint);
73     function price1CumulativeLast() external view returns (uint);
74     function kLast() external view returns (uint);
75 
76     function mint(address to) external returns (uint liquidity);
77     function burn(address to) external returns (uint amount0, uint amount1);
78     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
79     function skim(address to) external;
80     function sync() external;
81 
82     function initialize(address, address) external;
83 }
84 
85 interface IUniswapV2Factory {
86     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
87 
88     function feeTo() external view returns (address);
89     function feeToSetter() external view returns (address);
90 
91     function getPair(address tokenA, address tokenB) external view returns (address pair);
92     function allPairs(uint) external view returns (address pair);
93     function allPairsLength() external view returns (uint);
94 
95     function createPair(address tokenA, address tokenB) external returns (address pair);
96 
97     function setFeeTo(address) external;
98     function setFeeToSetter(address) external;
99 }
100 
101 interface IERC20 {
102     /**
103      * @dev Returns the amount of tokens in existence.
104      */
105     function totalSupply() external view returns (uint256);
106 
107     /**
108      * @dev Returns the amount of tokens owned by `account`.
109      */
110     function balanceOf(address account) external view returns (uint256);
111 
112     /**
113      * @dev Moves `amount` tokens from the caller's account to `recipient`.
114      *
115      * Returns a boolean value indicating whether the operation succeeded.
116      *
117      * Emits a {Transfer} event.
118      */
119     function transfer(address recipient, uint256 amount) external returns (bool);
120 
121     /**
122      * @dev Returns the remaining number of tokens that `spender` will be
123      * allowed to spend on behalf of `owner` through {transferFrom}. This is
124      * zero by default.
125      *
126      * This value changes when {approve} or {transferFrom} are called.
127      */
128     function allowance(address owner, address spender) external view returns (uint256);
129 
130     /**
131      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
132      *
133      * Returns a boolean value indicating whether the operation succeeded.
134      *
135      * IMPORTANT: Beware that changing an allowance with this method brings the risk
136      * that someone may use both the old and the new allowance by unfortunate
137      * transaction ordering. One possible solution to mitigate this race
138      * condition is to first reduce the spender's allowance to 0 and set the
139      * desired value afterwards:
140      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
141      *
142      * Emits an {Approval} event.
143      */
144     function approve(address spender, uint256 amount) external returns (bool);
145 
146     /**
147      * @dev Moves `amount` tokens from `sender` to `recipient` using the
148      * allowance mechanism. `amount` is then deducted from the caller's
149      * allowance.
150      *
151      * Returns a boolean value indicating whether the operation succeeded.
152      *
153      * Emits a {Transfer} event.
154      */
155     function transferFrom(
156         address sender,
157         address recipient,
158         uint256 amount
159     ) external returns (bool);
160 
161     /**
162      * @dev Emitted when `value` tokens are moved from one account (`from`) to
163      * another (`to`).
164      *
165      * Note that `value` may be zero.
166      */
167     event Transfer(address indexed from, address indexed to, uint256 value);
168 
169     /**
170      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
171      * a call to {approve}. `value` is the new allowance.
172      */
173     event Approval(address indexed owner, address indexed spender, uint256 value);
174 }
175 
176 interface IERC20Metadata is IERC20 {
177     /**
178      * @dev Returns the name of the token.
179      */
180     function name() external view returns (string memory);
181 
182     /**
183      * @dev Returns the symbol of the token.
184      */
185     function symbol() external view returns (string memory);
186 
187     /**
188      * @dev Returns the decimals places of the token.
189      */
190     function decimals() external view returns (uint8);
191 }
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
248         return 18;
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
666 library SafeMathInt {
667     int256 private constant MIN_INT256 = int256(1) << 255;
668     int256 private constant MAX_INT256 = ~(int256(1) << 255);
669 
670     /**
671      * @dev Multiplies two int256 variables and fails on overflow.
672      */
673     function mul(int256 a, int256 b) internal pure returns (int256) {
674         int256 c = a * b;
675 
676         // Detect overflow when multiplying MIN_INT256 with -1
677         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
678         require((b == 0) || (c / b == a));
679         return c;
680     }
681 
682     /**
683      * @dev Division of two int256 variables and fails on overflow.
684      */
685     function div(int256 a, int256 b) internal pure returns (int256) {
686         // Prevent overflow when dividing MIN_INT256 by -1
687         require(b != -1 || a != MIN_INT256);
688 
689         // Solidity already throws when dividing by 0.
690         return a / b;
691     }
692 
693     /**
694      * @dev Subtracts two int256 variables and fails on overflow.
695      */
696     function sub(int256 a, int256 b) internal pure returns (int256) {
697         int256 c = a - b;
698         require((b >= 0 && c <= a) || (b < 0 && c > a));
699         return c;
700     }
701 
702     /**
703      * @dev Adds two int256 variables and fails on overflow.
704      */
705     function add(int256 a, int256 b) internal pure returns (int256) {
706         int256 c = a + b;
707         require((b >= 0 && c >= a) || (b < 0 && c < a));
708         return c;
709     }
710 
711     /**
712      * @dev Converts to absolute value, and fails on overflow.
713      */
714     function abs(int256 a) internal pure returns (int256) {
715         require(a != MIN_INT256);
716         return a < 0 ? -a : a;
717     }
718 
719 
720     function toUint256Safe(int256 a) internal pure returns (uint256) {
721         require(a >= 0);
722         return uint256(a);
723     }
724 }
725 
726 library SafeMathUint {
727   function toInt256Safe(uint256 a) internal pure returns (int256) {
728     int256 b = int256(a);
729     require(b >= 0);
730     return b;
731   }
732 }
733 
734 interface IUniswapV2Router01 {
735     function factory() external pure returns (address);
736     function WETH() external pure returns (address);
737 
738     function addLiquidity(
739         address tokenA,
740         address tokenB,
741         uint amountADesired,
742         uint amountBDesired,
743         uint amountAMin,
744         uint amountBMin,
745         address to,
746         uint deadline
747     ) external returns (uint amountA, uint amountB, uint liquidity);
748     function addLiquidityETH(
749         address token,
750         uint amountTokenDesired,
751         uint amountTokenMin,
752         uint amountETHMin,
753         address to,
754         uint deadline
755     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
756     function removeLiquidity(
757         address tokenA,
758         address tokenB,
759         uint liquidity,
760         uint amountAMin,
761         uint amountBMin,
762         address to,
763         uint deadline
764     ) external returns (uint amountA, uint amountB);
765     function removeLiquidityETH(
766         address token,
767         uint liquidity,
768         uint amountTokenMin,
769         uint amountETHMin,
770         address to,
771         uint deadline
772     ) external returns (uint amountToken, uint amountETH);
773     function removeLiquidityWithPermit(
774         address tokenA,
775         address tokenB,
776         uint liquidity,
777         uint amountAMin,
778         uint amountBMin,
779         address to,
780         uint deadline,
781         bool approveMax, uint8 v, bytes32 r, bytes32 s
782     ) external returns (uint amountA, uint amountB);
783     function removeLiquidityETHWithPermit(
784         address token,
785         uint liquidity,
786         uint amountTokenMin,
787         uint amountETHMin,
788         address to,
789         uint deadline,
790         bool approveMax, uint8 v, bytes32 r, bytes32 s
791     ) external returns (uint amountToken, uint amountETH);
792     function swapExactTokensForTokens(
793         uint amountIn,
794         uint amountOutMin,
795         address[] calldata path,
796         address to,
797         uint deadline
798     ) external returns (uint[] memory amounts);
799     function swapTokensForExactTokens(
800         uint amountOut,
801         uint amountInMax,
802         address[] calldata path,
803         address to,
804         uint deadline
805     ) external returns (uint[] memory amounts);
806     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
807         external
808         payable
809         returns (uint[] memory amounts);
810     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
811         external
812         returns (uint[] memory amounts);
813     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
814         external
815         returns (uint[] memory amounts);
816     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
817         external
818         payable
819         returns (uint[] memory amounts);
820 
821     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
822     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
823     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
824     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
825     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
826 }
827 
828 interface IUniswapV2Router02 is IUniswapV2Router01 {
829     function removeLiquidityETHSupportingFeeOnTransferTokens(
830         address token,
831         uint liquidity,
832         uint amountTokenMin,
833         uint amountETHMin,
834         address to,
835         uint deadline
836     ) external returns (uint amountETH);
837     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
838         address token,
839         uint liquidity,
840         uint amountTokenMin,
841         uint amountETHMin,
842         address to,
843         uint deadline,
844         bool approveMax, uint8 v, bytes32 r, bytes32 s
845     ) external returns (uint amountETH);
846 
847     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
848         uint amountIn,
849         uint amountOutMin,
850         address[] calldata path,
851         address to,
852         uint deadline
853     ) external;
854     function swapExactETHForTokensSupportingFeeOnTransferTokens(
855         uint amountOutMin,
856         address[] calldata path,
857         address to,
858         uint deadline
859     ) external payable;
860     function swapExactTokensForETHSupportingFeeOnTransferTokens(
861         uint amountIn,
862         uint amountOutMin,
863         address[] calldata path,
864         address to,
865         uint deadline
866     ) external;
867 }
868 
869 contract xmostar is ERC20, Ownable {
870     using SafeMath for uint256;
871 
872     IUniswapV2Router02 public immutable uniswapV2Router;
873     address public immutable uniswapV2Pair;
874 
875     bool private swapping;
876     bool private um = true;
877 
878     address public marketingWallet;
879     address public devWallet;
880     
881     uint256 public maxTransactionAmount;
882     uint256 public swapTokensAtAmount;
883     uint256 public maxWallet;
884     
885     bool public limitsInEffect = true;
886     bool public tradingActive = false;
887     bool public swapEnabled = false;
888     mapping (address => bool) private bots;
889     
890     // Anti-bot and anti-whale mappings and variables
891     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
892     bool public transferDelayEnabled = true;
893     bool private boughtEarly = true;
894     uint256 private _firstBlock;
895     uint256 private _botBlocks;
896 
897     uint256 public buyTotalFees;
898     uint256 public buyMarketingFee;
899     uint256 public buyLiquidityFee;
900     uint256 public buyDevFee;
901     
902     uint256 public sellTotalFees;
903     uint256 public sellMarketingFee;
904     uint256 public sellLiquidityFee;
905     uint256 public sellDevFee;
906     
907     uint256 public tokensForMarketing;
908     uint256 public tokensForLiquidity;
909     uint256 public tokensForDev;
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
927     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
928     
929     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
930 
931     event EndedBoughtEarly(bool boughtEarly);
932 
933     event SwapAndLiquify(
934         uint256 tokensSwapped,
935         uint256 ethReceived,
936         uint256 tokensIntoLiquidity
937     );
938 
939     constructor() ERC20("XMOSTAR", "XMO") {
940         
941         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
942         
943         excludeFromMaxTransaction(address(_uniswapV2Router), true);
944         uniswapV2Router = _uniswapV2Router;
945         
946         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
947         excludeFromMaxTransaction(address(uniswapV2Pair), true);
948         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
949         
950         uint256 _buyMarketingFee = 4;
951         uint256 _buyLiquidityFee = 2;
952         uint256 _buyDevFee = 4;
953 
954         uint256 _sellMarketingFee = 5;
955         uint256 _sellLiquidityFee = 2;
956         uint256 _sellDevFee = 5;
957         
958         uint256 totalSupply = 1 * 1e9 * 1e18;
959         
960         maxTransactionAmount = totalSupply * 25 / 10000; // 0.25% maxTransactionAmountTxn
961         maxWallet = totalSupply * 20 / 1000; // 2% maxWallet
962         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
963 
964         buyMarketingFee = _buyMarketingFee;
965         buyLiquidityFee = _buyLiquidityFee;
966         buyDevFee = _buyDevFee;
967         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
968         
969         sellMarketingFee = _sellMarketingFee;
970         sellLiquidityFee = _sellLiquidityFee;
971         sellDevFee = _sellDevFee;
972         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
973         
974         marketingWallet = payable(0xEfd0BAE8500710b63f0A17bd5e567143f8293969); 
975         devWallet = payable(0x3baDbFbAA78381003ef235B4825795e543c8cF9F);
976 
977         // exclude from paying fees or having max transaction amount
978         excludeFromFees(owner(), true);
979         excludeFromFees(address(this), true);
980         excludeFromFees(address(devWallet), true);
981         excludeFromFees(address(marketingWallet), true);
982         
983         excludeFromMaxTransaction(owner(), true);
984         excludeFromMaxTransaction(address(this), true);
985         excludeFromMaxTransaction(address(devWallet), true);
986         excludeFromMaxTransaction(address(marketingWallet), true);
987         
988         /*
989             _mint is an internal function in ERC20.sol that is only called here,
990             and CANNOT be called ever again
991         */
992         _mint(msg.sender, totalSupply);
993     }
994 
995     receive() external payable {
996 
997   	}
998 
999     
1000     
1001     // remove limits after token is stable
1002     function removeLimits() external onlyOwner returns (bool){
1003         limitsInEffect = false;
1004         return true;
1005     }
1006     
1007     // disable Transfer delay - cannot be reenabled
1008     function disableTransferDelay() external onlyOwner returns (bool){
1009         transferDelayEnabled = false;
1010         return true;
1011     }
1012     
1013      // change the minimum amount of tokens to sell from fees
1014     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1015   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1016   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1017   	    swapTokensAtAmount = newAmount;
1018   	    return true;
1019   	}
1020     
1021     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1022         require(newNum >= (totalSupply() * 1 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.1%");
1023         maxTransactionAmount = newNum * (10**18);
1024     }
1025 
1026     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1027         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxWallet lower than 0.5%");
1028         maxWallet = newNum * (10**18);
1029     }
1030     
1031     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1032         _isExcludedMaxTransactionAmount[updAds] = isEx;
1033     }
1034     
1035     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1036         buyMarketingFee = _marketingFee;
1037         buyLiquidityFee = _liquidityFee;
1038         buyDevFee = _devFee;
1039         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1040         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1041     }
1042     
1043     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1044         sellMarketingFee = _marketingFee;
1045         sellLiquidityFee = _liquidityFee;
1046         sellDevFee = _devFee;
1047         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1048         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1049     }
1050 
1051     function excludeFromFees(address account, bool excluded) public onlyOwner {
1052         _isExcludedFromFees[account] = excluded;
1053         emit ExcludeFromFees(account, excluded);
1054     }
1055 
1056     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1057         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1058 
1059         _setAutomatedMarketMakerPair(pair, value);
1060     }
1061 
1062     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1063         automatedMarketMakerPairs[pair] = value;
1064 
1065         emit SetAutomatedMarketMakerPair(pair, value);
1066     }
1067 
1068     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1069         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1070         marketingWallet = newMarketingWallet;
1071     }
1072     
1073     function updateDevWallet(address newWallet) external onlyOwner {
1074         emit devWalletUpdated(newWallet, devWallet);
1075         devWallet = newWallet;
1076     }
1077     
1078 
1079     function isExcludedFromFees(address account) public view returns(bool) {
1080         return _isExcludedFromFees[account];
1081     }
1082     
1083     function _transfer(
1084         address from,
1085         address to,
1086         uint256 amount
1087     ) internal override {
1088         require(from != address(0), "ERC20: transfer from the zero address");
1089         require(to != address(0), "ERC20: transfer to the zero address");
1090         
1091          if(amount == 0) {
1092             super._transfer(from, to, 0);
1093             return;
1094         }
1095         
1096         if(limitsInEffect){
1097             if (
1098                 from != owner() &&
1099                 to != owner() &&
1100                 to != address(0) &&
1101                 to != address(0xdead) &&
1102                 !swapping
1103             ){
1104                 if (from == uniswapV2Pair && to != address(uniswapV2Router)) {
1105                 
1106                     if (block.number <= _firstBlock.add(_botBlocks)) {
1107                     bots[to] = true;
1108                     }
1109                 }
1110 
1111                 require(!bots[from] && !bots[to]);
1112                 if(!tradingActive){
1113                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1114                 }
1115 
1116                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1117                 if (transferDelayEnabled){
1118                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1119                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1120                         _holderLastTransferTimestamp[tx.origin] = block.number;
1121                     }
1122                 }
1123                  
1124                 //when buy
1125                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1126                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1127                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1128                 }
1129                 
1130                 //when sell
1131                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1132                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1133         
1134                 }
1135                 else if(!_isExcludedMaxTransactionAmount[to]){
1136                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1137                 }
1138             }
1139         }
1140         
1141         
1142         
1143 		uint256 contractTokenBalance = balanceOf(address(this));
1144         
1145         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1146 
1147         if( 
1148             canSwap &&
1149             swapEnabled &&
1150             !swapping &&
1151             !automatedMarketMakerPairs[from] &&
1152             !_isExcludedFromFees[from] &&
1153             !_isExcludedFromFees[to]
1154         ) {
1155             swapping = true;
1156             
1157             swapBack();
1158 
1159             swapping = false;
1160         }
1161 
1162         bool takeFee = !swapping;
1163 
1164         // if any account belongs to _isExcludedFromFee account then remove the fee
1165         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1166             takeFee = false;
1167         }
1168         
1169         uint256 fees = 0;
1170         // only take fees on buys/sells, do not take on wallet transfers
1171         if(takeFee){
1172             // on sell
1173             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1174                 fees = amount.mul(sellTotalFees).div(100);
1175                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1176                 tokensForDev += fees * sellDevFee / sellTotalFees;
1177                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1178             }
1179             // on buy
1180             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1181         	    fees = amount.mul(buyTotalFees).div(100);
1182         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1183                 tokensForDev += fees * buyDevFee / buyTotalFees;
1184                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1185             }
1186             
1187             if(fees > 0){    
1188                 super._transfer(from, address(this), fees);
1189             }
1190         	
1191         	amount -= fees;
1192         }
1193 
1194         super._transfer(from, to, amount);
1195     }
1196 
1197     function swapTokensForEth(uint256 tokenAmount) private {
1198 
1199         // generate the uniswap pair path of token -> weth
1200         address[] memory path = new address[](2);
1201         path[0] = address(this);
1202         path[1] = uniswapV2Router.WETH();
1203 
1204         _approve(address(this), address(uniswapV2Router), tokenAmount);
1205 
1206         // make the swap
1207         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1208             tokenAmount,
1209             0, // accept any amount of ETH
1210             path,
1211             address(this),
1212             block.timestamp
1213         );
1214         
1215     }
1216     
1217     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1218         // approve token transfer to cover all possible scenarios
1219         _approve(address(this), address(uniswapV2Router), tokenAmount);
1220 
1221         // add the liquidity
1222         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1223             address(this),
1224             tokenAmount,
1225             0, // slippage is unavoidable
1226             0, // slippage is unavoidable
1227             owner(),
1228             block.timestamp
1229         );
1230     }
1231 
1232     function swapBack() private {
1233         uint256 contractBalance = balanceOf(address(this));
1234         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1235         bool success;
1236         
1237         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1238 
1239         if(contractBalance > swapTokensAtAmount * 20){
1240           contractBalance = swapTokensAtAmount * 20;
1241         }
1242         
1243         // Halve the amount of liquidity tokens
1244         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1245         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1246         
1247         uint256 initialETHBalance = address(this).balance;
1248 
1249         swapTokensForEth(amountToSwapForETH); 
1250         
1251         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1252         
1253         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1254         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1255         
1256         
1257         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1258         
1259         
1260         tokensForLiquidity = 0;
1261         tokensForMarketing = 0;
1262         tokensForDev = 0;
1263         
1264         (success,) = address(devWallet).call{value: ethForDev}("");
1265         
1266         if(liquidityTokens > 0 && ethForLiquidity > 0){
1267             addLiquidity(liquidityTokens, ethForLiquidity);
1268             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1269         }
1270         
1271         
1272         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1273     }
1274 
1275     function setBots(address[] memory bots_) public onlyOwner {
1276         for (uint i = 0; i < bots_.length; i++) {
1277             bots[bots_[i]] = true;
1278         }
1279     }
1280     
1281     function delBot(address notbot) public onlyOwner {
1282         bots[notbot] = false;
1283     }
1284 
1285     function openTrading(uint256 botBlocks) private {
1286         _firstBlock = block.number;
1287         _botBlocks = botBlocks;
1288         tradingActive = true;
1289     }
1290 
1291     // once enabled, can never be turned off
1292     function enableTrading(uint256 botBlocks) external onlyOwner() {
1293         require(botBlocks <= 1, "don't catch humans");
1294         swapEnabled = true;
1295         require(boughtEarly == true, "done");
1296         boughtEarly = false;
1297         openTrading(botBlocks);
1298         emit EndedBoughtEarly(boughtEarly);
1299     }
1300 
1301 }