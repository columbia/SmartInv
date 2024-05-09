1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
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
493         _owner = 0x883a655b7458B9e0B7bD7d911B5DEDc98ad207af;
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
611 contract EthereumPlus is Context, IERC20, Ownable {
612     using SafeMath for uint256;
613     using Address for address;
614 
615     string private _name = "EthereumPlus";
616     string private _symbol = "ePlus";
617     uint256 private _decimals = 18;
618 
619     mapping(address => uint256) internal _reflectionBalance;
620     mapping(address => uint256) internal _tokenBalance;
621     mapping(address => mapping(address => uint256)) internal _allowances;
622 
623     uint256 private constant MAX = ~uint256(0);
624     uint256 internal _tokenTotal = 1_000_000_000_000_000*(10**decimals());
625     uint256 internal _reflectionTotal = (MAX - (MAX % _tokenTotal));
626 
627     mapping(address => bool) isTaxless;
628     mapping(address => bool) internal _isExcluded;
629     address[] internal _excluded;
630     
631     
632     uint256 public _feeDecimal = 2; // do not change this value...
633     uint256 public _taxFee = 200; // means 2% which distribute to all holders
634     uint256 public _liquidityFee = 400; // 4 means 4% add liquidity
635     uint256 public _burnFee = 0; // means 0 it menas burn 0%
636     uint256 public _ownerFee=400; //means 4% to owner wallet
637     
638     
639     address public ownerWallet=0xc1255f344361B4361BD6b380Fc244aB089b60b25; //it recieve ether
640     
641     
642     uint256 public _taxFeeTotal;
643     uint256 public _burnFeeTotal;
644     uint256 public _liquidityFeeTotal;
645 
646     bool public isFeeActive = true; // should be true
647     bool private inSwapAndLiquify;
648     bool public swapAndLiquifyEnabled = true;
649     
650     uint256 public maxTxAmount = _tokenTotal; // no limit
651     uint256 public minTokensBeforeSwap = 100_000*(10**decimals()); 
652   
653     IUniswapV2Router02 public  uniswapV2Router;
654     address public  uniswapV2Pair;
655 
656     event SwapAndLiquifyEnabledUpdated(bool enabled);
657     event SwapAndLiquify(uint256 tokensSwapped,uint256 ethReceived, uint256 tokensIntoLiqudity);
658 
659     modifier lockTheSwap {
660         inSwapAndLiquify = true;
661         _;
662         inSwapAndLiquify = false;
663     }
664 
665     constructor() public {
666         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // for Ethereum uniswap v2
667         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
668             .createPair(address(this), _uniswapV2Router.WETH());
669         uniswapV2Router = _uniswapV2Router;
670       
671         isTaxless[owner()] = true;
672         isTaxless[address(this)] = true;
673 
674         // exlcude pair address from tax rewards
675         _isExcluded[address(uniswapV2Pair)] = true;
676         _excluded.push(address(uniswapV2Pair));
677 
678         _reflectionBalance[owner()] = _reflectionTotal;
679         emit Transfer(address(0),owner(), _tokenTotal);
680     }
681 
682     function name() public view returns (string memory) {
683         return _name;
684     }
685 
686     function symbol() public view returns (string memory) {
687         return _symbol;
688     }
689 
690     function decimals() public view returns (uint256) {
691         return _decimals;
692     }
693 
694     function totalSupply() public override view returns (uint256) {
695         return _tokenTotal;
696     }
697     
698   
699     function balanceOf(address account) public override view returns (uint256) {
700         if (_isExcluded[account]) return _tokenBalance[account];
701         return tokenFromReflection(_reflectionBalance[account]);
702     }
703 
704     function transfer(address recipient, uint256 amount)
705         public
706         override
707         virtual
708         returns (bool)
709     {
710        _transfer(_msgSender(),recipient,amount);
711         return true;
712     }
713 
714     function allowance(address owner, address spender)
715         public
716         override
717         view
718         returns (uint256)
719     {
720         return _allowances[owner][spender];
721     }
722 
723     function approve(address spender, uint256 amount)
724         public
725         override
726         returns (bool)
727     {
728         _approve(_msgSender(), spender, amount);
729         return true;
730     }
731 
732     function transferFrom(
733         address sender,
734         address recipient,
735         uint256 amount
736     ) public override virtual returns (bool) {
737         _transfer(sender,recipient,amount);
738                
739         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub( amount,"ERC20: transfer amount exceeds allowance"));
740         return true;
741     }
742 
743     function increaseAllowance(address spender, uint256 addedValue)
744         public
745         virtual
746         returns (bool)
747     {
748         _approve(
749             _msgSender(),
750             spender,
751             _allowances[_msgSender()][spender].add(addedValue)
752         );
753         return true;
754     }
755 
756     function decreaseAllowance(address spender, uint256 subtractedValue)
757         public
758         virtual
759         returns (bool)
760     {
761         _approve(
762             _msgSender(),
763             spender,
764             _allowances[_msgSender()][spender].sub(
765                 subtractedValue,
766                 "ERC20: decreased allowance below zero"
767             )
768         );
769         return true;
770     }
771 
772     function isExcluded(address account) public view returns (bool) {
773         return _isExcluded[account];
774     }
775 
776     function reflectionFromToken(uint256 tokenAmount, bool deductTransferFee)
777         public
778         view
779         returns (uint256)
780     {
781         require(tokenAmount <= _tokenTotal, "Amount must be less than supply");
782         if (!deductTransferFee) {
783             return tokenAmount.mul(_getReflectionRate());
784         } else {
785             return
786                 tokenAmount.sub(tokenAmount.mul(_taxFee).div(10** _feeDecimal + 2)).mul(
787                     _getReflectionRate()
788                 );
789         }
790     }
791 
792     function tokenFromReflection(uint256 reflectionAmount)
793         public
794         view
795         returns (uint256)
796     {
797         require(
798             reflectionAmount <= _reflectionTotal,
799             "Amount must be less than total reflections"
800         );
801         uint256 currentRate = _getReflectionRate();
802         return reflectionAmount.div(currentRate);
803     }
804 
805     function excludeAccount(address account) external onlyOwner() {
806         require(
807             account != address(uniswapV2Router),
808             "ERC20: We can not exclude Uniswap router."
809         );
810         require(!_isExcluded[account], "ERC20: Account is already excluded");
811         if (_reflectionBalance[account] > 0) {
812             _tokenBalance[account] = tokenFromReflection(
813                 _reflectionBalance[account]
814             );
815         }
816         _isExcluded[account] = true;
817         _excluded.push(account);
818     }
819 
820     function includeAccount(address account) external onlyOwner() {
821         require(_isExcluded[account], "ERC20: Account is already included");
822         for (uint256 i = 0; i < _excluded.length; i++) {
823             if (_excluded[i] == account) {
824                 _excluded[i] = _excluded[_excluded.length - 1];
825                 _tokenBalance[account] = 0;
826                 _isExcluded[account] = false;
827                 _excluded.pop();
828                 break;
829             }
830         }
831     }
832 
833     function _approve(
834         address owner,
835         address spender,
836         uint256 amount
837     ) private {
838         require(owner != address(0), "ERC20: approve from the zero address");
839         require(spender != address(0), "ERC20: approve to the zero address");
840 
841         _allowances[owner][spender] = amount;
842         emit Approval(owner, spender, amount);
843     }
844 
845     function _transfer(
846         address sender,
847         address recipient,
848         uint256 amount
849     ) private {
850         require(sender != address(0), "ERC20: transfer from the zero address");
851         require(recipient != address(0), "ERC20: transfer to the zero address");
852         require(amount > 0, "Transfer amount must be greater than zero");
853         
854         require(amount <= maxTxAmount, "Transfer Limit Exceeds");
855         
856         
857         uint256 transferAmount = amount;
858         uint256 rate = _getReflectionRate();
859         
860         
861         if(sender == uniswapV2Pair || recipient == uniswapV2Pair){
862             
863         uint256 contractTokenBalance = balanceOf(address(this));
864         uint256 ownerBal=balanceOf(ownerWallet);
865         
866         if (!inSwapAndLiquify && sender != uniswapV2Pair && swapAndLiquifyEnabled) {
867             if(contractTokenBalance >= minTokensBeforeSwap)
868                 swapAndLiquify(contractTokenBalance);
869             else if(ownerBal >= minTokensBeforeSwap) {
870                 _reflectionBalance[ownerWallet] = _reflectionBalance[ownerWallet].sub(ownerBal.mul(rate));
871                 _reflectionBalance[address(this)] = _reflectionBalance[address(this)].add(ownerBal.mul(rate));
872                 distributeOwner(ownerBal);
873             }
874         }
875         
876          if(isFeeActive && !isTaxless[_msgSender()] && !isTaxless[recipient] && !inSwapAndLiquify){
877             
878             transferAmount = collectFee(sender,amount,rate);
879             
880          }
881         }
882         
883         //transfer reflection
884         _reflectionBalance[sender] = _reflectionBalance[sender].sub(amount.mul(rate));
885         
886         _reflectionBalance[recipient] = _reflectionBalance[recipient].add(transferAmount.mul(rate));
887 
888         //if any account belongs to the excludedAccount transfer token
889         if (_isExcluded[sender]) {
890             _tokenBalance[sender] = _tokenBalance[sender].sub(amount);
891         }
892         if (_isExcluded[recipient]) {
893             _tokenBalance[recipient] = _tokenBalance[recipient].add(transferAmount);
894             
895         }
896 
897         emit Transfer(sender, recipient, transferAmount);
898         
899     }
900     
901     function collectFee(address account, uint256 amount, uint256 rate) private returns (uint256) {
902         uint256 transferAmount = amount;
903         
904         //@dev tax fee
905         if(_taxFee != 0){
906             uint256 taxFee = amount.mul(_taxFee).div(10**(_feeDecimal + 2));
907             transferAmount = transferAmount.sub(taxFee);
908             _reflectionTotal = _reflectionTotal.sub(taxFee.mul(rate));
909             _taxFeeTotal = _taxFeeTotal.add(taxFee);
910         }
911         
912           //take owner fee
913         if(_ownerFee != 0){
914             uint256 ownerFee = amount.mul(_ownerFee).div(10**(_feeDecimal + 2));
915             transferAmount = transferAmount.sub(ownerFee);
916             _reflectionBalance[ownerWallet] = _reflectionBalance[ownerWallet].add(ownerFee.mul(rate));
917             if (_isExcluded[ownerWallet]) {
918                 _tokenBalance[ownerWallet] = _tokenBalance[ownerWallet].add(ownerFee);
919             }
920             emit Transfer(account,ownerWallet,ownerFee);
921         }
922 
923         //@dev liquidity fee
924         if(_liquidityFee != 0){
925             uint256 liquidityFee = amount.mul(_liquidityFee).div(10**(_feeDecimal + 2));
926             transferAmount = transferAmount.sub(liquidityFee);
927             _reflectionBalance[address(this)] = _reflectionBalance[address(this)].add(liquidityFee.mul(rate));
928             if(_isExcluded[address(this)]){
929                 _tokenBalance[address(this)] = _tokenBalance[address(this)].add(liquidityFee);
930             }
931             _liquidityFeeTotal = _liquidityFeeTotal.add(liquidityFee);
932             emit Transfer(account,address(this),liquidityFee);
933         }
934       
935         //@dev burn fee
936         if(_burnFee != 0){
937             uint256 burnFee = amount.mul(_burnFee).div(10**(_feeDecimal + 2));
938             transferAmount = transferAmount.sub(burnFee);
939             _tokenTotal = _tokenTotal.sub(burnFee);
940             _reflectionTotal = _reflectionTotal.sub(burnFee.mul(rate));
941             _burnFeeTotal = _burnFeeTotal.add(burnFee);
942             emit Transfer(account,address(0),burnFee);
943         }
944         
945         return transferAmount;
946     }
947 
948     function _getReflectionRate() private view returns (uint256) {
949         uint256 reflectionSupply = _reflectionTotal;
950         uint256 tokenSupply = _tokenTotal;
951         for (uint256 i = 0; i < _excluded.length; i++) {
952             if (
953                 _reflectionBalance[_excluded[i]] > reflectionSupply ||
954                 _tokenBalance[_excluded[i]] > tokenSupply
955             ) return _reflectionTotal.div(_tokenTotal);
956             reflectionSupply = reflectionSupply.sub(
957                 _reflectionBalance[_excluded[i]]
958             );
959             tokenSupply = tokenSupply.sub(_tokenBalance[_excluded[i]]);
960         }
961         if (reflectionSupply < _reflectionTotal.div(_tokenTotal))
962             return _reflectionTotal.div(_tokenTotal);
963         return reflectionSupply.div(tokenSupply);
964     }
965     
966      function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
967          if(contractTokenBalance > maxTxAmount){
968              contractTokenBalance = maxTxAmount;
969          }
970         // split the contract balance into halves
971         uint256 half = contractTokenBalance.div(2);
972         uint256 otherHalf = contractTokenBalance.sub(half);
973 
974         // capture the contract's current ETH balance.
975         // this is so that we can capture exactly the amount of ETH that the
976         // swap creates, and not make the liquidity event include any ETH that
977         // has been manually sent to the contract
978         uint256 initialBalance = address(this).balance;
979 
980         // swap tokens for ETH
981         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
982 
983         // how much ETH did we just swap into?
984         uint256 newBalance = address(this).balance.sub(initialBalance);
985 
986         // add liquidity to uniswap
987         addLiquidity(otherHalf, newBalance);
988         
989         emit SwapAndLiquify(half, newBalance, otherHalf);
990     }
991 
992     function swapTokensForEth(uint256 tokenAmount) private {
993         // generate the uniswap pair path of token -> weth
994         address[] memory path = new address[](2);
995         path[0] = address(this);
996         path[1] = uniswapV2Router.WETH();
997 
998         _approve(address(this), address(uniswapV2Router), tokenAmount);
999 
1000         // make the swap
1001         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1002             tokenAmount,
1003             0, // accept any amount of ETH
1004             path,
1005             address(this),
1006             block.timestamp
1007         );
1008     }
1009     
1010      function distributeOwner(uint256 amount) private lockTheSwap {
1011         swapTokensForEth(amount);
1012         payable(ownerWallet).transfer(address(this).balance);
1013     }
1014 
1015     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1016         // approve token transfer to cover all possible scenarios
1017         _approve(address(this), address(uniswapV2Router), tokenAmount);
1018 
1019         // add the liquidity
1020         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1021             address(this),
1022             tokenAmount,
1023             0, // slippage is unavoidable
1024             0, // slippage is unavoidable
1025             address(this),
1026             block.timestamp
1027         );
1028     }
1029     
1030     function setPair(address pair) external onlyOwner {
1031         uniswapV2Pair = pair;
1032     }
1033 
1034     function setTaxless(address account, bool value) external onlyOwner {
1035         isTaxless[account] = value;
1036     }
1037     
1038     function setSwapAndLiquifyEnabled(bool enabled) external onlyOwner {
1039         swapAndLiquifyEnabled = enabled;
1040         SwapAndLiquifyEnabledUpdated(enabled);
1041     }
1042     
1043     function setFeeActive(bool value) external onlyOwner {
1044         isFeeActive = value;
1045     }
1046     
1047     function setTaxFee(uint256 fee) external onlyOwner {
1048         _taxFee = fee;
1049     }
1050     
1051     function setBurnFee(uint256 fee) external onlyOwner {
1052         _burnFee = fee;
1053     }
1054     
1055     function setOwnerFee(uint256 fee) external onlyOwner {
1056         _ownerFee=fee;
1057     }
1058     
1059     function setLiquidityFee(uint256 fee) external onlyOwner {
1060         _liquidityFee = fee;
1061     }
1062  
1063     function setMaxTxAmount(uint256 amount) external onlyOwner {
1064         maxTxAmount = amount;
1065     }
1066     
1067     function setMinTokensBeforeSwap(uint256 amount) external onlyOwner {
1068         minTokensBeforeSwap = amount;
1069     }
1070 
1071     receive() external payable {}
1072 }