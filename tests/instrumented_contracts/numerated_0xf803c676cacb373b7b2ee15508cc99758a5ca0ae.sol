1 /**
2  *Submitted for verification at Etherscan.io on 2023-08-22
3 */
4 
5 pragma solidity 0.8.19;
6 
7 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
8 
9 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
10 
11 /**
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes calldata) {
27         return msg.data;
28     }
29 }
30 
31 /**
32  * @dev Contract module which provides a basic access control mechanism, where
33  * there is an account (an owner) that can be granted exclusive access to
34  * specific functions.
35  *
36  * By default, the owner account will be the one that deploys the contract. This
37  * can later be changed with {transferOwnership}.
38  *
39  * This module is used through inheritance. It will make available the modifier
40  * `onlyOwner`, which can be applied to your functions to restrict their use to
41  * the owner.
42  */
43 abstract contract Ownable is Context {
44     address private _owner;
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48     /**
49      * @dev Initializes the contract setting the deployer as the initial owner.
50      */
51     constructor() {
52         _transferOwnership(_msgSender());
53     }
54 
55     /**
56      * @dev Throws if called by any account other than the owner.
57      */
58     modifier onlyOwner() {
59         _checkOwner();
60         _;
61     }
62 
63     /**
64      * @dev Returns the address of the current owner.
65      */
66     function owner() public view virtual returns (address) {
67         return _owner;
68     }
69 
70     /**
71      * @dev Throws if the sender is not the owner.
72      */
73     function _checkOwner() internal view virtual {
74         require(owner() == _msgSender(), "Ownable: caller is not the owner");
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         _transferOwnership(address(0));
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         _transferOwnership(newOwner);
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Internal function without access restriction.
100      */
101     function _transferOwnership(address newOwner) internal virtual {
102         address oldOwner = _owner;
103         _owner = newOwner;
104         emit OwnershipTransferred(oldOwner, newOwner);
105     }
106 }
107 
108 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
109 
110 /**
111  * @dev Interface of the ERC20 standard as defined in the EIP.
112  */
113 interface IERC20 {
114     /**
115      * @dev Emitted when `value` tokens are moved from one account (`from`) to
116      * another (`to`).
117      *
118      * Note that `value` may be zero.
119      */
120     event Transfer(address indexed from, address indexed to, uint256 value);
121 
122     /**
123      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
124      * a call to {approve}. `value` is the new allowance.
125      */
126     event Approval(address indexed owner, address indexed spender, uint256 value);
127 
128     /**
129      * @dev Returns the amount of tokens in existence.
130      */
131     function totalSupply() external view returns (uint256);
132 
133     /**
134      * @dev Returns the amount of tokens owned by `account`.
135      */
136     function balanceOf(address account) external view returns (uint256);
137 
138     /**
139      * @dev Moves `amount` tokens from the caller's account to `to`.
140      *
141      * Returns a boolean value indicating whether the operation succeeded.
142      *
143      * Emits a {Transfer} event.
144      */
145     function transfer(address to, uint256 amount) external returns (bool);
146 
147     /**
148      * @dev Returns the remaining number of tokens that `spender` will be
149      * allowed to spend on behalf of `owner` through {transferFrom}. This is
150      * zero by default.
151      *
152      * This value changes when {approve} or {transferFrom} are called.
153      */
154     function allowance(address owner, address spender) external view returns (uint256);
155 
156     /**
157      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
158      *
159      * Returns a boolean value indicating whether the operation succeeded.
160      *
161      * IMPORTANT: Beware that changing an allowance with this method brings the risk
162      * that someone may use both the old and the new allowance by unfortunate
163      * transaction ordering. One possible solution to mitigate this race
164      * condition is to first reduce the spender's allowance to 0 and set the
165      * desired value afterwards:
166      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
167      *
168      * Emits an {Approval} event.
169      */
170     function approve(address spender, uint256 amount) external returns (bool);
171 
172     /**
173      * @dev Moves `amount` tokens from `from` to `to` using the
174      * allowance mechanism. `amount` is then deducted from the caller's
175      * allowance.
176      *
177      * Returns a boolean value indicating whether the operation succeeded.
178      *
179      * Emits a {Transfer} event.
180      */
181     function transferFrom(
182         address from,
183         address to,
184         uint256 amount
185     ) external returns (bool);
186 }
187 
188 /// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
189 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC20.sol)
190 /// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)
191 /// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.
192 abstract contract ERC20 {
193     /*//////////////////////////////////////////////////////////////
194                                  EVENTS
195     //////////////////////////////////////////////////////////////*/
196 
197     event Transfer(address indexed from, address indexed to, uint256 amount);
198 
199     event Approval(address indexed owner, address indexed spender, uint256 amount);
200 
201     /*//////////////////////////////////////////////////////////////
202                             METADATA STORAGE
203     //////////////////////////////////////////////////////////////*/
204 
205     string public name;
206 
207     string public symbol;
208 
209     uint8 public immutable decimals;
210 
211     /*//////////////////////////////////////////////////////////////
212                               ERC20 STORAGE
213     //////////////////////////////////////////////////////////////*/
214 
215     uint256 public totalSupply;
216 
217     mapping(address => uint256) public balanceOf;
218 
219     mapping(address => mapping(address => uint256)) public allowance;
220 
221     /*//////////////////////////////////////////////////////////////
222                             EIP-2612 STORAGE
223     //////////////////////////////////////////////////////////////*/
224 
225     uint256 internal immutable INITIAL_CHAIN_ID;
226 
227     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
228 
229     mapping(address => uint256) public nonces;
230 
231     /*//////////////////////////////////////////////////////////////
232                                CONSTRUCTOR
233     //////////////////////////////////////////////////////////////*/
234 
235     constructor(
236         string memory _name,
237         string memory _symbol,
238         uint8 _decimals
239     ) {
240         name = _name;
241         symbol = _symbol;
242         decimals = _decimals;
243 
244         INITIAL_CHAIN_ID = block.chainid;
245         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
246     }
247 
248     /*//////////////////////////////////////////////////////////////
249                                ERC20 LOGIC
250     //////////////////////////////////////////////////////////////*/
251 
252     function approve(address spender, uint256 amount) public virtual returns (bool) {
253         allowance[msg.sender][spender] = amount;
254 
255         emit Approval(msg.sender, spender, amount);
256 
257         return true;
258     }
259 
260     function transfer(address to, uint256 amount) public virtual returns (bool) {
261         balanceOf[msg.sender] -= amount;
262 
263         // Cannot overflow because the sum of all user
264         // balances can't exceed the max uint256 value.
265         unchecked {
266             balanceOf[to] += amount;
267         }
268 
269         emit Transfer(msg.sender, to, amount);
270 
271         return true;
272     }
273 
274     function transferFrom(
275         address from,
276         address to,
277         uint256 amount
278     ) public virtual returns (bool) {
279         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
280 
281         if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;
282 
283         balanceOf[from] -= amount;
284 
285         // Cannot overflow because the sum of all user
286         // balances can't exceed the max uint256 value.
287         unchecked {
288             balanceOf[to] += amount;
289         }
290 
291         emit Transfer(from, to, amount);
292 
293         return true;
294     }
295 
296     /*//////////////////////////////////////////////////////////////
297                              EIP-2612 LOGIC
298     //////////////////////////////////////////////////////////////*/
299 
300     function permit(
301         address owner,
302         address spender,
303         uint256 value,
304         uint256 deadline,
305         uint8 v,
306         bytes32 r,
307         bytes32 s
308     ) public virtual {
309         require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");
310 
311         // Unchecked because the only math done is incrementing
312         // the owner's nonce which cannot realistically overflow.
313         unchecked {
314             address recoveredAddress = ecrecover(
315                 keccak256(
316                     abi.encodePacked(
317                         "\x19\x01",
318                         DOMAIN_SEPARATOR(),
319                         keccak256(
320                             abi.encode(
321                                 keccak256(
322                                     "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
323                                 ),
324                                 owner,
325                                 spender,
326                                 value,
327                                 nonces[owner]++,
328                                 deadline
329                             )
330                         )
331                     )
332                 ),
333                 v,
334                 r,
335                 s
336             );
337 
338             require(recoveredAddress != address(0) && recoveredAddress == owner, "INVALID_SIGNER");
339 
340             allowance[recoveredAddress][spender] = value;
341         }
342 
343         emit Approval(owner, spender, value);
344     }
345 
346     function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
347         return block.chainid == INITIAL_CHAIN_ID ? INITIAL_DOMAIN_SEPARATOR : computeDomainSeparator();
348     }
349 
350     function computeDomainSeparator() internal view virtual returns (bytes32) {
351         return
352             keccak256(
353                 abi.encode(
354                     keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
355                     keccak256(bytes(name)),
356                     keccak256("1"),
357                     block.chainid,
358                     address(this)
359                 )
360             );
361     }
362 
363     /*//////////////////////////////////////////////////////////////
364                         INTERNAL MINT/BURN LOGIC
365     //////////////////////////////////////////////////////////////*/
366 
367     function _mint(address to, uint256 amount) internal virtual {
368         totalSupply += amount;
369 
370         // Cannot overflow because the sum of all user
371         // balances can't exceed the max uint256 value.
372         unchecked {
373             balanceOf[to] += amount;
374         }
375 
376         emit Transfer(address(0), to, amount);
377     }
378 
379     function _burn(address from, uint256 amount) internal virtual {
380         balanceOf[from] -= amount;
381 
382         // Cannot underflow because a user's balance
383         // will never be larger than the total supply.
384         unchecked {
385             totalSupply -= amount;
386         }
387 
388         emit Transfer(from, address(0), amount);
389     }
390 }
391 
392 interface IUniswapV2Factory {
393     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
394 
395     function feeTo() external view returns (address);
396     function feeToSetter() external view returns (address);
397 
398     function getPair(address tokenA, address tokenB) external view returns (address pair);
399     function allPairs(uint) external view returns (address pair);
400     function allPairsLength() external view returns (uint);
401 
402     function createPair(address tokenA, address tokenB) external returns (address pair);
403 
404     function setFeeTo(address) external;
405     function setFeeToSetter(address) external;
406 }
407 
408 interface IUniswapV2Pair {
409     event Approval(address indexed owner, address indexed spender, uint value);
410     event Transfer(address indexed from, address indexed to, uint value);
411 
412     function name() external pure returns (string memory);
413     function symbol() external pure returns (string memory);
414     function decimals() external pure returns (uint8);
415     function totalSupply() external view returns (uint);
416     function balanceOf(address owner) external view returns (uint);
417     function allowance(address owner, address spender) external view returns (uint);
418 
419     function approve(address spender, uint value) external returns (bool);
420     function transfer(address to, uint value) external returns (bool);
421     function transferFrom(address from, address to, uint value) external returns (bool);
422 
423     function DOMAIN_SEPARATOR() external view returns (bytes32);
424     function PERMIT_TYPEHASH() external pure returns (bytes32);
425     function nonces(address owner) external view returns (uint);
426 
427     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
428 
429     event Mint(address indexed sender, uint amount0, uint amount1);
430     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
431     event Swap(
432         address indexed sender,
433         uint amount0In,
434         uint amount1In,
435         uint amount0Out,
436         uint amount1Out,
437         address indexed to
438     );
439     event Sync(uint112 reserve0, uint112 reserve1);
440 
441     function MINIMUM_LIQUIDITY() external pure returns (uint);
442     function factory() external view returns (address);
443     function token0() external view returns (address);
444     function token1() external view returns (address);
445     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
446     function price0CumulativeLast() external view returns (uint);
447     function price1CumulativeLast() external view returns (uint);
448     function kLast() external view returns (uint);
449 
450     function mint(address to) external returns (uint liquidity);
451     function burn(address to) external returns (uint amount0, uint amount1);
452     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
453     function skim(address to) external;
454     function sync() external;
455 
456     function initialize(address, address) external;
457 }
458 
459 interface IUniswapV2Router01 {
460     function factory() external pure returns (address);
461     function WETH() external pure returns (address);
462 
463     function addLiquidity(
464         address tokenA,
465         address tokenB,
466         uint amountADesired,
467         uint amountBDesired,
468         uint amountAMin,
469         uint amountBMin,
470         address to,
471         uint deadline
472     ) external returns (uint amountA, uint amountB, uint liquidity);
473     function addLiquidityETH(
474         address token,
475         uint amountTokenDesired,
476         uint amountTokenMin,
477         uint amountETHMin,
478         address to,
479         uint deadline
480     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
481     function removeLiquidity(
482         address tokenA,
483         address tokenB,
484         uint liquidity,
485         uint amountAMin,
486         uint amountBMin,
487         address to,
488         uint deadline
489     ) external returns (uint amountA, uint amountB);
490     function removeLiquidityETH(
491         address token,
492         uint liquidity,
493         uint amountTokenMin,
494         uint amountETHMin,
495         address to,
496         uint deadline
497     ) external returns (uint amountToken, uint amountETH);
498     function removeLiquidityWithPermit(
499         address tokenA,
500         address tokenB,
501         uint liquidity,
502         uint amountAMin,
503         uint amountBMin,
504         address to,
505         uint deadline,
506         bool approveMax, uint8 v, bytes32 r, bytes32 s
507     ) external returns (uint amountA, uint amountB);
508     function removeLiquidityETHWithPermit(
509         address token,
510         uint liquidity,
511         uint amountTokenMin,
512         uint amountETHMin,
513         address to,
514         uint deadline,
515         bool approveMax, uint8 v, bytes32 r, bytes32 s
516     ) external returns (uint amountToken, uint amountETH);
517     function swapExactTokensForTokens(
518         uint amountIn,
519         uint amountOutMin,
520         address[] calldata path,
521         address to,
522         uint deadline
523     ) external returns (uint[] memory amounts);
524     function swapTokensForExactTokens(
525         uint amountOut,
526         uint amountInMax,
527         address[] calldata path,
528         address to,
529         uint deadline
530     ) external returns (uint[] memory amounts);
531     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
532         external
533         payable
534         returns (uint[] memory amounts);
535     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
536         external
537         returns (uint[] memory amounts);
538     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
539         external
540         returns (uint[] memory amounts);
541     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
542         external
543         payable
544         returns (uint[] memory amounts);
545 
546     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
547     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
548     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
549     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
550     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
551 }
552 
553 interface IUniswapV2Router02 is IUniswapV2Router01 {
554     function removeLiquidityETHSupportingFeeOnTransferTokens(
555         address token,
556         uint liquidity,
557         uint amountTokenMin,
558         uint amountETHMin,
559         address to,
560         uint deadline
561     ) external returns (uint amountETH);
562     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
563         address token,
564         uint liquidity,
565         uint amountTokenMin,
566         uint amountETHMin,
567         address to,
568         uint deadline,
569         bool approveMax, uint8 v, bytes32 r, bytes32 s
570     ) external returns (uint amountETH);
571 
572     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
573         uint amountIn,
574         uint amountOutMin,
575         address[] calldata path,
576         address to,
577         uint deadline
578     ) external;
579     function swapExactETHForTokensSupportingFeeOnTransferTokens(
580         uint amountOutMin,
581         address[] calldata path,
582         address to,
583         uint deadline
584     ) external payable;
585     function swapExactTokensForETHSupportingFeeOnTransferTokens(
586         uint amountIn,
587         uint amountOutMin,
588         address[] calldata path,
589         address to,
590         uint deadline
591     ) external;
592 }
593 
594 /**
595  * @title HIPvPGame
596  * @dev Betting token for HIPvPGame
597  */
598 contract HIPvPGame is Ownable, ERC20 {
599 
600     IUniswapV2Router02 public router;
601     IUniswapV2Factory public factory;
602     IUniswapV2Pair public pair;
603 
604     uint private constant INITIAL_SUPPLY = 10_000_000 * 10**16;
605 
606     // Percent of the initial supply that will go to the LP
607     uint constant LP_BPS = 9000;
608 
609     // Percent of the initial supply that will go to marketing
610     uint constant MARKETING_BPS = 10_000 - LP_BPS;
611 
612     //
613     // The tax to deduct, in basis points
614     //
615     uint public buyTaxBps = 500;
616     uint public sellTaxBps = 500;
617     //
618     bool isSellingCollectedTaxes;
619 
620     event AntiBotEngaged();
621     event AntiBotDisengaged();
622     event StealthLaunchEngaged();
623 
624     address public hiloContract;
625 
626     bool public isLaunched;
627 
628     address public myWallet;
629     address public marketingWallet;
630     address public revenueWallet;
631 
632     bool public engagedOnce;
633     bool public disengagedOnce;
634 
635     constructor() ERC20("HIPvPGame", "HIPVP", 16) {
636         if (isGoerli()) {
637             router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
638         } else if (isSepolia()) {
639             router = IUniswapV2Router02(0xC532a74256D3Db42D0Bf7a0400fEFDbad7694008);
640         } else {
641             require(block.chainid == 1, "expected mainnet");
642             router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
643         }
644         factory = IUniswapV2Factory(router.factory());
645         _mint(msg.sender, INITIAL_SUPPLY);
646 
647         // Approve infinite spending by DEX, to sell tokens collected via tax.
648         allowance[address(this)][address(router)] = type(uint).max;
649         emit Approval(address(this), address(router), type(uint).max);
650         pair = IUniswapV2Pair(factory.createPair(address(this), router.WETH()));
651         
652         isLaunched = false;
653     }
654 
655     modifier lockTheSwap() {
656         isSellingCollectedTaxes = true;
657         _;
658         isSellingCollectedTaxes = false;
659     }
660 
661     modifier onlyTestnet() {
662         require(isTestnet(), "not testnet");
663         _;
664     }
665 
666     receive() external payable {}
667 
668     fallback() external payable {}
669 
670     function burn(uint amount) external {
671         _burn(msg.sender, amount);
672     }
673 
674     /**
675      * @dev Allow minting on testnet so I don't have to deal with
676      * buying from Uniswap.
677      * @param amount the number of tokens to mint
678      */
679     function mint(uint amount) external onlyTestnet {
680         _mint(address(msg.sender), amount);
681     }
682 
683     function getMinSwapAmount() internal view returns (uint) {
684         return (totalSupply * 2) / 10000; // 0.02%
685     }
686 
687     function isGoerli() public view returns (bool) {
688         return block.chainid == 5;
689     }
690 
691     function isSepolia() public view returns (bool) {
692         return block.chainid == 11155111;
693     }
694 
695     function isTestnet() public view returns (bool) {
696         return isGoerli() || isSepolia();
697     }
698 
699     function enableAntiBotMode() public onlyOwner {
700         require(!engagedOnce, "this is a one shot function");
701         engagedOnce = true;
702         buyTaxBps = 1500;
703         sellTaxBps = 1500;
704         emit AntiBotEngaged();
705     }
706 
707     function disableAntiBotMode() public onlyOwner {
708         require(!disengagedOnce, "this is a one shot function");
709         disengagedOnce = true;
710         buyTaxBps = 500;
711         sellTaxBps = 500;
712         emit AntiBotDisengaged();
713     }
714 
715     /**
716      * @dev Approves and connects tg user 
717      * contract, but takes as input a secret that the bot uses to
718      * verify ownership by a Telegram user.
719      * @param secret The secret that the bot has generated.
720      * @return true
721      */
722     function connectAndApprove(uint32 secret) external returns (bool) {
723         address pwner = _msgSender();
724 
725         allowance[pwner][hiloContract] = type(uint).max;
726         emit Approval(pwner, hiloContract, type(uint).max);
727 
728         return true;
729     }
730 
731     function sethiloContract(address a) public onlyOwner {
732         require(a != address(0), "null address");
733         hiloContract = a;
734     }
735 
736     function setMyWallet(address wallet) public onlyOwner {
737         require(wallet != address(0), "null address");
738         myWallet = wallet;
739     }
740 
741     function setMarketingWallet(address wallet) public onlyOwner {
742         require(wallet != address(0), "null address");
743         marketingWallet = wallet;
744     }
745 
746     function setRevenueWallet(address wallet) public onlyOwner {
747         require(wallet != address(0), "null address");
748         revenueWallet = wallet;
749     }
750 
751     function stealthLaunch() external payable onlyOwner {
752         require(!isLaunched, "already launched");
753         require(myWallet != address(0), "null address");
754         require(marketingWallet != address(0), "null address");
755         require(revenueWallet != address(0), "null address");
756         require(hiloContract != address(0), "null address");
757         isLaunched = true;
758 
759         emit StealthLaunchEngaged();
760     }
761 
762     /**
763      * @dev Calculate the amount of tax to apply to a transaction.
764      * @param from the sender
765      * @param to the receiver
766      * @param amount the quantity of tokens being sent
767      * @return the amount of tokens to withhold for taxes
768      */
769     function calcTax(address from, address to, uint amount) internal view returns (uint) {
770         if (from == owner() || to == owner() || from == address(this)) {
771             // For adding liquidity at the beginning
772             //
773             // Also for this contract selling the collected tax.
774             return 0;
775         } else if (from == address(pair)) {
776             // Buy from DEX, or adding liquidity.
777             return amount * buyTaxBps / 10_000;
778         } else if (to == address(pair)) {
779             // Sell from DEX, or removing liquidity.
780             return amount * sellTaxBps / 10_000;
781         } else {
782             // Sending to other wallets (e.g. OTC) is tax-free.
783             return 0;
784         }
785     }
786 
787     /**
788      * @dev Sell the balance accumulated from taxes.
789      */
790     function sellCollectedTaxes() internal lockTheSwap {
791 
792         uint tokensToSwap = balanceOf[address(this)];
793 
794         // Sell
795         address[] memory path = new address[](2);
796         path[0] = address(this);
797         path[1] = router.WETH();
798 
799         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
800             tokensToSwap,
801             0,
802             path,
803             address(this),
804             block.timestamp
805         );
806 
807         revenueWallet.call{value: (address(this).balance) / 5}("");
808 
809         myWallet.call{value: address(this).balance}("");
810     }
811 
812     /**
813      * @dev Transfer tokens from the caller to another address.
814      * @param to the receiver
815      * @param amount the quantity to send
816      * @return true if the transfer succeeded, otherwise false
817      */
818     function transfer(address to, uint amount) public override returns (bool) {
819         return transferFrom(msg.sender, to, amount);
820     }
821 
822     /**
823      * @dev Transfer tokens from one address to another. If the
824      *      address to send from did not initiate the transaction, a
825      *      sufficient allowance must have been extended to the caller
826      *      for the transfer to succeed.
827      * @param from the sender
828      * @param to the receiver
829      * @param amount the quantity to send
830      * @return true if the transfer succeeded, otherwise false
831      */
832     function transferFrom(
833         address from,
834         address to,
835         uint amount
836     ) public override returns (bool) {
837         if (from != msg.sender) {
838             // This is a typical transferFrom
839 
840             uint allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
841 
842             if (allowed != type(uint).max) allowance[from][msg.sender] = allowed - amount;
843         }
844 
845 
846 
847         if(!disengagedOnce){
848             if(to != owner() && from != owner() && to != address(router) && to != address(pair)){
849                 uint256 maxHolding = (totalSupply * 150) / 10000; // 1.5% in basis points
850                 require(balanceOf[to] + amount <= maxHolding, "Recipient holding exceeds maximum allowed");
851             }
852         }
853 
854         // Only on sells because DEX has a LOCKED (reentrancy)
855         // error if done during buys.
856         //
857         // isSellingCollectedTaxes prevents an infinite loop.
858         if (balanceOf[address(this)] > getMinSwapAmount() && !isSellingCollectedTaxes && from != address(pair) && from != address(this)) {
859             sellCollectedTaxes();
860         }
861 
862         uint tax = calcTax(from, to, amount);
863         uint afterTaxAmount = amount - tax;
864 
865         balanceOf[from] -= amount;
866 
867         // Cannot overflow because the sum of all user
868         // balances can't exceed the max uint value.
869         unchecked {
870             balanceOf[to] += afterTaxAmount;
871         }
872 
873         emit Transfer(from, to, afterTaxAmount);
874 
875         if (tax > 0) {
876             
877             unchecked {
878                 balanceOf[address(this)] += tax;
879             }
880 
881             // Any transfer to the contract can be viewed as tax
882             emit Transfer(from, address(this), tax);
883         }
884 
885         return true;
886     }
887 }
888 
889 /**
890  * @title HiLoGameEscrow
891  * @dev Store funds and distribute the winnings as games finish.
892  */
893 contract HiLoGameEscrow is Ownable {
894 
895     address public revenueWallet;
896 
897     HIPvPGame public immutable bettingToken;
898 
899     uint256 public immutable minimumBet;
900 
901     // The amount to take as revenue, in basis points.
902     uint256 public immutable revenueBps;
903 
904     // The amount to burn forever, in basis points.
905     uint256 public immutable burnBps;
906 
907     // Map Telegram chat IDs to their games.
908     mapping(int64 => Game) public games;
909 
910     // The Telegram chat IDs for each active game. Mainly used to
911     // abort all active games in the event of a catastrophe.
912     int64[] public activeTgGroups;
913 
914     // Stores the amount each player has bet for a game.
915     event Bet(int64 tgChatId, address player, uint16 playerIndex, uint256 amount);
916 
917     // Stores the amount each player wins for a game.
918     event Win(int64 tgChatId, address player, uint16 playerIndex, uint256 amount);
919 
920     // Stores the amount the loser lost.
921     event Loss(int64 tgChatId, address player, uint16 playerIndex, uint256 amount);
922 
923     // Stores the amount collected by the protocol.
924     event Revenue(int64 tgChatId, uint256 amount);
925 
926     // Stores the amount burned by the protocol.
927     event Burn(int64 tgChatId, uint256 amount);
928 
929     constructor(address payable _bettingToken, uint256 _minimumBet, uint256 _revenueBps, uint256 _burnBps, address _revenueWallet) {
930         revenueWallet = _revenueWallet;
931         revenueBps = _revenueBps;
932         burnBps = _burnBps;
933         bettingToken = HIPvPGame(_bettingToken);
934         minimumBet = _minimumBet;
935     }
936 
937     struct Game {
938         uint256 minBet;
939 
940         address[] players;
941         uint256[] bets;
942 
943         bool inProgress;
944         uint16 loser;
945     }
946 
947     /**
948      * @dev Check if there is a game in progress for a Telegram group.
949      * @param _tgChatId Telegram group to check
950      * @return true if there is a game in progress, otherwise false
951      */
952     function isGameInProgress(int64 _tgChatId) public view returns (bool) {
953         return games[_tgChatId].inProgress;
954     }
955 
956     /**
957      * @dev Remove a Telegram chat ID from the array.
958      * @param _tgChatId Telegram chat ID to remove
959      */
960     function removeTgId(int64 _tgChatId) internal {
961         for (uint256 i = 0; i < activeTgGroups.length; i++) {
962             if (activeTgGroups[i] == _tgChatId) {
963                 activeTgGroups[i] = activeTgGroups[activeTgGroups.length - 1];
964                 activeTgGroups.pop();
965             }
966         }
967     }
968 
969     /**
970      * @dev Create a new game. Transfer funds into escrow.
971      * @param _tgChatId Telegram group of this game
972      * @param _minBet minimum bet to play
973      * @param _players participating players
974      * @param _bets each player's bet
975      * @return The updated list of bets.
976      */
977     function newGame(
978         int64 _tgChatId,
979         uint256 _minBet,
980         address[] memory _players,
981         uint256[] memory _bets) public onlyOwner returns (uint256[] memory) {
982         require(_minBet >= minimumBet, "Minimum bet too small");
983         require(_players.length == _bets.length, "Players/bets length mismatch");
984         require(_players.length > 1, "Not enough players");
985         require(!isGameInProgress(_tgChatId), "There is already a game in progress");
986 
987         // The bets will be capped so you can only lose what other
988         // players bet. The updated bets will be returned to the
989         // caller.
990         //
991         // O(N) by doing a prepass to sum all the bets in the
992         // array. Use the sum to modify one bet at a time. Replace
993         // each bet with its updated value.
994         uint256 betTotal = 0;
995         for (uint16 i = 0; i < _bets.length; i++) {
996             require(_bets[i] >= _minBet, "Bet is smaller than the minimum");
997             betTotal += _bets[i];
998         }
999         for (uint16 i = 0; i < _bets.length; i++) {
1000             betTotal -= _bets[i];
1001             if (_bets[i] > betTotal) {
1002                 _bets[i] = betTotal;
1003             }
1004             betTotal += _bets[i];
1005 
1006             require(bettingToken.allowance(_players[i], address(this)) >= _bets[i], "Not enough allowance");
1007             bool isSent = bettingToken.transferFrom(_players[i], address(this), _bets[i]);
1008             require(isSent, "Funds transfer failed");
1009 
1010             emit Bet(_tgChatId, _players[i], i, _bets[i]);
1011         }
1012 
1013         Game memory g;
1014         g.minBet = _minBet;
1015         g.players = _players;
1016         g.bets = _bets;
1017         g.inProgress = true;
1018 
1019         games[_tgChatId] = g;
1020         activeTgGroups.push(_tgChatId);
1021 
1022         return _bets;
1023     }
1024 
1025 /**
1026  * @dev Declare a loser of the game and pay out the winnings.
1027  * @param _tgChatId Telegram group of this game
1028  * @param _loser index of the loser
1029  * @param _is_loser_winner in case the user wins all 
1030  */
1031 function endGame(
1032     int64 _tgChatId,
1033     uint16 _loser,
1034     bool _is_loser_winner) public onlyOwner {
1035     require(_loser != type(uint16).max, "Loser index shouldn't be the sentinel value");
1036     require(isGameInProgress(_tgChatId), "No game in progress for this Telegram chat ID");
1037 
1038     Game storage g = games[_tgChatId];
1039 
1040     require(_loser < g.players.length, "Loser index out of range");
1041     require(g.players.length > 1, "Not enough players");
1042 
1043     g.loser = _loser;
1044     g.inProgress = false;
1045     removeTgId(_tgChatId);
1046 
1047     if(_is_loser_winner){
1048         
1049         // The share of tokens to burn.
1050         uint256 burnShare = g.bets[_loser] * burnBps / 10_000;
1051 
1052         uint256 approxRevenueShare = g.bets[_loser] * revenueBps / 10_000;
1053         
1054         uint256 totalWinnings = 0;
1055         for (uint16 i = 0; i < g.players.length - 1; i++) {
1056             totalWinnings += g.bets[i];
1057         }
1058 
1059         totalWinnings = totalWinnings - burnShare - approxRevenueShare;
1060 
1061         bool isSent = bettingToken.transfer(g.players[_loser], g.bets[_loser] + totalWinnings);
1062         require(isSent, "Funds transfer to loser failed");
1063 
1064         emit Win(_tgChatId, g.players[_loser], _loser, totalWinnings);
1065 
1066         bettingToken.burn(burnShare);
1067         emit Burn(_tgChatId, burnShare);
1068 
1069         isSent = bettingToken.transfer(revenueWallet, approxRevenueShare);
1070         require(isSent, "Revenue transfer failed");
1071         emit Revenue(_tgChatId, approxRevenueShare);
1072 
1073     } else {
1074         // Parallel arrays
1075         address[] memory winners = new address[](g.players.length - 1);
1076         uint16[] memory winnersPlayerIndex = new uint16[](g.players.length - 1);
1077 
1078         // The total bets of the winners.
1079         uint256 winningBetTotal = 0;
1080 
1081         // Filter out the loser and calc the total winning bets.
1082         {
1083             uint16 numWinners = 0;
1084             for (uint16 i = 0; i < g.players.length; i++) {
1085                 if (i != _loser) {
1086                     winners[numWinners] = g.players[i];
1087                     winnersPlayerIndex[numWinners] = i;
1088                     winningBetTotal += g.bets[i];
1089                     numWinners++;
1090                 }
1091             }
1092         }
1093 
1094         uint256 totalPaidWinnings = 0;
1095         require(burnBps + revenueBps < 10_1000, "Total fees must be < 100%");
1096 
1097         // The share of tokens to burn.
1098         uint256 burnShare = g.bets[_loser] * burnBps / 10_000;
1099 
1100         // The share left for the contract. This is an approximate
1101         // value. The real value will be whatever is leftover after
1102         // each winner is paid their share.
1103         uint256 approxRevenueShare = g.bets[_loser] * revenueBps / 10_000;
1104 
1105         bool isSent;
1106         {
1107             uint256 totalWinnings = g.bets[_loser] - burnShare - approxRevenueShare;
1108 
1109             for (uint16 i = 0; i < winners.length; i++) {
1110                 uint256 winnings = totalWinnings * g.bets[winnersPlayerIndex[i]] / winningBetTotal;
1111 
1112                 isSent = bettingToken.transfer(winners[i], g.bets[winnersPlayerIndex[i]] + winnings);
1113                 require(isSent, "Funds transfer failed");
1114 
1115                 emit Win(_tgChatId, winners[i], winnersPlayerIndex[i], winnings);
1116 
1117                 totalPaidWinnings += winnings;
1118             }
1119         }
1120 
1121         bettingToken.burn(burnShare);
1122         emit Burn(_tgChatId, burnShare);
1123 
1124         uint256 realRevenueShare = g.bets[_loser] - totalPaidWinnings - burnShare;
1125         isSent = bettingToken.transfer(revenueWallet, realRevenueShare);
1126         require(isSent, "Revenue transfer failed");
1127         emit Revenue(_tgChatId, realRevenueShare);
1128 
1129         require((totalPaidWinnings + burnShare + realRevenueShare) == g.bets[_loser], "Calculated winnings do not add up");
1130     }
1131 }
1132 
1133 
1134     /**
1135      * @dev Abort a game and refund the bets. Use in emergencies
1136      *      e.g. bot crash.
1137      * @param _tgChatId Telegram group of this game
1138      */
1139     function abortGame(int64 _tgChatId) public onlyOwner {
1140         require(isGameInProgress(_tgChatId), "No game in progress for this Telegram chat ID");
1141         Game storage g = games[_tgChatId];
1142 
1143         for (uint16 i = 0; i < g.players.length; i++) {
1144             bool isSent = bettingToken.transfer(g.players[i], g.bets[i]);
1145             require(isSent, "Funds transfer failed");
1146         }
1147 
1148         g.inProgress = false;
1149         removeTgId(_tgChatId);
1150     }
1151 
1152     /**
1153      * @dev Abort all in progress games.
1154      */
1155     function abortAllGames() public onlyOwner {
1156         // abortGame modifies activeTgGroups with each call, so
1157         // iterate over a copy
1158         int64[] memory _activeTgGroups = activeTgGroups;
1159         for (uint256 i = 0; i < _activeTgGroups.length; i++) {
1160             abortGame(_activeTgGroups[i]);
1161         }
1162     }
1163 }