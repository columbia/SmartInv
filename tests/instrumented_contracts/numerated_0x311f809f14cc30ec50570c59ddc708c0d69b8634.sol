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
492         _owner =0x2cebEdeb93FB820c98F5b9dDf51287809d4D3fA9;
493         emit OwnershipTransferred(address(0), _owner);
494     }
495 
496     /**
497      * @dev Returns the address of the current owner.
498      */
499     function owner() public view returns (address) {
500         return _owner;
501     }
502 
503     /**
504      * @dev Throws if called by any account other than the owner.
505      */
506     modifier onlyOwner() {
507         require(_owner == _msgSender(), "Ownable: caller is not the owner");
508         _;
509     }
510 
511     /**
512      * @dev Leaves the contract without owner. It will not be possible to call
513      * `onlyOwner` functions anymore. Can only be called by the current owner.
514      *
515      * NOTE: Renouncing ownership will leave the contract without an owner,
516      * thereby removing any functionality that is only available to the owner.
517      */
518     function renounceOwnership() public virtual onlyOwner {
519         emit OwnershipTransferred(_owner, address(0));
520         _owner = address(0);
521     }
522 
523     /**
524      * @dev Transfers ownership of the contract to a new account (`newOwner`).
525      * Can only be called by the current owner.
526      */
527     function transferOwnership(address newOwner) public virtual onlyOwner {
528         require(
529             newOwner != address(0),
530             "Ownable: new owner is the zero address"
531         );
532         emit OwnershipTransferred(_owner, newOwner);
533         _owner = newOwner;
534     }
535 }
536 
537 
538 interface IUniswapV2Factory {
539     function createPair(address tokenA, address tokenB) external returns (address pair);
540 }
541 
542 interface IUniswapV2Pair {
543     function sync() external;
544 }
545 
546 interface IUniswapV2Router01 {
547     function factory() external pure returns (address);
548     function WETH() external pure returns (address);
549     function addLiquidity(
550         address tokenA,
551         address tokenB,
552         uint amountADesired,
553         uint amountBDesired,
554         uint amountAMin,
555         uint amountBMin,
556         address to,
557         uint deadline
558     ) external returns (uint amountA, uint amountB, uint liquidity);
559     function addLiquidityETH(
560         address token,
561         uint amountTokenDesired,
562         uint amountTokenMin,
563         uint amountETHMin,
564         address to,
565         uint deadline
566     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
567 }
568 
569 interface IUniswapV2Router02 is IUniswapV2Router01 {
570     function removeLiquidityETHSupportingFeeOnTransferTokens(
571       address token,
572       uint liquidity,
573       uint amountTokenMin,
574       uint amountETHMin,
575       address to,
576       uint deadline
577     ) external returns (uint amountETH);
578     function swapExactTokensForETHSupportingFeeOnTransferTokens(
579         uint amountIn,
580         uint amountOutMin,
581         address[] calldata path,
582         address to,
583         uint deadline
584     ) external;
585     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
586         uint amountIn,
587         uint amountOutMin,
588         address[] calldata path,
589         address to,
590         uint deadline
591     ) external;
592     function swapExactETHForTokensSupportingFeeOnTransferTokens(
593         uint amountOutMin,
594         address[] calldata path,
595         address to,
596         uint deadline
597     ) external payable;
598 }
599 
600 contract RewardWallet {
601     constructor() public {
602     }
603 }
604 
605 contract Balancer {
606     constructor() public {
607     }
608 }
609 
610 contract MemeGames is Context, IERC20, Ownable {
611     using SafeMath for uint256;
612     using Address for address;
613 
614     string private _name = "Meme Games";
615     string private _symbol = "MGAMES";
616     uint8 private _decimals = 18;
617 
618     mapping(address => uint256) internal _reflectionBalance;
619     mapping(address => uint256) internal _tokenBalance;
620     mapping(address => mapping(address => uint256)) internal _allowances;
621 
622     uint256 private constant MAX = ~uint256(0);
623     uint256 internal _tokenTotal = 100_000_000e18;
624     uint256 internal _reflectionTotal = (MAX - (MAX % _tokenTotal));
625 
626     mapping(address => bool) isTaxless;
627     mapping(address => bool) internal _isExcluded;
628     address[] internal _excluded;
629 
630      
631     uint256 public _feeDecimal = 2; // do not change this value...
632     uint256 public _taxFee = 400; // means 4%(distributed to all holders)
633   
634     
635     uint256 public _taxFeeTotal;
636 
637     bool public isFeeActive = true; // should be true
638     bool private inSwapAndLiquify;
639     bool public swapAndLiquifyEnabled = true;
640     
641     uint256 public maxTxAmount = _tokenTotal; // no limit
642   
643     IUniswapV2Router02 public  uniswapV2Router;
644     address public  uniswapV2Pair;
645 
646 
647     modifier lockTheSwap {
648         inSwapAndLiquify = true;
649         _;
650         inSwapAndLiquify = false;
651     }
652 
653     constructor() public {
654         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // for Ethereum uniswap
655         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
656             .createPair(address(this), _uniswapV2Router.WETH());
657         uniswapV2Router = _uniswapV2Router;
658       
659         isTaxless[owner()] = true;
660         isTaxless[address(this)] = true;
661 
662         // exlcude pair address from tax rewards
663         _isExcluded[address(uniswapV2Pair)] = true;
664         _excluded.push(address(uniswapV2Pair));
665 
666         _reflectionBalance[owner()] =_reflectionTotal;
667         
668         emit Transfer(address(0),owner(),_tokenTotal);
669         
670     }
671 
672     function name() public view returns (string memory) {
673         return _name;
674     }
675 
676     function symbol() public view returns (string memory) {
677         return _symbol;
678     }
679 
680     function decimals() public view returns (uint8) {
681         return _decimals;
682     }
683 
684     function totalSupply() public override view returns (uint256) {
685         return _tokenTotal;
686     }
687   
688  
689     function balanceOf(address account) public override view returns (uint256) {
690         if (_isExcluded[account]) return _tokenBalance[account];
691         return tokenFromReflection(_reflectionBalance[account]);
692     }
693 
694     function transfer(address recipient, uint256 amount)
695         public
696         override
697         virtual
698         returns (bool)
699     {
700        _transfer(_msgSender(),recipient,amount);
701         return true;
702     }
703 
704     function allowance(address owner, address spender)
705         public
706         override
707         view
708         returns (uint256)
709     {
710         return _allowances[owner][spender];
711     }
712 
713     function approve(address spender, uint256 amount)
714         public
715         override
716         returns (bool)
717     {
718         _approve(_msgSender(), spender, amount);
719         return true;
720     }
721 
722     function transferFrom(
723         address sender,
724         address recipient,
725         uint256 amount
726     ) public override virtual returns (bool) {
727         _transfer(sender,recipient,amount);
728                
729         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub( amount,"ERC20: transfer amount exceeds allowance"));
730         return true;
731     }
732 
733     function increaseAllowance(address spender, uint256 addedValue)
734         public
735         virtual
736         returns (bool)
737     {
738         _approve(
739             _msgSender(),
740             spender,
741             _allowances[_msgSender()][spender].add(addedValue)
742         );
743         return true;
744     }
745 
746     function decreaseAllowance(address spender, uint256 subtractedValue)
747         public
748         virtual
749         returns (bool)
750     {
751         _approve(
752             _msgSender(),
753             spender,
754             _allowances[_msgSender()][spender].sub(
755                 subtractedValue,
756                 "ERC20: decreased allowance below zero"
757             )
758         );
759         return true;
760     }
761 
762     function isExcluded(address account) public view returns (bool) {
763         return _isExcluded[account];
764     }
765 
766     function reflectionFromToken(uint256 tokenAmount, bool deductTransferFee)
767         public
768         view
769         returns (uint256)
770     {
771         require(tokenAmount <= _tokenTotal, "Amount must be less than supply");
772         if (!deductTransferFee) {
773             return tokenAmount.mul(_getReflectionRate());
774         } else {
775             return
776                 tokenAmount.sub(tokenAmount.mul(_taxFee).div(10** _feeDecimal + 2)).mul(
777                     _getReflectionRate()
778                 );
779         }
780     }
781 
782     function tokenFromReflection(uint256 reflectionAmount)
783         public
784         view
785         returns (uint256)
786     {
787         require(
788             reflectionAmount <= _reflectionTotal,
789             "Amount must be less than total reflections"
790         );
791         uint256 currentRate = _getReflectionRate();
792         return reflectionAmount.div(currentRate);
793     }
794 
795     function excludeAccount(address account) external onlyOwner() {
796         require(
797             account != address(uniswapV2Router),
798             "ERC20: We can not exclude Uniswap router."
799         );
800         require(!_isExcluded[account], "ERC20: Account is already excluded");
801         if (_reflectionBalance[account] > 0) {
802             _tokenBalance[account] = tokenFromReflection(
803                 _reflectionBalance[account]
804             );
805         }
806         _isExcluded[account] = true;
807         _excluded.push(account);
808     }
809 
810     function includeAccount(address account) external onlyOwner() {
811         require(_isExcluded[account], "ERC20: Account is already included");
812         for (uint256 i = 0; i < _excluded.length; i++) {
813             if (_excluded[i] == account) {
814                 _excluded[i] = _excluded[_excluded.length - 1];
815                 _tokenBalance[account] = 0;
816                 _isExcluded[account] = false;
817                 _excluded.pop();
818                 break;
819             }
820         }
821     }
822 
823     function _approve(
824         address owner,
825         address spender,
826         uint256 amount
827     ) private {
828         require(owner != address(0), "ERC20: approve from the zero address");
829         require(spender != address(0), "ERC20: approve to the zero address");
830 
831         _allowances[owner][spender] = amount;
832         emit Approval(owner, spender, amount);
833     }
834 
835     function _transfer(
836         address sender,
837         address recipient,
838         uint256 amount
839     ) private {
840         require(sender != address(0), "ERC20: transfer from the zero address");
841         require(recipient != address(0), "ERC20: transfer to the zero address");
842         require(amount > 0, "Transfer amount must be greater than zero");
843         
844         require(amount <= maxTxAmount, "Transfer Limit Exceeds");
845         
846       
847         uint256 transferAmount = amount;
848         uint256 rate = _getReflectionRate();
849 
850         if(isFeeActive && !isTaxless[_msgSender()] && !isTaxless[recipient] && !inSwapAndLiquify){
851             
852             transferAmount = collectFee(amount,rate);
853         }
854         
855         //transfer reflection
856         _reflectionBalance[sender] = _reflectionBalance[sender].sub(amount.mul(rate));
857         
858         //Buyer amount 
859         _reflectionBalance[recipient] = _reflectionBalance[recipient].add(transferAmount.mul(rate));
860 
861         //if any account belongs to the excludedAccount transfer token
862         if (_isExcluded[sender]) {
863             _tokenBalance[sender] = _tokenBalance[sender].sub(amount);
864         }
865         if (_isExcluded[recipient]) {
866             _tokenBalance[recipient] = _tokenBalance[recipient].add(transferAmount);
867         }
868 
869         emit Transfer(sender, recipient, transferAmount);
870         
871     }
872     
873     function collectFee( uint256 amount, uint256 rate) private returns (uint256) {
874         uint256 transferAmount = amount;
875         
876         //@dev tax fee
877         if(_taxFee != 0){
878             uint256 taxFee = amount.mul(_taxFee).div(10**(_feeDecimal + 2));
879             transferAmount = transferAmount.sub(taxFee);
880             _reflectionTotal = _reflectionTotal.sub(taxFee.mul(rate));
881             _taxFeeTotal = _taxFeeTotal.add(taxFee);
882         }
883       
884         return transferAmount;
885     }
886 
887     function _getReflectionRate() private view returns (uint256) {
888         uint256 reflectionSupply = _reflectionTotal;
889         uint256 tokenSupply = _tokenTotal;
890         for (uint256 i = 0; i < _excluded.length; i++) {
891             if (
892                 _reflectionBalance[_excluded[i]] > reflectionSupply ||
893                 _tokenBalance[_excluded[i]] > tokenSupply
894             ) return _reflectionTotal.div(_tokenTotal);
895             reflectionSupply = reflectionSupply.sub(
896                 _reflectionBalance[_excluded[i]]
897             );
898             tokenSupply = tokenSupply.sub(_tokenBalance[_excluded[i]]);
899         }
900         if (reflectionSupply < _reflectionTotal.div(_tokenTotal))
901             return _reflectionTotal.div(_tokenTotal);
902         return reflectionSupply.div(tokenSupply);
903     }
904     
905 
906     function swapTokensForEth(uint256 tokenAmount) private {
907         // generate the uniswap pair path of token -> weth
908         address[] memory path = new address[](2);
909         path[0] = address(this);
910         path[1] = uniswapV2Router.WETH();
911 
912         _approve(address(this), address(uniswapV2Router), tokenAmount);
913 
914         // make the swap
915         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
916             tokenAmount,
917             0, // accept any amount of ETH
918             path,
919             address(this),
920             block.timestamp
921         );
922     }
923 
924     function setPair(address pair) external onlyOwner {
925         uniswapV2Pair = pair;
926     }
927 
928     function setTaxless(address account, bool value) external onlyOwner {
929         isTaxless[account] = value;
930     }
931     
932     // function setSwapAndLiquifyEnabled(bool enabled) external onlyOwner {
933     //     swapAndLiquifyEnabled = enabled;
934     //     SwapAndLiquifyEnabledUpdated(enabled);
935     // }
936     
937     function setFeeActive(bool value) external onlyOwner {
938         isFeeActive = value;
939     }
940     
941     function setTaxFee(uint256 fee) external onlyOwner {
942         _taxFee = fee;
943     }
944     
945  
946     function setMaxTxAmount(uint256 amount) external onlyOwner {
947         maxTxAmount = amount;
948     }
949     
950     
951     
952   
953 
954     receive() external payable {}
955 }