1 // File: openzeppelin-solidity\contracts\GSN\Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.6.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
29 
30 // SPDX-License-Identifier: MIT
31 
32 pragma solidity ^0.6.0;
33 
34 /**
35  * @dev Interface of the ERC20 standard as defined in the EIP.
36  */
37 interface IERC20 {
38     /**
39      * @dev Returns the amount of tokens in existence.
40      */
41     function totalSupply() external view returns (uint256);
42 
43     /**
44      * @dev Returns the amount of tokens owned by `account`.
45      */
46     function balanceOf(address account) external view returns (uint256);
47 
48     /**
49      * @dev Moves `amount` tokens from the caller's account to `recipient`.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * Emits a {Transfer} event.
54      */
55     function transfer(address recipient, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Returns the remaining number of tokens that `spender` will be
59      * allowed to spend on behalf of `owner` through {transferFrom}. This is
60      * zero by default.
61      *
62      * This value changes when {approve} or {transferFrom} are called.
63      */
64     function allowance(address owner, address spender) external view returns (uint256);
65 
66     /**
67      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * IMPORTANT: Beware that changing an allowance with this method brings the risk
72      * that someone may use both the old and the new allowance by unfortunate
73      * transaction ordering. One possible solution to mitigate this race
74      * condition is to first reduce the spender's allowance to 0 and set the
75      * desired value afterwards:
76      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
77      *
78      * Emits an {Approval} event.
79      */
80     function approve(address spender, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Moves `amount` tokens from `sender` to `recipient` using the
84      * allowance mechanism. `amount` is then deducted from the caller's
85      * allowance.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * Emits a {Transfer} event.
90      */
91     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
92 
93     /**
94      * @dev Emitted when `value` tokens are moved from one account (`from`) to
95      * another (`to`).
96      *
97      * Note that `value` may be zero.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 value);
100 
101     /**
102      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
103      * a call to {approve}. `value` is the new allowance.
104      */
105     event Approval(address indexed owner, address indexed spender, uint256 value);
106 }
107 
108 // File: openzeppelin-solidity\contracts\math\SafeMath.sol
109 
110 // SPDX-License-Identifier: MIT
111 
112 pragma solidity ^0.6.0;
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      *
136      * - Addition cannot overflow.
137      */
138     function add(uint256 a, uint256 b) internal pure returns (uint256) {
139         uint256 c = a + b;
140         require(c >= a, "SafeMath: addition overflow");
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting on
147      * overflow (when the result is negative).
148      *
149      * Counterpart to Solidity's `-` operator.
150      *
151      * Requirements:
152      *
153      * - Subtraction cannot overflow.
154      */
155     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
156         return sub(a, b, "SafeMath: subtraction overflow");
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
161      * overflow (when the result is negative).
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
170         require(b <= a, errorMessage);
171         uint256 c = a - b;
172 
173         return c;
174     }
175 
176     /**
177      * @dev Returns the multiplication of two unsigned integers, reverting on
178      * overflow.
179      *
180      * Counterpart to Solidity's `*` operator.
181      *
182      * Requirements:
183      *
184      * - Multiplication cannot overflow.
185      */
186     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
187         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
188         // benefit is lost if 'b' is also tested.
189         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
190         if (a == 0) {
191             return 0;
192         }
193 
194         uint256 c = a * b;
195         require(c / a == b, "SafeMath: multiplication overflow");
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the integer division of two unsigned integers. Reverts on
202      * division by zero. The result is rounded towards zero.
203      *
204      * Counterpart to Solidity's `/` operator. Note: this function uses a
205      * `revert` opcode (which leaves remaining gas untouched) while Solidity
206      * uses an invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function div(uint256 a, uint256 b) internal pure returns (uint256) {
213         return div(a, b, "SafeMath: division by zero");
214     }
215 
216     /**
217      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
218      * division by zero. The result is rounded towards zero.
219      *
220      * Counterpart to Solidity's `/` operator. Note: this function uses a
221      * `revert` opcode (which leaves remaining gas untouched) while Solidity
222      * uses an invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b > 0, errorMessage);
230         uint256 c = a / b;
231         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
232 
233         return c;
234     }
235 
236     /**
237      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
238      * Reverts when dividing by zero.
239      *
240      * Counterpart to Solidity's `%` operator. This function uses a `revert`
241      * opcode (which leaves remaining gas untouched) while Solidity uses an
242      * invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
249         return mod(a, b, "SafeMath: modulo by zero");
250     }
251 
252     /**
253      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
254      * Reverts with custom message when dividing by zero.
255      *
256      * Counterpart to Solidity's `%` operator. This function uses a `revert`
257      * opcode (which leaves remaining gas untouched) while Solidity uses an
258      * invalid opcode to revert (consuming all remaining gas).
259      *
260      * Requirements:
261      *
262      * - The divisor cannot be zero.
263      */
264     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
265         require(b != 0, errorMessage);
266         return a % b;
267     }
268 }
269 
270 // File: openzeppelin-solidity\contracts\utils\Address.sol
271 
272 // SPDX-License-Identifier: MIT
273 
274 pragma solidity ^0.6.2;
275 
276 /**
277  * @dev Collection of functions related to the address type
278  */
279 library Address {
280     /**
281      * @dev Returns true if `account` is a contract.
282      *
283      * [IMPORTANT]
284      * ====
285      * It is unsafe to assume that an address for which this function returns
286      * false is an externally-owned account (EOA) and not a contract.
287      *
288      * Among others, `isContract` will return false for the following
289      * types of addresses:
290      *
291      *  - an externally-owned account
292      *  - a contract in construction
293      *  - an address where a contract will be created
294      *  - an address where a contract lived, but was destroyed
295      * ====
296      */
297     function isContract(address account) internal view returns (bool) {
298         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
299         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
300         // for accounts without code, i.e. `keccak256('')`
301         bytes32 codehash;
302         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
303         // solhint-disable-next-line no-inline-assembly
304         assembly { codehash := extcodehash(account) }
305         return (codehash != accountHash && codehash != 0x0);
306     }
307 
308     /**
309      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
310      * `recipient`, forwarding all available gas and reverting on errors.
311      *
312      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
313      * of certain opcodes, possibly making contracts go over the 2300 gas limit
314      * imposed by `transfer`, making them unable to receive funds via
315      * `transfer`. {sendValue} removes this limitation.
316      *
317      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
318      *
319      * IMPORTANT: because control is transferred to `recipient`, care must be
320      * taken to not create reentrancy vulnerabilities. Consider using
321      * {ReentrancyGuard} or the
322      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
323      */
324     function sendValue(address payable recipient, uint256 amount) internal {
325         require(address(this).balance >= amount, "Address: insufficient balance");
326 
327         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
328         (bool success, ) = recipient.call{ value: amount }("");
329         require(success, "Address: unable to send value, recipient may have reverted");
330     }
331 
332     /**
333      * @dev Performs a Solidity function call using a low level `call`. A
334      * plain`call` is an unsafe replacement for a function call: use this
335      * function instead.
336      *
337      * If `target` reverts with a revert reason, it is bubbled up by this
338      * function (like regular Solidity function calls).
339      *
340      * Returns the raw returned data. To convert to the expected return value,
341      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
342      *
343      * Requirements:
344      *
345      * - `target` must be a contract.
346      * - calling `target` with `data` must not revert.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
351       return functionCall(target, data, "Address: low-level call failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
356      * `errorMessage` as a fallback revert reason when `target` reverts.
357      *
358      * _Available since v3.1._
359      */
360     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
361         return _functionCallWithValue(target, data, 0, errorMessage);
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
366      * but also transferring `value` wei to `target`.
367      *
368      * Requirements:
369      *
370      * - the calling contract must have an ETH balance of at least `value`.
371      * - the called Solidity function must be `payable`.
372      *
373      * _Available since v3.1._
374      */
375     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
376         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
377     }
378 
379     /**
380      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
381      * with `errorMessage` as a fallback revert reason when `target` reverts.
382      *
383      * _Available since v3.1._
384      */
385     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
386         require(address(this).balance >= value, "Address: insufficient balance for call");
387         return _functionCallWithValue(target, data, value, errorMessage);
388     }
389 
390     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
391         require(isContract(target), "Address: call to non-contract");
392 
393         // solhint-disable-next-line avoid-low-level-calls
394         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
395         if (success) {
396             return returndata;
397         } else {
398             // Look for revert reason and bubble it up if present
399             if (returndata.length > 0) {
400                 // The easiest way to bubble the revert reason is using memory via assembly
401 
402                 // solhint-disable-next-line no-inline-assembly
403                 assembly {
404                     let returndata_size := mload(returndata)
405                     revert(add(32, returndata), returndata_size)
406                 }
407             } else {
408                 revert(errorMessage);
409             }
410         }
411     }
412 }
413 
414 // File: openzeppelin-solidity\contracts\access\Ownable.sol
415 
416 // SPDX-License-Identifier: MIT
417 
418 pragma solidity ^0.6.0;
419 
420 /**
421  * @dev Contract module which provides a basic access control mechanism, where
422  * there is an account (an owner) that can be granted exclusive access to
423  * specific functions.
424  *
425  * By default, the owner account will be the one that deploys the contract. This
426  * can later be changed with {transferOwnership}.
427  *
428  * This module is used through inheritance. It will make available the modifier
429  * `onlyOwner`, which can be applied to your functions to restrict their use to
430  * the owner.
431  */
432 contract Ownable is Context {
433     address private _owner;
434 
435     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
436 
437     /**
438      * @dev Initializes the contract setting the deployer as the initial owner.
439      */
440     constructor () internal {
441         address msgSender = _msgSender();
442         _owner = msgSender;
443         emit OwnershipTransferred(address(0), msgSender);
444     }
445 
446     /**
447      * @dev Returns the address of the current owner.
448      */
449     function owner() public view returns (address) {
450         return _owner;
451     }
452 
453     /**
454      * @dev Throws if called by any account other than the owner.
455      */
456     modifier onlyOwner() {
457         require(_owner == _msgSender(), "Ownable: caller is not the owner");
458         _;
459     }
460 
461     /**
462      * @dev Leaves the contract without owner. It will not be possible to call
463      * `onlyOwner` functions anymore. Can only be called by the current owner.
464      *
465      * NOTE: Renouncing ownership will leave the contract without an owner,
466      * thereby removing any functionality that is only available to the owner.
467      */
468     function renounceOwnership() public virtual onlyOwner {
469         emit OwnershipTransferred(_owner, address(0));
470         _owner = address(0);
471     }
472 
473     /**
474      * @dev Transfers ownership of the contract to a new account (`newOwner`).
475      * Can only be called by the current owner.
476      */
477     function transferOwnership(address newOwner) public virtual onlyOwner {
478         require(newOwner != address(0), "Ownable: new owner is the zero address");
479         emit OwnershipTransferred(_owner, newOwner);
480         _owner = newOwner;
481     }
482 }
483 
484 // File: contracts\REFLECT.sol
485 
486 /*
487  * Copyright 2020 reflect.finance. ALL RIGHTS RESERVED.
488  */
489 
490 pragma solidity ^0.6.2;
491 
492 
493 
494 
495 
496 
497 contract REFLECT is Context, IERC20, Ownable {
498     using SafeMath for uint256;
499     using Address for address;
500 
501     mapping (address => uint256) private _rOwned;
502     mapping (address => uint256) private _tOwned;
503     mapping (address => mapping (address => uint256)) private _allowances;
504 
505     mapping (address => bool) private _isExcluded;
506     address[] private _excluded;
507    
508     uint256 private constant MAX = ~uint256(0);
509     uint256 private constant _tTotal = 10 * 10**6 * 10**9;
510     uint256 private _rTotal = (MAX - (MAX % _tTotal));
511     uint256 private _tFeeTotal;
512 
513     string private _name = 'reflect.finance';
514     string private _symbol = 'RFI';
515     uint8 private _decimals = 9;
516 
517     constructor () public {
518         _rOwned[_msgSender()] = _rTotal;
519         emit Transfer(address(0), _msgSender(), _tTotal);
520     }
521 
522     function name() public view returns (string memory) {
523         return _name;
524     }
525 
526     function symbol() public view returns (string memory) {
527         return _symbol;
528     }
529 
530     function decimals() public view returns (uint8) {
531         return _decimals;
532     }
533 
534     function totalSupply() public view override returns (uint256) {
535         return _tTotal;
536     }
537 
538     function balanceOf(address account) public view override returns (uint256) {
539         if (_isExcluded[account]) return _tOwned[account];
540         return tokenFromReflection(_rOwned[account]);
541     }
542 
543     function transfer(address recipient, uint256 amount) public override returns (bool) {
544         _transfer(_msgSender(), recipient, amount);
545         return true;
546     }
547 
548     function allowance(address owner, address spender) public view override returns (uint256) {
549         return _allowances[owner][spender];
550     }
551 
552     function approve(address spender, uint256 amount) public override returns (bool) {
553         _approve(_msgSender(), spender, amount);
554         return true;
555     }
556 
557     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
558         _transfer(sender, recipient, amount);
559         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
560         return true;
561     }
562 
563     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
564         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
565         return true;
566     }
567 
568     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
569         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
570         return true;
571     }
572 
573     function isExcluded(address account) public view returns (bool) {
574         return _isExcluded[account];
575     }
576 
577     function totalFees() public view returns (uint256) {
578         return _tFeeTotal;
579     }
580 
581     function reflect(uint256 tAmount) public {
582         address sender = _msgSender();
583         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
584         (uint256 rAmount,,,,) = _getValues(tAmount);
585         _rOwned[sender] = _rOwned[sender].sub(rAmount);
586         _rTotal = _rTotal.sub(rAmount);
587         _tFeeTotal = _tFeeTotal.add(tAmount);
588     }
589 
590     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
591         require(tAmount <= _tTotal, "Amount must be less than supply");
592         if (!deductTransferFee) {
593             (uint256 rAmount,,,,) = _getValues(tAmount);
594             return rAmount;
595         } else {
596             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
597             return rTransferAmount;
598         }
599     }
600 
601     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
602         require(rAmount <= _rTotal, "Amount must be less than total reflections");
603         uint256 currentRate =  _getRate();
604         return rAmount.div(currentRate);
605     }
606 
607     function excludeAccount(address account) external onlyOwner() {
608         require(!_isExcluded[account], "Account is already excluded");
609         if(_rOwned[account] > 0) {
610             _tOwned[account] = tokenFromReflection(_rOwned[account]);
611         }
612         _isExcluded[account] = true;
613         _excluded.push(account);
614     }
615 
616     function includeAccount(address account) external onlyOwner() {
617         require(_isExcluded[account], "Account is already excluded");
618         for (uint256 i = 0; i < _excluded.length; i++) {
619             if (_excluded[i] == account) {
620                 _excluded[i] = _excluded[_excluded.length - 1];
621                 _tOwned[account] = 0;
622                 _isExcluded[account] = false;
623                 _excluded.pop();
624                 break;
625             }
626         }
627     }
628 
629     function _approve(address owner, address spender, uint256 amount) private {
630         require(owner != address(0), "ERC20: approve from the zero address");
631         require(spender != address(0), "ERC20: approve to the zero address");
632 
633         _allowances[owner][spender] = amount;
634         emit Approval(owner, spender, amount);
635     }
636 
637     function _transfer(address sender, address recipient, uint256 amount) private {
638         require(sender != address(0), "ERC20: transfer from the zero address");
639         require(recipient != address(0), "ERC20: transfer to the zero address");
640         require(amount > 0, "Transfer amount must be greater than zero");
641         if (_isExcluded[sender] && !_isExcluded[recipient]) {
642             _transferFromExcluded(sender, recipient, amount);
643         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
644             _transferToExcluded(sender, recipient, amount);
645         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
646             _transferStandard(sender, recipient, amount);
647         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
648             _transferBothExcluded(sender, recipient, amount);
649         } else {
650             _transferStandard(sender, recipient, amount);
651         }
652     }
653 
654     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
655         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
656         _rOwned[sender] = _rOwned[sender].sub(rAmount);
657         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
658         _reflectFee(rFee, tFee);
659         emit Transfer(sender, recipient, tTransferAmount);
660     }
661 
662     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
663         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
664         _rOwned[sender] = _rOwned[sender].sub(rAmount);
665         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
666         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
667         _reflectFee(rFee, tFee);
668         emit Transfer(sender, recipient, tTransferAmount);
669     }
670 
671     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
672         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
673         _tOwned[sender] = _tOwned[sender].sub(tAmount);
674         _rOwned[sender] = _rOwned[sender].sub(rAmount);
675         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
676         _reflectFee(rFee, tFee);
677         emit Transfer(sender, recipient, tTransferAmount);
678     }
679 
680     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
681         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
682         _tOwned[sender] = _tOwned[sender].sub(tAmount);
683         _rOwned[sender] = _rOwned[sender].sub(rAmount);
684         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
685         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
686         _reflectFee(rFee, tFee);
687         emit Transfer(sender, recipient, tTransferAmount);
688     }
689 
690     function _reflectFee(uint256 rFee, uint256 tFee) private {
691         _rTotal = _rTotal.sub(rFee);
692         _tFeeTotal = _tFeeTotal.add(tFee);
693     }
694 
695     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
696         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
697         uint256 currentRate =  _getRate();
698         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
699         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
700     }
701 
702     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
703         uint256 tFee = tAmount.div(100);
704         uint256 tTransferAmount = tAmount.sub(tFee);
705         return (tTransferAmount, tFee);
706     }
707 
708     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
709         uint256 rAmount = tAmount.mul(currentRate);
710         uint256 rFee = tFee.mul(currentRate);
711         uint256 rTransferAmount = rAmount.sub(rFee);
712         return (rAmount, rTransferAmount, rFee);
713     }
714 
715     function _getRate() private view returns(uint256) {
716         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
717         return rSupply.div(tSupply);
718     }
719 
720     function _getCurrentSupply() private view returns(uint256, uint256) {
721         uint256 rSupply = _rTotal;
722         uint256 tSupply = _tTotal;      
723         for (uint256 i = 0; i < _excluded.length; i++) {
724             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
725             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
726             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
727         }
728         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
729         return (rSupply, tSupply);
730     }
731 }