1 /**
2  *Submitted for verification at Etherscan.io on 2021-02-07
3 */
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-02-07
7 */
8 
9 
10 // SPDX-License-Identifier: Unlicensed
11 
12 pragma solidity ^0.6.12;
13 
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address payable) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes memory) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
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
96 library SafeMath {
97     /**
98      * @dev Returns the addition of two unsigned integers, reverting on
99      * overflow.
100      *
101      * Counterpart to Solidity's `+` operator.
102      *
103      * Requirements:
104      *
105      * - Addition cannot overflow.
106      */
107     function add(uint256 a, uint256 b) internal pure returns (uint256) {
108         uint256 c = a + b;
109         require(c >= a, "SafeMath: addition overflow");
110 
111         return c;
112     }
113 
114     /**
115      * @dev Returns the subtraction of two unsigned integers, reverting on
116      * overflow (when the result is negative).
117      *
118      * Counterpart to Solidity's `-` operator.
119      *
120      * Requirements:
121      *
122      * - Subtraction cannot overflow.
123      */
124     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
125         return sub(a, b, "SafeMath: subtraction overflow");
126     }
127 
128     /**
129      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
130      * overflow (when the result is negative).
131      *
132      * Counterpart to Solidity's `-` operator.
133      *
134      * Requirements:
135      *
136      * - Subtraction cannot overflow.
137      */
138     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
139         require(b <= a, errorMessage);
140         uint256 c = a - b;
141 
142         return c;
143     }
144 
145     /**
146      * @dev Returns the multiplication of two unsigned integers, reverting on
147      * overflow.
148      *
149      * Counterpart to Solidity's `*` operator.
150      *
151      * Requirements:
152      *
153      * - Multiplication cannot overflow.
154      */
155     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
156         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
157         // benefit is lost if 'b' is also tested.
158         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
159         if (a == 0) {
160             return 0;
161         }
162 
163         uint256 c = a * b;
164         require(c / a == b, "SafeMath: multiplication overflow");
165 
166         return c;
167     }
168 
169     /**
170      * @dev Returns the integer division of two unsigned integers. Reverts on
171      * division by zero. The result is rounded towards zero.
172      *
173      * Counterpart to Solidity's `/` operator. Note: this function uses a
174      * `revert` opcode (which leaves remaining gas untouched) while Solidity
175      * uses an invalid opcode to revert (consuming all remaining gas).
176      *
177      * Requirements:
178      *
179      * - The divisor cannot be zero.
180      */
181     function div(uint256 a, uint256 b) internal pure returns (uint256) {
182         return div(a, b, "SafeMath: division by zero");
183     }
184 
185     /**
186      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
187      * division by zero. The result is rounded towards zero.
188      *
189      * Counterpart to Solidity's `/` operator. Note: this function uses a
190      * `revert` opcode (which leaves remaining gas untouched) while Solidity
191      * uses an invalid opcode to revert (consuming all remaining gas).
192      *
193      * Requirements:
194      *
195      * - The divisor cannot be zero.
196      */
197     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
198         require(b > 0, errorMessage);
199         uint256 c = a / b;
200         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
201 
202         return c;
203     }
204 
205     /**
206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
207      * Reverts when dividing by zero.
208      *
209      * Counterpart to Solidity's `%` operator. This function uses a `revert`
210      * opcode (which leaves remaining gas untouched) while Solidity uses an
211      * invalid opcode to revert (consuming all remaining gas).
212      *
213      * Requirements:
214      *
215      * - The divisor cannot be zero.
216      */
217     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
218         return mod(a, b, "SafeMath: modulo by zero");
219     }
220 
221     /**
222      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
223      * Reverts with custom message when dividing by zero.
224      *
225      * Counterpart to Solidity's `%` operator. This function uses a `revert`
226      * opcode (which leaves remaining gas untouched) while Solidity uses an
227      * invalid opcode to revert (consuming all remaining gas).
228      *
229      * Requirements:
230      *
231      * - The divisor cannot be zero.
232      */
233     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
234         require(b != 0, errorMessage);
235         return a % b;
236     }
237 }
238 
239 library Address {
240     /**
241      * @dev Returns true if `account` is a contract.
242      *
243      * [IMPORTANT]
244      * ====
245      * It is unsafe to assume that an address for which this function returns
246      * false is an externally-owned account (EOA) and not a contract.
247      *
248      * Among others, `isContract` will return false for the following
249      * types of addresses:
250      *
251      *  - an externally-owned account
252      *  - a contract in construction
253      *  - an address where a contract will be created
254      *  - an address where a contract lived, but was destroyed
255      * ====
256      */
257     function isContract(address account) internal view returns (bool) {
258         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
259         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
260         // for accounts without code, i.e. `keccak256('')`
261         bytes32 codehash;
262         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
263         // solhint-disable-next-line no-inline-assembly
264         assembly { codehash := extcodehash(account) }
265         return (codehash != accountHash && codehash != 0x0);
266     }
267 
268     /**
269      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
270      * `recipient`, forwarding all available gas and reverting on errors.
271      *
272      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
273      * of certain opcodes, possibly making contracts go over the 2300 gas limit
274      * imposed by `transfer`, making them unable to receive funds via
275      * `transfer`. {sendValue} removes this limitation.
276      *
277      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
278      *
279      * IMPORTANT: because control is transferred to `recipient`, care must be
280      * taken to not create reentrancy vulnerabilities. Consider using
281      * {ReentrancyGuard} or the
282      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
283      */
284     function sendValue(address payable recipient, uint256 amount) internal {
285         require(address(this).balance >= amount, "Address: insufficient balance");
286 
287         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
288         (bool success, ) = recipient.call{ value: amount }("");
289         require(success, "Address: unable to send value, recipient may have reverted");
290     }
291 
292     /**
293      * @dev Performs a Solidity function call using a low level `call`. A
294      * plain`call` is an unsafe replacement for a function call: use this
295      * function instead.
296      *
297      * If `target` reverts with a revert reason, it is bubbled up by this
298      * function (like regular Solidity function calls).
299      *
300      * Returns the raw returned data. To convert to the expected return value,
301      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
302      *
303      * Requirements:
304      *
305      * - `target` must be a contract.
306      * - calling `target` with `data` must not revert.
307      *
308      * _Available since v3.1._
309      */
310     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
311       return functionCall(target, data, "Address: low-level call failed");
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
316      * `errorMessage` as a fallback revert reason when `target` reverts.
317      *
318      * _Available since v3.1._
319      */
320     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
321         return _functionCallWithValue(target, data, 0, errorMessage);
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
326      * but also transferring `value` wei to `target`.
327      *
328      * Requirements:
329      *
330      * - the calling contract must have an ETH balance of at least `value`.
331      * - the called Solidity function must be `payable`.
332      *
333      * _Available since v3.1._
334      */
335     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
336         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
341      * with `errorMessage` as a fallback revert reason when `target` reverts.
342      *
343      * _Available since v3.1._
344      */
345     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
346         require(address(this).balance >= value, "Address: insufficient balance for call");
347         return _functionCallWithValue(target, data, value, errorMessage);
348     }
349 
350     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
351         require(isContract(target), "Address: call to non-contract");
352 
353         // solhint-disable-next-line avoid-low-level-calls
354         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
355         if (success) {
356             return returndata;
357         } else {
358             // Look for revert reason and bubble it up if present
359             if (returndata.length > 0) {
360                 // The easiest way to bubble the revert reason is using memory via assembly
361 
362                 // solhint-disable-next-line no-inline-assembly
363                 assembly {
364                     let returndata_size := mload(returndata)
365                     revert(add(32, returndata), returndata_size)
366                 }
367             } else {
368                 revert(errorMessage);
369             }
370         }
371     }
372 }
373 
374 contract Ownable is Context {
375     address private _owner;
376 
377     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
378 
379     /**
380      * @dev Initializes the contract setting the deployer as the initial owner.
381      */
382     constructor () internal {
383         address msgSender = _msgSender();
384         _owner = msgSender;
385         emit OwnershipTransferred(address(0), msgSender);
386     }
387 
388     /**
389      * @dev Returns the address of the current owner.
390      */
391     function owner() public view returns (address) {
392         return _owner;
393     }
394 
395     /**
396      * @dev Throws if called by any account other than the owner.
397      */
398     modifier onlyOwner() {
399         require(_owner == _msgSender(), "Ownable: caller is not the owner");
400         _;
401     }
402 
403     /**
404      * @dev Leaves the contract without owner. It will not be possible to call
405      * `onlyOwner` functions anymore. Can only be called by the current owner.
406      *
407      * NOTE: Renouncing ownership will leave the contract without an owner,
408      * thereby removing any functionality that is only available to the owner.
409      */
410     function renounceOwnership() public virtual onlyOwner {
411         emit OwnershipTransferred(_owner, address(0));
412         _owner = address(0);
413     }
414 
415     /**
416      * @dev Transfers ownership of the contract to a new account (`newOwner`).
417      * Can only be called by the current owner.
418      */
419     function transferOwnership(address newOwner) public virtual onlyOwner {
420         require(newOwner != address(0), "Ownable: new owner is the zero address");
421         emit OwnershipTransferred(_owner, newOwner);
422         _owner = newOwner;
423     }
424 }
425 
426 
427 
428 contract PiPiCoin is Context, IERC20, Ownable {
429     using SafeMath for uint256;
430     using Address for address;
431 
432     mapping (address => uint256) private _rOwned;
433     mapping (address => uint256) private _tOwned;
434     mapping (address => mapping (address => uint256)) private _allowances;
435 
436     mapping (address => bool) private _isExcluded;
437     address[] private _excluded;
438    
439     uint256 private constant MAX = ~uint256(0);
440     uint256 private constant _tTotal = 1000000 * 10**6 * 10**9;
441     uint256 private _rTotal = (MAX - (MAX % _tTotal));
442     uint256 private _tFeeTotal;
443 
444     string private _name = 'PiPiCoin';
445     string private _symbol = 'PIPI';
446     uint8 private _decimals = 9;
447 
448     constructor () public {
449         _rOwned[_msgSender()] = _rTotal;
450         emit Transfer(address(0), _msgSender(), _tTotal);
451     }
452 
453     function name() public view returns (string memory) {
454         return _name;
455     }
456 
457     function symbol() public view returns (string memory) {
458         return _symbol;
459     }
460 
461     function decimals() public view returns (uint8) {
462         return _decimals;
463     }
464 
465     function totalSupply() public view override returns (uint256) {
466         return _tTotal;
467     }
468 
469     function balanceOf(address account) public view override returns (uint256) {
470         if (_isExcluded[account]) return _tOwned[account];
471         return tokenFromReflection(_rOwned[account]);
472     }
473 
474     function transfer(address recipient, uint256 amount) public override returns (bool) {
475         _transfer(_msgSender(), recipient, amount);
476         return true;
477     }
478 
479     function allowance(address owner, address spender) public view override returns (uint256) {
480         return _allowances[owner][spender];
481     }
482 
483     function approve(address spender, uint256 amount) public override returns (bool) {
484         _approve(_msgSender(), spender, amount);
485         return true;
486     }
487 
488     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
489         _transfer(sender, recipient, amount);
490         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
491         return true;
492     }
493 
494     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
495         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
496         return true;
497     }
498 
499     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
500         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
501         return true;
502     }
503 
504     function isExcluded(address account) public view returns (bool) {
505         return _isExcluded[account];
506     }
507 
508     function totalFees() public view returns (uint256) {
509         return _tFeeTotal;
510     }
511 
512     function reflect(uint256 totalTransferAmount) public {
513         address sender = _msgSender();
514         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
515         (uint256 rAmount,,,,) = _getValues(totalTransferAmount);
516         _rOwned[sender] = _rOwned[sender].sub(rAmount);
517         _rTotal = _rTotal.sub(rAmount);
518         _tFeeTotal = _tFeeTotal.add(totalTransferAmount);
519     }
520 
521     function reflectionFromToken(uint256 totalTransferAmount, bool deductTransferFee) public view returns(uint256) {
522         require(totalTransferAmount <= _tTotal, "Amount must be less than supply");
523         if (!deductTransferFee) {
524             (uint256 rAmount,,,,) = _getValues(totalTransferAmount);
525             return rAmount;
526         } else {
527             (,uint256 rTransferAmount,,,) = _getValues(totalTransferAmount);
528             return rTransferAmount;
529         }
530     }
531 
532     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
533         require(rAmount <= _rTotal, "Amount must be less than total reflections");
534         uint256 currentRate =  _getRate();
535         return rAmount.div(currentRate);
536     }
537 
538     function excludeAccount(address account) external onlyOwner() {
539         require(!_isExcluded[account], "Account is already excluded");
540         if(_rOwned[account] > 0) {
541             _tOwned[account] = tokenFromReflection(_rOwned[account]);
542         }
543         _isExcluded[account] = true;
544         _excluded.push(account);
545     }
546 
547     function includeAccount(address account) external onlyOwner() {
548         require(_isExcluded[account], "Account is already included");
549         for (uint256 i = 0; i < _excluded.length; i++) {
550             if (_excluded[i] == account) {
551                 _excluded[i] = _excluded[_excluded.length - 1];
552                 _tOwned[account] = 0;
553                 _isExcluded[account] = false;
554                 _excluded.pop();
555                 break;
556             }
557         }
558     }
559 
560     function _approve(address owner, address spender, uint256 amount) private {
561         require(owner != address(0), "ERC20: approve from the zero address");
562         require(spender != address(0), "ERC20: approve to the zero address");
563 
564         _allowances[owner][spender] = amount;
565         emit Approval(owner, spender, amount);
566     }
567 
568     function _transfer(address sender, address recipient, uint256 amount) private {
569         require(sender != address(0), "ERC20: transfer from the zero address");
570         require(recipient != address(0), "ERC20: transfer to the zero address");
571         require(amount > 0, "Transfer amount must be greater than zero");
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
585     function _transferStandard(address sender, address recipient, uint256 totalTransferAmount) private {
586         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 transferAmount, uint256 tFee) = _getValues(totalTransferAmount);
587 
588         
589         _rOwned[sender] = _rOwned[sender].sub(rAmount);
590         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
591 
592         _reflectFee(rFee, tFee);
593         emit Transfer(sender, recipient, transferAmount);
594     }
595 
596     function _transferToExcluded(address sender, address recipient, uint256 totalTransferAmount) private {
597         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 transferAmount, uint256 tFee) = _getValues(totalTransferAmount);
598 
599         _rOwned[sender] = _rOwned[sender].sub(rAmount);
600         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
601 
602 
603         _tOwned[recipient] = _tOwned[recipient].add(transferAmount);
604 
605         _reflectFee(rFee, tFee);
606         emit Transfer(sender, recipient, transferAmount);
607     }
608 
609     function _transferFromExcluded(address sender, address recipient, uint256 totalTransferAmount) private {
610         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 transferAmount, uint256 tFee) = _getValues(totalTransferAmount);
611 
612         _rOwned[sender] = _rOwned[sender].sub(rAmount);
613         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
614 
615 
616         _tOwned[sender] = _tOwned[sender].sub(totalTransferAmount);
617 
618         _reflectFee(rFee, tFee);
619         emit Transfer(sender, recipient, transferAmount);
620     }
621 
622     function _transferBothExcluded(address sender, address recipient, uint256 totalTransferAmount) private {
623         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 transferAmount, uint256 tFee) = _getValues(totalTransferAmount);
624 
625         _rOwned[sender] = _rOwned[sender].sub(rAmount);
626         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
627 
628         _tOwned[sender] = _tOwned[sender].sub(totalTransferAmount);
629         _tOwned[recipient] = _tOwned[recipient].add(transferAmount);
630 
631         _reflectFee(rFee, tFee);
632         emit Transfer(sender, recipient, transferAmount);
633     }
634 
635     function _reflectFee(uint256 rFee, uint256 tFee) private {
636         _rTotal = _rTotal.sub(rFee);
637         _tFeeTotal = _tFeeTotal.add(tFee);
638     }
639 
640     function _getValues(uint256 totalTransferAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
641         (uint256 transferAmount, uint256 transferFee) = _getTransferValues(totalTransferAmount);
642         uint256 currentRate =  _getRate();
643         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(totalTransferAmount, transferFee, currentRate);
644         return (rAmount, rTransferAmount, rFee, transferAmount, transferFee);
645     }
646 
647     function _getTransferValues(uint256 totalTransferAmount) private pure returns (uint256, uint256) {
648         uint256 transferFee = totalTransferAmount.div(100).mul(3);
649         uint256 transferAmount = totalTransferAmount.sub(transferFee);
650         return (transferAmount, transferFee);
651     }
652 
653     function _getRValues(uint256 totalTransferAmount, uint256 transferFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
654         uint256 rAmount = totalTransferAmount.mul(currentRate);
655         uint256 rFee = transferFee.mul(currentRate);
656         uint256 rTransferAmount = rAmount.sub(rFee);
657         return (rAmount, rTransferAmount, rFee);
658     }
659 
660     function _getRate() private view returns(uint256) {
661         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
662         return rSupply.div(tSupply);
663     }
664 
665     function _getCurrentSupply() private view returns(uint256, uint256) {
666         uint256 rSupply = _rTotal;
667         uint256 tSupply = _tTotal;      
668         for (uint256 i = 0; i < _excluded.length; i++) {
669             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
670             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
671             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
672         }
673         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
674         return (rSupply, tSupply);
675     }
676 }