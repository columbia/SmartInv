1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-19
3 */
4 
5 // File: openzeppelin-solidity\contracts\GSN\Context.sol
6 
7 // SPDX-License-Identifier: MIT
8 
9 pragma solidity ^0.6.0;
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
22     function _msgSender() internal view virtual returns (address payable) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 // File: openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
33 
34 // SPDX-License-Identifier: MIT
35 
36 pragma solidity ^0.6.0;
37 
38 /**
39  * @dev Interface of the ERC20 standard as defined in the EIP.
40  */
41 interface IERC20 {
42     /**
43      * @dev Returns the amount of tokens in existence.
44      */
45     function totalSupply() external view returns (uint256);
46 
47     /**
48      * @dev Returns the amount of tokens owned by `account`.
49      */
50     function balanceOf(address account) external view returns (uint256);
51 
52     /**
53      * @dev Moves `amount` tokens from the caller's account to `recipient`.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * Emits a {Transfer} event.
58      */
59     function transfer(address recipient, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Returns the remaining number of tokens that `spender` will be
63      * allowed to spend on behalf of `owner` through {transferFrom}. This is
64      * zero by default.
65      *
66      * This value changes when {approve} or {transferFrom} are called.
67      */
68     function allowance(address owner, address spender) external view returns (uint256);
69 
70     /**
71      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * IMPORTANT: Beware that changing an allowance with this method brings the risk
76      * that someone may use both the old and the new allowance by unfortunate
77      * transaction ordering. One possible solution to mitigate this race
78      * condition is to first reduce the spender's allowance to 0 and set the
79      * desired value afterwards:
80      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
81      *
82      * Emits an {Approval} event.
83      */
84     function approve(address spender, uint256 amount) external returns (bool);
85 
86     /**
87      * @dev Moves `amount` tokens from `sender` to `recipient` using the
88      * allowance mechanism. `amount` is then deducted from the caller's
89      * allowance.
90      *
91      * Returns a boolean value indicating whether the operation succeeded.
92      *
93      * Emits a {Transfer} event.
94      */
95     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
96 
97     /**
98      * @dev Emitted when `value` tokens are moved from one account (`from`) to
99      * another (`to`).
100      *
101      * Note that `value` may be zero.
102      */
103     event Transfer(address indexed from, address indexed to, uint256 value);
104 
105     /**
106      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
107      * a call to {approve}. `value` is the new allowance.
108      */
109     event Approval(address indexed owner, address indexed spender, uint256 value);
110 }
111 
112 // File: openzeppelin-solidity\contracts\math\SafeMath.sol
113 
114 // SPDX-License-Identifier: MIT
115 
116 pragma solidity ^0.6.0;
117 
118 /**
119  * @dev Wrappers over Solidity's arithmetic operations with added overflow
120  * checks.
121  *
122  * Arithmetic operations in Solidity wrap on overflow. This can easily result
123  * in bugs, because programmers usually assume that an overflow raises an
124  * error, which is the standard behavior in high level programming languages.
125  * `SafeMath` restores this intuition by reverting the transaction when an
126  * operation overflows.
127  *
128  * Using this library instead of the unchecked operations eliminates an entire
129  * class of bugs, so it's recommended to use it always.
130  */
131 library SafeMath {
132     /**
133      * @dev Returns the addition of two unsigned integers, reverting on
134      * overflow.
135      *
136      * Counterpart to Solidity's `+` operator.
137      *
138      * Requirements:
139      *
140      * - Addition cannot overflow.
141      */
142     function add(uint256 a, uint256 b) internal pure returns (uint256) {
143         uint256 c = a + b;
144         require(c >= a, "SafeMath: addition overflow");
145 
146         return c;
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
160         return sub(a, b, "SafeMath: subtraction overflow");
161     }
162 
163     /**
164      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
165      * overflow (when the result is negative).
166      *
167      * Counterpart to Solidity's `-` operator.
168      *
169      * Requirements:
170      *
171      * - Subtraction cannot overflow.
172      */
173     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
174         require(b <= a, errorMessage);
175         uint256 c = a - b;
176 
177         return c;
178     }
179 
180     /**
181      * @dev Returns the multiplication of two unsigned integers, reverting on
182      * overflow.
183      *
184      * Counterpart to Solidity's `*` operator.
185      *
186      * Requirements:
187      *
188      * - Multiplication cannot overflow.
189      */
190     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
191         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
192         // benefit is lost if 'b' is also tested.
193         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
194         if (a == 0) {
195             return 0;
196         }
197 
198         uint256 c = a * b;
199         require(c / a == b, "SafeMath: multiplication overflow");
200 
201         return c;
202     }
203 
204     /**
205      * @dev Returns the integer division of two unsigned integers. Reverts on
206      * division by zero. The result is rounded towards zero.
207      *
208      * Counterpart to Solidity's `/` operator. Note: this function uses a
209      * `revert` opcode (which leaves remaining gas untouched) while Solidity
210      * uses an invalid opcode to revert (consuming all remaining gas).
211      *
212      * Requirements:
213      *
214      * - The divisor cannot be zero.
215      */
216     function div(uint256 a, uint256 b) internal pure returns (uint256) {
217         return div(a, b, "SafeMath: division by zero");
218     }
219 
220     /**
221      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
222      * division by zero. The result is rounded towards zero.
223      *
224      * Counterpart to Solidity's `/` operator. Note: this function uses a
225      * `revert` opcode (which leaves remaining gas untouched) while Solidity
226      * uses an invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      *
230      * - The divisor cannot be zero.
231      */
232     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
233         require(b > 0, errorMessage);
234         uint256 c = a / b;
235         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
236 
237         return c;
238     }
239 
240     /**
241      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
242      * Reverts when dividing by zero.
243      *
244      * Counterpart to Solidity's `%` operator. This function uses a `revert`
245      * opcode (which leaves remaining gas untouched) while Solidity uses an
246      * invalid opcode to revert (consuming all remaining gas).
247      *
248      * Requirements:
249      *
250      * - The divisor cannot be zero.
251      */
252     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
253         return mod(a, b, "SafeMath: modulo by zero");
254     }
255 
256     /**
257      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
258      * Reverts with custom message when dividing by zero.
259      *
260      * Counterpart to Solidity's `%` operator. This function uses a `revert`
261      * opcode (which leaves remaining gas untouched) while Solidity uses an
262      * invalid opcode to revert (consuming all remaining gas).
263      *
264      * Requirements:
265      *
266      * - The divisor cannot be zero.
267      */
268     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
269         require(b != 0, errorMessage);
270         return a % b;
271     }
272 }
273 
274 // File: openzeppelin-solidity\contracts\utils\Address.sol
275 
276 // SPDX-License-Identifier: MIT
277 
278 pragma solidity ^0.6.2;
279 
280 /**
281  * @dev Collection of functions related to the address type
282  */
283 library Address {
284     /**
285      * @dev Returns true if `account` is a contract.
286      *
287      * [IMPORTANT]
288      * ====
289      * It is unsafe to assume that an address for which this function returns
290      * false is an externally-owned account (EOA) and not a contract.
291      *
292      * Among others, `isContract` will return false for the following
293      * types of addresses:
294      *
295      *  - an externally-owned account
296      *  - a contract in construction
297      *  - an address where a contract will be created
298      *  - an address where a contract lived, but was destroyed
299      * ====
300      */
301     function isContract(address account) internal view returns (bool) {
302         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
303         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
304         // for accounts without code, i.e. `keccak256('')`
305         bytes32 codehash;
306         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
307         // solhint-disable-next-line no-inline-assembly
308         assembly { codehash := extcodehash(account) }
309         return (codehash != accountHash && codehash != 0x0);
310     }
311 
312     /**
313      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
314      * `recipient`, forwarding all available gas and reverting on errors.
315      *
316      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
317      * of certain opcodes, possibly making contracts go over the 2300 gas limit
318      * imposed by `transfer`, making them unable to receive funds via
319      * `transfer`. {sendValue} removes this limitation.
320      *
321      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
322      *
323      * IMPORTANT: because control is transferred to `recipient`, care must be
324      * taken to not create reentrancy vulnerabilities. Consider using
325      * {ReentrancyGuard} or the
326      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
327      */
328     function sendValue(address payable recipient, uint256 amount) internal {
329         require(address(this).balance >= amount, "Address: insufficient balance");
330 
331         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
332         (bool success, ) = recipient.call{ value: amount }("");
333         require(success, "Address: unable to send value, recipient may have reverted");
334     }
335 
336     /**
337      * @dev Performs a Solidity function call using a low level `call`. A
338      * plain`call` is an unsafe replacement for a function call: use this
339      * function instead.
340      *
341      * If `target` reverts with a revert reason, it is bubbled up by this
342      * function (like regular Solidity function calls).
343      *
344      * Returns the raw returned data. To convert to the expected return value,
345      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
346      *
347      * Requirements:
348      *
349      * - `target` must be a contract.
350      * - calling `target` with `data` must not revert.
351      *
352      * _Available since v3.1._
353      */
354     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
355       return functionCall(target, data, "Address: low-level call failed");
356     }
357 
358     /**
359      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
360      * `errorMessage` as a fallback revert reason when `target` reverts.
361      *
362      * _Available since v3.1._
363      */
364     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
365         return _functionCallWithValue(target, data, 0, errorMessage);
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
370      * but also transferring `value` wei to `target`.
371      *
372      * Requirements:
373      *
374      * - the calling contract must have an ETH balance of at least `value`.
375      * - the called Solidity function must be `payable`.
376      *
377      * _Available since v3.1._
378      */
379     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
380         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
381     }
382 
383     /**
384      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
385      * with `errorMessage` as a fallback revert reason when `target` reverts.
386      *
387      * _Available since v3.1._
388      */
389     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
390         require(address(this).balance >= value, "Address: insufficient balance for call");
391         return _functionCallWithValue(target, data, value, errorMessage);
392     }
393 
394     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
395         require(isContract(target), "Address: call to non-contract");
396 
397         // solhint-disable-next-line avoid-low-level-calls
398         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
399         if (success) {
400             return returndata;
401         } else {
402             // Look for revert reason and bubble it up if present
403             if (returndata.length > 0) {
404                 // The easiest way to bubble the revert reason is using memory via assembly
405 
406                 // solhint-disable-next-line no-inline-assembly
407                 assembly {
408                     let returndata_size := mload(returndata)
409                     revert(add(32, returndata), returndata_size)
410                 }
411             } else {
412                 revert(errorMessage);
413             }
414         }
415     }
416 }
417 
418 // File: openzeppelin-solidity\contracts\access\Ownable.sol
419 
420 // SPDX-License-Identifier: MIT
421 
422 pragma solidity ^0.6.0;
423 
424 /**
425  * @dev Contract module which provides a basic access control mechanism, where
426  * there is an account (an owner) that can be granted exclusive access to
427  * specific functions.
428  *
429  * By default, the owner account will be the one that deploys the contract. This
430  * can later be changed with {transferOwnership}.
431  *
432  * This module is used through inheritance. It will make available the modifier
433  * `onlyOwner`, which can be applied to your functions to restrict their use to
434  * the owner.
435  */
436 contract Ownable is Context {
437     address private _owner;
438 
439     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
440 
441     /**
442      * @dev Initializes the contract setting the deployer as the initial owner.
443      */
444     constructor () internal {
445         address msgSender = _msgSender();
446         _owner = msgSender;
447         emit OwnershipTransferred(address(0), msgSender);
448     }
449 
450     /**
451      * @dev Returns the address of the current owner.
452      */
453     function owner() public view returns (address) {
454         return _owner;
455     }
456 
457     /**
458      * @dev Throws if called by any account other than the owner.
459      */
460     modifier onlyOwner() {
461         require(_owner == _msgSender(), "Ownable: caller is not the owner");
462         _;
463     }
464 
465     /**
466      * @dev Leaves the contract without owner. It will not be possible to call
467      * `onlyOwner` functions anymore. Can only be called by the current owner.
468      *
469      * NOTE: Renouncing ownership will leave the contract without an owner,
470      * thereby removing any functionality that is only available to the owner.
471      */
472     function renounceOwnership() public virtual onlyOwner {
473         emit OwnershipTransferred(_owner, address(0));
474         _owner = address(0);
475     }
476 
477     /**
478      * @dev Transfers ownership of the contract to a new account (`newOwner`).
479      * Can only be called by the current owner.
480      */
481     function transferOwnership(address newOwner) public virtual onlyOwner {
482         require(newOwner != address(0), "Ownable: new owner is the zero address");
483         emit OwnershipTransferred(_owner, newOwner);
484         _owner = newOwner;
485     }
486 }
487 
488 // File: contracts\REFLECT.sol
489 
490 /*
491  * Copyright 2020 reflect.finance. ALL RIGHTS RESERVED.
492  */
493 
494 pragma solidity ^0.6.2;
495 
496 
497 
498 
499 
500 
501 contract REFLECTFINANCEDEGEN is Context, IERC20, Ownable {
502     using SafeMath for uint256;
503     using Address for address;
504 
505     mapping (address => uint256) private _rOwned;
506     mapping (address => uint256) private _tOwned;
507     mapping (address => mapping (address => uint256)) private _allowances;
508 
509     mapping (address => bool) private _isExcluded;
510     address[] private _excluded;
511    
512     uint256 private constant MAX = ~uint256(0);
513     uint256 private constant _tTotal = 10 * 10**6 * 10**9;
514     uint256 private _rTotal = (MAX - (MAX % _tTotal));
515     uint256 private _tFeeTotal;
516 
517     string private _name = 'reflect.financedegen';
518     string private _symbol = 'RFD';
519     uint8 private _decimals = 9;
520 
521     constructor () public {
522         _rOwned[_msgSender()] = _rTotal;
523         emit Transfer(address(0), _msgSender(), _tTotal);
524     }
525 
526     function name() public view returns (string memory) {
527         return _name;
528     }
529 
530     function symbol() public view returns (string memory) {
531         return _symbol;
532     }
533 
534     function decimals() public view returns (uint8) {
535         return _decimals;
536     }
537 
538     function totalSupply() public view override returns (uint256) {
539         return _tTotal;
540     }
541 
542     function balanceOf(address account) public view override returns (uint256) {
543         if (_isExcluded[account]) return _tOwned[account];
544         return tokenFromReflection(_rOwned[account]);
545     }
546 
547     function transfer(address recipient, uint256 amount) public override returns (bool) {
548         _transfer(_msgSender(), recipient, amount);
549         return true;
550     }
551 
552     function allowance(address owner, address spender) public view override returns (uint256) {
553         return _allowances[owner][spender];
554     }
555 
556     function approve(address spender, uint256 amount) public override returns (bool) {
557         _approve(_msgSender(), spender, amount);
558         return true;
559     }
560 
561     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
562         _transfer(sender, recipient, amount);
563         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
564         return true;
565     }
566 
567     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
568         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
569         return true;
570     }
571 
572     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
573         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
574         return true;
575     }
576 
577     function isExcluded(address account) public view returns (bool) {
578         return _isExcluded[account];
579     }
580 
581     function totalFees() public view returns (uint256) {
582         return _tFeeTotal;
583     }
584 
585     function reflect(uint256 tAmount) public {
586         address sender = _msgSender();
587         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
588         (uint256 rAmount,,,,) = _getValues(tAmount);
589         _rOwned[sender] = _rOwned[sender].sub(rAmount);
590         _rTotal = _rTotal.sub(rAmount);
591         _tFeeTotal = _tFeeTotal.add(tAmount);
592     }
593 
594     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
595         require(tAmount <= _tTotal, "Amount must be less than supply");
596         if (!deductTransferFee) {
597             (uint256 rAmount,,,,) = _getValues(tAmount);
598             return rAmount;
599         } else {
600             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
601             return rTransferAmount;
602         }
603     }
604 
605     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
606         require(rAmount <= _rTotal, "Amount must be less than total reflections");
607         uint256 currentRate =  _getRate();
608         return rAmount.div(currentRate);
609     }
610 
611     function excludeAccount(address account) external onlyOwner() {
612         require(!_isExcluded[account], "Account is already excluded");
613         if(_rOwned[account] > 0) {
614             _tOwned[account] = tokenFromReflection(_rOwned[account]);
615         }
616         _isExcluded[account] = true;
617         _excluded.push(account);
618     }
619 
620     function includeAccount(address account) external onlyOwner() {
621         require(_isExcluded[account], "Account is already excluded");
622         for (uint256 i = 0; i < _excluded.length; i++) {
623             if (_excluded[i] == account) {
624                 _excluded[i] = _excluded[_excluded.length - 1];
625                 _tOwned[account] = 0;
626                 _isExcluded[account] = false;
627                 _excluded.pop();
628                 break;
629             }
630         }
631     }
632 
633     function _approve(address owner, address spender, uint256 amount) private {
634         require(owner != address(0), "ERC20: approve from the zero address");
635         require(spender != address(0), "ERC20: approve to the zero address");
636 
637         _allowances[owner][spender] = amount;
638         emit Approval(owner, spender, amount);
639     }
640 
641     function _transfer(address sender, address recipient, uint256 amount) private {
642         require(sender != address(0), "ERC20: transfer from the zero address");
643         require(recipient != address(0), "ERC20: transfer to the zero address");
644         require(amount > 0, "Transfer amount must be greater than zero");
645         if (_isExcluded[sender] && !_isExcluded[recipient]) {
646             _transferFromExcluded(sender, recipient, amount);
647         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
648             _transferToExcluded(sender, recipient, amount);
649         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
650             _transferStandard(sender, recipient, amount);
651         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
652             _transferBothExcluded(sender, recipient, amount);
653         } else {
654             _transferStandard(sender, recipient, amount);
655         }
656     }
657 
658     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
659         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
660         _rOwned[sender] = _rOwned[sender].sub(rAmount);
661         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
662         _reflectFee(rFee, tFee);
663         emit Transfer(sender, recipient, tTransferAmount);
664     }
665 
666     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
667         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
668         _rOwned[sender] = _rOwned[sender].sub(rAmount);
669         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
670         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
671         _reflectFee(rFee, tFee);
672         emit Transfer(sender, recipient, tTransferAmount);
673     }
674 
675     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
676         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
677         _tOwned[sender] = _tOwned[sender].sub(tAmount);
678         _rOwned[sender] = _rOwned[sender].sub(rAmount);
679         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
680         _reflectFee(rFee, tFee);
681         emit Transfer(sender, recipient, tTransferAmount);
682     }
683 
684     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
685         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
686         _tOwned[sender] = _tOwned[sender].sub(tAmount);
687         _rOwned[sender] = _rOwned[sender].sub(rAmount);
688         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
689         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
690         _reflectFee(rFee, tFee);
691         emit Transfer(sender, recipient, tTransferAmount);
692     }
693 
694     function _reflectFee(uint256 rFee, uint256 tFee) private {
695         _rTotal = _rTotal.sub(rFee);
696         _tFeeTotal = _tFeeTotal.add(tFee);
697     }
698 
699     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
700         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
701         uint256 currentRate =  _getRate();
702         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
703         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
704     }
705 
706     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
707         uint256 tFee = tAmount.div(100).mul(8);
708         uint256 tTransferAmount = tAmount.sub(tFee);
709         return (tTransferAmount, tFee);
710     }
711 
712     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
713         uint256 rAmount = tAmount.mul(currentRate);
714         uint256 rFee = tFee.mul(currentRate);
715         uint256 rTransferAmount = rAmount.sub(rFee);
716         return (rAmount, rTransferAmount, rFee);
717     }
718 
719     function _getRate() private view returns(uint256) {
720         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
721         return rSupply.div(tSupply);
722     }
723 
724     function _getCurrentSupply() private view returns(uint256, uint256) {
725         uint256 rSupply = _rTotal;
726         uint256 tSupply = _tTotal;      
727         for (uint256 i = 0; i < _excluded.length; i++) {
728             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
729             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
730             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
731         }
732         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
733         return (rSupply, tSupply);
734     }
735 }