1 /*
2     Website: https://shinchantoken.com/
3     Telegram: https://t.me/ShinChanToken
4     Twitter: https://twitter.com/ShinChanToken
5     
6  ___   _    _        ___  _                 _____     _              
7 /  _) ( )  (_)      (  _)( )               (_   _)   ( )             
8 \_"-. | |_  _  ____ | |  | |_  ___  ____     | | ___ | | _ ___  ____ 
9  __) )( _ )( )( __ )( )_ ( _ )( o )( __ )    ( )( o )( _'(( o_)( __ )
10 /___/ /_\||/_\/_\/_\/___\/_\||/_^_\/_\/_\    /_\ \_/ /_\\_|\(  /_\/_\
11                                                                      
12 
13     
14 */
15 pragma solidity ^0.8.3;
16 // SPDX-License-Identifier: Unlicensed
17 
18 /**
19  * @dev Interface of the ERC20 standard as defined in the EIP.
20  */ 
21 interface IERC20 {
22     /**
23     * @dev Returns the amount of tokens in existence.
24     */
25     function totalSupply() external view returns (uint256);
26 
27     /**
28     * @dev Returns the amount of tokens owned by `account`.
29     */
30     function balanceOf(address account) external view returns (uint256);
31 
32     /**
33     * @dev Moves `amount` tokens from the caller's account to `recipient`.
34     *
35     * Returns a boolean value indicating whether the operation succeeded.
36     *
37     * Emits a {Transfer} event.
38     */
39     function transfer(address recipient, uint256 amount) external returns (bool);
40 
41     /**
42     * @dev Returns the remaining number of tokens that `spender` will be
43     * allowed to spend on behalf of `owner` through {transferFrom}. This is
44     * zero by default.
45     *
46     * This value changes when {approve} or {transferFrom} are called.
47     */
48     function allowance(address owner, address spender) external view returns (uint256);
49 
50     /**
51     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
52     *
53     * Returns a boolean value indicating whether the operation succeeded.
54     *
55     * IMPORTANT: Beware that changing an allowance with this method brings the risk
56     * that someone may use both the old and the new allowance by unfortunate
57     * transaction ordering. One possible solution to mitigate this race
58     * condition is to first reduce the spender's allowance to 0 and set the
59     * desired value afterwards:
60     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
61     *
62     * Emits an {Approval} event.
63     */
64     function approve(address spender, uint256 amount) external returns (bool);
65 
66     /**
67     * @dev Moves `amount` tokens from `sender` to `recipient` using the
68     * allowance mechanism. `amount` is then deducted from the caller's
69     * allowance.
70     *
71     * Returns a boolean value indicating whether the operation succeeded.
72     *
73     * Emits a {Transfer} event.
74     */
75     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
76 
77     /**
78     * @dev Emitted when `value` tokens are moved from one account (`from`) to
79     * another (`to`).
80     *
81     * Note that `value` may be zero.
82     */
83     event Transfer(address indexed from, address indexed to, uint256 value);
84 
85     /**
86     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
87     * a call to {approve}. `value` is the new allowance.
88     */
89     event Approval(address indexed owner, address indexed spender, uint256 value);
90 }
91 
92 // CAUTION
93 // This version of SafeMath should only be used with Solidity 0.8 or later,
94 // because it relies on the compiler's built in overflow checks.
95 
96 /**
97  * @dev Wrappers over Solidity's arithmetic operations.
98  *
99  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
100  * now has built in overflow checking.
101  */
102 library SafeMath {
103     /**
104     * @dev Returns the addition of two unsigned integers, with an overflow flag.
105     *
106     * _Available since v3.4._
107     */
108     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
109         unchecked {
110             uint256 c = a + b;
111             if (c < a) return (false, 0);
112             return (true, c);
113         }
114     }
115 
116     /**
117     * @dev Returns the substraction of two unsigned integers, with an overflow flag.
118     *
119     * _Available since v3.4._
120     */
121     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
122         unchecked {
123             if (b > a) return (false, 0);
124             return (true, a - b);
125         }
126     }
127 
128     /**
129     * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
130     *
131     * _Available since v3.4._
132     */
133     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
134         unchecked {
135             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
136             // benefit is lost if 'b' is also tested.
137             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
138             if (a == 0) return (true, 0);
139             uint256 c = a * b;
140             if (c / a != b) return (false, 0);
141             return (true, c);
142         }
143     }
144 
145     /**
146     * @dev Returns the division of two unsigned integers, with a division by zero flag.
147     *
148     * _Available since v3.4._
149     */
150     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
151         unchecked {
152             if (b == 0) return (false, 0);
153             return (true, a / b);
154         }
155     }
156 
157     /**
158     * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
159     *
160     * _Available since v3.4._
161     */
162     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
163         unchecked {
164             if (b == 0) return (false, 0);
165             return (true, a % b);
166         }
167     }
168 
169     /**
170     * @dev Returns the addition of two unsigned integers, reverting on
171     * overflow.
172     *
173     * Counterpart to Solidity's `+` operator.
174     *
175     * Requirements:
176     *
177     * - Addition cannot overflow.
178     */
179     function add(uint256 a, uint256 b) internal pure returns (uint256) {
180         return a + b;
181     }
182 
183     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
184         return a - b;
185     }
186 
187     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
188         return a * b;
189     }
190 
191  
192     function div(uint256 a, uint256 b) internal pure returns (uint256) {
193         return a / b;
194     }
195 
196     /**
197     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
198     * reverting when dividing by zero.
199     *
200     * Counterpart to Solidity's `%` operator. This function uses a `revert`
201     * opcode (which leaves remaining gas untouched) while Solidity uses an
202     * invalid opcode to revert (consuming all remaining gas).
203     *
204     * Requirements:
205     *
206     * - The divisor cannot be zero.
207     */
208     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
209         return a % b;
210     }
211 
212     /**
213     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
214     * overflow (when the result is negative).
215     *
216     * CAUTION: This function is deprecated because it requires allocating memory for the error
217     * message unnecessarily. For custom revert reasons use {trySub}.
218     *
219     * Counterpart to Solidity's `-` operator.
220     *
221     * Requirements:
222     *
223     * - Subtraction cannot overflow.
224     */
225     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
226         unchecked {
227             require(b <= a, errorMessage);
228             return a - b;
229         }
230     }
231 
232     /**
233     * @dev Returns the integer division of two unsigned integers, reverting with custom message on
234     * division by zero. The result is rounded towards zero.
235     *
236     * Counterpart to Solidity's `%` operator. This function uses a `revert`
237     * opcode (which leaves remaining gas untouched) while Solidity uses an
238     * invalid opcode to revert (consuming all remaining gas).
239     *
240     * Counterpart to Solidity's `/` operator. Note: this function uses a
241     * `revert` opcode (which leaves remaining gas untouched) while Solidity
242     * uses an invalid opcode to revert (consuming all remaining gas).
243     *
244     * Requirements:
245     *
246     * - The divisor cannot be zero.
247     */
248     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
249         unchecked {
250             require(b > 0, errorMessage);
251             return a / b;
252         }
253     }
254 
255     /**
256     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
257     * reverting with custom message when dividing by zero.
258     *
259     * CAUTION: This function is deprecated because it requires allocating memory for the error
260     * message unnecessarily. For custom revert reasons use {tryMod}.
261     *
262     * Counterpart to Solidity's `%` operator. This function uses a `revert`
263     * opcode (which leaves remaining gas untouched) while Solidity uses an
264     * invalid opcode to revert (consuming all remaining gas).
265     *
266     * Requirements:
267     *
268     * - The divisor cannot be zero.
269     */
270     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
271         unchecked {
272             require(b > 0, errorMessage);
273             return a % b;
274         }
275     }
276 }
277 
278 /*
279  * @dev Provides information about the current execution context, including the
280  * sender of the transaction and its data. While these are generally available
281  * via msg.sender and msg.data, they should not be accessed in such a direct
282  * manner, since when dealing with meta-transactions the account sending and
283  * paying for execution may not be the actual sender (as far as an application
284  * is concerned).
285  *
286  * This contract is only required for intermediate, library-like contracts.
287  */
288 abstract contract Context {
289     function _msgSender() internal view virtual returns (address) {
290         return msg.sender;
291     }
292 
293     function _msgData() internal view virtual returns (bytes calldata) {
294         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
295         return msg.data;
296     }
297 }
298 
299 /**
300  * @dev Collection of functions related to the address type
301  */
302 library Address {
303     /**
304     * @dev Returns true if `account` is a contract.
305     *
306     * [IMPORTANT]
307     * ====
308     * It is unsafe to assume that an address for which this function returns
309     * false is an externally-owned account (EOA) and not a contract.
310     *
311     * Among others, `isContract` will return false for the following
312     * types of addresses:
313     *
314     *  - an externally-owned account
315     *  - a contract in construction
316     *  - an address where a contract will be created
317     *  - an address where a contract lived, but was destroyed
318     * ====
319     */
320     function isContract(address account) internal view returns (bool) {
321         // This method relies on extcodesize, which returns 0 for contracts in
322         // construction, since the code is only stored at the end of the
323         // constructor execution.
324 
325         uint256 size;
326         // solhint-disable-next-line no-inline-assembly
327         assembly { size := extcodesize(account) }
328         return size > 0;
329     }
330 
331     /**
332     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
333     * `recipient`, forwarding all available gas and reverting on errors.
334     *
335     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
336     * of certain opcodes, possibly making contracts go over the 2300 gas limit
337     * imposed by `transfer`, making them unable to receive funds via
338     * `transfer`. {sendValue} removes this limitation.
339     *
340     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
341     *
342     * IMPORTANT: because control is transferred to `recipient`, care must be
343     * taken to not create reentrancy vulnerabilities. Consider using
344     * {ReentrancyGuard} or the
345     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
346     */
347     function sendValue(address payable recipient, uint256 amount) internal {
348         require(address(this).balance >= amount, "Address: insufficient balance");
349 
350         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
351         (bool success, ) = recipient.call{ value: amount }("");
352         require(success, "Address: unable to send value, recipient may have reverted");
353     }
354 
355     /**
356     * @dev Performs a Solidity function call using a low level `call`. A
357     * plain`call` is an unsafe replacement for a function call: use this
358     * function instead.
359     *
360     * If `target` reverts with a revert reason, it is bubbled up by this
361     * function (like regular Solidity function calls).
362     *
363     * Returns the raw returned data. To convert to the expected return value,
364     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
365     *
366     * Requirements:
367     *
368     * - `target` must be a contract.
369     * - calling `target` with `data` must not revert.
370     *
371     * _Available since v3.1._
372     */
373     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
374       return functionCall(target, data, "Address: low-level call failed");
375     }
376 
377     /**
378     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
379     * `errorMessage` as a fallback revert reason when `target` reverts.
380     *
381     * _Available since v3.1._
382     */
383     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
384         return functionCallWithValue(target, data, 0, errorMessage);
385     }
386 
387     /**
388     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
389     * but also transferring `value` wei to `target`.
390     *
391     * Requirements:
392     *
393     * - the calling contract must have an ETH balance of at least `value`.
394     * - the called Solidity function must be `payable`.
395     *
396     * _Available since v3.1._
397     */
398     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
399         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
400     }
401 
402     /**
403     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
404     * with `errorMessage` as a fallback revert reason when `target` reverts.
405     *
406     * _Available since v3.1._
407     */
408     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
409         require(address(this).balance >= value, "Address: insufficient balance for call");
410         require(isContract(target), "Address: call to non-contract");
411 
412         // solhint-disable-next-line avoid-low-level-calls
413         (bool success, bytes memory returndata) = target.call{ value: value }(data);
414         return _verifyCallResult(success, returndata, errorMessage);
415     }
416 
417     /**
418     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
419     * but performing a static call.
420     *
421     * _Available since v3.3._
422     */
423     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
424         return functionStaticCall(target, data, "Address: low-level static call failed");
425     }
426 
427     /**
428     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
429     * but performing a static call.
430     *
431     * _Available since v3.3._
432     */
433     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
434         require(isContract(target), "Address: static call to non-contract");
435 
436         // solhint-disable-next-line avoid-low-level-calls
437         (bool success, bytes memory returndata) = target.staticcall(data);
438         return _verifyCallResult(success, returndata, errorMessage);
439     }
440 
441     /**
442     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
443     * but performing a delegate call.
444     *
445     * _Available since v3.4._
446     */
447     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
448         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
449     }
450 
451     /**
452     * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
453     * but performing a delegate call.
454     *
455     * _Available since v3.4._
456     */
457     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
458         require(isContract(target), "Address: delegate call to non-contract");
459 
460         // solhint-disable-next-line avoid-low-level-calls
461         (bool success, bytes memory returndata) = target.delegatecall(data);
462         return _verifyCallResult(success, returndata, errorMessage);
463     }
464 
465     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
466         if (success) {
467             return returndata;
468         } else {
469             // Look for revert reason and bubble it up if present
470             if (returndata.length > 0) {
471                 // The easiest way to bubble the revert reason is using memory via assembly
472 
473                 // solhint-disable-next-line no-inline-assembly
474                 assembly {
475                     let returndata_size := mload(returndata)
476                     revert(add(32, returndata), returndata_size)
477                 }
478             } else {
479                 revert(errorMessage);
480             }
481         }
482     }
483 }
484 
485 /**
486  * @dev Contract module which provides a basic access control mechanism, where
487  * there is an account (an owner) that can be granted exclusive access to
488  * specific functions.
489  *
490  * By default, the owner account will be the one that deploys the contract. This
491  * can later be changed with {transferOwnership}.
492  *
493  * This module is used through inheritance. It will make available the modifier
494  * `onlyOwner`, which can be applied to your functions to restrict their use to
495  * the owner.
496  */
497 abstract contract Ownable is Context {
498     address private _owner;
499 
500     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
501     mapping (address => bool) public admins;
502     event AdminAdded(address adminAddress);
503     event AdminRemoved(address adminAddress);
504    
505     /**
506     * @dev Initializes the contract setting the deployer as the initial owner.
507     */
508     constructor () {
509         _owner = _msgSender();
510         emit OwnershipTransferred(address(0), _owner);
511     }
512 
513     /**
514     * @dev Returns the address of the current owner.
515     */
516     function owner() public view virtual returns (address) {
517         return _owner;
518     }
519 
520     /**
521     * @dev Throws if called by any account other than the owner.
522     */
523     modifier onlyOwner() {
524         require(owner() == _msgSender(), "Ownable: caller is not the owner");
525         _;
526     }
527     
528     /**
529     * Added modifier for external access to taxfee and reflection modifications within allowed range & to exclude CEX wallet and upcoming staking platform addresses to avoid fees on transfers.
530     */    
531     modifier onlyAdmins() {
532         require(owner() == _msgSender() || admins[_msgSender()] == true);
533         _;
534     }
535     
536     /**
537     * @dev Leaves the contract without owner. It will not be possible to call
538     * `onlyOwner` functions anymore. Can only be called by the current owner.
539     *
540     * NOTE: Renouncing ownership will leave the contract without an owner,
541     * thereby removing any functionality that is only available to the owner.
542     */
543     function renounceOwnership() public virtual onlyOwner {
544         emit OwnershipTransferred(_owner, address(0));
545         _owner = address(0);
546     }
547 
548     /**
549     * @dev Transfers ownership of the contract to a new account (`newOwner`).
550     * Can only be called by the current owner.
551     */
552     function transferOwnership(address newOwner) public virtual onlyOwner {
553         require(newOwner != address(0), "Ownable: new owner is the zero address");
554         emit OwnershipTransferred(_owner, newOwner);
555         _owner = newOwner;
556     }
557     
558     
559     //added for external access of inevitable functions FFS!
560     
561     function isAdmin(address _address) public view returns (bool) {
562         return admins[_address];
563     }
564 
565     function isOwner(address _address) public view returns (bool) {
566         return _address == owner();
567     }
568 
569     function isAdminOrOwner(address _address) public view returns (bool) {
570         return admins[_address] == true || _address == owner();
571     }
572 
573     function setAdmin(address _adminAddress, bool _isAdmin) public onlyOwner {
574         admins[_adminAddress] = _isAdmin;
575 
576         if (_isAdmin == true) {
577             emit AdminAdded(_adminAddress);
578         } else {
579             emit AdminRemoved(_adminAddress);
580         }
581     }    
582   
583 }
584 
585 interface IUniswapV2Factory {
586     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
587 
588     function feeTo() external view returns (address);
589     function feeToSetter() external view returns (address);
590 
591     function getPair(address tokenA, address tokenB) external view returns (address pair);
592     function allPairs(uint) external view returns (address pair);
593     function allPairsLength() external view returns (uint);
594 
595     function createPair(address tokenA, address tokenB) external returns (address pair);
596 
597     function setFeeTo(address) external;
598     function setFeeToSetter(address) external;
599 }
600 
601 interface IUniswapV2Pair {
602     event Approval(address indexed owner, address indexed spender, uint value);
603     event Transfer(address indexed from, address indexed to, uint value);
604 
605     function name() external pure returns (string memory);
606     function symbol() external pure returns (string memory);
607     function decimals() external pure returns (uint8);
608     function totalSupply() external view returns (uint);
609     function balanceOf(address owner) external view returns (uint);
610     function allowance(address owner, address spender) external view returns (uint);
611 
612     function approve(address spender, uint value) external returns (bool);
613     function transfer(address to, uint value) external returns (bool);
614     function transferFrom(address from, address to, uint value) external returns (bool);
615 
616     function DOMAIN_SEPARATOR() external view returns (bytes32);
617     function PERMIT_TYPEHASH() external pure returns (bytes32);
618     function nonces(address owner) external view returns (uint);
619 
620     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
621 
622     event Mint(address indexed sender, uint amount0, uint amount1);
623     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
624     event Swap(
625         address indexed sender,
626         uint amount0In,
627         uint amount1In,
628         uint amount0Out,
629         uint amount1Out,
630         address indexed to
631     );
632     event Sync(uint112 reserve0, uint112 reserve1);
633 
634     function MINIMUM_LIQUIDITY() external pure returns (uint);
635     function factory() external view returns (address);
636     function token0() external view returns (address);
637     function token1() external view returns (address);
638     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
639     function price0CumulativeLast() external view returns (uint);
640     function price1CumulativeLast() external view returns (uint);
641     function kLast() external view returns (uint);
642 
643     function mint(address to) external returns (uint liquidity);
644     function burn(address to) external returns (uint amount0, uint amount1);
645     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
646     function skim(address to) external;
647     function sync() external;
648 
649     function initialize(address, address) external;
650 }
651 
652 interface IUniswapV2Router01 {
653     function factory() external pure returns (address);
654     function WETH() external pure returns (address);
655 
656     function addLiquidity(
657         address tokenA,
658         address tokenB,
659         uint amountADesired,
660         uint amountBDesired,
661         uint amountAMin,
662         uint amountBMin,
663         address to,
664         uint deadline
665     ) external returns (uint amountA, uint amountB, uint liquidity);
666     function addLiquidityETH(
667         address token,
668         uint amountTokenDesired,
669         uint amountTokenMin,
670         uint amountETHMin,
671         address to,
672         uint deadline
673     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
674     function removeLiquidity(
675         address tokenA,
676         address tokenB,
677         uint liquidity,
678         uint amountAMin,
679         uint amountBMin,
680         address to,
681         uint deadline
682     ) external returns (uint amountA, uint amountB);
683     function removeLiquidityETH(
684         address token,
685         uint liquidity,
686         uint amountTokenMin,
687         uint amountETHMin,
688         address to,
689         uint deadline
690     ) external returns (uint amountToken, uint amountETH);
691     function removeLiquidityWithPermit(
692         address tokenA,
693         address tokenB,
694         uint liquidity,
695         uint amountAMin,
696         uint amountBMin,
697         address to,
698         uint deadline,
699         bool approveMax, uint8 v, bytes32 r, bytes32 s
700     ) external returns (uint amountA, uint amountB);
701     function removeLiquidityETHWithPermit(
702         address token,
703         uint liquidity,
704         uint amountTokenMin,
705         uint amountETHMin,
706         address to,
707         uint deadline,
708         bool approveMax, uint8 v, bytes32 r, bytes32 s
709     ) external returns (uint amountToken, uint amountETH);
710     function swapExactTokensForTokens(
711         uint amountIn,
712         uint amountOutMin,
713         address[] calldata path,
714         address to,
715         uint deadline
716     ) external returns (uint[] memory amounts);
717     function swapTokensForExactTokens(
718         uint amountOut,
719         uint amountInMax,
720         address[] calldata path,
721         address to,
722         uint deadline
723     ) external returns (uint[] memory amounts);
724     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
725         external
726         payable
727         returns (uint[] memory amounts);
728     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
729         external
730         returns (uint[] memory amounts);
731     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
732         external
733         returns (uint[] memory amounts);
734     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
735         external
736         payable
737         returns (uint[] memory amounts);
738 
739     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
740     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
741     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
742     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
743     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
744 }
745 
746 interface IUniswapV2Router02 is IUniswapV2Router01 {
747     function removeLiquidityETHSupportingFeeOnTransferTokens(
748         address token,
749         uint liquidity,
750         uint amountTokenMin,
751         uint amountETHMin,
752         address to,
753         uint deadline
754     ) external returns (uint amountETH);
755     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
756         address token,
757         uint liquidity,
758         uint amountTokenMin,
759         uint amountETHMin,
760         address to,
761         uint deadline,
762         bool approveMax, uint8 v, bytes32 r, bytes32 s
763     ) external returns (uint amountETH);
764 
765     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
766         uint amountIn,
767         uint amountOutMin,
768         address[] calldata path,
769         address to,
770         uint deadline
771     ) external;
772     function swapExactETHForTokensSupportingFeeOnTransferTokens(
773         uint amountOutMin,
774         address[] calldata path,
775         address to,
776         uint deadline
777     ) external payable;
778     function swapExactTokensForETHSupportingFeeOnTransferTokens(
779         uint amountIn,
780         uint amountOutMin,
781         address[] calldata path,
782         address to,
783         uint deadline
784     ) external;
785 }
786 
787 
788 contract ShinChanToken is Context, IERC20, Ownable {
789     using SafeMath for uint256;
790     using Address for address;
791 
792     uint8 private _decimals = 9;
793 
794     // 
795     string private _name = "ShinChan Token";                                 // name
796     string private _symbol = "Shinnosuke";                                   // ticker
797     uint256 private _tTotal = 1 * 10**18 * 10**uint256(_decimals);
798     mapping (address => uint256) public timestamp;
799 
800     // % to holders
801     uint256 public defaultTaxFee = 1;
802     uint256 public _taxFee = defaultTaxFee;
803     uint256 private _previousTaxFee = _taxFee;
804 
805     // % to swap & send to marketing wallet
806     uint256 public defaultMarketingFee = 11;
807     uint256 public _marketingFee = defaultMarketingFee;
808     uint256 private _previousMarketingFee = _marketingFee;
809 
810     uint256 public _marketingFee4Sellers = 11;
811 
812     bool public feesOnSellersAndBuyers = true;
813     
814     // Variable for function to run before adding liquidity
815     uint256 public LaunchTime = block.timestamp;
816     bool public Launched = false;
817     uint256 public launchBlock;   
818 
819     uint256 public _maxTxAmount = _tTotal.div(200);
820     uint256 public maxWalletBalance = _tTotal.div(25);    //Super whale protection
821     uint256 public numTokensToExchangeForMarketing = _tTotal.div(100).div(100);
822     address payable public marketingWallet = payable(0x22e790b8174E96048321b0d08473445a791b9d2C);
823 
824     //
825 
826     mapping (address => uint256) private _rOwned;
827     mapping (address => uint256) private _tOwned;
828     mapping (address => mapping (address => uint256)) private _allowances;
829     
830     mapping (address => bool) private _isExcludedFromFee;
831 
832     mapping (address => bool) private _isExcluded;
833     
834     mapping (address => bool) public _isBlacklisted;
835 
836     address[] private _excluded;
837     uint256 private constant MAX = ~uint256(0);
838 
839     uint256 private _tFeeTotal;
840     uint256 private _rTotal = (MAX - (MAX % _tTotal));
841 
842     IUniswapV2Router02 public immutable uniswapV2Router;
843     address public immutable uniswapV2Pair;
844 
845     bool inSwapAndSend;
846     bool public SwapAndSendEnabled = true;
847 
848     event SwapAndSendEnabledUpdated(bool enabled);
849 
850     modifier lockTheSwap {
851         inSwapAndSend = true;
852         _;
853         inSwapAndSend = false;
854     }
855 
856     constructor () {
857         _rOwned[_msgSender()] = _rTotal;
858 
859         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
860          // Create a uniswap pair for this new token
861         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
862             .createPair(address(this), _uniswapV2Router.WETH());
863 
864         // set the rest of the contract variables
865         uniswapV2Router = _uniswapV2Router;
866 
867         //exclude owner and this contract from fee
868         _isExcludedFromFee[owner()] = true;
869         _isExcludedFromFee[address(this)] = true;
870 
871         emit Transfer(address(0), _msgSender(), _tTotal);
872     }
873 
874     function name() public view returns (string memory) {
875         return _name;
876     }
877 
878     function symbol() public view returns (string memory) {
879         return _symbol;
880     }
881 
882     function decimals() public view returns (uint8) {
883         return _decimals;
884     }
885 
886     function totalSupply() public view override returns (uint256) {
887         return _tTotal;
888     }
889 
890     function balanceOf(address account) public view override returns (uint256) {
891         if (_isExcluded[account]) return _tOwned[account];
892         return tokenFromReflection(_rOwned[account]);
893     }
894 
895     function transfer(address recipient, uint256 amount) public override returns (bool) {
896         _transfer(_msgSender(), recipient, amount);
897         return true;
898     }
899 
900     function allowance(address owner, address spender) public view override returns (uint256) {
901         return _allowances[owner][spender];
902     }
903 
904     function approve(address spender, uint256 amount) public override returns (bool) {
905         _approve(_msgSender(), spender, amount);
906         return true;
907     }
908 
909     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
910         _transfer(sender, recipient, amount);
911         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
912         return true;
913     }
914 
915     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
916         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
917         return true;
918     }
919 
920     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
921         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
922         return true;
923     }
924 
925     function isExcludedFromReward(address account) public view returns (bool) {
926         return _isExcluded[account];
927     }
928 
929     function totalFees() public view returns (uint256) {
930         return _tFeeTotal;
931     }
932 
933     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
934         require(tAmount <= _tTotal, "Amount must be less than supply");
935         if (!deductTransferFee) {
936             (uint256 rAmount,,,,,) = _getValues(tAmount);
937             return rAmount;
938         } else {
939             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
940             return rTransferAmount;
941         }
942     }
943 
944     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
945         require(rAmount <= _rTotal, "Amount must be less than total reflections");
946         uint256 currentRate =  _getRate();
947         return rAmount.div(currentRate);
948     }
949 
950     function excludeFromReward(address account) public onlyOwner() {
951         // require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
952         require(!_isExcluded[account], "Account is already excluded");
953         if(_rOwned[account] > 0) {
954             _tOwned[account] = tokenFromReflection(_rOwned[account]);
955         }
956         _isExcluded[account] = true;
957         _excluded.push(account);
958     }
959 
960     function includeInReward(address account) external onlyOwner() {
961         require(_isExcluded[account], "Account is already excluded");
962         for (uint256 i = 0; i < _excluded.length; i++) {
963             if (_excluded[i] == account) {
964                 _excluded[i] = _excluded[_excluded.length - 1];
965                 _tOwned[account] = 0;
966                 _isExcluded[account] = false;
967                 _excluded.pop();
968                 break;
969             }
970         }
971     }
972 
973     function excludeFromFee(address account) public onlyAdmins() {
974         _isExcludedFromFee[account] = true;
975     }
976 
977     function includeInFee(address account) public onlyAdmins() {
978         _isExcludedFromFee[account] = false;
979     }
980 
981     function removeAllFee() private {
982         if(_taxFee == 0 && _marketingFee == 0) return;
983 
984         _previousTaxFee = _taxFee;
985         _previousMarketingFee = _marketingFee;
986 
987         _taxFee = 0;
988         _marketingFee = 0;
989     }
990 
991     function restoreAllFee() private {
992         _taxFee = _previousTaxFee;
993         _marketingFee = _previousMarketingFee;
994     }
995 
996     //to recieve ETH
997     receive() external payable {}
998 
999     function _reflectFee(uint256 rFee, uint256 tFee) private {
1000         _rTotal = _rTotal.sub(rFee);
1001         _tFeeTotal = _tFeeTotal.add(tFee);
1002     }
1003     
1004      function addToBlackList(address[] calldata addresses) external onlyOwner {
1005       for (uint256 i; i < addresses.length; ++i) {
1006         _isBlacklisted[addresses[i]] = true;
1007       }
1008     }
1009     
1010       function removeFromBlackList(address account) external onlyOwner {
1011         _isBlacklisted[account] = false;
1012     }
1013 
1014     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1015         (uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getTValues(tAmount);
1016         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tMarketing, _getRate());
1017         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tMarketing);
1018     }
1019 
1020     function _getTValues(uint256 tAmount) private view returns (uint256, uint256, uint256) {
1021         uint256 tFee = calculateTaxFee(tAmount);
1022         uint256 tMarketing = calculateMarketingFee(tAmount);
1023         uint256 tTransferAmount = tAmount.sub(tFee).sub(tMarketing);
1024         return (tTransferAmount, tFee, tMarketing);
1025     }
1026 
1027     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tMarketing, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1028         uint256 rAmount = tAmount.mul(currentRate);
1029         uint256 rFee = tFee.mul(currentRate);
1030         uint256 rMarketing = tMarketing.mul(currentRate);
1031         uint256 rTransferAmount = rAmount.sub(rFee).sub(rMarketing);
1032         return (rAmount, rTransferAmount, rFee);
1033     }
1034 
1035     function _getRate() private view returns(uint256) {
1036         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1037         return rSupply.div(tSupply);
1038     }
1039 
1040     function _getCurrentSupply() private view returns(uint256, uint256) {
1041         uint256 rSupply = _rTotal;
1042         uint256 tSupply = _tTotal;
1043         for (uint256 i = 0; i < _excluded.length; i++) {
1044             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1045             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1046             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1047         }
1048         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1049         return (rSupply, tSupply);
1050     }
1051 
1052     function _takeMarketing(uint256 tMarketing) private {
1053         uint256 currentRate =  _getRate();
1054         uint256 rMarketing = tMarketing.mul(currentRate);
1055         _rOwned[address(this)] = _rOwned[address(this)].add(rMarketing);
1056         if(_isExcluded[address(this)])
1057             _tOwned[address(this)] = _tOwned[address(this)].add(tMarketing);
1058     }
1059 
1060     function calculateTaxFee(uint256 _amount) private view returns (uint256) {
1061         return _amount.mul(_taxFee).div(
1062             10**2
1063         );
1064     }
1065 
1066     function calculateMarketingFee(uint256 _amount) private view returns (uint256) {
1067         return _amount.mul(_marketingFee).div(
1068             10**2
1069         );
1070     }
1071 
1072     function isExcludedFromFee(address account) public view returns(bool) {
1073         return _isExcludedFromFee[account];
1074     }
1075 
1076     function _approve(address owner, address spender, uint256 amount) private {
1077         require(owner != address(0), "ERC20: approve from the zero address");
1078         require(spender != address(0), "ERC20: approve to the zero address");
1079 
1080         _allowances[owner][spender] = amount;
1081         emit Approval(owner, spender, amount);
1082     }
1083 
1084     function _transfer(
1085         address from,
1086         address to,
1087         uint256 amount
1088     ) private {
1089         require(from != address(0), "ERC20: transfer from the zero address");
1090         require(to != address(0), "ERC20: transfer to the zero address");
1091         require(amount > 0, "Transfer amount must be greater than zero");
1092         require(!_isBlacklisted[from] && !_isBlacklisted[to], "This address is blacklisted");
1093 
1094         if(from != owner() && to != owner())
1095             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1096 
1097         // is the token balance of this contract address over the min number of
1098         // tokens that we need to initiate a swap + send lock?
1099         // also, don't get caught in a circular sending event.
1100         // also, don't swap & liquify if sender is uniswap pair.
1101         uint256 contractTokenBalance = balanceOf(address(this));
1102         bool overMinTokenBalance = contractTokenBalance >= numTokensToExchangeForMarketing;
1103 
1104         if(contractTokenBalance >= _maxTxAmount)
1105         {
1106             contractTokenBalance = _maxTxAmount;
1107         }
1108 
1109         if (
1110             overMinTokenBalance &&
1111             !inSwapAndSend &&
1112             from != uniswapV2Pair &&
1113             SwapAndSendEnabled
1114         ) {
1115             SwapAndSend(contractTokenBalance);
1116         }
1117 
1118         if(feesOnSellersAndBuyers) {
1119             setFees(to);
1120         }
1121 
1122         //indicates if fee should be deducted from transfer
1123         bool takeFee = true;
1124 
1125         //Limitation on the maximum wallet balance (for first 6 hours) to avoid super whales
1126         if(!_isExcludedFromFee[to] && to != uniswapV2Pair){
1127             if(block.timestamp < LaunchTime + 6 hours){
1128                 require(balanceOf(to).add(amount) <= maxWalletBalance, 'Recipient balance is exceeding maxWalletBalance! Try again after 6 hours post launch');
1129             }
1130         }        
1131 
1132         //if any account belongs to _isExcludedFromFee account then remove the fee
1133         if(_isExcludedFromFee[from] || _isExcludedFromFee[to]) {
1134             takeFee = false;
1135         }
1136 
1137         _tokenTransfer(from,to,amount,takeFee);
1138     }
1139 
1140     function setFees(address recipient) private {
1141         _taxFee = defaultTaxFee;
1142         _marketingFee = defaultMarketingFee;
1143         if (recipient == uniswapV2Pair) { // sell
1144             _marketingFee = _marketingFee4Sellers;
1145         }
1146     }
1147 
1148     function SwapAndSend(uint256 contractTokenBalance) private lockTheSwap {
1149         // generate the uniswap pair path of token -> weth
1150         address[] memory path = new address[](2);
1151         path[0] = address(this);
1152         path[1] = uniswapV2Router.WETH();
1153 
1154         _approve(address(this), address(uniswapV2Router), contractTokenBalance);
1155 
1156         // make the swap
1157         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1158             contractTokenBalance,
1159             0, // accept any amount of ETH
1160             path,
1161             address(this),
1162             block.timestamp
1163         );
1164 
1165         uint256 contractETHBalance = address(this).balance;
1166         if(contractETHBalance > 0) {
1167             marketingWallet.transfer(contractETHBalance);
1168         }
1169     }
1170 
1171     //this method is responsible for taking all fee, if takeFee is true
1172     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1173         if(!takeFee)
1174             removeAllFee();
1175 
1176         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1177             _transferFromExcluded(sender, recipient, amount);
1178         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1179             _transferToExcluded(sender, recipient, amount);
1180         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1181             _transferStandard(sender, recipient, amount);
1182         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1183             _transferBothExcluded(sender, recipient, amount);
1184         } else {
1185             _transferStandard(sender, recipient, amount);
1186         }
1187 
1188         if(!takeFee)
1189             restoreAllFee();
1190     }
1191 
1192     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1193         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1194         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1195         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1196         _takeMarketing(tMarketing);
1197         _reflectFee(rFee, tFee);
1198         emit Transfer(sender, recipient, tTransferAmount);
1199     }
1200 
1201     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1202         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1203         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1204         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1205         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1206         _takeMarketing(tMarketing);
1207         _reflectFee(rFee, tFee);
1208         emit Transfer(sender, recipient, tTransferAmount);
1209     }
1210 
1211     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1212         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1213         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1214         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1215         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1216         _takeMarketing(tMarketing);
1217         _reflectFee(rFee, tFee);
1218         emit Transfer(sender, recipient, tTransferAmount);
1219     }
1220 
1221     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1222         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tMarketing) = _getValues(tAmount);
1223         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1224         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1225         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1226         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1227         _takeMarketing(tMarketing);
1228         _reflectFee(rFee, tFee);
1229         emit Transfer(sender, recipient, tTransferAmount);
1230     }
1231 
1232     function setDefaultMarketingFee(uint256 marketingFee) external onlyAdmins() {
1233         require(marketingFee >= 0 && marketingFee <= 15, 'marketingFee should be in 0 - 15');
1234         
1235         defaultMarketingFee = marketingFee;
1236     }
1237 
1238     function setReflectionFee(uint256 reflectionFeePercentage) external onlyAdmins() {
1239         require(reflectionFeePercentage >= 0 && reflectionFeePercentage <= 10, 'reflectionFeePercentage should be in 0 - 10');
1240         defaultTaxFee = reflectionFeePercentage;
1241     }
1242 
1243     function setMarketingFee4Sellers(uint256 marketingFee4Sellers) external onlyAdmins() {
1244         require(marketingFee4Sellers >= 0 && marketingFee4Sellers <= 15, 'marketingFee4Sellers should be in 0 - 15');
1245         _marketingFee4Sellers = marketingFee4Sellers;
1246     }
1247 
1248     function setFeesOnSellersAndBuyers(bool _enabled) public onlyAdmins() {
1249         feesOnSellersAndBuyers = _enabled;
1250     }
1251     
1252     //function to keep track of timing of launch
1253     function setLaunchingTime(bool _Launched) external onlyOwner() {
1254         Launched = _Launched;
1255         LaunchTime = block.timestamp;
1256         launchBlock = block.number;
1257     }
1258     
1259     function setSwapAndSendEnabled(bool _enabled) public onlyOwner() {
1260         SwapAndSendEnabled = _enabled;
1261         emit SwapAndSendEnabledUpdated(_enabled);
1262     }
1263 
1264     function setnumTokensToExchangeForMarketing(uint256 _numTokensToExchangeForMarketing) public onlyOwner() {
1265         numTokensToExchangeForMarketing = _numTokensToExchangeForMarketing;
1266     }
1267 
1268     function _setMarketingWallet(address payable wallet) external onlyAdmins() {
1269         marketingWallet = wallet;
1270     }
1271     
1272     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
1273         _maxTxAmount = maxTxAmount;
1274     }
1275     
1276     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1277         _maxTxAmount = _tTotal.mul(maxTxPercent).div(10**2);
1278     }    
1279 }