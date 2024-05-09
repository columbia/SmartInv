1 /*
2  * Copyright 2020 Forge Finance. ALL RIGHTS RESERVED.
3  *
4  * Forge Finance is an experimental fork of R34P with a 4% tax for each transaction (2% is re-distributed to existing FRG3 holders and 2% is permanently burned)
5  *
6  * Telegram: https://t.me/forgefinance
7  *           https://t.me/forgefinanceann
8  *
9  * Website: www.forgefinance.org
10  *
11  */
12 
13 // File: openzeppelin-solidity\contracts\GSN\Context.sol
14 
15 // SPDX-License-Identifier: MIT
16 
17 pragma solidity ^0.6.0;
18 
19 /*
20  * @dev Provides information about the current execution context, including the
21  * sender of the transaction and its data. While these are generally available
22  * via msg.sender and msg.data, they should not be accessed in such a direct
23  * manner, since when dealing with GSN meta-transactions the account sending and
24  * paying for execution may not be the actual sender (as far as an application
25  * is concerned).
26  *
27  * This contract is only required for intermediate, library-like contracts.
28  */
29 abstract contract Context {
30     function _msgSender() internal view virtual returns (address payable) {
31         return msg.sender;
32     }
33 
34     function _msgData() internal view virtual returns (bytes memory) {
35         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
36         return msg.data;
37     }
38 }
39 
40 // File: openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
41 
42 // SPDX-License-Identifier: MIT
43 
44 pragma solidity ^0.6.0;
45 
46 /**
47  * @dev Interface of the ERC20 standard as defined in the EIP.
48  */
49 interface IERC20 {
50     /**
51      * @dev Returns the amount of tokens in existence.
52      */
53     function totalSupply() external view returns (uint256);
54 
55     /**
56      * @dev Returns the amount of tokens owned by `account`.
57      */
58     function balanceOf(address account) external view returns (uint256);
59 
60     /**
61      * @dev Moves `amount` tokens from the caller's account to `recipient`.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transfer(address recipient, uint256 amount) external returns (bool);
68 
69     /**
70      * @dev Returns the remaining number of tokens that `spender` will be
71      * allowed to spend on behalf of `owner` through {transferFrom}. This is
72      * zero by default.
73      *
74      * This value changes when {approve} or {transferFrom} are called.
75      */
76     function allowance(address owner, address spender) external view returns (uint256);
77 
78     /**
79      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
80      *
81      * Returns a boolean value indicating whether the operation succeeded.
82      *
83      * IMPORTANT: Beware that changing an allowance with this method brings the risk
84      * that someone may use both the old and the new allowance by unfortunate
85      * transaction ordering. One possible solution to mitigate this race
86      * condition is to first reduce the spender's allowance to 0 and set the
87      * desired value afterwards:
88      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
89      *
90      * Emits an {Approval} event.
91      */
92     function approve(address spender, uint256 amount) external returns (bool);
93 
94     /**
95      * @dev Moves `amount` tokens from `sender` to `recipient` using the
96      * allowance mechanism. `amount` is then deducted from the caller's
97      * allowance.
98      *
99      * Returns a boolean value indicating whether the operation succeeded.
100      *
101      * Emits a {Transfer} event.
102      */
103     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
104 
105     /**
106      * @dev Emitted when `value` tokens are moved from one account (`from`) to
107      * another (`to`).
108      *
109      * Note that `value` may be zero.
110      */
111     event Transfer(address indexed from, address indexed to, uint256 value);
112 
113     /**
114      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
115      * a call to {approve}. `value` is the new allowance.
116      */
117     event Approval(address indexed owner, address indexed spender, uint256 value);
118 }
119 
120 // File: openzeppelin-solidity\contracts\math\SafeMath.sol
121 
122 // SPDX-License-Identifier: MIT
123 
124 pragma solidity ^0.6.0;
125 
126 /**
127  * @dev Wrappers over Solidity's arithmetic operations with added overflow
128  * checks.
129  *
130  * Arithmetic operations in Solidity wrap on overflow. This can easily result
131  * in bugs, because programmers usually assume that an overflow raises an
132  * error, which is the standard behavior in high level programming languages.
133  * `SafeMath` restores this intuition by reverting the transaction when an
134  * operation overflows.
135  *
136  * Using this library instead of the unchecked operations eliminates an entire
137  * class of bugs, so it's recommended to use it always.
138  */
139 library SafeMath {
140     /**
141      * @dev Returns the addition of two unsigned integers, reverting on
142      * overflow.
143      *
144      * Counterpart to Solidity's `+` operator.
145      *
146      * Requirements:
147      *
148      * - Addition cannot overflow.
149      */
150     function add(uint256 a, uint256 b) internal pure returns (uint256) {
151         uint256 c = a + b;
152         require(c >= a, "SafeMath: addition overflow");
153 
154         return c;
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting on
159      * overflow (when the result is negative).
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      *
165      * - Subtraction cannot overflow.
166      */
167     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
168         return sub(a, b, "SafeMath: subtraction overflow");
169     }
170 
171     /**
172      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
173      * overflow (when the result is negative).
174      *
175      * Counterpart to Solidity's `-` operator.
176      *
177      * Requirements:
178      *
179      * - Subtraction cannot overflow.
180      */
181     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
182         require(b <= a, errorMessage);
183         uint256 c = a - b;
184 
185         return c;
186     }
187 
188     /**
189      * @dev Returns the multiplication of two unsigned integers, reverting on
190      * overflow.
191      *
192      * Counterpart to Solidity's `*` operator.
193      *
194      * Requirements:
195      *
196      * - Multiplication cannot overflow.
197      */
198     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
199         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
200         // benefit is lost if 'b' is also tested.
201         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
202         if (a == 0) {
203             return 0;
204         }
205 
206         uint256 c = a * b;
207         require(c / a == b, "SafeMath: multiplication overflow");
208 
209         return c;
210     }
211 
212     /**
213      * @dev Returns the integer division of two unsigned integers. Reverts on
214      * division by zero. The result is rounded towards zero.
215      *
216      * Counterpart to Solidity's `/` operator. Note: this function uses a
217      * `revert` opcode (which leaves remaining gas untouched) while Solidity
218      * uses an invalid opcode to revert (consuming all remaining gas).
219      *
220      * Requirements:
221      *
222      * - The divisor cannot be zero.
223      */
224     function div(uint256 a, uint256 b) internal pure returns (uint256) {
225         return div(a, b, "SafeMath: division by zero");
226     }
227 
228     /**
229      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
230      * division by zero. The result is rounded towards zero.
231      *
232      * Counterpart to Solidity's `/` operator. Note: this function uses a
233      * `revert` opcode (which leaves remaining gas untouched) while Solidity
234      * uses an invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      *
238      * - The divisor cannot be zero.
239      */
240     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
241         require(b > 0, errorMessage);
242         uint256 c = a / b;
243         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
244 
245         return c;
246     }
247 
248     /**
249      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
250      * Reverts when dividing by zero.
251      *
252      * Counterpart to Solidity's `%` operator. This function uses a `revert`
253      * opcode (which leaves remaining gas untouched) while Solidity uses an
254      * invalid opcode to revert (consuming all remaining gas).
255      *
256      * Requirements:
257      *
258      * - The divisor cannot be zero.
259      */
260     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
261         return mod(a, b, "SafeMath: modulo by zero");
262     }
263 
264     /**
265      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
266      * Reverts with custom message when dividing by zero.
267      *
268      * Counterpart to Solidity's `%` operator. This function uses a `revert`
269      * opcode (which leaves remaining gas untouched) while Solidity uses an
270      * invalid opcode to revert (consuming all remaining gas).
271      *
272      * Requirements:
273      *
274      * - The divisor cannot be zero.
275      */
276     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
277         require(b != 0, errorMessage);
278         return a % b;
279     }
280 }
281 
282 // File: openzeppelin-solidity\contracts\utils\Address.sol
283 
284 // SPDX-License-Identifier: MIT
285 
286 pragma solidity ^0.6.2;
287 
288 /**
289  * @dev Collection of functions related to the address type
290  */
291 library Address {
292     /**
293      * @dev Returns true if `account` is a contract.
294      *
295      * [IMPORTANT]
296      * ====
297      * It is unsafe to assume that an address for which this function returns
298      * false is an externally-owned account (EOA) and not a contract.
299      *
300      * Among others, `isContract` will return false for the following
301      * types of addresses:
302      *
303      *  - an externally-owned account
304      *  - a contract in construction
305      *  - an address where a contract will be created
306      *  - an address where a contract lived, but was destroyed
307      * ====
308      */
309     function isContract(address account) internal view returns (bool) {
310         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
311         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
312         // for accounts without code, i.e. `keccak256('')`
313         bytes32 codehash;
314         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
315         // solhint-disable-next-line no-inline-assembly
316         assembly { codehash := extcodehash(account) }
317         return (codehash != accountHash && codehash != 0x0);
318     }
319 
320     /**
321      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
322      * `recipient`, forwarding all available gas and reverting on errors.
323      *
324      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
325      * of certain opcodes, possibly making contracts go over the 2300 gas limit
326      * imposed by `transfer`, making them unable to receive funds via
327      * `transfer`. {sendValue} removes this limitation.
328      *
329      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
330      *
331      * IMPORTANT: because control is transferred to `recipient`, care must be
332      * taken to not create reentrancy vulnerabilities. Consider using
333      * {ReentrancyGuard} or the
334      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
335      */
336     function sendValue(address payable recipient, uint256 amount) internal {
337         require(address(this).balance >= amount, "Address: insufficient balance");
338 
339         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
340         (bool success, ) = recipient.call{ value: amount }("");
341         require(success, "Address: unable to send value, recipient may have reverted");
342     }
343 
344     /**
345      * @dev Performs a Solidity function call using a low level `call`. A
346      * plain`call` is an unsafe replacement for a function call: use this
347      * function instead.
348      *
349      * If `target` reverts with a revert reason, it is bubbled up by this
350      * function (like regular Solidity function calls).
351      *
352      * Returns the raw returned data. To convert to the expected return value,
353      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
354      *
355      * Requirements:
356      *
357      * - `target` must be a contract.
358      * - calling `target` with `data` must not revert.
359      *
360      * _Available since v3.1._
361      */
362     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
363       return functionCall(target, data, "Address: low-level call failed");
364     }
365 
366     /**
367      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
368      * `errorMessage` as a fallback revert reason when `target` reverts.
369      *
370      * _Available since v3.1._
371      */
372     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
373         return _functionCallWithValue(target, data, 0, errorMessage);
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
378      * but also transferring `value` wei to `target`.
379      *
380      * Requirements:
381      *
382      * - the calling contract must have an ETH balance of at least `value`.
383      * - the called Solidity function must be `payable`.
384      *
385      * _Available since v3.1._
386      */
387     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
388         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
389     }
390 
391     /**
392      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
393      * with `errorMessage` as a fallback revert reason when `target` reverts.
394      *
395      * _Available since v3.1._
396      */
397     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
398         require(address(this).balance >= value, "Address: insufficient balance for call");
399         return _functionCallWithValue(target, data, value, errorMessage);
400     }
401 
402     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
403         require(isContract(target), "Address: call to non-contract");
404 
405         // solhint-disable-next-line avoid-low-level-calls
406         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
407         if (success) {
408             return returndata;
409         } else {
410             // Look for revert reason and bubble it up if present
411             if (returndata.length > 0) {
412                 // The easiest way to bubble the revert reason is using memory via assembly
413 
414                 // solhint-disable-next-line no-inline-assembly
415                 assembly {
416                     let returndata_size := mload(returndata)
417                     revert(add(32, returndata), returndata_size)
418                 }
419             } else {
420                 revert(errorMessage);
421             }
422         }
423     }
424 }
425 
426 // File: openzeppelin-solidity\contracts\access\Ownable.sol
427 
428 // SPDX-License-Identifier: MIT
429 
430 pragma solidity ^0.6.0;
431 
432 /**
433  * @dev Contract module which provides a basic access control mechanism, where
434  * there is an account (an owner) that can be granted exclusive access to
435  * specific functions.
436  *
437  * By default, the owner account will be the one that deploys the contract. This
438  * can later be changed with {transferOwnership}.
439  *
440  * This module is used through inheritance. It will make available the modifier
441  * `onlyOwner`, which can be applied to your functions to restrict their use to
442  * the owner.
443  */
444 contract Ownable is Context {
445     address private _owner;
446 
447     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
448 
449     /**
450      * @dev Initializes the contract setting the deployer as the initial owner.
451      */
452     constructor () internal {
453         address msgSender = _msgSender();
454         _owner = msgSender;
455         emit OwnershipTransferred(address(0), msgSender);
456     }
457 
458     /**
459      * @dev Returns the address of the current owner.
460      */
461     function owner() public view returns (address) {
462         return _owner;
463     }
464 
465     /**
466      * @dev Throws if called by any account other than the owner.
467      */
468     modifier onlyOwner() {
469         require(_owner == _msgSender(), "Ownable: caller is not the owner");
470         _;
471     }
472 
473     /**
474      * @dev Leaves the contract without owner. It will not be possible to call
475      * `onlyOwner` functions anymore. Can only be called by the current owner.
476      *
477      * NOTE: Renouncing ownership will leave the contract without an owner,
478      * thereby removing any functionality that is only available to the owner.
479      */
480     function renounceOwnership() public virtual onlyOwner {
481         emit OwnershipTransferred(_owner, address(0));
482         _owner = address(0);
483     }
484 
485     /**
486      * @dev Transfers ownership of the contract to a new account (`newOwner`).
487      * Can only be called by the current owner.
488      */
489     function transferOwnership(address newOwner) public virtual onlyOwner {
490         require(newOwner != address(0), "Ownable: new owner is the zero address");
491         emit OwnershipTransferred(_owner, newOwner);
492         _owner = newOwner;
493     }
494 }
495 
496 
497 
498 /*
499  * Copyright 2020 Forge Finance. ALL RIGHTS RESERVED.
500  *
501  * Forge Finance is an experimental fork of R34P with a 4% tax for each transaction (2% is re-distributed to existing FRG3 holders and 2% is permanently burned)
502  *
503  * Telegram: https://t.me/forgefinance
504  *           https://t.me/forgefinanceann
505  *
506  * Website: www.forgefinance.org
507  *
508  */
509 
510 pragma solidity ^0.6.2;
511 
512 
513 
514 contract FORGEToken is Context, IERC20, Ownable {
515     using SafeMath for uint256;
516     using Address for address;
517 
518     mapping (address => uint256) private _rOwned;
519     mapping (address => uint256) private _tOwned;
520     mapping (address => mapping (address => uint256)) private _allowances;
521 
522     mapping (address => bool) private _isExcluded;
523     address[] private _excluded;
524    
525     uint256 private constant MAX = ~uint256(0);
526     uint256 private _tTotal = 100000 * 10**18;
527     uint256 private _rTotal = (MAX - (MAX % _tTotal));
528     uint256 private _tFeeTotal;
529     uint256 private _tBurnTotal;
530 
531     string private _name = 'Forge Finance';
532     string private _symbol = 'FRG3';
533     uint8 private _decimals = 18;
534     
535     uint256 private _taxFee = 2;
536     uint256 private _burnFee = 2;
537     uint256 private _maxTxAmount = 2500e18;
538 
539     constructor () public {
540         _rOwned[_msgSender()] = _rTotal;
541         emit Transfer(address(0), _msgSender(), _tTotal);
542     }
543 
544     function name() public view returns (string memory) {
545         return _name;
546     }
547 
548     function symbol() public view returns (string memory) {
549         return _symbol;
550     }
551 
552     function decimals() public view returns (uint8) {
553         return _decimals;
554     }
555 
556     function totalSupply() public view override returns (uint256) {
557         return _tTotal;
558     }
559 
560     function balanceOf(address account) public view override returns (uint256) {
561         if (_isExcluded[account]) return _tOwned[account];
562         return tokenFromReflection(_rOwned[account]);
563     }
564 
565     function transfer(address recipient, uint256 amount) public override returns (bool) {
566         _transfer(_msgSender(), recipient, amount);
567         return true;
568     }
569 
570     function allowance(address owner, address spender) public view override returns (uint256) {
571         return _allowances[owner][spender];
572     }
573 
574     function approve(address spender, uint256 amount) public override returns (bool) {
575         _approve(_msgSender(), spender, amount);
576         return true;
577     }
578 
579     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
580         _transfer(sender, recipient, amount);
581         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
582         return true;
583     }
584 
585     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
586         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
587         return true;
588     }
589 
590     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
591         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
592         return true;
593     }
594 
595     function isExcluded(address account) public view returns (bool) {
596         return _isExcluded[account];
597     }
598 
599     function totalFees() public view returns (uint256) {
600         return _tFeeTotal;
601     }
602     
603     function totalBurn() public view returns (uint256) {
604         return _tBurnTotal;
605     }
606 
607     function deliver(uint256 tAmount) public {
608         address sender = _msgSender();
609         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
610         (uint256 rAmount,,,,,) = _getValues(tAmount);
611         _rOwned[sender] = _rOwned[sender].sub(rAmount);
612         _rTotal = _rTotal.sub(rAmount);
613         _tFeeTotal = _tFeeTotal.add(tAmount);
614     }
615 
616     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
617         require(tAmount <= _tTotal, "Amount must be less than supply");
618         if (!deductTransferFee) {
619             (uint256 rAmount,,,,,) = _getValues(tAmount);
620             return rAmount;
621         } else {
622             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
623             return rTransferAmount;
624         }
625     }
626 
627     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
628         require(rAmount <= _rTotal, "Amount must be less than total reflections");
629         uint256 currentRate =  _getRate();
630         return rAmount.div(currentRate);
631     }
632 
633     function excludeAccount(address account) external onlyOwner() {
634         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
635         require(!_isExcluded[account], "Account is already excluded");
636         if(_rOwned[account] > 0) {
637             _tOwned[account] = tokenFromReflection(_rOwned[account]);
638         }
639         _isExcluded[account] = true;
640         _excluded.push(account);
641     }
642 
643     function includeAccount(address account) external onlyOwner() {
644         require(_isExcluded[account], "Account is already excluded");
645         for (uint256 i = 0; i < _excluded.length; i++) {
646             if (_excluded[i] == account) {
647                 _excluded[i] = _excluded[_excluded.length - 1];
648                 _tOwned[account] = 0;
649                 _isExcluded[account] = false;
650                 _excluded.pop();
651                 break;
652             }
653         }
654     }
655 
656     function _approve(address owner, address spender, uint256 amount) private {
657         require(owner != address(0), "ERC20: approve from the zero address");
658         require(spender != address(0), "ERC20: approve to the zero address");
659 
660         _allowances[owner][spender] = amount;
661         emit Approval(owner, spender, amount);
662     }
663 
664     function _transfer(address sender, address recipient, uint256 amount) private {
665         require(sender != address(0), "ERC20: transfer from the zero address");
666         require(recipient != address(0), "ERC20: transfer to the zero address");
667         require(amount > 0, "Transfer amount must be greater than zero");
668         
669         if(sender != owner() && recipient != owner())
670             require(amount <= _maxTxAmount, "Transfer amount exceeds the maxTxAmount.");
671         
672         if (_isExcluded[sender] && !_isExcluded[recipient]) {
673             _transferFromExcluded(sender, recipient, amount);
674         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
675             _transferToExcluded(sender, recipient, amount);
676         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
677             _transferStandard(sender, recipient, amount);
678         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
679             _transferBothExcluded(sender, recipient, amount);
680         } else {
681             _transferStandard(sender, recipient, amount);
682         }
683     }
684 
685     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
686         uint256 currentRate =  _getRate();
687         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
688         uint256 rBurn =  tBurn.mul(currentRate);
689         _rOwned[sender] = _rOwned[sender].sub(rAmount);
690         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
691         _reflectFee(rFee, rBurn, tFee, tBurn);
692         emit Transfer(sender, recipient, tTransferAmount);
693     }
694 
695     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
696         uint256 currentRate =  _getRate();
697         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
698         uint256 rBurn =  tBurn.mul(currentRate);
699         _rOwned[sender] = _rOwned[sender].sub(rAmount);
700         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
701         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
702         _reflectFee(rFee, rBurn, tFee, tBurn);
703         emit Transfer(sender, recipient, tTransferAmount);
704     }
705 
706     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
707         uint256 currentRate =  _getRate();
708         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
709         uint256 rBurn =  tBurn.mul(currentRate);
710         _tOwned[sender] = _tOwned[sender].sub(tAmount);
711         _rOwned[sender] = _rOwned[sender].sub(rAmount);
712         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
713         _reflectFee(rFee, rBurn, tFee, tBurn);
714         emit Transfer(sender, recipient, tTransferAmount);
715     }
716 
717     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
718         uint256 currentRate =  _getRate();
719         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
720         uint256 rBurn =  tBurn.mul(currentRate);
721         _tOwned[sender] = _tOwned[sender].sub(tAmount);
722         _rOwned[sender] = _rOwned[sender].sub(rAmount);
723         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
724         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
725         _reflectFee(rFee, rBurn, tFee, tBurn);
726         emit Transfer(sender, recipient, tTransferAmount);
727     }
728 
729     function _reflectFee(uint256 rFee, uint256 rBurn, uint256 tFee, uint256 tBurn) private {
730         _rTotal = _rTotal.sub(rFee).sub(rBurn);
731         _tFeeTotal = _tFeeTotal.add(tFee);
732         _tBurnTotal = _tBurnTotal.add(tBurn);
733         _tTotal = _tTotal.sub(tBurn);
734     }
735 
736     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
737         (uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getTValues(tAmount, _taxFee, _burnFee);
738         uint256 currentRate =  _getRate();
739         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tBurn, currentRate);
740         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBurn);
741     }
742 
743     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 burnFee) private pure returns (uint256, uint256, uint256) {
744         uint256 tFee = tAmount.mul(taxFee).div(100);
745         uint256 tBurn = tAmount.mul(burnFee).div(100);
746         uint256 tTransferAmount = tAmount.sub(tFee).sub(tBurn);
747         return (tTransferAmount, tFee, tBurn);
748     }
749 
750     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tBurn, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
751         uint256 rAmount = tAmount.mul(currentRate);
752         uint256 rFee = tFee.mul(currentRate);
753         uint256 rBurn = tBurn.mul(currentRate);
754         uint256 rTransferAmount = rAmount.sub(rFee).sub(rBurn);
755         return (rAmount, rTransferAmount, rFee);
756     }
757 
758     function _getRate() private view returns(uint256) {
759         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
760         return rSupply.div(tSupply);
761     }
762 
763     function _getCurrentSupply() private view returns(uint256, uint256) {
764         uint256 rSupply = _rTotal;
765         uint256 tSupply = _tTotal;      
766         for (uint256 i = 0; i < _excluded.length; i++) {
767             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
768             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
769             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
770         }
771         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
772         return (rSupply, tSupply);
773     }
774     
775     function _getTaxFee() private view returns(uint256) {
776         return _taxFee;
777     }
778 
779     function _getMaxTxAmount() private view returns(uint256) {
780         return _maxTxAmount;
781     }
782     
783     function _setTaxFee(uint256 taxFee) external onlyOwner() {
784         require(taxFee >= 1 && taxFee <= 10, 'taxFee should be in 1 - 10');
785         _taxFee = taxFee;
786     }
787     
788     function _setMaxTxAmount(uint256 maxTxAmount) external onlyOwner() {
789         require(maxTxAmount >= 9000e9 , 'maxTxAmount should be greater than 9000e9');
790         _maxTxAmount = maxTxAmount;
791     }
792 }