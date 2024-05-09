1 /**
2  *Submitted for verification at Etherscan.io on 2020-11-21
3 */
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.6.0;
8 
9 /**
10     REAPER (R3P) is a soft fork of Reflect (RFI) that incorporates adjustable
11     yield rates (so early buyers can continue to earn reasonable yields as
12     more holders enter the ecosystem). REAPER (R3P) also has a deflationary supply 
13     and fair-launch mechanisms to ensure a healthy distribution of tokens.
14     
15     Website: https://reaper.finance
16     Telegram: https://t.me/reaperfinance
17     
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
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
107 
108 /**
109  * @dev Wrappers over Solidity's arithmetic operations with added overflow
110  * checks.
111  *
112  * Arithmetic operations in Solidity wrap on overflow. This can easily result
113  * in bugs, because programmers usually assume that an overflow raises an
114  * error, which is the standard behavior in high level programming languages.
115  * `SafeMath` restores this intuition by reverting the transaction when an
116  * operation overflows.
117  *
118  * Using this library instead of the unchecked operations eliminates an entire
119  * class of bugs, so it's recommended to use it always.
120  */
121 library SafeMath {
122     /**
123      * @dev Returns the addition of two unsigned integers, reverting on
124      * overflow.
125      *
126      * Counterpart to Solidity's `+` operator.
127      *
128      * Requirements:
129      *
130      * - Addition cannot overflow.
131      */
132     function add(uint256 a, uint256 b) internal pure returns (uint256) {
133         uint256 c = a + b;
134         require(c >= a, "SafeMath: addition overflow");
135 
136         return c;
137     }
138 
139     /**
140      * @dev Returns the subtraction of two unsigned integers, reverting on
141      * overflow (when the result is negative).
142      *
143      * Counterpart to Solidity's `-` operator.
144      *
145      * Requirements:
146      *
147      * - Subtraction cannot overflow.
148      */
149     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
150         return sub(a, b, "SafeMath: subtraction overflow");
151     }
152 
153     /**
154      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
155      * overflow (when the result is negative).
156      *
157      * Counterpart to Solidity's `-` operator.
158      *
159      * Requirements:
160      *
161      * - Subtraction cannot overflow.
162      */
163     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
164         require(b <= a, errorMessage);
165         uint256 c = a - b;
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the multiplication of two unsigned integers, reverting on
172      * overflow.
173      *
174      * Counterpart to Solidity's `*` operator.
175      *
176      * Requirements:
177      *
178      * - Multiplication cannot overflow.
179      */
180     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
181         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
182         // benefit is lost if 'b' is also tested.
183         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
184         if (a == 0) {
185             return 0;
186         }
187 
188         uint256 c = a * b;
189         require(c / a == b, "SafeMath: multiplication overflow");
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the integer division of two unsigned integers. Reverts on
196      * division by zero. The result is rounded towards zero.
197      *
198      * Counterpart to Solidity's `/` operator. Note: this function uses a
199      * `revert` opcode (which leaves remaining gas untouched) while Solidity
200      * uses an invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function div(uint256 a, uint256 b) internal pure returns (uint256) {
207         return div(a, b, "SafeMath: division by zero");
208     }
209 
210     /**
211      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
212      * division by zero. The result is rounded towards zero.
213      *
214      * Counterpart to Solidity's `/` operator. Note: this function uses a
215      * `revert` opcode (which leaves remaining gas untouched) while Solidity
216      * uses an invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
223         require(b > 0, errorMessage);
224         uint256 c = a / b;
225         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
226 
227         return c;
228     }
229 
230     /**
231      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
232      * Reverts when dividing by zero.
233      *
234      * Counterpart to Solidity's `%` operator. This function uses a `revert`
235      * opcode (which leaves remaining gas untouched) while Solidity uses an
236      * invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      *
240      * - The divisor cannot be zero.
241      */
242     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
243         return mod(a, b, "SafeMath: modulo by zero");
244     }
245 
246     /**
247      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
248      * Reverts with custom message when dividing by zero.
249      *
250      * Counterpart to Solidity's `%` operator. This function uses a `revert`
251      * opcode (which leaves remaining gas untouched) while Solidity uses an
252      * invalid opcode to revert (consuming all remaining gas).
253      *
254      * Requirements:
255      *
256      * - The divisor cannot be zero.
257      */
258     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
259         require(b != 0, errorMessage);
260         return a % b;
261     }
262 }
263 
264 /**
265  * @dev Collection of functions related to the address type
266  */
267 library Address {
268     /**
269      * @dev Returns true if `account` is a contract.
270      *
271      * [IMPORTANT]
272      * ====
273      * It is unsafe to assume that an address for which this function returns
274      * false is an externally-owned account (EOA) and not a contract.
275      *
276      * Among others, `isContract` will return false for the following
277      * types of addresses:
278      *
279      *  - an externally-owned account
280      *  - a contract in construction
281      *  - an address where a contract will be created
282      *  - an address where a contract lived, but was destroyed
283      * ====
284      */
285     function isContract(address account) internal view returns (bool) {
286         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
287         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
288         // for accounts without code, i.e. `keccak256('')`
289         bytes32 codehash;
290         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
291         // solhint-disable-next-line no-inline-assembly
292         assembly { codehash := extcodehash(account) }
293         return (codehash != accountHash && codehash != 0x0);
294     }
295 
296     /**
297      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
298      * `recipient`, forwarding all available gas and reverting on errors.
299      *
300      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
301      * of certain opcodes, possibly making contracts go over the 2300 gas limit
302      * imposed by `transfer`, making them unable to receive funds via
303      * `transfer`. {sendValue} removes this limitation.
304      *
305      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
306      *
307      * IMPORTANT: because control is transferred to `recipient`, care must be
308      * taken to not create reentrancy vulnerabilities. Consider using
309      * {ReentrancyGuard} or the
310      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
311      */
312     function sendValue(address payable recipient, uint256 amount) internal {
313         require(address(this).balance >= amount, "Address: insufficient balance");
314 
315         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
316         (bool success, ) = recipient.call{ value: amount }("");
317         require(success, "Address: unable to send value, recipient may have reverted");
318     }
319 
320     /**
321      * @dev Performs a Solidity function call using a low level `call`. A
322      * plain`call` is an unsafe replacement for a function call: use this
323      * function instead.
324      *
325      * If `target` reverts with a revert reason, it is bubbled up by this
326      * function (like regular Solidity function calls).
327      *
328      * Returns the raw returned data. To convert to the expected return value,
329      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
330      *
331      * Requirements:
332      *
333      * - `target` must be a contract.
334      * - calling `target` with `data` must not revert.
335      *
336      * _Available since v3.1._
337      */
338     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
339       return functionCall(target, data, "Address: low-level call failed");
340     }
341 
342     /**
343      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
344      * `errorMessage` as a fallback revert reason when `target` reverts.
345      *
346      * _Available since v3.1._
347      */
348     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
349         return _functionCallWithValue(target, data, 0, errorMessage);
350     }
351 
352     /**
353      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
354      * but also transferring `value` wei to `target`.
355      *
356      * Requirements:
357      *
358      * - the calling contract must have an ETH balance of at least `value`.
359      * - the called Solidity function must be `payable`.
360      *
361      * _Available since v3.1._
362      */
363     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
364         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
365     }
366 
367     /**
368      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
369      * with `errorMessage` as a fallback revert reason when `target` reverts.
370      *
371      * _Available since v3.1._
372      */
373     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
374         require(address(this).balance >= value, "Address: insufficient balance for call");
375         return _functionCallWithValue(target, data, value, errorMessage);
376     }
377 
378     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
379         require(isContract(target), "Address: call to non-contract");
380 
381         // solhint-disable-next-line avoid-low-level-calls
382         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
383         if (success) {
384             return returndata;
385         } else {
386             // Look for revert reason and bubble it up if present
387             if (returndata.length > 0) {
388                 // The easiest way to bubble the revert reason is using memory via assembly
389 
390                 // solhint-disable-next-line no-inline-assembly
391                 assembly {
392                     let returndata_size := mload(returndata)
393                     revert(add(32, returndata), returndata_size)
394                 }
395             } else {
396                 revert(errorMessage);
397             }
398         }
399     }
400 }
401 
402 /**
403  * @dev Contract module which provides a basic access control mechanism, where
404  * there is an account (an owner) that can be granted exclusive access to
405  * specific functions.
406  *
407  * By default, the owner account will be the one that deploys the contract. This
408  * can later be changed with {transferOwnership}.
409  *
410  * This module is used through inheritance. It will make available the modifier
411  * `onlyOwner`, which can be applied to your functions to restrict their use to
412  * the owner.
413  */
414 contract Ownable is Context {
415     address private _owner;
416 
417     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
418 
419     /**
420      * @dev Initializes the contract setting the deployer as the initial owner.
421      */
422     constructor () internal {
423         address msgSender = _msgSender();
424         _owner = msgSender;
425         emit OwnershipTransferred(address(0), msgSender);
426     }
427 
428     /**
429      * @dev Returns the address of the current owner.
430      */
431     function owner() public view returns (address) {
432         return _owner;
433     }
434 
435     /**
436      * @dev Throws if called by any account other than the owner.
437      */
438     modifier onlyOwner() {
439         require(_owner == _msgSender(), "Ownable: caller is not the owner");
440         _;
441     }
442 
443     /**
444      * @dev Leaves the contract without owner. It will not be possible to call
445      * `onlyOwner` functions anymore. Can only be called by the current owner.
446      *
447      * NOTE: Renouncing ownership will leave the contract without an owner,
448      * thereby removing any functionality that is only available to the owner.
449      */
450     function renounceOwnership() public virtual onlyOwner {
451         emit OwnershipTransferred(_owner, address(0));
452         _owner = address(0);
453     }
454 
455     /**
456      * @dev Transfers ownership of the contract to a new account (`newOwner`).
457      * Can only be called by the current owner.
458      */
459     function transferOwnership(address newOwner) public virtual onlyOwner {
460         require(newOwner != address(0), "Ownable: new owner is the zero address");
461         emit OwnershipTransferred(_owner, newOwner);
462         _owner = newOwner;
463     }
464 }
465 
466 contract REAPER is Context, IERC20, Ownable {
467     using SafeMath for uint256;
468     using Address for address;
469 
470     mapping (address => uint256) private _rOwned;
471     mapping (address => uint256) private _tOwned;
472     mapping (address => mapping (address => uint256)) private _allowances;
473 
474     mapping (address => bool) private _isExcluded;
475     address[] private _excluded;
476    
477     uint256 private constant MAX = ~uint256(0);
478     uint256 private _tTotal = 1 * 10**6 * 10**7;
479     uint256 private _rTotal = (MAX - (MAX % _tTotal));
480     uint256 private _tFeeTotal;
481     uint256 private _tBurnTotal;
482 
483     string private _name = 'reaper.finance';
484     string private _symbol = 'R3P';
485     uint8 private _decimals = 8;
486     
487     uint256 private _taxFee = 1;
488     uint256 private _burnFee = 1;
489     uint256 private _maxTxAmount = 2500e8;
490 
491     constructor () public {
492         _rOwned[_msgSender()] = _rTotal;
493         emit Transfer(address(0), _msgSender(), _tTotal);
494     }
495 
496     function name() public view returns (string memory) {
497         return _name;
498     }
499 
500     function symbol() public view returns (string memory) {
501         return _symbol;
502     }
503 
504     function decimals() public view returns (uint8) {
505         return _decimals;
506     }
507 
508     function totalSupply() public view override returns (uint256) {
509         return _tTotal;
510     }
511 
512     function balanceOf(address account) public view override returns (uint256) {
513         if (_isExcluded[account]) return _tOwned[account];
514         return tokenFromReflection(_rOwned[account]);
515     }
516 
517     function transfer(address recipient, uint256 amount) public override returns (bool) {
518         _transfer(_msgSender(), recipient, amount);
519         return true;
520     }
521 
522     function allowance(address owner, address spender) public view override returns (uint256) {
523         return _allowances[owner][spender];
524     }
525 
526     function approve(address spender, uint256 amount) public override returns (bool) {
527         _approve(_msgSender(), spender, amount);
528         return true;
529     }
530 
531     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
532         _transfer(sender, recipient, amount);
533         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
534         return true;
535     }
536 
537     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
538         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
539         return true;
540     }
541 
542     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
543         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
544         return true;
545     }
546 
547     function isExcluded(address account) public view returns (bool) {
548         return _isExcluded[account];
549     }
550 
551     function totalFees() public view returns (uint256) {
552         return _tFeeTotal;
553     }
554     
555     function totalBurn() public view returns (uint256) {
556         return _tBurnTotal;
557     }
558 
559     function deliver(uint256 tAmount) public {
560         address sender = _msgSender();
561         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
562         (uint256 rAmount,,,,,) = _getValues(tAmount);
563         _rOwned[sender] = _rOwned[sender].sub(rAmount);
564         _rTotal = _rTotal.sub(rAmount);
565         _tFeeTotal = _tFeeTotal.add(tAmount);
566     }
567 
568     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
569         require(tAmount <= _tTotal, "Amount must be less than supply");
570         if (!deductTransferFee) {
571             (uint256 rAmount,,,,,) = _getValues(tAmount);
572             return rAmount;
573         } else {
574             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
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
586         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
587         require(!_isExcluded[account], "Account is already excluded");
588         if(_rOwned[account] > 0) {
589             _tOwned[account] = tokenFromReflection(_rOwned[account]);
590         }
591         _isExcluded[account] = true;
592         _excluded.push(account);
593     }
594 
595     function includeAccount(address account) external onlyOwner() {
596         require(_isExcluded[account], "Account is already excluded");
597         for (uint256 i = 0; i < _excluded.length; i++) {
598             if (_excluded[i] == account) {
599                 _excluded[i] = _excluded[_excluded.length - 1];
600                 _tOwned[account] = 0;
601                 _isExcluded[account] = false;
602                 _excluded.pop();
603                 break;
604             }
605         }
606     }
607 
608     function _approve(address owner, address spender, uint256 amount) private {
609         require(owner != address(0), "ERC20: approve from the zero address");
610         require(spender != address(0), "ERC20: approve to the zero address");
611 
612         _allowances[owner][spender] = amount;
613         emit Approval(owner, spender, amount);
614     }
615 
616     function _transfer(address sender, address recipient, uint256 amount) private {
617         require(sender != address(0), "ERC20: transfer from the zero address");
618         require(recipient != address(0), "ERC20: transfer to the zero address");
619         require(amount > 0, "Transfer amount must be greater than zero");
620         
621         if(sender != owner() && recipient != owner())
622             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
623         
624         if (_isExcluded[sender] && !_isExcluded[recipient]) {
625             _transferFromExcluded(sender, recipient, amount);
626         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
627             _transferToExcluded(sender, recipient, amount);
628         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
629             _transferStandard(sender, recipient, amount);
630         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
631             _transferBothExcluded(sender, recipient, amount);
632         } else {
633             _transferStandard(sender, recipient, amount);
634         }
635     }
636 
637     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
638         uint256 currentRate =  _getRate();
639         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
640         uint256 rBurn =  tBurn.mul(currentRate);
641         _rOwned[sender] = _rOwned[sender].sub(rAmount);
642         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
643         _reflectFee(rFee, rBurn, tFee, tBurn);
644         emit Transfer(sender, recipient, tTransferAmount);
645     }
646 
647     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
648         uint256 currentRate =  _getRate();
649         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
650         uint256 rBurn =  tBurn.mul(currentRate);
651         _rOwned[sender] = _rOwned[sender].sub(rAmount);
652         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
653         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
654         _reflectFee(rFee, rBurn, tFee, tBurn);
655         emit Transfer(sender, recipient, tTransferAmount);
656     }
657 
658     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
659         uint256 currentRate =  _getRate();
660         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
661         uint256 rBurn =  tBurn.mul(currentRate);
662         _tOwned[sender] = _tOwned[sender].sub(tAmount);
663         _rOwned[sender] = _rOwned[sender].sub(rAmount);
664         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
665         _reflectFee(rFee, rBurn, tFee, tBurn);
666         emit Transfer(sender, recipient, tTransferAmount);
667     }
668 
669     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
670         uint256 currentRate =  _getRate();
671         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
672         uint256 rBurn =  tBurn.mul(currentRate);
673         _tOwned[sender] = _tOwned[sender].sub(tAmount);
674         _rOwned[sender] = _rOwned[sender].sub(rAmount);
675         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
676         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
677         _reflectFee(rFee, rBurn, tFee, tBurn);
678         emit Transfer(sender, recipient, tTransferAmount);
679     }
680 
681     function _reflectFee(uint256 rFee, uint256 rBurn, uint256 tFee, uint256 tBurn) private {
682         _rTotal = _rTotal.sub(rFee).sub(rBurn);
683         _tFeeTotal = _tFeeTotal.add(tFee);
684         _tBurnTotal = _tBurnTotal.add(tBurn);
685         _tTotal = _tTotal.sub(tBurn);
686     }
687 
688     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
689         (uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getTValues(tAmount, _taxFee, _burnFee);
690         uint256 currentRate =  _getRate();
691         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tBurn, currentRate);
692         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBurn);
693     }
694 
695     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 burnFee) private pure returns (uint256, uint256, uint256) {
696         uint256 tFee = tAmount.mul(taxFee).div(100);
697         uint256 tBurn = tAmount.mul(burnFee).div(100);
698         uint256 tTransferAmount = tAmount.sub(tFee).sub(tBurn);
699         return (tTransferAmount, tFee, tBurn);
700     }
701 
702     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tBurn, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
703         uint256 rAmount = tAmount.mul(currentRate);
704         uint256 rFee = tFee.mul(currentRate);
705         uint256 rBurn = tBurn.mul(currentRate);
706         uint256 rTransferAmount = rAmount.sub(rFee).sub(rBurn);
707         return (rAmount, rTransferAmount, rFee);
708     }
709 
710     function _getRate() private view returns(uint256) {
711         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
712         return rSupply.div(tSupply);
713     }
714 
715     function _getCurrentSupply() private view returns(uint256, uint256) {
716         uint256 rSupply = _rTotal;
717         uint256 tSupply = _tTotal;      
718         for (uint256 i = 0; i < _excluded.length; i++) {
719             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
720             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
721             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
722         }
723         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
724         return (rSupply, tSupply);
725     }
726     
727     function _getTaxFee() private view returns(uint256) {
728         return _taxFee;
729     }
730 
731     function _getMaxTxAmount() private view returns(uint256) {
732         return _maxTxAmount;
733     }
734     
735     function _setTaxFee(uint256 taxFee) external onlyOwner() {
736         require(taxFee >= 1 && taxFee <= 10, 'taxFee should be in 1 - 10');
737         _taxFee = taxFee;
738     }
739     
740     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
741         require(maxTxAmount >= 9000e9 , 'maxTxAmount should be greater than 9000e9');
742         _maxTxAmount = maxTxAmount;
743     }
744 }