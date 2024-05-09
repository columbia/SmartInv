1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 
27 
28 
29 /**
30  * @dev Interface of the ERC20 standard as defined in the EIP.
31  */
32 interface IERC20 {
33     /**
34      * @dev Returns the amount of tokens in existence.
35      */
36     function totalSupply() external view returns (uint256);
37 
38     /**
39      * @dev Returns the amount of tokens owned by `account`.
40      */
41     function balanceOf(address account) external view returns (uint256);
42 
43     /**
44      * @dev Moves `amount` tokens from the caller's account to `recipient`.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * Emits a {Transfer} event.
49      */
50     function transfer(address recipient, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Returns the remaining number of tokens that `spender` will be
54      * allowed to spend on behalf of `owner` through {transferFrom}. This is
55      * zero by default.
56      *
57      * This value changes when {approve} or {transferFrom} are called.
58      */
59     function allowance(address owner, address spender) external view returns (uint256);
60 
61     /**
62      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * IMPORTANT: Beware that changing an allowance with this method brings the risk
67      * that someone may use both the old and the new allowance by unfortunate
68      * transaction ordering. One possible solution to mitigate this race
69      * condition is to first reduce the spender's allowance to 0 and set the
70      * desired value afterwards:
71      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
72      *
73      * Emits an {Approval} event.
74      */
75     function approve(address spender, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Moves `amount` tokens from `sender` to `recipient` using the
79      * allowance mechanism. `amount` is then deducted from the caller's
80      * allowance.
81      *
82      * Returns a boolean value indicating whether the operation succeeded.
83      *
84      * Emits a {Transfer} event.
85      */
86     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Emitted when `value` tokens are moved from one account (`from`) to
90      * another (`to`).
91      *
92      * Note that `value` may be zero.
93      */
94     event Transfer(address indexed from, address indexed to, uint256 value);
95 
96     /**
97      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
98      * a call to {approve}. `value` is the new allowance.
99      */
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 
104 
105 /**
106  * @dev Wrappers over Solidity's arithmetic operations with added overflow
107  * checks.
108  *
109  * Arithmetic operations in Solidity wrap on overflow. This can easily result
110  * in bugs, because programmers usually assume that an overflow raises an
111  * error, which is the standard behavior in high level programming languages.
112  * `SafeMath` restores this intuition by reverting the transaction when an
113  * operation overflows.
114  *
115  * Using this library instead of the unchecked operations eliminates an entire
116  * class of bugs, so it's recommended to use it always.
117  */
118 library SafeMath {
119     /**
120      * @dev Returns the addition of two unsigned integers, reverting on
121      * overflow.
122      *
123      * Counterpart to Solidity's `+` operator.
124      *
125      * Requirements:
126      *
127      * - Addition cannot overflow.
128      */
129     function add(uint256 a, uint256 b) internal pure returns (uint256) {
130         uint256 c = a + b;
131         require(c >= a, "SafeMath: addition overflow");
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the subtraction of two unsigned integers, reverting on
138      * overflow (when the result is negative).
139      *
140      * Counterpart to Solidity's `-` operator.
141      *
142      * Requirements:
143      *
144      * - Subtraction cannot overflow.
145      */
146     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147         return sub(a, b, "SafeMath: subtraction overflow");
148     }
149 
150     /**
151      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
152      * overflow (when the result is negative).
153      *
154      * Counterpart to Solidity's `-` operator.
155      *
156      * Requirements:
157      *
158      * - Subtraction cannot overflow.
159      */
160     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
161         require(b <= a, errorMessage);
162         uint256 c = a - b;
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the multiplication of two unsigned integers, reverting on
169      * overflow.
170      *
171      * Counterpart to Solidity's `*` operator.
172      *
173      * Requirements:
174      *
175      * - Multiplication cannot overflow.
176      */
177     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
178         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
179         // benefit is lost if 'b' is also tested.
180         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
181         if (a == 0) {
182             return 0;
183         }
184 
185         uint256 c = a * b;
186         require(c / a == b, "SafeMath: multiplication overflow");
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers. Reverts on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's `/` operator. Note: this function uses a
196      * `revert` opcode (which leaves remaining gas untouched) while Solidity
197      * uses an invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function div(uint256 a, uint256 b) internal pure returns (uint256) {
204         return div(a, b, "SafeMath: division by zero");
205     }
206 
207     /**
208      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
209      * division by zero. The result is rounded towards zero.
210      *
211      * Counterpart to Solidity's `/` operator. Note: this function uses a
212      * `revert` opcode (which leaves remaining gas untouched) while Solidity
213      * uses an invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
220         require(b > 0, errorMessage);
221         uint256 c = a / b;
222         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
223 
224         return c;
225     }
226 
227     /**
228      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
229      * Reverts when dividing by zero.
230      *
231      * Counterpart to Solidity's `%` operator. This function uses a `revert`
232      * opcode (which leaves remaining gas untouched) while Solidity uses an
233      * invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      *
237      * - The divisor cannot be zero.
238      */
239     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
240         return mod(a, b, "SafeMath: modulo by zero");
241     }
242 
243     /**
244      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
245      * Reverts with custom message when dividing by zero.
246      *
247      * Counterpart to Solidity's `%` operator. This function uses a `revert`
248      * opcode (which leaves remaining gas untouched) while Solidity uses an
249      * invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      *
253      * - The divisor cannot be zero.
254      */
255     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
256         require(b != 0, errorMessage);
257         return a % b;
258     }
259 }
260 
261 /**
262  * @dev Collection of functions related to the address type
263  */
264 library Address {
265     /**
266      * @dev Returns true if `account` is a contract.
267      *
268      * [IMPORTANT]
269      * ====
270      * It is unsafe to assume that an address for which this function returns
271      * false is an externally-owned account (EOA) and not a contract.
272      *
273      * Among others, `isContract` will return false for the following
274      * types of addresses:
275      *
276      *  - an externally-owned account
277      *  - a contract in construction
278      *  - an address where a contract will be created
279      *  - an address where a contract lived, but was destroyed
280      * ====
281      */
282     function isContract(address account) internal view returns (bool) {
283         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
284         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
285         // for accounts without code, i.e. `keccak256('')`
286         bytes32 codehash;
287         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
288         // solhint-disable-next-line no-inline-assembly
289         assembly { codehash := extcodehash(account) }
290         return (codehash != accountHash && codehash != 0x0);
291     }
292 
293     /**
294      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
295      * `recipient`, forwarding all available gas and reverting on errors.
296      *
297      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
298      * of certain opcodes, possibly making contracts go over the 2300 gas limit
299      * imposed by `transfer`, making them unable to receive funds via
300      * `transfer`. {sendValue} removes this limitation.
301      *
302      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
303      *
304      * IMPORTANT: because control is transferred to `recipient`, care must be
305      * taken to not create reentrancy vulnerabilities. Consider using
306      * {ReentrancyGuard} or the
307      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
308      */
309     function sendValue(address payable recipient, uint256 amount) internal {
310         require(address(this).balance >= amount, "Address: insufficient balance");
311 
312         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
313         (bool success, ) = recipient.call{ value: amount }("");
314         require(success, "Address: unable to send value, recipient may have reverted");
315     }
316 
317     /**
318      * @dev Performs a Solidity function call using a low level `call`. A
319      * plain`call` is an unsafe replacement for a function call: use this
320      * function instead.
321      *
322      * If `target` reverts with a revert reason, it is bubbled up by this
323      * function (like regular Solidity function calls).
324      *
325      * Returns the raw returned data. To convert to the expected return value,
326      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
327      *
328      * Requirements:
329      *
330      * - `target` must be a contract.
331      * - calling `target` with `data` must not revert.
332      *
333      * _Available since v3.1._
334      */
335     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
336       return functionCall(target, data, "Address: low-level call failed");
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
341      * `errorMessage` as a fallback revert reason when `target` reverts.
342      *
343      * _Available since v3.1._
344      */
345     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
346         return _functionCallWithValue(target, data, 0, errorMessage);
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
351      * but also transferring `value` wei to `target`.
352      *
353      * Requirements:
354      *
355      * - the calling contract must have an ETH balance of at least `value`.
356      * - the called Solidity function must be `payable`.
357      *
358      * _Available since v3.1._
359      */
360     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
361         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
366      * with `errorMessage` as a fallback revert reason when `target` reverts.
367      *
368      * _Available since v3.1._
369      */
370     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
371         require(address(this).balance >= value, "Address: insufficient balance for call");
372         return _functionCallWithValue(target, data, value, errorMessage);
373     }
374 
375     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
376         require(isContract(target), "Address: call to non-contract");
377 
378         // solhint-disable-next-line avoid-low-level-calls
379         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
380         if (success) {
381             return returndata;
382         } else {
383             // Look for revert reason and bubble it up if present
384             if (returndata.length > 0) {
385                 // The easiest way to bubble the revert reason is using memory via assembly
386 
387                 // solhint-disable-next-line no-inline-assembly
388                 assembly {
389                     let returndata_size := mload(returndata)
390                     revert(add(32, returndata), returndata_size)
391                 }
392             } else {
393                 revert(errorMessage);
394             }
395         }
396     }
397 }
398 
399 /**
400  * @dev Contract module which provides a basic access control mechanism, where
401  * there is an account (an owner) that can be granted exclusive access to
402  * specific functions.
403  *
404  * By default, the owner account will be the one that deploys the contract. This
405  * can later be changed with {transferOwnership}.
406  *
407  * This module is used through inheritance. It will make available the modifier
408  * `onlyOwner`, which can be applied to your functions to restrict their use to
409  * the owner.
410  */
411 contract Ownable is Context {
412     address private _owner;
413 
414     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
415 
416     /**
417      * @dev Initializes the contract setting the deployer as the initial owner.
418      */
419     constructor () internal {
420         address msgSender = _msgSender();
421         _owner = msgSender;
422         emit OwnershipTransferred(address(0), msgSender);
423     }
424 
425     /**
426      * @dev Returns the address of the current owner.
427      */
428     function owner() public view returns (address) {
429         return _owner;
430     }
431 
432     /**
433      * @dev Throws if called by any account other than the owner.
434      */
435     modifier onlyOwner() {
436         require(_owner == _msgSender(), "Ownable: caller is not the owner");
437         _;
438     }
439 
440     /**
441      * @dev Leaves the contract without owner. It will not be possible to call
442      * `onlyOwner` functions anymore. Can only be called by the current owner.
443      *
444      * NOTE: Renouncing ownership will leave the contract without an owner,
445      * thereby removing any functionality that is only available to the owner.
446      */
447     function renounceOwnership() public virtual onlyOwner {
448         emit OwnershipTransferred(_owner, address(0));
449         _owner = address(0);
450     }
451 
452     /**
453      * @dev Transfers ownership of the contract to a new account (`newOwner`).
454      * Can only be called by the current owner.
455      */
456     function transferOwnership(address newOwner) public virtual onlyOwner {
457         require(newOwner != address(0), "Ownable: new owner is the zero address");
458         emit OwnershipTransferred(_owner, newOwner);
459         _owner = newOwner;
460     }
461 }
462 
463 
464 contract GOAT is Context, IERC20, Ownable {
465     using SafeMath for uint256;
466     using Address for address;
467 
468     mapping (address => uint256) private _rOwned;
469     mapping (address => uint256) private _tOwned;
470     mapping (address => mapping (address => uint256)) private _allowances;
471 
472     mapping (address => bool) private _isExcluded;
473     address[] private _excluded;
474    
475     uint256 private constant MAX = ~uint256(0);
476     uint256 private constant _tTotal = 100 * 10**6 * 10**9;
477     uint256 private _rTotal = (MAX - (MAX % _tTotal));
478     uint256 private _tFeeTotal;
479 
480     string private _name = 'GOAT Coin';
481     string private _symbol = 'GOAT';
482     uint8 private _decimals = 9;
483 
484     constructor () public {
485         _rOwned[_msgSender()] = _rTotal;
486         emit Transfer(address(0), _msgSender(), _tTotal);
487     }
488 
489     function name() public view returns (string memory) {
490         return _name;
491     }
492 
493     function symbol() public view returns (string memory) {
494         return _symbol;
495     }
496 
497     function decimals() public view returns (uint8) {
498         return _decimals;
499     }
500 
501     function totalSupply() public view override returns (uint256) {
502         return _tTotal;
503     }
504 
505     function balanceOf(address account) public view override returns (uint256) {
506         if (_isExcluded[account]) return _tOwned[account];
507         return tokenFromReflection(_rOwned[account]);
508     }
509 
510     function transfer(address recipient, uint256 amount) public override returns (bool) {
511         _transfer(_msgSender(), recipient, amount);
512         return true;
513     }
514 
515     function allowance(address owner, address spender) public view override returns (uint256) {
516         return _allowances[owner][spender];
517     }
518 
519     function approve(address spender, uint256 amount) public override returns (bool) {
520         _approve(_msgSender(), spender, amount);
521         return true;
522     }
523 
524     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
525         _transfer(sender, recipient, amount);
526         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
527         return true;
528     }
529 
530     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
531         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
532         return true;
533     }
534 
535     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
536         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
537         return true;
538     }
539 
540     function isExcluded(address account) public view returns (bool) {
541         return _isExcluded[account];
542     }
543 
544     function totalFees() public view returns (uint256) {
545         return _tFeeTotal;
546     }
547 
548     function reflect(uint256 tAmount) public {
549         address sender = _msgSender();
550         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
551         (uint256 rAmount,,,,) = _getValues(tAmount);
552         _rOwned[sender] = _rOwned[sender].sub(rAmount);
553         _rTotal = _rTotal.sub(rAmount);
554         _tFeeTotal = _tFeeTotal.add(tAmount);
555     }
556 
557     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
558         require(tAmount <= _tTotal, "Amount must be less than supply");
559         if (!deductTransferFee) {
560             (uint256 rAmount,,,,) = _getValues(tAmount);
561             return rAmount;
562         } else {
563             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
564             return rTransferAmount;
565         }
566     }
567 
568     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
569         require(rAmount <= _rTotal, "Amount must be less than total reflections");
570         uint256 currentRate =  _getRate();
571         return rAmount.div(currentRate);
572     }
573 
574     function excludeAccount(address account) external onlyOwner() {
575         require(!_isExcluded[account], "Account is already excluded");
576         if(_rOwned[account] > 0) {
577             _tOwned[account] = tokenFromReflection(_rOwned[account]);
578         }
579         _isExcluded[account] = true;
580         _excluded.push(account);
581     }
582 
583     function includeAccount(address account) external onlyOwner() {
584         require(_isExcluded[account], "Account is already excluded");
585         for (uint256 i = 0; i < _excluded.length; i++) {
586             if (_excluded[i] == account) {
587                 _excluded[i] = _excluded[_excluded.length - 1];
588                 _tOwned[account] = 0;
589                 _isExcluded[account] = false;
590                 _excluded.pop();
591                 break;
592             }
593         }
594     }
595 
596     function _approve(address owner, address spender, uint256 amount) private {
597         require(owner != address(0), "ERC20: approve from the zero address");
598         require(spender != address(0), "ERC20: approve to the zero address");
599 
600         _allowances[owner][spender] = amount;
601         emit Approval(owner, spender, amount);
602     }
603 
604     function _transfer(address sender, address recipient, uint256 amount) private {
605         require(sender != address(0), "ERC20: transfer from the zero address");
606         require(recipient != address(0), "ERC20: transfer to the zero address");
607         require(amount > 0, "Transfer amount must be greater than zero");
608         if (_isExcluded[sender] && !_isExcluded[recipient]) {
609             _transferFromExcluded(sender, recipient, amount);
610         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
611             _transferToExcluded(sender, recipient, amount);
612         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
613             _transferStandard(sender, recipient, amount);
614         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
615             _transferBothExcluded(sender, recipient, amount);
616         } else {
617             _transferStandard(sender, recipient, amount);
618         }
619     }
620 
621     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
622         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
623         _rOwned[sender] = _rOwned[sender].sub(rAmount);
624         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
625         _reflectFee(rFee, tFee);
626         emit Transfer(sender, recipient, tTransferAmount);
627     }
628 
629     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
630         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
631         _rOwned[sender] = _rOwned[sender].sub(rAmount);
632         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
633         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
634         _reflectFee(rFee, tFee);
635         emit Transfer(sender, recipient, tTransferAmount);
636     }
637 
638     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
639         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
640         _tOwned[sender] = _tOwned[sender].sub(tAmount);
641         _rOwned[sender] = _rOwned[sender].sub(rAmount);
642         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
643         _reflectFee(rFee, tFee);
644         emit Transfer(sender, recipient, tTransferAmount);
645     }
646 
647     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
648         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
649         _tOwned[sender] = _tOwned[sender].sub(tAmount);
650         _rOwned[sender] = _rOwned[sender].sub(rAmount);
651         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
652         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
653         _reflectFee(rFee, tFee);
654         emit Transfer(sender, recipient, tTransferAmount);
655     }
656 
657     function _reflectFee(uint256 rFee, uint256 tFee) private {
658         _rTotal = _rTotal.sub(rFee);
659         _tFeeTotal = _tFeeTotal.add(tFee);
660     }
661 
662     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
663         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
664         uint256 currentRate =  _getRate();
665         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
666         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
667     }
668 
669     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
670         uint256 tFee = (tAmount.mul(2)).div(100);
671         uint256 tTransferAmount = tAmount.sub(tFee);
672         return (tTransferAmount, tFee);
673     }
674 
675     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
676         uint256 rAmount = tAmount.mul(currentRate);
677         uint256 rFee = tFee.mul(currentRate);
678         uint256 rTransferAmount = rAmount.sub(rFee);
679         return (rAmount, rTransferAmount, rFee);
680     }
681 
682     function _getRate() private view returns(uint256) {
683         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
684         return rSupply.div(tSupply);
685     }
686 
687     function _getCurrentSupply() private view returns(uint256, uint256) {
688         uint256 rSupply = _rTotal;
689         uint256 tSupply = _tTotal;      
690         for (uint256 i = 0; i < _excluded.length; i++) {
691             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
692             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
693             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
694         }
695         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
696         return (rSupply, tSupply);
697     }
698 }