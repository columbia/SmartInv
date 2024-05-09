1 pragma solidity ^0.6.0;
2 
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address payable) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes memory) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 // File: openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
16 
17 // SPDX-License-Identifier: MIT
18 
19 pragma solidity ^0.6.0;
20 
21 /**
22  * @dev Interface of the ERC20 standard as defined in the EIP.
23  */
24 interface IERC20 {
25     /**
26      * @dev Returns the amount of tokens in existence.
27      */
28     function totalSupply() external view returns (uint256);
29 
30     /**
31      * @dev Returns the amount of tokens owned by `account`.
32      */
33     function balanceOf(address account) external view returns (uint256);
34 
35     /**
36      * @dev Moves `amount` tokens from the caller's account to `recipient`.
37      *
38      * Returns a boolean value indicating whether the operation succeeded.
39      *
40      * Emits a {Transfer} event.
41      */
42     function transfer(address recipient, uint256 amount) external returns (bool);
43 
44     /**
45      * @dev Returns the remaining number of tokens that `spender` will be
46      * allowed to spend on behalf of `owner` through {transferFrom}. This is
47      * zero by default.
48      *
49      * This value changes when {approve} or {transferFrom} are called.
50      */
51     function allowance(address owner, address spender) external view returns (uint256);
52 
53     /**
54      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
55      *
56      * Returns a boolean value indicating whether the operation succeeded.
57      *
58      * IMPORTANT: Beware that changing an allowance with this method brings the risk
59      * that someone may use both the old and the new allowance by unfortunate
60      * transaction ordering. One possible solution to mitigate this race
61      * condition is to first reduce the spender's allowance to 0 and set the
62      * desired value afterwards:
63      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
64      *
65      * Emits an {Approval} event.
66      */
67     function approve(address spender, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Moves `amount` tokens from `sender` to `recipient` using the
71      * allowance mechanism. `amount` is then deducted from the caller's
72      * allowance.
73      *
74      * Returns a boolean value indicating whether the operation succeeded.
75      *
76      * Emits a {Transfer} event.
77      */
78     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Emitted when `value` tokens are moved from one account (`from`) to
82      * another (`to`).
83      *
84      * Note that `value` may be zero.
85      */
86     event Transfer(address indexed from, address indexed to, uint256 value);
87 
88     /**
89      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
90      * a call to {approve}. `value` is the new allowance.
91      */
92     event Approval(address indexed owner, address indexed spender, uint256 value);
93 }
94 
95 // File: openzeppelin-solidity\contracts\math\SafeMath.sol
96 
97 // SPDX-License-Identifier: MIT
98 
99 pragma solidity ^0.6.0;
100 
101 /**
102  * @dev Wrappers over Solidity's arithmetic operations with added overflow
103  * checks.
104  *
105  * Arithmetic operations in Solidity wrap on overflow. This can easily result
106  * in bugs, because programmers usually assume that an overflow raises an
107  * error, which is the standard behavior in high level programming languages.
108  * `SafeMath` restores this intuition by reverting the transaction when an
109  * operation overflows.
110  *
111  * Using this library instead of the unchecked operations eliminates an entire
112  * class of bugs, so it's recommended to use it always.
113  */
114 library SafeMath {
115     /**
116      * @dev Returns the addition of two unsigned integers, reverting on
117      * overflow.
118      *
119      * Counterpart to Solidity's `+` operator.
120      *
121      * Requirements:
122      *
123      * - Addition cannot overflow.
124      */
125     function add(uint256 a, uint256 b) internal pure returns (uint256) {
126         uint256 c = a + b;
127         require(c >= a, "SafeMath: addition overflow");
128 
129         return c;
130     }
131 
132     /**
133      * @dev Returns the subtraction of two unsigned integers, reverting on
134      * overflow (when the result is negative).
135      *
136      * Counterpart to Solidity's `-` operator.
137      *
138      * Requirements:
139      *
140      * - Subtraction cannot overflow.
141      */
142     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
143         return sub(a, b, "SafeMath: subtraction overflow");
144     }
145 
146     /**
147      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
148      * overflow (when the result is negative).
149      *
150      * Counterpart to Solidity's `-` operator.
151      *
152      * Requirements:
153      *
154      * - Subtraction cannot overflow.
155      */
156     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
157         require(b <= a, errorMessage);
158         uint256 c = a - b;
159 
160         return c;
161     }
162 
163     /**
164      * @dev Returns the multiplication of two unsigned integers, reverting on
165      * overflow.
166      *
167      * Counterpart to Solidity's `*` operator.
168      *
169      * Requirements:
170      *
171      * - Multiplication cannot overflow.
172      */
173     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
174         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
175         // benefit is lost if 'b' is also tested.
176         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
177         if (a == 0) {
178             return 0;
179         }
180 
181         uint256 c = a * b;
182         require(c / a == b, "SafeMath: multiplication overflow");
183 
184         return c;
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers. Reverts on
189      * division by zero. The result is rounded towards zero.
190      *
191      * Counterpart to Solidity's `/` operator. Note: this function uses a
192      * `revert` opcode (which leaves remaining gas untouched) while Solidity
193      * uses an invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      *
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b) internal pure returns (uint256) {
200         return div(a, b, "SafeMath: division by zero");
201     }
202 
203     /**
204      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
215     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
216         require(b > 0, errorMessage);
217         uint256 c = a / b;
218         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
219 
220         return c;
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * Reverts when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
236         return mod(a, b, "SafeMath: modulo by zero");
237     }
238 
239     /**
240      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
241      * Reverts with custom message when dividing by zero.
242      *
243      * Counterpart to Solidity's `%` operator. This function uses a `revert`
244      * opcode (which leaves remaining gas untouched) while Solidity uses an
245      * invalid opcode to revert (consuming all remaining gas).
246      *
247      * Requirements:
248      *
249      * - The divisor cannot be zero.
250      */
251     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
252         require(b != 0, errorMessage);
253         return a % b;
254     }
255 }
256 
257 // File: openzeppelin-solidity\contracts\utils\Address.sol
258 
259 // SPDX-License-Identifier: MIT
260 
261 pragma solidity ^0.6.2;
262 
263 /**
264  * @dev Collection of functions related to the address type
265  */
266 library Address {
267     /**
268      * @dev Returns true if `account` is a contract.
269      *
270      * [IMPORTANT]
271      * ====
272      * It is unsafe to assume that an address for which this function returns
273      * false is an externally-owned account (EOA) and not a contract.
274      *
275      * Among others, `isContract` will return false for the following
276      * types of addresses:
277      *
278      *  - an externally-owned account
279      *  - a contract in construction
280      *  - an address where a contract will be created
281      *  - an address where a contract lived, but was destroyed
282      * ====
283      */
284     function isContract(address account) internal view returns (bool) {
285         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
286         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
287         // for accounts without code, i.e. `keccak256('')`
288         bytes32 codehash;
289         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
290         // solhint-disable-next-line no-inline-assembly
291         assembly { codehash := extcodehash(account) }
292         return (codehash != accountHash && codehash != 0x0);
293     }
294 
295     /**
296      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
297      * `recipient`, forwarding all available gas and reverting on errors.
298      *
299      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
300      * of certain opcodes, possibly making contracts go over the 2300 gas limit
301      * imposed by `transfer`, making them unable to receive funds via
302      * `transfer`. {sendValue} removes this limitation.
303      *
304      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
305      *
306      * IMPORTANT: because control is transferred to `recipient`, care must be
307      * taken to not create reentrancy vulnerabilities. Consider using
308      * {ReentrancyGuard} or the
309      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
310      */
311     function sendValue(address payable recipient, uint256 amount) internal {
312         require(address(this).balance >= amount, "Address: insufficient balance");
313 
314         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
315         (bool success, ) = recipient.call{ value: amount }("");
316         require(success, "Address: unable to send value, recipient may have reverted");
317     }
318 
319     /**
320      * @dev Performs a Solidity function call using a low level `call`. A
321      * plain`call` is an unsafe replacement for a function call: use this
322      * function instead.
323      *
324      * If `target` reverts with a revert reason, it is bubbled up by this
325      * function (like regular Solidity function calls).
326      *
327      * Returns the raw returned data. To convert to the expected return value,
328      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
329      *
330      * Requirements:
331      *
332      * - `target` must be a contract.
333      * - calling `target` with `data` must not revert.
334      *
335      * _Available since v3.1._
336      */
337     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
338       return functionCall(target, data, "Address: low-level call failed");
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
343      * `errorMessage` as a fallback revert reason when `target` reverts.
344      *
345      * _Available since v3.1._
346      */
347     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
348         return _functionCallWithValue(target, data, 0, errorMessage);
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
353      * but also transferring `value` wei to `target`.
354      *
355      * Requirements:
356      *
357      * - the calling contract must have an ETH balance of at least `value`.
358      * - the called Solidity function must be `payable`.
359      *
360      * _Available since v3.1._
361      */
362     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
363         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
368      * with `errorMessage` as a fallback revert reason when `target` reverts.
369      *
370      * _Available since v3.1._
371      */
372     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
373         require(address(this).balance >= value, "Address: insufficient balance for call");
374         return _functionCallWithValue(target, data, value, errorMessage);
375     }
376 
377     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
378         require(isContract(target), "Address: call to non-contract");
379 
380         // solhint-disable-next-line avoid-low-level-calls
381         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
382         if (success) {
383             return returndata;
384         } else {
385             // Look for revert reason and bubble it up if present
386             if (returndata.length > 0) {
387                 // The easiest way to bubble the revert reason is using memory via assembly
388 
389                 // solhint-disable-next-line no-inline-assembly
390                 assembly {
391                     let returndata_size := mload(returndata)
392                     revert(add(32, returndata), returndata_size)
393                 }
394             } else {
395                 revert(errorMessage);
396             }
397         }
398     }
399 }
400 
401 // File: openzeppelin-solidity\contracts\access\Ownable.sol
402 
403 // SPDX-License-Identifier: MIT
404 
405 pragma solidity ^0.6.0;
406 
407 /**
408  * @dev Contract module which provides a basic access control mechanism, where
409  * there is an account (an owner) that can be granted exclusive access to
410  * specific functions.
411  *
412  * By default, the owner account will be the one that deploys the contract. This
413  * can later be changed with {transferOwnership}.
414  *
415  * This module is used through inheritance. It will make available the modifier
416  * `onlyOwner`, which can be applied to your functions to restrict their use to
417  * the owner.
418  */
419 contract Ownable is Context {
420     address private _owner;
421 
422     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
423 
424     /**
425      * @dev Initializes the contract setting the deployer as the initial owner.
426      */
427     constructor () internal {
428         address msgSender = _msgSender();
429         _owner = msgSender;
430         emit OwnershipTransferred(address(0), msgSender);
431     }
432 
433     /**
434      * @dev Returns the address of the current owner.
435      */
436     function owner() public view returns (address) {
437         return _owner;
438     }
439 
440     /**
441      * @dev Throws if called by any account other than the owner.
442      */
443     modifier onlyOwner() {
444         require(_owner == _msgSender(), "Ownable: caller is not the owner");
445         _;
446     }
447 
448     /**
449      * @dev Leaves the contract without owner. It will not be possible to call
450      * `onlyOwner` functions anymore. Can only be called by the current owner.
451      *
452      * NOTE: Renouncing ownership will leave the contract without an owner,
453      * thereby removing any functionality that is only available to the owner.
454      */
455     function renounceOwnership() public virtual onlyOwner {
456         emit OwnershipTransferred(_owner, address(0));
457         _owner = address(0);
458     }
459 
460     /**
461      * @dev Transfers ownership of the contract to a new account (`newOwner`).
462      * Can only be called by the current owner.
463      */
464     function transferOwnership(address newOwner) public virtual onlyOwner {
465         require(newOwner != address(0), "Ownable: new owner is the zero address");
466         emit OwnershipTransferred(_owner, newOwner);
467         _owner = newOwner;
468     }
469 }
470 
471 
472 pragma solidity ^0.6.2;
473 
474 contract METEOR is Context, IERC20, Ownable {
475     using SafeMath for uint256;
476     using Address for address;
477 
478     mapping (address => uint256) private _mOwned;
479     mapping (address => uint256) private _tOwned;
480     mapping (address => mapping (address => uint256)) private _allowances;
481 
482     mapping (address => bool) private _isExcluded;
483     address[] private _excluded;
484    
485     uint256 private constant MAX = ~uint256(0);
486     uint256 private constant _tTotal = 150 * 10**2 * 10**9;
487     uint256 private _mTotal = (MAX - (MAX % _tTotal));
488     uint256 private _tFeeTotal;
489 
490     string private _name = 'Meteorite.network';
491     string private _symbol = 'Meteor';
492     uint8 private _decimals = 9;
493 
494     constructor () public {
495         _mOwned[_msgSender()] = _mTotal;
496         emit Transfer(address(0), _msgSender(), _tTotal);
497     }
498 
499     function name() public view returns (string memory) {
500         return _name;
501     }
502 
503     function symbol() public view returns (string memory) {
504         return _symbol;
505     }
506 
507     function decimals() public view returns (uint8) {
508         return _decimals;
509     }
510 
511     function totalSupply() public view override returns (uint256) {
512         return _tTotal;
513     }
514 
515     function balanceOf(address account) public view override returns (uint256) {
516         if (_isExcluded[account]) return _tOwned[account];
517         return tokenFromMeteorite(_mOwned[account]);
518     }
519 
520     function transfer(address recipient, uint256 amount) public override returns (bool) {
521         _transfer(_msgSender(), recipient, amount);
522         return true;
523     }
524 
525     function allowance(address owner, address spender) public view override returns (uint256) {
526         return _allowances[owner][spender];
527     }
528 
529     function approve(address spender, uint256 amount) public override returns (bool) {
530         _approve(_msgSender(), spender, amount);
531         return true;
532     }
533 
534     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
535         _transfer(sender, recipient, amount);
536         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
537         return true;
538     }
539 
540     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
541         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
542         return true;
543     }
544 
545     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
546         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
547         return true;
548     }
549 
550     function isExcluded(address account) public view returns (bool) {
551         return _isExcluded[account];
552     }
553 
554     function totalFees() public view returns (uint256) {
555         return _tFeeTotal;
556     }
557 
558     function Meteor(uint256 tAmount) public {
559         address sender = _msgSender();
560         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
561         (uint256 mAmount,,,,) = _getValues(tAmount);
562         _mOwned[sender] = _mOwned[sender].sub(mAmount);
563         _mTotal = _mTotal.sub(mAmount);
564         _tFeeTotal = _tFeeTotal.add(tAmount);
565     }
566 
567     function meteorFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
568         require(tAmount <= _tTotal, "Amount must be less than supply");
569         if (!deductTransferFee) {
570             (uint256 mAmount,,,,) = _getValues(tAmount);
571             return mAmount;
572         } else {
573             (,uint256 mTransferAmount,,,) = _getValues(tAmount);
574             return mTransferAmount;
575         }
576     }
577 
578     function tokenFromMeteorite(uint256 mAmount) public view returns(uint256) {
579         require(mAmount <= _mTotal, "Amount must be less than total Meteorite");
580         uint256 currentRate =  _getRate();
581         return mAmount.div(currentRate);
582     }
583 
584     function excludeAccount(address account) external onlyOwner() {
585         require(!_isExcluded[account], "Account is already excluded");
586         if(_mOwned[account] > 0) {
587             _tOwned[account] = tokenFromMeteorite(_mOwned[account]);
588         }
589         _isExcluded[account] = true;
590         _excluded.push(account);
591     }
592 
593     function includeAccount(address account) external onlyOwner() {
594         require(_isExcluded[account], "Account is already excluded");
595         for (uint256 i = 0; i < _excluded.length; i++) {
596             if (_excluded[i] == account) {
597                 _excluded[i] = _excluded[_excluded.length - 1];
598                 _tOwned[account] = 0;
599                 _isExcluded[account] = false;
600                 _excluded.pop();
601                 break;
602             }
603         }
604     }
605 
606     function _approve(address owner, address spender, uint256 amount) private {
607         require(owner != address(0), "ERC20: approve from the zero address");
608         require(spender != address(0), "ERC20: approve to the zero address");
609 
610         _allowances[owner][spender] = amount;
611         emit Approval(owner, spender, amount);
612     }
613 
614     function _transfer(address sender, address recipient, uint256 amount) private {
615         require(sender != address(0), "ERC20: transfer from the zero address");
616         require(recipient != address(0), "ERC20: transfer to the zero address");
617         require(amount > 0, "Transfer amount must be greater than zero");
618         if (_isExcluded[sender] && !_isExcluded[recipient]) {
619             _transferFromExcluded(sender, recipient, amount);
620         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
621             _transferToExcluded(sender, recipient, amount);
622         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
623             _transferStandard(sender, recipient, amount);
624         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
625             _transferBothExcluded(sender, recipient, amount);
626         } else {
627             _transferStandard(sender, recipient, amount);
628         }
629     }
630 
631     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
632         (uint256 mAmount, uint256 mTransferAmount, uint256 mFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
633         _mOwned[sender] = _mOwned[sender].sub(mAmount);
634         _mOwned[recipient] = _mOwned[recipient].add(mTransferAmount);       
635         _meteorFee(mFee, tFee);
636         emit Transfer(sender, recipient, tTransferAmount);
637     }
638 
639     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
640         (uint256 mAmount, uint256 mTransferAmount, uint256 mFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
641         _mOwned[sender] = _mOwned[sender].sub(mAmount);
642         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
643         _mOwned[recipient] = _mOwned[recipient].add(mTransferAmount);           
644         _meteorFee(mFee, tFee);
645         emit Transfer(sender, recipient, tTransferAmount);
646     }
647 
648     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
649         (uint256 mAmount, uint256 mTransferAmount, uint256 mFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
650         _tOwned[sender] = _tOwned[sender].sub(tAmount);
651         _mOwned[sender] = _mOwned[sender].sub(mAmount);
652         _mOwned[recipient] = _mOwned[recipient].add(mTransferAmount);   
653         _meteorFee(mFee, tFee);
654         emit Transfer(sender, recipient, tTransferAmount);
655     }
656 
657     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
658         (uint256 mAmount, uint256 mTransferAmount, uint256 mFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
659         _tOwned[sender] = _tOwned[sender].sub(tAmount);
660         _mOwned[sender] = _mOwned[sender].sub(mAmount);
661         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
662         _mOwned[recipient] = _mOwned[recipient].add(mTransferAmount);        
663         _meteorFee(mFee, tFee);
664         emit Transfer(sender, recipient, tTransferAmount);
665     }
666 
667     function _meteorFee(uint256 mFee, uint256 tFee) private {
668         _mTotal = _mTotal.sub(mFee);
669         _tFeeTotal = _tFeeTotal.add(tFee);
670     }
671 
672     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
673         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
674         uint256 currentRate =  _getRate();
675         (uint256 mAmount, uint256 mTransferAmount, uint256 mFee) = _getMValues(tAmount, tFee, currentRate);
676         return (mAmount, mTransferAmount, mFee, tTransferAmount, tFee);
677     }
678 
679     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
680         uint256 tFee = tAmount.div(100);
681         uint256 tTransferAmount = tAmount.sub(tFee);
682         return (tTransferAmount, tFee);
683     }
684 
685     function _getMValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
686         uint256 mAmount = tAmount.mul(currentRate);
687         uint256 mFee = tFee.mul(currentRate);
688         uint256 mTransferAmount = mAmount.sub(mFee);
689         return (mAmount, mTransferAmount, mFee);
690     }
691 
692     function _getRate() private view returns(uint256) {
693         (uint256 mSupply, uint256 tSupply) = _getCurrentSupply();
694         return mSupply.div(tSupply);
695     }
696 
697     function _getCurrentSupply() private view returns(uint256, uint256) {
698         uint256 mSupply = _mTotal;
699         uint256 tSupply = _tTotal;      
700         for (uint256 i = 0; i < _excluded.length; i++) {
701             if (_mOwned[_excluded[i]] > mSupply || _tOwned[_excluded[i]] > tSupply) return (_mTotal, _tTotal);
702             mSupply = mSupply.sub(_mOwned[_excluded[i]]);
703             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
704         }
705         if (mSupply < _mTotal.div(_tTotal)) return (_mTotal, _tTotal);
706         return (mSupply, tSupply);
707     }
708 }