1 // SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.6.12;
3 
4 abstract contract Context {
5     function _msgSender() internal view virtual returns (address payable) {
6         return msg.sender;
7     }
8 
9     function _msgData() internal view virtual returns (bytes memory) {
10         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
11         return msg.data;
12     }
13 }
14 
15 interface IERC20 {
16     /**
17      * @dev Returns the amount of tokens in existence.
18      */
19     function totalSupply() external view returns (uint256);
20 
21     /**
22      * @dev Returns the amount of tokens owned by `account`.
23      */
24     function balanceOf(address account) external view returns (uint256);
25 
26     /**
27      * @dev Moves `amount` tokens from the caller's account to `recipient`.
28      *
29      * Returns a boolean value indicating whether the operation succeeded.
30      *
31      * Emits a {Transfer} event.
32      */
33     function transfer(address recipient, uint256 amount) external returns (bool);
34 
35     /**
36      * @dev Returns the remaining number of tokens that `spender` will be
37      * allowed to spend on behalf of `owner` through {transferFrom}. This is
38      * zero by default.
39      *
40      * This value changes when {approve} or {transferFrom} are called.
41      */
42     function allowance(address owner, address spender) external view returns (uint256);
43 
44     /**
45      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * IMPORTANT: Beware that changing an allowance with this method brings the risk
50      * that someone may use both the old and the new allowance by unfortunate
51      * transaction ordering. One possible solution to mitigate this race
52      * condition is to first reduce the spender's allowance to 0 and set the
53      * desired value afterwards:
54      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
55      *
56      * Emits an {Approval} event.
57      */
58     function approve(address spender, uint256 amount) external returns (bool);
59 
60     /**
61      * @dev Moves `amount` tokens from `sender` to `recipient` using the
62      * allowance mechanism. `amount` is then deducted from the caller's
63      * allowance.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * Emits a {Transfer} event.
68      */
69     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 
86 library SafeMath {
87     /**
88      * @dev Returns the addition of two unsigned integers, reverting on
89      * overflow.
90      *
91      * Counterpart to Solidity's `+` operator.
92      *
93      * Requirements:
94      *
95      * - Addition cannot overflow.
96      */
97     function add(uint256 a, uint256 b) internal pure returns (uint256) {
98         uint256 c = a + b;
99         require(c >= a, "SafeMath: addition overflow");
100 
101         return c;
102     }
103 
104     /**
105      * @dev Returns the subtraction of two unsigned integers, reverting on
106      * overflow (when the result is negative).
107      *
108      * Counterpart to Solidity's `-` operator.
109      *
110      * Requirements:
111      *
112      * - Subtraction cannot overflow.
113      */
114     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
115         return sub(a, b, "SafeMath: subtraction overflow");
116     }
117 
118     /**
119      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
120      * overflow (when the result is negative).
121      *
122      * Counterpart to Solidity's `-` operator.
123      *
124      * Requirements:
125      *
126      * - Subtraction cannot overflow.
127      */
128     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
129         require(b <= a, errorMessage);
130         uint256 c = a - b;
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the multiplication of two unsigned integers, reverting on
137      * overflow.
138      *
139      * Counterpart to Solidity's `*` operator.
140      *
141      * Requirements:
142      *
143      * - Multiplication cannot overflow.
144      */
145     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
146         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
147         // benefit is lost if 'b' is also tested.
148         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
149         if (a == 0) {
150             return 0;
151         }
152 
153         uint256 c = a * b;
154         require(c / a == b, "SafeMath: multiplication overflow");
155 
156         return c;
157     }
158 
159     /**
160      * @dev Returns the integer division of two unsigned integers. Reverts on
161      * division by zero. The result is rounded towards zero.
162      *
163      * Counterpart to Solidity's `/` operator. Note: this function uses a
164      * `revert` opcode (which leaves remaining gas untouched) while Solidity
165      * uses an invalid opcode to revert (consuming all remaining gas).
166      *
167      * Requirements:
168      *
169      * - The divisor cannot be zero.
170      */
171     function div(uint256 a, uint256 b) internal pure returns (uint256) {
172         return div(a, b, "SafeMath: division by zero");
173     }
174 
175     /**
176      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
177      * division by zero. The result is rounded towards zero.
178      *
179      * Counterpart to Solidity's `/` operator. Note: this function uses a
180      * `revert` opcode (which leaves remaining gas untouched) while Solidity
181      * uses an invalid opcode to revert (consuming all remaining gas).
182      *
183      * Requirements:
184      *
185      * - The divisor cannot be zero.
186      */
187     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
188         require(b > 0, errorMessage);
189         uint256 c = a / b;
190         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
191 
192         return c;
193     }
194 
195     /**
196      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
197      * Reverts when dividing by zero.
198      *
199      * Counterpart to Solidity's `%` operator. This function uses a `revert`
200      * opcode (which leaves remaining gas untouched) while Solidity uses an
201      * invalid opcode to revert (consuming all remaining gas).
202      *
203      * Requirements:
204      *
205      * - The divisor cannot be zero.
206      */
207     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
208         return mod(a, b, "SafeMath: modulo by zero");
209     }
210 
211     /**
212      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
213      * Reverts with custom message when dividing by zero.
214      *
215      * Counterpart to Solidity's `%` operator. This function uses a `revert`
216      * opcode (which leaves remaining gas untouched) while Solidity uses an
217      * invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      *
221      * - The divisor cannot be zero.
222      */
223     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
224         require(b != 0, errorMessage);
225         return a % b;
226     }
227 }
228 
229 library Address {
230     /**
231      * @dev Returns true if `account` is a contract.
232      *
233      * [IMPORTANT]
234      * ====
235      * It is unsafe to assume that an address for which this function returns
236      * false is an externally-owned account (EOA) and not a contract.
237      *
238      * Among others, `isContract` will return false for the following
239      * types of addresses:
240      *
241      *  - an externally-owned account
242      *  - a contract in construction
243      *  - an address where a contract will be created
244      *  - an address where a contract lived, but was destroyed
245      * ====
246      */
247     function isContract(address account) internal view returns (bool) {
248         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
249         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
250         // for accounts without code, i.e. `keccak256('')`
251         bytes32 codehash;
252         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
253         // solhint-disable-next-line no-inline-assembly
254         assembly { codehash := extcodehash(account) }
255         return (codehash != accountHash && codehash != 0x0);
256     }
257 
258     /**
259      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
260      * `recipient`, forwarding all available gas and reverting on errors.
261      *
262      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
263      * of certain opcodes, possibly making contracts go over the 2300 gas limit
264      * imposed by `transfer`, making them unable to receive funds via
265      * `transfer`. {sendValue} removes this limitation.
266      *
267      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
268      *
269      * IMPORTANT: because control is transferred to `recipient`, care must be
270      * taken to not create reentrancy vulnerabilities. Consider using
271      * {ReentrancyGuard} or the
272      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
273      */
274     function sendValue(address payable recipient, uint256 amount) internal {
275         require(address(this).balance >= amount, "Address: insufficient balance");
276 
277         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
278         (bool success, ) = recipient.call{ value: amount }("");
279         require(success, "Address: unable to send value, recipient may have reverted");
280     }
281 
282     /**
283      * @dev Performs a Solidity function call using a low level `call`. A
284      * plain`call` is an unsafe replacement for a function call: use this
285      * function instead.
286      *
287      * If `target` reverts with a revert reason, it is bubbled up by this
288      * function (like regular Solidity function calls).
289      *
290      * Returns the raw returned data. To convert to the expected return value,
291      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
292      *
293      * Requirements:
294      *
295      * - `target` must be a contract.
296      * - calling `target` with `data` must not revert.
297      *
298      * _Available since v3.1._
299      */
300     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
301       return functionCall(target, data, "Address: low-level call failed");
302     }
303 
304     /**
305      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
306      * `errorMessage` as a fallback revert reason when `target` reverts.
307      *
308      * _Available since v3.1._
309      */
310     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
311         return _functionCallWithValue(target, data, 0, errorMessage);
312     }
313 
314     /**
315      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
316      * but also transferring `value` wei to `target`.
317      *
318      * Requirements:
319      *
320      * - the calling contract must have an ETH balance of at least `value`.
321      * - the called Solidity function must be `payable`.
322      *
323      * _Available since v3.1._
324      */
325     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
326         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
331      * with `errorMessage` as a fallback revert reason when `target` reverts.
332      *
333      * _Available since v3.1._
334      */
335     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
336         require(address(this).balance >= value, "Address: insufficient balance for call");
337         return _functionCallWithValue(target, data, value, errorMessage);
338     }
339 
340     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
341         require(isContract(target), "Address: call to non-contract");
342 
343         // solhint-disable-next-line avoid-low-level-calls
344         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
345         if (success) {
346             return returndata;
347         } else {
348             // Look for revert reason and bubble it up if present
349             if (returndata.length > 0) {
350                 // The easiest way to bubble the revert reason is using memory via assembly
351 
352                 // solhint-disable-next-line no-inline-assembly
353                 assembly {
354                     let returndata_size := mload(returndata)
355                     revert(add(32, returndata), returndata_size)
356                 }
357             } else {
358                 revert(errorMessage);
359             }
360         }
361     }
362 }
363 
364 contract Ownable is Context {
365     address private _owner;
366 
367     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
368 
369     /**
370      * @dev Initializes the contract setting the deployer as the initial owner.
371      */
372     constructor () internal {
373         address msgSender = _msgSender();
374         _owner = msgSender;
375         emit OwnershipTransferred(address(0), msgSender);
376     }
377 
378     /**
379      * @dev Returns the address of the current owner.
380      */
381     function owner() public view returns (address) {
382         return _owner;
383     }
384 
385     /**
386      * @dev Throws if called by any account other than the owner.
387      */
388     modifier onlyOwner() {
389         require(_owner == _msgSender(), "Ownable: caller is not the owner");
390         _;
391     }
392 
393     /**
394      * @dev Leaves the contract without owner. It will not be possible to call
395      * `onlyOwner` functions anymore. Can only be called by the current owner.
396      *
397      * NOTE: Renouncing ownership will leave the contract without an owner,
398      * thereby removing any functionality that is only available to the owner.
399      */
400     function renounceOwnership() public virtual onlyOwner {
401         emit OwnershipTransferred(_owner, address(0));
402         _owner = address(0);
403     }
404 
405     /**
406      * @dev Transfers ownership of the contract to a new account (`newOwner`).
407      * Can only be called by the current owner.
408      */
409     function transferOwnership(address newOwner) public virtual onlyOwner {
410         require(newOwner != address(0), "Ownable: new owner can't be the zero address");
411         emit OwnershipTransferred(_owner, newOwner);
412         _owner = newOwner;
413     }
414 }
415 
416 contract MalamuteFinance is Context, IERC20, Ownable {
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
432     string private _name = 'Malamute.Finance';
433     string private _symbol = 'MALLY';
434     uint8 private _decimals = 9;
435 
436     constructor () public {
437         _rOwned[_msgSender()] = _rTotal;
438         emit Transfer(address(0), _msgSender(), _tTotal);
439     }
440 
441     function name() public view returns (string memory) {
442         return _name;
443     }
444 
445     function symbol() public view returns (string memory) {
446         return _symbol;
447     }
448 
449     function decimals() public view returns (uint8) {
450         return _decimals;
451     }
452 
453     function totalSupply() public view override returns (uint256) {
454         return _tTotal;
455     }
456 
457     function balanceOf(address account) public view override returns (uint256) {
458         if (_isExcluded[account]) return _tOwned[account];
459         return tokenFromReflection(_rOwned[account]);
460     }
461 
462     function transfer(address recipient, uint256 amount) public override returns (bool) {
463         _transfer(_msgSender(), recipient, amount);
464         return true;
465     }
466 
467     function allowance(address owner, address spender) public view override returns (uint256) {
468         return _allowances[owner][spender];
469     }
470 
471     function approve(address spender, uint256 amount) public override returns (bool) {
472         _approve(_msgSender(), spender, amount);
473         return true;
474     }
475 
476     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
477         _transfer(sender, recipient, amount);
478         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
479         return true;
480     }
481 
482     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
483         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
484         return true;
485     }
486 
487     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
488         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
489         return true;
490     }
491 
492     function isExcluded(address account) public view returns (bool) {
493         return _isExcluded[account];
494     }
495 
496     function totalFees() public view returns (uint256) {
497         return _tFeeTotal;
498     }
499 
500     function reflect(uint256 tAmount) public {
501         address sender = _msgSender();
502         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
503         (uint256 rAmount,,,,) = _getValues(tAmount);
504         _rOwned[sender] = _rOwned[sender].sub(rAmount);
505         _rTotal = _rTotal.sub(rAmount);
506         _tFeeTotal = _tFeeTotal.add(tAmount);
507     }
508 
509     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
510         require(tAmount <= _tTotal, "Amount must be less than supply");
511         if (!deductTransferFee) {
512             (uint256 rAmount,,,,) = _getValues(tAmount);
513             return rAmount;
514         } else {
515             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
516             return rTransferAmount;
517         }
518     }
519 
520     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
521         require(rAmount <= _rTotal, "Amount must be less than total reflections");
522         uint256 currentRate =  _getRate();
523         return rAmount.div(currentRate);
524     }
525 
526     function excludeAccount(address account) external onlyOwner() {
527         require(!_isExcluded[account], "Account is already excluded");
528         if(_rOwned[account] > 0) {
529             _tOwned[account] = tokenFromReflection(_rOwned[account]);
530         }
531         _isExcluded[account] = true;
532         _excluded.push(account);
533     }
534 
535     function includeAccount(address account) external onlyOwner() {
536         require(_isExcluded[account], "Account is not excluded");
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
548     function _approve(address owner, address spender, uint256 amount) private {
549         require(owner != address(0), "ERC20: approve from the zero address");
550         require(spender != address(0), "ERC20: approve to the zero address");
551 
552         _allowances[owner][spender] = amount;
553         emit Approval(owner, spender, amount);
554     }
555 
556     function _transfer(address sender, address recipient, uint256 amount) private {
557         require(sender != address(0), "ERC20: transfer from the zero address");
558         require(recipient != address(0), "ERC20: transfer to the zero address");
559         require(amount > 0, "Transfer amount must be greater than zero");
560         if (_isExcluded[sender] && !_isExcluded[recipient]) {
561             _transferFromExcluded(sender, recipient, amount);
562         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
563             _transferToExcluded(sender, recipient, amount);
564         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
565             _transferStandard(sender, recipient, amount);
566         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
567             _transferBothExcluded(sender, recipient, amount);
568         } else {
569             _transferStandard(sender, recipient, amount);
570         }
571     }
572 
573     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
574         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
575         _rOwned[sender] = _rOwned[sender].sub(rAmount);
576         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
577         _reflectFee(rFee, tFee);
578         emit Transfer(sender, recipient, tTransferAmount);
579     }
580 
581     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
582         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
583         _rOwned[sender] = _rOwned[sender].sub(rAmount);
584         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
585         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
586         _reflectFee(rFee, tFee);
587         emit Transfer(sender, recipient, tTransferAmount);
588     }
589 
590     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
591         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
592         _tOwned[sender] = _tOwned[sender].sub(tAmount);
593         _rOwned[sender] = _rOwned[sender].sub(rAmount);
594         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
595         _reflectFee(rFee, tFee);
596         emit Transfer(sender, recipient, tTransferAmount);
597     }
598 
599     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
600         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
601         _tOwned[sender] = _tOwned[sender].sub(tAmount);
602         _rOwned[sender] = _rOwned[sender].sub(rAmount);
603         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
604         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
605         _reflectFee(rFee, tFee);
606         emit Transfer(sender, recipient, tTransferAmount);
607     }
608 
609     function _reflectFee(uint256 rFee, uint256 tFee) private {
610         _rTotal = _rTotal.sub(rFee);
611         _tFeeTotal = _tFeeTotal.add(tFee);
612     }
613 
614     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
615         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
616         uint256 currentRate =  _getRate();
617         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
618         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
619     }
620 
621     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
622         uint256 tFee = tAmount.div(100).mul(2);
623         uint256 tTransferAmount = tAmount.sub(tFee);
624         return (tTransferAmount, tFee);
625     }
626 
627     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
628         uint256 rAmount = tAmount.mul(currentRate);
629         uint256 rFee = tFee.mul(currentRate);
630         uint256 rTransferAmount = rAmount.sub(rFee);
631         return (rAmount, rTransferAmount, rFee);
632     }
633 
634     function _getRate() private view returns(uint256) {
635         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
636         return rSupply.div(tSupply);
637     }
638 
639     function _getCurrentSupply() private view returns(uint256, uint256) {
640         uint256 rSupply = _rTotal;
641         uint256 tSupply = _tTotal;      
642         for (uint256 i = 0; i < _excluded.length; i++) {
643             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
644             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
645             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
646         }
647         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
648         return (rSupply, tSupply);
649     }
650 }