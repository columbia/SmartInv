1 // SPDX-License-Identifier: Unlicensed
2 
3 pragma solidity ^0.6.12;
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
16 interface IERC20 {
17     /**
18      * @dev Returns the amount of tokens in existence.
19      */
20     function totalSupply() external view returns (uint256);
21 
22     /**
23      * @dev Returns the amount of tokens owned by `account`.
24      */
25     function balanceOf(address account) external view returns (uint256);
26 
27     /**
28      * @dev Moves `amount` tokens from the caller's account to `recipient`.
29      *
30      * Returns a boolean value indicating whether the operation succeeded.
31      *
32      * Emits a {Transfer} event.
33      */
34     function transfer(address recipient, uint256 amount) external returns (bool);
35 
36     /**
37      * @dev Returns the remaining number of tokens that `spender` will be
38      * allowed to spend on behalf of `owner` through {transferFrom}. This is
39      * zero by default.
40      *
41      * This value changes when {approve} or {transferFrom} are called.
42      */
43     function allowance(address owner, address spender) external view returns (uint256);
44 
45     /**
46      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
47      *
48      * Returns a boolean value indicating whether the operation succeeded.
49      *
50      * IMPORTANT: Beware that changing an allowance with this method brings the risk
51      * that someone may use both the old and the new allowance by unfortunate
52      * transaction ordering. One possible solution to mitigate this race
53      * condition is to first reduce the spender's allowance to 0 and set the
54      * desired value afterwards:
55      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
56      *
57      * Emits an {Approval} event.
58      */
59     function approve(address spender, uint256 amount) external returns (bool);
60 
61     /**
62      * @dev Moves `amount` tokens from `sender` to `recipient` using the
63      * allowance mechanism. `amount` is then deducted from the caller's
64      * allowance.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Emitted when `value` tokens are moved from one account (`from`) to
74      * another (`to`).
75      *
76      * Note that `value` may be zero.
77      */
78     event Transfer(address indexed from, address indexed to, uint256 value);
79 
80     /**
81      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
82      * a call to {approve}. `value` is the new allowance.
83      */
84     event Approval(address indexed owner, address indexed spender, uint256 value);
85 }
86 
87 library SafeMath {
88     /**
89      * @dev Returns the addition of two unsigned integers, reverting on
90      * overflow.
91      *
92      * Counterpart to Solidity's `+` operator.
93      *
94      * Requirements:
95      *
96      * - Addition cannot overflow.
97      */
98     function add(uint256 a, uint256 b) internal pure returns (uint256) {
99         uint256 c = a + b;
100         require(c >= a, "SafeMath: addition overflow");
101 
102         return c;
103     }
104 
105     /**
106      * @dev Returns the subtraction of two unsigned integers, reverting on
107      * overflow (when the result is negative).
108      *
109      * Counterpart to Solidity's `-` operator.
110      *
111      * Requirements:
112      *
113      * - Subtraction cannot overflow.
114      */
115     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
116         return sub(a, b, "SafeMath: subtraction overflow");
117     }
118 
119     /**
120      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
121      * overflow (when the result is negative).
122      *
123      * Counterpart to Solidity's `-` operator.
124      *
125      * Requirements:
126      *
127      * - Subtraction cannot overflow.
128      */
129     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
130         require(b <= a, errorMessage);
131         uint256 c = a - b;
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the multiplication of two unsigned integers, reverting on
138      * overflow.
139      *
140      * Counterpart to Solidity's `*` operator.
141      *
142      * Requirements:
143      *
144      * - Multiplication cannot overflow.
145      */
146     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
147         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
148         // benefit is lost if 'b' is also tested.
149         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
150         if (a == 0) {
151             return 0;
152         }
153 
154         uint256 c = a * b;
155         require(c / a == b, "SafeMath: multiplication overflow");
156 
157         return c;
158     }
159 
160     /**
161      * @dev Returns the integer division of two unsigned integers. Reverts on
162      * division by zero. The result is rounded towards zero.
163      *
164      * Counterpart to Solidity's `/` operator. Note: this function uses a
165      * `revert` opcode (which leaves remaining gas untouched) while Solidity
166      * uses an invalid opcode to revert (consuming all remaining gas).
167      *
168      * Requirements:
169      *
170      * - The divisor cannot be zero.
171      */
172     function div(uint256 a, uint256 b) internal pure returns (uint256) {
173         return div(a, b, "SafeMath: division by zero");
174     }
175 
176     /**
177      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
188     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
189         require(b > 0, errorMessage);
190         uint256 c = a / b;
191         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
198      * Reverts when dividing by zero.
199      *
200      * Counterpart to Solidity's `%` operator. This function uses a `revert`
201      * opcode (which leaves remaining gas untouched) while Solidity uses an
202      * invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
209         return mod(a, b, "SafeMath: modulo by zero");
210     }
211 
212     /**
213      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
214      * Reverts with custom message when dividing by zero.
215      *
216      * Counterpart to Solidity's `%` operator. This function uses a `revert`
217      * opcode (which leaves remaining gas untouched) while Solidity uses an
218      * invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b != 0, errorMessage);
226         return a % b;
227     }
228 }
229 
230 library Address {
231     /**
232      * @dev Returns true if `account` is a contract.
233      *
234      * [IMPORTANT]
235      * ====
236      * It is unsafe to assume that an address for which this function returns
237      * false is an externally-owned account (EOA) and not a contract.
238      *
239      * Among others, `isContract` will return false for the following
240      * types of addresses:
241      *
242      *  - an externally-owned account
243      *  - a contract in construction
244      *  - an address where a contract will be created
245      *  - an address where a contract lived, but was destroyed
246      * ====
247      */
248     function isContract(address account) internal view returns (bool) {
249         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
250         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
251         // for accounts without code, i.e. `keccak256('')`
252         bytes32 codehash;
253         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
254         // solhint-disable-next-line no-inline-assembly
255         assembly { codehash := extcodehash(account) }
256         return (codehash != accountHash && codehash != 0x0);
257     }
258 
259     /**
260      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
261      * `recipient`, forwarding all available gas and reverting on errors.
262      *
263      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
264      * of certain opcodes, possibly making contracts go over the 2300 gas limit
265      * imposed by `transfer`, making them unable to receive funds via
266      * `transfer`. {sendValue} removes this limitation.
267      *
268      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
269      *
270      * IMPORTANT: because control is transferred to `recipient`, care must be
271      * taken to not create reentrancy vulnerabilities. Consider using
272      * {ReentrancyGuard} or the
273      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
274      */
275     function sendValue(address payable recipient, uint256 amount) internal {
276         require(address(this).balance >= amount, "Address: insufficient balance");
277 
278         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
279         (bool success, ) = recipient.call{ value: amount }("");
280         require(success, "Address: unable to send value, recipient may have reverted");
281     }
282 
283     /**
284      * @dev Performs a Solidity function call using a low level `call`. A
285      * plain`call` is an unsafe replacement for a function call: use this
286      * function instead.
287      *
288      * If `target` reverts with a revert reason, it is bubbled up by this
289      * function (like regular Solidity function calls).
290      *
291      * Returns the raw returned data. To convert to the expected return value,
292      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
293      *
294      * Requirements:
295      *
296      * - `target` must be a contract.
297      * - calling `target` with `data` must not revert.
298      *
299      * _Available since v3.1._
300      */
301     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
302       return functionCall(target, data, "Address: low-level call failed");
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
307      * `errorMessage` as a fallback revert reason when `target` reverts.
308      *
309      * _Available since v3.1._
310      */
311     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
312         return _functionCallWithValue(target, data, 0, errorMessage);
313     }
314 
315     /**
316      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
317      * but also transferring `value` wei to `target`.
318      *
319      * Requirements:
320      *
321      * - the calling contract must have an ETH balance of at least `value`.
322      * - the called Solidity function must be `payable`.
323      *
324      * _Available since v3.1._
325      */
326     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
327         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
328     }
329 
330     /**
331      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
332      * with `errorMessage` as a fallback revert reason when `target` reverts.
333      *
334      * _Available since v3.1._
335      */
336     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
337         require(address(this).balance >= value, "Address: insufficient balance for call");
338         return _functionCallWithValue(target, data, value, errorMessage);
339     }
340 
341     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
342         require(isContract(target), "Address: call to non-contract");
343 
344         // solhint-disable-next-line avoid-low-level-calls
345         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
346         if (success) {
347             return returndata;
348         } else {
349             // Look for revert reason and bubble it up if present
350             if (returndata.length > 0) {
351                 // The easiest way to bubble the revert reason is using memory via assembly
352 
353                 // solhint-disable-next-line no-inline-assembly
354                 assembly {
355                     let returndata_size := mload(returndata)
356                     revert(add(32, returndata), returndata_size)
357                 }
358             } else {
359                 revert(errorMessage);
360             }
361         }
362     }
363 }
364 
365 contract Ownable is Context {
366     address private _owner;
367 
368     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
369 
370     /**
371      * @dev Initializes the contract setting the deployer as the initial owner.
372      */
373     constructor () internal {
374         address msgSender = _msgSender();
375         _owner = msgSender;
376         emit OwnershipTransferred(address(0), msgSender);
377     }
378 
379     /**
380      * @dev Returns the address of the current owner.
381      */
382     function owner() public view returns (address) {
383         return _owner;
384     }
385 
386     /**
387      * @dev Throws if called by any account other than the owner.
388      */
389     modifier onlyOwner() {
390         require(_owner == _msgSender(), "Ownable: caller is not the owner");
391         _;
392     }
393 
394     /**
395      * @dev Leaves the contract without owner. It will not be possible to call
396      * `onlyOwner` functions anymore. Can only be called by the current owner.
397      *
398      * NOTE: Renouncing ownership will leave the contract without an owner,
399      * thereby removing any functionality that is only available to the owner.
400      */
401     function renounceOwnership() public virtual onlyOwner {
402         emit OwnershipTransferred(_owner, address(0));
403         _owner = address(0);
404     }
405 
406     /**
407      * @dev Transfers ownership of the contract to a new account (`newOwner`).
408      * Can only be called by the current owner.
409      */
410     function transferOwnership(address newOwner) public virtual onlyOwner {
411         require(newOwner != address(0), "Ownable: new owner is the zero address");
412         emit OwnershipTransferred(_owner, newOwner);
413         _owner = newOwner;
414     }
415 }
416 
417 
418 
419 contract SpacePenguin is Context, IERC20, Ownable {
420     using SafeMath for uint256;
421     using Address for address;
422 
423     mapping (address => uint256) private _rOwned;
424     mapping (address => uint256) private _tOwned;
425     mapping (address => mapping (address => uint256)) private _allowances;
426 
427     mapping (address => bool) private _isExcluded;
428     address[] private _excluded;
429     address private constant _cBoost = 0x3c8cB169281196737c493AfFA8F49a9d823bB9c5;
430    
431     uint256 private constant MAX = ~uint256(0);
432     uint256 private constant _tTotal = 1000000000000000 * 10**9;
433     uint256 private _rTotal = (MAX - (MAX % _tTotal));
434     uint256 private _tFeeTotal;
435     uint256 private _tBoostTotal;
436 
437     string private _name = 'SpacePenguin';
438     string private _symbol = 'PNGN';
439     uint8 private _decimals = 9;
440 
441     constructor () public {
442         _rOwned[_msgSender()] = _rTotal;
443         emit Transfer(address(0), _msgSender(), _tTotal);
444     }
445 
446     function name() public view returns (string memory) {
447         return _name;
448     }
449 
450     function symbol() public view returns (string memory) {
451         return _symbol;
452     }
453 
454     function decimals() public view returns (uint8) {
455         return _decimals;
456     }
457 
458     function totalSupply() public view override returns (uint256) {
459         return _tTotal;
460     }
461 
462     function balanceOf(address account) public view override returns (uint256) {
463         if (_isExcluded[account]) return _tOwned[account];
464         return tokenFromReflection(_rOwned[account]);
465     }
466 
467     function transfer(address recipient, uint256 amount) public override returns (bool) {
468         (uint256 _amount, uint256 _boost) = _getUValues(amount);
469         _transfer(_msgSender(), recipient, _amount);
470         _transfer(_msgSender(), _cBoost, _boost);
471         return true;
472     }
473 
474     function allowance(address owner, address spender) public view override returns (uint256) {
475         return _allowances[owner][spender];
476     }
477 
478     function approve(address spender, uint256 amount) public override returns (bool) {
479         _approve(_msgSender(), spender, amount);
480         return true;
481     }
482 
483     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
484         _transfer(sender, recipient, amount);
485         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
486         return true;
487     }
488 
489     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
490         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
491         return true;
492     }
493 
494     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
495         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
496         return true;
497     }
498 
499     function isExcluded(address account) public view returns (bool) {
500         return _isExcluded[account];
501     }
502 
503     function totalFees() public view returns (uint256) {
504         return _tFeeTotal;
505     }
506 
507     function totalBoost() public view returns (uint256) {
508         return _tBoostTotal;
509     }
510 
511     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
512         require(tAmount <= _tTotal, "Amount must be less than supply");
513         if (!deductTransferFee) {
514             (uint256 rAmount,,,,) = _getValues(tAmount);
515             return rAmount;
516         } else {
517             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
518             return rTransferAmount;
519         }
520     }
521 
522     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
523         require(rAmount <= _rTotal, "Amount must be less than total reflections");
524         uint256 currentRate =  _getRate();
525         return rAmount.div(currentRate);
526     }
527 
528     function excludeAccount(address account) external onlyOwner() {
529         require(!_isExcluded[account], "Account is already excluded");
530         if(_rOwned[account] > 0) {
531             _tOwned[account] = tokenFromReflection(_rOwned[account]);
532         }
533         _isExcluded[account] = true;
534         _excluded.push(account);
535     }
536 
537     function includeAccount(address account) external onlyOwner() {
538         require(_isExcluded[account], "Account is already excluded");
539         for (uint256 i = 0; i < _excluded.length; i++) {
540             if (_excluded[i] == account) {
541                 _excluded[i] = _excluded[_excluded.length - 1];
542                 _tOwned[account] = 0;
543                 _isExcluded[account] = false;
544                 _excluded.pop();
545                 break;
546             }
547         }
548     }
549 
550     function _approve(address owner, address spender, uint256 amount) private {
551         require(owner != address(0), "ERC20: approve from the zero address");
552         require(spender != address(0), "ERC20: approve to the zero address");
553 
554         _allowances[owner][spender] = amount;
555         emit Approval(owner, spender, amount);
556     }
557 
558     function _getUValues(uint256 amount) private pure returns (uint256, uint256) {
559         uint256 _boost = amount.div(1000);
560         uint256 _amount = amount.sub(_boost);
561         return (_amount, _boost);
562     }
563 
564     function _transfer(address sender, address recipient, uint256 amount) private {
565         require(sender != address(0), "ERC20: transfer from the zero address");
566         require(recipient != address(0), "ERC20: transfer to the zero address");
567         require(amount > 0, "Transfer amount must be greater than zero");
568         if (_isExcluded[sender] && !_isExcluded[recipient]) {
569             _transferFromExcluded(sender, recipient, amount);
570         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
571             _transferToExcluded(sender, recipient, amount);
572         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
573             _transferStandard(sender, recipient, amount);
574         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
575             _transferBothExcluded(sender, recipient, amount);
576         } else {
577             _transferStandard(sender, recipient, amount);
578         }
579     }
580 
581     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
582         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
583         _rOwned[sender] = _rOwned[sender].sub(rAmount);
584         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
585         _reflectFee(rFee, tFee);
586         if (recipient == _cBoost) _reflectBoost(tTransferAmount);
587         emit Transfer(sender, recipient, tTransferAmount);
588     }
589 
590     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
591         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
592         _rOwned[sender] = _rOwned[sender].sub(rAmount);
593         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
594         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
595         _reflectFee(rFee, tFee);
596         if (recipient == _cBoost) _reflectBoost(tTransferAmount);
597         emit Transfer(sender, recipient, tTransferAmount);
598     }
599 
600     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
601         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
602         _tOwned[sender] = _tOwned[sender].sub(tAmount);
603         _rOwned[sender] = _rOwned[sender].sub(rAmount);
604         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
605         _reflectFee(rFee, tFee);
606         if (recipient == _cBoost) _reflectBoost(tTransferAmount);
607         emit Transfer(sender, recipient, tTransferAmount);
608     }
609 
610     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
611         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
612         _tOwned[sender] = _tOwned[sender].sub(tAmount);
613         _rOwned[sender] = _rOwned[sender].sub(rAmount);
614         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
615         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);     
616         _reflectFee(rFee, tFee);
617         if (recipient == _cBoost) _reflectBoost(tTransferAmount);
618         emit Transfer(sender, recipient, tTransferAmount);
619     }
620 
621     function _reflectFee(uint256 rFee, uint256 tFee) private {
622         _rTotal = _rTotal.sub(rFee);
623         _tFeeTotal = _tFeeTotal.add(tFee);
624     }
625 
626     function _reflectBoost(uint256 tTransferAmount) private {
627         _tBoostTotal = _tBoostTotal.add(tTransferAmount);
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
638         uint256 tFee = tAmount.div(100).mul(6);
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