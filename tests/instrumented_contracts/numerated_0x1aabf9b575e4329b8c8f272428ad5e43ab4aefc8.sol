1 // Contract Audit
2 // BUGG = BUGG.GG
3 
4 pragma solidity ^0.6.12;
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
17 interface IERC20 {
18     /**
19      * @dev Returns the amount of tokens in existence.
20      */
21     function totalSupply() external view returns (uint256);
22 
23     /**
24      * @dev Returns the amount of tokens owned by `account`.
25      */
26     function balanceOf(address account) external view returns (uint256);
27 
28     /**
29      * @dev Moves `amount` tokens from the caller's account to `recipient`.
30      *
31      * Returns a boolean value indicating whether the operation succeeded.
32      *
33      * Emits a {Transfer} event.
34      */
35     function transfer(address recipient, uint256 amount) external returns (bool);
36 
37     /**
38      * @dev Returns the remaining number of tokens that `spender` will be
39      * allowed to spend on behalf of `owner` through {transferFrom}. This is
40      * zero by default.
41      *
42      * This value changes when {approve} or {transferFrom} are called.
43      */
44     function allowance(address owner, address spender) external view returns (uint256);
45 
46     /**
47      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * IMPORTANT: Beware that changing an allowance with this method brings the risk
52      * that someone may use both the old and the new allowance by unfortunate
53      * transaction ordering. One possible solution to mitigate this race
54      * condition is to first reduce the spender's allowance to 0 and set the
55      * desired value afterwards:
56      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
57      *
58      * Emits an {Approval} event.
59      */
60     function approve(address spender, uint256 amount) external returns (bool);
61 
62     /**
63      * @dev Moves `amount` tokens from `sender` to `recipient` using the
64      * allowance mechanism. `amount` is then deducted from the caller's
65      * allowance.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * Emits a {Transfer} event.
70      */
71     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(address indexed owner, address indexed spender, uint256 value);
86 }
87 
88 library SafeMath {
89     /**
90      * @dev Returns the addition of two unsigned integers, reverting on
91      * overflow.
92      *
93      * Counterpart to Solidity's `+` operator.
94      *
95      * Requirements:
96      *
97      * - Addition cannot overflow.
98      */
99     function add(uint256 a, uint256 b) internal pure returns (uint256) {
100         uint256 c = a + b;
101         require(c >= a, "SafeMath: addition overflow");
102 
103         return c;
104     }
105 
106     /**
107      * @dev Returns the subtraction of two unsigned integers, reverting on
108      * overflow (when the result is negative).
109      *
110      * Counterpart to Solidity's `-` operator.
111      *
112      * Requirements:
113      *
114      * - Subtraction cannot overflow.
115      */
116     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
117         return sub(a, b, "SafeMath: subtraction overflow");
118     }
119 
120     /**
121      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
122      * overflow (when the result is negative).
123      *
124      * Counterpart to Solidity's `-` operator.
125      *
126      * Requirements:
127      *
128      * - Subtraction cannot overflow.
129      */
130     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
131         require(b <= a, errorMessage);
132         uint256 c = a - b;
133 
134         return c;
135     }
136 
137     /**
138      * @dev Returns the multiplication of two unsigned integers, reverting on
139      * overflow.
140      *
141      * Counterpart to Solidity's `*` operator.
142      *
143      * Requirements:
144      *
145      * - Multiplication cannot overflow.
146      */
147     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
148         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
149         // benefit is lost if 'b' is also tested.
150         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
151         if (a == 0) {
152             return 0;
153         }
154 
155         uint256 c = a * b;
156         require(c / a == b, "SafeMath: multiplication overflow");
157 
158         return c;
159     }
160 
161     /**
162      * @dev Returns the integer division of two unsigned integers. Reverts on
163      * division by zero. The result is rounded towards zero.
164      *
165      * Counterpart to Solidity's `/` operator. Note: this function uses a
166      * `revert` opcode (which leaves remaining gas untouched) while Solidity
167      * uses an invalid opcode to revert (consuming all remaining gas).
168      *
169      * Requirements:
170      *
171      * - The divisor cannot be zero.
172      */
173     function div(uint256 a, uint256 b) internal pure returns (uint256) {
174         return div(a, b, "SafeMath: division by zero");
175     }
176 
177     /**
178      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
189     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
190         require(b > 0, errorMessage);
191         uint256 c = a / b;
192         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
193 
194         return c;
195     }
196 
197     /**
198      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
199      * Reverts when dividing by zero.
200      *
201      * Counterpart to Solidity's `%` operator. This function uses a `revert`
202      * opcode (which leaves remaining gas untouched) while Solidity uses an
203      * invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      *
207      * - The divisor cannot be zero.
208      */
209     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
210         return mod(a, b, "SafeMath: modulo by zero");
211     }
212 
213     /**
214      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
215      * Reverts with custom message when dividing by zero.
216      *
217      * Counterpart to Solidity's `%` operator. This function uses a `revert`
218      * opcode (which leaves remaining gas untouched) while Solidity uses an
219      * invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
226         require(b != 0, errorMessage);
227         return a % b;
228     }
229 }
230 
231 library Address {
232     /**
233      * @dev Returns true if `account` is a contract.
234      *
235      * [IMPORTANT]
236      * ====
237      * It is unsafe to assume that an address for which this function returns
238      * false is an externally-owned account (EOA) and not a contract.
239      *
240      * Among others, `isContract` will return false for the following
241      * types of addresses:
242      *
243      *  - an externally-owned account
244      *  - a contract in construction
245      *  - an address where a contract will be created
246      *  - an address where a contract lived, but was destroyed
247      * ====
248      */
249     function isContract(address account) internal view returns (bool) {
250         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
251         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
252         // for accounts without code, i.e. `keccak256('')`
253         bytes32 codehash;
254         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
255         // solhint-disable-next-line no-inline-assembly
256         assembly { codehash := extcodehash(account) }
257         return (codehash != accountHash && codehash != 0x0);
258     }
259 
260     /**
261      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
262      * `recipient`, forwarding all available gas and reverting on errors.
263      *
264      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
265      * of certain opcodes, possibly making contracts go over the 2300 gas limit
266      * imposed by `transfer`, making them unable to receive funds via
267      * `transfer`. {sendValue} removes this limitation.
268      *
269      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
270      *
271      * IMPORTANT: because control is transferred to `recipient`, care must be
272      * taken to not create reentrancy vulnerabilities. Consider using
273      * {ReentrancyGuard} or the
274      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
275      */
276     function sendValue(address payable recipient, uint256 amount) internal {
277         require(address(this).balance >= amount, "Address: insufficient balance");
278 
279         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
280         (bool success, ) = recipient.call{ value: amount }("");
281         require(success, "Address: unable to send value, recipient may have reverted");
282     }
283 
284     /**
285      * @dev Performs a Solidity function call using a low level `call`. A
286      * plain`call` is an unsafe replacement for a function call: use this
287      * function instead.
288      *
289      * If `target` reverts with a revert reason, it is bubbled up by this
290      * function (like regular Solidity function calls).
291      *
292      * Returns the raw returned data. To convert to the expected return value,
293      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
294      *
295      * Requirements:
296      *
297      * - `target` must be a contract.
298      * - calling `target` with `data` must not revert.
299      *
300      * _Available since v3.1._
301      */
302     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
303       return functionCall(target, data, "Address: low-level call failed");
304     }
305 
306     /**
307      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
308      * `errorMessage` as a fallback revert reason when `target` reverts.
309      *
310      * _Available since v3.1._
311      */
312     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
313         return _functionCallWithValue(target, data, 0, errorMessage);
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
318      * but also transferring `value` wei to `target`.
319      *
320      * Requirements:
321      *
322      * - the calling contract must have an ETH balance of at least `value`.
323      * - the called Solidity function must be `payable`.
324      *
325      * _Available since v3.1._
326      */
327     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
328         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
329     }
330 
331     /**
332      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
333      * with `errorMessage` as a fallback revert reason when `target` reverts.
334      *
335      * _Available since v3.1._
336      */
337     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
338         require(address(this).balance >= value, "Address: insufficient balance for call");
339         return _functionCallWithValue(target, data, value, errorMessage);
340     }
341 
342     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
343         require(isContract(target), "Address: call to non-contract");
344 
345         // solhint-disable-next-line avoid-low-level-calls
346         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
347         if (success) {
348             return returndata;
349         } else {
350             // Look for revert reason and bubble it up if present
351             if (returndata.length > 0) {
352                 // The easiest way to bubble the revert reason is using memory via assembly
353 
354                 // solhint-disable-next-line no-inline-assembly
355                 assembly {
356                     let returndata_size := mload(returndata)
357                     revert(add(32, returndata), returndata_size)
358                 }
359             } else {
360                 revert(errorMessage);
361             }
362         }
363     }
364 }
365 
366 contract Ownable is Context {
367     address private _owner;
368 
369     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
370 
371     /**
372      * @dev Initializes the contract setting the deployer as the initial owner.
373      */
374     constructor () internal {
375         address msgSender = _msgSender();
376         _owner = msgSender;
377         emit OwnershipTransferred(address(0), msgSender);
378     }
379 
380     /**
381      * @dev Returns the address of the current owner.
382      */
383     function owner() public view returns (address) {
384         return _owner;
385     }
386 
387     /**
388      * @dev Throws if called by any account other than the owner.
389      */
390     modifier onlyOwner() {
391         require(_owner == _msgSender(), "Ownable: caller is not the owner");
392         _;
393     }
394 
395     /**
396      * @dev Leaves the contract without owner. It will not be possible to call
397      * `onlyOwner` functions anymore. Can only be called by the current owner.
398      *
399      * NOTE: Renouncing ownership will leave the contract without an owner,
400      * thereby removing any functionality that is only available to the owner.
401      */
402     function renounceOwnership() public virtual onlyOwner {
403         emit OwnershipTransferred(_owner, address(0));
404         _owner = address(0);
405     }
406 
407     /**
408      * @dev Transfers ownership of the contract to a new account (`newOwner`).
409      * Can only be called by the current owner.
410      */
411     function transferOwnership(address newOwner) public virtual onlyOwner {
412         require(newOwner != address(0), "Ownable: new owner is the zero address");
413         emit OwnershipTransferred(_owner, newOwner);
414         _owner = newOwner;
415     }
416 }
417 
418 
419 
420 contract Bugg is Context, IERC20, Ownable {
421     using SafeMath for uint256;
422     using Address for address;
423 
424     mapping (address => uint256) private _rOwned;
425     mapping (address => uint256) private _tOwned;
426     mapping (address => mapping (address => uint256)) private _allowances;
427 
428     mapping (address => bool) private _isExcluded;
429     address[] private _excluded;
430    
431     uint256 private constant MAX = ~uint256(0);
432     uint256 private constant _tTotal = 100000000000 * 10**6 * 10**9;
433     uint256 private _rTotal = (MAX - (MAX % _tTotal));
434     uint256 private _tFeeTotal;
435 
436     string private _name = 'Bugg Inu';
437     string private _symbol = 'BUGG';
438     uint8 private _decimals = 9;
439     uint256 public _maxTxAmount = 500000000 * 10**6 * 10**9;
440 
441 
442     constructor () public {
443         _rOwned[_msgSender()] = _rTotal;
444         emit Transfer(address(0), _msgSender(), _tTotal);
445     }
446 
447     function name() public view returns (string memory) {
448         return _name;
449     }
450 
451     function symbol() public view returns (string memory) {
452         return _symbol;
453     }
454 
455     function decimals() public view returns (uint8) {
456         return _decimals;
457     }
458 
459     function totalSupply() public view override returns (uint256) {
460         return _tTotal;
461     }
462 
463     function balanceOf(address account) public view override returns (uint256) {
464         if (_isExcluded[account]) return _tOwned[account];
465         return tokenFromReflection(_rOwned[account]);
466     }
467 
468     function transfer(address recipient, uint256 amount) public override returns (bool) {
469         _transfer(_msgSender(), recipient, amount);
470         return true;
471     }
472 
473     function allowance(address owner, address spender) public view override returns (uint256) {
474         return _allowances[owner][spender];
475     }
476 
477     function approve(address spender, uint256 amount) public override returns (bool) {
478         _approve(_msgSender(), spender, amount);
479         return true;
480     }
481 
482     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
483         _transfer(sender, recipient, amount);
484         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
485         return true;
486     }
487 
488     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
489         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
490         return true;
491     }
492 
493     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
494         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
495         return true;
496     }
497 
498     function isExcluded(address account) public view returns (bool) {
499         return _isExcluded[account];
500     }
501 
502     function totalFees() public view returns (uint256) {
503         return _tFeeTotal;
504     }
505     
506     
507     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
508         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
509             10**2
510         );
511     }
512 
513     function reflect(uint256 tAmount) public {
514         address sender = _msgSender();
515         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
516         (uint256 rAmount,,,,) = _getValues(tAmount);
517         _rOwned[sender] = _rOwned[sender].sub(rAmount);
518         _rTotal = _rTotal.sub(rAmount);
519         _tFeeTotal = _tFeeTotal.add(tAmount);
520     }
521 
522     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
523         require(tAmount <= _tTotal, "Amount must be less than supply");
524         if (!deductTransferFee) {
525             (uint256 rAmount,,,,) = _getValues(tAmount);
526             return rAmount;
527         } else {
528             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
529             return rTransferAmount;
530         }
531     }
532 
533     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
534         require(rAmount <= _rTotal, "Amount must be less than total reflections");
535         uint256 currentRate =  _getRate();
536         return rAmount.div(currentRate);
537     }
538 
539     function excludeAccount(address account) external onlyOwner() {
540         require(!_isExcluded[account], "Account is already excluded");
541         if(_rOwned[account] > 0) {
542             _tOwned[account] = tokenFromReflection(_rOwned[account]);
543         }
544         _isExcluded[account] = true;
545         _excluded.push(account);
546     }
547 
548     function includeAccount(address account) external onlyOwner() {
549         require(_isExcluded[account], "Account is already excluded");
550         for (uint256 i = 0; i < _excluded.length; i++) {
551             if (_excluded[i] == account) {
552                 _excluded[i] = _excluded[_excluded.length - 1];
553                 _tOwned[account] = 0;
554                 _isExcluded[account] = false;
555                 _excluded.pop();
556                 break;
557             }
558         }
559     }
560 
561     function _approve(address owner, address spender, uint256 amount) private {
562         require(owner != address(0), "ERC20: approve from the zero address");
563         require(spender != address(0), "ERC20: approve to the zero address");
564 
565         _allowances[owner][spender] = amount;
566         emit Approval(owner, spender, amount);
567     }
568 
569     function _transfer(address sender, address recipient, uint256 amount) private {
570         require(sender != address(0), "ERC20: transfer from the zero address");
571         require(recipient != address(0), "ERC20: transfer to the zero address");
572         require(amount > 0, "Transfer amount must be greater than zero");
573         if(sender != owner() && recipient != owner())
574           require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
575             
576         if (_isExcluded[sender] && !_isExcluded[recipient]) {
577             _transferFromExcluded(sender, recipient, amount);
578         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
579             _transferToExcluded(sender, recipient, amount);
580         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
581             _transferStandard(sender, recipient, amount);
582         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
583             _transferBothExcluded(sender, recipient, amount);
584         } else {
585             _transferStandard(sender, recipient, amount);
586         }
587     }
588 
589     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
590         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
591         _rOwned[sender] = _rOwned[sender].sub(rAmount);
592         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
593         _reflectFee(rFee, tFee);
594         emit Transfer(sender, recipient, tTransferAmount);
595     }
596 
597     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
598         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
599         _rOwned[sender] = _rOwned[sender].sub(rAmount);
600         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
601         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
602         _reflectFee(rFee, tFee);
603         emit Transfer(sender, recipient, tTransferAmount);
604     }
605 
606     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
607         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
608         _tOwned[sender] = _tOwned[sender].sub(tAmount);
609         _rOwned[sender] = _rOwned[sender].sub(rAmount);
610         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
611         _reflectFee(rFee, tFee);
612         emit Transfer(sender, recipient, tTransferAmount);
613     }
614 
615     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
616         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
617         _tOwned[sender] = _tOwned[sender].sub(tAmount);
618         _rOwned[sender] = _rOwned[sender].sub(rAmount);
619         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
620         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
621         _reflectFee(rFee, tFee);
622         emit Transfer(sender, recipient, tTransferAmount);
623     }
624 
625     function _reflectFee(uint256 rFee, uint256 tFee) private {
626         _rTotal = _rTotal.sub(rFee);
627         _tFeeTotal = _tFeeTotal.add(tFee);
628     }
629 
630     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
631         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
632         uint256 currentRate =  _getRate();
633         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
634         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
635     }
636 
637     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
638         uint256 tFee = tAmount.div(100).mul(2);
639         uint256 tTransferAmount = tAmount.sub(tFee);
640         return (tTransferAmount, tFee);
641     }
642 
643     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
644         uint256 rAmount = tAmount.mul(currentRate);
645         uint256 rFee = tFee.mul(currentRate);
646         uint256 rTransferAmount = rAmount.sub(rFee);
647         return (rAmount, rTransferAmount, rFee);
648     }
649 
650     function _getRate() private view returns(uint256) {
651         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
652         return rSupply.div(tSupply);
653     }
654 
655     function _getCurrentSupply() private view returns(uint256, uint256) {
656         uint256 rSupply = _rTotal;
657         uint256 tSupply = _tTotal;      
658         for (uint256 i = 0; i < _excluded.length; i++) {
659             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
660             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
661             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
662         }
663         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
664         return (rSupply, tSupply);
665     }
666 }