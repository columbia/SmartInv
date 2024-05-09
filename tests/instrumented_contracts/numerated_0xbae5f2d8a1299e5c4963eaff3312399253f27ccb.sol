1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.2;
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
26 /**
27  * @dev Interface of the ERC20 standard as defined in the EIP.
28  */
29 interface IERC20 {
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address recipient, uint256 amount) external returns (bool);
48 
49     /**
50      * @dev Returns the remaining number of tokens that `spender` will be
51      * allowed to spend on behalf of `owner` through {transferFrom}. This is
52      * zero by default.
53      *
54      * This value changes when {approve} or {transferFrom} are called.
55      */
56     function allowance(address owner, address spender) external view returns (uint256);
57 
58     /**
59      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * IMPORTANT: Beware that changing an allowance with this method brings the risk
64      * that someone may use both the old and the new allowance by unfortunate
65      * transaction ordering. One possible solution to mitigate this race
66      * condition is to first reduce the spender's allowance to 0 and set the
67      * desired value afterwards:
68      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
69      *
70      * Emits an {Approval} event.
71      */
72     function approve(address spender, uint256 amount) external returns (bool);
73 
74     /**
75      * @dev Moves `amount` tokens from `sender` to `recipient` using the
76      * allowance mechanism. `amount` is then deducted from the caller's
77      * allowance.
78      *
79      * Returns a boolean value indicating whether the operation succeeded.
80      *
81      * Emits a {Transfer} event.
82      */
83     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
84 
85     /**
86      * @dev Emitted when `value` tokens are moved from one account (`from`) to
87      * another (`to`).
88      *
89      * Note that `value` may be zero.
90      */
91     event Transfer(address indexed from, address indexed to, uint256 value);
92 
93     /**
94      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
95      * a call to {approve}. `value` is the new allowance.
96      */
97     event Approval(address indexed owner, address indexed spender, uint256 value);
98 }
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
256 /**
257  * @dev Collection of functions related to the address type
258  */
259 library Address {
260     /**
261      * @dev Returns true if `account` is a contract.
262      *
263      * [IMPORTANT]
264      * ====
265      * It is unsafe to assume that an address for which this function returns
266      * false is an externally-owned account (EOA) and not a contract.
267      *
268      * Among others, `isContract` will return false for the following
269      * types of addresses:
270      *
271      *  - an externally-owned account
272      *  - a contract in construction
273      *  - an address where a contract will be created
274      *  - an address where a contract lived, but was destroyed
275      * ====
276      */
277     function isContract(address account) internal view returns (bool) {
278         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
279         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
280         // for accounts without code, i.e. `keccak256('')`
281         bytes32 codehash;
282         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
283         // solhint-disable-next-line no-inline-assembly
284         assembly { codehash := extcodehash(account) }
285         return (codehash != accountHash && codehash != 0x0);
286     }
287 
288     /**
289      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
290      * `recipient`, forwarding all available gas and reverting on errors.
291      *
292      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
293      * of certain opcodes, possibly making contracts go over the 2300 gas limit
294      * imposed by `transfer`, making them unable to receive funds via
295      * `transfer`. {sendValue} removes this limitation.
296      *
297      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
298      *
299      * IMPORTANT: because control is transferred to `recipient`, care must be
300      * taken to not create reentrancy vulnerabilities. Consider using
301      * {ReentrancyGuard} or the
302      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
303      */
304     function sendValue(address payable recipient, uint256 amount) internal {
305         require(address(this).balance >= amount, "Address: insufficient balance");
306 
307         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
308         (bool success, ) = recipient.call{ value: amount }("");
309         require(success, "Address: unable to send value, recipient may have reverted");
310     }
311 
312     /**
313      * @dev Performs a Solidity function call using a low level `call`. A
314      * plain`call` is an unsafe replacement for a function call: use this
315      * function instead.
316      *
317      * If `target` reverts with a revert reason, it is bubbled up by this
318      * function (like regular Solidity function calls).
319      *
320      * Returns the raw returned data. To convert to the expected return value,
321      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
322      *
323      * Requirements:
324      *
325      * - `target` must be a contract.
326      * - calling `target` with `data` must not revert.
327      *
328      * _Available since v3.1._
329      */
330     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
331       return functionCall(target, data, "Address: low-level call failed");
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
336      * `errorMessage` as a fallback revert reason when `target` reverts.
337      *
338      * _Available since v3.1._
339      */
340     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
341         return _functionCallWithValue(target, data, 0, errorMessage);
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
346      * but also transferring `value` wei to `target`.
347      *
348      * Requirements:
349      *
350      * - the calling contract must have an ETH balance of at least `value`.
351      * - the called Solidity function must be `payable`.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
356         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
361      * with `errorMessage` as a fallback revert reason when `target` reverts.
362      *
363      * _Available since v3.1._
364      */
365     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
366         require(address(this).balance >= value, "Address: insufficient balance for call");
367         return _functionCallWithValue(target, data, value, errorMessage);
368     }
369 
370     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
371         require(isContract(target), "Address: call to non-contract");
372 
373         // solhint-disable-next-line avoid-low-level-calls
374         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
375         if (success) {
376             return returndata;
377         } else {
378             // Look for revert reason and bubble it up if present
379             if (returndata.length > 0) {
380                 // The easiest way to bubble the revert reason is using memory via assembly
381 
382                 // solhint-disable-next-line no-inline-assembly
383                 assembly {
384                     let returndata_size := mload(returndata)
385                     revert(add(32, returndata), returndata_size)
386                 }
387             } else {
388                 revert(errorMessage);
389             }
390         }
391     }
392 }
393 
394 /**
395  * @dev Contract module which provides a basic access control mechanism, where
396  * there is an account (an owner) that can be granted exclusive access to
397  * specific functions.
398  *
399  * By default, the owner account will be the one that deploys the contract. This
400  * can later be changed with {transferOwnership}.
401  *
402  * This module is used through inheritance. It will make available the modifier
403  * `onlyOwner`, which can be applied to your functions to restrict their use to
404  * the owner.
405  */
406 contract Ownable is Context {
407     address private _owner;
408 
409     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
410 
411     /**
412      * @dev Initializes the contract setting the deployer as the initial owner.
413      */
414     constructor () internal {
415         address msgSender = _msgSender();
416         _owner = msgSender;
417         emit OwnershipTransferred(address(0), msgSender);
418     }
419 
420     /**
421      * @dev Returns the address of the current owner.
422      */
423     function owner() public view returns (address) {
424         return _owner;
425     }
426 
427     /**
428      * @dev Throws if called by any account other than the owner.
429      */
430     modifier onlyOwner() {
431         require(_owner == _msgSender(), "Ownable: caller is not the owner");
432         _;
433     }
434 
435     /**
436      * @dev Leaves the contract without owner. It will not be possible to call
437      * `onlyOwner` functions anymore. Can only be called by the current owner.
438      *
439      * NOTE: Renouncing ownership will leave the contract without an owner,
440      * thereby removing any functionality that is only available to the owner.
441      */
442     function renounceOwnership() public virtual onlyOwner {
443         emit OwnershipTransferred(_owner, address(0));
444         _owner = address(0);
445     }
446 
447     /**
448      * @dev Transfers ownership of the contract to a new account (`newOwner`).
449      * Can only be called by the current owner.
450      */
451     function transferOwnership(address newOwner) public virtual onlyOwner {
452         require(newOwner != address(0), "Ownable: new owner is the zero address");
453         emit OwnershipTransferred(_owner, newOwner);
454         _owner = newOwner;
455     }
456 }
457 
458 contract SOAR is Context, IERC20, Ownable { 
459     using SafeMath for uint256;
460     using Address for address;
461 
462     mapping (address => uint256) private _rOwned;
463     mapping (address => uint256) private _tOwned;
464     mapping (address => mapping (address => uint256)) private _allowances;
465 
466     mapping (address => bool) private _isExcluded;
467     address[] private _excluded;
468    
469     uint256 private constant MAX = ~uint256(0);
470     uint256 private constant _tTotal = 10 * 10**6 * 10**9;  
471     
472     uint256 private _rTotal = (MAX - (MAX % _tTotal));
473     uint256 private _tFeeTotal;
474 
475     string private _name = 'SOAR.FI'; 
476     string private _symbol = 'SOAR'; 
477     uint8 private _decimals = 9; 
478     
479     uint256 private startTime;
480 
481     constructor () public {
482         _rOwned[_msgSender()] = _rTotal;
483         emit Transfer(address(0), _msgSender(), _tTotal);
484         startTime = now + (60 * 60); //60 Minutes Delay to Launch Time Function since Contract Deployment
485     }
486 
487     function name() public view returns (string memory) {
488         return _name;
489     }
490 
491     function symbol() public view returns (string memory) {
492         return _symbol;
493     }
494 
495     function decimals() public view returns (uint8) {
496         return _decimals;
497     }
498 
499     function totalSupply() public view override returns (uint256) {
500         return _tTotal;
501     }
502 
503     function balanceOf(address account) public view override returns (uint256) {
504         if (_isExcluded[account]) return _tOwned[account];
505         return tokenFromReflection(_rOwned[account]);
506     }
507 
508     function transfer(address recipient, uint256 amount) public override returns (bool) {
509         _transfer(_msgSender(), recipient, amount);
510         return true;
511     }
512 
513     function allowance(address owner, address spender) public view override returns (uint256) {
514         return _allowances[owner][spender];
515     }
516 
517     function approve(address spender, uint256 amount) public override returns (bool) {
518         _approve(_msgSender(), spender, amount);
519         return true;
520     }
521 
522     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
523         _transfer(sender, recipient, amount);
524         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
525         return true;
526     }
527 
528     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
529         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
530         return true;
531     }
532 
533     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
534         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
535         return true;
536     }
537 
538     function isExcluded(address account) public view returns (bool) {
539         return _isExcluded[account];
540     }
541 
542     function totalFees() public view returns (uint256) {
543         return _tFeeTotal;
544     }
545 
546     function reflect(uint256 tAmount) public {
547         address sender = _msgSender();
548         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
549         (uint256 rAmount,,,,) = _getValues(tAmount);
550         _rOwned[sender] = _rOwned[sender].sub(rAmount);
551         _rTotal = _rTotal.sub(rAmount);
552         _tFeeTotal = _tFeeTotal.add(tAmount);
553     }
554 
555     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
556         require(tAmount <= _tTotal, "Amount must be less than supply");
557         if (!deductTransferFee) {
558             (uint256 rAmount,,,,) = _getValues(tAmount);
559             return rAmount;
560         } else {
561             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
562             return rTransferAmount;
563         }
564     }
565 
566     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
567         require(rAmount <= _rTotal, "Amount must be less than total reflections");
568         uint256 currentRate =  _getRate();
569         return rAmount.div(currentRate);
570     }
571 
572     function excludeAccount(address account) external onlyOwner() {
573         require(!_isExcluded[account], "Account is already excluded");
574         if(_rOwned[account] > 0) {
575             _tOwned[account] = tokenFromReflection(_rOwned[account]);
576         }
577         _isExcluded[account] = true;
578         _excluded.push(account);
579     }
580 
581     function includeAccount(address account) external onlyOwner() {
582         require(_isExcluded[account], "Account is already excluded");
583         for (uint256 i = 0; i < _excluded.length; i++) {
584             if (_excluded[i] == account) {
585                 _excluded[i] = _excluded[_excluded.length - 1];
586                 _tOwned[account] = 0;
587                 _isExcluded[account] = false;
588                 _excluded.pop();
589                 break;
590             }
591         }
592     }
593 
594     function _approve(address owner, address spender, uint256 amount) private {
595         require(owner != address(0), "ERC20: approve from the zero address");
596         require(spender != address(0), "ERC20: approve to the zero address");
597 
598         _allowances[owner][spender] = amount;
599         emit Approval(owner, spender, amount);
600     }
601 
602     function _transfer(address sender, address recipient, uint256 amount) private {
603         require(sender != address(0), "ERC20: transfer from the zero address");
604         require(recipient != address(0), "ERC20: transfer to the zero address");
605         require(amount > 0, "Transfer amount must be greater than zero");
606         
607         uint256 relaseTime1 = startTime + (120 * 60); //120 minutes
608         uint256 xLimit1 = 50000 * 10**9; 
609     
610         uint256 relaseTime2 = startTime + (240 * 60); //240 minutes
611         uint256 xLimit2 = 100000 * 10**9; 
612     
613         uint256 relaseTime3 = startTime + (360 * 60); //360 minutes
614         uint256 xLimit3 = 150000 * 10**9; 
615         
616         if (now < startTime) {
617                 if (_isExcluded[sender] && !_isExcluded[recipient]) {
618                     _transferFromExcluded(sender, recipient, amount);
619                 } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
620                     _transferToExcluded(sender, recipient, amount);
621                 } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
622                     _transferStandard(sender, recipient, amount);
623                 } else if (_isExcluded[sender] && _isExcluded[recipient]) {
624                     _transferBothExcluded(sender, recipient, amount);
625                 } else {
626                     _transferStandard(sender, recipient, amount);
627                 }
628         } else if (now >= startTime && now <= relaseTime1) {
629             if (amount <= xLimit1) {
630                 if (_isExcluded[sender] && !_isExcluded[recipient]) {
631                     _transferFromExcluded(sender, recipient, amount);
632                 } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
633                     _transferToExcluded(sender, recipient, amount);
634                 } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
635                     _transferStandard(sender, recipient, amount);
636                 } else if (_isExcluded[sender] && _isExcluded[recipient]) {
637                     _transferBothExcluded(sender, recipient, amount);
638                 } else {
639                     _transferStandard(sender, recipient, amount);
640                 }
641             } else {
642                 revert("ERC20: cannot transfer more than 50,000 tokens in first 120 minutes");
643             }
644         } else if (now > relaseTime1 && now <= relaseTime2) {
645             if (amount <= xLimit2) {
646                 if (_isExcluded[sender] && !_isExcluded[recipient]) {
647                     _transferFromExcluded(sender, recipient, amount);
648                 } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
649                     _transferToExcluded(sender, recipient, amount);
650                 } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
651                     _transferStandard(sender, recipient, amount);
652                 } else if (_isExcluded[sender] && _isExcluded[recipient]) {
653                     _transferBothExcluded(sender, recipient, amount);
654                 } else {
655                     _transferStandard(sender, recipient, amount);
656                 }
657             } else {
658                 revert("ERC20: cannot transfer more than 100,000 tokens in first 240 minutes");
659             }
660         } else if (now > relaseTime2 && now <= relaseTime3) {
661             if (amount <= xLimit3) {
662                 if (_isExcluded[sender] && !_isExcluded[recipient]) {
663                     _transferFromExcluded(sender, recipient, amount);
664                 } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
665                     _transferToExcluded(sender, recipient, amount);
666                 } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
667                     _transferStandard(sender, recipient, amount);
668                 } else if (_isExcluded[sender] && _isExcluded[recipient]) {
669                     _transferBothExcluded(sender, recipient, amount);
670                 } else {
671                     _transferStandard(sender, recipient, amount);
672                 }
673             } else {
674                 revert("ERC20: cannot transfer more than 150,000 tokens in first 360 minutes");
675             }
676         } else if (now > relaseTime3) {
677             if (_isExcluded[sender] && !_isExcluded[recipient]) {
678                 _transferFromExcluded(sender, recipient, amount);
679             } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
680                 _transferToExcluded(sender, recipient, amount);
681             } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
682                 _transferStandard(sender, recipient, amount);
683             } else if (_isExcluded[sender] && _isExcluded[recipient]) {
684                 _transferBothExcluded(sender, recipient, amount);
685             } else {
686                 _transferStandard(sender, recipient, amount);
687             }
688         }
689     }
690 
691     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
692         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
693         _rOwned[sender] = _rOwned[sender].sub(rAmount);
694         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
695         _reflectFee(rFee, tFee);
696         emit Transfer(sender, recipient, tTransferAmount);
697     }
698 
699     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
700         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
701         _rOwned[sender] = _rOwned[sender].sub(rAmount);
702         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
703         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
704         _reflectFee(rFee, tFee);
705         emit Transfer(sender, recipient, tTransferAmount);
706     }
707 
708     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
709         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
710         _tOwned[sender] = _tOwned[sender].sub(tAmount);
711         _rOwned[sender] = _rOwned[sender].sub(rAmount);
712         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
713         _reflectFee(rFee, tFee);
714         emit Transfer(sender, recipient, tTransferAmount);
715     }
716 
717     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
718         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
719         _tOwned[sender] = _tOwned[sender].sub(tAmount);
720         _rOwned[sender] = _rOwned[sender].sub(rAmount);
721         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
722         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
723         _reflectFee(rFee, tFee);
724         emit Transfer(sender, recipient, tTransferAmount);
725     }
726 
727     function _reflectFee(uint256 rFee, uint256 tFee) private {
728         _rTotal = _rTotal.sub(rFee);
729         _tFeeTotal = _tFeeTotal.add(tFee);
730     }
731 
732     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
733         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
734         uint256 currentRate =  _getRate();
735         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
736         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
737     }
738 
739     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
740         uint256 tFee = tAmount.div(100);
741         uint256 tTransferAmount = tAmount.sub(tFee);
742         return (tTransferAmount, tFee);
743     }
744 
745     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
746         uint256 rAmount = tAmount.mul(currentRate);
747         uint256 rFee = tFee.mul(currentRate);
748         uint256 rTransferAmount = rAmount.sub(rFee);
749         return (rAmount, rTransferAmount, rFee);
750     }
751 
752     function _getRate() private view returns(uint256) {
753         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
754         return rSupply.div(tSupply);
755     }
756 
757     function _getCurrentSupply() private view returns(uint256, uint256) {
758         uint256 rSupply = _rTotal;
759         uint256 tSupply = _tTotal;      
760         for (uint256 i = 0; i < _excluded.length; i++) {
761             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
762             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
763             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
764         }
765         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
766         return (rSupply, tSupply);
767     }
768 }