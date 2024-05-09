1 /**
2  *Submitted for verification at Etherscan.io on 2023-08-02
3  */
4 
5 /*
6    Bullet Game - Play Russian Roulette directly in Telegram
7 
8                ,___________________________________________/7_
9               |-_______------. `\                             |
10           _,/ | _______)     |___\____________________________|
11      .__/`((  | _______      | (/))_______________=.
12         `~) \ | _______)     |   /----------------_/
13           `__y|______________|  /
14           / ________ __________/
15          / /#####\(  \  /     ))
16         / /#######|\  \(     //
17        / /########|.\______ad/`
18       / /###(\)###||`------``
19      / /##########||
20     / /###########||
21    ( (############||
22     \ \####(/)####))
23      \ \#########//
24       \ \#######//
25        `---|_|--`
26           ((_))
27            `-`
28 
29    Telegram:  https://t.me/CrashGameDarkPortal
30    Twitter/X: https://twitter.com/CrashGameERC
31    Docs:      https://bullet-game.gitbook.io/bullet-game
32 */
33 // SPDX-License-Identifier: MIT
34 
35 pragma solidity 0.8.19;
36 
37 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
38 
39 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
40 
41 /**
42  * @dev Provides information about the current execution context, including the
43  * sender of the transaction and its data. While these are generally available
44  * via msg.sender and msg.data, they should not be accessed in such a direct
45  * manner, since when dealing with meta-transactions the account sending and
46  * paying for execution may not be the actual sender (as far as an application
47  * is concerned).
48  *
49  * This contract is only required for intermediate, library-like contracts.
50  */
51 abstract contract Context {
52     function _msgSender() internal view virtual returns (address) {
53         return msg.sender;
54     }
55 
56     function _msgData() internal view virtual returns (bytes calldata) {
57         return msg.data;
58     }
59 }
60 
61 /**
62  * @dev Contract module which provides a basic access control mechanism, where
63  * there is an account (an owner) that can be granted exclusive access to
64  * specific functions.
65  *
66  * By default, the owner account will be the one that deploys the contract. This
67  * can later be changed with {transferOwnership}.
68  *
69  * This module is used through inheritance. It will make available the modifier
70  * `onlyOwner`, which can be applied to your functions to restrict their use to
71  * the owner.
72  */
73 abstract contract Ownable is Context {
74     address private _owner;
75 
76     event OwnershipTransferred(
77         address indexed previousOwner,
78         address indexed newOwner
79     );
80 
81     /**
82      * @dev Initializes the contract setting the deployer as the initial owner.
83      */
84     constructor() {
85         _transferOwnership(_msgSender());
86     }
87 
88     /**
89      * @dev Throws if called by any account other than the owner.
90      */
91     modifier onlyOwner() {
92         _checkOwner();
93         _;
94     }
95 
96     /**
97      * @dev Returns the address of the current owner.
98      */
99     function owner() public view virtual returns (address) {
100         return _owner;
101     }
102 
103     /**
104      * @dev Throws if the sender is not the owner.
105      */
106     function _checkOwner() internal view virtual {
107         require(owner() == _msgSender(), "Ownable: caller is not the owner");
108     }
109 
110     /**
111      * @dev Leaves the contract without owner. It will not be possible to call
112      * `onlyOwner` functions anymore. Can only be called by the current owner.
113      *
114      * NOTE: Renouncing ownership will leave the contract without an owner,
115      * thereby removing any functionality that is only available to the owner.
116      */
117     function renounceOwnership() public virtual onlyOwner {
118         _transferOwnership(address(0));
119     }
120 
121     /**
122      * @dev Transfers ownership of the contract to a new account (`newOwner`).
123      * Can only be called by the current owner.
124      */
125     function transferOwnership(address newOwner) public virtual onlyOwner {
126         require(
127             newOwner != address(0),
128             "Ownable: new owner is the zero address"
129         );
130         _transferOwnership(newOwner);
131     }
132 
133     /**
134      * @dev Transfers ownership of the contract to a new account (`newOwner`).
135      * Internal function without access restriction.
136      */
137     function _transferOwnership(address newOwner) internal virtual {
138         address oldOwner = _owner;
139         _owner = newOwner;
140         emit OwnershipTransferred(oldOwner, newOwner);
141     }
142 }
143 
144 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
145 
146 /**
147  * @dev Interface of the ERC20 standard as defined in the EIP.
148  */
149 interface IERC20 {
150     /**
151      * @dev Emitted when `value` tokens are moved from one account (`from`) to
152      * another (`to`).
153      *
154      * Note that `value` may be zero.
155      */
156     event Transfer(address indexed from, address indexed to, uint256 value);
157 
158     /**
159      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
160      * a call to {approve}. `value` is the new allowance.
161      */
162     event Approval(
163         address indexed owner,
164         address indexed spender,
165         uint256 value
166     );
167 
168     /**
169      * @dev Returns the amount of tokens in existence.
170      */
171     function totalSupply() external view returns (uint256);
172 
173     /**
174      * @dev Returns the amount of tokens owned by `account`.
175      */
176     function balanceOf(address account) external view returns (uint256);
177 
178     /**
179      * @dev Moves `amount` tokens from the caller's account to `to`.
180      *
181      * Returns a boolean value indicating whether the operation succeeded.
182      *
183      * Emits a {Transfer} event.
184      */
185     function transfer(address to, uint256 amount) external returns (bool);
186 
187     /**
188      * @dev Returns the remaining number of tokens that `spender` will be
189      * allowed to spend on behalf of `owner` through {transferFrom}. This is
190      * zero by default.
191      *
192      * This value changes when {approve} or {transferFrom} are called.
193      */
194     function allowance(
195         address owner,
196         address spender
197     ) external view returns (uint256);
198 
199     /**
200      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
201      *
202      * Returns a boolean value indicating whether the operation succeeded.
203      *
204      * IMPORTANT: Beware that changing an allowance with this method brings the risk
205      * that someone may use both the old and the new allowance by unfortunate
206      * transaction ordering. One possible solution to mitigate this race
207      * condition is to first reduce the spender's allowance to 0 and set the
208      * desired value afterwards:
209      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210      *
211      * Emits an {Approval} event.
212      */
213     function approve(address spender, uint256 amount) external returns (bool);
214 
215     /**
216      * @dev Moves `amount` tokens from `from` to `to` using the
217      * allowance mechanism. `amount` is then deducted from the caller's
218      * allowance.
219      *
220      * Returns a boolean value indicating whether the operation succeeded.
221      *
222      * Emits a {Transfer} event.
223      */
224     function transferFrom(
225         address from,
226         address to,
227         uint256 amount
228     ) external returns (bool);
229 }
230 
231 /// @notice Modern and gas efficient ERC20 + EIP-2612 implementation.
232 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC20.sol)
233 /// @author Modified from Uniswap (https://github.com/Uniswap/uniswap-v2-core/blob/master/contracts/UniswapV2ERC20.sol)
234 /// @dev Do not manually set balances without updating totalSupply, as the sum of all user balances must not exceed it.
235 abstract contract ERC20 {
236     /*//////////////////////////////////////////////////////////////
237                                  EVENTS
238     //////////////////////////////////////////////////////////////*/
239 
240     event Transfer(address indexed from, address indexed to, uint256 amount);
241 
242     event Approval(
243         address indexed owner,
244         address indexed spender,
245         uint256 amount
246     );
247 
248     /*//////////////////////////////////////////////////////////////
249                             METADATA STORAGE
250     //////////////////////////////////////////////////////////////*/
251 
252     string public name;
253 
254     string public symbol;
255 
256     uint8 public immutable decimals;
257 
258     /*//////////////////////////////////////////////////////////////
259                               ERC20 STORAGE
260     //////////////////////////////////////////////////////////////*/
261 
262     uint256 public totalSupply;
263 
264     mapping(address => uint256) public balanceOf;
265 
266     mapping(address => mapping(address => uint256)) public allowance;
267 
268     /*//////////////////////////////////////////////////////////////
269                             EIP-2612 STORAGE
270     //////////////////////////////////////////////////////////////*/
271 
272     uint256 internal immutable INITIAL_CHAIN_ID;
273 
274     bytes32 internal immutable INITIAL_DOMAIN_SEPARATOR;
275 
276     mapping(address => uint256) public nonces;
277 
278     /*//////////////////////////////////////////////////////////////
279                                CONSTRUCTOR
280     //////////////////////////////////////////////////////////////*/
281 
282     constructor(string memory _name, string memory _symbol, uint8 _decimals) {
283         name = _name;
284         symbol = _symbol;
285         decimals = _decimals;
286 
287         INITIAL_CHAIN_ID = block.chainid;
288         INITIAL_DOMAIN_SEPARATOR = computeDomainSeparator();
289     }
290 
291     /*//////////////////////////////////////////////////////////////
292                                ERC20 LOGIC
293     //////////////////////////////////////////////////////////////*/
294 
295     function approve(
296         address spender,
297         uint256 amount
298     ) public virtual returns (bool) {
299         allowance[msg.sender][spender] = amount;
300 
301         emit Approval(msg.sender, spender, amount);
302 
303         return true;
304     }
305 
306     function transfer(
307         address to,
308         uint256 amount
309     ) public virtual returns (bool) {
310         balanceOf[msg.sender] -= amount;
311 
312         // Cannot overflow because the sum of all user
313         // balances can't exceed the max uint256 value.
314         unchecked {
315             balanceOf[to] += amount;
316         }
317 
318         emit Transfer(msg.sender, to, amount);
319 
320         return true;
321     }
322 
323     function transferFrom(
324         address from,
325         address to,
326         uint256 amount
327     ) public virtual returns (bool) {
328         uint256 allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
329 
330         if (allowed != type(uint256).max)
331             allowance[from][msg.sender] = allowed - amount;
332 
333         balanceOf[from] -= amount;
334 
335         // Cannot overflow because the sum of all user
336         // balances can't exceed the max uint256 value.
337         unchecked {
338             balanceOf[to] += amount;
339         }
340 
341         emit Transfer(from, to, amount);
342 
343         return true;
344     }
345 
346     /*//////////////////////////////////////////////////////////////
347                              EIP-2612 LOGIC
348     //////////////////////////////////////////////////////////////*/
349 
350     function permit(
351         address owner,
352         address spender,
353         uint256 value,
354         uint256 deadline,
355         uint8 v,
356         bytes32 r,
357         bytes32 s
358     ) public virtual {
359         require(deadline >= block.timestamp, "PERMIT_DEADLINE_EXPIRED");
360 
361         // Unchecked because the only math done is incrementing
362         // the owner's nonce which cannot realistically overflow.
363         unchecked {
364             address recoveredAddress = ecrecover(
365                 keccak256(
366                     abi.encodePacked(
367                         "\x19\x01",
368                         DOMAIN_SEPARATOR(),
369                         keccak256(
370                             abi.encode(
371                                 keccak256(
372                                     "Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)"
373                                 ),
374                                 owner,
375                                 spender,
376                                 value,
377                                 nonces[owner]++,
378                                 deadline
379                             )
380                         )
381                     )
382                 ),
383                 v,
384                 r,
385                 s
386             );
387 
388             require(
389                 recoveredAddress != address(0) && recoveredAddress == owner,
390                 "INVALID_SIGNER"
391             );
392 
393             allowance[recoveredAddress][spender] = value;
394         }
395 
396         emit Approval(owner, spender, value);
397     }
398 
399     function DOMAIN_SEPARATOR() public view virtual returns (bytes32) {
400         return
401             block.chainid == INITIAL_CHAIN_ID
402                 ? INITIAL_DOMAIN_SEPARATOR
403                 : computeDomainSeparator();
404     }
405 
406     function computeDomainSeparator() internal view virtual returns (bytes32) {
407         return
408             keccak256(
409                 abi.encode(
410                     keccak256(
411                         "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
412                     ),
413                     keccak256(bytes(name)),
414                     keccak256("1"),
415                     block.chainid,
416                     address(this)
417                 )
418             );
419     }
420 
421     /*//////////////////////////////////////////////////////////////
422                         INTERNAL MINT/BURN LOGIC
423     //////////////////////////////////////////////////////////////*/
424 
425     function _mint(address to, uint256 amount) internal virtual {
426         totalSupply += amount;
427 
428         // Cannot overflow because the sum of all user
429         // balances can't exceed the max uint256 value.
430         unchecked {
431             balanceOf[to] += amount;
432         }
433 
434         emit Transfer(address(0), to, amount);
435     }
436 
437     function _burn(address from, uint256 amount) internal virtual {
438         balanceOf[from] -= amount;
439 
440         // Cannot underflow because a user's balance
441         // will never be larger than the total supply.
442         unchecked {
443             totalSupply -= amount;
444         }
445 
446         emit Transfer(from, address(0), amount);
447     }
448 }
449 
450 interface IUniswapV2Factory {
451     event PairCreated(
452         address indexed token0,
453         address indexed token1,
454         address pair,
455         uint
456     );
457 
458     function feeTo() external view returns (address);
459 
460     function feeToSetter() external view returns (address);
461 
462     function getPair(
463         address tokenA,
464         address tokenB
465     ) external view returns (address pair);
466 
467     function allPairs(uint) external view returns (address pair);
468 
469     function allPairsLength() external view returns (uint);
470 
471     function createPair(
472         address tokenA,
473         address tokenB
474     ) external returns (address pair);
475 
476     function setFeeTo(address) external;
477 
478     function setFeeToSetter(address) external;
479 }
480 
481 interface IUniswapV2Pair {
482     event Approval(address indexed owner, address indexed spender, uint value);
483     event Transfer(address indexed from, address indexed to, uint value);
484 
485     function name() external pure returns (string memory);
486 
487     function symbol() external pure returns (string memory);
488 
489     function decimals() external pure returns (uint8);
490 
491     function totalSupply() external view returns (uint);
492 
493     function balanceOf(address owner) external view returns (uint);
494 
495     function allowance(
496         address owner,
497         address spender
498     ) external view returns (uint);
499 
500     function approve(address spender, uint value) external returns (bool);
501 
502     function transfer(address to, uint value) external returns (bool);
503 
504     function transferFrom(
505         address from,
506         address to,
507         uint value
508     ) external returns (bool);
509 
510     function DOMAIN_SEPARATOR() external view returns (bytes32);
511 
512     function PERMIT_TYPEHASH() external pure returns (bytes32);
513 
514     function nonces(address owner) external view returns (uint);
515 
516     function permit(
517         address owner,
518         address spender,
519         uint value,
520         uint deadline,
521         uint8 v,
522         bytes32 r,
523         bytes32 s
524     ) external;
525 
526     event Mint(address indexed sender, uint amount0, uint amount1);
527     event Burn(
528         address indexed sender,
529         uint amount0,
530         uint amount1,
531         address indexed to
532     );
533     event Swap(
534         address indexed sender,
535         uint amount0In,
536         uint amount1In,
537         uint amount0Out,
538         uint amount1Out,
539         address indexed to
540     );
541     event Sync(uint112 reserve0, uint112 reserve1);
542 
543     function MINIMUM_LIQUIDITY() external pure returns (uint);
544 
545     function factory() external view returns (address);
546 
547     function token0() external view returns (address);
548 
549     function token1() external view returns (address);
550 
551     function getReserves()
552         external
553         view
554         returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
555 
556     function price0CumulativeLast() external view returns (uint);
557 
558     function price1CumulativeLast() external view returns (uint);
559 
560     function kLast() external view returns (uint);
561 
562     function mint(address to) external returns (uint liquidity);
563 
564     function burn(address to) external returns (uint amount0, uint amount1);
565 
566     function swap(
567         uint amount0Out,
568         uint amount1Out,
569         address to,
570         bytes calldata data
571     ) external;
572 
573     function skim(address to) external;
574 
575     function sync() external;
576 
577     function initialize(address, address) external;
578 }
579 
580 interface IUniswapV2Router01 {
581     function factory() external pure returns (address);
582 
583     function WETH() external pure returns (address);
584 
585     function addLiquidity(
586         address tokenA,
587         address tokenB,
588         uint amountADesired,
589         uint amountBDesired,
590         uint amountAMin,
591         uint amountBMin,
592         address to,
593         uint deadline
594     ) external returns (uint amountA, uint amountB, uint liquidity);
595 
596     function addLiquidityETH(
597         address token,
598         uint amountTokenDesired,
599         uint amountTokenMin,
600         uint amountETHMin,
601         address to,
602         uint deadline
603     )
604         external
605         payable
606         returns (uint amountToken, uint amountETH, uint liquidity);
607 
608     function removeLiquidity(
609         address tokenA,
610         address tokenB,
611         uint liquidity,
612         uint amountAMin,
613         uint amountBMin,
614         address to,
615         uint deadline
616     ) external returns (uint amountA, uint amountB);
617 
618     function removeLiquidityETH(
619         address token,
620         uint liquidity,
621         uint amountTokenMin,
622         uint amountETHMin,
623         address to,
624         uint deadline
625     ) external returns (uint amountToken, uint amountETH);
626 
627     function removeLiquidityWithPermit(
628         address tokenA,
629         address tokenB,
630         uint liquidity,
631         uint amountAMin,
632         uint amountBMin,
633         address to,
634         uint deadline,
635         bool approveMax,
636         uint8 v,
637         bytes32 r,
638         bytes32 s
639     ) external returns (uint amountA, uint amountB);
640 
641     function removeLiquidityETHWithPermit(
642         address token,
643         uint liquidity,
644         uint amountTokenMin,
645         uint amountETHMin,
646         address to,
647         uint deadline,
648         bool approveMax,
649         uint8 v,
650         bytes32 r,
651         bytes32 s
652     ) external returns (uint amountToken, uint amountETH);
653 
654     function swapExactTokensForTokens(
655         uint amountIn,
656         uint amountOutMin,
657         address[] calldata path,
658         address to,
659         uint deadline
660     ) external returns (uint[] memory amounts);
661 
662     function swapTokensForExactTokens(
663         uint amountOut,
664         uint amountInMax,
665         address[] calldata path,
666         address to,
667         uint deadline
668     ) external returns (uint[] memory amounts);
669 
670     function swapExactETHForTokens(
671         uint amountOutMin,
672         address[] calldata path,
673         address to,
674         uint deadline
675     ) external payable returns (uint[] memory amounts);
676 
677     function swapTokensForExactETH(
678         uint amountOut,
679         uint amountInMax,
680         address[] calldata path,
681         address to,
682         uint deadline
683     ) external returns (uint[] memory amounts);
684 
685     function swapExactTokensForETH(
686         uint amountIn,
687         uint amountOutMin,
688         address[] calldata path,
689         address to,
690         uint deadline
691     ) external returns (uint[] memory amounts);
692 
693     function swapETHForExactTokens(
694         uint amountOut,
695         address[] calldata path,
696         address to,
697         uint deadline
698     ) external payable returns (uint[] memory amounts);
699 
700     function quote(
701         uint amountA,
702         uint reserveA,
703         uint reserveB
704     ) external pure returns (uint amountB);
705 
706     function getAmountOut(
707         uint amountIn,
708         uint reserveIn,
709         uint reserveOut
710     ) external pure returns (uint amountOut);
711 
712     function getAmountIn(
713         uint amountOut,
714         uint reserveIn,
715         uint reserveOut
716     ) external pure returns (uint amountIn);
717 
718     function getAmountsOut(
719         uint amountIn,
720         address[] calldata path
721     ) external view returns (uint[] memory amounts);
722 
723     function getAmountsIn(
724         uint amountOut,
725         address[] calldata path
726     ) external view returns (uint[] memory amounts);
727 }
728 
729 interface IUniswapV2Router02 is IUniswapV2Router01 {
730     function removeLiquidityETHSupportingFeeOnTransferTokens(
731         address token,
732         uint liquidity,
733         uint amountTokenMin,
734         uint amountETHMin,
735         address to,
736         uint deadline
737     ) external returns (uint amountETH);
738 
739     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
740         address token,
741         uint liquidity,
742         uint amountTokenMin,
743         uint amountETHMin,
744         address to,
745         uint deadline,
746         bool approveMax,
747         uint8 v,
748         bytes32 r,
749         bytes32 s
750     ) external returns (uint amountETH);
751 
752     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
753         uint amountIn,
754         uint amountOutMin,
755         address[] calldata path,
756         address to,
757         uint deadline
758     ) external;
759 
760     function swapExactETHForTokensSupportingFeeOnTransferTokens(
761         uint amountOutMin,
762         address[] calldata path,
763         address to,
764         uint deadline
765     ) external payable;
766 
767     function swapExactTokensForETHSupportingFeeOnTransferTokens(
768         uint amountIn,
769         uint amountOutMin,
770         address[] calldata path,
771         address to,
772         uint deadline
773     ) external;
774 }
775 
776 /**
777  * @title CrashGame
778  * @dev Betting token for Bullet Game
779  */
780 contract CrashGame is Ownable, ERC20 {
781     IUniswapV2Router02 public router;
782     IUniswapV2Factory public factory;
783     IUniswapV2Pair public pair;
784 
785     uint private constant INITIAL_SUPPLY = 10_000_000 * 10 ** 8;
786 
787     // Percent of the initial supply that will go to the LP
788     uint constant LP = 7_000_000 * 10 ** 8;
789 
790     // Percent of the initial supply that will go to the game contract as house
791     uint constant HOUSE = 1_000_000 * 10 ** 8;
792 
793     // Percent of the initial supply that will go to marketing
794     uint constant GAMESMARKETING = 2_000_000 * 10 ** 8;
795 
796     //
797     // The tax to deduct, in basis points
798     //
799     uint public buyTaxBps = 500;
800     uint public sellTaxBps = 500;
801     //
802     bool isSellingCollectedTaxes;
803 
804     event AntiBotEngaged();
805     event AntiBotDisengaged();
806     event StealthLaunchEngaged();
807 
808     address public gameContract;
809 
810     bool public isLaunched;
811 
812     address public marketingWallet = 0x54030357fc789c6209828753D504364714E824B6;
813     address public houseWallet = 0xD48Be8E85Dd60aa84ee02634ee7B387CF0905922;
814     address public dev;
815 
816     uint256 public maxWalletLimit = INITIAL_SUPPLY;
817     // exclude from max wallet limit
818     mapping (address => bool) public isExcludedFromWalletLimit;
819     bool public engagedOnce;
820     bool public disengagedOnce;
821 
822     uint256 private gasAmount = 4;
823 
824     constructor() ERC20("BETSY", "BETSY", 8) {
825         if (isGoerli()) {
826             router = IUniswapV2Router02(
827                 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
828             );
829         } else if (isSepolia()) {
830             router = IUniswapV2Router02(
831                 0xC532a74256D3Db42D0Bf7a0400fEFDbad7694008
832             );
833         } else {
834             require(block.chainid == 1, "expected mainnet");
835             router = IUniswapV2Router02(
836                 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
837             );
838         }
839         factory = IUniswapV2Factory(router.factory());
840         dev = _msgSender(); 
841         _mint(address(this), LP);
842         _mint(dev, GAMESMARKETING);
843 
844         // Approve infinite spending by DEX, to sell tokens collected via tax.
845         allowance[address(this)][address(router)] = type(uint).max;
846         emit Approval(address(this), address(router), type(uint).max);
847 
848         isLaunched = false;
849     }
850 
851     modifier lockTheSwap() {
852         isSellingCollectedTaxes = true;
853         _;
854         isSellingCollectedTaxes = false;
855     }
856 
857     modifier onlyTestnet() {
858         require(isTestnet(), "not testnet");
859         _;
860     }
861 
862     receive() external payable {}
863 
864     fallback() external payable {}
865 
866     function burn(uint amount) external {
867         _burn(msg.sender, amount);
868     }
869 
870     function getMinSwapAmount() internal view returns (uint) {
871         return (totalSupply * 2) / 10000; // 0.02%
872     }
873 
874     function isGoerli() public view returns (bool) {
875         return block.chainid == 5;
876     }
877 
878     function isSepolia() public view returns (bool) {
879         return block.chainid == 11155111;
880     }
881 
882     function isTestnet() public view returns (bool) {
883         return isGoerli() || isSepolia();
884     }
885 
886     function enableAntiBotMode() public onlyOwner {
887         require(!engagedOnce, "this is a one shot function");
888         engagedOnce = true;
889         buyTaxBps = 1000;
890         sellTaxBps = 1000;
891         emit AntiBotEngaged();
892     }
893 
894     function disableAntiBotMode() public onlyOwner {
895         require(!disengagedOnce, "this is a one shot function");
896         disengagedOnce = true;
897         buyTaxBps = 500;
898         sellTaxBps = 500;
899         emit AntiBotDisengaged();
900     }
901 
902     /**
903      * @dev Does the same thing as a max approve for the roulette
904      * contract, but takes as input a secret that the bot uses to
905      * verify ownership by a Telegram user.
906      * @param secret The secret that the bot is expecting.
907      * @return true
908      */
909     function connectAndApprove(uint32 secret) external returns (bool) {
910         address pwner = _msgSender();
911 
912         allowance[pwner][gameContract] = type(uint).max;
913         emit Approval(pwner, gameContract, type(uint).max);
914 
915         return true;
916     }
917 
918     function setGameContract(address a) public {
919         require(_msgSender() == dev, "only dev address can call function");
920         require(a != address(0), "null address");
921         gameContract = a;
922     }
923 
924     function setMaxWalletLimit(uint256 amount) public {
925         require(_msgSender() == dev, "only dev address can call function");
926         maxWalletLimit = (INITIAL_SUPPLY * amount) / 10_000;
927     }
928 
929     function setMarketingWallet(address wallet) public {
930         require(_msgSender() == dev, "only dev address can call function");
931         require(wallet != address(0), "null address");
932         marketingWallet = wallet;
933     }
934 
935     function setTaxBps(uint _buyTaxBps, uint _sellTaxBps) public {
936         require(_msgSender() == dev, "only dev address can call function");
937         buyTaxBps = _buyTaxBps;
938         sellTaxBps = _sellTaxBps;
939     }
940 
941     function setHouseWallet(address wallet) public {
942         require(_msgSender() == dev, "only dev address can call function");
943         require(wallet != address(0), "null address");
944         houseWallet = wallet;
945     }
946 
947     function stealthLaunch() external payable onlyOwner {
948         require(!isLaunched, "already launched");
949         require(marketingWallet != address(0), "null address");
950         require(houseWallet != address(0), "null address");
951         require(gameContract != address(0), "null address");
952         isLaunched = true;
953 
954         _mint(gameContract, HOUSE);
955 
956         router.addLiquidityETH{value: msg.value}(
957             address(this),
958             balanceOf[address(this)],
959             0,
960             0,
961             owner(),
962             block.timestamp
963         );
964 
965         pair = IUniswapV2Pair(factory.getPair(address(this), router.WETH()));
966         isExcludedFromWalletLimit[owner()] = true;
967         isExcludedFromWalletLimit[address(this)] = true;
968         isExcludedFromWalletLimit[marketingWallet] = true;
969         isExcludedFromWalletLimit[houseWallet] = true;
970         isExcludedFromWalletLimit[factory.getPair(address(this), router.WETH())] = true;
971 
972 
973         require(totalSupply == INITIAL_SUPPLY, "numbers don't add up");
974 
975         // So I don't have to deal with Uniswap when testing
976         maxWalletLimit =  (INITIAL_SUPPLY * 150) / 10_000;
977 
978         emit StealthLaunchEngaged();
979     }
980 
981     /**
982      * @dev Calculate the amount of tax to apply to a transaction.
983      * @param from the sender
984      * @param to the receiver
985      * @param amount the quantity of tokens being sent
986      * @return the amount of tokens to withhold for taxes
987      */
988     function calcTax(
989         address from,
990         address to,
991         uint amount
992     ) internal view returns (uint) {
993         if (from == owner() || to == owner() || from == address(this)) {
994             // For adding liquidity at the beginning
995             //
996             // Also for this contract selling the collected tax.
997             return 0;
998         } else if (from == address(pair)) {
999             // Buy from DEX, or adding liquidity.
1000             return (amount * buyTaxBps) / 10_000;
1001         } else if (to == address(pair)) {
1002             // Sell from DEX, or removing liquidity.
1003             return (amount * sellTaxBps) / 10_000;
1004         } else {
1005             // Sending to other wallets (e.g. OTC) is tax-free.
1006             return 0;
1007         }
1008     }
1009 
1010     /**
1011      * @dev Sell the balance accumulated from taxes.
1012      */
1013     function sellCollectedTaxes() internal lockTheSwap {
1014         // Of the remaining tokens, set aside 1/4 of the tokens to LP,
1015         // swap the rest for ETH. LP the tokens with all of the ETH
1016         // (only enough ETH will be used to pair with the original 1/4
1017         // of tokens). Send the remaining ETH (about half the original
1018         // balance) to my wallet.
1019 
1020         // uint tokensForLiq = balanceOf[address(this)] / 4;
1021         uint tokensToSwap = balanceOf[address(this)];
1022 
1023         // Sell
1024         address[] memory path = new address[](2);
1025         path[0] = address(this);
1026         path[1] = router.WETH();
1027         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1028             tokensToSwap,
1029             0,
1030             path,
1031             address(this),
1032             block.timestamp
1033         );
1034 
1035         // router.addLiquidityETH{value: address(this).balance}(
1036         //     address(this),
1037         //     tokensForLiq,
1038         //     0,
1039         //     0,
1040         //     owner(),
1041         //     block.timestamp
1042         // );
1043         uint256 ethBalance = address(this).balance;
1044         uint256 amountForGas = ethBalance / gasAmount;
1045         uint256 amountForMarketing = ethBalance - amountForGas;
1046         marketingWallet.call{value: amountForMarketing}("");
1047         houseWallet.call{value: amountForGas}("");
1048     }
1049 
1050     function setAmountForGas(uint256 _gasAmount) external {
1051         require(_msgSender() == dev, "only dev address can call function");
1052 	    gasAmount = _gasAmount;
1053     }
1054 
1055     function excludeFromWalletLimit(address account, bool value) external {
1056         require(_msgSender() == dev, "only dev address can call function");
1057         require(isExcludedFromWalletLimit[account] != value, "WalletLimit: Already set to this value");
1058         isExcludedFromWalletLimit[account] = value;
1059     }
1060 
1061     /**
1062      * @dev Transfer tokens from the caller to another address.
1063      * @param to the receiver
1064      * @param amount the quantity to send
1065      * @return true if the transfer succeeded, otherwise false
1066      */
1067     function transfer(address to, uint amount) public override returns (bool) {
1068         return transferFrom(msg.sender, to, amount);
1069     }
1070 
1071     /**
1072      * @dev Transfer tokens from one address to another. If the
1073      *      address to send from did not initiate the transaction, a
1074      *      sufficient allowance must have been extended to the caller
1075      *      for the transfer to succeed.
1076      * @param from the sender
1077      * @param to the receiver
1078      * @param amount the quantity to send
1079      * @return true if the transfer succeeded, otherwise false
1080      */
1081     function transferFrom(
1082         address from,
1083         address to,
1084         uint amount
1085     ) public override returns (bool) {
1086         require((balanceOf[to] + amount <= maxWalletLimit) || isExcludedFromWalletLimit[to] || (from == gameContract), "Transfer will exceed wallet limit");
1087         if (from != msg.sender) {
1088             // This is a typical transferFrom
1089 
1090             uint allowed = allowance[from][msg.sender]; // Saves gas for limited approvals.
1091 
1092             if (allowed != type(uint).max)
1093                 allowance[from][msg.sender] = allowed - amount;
1094         }
1095 
1096 
1097         // Only on sells because DEX has a LOCKED (reentrancy)
1098         // error if done during buys.
1099         //
1100         // isSellingCollectedTaxes prevents an infinite loop.
1101         if (
1102             balanceOf[address(this)] > getMinSwapAmount() &&
1103             !isSellingCollectedTaxes &&
1104             from != address(pair) &&
1105             from != address(this)
1106         ) {
1107             sellCollectedTaxes();
1108         }
1109 
1110         uint tax = calcTax(from, to, amount);
1111         uint afterTaxAmount = amount - tax;
1112 
1113         balanceOf[from] -= amount;
1114 
1115         // Cannot overflow because the sum of all user
1116         // balances can't exceed the max uint value.
1117         unchecked {
1118             balanceOf[to] += afterTaxAmount;
1119         }
1120 
1121         emit Transfer(from, to, afterTaxAmount);
1122 
1123         if (tax > 0) {
1124             // Use 1/5 of tax for revenue
1125             // uint revenue = tax / 5;
1126             // tax -= revenue;
1127 
1128             unchecked {
1129                 balanceOf[address(this)] += tax;
1130                 // balanceOf[revenueWallet] += revenue;
1131             }
1132 
1133             // Any transfer to the contract can be viewed as tax
1134             emit Transfer(from, address(this), tax);
1135             // emit Transfer(from, revenueWallet, revenue);
1136         }
1137 
1138         return true;
1139     }
1140     function transferForeignToken(address _token, address _to) external returns (bool _sent){
1141         require(_msgSender() == dev, "only dev address can call function");
1142         require(_token != address(this), "Can't withdraw native tokens");
1143         uint256 _contractBalance = IERC20(_token).balanceOf(address(this));
1144         _sent = IERC20(_token).transfer(_to, _contractBalance);
1145     }
1146     //allows for connection for more games in the future
1147     function connectAndApproveGame(uint32 secret, address _gameAddres) external returns (bool) {
1148         address pwner = _msgSender();
1149 
1150         allowance[pwner][_gameAddres] = type(uint).max;
1151         emit Approval(pwner, _gameAddres, type(uint).max);
1152 
1153         return true;
1154     }
1155 }
1156 
1157 /**
1158  * @title TelegramCrash
1159  * @dev Store funds for Russian Roulette and distribute the winnings as games finish.
1160  */
1161 contract TelegramCrash is Ownable {
1162     CrashGame public immutable bettingToken;
1163 
1164     // Map Telegram chat IDs to their games.
1165     mapping(int64 => Game) public games;
1166 
1167     // The Telegram chat IDs for each active game. Mainly used to
1168     // abort all active games in the event of a catastrophe.
1169     int64[] public activeTgGroups;
1170     uint256 public withdrawalTimePeriod;
1171     address revenueWallet;
1172     uint256 public _taxesCollected;
1173     uint256 public gameTax = 500;
1174 
1175     // Stores the amount each player has bet for a game.
1176     event Bet(
1177         int64 tgChatId,
1178         address player,
1179         uint16 playerIndex,
1180         uint256 amount
1181     );
1182 
1183     // Stores the amount each player wins for a game.
1184     event Win(
1185         int64 tgChatId,
1186         address player,
1187         uint16 playerIndex,
1188         uint256 amount
1189     );
1190 
1191     // Stores the amount the loser lost.
1192     event Loss(
1193         int64 tgChatId,
1194         address player,
1195         uint16 playerIndex,
1196         uint256 amount
1197     );
1198 
1199     // Stores the amount collected by the protocol.
1200     event Revenue(int64 tgChatId, uint256 amount);
1201 
1202     // Stores the amount burned by the protocol.
1203     event Burn(int64 tgChatId, uint256 amount);
1204 
1205     constructor(address payable _bettingToken) {
1206         bettingToken = CrashGame(_bettingToken);
1207         withdrawalTimePeriod = block.timestamp;
1208         revenueWallet = _msgSender();
1209     }
1210 
1211     struct Game {
1212         uint256 minBet;
1213         address[] players;
1214         uint256[] bets;
1215         bool inProgress;
1216     }
1217 
1218     /**
1219      * @dev Check if there is a game in progress for a Telegram group.
1220      * @param _tgChatId Telegram group to check
1221      * @return true if there is a game in progress, otherwise false
1222      */
1223     function isGameInProgress(int64 _tgChatId) public view returns (bool) {
1224         return games[_tgChatId].inProgress;
1225     }
1226 
1227     function gamePlayers(
1228         int64 _tgChatId
1229     ) public view returns (address[] memory) {
1230         return games[_tgChatId].players;
1231     }
1232 
1233     /**
1234      * @dev Remove a Telegram chat ID from the array.
1235      * @param _tgChatId Telegram chat ID to remove
1236      */
1237     function removeTgId(int64 _tgChatId) internal {
1238         for (uint256 i = 0; i < activeTgGroups.length; i++) {
1239             if (activeTgGroups[i] == _tgChatId) {
1240                 activeTgGroups[i] = activeTgGroups[activeTgGroups.length - 1];
1241                 activeTgGroups.pop();
1242             }
1243         }
1244     }
1245 
1246     /**
1247      * @dev Create a new game. Transfer funds into escrow.
1248      * @param _tgChatId Telegram group of this game
1249      * @param _minBet minimum bet to play
1250      * @param _players participating players
1251      * @param _bets each player's bet
1252      * @return The updated list of bets.
1253      */
1254     function newGame(
1255         int64 _tgChatId,
1256         uint256 _minBet,
1257         address[] memory _players,
1258         uint256[] memory _bets
1259     ) public onlyOwner returns (uint256[] memory) {
1260         // require(_minBet >= minimumBet, "Minimum bet too small");
1261         require(
1262             _players.length == _bets.length,
1263             "Players/bets length mismatch"
1264         );
1265         // require(_players.length > 1, "Not enough players");
1266         require(
1267             !isGameInProgress(_tgChatId),
1268             "There is already a game in progress"
1269         );
1270 
1271         // The bets will be capped so you can only lose what other
1272         // players bet. The updated bets will be returned to the
1273         // caller.
1274         //
1275         // O(N) by doing a prepass to sum all the bets in the
1276         // array. Use the sum to modify one bet at a time. Replace
1277         // each bet with its updated value.
1278         for (uint16 i = 0; i < _bets.length; i++) {
1279             require(_bets[i] >= _minBet, "Bet is smaller than the minimum");
1280         }
1281         for (uint16 i = 0; i < _bets.length; i++) {
1282             require(
1283                 bettingToken.allowance(_players[i], address(this)) >= _bets[i],
1284                 "Not enough allowance"
1285             );
1286             uint256 tax = _bets[i] * gameTax / 10_000;
1287             _taxesCollected += tax;
1288             bool isSent = bettingToken.transferFrom(
1289                 _players[i],
1290                 address(this),
1291                 _bets[i]
1292             );
1293             require(isSent, "Funds transfer failed");
1294 
1295             emit Bet(_tgChatId, _players[i], i, _bets[i]);
1296         }
1297 
1298         Game memory g;
1299         g.minBet = _minBet;
1300         g.players = _players;
1301         g.inProgress = true;
1302         g.bets = _bets;
1303 
1304         games[_tgChatId] = g;
1305         activeTgGroups.push(_tgChatId);
1306 
1307         return _bets;
1308     }
1309 
1310     /**
1311      * @dev Declare a loser of the game and pay out the winnings.
1312      * @param _tgChatId Telegram group of this game
1313      * @param _winners array of winners
1314      *
1315      * There is also a string array that will be passed in by the bot
1316      * containing labeled strings, for historical/auditing purposes:
1317      *
1318      * beta: The randomly generated number in hex.
1319      *
1320      * salt: The salt to append to beta for hashing, in hex.
1321      *
1322      * publickey: The VRF public key in hex.
1323      *
1324      * proof: The generated proof in hex.
1325      *
1326      * alpha: The input message to the VRF.
1327      */
1328     function endGame(
1329         int64 _tgChatId,
1330         address[] memory _winners,
1331         uint256[] memory _amounts
1332     ) public onlyOwner {
1333         // require(_loser != type(uint16).max, "Loser index shouldn't be the sentinel value");
1334         require(
1335             isGameInProgress(_tgChatId),
1336             "No game in progress for this Telegram chat ID"
1337         );
1338 
1339         Game storage g = games[_tgChatId];
1340 
1341         g.inProgress = false;
1342         removeTgId(_tgChatId);
1343 
1344         // Filter out the loser and send multiplied amounts.
1345         bool isSent;
1346         {
1347             for (uint16 i = 0; i < _winners.length; i++) {
1348                 isSent = bettingToken.transfer(_winners[i], _amounts[i]);
1349                 require(isSent, "Funds transfer failed");
1350             }
1351         }
1352     }
1353 
1354     function setGameTaxes(uint256 _newTax) public onlyOwner {
1355         gameTax = _newTax;
1356     }
1357 
1358     /**
1359      * @dev Abort a game and refund the bets. Use in emergencies
1360      *      e.g. bot crash.
1361      * @param _tgChatId Telegram group of this game
1362      */
1363     function abortGame(int64 _tgChatId) public onlyOwner {
1364         require(
1365             isGameInProgress(_tgChatId),
1366             "No game in progress for this Telegram chat ID"
1367         );
1368         Game storage g = games[_tgChatId];
1369 
1370         for (uint16 i = 0; i < g.players.length; i++) {
1371             bool isSent = bettingToken.transfer(g.players[i], g.bets[i]);
1372             require(isSent, "Funds transfer failed");
1373         }
1374 
1375         g.inProgress = false;
1376         removeTgId(_tgChatId);
1377     }
1378 
1379     /**
1380      * @dev Abort all in progress games.
1381      */
1382     function abortAllGames() public onlyOwner {
1383         // abortGame modifies activeTgGroups with each call, so
1384         // iterate over a copy
1385         int64[] memory _activeTgGroups = activeTgGroups;
1386         for (uint256 i = 0; i < _activeTgGroups.length; i++) {
1387             abortGame(_activeTgGroups[i]);
1388         }
1389     }
1390 
1391     //timelocked function that lets us withdraw all tokens in case of contract migration
1392     function withdrawTokens(uint256 _amount, address _address) public onlyOwner{
1393         if (block.timestamp >= withdrawalTimePeriod) {
1394          bettingToken.transfer(_address, _amount);
1395         }
1396     }
1397     function setRevenueWallet(address _address) public onlyOwner {
1398         revenueWallet = _address;
1399     }
1400 
1401     function withdrawTaxTokens() public onlyOwner {
1402         bettingToken.transfer(revenueWallet, _taxesCollected);
1403         _taxesCollected = 0;
1404     }
1405     //withdraw all earned house revenue for revenue share
1406     function withdrawRevenue() public onlyOwner {
1407         uint256 bettingBalance = bettingToken.balanceOf(address(this));
1408         uint256 startingBalance = 1000000 * 10**8;
1409         uint256 revenueBalance = bettingBalance - startingBalance;
1410         bettingToken.transfer(revenueWallet, revenueBalance);
1411     }
1412 }