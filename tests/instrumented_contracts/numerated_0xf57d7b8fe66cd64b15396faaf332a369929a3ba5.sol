1 //
2 // R2F.Finance: Next Evolution of the RFI experiment
3 //
4 // ██████╗ ██████╗ ███████╗
5 // ██╔══██╗╚════██╗██╔════╝
6 // ██████╔╝ █████╔╝█████╗  
7 // ██╔══██╗██╔═══╝ ██╔══╝  
8 // ██║  ██║███████╗██║     
9 // ╚═╝  ╚═╝╚══════╝╚═╝     
10 //      
11 // https://t.me/r2finance
12 // SPDX-License-Identifier: MIT
13 
14 pragma solidity ^0.6.0;
15 
16 /*
17  * @dev Provides information about the current execution context, including the
18  * sender of the transaction and its data. While these are generally available
19  * via msg.sender and msg.data, they should not be accessed in such a direct
20  * manner, since when dealing with GSN meta-transactions the account sending and
21  * paying for execution may not be the actual sender (as far as an application
22  * is concerned).
23  *
24  * This contract is only required for intermediate, library-like contracts.
25  */
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address payable) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view virtual returns (bytes memory) {
32         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
33         return msg.data;
34     }
35 }
36 
37 // File: openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
38 
39 // SPDX-License-Identifier: MIT
40 
41 pragma solidity ^0.6.0;
42 
43 /**
44  * @dev Interface of the ERC20 standard as defined in the EIP.
45  */
46 interface IERC20 {
47     /**
48      * @dev Returns the amount of tokens in existence.
49      */
50     function totalSupply() external view returns (uint256);
51 
52     /**
53      * @dev Returns the amount of tokens owned by `account`.
54      */
55     function balanceOf(address account) external view returns (uint256);
56 
57     /**
58      * @dev Moves `amount` tokens from the caller's account to `recipient`.
59      *
60      * Returns a boolean value indicating whether the operation succeeded.
61      *
62      * Emits a {Transfer} event.
63      */
64     function transfer(address recipient, uint256 amount) external returns (bool);
65 
66     /**
67      * @dev Returns the remaining number of tokens that `spender` will be
68      * allowed to spend on behalf of `owner` through {transferFrom}. This is
69      * zero by default.
70      *
71      * This value changes when {approve} or {transferFrom} are called.
72      */
73     function allowance(address owner, address spender) external view returns (uint256);
74 
75     /**
76      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
77      *
78      * Returns a boolean value indicating whether the operation succeeded.
79      *
80      * IMPORTANT: Beware that changing an allowance with this method brings the risk
81      * that someone may use both the old and the new allowance by unfortunate
82      * transaction ordering. One possible solution to mitigate this race
83      * condition is to first reduce the spender's allowance to 0 and set the
84      * desired value afterwards:
85      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
86      *
87      * Emits an {Approval} event.
88      */
89     function approve(address spender, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Moves `amount` tokens from `sender` to `recipient` using the
93      * allowance mechanism. `amount` is then deducted from the caller's
94      * allowance.
95      *
96      * Returns a boolean value indicating whether the operation succeeded.
97      *
98      * Emits a {Transfer} event.
99      */
100     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
101 
102     /**
103      * @dev Emitted when `value` tokens are moved from one account (`from`) to
104      * another (`to`).
105      *
106      * Note that `value` may be zero.
107      */
108     event Transfer(address indexed from, address indexed to, uint256 value);
109 
110     /**
111      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
112      * a call to {approve}. `value` is the new allowance.
113      */
114     event Approval(address indexed owner, address indexed spender, uint256 value);
115 }
116 
117 // File: openzeppelin-solidity\contracts\math\SafeMath.sol
118 
119 // SPDX-License-Identifier: MIT
120 
121 pragma solidity ^0.6.0;
122 
123 /**
124  * @dev Wrappers over Solidity's arithmetic operations with added overflow
125  * checks.
126  *
127  * Arithmetic operations in Solidity wrap on overflow. This can easily result
128  * in bugs, because programmers usually assume that an overflow raises an
129  * error, which is the standard behavior in high level programming languages.
130  * `SafeMath` restores this intuition by reverting the transaction when an
131  * operation overflows.
132  *
133  * Using this library instead of the unchecked operations eliminates an entire
134  * class of bugs, so it's recommended to use it always.
135  */
136 library SafeMath {
137     /**
138      * @dev Returns the addition of two unsigned integers, reverting on
139      * overflow.
140      *
141      * Counterpart to Solidity's `+` operator.
142      *
143      * Requirements:
144      *
145      * - Addition cannot overflow.
146      */
147     function add(uint256 a, uint256 b) internal pure returns (uint256) {
148         uint256 c = a + b;
149         require(c >= a, "SafeMath: addition overflow");
150 
151         return c;
152     }
153 
154     /**
155      * @dev Returns the subtraction of two unsigned integers, reverting on
156      * overflow (when the result is negative).
157      *
158      * Counterpart to Solidity's `-` operator.
159      *
160      * Requirements:
161      *
162      * - Subtraction cannot overflow.
163      */
164     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
165         return sub(a, b, "SafeMath: subtraction overflow");
166     }
167 
168     /**
169      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
170      * overflow (when the result is negative).
171      *
172      * Counterpart to Solidity's `-` operator.
173      *
174      * Requirements:
175      *
176      * - Subtraction cannot overflow.
177      */
178     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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
237     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
238         require(b > 0, errorMessage);
239         uint256 c = a / b;
240         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
241 
242         return c;
243     }
244 
245     /**
246      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
247      * Reverts when dividing by zero.
248      *
249      * Counterpart to Solidity's `%` operator. This function uses a `revert`
250      * opcode (which leaves remaining gas untouched) while Solidity uses an
251      * invalid opcode to revert (consuming all remaining gas).
252      *
253      * Requirements:
254      *
255      * - The divisor cannot be zero.
256      */
257     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
258         return mod(a, b, "SafeMath: modulo by zero");
259     }
260 
261     /**
262      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
263      * Reverts with custom message when dividing by zero.
264      *
265      * Counterpart to Solidity's `%` operator. This function uses a `revert`
266      * opcode (which leaves remaining gas untouched) while Solidity uses an
267      * invalid opcode to revert (consuming all remaining gas).
268      *
269      * Requirements:
270      *
271      * - The divisor cannot be zero.
272      */
273     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
274         require(b != 0, errorMessage);
275         return a % b;
276     }
277 }
278 
279 // File: openzeppelin-solidity\contracts\utils\Address.sol
280 
281 // SPDX-License-Identifier: MIT
282 
283 pragma solidity ^0.6.2;
284 
285 /**
286  * @dev Collection of functions related to the address type
287  */
288 library Address {
289     /**
290      * @dev Returns true if `account` is a contract.
291      *
292      * [IMPORTANT]
293      * ====
294      * It is unsafe to assume that an address for which this function returns
295      * false is an externally-owned account (EOA) and not a contract.
296      *
297      * Among others, `isContract` will return false for the following
298      * types of addresses:
299      *
300      *  - an externally-owned account
301      *  - a contract in construction
302      *  - an address where a contract will be created
303      *  - an address where a contract lived, but was destroyed
304      * ====
305      */
306     function isContract(address account) internal view returns (bool) {
307         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
308         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
309         // for accounts without code, i.e. `keccak256('')`
310         bytes32 codehash;
311         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
312         // solhint-disable-next-line no-inline-assembly
313         assembly { codehash := extcodehash(account) }
314         return (codehash != accountHash && codehash != 0x0);
315     }
316 
317     /**
318      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
319      * `recipient`, forwarding all available gas and reverting on errors.
320      *
321      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
322      * of certain opcodes, possibly making contracts go over the 2300 gas limit
323      * imposed by `transfer`, making them unable to receive funds via
324      * `transfer`. {sendValue} removes this limitation.
325      *
326      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
327      *
328      * IMPORTANT: because control is transferred to `recipient`, care must be
329      * taken to not create reentrancy vulnerabilities. Consider using
330      * {ReentrancyGuard} or the
331      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
332      */
333     function sendValue(address payable recipient, uint256 amount) internal {
334         require(address(this).balance >= amount, "Address: insufficient balance");
335 
336         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
337         (bool success, ) = recipient.call{ value: amount }("");
338         require(success, "Address: unable to send value, recipient may have reverted");
339     }
340 
341     /**
342      * @dev Performs a Solidity function call using a low level `call`. A
343      * plain`call` is an unsafe replacement for a function call: use this
344      * function instead.
345      *
346      * If `target` reverts with a revert reason, it is bubbled up by this
347      * function (like regular Solidity function calls).
348      *
349      * Returns the raw returned data. To convert to the expected return value,
350      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
351      *
352      * Requirements:
353      *
354      * - `target` must be a contract.
355      * - calling `target` with `data` must not revert.
356      *
357      * _Available since v3.1._
358      */
359     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
360         return functionCall(target, data, "Address: low-level call failed");
361     }
362 
363     /**
364      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
365      * `errorMessage` as a fallback revert reason when `target` reverts.
366      *
367      * _Available since v3.1._
368      */
369     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
370         return _functionCallWithValue(target, data, 0, errorMessage);
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
375      * but also transferring `value` wei to `target`.
376      *
377      * Requirements:
378      *
379      * - the calling contract must have an ETH balance of at least `value`.
380      * - the called Solidity function must be `payable`.
381      *
382      * _Available since v3.1._
383      */
384     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
385         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
386     }
387 
388     /**
389      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
390      * with `errorMessage` as a fallback revert reason when `target` reverts.
391      *
392      * _Available since v3.1._
393      */
394     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
395         require(address(this).balance >= value, "Address: insufficient balance for call");
396         return _functionCallWithValue(target, data, value, errorMessage);
397     }
398 
399     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
400         require(isContract(target), "Address: call to non-contract");
401 
402         // solhint-disable-next-line avoid-low-level-calls
403         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
404         if (success) {
405             return returndata;
406         } else {
407             // Look for revert reason and bubble it up if present
408             if (returndata.length > 0) {
409                 // The easiest way to bubble the revert reason is using memory via assembly
410 
411                 // solhint-disable-next-line no-inline-assembly
412                 assembly {
413                     let returndata_size := mload(returndata)
414                     revert(add(32, returndata), returndata_size)
415                 }
416             } else {
417                 revert(errorMessage);
418             }
419         }
420     }
421 }
422 
423 // File: openzeppelin-solidity\contracts\access\Ownable.sol
424 
425 // SPDX-License-Identifier: MIT
426 
427 pragma solidity ^0.6.0;
428 
429 /**
430  * @dev Contract module which provides a basic access control mechanism, where
431  * there is an account (an owner) that can be granted exclusive access to
432  * specific functions.
433  *
434  * By default, the owner account will be the one that deploys the contract. This
435  * can later be changed with {transferOwnership}.
436  *
437  * This module is used through inheritance. It will make available the modifier
438  * `onlyOwner`, which can be applied to your functions to restrict their use to
439  * the owner.
440  */
441 contract Ownable is Context {
442     address private _owner;
443 
444     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
445 
446     /**
447      * @dev Initializes the contract setting the deployer as the initial owner.
448      */
449     constructor () internal {
450         address msgSender = _msgSender();
451         _owner = msgSender;
452         emit OwnershipTransferred(address(0), msgSender);
453     }
454 
455     /**
456      * @dev Returns the address of the current owner.
457      */
458     function owner() public view returns (address) {
459         return _owner;
460     }
461 
462     /**
463      * @dev Throws if called by any account other than the owner.
464      */
465     modifier onlyOwner() {
466         require(_owner == _msgSender(), "Ownable: caller is not the owner");
467         _;
468     }
469 
470     /**
471      * @dev Leaves the contract without owner. It will not be possible to call
472      * `onlyOwner` functions anymore. Can only be called by the current owner.
473      *
474      * NOTE: Renouncing ownership will leave the contract without an owner,
475      * thereby removing any functionality that is only available to the owner.
476      */
477     function renounceOwnership() public virtual onlyOwner {
478         emit OwnershipTransferred(_owner, address(0));
479         _owner = address(0);
480     }
481 
482     /**
483      * @dev Transfers ownership of the contract to a new account (`newOwner`).
484      * Can only be called by the current owner.
485      */
486     function transferOwnership(address newOwner) public virtual onlyOwner {
487         require(newOwner != address(0), "Ownable: new owner is the zero address");
488         emit OwnershipTransferred(_owner, newOwner);
489         _owner = newOwner;
490     }
491 }
492 
493 
494 pragma solidity ^0.6.2;
495 
496 contract R2Ftoken is Context, IERC20, Ownable {
497     using SafeMath for uint256;
498     using Address for address;
499 
500     mapping (address => uint256) private _rOwned;
501     mapping (address => uint256) private _tOwned;
502     mapping (address => mapping (address => uint256)) private _allowances;
503 
504     mapping (address => bool) private _isExcluded;
505     address[] private _excluded;
506 
507     uint256 private constant MAX = ~uint256(0);
508     uint256 private constant _tTotal = 14 * 10**6 * 10**9;
509     uint256 private _rTotal = (MAX - (MAX % _tTotal));
510     uint256 private _tFeeTotal;
511 
512     string private _name = 'r2f.finance';
513     string private _symbol = 'R2F';
514     uint8 private _decimals = 9;
515 
516     constructor () public {
517         _rOwned[_msgSender()] = _rTotal;
518         emit Transfer(address(0), _msgSender(), _tTotal);
519     }
520 
521     function name() public view returns (string memory) {
522         return _name;
523     }
524 
525     function symbol() public view returns (string memory) {
526         return _symbol;
527     }
528 
529     function decimals() public view returns (uint8) {
530         return _decimals;
531     }
532 
533     function totalSupply() public view override returns (uint256) {
534         return _tTotal;
535     }
536 
537     function balanceOf(address account) public view override returns (uint256) {
538         if (_isExcluded[account]) return _tOwned[account];
539         return tokenFromReflection(_rOwned[account]);
540     }
541 
542     function transfer(address recipient, uint256 amount) public override returns (bool) {
543         _transfer(_msgSender(), recipient, amount);
544         return true;
545     }
546 
547     function allowance(address owner, address spender) public view override returns (uint256) {
548         return _allowances[owner][spender];
549     }
550 
551     function approve(address spender, uint256 amount) public override returns (bool) {
552         _approve(_msgSender(), spender, amount);
553         return true;
554     }
555 
556     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
557         _transfer(sender, recipient, amount);
558         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
559         return true;
560     }
561 
562     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
563         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
564         return true;
565     }
566 
567     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
568         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
569         return true;
570     }
571 
572     function isExcluded(address account) public view returns (bool) {
573         return _isExcluded[account];
574     }
575 
576     function totalFees() public view returns (uint256) {
577         return _tFeeTotal;
578     }
579 
580     function reflect(uint256 tAmount) public {
581         address sender = _msgSender();
582         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
583         (uint256 rAmount,,,,) = _getValues(tAmount);
584         _rOwned[sender] = _rOwned[sender].sub(rAmount);
585         _rTotal = _rTotal.sub(rAmount);
586         _tFeeTotal = _tFeeTotal.add(tAmount);
587     }
588 
589     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
590         require(tAmount <= _tTotal, "Amount must be less than supply");
591         if (!deductTransferFee) {
592             (uint256 rAmount,,,,) = _getValues(tAmount);
593             return rAmount;
594         } else {
595             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
596             return rTransferAmount;
597         }
598     }
599 
600     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
601         require(rAmount <= _rTotal, "Amount must be less than total reflections");
602         uint256 currentRate =  _getRate();
603         return rAmount.div(currentRate);
604     }
605 
606     function excludeAccount(address account) external onlyOwner() {
607         require(!_isExcluded[account], "Account is already excluded");
608         if(_rOwned[account] > 0) {
609             _tOwned[account] = tokenFromReflection(_rOwned[account]);
610         }
611         _isExcluded[account] = true;
612         _excluded.push(account);
613     }
614 
615     function includeAccount(address account) external onlyOwner() {
616         require(_isExcluded[account], "Account is already excluded");
617         for (uint256 i = 0; i < _excluded.length; i++) {
618             if (_excluded[i] == account) {
619                 _excluded[i] = _excluded[_excluded.length - 1];
620                 _tOwned[account] = 0;
621                 _isExcluded[account] = false;
622                 _excluded.pop();
623                 break;
624             }
625         }
626     }
627 
628     function _approve(address owner, address spender, uint256 amount) private {
629         require(owner != address(0), "ERC20: approve from the zero address");
630         require(spender != address(0), "ERC20: approve to the zero address");
631 
632         _allowances[owner][spender] = amount;
633         emit Approval(owner, spender, amount);
634     }
635 
636     function _transfer(address sender, address recipient, uint256 amount) private {
637         require(sender != address(0), "ERC20: transfer from the zero address");
638         require(recipient != address(0), "ERC20: transfer to the zero address");
639         require(amount > 0, "Transfer amount must be greater than zero");
640         if (_isExcluded[sender] && !_isExcluded[recipient]) {
641             _transferFromExcluded(sender, recipient, amount);
642         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
643             _transferToExcluded(sender, recipient, amount);
644         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
645             _transferStandard(sender, recipient, amount);
646         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
647             _transferBothExcluded(sender, recipient, amount);
648         } else {
649             _transferStandard(sender, recipient, amount);
650         }
651     }
652 
653     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
654         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
655         _rOwned[sender] = _rOwned[sender].sub(rAmount);
656         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
657         _reflectFee(rFee, tFee);
658         emit Transfer(sender, recipient, tTransferAmount);
659     }
660 
661     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
662         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
663         _rOwned[sender] = _rOwned[sender].sub(rAmount);
664         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
665         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
666         _reflectFee(rFee, tFee);
667         emit Transfer(sender, recipient, tTransferAmount);
668     }
669 
670     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
671         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
672         _tOwned[sender] = _tOwned[sender].sub(tAmount);
673         _rOwned[sender] = _rOwned[sender].sub(rAmount);
674         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
675         _reflectFee(rFee, tFee);
676         emit Transfer(sender, recipient, tTransferAmount);
677     }
678 
679     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
680         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
681         _tOwned[sender] = _tOwned[sender].sub(tAmount);
682         _rOwned[sender] = _rOwned[sender].sub(rAmount);
683         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
684         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
685         _reflectFee(rFee, tFee);
686         emit Transfer(sender, recipient, tTransferAmount);
687     }
688 
689     function _reflectFee(uint256 rFee, uint256 tFee) private {
690         _rTotal = _rTotal.sub(rFee);
691         _tFeeTotal = _tFeeTotal.add(tFee);
692     }
693 
694     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
695         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
696         uint256 currentRate =  _getRate();
697         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
698         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
699     }
700 
701     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
702         uint256 tFee = tAmount.mul(8).div(100);
703         uint256 tTransferAmount = tAmount.sub(tFee);
704         return (tTransferAmount, tFee);
705     }
706 
707     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
708         uint256 rAmount = tAmount.mul(currentRate);
709         uint256 rFee = tFee.mul(currentRate);
710         uint256 rTransferAmount = rAmount.sub(rFee);
711         return (rAmount, rTransferAmount, rFee);
712     }
713 
714     function _getRate() private view returns(uint256) {
715         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
716         return rSupply.div(tSupply);
717     }
718 
719     function _getCurrentSupply() private view returns(uint256, uint256) {
720         uint256 rSupply = _rTotal;
721         uint256 tSupply = _tTotal;
722         for (uint256 i = 0; i < _excluded.length; i++) {
723             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
724             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
725             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
726         }
727         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
728         return (rSupply, tSupply);
729     }
730 }