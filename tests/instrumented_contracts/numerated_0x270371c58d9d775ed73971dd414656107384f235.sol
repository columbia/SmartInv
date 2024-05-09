1 pragma solidity 0.8.1;
2 
3 // SPDX-License-Identifier: MIT
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
15 abstract contract Context {
16     function _msgSender() internal virtual view returns (address) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal virtual view returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 /**
27  * @dev Interface of the BEP20 standard as defined in the EIP.
28  */
29 interface IERC20 {
30     /**
31      * @dev Returns the amount of tokens in existence.
32      */
33     function totalSupply() external view returns (uint256);
34 
35     /**
36      * @dev Returns the amount of tokens owned by `account`.
37      */
38     function balanceOf(address account) external view returns (uint256);
39 
40     /**
41      * @dev Moves `amount` tokens from the caller's account to `recipient`.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * Emits a {Transfer} event.
46      */
47     function transfer(address recipient, uint256 amount)
48         external
49         returns (bool);
50 
51     /**
52      * @dev Returns the remaining number of tokens that `spender` will be
53      * allowed to spend on behalf of `owner` through {transferFrom}. This is
54      * zero by default.
55      *
56      * This value changes when {approve} or {transferFrom} are called.
57      */
58     function allowance(address owner, address spender)
59         external
60         view
61         returns (uint256);
62 
63     /**
64      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
65      *
66      * Returns a boolean value indicating whether the operation succeeded.
67      *
68      * IMPORTANT: Beware that changing an allowance with this method brings the risk
69      * that someone may use both the old and the new allowance by unfortunate
70      * transaction ordering. One possible solution to mitigate this race
71      * condition is to first reduce the spender's allowance to 0 and set the
72      * desired value afterwards:
73      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
74      *
75      * Emits an {Approval} event.
76      */
77     function approve(address spender, uint256 amount) external returns (bool);
78 
79     /**
80      * @dev Moves `amount` tokens from `sender` to `recipient` using the
81      * allowance mechanism. `amount` is then deducted from the caller's
82      * allowance.
83      *
84      * Returns a boolean value indicating whether the operation succeeded.
85      *
86      * Emits a {Transfer} event.
87      */
88     function transferFrom(
89         address sender,
90         address recipient,
91         uint256 amount
92     ) external returns (bool);
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
106     event Approval(
107         address indexed owner,
108         address indexed spender,
109         uint256 value
110     );
111 }
112 
113 /**
114  * @dev Wrappers over Solidity's arithmetic operations with added overflow
115  * checks.
116  *
117  * Arithmetic operations in Solidity wrap on overflow. This can easily result
118  * in bugs, because programmers usually assume that an overflow raises an
119  * error, which is the standard behavior in high level programming languages.
120  * `SafeMath` restores this intuition by reverting the transaction when an
121  * operation overflows.
122  *
123  * Using this library instead of the unchecked operations eliminates an entire
124  * class of bugs, so it's recommended to use it always.
125  */
126 library SafeMath {
127     /**
128      * @dev Returns the addition of two unsigned integers, reverting on
129      * overflow.
130      *
131      * Counterpart to Solidity's `+` operator.
132      *
133      * Requirements:
134      *
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
151      *
152      * - Subtraction cannot overflow.
153      */
154     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
155         return sub(a, b, "SafeMath: subtraction overflow");
156     }
157 
158     /**
159      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
160      * overflow (when the result is negative).
161      *
162      * Counterpart to Solidity's `-` operator.
163      *
164      * Requirements:
165      *
166      * - Subtraction cannot overflow.
167      */
168     function sub(
169         uint256 a,
170         uint256 b,
171         string memory errorMessage
172     ) internal pure returns (uint256) {
173         require(b <= a, errorMessage);
174         uint256 c = a - b;
175 
176         return c;
177     }
178 
179     /**
180      * @dev Returns the multiplication of two unsigned integers, reverting on
181      * overflow.
182      *
183      * Counterpart to Solidity's `*` operator.
184      *
185      * Requirements:
186      *
187      * - Multiplication cannot overflow.
188      */
189     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
190         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
191         // benefit is lost if 'b' is also tested.
192         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
193         if (a == 0) {
194             return 0;
195         }
196 
197         uint256 c = a * b;
198         require(c / a == b, "SafeMath: multiplication overflow");
199 
200         return c;
201     }
202 
203     /**
204      * @dev Returns the integer division of two unsigned integers. Reverts on
205      * division by zero. The result is rounded towards zero.
206      *
207      * Counterpart to Solidity's `/` operator. Note: this function uses a
208      * `revert` opcode (which leaves remaining gas untouched) while Solidity
209      * uses an invalid opcode to revert (consuming all remaining gas).
210      *
211      * Requirements:
212      *
213      * - The divisor cannot be zero.
214      */
215     function div(uint256 a, uint256 b) internal pure returns (uint256) {
216         return div(a, b, "SafeMath: division by zero");
217     }
218 
219     /**
220      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
221      * division by zero. The result is rounded towards zero.
222      *
223      * Counterpart to Solidity's `/` operator. Note: this function uses a
224      * `revert` opcode (which leaves remaining gas untouched) while Solidity
225      * uses an invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function div(
232         uint256 a,
233         uint256 b,
234         string memory errorMessage
235     ) internal pure returns (uint256) {
236         require(b > 0, errorMessage);
237         uint256 c = a / b;
238         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
239 
240         return c;
241     }
242 
243     /**
244      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
245      * Reverts when dividing by zero.
246      *
247      * Counterpart to Solidity's `%` operator. This function uses a `revert`
248      * opcode (which leaves remaining gas untouched) while Solidity uses an
249      * invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      *
253      * - The divisor cannot be zero.
254      */
255     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
256         return mod(a, b, "SafeMath: modulo by zero");
257     }
258 
259     /**
260      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
261      * Reverts with custom message when dividing by zero.
262      *
263      * Counterpart to Solidity's `%` operator. This function uses a `revert`
264      * opcode (which leaves remaining gas untouched) while Solidity uses an
265      * invalid opcode to revert (consuming all remaining gas).
266      *
267      * Requirements:
268      *
269      * - The divisor cannot be zero.
270      */
271     function mod(
272         uint256 a,
273         uint256 b,
274         string memory errorMessage
275     ) internal pure returns (uint256) {
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
307 
308 
309             bytes32 accountHash
310          = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
311         // solhint-disable-next-line no-inline-assembly
312         assembly {
313             codehash := extcodehash(account)
314         }
315         return (codehash != accountHash && codehash != 0x0);
316     }
317 
318     /**
319      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
320      * `recipient`, forwarding all available gas and reverting on errors.
321      *
322      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
323      * of certain opcodes, possibly making contracts go over the 2300 gas limit
324      * imposed by `transfer`, making them unable to receive funds via
325      * `transfer`. {sendValue} removes this limitation.
326      *
327      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-block.timestamp/[Learn more].
328      *
329      * IMPORTANT: because control is transferred to `recipient`, care must be
330      * taken to not create reentrancy vulnerabilities. Consider using
331      * {ReentrancyGuard} or the
332      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
333      */
334     function sendValue(address payable recipient, uint256 amount) internal {
335         require(
336             address(this).balance >= amount,
337             "Address: insufficient balance"
338         );
339 
340         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
341         (bool success, ) = recipient.call{value: amount}("");
342         require(
343             success,
344             "Address: unable to send value, recipient may have reverted"
345         );
346     }
347 
348     /**
349      * @dev Performs a Solidity function call using a low level `call`. A
350      * plain`call` is an unsafe replacement for a function call: use this
351      * function instead.
352      *
353      * If `target` reverts with a revert reason, it is bubbled up by this
354      * function (like regular Solidity function calls).
355      *
356      * Returns the raw returned data. To convert to the expected return value,
357      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
358      *
359      * Requirements:
360      *
361      * - `target` must be a contract.
362      * - calling `target` with `data` must not revert.
363      *
364      * _Available since v3.1._
365      */
366     function functionCall(address target, bytes memory data)
367         internal
368         returns (bytes memory)
369     {
370         return functionCall(target, data, "Address: low-level call failed");
371     }
372 
373     /**
374      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
375      * `errorMessage` as a fallback revert reason when `target` reverts.
376      *
377      * _Available since v3.1._
378      */
379     function functionCall(
380         address target,
381         bytes memory data,
382         string memory errorMessage
383     ) internal returns (bytes memory) {
384         return _functionCallWithValue(target, data, 0, errorMessage);
385     }
386 
387     /**
388      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
389      * but also transferring `value` wei to `target`.
390      *
391      * Requirements:
392      *
393      * - the calling contract must have an ETH balance of at least `value`.
394      * - the called Solidity function must be `payable`.
395      *
396      * _Available since v3.1._
397      */
398     function functionCallWithValue(
399         address target,
400         bytes memory data,
401         uint256 value
402     ) internal returns (bytes memory) {
403         return
404             functionCallWithValue(
405                 target,
406                 data,
407                 value,
408                 "Address: low-level call with value failed"
409             );
410     }
411 
412     /**
413      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
414      * with `errorMessage` as a fallback revert reason when `target` reverts.
415      *
416      * _Available since v3.1._
417      */
418     function functionCallWithValue(
419         address target,
420         bytes memory data,
421         uint256 value,
422         string memory errorMessage
423     ) internal returns (bytes memory) {
424         require(
425             address(this).balance >= value,
426             "Address: insufficient balance for call"
427         );
428         return _functionCallWithValue(target, data, value, errorMessage);
429     }
430 
431     function _functionCallWithValue(
432         address target,
433         bytes memory data,
434         uint256 weiValue,
435         string memory errorMessage
436     ) private returns (bytes memory) {
437         require(isContract(target), "Address: call to non-contract");
438 
439         // solhint-disable-next-line avoid-low-level-calls
440         (bool success, bytes memory returndata) = target.call{value: weiValue}(
441             data
442         );
443         if (success) {
444             return returndata;
445         } else {
446             // Look for revert reason and bubble it up if present
447             if (returndata.length > 0) {
448                 // The easiest way to bubble the revert reason is using memory via assembly
449 
450                 // solhint-disable-next-line no-inline-assembly
451                 assembly {
452                     let returndata_size := mload(returndata)
453                     revert(add(32, returndata), returndata_size)
454                 }
455             } else {
456                 revert(errorMessage);
457             }
458         }
459     }
460 }
461 
462 /**
463  * @dev Contract module which provides a basic access control mechanism, where
464  * there is an account (an owner) that can be granted exclusive access to
465  * specific functions.
466  *
467  * By default, the owner account will be the one that deploys the contract. This
468  * can later be changed with {transferOwnership}.
469  *
470  * This module is used through inheritance. It will make available the modifier
471  * `onlyOwner`, which can be applied to your functions to restrict their use to
472  * the owner.
473  */
474 contract Ownable is Context {
475     address private _owner;
476 
477     event OwnershipTransferred(
478         address indexed previousOwner,
479         address indexed newOwner
480     );
481 
482     /**
483      * @dev Initializes the contract setting the deployer as the initial owner.
484      */
485     constructor() {
486         address msgSender = _msgSender();
487         _owner = msgSender;
488         emit OwnershipTransferred(address(0), msgSender);
489     }
490 
491     /**
492      * @dev Returns the address of the current owner.
493      */
494     function owner() public view returns (address) {
495         return _owner;
496     }
497 
498     /**
499      * @dev Throws if called by any account other than the owner.
500      */
501     modifier onlyOwner() {
502         require(_owner == _msgSender(), "Ownable: caller is not the owner");
503         _;
504     }
505 
506     /**
507      * @dev Leaves the contract without owner. It will not be possible to call
508      * `onlyOwner` functions anymore. Can only be called by the current owner.
509      *
510      * NOTE: Renouncing ownership will leave the contract without an owner,
511      * thereby removing any functionality that is only available to the owner.
512      */
513     function renounceOwnership() public virtual onlyOwner {
514         emit OwnershipTransferred(_owner, address(0));
515         _owner = address(0);
516     }
517 
518     /**
519      * @dev Transfers ownership of the contract to a new account (`newOwner`).
520      * Can only be called by the current owner.
521      */
522     function transferOwnership(address newOwner) public virtual onlyOwner {
523         require(
524             newOwner != address(0),
525             "Ownable: new owner is the zero address"
526         );
527         emit OwnershipTransferred(_owner, newOwner);
528         _owner = newOwner;
529     }
530 }
531 
532 contract BTAP_Token is Context, IERC20, Ownable {
533     using SafeMath for uint256;
534     using Address for address;
535 
536     string private _name = "BTAP";
537     string private _symbol = "BTAP";
538     uint8 private _decimals = 18;
539 
540     mapping(address => uint256) internal _reflectionBalance;
541     mapping(address => uint256) internal _tokenBalance;
542     mapping(address => mapping(address => uint256)) internal _allowances;
543     
544     uint256 private constant MAX = ~uint256(0);
545     uint256 internal _tokenTotal = 100000000 *10**18;
546     uint256 internal _reflectionTotal = (MAX - (MAX % _tokenTotal));
547     
548     mapping(address => bool) isExcludedFromFee;
549     mapping(address => bool) internal _isExcluded;
550     address[] internal _excluded;
551     
552     uint256 public _taxFee = 50;
553     uint256 public _taxFeeAfter50millionSupply = 75;
554     uint256 public _burnFee = 25;
555     uint256 public _charityFee = 25;
556 
557     uint256 public _rebalanceCallerFee = 100;
558     
559     uint256 public _taxFeeTotal;
560     uint256 public _burnFeeTotal;
561     uint256 public _charityFeeTotal;
562     
563     address public charityAddress = 0xdbbb0DF9E8e9CbB11cA7a886113fA43504598C75;
564     
565     event RewardsDistributed(uint256 amount);
566 
567     constructor() {
568         
569         isExcludedFromFee[_msgSender()] = true;
570         isExcludedFromFee[address(this)] = true;
571         
572         _reflectionBalance[_msgSender()] = _reflectionTotal;
573         emit Transfer(address(0), _msgSender(), _tokenTotal);
574     }
575 
576     function name() public view returns (string memory) {
577         return _name;
578     }
579 
580     function symbol() public view returns (string memory) {
581         return _symbol;
582     }
583 
584     function decimals() public view returns (uint8) {
585         return _decimals;
586     }
587 
588     function totalSupply() public override view returns (uint256) {
589         return _tokenTotal;
590     }
591 
592     function balanceOf(address account) public override view returns (uint256) {
593         if (_isExcluded[account]) return _tokenBalance[account];
594         return tokenFromReflection(_reflectionBalance[account]);
595     }
596 
597     function transfer(address recipient, uint256 amount)
598         public
599         override
600         virtual
601         returns (bool)
602     {
603        _transfer(_msgSender(),recipient,amount);
604         return true;
605     }
606 
607     function allowance(address owner, address spender)
608         public
609         override
610         view
611         returns (uint256)
612     {
613         return _allowances[owner][spender];
614     }
615 
616     function approve(address spender, uint256 amount)
617         public
618         override
619         returns (bool)
620     {
621         _approve(_msgSender(), spender, amount);
622         return true;
623     }
624 
625     function transferFrom(
626         address sender,
627         address recipient,
628         uint256 amount
629     ) public override virtual returns (bool) {
630         _transfer(sender,recipient,amount);
631                
632         _approve(sender,_msgSender(),_allowances[sender][_msgSender()].sub( amount,"ERC20: transfer amount exceeds allowance"));
633         return true;
634     }
635 
636     function increaseAllowance(address spender, uint256 addedValue)
637         public
638         virtual
639         returns (bool)
640     {
641         _approve(
642             _msgSender(),
643             spender,
644             _allowances[_msgSender()][spender].add(addedValue)
645         );
646         return true;
647     }
648 
649     function decreaseAllowance(address spender, uint256 subtractedValue)
650         public
651         virtual
652         returns (bool)
653     {
654         _approve(
655             _msgSender(),
656             spender,
657             _allowances[_msgSender()][spender].sub(
658                 subtractedValue,
659                 "ERC20: decreased allowance below zero"
660             )
661         );
662         return true;
663     }
664 
665     function isExcluded(address account) public view returns (bool) {
666         return _isExcluded[account];
667     }
668 
669     function reflectionFromToken(uint256 tokenAmount, bool deductTransferFee)
670         public
671         view
672         returns (uint256)
673     {
674         require(tokenAmount <= _tokenTotal, "Amount must be less than supply");
675         if (!deductTransferFee) {
676             return tokenAmount.mul(_getReflectionRate());
677         } else {
678             return
679                 tokenAmount.sub(tokenAmount.mul(_taxFee).div(10000)).mul(
680                     _getReflectionRate()
681                 );
682         }
683     }
684 
685     function tokenFromReflection(uint256 reflectionAmount)
686         public
687         view
688         returns (uint256)
689     {
690         require(
691             reflectionAmount <= _reflectionTotal,
692             "Amount must be less than total reflections"
693         );
694         uint256 currentRate = _getReflectionRate();
695         return reflectionAmount.div(currentRate);
696     }
697 
698     function excludeAccount(address account) external onlyOwner() {
699         require(account != 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D,"BTAP: Uniswap router cannot be excluded.");
700         require(account != address(this), 'BTAP: The contract it self cannot be excluded');
701         require(!_isExcluded[account], "BTAP: Account is already excluded");
702         if (_reflectionBalance[account] > 0) {
703             _tokenBalance[account] = tokenFromReflection(
704                 _reflectionBalance[account]
705             );
706         }
707         _isExcluded[account] = true;
708         _excluded.push(account);
709     }
710 
711     function includeAccount(address account) external onlyOwner() {
712         require(_isExcluded[account], "BTAP: Account is already included");
713         for (uint256 i = 0; i < _excluded.length; i++) {
714             if (_excluded[i] == account) {
715                 _excluded[i] = _excluded[_excluded.length - 1];
716                 _tokenBalance[account] = 0;
717                 _isExcluded[account] = false;
718                 _excluded.pop();
719                 break;
720             }
721         }
722     }
723 
724     function _approve(
725         address owner,
726         address spender,
727         uint256 amount
728     ) private {
729         require(owner != address(0), "ERC20: approve from the zero address");
730         require(spender != address(0), "ERC20: approve to the zero address");
731 
732         _allowances[owner][spender] = amount;
733         emit Approval(owner, spender, amount);
734     }
735 
736     function _transfer(
737         address sender,
738         address recipient,
739         uint256 amount
740     ) private {
741         require(sender != address(0), "ERC20: transfer from the zero address");
742         require(recipient != address(0), "ERC20: transfer to the zero address");
743         require(amount > 0, "Transfer amount must be greater than zero");
744         
745         uint256 transferAmount = amount;
746         uint256 rate = _getReflectionRate();
747 
748         if(!isExcludedFromFee[sender] && !isExcludedFromFee[recipient]){
749             transferAmount = collectFee(sender,amount,rate);
750         }
751 
752         //@dev Transfer reflection
753         _reflectionBalance[sender] = _reflectionBalance[sender].sub(amount.mul(rate));
754         _reflectionBalance[recipient] = _reflectionBalance[recipient].add(transferAmount.mul(rate));
755 
756         //@dev If any account belongs to the excludedAccount transfer token
757         if (_isExcluded[sender]) {
758             _tokenBalance[sender] = _tokenBalance[sender].sub(amount);
759         }
760         if (_isExcluded[recipient]) {
761             _tokenBalance[recipient] = _tokenBalance[recipient].add(transferAmount);
762         }
763 
764         emit Transfer(sender, recipient, transferAmount);
765     }
766     
767     function collectFee(address account, uint256 amount, uint256 rate) private returns (uint256) {
768         
769         uint256 transferAmount = amount;
770         uint256 burnFee = amount.mul(_burnFee).div(10000);
771         uint256 charityFee = amount.mul(_charityFee).div(10000);
772         uint256 taxFee = amount.mul(_taxFee).div(10000);
773         uint256 taxFeeAfter50millionSupply = amount.mul(_taxFeeAfter50millionSupply).div(10000);
774         
775         //@dev Tax fee
776         if (_tokenTotal > 50000000 *10**18) {
777             transferAmount = transferAmount.sub(taxFee);
778             _reflectionTotal = _reflectionTotal.sub(taxFee.mul(rate));
779             _taxFeeTotal = _taxFeeTotal.add(taxFee);
780             emit RewardsDistributed(taxFee);
781             
782         }
783         
784         if(_tokenTotal == 50000000 *10**18){
785             transferAmount = transferAmount.sub(taxFeeAfter50millionSupply);
786             _reflectionTotal = _reflectionTotal.sub(taxFeeAfter50millionSupply.mul(rate));
787             _taxFeeTotal = _taxFeeTotal.add(taxFeeAfter50millionSupply);
788             emit RewardsDistributed(taxFeeAfter50millionSupply);
789         }
790 
791         //@dev charity fee
792         if(_charityFee != 0){
793             transferAmount = transferAmount.sub(charityFee);
794             _reflectionBalance[charityAddress] = _reflectionBalance[charityAddress].add(charityFee.mul(rate));
795             _charityFeeTotal = _charityFeeTotal.add(charityFee);
796             emit Transfer(account,charityAddress,charityFee);
797         }
798         
799         //@dev burn fee
800         if (burnFee != 0) {
801             if (_tokenTotal > 50000000 *10**18 && _tokenTotal < 50000000 *10**18 + burnFee) {
802                 uint256 lastBurnAmount = _tokenTotal - 50000000 *10**18;
803                 
804                 transferAmount = transferAmount.sub(lastBurnAmount);
805                 _tokenTotal = _tokenTotal.sub(lastBurnAmount);
806                 _burnFeeTotal = _burnFeeTotal.add(lastBurnAmount);
807                 emit Transfer(account,address(0),lastBurnAmount);
808         }
809         
810         if (_tokenTotal >= 50000000 *10**18 + burnFee) {
811                 transferAmount = transferAmount.sub(burnFee);
812                 _tokenTotal = _tokenTotal.sub(burnFee);
813                 _burnFeeTotal = _burnFeeTotal.add(burnFee);
814                 emit Transfer(account,address(0),burnFee);
815             }
816         
817         }
818         
819         return transferAmount;
820     }
821 
822     function _getReflectionRate() private view returns (uint256) {
823         uint256 reflectionSupply = _reflectionTotal;
824         uint256 tokenSupply = _tokenTotal;
825         for (uint256 i = 0; i < _excluded.length; i++) {
826             if (
827                 _reflectionBalance[_excluded[i]] > reflectionSupply ||
828                 _tokenBalance[_excluded[i]] > tokenSupply
829             ) return _reflectionTotal.div(_tokenTotal);
830             reflectionSupply = reflectionSupply.sub(
831                 _reflectionBalance[_excluded[i]]
832             );
833             tokenSupply = tokenSupply.sub(_tokenBalance[_excluded[i]]);
834         }
835         if (reflectionSupply < _reflectionTotal.div(_tokenTotal))
836             return _reflectionTotal.div(_tokenTotal);
837         return reflectionSupply.div(tokenSupply);
838     }
839     
840     function setExcludedFromFee(address account, bool excluded) public onlyOwner {
841         isExcludedFromFee[account] = excluded;
842     }
843     
844     function setTaxFee(uint256 fee) public onlyOwner {
845         _taxFee = fee;
846     }
847     
848     function setBurnFee(uint256 fee) public onlyOwner {
849         _burnFee = fee;
850     }
851     
852     function setCharityFee(uint256 fee) public onlyOwner {
853         _charityFee = fee;
854     }
855     
856     function setRebalanceCallerFee(uint256 fee) public onlyOwner {
857         _rebalanceCallerFee = fee;
858     }
859     
860     receive() external payable {}
861 }