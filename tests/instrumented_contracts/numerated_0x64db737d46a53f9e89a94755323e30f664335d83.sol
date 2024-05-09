1 pragma solidity ^0.8.2;
2 
3 // SPDX-License-Identifier: MIT
4 
5 abstract contract Context {
6     function _msgSender() internal view virtual returns (address payable) {
7         return payable(msg.sender);
8     }
9 
10     function _msgData() internal view virtual returns (bytes memory) {
11         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
12         return msg.data;
13     }
14 }
15 
16 /**
17  * @dev Interface of the BEP20 standard as defined in the EIP.
18  */
19 interface IBEP20 {
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
90 /**
91  * @dev Wrappers over Solidity's arithmetic operations with added overflow
92  * checks.
93  *
94  * Arithmetic operations in Solidity wrap on overflow. This can easily result
95  * in bugs, because programmers usually assume that an overflow raises an
96  * error, which is the standard behavior in high level programming languages.
97  * `SafeMath` restores this intuition by reverting the transaction when an
98  * operation overflows.
99  *
100  * Using this library instead of the unchecked operations eliminates an entire
101  * class of bugs, so it's recommended to use it always.
102  */
103 library SafeMath {
104     /**
105      * @dev Returns the addition of two unsigned integers, reverting on
106      * overflow.
107      *
108      * Counterpart to Solidity's `+` operator.
109      *
110      * Requirements:
111      *
112      * - Addition cannot overflow.
113      */
114     function add(uint256 a, uint256 b) internal pure returns (uint256) {
115         uint256 c = a + b;
116         require(c >= a, "SafeMath: addition overflow");
117 
118         return c;
119     }
120 
121     /**
122      * @dev Returns the subtraction of two unsigned integers, reverting on
123      * overflow (when the result is negative).
124      *
125      * Counterpart to Solidity's `-` operator.
126      *
127      * Requirements:
128      *
129      * - Subtraction cannot overflow.
130      */
131     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
132         return sub(a, b, "SafeMath: subtraction overflow");
133     }
134 
135     /**
136      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
137      * overflow (when the result is negative).
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      *
143      * - Subtraction cannot overflow.
144      */
145     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
146         require(b <= a, errorMessage);
147         uint256 c = a - b;
148 
149         return c;
150     }
151 
152     /**
153      * @dev Returns the multiplication of two unsigned integers, reverting on
154      * overflow.
155      *
156      * Counterpart to Solidity's `*` operator.
157      *
158      * Requirements:
159      *
160      * - Multiplication cannot overflow.
161      */
162     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
163         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
164         // benefit is lost if 'b' is also tested.
165         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
166         if (a == 0) {
167             return 0;
168         }
169 
170         uint256 c = a * b;
171         require(c / a == b, "SafeMath: multiplication overflow");
172 
173         return c;
174     }
175 
176     /**
177      * @dev Returns the integer division of two unsigned integers. Reverts on
178      * division by zero. The result is rounded towards zero.
179      *
180      * Counterpart to Solidity's `/` operator. Note: this function uses a
181      * `revert` opcode (which leaves remaining gas untouched) while Solidity
182      * uses an invalid opcode to revert (consuming all remaining gas).
183      *
184      * Requirements:
185      *
186      * - The divisor cannot be zero.
187      */
188     function div(uint256 a, uint256 b) internal pure returns (uint256) {
189         return div(a, b, "SafeMath: division by zero");
190     }
191 
192     /**
193      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
194      * division by zero. The result is rounded towards zero.
195      *
196      * Counterpart to Solidity's `/` operator. Note: this function uses a
197      * `revert` opcode (which leaves remaining gas untouched) while Solidity
198      * uses an invalid opcode to revert (consuming all remaining gas).
199      *
200      * Requirements:
201      *
202      * - The divisor cannot be zero.
203      */
204     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
205         require(b > 0, errorMessage);
206         uint256 c = a / b;
207         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
208 
209         return c;
210     }
211 
212     /**
213      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
214      * Reverts when dividing by zero.
215      *
216      * Counterpart to Solidity's `%` operator. This function uses a `revert`
217      * opcode (which leaves remaining gas untouched) while Solidity uses an
218      * invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
225         return mod(a, b, "SafeMath: modulo by zero");
226     }
227 
228     /**
229      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230      * Reverts with custom message when dividing by zero.
231      *
232      * Counterpart to Solidity's `%` operator. This function uses a `revert`
233      * opcode (which leaves remaining gas untouched) while Solidity uses an
234      * invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      *
238      * - The divisor cannot be zero.
239      */
240     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
241         require(b != 0, errorMessage);
242         return a % b;
243     }
244 }
245 
246 /**
247  * @dev Collection of functions related to the address type
248  */
249 library Address {
250     /**
251      * @dev Returns true if `account` is a contract.
252      *
253      * [IMPORTANT]
254      * ====
255      * It is unsafe to assume that an address for which this function returns
256      * false is an externally-owned account (EOA) and not a contract.
257      *
258      * Among others, `isContract` will return false for the following
259      * types of addresses:
260      *
261      *  - an externally-owned account
262      *  - a contract in construction
263      *  - an address where a contract will be created
264      *  - an address where a contract lived, but was destroyed
265      * ====
266      */
267     function isContract(address account) internal view returns (bool) {
268         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
269         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
270         // for accounts without code, i.e. `keccak256('')`
271         bytes32 codehash;
272         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
273         // solhint-disable-next-line no-inline-assembly
274         assembly { codehash := extcodehash(account) }
275         return (codehash != accountHash && codehash != 0x0);
276     }
277 
278     /**
279      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
280      * `recipient`, forwarding all available gas and reverting on errors.
281      *
282      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
283      * of certain opcodes, possibly making contracts go over the 2300 gas limit
284      * imposed by `transfer`, making them unable to receive funds via
285      * `transfer`. {sendValue} removes this limitation.
286      *
287      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
288      *
289      * IMPORTANT: because control is transferred to `recipient`, care must be
290      * taken to not create reentrancy vulnerabilities. Consider using
291      * {ReentrancyGuard} or the
292      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
293      */
294     function sendValue(address payable recipient, uint256 amount) internal {
295         require(address(this).balance >= amount, "Address: insufficient balance");
296 
297         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
298         (bool success, ) = recipient.call{ value: amount }("");
299         require(success, "Address: unable to send value, recipient may have reverted");
300     }
301 
302     /**
303      * @dev Performs a Solidity function call using a low level `call`. A
304      * plain`call` is an unsafe replacement for a function call: use this
305      * function instead.
306      *
307      * If `target` reverts with a revert reason, it is bubbled up by this
308      * function (like regular Solidity function calls).
309      *
310      * Returns the raw returned data. To convert to the expected return value,
311      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
312      *
313      * Requirements:
314      *
315      * - `target` must be a contract.
316      * - calling `target` with `data` must not revert.
317      *
318      * _Available since v3.1._
319      */
320     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
321       return functionCall(target, data, "Address: low-level call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
326      * `errorMessage` as a fallback revert reason when `target` reverts.
327      *
328      * _Available since v3.1._
329      */
330     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
331         return _functionCallWithValue(target, data, 0, errorMessage);
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
336      * but also transferring `value` wei to `target`.
337      *
338      * Requirements:
339      *
340      * - the calling contract must have an ETH balance of at least `value`.
341      * - the called Solidity function must be `payable`.
342      *
343      * _Available since v3.1._
344      */
345     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
346         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
351      * with `errorMessage` as a fallback revert reason when `target` reverts.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
356         require(address(this).balance >= value, "Address: insufficient balance for call");
357         return _functionCallWithValue(target, data, value, errorMessage);
358     }
359 
360     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
361         require(isContract(target), "Address: call to non-contract");
362 
363         // solhint-disable-next-line avoid-low-level-calls
364         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
365         if (success) {
366             return returndata;
367         } else {
368             // Look for revert reason and bubble it up if present
369             if (returndata.length > 0) {
370                 // The easiest way to bubble the revert reason is using memory via assembly
371 
372                 // solhint-disable-next-line no-inline-assembly
373                 assembly {
374                     let returndata_size := mload(returndata)
375                     revert(add(32, returndata), returndata_size)
376                 }
377             } else {
378                 revert(errorMessage);
379             }
380         }
381     }
382 }
383 
384 /**
385  * @dev Contract module which provides a basic access control mechanism, where
386  * there is an account (an owner) that can be granted exclusive access to
387  * specific functions.
388  *
389  * By default, the owner account will be the one that deploys the contract. This
390  * can later be changed with {transferOwnership}.
391  *
392  * This module is used through inheritance. It will make available the modifier
393  * `onlyOwner`, which can be applied to your functions to restrict their use to
394  * the owner.
395  */
396 contract Ownable is Context {
397     address private _owner;
398 
399     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
400 
401     /**
402      * @dev Initializes the contract setting the deployer as the initial owner.
403      */
404     constructor () {
405         address msgSender = _msgSender();
406         _owner = msgSender;
407         emit OwnershipTransferred(address(0), msgSender);
408     }
409 
410     /**
411      * @dev Returns the address of the current owner.
412      */
413     function owner() public view returns (address) {
414         return _owner;
415     }
416 
417     /**
418      * @dev Throws if called by any account other than the owner.
419      */
420     modifier onlyOwner() {
421         require(_owner == _msgSender(), "Ownable: caller is not the owner");
422         _;
423     }
424 
425     /**
426      * @dev Leaves the contract without owner. It will not be possible to call
427      * `onlyOwner` functions anymore. Can only be called by the current owner.
428      *
429      * NOTE: Renouncing ownership will leave the contract without an owner,
430      * thereby removing any functionality that is only available to the owner.
431      */
432     function renounceOwnership() public virtual onlyOwner {
433         emit OwnershipTransferred(_owner, address(0));
434         _owner = address(0);
435     }
436 
437     /**
438      * @dev Transfers ownership of the contract to a new account (`newOwner`).
439      * Can only be called by the current owner.
440      */
441     function transferOwnership(address newOwner) public virtual onlyOwner {
442         require(newOwner != address(0), "Ownable: new owner is the zero address");
443         emit OwnershipTransferred(_owner, newOwner);
444         _owner = newOwner;
445     }
446 }
447 
448 contract CubanDoge is Context, IBEP20, Ownable {
449     using SafeMath for uint256;
450     using Address for address;
451 
452     mapping (address => uint256) private _rOwned;
453     mapping (address => uint256) private _tOwned;
454     mapping (address => mapping (address => uint256)) private _allowances;
455 
456     mapping (address => bool) private _isExcluded;
457     mapping (address => bool) private _isCharity;
458     address[] private _excluded;
459     address[] private _charity;
460     
461     string  private constant _NAME = 'Cuban Doge';
462     string  private constant _SYMBOL = 'CDOGE';
463     uint8   private constant _DECIMALS = 9;
464    
465     uint256 private constant _MAX = ~uint256(0);
466     uint256 private constant _DECIMALFACTOR = 10 ** uint256(_DECIMALS);
467     uint256 private constant _GRANULARITY = 100;
468     
469     uint256 private _tTotal = 100000000000 * _DECIMALFACTOR;
470     uint256 private _rTotal = (_MAX - (_MAX % _tTotal));
471     
472     uint256 private _tFeeTotal;
473     uint256 private _tBurnTotal;
474     uint256 private _tCharityTotal;
475     
476     uint256 private     _TAX_FEE = 100; // 1% BACK TO HOLDERS
477     uint256 private    _BURN_FEE = 100; // 1% BURNED
478     uint256 private _CHARITY_FEE = 300; // 3% TO CHARITY WALLET
479     uint256 private constant _MAX_TX_SIZE = 100000000000 * _DECIMALFACTOR;
480 
481     // Track original fees to bypass fees for charity account
482     uint256 private ORIG_TAX_FEE = _TAX_FEE;
483     uint256 private ORIG_BURN_FEE = _BURN_FEE;
484     uint256 private ORIG_CHARITY_FEE = _CHARITY_FEE;
485 
486     constructor () {
487         _rOwned[_msgSender()] = _rTotal;
488         emit Transfer(address(0), _msgSender(), _tTotal);
489     }
490 
491     function name() public pure returns (string memory) {
492         return _NAME;
493     }
494 
495     function symbol() public pure returns (string memory) {
496         return _SYMBOL;
497     }
498 
499     function decimals() public pure returns (uint8) {
500         return _DECIMALS;
501     }
502 
503     function totalSupply() public view override returns (uint256) {
504         return _tTotal;
505     }
506 
507     function balanceOf(address account) public view override returns (uint256) {
508         if (_isExcluded[account]) return _tOwned[account];
509         return tokenFromReflection(_rOwned[account]);
510     }
511 
512     function transfer(address recipient, uint256 amount) public override returns (bool) {
513         _transfer(_msgSender(), recipient, amount);
514         return true;
515     }
516 
517     function allowance(address owner, address spender) public view override returns (uint256) {
518         return _allowances[owner][spender];
519     }
520 
521     function approve(address spender, uint256 amount) public override returns (bool) {
522         _approve(_msgSender(), spender, amount);
523         return true;
524     }
525 
526     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
527         _transfer(sender, recipient, amount);
528         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
529         return true;
530     }
531 
532     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
533         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
534         return true;
535     }
536 
537     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
538         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
539         return true;
540     }
541 
542     function isExcluded(address account) public view returns (bool) {
543         return _isExcluded[account];
544     }
545     
546     function isCharity(address account) public view returns (bool) {
547         return _isCharity[account];
548     }
549 
550     function totalFees() public view returns (uint256) {
551         return _tFeeTotal;
552     }
553     
554     function totalBurn() public view returns (uint256) {
555         return _tBurnTotal;
556     }
557     
558     function totalCharity() public view returns (uint256) {
559         return _tCharityTotal;
560     }
561 
562     function deliver(uint256 tAmount) public {
563         address sender = _msgSender();
564         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
565         (uint256 rAmount,,,,,,) = _getValues(tAmount);
566         _rOwned[sender] = _rOwned[sender].sub(rAmount);
567         _rTotal = _rTotal.sub(rAmount);
568         _tFeeTotal = _tFeeTotal.add(tAmount);
569     }
570 
571     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
572         require(tAmount <= _tTotal, "Amount must be less than supply");
573         if (!deductTransferFee) {
574             (uint256 rAmount,,,,,,) = _getValues(tAmount);
575             return rAmount;
576         } else {
577             (,uint256 rTransferAmount,,,,,) = _getValues(tAmount);
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
589         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
590         require(!_isExcluded[account], "Account is already excluded");
591         if(_rOwned[account] > 0) {
592             _tOwned[account] = tokenFromReflection(_rOwned[account]);
593         }
594         _isExcluded[account] = true;
595         _excluded.push(account);
596     }
597 
598     function includeAccount(address account) external onlyOwner() {
599         require(_isExcluded[account], "Account is already excluded");
600         for (uint256 i = 0; i < _excluded.length; i++) {
601             if (_excluded[i] == account) {
602                 _excluded[i] = _excluded[_excluded.length - 1];
603                 _tOwned[account] = 0;
604                 _isExcluded[account] = false;
605                 _excluded.pop();
606                 break;
607             }
608         }
609     }
610 
611     function setAsCharityAccount(address account) external onlyOwner() {
612         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'The Uniswap router can not be the charity account.');
613         require(!_isCharity[account], "Account is already charity account");
614         _isCharity[account] = true;
615         _charity.push(account);
616     }
617 
618     function _approve(address owner, address spender, uint256 amount) private {
619         require(owner != address(0), "ERC20: approve from the zero address");
620         require(spender != address(0), "ERC20: approve to the zero address");
621 
622         _allowances[owner][spender] = amount;
623         emit Approval(owner, spender, amount);
624     }
625 
626     function _transfer(address sender, address recipient, uint256 amount) private {
627         require(sender != address(0), "BEP20: transfer from the zero address");
628         require(recipient != address(0), "BEP20: transfer to the zero address");
629         require(amount > 0, "Transfer amount must be greater than zero");
630 
631         // Remove fees for transfers to and from charity account or to excluded account
632         bool takeFee = true;
633         if (_isCharity[sender] || _isCharity[recipient] || _isExcluded[recipient]) {
634             takeFee = false;
635         }
636 
637         if (!takeFee) removeAllFee();
638         
639         if (sender != owner() && recipient != owner())
640             require(amount <= _MAX_TX_SIZE, "Transfer amount exceeds the maxTxAmount.");
641         
642         if (_isExcluded[sender] && !_isExcluded[recipient]) {
643             _transferFromExcluded(sender, recipient, amount);
644         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
645             _transferToExcluded(sender, recipient, amount);
646         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
647             _transferStandard(sender, recipient, amount);
648         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
649             _transferBothExcluded(sender, recipient, amount);
650         } else {
651             _transferStandard(sender, recipient, amount);
652         }
653 
654         if (!takeFee) restoreAllFee();
655     }
656 
657     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
658         uint256 currentRate =  _getRate();
659         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tCharity) = _getValues(tAmount);
660         uint256 rBurn =  tBurn.mul(currentRate);
661         uint256 rCharity = tCharity.mul(currentRate);     
662         _standardTransferContent(sender, recipient, rAmount, rTransferAmount);
663         _sendToCharity(tCharity, sender);
664         _reflectFee(rFee, rBurn, rCharity, tFee, tBurn, tCharity);
665         emit Transfer(sender, recipient, tTransferAmount);
666     }
667     
668     function _standardTransferContent(address sender, address recipient, uint256 rAmount, uint256 rTransferAmount) private {
669         _rOwned[sender] = _rOwned[sender].sub(rAmount);
670         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
671     }
672     
673     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
674         uint256 currentRate =  _getRate();
675         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tCharity) = _getValues(tAmount);
676         uint256 rBurn =  tBurn.mul(currentRate);
677         uint256 rCharity = tCharity.mul(currentRate);
678         _excludedFromTransferContent(sender, recipient, tTransferAmount, rAmount, rTransferAmount);        
679         _sendToCharity(tCharity, sender);
680         _reflectFee(rFee, rBurn, rCharity, tFee, tBurn, tCharity);
681         emit Transfer(sender, recipient, tTransferAmount);
682     }
683     
684     function _excludedFromTransferContent(address sender, address recipient, uint256 tTransferAmount, uint256 rAmount, uint256 rTransferAmount) private {
685         _rOwned[sender] = _rOwned[sender].sub(rAmount);
686         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
687         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);    
688     }
689     
690 
691     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
692         uint256 currentRate =  _getRate();
693         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tCharity) = _getValues(tAmount);
694         uint256 rBurn =  tBurn.mul(currentRate);
695         uint256 rCharity = tCharity.mul(currentRate);
696         _excludedToTransferContent(sender, recipient, tAmount, rAmount, rTransferAmount);
697         _sendToCharity(tCharity, sender);
698         _reflectFee(rFee, rBurn, rCharity, tFee, tBurn, tCharity);
699         emit Transfer(sender, recipient, tTransferAmount);
700     }
701     
702     function _excludedToTransferContent(address sender, address recipient, uint256 tAmount, uint256 rAmount, uint256 rTransferAmount) private {
703         _tOwned[sender] = _tOwned[sender].sub(tAmount);
704         _rOwned[sender] = _rOwned[sender].sub(rAmount);
705         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);  
706     }
707 
708     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
709         uint256 currentRate =  _getRate();
710         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn, uint256 tCharity) = _getValues(tAmount);
711         uint256 rBurn =  tBurn.mul(currentRate);
712         uint256 rCharity = tCharity.mul(currentRate);    
713         _bothTransferContent(sender, recipient, tAmount, rAmount, tTransferAmount, rTransferAmount);  
714         _sendToCharity(tCharity, sender);
715         _reflectFee(rFee, rBurn, rCharity, tFee, tBurn, tCharity);
716         emit Transfer(sender, recipient, tTransferAmount);
717     }
718     
719     function _bothTransferContent(address sender, address recipient, uint256 tAmount, uint256 rAmount, uint256 tTransferAmount, uint256 rTransferAmount) private {
720         _tOwned[sender] = _tOwned[sender].sub(tAmount);
721         _rOwned[sender] = _rOwned[sender].sub(rAmount);
722         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
723         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);  
724     }
725 
726     function _reflectFee(uint256 rFee, uint256 rBurn, uint256 rCharity, uint256 tFee, uint256 tBurn, uint256 tCharity) private {
727         _rTotal = _rTotal.sub(rFee).sub(rBurn).sub(rCharity);
728         _tFeeTotal = _tFeeTotal.add(tFee);
729         _tBurnTotal = _tBurnTotal.add(tBurn);
730         _tCharityTotal = _tCharityTotal.add(tCharity);
731         _tTotal = _tTotal.sub(tBurn);
732     }
733     
734 
735     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256, uint256) {
736         (uint256 tFee, uint256 tBurn, uint256 tCharity) = _getTBasics(tAmount, _TAX_FEE, _BURN_FEE, _CHARITY_FEE);
737         uint256 tTransferAmount = getTTransferAmount(tAmount, tFee, tBurn, tCharity);
738         uint256 currentRate =  _getRate();
739         (uint256 rAmount, uint256 rFee) = _getRBasics(tAmount, tFee, currentRate);
740         uint256 rTransferAmount = _getRTransferAmount(rAmount, rFee, tBurn, tCharity, currentRate);
741         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBurn, tCharity);
742     }
743     
744     function _getTBasics(uint256 tAmount, uint256 taxFee, uint256 burnFee, uint256 charityFee) private pure returns (uint256, uint256, uint256) {
745         uint256 tFee = ((tAmount.mul(taxFee)).div(_GRANULARITY)).div(100);
746         uint256 tBurn = ((tAmount.mul(burnFee)).div(_GRANULARITY)).div(100);
747         uint256 tCharity = ((tAmount.mul(charityFee)).div(_GRANULARITY)).div(100);
748         return (tFee, tBurn, tCharity);
749     }
750     
751     function getTTransferAmount(uint256 tAmount, uint256 tFee, uint256 tBurn, uint256 tCharity) private pure returns (uint256) {
752         return tAmount.sub(tFee).sub(tBurn).sub(tCharity);
753     }
754     
755     function _getRBasics(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256) {
756         uint256 rAmount = tAmount.mul(currentRate);
757         uint256 rFee = tFee.mul(currentRate);
758         return (rAmount, rFee);
759     }
760     
761     function _getRTransferAmount(uint256 rAmount, uint256 rFee, uint256 tBurn, uint256 tCharity, uint256 currentRate) private pure returns (uint256) {
762         uint256 rBurn = tBurn.mul(currentRate);
763         uint256 rCharity = tCharity.mul(currentRate);
764         uint256 rTransferAmount = rAmount.sub(rFee).sub(rBurn).sub(rCharity);
765         return rTransferAmount;
766     }
767 
768     function _getRate() private view returns(uint256) {
769         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
770         return rSupply.div(tSupply);
771     }
772 
773     function _getCurrentSupply() private view returns(uint256, uint256) {
774         uint256 rSupply = _rTotal;
775         uint256 tSupply = _tTotal;      
776         for (uint256 i = 0; i < _excluded.length; i++) {
777             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
778             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
779             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
780         }
781         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
782         return (rSupply, tSupply);
783     }
784 
785     function _sendToCharity(uint256 tCharity, address sender) private {
786         uint256 currentRate = _getRate();
787         uint256 rCharity = tCharity.mul(currentRate);
788         address currentCharity = _charity[0];
789         _rOwned[currentCharity] = _rOwned[currentCharity].add(rCharity);
790         _tOwned[currentCharity] = _tOwned[currentCharity].add(tCharity);
791         emit Transfer(sender, currentCharity, tCharity);
792     }
793 
794     function removeAllFee() private {
795         if(_TAX_FEE == 0 && _BURN_FEE == 0 && _CHARITY_FEE == 0) return;
796         
797         ORIG_TAX_FEE = _TAX_FEE;
798         ORIG_BURN_FEE = _BURN_FEE;
799         ORIG_CHARITY_FEE = _CHARITY_FEE;
800         
801         _TAX_FEE = 0;
802         _BURN_FEE = 0;
803         _CHARITY_FEE = 0;
804     }
805     
806     function restoreAllFee() private {
807         _TAX_FEE = ORIG_TAX_FEE;
808         _BURN_FEE = ORIG_BURN_FEE;
809         _CHARITY_FEE = ORIG_CHARITY_FEE;
810     }
811     
812     function _getTaxFee() private view returns(uint256) {
813         return _TAX_FEE;
814     }
815 
816     function _getMaxTxAmount() private pure returns(uint256) {
817         return _MAX_TX_SIZE;
818     }
819     
820 }