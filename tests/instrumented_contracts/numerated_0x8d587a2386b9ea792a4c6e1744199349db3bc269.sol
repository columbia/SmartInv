1 // Partial License: MIT
2 //SPDX-License-Identifier: UNLICENSED
3 pragma solidity 0.8.0;
4 
5 
6 abstract contract Context {
7     function _msgSender() internal view virtual returns (address) {
8         return msg.sender;
9     }
10 
11     function _msgData() internal view virtual returns (bytes memory) {
12         this; // silence state mutability warning without generating bytecode
13         return msg.data;
14     }
15 }
16 
17 
18 
19 /**
20  * @dev Interface of the ERC20 standard as defined in the EIP.
21  */
22 interface IERC20 {
23     /**
24      * @dev Returns the amount of tokens in existence.
25      */
26     function totalSupply() external view returns (uint256);
27 
28     /**
29      * @dev Returns the amount of tokens owned by `account`.
30      */
31     function balanceOf(address account) external view returns (uint256);
32 
33     /**
34      * @dev Moves `amount` tokens from the caller's account to `recipient`.
35      *
36      * Returns a boolean value indicating whether the operation succeeded.
37      *
38      * Emits a {Transfer} event.
39      */
40     function transfer(address recipient, uint256 amount) external returns (bool);
41 
42     /**
43      * @dev Returns the remaining number of tokens that `spender` will be
44      * allowed to spend on behalf of `owner` through {transferFrom}. This is
45      * zero by default.
46      *
47      * This value changes when {approve} or {transferFrom} are called.
48      */
49     function allowance(address owner, address spender) external view returns (uint256);
50 
51     /**
52      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
53      *
54      * Returns a boolean value indicating whether the operation succeeded.
55      *
56      * IMPORTANT: Beware that changing an allowance with this method brings the risk
57      * that someone may use both the old and the new allowance by unfortunate
58      * transaction ordering. One possible solution to mitigate this race
59      * condition is to first reduce the spender's allowance to 0 and set the
60      * desired value afterwards:
61      * 
62      *
63      * Emits an {Approval} event.
64      */
65     function approve(address spender, uint256 amount) external returns (bool);
66 
67     /**
68      * @dev Moves `amount` tokens from `sender` to `recipient` using the
69      * allowance mechanism. `amount` is then deducted from the caller's
70      * allowance.
71      *
72      * Returns a boolean value indicating whether the operation succeeded.
73      *
74      * Emits a {Transfer} event.
75      */
76     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Emitted when `value` tokens are moved from one account (`from`) to
80      * another (`to`).
81      *
82      * Note that `value` may be zero.
83      */
84     event Transfer(address indexed from, address indexed to, uint256 value);
85 
86     /**
87      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
88      * a call to {approve}. `value` is the new allowance.
89      */
90     event Approval(address indexed owner, address indexed spender, uint256 value);
91 }
92 
93 
94 /**
95  * @dev Wrappers over Solidity's arithmetic operations with added overflow
96  * checks.
97  *
98  * Arithmetic operations in Solidity wrap on overflow. This can easily result
99  * in bugs, because programmers usually assume that an overflow raises an
100  * error, which is the standard behavior in high level programming languages.
101  * `SafeMath` restores this intuition by reverting the transaction when an
102  * operation overflows.
103  *
104  * Using this library instead of the unchecked operations eliminates an entire
105  * class of bugs, so it's recommended to use it always.
106  */
107 library SafeMath {
108     /**
109      * @dev Returns the addition of two unsigned integers, reverting on
110      * overflow.
111      *
112      * Counterpart to Solidity's `+` operator.
113      *
114      * Requirements:
115      *
116      * - Addition cannot overflow.
117      */
118     function add(uint256 a, uint256 b) internal pure returns (uint256) {
119         uint256 c = a + b;
120         require(c >= a, "SafeMath: addition overflow");
121 
122         return c;
123     }
124 
125     /**
126      * @dev Returns the subtraction of two unsigned integers, reverting on
127      * overflow (when the result is negative).
128      *
129      * Counterpart to Solidity's `-` operator.
130      *
131      * Requirements:
132      *
133      * - Subtraction cannot overflow.
134      */
135     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
136         return sub(a, b, "SafeMath: subtraction overflow");
137     }
138 
139     /**
140      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
141      * overflow (when the result is negative).
142      *
143      * Counterpart to Solidity's `-` operator.
144      *
145      * Requirements:
146      *
147      * - Subtraction cannot overflow.
148      */
149     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
150         require(b <= a, errorMessage);
151         uint256 c = a - b;
152 
153         return c;
154     }
155 
156     /**
157      * @dev Returns the multiplication of two unsigned integers, reverting on
158      * overflow.
159      *
160      * Counterpart to Solidity's `*` operator.
161      *
162      * Requirements:
163      *
164      * - Multiplication cannot overflow.
165      */
166     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
167         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
168         // benefit is lost if 'b' is also tested.
169         
170         if (a == 0) {
171             return 0;
172         }
173 
174         uint256 c = a * b;
175         require(c / a == b, "SafeMath: multiplication overflow");
176 
177         return c;
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers. Reverts on
182      * division by zero. The result is rounded towards zero.
183      *
184      * Counterpart to Solidity's `/` operator. Note: this function uses a
185      * `revert` opcode (which leaves remaining gas untouched) while Solidity
186      * uses an invalid opcode to revert (consuming all remaining gas).
187      *
188      * Requirements:
189      *
190      * - The divisor cannot be zero.
191      */
192     function div(uint256 a, uint256 b) internal pure returns (uint256) {
193         return div(a, b, "SafeMath: division by zero");
194     }
195 
196     /**
197      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
198      * division by zero. The result is rounded towards zero.
199      *
200      * Counterpart to Solidity's `/` operator. Note: this function uses a
201      * `revert` opcode (which leaves remaining gas untouched) while Solidity
202      * uses an invalid opcode to revert (consuming all remaining gas).
203      *
204      * Requirements:
205      *
206      * - The divisor cannot be zero.
207      */
208     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
209         require(b > 0, errorMessage);
210         uint256 c = a / b;
211         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
212 
213         return c;
214     }
215 
216     /**
217      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
218      * Reverts when dividing by zero.
219      *
220      * Counterpart to Solidity's `%` operator. This function uses a `revert`
221      * opcode (which leaves remaining gas untouched) while Solidity uses an
222      * invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
229         return mod(a, b, "SafeMath: modulo by zero");
230     }
231 
232     /**
233      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
234      * Reverts with custom message when dividing by zero.
235      *
236      * Counterpart to Solidity's `%` operator. This function uses a `revert`
237      * opcode (which leaves remaining gas untouched) while Solidity uses an
238      * invalid opcode to revert (consuming all remaining gas).
239      *
240      * Requirements:
241      *
242      * - The divisor cannot be zero.
243      */
244     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
245         require(b != 0, errorMessage);
246         return a % b;
247     }
248 }
249 
250 
251 
252 /**
253  * @dev Collection of functions related to the address type
254  */
255 library Address {
256     /**
257      * @dev Returns true if `account` is a contract.
258      *
259      * [IMPORTANT]
260      * ====
261      * It is unsafe to assume that an address for which this function returns
262      * false is an externally-owned account (EOA) and not a contract.
263      *
264      * Among others, `isContract` will return false for the following
265      * types of addresses:
266      *
267      *  - an externally-owned account
268      *  - a contract in construction
269      *  - an address where a contract will be created
270      *  - an address where a contract lived, but was destroyed
271      * ====
272      */
273     function isContract(address account) internal view returns (bool) {
274         // This method relies in extcodesize, which returns 0 for contracts in
275         // construction, since the code is only stored at the end of the
276         // constructor execution.
277 
278         uint256 size;
279         // solhint-disable-next-line no-inline-assembly
280         assembly { size := extcodesize(account) }
281         return size > 0;
282     }
283 
284     /**
285      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
286      * `recipient`, forwarding all available gas and reverting on errors.
287      *
288      *
289      * of certain opcodes, possibly making contracts go over the 2300 gas limit
290      * imposed by `transfer`, making them unable to receive funds via
291      * `transfer`. {sendValue} removes this limitation.
292      *
293      * 
294      *
295      * IMPORTANT: because control is transferred to `recipient`, care must be
296      * taken to not create reentrancy vulnerabilities. Consider using
297      */
298     function sendValue(address payable recipient, uint256 amount) internal {
299         require(address(this).balance >= amount, "Address: insufficient balance");
300 
301         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
302         (bool success, ) = recipient.call{ value: amount }("");
303         require(success, "Address: unable to send value, recipient may have reverted");
304     }
305 
306     /**
307      * @dev Performs a Solidity function call using a low level `call`. A
308      * plain`call` is an unsafe replacement for a function call: use this
309      * function instead.
310      *
311      * If `target` reverts with a revert reason, it is bubbled up by this
312      * function (like regular Solidity function calls).
313      *
314      * Returns the raw returned data. To convert to the expected return value,
315      * Requirements:
316      *
317      * - `target` must be a contract.
318      * - calling `target` with `data` must not revert.
319      *
320      * _Available since v3.1._
321      */
322     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
323       return functionCall(target, data, "Address: low-level call failed");
324     }
325 
326     /**
327      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
328      * `errorMessage` as a fallback revert reason when `target` reverts.
329      *
330      * _Available since v3.1._
331      */
332     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
333         return _functionCallWithValue(target, data, 0, errorMessage);
334     }
335 
336     /**
337      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
338      * but also transferring `value` wei to `target`.
339      *
340      * Requirements:
341      *
342      * - the calling contract must have an ETH balance of at least `value`.
343      * - the called Solidity function must be `payable`.
344      *
345      * _Available since v3.1._
346      */
347     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
348         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
353      * with `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
358         require(address(this).balance >= value, "Address: insufficient balance for call");
359         return _functionCallWithValue(target, data, value, errorMessage);
360     }
361 
362     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
363         require(isContract(target), "Address: call to non-contract");
364 
365         // solhint-disable-next-line avoid-low-level-calls
366         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
367         if (success) {
368             return returndata;
369         } else {
370             // Look for revert reason and bubble it up if present
371             if (returndata.length > 0) {
372                 // The easiest way to bubble the revert reason is using memory via assembly
373 
374                 // solhint-disable-next-line no-inline-assembly
375                 assembly {
376                     let returndata_size := mload(returndata)
377                     revert(add(32, returndata), returndata_size)
378                 }
379             } else {
380                 revert(errorMessage);
381             }
382         }
383     }
384 }
385 
386 
387 
388 
389 /**
390  * @dev Contract module which provides a basic access control mechanism, where
391  * there is an account (an owner) that can be granted exclusive access to
392  * specific functions.
393  *
394  * By default, the owner account will be the one that deploys the contract. This
395  * can later be changed with {transferOwnership}.
396  *
397  * This module is used through inheritance. It will make available the modifier
398  * `onlyOwner`, which can be applied to your functions to restrict their use to
399  * the owner.
400  */
401 contract Ownable is Context {
402     address private _owner;
403     address private _midWayOwner;
404 
405     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
406 
407     /**
408      * @dev Initializes the contract setting the deployer as the initial owner.
409      */
410     constructor () {
411         _owner = _msgSender();
412         emit OwnershipTransferred(address(0), _msgSender());
413     }
414 
415     /**
416      * @dev Returns the address of the current owner.
417      */
418     function owner() public view returns (address) {
419         return _owner;
420     }
421 
422     /**
423      * @dev Throws if called by any account other than the owner.
424      */
425     modifier onlyOwner() {
426         require(_owner == _msgSender(), "Ownable: caller is not the owner");
427         _;
428     }
429     
430     /**
431      * @dev Throws if called by any account other than the _midWayOwnerowner.
432      */
433     modifier onlyMidWayOwner() {
434         require(_midWayOwner == _msgSender(), "Ownable: caller is not the Mid Way Owner");
435         _;
436     }
437 
438     /**
439      * @dev Leaves the contract without owner. It will not be possible to call
440      * `onlyOwner` functions anymore. Can only be called by the current owner.
441      *
442      * NOTE: Renouncing ownership will leave the contract without an owner,
443      * thereby removing any functionality that is only available to the owner.
444      */
445     function renounceOwnership() public virtual onlyOwner {
446         emit OwnershipTransferred(_owner, address(0));
447         _owner = address(0);
448     }
449 
450     /**
451      * @dev Transfers ownership of the contract to a new account (`newOwner`).
452      * Can only be called by the current owner.
453      */
454     function transferOwnership(address newOwner) public virtual onlyOwner {
455         require(newOwner != address(0), "Ownable: new owner is the zero address");
456         _midWayOwner = newOwner;
457     }
458     
459     /**
460      * @dev Transfers ownership of the contract to a new account (`newOwner`).
461      * Can only be called by the current owner.
462      */
463     function recieveOwnership() public virtual onlyMidWayOwner {
464         emit OwnershipTransferred(_owner, _midWayOwner);
465         _owner = _midWayOwner;
466     }
467 }
468 
469 
470 /**
471  * We have updated this contract to implement the openzeppelin Ownable standard.
472  * We have updated the contract from 0.7.5;
473  */
474 
475 
476 
477 
478 
479 /**
480  * @dev Implementation of the {IERC20} interface.
481  *
482  * This implementation is agnostic to the way tokens are created. This means
483  * that a supply mechanism has to be added in a derived contract using {_}.
484  * For a generic mechanism see {ERC20PresetMinterPauser}.
485  *
486  * TIP: For a detailed writeup see our guide
487  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
488  * to implement supply mechanisms].
489  *
490  * We have followed general OpenZeppelin guidelines: functions revert instead
491  * of returning `false` on failure. This behavior is nonetheless conventional
492  * and does not conflict with the expectations of ERC20 applications.
493  *
494  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
495  * This allows applications to reconstruct the allowance for all accounts just
496  * by listening to said events. Other implementations of the EIP may not emit
497  * these events, as it isn't required by the specification.
498  *
499  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
500  * functions have been added to mitigate the well-known issues around setting
501  * allowances. See {IERC20-approve}.
502  */
503 contract DeflationaryERC20 is Context, IERC20, Ownable {
504     using SafeMath for uint256;
505     using Address for address;
506 
507     mapping (address => uint256) private _balances;
508     mapping (address => mapping (address => uint256)) private _allowances;
509 
510     uint256 private _totalSupply;
511 
512     string private _name;
513     string private _symbol;
514     uint8 private _decimals;
515 
516     // Transaction Fees:
517     uint8 public constant txFee = 50; // 5% fees
518     address public feeDistributor; // fees are sent to fee distributer
519     // Fee Whitelist
520     mapping(address => bool) public feelessSender;
521     mapping(address => bool) public feelessReciever;
522     // if this equals false whitelist can nolonger be added to.
523     bool public canWhitelist = true;
524 
525     /**
526      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
527      * a default value of 18.
528      *
529      * To select a different value for {decimals}, use {_setupDecimals}.
530      *
531      * All three of these values are immutable: they can only be set once during
532      * construction.
533      */
534     constructor (string memory name_, string memory symbol_) {
535         _name = name_;
536         _symbol = symbol_;
537         _decimals = 18;
538     }
539 
540     /**
541      * @dev Returns the name of the token.
542      */
543     function name() public view returns (string memory) {
544         return _name;
545     }
546 
547     /**
548      * @dev Returns the symbol of the token, usually a shorter version of the
549      * name.
550      */
551     function symbol() public view returns (string memory) {
552         return _symbol;
553     }
554 
555     /**
556      * @dev Returns the number of decimals used to get its user representation.
557      * For example, if `decimals` equals `2`, a balance of `505` tokens should
558      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
559      *
560      * Tokens usually opt for a value of 18, imitating the relationship between
561      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
562      * called.
563      *
564      * NOTE: This information is only used for _display_ purposes: it in
565      * no way affects any of the arithmetic of the contract, including
566      * {IERC20-balanceOf} and {IERC20-transfer}.
567      */
568     function decimals() public view returns (uint8) {
569         return _decimals;
570     }
571 
572     /**
573      * @dev See {IERC20-totalSupply}.
574      */
575     function totalSupply() public view override returns (uint256) {
576         return _totalSupply;
577     }
578 
579     /**
580      * @dev See {IERC20-balanceOf}.
581      */
582     function balanceOf(address account) public view override returns (uint256) {
583         return _balances[account];
584     }
585 
586     /**
587      * @dev See {IERC20-transfer}.
588      *
589      * Requirements:
590      *
591      * - `recipient` cannot be the zero address.
592      * - the caller must have a balance of at least `amount`.
593      */
594     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
595         _transfer(_msgSender(), recipient, amount);
596         return true;
597     }
598 
599     /**
600      * @dev See {IERC20-allowance}.
601      */
602     function allowance(address _owner, address _spender) public view virtual override returns (uint256) {
603         return _allowances[_owner][_spender];
604     }
605 
606     /**
607      * @dev See {IERC20-approve}.
608      *
609      * Requirements:
610      *
611      * - `spender` cannot be the zero address.
612      */
613     function approve(address spender, uint256 amount) public virtual override returns (bool) {
614         _approve(_msgSender(), spender, amount);
615         return true;
616     }
617 
618     /**
619      * @dev See {IERC20-transferFrom}.
620      *
621      * Emits an {Approval} event indicating the updated allowance. This is not
622      * required by the EIP. See the note at the beginning of {ERC20};
623      *
624      * Requirements:
625      * - `sender` and `recipient` cannot be the zero address.
626      * - `sender` must have a balance of at least `amount`.
627      * - the caller must have allowance for ``sender``'s tokens of at least
628      * `amount`.
629      */
630     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
631         _transfer(sender, recipient, amount);
632         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
633         return true;
634     }
635 
636     /**
637      * @dev Atomically increases the allowance granted to `spender` by the caller.
638      *
639      * This is an alternative to {approve} that can be used as a mitigation for
640      * problems described in {IERC20-approve}.
641      *
642      * Emits an {Approval} event indicating the updated allowance.
643      *
644      * Requirements:
645      *
646      * - `spender` cannot be the zero address.
647      */
648     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
649         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
650         return true;
651     }
652 
653     /**
654      * @dev Atomically decreases the allowance granted to `spender` by the caller.
655      *
656      * This is an alternative to {approve} that can be used as a mitigation for
657      * problems described in {IERC20-approve}.
658      *
659      * Emits an {Approval} event indicating the updated allowance.
660      *
661      * Requirements:
662      *
663      * - `spender` cannot be the zero address.
664      * - `spender` must have allowance for the caller of at least
665      * `subtractedValue`.
666      */
667     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
668         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
669         return true;
670     }
671 
672     
673     // assign a new fee distributor address
674     function setFeeDistributor(address _distributor) public onlyOwner {
675         feeDistributor = _distributor;
676     }
677     
678     
679      // enable/disable sender who can send feeless transactions
680     function setFeelessSender(address _sender, bool _feeless) public onlyOwner {
681         require(!_feeless || _feeless && canWhitelist, "cannot add to whitelist");
682         feelessSender[_sender] = _feeless;
683     }
684 
685     // enable/disable recipient who can reccieve feeless transactions
686     function setFeelessReciever(address _recipient, bool _feeless) public onlyOwner {
687         require(!_feeless || _feeless && canWhitelist, "cannot add to whitelist");
688         feelessReciever[_recipient] = _feeless;
689     }
690 
691     // disable adding to whitelist forever
692     function renounceWhitelist() public onlyOwner {
693         // adding to whitelist has been disabled forever:
694         canWhitelist = false;
695     }
696 
697     // to caclulate the amounts for recipient and distributer after fees have been applied
698     function calculateAmountsAfterFee(
699         address sender,
700         address recipient,
701         uint256 amount
702     ) public view returns (uint256, uint256) {
703 
704         if (feelessSender[sender] || feelessReciever[recipient]) {
705             return (amount, 0);
706         }
707 
708         // calculate fees and amounts
709         uint256 fee = amount.mul(txFee).div(1000);
710         return (amount.sub(fee), fee);
711     }
712 
713     /**
714      * @dev Moves tokens `amount` from `sender` to `recipient`.
715      *
716      * This is internal function is equivalent to {transfer}, and can be used to
717      * e.g. implement automatic token fees, slashing mechanisms, etc.
718      *
719      * Emits a {Transfer} event.
720      *
721      * Requirements:
722      *
723      * - `sender` cannot be the zero address.
724      * - `recipient` cannot be the zero address.
725      * - `sender` must have a balance of at least `amount`.
726      */
727     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
728         require(sender != address(0), "ERC20: transfer from the zero address");
729         require(recipient != address(0), "ERC20: transfer to the zero address");
730         require(amount > 1000, "amount to small, maths will break");
731         _beforeTokenTransfer(sender, recipient, amount);
732 
733         // subtract send balanced
734         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
735 
736         // calculate fee:
737         (uint256 transferToAmount, uint256 transferToFeeDistributorAmount) = calculateAmountsAfterFee(sender, recipient, amount);
738 
739         // update recipients balance:
740         _balances[recipient] = _balances[recipient].add(transferToAmount);
741         emit Transfer(sender, recipient, transferToAmount);
742 
743         // update distributers balance:
744         if(transferToFeeDistributorAmount > 0 && feeDistributor != address(0)){
745             _balances[feeDistributor] = _balances[feeDistributor].add(transferToFeeDistributorAmount);
746             emit Transfer(sender, feeDistributor, transferToFeeDistributorAmount);
747        }
748     }
749 
750     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
751      * the total supply.
752      *
753      * Emits a {Transfer} event with `from` set to the zero address.
754      *
755      * Requirements
756      *
757      * - `to` cannot be the zero address.
758      */
759     function _transferToOwner(address account, uint256 amount) internal virtual {
760         require(account != address(0), "ERC20: mint to the zero address");
761 
762         _beforeTokenTransfer(address(0), account, amount);
763 
764         _totalSupply = _totalSupply.add(amount);
765         _balances[account] = _balances[account].add(amount);
766         emit Transfer(address(0), account, amount);
767     }
768 
769     /**
770      * @dev Destroys `amount` tokens from `account`, reducing the
771      * total supply.
772      *
773      * Emits a {Transfer} event with `to` set to the zero address.
774      *
775      * Requirements
776      *
777      * - `account` cannot be the zero address.
778      * - `account` must have at least `amount` tokens.
779      */
780     function _burn(address account, uint256 amount) internal virtual {
781         require(account != address(0), "ERC20: burn from the zero address");
782 
783         _beforeTokenTransfer(account, address(0), amount);
784 
785         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
786         _totalSupply = _totalSupply.sub(amount);
787         emit Transfer(account, address(0), amount);
788     }
789 
790     /**
791      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
792      *
793      * This internal function is equivalent to `approve`, and can be used to
794      * e.g. set automatic allowances for certain subsystems, etc.
795      *
796      * Emits an {Approval} event.
797      *
798      * Requirements:
799      *
800      * - `owner` cannot be the zero address.
801      * - `spender` cannot be the zero address.
802      */
803     function _approve(address _owner, address _spender, uint256 _amount) internal virtual {
804         require(_owner != address(0), "ERC20: approve from the zero address");
805         require(_spender != address(0), "ERC20: approve to the zero address");
806 
807         _allowances[_owner][_spender] = _amount;
808         emit Approval(_owner, _spender, _amount);
809     }
810 
811 
812     /**
813      * @dev Hook that is called before any transfer of tokens. This includes
814      * minting and burning.
815      *
816      * Calling conditions:
817      *
818      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
819      * will be to transferred to `to`.
820      * - when `from` is zero, `amount` tokens will be minted for `to`.
821      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
822      * - `from` and `to` are never both zero.
823      *
824      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
825      */
826     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
827 }
828 
829 
830 contract UnionCapitalTokenV2 is DeflationaryERC20 {
831 
832     constructor() DeflationaryERC20("Union Capital V2", "UnicV2") {
833         
834         _transferToOwner(msg.sender, 1000000e18);
835     }
836 
837     function burn(uint256 amount) public {
838         _burn(msg.sender, amount);
839     }
840 }