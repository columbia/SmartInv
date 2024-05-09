1 //                                                                                                                       
2 //     d888888o.            .8.          8 88888888888  8 88888888888       ,o888888o.           .8.    8888888 8888888888 
3 //   .`8888:' `88.         .888.         8 8888         8 8888             8888     `88.        .888.         8 8888       
4 //   8.`8888.   Y8        :88888.        8 8888         8 8888          ,8 8888       `8.      :88888.        8 8888       
5 //   `8.`8888.           . `88888.       8 8888         8 8888          88 8888               . `88888.       8 8888       
6 //    `8.`8888.         .8. `88888.      8 8888888888   8 8888888888    88 8888              .8. `88888.      8 8888       
7 //     `8.`8888.       .8`8. `88888.     8 8888         8 8888          88 8888             .8`8. `88888.     8 8888       
8 //      `8.`8888.     .8' `8. `88888.    8 8888         8 8888          88 8888            .8' `8. `88888.    8 8888       
9 //  8b   `8.`8888.   .8'   `8. `88888.   8 8888         8 8888          `8 8888       .8' .8'   `8. `88888.   8 8888       
10 //  `8b.  ;8.`8888  .888888888. `88888.  8 8888         8 8888             8888     ,88' .888888888. `88888.  8 8888       
11 //   `Y8888P8,88P' .8'       `8. `88888. 8 8888         8 88888888888       `8888888P'  .8'       `8. `88888. 8 8888       
12 //
13 
14 
15 // SPDX-License-Identifier: MIT
16 
17 pragma solidity ^0.6.12;
18 
19 
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 /**
32  * @dev Interface of the BEP20 standard as defined in the EIP.
33  */
34 interface IBEP20 {
35     /**
36      * @dev Returns the amount of tokens in existence.
37      */
38     function totalSupply() external view returns (uint256);
39 
40     /**
41      * @dev Returns the amount of tokens owned by `account`.
42      */
43     function balanceOf(address account) external view returns (uint256);
44 
45     /**
46      * @dev Moves `amount` tokens from the caller's account to `recipient`.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * Emits a {Transfer} event.
51      */
52     function transfer(address recipient, uint256 amount) external returns (bool);
53 
54     /**
55      * @dev Returns the remaining number of tokens that `spender` will be
56      * allowed to spend on behalf of `owner` through {transferFrom}. This is
57      * zero by default.
58      *
59      * This value changes when {approve} or {transferFrom} are called.
60      */
61     function allowance(address owner, address spender) external view returns (uint256);
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
88     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
89 
90     /**
91      * @dev Emitted when `value` tokens are moved from one account (`from`) to
92      * another (`to`).
93      *
94      * Note that `value` may be zero.
95      */
96     event Transfer(address indexed from, address indexed to, uint256 value);
97 
98     /**
99      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
100      * a call to {approve}. `value` is the new allowance.
101      */
102     event Approval(address indexed owner, address indexed spender, uint256 value);
103 }
104 
105 /**
106  * @dev Wrappers over Solidity's arithmetic operations with added overflow
107  * checks.
108  *
109  * Arithmetic operations in Solidity wrap on overflow. This can easily result
110  * in bugs, because programmers usually assume that an overflow raises an
111  * error, which is the standard behavior in high level programming languages.
112  * `SafeMath` restores this intuition by reverting the transaction when an
113  * operation overflows.
114  *
115  * Using this library instead of the unchecked operations eliminates an entire
116  * class of bugs, so it's recommended to use it always.
117  */
118 library SafeMath {
119     /**
120      * @dev Returns the addition of two unsigned integers, reverting on
121      * overflow.
122      *
123      * Counterpart to Solidity's `+` operator.
124      *
125      * Requirements:
126      *
127      * - Addition cannot overflow.
128      */
129     function add(uint256 a, uint256 b) internal pure returns (uint256) {
130         uint256 c = a + b;
131         require(c >= a, "SafeMath: addition overflow");
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the subtraction of two unsigned integers, reverting on
138      * overflow (when the result is negative).
139      *
140      * Counterpart to Solidity's `-` operator.
141      *
142      * Requirements:
143      *
144      * - Subtraction cannot overflow.
145      */
146     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147         return sub(a, b, "SafeMath: subtraction overflow");
148     }
149 
150     /**
151      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
152      * overflow (when the result is negative).
153      *
154      * Counterpart to Solidity's `-` operator.
155      *
156      * Requirements:
157      *
158      * - Subtraction cannot overflow.
159      */
160     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
161         require(b <= a, errorMessage);
162         uint256 c = a - b;
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the multiplication of two unsigned integers, reverting on
169      * overflow.
170      *
171      * Counterpart to Solidity's `*` operator.
172      *
173      * Requirements:
174      *
175      * - Multiplication cannot overflow.
176      */
177     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
178         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
179         // benefit is lost if 'b' is also tested.
180         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
181         if (a == 0) {
182             return 0;
183         }
184 
185         uint256 c = a * b;
186         require(c / a == b, "SafeMath: multiplication overflow");
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers. Reverts on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's `/` operator. Note: this function uses a
196      * `revert` opcode (which leaves remaining gas untouched) while Solidity
197      * uses an invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function div(uint256 a, uint256 b) internal pure returns (uint256) {
204         return div(a, b, "SafeMath: division by zero");
205     }
206 
207     /**
208      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
209      * division by zero. The result is rounded towards zero.
210      *
211      * Counterpart to Solidity's `/` operator. Note: this function uses a
212      * `revert` opcode (which leaves remaining gas untouched) while Solidity
213      * uses an invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
220         require(b > 0, errorMessage);
221         uint256 c = a / b;
222         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
223 
224         return c;
225     }
226 
227     /**
228      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
229      * Reverts when dividing by zero.
230      *
231      * Counterpart to Solidity's `%` operator. This function uses a `revert`
232      * opcode (which leaves remaining gas untouched) while Solidity uses an
233      * invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      *
237      * - The divisor cannot be zero.
238      */
239     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
240         return mod(a, b, "SafeMath: modulo by zero");
241     }
242 
243     /**
244      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
245      * Reverts with custom message when dividing by zero.
246      *
247      * Counterpart to Solidity's `%` operator. This function uses a `revert`
248      * opcode (which leaves remaining gas untouched) while Solidity uses an
249      * invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      *
253      * - The divisor cannot be zero.
254      */
255     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
256         require(b != 0, errorMessage);
257         return a % b;
258     }
259 }
260 
261 /**
262  * @dev Collection of functions related to the address type
263  */
264 library Address {
265     /**
266      * @dev Returns true if `account` is a contract.
267      *
268      * [IMPORTANT]
269      * ====
270      * It is unsafe to assume that an address for which this function returns
271      * false is an externally-owned account (EOA) and not a contract.
272      *
273      * Among others, `isContract` will return false for the following
274      * types of addresses:
275      *
276      *  - an externally-owned account
277      *  - a contract in construction
278      *  - an address where a contract will be created
279      *  - an address where a contract lived, but was destroyed
280      * ====
281      */
282     function isContract(address account) internal view returns (bool) {
283         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
284         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
285         // for accounts without code, i.e. `keccak256('')`
286         bytes32 codehash;
287         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
288         // solhint-disable-next-line no-inline-assembly
289         assembly { codehash := extcodehash(account) }
290         return (codehash != accountHash && codehash != 0x0);
291     }
292 
293     /**
294      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
295      * `recipient`, forwarding all available gas and reverting on errors.
296      *
297      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
298      * of certain opcodes, possibly making contracts go over the 2300 gas limit
299      * imposed by `transfer`, making them unable to receive funds via
300      * `transfer`. {sendValue} removes this limitation.
301      *
302      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
303      *
304      * IMPORTANT: because control is transferred to `recipient`, care must be
305      * taken to not create reentrancy vulnerabilities. Consider using
306      * {ReentrancyGuard} or the
307      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
308      */
309     function sendValue(address payable recipient, uint256 amount) internal {
310         require(address(this).balance >= amount, "Address: insufficient balance");
311 
312         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
313         (bool success, ) = recipient.call{ value: amount }("");
314         require(success, "Address: unable to send value, recipient may have reverted");
315     }
316 
317     /**
318      * @dev Performs a Solidity function call using a low level `call`. A
319      * plain`call` is an unsafe replacement for a function call: use this
320      * function instead.
321      *
322      * If `target` reverts with a revert reason, it is bubbled up by this
323      * function (like regular Solidity function calls).
324      *
325      * Returns the raw returned data. To convert to the expected return value,
326      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
327      *
328      * Requirements:
329      *
330      * - `target` must be a contract.
331      * - calling `target` with `data` must not revert.
332      *
333      * _Available since v3.1._
334      */
335     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
336       return functionCall(target, data, "Address: low-level call failed");
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
341      * `errorMessage` as a fallback revert reason when `target` reverts.
342      *
343      * _Available since v3.1._
344      */
345     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
346         return _functionCallWithValue(target, data, 0, errorMessage);
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
351      * but also transferring `value` wei to `target`.
352      *
353      * Requirements:
354      *
355      * - the calling contract must have an ETH balance of at least `value`.
356      * - the called Solidity function must be `payable`.
357      *
358      * _Available since v3.1._
359      */
360     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
361         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
366      * with `errorMessage` as a fallback revert reason when `target` reverts.
367      *
368      * _Available since v3.1._
369      */
370     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
371         require(address(this).balance >= value, "Address: insufficient balance for call");
372         return _functionCallWithValue(target, data, value, errorMessage);
373     }
374 
375     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
376         require(isContract(target), "Address: call to non-contract");
377 
378         // solhint-disable-next-line avoid-low-level-calls
379         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
380         if (success) {
381             return returndata;
382         } else {
383             // Look for revert reason and bubble it up if present
384             if (returndata.length > 0) {
385                 // The easiest way to bubble the revert reason is using memory via assembly
386 
387                 // solhint-disable-next-line no-inline-assembly
388                 assembly {
389                     let returndata_size := mload(returndata)
390                     revert(add(32, returndata), returndata_size)
391                 }
392             } else {
393                 revert(errorMessage);
394             }
395         }
396     }
397 }
398 
399 /**
400  * @dev Contract module which provides a basic access control mechanism, where
401  * there is an account (an owner) that can be granted exclusive access to
402  * specific functions.
403  *
404  * By default, the owner account will be the one that deploys the contract. This
405  * can later be changed with {transferOwnership}.
406  *
407  * This module is used through inheritance. It will make available the modifier
408  * `onlyOwner`, which can be applied to your functions to restrict their use to
409  * the owner.
410  */
411 contract Ownable is Context {
412     address private _owner;
413 
414     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
415 
416     /**
417      * @dev Initializes the contract setting the deployer as the initial owner.
418      */
419     constructor () internal {
420         address msgSender = _msgSender();
421         _owner = msgSender;
422         emit OwnershipTransferred(address(0), msgSender);
423     }
424 
425     /**
426      * @dev Returns the address of the current owner.
427      */
428     function owner() public view returns (address) {
429         return _owner;
430     }
431 
432     /**
433      * @dev Throws if called by any account other than the owner.
434      */
435     modifier onlyOwner() {
436         require(_owner == _msgSender(), "Ownable: caller is not the owner");
437         _;
438     }
439 
440     /**
441      * @dev Leaves the contract without owner. It will not be possible to call
442      * `onlyOwner` functions anymore. Can only be called by the current owner.
443      *
444      * NOTE: Renouncing ownership will leave the contract without an owner,
445      * thereby removing any functionality that is only available to the owner.
446      */
447     function renounceOwnership() public virtual onlyOwner {
448         emit OwnershipTransferred(_owner, address(0));
449         _owner = address(0);
450     }
451 
452     /**
453      * @dev Transfers ownership of the contract to a new account (`newOwner`).
454      * Can only be called by the current owner.
455      */
456     function transferOwnership(address newOwner) public virtual onlyOwner {
457         require(newOwner != address(0), "Ownable: new owner is the zero address");
458         emit OwnershipTransferred(_owner, newOwner);
459         _owner = newOwner;
460     }
461 }
462 
463 contract SafeCat is Context, IBEP20, Ownable {
464     using SafeMath for uint256;
465     using Address for address;
466 
467     mapping (address => uint256) private _rOwned;
468     mapping (address => uint256) private _tOwned;
469     mapping (address => mapping (address => uint256)) private _allowances;
470     
471     //added now
472     mapping (address => bool) private bot; 
473     
474     mapping (address => bool) private _isExcluded;
475     address[] private _excluded;
476     
477     string  private constant _NAME = 'SafeCat';
478     string  private constant _SYMBOL = 'SafeCat';
479     uint8   private constant _DECIMALS = 8;
480    
481     uint256 private constant _MAX = ~uint256(0);
482     uint256 private constant _DECIMALFACTOR = 10 ** uint256(_DECIMALS);
483     uint256 private constant _GRANULARITY = 100;
484     
485     uint256 private _tTotal = 1000000000 * _DECIMALFACTOR;
486     uint256 private _rTotal = (_MAX - (_MAX % _tTotal));
487     
488     uint256 private _tFeeTotal;
489     uint256 private _tBurnTotal;
490     
491     uint256 private constant     _TAX_FEE = 100;
492     uint256 private constant    _BURN_FEE = 100;
493     uint256 private _MAX_TX_SIZE = 100000 * _DECIMALFACTOR;
494     
495     bool public tradingEnabled = false;
496     address private LiquidityAddress;
497     uint256 private _MAX_WT_SIZE = 200000 * _DECIMALFACTOR;
498     
499     uint256 public _marketingFee = 100;
500     address public marketingWallet = 0x610a81aea4C42fCd24A8CdF7174327066e6045A5;
501     uint256 private _previousmarketingFee = _marketingFee;
502     
503     constructor () public {
504         _rOwned[_msgSender()] = _rTotal;
505         emit Transfer(address(0), _msgSender(), _tTotal);
506     }
507 
508     function name() public view returns (string memory) {
509         return _NAME;
510     }
511 
512     function symbol() public view returns (string memory) {
513         return _SYMBOL;
514     }
515 
516     function decimals() public view returns (uint8) {
517         return _DECIMALS;
518     }
519 
520     function totalSupply() public view override returns (uint256) {
521         return _tTotal;
522     }
523 
524     function balanceOf(address account) public view override returns (uint256) {
525         if (_isExcluded[account]) return _tOwned[account];
526         return tokenFromReflection(_rOwned[account]);
527     }
528 
529     function transfer(address recipient, uint256 amount) public override returns (bool) {
530         _transfer(_msgSender(), recipient, amount);
531         return true;
532     }
533 
534     function allowance(address owner, address spender) public view override returns (uint256) {
535         return _allowances[owner][spender];
536     }
537 
538     function approve(address spender, uint256 amount) public override returns (bool) {
539         _approve(_msgSender(), spender, amount);
540         return true;
541     }
542 
543     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
544         _transfer(sender, recipient, amount);
545         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
546         return true;
547     }
548 
549     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
550         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
551         return true;
552     }
553 
554     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
555         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
556         return true;
557     }
558 
559     function isExcluded(address account) public view returns (bool) {
560         return _isExcluded[account];
561     }
562 
563     function totalFees() public view returns (uint256) {
564         return _tFeeTotal;
565     }
566     
567     function totalBurn() public view returns (uint256) {
568         return _tBurnTotal;
569     }
570 
571     //added this
572     function setBot(address blist) external onlyOwner returns (bool){
573         bot[blist] = !bot[blist];
574         return bot[blist];
575     }
576 
577     function deliver(uint256 tAmount) public {
578         address sender = _msgSender();
579         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
580         (uint256 rAmount,,,,,) = _getValues(tAmount);
581         _rOwned[sender] = _rOwned[sender].sub(rAmount);
582         _rTotal = _rTotal.sub(rAmount);
583         _tFeeTotal = _tFeeTotal.add(tAmount);
584     }
585 
586     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
587         require(tAmount <= _tTotal, "Amount must be less than supply");
588         if (!deductTransferFee) {
589             (uint256 rAmount,,,,,) = _getValues(tAmount);
590             return rAmount;
591         } else {
592             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
593             return rTransferAmount;
594         }
595     }
596 
597     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
598         require(rAmount <= _rTotal, "Amount must be less than total reflections");
599         uint256 currentRate =  _getRate();
600         return rAmount.div(currentRate);
601     }
602 
603     function excludeAccount(address account) external onlyOwner() {
604         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
605         require(account != 0x73feaa1eE314F8c655E354234017bE2193C9E24E, 'We can not exclude Pancake router.');
606         require(!_isExcluded[account], "Account is already excluded");
607         if(_rOwned[account] > 0) {
608             _tOwned[account] = tokenFromReflection(_rOwned[account]);
609         }
610         _isExcluded[account] = true;
611         _excluded.push(account);
612     }
613 
614     function includeAccount(address account) external onlyOwner() {
615         require(_isExcluded[account], "Account is already excluded");
616         for (uint256 i = 0; i < _excluded.length; i++) {
617             if (_excluded[i] == account) {
618                 _excluded[i] = _excluded[_excluded.length - 1];
619                 _tOwned[account] = 0;
620                 _isExcluded[account] = false;
621                 _excluded.pop();
622                 break;
623             }
624         }
625     }
626 
627     function _approve(address owner, address spender, uint256 amount) private {
628         require(owner != address(0), "BEP20: approve from the zero address");
629         require(spender != address(0), "BEP20: approve to the zero address");
630 
631         _allowances[owner][spender] = amount;
632         emit Approval(owner, spender, amount);
633     }
634 
635     function _transfer(address sender, address recipient, uint256 amount) private {
636         require(sender != address(0), "BEP20: transfer from the zero address");
637         require(recipient != address(0), "BEP20: transfer to the zero address");
638         require(amount > 0, "Transfer amount must be greater than zero");
639 
640         if(sender != owner() && recipient != owner()){
641             require(amount <= _MAX_TX_SIZE, "Transfer amount exceeds the maxTxAmount.");
642             require(!bot[sender], "Play fair");
643             require(!bot[recipient], "Play fair");
644             if (recipient != LiquidityAddress) {
645                  require(balanceOf(recipient) + amount <= _MAX_WT_SIZE, "Transfer amount exceeds the maxWtAmount.");
646             }
647         }
648         
649         if (sender != owner()) {
650             require(tradingEnabled, "Trading is not enabled yet");
651         }
652         
653         _previousmarketingFee = _marketingFee;
654         uint256 marketingAmt = amount.mul(_marketingFee).div(_GRANULARITY).div(100);
655             
656         if (_isExcluded[sender] && !_isExcluded[recipient]) {
657             _transferFromExcluded(sender, recipient, amount.sub(marketingAmt));
658         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
659             _transferToExcluded(sender, recipient, amount.sub(marketingAmt));
660         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
661             _transferStandard(sender, recipient, amount.sub(marketingAmt));
662         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
663             _transferBothExcluded(sender, recipient, amount.sub(marketingAmt));
664         } else {
665             _transferStandard(sender, recipient, amount.sub(marketingAmt));
666         }
667         
668         //temporarily remove marketing fees
669         _marketingFee = 0;
670         _transferStandard(sender, marketingWallet, marketingAmt);
671         _marketingFee = _previousmarketingFee;
672     }
673 
674     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
675         uint256 currentRate =  _getRate();
676         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
677         uint256 rBurn =  tBurn.mul(currentRate);
678         _rOwned[sender] = _rOwned[sender].sub(rAmount);
679         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
680         _reflectFee(rFee, rBurn, tFee, tBurn);
681         emit Transfer(sender, recipient, tTransferAmount);
682     }
683 
684     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
685         uint256 currentRate =  _getRate();
686         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
687         uint256 rBurn =  tBurn.mul(currentRate);
688         _rOwned[sender] = _rOwned[sender].sub(rAmount);
689         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
690         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
691         _reflectFee(rFee, rBurn, tFee, tBurn);
692         emit Transfer(sender, recipient, tTransferAmount);
693     }
694 
695     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
696         uint256 currentRate =  _getRate();
697         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
698         uint256 rBurn =  tBurn.mul(currentRate);
699         _tOwned[sender] = _tOwned[sender].sub(tAmount);
700         _rOwned[sender] = _rOwned[sender].sub(rAmount);
701         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
702         _reflectFee(rFee, rBurn, tFee, tBurn);
703         emit Transfer(sender, recipient, tTransferAmount);
704     }
705 
706     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
707         uint256 currentRate =  _getRate();
708         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
709         uint256 rBurn =  tBurn.mul(currentRate);
710         _tOwned[sender] = _tOwned[sender].sub(tAmount);
711         _rOwned[sender] = _rOwned[sender].sub(rAmount);
712         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
713         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
714         _reflectFee(rFee, rBurn, tFee, tBurn);
715         emit Transfer(sender, recipient, tTransferAmount);
716     }
717 
718     function _reflectFee(uint256 rFee, uint256 rBurn, uint256 tFee, uint256 tBurn) private {
719         _rTotal = _rTotal.sub(rFee).sub(rBurn);
720         _tFeeTotal = _tFeeTotal.add(tFee);
721         _tBurnTotal = _tBurnTotal.add(tBurn);
722         _tTotal = _tTotal.sub(tBurn);
723     }
724     
725     function setMaxTxSize(uint256 amount) external onlyOwner() {
726         _MAX_TX_SIZE = amount * _DECIMALFACTOR;
727     }
728 
729     function setmarketingWallet(address newWallet) external onlyOwner() {
730         marketingWallet = newWallet;
731     }
732     
733     function setmarketingfee(uint256 amount) external onlyOwner() {
734         _marketingFee = amount;
735     }
736     
737     function setMaxWtSize(uint256 amount) external onlyOwner() {
738         _MAX_WT_SIZE = amount * _DECIMALFACTOR;
739     }
740 
741     function setLiquidityAddress(address amount) external onlyOwner() {
742         LiquidityAddress = amount;
743     }
744 
745     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
746         (uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getTValues(tAmount, _TAX_FEE, _BURN_FEE);
747         uint256 currentRate =  _getRate();
748         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tBurn, currentRate);
749         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBurn);
750     }
751 
752     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 burnFee) private pure returns (uint256, uint256, uint256) {
753         uint256 tFee = ((tAmount.mul(taxFee)).div(_GRANULARITY)).div(100);
754         uint256 tBurn = ((tAmount.mul(burnFee)).div(_GRANULARITY)).div(100);
755         uint256 tTransferAmount = tAmount.sub(tFee).sub(tBurn);
756         return (tTransferAmount, tFee, tBurn);
757     }
758 
759     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tBurn, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
760         uint256 rAmount = tAmount.mul(currentRate);
761         uint256 rFee = tFee.mul(currentRate);
762         uint256 rBurn = tBurn.mul(currentRate);
763         uint256 rTransferAmount = rAmount.sub(rFee).sub(rBurn);
764         return (rAmount, rTransferAmount, rFee);
765     }
766 
767     function _getRate() private view returns(uint256) {
768         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
769         return rSupply.div(tSupply);
770     }
771 
772     function _getCurrentSupply() private view returns(uint256, uint256) {
773         uint256 rSupply = _rTotal;
774         uint256 tSupply = _tTotal;      
775         for (uint256 i = 0; i < _excluded.length; i++) {
776             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
777             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
778             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
779         }
780         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
781         return (rSupply, tSupply);
782     }
783     
784     function _getTaxFee() public view returns(uint256) {
785         return _TAX_FEE;
786     }
787 
788     function enableTrading(bool _tradingEnabled) external onlyOwner() {
789         tradingEnabled = _tradingEnabled;
790     }    
791         
792     function _getMaxTxSize() public view returns(uint256) {
793         return _MAX_TX_SIZE;
794     }
795     
796     function _getMaxWtSize() public view returns(uint256) {
797         return _MAX_WT_SIZE;
798     }
799 
800 }