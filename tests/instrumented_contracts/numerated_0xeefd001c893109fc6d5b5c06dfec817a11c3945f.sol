1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.6.0;
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with GSN meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address payable) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes memory) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 /**
26  * @dev Interface of the ERC20 standard as defined in the EIP.
27  */
28 interface IERC20 {
29     /**
30      * @dev Returns the amount of tokens in existence.
31      */
32     function totalSupply() external view returns (uint256);
33 
34     /**
35      * @dev Returns the amount of tokens owned by `account`.
36      */
37     function balanceOf(address account) external view returns (uint256);
38 
39     /**
40      * @dev Moves `amount` tokens from the caller's account to `recipient`.
41      *
42      * Returns a boolean value indicating whether the operation succeeded.
43      *
44      * Emits a {Transfer} event.
45      */
46     function transfer(address recipient, uint256 amount) external returns (bool);
47 
48     /**
49      * @dev Returns the remaining number of tokens that `spender` will be
50      * allowed to spend on behalf of `owner` through {transferFrom}. This is
51      * zero by default.
52      *
53      * This value changes when {approve} or {transferFrom} are called.
54      */
55     function allowance(address owner, address spender) external view returns (uint256);
56 
57     /**
58      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * IMPORTANT: Beware that changing an allowance with this method brings the risk
63      * that someone may use both the old and the new allowance by unfortunate
64      * transaction ordering. One possible solution to mitigate this race
65      * condition is to first reduce the spender's allowance to 0 and set the
66      * desired value afterwards:
67      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
68      *
69      * Emits an {Approval} event.
70      */
71     function approve(address spender, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Moves `amount` tokens from `sender` to `recipient` using the
75      * allowance mechanism. `amount` is then deducted from the caller's
76      * allowance.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transferFrom(
83         address sender,
84         address recipient,
85         uint256 amount
86     ) external returns (bool);
87 
88     /**
89      * @dev Emitted when `value` tokens are moved from one account (`from`) to
90      * another (`to`).
91      *
92      * Note that `value` may be zero.
93      */
94     event Transfer(address indexed from, address indexed to, uint256 value);
95 
96     /**
97      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
98      * a call to {approve}. `value` is the new allowance.
99      */
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 /**
104  * @dev Wrappers over Solidity's arithmetic operations with added overflow
105  * checks.
106  *
107  * Arithmetic operations in Solidity wrap on overflow. This can easily result
108  * in bugs, because programmers usually assume that an overflow raises an
109  * error, which is the standard behavior in high level programming languages.
110  * `SafeMath` restores this intuition by reverting the transaction when an
111  * operation overflows.
112  *
113  * Using this library instead of the unchecked operations eliminates an entire
114  * class of bugs, so it's recommended to use it always.
115  */
116 library SafeMath {
117     /**
118      * @dev Returns the addition of two unsigned integers, reverting on
119      * overflow.
120      *
121      * Counterpart to Solidity's `+` operator.
122      *
123      * Requirements:
124      *
125      * - Addition cannot overflow.
126      */
127     function add(uint256 a, uint256 b) internal pure returns (uint256) {
128         uint256 c = a + b;
129         require(c >= a, 'SafeMath: addition overflow');
130 
131         return c;
132     }
133 
134     /**
135      * @dev Returns the subtraction of two unsigned integers, reverting on
136      * overflow (when the result is negative).
137      *
138      * Counterpart to Solidity's `-` operator.
139      *
140      * Requirements:
141      *
142      * - Subtraction cannot overflow.
143      */
144     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
145         return sub(a, b, 'SafeMath: subtraction overflow');
146     }
147 
148     /**
149      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
150      * overflow (when the result is negative).
151      *
152      * Counterpart to Solidity's `-` operator.
153      *
154      * Requirements:
155      *
156      * - Subtraction cannot overflow.
157      */
158     function sub(
159         uint256 a,
160         uint256 b,
161         string memory errorMessage
162     ) internal pure returns (uint256) {
163         require(b <= a, errorMessage);
164         uint256 c = a - b;
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the multiplication of two unsigned integers, reverting on
171      * overflow.
172      *
173      * Counterpart to Solidity's `*` operator.
174      *
175      * Requirements:
176      *
177      * - Multiplication cannot overflow.
178      */
179     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
180         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
181         // benefit is lost if 'b' is also tested.
182         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
183         if (a == 0) {
184             return 0;
185         }
186 
187         uint256 c = a * b;
188         require(c / a == b, 'SafeMath: multiplication overflow');
189 
190         return c;
191     }
192 
193     /**
194      * @dev Returns the integer division of two unsigned integers. Reverts on
195      * division by zero. The result is rounded towards zero.
196      *
197      * Counterpart to Solidity's `/` operator. Note: this function uses a
198      * `revert` opcode (which leaves remaining gas untouched) while Solidity
199      * uses an invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      *
203      * - The divisor cannot be zero.
204      */
205     function div(uint256 a, uint256 b) internal pure returns (uint256) {
206         return div(a, b, 'SafeMath: division by zero');
207     }
208 
209     /**
210      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
211      * division by zero. The result is rounded towards zero.
212      *
213      * Counterpart to Solidity's `/` operator. Note: this function uses a
214      * `revert` opcode (which leaves remaining gas untouched) while Solidity
215      * uses an invalid opcode to revert (consuming all remaining gas).
216      *
217      * Requirements:
218      *
219      * - The divisor cannot be zero.
220      */
221     function div(
222         uint256 a,
223         uint256 b,
224         string memory errorMessage
225     ) internal pure returns (uint256) {
226         require(b > 0, errorMessage);
227         uint256 c = a / b;
228         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
229 
230         return c;
231     }
232 
233     /**
234      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
235      * Reverts when dividing by zero.
236      *
237      * Counterpart to Solidity's `%` operator. This function uses a `revert`
238      * opcode (which leaves remaining gas untouched) while Solidity uses an
239      * invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
246         return mod(a, b, 'SafeMath: modulo by zero');
247     }
248 
249     /**
250      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
251      * Reverts with custom message when dividing by zero.
252      *
253      * Counterpart to Solidity's `%` operator. This function uses a `revert`
254      * opcode (which leaves remaining gas untouched) while Solidity uses an
255      * invalid opcode to revert (consuming all remaining gas).
256      *
257      * Requirements:
258      *
259      * - The divisor cannot be zero.
260      */
261     function mod(
262         uint256 a,
263         uint256 b,
264         string memory errorMessage
265     ) internal pure returns (uint256) {
266         require(b != 0, errorMessage);
267         return a % b;
268     }
269 }
270 
271 /**
272  * @dev Collection of functions related to the address type
273  */
274 library Address {
275     /**
276      * @dev Returns true if `account` is a contract.
277      *
278      * [IMPORTANT]
279      * ====
280      * It is unsafe to assume that an address for which this function returns
281      * false is an externally-owned account (EOA) and not a contract.
282      *
283      * Among others, `isContract` will return false for the following
284      * types of addresses:
285      *
286      *  - an externally-owned account
287      *  - a contract in construction
288      *  - an address where a contract will be created
289      *  - an address where a contract lived, but was destroyed
290      * ====
291      */
292     function isContract(address account) internal view returns (bool) {
293         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
294         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
295         // for accounts without code, i.e. `keccak256('')`
296         bytes32 codehash;
297 
298         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
299         // solhint-disable-next-line no-inline-assembly
300         assembly {
301             codehash := extcodehash(account)
302         }
303         return (codehash != accountHash && codehash != 0x0);
304     }
305 
306     /**
307      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
308      * `recipient`, forwarding all available gas and reverting on errors.
309      *
310      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
311      * of certain opcodes, possibly making contracts go over the 2300 gas limit
312      * imposed by `transfer`, making them unable to receive funds via
313      * `transfer`. {sendValue} removes this limitation.
314      *
315      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
316      *
317      * IMPORTANT: because control is transferred to `recipient`, care must be
318      * taken to not create reentrancy vulnerabilities. Consider using
319      * {ReentrancyGuard} or the
320      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
321      */
322     function sendValue(address payable recipient, uint256 amount) internal {
323         require(address(this).balance >= amount, 'Address: insufficient balance');
324 
325         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
326         (bool success, ) = recipient.call{value: amount}('');
327         require(success, 'Address: unable to send value, recipient may have reverted');
328     }
329 
330     /**
331      * @dev Performs a Solidity function call using a low level `call`. A
332      * plain`call` is an unsafe replacement for a function call: use this
333      * function instead.
334      *
335      * If `target` reverts with a revert reason, it is bubbled up by this
336      * function (like regular Solidity function calls).
337      *
338      * Returns the raw returned data. To convert to the expected return value,
339      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
340      *
341      * Requirements:
342      *
343      * - `target` must be a contract.
344      * - calling `target` with `data` must not revert.
345      *
346      * _Available since v3.1._
347      */
348     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
349         return functionCall(target, data, 'Address: low-level call failed');
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
354      * `errorMessage` as a fallback revert reason when `target` reverts.
355      *
356      * _Available since v3.1._
357      */
358     function functionCall(
359         address target,
360         bytes memory data,
361         string memory errorMessage
362     ) internal returns (bytes memory) {
363         return _functionCallWithValue(target, data, 0, errorMessage);
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
368      * but also transferring `value` wei to `target`.
369      *
370      * Requirements:
371      *
372      * - the calling contract must have an ETH balance of at least `value`.
373      * - the called Solidity function must be `payable`.
374      *
375      * _Available since v3.1._
376      */
377     function functionCallWithValue(
378         address target,
379         bytes memory data,
380         uint256 value
381     ) internal returns (bytes memory) {
382         return functionCallWithValue(target, data, value, 'Address: low-level call with value failed');
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
387      * with `errorMessage` as a fallback revert reason when `target` reverts.
388      *
389      * _Available since v3.1._
390      */
391     function functionCallWithValue(
392         address target,
393         bytes memory data,
394         uint256 value,
395         string memory errorMessage
396     ) internal returns (bytes memory) {
397         require(address(this).balance >= value, 'Address: insufficient balance for call');
398         return _functionCallWithValue(target, data, value, errorMessage);
399     }
400 
401     function _functionCallWithValue(
402         address target,
403         bytes memory data,
404         uint256 weiValue,
405         string memory errorMessage
406     ) private returns (bytes memory) {
407         require(isContract(target), 'Address: call to non-contract');
408 
409         // solhint-disable-next-line avoid-low-level-calls
410         (bool success, bytes memory returndata) = target.call{value: weiValue}(data);
411         if (success) {
412             return returndata;
413         } else {
414             // Look for revert reason and bubble it up if present
415             if (returndata.length > 0) {
416                 // The easiest way to bubble the revert reason is using memory via assembly
417 
418                 // solhint-disable-next-line no-inline-assembly
419                 assembly {
420                     let returndata_size := mload(returndata)
421                     revert(add(32, returndata), returndata_size)
422                 }
423             } else {
424                 revert(errorMessage);
425             }
426         }
427     }
428 }
429 
430 /**
431  * @dev Contract module which provides a basic access control mechanism, where
432  * there is an account (an owner) that can be granted exclusive access to
433  * specific functions.
434  *
435  * By default, the owner account will be the one that deploys the contract. This
436  * can later be changed with {transferOwnership}.
437  *
438  * This module is used through inheritance. It will make available the modifier
439  * `onlyOwner`, which can be applied to your functions to restrict their use to
440  * the owner.
441  */
442 contract Ownable is Context {
443     address private _owner;
444 
445     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
446 
447     /**
448      * @dev Initializes the contract setting the deployer as the initial owner.
449      */
450     constructor() internal {
451         address msgSender = _msgSender();
452         _owner = msgSender;
453         emit OwnershipTransferred(address(0), msgSender);
454     }
455 
456     /**
457      * @dev Returns the address of the current owner.
458      */
459     function owner() public view returns (address) {
460         return _owner;
461     }
462 
463     /**
464      * @dev Throws if called by any account other than the owner.
465      */
466     modifier onlyOwner() {
467         require(_owner == _msgSender(), 'Ownable: caller is not the owner');
468         _;
469     }
470 
471     /**
472      * @dev Leaves the contract without owner. It will not be possible to call
473      * `onlyOwner` functions anymore. Can only be called by the current owner.
474      *
475      * NOTE: Renouncing ownership will leave the contract without an owner,
476      * thereby removing any functionality that is only available to the owner.
477      */
478     function renounceOwnership() public virtual onlyOwner {
479         emit OwnershipTransferred(_owner, address(0));
480         _owner = address(0);
481     }
482 
483     /**
484      * @dev Transfers ownership of the contract to a new account (`newOwner`).
485      * Can only be called by the current owner.
486      */
487     function transferOwnership(address newOwner) public virtual onlyOwner {
488         require(newOwner != address(0), 'Ownable: new owner is the zero address');
489         emit OwnershipTransferred(_owner, newOwner);
490         _owner = newOwner;
491     }
492 }
493 
494 interface IUniswapV2Factory {
495     function createPair(address tokenA, address tokenB) external returns (address pair);
496 }
497 
498 interface IUniswapV2Pair {
499     function sync() external;
500 }
501 
502 interface IUniswapV2Router01 {
503     function factory() external pure returns (address);
504 
505     function WETH() external pure returns (address);
506 
507     function addLiquidity(
508         address tokenA,
509         address tokenB,
510         uint256 amountADesired,
511         uint256 amountBDesired,
512         uint256 amountAMin,
513         uint256 amountBMin,
514         address to,
515         uint256 deadline
516     )
517         external
518         returns (
519             uint256 amountA,
520             uint256 amountB,
521             uint256 liquidity
522         );
523 
524     function addLiquidityETH(
525         address token,
526         uint256 amountTokenDesired,
527         uint256 amountTokenMin,
528         uint256 amountETHMin,
529         address to,
530         uint256 deadline
531     )
532         external
533         payable
534         returns (
535             uint256 amountToken,
536             uint256 amountETH,
537             uint256 liquidity
538         );
539 }
540 
541 interface IUniswapV2Router02 is IUniswapV2Router01 {
542     function removeLiquidityETHSupportingFeeOnTransferTokens(
543         address token,
544         uint256 liquidity,
545         uint256 amountTokenMin,
546         uint256 amountETHMin,
547         address to,
548         uint256 deadline
549     ) external returns (uint256 amountETH);
550 
551     function swapExactTokensForETHSupportingFeeOnTransferTokens(
552         uint256 amountIn,
553         uint256 amountOutMin,
554         address[] calldata path,
555         address to,
556         uint256 deadline
557     ) external;
558 
559     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
560         uint256 amountIn,
561         uint256 amountOutMin,
562         address[] calldata path,
563         address to,
564         uint256 deadline
565     ) external;
566 
567     function swapExactETHForTokensSupportingFeeOnTransferTokens(
568         uint256 amountOutMin,
569         address[] calldata path,
570         address to,
571         uint256 deadline
572     ) external payable;
573 }
574 
575 pragma solidity ^0.6.0;
576 
577 abstract contract ReentrancyGuard {
578     uint256 private constant _NOT_ENTERED = 1;
579     uint256 private constant _ENTERED = 2;
580 
581     uint256 private _status;
582 
583     constructor() public {
584         _status = _NOT_ENTERED;
585     }
586 
587     modifier nonReentrant() {
588         require(_status != _ENTERED, 'ReentrancyGuard: reentrant call');
589         _status = _ENTERED;
590         _;
591         _status = _NOT_ENTERED;
592     }
593 
594     modifier isHuman() {
595         require(tx.origin == msg.sender, 'sorry humans only');
596         _;
597     }
598 }
599 
600 pragma solidity ^0.6.0;
601 
602 library TransferHelper {
603     function safeApprove(
604         address token,
605         address to,
606         uint256 value
607     ) internal {
608         // bytes4(keccak256(bytes('approve(address,uint256)')));
609         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x095ea7b3, to, value));
610         require(
611             success && (data.length == 0 || abi.decode(data, (bool))),
612             'TransferHelper::safeApprove: approve failed'
613         );
614     }
615 
616     function safeTransfer(
617         address token,
618         address to,
619         uint256 value
620     ) internal {
621         // bytes4(keccak256(bytes('transfer(address,uint256)')));
622         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0xa9059cbb, to, value));
623         require(
624             success && (data.length == 0 || abi.decode(data, (bool))),
625             'TransferHelper::safeTransfer: transfer failed'
626         );
627     }
628 
629     function safeTransferFrom(
630         address token,
631         address from,
632         address to,
633         uint256 value
634     ) internal {
635         // bytes4(keccak256(bytes('transferFrom(address,address,uint256)')));
636         (bool success, bytes memory data) = token.call(abi.encodeWithSelector(0x23b872dd, from, to, value));
637         require(
638             success && (data.length == 0 || abi.decode(data, (bool))),
639             'TransferHelper::transferFrom: transferFrom failed'
640         );
641     }
642 
643     function safeTransferETH(address to, uint256 value) internal {
644         (bool success, ) = to.call{value: value}(new bytes(0));
645         require(success, 'TransferHelper::safeTransferETH: ETH transfer failed');
646     }
647 }
648 
649 interface IPinkAntiBot {
650   function setTokenOwner(address owner) external;
651 
652   function onPreTransferCheck(
653     address from,
654     address to,
655     uint256 amount
656   ) external;
657 }
658 
659 contract GhostInu is Context, IERC20, Ownable, ReentrancyGuard {
660     using SafeMath for uint256;
661     using Address for address;
662     using TransferHelper for address;
663 
664     string private _name = 'GhostInu';
665     string private _symbol = 'GHOST';
666     uint8 private _decimals = 9;
667 
668     mapping(address => uint256) internal _reflectionBalance;
669     mapping(address => uint256) internal _tokenBalance;
670     mapping(address => mapping(address => uint256)) internal _allowances;
671 
672     uint256 private constant MAX = ~uint256(0);
673     uint256 internal _tokenTotal = 1_000_000_000_000e9;
674     uint256 internal _reflectionTotal = (MAX - (MAX % _tokenTotal));
675 
676     mapping(address => bool) public isTaxless;
677     mapping(address => bool) internal _isExcluded;
678     address[] internal _excluded;
679 
680     uint256 public _feeDecimal = 2;
681     // index 0 = buy fee, index 1 = sell fee, index 2 = p2p fee
682     uint256[] public _teamFee;
683     uint256[] public _marketingFee;
684 
685     uint256 internal _feeTotal;
686     uint256 internal _marketingFeeCollected;
687     uint256 internal _teamFeeCollected;
688 
689     bool public isFeeActive = false; // should be true
690     bool private inSwap;
691     bool public swapEnabled = true;
692 
693     uint256 public maxWalletAmount = _tokenTotal.mul(3).div(1000); // 0.5%
694     uint256 public minTokensBeforeSwap = 1_000_000e9;
695 
696     address public marketingWallet;
697     address public teamWallet;
698 
699     IUniswapV2Router02 public router;
700     address public pair;
701 
702     event SwapUpdated(bool enabled);
703     event Swap(uint256 swaped, uint256 recieved);
704 
705     modifier lockTheSwap() {
706         inSwap = true;
707         _;
708         inSwap = false;
709     }
710 
711     constructor() public {
712         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
713         pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
714         router = _uniswapV2Router;
715         marketingWallet = 0x96067820B26B74749a9A9Ba8Ea6ba25d2F71f57D;
716         teamWallet = 0x1C2d58eb3D7926702a4632F75612E941F37F3251;
717         
718         isTaxless[msg.sender] = true;
719         isTaxless[teamWallet] = true;
720         isTaxless[marketingWallet] = true;
721         isTaxless[address(this)] = true;
722 
723         
724         _reflectionBalance[msg.sender] = _reflectionTotal;
725         emit Transfer(address(0),msg.sender, _tokenTotal);
726 
727         _teamFee.push(1000);
728         _teamFee.push(1500);
729         _teamFee.push(1000);
730 
731         _marketingFee.push(500);
732         _marketingFee.push(600);
733         _marketingFee.push(500);
734     }
735 
736     function name() public view returns (string memory) {
737         return _name;
738     }
739 
740     function symbol() public view returns (string memory) {
741         return _symbol;
742     }
743 
744     function decimals() public view returns (uint8) {
745         return _decimals;
746     }
747 
748     function totalSupply() public view override returns (uint256) {
749         return _tokenTotal;
750     }
751 
752     function balanceOf(address account) public view override returns (uint256) {
753         if (_isExcluded[account]) return _tokenBalance[account];
754         return tokenFromReflection(_reflectionBalance[account]);
755     }
756 
757     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
758         _transfer(_msgSender(), recipient, amount);
759         return true;
760     }
761 
762     function allowance(address owner, address spender) public view override returns (uint256) {
763         return _allowances[owner][spender];
764     }
765 
766     function approve(address spender, uint256 amount) public override returns (bool) {
767         _approve(_msgSender(), spender, amount);
768         return true;
769     }
770 
771     function transferFrom(
772         address sender,
773         address recipient,
774         uint256 amount
775     ) public virtual override returns (bool) {
776         _transfer(sender, recipient, amount);
777 
778         _approve(
779             sender,
780             _msgSender(),
781             _allowances[sender][_msgSender()].sub(amount, 'ERC20: transfer amount exceeds allowance')
782         );
783         return true;
784     }
785 
786     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
787         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
788         return true;
789     }
790 
791     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
792         _approve(
793             _msgSender(),
794             spender,
795             _allowances[_msgSender()][spender].sub(subtractedValue, 'ERC20: decreased allowance below zero')
796         );
797         return true;
798     }
799 
800     function isExcluded(address account) public view returns (bool) {
801         return _isExcluded[account];
802     }
803 
804     function reflectionFromToken(uint256 tokenAmount) public view returns (uint256) {
805         require(tokenAmount <= _tokenTotal, 'Amount must be less than supply');
806         return tokenAmount.mul(_getReflectionRate());
807     }
808 
809     function tokenFromReflection(uint256 reflectionAmount) public view returns (uint256) {
810         require(reflectionAmount <= _reflectionTotal, 'Amount must be less than total reflections');
811         uint256 currentRate = _getReflectionRate();
812         return reflectionAmount.div(currentRate);
813     }
814 
815     function _approve(
816         address owner,
817         address spender,
818         uint256 amount
819     ) private {
820         require(owner != address(0), 'ERC20: approve from the zero address');
821         require(spender != address(0), 'ERC20: approve to the zero address');
822 
823         _allowances[owner][spender] = amount;
824         emit Approval(owner, spender, amount);
825     }
826 
827     function _transfer(
828         address sender,
829         address recipient,
830         uint256 amount
831     ) private {
832         require(sender != address(0), 'ERC20: transfer from the zero address');
833         require(recipient != address(0), 'ERC20: transfer to the zero address');
834         require(amount > 0, 'Transfer amount must be greater than zero');
835 
836         require(isTaxless[sender] || isTaxless[recipient] || recipient == pair || balanceOf(recipient).add(amount) <= maxWalletAmount, 'Max Wallet Limit Exceeds!');
837 
838         if (swapEnabled && !inSwap && sender != pair) {
839             swap();
840         }
841 
842         uint256 transferAmount = amount;
843         uint256 rate = _getReflectionRate();
844 
845         if (isFeeActive && !isTaxless[sender] && !isTaxless[recipient] && !inSwap) {
846             transferAmount = collectFee(sender, amount, rate, recipient == pair, sender != pair && recipient != pair);
847         }
848 
849         //transfer reflection
850         _reflectionBalance[sender] = _reflectionBalance[sender].sub(amount.mul(rate));
851         _reflectionBalance[recipient] = _reflectionBalance[recipient].add(transferAmount.mul(rate));
852 
853         //if any account belongs to the excludedAccount transfer token
854         if (_isExcluded[sender]) {
855             _tokenBalance[sender] = _tokenBalance[sender].sub(amount);
856         }
857         if (_isExcluded[recipient]) {
858             _tokenBalance[recipient] = _tokenBalance[recipient].add(transferAmount);
859         }
860 
861         emit Transfer(sender, recipient, transferAmount);
862     }
863 
864     function calculateFee(uint256 feeIndex, uint256 amount) internal returns(uint256) {
865         uint256 marketingFee = amount.mul(_marketingFee[feeIndex]).div(10**(_feeDecimal + 2));
866         uint256 teamFee = amount.mul(_teamFee[feeIndex]).div(10**(_feeDecimal + 2));
867         
868         _marketingFeeCollected = _marketingFeeCollected.add(marketingFee);
869         _teamFeeCollected = _teamFeeCollected.add(teamFee);
870         return marketingFee.add(teamFee);
871     }
872 
873     function collectFee(
874         address account,
875         uint256 amount,
876         uint256 rate,
877         bool sell,
878         bool p2p
879     ) private returns (uint256) {
880         uint256 transferAmount = amount;
881 
882         uint256 otherFee = calculateFee(p2p ? 2 : sell ? 1 : 0, amount);
883         if(otherFee != 0) 
884         {
885             transferAmount = transferAmount.sub(otherFee);
886             _reflectionBalance[address(this)] = _reflectionBalance[address(this)].add(otherFee.mul(rate));
887             if (_isExcluded[address(this)]) {
888                 _tokenBalance[address(this)] = _tokenBalance[address(this)].add(otherFee);
889             }
890             emit Transfer(account, address(this), otherFee);
891         }
892         _feeTotal = _feeTotal.add(otherFee);
893         return transferAmount;
894     }
895 
896     function swap() private lockTheSwap {
897         uint256 totalFee = _teamFeeCollected.add(_marketingFeeCollected);
898 
899         if(minTokensBeforeSwap > totalFee) return;
900 
901         address[] memory sellPath = new address[](2);
902         sellPath[0] = address(this);
903         sellPath[1] = router.WETH();       
904 
905         uint256 balanceBefore = address(this).balance;
906 
907         _approve(address(this), address(router), totalFee);
908         router.swapExactTokensForETHSupportingFeeOnTransferTokens(
909             totalFee,
910             0,
911             sellPath,
912             address(this),
913             block.timestamp
914         );
915 
916         uint256 amountFee = address(this).balance.sub(balanceBefore);
917         
918         uint256 amountMarketing = amountFee.mul(_marketingFeeCollected).div(totalFee);
919         if(amountMarketing > 0) payable(marketingWallet).transfer(amountMarketing);
920 
921         uint256 amountTeam = address(this).balance;
922         if(amountTeam > 0) payable(teamWallet).transfer(address(this).balance);
923         
924         _marketingFeeCollected = 0;
925         _teamFeeCollected = 0;
926 
927         emit Swap(totalFee, amountFee);
928     }
929 
930     function _getReflectionRate() private view returns (uint256) {
931         uint256 reflectionSupply = _reflectionTotal;
932         uint256 tokenSupply = _tokenTotal;
933         for (uint256 i = 0; i < _excluded.length; i++) {
934             if (_reflectionBalance[_excluded[i]] > reflectionSupply || _tokenBalance[_excluded[i]] > tokenSupply)
935                 return _reflectionTotal.div(_tokenTotal);
936             reflectionSupply = reflectionSupply.sub(_reflectionBalance[_excluded[i]]);
937             tokenSupply = tokenSupply.sub(_tokenBalance[_excluded[i]]);
938         }
939         if (reflectionSupply < _reflectionTotal.div(_tokenTotal)) return _reflectionTotal.div(_tokenTotal);
940         return reflectionSupply.div(tokenSupply);
941     }
942 
943     function setPairAndRouter(address _pair, IUniswapV2Router02 _router) external onlyOwner {
944         pair = _pair;
945         router = _router;
946     }
947 
948     function setTaxless(address account, bool value) external onlyOwner {
949         isTaxless[account] = value;
950     }
951 
952     function setSwapEnabled(bool enabled) external onlyOwner {
953         swapEnabled = enabled;
954         SwapUpdated(enabled);
955     }
956 
957     function setFeeActive(bool value) external onlyOwner {
958         isFeeActive = value;
959     }
960 
961     function setTeamFee(uint256 buy, uint256 sell, uint256 p2p) external onlyOwner {
962         _teamFee[0] = buy;
963         _teamFee[1] = sell;
964         _teamFee[2] = p2p;
965     }
966 
967     function setMarketingFee(uint256 buy, uint256 sell, uint256 p2p) external onlyOwner {
968         _marketingFee[0] = buy;
969         _marketingFee[1] = sell;
970         _marketingFee[2] = p2p;
971     }
972 
973     function setMarketingWallet(address wallet) external onlyOwner {
974         marketingWallet = wallet;
975     }
976 
977     function setTeamWallet(address wallet)  external onlyOwner {
978         teamWallet = wallet;
979     }
980 
981     function setMaxWalletAmount(uint256 percentage) external onlyOwner {
982         maxWalletAmount = _tokenTotal.mul(percentage).div(10000);
983     }
984 
985     function setMinTokensBeforeSwap(uint256 amount) external onlyOwner {
986         minTokensBeforeSwap = amount;
987     }
988 
989     receive() external payable {}
990 }