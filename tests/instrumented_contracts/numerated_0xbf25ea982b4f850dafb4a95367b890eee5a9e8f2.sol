1 // Cute Akita ! 
2 
3 //Bot protection : on
4 
5 //Liqudity Locked
6 
7 //Website: http://cuteakita.dog
8 
9 //TG: https://t.me/CuteAkita
10 
11 //        __
12 //     __/o \_
13 //     \____  \
14 //         /   \
15 //   __   //\   \
16 //__/o \-//--\   \_/
17 //\____  ___  \  |
18 //     ||   \ |\ |
19 //    _||   _||_||
20 //
21 
22 // ^ How cute is that? 
23 
24 // SPDX-License-Identifier: Unlicensed
25 
26 pragma solidity ^0.6.12;    
27 
28 abstract contract Context {
29     function _msgSender() internal view virtual returns (address payable) {
30         return msg.sender;
31     }
32 
33     function _msgData() internal view virtual returns (bytes memory) {
34         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
35         return msg.data;
36     }
37 }
38 
39 interface IERC20 {
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     /**
51      * @dev Moves `amount` tokens from the caller's account to `recipient`.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.s
54      *
55      * Emits a {Transfer} event.
56      */
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * IMPORTANT: Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Moves `amount` tokens from `sender` to `recipient` using the
86      * allowance mechanism. `amount` is then deducted from the caller's
87      * allowance.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 library SafeMath {
111     /**
112      * @dev Returns the addition of two unsigned integers, reverting on
113      * overflow.
114      *
115      * Counterpart to Solidity's `+` operator.
116      *
117      * Requirements:
118      *
119      * - Addition cannot overflow.
120      */
121     function add(uint256 a, uint256 b) internal pure returns (uint256) {
122         uint256 c = a + b;
123         require(c >= a, "SafeMath: addition overflow");
124 
125         return c;
126     }
127 
128     /**
129      * @dev Returns the subtraction of two unsigned integers, reverting on
130      * overflow (when the result is negative).
131      *
132      * Counterpart to Solidity's `-` operator.
133      *
134      * Requirements:
135      *
136      * - Subtraction cannot overflow.
137      */
138     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
139         return sub(a, b, "SafeMath: subtraction overflow");
140     }
141 
142     /**
143      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
144      * overflow (when the result is negative).
145      *
146      * Counterpart to Solidity's `-` operator.
147      *
148      * Requirements:
149      *
150      * - Subtraction cannot overflow.
151      */
152     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
153         require(b <= a, errorMessage);
154         uint256 c = a - b;
155 
156         return c;
157     }
158 
159     /**
160      * @dev Returns the multiplication of two unsigned integers, reverting on
161      * overflow.
162      *
163      * Counterpart to Solidity's `*` operator.
164      *
165      * Requirements:
166      *
167      * - Multiplication cannot overflow.
168      */
169     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
170         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
171         // benefit is lost if 'b' is also tested.
172         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
173         if (a == 0) {
174             return 0;
175         }
176 
177         uint256 c = a * b;
178         require(c / a == b, "SafeMath: multiplication overflow");
179 
180         return c;
181     }
182 
183     /**
184      * @dev Returns the integer division of two unsigned integers. Reverts on
185      * division by zero. The result is rounded towards zero.
186      *
187      * Counterpart to Solidity's `/` operator. Note: this function uses a
188      * `revert` opcode (which leaves remaining gas untouched) while Solidity
189      * uses an invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      *
193      * - The divisor cannot be zero.
194      */
195     function div(uint256 a, uint256 b) internal pure returns (uint256) {
196         return div(a, b, "SafeMath: division by zero");
197     }
198 
199     /**
200      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
201      * division by zero. The result is rounded towards zero.
202      *
203      * Counterpart to Solidity's `/` operator. Note: this function uses a
204      * `revert` opcode (which leaves remaining gas untouched) while Solidity
205      * uses an invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      *
209      * - The divisor cannot be zero.
210      */
211     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
212         require(b > 0, errorMessage);
213         uint256 c = a / b;
214         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
215 
216         return c;
217     }
218 
219     /**
220      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
221      * Reverts when dividing by zero.
222      *
223      * Counterpart to Solidity's `%` operator. This function uses a `revert`
224      * opcode (which leaves remaining gas untouched) while Solidity uses an
225      * invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
232         return mod(a, b, "SafeMath: modulo by zero");
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts with custom message when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      *
245      * - The divisor cannot be zero.
246      */
247     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
248         require(b != 0, errorMessage);
249         return a % b;
250     }
251 }
252 
253 library Address {
254     /**
255      * @dev Returns true if `account` is a contract.
256      *
257      * [IMPORTANT]
258      * ====
259      * It is unsafe to assume that an address for which this function returns
260      * false is an externally-owned account (EOA) and not a contract.
261      *
262      * Among others, `isContract` will return false for the following
263      * types of addresses:
264      *
265      *  - an externally-owned account
266      *  - a contract in construction
267      *  - an address where a contract will be created
268      *  - an address where a contract lived, but was destroyed
269      * ====
270      */
271     function isContract(address account) internal view returns (bool) {
272         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
273         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
274         // for accounts without code, i.e. `keccak256('')`
275         bytes32 codehash;
276         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
277         // solhint-disable-next-line no-inline-assembly
278         assembly { codehash := extcodehash(account) }
279         return (codehash != accountHash && codehash != 0x0);
280     }
281 
282     /**
283      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
284      * `recipient`, forwarding all available gas and reverting on errors.
285      *
286      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
287      * of certain opcodes, possibly making contracts go over the 2300 gas limit
288      * imposed by `transfer`, making them unable to receive funds via
289      * `transfer`. {sendValue} removes this limitation.
290      *
291      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
292      *
293      * IMPORTANT: because control is transferred to `recipient`, care must be
294      * taken to not create reentrancy vulnerabilities. Consider using
295      * {ReentrancyGuard} or the
296      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
297      */
298     function sendValue(address payable recipient, uint256 amount) internal {
299         require(address(this).balance >= amount, "Address: insufficient balance");
300 
301         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
302         (bool success, ) = recipient.call{ value: amount }("");
303         require(success, "Address: unable to send value, recipient may have reverted");
304     }
305 
306     /**
307      * @dev Performs a Solidity function call using a low level `call`. A
308      * plain`call` is an unsafe replacement for a function call: use this
309      * function instead.
310      *
311      * If `target` reverts with a revert reason, it is bubbled up by this
312      * function (like regular Solidity function calls).
313      *
314      * Returns the raw returned data. To convert to the expected return value,
315      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
316      *
317      * Requirements:
318      *
319      * - `target` must be a contract.
320      * - calling `target` with `data` must not revert.
321      *
322      * _Available since v3.1._
323      */
324     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
325       return functionCall(target, data, "Address: low-level call failed");
326     }
327 
328     /**
329      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
330      * `errorMessage` as a fallback revert reason when `target` reverts.
331      *
332      * _Available since v3.1._
333      */
334     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
335         return _functionCallWithValue(target, data, 0, errorMessage);
336     }
337 
338     /**
339      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
340      * but also transferring `value` wei to `target`.
341      *
342      * Requirements:
343      *
344      * - the calling contract must have an ETH balance of at least `value`.
345      * - the called Solidity function must be `payable`.
346      *
347      * _Available since v3.1._
348      */
349     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
350         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
351     }
352 
353     /**
354      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
355      * with `errorMessage` as a fallback revert reason when `target` reverts.
356      *
357      * _Available since v3.1._
358      */
359     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
360         require(address(this).balance >= value, "Address: insufficient balance for call");
361         return _functionCallWithValue(target, data, value, errorMessage);
362     }
363 
364     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
365         require(isContract(target), "Address: call to non-contract");
366 
367         // solhint-disable-next-line avoid-low-level-calls
368         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
369         if (success) {
370             return returndata;
371         } else {
372             // Look for revert reason and bubble it up if present
373             if (returndata.length > 0) {
374                 // The easiest way to bubble the revert reason is using memory via assembly
375 
376                 // solhint-disable-next-line no-inline-assembly
377                 assembly {
378                     let returndata_size := mload(returndata)
379                     revert(add(32, returndata), returndata_size)
380                 }
381             } else {
382                 revert(errorMessage);
383             }
384         }
385     }
386 }
387 
388 contract Ownable is Context {
389     address private _owner;
390 
391     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
392 
393     /**
394      * @dev Initializes the contract setting the deployer as the initial owner.
395      */
396     constructor () internal {
397         address msgSender = _msgSender();
398         _owner = msgSender;
399         emit OwnershipTransferred(address(0), msgSender);
400     }
401 
402     /**
403      * @dev Returns the address of the current owner.
404      */
405     function owner() public view returns (address) {
406         return _owner;
407     }
408 
409     /**
410      * @dev Throws if called by any account other than the owner.
411      */
412     modifier onlyOwner() {
413         require(_owner == _msgSender(), "Ownable: caller is not the owner");
414         _;
415     }
416 
417     /**
418      * @dev Leaves the contract without owner. It will not be possible to call
419      * `onlyOwner` functions anymore. Can only be called by the current owner.
420      *
421      * NOTE: Renouncing ownership will leave the contract without an owner,
422      * thereby removing any functionality that is only available to the owner.
423      */
424     function renounceOwnership() public virtual onlyOwner {
425         emit OwnershipTransferred(_owner, address(0));
426         _owner = address(0);
427     }
428 
429     /**
430      * @dev Transfers ownership of the contract to a new account (`newOwner`).
431      * Can only be called by the current owner.
432      */
433     function transferOwnership(address newOwner) public virtual onlyOwner {
434         require(newOwner != address(0), "Ownable: new owner is the zero address");
435         emit OwnershipTransferred(_owner, newOwner);
436         _owner = newOwner;
437     }
438 }
439 
440 
441 
442 contract CuteAkita is Context, IERC20, Ownable {
443     using SafeMath for uint256;
444     using Address for address;
445 
446     mapping (address => uint256) private _rOwned;
447     mapping (address => uint256) private _tOwned;
448     mapping (address => mapping (address => uint256)) private _allowances;
449 
450     mapping (address => bool) private _isExcluded;
451     address[] private _excluded;
452    
453     uint256 private constant MAX = ~uint256(0);
454     uint256 private constant _tTotal = 10000000 * 10**5 * 10**9;
455     uint256 private _rTotal = (MAX - (MAX % _tTotal));
456     uint256 private _tFeeTotal;
457 
458     string private _name = 'Cute Akita';
459     string private _symbol = 'Ckita';
460     uint8 private _decimals = 8;
461     
462     uint256 public _maxTxAmount = 10000000 * 10**5 * 10**9;
463 
464     constructor () public {
465         _rOwned[_msgSender()] = _rTotal;
466         emit Transfer(address(0), _msgSender(), _tTotal);
467     }
468 
469     function name() public view returns (string memory) {
470         return _name;
471     }
472 
473     function symbol() public view returns (string memory) {
474         return _symbol;
475     }
476 
477     function decimals() public view returns (uint8) {
478         return _decimals;
479     }
480 
481     function totalSupply() public view override returns (uint256) {
482         return _tTotal;
483     }
484 
485     function balanceOf(address account) public view override returns (uint256) {
486         if (_isExcluded[account]) return _tOwned[account];
487         return tokenFromReflection(_rOwned[account]);
488     }
489 
490     function transfer(address recipient, uint256 amount) public override returns (bool) {
491         _transfer(_msgSender(), recipient, amount);
492         return true;
493     }
494 
495     function allowance(address owner, address spender) public view override returns (uint256) {
496         return _allowances[owner][spender];
497     }
498 
499     function approve(address spender, uint256 amount) public override returns (bool) {
500         _approve(_msgSender(), spender, amount);
501         return true;
502     }
503 
504     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
505         _transfer(sender, recipient, amount);
506         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
507         return true;
508     }
509 
510     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
511         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
512         return true;
513     }
514 
515     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
516         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
517         return true;
518     }
519 
520     function isExcluded(address account) public view returns (bool) {
521         return _isExcluded[account];
522     }
523 
524     function totalFees() public view returns (uint256) {
525         return _tFeeTotal;
526     }
527     
528     
529     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
530         _maxTxAmount = _tTotal.mul(maxTxPercent).div(
531             10**2
532         );
533     }
534 
535     function reflect(uint256 tAmount) public {
536         address sender = _msgSender();
537         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
538         (uint256 rAmount,,,,) = _getValues(tAmount);
539         _rOwned[sender] = _rOwned[sender].sub(rAmount);
540         _rTotal = _rTotal.sub(rAmount);
541         _tFeeTotal = _tFeeTotal.add(tAmount);
542     }
543 
544     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
545         require(tAmount <= _tTotal, "Amount must be less than supply");
546         if (!deductTransferFee) {
547             (uint256 rAmount,,,,) = _getValues(tAmount);
548             return rAmount;
549         } else {
550             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
551             return rTransferAmount;
552         }
553     }
554 
555     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
556         require(rAmount <= _rTotal, "Amount must be less than total reflections");
557         uint256 currentRate =  _getRate();
558         return rAmount.div(currentRate);
559     }
560 
561     function excludeAccount(address account) external onlyOwner() {
562         require(!_isExcluded[account], "Account is already excluded");
563         if(_rOwned[account] > 0) {
564             _tOwned[account] = tokenFromReflection(_rOwned[account]);
565         }
566         _isExcluded[account] = true;
567         _excluded.push(account);
568     }
569 
570     function includeAccount(address account) external onlyOwner() {
571         require(_isExcluded[account], "Account is already excluded");
572         for (uint256 i = 0; i < _excluded.length; i++) {
573             if (_excluded[i] == account) {
574                 _excluded[i] = _excluded[_excluded.length - 1];
575                 _tOwned[account] = 0;
576                 _isExcluded[account] = false;
577                 _excluded.pop();
578                 break;
579             }
580         }
581     }
582 
583     function _approve(address owner, address spender, uint256 amount) private {
584         require(owner != address(0), "ERC20: approve from the zero address");
585         require(spender != address(0), "ERC20: approve to the zero address");
586 
587         _allowances[owner][spender] = amount;
588         emit Approval(owner, spender, amount);
589     }
590 
591     function _transfer(address sender, address recipient, uint256 amount) private {
592         require(sender != address(0), "ERC20: transfer from the zero address");
593         require(recipient != address(0), "ERC20: transfer to the zero address");
594         require(amount > 0, "Transfer amount must be greater than zero");
595         if(sender != owner() && recipient != owner())
596           require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
597             
598         if (_isExcluded[sender] && !_isExcluded[recipient]) {
599             _transferFromExcluded(sender, recipient, amount);
600         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
601             _transferToExcluded(sender, recipient, amount);
602         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
603             _transferStandard(sender, recipient, amount);
604         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
605             _transferBothExcluded(sender, recipient, amount);
606         } else {
607             _transferStandard(sender, recipient, amount);
608         }
609     }
610 
611     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
612         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
613         _rOwned[sender] = _rOwned[sender].sub(rAmount);
614         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
615         _reflectFee(rFee, tFee);
616         emit Transfer(sender, recipient, tTransferAmount);
617     }
618 
619     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
620         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
621         _rOwned[sender] = _rOwned[sender].sub(rAmount);
622         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
623         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
624         _reflectFee(rFee, tFee);
625         emit Transfer(sender, recipient, tTransferAmount);
626     }
627 
628     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
629         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
630         _tOwned[sender] = _tOwned[sender].sub(tAmount);
631         _rOwned[sender] = _rOwned[sender].sub(rAmount);
632         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
633         _reflectFee(rFee, tFee);
634         emit Transfer(sender, recipient, tTransferAmount);
635     }
636 
637     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
638         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
639         _tOwned[sender] = _tOwned[sender].sub(tAmount);
640         _rOwned[sender] = _rOwned[sender].sub(rAmount);
641         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
642         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
643         _reflectFee(rFee, tFee);
644         emit Transfer(sender, recipient, tTransferAmount);
645     }
646 
647     function _reflectFee(uint256 rFee, uint256 tFee) private {
648         _rTotal = _rTotal.sub(rFee);
649         _tFeeTotal = _tFeeTotal.add(tFee);
650     }
651 
652     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
653         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
654         uint256 currentRate =  _getRate();
655         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
656         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
657     }
658 
659     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
660         uint256 tFee = tAmount.div(100).mul(2);
661         uint256 tTransferAmount = tAmount.sub(tFee);
662         return (tTransferAmount, tFee);
663     }
664 
665     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
666         uint256 rAmount = tAmount.mul(currentRate);
667         uint256 rFee = tFee.mul(currentRate);
668         uint256 rTransferAmount = rAmount.sub(rFee);
669         return (rAmount, rTransferAmount, rFee);
670     }
671 
672     function _getRate() private view returns(uint256) {
673         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
674         return rSupply.div(tSupply);
675     }
676 
677     function _getCurrentSupply() private view returns(uint256, uint256) {
678         uint256 rSupply = _rTotal;
679         uint256 tSupply = _tTotal;      
680         for (uint256 i = 0; i < _excluded.length; i++) {
681             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
682             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
683             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
684         }
685         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
686         return (rSupply, tSupply);
687     }
688 }