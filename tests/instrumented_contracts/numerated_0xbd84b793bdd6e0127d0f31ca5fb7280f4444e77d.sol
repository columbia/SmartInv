1 pragma solidity ^0.6.12;
2 
3 // SPDX-License-Identifier: MIT
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
17  * @dev Interface of the ERC20  standard as defined in the EIP.
18  */
19 interface IERC20  {
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
404     constructor () internal {
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
448 contract BOBO is Context, IERC20, Ownable {
449     using SafeMath for uint256;
450     using Address for address;
451 
452     mapping (address => uint256) private _rOwned;
453     mapping (address => uint256) private _tOwned;
454     mapping (address => mapping (address => uint256)) private _allowances;
455 
456     mapping (address => bool) private _isExcluded;
457     address[] private _excluded;
458     
459     string  private constant _NAME = 'Bobo Inu';
460     string  private constant _SYMBOL = 'BOBO';
461     uint8   private constant _DECIMALS = 8;
462    
463     uint256 private constant _MAX = ~uint256(0);
464     uint256 private constant _DECIMALFACTOR = 10 ** uint256(_DECIMALS);
465     uint256 private constant _GRANULARITY = 100;
466     
467     uint256 private _tTotal = 1000000000000000 * _DECIMALFACTOR;
468     uint256 private _rTotal = (_MAX - (_MAX % _tTotal));
469     
470     uint256 private _tFeeTotal;
471     uint256 private _tBurnTotal;
472     
473     uint256 private      _TAX_FEE = 0;
474     uint256 private     _BURN_FEE = 0;
475     uint256 private     _MAX_TX_SIZE = 10000000000000 * _DECIMALFACTOR;
476 
477     constructor () public {
478         _rOwned[_msgSender()] = _rTotal;
479         emit Transfer(address(0), _msgSender(), _tTotal);
480     }
481 
482     function name() public view returns (string memory) {
483         return _NAME;
484     }
485 
486     function symbol() public view returns (string memory) {
487         return _SYMBOL;
488     }
489 
490     function decimals() public view returns (uint8) {
491         return _DECIMALS;
492     }
493 
494     function totalSupply() public view override returns (uint256) {
495         return _tTotal;
496     }
497 
498     function balanceOf(address account) public view override returns (uint256) {
499         if (_isExcluded[account]) return _tOwned[account];
500         return tokenFromReflection(_rOwned[account]);
501     }
502 
503     function transfer(address recipient, uint256 amount) public override returns (bool) {
504         _transfer(_msgSender(), recipient, amount);
505         return true;
506     }
507 
508     function allowance(address owner, address spender) public view override returns (uint256) {
509         return _allowances[owner][spender];
510     }
511 
512     function approve(address spender, uint256 amount) public override returns (bool) {
513         _approve(_msgSender(), spender, amount);
514         return true;
515     }
516 
517     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
518         _transfer(sender, recipient, amount);
519         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
520         return true;
521     }
522 
523     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
524         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
525         return true;
526     }
527 
528     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
529         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
530         return true;
531     }
532 
533     function isExcluded(address account) public view returns (bool) {
534         return _isExcluded[account];
535     }
536 
537     function totalFees() public view returns (uint256) {
538         return _tFeeTotal;
539     }
540     
541     function totalBurn() public view returns (uint256) {
542         return _tBurnTotal;
543     }
544 
545     function deliver(uint256 tAmount) public {
546         address sender = _msgSender();
547         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
548         (uint256 rAmount,,,,,) = _getValues(tAmount);
549         _rOwned[sender] = _rOwned[sender].sub(rAmount);
550         _rTotal = _rTotal.sub(rAmount);
551         _tFeeTotal = _tFeeTotal.add(tAmount);
552     }
553 
554     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
555         require(tAmount <= _tTotal, "Amount must be less than supply");
556         if (!deductTransferFee) {
557             (uint256 rAmount,,,,,) = _getValues(tAmount);
558             return rAmount;
559         } else {
560             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
561             return rTransferAmount;
562         }
563     }
564 
565     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
566         require(rAmount <= _rTotal, "Amount must be less than total reflections");
567         uint256 currentRate =  _getRate();
568         return rAmount.div(currentRate);
569     }
570 
571     function excludeAccount(address account) external onlyOwner() {
572         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
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
607         if(sender != owner() && recipient != owner())
608             require(amount <= _MAX_TX_SIZE, "Transfer amount exceeds the maxTxAmount.");
609         
610         if (_isExcluded[sender] && !_isExcluded[recipient]) {
611             _transferFromExcluded(sender, recipient, amount);
612         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
613             _transferToExcluded(sender, recipient, amount);
614         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
615             _transferStandard(sender, recipient, amount);
616         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
617             _transferBothExcluded(sender, recipient, amount);
618         } else {
619             _transferStandard(sender, recipient, amount);
620         }
621     }
622 
623     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
624         uint256 currentRate =  _getRate();
625         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
626         uint256 rBurn =  tBurn.mul(currentRate);
627         _rOwned[sender] = _rOwned[sender].sub(rAmount);
628         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
629         _reflectFee(rFee, rBurn, tFee, tBurn);
630         emit Transfer(sender, recipient, tTransferAmount);
631     }
632 
633     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
634         uint256 currentRate =  _getRate();
635         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
636         uint256 rBurn =  tBurn.mul(currentRate);
637         _rOwned[sender] = _rOwned[sender].sub(rAmount);
638         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
639         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
640         _reflectFee(rFee, rBurn, tFee, tBurn);
641         emit Transfer(sender, recipient, tTransferAmount);
642     }
643 
644     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
645         uint256 currentRate =  _getRate();
646         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
647         uint256 rBurn =  tBurn.mul(currentRate);
648         _tOwned[sender] = _tOwned[sender].sub(tAmount);
649         _rOwned[sender] = _rOwned[sender].sub(rAmount);
650         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
651         _reflectFee(rFee, rBurn, tFee, tBurn);
652         emit Transfer(sender, recipient, tTransferAmount);
653     }
654 
655     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
656         uint256 currentRate =  _getRate();
657         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
658         uint256 rBurn =  tBurn.mul(currentRate);
659         _tOwned[sender] = _tOwned[sender].sub(tAmount);
660         _rOwned[sender] = _rOwned[sender].sub(rAmount);
661         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
662         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
663         _reflectFee(rFee, rBurn, tFee, tBurn);
664         emit Transfer(sender, recipient, tTransferAmount);
665     }
666 
667     function _reflectFee(uint256 rFee, uint256 rBurn, uint256 tFee, uint256 tBurn) private {
668         _rTotal = _rTotal.sub(rFee).sub(rBurn);
669         _tFeeTotal = _tFeeTotal.add(tFee);
670         _tBurnTotal = _tBurnTotal.add(tBurn);
671         _tTotal = _tTotal.sub(tBurn);
672     }
673 
674     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
675         (uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getTValues(tAmount, _TAX_FEE, _BURN_FEE);
676         uint256 currentRate =  _getRate();
677         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tBurn, currentRate);
678         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBurn);
679     }
680 
681     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 burnFee) private pure returns (uint256, uint256, uint256) {
682         uint256 tFee = ((tAmount.mul(taxFee)).div(_GRANULARITY)).div(100);
683         uint256 tBurn = ((tAmount.mul(burnFee)).div(_GRANULARITY)).div(100);
684         uint256 tTransferAmount = tAmount.sub(tFee).sub(tBurn);
685         return (tTransferAmount, tFee, tBurn);
686     }
687 
688     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tBurn, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
689         uint256 rAmount = tAmount.mul(currentRate);
690         uint256 rFee = tFee.mul(currentRate);
691         uint256 rBurn = tBurn.mul(currentRate);
692         uint256 rTransferAmount = rAmount.sub(rFee).sub(rBurn);
693         return (rAmount, rTransferAmount, rFee);
694     }
695 
696     function _getRate() private view returns(uint256) {
697         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
698         return rSupply.div(tSupply);
699     }
700 
701     function _getCurrentSupply() private view returns(uint256, uint256) {
702         uint256 rSupply = _rTotal;
703         uint256 tSupply = _tTotal;      
704         for (uint256 i = 0; i < _excluded.length; i++) {
705             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
706             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
707             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
708         }
709         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
710         return (rSupply, tSupply);
711     }
712     
713     function _getTaxFee() private view returns(uint256) {
714         return _TAX_FEE;
715     }
716 
717     function _setTaxFee(uint256 taxFee) external onlyOwner() {
718         require(taxFee >= 50 && taxFee <= 1000, 'taxFee should be in 1 - 10');
719         _TAX_FEE = taxFee;
720     }
721 
722     function _setBurnFee(uint256 burnFee) external onlyOwner() {
723         require(burnFee >= 50 && burnFee <= 1000, 'burnFee should be in 1 - 10');
724         _BURN_FEE = burnFee;
725     }
726 
727     function _getMaxTxAmount() private view returns(uint256) {
728         return _MAX_TX_SIZE;
729     }
730     
731     function getMaxTxAmount() public view returns(uint256) {
732         return _getMaxTxAmount();
733     }
734     
735     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
736         _MAX_TX_SIZE = _tTotal.mul(maxTxPercent).div(
737             10**2
738         );
739     }
740 }