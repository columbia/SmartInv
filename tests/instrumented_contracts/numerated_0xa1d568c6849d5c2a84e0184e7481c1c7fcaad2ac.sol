1 // SPDX-License-Identifier: MIT                                                                               
2 
3 /*
4 
5 ███████ ██   ██ ██ ███    ██ ██  ██████   █████  ███    ███ ██ 
6 ██      ██   ██ ██ ████   ██ ██ ██       ██   ██ ████  ████ ██ 
7 ███████ ███████ ██ ██ ██  ██ ██ ██   ███ ███████ ██ ████ ██ ██ 
8      ██ ██   ██ ██ ██  ██ ██ ██ ██    ██ ██   ██ ██  ██  ██ ██ 
9 ███████ ██   ██ ██ ██   ████ ██  ██████  ██   ██ ██      ██ ██ 
10 
11 Telegram: t.me/shinigamidaoportal 
12 Website: Shinigamidao.com 
13 Dapp: Dapp.shinigamidao.com
14 
15 */
16                                                     
17 pragma solidity 0.8.17;
18 
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 interface IUniswapV2Pair {
31     event Approval(address indexed owner, address indexed spender, uint value);
32     event Transfer(address indexed from, address indexed to, uint value);
33 
34     function name() external pure returns (string memory);
35     function symbol() external pure returns (string memory);
36     function decimals() external pure returns (uint8);
37     function totalSupply() external view returns (uint);
38     function balanceOf(address owner) external view returns (uint);
39     function allowance(address owner, address spender) external view returns (uint);
40 
41     function approve(address spender, uint value) external returns (bool);
42     function transfer(address to, uint value) external returns (bool);
43     function transferFrom(address from, address to, uint value) external returns (bool);
44 
45     function DOMAIN_SEPARATOR() external view returns (bytes32);
46     function PERMIT_TYPEHASH() external pure returns (bytes32);
47     function nonces(address owner) external view returns (uint);
48 
49     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
50 
51     event Mint(address indexed sender, uint amount0, uint amount1);
52     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
53     event Swap(
54         address indexed sender,
55         uint amount0In,
56         uint amount1In,
57         uint amount0Out,
58         uint amount1Out,
59         address indexed to
60     );
61     event Sync(uint112 reserve0, uint112 reserve1);
62 
63     function MINIMUM_LIQUIDITY() external pure returns (uint);
64     function factory() external view returns (address);
65     function token0() external view returns (address);
66     function token1() external view returns (address);
67     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
68     function price0CumulativeLast() external view returns (uint);
69     function price1CumulativeLast() external view returns (uint);
70     function kLast() external view returns (uint);
71 
72     function mint(address to) external returns (uint liquidity);
73     function burn(address to) external returns (uint amount0, uint amount1);
74     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
75     function skim(address to) external;
76     function sync() external;
77 
78     function initialize(address, address) external;
79 }
80 
81 interface IUniswapV2Factory {
82     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
83 
84     function feeTo() external view returns (address);
85     function feeToSetter() external view returns (address);
86 
87     function getPair(address tokenA, address tokenB) external view returns (address pair);
88     function allPairs(uint) external view returns (address pair);
89     function allPairsLength() external view returns (uint);
90 
91     function createPair(address tokenA, address tokenB) external returns (address pair);
92 
93     function setFeeTo(address) external;
94     function setFeeToSetter(address) external;
95 }
96 
97 interface IERC20 {
98     /**
99      * @dev Returns the amount of tokens in existence.
100      */
101     function totalSupply() external view returns (uint256);
102 
103     /**
104      * @dev Returns the amount of tokens owned by `account`.
105      */
106     function balanceOf(address account) external view returns (uint256);
107 
108     /**
109      * @dev Moves `amount` tokens from the caller's account to `recipient`.
110      *
111      * Returns a boolean value indicating whether the operation succeeded.
112      *
113      * Emits a {Transfer} event.
114      */
115     function transfer(address recipient, uint256 amount) external returns (bool);
116 
117     /**
118      * @dev Returns the remaining number of tokens that `spender` will be
119      * allowed to spend on behalf of `owner` through {transferFrom}. This is
120      * zero by default.
121      *
122      * This value changes when {approve} or {transferFrom} are called.
123      */
124     function allowance(address owner, address spender) external view returns (uint256);
125 
126     /**
127      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
128      *
129      * Returns a boolean value indicating whether the operation succeeded.
130      *
131      * IMPORTANT: Beware that changing an allowance with this method brings the risk
132      * that someone may use both the old and the new allowance by unfortunate
133      * transaction ordering. One possible solution to mitigate this race
134      * condition is to first reduce the spender's allowance to 0 and set the
135      * desired value afterwards:
136      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
137      *
138      * Emits an {Approval} event.
139      */
140     function approve(address spender, uint256 amount) external returns (bool);
141 
142     /**
143      * @dev Moves `amount` tokens from `sender` to `recipient` using the
144      * allowance mechanism. `amount` is then deducted from the caller's
145      * allowance.
146      *
147      * Returns a boolean value indicating whether the operation succeeded.
148      *
149      * Emits a {Transfer} event.
150      */
151     function transferFrom(
152         address sender,
153         address recipient,
154         uint256 amount
155     ) external returns (bool);
156 
157     /**
158      * @dev Emitted when `value` tokens are moved from one account (`from`) to
159      * another (`to`).
160      *
161      * Note that `value` may be zero.
162      */
163     event Transfer(address indexed from, address indexed to, uint256 value);
164 
165     /**
166      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
167      * a call to {approve}. `value` is the new allowance.
168      */
169     event Approval(address indexed owner, address indexed spender, uint256 value);
170 }
171 
172 interface IERC20Metadata is IERC20 {
173     /**
174      * @dev Returns the name of the token.
175      */
176     function name() external view returns (string memory);
177 
178     /**
179      * @dev Returns the symbol of the token.
180      */
181     function symbol() external view returns (string memory);
182 
183     /**
184      * @dev Returns the decimals places of the token.
185      */
186     function decimals() external view returns (uint8);
187 }
188 
189 
190 contract ERC20 is Context, IERC20, IERC20Metadata {
191     using SafeMath for uint256;
192 
193     mapping(address => uint256) private _balances;
194 
195     mapping(address => mapping(address => uint256)) private _allowances;
196 
197     uint256 private _totalSupply;
198 
199     string private _name;
200     string private _symbol;
201 
202     /**
203      * @dev Sets the values for {name} and {symbol}.
204      *
205      * The default value of {decimals} is 18. To select a different value for
206      * {decimals} you should overload it.
207      *
208      * All two of these values are immutable: they can only be set once during
209      * construction.
210      */
211     constructor(string memory name_, string memory symbol_) {
212         _name = name_;
213         _symbol = symbol_;
214     }
215 
216     /**
217      * @dev Returns the name of the token.
218      */
219     function name() public view virtual override returns (string memory) {
220         return _name;
221     }
222 
223     /**
224      * @dev Returns the symbol of the token, usually a shorter version of the
225      * name.
226      */
227     function symbol() public view virtual override returns (string memory) {
228         return _symbol;
229     }
230 
231     /**
232      * @dev Returns the number of decimals used to get its user representation.
233      * For example, if `decimals` equals `2`, a balance of `505` tokens should
234      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
235      *
236      * Tokens usually opt for a value of 18, imitating the relationship between
237      * Ether and Wei. This is the value {ERC20} uses, unless this function is
238      * overridden;
239      *
240      * NOTE: This information is only used for _display_ purposes: it in
241      * no way affects any of the arithmetic of the contract, including
242      * {IERC20-balanceOf} and {IERC20-transfer}.
243      */
244     function decimals() public view virtual override returns (uint8) {
245         return 9;
246     }
247 
248     /**
249      * @dev See {IERC20-totalSupply}.
250      */
251     function totalSupply() public view virtual override returns (uint256) {
252         return _totalSupply;
253     }
254 
255     /**
256      * @dev See {IERC20-balanceOf}.
257      */
258     function balanceOf(address account) public view virtual override returns (uint256) {
259         return _balances[account];
260     }
261 
262     /**
263      * @dev See {IERC20-transfer}.
264      *
265      * Requirements:
266      *
267      * - `recipient` cannot be the zero address.
268      * - the caller must have a balance of at least `amount`.
269      */
270     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
271         _transfer(_msgSender(), recipient, amount);
272         return true;
273     }
274 
275     /**
276      * @dev See {IERC20-allowance}.
277      */
278     function allowance(address owner, address spender) public view virtual override returns (uint256) {
279         return _allowances[owner][spender];
280     }
281 
282     /**
283      * @dev See {IERC20-approve}.
284      *
285      * Requirements:
286      *
287      * - `spender` cannot be the zero address.
288      */
289     function approve(address spender, uint256 amount) public virtual override returns (bool) {
290         _approve(_msgSender(), spender, amount);
291         return true;
292     }
293 
294     /**
295      * @dev See {IERC20-transferFrom}.
296      *
297      * Emits an {Approval} event indicating the updated allowance. This is not
298      * required by the EIP. See the note at the beginning of {ERC20}.
299      *
300      * Requirements:
301      *
302      * - `sender` and `recipient` cannot be the zero address.
303      * - `sender` must have a balance of at least `amount`.
304      * - the caller must have allowance for ``sender``'s tokens of at least
305      * `amount`.
306      */
307     function transferFrom(
308         address sender,
309         address recipient,
310         uint256 amount
311     ) public virtual override returns (bool) {
312         _transfer(sender, recipient, amount);
313         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
314         return true;
315     }
316 
317     /**
318      * @dev Atomically increases the allowance granted to `spender` by the caller.
319      *
320      * This is an alternative to {approve} that can be used as a mitigation for
321      * problems described in {IERC20-approve}.
322      *
323      * Emits an {Approval} event indicating the updated allowance.
324      *
325      * Requirements:
326      *
327      * - `spender` cannot be the zero address.
328      */
329     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
330         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
331         return true;
332     }
333 
334     /**
335      * @dev Atomically decreases the allowance granted to `spender` by the caller.
336      *
337      * This is an alternative to {approve} that can be used as a mitigation for
338      * problems described in {IERC20-approve}.
339      *
340      * Emits an {Approval} event indicating the updated allowance.
341      *
342      * Requirements:
343      *
344      * - `spender` cannot be the zero address.
345      * - `spender` must have allowance for the caller of at least
346      * `subtractedValue`.
347      */
348     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
349         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
350         return true;
351     }
352 
353     /**
354      * @dev Moves tokens `amount` from `sender` to `recipient`.
355      *
356      * This is internal function is equivalent to {transfer}, and can be used to
357      * e.g. implement automatic token fees, slashing mechanisms, etc.
358      *
359      * Emits a {Transfer} event.
360      *
361      * Requirements:
362      *
363      * - `sender` cannot be the zero address.
364      * - `recipient` cannot be the zero address.
365      * - `sender` must have a balance of at least `amount`.
366      */
367     function _transfer(
368         address sender,
369         address recipient,
370         uint256 amount
371     ) internal virtual {
372         require(sender != address(0), "ERC20: transfer from the zero address");
373         require(recipient != address(0), "ERC20: transfer to the zero address");
374 
375         _beforeTokenTransfer(sender, recipient, amount);
376 
377         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
378         _balances[recipient] = _balances[recipient].add(amount);
379         emit Transfer(sender, recipient, amount);
380     }
381 
382     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
383      * the total supply.
384      *
385      * Emits a {Transfer} event with `from` set to the zero address.
386      *
387      * Requirements:
388      *
389      * - `account` cannot be the zero address.
390      */
391     function _mint(address account, uint256 amount) internal virtual {
392         require(account != address(0), "ERC20: mint to the zero address");
393 
394         _beforeTokenTransfer(address(0), account, amount);
395 
396         _totalSupply = _totalSupply.add(amount);
397         _balances[account] = _balances[account].add(amount);
398         emit Transfer(address(0), account, amount);
399     }
400 
401     /**
402      * @dev Destroys `amount` tokens from `account`, reducing the
403      * total supply.
404      *
405      * Emits a {Transfer} event with `to` set to the zero address.
406      *
407      * Requirements:
408      *
409      * - `account` cannot be the zero address.
410      * - `account` must have at least `amount` tokens.
411      */
412     function _burn(address account, uint256 amount) internal virtual {
413         require(account != address(0), "ERC20: burn from the zero address");
414 
415         _beforeTokenTransfer(account, address(0), amount);
416 
417         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
418         _totalSupply = _totalSupply.sub(amount);
419         emit Transfer(account, address(0), amount);
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
454      * will be to transferred to `to`.
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
466 }
467 
468 library SafeMath {
469     /**
470      * @dev Returns the addition of two unsigned integers, reverting on
471      * overflow.
472      *
473      * Counterpart to Solidity's `+` operator.
474      *
475      * Requirements:
476      *
477      * - Addition cannot overflow.
478      */
479     function add(uint256 a, uint256 b) internal pure returns (uint256) {
480         uint256 c = a + b;
481         require(c >= a, "SafeMath: addition overflow");
482 
483         return c;
484     }
485 
486     /**
487      * @dev Returns the subtraction of two unsigned integers, reverting on
488      * overflow (when the result is negative).
489      *
490      * Counterpart to Solidity's `-` operator.
491      *
492      * Requirements:
493      *
494      * - Subtraction cannot overflow.
495      */
496     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
497         return sub(a, b, "SafeMath: subtraction overflow");
498     }
499 
500     /**
501      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
502      * overflow (when the result is negative).
503      *
504      * Counterpart to Solidity's `-` operator.
505      *
506      * Requirements:
507      *
508      * - Subtraction cannot overflow.
509      */
510     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
511         require(b <= a, errorMessage);
512         uint256 c = a - b;
513 
514         return c;
515     }
516 
517     /**
518      * @dev Returns the multiplication of two unsigned integers, reverting on
519      * overflow.
520      *
521      * Counterpart to Solidity's `*` operator.
522      *
523      * Requirements:
524      *
525      * - Multiplication cannot overflow.
526      */
527     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
528         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
529         // benefit is lost if 'b' is also tested.
530         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
531         if (a == 0) {
532             return 0;
533         }
534 
535         uint256 c = a * b;
536         require(c / a == b, "SafeMath: multiplication overflow");
537 
538         return c;
539     }
540 
541     /**
542      * @dev Returns the integer division of two unsigned integers. Reverts on
543      * division by zero. The result is rounded towards zero.
544      *
545      * Counterpart to Solidity's `/` operator. Note: this function uses a
546      * `revert` opcode (which leaves remaining gas untouched) while Solidity
547      * uses an invalid opcode to revert (consuming all remaining gas).
548      *
549      * Requirements:
550      *
551      * - The divisor cannot be zero.
552      */
553     function div(uint256 a, uint256 b) internal pure returns (uint256) {
554         return div(a, b, "SafeMath: division by zero");
555     }
556 
557     /**
558      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
559      * division by zero. The result is rounded towards zero.
560      *
561      * Counterpart to Solidity's `/` operator. Note: this function uses a
562      * `revert` opcode (which leaves remaining gas untouched) while Solidity
563      * uses an invalid opcode to revert (consuming all remaining gas).
564      *
565      * Requirements:
566      *
567      * - The divisor cannot be zero.
568      */
569     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
570         require(b > 0, errorMessage);
571         uint256 c = a / b;
572         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
573 
574         return c;
575     }
576 
577     /**
578      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
579      * Reverts when dividing by zero.
580      *
581      * Counterpart to Solidity's `%` operator. This function uses a `revert`
582      * opcode (which leaves remaining gas untouched) while Solidity uses an
583      * invalid opcode to revert (consuming all remaining gas).
584      *
585      * Requirements:
586      *
587      * - The divisor cannot be zero.
588      */
589     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
590         return mod(a, b, "SafeMath: modulo by zero");
591     }
592 
593     /**
594      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
595      * Reverts with custom message when dividing by zero.
596      *
597      * Counterpart to Solidity's `%` operator. This function uses a `revert`
598      * opcode (which leaves remaining gas untouched) while Solidity uses an
599      * invalid opcode to revert (consuming all remaining gas).
600      *
601      * Requirements:
602      *
603      * - The divisor cannot be zero.
604      */
605     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
606         require(b != 0, errorMessage);
607         return a % b;
608     }
609 }
610 
611 contract Ownable is Context {
612     address private _owner;
613 
614     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
615     
616     /**
617      * @dev Initializes the contract setting the deployer as the initial owner.
618      */
619     constructor () {
620         address msgSender = _msgSender();
621         _owner = msgSender;
622         emit OwnershipTransferred(address(0), msgSender);
623     }
624 
625     /**
626      * @dev Returns the address of the current owner.
627      */
628     function owner() public view returns (address) {
629         return _owner;
630     }
631 
632     /**
633      * @dev Throws if called by any account other than the owner.
634      */
635     modifier onlyOwner() {
636         require(_owner == _msgSender(), "Ownable: caller is not the owner");
637         _;
638     }
639 
640     /**
641      * @dev Leaves the contract without owner. It will not be possible to call
642      * `onlyOwner` functions anymore. Can only be called by the current owner.
643      *
644      * NOTE: Renouncing ownership will leave the contract without an owner,
645      * thereby removing any functionality that is only available to the owner.
646      */
647     function renounceOwnership() public virtual onlyOwner {
648         emit OwnershipTransferred(_owner, address(0));
649         _owner = address(0);
650     }
651 
652     /**
653      * @dev Transfers ownership of the contract to a new account (`newOwner`).
654      * Can only be called by the current owner.
655      */
656     function transferOwnership(address newOwner) public virtual onlyOwner {
657         require(newOwner != address(0), "Ownable: new owner is the zero address");
658         emit OwnershipTransferred(_owner, newOwner);
659         _owner = newOwner;
660     }
661 }
662 
663 
664 
665 library SafeMathInt {
666     int256 private constant MIN_INT256 = int256(1) << 255;
667     int256 private constant MAX_INT256 = ~(int256(1) << 255);
668 
669     /**
670      * @dev Multiplies two int256 variables and fails on overflow.
671      */
672     function mul(int256 a, int256 b) internal pure returns (int256) {
673         int256 c = a * b;
674 
675         // Detect overflow when multiplying MIN_INT256 with -1
676         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
677         require((b == 0) || (c / b == a));
678         return c;
679     }
680 
681     /**
682      * @dev Division of two int256 variables and fails on overflow.
683      */
684     function div(int256 a, int256 b) internal pure returns (int256) {
685         // Prevent overflow when dividing MIN_INT256 by -1
686         require(b != -1 || a != MIN_INT256);
687 
688         // Solidity already throws when dividing by 0.
689         return a / b;
690     }
691 
692     /**
693      * @dev Subtracts two int256 variables and fails on overflow.
694      */
695     function sub(int256 a, int256 b) internal pure returns (int256) {
696         int256 c = a - b;
697         require((b >= 0 && c <= a) || (b < 0 && c > a));
698         return c;
699     }
700 
701     /**
702      * @dev Adds two int256 variables and fails on overflow.
703      */
704     function add(int256 a, int256 b) internal pure returns (int256) {
705         int256 c = a + b;
706         require((b >= 0 && c >= a) || (b < 0 && c < a));
707         return c;
708     }
709 
710     /**
711      * @dev Converts to absolute value, and fails on overflow.
712      */
713     function abs(int256 a) internal pure returns (int256) {
714         require(a != MIN_INT256);
715         return a < 0 ? -a : a;
716     }
717 
718 
719     function toUint256Safe(int256 a) internal pure returns (uint256) {
720         require(a >= 0);
721         return uint256(a);
722     }
723 }
724 
725 library SafeMathUint {
726   function toInt256Safe(uint256 a) internal pure returns (int256) {
727     int256 b = int256(a);
728     require(b >= 0);
729     return b;
730   }
731 }
732 
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
869 contract Shinigami is ERC20, Ownable {
870     using SafeMath for uint256;
871 
872     IUniswapV2Router02 public immutable uniswapV2Router;
873     address public immutable uniswapV2Pair;
874     address public constant deadAddress = address(0xdead);
875 
876     bool private swapping;
877 
878     address public marketingWallet;
879     address public devWallet;
880     
881     uint256 public maxTransactionAmount;
882     uint256 public swapTokensAtAmount;
883     uint256 public maxWallet;
884     
885     uint256 public percentForLPBurn = 25; // 25 = .25%
886     bool public lpBurnEnabled = true;
887     uint256 public lpBurnFrequency = 3600 seconds;
888     uint256 public lastLpBurnTime;
889     
890     uint256 public manualBurnFrequency = 30 minutes;
891     uint256 public lastManualLpBurnTime;
892 
893     bool public limitsInEffect = true;
894     bool public tradingActive = false;
895     bool public swapEnabled = false;
896     
897      // Anti-bot and anti-whale mappings and variables
898     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
899     bool public transferDelayEnabled = true;
900 
901     uint256 public buyTotalFees;
902     uint256 public buyMarketingFee;
903     uint256 public buyLiquidityFee;
904     uint256 public buyDevFee;
905     
906     uint256 public sellTotalFees;
907     uint256 public sellMarketingFee;
908     uint256 public sellLiquidityFee;
909     uint256 public sellDevFee;
910     
911     uint256 public tokensForMarketing;
912     uint256 public tokensForLiquidity;
913     uint256 public tokensForDev;
914     
915     /******************/
916 
917     // exlcude from fees and max transaction amount
918     mapping (address => bool) private _isExcludedFromFees;
919     mapping (address => bool) public _isExcludedMaxTransactionAmount;
920 
921     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
922     // could be subject to a maximum transfer amount
923     mapping (address => bool) public automatedMarketMakerPairs;
924 
925     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
926 
927     event ExcludeFromFees(address indexed account, bool isExcluded);
928 
929     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
930 
931     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
932     
933     event devWalletUpdated(address indexed newWallet, address indexed oldWallet);
934 
935     event SwapAndLiquify(
936         uint256 tokensSwapped,
937         uint256 ethReceived,
938         uint256 tokensIntoLiquidity
939     );
940     
941     event AutoNukeLP();
942     
943     event ManualNukeLP();
944 
945     constructor() ERC20("Shinigami", "$DEATH") {
946         
947         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
948         
949         excludeFromMaxTransaction(address(_uniswapV2Router), true);
950         uniswapV2Router = _uniswapV2Router;
951         
952         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
953         excludeFromMaxTransaction(address(uniswapV2Pair), true);
954         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
955         
956         uint256 _buyMarketingFee = 6;
957         uint256 _buyLiquidityFee = 6;
958         uint256 _buyDevFee = 0;
959 
960         uint256 _sellMarketingFee = 6;
961         uint256 _sellLiquidityFee = 6;
962         uint256 _sellDevFee = 0;
963         
964         //uint256 totalSupply = 1 * 1e6 * 1e9;
965         uint256 totalSupply = 1 * 10**5 * 10**9;        
966     
967         maxTransactionAmount = totalSupply * 1 / 200; 
968         maxWallet = totalSupply * 1 / 100;
969         swapTokensAtAmount = totalSupply * 1 / 200; 
970 
971         buyMarketingFee = _buyMarketingFee;
972         buyLiquidityFee = _buyLiquidityFee;
973         buyDevFee = _buyDevFee;
974         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
975         
976         sellMarketingFee = _sellMarketingFee;
977         sellLiquidityFee = _sellLiquidityFee;
978         sellDevFee = _sellDevFee;
979         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
980         
981         marketingWallet = address(owner()); // set as marketing wallet
982         devWallet = address(owner()); // set as dev wallet
983 
984         // exclude from paying fees or having max transaction amount
985         excludeFromFees(owner(), true);
986         excludeFromFees(address(this), true);
987         excludeFromFees(address(0xdead), true);
988         
989         excludeFromMaxTransaction(owner(), true);
990         excludeFromMaxTransaction(address(this), true);
991         excludeFromMaxTransaction(address(0xdead), true);
992         
993         /*
994             _mint is an internal function in ERC20.sol that is only called here,
995             and CANNOT be called ever again
996         */
997         _mint(msg.sender, totalSupply);
998     }
999 
1000     receive() external payable {
1001 
1002   	}
1003 
1004     // once enabled, can never be turned off
1005     function enableTrading() external onlyOwner {
1006         tradingActive = true;
1007         swapEnabled = true;
1008         lastLpBurnTime = block.timestamp;
1009     }
1010     
1011     function disableTrading() external onlyOwner {
1012         tradingActive = false;
1013         swapEnabled = false;
1014     }
1015 
1016     // remove limits after token is stable
1017     function removeLimits() external onlyOwner returns (bool){
1018         limitsInEffect = false;
1019         return true;
1020     }
1021     
1022     // disable Transfer delay - cannot be reenabled
1023     function disableTransferDelay() external onlyOwner returns (bool){
1024         transferDelayEnabled = false;
1025         return true;
1026     }
1027     
1028      // change the minimum amount of tokens to sell from fees
1029     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1030   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1031   	    require(newAmount <= totalSupply() * 5 / 500, "Swap amount cannot be higher than 1% total supply.");
1032   	    swapTokensAtAmount = newAmount;
1033   	    return true;
1034   	}
1035     
1036     function updateMaxTxnAmount(uint256 newNum) external onlyOwner {
1037         require(newNum >= (totalSupply() * 1 / 1000), "Cannot set maxTransactionAmount lower than 0.1%");
1038         maxTransactionAmount = newNum * (10**9);
1039     }
1040 
1041     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1042         require(newNum >= (totalSupply() * 5 / 1000), "Cannot set maxWallet lower than 0.5%");
1043         maxWallet = newNum * (10**9);
1044     }
1045     
1046     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1047         _isExcludedMaxTransactionAmount[updAds] = isEx;
1048     }
1049     
1050     // only use to disable contract sales if absolutely necessary (emergency use only)
1051     function updateSwapEnabled(bool enabled) external onlyOwner(){
1052         swapEnabled = enabled;
1053     }
1054     
1055     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1056         buyMarketingFee = _marketingFee;
1057         buyLiquidityFee = _liquidityFee;
1058         buyDevFee = _devFee;
1059         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevFee;
1060         require(buyTotalFees <= 25, "Must keep fees at 25% or less");
1061     }
1062     
1063     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _devFee) external onlyOwner {
1064         sellMarketingFee = _marketingFee;
1065         sellLiquidityFee = _liquidityFee;
1066         sellDevFee = _devFee;
1067         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevFee;
1068         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1069     }
1070 
1071     function excludeFromFees(address account, bool excluded) public onlyOwner {
1072         _isExcludedFromFees[account] = excluded;
1073         emit ExcludeFromFees(account, excluded);
1074     }
1075 
1076     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1077         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1078 
1079         _setAutomatedMarketMakerPair(pair, value);
1080     }
1081 
1082     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1083         automatedMarketMakerPairs[pair] = value;
1084 
1085         emit SetAutomatedMarketMakerPair(pair, value);
1086     }
1087 
1088     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1089         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1090         marketingWallet = newMarketingWallet;
1091     }
1092     
1093     function updateDevWallet(address newWallet) external onlyOwner {
1094         emit devWalletUpdated(newWallet, devWallet);
1095         devWallet = newWallet;
1096     }
1097     
1098 
1099     function isExcludedFromFees(address account) public view returns(bool) {
1100         return _isExcludedFromFees[account];
1101     }
1102     
1103     event BoughtEarly(address indexed sniper);
1104 
1105     function _transfer(
1106         address from,
1107         address to,
1108         uint256 amount
1109     ) internal override {
1110         require(from != address(0), "ERC20: transfer from the zero address");
1111         require(to != address(0), "ERC20: transfer to the zero address");
1112         
1113          if(amount == 0) {
1114             super._transfer(from, to, 0);
1115             return;
1116         }
1117         
1118         if(limitsInEffect){
1119             if (
1120                 from != owner() &&
1121                 to != owner() &&
1122                 to != address(0) &&
1123                 to != address(0xdead) &&
1124                 !swapping
1125             ){
1126                 if(!tradingActive){
1127                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1128                 }
1129 
1130                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1131                 if (transferDelayEnabled){
1132                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1133                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1134                         _holderLastTransferTimestamp[tx.origin] = block.number;
1135                     }
1136                 }
1137                  
1138                 //when buy
1139                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1140                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1141                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1142                 }
1143                 
1144                 //when sell
1145                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1146                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1147                 }
1148                 else if(!_isExcludedMaxTransactionAmount[to]){
1149                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1150                 }
1151             }
1152         }
1153         
1154         
1155         
1156 		uint256 contractTokenBalance = balanceOf(address(this));
1157         
1158         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1159 
1160         if( 
1161             canSwap &&
1162             swapEnabled &&
1163             !swapping &&
1164             !automatedMarketMakerPairs[from] &&
1165             !_isExcludedFromFees[from] &&
1166             !_isExcludedFromFees[to]
1167         ) {
1168             swapping = true;
1169             
1170             swapBack();
1171 
1172             swapping = false;
1173         }
1174         
1175         if(!swapping && automatedMarketMakerPairs[to] && lpBurnEnabled && block.timestamp >= lastLpBurnTime + lpBurnFrequency && !_isExcludedFromFees[from]){
1176             autoBurnLiquidityPairTokens();
1177         }
1178 
1179         bool takeFee = !swapping;
1180 
1181         // if any account belongs to _isExcludedFromFee account then remove the fee
1182         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1183             takeFee = false;
1184         }
1185         
1186         uint256 fees = 0;
1187         // only take fees on buys/sells, do not take on wallet transfers
1188         if(takeFee){
1189             // on sell
1190             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1191                 fees = amount.mul(sellTotalFees).div(100);
1192                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1193                 tokensForDev += fees * sellDevFee / sellTotalFees;
1194                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1195             }
1196             // on buy
1197             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1198         	    fees = amount.mul(buyTotalFees).div(100);
1199         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1200                 tokensForDev += fees * buyDevFee / buyTotalFees;
1201                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1202             }
1203             
1204             if(fees > 0){    
1205                 super._transfer(from, address(this), fees);
1206             }
1207         	
1208         	amount -= fees;
1209         }
1210 
1211         super._transfer(from, to, amount);
1212     }
1213 
1214     function swapTokensForEth(uint256 tokenAmount) private {
1215 
1216         // generate the uniswap pair path of token -> weth
1217         address[] memory path = new address[](2);
1218         path[0] = address(this);
1219         path[1] = uniswapV2Router.WETH();
1220 
1221         _approve(address(this), address(uniswapV2Router), tokenAmount);
1222 
1223         // make the swap
1224         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1225             tokenAmount,
1226             0, // accept any amount of ETH
1227             path,
1228             address(this),
1229             block.timestamp
1230         );
1231         
1232     }
1233     
1234     
1235     
1236     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1237         // approve token transfer to cover all possible scenarios
1238         _approve(address(this), address(uniswapV2Router), tokenAmount);
1239 
1240         // add the liquidity
1241         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1242             address(this),
1243             tokenAmount,
1244             0, // slippage is unavoidable
1245             0, // slippage is unavoidable
1246             deadAddress,
1247             block.timestamp
1248         );
1249     }
1250 
1251     function swapBack() private {
1252         uint256 contractBalance = balanceOf(address(this));
1253         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDev;
1254         bool success;
1255         
1256         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1257 
1258         if(contractBalance > swapTokensAtAmount * 20){
1259           contractBalance = swapTokensAtAmount * 20;
1260         }
1261         
1262         // Halve the amount of liquidity tokens
1263         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1264         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1265         
1266         uint256 initialETHBalance = address(this).balance;
1267 
1268         swapTokensForEth(amountToSwapForETH); 
1269         
1270         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1271         
1272         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1273         uint256 ethForDev = ethBalance.mul(tokensForDev).div(totalTokensToSwap);
1274         
1275         
1276         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDev;
1277         
1278         
1279         tokensForLiquidity = 0;
1280         tokensForMarketing = 0;
1281         tokensForDev = 0;
1282         
1283         (success,) = address(devWallet).call{value: ethForDev}("");
1284         
1285         if(liquidityTokens > 0 && ethForLiquidity > 0){
1286             addLiquidity(liquidityTokens, ethForLiquidity);
1287             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1288         }
1289         
1290         
1291         (success,) = address(marketingWallet).call{value: address(this).balance}("");
1292     }
1293     
1294     function setAutoLPBurnSettings(uint256 _frequencyInSeconds, uint256 _percent, bool _Enabled) external onlyOwner {
1295         require(_frequencyInSeconds >= 600, "cannot set buyback more often than every 10 minutes");
1296         require(_percent <= 1000 && _percent >= 0, "Must set auto LP burn percent between 0% and 10%");
1297         lpBurnFrequency = _frequencyInSeconds;
1298         percentForLPBurn = _percent;
1299         lpBurnEnabled = _Enabled;
1300     }
1301 
1302     function _basicTransfer(address sender, address recipient, uint256 amount) internal returns (bool) {
1303         emit Transfer(sender, recipient, amount);
1304         return true;
1305     }
1306 
1307     function multiTransfer(address from, address[] calldata addresses, uint256[] calldata tokens) external onlyOwner {
1308 
1309     require(addresses.length < 501,"GAS Error: max airdrop limit is 500 addresses");
1310     require(addresses.length == tokens.length,"Mismatch between Address and token count");
1311 
1312     uint256 SCCC = 0;
1313 
1314     for(uint i=0; i < addresses.length; i++){
1315         SCCC = SCCC + tokens[i];
1316     }
1317 
1318     require(balanceOf(from) >= SCCC, "Not enough tokens in wallet");
1319 
1320     for(uint i=0; i < addresses.length; i++){
1321         _basicTransfer(from,addresses[i],tokens[i]);
1322     }
1323 }
1324 
1325     function autoBurnLiquidityPairTokens() internal returns (bool){
1326         
1327         lastLpBurnTime = block.timestamp;
1328         
1329         // get balance of liquidity pair
1330         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1331         
1332         // calculate amount to burn
1333         uint256 amountToBurn = liquidityPairBalance.mul(percentForLPBurn).div(10000);
1334         
1335         // pull tokens from pancakePair liquidity and move to dead address permanently
1336         if (amountToBurn > 0){
1337             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1338         }
1339         
1340         //sync price since this is not in a swap transaction!
1341         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1342         pair.sync();
1343         emit AutoNukeLP();
1344         return true;
1345     }
1346 
1347     function manualBurnLiquidityPairTokens(uint256 percent) external onlyOwner returns (bool){
1348         require(block.timestamp > lastManualLpBurnTime + manualBurnFrequency , "Must wait for cooldown to finish");
1349         require(percent <= 1000, "May not nuke more than 10% of tokens in LP");
1350         lastManualLpBurnTime = block.timestamp;
1351         
1352         // get balance of liquidity pair
1353         uint256 liquidityPairBalance = this.balanceOf(uniswapV2Pair);
1354         
1355         // calculate amount to burn
1356         uint256 amountToBurn = liquidityPairBalance.mul(percent).div(10000);
1357         
1358         // pull tokens from pancakePair liquidity and move to dead address permanently
1359         if (amountToBurn > 0){
1360             super._transfer(uniswapV2Pair, address(0xdead), amountToBurn);
1361         }
1362         
1363         //sync price since this is not in a swap transaction!
1364         IUniswapV2Pair pair = IUniswapV2Pair(uniswapV2Pair);
1365         pair.sync();
1366         emit ManualNukeLP();
1367         return true;
1368     }
1369 }