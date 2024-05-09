1 //
2 //
3 //     ▄▄▄       ███▄    █  ▒█████   ███▄    █▓██   ██▓ ███▄ ▄███▓ ▒█████   █    ██   ██████ 
4 //    ▒████▄     ██ ▀█   █ ▒██▒  ██▒ ██ ▀█   █ ▒██  ██▒▓██▒▀█▀ ██▒▒██▒  ██▒ ██  ▓██▒▒██    ▒ 
5 //    ▒██  ▀█▄  ▓██  ▀█ ██▒▒██░  ██▒▓██  ▀█ ██▒ ▒██ ██░▓██    ▓██░▒██░  ██▒▓██  ▒██░░ ▓██▄   
6 //    ░██▄▄▄▄██ ▓██▒  ▐▌██▒▒██   ██░▓██▒  ▐▌██▒ ░ ▐██▓░▒██    ▒██ ▒██   ██░▓▓█  ░██░  ▒   ██▒
7 //    ▓█   ▓██▒▒██░   ▓██░░ ████▓▒░▒██░   ▓██░ ░ ██▒▓░▒██▒   ░██▒░ ████▓▒░▒▒█████▓ ▒██████▒▒
8 //    ▒▒   ▓▒█░░ ▒░   ▒ ▒ ░ ▒░▒░▒░ ░ ▒░   ▒ ▒   ██▒▒▒ ░ ▒░   ░  ░░ ▒░▒░▒░ ░▒▓▒ ▒ ▒ ▒ ▒▓▒ ▒ ░
9 //    ▒   ▒▒ ░░ ░░   ░ ▒░  ░ ▒ ▒░ ░ ░░   ░ ▒░▓██ ░▒░ ░  ░      ░  ░ ▒ ▒░ ░░▒░ ░ ░ ░ ░▒  ░ ░
10 //    ░   ▒      ░   ░ ░ ░ ░ ░ ▒     ░   ░ ░ ▒ ▒ ░░  ░      ░   ░ ░ ░ ▒   ░░░ ░ ░ ░  ░  ░  
11 //        ░  ░         ░     ░ ░           ░ ░ ░            ░       ░ ░     ░           ░  
12 //                                         ░ ░                                           
13 //
14 
15 
16 // SPDX-License-Identifier: MIT
17 
18 pragma solidity ^0.6.12;
19 
20 
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address payable) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes memory) {
27         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
28         return msg.data;
29     }
30 }
31 
32 /**
33  * @dev Interface of the BEP20 standard as defined in the EIP.
34  */
35 interface IBEP20 {
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
106 /**
107  * @dev Wrappers over Solidity's arithmetic operations with added overflow
108  * checks.
109  *
110  * Arithmetic operations in Solidity wrap on overflow. This can easily result
111  * in bugs, because programmers usually assume that an overflow raises an
112  * error, which is the standard behavior in high level programming languages.
113  * `SafeMath` restores this intuition by reverting the transaction when an
114  * operation overflows.
115  *
116  * Using this library instead of the unchecked operations eliminates an entire
117  * class of bugs, so it's recommended to use it always.
118  */
119 library SafeMath {
120     /**
121      * @dev Returns the addition of two unsigned integers, reverting on
122      * overflow.
123      *
124      * Counterpart to Solidity's `+` operator.
125      *
126      * Requirements:
127      *
128      * - Addition cannot overflow.
129      */
130     function add(uint256 a, uint256 b) internal pure returns (uint256) {
131         uint256 c = a + b;
132         require(c >= a, "SafeMath: addition overflow");
133 
134         return c;
135     }
136 
137     /**
138      * @dev Returns the subtraction of two unsigned integers, reverting on
139      * overflow (when the result is negative).
140      *
141      * Counterpart to Solidity's `-` operator.
142      *
143      * Requirements:
144      *
145      * - Subtraction cannot overflow.
146      */
147     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
148         return sub(a, b, "SafeMath: subtraction overflow");
149     }
150 
151     /**
152      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
153      * overflow (when the result is negative).
154      *
155      * Counterpart to Solidity's `-` operator.
156      *
157      * Requirements:
158      *
159      * - Subtraction cannot overflow.
160      */
161     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
162         require(b <= a, errorMessage);
163         uint256 c = a - b;
164 
165         return c;
166     }
167 
168     /**
169      * @dev Returns the multiplication of two unsigned integers, reverting on
170      * overflow.
171      *
172      * Counterpart to Solidity's `*` operator.
173      *
174      * Requirements:
175      *
176      * - Multiplication cannot overflow.
177      */
178     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
179         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
180         // benefit is lost if 'b' is also tested.
181         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
182         if (a == 0) {
183             return 0;
184         }
185 
186         uint256 c = a * b;
187         require(c / a == b, "SafeMath: multiplication overflow");
188 
189         return c;
190     }
191 
192     /**
193      * @dev Returns the integer division of two unsigned integers. Reverts on
194      * division by zero. The result is rounded towards zero.
195      *
196      * Counterpart to Solidity's `/` operator. Note: this function uses a
197      * `revert` opcode (which leaves remaining gas untouched) while Solidity
198      * uses an invalid opcode to revert (consuming all remaining gas).
199      *
200      * Requirements:
201      *
202      * - The divisor cannot be zero.
203      */
204     function div(uint256 a, uint256 b) internal pure returns (uint256) {
205         return div(a, b, "SafeMath: division by zero");
206     }
207 
208     /**
209      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
210      * division by zero. The result is rounded towards zero.
211      *
212      * Counterpart to Solidity's `/` operator. Note: this function uses a
213      * `revert` opcode (which leaves remaining gas untouched) while Solidity
214      * uses an invalid opcode to revert (consuming all remaining gas).
215      *
216      * Requirements:
217      *
218      * - The divisor cannot be zero.
219      */
220     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
221         require(b > 0, errorMessage);
222         uint256 c = a / b;
223         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
224 
225         return c;
226     }
227 
228     /**
229      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
230      * Reverts when dividing by zero.
231      *
232      * Counterpart to Solidity's `%` operator. This function uses a `revert`
233      * opcode (which leaves remaining gas untouched) while Solidity uses an
234      * invalid opcode to revert (consuming all remaining gas).
235      *
236      * Requirements:
237      *
238      * - The divisor cannot be zero.
239      */
240     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
241         return mod(a, b, "SafeMath: modulo by zero");
242     }
243 
244     /**
245      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
246      * Reverts with custom message when dividing by zero.
247      *
248      * Counterpart to Solidity's `%` operator. This function uses a `revert`
249      * opcode (which leaves remaining gas untouched) while Solidity uses an
250      * invalid opcode to revert (consuming all remaining gas).
251      *
252      * Requirements:
253      *
254      * - The divisor cannot be zero.
255      */
256     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
257         require(b != 0, errorMessage);
258         return a % b;
259     }
260 }
261 
262 /**
263  * @dev Collection of functions related to the address type
264  */
265 library Address {
266     /**
267      * @dev Returns true if `account` is a contract.
268      *
269      * [IMPORTANT]
270      * ====
271      * It is unsafe to assume that an address for which this function returns
272      * false is an externally-owned account (EOA) and not a contract.
273      *
274      * Among others, `isContract` will return false for the following
275      * types of addresses:
276      *
277      *  - an externally-owned account
278      *  - a contract in construction
279      *  - an address where a contract will be created
280      *  - an address where a contract lived, but was destroyed
281      * ====
282      */
283     function isContract(address account) internal view returns (bool) {
284         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
285         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
286         // for accounts without code, i.e. `keccak256('')`
287         bytes32 codehash;
288         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
289         // solhint-disable-next-line no-inline-assembly
290         assembly { codehash := extcodehash(account) }
291         return (codehash != accountHash && codehash != 0x0);
292     }
293 
294     /**
295      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
296      * `recipient`, forwarding all available gas and reverting on errors.
297      *
298      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
299      * of certain opcodes, possibly making contracts go over the 2300 gas limit
300      * imposed by `transfer`, making them unable to receive funds via
301      * `transfer`. {sendValue} removes this limitation.
302      *
303      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
304      *
305      * IMPORTANT: because control is transferred to `recipient`, care must be
306      * taken to not create reentrancy vulnerabilities. Consider using
307      * {ReentrancyGuard} or the
308      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
309      */
310     function sendValue(address payable recipient, uint256 amount) internal {
311         require(address(this).balance >= amount, "Address: insufficient balance");
312 
313         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
314         (bool success, ) = recipient.call{ value: amount }("");
315         require(success, "Address: unable to send value, recipient may have reverted");
316     }
317 
318     /**
319      * @dev Performs a Solidity function call using a low level `call`. A
320      * plain`call` is an unsafe replacement for a function call: use this
321      * function instead.
322      *
323      * If `target` reverts with a revert reason, it is bubbled up by this
324      * function (like regular Solidity function calls).
325      *
326      * Returns the raw returned data. To convert to the expected return value,
327      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
328      *
329      * Requirements:
330      *
331      * - `target` must be a contract.
332      * - calling `target` with `data` must not revert.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
337       return functionCall(target, data, "Address: low-level call failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
342      * `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
347         return _functionCallWithValue(target, data, 0, errorMessage);
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
352      * but also transferring `value` wei to `target`.
353      *
354      * Requirements:
355      *
356      * - the calling contract must have an ETH balance of at least `value`.
357      * - the called Solidity function must be `payable`.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
362         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
367      * with `errorMessage` as a fallback revert reason when `target` reverts.
368      *
369      * _Available since v3.1._
370      */
371     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
372         require(address(this).balance >= value, "Address: insufficient balance for call");
373         return _functionCallWithValue(target, data, value, errorMessage);
374     }
375 
376     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
377         require(isContract(target), "Address: call to non-contract");
378 
379         // solhint-disable-next-line avoid-low-level-calls
380         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
381         if (success) {
382             return returndata;
383         } else {
384             // Look for revert reason and bubble it up if present
385             if (returndata.length > 0) {
386                 // The easiest way to bubble the revert reason is using memory via assembly
387 
388                 // solhint-disable-next-line no-inline-assembly
389                 assembly {
390                     let returndata_size := mload(returndata)
391                     revert(add(32, returndata), returndata_size)
392                 }
393             } else {
394                 revert(errorMessage);
395             }
396         }
397     }
398 }
399 
400 /**
401  * @dev Contract module which provides a basic access control mechanism, where
402  * there is an account (an owner) that can be granted exclusive access to
403  * specific functions.
404  *
405  * By default, the owner account will be the one that deploys the contract. This
406  * can later be changed with {transferOwnership}.
407  *
408  * This module is used through inheritance. It will make available the modifier
409  * `onlyOwner`, which can be applied to your functions to restrict their use to
410  * the owner.
411  */
412 contract Ownable is Context {
413     address private _owner;
414 
415     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
416 
417     /**
418      * @dev Initializes the contract setting the deployer as the initial owner.
419      */
420     constructor () internal {
421         address msgSender = _msgSender();
422         _owner = msgSender;
423         emit OwnershipTransferred(address(0), msgSender);
424     }
425 
426     /**
427      * @dev Returns the address of the current owner.
428      */
429     function owner() public view returns (address) {
430         return _owner;
431     }
432 
433     /**
434      * @dev Throws if called by any account other than the owner.
435      */
436     modifier onlyOwner() {
437         require(_owner == _msgSender(), "Ownable: caller is not the owner");
438         _;
439     }
440 
441     /**
442      * @dev Leaves the contract without owner. It will not be possible to call
443      * `onlyOwner` functions anymore. Can only be called by the current owner.
444      *
445      * NOTE: Renouncing ownership will leave the contract without an owner,
446      * thereby removing any functionality that is only available to the owner.
447      */
448     function renounceOwnership() public virtual onlyOwner {
449         emit OwnershipTransferred(_owner, address(0));
450         _owner = address(0);
451     }
452 
453     /**
454      * @dev Transfers ownership of the contract to a new account (`newOwner`).
455      * Can only be called by the current owner.
456      */
457     function transferOwnership(address newOwner) public virtual onlyOwner {
458         require(newOwner != address(0), "Ownable: new owner is the zero address");
459         emit OwnershipTransferred(_owner, newOwner);
460         _owner = newOwner;
461     }
462 }
463 
464 contract Anonymous is Context, IBEP20, Ownable {
465     using SafeMath for uint256;
466     using Address for address;
467 
468     mapping (address => uint256) private _rOwned;
469     mapping (address => uint256) private _tOwned;
470     mapping (address => mapping (address => uint256)) private _allowances;
471     
472     //added now
473     mapping (address => bool) private bot; 
474     
475     mapping (address => bool) private _isExcluded;
476     address[] private _excluded;
477     
478     string  private constant _NAME = 'Anonymous';
479     string  private constant _SYMBOL = 'ANON';
480     uint8   private constant _DECIMALS = 8;
481    
482     uint256 private constant _MAX = ~uint256(0);
483     uint256 private constant _DECIMALFACTOR = 10 ** uint256(_DECIMALS);
484     uint256 private constant _GRANULARITY = 100;
485     
486     uint256 private _tTotal = 1000000000000 * _DECIMALFACTOR;
487     uint256 private _rTotal = (_MAX - (_MAX % _tTotal));
488     
489     uint256 private _tFeeTotal;
490     uint256 private _tBurnTotal;
491     
492     uint256 private constant     _TAX_FEE = 100;
493     uint256 private constant    _BURN_FEE = 100;
494     uint256 private _MAX_TX_SIZE = 100000000 * _DECIMALFACTOR;
495     
496     bool public tradingEnabled = false;
497     address private LiquidityAddress;
498     uint256 private _MAX_WT_SIZE = 200000000 * _DECIMALFACTOR;
499     
500     uint256 public _marketingFee = 100;
501     address public marketingWallet = 0x990aad404b5eeA860255285F4f1B445d1Ee4C8Ec;
502     uint256 private _previousmarketingFee = _marketingFee;
503     
504     constructor () public {
505         _rOwned[_msgSender()] = _rTotal;
506         emit Transfer(address(0), _msgSender(), _tTotal);
507     }
508 
509     function name() public view returns (string memory) {
510         return _NAME;
511     }
512 
513     function symbol() public view returns (string memory) {
514         return _SYMBOL;
515     }
516 
517     function decimals() public view returns (uint8) {
518         return _DECIMALS;
519     }
520 
521     function totalSupply() public view override returns (uint256) {
522         return _tTotal;
523     }
524 
525     function balanceOf(address account) public view override returns (uint256) {
526         if (_isExcluded[account]) return _tOwned[account];
527         return tokenFromReflection(_rOwned[account]);
528     }
529 
530     function transfer(address recipient, uint256 amount) public override returns (bool) {
531         _transfer(_msgSender(), recipient, amount);
532         return true;
533     }
534 
535     function allowance(address owner, address spender) public view override returns (uint256) {
536         return _allowances[owner][spender];
537     }
538 
539     function approve(address spender, uint256 amount) public override returns (bool) {
540         _approve(_msgSender(), spender, amount);
541         return true;
542     }
543 
544     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
545         _transfer(sender, recipient, amount);
546         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "BEP20: transfer amount exceeds allowance"));
547         return true;
548     }
549 
550     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
551         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
552         return true;
553     }
554 
555     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
556         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "BEP20: decreased allowance below zero"));
557         return true;
558     }
559 
560     function isExcluded(address account) public view returns (bool) {
561         return _isExcluded[account];
562     }
563 
564     function totalFees() public view returns (uint256) {
565         return _tFeeTotal;
566     }
567     
568     function totalBurn() public view returns (uint256) {
569         return _tBurnTotal;
570     }
571 
572     //added this
573     function setBot(address blist) external onlyOwner returns (bool){
574         bot[blist] = !bot[blist];
575         return bot[blist];
576     }
577 
578     function deliver(uint256 tAmount) public {
579         address sender = _msgSender();
580         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
581         (uint256 rAmount,,,,,) = _getValues(tAmount);
582         _rOwned[sender] = _rOwned[sender].sub(rAmount);
583         _rTotal = _rTotal.sub(rAmount);
584         _tFeeTotal = _tFeeTotal.add(tAmount);
585     }
586 
587     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
588         require(tAmount <= _tTotal, "Amount must be less than supply");
589         if (!deductTransferFee) {
590             (uint256 rAmount,,,,,) = _getValues(tAmount);
591             return rAmount;
592         } else {
593             (,uint256 rTransferAmount,,,,) = _getValues(tAmount);
594             return rTransferAmount;
595         }
596     }
597 
598     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
599         require(rAmount <= _rTotal, "Amount must be less than total reflections");
600         uint256 currentRate =  _getRate();
601         return rAmount.div(currentRate);
602     }
603 
604     function excludeAccount(address account) external onlyOwner() {
605         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D, 'We can not exclude Uniswap router.');
606         require(account != 0x73feaa1eE314F8c655E354234017bE2193C9E24E, 'We can not exclude Pancake router.');
607         require(!_isExcluded[account], "Account is already excluded");
608         if(_rOwned[account] > 0) {
609             _tOwned[account] = tokenFromReflection(_rOwned[account]);
610         }
611         _isExcluded[account] = true;
612         _excluded.push(account);
613     }
614 
615     function includeAccount(address account) external onlyOwner() {
616         require(_isExcluded[account], "Account is already excluded");
617         for (uint256 i = 0; i < _excluded.length; i++) {
618             if (_excluded[i] == account) {
619                 _excluded[i] = _excluded[_excluded.length - 1];
620                 _tOwned[account] = 0;
621                 _isExcluded[account] = false;
622                 _excluded.pop();
623                 break;
624             }
625         }
626     }
627 
628     function _approve(address owner, address spender, uint256 amount) private {
629         require(owner != address(0), "BEP20: approve from the zero address");
630         require(spender != address(0), "BEP20: approve to the zero address");
631 
632         _allowances[owner][spender] = amount;
633         emit Approval(owner, spender, amount);
634     }
635 
636     function _transfer(address sender, address recipient, uint256 amount) private {
637         require(sender != address(0), "BEP20: transfer from the zero address");
638         require(recipient != address(0), "BEP20: transfer to the zero address");
639         require(amount > 0, "Transfer amount must be greater than zero");
640 
641         if(sender != owner() && recipient != owner()){
642             require(amount <= _MAX_TX_SIZE, "Transfer amount exceeds the maxTxAmount.");
643             require(!bot[sender], "Play fair");
644             require(!bot[recipient], "Play fair");
645             if (recipient != LiquidityAddress) {
646                  require(balanceOf(recipient) + amount <= _MAX_WT_SIZE, "Transfer amount exceeds the maxWtAmount.");
647             }
648         }
649         
650         if (sender != owner()) {
651             require(tradingEnabled, "Trading is not enabled yet");
652         }
653         
654         _previousmarketingFee = _marketingFee;
655         uint256 marketingAmt = amount.mul(_marketingFee).div(_GRANULARITY).div(100);
656             
657         if (_isExcluded[sender] && !_isExcluded[recipient]) {
658             _transferFromExcluded(sender, recipient, amount.sub(marketingAmt));
659         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
660             _transferToExcluded(sender, recipient, amount.sub(marketingAmt));
661         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
662             _transferStandard(sender, recipient, amount.sub(marketingAmt));
663         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
664             _transferBothExcluded(sender, recipient, amount.sub(marketingAmt));
665         } else {
666             _transferStandard(sender, recipient, amount.sub(marketingAmt));
667         }
668         
669         //temporarily remove marketing fees
670         _marketingFee = 0;
671         _transferStandard(sender, marketingWallet, marketingAmt);
672         _marketingFee = _previousmarketingFee;
673     }
674 
675     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
676         uint256 currentRate =  _getRate();
677         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
678         uint256 rBurn =  tBurn.mul(currentRate);
679         _rOwned[sender] = _rOwned[sender].sub(rAmount);
680         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
681         _reflectFee(rFee, rBurn, tFee, tBurn);
682         emit Transfer(sender, recipient, tTransferAmount);
683     }
684 
685     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
686         uint256 currentRate =  _getRate();
687         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
688         uint256 rBurn =  tBurn.mul(currentRate);
689         _rOwned[sender] = _rOwned[sender].sub(rAmount);
690         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
691         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
692         _reflectFee(rFee, rBurn, tFee, tBurn);
693         emit Transfer(sender, recipient, tTransferAmount);
694     }
695 
696     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
697         uint256 currentRate =  _getRate();
698         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
699         uint256 rBurn =  tBurn.mul(currentRate);
700         _tOwned[sender] = _tOwned[sender].sub(tAmount);
701         _rOwned[sender] = _rOwned[sender].sub(rAmount);
702         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
703         _reflectFee(rFee, rBurn, tFee, tBurn);
704         emit Transfer(sender, recipient, tTransferAmount);
705     }
706 
707     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
708         uint256 currentRate =  _getRate();
709         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getValues(tAmount);
710         uint256 rBurn =  tBurn.mul(currentRate);
711         _tOwned[sender] = _tOwned[sender].sub(tAmount);
712         _rOwned[sender] = _rOwned[sender].sub(rAmount);
713         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
714         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
715         _reflectFee(rFee, rBurn, tFee, tBurn);
716         emit Transfer(sender, recipient, tTransferAmount);
717     }
718 
719     function _reflectFee(uint256 rFee, uint256 rBurn, uint256 tFee, uint256 tBurn) private {
720         _rTotal = _rTotal.sub(rFee).sub(rBurn);
721         _tFeeTotal = _tFeeTotal.add(tFee);
722         _tBurnTotal = _tBurnTotal.add(tBurn);
723         _tTotal = _tTotal.sub(tBurn);
724     }
725     
726     function setMaxTxSize(uint256 amount) external onlyOwner() {
727         _MAX_TX_SIZE = amount * _DECIMALFACTOR;
728     }
729 
730     function setmarketingWallet(address newWallet) external onlyOwner() {
731         marketingWallet = newWallet;
732     }
733     
734     function setmarketingfee(uint256 amount) external onlyOwner() {
735         _marketingFee = amount;
736     }
737     
738     function setMaxWtSize(uint256 amount) external onlyOwner() {
739         _MAX_WT_SIZE = amount * _DECIMALFACTOR;
740     }
741 
742     function setLiquidityAddress(address amount) external onlyOwner() {
743         LiquidityAddress = amount;
744     }
745 
746     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256, uint256) {
747         (uint256 tTransferAmount, uint256 tFee, uint256 tBurn) = _getTValues(tAmount, _TAX_FEE, _BURN_FEE);
748         uint256 currentRate =  _getRate();
749         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, tBurn, currentRate);
750         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee, tBurn);
751     }
752 
753     function _getTValues(uint256 tAmount, uint256 taxFee, uint256 burnFee) private pure returns (uint256, uint256, uint256) {
754         uint256 tFee = ((tAmount.mul(taxFee)).div(_GRANULARITY)).div(100);
755         uint256 tBurn = ((tAmount.mul(burnFee)).div(_GRANULARITY)).div(100);
756         uint256 tTransferAmount = tAmount.sub(tFee).sub(tBurn);
757         return (tTransferAmount, tFee, tBurn);
758     }
759 
760     function _getRValues(uint256 tAmount, uint256 tFee, uint256 tBurn, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
761         uint256 rAmount = tAmount.mul(currentRate);
762         uint256 rFee = tFee.mul(currentRate);
763         uint256 rBurn = tBurn.mul(currentRate);
764         uint256 rTransferAmount = rAmount.sub(rFee).sub(rBurn);
765         return (rAmount, rTransferAmount, rFee);
766     }
767 
768     function _getRate() private view returns(uint256) {
769         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
770         return rSupply.div(tSupply);
771     }
772 
773     function _getCurrentSupply() private view returns(uint256, uint256) {
774         uint256 rSupply = _rTotal;
775         uint256 tSupply = _tTotal;      
776         for (uint256 i = 0; i < _excluded.length; i++) {
777             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
778             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
779             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
780         }
781         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
782         return (rSupply, tSupply);
783     }
784     
785     function _getTaxFee() public view returns(uint256) {
786         return _TAX_FEE;
787     }
788 
789     function enableTrading(bool _tradingEnabled) external onlyOwner() {
790         tradingEnabled = _tradingEnabled;
791     }    
792         
793     function _getMaxTxSize() public view returns(uint256) {
794         return _MAX_TX_SIZE;
795     }
796     
797     function _getMaxWtSize() public view returns(uint256) {
798         return _MAX_WT_SIZE;
799     }
800 
801 }