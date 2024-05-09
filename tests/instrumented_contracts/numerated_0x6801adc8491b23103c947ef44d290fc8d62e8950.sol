1 // yDoge - Frictionless Yield Meme Farming sol. erc20
2 
3 // Git: https://github.com/dogelordsolidity/Dogefarm_Platform
4 // TG: https://t.me/dogefarm_finance
5 // Website: https://dogefarm.finance
6 // SPDX-License-Identifier: MIT
7 
8 pragma solidity ^0.6.0;
9 
10 
11 abstract contract Context {
12     function _msgSender() internal view virtual returns (address payable) {
13         return msg.sender;
14     }
15 
16     function _msgData() internal view virtual returns (bytes memory) {
17         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
18         return msg.data;
19     }
20 }
21 
22 /**
23  * @dev Interface of the ERC20 standard as defined in the EIP.
24  */
25 interface IERC20 {
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `recipient`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address recipient, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `sender` to `recipient` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Emitted when `value` tokens are moved from one account (`from`) to
83      * another (`to`).
84      *
85      * Note that `value` may be zero.
86      */
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 
89     /**
90      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
91      * a call to {approve}. `value` is the new allowance.
92      */
93     event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 /**
97  * @dev Wrappers over Solidity's arithmetic operations with added overflow
98  * checks.
99  *
100  * Arithmetic operations in Solidity wrap on overflow. This can easily result
101  * in bugs, because programmers usually assume that an overflow raises an
102  * error, which is the standard behavior in high level programming languages.
103  * `SafeMath` restores this intuition by reverting the transaction when an
104  * operation overflows.
105  *
106  * Using this library instead of the unchecked operations eliminates an entire
107  * class of bugs, so it's recommended to use it always.
108  */
109 library SafeMath {
110     /**
111      * @dev Returns the addition of two unsigned integers, reverting on
112      * overflow.
113      *
114      * Counterpart to Solidity's `+` operator.
115      *
116      * Requirements:
117      *
118      * - Addition cannot overflow.
119      */
120     function add(uint256 a, uint256 b) internal pure returns (uint256) {
121         uint256 c = a + b;
122         require(c >= a, "SafeMath: addition overflow");
123 
124         return c;
125     }
126 
127     /**
128      * @dev Returns the subtraction of two unsigned integers, reverting on
129      * overflow (when the result is negative).
130      *
131      * Counterpart to Solidity's `-` operator.
132      *
133      * Requirements:
134      *
135      * - Subtraction cannot overflow.
136      */
137     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
138         return sub(a, b, "SafeMath: subtraction overflow");
139     }
140 
141     /**
142      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
143      * overflow (when the result is negative).
144      *
145      * Counterpart to Solidity's `-` operator.
146      *
147      * Requirements:
148      *
149      * - Subtraction cannot overflow.
150      */
151     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
152         require(b <= a, errorMessage);
153         uint256 c = a - b;
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the multiplication of two unsigned integers, reverting on
160      * overflow.
161      *
162      * Counterpart to Solidity's `*` operator.
163      *
164      * Requirements:
165      *
166      * - Multiplication cannot overflow.
167      */
168     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
169         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
170         // benefit is lost if 'b' is also tested.
171         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
172         if (a == 0) {
173             return 0;
174         }
175 
176         uint256 c = a * b;
177         require(c / a == b, "SafeMath: multiplication overflow");
178 
179         return c;
180     }
181 
182     /**
183      * @dev Returns the integer division of two unsigned integers. Reverts on
184      * division by zero. The result is rounded towards zero.
185      *
186      * Counterpart to Solidity's `/` operator. Note: this function uses a
187      * `revert` opcode (which leaves remaining gas untouched) while Solidity
188      * uses an invalid opcode to revert (consuming all remaining gas).
189      *
190      * Requirements:
191      *
192      * - The divisor cannot be zero.
193      */
194     function div(uint256 a, uint256 b) internal pure returns (uint256) {
195         return div(a, b, "SafeMath: division by zero");
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
207      *
208      * - The divisor cannot be zero.
209      */
210     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
211         require(b > 0, errorMessage);
212         uint256 c = a / b;
213         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
214 
215         return c;
216     }
217 
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220      * Reverts when dividing by zero.
221      *
222      * Counterpart to Solidity's `%` operator. This function uses a `revert`
223      * opcode (which leaves remaining gas untouched) while Solidity uses an
224      * invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
231         return mod(a, b, "SafeMath: modulo by zero");
232     }
233 
234     /**
235      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
236      * Reverts with custom message when dividing by zero.
237      *
238      * Counterpart to Solidity's `%` operator. This function uses a `revert`
239      * opcode (which leaves remaining gas untouched) while Solidity uses an
240      * invalid opcode to revert (consuming all remaining gas).
241      *
242      * Requirements:
243      *
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
247         require(b != 0, errorMessage);
248         return a % b;
249     }
250 }
251 
252 /**
253  * @dev Collection of functions related to the address type
254  */
255 library Address {
256     /**
257      * @dev Returns true if `account` is a contract.
258      *
259      * [IMPORTANT]
260      * ====
261      * It is unsafe to assume that an address for which this function returns
262      * false is an externally-owned account (EOA) and not a contract.
263      *
264      * Among others, `isContract` will return false for the following
265      * types of addresses:
266      *
267      *  - an externally-owned account
268      *  - a contract in construction
269      *  - an address where a contract will be created
270      *  - an address where a contract lived, but was destroyed
271      * ====
272      */
273     function isContract(address account) internal view returns (bool) {
274         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
275         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
276         // for accounts without code, i.e. `keccak256('')`
277         bytes32 codehash;
278         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
279         // solhint-disable-next-line no-inline-assembly
280         assembly { codehash := extcodehash(account) }
281         return (codehash != accountHash && codehash != 0x0);
282     }
283 
284     /**
285      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
286      * `recipient`, forwarding all available gas and reverting on errors.
287      *
288      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
289      * of certain opcodes, possibly making contracts go over the 2300 gas limit
290      * imposed by `transfer`, making them unable to receive funds via
291      * `transfer`. {sendValue} removes this limitation.
292      *
293      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
294      *
295      * IMPORTANT: because control is transferred to `recipient`, care must be
296      * taken to not create reentrancy vulnerabilities. Consider using
297      * {ReentrancyGuard} or the
298      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
299      */
300     function sendValue(address payable recipient, uint256 amount) internal {
301         require(address(this).balance >= amount, "Address: insufficient balance");
302 
303         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
304         (bool success, ) = recipient.call{ value: amount }("");
305         require(success, "Address: unable to send value, recipient may have reverted");
306     }
307 
308     /**
309      * @dev Performs a Solidity function call using a low level `call`. A
310      * plain`call` is an unsafe replacement for a function call: use this
311      * function instead.
312      *
313      * If `target` reverts with a revert reason, it is bubbled up by this
314      * function (like regular Solidity function calls).
315      *
316      * Returns the raw returned data. To convert to the expected return value,
317      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
318      *
319      * Requirements:
320      *
321      * - `target` must be a contract.
322      * - calling `target` with `data` must not revert.
323      *
324      * _Available since v3.1._
325      */
326     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
327       return functionCall(target, data, "Address: low-level call failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
332      * `errorMessage` as a fallback revert reason when `target` reverts.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
337         return _functionCallWithValue(target, data, 0, errorMessage);
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
342      * but also transferring `value` wei to `target`.
343      *
344      * Requirements:
345      *
346      * - the calling contract must have an ETH balance of at least `value`.
347      * - the called Solidity function must be `payable`.
348      *
349      * _Available since v3.1._
350      */
351     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
352         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
357      * with `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
362         require(address(this).balance >= value, "Address: insufficient balance for call");
363         return _functionCallWithValue(target, data, value, errorMessage);
364     }
365 
366     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
367         require(isContract(target), "Address: call to non-contract");
368 
369         // solhint-disable-next-line avoid-low-level-calls
370         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
371         if (success) {
372             return returndata;
373         } else {
374             // Look for revert reason and bubble it up if present
375             if (returndata.length > 0) {
376                 // The easiest way to bubble the revert reason is using memory via assembly
377 
378                 // solhint-disable-next-line no-inline-assembly
379                 assembly {
380                     let returndata_size := mload(returndata)
381                     revert(add(32, returndata), returndata_size)
382                 }
383             } else {
384                 revert(errorMessage);
385             }
386         }
387     }
388 }
389 
390 /**
391  * @dev Contract module which provides a basic access control mechanism, where
392  * there is an account (an owner) that can be granted exclusive access to
393  * specific functions.
394  *
395  * By default, the owner account will be the one that deploys the contract. This
396  * can later be changed with {transferOwnership}.
397  *
398  * This module is used through inheritance. It will make available the modifier
399  * `onlyOwner`, which can be applied to your functions to restrict their use to
400  * the owner.
401  */
402 contract Ownable is Context {
403     address private _owner;
404 
405     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
406 
407     /**
408      * @dev Initializes the contract setting the deployer as the initial owner.
409      */
410     constructor () internal {
411         address msgSender = _msgSender();
412         _owner = msgSender;
413         emit OwnershipTransferred(address(0), msgSender);
414     }
415 
416     /**
417      * @dev Returns the address of the current owner.
418      */
419     function owner() public view returns (address) {
420         return _owner;
421     }
422 
423     /**
424      * @dev Throws if called by any account other than the owner.
425      */
426     modifier onlyOwner() {
427         require(_owner == _msgSender(), "Ownable: caller is not the owner");
428         _;
429     }
430 
431     /**
432      * @dev Leaves the contract without owner. It will not be possible to call
433      * `onlyOwner` functions anymore. Can only be called by the current owner.
434      *
435      * NOTE: Renouncing ownership will leave the contract without an owner,
436      * thereby removing any functionality that is only available to the owner.
437      */
438     function renounceOwnership() public virtual onlyOwner {
439         emit OwnershipTransferred(_owner, address(0));
440         _owner = address(0);
441     }
442 
443     /**
444      * @dev Transfers ownership of the contract to a new account (`newOwner`).
445      * Can only be called by the current owner.
446      */
447     function transferOwnership(address newOwner) public virtual onlyOwner {
448         require(newOwner != address(0), "Ownable: new owner is the zero address");
449         emit OwnershipTransferred(_owner, newOwner);
450         _owner = newOwner;
451     }
452 }
453 
454 contract DOGEFARMtoken is Context, IERC20, Ownable {
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
465     string  private constant _NAME = 'dogefarm.finance';
466     string  private constant _SYMBOL = 'yDOGE';
467     uint8   private constant _DECIMALS = 8;
468    
469     uint256 private constant _MAX = ~uint256(0);
470     uint256 private constant _DECIMALFACTOR = 10 ** uint256(_DECIMALS);
471     uint256 private constant _GRANULARITY = 100;
472     
473     uint256 private _tTotal = 100000000 * _DECIMALFACTOR;
474     uint256 private _rTotal = (_MAX - (_MAX % _tTotal));
475     
476     uint256 private _tFeeTotal;
477     uint256 private _tBurnTotal;
478     
479     uint256 private constant     _TAX_FEE = 680;
480     uint256 private constant    _BURN_FEE = 320;
481     uint256 private constant _MAX_TX_SIZE = 1000000 * _DECIMALFACTOR;
482 
483     constructor () public {
484         _rOwned[_msgSender()] = _rTotal;
485         emit Transfer(address(0), _msgSender(), _tTotal);
486     }
487 
488     function name() public view returns (string memory) {
489         return _NAME;
490     }
491 
492     function symbol() public view returns (string memory) {
493         return _SYMBOL;
494     }
495 
496     function decimals() public view returns (uint8) {
497         return _DECIMALS;
498     }
499 
500     function totalSupply() public view override returns (uint256) {
501         return _tTotal;
502     }
503 
504     function balanceOf(address account) public view override returns (uint256) {
505         if (_isExcluded[account]) return _tOwned[account];
506         return tokenFromReflection(_rOwned[account]);
507     }
508 
509     function transfer(address recipient, uint256 amount) public override returns (bool) {
510         _transfer(_msgSender(), recipient, amount);
511         return true;
512     }
513 
514     function allowance(address owner, address spender) public view override returns (uint256) {
515         return _allowances[owner][spender];
516     }
517 
518     function approve(address spender, uint256 amount) public override returns (bool) {
519         _approve(_msgSender(), spender, amount);
520         return true;
521     }
522 
523     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
524         _transfer(sender, recipient, amount);
525         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
526         return true;
527     }
528 
529     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
530         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
531         return true;
532     }
533 
534     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
535         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
536         return true;
537     }
538 
539     function isExcluded(address account) public view returns (bool) {
540         return _isExcluded[account];
541     }
542 
543     function totalFees() public view returns (uint256) {
544         return _tFeeTotal;
545     }
546     
547     function totalBurn() public view returns (uint256) {
548         return _tBurnTotal;
549     }
550 
551     function deliver(uint256 tAmount) public {
552         address sender = _msgSender();
553         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
554         (uint256 rAmount,,,,,) = _getValues(tAmount);
555         _rOwned[sender] = _rOwned[sender].sub(rAmount);
556         _rTotal = _rTotal.sub(rAmount);
557         _tFeeTotal = _tFeeTotal.add(tAmount);
558     }
559 
560     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
561         require(tAmount <= _tTotal, "Amount must be less than supply");
562         if (!deductTransferFee) {
563             (uint256 rAmount,,,,,) = _getValues(tAmount);
564             return rAmount;
565         } else {
566             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
567             return rTransferAmount;
568         }
569     }
570 
571     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
572         require(rAmount <= _rTotal, "Amount must be less than total reflections");
573         uint256 currentRate =  _getRate();
574         return rAmount.div(currentRate);
575     }
576 
577     function excludeAccount(address account) external onlyOwner() {
578         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
579         require(!_isExcluded[account], "Account is already excluded");
580         if(_rOwned[account] > 0) {
581             _tOwned[account] = tokenFromReflection(_rOwned[account]);
582         }
583         _isExcluded[account] = true;
584         _excluded.push(account);
585     }
586 
587     function includeAccount(address account) external onlyOwner() {
588         require(_isExcluded[account], "Account is already excluded");
589         for (uint256 i = 0; i < _excluded.length; i++) {
590             if (_excluded[i] == account) {
591                 _excluded[i] = _excluded[_excluded.length - 1];
592                 _tOwned[account] = 0;
593                 _isExcluded[account] = false;
594                 _excluded.pop();
595                 break;
596             }
597         }
598     }
599 
600     function _approve(address owner, address spender, uint256 amount) private {
601         require(owner != address(0), "ERC20: approve from the zero address");
602         require(spender != address(0), "ERC20: approve to the zero address");
603 
604         _allowances[owner][spender] = amount;
605         emit Approval(owner, spender, amount);
606     }
607 
608     function _transfer(address sender, address recipient, uint256 amount) private {
609         require(sender != address(0), "ERC20: transfer from the zero address");
610         require(recipient != address(0), "ERC20: transfer to the zero address");
611         require(amount > 0, "Transfer amount must be greater than zero");
612         
613         if(sender != owner() && recipient != owner())
614             require(amount <= _MAX_TX_SIZE, "Transfer amount exceeds the maxTxAmount.");
615         
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
630         uint256 currentRate =  _getRate();
631         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
632         uint256 rBurn =  tBurn.mul(currentRate);
633         _rOwned[sender] = _rOwned[sender].sub(rAmount);
634         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
635         _reflectFee(rFee, rBurn, tFee, tBurn);
636         emit Transfer(sender, recipient, tTransferAmount);
637     }
638 
639     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
640         uint256 currentRate =  _getRate();
641         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
642         uint256 rBurn =  tBurn.mul(currentRate);
643         _rOwned[sender] = _rOwned[sender].sub(rAmount);
644         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
645         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
646         _reflectFee(rFee, rBurn, tFee, tBurn);
647         emit Transfer(sender, recipient, tTransferAmount);
648     }
649 
650     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
651         uint256 currentRate =  _getRate();
652         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
653         uint256 rBurn =  tBurn.mul(currentRate);
654         _tOwned[sender] = _tOwned[sender].sub(tAmount);
655         _rOwned[sender] = _rOwned[sender].sub(rAmount);
656         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
657         _reflectFee(rFee, rBurn, tFee, tBurn);
658         emit Transfer(sender, recipient, tTransferAmount);
659     }
660 
661     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
662         uint256 currentRate =  _getRate();
663         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
664         uint256 rBurn =  tBurn.mul(currentRate);
665         _tOwned[sender] = _tOwned[sender].sub(tAmount);
666         _rOwned[sender] = _rOwned[sender].sub(rAmount);
667         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
668         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
669         _reflectFee(rFee, rBurn, tFee, tBurn);
670         emit Transfer(sender, recipient, tTransferAmount);
671     }
672 
673     function _reflectFee(uint256 rFee, uint256 rBurn, uint256 tFee, uint256 tBurn) private {
674         _rTotal = _rTotal.sub(rFee).sub(rBurn);
675         _tFeeTotal = _tFeeTotal.add(tFee);
676         _tBurnTotal = _tBurnTotal.add(tBurn);
677         _tTotal = _tTotal.sub(tBurn);
678     }
679 
680     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
681         (uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getTValues(tAmount, _TAX_FEE, _BURN_FEE);
682         uint256 currentRate =  _getRate();
683         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tBurn, currentRate);
684         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBurn);
685     }
686 
687     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 burnFee) private pure returns (uint256, uint256, uint256) {
688         uint256 tFee = ((tAmount.mul(taxFee)).div(_GRANULARITY)).div(100);
689         uint256 tBurn = ((tAmount.mul(burnFee)).div(_GRANULARITY)).div(100);
690         uint256 tTransferAmount = tAmount.sub(tFee).sub(tBurn);
691         return (tTransferAmount, tFee, tBurn);
692     }
693 
694     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tBurn, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
695         uint256 rAmount = tAmount.mul(currentRate);
696         uint256 rFee = tFee.mul(currentRate);
697         uint256 rBurn = tBurn.mul(currentRate);
698         uint256 rTransferAmount = rAmount.sub(rFee).sub(rBurn);
699         return (rAmount, rTransferAmount, rFee);
700     }
701 
702     function _getRate() private view returns(uint256) {
703         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
704         return rSupply.div(tSupply);
705     }
706 
707     function _getCurrentSupply() private view returns(uint256, uint256) {
708         uint256 rSupply = _rTotal;
709         uint256 tSupply = _tTotal;      
710         for (uint256 i = 0; i < _excluded.length; i++) {
711             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
712             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
713             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
714         }
715         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
716         return (rSupply, tSupply);
717     }
718     
719     function _getTaxFee() private view returns(uint256) {
720         return _TAX_FEE;
721     }
722 
723     function _getMaxTxAmount() private view returns(uint256) {
724         return _MAX_TX_SIZE;
725     }
726     
727 }