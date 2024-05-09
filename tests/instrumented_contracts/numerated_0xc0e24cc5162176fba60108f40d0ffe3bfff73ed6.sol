1 // SPDX-License-Identifier: MIT  
2 /*
3 TG: https://t.me/dojochip
4 
5 "When something is important enough, you do it even if the odds are not in your favor." Elon Musk
6 */ 
7                                                     
8 pragma solidity 0.8.9;
9 
10 abstract contract Context {
11     function _msgSender() internal view virtual returns (address) {
12         return msg.sender;
13     }
14 
15     function _msgData() internal view virtual returns (bytes calldata) {
16         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
17         return msg.data;
18     }
19 }
20 
21 interface IUniswapV2Pair {
22     event Approval(address indexed owner, address indexed spender, uint value);
23     event Transfer(address indexed from, address indexed to, uint value);
24 
25     function name() external pure returns (string memory);
26     function symbol() external pure returns (string memory);
27     function decimals() external pure returns (uint8);
28     function totalSupply() external view returns (uint);
29     function balanceOf(address owner) external view returns (uint);
30     function allowance(address owner, address spender) external view returns (uint);
31 
32     function approve(address spender, uint value) external returns (bool);
33     function transfer(address to, uint value) external returns (bool);
34     function transferFrom(address from, address to, uint value) external returns (bool);
35 
36     function DOMAIN_SEPARATOR() external view returns (bytes32);
37     function PERMIT_TYPEHASH() external pure returns (bytes32);
38     function nonces(address owner) external view returns (uint);
39 
40     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
41 
42     event Mint(address indexed sender, uint amount0, uint amount1);
43     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
44     event Swap(
45         address indexed sender,
46         uint amount0In,
47         uint amount1In,
48         uint amount0Out,
49         uint amount1Out,
50         address indexed to
51     );
52     event Sync(uint112 reserve0, uint112 reserve1);
53 
54     function MINIMUM_LIQUIDITY() external pure returns (uint);
55     function factory() external view returns (address);
56     function token0() external view returns (address);
57     function token1() external view returns (address);
58     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
59     function price0CumulativeLast() external view returns (uint);
60     function price1CumulativeLast() external view returns (uint);
61     function kLast() external view returns (uint);
62 
63     function mint(address to) external returns (uint liquidity);
64     function burn(address to) external returns (uint amount0, uint amount1);
65     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
66     function skim(address to) external;
67     function sync() external;
68 
69     function initialize(address, address) external;
70 }
71 
72 interface IUniswapV2Factory {
73     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
74 
75     function feeTo() external view returns (address);
76     function feeToSetter() external view returns (address);
77 
78     function getPair(address tokenA, address tokenB) external view returns (address pair);
79     function allPairs(uint) external view returns (address pair);
80     function allPairsLength() external view returns (uint);
81 
82     function createPair(address tokenA, address tokenB) external returns (address pair);
83 
84     function setFeeTo(address) external;
85     function setFeeToSetter(address) external;
86 }
87 
88 interface IERC20 {
89     /**
90      * @dev Returns the amount of tokens in existence.
91      */
92     function totalSupply() external view returns (uint256);
93 
94     /**
95      * @dev Returns the amount of tokens owned by `account`.
96      */
97     function balanceOf(address account) external view returns (uint256);
98 
99     /**
100      * @dev Moves `amount` tokens from the caller's account to `recipient`.
101      *
102      * Returns a boolean value indicating whether the operation succeeded.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transfer(address recipient, uint256 amount) external returns (bool);
107 
108     /**
109      * @dev Returns the remaining number of tokens that `spender` will be
110      * allowed to spend on behalf of `owner` through {transferFrom}. This is
111      * zero by default.
112      *
113      * This value changes when {approve} or {transferFrom} are called.
114      */
115     function allowance(address owner, address spender) external view returns (uint256);
116 
117     /**
118      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
119      *
120      * Returns a boolean value indicating whether the operation succeeded.
121      *
122      * IMPORTANT: Beware that changing an allowance with this method brings the risk
123      * that someone may use both the old and the new allowance by unfortunate
124      * transaction ordering. One possible solution to mitigate this race
125      * condition is to first reduce the spender's allowance to 0 and set the
126      * desired value afterwards:
127      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
128      *
129      * Emits an {Approval} event.
130      */
131     function approve(address spender, uint256 amount) external returns (bool);
132 
133     /**
134      * @dev Moves `amount` tokens from `sender` to `recipient` using the
135      * allowance mechanism. `amount` is then deducted from the caller's
136      * allowance.
137      *
138      * Returns a boolean value indicating whether the operation succeeded.
139      *
140      * Emits a {Transfer} event.
141      */
142     function transferFrom(
143         address sender,
144         address recipient,
145         uint256 amount
146     ) external returns (bool);
147 
148     /**
149      * @dev Emitted when `value` tokens are moved from one account (`from`) to
150      * another (`to`).
151      *
152      * Note that `value` may be zero.
153      */
154     event Transfer(address indexed from, address indexed to, uint256 value);
155 
156     /**
157      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
158      * a call to {approve}. `value` is the new allowance.
159      */
160     event Approval(address indexed owner, address indexed spender, uint256 value);
161 }
162 
163 interface IERC20Metadata is IERC20 {
164     /**
165      * @dev Returns the name of the token.
166      */
167     function name() external view returns (string memory);
168 
169     /**
170      * @dev Returns the symbol of the token.
171      */
172     function symbol() external view returns (string memory);
173 
174     /**
175      * @dev Returns the decimals places of the token.
176      */
177     function decimals() external view returns (uint8);
178 }
179 
180 
181 contract ERC20 is Context, IERC20, IERC20Metadata {
182     using SafeMath for uint256;
183 
184     mapping (address => uint256) private _balances;
185 
186     mapping(address => mapping(address => uint256)) private _allowances;
187 
188     uint256 private _totalSupply;
189 
190     string private _name;
191     string private _symbol;
192 
193     /**
194      * @dev Sets the values for {name} and {symbol}.
195      *
196      * The default value of {decimals} is 18. To select a different value for
197      * {decimals} you should overload it.
198      *
199      * All two of these values are immutable: they can only be set once during
200      * construction.
201      */
202     constructor(string memory name_, string memory symbol_) {
203         _name = name_;
204         _symbol = symbol_;
205     }
206 
207     /**
208      * @dev Returns the name of the token.
209      */
210     function name() public view virtual override returns (string memory) {
211         return _name;
212     }
213 
214     /**
215      * @dev Returns the symbol of the token, usually a shorter version of the
216      * name.
217      */
218     function symbol() public view virtual override returns (string memory) {
219         return _symbol;
220     }
221 
222     /**
223      * @dev Returns the number of decimals used to get its user representation.
224      * For example, if `decimals` equals `2`, a balance of `505` tokens should
225      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
226      *
227      * Tokens usually opt for a value of 18, imitating the relationship between
228      * Ether and Wei. This is the value {ERC20} uses, unless this function is
229      * overridden;
230      *
231      * NOTE: This information is only used for _display_ purposes: it in
232      * no way affects any of the arithmetic of the contract, including
233      * {IERC20-balanceOf} and {IERC20-transfer}.
234      */
235     function decimals() public view virtual override returns (uint8) {
236         return 6;
237     }
238 
239     /**
240      * @dev See {IERC20-totalSupply}.
241      */
242     function totalSupply() public view virtual override returns (uint256) {
243         return _totalSupply;
244     }
245 
246     /**
247      * @dev See {IERC20-balanceOf}.
248      */
249     function balanceOf(address account) public view virtual override returns (uint256) {
250         return _balances[account];
251     }
252 
253     /**
254      * @dev See {IERC20-transfer}.
255      *
256      * Requirements:
257      *
258      * - `recipient` cannot be the zero address.
259      * - the caller must have a balance of at least `amount`.
260      */
261     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
262         _transfer(_msgSender(), recipient, amount);
263         return true;
264     }
265 
266     /**
267      * @dev See {IERC20-allowance}.
268      */
269     function allowance(address owner, address spender) public view virtual override returns (uint256) {
270         return _allowances[owner][spender];
271     }
272 
273     /**
274      * @dev See {IERC20-approve}.
275      *
276      * Requirements:
277      *
278      * - `spender` cannot be the zero address.
279      */
280     function approve(address spender, uint256 amount) public virtual override returns (bool) {
281         _approve(_msgSender(), spender, amount);
282         return true;
283     }
284 
285     /**
286      * @dev See {IERC20-transferFrom}.
287      *
288      * Emits an {Approval} event indicating the updated allowance. This is not
289      * required by the EIP. See the note at the beginning of {ERC20}.
290      *
291      * Requirements:
292      *
293      * - `sender` and `recipient` cannot be the zero address.
294      * - `sender` must have a balance of at least `amount`.
295      * - the caller must have allowance for ``sender``'s tokens of at least
296      * `amount`.
297      */
298     function transferFrom(
299         address sender,
300         address recipient,
301         uint256 amount
302     ) public virtual override returns (bool) {
303         _transfer(sender, recipient, amount);
304         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
305         return true;
306     }
307 
308     /**
309      * @dev Atomically increases the allowance granted to `spender` by the caller.
310      *
311      * This is an alternative to {approve} that can be used as a mitigation for
312      * problems described in {IERC20-approve}.
313      *
314      * Emits an {Approval} event indicating the updated allowance.
315      *
316      * Requirements:
317      *
318      * - `spender` cannot be the zero address.
319      */
320     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
321         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
322         return true;
323     }
324 
325     /**
326      * @dev Atomically decreases the allowance granted to `spender` by the caller.
327      *
328      * This is an alternative to {approve} that can be used as a mitigation for
329      * problems described in {IERC20-approve}.
330      *
331      * Emits an {Approval} event indicating the updated allowance.
332      *
333      * Requirements:
334      *
335      * - `spender` cannot be the zero address.
336      * - `spender` must have allowance for the caller of at least
337      * `subtractedValue`.
338      */
339     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
340         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
341         return true;
342     }
343 
344     /**
345      * @dev Moves tokens `amount` from `sender` to `recipient`.
346      *
347      * This is internal function is equivalent to {transfer}, and can be used to
348      * e.g. implement automatic token fees, slashing mechanisms, etc.
349      *
350      * Emits a {Transfer} event.
351      *
352      * Requirements:
353      *
354      * - `sender` cannot be the zero address.
355      * - `recipient` cannot be the zero address.
356      * - `sender` must have a balance of at least `amount`.
357      */
358     function _transfer(
359         address sender,
360         address recipient,
361         uint256 amount
362     ) internal virtual {
363         require(sender != address(0), "ERC20: transfer from the zero address");
364         require(recipient != address(0), "ERC20: transfer to the zero address");
365 
366         _beforeTokenTransfer(sender, recipient, amount);
367 
368         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
369         _balances[recipient] = _balances[recipient].add(amount);
370         emit Transfer(sender, recipient, amount);
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
387         _totalSupply = _totalSupply.add(amount);
388         _balances[account] = _balances[account].add(amount);
389         emit Transfer(address(0), account, amount);
390     }
391 
392     /**
393      * @dev Destroys `amount` tokens from `account`, reducing the
394      * total supply.
395      *
396      * Emits a {Transfer} event with `to` set to the zero address.
397      *
398      * Requirements:
399      *
400      * - `account` cannot be the zero address.
401      * - `account` must have at least `amount` tokens.
402      */
403     function _burn(address account, uint256 amount) internal virtual {
404         require(account != address(0), "ERC20: burn from the zero address");
405 
406         _beforeTokenTransfer(account, address(0), amount);
407 
408         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
409         _totalSupply = _totalSupply.sub(amount);
410         emit Transfer(account, address(0), amount);
411     }
412 
413     /**
414      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
415      *
416      * This internal function is equivalent to `approve`, and can be used to
417      * e.g. set automatic allowances for certain subsystems, etc.
418      *
419      * Emits an {Approval} event.
420      *
421      * Requirements:
422      *
423      * - `owner` cannot be the zero address.
424      * - `spender` cannot be the zero address.
425      */
426     function _approve(
427         address owner,
428         address spender,
429         uint256 amount
430     ) internal virtual {
431         require(owner != address(0), "ERC20: approve from the zero address");
432         require(spender != address(0), "ERC20: approve to the zero address");
433 
434         _allowances[owner][spender] = amount;
435 
436         emit Approval(owner, spender, amount);
437     }
438 
439     /**
440      * @dev Hook that is called before any transfer of tokens. This includes
441      * minting and burning.
442      *
443      * Calling conditions:
444      *
445      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
446      * will be to transferred to `to`.
447      * - when `from` is zero, `amount` tokens will be minted for `to`.
448      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
449      * - `from` and `to` are never both zero.
450      *
451      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
452      */
453     function _beforeTokenTransfer(
454         address from,
455         address to,
456         uint256 amount
457     ) internal virtual {}
458 }
459 
460 library SafeMath {
461     /**
462      * @dev Returns the addition of two unsigned integers, reverting on
463      * overflow.
464      *
465      * Counterpart to Solidity's `+` operator.
466      *
467      * Requirements:
468      *
469      * - Addition cannot overflow.
470      */
471     function add(uint256 a, uint256 b) internal pure returns (uint256) {
472         uint256 c = a + b;
473         require(c >= a, "SafeMath: addition overflow");
474 
475         return c;
476     }
477 
478     /**
479      * @dev Returns the subtraction of two unsigned integers, reverting on
480      * overflow (when the result is negative).
481      *
482      * Counterpart to Solidity's `-` operator.
483      *
484      * Requirements:
485      *
486      * - Subtraction cannot overflow.
487      */
488     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
489         return sub(a, b, "SafeMath: subtraction overflow");
490     }
491 
492     /**
493      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
494      * overflow (when the result is negative).
495      *
496      * Counterpart to Solidity's `-` operator.
497      *
498      * Requirements:
499      *
500      * - Subtraction cannot overflow.
501      */
502     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
503         require(b <= a, errorMessage);
504         uint256 c = a - b;
505 
506         return c;
507     }
508 
509     /**
510      * @dev Returns the multiplication of two unsigned integers, reverting on
511      * overflow.
512      *
513      * Counterpart to Solidity's `*` operator.
514      *
515      * Requirements:
516      *
517      * - Multiplication cannot overflow.
518      */
519     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
520         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
521         // benefit is lost if 'b' is also tested.
522         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
523         if (a == 0) {
524             return 0;
525         }
526 
527         uint256 c = a * b;
528         require(c / a == b, "SafeMath: multiplication overflow");
529 
530         return c;
531     }
532 
533     /**
534      * @dev Returns the integer division of two unsigned integers. Reverts on
535      * division by zero. The result is rounded towards zero.
536      *
537      * Counterpart to Solidity's `/` operator. Note: this function uses a
538      * `revert` opcode (which leaves remaining gas untouched) while Solidity
539      * uses an invalid opcode to revert (consuming all remaining gas).
540      *
541      * Requirements:
542      *
543      * - The divisor cannot be zero.
544      */
545     function div(uint256 a, uint256 b) internal pure returns (uint256) {
546         return div(a, b, "SafeMath: division by zero");
547     }
548 
549     /**
550      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
551      * division by zero. The result is rounded towards zero.
552      *
553      * Counterpart to Solidity's `/` operator. Note: this function uses a
554      * `revert` opcode (which leaves remaining gas untouched) while Solidity
555      * uses an invalid opcode to revert (consuming all remaining gas).
556      *
557      * Requirements:
558      *
559      * - The divisor cannot be zero.
560      */
561     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
562         require(b > 0, errorMessage);
563         uint256 c = a / b;
564         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
565 
566         return c;
567     }
568 
569     /**
570      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
571      * Reverts when dividing by zero.
572      *
573      * Counterpart to Solidity's `%` operator. This function uses a `revert`
574      * opcode (which leaves remaining gas untouched) while Solidity uses an
575      * invalid opcode to revert (consuming all remaining gas).
576      *
577      * Requirements:
578      *
579      * - The divisor cannot be zero.
580      */
581     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
582         return mod(a, b, "SafeMath: modulo by zero");
583     }
584 
585     /**
586      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
587      * Reverts with custom message when dividing by zero.
588      *
589      * Counterpart to Solidity's `%` operator. This function uses a `revert`
590      * opcode (which leaves remaining gas untouched) while Solidity uses an
591      * invalid opcode to revert (consuming all remaining gas).
592      *
593      * Requirements:
594      *
595      * - The divisor cannot be zero.
596      */
597     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
598         require(b != 0, errorMessage);
599         return a % b;
600     }
601 }
602 
603 contract Ownable is Context {
604     address private _owner;
605 
606     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
607     
608     /**
609      * @dev Initializes the contract setting the deployer as the initial owner.
610      */
611     constructor () {
612         address msgSender = _msgSender();
613         _owner = msgSender;
614         emit OwnershipTransferred(address(0), msgSender);
615     }
616 
617     /**
618      * @dev Returns the address of the current owner.
619      */
620     function owner() public view returns (address) {
621         return _owner;
622     }
623 
624     /**
625      * @dev Throws if called by any account other than the owner.
626      */
627     modifier onlyOwner() {
628         require(_owner == _msgSender(), "Ownable: caller is not the owner");
629         _;
630     }
631 
632     /**
633      * @dev Leaves the contract without owner. It will not be possible to call
634      * `onlyOwner` functions anymore. Can only be called by the current owner.
635      *
636      * NOTE: Renouncing ownership will leave the contract without an owner,
637      * thereby removing any functionality that is only available to the owner.
638      */
639     function renounceOwnership() public virtual onlyOwner {
640         emit OwnershipTransferred(_owner, address(0));
641         _owner = address(0);
642     }
643 
644     /**
645      * @dev Transfers ownership of the contract to a new account (`newOwner`).
646      * Can only be called by the current owner.
647      */
648     function transferOwnership(address newOwner) public virtual onlyOwner {
649         require(newOwner != address(0), "Ownable: new owner is the zero address");
650         emit OwnershipTransferred(_owner, newOwner);
651         _owner = newOwner;
652     }
653 }
654 
655 interface IUniswapV2Router01 {
656     function factory() external pure returns (address);
657     function WETH() external pure returns (address);
658 
659     function addLiquidity(
660         address tokenA,
661         address tokenB,
662         uint amountADesired,
663         uint amountBDesired,
664         uint amountAMin,
665         uint amountBMin,
666         address to,
667         uint deadline
668     ) external returns (uint amountA, uint amountB, uint liquidity);
669     function addLiquidityETH(
670         address token,
671         uint amountTokenDesired,
672         uint amountTokenMin,
673         uint amountETHMin,
674         address to,
675         uint deadline
676     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
677     function removeLiquidity(
678         address tokenA,
679         address tokenB,
680         uint liquidity,
681         uint amountAMin,
682         uint amountBMin,
683         address to,
684         uint deadline
685     ) external returns (uint amountA, uint amountB);
686     function removeLiquidityETH(
687         address token,
688         uint liquidity,
689         uint amountTokenMin,
690         uint amountETHMin,
691         address to,
692         uint deadline
693     ) external returns (uint amountToken, uint amountETH);
694     function removeLiquidityWithPermit(
695         address tokenA,
696         address tokenB,
697         uint liquidity,
698         uint amountAMin,
699         uint amountBMin,
700         address to,
701         uint deadline,
702         bool approveMax, uint8 v, bytes32 r, bytes32 s
703     ) external returns (uint amountA, uint amountB);
704     function removeLiquidityETHWithPermit(
705         address token,
706         uint liquidity,
707         uint amountTokenMin,
708         uint amountETHMin,
709         address to,
710         uint deadline,
711         bool approveMax, uint8 v, bytes32 r, bytes32 s
712     ) external returns (uint amountToken, uint amountETH);
713     function swapExactTokensForTokens(
714         uint amountIn,
715         uint amountOutMin,
716         address[] calldata path,
717         address to,
718         uint deadline
719     ) external returns (uint[] memory amounts);
720     function swapTokensForExactTokens(
721         uint amountOut,
722         uint amountInMax,
723         address[] calldata path,
724         address to,
725         uint deadline
726     ) external returns (uint[] memory amounts);
727     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
728         external
729         payable
730         returns (uint[] memory amounts);
731     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
732         external
733         returns (uint[] memory amounts);
734     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
735         external
736         returns (uint[] memory amounts);
737     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
738         external
739         payable
740         returns (uint[] memory amounts);
741 
742     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
743     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
744     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
745     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
746     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
747 }
748 
749 interface IUniswapV2Router02 is IUniswapV2Router01 {
750     function removeLiquidityETHSupportingFeeOnTransferTokens(
751         address token,
752         uint liquidity,
753         uint amountTokenMin,
754         uint amountETHMin,
755         address to,
756         uint deadline
757     ) external returns (uint amountETH);
758     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
759         address token,
760         uint liquidity,
761         uint amountTokenMin,
762         uint amountETHMin,
763         address to,
764         uint deadline,
765         bool approveMax, uint8 v, bytes32 r, bytes32 s
766     ) external returns (uint amountETH);
767 
768     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
769         uint amountIn,
770         uint amountOutMin,
771         address[] calldata path,
772         address to,
773         uint deadline
774     ) external;
775     function swapExactETHForTokensSupportingFeeOnTransferTokens(
776         uint amountOutMin,
777         address[] calldata path,
778         address to,
779         uint deadline
780     ) external payable;
781     function swapExactTokensForETHSupportingFeeOnTransferTokens(
782         uint amountIn,
783         uint amountOutMin,
784         address[] calldata path,
785         address to,
786         uint deadline
787     ) external;
788 }
789 
790 contract DojoCHIP is ERC20, Ownable {
791     using SafeMath for uint256;
792 
793     mapping (address => uint256) private _rOwned;
794     uint256 private constant MAX = ~uint256(0);
795     uint256 private constant _tTotal = 9 * 1e6 * 1e6;
796     uint256 private _tSupply;
797     uint256 private _rTotal = (MAX - (MAX % _tTotal));
798     uint256 private _tFeeTotal;
799     
800     uint256 public maxTransactionAmount;
801     uint256 public maxWallet;
802     uint256 public swapTokensAtAmount;
803 
804     IUniswapV2Router02 public immutable uniswapV2Router;
805     address public immutable uniswapV2Pair;
806     address public constant deadAddress = address(0xdead);
807 
808     bool private swapping;
809 
810     address public Treasury;
811 
812     bool public limitsInEffect = true;
813     bool public tradingActive = false;
814     
815      // Anti-bot and anti-whale mappings and variables
816     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
817     bool public transferDelayEnabled = true;
818 
819     uint256 public buyTotalFees;
820     uint256 public buyTreasuryFee = 28;
821     uint256 public buyBurnFee = 1;
822     uint256 public buyReflectionFee = 1;
823     
824     uint256 public sellTotalFees;
825     uint256 public sellTreasuryFee = 28;
826     uint256 public sellBurnFee = 1;
827     uint256 public sellReflectionFee = 1;
828 
829     uint256 public tokensForTreasury;
830     uint256 public tokensForBurn;
831     uint256 public tokensForReflections;
832     
833     uint256 public walletDigit;
834     uint256 public transDigit;
835     uint256 public delayDigit;
836     
837     /******************/
838 
839     // exclude from fees, max transaction amount and max wallet amount
840     mapping (address => bool) private _isExcludedFromFees;
841     mapping (address => bool) public _isExcludedMaxTransactionAmount;
842     mapping (address => bool) public _isExcludedMaxWalletAmount;
843 
844     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
845     // could be subject to a maximum transfer amount
846     mapping (address => bool) public automatedMarketMakerPairs;
847 
848     constructor() ERC20("DojoCHIP", "dojo") {
849         
850         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
851         
852         excludeFromMaxTransaction(address(_uniswapV2Router), true);
853         excludeFromMaxWallet(address(_uniswapV2Router), true);
854         uniswapV2Router = _uniswapV2Router;
855         
856         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
857         excludeFromMaxTransaction(address(uniswapV2Pair), true);
858         excludeFromMaxWallet(address(uniswapV2Pair), true);
859         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
860 
861         buyTotalFees = buyTreasuryFee + buyBurnFee + buyReflectionFee;
862         sellTotalFees = sellTreasuryFee + sellBurnFee + sellReflectionFee;
863         
864         Treasury = 0x3d37743CC53fa989D910c13aE05AAfAc0d0f489b; 
865         _rOwned[_msgSender()] = _rTotal;
866         _tSupply = _tTotal;
867 
868         walletDigit = 1;
869         transDigit = 1;
870         delayDigit = 1;
871         
872         maxTransactionAmount =_tSupply * transDigit / 100;
873         swapTokensAtAmount = _tSupply * 5 / 10000; // 0.05% swap wallet;
874         maxWallet = _tSupply * walletDigit / 100;
875 
876         // exclude from paying fees or having max transaction amount, max wallet amount
877         excludeFromFees(owner(), true);
878         excludeFromFees(address(this), true);
879         excludeFromFees(address(0xdead), true);
880         
881         excludeFromMaxTransaction(owner(), true);
882         excludeFromMaxTransaction(address(this), true);
883         excludeFromMaxTransaction(address(0xdead), true);
884 
885         excludeFromMaxWallet(owner(), true);
886         excludeFromMaxWallet(address(this), true);
887         excludeFromMaxWallet(address(0xdead), true);
888 
889         _approve(owner(), address(uniswapV2Router), _tSupply);
890         _mint(msg.sender, _tSupply);
891     }
892 
893     receive() external payable {}
894 
895     // once enabled, can never be turned off
896     function enableTrading() external onlyOwner {
897         tradingActive = true;
898     }
899     
900     // remove limits after token is stable
901     function removeLimits() external onlyOwner returns (bool) {
902         limitsInEffect = false;
903         return true;
904     }
905 
906      // change the minimum amount of tokens to swap
907     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool) {
908   	    require(newAmount >= (totalSupply() * 1 / 100000) / 1e6, "Swap amount cannot be lower than 0.001% total supply.");
909   	    require(newAmount <= (totalSupply() * 5 / 1000) / 1e6, "Swap amount cannot be higher than 0.5% total supply.");
910   	    swapTokensAtAmount = newAmount * (10**6);
911   	    return true;
912   	}
913     
914     function updateTransDigit(uint256 newNum) external onlyOwner {
915         require(newNum >= 1);
916         transDigit = newNum;
917         updateLimits();
918     }
919 
920     function updateWalletDigit(uint256 newNum) external onlyOwner {
921         require(newNum >= 1);
922         walletDigit = newNum;
923         updateLimits();
924     }
925 
926     function updateDelayDigit(uint256 newNum) external onlyOwner{
927         delayDigit = newNum;
928     }
929     
930     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
931         _isExcludedMaxTransactionAmount[updAds] = isEx;
932     }
933 
934     function excludeFromMaxWallet(address updAds, bool isEx) public onlyOwner {
935         _isExcludedMaxWalletAmount[updAds] = isEx;
936     }
937 
938     function updateBuyFees(uint256 _treasuryFee, uint256 _burnFee, uint256 _reflectionFee) external onlyOwner {
939         buyTreasuryFee = _treasuryFee;
940         buyBurnFee = _burnFee;
941         buyReflectionFee = _reflectionFee;
942         buyTotalFees = buyTreasuryFee + buyBurnFee + buyReflectionFee;
943         require(buyTotalFees <= 10, "Must keep fees at 10% or less");
944     }
945     
946     function updateSellFees(uint256 _treasuryFee, uint256 _burnFee, uint256 _reflectionFee) external onlyOwner {
947         sellTreasuryFee = _treasuryFee;
948         sellBurnFee = _burnFee;
949         sellReflectionFee = _reflectionFee;
950         sellTotalFees = sellTreasuryFee + sellBurnFee + sellReflectionFee;
951         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
952     }
953 
954     function excludeFromFees(address account, bool excluded) public onlyOwner {
955         _isExcludedFromFees[account] = excluded;
956     }
957 
958     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
959         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
960 
961         _setAutomatedMarketMakerPair(pair, value);
962     }
963 
964     function _setAutomatedMarketMakerPair(address pair, bool value) private {
965         automatedMarketMakerPairs[pair] = value;
966 
967     }
968 
969     function updateTreasuryWallet(address newTreasuryWallet) external onlyOwner {
970         Treasury = newTreasuryWallet;
971     }
972 
973     function updateLimits() private {
974         maxTransactionAmount = _tSupply * transDigit / 100;
975         swapTokensAtAmount = _tSupply * 1 / 10000; // 0.01% swap wallet;
976         maxWallet = _tSupply * walletDigit / 100;
977     }
978 
979     function isExcludedFromFees(address account) external view returns(bool) {
980         return _isExcludedFromFees[account];
981     }
982 
983     function _transfer(
984         address from,
985         address to,
986         uint256 amount
987     ) internal override {
988         require(from != address(0), "ERC20: transfer from the zero address");
989         require(to != address(0), "ERC20: transfer to the zero address");
990         require(amount > 0, "Transfer amount must be greater than zero");
991 
992         if (limitsInEffect) {
993             if (
994                 from != owner() &&
995                 to != owner() &&
996                 to != address(0) &&
997                 to != address(0xdead) &&
998                 !swapping
999             ) {
1000                 if (!tradingActive) {
1001                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1002                 }
1003  
1004                 if (transferDelayEnabled){
1005                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1006                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1007                         _holderLastTransferTimestamp[tx.origin] = block.number + delayDigit;
1008                     }
1009                 }
1010 
1011                 // when buy
1012                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1013                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1014                 }
1015 
1016                 if (!_isExcludedMaxTransactionAmount[from]) {
1017                     require(amount <= maxTransactionAmount, "transfer amount exceeds the maxTransactionAmount.");
1018                 }
1019 
1020                 if (!_isExcludedMaxWalletAmount[to]) {
1021                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1022                 }
1023             }
1024         }
1025 
1026 		uint256 contractTokenBalance = balanceOf(address(this));
1027         
1028         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1029 
1030         if ( 
1031             canSwap &&
1032             !swapping &&
1033             !automatedMarketMakerPairs[from] &&
1034             !_isExcludedFromFees[from] &&
1035             !_isExcludedFromFees[to]
1036         ) {
1037             swapping = true;
1038             
1039             swapBack();
1040 
1041             swapping = false;
1042         }
1043 
1044         bool takeFee = !swapping;
1045 
1046         // if any account belongs to _isExcludedFromFee account then remove the fee
1047         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1048             takeFee = false;
1049         }
1050         
1051         uint256 fees = 0;
1052         uint256 reflectionFee = 0;
1053  
1054         if (takeFee){
1055 
1056             // on buy
1057             if (automatedMarketMakerPairs[from] && to != address(uniswapV2Router)) {
1058                 fees = amount.mul(buyTotalFees).div(100);
1059                 getTokensForFees(amount, buyTreasuryFee, buyBurnFee, buyReflectionFee);
1060             }
1061 
1062             // on sell
1063             else if (automatedMarketMakerPairs[to] && from != address(uniswapV2Router)) {
1064                     fees = amount.mul(sellTotalFees).div(100);
1065                     getTokensForFees(amount, sellTreasuryFee, sellBurnFee, sellReflectionFee);
1066             }
1067 
1068             if (fees > 0) {
1069                 _tokenTransfer(from, address(this), fees, 0);
1070                 uint256 refiAmount = tokensForBurn + tokensForReflections;
1071                 bool refiAndBurn = refiAmount > 0;
1072 
1073                 if(refiAndBurn){
1074                     burnAndReflect(refiAmount);
1075                 }
1076 
1077             }
1078 
1079             amount -= fees;
1080         }
1081 
1082         _tokenTransfer(from, to, amount, reflectionFee);
1083     }
1084 
1085     function getTokensForFees(uint256 _amount, uint256 _treasuryFee, uint256 _burnFee, uint256 _reflectionFee) private {
1086         tokensForTreasury += _amount.mul(_treasuryFee).div(100);
1087         tokensForBurn += _amount.mul(_burnFee).div(100);
1088         tokensForReflections += _amount.mul(_reflectionFee).div(100);
1089     }
1090 
1091     function swapTokensForEth(uint256 tokenAmount) private {
1092 
1093         // generate the uniswap pair path of token -> weth
1094         address[] memory path = new address[](2);
1095         path[0] = address(this);
1096         path[1] = uniswapV2Router.WETH();
1097 
1098         _approve(address(this), address(uniswapV2Router), tokenAmount);
1099 
1100         // make the swap
1101         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1102             tokenAmount,
1103             0, // accept any amount of ETH
1104             path,
1105             address(this),
1106             block.timestamp
1107         );
1108         
1109     }
1110 
1111     function swapBack() private {
1112         uint256 contractBalance = balanceOf(address(this));
1113         bool success;
1114         
1115         if(contractBalance == 0) {return;}
1116 
1117         swapTokensForEth(contractBalance); 
1118 
1119         tokensForTreasury = 0;
1120 
1121         
1122         (success,) = address(Treasury).call{value: address(this).balance}("");
1123     }
1124 
1125     // Reflection
1126     function totalSupply() public view override returns (uint256) {
1127         return _tSupply;
1128     }
1129 
1130     function balanceOf(address account) public view override returns (uint256) {
1131         return tokenFromReflection(_rOwned[account]);
1132     }
1133 
1134     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
1135         require(rAmount <= _rTotal, "Amount must be less than total reflections");
1136         uint256 currentRate =  _getRate();
1137         return rAmount.div(currentRate);
1138     }
1139 
1140     function _tokenTransfer(address sender, address recipient, uint256 amount, uint256 reflectionFee) private {      
1141         _transferStandard(sender, recipient, amount, reflectionFee);
1142     }
1143 
1144     function _transferStandard(address sender, address recipient, uint256 tAmount, uint256 reflectionFee) private {
1145         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount, reflectionFee);
1146         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1147         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1148         _reflectFee(rFee, tFee);
1149         emit Transfer(sender, recipient, tTransferAmount);
1150     }
1151 
1152     function _reflectFee(uint256 rFee, uint256 tFee) private {
1153         _rTotal = _rTotal.sub(rFee);
1154         _tFeeTotal = _tFeeTotal.add(tFee);
1155     }
1156 
1157     function _getValues(uint256 tAmount, uint256 reflectionFee) private view returns (uint256, uint256, uint256, uint256, uint256) {
1158         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount, reflectionFee);
1159         uint256 currentRate =  _getRate();
1160         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1161         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
1162     }
1163 
1164     function _getTValues(uint256 tAmount, uint256 reflectionFee) private pure returns (uint256, uint256) {
1165         uint256 tFee = tAmount.mul(reflectionFee).div(100);
1166         uint256 tTransferAmount = tAmount.sub(tFee);
1167         return (tTransferAmount, tFee);
1168     }
1169 
1170     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1171         uint256 rAmount = tAmount.mul(currentRate);
1172         uint256 rFee = tFee.mul(currentRate);
1173         uint256 rTransferAmount = rAmount.sub(rFee);
1174         return (rAmount, rTransferAmount, rFee);
1175     }
1176 
1177     function _getRate() private view returns(uint256) {
1178         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1179         return rSupply.div(tSupply);
1180     }
1181 
1182     function _getCurrentSupply() private view returns(uint256, uint256) {
1183         uint256 rSupply = _rTotal;
1184         uint256 tSupply = _tTotal;
1185 
1186         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1187         return (rSupply, tSupply);
1188     }
1189     
1190     function burnAndReflect(uint256 _amount) private {
1191         _tokenTransfer(address(this), deadAddress, _amount, 50);
1192         _tSupply -= _amount.div(2);
1193         tokensForReflections = 0;
1194         tokensForBurn = 0;
1195         updateLimits();
1196     }
1197 
1198 
1199 }