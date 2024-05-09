1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.2;
4 
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address payable) {
8         return payable(msg.sender);
9     }
10 
11     function _msgData() internal view virtual returns (bytes memory) {
12         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
13         return msg.data;
14     }
15 }
16 
17 /**
18  * @dev Interface of the BEP20 standard as defined in the EIP.
19  */
20 interface IBEP20 {
21     /**
22      * @dev Returns the amount of tokens in existence.
23      */
24     function totalSupply() external view returns (uint256);
25 
26     /**
27      * @dev Returns the amount of tokens owned by `account`.
28      */
29     function balanceOf(address account) external view returns (uint256);
30 
31     /**
32      * @dev Moves `amount` tokens from the caller's account to `recipient`.
33      *
34      * Returns a boolean value indicating whether the operation succeeded.
35      *
36      * Emits a {Transfer} event.
37      */
38     function transfer(address recipient, uint256 amount) external returns (bool);
39 
40     /**
41      * @dev Returns the remaining number of tokens that `spender` will be
42      * allowed to spend on behalf of `owner` through {transferFrom}. This is
43      * zero by default.
44      *
45      * This value changes when {approve} or {transferFrom} are called.
46      */
47     function allowance(address owner, address spender) external view returns (uint256);
48 
49     /**
50      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * IMPORTANT: Beware that changing an allowance with this method brings the risk
55      * that someone may use both the old and the new allowance by unfortunate
56      * transaction ordering. One possible solution to mitigate this race
57      * condition is to first reduce the spender's allowance to 0 and set the
58      * desired value afterwards:
59      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
60      *
61      * Emits an {Approval} event.
62      */
63     function approve(address spender, uint256 amount) external returns (bool);
64 
65     /**
66      * @dev Moves `amount` tokens from `sender` to `recipient` using the
67      * allowance mechanism. `amount` is then deducted from the caller's
68      * allowance.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * Emits a {Transfer} event.
73      */
74     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
75 
76     /**
77      * @dev Emitted when `value` tokens are moved from one account (`from`) to
78      * another (`to`).
79      *
80      * Note that `value` may be zero.
81      */
82     event Transfer(address indexed from, address indexed to, uint256 value);
83 
84     /**
85      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
86      * a call to {approve}. `value` is the new allowance.
87      */
88     event Approval(address indexed owner, address indexed spender, uint256 value);
89 }
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
385 /**
386  * @dev Contract module which provides a basic access control mechanism, where
387  * there is an account (an owner) that can be granted exclusive access to
388  * specific functions.
389  *
390  * By default, the owner account will be the one that deploys the contract. This
391  * can later be changed with {transferOwnership}.
392  *
393  * This module is used through inheritance. It will make available the modifier
394  * `onlyOwner`, which can be applied to your functions to restrict their use to
395  * the owner.
396  */
397 contract Ownable is Context {
398     address public _owner;
399 
400     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
401 
402 
403     /**
404      * @dev Returns the address of the current owner.
405      */
406     function owner() public view returns (address) {
407         return _owner;
408     }
409 
410     /**
411      * @dev Throws if called by any account other than the owner.
412      */
413     modifier onlyOwner() {
414         require(_owner == _msgSender(), "Ownable: caller is not the owner");
415         _;
416     }
417 
418     /**
419      * @dev Leaves the contract without owner. It will not be possible to call
420      * `onlyOwner` functions anymore. Can only be called by the current owner.
421      *
422      * NOTE: Renouncing ownership will leave the contract without an owner,
423      * thereby removing any functionality that is only available to the owner.
424      */
425     function renounceOwnership() public virtual onlyOwner {
426         emit OwnershipTransferred(_owner, address(0));
427         _owner = address(0);
428     }
429 
430     /**
431      * @dev Transfers ownership of the contract to a new account (`newOwner`).
432      * Can only be called by the current owner.
433      */
434     function transferOwnership(address newOwner) public virtual onlyOwner {
435         require(newOwner != address(0), "Ownable: new owner is the zero address");
436         emit OwnershipTransferred(_owner, newOwner);
437         _owner = newOwner;
438     }
439 }
440 
441 contract CoinToken is Context, IBEP20, Ownable {
442     using SafeMath for uint256;
443     using Address for address;
444 
445     mapping (address => uint256) private _rOwned;
446     mapping (address => uint256) private _tOwned;
447     mapping (address => mapping (address => uint256)) private _allowances;
448 
449     mapping (address => bool) private _isExcluded;
450     address[] private _excluded;
451     
452     string  private _NAME;
453     string  private _SYMBOL;
454     uint256   private _DECIMALS;
455 	address public FeeAddress;
456    
457     uint256 private _MAX = ~uint256(0);
458     uint256 private _DECIMALFACTOR;
459     uint256 private _GRANULARITY = 100;
460     
461     uint256 private _tTotal;
462     uint256 private _rTotal;
463     
464     uint256 private _tFeeTotal;
465     uint256 private _tBurnTotal;
466     uint256 private _tCharityTotal;
467     
468     uint256 public     _TAX_FEE;
469     uint256 public    _BURN_FEE;
470     uint256 public _CHARITY_FEE;
471 
472     // Track original fees to bypass fees for charity account
473     uint256 private ORIG_TAX_FEE;
474     uint256 private ORIG_BURN_FEE;
475     uint256 private ORIG_CHARITY_FEE;
476 
477     constructor (string memory _name, string memory _symbol, uint256 _decimals, uint256 _supply, uint256 _txFee,uint256 _burnFee,uint256 _charityFee,address _FeeAddress,address tokenOwner)  {
478 		_NAME = _name;
479 		_SYMBOL = _symbol;
480 		_DECIMALS = _decimals;
481 		_DECIMALFACTOR = 10 ** _DECIMALS;
482 		_tTotal =_supply * _DECIMALFACTOR;
483 		_rTotal = (_MAX - (_MAX % _tTotal));
484 		_TAX_FEE = _txFee* 100; 
485         _BURN_FEE = _burnFee * 100;
486 		_CHARITY_FEE = _charityFee* 100;
487 		ORIG_TAX_FEE = _TAX_FEE;
488 		ORIG_BURN_FEE = _BURN_FEE;
489 		ORIG_CHARITY_FEE = _CHARITY_FEE;
490 		FeeAddress = _FeeAddress;
491 		_owner = tokenOwner;
492         _rOwned[tokenOwner] = _rTotal;
493         emit Transfer(address(0),tokenOwner, _tTotal);
494     }
495 
496     function name() public view returns (string memory) {
497         return _NAME;
498     }
499 
500     function symbol() public view returns (string memory) {
501         return _SYMBOL;
502     }
503 
504     function decimals() public view returns (uint8) {
505         return uint8(_DECIMALS);
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
533         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "TOKEN20: transfer amount exceeds allowance"));
534         return true;
535     }
536 
537     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
538         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
539         return true;
540     }
541 
542     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
543         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "TOKEN20: decreased allowance below zero"));
544         return true;
545     }
546 
547     function isExcluded(address account) public view returns (bool) {
548         return _isExcluded[account];
549     }
550     
551 
552     function totalFees() public view returns (uint256) {
553         return _tFeeTotal;
554     }
555     
556     function totalBurn() public view returns (uint256) {
557         return _tBurnTotal;
558     }
559     
560     function totalCharity() public view returns (uint256) {
561         return _tCharityTotal;
562     }
563 
564     function deliver(uint256 tAmount) public {
565         address sender = _msgSender();
566         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
567         (uint256 rAmount,,,,,,) = _getValues(tAmount);
568         _rOwned[sender] = _rOwned[sender].sub(rAmount);
569         _rTotal = _rTotal.sub(rAmount);
570         _tFeeTotal = _tFeeTotal.add(tAmount);
571     }
572 
573     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
574         require(tAmount <= _tTotal, "Amount must be less than supply");
575         if (!deductTransferFee) {
576             (uint256 rAmount,,,,,,) = _getValues(tAmount);
577             return rAmount;
578         } else {
579             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
580             return rTransferAmount;
581         }
582     }
583 
584     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
585         require(rAmount <= _rTotal, "Amount must be less than total reflections");
586         uint256 currentRate =  _getRate();
587         return rAmount.div(currentRate);
588     }
589 
590     function excludeAccount(address account) external onlyOwner() {
591         require(!_isExcluded[account], "Account is already excluded");
592         if(_rOwned[account] > 0) {
593             _tOwned[account] = tokenFromReflection(_rOwned[account]);
594         }
595         _isExcluded[account] = true;
596         _excluded.push(account);
597     }
598 
599     function includeAccount(address account) external onlyOwner() {
600         require(_isExcluded[account], "Account is already included");
601         for (uint256 i = 0; i < _excluded.length; i++) {
602             if (_excluded[i] == account) {
603                 _excluded[i] = _excluded[_excluded.length - 1];
604                 _tOwned[account] = 0;
605                 _isExcluded[account] = false;
606                 _excluded.pop();
607                 break;
608             }
609         }
610     }
611 
612     function setAsCharityAccount(address account) external onlyOwner() {
613 		FeeAddress = account;
614     }
615 
616 	
617 	function updateFee(uint256 _txFee,uint256 _burnFee,uint256 _charityFee) onlyOwner() public{
618 		require(_txFee < 100 && _burnFee < 100 && _charityFee < 100);
619         _TAX_FEE = _txFee* 100; 
620         _BURN_FEE = _burnFee * 100;
621 		_CHARITY_FEE = _charityFee* 100;
622 		ORIG_TAX_FEE = _TAX_FEE;
623 		ORIG_BURN_FEE = _BURN_FEE;
624 		ORIG_CHARITY_FEE = _CHARITY_FEE;
625 	}
626 	
627 
628 
629 
630 
631     function _approve(address owner, address spender, uint256 amount) private {
632         require(owner != address(0), "TOKEN20: approve from the zero address");
633         require(spender != address(0), "TOKEN20: approve to the zero address");
634 
635         _allowances[owner][spender] = amount;
636         emit Approval(owner, spender, amount);
637     }
638 
639     function _transfer(address sender, address recipient, uint256 amount) private {
640         require(sender != address(0), "TOKEN20: transfer from the zero address");
641         require(recipient != address(0), "TOKEN20: transfer to the zero address");
642         require(amount > 0, "Transfer amount must be greater than zero");
643 
644         // Remove fees for transfers to and from charity account or to excluded account
645         bool takeFee = true;
646         if (FeeAddress == sender || FeeAddress == recipient || _isExcluded[recipient]) {
647             takeFee = false;
648         }
649 
650         if (!takeFee) removeAllFee();
651         
652         
653         if (_isExcluded[sender] && !_isExcluded[recipient]) {
654             _transferFromExcluded(sender, recipient, amount);
655         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
656             _transferToExcluded(sender, recipient, amount);
657         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
658             _transferStandard(sender, recipient, amount);
659         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
660             _transferBothExcluded(sender, recipient, amount);
661         } else {
662             _transferStandard(sender, recipient, amount);
663         }
664 
665         if (!takeFee) restoreAllFee();
666     }
667 
668     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
669         uint256 currentRate =  _getRate();
670         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tCharity) = _getValues(tAmount);
671         uint256 rBurn =  tBurn.mul(currentRate);
672         _standardTransferContent(sender, recipient, rAmount, rTransferAmount);
673         _sendToCharity(tCharity, sender);
674         _reflectFee(rFee, rBurn, tFee, tBurn, tCharity);
675         emit Transfer(sender, recipient, tTransferAmount);
676     }
677     
678     function _standardTransferContent(address sender, address recipient, uint256 rAmount, uint256 rTransferAmount) private {
679         _rOwned[sender] = _rOwned[sender].sub(rAmount);
680         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
681     }
682     
683     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
684         uint256 currentRate =  _getRate();
685         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tCharity) = _getValues(tAmount);
686         uint256 rBurn =  tBurn.mul(currentRate);
687         _excludedFromTransferContent(sender, recipient, tTransferAmount, rAmount, rTransferAmount);        
688         _sendToCharity(tCharity, sender);
689         _reflectFee(rFee, rBurn, tFee, tBurn, tCharity);
690         emit Transfer(sender, recipient, tTransferAmount);
691     }
692     
693     function _excludedFromTransferContent(address sender, address recipient, uint256 tTransferAmount, uint256 rAmount, uint256 rTransferAmount) private {
694         _rOwned[sender] = _rOwned[sender].sub(rAmount);
695         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
696         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
697     }
698     
699 
700     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
701         uint256 currentRate =  _getRate();
702         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tCharity) = _getValues(tAmount);
703         uint256 rBurn =  tBurn.mul(currentRate);
704         _excludedToTransferContent(sender, recipient, tAmount, rAmount, rTransferAmount);
705         _sendToCharity(tCharity, sender);
706         _reflectFee(rFee, rBurn, tFee, tBurn, tCharity);
707         emit Transfer(sender, recipient, tTransferAmount);
708     }
709     
710     function _excludedToTransferContent(address sender, address recipient, uint256 tAmount, uint256 rAmount, uint256 rTransferAmount) private {
711         _tOwned[sender] = _tOwned[sender].sub(tAmount);
712         _rOwned[sender] = _rOwned[sender].sub(rAmount);
713         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);  
714     }
715 
716     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
717         uint256 currentRate =  _getRate();
718         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tCharity) = _getValues(tAmount);
719         uint256 rBurn =  tBurn.mul(currentRate);
720         _bothTransferContent(sender, recipient, tAmount, rAmount, tTransferAmount, rTransferAmount);  
721         _sendToCharity(tCharity, sender);
722         _reflectFee(rFee, rBurn, tFee, tBurn, tCharity);
723         emit Transfer(sender, recipient, tTransferAmount);
724     }
725     
726     function _bothTransferContent(address sender, address recipient, uint256 tAmount, uint256 rAmount, uint256 tTransferAmount, uint256 rTransferAmount) private {
727         _tOwned[sender] = _tOwned[sender].sub(tAmount);
728         _rOwned[sender] = _rOwned[sender].sub(rAmount);
729         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
730         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);  
731     }
732 
733     function _reflectFee(uint256 rFee, uint256 rBurn, uint256 tFee, uint256 tBurn, uint256 tCharity) private {
734         _rTotal = _rTotal.sub(rFee).sub(rBurn);
735         _tFeeTotal = _tFeeTotal.add(tFee);
736         _tBurnTotal = _tBurnTotal.add(tBurn);
737         _tCharityTotal = _tCharityTotal.add(tCharity);
738         _tTotal = _tTotal.sub(tBurn);
739 		emit Transfer(address(this), address(0), tBurn);
740     }
741     
742 
743     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
744         (uint256 tFee, uint256 tBurn, uint256 tCharity) = _getTBasics(tAmount, _TAX_FEE, _BURN_FEE, _CHARITY_FEE);
745         uint256 tTransferAmount = getTTransferAmount(tAmount, tFee, tBurn, tCharity);
746         uint256 currentRate =  _getRate();
747         (uint256 rAmount, uint256 rFee) = _getRBasics(tAmount, tFee, currentRate);
748         uint256 rTransferAmount = _getRTransferAmount(rAmount, rFee, tBurn, tCharity, currentRate);
749         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBurn, tCharity);
750     }
751     
752     function _getTBasics(uint256 tAmount, uint256 taxFee, uint256 burnFee, uint256 charityFee) private view returns (uint256, uint256, uint256) {
753         uint256 tFee = ((tAmount.mul(taxFee)).div(_GRANULARITY)).div(100);
754         uint256 tBurn = ((tAmount.mul(burnFee)).div(_GRANULARITY)).div(100);
755         uint256 tCharity = ((tAmount.mul(charityFee)).div(_GRANULARITY)).div(100);
756         return (tFee, tBurn, tCharity);
757     }
758     
759     function getTTransferAmount(uint256 tAmount, uint256 tFee, uint256 tBurn, uint256 tCharity) private pure returns (uint256) {
760         return tAmount.sub(tFee).sub(tBurn).sub(tCharity);
761     }
762     
763     function _getRBasics(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256) {
764         uint256 rAmount = tAmount.mul(currentRate);
765         uint256 rFee = tFee.mul(currentRate);
766         return (rAmount, rFee);
767     }
768     
769     function _getRTransferAmount(uint256 rAmount, uint256 rFee, uint256 tBurn, uint256 tCharity, uint256 currentRate) private pure returns (uint256) {
770         uint256 rBurn = tBurn.mul(currentRate);
771         uint256 rCharity = tCharity.mul(currentRate);
772         uint256 rTransferAmount = rAmount.sub(rFee).sub(rBurn).sub(rCharity);
773         return rTransferAmount;
774     }
775 
776     function _getRate() private view returns(uint256) {
777         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
778         return rSupply.div(tSupply);
779     }
780 
781     function _getCurrentSupply() private view returns(uint256, uint256) {
782         uint256 rSupply = _rTotal;
783         uint256 tSupply = _tTotal;      
784         for (uint256 i = 0; i < _excluded.length; i++) {
785             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
786             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
787             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
788         }
789         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
790         return (rSupply, tSupply);
791     }
792 
793     function _sendToCharity(uint256 tCharity, address sender) private {
794         uint256 currentRate = _getRate();
795         uint256 rCharity = tCharity.mul(currentRate);
796         _rOwned[FeeAddress] = _rOwned[FeeAddress].add(rCharity);
797         _tOwned[FeeAddress] = _tOwned[FeeAddress].add(tCharity);
798         emit Transfer(sender, FeeAddress, tCharity);
799     }
800 
801     function removeAllFee() private {
802         if(_TAX_FEE == 0 && _BURN_FEE == 0 && _CHARITY_FEE == 0) return;
803         
804         ORIG_TAX_FEE = _TAX_FEE;
805         ORIG_BURN_FEE = _BURN_FEE;
806         ORIG_CHARITY_FEE = _CHARITY_FEE;
807         
808         _TAX_FEE = 0;
809         _BURN_FEE = 0;
810         _CHARITY_FEE = 0;
811     }
812     
813     function restoreAllFee() private {
814         _TAX_FEE = ORIG_TAX_FEE;
815         _BURN_FEE = ORIG_BURN_FEE;
816         _CHARITY_FEE = ORIG_CHARITY_FEE;
817     }
818     
819     function _getTaxFee() private view returns(uint256) {
820         return _TAX_FEE;
821     }
822 
823 
824 }