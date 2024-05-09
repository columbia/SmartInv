1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.0;
4 
5 /*
6 \\\     \\       \\     \      \\
7  \\\\    \\\  \\  \\\    \\  \ \\\\    \
8   \\\\\  \\\\\ \\  \\\\\  \\\ \\ \\\\   \\  \\
9     \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\  \\  \\
10       \\\\\\\\\\ \\\\\\\\\\\\\\\\\\\\\\\\\\\  \\
11         \\\\\\\//PROPHET.FINANCE//\\\\\\\\\\\\\\\         `
12      \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
13          \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\      \
14             \\\\\\\\\\\\\\\\\\\\\     \\\\\\\\\\\\\\\\\      .
15                \\\\\\\\\\                     \\\\\\\\\\\
16                   \\        \\\wWWWWWWWww.          \\\\\\\    `
17                       \\ \\\WWW"""::::::""WWw         \\\\\    ,
18                  \  \\ \\wWWW" .,wWWWWWWw..  WWw.        \\\
19               ` ` \\\\\wWW"   W888888888888W  "WXX.       `\\
20                . `.\\wWW"   M88888i#####888"8M  "WWX.      `\`
21               \ \` wWWW"   M88888##d###"w8oo88M   WWMX.     `\
22                ` \wWWW"   :W88888####*  #88888M;   WWIZ.     ``
23            - -- wWWWW"     W88888####42##88888W     WWWXx .
24                / "WIZ       W8n889######98888W       WWXx.
25               ' '/"Wm,       W88888999988888W        >WWR" :
26                '   "WMm.      "WW88888888WW"        mmMM" '
27                      "Wmm.       "WWWWWW"        ,whAT?"
28                       ""MMMmm..            _,mMMMM"""
29                            ""MMMMMMMMMMMMMM""""    
30                            
31      PROPHET is a soft fork of Reflect (RFI) that incorporates adjustable
32      yield rates (so early early buyers can continue to earn reasonable yields as
33      more holders enter the ecosystem). PROPHET also has a deflationary supply 
34      and fair-launch mechanisms to ensure a healthy distribution of tokens. 
35  */
36 abstract contract Context {
37     function _msgSender() internal view virtual returns (address payable) {
38         return msg.sender;
39     }
40 
41     function _msgData() internal view virtual returns (bytes memory) {
42         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
43         return msg.data;
44     }
45 }
46 
47 
48 
49 /**
50  * @dev Interface of the ERC20 standard as defined in the EIP.
51  */
52 interface IERC20 {
53     /**
54      * @dev Returns the amount of tokens in existence.
55      */
56     function totalSupply() external view returns (uint256);
57 
58     /**
59      * @dev Returns the amount of tokens owned by `account`.
60      */
61     function balanceOf(address account) external view returns (uint256);
62 
63     /**
64      * @dev Moves `amount` tokens from the caller's account to `recipient`.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * Emits a {Transfer} event.
69      */
70     function transfer(address recipient, uint256 amount) external returns (bool);
71 
72     /**
73      * @dev Returns the remaining number of tokens that `spender` will be
74      * allowed to spend on behalf of `owner` through {transferFrom}. This is
75      * zero by default.
76      *
77      * This value changes when {approve} or {transferFrom} are called.
78      */
79     function allowance(address owner, address spender) external view returns (uint256);
80 
81     /**
82      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * IMPORTANT: Beware that changing an allowance with this method brings the risk
87      * that someone may use both the old and the new allowance by unfortunate
88      * transaction ordering. One possible solution to mitigate this race
89      * condition is to first reduce the spender's allowance to 0 and set the
90      * desired value afterwards:
91      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
92      *
93      * Emits an {Approval} event.
94      */
95     function approve(address spender, uint256 amount) external returns (bool);
96 
97     /**
98      * @dev Moves `amount` tokens from `sender` to `recipient` using the
99      * allowance mechanism. `amount` is then deducted from the caller's
100      * allowance.
101      *
102      * Returns a boolean value indicating whether the operation succeeded.
103      *
104      * Emits a {Transfer} event.
105      */
106     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
107 
108     /**
109      * @dev Emitted when `value` tokens are moved from one account (`from`) to
110      * another (`to`).
111      *
112      * Note that `value` may be zero.
113      */
114     event Transfer(address indexed from, address indexed to, uint256 value);
115 
116     /**
117      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
118      * a call to {approve}. `value` is the new allowance.
119      */
120     event Approval(address indexed owner, address indexed spender, uint256 value);
121 }
122 
123 
124 
125 /**
126  * @dev Wrappers over Solidity's arithmetic operations with added overflow
127  * checks.
128  *
129  * Arithmetic operations in Solidity wrap on overflow. This can easily result
130  * in bugs, because programmers usually assume that an overflow raises an
131  * error, which is the standard behavior in high level programming languages.
132  * `SafeMath` restores this intuition by reverting the transaction when an
133  * operation overflows.
134  *
135  * Using this library instead of the unchecked operations eliminates an entire
136  * class of bugs, so it's recommended to use it always.
137  */
138 library SafeMath {
139     /**
140      * @dev Returns the addition of two unsigned integers, reverting on
141      * overflow.
142      *
143      * Counterpart to Solidity's `+` operator.
144      *
145      * Requirements:
146      *
147      * - Addition cannot overflow.
148      */
149     function add(uint256 a, uint256 b) internal pure returns (uint256) {
150         uint256 c = a + b;
151         require(c >= a, "SafeMath: addition overflow");
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting on
158      * overflow (when the result is negative).
159      *
160      * Counterpart to Solidity's `-` operator.
161      *
162      * Requirements:
163      *
164      * - Subtraction cannot overflow.
165      */
166     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
167         return sub(a, b, "SafeMath: subtraction overflow");
168     }
169 
170     /**
171      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
172      * overflow (when the result is negative).
173      *
174      * Counterpart to Solidity's `-` operator.
175      *
176      * Requirements:
177      *
178      * - Subtraction cannot overflow.
179      */
180     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
181         require(b <= a, errorMessage);
182         uint256 c = a - b;
183 
184         return c;
185     }
186 
187     /**
188      * @dev Returns the multiplication of two unsigned integers, reverting on
189      * overflow.
190      *
191      * Counterpart to Solidity's `*` operator.
192      *
193      * Requirements:
194      *
195      * - Multiplication cannot overflow.
196      */
197     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
198         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
199         // benefit is lost if 'b' is also tested.
200         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
201         if (a == 0) {
202             return 0;
203         }
204 
205         uint256 c = a * b;
206         require(c / a == b, "SafeMath: multiplication overflow");
207 
208         return c;
209     }
210 
211     /**
212      * @dev Returns the integer division of two unsigned integers. Reverts on
213      * division by zero. The result is rounded towards zero.
214      *
215      * Counterpart to Solidity's `/` operator. Note: this function uses a
216      * `revert` opcode (which leaves remaining gas untouched) while Solidity
217      * uses an invalid opcode to revert (consuming all remaining gas).
218      *
219      * Requirements:
220      *
221      * - The divisor cannot be zero.
222      */
223     function div(uint256 a, uint256 b) internal pure returns (uint256) {
224         return div(a, b, "SafeMath: division by zero");
225     }
226 
227     /**
228      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
229      * division by zero. The result is rounded towards zero.
230      *
231      * Counterpart to Solidity's `/` operator. Note: this function uses a
232      * `revert` opcode (which leaves remaining gas untouched) while Solidity
233      * uses an invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      *
237      * - The divisor cannot be zero.
238      */
239     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
240         require(b > 0, errorMessage);
241         uint256 c = a / b;
242         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
243 
244         return c;
245     }
246 
247     /**
248      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
249      * Reverts when dividing by zero.
250      *
251      * Counterpart to Solidity's `%` operator. This function uses a `revert`
252      * opcode (which leaves remaining gas untouched) while Solidity uses an
253      * invalid opcode to revert (consuming all remaining gas).
254      *
255      * Requirements:
256      *
257      * - The divisor cannot be zero.
258      */
259     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
260         return mod(a, b, "SafeMath: modulo by zero");
261     }
262 
263     /**
264      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
265      * Reverts with custom message when dividing by zero.
266      *
267      * Counterpart to Solidity's `%` operator. This function uses a `revert`
268      * opcode (which leaves remaining gas untouched) while Solidity uses an
269      * invalid opcode to revert (consuming all remaining gas).
270      *
271      * Requirements:
272      *
273      * - The divisor cannot be zero.
274      */
275     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
276         require(b != 0, errorMessage);
277         return a % b;
278     }
279 }
280 
281 /**
282  * @dev Collection of functions related to the address type
283  */
284 library Address {
285     /**
286      * @dev Returns true if `account` is a contract.
287      *
288      * [IMPORTANT]
289      * ====
290      * It is unsafe to assume that an address for which this function returns
291      * false is an externally-owned account (EOA) and not a contract.
292      *
293      * Among others, `isContract` will return false for the following
294      * types of addresses:
295      *
296      *  - an externally-owned account
297      *  - a contract in construction
298      *  - an address where a contract will be created
299      *  - an address where a contract lived, but was destroyed
300      * ====
301      */
302     function isContract(address account) internal view returns (bool) {
303         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
304         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
305         // for accounts without code, i.e. `keccak256('')`
306         bytes32 codehash;
307         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
308         // solhint-disable-next-line no-inline-assembly
309         assembly { codehash := extcodehash(account) }
310         return (codehash != accountHash && codehash != 0x0);
311     }
312 
313     /**
314      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
315      * `recipient`, forwarding all available gas and reverting on errors.
316      *
317      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
318      * of certain opcodes, possibly making contracts go over the 2300 gas limit
319      * imposed by `transfer`, making them unable to receive funds via
320      * `transfer`. {sendValue} removes this limitation.
321      *
322      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
323      *
324      * IMPORTANT: because control is transferred to `recipient`, care must be
325      * taken to not create reentrancy vulnerabilities. Consider using
326      * {ReentrancyGuard} or the
327      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
328      */
329     function sendValue(address payable recipient, uint256 amount) internal {
330         require(address(this).balance >= amount, "Address: insufficient balance");
331 
332         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
333         (bool success, ) = recipient.call{ value: amount }("");
334         require(success, "Address: unable to send value, recipient may have reverted");
335     }
336 
337     /**
338      * @dev Performs a Solidity function call using a low level `call`. A
339      * plain`call` is an unsafe replacement for a function call: use this
340      * function instead.
341      *
342      * If `target` reverts with a revert reason, it is bubbled up by this
343      * function (like regular Solidity function calls).
344      *
345      * Returns the raw returned data. To convert to the expected return value,
346      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
347      *
348      * Requirements:
349      *
350      * - `target` must be a contract.
351      * - calling `target` with `data` must not revert.
352      *
353      * _Available since v3.1._
354      */
355     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
356       return functionCall(target, data, "Address: low-level call failed");
357     }
358 
359     /**
360      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
361      * `errorMessage` as a fallback revert reason when `target` reverts.
362      *
363      * _Available since v3.1._
364      */
365     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
366         return _functionCallWithValue(target, data, 0, errorMessage);
367     }
368 
369     /**
370      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
371      * but also transferring `value` wei to `target`.
372      *
373      * Requirements:
374      *
375      * - the calling contract must have an ETH balance of at least `value`.
376      * - the called Solidity function must be `payable`.
377      *
378      * _Available since v3.1._
379      */
380     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
381         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
386      * with `errorMessage` as a fallback revert reason when `target` reverts.
387      *
388      * _Available since v3.1._
389      */
390     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
391         require(address(this).balance >= value, "Address: insufficient balance for call");
392         return _functionCallWithValue(target, data, value, errorMessage);
393     }
394 
395     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
396         require(isContract(target), "Address: call to non-contract");
397 
398         // solhint-disable-next-line avoid-low-level-calls
399         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
400         if (success) {
401             return returndata;
402         } else {
403             // Look for revert reason and bubble it up if present
404             if (returndata.length > 0) {
405                 // The easiest way to bubble the revert reason is using memory via assembly
406 
407                 // solhint-disable-next-line no-inline-assembly
408                 assembly {
409                     let returndata_size := mload(returndata)
410                     revert(add(32, returndata), returndata_size)
411                 }
412             } else {
413                 revert(errorMessage);
414             }
415         }
416     }
417 }
418 
419 /**
420  * @dev Contract module which provides a basic access control mechanism, where
421  * there is an account (an owner) that can be granted exclusive access to
422  * specific functions.
423  *
424  * By default, the owner account will be the one that deploys the contract. This
425  * can later be changed with {transferOwnership}.
426  *
427  * This module is used through inheritance. It will make available the modifier
428  * `onlyOwner`, which can be applied to your functions to restrict their use to
429  * the owner.
430  */
431 contract Ownable is Context {
432     address private _owner;
433 
434     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
435 
436     /**
437      * @dev Initializes the contract setting the deployer as the initial owner.
438      */
439     constructor () internal {
440         address msgSender = _msgSender();
441         _owner = msgSender;
442         emit OwnershipTransferred(address(0), msgSender);
443     }
444 
445     /**
446      * @dev Returns the address of the current owner.
447      */
448     function owner() public view returns (address) {
449         return _owner;
450     }
451 
452     /**
453      * @dev Throws if called by any account other than the owner.
454      */
455     modifier onlyOwner() {
456         require(_owner == _msgSender(), "Ownable: caller is not the owner");
457         _;
458     }
459 
460     /**
461      * @dev Leaves the contract without owner. It will not be possible to call
462      * `onlyOwner` functions anymore. Can only be called by the current owner.
463      *
464      * NOTE: Renouncing ownership will leave the contract without an owner,
465      * thereby removing any functionality that is only available to the owner.
466      */
467     function renounceOwnership() public virtual onlyOwner {
468         emit OwnershipTransferred(_owner, address(0));
469         _owner = address(0);
470     }
471 
472     /**
473      * @dev Transfers ownership of the contract to a new account (`newOwner`).
474      * Can only be called by the current owner.
475      */
476     function transferOwnership(address newOwner) public virtual onlyOwner {
477         require(newOwner != address(0), "Ownable: new owner is the zero address");
478         emit OwnershipTransferred(_owner, newOwner);
479         _owner = newOwner;
480     }
481 }
482 
483 contract PROPHET is Context, IERC20, Ownable {
484     using SafeMath for uint256;
485     using Address for address;
486 
487     mapping (address => uint256) private _rOwned;
488     mapping (address => uint256) private _tOwned;
489     mapping (address => mapping (address => uint256)) private _allowances;
490 
491     mapping (address => bool) private _isExcluded;
492     address[] private _excluded;
493    
494     uint256 private constant MAX = ~uint256(0);
495     uint256 private _tTotal = 1 * 10**6 * 10**9;
496     uint256 private _rTotal = (MAX - (MAX % _tTotal));
497     uint256 private _tFeeTotal;
498     uint256 private _tBurnTotal;
499 
500     string private _name = 'prophet.finance';
501     string private _symbol = 'PROPHET';
502     uint8 private _decimals = 9;
503     
504     uint256 private _taxFee = 2;
505     uint256 private _burnFee = 1;
506     uint256 private _maxTxAmount = 9500e9;
507 
508     constructor () public {
509         _rOwned[_msgSender()] = _rTotal;
510         emit Transfer(address(0), _msgSender(), _tTotal);
511     }
512 
513     function name() public view returns (string memory) {
514         return _name;
515     }
516 
517     function symbol() public view returns (string memory) {
518         return _symbol;
519     }
520 
521     function decimals() public view returns (uint8) {
522         return _decimals;
523     }
524 
525     function totalSupply() public view override returns (uint256) {
526         return _tTotal;
527     }
528 
529     function balanceOf(address account) public view override returns (uint256) {
530         if (_isExcluded[account]) return _tOwned[account];
531         return tokenFromReflection(_rOwned[account]);
532     }
533 
534     function transfer(address recipient, uint256 amount) public override returns (bool) {
535         _transfer(_msgSender(), recipient, amount);
536         return true;
537     }
538 
539     function allowance(address owner, address spender) public view override returns (uint256) {
540         return _allowances[owner][spender];
541     }
542 
543     function approve(address spender, uint256 amount) public override returns (bool) {
544         _approve(_msgSender(), spender, amount);
545         return true;
546     }
547 
548     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
549         _transfer(sender, recipient, amount);
550         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
551         return true;
552     }
553 
554     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
555         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
556         return true;
557     }
558 
559     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
560         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
561         return true;
562     }
563 
564     function isExcluded(address account) public view returns (bool) {
565         return _isExcluded[account];
566     }
567 
568     function totalFees() public view returns (uint256) {
569         return _tFeeTotal;
570     }
571     
572     function totalBurn() public view returns (uint256) {
573         return _tBurnTotal;
574     }
575 
576     function deliver(uint256 tAmount) public {
577         address sender = _msgSender();
578         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
579         (uint256 rAmount,,,,,) = _getValues(tAmount);
580         _rOwned[sender] = _rOwned[sender].sub(rAmount);
581         _rTotal = _rTotal.sub(rAmount);
582         _tFeeTotal = _tFeeTotal.add(tAmount);
583     }
584 
585     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
586         require(tAmount <= _tTotal, "Amount must be less than supply");
587         if (!deductTransferFee) {
588             (uint256 rAmount,,,,,) = _getValues(tAmount);
589             return rAmount;
590         } else {
591             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
592             return rTransferAmount;
593         }
594     }
595 
596     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
597         require(rAmount <= _rTotal, "Amount must be less than total reflections");
598         uint256 currentRate =  _getRate();
599         return rAmount.div(currentRate);
600     }
601 
602     function excludeAccount(address account) external onlyOwner() {
603         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
604         require(!_isExcluded[account], "Account is already excluded");
605         if(_rOwned[account] > 0) {
606             _tOwned[account] = tokenFromReflection(_rOwned[account]);
607         }
608         _isExcluded[account] = true;
609         _excluded.push(account);
610     }
611 
612     function includeAccount(address account) external onlyOwner() {
613         require(_isExcluded[account], "Account is already excluded");
614         for (uint256 i = 0; i < _excluded.length; i++) {
615             if (_excluded[i] == account) {
616                 _excluded[i] = _excluded[_excluded.length - 1];
617                 _tOwned[account] = 0;
618                 _isExcluded[account] = false;
619                 _excluded.pop();
620                 break;
621             }
622         }
623     }
624 
625     function _approve(address owner, address spender, uint256 amount) private {
626         require(owner != address(0), "ERC20: approve from the zero address");
627         require(spender != address(0), "ERC20: approve to the zero address");
628 
629         _allowances[owner][spender] = amount;
630         emit Approval(owner, spender, amount);
631     }
632 
633     function _transfer(address sender, address recipient, uint256 amount) private {
634         require(sender != address(0), "ERC20: transfer from the zero address");
635         require(recipient != address(0), "ERC20: transfer to the zero address");
636         require(amount > 0, "Transfer amount must be greater than zero");
637         
638         if(sender != owner() && recipient != owner())
639             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
640         
641         if (_isExcluded[sender] && !_isExcluded[recipient]) {
642             _transferFromExcluded(sender, recipient, amount);
643         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
644             _transferToExcluded(sender, recipient, amount);
645         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
646             _transferStandard(sender, recipient, amount);
647         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
648             _transferBothExcluded(sender, recipient, amount);
649         } else {
650             _transferStandard(sender, recipient, amount);
651         }
652     }
653 
654     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
655         uint256 currentRate =  _getRate();
656         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
657         uint256 rBurn =  tBurn.mul(currentRate);
658         _rOwned[sender] = _rOwned[sender].sub(rAmount);
659         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
660         _reflectFee(rFee, rBurn, tFee, tBurn);
661         emit Transfer(sender, recipient, tTransferAmount);
662     }
663 
664     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
665         uint256 currentRate =  _getRate();
666         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
667         uint256 rBurn =  tBurn.mul(currentRate);
668         _rOwned[sender] = _rOwned[sender].sub(rAmount);
669         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
670         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
671         _reflectFee(rFee, rBurn, tFee, tBurn);
672         emit Transfer(sender, recipient, tTransferAmount);
673     }
674 
675     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
676         uint256 currentRate =  _getRate();
677         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
678         uint256 rBurn =  tBurn.mul(currentRate);
679         _tOwned[sender] = _tOwned[sender].sub(tAmount);
680         _rOwned[sender] = _rOwned[sender].sub(rAmount);
681         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
682         _reflectFee(rFee, rBurn, tFee, tBurn);
683         emit Transfer(sender, recipient, tTransferAmount);
684     }
685 
686     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
687         uint256 currentRate =  _getRate();
688         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
689         uint256 rBurn =  tBurn.mul(currentRate);
690         _tOwned[sender] = _tOwned[sender].sub(tAmount);
691         _rOwned[sender] = _rOwned[sender].sub(rAmount);
692         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
693         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
694         _reflectFee(rFee, rBurn, tFee, tBurn);
695         emit Transfer(sender, recipient, tTransferAmount);
696     }
697 
698     function _reflectFee(uint256 rFee, uint256 rBurn, uint256 tFee, uint256 tBurn) private {
699         _rTotal = _rTotal.sub(rFee).sub(rBurn);
700         _tFeeTotal = _tFeeTotal.add(tFee);
701         _tBurnTotal = _tBurnTotal.add(tBurn);
702         _tTotal = _tTotal.sub(tBurn);
703     }
704 
705     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
706         (uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getTValues(tAmount, _taxFee, _burnFee);
707         uint256 currentRate =  _getRate();
708         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tBurn, currentRate);
709         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBurn);
710     }
711 
712     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 burnFee) private pure returns (uint256, uint256, uint256) {
713         uint256 tFee = tAmount.mul(taxFee).div(100);
714         uint256 tBurn = tAmount.mul(burnFee).div(100);
715         uint256 tTransferAmount = tAmount.sub(tFee).sub(tBurn);
716         return (tTransferAmount, tFee, tBurn);
717     }
718 
719     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tBurn, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
720         uint256 rAmount = tAmount.mul(currentRate);
721         uint256 rFee = tFee.mul(currentRate);
722         uint256 rBurn = tBurn.mul(currentRate);
723         uint256 rTransferAmount = rAmount.sub(rFee).sub(rBurn);
724         return (rAmount, rTransferAmount, rFee);
725     }
726 
727     function _getRate() private view returns(uint256) {
728         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
729         return rSupply.div(tSupply);
730     }
731 
732     function _getCurrentSupply() private view returns(uint256, uint256) {
733         uint256 rSupply = _rTotal;
734         uint256 tSupply = _tTotal;      
735         for (uint256 i = 0; i < _excluded.length; i++) {
736             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
737             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
738             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
739         }
740         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
741         return (rSupply, tSupply);
742     }
743     
744     function _getTaxFee() private view returns(uint256) {
745         return _taxFee;
746     }
747 
748     function _getMaxTxAmount() private view returns(uint256) {
749         return _maxTxAmount;
750     }
751     
752     function _setTaxFee(uint256 taxFee) external onlyOwner() {
753         require(taxFee >= 1 && taxFee <= 10, 'taxFee should be in 1 - 10');
754         _taxFee = taxFee;
755     }
756     
757     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
758         require(maxTxAmount >= 9000e9 , 'maxTxAmount should be greater than 9000e9');
759         _maxTxAmount = maxTxAmount;
760     }
761 }