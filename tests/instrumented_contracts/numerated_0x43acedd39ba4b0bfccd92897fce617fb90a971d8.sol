1 /**
2  *Submitted for verification at BscScan.com on 2021-07-17
3 */
4 
5 /**
6 //Contract Developed by Snipe.Finance for SafeBTC team
7 
8  $$$$$$\           $$$$$$\         $$$$$$$\                   $$\       
9 $$  __$$\         $$  __$$\        $$  __$$\                  $$ |      
10 $$ /  \__|$$$$$$\ $$ /  \__$$$$$$\ $$ |  $$ |$$$$$$\ $$$$$$$\ $$ |  $$\ 
11 \$$$$$$\  \____$$\$$$$\   $$  __$$\$$$$$$$\ |\____$$\$$  __$$\$$ | $$  |
12  \____$$\ $$$$$$$ $$  _|  $$$$$$$$ $$  __$$\ $$$$$$$ $$ |  $$ $$$$$$  / 
13 $$\   $$ $$  __$$ $$ |    $$   ____$$ |  $$ $$  __$$ $$ |  $$ $$  _$$<  
14 \$$$$$$  \$$$$$$$ $$ |    \$$$$$$$\$$$$$$$  \$$$$$$$ $$ |  $$ $$ | \$$\ 
15  \______/ \_______\__|     \_______\_______/ \_______\__|  \__\__|  \__|
16 
17  */
18 
19 pragma solidity ^0.7.0;
20 
21 /**
22  * @dev Interface of the ERC20 standard as defined in the EIP.
23  */
24 interface IERC20 {
25     /**
26      * @dev Returns the amount of tokens in existence.
27      */
28     function totalSupply() external view returns (uint256);
29 
30     /**
31      * @dev Returns the amount of tokens owned by `account`.
32      */
33     function balanceOf(address account) external view returns (uint256);
34 
35     /**
36      * @dev Moves `amount` tokens from the caller's account to `recipient`.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * Emits a {Transfer} event.
41      */
42     function transfer(address recipient, uint256 amount) external returns (bool);
43 
44     /**
45      * @dev Returns the remaining number of tokens that `spender` will be
46      * allowed to spend on behalf of `owner` through {transferFrom}. This is
47      * zero by default.
48      *
49      * This value changes when {approve} or {transferFrom} are called.
50      */
51     function allowance(address owner, address spender) external view returns (uint256);
52 
53     /**
54      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * IMPORTANT: Beware that changing an allowance with this method brings the risk
59      * that someone may use both the old and the new allowance by unfortunate
60      * transaction ordering. One possible solution to mitigate this race
61      * condition is to first reduce the spender's allowance to 0 and set the
62      * desired value afterwards:
63      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
64      *
65      * Emits an {Approval} event.
66      */
67     function approve(address spender, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Moves `amount` tokens from `sender` to `recipient` using the
71      * allowance mechanism. `amount` is then deducted from the caller's
72      * allowance.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * Emits a {Transfer} event.
77      */
78     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Emitted when `value` tokens are moved from one account (`from`) to
82      * another (`to`).
83      *
84      * Note that `value` may be zero.
85      */
86     event Transfer(address indexed from, address indexed to, uint256 value);
87 
88     /**
89      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
90      * a call to {approve}. `value` is the new allowance.
91      */
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 // File: contracts/Context.sol
96 
97 pragma solidity >=0.6.0 <0.8.0;
98 
99 /*
100  * @dev Provides information about the current execution context, including the
101  * sender of the transaction and its data. While these are generally available
102  * via msg.sender and msg.data, they should not be accessed in such a direct
103  * manner, since when dealing with GSN meta-transactions the account sending and
104  * paying for execution may not be the actual sender (as far as an application
105  * is concerned).
106  *
107  * This contract is only required for intermediate, library-like contracts.
108  */
109 abstract contract Context {
110     function _msgSender() internal view virtual returns (address payable) {
111         return msg.sender;
112     }
113 
114     function _msgData() internal view virtual returns (bytes memory) {
115         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
116         return msg.data;
117     }
118 }
119 
120 // File: contracts/IUniswapV2Router01.sol
121 
122 pragma solidity >=0.6.2;
123 
124 interface IUniswapV2Router01 {
125     function factory() external pure returns (address);
126     function WETH() external pure returns (address);
127 
128     function addLiquidity(
129         address tokenA,
130         address tokenB,
131         uint amountADesired,
132         uint amountBDesired,
133         uint amountAMin,
134         uint amountBMin,
135         address to,
136         uint deadline
137     ) external returns (uint amountA, uint amountB, uint liquidity);
138     function addLiquidityETH(
139         address token,
140         uint amountTokenDesired,
141         uint amountTokenMin,
142         uint amountETHMin,
143         address to,
144         uint deadline
145     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
146     function removeLiquidity(
147         address tokenA,
148         address tokenB,
149         uint liquidity,
150         uint amountAMin,
151         uint amountBMin,
152         address to,
153         uint deadline
154     ) external returns (uint amountA, uint amountB);
155     function removeLiquidityETH(
156         address token,
157         uint liquidity,
158         uint amountTokenMin,
159         uint amountETHMin,
160         address to,
161         uint deadline
162     ) external returns (uint amountToken, uint amountETH);
163     function removeLiquidityWithPermit(
164         address tokenA,
165         address tokenB,
166         uint liquidity,
167         uint amountAMin,
168         uint amountBMin,
169         address to,
170         uint deadline,
171         bool approveMax, uint8 v, bytes32 r, bytes32 s
172     ) external returns (uint amountA, uint amountB);
173     function removeLiquidityETHWithPermit(
174         address token,
175         uint liquidity,
176         uint amountTokenMin,
177         uint amountETHMin,
178         address to,
179         uint deadline,
180         bool approveMax, uint8 v, bytes32 r, bytes32 s
181     ) external returns (uint amountToken, uint amountETH);
182     function swapExactTokensForTokens(
183         uint amountIn,
184         uint amountOutMin,
185         address[] calldata path,
186         address to,
187         uint deadline
188     ) external returns (uint[] memory amounts);
189     function swapTokensForExactTokens(
190         uint amountOut,
191         uint amountInMax,
192         address[] calldata path,
193         address to,
194         uint deadline
195     ) external returns (uint[] memory amounts);
196     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
197         external
198         payable
199         returns (uint[] memory amounts);
200     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
201         external
202         returns (uint[] memory amounts);
203     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
204         external
205         returns (uint[] memory amounts);
206     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
207         external
208         payable
209         returns (uint[] memory amounts);
210 
211     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
212     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
213     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
214     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
215     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
216 }
217 // File: contracts/IUniswapV2Router02.sol
218 
219 pragma solidity >=0.6.2;
220 
221 
222 interface IUniswapV2Router02 is IUniswapV2Router01 {
223     function removeLiquidityETHSupportingFeeOnTransferTokens(
224         address token,
225         uint liquidity,
226         uint amountTokenMin,
227         uint amountETHMin,
228         address to,
229         uint deadline
230     ) external returns (uint amountETH);
231     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
232         address token,
233         uint liquidity,
234         uint amountTokenMin,
235         uint amountETHMin,
236         address to,
237         uint deadline,
238         bool approveMax, uint8 v, bytes32 r, bytes32 s
239     ) external returns (uint amountETH);
240 
241     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
242         uint amountIn,
243         uint amountOutMin,
244         address[] calldata path,
245         address to,
246         uint deadline
247     ) external;
248     function swapExactETHForTokensSupportingFeeOnTransferTokens(
249         uint amountOutMin,
250         address[] calldata path,
251         address to,
252         uint deadline
253     ) external payable;
254     function swapExactTokensForETHSupportingFeeOnTransferTokens(
255         uint amountIn,
256         uint amountOutMin,
257         address[] calldata path,
258         address to,
259         uint deadline
260     ) external;
261 }
262 // File: contracts/IUniswapV2Factory.sol
263 
264 pragma solidity >=0.5.0;
265 
266 interface IUniswapV2Factory {
267     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
268 
269     function feeTo() external view returns (address);
270     function feeToSetter() external view returns (address);
271 
272     function getPair(address tokenA, address tokenB) external view returns (address pair);
273     function allPairs(uint) external view returns (address pair);
274     function allPairsLength() external view returns (uint);
275 
276     function createPair(address tokenA, address tokenB) external returns (address pair);
277 
278     function setFeeTo(address) external;
279     function setFeeToSetter(address) external;
280 }
281 // File: contracts/IUniswapV2Pair.sol
282 
283 pragma solidity >=0.5.0;
284 
285 interface IUniswapV2Pair {
286     event Approval(address indexed owner, address indexed spender, uint value);
287     event Transfer(address indexed from, address indexed to, uint value);
288 
289     function name() external pure returns (string memory);
290     function symbol() external pure returns (string memory);
291     function decimals() external pure returns (uint8);
292     function totalSupply() external view returns (uint);
293     function balanceOf(address owner) external view returns (uint);
294     function allowance(address owner, address spender) external view returns (uint);
295 
296     function approve(address spender, uint value) external returns (bool);
297     function transfer(address to, uint value) external returns (bool);
298     function transferFrom(address from, address to, uint value) external returns (bool);
299 
300     function DOMAIN_SEPARATOR() external view returns (bytes32);
301     function PERMIT_TYPEHASH() external pure returns (bytes32);
302     function nonces(address owner) external view returns (uint);
303 
304     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
305 
306     event Mint(address indexed sender, uint amount0, uint amount1);
307     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
308     event Swap(
309         address indexed sender,
310         uint amount0In,
311         uint amount1In,
312         uint amount0Out,
313         uint amount1Out,
314         address indexed to
315     );
316     event Sync(uint112 reserve0, uint112 reserve1);
317 
318     function MINIMUM_LIQUIDITY() external pure returns (uint);
319     function factory() external view returns (address);
320     function token0() external view returns (address);
321     function token1() external view returns (address);
322     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
323     function price0CumulativeLast() external view returns (uint);
324     function price1CumulativeLast() external view returns (uint);
325     function kLast() external view returns (uint);
326 
327     function mint(address to) external returns (uint liquidity);
328     function burn(address to) external returns (uint amount0, uint amount1);
329     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
330     function skim(address to) external;
331     function sync() external;
332 
333     function initialize(address, address) external;
334 }
335 // File: contracts/IterableMapping.sol
336 
337 // 
338 pragma solidity ^0.7.6;
339 
340 library IterableMapping {
341     // Iterable mapping from address to uint;
342     struct Map {
343         address[] keys;
344         mapping(address => uint) values;
345         mapping(address => uint) indexOf;
346         mapping(address => bool) inserted;
347     }
348 
349     function get(Map storage map, address key) public view returns (uint) {
350         return map.values[key];
351     }
352 
353     function getIndexOfKey(Map storage map, address key) public view returns (int) {
354         if(!map.inserted[key]) {
355             return -1;
356         }
357         return int(map.indexOf[key]);
358     }
359 
360     function getKeyAtIndex(Map storage map, uint index) public view returns (address) {
361         return map.keys[index];
362     }
363 
364 
365 
366     function size(Map storage map) public view returns (uint) {
367         return map.keys.length;
368     }
369 
370     function set(Map storage map, address key, uint val) public {
371         if (map.inserted[key]) {
372             map.values[key] = val;
373         } else {
374             map.inserted[key] = true;
375             map.values[key] = val;
376             map.indexOf[key] = map.keys.length;
377             map.keys.push(key);
378         }
379     }
380 
381     function remove(Map storage map, address key) public {
382         if (!map.inserted[key]) {
383             return;
384         }
385 
386         delete map.inserted[key];
387         delete map.values[key];
388 
389         uint index = map.indexOf[key];
390         uint lastIndex = map.keys.length - 1;
391         address lastKey = map.keys[lastIndex];
392 
393         map.indexOf[lastKey] = index;
394         delete map.indexOf[key];
395 
396         map.keys[index] = lastKey;
397         map.keys.pop();
398     }
399 }
400 // File: contracts/Ownable.sol
401 
402 // 
403 
404 pragma solidity ^0.7.0;
405 
406 /**
407  * @dev Contract module which provides a basic access control mechanism, where
408  * there is an account (an owner) that can be granted exclusive access to
409  * specific functions.
410  *
411  * By default, the owner account will be the one that deploys the contract. This
412  * can later be changed with {transferOwnership}.
413  *
414  * This module is used through inheritance. It will make available the modifier
415  * `onlyOwner`, which can be applied to your functions to restrict their use to
416  * the owner.
417  */
418 abstract contract Ownable is Context {
419     address private _owner;
420 
421     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
422 
423     /**
424      * @dev Initializes the contract setting the deployer as the initial owner.
425      */
426     constructor () {
427         address msgSender = _msgSender();
428         _owner = msgSender;
429         emit OwnershipTransferred(address(0), msgSender);
430     }
431 
432     /**
433      * @dev Returns the address of the current owner.
434      */
435     function owner() public view virtual returns (address) {
436         return _owner;
437     }
438 
439     /**
440      * @dev Throws if called by any account other than the owner.
441      */
442     modifier onlyOwner() {
443         require(owner() == _msgSender(), "Ownable: caller is not the owner");
444         _;
445     }
446 
447     /**
448      * @dev Leaves the contract without owner. It will not be possible to call
449      * `onlyOwner` functions anymore. Can only be called by the current owner.
450      *
451      * NOTE: Renouncing ownership will leave the contract without an owner,
452      * thereby removing any functionality that is only available to the owner.
453      */
454     function renounceOwnership() public virtual onlyOwner {
455         emit OwnershipTransferred(_owner, address(0));
456         _owner = address(0);
457     }
458 
459     /**
460      * @dev Transfers ownership of the contract to a new account (`newOwner`).
461      * Can only be called by the current owner.
462      */
463     function transferOwnership(address newOwner) public virtual onlyOwner {
464         require(newOwner != address(0), "Ownable: new owner is the zero address");
465         emit OwnershipTransferred(_owner, newOwner);
466         _owner = newOwner;
467     }
468 }
469 // File: contracts/IDividendPayingTokenOptional.sol
470 
471 pragma solidity ^0.7.6;
472 
473 
474 /// @title Dividend-Paying Token Optional Interface
475 /// @author Roger Wu (https://github.com/roger-wu)
476 /// @dev OPTIONAL functions for a dividend-paying token contract.
477 interface IDividendPayingTokenOptional {
478   /// @notice View the amount of dividend in wei that an address can withdraw.
479   /// @param _owner The address of a token holder.
480   /// @return The amount of dividend in wei that `_owner` can withdraw.
481   function withdrawableDividendOf(address _owner) external view returns(uint256);
482 
483   /// @notice View the amount of dividend in wei that an address has withdrawn.
484   /// @param _owner The address of a token holder.
485   /// @return The amount of dividend in wei that `_owner` has withdrawn.
486   function withdrawnDividendOf(address _owner) external view returns(uint256);
487 
488   /// @notice View the amount of dividend in wei that an address has earned in total.
489   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
490   /// @param _owner The address of a token holder.
491   /// @return The amount of dividend in wei that `_owner` has earned in total.
492   function accumulativeDividendOf(address _owner) external view returns(uint256);
493 }
494 // File: contracts/IDividendPayingToken.sol
495 
496 pragma solidity ^0.7.6;
497 
498 
499 /// @title Dividend-Paying Token Interface
500 /// @author Roger Wu (https://github.com/roger-wu)
501 /// @dev An interface for a dividend-paying token contract.
502 interface IDividendPayingToken {
503   /// @notice View the amount of dividend in wei that an address can withdraw.
504   /// @param _owner The address of a token holder.
505   /// @return The amount of dividend in wei that `_owner` can withdraw.
506   function dividendOf(address _owner) external view returns(uint256);
507 
508   /// @notice Distributes ether to token holders as dividends.
509   /// @dev SHOULD distribute the paid ether to token holders as dividends.
510   ///  SHOULD NOT directly transfer ether to token holders in this function.
511   ///  MUST emit a `DividendsDistributed` event when the amount of distributed ether is greater than 0.
512   function distributeDividends() external payable;
513 
514   /// @notice Withdraws the ether distributed to the sender.
515   /// @dev SHOULD transfer `dividendOf(msg.sender)` wei to `msg.sender`, and `dividendOf(msg.sender)` SHOULD be 0 after the transfer.
516   ///  MUST emit a `DividendWithdrawn` event if the amount of ether transferred is greater than 0.
517   function withdrawDividend() external;
518 
519   /// @dev This event MUST emit when ether is distributed to token holders.
520   /// @param from The address which sends ether to this contract.
521   /// @param weiAmount The amount of distributed ether in wei.
522   event DividendsDistributed(
523     address indexed from,
524     uint256 weiAmount
525   );
526 
527   /// @dev This event MUST emit when an address withdraws their dividend.
528   /// @param to The address which withdraws ether from this contract.
529   /// @param weiAmount The amount of withdrawn ether in wei.
530   event DividendWithdrawn(
531     address indexed to,
532     uint256 weiAmount,
533     address indexed tokenWithdrawn
534   );
535 }
536 // File: contracts/SafeMathInt.sol
537 
538 pragma solidity ^0.7.6;
539 
540 /**
541  * @title SafeMathInt
542  * @dev Math operations with safety checks that revert on error
543  * @dev SafeMath adapted for int256
544  * Based on code of  https://github.com/RequestNetwork/requestNetwork/blob/master/packages/requestNetworkSmartContracts/contracts/base/math/SafeMathInt.sol
545  */
546 library SafeMathInt {
547   function mul(int256 a, int256 b) internal pure returns (int256) {
548     // Prevent overflow when multiplying INT256_MIN with -1
549     // https://github.com/RequestNetwork/requestNetwork/issues/43
550     require(!(a == - 2**255 && b == -1) && !(b == - 2**255 && a == -1));
551 
552     int256 c = a * b;
553     require((b == 0) || (c / b == a));
554     return c;
555   }
556 
557   function div(int256 a, int256 b) internal pure returns (int256) {
558     // Prevent overflow when dividing INT256_MIN by -1
559     // https://github.com/RequestNetwork/requestNetwork/issues/43
560     require(!(a == - 2**255 && b == -1) && (b > 0));
561 
562     return a / b;
563   }
564 
565   function sub(int256 a, int256 b) internal pure returns (int256) {
566     require((b >= 0 && a - b <= a) || (b < 0 && a - b > a));
567 
568     return a - b;
569   }
570 
571   function add(int256 a, int256 b) internal pure returns (int256) {
572     int256 c = a + b;
573     require((b >= 0 && c >= a) || (b < 0 && c < a));
574     return c;
575   }
576 
577   function toUint256Safe(int256 a) internal pure returns (uint256) {
578     require(a >= 0);
579     return uint256(a);
580   }
581 }
582 // File: contracts/SafeMathUint.sol
583 
584 pragma solidity ^0.7.6;
585 
586 /**
587  * @title SafeMathUint
588  * @dev Math operations with safety checks that revert on error
589  */
590 library SafeMathUint {
591   function toInt256Safe(uint256 a) internal pure returns (int256) {
592     int256 b = int256(a);
593     require(b >= 0);
594     return b;
595   }
596 }
597 
598 // File: contracts/ERC20.sol
599 
600 // 
601 
602 pragma solidity ^0.7.0;
603 
604 
605 
606 
607 /**
608  * @dev Implementation of the {IERC20} interface.
609  *
610  * This implementation is agnostic to the way tokens are created. This means
611  * that a supply mechanism has to be added in a derived contract using {_mint}.
612  * For a generic mechanism see {ERC20PresetMinterPauser}.
613  *
614  * TIP: For a detailed writeup see our guide
615  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
616  * to implement supply mechanisms].
617  *
618  * We have followed general OpenZeppelin guidelines: functions revert instead
619  * of returning `false` on failure. This behavior is nonetheless conventional
620  * and does not conflict with the expectations of ERC20 applications.
621  *
622  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
623  * This allows applications to reconstruct the allowance for all accounts just
624  * by listening to said events. Other implementations of the EIP may not emit
625  * these events, as it isn't required by the specification.
626  *
627  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
628  * functions have been added to mitigate the well-known issues around setting
629  * allowances. See {IERC20-approve}.
630  */
631 contract ERC20 is Context, IERC20 {
632     using SafeMath for uint256;
633 
634     mapping (address => uint256) private _balances;
635 
636     mapping (address => mapping (address => uint256)) private _allowances;
637 
638     uint256 private _totalSupply;
639 
640     string private _name;
641     string private _symbol;
642     uint8 private _decimals;
643 
644     /**
645      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
646      * a default value of 18.
647      *
648      * To select a different value for {decimals}, use {_setupDecimals}.
649      *
650      * All three of these values are immutable: they can only be set once during
651      * construction.
652      */
653     constructor (string memory name_, string memory symbol_) {
654         _name = name_;
655         _symbol = symbol_;
656         _decimals = 9;
657     }
658 
659     /**
660      * @dev Returns the name of the token.
661      */
662     function name() public view virtual returns (string memory) {
663         return _name;
664     }
665 
666     /**
667      * @dev Returns the symbol of the token, usually a shorter version of the
668      * name.
669      */
670     function symbol() public view virtual returns (string memory) {
671         return _symbol;
672     }
673 
674     /**
675      * @dev Returns the number of decimals used to get its user representation.
676      * For example, if `decimals` equals `2`, a balance of `505` tokens should
677      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
678      *
679      * Tokens usually opt for a value of 18, imitating the relationship between
680      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
681      * called.
682      *
683      * NOTE: This information is only used for _display_ purposes: it in
684      * no way affects any of the arithmetic of the contract, including
685      * {IERC20-balanceOf} and {IERC20-transfer}.
686      */
687     function decimals() public view virtual returns (uint8) {
688         return _decimals;
689     }
690 
691     /**
692      * @dev See {IERC20-totalSupply}.
693      */
694     function totalSupply() public view virtual override returns (uint256) {
695         return _totalSupply;
696     }
697 
698     /**
699      * @dev See {IERC20-balanceOf}.
700      */
701     function balanceOf(address account) public view virtual override returns (uint256) {
702         return _balances[account];
703     }
704 
705     /**
706      * @dev See {IERC20-transfer}.
707      *
708      * Requirements:
709      *
710      * - `recipient` cannot be the zero address.
711      * - the caller must have a balance of at least `amount`.
712      */
713     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
714         _transfer(_msgSender(), recipient, amount);
715         return true;
716     }
717 
718     /**
719      * @dev See {IERC20-allowance}.
720      */
721     function allowance(address owner, address spender) public view virtual override returns (uint256) {
722         return _allowances[owner][spender];
723     }
724 
725     /**
726      * @dev See {IERC20-approve}.
727      *
728      * Requirements:
729      *
730      * - `spender` cannot be the zero address.
731      */
732     function approve(address spender, uint256 amount) public virtual override returns (bool) {
733         _approve(_msgSender(), spender, amount);
734         return true;
735     }
736 
737     /**
738      * @dev See {IERC20-transferFrom}.
739      *
740      * Emits an {Approval} event indicating the updated allowance. This is not
741      * required by the EIP. See the note at the beginning of {ERC20}.
742      *
743      * Requirements:
744      *
745      * - `sender` and `recipient` cannot be the zero address.
746      * - `sender` must have a balance of at least `amount`.
747      * - the caller must have allowance for ``sender``'s tokens of at least
748      * `amount`.
749      */
750     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
751         _transfer(sender, recipient, amount);
752         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
753         return true;
754     }
755 
756     /**
757      * @dev Atomically increases the allowance granted to `spender` by the caller.
758      *
759      * This is an alternative to {approve} that can be used as a mitigation for
760      * problems described in {IERC20-approve}.
761      *
762      * Emits an {Approval} event indicating the updated allowance.
763      *
764      * Requirements:
765      *
766      * - `spender` cannot be the zero address.
767      */
768     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
769         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
770         return true;
771     }
772 
773     /**
774      * @dev Atomically decreases the allowance granted to `spender` by the caller.
775      *
776      * This is an alternative to {approve} that can be used as a mitigation for
777      * problems described in {IERC20-approve}.
778      *
779      * Emits an {Approval} event indicating the updated allowance.
780      *
781      * Requirements:
782      *
783      * - `spender` cannot be the zero address.
784      * - `spender` must have allowance for the caller of at least
785      * `subtractedValue`.
786      */
787     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
788         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
789         return true;
790     }
791 
792     /**
793      * @dev Moves tokens `amount` from `sender` to `recipient`.
794      *
795      * This is internal function is equivalent to {transfer}, and can be used to
796      * e.g. implement automatic token fees, slashing mechanisms, etc.
797      *
798      * Emits a {Transfer} event.
799      *
800      * Requirements:
801      *
802      * - `sender` cannot be the zero address.
803      * - `recipient` cannot be the zero address.
804      * - `sender` must have a balance of at least `amount`.
805      */
806     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
807         require(sender != address(0), "ERC20: transfer from the zero address");
808         require(recipient != address(0), "ERC20: transfer to the zero address");
809 
810         _beforeTokenTransfer(sender, recipient, amount);
811 
812         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
813         _balances[recipient] = _balances[recipient].add(amount);
814         emit Transfer(sender, recipient, amount);
815     }
816 
817     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
818      * the total supply.
819      *
820      * Emits a {Transfer} event with `from` set to the zero address.
821      *
822      * Requirements:
823      *
824      * - `to` cannot be the zero address.
825      */
826     function _mint(address account, uint256 amount) internal virtual {
827         require(account != address(0), "ERC20: mint to the zero address");
828 
829         _beforeTokenTransfer(address(0), account, amount);
830 
831         _totalSupply = _totalSupply.add(amount);
832         _balances[account] = _balances[account].add(amount);
833         emit Transfer(address(0), account, amount);
834     }
835 
836     /**
837      * @dev Destroys `amount` tokens from `account`, reducing the
838      * total supply.
839      *
840      * Emits a {Transfer} event with `to` set to the zero address.
841      *
842      * Requirements:
843      *
844      * - `account` cannot be the zero address.
845      * - `account` must have at least `amount` tokens.
846      */
847     function _burn(address account, uint256 amount) internal virtual {
848         require(account != address(0), "ERC20: burn from the zero address");
849 
850         _beforeTokenTransfer(account, address(0), amount);
851 
852         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
853         _totalSupply = _totalSupply.sub(amount);
854         emit Transfer(account, address(0), amount);
855     }
856 
857     /**
858      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
859      *
860      * This internal function is equivalent to `approve`, and can be used to
861      * e.g. set automatic allowances for certain subsystems, etc.
862      *
863      * Emits an {Approval} event.
864      *
865      * Requirements:
866      *
867      * - `owner` cannot be the zero address.
868      * - `spender` cannot be the zero address.
869      */
870     function _approve(address owner, address spender, uint256 amount) internal virtual {
871         require(owner != address(0), "ERC20: approve from the zero address");
872         require(spender != address(0), "ERC20: approve to the zero address");
873 
874         _allowances[owner][spender] = amount;
875         emit Approval(owner, spender, amount);
876     }
877 
878     /**
879      * @dev Sets {decimals} to a value other than the default one of 18.
880      *
881      * WARNING: This function should only be called from the constructor. Most
882      * applications that interact with token contracts will not expect
883      * {decimals} to ever change, and may work incorrectly if it does.
884      */
885     function _setupDecimals(uint8 decimals_) internal virtual {
886         _decimals = decimals_;
887     }
888 
889     /**
890      * @dev Hook that is called before any transfer of tokens. This includes
891      * minting and burning.
892      *
893      * Calling conditions:
894      *
895      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
896      * will be to transferred to `to`.
897      * - when `from` is zero, `amount` tokens will be minted for `to`.
898      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
899      * - `from` and `to` are never both zero.
900      *
901      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
902      */
903     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
904 }
905 // File: contracts/SafeMath.sol
906 
907 // 
908 
909 pragma solidity ^0.7.0;
910 
911 /**
912  * @dev Wrappers over Solidity's arithmetic operations with added overflow
913  * checks.
914  *
915  * Arithmetic operations in Solidity wrap on overflow. This can easily result
916  * in bugs, because programmers usually assume that an overflow raises an
917  * error, which is the standard behavior in high level programming languages.
918  * `SafeMath` restores this intuition by reverting the transaction when an
919  * operation overflows.
920  *
921  * Using this library instead of the unchecked operations eliminates an entire
922  * class of bugs, so it's recommended to use it always.
923  */
924 library SafeMath {
925     /**
926      * @dev Returns the addition of two unsigned integers, with an overflow flag.
927      *
928      * _Available since v3.4._
929      */
930     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
931         uint256 c = a + b;
932         if (c < a) return (false, 0);
933         return (true, c);
934     }
935 
936     /**
937      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
938      *
939      * _Available since v3.4._
940      */
941     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
942         if (b > a) return (false, 0);
943         return (true, a - b);
944     }
945 
946     /**
947      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
948      *
949      * _Available since v3.4._
950      */
951     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
952         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
953         // benefit is lost if 'b' is also tested.
954         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
955         if (a == 0) return (true, 0);
956         uint256 c = a * b;
957         if (c / a != b) return (false, 0);
958         return (true, c);
959     }
960 
961     /**
962      * @dev Returns the division of two unsigned integers, with a division by zero flag.
963      *
964      * _Available since v3.4._
965      */
966     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
967         if (b == 0) return (false, 0);
968         return (true, a / b);
969     }
970 
971     /**
972      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
973      *
974      * _Available since v3.4._
975      */
976     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
977         if (b == 0) return (false, 0);
978         return (true, a % b);
979     }
980 
981     /**
982      * @dev Returns the addition of two unsigned integers, reverting on
983      * overflow.
984      *
985      * Counterpart to Solidity's `+` operator.
986      *
987      * Requirements:
988      *
989      * - Addition cannot overflow.
990      */
991     function add(uint256 a, uint256 b) internal pure returns (uint256) {
992         uint256 c = a + b;
993         require(c >= a, "SafeMath: addition overflow");
994         return c;
995     }
996 
997     /**
998      * @dev Returns the subtraction of two unsigned integers, reverting on
999      * overflow (when the result is negative).
1000      *
1001      * Counterpart to Solidity's `-` operator.
1002      *
1003      * Requirements:
1004      *
1005      * - Subtraction cannot overflow.
1006      */
1007     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1008         require(b <= a, "SafeMath: subtraction overflow");
1009         return a - b;
1010     }
1011 
1012     /**
1013      * @dev Returns the multiplication of two unsigned integers, reverting on
1014      * overflow.
1015      *
1016      * Counterpart to Solidity's `*` operator.
1017      *
1018      * Requirements:
1019      *
1020      * - Multiplication cannot overflow.
1021      */
1022     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1023         if (a == 0) return 0;
1024         uint256 c = a * b;
1025         require(c / a == b, "SafeMath: multiplication overflow");
1026         return c;
1027     }
1028 
1029     /**
1030      * @dev Returns the integer division of two unsigned integers, reverting on
1031      * division by zero. The result is rounded towards zero.
1032      *
1033      * Counterpart to Solidity's `/` operator. Note: this function uses a
1034      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1035      * uses an invalid opcode to revert (consuming all remaining gas).
1036      *
1037      * Requirements:
1038      *
1039      * - The divisor cannot be zero.
1040      */
1041     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1042         require(b > 0, "SafeMath: division by zero");
1043         return a / b;
1044     }
1045 
1046     /**
1047      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1048      * reverting when dividing by zero.
1049      *
1050      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1051      * opcode (which leaves remaining gas untouched) while Solidity uses an
1052      * invalid opcode to revert (consuming all remaining gas).
1053      *
1054      * Requirements:
1055      *
1056      * - The divisor cannot be zero.
1057      */
1058     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1059         require(b > 0, "SafeMath: modulo by zero");
1060         return a % b;
1061     }
1062 
1063     /**
1064      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1065      * overflow (when the result is negative).
1066      *
1067      * CAUTION: This function is deprecated because it requires allocating memory for the error
1068      * message unnecessarily. For custom revert reasons use {trySub}.
1069      *
1070      * Counterpart to Solidity's `-` operator.
1071      *
1072      * Requirements:
1073      *
1074      * - Subtraction cannot overflow.
1075      */
1076     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1077         require(b <= a, errorMessage);
1078         return a - b;
1079     }
1080 
1081     /**
1082      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1083      * division by zero. The result is rounded towards zero.
1084      *
1085      * CAUTION: This function is deprecated because it requires allocating memory for the error
1086      * message unnecessarily. For custom revert reasons use {tryDiv}.
1087      *
1088      * Counterpart to Solidity's `/` operator. Note: this function uses a
1089      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1090      * uses an invalid opcode to revert (consuming all remaining gas).
1091      *
1092      * Requirements:
1093      *
1094      * - The divisor cannot be zero.
1095      */
1096     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1097         require(b > 0, errorMessage);
1098         return a / b;
1099     }
1100 
1101     /**
1102      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1103      * reverting with custom message when dividing by zero.
1104      *
1105      * CAUTION: This function is deprecated because it requires allocating memory for the error
1106      * message unnecessarily. For custom revert reasons use {tryMod}.
1107      *
1108      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1109      * opcode (which leaves remaining gas untouched) while Solidity uses an
1110      * invalid opcode to revert (consuming all remaining gas).
1111      *
1112      * Requirements:
1113      *
1114      * - The divisor cannot be zero.
1115      */
1116     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1117         require(b > 0, errorMessage);
1118         return a % b;
1119     }
1120 }
1121 
1122 // File: contracts/SafeBankDividendPayingToken.sol
1123 
1124 // 
1125 
1126 pragma solidity ^0.7.6;
1127 
1128 
1129 
1130 
1131 
1132 
1133 
1134 
1135 
1136 /// @title Dividend-Paying Token
1137 /// @author Roger Wu (https://github.com/roger-wu)
1138 /// @dev A mintable ERC20 token that allows anyone to pay and distribute ether
1139 ///  to token holders as dividends and allows token holders to withdraw their dividends.
1140 ///  Reference: the source code of PoWH3D: https://etherscan.io/address/0xB3775fB83F7D12A36E0475aBdD1FCA35c091efBe#code
1141 contract DividendPayingToken is ERC20, IDividendPayingToken, IDividendPayingTokenOptional {
1142   using SafeMath for uint256;
1143   using SafeMathUint for uint256;
1144   using SafeMathInt for int256;
1145 
1146   // With `magnitude`, we can properly distribute dividends even if the amount of received ether is small.
1147   // For more discussion about choosing the value of `magnitude`,
1148   //  see https://github.com/ethereum/EIPs/issues/1726#issuecomment-472352728
1149   uint256 constant internal magnitude = 2**128;
1150 
1151   uint256 internal magnifiedDividendPerShare;
1152   uint256 internal lastAmount;
1153   
1154   address public DividendToken = address(0);
1155 
1156   // About dividendCorrection:
1157   // If the token balance of a `_user` is never changed, the dividend of `_user` can be computed with:
1158   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user)`.
1159   // When `balanceOf(_user)` is changed (via minting/burning/transferring tokens),
1160   //   `dividendOf(_user)` should not be changed,
1161   //   but the computed value of `dividendPerShare * balanceOf(_user)` is changed.
1162   // To keep the `dividendOf(_user)` unchanged, we add a correction term:
1163   //   `dividendOf(_user) = dividendPerShare * balanceOf(_user) + dividendCorrectionOf(_user)`,
1164   //   where `dividendCorrectionOf(_user)` is updated whenever `balanceOf(_user)` is changed:
1165   //   `dividendCorrectionOf(_user) = dividendPerShare * (old balanceOf(_user)) - (new balanceOf(_user))`.
1166   // So now `dividendOf(_user)` returns the same value before and after `balanceOf(_user)` is changed.
1167   mapping(address => int256) internal magnifiedDividendCorrections;
1168   mapping(address => uint256) internal withdrawnDividends;
1169 
1170   uint256 public totalDividendsDistributed;
1171 
1172   constructor(string memory _name, string memory _symbol) public ERC20(_name, _symbol) {
1173 
1174   }
1175   
1176 
1177   receive() external payable {
1178   }
1179 
1180   /// @notice Distributes ether to token holders as dividends.
1181   /// @dev It reverts if the total supply of tokens is 0.
1182   /// It emits the `DividendsDistributed` event if the amount of received ether is greater than 0.
1183   /// About undistributed ether:
1184   ///   In each distribution, there is a small amount of ether not distributed,
1185   ///     the magnified amount of which is
1186   ///     `(msg.value * magnitude) % totalSupply()`.
1187   ///   With a well-chosen `magnitude`, the amount of undistributed ether
1188   ///     (de-magnified) in a distribution can be less than 1 wei.
1189   ///   We can actually keep track of the undistributed ether in a distribution
1190   ///     and try to distribute it in the next distribution,
1191   ///     but keeping track of such data on-chain costs much more than
1192   ///     the saved ether, so we don't do that.
1193   function distributeDividends() public override payable {
1194     require(totalSupply() > 0);
1195 
1196     if (msg.value > 0) {
1197       magnifiedDividendPerShare = magnifiedDividendPerShare.add(
1198         (msg.value).mul(magnitude) / totalSupply()
1199       );
1200       emit DividendsDistributed(msg.sender, msg.value);
1201 
1202       totalDividendsDistributed = totalDividendsDistributed.add(msg.value);
1203     }
1204   }
1205   
1206 
1207   function distributeTokenDividends(uint256 amount) public {
1208     require(totalSupply() > 0);
1209 
1210     if (amount > 0) {
1211       magnifiedDividendPerShare = magnifiedDividendPerShare.add(
1212         (amount).mul(magnitude) / totalSupply()
1213       );
1214       emit DividendsDistributed(msg.sender, amount);
1215 
1216       totalDividendsDistributed = totalDividendsDistributed.add(amount);
1217     }
1218   }
1219 
1220   /// @notice Withdraws the ether distributed to the sender.
1221   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1222   function withdrawDividend() public virtual override {
1223     _withdrawDividendOfUser(msg.sender);
1224   }
1225 
1226   /// @notice Withdraws the ether distributed to the sender.
1227   /// @dev It emits a `DividendWithdrawn` event if the amount of withdrawn ether is greater than 0.
1228   /// modified to support BNB dividend
1229   function _withdrawDividendOfUser(address payable user) internal returns (uint256) {
1230     uint256 _withdrawableDividend = withdrawableDividendOf(user);
1231     if (_withdrawableDividend > 0) {
1232       withdrawnDividends[user] = withdrawnDividends[user].add(_withdrawableDividend);
1233 
1234         bool success = false;
1235         if(DividendToken == address(0)){
1236             (bool sent, bytes memory data) = user.call{value: _withdrawableDividend}("");
1237             success = sent;
1238             emit DividendWithdrawn(user, _withdrawableDividend, DividendToken);     
1239         }else{
1240             success = IERC20(DividendToken).transfer(user, _withdrawableDividend);
1241             emit DividendWithdrawn(user, _withdrawableDividend, DividendToken);
1242         }
1243 
1244       if(!success) {
1245         withdrawnDividends[user] = withdrawnDividends[user].sub(_withdrawableDividend);
1246         return 0;
1247       }
1248 
1249       return _withdrawableDividend;
1250     }
1251 
1252     return 0;
1253   }
1254 
1255 
1256   /// @notice View the amount of dividend in wei that an address can withdraw.
1257   /// @param _owner The address of a token holder.
1258   /// @return The amount of dividend in wei that `_owner` can withdraw.
1259   function dividendOf(address _owner) public view override returns(uint256) {
1260     return withdrawableDividendOf(_owner);
1261   }
1262 
1263   /// @notice View the amount of dividend in wei that an address can withdraw.
1264   /// @param _owner The address of a token holder.
1265   /// @return The amount of dividend in wei that `_owner` can withdraw.
1266   function withdrawableDividendOf(address _owner) public view override returns(uint256) {
1267     return accumulativeDividendOf(_owner).sub(withdrawnDividends[_owner]);
1268   }
1269 
1270   /// @notice View the amount of dividend in wei that an address has withdrawn.
1271   /// @param _owner The address of a token holder.
1272   /// @return The amount of dividend in wei that `_owner` has withdrawn.
1273   function withdrawnDividendOf(address _owner) public view override returns(uint256) {
1274     return withdrawnDividends[_owner];
1275   }
1276 
1277 
1278   /// @notice View the amount of dividend in wei that an address has earned in total.
1279   /// @dev accumulativeDividendOf(_owner) = withdrawableDividendOf(_owner) + withdrawnDividendOf(_owner)
1280   /// = (magnifiedDividendPerShare * balanceOf(_owner) + magnifiedDividendCorrections[_owner]) / magnitude
1281   /// @param _owner The address of a token holder.
1282   /// @return The amount of dividend in wei that `_owner` has earned in total.
1283   function accumulativeDividendOf(address _owner) public view override returns(uint256) {
1284     return magnifiedDividendPerShare.mul(balanceOf(_owner)).toInt256Safe()
1285       .add(magnifiedDividendCorrections[_owner]).toUint256Safe() / magnitude;
1286   }
1287 
1288   /// @dev Internal function that transfer tokens from one address to another.
1289   /// Update magnifiedDividendCorrections to keep dividends unchanged.
1290   /// @param from The address to transfer from.
1291   /// @param to The address to transfer to.
1292   /// @param value The amount to be transferred.
1293   function _transfer(address from, address to, uint256 value) internal virtual override {
1294     require(false);
1295 
1296     int256 _magCorrection = magnifiedDividendPerShare.mul(value).toInt256Safe();
1297     magnifiedDividendCorrections[from] = magnifiedDividendCorrections[from].add(_magCorrection);
1298     magnifiedDividendCorrections[to] = magnifiedDividendCorrections[to].sub(_magCorrection);
1299   }
1300 
1301   /// @dev Internal function that mints tokens to an account.
1302   /// Update magnifiedDividendCorrections to keep dividends unchanged.
1303   /// @param account The account that will receive the created tokens.
1304   /// @param value The amount that will be created.
1305   function _mint(address account, uint256 value) internal override {
1306     super._mint(account, value);
1307 
1308     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1309       .sub( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
1310   }
1311 
1312   /// @dev Internal function that burns an amount of the token of a given account.
1313   /// Update magnifiedDividendCorrections to keep dividends unchanged.
1314   /// @param account The account whose tokens will be burnt.
1315   /// @param value The amount that will be burnt.
1316   function _burn(address account, uint256 value) internal override {
1317     super._burn(account, value);
1318 
1319     magnifiedDividendCorrections[account] = magnifiedDividendCorrections[account]
1320       .add( (magnifiedDividendPerShare.mul(value)).toInt256Safe() );
1321   }
1322 
1323   function _setBalance(address account, uint256 newBalance) internal {
1324     uint256 currentBalance = balanceOf(account);
1325 
1326     if(newBalance > currentBalance) {
1327       uint256 mintAmount = newBalance.sub(currentBalance);
1328       _mint(account, mintAmount);
1329     } else if(newBalance < currentBalance) {
1330       uint256 burnAmount = currentBalance.sub(newBalance);
1331       _burn(account, burnAmount);
1332     }
1333   }
1334 }
1335 
1336 // File: contracts/SafeBank.sol
1337 
1338 // 
1339 
1340 pragma solidity ^0.7.6;
1341 
1342 
1343 
1344 
1345 
1346 
1347 
1348 
1349 
1350 contract SafeBank is ERC20, Ownable {
1351     using SafeMath for uint256;
1352 
1353     IUniswapV2Router02 public uniswapV2Router;
1354     address public immutable uniswapV2Pair;
1355 
1356     address public DividendToken = address(0);
1357 
1358     bool private swapping;
1359 
1360     SafeBankDividendTracker public dividendTracker;
1361 
1362     address public burnAddress;
1363     
1364     uint256 public maxBuyTranscationAmount = 100000000000000 * (10**9);
1365     uint256 public maxSellTransactionAmount = 100000000000000 * (10**9);
1366     uint256 public swapTokensAtAmount = 5000000 * (10**9);
1367     uint256 public _maxWalletToken = 100000000000000 * (10**9);
1368 
1369     // added
1370     address payable public wallet1Address;
1371     address payable public wallet2Address;
1372     address payable public wallet3Address;
1373     address public wallet1TokenAddressForFee;
1374     address public wallet2TokenAddressForFee;
1375     address public wallet3TokenAddressForFee;
1376     uint256 public wallet1Fee;
1377     uint256 public wallet2Fee;
1378     uint256 public wallet3Fee;
1379     uint256 public tokenRewardsFee;
1380     uint256 public liquidityFee;
1381     uint256 public totalFees;
1382 
1383     // fee aggiuntiva alla vendita del 20% 
1384     uint256 public sellFeeIncreaseFactor = 1200;
1385 
1386     // autoclaim gas to 400k
1387     uint256 public gasForProcessing = 400000;
1388     
1389     address public presaleAddress = address(0);
1390 
1391     // timestamp for when the token can be traded freely on PanackeSwap
1392     uint256 public tradingEnabledTimestamp = 1626624000;
1393 
1394     // exlcude from fees and max transaction amount
1395     mapping (address => bool) private _isExcludedFromFees;
1396     mapping (address => bool) public _isExcludedMaxSellTransactionAmount;
1397 
1398     // addresses that can make transfers before presale is over
1399     mapping (address => bool) private canTransferBeforeTradingIsEnabled;
1400 
1401     // store addresses that a automatic market maker pairs. Any transfer *to* these addresses
1402     // could be subject to a maximum transfer amount
1403     mapping (address => bool) public automatedMarketMakerPairs;
1404 
1405     event UpdateDividendTracker(address indexed newAddress, address indexed oldAddress);
1406 
1407     event UpdateUniswapV2Router(address indexed newAddress, address indexed oldAddress);
1408     // added
1409     event UpdateDividendToken(address indexed newAddress, address indexed oldAddress);
1410     //
1411 
1412     event ExcludeFromFees(address indexed account, bool isExcluded);
1413     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1414     event ExcludedMaxSellTransactionAmount(address indexed account, bool isExcluded);
1415 
1416     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1417 
1418     event BurnWalletUpdated(address indexed newBurnWallet, address indexed oldBurnWallet);
1419 
1420     event GasForProcessingUpdated(uint256 indexed newValue, uint256 indexed oldValue);
1421 
1422     event FixedSaleBuy(address indexed account, uint256 indexed amount, bool indexed earlyParticipant, uint256 numberOfBuyers);
1423 
1424     event SwapAndLiquify(
1425         uint256 tokensSwapped,
1426         uint256 ethReceived,
1427         uint256 tokensIntoLiqudity
1428     );
1429 
1430     event SendDividends(
1431         uint256 tokensSwapped,
1432         uint256 amount
1433     );
1434 
1435     event ProcessedDividendTracker(
1436         uint256 iterations,
1437         uint256 claims,
1438         uint256 lastProcessedIndex,
1439         bool indexed automatic,
1440         uint256 gas,
1441         address indexed processor
1442     );
1443 
1444     constructor() public ERC20("SafeBank", "sBANK") {
1445         uint256 _tokenRewardsFee = 3;
1446         uint256 _liquidityFee = 2;
1447         uint256 _wallet1Fee = 1;
1448         uint256 _wallet2Fee = 2;
1449         uint256 _wallet3Fee = 2;
1450 
1451         tokenRewardsFee = _tokenRewardsFee;
1452         liquidityFee = _liquidityFee;
1453         wallet1Fee = _wallet1Fee;
1454         wallet2Fee = _wallet2Fee;
1455         wallet3Fee = _wallet3Fee;
1456         totalFees = _tokenRewardsFee.add(_liquidityFee).add(_wallet1Fee).add(_wallet2Fee).add(_wallet3Fee);
1457         
1458 
1459 
1460         dividendTracker = new SafeBankDividendTracker();
1461 
1462         burnAddress = address(0xdead);
1463 
1464         
1465         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1466          // Create a uniswap pair for this new token
1467         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1468             .createPair(address(this), _uniswapV2Router.WETH());
1469 
1470         uniswapV2Router = _uniswapV2Router;
1471         uniswapV2Pair = _uniswapV2Pair;
1472 
1473         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1474 
1475         // exclude from receiving dividends
1476         dividendTracker.excludeFromDividends(address(dividendTracker));
1477         dividendTracker.excludeFromDividends(address(this));
1478         dividendTracker.excludeFromDividends(address(_uniswapV2Router));
1479         dividendTracker.excludeFromDividends(owner());
1480 
1481         
1482 
1483         // exclude from paying fees or having max transaction amount
1484         excludeFromFees(burnAddress, true);
1485         excludeFromFees(address(this), true);
1486         excludeFromFees(owner(), true);
1487 
1488 
1489         // enable owner and fixed-sale wallet to send tokens before presales are over
1490         canTransferBeforeTradingIsEnabled[owner()] = true;
1491         /*
1492             _mint is an internal function in ERC20.sol that is only called here,
1493             and CANNOT be called ever again
1494         */
1495         _mint(owner(), 100000000000000 * (10**9));
1496     }
1497 
1498     receive() external payable {
1499 
1500     }
1501     
1502     // added
1503     function updateTradingEnabledTime (uint256 newTimeInEpoch) external onlyOwner {
1504         tradingEnabledTimestamp = newTimeInEpoch;
1505     }     
1506 
1507     function updateMinimumBalanceForDividends (uint256 newAmountNoDecimials) external onlyOwner {
1508         dividendTracker.updateMinimumBalanceForDividends(newAmountNoDecimials);
1509     }    
1510 
1511     function updateSellIncreaseFee (uint256 newFeeWholeNumber) external onlyOwner {
1512         sellFeeIncreaseFactor = newFeeWholeNumber;
1513     }
1514     
1515     function updateMaxWalletAmount(uint256 newAmountNoDecimials) external onlyOwner {
1516         _maxWalletToken = newAmountNoDecimials * (10**9);
1517     }     
1518 
1519     function updateSwapAtAmount(uint256 newAmountNoDecimials) external onlyOwner {
1520         swapTokensAtAmount = newAmountNoDecimials * (10**9);
1521     } 
1522 
1523     function updateTokenForDividend(address newAddress) external onlyOwner {
1524         dividendTracker.updateTokenForDividend(newAddress);
1525         DividendToken = newAddress;
1526         emit UpdateDividendToken(newAddress, address(DividendToken));
1527     }    
1528 
1529     function updateWallet1Address(address payable newAddress) external onlyOwner {
1530         wallet1Address = newAddress;
1531         excludeFromFees(wallet1Address, true);
1532         dividendTracker.excludeFromDividends(wallet1Address);     
1533     }    
1534 
1535     function updateWallet2Address(address payable newAddress) external onlyOwner {
1536         wallet2Address = newAddress;
1537         excludeFromFees(wallet2Address, true);
1538         dividendTracker.excludeFromDividends(wallet2Address);
1539     }       
1540 
1541     function updateWallet3Address(address payable newAddress) external onlyOwner {
1542         wallet3Address = newAddress;
1543         excludeFromFees(wallet3Address, true);
1544         dividendTracker.excludeFromDividends(wallet3Address);
1545     }    
1546 
1547     function updateWallet1TokenFeeAddress(address newAddress) external onlyOwner {
1548         wallet1TokenAddressForFee = newAddress;
1549     }    
1550 
1551     function updateWallet2TokenFeeAddress(address newAddress) external onlyOwner {
1552         wallet2TokenAddressForFee = newAddress;
1553     }    
1554 
1555     function updateWallet3TokenFeeAddress(address newAddress) external onlyOwner {
1556         wallet3TokenAddressForFee = newAddress;
1557     }
1558 
1559     function updateFees(uint256 _tokenRewardsFee, uint256 _liquidityFee, uint256 _wallet1Fee, uint256 _wallet2Fee, uint256 _wallet3Fee) external onlyOwner {
1560         tokenRewardsFee = _tokenRewardsFee;
1561         liquidityFee = _liquidityFee;
1562         wallet1Fee = _wallet1Fee;
1563         wallet2Fee = _wallet2Fee;
1564         wallet3Fee = _wallet3Fee;
1565         totalFees = tokenRewardsFee.add(liquidityFee).add(wallet1Fee).add(wallet2Fee).add(wallet3Fee);
1566     }
1567     //
1568     function whitelistDxSale(address _presaleAddress, address _routerAddress) external onlyOwner {
1569         presaleAddress = _presaleAddress;
1570         canTransferBeforeTradingIsEnabled[presaleAddress] = true;
1571         dividendTracker.excludeFromDividends(_presaleAddress);
1572         excludeFromFees(_presaleAddress, true);
1573 
1574         canTransferBeforeTradingIsEnabled[_routerAddress] = true;
1575         dividendTracker.excludeFromDividends(_routerAddress);
1576         excludeFromFees(_routerAddress, true);
1577     }
1578 
1579     function updateDividendTracker(address newAddress) external onlyOwner {
1580         require(newAddress != address(dividendTracker), "SafeBank: The dividend tracker already has that address");
1581 
1582         SafeBankDividendTracker newDividendTracker = SafeBankDividendTracker(payable(newAddress));
1583 
1584         require(newDividendTracker.owner() == address(this), "SafeBank: The new dividend tracker must be owned by the SafeBank token contract");
1585 
1586         newDividendTracker.excludeFromDividends(address(newDividendTracker));
1587         newDividendTracker.excludeFromDividends(address(this));
1588         newDividendTracker.excludeFromDividends(address(uniswapV2Router));
1589 
1590         emit UpdateDividendTracker(newAddress, address(dividendTracker));
1591 
1592         dividendTracker = newDividendTracker;
1593     }
1594 
1595     function updateUniswapV2Router(address newAddress) external onlyOwner {
1596         require(newAddress != address(uniswapV2Router), "SafeBank: The router already has that address");
1597         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
1598         uniswapV2Router = IUniswapV2Router02(newAddress);
1599     }
1600 
1601     function excludeFromFees(address account, bool excluded) public onlyOwner {
1602         //require(_isExcludedFromFees[account] != excluded, "SafeBank: Account is already the value of 'excluded'");
1603         _isExcludedFromFees[account] = excluded;
1604 
1605         emit ExcludeFromFees(account, excluded);
1606     }
1607 
1608     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) external onlyOwner {
1609         for(uint256 i = 0; i < accounts.length; i++) {
1610             _isExcludedFromFees[accounts[i]] = excluded;
1611         }
1612 
1613         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1614     }
1615 
1616     function setAutomatedMarketMakerPair(address pair, bool value) external onlyOwner {
1617         require(pair != uniswapV2Pair, "SafeBank: The PancakeSwap pair cannot be removed from automatedMarketMakerPairs");
1618 
1619         _setAutomatedMarketMakerPair(pair, value);
1620     }
1621 
1622     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1623         require(automatedMarketMakerPairs[pair] != value, "SafeBank: Automated market maker pair is already set to that value");
1624         automatedMarketMakerPairs[pair] = value;
1625 
1626         if(value) {
1627             dividendTracker.excludeFromDividends(pair);
1628         }
1629 
1630         emit SetAutomatedMarketMakerPair(pair, value);
1631     }
1632 
1633     function updateGasForProcessing(uint256 newValue) public onlyOwner {
1634         require(newValue >= 200000 && newValue <= 500000, "SafeBank: gasForProcessing must be between 200,000 and 500,000");
1635         require(newValue != gasForProcessing, "SafeBank: Cannot update gasForProcessing to same value");
1636         emit GasForProcessingUpdated(newValue, gasForProcessing);
1637         gasForProcessing = newValue;
1638     }
1639 
1640     function updateClaimWait(uint256 claimWait) external onlyOwner {
1641         dividendTracker.updateClaimWait(claimWait);
1642     }
1643 
1644     function getClaimWait() external view returns(uint256) {
1645         return dividendTracker.claimWait();
1646     }
1647 
1648     function getTotalDividendsDistributed() external view returns (uint256) {
1649         return dividendTracker.totalDividendsDistributed();
1650     }
1651 
1652     function isExcludedFromFees(address account) public view returns(bool) {
1653         return _isExcludedFromFees[account];
1654     }
1655 
1656     function withdrawableDividendOf(address account) public view returns(uint256) {
1657         return dividendTracker.withdrawableDividendOf(account);
1658     }
1659 
1660     function dividendTokenBalanceOf(address account) public view returns (uint256) {
1661         return dividendTracker.balanceOf(account);
1662     }
1663 
1664     function getAccountDividendsInfo(address account)
1665         external view returns (
1666             address,
1667             int256,
1668             int256,
1669             uint256,
1670             uint256,
1671             uint256,
1672             uint256,
1673             uint256) {
1674         return dividendTracker.getAccount(account);
1675     }
1676 
1677     function getAccountDividendsInfoAtIndex(uint256 index)
1678         external view returns (
1679             address,
1680             int256,
1681             int256,
1682             uint256,
1683             uint256,
1684             uint256,
1685             uint256,
1686             uint256) {
1687         return dividendTracker.getAccountAtIndex(index);
1688     }
1689 
1690     function processDividendTracker(uint256 gas) external {
1691         (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) = dividendTracker.process(gas);
1692         emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, false, gas, tx.origin);
1693     }
1694 
1695     function claim() external {
1696         dividendTracker.processAccount(msg.sender, false);
1697     }
1698 
1699     function getLastProcessedIndex() external view returns(uint256) {
1700         return dividendTracker.getLastProcessedIndex();
1701     }
1702 
1703     function getNumberOfDividendTokenHolders() external view returns(uint256) {
1704         return dividendTracker.getNumberOfTokenHolders();
1705     }
1706 
1707     function getTradingIsEnabled() public view returns (bool) {
1708         return block.timestamp >= tradingEnabledTimestamp;
1709     }
1710 
1711     function _transfer(
1712         address from,
1713         address to,
1714         uint256 amount
1715     ) internal override {
1716         require(from != address(0), "ERC20: transfer from the zero address");
1717         require(to != address(0), "ERC20: transfer to the zero address");
1718         
1719             if (
1720             from != owner() &&
1721             to != owner() &&
1722             to != address(0) &&
1723             to != address(0xdead) &&
1724             to != uniswapV2Pair
1725         ) {
1726             require(
1727                 amount <= maxBuyTranscationAmount,
1728                 "Transfer amount exceeds the maxTxAmount."
1729             );
1730             
1731             uint256 contractBalanceRecepient = balanceOf(to);
1732             require(
1733                 contractBalanceRecepient + amount <= _maxWalletToken,
1734                 "Exceeds maximum wallet token amount."
1735             );
1736         }
1737         
1738         
1739         
1740         bool tradingIsEnabled = getTradingIsEnabled();
1741 
1742         // only whitelisted addresses can make transfers after the fixed-sale has started
1743         // and before the public presale is over
1744         if(!tradingIsEnabled) {
1745             require(canTransferBeforeTradingIsEnabled[from], "SafeBank: This account cannot send tokens until trading is enabled");
1746         }
1747 
1748         if(amount == 0) {
1749             super._transfer(from, to, 0);
1750             return;
1751         }
1752 
1753         if( 
1754             !swapping &&
1755             tradingIsEnabled &&
1756             automatedMarketMakerPairs[to] && // sells only by detecting transfer to automated market maker pair
1757             from != address(uniswapV2Router) && //router -> pair is removing liquidity which shouldn't have max
1758             !_isExcludedFromFees[to] //no max for those excluded from fees
1759         ) {
1760             require(amount <= maxSellTransactionAmount, "Sell transfer amount exceeds the maxSellTransactionAmount.");
1761         }
1762 
1763         uint256 contractTokenBalance = balanceOf(address(this));
1764         
1765         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1766 
1767         if(
1768             tradingIsEnabled && 
1769             canSwap &&
1770             !swapping &&
1771             !automatedMarketMakerPairs[from] &&
1772             from != burnAddress &&
1773             to != burnAddress
1774         ) {
1775             swapping = true;
1776 
1777             uint256 swapTokens = contractTokenBalance.mul(liquidityFee).div(totalFees);
1778             swapAndLiquify(swapTokens);
1779 
1780             uint256 sellTokens = balanceOf(address(this));
1781             swapAndSendDividends(sellTokens);
1782 
1783             swapping = false;
1784         }
1785 
1786 
1787         bool takeFee = tradingIsEnabled && !swapping;
1788 
1789         // if any account belongs to _isExcludedFromFee account then remove the fee
1790         if(_isExcludedFromFees[from] || _isExcludedFromFees[to]) {
1791             takeFee = false;
1792         }
1793 
1794         if(takeFee) {
1795             uint256 fees = amount.mul(totalFees).div(100);
1796 
1797             // if sell, multiply by 1.2
1798             if(automatedMarketMakerPairs[to]) {
1799                 fees = fees.mul(sellFeeIncreaseFactor).div(100);
1800             }
1801 
1802             amount = amount.sub(fees);
1803 
1804             super._transfer(from, address(this), fees);
1805         }
1806 
1807         super._transfer(from, to, amount);
1808 
1809         try dividendTracker.setBalance(payable(from), balanceOf(from)) {} catch {}
1810         try dividendTracker.setBalance(payable(to), balanceOf(to)) {} catch {}
1811 
1812         if(!swapping) {
1813             uint256 gas = gasForProcessing;
1814 
1815             try dividendTracker.process(gas) returns (uint256 iterations, uint256 claims, uint256 lastProcessedIndex) {
1816                 emit ProcessedDividendTracker(iterations, claims, lastProcessedIndex, true, gas, tx.origin);
1817             }
1818             catch {
1819 
1820             }
1821         }
1822     }
1823     
1824     // made public for testing
1825     function swapAndLiquify(uint256 tokens) public  {
1826         // split the contract balance into halves
1827         uint256 half = tokens.div(2);
1828         uint256 otherHalf = tokens.sub(half);
1829 
1830         // capture the contract's current ETH balance.
1831         // this is so that we can capture exactly the amount of ETH that the
1832         // swap creates, and not make the liquidity event include any ETH that
1833         // has been manually sent to the contract
1834         uint256 initialBalance = address(this).balance;
1835 
1836         // swap tokens for ETH
1837         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1838 
1839         // how much ETH did we just swap into?
1840         uint256 newBalance = address(this).balance.sub(initialBalance);
1841         
1842         // calculate the portions of the liquidity to add to wallet1fee
1843         uint256 wallet1feeBalance = newBalance.div(totalFees).mul(wallet1Fee);
1844         uint256 wallet1feePortion = otherHalf.div(totalFees).mul(wallet1Fee);        
1845         // calculate the portions of the liquidity to add to wallet2fee
1846         uint256 wallet2feeBalance = newBalance.div(totalFees).mul(wallet2Fee);
1847         uint256 wallet2feePortion = otherHalf.div(totalFees).mul(wallet2Fee);
1848         // calculate the portions of the liquidity to add to wallet3fee
1849         uint256 wallet3feeBalance = newBalance.div(totalFees).mul(wallet3Fee);
1850         uint256 wallet3feePortion = otherHalf.div(totalFees).mul(wallet3Fee);
1851         uint256 walletTotalBalance = wallet1feeBalance + wallet2feeBalance + wallet3feeBalance;
1852         uint256 walletTotalPortion = wallet1feePortion + wallet2feePortion + wallet3feePortion;
1853         uint256 finalBalance = newBalance.sub(walletTotalBalance);
1854         uint256 finalHalf = otherHalf.sub(walletTotalPortion);
1855         
1856         
1857         // added to manage receiving eth or any token 1
1858         if(wallet1TokenAddressForFee != address(0)){
1859             swapEthForTokens(wallet1feeBalance, wallet1TokenAddressForFee, wallet1Address);
1860             //_transfer(address(this), burnAddress, wallet1feePortion);
1861             //emit Transfer(address(this), burnAddress, wallet1feePortion);
1862         }else{
1863             (bool sent, bytes memory data) = wallet1Address.call{value: wallet1feeBalance}("");
1864             if(sent){
1865                 //_transfer(address(this), burnAddress, wallet1feePortion);
1866                 //emit Transfer(address(this), burnAddress, wallet1feePortion);
1867             } else {
1868                 addLiquidity(wallet1feePortion, wallet1feeBalance);
1869             }
1870         }        
1871 
1872         // added to manage receiving eth or any token 2
1873         if(wallet2TokenAddressForFee != address(0)){
1874             swapEthForTokens(wallet2feeBalance, wallet2TokenAddressForFee, wallet2Address);
1875             //_transfer(address(this), burnAddress, wallet2feePortion);
1876             //emit Transfer(address(this), burnAddress, wallet2feePortion);
1877         }else{
1878             (bool sent, bytes memory data) = wallet2Address.call{value: wallet2feeBalance}("");
1879             if(sent){
1880                 //_transfer(address(this), burnAddress, wallet2feePortion);
1881                 //emit Transfer(address(this), burnAddress, wallet2feePortion);
1882             } else {
1883                 addLiquidity(wallet2feePortion, wallet2feeBalance);
1884             }
1885         }        
1886 
1887         // added to manage receiving eth or any token 3
1888         if(wallet3TokenAddressForFee != address(0)){
1889             swapEthForTokens(wallet3feeBalance, wallet3TokenAddressForFee, wallet3Address);
1890             //_transfer(address(this), burnAddress, wallet3feePortion);
1891             //emit Transfer(address(this), burnAddress, wallet3feePortion);
1892         }else{
1893             (bool sent, bytes memory data) = wallet3Address.call{value: wallet3feeBalance}("");
1894             if(sent){
1895                 //_transfer(address(this), burnAddress, wallet3feePortion);
1896                 //emit Transfer(address(this), burnAddress, wallet3feePortion);
1897             } else {
1898                 addLiquidity(wallet3feePortion, wallet3feeBalance);
1899             }
1900         }
1901         
1902         // add liquidity to uniswap
1903         addLiquidity(finalHalf, finalBalance);
1904         
1905         emit SwapAndLiquify(half, newBalance, otherHalf);
1906     }
1907     
1908     // added in order to sell eth for something else like usdt,busd,etc
1909     function swapEthForTokens(uint256 ethAmount, address tokenAddress, address receiver) private {
1910         // generate the uniswap pair path of weth -> token
1911         address[] memory path = new address[](2);
1912         path[0] = uniswapV2Router.WETH();
1913         path[1] = tokenAddress;
1914 
1915         // make the swap
1916         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: ethAmount}(
1917             0, // accept any amount of ETH
1918             path,
1919             receiver,
1920             block.timestamp
1921         );
1922     }
1923 
1924     function swapTokensForEth(uint256 tokenAmount) private {
1925 
1926         
1927         // generate the uniswap pair path of token -> weth
1928         address[] memory path = new address[](2);
1929         path[0] = address(this);
1930         path[1] = uniswapV2Router.WETH();
1931 
1932         _approve(address(this), address(uniswapV2Router), tokenAmount);
1933 
1934         // make the swap
1935         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1936             tokenAmount,
1937             0, // accept any amount of ETH
1938             path,
1939             address(this),
1940             block.timestamp
1941         );
1942         
1943     }
1944 
1945 
1946     function swapTokensForTokens(uint256 tokenAmount, address recipient) private {
1947        
1948         // generate the uniswap pair path of weth -> busd
1949         address[] memory path = new address[](3);
1950         path[0] = address(this);
1951         path[1] = uniswapV2Router.WETH();
1952         path[2] = DividendToken;
1953 
1954         _approve(address(this), address(uniswapV2Router), tokenAmount);
1955 
1956         // make the swap
1957         uniswapV2Router.swapExactTokensForTokensSupportingFeeOnTransferTokens(
1958             tokenAmount,
1959             0, // accept any amount of BUSD
1960             path,
1961             recipient,
1962             block.timestamp
1963         );
1964         
1965     }
1966 
1967     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) public {
1968         
1969         // approve token transfer to cover all possible scenarios
1970         _approve(address(this), address(uniswapV2Router), tokenAmount);
1971 
1972         // add the liquidity
1973        uniswapV2Router.addLiquidityETH{value: ethAmount}(
1974             address(this),
1975             tokenAmount,
1976             0, // slippage is unavoidable
1977             0, // slippage is unavoidable
1978             burnAddress,
1979             block.timestamp
1980         );
1981         
1982     }
1983 
1984     // modified to support BNB dividend
1985     function swapAndSendDividends(uint256 tokens) private {
1986         address payable diviTracker = address(dividendTracker);
1987         bool success = false;
1988         uint256 dividends;
1989         if(DividendToken != address(0)){
1990             swapTokensForTokens(tokens, address(this));
1991             dividends = IERC20(DividendToken).balanceOf(address(this));
1992             success = IERC20(DividendToken).transfer(address(dividendTracker), dividends);
1993         }else{
1994             uint256 initialBalance = address(this).balance;
1995             swapTokensForEth(tokens);
1996             uint256 newBalance = address(this).balance.sub(initialBalance);
1997             dividends = newBalance;
1998             (bool sent, bytes memory data) = diviTracker.call{value: newBalance}("");
1999             success = sent;
2000         }
2001         if (success) {
2002             dividendTracker.distributeTokenDividends(dividends);
2003             emit SendDividends(tokens, dividends);
2004         }
2005     }
2006     
2007 }
2008 
2009 contract SafeBankDividendTracker is DividendPayingToken, Ownable {
2010     using SafeMath for uint256;
2011     using SafeMathInt for int256;
2012     using IterableMapping for IterableMapping.Map;
2013 
2014     IterableMapping.Map private tokenHoldersMap;
2015     uint256 public lastProcessedIndex;
2016 
2017     mapping (address => bool) public excludedFromDividends;
2018 
2019     mapping (address => uint256) public lastClaimTimes;
2020 
2021     uint256 public claimWait;
2022     uint256 public minimumTokenBalanceForDividends;
2023 
2024     event ExcludeFromDividends(address indexed account);
2025     event ClaimWaitUpdated(uint256 indexed newValue, uint256 indexed oldValue);
2026 
2027     event Claim(address indexed account, uint256 amount, bool indexed automatic);
2028 
2029     constructor() public DividendPayingToken("SafeBank_Dividend_Tracker", "SafeBank_Dividend_Tracker") {
2030         claimWait = 3600;
2031         minimumTokenBalanceForDividends = 1000000000 * (10**9); //min 1 billion
2032     }
2033 
2034     // added
2035     function updateMinimumBalanceForDividends(uint256 newAmountNoDecimials) external onlyOwner{
2036         minimumTokenBalanceForDividends = newAmountNoDecimials * (10**9);
2037     }
2038 
2039     function updateTokenForDividend(address newAddress) external onlyOwner {
2040         DividendToken = newAddress;
2041     }  
2042     // 
2043     function _transfer(address, address, uint256) internal override {
2044         require(false, "SafeBank_Dividend_Tracker: No transfers allowed");
2045     }
2046 
2047     function withdrawDividend() public override {
2048         require(false, "SafeBank_Dividend_Tracker: withdrawDividend disabled. Use the 'claim' function on the main SafeBank contract.");
2049    
2050     }
2051 
2052     function updateClaimWait(uint256 newClaimWait) external onlyOwner {
2053         require(newClaimWait >= 3600 && newClaimWait <= 86400, "SafeBank_Dividend_Tracker: claimWait must be updated to between 1 and 24 hours");
2054         require(newClaimWait != claimWait, "SafeBank_Dividend_Tracker: Cannot update claimWait to same value");
2055         emit ClaimWaitUpdated(newClaimWait, claimWait);
2056         claimWait = newClaimWait;
2057     }
2058 
2059     function getLastProcessedIndex() external view returns(uint256) {
2060         return lastProcessedIndex;
2061     }
2062 
2063     function getNumberOfTokenHolders() external view returns(uint256) {
2064         return tokenHoldersMap.keys.length;
2065     }
2066 
2067 
2068     function getAccount(address _account)
2069         public view returns (
2070             address account,
2071             int256 index,
2072             int256 iterationsUntilProcessed,
2073             uint256 withdrawableDividends,
2074             uint256 totalDividends,
2075             uint256 lastClaimTime,
2076             uint256 nextClaimTime,
2077             uint256 secondsUntilAutoClaimAvailable) {
2078         account = _account;
2079 
2080         index = tokenHoldersMap.getIndexOfKey(account);
2081 
2082         iterationsUntilProcessed = -1;
2083 
2084         if(index >= 0) {
2085             if(uint256(index) > lastProcessedIndex) {
2086                 iterationsUntilProcessed = index.sub(int256(lastProcessedIndex));
2087             }
2088             else {
2089                 uint256 processesUntilEndOfArray = tokenHoldersMap.keys.length > lastProcessedIndex ?
2090                                                         tokenHoldersMap.keys.length.sub(lastProcessedIndex) :
2091                                                         0;
2092 
2093 
2094                 iterationsUntilProcessed = index.add(int256(processesUntilEndOfArray));
2095             }
2096         }
2097 
2098 
2099         withdrawableDividends = withdrawableDividendOf(account);
2100         totalDividends = accumulativeDividendOf(account);
2101 
2102         lastClaimTime = lastClaimTimes[account];
2103 
2104         nextClaimTime = lastClaimTime > 0 ?
2105                                     lastClaimTime.add(claimWait) :
2106                                     0;
2107 
2108         secondsUntilAutoClaimAvailable = nextClaimTime > block.timestamp ?
2109                                                     nextClaimTime.sub(block.timestamp) :
2110                                                     0;
2111     }
2112 
2113     function getAccountAtIndex(uint256 index)
2114         public view returns (
2115             address,
2116             int256,
2117             int256,
2118             uint256,
2119             uint256,
2120             uint256,
2121             uint256,
2122             uint256) {
2123         if(index >= tokenHoldersMap.size()) {
2124             return (0x0000000000000000000000000000000000000000, -1, -1, 0, 0, 0, 0, 0);
2125         }
2126 
2127         address account = tokenHoldersMap.getKeyAtIndex(index);
2128 
2129         return getAccount(account);
2130 
2131      }
2132 
2133     function excludeFromDividends(address account) external onlyOwner {
2134         require(!excludedFromDividends[account]);
2135         excludedFromDividends[account] = true;
2136 
2137         _setBalance(account, 0);
2138         tokenHoldersMap.remove(account);
2139 
2140         //emit ExcludeFromDividends(account);
2141         
2142     }
2143 
2144     function canAutoClaim(uint256 lastClaimTime) private view returns (bool) {
2145         if(lastClaimTime > block.timestamp)  {
2146             return false;
2147         }
2148 
2149         return block.timestamp.sub(lastClaimTime) >= claimWait;
2150     }
2151 
2152     function setBalance(address payable account, uint256 newBalance) external onlyOwner {
2153         if(excludedFromDividends[account]) {
2154             return;
2155         }
2156 
2157         if(newBalance >= minimumTokenBalanceForDividends) {
2158             _setBalance(account, newBalance);
2159             tokenHoldersMap.set(account, newBalance);
2160         }
2161         else {
2162             _setBalance(account, 0);
2163             tokenHoldersMap.remove(account);
2164         }
2165 
2166         processAccount(account, true);
2167     }
2168 
2169     function process(uint256 gas) public returns (uint256, uint256, uint256) {
2170         uint256 numberOfTokenHolders = tokenHoldersMap.keys.length;
2171 
2172         if(numberOfTokenHolders == 0) {
2173             return (0, 0, lastProcessedIndex);
2174         }
2175 
2176         uint256 _lastProcessedIndex = lastProcessedIndex;
2177 
2178         uint256 gasUsed = 0;
2179 
2180         uint256 gasLeft = gasleft();
2181 
2182         uint256 iterations = 0;
2183         uint256 claims = 0;
2184 
2185         while(gasUsed < gas && iterations < numberOfTokenHolders) {
2186             _lastProcessedIndex++;
2187 
2188             if(_lastProcessedIndex >= tokenHoldersMap.keys.length) {
2189                 _lastProcessedIndex = 0;
2190             }
2191 
2192             address account = tokenHoldersMap.keys[_lastProcessedIndex];
2193 
2194             if(canAutoClaim(lastClaimTimes[account])) {
2195                 if(processAccount(payable(account), true)) {
2196                     claims++;
2197                 }
2198             }
2199 
2200             iterations++;
2201 
2202             uint256 newGasLeft = gasleft();
2203 
2204             if(gasLeft > newGasLeft) {
2205                 gasUsed = gasUsed.add(gasLeft.sub(newGasLeft));
2206             }
2207 
2208             gasLeft = newGasLeft;
2209         }
2210 
2211         lastProcessedIndex = _lastProcessedIndex;
2212 
2213         return (iterations, claims, lastProcessedIndex);
2214     }
2215 
2216     function processAccount(address payable account, bool automatic) public onlyOwner returns (bool) {
2217         uint256 amount = _withdrawDividendOfUser(account);
2218 
2219         if(amount > 0) {
2220             lastClaimTimes[account] = block.timestamp;
2221             emit Claim(account, amount, automatic);
2222             return true;
2223         }
2224 
2225         return false;
2226     }
2227     
2228 }