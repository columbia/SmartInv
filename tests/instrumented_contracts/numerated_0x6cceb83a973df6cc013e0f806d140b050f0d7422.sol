1 /*
2  * @dev Provides information about the current execution context, including the
3  * sender of the transaction and its data. While these are generally available
4  * via msg.sender and msg.data, they should not be accessed in such a direct
5  * manner, since when dealing with GSN meta-transactions the account sending and
6  * paying for execution may not be the actual sender (as far as an application
7  * is concerned).
8  *
9  * This contract is only required for intermediate, library-like contracts.
10  */
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address payable) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes memory) {
17         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
18         return msg.data;
19     }
20 }
21 
22 
23 /**
24  * @dev Interface of the ERC20 standard as defined in the EIP.
25  */
26 interface IERC20 {
27     /**
28      * @dev Returns the amount of tokens in existence.
29      */
30     function totalSupply() external view returns (uint256);
31 
32     /**
33      * @dev Returns the amount of tokens owned by `account`.
34      */
35     function balanceOf(address account) external view returns (uint256);
36 
37     /**
38      * @dev Moves `amount` tokens from the caller's account to `recipient`.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * Emits a {Transfer} event.
43      */
44     function transfer(address recipient, uint256 amount) external returns (bool);
45 
46     /**
47      * @dev Returns the remaining number of tokens that `spender` will be
48      * allowed to spend on behalf of `owner` through {transferFrom}. This is
49      * zero by default.
50      *
51      * This value changes when {approve} or {transferFrom} are called.
52      */
53     function allowance(address owner, address spender) external view returns (uint256);
54 
55     /**
56      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * IMPORTANT: Beware that changing an allowance with this method brings the risk
61      * that someone may use both the old and the new allowance by unfortunate
62      * transaction ordering. One possible solution to mitigate this race
63      * condition is to first reduce the spender's allowance to 0 and set the
64      * desired value afterwards:
65      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
66      *
67      * Emits an {Approval} event.
68      */
69     function approve(address spender, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Moves `amount` tokens from `sender` to `recipient` using the
73      * allowance mechanism. `amount` is then deducted from the caller's
74      * allowance.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * Emits a {Transfer} event.
79      */
80     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Emitted when `value` tokens are moved from one account (`from`) to
84      * another (`to`).
85      *
86      * Note that `value` may be zero.
87      */
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 
90     /**
91      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
92      * a call to {approve}. `value` is the new allowance.
93      */
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 
98 
99 /**
100  * @dev Wrappers over Solidity's arithmetic operations with added overflow
101  * checks.
102  *
103  * Arithmetic operations in Solidity wrap on overflow. This can easily result
104  * in bugs, because programmers usually assume that an overflow raises an
105  * error, which is the standard behavior in high level programming languages.
106  * `SafeMath` restores this intuition by reverting the transaction when an
107  * operation overflows.
108  *
109  * Using this library instead of the unchecked operations eliminates an entire
110  * class of bugs, so it's recommended to use it always.
111  */
112 library SafeMath {
113     /**
114      * @dev Returns the addition of two unsigned integers, reverting on
115      * overflow.
116      *
117      * Counterpart to Solidity's `+` operator.
118      *
119      * Requirements:
120      *
121      * - Addition cannot overflow.
122      */
123     function add(uint256 a, uint256 b) internal pure returns (uint256) {
124         uint256 c = a + b;
125         require(c >= a, "SafeMath: addition overflow");
126 
127         return c;
128     }
129 
130     /**
131      * @dev Returns the subtraction of two unsigned integers, reverting on
132      * overflow (when the result is negative).
133      *
134      * Counterpart to Solidity's `-` operator.
135      *
136      * Requirements:
137      *
138      * - Subtraction cannot overflow.
139      */
140     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
141         return sub(a, b, "SafeMath: subtraction overflow");
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      *
152      * - Subtraction cannot overflow.
153      */
154     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
155         require(b <= a, errorMessage);
156         uint256 c = a - b;
157 
158         return c;
159     }
160 
161     /**
162      * @dev Returns the multiplication of two unsigned integers, reverting on
163      * overflow.
164      *
165      * Counterpart to Solidity's `*` operator.
166      *
167      * Requirements:
168      *
169      * - Multiplication cannot overflow.
170      */
171     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
172         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
173         // benefit is lost if 'b' is also tested.
174         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
175         if (a == 0) {
176             return 0;
177         }
178 
179         uint256 c = a * b;
180         require(c / a == b, "SafeMath: multiplication overflow");
181 
182         return c;
183     }
184 
185     /**
186      * @dev Returns the integer division of two unsigned integers. Reverts on
187      * division by zero. The result is rounded towards zero.
188      *
189      * Counterpart to Solidity's `/` operator. Note: this function uses a
190      * `revert` opcode (which leaves remaining gas untouched) while Solidity
191      * uses an invalid opcode to revert (consuming all remaining gas).
192      *
193      * Requirements:
194      *
195      * - The divisor cannot be zero.
196      */
197     function div(uint256 a, uint256 b) internal pure returns (uint256) {
198         return div(a, b, "SafeMath: division by zero");
199     }
200 
201     /**
202      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
203      * division by zero. The result is rounded towards zero.
204      *
205      * Counterpart to Solidity's `/` operator. Note: this function uses a
206      * `revert` opcode (which leaves remaining gas untouched) while Solidity
207      * uses an invalid opcode to revert (consuming all remaining gas).
208      *
209      * Requirements:
210      *
211      * - The divisor cannot be zero.
212      */
213     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
214         require(b > 0, errorMessage);
215         uint256 c = a / b;
216         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
217 
218         return c;
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * Reverts when dividing by zero.
224      *
225      * Counterpart to Solidity's `%` operator. This function uses a `revert`
226      * opcode (which leaves remaining gas untouched) while Solidity uses an
227      * invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
234         return mod(a, b, "SafeMath: modulo by zero");
235     }
236 
237     /**
238      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
239      * Reverts with custom message when dividing by zero.
240      *
241      * Counterpart to Solidity's `%` operator. This function uses a `revert`
242      * opcode (which leaves remaining gas untouched) while Solidity uses an
243      * invalid opcode to revert (consuming all remaining gas).
244      *
245      * Requirements:
246      *
247      * - The divisor cannot be zero.
248      */
249     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
250         require(b != 0, errorMessage);
251         return a % b;
252     }
253 }
254 
255 // File: openzeppelin-solidity\contracts\utils\Address.sol
256 
257 // SPDX-License-Identifier: MIT
258 
259 
260 /**
261  * @dev Collection of functions related to the address type
262  */
263 library Address {
264     /**
265      * @dev Returns true if `account` is a contract.
266      *
267      * [IMPORTANT]
268      * ====
269      * It is unsafe to assume that an address for which this function returns
270      * false is an externally-owned account (EOA) and not a contract.
271      *
272      * Among others, `isContract` will return false for the following
273      * types of addresses:
274      *
275      *  - an externally-owned account
276      *  - a contract in construction
277      *  - an address where a contract will be created
278      *  - an address where a contract lived, but was destroyed
279      * ====
280      */
281     function isContract(address account) internal view returns (bool) {
282         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
283         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
284         // for accounts without code, i.e. `keccak256('')`
285         bytes32 codehash;
286         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
287         // solhint-disable-next-line no-inline-assembly
288         assembly { codehash := extcodehash(account) }
289         return (codehash != accountHash && codehash != 0x0);
290     }
291 
292     /**
293      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
294      * `recipient`, forwarding all available gas and reverting on errors.
295      *
296      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
297      * of certain opcodes, possibly making contracts go over the 2300 gas limit
298      * imposed by `transfer`, making them unable to receive funds via
299      * `transfer`. {sendValue} removes this limitation.
300      *
301      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
302      *
303      * IMPORTANT: because control is transferred to `recipient`, care must be
304      * taken to not create reentrancy vulnerabilities. Consider using
305      * {ReentrancyGuard} or the
306      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
307      */
308     function sendValue(address payable recipient, uint256 amount) internal {
309         require(address(this).balance >= amount, "Address: insufficient balance");
310 
311         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
312         (bool success, ) = recipient.call{ value: amount }("");
313         require(success, "Address: unable to send value, recipient may have reverted");
314     }
315 
316     /**
317      * @dev Performs a Solidity function call using a low level `call`. A
318      * plain`call` is an unsafe replacement for a function call: use this
319      * function instead.
320      *
321      * If `target` reverts with a revert reason, it is bubbled up by this
322      * function (like regular Solidity function calls).
323      *
324      * Returns the raw returned data. To convert to the expected return value,
325      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
326      *
327      * Requirements:
328      *
329      * - `target` must be a contract.
330      * - calling `target` with `data` must not revert.
331      *
332      * _Available since v3.1._
333      */
334     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
335         return functionCall(target, data, "Address: low-level call failed");
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
340      * `errorMessage` as a fallback revert reason when `target` reverts.
341      *
342      * _Available since v3.1._
343      */
344     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
345         return _functionCallWithValue(target, data, 0, errorMessage);
346     }
347 
348     /**
349      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
350      * but also transferring `value` wei to `target`.
351      *
352      * Requirements:
353      *
354      * - the calling contract must have an ETH balance of at least `value`.
355      * - the called Solidity function must be `payable`.
356      *
357      * _Available since v3.1._
358      */
359     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
360         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
365      * with `errorMessage` as a fallback revert reason when `target` reverts.
366      *
367      * _Available since v3.1._
368      */
369     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
370         require(address(this).balance >= value, "Address: insufficient balance for call");
371         return _functionCallWithValue(target, data, value, errorMessage);
372     }
373 
374     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
375         require(isContract(target), "Address: call to non-contract");
376 
377         // solhint-disable-next-line avoid-low-level-calls
378         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
379         if (success) {
380             return returndata;
381         } else {
382             // Look for revert reason and bubble it up if present
383             if (returndata.length > 0) {
384                 // The easiest way to bubble the revert reason is using memory via assembly
385 
386                 // solhint-disable-next-line no-inline-assembly
387                 assembly {
388                     let returndata_size := mload(returndata)
389                     revert(add(32, returndata), returndata_size)
390                 }
391             } else {
392                 revert(errorMessage);
393             }
394         }
395     }
396 }
397 
398 
399 
400 /**
401  * @dev Contract module which provides a basic access control mechanism, where
402  * there is an account (an owner) that can be granted exclusive access to
403  * specific functions.
404  *
405  * By default, the owner account will be the one that deploys the contract. This
406  * can later be changed with {transferOwnership}.
407  *
408  * This module is used through inheritance. It will make available the modifier
409  * `onlyOwner`, which can be applied to your functions to restrict their use to
410  * the owner.
411  */
412 contract Ownable is Context {
413     address private _owner;
414 
415     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
416 
417     /**
418      * @dev Initializes the contract setting the deployer as the initial owner.
419      */
420     constructor () internal {
421         address msgSender = _msgSender();
422         _owner = msgSender;
423         emit OwnershipTransferred(address(0), msgSender);
424     }
425 
426     /**
427      * @dev Returns the address of the current owner.
428      */
429     function owner() public view returns (address) {
430         return _owner;
431     }
432 
433     /**
434      * @dev Throws if called by any account other than the owner.
435      */
436     modifier onlyOwner() {
437         require(_owner == _msgSender(), "Ownable: caller is not the owner");
438         _;
439     }
440 
441     /**
442      * @dev Leaves the contract without owner. It will not be possible to call
443      * `onlyOwner` functions anymore. Can only be called by the current owner.
444      *
445      * NOTE: Renouncing ownership will leave the contract without an owner,
446      * thereby removing any functionality that is only available to the owner.
447      */
448     function renounceOwnership() public virtual onlyOwner {
449         emit OwnershipTransferred(_owner, address(0));
450         _owner = address(0);
451     }
452 
453     /**
454      * @dev Transfers ownership of the contract to a new account (`newOwner`).
455      * Can only be called by the current owner.
456      */
457     function transferOwnership(address newOwner) public virtual onlyOwner {
458         require(newOwner != address(0), "Ownable: new owner is the zero address");
459         emit OwnershipTransferred(_owner, newOwner);
460         _owner = newOwner;
461     }
462 }
463 
464 
465 pragma solidity ^0.6.2;
466 
467 contract Maximus is Context, IERC20, Ownable {
468     using SafeMath for uint256;
469     using Address for address;
470 
471     mapping (address => uint256) private _rOwned;
472     mapping (address => uint256) private _tOwned;
473     mapping (address => mapping (address => uint256)) private _allowances;
474 
475     mapping (address => bool) private _isExcluded;
476     address[] private _excluded;
477 
478     uint256 private constant MAX = ~uint256(0);
479     uint256 private constant _tTotal = 500 * 10**6 * 10**9;
480     uint256 private _rTotal = (MAX - (MAX % _tTotal));
481     uint256 private _tFeeTotal;
482 
483     string private _name = 'Maximus';
484     string private _symbol = 'Max';
485     uint8 private _decimals = 9;
486 
487     constructor () public {
488         _rOwned[_msgSender()] = _rTotal;
489         emit Transfer(address(0), _msgSender(), _tTotal);
490     }
491 
492     function name() public view returns (string memory) {
493         return _name;
494     }
495 
496     function symbol() public view returns (string memory) {
497         return _symbol;
498     }
499 
500     function decimals() public view returns (uint8) {
501         return _decimals;
502     }
503 
504     function totalSupply() public view override returns (uint256) {
505         return _tTotal;
506     }
507 
508     function balanceOf(address account) public view override returns (uint256) {
509         if (_isExcluded[account]) return _tOwned[account];
510         return tokenFromReflection(_rOwned[account]);
511     }
512 
513     function transfer(address recipient, uint256 amount) public override returns (bool) {
514         _transfer(_msgSender(), recipient, amount);
515         return true;
516     }
517 
518     function allowance(address owner, address spender) public view override returns (uint256) {
519         return _allowances[owner][spender];
520     }
521 
522     function approve(address spender, uint256 amount) public override returns (bool) {
523         _approve(_msgSender(), spender, amount);
524         return true;
525     }
526 
527     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
528         _transfer(sender, recipient, amount);
529         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
530         return true;
531     }
532 
533     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
534         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
535         return true;
536     }
537 
538     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
539         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
540         return true;
541     }
542 
543     function isExcluded(address account) public view returns (bool) {
544         return _isExcluded[account];
545     }
546 
547     function totalFees() public view returns (uint256) {
548         return _tFeeTotal;
549     }
550 
551     function reflect(uint256 tAmount) public {
552         address sender = _msgSender();
553         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
554         (uint256 rAmount,,,,) = _getValues(tAmount);
555         _rOwned[sender] = _rOwned[sender].sub(rAmount);
556         _rTotal = _rTotal.sub(rAmount);
557         _tFeeTotal = _tFeeTotal.add(tAmount);
558     }
559 
560     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
561         require(tAmount <= _tTotal, "Amount must be less than supply");
562         if (!deductTransferFee) {
563             (uint256 rAmount,,,,) = _getValues(tAmount);
564             return rAmount;
565         } else {
566             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
567             return rTransferAmount;
568         }
569     }
570 
571     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
572         require(rAmount <= _rTotal, "Amount must be less than total reflections");
573         uint256 currentRate =  _getRate();
574         return rAmount.div(currentRate);
575     }
576 
577     function excludeAccount(address account) external onlyOwner() {
578         require(!_isExcluded[account], "Account is already excluded");
579         if(_rOwned[account] > 0) {
580             _tOwned[account] = tokenFromReflection(_rOwned[account]);
581         }
582         _isExcluded[account] = true;
583         _excluded.push(account);
584     }
585 
586     function includeAccount(address account) external onlyOwner() {
587         require(_isExcluded[account], "Account is already excluded");
588         for (uint256 i = 0; i < _excluded.length; i++) {
589             if (_excluded[i] == account) {
590                 _excluded[i] = _excluded[_excluded.length - 1];
591                 _tOwned[account] = 0;
592                 _isExcluded[account] = false;
593                 _excluded.pop();
594                 break;
595             }
596         }
597     }
598 
599     function _approve(address owner, address spender, uint256 amount) private {
600         require(owner != address(0), "ERC20: approve from the zero address");
601         require(spender != address(0), "ERC20: approve to the zero address");
602 
603         _allowances[owner][spender] = amount;
604         emit Approval(owner, spender, amount);
605     }
606 
607     function _transfer(address sender, address recipient, uint256 amount) private {
608         require(sender != address(0), "ERC20: transfer from the zero address");
609         require(recipient != address(0), "ERC20: transfer to the zero address");
610         require(amount > 0, "Transfer amount must be greater than zero");
611         if (_isExcluded[sender] && !_isExcluded[recipient]) {
612             _transferFromExcluded(sender, recipient, amount);
613         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
614             _transferToExcluded(sender, recipient, amount);
615         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
616             _transferStandard(sender, recipient, amount);
617         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
618             _transferBothExcluded(sender, recipient, amount);
619         } else {
620             _transferStandard(sender, recipient, amount);
621         }
622     }
623 
624     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
625         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
626         _rOwned[sender] = _rOwned[sender].sub(rAmount);
627         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
628         _reflectFee(rFee, tFee);
629         emit Transfer(sender, recipient, tTransferAmount);
630     }
631 
632     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
633         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
634         _rOwned[sender] = _rOwned[sender].sub(rAmount);
635         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
636         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
637         _reflectFee(rFee, tFee);
638         emit Transfer(sender, recipient, tTransferAmount);
639     }
640 
641     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
642         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
643         _tOwned[sender] = _tOwned[sender].sub(tAmount);
644         _rOwned[sender] = _rOwned[sender].sub(rAmount);
645         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
646         _reflectFee(rFee, tFee);
647         emit Transfer(sender, recipient, tTransferAmount);
648     }
649 
650     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
651         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
652         _tOwned[sender] = _tOwned[sender].sub(tAmount);
653         _rOwned[sender] = _rOwned[sender].sub(rAmount);
654         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
655         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
656         _reflectFee(rFee, tFee);
657         emit Transfer(sender, recipient, tTransferAmount);
658     }
659 
660     function _reflectFee(uint256 rFee, uint256 tFee) private {
661         _rTotal = _rTotal.sub(rFee);
662         _tFeeTotal = _tFeeTotal.add(tFee);
663     }
664 
665     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
666         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
667         uint256 currentRate =  _getRate();
668         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
669         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
670     }
671 
672     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
673         uint256 tFee = tAmount.mul(5).div(100);
674         uint256 tTransferAmount = tAmount.sub(tFee);
675         return (tTransferAmount, tFee);
676     }
677 
678     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
679         uint256 rAmount = tAmount.mul(currentRate);
680         uint256 rFee = tFee.mul(currentRate);
681         uint256 rTransferAmount = rAmount.sub(rFee);
682         return (rAmount, rTransferAmount, rFee);
683     }
684 
685     function _getRate() private view returns(uint256) {
686         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
687         return rSupply.div(tSupply);
688     }
689 
690     function _getCurrentSupply() private view returns(uint256, uint256) {
691         uint256 rSupply = _rTotal;
692         uint256 tSupply = _tTotal;
693         for (uint256 i = 0; i < _excluded.length; i++) {
694             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
695             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
696             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
697         }
698         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
699         return (rSupply, tSupply);
700     }
701 }