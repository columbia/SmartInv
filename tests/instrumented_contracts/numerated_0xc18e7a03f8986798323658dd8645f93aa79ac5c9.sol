1 /**
2 
3                                       
4                       
5     https://t.me/americanAkitauni
6 
7   http://americanakita.finance/
8 
9 */
10 
11 
12 // SPDX-License-Identifier: Unlicensed
13 
14 pragma solidity ^0.6.12;
15 
16 abstract contract Context {
17     function _msgSender() internal view virtual returns (address payable) {
18         return msg.sender;
19     }
20 
21     function _msgData() internal view virtual returns (bytes memory) {
22         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
23         return msg.data;
24     }
25 }
26 
27 interface IERC20 {
28     /**
29      * @dev Returns the amount of tokens in existence.
30      */
31     function totalSupply() external view returns (uint256);
32 
33     /**
34      * @dev Returns the amount of tokens owned by `account`.
35      */
36     function balanceOf(address account) external view returns (uint256);
37 
38     /**
39      * @dev Moves `amount` tokens from the caller's account to `recipient`.
40      *
41      * Returns a boolean value indicating whether the operation succeeded.
42      *
43      * Emits a {Transfer} event.
44      */
45     function transfer(address recipient, uint256 amount) external returns (bool);
46 
47     /**
48      * @dev Returns the remaining number of tokens that `spender` will be
49      * allowed to spend on behalf of `owner` through {transferFrom}. This is
50      * zero by default.
51      *
52      * This value changes when {approve} or {transferFrom} are called.
53      */
54     function allowance(address owner, address spender) external view returns (uint256);
55 
56     /**
57      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
58      *
59      * Returns a boolean value indicating whether the operation succeeded.
60      *
61      * IMPORTANT: Beware that changing an allowance with this method brings the risk
62      * that someone may use both the old and the new allowance by unfortunate
63      * transaction ordering. One possible solution to mitigate this race
64      * condition is to first reduce the spender's allowance to 0 and set the
65      * desired value afterwards:
66      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
67      *
68      * Emits an {Approval} event.
69      */
70     function approve(address spender, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Moves `amount` tokens from `sender` to `recipient` using the
74      * allowance mechanism. `amount` is then deducted from the caller's
75      * allowance.
76      *
77      * Returns a boolean value indicating whether the operation succeeded.
78      *
79      * Emits a {Transfer} event.
80      */
81     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Emitted when `value` tokens are moved from one account (`from`) to
85      * another (`to`).
86      *
87      * Note that `value` may be zero.
88      */
89     event Transfer(address indexed from, address indexed to, uint256 value);
90 
91     /**
92      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
93      * a call to {approve}. `value` is the new allowance.
94      */
95     event Approval(address indexed owner, address indexed spender, uint256 value);
96 }
97 
98 library SafeMath {
99     /**
100      * @dev Returns the addition of two unsigned integers, reverting on
101      * overflow.
102      *
103      * Counterpart to Solidity's `+` operator.
104      *
105      * Requirements:
106      *
107      * - Addition cannot overflow.
108      */
109     function add(uint256 a, uint256 b) internal pure returns (uint256) {
110         uint256 c = a + b;
111         require(c >= a, "SafeMath: addition overflow");
112 
113         return c;
114     }
115 
116     /**
117      * @dev Returns the subtraction of two unsigned integers, reverting on
118      * overflow (when the result is negative).
119      *
120      * Counterpart to Solidity's `-` operator.
121      *
122      * Requirements:
123      *
124      * - Subtraction cannot overflow.
125      */
126     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
127         return sub(a, b, "SafeMath: subtraction overflow");
128     }
129 
130     /**
131      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
132      * overflow (when the result is negative).
133      *
134      * Counterpart to Solidity's `-` operator.
135      *
136      * Requirements:
137      *
138      * - Subtraction cannot overflow.
139      */
140     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
141         require(b <= a, errorMessage);
142         uint256 c = a - b;
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the multiplication of two unsigned integers, reverting on
149      * overflow.
150      *
151      * Counterpart to Solidity's `*` operator.
152      *
153      * Requirements:
154      *
155      * - Multiplication cannot overflow.
156      */
157     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
158         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
159         // benefit is lost if 'b' is also tested.
160         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
161         if (a == 0) {
162             return 0;
163         }
164 
165         uint256 c = a * b;
166         require(c / a == b, "SafeMath: multiplication overflow");
167 
168         return c;
169     }
170 
171     /**
172      * @dev Returns the integer division of two unsigned integers. Reverts on
173      * division by zero. The result is rounded towards zero.
174      *
175      * Counterpart to Solidity's `/` operator. Note: this function uses a
176      * `revert` opcode (which leaves remaining gas untouched) while Solidity
177      * uses an invalid opcode to revert (consuming all remaining gas).
178      *
179      * Requirements:
180      *
181      * - The divisor cannot be zero.
182      */
183     function div(uint256 a, uint256 b) internal pure returns (uint256) {
184         return div(a, b, "SafeMath: division by zero");
185     }
186 
187     /**
188      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
189      * division by zero. The result is rounded towards zero.
190      *
191      * Counterpart to Solidity's `/` operator. Note: this function uses a
192      * `revert` opcode (which leaves remaining gas untouched) while Solidity
193      * uses an invalid opcode to revert (consuming all remaining gas).
194      *
195      * Requirements:
196      *
197      * - The divisor cannot be zero.
198      */
199     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
200         require(b > 0, errorMessage);
201         uint256 c = a / b;
202         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
203 
204         return c;
205     }
206 
207     /**
208      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
209      * Reverts when dividing by zero.
210      *
211      * Counterpart to Solidity's `%` operator. This function uses a `revert`
212      * opcode (which leaves remaining gas untouched) while Solidity uses an
213      * invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
220         return mod(a, b, "SafeMath: modulo by zero");
221     }
222 
223     /**
224      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
225      * Reverts with custom message when dividing by zero.
226      *
227      * Counterpart to Solidity's `%` operator. This function uses a `revert`
228      * opcode (which leaves remaining gas untouched) while Solidity uses an
229      * invalid opcode to revert (consuming all remaining gas).
230      *
231      * Requirements:
232      *
233      * - The divisor cannot be zero.
234      */
235     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
236         require(b != 0, errorMessage);
237         return a % b;
238     }
239 }
240 
241 library Address {
242     /**
243      * @dev Returns true if `account` is a contract.
244      *
245      * [IMPORTANT]
246      * ====
247      * It is unsafe to assume that an address for which this function returns
248      * false is an externally-owned account (EOA) and not a contract.
249      *
250      * Among others, `isContract` will return false for the following
251      * types of addresses:
252      *
253      *  - an externally-owned account
254      *  - a contract in construction
255      *  - an address where a contract will be created
256      *  - an address where a contract lived, but was destroyed
257      * ====
258      */
259     function isContract(address account) internal view returns (bool) {
260         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
261         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
262         // for accounts without code, i.e. `keccak256('')`
263         bytes32 codehash;
264         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
265         // solhint-disable-next-line no-inline-assembly
266         assembly { codehash := extcodehash(account) }
267         return (codehash != accountHash && codehash != 0x0);
268     }
269 
270     /**
271      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
272      * `recipient`, forwarding all available gas and reverting on errors.
273      *
274      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
275      * of certain opcodes, possibly making contracts go over the 2300 gas limit
276      * imposed by `transfer`, making them unable to receive funds via
277      * `transfer`. {sendValue} removes this limitation.
278      *
279      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
280      *
281      * IMPORTANT: because control is transferred to `recipient`, care must be
282      * taken to not create reentrancy vulnerabilities. Consider using
283      * {ReentrancyGuard} or the
284      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
285      */
286     function sendValue(address payable recipient, uint256 amount) internal {
287         require(address(this).balance >= amount, "Address: insufficient balance");
288 
289         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
290         (bool success, ) = recipient.call{ value: amount }("");
291         require(success, "Address: unable to send value, recipient may have reverted");
292     }
293 
294     /**
295      * @dev Performs a Solidity function call using a low level `call`. A
296      * plain`call` is an unsafe replacement for a function call: use this
297      * function instead.
298      *
299      * If `target` reverts with a revert reason, it is bubbled up by this
300      * function (like regular Solidity function calls).
301      *
302      * Returns the raw returned data. To convert to the expected return value,
303      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
304      *
305      * Requirements:
306      *
307      * - `target` must be a contract.
308      * - calling `target` with `data` must not revert.
309      *
310      * _Available since v3.1._
311      */
312     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
313       return functionCall(target, data, "Address: low-level call failed");
314     }
315 
316     /**
317      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
318      * `errorMessage` as a fallback revert reason when `target` reverts.
319      *
320      * _Available since v3.1._
321      */
322     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
323         return _functionCallWithValue(target, data, 0, errorMessage);
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
328      * but also transferring `value` wei to `target`.
329      *
330      * Requirements:
331      *
332      * - the calling contract must have an ETH balance of at least `value`.
333      * - the called Solidity function must be `payable`.
334      *
335      * _Available since v3.1._
336      */
337     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
338         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
339     }
340 
341     /**
342      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
343      * with `errorMessage` as a fallback revert reason when `target` reverts.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
348         require(address(this).balance >= value, "Address: insufficient balance for call");
349         return _functionCallWithValue(target, data, value, errorMessage);
350     }
351 
352     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
353         require(isContract(target), "Address: call to non-contract");
354 
355         // solhint-disable-next-line avoid-low-level-calls
356         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
357         if (success) {
358             return returndata;
359         } else {
360             // Look for revert reason and bubble it up if present
361             if (returndata.length > 0) {
362                 // The easiest way to bubble the revert reason is using memory via assembly
363 
364                 // solhint-disable-next-line no-inline-assembly
365                 assembly {
366                     let returndata_size := mload(returndata)
367                     revert(add(32, returndata), returndata_size)
368                 }
369             } else {
370                 revert(errorMessage);
371             }
372         }
373     }
374 }
375 
376 contract Ownable is Context {
377     address private _owner;
378 
379     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
380 
381     /**
382      * @dev Initializes the contract setting the deployer as the initial owner.
383      */
384     constructor () internal {
385         address msgSender = _msgSender();
386         _owner = msgSender;
387         emit OwnershipTransferred(address(0), msgSender);
388     }
389 
390     /**
391      * @dev Returns the address of the current owner.
392      */
393     function owner() public view returns (address) {
394         return _owner;
395     }
396 
397     /**
398      * @dev Throws if called by any account other than the owner.
399      */
400     modifier onlyOwner() {
401         require(_owner == _msgSender(), "Ownable: caller is not the owner");
402         _;
403     }
404 
405     /**
406      * @dev Leaves the contract without owner. It will not be possible to call
407      * `onlyOwner` functions anymore. Can only be called by the current owner.
408      *
409      * NOTE: Renouncing ownership will leave the contract without an owner,
410      * thereby removing any functionality that is only available to the owner.
411      */
412     function renounceOwnership() public virtual onlyOwner {
413         emit OwnershipTransferred(_owner, address(0));
414         _owner = address(0);
415     }
416 
417     /**
418      * @dev Transfers ownership of the contract to a new account (`newOwner`).
419      * Can only be called by the current owner.
420      */
421     function transferOwnership(address newOwner) public virtual onlyOwner {
422         require(newOwner != address(0), "Ownable: new owner is the zero address");
423         emit OwnershipTransferred(_owner, newOwner);
424         _owner = newOwner;
425     }
426 }
427 
428 
429 
430 contract AmericanAkita is Context, IERC20, Ownable {
431     using SafeMath for uint256;
432     using Address for address;
433 
434     mapping (address => uint256) private _rOwned;
435     mapping (address => uint256) private _tOwned;
436     mapping (address => mapping (address => uint256)) private _allowances;
437 
438     mapping (address => bool) private _isExcluded;
439     address[] private _excluded;
440    
441     uint256 private constant MAX = ~uint256(0);
442     uint256 private constant _tTotal = 100000000000 * 10**6 * 10**9;
443     uint256 private _rTotal = (MAX - (MAX % _tTotal));
444     uint256 private _tFeeTotal;
445 
446     string private _name = 'American Akita';
447     string private _symbol = 'USKITA';
448     uint8 private _decimals = 9;
449     
450     uint256 public _maxTxAmount = 100000000 * 10**6 * 10**9;
451 
452     constructor () public {
453         _rOwned[_msgSender()] = _rTotal;
454         emit Transfer(address(0), _msgSender(), _tTotal);
455     }
456 
457     function name() public view returns (string memory) {
458         return _name;
459     }
460 
461     function symbol() public view returns (string memory) {
462         return _symbol;
463     }
464 
465     function decimals() public view returns (uint8) {
466         return _decimals;
467     }
468 
469     function totalSupply() public view override returns (uint256) {
470         return _tTotal;
471     }
472 
473     function balanceOf(address account) public view override returns (uint256) {
474         if (_isExcluded[account]) return _tOwned[account];
475         return tokenFromReflection(_rOwned[account]);
476     }
477 
478     function transfer(address recipient, uint256 amount) public override returns (bool) {
479         _transfer(_msgSender(), recipient, amount);
480         return true;
481     }
482 
483     function allowance(address owner, address spender) public view override returns (uint256) {
484         return _allowances[owner][spender];
485     }
486 
487     function approve(address spender, uint256 amount) public override returns (bool) {
488         _approve(_msgSender(), spender, amount);
489         return true;
490     }
491 
492     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
493         _transfer(sender, recipient, amount);
494         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
495         return true;
496     }
497 
498     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
499         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
500         return true;
501     }
502 
503     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
504         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
505         return true;
506     }
507 
508     function isExcluded(address account) public view returns (bool) {
509         return _isExcluded[account];
510     }
511 
512     function totalFees() public view returns (uint256) {
513         return _tFeeTotal;
514     }
515     
516     
517     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
518         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
519             10**2
520         );
521     }
522     
523     function rescueFromContract() external onlyOwner {
524         address payable _owner = _msgSender();
525         _owner.transfer(address(this).balance);
526     }
527 
528     function reflect(uint256 tAmount) public {
529         address sender = _msgSender();
530         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
531         (uint256 rAmount,,,,) = _getValues(tAmount);
532         _rOwned[sender] = _rOwned[sender].sub(rAmount);
533         _rTotal = _rTotal.sub(rAmount);
534         _tFeeTotal = _tFeeTotal.add(tAmount);
535     }
536 
537     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
538         require(tAmount <= _tTotal, "Amount must be less than supply");
539         if (!deductTransferFee) {
540             (uint256 rAmount,,,,) = _getValues(tAmount);
541             return rAmount;
542         } else {
543             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
544             return rTransferAmount;
545         }
546     }
547 
548     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
549         require(rAmount <= _rTotal, "Amount must be less than total reflections");
550         uint256 currentRate =  _getRate();
551         return rAmount.div(currentRate);
552     }
553 
554     function excludeAccount(address account) external onlyOwner() {
555         require(!_isExcluded[account], "Account is already excluded");
556         if(_rOwned[account] > 0) {
557             _tOwned[account] = tokenFromReflection(_rOwned[account]);
558         }
559         _isExcluded[account] = true;
560         _excluded.push(account);
561     }
562 
563     function includeAccount(address account) external onlyOwner() {
564         require(_isExcluded[account], "Account is already excluded");
565         for (uint256 i = 0; i < _excluded.length; i++) {
566             if (_excluded[i] == account) {
567                 _excluded[i] = _excluded[_excluded.length - 1];
568                 _tOwned[account] = 0;
569                 _isExcluded[account] = false;
570                 _excluded.pop();
571                 break;
572             }
573         }
574     }
575 
576     function _approve(address owner, address spender, uint256 amount) private {
577         require(owner != address(0), "ERC20: approve from the zero address");
578         require(spender != address(0), "ERC20: approve to the zero address");
579 
580         _allowances[owner][spender] = amount;
581         emit Approval(owner, spender, amount);
582     }
583 
584     function _transfer(address sender, address recipient, uint256 amount) private {
585         require(sender != address(0), "ERC20: transfer from the zero address");
586         require(recipient != address(0), "ERC20: transfer to the zero address");
587         require(amount > 0, "Transfer amount must be greater than zero");
588         if(sender != owner() && recipient != owner())
589           require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
590             
591         if (_isExcluded[sender] && !_isExcluded[recipient]) {
592             _transferFromExcluded(sender, recipient, amount);
593         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
594             _transferToExcluded(sender, recipient, amount);
595         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
596             _transferStandard(sender, recipient, amount);
597         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
598             _transferBothExcluded(sender, recipient, amount);
599         } else {
600             _transferStandard(sender, recipient, amount);
601         }
602     }
603 
604     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
605         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
606         _rOwned[sender] = _rOwned[sender].sub(rAmount);
607         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
608         _reflectFee(rFee, tFee);
609         emit Transfer(sender, recipient, tTransferAmount);
610     }
611 
612     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
613         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
614         _rOwned[sender] = _rOwned[sender].sub(rAmount);
615         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
616         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
617         _reflectFee(rFee, tFee);
618         emit Transfer(sender, recipient, tTransferAmount);
619     }
620 
621     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
622         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
623         _tOwned[sender] = _tOwned[sender].sub(tAmount);
624         _rOwned[sender] = _rOwned[sender].sub(rAmount);
625         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
626         _reflectFee(rFee, tFee);
627         emit Transfer(sender, recipient, tTransferAmount);
628     }
629 
630     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
631         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
632         _tOwned[sender] = _tOwned[sender].sub(tAmount);
633         _rOwned[sender] = _rOwned[sender].sub(rAmount);
634         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
635         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
636         _reflectFee(rFee, tFee);
637         emit Transfer(sender, recipient, tTransferAmount);
638     }
639 
640     function _reflectFee(uint256 rFee, uint256 tFee) private {
641         _rTotal = _rTotal.sub(rFee);
642         _tFeeTotal = _tFeeTotal.add(tFee);
643     }
644 
645     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
646         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
647         uint256 currentRate =  _getRate();
648         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
649         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
650     }
651 
652     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
653         uint256 tFee = tAmount.div(100).mul(2);
654         uint256 tTransferAmount = tAmount.sub(tFee);
655         return (tTransferAmount, tFee);
656     }
657 
658     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
659         uint256 rAmount = tAmount.mul(currentRate);
660         uint256 rFee = tFee.mul(currentRate);
661         uint256 rTransferAmount = rAmount.sub(rFee);
662         return (rAmount, rTransferAmount, rFee);
663     }
664 
665     function _getRate() private view returns(uint256) {
666         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
667         return rSupply.div(tSupply);
668     }
669 
670     function _getCurrentSupply() private view returns(uint256, uint256) {
671         uint256 rSupply = _rTotal;
672         uint256 tSupply = _tTotal;      
673         for (uint256 i = 0; i < _excluded.length; i++) {
674             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
675             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
676             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
677         }
678         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
679         return (rSupply, tSupply);
680     }
681 }