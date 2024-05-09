1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address payable) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view virtual returns (bytes memory) {
12         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
13         return msg.data;
14     }
15 }
16 
17 /**
18  * @dev Interface of the ERC20 standard as defined in the EIP.
19  */
20 interface IERC20 {
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
398     address private _owner;
399 
400     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
401 
402     /**
403      * @dev Initializes the contract setting the deployer as the initial owner.
404      */
405     constructor () internal {
406         address msgSender = _msgSender();
407         _owner = msgSender;
408         emit OwnershipTransferred(address(0), msgSender);
409     }
410 
411     /**
412      * @dev Returns the address of the current owner.
413      */
414     function owner() public view returns (address) {
415         return _owner;
416     }
417 
418     /**
419      * @dev Throws if called by any account other than the owner.
420      */
421     modifier onlyOwner() {
422         require(_owner == _msgSender(), "Ownable: caller is not the owner");
423         _;
424     }
425 
426     /**
427      * @dev Leaves the contract without owner. It will not be possible to call
428      * `onlyOwner` functions anymore. Can only be called by the current owner.
429      *
430      * NOTE: Renouncing ownership will leave the contract without an owner,
431      * thereby removing any functionality that is only available to the owner.
432      */
433     function renounceOwnership() public virtual onlyOwner {
434         emit OwnershipTransferred(_owner, address(0));
435         _owner = address(0);
436     }
437 
438     /**
439      * @dev Transfers ownership of the contract to a new account (`newOwner`).
440      * Can only be called by the current owner.
441      */
442     function transferOwnership(address newOwner) public virtual onlyOwner {
443         require(newOwner != address(0), "Ownable: new owner is the zero address");
444         emit OwnershipTransferred(_owner, newOwner);
445         _owner = newOwner;
446     }
447 }
448 
449 contract RFbtc is Context, IERC20, Ownable {
450     using SafeMath for uint256;
451     using Address for address;
452 
453     mapping (address => uint256) private _rOwned;
454     mapping (address => uint256) private _tOwned;
455     mapping (address => mapping (address => uint256)) private _allowances;
456 
457     mapping (address => bool) private _isExcluded;
458     address[] private _excluded;
459     
460     string  private constant _NAME = 'RFbtc';
461     string  private constant _SYMBOL = 'RFbtc';
462     uint8   private constant _DECIMALS = 8;
463    
464     uint256 private constant _MAX = ~uint256(0);
465     uint256 private constant _DECIMALFACTOR = 10 ** uint256(_DECIMALS);
466     uint256 private constant _GRANULARITY = 100;
467     
468     uint256 private _tTotal = 21000000 * _DECIMALFACTOR;
469     uint256 private _rTotal = (_MAX - (_MAX % _tTotal));
470     
471     uint256 private _tFeeTotal;
472     uint256 private _tBurnTotal;
473     
474     uint256 private constant     _TAX_FEE = 210;
475     uint256 private constant    _BURN_FEE = 210;
476     uint256 private constant _MAX_TX_SIZE = 210000 * _DECIMALFACTOR;
477 
478     constructor () public {
479         _rOwned[_msgSender()] = _rTotal;
480         emit Transfer(address(0), _msgSender(), _tTotal);
481     }
482 
483     function name() public view returns (string memory) {
484         return _NAME;
485     }
486 
487     function symbol() public view returns (string memory) {
488         return _SYMBOL;
489     }
490 
491     function decimals() public view returns (uint8) {
492         return _DECIMALS;
493     }
494 
495     function totalSupply() public view override returns (uint256) {
496         return _tTotal;
497     }
498 
499     function balanceOf(address account) public view override returns (uint256) {
500         if (_isExcluded[account]) return _tOwned[account];
501         return tokenFromReflection(_rOwned[account]);
502     }
503 
504     function transfer(address recipient, uint256 amount) public override returns (bool) {
505         _transfer(_msgSender(), recipient, amount);
506         return true;
507     }
508 
509     function allowance(address owner, address spender) public view override returns (uint256) {
510         return _allowances[owner][spender];
511     }
512 
513     function approve(address spender, uint256 amount) public override returns (bool) {
514         _approve(_msgSender(), spender, amount);
515         return true;
516     }
517 
518     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
519         _transfer(sender, recipient, amount);
520         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
521         return true;
522     }
523 
524     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
525         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
526         return true;
527     }
528 
529     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
530         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
531         return true;
532     }
533 
534     function isExcluded(address account) public view returns (bool) {
535         return _isExcluded[account];
536     }
537 
538     function totalFees() public view returns (uint256) {
539         return _tFeeTotal;
540     }
541     
542     function totalBurn() public view returns (uint256) {
543         return _tBurnTotal;
544     }
545 
546     function deliver(uint256 tAmount) public {
547         address sender = _msgSender();
548         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
549         (uint256 rAmount,,,,,) = _getValues(tAmount);
550         _rOwned[sender] = _rOwned[sender].sub(rAmount);
551         _rTotal = _rTotal.sub(rAmount);
552         _tFeeTotal = _tFeeTotal.add(tAmount);
553     }
554 
555     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
556         require(tAmount <= _tTotal, "Amount must be less than supply");
557         if (!deductTransferFee) {
558             (uint256 rAmount,,,,,) = _getValues(tAmount);
559             return rAmount;
560         } else {
561             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
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
573         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
574         require(!_isExcluded[account], "Account is already excluded");
575         if(_rOwned[account] > 0) {
576             _tOwned[account] = tokenFromReflection(_rOwned[account]);
577         }
578         _isExcluded[account] = true;
579         _excluded.push(account);
580     }
581 
582     function includeAccount(address account) external onlyOwner() {
583         require(_isExcluded[account], "Account is already excluded");
584         for (uint256 i = 0; i < _excluded.length; i++) {
585             if (_excluded[i] == account) {
586                 _excluded[i] = _excluded[_excluded.length - 1];
587                 _tOwned[account] = 0;
588                 _isExcluded[account] = false;
589                 _excluded.pop();
590                 break;
591             }
592         }
593     }
594 
595     function _approve(address owner, address spender, uint256 amount) private {
596         require(owner != address(0), "ERC20: approve from the zero address");
597         require(spender != address(0), "ERC20: approve to the zero address");
598 
599         _allowances[owner][spender] = amount;
600         emit Approval(owner, spender, amount);
601     }
602 
603     function _transfer(address sender, address recipient, uint256 amount) private {
604         require(sender != address(0), "ERC20: transfer from the zero address");
605         require(recipient != address(0), "ERC20: transfer to the zero address");
606         require(amount > 0, "Transfer amount must be greater than zero");
607         
608         if(sender != owner() && recipient != owner())
609             require(amount <= _MAX_TX_SIZE, "Transfer amount exceeds the maxTxAmount.");
610         
611         if (_isExcluded[sender] && !_isExcluded[recipient]) {
612             _transferFromExcluded(sender, recipient, amount);
613         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
614             _transferToExcluded(sender, recipient, amount);
615         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
616             _transferStandard(sender, recipient, amount);
617         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
618             _transferBothExcluded(sender, recipient, amount);
619         } else {
620             _transferStandard(sender, recipient, amount);
621         }
622     }
623 
624     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
625         uint256 currentRate =  _getRate();
626         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
627         uint256 rBurn =  tBurn.mul(currentRate);
628         _rOwned[sender] = _rOwned[sender].sub(rAmount);
629         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
630         _reflectFee(rFee, rBurn, tFee, tBurn);
631         emit Transfer(sender, recipient, tTransferAmount);
632     }
633 
634     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
635         uint256 currentRate =  _getRate();
636         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
637         uint256 rBurn =  tBurn.mul(currentRate);
638         _rOwned[sender] = _rOwned[sender].sub(rAmount);
639         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
640         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
641         _reflectFee(rFee, rBurn, tFee, tBurn);
642         emit Transfer(sender, recipient, tTransferAmount);
643     }
644 
645     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
646         uint256 currentRate =  _getRate();
647         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
648         uint256 rBurn =  tBurn.mul(currentRate);
649         _tOwned[sender] = _tOwned[sender].sub(tAmount);
650         _rOwned[sender] = _rOwned[sender].sub(rAmount);
651         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
652         _reflectFee(rFee, rBurn, tFee, tBurn);
653         emit Transfer(sender, recipient, tTransferAmount);
654     }
655 
656     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
657         uint256 currentRate =  _getRate();
658         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
659         uint256 rBurn =  tBurn.mul(currentRate);
660         _tOwned[sender] = _tOwned[sender].sub(tAmount);
661         _rOwned[sender] = _rOwned[sender].sub(rAmount);
662         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
663         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
664         _reflectFee(rFee, rBurn, tFee, tBurn);
665         emit Transfer(sender, recipient, tTransferAmount);
666     }
667 
668     function _reflectFee(uint256 rFee, uint256 rBurn, uint256 tFee, uint256 tBurn) private {
669         _rTotal = _rTotal.sub(rFee).sub(rBurn);
670         _tFeeTotal = _tFeeTotal.add(tFee);
671         _tBurnTotal = _tBurnTotal.add(tBurn);
672         _tTotal = _tTotal.sub(tBurn);
673     }
674 
675     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
676         (uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getTValues(tAmount, _TAX_FEE, _BURN_FEE);
677         uint256 currentRate =  _getRate();
678         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tBurn, currentRate);
679         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBurn);
680     }
681 
682     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 burnFee) private pure returns (uint256, uint256, uint256) {
683         uint256 tFee = ((tAmount.mul(taxFee)).div(_GRANULARITY)).div(100);
684         uint256 tBurn = ((tAmount.mul(burnFee)).div(_GRANULARITY)).div(100);
685         uint256 tTransferAmount = tAmount.sub(tFee).sub(tBurn);
686         return (tTransferAmount, tFee, tBurn);
687     }
688 
689     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tBurn, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
690         uint256 rAmount = tAmount.mul(currentRate);
691         uint256 rFee = tFee.mul(currentRate);
692         uint256 rBurn = tBurn.mul(currentRate);
693         uint256 rTransferAmount = rAmount.sub(rFee).sub(rBurn);
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
713     
714     function _getTaxFee() private view returns(uint256) {
715         return _TAX_FEE;
716     }
717 
718     function _getMaxTxAmount() private view returns(uint256) {
719         return _MAX_TX_SIZE;
720     }
721     
722 }