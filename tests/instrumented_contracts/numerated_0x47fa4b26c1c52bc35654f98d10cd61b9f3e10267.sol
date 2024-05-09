1 // File: openzeppelin-solidity\contracts\GSN\Context.sol
2 
3 // SPDX-License-Identifier: MIT
4 
5 pragma solidity ^0.8.4;
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
18     function _msgSender() internal view virtual returns (address) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 
29 pragma solidity ^0.8.4;
30 
31 
32 /**
33  * @dev Interface of the ERC20 standard as defined in the EIP.
34  */
35 interface IERC20 {
36     /**
37      * @dev Returns the amount of tokens in existence.
38      */
39     function totalSupply() external view returns (uint256);
40 
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44     function balanceOf(address account) external view returns (uint256);
45 
46     /**
47      * @dev Moves `amount` tokens from the caller's account to `recipient`.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * Emits a {Transfer} event.
52      */
53     function transfer(address recipient, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * IMPORTANT: Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an {Approval} event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from `sender` to `recipient` using the
82      * allowance mechanism. `amount` is then deducted from the caller's
83      * allowance.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 
107 pragma solidity ^0.8.4;
108 
109 
110 /**
111  * @dev Wrappers over Solidity's arithmetic operations with added overflow
112  * checks.
113  *
114  * Arithmetic operations in Solidity wrap on overflow. This can easily result
115  * in bugs, because programmers usually assume that an overflow raises an
116  * error, which is the standard behavior in high level programming languages.
117  * `SafeMath` restores this intuition by reverting the transaction when an
118  * operation overflows.
119  *
120  * Using this library instead of the unchecked operations eliminates an entire
121  * class of bugs, so it's recommended to use it always.
122  */
123 library SafeMath {
124     /**
125      * @dev Returns the addition of two unsigned integers, reverting on
126      * overflow.
127      *
128      * Counterpart to Solidity's `+` operator.
129      *
130      * Requirements:
131      *
132      * - Addition cannot overflow.
133      */
134     function add(uint256 a, uint256 b) internal pure returns (uint256) {
135         uint256 c = a + b;
136         require(c >= a, "SafeMath: addition overflow");
137 
138         return c;
139     }
140 
141     /**
142      * @dev Returns the subtraction of two unsigned integers, reverting on
143      * overflow (when the result is negative).
144      *
145      * Counterpart to Solidity's `-` operator.
146      *
147      * Requirements:
148      *
149      * - Subtraction cannot overflow.
150      */
151     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
152         return sub(a, b, "SafeMath: subtraction overflow");
153     }
154 
155     /**
156      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
157      * overflow (when the result is negative).
158      *
159      * Counterpart to Solidity's `-` operator.
160      *
161      * Requirements:
162      *
163      * - Subtraction cannot overflow.
164      */
165     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
166         require(b <= a, errorMessage);
167         uint256 c = a - b;
168 
169         return c;
170     }
171 
172     /**
173      * @dev Returns the multiplication of two unsigned integers, reverting on
174      * overflow.
175      *
176      * Counterpart to Solidity's `*` operator.
177      *
178      * Requirements:
179      *
180      * - Multiplication cannot overflow.
181      */
182     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
183         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
184         // benefit is lost if 'b' is also tested.
185         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
186         if (a == 0) {
187             return 0;
188         }
189 
190         uint256 c = a * b;
191         require(c / a == b, "SafeMath: multiplication overflow");
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the integer division of two unsigned integers. Reverts on
198      * division by zero. The result is rounded towards zero.
199      *
200      * Counterpart to Solidity's `/` operator. Note: this function uses a
201      * `revert` opcode (which leaves remaining gas untouched) while Solidity
202      * uses an invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function div(uint256 a, uint256 b) internal pure returns (uint256) {
209         return div(a, b, "SafeMath: division by zero");
210     }
211 
212     /**
213      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
214      * division by zero. The result is rounded towards zero.
215      *
216      * Counterpart to Solidity's `/` operator. Note: this function uses a
217      * `revert` opcode (which leaves remaining gas untouched) while Solidity
218      * uses an invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b > 0, errorMessage);
226         uint256 c = a / b;
227         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
228 
229         return c;
230     }
231 
232     /**
233      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
234      * Reverts when dividing by zero.
235      *
236      * Counterpart to Solidity's `%` operator. This function uses a `revert`
237      * opcode (which leaves remaining gas untouched) while Solidity uses an
238      * invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
245         return mod(a, b, "SafeMath: modulo by zero");
246     }
247 
248     /**
249      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
250      * Reverts with custom message when dividing by zero.
251      *
252      * Counterpart to Solidity's `%` operator. This function uses a `revert`
253      * opcode (which leaves remaining gas untouched) while Solidity uses an
254      * invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
261         require(b != 0, errorMessage);
262         return a % b;
263     }
264 }
265 
266 pragma solidity ^0.8.4;
267 
268 /**
269  * @dev Collection of functions related to the address type
270  */
271 library Address {
272     /**
273      * @dev Returns true if `account` is a contract.
274      *
275      * [IMPORTANT]
276      * ====
277      * It is unsafe to assume that an address for which this function returns
278      * false is an externally-owned account (EOA) and not a contract.
279      *
280      * Among others, `isContract` will return false for the following
281      * types of addresses:
282      *
283      *  - an externally-owned account
284      *  - a contract in construction
285      *  - an address where a contract will be created
286      *  - an address where a contract lived, but was destroyed
287      * ====
288      */
289     function isContract(address account) internal view returns (bool) {
290         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
291         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
292         // for accounts without code, i.e. `keccak256('')`
293         bytes32 codehash;
294         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
295         // solhint-disable-next-line no-inline-assembly
296         assembly { codehash := extcodehash(account) }
297         return (codehash != accountHash && codehash != 0x0);
298     }
299 
300     /**
301      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
302      * `recipient`, forwarding all available gas and reverting on errors.
303      *
304      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
305      * of certain opcodes, possibly making contracts go over the 2300 gas limit
306      * imposed by `transfer`, making them unable to receive funds via
307      * `transfer`. {sendValue} removes this limitation.
308      *
309      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
310      *
311      * IMPORTANT: because control is transferred to `recipient`, care must be
312      * taken to not create reentrancy vulnerabilities. Consider using
313      * {ReentrancyGuard} or the
314      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
315      */
316     function sendValue(address payable recipient, uint256 amount) internal {
317         require(address(this).balance >= amount, "Address: insufficient balance");
318 
319         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
320         (bool success, ) = recipient.call{ value: amount }("");
321         require(success, "Address: unable to send value, recipient may have reverted");
322     }
323 
324     /**
325      * @dev Performs a Solidity function call using a low level `call`. A
326      * plain`call` is an unsafe replacement for a function call: use this
327      * function instead.
328      *
329      * If `target` reverts with a revert reason, it is bubbled up by this
330      * function (like regular Solidity function calls).
331      *
332      * Returns the raw returned data. To convert to the expected return value,
333      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
334      *
335      * Requirements:
336      *
337      * - `target` must be a contract.
338      * - calling `target` with `data` must not revert.
339      *
340      * _Available since v3.1._
341      */
342     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
343       return functionCall(target, data, "Address: low-level call failed");
344     }
345 
346     /**
347      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
348      * `errorMessage` as a fallback revert reason when `target` reverts.
349      *
350      * _Available since v3.1._
351      */
352     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
353         return _functionCallWithValue(target, data, 0, errorMessage);
354     }
355 
356     /**
357      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
358      * but also transferring `value` wei to `target`.
359      *
360      * Requirements:
361      *
362      * - the calling contract must have an ETH balance of at least `value`.
363      * - the called Solidity function must be `payable`.
364      *
365      * _Available since v3.1._
366      */
367     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
368         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
369     }
370 
371     /**
372      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
373      * with `errorMessage` as a fallback revert reason when `target` reverts.
374      *
375      * _Available since v3.1._
376      */
377     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
378         require(address(this).balance >= value, "Address: insufficient balance for call");
379         return _functionCallWithValue(target, data, value, errorMessage);
380     }
381 
382     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
383         require(isContract(target), "Address: call to non-contract");
384 
385         // solhint-disable-next-line avoid-low-level-calls
386         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
387         if (success) {
388             return returndata;
389         } else {
390             // Look for revert reason and bubble it up if present
391             if (returndata.length > 0) {
392                 // The easiest way to bubble the revert reason is using memory via assembly
393 
394                 // solhint-disable-next-line no-inline-assembly
395                 assembly {
396                     let returndata_size := mload(returndata)
397                     revert(add(32, returndata), returndata_size)
398                 }
399             } else {
400                 revert(errorMessage);
401             }
402         }
403     }
404 }
405 
406 
407 pragma solidity ^0.8.4;
408 
409 /**
410  * @dev Contract module which provides a basic access control mechanism, where
411  * there is an account (an owner) that can be granted exclusive access to
412  * specific functions.
413  *
414  * By default, the owner account will be the one that deploys the contract. This
415  * can later be changed with {transferOwnership}.
416  *
417  * This module is used through inheritance. It will make available the modifier
418  * `onlyOwner`, which can be applied to your functions to restrict their use to
419  * the owner.
420  */
421 contract Ownable is Context {
422     address private _owner;
423 
424     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
425 
426     /**
427      * @dev Initializes the contract setting the deployer as the initial owner.
428      */
429     constructor () {
430         address msgSender = _msgSender();
431         _owner = msgSender;
432         emit OwnershipTransferred(address(0), msgSender);
433     }
434 
435     /**
436      * @dev Returns the address of the current owner.
437      */
438     function owner() public view returns (address) {
439         return _owner;
440     }
441 
442     /**
443      * @dev Throws if called by any account other than the owner.
444      */
445     modifier onlyOwner() {
446         require(_owner == _msgSender(), "Ownable: caller is not the owner");
447         _;
448     }
449 
450     /**
451      * @dev Leaves the contract without owner. It will not be possible to call
452      * `onlyOwner` functions anymore. Can only be called by the current owner.
453      *
454      * NOTE: Renouncing ownership will leave the contract without an owner,
455      * thereby removing any functionality that is only available to the owner.
456      */
457     function renounceOwnership() public virtual onlyOwner {
458         emit OwnershipTransferred(_owner, address(0));
459         _owner = address(0);
460     }
461 
462     /**
463      * @dev Transfers ownership of the contract to a new account (`newOwner`).
464      * Can only be called by the current owner.
465      */
466     function transferOwnership(address newOwner) public virtual onlyOwner {
467         require(newOwner != address(0), "Ownable: new owner is the zero address");
468         emit OwnershipTransferred(_owner, newOwner);
469         _owner = newOwner;
470     }
471 }
472 
473 pragma solidity ^0.8.4;
474 
475 contract TINKU is Context, IERC20, Ownable {
476     using SafeMath for uint256;
477     using Address for address;
478 
479     mapping (address => uint256) private _rOwned;
480     mapping (address => uint256) private _tOwned;
481     mapping (address => mapping (address => uint256)) private _allowances;
482 
483     mapping (address => bool) private _isExcluded;
484     address[] private _excluded;
485    
486     uint256 private constant MAX = ~uint256(0);
487     uint256 private constant _tTotal = 100000000000000000 * 10**9;
488     uint256 private _rTotal = (MAX - (MAX % _tTotal));
489     uint256 private _tFeeTotal;
490 
491     string private _name = 'TINKU';
492     string private _symbol = 'TINKU';
493     uint8 private _decimals = 9;
494 
495     constructor () {
496         _rOwned[_msgSender()] = _rTotal;
497         emit Transfer(address(0), _msgSender(), _tTotal);
498     }
499 
500     function name() public view returns (string memory) {
501         return _name;
502     }
503 
504     function symbol() public view returns (string memory) {
505         return _symbol;
506     }
507 
508     function decimals() public view returns (uint8) {
509         return _decimals;
510     }
511 
512     function totalSupply() public pure override returns (uint256) {
513         return _tTotal;
514     }
515 
516     function balanceOf(address account) public view override returns (uint256) {
517         if (_isExcluded[account]) return _tOwned[account];
518         return tokenFromReflection(_rOwned[account]);
519     }
520 
521     function transfer(address recipient, uint256 amount) public override returns (bool) {
522         _transfer(_msgSender(), recipient, amount);
523         return true;
524     }
525 
526     function allowance(address owner, address spender) public view override returns (uint256) {
527         return _allowances[owner][spender];
528     }
529 
530     function approve(address spender, uint256 amount) public override returns (bool) {
531         _approve(_msgSender(), spender, amount);
532         return true;
533     }
534 
535     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
536         _transfer(sender, recipient, amount);
537         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
538         return true;
539     }
540 
541     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
542         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
543         return true;
544     }
545 
546     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
547         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
548         return true;
549     }
550 
551     function isExcluded(address account) public view returns (bool) {
552         return _isExcluded[account];
553     }
554 
555     function totalFees() public view returns (uint256) {
556         return _tFeeTotal;
557     }
558 
559     function reflect(uint256 tAmount) public {
560         address sender = _msgSender();
561         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
562         (uint256 rAmount,,,,) = _getValues(tAmount);
563         _rOwned[sender] = _rOwned[sender].sub(rAmount);
564         _rTotal = _rTotal.sub(rAmount);
565         _tFeeTotal = _tFeeTotal.add(tAmount);
566     }
567 
568     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
569         require(tAmount <= _tTotal, "Amount must be less than supply");
570         if (!deductTransferFee) {
571             (uint256 rAmount,,,,) = _getValues(tAmount);
572             return rAmount;
573         } else {
574             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
575             return rTransferAmount;
576         }
577     }
578 
579     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
580         require(rAmount <= _rTotal, "Amount must be less than total reflections");
581         uint256 currentRate =  _getRate();
582         return rAmount.div(currentRate);
583     }
584 
585     function excludeAccount(address account) external onlyOwner() {
586         require(!_isExcluded[account], "Account is already excluded");
587         if(_rOwned[account] > 0) {
588             _tOwned[account] = tokenFromReflection(_rOwned[account]);
589         }
590         _isExcluded[account] = true;
591         _excluded.push(account);
592     }
593 
594     function includeAccount(address account) external onlyOwner() {
595         require(_isExcluded[account], "Account is already excluded");
596         for (uint256 i = 0; i < _excluded.length; i++) {
597             if (_excluded[i] == account) {
598                 _excluded[i] = _excluded[_excluded.length - 1];
599                 _tOwned[account] = 0;
600                 _isExcluded[account] = false;
601                 _excluded.pop();
602                 break;
603             }
604         }
605     }
606 
607     function _approve(address owner, address spender, uint256 amount) private {
608         require(owner != address(0), "ERC20: approve from the zero address");
609         require(spender != address(0), "ERC20: approve to the zero address");
610 
611         _allowances[owner][spender] = amount;
612         emit Approval(owner, spender, amount);
613     }
614 
615     function _transfer(address sender, address recipient, uint256 amount) private {
616         require(sender != address(0), "ERC20: transfer from the zero address");
617         require(recipient != address(0), "ERC20: transfer to the zero address");
618         require(amount > 0, "Transfer amount must be greater than zero");
619         if (_isExcluded[sender] && !_isExcluded[recipient]) {
620             _transferFromExcluded(sender, recipient, amount);
621         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
622             _transferToExcluded(sender, recipient, amount);
623         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
624             _transferStandard(sender, recipient, amount);
625         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
626             _transferBothExcluded(sender, recipient, amount);
627         } else {
628             _transferStandard(sender, recipient, amount);
629         }
630     }
631 
632     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
633         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
634         _rOwned[sender] = _rOwned[sender].sub(rAmount);
635         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
636         _reflectFee(rFee, tFee);
637         emit Transfer(sender, recipient, tTransferAmount);
638     }
639 
640     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
641         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
642         _rOwned[sender] = _rOwned[sender].sub(rAmount);
643         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
644         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
645         _reflectFee(rFee, tFee);
646         emit Transfer(sender, recipient, tTransferAmount);
647     }
648 
649     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
650         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
651         _tOwned[sender] = _tOwned[sender].sub(tAmount);
652         _rOwned[sender] = _rOwned[sender].sub(rAmount);
653         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
654         _reflectFee(rFee, tFee);
655         emit Transfer(sender, recipient, tTransferAmount);
656     }
657 
658     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
659         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
660         _tOwned[sender] = _tOwned[sender].sub(tAmount);
661         _rOwned[sender] = _rOwned[sender].sub(rAmount);
662         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
663         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
664         _reflectFee(rFee, tFee);
665         emit Transfer(sender, recipient, tTransferAmount);
666     }
667 
668     function _reflectFee(uint256 rFee, uint256 tFee) private {
669         _rTotal = _rTotal.sub(rFee);
670         _tFeeTotal = _tFeeTotal.add(tFee);
671     }
672 
673     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
674         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
675         uint256 currentRate =  _getRate();
676         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
677         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
678     }
679 
680     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
681         uint256 tFee = tAmount.div(100);
682         uint256 tTransferAmount = tAmount.sub(tFee);
683         return (tTransferAmount, tFee);
684     }
685 
686     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
687         uint256 rAmount = tAmount.mul(currentRate);
688         uint256 rFee = tFee.mul(currentRate);
689         uint256 rTransferAmount = rAmount.sub(rFee);
690         return (rAmount, rTransferAmount, rFee);
691     }
692 
693     function _getRate() private view returns(uint256) {
694         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
695         return rSupply.div(tSupply);
696     }
697 
698     function _getCurrentSupply() private view returns(uint256, uint256) {
699         uint256 rSupply = _rTotal;
700         uint256 tSupply = _tTotal;      
701         for (uint256 i = 0; i < _excluded.length; i++) {
702             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
703             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
704             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
705         }
706         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
707         return (rSupply, tSupply);
708     }
709 }