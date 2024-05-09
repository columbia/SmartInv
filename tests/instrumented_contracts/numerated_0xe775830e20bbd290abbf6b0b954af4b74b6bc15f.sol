1 /**
2  *Submitted for verification at Etherscan.io on 2021-04-26
3 */
4 
5 pragma solidity ^0.6.12;
6 
7 // SPDX-License-Identifier: MIT
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
20 /**
21  * @dev Interface of the ERC20  standard as defined in the EIP.
22  */
23 interface IERC20  {
24     /**
25      * @dev Returns the amount of tokens in existence.
26      */
27     function totalSupply() external view returns (uint256);
28 
29     /**
30      * @dev Returns the amount of tokens owned by `account`.
31      */
32     function balanceOf(address account) external view returns (uint256);
33 
34     /**
35      * @dev Moves `amount` tokens from the caller's account to `recipient`.
36      *
37      * Returns a boolean value indicating whether the operation succeeded.
38      *
39      * Emits a {Transfer} event.
40      */
41     function transfer(address recipient, uint256 amount) external returns (bool);
42 
43     /**
44      * @dev Returns the remaining number of tokens that `spender` will be
45      * allowed to spend on behalf of `owner` through {transferFrom}. This is
46      * zero by default.
47      *
48      * This value changes when {approve} or {transferFrom} are called.
49      */
50     function allowance(address owner, address spender) external view returns (uint256);
51 
52     /**
53      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
54      *
55      * Returns a boolean value indicating whether the operation succeeded.
56      *
57      * IMPORTANT: Beware that changing an allowance with this method brings the risk
58      * that someone may use both the old and the new allowance by unfortunate
59      * transaction ordering. One possible solution to mitigate this race
60      * condition is to first reduce the spender's allowance to 0 and set the
61      * desired value afterwards:
62      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
63      *
64      * Emits an {Approval} event.
65      */
66     function approve(address spender, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Moves `amount` tokens from `sender` to `recipient` using the
70      * allowance mechanism. `amount` is then deducted from the caller's
71      * allowance.
72      *
73      * Returns a boolean value indicating whether the operation succeeded.
74      *
75      * Emits a {Transfer} event.
76      */
77     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Emitted when `value` tokens are moved from one account (`from`) to
81      * another (`to`).
82      *
83      * Note that `value` may be zero.
84      */
85     event Transfer(address indexed from, address indexed to, uint256 value);
86 
87     /**
88      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
89      * a call to {approve}. `value` is the new allowance.
90      */
91     event Approval(address indexed owner, address indexed spender, uint256 value);
92 }
93 
94 /**
95  * @dev Wrappers over Solidity's arithmetic operations with added overflow
96  * checks.
97  *
98  * Arithmetic operations in Solidity wrap on overflow. This can easily result
99  * in bugs, because programmers usually assume that an overflow raises an
100  * error, which is the standard behavior in high level programming languages.
101  * `SafeMath` restores this intuition by reverting the transaction when an
102  * operation overflows.
103  *
104  * Using this library instead of the unchecked operations eliminates an entire
105  * class of bugs, so it's recommended to use it always.
106  */
107 library SafeMath {
108     /**
109      * @dev Returns the addition of two unsigned integers, reverting on
110      * overflow.
111      *
112      * Counterpart to Solidity's `+` operator.
113      *
114      * Requirements:
115      *
116      * - Addition cannot overflow.
117      */
118     function add(uint256 a, uint256 b) internal pure returns (uint256) {
119         uint256 c = a + b;
120         require(c >= a, "SafeMath: addition overflow");
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the subtraction of two unsigned integers, reverting on
127      * overflow (when the result is negative).
128      *
129      * Counterpart to Solidity's `-` operator.
130      *
131      * Requirements:
132      *
133      * - Subtraction cannot overflow.
134      */
135     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
136         return sub(a, b, "SafeMath: subtraction overflow");
137     }
138 
139     /**
140      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
141      * overflow (when the result is negative).
142      *
143      * Counterpart to Solidity's `-` operator.
144      *
145      * Requirements:
146      *
147      * - Subtraction cannot overflow.
148      */
149     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
150         require(b <= a, errorMessage);
151         uint256 c = a - b;
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the multiplication of two unsigned integers, reverting on
158      * overflow.
159      *
160      * Counterpart to Solidity's `*` operator.
161      *
162      * Requirements:
163      *
164      * - Multiplication cannot overflow.
165      */
166     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
167         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
168         // benefit is lost if 'b' is also tested.
169         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
170         if (a == 0) {
171             return 0;
172         }
173 
174         uint256 c = a * b;
175         require(c / a == b, "SafeMath: multiplication overflow");
176 
177         return c;
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers. Reverts on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b) internal pure returns (uint256) {
193         return div(a, b, "SafeMath: division by zero");
194     }
195 
196     /**
197      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
198      * division by zero. The result is rounded towards zero.
199      *
200      * Counterpart to Solidity's `/` operator. Note: this function uses a
201      * `revert` opcode (which leaves remaining gas untouched) while Solidity
202      * uses an invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
209         require(b > 0, errorMessage);
210         uint256 c = a / b;
211         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
212 
213         return c;
214     }
215 
216     /**
217      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
218      * Reverts when dividing by zero.
219      *
220      * Counterpart to Solidity's `%` operator. This function uses a `revert`
221      * opcode (which leaves remaining gas untouched) while Solidity uses an
222      * invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
229         return mod(a, b, "SafeMath: modulo by zero");
230     }
231 
232     /**
233      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
234      * Reverts with custom message when dividing by zero.
235      *
236      * Counterpart to Solidity's `%` operator. This function uses a `revert`
237      * opcode (which leaves remaining gas untouched) while Solidity uses an
238      * invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
245         require(b != 0, errorMessage);
246         return a % b;
247     }
248 }
249 
250 /**
251  * @dev Collection of functions related to the address type
252  */
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
388 /**
389  * @dev Contract module which provides a basic access control mechanism, where
390  * there is an account (an owner) that can be granted exclusive access to
391  * specific functions.
392  *
393  * By default, the owner account will be the one that deploys the contract. This
394  * can later be changed with {transferOwnership}.
395  *
396  * This module is used through inheritance. It will make available the modifier
397  * `onlyOwner`, which can be applied to your functions to restrict their use to
398  * the owner.
399  */
400 contract Ownable is Context {
401     address private _owner;
402 
403     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
404 
405     /**
406      * @dev Initializes the contract setting the deployer as the initial owner.
407      */
408     constructor () internal {
409         address msgSender = _msgSender();
410         _owner = msgSender;
411         emit OwnershipTransferred(address(0), msgSender);
412     }
413 
414     /**
415      * @dev Returns the address of the current owner.
416      */
417     function owner() public view returns (address) {
418         return _owner;
419     }
420 
421     /**
422      * @dev Throws if called by any account other than the owner.
423      */
424     modifier onlyOwner() {
425         require(_owner == _msgSender(), "Ownable: caller is not the owner");
426         _;
427     }
428 
429     /**
430      * @dev Leaves the contract without owner. It will not be possible to call
431      * `onlyOwner` functions anymore. Can only be called by the current owner.
432      *
433      * NOTE: Renouncing ownership will leave the contract without an owner,
434      * thereby removing any functionality that is only available to the owner.
435      */
436     function renounceOwnership() public virtual onlyOwner {
437         emit OwnershipTransferred(_owner, address(0));
438         _owner = address(0);
439     }
440 
441     /**
442      * @dev Transfers ownership of the contract to a new account (`newOwner`).
443      * Can only be called by the current owner.
444      */
445     function transferOwnership(address newOwner) public virtual onlyOwner {
446         require(newOwner != address(0), "Ownable: new owner is the zero address");
447         emit OwnershipTransferred(_owner, newOwner);
448         _owner = newOwner;
449     }
450 }
451 
452 contract DOGE1 is Context, IERC20, Ownable {
453     using SafeMath for uint256;
454     using Address for address;
455 
456     mapping (address => uint256) private _rOwned;
457     mapping (address => uint256) private _tOwned;
458     mapping (address => mapping (address => uint256)) private _allowances;
459 
460     mapping (address => bool) private _isExcluded;
461     address[] private _excluded;
462     
463     string  private constant _NAME = 'Doge-1 Inu';
464     string  private constant _SYMBOL = 'Doge-1';
465     uint8   private constant _DECIMALS = 8;
466    
467     uint256 private constant _MAX = ~uint256(0);
468     uint256 private constant _DECIMALFACTOR = 10 ** uint256(_DECIMALS);
469     uint256 private constant _GRANULARITY = 100;
470     
471     uint256 private _tTotal = 1000000000000000 * _DECIMALFACTOR;
472     uint256 private _rTotal = (_MAX - (_MAX % _tTotal));
473     
474     uint256 private _tFeeTotal;
475     uint256 private _tBurnTotal;
476     
477     uint256 private      _TAX_FEE = 0;
478     uint256 private     _BURN_FEE = 0;
479     uint256 private     _MAX_TX_SIZE = 10000000000000 * _DECIMALFACTOR;
480 
481     constructor () public {
482         _rOwned[_msgSender()] = _rTotal;
483         emit Transfer(address(0), _msgSender(), _tTotal);
484     }
485 
486     function name() public view returns (string memory) {
487         return _NAME;
488     }
489 
490     function symbol() public view returns (string memory) {
491         return _SYMBOL;
492     }
493 
494     function decimals() public view returns (uint8) {
495         return _DECIMALS;
496     }
497 
498     function totalSupply() public view override returns (uint256) {
499         return _tTotal;
500     }
501 
502     function balanceOf(address account) public view override returns (uint256) {
503         if (_isExcluded[account]) return _tOwned[account];
504         return tokenFromReflection(_rOwned[account]);
505     }
506 
507     function transfer(address recipient, uint256 amount) public override returns (bool) {
508         _transfer(_msgSender(), recipient, amount);
509         return true;
510     }
511 
512     function allowance(address owner, address spender) public view override returns (uint256) {
513         return _allowances[owner][spender];
514     }
515 
516     function approve(address spender, uint256 amount) public override returns (bool) {
517         _approve(_msgSender(), spender, amount);
518         return true;
519     }
520 
521     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
522         _transfer(sender, recipient, amount);
523         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
524         return true;
525     }
526 
527     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
528         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
529         return true;
530     }
531 
532     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
533         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
534         return true;
535     }
536 
537     function isExcluded(address account) public view returns (bool) {
538         return _isExcluded[account];
539     }
540 
541     function totalFees() public view returns (uint256) {
542         return _tFeeTotal;
543     }
544     
545     function totalBurn() public view returns (uint256) {
546         return _tBurnTotal;
547     }
548 
549     function deliver(uint256 tAmount) public {
550         address sender = _msgSender();
551         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
552         (uint256 rAmount,,,,,) = _getValues(tAmount);
553         _rOwned[sender] = _rOwned[sender].sub(rAmount);
554         _rTotal = _rTotal.sub(rAmount);
555         _tFeeTotal = _tFeeTotal.add(tAmount);
556     }
557 
558     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
559         require(tAmount <= _tTotal, "Amount must be less than supply");
560         if (!deductTransferFee) {
561             (uint256 rAmount,,,,,) = _getValues(tAmount);
562             return rAmount;
563         } else {
564             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
565             return rTransferAmount;
566         }
567     }
568 
569     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
570         require(rAmount <= _rTotal, "Amount must be less than total reflections");
571         uint256 currentRate =  _getRate();
572         return rAmount.div(currentRate);
573     }
574 
575     function excludeAccount(address account) external onlyOwner() {
576         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
577         require(!_isExcluded[account], "Account is already excluded");
578         if(_rOwned[account] > 0) {
579             _tOwned[account] = tokenFromReflection(_rOwned[account]);
580         }
581         _isExcluded[account] = true;
582         _excluded.push(account);
583     }
584 
585     function includeAccount(address account) external onlyOwner() {
586         require(_isExcluded[account], "Account is already excluded");
587         for (uint256 i = 0; i < _excluded.length; i++) {
588             if (_excluded[i] == account) {
589                 _excluded[i] = _excluded[_excluded.length - 1];
590                 _tOwned[account] = 0;
591                 _isExcluded[account] = false;
592                 _excluded.pop();
593                 break;
594             }
595         }
596     }
597 
598     function _approve(address owner, address spender, uint256 amount) private {
599         require(owner != address(0), "ERC20: approve from the zero address");
600         require(spender != address(0), "ERC20: approve to the zero address");
601 
602         _allowances[owner][spender] = amount;
603         emit Approval(owner, spender, amount);
604     }
605 
606     function _transfer(address sender, address recipient, uint256 amount) private {
607         require(sender != address(0), "ERC20: transfer from the zero address");
608         require(recipient != address(0), "ERC20: transfer to the zero address");
609         require(amount > 0, "Transfer amount must be greater than zero");
610         
611         if(sender != owner() && recipient != owner())
612             require(amount <= _MAX_TX_SIZE, "Transfer amount exceeds the maxTxAmount.");
613         
614         if (_isExcluded[sender] && !_isExcluded[recipient]) {
615             _transferFromExcluded(sender, recipient, amount);
616         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
617             _transferToExcluded(sender, recipient, amount);
618         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
619             _transferStandard(sender, recipient, amount);
620         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
621             _transferBothExcluded(sender, recipient, amount);
622         } else {
623             _transferStandard(sender, recipient, amount);
624         }
625     }
626 
627     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
628         uint256 currentRate =  _getRate();
629         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
630         uint256 rBurn =  tBurn.mul(currentRate);
631         _rOwned[sender] = _rOwned[sender].sub(rAmount);
632         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
633         _reflectFee(rFee, rBurn, tFee, tBurn);
634         emit Transfer(sender, recipient, tTransferAmount);
635     }
636 
637     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
638         uint256 currentRate =  _getRate();
639         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
640         uint256 rBurn =  tBurn.mul(currentRate);
641         _rOwned[sender] = _rOwned[sender].sub(rAmount);
642         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
643         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
644         _reflectFee(rFee, rBurn, tFee, tBurn);
645         emit Transfer(sender, recipient, tTransferAmount);
646     }
647 
648     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
649         uint256 currentRate =  _getRate();
650         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
651         uint256 rBurn =  tBurn.mul(currentRate);
652         _tOwned[sender] = _tOwned[sender].sub(tAmount);
653         _rOwned[sender] = _rOwned[sender].sub(rAmount);
654         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
655         _reflectFee(rFee, rBurn, tFee, tBurn);
656         emit Transfer(sender, recipient, tTransferAmount);
657     }
658 
659     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
660         uint256 currentRate =  _getRate();
661         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
662         uint256 rBurn =  tBurn.mul(currentRate);
663         _tOwned[sender] = _tOwned[sender].sub(tAmount);
664         _rOwned[sender] = _rOwned[sender].sub(rAmount);
665         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
666         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
667         _reflectFee(rFee, rBurn, tFee, tBurn);
668         emit Transfer(sender, recipient, tTransferAmount);
669     }
670 
671     function _reflectFee(uint256 rFee, uint256 rBurn, uint256 tFee, uint256 tBurn) private {
672         _rTotal = _rTotal.sub(rFee).sub(rBurn);
673         _tFeeTotal = _tFeeTotal.add(tFee);
674         _tBurnTotal = _tBurnTotal.add(tBurn);
675         _tTotal = _tTotal.sub(tBurn);
676     }
677 
678     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
679         (uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getTValues(tAmount, _TAX_FEE, _BURN_FEE);
680         uint256 currentRate =  _getRate();
681         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tBurn, currentRate);
682         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBurn);
683     }
684 
685     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 burnFee) private pure returns (uint256, uint256, uint256) {
686         uint256 tFee = ((tAmount.mul(taxFee)).div(_GRANULARITY)).div(100);
687         uint256 tBurn = ((tAmount.mul(burnFee)).div(_GRANULARITY)).div(100);
688         uint256 tTransferAmount = tAmount.sub(tFee).sub(tBurn);
689         return (tTransferAmount, tFee, tBurn);
690     }
691 
692     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tBurn, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
693         uint256 rAmount = tAmount.mul(currentRate);
694         uint256 rFee = tFee.mul(currentRate);
695         uint256 rBurn = tBurn.mul(currentRate);
696         uint256 rTransferAmount = rAmount.sub(rFee).sub(rBurn);
697         return (rAmount, rTransferAmount, rFee);
698     }
699 
700     function _getRate() private view returns(uint256) {
701         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
702         return rSupply.div(tSupply);
703     }
704 
705     function _getCurrentSupply() private view returns(uint256, uint256) {
706         uint256 rSupply = _rTotal;
707         uint256 tSupply = _tTotal;      
708         for (uint256 i = 0; i < _excluded.length; i++) {
709             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
710             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
711             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
712         }
713         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
714         return (rSupply, tSupply);
715     }
716     
717     function _getTaxFee() private view returns(uint256) {
718         return _TAX_FEE;
719     }
720 
721     function _setTaxFee(uint256 taxFee) external onlyOwner() {
722         require(taxFee >= 50 && taxFee <= 1000, 'taxFee should be in 1 - 10');
723         _TAX_FEE = taxFee;
724     }
725 
726     function _setBurnFee(uint256 burnFee) external onlyOwner() {
727         require(burnFee >= 50 && burnFee <= 1000, 'burnFee should be in 1 - 10');
728         _BURN_FEE = burnFee;
729     }
730 
731     function _getMaxTxAmount() private view returns(uint256) {
732         return _MAX_TX_SIZE;
733     }
734     
735     function getMaxTxAmount() public view returns(uint256) {
736         return _getMaxTxAmount();
737     }
738     
739     function setMaxTxPercent(uint256 maxTxPercent) external onlyOwner() {
740         _MAX_TX_SIZE = _tTotal.mul(maxTxPercent).div(
741             10**2
742         );
743     }
744 }