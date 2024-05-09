1 /**
2 
3   _________.____     ________ ___________ ___ ___      ___________________    ____  __.    
4 ░██████╗██╗░░░░░░█████╗░████████╗██╗░░██╗  ████████╗░█████╗░██╗░░██╗███████╗███╗░░██╗
5 ██╔════╝██║░░░░░██╔══██╗╚══██╔══╝██║░░██║  ╚══██╔══╝██╔══██╗██║░██╔╝██╔════╝████╗░██║
6 ╚█████╗░██║░░░░░██║░░██║░░░██║░░░███████║  ░░░██║░░░██║░░██║█████═╝░█████╗░░██╔██╗██║
7 ░╚═══██╗██║░░░░░██║░░██║░░░██║░░░██╔══██║  ░░░██║░░░██║░░██║██╔═██╗░██╔══╝░░██║╚████║
8 ██████╔╝███████╗╚█████╔╝░░░██║░░░██║░░██║  ░░░██║░░░╚█████╔╝██║░╚██╗███████╗██║░╚███║
9 ╚═════╝░╚══════╝░╚════╝░░░░╚═╝░░░╚═╝░░╚═╝  ░░░╚═╝░░░░╚════╝░╚═╝░░╚═╝╚══════╝╚═╝░░╚══╝
10 
11 
12 
13 ████████████████████████████████████████████████████████████████████████████████
14 █▄─▄─▀█▄─▄▄─█─▄▄▄▄█─▄─▄─███▄─▀█▀─▄█▄─▄▄─█▄─▀█▀─▄█▄─▄▄─███─▄▄▄─█─▄▄─█▄─▄█▄─▀█▄─▄█
15 ██─▄─▀██─▄█▀█▄▄▄▄─███─██████─█▄█─███─▄█▀██─█▄█─███─▄█▀███─███▀█─██─██─███─█▄▀─██
16 ▀▄▄▄▄▀▀▄▄▄▄▄▀▄▄▄▄▄▀▀▄▄▄▀▀▀▀▄▄▄▀▄▄▄▀▄▄▄▄▄▀▄▄▄▀▄▄▄▀▄▄▄▄▄▀▀▀▄▄▄▄▄▀▄▄▄▄▀▄▄▄▀▄▄▄▀▀▄▄▀
17 
18 
19 // SLOTHTOKEN: $SLOTH is ERC-20 MEME COIN 
20 
21 it was made for lazy people who didn't want to do stake and farm.
22 Only Hodl and earn 2% fee from transactions
23 
24 
25 pragma solidity ^0.6.0;
26 
27 /*
28  * @dev Provides information about the current execution context, including the
29  * sender of the transaction and its data. While these are generally available
30  * via msg.sender and msg.data, they should not be accessed in such a direct
31  * manner, since when dealing with GSN meta-transactions the account sending and
32  * paying for execution may not be the actual sender (as far as an application
33  * is concerned).
34  *
35  * This contract is only required for intermediate, library-like contracts.
36  */
37 abstract contract Context {
38     function _msgSender() internal view virtual returns (address payable) {
39         return msg.sender;
40     }
41 
42     function _msgData() internal view virtual returns (bytes memory) {
43         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
44         return msg.data;
45     }
46 }
47 
48 // File: openzeppelin-solidity\contracts\token\ERC20\IERC20.sol
49 
50 // SPDX-License-Identifier: MIT
51 
52 pragma solidity ^0.6.0;
53 
54 /**
55  * @dev Interface of the ERC20 standard as defined in the EIP.
56  */
57 interface IERC20 {
58     /**
59      * @dev Returns the amount of tokens in existence.
60      */
61     function totalSupply() external view returns (uint256);
62 
63     /**
64      * @dev Returns the amount of tokens owned by `account`.
65      */
66     function balanceOf(address account) external view returns (uint256);
67 
68     /**
69      * @dev Moves `amount` tokens from the caller's account to `recipient`.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * Emits a {Transfer} event.
74      */
75     function transfer(address recipient, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Returns the remaining number of tokens that `spender` will be
79      * allowed to spend on behalf of `owner` through {transferFrom}. This is
80      * zero by default.
81      *
82      * This value changes when {approve} or {transferFrom} are called.
83      */
84     function allowance(address owner, address spender) external view returns (uint256);
85 
86     /**
87      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * IMPORTANT: Beware that changing an allowance with this method brings the risk
92      * that someone may use both the old and the new allowance by unfortunate
93      * transaction ordering. One possible solution to mitigate this race
94      * condition is to first reduce the spender's allowance to 0 and set the
95      * desired value afterwards:
96      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
97      *
98      * Emits an {Approval} event.
99      */
100     function approve(address spender, uint256 amount) external returns (bool);
101 
102     /**
103      * @dev Moves `amount` tokens from `sender` to `recipient` using the
104      * allowance mechanism. `amount` is then deducted from the caller's
105      * allowance.
106      *
107      * Returns a boolean value indicating whether the operation succeeded.
108      *
109      * Emits a {Transfer} event.
110      */
111     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
112 
113     /**
114      * @dev Emitted when `value` tokens are moved from one account (`from`) to
115      * another (`to`).
116      *
117      * Note that `value` may be zero.
118      */
119     event Transfer(address indexed from, address indexed to, uint256 value);
120 
121     /**
122      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
123      * a call to {approve}. `value` is the new allowance.
124      */
125     event Approval(address indexed owner, address indexed spender, uint256 value);
126 }
127 
128 // File: openzeppelin-solidity\contracts\math\SafeMath.sol
129 
130 // SPDX-License-Identifier: MIT
131 
132 pragma solidity ^0.6.0;
133 
134 /**
135  * @dev Wrappers over Solidity's arithmetic operations with added overflow
136  * checks.
137  *
138  * Arithmetic operations in Solidity wrap on overflow. This can easily result
139  * in bugs, because programmers usually assume that an overflow raises an
140  * error, which is the standard behavior in high level programming languages.
141  * `SafeMath` restores this intuition by reverting the transaction when an
142  * operation overflows.
143  *
144  * Using this library instead of the unchecked operations eliminates an entire
145  * class of bugs, so it's recommended to use it always.
146  */
147 library SafeMath {
148     /**
149      * @dev Returns the addition of two unsigned integers, reverting on
150      * overflow.
151      *
152      * Counterpart to Solidity's `+` operator.
153      *
154      * Requirements:
155      *
156      * - Addition cannot overflow.
157      */
158     function add(uint256 a, uint256 b) internal pure returns (uint256) {
159         uint256 c = a + b;
160         require(c >= a, "SafeMath: addition overflow");
161 
162         return c;
163     }
164 
165     /**
166      * @dev Returns the subtraction of two unsigned integers, reverting on
167      * overflow (when the result is negative).
168      *
169      * Counterpart to Solidity's `-` operator.
170      *
171      * Requirements:
172      *
173      * - Subtraction cannot overflow.
174      */
175     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
176         return sub(a, b, "SafeMath: subtraction overflow");
177     }
178 
179     /**
180      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
181      * overflow (when the result is negative).
182      *
183      * Counterpart to Solidity's `-` operator.
184      *
185      * Requirements:
186      *
187      * - Subtraction cannot overflow.
188      */
189     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
190         require(b <= a, errorMessage);
191         uint256 c = a - b;
192 
193         return c;
194     }
195 
196     /**
197      * @dev Returns the multiplication of two unsigned integers, reverting on
198      * overflow.
199      *
200      * Counterpart to Solidity's `*` operator.
201      *
202      * Requirements:
203      *
204      * - Multiplication cannot overflow.
205      */
206     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
207         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
208         // benefit is lost if 'b' is also tested.
209         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
210         if (a == 0) {
211             return 0;
212         }
213 
214         uint256 c = a * b;
215         require(c / a == b, "SafeMath: multiplication overflow");
216 
217         return c;
218     }
219 
220     /**
221      * @dev Returns the integer division of two unsigned integers. Reverts on
222      * division by zero. The result is rounded towards zero.
223      *
224      * Counterpart to Solidity's `/` operator. Note: this function uses a
225      * `revert` opcode (which leaves remaining gas untouched) while Solidity
226      * uses an invalid opcode to revert (consuming all remaining gas).
227      *
228      * Requirements:
229      *
230      * - The divisor cannot be zero.
231      */
232     function div(uint256 a, uint256 b) internal pure returns (uint256) {
233         return div(a, b, "SafeMath: division by zero");
234     }
235 
236     /**
237      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
238      * division by zero. The result is rounded towards zero.
239      *
240      * Counterpart to Solidity's `/` operator. Note: this function uses a
241      * `revert` opcode (which leaves remaining gas untouched) while Solidity
242      * uses an invalid opcode to revert (consuming all remaining gas).
243      *
244      * Requirements:
245      *
246      * - The divisor cannot be zero.
247      */
248     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
249         require(b > 0, errorMessage);
250         uint256 c = a / b;
251         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
252 
253         return c;
254     }
255 
256     /**
257      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
258      * Reverts when dividing by zero.
259      *
260      * Counterpart to Solidity's `%` operator. This function uses a `revert`
261      * opcode (which leaves remaining gas untouched) while Solidity uses an
262      * invalid opcode to revert (consuming all remaining gas).
263      *
264      * Requirements:
265      *
266      * - The divisor cannot be zero.
267      */
268     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
269         return mod(a, b, "SafeMath: modulo by zero");
270     }
271 
272     /**
273      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
274      * Reverts with custom message when dividing by zero.
275      *
276      * Counterpart to Solidity's `%` operator. This function uses a `revert`
277      * opcode (which leaves remaining gas untouched) while Solidity uses an
278      * invalid opcode to revert (consuming all remaining gas).
279      *
280      * Requirements:
281      *
282      * - The divisor cannot be zero.
283      */
284     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
285         require(b != 0, errorMessage);
286         return a % b;
287     }
288 }
289 
290 // File: openzeppelin-solidity\contracts\utils\Address.sol
291 
292 // SPDX-License-Identifier: MIT
293 
294 pragma solidity ^0.6.2;
295 
296 /**
297  * @dev Collection of functions related to the address type
298  */
299 library Address {
300     /**
301      * @dev Returns true if `account` is a contract.
302      *
303      * [IMPORTANT]
304      * ====
305      * It is unsafe to assume that an address for which this function returns
306      * false is an externally-owned account (EOA) and not a contract.
307      *
308      * Among others, `isContract` will return false for the following
309      * types of addresses:
310      *
311      *  - an externally-owned account
312      *  - a contract in construction
313      *  - an address where a contract will be created
314      *  - an address where a contract lived, but was destroyed
315      * ====
316      */
317     function isContract(address account) internal view returns (bool) {
318         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
319         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
320         // for accounts without code, i.e. `keccak256('')`
321         bytes32 codehash;
322         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
323         // solhint-disable-next-line no-inline-assembly
324         assembly { codehash := extcodehash(account) }
325         return (codehash != accountHash && codehash != 0x0);
326     }
327 
328     /**
329      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
330      * `recipient`, forwarding all available gas and reverting on errors.
331      *
332      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
333      * of certain opcodes, possibly making contracts go over the 2300 gas limit
334      * imposed by `transfer`, making them unable to receive funds via
335      * `transfer`. {sendValue} removes this limitation.
336      *
337      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
338      *
339      * IMPORTANT: because control is transferred to `recipient`, care must be
340      * taken to not create reentrancy vulnerabilities. Consider using
341      * {ReentrancyGuard} or the
342      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
343      */
344     function sendValue(address payable recipient, uint256 amount) internal {
345         require(address(this).balance >= amount, "Address: insufficient balance");
346 
347         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
348         (bool success, ) = recipient.call{ value: amount }("");
349         require(success, "Address: unable to send value, recipient may have reverted");
350     }
351 
352     /**
353      * @dev Performs a Solidity function call using a low level `call`. A
354      * plain`call` is an unsafe replacement for a function call: use this
355      * function instead.
356      *
357      * If `target` reverts with a revert reason, it is bubbled up by this
358      * function (like regular Solidity function calls).
359      *
360      * Returns the raw returned data. To convert to the expected return value,
361      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
362      *
363      * Requirements:
364      *
365      * - `target` must be a contract.
366      * - calling `target` with `data` must not revert.
367      *
368      * _Available since v3.1._
369      */
370     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
371         return functionCall(target, data, "Address: low-level call failed");
372     }
373 
374     /**
375      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
376      * `errorMessage` as a fallback revert reason when `target` reverts.
377      *
378      * _Available since v3.1._
379      */
380     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
381         return _functionCallWithValue(target, data, 0, errorMessage);
382     }
383 
384     /**
385      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
386      * but also transferring `value` wei to `target`.
387      *
388      * Requirements:
389      *
390      * - the calling contract must have an ETH balance of at least `value`.
391      * - the called Solidity function must be `payable`.
392      *
393      * _Available since v3.1._
394      */
395     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
396         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
397     }
398 
399     /**
400      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
401      * with `errorMessage` as a fallback revert reason when `target` reverts.
402      *
403      * _Available since v3.1._
404      */
405     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
406         require(address(this).balance >= value, "Address: insufficient balance for call");
407         return _functionCallWithValue(target, data, value, errorMessage);
408     }
409 
410     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
411         require(isContract(target), "Address: call to non-contract");
412 
413         // solhint-disable-next-line avoid-low-level-calls
414         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
415         if (success) {
416             return returndata;
417         } else {
418             // Look for revert reason and bubble it up if present
419             if (returndata.length > 0) {
420                 // The easiest way to bubble the revert reason is using memory via assembly
421 
422                 // solhint-disable-next-line no-inline-assembly
423                 assembly {
424                     let returndata_size := mload(returndata)
425                     revert(add(32, returndata), returndata_size)
426                 }
427             } else {
428                 revert(errorMessage);
429             }
430         }
431     }
432 }
433 
434 // File: openzeppelin-solidity\contracts\access\Ownable.sol
435 
436 // SPDX-License-Identifier: MIT
437 
438 pragma solidity ^0.6.0;
439 
440 /**
441  * @dev Contract module which provides a basic access control mechanism, where
442  * there is an account (an owner) that can be granted exclusive access to
443  * specific functions.
444  *
445  * By default, the owner account will be the one that deploys the contract. This
446  * can later be changed with {transferOwnership}.
447  *
448  * This module is used through inheritance. It will make available the modifier
449  * `onlyOwner`, which can be applied to your functions to restrict their use to
450  * the owner.
451  */
452 contract Ownable is Context {
453     address private _owner;
454 
455     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
456 
457     /**
458      * @dev Initializes the contract setting the deployer as the initial owner.
459      */
460     constructor () internal {
461         address msgSender = _msgSender();
462         _owner = msgSender;
463         emit OwnershipTransferred(address(0), msgSender);
464     }
465 
466     /**
467      * @dev Returns the address of the current owner.
468      */
469     function owner() public view returns (address) {
470         return _owner;
471     }
472 
473     /**
474      * @dev Throws if called by any account other than the owner.
475      */
476     modifier onlyOwner() {
477         require(_owner == _msgSender(), "Ownable: caller is not the owner");
478         _;
479     }
480 
481     /**
482      * @dev Leaves the contract without owner. It will not be possible to call
483      * `onlyOwner` functions anymore. Can only be called by the current owner.
484      *
485      * NOTE: Renouncing ownership will leave the contract without an owner,
486      * thereby removing any functionality that is only available to the owner.
487      */
488     function renounceOwnership() public virtual onlyOwner {
489         emit OwnershipTransferred(_owner, address(0));
490         _owner = address(0);
491     }
492 
493     /**
494      * @dev Transfers ownership of the contract to a new account (`newOwner`).
495      * Can only be called by the current owner.
496      */
497     function transferOwnership(address newOwner) public virtual onlyOwner {
498         require(newOwner != address(0), "Ownable: new owner is the zero address");
499         emit OwnershipTransferred(_owner, newOwner);
500         _owner = newOwner;
501     }
502 }
503 
504 
505 pragma solidity ^0.6.2;
506 
507 contract SLOTH is Context, IERC20, Ownable {
508     using SafeMath for uint256;
509     using Address for address;
510 
511     mapping (address => uint256) private _rOwned;
512     mapping (address => uint256) private _tOwned;
513     mapping (address => mapping (address => uint256)) private _allowances;
514 
515     mapping (address => bool) private _isExcluded;
516     address[] private _excluded;
517 
518     uint256 private constant MAX = ~uint256(0);
519     uint256 private constant _tTotal = 10000 * 10**6 * 10**9;
520     uint256 private _rTotal = (MAX - (MAX % _tTotal));
521     uint256 private _tFeeTotal;
522 
523     string private _name = 'Sloth Token';
524     string private _symbol = 'SLOTH';
525     uint8 private _decimals = 9;
526 
527     constructor () public {
528         _rOwned[_msgSender()] = _rTotal;
529         emit Transfer(address(0), _msgSender(), _tTotal);
530     }
531 
532     function name() public view returns (string memory) {
533         return _name;
534     }
535 
536     function symbol() public view returns (string memory) {
537         return _symbol;
538     }
539 
540     function decimals() public view returns (uint8) {
541         return _decimals;
542     }
543 
544     function totalSupply() public view override returns (uint256) {
545         return _tTotal;
546     }
547 
548     function balanceOf(address account) public view override returns (uint256) {
549         if (_isExcluded[account]) return _tOwned[account];
550         return tokenFromReflection(_rOwned[account]);
551     }
552 
553     function transfer(address recipient, uint256 amount) public override returns (bool) {
554         _transfer(_msgSender(), recipient, amount);
555         return true;
556     }
557 
558     function allowance(address owner, address spender) public view override returns (uint256) {
559         return _allowances[owner][spender];
560     }
561 
562     function approve(address spender, uint256 amount) public override returns (bool) {
563         _approve(_msgSender(), spender, amount);
564         return true;
565     }
566 
567     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
568         _transfer(sender, recipient, amount);
569         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
570         return true;
571     }
572 
573     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
574         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
575         return true;
576     }
577 
578     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
579         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
580         return true;
581     }
582 
583     function isExcluded(address account) public view returns (bool) {
584         return _isExcluded[account];
585     }
586 
587     function totalFees() public view returns (uint256) {
588         return _tFeeTotal;
589     }
590 
591     function reflect(uint256 tAmount) public {
592         address sender = _msgSender();
593         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
594         (uint256 rAmount,,,,) = _getValues(tAmount);
595         _rOwned[sender] = _rOwned[sender].sub(rAmount);
596         _rTotal = _rTotal.sub(rAmount);
597         _tFeeTotal = _tFeeTotal.add(tAmount);
598     }
599 
600     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
601         require(tAmount <= _tTotal, "Amount must be less than supply");
602         if (!deductTransferFee) {
603             (uint256 rAmount,,,,) = _getValues(tAmount);
604             return rAmount;
605         } else {
606             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
607             return rTransferAmount;
608         }
609     }
610 
611     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
612         require(rAmount <= _rTotal, "Amount must be less than total reflections");
613         uint256 currentRate =  _getRate();
614         return rAmount.div(currentRate);
615     }
616 
617     function excludeAccount(address account) external onlyOwner() {
618         require(!_isExcluded[account], "Account is already excluded");
619         if(_rOwned[account] > 0) {
620             _tOwned[account] = tokenFromReflection(_rOwned[account]);
621         }
622         _isExcluded[account] = true;
623         _excluded.push(account);
624     }
625 
626     function includeAccount(address account) external onlyOwner() {
627         require(_isExcluded[account], "Account is already excluded");
628         for (uint256 i = 0; i < _excluded.length; i++) {
629             if (_excluded[i] == account) {
630                 _excluded[i] = _excluded[_excluded.length - 1];
631                 _tOwned[account] = 0;
632                 _isExcluded[account] = false;
633                 _excluded.pop();
634                 break;
635             }
636         }
637     }
638 
639     function _approve(address owner, address spender, uint256 amount) private {
640         require(owner != address(0), "ERC20: approve from the zero address");
641         require(spender != address(0), "ERC20: approve to the zero address");
642 
643         _allowances[owner][spender] = amount;
644         emit Approval(owner, spender, amount);
645     }
646 
647     function _transfer(address sender, address recipient, uint256 amount) private {
648         require(sender != address(0), "ERC20: transfer from the zero address");
649         require(recipient != address(0), "ERC20: transfer to the zero address");
650         require(amount > 0, "Transfer amount must be greater than zero");
651         if (_isExcluded[sender] && !_isExcluded[recipient]) {
652             _transferFromExcluded(sender, recipient, amount);
653         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
654             _transferToExcluded(sender, recipient, amount);
655         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
656             _transferStandard(sender, recipient, amount);
657         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
658             _transferBothExcluded(sender, recipient, amount);
659         } else {
660             _transferStandard(sender, recipient, amount);
661         }
662     }
663 
664     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
665         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
666         _rOwned[sender] = _rOwned[sender].sub(rAmount);
667         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
668         _reflectFee(rFee, tFee);
669         emit Transfer(sender, recipient, tTransferAmount);
670     }
671 
672     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
673         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
674         _rOwned[sender] = _rOwned[sender].sub(rAmount);
675         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
676         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
677         _reflectFee(rFee, tFee);
678         emit Transfer(sender, recipient, tTransferAmount);
679     }
680 
681     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
682         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
683         _tOwned[sender] = _tOwned[sender].sub(tAmount);
684         _rOwned[sender] = _rOwned[sender].sub(rAmount);
685         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
686         _reflectFee(rFee, tFee);
687         emit Transfer(sender, recipient, tTransferAmount);
688     }
689 
690     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
691         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
692         _tOwned[sender] = _tOwned[sender].sub(tAmount);
693         _rOwned[sender] = _rOwned[sender].sub(rAmount);
694         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
695         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
696         _reflectFee(rFee, tFee);
697         emit Transfer(sender, recipient, tTransferAmount);
698     }
699 
700     function _reflectFee(uint256 rFee, uint256 tFee) private {
701         _rTotal = _rTotal.sub(rFee);
702         _tFeeTotal = _tFeeTotal.add(tFee);
703     }
704 
705     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
706         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
707         uint256 currentRate =  _getRate();
708         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
709         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
710     }
711 
712     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
713         uint256 tFee = tAmount.mul(2).div(100);
714         uint256 tTransferAmount = tAmount.sub(tFee);
715         return (tTransferAmount, tFee);
716     }
717 
718     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
719         uint256 rAmount = tAmount.mul(currentRate);
720         uint256 rFee = tFee.mul(currentRate);
721         uint256 rTransferAmount = rAmount.sub(rFee);
722         return (rAmount, rTransferAmount, rFee);
723     }
724 
725     function _getRate() private view returns(uint256) {
726         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
727         return rSupply.div(tSupply);
728     }
729 
730     function _getCurrentSupply() private view returns(uint256, uint256) {
731         uint256 rSupply = _rTotal;
732         uint256 tSupply = _tTotal;
733         for (uint256 i = 0; i < _excluded.length; i++) {
734             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
735             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
736             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
737         }
738         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
739         return (rSupply, tSupply);
740     }
741 }