1 /**
2 *Submitted for verification at Etherscan.io on 2022-10-31
3 */
4  
5 // SPDX-License-Identifier: MIT 
6 /*
7 SOCIALS: SOON
8 */
9                                                     
10 pragma solidity 0.8.9;
11  
12 abstract contract Context {
13     function _msgSender() internal view virtual returns (address) {
14         return msg.sender;
15     }
16  
17     function _msgData() internal view virtual returns (bytes calldata) {
18         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
19         return msg.data;
20     }
21 }
22  
23 interface IUniswapV2Pair {
24     event Approval(address indexed owner, address indexed spender, uint value);
25     event Transfer(address indexed from, address indexed to, uint value);
26  
27    function name() external pure returns (string memory);
28     function symbol() external pure returns (string memory);
29     function decimals() external pure returns (uint8);
30     function totalSupply() external view returns (uint);
31     function balanceOf(address owner) external view returns (uint);
32     function allowance(address owner, address spender) external view returns (uint);
33  
34     function approve(address spender, uint value) external returns (bool);
35     function transfer(address to, uint value) external returns (bool);
36     function transferFrom(address from, address to, uint value) external returns (bool);
37  
38     function DOMAIN_SEPARATOR() external view returns (bytes32);
39     function PERMIT_TYPEHASH() external pure returns (bytes32);
40     function nonces(address owner) external view returns (uint);
41  
42     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
43  
44     event Mint(address indexed sender, uint amount0, uint amount1);
45     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
46     event Swap(
47         address indexed sender,
48         uint amount0In,
49         uint amount1In,
50         uint amount0Out,
51         uint amount1Out,
52         address indexed to
53     );
54     event Sync(uint112 reserve0, uint112 reserve1);
55  
56     function MINIMUM_LIQUIDITY() external pure returns (uint);
57     function factory() external view returns (address);
58     function token0() external view returns (address);
59     function token1() external view returns (address);
60     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
61     function price0CumulativeLast() external view returns (uint);
62     function price1CumulativeLast() external view returns (uint);
63     function kLast() external view returns (uint);
64  
65     function mint(address to) external returns (uint liquidity);
66     function burn(address to) external returns (uint amount0, uint amount1);
67     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
68     function skim(address to) external;
69     function sync() external;
70  
71     function initialize(address, address) external;
72 }
73  
74 interface IUniswapV2Factory {
75     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
76  
77     function feeTo() external view returns (address);
78     function feeToSetter() external view returns (address);
79  
80     function getPair(address tokenA, address tokenB) external view returns (address pair);
81     function allPairs(uint) external view returns (address pair);
82     function allPairsLength() external view returns (uint);
83  
84     function createPair(address tokenA, address tokenB) external returns (address pair);
85  
86     function setFeeTo(address) external;
87     function setFeeToSetter(address) external;
88 }
89  
90 interface IERC20 {
91     /**
92      * @dev Returns the amount of tokens in existence.
93      */
94     function totalSupply() external view returns (uint256);
95  
96     /**
97      * @dev Returns the amount of tokens owned by account.
98      */
99     function balanceOf(address account) external view returns (uint256);
100  
101     /**
102      * @dev Moves amount tokens from the caller's account tot Etherscan.i
103      *
104      * Returns a boolean value indicating whether the operation succeeded.
105      ** Emits a {Transfer} event.
106      */
107     function transfer(address recipient, uint256 amount) external returns (bool);
108  
109     /**
110      * @dev Returns the remaining number of tokens that spender will be
111      * allowed to spend on behalf ofan.io on through {transferFrom}. This is
112      * zero by default.
113      *
114      * This value changes when {approve} or {transferFrom} are called.
115      */
116     function allowance(address owner, address spender) external view returns (uint256);
117  
118     /**
119      * @dev Sets amount as the allowance of spender over the caller's tokens.
120      *
121      * Returns a boolean value indicating whether the operation succeeded.
122      *
123     * IMPORTANT: Beware that changing an allowance with this method brings the risk
124      * that someone may use both the old and the new allowance by unfortunate
125      * transaction ordering. One possible solution to mitigate this race
126      * condition is to first reduce the spender's allowance to 0 and set the
127      * desired value afterwards:
128      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
129      *
130      * Emits an {Approval} event.
131      */
132     function approve(address spender, uint256 amount) external returns (bool);
133  
134     /**
135      * @dev Moves amount tokens from sender to recipient using the
136      * allowance mechanism.Etherscan.is then deducted from the caller's
137      * allowance.
138      *
139      * Returns a boolean value indicating whether the operation succeeded.
140      *
141      * Emits a {Transfer} event.
142      */
143     function transferFrom(
144         address sender,
145         address recipient,
146         uint256 amount
147     ) external returns (bool);
148  
149     /**
150      * @dev Emitted when value tokens are moved from one account (`from`) to
151      * another (`to`).
152      *
153      * Note that value may be zero.
154      */
155     event Transfer(address indexed from, address indexed to, uint256 value);
156  
157     /**
158      * @dev Emitted when the allowance of a spender for an owner is set by
159      * a call to {approve}.Etherscanis the new allowance.
160      */
161     event Approval(address indexed owner, address indexed spender, uint256 value);
162 }
163  
164 interface IERC20Metadata is IERC20 {
165     /**
166      * @dev Returns the name of the token.
167      */
168     function name() external view returns (string memory);
169  
170     /**
171      * @dev Returns the symbol of the token.
172      */
173     function symbol() external view returns (string memory);
174  
175     /**
176      * @dev Returns the decimals places of the token.
177      */
178     function decimals() external view returns (uint8);
179 }
180  
181  
182 contract ERC20 is Context, IERC20, IERC20Metadata {
183     using SafeMath for uint256;
184  
185     mapping (address => uint256) private _balances;
186  
187     mapping(address => mapping(address => uint256)) private _allowances;
188  
189     uint256 private _totalSupply;
190  
191     string private _name;
192     string private _symbol;
193  
194     /**
195      * @dev Sets the values for {name} and {symbol}.
196      *
197      * The default value of {decimals} is 18. To select a different value for
198      * {decimals} you should overload it.
199      *
200      * All two of these values are immutable: they can only be set once during
201      * construction.
202      */
203     constructor(string memory name_, string memory symbol_) {
204         _name = name_;
205         _symbol = symbol_;
206     }
207  
208     /**
209      * @dev Returns the name of the token.
210      */
211     function name() public view virtual override returns (string memory) {
212         return _name;
213     }
214  
215     /**
216      * @dev Returns the symbol of the token, usually a shorter version of the
217      * name.
218      */
219     function symbol() public view virtual override returns (string memory) {
220         return _symbol;
221     }
222  
223     /**
224      * @dev Returns the number of decimals used to get its user representation.
225      * For example, if decimals equals 2, a balance of 505 tokens should
226      * be displayed to a user as.io on 2(`505 / 10 ** 2`).
227      *
228      * Tokens usually opt for a value of 18, imitating the relationship between
229      * Ether and Wei. This is the value {ERC20} uses, unless this function is
230      * overridden;
231      ** NOTE: This information is only used for _display_ purposes: it in
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
258      * - recipient cannot be the zero address.
259      * - the caller must have a balance of at least amount.
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
278      * - - see http (https://github.com/ethereum/solidity/issues/2691)cannot be the zero address.
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
293      * - sender and recipient cannot be the zero address.
294      * - Etherscanmust have a balance of at leaston at Ethe
295      * - the caller must have allowance for ``sender``'s tokens of at least
296      * amount.
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
309      * @dev Atomically increases the allowance granted to spender by the caller.
310      *
311      * This is an alternative to {approve} that can be used as a mitigation for
312      * problems described in {IERC20-approve}.
313      *
314      * Emits an {Approval} event indicating the updated allowance.
315      *
316      * Requirements:
317      *
318      * - spender cannot be the zero address.
319      */
320     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
321         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
322         return true;
323     }
324  
325     /**
326      * @dev Atomically decreases the allowance granted to spender by the caller.
327      *
328      * This is an alternative to {approve} that can be used as a mitigation for
329      * problems described in {IERC20-approve}.
330      *
331      * Emits an {Approval} event indicating the updated allowance.
332      *
333      * Requirements:
334      *
335      * - spender cannot be the zero address.
336      * - Etherscan.must have allowance for the caller of at least
337      * subtractedValue.
338      */
339     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
340         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
341         return true;
342     }
343  
344     /**
345      * @dev Moves tokens amount from sender to recipient.
346      *
347      * This is internal function is equivalent to {transfer}, and can be used to
348      * e.g. implement automatic token fees, slashing mechanisms, etc.
349      *
350      * Emits a {Transfer} event.
351      *
352      * Requirements:
353      *
354      * - sender cannot be the zero address.
355      * - Etherscan.iocannot be the zero address.* - Etherscanmust have a balance of at leaston at Ethe
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
372     /** @dev Creates amount tokens and assigns them to account, increasing
373      * the total supply.
374      *
375      * Emits a {Transfer} event with from set to the zero address.
376      *
377      * Requirements:
378      *
379      * - account cannot be the zero address.
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
392      * @dev Destroys amount tokens from account, reducing the
393      * total supply.
394      *
395      * Emits a {Transfer} event with to set to the zero address.
396      *
397      * Requirements:
398      *
399      * - account cannot be the zero address.
400      * - Etherscan.must have at least amount tokens.
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
413      * @dev Sets amount as the allowance of spender over the owner s tokens.
414      *
415      * This internal function is equivalent to approve, and can be used to
416      * e.g. set automatic allowances for certain subsystems, etc.
417      *
418      * Emits an {Approval} event.
419      *
420      * Requirements:
421      *
422      * - owner cannot be the zero address.
423      * - Etherscan.cannot be the zero address.
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
434  
435         emit Approval(owner, spender, amount);
436     }
437  
438     /**
439      * @dev Hook that is called before any transfer of tokens. This includes
440      * minting and burning.
441      *
442      * Calling conditions:
443      *
444      * - when from and to are both non-zero, amount of ``from``'s tokens
445      * will be to transferred to to.
446      * - when from is zero, amount tokens will be minted for to.
447      * - when to is zero, amount of ``from``'s tokens will be burned.
448      * -n.io on and to are never both zero.
449      *
450      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
451      */
452     function _beforeTokenTransfer(
453         address from,
454         address to,
455         uint256 amount
456     ) internal virtual {}
457 }
458  
459 library SafeMath {
460     /**
461      * @dev Returns the addition of two unsigned integers, reverting on
462      * overflow.
463      *
464      * Counterpart to Solidity's + operator.
465      *
466      * Requirements:
467      *
468      * - Addition cannot overflow.
469      */
470     function add(uint256 a, uint256 b) internal pure returns (uint256) {
471         uint256 c = a + b;
472         require(c >= a, "SafeMath: addition overflow");
473  
474         return c;
475     }
476  
477     /**
478      * @dev Returns the subtraction of two unsigned integers, reverting on
479      * overflow (when the result is negative).
480      *
481      * Counterpart to Solidity's - operator.*
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
494      * Counterpart to Solidity's - operator.
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
511      * Counterpart to Solidity's * operator.
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
535      * Counterpart to Solidity's / operator. Note: this function uses a
536      *can.io on opcode (which leaves remaining gas untouched) while Solidity
537      * uses an invalid opcode to revert (consuming all remaining gas).
538      *
539      * Requirements:
540      *
541      * - The divisor cannot be zero.
542      */
543     function div(uint256 a, uint256 b) internal pure returns (uint256) {
544        return div(a, b, "SafeMath: division by zero");
545     }
546  
547     /**
548      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
549      * division by zero. The result is rounded towards zero.
550      *
551      * Counterpart to Solidity's / operator. Note: this function uses a
552      *can.io on opcode (which leaves remaining gas untouched) while Solidity
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
571      * Counterpart to Solidity's % operator. This function uses aion at Eth     * opcode (which leaves remaining gas untouched) while Solidity uses an
572      * invalid opcode to revert (consuming all remaining gas).
573      *
574      * Requirements:
575      *
576      * - The divisor cannot be zero.
577      */
578     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
579         return mod(a, b, "SafeMath: modulo by zero");
580     }
581  
582     /**
583      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
584      * Reverts with custom message when dividing by zero.
585      *
586      * Counterpart to Solidity's % operator. This function uses aion at Eth     * opcode (which leaves remaining gas untouched) while Solidity uses an
587      * invalid opcode to revert (consuming all remaining gas).
588      *
589      * Requirements:
590      *
591      * - The divisor cannot be zero.
592      */
593     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
594         require(b != 0, errorMessage);
595         return a % b;
596     }
597 }
598  
599 contract Ownable is Context {
600     address private _owner;event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
601    
602     /**
603      * @dev Initializes the contract setting the deployer as the initial owner.
604      */
605     constructor () {
606         address msgSender = _msgSender();
607         _owner = msgSender;
608         emit OwnershipTransferred(address(0), msgSender);
609     }
610  
611     /**
612      * @dev Returns the address of the current owner.
613      */
614     function owner() public view returns (address) {
615         return _owner;
616     }
617  
618     /**
619      * @dev Throws if called by any account other than the owner.
620      */
621     modifier onlyOwner() {
622         require(_owner == _msgSender(), "Ownable: caller is not the owner");
623         _;
624     }
625  
626     /**
627      * @dev Leaves the contract without owner. It will not be possible to call
628      * onlyOwner functions anymore. Can only be called by the current owner.
629      *
630      * NOTE: Renouncing ownership will leave the contract without an owner,
631      * thereby removing any functionality that is only available to the owner.
632      */
633     function renounceOwnership() public virtual onlyOwner {
634         emit OwnershipTransferred(_owner, address(0));
635         _owner = address(0);
636     }
637  
638     /**
639      * @dev Transfers ownership of the contract to a new account (`newOwner`).
640      * Can only be called by the current owner.
641      */
642     function transferOwnership(address newOwner) public virtual onlyOwner {
643         require(newOwner != address(0), "Ownable: new owner is the zero address");
644         emit OwnershipTransferred(_owner, newOwner);
645         _owner = newOwner;
646     }
647 }
648  
649 interface IUniswapV2Router01 {
650     function factory() external pure returns (address);
651     function WETH() external pure returns (address);
652  
653     function addLiquidity(
654         address tokenA,
655         address tokenB,
656         uint amountADesired,
657         uint amountBDesired,
658         uint amountAMin,
659         uint amountBMin,
660         address to,
661         uint deadline
662     ) external returns (uint amountA, uint amountB, uint liquidity);
663     function addLiquidityETH(
664         address token,
665         uint amountTokenDesired,
666         uint amountTokenMin,
667         uint amountETHMin,
668         address to,
669         uint deadline
670     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
671     function removeLiquidity(
672         address tokenA,
673         address tokenB,
674         uint liquidity,
675         uint amountAMin,
676         uint amountBMin,
677         address to,
678         uint deadline
679     ) external returns (uint amountA, uint amountB);
680     function removeLiquidityETH(
681         address token,
682         uint liquidity,
683         uint amountTokenMin,
684         uint amountETHMin,
685         address to,
686         uint deadline
687     ) external returns (uint amountToken, uint amountETH);
688     function removeLiquidityWithPermit(
689         address tokenA,
690         address tokenB,
691         uint liquidity,
692         uint amountAMin,
693         uint amountBMin,
694         address to,
695         uint deadline,
696         bool approveMax, uint8 v, bytes32 r, bytes32 s
697     ) external returns (uint amountA, uint amountB);
698     function removeLiquidityETHWithPermit(
699         address token,
700         uint liquidity,
701         uint amountTokenMin,
702         uint amountETHMin,
703         address to,
704         uint deadline,
705         bool approveMax, uint8 v, bytes32 r, bytes32 s
706     ) external returns (uint amountToken, uint amountETH);
707     function swapExactTokensForTokens(
708         uint amountIn,
709         uint amountOutMin,
710         address[] calldata path,
711         address to,
712         uint deadline
713     ) external returns (uint[] memory amounts);
714     function swapTokensForExactTokens(
715         uint amountOut,
716         uint amountInMax,
717         address[] calldata path,
718         address to,
719         uint deadline
720     ) external returns (uint[] memory amounts);
721     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
722         external
723         payable
724         returns (uint[] memory amounts);function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
725         external
726         returns (uint[] memory amounts);
727     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
728         external
729         returns (uint[] memory amounts);
730     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
731         external
732         payable
733         returns (uint[] memory amounts);
734  
735     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
736     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
737     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
738     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
739     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
740 }
741  
742 interface IUniswapV2Router02 is IUniswapV2Router01 {
743     function removeLiquidityETHSupportingFeeOnTransferTokens(
744         address token,
745         uint liquidity,
746         uint amountTokenMin,
747         uint amountETHMin,
748         address to,
749         uint deadline
750     ) external returns (uint amountETH);
751     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
752         address token,
753         uint liquidity,
754         uint amountTokenMin,
755         uint amountETHMin,
756         address to,
757         uint deadline,
758        bool approveMax, uint8 v, bytes32 r, bytes32 s
759     ) external returns (uint amountETH);
760  
761     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
762         uint amountIn,
763         uint amountOutMin,
764         address[] calldata path,
765         address to,
766         uint deadline
767     ) external;
768     function swapExactETHForTokensSupportingFeeOnTransferTokens(
769         uint amountOutMin,
770         address[] calldata path,
771         address to,
772         uint deadline
773     ) external payable;
774     function swapExactTokensForETHSupportingFeeOnTransferTokens(
775         uint amountIn,
776         uint amountOutMin,
777         address[] calldata path,
778         address to,
779         uint deadline
780     ) external;
781 }
782  
783 contract OMICS is ERC20, Ownable {
784     using SafeMath for uint256;
785  
786     mapping (address => uint256) private _rOwned;
787     uint256 private constant MAX = ~uint256(0);
788     uint256 private constant _tTotal = 9 * 1e6 * 1e6;
789     uint256 private _tSupply;
790     uint256 private _rTotal = (MAX - (MAX % _tTotal));
791     uint256 private _tFeeTotal;
792    
793     uint256 public maxTransactionAmount;
794     uint256 public maxWallet;
795     uint256 public swapTokensAtAmount;
796  
797     IUniswapV2Router02 public immutable uniswapV2Router;
798     address public immutable uniswapV2Pair;
799     address public constant deadAddress = address(0xdead);
800  
801     bool private swapping;
802  
803     address public Treasury;
804  
805     bool public limitsInEffect = true;
806     bool public tradingActive = false;
807    
808      // Anti-bot and anti-whale mappings and variables
809     mapping(address => uint256) private _holderLastTransferTimestamp; // to hold last Transfers temporarily during launch
810     bool public transferDelayEnabled = true;
811  
812     uint256 public buyTotalFees;
813     uint256 public buyTreasuryFee = 3;
814     uint256 public buyBurnFee = 1;
815     uint256 public buyReflectionFee = 1;
816    
817     uint256 public sellTotalFees;
818     uint256 public sellTreasuryFee = 3;
819     uint256 public sellBurnFee = 1;
820     uint256 public sellReflectionFee = 1;
821  
822     uint256 public tokensForTreasury;
823     uint256 public tokensForBurn;
824     uint256 public tokensForReflections;
825    
826     uint256 public walletDigit;
827     uint256 public transDigit;
828     uint256 public delayDigit;
829    
830     /******************/
831  
832     // exclude from fees, max transaction amount and max wallet amount
833     mapping (address => bool) private _isExcludedFromFees;
834     mapping (address => bool) public _isExcludedMaxTransactionAmount;mapping (address => bool) public _isExcludedMaxWalletAmount;
835  
836     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
837     // could be subject to a maximum transfer amount
838     mapping (address => bool) public automatedMarketMakerPairs;
839  
840     constructor() ERC20("OMICS", "OMICS TOKEN") {
841        
842         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
843        
844         excludeFromMaxTransaction(address(_uniswapV2Router), true);
845         excludeFromMaxWallet(address(_uniswapV2Router), true);
846         uniswapV2Router = _uniswapV2Router;
847        
848         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
849         excludeFromMaxTransaction(address(uniswapV2Pair), true);
850         excludeFromMaxWallet(address(uniswapV2Pair), true);
851         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
852  
853         buyTotalFees = buyTreasuryFee + buyBurnFee + buyReflectionFee;
854         sellTotalFees = sellTreasuryFee + sellBurnFee + sellReflectionFee;
855        
856         Treasury = 0xfD5243522C2c10B3a2Abf7A8DBfe1AC5Bc3D8D09;
857         _rOwned[_msgSender()] = _rTotal;
858         _tSupply = _tTotal;
859  
860         walletDigit = 1;
861         transDigit = 1;
862         delayDigit = 1;
863        
864         maxTransactionAmount =_tSupply * transDigit / 100;
865         swapTokensAtAmount = _tSupply * 5 / 10000; // 0.05% swap wallet;
866         maxWallet = _tSupply * walletDigit / 100;
867  
868         // exclude from paying fees or having max transaction amount, max wallet amount
869         excludeFromFees(owner(), true);
870         excludeFromFees(address(this), true);
871         excludeFromFees(address(0xdead), true);
872        
873         excludeFromMaxTransaction(owner(), true);
874         excludeFromMaxTransaction(address(this), true);
875         excludeFromMaxTransaction(address(0xdead), true);
876  
877         excludeFromMaxWallet(owner(), true);
878         excludeFromMaxWallet(address(this), true);
879         excludeFromMaxWallet(address(0xdead), true);
880  
881         _approve(owner(), address(uniswapV2Router), _tSupply);
882         _mint(msg.sender, _tSupply);
883     }
884  
885     receive() external payable {}
886  
887     // once enabled, can never be turned off
888     function enableTrading() external onlyOwner {
889         tradingActive = true;
890     }
891    
892     // remove limits after token is stable
893     function removeLimits() external onlyOwner returns (bool) {
894         limitsInEffect = false;
895         return true;
896     }
897  
898      // change the minimum amount of tokens to swap
899     function updateSwapTokensAtAmount(uint256 newAmount) external onlyOwner returns (bool) {
900                   require(newAmount >= (totalSupply() * 1 / 100000) / 1e6, "Swap amount cannot be lower than 0.001% total supply.");
901                   require(newAmount <= (totalSupply() * 5 / 1000) / 1e6, "Swap amount cannot be higher than 0.5% total supply.");
902                   swapTokensAtAmount = newAmount * (10**6);
903                   return true;
904               }
905    
906     function updateTransDigit(uint256 newNum) external onlyOwner {
907         require(newNum >= 1);
908         transDigit = newNum;
909         updateLimits();
910     }
911  
912     function updateWalletDigit(uint256 newNum) external onlyOwner {
913         require(newNum >= 1);
914         walletDigit = newNum;
915         updateLimits();
916     }
917  
918     function updateDelayDigit(uint256 newNum) external onlyOwner{
919         delayDigit = newNum;
920     }
921    
922     function excludeFromMaxTransaction(address updAds, bool isEx) public onlyOwner {
923         _isExcludedMaxTransactionAmount[updAds] = isEx;
924     }
925  
926     function excludeFromMaxWallet(address updAds, bool isEx) public onlyOwner {
927         _isExcludedMaxWalletAmount[updAds] = isEx;
928     }
929  
930     function updateBuyFees(uint256 _treasuryFee, uint256 _burnFee, uint256 _reflectionFee) external onlyOwner {
931         buyTreasuryFee = _treasuryFee;
932         buyBurnFee = _burnFee;
933         buyReflectionFee = _reflectionFee;
934         buyTotalFees = buyTreasuryFee + buyBurnFee + buyReflectionFee;require(buyTotalFees <= 10, "Must keep fees at 10% or less");
935     }
936    
937     function updateSellFees(uint256 _treasuryFee, uint256 _burnFee, uint256 _reflectionFee) external onlyOwner {
938         sellTreasuryFee = _treasuryFee;
939         sellBurnFee = _burnFee;
940         sellReflectionFee = _reflectionFee;
941         sellTotalFees = sellTreasuryFee + sellBurnFee + sellReflectionFee;
942         require(sellTotalFees <= 10, "Must keep fees at 10% or less");
943     }
944  
945     function excludeFromFees(address account, bool excluded) public onlyOwner {
946         _isExcludedFromFees[account] = excluded;
947     }
948  
949     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
950         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
951  
952         _setAutomatedMarketMakerPair(pair, value);
953     }
954  
955     function _setAutomatedMarketMakerPair(address pair, bool value) private {
956         automatedMarketMakerPairs[pair] = value;
957  
958     }
959  
960     function updateTreasuryWallet(address newTreasuryWallet) external onlyOwner {
961         Treasury = newTreasuryWallet;
962     }
963  
964     function updateLimits() private {
965         maxTransactionAmount = _tSupply * transDigit / 100;
966         swapTokensAtAmount = _tSupply * 1 / 10000; // 0.01% swap wallet;
967         maxWallet = _tSupply * walletDigit / 100;
968     }
969  
970     function isExcludedFromFees(address account) external view returns(bool) {
971         return _isExcludedFromFees[account];
972     }
973  
974     function _transfer(
975         address from,
976         address to,
977         uint256 amount
978     ) internal override {
979         require(from != address(0), "ERC20: transfer from the zero address");
980         require(to != address(0), "ERC20: transfer to the zero address");
981         require(amount > 0, "Transfer amount must be greater than zero");
982  
983         if (limitsInEffect) {
984             if (
985                 from != owner() &&
986                 to != owner() &&
987                 to != address(0) &&
988                 to != address(0xdead) &&
989                 !swapping
990             ) {
991                 if (!tradingActive) {
992                     require(_isExcludedFromFees[from] || _isExcludedFromFees[to], "Trading is not active.");
993                 }
994 
995                 if (transferDelayEnabled){
996                     if (to != owner() && to != address(uniswapV2Router) && to != address(uniswapV2Pair)){
997                         require(_holderLastTransferTimestamp[tx.origin] < block.number, "_transfer:: Transfer Delay enabled.  Only one purchase per block allowed.");
998                         _holderLastTransferTimestamp[tx.origin] = block.number + delayDigit;
999                     }
1000                 }
1001  
1002                 // when buy
1003                 if (automatedMarketMakerPairs[from] && !_isExcludedMaxTransactionAmount[to]) {
1004                     require(amount <= maxTransactionAmount, "Buy transfer amount exceeds the maxTransactionAmount.");
1005                 }
1006  
1007                 if (!_isExcludedMaxTransactionAmount[from]) {
1008                     require(amount <= maxTransactionAmount, "transfer amount exceeds the maxTransactionAmount.");
1009                 }
1010  
1011                 if (!_isExcludedMaxWalletAmount[to]) {
1012                     require(amount + balanceOf(to) <= maxWallet, "Max wallet exceeded");
1013                 }
1014             }
1015         }
1016  
1017                              uint256 contractTokenBalance = balanceOf(address(this));
1018        
1019         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1020  
1021         if (
1022             canSwap &&
1023             !swapping &&
1024             !automatedMarketMakerPairs[from] &&
1025             !_isExcludedFromFees[from] &&
1026             !_isExcludedFromFees[to]
1027         ) {
1028             swapping = true;
1029            
1030             swapBack();
1031  
1032             swapping = false;
1033         }
1034  
1035         bool takeFee = !swapping;
1036  
1037         // if any account belongs to _isExcludedFromFee account then remove the fee
1038         if (_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1039             takeFee = false;
1040         }
1041        
1042         uint256 fees = 0;
1043         uint256 reflectionFee = 0;if (takeFee){
1044  
1045             // on buy
1046             if (automatedMarketMakerPairs[from] && to != address(uniswapV2Router)) {
1047                 fees = amount.mul(buyTotalFees).div(100);
1048                 getTokensForFees(amount, buyTreasuryFee, buyBurnFee, buyReflectionFee);
1049             }
1050  
1051             // on sell
1052             else if (automatedMarketMakerPairs[to] && from != address(uniswapV2Router)) {
1053                     fees = amount.mul(sellTotalFees).div(100);
1054                     getTokensForFees(amount, sellTreasuryFee, sellBurnFee, sellReflectionFee);
1055             }
1056  
1057             if (fees > 0) {
1058                 _tokenTransfer(from, address(this), fees, 0);
1059                 uint256 refiAmount = tokensForBurn + tokensForReflections;
1060                 bool refiAndBurn = refiAmount > 0;
1061  
1062                 if(refiAndBurn){
1063                     burnAndReflect(refiAmount);
1064                 }
1065  
1066             }
1067  
1068             amount -= fees;
1069         }
1070  
1071         _tokenTransfer(from, to, amount, reflectionFee);
1072     }
1073  
1074     function getTokensForFees(uint256 _amount, uint256 _treasuryFee, uint256 _burnFee, uint256 _reflectionFee) private {
1075         tokensForTreasury += _amount.mul(_treasuryFee).div(100);
1076         tokensForBurn += _amount.mul(_burnFee).div(100);
1077         tokensForReflections += _amount.mul(_reflectionFee).div(100);
1078     }
1079  
1080     function swapTokensForEth(uint256 tokenAmount) private {
1081  
1082         // generate the uniswap pair path of token -> weth
1083         address[] memory path = new address[](2);
1084         path[0] = address(this);
1085         path[1] = uniswapV2Router.WETH();
1086  
1087         _approve(address(this), address(uniswapV2Router), tokenAmount);
1088  
1089         // make the swap
1090         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1091             tokenAmount,
1092             0, // accept any amount of ETH
1093             path,
1094             address(this),
1095             block.timestamp
1096         );
1097        
1098     }
1099  
1100     function swapBack() private {
1101         uint256 contractBalance = balanceOf(address(this));
1102         bool success;
1103        
1104         if(contractBalance == 0) {return;}
1105  
1106         swapTokensForEth(contractBalance);
1107  
1108         tokensForTreasury = 0;
1109  
1110        
1111         (success,) = address(Treasury).call{value: address(this).balance}("");
1112     }
1113  
1114     // Reflection
1115     function totalSupply() public view override returns (uint256) {
1116         return _tSupply;
1117     }
1118  
1119     function balanceOf(address account) public view override returns (uint256) {
1120         return tokenFromReflection(_rOwned[account]);
1121     }
1122  
1123     function tokenFromReflection(uint256 rAmount) private view returns(uint256) {
1124         require(rAmount <= _rTotal, "Amount must be less than total reflections");
1125         uint256 currentRate =  _getRate();
1126         return rAmount.div(currentRate);
1127     }
1128  
1129     function _tokenTransfer(address sender, address recipient, uint256 amount, uint256 reflectionFee) private {     
1130         _transferStandard(sender, recipient, amount, reflectionFee);
1131     }
1132  
1133     function _transferStandard(address sender, address recipient, uint256 tAmount, uint256 reflectionFee) private {
1134         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount, reflectionFee);
1135         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1136         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1137         _reflectFee(rFee, tFee);
1138         emit Transfer(sender, recipient, tTransferAmount);
1139     }
1140  
1141     function _reflectFee(uint256 rFee, uint256 tFee) private {
1142         _rTotal = _rTotal.sub(rFee);
1143         _tFeeTotal = _tFeeTotal.add(tFee);
1144     }
1145  
1146     function _getValues(uint256 tAmount, uint256 reflectionFee) private view returns (uint256, uint256, uint256, uint256, uint256) {
1147         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount, reflectionFee);
1148         uint256 currentRate =  _getRate();
1149         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1150         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
1151     }function _getTValues(uint256 tAmount, uint256 reflectionFee) private pure returns (uint256, uint256) {
1152         uint256 tFee = tAmount.mul(reflectionFee).div(100);
1153         uint256 tTransferAmount = tAmount.sub(tFee);
1154         return (tTransferAmount, tFee);
1155     }
1156  
1157     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1158         uint256 rAmount = tAmount.mul(currentRate);
1159         uint256 rFee = tFee.mul(currentRate);
1160         uint256 rTransferAmount = rAmount.sub(rFee);
1161         return (rAmount, rTransferAmount, rFee);
1162     }
1163  
1164     function _getRate() private view returns(uint256) {
1165         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1166         return rSupply.div(tSupply);
1167     }
1168  
1169     function _getCurrentSupply() private view returns(uint256, uint256) {
1170         uint256 rSupply = _rTotal;
1171         uint256 tSupply = _tTotal;
1172  
1173         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1174         return (rSupply, tSupply);
1175     }
1176    
1177     function burnAndReflect(uint256 _amount) private {
1178         _tokenTransfer(address(this), deadAddress, _amount, 50);
1179         _tSupply -= _amount.div(2);
1180         tokensForReflections = 0;
1181         tokensForBurn = 0;
1182         updateLimits();
1183     }
1184  
1185  
1186 }