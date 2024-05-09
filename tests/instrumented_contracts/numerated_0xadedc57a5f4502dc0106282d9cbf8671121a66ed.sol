1 /**
2  * 
3  * 
4  * 
5  MMMMMMMMMMMMWNX0kxdolccccccllooxkO0XNMMMMMMMMMMMMM
6  MMMMMMMMMWX0xoc:::::::::ccc:cccccclldk0NWMMMMMMMMM
7  MMMMMMMN0xc;;;;;;;;;:::okkdc::cccccccclokKWMMMMMMM
8  MMMMMN0o:,,,,,;;,;;;;:dOK0Oxc::::cccccccclx0WMMMMM
9  MMMWKd;,,,,,,,,,,,,,:d0KK000xl::::::ccccccclxKWMMM
10  MMNOc,'''''''','',,:x0KK00000kl::::::::cccccco0WMM
11  MNk:'''''''''''''':xKKKK000000ko:;;:::::cccccclONM
12  Nk:'''''''''....'ckKKKK00OOOO00Oo:;;::::ccccccclOW
13  0c''''''.......'lO000000OkkkkkOOOd:;;;::::cccccco0
14  o,''''.........'lkO00000Okkkkkkkxdc;;;:::::ccccclx
15  c''''...........,:cldO00Okkkxdollc;;;;;::::cccccco
16  ;'''............'ldoccldddocccoddc,,;;;;:::ccccccl
17  ;''''..........''':k0kdl::coxOOo;,,,,;;;::::cccccl
18  :''''......,,;loo;.,d0KK0OO00xc,'',,,;;;:::ccccccl
19  l,'''....':oolccc;...cOKK00Od;''',,,,;;;:::ccccccd
20  x;''''..':ooccllc'..';oO000kl:,,,,,,;;;::::ccccclk
21  Xo,'''.':ll::oddocclooodkkkxddoc:;;;;;;;:::cccclxX
22  W0l,'''';ol:looodxxdddoodddddoooooc;;;;::::ccccdKW
23  MW0l,''';lolc;,,lkxdxxddooooolllool;,;;:::cccldKWM
24  MMWXd;''',,'...'lxxdxkkxdooolcclool;,;::::cclkXWMM
25  MMMMN0o;'''.....;lodxxkxdooolcclolc,,;::::cd0NMMMM
26  MMMMMMNOo;,'''''.',:ldkxdooolc::;;,,;;::ld0NMMMMMM
27  MMMMMMMMNKxl;,''''''';cllcc:;,,,,,;;:cokKNMMMMMMMM
28  MMMMMMMMMMWNKkdl:;,''''','''',,;:coxOKNMMMMMMMMMMM
29  MMMMMMMMMMMMMMWNKOdoc:;;;;;::loxOKNWMMMMMMMMMMMMMM
30 
31  Evergive Token 
32 
33  Description
34 
35  Get rewarded extra tokens when you buy the dip! Dumpers get taxed when they sell below the moving 
36  average and that funds the buy back wallet, then those tokens get burned! FIRST EVER TOKENOMICS of 
37  its kind and the FOMO will never be so real! So don’t miss out and join the telegram!! Solving the 
38  problems in the world of Crypto. Lets start off with building a great and strong community here.
39 
40  Token Features:
41  
42  2% Charity Wallet
43  1% Dev Wallet
44  2% Marketing Wallet
45  3% Auto Liquidity
46  1% Buy Back Wallet
47  1% Buy-the-dip Bonus
48  
49  visit https://evergive.io for more information!
50 */
51 
52 pragma solidity ^0.8.4;
53 // SPDX-License-Identifier: Unlicensed
54 
55 interface IERC20 {
56     function totalSupply() external view returns (uint256);
57 
58     /**
59      * @dev Returns the amount of tokens owned by `account`.
60      */
61     function balanceOf(address account) external view returns (uint256);
62 
63     /**
64      * @dev Moves `amount` tokens from the caller's account to `recipient`.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transfer(address recipient, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Returns the remaining number of tokens that `spender` will be
74      * allowed to spend on behalf of `owner` through {transferFrom}. This is
75      * zero by default.
76      *
77      * This value changes when {approve} or {transferFrom} are called.
78      */
79     function allowance(address owner, address spender) external view returns (uint256);
80 
81     /**
82      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * IMPORTANT: Beware that changing an allowance with this method brings the risk
87      * that someone may use both the old and the new allowance by unfortunate
88      * transaction ordering. One possible solution to mitigate this race
89      * condition is to first reduce the spender's allowance to 0 and set the
90      * desired value afterwards:
91      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
92      *
93      * Emits an {Approval} event.
94      */
95     function approve(address spender, uint256 amount) external returns (bool);
96 
97     /**
98      * @dev Moves `amount` tokens from `sender` to `recipient` using the
99      * allowance mechanism. `amount` is then deducted from the caller's
100      * allowance.
101      *
102      * Returns a boolean value indicating whether the operation succeeded.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
107 
108     /**
109      * @dev Emitted when `value` tokens are moved from one account (`from`) to
110      * another (`to`).
111      *
112      * Note that `value` may be zero.
113      */
114     event Transfer(address indexed from, address indexed to, uint256 value);
115 
116     /**
117      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
118      * a call to {approve}. `value` is the new allowance.
119      */
120     event Approval(address indexed owner, address indexed spender, uint256 value);
121 }
122 
123 /**
124  * @dev Wrappers over Solidity's arithmetic operations with added overflow
125  * checks.
126  *
127  * Arithmetic operations in Solidity wrap on overflow. This can easily result
128  * in bugs, because programmers usually assume that an overflow raises an
129  * error, which is the standard behavior in high level programming languages.
130  * `SafeMath` restores this intuition by reverting the transaction when an
131  * operation overflows.
132  *
133  * Using this library instead of the unchecked operations eliminates an entire
134  * class of bugs, so it's recommended to use it always.
135  */
136 library SafeMath {
137   /**
138    * @dev Returns the addition of two unsigned integers, reverting on
139    * overflow.
140    *
141    * Counterpart to Solidity's `+` operator.
142    *
143    * Requirements:
144    * - Addition cannot overflow.
145    */
146   function add(uint256 a, uint256 b) internal pure returns (uint256) {
147     uint256 c = a + b;
148     require(c >= a, "SafeMath: addition overflow");
149 
150     return c;
151   }
152 
153   /**
154    * @dev Returns the subtraction of two unsigned integers, reverting on
155    * overflow (when the result is negative).
156    *
157    * Counterpart to Solidity's `-` operator.
158    *
159    * Requirements:
160    * - Subtraction cannot overflow.
161    */
162   function sub(uint256 a, uint256 b) internal pure returns (uint256) {
163     return sub(a, b, "SafeMath: subtraction overflow");
164   }
165 
166   /**
167    * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
168    * overflow (when the result is negative).
169    *
170    * Counterpart to Solidity's `-` operator.
171    *
172    * Requirements:
173    * - Subtraction cannot overflow.
174    */
175   function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
176     require(b <= a, errorMessage);
177     uint256 c = a - b;
178 
179     return c;
180   }
181 
182   /**
183    * @dev Returns the multiplication of two unsigned integers, reverting on
184    * overflow.
185    *
186    * Counterpart to Solidity's `*` operator.
187    *
188    * Requirements:
189    * - Multiplication cannot overflow.
190    */
191   function mul(uint256 a, uint256 b) internal pure returns (uint256) {
192     // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
193     // benefit is lost if 'b' is also tested.
194     // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
195     if (a == 0) {
196       return 0;
197     }
198 
199     uint256 c = a * b;
200     require(c / a == b, "SafeMath: multiplication overflow");
201 
202     return c;
203   }
204 
205   /**
206    * @dev Returns the integer division of two unsigned integers. Reverts on
207    * division by zero. The result is rounded towards zero.
208    *
209    * Counterpart to Solidity's `/` operator. Note: this function uses a
210    * `revert` opcode (which leaves remaining gas untouched) while Solidity
211    * uses an invalid opcode to revert (consuming all remaining gas).
212    *
213    * Requirements:
214    * - The divisor cannot be zero.
215    */
216   function div(uint256 a, uint256 b) internal pure returns (uint256) {
217     return div(a, b, "SafeMath: division by zero");
218   }
219 
220   /**
221    * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
222    * division by zero. The result is rounded towards zero.
223    *
224    * Counterpart to Solidity's `/` operator. Note: this function uses a
225    * `revert` opcode (which leaves remaining gas untouched) while Solidity
226    * uses an invalid opcode to revert (consuming all remaining gas).
227    *
228    * Requirements:
229    * - The divisor cannot be zero.
230    */
231   function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
232     // Solidity only automatically asserts when dividing by 0
233     require(b > 0, errorMessage);
234     uint256 c = a / b;
235     // assert(a == b * c + a % b); // There is no case in which this doesn't hold
236 
237     return c;
238   }
239 
240   /**
241    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242    * Reverts when dividing by zero.
243    *
244    * Counterpart to Solidity's `%` operator. This function uses a `revert`
245    * opcode (which leaves remaining gas untouched) while Solidity uses an
246    * invalid opcode to revert (consuming all remaining gas).
247    *
248    * Requirements:
249    * - The divisor cannot be zero.
250    */
251   function mod(uint256 a, uint256 b) internal pure returns (uint256) {
252     return mod(a, b, "SafeMath: modulo by zero");
253   }
254 
255   /**
256    * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
257    * Reverts with custom message when dividing by zero.
258    *
259    * Counterpart to Solidity's `%` operator. This function uses a `revert`
260    * opcode (which leaves remaining gas untouched) while Solidity uses an
261    * invalid opcode to revert (consuming all remaining gas).
262    *
263    * Requirements:
264    * - The divisor cannot be zero.
265    */
266   function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
267     require(b != 0, errorMessage);
268     return a % b;
269   }
270 }
271 
272 /*
273  * @dev Provides information about the current execution context, including the
274  * sender of the transaction and its data. While these are generally available
275  * via msg.sender and msg.data, they should not be accessed in such a direct
276  * manner, since when dealing with GSN meta-transactions the account sending and
277  * paying for execution may not be the actual sender (as far as an application
278  * is concerned).
279  *
280  * This contract is only required for intermediate, library-like contracts.
281  */
282 abstract contract Context {
283     function _msgSender() internal view virtual returns (address payable) {
284         return payable(msg.sender);
285     }
286 
287     function _msgData() internal view virtual returns (bytes memory) {
288         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
289         return msg.data;
290     }
291 }
292 
293 /**
294  * @dev Collection of functions related to the address type
295  */
296 library Address {
297     /**
298      * @dev Returns true if `account` is a contract.
299      *
300      * [IMPORTANT]
301      * ====
302      * It is unsafe to assume that an address for which this function returns
303      * false is an externally-owned account (EOA) and not a contract.
304      *
305      * Among others, `isContract` will return false for the following
306      * types of addresses:
307      *
308      *  - an externally-owned account
309      *  - a contract in construction
310      *  - an address where a contract will be created
311      *  - an address where a contract lived, but was destroyed
312      * ====
313      */
314     function isContract(address account) internal view returns (bool) {
315         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
316         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
317         // for accounts without code, i.e. `keccak256('')`
318         bytes32 codehash;
319         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
320         // solhint-disable-next-line no-inline-assembly
321         assembly { codehash := extcodehash(account) }
322         return (codehash != accountHash && codehash != 0x0);
323     }
324 
325     /**
326      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
327      * `recipient`, forwarding all available gas and reverting on errors.
328      *
329      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
330      * of certain opcodes, possibly making contracts go over the 2300 gas limit
331      * imposed by `transfer`, making them unable to receive funds via
332      * `transfer`. {sendValue} removes this limitation.
333      *
334      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
335      *
336      * IMPORTANT: because control is transferred to `recipient`, care must be
337      * taken to not create reentrancy vulnerabilities. Consider using
338      * {ReentrancyGuard} or the
339      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
340      */
341     function sendValue(address payable recipient, uint256 amount) internal {
342         require(address(this).balance >= amount, "Address: insufficient balance");
343 
344         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
345         (bool success, ) = recipient.call{ value: amount }("");
346         require(success, "Address: unable to send value, recipient may have reverted");
347     }
348 
349     /**
350      * @dev Performs a Solidity function call using a low level `call`. A
351      * plain`call` is an unsafe replacement for a function call: use this
352      * function instead.
353      *
354      * If `target` reverts with a revert reason, it is bubbled up by this
355      * function (like regular Solidity function calls).
356      *
357      * Returns the raw returned data. To convert to the expected return value,
358      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
359      *
360      * Requirements:
361      *
362      * - `target` must be a contract.
363      * - calling `target` with `data` must not revert.
364      *
365      * _Available since v3.1._
366      */
367     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
368       return functionCall(target, data, "Address: low-level call failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
373      * `errorMessage` as a fallback revert reason when `target` reverts.
374      *
375      * _Available since v3.1._
376      */
377     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
378         return _functionCallWithValue(target, data, 0, errorMessage);
379     }
380 
381     /**
382      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
383      * but also transferring `value` wei to `target`.
384      *
385      * Requirements:
386      *
387      * - the calling contract must have an ETH balance of at least `value`.
388      * - the called Solidity function must be `payable`.
389      *
390      * _Available since v3.1._
391      */
392     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
393         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
394     }
395 
396     /**
397      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
398      * with `errorMessage` as a fallback revert reason when `target` reverts.
399      *
400      * _Available since v3.1._
401      */
402     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
403         require(address(this).balance >= value, "Address: insufficient balance for call");
404         return _functionCallWithValue(target, data, value, errorMessage);
405     }
406 
407     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
408         require(isContract(target), "Address: call to non-contract");
409 
410         // solhint-disable-next-line avoid-low-level-calls
411         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
412         if (success) {
413             return returndata;
414         } else {
415             // Look for revert reason and bubble it up if present
416             if (returndata.length > 0) {
417                 // The easiest way to bubble the revert reason is using memory via assembly
418 
419                 // solhint-disable-next-line no-inline-assembly
420                 assembly {
421                     let returndata_size := mload(returndata)
422                     revert(add(32, returndata), returndata_size)
423                 }
424             } else {
425                 revert(errorMessage);
426             }
427         }
428     }
429 }
430 
431 /**
432  * @dev Contract module which provides a basic access control mechanism, where
433  * there is an account (an owner) that can be granted exclusive access to
434  * specific functions.
435  *
436  * By default, the owner account will be the one that deploys the contract. This
437  * can later be changed with {transferOwnership}.
438  *
439  * This module is used through inheritance. It will make available the modifier
440  * `onlyOwner`, which can be applied to your functions to restrict their use to
441  * the owner.
442  */
443 contract Ownable is Context {
444     address private _owner;
445     address private _previousOwner;
446     uint256 private _lockTime;
447 
448     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
449 
450     /**
451      * @dev Initializes the contract setting the deployer as the initial owner.
452      */
453     constructor () {
454         address msgSender = _msgSender();
455         _owner = msgSender;
456         emit OwnershipTransferred(address(0), msgSender);
457     }
458 
459     /**
460      * @dev Returns the address of the current owner.
461      */
462     function owner() public view returns (address) {
463         return _owner;
464     }
465 
466     /**
467      * @dev Throws if called by any account other than the owner.
468      */
469     modifier onlyOwner() {
470         require(_owner == _msgSender(), "Ownable: caller is not the owner");
471         _;
472     }
473 
474      /**
475      * @dev Leaves the contract without owner. It will not be possible to call
476      * `onlyOwner` functions anymore. Can only be called by the current owner.
477      *
478      * NOTE: Renouncing ownership will leave the contract without an owner,
479      * thereby removing any functionality that is only available to the owner.
480      */
481     function renounceOwnership() public virtual onlyOwner {
482         emit OwnershipTransferred(_owner, address(0));
483         _owner = address(0);
484     }
485 
486     /**
487      * @dev Transfers ownership of the contract to a new account (`newOwner`).
488      * Can only be called by the current owner.
489      */
490     function transferOwnership(address newOwner) public virtual onlyOwner {
491         require(newOwner != address(0), "Ownable: new owner is the zero address");
492         emit OwnershipTransferred(_owner, newOwner);
493         _owner = newOwner;
494     }
495 
496     function geUnlockTime() public view returns (uint256) {
497         return _lockTime;
498     }
499 
500     //Locks the contract for owner for the amount of time provided
501     function lock(uint256 time) public virtual onlyOwner {
502         _previousOwner = _owner;
503         _owner = address(0);
504         _lockTime = block.timestamp + time;
505         emit OwnershipTransferred(_owner, address(0));
506     }
507     
508     //Unlocks the contract for owner when _lockTime is exceeds
509     function unlock() public virtual {
510         require(_previousOwner == msg.sender, "You don't have permission to unlock");
511         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
512         emit OwnershipTransferred(_owner, _previousOwner);
513         _owner = _previousOwner;
514     }
515 }
516 
517 // pragma solidity >=0.5.0;
518 
519 interface IUniswapV2Factory {
520     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
521 
522     function feeTo() external view returns (address);
523     function feeToSetter() external view returns (address);
524 
525     function getPair(address tokenA, address tokenB) external view returns (address pair);
526     function allPairs(uint) external view returns (address pair);
527     function allPairsLength() external view returns (uint);
528 
529     function createPair(address tokenA, address tokenB) external returns (address pair);
530 
531     function setFeeTo(address) external;
532     function setFeeToSetter(address) external;
533 }
534 
535 
536 // pragma solidity >=0.5.0;
537 
538 interface IUniswapV2Pair {
539     event Approval(address indexed owner, address indexed spender, uint value);
540     event Transfer(address indexed from, address indexed to, uint value);
541 
542     function name() external pure returns (string memory);
543     function symbol() external pure returns (string memory);
544     function decimals() external pure returns (uint8);
545     function totalSupply() external view returns (uint);
546     function balanceOf(address owner) external view returns (uint);
547     function allowance(address owner, address spender) external view returns (uint);
548 
549     function approve(address spender, uint value) external returns (bool);
550     function transfer(address to, uint value) external returns (bool);
551     function transferFrom(address from, address to, uint value) external returns (bool);
552 
553     function DOMAIN_SEPARATOR() external view returns (bytes32);
554     function PERMIT_TYPEHASH() external pure returns (bytes32);
555     function nonces(address owner) external view returns (uint);
556 
557     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
558 
559     event Mint(address indexed sender, uint amount0, uint amount1);
560     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
561     event Swap(
562         address indexed sender,
563         uint amount0In,
564         uint amount1In, 
565         uint amount0Out,
566         uint amount1Out,
567         address indexed to
568     );
569     event Sync(uint112 reserve0, uint112 reserve1);
570 
571     function MINIMUM_LIQUIDITY() external pure returns (uint);
572     function factory() external view returns (address);
573     function token0() external view returns (address);
574     function token1() external view returns (address);
575     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
576     function price0CumulativeLast() external view returns (uint);
577     function price1CumulativeLast() external view returns (uint);
578     function kLast() external view returns (uint);
579 
580     function mint(address to) external returns (uint liquidity);
581     function burn(address to) external returns (uint amount0, uint amount1);
582     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
583     function skim(address to) external;
584     function sync() external;
585 
586     function initialize(address, address) external;
587 }
588 
589 // pragma solidity >=0.6.2;
590 
591 interface IUniswapV2Router01 {
592     function factory() external pure returns (address);
593     function WETH() external pure returns (address);
594 
595     function addLiquidity(
596         address tokenA,
597         address tokenB,
598         uint amountADesired,
599         uint amountBDesired,
600         uint amountAMin,
601         uint amountBMin,
602         address to,
603         uint deadline
604     ) external returns (uint amountA, uint amountB, uint liquidity);
605     function addLiquidityETH(
606         address token,
607         uint amountTokenDesired,
608         uint amountTokenMin,
609         uint amountETHMin,
610         address to,
611         uint deadline
612     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
613     function removeLiquidity(
614         address tokenA,
615         address tokenB,
616         uint liquidity,
617         uint amountAMin,
618         uint amountBMin,
619         address to,
620         uint deadline
621     ) external returns (uint amountA, uint amountB);
622     function removeLiquidityETH(
623         address token,
624         uint liquidity,
625         uint amountTokenMin,
626         uint amountETHMin,
627         address to,
628         uint deadline
629     ) external returns (uint amountToken, uint amountETH);
630     function removeLiquidityWithPermit(
631         address tokenA,
632         address tokenB,
633         uint liquidity,
634         uint amountAMin,
635         uint amountBMin,
636         address to,
637         uint deadline,
638         bool approveMax, uint8 v, bytes32 r, bytes32 s
639     ) external returns (uint amountA, uint amountB);
640     function removeLiquidityETHWithPermit(
641         address token,
642         uint liquidity,
643         uint amountTokenMin,
644         uint amountETHMin,
645         address to,
646         uint deadline,
647         bool approveMax, uint8 v, bytes32 r, bytes32 s
648     ) external returns (uint amountToken, uint amountETH);
649     function swapExactTokensForTokens(
650         uint amountIn,
651         uint amountOutMin,
652         address[] calldata path,
653         address to,
654         uint deadline
655     ) external returns (uint[] memory amounts);
656     function swapTokensForExactTokens(
657         uint amountOut,
658         uint amountInMax,
659         address[] calldata path,
660         address to,
661         uint deadline
662     ) external returns (uint[] memory amounts);
663     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
664         external
665         payable
666         returns (uint[] memory amounts);
667     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
668         external
669         returns (uint[] memory amounts);
670     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
671         external
672         returns (uint[] memory amounts);
673     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
674         external
675         payable
676         returns (uint[] memory amounts);
677 
678     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
679     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
680     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
681     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
682     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
683 }
684 
685 
686 
687 // pragma solidity >=0.6.2;
688 
689 interface IUniswapV2Router02 is IUniswapV2Router01 {
690     function removeLiquidityETHSupportingFeeOnTransferTokens(
691         address token,
692         uint liquidity,
693         uint amountTokenMin,
694         uint amountETHMin,
695         address to,
696         uint deadline
697     ) external returns (uint amountETH);
698     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
699         address token,
700         uint liquidity,
701         uint amountTokenMin,
702         uint amountETHMin,
703         address to,
704         uint deadline,
705         bool approveMax, uint8 v, bytes32 r, bytes32 s
706     ) external returns (uint amountETH);
707     
708     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
709         uint amountIn,
710         uint amountOutMin,
711         address[] calldata path,
712         address to,
713         uint deadline
714     ) external;
715     function swapExactETHForTokensSupportingFeeOnTransferTokens(
716         uint amountOutMin,
717         address[] calldata path,
718         address to,
719         uint deadline
720     ) external payable;
721     function swapExactTokensForETHSupportingFeeOnTransferTokens(
722         uint amountIn,
723         uint amountOutMin,
724         address[] calldata path,
725         address to,
726         uint deadline
727     ) external;
728 }
729 
730 /* SAINT is a fork of SafeMoon that has been edited to support the children-focused
731    charitable mission of Saint
732 */
733 
734 abstract contract IERC20Extented is IERC20 {
735     function decimals() public view virtual returns (uint8);
736     function name() public view virtual returns (string memory);
737     function symbol() public view virtual returns (string memory);
738 }
739 
740 contract Evergive is Context, IERC20, IERC20Extented, Ownable {
741   using SafeMath for uint256;
742   using Address for address;
743 
744   mapping (address => uint256) private _rOwned;
745   mapping (address => uint256) private _tOwned;
746   mapping (address => mapping (address => uint256)) private _allowances;
747 
748   mapping (address => bool) private _isExcludedFromFee;
749 
750   mapping (address => bool) private _isExcluded;
751   address[] private _excluded;
752 
753   address payable public _feeWallet = payable(0xbD6B5A591964F2ecbd521c98C4002f18034Ee7c0);
754   address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
755   /* Variables _tTotal, _name, _symbol, _decimals, and numTokensSellToAddToLiquidity
756      changed to constant.
757      See "SSL-05 | Variable could be declared as constant" from the Certik 
758      audit of Safemoon.
759   */
760   uint256 private constant MAX = 150000000000000 * 10**9;
761   uint256 private constant _tTotal = 150000000000000 * 10**9;
762   uint256 private _rTotal = (MAX - (MAX % _tTotal));
763   uint256 private _tFeeTotal;
764   
765   string public _name = " ";
766   string public _symbol = "bbb";
767   uint8 private constant _decimals = 9;
768  
769   uint256 private _buyBackDivisor = 100;
770   
771   uint256 public _devFee = 3;
772   uint256 private _previousDevFee = _devFee;
773   
774   uint256 public _marketingFee = 2;
775   uint256 private _previousMarketingFee = _marketingFee;
776 
777   uint256 public _liquidityFee = 3;
778   uint256 private _previousLiquidityFee = _liquidityFee;
779   
780   uint256 public _buyBackFee = 1;
781   uint256 private _previousBuyBackFee = _buyBackFee;
782   
783   uint256 public _dipRewardFee = 1;
784   uint256 private _previousDipRewardFee = _dipRewardFee;
785   
786   uint256 public _txFee = _devFee.add(_marketingFee).add(_liquidityFee).add(_buyBackFee).add(_dipRewardFee);
787   uint256 private _previousTxFee  =  _txFee;
788   
789   mapping (bytes32 => uint256) private _balances;
790   
791   bytes32 public constant _devBalance = keccak256("_devBalance"); 
792   bytes32 public constant _marketingBalance = keccak256("_marketingBalance");
793   bytes32 public constant _liquidityBalance = keccak256("_liquidityBalance");
794   bytes32 public constant _buyBackBalance = keccak256("_buyBackBalance");
795   bytes32 public constant _dipBalance = keccak256("_dipBalance");
796   bytes32 public constant _buyBackETHbalance = keccak256("_buyBackETHbalance");
797   
798   IUniswapV2Router02 public uniswapV2Router;
799   address public uniswapV2Pair;
800   
801   bool inSwapAndLiquify;
802   bool public swapAndLiquifyEnabled = true;
803   
804   uint256 public _maxTxAmount = _tTotal;
805   uint256 private numTokensSellToAddToLiquidity = 1000000000000 * 10**9;
806   uint256 public marketingDivisor = 3;
807   uint256 public maxWallet = 1500000000000 * 10**9;
808   uint256 public _whalePenaltyAmount = 1125000000000 * 10**9; // 75% of maxWallet
809     
810   uint256 private buyBackUpperLimit = 1500000000000 * 10**9;
811     
812   event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap);
813   event SwapAndLiquifyEnabledUpdated(bool enabled);
814   event SwapAndLiquify(
815       uint256 tokensSwapped,
816       uint256 ethReceived,
817       uint256 tokensIntoLiquidity
818   );
819   
820   event AddLiquidityETH(uint amountA, uint amountB, uint liquidity);
821 
822   modifier lockTheSwap {
823       inSwapAndLiquify = true;
824       _;
825       inSwapAndLiquify = false;
826   }
827   bool public buyBackEnabled = true;
828     
829   event BuyBackEnabledUpdated(bool enabled);
830     
831   event SwapETHForTokens(
832       uint256 amountIn,
833       address[] path
834   );
835     
836   event SwapTokensForETH(
837       uint256 amountIn,
838       address[] path
839   );
840 
841   event test_value(uint256 indexed value1);
842   
843   constructor () {
844       _rOwned[_msgSender()] = _rTotal;
845       
846       IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);// v2 testnet 0xD99D1c33F9fC3444f8101754aBC46c52416550D1
847         // Create a pancakeswap pair for this new token 
848       uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
849           .createPair(address(this), _uniswapV2Router.WETH());
850 
851       // set the rest of the contract variables
852       uniswapV2Router = _uniswapV2Router;
853       
854       //exclude owner and this contract from fee
855       _isExcludedFromFee[owner()] = true;
856       _isExcludedFromFee[address(this)] = true;
857       _isExcludedFromFee[_feeWallet] = true;
858 
859       _balances[_devBalance] = 0; 
860       _balances[_marketingBalance] = 0;
861       _balances[_liquidityBalance] = 0;
862       _balances[_buyBackBalance] = 0;
863       _balances[_dipBalance] = 0;
864       _balances[_buyBackETHbalance] = 0;
865 
866       emit Transfer(address(0), _msgSender(), _tTotal);
867   }
868   
869   // calculate price based on pair reserves
870   function getTokenPrice() public view returns(uint256) {
871     IERC20Extented token1 = IERC20Extented(IUniswapV2Pair(uniswapV2Pair).token1());
872     (uint256 Res0, uint256 Res1,) = IUniswapV2Pair(uniswapV2Pair).getReserves();
873 
874     // decimals
875     return((Res0*(10**uint256(token1.decimals())))/(Res1)); // return amount of token0 needed to buy token1
876   }
877    
878   function name() override public view returns (string memory) {
879       return _name;
880   }
881 
882   function symbol() override public view returns (string memory) {
883       return _symbol;
884   }
885 
886   function decimals() override public pure returns (uint8) {
887       return _decimals;
888   }
889 
890   function totalSupply() public pure override returns (uint256) {
891       return _tTotal;
892   }
893 
894   function balanceOf(address account) public view override returns (uint256) {
895       if (_isExcluded[account]) return _tOwned[account];
896       return tokenFromReflection(_rOwned[account]);
897   }
898 
899   function transfer(address recipient, uint256 amount) public override returns (bool) {
900       _transfer(_msgSender(), recipient, amount);
901       return true;
902   }
903 
904   function allowance(address owner, address spender) public view override returns (uint256) {
905       return _allowances[owner][spender];
906   }
907 
908   function approve(address spender, uint256 amount) public override returns (bool) {
909       _approve(_msgSender(), spender, amount);
910       return true;
911   }
912 
913   function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
914       _transfer(sender, recipient, amount);
915       _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
916       return true;
917   }
918 
919   function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
920       _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
921       return true;
922   }
923 
924   function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
925       _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
926       return true;
927   }
928 
929   function isExcludedFromReward(address account) public view returns (bool) {
930       return _isExcluded[account];
931   }
932 
933   function totalFees() public view returns (uint256) {
934       return _tFeeTotal;
935   }
936 
937   function buyBackTokens(uint256 amount) private lockTheSwap {
938       if (amount > 0) {
939     	  swapETHForTokens(amount);
940 	  }
941   }
942     
943   function swapTokensForEth(uint256 tokenAmount) private {
944       // generate the uniswap pair path of token -> weth
945       address[] memory path = new address[](2);
946       path[0] = address(this);
947       path[1] = uniswapV2Router.WETH();
948 
949       _approve(address(this), address(uniswapV2Router), tokenAmount);
950 
951       // make the swap
952       uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
953           tokenAmount,
954           0, // accept any amount of ETH
955           path,
956           address(this), // The contract
957           block.timestamp
958       );
959         
960       emit SwapTokensForETH(tokenAmount, path);
961   }
962     
963   function swapETHForTokens(uint256 amount) private {
964       // generate the uniswap pair path of token -> weth
965       address[] memory path = new address[](2);
966       path[0] = uniswapV2Router.WETH();
967       path[1] = address(this);
968 
969       // make the swap
970       uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
971           0, // accept any amount of Tokens
972           path,
973           deadAddress, // Burn address
974           block.timestamp.add(300)
975       );
976         
977       emit SwapETHForTokens(amount, path);
978   }
979     
980   /* removed function due to security concerns
981      See "SSL-12 | The purpose of function deliver" from the Certik audit of safemoon
982      
983   function deliver(uint256 tAmount) public {
984       address sender = _msgSender();
985       require(!_isExcluded[sender], "Excluded addresses cannot call this function");
986       (uint256 rAmount,,,,,,) = _getValues(tAmount);
987       _rOwned[sender] = _rOwned[sender].sub(rAmount);
988       _rTotal = _rTotal.sub(rAmount);
989       _tFeeTotal = _tFeeTotal.add(tAmount);
990   }
991   */
992   
993   function buyBackUpperLimitAmount() public view returns (uint256) {
994       return buyBackUpperLimit;
995   }
996     
997   function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
998       require(tAmount <= _tTotal, "Amount must be less than supply");
999       if (!deductTransferFee) {
1000           (uint256 rAmount,,,) = _getValues(tAmount);
1001           return rAmount;
1002       } else {
1003           (,uint256 rTransferAmount,,) = _getValues(tAmount);
1004           return rTransferAmount;
1005       }
1006   }
1007 
1008   function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
1009       require(rAmount <= _rTotal, "Amount must be less than total reflections");
1010       uint256 currentRate =  _getRate();
1011       return rAmount.div(currentRate);
1012   }
1013 
1014   function excludeFromReward(address account) public onlyOwner() {
1015       // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Pancakeswap router.');
1016       require(!_isExcluded[account], "Account is already excluded");
1017       if(_rOwned[account] > 0) {
1018           _tOwned[account] = tokenFromReflection(_rOwned[account]);
1019       }
1020       _isExcluded[account] = true;
1021       _excluded.push(account);
1022   }
1023 
1024   function includeInReward(address account) external onlyOwner() {
1025       /* Changed error message to "Account not excluded"
1026          See "SSL-01 | Incorrect error message" from the Certik
1027          audit of safemoon.
1028       */
1029       require(_isExcluded[account], "Account not excluded");
1030       for (uint256 i = 0; i < _excluded.length; i++) {
1031           if (_excluded[i] == account) {
1032               _excluded[i] = _excluded[_excluded.length - 1];
1033               _tOwned[account] = 0;
1034               _isExcluded[account] = false;
1035               _excluded.pop();
1036               break;
1037           }
1038       }
1039   }
1040   function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1041       (uint256 rAmount, uint256 rTransferAmount, uint256 tTransferAmount, uint256 tTxFee) = _getValues(tAmount);
1042       
1043       _tOwned[sender] = _tOwned[sender].sub(tAmount);
1044       _rOwned[sender] = _rOwned[sender].sub(rAmount);
1045       _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1046       _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
1047       _takeTxFee(tTxFee);
1048       setBalancesOnTransfer(tAmount);
1049       emit Transfer(sender, recipient, tTransferAmount);
1050   }
1051   
1052   function excludeFromFee(address account) public onlyOwner {
1053       _isExcludedFromFee[account] = true;
1054   }
1055   
1056   function includeInFee(address account) public onlyOwner {
1057       _isExcludedFromFee[account] = false;
1058   }
1059   
1060   function setDevFeePercent(uint256 devFee) private {
1061       require(devFee <= 20, "Fee must be less than 20%");
1062       _devFee = devFee;
1063   }
1064   
1065   function setMarketingFeePercent(uint256 marketingFee) private {
1066       require(marketingFee <= 20, "Fee must be less than 20%");
1067       _marketingFee = marketingFee;
1068   }
1069 
1070   function setLiquidityFeePercent(uint256 liquidityFee) private {
1071       require(liquidityFee <= 20, "Fee must be less than 20%");
1072       _liquidityFee = liquidityFee;
1073   }
1074   
1075   function setBuyBackFeePercent(uint256 buyBackFee) private {
1076       require(buyBackFee <= 20, "Fee must be less than 20%");
1077       _buyBackFee = buyBackFee;
1078   }
1079   
1080   function setDipRewardFeePercent(uint256 dipRewardFee) private {
1081       require(dipRewardFee <= 20, "Fee must be less than 20%");
1082       _dipRewardFee = dipRewardFee;
1083   }
1084   
1085   function setTxFeePercent(uint256 devFee, uint256 marketingFee, uint256 liquidityFee, uint256 buyBackFee, uint256 dipRewardFee) external onlyOwner() {
1086       setDevFeePercent(devFee);
1087       setMarketingFeePercent(marketingFee);
1088       setLiquidityFeePercent(liquidityFee);
1089       setBuyBackFeePercent(buyBackFee);
1090       setDipRewardFeePercent(dipRewardFee);
1091       _txFee = _devFee.add(_marketingFee).add(_liquidityFee).add(_buyBackFee).add(_dipRewardFee);
1092   }
1093   
1094   function setBuyBackDivisor(uint256 divisor) external onlyOwner() {
1095       require(divisor > 0, "divisor must be greater than zero");
1096       _buyBackDivisor = divisor;
1097   }
1098   
1099   function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1100       _maxTxAmount = maxTxAmount;
1101   }
1102 
1103   function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1104       swapAndLiquifyEnabled = _enabled;
1105       emit SwapAndLiquifyEnabledUpdated(_enabled);
1106   }
1107   
1108   function setBuyBackEnabled(bool _enabled) public onlyOwner {
1109       buyBackEnabled = _enabled;
1110       emit BuyBackEnabledUpdated(_enabled);
1111   }
1112   
1113   //to recieve ETH from pancakeswapV2Router when swaping
1114   receive() external payable {}
1115 
1116   function _reflectFee(uint256 rFee, uint256 tFee) private {
1117       _rTotal = _rTotal.sub(rFee);
1118       _tFeeTotal = _tFeeTotal.add(tFee);
1119   }
1120 
1121   function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256) {
1122       (uint256 tTransferAmount, uint256 tTxFee) = _getTValues(tAmount);
1123       (uint256 rAmount, uint256 rTransferAmount) = _getRValues(tAmount, tTxFee, _getRate());
1124       return (rAmount, rTransferAmount, tTransferAmount, tTxFee);
1125       
1126   }
1127 
1128   function _getTValues(uint256 tAmount) private view returns (uint256, uint256) {
1129       uint256 tTxFee = calculateTxFee(tAmount);
1130       uint256 tTransferAmount = tAmount.sub(tTxFee);
1131       return (tTransferAmount, tTxFee);
1132   }
1133 
1134   function _getRValues(uint256 tAmount, uint256 tTxFee, uint256 currentRate) private pure returns (uint256, uint256) {
1135       uint256 rAmount = tAmount.mul(currentRate);
1136       uint256 rTxFee = tTxFee.mul(currentRate);
1137       uint256 rTransferAmount = rAmount.sub(rTxFee);
1138       return (rAmount, rTransferAmount);
1139   }
1140 
1141   function _getRate() private view returns(uint256) {
1142       (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1143       return rSupply.div(tSupply);
1144   }
1145 
1146   function _getCurrentSupply() private view returns(uint256, uint256) {
1147       uint256 rSupply = _rTotal;
1148       uint256 tSupply = _tTotal;      
1149       for (uint256 i = 0; i < _excluded.length; i++) {
1150           if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1151           rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1152           tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1153       }
1154       if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1155       return (rSupply, tSupply);
1156   }
1157   
1158   function _takeTxFee(uint256 tTxFee) private {
1159       uint256 currentRate = _getRate();
1160       uint256 rTxFee = tTxFee.mul(currentRate);
1161       _rOwned[owner()] = _rOwned[owner()].add(rTxFee);
1162       if(_isExcluded[owner()])
1163         _tOwned[owner()] = _tOwned[owner()].add(tTxFee);
1164   }
1165 
1166   function calculateTxFee(uint256 _amount) private view returns (uint256) {
1167       return _amount.mul(_txFee).div(
1168           10**2
1169       );
1170   }
1171   
1172   function removeAllFee() private {
1173       if(_txFee == 0) return;
1174       
1175       _previousTxFee = _txFee;
1176       
1177       _txFee = 0;
1178   }
1179   
1180   function restoreAllFee() private {
1181       _txFee = _previousTxFee;
1182   }
1183   
1184   function isExcludedFromFee(address account) public view returns(bool) {
1185       return _isExcludedFromFee[account];
1186   }
1187 
1188   function _approve(address owner, address spender, uint256 amount) private {
1189       require(owner != address(0), "BEP20: approve from the zero address");
1190       require(spender != address(0), "BEP20: approve to the zero address");
1191 
1192       _allowances[owner][spender] = amount;
1193       emit Approval(owner, spender, amount);
1194   }
1195 
1196   function _transfer(
1197       address from,
1198       address to,
1199       uint256 amount
1200   ) private {
1201         require(from != address(0), "ERC20: transfer from the zero address");
1202         require(to != address(0), "ERC20: transfer to the zero address");
1203         require(amount > 0, "Transfer amount must be greater than zero");
1204         if(from != owner() && to != owner()) {
1205             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1206         }
1207 
1208         uint256 contractTokenBalance = balanceOf(address(this));
1209         bool overMinimumTokenBalance = contractTokenBalance >= numTokensSellToAddToLiquidity;
1210         
1211         if (!inSwapAndLiquify && swapAndLiquifyEnabled && to == uniswapV2Pair) {
1212             if (overMinimumTokenBalance) {
1213                 contractTokenBalance = numTokensSellToAddToLiquidity;
1214                 swapTokens(contractTokenBalance);    
1215             }
1216 	        uint256 balance = address(this).balance;
1217             if (buyBackEnabled && balance > uint256(1 * 10**18)) {
1218                 
1219                 if (balance > buyBackUpperLimit)
1220                     balance = buyBackUpperLimit;
1221                 
1222                 buyBackTokens(balance.div(100));
1223             }
1224         }
1225         
1226         bool takeFee = true;
1227         
1228         //if any account belongs to _isExcludedFromFee account then remove the fee
1229         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]){
1230             takeFee = false;
1231             _tokenTransfer(from,to,amount,takeFee);
1232         }
1233         else {
1234             if(to != uniswapV2Pair){
1235                 require(balanceOf(to).add(amount) <= maxWallet, "transfer amount must be less than maxWallet");
1236             }
1237             require(amount <= _maxTxAmount, "transfer amount must be less than _maxTxAmount");
1238             
1239             if(amount > _whalePenaltyAmount && to == uniswapV2Pair){
1240                 _previousDipRewardFee = _dipRewardFee;
1241                 _previousTxFee = _txFee;
1242                 
1243                 _dipRewardFee = _dipRewardFee + 15;
1244                 _txFee = _devFee.add(_marketingFee).add(_liquidityFee).add(_buyBackFee).add(_dipRewardFee);
1245         
1246                 _tokenTransfer(from,to,amount,takeFee);
1247                 
1248                 _dipRewardFee = _previousDipRewardFee;
1249                 _txFee = _previousTxFee;            
1250             }
1251             else {
1252                 _tokenTransfer(from,to,amount,takeFee);
1253             }
1254         }
1255         
1256   }
1257 
1258   function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
1259        
1260       uint256 initialBalance = address(this).balance;
1261       swapTokensForEth(contractTokenBalance);
1262       uint256 transferredBalance = address(this).balance.sub(initialBalance);
1263 
1264       //Send to Marketing address
1265       transferToAddressETH(_feeWallet, transferredBalance.div(_txFee).mul(_devFee.add(_marketingFee).add(_buyBackFee)));
1266         
1267   }
1268     
1269   function setBalancesOnTransfer(uint256 amount) private {
1270           _balances[_devBalance] = _balances[_devBalance].add(amount.mul(_devFee.div(100)));
1271           _balances[_marketingBalance] = _balances[_marketingBalance].add(amount.mul(_marketingFee.div(100)));
1272           _balances[_liquidityBalance] += amount.mul(_liquidityFee.div(100));
1273           _balances[_buyBackBalance] += amount.mul(_buyBackFee.div(100));
1274           _balances[_dipBalance] += amount.mul(_dipRewardFee.div(100));
1275   }
1276   
1277   function setBalancesOnBuy(uint256 amount, uint256 buyBackETH) private {
1278           _balances[_devBalance] -= amount.mul(_devFee.div(100));
1279           _balances[_marketingBalance] -= amount.mul(_marketingFee.div(100));
1280           _balances[_buyBackBalance] -= amount.mul(_buyBackFee.div(100));
1281           _balances[_buyBackETHbalance] += buyBackETH;
1282   }
1283   
1284   function updateBuyBackBalance(uint amount) private {
1285            _balances[_buyBackETHbalance] -= amount;
1286   }
1287   
1288   function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1289       // split the contract balance into halves
1290       uint256 half = contractTokenBalance.div(2);
1291       uint256 otherHalf = contractTokenBalance.sub(half);
1292 
1293       // capture the contract's current ETH balance.
1294       // this is so that we can capture exactly the amount of ETH that the
1295       // swap creates, and not make the liquidity event include any ETH that
1296       // has been manually sent to the contract
1297       uint256 initialBalance = address(this).balance;
1298 
1299       // swap tokens for ETH
1300       swapTokensForETH(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1301 
1302       // how much ETH did we just swap into?
1303       uint256 newBalance = address(this).balance.sub(initialBalance);
1304 
1305       // add liquidity to pancakeswap
1306       addLiquidity(otherHalf, newBalance);
1307       
1308       emit SwapAndLiquify(half, newBalance, otherHalf);
1309   }
1310 
1311   function swapTokensForETH(uint256 tokenAmount) private {
1312       // generate the pancakeswap pair path of token -> WETH
1313       address[] memory path = new address[](2);
1314       path[0] = address(this);
1315       path[1] = uniswapV2Router.WETH();
1316 
1317       _approve(address(this), address(uniswapV2Router), tokenAmount);
1318 
1319       // make the swap
1320       uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1321           tokenAmount,
1322           0, // accept any amount of ETH
1323           path,
1324           address(this),
1325           block.timestamp
1326       );
1327   }
1328 
1329   function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1330       // approve token transfer to cover all possible scenarios
1331       /* "to" account changed to address(this) to mitigate major centralization
1332          issue in Safemoon's contract.
1333          See "SSL-04 | Centralized risk in addLiquidity" from the Certik
1334          audit of Safemoon.
1335       */
1336       _approve(address(this), address(uniswapV2Router), tokenAmount);
1337 
1338          // add the liquidity
1339       uniswapV2Router.addLiquidityETH{value: ethAmount}(
1340             address(this),
1341             tokenAmount,
1342             0, // slippage is unavoidable
1343             0, // slippage is unavoidable
1344             address(this),
1345             block.timestamp
1346         );
1347       //emit AddLiquidityETH(amountA, amountB, liquidity);
1348   }
1349 
1350   //this method is responsible for taking all fee, if takeFee is true
1351   function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1352       /* Removed:
1353          ".....else  if  (!_isExcluded[sender]  &&  !_isExcluded[recipient])  {{        
1354                          _transferStandard(sender, recipient, amount);  }....."
1355                          
1356         See "SSL-02 | Redundant code" from the Certik audit of Safemoon
1357       */
1358       if(!takeFee)
1359           removeAllFee();
1360       
1361       if (_isExcluded[sender] && !_isExcluded[recipient]) {
1362           _transferFromExcluded(sender, recipient, amount);
1363       } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1364           _transferToExcluded(sender, recipient, amount);
1365       } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1366           _transferBothExcluded(sender, recipient, amount);
1367       } else {
1368           _transferStandard(sender, recipient, amount);
1369       }
1370       
1371       if(!takeFee)
1372           restoreAllFee();
1373   }
1374 
1375   function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1376       (uint256 rAmount, uint256 rTransferAmount, uint256 tTransferAmount, uint256 tTxFee) = _getValues(tAmount);
1377 
1378       _rOwned[sender] = _rOwned[sender].sub(rAmount);
1379       _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1380       _takeTxFee(tTxFee);
1381       setBalancesOnTransfer(tAmount);
1382       emit Transfer(sender, recipient, tTransferAmount);
1383   }
1384 
1385   function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1386       (uint256 rAmount, uint256 rTransferAmount, uint256 tTransferAmount, uint256 tTxFee) = _getValues(tAmount);
1387       
1388       _rOwned[sender] = _rOwned[sender].sub(rAmount);
1389       _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1390       _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
1391       _takeTxFee(tTxFee);
1392       setBalancesOnTransfer(tAmount);
1393 
1394       emit Transfer(sender, recipient, tTransferAmount);
1395   }
1396 
1397   function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1398       (uint256 rAmount, uint256 rTransferAmount, uint256 tTransferAmount, uint256 tTxFee) = _getValues(tAmount);
1399       
1400       _tOwned[sender] = _tOwned[sender].sub(tAmount);
1401       _rOwned[sender] = _rOwned[sender].sub(rAmount);
1402       _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
1403       _takeTxFee(tTxFee);
1404       setBalancesOnTransfer(tAmount);
1405 
1406       emit Transfer(sender, recipient, tTransferAmount);
1407   }
1408   
1409   function transferToAddressETH(address payable recipient, uint256 amount) private {
1410       recipient.transfer(amount);
1411   }
1412     
1413   //New Pancakeswap router version?
1414   //No problem, just change it!
1415   function setRouterAddress(address newRouter) external onlyOwner() {
1416       IUniswapV2Router02 _uniswapV2newRouter = IUniswapV2Router02(newRouter);//v2 router --> 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1417       // Create a pancakeswap pair for this new token 
1418       uniswapV2Pair = IUniswapV2Factory(_uniswapV2newRouter.factory())
1419             .createPair(address(this), _uniswapV2newRouter.WETH());
1420 
1421       // set the rest of the contract variables
1422       uniswapV2Router = _uniswapV2newRouter;
1423       
1424     }
1425     
1426   function setFeeWallet(address payable newWallet) external onlyOwner(){
1427       // in case the charity wallet needs to be updated
1428       _feeWallet = payable(newWallet);
1429   }
1430   function setName(string memory newName) external onlyOwner()  {
1431       _name = newName;
1432   }
1433   function setSymbol(string memory newSymbol) external onlyOwner() {
1434       _symbol =  newSymbol;
1435   }
1436   function setMaxWallet(uint256 _maxWallet) external onlyOwner() {
1437       maxWallet = _maxWallet;
1438   }
1439   function setWhalePenaltyAmount(uint256 whalePenaltyAmount) external onlyOwner() {
1440       _whalePenaltyAmount = whalePenaltyAmount;
1441   }
1442   function getMaxTxAmount() external view onlyOwner() returns(uint256){
1443       return _maxTxAmount;
1444   }
1445   
1446   function getBalances() external view onlyOwner() returns(uint256, uint256, uint256, uint256, uint256, uint256) {
1447       return (_balances[_devBalance], _balances[_marketingBalance], _balances[_liquidityBalance], _balances[_buyBackBalance],
1448       _balances[_dipBalance], _balances[_buyBackETHbalance]);
1449   }
1450   
1451 }