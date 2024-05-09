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
450     mapping (address => bool) private _isCharity;
451     address[] private _excluded;
452     
453     string  private _NAME;
454     string  private _SYMBOL;
455     uint256   private _DECIMALS;
456 	address public FeeAddress;
457    
458     uint256 private _MAX = ~uint256(0);
459     uint256 private _DECIMALFACTOR;
460     uint256 private _GRANULARITY = 100;
461     
462     uint256 private _tTotal;
463     uint256 private _rTotal;
464     
465     uint256 private _tFeeTotal;
466     uint256 private _tBurnTotal;
467     uint256 private _tCharityTotal;
468     
469     uint256 public     _TAX_FEE;
470     uint256 public    _BURN_FEE;
471     uint256 public _CHARITY_FEE;
472 
473     // Track original fees to bypass fees for charity account
474     uint256 private ORIG_TAX_FEE;
475     uint256 private ORIG_BURN_FEE;
476     uint256 private ORIG_CHARITY_FEE;
477 
478     constructor (string memory _name, string memory _symbol, uint256 _decimals, uint256 _supply, uint256 _txFee,uint256 _burnFee,uint256 _charityFee,address _FeeAddress,address tokenOwner)  {
479 		_NAME = _name;
480 		_SYMBOL = _symbol;
481 		_DECIMALS = _decimals;
482 		_DECIMALFACTOR = 10 ** uint256(_DECIMALS);
483 		_tTotal =_supply * _DECIMALFACTOR;
484 		_rTotal = (_MAX - (_MAX % _tTotal));
485 		_TAX_FEE = _txFee* 100; 
486         _BURN_FEE = _burnFee * 100;
487 		_CHARITY_FEE = _charityFee* 100;
488 		ORIG_TAX_FEE = _TAX_FEE;
489 		ORIG_BURN_FEE = _BURN_FEE;
490 		ORIG_CHARITY_FEE = _CHARITY_FEE;
491 		_isCharity[_FeeAddress] = true;
492 		FeeAddress = _FeeAddress;
493 		_owner = tokenOwner;
494         _rOwned[tokenOwner] = _rTotal;
495         emit Transfer(address(0),tokenOwner, _tTotal);
496     }
497 
498     function name() public view returns (string memory) {
499         return _NAME;
500     }
501 
502     function symbol() public view returns (string memory) {
503         return _SYMBOL;
504     }
505 
506     function decimals() public view returns (uint256) {
507         return _DECIMALS;
508     }
509 
510     function totalSupply() public view override returns (uint256) {
511         return _tTotal;
512     }
513 
514     function balanceOf(address account) public view override returns (uint256) {
515         if (_isExcluded[account]) return _tOwned[account];
516         return tokenFromReflection(_rOwned[account]);
517     }
518 
519     function transfer(address recipient, uint256 amount) public override returns (bool) {
520         _transfer(_msgSender(), recipient, amount);
521         return true;
522     }
523 
524     function allowance(address owner, address spender) public view override returns (uint256) {
525         return _allowances[owner][spender];
526     }
527 
528     function approve(address spender, uint256 amount) public override returns (bool) {
529         _approve(_msgSender(), spender, amount);
530         return true;
531     }
532 
533     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
534         _transfer(sender, recipient, amount);
535         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "TOKEN20: transfer amount exceeds allowance"));
536         return true;
537     }
538 
539     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
540         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
541         return true;
542     }
543 
544     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
545         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "TOKEN20: decreased allowance below zero"));
546         return true;
547     }
548 
549     function isExcluded(address account) public view returns (bool) {
550         return _isExcluded[account];
551     }
552     
553     function isCharity(address account) public view returns (bool) {
554         return _isCharity[account];
555     }
556 
557     function totalFees() public view returns (uint256) {
558         return _tFeeTotal;
559     }
560     
561     function totalBurn() public view returns (uint256) {
562         return _tBurnTotal;
563     }
564     
565     function totalCharity() public view returns (uint256) {
566         return _tCharityTotal;
567     }
568 
569     function deliver(uint256 tAmount) public {
570         address sender = _msgSender();
571         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
572         (uint256 rAmount,,,,,,) = _getValues(tAmount);
573         _rOwned[sender] = _rOwned[sender].sub(rAmount);
574         _rTotal = _rTotal.sub(rAmount);
575         _tFeeTotal = _tFeeTotal.add(tAmount);
576     }
577 
578     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
579         require(tAmount <= _tTotal, "Amount must be less than supply");
580         if (!deductTransferFee) {
581             (uint256 rAmount,,,,,,) = _getValues(tAmount);
582             return rAmount;
583         } else {
584             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
585             return rTransferAmount;
586         }
587     }
588 
589     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
590         require(rAmount <= _rTotal, "Amount must be less than total reflections");
591         uint256 currentRate =  _getRate();
592         return rAmount.div(currentRate);
593     }
594 
595     function excludeAccount(address account) external onlyOwner() {
596         require(!_isExcluded[account], "Account is already excluded");
597         if(_rOwned[account] > 0) {
598             _tOwned[account] = tokenFromReflection(_rOwned[account]);
599         }
600         _isExcluded[account] = true;
601         _excluded.push(account);
602     }
603 
604     function includeAccount(address account) external onlyOwner() {
605         require(_isExcluded[account], "Account is already excluded");
606         for (uint256 i = 0; i < _excluded.length; i++) {
607             if (_excluded[i] == account) {
608                 _excluded[i] = _excluded[_excluded.length - 1];
609                 _tOwned[account] = 0;
610                 _isExcluded[account] = false;
611                 _excluded.pop();
612                 break;
613             }
614         }
615     }
616 
617     function setAsCharityAccount(address account) external onlyOwner() {
618         require(!_isCharity[account], "Account is already charity account");
619         _isCharity[account] = true;
620 		FeeAddress = account;
621     }
622 
623 
624 	
625 	function updateFee(uint256 _txFee,uint256 _burnFee,uint256 _charityFee) onlyOwner() public{
626         _TAX_FEE = _txFee* 100; 
627         _BURN_FEE = _burnFee * 100;
628 		_CHARITY_FEE = _charityFee* 100;
629 		ORIG_TAX_FEE = _TAX_FEE;
630 		ORIG_BURN_FEE = _BURN_FEE;
631 		ORIG_CHARITY_FEE = _CHARITY_FEE;
632 	}
633 	
634 
635 
636 
637 
638     function _approve(address owner, address spender, uint256 amount) private {
639         require(owner != address(0), "TOKEN20: approve from the zero address");
640         require(spender != address(0), "TOKEN20: approve to the zero address");
641 
642         _allowances[owner][spender] = amount;
643         emit Approval(owner, spender, amount);
644     }
645 
646     function _transfer(address sender, address recipient, uint256 amount) private {
647         require(sender != address(0), "TOKEN20: transfer from the zero address");
648         require(recipient != address(0), "TOKEN20: transfer to the zero address");
649         require(amount > 0, "Transfer amount must be greater than zero");
650 
651         // Remove fees for transfers to and from charity account or to excluded account
652         bool takeFee = true;
653         if (_isCharity[sender] || _isCharity[recipient] || _isExcluded[recipient]) {
654             takeFee = false;
655         }
656 
657         if (!takeFee) removeAllFee();
658         
659         
660         if (_isExcluded[sender] && !_isExcluded[recipient]) {
661             _transferFromExcluded(sender, recipient, amount);
662         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
663             _transferToExcluded(sender, recipient, amount);
664         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
665             _transferStandard(sender, recipient, amount);
666         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
667             _transferBothExcluded(sender, recipient, amount);
668         } else {
669             _transferStandard(sender, recipient, amount);
670         }
671 
672         if (!takeFee) restoreAllFee();
673     }
674 
675     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
676         uint256 currentRate =  _getRate();
677         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tCharity) = _getValues(tAmount);
678         uint256 rBurn =  tBurn.mul(currentRate);
679         uint256 rCharity = tCharity.mul(currentRate);     
680         _standardTransferContent(sender, recipient, rAmount, rTransferAmount);
681         _sendToCharity(tCharity, sender);
682         _reflectFee(rFee, rBurn, rCharity, tFee, tBurn, tCharity);
683         emit Transfer(sender, recipient, tTransferAmount);
684     }
685     
686     function _standardTransferContent(address sender, address recipient, uint256 rAmount, uint256 rTransferAmount) private {
687         _rOwned[sender] = _rOwned[sender].sub(rAmount);
688         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
689     }
690     
691     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
692         uint256 currentRate =  _getRate();
693         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tCharity) = _getValues(tAmount);
694         uint256 rBurn =  tBurn.mul(currentRate);
695         uint256 rCharity = tCharity.mul(currentRate);
696         _excludedFromTransferContent(sender, recipient, tTransferAmount, rAmount, rTransferAmount);        
697         _sendToCharity(tCharity, sender);
698         _reflectFee(rFee, rBurn, rCharity, tFee, tBurn, tCharity);
699         emit Transfer(sender, recipient, tTransferAmount);
700     }
701     
702     function _excludedFromTransferContent(address sender, address recipient, uint256 tTransferAmount, uint256 rAmount, uint256 rTransferAmount) private {
703         _rOwned[sender] = _rOwned[sender].sub(rAmount);
704         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
705         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
706     }
707     
708 
709     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
710         uint256 currentRate =  _getRate();
711         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tCharity) = _getValues(tAmount);
712         uint256 rBurn =  tBurn.mul(currentRate);
713         uint256 rCharity = tCharity.mul(currentRate);
714         _excludedToTransferContent(sender, recipient, tAmount, rAmount, rTransferAmount);
715         _sendToCharity(tCharity, sender);
716         _reflectFee(rFee, rBurn, rCharity, tFee, tBurn, tCharity);
717         emit Transfer(sender, recipient, tTransferAmount);
718     }
719     
720     function _excludedToTransferContent(address sender, address recipient, uint256 tAmount, uint256 rAmount, uint256 rTransferAmount) private {
721         _tOwned[sender] = _tOwned[sender].sub(tAmount);
722         _rOwned[sender] = _rOwned[sender].sub(rAmount);
723         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);  
724     }
725 
726     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
727         uint256 currentRate =  _getRate();
728         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tCharity) = _getValues(tAmount);
729         uint256 rBurn =  tBurn.mul(currentRate);
730         uint256 rCharity = tCharity.mul(currentRate);    
731         _bothTransferContent(sender, recipient, tAmount, rAmount, tTransferAmount, rTransferAmount);  
732         _sendToCharity(tCharity, sender);
733         _reflectFee(rFee, rBurn, rCharity, tFee, tBurn, tCharity);
734         emit Transfer(sender, recipient, tTransferAmount);
735     }
736     
737     function _bothTransferContent(address sender, address recipient, uint256 tAmount, uint256 rAmount, uint256 tTransferAmount, uint256 rTransferAmount) private {
738         _tOwned[sender] = _tOwned[sender].sub(tAmount);
739         _rOwned[sender] = _rOwned[sender].sub(rAmount);
740         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
741         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);  
742     }
743 
744     function _reflectFee(uint256 rFee, uint256 rBurn, uint256 rCharity, uint256 tFee, uint256 tBurn, uint256 tCharity) private {
745         _rTotal = _rTotal.sub(rFee).sub(rBurn).sub(rCharity);
746         _tFeeTotal = _tFeeTotal.add(tFee);
747         _tBurnTotal = _tBurnTotal.add(tBurn);
748         _tCharityTotal = _tCharityTotal.add(tCharity);
749         _tTotal = _tTotal.sub(tBurn);
750 		emit Transfer(address(this), address(0), tBurn);
751     }
752     
753 
754     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
755         (uint256 tFee, uint256 tBurn, uint256 tCharity) = _getTBasics(tAmount, _TAX_FEE, _BURN_FEE, _CHARITY_FEE);
756         uint256 tTransferAmount = getTTransferAmount(tAmount, tFee, tBurn, tCharity);
757         uint256 currentRate =  _getRate();
758         (uint256 rAmount, uint256 rFee) = _getRBasics(tAmount, tFee, currentRate);
759         uint256 rTransferAmount = _getRTransferAmount(rAmount, rFee, tBurn, tCharity, currentRate);
760         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBurn, tCharity);
761     }
762     
763     function _getTBasics(uint256 tAmount, uint256 taxFee, uint256 burnFee, uint256 charityFee) private view returns (uint256, uint256, uint256) {
764         uint256 tFee = ((tAmount.mul(taxFee)).div(_GRANULARITY)).div(100);
765         uint256 tBurn = ((tAmount.mul(burnFee)).div(_GRANULARITY)).div(100);
766         uint256 tCharity = ((tAmount.mul(charityFee)).div(_GRANULARITY)).div(100);
767         return (tFee, tBurn, tCharity);
768     }
769     
770     function getTTransferAmount(uint256 tAmount, uint256 tFee, uint256 tBurn, uint256 tCharity) private pure returns (uint256) {
771         return tAmount.sub(tFee).sub(tBurn).sub(tCharity);
772     }
773     
774     function _getRBasics(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256) {
775         uint256 rAmount = tAmount.mul(currentRate);
776         uint256 rFee = tFee.mul(currentRate);
777         return (rAmount, rFee);
778     }
779     
780     function _getRTransferAmount(uint256 rAmount, uint256 rFee, uint256 tBurn, uint256 tCharity, uint256 currentRate) private pure returns (uint256) {
781         uint256 rBurn = tBurn.mul(currentRate);
782         uint256 rCharity = tCharity.mul(currentRate);
783         uint256 rTransferAmount = rAmount.sub(rFee).sub(rBurn).sub(rCharity);
784         return rTransferAmount;
785     }
786 
787     function _getRate() private view returns(uint256) {
788         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
789         return rSupply.div(tSupply);
790     }
791 
792     function _getCurrentSupply() private view returns(uint256, uint256) {
793         uint256 rSupply = _rTotal;
794         uint256 tSupply = _tTotal;      
795         for (uint256 i = 0; i < _excluded.length; i++) {
796             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
797             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
798             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
799         }
800         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
801         return (rSupply, tSupply);
802     }
803 
804     function _sendToCharity(uint256 tCharity, address sender) private {
805         uint256 currentRate = _getRate();
806         uint256 rCharity = tCharity.mul(currentRate);
807         _rOwned[FeeAddress] = _rOwned[FeeAddress].add(rCharity);
808         _tOwned[FeeAddress] = _tOwned[FeeAddress].add(tCharity);
809         emit Transfer(sender, FeeAddress, tCharity);
810     }
811 
812     function removeAllFee() private {
813         if(_TAX_FEE == 0 && _BURN_FEE == 0 && _CHARITY_FEE == 0) return;
814         
815         ORIG_TAX_FEE = _TAX_FEE;
816         ORIG_BURN_FEE = _BURN_FEE;
817         ORIG_CHARITY_FEE = _CHARITY_FEE;
818         
819         _TAX_FEE = 0;
820         _BURN_FEE = 0;
821         _CHARITY_FEE = 0;
822     }
823     
824     function restoreAllFee() private {
825         _TAX_FEE = ORIG_TAX_FEE;
826         _BURN_FEE = ORIG_BURN_FEE;
827         _CHARITY_FEE = ORIG_CHARITY_FEE;
828     }
829     
830     function _getTaxFee() private view returns(uint256) {
831         return _TAX_FEE;
832     }
833 
834 
835 }