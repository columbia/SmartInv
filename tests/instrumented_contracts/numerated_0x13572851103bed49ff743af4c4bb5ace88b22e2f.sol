1 /**
2  *Submitted for verification at Etherscan.io on 2020-12-12
3 */
4 
5 // R3FI.Finance: DeFi token with 5% reflect redistribution tax
6 
7 
8 // R3fi is a modified fork of RFI & RFCTR
9 // SPDX-License-Identifier: MIT
10 
11 pragma solidity ^0.6.0;
12 
13 /*
14  * @dev Provides information about the current execution context, including the
15  * sender of the transaction and its data. While these are generally available
16  * via msg.sender and msg.data, they should not be accessed in such a direct
17  * manner, since when dealing with GSN meta-transactions the account sending and
18  * paying for execution may not be the actual sender (as far as an application
19  * is concerned).
20  *
21  * This contract is only required for intermediate, library-like contracts.
22  */
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address payable) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes memory) {
29         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30         return msg.data;
31     }
32 }
33 
34 // File: openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
35 
36 // SPDX-License-Identifier: MIT
37 
38 pragma solidity ^0.6.0;
39 
40 /**
41  * @dev Interface of the ERC20 standard as defined in the EIP.
42  */
43 interface IERC20 {
44     /**
45      * @dev Returns the amount of tokens in existence.
46      */
47     function totalSupply() external view returns (uint256);
48 
49     /**
50      * @dev Returns the amount of tokens owned by `account`.
51      */
52     function balanceOf(address account) external view returns (uint256);
53 
54     /**
55      * @dev Moves `amount` tokens from the caller's account to `recipient`.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transfer(address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Returns the remaining number of tokens that `spender` will be
65      * allowed to spend on behalf of `owner` through {transferFrom}. This is
66      * zero by default.
67      *
68      * This value changes when {approve} or {transferFrom} are called.
69      */
70     function allowance(address owner, address spender) external view returns (uint256);
71 
72     /**
73      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * IMPORTANT: Beware that changing an allowance with this method brings the risk
78      * that someone may use both the old and the new allowance by unfortunate
79      * transaction ordering. One possible solution to mitigate this race
80      * condition is to first reduce the spender's allowance to 0 and set the
81      * desired value afterwards:
82      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
83      *
84      * Emits an {Approval} event.
85      */
86     function approve(address spender, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Moves `amount` tokens from `sender` to `recipient` using the
90      * allowance mechanism. `amount` is then deducted from the caller's
91      * allowance.
92      *
93      * Returns a boolean value indicating whether the operation succeeded.
94      *
95      * Emits a {Transfer} event.
96      */
97     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
98 
99     /**
100      * @dev Emitted when `value` tokens are moved from one account (`from`) to
101      * another (`to`).
102      *
103      * Note that `value` may be zero.
104      */
105     event Transfer(address indexed from, address indexed to, uint256 value);
106 
107     /**
108      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
109      * a call to {approve}. `value` is the new allowance.
110      */
111     event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 // File: openzeppelin-solidity\contracts\math\SafeMath.sol
115 
116 // SPDX-License-Identifier: MIT
117 
118 pragma solidity ^0.6.0;
119 
120 /**
121  * @dev Wrappers over Solidity's arithmetic operations with added overflow
122  * checks.
123  *
124  * Arithmetic operations in Solidity wrap on overflow. This can easily result
125  * in bugs, because programmers usually assume that an overflow raises an
126  * error, which is the standard behavior in high level programming languages.
127  * `SafeMath` restores this intuition by reverting the transaction when an
128  * operation overflows.
129  *
130  * Using this library instead of the unchecked operations eliminates an entire
131  * class of bugs, so it's recommended to use it always.
132  */
133 library SafeMath {
134     /**
135      * @dev Returns the addition of two unsigned integers, reverting on
136      * overflow.
137      *
138      * Counterpart to Solidity's `+` operator.
139      *
140      * Requirements:
141      *
142      * - Addition cannot overflow.
143      */
144     function add(uint256 a, uint256 b) internal pure returns (uint256) {
145         uint256 c = a + b;
146         require(c >= a, "SafeMath: addition overflow");
147 
148         return c;
149     }
150 
151     /**
152      * @dev Returns the subtraction of two unsigned integers, reverting on
153      * overflow (when the result is negative).
154      *
155      * Counterpart to Solidity's `-` operator.
156      *
157      * Requirements:
158      *
159      * - Subtraction cannot overflow.
160      */
161     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
162         return sub(a, b, "SafeMath: subtraction overflow");
163     }
164 
165     /**
166      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
167      * overflow (when the result is negative).
168      *
169      * Counterpart to Solidity's `-` operator.
170      *
171      * Requirements:
172      *
173      * - Subtraction cannot overflow.
174      */
175     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
176         require(b <= a, errorMessage);
177         uint256 c = a - b;
178 
179         return c;
180     }
181 
182     /**
183      * @dev Returns the multiplication of two unsigned integers, reverting on
184      * overflow.
185      *
186      * Counterpart to Solidity's `*` operator.
187      *
188      * Requirements:
189      *
190      * - Multiplication cannot overflow.
191      */
192     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
193         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
194         // benefit is lost if 'b' is also tested.
195         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
196         if (a == 0) {
197             return 0;
198         }
199 
200         uint256 c = a * b;
201         require(c / a == b, "SafeMath: multiplication overflow");
202 
203         return c;
204     }
205 
206     /**
207      * @dev Returns the integer division of two unsigned integers. Reverts on
208      * division by zero. The result is rounded towards zero.
209      *
210      * Counterpart to Solidity's `/` operator. Note: this function uses a
211      * `revert` opcode (which leaves remaining gas untouched) while Solidity
212      * uses an invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function div(uint256 a, uint256 b) internal pure returns (uint256) {
219         return div(a, b, "SafeMath: division by zero");
220     }
221 
222     /**
223      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
224      * division by zero. The result is rounded towards zero.
225      *
226      * Counterpart to Solidity's `/` operator. Note: this function uses a
227      * `revert` opcode (which leaves remaining gas untouched) while Solidity
228      * uses an invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
235         require(b > 0, errorMessage);
236         uint256 c = a / b;
237         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
238 
239         return c;
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * Reverts when dividing by zero.
245      *
246      * Counterpart to Solidity's `%` operator. This function uses a `revert`
247      * opcode (which leaves remaining gas untouched) while Solidity uses an
248      * invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      *
252      * - The divisor cannot be zero.
253      */
254     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
255         return mod(a, b, "SafeMath: modulo by zero");
256     }
257 
258     /**
259      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
260      * Reverts with custom message when dividing by zero.
261      *
262      * Counterpart to Solidity's `%` operator. This function uses a `revert`
263      * opcode (which leaves remaining gas untouched) while Solidity uses an
264      * invalid opcode to revert (consuming all remaining gas).
265      *
266      * Requirements:
267      *
268      * - The divisor cannot be zero.
269      */
270     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
271         require(b != 0, errorMessage);
272         return a % b;
273     }
274 }
275 
276 // File: openzeppelin-solidity\contracts\utils\Address.sol
277 
278 // SPDX-License-Identifier: MIT
279 
280 pragma solidity ^0.6.2;
281 
282 /**
283  * @dev Collection of functions related to the address type
284  */
285 library Address {
286     /**
287      * @dev Returns true if `account` is a contract.
288      *
289      * [IMPORTANT]
290      * ====
291      * It is unsafe to assume that an address for which this function returns
292      * false is an externally-owned account (EOA) and not a contract.
293      *
294      * Among others, `isContract` will return false for the following
295      * types of addresses:
296      *
297      *  - an externally-owned account
298      *  - a contract in construction
299      *  - an address where a contract will be created
300      *  - an address where a contract lived, but was destroyed
301      * ====
302      */
303     function isContract(address account) internal view returns (bool) {
304         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
305         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
306         // for accounts without code, i.e. `keccak256('')`
307         bytes32 codehash;
308         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
309         // solhint-disable-next-line no-inline-assembly
310         assembly { codehash := extcodehash(account) }
311         return (codehash != accountHash && codehash != 0x0);
312     }
313 
314     /**
315      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
316      * `recipient`, forwarding all available gas and reverting on errors.
317      *
318      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
319      * of certain opcodes, possibly making contracts go over the 2300 gas limit
320      * imposed by `transfer`, making them unable to receive funds via
321      * `transfer`. {sendValue} removes this limitation.
322      *
323      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
324      *
325      * IMPORTANT: because control is transferred to `recipient`, care must be
326      * taken to not create reentrancy vulnerabilities. Consider using
327      * {ReentrancyGuard} or the
328      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
329      */
330     function sendValue(address payable recipient, uint256 amount) internal {
331         require(address(this).balance >= amount, "Address: insufficient balance");
332 
333         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
334         (bool success, ) = recipient.call{ value: amount }("");
335         require(success, "Address: unable to send value, recipient may have reverted");
336     }
337 
338     /**
339      * @dev Performs a Solidity function call using a low level `call`. A
340      * plain`call` is an unsafe replacement for a function call: use this
341      * function instead.
342      *
343      * If `target` reverts with a revert reason, it is bubbled up by this
344      * function (like regular Solidity function calls).
345      *
346      * Returns the raw returned data. To convert to the expected return value,
347      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
348      *
349      * Requirements:
350      *
351      * - `target` must be a contract.
352      * - calling `target` with `data` must not revert.
353      *
354      * _Available since v3.1._
355      */
356     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
357         return functionCall(target, data, "Address: low-level call failed");
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
362      * `errorMessage` as a fallback revert reason when `target` reverts.
363      *
364      * _Available since v3.1._
365      */
366     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
367         return _functionCallWithValue(target, data, 0, errorMessage);
368     }
369 
370     /**
371      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
372      * but also transferring `value` wei to `target`.
373      *
374      * Requirements:
375      *
376      * - the calling contract must have an ETH balance of at least `value`.
377      * - the called Solidity function must be `payable`.
378      *
379      * _Available since v3.1._
380      */
381     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
382         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
383     }
384 
385     /**
386      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
387      * with `errorMessage` as a fallback revert reason when `target` reverts.
388      *
389      * _Available since v3.1._
390      */
391     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
392         require(address(this).balance >= value, "Address: insufficient balance for call");
393         return _functionCallWithValue(target, data, value, errorMessage);
394     }
395 
396     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
397         require(isContract(target), "Address: call to non-contract");
398 
399         // solhint-disable-next-line avoid-low-level-calls
400         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
401         if (success) {
402             return returndata;
403         } else {
404             // Look for revert reason and bubble it up if present
405             if (returndata.length > 0) {
406                 // The easiest way to bubble the revert reason is using memory via assembly
407 
408                 // solhint-disable-next-line no-inline-assembly
409                 assembly {
410                     let returndata_size := mload(returndata)
411                     revert(add(32, returndata), returndata_size)
412                 }
413             } else {
414                 revert(errorMessage);
415             }
416         }
417     }
418 }
419 
420 // File: openzeppelin-solidity\contracts\access\Ownable.sol
421 
422 // SPDX-License-Identifier: MIT
423 
424 pragma solidity ^0.6.0;
425 
426 /**
427  * @dev Contract module which provides a basic access control mechanism, where
428  * there is an account (an owner) that can be granted exclusive access to
429  * specific functions.
430  *
431  * By default, the owner account will be the one that deploys the contract. This
432  * can later be changed with {transferOwnership}.
433  *
434  * This module is used through inheritance. It will make available the modifier
435  * `onlyOwner`, which can be applied to your functions to restrict their use to
436  * the owner.
437  */
438 contract Ownable is Context {
439     address private _owner;
440 
441     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
442 
443     /**
444      * @dev Initializes the contract setting the deployer as the initial owner.
445      */
446     constructor () internal {
447         address msgSender = _msgSender();
448         _owner = msgSender;
449         emit OwnershipTransferred(address(0), msgSender);
450     }
451 
452     /**
453      * @dev Returns the address of the current owner.
454      */
455     function owner() public view returns (address) {
456         return _owner;
457     }
458 
459     /**
460      * @dev Throws if called by any account other than the owner.
461      */
462     modifier onlyOwner() {
463         require(_owner == _msgSender(), "Ownable: caller is not the owner");
464         _;
465     }
466 
467     /**
468      * @dev Leaves the contract without owner. It will not be possible to call
469      * `onlyOwner` functions anymore. Can only be called by the current owner.
470      *
471      * NOTE: Renouncing ownership will leave the contract without an owner,
472      * thereby removing any functionality that is only available to the owner.
473      */
474     function renounceOwnership() public virtual onlyOwner {
475         emit OwnershipTransferred(_owner, address(0));
476         _owner = address(0);
477     }
478 
479     /**
480      * @dev Transfers ownership of the contract to a new account (`newOwner`).
481      * Can only be called by the current owner.
482      */
483     function transferOwnership(address newOwner) public virtual onlyOwner {
484         require(newOwner != address(0), "Ownable: new owner is the zero address");
485         emit OwnershipTransferred(_owner, newOwner);
486         _owner = newOwner;
487     }
488 }
489 
490 
491 pragma solidity ^0.6.2;
492 
493 contract R3FItoken is Context, IERC20, Ownable {
494     using SafeMath for uint256;
495     using Address for address;
496 
497     mapping (address => uint256) private _rOwned;
498     mapping (address => uint256) private _tOwned;
499     mapping (address => mapping (address => uint256)) private _allowances;
500 
501     mapping (address => bool) private _isExcluded;
502     address[] private _excluded;
503 
504     uint256 private constant MAX = ~uint256(0);
505     uint256 private constant _tTotal = 5 * 10**6 * 10**9;
506     uint256 private _rTotal = (MAX - (MAX % _tTotal));
507     uint256 private _tFeeTotal;
508 
509     string private _name = 'r3fi.finance';
510     string private _symbol = 'R3FI';
511     uint8 private _decimals = 9;
512 
513     constructor () public {
514         _rOwned[_msgSender()] = _rTotal;
515         emit Transfer(address(0), _msgSender(), _tTotal);
516     }
517 
518     function name() public view returns (string memory) {
519         return _name;
520     }
521 
522     function symbol() public view returns (string memory) {
523         return _symbol;
524     }
525 
526     function decimals() public view returns (uint8) {
527         return _decimals;
528     }
529 
530     function totalSupply() public view override returns (uint256) {
531         return _tTotal;
532     }
533 
534     function balanceOf(address account) public view override returns (uint256) {
535         if (_isExcluded[account]) return _tOwned[account];
536         return tokenFromReflection(_rOwned[account]);
537     }
538 
539     function transfer(address recipient, uint256 amount) public override returns (bool) {
540         _transfer(_msgSender(), recipient, amount);
541         return true;
542     }
543 
544     function allowance(address owner, address spender) public view override returns (uint256) {
545         return _allowances[owner][spender];
546     }
547 
548     function approve(address spender, uint256 amount) public override returns (bool) {
549         _approve(_msgSender(), spender, amount);
550         return true;
551     }
552 
553     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
554         _transfer(sender, recipient, amount);
555         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
556         return true;
557     }
558 
559     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
560         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
561         return true;
562     }
563 
564     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
565         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
566         return true;
567     }
568 
569     function isExcluded(address account) public view returns (bool) {
570         return _isExcluded[account];
571     }
572 
573     function totalFees() public view returns (uint256) {
574         return _tFeeTotal;
575     }
576 
577     function reflect(uint256 tAmount) public {
578         address sender = _msgSender();
579         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
580         (uint256 rAmount,,,,) = _getValues(tAmount);
581         _rOwned[sender] = _rOwned[sender].sub(rAmount);
582         _rTotal = _rTotal.sub(rAmount);
583         _tFeeTotal = _tFeeTotal.add(tAmount);
584     }
585 
586     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
587         require(tAmount <= _tTotal, "Amount must be less than supply");
588         if (!deductTransferFee) {
589             (uint256 rAmount,,,,) = _getValues(tAmount);
590             return rAmount;
591         } else {
592             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
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
604         require(!_isExcluded[account], "Account is already excluded");
605         if(_rOwned[account] > 0) {
606             _tOwned[account] = tokenFromReflection(_rOwned[account]);
607         }
608         _isExcluded[account] = true;
609         _excluded.push(account);
610     }
611 
612     function includeAccount(address account) external onlyOwner() {
613         require(_isExcluded[account], "Account is already excluded");
614         for (uint256 i = 0; i < _excluded.length; i++) {
615             if (_excluded[i] == account) {
616                 _excluded[i] = _excluded[_excluded.length - 1];
617                 _tOwned[account] = 0;
618                 _isExcluded[account] = false;
619                 _excluded.pop();
620                 break;
621             }
622         }
623     }
624 
625     function _approve(address owner, address spender, uint256 amount) private {
626         require(owner != address(0), "ERC20: approve from the zero address");
627         require(spender != address(0), "ERC20: approve to the zero address");
628 
629         _allowances[owner][spender] = amount;
630         emit Approval(owner, spender, amount);
631     }
632 
633     function _transfer(address sender, address recipient, uint256 amount) private {
634         require(sender != address(0), "ERC20: transfer from the zero address");
635         require(recipient != address(0), "ERC20: transfer to the zero address");
636         require(amount > 0, "Transfer amount must be greater than zero");
637         if (_isExcluded[sender] && !_isExcluded[recipient]) {
638             _transferFromExcluded(sender, recipient, amount);
639         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
640             _transferToExcluded(sender, recipient, amount);
641         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
642             _transferStandard(sender, recipient, amount);
643         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
644             _transferBothExcluded(sender, recipient, amount);
645         } else {
646             _transferStandard(sender, recipient, amount);
647         }
648     }
649 
650     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
651         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
652         _rOwned[sender] = _rOwned[sender].sub(rAmount);
653         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
654         _reflectFee(rFee, tFee);
655         emit Transfer(sender, recipient, tTransferAmount);
656     }
657 
658     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
659         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
660         _rOwned[sender] = _rOwned[sender].sub(rAmount);
661         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
662         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
663         _reflectFee(rFee, tFee);
664         emit Transfer(sender, recipient, tTransferAmount);
665     }
666 
667     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
668         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
669         _tOwned[sender] = _tOwned[sender].sub(tAmount);
670         _rOwned[sender] = _rOwned[sender].sub(rAmount);
671         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
672         _reflectFee(rFee, tFee);
673         emit Transfer(sender, recipient, tTransferAmount);
674     }
675 
676     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
677         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
678         _tOwned[sender] = _tOwned[sender].sub(tAmount);
679         _rOwned[sender] = _rOwned[sender].sub(rAmount);
680         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
681         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
682         _reflectFee(rFee, tFee);
683         emit Transfer(sender, recipient, tTransferAmount);
684     }
685 
686     function _reflectFee(uint256 rFee, uint256 tFee) private {
687         _rTotal = _rTotal.sub(rFee);
688         _tFeeTotal = _tFeeTotal.add(tFee);
689     }
690 
691     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
692         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
693         uint256 currentRate =  _getRate();
694         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
695         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
696     }
697 
698     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
699         uint256 tFee = tAmount.mul(5).div(100);
700         uint256 tTransferAmount = tAmount.sub(tFee);
701         return (tTransferAmount, tFee);
702     }
703 
704     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
705         uint256 rAmount = tAmount.mul(currentRate);
706         uint256 rFee = tFee.mul(currentRate);
707         uint256 rTransferAmount = rAmount.sub(rFee);
708         return (rAmount, rTransferAmount, rFee);
709     }
710 
711     function _getRate() private view returns(uint256) {
712         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
713         return rSupply.div(tSupply);
714     }
715 
716     function _getCurrentSupply() private view returns(uint256, uint256) {
717         uint256 rSupply = _rTotal;
718         uint256 tSupply = _tTotal;
719         for (uint256 i = 0; i < _excluded.length; i++) {
720             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
721             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
722             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
723         }
724         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
725         return (rSupply, tSupply);
726     }
727 }