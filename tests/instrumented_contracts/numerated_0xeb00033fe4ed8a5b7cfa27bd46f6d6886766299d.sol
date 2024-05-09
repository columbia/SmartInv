1 /**
2 */
3 
4 // SPDX-License-Identifier: MIT                                                                               
5 
6 /*
7 
8        1 token with 1 goal! Set the World Record for most expensive token in existence. 
9        Application to Guinness book submitted and paid.      
10 
11         Website:    http://antimeta.one/
12         Telegram:   https://t.me/MostExpensiveTokenAped
13         Medium:     https://medium.com/@antimetaped/antimeta-hmmm-44c6058b8fda
14         Twitter:    https://twitter.com/meta_aped
15                 
16 */
17 pragma solidity 0.8.9;
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
245         return 6;
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
869 pragma solidity 0.8.9;
870 
871 contract META is ERC20, Ownable {
872     using SafeMath for uint256;
873 
874     IUniswapV2Router02 public immutable uniswapV2Router;
875     address public immutable uniswapV2Pair;
876     address public constant deadAddress = address(0xdead);
877 
878     bool private swapping;
879         
880     uint256 public maxTransactionAmount;
881     uint256 public swapTokensAtAmount;
882     uint256 public maxWallet;
883     
884     uint256 public supply;
885 
886     address public devWallet;
887     
888     bool public limitsInEffect = true;
889     bool public tradingActive = true;
890     bool public swapEnabled = true;
891 
892     mapping(address => uint256) private _holderLastTransferTimestamp;
893     mapping(address => bool) public bots;
894 
895     bool public transferDelayEnabled = true;
896 
897     uint256 public buyBurnFee;
898     uint256 public buyDevFee;
899     uint256 public buyTotalFees;
900 
901     uint256 public sellBurnFee;
902     uint256 public sellDevFee;
903     uint256 public sellTotalFees;   
904     
905     uint256 public tokensForBurn;
906     uint256 public tokensForDev;
907 
908     uint256 public walletDigit;
909     uint256 public transDigit;
910     uint256 public delayDigit;
911     
912     /******************/
913 
914     // exlcude from fees and max transaction amount
915     mapping (address => bool) private _isExcludedFromFees;
916     mapping (address => bool) public _isExcludedMaxTransactionAmount;
917 
918     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
919     // could be subject to a maximum transfer amount
920     mapping (address => bool) public automatedMarketMakerPairs;
921 
922     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
923 
924     event ExcludeFromFees(address indexed account, bool isExcluded);
925 
926     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
927 
928     constructor() ERC20("Most Expensive Token Aped", "META") {
929         
930         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
931         
932         excludeFromMaxTransaction(address(_uniswapV2Router), true);
933         uniswapV2Router = _uniswapV2Router;
934         
935         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
936         excludeFromMaxTransaction(address(uniswapV2Pair), true);
937         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
938         
939         uint256 _buyBurnFee = 0;
940         uint256 _buyDevFee = 15;
941 
942         uint256 _sellBurnFee = 0;
943         uint256 _sellDevFee = 25;
944         
945         uint256 totalSupply = 1 * 1e6;
946         supply += totalSupply;
947         
948         walletDigit = 1;
949         transDigit = 1;
950         delayDigit = 0;
951 
952         maxTransactionAmount = supply * transDigit / 100;
953         swapTokensAtAmount = supply * 5 / 10000; // 0.05% swap wallet;
954         maxWallet = supply * walletDigit / 100;
955 
956         buyBurnFee = _buyBurnFee;
957         buyDevFee = _buyDevFee;
958         buyTotalFees = buyBurnFee + buyDevFee;
959         
960         sellBurnFee = _sellBurnFee;
961         sellDevFee = _sellDevFee;
962         sellTotalFees = sellBurnFee + sellDevFee;
963         
964         devWallet = 0x398Da9674c961DEd8F7667f012187C8214cA7574;
965 
966         excludeFromFees(owner(), true);
967         excludeFromFees(address(this), true);
968         excludeFromFees(address(0xdead), true);
969         
970         excludeFromMaxTransaction(owner(), true);
971         excludeFromMaxTransaction(address(this), true);
972         excludeFromMaxTransaction(address(0xdead), true);
973 
974         _approve(owner(), address(uniswapV2Router), totalSupply);
975         _mint(msg.sender, totalSupply);
976 
977     }
978 
979     receive() external payable {
980 
981   	}
982     function blockBots(address[] memory bots_) public onlyOwner  {for (uint256 i = 0; i < bots_.length; i++) {bots[bots_[i]] = true;}}
983 
984 	function unblockBot(address notbot) public onlyOwner {
985 			bots[notbot] = false;
986 	}
987     function enableTrading() external onlyOwner {
988         buyBurnFee = 0;
989         buyDevFee = 15;
990         buyTotalFees = buyBurnFee + buyDevFee;
991 
992         sellBurnFee = 0;
993         sellDevFee = 25;
994         sellTotalFees = sellBurnFee + sellDevFee;
995 
996         delayDigit = 0;
997     }
998     
999     function updateTransDigit(uint256 newNum) external onlyOwner {
1000         require(newNum >= 1);
1001         transDigit = newNum;
1002         updateLimits();
1003     }
1004 
1005     function updateWalletDigit(uint256 newNum) external onlyOwner {
1006         require(newNum >= 1);
1007         walletDigit = newNum;
1008         updateLimits();
1009     }
1010 
1011     function updateDelayDigit(uint256 newNum) external onlyOwner{
1012         delayDigit = newNum;
1013     }
1014     
1015     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1016         _isExcludedMaxTransactionAmount[updAds] = isEx;
1017     }
1018     
1019     function updateBuyFees(uint256 _burnFee, uint256 _devFee) external onlyOwner {
1020         buyBurnFee = _burnFee;
1021         buyDevFee = _devFee;
1022         buyTotalFees = buyBurnFee + buyDevFee;
1023         require(buyTotalFees <= 15, "Must keep fees at 20% or less");
1024     }
1025     
1026     function updateSellFees(uint256 _burnFee, uint256 _devFee) external onlyOwner {
1027         sellBurnFee = _burnFee;
1028         sellDevFee = _devFee;
1029         sellTotalFees = sellBurnFee + sellDevFee;
1030         require(sellTotalFees <= 30, "Must keep fees at 25% or less");
1031     }
1032 
1033     function updateDevWallet(address newWallet) external onlyOwner {
1034         devWallet = newWallet;
1035     }
1036 
1037     function excludeFromFees(address account, bool excluded) public onlyOwner {
1038         _isExcludedFromFees[account] = excluded;
1039         emit ExcludeFromFees(account, excluded);
1040     }
1041 
1042     function updateLimits() private {
1043         maxTransactionAmount = supply * transDigit / 100;
1044         swapTokensAtAmount = supply * 5 / 10000; // 0.05% swap wallet;
1045         maxWallet = supply * walletDigit / 100;
1046     }
1047 
1048     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1049         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1050 
1051         _setAutomatedMarketMakerPair(pair, value);
1052     }
1053 
1054     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1055         automatedMarketMakerPairs[pair] = value;
1056 
1057         emit SetAutomatedMarketMakerPair(pair, value);
1058     }
1059 
1060     function isExcludedFromFees(address account) public view returns(bool) {
1061         return _isExcludedFromFees[account];
1062     }
1063     
1064     function _transfer(
1065         address from,
1066         address to,
1067         uint256 amount
1068     ) internal override {
1069         require(from != address(0), "ERC20: transfer from the zero address");
1070         require(to != address(0), "ERC20: transfer to the zero address");
1071         require(!bots[from] && !bots[to], "This account is blacklisted");
1072         
1073          if(amount == 0) {
1074             super._transfer(from, to, 0);
1075             return;
1076         }
1077         
1078         if(limitsInEffect){
1079             if (
1080                 from != owner() &&
1081                 to != owner() &&
1082                 to != address(0) &&
1083                 to != address(0xdead) &&
1084                 !swapping
1085             ){
1086                 if(!tradingActive){
1087                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1088                 }
1089 
1090                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1091                 if (transferDelayEnabled){
1092                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1093                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1094                         _holderLastTransferTimestamp[tx.origin] = block.number + delayDigit;
1095                     }
1096                 }
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
1113         uint256 contractTokenBalance = balanceOf(address(this));
1114         
1115         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1116 
1117         if( 
1118             canSwap &&
1119             !swapping &&
1120             swapEnabled &&
1121             !automatedMarketMakerPairs[from] &&
1122             !_isExcludedFromFees[from] &&
1123             !_isExcludedFromFees[to]
1124         ) {
1125             swapping = true;
1126             
1127             swapBack();
1128 
1129             swapping = false;
1130         }
1131         
1132         bool takeFee = !swapping;
1133 
1134         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1135             takeFee = false;
1136         }
1137         
1138         uint256 fees = 0;
1139 
1140         if(takeFee){
1141             // on sell
1142             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1143                 fees = amount.mul(sellTotalFees).div(100);
1144                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
1145                 tokensForDev += fees * sellDevFee / sellTotalFees;
1146             }
1147 
1148             // on buy
1149             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1150 
1151         	    fees = amount.mul(buyTotalFees).div(100);
1152         	    tokensForBurn += fees * buyBurnFee / buyTotalFees;
1153                 tokensForDev += fees * buyDevFee / buyTotalFees;
1154             }
1155             
1156             if(fees > 0){    
1157                 super._transfer(from, address(this), fees);
1158                 if (tokensForBurn > 0) {
1159                     _burn(address(this), tokensForBurn);
1160                     supply = totalSupply();
1161                     updateLimits();
1162                     tokensForBurn = 0;
1163                 }
1164             }
1165         	
1166         	amount -= fees;
1167         }
1168 
1169         super._transfer(from, to, amount);
1170     }
1171 
1172     function swapTokensForEth(uint256 tokenAmount) private {
1173 
1174         // generate the uniswap pair path of token -> weth
1175         address[] memory path = new address[](2);
1176         path[0] = address(this);
1177         path[1] = uniswapV2Router.WETH();
1178 
1179         _approve(address(this), address(uniswapV2Router), tokenAmount);
1180 
1181         // make the swap
1182         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1183             tokenAmount,
1184             0, // accept any amount of ETH
1185             path,
1186             address(this),
1187             block.timestamp
1188         );
1189         
1190     }
1191     
1192     function swapBack() private {
1193         uint256 contractBalance = balanceOf(address(this));
1194         bool success;
1195         
1196         if(contractBalance == 0) {return;}
1197 
1198         if(contractBalance > swapTokensAtAmount * 20){
1199           contractBalance = swapTokensAtAmount * 20;
1200         }
1201 
1202         swapTokensForEth(contractBalance); 
1203         
1204         tokensForDev = 0;
1205 
1206         (success,) = address(devWallet).call{value: address(this).balance}("");
1207     }
1208 
1209 }