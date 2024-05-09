1 // SPDX-License-Identifier: MIT
2 
3 //  ________  _______   ______  ________  __    __  _______    ______   __    __  ______  _______    ______  
4 // /        |/       \ /      |/        |/  \  /  |/       \  /      \ /  |  /  |/      |/       \  /      \ 
5 // $$$$$$$$/ $$$$$$$  |$$$$$$/ $$$$$$$$/ $$  \ $$ |$$$$$$$  |/$$$$$$  |$$ |  $$ |$$$$$$/ $$$$$$$  |/$$$$$$  |
6 // $$ |__    $$ |__$$ |  $$ |  $$ |__    $$$  \$$ |$$ |  $$ |$$ |  $$/ $$ |__$$ |  $$ |  $$ |__$$ |$$ \__$$/ 
7 // $$    |   $$    $$<   $$ |  $$    |   $$$$  $$ |$$ |  $$ |$$ |      $$    $$ |  $$ |  $$    $$/ $$      \ 
8 // $$$$$/    $$$$$$$  |  $$ |  $$$$$/    $$ $$ $$ |$$ |  $$ |$$ |   __ $$$$$$$$ |  $$ |  $$$$$$$/   $$$$$$  |
9 // $$ |      $$ |  $$ | _$$ |_ $$ |_____ $$ |$$$$ |$$ |__$$ |$$ \__/  |$$ |  $$ | _$$ |_ $$ |      /  \__$$ |
10 // $$ |      $$ |  $$ |/ $$   |$$       |$$ | $$$ |$$    $$/ $$    $$/ $$ |  $$ |/ $$   |$$ |      $$    $$/ 
11 // $$/       $$/   $$/ $$$$$$/ $$$$$$$$/ $$/   $$/ $$$$$$$/   $$$$$$/  $$/   $$/ $$$$$$/ $$/        $$$$$$/  
12                                                                                                                              
13 // The Mutual Fund of Friend Tech
14 
15 // Friendchips gives you exposure to the Friend Tech ecosystem and airdrop, without all the hard work.
16 // We manage the bridging and buying, we all share the rewards.
17 
18 // website - https://www.friendchips.tech/
19 // Telegram - https://t.me/friendchipstoken
20 // Docs - https://friendchips.gitbook.io/friendchips/
21 // Twitter - https://twitter.com/FriendChipsTech
22 
23 
24 pragma solidity 0.6.12;
25 
26 interface IUniswapV2Pair {
27     event Approval(address indexed owner, address indexed spender, uint value);
28     event Transfer(address indexed from, address indexed to, uint value);
29 
30     function name() external pure returns (string memory);
31     function symbol() external pure returns (string memory);
32     function decimals() external pure returns (uint8);
33     function totalSupply() external view returns (uint);
34     function balanceOf(address owner) external view returns (uint);
35     function allowance(address owner, address spender) external view returns (uint);
36 
37     function approve(address spender, uint value) external returns (bool);
38     function transfer(address to, uint value) external returns (bool);
39     function transferFrom(address from, address to, uint value) external returns (bool);
40 
41     function DOMAIN_SEPARATOR() external view returns (bytes32);
42     function PERMIT_TYPEHASH() external pure returns (bytes32);
43     function nonces(address owner) external view returns (uint);
44 
45     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
46 
47     event Mint(address indexed sender, uint amount0, uint amount1);
48     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
49     event Swap(
50         address indexed sender,
51         uint amount0In,
52         uint amount1In,
53         uint amount0Out,
54         uint amount1Out,
55         address indexed to
56     );
57     event Sync(uint112 reserve0, uint112 reserve1);
58 
59     function MINIMUM_LIQUIDITY() external pure returns (uint);
60     function factory() external view returns (address);
61     function token0() external view returns (address);
62     function token1() external view returns (address);
63     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
64     function price0CumulativeLast() external view returns (uint);
65     function price1CumulativeLast() external view returns (uint);
66     function kLast() external view returns (uint);
67 
68     function mint(address to) external returns (uint liquidity);
69     function burn(address to) external returns (uint amount0, uint amount1);
70     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
71     function skim(address to) external;
72     function sync() external;
73 
74     function initialize(address, address) external;
75 }
76 
77 interface IUniswapV2Factory {
78     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
79 
80     function feeTo() external view returns (address);
81     function feeToSetter() external view returns (address);
82 
83     function getPair(address tokenA, address tokenB) external view returns (address pair);
84     function allPairs(uint) external view returns (address pair);
85     function allPairsLength() external view returns (uint);
86 
87     function createPair(address tokenA, address tokenB) external returns (address pair);
88 
89     function setFeeTo(address) external;
90     function setFeeToSetter(address) external;
91 }
92 
93 interface IUniswapV2Router01 {
94     function factory() external pure returns (address);
95     function WETH() external pure returns (address);
96 
97     function addLiquidity(
98         address tokenA,
99         address tokenB,
100         uint amountADesired,
101         uint amountBDesired,
102         uint amountAMin,
103         uint amountBMin,
104         address to,
105         uint deadline
106     ) external returns (uint amountA, uint amountB, uint liquidity);
107     function addLiquidityETH(
108         address token,
109         uint amountTokenDesired,
110         uint amountTokenMin,
111         uint amountETHMin,
112         address to,
113         uint deadline
114     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
115     function removeLiquidity(
116         address tokenA,
117         address tokenB,
118         uint liquidity,
119         uint amountAMin,
120         uint amountBMin,
121         address to,
122         uint deadline
123     ) external returns (uint amountA, uint amountB);
124     function removeLiquidityETH(
125         address token,
126         uint liquidity,
127         uint amountTokenMin,
128         uint amountETHMin,
129         address to,
130         uint deadline
131     ) external returns (uint amountToken, uint amountETH);
132     function removeLiquidityWithPermit(
133         address tokenA,
134         address tokenB,
135         uint liquidity,
136         uint amountAMin,
137         uint amountBMin,
138         address to,
139         uint deadline,
140         bool approveMax, uint8 v, bytes32 r, bytes32 s
141     ) external returns (uint amountA, uint amountB);
142     function removeLiquidityETHWithPermit(
143         address token,
144         uint liquidity,
145         uint amountTokenMin,
146         uint amountETHMin,
147         address to,
148         uint deadline,
149         bool approveMax, uint8 v, bytes32 r, bytes32 s
150     ) external returns (uint amountToken, uint amountETH);
151     function swapExactTokensForTokens(
152         uint amountIn,
153         uint amountOutMin,
154         address[] calldata path,
155         address to,
156         uint deadline
157     ) external returns (uint[] memory amounts);
158     function swapTokensForExactTokens(
159         uint amountOut,
160         uint amountInMax,
161         address[] calldata path,
162         address to,
163         uint deadline
164     ) external returns (uint[] memory amounts);
165     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
166         external
167         payable
168         returns (uint[] memory amounts);
169     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
170         external
171         returns (uint[] memory amounts);
172     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
173         external
174         returns (uint[] memory amounts);
175     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
176         external
177         payable
178         returns (uint[] memory amounts);
179 
180     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
181     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
182     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
183     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
184     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
185 }
186 
187 interface IUniswapV2Router02 is IUniswapV2Router01 {
188     function removeLiquidityETHSupportingFeeOnTransferTokens(
189         address token,
190         uint liquidity,
191         uint amountTokenMin,
192         uint amountETHMin,
193         address to,
194         uint deadline
195     ) external returns (uint amountETH);
196     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
197         address token,
198         uint liquidity,
199         uint amountTokenMin,
200         uint amountETHMin,
201         address to,
202         uint deadline,
203         bool approveMax, uint8 v, bytes32 r, bytes32 s
204     ) external returns (uint amountETH);
205 
206     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
207         uint amountIn,
208         uint amountOutMin,
209         address[] calldata path,
210         address to,
211         uint deadline
212     ) external;
213     function swapExactETHForTokensSupportingFeeOnTransferTokens(
214         uint amountOutMin,
215         address[] calldata path,
216         address to,
217         uint deadline
218     ) external payable;
219     function swapExactTokensForETHSupportingFeeOnTransferTokens(
220         uint amountIn,
221         uint amountOutMin,
222         address[] calldata path,
223         address to,
224         uint deadline
225     ) external;
226 }
227 
228 interface IERC20 {
229   /**
230    * @dev Returns the amount of tokens in existence.
231    */
232   function totalSupply() external view returns (uint256);
233 
234   /**
235    * @dev Returns the amount of tokens owned by `account`.
236    */
237   function balanceOf(address account) external view returns (uint256);
238 
239   /**
240    * @dev Moves `amount` tokens from the caller's account to `recipient`.
241    *
242    * Returns a boolean value indicating whether the operation succeeded.
243    *
244    * Emits a {Transfer} event.
245    */
246   function transfer(address recipient, uint256 amount) external returns (bool);
247 
248   /**
249    * @dev Returns the remaining number of tokens that `spender` will be
250    * allowed to spend on behalf of `owner` through {transferFrom}. This is
251    * zero by default.
252    *
253    * This value changes when {approve} or {transferFrom} are called.
254    */
255   function allowance(address owner, address spender) external view returns (uint256);
256 
257   /**
258    * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
259    *
260    * Returns a boolean value indicating whether the operation succeeded.
261    *
262    * IMPORTANT: Beware that changing an allowance with this method brings the risk
263    * that someone may use both the old and the new allowance by unfortunate
264    * transaction ordering. One possible solution to mitigate this race
265    * condition is to first reduce the spender's allowance to 0 and set the
266    * desired value afterwards:
267    * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
268    *
269    * Emits an {Approval} event.
270    */
271   function approve(address spender, uint256 amount) external returns (bool);
272 
273   /**
274    * @dev Moves `amount` tokens from `sender` to `recipient` using the
275    * allowance mechanism. `amount` is then deducted from the caller's
276    * allowance.
277    *
278    * Returns a boolean value indicating whether the operation succeeded.
279    *
280    * Emits a {Transfer} event.
281    */
282   function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
283 
284   /**
285    * @dev Emitted when `value` tokens are moved from one account (`from`) to
286    * another (`to`).
287    *
288    * Note that `value` may be zero.
289    */
290   event Transfer(address indexed from, address indexed to, uint256 value);
291 
292   /**
293    * @dev Emitted when the allowance of a `spender` for an `owner` is set by
294    * a call to {approve}. `value` is the new allowance.
295    */
296   event Approval(address indexed owner, address indexed spender, uint256 value);
297 }
298 
299 abstract contract Context {
300     function _msgSender() internal view virtual returns (address payable) {
301         return msg.sender;
302     }
303 
304     function _msgData() internal view virtual returns (bytes memory) {
305         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
306         return msg.data;
307     }
308 }
309 
310 /**
311  * @dev Contract module which provides a basic access control mechanism, where
312  * there is an account (an owner) that can be granted exclusive access to
313  * specific functions.
314  *
315  * By default, the owner account will be the one that deploys the contract. This
316  * can later be changed with {transferOwnership}.
317  *
318  * This module is used through inheritance. It will make available the modifier
319  * `onlyOwner`, which can be applied to your functions to restrict their use to
320  * the owner.
321  */
322 abstract contract Ownable is Context {
323     address private _owner;
324 
325     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
326 
327     /**
328      * @dev Initializes the contract setting the deployer as the initial owner.
329      */
330     constructor () internal {
331         address msgSender = _msgSender();
332         _owner = msgSender;
333         emit OwnershipTransferred(address(0), msgSender);
334     }
335 
336     /**
337      * @dev Returns the address of the current owner.
338      */
339     function owner() public view virtual returns (address) {
340         return _owner;
341     }
342 
343     /**
344      * @dev Throws if called by any account other than the owner.
345      */
346     modifier onlyOwner() {
347         require(owner() == _msgSender(), "Ownable: caller is not the owner");
348         _;
349     }
350 
351     /**
352      * @dev Leaves the contract without owner. It will not be possible to call
353      * `onlyOwner` functions anymore. Can only be called by the current owner.
354      *
355      * NOTE: Renouncing ownership will leave the contract without an owner,
356      * thereby removing any functionality that is only available to the owner.
357      */
358     function renounceOwnership() public virtual onlyOwner {
359         emit OwnershipTransferred(_owner, address(0));
360         _owner = address(0);
361     }
362 
363     /**
364      * @dev Transfers ownership of the contract to a new account (`newOwner`).
365      * Can only be called by the current owner.
366      */
367     function transferOwnership(address newOwner) public virtual onlyOwner {
368         require(newOwner != address(0), "Ownable: new owner is the zero address");
369         emit OwnershipTransferred(_owner, newOwner);
370         _owner = newOwner;
371     }
372 }
373 
374 /**
375  * @dev Wrappers over Solidity's arithmetic operations with added overflow
376  * checks.
377  *
378  * Arithmetic operations in Solidity wrap on overflow. This can easily result
379  * in bugs, because programmers usually assume that an overflow raises an
380  * error, which is the standard behavior in high level programming languages.
381  * `SafeMath` restores this intuition by reverting the transaction when an
382  * operation overflows.
383  *
384  * Using this library instead of the unchecked operations eliminates an entire
385  * class of bugs, so it's recommended to use it always.
386  */
387 library SafeMath {
388     /**
389      * @dev Returns the addition of two unsigned integers, with an overflow flag.
390      *
391      * _Available since v3.4._
392      */
393     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
394         uint256 c = a + b;
395         if (c < a) return (false, 0);
396         return (true, c);
397     }
398 
399     /**
400      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
401      *
402      * _Available since v3.4._
403      */
404     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
405         if (b > a) return (false, 0);
406         return (true, a - b);
407     }
408 
409     /**
410      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
411      *
412      * _Available since v3.4._
413      */
414     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
415         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
416         // benefit is lost if 'b' is also tested.
417         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
418         if (a == 0) return (true, 0);
419         uint256 c = a * b;
420         if (c / a != b) return (false, 0);
421         return (true, c);
422     }
423 
424     /**
425      * @dev Returns the division of two unsigned integers, with a division by zero flag.
426      *
427      * _Available since v3.4._
428      */
429     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
430         if (b == 0) return (false, 0);
431         return (true, a / b);
432     }
433 
434     /**
435      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
436      *
437      * _Available since v3.4._
438      */
439     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
440         if (b == 0) return (false, 0);
441         return (true, a % b);
442     }
443 
444     /**
445      * @dev Returns the addition of two unsigned integers, reverting on
446      * overflow.
447      *
448      * Counterpart to Solidity's `+` operator.
449      *
450      * Requirements:
451      *
452      * - Addition cannot overflow.
453      */
454     function add(uint256 a, uint256 b) internal pure returns (uint256) {
455         uint256 c = a + b;
456         require(c >= a, "SafeMath: addition overflow");
457         return c;
458     }
459 
460     /**
461      * @dev Returns the subtraction of two unsigned integers, reverting on
462      * overflow (when the result is negative).
463      *
464      * Counterpart to Solidity's `-` operator.
465      *
466      * Requirements:
467      *
468      * - Subtraction cannot overflow.
469      */
470     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
471         require(b <= a, "SafeMath: subtraction overflow");
472         return a - b;
473     }
474 
475     /**
476      * @dev Returns the multiplication of two unsigned integers, reverting on
477      * overflow.
478      *
479      * Counterpart to Solidity's `*` operator.
480      *
481      * Requirements:
482      *
483      * - Multiplication cannot overflow.
484      */
485     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
486         if (a == 0) return 0;
487         uint256 c = a * b;
488         require(c / a == b, "SafeMath: multiplication overflow");
489         return c;
490     }
491 
492     /**
493      * @dev Returns the integer division of two unsigned integers, reverting on
494      * division by zero. The result is rounded towards zero.
495      *
496      * Counterpart to Solidity's `/` operator. Note: this function uses a
497      * `revert` opcode (which leaves remaining gas untouched) while Solidity
498      * uses an invalid opcode to revert (consuming all remaining gas).
499      *
500      * Requirements:
501      *
502      * - The divisor cannot be zero.
503      */
504     function div(uint256 a, uint256 b) internal pure returns (uint256) {
505         require(b > 0, "SafeMath: division by zero");
506         return a / b;
507     }
508 
509     /**
510      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
511      * reverting when dividing by zero.
512      *
513      * Counterpart to Solidity's `%` operator. This function uses a `revert`
514      * opcode (which leaves remaining gas untouched) while Solidity uses an
515      * invalid opcode to revert (consuming all remaining gas).
516      *
517      * Requirements:
518      *
519      * - The divisor cannot be zero.
520      */
521     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
522         require(b > 0, "SafeMath: modulo by zero");
523         return a % b;
524     }
525 
526     /**
527      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
528      * overflow (when the result is negative).
529      *
530      * CAUTION: This function is deprecated because it requires allocating memory for the error
531      * message unnecessarily. For custom revert reasons use {trySub}.
532      *
533      * Counterpart to Solidity's `-` operator.
534      *
535      * Requirements:
536      *
537      * - Subtraction cannot overflow.
538      */
539     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
540         require(b <= a, errorMessage);
541         return a - b;
542     }
543 
544     /**
545      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
546      * division by zero. The result is rounded towards zero.
547      *
548      * CAUTION: This function is deprecated because it requires allocating memory for the error
549      * message unnecessarily. For custom revert reasons use {tryDiv}.
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
561         return a / b;
562     }
563 
564     /**
565      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
566      * reverting with custom message when dividing by zero.
567      *
568      * CAUTION: This function is deprecated because it requires allocating memory for the error
569      * message unnecessarily. For custom revert reasons use {tryMod}.
570      *
571      * Counterpart to Solidity's `%` operator. This function uses a `revert`
572      * opcode (which leaves remaining gas untouched) while Solidity uses an
573      * invalid opcode to revert (consuming all remaining gas).
574      *
575      * Requirements:
576      *
577      * - The divisor cannot be zero.
578      */
579     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
580         require(b > 0, errorMessage);
581         return a % b;
582     }
583 }
584 
585 /**
586  * @title Roles
587  * @dev Library for managing addresses assigned to a Role.
588  */
589 library Roles {
590     struct Role {
591         mapping (address => bool) bearer;
592     }
593 
594     /**
595      * @dev Give an account access to this role.
596      */
597     function add(Role storage role, address account) internal {
598         require(!has(role, account), "Roles: account already has role");
599         role.bearer[account] = true;
600     }
601 
602     /**
603      * @dev Remove an account's access to this role.
604      */
605     function remove(Role storage role, address account) internal {
606         require(has(role, account), "Roles: account does not have role");
607         role.bearer[account] = false;
608     }
609 
610     /**
611      * @dev Check if an account has this role.
612      * @return bool
613      */
614     function has(Role storage role, address account) internal view returns (bool) {
615         require(account != address(0), "Roles: account is the zero address");
616         return role.bearer[account];
617     }
618 }
619 
620 /**
621  * @title MinterRole
622  * @dev Implementation of the {MinterRole} interface.
623  */
624 contract MinterRole {
625     using Roles for Roles.Role;
626 
627     event MinterAdded(address indexed account);
628     event MinterRemoved(address indexed account);
629 
630     Roles.Role private _minters;
631 
632     constructor () internal {
633         _addMinter(msg.sender);
634     }
635 
636     modifier onlyMinter() {
637         require(isMinter(msg.sender), "MinterRole: caller does not have the Minter role");
638         _;
639     }
640 
641     function isMinter(address account) public view returns (bool) {
642         return _minters.has(account);
643     }
644 
645     function addMinter(address account) public onlyMinter {
646         _addMinter(account);
647     }
648 
649     function removeMinter(address account) public onlyMinter {
650         _removeMinter(account);
651     }
652 
653     function renounceMinter() public {
654         _removeMinter(msg.sender);
655     }
656 
657     function _addMinter(address account) internal {
658         _minters.add(account);
659         emit MinterAdded(account);
660     }
661 
662     function _removeMinter(address account) internal {
663         _minters.remove(account);
664         emit MinterRemoved(account);
665     }
666 }
667 
668 contract ERC20 is Context, IERC20, Ownable {
669     using SafeMath for uint256;
670 
671     mapping(address => uint256) private _balances;
672 
673     mapping(address => mapping(address => uint256)) private _allowances;
674 
675     uint256 private _totalSupply;
676 
677     string private _name;
678     string private _symbol;
679     uint8 private _decimals;
680 
681     uint8 private _setupDecimals = 9;
682 
683     /**
684      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
685      * a default value of 18.
686      *
687      * To select a different value for {decimals}, use {_setupDecimals}.
688      *
689      * All three of these values are immutable: they can only be set once during
690      * construction.
691      */
692     constructor(string memory name, string memory symbol) public {
693         _name = name;
694         _symbol = symbol;
695         _decimals = _setupDecimals;
696     }
697 
698     /**
699      * @dev Returns the bep token owner.
700      */
701     function getOwner() external view returns (address) {
702         return owner();
703     }
704 
705     /**
706      * @dev Returns the name of the token.
707      */
708     function name() public view returns (string memory) {
709         return _name;
710     }
711 
712     /**
713      * @dev Returns the symbol of the token, usually a shorter version of the
714      * name.
715      */
716     function symbol() public view returns (string memory) {
717         return _symbol;
718     }
719 
720     /**
721     * @dev Returns the number of decimals used to get its user representation.
722     */
723     function decimals() public view returns (uint8) {
724         return _decimals;
725     }
726 
727     /**
728      * @dev See {ERC20-totalSupply}.
729      */
730     function totalSupply() public override view returns (uint256) {
731         return _totalSupply;
732     }
733 
734     /**
735      * @dev See {ERC20-balanceOf}.
736      */
737     function balanceOf(address account) virtual public override view returns (uint256) {
738         return _balances[account];
739     }
740 
741     /**
742      * @dev See {ERC20-transfer}.
743      *
744      * Requirements:
745      *
746      * - `recipient` cannot be the zero address.
747      * - the caller must have a balance of at least `amount`.
748      */
749     function transfer(address recipient, uint256 amount) virtual public override returns (bool) {
750         _transfer(_msgSender(), recipient, amount);
751         return true;
752     }
753 
754     /**
755      * @dev See {ERC20-allowance}.
756      */
757     function allowance(address owner, address spender) virtual public override view returns (uint256) {
758         return _allowances[owner][spender];
759     }
760 
761     /**
762      * @dev See {ERC20-approve}.
763      *
764      * Requirements:
765      *
766      * - `spender` cannot be the zero address.
767      */
768     function approve(address spender, uint256 amount) virtual public override returns (bool) {
769         _approve(_msgSender(), spender, amount);
770         return true;
771     }
772 
773     /**
774      * @dev See {ERC20-transferFrom}.
775      *
776      * Emits an {Approval} event indicating the updated allowance. This is not
777      * required by the EIP. See the note at the beginning of {ERC20};
778      *
779      * Requirements:
780      * - `sender` and `recipient` cannot be the zero address.
781      * - `sender` must have a balance of at least `amount`.
782      * - the caller must have allowance for `sender`'s tokens of at least
783      * `amount`.
784      */
785     function transferFrom (address sender, address recipient, uint256 amount) virtual public override returns (bool) {
786         _transfer(sender, recipient, amount);
787         _approve(
788             sender,
789             _msgSender(),
790             _allowances[sender][_msgSender()].sub(amount, 'ERC20: transfer amount exceeds allowance')
791         );
792         return true;
793     }
794 
795     /**
796      * @dev Atomically increases the allowance granted to `spender` by the caller.
797      *
798      * This is an alternative to {approve} that can be used as a mitigation for
799      * problems described in {ERC20-approve}.
800      *
801      * Emits an {Approval} event indicating the updated allowance.
802      *
803      * Requirements:
804      *
805      * - `spender` cannot be the zero address.
806      */
807     function increaseAllowance(address spender, uint256 addedValue) public returns (bool) {
808         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
809         return true;
810     }
811 
812     /**
813      * @dev Atomically decreases the allowance granted to `spender` by the caller.
814      *
815      * This is an alternative to {approve} that can be used as a mitigation for
816      * problems described in {ERC20-approve}.
817      *
818      * Emits an {Approval} event indicating the updated allowance.
819      *
820      * Requirements:
821      *
822      * - `spender` cannot be the zero address.
823      * - `spender` must have allowance for the caller of at least
824      * `subtractedValue`.
825      */
826     function decreaseAllowance(address spender, uint256 subtractedValue) public returns (bool) {
827         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, 'ERC20: decreased allowance below zero'));
828         return true;
829     }
830 
831     /**
832      * @dev Creates `amount` tokens and assigns them to `msg.sender`, increasing
833      * the total supply.
834      *
835      * Requirements
836      *
837      * - `msg.sender` must be the token owner
838      */
839     function mint(uint256 amount) public onlyOwner returns (bool) {
840         _mint(_msgSender(), amount);
841         return true;
842     }
843 
844     /**
845      * @dev Moves tokens `amount` from `sender` to `recipient`.
846      *
847      * This is internal function is equivalent to {transfer}, and can be used to
848      * e.g. implement automatic token fees, slashing mechanisms, etc.
849      *
850      * Emits a {Transfer} event.
851      *
852      * Requirements:
853      *
854      * - `sender` cannot be the zero address.
855      * - `recipient` cannot be the zero address.
856      * - `sender` must have a balance of at least `amount`.
857      */
858     function _transfer (address sender, address recipient, uint256 amount) virtual internal {
859         require(sender != address(0), 'ERC20: transfer from the zero address');
860         require(recipient != address(0), 'ERC20: transfer to the zero address');
861 
862         _balances[sender] = _balances[sender].sub(amount, 'ERC20: transfer amount exceeds balance');
863         _balances[recipient] = _balances[recipient].add(amount);
864         emit Transfer(sender, recipient, amount);
865     }
866 
867     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
868      * the total supply.
869      *
870      * Emits a {Transfer} event with `from` set to the zero address.
871      *
872      * Requirements
873      *
874      * - `to` cannot be the zero address.
875      */
876     function _mint(address account, uint256 amount) virtual internal {
877         require(account != address(0), 'ERC20: mint to the zero address');
878 
879         _totalSupply = _totalSupply.add(amount);
880         _balances[account] = _balances[account].add(amount);
881         emit Transfer(address(0), account, amount);
882     }
883 
884     /**
885      * @dev Destroys `amount` tokens from `account`, reducing the
886      * total supply.
887      *
888      * Emits a {Transfer} event with `to` set to the zero address.
889      *
890      * Requirements
891      *
892      * - `account` cannot be the zero address.
893      * - `account` must have at least `amount` tokens.
894      */
895     function _burn(address account, uint256 amount) virtual internal {
896         require(account != address(0), 'ERC20: burn from the zero address');
897 
898         _balances[account] = _balances[account].sub(amount, 'ERC20: burn amount exceeds balance');
899         _totalSupply = _totalSupply.sub(amount);
900         emit Transfer(account, address(0), amount);
901     }
902 
903     /**
904      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
905      *
906      * This is internal function is equivalent to `approve`, and can be used to
907      * e.g. set automatic allowances for certain subsystems, etc.
908      *
909      * Emits an {Approval} event.
910      *
911      * Requirements:
912      *
913      * - `owner` cannot be the zero address.
914      * - `spender` cannot be the zero address.
915      */
916     function _approve (address owner, address spender, uint256 amount) virtual internal {
917         require(owner != address(0), 'ERC20: approve from the zero address');
918         require(spender != address(0), 'ERC20: approve to the zero address');
919 
920         _allowances[owner][spender] = amount;
921         emit Approval(owner, spender, amount);
922     }
923 
924     /**
925      * @dev Destroys `amount` tokens from `account`.`amount` is then deducted
926      * from the caller's allowance.
927      *
928      * See {_burn} and {_approve}.
929      */
930     // function _burnFrom(address account, uint256 amount) virtual internal {
931     //     _burn(account, amount);
932     //     _approve(account, _msgSender(), _allowances[account][_msgSender()].sub(amount, 'ERC20: burn amount exceeds allowance'));
933     // }
934 }
935 
936 contract Friendchips is ERC20, MinterRole {
937     
938     IUniswapV2Router02 public uniswapV2Router;
939     address public uniswapV2Pair;
940     
941     // The operator is NOT the owner, is the operator of the machine
942     address public operator;
943 
944     // Addresses excluded from fees
945     mapping (address => bool) public isExcludedFromFee;
946     mapping (address => bool) public automatedMarketMakerPairs;
947 
948     // tax Fee Wallet address
949     address public teamWallet;
950     uint256 public teamBuyFee = 5;
951     uint256 public teamSellFee = 5;
952     uint256 public liquidityBuyFee = 1;
953     uint256 public liquiditySellFee = 1;
954     uint256 public buyFee = teamBuyFee.add(liquidityBuyFee);
955     uint256 public sellFee = teamSellFee.add(liquiditySellFee);
956     uint256 public totalFee = buyFee.add(sellFee);
957 
958     uint256 public minSwapAmount = 100000000000;
959     // Trading bool
960     bool public tradingOpen; 
961     // In swap and liquify
962     bool private _inSwapForETH;
963 
964     // Burn address
965     address public constant BURN_ADDRESS = 0x000000000000000000000000000000000000dEaD; // INMUTABLE
966     address public constant V2ROUTER = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
967     address public constant deadAddress = address(0xdead);
968 
969     // Events before Governance
970     event OperatorTransferred(address indexed previousOperator, address indexed newOperator);
971     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
972     event UpdateTeamWallet(address indexed walletAddress);
973     event UpdateBuyFee(uint256 buyFee);
974     event UpdateSellFee(uint256 sellFee);
975 
976     event SwapAndLiquify(
977         uint256 tokensSwapped,
978         uint256 ethReceived,
979         uint256 tokensIntoLiqudity
980     );
981 
982     // Lock the swap on SwapAndLiquify
983     modifier lockTheSwap {
984         _inSwapForETH = true;
985         _;
986         _inSwapForETH = false;
987     }
988 
989     // Operator CAN do modifier
990     modifier onlyOperator() {
991         require(operator == msg.sender, "operator: caller is not the operator");
992         _;
993     }
994     receive() external payable {}
995 
996     /**
997      * @notice Constructs the FRIENDCHIPS token contract.
998      */
999     constructor(address _teamWallet) public ERC20("Friendchips.tech", "FRIENDCHIPS") {
1000         operator = _msgSender();
1001         emit OperatorTransferred(address(0), operator);
1002         
1003         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1004         uniswapV2Router = _uniswapV2Router;
1005         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
1006 
1007         _setAutomatedMarketMakerPair(address(uniswapV2Pair), true);
1008 
1009         require(_teamWallet != address(0), "wallet address is zero");
1010         teamWallet = _teamWallet;
1011 
1012         setExcludeFromFee(msg.sender, true);
1013         setExcludeFromFee(address(this), true);
1014         setExcludeFromFee(address(BURN_ADDRESS), true);
1015     }
1016 
1017 
1018 
1019     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MasterChef).
1020     function mint(address _to, uint256 _amount) public onlyMinter {
1021         _mint(_to, _amount);
1022     }
1023 
1024     function burn(uint256 amount) public virtual {
1025         _burn(msg.sender, amount);
1026     }
1027      
1028     function burnFrom(address account_, uint256 amount_) public virtual {
1029         _burnFrom(account_, amount_);
1030     }
1031 
1032     function _burnFrom(address account_, uint256 amount_) public virtual {
1033         uint256 decreasedAllowance_ =
1034             allowance(account_, msg.sender).sub(
1035                 amount_,
1036                 "ERC20: burn amount exceeds allowance"
1037             );
1038 
1039         _approve(account_, msg.sender, decreasedAllowance_);
1040         _burn(account_, amount_);
1041     }
1042 
1043     /// @dev overrides transfer function to meet tokenomics of FRIENDCHIPS
1044     function _transfer(address sender, address recipient, uint256 amount) internal virtual override {
1045         // Pre-flight checks
1046         require(amount > 0, "Transfer amount must be greater than zero");
1047 
1048         uint256 contractBalance = balanceOf(address(this));
1049         bool canSwap  = contractBalance >= minSwapAmount;
1050         if( 
1051             tradingOpen == true
1052             && _inSwapForETH == false
1053             && canSwap
1054             && !automatedMarketMakerPairs[sender]
1055             && sender != owner() 
1056         ) {
1057             uint256 feeAmount = contractBalance.mul(teamBuyFee.add(teamSellFee)).div(totalFee);
1058             uint256 liquidityTokens = (contractBalance.sub(feeAmount)).div(2);
1059             uint256 amountToSwapForETH = contractBalance.sub(liquidityTokens);
1060             uint256 initialETHBalance = address(this).balance;
1061             swapTokensForEth(amountToSwapForETH);
1062             uint256 ethBalance = address(this).balance.sub(initialETHBalance);
1063             uint256 ethForTeam = ethBalance.mul(teamBuyFee.add(teamSellFee)).div(
1064                 totalFee
1065             );
1066 
1067             uint256 ethForLiquidity = ethBalance.sub(ethForTeam);
1068             if (liquidityTokens > 0 && ethForLiquidity > 0) {
1069                 addLiquidity(liquidityTokens, ethForLiquidity);
1070                 emit SwapAndLiquify(
1071                     amountToSwapForETH,
1072                     ethForLiquidity,
1073                     liquidityTokens
1074                 );
1075             }
1076             payable(address(teamWallet)).transfer(address(this).balance);
1077         }
1078         if (sender == owner() || recipient == owner() || isExcludedFromFee[sender] || isExcludedFromFee[recipient]) {
1079             super._transfer(sender, recipient, amount);
1080         } else {
1081             require(tradingOpen == true, "Trading is not yet open.");
1082 
1083             uint256 sendAmount = amount;
1084             uint256 feeAmount;
1085             //Buy Token
1086             if(automatedMarketMakerPairs[sender] && buyFee > 0) {
1087                 feeAmount = amount.mul(buyFee).div(100);
1088                 sendAmount = amount.sub(feeAmount);
1089             }
1090             //Sell Token
1091             if(automatedMarketMakerPairs[recipient] && sellFee > 0) {
1092                 feeAmount = amount.mul(sellFee).div(100);
1093                 sendAmount = amount.sub(feeAmount);
1094             }
1095             if(feeAmount > 0) {
1096                 super._transfer(sender, address(this), feeAmount);
1097             }
1098             super._transfer(sender, recipient, sendAmount);
1099         }
1100     }
1101 
1102     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private lockTheSwap{
1103         _approve(address(this), address(uniswapV2Router), tokenAmount);
1104 
1105         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1106             address(this),
1107             tokenAmount,
1108             0,
1109             0,
1110             deadAddress,
1111             block.timestamp + 400
1112         );
1113     }
1114 
1115     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap {
1116 
1117         address[] memory path = new address[](2);
1118         path[0] = address(this);
1119         path[1] = uniswapV2Router.WETH();
1120 
1121         _approve(address(this), address(uniswapV2Router), tokenAmount);
1122 
1123         // make the swap
1124         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1125             tokenAmount,
1126             0,
1127             path,
1128             address(this),
1129             block.timestamp + 400
1130         );
1131     }
1132 
1133 
1134     function transferOperator(address newOperator) public onlyOperator {
1135         require(newOperator != address(0), "FRIENDCHIPS::transferOperator: new operator is the zero address");
1136         emit OperatorTransferred(operator, newOperator);
1137         operator = newOperator;
1138     }
1139     
1140     function openTrading(bool bOpen) public onlyOperator {
1141         // Can open trading only once!
1142         tradingOpen = bOpen;
1143         _approve(address(this), V2ROUTER, type(uint).max);
1144     }
1145 
1146     function setAutomatedMarketMakerPair(address pair, bool value) public onlyOwner {
1147         require(pair != uniswapV2Pair, "The pair cannot be removed from automatedMarketMakerPairs");
1148 
1149         _setAutomatedMarketMakerPair(pair, value);
1150     }
1151 
1152     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1153         automatedMarketMakerPairs[pair] = value;
1154 
1155         emit SetAutomatedMarketMakerPair(pair, value);
1156     }
1157     function setExcludeFromFee(address _account, bool _bool) public onlyOperator {
1158         isExcludedFromFee[_account] = _bool;
1159     }
1160 
1161     /** 
1162      * @dev Update the dev wallet Address.
1163      * Can only be called by the current operator.
1164      */
1165     function updateTeamWallet(address payable _teamWallet) public onlyOwner {
1166         require( _teamWallet != address(0), "FRIENDCHIPS:: tax fee address is zero" );
1167         emit UpdateTeamWallet(_teamWallet);
1168         teamWallet = _teamWallet;
1169     }
1170 
1171     function updateBuyFee(uint256 _teamFee, uint256 _liquidityFee) public onlyOwner {
1172         require( _teamFee.add(_liquidityFee) <= 100, "FRIENDCHIPS:: Buy Fee can't exceed 100%" );
1173         emit UpdateBuyFee(_teamFee.add(_liquidityFee));
1174         teamBuyFee = _teamFee;
1175         liquidityBuyFee = _liquidityFee;
1176         buyFee = _teamFee.add(_liquidityFee);
1177         totalFee = buyFee.add(sellFee);
1178     }
1179 
1180     function updateSellFee(uint256 _teamFee, uint256 _liquidityFee) public onlyOwner {
1181         require( _teamFee.add(_liquidityFee) <= 100, "FRIENDCHIPS:: Sell Fee can't exceed 100%");
1182         emit UpdateSellFee(_teamFee.add(_liquidityFee));
1183         teamSellFee = _teamFee;
1184         liquiditySellFee = _liquidityFee;
1185         sellFee = _teamFee.add(_liquidityFee);
1186         totalFee = buyFee.add(sellFee);
1187     }
1188 
1189     function updateMinSwapAmount(uint256 _minSwapAmount) public onlyOperator {
1190         minSwapAmount = _minSwapAmount;
1191     }
1192 
1193     function approveToRouter(uint256 _amount) public onlyOperator {
1194         _approve(address(this), V2ROUTER, _amount);
1195     }
1196 }