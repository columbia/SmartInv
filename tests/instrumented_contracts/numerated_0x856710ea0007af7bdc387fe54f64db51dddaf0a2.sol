1 pragma solidity ^0.6.12;
2 
3 abstract contract Context {
4     function _msgSender() internal view virtual returns (address payable) {
5         return msg.sender;
6     }
7 
8     function _msgData() internal view virtual returns (bytes memory) {
9         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
10         return msg.data;
11     }
12 }
13 
14 interface IERC20 {
15     /**
16      * @dev Returns the amount of tokens in existence.
17      */
18     function totalSupply() external view returns (uint256);
19 
20     /**
21      * @dev Returns the amount of tokens owned by `account`.
22      */
23     function balanceOf(address account) external view returns (uint256);
24 
25     /**
26      * @dev Moves `amount` tokens from the caller's account to `recipient`.
27      *
28      * Returns a boolean value indicating whether the operation succeeded.
29      *
30      * Emits a {Transfer} event.
31      */
32     function transfer(address recipient, uint256 amount) external returns (bool);
33 
34     /**
35      * @dev Returns the remaining number of tokens that `spender` will be
36      * allowed to spend on behalf of `owner` through {transferFrom}. This is
37      * zero by default.
38      *
39      * This value changes when {approve} or {transferFrom} are called.
40      */
41     function allowance(address owner, address spender) external view returns (uint256);
42 
43     /**
44      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * IMPORTANT: Beware that changing an allowance with this method brings the risk
49      * that someone may use both the old and the new allowance by unfortunate
50      * transaction ordering. One possible solution to mitigate this race
51      * condition is to first reduce the spender's allowance to 0 and set the
52      * desired value afterwards:
53      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
54      *
55      * Emits an {Approval} event.
56      */
57     function approve(address spender, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Moves `amount` tokens from `sender` to `recipient` using the
61      * allowance mechanism. `amount` is then deducted from the caller's
62      * allowance.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * Emits a {Transfer} event.
67      */
68     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Emitted when `value` tokens are moved from one account (`from`) to
72      * another (`to`).
73      *
74      * Note that `value` may be zero.
75      */
76     event Transfer(address indexed from, address indexed to, uint256 value);
77 
78     /**
79      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
80      * a call to {approve}. `value` is the new allowance.
81      */
82     event Approval(address indexed owner, address indexed spender, uint256 value);
83 }
84 
85 library SafeMath {
86     /**
87      * @dev Returns the addition of two unsigned integers, reverting on
88      * overflow.
89      *
90      * Counterpart to Solidity's `+` operator.
91      *
92      * Requirements:
93      *
94      * - Addition cannot overflow.
95      */
96     function add(uint256 a, uint256 b) internal pure returns (uint256) {
97         uint256 c = a + b;
98         require(c >= a, "SafeMath: addition overflow");
99 
100         return c;
101     }
102 
103     /**
104      * @dev Returns the subtraction of two unsigned integers, reverting on
105      * overflow (when the result is negative).
106      *
107      * Counterpart to Solidity's `-` operator.
108      *
109      * Requirements:
110      *
111      * - Subtraction cannot overflow.
112      */
113     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
114         return sub(a, b, "SafeMath: subtraction overflow");
115     }
116 
117     /**
118      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
119      * overflow (when the result is negative).
120      *
121      * Counterpart to Solidity's `-` operator.
122      *
123      * Requirements:
124      *
125      * - Subtraction cannot overflow.
126      */
127     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
128         require(b <= a, errorMessage);
129         uint256 c = a - b;
130 
131         return c;
132     }
133 
134     /**
135      * @dev Returns the multiplication of two unsigned integers, reverting on
136      * overflow.
137      *
138      * Counterpart to Solidity's `*` operator.
139      *
140      * Requirements:
141      *
142      * - Multiplication cannot overflow.
143      */
144     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
145         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
146         // benefit is lost if 'b' is also tested.
147         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
148         if (a == 0) {
149             return 0;
150         }
151 
152         uint256 c = a * b;
153         require(c / a == b, "SafeMath: multiplication overflow");
154 
155         return c;
156     }
157 
158     /**
159      * @dev Returns the integer division of two unsigned integers. Reverts on
160      * division by zero. The result is rounded towards zero.
161      *
162      * Counterpart to Solidity's `/` operator. Note: this function uses a
163      * `revert` opcode (which leaves remaining gas untouched) while Solidity
164      * uses an invalid opcode to revert (consuming all remaining gas).
165      *
166      * Requirements:
167      *
168      * - The divisor cannot be zero.
169      */
170     function div(uint256 a, uint256 b) internal pure returns (uint256) {
171         return div(a, b, "SafeMath: division by zero");
172     }
173 
174     /**
175      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
176      * division by zero. The result is rounded towards zero.
177      *
178      * Counterpart to Solidity's `/` operator. Note: this function uses a
179      * `revert` opcode (which leaves remaining gas untouched) while Solidity
180      * uses an invalid opcode to revert (consuming all remaining gas).
181      *
182      * Requirements:
183      *
184      * - The divisor cannot be zero.
185      */
186     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
187         require(b > 0, errorMessage);
188         uint256 c = a / b;
189         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
190 
191         return c;
192     }
193 
194     /**
195      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
196      * Reverts when dividing by zero.
197      *
198      * Counterpart to Solidity's `%` operator. This function uses a `revert`
199      * opcode (which leaves remaining gas untouched) while Solidity uses an
200      * invalid opcode to revert (consuming all remaining gas).
201      *
202      * Requirements:
203      *
204      * - The divisor cannot be zero.
205      */
206     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
207         return mod(a, b, "SafeMath: modulo by zero");
208     }
209 
210     /**
211      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
212      * Reverts with custom message when dividing by zero.
213      *
214      * Counterpart to Solidity's `%` operator. This function uses a `revert`
215      * opcode (which leaves remaining gas untouched) while Solidity uses an
216      * invalid opcode to revert (consuming all remaining gas).
217      *
218      * Requirements:
219      *
220      * - The divisor cannot be zero.
221      */
222     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
223         require(b != 0, errorMessage);
224         return a % b;
225     }
226 }
227 
228 library Address {
229     /**
230      * @dev Returns true if `account` is a contract.
231      *
232      * [IMPORTANT]
233      * ====
234      * It is unsafe to assume that an address for which this function returns
235      * false is an externally-owned account (EOA) and not a contract.
236      *
237      * Among others, `isContract` will return false for the following
238      * types of addresses:
239      *
240      *  - an externally-owned account
241      *  - a contract in construction
242      *  - an address where a contract will be created
243      *  - an address where a contract lived, but was destroyed
244      * ====
245      */
246     function isContract(address account) internal view returns (bool) {
247         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
248         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
249         // for accounts without code, i.e. `keccak256('')`
250         bytes32 codehash;
251         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
252         // solhint-disable-next-line no-inline-assembly
253         assembly { codehash := extcodehash(account) }
254         return (codehash != accountHash && codehash != 0x0);
255     }
256 
257     /**
258      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
259      * `recipient`, forwarding all available gas and reverting on errors.
260      *
261      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
262      * of certain opcodes, possibly making contracts go over the 2300 gas limit
263      * imposed by `transfer`, making them unable to receive funds via
264      * `transfer`. {sendValue} removes this limitation.
265      *
266      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
267      *
268      * IMPORTANT: because control is transferred to `recipient`, care must be
269      * taken to not create reentrancy vulnerabilities. Consider using
270      * {ReentrancyGuard} or the
271      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
272      */
273     function sendValue(address payable recipient, uint256 amount) internal {
274         require(address(this).balance >= amount, "Address: insufficient balance");
275 
276         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
277         (bool success, ) = recipient.call{ value: amount }("");
278         require(success, "Address: unable to send value, recipient may have reverted");
279     }
280 
281     /**
282      * @dev Performs a Solidity function call using a low level `call`. A
283      * plain`call` is an unsafe replacement for a function call: use this
284      * function instead.
285      *
286      * If `target` reverts with a revert reason, it is bubbled up by this
287      * function (like regular Solidity function calls).
288      *
289      * Returns the raw returned data. To convert to the expected return value,
290      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
291      *
292      * Requirements:
293      *
294      * - `target` must be a contract.
295      * - calling `target` with `data` must not revert.
296      *
297      * _Available since v3.1._
298      */
299     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
300       return functionCall(target, data, "Address: low-level call failed");
301     }
302 
303     /**
304      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
305      * `errorMessage` as a fallback revert reason when `target` reverts.
306      *
307      * _Available since v3.1._
308      */
309     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
310         return _functionCallWithValue(target, data, 0, errorMessage);
311     }
312 
313     /**
314      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
315      * but also transferring `value` wei to `target`.
316      *
317      * Requirements:
318      *
319      * - the calling contract must have an ETH balance of at least `value`.
320      * - the called Solidity function must be `payable`.
321      *
322      * _Available since v3.1._
323      */
324     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
325         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
330      * with `errorMessage` as a fallback revert reason when `target` reverts.
331      *
332      * _Available since v3.1._
333      */
334     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
335         require(address(this).balance >= value, "Address: insufficient balance for call");
336         return _functionCallWithValue(target, data, value, errorMessage);
337     }
338 
339     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
340         require(isContract(target), "Address: call to non-contract");
341 
342         // solhint-disable-next-line avoid-low-level-calls
343         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
344         if (success) {
345             return returndata;
346         } else {
347             // Look for revert reason and bubble it up if present
348             if (returndata.length > 0) {
349                 // The easiest way to bubble the revert reason is using memory via assembly
350 
351                 // solhint-disable-next-line no-inline-assembly
352                 assembly {
353                     let returndata_size := mload(returndata)
354                     revert(add(32, returndata), returndata_size)
355                 }
356             } else {
357                 revert(errorMessage);
358             }
359         }
360     }
361 }
362 
363 contract Ownable is Context {
364     address private _owner;
365 
366     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
367 
368     /**
369      * @dev Initializes the contract setting the deployer as the initial owner.
370      */
371     constructor () internal {
372         address msgSender = _msgSender();
373         _owner = msgSender;
374         emit OwnershipTransferred(address(0), msgSender);
375     }
376 
377     /**
378      * @dev Returns the address of the current owner.
379      */
380     function owner() public view returns (address) {
381         return _owner;
382     }
383 
384     /**
385      * @dev Throws if called by any account other than the owner.
386      */
387     modifier onlyOwner() {
388         require(_owner == _msgSender(), "Ownable: caller is not the owner");
389         _;
390     }
391 
392     /**
393      * @dev Leaves the contract without owner. It will not be possible to call
394      * `onlyOwner` functions anymore. Can only be called by the current owner.
395      *
396      * NOTE: Renouncing ownership will leave the contract without an owner,
397      * thereby removing any functionality that is only available to the owner.
398      */
399     function renounceOwnership() public virtual onlyOwner {
400         emit OwnershipTransferred(_owner, address(0));
401         _owner = address(0);
402     }
403 
404     /**
405      * @dev Transfers ownership of the contract to a new account (`newOwner`).
406      * Can only be called by the current owner.
407      */
408     function transferOwnership(address newOwner) public virtual onlyOwner {
409         require(newOwner != address(0), "Ownable: new owner is the zero address");
410         emit OwnershipTransferred(_owner, newOwner);
411         _owner = newOwner;
412     }
413 }
414 
415 
416 contract MoonPug is Context, IERC20, Ownable {
417     using SafeMath for uint256;
418     using Address for address;
419 
420     mapping (address => uint256) private _rOwned;
421     mapping (address => uint256) private _tOwned;
422     mapping (address => mapping (address => uint256)) private _allowances;
423 
424     mapping (address => bool) private _isExcluded;
425     address[] private _excluded;
426    
427     uint256 private constant MAX = ~uint256(0);
428     uint256 private constant _tTotal = 100000000000 * 10**6 * 10**9;
429     uint256 private _rTotal = (MAX - (MAX % _tTotal));
430     uint256 private _tFeeTotal;
431 
432     string private _name = 'Moon Pug';
433     string private _symbol = 'MOONPUG';
434     uint8 private _decimals = 9;
435     
436     uint256 public _maxTxAmount = 100000000 * 10**6 * 10**9;
437 
438     constructor () public {
439         _rOwned[_msgSender()] = _rTotal;
440         emit Transfer(address(0), _msgSender(), _tTotal);
441     }
442 
443     function name() public view returns (string memory) {
444         return _name;
445     }
446 
447     function symbol() public view returns (string memory) {
448         return _symbol;
449     }
450 
451     function decimals() public view returns (uint8) {
452         return _decimals;
453     }
454 
455     function totalSupply() public view override returns (uint256) {
456         return _tTotal;
457     }
458 
459     function balanceOf(address account) public view override returns (uint256) {
460         if (_isExcluded[account]) return _tOwned[account];
461         return tokenFromReflection(_rOwned[account]);
462     }
463 
464     function transfer(address recipient, uint256 amount) public override returns (bool) {
465         _transfer(_msgSender(), recipient, amount);
466         return true;
467     }
468 
469     function allowance(address owner, address spender) public view override returns (uint256) {
470         return _allowances[owner][spender];
471     }
472 
473     function approve(address spender, uint256 amount) public override returns (bool) {
474         _approve(_msgSender(), spender, amount);
475         return true;
476     }
477 
478     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
479         _transfer(sender, recipient, amount);
480         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
481         return true;
482     }
483 
484     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
485         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
486         return true;
487     }
488 
489     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
490         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
491         return true;
492     }
493 
494     function isExcluded(address account) public view returns (bool) {
495         return _isExcluded[account];
496     }
497 
498     function totalFees() public view returns (uint256) {
499         return _tFeeTotal;
500     }
501     
502     
503     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
504         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
505             10**2
506         );
507     }
508 
509     function reflect(uint256 tAmount) public {
510         address sender = _msgSender();
511         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
512         (uint256 rAmount,,,,) = _getValues(tAmount);
513         _rOwned[sender] = _rOwned[sender].sub(rAmount);
514         _rTotal = _rTotal.sub(rAmount);
515         _tFeeTotal = _tFeeTotal.add(tAmount);
516     }
517 
518     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
519         require(tAmount <= _tTotal, "Amount must be less than supply");
520         if (!deductTransferFee) {
521             (uint256 rAmount,,,,) = _getValues(tAmount);
522             return rAmount;
523         } else {
524             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
525             return rTransferAmount;
526         }
527     }
528 
529     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
530         require(rAmount <= _rTotal, "Amount must be less than total reflections");
531         uint256 currentRate =  _getRate();
532         return rAmount.div(currentRate);
533     }
534     
535     function includeAccount(address account) external onlyOwner() {
536         require(_isExcluded[account], "Account is already excluded");
537         for (uint256 i = 0; i < _excluded.length; i++) {
538             if (_excluded[i] == account) {
539                 _excluded[i] = _excluded[_excluded.length - 1];
540                 _tOwned[account] = 0;
541                 _isExcluded[account] = false;
542                 _excluded.pop();
543                 break;
544             }
545         }
546     }
547     
548     function excludeAccount(address account) external onlyOwner() {
549         require(!_isExcluded[account], "Account is already excluded");
550         if(_rOwned[account] > 0) {
551             _tOwned[account] = tokenFromReflection(_rOwned[account]);
552         }
553         _isExcluded[account] = true;
554         _excluded.push(account);
555     }
556 
557     function _approve(address owner, address spender, uint256 amount) private {
558         require(owner != address(0), "ERC20: approve from the zero address");
559         require(spender != address(0), "ERC20: approve to the zero address");
560 
561         _allowances[owner][spender] = amount;
562         emit Approval(owner, spender, amount);
563     }
564 
565     function _transfer(address sender, address recipient, uint256 amount) private {
566         require(sender != address(0), "ERC20: transfer from the zero address");
567         require(recipient != address(0), "ERC20: transfer to the zero address");
568         require(amount > 0, "Transfer amount must be greater than zero");
569         if(sender != owner() && recipient != owner())
570           require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
571             
572         if (_isExcluded[sender] && !_isExcluded[recipient]) {
573             _transferFromExcluded(sender, recipient, amount);
574         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
575             _transferToExcluded(sender, recipient, amount);
576         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
577             _transferStandard(sender, recipient, amount);
578         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
579             _transferBothExcluded(sender, recipient, amount);
580         } else {
581             _transferStandard(sender, recipient, amount);
582         }
583     }
584 
585     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
586         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
587         _rOwned[sender] = _rOwned[sender].sub(rAmount);
588         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
589         _reflectFee(rFee, tFee);
590         emit Transfer(sender, recipient, tTransferAmount);
591     }
592 
593     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
594         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
595         _rOwned[sender] = _rOwned[sender].sub(rAmount);
596         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
597         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
598         _reflectFee(rFee, tFee);
599         emit Transfer(sender, recipient, tTransferAmount);
600     }
601 
602     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
603         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
604         _tOwned[sender] = _tOwned[sender].sub(tAmount);
605         _rOwned[sender] = _rOwned[sender].sub(rAmount);
606         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
607         _reflectFee(rFee, tFee);
608         emit Transfer(sender, recipient, tTransferAmount);
609     }
610 
611     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
612         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
613         _tOwned[sender] = _tOwned[sender].sub(tAmount);
614         _rOwned[sender] = _rOwned[sender].sub(rAmount);
615         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
616         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
617         _reflectFee(rFee, tFee);
618         emit Transfer(sender, recipient, tTransferAmount);
619     }
620 
621     function _reflectFee(uint256 rFee, uint256 tFee) private {
622         _rTotal = _rTotal.sub(rFee);
623         _tFeeTotal = _tFeeTotal.add(tFee);
624     }
625     function _getCurrentSupply() private view returns(uint256, uint256) {
626         uint256 rSupply = _rTotal;
627         uint256 tSupply = _tTotal;      
628         for (uint256 i = 0; i < _excluded.length; i++) {
629             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
630             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
631             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
632         }
633         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
634         return (rSupply, tSupply);
635     }
636     
637     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
638         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
639         uint256 currentRate =  _getRate();
640         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
641         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
642     }
643 
644     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
645         uint256 rAmount = tAmount.mul(currentRate);
646         uint256 rFee = tFee.mul(currentRate);
647         uint256 rTransferAmount = rAmount.sub(rFee);
648         return (rAmount, rTransferAmount, rFee);
649     }
650     
651     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
652         uint256 tFee = tAmount.div(100).mul(2);
653         uint256 tTransferAmount = tAmount.sub(tFee);
654         return (tTransferAmount, tFee);
655     }
656     
657     function _getRate() private view returns(uint256) {
658         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
659         return rSupply.div(tSupply);
660     }
661 
662 
663 }