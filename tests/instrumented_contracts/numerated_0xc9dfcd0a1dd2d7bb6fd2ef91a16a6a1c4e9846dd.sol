1 // Partial License: MIT
2 //SPDX-License-Identifier: UNLICENSED
3 pragma solidity 0.7.5;
4 
5 /*
6  * HYPE FINANCE Smart contract for Hype.Bet produced by ????? ?????
7  *
8  */
9 abstract contract Context {
10     function _msgSender() internal view virtual returns (address payable) {
11         return msg.sender;
12     }
13 
14     function _msgData() internal view virtual returns (bytes memory) {
15         this; // silence state mutability warning without generating bytecode
16         return msg.data;
17     }
18 }
19 
20 
21 
22 /**
23  * @dev Interface of the ERC20 standard as defined in the EIP.
24  */
25 interface IERC20 {
26     /**
27      * @dev Returns the amount of tokens in existence.
28      */
29     function totalSupply() external view returns (uint256);
30 
31     /**
32      * @dev Returns the amount of tokens owned by `account`.
33      */
34     function balanceOf(address account) external view returns (uint256);
35 
36     /**
37      * @dev Moves `amount` tokens from the caller's account to `recipient`.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * Emits a {Transfer} event.
42      */
43     function transfer(address recipient, uint256 amount) external returns (bool);
44 
45     /**
46      * @dev Returns the remaining number of tokens that `spender` will be
47      * allowed to spend on behalf of `owner` through {transferFrom}. This is
48      * zero by default.
49      *
50      * This value changes when {approve} or {transferFrom} are called.
51      */
52     function allowance(address owner, address spender) external view returns (uint256);
53 
54     /**
55      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * IMPORTANT: Beware that changing an allowance with this method brings the risk
60      * that someone may use both the old and the new allowance by unfortunate
61      * transaction ordering. One possible solution to mitigate this race
62      * condition is to first reduce the spender's allowance to 0 and set the
63      * desired value afterwards:
64      * 
65      *
66      * Emits an {Approval} event.
67      */
68     function approve(address spender, uint256 amount) external returns (bool);
69 
70     /**
71      * @dev Moves `amount` tokens from `sender` to `recipient` using the
72      * allowance mechanism. `amount` is then deducted from the caller's
73      * allowance.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Emitted when `value` tokens are moved from one account (`from`) to
83      * another (`to`).
84      *
85      * Note that `value` may be zero.
86      */
87     event Transfer(address indexed from, address indexed to, uint256 value);
88 
89     /**
90      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
91      * a call to {approve}. `value` is the new allowance.
92      */
93     event Approval(address indexed owner, address indexed spender, uint256 value);
94 }
95 
96 
97 /**
98  * @dev Wrappers over Solidity's arithmetic operations with added overflow
99  * checks.
100  *
101  * Arithmetic operations in Solidity wrap on overflow. This can easily result
102  * in bugs, because programmers usually assume that an overflow raises an
103  * error, which is the standard behavior in high level programming languages.
104  * `SafeMath` restores this intuition by reverting the transaction when an
105  * operation overflows.
106  *
107  * Using this library instead of the unchecked operations eliminates an entire
108  * class of bugs, so it's recommended to use it always.
109  */
110 library SafeMath {
111     /**
112      * @dev Returns the addition of two unsigned integers, reverting on
113      * overflow.
114      *
115      * Counterpart to Solidity's `+` operator.
116      *
117      * Requirements:
118      *
119      * - Addition cannot overflow.
120      */
121     function add(uint256 a, uint256 b) internal pure returns (uint256) {
122         uint256 c = a + b;
123         require(c >= a, "SafeMath: addition overflow");
124 
125         return c;
126     }
127 
128     /**
129      * @dev Returns the subtraction of two unsigned integers, reverting on
130      * overflow (when the result is negative).
131      *
132      * Counterpart to Solidity's `-` operator.
133      *
134      * Requirements:
135      *
136      * - Subtraction cannot overflow.
137      */
138     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
139         return sub(a, b, "SafeMath: subtraction overflow");
140     }
141 
142     /**
143      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
144      * overflow (when the result is negative).
145      *
146      * Counterpart to Solidity's `-` operator.
147      *
148      * Requirements:
149      *
150      * - Subtraction cannot overflow.
151      */
152     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
153         require(b <= a, errorMessage);
154         uint256 c = a - b;
155 
156         return c;
157     }
158 
159     /**
160      * @dev Returns the multiplication of two unsigned integers, reverting on
161      * overflow.
162      *
163      * Counterpart to Solidity's `*` operator.
164      *
165      * Requirements:
166      *
167      * - Multiplication cannot overflow.
168      */
169     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
170         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
171         // benefit is lost if 'b' is also tested.
172         
173         if (a == 0) {
174             return 0;
175         }
176 
177         uint256 c = a * b;
178         require(c / a == b, "SafeMath: multiplication overflow");
179 
180         return c;
181     }
182 
183     /**
184      * @dev Returns the integer division of two unsigned integers. Reverts on
185      * division by zero. The result is rounded towards zero.
186      *
187      * Counterpart to Solidity's `/` operator. Note: this function uses a
188      * `revert` opcode (which leaves remaining gas untouched) while Solidity
189      * uses an invalid opcode to revert (consuming all remaining gas).
190      *
191      * Requirements:
192      *
193      * - The divisor cannot be zero.
194      */
195     function div(uint256 a, uint256 b) internal pure returns (uint256) {
196         return div(a, b, "SafeMath: division by zero");
197     }
198 
199     /**
200      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
201      * division by zero. The result is rounded towards zero.
202      *
203      * Counterpart to Solidity's `/` operator. Note: this function uses a
204      * `revert` opcode (which leaves remaining gas untouched) while Solidity
205      * uses an invalid opcode to revert (consuming all remaining gas).
206      *
207      * Requirements:
208      *
209      * - The divisor cannot be zero.
210      */
211     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
212         require(b > 0, errorMessage);
213         uint256 c = a / b;
214         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
215 
216         return c;
217     }
218 
219     /**
220      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
221      * Reverts when dividing by zero.
222      *
223      * Counterpart to Solidity's `%` operator. This function uses a `revert`
224      * opcode (which leaves remaining gas untouched) while Solidity uses an
225      * invalid opcode to revert (consuming all remaining gas).
226      *
227      * Requirements:
228      *
229      * - The divisor cannot be zero.
230      */
231     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
232         return mod(a, b, "SafeMath: modulo by zero");
233     }
234 
235     /**
236      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
237      * Reverts with custom message when dividing by zero.
238      *
239      * Counterpart to Solidity's `%` operator. This function uses a `revert`
240      * opcode (which leaves remaining gas untouched) while Solidity uses an
241      * invalid opcode to revert (consuming all remaining gas).
242      *
243      * Requirements:
244      *
245      * - The divisor cannot be zero.
246      */
247     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
248         require(b != 0, errorMessage);
249         return a % b;
250     }
251 }
252 
253 
254 
255 /**
256  * @dev Collection of functions related to the address type
257  */
258 library Address {
259     /**
260      * @dev Returns true if `account` is a contract.
261      *
262      * [IMPORTANT]
263      * ====
264      * It is unsafe to assume that an address for which this function returns
265      * false is an externally-owned account (EOA) and not a contract.
266      *
267      * Among others, `isContract` will return false for the following
268      * types of addresses:
269      *
270      *  - an externally-owned account
271      *  - a contract in construction
272      *  - an address where a contract will be created
273      *  - an address where a contract lived, but was destroyed
274      * ====
275      */
276     function isContract(address account) internal view returns (bool) {
277         // This method relies in extcodesize, which returns 0 for contracts in
278         // construction, since the code is only stored at the end of the
279         // constructor execution.
280 
281         uint256 size;
282         // solhint-disable-next-line no-inline-assembly
283         assembly { size := extcodesize(account) }
284         return size > 0;
285     }
286 
287     /**
288      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
289      * `recipient`, forwarding all available gas and reverting on errors.
290      *
291      *
292      * of certain opcodes, possibly making contracts go over the 2300 gas limit
293      * imposed by `transfer`, making them unable to receive funds via
294      * `transfer`. {sendValue} removes this limitation.
295      *
296      * 
297      *
298      * IMPORTANT: because control is transferred to `recipient`, care must be
299      * taken to not create reentrancy vulnerabilities. Consider using
300      */
301     function sendValue(address payable recipient, uint256 amount) internal {
302         require(address(this).balance >= amount, "Address: insufficient balance");
303 
304         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
305         (bool success, ) = recipient.call{ value: amount }("");
306         require(success, "Address: unable to send value, recipient may have reverted");
307     }
308 
309     /**
310      * @dev Performs a Solidity function call using a low level `call`. A
311      * plain`call` is an unsafe replacement for a function call: use this
312      * function instead.
313      *
314      * If `target` reverts with a revert reason, it is bubbled up by this
315      * function (like regular Solidity function calls).
316      *
317      * Returns the raw returned data. To convert to the expected return value,
318      * Requirements:
319      *
320      * - `target` must be a contract.
321      * - calling `target` with `data` must not revert.
322      *
323      * _Available since v3.1._
324      */
325     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
326       return functionCall(target, data, "Address: low-level call failed");
327     }
328 
329     /**
330      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
331      * `errorMessage` as a fallback revert reason when `target` reverts.
332      *
333      * _Available since v3.1._
334      */
335     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
336         return _functionCallWithValue(target, data, 0, errorMessage);
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
341      * but also transferring `value` wei to `target`.
342      *
343      * Requirements:
344      *
345      * - the calling contract must have an ETH balance of at least `value`.
346      * - the called Solidity function must be `payable`.
347      *
348      * _Available since v3.1._
349      */
350     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
351         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
352     }
353 
354     /**
355      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
356      * with `errorMessage` as a fallback revert reason when `target` reverts.
357      *
358      * _Available since v3.1._
359      */
360     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
361         require(address(this).balance >= value, "Address: insufficient balance for call");
362         return _functionCallWithValue(target, data, value, errorMessage);
363     }
364 
365     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
366         require(isContract(target), "Address: call to non-contract");
367 
368         // solhint-disable-next-line avoid-low-level-calls
369         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
370         if (success) {
371             return returndata;
372         } else {
373             // Look for revert reason and bubble it up if present
374             if (returndata.length > 0) {
375                 // The easiest way to bubble the revert reason is using memory via assembly
376 
377                 // solhint-disable-next-line no-inline-assembly
378                 assembly {
379                     let returndata_size := mload(returndata)
380                     revert(add(32, returndata), returndata_size)
381                 }
382             } else {
383                 revert(errorMessage);
384             }
385         }
386     }
387 }
388 
389 
390 
391 
392 /**
393  * @dev Contract module which provides a basic access control mechanism, where
394  * there is an account (an owner) that can be granted exclusive access to
395  * specific functions.
396  *
397  * By default, the owner account will be the one that deploys the contract. This
398  * can later be changed with {transferOwnership}.
399  *
400  * This module is used through inheritance. It will make available the modifier
401  * `onlyOwner`, which can be applied to your functions to restrict their use to
402  * the owner.
403  */
404 contract Ownable is Context {
405     address private _owner;
406 
407     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
408 
409     /**
410      * @dev Initializes the contract setting the deployer as the initial owner.
411      */
412     constructor () {
413         address msgSender = _msgSender();
414         _owner = msgSender;
415         emit OwnershipTransferred(address(0), msgSender);
416     }
417 
418     /**
419      * @dev Returns the address of the current owner.
420      */
421     function owner() public view returns (address) {
422         return _owner;
423     }
424 
425     /**
426      * @dev Throws if called by any account other than the owner.
427      */
428     modifier onlyOwner() {
429         require(_owner == _msgSender(), "Ownable: caller is not the owner");
430         _;
431     }
432 
433     /**
434      * @dev Leaves the contract without owner. It will not be possible to call
435      * `onlyOwner` functions anymore. Can only be called by the current owner.
436      *
437      * NOTE: Renouncing ownership will leave the contract without an owner,
438      * thereby removing any functionality that is only available to the owner.
439      */
440     function renounceOwnership() public virtual onlyOwner {
441         emit OwnershipTransferred(_owner, address(0));
442         _owner = address(0);
443     }
444 
445     /**
446      * @dev Transfers ownership of the contract to a new account (`newOwner`).
447      * Can only be called by the current owner.
448      */
449     function transferOwnership(address newOwner) public virtual onlyOwner {
450         require(newOwner != address(0), "Ownable: new owner is the zero address");
451         emit OwnershipTransferred(_owner, newOwner);
452         _owner = newOwner;
453     }
454 }
455 
456 
457 /**
458  * We have made some light modifications to the openzeppelin ER20
459  * located here "../node_modules/@openzeppelin/contracts/token/ERC20/ERC20.sol".
460  * Please read below for a quick overview of what has been changed:
461  *
462  * We have changed one function:
463  * - `_transfer` [line 293] to apply a transfer fee
464  *
465  * We have added 6 variables
466  * - `txFee` [line 78] the transaction fee to be applied.
467  * - `feeDistributor` [line 79] the contract address to recieve the fees.
468  * - 'OwnerFee' Owner takes 2% fee for every transfer done
469  * - `feelessSender` [line 82] map containing senders who will not have txFees applied.
470  * - `feelessReciever` [line 83] map containing recipients who will not have txFee applied.
471  * - `canWhitelist` [line 85] map containing recipients who will not have txFee applied.
472  *
473  * We have added 6 simple functions
474  * - `setFee` [line 235] set new transaction fee.
475  * - `setFeeDistributor` [line 240] sets new address to recieve txFees
476  * - `setFeelessSender` [line 245] to enable/disable fees for a given sender.
477  * - `setFeelessReciever` [line 251] to enable/disable fees for a given recipient.
478  * - `renounceWhitelist` [line 257] disables adding to whitelist forever.
479  * - `calculateAmountsAfterFee` [line 262] to caclulate the amounts after fees have been applied.
480  *
481  * We have updated this contract to implement the openzeppelin Ownable standard.
482  * We have updated the contract from 0.6.0 to 0.6.6;
483  */
484 
485 
486 
487 
488 
489 /**
490  * @dev Implementation of the {IERC20} interface.
491  *
492  * This implementation is agnostic to the way tokens are created. This means
493  * that a supply mechanism has to be added in a derived contract using {_mint}.
494  * For a generic mechanism see {ERC20PresetMinterPauser}.
495  *
496  * TIP: For a detailed writeup see our guide
497  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
498  * to implement supply mechanisms].
499  *
500  * We have followed general OpenZeppelin guidelines: functions revert instead
501  * of returning `false` on failure. This behavior is nonetheless conventional
502  * and does not conflict with the expectations of ERC20 applications.
503  *
504  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
505  * This allows applications to reconstruct the allowance for all accounts just
506  * by listening to said events. Other implementations of the EIP may not emit
507  * these events, as it isn't required by the specification.
508  *
509  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
510  * functions have been added to mitigate the well-known issues around setting
511  * allowances. See {IERC20-approve}.
512  */
513 contract DeflationaryERC20 is Context, IERC20, Ownable {
514     using SafeMath for uint256;
515     using Address for address;
516 
517     mapping (address => uint256) private _balances;
518     mapping (address => mapping (address => uint256)) private _allowances;
519 
520     uint256 private _totalSupply;
521 
522     string private _name;
523     string private _symbol;
524     uint8 private _decimals;
525 
526     // Transaction Fees:
527     uint8 public txFee = 10; // 1% fees
528     uint8 public OwnertxFee = 20; // 2% fees
529     address public feeDistributor; // fees are sent to fee distributer
530     address public OwnerfeeDistributor; // some fees are sent to fee Owner
531 
532     // Fee Whitelist
533     mapping(address => bool) public feelessSender;
534     mapping(address => bool) public feelessReciever;
535     // if this equals false whitelist can nolonger be added to.
536     bool public canWhitelist = true;
537 
538     /**
539      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
540      * a default value of 18.
541      *
542      * To select a different value for {decimals}, use {_setupDecimals}.
543      *
544      * All three of these values are immutable: they can only be set once during
545      * construction.
546      */
547     constructor (string memory name_, string memory symbol_) {
548         _name = name_;
549         _symbol = symbol_;
550         _decimals = 18;
551     }
552 
553     /**
554      * @dev Returns the name of the token.
555      */
556     function name() public view returns (string memory) {
557         return _name;
558     }
559 
560     /**
561      * @dev Returns the symbol of the token, usually a shorter version of the
562      * name.
563      */
564     function symbol() public view returns (string memory) {
565         return _symbol;
566     }
567 
568     /**
569      * @dev Returns the number of decimals used to get its user representation.
570      * For example, if `decimals` equals `2`, a balance of `505` tokens should
571      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
572      *
573      * Tokens usually opt for a value of 18, imitating the relationship between
574      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
575      * called.
576      *
577      * NOTE: This information is only used for _display_ purposes: it in
578      * no way affects any of the arithmetic of the contract, including
579      * {IERC20-balanceOf} and {IERC20-transfer}.
580      */
581     function decimals() public view returns (uint8) {
582         return _decimals;
583     }
584 
585     /**
586      * @dev See {IERC20-totalSupply}.
587      */
588     function totalSupply() public view override returns (uint256) {
589         return _totalSupply;
590     }
591 
592     /**
593      * @dev See {IERC20-balanceOf}.
594      */
595     function balanceOf(address account) public view override returns (uint256) {
596         return _balances[account];
597     }
598 
599     /**
600      * @dev See {IERC20-transfer}.
601      *
602      * Requirements:
603      *
604      * - `recipient` cannot be the zero address.
605      * - the caller must have a balance of at least `amount`.
606      */
607     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
608         _transfer(_msgSender(), recipient, amount);
609         return true;
610     }
611 
612     /**
613      * @dev See {IERC20-allowance}.
614      */
615     function allowance(address owner, address spender) public view virtual override returns (uint256) {
616         return _allowances[owner][spender];
617     }
618 
619     /**
620      * @dev See {IERC20-approve}.
621      *
622      * Requirements:
623      *
624      * - `spender` cannot be the zero address.
625      */
626     function approve(address spender, uint256 amount) public virtual override returns (bool) {
627         _approve(_msgSender(), spender, amount);
628         return true;
629     }
630 
631     /**
632      * @dev See {IERC20-transferFrom}.
633      *
634      * Emits an {Approval} event indicating the updated allowance. This is not
635      * required by the EIP. See the note at the beginning of {ERC20};
636      *
637      * Requirements:
638      * - `sender` and `recipient` cannot be the zero address.
639      * - `sender` must have a balance of at least `amount`.
640      * - the caller must have allowance for ``sender``'s tokens of at least
641      * `amount`.
642      */
643     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
644         _transfer(sender, recipient, amount);
645         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
646         return true;
647     }
648 
649     /**
650      * @dev Atomically increases the allowance granted to `spender` by the caller.
651      *
652      * This is an alternative to {approve} that can be used as a mitigation for
653      * problems described in {IERC20-approve}.
654      *
655      * Emits an {Approval} event indicating the updated allowance.
656      *
657      * Requirements:
658      *
659      * - `spender` cannot be the zero address.
660      */
661     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
662         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
663         return true;
664     }
665 
666     /**
667      * @dev Atomically decreases the allowance granted to `spender` by the caller.
668      *
669      * This is an alternative to {approve} that can be used as a mitigation for
670      * problems described in {IERC20-approve}.
671      *
672      * Emits an {Approval} event indicating the updated allowance.
673      *
674      * Requirements:
675      *
676      * - `spender` cannot be the zero address.
677      * - `spender` must have allowance for the caller of at least
678      * `subtractedValue`.
679      */
680     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
681         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
682         return true;
683     }
684 
685     // assign a new transactionfee
686     function setFee(uint8 _newTxFee) public onlyOwner {
687         txFee = _newTxFee;
688     }
689     
690     // assign a new transaction Ownerfee
691     function setOwnerFee(uint8 _newTxFee) public onlyOwner {
692         OwnertxFee = _newTxFee;
693     }
694 
695     // assign a new fee distributor address
696     function setFeeDistributor(address _distributor) public onlyOwner {
697         feeDistributor = _distributor;
698     }
699     
700     
701     // assign a Owner fee distributor address
702     function setOwnerFeeDistributor(address _distributor) public onlyOwner {
703         OwnerfeeDistributor = _distributor;
704     }
705 
706      // enable/disable sender who can send feeless transactions
707     function setFeelessSender(address _sender, bool _feeless) public onlyOwner {
708         require(!_feeless || _feeless && canWhitelist, "cannot add to whitelist");
709         feelessSender[_sender] = _feeless;
710     }
711 
712     // enable/disable recipient who can reccieve feeless transactions
713     function setFeelessReciever(address _recipient, bool _feeless) public onlyOwner {
714         require(!_feeless || _feeless && canWhitelist, "cannot add to whitelist");
715         feelessReciever[_recipient] = _feeless;
716     }
717 
718     // disable adding to whitelist forever
719     function renounceWhitelist() public onlyOwner {
720         // adding to whitelist has been disabled forever:
721         canWhitelist = false;
722     }
723 
724     // to caclulate the amounts for recipient and distributer after fees have been applied
725     function calculateAmountsAfterFee(
726         address sender,
727         address recipient,
728         uint256 amount
729     ) public view returns (uint256 transferToAmount, uint256 transferToFeeDistributorAmount, uint256 transferToOwnerFeeDistributorAmount) {
730 
731         // check if fees should apply to this transaction
732         if (feelessSender[sender] || feelessReciever[recipient]) {
733             return (amount, 0, 0);
734         }
735 
736         // calculate fees and amounts
737         uint256 fee = amount.mul(txFee).div(1000);
738         uint256 Ownerfee = amount.mul(OwnertxFee).div(1000);
739         return (amount.sub(fee.add(Ownerfee)), fee, Ownerfee);
740     }
741 
742     /**
743      * @dev Moves tokens `amount` from `sender` to `recipient`.
744      *
745      * This is internal function is equivalent to {transfer}, and can be used to
746      * e.g. implement automatic token fees, slashing mechanisms, etc.
747      *
748      * Emits a {Transfer} event.
749      *
750      * Requirements:
751      *
752      * - `sender` cannot be the zero address.
753      * - `recipient` cannot be the zero address.
754      * - `sender` must have a balance of at least `amount`.
755      */
756     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
757         require(sender != address(0), "ERC20: transfer from the zero address");
758         require(recipient != address(0), "ERC20: transfer to the zero address");
759         require(amount > 1000, "amount to small, maths will break");
760         _beforeTokenTransfer(sender, recipient, amount);
761 
762         // subtract send balanced
763         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
764 
765         // calculate fee:
766         (uint256 transferToAmount, uint256 transferToFeeDistributorAmount, uint256 transferToOwnerFeeDistributorAmount) = calculateAmountsAfterFee(sender, recipient, amount);
767 
768         // update recipients balance:
769         _balances[recipient] = _balances[recipient].add(transferToAmount);
770         emit Transfer(sender, recipient, transferToAmount);
771 
772         // update distributers balance:
773         if(transferToFeeDistributorAmount > 0 && feeDistributor != address(0)){
774             _balances[feeDistributor] = _balances[feeDistributor].add(transferToFeeDistributorAmount);
775             _balances[OwnerfeeDistributor] = _balances[OwnerfeeDistributor].add(transferToOwnerFeeDistributorAmount);
776             emit Transfer(sender, feeDistributor, transferToFeeDistributorAmount);
777             emit Transfer(sender, OwnerfeeDistributor, transferToOwnerFeeDistributorAmount);
778         }
779     }
780 
781     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
782      * the total supply.
783      *
784      * Emits a {Transfer} event with `from` set to the zero address.
785      *
786      * Requirements
787      *
788      * - `to` cannot be the zero address.
789      */
790     function _mint(address account, uint256 amount) internal virtual {
791         require(account != address(0), "ERC20: mint to the zero address");
792 
793         _beforeTokenTransfer(address(0), account, amount);
794 
795         _totalSupply = _totalSupply.add(amount);
796         _balances[account] = _balances[account].add(amount);
797         emit Transfer(address(0), account, amount);
798     }
799 
800     /**
801      * @dev Destroys `amount` tokens from `account`, reducing the
802      * total supply.
803      *
804      * Emits a {Transfer} event with `to` set to the zero address.
805      *
806      * Requirements
807      *
808      * - `account` cannot be the zero address.
809      * - `account` must have at least `amount` tokens.
810      */
811     function _burn(address account, uint256 amount) internal virtual {
812         require(account != address(0), "ERC20: burn from the zero address");
813 
814         _beforeTokenTransfer(account, address(0), amount);
815 
816         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
817         _totalSupply = _totalSupply.sub(amount);
818         emit Transfer(account, address(0), amount);
819     }
820 
821     /**
822      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
823      *
824      * This internal function is equivalent to `approve`, and can be used to
825      * e.g. set automatic allowances for certain subsystems, etc.
826      *
827      * Emits an {Approval} event.
828      *
829      * Requirements:
830      *
831      * - `owner` cannot be the zero address.
832      * - `spender` cannot be the zero address.
833      */
834     function _approve(address owner, address spender, uint256 amount) internal virtual {
835         require(owner != address(0), "ERC20: approve from the zero address");
836         require(spender != address(0), "ERC20: approve to the zero address");
837 
838         _allowances[owner][spender] = amount;
839         emit Approval(owner, spender, amount);
840     }
841 
842     /**
843      * @dev Sets {decimals} to a value other than the default one of 18.
844      *
845      * WARNING: This function should only be called from the constructor. Most
846      * applications that interact with token contracts will not expect
847      * {decimals} to ever change, and may work incorrectly if it does.
848      */
849     function _setupDecimals(uint8 decimals_) internal {
850         _decimals = decimals_;
851     }
852 
853     /**
854      * @dev Hook that is called before any transfer of tokens. This includes
855      * minting and burning.
856      *
857      * Calling conditions:
858      *
859      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
860      * will be to transferred to `to`.
861      * - when `from` is zero, `amount` tokens will be minted for `to`.
862      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
863      * - `from` and `to` are never both zero.
864      *
865      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
866      */
867     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
868 }
869 
870 
871 /**
872  * The Hype_Bet Token itself is just a standard ERC20, with:
873  * No minting.
874  * .
875  * Transfer fee applied.
876  */
877 contract Hype_Bet is DeflationaryERC20 {
878 
879     constructor() DeflationaryERC20("Hype.Bet", "Hype.Bet") {
880         
881         _mint(msg.sender, 1000000e18);
882     }
883 
884     function burn(uint256 amount) public {
885         _burn(msg.sender, amount);
886     }
887 }