1 /*IGNITE
2  */
3  
4 // File: openzeppelin-solidity\contracts\GSN\Context.sol
5 
6 // SPDX-License-Identifier: MIT
7 
8 pragma solidity ^0.6.0;
9 
10 /*
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with GSN meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
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
31 // File: openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
32 
33 // SPDX-License-Identifier: MIT
34 
35 pragma solidity ^0.6.0;
36 
37 /**
38  * @dev Interface of the ERC20 standard as defined in the EIP.
39  */
40 interface IERC20 {
41     /**
42      * @dev Returns the amount of tokens in existence.
43      */
44     function totalSupply() external view returns (uint256);
45 
46     /**
47      * @dev Returns the amount of tokens owned by `account`.
48      */
49     function balanceOf(address account) external view returns (uint256);
50 
51     /**
52      * @dev Moves `amount` tokens from the caller's account to `recipient`.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * Emits a {Transfer} event.
57      */
58     function transfer(address recipient, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Returns the remaining number of tokens that `spender` will be
62      * allowed to spend on behalf of `owner` through {transferFrom}. This is
63      * zero by default.
64      *
65      * This value changes when {approve} or {transferFrom} are called.
66      */
67     function allowance(address owner, address spender) external view returns (uint256);
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
94     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
95 
96     /**
97      * @dev Emitted when `value` tokens are moved from one account (`from`) to
98      * another (`to`).
99      *
100      * Note that `value` may be zero.
101      */
102     event Transfer(address indexed from, address indexed to, uint256 value);
103 
104     /**
105      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
106      * a call to {approve}. `value` is the new allowance.
107      */
108     event Approval(address indexed owner, address indexed spender, uint256 value);
109 }
110 
111 // File: openzeppelin-solidity\contracts\math\SafeMath.sol
112 
113 // SPDX-License-Identifier: MIT
114 
115 pragma solidity ^0.6.0;
116 
117 /**
118  * @dev Wrappers over Solidity's arithmetic operations with added overflow
119  * checks.
120  *
121  * Arithmetic operations in Solidity wrap on overflow. This can easily result
122  * in bugs, because programmers usually assume that an overflow raises an
123  * error, which is the standard behavior in high level programming languages.
124  * `SafeMath` restores this intuition by reverting the transaction when an
125  * operation overflows.
126  *
127  * Using this library instead of the unchecked operations eliminates an entire
128  * class of bugs, so it's recommended to use it always.
129  */
130 library SafeMath {
131     /**
132      * @dev Returns the addition of two unsigned integers, reverting on
133      * overflow.
134      *
135      * Counterpart to Solidity's `+` operator.
136      *
137      * Requirements:
138      *
139      * - Addition cannot overflow.
140      */
141     function add(uint256 a, uint256 b) internal pure returns (uint256) {
142         uint256 c = a + b;
143         require(c >= a, "SafeMath: addition overflow");
144 
145         return c;
146     }
147 
148     /**
149      * @dev Returns the subtraction of two unsigned integers, reverting on
150      * overflow (when the result is negative).
151      *
152      * Counterpart to Solidity's `-` operator.
153      *
154      * Requirements:
155      *
156      * - Subtraction cannot overflow.
157      */
158     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
159         return sub(a, b, "SafeMath: subtraction overflow");
160     }
161 
162     /**
163      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
164      * overflow (when the result is negative).
165      *
166      * Counterpart to Solidity's `-` operator.
167      *
168      * Requirements:
169      *
170      * - Subtraction cannot overflow.
171      */
172     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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
231     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
232         require(b > 0, errorMessage);
233         uint256 c = a / b;
234         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
235 
236         return c;
237     }
238 
239     /**
240      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
241      * Reverts when dividing by zero.
242      *
243      * Counterpart to Solidity's `%` operator. This function uses a `revert`
244      * opcode (which leaves remaining gas untouched) while Solidity uses an
245      * invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      *
249      * - The divisor cannot be zero.
250      */
251     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
252         return mod(a, b, "SafeMath: modulo by zero");
253     }
254 
255     /**
256      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
257      * Reverts with custom message when dividing by zero.
258      *
259      * Counterpart to Solidity's `%` operator. This function uses a `revert`
260      * opcode (which leaves remaining gas untouched) while Solidity uses an
261      * invalid opcode to revert (consuming all remaining gas).
262      *
263      * Requirements:
264      *
265      * - The divisor cannot be zero.
266      */
267     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
268         require(b != 0, errorMessage);
269         return a % b;
270     }
271 }
272 
273 // File: openzeppelin-solidity\contracts\utils\Address.sol
274 
275 // SPDX-License-Identifier: MIT
276 
277 pragma solidity ^0.6.2;
278 
279 /**
280  * @dev Collection of functions related to the address type
281  */
282 library Address {
283     /**
284      * @dev Returns true if `account` is a contract.
285      *
286      * [IMPORTANT]
287      * ====
288      * It is unsafe to assume that an address for which this function returns
289      * false is an externally-owned account (EOA) and not a contract.
290      *
291      * Among others, `isContract` will return false for the following
292      * types of addresses:
293      *
294      *  - an externally-owned account
295      *  - a contract in construction
296      *  - an address where a contract will be created
297      *  - an address where a contract lived, but was destroyed
298      * ====
299      */
300     function isContract(address account) internal view returns (bool) {
301         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
302         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
303         // for accounts without code, i.e. `keccak256('')`
304         bytes32 codehash;
305         bytes32 accountHash = 0;
306         // solhint-disable-next-line no-inline-assembly
307         assembly { codehash := extcodehash(account) }
308         return (codehash != accountHash && codehash != 0x0);
309     }
310 
311     /**
312      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
313      * `recipient`, forwarding all available gas and reverting on errors.
314      *
315      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
316      * of certain opcodes, possibly making contracts go over the 2300 gas limit
317      * imposed by `transfer`, making them unable to receive funds via
318      * `transfer`. {sendValue} removes this limitation.
319      *
320      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
321      *
322      * IMPORTANT: because control is transferred to `recipient`, care must be
323      * taken to not create reentrancy vulnerabilities. Consider using
324      * {ReentrancyGuard} or the
325      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
326      */
327     function sendValue(address payable recipient, uint256 amount) internal {
328         require(address(this).balance >= amount, "Address: insufficient balance");
329 
330         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
331         (bool success, ) = recipient.call{ value: amount }("");
332         require(success, "Address: unable to send value, recipient may have reverted");
333     }
334 
335     /**
336      * @dev Performs a Solidity function call using a low level `call`. A
337      * plain`call` is an unsafe replacement for a function call: use this
338      * function instead.
339      *
340      * If `target` reverts with a revert reason, it is bubbled up by this
341      * function (like regular Solidity function calls).
342      *
343      * Returns the raw returned data. To convert to the expected return value,
344      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
345      *
346      * Requirements:
347      *
348      * - `target` must be a contract.
349      * - calling `target` with `data` must not revert.
350      *
351      * _Available since v3.1._
352      */
353     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
354       return functionCall(target, data, "Address: low-level call failed");
355     }
356 
357     /**
358      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
359      * `errorMessage` as a fallback revert reason when `target` reverts.
360      *
361      * _Available since v3.1._
362      */
363     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
364         return _functionCallWithValue(target, data, 0, errorMessage);
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
369      * but also transferring `value` wei to `target`.
370      *
371      * Requirements:
372      *
373      * - the calling contract must have an ETH balance of at least `value`.
374      * - the called Solidity function must be `payable`.
375      *
376      * _Available since v3.1._
377      */
378     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
379         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
380     }
381 
382     /**
383      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
384      * with `errorMessage` as a fallback revert reason when `target` reverts.
385      *
386      * _Available since v3.1._
387      */
388     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
389         require(address(this).balance >= value, "Address: insufficient balance for call");
390         return _functionCallWithValue(target, data, value, errorMessage);
391     }
392 
393     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
394         require(isContract(target), "Address: call to non-contract");
395 
396         // solhint-disable-next-line avoid-low-level-calls
397         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
398         if (success) {
399             return returndata;
400         } else {
401             // Look for revert reason and bubble it up if present
402             if (returndata.length > 0) {
403                 // The easiest way to bubble the revert reason is using memory via assembly
404 
405                 // solhint-disable-next-line no-inline-assembly
406                 assembly {
407                     let returndata_size := mload(returndata)
408                     revert(add(32, returndata), returndata_size)
409                 }
410             } else {
411                 revert(errorMessage);
412             }
413         }
414     }
415 }
416 
417 // File: openzeppelin-solidity\contracts\access\Ownable.sol
418 
419 // SPDX-License-Identifier: MIT
420 
421 pragma solidity ^0.6.0;
422 
423 /**
424  * @dev Contract module which provides a basic access control mechanism, where
425  * there is an account (an owner) that can be granted exclusive access to
426  * specific functions.
427  *
428  * By default, the owner account will be the one that deploys the contract. This
429  * can later be changed with {transferOwnership}.
430  *
431  * This module is used through inheritance. It will make available the modifier
432  * `onlyOwner`, which can be applied to your functions to restrict their use to
433  * the owner.
434  */
435 contract Ownable is Context {
436     address private _owner;
437 
438     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
439 
440     /**
441      * @dev Initializes the contract setting the deployer as the initial owner.
442      */
443     constructor () internal {
444         address msgSender = _msgSender();
445         _owner = msgSender;
446         emit OwnershipTransferred(address(0), msgSender);
447     }
448 
449     /**
450      * @dev Returns the address of the current owner.
451      */
452     function owner() public view returns (address) {
453         return _owner;
454     }
455 
456     /**
457      * @dev Throws if called by any account other than the owner.
458      */
459     modifier onlyOwner() {
460         require(_owner == _msgSender(), "Ownable: caller is not the owner");
461         _;
462     }
463 
464     /**
465      * @dev Leaves the contract without owner. It will not be possible to call
466      * `onlyOwner` functions anymore. Can only be called by the current owner.
467      *
468      * NOTE: Renouncing ownership will leave the contract without an owner,
469      * thereby removing any functionality that is only available to the owner.
470      */
471     function renounceOwnership() public virtual onlyOwner {
472         emit OwnershipTransferred(_owner, address(0));
473         _owner = address(0);
474     }
475 
476     /**
477      * @dev Transfers ownership of the contract to a new account (`newOwner`).
478      * Can only be called by the current owner.
479      */
480     function transferOwnership(address newOwner) public virtual onlyOwner {
481         require(newOwner != address(0), "Ownable: new owner is the zero address");
482         emit OwnershipTransferred(_owner, newOwner);
483         _owner = newOwner;
484     }
485 }
486 
487 // File: contracts\IGNITETOKEN.sol
488 
489 /*
490 
491  */
492 
493 pragma solidity ^0.6.2;
494 
495 
496 
497 
498 
499 
500 contract IGNITE is Context, IERC20, Ownable {
501     using SafeMath for uint256;
502     using Address for address;
503 
504     mapping (address => uint256) private _rOwned;
505     mapping (address => uint256) private _tOwned;
506     mapping (address => mapping (address => uint256)) private _allowances;
507 
508     mapping (address => bool) private _isExcluded;
509     address[] private _excluded;
510    
511     uint256 private constant MAX = ~uint256(0);
512     uint256 private constant _tTotal = 10 * 10**6 * 10**9;
513     uint256 private _rTotal = (MAX - (MAX % _tTotal));
514     uint256 private _tFeeTotal;
515 
516     string private _name = 'IGNITE';
517     string private _symbol = 'IGN';
518     uint8 private _decimals = 9;
519 
520     constructor () public {
521         _rOwned[_msgSender()] = _rTotal;
522         emit Transfer(address(0), _msgSender(), _tTotal);
523     }
524 
525     function name() public view returns (string memory) {
526         return _name;
527     }
528 
529     function symbol() public view returns (string memory) {
530         return _symbol;
531     }
532 
533     function decimals() public view returns (uint8) {
534         return _decimals;
535     }
536 
537     function totalSupply() public view override returns (uint256) {
538         return _tTotal;
539     }
540 
541     function balanceOf(address account) public view override returns (uint256) {
542         if (_isExcluded[account]) return _tOwned[account];
543         return tokenFromReflection(_rOwned[account]);
544     }
545 
546     function transfer(address recipient, uint256 amount) public override returns (bool) {
547         _transfer(_msgSender(), recipient, amount);
548         return true;
549     }
550 
551     function allowance(address owner, address spender) public view override returns (uint256) {
552         return _allowances[owner][spender];
553     }
554 
555     function approve(address spender, uint256 amount) public override returns (bool) {
556         _approve(_msgSender(), spender, amount);
557         return true;
558     }
559 
560     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
561         _transfer(sender, recipient, amount);
562         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
563         return true;
564     }
565 
566     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
567         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
568         return true;
569     }
570 
571     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
572         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
573         return true;
574     }
575 
576     function isExcluded(address account) public view returns (bool) {
577         return _isExcluded[account];
578     }
579 
580     function totalFees() public view returns (uint256) {
581         return _tFeeTotal;
582     }
583 
584     function Ignite(uint256 tAmount) public {
585         address sender = _msgSender();
586         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
587         (uint256 rAmount,,,,) = _getValues(tAmount);
588         _rOwned[sender] = _rOwned[sender].sub(rAmount);
589         _rTotal = _rTotal.sub(rAmount);
590         _tFeeTotal = _tFeeTotal.add(tAmount);
591     }
592 
593     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
594         require(tAmount <= _tTotal, "Amount must be less than supply");
595         if (!deductTransferFee) {
596             (uint256 rAmount,,,,) = _getValues(tAmount);
597             return rAmount;
598         } else {
599             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
600             return rTransferAmount;
601         }
602     }
603 
604     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
605         require(rAmount <= _rTotal, "Amount must be less than total reflections");
606         uint256 currentRate =  _getRate();
607         return rAmount.div(currentRate);
608     }
609 
610     function excludeAccount(address account) external onlyOwner() {
611         require(!_isExcluded[account], "Account is already excluded");
612         if(_rOwned[account] > 0) {
613             _tOwned[account] = tokenFromReflection(_rOwned[account]);
614         }
615         _isExcluded[account] = true;
616         _excluded.push(account);
617     }
618 
619     function includeAccount(address account) external onlyOwner() {
620         require(_isExcluded[account], "Account is already excluded");
621         for (uint256 i = 0; i < _excluded.length; i++) {
622             if (_excluded[i] == account) {
623                 _excluded[i] = _excluded[_excluded.length - 1];
624                 _tOwned[account] = 0;
625                 _isExcluded[account] = false;
626                 _excluded.pop();
627                 break;
628             }
629         }
630     }
631 
632     function _approve(address owner, address spender, uint256 amount) private {
633         require(owner != address(0), "ERC20: approve from the zero address");
634         require(spender != address(0), "ERC20: approve to the zero address");
635 
636         _allowances[owner][spender] = amount;
637         emit Approval(owner, spender, amount);
638     }
639 
640     function _transfer(address sender, address recipient, uint256 amount) private {
641         require(sender != address(0), "ERC20: transfer from the zero address");
642         require(recipient != address(0), "ERC20: transfer to the zero address");
643         require(amount > 0, "Transfer amount must be greater than zero");
644         if (_isExcluded[sender] && !_isExcluded[recipient]) {
645             _transferFromExcluded(sender, recipient, amount);
646         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
647             _transferToExcluded(sender, recipient, amount);
648         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
649             _transferStandard(sender, recipient, amount);
650         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
651             _transferBothExcluded(sender, recipient, amount);
652         } else {
653             _transferStandard(sender, recipient, amount);
654         }
655     }
656 
657     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
658         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
659         _rOwned[sender] = _rOwned[sender].sub(rAmount);
660         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
661         _reflectFee(rFee, tFee);
662         emit Transfer(sender, recipient, tTransferAmount);
663     }
664 
665     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
666         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
667         _rOwned[sender] = _rOwned[sender].sub(rAmount);
668         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
669         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
670         _reflectFee(rFee, tFee);
671         emit Transfer(sender, recipient, tTransferAmount);
672     }
673 
674     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
675         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
676         _tOwned[sender] = _tOwned[sender].sub(tAmount);
677         _rOwned[sender] = _rOwned[sender].sub(rAmount);
678         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
679         _reflectFee(rFee, tFee);
680         emit Transfer(sender, recipient, tTransferAmount);
681     }
682 
683     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
684         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
685         _tOwned[sender] = _tOwned[sender].sub(tAmount);
686         _rOwned[sender] = _rOwned[sender].sub(rAmount);
687         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
688         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
689         _reflectFee(rFee, tFee);
690         emit Transfer(sender, recipient, tTransferAmount);
691     }
692 
693     function _reflectFee(uint256 rFee, uint256 tFee) private {
694         _rTotal = _rTotal.sub(rFee);
695         _tFeeTotal = _tFeeTotal.add(tFee);
696     }
697 
698     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
699         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
700         uint256 currentRate =  _getRate();
701         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
702         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
703     }
704 
705     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
706         uint256 tFee = tAmount.div(100).mul(8);
707         uint256 tTransferAmount = tAmount.sub(tFee);
708         return (tTransferAmount, tFee);
709     }
710 
711     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
712         uint256 rAmount = tAmount.mul(currentRate);
713         uint256 rFee = tFee.mul(currentRate);
714         uint256 rTransferAmount = rAmount.sub(rFee);
715         return (rAmount, rTransferAmount, rFee);
716     }
717 
718     function _getRate() private view returns(uint256) {
719         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
720         return rSupply.div(tSupply);
721     }
722 
723     function _getCurrentSupply() private view returns(uint256, uint256) {
724         uint256 rSupply = _rTotal;
725         uint256 tSupply = _tTotal;      
726         for (uint256 i = 0; i < _excluded.length; i++) {
727             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
728             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
729             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
730         }
731         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
732         return (rSupply, tSupply);
733     }
734 }