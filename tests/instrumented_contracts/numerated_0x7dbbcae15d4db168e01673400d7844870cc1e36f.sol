1 /**
2  *Submitted for verification at Etherscan.io on 2021-02-02
3 */
4 
5 pragma solidity >=0.6.2;
6 
7 
8 
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address payable) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes memory) {
15         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
16         return msg.data;
17     }
18 }
19 
20 
21 
22 /**
23  * @dev Interface of the ERC20 standard as defined in the EIP.
24  */
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
96 
97 
98 contract Ownable is Context {
99     address private _owner;
100     address private _previousOwner;
101     uint256 private _lockTime;
102 
103     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
104 
105     /**
106      * @dev Initializes the contract setting the deployer as the initial owner.
107      */
108     constructor () internal {
109         address msgSender = _msgSender();
110         _owner = msgSender;
111         emit OwnershipTransferred(address(0), msgSender);
112     }
113 
114     /**
115      * @dev Returns the address of the current owner.
116      */
117     function owner() public view returns (address) {
118         return _owner;
119     }
120 
121     /**
122      * @dev Throws if called by any account other than the owner.
123      */
124     modifier onlyOwner() {
125         require(_owner == _msgSender(), "Ownable: caller is not the owner");
126         _;
127     }
128 
129      /**
130      * @dev Leaves the contract without owner. It will not be possible to call
131      * `onlyOwner` functions anymore. Can only be called by the current owner.
132      *
133      * NOTE: Renouncing ownership will leave the contract without an owner,
134      * thereby removing any functionality that is only available to the owner.
135      */
136     function renounceOwnership() public virtual onlyOwner {
137         emit OwnershipTransferred(_owner, address(0));
138         _owner = address(0);
139     }
140 
141     /**
142      * @dev Transfers ownership of the contract to a new account (`newOwner`).
143      * Can only be called by the current owner.
144      */
145     function transferOwnership(address newOwner) public virtual onlyOwner {
146         require(newOwner != address(0), "Ownable: new owner is the zero address");
147         emit OwnershipTransferred(_owner, newOwner);
148         _owner = newOwner;
149     }
150 
151     function geUnlockTime() public view returns (uint256) {
152         return _lockTime;
153     }
154 
155     //Locks the contract for owner for the amount of time provided
156     function lock(uint256 time) public virtual onlyOwner {
157         _previousOwner = _owner;
158         _owner = address(0);
159         _lockTime = now + time;
160         emit OwnershipTransferred(_owner, address(0));
161     }
162     
163     //Unlocks the contract for owner when _lockTime is exceeds
164     function unlock() public virtual {
165         require(_previousOwner == msg.sender, "You don't have permission to unlock");
166         require(now > _lockTime , "Contract is locked until 7 days");
167         emit OwnershipTransferred(_owner, _previousOwner);
168         _owner = _previousOwner;
169     }
170 }
171 
172 
173 /**
174  * @dev Wrappers over Solidity's arithmetic operations with added overflow
175  * checks.
176  *
177  * Arithmetic operations in Solidity wrap on overflow. This can easily result
178  * in bugs, because programmers usually assume that an overflow raises an
179  * error, which is the standard behavior in high level programming languages.
180  * `SafeMath` restores this intuition by reverting the transaction when an
181  * operation overflows.
182  *
183  * Using this library instead of the unchecked operations eliminates an entire
184  * class of bugs, so it's recommended to use it always.
185  */
186 library SafeMath {
187     /**
188      * @dev Returns the addition of two unsigned integers, reverting on
189      * overflow.
190      *
191      * Counterpart to Solidity's `+` operator.
192      *
193      * Requirements:
194      *
195      * - Addition cannot overflow.
196      */
197     function add(uint256 a, uint256 b) internal pure returns (uint256) {
198         uint256 c = a + b;
199         require(c >= a, "SafeMath: addition overflow");
200 
201         return c;
202     }
203 
204     /**
205      * @dev Returns the subtraction of two unsigned integers, reverting on
206      * overflow (when the result is negative).
207      *
208      * Counterpart to Solidity's `-` operator.
209      *
210      * Requirements:
211      *
212      * - Subtraction cannot overflow.
213      */
214     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
215         return sub(a, b, "SafeMath: subtraction overflow");
216     }
217 
218     /**
219      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
220      * overflow (when the result is negative).
221      *
222      * Counterpart to Solidity's `-` operator.
223      *
224      * Requirements:
225      *
226      * - Subtraction cannot overflow.
227      */
228     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b <= a, errorMessage);
230         uint256 c = a - b;
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the multiplication of two unsigned integers, reverting on
237      * overflow.
238      *
239      * Counterpart to Solidity's `*` operator.
240      *
241      * Requirements:
242      *
243      * - Multiplication cannot overflow.
244      */
245     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
246         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
247         // benefit is lost if 'b' is also tested.
248         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
249         if (a == 0) {
250             return 0;
251         }
252 
253         uint256 c = a * b;
254         require(c / a == b, "SafeMath: multiplication overflow");
255 
256         return c;
257     }
258 
259     /**
260      * @dev Returns the integer division of two unsigned integers. Reverts on
261      * division by zero. The result is rounded towards zero.
262      *
263      * Counterpart to Solidity's `/` operator. Note: this function uses a
264      * `revert` opcode (which leaves remaining gas untouched) while Solidity
265      * uses an invalid opcode to revert (consuming all remaining gas).
266      *
267      * Requirements:
268      *
269      * - The divisor cannot be zero.
270      */
271     function div(uint256 a, uint256 b) internal pure returns (uint256) {
272         return div(a, b, "SafeMath: division by zero");
273     }
274 
275     /**
276      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
277      * division by zero. The result is rounded towards zero.
278      *
279      * Counterpart to Solidity's `/` operator. Note: this function uses a
280      * `revert` opcode (which leaves remaining gas untouched) while Solidity
281      * uses an invalid opcode to revert (consuming all remaining gas).
282      *
283      * Requirements:
284      *
285      * - The divisor cannot be zero.
286      */
287     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
288         require(b > 0, errorMessage);
289         uint256 c = a / b;
290         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
291 
292         return c;
293     }
294 
295     /**
296      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
297      * Reverts when dividing by zero.
298      *
299      * Counterpart to Solidity's `%` operator. This function uses a `revert`
300      * opcode (which leaves remaining gas untouched) while Solidity uses an
301      * invalid opcode to revert (consuming all remaining gas).
302      *
303      * Requirements:
304      *
305      * - The divisor cannot be zero.
306      */
307     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
308         return mod(a, b, "SafeMath: modulo by zero");
309     }
310 
311     /**
312      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
313      * Reverts with custom message when dividing by zero.
314      *
315      * Counterpart to Solidity's `%` operator. This function uses a `revert`
316      * opcode (which leaves remaining gas untouched) while Solidity uses an
317      * invalid opcode to revert (consuming all remaining gas).
318      *
319      * Requirements:
320      *
321      * - The divisor cannot be zero.
322      */
323     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
324         require(b != 0, errorMessage);
325         return a % b;
326     }
327 }
328 
329 
330 /**
331  * @dev Collection of functions related to the address type
332  */
333 library Address {
334     /**
335      * @dev Returns true if `account` is a contract.
336      *
337      * [IMPORTANT]
338      * ====
339      * It is unsafe to assume that an address for which this function returns
340      * false is an externally-owned account (EOA) and not a contract.
341      *
342      * Among others, `isContract` will return false for the following
343      * types of addresses:
344      *
345      *  - an externally-owned account
346      *  - a contract in construction
347      *  - an address where a contract will be created
348      *  - an address where a contract lived, but was destroyed
349      * ====
350      */
351     function isContract(address account) internal view returns (bool) {
352         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
353         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
354         // for accounts without code, i.e. `keccak256('')`
355         bytes32 codehash;
356         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
357         // solhint-disable-next-line no-inline-assembly
358         assembly { codehash := extcodehash(account) }
359         return (codehash != accountHash && codehash != 0x0);
360     }
361 
362     /**
363      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
364      * `recipient`, forwarding all available gas and reverting on errors.
365      *
366      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
367      * of certain opcodes, possibly making contracts go over the 2300 gas limit
368      * imposed by `transfer`, making them unable to receive funds via
369      * `transfer`. {sendValue} removes this limitation.
370      *
371      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
372      *
373      * IMPORTANT: because control is transferred to `recipient`, care must be
374      * taken to not create reentrancy vulnerabilities. Consider using
375      * {ReentrancyGuard} or the
376      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
377      */
378     function sendValue(address payable recipient, uint256 amount) internal {
379         require(address(this).balance >= amount, "Address: insufficient balance");
380 
381         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
382         (bool success, ) = recipient.call{ value: amount }("");
383         require(success, "Address: unable to send value, recipient may have reverted");
384     }
385 
386     /**
387      * @dev Performs a Solidity function call using a low level `call`. A
388      * plain`call` is an unsafe replacement for a function call: use this
389      * function instead.
390      *
391      * If `target` reverts with a revert reason, it is bubbled up by this
392      * function (like regular Solidity function calls).
393      *
394      * Returns the raw returned data. To convert to the expected return value,
395      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
396      *
397      * Requirements:
398      *
399      * - `target` must be a contract.
400      * - calling `target` with `data` must not revert.
401      *
402      * _Available since v3.1._
403      */
404     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
405       return functionCall(target, data, "Address: low-level call failed");
406     }
407 
408     /**
409      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
410      * `errorMessage` as a fallback revert reason when `target` reverts.
411      *
412      * _Available since v3.1._
413      */
414     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
415         return _functionCallWithValue(target, data, 0, errorMessage);
416     }
417 
418     /**
419      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
420      * but also transferring `value` wei to `target`.
421      *
422      * Requirements:
423      *
424      * - the calling contract must have an ETH balance of at least `value`.
425      * - the called Solidity function must be `payable`.
426      *
427      * _Available since v3.1._
428      */
429     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
430         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
431     }
432 
433     /**
434      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
435      * with `errorMessage` as a fallback revert reason when `target` reverts.
436      *
437      * _Available since v3.1._
438      */
439     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
440         require(address(this).balance >= value, "Address: insufficient balance for call");
441         return _functionCallWithValue(target, data, value, errorMessage);
442     }
443 
444     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
445         require(isContract(target), "Address: call to non-contract");
446 
447         // solhint-disable-next-line avoid-low-level-calls
448         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
449         if (success) {
450             return returndata;
451         } else {
452             // Look for revert reason and bubble it up if present
453             if (returndata.length > 0) {
454                 // The easiest way to bubble the revert reason is using memory via assembly
455 
456                 // solhint-disable-next-line no-inline-assembly
457                 assembly {
458                     let returndata_size := mload(returndata)
459                     revert(add(32, returndata), returndata_size)
460                 }
461             } else {
462                 revert(errorMessage);
463             }
464         }
465     }
466 }
467 
468 
469 contract WOLFYCOIN is Context, IERC20, Ownable {
470     using SafeMath for uint256;
471     using Address for address;
472 
473     mapping (address => uint256) private _rOwned;
474     mapping (address => uint256) private _tOwned;
475     mapping (address => mapping (address => uint256)) private _allowances;
476 
477     mapping (address => bool) private _isExcluded;
478     address[] private _excluded;
479    
480     uint256 private constant MAX = ~uint256(0);
481     uint256 private _tTotal = 1000000000 * 10**9;
482     uint256 private _rTotal = (MAX - (MAX % _tTotal));
483     uint256 private _tFeeTotal;
484     uint256 private _tBurnTotal;
485 
486     string private _name = 'WOLFYCOIN';
487     string private _symbol = 'WOLFY';
488     uint8 private _decimals = 9;
489     
490     uint256 private _taxFee = 2;
491     uint256 private _burnFee = 1;
492     uint256 private _maxTxAmount = 1000000000e9;
493 
494     constructor () public {
495         _rOwned[_msgSender()] = _rTotal;
496         emit Transfer(address(0), _msgSender(), _tTotal);
497     }
498 
499     function name() public view returns (string memory) {
500         return _name;
501     }
502 
503     function symbol() public view returns (string memory) {
504         return _symbol;
505     }
506 
507     function decimals() public view returns (uint8) {
508         return _decimals;
509     }
510 
511     function totalSupply() public view override returns (uint256) {
512         return _tTotal;
513     }
514 
515     function balanceOf(address account) public view override returns (uint256) {
516         if (_isExcluded[account]) return _tOwned[account];
517         return tokenFromReflection(_rOwned[account]);
518     }
519 
520     function transfer(address recipient, uint256 amount) public override returns (bool) {
521         _transfer(_msgSender(), recipient, amount);
522         return true;
523     }
524 
525     function allowance(address owner, address spender) public view override returns (uint256) {
526         return _allowances[owner][spender];
527     }
528 
529     function approve(address spender, uint256 amount) public override returns (bool) {
530         _approve(_msgSender(), spender, amount);
531         return true;
532     }
533 
534     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
535         _transfer(sender, recipient, amount);
536         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
537         return true;
538     }
539 
540     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
541         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
542         return true;
543     }
544 
545     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
546         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
547         return true;
548     }
549 
550     function isExcluded(address account) public view returns (bool) {
551         return _isExcluded[account];
552     }
553 
554     function totalFees() public view returns (uint256) {
555         return _tFeeTotal;
556     }
557     
558     function totalBurn() public view returns (uint256) {
559         return _tBurnTotal;
560     }
561 
562     function deliver(uint256 tAmount) public {
563         address sender = _msgSender();
564         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
565         (uint256 rAmount,,,,,) = _getValues(tAmount);
566         _rOwned[sender] = _rOwned[sender].sub(rAmount);
567         _rTotal = _rTotal.sub(rAmount);
568         _tFeeTotal = _tFeeTotal.add(tAmount);
569     }
570 
571     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
572         require(tAmount <= _tTotal, "Amount must be less than supply");
573         if (!deductTransferFee) {
574             (uint256 rAmount,,,,,) = _getValues(tAmount);
575             return rAmount;
576         } else {
577             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
578             return rTransferAmount;
579         }
580     }
581 
582     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
583         require(rAmount <= _rTotal, "Amount must be less than total reflections");
584         uint256 currentRate =  _getRate();
585         return rAmount.div(currentRate);
586     }
587 
588     function excludeAccount(address account) external onlyOwner() {
589         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
590         require(!_isExcluded[account], "Account is already excluded");
591         if(_rOwned[account] > 0) {
592             _tOwned[account] = tokenFromReflection(_rOwned[account]);
593         }
594         _isExcluded[account] = true;
595         _excluded.push(account);
596     }
597 
598     function includeAccount(address account) external onlyOwner() {
599         require(_isExcluded[account], "Account is already excluded");
600         for (uint256 i = 0; i < _excluded.length; i++) {
601             if (_excluded[i] == account) {
602                 _excluded[i] = _excluded[_excluded.length - 1];
603                 _tOwned[account] = 0;
604                 _isExcluded[account] = false;
605                 _excluded.pop();
606                 break;
607             }
608         }
609     }
610 
611     function _approve(address owner, address spender, uint256 amount) private {
612         require(owner != address(0), "ERC20: approve from the zero address");
613         require(spender != address(0), "ERC20: approve to the zero address");
614 
615         _allowances[owner][spender] = amount;
616         emit Approval(owner, spender, amount);
617     }
618 
619     function _transfer(address sender, address recipient, uint256 amount) private {
620         require(sender != address(0), "ERC20: transfer from the zero address");
621         require(recipient != address(0), "ERC20: transfer to the zero address");
622         require(amount > 0, "Transfer amount must be greater than zero");
623         
624         if(sender != owner() && recipient != owner())
625             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
626         
627         if (_isExcluded[sender] && !_isExcluded[recipient]) {
628             _transferFromExcluded(sender, recipient, amount);
629         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
630             _transferToExcluded(sender, recipient, amount);
631         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
632             _transferStandard(sender, recipient, amount);
633         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
634             _transferBothExcluded(sender, recipient, amount);
635         } else {
636             _transferStandard(sender, recipient, amount);
637         }
638     }
639 
640     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
641         uint256 currentRate =  _getRate();
642         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
643         uint256 rBurn =  tBurn.mul(currentRate);
644         _rOwned[sender] = _rOwned[sender].sub(rAmount);
645         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
646         _reflectFee(rFee, rBurn, tFee, tBurn);
647         emit Transfer(sender, recipient, tTransferAmount);
648     }
649 
650     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
651         uint256 currentRate =  _getRate();
652         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
653         uint256 rBurn =  tBurn.mul(currentRate);
654         _rOwned[sender] = _rOwned[sender].sub(rAmount);
655         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
656         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
657         _reflectFee(rFee, rBurn, tFee, tBurn);
658         emit Transfer(sender, recipient, tTransferAmount);
659     }
660 
661     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
662         uint256 currentRate =  _getRate();
663         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
664         uint256 rBurn =  tBurn.mul(currentRate);
665         _tOwned[sender] = _tOwned[sender].sub(tAmount);
666         _rOwned[sender] = _rOwned[sender].sub(rAmount);
667         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
668         _reflectFee(rFee, rBurn, tFee, tBurn);
669         emit Transfer(sender, recipient, tTransferAmount);
670     }
671 
672     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
673         uint256 currentRate =  _getRate();
674         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
675         uint256 rBurn =  tBurn.mul(currentRate);
676         _tOwned[sender] = _tOwned[sender].sub(tAmount);
677         _rOwned[sender] = _rOwned[sender].sub(rAmount);
678         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
679         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
680         _reflectFee(rFee, rBurn, tFee, tBurn);
681         emit Transfer(sender, recipient, tTransferAmount);
682     }
683 
684     function _reflectFee(uint256 rFee, uint256 rBurn, uint256 tFee, uint256 tBurn) private {
685         _rTotal = _rTotal.sub(rFee).sub(rBurn);
686         _tFeeTotal = _tFeeTotal.add(tFee);
687         _tBurnTotal = _tBurnTotal.add(tBurn);
688         _tTotal = _tTotal.sub(tBurn);
689     }
690 
691     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
692         (uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getTValues(tAmount, _taxFee, _burnFee);
693         uint256 currentRate =  _getRate();
694         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tBurn, currentRate);
695         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBurn);
696     }
697 
698     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 burnFee) private pure returns (uint256, uint256, uint256) {
699         uint256 tFee = tAmount.mul(taxFee).div(100);
700         uint256 tBurn = tAmount.mul(burnFee).div(100);
701         uint256 tTransferAmount = tAmount.sub(tFee).sub(tBurn);
702         return (tTransferAmount, tFee, tBurn);
703     }
704 
705     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tBurn, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
706         uint256 rAmount = tAmount.mul(currentRate);
707         uint256 rFee = tFee.mul(currentRate);
708         uint256 rBurn = tBurn.mul(currentRate);
709         uint256 rTransferAmount = rAmount.sub(rFee).sub(rBurn);
710         return (rAmount, rTransferAmount, rFee);
711     }
712 
713     function _getRate() private view returns(uint256) {
714         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
715         return rSupply.div(tSupply);
716     }
717 
718     function _getCurrentSupply() private view returns(uint256, uint256) {
719         uint256 rSupply = _rTotal;
720         uint256 tSupply = _tTotal;      
721         for (uint256 i = 0; i < _excluded.length; i++) {
722             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
723             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
724             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
725         }
726         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
727         return (rSupply, tSupply);
728     }
729     
730     function _getTaxFee() private view returns(uint256) {
731         return _taxFee;
732     }
733 
734     function _getMaxTxAmount() private view returns(uint256) {
735         return _maxTxAmount;
736     }
737     
738     function _setTaxFee(uint256 taxFee) external onlyOwner() {
739         require(taxFee >= 1 && taxFee <= 10, 'taxFee should be in 1 - 10');
740         _taxFee = taxFee;
741     }
742     
743     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
744         require(maxTxAmount >= 100000000000000e9 , 'maxTxAmount should be greater than 100000000000000e9');
745         _maxTxAmount = maxTxAmount;
746     }
747 }