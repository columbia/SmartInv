1 // Ethereum Cash (eCash)
2 // Telegram t.me/ethereumcashtoken
3 // Website: www.ethereumcashtoken.com
4 // Twitter: https://twitter.com/0xethercash
5 // 
6 // .----------------.  .----------------.  .----------------.  .----------------.  .----------------. 
7 //| .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |
8 //| |  _________   | || |     ______   | || |      __      | || |    _______   | || |  ____  ____  | |
9 //| | |_   ___  |  | || |   .' ___  |  | || |     /  \     | || |   /  ___  |  | || | |_   ||   _| | |
10 //| |   | |_  \_|  | || |  / .'   \_|  | || |    / /\ \    | || |  |  (__ \_|  | || |   | |__| |   | |
11 //| |   |  _|  _   | || |  | |         | || |   / ____ \   | || |   '.___`-.   | || |   |  __  |   | |
12 //| |  _| |___/ |  | || |  \ `.___.'\  | || | _/ /    \ \_ | || |  |`\____) |  | || |  _| |  | |_  | |
13 //| | |_________|  | || |   `._____.'  | || ||____|  |____|| || |  |_______.'  | || | |____||____| | |
14 //| |              | || |              | || |              | || |              | || |              | |
15 //| '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |
16 // '----------------'  '----------------'  '----------------'  '----------------'  '----------------' 
17 
18 /*
19  * @dev Provides information about the current execution context, including the
20  * sender of the transaction and its data. While these are generally available
21  * via msg.sender and msg.data, they should not be accessed in such a direct
22  * manner, since when dealing with GSN meta-transactions the account sending and
23  * paying for execution may not be the actual sender (as far as an application
24  * is concerned).
25  *
26  * This contract is only required for intermediate, library-like contracts.
27  */
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
39 
40 /**
41  * @dev Interface of the ERC20 standard as defined in the EIP.
42  */
43 interface IERC20 {
44     /**
45      * @dev Returns the amount of tokens in existence.
46      */
47     function totalSupply() external view returns (uint256);
48 
49     /**
50      * @dev Returns the amount of tokens owned by `account`.
51      */
52     function balanceOf(address account) external view returns (uint256);
53 
54     /**
55      * @dev Moves `amount` tokens from the caller's account to `recipient`.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transfer(address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Returns the remaining number of tokens that `spender` will be
65      * allowed to spend on behalf of `owner` through {transferFrom}. This is
66      * zero by default.
67      *
68      * This value changes when {approve} or {transferFrom} are called.
69      */
70     function allowance(address owner, address spender) external view returns (uint256);
71 
72     /**
73      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * IMPORTANT: Beware that changing an allowance with this method brings the risk
78      * that someone may use both the old and the new allowance by unfortunate
79      * transaction ordering. One possible solution to mitigate this race
80      * condition is to first reduce the spender's allowance to 0 and set the
81      * desired value afterwards:
82      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
83      *
84      * Emits an {Approval} event.
85      */
86     function approve(address spender, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Moves `amount` tokens from `sender` to `recipient` using the
90      * allowance mechanism. `amount` is then deducted from the caller's
91      * allowance.
92      *
93      * Returns a boolean value indicating whether the operation succeeded.
94      *
95      * Emits a {Transfer} event.
96      */
97     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
98 
99     /**
100      * @dev Emitted when `value` tokens are moved from one account (`from`) to
101      * another (`to`).
102      *
103      * Note that `value` may be zero.
104      */
105     event Transfer(address indexed from, address indexed to, uint256 value);
106 
107     /**
108      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
109      * a call to {approve}. `value` is the new allowance.
110      */
111     event Approval(address indexed owner, address indexed spender, uint256 value);
112 }
113 
114 
115 
116 /**
117  * @dev Wrappers over Solidity's arithmetic operations with added overflow
118  * checks.
119  *
120  * Arithmetic operations in Solidity wrap on overflow. This can easily result
121  * in bugs, because programmers usually assume that an overflow raises an
122  * error, which is the standard behavior in high level programming languages.
123  * `SafeMath` restores this intuition by reverting the transaction when an
124  * operation overflows.
125  *
126  * Using this library instead of the unchecked operations eliminates an entire
127  * class of bugs, so it's recommended to use it always.
128  */
129 library SafeMath {
130     /**
131      * @dev Returns the addition of two unsigned integers, reverting on
132      * overflow.
133      *
134      * Counterpart to Solidity's `+` operator.
135      *
136      * Requirements:
137      *
138      * - Addition cannot overflow.
139      */
140     function add(uint256 a, uint256 b) internal pure returns (uint256) {
141         uint256 c = a + b;
142         require(c >= a, "SafeMath: addition overflow");
143 
144         return c;
145     }
146 
147     /**
148      * @dev Returns the subtraction of two unsigned integers, reverting on
149      * overflow (when the result is negative).
150      *
151      * Counterpart to Solidity's `-` operator.
152      *
153      * Requirements:
154      *
155      * - Subtraction cannot overflow.
156      */
157     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
158         return sub(a, b, "SafeMath: subtraction overflow");
159     }
160 
161     /**
162      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
163      * overflow (when the result is negative).
164      *
165      * Counterpart to Solidity's `-` operator.
166      *
167      * Requirements:
168      *
169      * - Subtraction cannot overflow.
170      */
171     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
172         require(b <= a, errorMessage);
173         uint256 c = a - b;
174 
175         return c;
176     }
177 
178     /**
179      * @dev Returns the multiplication of two unsigned integers, reverting on
180      * overflow.
181      *
182      * Counterpart to Solidity's `*` operator.
183      *
184      * Requirements:
185      *
186      * - Multiplication cannot overflow.
187      */
188     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
189         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
190         // benefit is lost if 'b' is also tested.
191         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
192         if (a == 0) {
193             return 0;
194         }
195 
196         uint256 c = a * b;
197         require(c / a == b, "SafeMath: multiplication overflow");
198 
199         return c;
200     }
201 
202     /**
203      * @dev Returns the integer division of two unsigned integers. Reverts on
204      * division by zero. The result is rounded towards zero.
205      *
206      * Counterpart to Solidity's `/` operator. Note: this function uses a
207      * `revert` opcode (which leaves remaining gas untouched) while Solidity
208      * uses an invalid opcode to revert (consuming all remaining gas).
209      *
210      * Requirements:
211      *
212      * - The divisor cannot be zero.
213      */
214     function div(uint256 a, uint256 b) internal pure returns (uint256) {
215         return div(a, b, "SafeMath: division by zero");
216     }
217 
218     /**
219      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
220      * division by zero. The result is rounded towards zero.
221      *
222      * Counterpart to Solidity's `/` operator. Note: this function uses a
223      * `revert` opcode (which leaves remaining gas untouched) while Solidity
224      * uses an invalid opcode to revert (consuming all remaining gas).
225      *
226      * Requirements:
227      *
228      * - The divisor cannot be zero.
229      */
230     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
231         require(b > 0, errorMessage);
232         uint256 c = a / b;
233         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
234 
235         return c;
236     }
237 
238     /**
239      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
240      * Reverts when dividing by zero.
241      *
242      * Counterpart to Solidity's `%` operator. This function uses a `revert`
243      * opcode (which leaves remaining gas untouched) while Solidity uses an
244      * invalid opcode to revert (consuming all remaining gas).
245      *
246      * Requirements:
247      *
248      * - The divisor cannot be zero.
249      */
250     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
251         return mod(a, b, "SafeMath: modulo by zero");
252     }
253 
254     /**
255      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
256      * Reverts with custom message when dividing by zero.
257      *
258      * Counterpart to Solidity's `%` operator. This function uses a `revert`
259      * opcode (which leaves remaining gas untouched) while Solidity uses an
260      * invalid opcode to revert (consuming all remaining gas).
261      *
262      * Requirements:
263      *
264      * - The divisor cannot be zero.
265      */
266     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
267         require(b != 0, errorMessage);
268         return a % b;
269     }
270 }
271 
272 // File: openzeppelin-solidity\contracts\utils\Address.sol
273 
274 // SPDX-License-Identifier: MIT
275 
276 
277 /**
278  * @dev Collection of functions related to the address type
279  */
280 library Address {
281     /**
282      * @dev Returns true if `account` is a contract.
283      *
284      * [IMPORTANT]
285      * ====
286      * It is unsafe to assume that an address for which this function returns
287      * false is an externally-owned account (EOA) and not a contract.
288      *
289      * Among others, `isContract` will return false for the following
290      * types of addresses:
291      *
292      *  - an externally-owned account
293      *  - a contract in construction
294      *  - an address where a contract will be created
295      *  - an address where a contract lived, but was destroyed
296      * ====
297      */
298     function isContract(address account) internal view returns (bool) {
299         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
300         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
301         // for accounts without code, i.e. `keccak256('')`
302         bytes32 codehash;
303         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
304         // solhint-disable-next-line no-inline-assembly
305         assembly { codehash := extcodehash(account) }
306         return (codehash != accountHash && codehash != 0x0);
307     }
308 
309     /**
310      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
311      * `recipient`, forwarding all available gas and reverting on errors.
312      *
313      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
314      * of certain opcodes, possibly making contracts go over the 2300 gas limit
315      * imposed by `transfer`, making them unable to receive funds via
316      * `transfer`. {sendValue} removes this limitation.
317      *
318      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
319      *
320      * IMPORTANT: because control is transferred to `recipient`, care must be
321      * taken to not create reentrancy vulnerabilities. Consider using
322      * {ReentrancyGuard} or the
323      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
324      */
325     function sendValue(address payable recipient, uint256 amount) internal {
326         require(address(this).balance >= amount, "Address: insufficient balance");
327 
328         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
329         (bool success, ) = recipient.call{ value: amount }("");
330         require(success, "Address: unable to send value, recipient may have reverted");
331     }
332 
333     /**
334      * @dev Performs a Solidity function call using a low level `call`. A
335      * plain`call` is an unsafe replacement for a function call: use this
336      * function instead.
337      *
338      * If `target` reverts with a revert reason, it is bubbled up by this
339      * function (like regular Solidity function calls).
340      *
341      * Returns the raw returned data. To convert to the expected return value,
342      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
343      *
344      * Requirements:
345      *
346      * - `target` must be a contract.
347      * - calling `target` with `data` must not revert.
348      *
349      * _Available since v3.1._
350      */
351     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
352         return functionCall(target, data, "Address: low-level call failed");
353     }
354 
355     /**
356      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
357      * `errorMessage` as a fallback revert reason when `target` reverts.
358      *
359      * _Available since v3.1._
360      */
361     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
362         return _functionCallWithValue(target, data, 0, errorMessage);
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
367      * but also transferring `value` wei to `target`.
368      *
369      * Requirements:
370      *
371      * - the calling contract must have an ETH balance of at least `value`.
372      * - the called Solidity function must be `payable`.
373      *
374      * _Available since v3.1._
375      */
376     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
377         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
378     }
379 
380     /**
381      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
382      * with `errorMessage` as a fallback revert reason when `target` reverts.
383      *
384      * _Available since v3.1._
385      */
386     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
387         require(address(this).balance >= value, "Address: insufficient balance for call");
388         return _functionCallWithValue(target, data, value, errorMessage);
389     }
390 
391     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
392         require(isContract(target), "Address: call to non-contract");
393 
394         // solhint-disable-next-line avoid-low-level-calls
395         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
396         if (success) {
397             return returndata;
398         } else {
399             // Look for revert reason and bubble it up if present
400             if (returndata.length > 0) {
401                 // The easiest way to bubble the revert reason is using memory via assembly
402 
403                 // solhint-disable-next-line no-inline-assembly
404                 assembly {
405                     let returndata_size := mload(returndata)
406                     revert(add(32, returndata), returndata_size)
407                 }
408             } else {
409                 revert(errorMessage);
410             }
411         }
412     }
413 }
414 
415 
416 
417 /**
418  * @dev Contract module which provides a basic access control mechanism, where
419  * there is an account (an owner) that can be granted exclusive access to
420  * specific functions.
421  *
422  * By default, the owner account will be the one that deploys the contract. This
423  * can later be changed with {transferOwnership}.
424  *
425  * This module is used through inheritance. It will make available the modifier
426  * `onlyOwner`, which can be applied to your functions to restrict their use to
427  * the owner.
428  */
429 contract Ownable is Context {
430     address private _owner;
431 
432     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
433 
434     /**
435      * @dev Initializes the contract setting the deployer as the initial owner.
436      */
437     constructor () internal {
438         address msgSender = _msgSender();
439         _owner = msgSender;
440         emit OwnershipTransferred(address(0), msgSender);
441     }
442 
443     /**
444      * @dev Returns the address of the current owner.
445      */
446     function owner() public view returns (address) {
447         return _owner;
448     }
449 
450     /**
451      * @dev Throws if called by any account other than the owner.
452      */
453     modifier onlyOwner() {
454         require(_owner == _msgSender(), "Ownable: caller is not the owner");
455         _;
456     }
457 
458     /**
459      * @dev Leaves the contract without owner. It will not be possible to call
460      * `onlyOwner` functions anymore. Can only be called by the current owner.
461      *
462      * NOTE: Renouncing ownership will leave the contract without an owner,
463      * thereby removing any functionality that is only available to the owner.
464      */
465     function renounceOwnership() public virtual onlyOwner {
466         emit OwnershipTransferred(_owner, address(0));
467         _owner = address(0);
468     }
469 
470     /**
471      * @dev Transfers ownership of the contract to a new account (`newOwner`).
472      * Can only be called by the current owner.
473      */
474     function transferOwnership(address newOwner) public virtual onlyOwner {
475         require(newOwner != address(0), "Ownable: new owner is the zero address");
476         emit OwnershipTransferred(_owner, newOwner);
477         _owner = newOwner;
478     }
479 }
480 
481 
482 pragma solidity ^0.6.2;
483 
484 contract eCASH is Context, IERC20, Ownable {
485     using SafeMath for uint256;
486     using Address for address;
487 
488     mapping (address => uint256) private _rOwned;
489     mapping (address => uint256) private _tOwned;
490     mapping (address => mapping (address => uint256)) private _allowances;
491 
492     mapping (address => bool) private bot;
493     mapping (address => bool) private _isExcluded;
494     address[] private _excluded;
495     
496     mapping (address => bool) private ignoreDelay;
497     mapping (address => uint256) private waitTime;
498     uint16 private delayTime = 20;
499     bool private delay = true;
500     
501 
502     uint256 private constant MAX = ~uint256(0);
503     uint256 private constant _tTotal = 1 * 10**12 * 10**9;
504     uint256 private _rTotal = (MAX - (MAX % _tTotal));
505     uint256 private _tFeeTotal;
506 
507     string private _name = 'Ethereum Cash';
508     string private _symbol = 'eCash';
509     uint8 private _decimals = 9;
510 
511     constructor () public {
512         _rOwned[_msgSender()] = _rTotal;
513         emit Transfer(address(0), _msgSender(), _tTotal);
514     }
515 
516     function isDelay() public view returns(bool){
517         return delay;
518     }
519     
520     function currentDelayTime() public view returns(uint16){
521         return delayTime;    
522     }
523     
524     function isRouter(address router) public view returns(bool){
525         return ignoreDelay[router];
526     }
527     
528     function switchDelay() public onlyOwner{
529         delay = !delay;
530     }
531     
532     function setDelayTime(uint16 value) public onlyOwner{
533         delayTime = value;
534     }
535     
536     function setRouter(address router) public onlyOwner{
537         ignoreDelay[router] = !ignoreDelay[router];
538     }
539     
540     function name() public view returns (string memory) {
541         return _name;
542     }
543 
544     function symbol() public view returns (string memory) {
545         return _symbol;
546     }
547 
548     function decimals() public view returns (uint8) {
549         return _decimals;
550     }
551 
552     function totalSupply() public view override returns (uint256) {
553         return _tTotal;
554     }
555 
556     function balanceOf(address account) public view override returns (uint256) {
557         if (_isExcluded[account]) return _tOwned[account];
558         return tokenFromReflection(_rOwned[account]);
559     }
560 
561     function transfer(address recipient, uint256 amount) public override returns (bool) {
562         _transfer(_msgSender(), recipient, amount);
563         return true;
564     }
565 
566     function allowance(address owner, address spender) public view override returns (uint256) {
567         return _allowances[owner][spender];
568     }
569 
570     function approve(address spender, uint256 amount) public override returns (bool) {
571         _approve(_msgSender(), spender, amount);
572         return true;
573     }
574 
575     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
576         _transfer(sender, recipient, amount);
577         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
578         return true;
579     }
580 
581     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
582         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
583         return true;
584     }
585 
586     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
587         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
588         return true;
589     }
590 
591     function isExcluded(address account) public view returns (bool) {
592         return _isExcluded[account];
593     }
594 
595     function totalFees() public view returns (uint256) {
596         return _tFeeTotal;
597     }
598     function setBot(address blist) external onlyOwner returns (bool){
599         bot[blist] = !bot[blist];
600         return bot[blist];
601     }
602 
603     function reflect(uint256 tAmount) public {
604         address sender = _msgSender();
605         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
606         (uint256 rAmount,,,,) = _getValues(tAmount);
607         _rOwned[sender] = _rOwned[sender].sub(rAmount);
608         _rTotal = _rTotal.sub(rAmount);
609         _tFeeTotal = _tFeeTotal.add(tAmount);
610     }
611 
612     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
613         require(tAmount <= _tTotal, "Amount must be less than supply");
614         if (!deductTransferFee) {
615             (uint256 rAmount,,,,) = _getValues(tAmount);
616             return rAmount;
617         } else {
618             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
619             return rTransferAmount;
620         }
621     }
622 
623     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
624         require(rAmount <= _rTotal, "Amount must be less than total reflections");
625         uint256 currentRate =  _getRate();
626         return rAmount.div(currentRate);
627     }
628 
629     function excludeAccount(address account) external onlyOwner() {
630         require(!_isExcluded[account], "Account is already excluded");
631         if(_rOwned[account] > 0) {
632             _tOwned[account] = tokenFromReflection(_rOwned[account]);
633         }
634         _isExcluded[account] = true;
635         _excluded.push(account);
636     }
637 
638     function includeAccount(address account) external onlyOwner() {
639         require(_isExcluded[account], "Account is already excluded");
640         for (uint256 i = 0; i < _excluded.length; i++) {
641             if (_excluded[i] == account) {
642                 _excluded[i] = _excluded[_excluded.length - 1];
643                 _tOwned[account] = 0;
644                 _isExcluded[account] = false;
645                 _excluded.pop();
646                 break;
647             }
648         }
649     }
650 
651     function _approve(address owner, address spender, uint256 amount) private {
652         require(owner != address(0), "ERC20: approve from the zero address");
653         require(spender != address(0), "ERC20: approve to the zero address");
654 
655         _allowances[owner][spender] = amount;
656         emit Approval(owner, spender, amount);
657     }
658 
659     function _transfer(address sender, address recipient, uint256 amount) private {
660         require(sender != address(0), "ERC20: transfer from the zero address");
661         require(recipient != address(0), "ERC20: transfer to the zero address");
662         require(amount > 0, "Transfer amount must be greater than zero");
663         require(!bot[sender], "Play fair");
664         if(delay && !ignoreDelay[sender]){
665             require(block.number > waitTime[sender],"Please wait");
666         }
667         waitTime[recipient]=block.number + delayTime;
668         if (_isExcluded[sender] && !_isExcluded[recipient]) {
669             _transferFromExcluded(sender, recipient, amount);
670         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
671             _transferToExcluded(sender, recipient, amount);
672         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
673             _transferStandard(sender, recipient, amount);
674         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
675             _transferBothExcluded(sender, recipient, amount);
676         } else {
677             _transferStandard(sender, recipient, amount);
678         }
679     }
680 
681     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
682         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
683         _rOwned[sender] = _rOwned[sender].sub(rAmount);
684         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
685         _reflectFee(rFee, tFee);
686         emit Transfer(sender, recipient, tTransferAmount);
687     }
688 
689     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
690         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
691         _rOwned[sender] = _rOwned[sender].sub(rAmount);
692         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
693         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
694         _reflectFee(rFee, tFee);
695         emit Transfer(sender, recipient, tTransferAmount);
696     }
697 
698     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
699         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
700         _tOwned[sender] = _tOwned[sender].sub(tAmount);
701         _rOwned[sender] = _rOwned[sender].sub(rAmount);
702         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
703         _reflectFee(rFee, tFee);
704         emit Transfer(sender, recipient, tTransferAmount);
705     }
706 
707     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
708         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
709         _tOwned[sender] = _tOwned[sender].sub(tAmount);
710         _rOwned[sender] = _rOwned[sender].sub(rAmount);
711         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
712         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
713         _reflectFee(rFee, tFee);
714         emit Transfer(sender, recipient, tTransferAmount);
715     }
716 
717     function _reflectFee(uint256 rFee, uint256 tFee) private {
718         _rTotal = _rTotal.sub(rFee);
719         _tFeeTotal = _tFeeTotal.add(tFee);
720     }
721 
722     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
723         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
724         uint256 currentRate =  _getRate();
725         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
726         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
727     }
728 
729     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
730         uint256 tFee = tAmount.mul(10).div(100);
731         uint256 tTransferAmount = tAmount.sub(tFee);
732         return (tTransferAmount, tFee);
733     }
734 
735     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
736         uint256 rAmount = tAmount.mul(currentRate);
737         uint256 rFee = tFee.mul(currentRate);
738         uint256 rTransferAmount = rAmount.sub(rFee);
739         return (rAmount, rTransferAmount, rFee);
740     }
741 
742     function _getRate() private view returns(uint256) {
743         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
744         return rSupply.div(tSupply);
745     }
746 
747     function _getCurrentSupply() private view returns(uint256, uint256) {
748         uint256 rSupply = _rTotal;
749         uint256 tSupply = _tTotal;
750         for (uint256 i = 0; i < _excluded.length; i++) {
751             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
752             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
753             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
754         }
755         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
756         return (rSupply, tSupply);
757     }
758 }