1 /**
2 */
3 //	
4 //	 Join us on our journey to the moon and beyond!
5 //    _____                       _____ _     _ _           
6 //   / ____|                     / ____| |   (_) |          
7 //  | (___  _ __   __ _  ___ ___| (___ | |__  _| |__   __ _ 
8 //   \___ \| '_ \ / _` |/ __/ _ \\___ \| '_ \| | '_ \ / _` |
9 //   ____) | |_) | (_| | (_|  __/____) | | | | | |_) | (_| |
10 //  |_____/| .__/ \__,_|\___\___|_____/|_| |_|_|_.__/ \__,_|
11 //         | |                                              
12 //         |_|                                              
13 //
14 // website: http://www.spaceshiba.io/
15 // Telegram: https://t.me/SpaceShibToken
16 // Twitter: https://twitter.com/SpaceShibaToken
17 // Find the whitepaper on our website!
18 
19 
20 
21 // SPDX-License-Identifier: Unlicensed
22 pragma solidity ^0.8.0;
23 
24 abstract contract Context {
25     function _msgSender() internal view virtual returns (address) {
26         return msg.sender;
27     }
28 
29     function _msgData() internal view virtual returns (bytes memory) {
30         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
31         return msg.data;
32     }
33 }
34 
35 interface IERC20 {
36     /**
37      * @dev Returns the amount of tokens in existence.
38      */
39     function totalSupply() external view returns (uint256);
40 
41     /**
42      * @dev Returns the amount of tokens owned by `account`.
43      */
44     function balanceOf(address account) external view returns (uint256);
45 
46     /**
47      * @dev Moves `amount` tokens from the caller's account to `recipient`.
48      *
49      * Returns a boolean value indicating whether the operation succeeded.
50      *
51      * Emits a {Transfer} event.
52      */
53     function transfer(address recipient, uint256 amount) external returns (bool);
54 
55     /**
56      * @dev Returns the remaining number of tokens that `spender` will be
57      * allowed to spend on behalf of `owner` through {transferFrom}. This is
58      * zero by default.
59      *
60      * This value changes when {approve} or {transferFrom} are called.
61      */
62     function allowance(address owner, address spender) external view returns (uint256);
63 
64     /**
65      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
66      *
67      * Returns a boolean value indicating whether the operation succeeded.
68      *
69      * IMPORTANT: Beware that changing an allowance with this method brings the risk
70      * that someone may use both the old and the new allowance by unfortunate
71      * transaction ordering. One possible solution to mitigate this race
72      * condition is to first reduce the spender's allowance to 0 and set the
73      * desired value afterwards:
74      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
75      *
76      * Emits an {Approval} event.
77      */
78     function approve(address spender, uint256 amount) external returns (bool);
79 
80     /**
81      * @dev Moves `amount` tokens from `sender` to `recipient` using the
82      * allowance mechanism. `amount` is then deducted from the caller's
83      * allowance.
84      *
85      * Returns a boolean value indicating whether the operation succeeded.
86      *
87      * Emits a {Transfer} event.
88      */
89     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
90 
91     /**
92      * @dev Emitted when `value` tokens are moved from one account (`from`) to
93      * another (`to`).
94      *
95      * Note that `value` may be zero.
96      */
97     event Transfer(address indexed from, address indexed to, uint256 value);
98 
99     /**
100      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
101      * a call to {approve}. `value` is the new allowance.
102      */
103     event Approval(address indexed owner, address indexed spender, uint256 value);
104 }
105 
106 library SafeMath {
107     /**
108      * @dev Returns the addition of two unsigned integers, reverting on
109      * overflow.
110      *
111      * Counterpart to Solidity's `+` operator.
112      *
113      * Requirements:
114      *
115      * - Addition cannot overflow.
116      */
117     function add(uint256 a, uint256 b) internal pure returns (uint256) {
118         uint256 c = a + b;
119         require(c >= a, "SafeMath: addition overflow");
120 
121         return c;
122     }
123 
124     /**
125      * @dev Returns the subtraction of two unsigned integers, reverting on
126      * overflow (when the result is negative).
127      *
128      * Counterpart to Solidity's `-` operator.
129      *
130      * Requirements:
131      *
132      * - Subtraction cannot overflow.
133      */
134     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
135         return sub(a, b, "SafeMath: subtraction overflow");
136     }
137 
138     /**
139      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
140      * overflow (when the result is negative).
141      *
142      * Counterpart to Solidity's `-` operator.
143      *
144      * Requirements:
145      *
146      * - Subtraction cannot overflow.
147      */
148     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
149         require(b <= a, errorMessage);
150         uint256 c = a - b;
151 
152         return c;
153     }
154 
155     /**
156      * @dev Returns the multiplication of two unsigned integers, reverting on
157      * overflow.
158      *
159      * Counterpart to Solidity's `*` operator.
160      *
161      * Requirements:
162      *
163      * - Multiplication cannot overflow.
164      */
165     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
166         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
167         // benefit is lost if 'b' is also tested.
168         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
169         if (a == 0) {
170             return 0;
171         }
172 
173         uint256 c = a * b;
174         require(c / a == b, "SafeMath: multiplication overflow");
175 
176         return c;
177     }
178 
179     /**
180      * @dev Returns the integer division of two unsigned integers. Reverts on
181      * division by zero. The result is rounded towards zero.
182      *
183      * Counterpart to Solidity's `/` operator. Note: this function uses a
184      * `revert` opcode (which leaves remaining gas untouched) while Solidity
185      * uses an invalid opcode to revert (consuming all remaining gas).
186      *
187      * Requirements:
188      *
189      * - The divisor cannot be zero.
190      */
191     function div(uint256 a, uint256 b) internal pure returns (uint256) {
192         return div(a, b, "SafeMath: division by zero");
193     }
194 
195     /**
196      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
197      * division by zero. The result is rounded towards zero.
198      *
199      * Counterpart to Solidity's `/` operator. Note: this function uses a
200      * `revert` opcode (which leaves remaining gas untouched) while Solidity
201      * uses an invalid opcode to revert (consuming all remaining gas).
202      *
203      * Requirements:
204      *
205      * - The divisor cannot be zero.
206      */
207     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
208         require(b > 0, errorMessage);
209         uint256 c = a / b;
210         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
211 
212         return c;
213     }
214 
215     /**
216      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
217      * Reverts when dividing by zero.
218      *
219      * Counterpart to Solidity's `%` operator. This function uses a `revert`
220      * opcode (which leaves remaining gas untouched) while Solidity uses an
221      * invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
228         return mod(a, b, "SafeMath: modulo by zero");
229     }
230 
231     /**
232      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
233      * Reverts with custom message when dividing by zero.
234      *
235      * Counterpart to Solidity's `%` operator. This function uses a `revert`
236      * opcode (which leaves remaining gas untouched) while Solidity uses an
237      * invalid opcode to revert (consuming all remaining gas).
238      *
239      * Requirements:
240      *
241      * - The divisor cannot be zero.
242      */
243     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
244         require(b != 0, errorMessage);
245         return a % b;
246     }
247 }
248 
249 library Address {
250     /**
251      * @dev Returns true if `account` is a contract.
252      *
253      * [IMPORTANT]
254      * ====
255      * It is unsafe to assume that an address for which this function returns
256      * false is an externally-owned account (EOA) and not a contract.
257      *
258      * Among others, `isContract` will return false for the following
259      * types of addresses:
260      *
261      *  - an externally-owned account
262      *  - a contract in construction
263      *  - an address where a contract will be created
264      *  - an address where a contract lived, but was destroyed
265      * ====
266      */
267     function isContract(address account) internal view returns (bool) {
268         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
269         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
270         // for accounts without code, i.e. `keccak256('')`
271         bytes32 codehash;
272         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
273         // solhint-disable-next-line no-inline-assembly
274         assembly { codehash := extcodehash(account) }
275         return (codehash != accountHash && codehash != 0x0);
276     }
277 
278     /**
279      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
280      * `recipient`, forwarding all available gas and reverting on errors.
281      *
282      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
283      * of certain opcodes, possibly making contracts go over the 2300 gas limit
284      * imposed by `transfer`, making them unable to receive funds via
285      * `transfer`. {sendValue} removes this limitation.
286      *
287      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
288      *
289      * IMPORTANT: because control is transferred to `recipient`, care must be
290      * taken to not create reentrancy vulnerabilities. Consider using
291      * {ReentrancyGuard} or the
292      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
293      */
294     function sendValue(address payable recipient, uint256 amount) internal {
295         require(address(this).balance >= amount, "Address: insufficient balance");
296 
297         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
298         (bool success, ) = recipient.call{ value: amount }("");
299         require(success, "Address: unable to send value, recipient may have reverted");
300     }
301 
302     /**
303      * @dev Performs a Solidity function call using a low level `call`. A
304      * plain`call` is an unsafe replacement for a function call: use this
305      * function instead.
306      *
307      * If `target` reverts with a revert reason, it is bubbled up by this
308      * function (like regular Solidity function calls).
309      *
310      * Returns the raw returned data. To convert to the expected return value,
311      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
312      *
313      * Requirements:
314      *
315      * - `target` must be a contract.
316      * - calling `target` with `data` must not revert.
317      *
318      * _Available since v3.1._
319      */
320     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
321       return functionCall(target, data, "Address: low-level call failed");
322     }
323 
324     /**
325      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
326      * `errorMessage` as a fallback revert reason when `target` reverts.
327      *
328      * _Available since v3.1._
329      */
330     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
331         return _functionCallWithValue(target, data, 0, errorMessage);
332     }
333 
334     /**
335      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
336      * but also transferring `value` wei to `target`.
337      *
338      * Requirements:
339      *
340      * - the calling contract must have an ETH balance of at least `value`.
341      * - the called Solidity function must be `payable`.
342      *
343      * _Available since v3.1._
344      */
345     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
346         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
351      * with `errorMessage` as a fallback revert reason when `target` reverts.
352      *
353      * _Available since v3.1._
354      */
355     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
356         require(address(this).balance >= value, "Address: insufficient balance for call");
357         return _functionCallWithValue(target, data, value, errorMessage);
358     }
359 
360     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
361         require(isContract(target), "Address: call to non-contract");
362 
363         // solhint-disable-next-line avoid-low-level-calls
364         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
365         if (success) {
366             return returndata;
367         } else {
368             // Look for revert reason and bubble it up if present
369             if (returndata.length > 0) {
370                 // The easiest way to bubble the revert reason is using memory via assembly
371 
372                 // solhint-disable-next-line no-inline-assembly
373                 assembly {
374                     let returndata_size := mload(returndata)
375                     revert(add(32, returndata), returndata_size)
376                 }
377             } else {
378                 revert(errorMessage);
379             }
380         }
381     }
382 }
383 
384 contract Ownable is Context {
385     address private _owner;
386 
387     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
388 
389     /**
390      * @dev Initializes the contract setting the deployer as the initial owner.
391      */
392     constructor () {
393         address msgSender = _msgSender();
394         _owner = msgSender;
395         emit OwnershipTransferred(address(0), msgSender);
396     }
397 
398     /**
399      * @dev Returns the address of the current owner.
400      */
401     function owner() public view returns (address) {
402         return _owner;
403     }
404 
405     /**
406      * @dev Throws if called by any account other than the owner.
407      */
408     modifier onlyOwner() {
409         require(_owner == _msgSender(), "Ownable: caller is not the owner");
410         _;
411     }
412 
413     /**
414      * @dev Leaves the contract without owner. It will not be possible to call
415      * `onlyOwner` functions anymore. Can only be called by the current owner.
416      *
417      * NOTE: Renouncing ownership will leave the contract without an owner,
418      * thereby removing any functionality that is only available to the owner.
419      */
420     function renounceOwnership() public virtual onlyOwner {
421         emit OwnershipTransferred(_owner, address(0));
422         _owner = address(0);
423     }
424 
425     /**
426      * @dev Transfers ownership of the contract to a new account (`newOwner`).
427      * Can only be called by the current owner.
428      */
429     function transferOwnership(address newOwner) public virtual onlyOwner {
430         require(newOwner != address(0), "Ownable: new owner is the zero address");
431         emit OwnershipTransferred(_owner, newOwner);
432         _owner = newOwner;
433     }
434 }
435 
436 
437 
438 contract Spaceshiba is Context, IERC20, Ownable {
439     using SafeMath for uint256;
440     using Address for address;
441 
442     mapping (address => uint256) private _rOwned;
443     mapping (address => uint256) private _tOwned;
444     mapping (address => mapping (address => uint256)) private _allowances;
445 
446     mapping (address => bool) private _isExcluded;
447     address[] private _excluded;
448    
449     uint256 private constant MAX = ~uint256(0);
450     uint256 private constant _tTotal = 100000000 * 10**6 * 10**18;
451     uint256 private _rTotal = (MAX - (MAX % _tTotal));
452     uint256 private _tFeeTotal;
453 
454     string private _name = ' SpaceShiba';
455     string private _symbol = 'SSHIBA';
456     uint8 private _decimals = 18;
457 
458     constructor () public {
459         _rOwned[_msgSender()] = _rTotal;
460         emit Transfer(address(0), _msgSender(), _tTotal);
461     }
462 
463     function name() public view returns (string memory) {
464         return _name;
465     }
466 
467     function symbol() public view returns (string memory) {
468         return _symbol;
469     }
470 
471     function decimals() public view returns (uint8) {
472         return _decimals;
473     }
474 
475     function totalSupply() public view override returns (uint256) {
476         return _tTotal;
477     }
478 
479     function balanceOf(address account) public view override returns (uint256) {
480         if (_isExcluded[account]) return _tOwned[account];
481         return tokenFromReflection(_rOwned[account]);
482     }
483 
484     function transfer(address recipient, uint256 amount) public override returns (bool) {
485         _transfer(_msgSender(), recipient, amount);
486         return true;
487     }
488 
489     function allowance(address owner, address spender) public view override returns (uint256) {
490         return _allowances[owner][spender];
491     }
492 
493     function approve(address spender, uint256 amount) public override returns (bool) {
494         _approve(_msgSender(), spender, amount);
495         return true;
496     }
497 
498     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
499         _transfer(sender, recipient, amount);
500         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
501         return true;
502     }
503 
504     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
505         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
506         return true;
507     }
508 
509     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
510         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
511         return true;
512     }
513 
514     function isExcluded(address account) public view returns (bool) {
515         return _isExcluded[account];
516     }
517 
518     function totalFees() public view returns (uint256) {
519         return _tFeeTotal;
520     }
521 
522     function reflect(uint256 tAmount) public {
523         address sender = _msgSender();
524         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
525         (uint256 rAmount,,,,) = _getValues(tAmount);
526         _rOwned[sender] = _rOwned[sender].sub(rAmount);
527         _rTotal = _rTotal.sub(rAmount);
528         _tFeeTotal = _tFeeTotal.add(tAmount);
529     }
530 
531     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
532         require(tAmount <= _tTotal, "Amount must be less than supply");
533         if (!deductTransferFee) {
534             (uint256 rAmount,,,,) = _getValues(tAmount);
535             return rAmount;
536         } else {
537             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
538             return rTransferAmount;
539         }
540     }
541 
542     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
543         require(rAmount <= _rTotal, "Amount must be less than total reflections");
544         uint256 currentRate =  _getRate();
545         return rAmount.div(currentRate);
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
557     function includeAccount(address account) external onlyOwner() {
558         require(_isExcluded[account], "Account is already excluded");
559         for (uint256 i = 0; i < _excluded.length; i++) {
560             if (_excluded[i] == account) {
561                 _excluded[i] = _excluded[_excluded.length - 1];
562                 _tOwned[account] = 0;
563                 _isExcluded[account] = false;
564                 _excluded.pop();
565                 break;
566             }
567         }
568     }
569 
570     function _approve(address owner, address spender, uint256 amount) private {
571         require(owner != address(0), "ERC20: approve from the zero address");
572         require(spender != address(0), "ERC20: approve to the zero address");
573 
574         _allowances[owner][spender] = amount;
575         emit Approval(owner, spender, amount);
576     }
577 
578     function _transfer(address sender, address recipient, uint256 amount) private {
579         require(sender != address(0), "ERC20: transfer from the zero address");
580         require(recipient != address(0), "ERC20: transfer to the zero address");
581         require(amount > 0, "Transfer amount must be greater than zero");
582         if (_isExcluded[sender] && !_isExcluded[recipient]) {
583             _transferFromExcluded(sender, recipient, amount);
584         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
585             _transferToExcluded(sender, recipient, amount);
586         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
587             _transferStandard(sender, recipient, amount);
588         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
589             _transferBothExcluded(sender, recipient, amount);
590         } else {
591             _transferStandard(sender, recipient, amount);
592         }
593     }
594 
595     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
596         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
597         _rOwned[sender] = _rOwned[sender].sub(rAmount);
598         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
599         _reflectFee(rFee, tFee);
600         emit Transfer(sender, recipient, tTransferAmount);
601     }
602 
603     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
604         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
605         _rOwned[sender] = _rOwned[sender].sub(rAmount);
606         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
607         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
608         _reflectFee(rFee, tFee);
609         emit Transfer(sender, recipient, tTransferAmount);
610     }
611 
612     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
613         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
614         _tOwned[sender] = _tOwned[sender].sub(tAmount);
615         _rOwned[sender] = _rOwned[sender].sub(rAmount);
616         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
617         _reflectFee(rFee, tFee);
618         emit Transfer(sender, recipient, tTransferAmount);
619     }
620 
621     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
622         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
623         _tOwned[sender] = _tOwned[sender].sub(tAmount);
624         _rOwned[sender] = _rOwned[sender].sub(rAmount);
625         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
626         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
627         _reflectFee(rFee, tFee);
628         emit Transfer(sender, recipient, tTransferAmount);
629     }
630 
631     function _reflectFee(uint256 rFee, uint256 tFee) private {
632        
633         _rTotal = _rTotal.sub(rFee);
634         _tFeeTotal = _tFeeTotal.add(tFee);
635     }
636 
637     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
638         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
639         uint256 currentRate =  _getRate();
640         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
641         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
642     }
643 
644     function _getTValues(uint256 tAmount) private view returns (uint256, uint256) {
645        
646         uint256 tFee;
647         if(_tTotal >= 30000000 * (10**6) * (10**18))
648         {
649         tFee = tAmount.div(100).mul(5);
650         }
651         else
652         {
653         tFee = 0;
654         }
655         uint256 tTransferAmount = tAmount.sub(tFee);
656         return (tTransferAmount, tFee);
657     }
658 
659     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
660         uint256 rAmount = tAmount.mul(currentRate);
661         uint256 rFee = tFee.mul(currentRate);
662         uint256 rTransferAmount = rAmount.sub(rFee);
663         return (rAmount, rTransferAmount, rFee);
664     }
665 
666     function _getRate() private view returns(uint256) {
667         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
668         return rSupply.div(tSupply);
669     }
670     uint256 public rSupply;
671     uint256 public tSupply; 
672     function _getCurrentSupply() private view returns(uint256, uint256) {
673         uint256 rSupply = _rTotal;
674         uint256 tSupply = _tTotal;      
675         for (uint256 i = 0; i < _excluded.length; i++) {
676             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
677             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
678             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
679         }
680         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
681         return (rSupply, tSupply);
682     }
683 }