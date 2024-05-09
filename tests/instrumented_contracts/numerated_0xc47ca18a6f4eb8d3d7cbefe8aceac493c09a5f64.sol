1 /**
2 
3     https://nyanshib.io/
4     https://t.me/nyanshib
5 
6 **/
7 
8 // SPDX-License-Identifier: Unlicensed
9 pragma solidity ^0.6.12;
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
22 interface IERC20 {
23     /**
24      * @dev Returns the amount of tokens in existence.
25      */
26     function totalSupply() external view returns (uint256);
27 
28     /**
29      * @dev Returns the amount of tokens owned by `account`.
30      */
31     function balanceOf(address account) external view returns (uint256);
32 
33     /**
34      * @dev Moves `amount` tokens from the caller's account to `recipient`.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * Emits a {Transfer} event.
39      */
40     function transfer(address recipient, uint256 amount) external returns (bool);
41 
42     /**
43      * @dev Returns the remaining number of tokens that `spender` will be
44      * allowed to spend on behalf of `owner` through {transferFrom}. This is
45      * zero by default.
46      *
47      * This value changes when {approve} or {transferFrom} are called.
48      */
49     function allowance(address owner, address spender) external view returns (uint256);
50 
51     /**
52      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * IMPORTANT: Beware that changing an allowance with this method brings the risk
57      * that someone may use both the old and the new allowance by unfortunate
58      * transaction ordering. One possible solution to mitigate this race
59      * condition is to first reduce the spender's allowance to 0 and set the
60      * desired value afterwards:
61      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
62      *
63      * Emits an {Approval} event.
64      */
65     function approve(address spender, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Moves `amount` tokens from `sender` to `recipient` using the
69      * allowance mechanism. `amount` is then deducted from the caller's
70      * allowance.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * Emits a {Transfer} event.
75      */
76     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Emitted when `value` tokens are moved from one account (`from`) to
80      * another (`to`).
81      *
82      * Note that `value` may be zero.
83      */
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     /**
87      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
88      * a call to {approve}. `value` is the new allowance.
89      */
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 library SafeMath {
94     /**
95      * @dev Returns the addition of two unsigned integers, reverting on
96      * overflow.
97      *
98      * Counterpart to Solidity's `+` operator.
99      *
100      * Requirements:
101      *
102      * - Addition cannot overflow.
103      */
104     function add(uint256 a, uint256 b) internal pure returns (uint256) {
105         uint256 c = a + b;
106         require(c >= a, "SafeMath: addition overflow");
107 
108         return c;
109     }
110 
111     /**
112      * @dev Returns the subtraction of two unsigned integers, reverting on
113      * overflow (when the result is negative).
114      *
115      * Counterpart to Solidity's `-` operator.
116      *
117      * Requirements:
118      *
119      * - Subtraction cannot overflow.
120      */
121     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
122         return sub(a, b, "SafeMath: subtraction overflow");
123     }
124 
125     /**
126      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
127      * overflow (when the result is negative).
128      *
129      * Counterpart to Solidity's `-` operator.
130      *
131      * Requirements:
132      *
133      * - Subtraction cannot overflow.
134      */
135     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
136         require(b <= a, errorMessage);
137         uint256 c = a - b;
138 
139         return c;
140     }
141 
142     /**
143      * @dev Returns the multiplication of two unsigned integers, reverting on
144      * overflow.
145      *
146      * Counterpart to Solidity's `*` operator.
147      *
148      * Requirements:
149      *
150      * - Multiplication cannot overflow.
151      */
152     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
153         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
154         // benefit is lost if 'b' is also tested.
155         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
156         if (a == 0) {
157             return 0;
158         }
159 
160         uint256 c = a * b;
161         require(c / a == b, "SafeMath: multiplication overflow");
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the integer division of two unsigned integers. Reverts on
168      * division by zero. The result is rounded towards zero.
169      *
170      * Counterpart to Solidity's `/` operator. Note: this function uses a
171      * `revert` opcode (which leaves remaining gas untouched) while Solidity
172      * uses an invalid opcode to revert (consuming all remaining gas).
173      *
174      * Requirements:
175      *
176      * - The divisor cannot be zero.
177      */
178     function div(uint256 a, uint256 b) internal pure returns (uint256) {
179         return div(a, b, "SafeMath: division by zero");
180     }
181 
182     /**
183      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
194     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
195         require(b > 0, errorMessage);
196         uint256 c = a / b;
197         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
204      * Reverts when dividing by zero.
205      *
206      * Counterpart to Solidity's `%` operator. This function uses a `revert`
207      * opcode (which leaves remaining gas untouched) while Solidity uses an
208      * invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
215         return mod(a, b, "SafeMath: modulo by zero");
216     }
217 
218     /**
219      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
220      * Reverts with custom message when dividing by zero.
221      *
222      * Counterpart to Solidity's `%` operator. This function uses a `revert`
223      * opcode (which leaves remaining gas untouched) while Solidity uses an
224      * invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
231         require(b != 0, errorMessage);
232         return a % b;
233     }
234 }
235 
236 library Address {
237     /**
238      * @dev Returns true if `account` is a contract.
239      *
240      * [IMPORTANT]
241      * ====
242      * It is unsafe to assume that an address for which this function returns
243      * false is an externally-owned account (EOA) and not a contract.
244      *
245      * Among others, `isContract` will return false for the following
246      * types of addresses:
247      *
248      *  - an externally-owned account
249      *  - a contract in construction
250      *  - an address where a contract will be created
251      *  - an address where a contract lived, but was destroyed
252      * ====
253      */
254     function isContract(address account) internal view returns (bool) {
255         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
256         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
257         // for accounts without code, i.e. `keccak256('')`
258         bytes32 codehash;
259         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
260         // solhint-disable-next-line no-inline-assembly
261         assembly { codehash := extcodehash(account) }
262         return (codehash != accountHash && codehash != 0x0);
263     }
264 
265     /**
266      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
267      * `recipient`, forwarding all available gas and reverting on errors.
268      *
269      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
270      * of certain opcodes, possibly making contracts go over the 2300 gas limit
271      * imposed by `transfer`, making them unable to receive funds via
272      * `transfer`. {sendValue} removes this limitation.
273      *
274      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
275      *
276      * IMPORTANT: because control is transferred to `recipient`, care must be
277      * taken to not create reentrancy vulnerabilities. Consider using
278      * {ReentrancyGuard} or the
279      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
280      */
281     function sendValue(address payable recipient, uint256 amount) internal {
282         require(address(this).balance >= amount, "Address: insufficient balance");
283 
284         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
285         (bool success, ) = recipient.call{ value: amount }("");
286         require(success, "Address: unable to send value, recipient may have reverted");
287     }
288 
289     /**
290      * @dev Performs a Solidity function call using a low level `call`. A
291      * plain`call` is an unsafe replacement for a function call: use this
292      * function instead.
293      *
294      * If `target` reverts with a revert reason, it is bubbled up by this
295      * function (like regular Solidity function calls).
296      *
297      * Returns the raw returned data. To convert to the expected return value,
298      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
299      *
300      * Requirements:
301      *
302      * - `target` must be a contract.
303      * - calling `target` with `data` must not revert.
304      *
305      * _Available since v3.1._
306      */
307     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
308       return functionCall(target, data, "Address: low-level call failed");
309     }
310 
311     /**
312      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
313      * `errorMessage` as a fallback revert reason when `target` reverts.
314      *
315      * _Available since v3.1._
316      */
317     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
318         return _functionCallWithValue(target, data, 0, errorMessage);
319     }
320 
321     /**
322      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
323      * but also transferring `value` wei to `target`.
324      *
325      * Requirements:
326      *
327      * - the calling contract must have an ETH balance of at least `value`.
328      * - the called Solidity function must be `payable`.
329      *
330      * _Available since v3.1._
331      */
332     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
333         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
338      * with `errorMessage` as a fallback revert reason when `target` reverts.
339      *
340      * _Available since v3.1._
341      */
342     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
343         require(address(this).balance >= value, "Address: insufficient balance for call");
344         return _functionCallWithValue(target, data, value, errorMessage);
345     }
346 
347     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
348         require(isContract(target), "Address: call to non-contract");
349 
350         // solhint-disable-next-line avoid-low-level-calls
351         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
352         if (success) {
353             return returndata;
354         } else {
355             // Look for revert reason and bubble it up if present
356             if (returndata.length > 0) {
357                 // The easiest way to bubble the revert reason is using memory via assembly
358 
359                 // solhint-disable-next-line no-inline-assembly
360                 assembly {
361                     let returndata_size := mload(returndata)
362                     revert(add(32, returndata), returndata_size)
363                 }
364             } else {
365                 revert(errorMessage);
366             }
367         }
368     }
369 }
370 
371 contract Ownable is Context {
372     address private _owner;
373 
374     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
375 
376     /**
377      * @dev Initializes the contract setting the deployer as the initial owner.
378      */
379     constructor () internal {
380         address msgSender = _msgSender();
381         _owner = msgSender;
382         emit OwnershipTransferred(address(0), msgSender);
383     }
384 
385     /**
386      * @dev Returns the address of the current owner.
387      */
388     function owner() public view returns (address) {
389         return _owner;
390     }
391 
392     /**
393      * @dev Throws if called by any account other than the owner.
394      */
395     modifier onlyOwner() {
396         require(_owner == _msgSender(), "Ownable: caller is not the owner");
397         _;
398     }
399 
400     /**
401      * @dev Leaves the contract without owner. It will not be possible to call
402      * `onlyOwner` functions anymore. Can only be called by the current owner.
403      *
404      * NOTE: Renouncing ownership will leave the contract without an owner,
405      * thereby removing any functionality that is only available to the owner.
406      */
407     function renounceOwnership() public virtual onlyOwner {
408         emit OwnershipTransferred(_owner, address(0));
409         _owner = address(0);
410     }
411 
412     /**
413      * @dev Transfers ownership of the contract to a new account (`newOwner`).
414      * Can only be called by the current owner.
415      */
416     function transferOwnership(address newOwner) public virtual onlyOwner {
417         require(newOwner != address(0), "Ownable: new owner is the zero address");
418         emit OwnershipTransferred(_owner, newOwner);
419         _owner = newOwner;
420     }
421 }
422 
423 
424 contract NYANSHIB is Context, IERC20, Ownable {
425     using SafeMath for uint256;
426     using Address for address;
427 
428     mapping (address => uint256) private _rOwned;
429     mapping (address => uint256) private _tOwned;
430     mapping (address => mapping (address => uint256)) private _allowances;
431 
432     mapping (address => bool) private _isExcluded;
433     address[] private _excluded;
434    
435     uint256 private constant MAX = ~uint256(0);
436     uint256 private constant _tTotal = 100000000000 * 10**6 * 10**9;
437     uint256 private _rTotal = (MAX - (MAX % _tTotal));
438     uint256 private _tFeeTotal;
439 
440     string private _name = 'NYANSHIB';
441     string private _symbol = 'NYANSHIB';
442     uint8 private _decimals = 9;
443     
444     uint256 public _maxTxAmount = 100000000 * 10**6 * 10**9;
445 
446     constructor () public {
447         _rOwned[_msgSender()] = _rTotal;
448         emit Transfer(address(0), _msgSender(), _tTotal);
449     }
450 
451     function name() public view returns (string memory) {
452         return _name;
453     }
454 
455     function symbol() public view returns (string memory) {
456         return _symbol;
457     }
458 
459     function decimals() public view returns (uint8) {
460         return _decimals;
461     }
462 
463     function totalSupply() public view override returns (uint256) {
464         return _tTotal;
465     }
466 
467     function balanceOf(address account) public view override returns (uint256) {
468         if (_isExcluded[account]) return _tOwned[account];
469         return tokenFromReflection(_rOwned[account]);
470     }
471 
472     function transfer(address recipient, uint256 amount) public override returns (bool) {
473         _transfer(_msgSender(), recipient, amount);
474         return true;
475     }
476 
477     function allowance(address owner, address spender) public view override returns (uint256) {
478         return _allowances[owner][spender];
479     }
480 
481     function approve(address spender, uint256 amount) public override returns (bool) {
482         _approve(_msgSender(), spender, amount);
483         return true;
484     }
485 
486     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
487         _transfer(sender, recipient, amount);
488         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
489         return true;
490     }
491 
492     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
493         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
494         return true;
495     }
496 
497     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
498         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
499         return true;
500     }
501 
502     function isExcluded(address account) public view returns (bool) {
503         return _isExcluded[account];
504     }
505 
506     function totalFees() public view returns (uint256) {
507         return _tFeeTotal;
508     }
509     
510     
511     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
512         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
513             10**2
514         );
515     }
516 
517     function reflect(uint256 tAmount) public {
518         address sender = _msgSender();
519         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
520         (uint256 rAmount,,,,) = _getValues(tAmount);
521         _rOwned[sender] = _rOwned[sender].sub(rAmount);
522         _rTotal = _rTotal.sub(rAmount);
523         _tFeeTotal = _tFeeTotal.add(tAmount);
524     }
525 
526     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
527         require(tAmount <= _tTotal, "Amount must be less than supply");
528         if (!deductTransferFee) {
529             (uint256 rAmount,,,,) = _getValues(tAmount);
530             return rAmount;
531         } else {
532             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
533             return rTransferAmount;
534         }
535     }
536 
537     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
538         require(rAmount <= _rTotal, "Amount must be less than total reflections");
539         uint256 currentRate =  _getRate();
540         return rAmount.div(currentRate);
541     }
542 
543     function excludeAccount(address account) external onlyOwner() {
544         require(!_isExcluded[account], "Account is already excluded");
545         if(_rOwned[account] > 0) {
546             _tOwned[account] = tokenFromReflection(_rOwned[account]);
547         }
548         _isExcluded[account] = true;
549         _excluded.push(account);
550     }
551 
552     function includeAccount(address account) external onlyOwner() {
553         require(_isExcluded[account], "Account is already excluded");
554         for (uint256 i = 0; i < _excluded.length; i++) {
555             if (_excluded[i] == account) {
556                 _excluded[i] = _excluded[_excluded.length - 1];
557                 _tOwned[account] = 0;
558                 _isExcluded[account] = false;
559                 _excluded.pop();
560                 break;
561             }
562         }
563     }
564 
565     function _approve(address owner, address spender, uint256 amount) private {
566         require(owner != address(0), "ERC20: approve from the zero address");
567         require(spender != address(0), "ERC20: approve to the zero address");
568 
569         _allowances[owner][spender] = amount;
570         emit Approval(owner, spender, amount);
571     }
572 
573     function _transfer(address sender, address recipient, uint256 amount) private {
574         require(sender != address(0), "ERC20: transfer from the zero address");
575         require(recipient != address(0), "ERC20: transfer to the zero address");
576         require(amount > 0, "Transfer amount must be greater than zero");
577         if(sender != owner() && recipient != owner())
578           require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
579             
580         if (_isExcluded[sender] && !_isExcluded[recipient]) {
581             _transferFromExcluded(sender, recipient, amount);
582         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
583             _transferToExcluded(sender, recipient, amount);
584         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
585             _transferStandard(sender, recipient, amount);
586         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
587             _transferBothExcluded(sender, recipient, amount);
588         } else {
589             _transferStandard(sender, recipient, amount);
590         }
591     }
592 
593     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
594         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
595         _rOwned[sender] = _rOwned[sender].sub(rAmount);
596         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
597         _reflectFee(rFee, tFee);
598         emit Transfer(sender, recipient, tTransferAmount);
599     }
600 
601     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
602         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
603         _rOwned[sender] = _rOwned[sender].sub(rAmount);
604         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
605         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
606         _reflectFee(rFee, tFee);
607         emit Transfer(sender, recipient, tTransferAmount);
608     }
609 
610     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
611         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
612         _tOwned[sender] = _tOwned[sender].sub(tAmount);
613         _rOwned[sender] = _rOwned[sender].sub(rAmount);
614         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
615         _reflectFee(rFee, tFee);
616         emit Transfer(sender, recipient, tTransferAmount);
617     }
618 
619     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
620         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
621         _tOwned[sender] = _tOwned[sender].sub(tAmount);
622         _rOwned[sender] = _rOwned[sender].sub(rAmount);
623         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
624         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
625         _reflectFee(rFee, tFee);
626         emit Transfer(sender, recipient, tTransferAmount);
627     }
628 
629     function _reflectFee(uint256 rFee, uint256 tFee) private {
630         _rTotal = _rTotal.sub(rFee);
631         _tFeeTotal = _tFeeTotal.add(tFee);
632     }
633 
634     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
635         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
636         uint256 currentRate =  _getRate();
637         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
638         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
639     }
640 
641     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
642         uint256 tFee = tAmount.div(200).mul(2);
643         uint256 tTransferAmount = tAmount.sub(tFee);
644         return (tTransferAmount, tFee);
645     }
646 
647     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
648         uint256 rAmount = tAmount.mul(currentRate);
649         uint256 rFee = tFee.mul(currentRate);
650         uint256 rTransferAmount = rAmount.sub(rFee);
651         return (rAmount, rTransferAmount, rFee);
652     }
653 
654     function _getRate() private view returns(uint256) {
655         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
656         return rSupply.div(tSupply);
657     }
658 
659     function _getCurrentSupply() private view returns(uint256, uint256) {
660         uint256 rSupply = _rTotal;
661         uint256 tSupply = _tTotal;      
662         for (uint256 i = 0; i < _excluded.length; i++) {
663             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
664             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
665             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
666         }
667         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
668         return (rSupply, tSupply);
669     }
670 }