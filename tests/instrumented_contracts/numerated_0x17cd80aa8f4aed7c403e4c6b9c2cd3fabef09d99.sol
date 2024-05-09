1 pragma solidity ^0.8.10;
2 // SPDX-License-Identifier: MIT
3 
4 interface IERC20 {
5 
6     /**  
7      * @dev Returns the total tokens supply  
8      */
9     function totalSupply() external view returns (uint256);
10 
11     /**
12      * @dev Returns the amount of tokens owned by `account`.
13      */
14     function balanceOf(address account) external view returns (uint256);
15 
16     /**
17      * @dev Moves `amount` tokens from the caller's account to `recipient`.
18      *
19      * Returns a boolean value indicating whether the operation succeeded.
20      *
21      * Emits a {Transfer} event.
22      */
23     function transfer(address recipient, uint256 amount) external returns (bool);
24 
25     /**
26      * @dev Returns the remaining number of tokens that `spender` will be
27      * allowed to spend on behalf of `owner` through {transferFrom}. This is
28      * zero by default.
29      *
30      * This value changes when {approve} or {transferFrom} are called.
31      */
32     function allowance(address owner, address spender) external view returns (uint256);
33 
34     /**
35      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * IMPORTANT: Beware that changing an allowance with this method brings the risk
40      * that someone may use both the old and the new allowance by unfortunate
41      * transaction ordering. One possible solution to mitigate this race
42      * condition is to first reduce the spender's allowance to 0 and set the
43      * desired value afterwards:
44      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
45      *
46      * Emits an {Approval} event.
47      */
48     function approve(address spender, uint256 amount) external returns (bool);
49 
50     /**
51      * @dev Moves `amount` tokens from `sender` to `recipient` using the
52      * allowance mechanism. `amount` is then deducted from the caller's
53      * allowance.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Emitted when `value` tokens are moved from one account (`from`) to
63      * another (`to`).
64      *
65      * Note that `value` may be zero.
66      */
67     event Transfer(address indexed from, address indexed to, uint256 value);
68 
69     /**
70      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
71      * a call to {approve}. `value` is the new allowance.
72      */
73     event Approval(address indexed owner, address indexed spender, uint256 value);
74 }
75 
76 // CAUTION
77 // This version of SafeMath should only be used with Solidity 0.8 or later,
78 // because it relies on the compiler's built in overflow checks.
79 
80 /**
81  * @dev Wrappers over Solidity's arithmetic operations.
82  *
83  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
84  * now has built in overflow checking.
85  */
86 library SafeMath {
87 
88     /**
89      * @dev Returns the addition of two unsigned integers, reverting on
90      * overflow.
91      *
92      * Counterpart to Solidity's `+` operator.
93      *
94      * Requirements:
95      *
96      * - Addition cannot overflow.
97      */
98     function add(uint256 a, uint256 b) internal pure returns (uint256) {
99         return a + b;
100     }
101 
102     /**
103      * @dev Returns the subtraction of two unsigned integers, reverting on
104      * overflow (when the result is negative).
105      *
106      * Counterpart to Solidity's `-` operator.
107      *
108      * Requirements:
109      *
110      * - Subtraction cannot overflow.
111      */
112     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
113         return a - b;
114     }
115 
116     /**
117      * @dev Returns the multiplication of two unsigned integers, reverting on
118      * overflow.
119      *
120      * Counterpart to Solidity's `*` operator.
121      *
122      * Requirements:
123      *
124      * - Multiplication cannot overflow.
125      */
126     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
127         return a * b;
128     }
129 
130     /**
131      * @dev Returns the integer division of two unsigned integers, reverting on
132      * division by zero. The result is rounded towards zero.
133      *
134      * Counterpart to Solidity's `/` operator.
135      *
136      * Requirements:
137      *
138      * - The divisor cannot be zero.
139      */
140     function div(uint256 a, uint256 b) internal pure returns (uint256) {
141         return a / b;
142     }
143 
144     /**
145      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
146      * reverting when dividing by zero.
147      *
148      * Counterpart to Solidity's `%` operator. This function uses a `revert`
149      * opcode (which leaves remaining gas untouched) while Solidity uses an
150      * invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      *
154      * - The divisor cannot be zero.
155      */
156     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
157         return a % b;
158     }
159 
160     /**
161      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
162      * overflow (when the result is negative).
163      *
164      * CAUTION: This function is deprecated because it requires allocating memory for the error
165      * message unnecessarily. For custom revert reasons use {trySub}.
166      *
167      * Counterpart to Solidity's `-` operator.
168      *
169      * Requirements:
170      *
171      * - Subtraction cannot overflow.
172      */
173     function sub(
174         uint256 a,
175         uint256 b,
176         string memory errorMessage
177     ) internal pure returns (uint256) {
178         unchecked {
179             require(b <= a, errorMessage);
180             return a - b;
181         }
182     }
183 
184     /**
185      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
186      * division by zero. The result is rounded towards zero.
187      *
188      * Counterpart to Solidity's `/` operator. Note: this function uses a
189      * `revert` opcode (which leaves remaining gas untouched) while Solidity
190      * uses an invalid opcode to revert (consuming all remaining gas).
191      *
192      * Requirements:
193      *
194      * - The divisor cannot be zero.
195      */
196     function div(
197         uint256 a,
198         uint256 b,
199         string memory errorMessage
200     ) internal pure returns (uint256) {
201         unchecked {
202             require(b > 0, errorMessage);
203             return a / b;
204         }
205     }
206 
207     /**
208      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
209      * reverting with custom message when dividing by zero.
210      *
211      * CAUTION: This function is deprecated because it requires allocating memory for the error
212      * message unnecessarily. For custom revert reasons use {tryMod}.
213      *
214      * Counterpart to Solidity's `%` operator. This function uses a `revert`
215      * opcode (which leaves remaining gas untouched) while Solidity uses an
216      * invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function mod(
223         uint256 a,
224         uint256 b,
225         string memory errorMessage
226     ) internal pure returns (uint256) {
227         unchecked {
228             require(b > 0, errorMessage);
229             return a % b;
230         }
231     }
232 }
233 
234 abstract contract Context {
235     function _msgSender() internal view virtual returns (address payable) {
236         return payable(msg.sender);
237     }
238 
239     function _msgData() internal view virtual returns (bytes memory) {
240         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
241         return msg.data; // msg.data is used to handle array, bytes, string 
242     }
243 }
244 
245 
246 /**
247  * @dev Collection of functions related to the address type
248  */
249 library Address {
250     /**
251      * @dev Returns true if `account` is a contract.
252      *
253      * [IMPORTANT]
254      * ====
255      * It is unsafe to assume that an address for which this function returns
256      * false is an externally-owned account (EOA) and not a contract.
257      *
258      * Among others, `isContract` will return false for the following
259      * types of addresses:
260      *
261      *  - an externally-owned account
262      *  - a contract in construction
263      *  - an address where a contract will be created
264      *  - an address where a contract lived, but was destroyed
265      * ====
266      */
267     function isContract(address account) internal view returns (bool) {
268         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
269         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
270         // for accounts without code, i.e. `keccak256('')`
271         bytes32 codehash;
272         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
273         // solhint-disable-next-line no-inline-assembly
274         assembly { codehash := extcodehash(account) }
275         return (codehash != accountHash && codehash != 0x0);
276     }
277 
278     /**
279      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
280      * `recipient`, forwarding all available gas and reverting on errors.
281      *
282      * increases the gas cost
283      * of certain opcodes, possibly making contracts go over the 2300 gas limit
284      * imposed by `transfer`, making them unable to receive funds via
285      * `transfer`. {sendValue} removes this limitation.
286      *
287      *
288      * IMPORTANT: because control is transferred to `recipient`, care must be
289      * taken to not create reentrancy vulnerabilities. Consider using
290      * {ReentrancyGuard} or the
291      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
292      */
293     function sendValue(address payable recipient, uint256 amount) internal {
294         require(address(this).balance >= amount, "Address: insufficient balance");
295 
296         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
297         (bool success, ) = recipient.call{ value: amount }("");
298         require(success, "Address: unable to send value, recipient may have reverted");
299     }
300 
301     /**
302      * @dev Performs a Solidity function call using a low level `call`. A
303      * plain`call` is an unsafe replacement for a function call: use this
304      * function instead.
305      *
306      * If `target` reverts with a revert reason, it is bubbled up by this
307      * function (like regular Solidity function calls).
308      *
309      * Returns the raw returned data. To convert to the expected return value,
310      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
311      *
312      * Requirements:
313      *
314      * - `target` must be a contract.
315      * - calling `target` with `data` must not revert.
316      *
317      * _Available since v3.1._
318      */
319     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
320       return functionCall(target, data, "Address: low-level call failed");
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
325      * `errorMessage` as a fallback revert reason when `target` reverts.
326      *
327      * _Available since v3.1._
328      */
329     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
330         return _functionCallWithValue(target, data, 0, errorMessage);
331     }
332 
333     /**
334      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
335      * but also transferring `value` wei to `target`.
336      *
337      * Requirements:
338      *
339      * - the calling contract must have an ETH balance of at least `value`.
340      * - the called Solidity function must be `payable`.
341      *
342      * _Available since v3.1._
343      */
344     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
345         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
350      * with `errorMessage` as a fallback revert reason when `target` reverts.
351      *
352      * _Available since v3.1._
353      */
354     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
355         require(address(this).balance >= value, "Address: insufficient balance for call");
356         return _functionCallWithValue(target, data, value, errorMessage);
357     }
358 
359     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
360         require(isContract(target), "Address: call to non-contract");
361 
362         // solhint-disable-next-line avoid-low-level-calls
363         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
364         if (success) {
365             return returndata;
366         } else {
367             // Look for revert reason and bubble it up if present
368             if (returndata.length > 0) {
369                 // The easiest way to bubble the revert reason is using memory via assembly
370 
371                 // solhint-disable-next-line no-inline-assembly
372                 assembly {
373                     let returndata_size := mload(returndata)
374                     revert(add(32, returndata), returndata_size)
375                 }
376             } else {
377                 revert(errorMessage);
378             }
379         }
380     }
381 }
382 
383 /**
384  * @dev Contract module which provides a basic access control mechanism, where
385  * there is an account (an owner) that can be granted exclusive access to
386  * specific functions.
387  *
388  * By default, the owner account will be the one that deploys the contract. This
389  * can later be changed with {transferOwnership}.
390  *
391  * This module is used through inheritance. It will make available the modifier
392  * `onlyOwner`, which can be applied to your functions to restrict their use to
393  * the owner.
394  */
395 contract Ownable is Context {
396     address private _owner;
397     address private _previousOwner;
398     uint256 private _lockTime;
399 
400     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
401 
402     /**
403      * @dev Initializes the contract setting the deployer as the initial owner.
404      */
405     constructor () {
406         address msgSender = _msgSender();
407         _owner = msgSender;
408         emit OwnershipTransferred(address(0), msgSender);
409     }
410 
411     /**
412      * @dev Returns the address of the current owner.
413      */
414     function owner() public view returns (address) {
415         return _owner;
416     }
417 
418     /**
419      * @dev Throws if called by any account other than the owner.
420      */
421     modifier onlyOwner() {
422         require(_owner == _msgSender(), "Ownable: caller is not the owner");
423         _;
424     }
425 
426      /**
427      * @dev Leaves the contract without owner. It will not be possible to call
428      * `onlyOwner` functions anymore. Can only be called by the current owner.
429      *
430      * NOTE: Renouncing ownership will leave the contract without an owner,
431      * thereby removing any functionality that is only available to the owner.
432      */
433     function renounceOwnership() external virtual onlyOwner {
434         emit OwnershipTransferred(_owner, address(0));
435         _owner = address(0);
436     }
437 
438     /**
439      * @dev Transfers ownership of the contract to a new account (`newOwner`).
440      * Can only be called by the current owner.
441      */
442     function transferOwnership(address newOwner) external virtual onlyOwner {
443         require(newOwner != address(0), "Ownable: new owner is the zero address");
444         emit OwnershipTransferred(_owner, newOwner);
445         _owner = newOwner;
446     }
447     
448     function getUnlockTime() external view returns (uint256) {
449         return _lockTime;
450     }
451 
452     //Locks the contract for owner for the amount of time provided
453     function lock(uint256 time) external virtual onlyOwner {
454         _previousOwner = _owner;
455         _owner = address(0);
456         _lockTime = block.timestamp + time;
457         emit OwnershipTransferred(_owner, address(0));
458     }
459     
460     //Unlocks the contract for owner when _lockTime is exceeds
461     function unlock() external virtual {
462         require(_previousOwner == msg.sender, "You don't have permission to unlock");
463         require(block.timestamp > _lockTime , "Contract is locked until 7 days");
464         emit OwnershipTransferred(_owner, _previousOwner);
465         _owner = _previousOwner;
466         _previousOwner = address(0);
467     }
468 }
469 
470 // pragma solidity >=0.5.0;
471 
472 interface IUniSwapFactory {
473     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
474 
475     function createPair(address tokenA, address tokenB) external returns (address pair);
476 
477 }
478 
479 // pragma solidity >=0.6.2;
480 
481 interface IUniSwapRouter {
482     function factory() external pure returns (address);
483     function WETH() external pure returns (address);
484 
485     function addLiquidity(
486         address tokenA,
487         address tokenB,
488         uint amountADesired,
489         uint amountBDesired,
490         uint amountAMin,
491         uint amountBMin,
492         address to,
493         uint deadline
494     ) external returns (uint amountA, uint amountB, uint liquidity);
495     function addLiquidityETH(
496         address token,
497         uint amountTokenDesired,
498         uint amountTokenMin,
499         uint amountETHMin,
500         address to,
501         uint deadline
502     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
503     function swapExactTokensForETHSupportingFeeOnTransferTokens(
504         uint amountIn,
505         uint amountOutMin,
506         address[] calldata path,
507         address to,
508         uint deadline
509     ) external;
510 }
511 
512 
513 
514 contract METAPETS is Context, IERC20, Ownable {
515     using SafeMath for uint256;
516     using Address for address;
517 
518     mapping (address => uint256) private _tOwned; // total Owned tokens
519     mapping (address => mapping (address => uint256)) private _allowances; // allowed allowance for spender
520     mapping (address => bool) public isExcludedFromAntiWhale; // Limits how many tokens can an address hold
521 
522     mapping (address => bool) public isExcludedFromFee; // excluded address from all fee
523 
524     mapping (address => uint256) private _transactionCheckpoint;
525     mapping(address => bool) public isExcludedFromTransactionCoolDown; // Address to be excluded from transaction cooldown
526     uint256 private _transactionCoolTime = 120; //Cool down time between each transaction per address
527     
528     mapping (address => bool) public isBlacklisted; // blocks an address from buy and selling
529 
530     address payable public maintainanceAddress = payable(0x71d2EBB87c1b8be5d7527b55c63e27312494D361); // Maintainance Address
531     address payable public developmentAddress  = payable(0x57C7CB16A480232CC479D85A3c962e826FA0f3C3); // Development Address
532     address payable public marketingAddress    = payable(0x80F37688dD7850ac3B5884066C03897d9fF5cA0c); // Marketing Address
533 
534     string private _name = "Meta Pets"; //token name
535     string private _symbol = "$MP"; // token symbol
536     uint8 private _decimals = 18; // 1 token can be divided into 1e_decimals parts
537 
538     uint256 private _tTotal = 1000000 * 10**6 * 10**_decimals;
539     
540     // All fees are with one decimal value. so if you want 0.5 set value to 5, for 10 set 100. so on...
541 
542     // Below Fees to be deducted and sent as ETH
543     uint256 public liquidityFee = 20; // actual liquidity fee 2%
544 
545     uint256 public marketingFee = 60; // marketing fee 6%
546 
547     uint256 public developmentFee = 30; // development fee 3%
548 
549     uint256 public maintainanceFee = 10; // Project Maintainance fee 1%
550 
551     uint256 public sellExtraFee = 20; // extra fee on sell 2%.
552 
553     uint256 private _totalFee =liquidityFee.add(marketingFee).add(developmentFee).add(maintainanceFee); // Liquidity + Marketing + Development + Mainitainance fee on each transaction
554     uint256 private _previousTotalFee = _totalFee; // restore old fees
555 
556     bool public antiBotEnabled = true; //enables anti bot restrictions(max txn amount, max wallet holding transaction cooldown)
557 
558     IUniSwapRouter public uniSwapRouter; // uniSwap router assiged using address
559     address public uniSwapPair; // for creating WETH pair with our token
560     
561     bool inSwapAndLiquify; // after each successfull swapandliquify disable the swapandliquify
562     bool public swapAndLiquifyEnabled = true; // set auto swap to ETH and liquify collected liquidity fee
563     
564     uint256 public maxTxnAmount = 1000 * 10**6 * 10**_decimals; // max allowed tokens tranfer per transaction
565     uint256 public minTokensSwapToAndTransferTo = 500 * 10**6 * 10**_decimals; // min token liquidity fee collected before swapandLiquify
566     uint256 public maxTokensPerAddress            = 2000 * 10**6 * 10**_decimals; // Max number of tokens that an address can hold
567 
568     
569     event MinTokensBeforeSwapUpdated(uint256 minTokensBeforeSwap); //event fire min token liquidity fee collected before swapandLiquify 
570     event SwapAndLiquifyEnabledUpdated(bool enabled); // event fire set auto swap to ETH and liquify collected liquidity fee
571     event SwapAndLiquify(
572         uint256 tokensSwapped,
573         uint256 ethReceived,
574         uint256 tokensIntoLiqiudity
575     ); // fire event how many tokens were swapedandLiquified
576     
577     modifier lockTheSwap {
578         inSwapAndLiquify = true;
579         _;
580         inSwapAndLiquify = false;
581     } // modifier to after each successfull swapandliquify disable the swapandliquify
582     
583     constructor () {
584         _tOwned[_msgSender()] = _tTotal; // assigning the max token to owner's address  
585         
586         IUniSwapRouter _uniSwapRouter = IUniSwapRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
587          // Create a uniSwap pair for this new token
588         uniSwapPair = IUniSwapFactory(_uniSwapRouter.factory())
589             .createPair(address(this), _uniSwapRouter.WETH());    
590 
591         // set the rest of the contract variables
592         uniSwapRouter = _uniSwapRouter;
593         
594         //exclude owner and this contract from fee
595         isExcludedFromFee[owner()]             = true;
596         isExcludedFromFee[address(this)]       = true;
597         isExcludedFromFee[marketingAddress]    = true;
598         isExcludedFromFee[developmentAddress]  = true;
599         isExcludedFromFee[maintainanceAddress] = true;
600 
601         //Exclude's below addresses from per account tokens limit
602         isExcludedFromAntiWhale[owner()]                 = true;
603         isExcludedFromAntiWhale[uniSwapPair]             = true;
604         isExcludedFromAntiWhale[address(this)]           = true;
605         isExcludedFromAntiWhale[marketingAddress]        = true;
606         isExcludedFromAntiWhale[developmentAddress]      = true;
607         isExcludedFromAntiWhale[maintainanceAddress]     = true;
608         isExcludedFromAntiWhale[address(_uniSwapRouter)] = true;
609 
610         //Exclude's below addresses from transaction cooldown
611         isExcludedFromTransactionCoolDown[owner()]                 = true;
612         isExcludedFromTransactionCoolDown[uniSwapPair]             = true;
613         isExcludedFromTransactionCoolDown[address(this)]           = true;
614         isExcludedFromTransactionCoolDown[marketingAddress]        = true;
615         isExcludedFromTransactionCoolDown[developmentAddress]      = true;
616         isExcludedFromTransactionCoolDown[maintainanceAddress]     = true;
617         isExcludedFromTransactionCoolDown[address(_uniSwapRouter)] = true;
618 
619         emit Transfer(address(0), _msgSender(), _tTotal);
620     }
621 
622     function name() public view returns (string memory) {
623         return _name;
624     }
625 
626     function symbol() public view returns (string memory) {
627         return _symbol;
628     }
629 
630     function decimals() public view returns (uint8) {
631         return _decimals;
632     }
633 
634     function totalSupply() public view override returns (uint256) {
635         return _tTotal;
636     }
637 
638     function balanceOf(address account) public view override returns (uint256) {
639         return _tOwned[account];
640     }
641 
642     function transfer(address recipient, uint256 amount) public override returns (bool) {
643         _transfer(_msgSender(), recipient, amount);
644         return true;
645     }
646 
647     function allowance(address owner, address spender) public view override returns (uint256) {
648         return _allowances[owner][spender];
649     }
650     
651     /**  
652      * @dev approves allowance of a spender
653      */
654     function approve(address spender, uint256 amount) public override returns (bool) {
655         _approve(_msgSender(), spender, amount);
656         return true;
657     }
658     
659     /**  
660      * @dev transfers from a sender to receipent with subtracting spenders allowance with each successfull transfer
661      */
662     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
663         _transfer(sender, recipient, amount);
664         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
665          return true;
666     }
667 
668     /**  
669      * @dev approves allowance of a spender should set it to zero first than increase
670      */
671     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
672         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
673         return true;
674     }
675 
676     /**  
677      * @dev decrease allowance of spender that it can spend on behalf of owner
678      */
679     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
680         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
681         return true;
682     }
683 
684     /**  
685      * @dev exclude an address from fee
686      */
687     function excludeFromFee(address account) external onlyOwner {
688         isExcludedFromFee[account] = true;
689     }
690     
691     /**  
692      * @dev include an address for fee
693      */
694     function includeInFee(address account) external onlyOwner {
695         isExcludedFromFee[account] = false;
696     }
697 
698     /**  
699      * @dev exclude an address from per address tokens limit
700      */
701     function excludedFromAntiWhale(address account) external onlyOwner {
702         isExcludedFromAntiWhale[account] = true;
703     }
704 
705     /**  
706      * @dev include an address in per address tokens limit
707      */
708     function includeInAntiWhale(address account) external onlyOwner {
709         isExcludedFromAntiWhale[account] = false;
710     }
711 
712     /**  
713      * @dev set's Development fee percentage
714      */
715     function setDevelopmentFeePercent(uint256 Fee) external onlyOwner {
716         developmentFee = Fee;
717         _totalFee = liquidityFee.add(marketingFee).add(developmentFee).add(maintainanceFee);
718     }
719 
720         /**  
721      * @dev set's marketing fee percentage
722      */
723     function setMarketingFeePercent(uint256 Fee) external onlyOwner {
724         marketingFee = Fee;
725         _totalFee = liquidityFee.add(marketingFee).add(developmentFee).add(maintainanceFee);
726     }
727 
728     /**  
729      * @dev set's Maintainance fee percentage
730      */
731     function setMaintainanceFeePercent(uint256 Fee) external onlyOwner {
732         maintainanceFee = Fee;
733         _totalFee = liquidityFee.add(marketingFee).add(developmentFee).add(maintainanceFee);
734     }
735     
736     /**  
737      * @dev set's liquidity fee percentage
738      */
739     function setLiquidityFeePercent(uint256 Fee) external onlyOwner {
740         liquidityFee = Fee;
741         _totalFee = liquidityFee.add(marketingFee).add(developmentFee).add(maintainanceFee);
742     }
743 
744     /**  
745      * @dev set's sell extra fee percentage
746      */
747     function setSellExtraFeePercent(uint256 Fee) external onlyOwner {
748         sellExtraFee = Fee;
749     }
750    
751     /**  
752      * @dev set's max amount of tokens percentage 
753      * that can be transfered in each transaction from an address
754      */
755     function setMaxTxnTokens(uint256 maxTxnTokens) external onlyOwner {
756         maxTxnAmount = maxTxnTokens.mul( 10**_decimals );
757     }
758 
759     /**  
760      * @dev set's max amount of tokens
761      * that an address can hold
762      */
763     function setMaxTokenPerAddress(uint256 maxTokens) external onlyOwner {
764         maxTokensPerAddress = maxTokens.mul( 10**_decimals );
765     }
766 
767     /**  
768      * @dev set's minimmun amount of tokens required 
769      * before swaped and ETH send to  wallet
770      * same value will be used for auto swapandliquifiy threshold
771      */
772     function setMinTokensSwapAndTransfer(uint256 minAmount) external onlyOwner {
773         minTokensSwapToAndTransferTo = minAmount.mul( 10 ** _decimals);
774     }
775 
776     /**  
777      * @dev set's marketing address
778      */
779     function setMarketingFeeAddress(address payable wallet) external onlyOwner {
780         marketingAddress = wallet;
781     }
782 
783     /**  
784      * @dev set's development address
785      */
786     function setDevelopmentFeeAddress(address payable wallet) external onlyOwner {
787         developmentAddress = wallet;
788     }
789 
790     /**  
791      * @dev set's maintainnance address
792      */
793     function setMaintainaceFeeAddress(address payable wallet) external onlyOwner {
794         maintainanceAddress = wallet;
795     }
796 
797     /**  
798      * @dev set's auto SwapandLiquify when contract's token balance threshold is reached
799      */
800     function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
801         swapAndLiquifyEnabled = _enabled;
802         emit SwapAndLiquifyEnabledUpdated(_enabled);
803     }
804 
805     /**
806 	* @dev Sets transactions on time periods or cooldowns. Buzz Buzz Bots.
807 	* Can only be set by owner set in seconds.
808 	*/
809 	function setTransactionCooldownTime(uint256 transactiontime) external onlyOwner {
810 		_transactionCoolTime = transactiontime;
811 	}
812 
813     /**
814 	 * @dev Exclude's an address from transactions from cooldowns.
815 	 * Can only be set by owner.
816 	 */
817 	function excludedFromTransactionCooldown(address account) external onlyOwner {
818 		isExcludedFromTransactionCoolDown[account] = true;
819 	}
820 
821     /**
822 	 * @dev Include's an address in transactions from cooldowns.
823 	 * Can only be set by owner.
824 	 */
825 	function includeInTransactionCooldown(address account) external onlyOwner {
826 		isExcludedFromTransactionCoolDown[account] = false;
827 	}
828 
829     /**
830 	 * @dev enable/disable antibot measures
831 	 */
832     function setAntiBotEnabled(bool value) external onlyOwner {
833         antiBotEnabled = value;
834     }
835     
836      //to recieve ETH from uniSwapRouter when swaping
837     receive() external payable {}
838 
839     /**  
840      * @dev get/calculates all values e.g taxfee, 
841      * liquidity fee, actual transfer amount to receiver, 
842      * deuction amount from sender
843      * amount with reward to all holders
844      * amount without reward to all holders
845      */
846     function _getValues(uint256 tAmount) private view returns (uint256, uint256) {
847         uint256 tFee = calculateFee(tAmount);
848         uint256 tTransferAmount = tAmount.sub(tFee);
849         return (tTransferAmount, tFee);
850     }
851     
852     /**  
853      * @dev take's fee tokens from tansaction and saves in contract
854      */
855     function _takeFee(address account, uint256 tFee) private {
856         if(tFee > 0) {
857             _tOwned[address(this)] = _tOwned[address(this)].add(tFee);
858             emit Transfer(account, address(this), tFee);
859         }
860     }
861 
862     /**  
863      * @dev calculates fee tokens to be deducted
864      */
865     function calculateFee(uint256 _amount) private view returns (uint256) {
866         return _amount.mul(_totalFee).div(
867             10**3
868         );
869     }
870 
871     /**  
872      * @dev increase fee if selling
873      */
874     function increaseFee() private {
875         _totalFee = _totalFee.add(sellExtraFee);
876     }
877     
878     /**  
879      * @dev removes all fee from transaction if takefee is set to false
880      */
881     function removeAllFee() private {
882         if(_totalFee == 0) return;
883         
884         _previousTotalFee = _totalFee;
885         _totalFee = 0;
886     }
887 
888     /**  
889      * @dev restores all fee after exclude fee transaction completes
890      */
891     function restoreAllFee() private {
892         _totalFee = _previousTotalFee;
893     }
894 
895     /**  
896      * @dev decrease fee after selling
897      */
898     function decreaseFee() private {
899         _totalFee = _totalFee.sub(sellExtraFee);
900     }
901 
902     /**  
903      * @dev approves amount of token spender can spend on behalf of an owner
904      */
905     function _approve(address owner, address spender, uint256 amount) private {
906         require(owner != address(0), "ERC20: approve from the zero address");
907         require(spender != address(0), "ERC20: approve to the zero address");
908 
909         _allowances[owner][spender] = amount;
910         emit Approval(owner, spender, amount);
911     }
912 
913     /**  
914      * @dev transfers token from sender to recipient also auto 
915      * swapsandliquify if contract's token balance threshold is reached
916      */
917     function _transfer(
918         address from,
919         address to,
920         uint256 amount
921     ) private {
922         require(from != address(0) && to != address(0), "ERC20: transfer from or two the zero address");
923         require(!isBlacklisted[from], "You are Blacklisted");
924         if(antiBotEnabled) {
925             require(balanceOf(to) + amount <= maxTokensPerAddress || isExcludedFromAntiWhale[to],
926             "Max tokens limit for this account exceeded. Or try lower amount");
927             require(isExcludedFromTransactionCoolDown[from] || block.timestamp >= _transactionCheckpoint[from] + _transactionCoolTime,
928             "Wait for transaction cooldown time to end before making a tansaction");
929             require(isExcludedFromTransactionCoolDown[to] || block.timestamp >= _transactionCheckpoint[to] + _transactionCoolTime,
930             "Wait for transaction cooldown time to end before making a tansaction");
931             if(from != owner() && to != owner())
932                 require(amount <= maxTxnAmount, "Transfer amount exceeds the maxTxAmount.");
933 
934             _transactionCheckpoint[from] = block.timestamp;
935             _transactionCheckpoint[to] = block.timestamp;
936         }
937 
938         // is the token balance of this contract address over the min number of
939         // tokens that we need to initiate a swap + liquidity lock?
940         // also, don't get caught in a circular liquidity event.
941         // also, don't swap & liquify if sender is uniSwap pair.
942         uint256 contractTokenBalance = balanceOf(address(this));
943         
944         if(contractTokenBalance >= maxTxnAmount)
945         {
946             contractTokenBalance = maxTxnAmount;
947         }
948         
949         bool overMinTokenBalance = contractTokenBalance >=minTokensSwapToAndTransferTo;
950         if (
951             overMinTokenBalance &&
952             !inSwapAndLiquify &&
953             from != uniSwapPair &&
954             swapAndLiquifyEnabled
955         ) {
956             contractTokenBalance =minTokensSwapToAndTransferTo;
957             //add liquidity
958             swapAndLiquify(contractTokenBalance);
959         }
960         
961         //indicates if fee should be deducted from transfer
962         bool takeFee = true;
963         
964         //if any account belongs to isExcludedFromFee account then remove the fee
965         if(isExcludedFromFee[from] || isExcludedFromFee[to]){
966             takeFee = false;
967         }
968         
969         //transfer amount, it will take tax fee
970         _tokenTransfer(from,to,amount,takeFee);
971     }
972 
973     /**  
974      * @dev swapsAndLiquify tokens to uniSwap if swapandliquify is enabled
975      */
976     function swapAndLiquify(uint256 tokenBalance) private lockTheSwap {
977         // first split contract into marketing fee and liquidity fee
978         uint256 swapPercent = developmentFee.add(marketingFee).add(maintainanceFee).add(liquidityFee/2);
979         uint256 swapTokens = tokenBalance.div(_totalFee).mul(swapPercent);
980         uint256 liquidityTokens = tokenBalance.sub(swapTokens);
981         uint256 initialBalance = address(this).balance;
982         
983         swapTokensForEth(swapTokens);
984 
985         uint256 transferredBalance = address(this).balance.sub(initialBalance);
986         uint256 developmentAmount = 0;
987         uint256 maintainanceAmount = 0;
988         uint256 marketingAmount = 0;
989 
990         if(developmentFee > 0)
991         {
992             developmentAmount = transferredBalance.mul(developmentFee).div(swapPercent);
993 
994             developmentAddress.transfer(developmentAmount);
995         }
996 
997         if(marketingFee > 0)
998         {
999             marketingAmount = transferredBalance.mul(marketingFee).div(swapPercent);
1000 
1001             marketingAddress.transfer(marketingAmount);
1002         }
1003 
1004         if(maintainanceFee > 0)
1005         {
1006             maintainanceAmount = transferredBalance.mul(maintainanceFee).div(swapPercent);
1007 
1008             maintainanceAddress.transfer(maintainanceAmount);
1009         }
1010         
1011         if(liquidityFee > 0)
1012         {
1013             transferredBalance = transferredBalance.sub(developmentAmount).sub(marketingAmount).sub(maintainanceAmount);
1014             addLiquidity(owner(), liquidityTokens, transferredBalance);
1015 
1016             emit SwapAndLiquify(liquidityTokens, transferredBalance, liquidityTokens);
1017         }
1018     }
1019 
1020     /**  
1021      * @dev swap's exact amount of tokens for ETH if swapandliquify is enabled
1022      */
1023     function swapTokensForEth(uint256 tokenAmount) private {
1024         // generate the uniSwap pair path of token -> weth
1025         address[] memory path = new address[](2);
1026         path[0] = address(this);
1027         path[1] = uniSwapRouter.WETH();
1028 
1029         _approve(address(this), address(uniSwapRouter), tokenAmount);
1030 
1031         // make the swap
1032         uniSwapRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1033             tokenAmount,
1034             0, // accept any amount of ETH
1035             path,
1036             address(this),
1037             block.timestamp
1038         );
1039     }
1040 
1041     /**  
1042      * @dev add's liquidy to uniSwap if swapandliquify is enabled
1043      */
1044     function addLiquidity(address recipient, uint256 tokenAmount, uint256 ethAmount) private {
1045         // approve token transfer to cover all possible scenarios
1046         _approve(address(this), address(uniSwapRouter), tokenAmount);
1047 
1048         // add the liquidity
1049         uniSwapRouter.addLiquidityETH{value: ethAmount}(
1050             address(this),
1051             tokenAmount,
1052             0, // slippage is unavoidable
1053             0, // slippage is unavoidable
1054             recipient,
1055             block.timestamp
1056         );
1057     }
1058 
1059     //this method is responsible for taking all fee, if takeFee is true
1060     function _tokenTransfer(address sender, address recipient, uint256 amount,bool takeFee) private {
1061         if(recipient == uniSwapPair && sellExtraFee > 0)
1062             increaseFee();
1063         if(!takeFee)
1064             removeAllFee();
1065 
1066         (uint256 tTransferAmount, uint256 tFee) = _getValues(amount);
1067         _tOwned[sender] = _tOwned[sender].sub(amount);
1068         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
1069 
1070         _takeFee(sender, tFee);
1071         emit Transfer(sender, recipient, tTransferAmount);
1072         
1073         
1074         if(!takeFee)
1075             restoreAllFee();
1076         if(recipient == uniSwapPair && sellExtraFee > 0)
1077             decreaseFee();
1078     }
1079 
1080 
1081     /**  
1082      * @dev Blacklist a singel wallet from buying and selling
1083      */
1084     function blacklistSingleWallet(address account) external onlyOwner{
1085         if(isBlacklisted[account] == true) return;
1086         isBlacklisted[account] = true;
1087     }
1088 
1089     /**  
1090      * @dev Blacklist multiple wallets from buying and selling
1091      */
1092     function blacklistMultipleWallets(address[] calldata accounts) external onlyOwner{
1093         require(accounts.length < 800, "Can not blacklist more then 800 address in one transaction");
1094         for (uint256 i; i < accounts.length; ++i) {
1095             isBlacklisted[accounts[i]] = true;
1096         }
1097     }
1098     
1099     /**  
1100      * @dev un blacklist a singel wallet from buying and selling
1101      */
1102     function unBlacklistSingleWallet(address account) external onlyOwner{
1103          if(isBlacklisted[account] == false) return;
1104         isBlacklisted[account] = false;
1105     }
1106 
1107     /**  
1108      * @dev un blacklist multiple wallets from buying and selling
1109      */
1110     function unBlacklistMultipleWallets(address[] calldata accounts) external onlyOwner {
1111         require(accounts.length < 800, "Can not Unblacklist more then 800 address in one transaction");
1112         for (uint256 i; i < accounts.length; ++i) {
1113             isBlacklisted[accounts[i]] = false;
1114         }
1115     }
1116 
1117     /**  
1118      * @dev recovers any tokens stuck in Contract's address
1119      * NOTE! if ownership is renounced then it will not work
1120      */
1121     function recoverTokens(address tokenAddress, address recipient, uint256 amountToRecover) external onlyOwner {
1122         IERC20 token = IERC20(tokenAddress);
1123         uint256 balance = token.balanceOf(address(this));
1124         
1125         require(balance >= amountToRecover, "Not Enough Tokens in contract to recover");
1126 
1127         if(amountToRecover > 0)
1128             token.transfer(recipient, amountToRecover);
1129     }
1130     
1131     /**  
1132      * @dev recovers any ETH stuck in Contract's balance
1133      * NOTE! if ownership is renounced then it will not work
1134      */
1135     function recoverETH() external onlyOwner {
1136         address payable recipient = _msgSender();
1137         if(address(this).balance > 0)
1138             recipient.transfer(address(this).balance);
1139     }
1140     
1141     //New uniswap router version?
1142     //No problem, just change it!
1143     function setRouterAddress(address newRouter) external onlyOwner {
1144         IUniSwapRouter _newUniSwapRouter = IUniSwapRouter(newRouter);
1145         uniSwapPair = IUniSwapFactory(_newUniSwapRouter.factory()).createPair(address(this), _newUniSwapRouter.WETH());
1146         uniSwapRouter = _newUniSwapRouter;
1147 
1148         isExcludedFromAntiWhale[uniSwapPair]           = true;
1149         isExcludedFromTransactionCoolDown[uniSwapPair] = true;
1150     }
1151 
1152 }