1 /*
2   Unless required by applicable law or agreed to in writing, software
3   distributed under the License is distributed on an "AS IS" BASIS,
4   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
5   See the License for the specific language governing permissions and
6   limitations under the License.
7 */
8 // SPDX-License-Identifier: MIT
9 // import "hardhat/console.sol";
10 pragma solidity ^0.6.12;
11 
12 library AddrArrayLib {
13     using AddrArrayLib for Addresses;
14     struct Addresses {
15         address[] _items;
16         mapping(address => int) map;
17     }
18 
19     function removeAll(Addresses storage self) internal {
20         delete self._items;
21     }
22 
23     function pushAddress(Addresses storage self, address element, bool allowDup) internal {
24         if (allowDup) {
25             self._items.push(element);
26             self.map[element] = 2;
27         } else if (!exists(self, element)) {
28             self._items.push(element);
29             self.map[element] = 2;
30         }
31     }
32 
33     function removeAddress(Addresses storage self, address element) internal returns (bool) {
34         if (!exists(self, element)) {
35             return true;
36         }
37         for (uint i = 0; i < self.size(); i++) {
38             if (self._items[i] == element) {
39                 self._items[i] = self._items[self.size() - 1];
40                 self._items.pop();
41                 self.map[element] = 1;
42                 return true;
43             }
44         }
45         return false;
46     }
47 
48     function getAddressAtIndex(Addresses storage self, uint256 index) internal view returns (address) {
49         require(index < size(self), "the index is out of bounds");
50         return self._items[index];
51     }
52 
53     function size(Addresses storage self) internal view returns (uint256) {
54         return self._items.length;
55     }
56 
57     function exists(Addresses storage self, address element) internal view returns (bool) {
58         return self.map[element] == 2;
59     }
60 
61     function getAllAddresses(Addresses storage self) internal view returns (address[] memory) {
62         return self._items;
63     }
64 }
65 
66 interface IERC20 {
67 
68     function totalSupply() external view returns (uint256);
69 
70     /**
71      * @dev Returns the amount of tokens owned by `account`.
72      */
73     function balanceOf(address account) external view returns (uint256);
74 
75     /**
76      * @dev Moves `amount` tokens from the caller's account to `recipient`.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * Emits a {Transfer} event.
81      */
82     function transfer(address recipient, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Returns the remaining number of tokens that `spender` will be
86      * allowed to spend on behalf of `owner` through {transferFrom}. This is
87      * zero by default.
88      *
89      * This value changes when {approve} or {transferFrom} are called.
90      */
91     function allowance(address owner, address spender) external view returns (uint256);
92 
93     /**
94      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
95      *
96      * Returns a boolean value indicating whether the operation succeeded.
97      *
98      * IMPORTANT: Beware that changing an allowance with this method brings the risk
99      * that someone may use both the old and the new allowance by unfortunate
100      * transaction ordering. One possible solution to mitigate this race
101      * condition is to first reduce the spender's allowance to 0 and set the
102      * desired value afterwards:
103      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
104      *
105      * Emits an {Approval} event.
106      */
107     function approve(address spender, uint256 amount) external returns (bool);
108 
109     /**
110      * @dev Moves `amount` tokens from `sender` to `recipient` using the
111      * allowance mechanism. `amount` is then deducted from the caller's
112      * allowance.
113      *
114      * Returns a boolean value indicating whether the operation succeeded.
115      *
116      * Emits a {Transfer} event.
117      */
118     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
119 
120     /**
121      * @dev Emitted when `value` tokens are moved from one account (`from`) to
122      * another (`to`).
123      *
124      * Note that `value` may be zero.
125      */
126     event Transfer(address indexed from, address indexed to, uint256 value);
127 
128     /**
129      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
130      * a call to {approve}. `value` is the new allowance.
131      */
132     event Approval(address indexed owner, address indexed spender, uint256 value);
133 }
134 
135 library SafeMath {
136     /**
137      * @dev Returns the addition of two unsigned integers, reverting on
138      * overflow.
139      *
140      * Counterpart to Solidity's `+` operator.
141      *
142      * Requirements:
143      *
144      * - Addition cannot overflow.
145      */
146     function add(uint256 a, uint256 b) internal pure returns (uint256) {
147         uint256 c = a + b;
148         require(c >= a, "SafeMath: addition overflow");
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the subtraction of two unsigned integers, reverting on
155      * overflow (when the result is negative).
156      *
157      * Counterpart to Solidity's `-` operator.
158      *
159      * Requirements:
160      *
161      * - Subtraction cannot overflow.
162      */
163     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
164         return sub(a, b, "SafeMath: subtraction overflow");
165     }
166 
167     /**
168      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
169      * overflow (when the result is negative).
170      *
171      * Counterpart to Solidity's `-` operator.
172      *
173      * Requirements:
174      *
175      * - Subtraction cannot overflow.
176      */
177     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
178         require(b <= a, errorMessage);
179         uint256 c = a - b;
180 
181         return c;
182     }
183 
184     /**
185      * @dev Returns the multiplication of two unsigned integers, reverting on
186      * overflow.
187      *
188      * Counterpart to Solidity's `*` operator.
189      *
190      * Requirements:
191      *
192      * - Multiplication cannot overflow.
193      */
194     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
195         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
196         // benefit is lost if 'b' is also tested.
197         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
198         if (a == 0) {
199             return 0;
200         }
201 
202         uint256 c = a * b;
203         require(c / a == b, "SafeMath: multiplication overflow");
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers. Reverts on
210      * division by zero. The result is rounded towards zero.
211      *
212      * Counterpart to Solidity's `/` operator. Note: this function uses a
213      * `revert` opcode (which leaves remaining gas untouched) while Solidity
214      * uses an invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function div(uint256 a, uint256 b) internal pure returns (uint256) {
221         return div(a, b, "SafeMath: division by zero");
222     }
223 
224     /**
225      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
226      * division by zero. The result is rounded towards zero.
227      *
228      * Counterpart to Solidity's `/` operator. Note: this function uses a
229      * `revert` opcode (which leaves remaining gas untouched) while Solidity
230      * uses an invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237         require(b > 0, errorMessage);
238         uint256 c = a / b;
239         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
240 
241         return c;
242     }
243 
244     /**
245      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
246      * Reverts when dividing by zero.
247      *
248      * Counterpart to Solidity's `%` operator. This function uses a `revert`
249      * opcode (which leaves remaining gas untouched) while Solidity uses an
250      * invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      *
254      * - The divisor cannot be zero.
255      */
256     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
257         return mod(a, b, "SafeMath: modulo by zero");
258     }
259 
260     /**
261      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
262      * Reverts with custom message when dividing by zero.
263      *
264      * Counterpart to Solidity's `%` operator. This function uses a `revert`
265      * opcode (which leaves remaining gas untouched) while Solidity uses an
266      * invalid opcode to revert (consuming all remaining gas).
267      *
268      * Requirements:
269      *
270      * - The divisor cannot be zero.
271      */
272     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
273         require(b != 0, errorMessage);
274         return a % b;
275     }
276 }
277 
278 abstract contract Context {
279     function _msgSender() internal view virtual returns (address payable) {
280         return msg.sender;
281     }
282 
283     function _msgData() internal view virtual returns (bytes memory) {
284         this;
285         // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
286         return msg.data;
287     }
288 }
289 
290 library Address {
291     /**
292      * @dev Returns true if `account` is a contract.
293      *
294      * [IMPORTANT]
295      * ====
296      * It is unsafe to assume that an address for which this function returns
297      * false is an externally-owned account (EOA) and not a contract.
298      *
299      * Among others, `isContract` will return false for the following
300      * types of addresses:
301      *
302      *  - an externally-owned account
303      *  - a contract in construction
304      *  - an address where a contract will be created
305      *  - an address where a contract lived, but was destroyed
306      * ====
307      */
308     function isContract(address account) internal view returns (bool) {
309         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
310         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
311         // for accounts without code, i.e. `keccak256('')`
312         bytes32 codehash;
313         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
314         // solhint-disable-next-line no-inline-assembly
315         assembly {codehash := extcodehash(account)}
316         return (codehash != accountHash && codehash != 0x0);
317     }
318 
319     /**
320      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
321      * `recipient`, forwarding all available gas and reverting on errors.
322      *
323      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
324      * of certain opcodes, possibly making contracts go over the 2300 gas limit
325      * imposed by `transfer`, making them unable to receive funds via
326      * `transfer`. {sendValue} removes this limitation.
327      *
328      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
329      *
330      * IMPORTANT: because control is transferred to `recipient`, care must be
331      * taken to not create reentrancy vulnerabilities. Consider using
332      * {ReentrancyGuard} or the
333      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
334      */
335     function sendValue(address payable recipient, uint256 amount) internal {
336         require(address(this).balance >= amount, "Address: insufficient balance");
337 
338         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
339         (bool success,) = recipient.call{value : amount}("");
340         require(success, "Address: unable to send value, recipient may have reverted");
341     }
342 
343     /**
344      * @dev Performs a Solidity function call using a low level `call`. A
345      * plain`call` is an unsafe replacement for a function call: use this
346      * function instead.
347      *
348      * If `target` reverts with a revert reason, it is bubbled up by this
349      * function (like regular Solidity function calls).
350      *
351      * Returns the raw returned data. To convert to the expected return value,
352      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
353      *
354      * Requirements:
355      *
356      * - `target` must be a contract.
357      * - calling `target` with `data` must not revert.
358      *
359      * _Available since v3.1._
360      */
361     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
362         return functionCall(target, data, "Address: low-level call failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
367      * `errorMessage` as a fallback revert reason when `target` reverts.
368      *
369      * _Available since v3.1._
370      */
371     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
372         return _functionCallWithValue(target, data, 0, errorMessage);
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
377      * but also transferring `value` wei to `target`.
378      *
379      * Requirements:
380      *
381      * - the calling contract must have an ETH balance of at least `value`.
382      * - the called Solidity function must be `payable`.
383      *
384      * _Available since v3.1._
385      */
386     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
387         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
388     }
389 
390     /**
391      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
392      * with `errorMessage` as a fallback revert reason when `target` reverts.
393      *
394      * _Available since v3.1._
395      */
396     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
397         require(address(this).balance >= value, "Address: insufficient balance for call");
398         return _functionCallWithValue(target, data, value, errorMessage);
399     }
400 
401     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
402         require(isContract(target), "Address: call to non-contract");
403 
404         // solhint-disable-next-line avoid-low-level-calls
405         (bool success, bytes memory returndata) = target.call{value : weiValue}(data);
406         if (success) {
407             return returndata;
408         } else {
409             // Look for revert reason and bubble it up if present
410             if (returndata.length > 0) {
411                 // The easiest way to bubble the revert reason is using memory via assembly
412 
413                 // solhint-disable-next-line no-inline-assembly
414                 assembly {
415                     let returndata_size := mload(returndata)
416                     revert(add(32, returndata), returndata_size)
417                 }
418             } else {
419                 revert(errorMessage);
420             }
421         }
422     }
423 }
424 
425 contract Ownable is Context {
426     address private _owner;
427 
428     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
429 
430     /**
431      * @dev Initializes the contract setting the deployer as the initial owner.
432      */
433     constructor () internal {
434         address msgSender = _msgSender();
435         _owner = msgSender;
436         emit OwnershipTransferred(address(0), msgSender);
437     }
438 
439     /**
440      * @dev Returns the address of the current owner.
441      */
442     function owner() public view returns (address) {
443         return _owner;
444     }
445 
446     /**
447      * @dev Throws if called by any account other than the owner.
448      */
449     modifier onlyOwner() {
450         require(_owner == _msgSender(), "Ownable: caller is not the owner");
451         _;
452     }
453 
454     /**
455     * @dev Leaves the contract without owner. It will not be possible to call
456      * `onlyOwner` functions anymore. Can only be called by the current owner.
457      *
458      * NOTE: Renouncing ownership will leave the contract without an owner,
459      * thereby removing any functionality that is only available to the owner.
460      */
461     function renounceOwnership() public virtual onlyOwner {
462         emit OwnershipTransferred(_owner, address(0));
463         _owner = address(0);
464     }
465 
466     /**
467      * @dev Transfers ownership of the contract to a new account (`newOwner`).
468      * Can only be called by the current owner.
469      */
470     function transferOwnership(address newOwner) public virtual onlyOwner {
471         require(newOwner != address(0), "Ownable: new owner is the zero address");
472         emit OwnershipTransferred(_owner, newOwner);
473         _owner = newOwner;
474     }
475 
476 }
477 
478 interface IUniswapV2Factory {
479     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
480 
481     function feeTo() external view returns (address);
482 
483     function feeToSetter() external view returns (address);
484 
485     function getPair(address tokenA, address tokenB) external view returns (address pair);
486 
487     function allPairs(uint) external view returns (address pair);
488 
489     function allPairsLength() external view returns (uint);
490 
491     function createPair(address tokenA, address tokenB) external returns (address pair);
492 
493     function setFeeTo(address) external;
494 
495     function setFeeToSetter(address) external;
496 }
497 
498 // interface IUniswapV2Pair {
499 //     event Approval(address indexed owner, address indexed spender, uint value);
500 //     event Transfer(address indexed from, address indexed to, uint value);
501 
502 //     function name() external pure returns (string memory);
503 
504 //     function symbol() external pure returns (string memory);
505 
506 //     function decimals() external pure returns (uint8);
507 
508 //     function totalSupply() external view returns (uint);
509 
510 //     function balanceOf(address owner) external view returns (uint);
511 
512 //     function allowance(address owner, address spender) external view returns (uint);
513 
514 //     function approve(address spender, uint value) external returns (bool);
515 
516 //     function transfer(address to, uint value) external returns (bool);
517 
518 //     function transferFrom(address from, address to, uint value) external returns (bool);
519 
520 //     function DOMAIN_SEPARATOR() external view returns (bytes32);
521 
522 //     function PERMIT_TYPEHASH() external pure returns (bytes32);
523 
524 //     function nonces(address owner) external view returns (uint);
525 
526 //     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
527 
528 //     event Mint(address indexed sender, uint amount0, uint amount1);
529 //     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
530 //     event Swap(
531 //         address indexed sender,
532 //         uint amount0In,
533 //         uint amount1In,
534 //         uint amount0Out,
535 //         uint amount1Out,
536 //         address indexed to
537 //     );
538 //     event Sync(uint112 reserve0, uint112 reserve1);
539 
540 //     function MINIMUM_LIQUIDITY() external pure returns (uint);
541 
542 //     function factory() external view returns (address);
543 
544 //     function token0() external view returns (address);
545 
546 //     function token1() external view returns (address);
547 
548 //     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
549 
550 //     function price0CumulativeLast() external view returns (uint);
551 
552 //     function price1CumulativeLast() external view returns (uint);
553 
554 //     function kLast() external view returns (uint);
555 
556 //     function mint(address to) external returns (uint liquidity);
557 
558 //     function burn(address to) external returns (uint amount0, uint amount1);
559 
560 //     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
561 
562 //     function skim(address to) external;
563 
564 //     function sync() external;
565 
566 //     function initialize(address, address) external;
567 // }
568 
569 interface IUniswapV2Router01 {
570     function factory() external pure returns (address);
571 
572     function WETH() external pure returns (address);
573 
574     function addLiquidity(
575         address tokenA,
576         address tokenB,
577         uint amountADesired,
578         uint amountBDesired,
579         uint amountAMin,
580         uint amountBMin,
581         address to,
582         uint deadline
583     ) external returns (uint amountA, uint amountB, uint liquidity);
584 
585     function addLiquidityETH(
586         address token,
587         uint amountTokenDesired,
588         uint amountTokenMin,
589         uint amountETHMin,
590         address to,
591         uint deadline
592     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
593 
594     function removeLiquidity(
595         address tokenA,
596         address tokenB,
597         uint liquidity,
598         uint amountAMin,
599         uint amountBMin,
600         address to,
601         uint deadline
602     ) external returns (uint amountA, uint amountB);
603 
604     function removeLiquidityETH(
605         address token,
606         uint liquidity,
607         uint amountTokenMin,
608         uint amountETHMin,
609         address to,
610         uint deadline
611     ) external returns (uint amountToken, uint amountETH);
612 
613     function removeLiquidityWithPermit(
614         address tokenA,
615         address tokenB,
616         uint liquidity,
617         uint amountAMin,
618         uint amountBMin,
619         address to,
620         uint deadline,
621         bool approveMax, uint8 v, bytes32 r, bytes32 s
622     ) external returns (uint amountA, uint amountB);
623 
624     function removeLiquidityETHWithPermit(
625         address token,
626         uint liquidity,
627         uint amountTokenMin,
628         uint amountETHMin,
629         address to,
630         uint deadline,
631         bool approveMax, uint8 v, bytes32 r, bytes32 s
632     ) external returns (uint amountToken, uint amountETH);
633 
634     function swapExactTokensForTokens(
635         uint amountIn,
636         uint amountOutMin,
637         address[] calldata path,
638         address to,
639         uint deadline
640     ) external returns (uint[] memory amounts);
641 
642     function swapTokensForExactTokens(
643         uint amountOut,
644         uint amountInMax,
645         address[] calldata path,
646         address to,
647         uint deadline
648     ) external returns (uint[] memory amounts);
649 
650     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
651     external
652     payable
653     returns (uint[] memory amounts);
654 
655     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
656     external
657     returns (uint[] memory amounts);
658 
659     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
660     external
661     returns (uint[] memory amounts);
662 
663     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
664     external
665     payable
666     returns (uint[] memory amounts);
667 
668     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
669 
670     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
671 
672     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
673 
674     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
675 
676     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
677 }
678 
679 interface IUniswapV2Router02 is IUniswapV2Router01 {
680     function removeLiquidityETHSupportingFeeOnTransferTokens(
681         address token,
682         uint liquidity,
683         uint amountTokenMin,
684         uint amountETHMin,
685         address to,
686         uint deadline
687     ) external returns (uint amountETH);
688 
689     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
690         address token,
691         uint liquidity,
692         uint amountTokenMin,
693         uint amountETHMin,
694         address to,
695         uint deadline,
696         bool approveMax, uint8 v, bytes32 r, bytes32 s
697     ) external returns (uint amountETH);
698 
699     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
700         uint amountIn,
701         uint amountOutMin,
702         address[] calldata path,
703         address to,
704         uint deadline
705     ) external;
706 
707     function swapExactETHForTokensSupportingFeeOnTransferTokens(
708         uint amountOutMin,
709         address[] calldata path,
710         address to,
711         uint deadline
712     ) external payable;
713 
714     function swapExactTokensForETHSupportingFeeOnTransferTokens(
715         uint amountIn,
716         uint amountOutMin,
717         address[] calldata path,
718         address to,
719         uint deadline
720     ) external;
721 }
722 interface IERC2612 {
723 
724     /**
725      * @dev Returns the current ERC2612 nonce for `owner`. This value must be
726      * included whenever a signature is generated for {permit}.
727      *
728      * Every successful call to {permit} increases ``owner``'s nonce by one. This
729      * prevents a signature from being used multiple times.
730      */
731     function nonces(address owner) external view returns (uint256);
732 }
733 interface IAnyswapV3ERC20 is IERC20, IERC2612 {
734 
735     /// @dev Sets `value` as allowance of `spender` account over caller account's AnyswapV3ERC20 token,
736     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
737     /// Emits {Approval} event.
738     /// Returns boolean value indicating whether operation succeeded.
739     /// For more information on approveAndCall format, see https://github.com/ethereum/EIPs/issues/677.
740     function approveAndCall(address spender, uint256 value, bytes calldata data) external returns (bool);
741 
742     /// @dev Moves `value` AnyswapV3ERC20 token from caller's account to account (`to`),
743     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
744     /// A transfer to `address(0)` triggers an ERC-20 withdraw matching the sent AnyswapV3ERC20 token in favor of caller.
745     /// Emits {Transfer} event.
746     /// Returns boolean value indicating whether operation succeeded.
747     /// Requirements:
748     ///   - caller account must have at least `value` AnyswapV3ERC20 token.
749     /// For more information on transferAndCall format, see https://github.com/ethereum/EIPs/issues/677.
750     function transferAndCall(address to, uint value, bytes calldata data) external returns (bool);
751 }
752 
753 interface ITransferReceiver {
754     function onTokenTransfer(address, uint, bytes calldata) external returns (bool);
755 }
756 
757 interface IApprovalReceiver {
758     function onTokenApproval(address, uint, bytes calldata) external returns (bool);
759 }
760 
761 
762 contract Token is IAnyswapV3ERC20, Context, Ownable {
763     using SafeMath for uint256;
764     using Address for address;
765     using AddrArrayLib for AddrArrayLib.Addresses;
766 
767     mapping (address => uint256) public override nonces;
768 
769 
770     mapping(address => uint256) private _rOwned;
771     mapping(address => uint256) private _tOwned;
772     mapping(address => mapping(address => uint256)) private _allowances;
773 
774     mapping(address => bool) private _isExcludedFromFee;
775 
776     mapping(address => bool) public _isExcluded;
777     mapping(address => bool) public whitelist;
778     address[] private _excluded;
779 
780     uint256 private constant MAX = ~uint256(0);
781     uint256 private _tTotal = 1_000_000_000_000_000_000_000;
782 
783     uint256 public _maxTxAmount = 10_000_000_000_000_000_000; // 10b
784     uint256 private numTokensSellToAddToLiquidity = 1_000_000_000_000_000; // 1m
785     // mint transfer value to get a ticket
786     uint256 public minimumDonationForTicket = 1_000_000_000_000_000_000; // 1b
787     uint256 public lotteryHolderMinBalance  = 1_000_000_000_000_000_000; // 1b
788 
789     uint256 private _rTotal = (MAX - (MAX % _tTotal));
790     uint256 private _tFeeTotal;
791 
792     string private _name = "Elonson Inu";
793     string private _symbol = "ESI";
794     uint8 public immutable decimals = 9;
795 
796     address public donationAddress = 0x676FbD4E4bd54e3a1Be74178df2fFefa15B4824b;
797     address public holderAddress = 0xa30d530C0BCB6f7b7D5a83B1D51716d7eeaf8E8F;
798     address public burnAddress = 0x000000000000000000000000000000000000dEaD;
799     address public charityWalletAddress = 0x37c636084cf1d5e0a23dc6eAadcD2a93eF00E0c1;
800 
801 
802     address public devFundWalletAddress = 0xd68749450a51e50e4418F13fB3cEaBB27B2e68aB;
803     address public marketingFundWalletAddress = 0x6EAe593726Cdc7fe4249CF77a1B5B24f0bd3dB11;
804     address public donationLotteryPrizeWalletAddress = 0xa4c57d4bf1dEf34f40A15d8B89d3cCb315722d7F;
805     address public faaSWalletAddress = 0xfC1034EFFE7A26a0FD69B5c08b21d1e0855fdb19;
806 
807     uint256 public _FaaSFee = 10; //1%
808     uint256 private _previous_FaaSFee = _FaaSFee;
809 
810     uint256 public _distributionFee = 10; //1%
811     uint256 private _previousDistributionFee = _distributionFee;
812 
813     uint256 public _charityFee = 20; //2%
814     uint256 private _previousCharityFee = _charityFee;
815 
816     uint256 public _devFundFee = 10; //1%
817     uint256 private _previousDevFundFee = _devFundFee;
818 
819     uint256 public _marketingFundFee = 10; //1%
820     uint256 private _previousMarketingFundFee = _marketingFundFee;
821 
822     uint256 public _donationLotteryPrizeFee = 5; //0.5%
823     uint256 private _previousDonationLotteryPrizeFee = _donationLotteryPrizeFee;
824 
825     uint256 public _burnFee = 10; //1%
826     uint256 private _previousBurnFee = _burnFee;
827 
828     uint256 public _lotteryHolderFee = 5; //0.5%
829     uint256 private _previousLotteryHolderFee = _lotteryHolderFee;
830 
831     uint256 public _liquidityFee = 10; //1%
832     uint256 private _previousLiquidityFee = _liquidityFee;
833 
834     IUniswapV2Router02 public immutable uniswapV2Router;
835     address public immutable uniswapV2Pair;
836 
837     bool inSwapAndLiquify;
838     bool public swapAndLiquifyEnabled = true;
839     uint256 public _creationTime = now;
840     uint256 public endtime; // when lottery period end and prize get distributed
841     mapping(address => uint256) public userTicketsTs;
842     bool public disableTicketsTs = false; // disable on testing env only
843     bool public donationLotteryDebug = true; // disable on testing env only
844 
845     bool public donationLotteryEnabled = true;
846     address[] private donationLotteryUsers; // list of tickets for 1000 tx prize
847     uint256 public donationLotteryIndex; // index of last winner
848     address public donationLotteryWinner; // last random winner
849     uint256 public donationLotteryLimit = 1000;
850     uint256 public donationLotteryMinLimit = 50;
851 
852     bool public lotteryHoldersEnabled = true;
853     bool public lotteryHoldersDebug = true;
854     uint256 public lotteryHoldersLimit = 1000;
855     uint256 public lotteryHoldersIndex = 0;
856     address public lotteryHoldersWinner;
857 
858 
859     // list of balance by users illegible for holder lottery
860     AddrArrayLib.Addresses private ticketsByBalance;
861 
862     event LotteryHolderChooseOne(uint256 tickets, address winner, uint256 prize);
863 
864     modifier lockTheSwap {
865         inSwapAndLiquify = true;
866         _;
867         inSwapAndLiquify = false;
868     }
869 
870     // control % of a buy in the first days
871     uint antiAbuseDay1 = 50; // 0.5%
872     uint antiAbuseDay2 = 100; // 1.0%
873     uint antiAbuseDay3 = 150; // 1.5%
874 
875     constructor (address mintSupplyTo, address router) public {
876         //console.log('_tTotal=%s', _tTotal);
877         _rOwned[mintSupplyTo] = _rTotal;
878 
879         // we whitelist treasure and owner to allow pool management
880         whitelist[mintSupplyTo] = true;
881         whitelist[owner()] = true;
882 
883         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(router);
884         // Create a uniswap pair for this new token
885         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
886         .createPair(address(this), _uniswapV2Router.WETH());
887 
888         // set the rest of the contract variables
889         uniswapV2Router = _uniswapV2Router;
890 
891         //exclude owner and this contract from fee
892         _isExcludedFromFee[owner()] = true;
893         _isExcludedFromFee[address(this)] = true;
894         _isExcludedFromFee[mintSupplyTo] = true;
895         _isExcludedFromFee[donationLotteryPrizeWalletAddress] = true;
896         _isExcludedFromFee[donationAddress] = true;
897         _isExcludedFromFee[devFundWalletAddress] = true;
898         _isExcludedFromFee[marketingFundWalletAddress] = true;
899         _isExcludedFromFee[holderAddress] = true;
900         _isExcludedFromFee[charityWalletAddress] = true;
901         _isExcludedFromFee[burnAddress] = true;
902         _isExcludedFromFee[faaSWalletAddress] = true;
903         emit Transfer(address(0), mintSupplyTo, _tTotal);
904     }
905 
906     function name() public view returns (string memory) {
907         return _name;
908     }
909 
910     function symbol() public view returns (string memory) {
911         return _symbol;
912     }
913 
914     function totalSupply() public view override returns (uint256) {
915         return _tTotal;
916     }
917 
918     function balanceOf(address account) public view override returns (uint256) {
919         if (_isExcluded[account]) return _tOwned[account];
920         return tokenFromReflection(_rOwned[account]);
921     }
922     function transfer(address recipient, uint256 amount) public override returns (bool) {
923         _transfer(_msgSender(), recipient, amount);
924         return true;
925     }
926 
927     function allowance(address owner, address spender) public view override returns (uint256) {
928         return _allowances[owner][spender];
929     }
930 
931     function approve(address spender, uint256 amount) public override returns (bool) {
932         _approve(_msgSender(), spender, amount);
933         return true;
934     }
935     function approveAndCall(address spender, uint256 value, bytes calldata data) external override returns (bool) {
936         // _approve(msg.sender, spender, value);
937         _allowances[msg.sender][spender] = value;
938         emit Approval(msg.sender, spender, value);
939 
940         return IApprovalReceiver(spender).onTokenApproval(msg.sender, value, data);
941     }
942       /// @dev Moves `value` AnyswapV3ERC20 token from caller's account to account (`to`),
943     /// after which a call is executed to an ERC677-compliant contract with the `data` parameter.
944     /// A transfer to `address(0)` triggers an ETH withdraw matching the sent AnyswapV3ERC20 token in favor of caller.
945     /// Emits {Transfer} event.
946     /// Returns boolean value indicating whether operation succeeded.
947     /// Requirements:
948     ///   - caller account must have at least `value` AnyswapV3ERC20 token.
949     /// For more information on transferAndCall format, see https://github.com/ethereum/EIPs/issues/677.
950     function transferAndCall(address to, uint value, bytes calldata data) external override returns (bool) {
951         require(to != address(0) || to != address(this));
952         _transfer(msg.sender, to, value);
953 
954         return ITransferReceiver(to).onTokenTransfer(msg.sender, value, data);
955     }
956 
957     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
958         _transfer(sender, recipient, amount);
959         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
960         return true;
961     }
962 
963     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
964         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
965         return true;
966     }
967 
968     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
969         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
970         return true;
971     }
972 
973     function isExcludedFromReward(address account) public view returns (bool) {
974         return _isExcluded[account];
975     }
976 
977     function totalFees() public view returns (uint256) {
978         return _tFeeTotal;
979     }
980 
981     function deliver(uint256 tAmount) public {
982         address sender = _msgSender();
983         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
984         (rInfo memory rr,) = _getValues(tAmount);
985         _rOwned[sender] = _rOwned[sender].sub(rr.rAmount);
986         _rTotal = _rTotal.sub(rr.rAmount);
987         _tFeeTotal = _tFeeTotal.add(tAmount);
988     }
989 
990     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns (uint256) {
991         require(tAmount <= _tTotal, "Amount must be less than supply");
992         if (!deductTransferFee) {
993             (rInfo memory rr,) = _getValues(tAmount);
994             return rr.rAmount;
995         } else {
996             (rInfo memory rr,) = _getValues(tAmount);
997             return rr.rTransferAmount;
998         }
999     }
1000 
1001     function tokenFromReflection(uint256 rAmount) public view returns (uint256) {
1002         require(rAmount <= _rTotal, "Amount must be less than total reflections");
1003         uint256 currentRate = _getRate();
1004         return rAmount.div(currentRate);
1005     }
1006 
1007     function excludeFromReward(address account) public onlyOwner() {
1008         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
1009         require(!_isExcluded[account], "Account is already excluded");
1010         if (_rOwned[account] > 0) {
1011             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1012         }
1013         _isExcluded[account] = true;
1014         _excluded.push(account);
1015     }
1016 
1017     function includeInReward(address account) external onlyOwner() {
1018         require(_isExcluded[account], "Account is already excluded");
1019         for (uint256 i = 0; i < _excluded.length; i++) {
1020             if (_excluded[i] == account) {
1021                 _excluded[i] = _excluded[_excluded.length - 1];
1022                 _tOwned[account] = 0;
1023                 _isExcluded[account] = false;
1024                 _excluded.pop();
1025                 break;
1026             }
1027         }
1028     }
1029 
1030     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1031         (rInfo memory rr, tInfo memory tt) = _getValues(tAmount);
1032         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1033         _rOwned[sender] = _rOwned[sender].sub(rr.rAmount);
1034         _tOwned[recipient] = _tOwned[recipient].add(tt.tTransferAmount);
1035         _rOwned[recipient] = _rOwned[recipient].add(rr.rTransferAmount);
1036         _takeLiquidity(tt.tLiquidity);
1037         _reflectFee(rr, tt);
1038         emit Transfer(sender, recipient, tt.tTransferAmount);
1039     }
1040 
1041     // whitelist to add liquidity
1042     function setWhitelist(address account, bool _status) public onlyOwner {
1043         whitelist[account] = _status;
1044     }
1045 
1046     function excludeFromFee(address account) public onlyOwner {
1047         _isExcludedFromFee[account] = true;
1048     }
1049 
1050     function includeInFee(address account) public onlyOwner {
1051         _isExcludedFromFee[account] = false;
1052     }
1053 
1054     function setDistributionFeePercent(uint256 distributionFee) external onlyOwner() {
1055         _distributionFee = distributionFee;
1056     }
1057 
1058     function setCharityFeePercent(uint256 charityFee) external onlyOwner() {
1059         _charityFee = charityFee;
1060     }
1061 
1062     function setDevFundFeePercent(uint256 devFundFee) external onlyOwner() {
1063         _devFundFee = devFundFee;
1064     }
1065 
1066     function setMarketingFundFeePercent(uint256 marketingFundFee) external onlyOwner() {
1067         _marketingFundFee = marketingFundFee;
1068     }
1069 
1070     function setDonationLotteryPrizeFeePercent(uint256 donationLotteryPrizeFee) external onlyOwner() {
1071         _donationLotteryPrizeFee = donationLotteryPrizeFee;
1072     }
1073 
1074     function setBurnFeePercent(uint256 burnFee) external onlyOwner() {
1075         _burnFee = burnFee;
1076     }
1077 
1078     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
1079         _liquidityFee = liquidityFee;
1080     }
1081 
1082     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1083         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1084             10 ** 2
1085         );
1086     }
1087 
1088     event SwapAndLiquifyEnabledUpdated(bool _enabled);
1089     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1090         swapAndLiquifyEnabled = _enabled;
1091         emit SwapAndLiquifyEnabledUpdated(_enabled);
1092     }
1093 
1094     //to recieve ETH from uniswapV2Router when swaping
1095     receive() external payable {}
1096 
1097     function _reflectFee(rInfo memory rr, tInfo memory tt) private {
1098         _rTotal = _rTotal.sub(rr.rDistributionFee);
1099         _tFeeTotal = _tFeeTotal.add(tt.tDistributionFee).add(tt.tCharityFee).add(tt.tDevFundFee)
1100         .add(tt.tMarketingFundFee).add(tt.tDonationLotteryPrizeFee).add(tt.tBurn).add(tt.tHolderFee).add(tt.tFaaSFee);
1101 
1102         _rOwned[holderAddress] = _rOwned[holderAddress].add(rr.rHolderFee);
1103         _rOwned[charityWalletAddress] = _rOwned[charityWalletAddress].add(rr.rCharityFee);
1104         _rOwned[devFundWalletAddress] = _rOwned[devFundWalletAddress].add(rr.rDevFundFee);
1105         _rOwned[marketingFundWalletAddress] = _rOwned[marketingFundWalletAddress].add(rr.rMarketingFundFee);
1106         _rOwned[donationLotteryPrizeWalletAddress] = _rOwned[donationLotteryPrizeWalletAddress].add(rr.rDonationLotteryPrizeFee);
1107         _rOwned[burnAddress] = _rOwned[burnAddress].add(rr.rBurn);
1108         _rOwned[faaSWalletAddress] = _rOwned[faaSWalletAddress].add(rr.rFaaSFee);
1109 
1110         if( tt.tHolderFee > 0)
1111             emit Transfer(msg.sender, holderAddress, tt.tHolderFee);
1112 
1113         if( tt.tCharityFee > 0)
1114             emit Transfer(msg.sender, charityWalletAddress, tt.tCharityFee);
1115 
1116         if( tt.tDevFundFee > 0 )
1117             emit Transfer(msg.sender, devFundWalletAddress, tt.tDevFundFee);
1118 
1119         if( tt.tMarketingFundFee > 0 )
1120             emit Transfer(msg.sender, marketingFundWalletAddress, tt.tMarketingFundFee);
1121 
1122         if( tt.tDonationLotteryPrizeFee > 0 )
1123             emit Transfer(msg.sender, donationLotteryPrizeWalletAddress, tt.tDonationLotteryPrizeFee);
1124 
1125         if( tt.tBurn > 0 )
1126             emit Transfer(msg.sender, burnAddress, tt.tBurn);
1127 
1128         if( tt.tFaaSFee > 0 )
1129             emit Transfer(msg.sender, faaSWalletAddress, tt.tFaaSFee);
1130 
1131     }
1132 
1133     struct tInfo {
1134         uint256 tTransferAmount;
1135         uint256 tDistributionFee;
1136         uint256 tLiquidity;
1137         uint256 tCharityFee;
1138         uint256 tDevFundFee;
1139         uint256 tMarketingFundFee;
1140         uint256 tDonationLotteryPrizeFee;
1141         uint256 tBurn;
1142         uint256 tHolderFee;
1143         uint256 tFaaSFee;
1144     }
1145 
1146     struct rInfo {
1147         uint256 rAmount;
1148         uint256 rTransferAmount;
1149         uint256 rDistributionFee;
1150         uint256 rCharityFee;
1151         uint256 rDevFundFee;
1152         uint256 rMarketingFundFee;
1153         uint256 rDonationLotteryPrizeFee;
1154         uint256 rBurn;
1155         uint256 rLiquidity;
1156         uint256 rHolderFee;
1157         uint256 rFaaSFee;
1158     }
1159 
1160     function _getValues(uint256 tAmount) private view returns (rInfo memory rr, tInfo memory tt) {
1161         tt = _getTValues(tAmount);
1162         rr = _getRValues(tAmount, tt.tDistributionFee, tt.tCharityFee, tt.tDevFundFee, tt.tMarketingFundFee,
1163             tt.tDonationLotteryPrizeFee, tt.tBurn, tt.tHolderFee, tt.tLiquidity, _getRate(), tt.tFaaSFee);
1164         return (rr, tt);
1165     }
1166 
1167     function _getTValues(uint256 tAmount) private view returns (tInfo memory tt) {
1168         tt.tFaaSFee = calculateFaaSFee(tAmount);                    // _FaaSFee 1%
1169         tt.tDistributionFee = calculateDistributionFee(tAmount);    // _distributionFee 1%
1170         tt.tCharityFee = calculateCharityFee(tAmount);              // _charityFee 2%
1171         tt.tDevFundFee = calculateDevFundFee(tAmount);              // _devFundFee 1%
1172         tt.tMarketingFundFee = calculateMarketingFundFee(tAmount);  // _marketingFundFee 1%
1173         tt.tDonationLotteryPrizeFee = calculateDonationLotteryPrizeFee(tAmount);        // _donationLotteryPrizeFee 0.5%
1174         tt.tBurn = calculateBurnFee(tAmount);                       // _burnFee 1%
1175         tt.tHolderFee = calculateHolderFee(tAmount);                // _lotteryHolderFee 0.5%
1176         tt.tLiquidity = calculateLiquidityFee(tAmount);             // _liquidityFee 1%
1177 
1178         uint totalFee = tt.tDistributionFee.add(tt.tCharityFee).add(tt.tDevFundFee)
1179         .add(tt.tMarketingFundFee).add(tt.tDonationLotteryPrizeFee).add(tt.tBurn);
1180         totalFee = totalFee.add(tt.tLiquidity).add(tt.tHolderFee).add(tt.tFaaSFee);
1181         tt.tTransferAmount = tAmount.sub(totalFee);
1182         return tt;
1183     }
1184 
1185     function _getRValues(uint256 tAmount, uint256 tDistributionFee, uint256 tCharityFee, uint256 tDevFundFee,
1186         uint256 tMarketingFundFee, uint256 tDonationLotteryPrizeFee, uint256 tBurn, uint256 tHolderFee, uint256 tLiquidity,
1187         uint256 currentRate, uint256 tFaaSFee) private pure returns (rInfo memory rr) {
1188         rr.rAmount = tAmount.mul(currentRate);
1189         rr.rDistributionFee = tDistributionFee.mul(currentRate);
1190         rr.rCharityFee = tCharityFee.mul(currentRate);
1191         rr.rDevFundFee = tDevFundFee.mul(currentRate);
1192         rr.rMarketingFundFee = tMarketingFundFee.mul(currentRate);
1193         rr.rDonationLotteryPrizeFee = tDonationLotteryPrizeFee.mul(currentRate);
1194         rr.rBurn = tBurn.mul(currentRate);
1195         rr.rLiquidity = tLiquidity.mul(currentRate);
1196         rr.rHolderFee = tHolderFee.mul(currentRate);
1197         rr.rFaaSFee = tFaaSFee.mul(currentRate);
1198         uint totalFee = rr.rDistributionFee.add(rr.rCharityFee).add(rr.rDevFundFee).add(rr.rMarketingFundFee);
1199         totalFee = totalFee.add(rr.rDonationLotteryPrizeFee).add(rr.rBurn).add(rr.rLiquidity).add(rr.rHolderFee).add(rr.rFaaSFee);
1200         rr.rTransferAmount = rr.rAmount.sub(totalFee);
1201         return rr;
1202     }
1203 
1204     function _getRate() private view returns (uint256) {
1205         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1206         return rSupply.div(tSupply);
1207     }
1208 
1209     function _getCurrentSupply() private view returns (uint256, uint256) {
1210         uint256 rSupply = _rTotal;
1211         uint256 tSupply = _tTotal;
1212         for (uint256 i = 0; i < _excluded.length; i++) {
1213             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1214             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1215             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1216         }
1217         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1218         return (rSupply, tSupply);
1219     }
1220 
1221     function _takeLiquidity(uint256 tLiquidity) private {
1222         uint256 currentRate = _getRate();
1223         uint256 rLiquidity = tLiquidity.mul(currentRate);
1224         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1225         if (_isExcluded[address(this)])
1226             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1227     }
1228 
1229     function calculateDistributionFee(uint256 _amount) private view returns (uint256) {
1230         return _amount.mul(_distributionFee).div(1000);
1231     }
1232 
1233     function calculateCharityFee(uint256 _amount) private view returns (uint256) {
1234         return _amount.mul(_charityFee).div(1000);
1235     }
1236 
1237     function calculateDevFundFee(uint256 _amount) private view returns (uint256) {
1238         return _amount.mul(_devFundFee).div(1000);
1239     }
1240 
1241     function calculateMarketingFundFee(uint256 _amount) private view returns (uint256) {
1242         return _amount.mul(_marketingFundFee).div(1000);
1243     }
1244 
1245     function calculateDonationLotteryPrizeFee(uint256 _amount) private view returns (uint256) {
1246         return _amount.mul(_donationLotteryPrizeFee).div(1000);
1247     }
1248 
1249     function calculateBurnFee(uint256 _amount) private view returns (uint256) {
1250         return _amount.mul(_burnFee).div(1000);
1251     }
1252 
1253     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1254         return _amount.mul(_liquidityFee).div(1000);
1255     }
1256 
1257     function calculateHolderFee(uint256 _amount) private view returns (uint256) {
1258         return _amount.mul(_lotteryHolderFee).div(1000);
1259     }
1260 
1261     function calculateFaaSFee(uint256 _amount) private view returns (uint256) {
1262         return _amount.mul(_FaaSFee).div(1000);
1263     }
1264 
1265     function removeAllFee() private {
1266 
1267         _previousDistributionFee = _distributionFee;
1268         _previousLiquidityFee = _liquidityFee;
1269 
1270         _previous_FaaSFee = _FaaSFee;
1271         _previousCharityFee = _charityFee;
1272         _previousDevFundFee = _devFundFee;
1273         _previousMarketingFundFee = _marketingFundFee;
1274         _previousDonationLotteryPrizeFee = _donationLotteryPrizeFee;
1275         _previousBurnFee = _burnFee;
1276         _previousLotteryHolderFee = _lotteryHolderFee;
1277 
1278         _FaaSFee = 0;
1279         _distributionFee = 0;
1280         _charityFee = 0;
1281         _devFundFee = 0;
1282         _marketingFundFee = 0;
1283         _donationLotteryPrizeFee = 0;
1284         _burnFee = 0;
1285         _liquidityFee = 0;
1286         _lotteryHolderFee = 0;
1287     }
1288 
1289     function restoreAllFee() private {
1290         _FaaSFee = _previous_FaaSFee;
1291         _distributionFee = _previousDistributionFee;
1292         _charityFee = _previousCharityFee;
1293         _devFundFee = _previousDevFundFee;
1294         _marketingFundFee = _previousMarketingFundFee;
1295         _donationLotteryPrizeFee = _previousDonationLotteryPrizeFee;
1296         _burnFee = _previousBurnFee;
1297         _liquidityFee = _previousLiquidityFee;
1298         _lotteryHolderFee = _previousLotteryHolderFee;
1299     }
1300 
1301     function isExcludedFromFee(address account) public view returns (bool) {
1302         return _isExcludedFromFee[account];
1303     }
1304 
1305     function _approve(address owner, address spender, uint256 amount) private {
1306         require(owner != address(0), "ERC20: approve from the zero address");
1307         require(spender != address(0), "ERC20: approve to the zero address");
1308 
1309         _allowances[owner][spender] = amount;
1310         emit Approval(owner, spender, amount);
1311     }
1312 
1313 
1314     function _antiAbuse(address from, address to, uint256 amount) private view {
1315 
1316         if (from == owner() || to == owner())
1317         //  if owner we just return or we can't add liquidity
1318             return;
1319 
1320         uint256 allowedAmount;
1321 
1322         (, uint256 tSupply) = _getCurrentSupply();
1323         uint256 lastUserBalance = balanceOf(to) + (amount * (10000 - getTotalFees()) / 10000);
1324 
1325         // bot \ whales prevention
1326         if (now <= (_creationTime.add(1 days))) {
1327             allowedAmount = tSupply.mul(antiAbuseDay1).div(10000);
1328 
1329             // bool s = lastUserBalance < allowedAmount;
1330             //console.log('lastUserBalance = %s', lastUserBalance);
1331             //console.log('allowedAmount   = %s status=', allowedAmount, s);
1332 
1333             require(lastUserBalance < allowedAmount, "Transfer amount exceeds the max for day 1");
1334         } else if (now <= (_creationTime.add(2 days))) {
1335             allowedAmount = tSupply.mul(antiAbuseDay2).div(10000);
1336             require(lastUserBalance < allowedAmount, "Transfer amount exceeds the max for day 2");
1337         } else if (now <= (_creationTime.add(3 days))) {
1338             allowedAmount = tSupply.mul(antiAbuseDay3).div(10000);
1339             require(lastUserBalance < allowedAmount, "Transfer amount exceeds the max for day 3");
1340         }
1341     }
1342 
1343     event WhiteListTransfer(address from, address to, uint256 amount);
1344 
1345     function _transfer(
1346         address from,
1347         address to,
1348         uint256 amount
1349     ) private {
1350         require(from != address(0), "ERC20: transfer from the zero address");
1351         require(to != address(0), "ERC20: transfer to the zero address");
1352         require(amount > 0, "Transfer amount must be greater than zero");
1353 
1354         uint256 contractTokenBalance = balanceOf(address(this));
1355         // whitelist to allow treasure to add liquidity:
1356         if (whitelist[from] || whitelist[to]) {
1357             emit WhiteListTransfer(from, to, amount);
1358         } else {
1359 
1360             if( from == uniswapV2Pair || from == address(uniswapV2Router) ){
1361                 _antiAbuse(from, to, amount);
1362             }
1363 
1364             // is the token balance of this contract address over the min number of
1365             // tokens that we need to initiate a swap + liquidity lock?
1366             // also, don't get caught in a circular liquidity event.
1367             // also, don't swap & liquify if sender is uniswap pair.
1368 
1369             if (contractTokenBalance >= _maxTxAmount) {
1370                 contractTokenBalance = _maxTxAmount;
1371             }
1372         }
1373 
1374         bool overMinTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1375         if (
1376             overMinTokenBalance &&
1377             !inSwapAndLiquify &&
1378             from != uniswapV2Pair &&
1379             swapAndLiquifyEnabled
1380         ) {
1381             contractTokenBalance = numTokensSellToAddToLiquidity;
1382             //add liquidity
1383             swapAndLiquify(contractTokenBalance);
1384         }
1385 
1386         //indicates if fee should be deducted from transfer
1387         bool takeFee = true;
1388 
1389         //if any account belongs to _isExcludedFromFee account then remove the fee
1390         if (_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1391             takeFee = false;
1392         }
1393 
1394         //transfer amount, it will take tax, burn, liquidity fee
1395         _tokenTransfer(from, to, amount, takeFee);
1396 
1397         // process lottery if user is paying fee
1398         lotteryOnTransfer(from, to, amount);
1399     }
1400 
1401     event SwapAndLiquify(uint256 half, uint256 newBalance, uint256 otherHalf);
1402     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1403         // split the contract balance into halves
1404         uint256 half = contractTokenBalance.div(2);
1405         uint256 otherHalf = contractTokenBalance.sub(half);
1406 
1407         // capture the contract's current ETH balance.
1408         // this is so that we can capture exactly the amount of ETH that the
1409         // swap creates, and not make the liquidity event include any ETH that
1410         // has been manually sent to the contract
1411         uint256 initialBalance = address(this).balance;
1412 
1413         // swap tokens for ETH
1414         swapTokensForEth(half);
1415         // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1416 
1417         // how much ETH did we just swap into?
1418         uint256 newBalance = address(this).balance.sub(initialBalance);
1419 
1420         // add liquidity to uniswap
1421         addLiquidity(otherHalf, newBalance);
1422 
1423         emit SwapAndLiquify(half, newBalance, otherHalf);
1424     }
1425 
1426     function swapTokensForEth(uint256 tokenAmount) private {
1427         // generate the uniswap pair path of token -> weth
1428         address[] memory path = new address[](2);
1429         path[0] = address(this);
1430         path[1] = uniswapV2Router.WETH();
1431 
1432         _approve(address(this), address(uniswapV2Router), tokenAmount);
1433 
1434         // make the swap
1435         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1436             tokenAmount,
1437             0, // accept any amount of ETH
1438             path,
1439             address(this),
1440             block.timestamp
1441         );
1442     }
1443 
1444     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1445         // approve token transfer to cover all possible scenarios
1446         _approve(address(this), address(uniswapV2Router), tokenAmount);
1447 
1448         // add the liquidity
1449         uniswapV2Router.addLiquidityETH{value : ethAmount}(
1450             address(this),
1451             tokenAmount,
1452             0, // slippage is unavoidable
1453             0, // slippage is unavoidable
1454             owner(),
1455             block.timestamp
1456         );
1457     }
1458 
1459     //this method is responsible for taking all fee, if takeFee is true
1460     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1461 
1462         if (!takeFee) {
1463             removeAllFee();
1464         }
1465 
1466         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1467             _transferFromExcluded(sender, recipient, amount);
1468         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1469             _transferToExcluded(sender, recipient, amount);
1470         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1471             _transferStandard(sender, recipient, amount);
1472         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1473             _transferBothExcluded(sender, recipient, amount);
1474         } else {
1475             _transferStandard(sender, recipient, amount);
1476         }
1477 
1478         if (!takeFee)
1479             restoreAllFee();
1480 
1481     }
1482 
1483     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1484         (rInfo memory rr, tInfo memory tt) = _getValues(tAmount);
1485         _rOwned[sender] = _rOwned[sender].sub(rr.rAmount);
1486         _rOwned[recipient] = _rOwned[recipient].add(rr.rTransferAmount);
1487         _takeLiquidity(tt.tLiquidity);
1488         _reflectFee(rr, tt);
1489 
1490         emit Transfer(sender, recipient, tt.tTransferAmount);
1491     }
1492 
1493     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1494         (rInfo memory rr, tInfo memory tt) = _getValues(tAmount);
1495         _rOwned[sender] = _rOwned[sender].sub(rr.rAmount);
1496         _tOwned[recipient] = _tOwned[recipient].add(tt.tTransferAmount);
1497         _rOwned[recipient] = _rOwned[recipient].add(rr.rTransferAmount);
1498         _takeLiquidity(tt.tLiquidity);
1499         _reflectFee(rr, tt);
1500         emit Transfer(sender, recipient, tt.tTransferAmount);
1501     }
1502 
1503     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1504         (rInfo memory rr, tInfo memory tt) = _getValues(tAmount);
1505         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1506         _rOwned[sender] = _rOwned[sender].sub(rr.rAmount);
1507         _rOwned[recipient] = _rOwned[recipient].add(rr.rTransferAmount);
1508         _takeLiquidity(tt.tLiquidity);
1509         _reflectFee(rr, tt);
1510         emit Transfer(sender, recipient, tt.tTransferAmount);
1511     }
1512 
1513     function getTime() public view returns (uint256){
1514         return block.timestamp;
1515     }
1516 
1517     function getTotalFees() internal view returns (uint256) {
1518         return _charityFee + _liquidityFee + _burnFee + _donationLotteryPrizeFee + _marketingFundFee + _devFundFee;
1519     }
1520 
1521     function getPrizeForEach1k() public view returns (uint256) {
1522         return balanceOf(donationLotteryPrizeWalletAddress);
1523     }
1524 
1525     function getPrizeForHolders() public view returns (uint256) {
1526         return balanceOf(holderAddress);
1527     }
1528 
1529     // view to get illegible holders lottery
1530     function getTicketsByBalance() public view returns (address[] memory){
1531         return ticketsByBalance.getAllAddresses();
1532     }
1533 
1534     function setLotteryHoldersLimit(uint256 val) public onlyOwner {
1535         lotteryHoldersLimit = val;
1536     }
1537     function setDisableTicketsTs(bool status) public onlyOwner {
1538         disableTicketsTs = status;
1539     }
1540 
1541     function setLotteryHolderMinBalance(uint256 val) public onlyOwner {
1542         lotteryHolderMinBalance = val;
1543     }
1544     function setMinimumDonationForTicket(uint256 val) public onlyOwner {
1545         minimumDonationForTicket = val;
1546     }
1547     function setLotteryHoldersEnabled(bool val) public onlyOwner {
1548         lotteryHoldersEnabled = val;
1549     }
1550     function lotteryUserTickets(address _user) public view returns (uint256[] memory){
1551         uint[] memory my = new uint256[](donationLotteryUsers.length);
1552         uint count;
1553         for (uint256 i = 0; i < donationLotteryUsers.length; i++) {
1554             if (donationLotteryUsers[i] == _user) {
1555                 my[count++] = i;
1556             }
1557         }
1558         return my;
1559     }
1560 
1561     function lotteryTotalTicket() public view returns (uint256){
1562         return donationLotteryUsers.length;
1563     }
1564 
1565     // process both lottery
1566 
1567     function lotteryOnTransfer(address user, address to, uint256 value) internal {
1568 
1569         if( donationLotteryEnabled ){
1570             donationLottery(user, to, value);
1571         }
1572 
1573         if( lotteryHoldersEnabled ){
1574             lotteryHolders(user, to);
1575         }
1576     }
1577 
1578 
1579     // 0.5% for holders of certain amount of tokens for random chance every 1000 tx
1580     // lottery that get triggered on N number of TX
1581     event donationLotteryTicket(address user, address to, uint256 value, uint256 donationLotteryIndex, uint256 donationLotteryUsers);
1582     event LotteryTriggerEveryNtx(uint256 ticket, address winner, uint256 prize);
1583     function setDonationLotteryLimit(uint256 val) public onlyOwner {
1584         donationLotteryLimit = val;
1585     }
1586     function setDonationLotteryMinLimit(uint256 val) public onlyOwner {
1587         donationLotteryMinLimit = val;
1588     }
1589     function setDonationLotteryEnabled(bool val) public onlyOwner {
1590         donationLotteryEnabled = val;
1591     }
1592     function setDonationLotteryDebug(bool val) public onlyOwner {
1593         donationLotteryDebug = val;
1594     }
1595     function setLotteryHoldersDebug(bool val) public onlyOwner {
1596         lotteryHoldersDebug = val;
1597     }
1598     function donationLottery(address user, address to, uint256 value) internal {
1599         uint256 prize = getPrizeForEach1k();
1600 
1601         if (value >= minimumDonationForTicket && to == donationAddress) {
1602             // if(donationLotteryDebug) console.log("- donationLottery> donation=%s value=%d donationLotteryLimit=%d", donationLotteryPrizeWalletAddress, value, donationLotteryLimit);
1603             uint256 uts = userTicketsTs[user];
1604             if (disableTicketsTs == false || uts == 0 || uts.add(3600) <= block.timestamp) {
1605                 donationLotteryIndex++;
1606                 donationLotteryUsers.push(user);
1607                 userTicketsTs[user] = block.timestamp;
1608                 emit donationLotteryTicket(user, to, value, donationLotteryIndex, donationLotteryUsers.length);
1609                 // if(donationLotteryDebug) console.log("\tdonationLottery> added index=%d length=%d prize=%d", donationLotteryIndex, donationLotteryUsers.length, prize);
1610             }
1611         }
1612 
1613         // console.log("prize=%d index=%d limit =%d", prize, donationLotteryIndex, donationLotteryLimit);
1614         if (prize > 0 && donationLotteryIndex >= donationLotteryLimit) {
1615             uint256 _mod = donationLotteryUsers.length;
1616             // console.log("\tlength=%d limist=%d", donationLotteryUsers.length, donationLotteryMinLimit);
1617             if (donationLotteryUsers.length < donationLotteryMinLimit){
1618                 return;
1619             }
1620             uint256 _randomNumber;
1621             bytes32 _structHash = keccak256(abi.encode(msg.sender, block.difficulty, gasleft(), prize));
1622             _randomNumber = uint256(_structHash);
1623             assembly {_randomNumber := mod(_randomNumber, _mod)}
1624             donationLotteryWinner = donationLotteryUsers[_randomNumber];
1625             emit LotteryTriggerEveryNtx(_randomNumber, donationLotteryWinner, prize);
1626             _tokenTransfer(donationLotteryPrizeWalletAddress, donationLotteryWinner, prize, false);
1627 //            if(donationLotteryDebug){
1628 //                console.log("\t\tdonationLottery> TRIGGER _mod=%d rnd=%d prize=%d", _mod, _randomNumber, prize);
1629 //                console.log("\t\tdonationLottery> TRIGGER winner=%s", donationLotteryWinner);
1630 //            }
1631             donationLotteryIndex = 0;
1632             delete donationLotteryUsers;
1633         }
1634     }
1635 
1636     // add and remove users according to their balance from holder lottery
1637     //event LotteryAddToHolder(address from, bool status);
1638     function addUserToBalanceLottery(address user) internal {
1639         if (!_isExcludedFromFee[user] && !_isExcluded[user] ){
1640             uint256 balance = balanceOf(user);
1641             bool exists = ticketsByBalance.exists(user);
1642             // emit LotteryAddToHolder(user, exists);
1643             if (balance >= lotteryHolderMinBalance && !exists) {
1644                 ticketsByBalance.pushAddress(user, false);
1645 //                if(lotteryHoldersDebug)
1646 //                    console.log("\t\tADD %s HOLDERS=%d PRIZE=%d", user, ticketsByBalance.size(), getPrizeForHolders()/1e9);
1647             } else if (balance < lotteryHolderMinBalance && exists) {
1648                 ticketsByBalance.removeAddress(user);
1649 //                if(lotteryHoldersDebug)
1650 //                    console.log("\t\tREMOVE HOLDERS=%d PRIZE=%d", ticketsByBalance.size(), getPrizeForHolders()/1e9);
1651             }
1652         }
1653     }
1654 
1655     function lotteryHolders(address user, address to) internal {
1656         uint256 prize = getPrizeForHolders();
1657 
1658         if( user != address(uniswapV2Router) && user != uniswapV2Pair ){
1659             addUserToBalanceLottery(user);
1660         }
1661 
1662         if( to != address(uniswapV2Router) && to != uniswapV2Pair ){
1663             addUserToBalanceLottery(to);
1664         }
1665 
1666 //        if(lotteryHoldersDebug){
1667 //            console.log("\tTICKETS=%d PRIZE=%d, INDEX=%d", ticketsByBalance.size(), prize/1e9, lotteryHoldersIndex );
1668 //        }
1669 
1670         if (prize > 0 && lotteryHoldersIndex >= lotteryHoldersLimit && ticketsByBalance.size() > 0 ) {
1671             uint256 _mod = ticketsByBalance.size() - 1;
1672             uint256 _randomNumber;
1673             bytes32 _structHash = keccak256(abi.encode(msg.sender, block.difficulty, gasleft()));
1674             _randomNumber = uint256(_structHash);
1675             assembly {_randomNumber := mod(_randomNumber, _mod)}
1676             lotteryHoldersWinner = ticketsByBalance._items[_randomNumber];
1677             // console.log("%s %s %s", lotteryHoldersWinner, _randomNumber, ticketsByBalance.size());
1678             emit LotteryHolderChooseOne(ticketsByBalance.size(), lotteryHoldersWinner, prize);
1679             _tokenTransfer(holderAddress, lotteryHoldersWinner, prize, false);
1680 //            if(lotteryHoldersDebug){
1681 //                console.log("\t\tPRIZE=%d index=%d lmt=%d", prize/1e9, lotteryHoldersIndex, lotteryHoldersLimit);
1682 //                console.log("\t\tlotteryHoldersWinner=%s rnd=", lotteryHoldersWinner, _randomNumber);
1683 //            }
1684             lotteryHoldersIndex = 0;
1685         }
1686         lotteryHoldersIndex++;
1687     }
1688 
1689     function setDonationAddress(address val) public onlyOwner {
1690         donationAddress = val;
1691     }
1692     function setHolderAddress(address val) public onlyOwner {
1693         holderAddress = val;
1694     }
1695     function setBurnAddress(address val) public onlyOwner {
1696         burnAddress = val;
1697     }
1698     function setCharityWalletAddress(address val) public onlyOwner {
1699         charityWalletAddress = val;
1700     }
1701     function setDevFundWalletAddress(address val) public onlyOwner {
1702         devFundWalletAddress = val;
1703     }
1704     function setMarketingFundWalletAddress(address val) public onlyOwner {
1705         marketingFundWalletAddress = val;
1706     }
1707     function setDonationLotteryPrizeWalletAddress(address val) public onlyOwner {
1708         donationLotteryPrizeWalletAddress = val;
1709     }
1710     function setFaaSWalletAddress(address val) public onlyOwner {
1711         faaSWalletAddress = val;
1712     }
1713     function updateHolderList(address[] memory holdersToCheck) public onlyOwner {
1714         for( uint i = 0 ; i < holdersToCheck.length ; i ++ ){
1715             addUserToBalanceLottery(holdersToCheck[i]);
1716         }
1717     }
1718 
1719 
1720 }