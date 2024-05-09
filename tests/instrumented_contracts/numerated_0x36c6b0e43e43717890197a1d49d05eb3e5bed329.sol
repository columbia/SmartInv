1 pragma solidity ^0.6.0;
2 
3 // SPDX-License-Identifier: MIT
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return msg.sender;
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 // SPDX-License-Identifier: MIT
17 
18 pragma solidity ^0.6.0;
19 
20 /**
21  * @dev Interface of the ERC20 standard as defined in the EIP.
22  */
23 interface IERC20 {
24     /**
25      * @dev Returns the amount of tokens in existence.
26      */
27     function totalSupply() external view returns (uint256);
28 
29     /**
30      * @dev Returns the amount of tokens owned by `account`.
31      */
32     function balanceOf(address account) external view returns (uint256);
33 
34     /**
35      * @dev Moves `amount` tokens from the caller's account to `recipient`.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * Emits a {Transfer} event.
40      */
41     function transfer(address recipient, uint256 amount) external returns (bool);
42 
43     /**
44      * @dev Returns the remaining number of tokens that `spender` will be
45      * allowed to spend on behalf of `owner` through {transferFrom}. This is
46      * zero by default.
47      *
48      * This value changes when {approve} or {transferFrom} are called.
49      */
50     function allowance(address owner, address spender) external view returns (uint256);
51 
52     /**
53      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * IMPORTANT: Beware that changing an allowance with this method brings the risk
58      * that someone may use both the old and the new allowance by unfortunate
59      * transaction ordering. One possible solution to mitigate this race
60      * condition is to first reduce the spender's allowance to 0 and set the
61      * desired value afterwards:
62      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63      *
64      * Emits an {Approval} event.
65      */
66     function approve(address spender, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Moves `amount` tokens from `sender` to `recipient` using the
70      * allowance mechanism. `amount` is then deducted from the caller's
71      * allowance.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * Emits a {Transfer} event.
76      */
77     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Emitted when `value` tokens are moved from one account (`from`) to
81      * another (`to`).
82      *
83      * Note that `value` may be zero.
84      */
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     /**
88      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
89      * a call to {approve}. `value` is the new allowance.
90      */
91     event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 // File: openzeppelin-solidity\contracts\math\SafeMath.sol
95 
96 // SPDX-License-Identifier: MIT
97 
98 pragma solidity ^0.6.0;
99 
100 /**
101  * @dev Wrappers over Solidity's arithmetic operations with added overflow
102  * checks.
103  *
104  * Arithmetic operations in Solidity wrap on overflow. This can easily result
105  * in bugs, because programmers usually assume that an overflow raises an
106  * error, which is the standard behavior in high level programming languages.
107  * `SafeMath` restores this intuition by reverting the transaction when an
108  * operation overflows.
109  *
110  * Using this library instead of the unchecked operations eliminates an entire
111  * class of bugs, so it's recommended to use it always.
112  */
113 library SafeMath {
114     /**
115      * @dev Returns the addition of two unsigned integers, reverting on
116      * overflow.
117      *
118      * Counterpart to Solidity's `+` operator.
119      *
120      * Requirements:
121      *
122      * - Addition cannot overflow.
123      */
124     function add(uint256 a, uint256 b) internal pure returns (uint256) {
125         uint256 c = a + b;
126         require(c >= a, "SafeMath: addition overflow");
127 
128         return c;
129     }
130 
131     /**
132      * @dev Returns the subtraction of two unsigned integers, reverting on
133      * overflow (when the result is negative).
134      *
135      * Counterpart to Solidity's `-` operator.
136      *
137      * Requirements:
138      *
139      * - Subtraction cannot overflow.
140      */
141     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
142         return sub(a, b, "SafeMath: subtraction overflow");
143     }
144 
145     /**
146      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
147      * overflow (when the result is negative).
148      *
149      * Counterpart to Solidity's `-` operator.
150      *
151      * Requirements:
152      *
153      * - Subtraction cannot overflow.
154      */
155     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
156         require(b <= a, errorMessage);
157         uint256 c = a - b;
158 
159         return c;
160     }
161 
162     /**
163      * @dev Returns the multiplication of two unsigned integers, reverting on
164      * overflow.
165      *
166      * Counterpart to Solidity's `*` operator.
167      *
168      * Requirements:
169      *
170      * - Multiplication cannot overflow.
171      */
172     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
173         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
174         // benefit is lost if 'b' is also tested.
175         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
176         if (a == 0) {
177             return 0;
178         }
179 
180         uint256 c = a * b;
181         require(c / a == b, "SafeMath: multiplication overflow");
182 
183         return c;
184     }
185 
186     /**
187      * @dev Returns the integer division of two unsigned integers. Reverts on
188      * division by zero. The result is rounded towards zero.
189      *
190      * Counterpart to Solidity's `/` operator. Note: this function uses a
191      * `revert` opcode (which leaves remaining gas untouched) while Solidity
192      * uses an invalid opcode to revert (consuming all remaining gas).
193      *
194      * Requirements:
195      *
196      * - The divisor cannot be zero.
197      */
198     function div(uint256 a, uint256 b) internal pure returns (uint256) {
199         return div(a, b, "SafeMath: division by zero");
200     }
201 
202     /**
203      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
204      * division by zero. The result is rounded towards zero.
205      *
206      * Counterpart to Solidity's `/` operator. Note: this function uses a
207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
208      * uses an invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
215         require(b > 0, errorMessage);
216         uint256 c = a / b;
217         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
218 
219         return c;
220     }
221 
222     /**
223      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
224      * Reverts when dividing by zero.
225      *
226      * Counterpart to Solidity's `%` operator. This function uses a `revert`
227      * opcode (which leaves remaining gas untouched) while Solidity uses an
228      * invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
235         return mod(a, b, "SafeMath: modulo by zero");
236     }
237 
238     /**
239      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
240      * Reverts with custom message when dividing by zero.
241      *
242      * Counterpart to Solidity's `%` operator. This function uses a `revert`
243      * opcode (which leaves remaining gas untouched) while Solidity uses an
244      * invalid opcode to revert (consuming all remaining gas).
245      *
246      * Requirements:
247      *
248      * - The divisor cannot be zero.
249      */
250     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
251         require(b != 0, errorMessage);
252         return a % b;
253     }
254 }
255 
256 // File: openzeppelin-solidity\contracts\utils\Address.sol
257 
258 // SPDX-License-Identifier: MIT
259 
260 pragma solidity ^0.6.2;
261 
262 /**
263  * @dev Collection of functions related to the address type
264  */
265 library Address {
266     /**
267      * @dev Returns true if `account` is a contract.
268      *
269      * [IMPORTANT]
270      * ====
271      * It is unsafe to assume that an address for which this function returns
272      * false is an externally-owned account (EOA) and not a contract.
273      *
274      * Among others, `isContract` will return false for the following
275      * types of addresses:
276      *
277      *  - an externally-owned account
278      *  - a contract in construction
279      *  - an address where a contract will be created
280      *  - an address where a contract lived, but was destroyed
281      * ====
282      */
283     function isContract(address account) internal view returns (bool) {
284         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
285         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
286         // for accounts without code, i.e. `keccak256('')`
287         bytes32 codehash;
288         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
289         // solhint-disable-next-line no-inline-assembly
290         assembly { codehash := extcodehash(account) }
291         return (codehash != accountHash && codehash != 0x0);
292     }
293 
294     /**
295      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
296      * `recipient`, forwarding all available gas and reverting on errors.
297      *
298      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
299      * of certain opcodes, possibly making contracts go over the 2300 gas limit
300      * imposed by `transfer`, making them unable to receive funds via
301      * `transfer`. {sendValue} removes this limitation.
302      *
303      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
304      *
305      * IMPORTANT: because control is transferred to `recipient`, care must be
306      * taken to not create reentrancy vulnerabilities. Consider using
307      * {ReentrancyGuard} or the
308      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
309      */
310     function sendValue(address payable recipient, uint256 amount) internal {
311         require(address(this).balance >= amount, "Address: insufficient balance");
312 
313         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
314         (bool success, ) = recipient.call{ value: amount }("");
315         require(success, "Address: unable to send value, recipient may have reverted");
316     }
317 
318     /**
319      * @dev Performs a Solidity function call using a low level `call`. A
320      * plain`call` is an unsafe replacement for a function call: use this
321      * function instead.
322      *
323      * If `target` reverts with a revert reason, it is bubbled up by this
324      * function (like regular Solidity function calls).
325      *
326      * Returns the raw returned data. To convert to the expected return value,
327      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
328      *
329      * Requirements:
330      *
331      * - `target` must be a contract.
332      * - calling `target` with `data` must not revert.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
337       return functionCall(target, data, "Address: low-level call failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
342      * `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
347         return _functionCallWithValue(target, data, 0, errorMessage);
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
352      * but also transferring `value` wei to `target`.
353      *
354      * Requirements:
355      *
356      * - the calling contract must have an ETH balance of at least `value`.
357      * - the called Solidity function must be `payable`.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
362         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
367      * with `errorMessage` as a fallback revert reason when `target` reverts.
368      *
369      * _Available since v3.1._
370      */
371     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
372         require(address(this).balance >= value, "Address: insufficient balance for call");
373         return _functionCallWithValue(target, data, value, errorMessage);
374     }
375 
376     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
377         require(isContract(target), "Address: call to non-contract");
378 
379         // solhint-disable-next-line avoid-low-level-calls
380         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
381         if (success) {
382             return returndata;
383         } else {
384             // Look for revert reason and bubble it up if present
385             if (returndata.length > 0) {
386                 // The easiest way to bubble the revert reason is using memory via assembly
387 
388                 // solhint-disable-next-line no-inline-assembly
389                 assembly {
390                     let returndata_size := mload(returndata)
391                     revert(add(32, returndata), returndata_size)
392                 }
393             } else {
394                 revert(errorMessage);
395             }
396         }
397     }
398 }
399 
400 // File: openzeppelin-solidity\contracts\access\Ownable.sol
401 
402 // SPDX-License-Identifier: MIT
403 
404 pragma solidity ^0.6.0;
405 
406 /**
407  * @dev Contract module which provides a basic access control mechanism, where
408  * there is an account (an owner) that can be granted exclusive access to
409  * specific functions.
410  *
411  * By default, the owner account will be the one that deploys the contract. This
412  * can later be changed with {transferOwnership}.
413  *
414  * This module is used through inheritance. It will make available the modifier
415  * `onlyOwner`, which can be applied to your functions to restrict their use to
416  * the owner.
417  */
418 contract Ownable is Context {
419     address private _owner;
420 
421     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
422 
423     /**
424      * @dev Initializes the contract setting the deployer as the initial owner.
425      */
426     constructor () internal {
427         address msgSender = _msgSender();
428         _owner = msgSender;
429         emit OwnershipTransferred(address(0), msgSender);
430     }
431 
432     /**
433      * @dev Returns the address of the current owner.
434      */
435     function owner() public view returns (address) {
436         return _owner;
437     }
438 
439     /**
440      * @dev Throws if called by any account other than the owner.
441      */
442     modifier onlyOwner() {
443         require(_owner == _msgSender(), "Ownable: caller is not the owner");
444         _;
445     }
446 
447     /**
448      * @dev Leaves the contract without owner. It will not be possible to call
449      * `onlyOwner` functions anymore. Can only be called by the current owner.
450      *
451      * NOTE: Renouncing ownership will leave the contract without an owner,
452      * thereby removing any functionality that is only available to the owner.
453      */
454     function renounceOwnership() public virtual onlyOwner {
455         emit OwnershipTransferred(_owner, address(0));
456         _owner = address(0);
457     }
458 
459     /**
460      * @dev Transfers ownership of the contract to a new account (`newOwner`).
461      * Can only be called by the current owner.
462      */
463     function transferOwnership(address newOwner) public virtual onlyOwner {
464         require(newOwner != address(0), "Ownable: new owner is the zero address");
465         emit OwnershipTransferred(_owner, newOwner);
466         _owner = newOwner;
467     }
468 }
469 
470 // File: contracts\REFLECT.sol
471 
472 pragma solidity ^0.6.2;
473 
474 contract ChanChain is Context, IERC20, Ownable {
475     using SafeMath for uint256;
476     using Address for address;
477 
478     mapping (address => uint256) private _rOwned;
479     mapping (address => uint256) private _tOwned;
480     mapping (address => mapping (address => uint256)) private _allowances;
481 
482     mapping (address => bool) private _isExcluded;
483     address[] private _excluded;
484    
485     uint256 private constant MAX = ~uint256(0);
486     uint256 private constant _tTotal = 5 * 10**6 * 10**9;  // 5 Millions
487     uint256 private _rTotal = (MAX - (MAX % _tTotal));
488     uint256 private _tFeeTotal;
489 
490     string private _name = '4Chan500';
491     string private _symbol = '4CH5';
492     uint8 private _decimals = 9;
493 
494     constructor () public {
495         _rOwned[_msgSender()] = _rTotal;
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
517         return tokenFromReflection(_rOwned[account]);
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
558     function reflect(uint256 tAmount) public {
559         address sender = _msgSender();
560         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
561         (uint256 rAmount,,,,) = _getValues(tAmount);
562         _rOwned[sender] = _rOwned[sender].sub(rAmount);
563         _rTotal = _rTotal.sub(rAmount);
564         _tFeeTotal = _tFeeTotal.add(tAmount);
565     }
566 
567     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
568         require(tAmount <= _tTotal, "Amount must be less than supply");
569         if (!deductTransferFee) {
570             (uint256 rAmount,,,,) = _getValues(tAmount);
571             return rAmount;
572         } else {
573             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
574             return rTransferAmount;
575         }
576     }
577 
578     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
579         require(rAmount <= _rTotal, "Amount must be less than total reflections");
580         uint256 currentRate =  _getRate();
581         return rAmount.div(currentRate);
582     }
583 
584     function excludeAccount(address account) external onlyOwner() {
585         require(!_isExcluded[account], "Account is already excluded");
586         if(_rOwned[account] > 0) {
587             _tOwned[account] = tokenFromReflection(_rOwned[account]);
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
632         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
633         _rOwned[sender] = _rOwned[sender].sub(rAmount);
634         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
635         _reflectFee(rFee, tFee);
636         emit Transfer(sender, recipient, tTransferAmount);
637     }
638 
639     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
640         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
641         _rOwned[sender] = _rOwned[sender].sub(rAmount);
642         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
643         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
644         _reflectFee(rFee, tFee);
645         emit Transfer(sender, recipient, tTransferAmount);
646     }
647 
648     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
649         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
650         _tOwned[sender] = _tOwned[sender].sub(tAmount);
651         _rOwned[sender] = _rOwned[sender].sub(rAmount);
652         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
653         _reflectFee(rFee, tFee);
654         emit Transfer(sender, recipient, tTransferAmount);
655     }
656 
657     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
658         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
659         _tOwned[sender] = _tOwned[sender].sub(tAmount);
660         _rOwned[sender] = _rOwned[sender].sub(rAmount);
661         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
662         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
663         _reflectFee(rFee, tFee);
664         emit Transfer(sender, recipient, tTransferAmount);
665     }
666 
667     function _reflectFee(uint256 rFee, uint256 tFee) private {
668         _rTotal = _rTotal.sub(rFee);
669         _tFeeTotal = _tFeeTotal.add(tFee);
670     }
671 
672     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
673         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
674         uint256 currentRate =  _getRate();
675         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
676         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
677     }
678 
679     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
680         uint256 tFee = tAmount.div(25);
681         uint256 tTransferAmount = tAmount.sub(tFee);
682         return (tTransferAmount, tFee);
683     }
684 
685     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
686         uint256 rAmount = tAmount.mul(currentRate);
687         uint256 rFee = tFee.mul(currentRate);
688         uint256 rTransferAmount = rAmount.sub(rFee);
689         return (rAmount, rTransferAmount, rFee);
690     }
691 
692     function _getRate() private view returns(uint256) {
693         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
694         return rSupply.div(tSupply);
695     }
696 
697     function _getCurrentSupply() private view returns(uint256, uint256) {
698         uint256 rSupply = _rTotal;
699         uint256 tSupply = _tTotal;      
700         for (uint256 i = 0; i < _excluded.length; i++) {
701             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
702             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
703             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
704         }
705         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
706         return (rSupply, tSupply);
707     }
708 }