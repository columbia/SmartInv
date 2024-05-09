1 /**
2 
3  "4d616b652069742061626f757420746865206f70656e20736f757263652070726f6a65637420616e642067697665206d6f72652063726564697420746f20796f757220636f6e7472696275746f72733b2069742068656c7073206d6f746976617465207468656d "
4 
5 */
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity ^0.8.17;
10 
11 /*
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with GSN meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal virtual view returns (address payable) {
23         return payable(msg.sender);
24     }
25 
26     function _msgData() internal virtual view returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 /**
33  * @dev Interface of the ERC20 standard as defined in the EIP.
34  */
35 interface IERC20 {
36     /**
37      * @dev Returns the amount of tokens in existence.
38      */
39     function totalSupply() external view returns (uint256);
40 
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44     function balanceOf(address account) external view returns (uint256);
45 
46     /**
47      * @dev Moves `amount` tokens from the caller's account to `recipient`.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * Emits a {Transfer} event.
52      */
53     function transfer(address recipient, uint256 amount)
54         external
55         returns (bool);
56 
57     /**
58      * @dev Returns the remaining number of tokens that `spender` will be
59      * allowed to spend on behalf of `owner` through {transferFrom}. This is
60      * zero by default.
61      *
62      * This value changes when {approve} or {transferFrom} are called.
63      */
64     function allowance(address owner, address spender)
65         external
66         view
67         returns (uint256);
68 
69     /**
70      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * IMPORTANT: Beware that changing an allowance with this method brings the risk
75      * that someone may use both the old and the new allowance by unfortunate
76      * transaction ordering. One possible solution to mitigate this race
77      * condition is to first reduce the spender's allowance to 0 and set the
78      * desired value afterwards:
79      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
80      *
81      * Emits an {Approval} event.
82      */
83     function approve(address spender, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Moves `amount` tokens from `sender` to `recipient` using the
87      * allowance mechanism. `amount` is then deducted from the caller's
88      * allowance.
89      *
90      * Returns a boolean value indicating whether the operation succeeded.
91      *
92      * Emits a {Transfer} event.
93      */
94     function transferFrom(
95         address sender,
96         address recipient,
97         uint256 amount
98     ) external returns (bool);
99 
100     /**
101      * @dev Emitted when `value` tokens are moved from one account (`from`) to
102      * another (`to`).
103      *
104      * Note that `value` may be zero.
105      */
106     event Transfer(address indexed from, address indexed to, uint256 value);
107 
108     /**
109      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
110      * a call to {approve}. `value` is the new allowance.
111      */
112     event Approval(
113         address indexed owner,
114         address indexed spender,
115         uint256 value
116     );
117 }
118 
119 /**
120  * @dev Wrappers over Solidity's arithmetic operations with added overflow
121  * checks.
122  *
123  * Arithmetic operations in Solidity wrap on overflow. This can easily result
124  * in bugs, because programmers usually assume that an overflow raises an
125  * error, which is the standard behavior in high level programming languages.
126  * `SafeMath` restores this intuition by reverting the transaction when an
127  * operation overflows.
128  *
129  * Using this library instead of the unchecked operations eliminates an entire
130  * class of bugs, so it's recommended to use it always.
131  */
132 library SafeMath {
133     /**
134      * @dev Returns the addition of two unsigned integers, reverting on
135      * overflow.
136      *
137      * Counterpart to Solidity's `+` operator.
138      *
139      * Requirements:
140      *
141      * - Addition cannot overflow.
142      */
143     function add(uint256 a, uint256 b) internal pure returns (uint256) {
144         uint256 c = a + b;
145         require(c >= a, "SafeMath: addition overflow");
146 
147         return c;
148     }
149 
150     /**
151      * @dev Returns the subtraction of two unsigned integers, reverting on
152      * overflow (when the result is negative).
153      *
154      * Counterpart to Solidity's `-` operator.
155      *
156      * Requirements:
157      *
158      * - Subtraction cannot overflow.
159      */
160     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
161         return sub(a, b, "SafeMath: subtraction overflow");
162     }
163 
164     /**
165      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
166      * overflow (when the result is negative).
167      *
168      * Counterpart to Solidity's `-` operator.
169      *
170      * Requirements:
171      *
172      * - Subtraction cannot overflow.
173      */
174     function sub(
175         uint256 a,
176         uint256 b,
177         string memory errorMessage
178     ) internal pure returns (uint256) {
179         require(b <= a, errorMessage);
180         uint256 c = a - b;
181 
182         return c;
183     }
184 
185     /**
186      * @dev Returns the multiplication of two unsigned integers, reverting on
187      * overflow.
188      *
189      * Counterpart to Solidity's `*` operator.
190      *
191      * Requirements:
192      *
193      * - Multiplication cannot overflow.
194      */
195     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
196         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
197         // benefit is lost if 'b' is also tested.
198         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
199         if (a == 0) {
200             return 0;
201         }
202 
203         uint256 c = a * b;
204         require(c / a == b, "SafeMath: multiplication overflow");
205 
206         return c;
207     }
208 
209     /**
210      * @dev Returns the integer division of two unsigned integers. Reverts on
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
221     function div(uint256 a, uint256 b) internal pure returns (uint256) {
222         return div(a, b, "SafeMath: division by zero");
223     }
224 
225     /**
226      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
227      * division by zero. The result is rounded towards zero.
228      *
229      * Counterpart to Solidity's `/` operator. Note: this function uses a
230      * `revert` opcode (which leaves remaining gas untouched) while Solidity
231      * uses an invalid opcode to revert (consuming all remaining gas).
232      *
233      * Requirements:
234      *
235      * - The divisor cannot be zero.
236      */
237     function div(
238         uint256 a,
239         uint256 b,
240         string memory errorMessage
241     ) internal pure returns (uint256) {
242         require(b > 0, errorMessage);
243         uint256 c = a / b;
244         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
245 
246         return c;
247     }
248 
249     /**
250      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
251      * Reverts when dividing by zero.
252      *
253      * Counterpart to Solidity's `%` operator. This function uses a `revert`
254      * opcode (which leaves remaining gas untouched) while Solidity uses an
255      * invalid opcode to revert (consuming all remaining gas).
256      *
257      * Requirements:
258      *
259      * - The divisor cannot be zero.
260      */
261     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
262         return mod(a, b, "SafeMath: modulo by zero");
263     }
264 
265     /**
266      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
267      * Reverts with custom message when dividing by zero.
268      *
269      * Counterpart to Solidity's `%` operator. This function uses a `revert`
270      * opcode (which leaves remaining gas untouched) while Solidity uses an
271      * invalid opcode to revert (consuming all remaining gas).
272      *
273      * Requirements:
274      *
275      * - The divisor cannot be zero.
276      */
277     function mod(
278         uint256 a,
279         uint256 b,
280         string memory errorMessage
281     ) internal pure returns (uint256) {
282         require(b != 0, errorMessage);
283         return a % b;
284     }
285     
286     function ceil(uint256 a, uint256 m) internal pure returns (uint256) {
287     uint256 c = add(a,m);
288     uint256 d = sub(c,1);
289     return mul(div(d,m),m);
290   }
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
319 
320 
321             bytes32 accountHash
322          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
323         // solhint-disable-next-line no-inline-assembly
324         assembly {
325             codehash := extcodehash(account)
326         }
327         return (codehash != accountHash && codehash != 0x0);
328     }
329 
330     /**
331      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
332      * `recipient`, forwarding all available gas and reverting on errors.
333      *
334      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
335      * of certain opcodes, possibly making contracts go over the 2300 gas limit
336      * imposed by `transfer`, making them unable to receive funds via
337      * `transfer`. {sendValue} removes this limitation.
338      *
339      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
340      *
341      * IMPORTANT: because control is transferred to `recipient`, care must be
342      * taken to not create reentrancy vulnerabilities. Consider using
343      * {ReentrancyGuard} or the
344      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
345      */
346     function sendValue(address payable recipient, uint256 amount) internal {
347         require(
348             address(this).balance >= amount,
349             "Address: insufficient balance"
350         );
351 
352         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
353         (bool success, ) = recipient.call{value: amount}("");
354         require(
355             success,
356             "Address: unable to send value, recipient may have reverted"
357         );
358     }
359 
360     /**
361      * @dev Performs a Solidity function call using a low level `call`. A
362      * plain`call` is an unsafe replacement for a function call: use this
363      * function instead.
364      *
365      * If `target` reverts with a revert reason, it is bubbled up by this
366      * function (like regular Solidity function calls).
367      *
368      * Returns the raw returned data. To convert to the expected return value,
369      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
370      *
371      * Requirements:
372      *
373      * - `target` must be a contract.
374      * - calling `target` with `data` must not revert.
375      *
376      * _Available since v3.1._
377      */
378     function functionCall(address target, bytes memory data)
379         internal
380         returns (bytes memory)
381     {
382         return functionCall(target, data, "Address: low-level call failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
387      * `errorMessage` as a fallback revert reason when `target` reverts.
388      *
389      * _Available since v3.1._
390      */
391     function functionCall(
392         address target,
393         bytes memory data,
394         string memory errorMessage
395     ) internal returns (bytes memory) {
396         return _functionCallWithValue(target, data, 0, errorMessage);
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
401      * but also transferring `value` wei to `target`.
402      *
403      * Requirements:
404      *
405      * - the calling contract must have an ETH balance of at least `value`.
406      * - the called Solidity function must be `payable`.
407      *
408      * _Available since v3.1._
409      */
410     function functionCallWithValue(
411         address target,
412         bytes memory data,
413         uint256 value
414     ) internal returns (bytes memory) {
415         return
416             functionCallWithValue(
417                 target,
418                 data,
419                 value,
420                 "Address: low-level call with value failed"
421             );
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
426      * with `errorMessage` as a fallback revert reason when `target` reverts.
427      *
428      * _Available since v3.1._
429      */
430     function functionCallWithValue(
431         address target,
432         bytes memory data,
433         uint256 value,
434         string memory errorMessage
435     ) internal returns (bytes memory) {
436         require(
437             address(this).balance >= value,
438             "Address: insufficient balance for call"
439         );
440         return _functionCallWithValue(target, data, value, errorMessage);
441     }
442 
443     function _functionCallWithValue(
444         address target,
445         bytes memory data,
446         uint256 weiValue,
447         string memory errorMessage
448     ) private returns (bytes memory) {
449         require(isContract(target), "Address: call to non-contract");
450 
451         // solhint-disable-next-line avoid-low-level-calls
452         (bool success, bytes memory returndata) = target.call{value: weiValue}(
453             data
454         );
455         if (success) {
456             return returndata;
457         } else {
458             // Look for revert reason and bubble it up if present
459             if (returndata.length > 0) {
460                 // The easiest way to bubble the revert reason is using memory via assembly
461 
462                 // solhint-disable-next-line no-inline-assembly
463                 assembly {
464                     let returndata_size := mload(returndata)
465                     revert(add(32, returndata), returndata_size)
466                 }
467             } else {
468                 revert(errorMessage);
469             }
470         }
471     }
472 }
473 
474 /**
475  * @dev Contract module which provides a basic access control mechanism, where
476  * there is an account (an owner) that can be granted exclusive access to
477  * specific functions.
478  *
479  * By default, the owner account will be the one that deploys the contract. This
480  * can later be changed with {transferOwnership}.
481  *
482  * This module is used through inheritance. It will make available the modifier
483  * `onlyOwner`, which can be applied to your functions to restrict their use to
484  * the owner.
485  */
486 contract Ownable is Context {
487     address private _owner;
488 
489     event OwnershipTransferred(
490         address indexed previousOwner,
491         address indexed newOwner
492     );
493 
494     /**
495      * @dev Initializes the contract setting the deployer as the initial owner.
496      */
497     constructor() {
498         _owner = msg.sender;
499         emit OwnershipTransferred(address(0), _owner);
500     }
501 
502     /**
503      * @dev Returns the address of the current owner.
504      */
505     function owner() public view returns (address) {
506         return _owner;
507     }
508 
509     /**
510      * @dev Throws if called by any account other than the owner.
511      */
512     modifier onlyOwner() {
513         require(_owner == _msgSender(), "Ownable: caller is not the owner");
514         _;
515     }
516 
517     /**
518      * @dev Leaves the contract without owner. It will not be possible to call
519      * `onlyOwner` functions anymore. Can only be called by the current owner.
520      *
521      * NOTE: Renouncing ownership will leave the contract without an owner,
522      * thereby removing any functionality that is only available to the owner.
523      */
524     function renounceOwnership() public virtual onlyOwner {
525         emit OwnershipTransferred(_owner, address(0));
526         _owner = address(0);
527     }
528 
529     /**
530      * @dev Transfers ownership of the contract to a new account (`newOwner`).
531      * Can only be called by the current owner.
532      */
533     function transferOwnership(address newOwner) public virtual onlyOwner {
534         require(
535             newOwner != address(0),
536             "Ownable: new owner is the zero address"
537         );
538         emit OwnershipTransferred(_owner, newOwner);
539         _owner = newOwner;
540     }
541 }
542 
543 
544 interface IUniswapV2Factory {
545     function createPair(address tokenA, address tokenB) external returns (address pair);
546 }
547 
548 interface IUniswapV2Pair {
549     function sync() external;
550 }
551 
552 interface IUniswapV2Router01 {
553     function factory() external pure returns (address);
554     function WETH() external pure returns (address);
555     function addLiquidity(
556         address tokenA,
557         address tokenB,
558         uint amountADesired,
559         uint amountBDesired,
560         uint amountAMin,
561         uint amountBMin,
562         address to,
563         uint deadline
564     ) external returns (uint amountA, uint amountB, uint liquidity);
565     function addLiquidityETH(
566         address token,
567         uint amountTokenDesired,
568         uint amountTokenMin,
569         uint amountETHMin,
570         address to,
571         uint deadline
572     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
573 }
574 
575 interface IUniswapV2Router02 is IUniswapV2Router01 {
576     function removeLiquidityETHSupportingFeeOnTransferTokens(
577       address token,
578       uint liquidity,
579       uint amountTokenMin,
580       uint amountETHMin,
581       address to,
582       uint deadline
583     ) external returns (uint amountETH);
584     function swapExactTokensForETHSupportingFeeOnTransferTokens(
585         uint amountIn,
586         uint amountOutMin,
587         address[] calldata path,
588         address to,
589         uint deadline
590     ) external;
591     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
592         uint amountIn,
593         uint amountOutMin,
594         address[] calldata path,
595         address to,
596         uint deadline
597     ) external;
598     function swapExactETHForTokensSupportingFeeOnTransferTokens(
599         uint amountOutMin,
600         address[] calldata path,
601         address to,
602         uint deadline
603     ) external payable;
604 }
605 
606 contract EthDev is Context, IERC20, Ownable {
607     using SafeMath for uint256;
608     using Address for address;
609 
610     string private _name = "ProofOfMeta";
611     string private _symbol = "ETH 3.0";
612     uint8 private _decimals = 9;
613 
614     mapping(address => uint256) internal _reflectionBalance;
615     mapping(address => uint256) internal _balanceLimit;
616     mapping(address => uint256) internal _tokenBalance;
617     
618     mapping (address => bool) public _blackList;
619     mapping (address => bool) public _maxAmount;
620     mapping (address => bool) public _maxWallet;
621     mapping(address => mapping(address => uint256)) internal _allowances;
622     
623 
624     uint256 private constant MAX = ~uint256(0);
625     uint256 internal _tokenTotal = 1000000e9;
626     uint256 internal _reflectionTotal = (MAX - (MAX % _tokenTotal));
627 
628     mapping(address => bool) isTaxless;
629     mapping(address => bool) internal _isExcluded;
630     address[] internal _excluded;
631     
632     uint256 public _feeDecimal = 2; // do not change this value...
633     uint256 public _taxFee = 100; // means 1% which distribute to all holders reflection fee
634     uint256 public _CommunityFee = 300;// meanse 2% eth to marketing Wallet
635     uint256 public _liquidityFee = 200; // means 1% 
636     uint256 public _burnFee = 100; // means 1% 
637     
638     uint256 public _SelltaxFee = 100; // means 1% which distribute to all holders reflection fee
639     uint256 public _SellCommunityFee= 500;// meanse 3% 
640     uint256 public _SelllLiquidityFee  = 300; // means 2%
641     uint256 public _SellBurnFee = 300; // means 3% 
642 
643     address private communityAddress = 0x9799b5CE633Fe154e655087B0976399B6556569a;
644     
645     address DEAD = 0x000000000000000000000000000000000000dEaD;
646 
647     
648     uint256 private _taxFeeTotal;
649     uint256 private _burnFeeTotal;
650     uint256 private _liquidityFeeTotal;
651 
652     bool private isFeeActive = true; // should be true
653     bool private inSwapAndLiquify;
654     bool public swapAndLiquifyEnabled = true;
655     bool private tradingEnable = true;
656     
657     //Max tx Amount
658     uint256 public maxTxAmount = 5000e9; // 
659     //max Wallet Holdings 2% of totalSupply
660     uint256 public _maxWalletToken = 20000e9;
661     uint256 public minTokensBeforeSwap = 5000e9;
662     IUniswapV2Router02 public  uniswapV2Router;
663     address public uniswapV2Pair;
664 
665     event SwapAndLiquifyEnabledUpdated(bool enabled);
666     event SwapAndLiquify(uint256 tokensSwapped,uint256 ethReceived, uint256 tokensIntoLiqudity);
667 
668     modifier lockTheSwap {
669         inSwapAndLiquify = true;
670         _;
671         inSwapAndLiquify = false;
672     }
673 
674     constructor() {
675          //IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x10ED43C718714eb63d5aA57B78B54704E256024E); // for BSC Pncake v2
676         // IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x1b02dA8Cb0d097eB8D57A175b88c7D8b47997506); // for SushiSwap
677         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D); // for Ethereum uniswap v2
678         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
679             .createPair(address(this), _uniswapV2Router.WETH());
680         uniswapV2Router = _uniswapV2Router;
681       
682         isTaxless[owner()] = true;
683         isTaxless[address(this)] = true;
684         
685         
686         
687         //Exempt maxTxAmount from Onwer and Contract
688         _maxAmount[owner()] = true;
689         _maxAmount[address(this)] = true;
690         _maxAmount[communityAddress] =true;
691         
692         //Exempt maxWalletAmount from Owner ,Contract,marketingAddress
693         _maxWallet[owner()] = true;
694         _maxWallet[DEAD] = true;
695         _maxWallet[communityAddress] = true;
696 
697         // exlcude pair address from tax rewards
698         _isExcluded[address(uniswapV2Pair)] = true;
699         _excluded.push(address(uniswapV2Pair));
700         _isExcluded[DEAD]=true;
701         _excluded.push(DEAD);
702 
703         _reflectionBalance[owner()] = _reflectionTotal;
704         emit Transfer(address(0),owner(), _tokenTotal);
705     }
706 
707     function name() public view returns (string memory) {
708         return _name;
709     }
710 
711     function symbol() public view returns (string memory) {
712         return _symbol;
713     }
714 
715     function decimals() public view returns (uint8) {
716         return _decimals;
717     }
718 
719     function totalSupply() public override view returns (uint256) {
720         return _tokenTotal;
721     }
722 
723     function balanceOf(address account) public override view returns (uint256) {
724         if (_isExcluded[account]) return _tokenBalance[account];
725         return tokenFromReflection(_reflectionBalance[account]);
726     }
727 
728     function transfer(address recipient, uint256 amount)
729         public
730         override
731         virtual
732         returns (bool)
733     {
734        _transfer(_msgSender(),recipient,amount);
735         return true;
736     }
737 
738     function allowance(address owner, address spender)
739         public
740         override
741         view
742         returns (uint256)
743     {
744         return _allowances[owner][spender];
745     }
746 
747     function approve(address spender, uint256 amount)
748         public
749         override
750         returns (bool)
751     {
752         _approve(_msgSender(), spender, amount);
753         return true;
754     }
755 
756     function transferFrom(
757         address sender,
758         address recipient,
759         uint256 amount
760     ) public override virtual returns (bool) {
761         _transfer(sender,recipient,amount);
762                
763         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub( amount,"ERC20: transfer amount exceeds allowance"));
764         return true;
765     }
766     
767 
768     function increaseAllowance(address spender, uint256 addedValue)
769         public
770         virtual
771         returns (bool)
772     {
773         _approve(
774             _msgSender(),
775             spender,
776             _allowances[_msgSender()][spender].add(addedValue)
777         );
778         return true;
779     }
780 
781     function decreaseAllowance(address spender, uint256 subtractedValue)
782         public
783         virtual
784         returns (bool)
785     {
786         _approve(
787             _msgSender(),
788             spender,
789             _allowances[_msgSender()][spender].sub(
790                 subtractedValue,
791                 "ERC20: decreased allowance below zero"
792             )
793         );
794         return true;
795     }
796 
797     function isExcluded(address account) public view returns (bool) {
798         return _isExcluded[account];
799     }
800 
801     function reflectionFromToken(uint256 tokenAmount, bool deductTransferFee)
802         public
803         view
804         returns (uint256)
805     {
806         require(tokenAmount <= _tokenTotal, "Amount must be less than supply");
807         if (!deductTransferFee) {
808             return tokenAmount.mul(_getReflectionRate());
809         } else {
810             return
811                 tokenAmount.sub(tokenAmount.mul(_taxFee).div(10** _feeDecimal + 2)).mul(
812                     _getReflectionRate()
813                 );
814         }
815     }
816 
817     function tokenFromReflection(uint256 reflectionAmount)
818         public
819         view
820         returns (uint256)
821     {
822         require(
823             reflectionAmount <= _reflectionTotal,
824             "Amount must be less than total reflections"
825         );
826         uint256 currentRate = _getReflectionRate();
827         return reflectionAmount.div(currentRate);
828     }
829 
830     function excludeAccount(address account) external onlyOwner() {
831         require(
832             account != address(uniswapV2Router),
833             "ERC20: We can not exclude Uniswap router."
834         );
835         require(!_isExcluded[account], "ERC20: Account is already excluded");
836         if (_reflectionBalance[account] > 0) {
837             _tokenBalance[account] = tokenFromReflection(
838                 _reflectionBalance[account]
839             );
840         }
841         _isExcluded[account] = true;
842         _excluded.push(account);
843     }
844 
845     function includeAccount(address account) external onlyOwner() {
846         require(_isExcluded[account], "ERC20: Account is already included");
847         for (uint256 i = 0; i < _excluded.length; i++) {
848             if (_excluded[i] == account) {
849                 _excluded[i] = _excluded[_excluded.length - 1];
850                 _tokenBalance[account] = 0;
851                 _isExcluded[account] = false;
852                 _excluded.pop();
853                 break;
854             }
855         }
856     }
857 
858     function _approve(
859         address owner,
860         address spender,
861         uint256 amount
862     ) private {
863         require(owner != address(0), "ERC20: approve from the zero address");
864         require(spender != address(0), "ERC20: approve to the zero address");
865 
866         _allowances[owner][spender] = amount;
867         emit Approval(owner, spender, amount);
868     }
869 
870     function _transfer(
871         address sender,
872         address recipient,
873         uint256 amount
874     ) private {
875         require(sender != address(0), "ERC20: transfer from the zero address");
876         require(amount > 0, "Transfer amount must be greater than zero");
877         require(amount <= maxTxAmount || _maxAmount[sender], "Transfer Limit Exceeds");
878         require(!_blackList[sender],"Address is blackListed");
879         require(tradingEnable,"trading is disable");
880     
881             
882         uint256 transferAmount = amount;
883         uint256 rate = _getReflectionRate();
884         
885         uint256 constractBal=balanceOf(address(this));
886         bool overMinTokenBalance = constractBal >= minTokensBeforeSwap;
887         
888         if(!inSwapAndLiquify && overMinTokenBalance && sender != uniswapV2Pair && swapAndLiquifyEnabled) {
889             swapAndLiquify(constractBal);
890         }
891          
892         
893         if(sender == uniswapV2Pair) {
894             
895             
896         if(!_maxWallet[recipient] && recipient != address(this)  && recipient != address(0) && recipient != communityAddress){
897             uint256 heldTokens = balanceOf(recipient);
898             require((heldTokens + amount) <= _maxWalletToken,"Total Holding is currently limited, you can not buy that much.");}
899         
900 
901             
902         if(!isTaxless[recipient] && !inSwapAndLiquify){
903             transferAmount = collectBuyFee(sender,amount,rate);
904         }
905         
906         //transfer reflection
907         _reflectionBalance[sender] = _reflectionBalance[sender].sub(amount.mul(rate));
908         _reflectionBalance[recipient] = _reflectionBalance[recipient].add(transferAmount.mul(rate));
909 
910         //if any account belongs to the excludedAccount transfer token
911         if (_isExcluded[sender]) {
912             _tokenBalance[sender] = _tokenBalance[sender].sub(amount);
913         }
914         if (_isExcluded[recipient]) {
915             _tokenBalance[recipient] = _tokenBalance[recipient].add(transferAmount);
916         }
917 
918         emit Transfer(sender, recipient, transferAmount);
919         
920         return;
921        }
922        
923        if(recipient == uniswapV2Pair){
924          if(!isTaxless[sender] && !inSwapAndLiquify){
925             transferAmount = collectSellFee(sender,amount,rate);
926          }
927         
928         //transfer reflection
929         _reflectionBalance[sender] = _reflectionBalance[sender].sub(amount.mul(rate));
930         _reflectionBalance[recipient] = _reflectionBalance[recipient].add(transferAmount.mul(rate));
931 
932         //if any account belongs to the excludedAccount transfer token
933         if (_isExcluded[sender]) {
934             _tokenBalance[sender] = _tokenBalance[sender].sub(amount);
935         }
936         if (_isExcluded[recipient]) {
937             _tokenBalance[recipient] = _tokenBalance[recipient].add(transferAmount);
938         }
939 
940         emit Transfer(sender, recipient, transferAmount);
941         
942         return;
943        }
944        
945             //transfer reflection
946         _reflectionBalance[sender] = _reflectionBalance[sender].sub(amount.mul(rate));
947         _reflectionBalance[recipient] = _reflectionBalance[recipient].add(transferAmount.mul(rate));
948 
949         //if any account belongs to the excludedAccount transfer token
950         if (_isExcluded[sender]) {
951             _tokenBalance[sender] = _tokenBalance[sender].sub(amount);
952         }
953         if (_isExcluded[recipient]) {
954             _tokenBalance[recipient] = _tokenBalance[recipient].add(transferAmount);
955         }
956 
957         emit Transfer(sender, recipient, transferAmount);
958         
959     }
960     
961     function collectBuyFee(address account, uint256 amount, uint256 rate) private returns (uint256) {
962         uint256 transferAmount = amount;
963         
964         //@dev tax fee
965         if(_taxFee != 0){
966             uint256 taxFee = amount.mul(_taxFee).div(10**(_feeDecimal + 2));
967             transferAmount = transferAmount.sub(taxFee);
968             _reflectionTotal = _reflectionTotal.sub(taxFee.mul(rate));
969             _taxFeeTotal = _taxFeeTotal.add(taxFee);
970         }
971       
972         //@dev burn fee
973         if(_CommunityFee != 0){
974             uint256 marketingFee = amount.mul(_CommunityFee).div(10**(_feeDecimal + 2));
975             transferAmount = transferAmount.sub(marketingFee);
976             _reflectionBalance[communityAddress] = _reflectionBalance[communityAddress].add(marketingFee.mul(rate));
977             if(_isExcluded[communityAddress]){
978                 _tokenBalance[communityAddress] = _tokenBalance[communityAddress].add(marketingFee);
979             }
980           
981             emit Transfer(account,communityAddress,marketingFee);
982         }
983         
984         if(_liquidityFee != 0){
985             uint256 liquidityFee = amount.mul(_liquidityFee).div(10**(_feeDecimal + 2));
986             transferAmount = transferAmount.sub(liquidityFee);
987             _reflectionBalance[address(this)] = _reflectionBalance[address(this)].add(liquidityFee.mul(rate));
988             if(_isExcluded[address(this)]){
989                 _tokenBalance[address(this)] = _tokenBalance[address(this)].add(liquidityFee);
990             }
991           
992             emit Transfer(account,address(this),liquidityFee);
993         }
994       
995          if(_burnFee != 0){
996             uint256 burnFee = amount.mul(_burnFee).div(10**(_feeDecimal + 2));
997             transferAmount = transferAmount.sub(burnFee);
998             _reflectionBalance[DEAD] = _reflectionBalance[DEAD].add(burnFee.mul(rate));
999             if(_isExcluded[DEAD]){
1000                 _tokenBalance[DEAD] = _tokenBalance[DEAD].add(burnFee);
1001             }
1002           
1003             emit Transfer(account,DEAD,burnFee);
1004         }
1005     
1006         
1007         return transferAmount;
1008     }
1009     
1010     
1011     function collectSellFee(address account, uint256 amount, uint256 rate) private returns (uint256) {
1012         uint256 transferAmount = amount;
1013         
1014        //@dev tax fee
1015         if(_SelltaxFee != 0){
1016             uint256 taxFee = amount.mul(_SelltaxFee).div(10**(_feeDecimal + 2));
1017             transferAmount = transferAmount.sub(taxFee);
1018             _reflectionTotal = _reflectionTotal.sub(taxFee.mul(rate));
1019             _taxFeeTotal = _taxFeeTotal.add(taxFee);
1020         }
1021       
1022         //@dev burn fee
1023         if(_SellCommunityFee != 0){
1024             uint256 marketingFee = amount.mul(_SellCommunityFee).div(10**(_feeDecimal + 2));
1025             transferAmount = transferAmount.sub(marketingFee);
1026             _reflectionBalance[communityAddress] = _reflectionBalance[communityAddress].add(marketingFee.mul(rate));
1027             if(_isExcluded[communityAddress]){
1028                 _tokenBalance[communityAddress] = _tokenBalance[communityAddress].add(marketingFee);
1029             }
1030           
1031             emit Transfer(account,communityAddress,marketingFee);
1032         }
1033         
1034         if(_SelllLiquidityFee != 0){
1035             uint256 liquidityFee = amount.mul(_SelllLiquidityFee).div(10**(_feeDecimal + 2));
1036             transferAmount = transferAmount.sub(liquidityFee);
1037             _reflectionBalance[address(this)] = _reflectionBalance[address(this)].add(liquidityFee.mul(rate));
1038             if(_isExcluded[address(this)]){
1039                 _tokenBalance[address(this)] = _tokenBalance[address(this)].add(liquidityFee);
1040             }
1041           
1042             emit Transfer(account,address(this),liquidityFee);
1043         }
1044       
1045          if(_SellBurnFee != 0){
1046             uint256 burnFee = amount.mul(_SellBurnFee).div(10**(_feeDecimal + 2));
1047             transferAmount = transferAmount.sub(burnFee);
1048             _reflectionBalance[DEAD] = _reflectionBalance[DEAD].add(burnFee.mul(rate));
1049             if(_isExcluded[DEAD]){
1050                 _tokenBalance[DEAD] = _tokenBalance[DEAD].add(burnFee);
1051             }
1052           
1053             emit Transfer(account,DEAD,burnFee);
1054         }
1055     
1056         
1057         return transferAmount;
1058     }
1059 
1060     function _getReflectionRate() private view returns (uint256) {
1061         uint256 reflectionSupply = _reflectionTotal;
1062         uint256 tokenSupply = _tokenTotal;
1063         for (uint256 i = 0; i < _excluded.length; i++) {
1064             if (
1065                 _reflectionBalance[_excluded[i]] > reflectionSupply ||
1066                 _tokenBalance[_excluded[i]] > tokenSupply
1067             ) return _reflectionTotal.div(_tokenTotal);
1068             reflectionSupply = reflectionSupply.sub(
1069                 _reflectionBalance[_excluded[i]]
1070             );
1071             tokenSupply = tokenSupply.sub(_tokenBalance[_excluded[i]]);
1072         }
1073         if (reflectionSupply < _reflectionTotal.div(_tokenTotal))
1074             return _reflectionTotal.div(_tokenTotal);
1075         return reflectionSupply.div(tokenSupply);
1076     }
1077     
1078     
1079     
1080       function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
1081          if(contractTokenBalance > maxTxAmount){
1082              contractTokenBalance = maxTxAmount;
1083          }
1084         // split the contract balance into halves
1085         uint256 half = contractTokenBalance.div(2);
1086         uint256 otherHalf = contractTokenBalance.sub(half);
1087 
1088         // capture the contract's current ETH balance.
1089         // this is so that we can capture exactly the amount of ETH that the
1090         // swap creates, and not make the liquidity event include any ETH that
1091         // has been manually sent to the contract
1092         uint256 initialBalance = address(this).balance;
1093 
1094         // swap tokens for ETH
1095         swapTokensForEth(half); // <- this breaks the ETH -> HATE swap when swap+liquify is triggered
1096 
1097         // how much ETH did we just swap into?
1098         uint256 newBalance = address(this).balance.sub(initialBalance);
1099 
1100         // add liquidity to uniswap
1101         addLiquidity(otherHalf, newBalance);
1102         
1103         emit SwapAndLiquify(half, newBalance, otherHalf);
1104     }
1105 
1106 
1107      function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1108         // approve token transfer to cover all possible scenarios
1109         _approve(address(this), address(uniswapV2Router), tokenAmount);
1110 
1111         // add the liquidity
1112         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1113             address(this),
1114             tokenAmount,
1115             0, // slippage is unavoidable
1116             0, // slippage is unavoidable
1117             address(this),
1118             block.timestamp
1119         );
1120     }
1121     
1122     
1123     
1124     
1125     function swapTokensForEth(uint256 tokenAmount) private {
1126         // generate the uniswap pair path of token -> weth
1127         address[] memory path = new address[](2);
1128         path[0] = address(this);
1129         path[1] = uniswapV2Router.WETH();
1130 
1131         _approve(address(this), address(uniswapV2Router), tokenAmount);
1132 
1133         // make the swap
1134         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1135             tokenAmount,
1136             0, // accept any amount of ETH
1137             path,
1138             address(this),
1139             block.timestamp
1140         );
1141     }
1142     
1143     function setPair(address pair) external onlyOwner {
1144         uniswapV2Pair = pair;
1145     }
1146 
1147     function setTaxless(address account, bool value) external onlyOwner {
1148         isTaxless[account] = value;
1149     }
1150     
1151     function setSwapAndLiquifyEnabled(bool enabled) external onlyOwner {
1152         swapAndLiquifyEnabled = enabled;
1153         emit SwapAndLiquifyEnabledUpdated(enabled);
1154     }
1155     
1156     function setFeeActive(bool value) external onlyOwner {
1157         isFeeActive = value;
1158     }
1159     
1160     function setBuyFee(uint256 communityFee,uint256 burnFee,uint256 liquidityFee,uint256 taxFee) external onlyOwner {
1161         _CommunityFee = communityFee;
1162         _liquidityFee=liquidityFee;
1163         _burnFee=burnFee;
1164         _taxFee=taxFee;
1165     }
1166     
1167     function setSellFee(uint256 sellCommunityFee,uint256 burnFee,uint256 liquidityFee,uint256 taxFee) external onlyOwner {
1168         _SellCommunityFee= sellCommunityFee;
1169         _SelllLiquidityFee=liquidityFee;
1170         _SelltaxFee=taxFee;
1171         _SellBurnFee=burnFee;
1172     }
1173     
1174     function setWalletAddress(address _communityAddress) external onlyOwner{
1175         communityAddress=_communityAddress;
1176     }
1177     
1178      function setBlackList (address add,bool value) external onlyOwner {
1179         _blackList[add]=value;
1180     }
1181     
1182     function setTrading(bool value) external onlyOwner {
1183         tradingEnable= value;
1184     }
1185     
1186     function exemptMaxTxAmountAddress(address _address,bool value) external onlyOwner {
1187         _maxAmount[_address] = value;
1188     }
1189     
1190     function exemptMaxWalletAmountAddress(address _address,bool value) external onlyOwner {
1191         _maxWallet[_address] =value;
1192     }
1193     
1194     function setMaxWalletAmount(uint256 amount) external onlyOwner {
1195         _maxWalletToken = amount;
1196     }
1197  
1198     function setMaxTxAmount(uint256 amount) external onlyOwner {
1199         maxTxAmount = amount;
1200     }
1201     
1202     function setMinTokensBeforeSwap(uint256 amount) external onlyOwner {
1203         minTokensBeforeSwap = amount;
1204     }
1205 
1206     receive() external payable {}
1207 }