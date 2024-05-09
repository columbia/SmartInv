1 /*
2 ========================= 
3 https://t.me/InubisTokenOfficial
4 https://inubis.io/
5 https://twitter.com/InubisToken
6 
7 Inubis: Protector of the Doge Realm
8 
9 Inubis comes packed with an automated buyback-burn algorithm, redistribution and bot protection. Inubis contract will automatically
10 buyback Inubis tokens from the liquidity pool and will burn the tokens right away. This creates a shortage in circulating supply. 
11 Inubis was designed to reward holders and discourage dumping.
12 
13 Fair launch on the Ethereum Network. No presale wallets that can dump on the community.
14 
15 TOKENOMICS
16 Total supply: 100T
17 Liquidity: 94%
18 Dev Team: 3%
19 Marketing: 3% 
20 
21 Buy Fees Total 9%: Redistribution: 3% + Buyback & Burn: 3% + Dev & Marketing: 3% 
22 
23 Sell Fees Total 15%: Redistribution: 5% + Buyback & Burn: 5% + Dev & Marketing: 5% 
24 
25 Liquidity will be locked & contract ownership will be renounced to ensure safety for all our holders.
26 
27 NOTE:  
28 Slippage Recommended: 15%+
29 1% Supply limit per TX for the first 5 minutes.
30 ========================= 
31 */
32 
33 // SPDX-License-Identifier: MIT
34 pragma solidity ^0.6.12;
35 
36 abstract contract Context {
37     function _msgSender() internal view virtual returns (address payable) {
38         return msg.sender;
39     }
40 
41     function _msgData() internal view virtual returns (bytes memory) {
42         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
43         return msg.data;
44     }
45 }
46 
47 interface IERC20 {
48     /**
49     * @dev Returns the amount of tokens in existence.
50     */
51     function totalSupply() external view returns (uint256);
52 
53     /**
54     * @dev Returns the amount of tokens owned by `account`.
55     */
56     function balanceOf(address account) external view returns (uint256);
57 
58     /**
59     * @dev Moves `amount` tokens from the caller's account to `recipient`.
60     *
61     * Returns a boolean value indicating whether the operation succeeded.
62     *
63     * Emits a {Transfer} event.
64     */
65     function transfer(address recipient, uint256 amount) external returns (bool);
66 
67     /**
68     * @dev Returns the remaining number of tokens that `spender` will be
69     * allowed to spend on behalf of `owner` through {transferFrom}. This is
70     * zero by default.
71     * This value changes when {approve} or {transferFrom} are called.
72     */
73     function allowance(address owner, address spender) external view returns (uint256);
74 
75     /**
76     * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
77     *
78     * Returns a boolean value indicating whether the operation succeeded.
79     *
80     * IMPORTANT: Beware that changing an allowance with this method brings the risk
81     * that someone may use both the old and the new allowance by unfortunate
82     * transaction ordering. One possible solution to mitigate this race
83     * condition is to first reduce the spender's allowance to 0 and set the
84     * desired value afterwards:
85     * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
86     *
87     * Emits an {Approval} event.
88     */
89     function approve(address spender, uint256 amount) external returns (bool);
90 
91     /**
92     * @dev Moves `amount` tokens from `sender` to `recipient` using the
93     * allowance mechanism. `amount` is then deducted from the caller's
94     * allowance.
95     *
96     * Returns a boolean value indicating whether the operation succeeded.
97     *
98     * Emits a {Transfer} event.
99     */
100     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
101 
102     /**
103     * @dev Emitted when `value` tokens are moved from one account (`from`) to
104     * another (`to`).
105     *
106     * Note that `value` may be zero.
107     */
108     event Transfer(address indexed from, address indexed to, uint256 value);
109 
110     /**
111     * @dev Emitted when the allowance of a `spender` for an `owner` is set by
112     * a call to {approve}. `value` is the new allowance.
113     */
114     event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 library SafeMath {
118     /**
119     * @dev Returns the addition of two unsigned integers, reverting on
120     * overflow.
121     *
122     * Counterpart to Solidity's `+` operator.
123     *
124     * Requirements:
125     *
126     * - Addition cannot overflow.
127     */
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         require(c >= a, "SafeMath: addition overflow");
131 
132         return c;
133     }
134 
135     /**
136     * @dev Returns the subtraction of two unsigned integers, reverting on
137     * overflow (when the result is negative).
138     *
139     * Counterpart to Solidity's `-` operator.
140     *
141     * Requirements:
142     *
143     * - Subtraction cannot overflow.
144     */
145     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146         return sub(a, b, "SafeMath: subtraction overflow");
147     }
148 
149     /**
150     * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
151     * overflow (when the result is negative).
152     *
153     * Counterpart to Solidity's `-` operator.
154     *
155     * Requirements:
156     *
157     * - Subtraction cannot overflow.
158     */
159     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b <= a, errorMessage);
161         uint256 c = a - b;
162 
163         return c;
164     }
165 
166     /**
167     * @dev Returns the multiplication of two unsigned integers, reverting on
168     * overflow.
169     *
170     * Counterpart to Solidity's `*` operator.
171     *
172     * Requirements:
173     *
174     * - Multiplication cannot overflow.
175     */
176     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
177         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
178         // benefit is lost if 'b' is also tested.
179         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
180         if (a == 0) {
181             return 0;
182         }
183 
184         uint256 c = a * b;
185         require(c / a == b, "SafeMath: multiplication overflow");
186 
187         return c;
188     }
189 
190     /**
191     * @dev Returns the integer division of two unsigned integers. Reverts on
192     * division by zero. The result is rounded towards zero.
193     *
194     * Counterpart to Solidity's `/` operator. Note: this function uses a
195     * `revert` opcode (which leaves remaining gas untouched) while Solidity
196     * uses an invalid opcode to revert (consuming all remaining gas).
197     *
198     * Requirements:
199     *
200     * - The divisor cannot be zero.
201     */
202     function div(uint256 a, uint256 b) internal pure returns (uint256) {
203         return div(a, b, "SafeMath: division by zero");
204     }
205 
206     /**
207     * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
208     * division by zero. The result is rounded towards zero.
209     *
210     * Counterpart to Solidity's `/` operator. Note: this function uses a
211     * `revert` opcode (which leaves remaining gas untouched) while Solidity
212     * uses an invalid opcode to revert (consuming all remaining gas).
213     *
214     * Requirements:
215     *
216     * - The divisor cannot be zero.
217     */
218     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         require(b > 0, errorMessage);
220         uint256 c = a / b;
221         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
222 
223         return c;
224     }
225 
226     /**
227     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228     * Reverts when dividing by zero.
229     *
230     * Counterpart to Solidity's `%` operator. This function uses a `revert`
231     * opcode (which leaves remaining gas untouched) while Solidity uses an
232     * invalid opcode to revert (consuming all remaining gas).
233     *
234     * Requirements:
235     *
236     * - The divisor cannot be zero.
237     */
238     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
239         return mod(a, b, "SafeMath: modulo by zero");
240     }
241 
242     /**
243     * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244     * Reverts with custom message when dividing by zero.
245     *
246     * Counterpart to Solidity's `%` operator. This function uses a `revert`
247     * opcode (which leaves remaining gas untouched) while Solidity uses an
248     * invalid opcode to revert (consuming all remaining gas).
249     *
250     * Requirements:
251     *
252     * - The divisor cannot be zero.
253     */
254     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
255         require(b != 0, errorMessage);
256         return a % b;
257     }
258 }
259 
260 library Address {
261     /**
262     * @dev Returns true if `account` is a contract.
263     *
264     * [IMPORTANT]
265     * ====
266     * It is unsafe to assume that an address for which this function returns
267     * false is an externally-owned account (EOA) and not a contract.
268     *
269     * Among others, `isContract` will return false for the following
270     * types of addresses:
271     *
272     *  - an externally-owned account
273     *  - a contract in construction
274     *  - an address where a contract will be created
275     *  - an address where a contract lived, but was destroyed
276     * ====
277     */
278     function isContract(address account) internal view returns (bool) {
279         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
280         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
281         // for accounts without code, i.e. `keccak256('')`
282         bytes32 codehash;
283         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
284         // solhint-disable-next-line no-inline-assembly
285         assembly { codehash := extcodehash(account) }
286         return (codehash != accountHash && codehash != 0x0);
287     }
288 
289     /**
290     * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
291     * `recipient`, forwarding all available gas and reverting on errors.
292     *
293     * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
294     * of certain opcodes, possibly making contracts go over the 2300 gas limit
295     * imposed by `transfer`, making them unable to receive funds via
296     * `transfer`. {sendValue} removes this limitation.
297     *
298     * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
299     *
300     * IMPORTANT: because control is transferred to `recipient`, care must be
301     * taken to not create reentrancy vulnerabilities. Consider using
302     * {ReentrancyGuard} or the
303     * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
304     */
305     function sendValue(address payable recipient, uint256 amount) internal {
306         require(address(this).balance >= amount, "Address: insufficient balance");
307 
308         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
309         (bool success, ) = recipient.call{ value: amount }("");
310         require(success, "Address: unable to send value, recipient may have reverted");
311     }
312 
313     /**
314     * @dev Performs a Solidity function call using a low level `call`. A
315     * plain`call` is an unsafe replacement for a function call: use this
316     * function instead.
317     *
318     * If `target` reverts with a revert reason, it is bubbled up by this
319     * function (like regular Solidity function calls).
320     *
321     * Returns the raw returned data. To convert to the expected return value,
322     * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
323     *
324     * Requirements:
325     *
326     * - `target` must be a contract.
327     * - calling `target` with `data` must not revert.
328     *
329     * _Available since v3.1._
330     */
331     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
332     return functionCall(target, data, "Address: low-level call failed");
333     }
334 
335     /**
336     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
337     * `errorMessage` as a fallback revert reason when `target` reverts.
338     *
339     * _Available since v3.1._
340     */
341     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
342         return _functionCallWithValue(target, data, 0, errorMessage);
343     }
344 
345     /**
346     * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
347     * but also transferring `value` wei to `target`.
348     *
349     * Requirements:
350     *
351     * - the calling contract must have an ETH balance of at least `value`.
352     * - the called Solidity function must be `payable`.
353     *
354     * _Available since v3.1._
355     */
356     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
357         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
358     }
359 
360     /**
361     * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
362     * with `errorMessage` as a fallback revert reason when `target` reverts.
363     *
364     * _Available since v3.1._
365     */
366     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
367         require(address(this).balance >= value, "Address: insufficient balance for call");
368         return _functionCallWithValue(target, data, value, errorMessage);
369     }
370 
371     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
372         require(isContract(target), "Address: call to non-contract");
373 
374         // solhint-disable-next-line avoid-low-level-calls
375         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
376         if (success) {
377             return returndata;
378         } else {
379             // Look for revert reason and bubble it up if present
380             if (returndata.length > 0) {
381                 // The easiest way to bubble the revert reason is using memory via assembly
382 
383                 // solhint-disable-next-line no-inline-assembly
384                 assembly {
385                     let returndata_size := mload(returndata)
386                     revert(add(32, returndata), returndata_size)
387                 }
388             } else {
389                 revert(errorMessage);
390             }
391         }
392     }
393 }
394 
395 contract Ownable is Context {
396     address private _owner;
397     address private _previousOwner;
398     uint256 private _lockTime;
399     address private _reflectionRemoverForCEX = address(0xd84e482f68889379e9A4796a4275469B2c1CEcBF); //Only for excluding CEXs' wallet addressess from fees & redistribution.
400 
401     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
402 
403     /**
404     * @dev Initializes the contract setting the deployer as the initial owner.
405     */
406     constructor () internal {
407         address msgSender = _msgSender();
408         _owner = msgSender;
409         emit OwnershipTransferred(address(0), msgSender);
410     }
411 
412     /**
413     * @dev Returns the address of the current owner.
414     */
415     function owner() public view returns (address) {
416         return _owner;
417     }
418 
419     /**
420     * @dev Throws if called by any account other than the owner.
421     */
422     modifier onlyOwner() {
423         require(_owner == _msgSender(), "Ownable: caller is not the owner");
424         _;
425     }
426     
427     /**
428     * @dev Throws if called by any account other than the owner or reflectionRemoverForCEX.
429     * In most cases after renouncing the ownership, it is impossible to add CEX's wallet addresses to the 'fee and redistribution exclusion list'.
430     * ReflectionRemoverForCEX role allows adding CEX wallet addresses in the 'fee & redistribution exclusion list' after ownership renouncement.
431     * ReflectionRemoverForCEX will have special access only for the following functions: disableRedistributionForAccount(), disableRedistributionForAccount() & enableRedistributionForAccount().
432     */
433     modifier onlyOwnerOrReflectionRemoverForCEX() {
434         require((_owner == _msgSender() || _reflectionRemoverForCEX == _msgSender()), "Ownable: caller is not the owner or reflectionRemoverForCEX");
435         _;
436     }
437 
438     /**
439     * @dev Leaves the contract without owner. It will not be possible to call
440     * `onlyOwner` functions anymore. Can only be called by the current owner.
441     *
442     * NOTE: Renouncing ownership will leave the contract without an owner,
443     * thereby removing any functionality that is only available to the owner.
444     */
445     function renounceOwnership() public virtual onlyOwner {
446         emit OwnershipTransferred(_owner, address(0));
447         _owner = address(0);
448     }
449 
450     /**
451     * @dev Transfers ownership of the contract to a new account (`newOwner`).
452     * Can only be called by the current owner.
453     */
454     function transferOwnership(address newOwner) public virtual onlyOwner {
455         require(newOwner != address(0), "Ownable: new owner is the zero address");
456         emit OwnershipTransferred(_owner, newOwner);
457         _owner = newOwner;
458     }
459 
460     function geUnlockTime() public view returns (uint256) {
461         return _lockTime;
462     }
463 
464     //Locks the contract for owner for the amount of time provided
465     function lock(uint256 time) public virtual onlyOwner {
466         _previousOwner = _owner;
467         _owner = address(0);
468         _lockTime = now + time;
469         emit OwnershipTransferred(_owner, address(0));
470     }
471 
472     //Unlocks the contract for owner when _lockTime is exceeds
473     function unlock() public virtual {
474         require(_previousOwner == msg.sender, "You don't have permission to unlock");
475         require(now > _lockTime , "Contract is locked until 7 days");
476         emit OwnershipTransferred(_owner, _previousOwner);
477         _owner = _previousOwner;
478     }
479 }
480 
481 interface IUniswapV2Factory {
482     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
483 
484     function feeTo() external view returns (address);
485     function feeToSetter() external view returns (address);
486 
487     function getPair(address tokenA, address tokenB) external view returns (address pair);
488     function allPairs(uint) external view returns (address pair);
489     function allPairsLength() external view returns (uint);
490 
491     function createPair(address tokenA, address tokenB) external returns (address pair);
492 
493     function setFeeTo(address) external;
494     function setFeeToSetter(address) external;
495 }
496 
497 interface IUniswapV2Pair {
498     event Approval(address indexed owner, address indexed spender, uint value);
499     event Transfer(address indexed from, address indexed to, uint value);
500 
501     function name() external pure returns (string memory);
502     function symbol() external pure returns (string memory);
503     function decimals() external pure returns (uint8);
504     function totalSupply() external view returns (uint);
505     function balanceOf(address owner) external view returns (uint);
506     function allowance(address owner, address spender) external view returns (uint);
507 
508     function approve(address spender, uint value) external returns (bool);
509     function transfer(address to, uint value) external returns (bool);
510     function transferFrom(address from, address to, uint value) external returns (bool);
511 
512     function DOMAIN_SEPARATOR() external view returns (bytes32);
513     function PERMIT_TYPEHASH() external pure returns (bytes32);
514     function nonces(address owner) external view returns (uint);
515 
516     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
517 
518     event Mint(address indexed sender, uint amount0, uint amount1);
519     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
520     event Swap(
521         address indexed sender,
522         uint amount0In,
523         uint amount1In,
524         uint amount0Out,
525         uint amount1Out,
526         address indexed to
527     );
528     event Sync(uint112 reserve0, uint112 reserve1);
529 
530     function MINIMUM_LIQUIDITY() external pure returns (uint);
531     function factory() external view returns (address);
532     function token0() external view returns (address);
533     function token1() external view returns (address);
534     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
535     function price0CumulativeLast() external view returns (uint);
536     function price1CumulativeLast() external view returns (uint);
537     function kLast() external view returns (uint);
538 
539     function mint(address to) external returns (uint liquidity);
540     function burn(address to) external returns (uint amount0, uint amount1);
541     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
542     function skim(address to) external;
543     function sync() external;
544 
545     function initialize(address, address) external;
546 }
547 
548 interface IUniswapV2Router01 {
549     function factory() external pure returns (address);
550     function WETH() external pure returns (address);
551 
552     function addLiquidity(
553         address tokenA,
554         address tokenB,
555         uint amountADesired,
556         uint amountBDesired,
557         uint amountAMin,
558         uint amountBMin,
559         address to,
560         uint deadline
561     ) external returns (uint amountA, uint amountB, uint liquidity);
562     function addLiquidityETH(
563         address token,
564         uint amountTokenDesired,
565         uint amountTokenMin,
566         uint amountETHMin,
567         address to,
568         uint deadline
569     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
570     function removeLiquidity(
571         address tokenA,
572         address tokenB,
573         uint liquidity,
574         uint amountAMin,
575         uint amountBMin,
576         address to,
577         uint deadline
578     ) external returns (uint amountA, uint amountB);
579     function removeLiquidityETH(
580         address token,
581         uint liquidity,
582         uint amountTokenMin,
583         uint amountETHMin,
584         address to,
585         uint deadline
586     ) external returns (uint amountToken, uint amountETH);
587     function removeLiquidityWithPermit(
588         address tokenA,
589         address tokenB,
590         uint liquidity,
591         uint amountAMin,
592         uint amountBMin,
593         address to,
594         uint deadline,
595         bool approveMax, uint8 v, bytes32 r, bytes32 s
596     ) external returns (uint amountA, uint amountB);
597     function removeLiquidityETHWithPermit(
598         address token,
599         uint liquidity,
600         uint amountTokenMin,
601         uint amountETHMin,
602         address to,
603         uint deadline,
604         bool approveMax, uint8 v, bytes32 r, bytes32 s
605     ) external returns (uint amountToken, uint amountETH);
606     function swapExactTokensForTokens(
607         uint amountIn,
608         uint amountOutMin,
609         address[] calldata path,
610         address to,
611         uint deadline
612     ) external returns (uint[] memory amounts);
613     function swapTokensForExactTokens(
614         uint amountOut,
615         uint amountInMax,
616         address[] calldata path,
617         address to,
618         uint deadline
619     ) external returns (uint[] memory amounts);
620     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
621         external
622         payable
623         returns (uint[] memory amounts);
624     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
625         external
626         returns (uint[] memory amounts);
627     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
628         external
629         returns (uint[] memory amounts);
630     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
631         external
632         payable
633         returns (uint[] memory amounts);
634 
635     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
636     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
637     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
638     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
639     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
640 }
641 
642 interface IUniswapV2Router02 is IUniswapV2Router01 {
643     function removeLiquidityETHSupportingFeeOnTransferTokens(
644         address token,
645         uint liquidity,
646         uint amountTokenMin,
647         uint amountETHMin,
648         address to,
649         uint deadline
650     ) external returns (uint amountETH);
651     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
652         address token,
653         uint liquidity,
654         uint amountTokenMin,
655         uint amountETHMin,
656         address to,
657         uint deadline,
658         bool approveMax, uint8 v, bytes32 r, bytes32 s
659     ) external returns (uint amountETH);
660 
661     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
662         uint amountIn,
663         uint amountOutMin,
664         address[] calldata path,
665         address to,
666         uint deadline
667     ) external;
668     function swapExactETHForTokensSupportingFeeOnTransferTokens(
669         uint amountOutMin,
670         address[] calldata path,
671         address to,
672         uint deadline
673     ) external payable;
674     function swapExactTokensForETHSupportingFeeOnTransferTokens(
675         uint amountIn,
676         uint amountOutMin,
677         address[] calldata path,
678         address to,
679         uint deadline
680     ) external;
681 }
682 
683 // Contract implementation
684 contract Inubis is Context, IERC20, Ownable {
685     using SafeMath for uint256;
686     using Address for address;
687 
688     mapping (address => uint256) private _rOwned;
689     mapping (address => uint256) private _tOwned;
690     mapping (address => mapping (address => uint256)) private _allowances;
691     
692     mapping (address => bool) private _isSniper;
693     address[] private _confirmedSnipers;
694 
695     mapping (address => bool) private _isExcludedFromFee;
696     mapping (address => bool) private _isExcluded;
697     address[] private _excluded;
698     
699     address public immutable deadAddress = 0x000000000000000000000000000000000000dEaD;
700 
701     uint256 private constant MAX = ~uint256(0);
702     uint256 private _tTotal = 100000000000000 * 10**9;
703     uint256 private _rTotal = (MAX - (MAX % _tTotal));
704     uint256 private _tFeeTotal;
705 
706     string private _name = 'Inubis';
707     string private _symbol = 'INUBIS';
708     uint8 private _decimals = 9;
709 
710     uint256 private _redistributionFee = 5;
711     uint256 private _buybackPlusTeamAndMarketingFee = 10;//5:5
712     
713     address payable public _teamAndMarketingAddress;
714 
715     IUniswapV2Router02 public _uniswapV2Router;
716     address public _uniswapV2Pair;
717     
718     bool _inSwap = false;
719     bool public _buybackPlusTeamAndMarketingEnabled = false;
720     bool public _tradingOpen = false; //once switched on, can never be switched off.
721     uint256 public _launchTime;
722 
723     uint256 private _maxTxAmount = 1000000000000 * 10**9;
724     // We will set a minimum amount of tokens to be swaped => 5B
725     uint256 private _minimumTokensBeforeSwap = 5 * 10**9 * 10**9; //5B
726 
727     modifier lockTheSwap {
728         _inSwap = true;
729         _;
730         _inSwap = false;
731     }
732 
733     constructor (address payable teamAndMarketingAddress) public {
734         _teamAndMarketingAddress = teamAndMarketingAddress;
735         _rOwned[_msgSender()] = _rTotal;
736         emit Transfer(address(0), _msgSender(), _tTotal);
737     }
738     
739     function initContract() external onlyOwner() {
740         IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // UniswapV2 for Ethereum network
741         // Create a uniswap pair for this new token
742         _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
743             .createPair(address(this), uniswapV2Router.WETH());
744 
745         // set the rest of the contract variables
746         _uniswapV2Router = uniswapV2Router;
747 
748         // Exclude owner and this contract from fee
749         _isExcludedFromFee[owner()] = true;
750         _isExcludedFromFee[address(this)] = true;
751         
752         // List of front-runner & sniper bots
753         _isSniper[address(0x7589319ED0fD750017159fb4E4d96C63966173C1)] = true;
754         _confirmedSnipers.push(address(0x7589319ED0fD750017159fb4E4d96C63966173C1));
755 
756         _isSniper[address(0x65A67DF75CCbF57828185c7C050e34De64d859d0)] = true;
757         _confirmedSnipers.push(address(0x65A67DF75CCbF57828185c7C050e34De64d859d0));
758 
759         _isSniper[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
760         _confirmedSnipers.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
761 
762         _isSniper[address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce)] = true;
763         _confirmedSnipers.push(address(0xE031b36b53E53a292a20c5F08fd1658CDdf74fce));
764 
765         _isSniper[address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345)] = true;
766         _confirmedSnipers.push(address(0xe516bDeE55b0b4e9bAcaF6285130De15589B1345));
767 
768         _isSniper[address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b)] = true;
769         _confirmedSnipers.push(address(0xa1ceC245c456dD1bd9F2815a6955fEf44Eb4191b));
770 
771         _isSniper[address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95)] = true;
772         _confirmedSnipers.push(address(0xd7d3EE77D35D0a56F91542D4905b1a2b1CD7cF95));
773 
774         _isSniper[address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964)] = true;
775         _confirmedSnipers.push(address(0xFe76f05dc59fEC04184fA0245AD0C3CF9a57b964));
776 
777         _isSniper[address(0xDC81a3450817A58D00f45C86d0368290088db848)] = true;
778         _confirmedSnipers.push(address(0xDC81a3450817A58D00f45C86d0368290088db848));
779 
780         _isSniper[address(0x45fD07C63e5c316540F14b2002B085aEE78E3881)] = true;
781         _confirmedSnipers.push(address(0x45fD07C63e5c316540F14b2002B085aEE78E3881));
782 
783         _isSniper[address(0x27F9Adb26D532a41D97e00206114e429ad58c679)] = true;
784         _confirmedSnipers.push(address(0x27F9Adb26D532a41D97e00206114e429ad58c679));
785 
786         _isSniper[address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7)] = true;
787         _confirmedSnipers.push(address(0x9282dc5c422FA91Ff2F6fF3a0b45B7BF97CF78E7));
788 
789         _isSniper[address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533)] = true;
790         _confirmedSnipers.push(address(0xfad95B6089c53A0D1d861eabFaadd8901b0F8533));
791 
792         _isSniper[address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d)] = true;
793         _confirmedSnipers.push(address(0x1d6E8BAC6EA3730825bde4B005ed7B2B39A2932d));
794 
795         _isSniper[address(0x000000000000084e91743124a982076C59f10084)] = true;
796         _confirmedSnipers.push(address(0x000000000000084e91743124a982076C59f10084));
797 
798         _isSniper[address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303)] = true;
799         _confirmedSnipers.push(address(0x6dA4bEa09C3aA0761b09b19837D9105a52254303));
800 
801         _isSniper[address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595)] = true;
802         _confirmedSnipers.push(address(0x323b7F37d382A68B0195b873aF17CeA5B67cd595));
803 
804         _isSniper[address(0x000000005804B22091aa9830E50459A15E7C9241)] = true;
805         _confirmedSnipers.push(address(0x000000005804B22091aa9830E50459A15E7C9241));
806 
807         _isSniper[address(0xA3b0e79935815730d942A444A84d4Bd14A339553)] = true;
808         _confirmedSnipers.push(address(0xA3b0e79935815730d942A444A84d4Bd14A339553));
809 
810         _isSniper[address(0xf6da21E95D74767009acCB145b96897aC3630BaD)] = true;
811         _confirmedSnipers.push(address(0xf6da21E95D74767009acCB145b96897aC3630BaD));
812 
813         _isSniper[address(0x0000000000007673393729D5618DC555FD13f9aA)] = true;
814         _confirmedSnipers.push(address(0x0000000000007673393729D5618DC555FD13f9aA));
815 
816         _isSniper[address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1)] = true;
817         _confirmedSnipers.push(address(0x00000000000003441d59DdE9A90BFfb1CD3fABf1));
818 
819         _isSniper[address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6)] = true;
820         _confirmedSnipers.push(address(0x59903993Ae67Bf48F10832E9BE28935FEE04d6F6));
821 
822         _isSniper[address(0x000000917de6037d52b1F0a306eeCD208405f7cd)] = true;
823         _confirmedSnipers.push(address(0x000000917de6037d52b1F0a306eeCD208405f7cd));
824 
825         _isSniper[address(0x7100e690554B1c2FD01E8648db88bE235C1E6514)] = true;
826         _confirmedSnipers.push(address(0x7100e690554B1c2FD01E8648db88bE235C1E6514));
827 
828         _isSniper[address(0x72b30cDc1583224381132D379A052A6B10725415)] = true;
829         _confirmedSnipers.push(address(0x72b30cDc1583224381132D379A052A6B10725415));
830 
831         _isSniper[address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE)] = true;
832         _confirmedSnipers.push(address(0x9eDD647D7d6Eceae6bB61D7785Ef66c5055A9bEE));
833 
834         _isSniper[address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F)] = true;
835         _confirmedSnipers.push(address(0xfe9d99ef02E905127239E85A611c29ad32c31c2F));
836 
837         _isSniper[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
838         _confirmedSnipers.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
839 
840         _isSniper[address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9)] = true;
841         _confirmedSnipers.push(address(0xc496D84215d5018f6F53E7F6f12E45c9b5e8e8A9));
842 
843         _isSniper[address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7)] = true;
844         _confirmedSnipers.push(address(0x59341Bc6b4f3Ace878574b05914f43309dd678c7));
845 
846         _isSniper[address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF)] = true;
847         _confirmedSnipers.push(address(0xe986d48EfeE9ec1B8F66CD0b0aE8e3D18F091bDF));
848 
849         _isSniper[address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290)] = true;
850         _confirmedSnipers.push(address(0x4aEB32e16DcaC00B092596ADc6CD4955EfdEE290));
851 
852         _isSniper[address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5)] = true;
853         _confirmedSnipers.push(address(0x136F4B5b6A306091b280E3F251fa0E21b1280Cd5));
854 
855         _isSniper[address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b)] = true;
856         _confirmedSnipers.push(address(0x39608b6f20704889C51C0Ae28b1FCA8F36A5239b));
857 
858         _isSniper[address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7)] = true;
859         _confirmedSnipers.push(address(0x5B83A351500B631cc2a20a665ee17f0dC66e3dB7));
860 
861         _isSniper[address(0xbCb05a3F85d34f0194C70d5914d5C4E28f11Cc02)] = true;
862         _confirmedSnipers.push(address(0xbCb05a3F85d34f0194C70d5914d5C4E28f11Cc02));
863 
864         _isSniper[address(0x22246F9BCa9921Bfa9A3f8df5baBc5Bc8ee73850)] = true;
865         _confirmedSnipers.push(address(0x22246F9BCa9921Bfa9A3f8df5baBc5Bc8ee73850));
866 
867         _isSniper[address(0x42d4C197036BD9984cA652303e07dD29fA6bdB37)] = true;
868         _confirmedSnipers.push(address(0x42d4C197036BD9984cA652303e07dD29fA6bdB37));
869 
870         _isSniper[address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40)] = true;
871         _confirmedSnipers.push(address(0x00000000003b3cc22aF3aE1EAc0440BcEe416B40));
872 
873         _isSniper[address(0x231DC6af3C66741f6Cf618884B953DF0e83C1A2A)] = true;
874         _confirmedSnipers.push(address(0x231DC6af3C66741f6Cf618884B953DF0e83C1A2A));
875 
876         _isSniper[address(0xC6bF34596f74eb22e066a878848DfB9fC1CF4C65)] = true;
877         _confirmedSnipers.push(address(0xC6bF34596f74eb22e066a878848DfB9fC1CF4C65));
878 
879         _isSniper[address(0x20f6fCd6B8813c4f98c0fFbD88C87c0255040Aa3)] = true;
880         _confirmedSnipers.push(address(0x20f6fCd6B8813c4f98c0fFbD88C87c0255040Aa3));
881 
882         _isSniper[address(0xD334C5392eD4863C81576422B968C6FB90EE9f79)] = true;
883         _confirmedSnipers.push(address(0xD334C5392eD4863C81576422B968C6FB90EE9f79));
884 
885         _isSniper[address(0xFFFFF6E70842330948Ca47254F2bE673B1cb0dB7)] = true;
886         _confirmedSnipers.push(address(0xFFFFF6E70842330948Ca47254F2bE673B1cb0dB7));
887 
888         _isSniper[address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a)] = true;
889         _confirmedSnipers.push(address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a));
890 
891         _isSniper[address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a)] = true;
892         _confirmedSnipers.push(address(0xA39C50bf86e15391180240938F469a7bF4fDAe9a));
893         
894     }
895 
896     function name() public view returns (string memory) {
897         return _name;
898     }
899 
900     function symbol() public view returns (string memory) {
901         return _symbol;
902     }
903 
904     function decimals() public view returns (uint8) {
905         return _decimals;
906     }
907 
908     function totalSupply() public view override returns (uint256) {
909         return _tTotal;
910     }
911 
912     function balanceOf(address account) public view override returns (uint256) {
913         if (_isExcluded[account]) return _tOwned[account];
914         return tokenFromReflection(_rOwned[account]);
915     }
916 
917     function transfer(address recipient, uint256 amount) public override returns (bool) {
918         _transfer(_msgSender(), recipient, amount);
919         return true;
920     }
921 
922     function allowance(address owner, address spender) public view override returns (uint256) {
923         return _allowances[owner][spender];
924     }
925 
926     function approve(address spender, uint256 amount) public override returns (bool) {
927         _approve(_msgSender(), spender, amount);
928         return true;
929     }
930 
931     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
932         _transfer(sender, recipient, amount);
933         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
934         return true;
935     }
936 
937     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
938         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
939         return true;
940     }
941 
942     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
943         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
944         return true;
945     }
946 
947     function isExcluded(address account) public view returns (bool) {
948         return _isExcluded[account];
949     }
950 
951     function setExcludeFromFee(address account, bool excluded) external onlyOwnerOrReflectionRemoverForCEX() {
952         _isExcludedFromFee[account] = excluded;
953     }
954 
955     function totalFees() public view returns (uint256) {
956         return _tFeeTotal;
957     }
958 
959     function deliver(uint256 tAmount) public {
960         address sender = _msgSender();
961         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
962         (uint256 rAmount,,,,,) = _getValues(tAmount);
963         _rOwned[sender] = _rOwned[sender].sub(rAmount);
964         _rTotal = _rTotal.sub(rAmount);
965         _tFeeTotal = _tFeeTotal.add(tAmount);
966     }
967 
968     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
969         require(tAmount <= _tTotal, "Amount must be less than supply");
970         if (!deductTransferFee) {
971             (uint256 rAmount,,,,,) = _getValues(tAmount);
972             return rAmount;
973         } else {
974             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
975             return rTransferAmount;
976         }
977     }
978 
979     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
980         require(rAmount <= _rTotal, "Amount must be less than total reflections");
981         uint256 currentRate =  _getRate();
982         return rAmount.div(currentRate);
983     }
984     
985     function isRemovedSniper(address account) public view returns (bool) {
986         return _isSniper[account];
987     }
988 
989     //function to disable redistribution for addresses
990     function disableRedistributionForAccount(address account) external onlyOwnerOrReflectionRemoverForCEX() {
991         require(!_isExcluded[account], "Account is already excluded");
992         if(_rOwned[account] > 0) {
993             _tOwned[account] = tokenFromReflection(_rOwned[account]);
994         }
995         _isExcluded[account] = true;
996         _excluded.push(account);
997     }
998 
999     //function to enable redistribution for addresses
1000     function enableRedistributionForAccount(address account) external onlyOwnerOrReflectionRemoverForCEX() {
1001         require(_isExcluded[account], "Account is already excluded");
1002         for (uint256 i = 0; i < _excluded.length; i++) {
1003             if (_excluded[i] == account) {
1004                 _excluded[i] = _excluded[_excluded.length - 1];
1005                 _tOwned[account] = 0;
1006                 _isExcluded[account] = false;
1007                 _excluded.pop();
1008                 break;
1009             }
1010         }
1011     }
1012     
1013     function openTrading() external onlyOwner() {
1014         _buybackPlusTeamAndMarketingEnabled = true;
1015         _launchTime = block.timestamp;
1016         _tradingOpen = true;
1017     }
1018 
1019     function removeAllFees() private {
1020         if (_redistributionFee == 0 && _buybackPlusTeamAndMarketingFee == 0) return;
1021         _redistributionFee = 0;
1022         _buybackPlusTeamAndMarketingFee = 0;
1023     }
1024 
1025     function restoreAllFees() private {
1026         _redistributionFee = 5;
1027         _buybackPlusTeamAndMarketingFee = 10;
1028     }
1029 
1030     function isExcludedFromFee(address account) public view returns(bool) {
1031         return _isExcludedFromFee[account];
1032     }
1033 
1034     function _approve(address owner, address spender, uint256 amount) private {
1035         require(owner != address(0), "ERC20: approve from the zero address");
1036         require(spender != address(0), "ERC20: approve to the zero address");
1037 
1038         _allowances[owner][spender] = amount;
1039         emit Approval(owner, spender, amount);
1040     }
1041 
1042     function _transfer(address sender, address recipient, uint256 amount) private {
1043         require(sender != address(0), "ERC20: transfer from the zero address");
1044         require(recipient != address(0), "ERC20: transfer to the zero address");
1045         require(amount > 0, "Transfer amount must be greater than zero");
1046         require(!_isSniper[recipient], "You shall not pass!");
1047         require(!_isSniper[msg.sender], "You shall not pass!");
1048 
1049         if(sender != owner() && recipient != owner()) {
1050             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
1051             
1052             if (!_tradingOpen) {
1053                 if (!(sender == address(this) || recipient == address(this)
1054                 || sender == address(owner()) || recipient == address(owner()))) {
1055                     require(_tradingOpen, "Trading is not enabled");
1056                 }
1057             }
1058 
1059             if (block.timestamp < _launchTime + 15 seconds) {
1060                 if (sender != _uniswapV2Pair
1061                 && sender != address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D)
1062                     && sender != address(_uniswapV2Router)) {
1063                     _isSniper[sender] = true;
1064                     _confirmedSnipers.push(sender);
1065                 }
1066             }
1067         }
1068         
1069         if (sender == _uniswapV2Pair && recipient != address(_uniswapV2Router) && !_isExcludedFromFee[recipient]) { //a buy
1070             _redistributionFee = 3;
1071             _buybackPlusTeamAndMarketingFee = 6; //3:3
1072         }else if (recipient == _uniswapV2Pair && sender != address(_uniswapV2Router) && !_isExcludedFromFee[recipient]) { //a sell
1073             _redistributionFee = 5;
1074             _buybackPlusTeamAndMarketingFee = 10; //5:5
1075         }
1076 
1077         uint256 contractTokenBalance = balanceOf(address(this));
1078         if(contractTokenBalance >= _maxTxAmount)
1079         {
1080             contractTokenBalance = _maxTxAmount;
1081         }
1082         
1083         if (!_inSwap && _buybackPlusTeamAndMarketingEnabled && recipient == _uniswapV2Pair) {
1084             // We need to swap the current tokens to ETH for buyback and team fund
1085             bool overMinTokenBalance = contractTokenBalance >= _minimumTokensBeforeSwap;
1086             if (overMinTokenBalance) {
1087                 contractTokenBalance = _minimumTokensBeforeSwap;
1088                 swapTokensForEth(contractTokenBalance);
1089             }
1090             uint256 contractETHBalance = address(this).balance;
1091             if (contractETHBalance > uint256(1 * 10**18)) {
1092                 transferFundsAndBuybackTokens(contractETHBalance.div(2));
1093             }
1094         }
1095         
1096         //indicates if fee should be deducted from transfer
1097         bool takeFee = true;
1098 
1099         //if any account belongs to _isExcludedFromFee account then remove the fee
1100         if(_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]){
1101             takeFee = false;
1102         }
1103 
1104         //transfer amount, it will handle redistribution, buyback, development and marketing fee
1105         _tokenTransfer(sender,recipient,amount,takeFee);
1106     }
1107 
1108     function swapTokensForEth(uint256 tokenAmount) private lockTheSwap{
1109         // generate the uniswap pair path of token -> weth
1110         address[] memory path = new address[](2);
1111         path[0] = address(this);
1112         path[1] = _uniswapV2Router.WETH();
1113 
1114         _approve(address(this), address(_uniswapV2Router), tokenAmount);
1115 
1116         // make the swap
1117         _uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1118             tokenAmount,
1119             0, // accept any amount of ETH
1120             path,
1121             address(this),
1122             block.timestamp
1123         );
1124     }
1125     
1126     function buybackAndBurnTokens(uint256 amount) private lockTheSwap{
1127         // generate the uniswap pair path of weth -> token
1128         address[] memory path = new address[](2);
1129         path[0] = _uniswapV2Router.WETH();
1130         path[1] = address(this);
1131 
1132         // make the swap
1133         _uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: amount}(
1134             0, // accept any amount of Tokens
1135             path,
1136             deadAddress, // Burn address
1137             block.timestamp.add(300)
1138         );
1139     }
1140 
1141     function transferFundsAndBuybackTokens(uint256 amount) private {
1142         if (amount > 0) {
1143             uint256 transferAmount = amount.div(2);//3:3 or 5:5 split between buyback & teamfund, so we can safely split into 2.
1144             uint256 buyBackAmount = amount.div(2);
1145             _teamAndMarketingAddress.transfer(transferAmount); //transferring to Development Team And Marketing fund
1146             buybackAndBurnTokens(buyBackAmount); //buyback and burn
1147         }
1148     }
1149     
1150     // Just in case _minimumTokensBeforeSwap = 5B becomes too much
1151     function manualSwap() external onlyOwner() {
1152         uint256 contractBalance = balanceOf(address(this));
1153         swapTokensForEth(contractBalance);
1154     }
1155     
1156     // Just in case _minimumTokensBeforeSwap = 5B becomes too much
1157     function manualTransfer() external onlyOwner() {
1158         uint256 contractETHBalance = address(this).balance;
1159         transferFundsAndBuybackTokens(contractETHBalance);
1160     }
1161 
1162     function _tokenTransfer(address sender, address recipient, uint256 amount, bool takeFee) private {
1163         
1164         if(!takeFee)
1165             removeAllFees();
1166 
1167         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1168             _transferFromExcluded(sender, recipient, amount);
1169         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1170             _transferToExcluded(sender, recipient, amount);
1171         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
1172             _transferStandard(sender, recipient, amount);
1173         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1174             _transferBothExcluded(sender, recipient, amount);
1175         } else {
1176             _transferStandard(sender, recipient, amount);
1177         }
1178 
1179         if(!takeFee)
1180             restoreAllFees();
1181     }
1182 
1183     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
1184         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBuyBackAndTeamFees) = _getValues(tAmount);
1185         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1186         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1187         _takeBuybackAndTeamFees(tBuyBackAndTeamFees);
1188         _reflectFee(rFee, tFee);
1189         emit Transfer(sender, recipient, tTransferAmount);
1190     }
1191 
1192     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
1193         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBuyBackAndTeamFees) = _getValues(tAmount);
1194         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1195         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1196         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1197         _takeBuybackAndTeamFees(tBuyBackAndTeamFees);
1198         _reflectFee(rFee, tFee);
1199         emit Transfer(sender, recipient, tTransferAmount);
1200     }
1201 
1202     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
1203         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBuyBackAndTeamFees) = _getValues(tAmount);
1204         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1205         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1206         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1207         _takeBuybackAndTeamFees(tBuyBackAndTeamFees);
1208         _reflectFee(rFee, tFee);
1209         emit Transfer(sender, recipient, tTransferAmount);
1210     }
1211 
1212     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
1213         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBuyBackAndTeamFees) = _getValues(tAmount);
1214         _tOwned[sender] = _tOwned[sender].sub(tAmount);
1215         _rOwned[sender] = _rOwned[sender].sub(rAmount);
1216         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1217         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
1218         _takeBuybackAndTeamFees(tBuyBackAndTeamFees);
1219         _reflectFee(rFee, tFee);
1220         emit Transfer(sender, recipient, tTransferAmount);
1221     }
1222 
1223     function _takeBuybackAndTeamFees(uint256 tFees) private {
1224         uint256 currentRate =  _getRate();
1225         uint256 rFees = tFees.mul(currentRate);
1226         _rOwned[address(this)] = _rOwned[address(this)].add(rFees);
1227         if(_isExcluded[address(this)])
1228             _tOwned[address(this)] = _tOwned[address(this)].add(tFees);
1229     }
1230 
1231     function _reflectFee(uint256 rFee, uint256 tFee) private {
1232         _rTotal = _rTotal.sub(rFee);
1233         _tFeeTotal = _tFeeTotal.add(tFee);
1234     }
1235 
1236      //to recieve ETH from uniswapV2Router when swaping
1237     receive() external payable {}
1238 
1239     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
1240         
1241         (uint256 tTransferAmount, uint256 tFee, uint256 tBuyBackAndTeamFees) = _getTValues(tAmount, _redistributionFee, _buybackPlusTeamAndMarketingFee);
1242         uint256 currentRate =  _getRate();
1243         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
1244         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBuyBackAndTeamFees);
1245     }
1246 
1247     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 buyBackAndTeamFees) private pure returns (uint256, uint256, uint256) {
1248         uint256 tFee = tAmount.mul(taxFee).div(100);
1249         uint256 tBuyBackAndTeamFees = tAmount.mul(buyBackAndTeamFees).div(100);
1250         uint256 tTransferAmount = tAmount.sub(tFee).sub(tBuyBackAndTeamFees);
1251         return (tTransferAmount, tFee, tBuyBackAndTeamFees);
1252     }
1253 
1254     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
1255         uint256 rAmount = tAmount.mul(currentRate);
1256         uint256 rFee = tFee.mul(currentRate);
1257         uint256 rTransferAmount = rAmount.sub(rFee);
1258         return (rAmount, rTransferAmount, rFee);
1259     }
1260 
1261     function _getRate() private view returns(uint256) {
1262         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1263         return rSupply.div(tSupply);
1264     }
1265 
1266     function _getCurrentSupply() private view returns(uint256, uint256) {
1267         uint256 rSupply = _rTotal;
1268         uint256 tSupply = _tTotal;
1269         for (uint256 i = 0; i < _excluded.length; i++) {
1270             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
1271             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
1272             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
1273         }
1274         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
1275         return (rSupply, tSupply);
1276     }
1277 
1278     function _getETHBalance() public view returns(uint256 balance) {
1279         return address(this).balance;
1280     }
1281 
1282     function _setTeamAndMarketingAddress(address payable teamAndMarketingAddress) external onlyOwner() {
1283         _teamAndMarketingAddress = teamAndMarketingAddress;
1284     }
1285 
1286     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
1287         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
1288             10**2
1289         );
1290     }
1291     
1292     function _removeSniper(address account) external onlyOwner() {
1293         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not blacklist Uniswap');
1294         require(!_isSniper[account], "Account is already blacklisted");
1295         _isSniper[account] = true;
1296         _confirmedSnipers.push(account);
1297     }
1298 
1299     function _amnestySniper(address account) external onlyOwner() {
1300         require(_isSniper[account], "Account is not blacklisted");
1301         for (uint256 i = 0; i < _confirmedSnipers.length; i++) {
1302             if (_confirmedSnipers[i] == account) {
1303                 _confirmedSnipers[i] = _confirmedSnipers[_confirmedSnipers.length - 1];
1304                 _isSniper[account] = false;
1305                 _confirmedSnipers.pop();
1306                 break;
1307             }
1308         }
1309     }
1310     
1311     function _removeTxLimit() external onlyOwner() {
1312         _maxTxAmount = 100000000000000000000000;
1313     }
1314 }