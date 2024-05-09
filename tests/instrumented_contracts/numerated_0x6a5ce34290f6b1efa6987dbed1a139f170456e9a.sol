1 /*  Telegram:  https://t.me/genjiinu
2     Website:  https://genjiinu.weebly.com/
3 */
4 
5 
6 /*
7  * @dev Provides information about the current execution context, including the
8  * sender of the transaction and its data. While these are generally available
9  * via msg.sender and msg.data, they should not be accessed in such a direct
10  * manner, since when dealing with GSN meta-transactions the account sending and
11  * paying for execution may not be the actual sender (as far as an application
12  * is concerned).
13  *
14  * This contract is only required for intermediate, library-like contracts.
15  */
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address payable) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 
28 /**
29  * @dev Interface of the ERC20 standard as defined in the EIP.
30  */
31 interface IERC20 {
32     /**
33      * @dev Returns the amount of tokens in existence.
34      */
35     function totalSupply() external view returns (uint256);
36 
37     /**
38      * @dev Returns the amount of tokens owned by `account`.
39      */
40     function balanceOf(address account) external view returns (uint256);
41 
42     /**
43      * @dev Moves `amount` tokens from the caller's account to `recipient`.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * Emits a {Transfer} event.
48      */
49     function transfer(address recipient, uint256 amount) external returns (bool);
50 
51     /**
52      * @dev Returns the remaining number of tokens that `spender` will be
53      * allowed to spend on behalf of `owner` through {transferFrom}. This is
54      * zero by default.
55      *
56      * This value changes when {approve} or {transferFrom} are called.
57      */
58     function allowance(address owner, address spender) external view returns (uint256);
59 
60     /**
61      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * IMPORTANT: Beware that changing an allowance with this method brings the risk
66      * that someone may use both the old and the new allowance by unfortunate
67      * transaction ordering. One possible solution to mitigate this race
68      * condition is to first reduce the spender's allowance to 0 and set the
69      * desired value afterwards:
70      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
71      *
72      * Emits an {Approval} event.
73      */
74     function approve(address spender, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Moves `amount` tokens from `sender` to `recipient` using the
78      * allowance mechanism. `amount` is then deducted from the caller's
79      * allowance.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * Emits a {Transfer} event.
84      */
85     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
86 
87     /**
88      * @dev Emitted when `value` tokens are moved from one account (`from`) to
89      * another (`to`).
90      *
91      * Note that `value` may be zero.
92      */
93     event Transfer(address indexed from, address indexed to, uint256 value);
94 
95     /**
96      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
97      * a call to {approve}. `value` is the new allowance.
98      */
99     event Approval(address indexed owner, address indexed spender, uint256 value);
100 }
101 
102 
103 
104 /**
105  * @dev Wrappers over Solidity's arithmetic operations with added overflow
106  * checks.
107  *
108  * Arithmetic operations in Solidity wrap on overflow. This can easily result
109  * in bugs, because programmers usually assume that an overflow raises an
110  * error, which is the standard behavior in high level programming languages.
111  * `SafeMath` restores this intuition by reverting the transaction when an
112  * operation overflows.
113  *
114  * Using this library instead of the unchecked operations eliminates an entire
115  * class of bugs, so it's recommended to use it always.
116  */
117 library SafeMath {
118     /**
119      * @dev Returns the addition of two unsigned integers, reverting on
120      * overflow.
121      *
122      * Counterpart to Solidity's `+` operator.
123      *
124      * Requirements:
125      *
126      * - Addition cannot overflow.
127      */
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         require(c >= a, "SafeMath: addition overflow");
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the subtraction of two unsigned integers, reverting on
137      * overflow (when the result is negative).
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      *
143      * - Subtraction cannot overflow.
144      */
145     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146         return sub(a, b, "SafeMath: subtraction overflow");
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b <= a, errorMessage);
161         uint256 c = a - b;
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the multiplication of two unsigned integers, reverting on
168      * overflow.
169      *
170      * Counterpart to Solidity's `*` operator.
171      *
172      * Requirements:
173      *
174      * - Multiplication cannot overflow.
175      */
176     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
177         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
178         // benefit is lost if 'b' is also tested.
179         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
180         if (a == 0) {
181             return 0;
182         }
183 
184         uint256 c = a * b;
185         require(c / a == b, "SafeMath: multiplication overflow");
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers. Reverts on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      *
200      * - The divisor cannot be zero.
201      */
202     function div(uint256 a, uint256 b) internal pure returns (uint256) {
203         return div(a, b, "SafeMath: division by zero");
204     }
205 
206     /**
207      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
208      * division by zero. The result is rounded towards zero.
209      *
210      * Counterpart to Solidity's `/` operator. Note: this function uses a
211      * `revert` opcode (which leaves remaining gas untouched) while Solidity
212      * uses an invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         require(b > 0, errorMessage);
220         uint256 c = a / b;
221         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
222 
223         return c;
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * Reverts when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
239         return mod(a, b, "SafeMath: modulo by zero");
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * Reverts with custom message when dividing by zero.
245      *
246      * Counterpart to Solidity's `%` operator. This function uses a `revert`
247      * opcode (which leaves remaining gas untouched) while Solidity uses an
248      * invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      *
252      * - The divisor cannot be zero.
253      */
254     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
255         require(b != 0, errorMessage);
256         return a % b;
257     }
258 }
259 
260 // File: openzeppelin-solidity\contracts\utils\Address.sol
261 
262 // SPDX-License-Identifier: MIT
263 
264 
265 /**
266  * @dev Collection of functions related to the address type
267  */
268 library Address {
269     /**
270      * @dev Returns true if `account` is a contract.
271      *
272      * [IMPORTANT]
273      * ====
274      * It is unsafe to assume that an address for which this function returns
275      * false is an externally-owned account (EOA) and not a contract.
276      *
277      * Among others, `isContract` will return false for the following
278      * types of addresses:
279      *
280      *  - an externally-owned account
281      *  - a contract in construction
282      *  - an address where a contract will be created
283      *  - an address where a contract lived, but was destroyed
284      * ====
285      */
286     function isContract(address account) internal view returns (bool) {
287         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
288         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
289         // for accounts without code, i.e. `keccak256('')`
290         bytes32 codehash;
291         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
292         // solhint-disable-next-line no-inline-assembly
293         assembly { codehash := extcodehash(account) }
294         return (codehash != accountHash && codehash != 0x0);
295     }
296 
297     /**
298      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
299      * `recipient`, forwarding all available gas and reverting on errors.
300      *
301      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
302      * of certain opcodes, possibly making contracts go over the 2300 gas limit
303      * imposed by `transfer`, making them unable to receive funds via
304      * `transfer`. {sendValue} removes this limitation.
305      *
306      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
307      *
308      * IMPORTANT: because control is transferred to `recipient`, care must be
309      * taken to not create reentrancy vulnerabilities. Consider using
310      * {ReentrancyGuard} or the
311      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
312      */
313     function sendValue(address payable recipient, uint256 amount) internal {
314         require(address(this).balance >= amount, "Address: insufficient balance");
315 
316         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
317         (bool success, ) = recipient.call{ value: amount }("");
318         require(success, "Address: unable to send value, recipient may have reverted");
319     }
320 
321     /**
322      * @dev Performs a Solidity function call using a low level `call`. A
323      * plain`call` is an unsafe replacement for a function call: use this
324      * function instead.
325      *
326      * If `target` reverts with a revert reason, it is bubbled up by this
327      * function (like regular Solidity function calls).
328      *
329      * Returns the raw returned data. To convert to the expected return value,
330      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
331      *
332      * Requirements:
333      *
334      * - `target` must be a contract.
335      * - calling `target` with `data` must not revert.
336      *
337      * _Available since v3.1._
338      */
339     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
340         return functionCall(target, data, "Address: low-level call failed");
341     }
342 
343     /**
344      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
345      * `errorMessage` as a fallback revert reason when `target` reverts.
346      *
347      * _Available since v3.1._
348      */
349     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
350         return _functionCallWithValue(target, data, 0, errorMessage);
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
355      * but also transferring `value` wei to `target`.
356      *
357      * Requirements:
358      *
359      * - the calling contract must have an ETH balance of at least `value`.
360      * - the called Solidity function must be `payable`.
361      *
362      * _Available since v3.1._
363      */
364     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
365         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
370      * with `errorMessage` as a fallback revert reason when `target` reverts.
371      *
372      * _Available since v3.1._
373      */
374     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
375         require(address(this).balance >= value, "Address: insufficient balance for call");
376         return _functionCallWithValue(target, data, value, errorMessage);
377     }
378 
379     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
380         require(isContract(target), "Address: call to non-contract");
381 
382         // solhint-disable-next-line avoid-low-level-calls
383         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
384         if (success) {
385             return returndata;
386         } else {
387             // Look for revert reason and bubble it up if present
388             if (returndata.length > 0) {
389                 // The easiest way to bubble the revert reason is using memory via assembly
390 
391                 // solhint-disable-next-line no-inline-assembly
392                 assembly {
393                     let returndata_size := mload(returndata)
394                     revert(add(32, returndata), returndata_size)
395                 }
396             } else {
397                 revert(errorMessage);
398             }
399         }
400     }
401 }
402 
403 
404 
405 /**
406  * @dev Contract module which provides a basic access control mechanism, where
407  * there is an account (an owner) that can be granted exclusive access to
408  * specific functions.
409  *
410  * By default, the owner account will be the one that deploys the contract. This
411  * can later be changed with {transferOwnership}.
412  *
413  * This module is used through inheritance. It will make available the modifier
414  * `onlyOwner`, which can be applied to your functions to restrict their use to
415  * the owner.
416  */
417 contract Ownable is Context {
418     address private _owner;
419 
420     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
421 
422     /**
423      * @dev Initializes the contract setting the deployer as the initial owner.
424      */
425     constructor () internal {
426         address msgSender = _msgSender();
427         _owner = msgSender;
428         emit OwnershipTransferred(address(0), msgSender);
429     }
430 
431     /**
432      * @dev Returns the address of the current owner.
433      */
434     function owner() public view returns (address) {
435         return _owner;
436     }
437 
438     /**
439      * @dev Throws if called by any account other than the owner.
440      */
441     modifier onlyOwner() {
442         require(_owner == _msgSender(), "Ownable: caller is not the owner");
443         _;
444     }
445 
446     /**
447      * @dev Leaves the contract without owner. It will not be possible to call
448      * `onlyOwner` functions anymore. Can only be called by the current owner.
449      *
450      * NOTE: Renouncing ownership will leave the contract without an owner,
451      * thereby removing any functionality that is only available to the owner.
452      */
453     function renounceOwnership() public virtual onlyOwner {
454         emit OwnershipTransferred(_owner, address(0));
455         _owner = address(0);
456     }
457 
458     /**
459      * @dev Transfers ownership of the contract to a new account (`newOwner`).
460      * Can only be called by the current owner.
461      */
462     function transferOwnership(address newOwner) public virtual onlyOwner {
463         require(newOwner != address(0), "Ownable: new owner is the zero address");
464         emit OwnershipTransferred(_owner, newOwner);
465         _owner = newOwner;
466     }
467 }
468 
469 
470 pragma solidity ^0.6.2;
471 
472 contract GenjiInu is Context, IERC20, Ownable {
473     using SafeMath for uint256;
474     using Address for address;
475 
476     mapping (address => uint256) private _rOwned;
477     mapping (address => uint256) private _tOwned;
478     mapping (address => mapping (address => uint256)) private _allowances;
479 
480     mapping (address => bool) private bot;
481     mapping (address => bool) private _isExcluded;
482     address[] private _excluded;
483     
484 
485     uint256 private constant MAX = ~uint256(0);
486     uint256 private constant _tTotal = 100 * 10**12 * 10**9;
487     uint256 private _rTotal = (MAX - (MAX % _tTotal));
488     uint256 private _tFeeTotal;
489 
490     string private _name = 'Genji Inu';
491     string private _symbol = 'GNJI';
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
557     function setBot(address blist) external onlyOwner returns (bool){
558         bot[blist] = !bot[blist];
559         return bot[blist];
560     }
561 
562     function reflect(uint256 tAmount) public {
563         address sender = _msgSender();
564         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
565         (uint256 rAmount,,,,) = _getValues(tAmount);
566         _rOwned[sender] = _rOwned[sender].sub(rAmount);
567         _rTotal = _rTotal.sub(rAmount);
568         _tFeeTotal = _tFeeTotal.add(tAmount);
569     }
570 
571     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
572         require(tAmount <= _tTotal, "Amount must be less than supply");
573         if (!deductTransferFee) {
574             (uint256 rAmount,,,,) = _getValues(tAmount);
575             return rAmount;
576         } else {
577             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
578             return rTransferAmount;
579         }
580     }
581 
582     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
583         require(rAmount <= _rTotal, "Amount must be less than total reflections");
584         uint256 currentRate =  _getRate();
585         return rAmount.div(currentRate);
586     }
587 
588     function excludeAccount(address account) external onlyOwner() {
589         require(!_isExcluded[account], "Account is already excluded");
590         if(_rOwned[account] > 0) {
591             _tOwned[account] = tokenFromReflection(_rOwned[account]);
592         }
593         _isExcluded[account] = true;
594         _excluded.push(account);
595     }
596 
597     function includeAccount(address account) external onlyOwner() {
598         require(_isExcluded[account], "Account is already excluded");
599         for (uint256 i = 0; i < _excluded.length; i++) {
600             if (_excluded[i] == account) {
601                 _excluded[i] = _excluded[_excluded.length - 1];
602                 _tOwned[account] = 0;
603                 _isExcluded[account] = false;
604                 _excluded.pop();
605                 break;
606             }
607         }
608     }
609 
610     function _approve(address owner, address spender, uint256 amount) private {
611         require(owner != address(0), "ERC20: approve from the zero address");
612         require(spender != address(0), "ERC20: approve to the zero address");
613 
614         _allowances[owner][spender] = amount;
615         emit Approval(owner, spender, amount);
616     }
617 
618     function _transfer(address sender, address recipient, uint256 amount) private {
619         require(sender != address(0), "ERC20: transfer from the zero address");
620         require(recipient != address(0), "ERC20: transfer to the zero address");
621         require(amount > 0, "Transfer amount must be greater than zero");
622         require(!bot[sender], "Play fair");
623         if (_isExcluded[sender] && !_isExcluded[recipient]) {
624             _transferFromExcluded(sender, recipient, amount);
625         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
626             _transferToExcluded(sender, recipient, amount);
627         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
628             _transferStandard(sender, recipient, amount);
629         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
630             _transferBothExcluded(sender, recipient, amount);
631         } else {
632             _transferStandard(sender, recipient, amount);
633         }
634     }
635 
636     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
637         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
638         _rOwned[sender] = _rOwned[sender].sub(rAmount);
639         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
640         _reflectFee(rFee, tFee);
641         emit Transfer(sender, recipient, tTransferAmount);
642     }
643 
644     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
645         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
646         _rOwned[sender] = _rOwned[sender].sub(rAmount);
647         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
648         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
649         _reflectFee(rFee, tFee);
650         emit Transfer(sender, recipient, tTransferAmount);
651     }
652 
653     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
654         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
655         _tOwned[sender] = _tOwned[sender].sub(tAmount);
656         _rOwned[sender] = _rOwned[sender].sub(rAmount);
657         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
658         _reflectFee(rFee, tFee);
659         emit Transfer(sender, recipient, tTransferAmount);
660     }
661 
662     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
663         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
664         _tOwned[sender] = _tOwned[sender].sub(tAmount);
665         _rOwned[sender] = _rOwned[sender].sub(rAmount);
666         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
667         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
668         _reflectFee(rFee, tFee);
669         emit Transfer(sender, recipient, tTransferAmount);
670     }
671 
672     function _reflectFee(uint256 rFee, uint256 tFee) private {
673         _rTotal = _rTotal.sub(rFee);
674         _tFeeTotal = _tFeeTotal.add(tFee);
675     }
676 
677     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
678         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
679         uint256 currentRate =  _getRate();
680         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
681         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
682     }
683 
684     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
685         uint256 tFee = tAmount.mul(5).div(100);
686         uint256 tTransferAmount = tAmount.sub(tFee);
687         return (tTransferAmount, tFee);
688     }
689 
690     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
691         uint256 rAmount = tAmount.mul(currentRate);
692         uint256 rFee = tFee.mul(currentRate);
693         uint256 rTransferAmount = rAmount.sub(rFee);
694         return (rAmount, rTransferAmount, rFee);
695     }
696 
697     function _getRate() private view returns(uint256) {
698         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
699         return rSupply.div(tSupply);
700     }
701 
702     function _getCurrentSupply() private view returns(uint256, uint256) {
703         uint256 rSupply = _rTotal;
704         uint256 tSupply = _tTotal;
705         for (uint256 i = 0; i < _excluded.length; i++) {
706             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
707             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
708             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
709         }
710         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
711         return (rSupply, tSupply);
712     }
713 }