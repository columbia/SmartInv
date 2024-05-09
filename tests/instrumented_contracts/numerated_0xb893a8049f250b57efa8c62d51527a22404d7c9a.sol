1 /**
2 
3                                       
4    https://t.me/ushibauni      
5 
6   http://www.americanshiba.com
7 
8 */
9 
10 
11 // SPDX-License-Identifier: Unlicensed
12 
13 pragma solidity ^0.6.12;
14 
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 interface IERC20 {
27     /**
28      * @dev Returns the amount of tokens in existence.
29      */
30     function totalSupply() external view returns (uint256);
31 
32     /**
33      * @dev Returns the amount of tokens owned by `account`.
34      */
35     function balanceOf(address account) external view returns (uint256);
36 
37     /**
38      * @dev Moves `amount` tokens from the caller's account to `recipient`.
39      *
40      * Returns a boolean value indicating whether the operation succeeded.
41      *
42      * Emits a {Transfer} event.
43      */
44     function transfer(address recipient, uint256 amount) external returns (bool);
45 
46     /**
47      * @dev Returns the remaining number of tokens that `spender` will be
48      * allowed to spend on behalf of `owner` through {transferFrom}. This is
49      * zero by default.
50      *
51      * This value changes when {approve} or {transferFrom} are called.
52      */
53     function allowance(address owner, address spender) external view returns (uint256);
54 
55     /**
56      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
57      *
58      * Returns a boolean value indicating whether the operation succeeded.
59      *
60      * IMPORTANT: Beware that changing an allowance with this method brings the risk
61      * that someone may use both the old and the new allowance by unfortunate
62      * transaction ordering. One possible solution to mitigate this race
63      * condition is to first reduce the spender's allowance to 0 and set the
64      * desired value afterwards:
65      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
66      *
67      * Emits an {Approval} event.
68      */
69     function approve(address spender, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Moves `amount` tokens from `sender` to `recipient` using the
73      * allowance mechanism. `amount` is then deducted from the caller's
74      * allowance.
75      *
76      * Returns a boolean value indicating whether the operation succeeded.
77      *
78      * Emits a {Transfer} event.
79      */
80     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
81 
82     /**
83      * @dev Emitted when `value` tokens are moved from one account (`from`) to
84      * another (`to`).
85      *
86      * Note that `value` may be zero.
87      */
88     event Transfer(address indexed from, address indexed to, uint256 value);
89 
90     /**
91      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
92      * a call to {approve}. `value` is the new allowance.
93      */
94     event Approval(address indexed owner, address indexed spender, uint256 value);
95 }
96 
97 library SafeMath {
98     /**
99      * @dev Returns the addition of two unsigned integers, reverting on
100      * overflow.
101      *
102      * Counterpart to Solidity's `+` operator.
103      *
104      * Requirements:
105      *
106      * - Addition cannot overflow.
107      */
108     function add(uint256 a, uint256 b) internal pure returns (uint256) {
109         uint256 c = a + b;
110         require(c >= a, "SafeMath: addition overflow");
111 
112         return c;
113     }
114 
115     /**
116      * @dev Returns the subtraction of two unsigned integers, reverting on
117      * overflow (when the result is negative).
118      *
119      * Counterpart to Solidity's `-` operator.
120      *
121      * Requirements:
122      *
123      * - Subtraction cannot overflow.
124      */
125     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
126         return sub(a, b, "SafeMath: subtraction overflow");
127     }
128 
129     /**
130      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
131      * overflow (when the result is negative).
132      *
133      * Counterpart to Solidity's `-` operator.
134      *
135      * Requirements:
136      *
137      * - Subtraction cannot overflow.
138      */
139     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
140         require(b <= a, errorMessage);
141         uint256 c = a - b;
142 
143         return c;
144     }
145 
146     /**
147      * @dev Returns the multiplication of two unsigned integers, reverting on
148      * overflow.
149      *
150      * Counterpart to Solidity's `*` operator.
151      *
152      * Requirements:
153      *
154      * - Multiplication cannot overflow.
155      */
156     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
157         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
158         // benefit is lost if 'b' is also tested.
159         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
160         if (a == 0) {
161             return 0;
162         }
163 
164         uint256 c = a * b;
165         require(c / a == b, "SafeMath: multiplication overflow");
166 
167         return c;
168     }
169 
170     /**
171      * @dev Returns the integer division of two unsigned integers. Reverts on
172      * division by zero. The result is rounded towards zero.
173      *
174      * Counterpart to Solidity's `/` operator. Note: this function uses a
175      * `revert` opcode (which leaves remaining gas untouched) while Solidity
176      * uses an invalid opcode to revert (consuming all remaining gas).
177      *
178      * Requirements:
179      *
180      * - The divisor cannot be zero.
181      */
182     function div(uint256 a, uint256 b) internal pure returns (uint256) {
183         return div(a, b, "SafeMath: division by zero");
184     }
185 
186     /**
187      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
188      * division by zero. The result is rounded towards zero.
189      *
190      * Counterpart to Solidity's `/` operator. Note: this function uses a
191      * `revert` opcode (which leaves remaining gas untouched) while Solidity
192      * uses an invalid opcode to revert (consuming all remaining gas).
193      *
194      * Requirements:
195      *
196      * - The divisor cannot be zero.
197      */
198     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
199         require(b > 0, errorMessage);
200         uint256 c = a / b;
201         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
202 
203         return c;
204     }
205 
206     /**
207      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
208      * Reverts when dividing by zero.
209      *
210      * Counterpart to Solidity's `%` operator. This function uses a `revert`
211      * opcode (which leaves remaining gas untouched) while Solidity uses an
212      * invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
219         return mod(a, b, "SafeMath: modulo by zero");
220     }
221 
222     /**
223      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
224      * Reverts with custom message when dividing by zero.
225      *
226      * Counterpart to Solidity's `%` operator. This function uses a `revert`
227      * opcode (which leaves remaining gas untouched) while Solidity uses an
228      * invalid opcode to revert (consuming all remaining gas).
229      *
230      * Requirements:
231      *
232      * - The divisor cannot be zero.
233      */
234     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
235         require(b != 0, errorMessage);
236         return a % b;
237     }
238 }
239 
240 library Address {
241     /**
242      * @dev Returns true if `account` is a contract.
243      *
244      * [IMPORTANT]
245      * ====
246      * It is unsafe to assume that an address for which this function returns
247      * false is an externally-owned account (EOA) and not a contract.
248      *
249      * Among others, `isContract` will return false for the following
250      * types of addresses:
251      *
252      *  - an externally-owned account
253      *  - a contract in construction
254      *  - an address where a contract will be created
255      *  - an address where a contract lived, but was destroyed
256      * ====
257      */
258     function isContract(address account) internal view returns (bool) {
259         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
260         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
261         // for accounts without code, i.e. `keccak256('')`
262         bytes32 codehash;
263         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
264         // solhint-disable-next-line no-inline-assembly
265         assembly { codehash := extcodehash(account) }
266         return (codehash != accountHash && codehash != 0x0);
267     }
268 
269     /**
270      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
271      * `recipient`, forwarding all available gas and reverting on errors.
272      *
273      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
274      * of certain opcodes, possibly making contracts go over the 2300 gas limit
275      * imposed by `transfer`, making them unable to receive funds via
276      * `transfer`. {sendValue} removes this limitation.
277      *
278      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
279      *
280      * IMPORTANT: because control is transferred to `recipient`, care must be
281      * taken to not create reentrancy vulnerabilities. Consider using
282      * {ReentrancyGuard} or the
283      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
284      */
285     function sendValue(address payable recipient, uint256 amount) internal {
286         require(address(this).balance >= amount, "Address: insufficient balance");
287 
288         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
289         (bool success, ) = recipient.call{ value: amount }("");
290         require(success, "Address: unable to send value, recipient may have reverted");
291     }
292 
293     /**
294      * @dev Performs a Solidity function call using a low level `call`. A
295      * plain`call` is an unsafe replacement for a function call: use this
296      * function instead.
297      *
298      * If `target` reverts with a revert reason, it is bubbled up by this
299      * function (like regular Solidity function calls).
300      *
301      * Returns the raw returned data. To convert to the expected return value,
302      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
303      *
304      * Requirements:
305      *
306      * - `target` must be a contract.
307      * - calling `target` with `data` must not revert.
308      *
309      * _Available since v3.1._
310      */
311     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
312       return functionCall(target, data, "Address: low-level call failed");
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
317      * `errorMessage` as a fallback revert reason when `target` reverts.
318      *
319      * _Available since v3.1._
320      */
321     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
322         return _functionCallWithValue(target, data, 0, errorMessage);
323     }
324 
325     /**
326      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
327      * but also transferring `value` wei to `target`.
328      *
329      * Requirements:
330      *
331      * - the calling contract must have an ETH balance of at least `value`.
332      * - the called Solidity function must be `payable`.
333      *
334      * _Available since v3.1._
335      */
336     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
337         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
342      * with `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
347         require(address(this).balance >= value, "Address: insufficient balance for call");
348         return _functionCallWithValue(target, data, value, errorMessage);
349     }
350 
351     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
352         require(isContract(target), "Address: call to non-contract");
353 
354         // solhint-disable-next-line avoid-low-level-calls
355         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
356         if (success) {
357             return returndata;
358         } else {
359             // Look for revert reason and bubble it up if present
360             if (returndata.length > 0) {
361                 // The easiest way to bubble the revert reason is using memory via assembly
362 
363                 // solhint-disable-next-line no-inline-assembly
364                 assembly {
365                     let returndata_size := mload(returndata)
366                     revert(add(32, returndata), returndata_size)
367                 }
368             } else {
369                 revert(errorMessage);
370             }
371         }
372     }
373 }
374 
375 contract Ownable is Context {
376     address private _owner;
377 
378     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
379 
380     /**
381      * @dev Initializes the contract setting the deployer as the initial owner.
382      */
383     constructor () internal {
384         address msgSender = _msgSender();
385         _owner = msgSender;
386         emit OwnershipTransferred(address(0), msgSender);
387     }
388 
389     /**
390      * @dev Returns the address of the current owner.
391      */
392     function owner() public view returns (address) {
393         return _owner;
394     }
395 
396     /**
397      * @dev Throws if called by any account other than the owner.
398      */
399     modifier onlyOwner() {
400         require(_owner == _msgSender(), "Ownable: caller is not the owner");
401         _;
402     }
403 
404     /**
405      * @dev Leaves the contract without owner. It will not be possible to call
406      * `onlyOwner` functions anymore. Can only be called by the current owner.
407      *
408      * NOTE: Renouncing ownership will leave the contract without an owner,
409      * thereby removing any functionality that is only available to the owner.
410      */
411     function renounceOwnership() public virtual onlyOwner {
412         emit OwnershipTransferred(_owner, address(0));
413         _owner = address(0);
414     }
415 
416     /**
417      * @dev Transfers ownership of the contract to a new account (`newOwner`).
418      * Can only be called by the current owner.
419      */
420     function transferOwnership(address newOwner) public virtual onlyOwner {
421         require(newOwner != address(0), "Ownable: new owner is the zero address");
422         emit OwnershipTransferred(_owner, newOwner);
423         _owner = newOwner;
424     }
425 }
426 
427 
428 
429 contract AmericanShiba is Context, IERC20, Ownable {
430     using SafeMath for uint256;
431     using Address for address;
432 
433     mapping (address => uint256) private _rOwned;
434     mapping (address => uint256) private _tOwned;
435     mapping (address => mapping (address => uint256)) private _allowances;
436 
437     mapping (address => bool) private _isExcluded;
438     address[] private _excluded;
439    
440     uint256 private constant MAX = ~uint256(0);
441     uint256 private constant _tTotal = 100000000000 * 10**6 * 10**9;
442     uint256 private _rTotal = (MAX - (MAX % _tTotal));
443     uint256 private _tFeeTotal;
444 
445     string private _name = 'American Shiba';
446     string private _symbol = 'USHIBA';
447     uint8 private _decimals = 9;
448     
449     uint256 public _maxTxAmount = 100000000 * 10**6 * 10**9;
450 
451     constructor () public {
452         _rOwned[_msgSender()] = _rTotal;
453         emit Transfer(address(0), _msgSender(), _tTotal);
454     }
455 
456     function name() public view returns (string memory) {
457         return _name;
458     }
459 
460     function symbol() public view returns (string memory) {
461         return _symbol;
462     }
463 
464     function decimals() public view returns (uint8) {
465         return _decimals;
466     }
467 
468     function totalSupply() public view override returns (uint256) {
469         return _tTotal;
470     }
471 
472     function balanceOf(address account) public view override returns (uint256) {
473         if (_isExcluded[account]) return _tOwned[account];
474         return tokenFromReflection(_rOwned[account]);
475     }
476 
477     function transfer(address recipient, uint256 amount) public override returns (bool) {
478         _transfer(_msgSender(), recipient, amount);
479         return true;
480     }
481 
482     function allowance(address owner, address spender) public view override returns (uint256) {
483         return _allowances[owner][spender];
484     }
485 
486     function approve(address spender, uint256 amount) public override returns (bool) {
487         _approve(_msgSender(), spender, amount);
488         return true;
489     }
490 
491     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
492         _transfer(sender, recipient, amount);
493         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
494         return true;
495     }
496 
497     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
498         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
499         return true;
500     }
501 
502     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
503         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
504         return true;
505     }
506 
507     function isExcluded(address account) public view returns (bool) {
508         return _isExcluded[account];
509     }
510 
511     function totalFees() public view returns (uint256) {
512         return _tFeeTotal;
513     }
514     
515     
516     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
517         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
518             10**2
519         );
520     }
521     
522     function rescueFromContract() external onlyOwner {
523         address payable _owner = _msgSender();
524         _owner.transfer(address(this).balance);
525     }
526 
527     function reflect(uint256 tAmount) public {
528         address sender = _msgSender();
529         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
530         (uint256 rAmount,,,,) = _getValues(tAmount);
531         _rOwned[sender] = _rOwned[sender].sub(rAmount);
532         _rTotal = _rTotal.sub(rAmount);
533         _tFeeTotal = _tFeeTotal.add(tAmount);
534     }
535 
536     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
537         require(tAmount <= _tTotal, "Amount must be less than supply");
538         if (!deductTransferFee) {
539             (uint256 rAmount,,,,) = _getValues(tAmount);
540             return rAmount;
541         } else {
542             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
543             return rTransferAmount;
544         }
545     }
546 
547     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
548         require(rAmount <= _rTotal, "Amount must be less than total reflections");
549         uint256 currentRate =  _getRate();
550         return rAmount.div(currentRate);
551     }
552 
553     function excludeAccount(address account) external onlyOwner() {
554         require(!_isExcluded[account], "Account is already excluded");
555         if(_rOwned[account] > 0) {
556             _tOwned[account] = tokenFromReflection(_rOwned[account]);
557         }
558         _isExcluded[account] = true;
559         _excluded.push(account);
560     }
561 
562     function includeAccount(address account) external onlyOwner() {
563         require(_isExcluded[account], "Account is already excluded");
564         for (uint256 i = 0; i < _excluded.length; i++) {
565             if (_excluded[i] == account) {
566                 _excluded[i] = _excluded[_excluded.length - 1];
567                 _tOwned[account] = 0;
568                 _isExcluded[account] = false;
569                 _excluded.pop();
570                 break;
571             }
572         }
573     }
574 
575     function _approve(address owner, address spender, uint256 amount) private {
576         require(owner != address(0), "ERC20: approve from the zero address");
577         require(spender != address(0), "ERC20: approve to the zero address");
578 
579         _allowances[owner][spender] = amount;
580         emit Approval(owner, spender, amount);
581     }
582 
583     function _transfer(address sender, address recipient, uint256 amount) private {
584         require(sender != address(0), "ERC20: transfer from the zero address");
585         require(recipient != address(0), "ERC20: transfer to the zero address");
586         require(amount > 0, "Transfer amount must be greater than zero");
587         if(sender != owner() && recipient != owner())
588           require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
589             
590         if (_isExcluded[sender] && !_isExcluded[recipient]) {
591             _transferFromExcluded(sender, recipient, amount);
592         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
593             _transferToExcluded(sender, recipient, amount);
594         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
595             _transferStandard(sender, recipient, amount);
596         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
597             _transferBothExcluded(sender, recipient, amount);
598         } else {
599             _transferStandard(sender, recipient, amount);
600         }
601     }
602 
603     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
604         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
605         _rOwned[sender] = _rOwned[sender].sub(rAmount);
606         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
607         _reflectFee(rFee, tFee);
608         emit Transfer(sender, recipient, tTransferAmount);
609     }
610 
611     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
612         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
613         _rOwned[sender] = _rOwned[sender].sub(rAmount);
614         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
615         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
616         _reflectFee(rFee, tFee);
617         emit Transfer(sender, recipient, tTransferAmount);
618     }
619 
620     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
621         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
622         _tOwned[sender] = _tOwned[sender].sub(tAmount);
623         _rOwned[sender] = _rOwned[sender].sub(rAmount);
624         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
625         _reflectFee(rFee, tFee);
626         emit Transfer(sender, recipient, tTransferAmount);
627     }
628 
629     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
630         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
631         _tOwned[sender] = _tOwned[sender].sub(tAmount);
632         _rOwned[sender] = _rOwned[sender].sub(rAmount);
633         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
634         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
635         _reflectFee(rFee, tFee);
636         emit Transfer(sender, recipient, tTransferAmount);
637     }
638 
639     function _reflectFee(uint256 rFee, uint256 tFee) private {
640         _rTotal = _rTotal.sub(rFee);
641         _tFeeTotal = _tFeeTotal.add(tFee);
642     }
643 
644     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
645         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
646         uint256 currentRate =  _getRate();
647         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
648         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
649     }
650 
651     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
652         uint256 tFee = tAmount.div(100).mul(2);
653         uint256 tTransferAmount = tAmount.sub(tFee);
654         return (tTransferAmount, tFee);
655     }
656 
657     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
658         uint256 rAmount = tAmount.mul(currentRate);
659         uint256 rFee = tFee.mul(currentRate);
660         uint256 rTransferAmount = rAmount.sub(rFee);
661         return (rAmount, rTransferAmount, rFee);
662     }
663 
664     function _getRate() private view returns(uint256) {
665         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
666         return rSupply.div(tSupply);
667     }
668 
669     function _getCurrentSupply() private view returns(uint256, uint256) {
670         uint256 rSupply = _rTotal;
671         uint256 tSupply = _tTotal;      
672         for (uint256 i = 0; i < _excluded.length; i++) {
673             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
674             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
675             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
676         }
677         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
678         return (rSupply, tSupply);
679     }
680 }