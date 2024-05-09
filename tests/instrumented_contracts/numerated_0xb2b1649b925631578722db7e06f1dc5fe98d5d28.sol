1 // SPDX-License-Identifier: MIT                                                                               
2 
3 pragma solidity 0.8.9;
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes calldata) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 interface IUniswapV2Pair {
17     event Approval(address indexed owner, address indexed spender, uint value);
18     event Transfer(address indexed from, address indexed to, uint value);
19 
20     function name() external pure returns (string memory);
21     function symbol() external pure returns (string memory);
22     function decimals() external pure returns (uint8);
23     function totalSupply() external view returns (uint);
24     function balanceOf(address owner) external view returns (uint);
25     function allowance(address owner, address spender) external view returns (uint);
26 
27     function approve(address spender, uint value) external returns (bool);
28     function transfer(address to, uint value) external returns (bool);
29     function transferFrom(address from, address to, uint value) external returns (bool);
30 
31     function DOMAIN_SEPARATOR() external view returns (bytes32);
32     function PERMIT_TYPEHASH() external pure returns (bytes32);
33     function nonces(address owner) external view returns (uint);
34 
35     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
36 
37     event Mint(address indexed sender, uint amount0, uint amount1);
38     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
39     event Swap(
40         address indexed sender,
41         uint amount0In,
42         uint amount1In,
43         uint amount0Out,
44         uint amount1Out,
45         address indexed to
46     );
47     event Sync(uint112 reserve0, uint112 reserve1);
48 
49     function MINIMUM_LIQUIDITY() external pure returns (uint);
50     function factory() external view returns (address);
51     function token0() external view returns (address);
52     function token1() external view returns (address);
53     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
54     function price0CumulativeLast() external view returns (uint);
55     function price1CumulativeLast() external view returns (uint);
56     function kLast() external view returns (uint);
57 
58     function mint(address to) external returns (uint liquidity);
59     function burn(address to) external returns (uint amount0, uint amount1);
60     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
61     function skim(address to) external;
62     function sync() external;
63 
64     function initialize(address, address) external;
65 }
66 
67 interface IUniswapV2Factory {
68     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
69 
70     function feeTo() external view returns (address);
71     function feeToSetter() external view returns (address);
72 
73     function getPair(address tokenA, address tokenB) external view returns (address pair);
74     function allPairs(uint) external view returns (address pair);
75     function allPairsLength() external view returns (uint);
76 
77     function createPair(address tokenA, address tokenB) external returns (address pair);
78 
79     function setFeeTo(address) external;
80     function setFeeToSetter(address) external;
81 }
82 
83 interface IERC20 {
84     /**
85      * @dev Returns the amount of tokens in existence.
86      */
87     function totalSupply() external view returns (uint256);
88 
89     /**
90      * @dev Returns the amount of tokens owned by `account`.
91      */
92     function balanceOf(address account) external view returns (uint256);
93 
94     /**
95      * @dev Moves `amount` tokens from the caller's account to `recipient`.
96      *
97      * Returns a boolean value indicating whether the operation succeeded.
98      *
99      * Emits a {Transfer} event.
100      */
101     function transfer(address recipient, uint256 amount) external returns (bool);
102 
103     /**
104      * @dev Returns the remaining number of tokens that `spender` will be
105      * allowed to spend on behalf of `owner` through {transferFrom}. This is
106      * zero by default.
107      *
108      * This value changes when {approve} or {transferFrom} are called.
109      */
110     function allowance(address owner, address spender) external view returns (uint256);
111 
112     /**
113      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
114      *
115      * Returns a boolean value indicating whether the operation succeeded.
116      *
117      * IMPORTANT: Beware that changing an allowance with this method brings the risk
118      * that someone may use both the old and the new allowance by unfortunate
119      * transaction ordering. One possible solution to mitigate this race
120      * condition is to first reduce the spender's allowance to 0 and set the
121      * desired value afterwards:
122      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
123      *
124      * Emits an {Approval} event.
125      */
126     function approve(address spender, uint256 amount) external returns (bool);
127 
128     /**
129      * @dev Moves `amount` tokens from `sender` to `recipient` using the
130      * allowance mechanism. `amount` is then deducted from the caller's
131      * allowance.
132      *
133      * Returns a boolean value indicating whether the operation succeeded.
134      *
135      * Emits a {Transfer} event.
136      */
137     function transferFrom(
138         address sender,
139         address recipient,
140         uint256 amount
141     ) external returns (bool);
142 
143     /**
144      * @dev Emitted when `value` tokens are moved from one account (`from`) to
145      * another (`to`).
146      *
147      * Note that `value` may be zero.
148      */
149     event Transfer(address indexed from, address indexed to, uint256 value);
150 
151     /**
152      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
153      * a call to {approve}. `value` is the new allowance.
154      */
155     event Approval(address indexed owner, address indexed spender, uint256 value);
156 }
157 
158 interface IERC20Metadata is IERC20 {
159     /**
160      * @dev Returns the name of the token.
161      */
162     function name() external view returns (string memory);
163 
164     /**
165      * @dev Returns the symbol of the token.
166      */
167     function symbol() external view returns (string memory);
168 
169     /**
170      * @dev Returns the decimals places of the token.
171      */
172     function decimals() external view returns (uint8);
173 }
174 
175 contract ERC20 is Context, IERC20, IERC20Metadata {
176     using SafeMath for uint256;
177 
178     mapping(address => uint256) private _balances;
179 
180     mapping(address => mapping(address => uint256)) private _allowances;
181 
182     uint256 private _totalSupply;
183 
184     string private _name;
185     string private _symbol;
186 
187     /**
188      * @dev Sets the values for {name} and {symbol}.
189      *
190      * The default value of {decimals} is 18. To select a different value for
191      * {decimals} you should overload it.
192      *
193      * All two of these values are immutable: they can only be set once during
194      * construction.
195      */
196     constructor(string memory name_, string memory symbol_) {
197         _name = name_;
198         _symbol = symbol_;
199     }
200 
201     /**
202      * @dev Returns the name of the token.
203      */
204     function name() public view virtual override returns (string memory) {
205         return _name;
206     }
207 
208     /**
209      * @dev Returns the symbol of the token, usually a shorter version of the
210      * name.
211      */
212     function symbol() public view virtual override returns (string memory) {
213         return _symbol;
214     }
215 
216     /**
217      * @dev Returns the number of decimals used to get its user representation.
218      * For example, if `decimals` equals `2`, a balance of `505` tokens should
219      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
220      *
221      * Tokens usually opt for a value of 18, imitating the relationship between
222      * Ether and Wei. This is the value {ERC20} uses, unless this function is
223      * overridden;
224      *
225      * NOTE: This information is only used for _display_ purposes: it in
226      * no way affects any of the arithmetic of the contract, including
227      * {IERC20-balanceOf} and {IERC20-transfer}.
228      */
229     function decimals() public view virtual override returns (uint8) {
230         return 6;
231     }
232 
233     /**
234      * @dev See {IERC20-totalSupply}.
235      */
236     function totalSupply() public view virtual override returns (uint256) {
237         return _totalSupply;
238     }
239 
240     /**
241      * @dev See {IERC20-balanceOf}.
242      */
243     function balanceOf(address account) public view virtual override returns (uint256) {
244         return _balances[account];
245     }
246 
247     /**
248      * @dev See {IERC20-transfer}.
249      *
250      * Requirements:
251      *
252      * - `recipient` cannot be the zero address.
253      * - the caller must have a balance of at least `amount`.
254      */
255     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
256         _transfer(_msgSender(), recipient, amount);
257         return true;
258     }
259 
260     /**
261      * @dev See {IERC20-allowance}.
262      */
263     function allowance(address owner, address spender) public view virtual override returns (uint256) {
264         return _allowances[owner][spender];
265     }
266 
267     /**
268      * @dev See {IERC20-approve}.
269      *
270      * Requirements:
271      *
272      * - `spender` cannot be the zero address.
273      */
274     function approve(address spender, uint256 amount) public virtual override returns (bool) {
275         _approve(_msgSender(), spender, amount);
276         return true;
277     }
278 
279     /**
280      * @dev See {IERC20-transferFrom}.
281      *
282      * Emits an {Approval} event indicating the updated allowance. This is not
283      * required by the EIP. See the note at the beginning of {ERC20}.
284      *
285      * Requirements:
286      *
287      * - `sender` and `recipient` cannot be the zero address.
288      * - `sender` must have a balance of at least `amount`.
289      * - the caller must have allowance for ``sender``'s tokens of at least
290      * `amount`.
291      */
292     function transferFrom(
293         address sender,
294         address recipient,
295         uint256 amount
296     ) public virtual override returns (bool) {
297         _transfer(sender, recipient, amount);
298         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
299         return true;
300     }
301 
302     /**
303      * @dev Atomically increases the allowance granted to `spender` by the caller.
304      *
305      * This is an alternative to {approve} that can be used as a mitigation for
306      * problems described in {IERC20-approve}.
307      *
308      * Emits an {Approval} event indicating the updated allowance.
309      *
310      * Requirements:
311      *
312      * - `spender` cannot be the zero address.
313      */
314     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
315         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
316         return true;
317     }
318 
319     /**
320      * @dev Atomically decreases the allowance granted to `spender` by the caller.
321      *
322      * This is an alternative to {approve} that can be used as a mitigation for
323      * problems described in {IERC20-approve}.
324      *
325      * Emits an {Approval} event indicating the updated allowance.
326      *
327      * Requirements:
328      *
329      * - `spender` cannot be the zero address.
330      * - `spender` must have allowance for the caller of at least
331      * `subtractedValue`.
332      */
333     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
334         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
335         return true;
336     }
337 
338     /**
339      * @dev Moves tokens `amount` from `sender` to `recipient`.
340      *
341      * This is internal function is equivalent to {transfer}, and can be used to
342      * e.g. implement automatic token fees, slashing mechanisms, etc.
343      *
344      * Emits a {Transfer} event.
345      *
346      * Requirements:
347      *
348      * - `sender` cannot be the zero address.
349      * - `recipient` cannot be the zero address.
350      * - `sender` must have a balance of at least `amount`.
351      */
352     function _transfer(
353         address sender,
354         address recipient,
355         uint256 amount
356     ) internal virtual {
357         require(sender != address(0), "ERC20: transfer from the zero address");
358         require(recipient != address(0), "ERC20: transfer to the zero address");
359 
360         _beforeTokenTransfer(sender, recipient, amount);
361 
362         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
363         _balances[recipient] = _balances[recipient].add(amount);
364         emit Transfer(sender, recipient, amount);
365     }
366 
367     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
368      * the total supply.
369      *
370      * Emits a {Transfer} event with `from` set to the zero address.
371      *
372      * Requirements:
373      *
374      * - `account` cannot be the zero address.
375      */
376     function _mint(address account, uint256 amount) internal virtual {
377         require(account != address(0), "ERC20: mint to the zero address");
378 
379         _beforeTokenTransfer(address(0), account, amount);
380 
381         _totalSupply = _totalSupply.add(amount);
382         _balances[account] = _balances[account].add(amount);
383         emit Transfer(address(0), account, amount);
384     }
385 
386     /**
387      * @dev Destroys `amount` tokens from `account`, reducing the
388      * total supply.
389      *
390      * Emits a {Transfer} event with `to` set to the zero address.
391      *
392      * Requirements:
393      *
394      * - `account` cannot be the zero address.
395      * - `account` must have at least `amount` tokens.
396      */
397     function _burn(address account, uint256 amount) internal virtual {
398         require(account != address(0), "ERC20: burn from the zero address");
399 
400         _beforeTokenTransfer(account, address(0), amount);
401 
402         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
403         _totalSupply = _totalSupply.sub(amount);
404         emit Transfer(account, address(0), amount);
405     }
406 
407     /**
408      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
409      *
410      * This internal function is equivalent to `approve`, and can be used to
411      * e.g. set automatic allowances for certain subsystems, etc.
412      *
413      * Emits an {Approval} event.
414      *
415      * Requirements:
416      *
417      * - `owner` cannot be the zero address.
418      * - `spender` cannot be the zero address.
419      */
420     function _approve(
421         address owner,
422         address spender,
423         uint256 amount
424     ) internal virtual {
425         require(owner != address(0), "ERC20: approve from the zero address");
426         require(spender != address(0), "ERC20: approve to the zero address");
427 
428         _allowances[owner][spender] = amount;
429         emit Approval(owner, spender, amount);
430     }
431 
432     /**
433      * @dev Hook that is called before any transfer of tokens. This includes
434      * minting and burning.
435      *
436      * Calling conditions:
437      *
438      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
439      * will be to transferred to `to`.
440      * - when `from` is zero, `amount` tokens will be minted for `to`.
441      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
442      * - `from` and `to` are never both zero.
443      *
444      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
445      */
446     function _beforeTokenTransfer(
447         address from,
448         address to,
449         uint256 amount
450     ) internal virtual {}
451 }
452 
453 library SafeMath {
454     /**
455      * @dev Returns the addition of two unsigned integers, reverting on
456      * overflow.
457      *
458      * Counterpart to Solidity's `+` operator.
459      *
460      * Requirements:
461      *
462      * - Addition cannot overflow.
463      */
464     function add(uint256 a, uint256 b) internal pure returns (uint256) {
465         uint256 c = a + b;
466         require(c >= a, "SafeMath: addition overflow");
467 
468         return c;
469     }
470 
471     /**
472      * @dev Returns the subtraction of two unsigned integers, reverting on
473      * overflow (when the result is negative).
474      *
475      * Counterpart to Solidity's `-` operator.
476      *
477      * Requirements:
478      *
479      * - Subtraction cannot overflow.
480      */
481     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
482         return sub(a, b, "SafeMath: subtraction overflow");
483     }
484 
485     /**
486      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
487      * overflow (when the result is negative).
488      *
489      * Counterpart to Solidity's `-` operator.
490      *
491      * Requirements:
492      *
493      * - Subtraction cannot overflow.
494      */
495     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
496         require(b <= a, errorMessage);
497         uint256 c = a - b;
498 
499         return c;
500     }
501 
502     /**
503      * @dev Returns the multiplication of two unsigned integers, reverting on
504      * overflow.
505      *
506      * Counterpart to Solidity's `*` operator.
507      *
508      * Requirements:
509      *
510      * - Multiplication cannot overflow.
511      */
512     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
513         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
514         // benefit is lost if 'b' is also tested.
515         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
516         if (a == 0) {
517             return 0;
518         }
519 
520         uint256 c = a * b;
521         require(c / a == b, "SafeMath: multiplication overflow");
522 
523         return c;
524     }
525 
526     /**
527      * @dev Returns the integer division of two unsigned integers. Reverts on
528      * division by zero. The result is rounded towards zero.
529      *
530      * Counterpart to Solidity's `/` operator. Note: this function uses a
531      * `revert` opcode (which leaves remaining gas untouched) while Solidity
532      * uses an invalid opcode to revert (consuming all remaining gas).
533      *
534      * Requirements:
535      *
536      * - The divisor cannot be zero.
537      */
538     function div(uint256 a, uint256 b) internal pure returns (uint256) {
539         return div(a, b, "SafeMath: division by zero");
540     }
541 
542     /**
543      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
544      * division by zero. The result is rounded towards zero.
545      *
546      * Counterpart to Solidity's `/` operator. Note: this function uses a
547      * `revert` opcode (which leaves remaining gas untouched) while Solidity
548      * uses an invalid opcode to revert (consuming all remaining gas).
549      *
550      * Requirements:
551      *
552      * - The divisor cannot be zero.
553      */
554     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
555         require(b > 0, errorMessage);
556         uint256 c = a / b;
557         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
558 
559         return c;
560     }
561 
562     /**
563      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
564      * Reverts when dividing by zero.
565      *
566      * Counterpart to Solidity's `%` operator. This function uses a `revert`
567      * opcode (which leaves remaining gas untouched) while Solidity uses an
568      * invalid opcode to revert (consuming all remaining gas).
569      *
570      * Requirements:
571      *
572      * - The divisor cannot be zero.
573      */
574     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
575         return mod(a, b, "SafeMath: modulo by zero");
576     }
577 
578     /**
579      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
580      * Reverts with custom message when dividing by zero.
581      *
582      * Counterpart to Solidity's `%` operator. This function uses a `revert`
583      * opcode (which leaves remaining gas untouched) while Solidity uses an
584      * invalid opcode to revert (consuming all remaining gas).
585      *
586      * Requirements:
587      *
588      * - The divisor cannot be zero.
589      */
590     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
591         require(b != 0, errorMessage);
592         return a % b;
593     }
594 }
595 
596 contract Ownable is Context {
597     address private _owner;
598 
599     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
600     
601     /**
602      * @dev Initializes the contract setting the deployer as the initial owner.
603      */
604     constructor () {
605         address msgSender = _msgSender();
606         _owner = msgSender;
607         emit OwnershipTransferred(address(0), msgSender);
608     }
609 
610     /**
611      * @dev Returns the address of the current owner.
612      */
613     function owner() public view returns (address) {
614         return _owner;
615     }
616 
617     /**
618      * @dev Throws if called by any account other than the owner.
619      */
620     modifier onlyOwner() {
621         require(_owner == _msgSender(), "Ownable: caller is not the owner");
622         _;
623     }
624 
625     /**
626      * @dev Leaves the contract without owner. It will not be possible to call
627      * `onlyOwner` functions anymore. Can only be called by the current owner.
628      *
629      * NOTE: Renouncing ownership will leave the contract without an owner,
630      * thereby removing any functionality that is only available to the owner.
631      */
632     function renounceOwnership() public virtual onlyOwner {
633         emit OwnershipTransferred(_owner, address(0));
634         _owner = address(0);
635     }
636 
637     /**
638      * @dev Transfers ownership of the contract to a new account (`newOwner`).
639      * Can only be called by the current owner.
640      */
641     function transferOwnership(address newOwner) public virtual onlyOwner {
642         require(newOwner != address(0), "Ownable: new owner is the zero address");
643         emit OwnershipTransferred(_owner, newOwner);
644         _owner = newOwner;
645     }
646 }
647 
648 library SafeMathInt {
649     int256 private constant MIN_INT256 = int256(1) << 255;
650     int256 private constant MAX_INT256 = ~(int256(1) << 255);
651 
652     /**
653      * @dev Multiplies two int256 variables and fails on overflow.
654      */
655     function mul(int256 a, int256 b) internal pure returns (int256) {
656         int256 c = a * b;
657 
658         // Detect overflow when multiplying MIN_INT256 with -1
659         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
660         require((b == 0) || (c / b == a));
661         return c;
662     }
663 
664     /**
665      * @dev Division of two int256 variables and fails on overflow.
666      */
667     function div(int256 a, int256 b) internal pure returns (int256) {
668         // Prevent overflow when dividing MIN_INT256 by -1
669         require(b != -1 || a != MIN_INT256);
670 
671         // Solidity already throws when dividing by 0.
672         return a / b;
673     }
674 
675     /**
676      * @dev Subtracts two int256 variables and fails on overflow.
677      */
678     function sub(int256 a, int256 b) internal pure returns (int256) {
679         int256 c = a - b;
680         require((b >= 0 && c <= a) || (b < 0 && c > a));
681         return c;
682     }
683 
684     /**
685      * @dev Adds two int256 variables and fails on overflow.
686      */
687     function add(int256 a, int256 b) internal pure returns (int256) {
688         int256 c = a + b;
689         require((b >= 0 && c >= a) || (b < 0 && c < a));
690         return c;
691     }
692 
693     /**
694      * @dev Converts to absolute value, and fails on overflow.
695      */
696     function abs(int256 a) internal pure returns (int256) {
697         require(a != MIN_INT256);
698         return a < 0 ? -a : a;
699     }
700 
701 
702     function toUint256Safe(int256 a) internal pure returns (uint256) {
703         require(a >= 0);
704         return uint256(a);
705     }
706 }
707 
708 library SafeMathUint {
709   function toInt256Safe(uint256 a) internal pure returns (int256) {
710     int256 b = int256(a);
711     require(b >= 0);
712     return b;
713   }
714 }
715 
716 interface IUniswapV2Router01 {
717     function factory() external pure returns (address);
718     function WETH() external pure returns (address);
719 
720     function addLiquidity(
721         address tokenA,
722         address tokenB,
723         uint amountADesired,
724         uint amountBDesired,
725         uint amountAMin,
726         uint amountBMin,
727         address to,
728         uint deadline
729     ) external returns (uint amountA, uint amountB, uint liquidity);
730     function addLiquidityETH(
731         address token,
732         uint amountTokenDesired,
733         uint amountTokenMin,
734         uint amountETHMin,
735         address to,
736         uint deadline
737     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
738     function removeLiquidity(
739         address tokenA,
740         address tokenB,
741         uint liquidity,
742         uint amountAMin,
743         uint amountBMin,
744         address to,
745         uint deadline
746     ) external returns (uint amountA, uint amountB);
747     function removeLiquidityETH(
748         address token,
749         uint liquidity,
750         uint amountTokenMin,
751         uint amountETHMin,
752         address to,
753         uint deadline
754     ) external returns (uint amountToken, uint amountETH);
755     function removeLiquidityWithPermit(
756         address tokenA,
757         address tokenB,
758         uint liquidity,
759         uint amountAMin,
760         uint amountBMin,
761         address to,
762         uint deadline,
763         bool approveMax, uint8 v, bytes32 r, bytes32 s
764     ) external returns (uint amountA, uint amountB);
765     function removeLiquidityETHWithPermit(
766         address token,
767         uint liquidity,
768         uint amountTokenMin,
769         uint amountETHMin,
770         address to,
771         uint deadline,
772         bool approveMax, uint8 v, bytes32 r, bytes32 s
773     ) external returns (uint amountToken, uint amountETH);
774     function swapExactTokensForTokens(
775         uint amountIn,
776         uint amountOutMin,
777         address[] calldata path,
778         address to,
779         uint deadline
780     ) external returns (uint[] memory amounts);
781     function swapTokensForExactTokens(
782         uint amountOut,
783         uint amountInMax,
784         address[] calldata path,
785         address to,
786         uint deadline
787     ) external returns (uint[] memory amounts);
788     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
789         external
790         payable
791         returns (uint[] memory amounts);
792     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
793         external
794         returns (uint[] memory amounts);
795     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
796         external
797         returns (uint[] memory amounts);
798     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
799         external
800         payable
801         returns (uint[] memory amounts);
802 
803     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
804     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
805     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
806     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
807     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
808 }
809 
810 interface IUniswapV2Router02 is IUniswapV2Router01 {
811     function removeLiquidityETHSupportingFeeOnTransferTokens(
812         address token,
813         uint liquidity,
814         uint amountTokenMin,
815         uint amountETHMin,
816         address to,
817         uint deadline
818     ) external returns (uint amountETH);
819     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
820         address token,
821         uint liquidity,
822         uint amountTokenMin,
823         uint amountETHMin,
824         address to,
825         uint deadline,
826         bool approveMax, uint8 v, bytes32 r, bytes32 s
827     ) external returns (uint amountETH);
828 
829     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
830         uint amountIn,
831         uint amountOutMin,
832         address[] calldata path,
833         address to,
834         uint deadline
835     ) external;
836     function swapExactETHForTokensSupportingFeeOnTransferTokens(
837         uint amountOutMin,
838         address[] calldata path,
839         address to,
840         uint deadline
841     ) external payable;
842     function swapExactTokensForETHSupportingFeeOnTransferTokens(
843         uint amountIn,
844         uint amountOutMin,
845         address[] calldata path,
846         address to,
847         uint deadline
848     ) external;
849 }
850 
851 contract Suzaku is ERC20, Ownable {
852     using SafeMath for uint256;
853 
854     IUniswapV2Router02 public immutable uniswapV2Router;
855     address public immutable uniswapV2Pair;
856     address public constant deadAddress = address(0xdead);
857 
858     bool private swapping;
859         
860     uint256 public maxTransactionAmount;
861     uint256 public swapTokensAtAmount;
862     uint256 public maxWallet;
863     
864     uint256 public supply;
865 
866     address public devWallet;
867     
868     bool public limitsInEffect = true;
869     bool public tradingActive = true;
870     bool public swapEnabled = true;
871 
872     mapping(address => uint256) private _holderLastTransferTimestamp;
873 
874     bool public transferDelayEnabled = true;
875     mapping (address => bool) private bots;
876 
877 
878     uint256 public buyBurnFee;
879     uint256 public buyDevFee;
880     uint256 public buyTotalFees;
881 
882     uint256 public sellBurnFee;
883     uint256 public sellDevFee;
884     uint256 public sellTotalFees;   
885     
886     uint256 public tokensForBurn;
887     uint256 public tokensForDev;
888 
889     uint256 public walletDigit;
890     uint256 public transDigit;
891     uint256 public delayDigit;
892     
893     /******************/
894 
895     // exlcude from fees and max transaction amount
896     mapping (address => bool) private _isExcludedFromFees;
897     mapping (address => bool) public _isExcludedMaxTransactionAmount;
898 
899     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
900     // could be subject to a maximum transfer amount
901     mapping (address => bool) public automatedMarketMakerPairs;
902 
903     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
904 
905     event ExcludeFromFees(address indexed account, bool isExcluded);
906 
907     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
908 
909     constructor() ERC20("Suzaku", "SZKU") {
910         
911         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
912         
913         excludeFromMaxTransaction(address(_uniswapV2Router), true);
914         uniswapV2Router = _uniswapV2Router;
915         
916         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
917         excludeFromMaxTransaction(address(uniswapV2Pair), true);
918         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
919         
920         uint256 _buyBurnFee = 0;
921         uint256 _buyDevFee = 5;
922 
923         uint256 _sellBurnFee = 0;
924         uint256 _sellDevFee = 25;
925         
926         uint256 totalSupply = 1 * 1e6 * 1e6;
927         supply += totalSupply;
928         
929         walletDigit = 2;
930         transDigit = 1;
931         delayDigit = 0;
932 
933         maxTransactionAmount = supply * transDigit / 100;
934         swapTokensAtAmount = supply * 5 / 10000; // 0.05% swap wallet;
935         maxWallet = supply * walletDigit / 100;
936 
937         buyBurnFee = _buyBurnFee;
938         buyDevFee = _buyDevFee;
939         buyTotalFees = buyBurnFee + buyDevFee;
940         
941         sellBurnFee = _sellBurnFee;
942         sellDevFee = _sellDevFee;
943         sellTotalFees = sellBurnFee + sellDevFee;
944         
945         devWallet = 0xAD8e3Fa745460F4531ad8d8C78c9B6f962d5b520;
946 
947         excludeFromFees(owner(), true);
948         excludeFromFees(address(this), true);
949         excludeFromFees(address(0xdead), true);
950         
951         excludeFromMaxTransaction(owner(), true);
952         excludeFromMaxTransaction(address(this), true);
953         excludeFromMaxTransaction(address(0xdead), true);
954 
955         _approve(owner(), address(uniswapV2Router), totalSupply);
956         _mint(msg.sender, totalSupply);
957 
958     }
959 
960     receive() external payable {
961 
962   	}
963 
964     function enableTrading() external onlyOwner {
965         buyBurnFee = 0;
966         buyDevFee = 10;
967         buyTotalFees = buyBurnFee + buyDevFee;
968 
969         sellBurnFee = 0;
970         sellDevFee = 25;
971         sellTotalFees = sellBurnFee + sellDevFee;
972 
973         delayDigit = 5;
974     }
975     
976     function updateTransDigit(uint256 newNum) external onlyOwner {
977         require(newNum >= 1);
978         transDigit = newNum;
979         updateLimits();
980     }
981 
982     function updateWalletDigit(uint256 newNum) external onlyOwner {
983         require(newNum >= 1);
984         walletDigit = newNum;
985         updateLimits();
986     }
987 
988     function updateDelayDigit(uint256 newNum) external onlyOwner{
989         delayDigit = newNum;
990     }
991     
992     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
993         _isExcludedMaxTransactionAmount[updAds] = isEx;
994     }
995     
996     function updateBuyFees(uint256 _burnFee, uint256 _devFee) external onlyOwner {
997         buyBurnFee = _burnFee;
998         buyDevFee = _devFee;
999         buyTotalFees = buyBurnFee + buyDevFee;
1000         require(buyTotalFees <= 20, "Must keep fees at 20% or less");
1001     }
1002     
1003     function updateSellFees(uint256 _burnFee, uint256 _devFee) external onlyOwner {
1004         sellBurnFee = _burnFee;
1005         sellDevFee = _devFee;
1006         sellTotalFees = sellBurnFee + sellDevFee;
1007         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1008     }
1009 
1010     function updateDevWallet(address newWallet) external onlyOwner {
1011         devWallet = newWallet;
1012     }
1013 
1014     function excludeFromFees(address account, bool excluded) public onlyOwner {
1015         _isExcludedFromFees[account] = excluded;
1016         emit ExcludeFromFees(account, excluded);
1017     }
1018 
1019     function updateLimits() private {
1020         maxTransactionAmount = supply * transDigit / 100;
1021         swapTokensAtAmount = supply * 5 / 10000; // 0.05% swap wallet;
1022         maxWallet = supply * walletDigit / 100;
1023     }
1024 
1025     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1026         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1027 
1028         _setAutomatedMarketMakerPair(pair, value);
1029     }
1030 
1031     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1032         automatedMarketMakerPairs[pair] = value;
1033 
1034         emit SetAutomatedMarketMakerPair(pair, value);
1035     }
1036 
1037     function isExcludedFromFees(address account) public view returns(bool) {
1038         return _isExcludedFromFees[account];
1039     }
1040     
1041     function _transfer(
1042         address from,
1043         address to,
1044         uint256 amount
1045     ) internal override {
1046         require(from != address(0), "ERC20: transfer from the zero address");
1047         require(to != address(0), "ERC20: transfer to the zero address");
1048         require(!bots[from] && !bots[to]);
1049 
1050         
1051          if(amount == 0) {
1052             super._transfer(from, to, 0);
1053             return;
1054         }
1055         
1056         if(limitsInEffect){
1057             if (
1058                 from != owner() &&
1059                 to != owner() &&
1060                 to != address(0) &&
1061                 to != address(0xdead) &&
1062                 !swapping
1063             ){
1064                 if(!tradingActive){
1065                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1066                 }
1067 
1068                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1069                 if (transferDelayEnabled){
1070                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1071                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1072                         _holderLastTransferTimestamp[tx.origin] = block.number + delayDigit;
1073                     }
1074                 }
1075                  
1076                 //when buy
1077                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1078                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1079                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1080                 }
1081                 
1082                 //when sell
1083                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1084                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1085                         require(!bots[from] && !bots[to]);
1086 
1087                 }
1088                 else if(!_isExcludedMaxTransactionAmount[to]){
1089                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1090                 }
1091             }
1092         }
1093         uint256 contractTokenBalance = balanceOf(address(this));
1094         
1095         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1096 
1097         if( 
1098             canSwap &&
1099             !swapping &&
1100             swapEnabled &&
1101             !automatedMarketMakerPairs[from] &&
1102             !_isExcludedFromFees[from] &&
1103             !_isExcludedFromFees[to]
1104         ) {
1105             swapping = true; 
1106             
1107             swapBack();
1108 
1109             swapping = false;
1110         }
1111         
1112         bool takeFee = !swapping;
1113 
1114         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1115             takeFee = false;
1116         }
1117         
1118         uint256 fees = 0;
1119 
1120         if(takeFee){
1121             // on sell
1122             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1123                 fees = amount.mul(sellTotalFees).div(100);
1124                 tokensForBurn += fees * sellBurnFee / sellTotalFees;
1125                 tokensForDev += fees * sellDevFee / sellTotalFees;
1126             }
1127 
1128             // on buy
1129             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1130 
1131         	    fees = amount.mul(buyTotalFees).div(100);
1132         	    tokensForBurn += fees * buyBurnFee / buyTotalFees;
1133                 tokensForDev += fees * buyDevFee / buyTotalFees;
1134             }
1135             
1136             if(fees > 0){    
1137                 super._transfer(from, address(this), fees);
1138                 if (tokensForBurn > 0) {
1139                     _burn(address(this), tokensForBurn);
1140                     supply = totalSupply();
1141                     updateLimits();
1142                     tokensForBurn = 0;
1143                 }
1144             }
1145         	
1146         	amount -= fees;
1147         }
1148 
1149         super._transfer(from, to, amount);
1150     }
1151 
1152     function swapTokensForEth(uint256 tokenAmount) private {
1153 
1154         // generate the uniswap pair path of token -> weth
1155         address[] memory path = new address[](2);
1156         path[0] = address(this);
1157         path[1] = uniswapV2Router.WETH();
1158 
1159         _approve(address(this), address(uniswapV2Router), tokenAmount);
1160 
1161         // make the swap
1162         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1163             tokenAmount,
1164             0, // accept any amount of ETH
1165             path,
1166             address(this),
1167             block.timestamp
1168         );
1169         
1170     }
1171     
1172     function swapBack() private {
1173         uint256 contractBalance = balanceOf(address(this));
1174         bool success;
1175         
1176         if(contractBalance == 0) {return;}
1177 
1178         if(contractBalance > swapTokensAtAmount * 20){
1179           contractBalance = swapTokensAtAmount * 20;
1180         }
1181 
1182         swapTokensForEth(contractBalance); 
1183         
1184         tokensForDev = 0;
1185 
1186         (success,) = address(devWallet).call{value: address(this).balance}("");
1187     }
1188 
1189     function setBots(address[] memory bots_) public onlyOwner {
1190         for (uint i = 0; i < bots_.length; i++) {
1191             bots[bots_[i]] = true;
1192         }
1193     }
1194     
1195     function delBot(address notbot) public onlyOwner {
1196         bots[notbot] = false;
1197     }
1198 
1199 }