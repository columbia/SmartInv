1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
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
16 /**
17  * @dev Interface of the ERC20 standard as defined in the EIP.
18  */
19 interface IERC20 {
20     /**
21      * @dev Returns the amount of tokens in existence.
22      */
23     function totalSupply() external view returns (uint256);
24 
25     /**
26      * @dev Returns the amount of tokens owned by `account`.
27      */
28     function balanceOf(address account) external view returns (uint256);
29 
30     /**
31      * @dev Moves `amount` tokens from the caller's account to `recipient`.
32      *
33      * Returns a boolean value indicating whether the operation succeeded.
34      *
35      * Emits a {Transfer} event.
36      */
37     function transfer(address recipient, uint256 amount) external returns (bool);
38 
39     /**
40      * @dev Returns the remaining number of tokens that `spender` will be
41      * allowed to spend on behalf of `owner` through {transferFrom}. This is
42      * zero by default.
43      *
44      * This value changes when {approve} or {transferFrom} are called.
45      */
46     function allowance(address owner, address spender) external view returns (uint256);
47 
48     /**
49      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
50      *
51      * Returns a boolean value indicating whether the operation succeeded.
52      *
53      * IMPORTANT: Beware that changing an allowance with this method brings the risk
54      * that someone may use both the old and the new allowance by unfortunate
55      * transaction ordering. One possible solution to mitigate this race
56      * condition is to first reduce the spender's allowance to 0 and set the
57      * desired value afterwards:
58      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
59      *
60      * Emits an {Approval} event.
61      */
62     function approve(address spender, uint256 amount) external returns (bool);
63 
64     /**
65      * @dev Moves `amount` tokens from `sender` to `recipient` using the
66      * allowance mechanism. `amount` is then deducted from the caller's
67      * allowance.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Emitted when `value` tokens are moved from one account (`from`) to
77      * another (`to`).
78      *
79      * Note that `value` may be zero.
80      */
81     event Transfer(address indexed from, address indexed to, uint256 value);
82 
83     /**
84      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
85      * a call to {approve}. `value` is the new allowance.
86      */
87     event Approval(address indexed owner, address indexed spender, uint256 value);
88 }
89 
90 
91 /**
92  * @dev Wrappers over Solidity's arithmetic operations with added overflow
93  * checks.
94  *
95  * Arithmetic operations in Solidity wrap on overflow. This can easily result
96  * in bugs, because programmers usually assume that an overflow raises an
97  * error, which is the standard behavior in high level programming languages.
98  * `SafeMath` restores this intuition by reverting the transaction when an
99  * operation overflows.
100  *
101  * Using this library instead of the unchecked operations eliminates an entire
102  * class of bugs, so it's recommended to use it always.
103  */
104 library SafeMath {
105     /**
106      * @dev Returns the addition of two unsigned integers, reverting on
107      * overflow.
108      *
109      * Counterpart to Solidity's `+` operator.
110      *
111      * Requirements:
112      *
113      * - Addition cannot overflow.
114      */
115     function add(uint256 a, uint256 b) internal pure returns (uint256) {
116         uint256 c = a + b;
117         require(c >= a, "SafeMath: addition overflow");
118 
119         return c;
120     }
121 
122     /**
123      * @dev Returns the subtraction of two unsigned integers, reverting on
124      * overflow (when the result is negative).
125      *
126      * Counterpart to Solidity's `-` operator.
127      *
128      * Requirements:
129      *
130      * - Subtraction cannot overflow.
131      */
132     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
133         return sub(a, b, "SafeMath: subtraction overflow");
134     }
135 
136     /**
137      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
138      * overflow (when the result is negative).
139      *
140      * Counterpart to Solidity's `-` operator.
141      *
142      * Requirements:
143      *
144      * - Subtraction cannot overflow.
145      */
146     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
147         require(b <= a, errorMessage);
148         uint256 c = a - b;
149 
150         return c;
151     }
152 
153     /**
154      * @dev Returns the multiplication of two unsigned integers, reverting on
155      * overflow.
156      *
157      * Counterpart to Solidity's `*` operator.
158      *
159      * Requirements:
160      *
161      * - Multiplication cannot overflow.
162      */
163     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
164         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
165         // benefit is lost if 'b' is also tested.
166         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
167         if (a == 0) {
168             return 0;
169         }
170 
171         uint256 c = a * b;
172         require(c / a == b, "SafeMath: multiplication overflow");
173 
174         return c;
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers. Reverts on
179      * division by zero. The result is rounded towards zero.
180      *
181      * Counterpart to Solidity's `/` operator. Note: this function uses a
182      * `revert` opcode (which leaves remaining gas untouched) while Solidity
183      * uses an invalid opcode to revert (consuming all remaining gas).
184      *
185      * Requirements:
186      *
187      * - The divisor cannot be zero.
188      */
189     function div(uint256 a, uint256 b) internal pure returns (uint256) {
190         return div(a, b, "SafeMath: division by zero");
191     }
192 
193     /**
194      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
195      * division by zero. The result is rounded towards zero.
196      *
197      * Counterpart to Solidity's `/` operator. Note: this function uses a
198      * `revert` opcode (which leaves remaining gas untouched) while Solidity
199      * uses an invalid opcode to revert (consuming all remaining gas).
200      *
201      * Requirements:
202      *
203      * - The divisor cannot be zero.
204      */
205     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
206         require(b > 0, errorMessage);
207         uint256 c = a / b;
208         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
209 
210         return c;
211     }
212 
213     /**
214      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
215      * Reverts when dividing by zero.
216      *
217      * Counterpart to Solidity's `%` operator. This function uses a `revert`
218      * opcode (which leaves remaining gas untouched) while Solidity uses an
219      * invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
226         return mod(a, b, "SafeMath: modulo by zero");
227     }
228 
229     /**
230      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
231      * Reverts with custom message when dividing by zero.
232      *
233      * Counterpart to Solidity's `%` operator. This function uses a `revert`
234      * opcode (which leaves remaining gas untouched) while Solidity uses an
235      * invalid opcode to revert (consuming all remaining gas).
236      *
237      * Requirements:
238      *
239      * - The divisor cannot be zero.
240      */
241     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
242         require(b != 0, errorMessage);
243         return a % b;
244     }
245 }
246 
247 /**
248  * @dev Collection of functions related to the address type
249  */
250 library Address {
251     /**
252      * @dev Returns true if `account` is a contract.
253      *
254      * [IMPORTANT]
255      * ====
256      * It is unsafe to assume that an address for which this function returns
257      * false is an externally-owned account (EOA) and not a contract.
258      *
259      * Among others, `isContract` will return false for the following
260      * types of addresses:
261      *
262      *  - an externally-owned account
263      *  - a contract in construction
264      *  - an address where a contract will be created
265      *  - an address where a contract lived, but was destroyed
266      * ====
267      */
268     function isContract(address account) internal view returns (bool) {
269         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
270         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
271         // for accounts without code, i.e. `keccak256('')`
272         bytes32 codehash;
273         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
274         // solhint-disable-next-line no-inline-assembly
275         assembly { codehash := extcodehash(account) }
276         return (codehash != accountHash && codehash != 0x0);
277     }
278 
279     /**
280      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
281      * `recipient`, forwarding all available gas and reverting on errors.
282      *
283      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
284      * of certain opcodes, possibly making contracts go over the 2300 gas limit
285      * imposed by `transfer`, making them unable to receive funds via
286      * `transfer`. {sendValue} removes this limitation.
287      *
288      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
289      *
290      * IMPORTANT: because control is transferred to `recipient`, care must be
291      * taken to not create reentrancy vulnerabilities. Consider using
292      * {ReentrancyGuard} or the
293      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
294      */
295     function sendValue(address payable recipient, uint256 amount) internal {
296         require(address(this).balance >= amount, "Address: insufficient balance");
297 
298         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
299         (bool success, ) = recipient.call{ value: amount }("");
300         require(success, "Address: unable to send value, recipient may have reverted");
301     }
302 
303     /**
304      * @dev Performs a Solidity function call using a low level `call`. A
305      * plain`call` is an unsafe replacement for a function call: use this
306      * function instead.
307      *
308      * If `target` reverts with a revert reason, it is bubbled up by this
309      * function (like regular Solidity function calls).
310      *
311      * Returns the raw returned data. To convert to the expected return value,
312      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
313      *
314      * Requirements:
315      *
316      * - `target` must be a contract.
317      * - calling `target` with `data` must not revert.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
322       return functionCall(target, data, "Address: low-level call failed");
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
327      * `errorMessage` as a fallback revert reason when `target` reverts.
328      *
329      * _Available since v3.1._
330      */
331     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
332         return _functionCallWithValue(target, data, 0, errorMessage);
333     }
334 
335     /**
336      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
337      * but also transferring `value` wei to `target`.
338      *
339      * Requirements:
340      *
341      * - the calling contract must have an ETH balance of at least `value`.
342      * - the called Solidity function must be `payable`.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
347         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
352      * with `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
357         require(address(this).balance >= value, "Address: insufficient balance for call");
358         return _functionCallWithValue(target, data, value, errorMessage);
359     }
360 
361     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
362         require(isContract(target), "Address: call to non-contract");
363 
364         // solhint-disable-next-line avoid-low-level-calls
365         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
366         if (success) {
367             return returndata;
368         } else {
369             // Look for revert reason and bubble it up if present
370             if (returndata.length > 0) {
371                 // The easiest way to bubble the revert reason is using memory via assembly
372 
373                 // solhint-disable-next-line no-inline-assembly
374                 assembly {
375                     let returndata_size := mload(returndata)
376                     revert(add(32, returndata), returndata_size)
377                 }
378             } else {
379                 revert(errorMessage);
380             }
381         }
382     }
383 }
384 
385 
386 /**
387  * @dev Contract module which provides a basic access control mechanism, where
388  * there is an account (an owner) that can be granted exclusive access to
389  * specific functions.
390  *
391  * By default, the owner account will be the one that deploys the contract. This
392  * can later be changed with {transferOwnership}.
393  *
394  * This module is used through inheritance. It will make available the modifier
395  * `onlyOwner`, which can be applied to your functions to restrict their use to
396  * the owner.
397  */
398 contract Ownable is Context {
399     address private _owner;
400 
401     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
402 
403     /**
404      * @dev Initializes the contract setting the deployer as the initial owner.
405      */
406     constructor () internal {
407         address msgSender = _msgSender();
408         _owner = msgSender;
409         emit OwnershipTransferred(address(0), msgSender);
410     }
411 
412     /**
413      * @dev Returns the address of the current owner.
414      */
415     function owner() public view returns (address) {
416         return _owner;
417     }
418 
419     /**
420      * @dev Throws if called by any account other than the owner.
421      */
422     modifier onlyOwner() {
423         require(_owner == _msgSender(), "Ownable: caller is not the owner");
424         _;
425     }
426 
427     /**
428      * @dev Leaves the contract without owner. It will not be possible to call
429      * `onlyOwner` functions anymore. Can only be called by the current owner.
430      *
431      * NOTE: Renouncing ownership will leave the contract without an owner,
432      * thereby removing any functionality that is only available to the owner.
433      */
434     function renounceOwnership() public virtual onlyOwner {
435         emit OwnershipTransferred(_owner, address(0));
436         _owner = address(0);
437     }
438 
439     /**
440      * @dev Transfers ownership of the contract to a new account (`newOwner`).
441      * Can only be called by the current owner.
442      */
443     function transferOwnership(address newOwner) public virtual onlyOwner {
444         require(newOwner != address(0), "Ownable: new owner is the zero address");
445         emit OwnershipTransferred(_owner, newOwner);
446         _owner = newOwner;
447     }
448 }
449 
450 /*
451  * This is a simple fork of reflect.finance. Which is a clone of prophet.finance. Credits goes to both of them.
452  * This is not pretending to be anything, it's just code in the end, life goes on. Peace to all devs.
453  */
454 contract REFLECT is Context, IERC20, Ownable {
455     using SafeMath for uint256;
456     using Address for address;
457 
458     mapping (address => uint256) private _rOwned;
459     mapping (address => uint256) private _tOwned;
460     mapping (address => mapping (address => uint256)) private _allowances;
461 
462     mapping (address => bool) private _isExcluded;
463     address[] private _excluded;
464    
465     uint256 private constant MAX = ~uint256(0);
466     uint256 private constant _tTotal = 1 * 10**5 * 10**9;
467     uint256 private _rTotal = (MAX - (MAX % _tTotal));
468     uint256 private _tFeeTotal;
469 
470     string private _name = 'ReflectIV.finance';
471     string private _symbol = 'RFIV';
472     uint8 private _decimals = 9;
473 
474     constructor () public {
475         _rOwned[_msgSender()] = _rTotal;
476         emit Transfer(address(0), _msgSender(), _tTotal);
477     }
478 
479     function name() public view returns (string memory) {
480         return _name;
481     }
482 
483     function symbol() public view returns (string memory) {
484         return _symbol;
485     }
486 
487     function decimals() public view returns (uint8) {
488         return _decimals;
489     }
490 
491     function totalSupply() public view override returns (uint256) {
492         return _tTotal;
493     }
494 
495     function balanceOf(address account) public view override returns (uint256) {
496         if (_isExcluded[account]) return _tOwned[account];
497         return tokenFromReflection(_rOwned[account]);
498     }
499 
500     function transfer(address recipient, uint256 amount) public override returns (bool) {
501         _transfer(_msgSender(), recipient, amount);
502         return true;
503     }
504 
505     function allowance(address owner, address spender) public view override returns (uint256) {
506         return _allowances[owner][spender];
507     }
508 
509     function approve(address spender, uint256 amount) public override returns (bool) {
510         _approve(_msgSender(), spender, amount);
511         return true;
512     }
513 
514     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
515         _transfer(sender, recipient, amount);
516         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
517         return true;
518     }
519 
520     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
521         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
522         return true;
523     }
524 
525     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
526         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
527         return true;
528     }
529 
530     function isExcluded(address account) public view returns (bool) {
531         return _isExcluded[account];
532     }
533 
534     function totalFees() public view returns (uint256) {
535         return _tFeeTotal;
536     }
537 
538     function reflect(uint256 tAmount) public {
539         address sender = _msgSender();
540         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
541         (uint256 rAmount,,,,) = _getValues(tAmount);
542         _rOwned[sender] = _rOwned[sender].sub(rAmount);
543         _rTotal = _rTotal.sub(rAmount);
544         _tFeeTotal = _tFeeTotal.add(tAmount);
545     }
546 
547     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
548         require(tAmount <= _tTotal, "Amount must be less than supply");
549         if (!deductTransferFee) {
550             (uint256 rAmount,,,,) = _getValues(tAmount);
551             return rAmount;
552         } else {
553             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
554             return rTransferAmount;
555         }
556     }
557 
558     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
559         require(rAmount <= _rTotal, "Amount must be less than total reflections");
560         uint256 currentRate =  _getRate();
561         return rAmount.div(currentRate);
562     }
563 
564     function excludeAccount(address account) external onlyOwner() {
565         require(!_isExcluded[account], "Account is already excluded");
566         if(_rOwned[account] > 0) {
567             _tOwned[account] = tokenFromReflection(_rOwned[account]);
568         }
569         _isExcluded[account] = true;
570         _excluded.push(account);
571     }
572 
573     function includeAccount(address account) external onlyOwner() {
574         require(_isExcluded[account], "Account is already excluded");
575         for (uint256 i = 0; i < _excluded.length; i++) {
576             if (_excluded[i] == account) {
577                 _excluded[i] = _excluded[_excluded.length - 1];
578                 _tOwned[account] = 0;
579                 _isExcluded[account] = false;
580                 _excluded.pop();
581                 break;
582             }
583         }
584     }
585 
586     function _approve(address owner, address spender, uint256 amount) private {
587         require(owner != address(0), "ERC20: approve from the zero address");
588         require(spender != address(0), "ERC20: approve to the zero address");
589 
590         _allowances[owner][spender] = amount;
591         emit Approval(owner, spender, amount);
592     }
593 
594     function _transfer(address sender, address recipient, uint256 amount) private {
595         require(sender != address(0), "ERC20: transfer from the zero address");
596         require(recipient != address(0), "ERC20: transfer to the zero address");
597         require(amount > 0, "Transfer amount must be greater than zero");
598         if (_isExcluded[sender] && !_isExcluded[recipient]) {
599             _transferFromExcluded(sender, recipient, amount);
600         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
601             _transferToExcluded(sender, recipient, amount);
602         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
603             _transferStandard(sender, recipient, amount);
604         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
605             _transferBothExcluded(sender, recipient, amount);
606         } else {
607             _transferStandard(sender, recipient, amount);
608         }
609     }
610 
611     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
612         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
613         _rOwned[sender] = _rOwned[sender].sub(rAmount);
614         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
615         _reflectFee(rFee, tFee);
616         emit Transfer(sender, recipient, tTransferAmount);
617     }
618 
619     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
620         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
621         _rOwned[sender] = _rOwned[sender].sub(rAmount);
622         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
623         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
624         _reflectFee(rFee, tFee);
625         emit Transfer(sender, recipient, tTransferAmount);
626     }
627 
628     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
629         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
630         _tOwned[sender] = _tOwned[sender].sub(tAmount);
631         _rOwned[sender] = _rOwned[sender].sub(rAmount);
632         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
633         _reflectFee(rFee, tFee);
634         emit Transfer(sender, recipient, tTransferAmount);
635     }
636 
637     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
638         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
639         _tOwned[sender] = _tOwned[sender].sub(tAmount);
640         _rOwned[sender] = _rOwned[sender].sub(rAmount);
641         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
642         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
643         _reflectFee(rFee, tFee);
644         emit Transfer(sender, recipient, tTransferAmount);
645     }
646 
647     function _reflectFee(uint256 rFee, uint256 tFee) private {
648         _rTotal = _rTotal.sub(rFee);
649         _tFeeTotal = _tFeeTotal.add(tFee);
650     }
651 
652     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
653         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
654         uint256 currentRate =  _getRate();
655         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
656         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
657     }
658 
659     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
660         uint256 tFee = tAmount.div(100);
661         uint256 tTransferAmount = tAmount.sub(tFee);
662         return (tTransferAmount, tFee);
663     }
664 
665     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
666         uint256 rAmount = tAmount.mul(currentRate);
667         uint256 rFee = tFee.mul(currentRate);
668         uint256 rTransferAmount = rAmount.sub(rFee);
669         return (rAmount, rTransferAmount, rFee);
670     }
671 
672     function _getRate() private view returns(uint256) {
673         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
674         return rSupply.div(tSupply);
675     }
676 
677     function _getCurrentSupply() private view returns(uint256, uint256) {
678         uint256 rSupply = _rTotal;
679         uint256 tSupply = _tTotal;      
680         for (uint256 i = 0; i < _excluded.length; i++) {
681             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
682             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
683             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
684         }
685         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
686         return (rSupply, tSupply);
687     }
688 }