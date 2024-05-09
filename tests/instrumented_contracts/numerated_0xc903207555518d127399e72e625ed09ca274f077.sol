1 // SPDX-License-Identifier: MIT
2 
3 /*
4 .########..####..######...#######...######..##.....##.########.########...
5 .##.....##..##..##....##.##.....##.##....##.##.....##.##..........##......
6 .##.....##..##..##.......##.....##.##.......##.....##.##..........##......
7 .########...##..##.......##.....##.##.......#########.######......##......
8 .##...##....##..##.......##.....##.##.......##.....##.##..........##......
9 .##....##...##..##....##.##.....##.##....##.##.....##.##..........##......
10 .##.....##.####..######...#######...######..##.....##.########....##......
11 */
12 pragma solidity ^0.6.0;
13 
14 /*
15  * @dev Provides information about the current execution context, including the
16  * sender of the transaction and its data. While these are generally available
17  * via msg.sender and msg.data, they should not be accessed in such a direct
18  * manner, since when dealing with GSN meta-transactions the account sending and
19  * paying for execution may not be the actual sender (as far as an application
20  * is concerned).
21  *
22  * This contract is only required for intermediate, library-like contracts.
23  */
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address payable) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes memory) {
30         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
31         return msg.data;
32     }
33 }
34 
35 
36 /**
37  * @dev Interface of the ERC20 standard as defined in the EIP.
38  */
39 interface IERC20 {
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     /**
51      * @dev Moves `amount` tokens from the caller's account to `recipient`.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * IMPORTANT: Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Moves `amount` tokens from `sender` to `recipient` using the
86      * allowance mechanism. `amount` is then deducted from the caller's
87      * allowance.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
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
266 /**
267  * @dev Collection of functions related to the address type
268  */
269 library Address {
270     /**
271      * @dev Returns true if `account` is a contract.
272      *
273      * [IMPORTANT]
274      * ====
275      * It is unsafe to assume that an address for which this function returns
276      * false is an externally-owned account (EOA) and not a contract.
277      *
278      * Among others, `isContract` will return false for the following
279      * types of addresses:
280      *
281      *  - an externally-owned account
282      *  - a contract in construction
283      *  - an address where a contract will be created
284      *  - an address where a contract lived, but was destroyed
285      * ====
286      */
287     function isContract(address account) internal view returns (bool) {
288         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
289         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
290         // for accounts without code, i.e. `keccak256('')`
291         bytes32 codehash;
292         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
293         // solhint-disable-next-line no-inline-assembly
294         assembly { codehash := extcodehash(account) }
295         return (codehash != accountHash && codehash != 0x0);
296     }
297 
298     /**
299      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
300      * `recipient`, forwarding all available gas and reverting on errors.
301      *
302      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
303      * of certain opcodes, possibly making contracts go over the 2300 gas limit
304      * imposed by `transfer`, making them unable to receive funds via
305      * `transfer`. {sendValue} removes this limitation.
306      *
307      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
308      *
309      * IMPORTANT: because control is transferred to `recipient`, care must be
310      * taken to not create reentrancy vulnerabilities. Consider using
311      * {ReentrancyGuard} or the
312      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
313      */
314     function sendValue(address payable recipient, uint256 amount) internal {
315         require(address(this).balance >= amount, "Address: insufficient balance");
316 
317         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
318         (bool success, ) = recipient.call{ value: amount }("");
319         require(success, "Address: unable to send value, recipient may have reverted");
320     }
321 
322     /**
323      * @dev Performs a Solidity function call using a low level `call`. A
324      * plain`call` is an unsafe replacement for a function call: use this
325      * function instead.
326      *
327      * If `target` reverts with a revert reason, it is bubbled up by this
328      * function (like regular Solidity function calls).
329      *
330      * Returns the raw returned data. To convert to the expected return value,
331      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
332      *
333      * Requirements:
334      *
335      * - `target` must be a contract.
336      * - calling `target` with `data` must not revert.
337      *
338      * _Available since v3.1._
339      */
340     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
341       return functionCall(target, data, "Address: low-level call failed");
342     }
343 
344     /**
345      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
346      * `errorMessage` as a fallback revert reason when `target` reverts.
347      *
348      * _Available since v3.1._
349      */
350     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
351         return _functionCallWithValue(target, data, 0, errorMessage);
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
356      * but also transferring `value` wei to `target`.
357      *
358      * Requirements:
359      *
360      * - the calling contract must have an ETH balance of at least `value`.
361      * - the called Solidity function must be `payable`.
362      *
363      * _Available since v3.1._
364      */
365     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
366         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
371      * with `errorMessage` as a fallback revert reason when `target` reverts.
372      *
373      * _Available since v3.1._
374      */
375     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
376         require(address(this).balance >= value, "Address: insufficient balance for call");
377         return _functionCallWithValue(target, data, value, errorMessage);
378     }
379 
380     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
381         require(isContract(target), "Address: call to non-contract");
382 
383         // solhint-disable-next-line avoid-low-level-calls
384         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
385         if (success) {
386             return returndata;
387         } else {
388             // Look for revert reason and bubble it up if present
389             if (returndata.length > 0) {
390                 // The easiest way to bubble the revert reason is using memory via assembly
391 
392                 // solhint-disable-next-line no-inline-assembly
393                 assembly {
394                     let returndata_size := mload(returndata)
395                     revert(add(32, returndata), returndata_size)
396                 }
397             } else {
398                 revert(errorMessage);
399             }
400         }
401     }
402 }
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
470 
471 
472 contract RICOCHET is Context, IERC20, Ownable {
473     using SafeMath for uint256;
474     using Address for address;
475 
476     mapping (address => uint256) private _rOwned;
477     mapping (address => uint256) private _tOwned;
478     mapping (address => mapping (address => uint256)) private _allowances;
479 
480     mapping (address => bool) private _isExcluded;
481     address[] private _excluded;
482    
483     uint256 private constant MAX = ~uint256(0);
484     uint256 private constant _tTotal = 10 * 10**6 * 10**9;
485     uint256 private _rTotal = (MAX - (MAX % _tTotal));
486     uint256 private _tFeeTotal;
487 
488     string private _name = 'Ricochet.space';
489     string private _symbol = 'RICO';
490     uint8 private _decimals = 9;
491 
492     constructor () public {
493         _rOwned[_msgSender()] = _rTotal;
494         emit Transfer(address(0), _msgSender(), _tTotal);
495     }
496 
497     function name() public view returns (string memory) {
498         return _name;
499     }
500 
501     function symbol() public view returns (string memory) {
502         return _symbol;
503     }
504 
505     function decimals() public view returns (uint8) {
506         return _decimals;
507     }
508 
509     function totalSupply() public view override returns (uint256) {
510         return _tTotal;
511     }
512 
513     function balanceOf(address account) public view override returns (uint256) {
514         if (_isExcluded[account]) return _tOwned[account];
515         return tokenFromReflection(_rOwned[account]);
516     }
517 
518     function transfer(address recipient, uint256 amount) public override returns (bool) {
519         _transfer(_msgSender(), recipient, amount);
520         return true;
521     }
522 
523     function allowance(address owner, address spender) public view override returns (uint256) {
524         return _allowances[owner][spender];
525     }
526 
527     function approve(address spender, uint256 amount) public override returns (bool) {
528         _approve(_msgSender(), spender, amount);
529         return true;
530     }
531 
532     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
533         _transfer(sender, recipient, amount);
534         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
535         return true;
536     }
537 
538     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
539         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
540         return true;
541     }
542 
543     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
544         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
545         return true;
546     }
547 
548     function isExcluded(address account) public view returns (bool) {
549         return _isExcluded[account];
550     }
551 
552     function totalFees() public view returns (uint256) {
553         return _tFeeTotal;
554     }
555 
556     function ricochet(uint256 tAmount) public {
557         address sender = _msgSender();
558         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
559         (uint256 rAmount,,,,) = _getValues(tAmount);
560         _rOwned[sender] = _rOwned[sender].sub(rAmount);
561         _rTotal = _rTotal.sub(rAmount);
562         _tFeeTotal = _tFeeTotal.add(tAmount);
563     }
564 
565     function ricochetionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
566         require(tAmount <= _tTotal, "Amount must be less than supply");
567         if (!deductTransferFee) {
568             (uint256 rAmount,,,,) = _getValues(tAmount);
569             return rAmount;
570         } else {
571             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
572             return rTransferAmount;
573         }
574     }
575 
576     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
577         require(rAmount <= _rTotal, "Amount must be less than total ricochetions");
578         uint256 currentRate =  _getRate();
579         return rAmount.div(currentRate);
580     }
581 
582     function excludeAccount(address account) external onlyOwner() {
583         require(!_isExcluded[account], "Account is already excluded");
584         if(_rOwned[account] > 0) {
585             _tOwned[account] = tokenFromReflection(_rOwned[account]);
586         }
587         _isExcluded[account] = true;
588         _excluded.push(account);
589     }
590 
591     function includeAccount(address account) external onlyOwner() {
592         require(_isExcluded[account], "Account is already excluded");
593         for (uint256 i = 0; i < _excluded.length; i++) {
594             if (_excluded[i] == account) {
595                 _excluded[i] = _excluded[_excluded.length - 1];
596                 _tOwned[account] = 0;
597                 _isExcluded[account] = false;
598                 _excluded.pop();
599                 break;
600             }
601         }
602     }
603 
604     function _approve(address owner, address spender, uint256 amount) private {
605         require(owner != address(0), "ERC20: approve from the zero address");
606         require(spender != address(0), "ERC20: approve to the zero address");
607 
608         _allowances[owner][spender] = amount;
609         emit Approval(owner, spender, amount);
610     }
611 
612     function _transfer(address sender, address recipient, uint256 amount) private {
613         require(sender != address(0), "ERC20: transfer from the zero address");
614         require(recipient != address(0), "ERC20: transfer to the zero address");
615         require(amount > 0, "Transfer amount must be greater than zero");
616         if (_isExcluded[sender] && !_isExcluded[recipient]) {
617             _transferFromExcluded(sender, recipient, amount);
618         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
619             _transferToExcluded(sender, recipient, amount);
620         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
621             _transferStandard(sender, recipient, amount);
622         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
623             _transferBothExcluded(sender, recipient, amount);
624         } else {
625             _transferStandard(sender, recipient, amount);
626         }
627     }
628 
629     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
630         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
631         _rOwned[sender] = _rOwned[sender].sub(rAmount);
632         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
633         _ricochetFee(rFee, tFee);
634         emit Transfer(sender, recipient, tTransferAmount);
635     }
636 
637     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
638         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
639         _rOwned[sender] = _rOwned[sender].sub(rAmount);
640         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
641         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
642         _ricochetFee(rFee, tFee);
643         emit Transfer(sender, recipient, tTransferAmount);
644     }
645 
646     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
647         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
648         _tOwned[sender] = _tOwned[sender].sub(tAmount);
649         _rOwned[sender] = _rOwned[sender].sub(rAmount);
650         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
651         _ricochetFee(rFee, tFee);
652         emit Transfer(sender, recipient, tTransferAmount);
653     }
654 
655     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
656         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
657         _tOwned[sender] = _tOwned[sender].sub(tAmount);
658         _rOwned[sender] = _rOwned[sender].sub(rAmount);
659         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
660         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
661         _ricochetFee(rFee, tFee);
662         emit Transfer(sender, recipient, tTransferAmount);
663     }
664 
665     function _ricochetFee(uint256 rFee, uint256 tFee) private {
666         _rTotal = _rTotal.sub(rFee);
667         _tFeeTotal = _tFeeTotal.add(tFee);
668     }
669 
670     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
671         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
672         uint256 currentRate =  _getRate();
673         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
674         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
675     }
676 
677     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
678         uint256 tFee = tAmount.mul(2).div(100);
679         uint256 tTransferAmount = tAmount.sub(tFee);
680         return (tTransferAmount, tFee);
681     }
682 
683     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
684         uint256 rAmount = tAmount.mul(currentRate);
685         uint256 rFee = tFee.mul(currentRate);
686         uint256 rTransferAmount = rAmount.sub(rFee);
687         return (rAmount, rTransferAmount, rFee);
688     }
689 
690     function _getRate() private view returns(uint256) {
691         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
692         return rSupply.div(tSupply);
693     }
694 
695     function _getCurrentSupply() private view returns(uint256, uint256) {
696         uint256 rSupply = _rTotal;
697         uint256 tSupply = _tTotal;      
698         for (uint256 i = 0; i < _excluded.length; i++) {
699             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
700             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
701             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
702         }
703         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
704         return (rSupply, tSupply);
705     }
706 }