1 // REFLECTOR.Finance: DeFi token with 12% reflect redistribution tax
2 
3 // ██████╗ ███████╗███████╗██╗     ███████╗ ██████╗████████╗ ██████╗ ██████╗ 
4 // ██╔══██╗██╔════╝██╔════╝██║     ██╔════╝██╔════╝╚══██╔══╝██╔═══██╗██╔══██╗
5 // ██████╔╝█████╗  █████╗  ██║     █████╗  ██║        ██║   ██║   ██║██████╔╝
6 // ██╔══██╗██╔══╝  ██╔══╝  ██║     ██╔══╝  ██║        ██║   ██║   ██║██╔══██╗
7 // ██║  ██║███████╗██║     ███████╗███████╗╚██████╗   ██║   ╚██████╔╝██║  ██║
8 // ╚═╝  ╚═╝╚══════╝╚═╝     ╚══════╝╚══════╝ ╚═════╝   ╚═╝    ╚═════╝ ╚═╝  ╚═╝
9                                                                           
10 // Reflector is a modified fork of RFI
11 // SPDX-License-Identifier: MIT
12 
13 pragma solidity ^0.6.0;
14 
15 /*
16  * @dev Provides information about the current execution context, including the
17  * sender of the transaction and its data. While these are generally available
18  * via msg.sender and msg.data, they should not be accessed in such a direct
19  * manner, since when dealing with GSN meta-transactions the account sending and
20  * paying for execution may not be the actual sender (as far as an application
21  * is concerned).
22  *
23  * This contract is only required for intermediate, library-like contracts.
24  */
25 abstract contract Context {
26     function _msgSender() internal view virtual returns (address payable) {
27         return msg.sender;
28     }
29 
30     function _msgData() internal view virtual returns (bytes memory) {
31         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
32         return msg.data;
33     }
34 }
35 
36 // File: openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
37 
38 // SPDX-License-Identifier: MIT
39 
40 pragma solidity ^0.6.0;
41 
42 /**
43  * @dev Interface of the ERC20 standard as defined in the EIP.
44  */
45 interface IERC20 {
46     /**
47      * @dev Returns the amount of tokens in existence.
48      */
49     function totalSupply() external view returns (uint256);
50 
51     /**
52      * @dev Returns the amount of tokens owned by `account`.
53      */
54     function balanceOf(address account) external view returns (uint256);
55 
56     /**
57      * @dev Moves `amount` tokens from the caller's account to `recipient`.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * Emits a {Transfer} event.
62      */
63     function transfer(address recipient, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Returns the remaining number of tokens that `spender` will be
67      * allowed to spend on behalf of `owner` through {transferFrom}. This is
68      * zero by default.
69      *
70      * This value changes when {approve} or {transferFrom} are called.
71      */
72     function allowance(address owner, address spender) external view returns (uint256);
73 
74     /**
75      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * IMPORTANT: Beware that changing an allowance with this method brings the risk
80      * that someone may use both the old and the new allowance by unfortunate
81      * transaction ordering. One possible solution to mitigate this race
82      * condition is to first reduce the spender's allowance to 0 and set the
83      * desired value afterwards:
84      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
85      *
86      * Emits an {Approval} event.
87      */
88     function approve(address spender, uint256 amount) external returns (bool);
89 
90     /**
91      * @dev Moves `amount` tokens from `sender` to `recipient` using the
92      * allowance mechanism. `amount` is then deducted from the caller's
93      * allowance.
94      *
95      * Returns a boolean value indicating whether the operation succeeded.
96      *
97      * Emits a {Transfer} event.
98      */
99     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
100 
101     /**
102      * @dev Emitted when `value` tokens are moved from one account (`from`) to
103      * another (`to`).
104      *
105      * Note that `value` may be zero.
106      */
107     event Transfer(address indexed from, address indexed to, uint256 value);
108 
109     /**
110      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
111      * a call to {approve}. `value` is the new allowance.
112      */
113     event Approval(address indexed owner, address indexed spender, uint256 value);
114 }
115 
116 // File: openzeppelin-solidity\contracts\math\SafeMath.sol
117 
118 // SPDX-License-Identifier: MIT
119 
120 pragma solidity ^0.6.0;
121 
122 /**
123  * @dev Wrappers over Solidity's arithmetic operations with added overflow
124  * checks.
125  *
126  * Arithmetic operations in Solidity wrap on overflow. This can easily result
127  * in bugs, because programmers usually assume that an overflow raises an
128  * error, which is the standard behavior in high level programming languages.
129  * `SafeMath` restores this intuition by reverting the transaction when an
130  * operation overflows.
131  *
132  * Using this library instead of the unchecked operations eliminates an entire
133  * class of bugs, so it's recommended to use it always.
134  */
135 library SafeMath {
136     /**
137      * @dev Returns the addition of two unsigned integers, reverting on
138      * overflow.
139      *
140      * Counterpart to Solidity's `+` operator.
141      *
142      * Requirements:
143      *
144      * - Addition cannot overflow.
145      */
146     function add(uint256 a, uint256 b) internal pure returns (uint256) {
147         uint256 c = a + b;
148         require(c >= a, "SafeMath: addition overflow");
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the subtraction of two unsigned integers, reverting on
155      * overflow (when the result is negative).
156      *
157      * Counterpart to Solidity's `-` operator.
158      *
159      * Requirements:
160      *
161      * - Subtraction cannot overflow.
162      */
163     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
164         return sub(a, b, "SafeMath: subtraction overflow");
165     }
166 
167     /**
168      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
169      * overflow (when the result is negative).
170      *
171      * Counterpart to Solidity's `-` operator.
172      *
173      * Requirements:
174      *
175      * - Subtraction cannot overflow.
176      */
177     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
178         require(b <= a, errorMessage);
179         uint256 c = a - b;
180 
181         return c;
182     }
183 
184     /**
185      * @dev Returns the multiplication of two unsigned integers, reverting on
186      * overflow.
187      *
188      * Counterpart to Solidity's `*` operator.
189      *
190      * Requirements:
191      *
192      * - Multiplication cannot overflow.
193      */
194     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
195         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
196         // benefit is lost if 'b' is also tested.
197         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
198         if (a == 0) {
199             return 0;
200         }
201 
202         uint256 c = a * b;
203         require(c / a == b, "SafeMath: multiplication overflow");
204 
205         return c;
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers. Reverts on
210      * division by zero. The result is rounded towards zero.
211      *
212      * Counterpart to Solidity's `/` operator. Note: this function uses a
213      * `revert` opcode (which leaves remaining gas untouched) while Solidity
214      * uses an invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function div(uint256 a, uint256 b) internal pure returns (uint256) {
221         return div(a, b, "SafeMath: division by zero");
222     }
223 
224     /**
225      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
226      * division by zero. The result is rounded towards zero.
227      *
228      * Counterpart to Solidity's `/` operator. Note: this function uses a
229      * `revert` opcode (which leaves remaining gas untouched) while Solidity
230      * uses an invalid opcode to revert (consuming all remaining gas).
231      *
232      * Requirements:
233      *
234      * - The divisor cannot be zero.
235      */
236     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
237         require(b > 0, errorMessage);
238         uint256 c = a / b;
239         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
240 
241         return c;
242     }
243 
244     /**
245      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
246      * Reverts when dividing by zero.
247      *
248      * Counterpart to Solidity's `%` operator. This function uses a `revert`
249      * opcode (which leaves remaining gas untouched) while Solidity uses an
250      * invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      *
254      * - The divisor cannot be zero.
255      */
256     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
257         return mod(a, b, "SafeMath: modulo by zero");
258     }
259 
260     /**
261      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
262      * Reverts with custom message when dividing by zero.
263      *
264      * Counterpart to Solidity's `%` operator. This function uses a `revert`
265      * opcode (which leaves remaining gas untouched) while Solidity uses an
266      * invalid opcode to revert (consuming all remaining gas).
267      *
268      * Requirements:
269      *
270      * - The divisor cannot be zero.
271      */
272     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
273         require(b != 0, errorMessage);
274         return a % b;
275     }
276 }
277 
278 // File: openzeppelin-solidity\contracts\utils\Address.sol
279 
280 // SPDX-License-Identifier: MIT
281 
282 pragma solidity ^0.6.2;
283 
284 /**
285  * @dev Collection of functions related to the address type
286  */
287 library Address {
288     /**
289      * @dev Returns true if `account` is a contract.
290      *
291      * [IMPORTANT]
292      * ====
293      * It is unsafe to assume that an address for which this function returns
294      * false is an externally-owned account (EOA) and not a contract.
295      *
296      * Among others, `isContract` will return false for the following
297      * types of addresses:
298      *
299      *  - an externally-owned account
300      *  - a contract in construction
301      *  - an address where a contract will be created
302      *  - an address where a contract lived, but was destroyed
303      * ====
304      */
305     function isContract(address account) internal view returns (bool) {
306         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
307         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
308         // for accounts without code, i.e. `keccak256('')`
309         bytes32 codehash;
310         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
311         // solhint-disable-next-line no-inline-assembly
312         assembly { codehash := extcodehash(account) }
313         return (codehash != accountHash && codehash != 0x0);
314     }
315 
316     /**
317      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
318      * `recipient`, forwarding all available gas and reverting on errors.
319      *
320      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
321      * of certain opcodes, possibly making contracts go over the 2300 gas limit
322      * imposed by `transfer`, making them unable to receive funds via
323      * `transfer`. {sendValue} removes this limitation.
324      *
325      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
326      *
327      * IMPORTANT: because control is transferred to `recipient`, care must be
328      * taken to not create reentrancy vulnerabilities. Consider using
329      * {ReentrancyGuard} or the
330      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
331      */
332     function sendValue(address payable recipient, uint256 amount) internal {
333         require(address(this).balance >= amount, "Address: insufficient balance");
334 
335         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
336         (bool success, ) = recipient.call{ value: amount }("");
337         require(success, "Address: unable to send value, recipient may have reverted");
338     }
339 
340     /**
341      * @dev Performs a Solidity function call using a low level `call`. A
342      * plain`call` is an unsafe replacement for a function call: use this
343      * function instead.
344      *
345      * If `target` reverts with a revert reason, it is bubbled up by this
346      * function (like regular Solidity function calls).
347      *
348      * Returns the raw returned data. To convert to the expected return value,
349      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
350      *
351      * Requirements:
352      *
353      * - `target` must be a contract.
354      * - calling `target` with `data` must not revert.
355      *
356      * _Available since v3.1._
357      */
358     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
359         return functionCall(target, data, "Address: low-level call failed");
360     }
361 
362     /**
363      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
364      * `errorMessage` as a fallback revert reason when `target` reverts.
365      *
366      * _Available since v3.1._
367      */
368     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
369         return _functionCallWithValue(target, data, 0, errorMessage);
370     }
371 
372     /**
373      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
374      * but also transferring `value` wei to `target`.
375      *
376      * Requirements:
377      *
378      * - the calling contract must have an ETH balance of at least `value`.
379      * - the called Solidity function must be `payable`.
380      *
381      * _Available since v3.1._
382      */
383     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
384         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
389      * with `errorMessage` as a fallback revert reason when `target` reverts.
390      *
391      * _Available since v3.1._
392      */
393     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
394         require(address(this).balance >= value, "Address: insufficient balance for call");
395         return _functionCallWithValue(target, data, value, errorMessage);
396     }
397 
398     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
399         require(isContract(target), "Address: call to non-contract");
400 
401         // solhint-disable-next-line avoid-low-level-calls
402         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
403         if (success) {
404             return returndata;
405         } else {
406             // Look for revert reason and bubble it up if present
407             if (returndata.length > 0) {
408                 // The easiest way to bubble the revert reason is using memory via assembly
409 
410                 // solhint-disable-next-line no-inline-assembly
411                 assembly {
412                     let returndata_size := mload(returndata)
413                     revert(add(32, returndata), returndata_size)
414                 }
415             } else {
416                 revert(errorMessage);
417             }
418         }
419     }
420 }
421 
422 // File: openzeppelin-solidity\contracts\access\Ownable.sol
423 
424 // SPDX-License-Identifier: MIT
425 
426 pragma solidity ^0.6.0;
427 
428 /**
429  * @dev Contract module which provides a basic access control mechanism, where
430  * there is an account (an owner) that can be granted exclusive access to
431  * specific functions.
432  *
433  * By default, the owner account will be the one that deploys the contract. This
434  * can later be changed with {transferOwnership}.
435  *
436  * This module is used through inheritance. It will make available the modifier
437  * `onlyOwner`, which can be applied to your functions to restrict their use to
438  * the owner.
439  */
440 contract Ownable is Context {
441     address private _owner;
442 
443     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
444 
445     /**
446      * @dev Initializes the contract setting the deployer as the initial owner.
447      */
448     constructor () internal {
449         address msgSender = _msgSender();
450         _owner = msgSender;
451         emit OwnershipTransferred(address(0), msgSender);
452     }
453 
454     /**
455      * @dev Returns the address of the current owner.
456      */
457     function owner() public view returns (address) {
458         return _owner;
459     }
460 
461     /**
462      * @dev Throws if called by any account other than the owner.
463      */
464     modifier onlyOwner() {
465         require(_owner == _msgSender(), "Ownable: caller is not the owner");
466         _;
467     }
468 
469     /**
470      * @dev Leaves the contract without owner. It will not be possible to call
471      * `onlyOwner` functions anymore. Can only be called by the current owner.
472      *
473      * NOTE: Renouncing ownership will leave the contract without an owner,
474      * thereby removing any functionality that is only available to the owner.
475      */
476     function renounceOwnership() public virtual onlyOwner {
477         emit OwnershipTransferred(_owner, address(0));
478         _owner = address(0);
479     }
480 
481     /**
482      * @dev Transfers ownership of the contract to a new account (`newOwner`).
483      * Can only be called by the current owner.
484      */
485     function transferOwnership(address newOwner) public virtual onlyOwner {
486         require(newOwner != address(0), "Ownable: new owner is the zero address");
487         emit OwnershipTransferred(_owner, newOwner);
488         _owner = newOwner;
489     }
490 }
491 
492 
493 pragma solidity ^0.6.2;
494 
495 contract REFLECTORtoken is Context, IERC20, Ownable {
496     using SafeMath for uint256;
497     using Address for address;
498 
499     mapping (address => uint256) private _rOwned;
500     mapping (address => uint256) private _tOwned;
501     mapping (address => mapping (address => uint256)) private _allowances;
502 
503     mapping (address => bool) private _isExcluded;
504     address[] private _excluded;
505 
506     uint256 private constant MAX = ~uint256(0);
507     uint256 private constant _tTotal = 12 * 10**6 * 10**9;
508     uint256 private _rTotal = (MAX - (MAX % _tTotal));
509     uint256 private _tFeeTotal;
510 
511     string private _name = 'reflector.finance';
512     string private _symbol = 'RFCTR';
513     uint8 private _decimals = 9;
514 
515     constructor () public {
516         _rOwned[_msgSender()] = _rTotal;
517         emit Transfer(address(0), _msgSender(), _tTotal);
518     }
519 
520     function name() public view returns (string memory) {
521         return _name;
522     }
523 
524     function symbol() public view returns (string memory) {
525         return _symbol;
526     }
527 
528     function decimals() public view returns (uint8) {
529         return _decimals;
530     }
531 
532     function totalSupply() public view override returns (uint256) {
533         return _tTotal;
534     }
535 
536     function balanceOf(address account) public view override returns (uint256) {
537         if (_isExcluded[account]) return _tOwned[account];
538         return tokenFromReflection(_rOwned[account]);
539     }
540 
541     function transfer(address recipient, uint256 amount) public override returns (bool) {
542         _transfer(_msgSender(), recipient, amount);
543         return true;
544     }
545 
546     function allowance(address owner, address spender) public view override returns (uint256) {
547         return _allowances[owner][spender];
548     }
549 
550     function approve(address spender, uint256 amount) public override returns (bool) {
551         _approve(_msgSender(), spender, amount);
552         return true;
553     }
554 
555     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
556         _transfer(sender, recipient, amount);
557         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
558         return true;
559     }
560 
561     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
562         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
563         return true;
564     }
565 
566     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
567         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
568         return true;
569     }
570 
571     function isExcluded(address account) public view returns (bool) {
572         return _isExcluded[account];
573     }
574 
575     function totalFees() public view returns (uint256) {
576         return _tFeeTotal;
577     }
578 
579     function reflect(uint256 tAmount) public {
580         address sender = _msgSender();
581         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
582         (uint256 rAmount,,,,) = _getValues(tAmount);
583         _rOwned[sender] = _rOwned[sender].sub(rAmount);
584         _rTotal = _rTotal.sub(rAmount);
585         _tFeeTotal = _tFeeTotal.add(tAmount);
586     }
587 
588     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
589         require(tAmount <= _tTotal, "Amount must be less than supply");
590         if (!deductTransferFee) {
591             (uint256 rAmount,,,,) = _getValues(tAmount);
592             return rAmount;
593         } else {
594             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
595             return rTransferAmount;
596         }
597     }
598 
599     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
600         require(rAmount <= _rTotal, "Amount must be less than total reflections");
601         uint256 currentRate =  _getRate();
602         return rAmount.div(currentRate);
603     }
604 
605     function excludeAccount(address account) external onlyOwner() {
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
628         require(owner != address(0), "ERC20: approve from the zero address");
629         require(spender != address(0), "ERC20: approve to the zero address");
630 
631         _allowances[owner][spender] = amount;
632         emit Approval(owner, spender, amount);
633     }
634 
635     function _transfer(address sender, address recipient, uint256 amount) private {
636         require(sender != address(0), "ERC20: transfer from the zero address");
637         require(recipient != address(0), "ERC20: transfer to the zero address");
638         require(amount > 0, "Transfer amount must be greater than zero");
639         if (_isExcluded[sender] && !_isExcluded[recipient]) {
640             _transferFromExcluded(sender, recipient, amount);
641         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
642             _transferToExcluded(sender, recipient, amount);
643         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
644             _transferStandard(sender, recipient, amount);
645         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
646             _transferBothExcluded(sender, recipient, amount);
647         } else {
648             _transferStandard(sender, recipient, amount);
649         }
650     }
651 
652     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
653         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
654         _rOwned[sender] = _rOwned[sender].sub(rAmount);
655         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
656         _reflectFee(rFee, tFee);
657         emit Transfer(sender, recipient, tTransferAmount);
658     }
659 
660     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
661         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
662         _rOwned[sender] = _rOwned[sender].sub(rAmount);
663         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
664         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
665         _reflectFee(rFee, tFee);
666         emit Transfer(sender, recipient, tTransferAmount);
667     }
668 
669     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
670         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
671         _tOwned[sender] = _tOwned[sender].sub(tAmount);
672         _rOwned[sender] = _rOwned[sender].sub(rAmount);
673         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
674         _reflectFee(rFee, tFee);
675         emit Transfer(sender, recipient, tTransferAmount);
676     }
677 
678     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
679         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
680         _tOwned[sender] = _tOwned[sender].sub(tAmount);
681         _rOwned[sender] = _rOwned[sender].sub(rAmount);
682         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
683         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
684         _reflectFee(rFee, tFee);
685         emit Transfer(sender, recipient, tTransferAmount);
686     }
687 
688     function _reflectFee(uint256 rFee, uint256 tFee) private {
689         _rTotal = _rTotal.sub(rFee);
690         _tFeeTotal = _tFeeTotal.add(tFee);
691     }
692 
693     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
694         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
695         uint256 currentRate =  _getRate();
696         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
697         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
698     }
699 
700     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
701         uint256 tFee = tAmount.mul(12).div(100);
702         uint256 tTransferAmount = tAmount.sub(tFee);
703         return (tTransferAmount, tFee);
704     }
705 
706     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
707         uint256 rAmount = tAmount.mul(currentRate);
708         uint256 rFee = tFee.mul(currentRate);
709         uint256 rTransferAmount = rAmount.sub(rFee);
710         return (rAmount, rTransferAmount, rFee);
711     }
712 
713     function _getRate() private view returns(uint256) {
714         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
715         return rSupply.div(tSupply);
716     }
717 
718     function _getCurrentSupply() private view returns(uint256, uint256) {
719         uint256 rSupply = _rTotal;
720         uint256 tSupply = _tTotal;
721         for (uint256 i = 0; i < _excluded.length; i++) {
722             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
723             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
724             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
725         }
726         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
727         return (rSupply, tSupply);
728     }
729 }