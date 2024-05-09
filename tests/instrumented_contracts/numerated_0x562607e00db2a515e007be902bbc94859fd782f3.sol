1 /**
2  *
3  *       
4 
5 ───────────────────────────────────────────────────────────────────────────────────────────────
6 ─██████──████████─██████████████─██████████████───██████████████─██████████████─██████──██████─
7 ─██░░██──██░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██───██░░░░░░░░░░██─██░░░░░░░░░░██─██░░██──██░░██─
8 ─██░░██──██░░████─██░░██████░░██─██░░██████░░██───██░░██████░░██─██░░██████████─██░░██──██░░██─
9 ─██░░██──██░░██───██░░██──██░░██─██░░██──██░░██───██░░██──██░░██─██░░██─────────██░░██──██░░██─
10 ─██░░██████░░██───██░░██████░░██─██░░██████░░████─██░░██──██░░██─██░░██████████─██░░██──██░░██─
11 ─██░░░░░░░░░░██───██░░░░░░░░░░██─██░░░░░░░░░░░░██─██░░██──██░░██─██░░░░░░░░░░██─██░░██──██░░██─
12 ─██░░██████░░██───██░░██████░░██─██░░████████░░██─██░░██──██░░██─██████████░░██─██░░██──██░░██─
13 ─██░░██──██░░██───██░░██──██░░██─██░░██────██░░██─██░░██──██░░██─────────██░░██─██░░██──██░░██─
14 ─██░░██──██░░████─██░░██──██░░██─██░░████████░░██─██░░██████░░██─██████████░░██─██░░██████░░██─
15 ─██░░██──██░░░░██─██░░██──██░░██─██░░░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─██░░░░░░░░░░██─
16 ─██████──████████─██████──██████─████████████████─██████████████─██████████████─██████████████─
17 ───────────────────────────────────────────────────────────────────────────────────────────────
18  * 
19  * 
20  * 
21  * 
22  * 
23  * 
24 */
25 
26 // Kabo is Kabosu, the OG Doge.  It is a DeFi token with 2% redistribution tax (RFI variant)
27 
28 
29 
30 /*
31  * @dev Provides information about the current execution context, including the
32  * sender of the transaction and its data. While these are generally available
33  * via msg.sender and msg.data, they should not be accessed in such a direct
34  * manner, since when dealing with GSN meta-transactions the account sending and
35  * paying for execution may not be the actual sender (as far as an application
36  * is concerned).
37  *
38  * This contract is only required for intermediate, library-like contracts.
39  */
40 abstract contract Context {
41     function _msgSender() internal view virtual returns (address payable) {
42         return msg.sender;
43     }
44 
45     function _msgData() internal view virtual returns (bytes memory) {
46         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
47         return msg.data;
48     }
49 }
50 
51 
52 /**
53  * @dev Interface of the ERC20 standard as defined in the EIP.
54  */
55 interface IERC20 {
56     /**
57      * @dev Returns the amount of tokens in existence.
58      */
59     function totalSupply() external view returns (uint256);
60 
61     /**
62      * @dev Returns the amount of tokens owned by `account`.
63      */
64     function balanceOf(address account) external view returns (uint256);
65 
66     /**
67      * @dev Moves `amount` tokens from the caller's account to `recipient`.
68      *
69      * Returns a boolean value indicating whether the operation succeeded.
70      *
71      * Emits a {Transfer} event.
72      */
73     function transfer(address recipient, uint256 amount) external returns (bool);
74 
75     /**
76      * @dev Returns the remaining number of tokens that `spender` will be
77      * allowed to spend on behalf of `owner` through {transferFrom}. This is
78      * zero by default.
79      *
80      * This value changes when {approve} or {transferFrom} are called.
81      */
82     function allowance(address owner, address spender) external view returns (uint256);
83 
84     /**
85      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
86      *
87      * Returns a boolean value indicating whether the operation succeeded.
88      *
89      * IMPORTANT: Beware that changing an allowance with this method brings the risk
90      * that someone may use both the old and the new allowance by unfortunate
91      * transaction ordering. One possible solution to mitigate this race
92      * condition is to first reduce the spender's allowance to 0 and set the
93      * desired value afterwards:
94      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
95      *
96      * Emits an {Approval} event.
97      */
98     function approve(address spender, uint256 amount) external returns (bool);
99 
100     /**
101      * @dev Moves `amount` tokens from `sender` to `recipient` using the
102      * allowance mechanism. `amount` is then deducted from the caller's
103      * allowance.
104      *
105      * Returns a boolean value indicating whether the operation succeeded.
106      *
107      * Emits a {Transfer} event.
108      */
109     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
110 
111     /**
112      * @dev Emitted when `value` tokens are moved from one account (`from`) to
113      * another (`to`).
114      *
115      * Note that `value` may be zero.
116      */
117     event Transfer(address indexed from, address indexed to, uint256 value);
118 
119     /**
120      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
121      * a call to {approve}. `value` is the new allowance.
122      */
123     event Approval(address indexed owner, address indexed spender, uint256 value);
124 }
125 
126 
127 
128 /**
129  * @dev Wrappers over Solidity's arithmetic operations with added overflow
130  * checks.
131  *
132  * Arithmetic operations in Solidity wrap on overflow. This can easily result
133  * in bugs, because programmers usually assume that an overflow raises an
134  * error, which is the standard behavior in high level programming languages.
135  * `SafeMath` restores this intuition by reverting the transaction when an
136  * operation overflows.
137  *
138  * Using this library instead of the unchecked operations eliminates an entire
139  * class of bugs, so it's recommended to use it always.
140  */
141 library SafeMath {
142     /**
143      * @dev Returns the addition of two unsigned integers, reverting on
144      * overflow.
145      *
146      * Counterpart to Solidity's `+` operator.
147      *
148      * Requirements:
149      *
150      * - Addition cannot overflow.
151      */
152     function add(uint256 a, uint256 b) internal pure returns (uint256) {
153         uint256 c = a + b;
154         require(c >= a, "SafeMath: addition overflow");
155 
156         return c;
157     }
158 
159     /**
160      * @dev Returns the subtraction of two unsigned integers, reverting on
161      * overflow (when the result is negative).
162      *
163      * Counterpart to Solidity's `-` operator.
164      *
165      * Requirements:
166      *
167      * - Subtraction cannot overflow.
168      */
169     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
170         return sub(a, b, "SafeMath: subtraction overflow");
171     }
172 
173     /**
174      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
175      * overflow (when the result is negative).
176      *
177      * Counterpart to Solidity's `-` operator.
178      *
179      * Requirements:
180      *
181      * - Subtraction cannot overflow.
182      */
183     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
184         require(b <= a, errorMessage);
185         uint256 c = a - b;
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the multiplication of two unsigned integers, reverting on
192      * overflow.
193      *
194      * Counterpart to Solidity's `*` operator.
195      *
196      * Requirements:
197      *
198      * - Multiplication cannot overflow.
199      */
200     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
201         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
202         // benefit is lost if 'b' is also tested.
203         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
204         if (a == 0) {
205             return 0;
206         }
207 
208         uint256 c = a * b;
209         require(c / a == b, "SafeMath: multiplication overflow");
210 
211         return c;
212     }
213 
214     /**
215      * @dev Returns the integer division of two unsigned integers. Reverts on
216      * division by zero. The result is rounded towards zero.
217      *
218      * Counterpart to Solidity's `/` operator. Note: this function uses a
219      * `revert` opcode (which leaves remaining gas untouched) while Solidity
220      * uses an invalid opcode to revert (consuming all remaining gas).
221      *
222      * Requirements:
223      *
224      * - The divisor cannot be zero.
225      */
226     function div(uint256 a, uint256 b) internal pure returns (uint256) {
227         return div(a, b, "SafeMath: division by zero");
228     }
229 
230     /**
231      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
232      * division by zero. The result is rounded towards zero.
233      *
234      * Counterpart to Solidity's `/` operator. Note: this function uses a
235      * `revert` opcode (which leaves remaining gas untouched) while Solidity
236      * uses an invalid opcode to revert (consuming all remaining gas).
237      *
238      * Requirements:
239      *
240      * - The divisor cannot be zero.
241      */
242     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
243         require(b > 0, errorMessage);
244         uint256 c = a / b;
245         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
246 
247         return c;
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * Reverts when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      *
260      * - The divisor cannot be zero.
261      */
262     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
263         return mod(a, b, "SafeMath: modulo by zero");
264     }
265 
266     /**
267      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
268      * Reverts with custom message when dividing by zero.
269      *
270      * Counterpart to Solidity's `%` operator. This function uses a `revert`
271      * opcode (which leaves remaining gas untouched) while Solidity uses an
272      * invalid opcode to revert (consuming all remaining gas).
273      *
274      * Requirements:
275      *
276      * - The divisor cannot be zero.
277      */
278     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
279         require(b != 0, errorMessage);
280         return a % b;
281     }
282 }
283 
284 // File: openzeppelin-solidity\contracts\utils\Address.sol
285 
286 // SPDX-License-Identifier: MIT
287 
288 pragma solidity ^0.6.2;
289 
290 /**
291  * @dev Collection of functions related to the address type
292  */
293 library Address {
294     /**
295      * @dev Returns true if `account` is a contract.
296      *
297      * [IMPORTANT]
298      * ====
299      * It is unsafe to assume that an address for which this function returns
300      * false is an externally-owned account (EOA) and not a contract.
301      *
302      * Among others, `isContract` will return false for the following
303      * types of addresses:
304      *
305      *  - an externally-owned account
306      *  - a contract in construction
307      *  - an address where a contract will be created
308      *  - an address where a contract lived, but was destroyed
309      * ====
310      */
311     function isContract(address account) internal view returns (bool) {
312         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
313         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
314         // for accounts without code, i.e. `keccak256('')`
315         bytes32 codehash;
316         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
317         // solhint-disable-next-line no-inline-assembly
318         assembly { codehash := extcodehash(account) }
319         return (codehash != accountHash && codehash != 0x0);
320     }
321 
322     /**
323      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
324      * `recipient`, forwarding all available gas and reverting on errors.
325      *
326      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
327      * of certain opcodes, possibly making contracts go over the 2300 gas limit
328      * imposed by `transfer`, making them unable to receive funds via
329      * `transfer`. {sendValue} removes this limitation.
330      *
331      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
332      *
333      * IMPORTANT: because control is transferred to `recipient`, care must be
334      * taken to not create reentrancy vulnerabilities. Consider using
335      * {ReentrancyGuard} or the
336      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
337      */
338     function sendValue(address payable recipient, uint256 amount) internal {
339         require(address(this).balance >= amount, "Address: insufficient balance");
340 
341         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
342         (bool success, ) = recipient.call{ value: amount }("");
343         require(success, "Address: unable to send value, recipient may have reverted");
344     }
345 
346     /**
347      * @dev Performs a Solidity function call using a low level `call`. A
348      * plain`call` is an unsafe replacement for a function call: use this
349      * function instead.
350      *
351      * If `target` reverts with a revert reason, it is bubbled up by this
352      * function (like regular Solidity function calls).
353      *
354      * Returns the raw returned data. To convert to the expected return value,
355      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
356      *
357      * Requirements:
358      *
359      * - `target` must be a contract.
360      * - calling `target` with `data` must not revert.
361      *
362      * _Available since v3.1._
363      */
364     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
365         return functionCall(target, data, "Address: low-level call failed");
366     }
367 
368     /**
369      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
370      * `errorMessage` as a fallback revert reason when `target` reverts.
371      *
372      * _Available since v3.1._
373      */
374     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
375         return _functionCallWithValue(target, data, 0, errorMessage);
376     }
377 
378     /**
379      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
380      * but also transferring `value` wei to `target`.
381      *
382      * Requirements:
383      *
384      * - the calling contract must have an ETH balance of at least `value`.
385      * - the called Solidity function must be `payable`.
386      *
387      * _Available since v3.1._
388      */
389     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
390         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
391     }
392 
393     /**
394      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
395      * with `errorMessage` as a fallback revert reason when `target` reverts.
396      *
397      * _Available since v3.1._
398      */
399     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
400         require(address(this).balance >= value, "Address: insufficient balance for call");
401         return _functionCallWithValue(target, data, value, errorMessage);
402     }
403 
404     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
405         require(isContract(target), "Address: call to non-contract");
406 
407         // solhint-disable-next-line avoid-low-level-calls
408         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
409         if (success) {
410             return returndata;
411         } else {
412             // Look for revert reason and bubble it up if present
413             if (returndata.length > 0) {
414                 // The easiest way to bubble the revert reason is using memory via assembly
415 
416                 // solhint-disable-next-line no-inline-assembly
417                 assembly {
418                     let returndata_size := mload(returndata)
419                     revert(add(32, returndata), returndata_size)
420                 }
421             } else {
422                 revert(errorMessage);
423             }
424         }
425     }
426 }
427 
428 
429 pragma solidity ^0.6.0;
430 
431 /**
432  * @dev Contract module which provides a basic access control mechanism, where
433  * there is an account (an owner) that can be granted exclusive access to
434  * specific functions.
435  *
436  * By default, the owner account will be the one that deploys the contract. This
437  * can later be changed with {transferOwnership}.
438  *
439  * This module is used through inheritance. It will make available the modifier
440  * `onlyOwner`, which can be applied to your functions to restrict their use to
441  * the owner.
442  */
443 contract Ownable is Context {
444     address private _owner;
445 
446     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
447 
448     /**
449      * @dev Initializes the contract setting the deployer as the initial owner.
450      */
451     constructor () internal {
452         address msgSender = _msgSender();
453         _owner = msgSender;
454         emit OwnershipTransferred(address(0), msgSender);
455     }
456 
457     /**
458      * @dev Returns the address of the current owner.
459      */
460     function owner() public view returns (address) {
461         return _owner;
462     }
463 
464     /**
465      * @dev Throws if called by any account other than the owner.
466      */
467     modifier onlyOwner() {
468         require(_owner == _msgSender(), "Ownable: caller is not the owner");
469         _;
470     }
471 
472     /**
473      * @dev Leaves the contract without owner. It will not be possible to call
474      * `onlyOwner` functions anymore. Can only be called by the current owner.
475      *
476      * NOTE: Renouncing ownership will leave the contract without an owner,
477      * thereby removing any functionality that is only available to the owner.
478      */
479     function renounceOwnership() public virtual onlyOwner {
480         emit OwnershipTransferred(_owner, address(0));
481         _owner = address(0);
482     }
483 
484     /**
485      * @dev Transfers ownership of the contract to a new account (`newOwner`).
486      * Can only be called by the current owner.
487      */
488     function transferOwnership(address newOwner) public virtual onlyOwner {
489         require(newOwner != address(0), "Ownable: new owner is the zero address");
490         emit OwnershipTransferred(_owner, newOwner);
491         _owner = newOwner;
492     }
493 }
494 
495 
496 
497 //Many peopel do not these contracts a read BUT NOT YOU.  Somewhere in socials are eggs, you can do them a find and get rewarded with BOUNTIES
498 
499 
500 pragma solidity ^0.6.2;
501 
502 contract Kabo is Context, IERC20, Ownable {
503     using SafeMath for uint256;
504     using Address for address;
505 
506     mapping (address => uint256) private _rOwned;
507     mapping (address => uint256) private _tOwned;
508     mapping (address => mapping (address => uint256)) private _allowances;
509 
510     mapping (address => bool) private _isExcluded;
511     address[] private _excluded;
512     
513     uint256 private constant MAX = ~uint256(0);
514     uint256 private constant _tTotal = 1 * 10**12 * 10**9;
515     uint256 private _rTotal = (MAX - (MAX % _tTotal));
516     uint256 private _tFeeTotal;
517 
518     string private _name = 'Kabosu.finance';
519     string private _symbol = 'KABO';
520     uint8 private _decimals = 9;
521 
522     constructor () public {
523         _rOwned[_msgSender()] = _rTotal;
524         emit Transfer(address(0), _msgSender(), _tTotal);
525     }
526 
527     function symbol() public view returns (string memory) {
528         return _symbol;
529     }
530 
531     function name() public view returns (string memory) {
532         return _name;
533     }
534     
535     function decimals() public view returns (uint8) {
536         return _decimals;
537     }
538 
539     function totalSupply() public view override returns (uint256) {
540         return _tTotal;
541     }
542 
543     function balanceOf(address account) public view override returns (uint256) {
544         if (_isExcluded[account]) return _tOwned[account];
545         return tokenFromReflection(_rOwned[account]);
546     }
547     
548     function awooooo() public pure returns (string memory){
549         
550         return ("AWOOOOOOOOOOO!!!  hi there 'fren', iz a secret");
551     }
552 
553     function allowance(address owner, address spender) public view override returns (uint256) {
554         return _allowances[owner][spender];
555     }
556 
557     function transfer(address recipient, uint256 amount) public override returns (bool) {
558         _transfer(_msgSender(), recipient, amount);
559         return true;
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
611     function excludeAccount(address account) external onlyOwner() {
612         require(!_isExcluded[account], "Account is already excluded");
613         if(_rOwned[account] > 0) {
614             _tOwned[account] = tokenFromReflection(_rOwned[account]);
615         }
616         _isExcluded[account] = true;
617         _excluded.push(account);
618     }
619     
620     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
621         require(rAmount <= _rTotal, "Amount must be less than total reflections");
622         uint256 currentRate =  _getRate();
623         return rAmount.div(currentRate);
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
647     function awooooooo(string memory _msg) public pure returns(string memory){
648         
649         if(keccak256(abi.encodePacked(_msg)) == keccak256(abi.encodePacked("clue"))){
650             return ("Now leabder in 'cord, for bounty");
651         }
652         return ("Nope, wrong passhwerd");
653     }
654 
655     function _transfer(address sender, address recipient, uint256 amount) private {
656         require(sender != address(0), "ERC20: transfer from the zero address");
657         require(recipient != address(0), "ERC20: transfer to the zero address");
658         require(amount > 0, "Transfer amount must be greater than zero");
659         if (_isExcluded[sender] && !_isExcluded[recipient]) {
660             _transferFromExcluded(sender, recipient, amount);
661         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
662             _transferToExcluded(sender, recipient, amount);
663         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
664             _transferStandard(sender, recipient, amount);
665         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
666             _transferBothExcluded(sender, recipient, amount);
667         } else {
668             _transferStandard(sender, recipient, amount);
669         }
670     }
671 
672     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
673         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
674         _tOwned[sender] = _tOwned[sender].sub(tAmount);
675         _rOwned[sender] = _rOwned[sender].sub(rAmount);
676         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
677         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
678         _reflectFee(rFee, tFee);
679         emit Transfer(sender, recipient, tTransferAmount);
680     }
681 
682     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
683         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
684         _rOwned[sender] = _rOwned[sender].sub(rAmount);
685         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
686         _reflectFee(rFee, tFee);
687         emit Transfer(sender, recipient, tTransferAmount);
688     }
689 
690     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
691         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
692         _rOwned[sender] = _rOwned[sender].sub(rAmount);
693         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
694         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
695         _reflectFee(rFee, tFee);
696         emit Transfer(sender, recipient, tTransferAmount);
697     }
698 
699     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
700         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
701         _tOwned[sender] = _tOwned[sender].sub(tAmount);
702         _rOwned[sender] = _rOwned[sender].sub(rAmount);
703         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
704         _reflectFee(rFee, tFee);
705         emit Transfer(sender, recipient, tTransferAmount);
706     }
707 
708     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
709         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
710         uint256 currentRate =  _getRate();
711         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
712         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
713     }
714 
715     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
716         uint256 tFee = tAmount.mul(2).div(100);
717         uint256 tTransferAmount = tAmount.sub(tFee);
718         return (tTransferAmount, tFee);
719     }
720     
721     function _reflectFee(uint256 rFee, uint256 tFee) private {
722         _rTotal = _rTotal.sub(rFee);
723         _tFeeTotal = _tFeeTotal.add(tFee);
724     }
725 
726     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
727         uint256 rAmount = tAmount.mul(currentRate);
728         uint256 rFee = tFee.mul(currentRate);
729         uint256 rTransferAmount = rAmount.sub(rFee);
730         return (rAmount, rTransferAmount, rFee);
731     }
732 
733     function _getRate() private view returns(uint256) {
734         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
735         return rSupply.div(tSupply);
736     }
737     function awoooooo(string memory _msg) public pure returns(string memory){
738         
739         if(keccak256(abi.encodePacked(_msg)) == keccak256(abi.encodePacked("fren"))){
740             return ("can you find da 'clue' ??");
741         }
742         return ("Nope, wrong passhwerd");
743     }
744 
745     function _getCurrentSupply() private view returns(uint256, uint256) {
746         uint256 rSupply = _rTotal;
747         uint256 tSupply = _tTotal;
748         for (uint256 i = 0; i < _excluded.length; i++) {
749             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
750             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
751             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
752         }
753         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
754         return (rSupply, tSupply);
755     }
756 }