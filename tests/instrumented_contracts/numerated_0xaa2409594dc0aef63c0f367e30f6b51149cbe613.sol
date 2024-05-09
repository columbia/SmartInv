1 /**
2 
3                      
4 Decentralised Finance (DeFi) is replacing the existing capitalist and corporate structures inhabiting current Banks and Financial Services. We have an exciting new Deflationary Currency with RFI system and liquidity features. Automatic 3% burn and an innovative liquidity addition feature.
5 
6 If we have learned one thing from DOGE making its way into the top 10 cryptocurrencies by market capitalisation, there is plenty of room in the crypto world for a token who’s value rests on internet subculture. After all, why shouldn’t we have our own token that we can use and exchange among ourselves? DOGE is totally capable of this however, will not be able to carry this torch in the long term as it is inherently inflationary. Everyday there are more Dogecoins in circulation and therefore, its value is constantly being diminished by design. This is where Space Doge comes in. Space Doge is a deflationary currency. There will never be more SpaceDoge in circulation than there is now. 
7 
8 Every time a sell transaction takes place with SpaceDoge, 3% of that sell transaction is distributed to liquidity and 3% is burnt from the total supply. This increases the scarcity of every SpaceDoge in circulation. What this means is that everytime SpaceDoge is used, the value of the remaining SpaceDoge in circulation is increased by simultaneously decreasing the supply (deflation). As a result of this, every single SpaceDoge holder has an incentive to spread the use of SpaceDoge as much as possible. As more transactions take place in the network, the individual net-worth of all who own a piece of the network increases as well.
9 
10 Contact us here:
11 
12 Telegram: https://t.me/Space_Doge
13 
14 Twitter: https://twitter.com/The_Space_Doge
15 
16 Website: https://spacedoge.site/ 
17 
18 Medium: https://spacedoge.medium.com
19 
20  */
21 
22 pragma solidity ^0.6.12;
23 
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address payable) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes memory) {
30         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
31         return msg.data;
32     }
33 }
34 
35 
36 /**
37  * @dev Interface of the ERC20 standard as defined in the EIP.
38  */
39 interface IERC20 {
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     /**
51      * @dev Moves `amount` tokens from the caller's account to `recipient`.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * IMPORTANT: Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Moves `amount` tokens from `sender` to `recipient` using the
86      * allowance mechanism. `amount` is then deducted from the caller's
87      * allowance.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 
111 
112 /**
113  * @dev Wrappers over Solidity's arithmetic operations with added overflow
114  * checks.
115  *
116  * Arithmetic operations in Solidity wrap on overflow. This can easily result
117  * in bugs, because programmers usually assume that an overflow raises an
118  * error, which is the standard behavior in high level programming languages.
119  * `SafeMath` restores this intuition by reverting the transaction when an
120  * operation overflows.
121  *
122  * Using this library instead of the unchecked operations eliminates an entire
123  * class of bugs, so it's recommended to use it always.
124  */
125  
126 library SafeMath {
127     /**
128      * @dev Returns the addition of two unsigned integers, reverting on
129      * overflow.
130      *
131      * Counterpart to Solidity's `+` operator.
132      *
133      * Requirements:
134      *
135      * - Addition cannot overflow.
136      */
137     function add(uint256 a, uint256 b) internal pure returns (uint256) {
138         uint256 c = a + b;
139         require(c >= a, "SafeMath: addition overflow");
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      *
152      * - Subtraction cannot overflow.
153      */
154     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
155         return sub(a, b, "SafeMath: subtraction overflow");
156     }
157 
158     /**
159      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
160      * overflow (when the result is negative).
161      *
162      * Counterpart to Solidity's `-` operator.
163      *
164      * Requirements:
165      *
166      * - Subtraction cannot overflow.
167      */
168     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         require(b <= a, errorMessage);
170         uint256 c = a - b;
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the multiplication of two unsigned integers, reverting on
177      * overflow.
178      *
179      * Counterpart to Solidity's `*` operator.
180      *
181      * Requirements:
182      *
183      * - Multiplication cannot overflow.
184      */
185     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
186         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
187         // benefit is lost if 'b' is also tested.
188         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
189         if (a == 0) {
190             return 0;
191         }
192 
193         uint256 c = a * b;
194         require(c / a == b, "SafeMath: multiplication overflow");
195 
196         return c;
197     }
198 
199     /**
200      * @dev Returns the integer division of two unsigned integers. Reverts on
201      * division by zero. The result is rounded towards zero.
202      *
203      * Counterpart to Solidity's `/` operator. Note: this function uses a
204      * `revert` opcode (which leaves remaining gas untouched) while Solidity
205      * uses an invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      *
209      * - The divisor cannot be zero.
210      */
211     function div(uint256 a, uint256 b) internal pure returns (uint256) {
212         return div(a, b, "SafeMath: division by zero");
213     }
214 
215     /**
216      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
217      * division by zero. The result is rounded towards zero.
218      *
219      * Counterpart to Solidity's `/` operator. Note: this function uses a
220      * `revert` opcode (which leaves remaining gas untouched) while Solidity
221      * uses an invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
228         require(b > 0, errorMessage);
229         uint256 c = a / b;
230         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      *
245      * - The divisor cannot be zero.
246      */
247     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
248         return mod(a, b, "SafeMath: modulo by zero");
249     }
250 
251     /**
252      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
253      * Reverts with custom message when dividing by zero.
254      *
255      * Counterpart to Solidity's `%` operator. This function uses a `revert`
256      * opcode (which leaves remaining gas untouched) while Solidity uses an
257      * invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      *
261      * - The divisor cannot be zero.
262      */
263     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         require(b != 0, errorMessage);
265         return a % b;
266     }
267 }
268 
269 /**
270  * @dev Collection of functions related to the address type
271  */
272 library Address {
273     /**
274      * @dev Returns true if `account` is a contract.
275      *
276      * [IMPORTANT]
277      * ====
278      * It is unsafe to assume that an address for which this function returns
279      * false is an externally-owned account (EOA) and not a contract.
280      *
281      * Among others, `isContract` will return false for the following
282      * types of addresses:
283      *
284      *  - an externally-owned account
285      *  - a contract in construction
286      *  - an address where a contract will be created
287      *  - an address where a contract lived, but was destroyed
288      * ====
289      */
290     function isContract(address account) internal view returns (bool) {
291         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
292         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
293         // for accounts without code, i.e. `keccak256('')`
294         bytes32 codehash;
295         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
296         // solhint-disable-next-line no-inline-assembly
297         assembly { codehash := extcodehash(account) }
298         return (codehash != accountHash && codehash != 0x0);
299     }
300 
301     /**
302      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
303      * `recipient`, forwarding all available gas and reverting on errors.
304      *
305      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
306      * of certain opcodes, possibly making contracts go over the 2300 gas limit
307      * imposed by `transfer`, making them unable to receive funds via
308      * `transfer`. {sendValue} removes this limitation.
309      *
310      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
311      *
312      * IMPORTANT: because control is transferred to `recipient`, care must be
313      * taken to not create reentrancy vulnerabilities. Consider using
314      * {ReentrancyGuard} or the
315      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
316      */
317     function sendValue(address payable recipient, uint256 amount) internal {
318         require(address(this).balance >= amount, "Address: insufficient balance");
319 
320         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
321         (bool success, ) = recipient.call{ value: amount }("");
322         require(success, "Address: unable to send value, recipient may have reverted");
323     }
324 
325     /**
326      * @dev Performs a Solidity function call using a low level `call`. A
327      * plain`call` is an unsafe replacement for a function call: use this
328      * function instead.
329      *
330      * If `target` reverts with a revert reason, it is bubbled up by this
331      * function (like regular Solidity function calls).
332      *
333      * Returns the raw returned data. To convert to the expected return value,
334      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
335      *
336      * Requirements:
337      *
338      * - `target` must be a contract.
339      * - calling `target` with `data` must not revert.
340      *
341      * _Available since v3.1._
342      */
343     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
344       return functionCall(target, data, "Address: low-level call failed");
345     }
346 
347     /**
348      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
349      * `errorMessage` as a fallback revert reason when `target` reverts.
350      *
351      * _Available since v3.1._
352      */
353     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
354         return _functionCallWithValue(target, data, 0, errorMessage);
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
359      * but also transferring `value` wei to `target`.
360      *
361      * Requirements:
362      *
363      * - the calling contract must have an ETH balance of at least `value`.
364      * - the called Solidity function must be `payable`.
365      *
366      * _Available since v3.1._
367      */
368     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
369         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
374      * with `errorMessage` as a fallback revert reason when `target` reverts.
375      *
376      * _Available since v3.1._
377      */
378     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
379         require(address(this).balance >= value, "Address: insufficient balance for call");
380         return _functionCallWithValue(target, data, value, errorMessage);
381     }
382 
383     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
384         require(isContract(target), "Address: call to non-contract");
385 
386         // solhint-disable-next-line avoid-low-level-calls
387         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
388         if (success) {
389             return returndata;
390         } else {
391             // Look for revert reason and bubble it up if present
392             if (returndata.length > 0) {
393                 // The easiest way to bubble the revert reason is using memory via assembly
394 
395                 // solhint-disable-next-line no-inline-assembly
396                 assembly {
397                     let returndata_size := mload(returndata)
398                     revert(add(32, returndata), returndata_size)
399                 }
400             } else {
401                 revert(errorMessage);
402             }
403         }
404     }
405 }
406 
407 /**
408  * @dev Contract module which provides a basic access control mechanism, where
409  * there is an account (an owner) that can be granted exclusive access to
410  * specific functions.
411  *
412  * By default, the owner account will be the one that deploys the contract. This
413  * can later be changed with {transferOwnership}.
414  *
415  * This module is used through inheritance. It will make available the modifier
416  * `onlyOwner`, which can be applied to your functions to restrict their use to
417  * the owner.
418  */
419 contract Ownable is Context {
420     address private _owner;
421     address private _previousOwner;
422     uint256 private _lockTime;
423 
424     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
425 
426     /**
427      * @dev Initializes the contract setting the deployer as the initial owner.
428      */
429     constructor () internal {
430         address msgSender = _msgSender();
431         _owner = _msgSender();
432         emit OwnershipTransferred(address(0), msgSender);
433     }
434 
435     /**
436      * @dev Returns the address of the current owner.
437      */
438     function owner() public view returns (address) {
439         return _owner;
440     }
441 
442     /**
443      * @dev Throws if called by any account other than the owner.
444      */
445     modifier onlyOwner() {
446         require(_owner == _msgSender(), "Ownable: caller is not the owner");
447         _;
448     }
449 
450      /**
451      * @dev Leaves the contract without owner. It will not be possible to call
452      * `onlyOwner` functions anymore. Can only be called by the current owner.
453      *
454      * NOTE: Renouncing ownership will leave the contract without an owner,
455      * thereby removing any functionality that is only available to the owner.
456      */
457     function renounceOwnership() public virtual onlyOwner {
458         emit OwnershipTransferred(_owner, address(0));
459         _owner = address(0);
460     }
461 
462     /**
463      * @dev Transfers ownership of the contract to a new account (`newOwner`).
464      * Can only be called by the current owner.
465      */
466     function transferOwnership(address newOwner) public virtual onlyOwner {
467         require(newOwner != address(0), "Ownable: new owner is the zero address");
468         emit OwnershipTransferred(_owner, newOwner);
469         _owner = newOwner;
470     }
471 
472     function geUnlockTime() public view returns (uint256) {
473         return _lockTime;
474     }
475 
476     //Locks the contract for owner for the amount of time provided
477     function lock(uint256 time) public virtual onlyOwner {
478         _previousOwner = _owner;
479         _owner = address(0);
480         _lockTime = now + time;
481         emit OwnershipTransferred(_owner, address(0));
482     }
483     
484     //Unlocks the contract for owner when _lockTime is exceeds
485     function unlock() public virtual {
486         require(_previousOwner == msg.sender, "You don't have permission to unlock");
487         require(now > _lockTime , "Contract is locked until 7 days");
488         emit OwnershipTransferred(_owner, _previousOwner);
489         _owner = _previousOwner;
490     }
491 }
492 
493 // pragma solidity >=0.5.0;
494 
495 interface IPancakeFactory {
496     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
497 
498     function feeTo() external view returns (address);
499     function feeToSetter() external view returns (address);
500 
501     function getPair(address tokenA, address tokenB) external view returns (address pair);
502     function allPairs(uint) external view returns (address pair);
503     function allPairsLength() external view returns (uint);
504 
505     function createPair(address tokenA, address tokenB) external returns (address pair);
506 
507     function setFeeTo(address) external;
508     function setFeeToSetter(address) external;
509 }
510 
511 // pragma solidity >=0.5.0;
512 
513 interface IPancakePair {
514     event Approval(address indexed owner, address indexed spender, uint value);
515     event Transfer(address indexed from, address indexed to, uint value);
516 
517     function name() external pure returns (string memory);
518     function symbol() external pure returns (string memory);
519     function decimals() external pure returns (uint8);
520     function totalSupply() external view returns (uint);
521     function balanceOf(address owner) external view returns (uint);
522     function allowance(address owner, address spender) external view returns (uint);
523 
524     function approve(address spender, uint value) external returns (bool);
525     function transfer(address to, uint value) external returns (bool);
526     function transferFrom(address from, address to, uint value) external returns (bool);
527 
528     function DOMAIN_SEPARATOR() external view returns (bytes32);
529     function PERMIT_TYPEHASH() external pure returns (bytes32);
530     function nonces(address owner) external view returns (uint);
531 
532     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
533 
534     event Mint(address indexed sender, uint amount0, uint amount1);
535     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
536     event Swap(
537         address indexed sender,
538         uint amount0In,
539         uint amount1In,
540         uint amount0Out,
541         uint amount1Out,
542         address indexed to
543     );
544     event Sync(uint112 reserve0, uint112 reserve1);
545 
546     function MINIMUM_LIQUIDITY() external pure returns (uint);
547     function factory() external view returns (address);
548     function token0() external view returns (address);
549     function token1() external view returns (address);
550     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
551     function price0CumulativeLast() external view returns (uint);
552     function price1CumulativeLast() external view returns (uint);
553     function kLast() external view returns (uint);
554 
555     function mint(address to) external returns (uint liquidity);
556     function burn(address to) external returns (uint amount0, uint amount1);
557     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
558     function skim(address to) external;
559     function sync() external;
560 
561     function initialize(address, address) external;
562 }
563 
564 // pragma solidity >=0.6.2;
565 
566 interface IPancakeRouter01 {
567     function factory() external pure returns (address);
568     function WETH() external pure returns (address);
569 
570     function addLiquidity(
571         address tokenA,
572         address tokenB,
573         uint amountADesired,
574         uint amountBDesired,
575         uint amountAMin,
576         uint amountBMin,
577         address to,
578         uint deadline
579     ) external returns (uint amountA, uint amountB, uint liquidity);
580     function addLiquidityETH(
581         address token,
582         uint amountTokenDesired,
583         uint amountTokenMin,
584         uint amountETHMin,
585         address to,
586         uint deadline
587     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
588     function removeLiquidity(
589         address tokenA,
590         address tokenB,
591         uint liquidity,
592         uint amountAMin,
593         uint amountBMin,
594         address to,
595         uint deadline
596     ) external returns (uint amountA, uint amountB);
597     function removeLiquidityETH(
598         address token,
599         uint liquidity,
600         uint amountTokenMin,
601         uint amountETHMin,
602         address to,
603         uint deadline
604     ) external returns (uint amountToken, uint amountETH);
605     function removeLiquidityWithPermit(
606         address tokenA,
607         address tokenB,
608         uint liquidity,
609         uint amountAMin,
610         uint amountBMin,
611         address to,
612         uint deadline,
613         bool approveMax, uint8 v, bytes32 r, bytes32 s
614     ) external returns (uint amountA, uint amountB);
615     function removeLiquidityETHWithPermit(
616         address token,
617         uint liquidity,
618         uint amountTokenMin,
619         uint amountETHMin,
620         address to,
621         uint deadline,
622         bool approveMax, uint8 v, bytes32 r, bytes32 s
623     ) external returns (uint amountToken, uint amountETH);
624     function swapExactTokensForTokens(
625         uint amountIn,
626         uint amountOutMin,
627         address[] calldata path,
628         address to,
629         uint deadline
630     ) external returns (uint[] memory amounts);
631     function swapTokensForExactTokens(
632         uint amountOut,
633         uint amountInMax,
634         address[] calldata path,
635         address to,
636         uint deadline
637     ) external returns (uint[] memory amounts);
638     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
639         external
640         payable
641         returns (uint[] memory amounts);
642     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
643         external
644         returns (uint[] memory amounts);
645     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
646         external
647         returns (uint[] memory amounts);
648     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
649         external
650         payable
651         returns (uint[] memory amounts);
652 
653     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
654     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
655     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
656     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
657     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
658 }
659 
660 
661 
662 // pragma solidity >=0.6.2;
663 
664 interface IPancakeRouter02 is IPancakeRouter01 {
665     function removeLiquidityETHSupportingFeeOnTransferTokens(
666         address token,
667         uint liquidity,
668         uint amountTokenMin,
669         uint amountETHMin,
670         address to,
671         uint deadline
672     ) external returns (uint amountETH);
673     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
674         address token,
675         uint liquidity,
676         uint amountTokenMin,
677         uint amountETHMin,
678         address to,
679         uint deadline,
680         bool approveMax, uint8 v, bytes32 r, bytes32 s
681     ) external returns (uint amountETH);
682 
683     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
684         uint amountIn,
685         uint amountOutMin,
686         address[] calldata path,
687         address to,
688         uint deadline
689     ) external;
690     function swapExactETHForTokensSupportingFeeOnTransferTokens(
691         uint amountOutMin,
692         address[] calldata path,
693         address to,
694         uint deadline
695     ) external payable;
696     function swapExactTokensForETHSupportingFeeOnTransferTokens(
697         uint amountIn,
698         uint amountOutMin,
699         address[] calldata path,
700         address to,
701         uint deadline
702     ) external;
703 }
704 
705 
706 contract SpaceDoge is Context, IERC20, Ownable {
707     using SafeMath for uint256;
708     using Address for address;
709 
710     mapping (address => uint256) private _rOwned;
711     mapping (address => uint256) private _tOwned;
712     mapping (address => mapping (address => uint256)) private _allowances;
713     mapping (address => bool) private _isExcludedFromFee;
714 
715     mapping (address => bool) private _isExcluded;
716     address[] private _excluded;
717    
718   uint allTheEth;
719     uint256 private constant MAX = ~uint256(0);
720     uint256 private _tTotal = 10000000000 * 10**2 * 10**9;
721     uint256 private _rTotal = (MAX - (MAX % _tTotal));
722     uint256 private _tFeeTotal;
723 
724 
725     string private _name = "Space Doge";
726     string private _symbol = "SpaceDoge";
727     uint8 private _decimals = 9;
728     
729     uint256 public _taxFee = 0;
730     uint256 private _previousTaxFee = _taxFee;
731     
732     uint256 public _liquidityFee = 0;
733     uint256 private _previousLiquidityFee = _liquidityFee;
734     
735     address [] public tokenHolder;
736     uint256 public numberOfTokenHolders = 0;
737     mapping(address => bool) public exist;
738 
739     //No limit
740    address payable wallet;
741     IPancakeRouter02 public immutable pancakeRouter;
742     address public immutable pancakePair;
743     
744     bool inSwapAndLiquify;
745     bool public swapAndLiquifyEnabled = false;
746     uint256 private minTokensBeforeSwap = 8;
747 
748    uint256 public _maxTxAmount = 10000000000 * 10**2 * 10**9;
749     
750 
751     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
752     event SwapAndLiquifyEnabledUpdated(bool enabled);
753     event SwapAndLiquify(
754         uint256 tokensSwapped,
755         uint256 ethReceived,
756         uint256 tokensIntoLiqudity
757     );
758     
759     modifier lockTheSwap {
760         inSwapAndLiquify = true;
761          _;
762         inSwapAndLiquify = false;
763     }
764     
765     constructor () public {
766         _rOwned[_msgSender()] = _rTotal;
767         wallet = msg.sender;
768         IPancakeRouter02 _pancakeRouter = IPancakeRouter02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
769          // Create a pancake pair for this new token
770         pancakePair = IPancakeFactory(_pancakeRouter.factory())
771             .createPair(address(this), _pancakeRouter.WETH());
772 
773         // set the rest of the contract variables
774         pancakeRouter = _pancakeRouter;
775         
776         //exclude owner and this contract from fee
777         _isExcludedFromFee[owner()] = true;
778         _isExcludedFromFee[address(this)] = true;
779         
780         emit Transfer(address(0), _msgSender(), _tTotal);
781     }
782 
783     function name() public view returns (string memory) {
784         return _name;
785     }
786 
787     function symbol() public view returns (string memory) {
788         return _symbol;
789     }
790 
791     function decimals() public view returns (uint8) {
792         return _decimals;
793     }
794 
795     function totalSupply() public view override returns (uint256) {
796         return _tTotal;
797     }
798 
799     function balanceOf(address account) public view override returns (uint256) {
800         if (_isExcluded[account]) return _tOwned[account];
801         return tokenFromReflection(_rOwned[account]);
802     }
803 
804     function transfer(address recipient, uint256 amount) public override returns (bool) {
805         _transfer(_msgSender(), recipient, amount);
806         return true;
807     }
808 
809     function allowance(address owner, address spender) public view override returns (uint256) {
810         return _allowances[owner][spender];
811     }
812 
813     function approve(address spender, uint256 amount) public override returns (bool) {
814         _approve(_msgSender(), spender, amount);
815         return true;
816     }
817 
818 function withdrawEther() external onlyOwner {
819     msg.sender.transfer(address(this).balance);
820 }
821 
822     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
823         _transfer(sender, recipient, amount);
824         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
825         return true;
826     }
827 
828     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
829         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
830         return true;
831     }
832 
833     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
834         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
835         return true;
836     }
837 
838    
839 
840     function totalFees() public view returns (uint256) {
841         return _tFeeTotal;
842     }
843 
844     function deliver(uint256 tAmount) public {
845         address sender = _msgSender();
846         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
847         (uint256 rAmount,,,,,) = _getValues(tAmount);
848         _rOwned[sender] = _rOwned[sender].sub(rAmount);
849         _rTotal = _rTotal.sub(rAmount);
850         _tFeeTotal = _tFeeTotal.add(tAmount);
851     }
852 
853     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
854         require(tAmount <= _tTotal, "Amount must be less than supply");
855         if (!deductTransferFee) {
856             (uint256 rAmount,,,,,) = _getValues(tAmount);
857             return rAmount;
858         } else {
859             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
860             return rTransferAmount;
861         }
862     }
863 
864     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
865         require(rAmount <= _rTotal, "Amount must be less than total reflections");
866         uint256 currentRate =  _getRate();
867         return rAmount.div(currentRate);
868     }
869 
870    
871     function _approve(address owner, address spender, uint256 amount) private {
872         require(owner != address(0));
873         require(spender != address(0));
874 
875         _allowances[owner][spender] = amount;
876         emit Approval(owner, spender, amount);
877     }
878 
879     bool public limit = true;
880     function changeLimit() public onlyOwner(){
881         require(limit == true, 'limit is already false');
882             limit = false;
883     }
884     
885     
886     function _transfer(
887         address from,
888         address to,
889         uint256 amount
890     ) 
891 
892 private {
893         require(from != address(0), "ERC20: transfer from the zero address");
894         require(to != address(0), "ERC20: transfer to the zero address");
895         require(amount > 0, "Transfer amount must be greater than zero");
896         if(limit ==  true && from != owner() && to != owner()){
897             if(to != pancakePair){
898                 require(((balanceOf(to).add(amount)) <= 500 ether));
899             }
900             require(amount <= 100 ether, 'Transfer amount must be less than 100 tokens');
901             }
902         if(from != owner() && to != owner())
903             require(amount <= _maxTxAmount);
904 
905         // is the token balance of this contract address over the min number of
906         // tokens that we need to initiate a swap + liquidity lock?
907         // also, don't get caught in a circular liquidity event.
908         // also, don't swap & liquify if sender is pancake pair.
909         if(!exist[to]){
910             tokenHolder.push(to);
911             numberOfTokenHolders++;
912             exist[to] = true;
913         }
914         uint256 contractTokenBalance = balanceOf(address(this));
915         bool overMinTokenBalance = contractTokenBalance >= minTokensBeforeSwap;
916         if (
917             overMinTokenBalance &&
918             !inSwapAndLiquify &&
919             from != pancakePair &&
920             swapAndLiquifyEnabled
921         ) {
922             //add liquidity
923             swapAndLiquify(contractTokenBalance);
924         }
925         
926         //indicates if fee should be deducted from transfer
927         bool takeFee = true;
928         
929         //if any account belongs to _isExcludedFromFee account then remove the fee
930         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
931             takeFee = false;
932         }
933         
934         //transfer amount, it will take tax, burn, liquidity fee
935         _tokenTransfer(from,to,amount,takeFee);
936     }
937     function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
938         // split the contract balance into halves
939         uint256 forLiquidity = contractTokenBalance.div(2);
940         uint256 devExp = contractTokenBalance.div(2);
941         // split the liquidity
942         uint256 half = forLiquidity.div(2);
943         uint256 otherHalf = forLiquidity.sub(half);
944         // capture the contract's current ETH balance.
945         // this is so that we can capture exactly the amount of ETH that the
946         // swap creates, and not make the liquidity event include any ETH that
947         // has been manually sent to the contract
948         uint256 initialBalance = address(this).balance;
949 
950         // swap tokens for ETH
951         swapTokensForEth(devExp); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
952 
953         // how much ETH did we just swap into?
954         uint256 Balance = address(this).balance.sub(initialBalance);
955         uint256 oneThird = Balance.div(3);
956         wallet.transfer(oneThird);
957 
958        // for(uint256 i = 0; i < numberOfTokenHolders; i++){
959          //   uint256 share = (balanceOf(tokenHolder[i]).mul(ethFees)).div(totalSupply());
960         //}
961         // add liquidity to pancake
962         addLiquidity(otherHalf, oneThird);
963         
964         emit SwapAndLiquify(half, oneThird, otherHalf);
965     }
966     function swapTokensForEth(uint256 tokenAmount) private {
967         // generate the pancake pair path of token -> weth
968         address[] memory path = new address[](2);
969         path[0] = address(this);
970         path[1] = pancakeRouter.WETH();
971 
972         _approve(address(this), address(pancakeRouter), tokenAmount);
973 
974         // make the swap
975         pancakeRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
976             tokenAmount,
977             0, // accept any amount of ETH
978             path,
979             address(this),
980             block.timestamp
981         );
982     }
983 
984     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
985         // approve token transfer to cover all possible scenarios
986         _approve(address(this), address(pancakeRouter), tokenAmount);
987 
988         // add the liquidity
989         pancakeRouter.addLiquidityETH{value: ethAmount}(
990             address(this),
991             tokenAmount,
992             0, // slippage is unavoidable
993             0, // slippage is unavoidable
994             owner(),
995             block.timestamp
996         );
997     }
998 
999     //this method is responsible for taking all fee, if takeFee is true
1000     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1001         if(!takeFee)
1002             removeAllFee();
1003         
1004         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1005             _transferFromExcluded(sender, recipient, amount);
1006         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1007             _transferToExcluded(sender, recipient, amount);
1008         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1009             _transferStandard(sender, recipient, amount);
1010         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1011             _transferBothExcluded(sender, recipient, amount);
1012         } else {
1013             _transferStandard(sender, recipient, amount);
1014         }
1015         
1016         if(!takeFee)
1017             restoreAllFee();
1018     }
1019 
1020     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1021         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1022         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1023         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1024         _takeLiquidity(tLiquidity);
1025         _reflectFee(rFee, tFee);
1026         emit Transfer(sender, recipient, tTransferAmount);
1027     }
1028 
1029     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1030         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1031         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1032         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1033         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1034         _takeLiquidity(tLiquidity);
1035         _reflectFee(rFee, tFee);
1036         emit Transfer(sender, recipient, tTransferAmount);
1037     }
1038 
1039     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1040         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1041         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1042         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1043         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1044         _takeLiquidity(tLiquidity);
1045         _reflectFee(rFee, tFee);
1046         emit Transfer(sender, recipient, tTransferAmount);
1047     }
1048 
1049     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1050         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getValues(tAmount);
1051         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1052         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1053         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1054         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1055         _takeLiquidity(tLiquidity);
1056         _reflectFee(rFee, tFee);
1057         emit Transfer(sender, recipient, tTransferAmount);
1058     }
1059 
1060     function _reflectFee(uint256 rFee, uint256 tFee) private {
1061         _rTotal = _rTotal.sub(rFee);
1062         _tFeeTotal = _tFeeTotal.add(tFee);
1063     }
1064 
1065     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1066         (uint256 tTransferAmount, uint256 tFee, uint256 tLiquidity) = _getTValues(tAmount);
1067         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tLiquidity, _getRate());
1068         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tLiquidity);
1069     }
1070 
1071     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1072         uint256 tFee = calculateTaxFee(tAmount);
1073         uint256 tLiquidity = calculateLiquidityFee(tAmount);
1074         uint256 tTransferAmount = tAmount.sub(tFee).sub(tLiquidity);
1075         return (tTransferAmount, tFee, tLiquidity);
1076     }
1077 
1078     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tLiquidity, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1079         uint256 rAmount = tAmount.mul(currentRate);
1080         uint256 rFee = tFee.mul(currentRate);
1081         uint256 rLiquidity = tLiquidity.mul(currentRate);
1082         uint256 rTransferAmount = rAmount.sub(rFee).sub(rLiquidity);
1083         return (rAmount, rTransferAmount, rFee);
1084     }
1085 
1086     function _getRate() private view returns(uint256) {
1087         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1088         return rSupply.div(tSupply);
1089     }
1090 
1091     function _getCurrentSupply() private view returns(uint256, uint256) {
1092         uint256 rSupply = _rTotal;
1093         uint256 tSupply = _tTotal;      
1094         for (uint256 i = 0; i < _excluded.length; i++) {
1095             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1096             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1097             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1098         }
1099         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1100         return (rSupply, tSupply);
1101     }
1102     
1103     function _takeLiquidity(uint256 tLiquidity) private {
1104         uint256 currentRate =  _getRate();
1105         uint256 rLiquidity = tLiquidity.mul(currentRate);
1106         _rOwned[address(this)] = _rOwned[address(this)].add(rLiquidity);
1107         if(_isExcluded[address(this)])
1108             _tOwned[address(this)] = _tOwned[address(this)].add(tLiquidity);
1109     }
1110     
1111     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1112         return _amount.mul(_taxFee).div(
1113             10**2
1114         );
1115     }
1116 
1117     function calculateLiquidityFee(uint256 _amount) private view returns (uint256) {
1118         return _amount.mul(_liquidityFee).div(
1119             10**2
1120         );
1121     }
1122     
1123     function removeAllFee() private {
1124         if(_taxFee == 0 && _liquidityFee == 0) return;
1125         
1126         _previousTaxFee = _taxFee;
1127         _previousLiquidityFee = _liquidityFee;
1128         
1129         _taxFee = 0;
1130         _liquidityFee = 0;
1131     }
1132     
1133     function restoreAllFee() private {
1134         _taxFee = _previousTaxFee;
1135         _liquidityFee = _previousLiquidityFee;
1136     }
1137     
1138     function isExcludedFromFee(address account) public view returns(bool) {
1139         return _isExcludedFromFee[account];
1140     }
1141     
1142     function excludeFromFee(address account) public onlyOwner {
1143         _isExcludedFromFee[account] = true;
1144     }
1145     
1146     function includeInFee(address account) public onlyOwner {
1147         _isExcludedFromFee[account] = false;
1148     }
1149     
1150     function setTaxFeePercent(uint256 taxFee) external onlyOwner() {
1151         _taxFee = taxFee;
1152     }
1153     
1154     function setLiquidityFeePercent(uint256 liquidityFee) external onlyOwner() {
1155         require(liquidityFee <= 10, "Maximum fee limit is 10 percent");
1156         _liquidityFee = liquidityFee;
1157     }
1158    
1159     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1160         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1161             10**2
1162         );
1163     }
1164 
1165     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1166         swapAndLiquifyEnabled = _enabled;
1167         emit SwapAndLiquifyEnabledUpdated(_enabled);
1168     }
1169     
1170      //to recieve ETH from pancakeRouter when swaping
1171     receive() external payable {}
1172 }