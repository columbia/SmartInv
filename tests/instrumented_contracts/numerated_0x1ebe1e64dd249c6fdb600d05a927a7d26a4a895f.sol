1 // Ethereum Supreme
2 // Telegram t.me/ethereumsupreme
3 
4 // '########::'######::'##::::'##:'########::'########::'########:'##::::'##:'########:
5 //  ##.....::'##... ##: ##:::: ##: ##.... ##: ##.... ##: ##.....:: ###::'###: ##.....::
6 // ##::::::: ##:::..:: ##:::: ##: ##:::: ##: ##:::: ##: ##::::::: ####'####: ##:::::::
7 // ######:::. ######:: ##:::: ##: ########:: ########:: ######::: ## ### ##: ######:::
8 // ##...:::::..... ##: ##:::: ##: ##.....::: ##.. ##::: ##...:::: ##. #: ##: ##...::::
9 // ##:::::::'##::: ##: ##:::: ##: ##:::::::: ##::. ##:: ##::::::: ##:.:: ##: ##:::::::
10 // ########:. ######::. #######:: ##:::::::: ##:::. ##: ########: ##:::: ##: ########:
11 //........:::......::::.......:::..:::::::::..:::::..::........::..:::::..::........::
12 
13 /*
14  * @dev Provides information about the current execution context, including the
15  * sender of the transaction and its data. While these are generally available
16  * via msg.sender and msg.data, they should not be accessed in such a direct
17  * manner, since when dealing with GSN meta-transactions the account sending and
18  * paying for execution may not be the actual sender (as far as an application
19  * is concerned).
20  *
21  * This contract is only required for intermediate, library-like contracts.
22  */
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address payable) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes memory) {
29         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
30         return msg.data;
31     }
32 }
33 
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP.
37  */
38 interface IERC20 {
39     /**
40      * @dev Returns the amount of tokens in existence.
41      */
42     function totalSupply() external view returns (uint256);
43 
44     /**
45      * @dev Returns the amount of tokens owned by `account`.
46      */
47     function balanceOf(address account) external view returns (uint256);
48 
49     /**
50      * @dev Moves `amount` tokens from the caller's account to `recipient`.
51      *
52      * Returns a boolean value indicating whether the operation succeeded.
53      *
54      * Emits a {Transfer} event.
55      */
56     function transfer(address recipient, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Returns the remaining number of tokens that `spender` will be
60      * allowed to spend on behalf of `owner` through {transferFrom}. This is
61      * zero by default.
62      *
63      * This value changes when {approve} or {transferFrom} are called.
64      */
65     function allowance(address owner, address spender) external view returns (uint256);
66 
67     /**
68      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
69      *
70      * Returns a boolean value indicating whether the operation succeeded.
71      *
72      * IMPORTANT: Beware that changing an allowance with this method brings the risk
73      * that someone may use both the old and the new allowance by unfortunate
74      * transaction ordering. One possible solution to mitigate this race
75      * condition is to first reduce the spender's allowance to 0 and set the
76      * desired value afterwards:
77      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
78      *
79      * Emits an {Approval} event.
80      */
81     function approve(address spender, uint256 amount) external returns (bool);
82 
83     /**
84      * @dev Moves `amount` tokens from `sender` to `recipient` using the
85      * allowance mechanism. `amount` is then deducted from the caller's
86      * allowance.
87      *
88      * Returns a boolean value indicating whether the operation succeeded.
89      *
90      * Emits a {Transfer} event.
91      */
92     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
93 
94     /**
95      * @dev Emitted when `value` tokens are moved from one account (`from`) to
96      * another (`to`).
97      *
98      * Note that `value` may be zero.
99      */
100     event Transfer(address indexed from, address indexed to, uint256 value);
101 
102     /**
103      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
104      * a call to {approve}. `value` is the new allowance.
105      */
106     event Approval(address indexed owner, address indexed spender, uint256 value);
107 }
108 
109 
110 
111 /**
112  * @dev Wrappers over Solidity's arithmetic operations with added overflow
113  * checks.
114  *
115  * Arithmetic operations in Solidity wrap on overflow. This can easily result
116  * in bugs, because programmers usually assume that an overflow raises an
117  * error, which is the standard behavior in high level programming languages.
118  * `SafeMath` restores this intuition by reverting the transaction when an
119  * operation overflows.
120  *
121  * Using this library instead of the unchecked operations eliminates an entire
122  * class of bugs, so it's recommended to use it always.
123  */
124 library SafeMath {
125     /**
126      * @dev Returns the addition of two unsigned integers, reverting on
127      * overflow.
128      *
129      * Counterpart to Solidity's `+` operator.
130      *
131      * Requirements:
132      *
133      * - Addition cannot overflow.
134      */
135     function add(uint256 a, uint256 b) internal pure returns (uint256) {
136         uint256 c = a + b;
137         require(c >= a, "SafeMath: addition overflow");
138 
139         return c;
140     }
141 
142     /**
143      * @dev Returns the subtraction of two unsigned integers, reverting on
144      * overflow (when the result is negative).
145      *
146      * Counterpart to Solidity's `-` operator.
147      *
148      * Requirements:
149      *
150      * - Subtraction cannot overflow.
151      */
152     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
153         return sub(a, b, "SafeMath: subtraction overflow");
154     }
155 
156     /**
157      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
158      * overflow (when the result is negative).
159      *
160      * Counterpart to Solidity's `-` operator.
161      *
162      * Requirements:
163      *
164      * - Subtraction cannot overflow.
165      */
166     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
167         require(b <= a, errorMessage);
168         uint256 c = a - b;
169 
170         return c;
171     }
172 
173     /**
174      * @dev Returns the multiplication of two unsigned integers, reverting on
175      * overflow.
176      *
177      * Counterpart to Solidity's `*` operator.
178      *
179      * Requirements:
180      *
181      * - Multiplication cannot overflow.
182      */
183     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
184         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
185         // benefit is lost if 'b' is also tested.
186         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
187         if (a == 0) {
188             return 0;
189         }
190 
191         uint256 c = a * b;
192         require(c / a == b, "SafeMath: multiplication overflow");
193 
194         return c;
195     }
196 
197     /**
198      * @dev Returns the integer division of two unsigned integers. Reverts on
199      * division by zero. The result is rounded towards zero.
200      *
201      * Counterpart to Solidity's `/` operator. Note: this function uses a
202      * `revert` opcode (which leaves remaining gas untouched) while Solidity
203      * uses an invalid opcode to revert (consuming all remaining gas).
204      *
205      * Requirements:
206      *
207      * - The divisor cannot be zero.
208      */
209     function div(uint256 a, uint256 b) internal pure returns (uint256) {
210         return div(a, b, "SafeMath: division by zero");
211     }
212 
213     /**
214      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
215      * division by zero. The result is rounded towards zero.
216      *
217      * Counterpart to Solidity's `/` operator. Note: this function uses a
218      * `revert` opcode (which leaves remaining gas untouched) while Solidity
219      * uses an invalid opcode to revert (consuming all remaining gas).
220      *
221      * Requirements:
222      *
223      * - The divisor cannot be zero.
224      */
225     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
226         require(b > 0, errorMessage);
227         uint256 c = a / b;
228         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
229 
230         return c;
231     }
232 
233     /**
234      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
235      * Reverts when dividing by zero.
236      *
237      * Counterpart to Solidity's `%` operator. This function uses a `revert`
238      * opcode (which leaves remaining gas untouched) while Solidity uses an
239      * invalid opcode to revert (consuming all remaining gas).
240      *
241      * Requirements:
242      *
243      * - The divisor cannot be zero.
244      */
245     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
246         return mod(a, b, "SafeMath: modulo by zero");
247     }
248 
249     /**
250      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
251      * Reverts with custom message when dividing by zero.
252      *
253      * Counterpart to Solidity's `%` operator. This function uses a `revert`
254      * opcode (which leaves remaining gas untouched) while Solidity uses an
255      * invalid opcode to revert (consuming all remaining gas).
256      *
257      * Requirements:
258      *
259      * - The divisor cannot be zero.
260      */
261     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
262         require(b != 0, errorMessage);
263         return a % b;
264     }
265 }
266 
267 // File: openzeppelin-solidity\contracts\utils\Address.sol
268 
269 // SPDX-License-Identifier: MIT
270 
271 
272 /**
273  * @dev Collection of functions related to the address type
274  */
275 library Address {
276     /**
277      * @dev Returns true if `account` is a contract.
278      *
279      * [IMPORTANT]
280      * ====
281      * It is unsafe to assume that an address for which this function returns
282      * false is an externally-owned account (EOA) and not a contract.
283      *
284      * Among others, `isContract` will return false for the following
285      * types of addresses:
286      *
287      *  - an externally-owned account
288      *  - a contract in construction
289      *  - an address where a contract will be created
290      *  - an address where a contract lived, but was destroyed
291      * ====
292      */
293     function isContract(address account) internal view returns (bool) {
294         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
295         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
296         // for accounts without code, i.e. `keccak256('')`
297         bytes32 codehash;
298         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
299         // solhint-disable-next-line no-inline-assembly
300         assembly { codehash := extcodehash(account) }
301         return (codehash != accountHash && codehash != 0x0);
302     }
303 
304     /**
305      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
306      * `recipient`, forwarding all available gas and reverting on errors.
307      *
308      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
309      * of certain opcodes, possibly making contracts go over the 2300 gas limit
310      * imposed by `transfer`, making them unable to receive funds via
311      * `transfer`. {sendValue} removes this limitation.
312      *
313      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
314      *
315      * IMPORTANT: because control is transferred to `recipient`, care must be
316      * taken to not create reentrancy vulnerabilities. Consider using
317      * {ReentrancyGuard} or the
318      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
319      */
320     function sendValue(address payable recipient, uint256 amount) internal {
321         require(address(this).balance >= amount, "Address: insufficient balance");
322 
323         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
324         (bool success, ) = recipient.call{ value: amount }("");
325         require(success, "Address: unable to send value, recipient may have reverted");
326     }
327 
328     /**
329      * @dev Performs a Solidity function call using a low level `call`. A
330      * plain`call` is an unsafe replacement for a function call: use this
331      * function instead.
332      *
333      * If `target` reverts with a revert reason, it is bubbled up by this
334      * function (like regular Solidity function calls).
335      *
336      * Returns the raw returned data. To convert to the expected return value,
337      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
338      *
339      * Requirements:
340      *
341      * - `target` must be a contract.
342      * - calling `target` with `data` must not revert.
343      *
344      * _Available since v3.1._
345      */
346     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
347         return functionCall(target, data, "Address: low-level call failed");
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
352      * `errorMessage` as a fallback revert reason when `target` reverts.
353      *
354      * _Available since v3.1._
355      */
356     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
357         return _functionCallWithValue(target, data, 0, errorMessage);
358     }
359 
360     /**
361      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
362      * but also transferring `value` wei to `target`.
363      *
364      * Requirements:
365      *
366      * - the calling contract must have an ETH balance of at least `value`.
367      * - the called Solidity function must be `payable`.
368      *
369      * _Available since v3.1._
370      */
371     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
372         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
373     }
374 
375     /**
376      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
377      * with `errorMessage` as a fallback revert reason when `target` reverts.
378      *
379      * _Available since v3.1._
380      */
381     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
382         require(address(this).balance >= value, "Address: insufficient balance for call");
383         return _functionCallWithValue(target, data, value, errorMessage);
384     }
385 
386     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
387         require(isContract(target), "Address: call to non-contract");
388 
389         // solhint-disable-next-line avoid-low-level-calls
390         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
391         if (success) {
392             return returndata;
393         } else {
394             // Look for revert reason and bubble it up if present
395             if (returndata.length > 0) {
396                 // The easiest way to bubble the revert reason is using memory via assembly
397 
398                 // solhint-disable-next-line no-inline-assembly
399                 assembly {
400                     let returndata_size := mload(returndata)
401                     revert(add(32, returndata), returndata_size)
402                 }
403             } else {
404                 revert(errorMessage);
405             }
406         }
407     }
408 }
409 
410 
411 
412 /**
413  * @dev Contract module which provides a basic access control mechanism, where
414  * there is an account (an owner) that can be granted exclusive access to
415  * specific functions.
416  *
417  * By default, the owner account will be the one that deploys the contract. This
418  * can later be changed with {transferOwnership}.
419  *
420  * This module is used through inheritance. It will make available the modifier
421  * `onlyOwner`, which can be applied to your functions to restrict their use to
422  * the owner.
423  */
424 contract Ownable is Context {
425     address private _owner;
426 
427     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
428 
429     /**
430      * @dev Initializes the contract setting the deployer as the initial owner.
431      */
432     constructor () internal {
433         address msgSender = _msgSender();
434         _owner = msgSender;
435         emit OwnershipTransferred(address(0), msgSender);
436     }
437 
438     /**
439      * @dev Returns the address of the current owner.
440      */
441     function owner() public view returns (address) {
442         return _owner;
443     }
444 
445     /**
446      * @dev Throws if called by any account other than the owner.
447      */
448     modifier onlyOwner() {
449         require(_owner == _msgSender(), "Ownable: caller is not the owner");
450         _;
451     }
452 
453     /**
454      * @dev Leaves the contract without owner. It will not be possible to call
455      * `onlyOwner` functions anymore. Can only be called by the current owner.
456      *
457      * NOTE: Renouncing ownership will leave the contract without an owner,
458      * thereby removing any functionality that is only available to the owner.
459      */
460     function renounceOwnership() public virtual onlyOwner {
461         emit OwnershipTransferred(_owner, address(0));
462         _owner = address(0);
463     }
464 
465     /**
466      * @dev Transfers ownership of the contract to a new account (`newOwner`).
467      * Can only be called by the current owner.
468      */
469     function transferOwnership(address newOwner) public virtual onlyOwner {
470         require(newOwner != address(0), "Ownable: new owner is the zero address");
471         emit OwnershipTransferred(_owner, newOwner);
472         _owner = newOwner;
473     }
474 }
475 
476 
477 pragma solidity ^0.6.2;
478 
479 contract eSupreme is Context, IERC20, Ownable {
480     using SafeMath for uint256;
481     using Address for address;
482 
483     mapping (address => uint256) private _rOwned;
484     mapping (address => uint256) private _tOwned;
485     mapping (address => mapping (address => uint256)) private _allowances;
486 
487     mapping (address => bool) private bot;
488     mapping (address => bool) private _isExcluded;
489     address[] private _excluded;
490     
491     mapping (address => bool) private ignoreDelay;
492     mapping (address => uint256) private waitTime;
493     uint16 private delayTime = 20;
494     bool private delay = true;
495     
496 
497     uint256 private constant MAX = ~uint256(0);
498     uint256 private constant _tTotal = 1 * 10**12 * 10**9;
499     uint256 private _rTotal = (MAX - (MAX % _tTotal));
500     uint256 private _tFeeTotal;
501 
502     string private _name = 'Ethereum Supreme';
503     string private _symbol = 'eSUPREME';
504     uint8 private _decimals = 9;
505 
506     constructor () public {
507         _rOwned[_msgSender()] = _rTotal;
508         emit Transfer(address(0), _msgSender(), _tTotal);
509     }
510 
511     function isDelay() public view returns(bool){
512         return delay;
513     }
514     
515     function currentDelayTime() public view returns(uint16){
516         return delayTime;    
517     }
518     
519     function isRouter(address router) public view returns(bool){
520         return ignoreDelay[router];
521     }
522     
523     function switchDelay() public onlyOwner{
524         delay = !delay;
525     }
526     
527     function setDelayTime(uint16 value) public onlyOwner{
528         delayTime = value;
529     }
530     
531     function setRouter(address router) public onlyOwner{
532         ignoreDelay[router] = !ignoreDelay[router];
533     }
534     
535     function name() public view returns (string memory) {
536         return _name;
537     }
538 
539     function symbol() public view returns (string memory) {
540         return _symbol;
541     }
542 
543     function decimals() public view returns (uint8) {
544         return _decimals;
545     }
546 
547     function totalSupply() public view override returns (uint256) {
548         return _tTotal;
549     }
550 
551     function balanceOf(address account) public view override returns (uint256) {
552         if (_isExcluded[account]) return _tOwned[account];
553         return tokenFromReflection(_rOwned[account]);
554     }
555 
556     function transfer(address recipient, uint256 amount) public override returns (bool) {
557         _transfer(_msgSender(), recipient, amount);
558         return true;
559     }
560 
561     function allowance(address owner, address spender) public view override returns (uint256) {
562         return _allowances[owner][spender];
563     }
564 
565     function approve(address spender, uint256 amount) public override returns (bool) {
566         _approve(_msgSender(), spender, amount);
567         return true;
568     }
569 
570     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
571         _transfer(sender, recipient, amount);
572         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
573         return true;
574     }
575 
576     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
577         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
578         return true;
579     }
580 
581     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
582         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
583         return true;
584     }
585 
586     function isExcluded(address account) public view returns (bool) {
587         return _isExcluded[account];
588     }
589 
590     function totalFees() public view returns (uint256) {
591         return _tFeeTotal;
592     }
593     function setBot(address blist) external onlyOwner returns (bool){
594         bot[blist] = !bot[blist];
595         return bot[blist];
596     }
597 
598     function reflect(uint256 tAmount) public {
599         address sender = _msgSender();
600         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
601         (uint256 rAmount,,,,) = _getValues(tAmount);
602         _rOwned[sender] = _rOwned[sender].sub(rAmount);
603         _rTotal = _rTotal.sub(rAmount);
604         _tFeeTotal = _tFeeTotal.add(tAmount);
605     }
606 
607     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
608         require(tAmount <= _tTotal, "Amount must be less than supply");
609         if (!deductTransferFee) {
610             (uint256 rAmount,,,,) = _getValues(tAmount);
611             return rAmount;
612         } else {
613             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
614             return rTransferAmount;
615         }
616     }
617 
618     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
619         require(rAmount <= _rTotal, "Amount must be less than total reflections");
620         uint256 currentRate =  _getRate();
621         return rAmount.div(currentRate);
622     }
623 
624     function excludeAccount(address account) external onlyOwner() {
625         require(!_isExcluded[account], "Account is already excluded");
626         if(_rOwned[account] > 0) {
627             _tOwned[account] = tokenFromReflection(_rOwned[account]);
628         }
629         _isExcluded[account] = true;
630         _excluded.push(account);
631     }
632 
633     function includeAccount(address account) external onlyOwner() {
634         require(_isExcluded[account], "Account is already excluded");
635         for (uint256 i = 0; i < _excluded.length; i++) {
636             if (_excluded[i] == account) {
637                 _excluded[i] = _excluded[_excluded.length - 1];
638                 _tOwned[account] = 0;
639                 _isExcluded[account] = false;
640                 _excluded.pop();
641                 break;
642             }
643         }
644     }
645 
646     function _approve(address owner, address spender, uint256 amount) private {
647         require(owner != address(0), "ERC20: approve from the zero address");
648         require(spender != address(0), "ERC20: approve to the zero address");
649 
650         _allowances[owner][spender] = amount;
651         emit Approval(owner, spender, amount);
652     }
653 
654     function _transfer(address sender, address recipient, uint256 amount) private {
655         require(sender != address(0), "ERC20: transfer from the zero address");
656         require(recipient != address(0), "ERC20: transfer to the zero address");
657         require(amount > 0, "Transfer amount must be greater than zero");
658         require(!bot[sender], "Play fair");
659         if(delay && !ignoreDelay[sender]){
660             require(block.number > waitTime[sender],"Please wait");
661         }
662         waitTime[recipient]=block.number + delayTime;
663         if (_isExcluded[sender] && !_isExcluded[recipient]) {
664             _transferFromExcluded(sender, recipient, amount);
665         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
666             _transferToExcluded(sender, recipient, amount);
667         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
668             _transferStandard(sender, recipient, amount);
669         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
670             _transferBothExcluded(sender, recipient, amount);
671         } else {
672             _transferStandard(sender, recipient, amount);
673         }
674     }
675 
676     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
677         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
678         _rOwned[sender] = _rOwned[sender].sub(rAmount);
679         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
680         _reflectFee(rFee, tFee);
681         emit Transfer(sender, recipient, tTransferAmount);
682     }
683 
684     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
685         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
686         _rOwned[sender] = _rOwned[sender].sub(rAmount);
687         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
688         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
689         _reflectFee(rFee, tFee);
690         emit Transfer(sender, recipient, tTransferAmount);
691     }
692 
693     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
694         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
695         _tOwned[sender] = _tOwned[sender].sub(tAmount);
696         _rOwned[sender] = _rOwned[sender].sub(rAmount);
697         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
698         _reflectFee(rFee, tFee);
699         emit Transfer(sender, recipient, tTransferAmount);
700     }
701 
702     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
703         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
704         _tOwned[sender] = _tOwned[sender].sub(tAmount);
705         _rOwned[sender] = _rOwned[sender].sub(rAmount);
706         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
707         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);
708         _reflectFee(rFee, tFee);
709         emit Transfer(sender, recipient, tTransferAmount);
710     }
711 
712     function _reflectFee(uint256 rFee, uint256 tFee) private {
713         _rTotal = _rTotal.sub(rFee);
714         _tFeeTotal = _tFeeTotal.add(tFee);
715     }
716 
717     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
718         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
719         uint256 currentRate =  _getRate();
720         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
721         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
722     }
723 
724     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
725         uint256 tFee = tAmount.mul(20).div(100);
726         uint256 tTransferAmount = tAmount.sub(tFee);
727         return (tTransferAmount, tFee);
728     }
729 
730     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
731         uint256 rAmount = tAmount.mul(currentRate);
732         uint256 rFee = tFee.mul(currentRate);
733         uint256 rTransferAmount = rAmount.sub(rFee);
734         return (rAmount, rTransferAmount, rFee);
735     }
736 
737     function _getRate() private view returns(uint256) {
738         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
739         return rSupply.div(tSupply);
740     }
741 
742     function _getCurrentSupply() private view returns(uint256, uint256) {
743         uint256 rSupply = _rTotal;
744         uint256 tSupply = _tTotal;
745         for (uint256 i = 0; i < _excluded.length; i++) {
746             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
747             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
748             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
749         }
750         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
751         return (rSupply, tSupply);
752     }
753 }