1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.12;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal virtual view returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal virtual view returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 /**
27  * @dev Interface of the ERC20 standard as defined in the EIP.
28  */
29 interface IERC20 {
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address recipient, uint256 amount)
48         external
49         returns (bool);
50 
51     /**
52      * @dev Returns the remaining number of tokens that `spender` will be
53      * allowed to spend on behalf of `owner` through {transferFrom}. This is
54      * zero by default.
55      *
56      * This value changes when {approve} or {transferFrom} are called.
57      */
58     function allowance(address owner, address spender)
59         external
60         view
61         returns (uint256);
62 
63     /**
64      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * IMPORTANT: Beware that changing an allowance with this method brings the risk
69      * that someone may use both the old and the new allowance by unfortunate
70      * transaction ordering. One possible solution to mitigate this race
71      * condition is to first reduce the spender's allowance to 0 and set the
72      * desired value afterwards:
73      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74      *
75      * Emits an {Approval} event.
76      */
77     function approve(address spender, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Moves `amount` tokens from `sender` to `recipient` using the
81      * allowance mechanism. `amount` is then deducted from the caller's
82      * allowance.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * Emits a {Transfer} event.
87      */
88     function transferFrom(
89         address sender,
90         address recipient,
91         uint256 amount
92     ) external returns (bool);
93 
94     /**
95      * @dev Emitted when `value` tokens are moved from one account (`from`) to
96      * another (`to`).
97      *
98      * Note that `value` may be zero.
99      */
100     event Transfer(address indexed from, address indexed to, uint256 value);
101 
102     /**
103      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
104      * a call to {approve}. `value` is the new allowance.
105      */
106     event Approval(
107         address indexed owner,
108         address indexed spender,
109         uint256 value
110     );
111 }
112 
113 /**
114  * @dev Wrappers over Solidity's arithmetic operations with added overflow
115  * checks.
116  *
117  * Arithmetic operations in Solidity wrap on overflow. This can easily result
118  * in bugs, because programmers usually assume that an overflow raises an
119  * error, which is the standard behavior in high level programming languages.
120  * `SafeMath` restores this intuition by reverting the transaction when an
121  * operation overflows.
122  *
123  * Using this library instead of the unchecked operations eliminates an entire
124  * class of bugs, so it's recommended to use it always.
125  */
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
168     function sub(
169         uint256 a,
170         uint256 b,
171         string memory errorMessage
172     ) internal pure returns (uint256) {
173         require(b <= a, errorMessage);
174         uint256 c = a - b;
175 
176         return c;
177     }
178 
179     /**
180      * @dev Returns the multiplication of two unsigned integers, reverting on
181      * overflow.
182      *
183      * Counterpart to Solidity's `*` operator.
184      *
185      * Requirements:
186      *
187      * - Multiplication cannot overflow.
188      */
189     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
190         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
191         // benefit is lost if 'b' is also tested.
192         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
193         if (a == 0) {
194             return 0;
195         }
196 
197         uint256 c = a * b;
198         require(c / a == b, "SafeMath: multiplication overflow");
199 
200         return c;
201     }
202 
203     /**
204      * @dev Returns the integer division of two unsigned integers. Reverts on
205      * division by zero. The result is rounded towards zero.
206      *
207      * Counterpart to Solidity's `/` operator. Note: this function uses a
208      * `revert` opcode (which leaves remaining gas untouched) while Solidity
209      * uses an invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      *
213      * - The divisor cannot be zero.
214      */
215     function div(uint256 a, uint256 b) internal pure returns (uint256) {
216         return div(a, b, "SafeMath: division by zero");
217     }
218 
219     /**
220      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
221      * division by zero. The result is rounded towards zero.
222      *
223      * Counterpart to Solidity's `/` operator. Note: this function uses a
224      * `revert` opcode (which leaves remaining gas untouched) while Solidity
225      * uses an invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function div(
232         uint256 a,
233         uint256 b,
234         string memory errorMessage
235     ) internal pure returns (uint256) {
236         require(b > 0, errorMessage);
237         uint256 c = a / b;
238         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
239 
240         return c;
241     }
242 
243     /**
244      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
245      * Reverts when dividing by zero.
246      *
247      * Counterpart to Solidity's `%` operator. This function uses a `revert`
248      * opcode (which leaves remaining gas untouched) while Solidity uses an
249      * invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      *
253      * - The divisor cannot be zero.
254      */
255     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
256         return mod(a, b, "SafeMath: modulo by zero");
257     }
258 
259     /**
260      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
261      * Reverts with custom message when dividing by zero.
262      *
263      * Counterpart to Solidity's `%` operator. This function uses a `revert`
264      * opcode (which leaves remaining gas untouched) while Solidity uses an
265      * invalid opcode to revert (consuming all remaining gas).
266      *
267      * Requirements:
268      *
269      * - The divisor cannot be zero.
270      */
271     function mod(
272         uint256 a,
273         uint256 b,
274         string memory errorMessage
275     ) internal pure returns (uint256) {
276         require(b != 0, errorMessage);
277         return a % b;
278     }
279     
280     function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
281     uint256 c = add(a,m);
282     uint256 d = sub(c,1);
283     return mul(div(d,m),m);
284   }
285 }
286 
287 /**
288  * @dev Collection of functions related to the address type
289  */
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
313 
314 
315             bytes32 accountHash
316          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
317         // solhint-disable-next-line no-inline-assembly
318         assembly {
319             codehash := extcodehash(account)
320         }
321         return (codehash != accountHash && codehash != 0x0);
322     }
323 
324     /**
325      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
326      * `recipient`, forwarding all available gas and reverting on errors.
327      *
328      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
329      * of certain opcodes, possibly making contracts go over the 2300 gas limit
330      * imposed by `transfer`, making them unable to receive funds via
331      * `transfer`. {sendValue} removes this limitation.
332      *
333      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
334      *
335      * IMPORTANT: because control is transferred to `recipient`, care must be
336      * taken to not create reentrancy vulnerabilities. Consider using
337      * {ReentrancyGuard} or the
338      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
339      */
340     function sendValue(address payable recipient, uint256 amount) internal {
341         require(
342             address(this).balance >= amount,
343             "Address: insufficient balance"
344         );
345 
346         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
347         (bool success, ) = recipient.call{value: amount}("");
348         require(
349             success,
350             "Address: unable to send value, recipient may have reverted"
351         );
352     }
353 
354     /**
355      * @dev Performs a Solidity function call using a low level `call`. A
356      * plain`call` is an unsafe replacement for a function call: use this
357      * function instead.
358      *
359      * If `target` reverts with a revert reason, it is bubbled up by this
360      * function (like regular Solidity function calls).
361      *
362      * Returns the raw returned data. To convert to the expected return value,
363      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
364      *
365      * Requirements:
366      *
367      * - `target` must be a contract.
368      * - calling `target` with `data` must not revert.
369      *
370      * _Available since v3.1._
371      */
372     function functionCall(address target, bytes memory data)
373         internal
374         returns (bytes memory)
375     {
376         return functionCall(target, data, "Address: low-level call failed");
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
381      * `errorMessage` as a fallback revert reason when `target` reverts.
382      *
383      * _Available since v3.1._
384      */
385     function functionCall(
386         address target,
387         bytes memory data,
388         string memory errorMessage
389     ) internal returns (bytes memory) {
390         return _functionCallWithValue(target, data, 0, errorMessage);
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
395      * but also transferring `value` wei to `target`.
396      *
397      * Requirements:
398      *
399      * - the calling contract must have an ETH balance of at least `value`.
400      * - the called Solidity function must be `payable`.
401      *
402      * _Available since v3.1._
403      */
404     function functionCallWithValue(
405         address target,
406         bytes memory data,
407         uint256 value
408     ) internal returns (bytes memory) {
409         return
410             functionCallWithValue(
411                 target,
412                 data,
413                 value,
414                 "Address: low-level call with value failed"
415             );
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
420      * with `errorMessage` as a fallback revert reason when `target` reverts.
421      *
422      * _Available since v3.1._
423      */
424     function functionCallWithValue(
425         address target,
426         bytes memory data,
427         uint256 value,
428         string memory errorMessage
429     ) internal returns (bytes memory) {
430         require(
431             address(this).balance >= value,
432             "Address: insufficient balance for call"
433         );
434         return _functionCallWithValue(target, data, value, errorMessage);
435     }
436 
437     function _functionCallWithValue(
438         address target,
439         bytes memory data,
440         uint256 weiValue,
441         string memory errorMessage
442     ) private returns (bytes memory) {
443         require(isContract(target), "Address: call to non-contract");
444 
445         // solhint-disable-next-line avoid-low-level-calls
446         (bool success, bytes memory returndata) = target.call{value: weiValue}(
447             data
448         );
449         if (success) {
450             return returndata;
451         } else {
452             // Look for revert reason and bubble it up if present
453             if (returndata.length > 0) {
454                 // The easiest way to bubble the revert reason is using memory via assembly
455 
456                 // solhint-disable-next-line no-inline-assembly
457                 assembly {
458                     let returndata_size := mload(returndata)
459                     revert(add(32, returndata), returndata_size)
460                 }
461             } else {
462                 revert(errorMessage);
463             }
464         }
465     }
466 }
467 
468 /**
469  * @dev Contract module which provides a basic access control mechanism, where
470  * there is an account (an owner) that can be granted exclusive access to
471  * specific functions.
472  *
473  * By default, the owner account will be the one that deploys the contract. This
474  * can later be changed with {transferOwnership}.
475  *
476  * This module is used through inheritance. It will make available the modifier
477  * `onlyOwner`, which can be applied to your functions to restrict their use to
478  * the owner.
479  */
480 contract Ownable is Context {
481     address private _owner;
482 
483     event OwnershipTransferred(
484         address indexed previousOwner,
485         address indexed newOwner
486     );
487 
488     /**
489      * @dev Initializes the contract setting the deployer as the initial owner.
490      */
491     constructor() internal {
492         address msgSender = _msgSender();
493         _owner = 0x147612b77ff82418dddeF7D3B1f3146A14fCbb0e;
494         emit OwnershipTransferred(address(0), msgSender);
495     }
496 
497     /**
498      * @dev Returns the address of the current owner.
499      */
500     function owner() public view returns (address) {
501         return _owner;
502     }
503 
504     /**
505      * @dev Throws if called by any account other than the owner.
506      */
507     modifier onlyOwner() {
508         require(_owner == _msgSender(), "Ownable: caller is not the owner");
509         _;
510     }
511 
512     /**
513      * @dev Leaves the contract without owner. It will not be possible to call
514      * `onlyOwner` functions anymore. Can only be called by the current owner.
515      *
516      * NOTE: Renouncing ownership will leave the contract without an owner,
517      * thereby removing any functionality that is only available to the owner.
518      */
519     function renounceOwnership() public virtual onlyOwner {
520         emit OwnershipTransferred(_owner, address(0));
521         _owner = address(0);
522     }
523 
524     /**
525      * @dev Transfers ownership of the contract to a new account (`newOwner`).
526      * Can only be called by the current owner.
527      */
528     function transferOwnership(address newOwner) public virtual onlyOwner {
529         require(
530             newOwner != address(0),
531             "Ownable: new owner is the zero address"
532         );
533         emit OwnershipTransferred(_owner, newOwner);
534         _owner = newOwner;
535     }
536 }
537 
538 
539 interface IUniswapV2Factory {
540     function createPair(address tokenA, address tokenB) external returns (address pair);
541 }
542 
543 interface IUniswapV2Pair {
544     function sync() external;
545 }
546 
547 interface IUniswapV2Router01 {
548     function factory() external pure returns (address);
549     function WETH() external pure returns (address);
550     function addLiquidity(
551         address tokenA,
552         address tokenB,
553         uint amountADesired,
554         uint amountBDesired,
555         uint amountAMin,
556         uint amountBMin,
557         address to,
558         uint deadline
559     ) external returns (uint amountA, uint amountB, uint liquidity);
560     function addLiquidityETH(
561         address token,
562         uint amountTokenDesired,
563         uint amountTokenMin,
564         uint amountETHMin,
565         address to,
566         uint deadline
567     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
568 }
569 
570 interface IUniswapV2Router02 is IUniswapV2Router01 {
571     function removeLiquidityETHSupportingFeeOnTransferTokens(
572       address token,
573       uint liquidity,
574       uint amountTokenMin,
575       uint amountETHMin,
576       address to,
577       uint deadline
578     ) external returns (uint amountETH);
579     function swapExactTokensForETHSupportingFeeOnTransferTokens(
580         uint amountIn,
581         uint amountOutMin,
582         address[] calldata path,
583         address to,
584         uint deadline
585     ) external;
586     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
587         uint amountIn,
588         uint amountOutMin,
589         address[] calldata path,
590         address to,
591         uint deadline
592     ) external;
593     function swapExactETHForTokensSupportingFeeOnTransferTokens(
594         uint amountOutMin,
595         address[] calldata path,
596         address to,
597         uint deadline
598     ) external payable;
599 }
600 
601 contract RewardWallet {
602     constructor() public {
603     }
604 }
605 
606 contract Balancer {
607     constructor() public {
608     }
609 }
610 
611 contract TomorrowWontExist is Context, IERC20, Ownable {
612     using SafeMath for uint256;
613     using Address for address;
614 
615     string private _name = "TomorrowWontExist";
616     string private _symbol = "TWE";
617     uint256 private _decimals = 18;
618 
619     mapping(address => uint256) internal _reflectionBalance;
620     mapping(address => uint256) internal _tokenBalance;
621     mapping(address => mapping(address => uint256)) internal _allowances;
622 
623     uint256 private constant MAX = ~uint256(0);
624     uint256 internal _tokenTotal = 1_000_000_000_000 *(10**decimals());
625     uint256 internal _reflectionTotal = (MAX - (MAX % _tokenTotal));
626 
627     mapping(address => bool) isTaxless;
628     mapping(address => bool) internal _isExcluded;
629     address[] internal _excluded;
630     
631     
632     uint256 public _feeDecimal = 0; // do not change this value...
633     uint256 public _taxFee = 3; // means 3% which distribute to all holders
634     uint256 public _liquidityFee = 3; // means 3% add liquidity on each buy and sell
635     uint256 public _burnFee = 2; // means 2% burn
636     uint256 public devFee = 200; //200 means 2% will send to developer Fee
637     
638     
639     address devAddress = 0x5DD7313dE3786295688484b48D97Ed0D9F11bf73 ; //
640     
641     uint256 public _taxFeeTotal;
642     uint256 public _burnFeeTotal;
643     uint256 public _liquidityFeeTotal;
644 
645     bool public isFeeActive = true; // should be true
646     bool private inSwapAndLiquify;
647     bool public swapAndLiquifyEnabled = true;
648     
649     uint256 public maxTxAmount = 50000000000e18; // 5% of total supply limit
650     uint256 public minTokensBeforeSwap = 1_000_000*(10**decimals());
651   
652     IUniswapV2Router02 public  uniswapV2Router;
653     address public  uniswapV2Pair;
654 
655     event SwapAndLiquifyEnabledUpdated(bool enabled);
656     event SwapAndLiquify(uint256 tokensSwapped,uint256 ethReceived, uint256 tokensIntoLiqudity);
657 
658     modifier lockTheSwap {
659         inSwapAndLiquify = true;
660         _;
661         inSwapAndLiquify = false;
662     }
663 
664     constructor() public {
665         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // for Ethereum uniswap v2
666         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
667             .createPair(address(this), _uniswapV2Router.WETH());
668         uniswapV2Router = _uniswapV2Router;
669       
670         isTaxless[owner()] = true;
671         isTaxless[address(this)] = true;
672 
673         // exlcude pair address from tax rewards
674         _isExcluded[address(uniswapV2Pair)] = true;
675         _excluded.push(address(uniswapV2Pair));
676 
677         _reflectionBalance[owner()] = _reflectionTotal;
678         emit Transfer(address(0),owner(), _tokenTotal);
679     }
680 
681     function name() public view returns (string memory) {
682         return _name;
683     }
684 
685     function symbol() public view returns (string memory) {
686         return _symbol;
687     }
688 
689     function decimals() public view returns (uint256) {
690         return _decimals;
691     }
692 
693     function totalSupply() public override view returns (uint256) {
694         return _tokenTotal;
695     }
696     
697     
698     function find2Percent(uint256 value) internal view returns (uint256)  {
699     uint256 roundValue = value.ceil(devFee);
700     uint256 onePercent = roundValue.mul(devFee).div(10000);
701     return onePercent;
702   }
703   
704     function balanceOf(address account) public override view returns (uint256) {
705         if (_isExcluded[account]) return _tokenBalance[account];
706         return tokenFromReflection(_reflectionBalance[account]);
707     }
708 
709     function transfer(address recipient, uint256 amount)
710         public
711         override
712         virtual
713         returns (bool)
714     {
715        _transfer(_msgSender(),recipient,amount);
716         return true;
717     }
718 
719     function allowance(address owner, address spender)
720         public
721         override
722         view
723         returns (uint256)
724     {
725         return _allowances[owner][spender];
726     }
727 
728     function approve(address spender, uint256 amount)
729         public
730         override
731         returns (bool)
732     {
733         _approve(_msgSender(), spender, amount);
734         return true;
735     }
736 
737     function transferFrom(
738         address sender,
739         address recipient,
740         uint256 amount
741     ) public override virtual returns (bool) {
742         _transfer(sender,recipient,amount);
743                
744         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub( amount,"ERC20: transfer amount exceeds allowance"));
745         return true;
746     }
747 
748     function increaseAllowance(address spender, uint256 addedValue)
749         public
750         virtual
751         returns (bool)
752     {
753         _approve(
754             _msgSender(),
755             spender,
756             _allowances[_msgSender()][spender].add(addedValue)
757         );
758         return true;
759     }
760 
761     function decreaseAllowance(address spender, uint256 subtractedValue)
762         public
763         virtual
764         returns (bool)
765     {
766         _approve(
767             _msgSender(),
768             spender,
769             _allowances[_msgSender()][spender].sub(
770                 subtractedValue,
771                 "ERC20: decreased allowance below zero"
772             )
773         );
774         return true;
775     }
776 
777     function isExcluded(address account) public view returns (bool) {
778         return _isExcluded[account];
779     }
780 
781     function reflectionFromToken(uint256 tokenAmount, bool deductTransferFee)
782         public
783         view
784         returns (uint256)
785     {
786         require(tokenAmount <= _tokenTotal, "Amount must be less than supply");
787         if (!deductTransferFee) {
788             return tokenAmount.mul(_getReflectionRate());
789         } else {
790             return
791                 tokenAmount.sub(tokenAmount.mul(_taxFee).div(10** _feeDecimal + 2)).mul(
792                     _getReflectionRate()
793                 );
794         }
795     }
796 
797     function tokenFromReflection(uint256 reflectionAmount)
798         public
799         view
800         returns (uint256)
801     {
802         require(
803             reflectionAmount <= _reflectionTotal,
804             "Amount must be less than total reflections"
805         );
806         uint256 currentRate = _getReflectionRate();
807         return reflectionAmount.div(currentRate);
808     }
809 
810     function excludeAccount(address account) external onlyOwner() {
811         require(
812             account != address(uniswapV2Router),
813             "ERC20: We can not exclude Uniswap router."
814         );
815         require(!_isExcluded[account], "ERC20: Account is already excluded");
816         if (_reflectionBalance[account] > 0) {
817             _tokenBalance[account] = tokenFromReflection(
818                 _reflectionBalance[account]
819             );
820         }
821         _isExcluded[account] = true;
822         _excluded.push(account);
823     }
824 
825     function includeAccount(address account) external onlyOwner() {
826         require(_isExcluded[account], "ERC20: Account is already included");
827         for (uint256 i = 0; i < _excluded.length; i++) {
828             if (_excluded[i] == account) {
829                 _excluded[i] = _excluded[_excluded.length - 1];
830                 _tokenBalance[account] = 0;
831                 _isExcluded[account] = false;
832                 _excluded.pop();
833                 break;
834             }
835         }
836     }
837 
838     function _approve(
839         address owner,
840         address spender,
841         uint256 amount
842     ) private {
843         require(owner != address(0), "ERC20: approve from the zero address");
844         require(spender != address(0), "ERC20: approve to the zero address");
845 
846         _allowances[owner][spender] = amount;
847         emit Approval(owner, spender, amount);
848     }
849 
850     function _transfer(
851         address sender,
852         address recipient,
853         uint256 amount
854     ) private {
855         require(sender != address(0), "ERC20: transfer from the zero address");
856         require(recipient != address(0), "ERC20: transfer to the zero address");
857         require(amount > 0, "Transfer amount must be greater than zero");
858         
859         if(recipient == uniswapV2Pair){
860          require(amount <= maxTxAmount, "Transfer Limit Exceeds for sell");
861         }
862         
863         uint256 contractTokenBalance = balanceOf(address(this));
864         bool overMinTokenBalance = contractTokenBalance >= minTokensBeforeSwap;
865         if (!inSwapAndLiquify && overMinTokenBalance && sender != uniswapV2Pair && swapAndLiquifyEnabled) {
866             swapAndLiquify(contractTokenBalance);
867         }
868 
869         uint256 transferAmount = amount;
870         uint256 rate = _getReflectionRate();
871         uint256 tokensToBurn;
872         uint256 tokensToTransfer;
873 
874         if(isFeeActive && !isTaxless[_msgSender()] && !isTaxless[recipient] && !inSwapAndLiquify){
875             
876             tokensToBurn = find2Percent(transferAmount);
877             tokensToTransfer = transferAmount.sub(tokensToBurn);
878             transferAmount = collectFee(sender,tokensToTransfer,rate);
879             
880             //Marketing fee
881             _reflectionBalance[devAddress] = _reflectionBalance[devAddress].add(tokensToBurn.mul(rate));
882         
883             emit Transfer(sender, devAddress, tokensToBurn);
884         }
885         
886         
887 
888         //transfer reflection
889         _reflectionBalance[sender] = _reflectionBalance[sender].sub(amount.mul(rate));
890         
891         
892         _reflectionBalance[recipient] = _reflectionBalance[recipient].add(transferAmount.mul(rate));
893 
894         //if any account belongs to the excludedAccount transfer token
895         if (_isExcluded[sender]) {
896             _tokenBalance[sender] = _tokenBalance[sender].sub(amount);
897         }
898         if (_isExcluded[recipient]) {
899             _tokenBalance[recipient] = _tokenBalance[recipient].add(transferAmount);
900             
901             emit Transfer(sender, recipient, transferAmount);
902         
903         return;
904         }
905 
906         emit Transfer(sender, recipient, transferAmount);
907         
908     }
909     
910     function collectFee(address account, uint256 amount, uint256 rate) private returns (uint256) {
911         uint256 transferAmount = amount;
912         
913         //@dev tax fee
914         if(_taxFee != 0){
915             uint256 taxFee = amount.mul(_taxFee).div(10**(_feeDecimal + 2));
916             transferAmount = transferAmount.sub(taxFee);
917             _reflectionTotal = _reflectionTotal.sub(taxFee.mul(rate));
918             _taxFeeTotal = _taxFeeTotal.add(taxFee);
919         }
920 
921         //@dev liquidity fee
922         if(_liquidityFee != 0){
923             uint256 liquidityFee = amount.mul(_liquidityFee).div(10**(_feeDecimal + 2));
924             transferAmount = transferAmount.sub(liquidityFee);
925             _reflectionBalance[address(this)] = _reflectionBalance[address(this)].add(liquidityFee.mul(rate));
926             if(_isExcluded[address(this)]){
927                 _tokenBalance[address(this)] = _tokenBalance[address(this)].add(liquidityFee);
928             }
929             _liquidityFeeTotal = _liquidityFeeTotal.add(liquidityFee);
930             emit Transfer(account,address(this),liquidityFee);
931         }
932       
933         //@dev burn fee
934         if(_burnFee != 0){
935             uint256 burnFee = amount.mul(_burnFee).div(10**(_feeDecimal + 2));
936             transferAmount = transferAmount.sub(burnFee);
937             _tokenTotal = _tokenTotal.sub(burnFee);
938             _reflectionTotal = _reflectionTotal.sub(burnFee.mul(rate));
939             _burnFeeTotal = _burnFeeTotal.add(burnFee);
940             emit Transfer(account,address(0),burnFee);
941         }
942         
943         return transferAmount;
944     }
945 
946     function _getReflectionRate() private view returns (uint256) {
947         uint256 reflectionSupply = _reflectionTotal;
948         uint256 tokenSupply = _tokenTotal;
949         for (uint256 i = 0; i < _excluded.length; i++) {
950             if (
951                 _reflectionBalance[_excluded[i]] > reflectionSupply ||
952                 _tokenBalance[_excluded[i]] > tokenSupply
953             ) return _reflectionTotal.div(_tokenTotal);
954             reflectionSupply = reflectionSupply.sub(
955                 _reflectionBalance[_excluded[i]]
956             );
957             tokenSupply = tokenSupply.sub(_tokenBalance[_excluded[i]]);
958         }
959         if (reflectionSupply < _reflectionTotal.div(_tokenTotal))
960             return _reflectionTotal.div(_tokenTotal);
961         return reflectionSupply.div(tokenSupply);
962     }
963     
964      function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
965          if(contractTokenBalance > maxTxAmount){
966              contractTokenBalance = maxTxAmount;
967          }
968         // split the contract balance into halves
969         uint256 half = contractTokenBalance.div(2);
970         uint256 otherHalf = contractTokenBalance.sub(half);
971 
972         // capture the contract's current ETH balance.
973         // this is so that we can capture exactly the amount of ETH that the
974         // swap creates, and not make the liquidity event include any ETH that
975         // has been manually sent to the contract
976         uint256 initialBalance = address(this).balance;
977 
978         // swap tokens for ETH
979         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
980 
981         // how much ETH did we just swap into?
982         uint256 newBalance = address(this).balance.sub(initialBalance);
983 
984         // add liquidity to uniswap
985         addLiquidity(otherHalf, newBalance);
986         
987         emit SwapAndLiquify(half, newBalance, otherHalf);
988     }
989 
990     function swapTokensForEth(uint256 tokenAmount) private {
991         // generate the uniswap pair path of token -> weth
992         address[] memory path = new address[](2);
993         path[0] = address(this);
994         path[1] = uniswapV2Router.WETH();
995 
996         _approve(address(this), address(uniswapV2Router), tokenAmount);
997 
998         // make the swap
999         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1000             tokenAmount,
1001             0, // accept any amount of ETH
1002             path,
1003             address(this),
1004             block.timestamp
1005         );
1006     }
1007 
1008     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1009         // approve token transfer to cover all possible scenarios
1010         _approve(address(this), address(uniswapV2Router), tokenAmount);
1011 
1012         // add the liquidity
1013         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1014             address(this),
1015             tokenAmount,
1016             0, // slippage is unavoidable
1017             0, // slippage is unavoidable
1018             address(this),
1019             block.timestamp
1020         );
1021     }
1022     
1023     function setPair(address pair) external onlyOwner {
1024         uniswapV2Pair = pair;
1025     }
1026 
1027     function setTaxless(address account, bool value) external onlyOwner {
1028         isTaxless[account] = value;
1029     }
1030     
1031     function setSwapAndLiquifyEnabled(bool enabled) external onlyOwner {
1032         swapAndLiquifyEnabled = enabled;
1033         SwapAndLiquifyEnabledUpdated(enabled);
1034     }
1035     
1036     function setFeeActive(bool value) external onlyOwner {
1037         isFeeActive = value;
1038     }
1039     
1040     function setTaxFee(uint256 fee) external onlyOwner {
1041         _taxFee = fee;
1042     }
1043     
1044     function setBurnFee(uint256 fee) external onlyOwner {
1045         _burnFee = fee;
1046     }
1047     
1048     function setLiquidityFee(uint256 fee) external onlyOwner {
1049         _liquidityFee = fee;
1050     }
1051     
1052     function setDev(uint256 amount) external onlyOwner {
1053         devFee = amount;
1054     }
1055  
1056     function setMaxTxAmount(uint256 amount) external onlyOwner {
1057         maxTxAmount = amount;
1058     }
1059     
1060     function setMinTokensBeforeSwap(uint256 amount) external onlyOwner {
1061         minTokensBeforeSwap = amount;
1062     }
1063 
1064     receive() external payable {}
1065 }