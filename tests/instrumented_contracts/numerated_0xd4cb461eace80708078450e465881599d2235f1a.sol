1 // File: @openzeppelin\contracts\GSN\Context.sol
2 
3 pragma solidity ^0.6.2;
4 
5 /*
6  * @dev Provides information about the current execution context, including the
7  * sender of the transaction and its data. While these are generally available
8  * via msg.sender and msg.data, they should not be accessed in such a direct
9  * manner, since when dealing with GSN meta-transactions the account sending and
10  * paying for execution may not be the actual sender (as far as an application
11  * is concerned).
12  *
13  * This contract is only required for intermediate, library-like contracts.
14  */
15 contract Context {
16     // Empty internal constructor, to prevent people from mistakenly deploying
17     // an instance of this contract, which should be used via inheritance.
18     constructor () internal { }
19     // solhint-disable-previous-line no-empty-blocks
20 
21     function _msgSender() internal view returns (address payable) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view returns (bytes memory) {
26         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
27         return msg.data;
28     }
29 }
30 
31 // File: @openzeppelin\contracts\token\ERC20\IERC20.sol
32 
33 pragma solidity ^0.6.2;
34 
35 /**
36  * @dev Interface of the ERC20 standard as defined in the EIP. Does not include
37  * the optional functions; to access them see {ERC20Detailed}.
38  */
39 interface IERC20 {
40     /**
41      * @dev Returns the amount of tokens in existence.
42      */
43     function totalSupply() external view returns (uint256);
44 
45     /**
46      * @dev Returns the amount of tokens owned by `account`.
47      */
48     function balanceOf(address account) external view returns (uint256);
49 
50     /**
51      * @dev Moves `amount` tokens from the caller's account to `recipient`.
52      *
53      * Returns a boolean value indicating whether the operation succeeded.
54      *
55      * Emits a {Transfer} event.
56      */
57     function transfer(address recipient, uint256 amount) external returns (bool);
58 
59     /**
60      * @dev Returns the remaining number of tokens that `spender` will be
61      * allowed to spend on behalf of `owner` through {transferFrom}. This is
62      * zero by default.
63      *
64      * This value changes when {approve} or {transferFrom} are called.
65      */
66     function allowance(address owner, address spender) external view returns (uint256);
67 
68     /**
69      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
70      *
71      * Returns a boolean value indicating whether the operation succeeded.
72      *
73      * IMPORTANT: Beware that changing an allowance with this method brings the risk
74      * that someone may use both the old and the new allowance by unfortunate
75      * transaction ordering. One possible solution to mitigate this race
76      * condition is to first reduce the spender's allowance to 0 and set the
77      * desired value afterwards:
78      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
79      *
80      * Emits an {Approval} event.
81      */
82     function approve(address spender, uint256 amount) external returns (bool);
83 
84     /**
85      * @dev Moves `amount` tokens from `sender` to `recipient` using the
86      * allowance mechanism. `amount` is then deducted from the caller's
87      * allowance.
88      *
89      * Returns a boolean value indicating whether the operation succeeded.
90      *
91      * Emits a {Transfer} event.
92      */
93     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
94 
95     /**
96      * @dev Emitted when `value` tokens are moved from one account (`from`) to
97      * another (`to`).
98      *
99      * Note that `value` may be zero.
100      */
101     event Transfer(address indexed from, address indexed to, uint256 value);
102 
103     /**
104      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
105      * a call to {approve}. `value` is the new allowance.
106      */
107     event Approval(address indexed owner, address indexed spender, uint256 value);
108 }
109 
110 // File: @openzeppelin\contracts\math\SafeMath.sol
111 
112 pragma solidity ^0.6.2;
113 
114 /**
115  * @dev Wrappers over Solidity's arithmetic operations with added overflow
116  * checks.
117  *
118  * Arithmetic operations in Solidity wrap on overflow. This can easily result
119  * in bugs, because programmers usually assume that an overflow raises an
120  * error, which is the standard behavior in high level programming languages.
121  * `SafeMath` restores this intuition by reverting the transaction when an
122  * operation overflows.
123  *
124  * Using this library instead of the unchecked operations eliminates an entire
125  * class of bugs, so it's recommended to use it always.
126  */
127 library SafeMath {
128     /**
129      * @dev Returns the addition of two unsigned integers, reverting on
130      * overflow.
131      *
132      * Counterpart to Solidity's `+` operator.
133      *
134      * Requirements:
135      * - Addition cannot overflow.
136      */
137     function add(uint256 a, uint256 b) internal pure returns (uint256) {
138         uint256 c = a + b;
139         require(c >= a, "SafeMath: addition overflow");
140 
141         return c;
142     }
143 
144     /**
145      * @dev Returns the subtraction of two unsigned integers, reverting on
146      * overflow (when the result is negative).
147      *
148      * Counterpart to Solidity's `-` operator.
149      *
150      * Requirements:
151      * - Subtraction cannot overflow.
152      */
153     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
154         return sub(a, b, "SafeMath: subtraction overflow");
155     }
156 
157     /**
158      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
159      * overflow (when the result is negative).
160      *
161      * Counterpart to Solidity's `-` operator.
162      *
163      * Requirements:
164      * - Subtraction cannot overflow.
165      *
166      * _Available since v2.4.0._
167      */
168     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
169         require(b <= a, errorMessage);
170         uint256 c = a - b;
171 
172         return c;
173     }
174 
175     /**
176      * @dev Returns the multiplication of two unsigned integers, reverting on
177      * overflow.
178      *
179      * Counterpart to Solidity's `*` operator.
180      *
181      * Requirements:
182      * - Multiplication cannot overflow.
183      */
184     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
185         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
186         // benefit is lost if 'b' is also tested.
187         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
188         if (a == 0) {
189             return 0;
190         }
191 
192         uint256 c = a * b;
193         require(c / a == b, "SafeMath: multiplication overflow");
194 
195         return c;
196     }
197 
198     /**
199      * @dev Returns the integer division of two unsigned integers. Reverts on
200      * division by zero. The result is rounded towards zero.
201      *
202      * Counterpart to Solidity's `/` operator. Note: this function uses a
203      * `revert` opcode (which leaves remaining gas untouched) while Solidity
204      * uses an invalid opcode to revert (consuming all remaining gas).
205      *
206      * Requirements:
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
222      * - The divisor cannot be zero.
223      *
224      * _Available since v2.4.0._
225      */
226     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
227         // Solidity only automatically asserts when dividing by 0
228         require(b > 0, errorMessage);
229         uint256 c = a / b;
230         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
231 
232         return c;
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      * - The divisor cannot be zero.
245      */
246     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
247         return mod(a, b, "SafeMath: modulo by zero");
248     }
249 
250     /**
251      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
252      * Reverts with custom message when dividing by zero.
253      *
254      * Counterpart to Solidity's `%` operator. This function uses a `revert`
255      * opcode (which leaves remaining gas untouched) while Solidity uses an
256      * invalid opcode to revert (consuming all remaining gas).
257      *
258      * Requirements:
259      * - The divisor cannot be zero.
260      *
261      * _Available since v2.4.0._
262      */
263     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         require(b != 0, errorMessage);
265         return a % b;
266     }
267 }
268 
269 // File: @openzeppelin\contracts\utils\Address.sol
270 
271 pragma solidity ^0.6.2;
272 
273 /**
274  * @dev Collection of functions related to the address type
275  */
276 library Address {
277     /**
278      * @dev Returns true if `account` is a contract.
279      *
280      * [IMPORTANT]
281      * ====
282      * It is unsafe to assume that an address for which this function returns
283      * false is an externally-owned account (EOA) and not a contract.
284      *
285      * Among others, `isContract` will return false for the following 
286      * types of addresses:
287      *
288      *  - an externally-owned account
289      *  - a contract in construction
290      *  - an address where a contract will be created
291      *  - an address where a contract lived, but was destroyed
292      * ====
293      */
294     function isContract(address account) internal view returns (bool) {
295         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
296         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
297         // for accounts without code, i.e. `keccak256('')`
298         bytes32 codehash;
299         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
300         // solhint-disable-next-line no-inline-assembly
301         assembly { codehash := extcodehash(account) }
302         return (codehash != accountHash && codehash != 0x0);
303     }
304 
305     /**
306      * @dev Converts an `address` into `address payable`. Note that this is
307      * simply a type cast: the actual underlying value is not changed.
308      *
309      * _Available since v2.4.0._
310      */
311     function toPayable(address account) internal pure returns (address payable) {
312         return address(uint160(account));
313     }
314 
315     /**
316      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
317      * `recipient`, forwarding all available gas and reverting on errors.
318      *
319      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
320      * of certain opcodes, possibly making contracts go over the 2300 gas limit
321      * imposed by `transfer`, making them unable to receive funds via
322      * `transfer`. {sendValue} removes this limitation.
323      *
324      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
325      *
326      * IMPORTANT: because control is transferred to `recipient`, care must be
327      * taken to not create reentrancy vulnerabilities. Consider using
328      * {ReentrancyGuard} or the
329      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
330      *
331      * _Available since v2.4.0._
332      */
333     function sendValue(address payable recipient, uint256 amount) internal {
334         require(address(this).balance >= amount, "Address: insufficient balance");
335 
336         // solhint-disable-next-line avoid-call-value
337         (bool success, ) = recipient.call.value(amount)("");
338         require(success, "Address: unable to send value, recipient may have reverted");
339     }
340 }
341 
342 // File: @openzeppelin\contracts\ownership\Ownable.sol
343 
344 pragma solidity ^0.6.2;
345 
346 /**
347  * @dev Contract module which provides a basic access control mechanism, where
348  * there is an account (an owner) that can be granted exclusive access to
349  * specific functions.
350  *
351  * This module is used through inheritance. It will make available the modifier
352  * `onlyOwner`, which can be applied to your functions to restrict their use to
353  * the owner.
354  */
355 contract Ownable is Context {
356     address private _owner;
357 
358     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
359 
360     /**
361      * @dev Initializes the contract setting the deployer as the initial owner.
362      */
363     constructor () internal {
364         address msgSender = _msgSender();
365         _owner = msgSender;
366         emit OwnershipTransferred(address(0), msgSender);
367     }
368 
369     /**
370      * @dev Returns the address of the current owner.
371      */
372     function owner() public view returns (address) {
373         return _owner;
374     }
375 
376     /**
377      * @dev Throws if called by any account other than the owner.
378      */
379     modifier onlyOwner() {
380         require(isOwner(), "Ownable: caller is not the owner");
381         _;
382     }
383 
384     /**
385      * @dev Returns true if the caller is the current owner.
386      */
387     function isOwner() public view returns (bool) {
388         return _msgSender() == _owner;
389     }
390 
391     /**
392      * @dev Leaves the contract without owner. It will not be possible to call
393      * `onlyOwner` functions anymore. Can only be called by the current owner.
394      *
395      * NOTE: Renouncing ownership will leave the contract without an owner,
396      * thereby removing any functionality that is only available to the owner.
397      */
398     function renounceOwnership() public onlyOwner {
399         emit OwnershipTransferred(_owner, address(0));
400         _owner = address(0);
401     }
402 
403     /**
404      * @dev Transfers ownership of the contract to a new account (`newOwner`).
405      * Can only be called by the current owner.
406      */
407     function transferOwnership(address newOwner) public onlyOwner {
408         _transferOwnership(newOwner);
409     }
410 
411     /**
412      * @dev Transfers ownership of the contract to a new account (`newOwner`).
413      */
414     function _transferOwnership(address newOwner) internal {
415         require(newOwner != address(0), "Ownable: new owner is the zero address");
416         emit OwnershipTransferred(_owner, newOwner);
417         _owner = newOwner;
418     }
419 }
420 
421 // File: contracts\Token.sol
422 
423 pragma solidity ^0.6.2;
424 
425 
426 
427 
428 
429 
430 contract PSI is Context, IERC20, Ownable {
431     using SafeMath for uint256;
432     using Address for address;
433 
434     mapping (address => uint256) private _rOwned;
435     mapping (address => uint256) private _tOwned;
436     mapping (address => mapping (address => uint256)) private _allowances;
437 
438     mapping (address => bool) private _isExcluded;
439     address[] private _excluded;
440    
441     uint256 private constant MAX = ~uint256(0);
442     uint256 private constant _tTotal = 0.05 * 10**6 * 10**9;
443     uint256 private _rTotal = (MAX - (MAX % _tTotal));
444     uint256 private _tFeeTotal;
445 
446     string private _name = 'passive.income';
447     string private _symbol = 'PSI';
448     uint8 private _decimals = 9;
449 
450     constructor () public {
451         _rOwned[_msgSender()] = _rTotal;
452         emit Transfer(address(0), _msgSender(), _tTotal);
453     }
454 
455     function name() public view returns (string memory) {
456         return _name;
457     }
458 
459     function symbol() public view returns (string memory) {
460         return _symbol;
461     }
462 
463     function decimals() public view returns (uint8) {
464         return _decimals;
465     }
466 
467     function totalSupply() public view override returns (uint256) {
468         return _tTotal;
469     }
470 
471     function balanceOf(address account) public view override returns (uint256) {
472         if (_isExcluded[account]) return _tOwned[account];
473         return tokenFromReflection(_rOwned[account]);
474     }
475 
476     function transfer(address recipient, uint256 amount) public override returns (bool) {
477         _transfer(_msgSender(), recipient, amount);
478         return true;
479     }
480 
481     function allowance(address owner, address spender) public view override returns (uint256) {
482         return _allowances[owner][spender];
483     }
484 
485     function approve(address spender, uint256 amount) public override returns (bool) {
486         _approve(_msgSender(), spender, amount);
487         return true;
488     }
489 
490     function transferFrom(address sender, address recipient, uint256 amount) public override returns (bool) {
491         _transfer(sender, recipient, amount);
492         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
493         return true;
494     }
495 
496     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
497         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
498         return true;
499     }
500 
501     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
502         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
503         return true;
504     }
505 
506     function isExcluded(address account) public view returns (bool) {
507         return _isExcluded[account];
508     }
509 
510     function totalFees() public view returns (uint256) {
511         return _tFeeTotal;
512     }
513 
514     function reflect(uint256 tAmount) public {
515         address sender = _msgSender();
516         require(!_isExcluded[sender], "Excluded addresses cannot call this function");
517         (uint256 rAmount,,,,) = _getValues(tAmount);
518         _rOwned[sender] = _rOwned[sender].sub(rAmount);
519         _rTotal = _rTotal.sub(rAmount);
520         _tFeeTotal = _tFeeTotal.add(tAmount);
521     }
522 
523     function reflectionFromToken(uint256 tAmount, bool deductTransferFee) public view returns(uint256) {
524         require(tAmount <= _tTotal, "Amount must be less than supply");
525         if (!deductTransferFee) {
526             (uint256 rAmount,,,,) = _getValues(tAmount);
527             return rAmount;
528         } else {
529             (,uint256 rTransferAmount,,,) = _getValues(tAmount);
530             return rTransferAmount;
531         }
532     }
533 
534     function tokenFromReflection(uint256 rAmount) public view returns(uint256) {
535         require(rAmount <= _rTotal, "Amount must be less than total reflections");
536         uint256 currentRate =  _getRate();
537         return rAmount.div(currentRate);
538     }
539 
540     function excludeAccount(address account) external onlyOwner() {
541         require(!_isExcluded[account], "Account is already excluded");
542         if(_rOwned[account] > 0) {
543             _tOwned[account] = tokenFromReflection(_rOwned[account]);
544         }
545         _isExcluded[account] = true;
546         _excluded.push(account);
547     }
548 
549     function includeAccount(address account) external onlyOwner() {
550         require(_isExcluded[account], "Account is already excluded");
551         for (uint256 i = 0; i < _excluded.length; i++) {
552             if (_excluded[i] == account) {
553                 _excluded[i] = _excluded[_excluded.length - 1];
554                 _tOwned[account] = 0;
555                 _isExcluded[account] = false;
556                 _excluded.pop();
557                 break;
558             }
559         }
560     }
561 
562     function _approve(address owner, address spender, uint256 amount) private {
563         require(owner != address(0), "ERC20: approve from the zero address");
564         require(spender != address(0), "ERC20: approve to the zero address");
565 
566         _allowances[owner][spender] = amount;
567         emit Approval(owner, spender, amount);
568     }
569 
570     function _transfer(address sender, address recipient, uint256 amount) private {
571         require(sender != address(0), "ERC20: transfer from the zero address");
572         require(recipient != address(0), "ERC20: transfer to the zero address");
573         require(amount > 0, "Transfer amount must be greater than zero");
574         if (_isExcluded[sender] && !_isExcluded[recipient]) {
575             _transferFromExcluded(sender, recipient, amount);
576         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
577             _transferToExcluded(sender, recipient, amount);
578         } else if (!_isExcluded[sender] && !_isExcluded[recipient]) {
579             _transferStandard(sender, recipient, amount);
580         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
581             _transferBothExcluded(sender, recipient, amount);
582         } else {
583             _transferStandard(sender, recipient, amount);
584         }
585     }
586 
587     function _transferStandard(address sender, address recipient, uint256 tAmount) private {
588         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
589         _rOwned[sender] = _rOwned[sender].sub(rAmount);
590         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);       
591         _reflectFee(rFee, tFee);
592         emit Transfer(sender, recipient, tTransferAmount);
593     }
594 
595     function _transferToExcluded(address sender, address recipient, uint256 tAmount) private {
596         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
597         _rOwned[sender] = _rOwned[sender].sub(rAmount);
598         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
599         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);           
600         _reflectFee(rFee, tFee);
601         emit Transfer(sender, recipient, tTransferAmount);
602     }
603 
604     function _transferFromExcluded(address sender, address recipient, uint256 tAmount) private {
605         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
606         _tOwned[sender] = _tOwned[sender].sub(tAmount);
607         _rOwned[sender] = _rOwned[sender].sub(rAmount);
608         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);   
609         _reflectFee(rFee, tFee);
610         emit Transfer(sender, recipient, tTransferAmount);
611     }
612 
613     function _transferBothExcluded(address sender, address recipient, uint256 tAmount) private {
614         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee, uint256 tTransferAmount, uint256 tFee) = _getValues(tAmount);
615         _tOwned[sender] = _tOwned[sender].sub(tAmount);
616         _rOwned[sender] = _rOwned[sender].sub(rAmount);
617         _tOwned[recipient] = _tOwned[recipient].add(tTransferAmount);
618         _rOwned[recipient] = _rOwned[recipient].add(rTransferAmount);        
619         _reflectFee(rFee, tFee);
620         emit Transfer(sender, recipient, tTransferAmount);
621     }
622 
623     function _reflectFee(uint256 rFee, uint256 tFee) private {
624         _rTotal = _rTotal.sub(rFee);
625         _tFeeTotal = _tFeeTotal.add(tFee);
626     }
627 
628     function _getValues(uint256 tAmount) private view returns (uint256, uint256, uint256, uint256, uint256) {
629         (uint256 tTransferAmount, uint256 tFee) = _getTValues(tAmount);
630         uint256 currentRate =  _getRate();
631         (uint256 rAmount, uint256 rTransferAmount, uint256 rFee) = _getRValues(tAmount, tFee, currentRate);
632         return (rAmount, rTransferAmount, rFee, tTransferAmount, tFee);
633     }
634 
635     function _getTValues(uint256 tAmount) private pure returns (uint256, uint256) {
636         uint256 tFee = tAmount.div(100);
637         uint256 tTransferAmount = tAmount.sub(tFee);
638         return (tTransferAmount, tFee);
639     }
640 
641     function _getRValues(uint256 tAmount, uint256 tFee, uint256 currentRate) private pure returns (uint256, uint256, uint256) {
642         uint256 rAmount = tAmount.mul(currentRate);
643         uint256 rFee = tFee.mul(currentRate);
644         uint256 rTransferAmount = rAmount.sub(rFee);
645         return (rAmount, rTransferAmount, rFee);
646     }
647 
648     function _getRate() private view returns(uint256) {
649         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
650         return rSupply.div(tSupply);
651     }
652 
653     function _getCurrentSupply() private view returns(uint256, uint256) {
654         uint256 rSupply = _rTotal;
655         uint256 tSupply = _tTotal;      
656         for (uint256 i = 0; i < _excluded.length; i++) {
657             if (_rOwned[_excluded[i]] > rSupply || _tOwned[_excluded[i]] > tSupply) return (_rTotal, _tTotal);
658             rSupply = rSupply.sub(_rOwned[_excluded[i]]);
659             tSupply = tSupply.sub(_tOwned[_excluded[i]]);
660         }
661         if (rSupply < _rTotal.div(_tTotal)) return (_rTotal, _tTotal);
662         return (rSupply, tSupply);
663     }
664 }