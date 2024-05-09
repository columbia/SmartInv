1 //Suki, along with Kabosu, is one of the most iconic dogs in the world. 
2 //Now immortalised on the Ethereum blockchain, $SUKI will live on forever.
3 //This is the final doge
4 
5 // SPDX-License-Identifier: MIT                                                                               
6                                                     
7 pragma solidity 0.8.15;
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes calldata) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19 
20 interface IUniswapV2Pair {
21     event Approval(address indexed owner, address indexed spender, uint value);
22     event Transfer(address indexed from, address indexed to, uint value);
23 
24     function name() external pure returns (string memory);
25     function symbol() external pure returns (string memory);
26     function decimals() external pure returns (uint8);
27     function totalSupply() external view returns (uint);
28     function balanceOf(address owner) external view returns (uint);
29     function allowance(address owner, address spender) external view returns (uint);
30 
31     function approve(address spender, uint value) external returns (bool);
32     function transfer(address to, uint value) external returns (bool);
33     function transferFrom(address from, address to, uint value) external returns (bool);
34 
35     function DOMAIN_SEPARATOR() external view returns (bytes32);
36     function PERMIT_TYPEHASH() external pure returns (bytes32);
37     function nonces(address owner) external view returns (uint);
38 
39     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
40 
41     event Mint(address indexed sender, uint amount0, uint amount1);
42     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
43     event Swap(
44         address indexed sender,
45         uint amount0In,
46         uint amount1In,
47         uint amount0Out,
48         uint amount1Out,
49         address indexed to
50     );
51     event Sync(uint112 reserve0, uint112 reserve1);
52 
53     function MINIMUM_LIQUIDITY() external pure returns (uint);
54     function factory() external view returns (address);
55     function token0() external view returns (address);
56     function token1() external view returns (address);
57     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
58     function price0CumulativeLast() external view returns (uint);
59     function price1CumulativeLast() external view returns (uint);
60     function kLast() external view returns (uint);
61 
62     function mint(address to) external returns (uint liquidity);
63     function burn(address to) external returns (uint amount0, uint amount1);
64     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
65     function skim(address to) external;
66     function sync() external;
67 
68     function initialize(address, address) external;
69 }
70 
71 interface IUniswapV2Factory {
72     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
73 
74     function feeTo() external view returns (address);
75     function feeToSetter() external view returns (address);
76 
77     function getPair(address tokenA, address tokenB) external view returns (address pair);
78     function allPairs(uint) external view returns (address pair);
79     function allPairsLength() external view returns (uint);
80 
81     function createPair(address tokenA, address tokenB) external returns (address pair);
82 
83     function setFeeTo(address) external;
84     function setFeeToSetter(address) external;
85 }
86 
87 interface IERC20 {
88     /**
89      * @dev Returns the amount of tokens in existence.
90      */
91     function totalSupply() external view returns (uint256);
92 
93     /**
94      * @dev Returns the amount of tokens owned by `account`.
95      */
96     function balanceOf(address account) external view returns (uint256);
97 
98     /**
99      * @dev Moves `amount` tokens from the caller's account to `recipient`.
100      *
101      * Returns a boolean value indicating whether the operation succeeded.
102      *
103      * Emits a {Transfer} event.
104      */
105     function transfer(address recipient, uint256 amount) external returns (bool);
106 
107     /**
108      * @dev Returns the remaining number of tokens that `spender` will be
109      * allowed to spend on behalf of `owner` through {transferFrom}. This is
110      * zero by default.
111      *
112      * This value changes when {approve} or {transferFrom} are called.
113      */
114     function allowance(address owner, address spender) external view returns (uint256);
115 
116     /**
117      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
118      *
119      * Returns a boolean value indicating whether the operation succeeded.
120      *
121      * IMPORTANT: Beware that changing an allowance with this method brings the risk
122      * that someone may use both the old and the new allowance by unfortunate
123      * transaction ordering. One possible solution to mitigate this race
124      * condition is to first reduce the spender's allowance to 0 and set the
125      * desired value afterwards:
126      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
127      *
128      * Emits an {Approval} event.
129      */
130     function approve(address spender, uint256 amount) external returns (bool);
131 
132     /**
133      * @dev Moves `amount` tokens from `sender` to `recipient` using the
134      * allowance mechanism. `amount` is then deducted from the caller's
135      * allowance.
136      *
137      * Returns a boolean value indicating whether the operation succeeded.
138      *
139      * Emits a {Transfer} event.
140      */
141     function transferFrom(
142         address sender,
143         address recipient,
144         uint256 amount
145     ) external returns (bool);
146 
147     /**
148      * @dev Emitted when `value` tokens are moved from one account (`from`) to
149      * another (`to`).
150      *
151      * Note that `value` may be zero.
152      */
153     event Transfer(address indexed from, address indexed to, uint256 value);
154 
155     /**
156      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
157      * a call to {approve}. `value` is the new allowance.
158      */
159     event Approval(address indexed owner, address indexed spender, uint256 value);
160 }
161 
162 interface IERC20Metadata is IERC20 {
163     /**
164      * @dev Returns the name of the token.
165      */
166     function name() external view returns (string memory);
167 
168     /**
169      * @dev Returns the symbol of the token.
170      */
171     function symbol() external view returns (string memory);
172 
173     /**
174      * @dev Returns the decimals places of the token.
175      */
176     function decimals() external view returns (uint8);
177 }
178 
179 
180 contract ERC20 is Context, IERC20, IERC20Metadata {
181     using SafeMath for uint256;
182 
183     mapping(address => uint256) private _balances;
184 
185     mapping(address => mapping(address => uint256)) private _allowances;
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
235         return 18;
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
434         emit Approval(owner, spender, amount);
435     }
436 
437     /**
438      * @dev Hook that is called before any transfer of tokens. This includes
439      * minting and burning.
440      *
441      * Calling conditions:
442      *
443      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
444      * will be to transferred to `to`.
445      * - when `from` is zero, `amount` tokens will be minted for `to`.
446      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
447      * - `from` and `to` are never both zero.
448      *
449      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
450      */
451     function _beforeTokenTransfer(
452         address from,
453         address to,
454         uint256 amount
455     ) internal virtual {}
456 }
457 
458 library SafeMath {
459     /**
460      * @dev Returns the addition of two unsigned integers, reverting on
461      * overflow.
462      *
463      * Counterpart to Solidity's `+` operator.
464      *
465      * Requirements:
466      *
467      * - Addition cannot overflow.
468      */
469     function add(uint256 a, uint256 b) internal pure returns (uint256) {
470         uint256 c = a + b;
471         require(c >= a, "SafeMath: addition overflow");
472 
473         return c;
474     }
475 
476     /**
477      * @dev Returns the subtraction of two unsigned integers, reverting on
478      * overflow (when the result is negative).
479      *
480      * Counterpart to Solidity's `-` operator.
481      *
482      * Requirements:
483      *
484      * - Subtraction cannot overflow.
485      */
486     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
487         return sub(a, b, "SafeMath: subtraction overflow");
488     }
489 
490     /**
491      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
492      * overflow (when the result is negative).
493      *
494      * Counterpart to Solidity's `-` operator.
495      *
496      * Requirements:
497      *
498      * - Subtraction cannot overflow.
499      */
500     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
501         require(b <= a, errorMessage);
502         uint256 c = a - b;
503 
504         return c;
505     }
506 
507     /**
508      * @dev Returns the multiplication of two unsigned integers, reverting on
509      * overflow.
510      *
511      * Counterpart to Solidity's `*` operator.
512      *
513      * Requirements:
514      *
515      * - Multiplication cannot overflow.
516      */
517     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
518         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
519         // benefit is lost if 'b' is also tested.
520         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
521         if (a == 0) {
522             return 0;
523         }
524 
525         uint256 c = a * b;
526         require(c / a == b, "SafeMath: multiplication overflow");
527 
528         return c;
529     }
530 
531     /**
532      * @dev Returns the integer division of two unsigned integers. Reverts on
533      * division by zero. The result is rounded towards zero.
534      *
535      * Counterpart to Solidity's `/` operator. Note: this function uses a
536      * `revert` opcode (which leaves remaining gas untouched) while Solidity
537      * uses an invalid opcode to revert (consuming all remaining gas).
538      *
539      * Requirements:
540      *
541      * - The divisor cannot be zero.
542      */
543     function div(uint256 a, uint256 b) internal pure returns (uint256) {
544         return div(a, b, "SafeMath: division by zero");
545     }
546 
547     /**
548      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
549      * division by zero. The result is rounded towards zero.
550      *
551      * Counterpart to Solidity's `/` operator. Note: this function uses a
552      * `revert` opcode (which leaves remaining gas untouched) while Solidity
553      * uses an invalid opcode to revert (consuming all remaining gas).
554      *
555      * Requirements:
556      *
557      * - The divisor cannot be zero.
558      */
559     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
560         require(b > 0, errorMessage);
561         uint256 c = a / b;
562         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
563 
564         return c;
565     }
566 
567     /**
568      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
569      * Reverts when dividing by zero.
570      *
571      * Counterpart to Solidity's `%` operator. This function uses a `revert`
572      * opcode (which leaves remaining gas untouched) while Solidity uses an
573      * invalid opcode to revert (consuming all remaining gas).
574      *
575      * Requirements:
576      *
577      * - The divisor cannot be zero.
578      */
579     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
580         return mod(a, b, "SafeMath: modulo by zero");
581     }
582 
583     /**
584      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
585      * Reverts with custom message when dividing by zero.
586      *
587      * Counterpart to Solidity's `%` operator. This function uses a `revert`
588      * opcode (which leaves remaining gas untouched) while Solidity uses an
589      * invalid opcode to revert (consuming all remaining gas).
590      *
591      * Requirements:
592      *
593      * - The divisor cannot be zero.
594      */
595     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
596         require(b != 0, errorMessage);
597         return a % b;
598     }
599 }
600 
601 contract Ownable is Context {
602     address private _owner;
603 
604     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
605     
606     /**
607      * @dev Initializes the contract setting the deployer as the initial owner.
608      */
609     constructor () {
610         address msgSender = _msgSender();
611         _owner = msgSender;
612         emit OwnershipTransferred(address(0), msgSender);
613     }
614 
615     /**
616      * @dev Returns the address of the current owner.
617      */
618     function owner() public view returns (address) {
619         return _owner;
620     }
621 
622     /**
623      * @dev Throws if called by any account other than the owner.
624      */
625     modifier onlyOwner() {
626         require(_owner == _msgSender(), "Ownable: caller is not the owner");
627         _;
628     }
629 
630     /**
631      * @dev Leaves the contract without owner. It will not be possible to call
632      * `onlyOwner` functions anymore. Can only be called by the current owner.
633      *
634      * NOTE: Renouncing ownership will leave the contract without an owner,
635      * thereby removing any functionality that is only available to the owner.
636      */
637     function renounceOwnership() public virtual onlyOwner {
638         emit OwnershipTransferred(_owner, address(0));
639         _owner = address(0);
640     }
641 
642     /**
643      * @dev Transfers ownership of the contract to a new account (`newOwner`).
644      * Can only be called by the current owner.
645      */
646     function transferOwnership(address newOwner) public virtual onlyOwner {
647         require(newOwner != address(0), "Ownable: new owner is the zero address");
648         emit OwnershipTransferred(_owner, newOwner);
649         _owner = newOwner;
650     }
651 }
652 
653 
654 
655 library SafeMathInt {
656     int256 private constant MIN_INT256 = int256(1) << 255;
657     int256 private constant MAX_INT256 = ~(int256(1) << 255);
658 
659     /**
660      * @dev Multiplies two int256 variables and fails on overflow.
661      */
662     function mul(int256 a, int256 b) internal pure returns (int256) {
663         int256 c = a * b;
664 
665         // Detect overflow when multiplying MIN_INT256 with -1
666         require(c != MIN_INT256 || (a & MIN_INT256) != (b & MIN_INT256));
667         require((b == 0) || (c / b == a));
668         return c;
669     }
670 
671     /**
672      * @dev Division of two int256 variables and fails on overflow.
673      */
674     function div(int256 a, int256 b) internal pure returns (int256) {
675         // Prevent overflow when dividing MIN_INT256 by -1
676         require(b != -1 || a != MIN_INT256);
677 
678         // Solidity already throws when dividing by 0.
679         return a / b;
680     }
681 
682     /**
683      * @dev Subtracts two int256 variables and fails on overflow.
684      */
685     function sub(int256 a, int256 b) internal pure returns (int256) {
686         int256 c = a - b;
687         require((b >= 0 && c <= a) || (b < 0 && c > a));
688         return c;
689     }
690 
691     /**
692      * @dev Adds two int256 variables and fails on overflow.
693      */
694     function add(int256 a, int256 b) internal pure returns (int256) {
695         int256 c = a + b;
696         require((b >= 0 && c >= a) || (b < 0 && c < a));
697         return c;
698     }
699 
700     /**
701      * @dev Converts to absolute value, and fails on overflow.
702      */
703     function abs(int256 a) internal pure returns (int256) {
704         require(a != MIN_INT256);
705         return a < 0 ? -a : a;
706     }
707 
708 
709     function toUint256Safe(int256 a) internal pure returns (uint256) {
710         require(a >= 0);
711         return uint256(a);
712     }
713 }
714 
715 library SafeMathUint {
716   function toInt256Safe(uint256 a) internal pure returns (int256) {
717     int256 b = int256(a);
718     require(b >= 0);
719     return b;
720   }
721 }
722 
723 
724 interface IUniswapV2Router01 {
725     function factory() external pure returns (address);
726     function WETH() external pure returns (address);
727 
728     function addLiquidity(
729         address tokenA,
730         address tokenB,
731         uint amountADesired,
732         uint amountBDesired,
733         uint amountAMin,
734         uint amountBMin,
735         address to,
736         uint deadline
737     ) external returns (uint amountA, uint amountB, uint liquidity);
738     function addLiquidityETH(
739         address token,
740         uint amountTokenDesired,
741         uint amountTokenMin,
742         uint amountETHMin,
743         address to,
744         uint deadline
745     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
746     function removeLiquidity(
747         address tokenA,
748         address tokenB,
749         uint liquidity,
750         uint amountAMin,
751         uint amountBMin,
752         address to,
753         uint deadline
754     ) external returns (uint amountA, uint amountB);
755     function removeLiquidityETH(
756         address token,
757         uint liquidity,
758         uint amountTokenMin,
759         uint amountETHMin,
760         address to,
761         uint deadline
762     ) external returns (uint amountToken, uint amountETH);
763     function removeLiquidityWithPermit(
764         address tokenA,
765         address tokenB,
766         uint liquidity,
767         uint amountAMin,
768         uint amountBMin,
769         address to,
770         uint deadline,
771         bool approveMax, uint8 v, bytes32 r, bytes32 s
772     ) external returns (uint amountA, uint amountB);
773     function removeLiquidityETHWithPermit(
774         address token,
775         uint liquidity,
776         uint amountTokenMin,
777         uint amountETHMin,
778         address to,
779         uint deadline,
780         bool approveMax, uint8 v, bytes32 r, bytes32 s
781     ) external returns (uint amountToken, uint amountETH);
782     function swapExactTokensForTokens(
783         uint amountIn,
784         uint amountOutMin,
785         address[] calldata path,
786         address to,
787         uint deadline
788     ) external returns (uint[] memory amounts);
789     function swapTokensForExactTokens(
790         uint amountOut,
791         uint amountInMax,
792         address[] calldata path,
793         address to,
794         uint deadline
795     ) external returns (uint[] memory amounts);
796     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
797         external
798         payable
799         returns (uint[] memory amounts);
800     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
801         external
802         returns (uint[] memory amounts);
803     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
804         external
805         returns (uint[] memory amounts);
806     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
807         external
808         payable
809         returns (uint[] memory amounts);
810 
811     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
812     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
813     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
814     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
815     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
816 }
817 
818 interface IUniswapV2Router02 is IUniswapV2Router01 {
819     function removeLiquidityETHSupportingFeeOnTransferTokens(
820         address token,
821         uint liquidity,
822         uint amountTokenMin,
823         uint amountETHMin,
824         address to,
825         uint deadline
826     ) external returns (uint amountETH);
827     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
828         address token,
829         uint liquidity,
830         uint amountTokenMin,
831         uint amountETHMin,
832         address to,
833         uint deadline,
834         bool approveMax, uint8 v, bytes32 r, bytes32 s
835     ) external returns (uint amountETH);
836 
837     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
838         uint amountIn,
839         uint amountOutMin,
840         address[] calldata path,
841         address to,
842         uint deadline
843     ) external;
844     function swapExactETHForTokensSupportingFeeOnTransferTokens(
845         uint amountOutMin,
846         address[] calldata path,
847         address to,
848         uint deadline
849     ) external payable;
850     function swapExactTokensForETHSupportingFeeOnTransferTokens(
851         uint amountIn,
852         uint amountOutMin,
853         address[] calldata path,
854         address to,
855         uint deadline
856     ) external;
857 }
858 
859 contract SUKI is ERC20, Ownable {
860     using SafeMath for uint256;
861 
862     IUniswapV2Router02 public immutable uniswapV2Router;
863     address public immutable uniswapV2Pair;
864     address public constant deadAddress = address(0xdead);
865 
866     bool private swapping;
867 
868     address public marketingWallet;
869     address public tokenDevelopmentAddress;
870     
871     uint256 public maxTransactionAmount;
872     uint256 public swapTokensAtAmount;
873     uint256 public maxWallet;
874 
875     bool public limitsInEffect = true;
876     bool public tradingActive = false;
877     bool public swapEnabled = false;
878     
879     bool private gasLimitActive = true;
880     uint256 private constant gasPriceLimit = 70 * 1 gwei; // do not allow over x gwei for launch
881     
882      // Anti-bot and anti-whale mappings and variables
883     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
884     bool public transferDelayEnabled = true;
885 
886     uint256 public buyTotalFees;
887     uint256 public buyMarketingFee;
888     uint256 public buyLiquidityFee;
889     uint256 public buyDevelopmentFee;
890     
891     uint256 public sellTotalFees;
892     uint256 public sellMarketingFee;
893     uint256 public sellLiquidityFee;
894     uint256 public sellDevelopmentFee;
895     
896     uint256 public tokensForMarketing;
897     uint256 public tokensForLiquidity;
898     uint256 public tokensForDevelopment;
899 
900     // exlcude from fees and max transaction amount
901     mapping (address => bool) private _isExcludedFromFees;
902     mapping (address => bool) public _isExcludedMaxTransactionAmount;
903 
904     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
905     // could be subject to a maximum transfer amount
906     mapping (address => bool) public automatedMarketMakerPairs;
907 
908     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
909 
910     event ExcludeFromFees(address indexed account, bool isExcluded);
911 
912     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
913 
914     event marketingWalletUpdated(address indexed newWallet, address indexed oldWallet);
915 
916     event DevelopmentWalletUpdated(address indexed newWallet, address indexed oldWallet);
917 
918     event SwapAndLiquify(
919         uint256 tokensSwapped,
920         uint256 ethReceived,
921         uint256 tokensIntoLiquidity
922     );
923 
924     event BuyBackTriggered(uint256 amount);
925     
926     event OwnerForcedSwapBack(uint256 timestamp);
927 
928     constructor() ERC20("SUKI", "SUKI") {
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
939         uint256 _buyMarketingFee = 3;
940         uint256 _buyLiquidityFee = 2;
941         uint256 _buyDevelopmentFee = 1;
942 
943 
944         uint256 _sellMarketingFee = 3;
945         uint256 _sellLiquidityFee = 2;
946         uint256 _sellDevelopmentFee = 1;
947 
948         
949         uint256 totalSupply = 1 * 1e9 * 1e18;
950         
951         maxWallet = totalSupply * 2 / 100; // 2% Max wallet
952         maxTransactionAmount = totalSupply * 2 / 100; // 2% maxTransactionAmountTxn
953         swapTokensAtAmount = totalSupply * 5 / 10000; // 0.05% swap wallet
954 
955         buyMarketingFee = _buyMarketingFee;
956         buyLiquidityFee = _buyLiquidityFee;
957         buyDevelopmentFee = _buyDevelopmentFee;
958         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
959         
960         sellMarketingFee = _sellMarketingFee;
961         sellLiquidityFee = _sellLiquidityFee;
962         sellDevelopmentFee = _sellDevelopmentFee;
963         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
964         
965     	marketingWallet = address(msg.sender); // set as marketing wallet
966         tokenDevelopmentAddress = address(msg.sender); // set as Development wallet (before Development is available)
967 
968         // exclude from paying fees or having max transaction amount
969         excludeFromFees(owner(), true);
970         excludeFromFees(address(this), true);
971         excludeFromFees(address(0xdead), true);
972         
973         excludeFromMaxTransaction(owner(), true);
974         excludeFromMaxTransaction(address(this), true);
975         excludeFromMaxTransaction(address(0xdead), true);
976         
977         /*
978             _mint is an internal function in ERC20.sol that is only called here,
979             and CANNOT be called ever again
980         */
981         _mint(msg.sender, totalSupply);
982     }
983 
984     receive() external payable {
985 
986   	}
987 
988     // once enabled, can never be turned off
989     function enableTrading() external onlyOwner {
990         tradingActive = true;
991         swapEnabled = true;
992     }
993     
994     // remove limits after token is stable
995     function removeLimits() external onlyOwner returns (bool){
996         limitsInEffect = false;
997         gasLimitActive = false;
998         transferDelayEnabled = false;
999         return true;
1000     }
1001     
1002     // disable Transfer delay - cannot be reenabled
1003     function disableTransferDelay() external onlyOwner returns (bool){
1004         transferDelayEnabled = false;
1005         return true;
1006     }
1007 
1008     
1009      // change the minimum amount of tokens to sell from fees
1010     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool){
1011   	    require(newAmount >= totalSupply() * 1 / 100000, "Swap amount cannot be lower than 0.001% total supply.");
1012   	    require(newAmount <= totalSupply() * 5 / 1000, "Swap amount cannot be higher than 0.5% total supply.");
1013   	    swapTokensAtAmount = newAmount;
1014   	    return true;
1015   	}
1016     
1017     function updateMaxAmount(uint256 newNum) external onlyOwner {
1018         require(newNum >= (totalSupply() * 5 / 1000)/1e18, "Cannot set maxTransactionAmount lower than 0.5%");
1019         maxTransactionAmount = newNum * (10**18);
1020     }
1021 
1022     function updateMaxWalletAmount(uint256 newNum) external onlyOwner {
1023         require(newNum > (totalSupply() * 1 / 100)/1e18, "Cannot set maxWallet lower than 1%");
1024         maxWallet = newNum * (10**18);
1025     }
1026     
1027     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
1028         _isExcludedMaxTransactionAmount[updAds] = isEx;
1029     }
1030     
1031     // only use to disable contract sales if absolutely necessary (emergency use only)
1032     function updateSwapEnabled(bool enabled) external onlyOwner(){
1033         swapEnabled = enabled;
1034     }
1035     
1036     function updateBuyFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _DevelopmentFee) external onlyOwner {
1037         buyMarketingFee = _marketingFee;
1038         buyLiquidityFee = _liquidityFee;
1039         buyDevelopmentFee = _DevelopmentFee;
1040         buyTotalFees = buyMarketingFee + buyLiquidityFee + buyDevelopmentFee;
1041         require(buyTotalFees <= 25, "Must keep fees at 25% or less");
1042     }
1043     
1044     function updateSellFees(uint256 _marketingFee, uint256 _liquidityFee, uint256 _DevelopmentFee) external onlyOwner {
1045         sellMarketingFee = _marketingFee;
1046         sellLiquidityFee = _liquidityFee;
1047         sellDevelopmentFee = _DevelopmentFee;
1048         sellTotalFees = sellMarketingFee + sellLiquidityFee + sellDevelopmentFee;
1049         require(sellTotalFees <= 25, "Must keep fees at 25% or less");
1050     }
1051 
1052     function excludeFromFees(address account, bool excluded) public onlyOwner {
1053         _isExcludedFromFees[account] = excluded;
1054         emit ExcludeFromFees(account, excluded);
1055     }
1056 
1057     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
1058         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1059 
1060         _setAutomatedMarketMakerPair(pair, value);
1061     }
1062     
1063     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1064         automatedMarketMakerPairs[pair] = value;
1065 
1066         emit SetAutomatedMarketMakerPair(pair, value);
1067     }
1068 
1069     function updateMarketingWallet(address newMarketingWallet) external onlyOwner {
1070         emit marketingWalletUpdated(newMarketingWallet, marketingWallet);
1071         marketingWallet = newMarketingWallet;
1072     }
1073     
1074 
1075     function updateDevelopmentAddress(address newWallet) external onlyOwner {
1076         emit DevelopmentWalletUpdated(newWallet, tokenDevelopmentAddress);
1077         tokenDevelopmentAddress = newWallet;
1078     }
1079     
1080 
1081     function isExcludedFromFees(address account) external view returns(bool) {
1082         return _isExcludedFromFees[account];
1083     }
1084     
1085     function _transfer(
1086         address from,
1087         address to,
1088         uint256 amount
1089     ) internal override {
1090         require(from != address(0), "ERC20: transfer from the zero address");
1091         require(to != address(0), "ERC20: transfer to the zero address");
1092         
1093          if(amount == 0) {
1094             super._transfer(from, to, 0);
1095             return;
1096         }
1097         
1098         if(limitsInEffect){
1099             if (
1100                 from != owner() &&
1101                 to != owner() &&
1102                 to != address(0) &&
1103                 to != address(0xdead) &&
1104                 !swapping
1105             ){
1106                 if(!tradingActive){
1107                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
1108                 }
1109                 
1110                 // only use to prevent sniper buys in the first blocks.
1111                 if (gasLimitActive && automatedMarketMakerPairs[from]) {
1112                     require(tx.gasprice <= gasPriceLimit, "Gas price exceeds limit.");
1113                 }
1114 
1115                 // at launch if the transfer delay is enabled, ensure the block timestamps for purchasers is set -- during launch.  
1116                 if (transferDelayEnabled){
1117                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
1118                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
1119                         _holderLastTransferTimestamp[tx.origin] = block.number;
1120                     }
1121                 }
1122                  
1123                 //when buy
1124                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1125                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1126                 } 
1127                 //when sell
1128                 else if (automatedMarketMakerPairs[to] && !_isExcludedMaxTransactionAmount[from]) {
1129                     require(amount <= maxTransactionAmount, "Sell transfer amount exceeds the maxTransactionAmount.");
1130                 }
1131                 else if(!_isExcludedMaxTransactionAmount[to]) {
1132                     require(amount + balanceOf(to) <= maxWallet, "Unable to exceed Max Wallet");
1133                 }
1134             }
1135         }
1136         
1137 		uint256 contractTokenBalance = balanceOf(address(this));
1138         
1139         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1140 
1141         if( 
1142             canSwap &&
1143             swapEnabled &&
1144             !swapping &&
1145             !automatedMarketMakerPairs[from] &&
1146             !_isExcludedFromFees[from] &&
1147             !_isExcludedFromFees[to]
1148         ) {
1149             swapping = true;
1150             
1151             swapBack();
1152 
1153             swapping = false;
1154         }
1155         
1156         bool takeFee = !swapping;
1157 
1158         // if any account belongs to _isExcludedFromFee account then remove the fee
1159         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1160             takeFee = false;
1161         }
1162         
1163         uint256 fees = 0;
1164         // only take fees on buys/sells, do not take on wallet transfers
1165         if(takeFee){
1166             // on sell
1167             if (automatedMarketMakerPairs[to] && sellTotalFees > 0){
1168                 fees = amount.mul(sellTotalFees).div(100);
1169                 tokensForLiquidity += fees * sellLiquidityFee / sellTotalFees;
1170                 tokensForDevelopment += fees * sellDevelopmentFee / sellTotalFees;
1171                 tokensForMarketing += fees * sellMarketingFee / sellTotalFees;
1172             }
1173             // on buy
1174             else if(automatedMarketMakerPairs[from] && buyTotalFees > 0) {
1175         	    fees = amount.mul(buyTotalFees).div(100);
1176         	    tokensForLiquidity += fees * buyLiquidityFee / buyTotalFees;
1177                 tokensForDevelopment += fees * buyDevelopmentFee / buyTotalFees;
1178                 tokensForMarketing += fees * buyMarketingFee / buyTotalFees;
1179             }
1180             
1181             if(fees > 0){    
1182                 super._transfer(from, address(this), fees);
1183             }
1184         	
1185         	amount -= fees;
1186         }
1187 
1188         super._transfer(from, to, amount);
1189     }
1190 
1191     function swapTokensForEth(uint256 tokenAmount) private {
1192 
1193         // generate the uniswap pair path of token -> weth
1194         address[] memory path = new address[](2);
1195         path[0] = address(this);
1196         path[1] = uniswapV2Router.WETH();
1197 
1198         _approve(address(this), address(uniswapV2Router), tokenAmount);
1199 
1200         // make the swap
1201         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1202             tokenAmount,
1203             0, // accept any amount of ETH
1204             path,
1205             address(this),
1206             block.timestamp
1207         );
1208         
1209     }
1210     
1211     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1212         // approve token transfer to cover all possible scenarios
1213         _approve(address(this), address(uniswapV2Router), tokenAmount);
1214 
1215         // add the liquidity
1216         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1217             address(this),
1218             tokenAmount,
1219             0, // slippage is unavoidable
1220             0, // slippage is unavoidable
1221             owner(),
1222             block.timestamp
1223         );
1224     }
1225 
1226     function swapBack() private {
1227         uint256 contractBalance = balanceOf(address(this));
1228         uint256 totalTokensToSwap = tokensForLiquidity + tokensForMarketing + tokensForDevelopment;
1229         
1230         if(contractBalance == 0 || totalTokensToSwap == 0) {return;}
1231 
1232         // prevent overly large contract sells.
1233         if(contractBalance >= swapTokensAtAmount * 5){
1234             contractBalance = swapTokensAtAmount * 5;
1235         }
1236         
1237         // Halve the amount of liquidity tokens
1238         uint256 liquidityTokens = contractBalance * tokensForLiquidity / totalTokensToSwap / 2;
1239         uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1240         
1241         uint256 initialETHBalance = address(this).balance;
1242 
1243         swapTokensForEth(amountToSwapForETH); 
1244         
1245         uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1246         
1247         uint256 ethForMarketing = ethBalance.mul(tokensForMarketing).div(totalTokensToSwap);
1248         uint256 ethForDevelopment = ethBalance.mul(tokensForDevelopment).div(totalTokensToSwap);
1249         
1250         
1251         uint256 ethForLiquidity = ethBalance - ethForMarketing - ethForDevelopment;
1252         
1253         
1254         tokensForLiquidity = 0;
1255         tokensForMarketing = 0;
1256         tokensForDevelopment = 0;
1257 
1258         
1259         (bool success,) = address(tokenDevelopmentAddress).call{value: ethForDevelopment}("");
1260         
1261         if(liquidityTokens > 0 && ethForLiquidity > 0){
1262             addLiquidity(liquidityTokens, ethForLiquidity);
1263             emit SwapAndLiquify(amountToSwapForETH, ethForLiquidity, tokensForLiquidity);
1264         }
1265         
1266         (success,) = address(marketingWallet).call{value: address(this).balance}("");       
1267     }
1268 }