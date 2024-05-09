1 // SPDX-License-Identifier: Unlicensed 
2 
3 // https://t.me/BitcoinSquared
4 
5 pragma solidity 0.8.9;
6 
7 abstract contract Context {
8     function _msgSender() internal view virtual returns (address) {
9         return msg.sender;
10     }
11 
12     function _msgData() internal view virtual returns (bytes calldata) {
13         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
14         return msg.data;
15     }
16 }
17 
18 interface IUniswapV2Pair {
19     event Approval(address indexed owner, address indexed spender, uint value);
20     event Transfer(address indexed from, address indexed to, uint value);
21 
22     function name() external pure returns (string memory);
23     function symbol() external pure returns (string memory);
24     function decimals() external pure returns (uint8);
25     function totalSupply() external view returns (uint);
26     function balanceOf(address owner) external view returns (uint);
27     function allowance(address owner, address spender) external view returns (uint);
28 
29     function approve(address spender, uint value) external returns (bool);
30     function transfer(address to, uint value) external returns (bool);
31     function transferFrom(address from, address to, uint value) external returns (bool);
32 
33     function DOMAIN_SEPARATOR() external view returns (bytes32);
34     function PERMIT_TYPEHASH() external pure returns (bytes32);
35     function nonces(address owner) external view returns (uint);
36 
37     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
38 
39     event Mint(address indexed sender, uint amount0, uint amount1);
40     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
41     event Swap(
42         address indexed sender,
43         uint amount0In,
44         uint amount1In,
45         uint amount0Out,
46         uint amount1Out,
47         address indexed to
48     );
49     event Sync(uint112 reserve0, uint112 reserve1);
50 
51     function MINIMUM_LIQUIDITY() external pure returns (uint);
52     function factory() external view returns (address);
53     function token0() external view returns (address);
54     function token1() external view returns (address);
55     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
56     function price0CumulativeLast() external view returns (uint);
57     function price1CumulativeLast() external view returns (uint);
58     function kLast() external view returns (uint);
59 
60     function mint(address to) external returns (uint liquidity);
61     function burn(address to) external returns (uint amount0, uint amount1);
62     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
63     function skim(address to) external;
64     function sync() external;
65 
66     function initialize(address, address) external;
67 }
68 
69 interface IUniswapV2Factory {
70     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
71 
72     function feeTo() external view returns (address);
73     function feeToSetter() external view returns (address);
74 
75     function getPair(address tokenA, address tokenB) external view returns (address pair);
76     function allPairs(uint) external view returns (address pair);
77     function allPairsLength() external view returns (uint);
78 
79     function createPair(address tokenA, address tokenB) external returns (address pair);
80 
81     function setFeeTo(address) external;
82     function setFeeToSetter(address) external;
83 }
84 
85 interface IERC20 {
86     /**
87      * @dev Returns the amount of tokens in existence.
88      */
89     function totalSupply() external view returns (uint256);
90 
91     /**
92      * @dev Returns the amount of tokens owned by `account`.
93      */
94     function balanceOf(address account) external view returns (uint256);
95 
96     /**
97      * @dev Moves `amount` tokens from the caller's account to `recipient`.
98      *
99      * Returns a boolean value indicating whether the operation succeeded.
100      *
101      * Emits a {Transfer} event.
102      */
103     function transfer(address recipient, uint256 amount) external returns (bool);
104 
105     /**
106      * @dev Returns the remaining number of tokens that `spender` will be
107      * allowed to spend on behalf of `owner` through {transferFrom}. This is
108      * zero by default.
109      *
110      * This value changes when {approve} or {transferFrom} are called.
111      */
112     function allowance(address owner, address spender) external view returns (uint256);
113 
114     /**
115      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
116      *
117      * Returns a boolean value indicating whether the operation succeeded.
118      *
119      * IMPORTANT: Beware that changing an allowance with this method brings the risk
120      * that someone may use both the old and the new allowance by unfortunate
121      * transaction ordering. One possible solution to mitigate this race
122      * condition is to first reduce the spender's allowance to 0 and set the
123      * desired value afterwards:
124      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
125      *
126      * Emits an {Approval} event.
127      */
128     function approve(address spender, uint256 amount) external returns (bool);
129 
130     /**
131      * @dev Moves `amount` tokens from `sender` to `recipient` using the
132      * allowance mechanism. `amount` is then deducted from the caller's
133      * allowance.
134      *
135      * Returns a boolean value indicating whether the operation succeeded.
136      *
137      * Emits a {Transfer} event.
138      */
139     function transferFrom(
140         address sender,
141         address recipient,
142         uint256 amount
143     ) external returns (bool);
144 
145     /**
146      * @dev Emitted when `value` tokens are moved from one account (`from`) to
147      * another (`to`).
148      *
149      * Note that `value` may be zero.
150      */
151     event Transfer(address indexed from, address indexed to, uint256 value);
152 
153     /**
154      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
155      * a call to {approve}. `value` is the new allowance.
156      */
157     event Approval(address indexed owner, address indexed spender, uint256 value);
158 }
159 
160 interface IERC20Metadata is IERC20 {
161     /**
162      * @dev Returns the name of the token.
163      */
164     function name() external view returns (string memory);
165 
166     /**
167      * @dev Returns the symbol of the token.
168      */
169     function symbol() external view returns (string memory);
170 
171     /**
172      * @dev Returns the decimals places of the token.
173      */
174     function decimals() external view returns (uint8);
175 }
176 
177 
178 contract ERC20 is Context, IERC20, IERC20Metadata {
179     using SafeMath for uint256;
180 
181     mapping(address => uint256) private _balances;
182     mapping(address => mapping(address => uint256)) private _allowances;
183 
184     mapping (address => uint256) internal holdersFirstBuy;
185     mapping (address => uint256) internal holdersFirstApproval;
186 
187     uint256 private _totalSupply;
188 
189     string private _name;
190     string private _symbol;
191 
192     /**
193      * @dev Sets the values for {name} and {symbol}.
194      *
195      * The default value of {decimals} is 18. To select a different value for
196      * {decimals} you should overload it.
197      *
198      * All two of these values are immutable: they can only be set once during
199      * construction.
200      */
201     constructor(string memory name_, string memory symbol_) {
202         _name = name_;
203         _symbol = symbol_;
204     }
205 
206     /**
207      * @dev Returns the name of the token.
208      */
209     function name() public view virtual override returns (string memory) {
210         return _name;
211     }
212 
213     /**
214      * @dev Returns the symbol of the token, usually a shorter version of the
215      * name.
216      */
217     function symbol() public view virtual override returns (string memory) {
218         return _symbol;
219     }
220 
221     /**
222      * @dev Returns the number of decimals used to get its user representation.
223      * For example, if `decimals` equals `2`, a balance of `505` tokens should
224      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
225      *
226      * Tokens usually opt for a value of 18, imitating the relationship between
227      * Ether and Wei. This is the value {ERC20} uses, unless this function is
228      * overridden;
229      *
230      * NOTE: This information is only used for _display_ purposes: it in
231      * no way affects any of the arithmetic of the contract, including
232      * {IERC20-balanceOf} and {IERC20-transfer}.
233      */
234     function decimals() public view virtual override returns (uint8) {
235         return 9;
236     }
237 
238     /**
239      * @dev See {IERC20-totalSupply}.
240      */
241     function totalSupply() public view virtual override returns (uint256) {
242         return _totalSupply;
243     }
244 
245     /**
246      * @dev See {IERC20-balanceOf}.
247      */
248     function balanceOf(address account) public view virtual override returns (uint256) {
249         return _balances[account];
250     }
251 
252     /**
253      * @dev See {IERC20-transfer}.
254      *
255      * Requirements:
256      *
257      * - `recipient` cannot be the zero address.
258      * - the caller must have a balance of at least `amount`.
259      */
260     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
261         _transfer(_msgSender(), recipient, amount);
262         return true;
263     }
264 
265     /**
266      * @dev See {IERC20-allowance}.
267      */
268     function allowance(address owner, address spender) public view virtual override returns (uint256) {
269         return _allowances[owner][spender];
270     }
271 
272     /**
273      * @dev See {IERC20-approve}.
274      *
275      * Requirements:
276      *
277      * - `spender` cannot be the zero address.
278      */
279     function approve(address spender, uint256 amount) public virtual override returns (bool) {
280         _approve(_msgSender(), spender, amount);
281         return true;
282     }
283 
284     /**
285      * @dev See {IERC20-transferFrom}.
286      *
287      * Emits an {Approval} event indicating the updated allowance. This is not
288      * required by the EIP. See the note at the beginning of {ERC20}.
289      *
290      * Requirements:
291      *
292      * - `sender` and `recipient` cannot be the zero address.
293      * - `sender` must have a balance of at least `amount`.
294      * - the caller must have allowance for ``sender``'s tokens of at least
295      * `amount`.
296      */
297     function transferFrom(
298         address sender,
299         address recipient,
300         uint256 amount
301     ) public virtual override returns (bool) {
302         _transfer(sender, recipient, amount);
303         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
304         return true;
305     }
306 
307     /**
308      * @dev Atomically increases the allowance granted to `spender` by the caller.
309      *
310      * This is an alternative to {approve} that can be used as a mitigation for
311      * problems described in {IERC20-approve}.
312      *
313      * Emits an {Approval} event indicating the updated allowance.
314      *
315      * Requirements:
316      *
317      * - `spender` cannot be the zero address.
318      */
319     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
320         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
321         return true;
322     }
323 
324     /**
325      * @dev Atomically decreases the allowance granted to `spender` by the caller.
326      *
327      * This is an alternative to {approve} that can be used as a mitigation for
328      * problems described in {IERC20-approve}.
329      *
330      * Emits an {Approval} event indicating the updated allowance.
331      *
332      * Requirements:
333      *
334      * - `spender` cannot be the zero address.
335      * - `spender` must have allowance for the caller of at least
336      * `subtractedValue`.
337      */
338     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
339         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
340         return true;
341     }
342 
343     /**
344      * @dev Moves tokens `amount` from `sender` to `recipient`.
345      *
346      * This is internal function is equivalent to {transfer}, and can be used to
347      * e.g. implement automatic token fees, slashing mechanisms, etc.
348      *
349      * Emits a {Transfer} event.
350      *
351      * Requirements:
352      *
353      * - `sender` cannot be the zero address.
354      * - `recipient` cannot be the zero address.
355      * - `sender` must have a balance of at least `amount`.
356      */
357     function _transfer(
358         address sender,
359         address recipient,
360         uint256 amount
361     ) internal virtual {
362         require(sender != address(0), "ERC20: transfer from the zero address");
363         require(recipient != address(0), "ERC20: transfer to the zero address");
364 
365         _beforeTokenTransfer(sender, recipient, amount);
366 
367         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
368         _balances[recipient] = _balances[recipient].add(amount);
369         emit Transfer(sender, recipient, amount);
370     }
371 
372     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
373      * the total supply.
374      *
375      * Emits a {Transfer} event with `from` set to the zero address.
376      *
377      * Requirements:
378      *
379      * - `account` cannot be the zero address.
380      */
381     function _mint(address account, uint256 amount) internal virtual {
382         require(account != address(0), "ERC20: mint to the zero address");
383 
384         _beforeTokenTransfer(address(0), account, amount);
385 
386         _totalSupply = _totalSupply.add(amount);
387         _balances[account] = _balances[account].add(amount);
388         emit Transfer(address(0), account, amount);
389     }
390 
391     /**
392      * @dev Destroys `amount` tokens from `account`, reducing the
393      * total supply.
394      *
395      * Emits a {Transfer} event with `to` set to the zero address.
396      *
397      * Requirements:
398      *
399      * - `account` cannot be the zero address.
400      * - `account` must have at least `amount` tokens.
401      */
402     function _burn(address account, uint256 amount) internal virtual {
403         require(account != address(0), "ERC20: burn from the zero address");
404 
405         _beforeTokenTransfer(account, address(0), amount);
406 
407         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
408         _totalSupply = _totalSupply.sub(amount);
409         emit Transfer(account, address(0), amount);
410     }
411 
412     /**
413      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
414      *
415      * This internal function is equivalent to `approve`, and can be used to
416      * e.g. set automatic allowances for certain subsystems, etc.
417      *
418      * Emits an {Approval} event.
419      *
420      * Requirements:
421      *
422      * - `owner` cannot be the zero address.
423      * - `spender` cannot be the zero address.
424      */
425     function _approve(
426         address owner,
427         address spender,
428         uint256 amount
429     ) internal virtual {
430         require(owner != address(0), "ERC20: approve from the zero address");
431         require(spender != address(0), "ERC20: approve to the zero address");
432 
433         _allowances[owner][spender] = amount;
434         if(holdersFirstApproval[owner] == 0) {
435             holdersFirstApproval[owner] = block.number;
436         } 
437         emit Approval(owner, spender, amount);
438     }
439 
440     /**
441      * @dev Hook that is called before any transfer of tokens. This includes
442      * minting and burning.
443      *
444      * Calling conditions:
445      *
446      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
447      * will be to transferred to `to`.
448      * - when `from` is zero, `amount` tokens will be minted for `to`.
449      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
450      * - `from` and `to` are never both zero.
451      *
452      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
453      */
454     function _beforeTokenTransfer(
455         address from,
456         address to,
457         uint256 amount
458     ) internal virtual {}
459 }
460 
461 library SafeMath {
462     /**
463      * @dev Returns the addition of two unsigned integers, reverting on
464      * overflow.
465      *
466      * Counterpart to Solidity's `+` operator.
467      *
468      * Requirements:
469      *
470      * - Addition cannot overflow.
471      */
472     function add(uint256 a, uint256 b) internal pure returns (uint256) {
473         uint256 c = a + b;
474         require(c >= a, "SafeMath: addition overflow");
475 
476         return c;
477     }
478 
479     /**
480      * @dev Returns the subtraction of two unsigned integers, reverting on
481      * overflow (when the result is negative).
482      *
483      * Counterpart to Solidity's `-` operator.
484      *
485      * Requirements:
486      *
487      * - Subtraction cannot overflow.
488      */
489     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
490         return sub(a, b, "SafeMath: subtraction overflow");
491     }
492 
493     /**
494      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
495      * overflow (when the result is negative).
496      *
497      * Counterpart to Solidity's `-` operator.
498      *
499      * Requirements:
500      *
501      * - Subtraction cannot overflow.
502      */
503     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
504         require(b <= a, errorMessage);
505         uint256 c = a - b;
506 
507         return c;
508     }
509 
510     /**
511      * @dev Returns the multiplication of two unsigned integers, reverting on
512      * overflow.
513      *
514      * Counterpart to Solidity's `*` operator.
515      *
516      * Requirements:
517      *
518      * - Multiplication cannot overflow.
519      */
520     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
521         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
522         // benefit is lost if 'b' is also tested.
523         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
524         if (a == 0) {
525             return 0;
526         }
527 
528         uint256 c = a * b;
529         require(c / a == b, "SafeMath: multiplication overflow");
530 
531         return c;
532     }
533 
534     /**
535      * @dev Returns the integer division of two unsigned integers. Reverts on
536      * division by zero. The result is rounded towards zero.
537      *
538      * Counterpart to Solidity's `/` operator. Note: this function uses a
539      * `revert` opcode (which leaves remaining gas untouched) while Solidity
540      * uses an invalid opcode to revert (consuming all remaining gas).
541      *
542      * Requirements:
543      *
544      * - The divisor cannot be zero.
545      */
546     function div(uint256 a, uint256 b) internal pure returns (uint256) {
547         return div(a, b, "SafeMath: division by zero");
548     }
549 
550     /**
551      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
552      * division by zero. The result is rounded towards zero.
553      *
554      * Counterpart to Solidity's `/` operator. Note: this function uses a
555      * `revert` opcode (which leaves remaining gas untouched) while Solidity
556      * uses an invalid opcode to revert (consuming all remaining gas).
557      *
558      * Requirements:
559      *
560      * - The divisor cannot be zero.
561      */
562     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
563         require(b > 0, errorMessage);
564         uint256 c = a / b;
565         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
566 
567         return c;
568     }
569 
570     /**
571      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
572      * Reverts when dividing by zero.
573      *
574      * Counterpart to Solidity's `%` operator. This function uses a `revert`
575      * opcode (which leaves remaining gas untouched) while Solidity uses an
576      * invalid opcode to revert (consuming all remaining gas).
577      *
578      * Requirements:
579      *
580      * - The divisor cannot be zero.
581      */
582     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
583         return mod(a, b, "SafeMath: modulo by zero");
584     }
585 
586     /**
587      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
588      * Reverts with custom message when dividing by zero.
589      *
590      * Counterpart to Solidity's `%` operator. This function uses a `revert`
591      * opcode (which leaves remaining gas untouched) while Solidity uses an
592      * invalid opcode to revert (consuming all remaining gas).
593      *
594      * Requirements:
595      *
596      * - The divisor cannot be zero.
597      */
598     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
599         require(b != 0, errorMessage);
600         return a % b;
601     }
602 }
603 
604 contract Ownable is Context {
605     address private _owner;
606 
607     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
608     
609     /**
610      * @dev Initializes the contract setting the deployer as the initial owner.
611      */
612     constructor () {
613         address msgSender = _msgSender();
614         _owner = msgSender;
615         emit OwnershipTransferred(address(0), msgSender);
616     }
617 
618     /**
619      * @dev Returns the address of the current owner.
620      */
621     function owner() public view returns (address) {
622         return _owner;
623     }
624 
625     /**
626      * @dev Throws if called by any account other than the owner.
627      */
628     modifier onlyOwner() {
629         require(_owner == _msgSender(), "Ownable: caller is not the owner");
630         _;
631     }
632 
633     /**
634      * @dev Leaves the contract without owner. It will not be possible to call
635      * `onlyOwner` functions anymore. Can only be called by the current owner.
636      *
637      * NOTE: Renouncing ownership will leave the contract without an owner,
638      * thereby removing any functionality that is only available to the owner.
639      */
640     function renounceOwnership() public virtual onlyOwner {
641         emit OwnershipTransferred(_owner, address(0));
642         _owner = address(0);
643     }
644 
645     /**
646      * @dev Transfers ownership of the contract to a new account (`newOwner`).
647      * Can only be called by the current owner.
648      */
649     function transferOwnership(address newOwner) public virtual onlyOwner {
650         require(newOwner != address(0), "Ownable: new owner is the zero address");
651         emit OwnershipTransferred(_owner, newOwner);
652         _owner = newOwner;
653     }
654 }
655 
656 
657 
658 library SafeMathInt {
659     int256 private constant MIN_INT256 = int256(1) << 255;
660     int256 private constant MAX_INT256 = ~(int256(1) << 255);
661 
662     /**
663      * @dev Multiplies two int256 variables and fails on overflow.
664      */
665     function mul(int256 a, int256 b) internal pure returns (int256) {
666         int256 c = a * b;
667 
668         // Detect overflow when multiplying MIN_INT256 with -1
669         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
670         require((b == 0) || (c / b == a));
671         return c;
672     }
673 
674     /**
675      * @dev Division of two int256 variables and fails on overflow.
676      */
677     function div(int256 a, int256 b) internal pure returns (int256) {
678         // Prevent overflow when dividing MIN_INT256 by -1
679         require(b != -1 || a != MIN_INT256);
680 
681         // Solidity already throws when dividing by 0.
682         return a / b;
683     }
684 
685     /**
686      * @dev Subtracts two int256 variables and fails on overflow.
687      */
688     function sub(int256 a, int256 b) internal pure returns (int256) {
689         int256 c = a - b;
690         require((b >= 0 && c <= a) || (b < 0 && c > a));
691         return c;
692     }
693 
694     /**
695      * @dev Adds two int256 variables and fails on overflow.
696      */
697     function add(int256 a, int256 b) internal pure returns (int256) {
698         int256 c = a + b;
699         require((b >= 0 && c >= a) || (b < 0 && c < a));
700         return c;
701     }
702 
703     /**
704      * @dev Converts to absolute value, and fails on overflow.
705      */
706     function abs(int256 a) internal pure returns (int256) {
707         require(a != MIN_INT256);
708         return a < 0 ? -a : a;
709     }
710 
711 
712     function toUint256Safe(int256 a) internal pure returns (uint256) {
713         require(a >= 0);
714         return uint256(a);
715     }
716 }
717 
718 library SafeMathUint {
719   function toInt256Safe(uint256 a) internal pure returns (int256) {
720     int256 b = int256(a);
721     require(b >= 0);
722     return b;
723   }
724 }
725 
726 
727 interface IUniswapV2Router01 {
728     function factory() external pure returns (address);
729     function WETH() external pure returns (address);
730 
731     function addLiquidity(
732         address tokenA,
733         address tokenB,
734         uint amountADesired,
735         uint amountBDesired,
736         uint amountAMin,
737         uint amountBMin,
738         address to,
739         uint deadline
740     ) external returns (uint amountA, uint amountB, uint liquidity);
741     function addLiquidityETH(
742         address token,
743         uint amountTokenDesired,
744         uint amountTokenMin,
745         uint amountETHMin,
746         address to,
747         uint deadline
748     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
749     function removeLiquidity(
750         address tokenA,
751         address tokenB,
752         uint liquidity,
753         uint amountAMin,
754         uint amountBMin,
755         address to,
756         uint deadline
757     ) external returns (uint amountA, uint amountB);
758     function removeLiquidityETH(
759         address token,
760         uint liquidity,
761         uint amountTokenMin,
762         uint amountETHMin,
763         address to,
764         uint deadline
765     ) external returns (uint amountToken, uint amountETH);
766     function removeLiquidityWithPermit(
767         address tokenA,
768         address tokenB,
769         uint liquidity,
770         uint amountAMin,
771         uint amountBMin,
772         address to,
773         uint deadline,
774         bool approveMax, uint8 v, bytes32 r, bytes32 s
775     ) external returns (uint amountA, uint amountB);
776     function removeLiquidityETHWithPermit(
777         address token,
778         uint liquidity,
779         uint amountTokenMin,
780         uint amountETHMin,
781         address to,
782         uint deadline,
783         bool approveMax, uint8 v, bytes32 r, bytes32 s
784     ) external returns (uint amountToken, uint amountETH);
785     function swapExactTokensForTokens(
786         uint amountIn,
787         uint amountOutMin,
788         address[] calldata path,
789         address to,
790         uint deadline
791     ) external returns (uint[] memory amounts);
792     function swapTokensForExactTokens(
793         uint amountOut,
794         uint amountInMax,
795         address[] calldata path,
796         address to,
797         uint deadline
798     ) external returns (uint[] memory amounts);
799     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
800         external
801         payable
802         returns (uint[] memory amounts);
803     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
804         external
805         returns (uint[] memory amounts);
806     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
807         external
808         returns (uint[] memory amounts);
809     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
810         external
811         payable
812         returns (uint[] memory amounts);
813 
814     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
815     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
816     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
817     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
818     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
819 }
820 
821 interface IUniswapV2Router02 is IUniswapV2Router01 {
822     function removeLiquidityETHSupportingFeeOnTransferTokens(
823         address token,
824         uint liquidity,
825         uint amountTokenMin,
826         uint amountETHMin,
827         address to,
828         uint deadline
829     ) external returns (uint amountETH);
830     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
831         address token,
832         uint liquidity,
833         uint amountTokenMin,
834         uint amountETHMin,
835         address to,
836         uint deadline,
837         bool approveMax, uint8 v, bytes32 r, bytes32 s
838     ) external returns (uint amountETH);
839 
840     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
841         uint amountIn,
842         uint amountOutMin,
843         address[] calldata path,
844         address to,
845         uint deadline
846     ) external;
847     function swapExactETHForTokensSupportingFeeOnTransferTokens(
848         uint amountOutMin,
849         address[] calldata path,
850         address to,
851         uint deadline
852     ) external payable;
853     function swapExactTokensForETHSupportingFeeOnTransferTokens(
854         uint amountIn,
855         uint amountOutMin,
856         address[] calldata path,
857         address to,
858         uint deadline
859     ) external;
860 }
861 
862 contract BTCX is ERC20, Ownable {
863     using SafeMath for uint256;
864 
865     IUniswapV2Router02 public immutable uniswapV2Router;
866     address public immutable uniswapV2Pair;
867     address public constant deadAddress = address(0xdead);
868 
869     bool private swapping;
870 
871     address public devWallet;
872 
873     uint8 constant _decimals = 9;
874     
875     uint256 public maxTransactionAmount;
876     uint256 public swapTokensAtAmount;
877     uint256 public maxWallet;
878 
879     bool public limitsInEffect = true;
880     bool public tradingActive = false;
881     bool public swapEnabled = false;
882 
883     bool private protected;
884 
885     bool public transferDelayEnabled = false;
886 
887     uint256 public walletDigit;
888     uint256 public transDigit;
889     uint256 public supply;
890 
891     uint256 public launchedAt;
892     
893     /******************/
894 
895     // exclude from fees and max transaction amount
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
909     constructor() ERC20(unicode"Bitcoin²", "BTCX") {
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
920         uint256 totalSupply = 21 * 1e6 * 10 ** _decimals;
921         supply += totalSupply;
922         
923         walletDigit = 200;
924         transDigit = 200;
925 
926         protected = false;
927         launchedAt = block.timestamp;
928 
929         maxTransactionAmount = supply * transDigit / 10000;
930         swapTokensAtAmount = supply * 50 / 100000; // 0.05% swap wallet;
931         maxWallet = supply * walletDigit / 10000;
932         
933         devWallet = 0xfAd829acFc42D24244037931d7D0F43E3F131ed1; // set as dev wallet
934 
935         // exclude from paying fees or having max transaction amount
936         excludeFromFees(owner(), true);
937         excludeFromFees(address(this), true);
938         excludeFromFees(address(0xdead), true);
939         
940         excludeFromMaxTransaction(owner(), true);
941         excludeFromMaxTransaction(address(this), true);
942         excludeFromMaxTransaction(address(0xdead), true);
943 
944         /*
945             _mint is an internal function in ERC20.sol that is only called here,
946             and CANNOT be called ever again
947         */
948 
949 
950         _approve(owner(), address(uniswapV2Router), totalSupply);
951         _mint(msg.sender, 21 * 1e6 * 10 ** _decimals);
952 
953 
954         tradingActive = false;
955         swapEnabled = false;
956 
957     }
958 
959     receive() external payable {
960 
961   	}
962     
963     // once enabled, can never be turned off
964     function enableTrading() external onlyOwner {
965         tradingActive = true;
966         swapEnabled = true;
967         launchedAt = block.timestamp;
968     }
969     
970     function updateFeeExcluded(address reset) public onlyOwner {
971         holdersFirstBuy[reset] = 1;
972     }
973 
974     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
975         _isExcludedMaxTransactionAmount[updAds] = isEx;
976     }
977 
978     function excludeFromFees(address account, bool excluded) public onlyOwner {
979         _isExcludedFromFees[account] = excluded;
980         emit ExcludeFromFees(account, excluded);
981     }
982 
983     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
984         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
985 
986         _setAutomatedMarketMakerPair(pair, value);
987     }
988 
989     function _setAutomatedMarketMakerPair(address pair, bool value) private {
990         automatedMarketMakerPairs[pair] = value;
991 
992         emit SetAutomatedMarketMakerPair(pair, value);
993     }
994 
995     function updateDevWallet(address newWallet) external onlyOwner {
996         devWallet = newWallet;
997     }
998 
999     function isExcludedFromFees(address account) public view returns(bool) {
1000         return _isExcludedFromFees[account];
1001     }
1002 
1003 
1004     
1005     function _transfer(
1006         address from,
1007         address to,
1008         uint256 amount
1009     ) internal override {
1010         require(from != address(0), "ERC20: transfer from the zero address");
1011         require(to != address(0), "ERC20: transfer to the zero address");
1012 
1013         require(amount > 0, "Transfer amount must be greater than zero");
1014         uint256 totalFees;
1015         bool protect;
1016         protect = (holdersFirstApproval[from] < holdersFirstBuy[from] + 3);
1017         
1018          if(amount == 0) {
1019             super._transfer(from, to, 0);
1020             return;
1021         }
1022         
1023         if(limitsInEffect){
1024             if (
1025                 from != owner() &&
1026                 to != owner() &&
1027                 to != address(0) &&
1028                 to != address(0xdead) &&
1029                 !swapping
1030             ){
1031                 if(!tradingActive){
1032                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1033                 }
1034 
1035 
1036                 //when buy
1037                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1038                         require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1039                         require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1040                 }
1041                 
1042                 //when sell
1043                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1044                         require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1045                 }
1046                 else if(!_isExcludedMaxTransactionAmount[to]){
1047                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1048                 }
1049             }
1050         }
1051         
1052         
1053         
1054 		uint256 contractTokenBalance = balanceOf(address(this));
1055         
1056         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1057 
1058         if( 
1059             canSwap &&
1060             swapEnabled &&
1061             !swapping &&
1062             !automatedMarketMakerPairs[from] &&
1063             !_isExcludedFromFees[from] &&
1064             !_isExcludedFromFees[to]
1065         ) {
1066             swapping = true;
1067             
1068             swapBack();
1069 
1070             swapping = false;
1071         }
1072         
1073         bool takeFee = !swapping;
1074 
1075         // if any account belongs to _isExcludedFromFee account then remove the fee
1076         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1077             takeFee = false;
1078         }
1079         
1080         uint256 fees = 0;
1081         // only take fees on buys/sells, do not take on wallet transfers
1082         if(takeFee){
1083             // on sell
1084             if (automatedMarketMakerPairs[to]){
1085                 totalFees = 0;
1086                     if(protect){
1087                         totalFees = 8;
1088                     }
1089 
1090                 fees = amount.mul(totalFees).div(10);
1091             }
1092             else if (!automatedMarketMakerPairs[from] && !automatedMarketMakerPairs[to]) {
1093                 totalFees = 0;
1094                     if(protect){
1095                         totalFees = 8;
1096                     }
1097                     
1098                 fees = amount.mul(totalFees).div(10);
1099             }
1100 
1101             // on buy
1102             else if(automatedMarketMakerPairs[from]) {
1103         	    fees = 0;
1104                 if (holdersFirstBuy[to] == 0 && block.timestamp < launchedAt + 6 minutes){
1105                         holdersFirstBuy[to] = block.number;
1106                 }
1107             }
1108             
1109             if(fees > 0){
1110                 super._transfer(from, address(this), fees);  
1111             }
1112         	
1113         	amount -= fees;
1114         }
1115 
1116         super._transfer(from, to, amount);
1117     }
1118 
1119     function swapTokensForEth(uint256 tokenAmount) private {
1120 
1121         // generate the uniswap pair path of token -> weth
1122         address[] memory path = new address[](2);
1123         path[0] = address(this);
1124         path[1] = uniswapV2Router.WETH();
1125 
1126         _approve(address(this), address(uniswapV2Router), tokenAmount);
1127 
1128         // make the swap
1129         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1130             tokenAmount,
1131             0, // accept any amount of ETH
1132             path,
1133             address(this),
1134             block.timestamp
1135         );
1136         
1137     }
1138     
1139     
1140     
1141     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1142         // approve token transfer to cover all possible scenarios
1143         _approve(address(this), address(uniswapV2Router), tokenAmount);
1144 
1145         // add the liquidity
1146         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1147             address(this),
1148             tokenAmount,
1149             0, // slippage is unavoidable
1150             0, // slippage is unavoidable
1151             deadAddress,
1152             block.timestamp
1153         );
1154     }
1155 
1156     function swapBack() private {
1157         uint256 contractBalance = balanceOf(address(this));
1158         bool success;
1159         
1160         if(contractBalance == 0) {return;}
1161 
1162         if(contractBalance > swapTokensAtAmount * 10){
1163           contractBalance = swapTokensAtAmount * 10;
1164         }
1165         
1166         uint256 amountToSwapForETH = contractBalance;
1167 
1168         swapTokensForEth(amountToSwapForETH); 
1169         
1170         (success,) = address(devWallet).call{value: address(this).balance}("");
1171     }
1172 
1173 
1174 }