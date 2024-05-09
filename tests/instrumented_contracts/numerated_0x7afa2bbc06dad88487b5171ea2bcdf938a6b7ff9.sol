1 // File: @openzeppelin/contracts/GSN/Context.sol
2 
3 // SPDX-License-Identifier: MIT + WTFTL
4 
5 pragma solidity ^0.6.0;
6 
7 /*
8  * @dev Provides information about the current execution context, including the
9  * sender of the transaction and its data. While these are generally available
10  * via msg.sender and msg.data, they should not be accessed in such a direct
11  * manner, since when dealing with GSN meta-transactions the account sending and
12  * paying for execution may not be the actual sender (as far as an application
13  * is concerned).
14  *
15  * This contract is only required for intermediate, library-like contracts.
16  */
17 abstract contract Context {
18     function _msgSender() internal view virtual returns (address payable) {
19         return msg.sender;
20     }
21 
22     function _msgData() internal view virtual returns (bytes memory) {
23         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
24         return msg.data;
25     }
26 }
27 
28 // File: @openzeppelin/contracts/access/Ownable.sol
29 
30 
31 
32 pragma solidity ^0.6.0;
33 
34 /**
35  * @dev Contract module which provides a basic access control mechanism, where
36  * there is an account (an owner) that can be granted exclusive access to
37  * specific functions.
38  *
39  * By default, the owner account will be the one that deploys the contract. This
40  * can later be changed with {transferOwnership}.
41  *
42  * This module is used through inheritance. It will make available the modifier
43  * `onlyOwner`, which can be applied to your functions to restrict their use to
44  * the owner.
45  */
46 contract Ownable is Context {
47     address private _owner;
48 
49     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
50 
51     /**
52      * @dev Initializes the contract setting the deployer as the initial owner.
53      */
54     constructor () internal {
55         address msgSender = _msgSender();
56         _owner = msgSender;
57         emit OwnershipTransferred(address(0), msgSender);
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(_owner == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         emit OwnershipTransferred(_owner, address(0));
84         _owner = address(0);
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         emit OwnershipTransferred(_owner, newOwner);
94         _owner = newOwner;
95     }
96 }
97 
98 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
99 
100 
101 
102 pragma solidity ^0.6.0;
103 
104 /**
105  * @dev Interface of the ERC20 standard as defined in the EIP.
106  */
107 interface IERC20 {
108     /**
109      * @dev Returns the amount of tokens in existence.
110      */
111     function totalSupply() external view returns (uint256);
112 
113     /**
114      * @dev Returns the amount of tokens owned by `account`.
115      */
116     function balanceOf(address account) external view returns (uint256);
117 
118     /**
119      * @dev Moves `amount` tokens from the caller's account to `recipient`.
120      *
121      * Returns a boolean value indicating whether the operation succeeded.
122      *
123      * Emits a {Transfer} event.
124      */
125     function transfer(address recipient, uint256 amount) external returns (bool);
126 
127     /**
128      * @dev Returns the remaining number of tokens that `spender` will be
129      * allowed to spend on behalf of `owner` through {transferFrom}. This is
130      * zero by default.
131      *
132      * This value changes when {approve} or {transferFrom} are called.
133      */
134     function allowance(address owner, address spender) external view returns (uint256);
135 
136     /**
137      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
138      *
139      * Returns a boolean value indicating whether the operation succeeded.
140      *
141      * IMPORTANT: Beware that changing an allowance with this method brings the risk
142      * that someone may use both the old and the new allowance by unfortunate
143      * transaction ordering. One possible solution to mitigate this race
144      * condition is to first reduce the spender's allowance to 0 and set the
145      * desired value afterwards:
146      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
147      *
148      * Emits an {Approval} event.
149      */
150     function approve(address spender, uint256 amount) external returns (bool);
151 
152     /**
153      * @dev Moves `amount` tokens from `sender` to `recipient` using the
154      * allowance mechanism. `amount` is then deducted from the caller's
155      * allowance.
156      *
157      * Returns a boolean value indicating whether the operation succeeded.
158      *
159      * Emits a {Transfer} event.
160      */
161     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
162 
163     /**
164      * @dev Emitted when `value` tokens are moved from one account (`from`) to
165      * another (`to`).
166      *
167      * Note that `value` may be zero.
168      */
169     event Transfer(address indexed from, address indexed to, uint256 value);
170 
171     /**
172      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
173      * a call to {approve}. `value` is the new allowance.
174      */
175     event Approval(address indexed owner, address indexed spender, uint256 value);
176 }
177 
178 // File: @openzeppelin/contracts/math/SafeMath.sol
179 
180 
181 
182 pragma solidity ^0.6.0;
183 
184 /**
185  * @dev Wrappers over Solidity's arithmetic operations with added overflow
186  * checks.
187  *
188  * Arithmetic operations in Solidity wrap on overflow. This can easily result
189  * in bugs, because programmers usually assume that an overflow raises an
190  * error, which is the standard behavior in high level programming languages.
191  * `SafeMath` restores this intuition by reverting the transaction when an
192  * operation overflows.
193  *
194  * Using this library instead of the unchecked operations eliminates an entire
195  * class of bugs, so it's recommended to use it always.
196  */
197 library SafeMath {
198     /**
199      * @dev Returns the addition of two unsigned integers, reverting on
200      * overflow.
201      *
202      * Counterpart to Solidity's `+` operator.
203      *
204      * Requirements:
205      *
206      * - Addition cannot overflow.
207      */
208     function add(uint256 a, uint256 b) internal pure returns (uint256) {
209         uint256 c = a + b;
210         require(c >= a, "SafeMath: addition overflow");
211 
212         return c;
213     }
214 
215     /**
216      * @dev Returns the subtraction of two unsigned integers, reverting on
217      * overflow (when the result is negative).
218      *
219      * Counterpart to Solidity's `-` operator.
220      *
221      * Requirements:
222      *
223      * - Subtraction cannot overflow.
224      */
225     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
226         return sub(a, b, "SafeMath: subtraction overflow");
227     }
228 
229     /**
230      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
231      * overflow (when the result is negative).
232      *
233      * Counterpart to Solidity's `-` operator.
234      *
235      * Requirements:
236      *
237      * - Subtraction cannot overflow.
238      */
239     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
240         require(b <= a, errorMessage);
241         uint256 c = a - b;
242 
243         return c;
244     }
245 
246     /**
247      * @dev Returns the multiplication of two unsigned integers, reverting on
248      * overflow.
249      *
250      * Counterpart to Solidity's `*` operator.
251      *
252      * Requirements:
253      *
254      * - Multiplication cannot overflow.
255      */
256     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
257         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
258         // benefit is lost if 'b' is also tested.
259         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
260         if (a == 0) {
261             return 0;
262         }
263 
264         uint256 c = a * b;
265         require(c / a == b, "SafeMath: multiplication overflow");
266 
267         return c;
268     }
269 
270     /**
271      * @dev Returns the integer division of two unsigned integers. Reverts on
272      * division by zero. The result is rounded towards zero.
273      *
274      * Counterpart to Solidity's `/` operator. Note: this function uses a
275      * `revert` opcode (which leaves remaining gas untouched) while Solidity
276      * uses an invalid opcode to revert (consuming all remaining gas).
277      *
278      * Requirements:
279      *
280      * - The divisor cannot be zero.
281      */
282     function div(uint256 a, uint256 b) internal pure returns (uint256) {
283         return div(a, b, "SafeMath: division by zero");
284     }
285 
286     /**
287      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
288      * division by zero. The result is rounded towards zero.
289      *
290      * Counterpart to Solidity's `/` operator. Note: this function uses a
291      * `revert` opcode (which leaves remaining gas untouched) while Solidity
292      * uses an invalid opcode to revert (consuming all remaining gas).
293      *
294      * Requirements:
295      *
296      * - The divisor cannot be zero.
297      */
298     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
299         require(b > 0, errorMessage);
300         uint256 c = a / b;
301         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
302 
303         return c;
304     }
305 
306     /**
307      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
308      * Reverts when dividing by zero.
309      *
310      * Counterpart to Solidity's `%` operator. This function uses a `revert`
311      * opcode (which leaves remaining gas untouched) while Solidity uses an
312      * invalid opcode to revert (consuming all remaining gas).
313      *
314      * Requirements:
315      *
316      * - The divisor cannot be zero.
317      */
318     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
319         return mod(a, b, "SafeMath: modulo by zero");
320     }
321 
322     /**
323      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
324      * Reverts with custom message when dividing by zero.
325      *
326      * Counterpart to Solidity's `%` operator. This function uses a `revert`
327      * opcode (which leaves remaining gas untouched) while Solidity uses an
328      * invalid opcode to revert (consuming all remaining gas).
329      *
330      * Requirements:
331      *
332      * - The divisor cannot be zero.
333      */
334     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
335         require(b != 0, errorMessage);
336         return a % b;
337     }
338 }
339 
340 // File: @openzeppelin/contracts/utils/Address.sol
341 
342 
343 
344 pragma solidity ^0.6.2;
345 
346 /**
347  * @dev Collection of functions related to the address type
348  */
349 library Address {
350     /**
351      * @dev Returns true if `account` is a contract.
352      *
353      * [IMPORTANT]
354      * ====
355      * It is unsafe to assume that an address for which this function returns
356      * false is an externally-owned account (EOA) and not a contract.
357      *
358      * Among others, `isContract` will return false for the following
359      * types of addresses:
360      *
361      *  - an externally-owned account
362      *  - a contract in construction
363      *  - an address where a contract will be created
364      *  - an address where a contract lived, but was destroyed
365      * ====
366      */
367     function isContract(address account) internal view returns (bool) {
368         // This method relies in extcodesize, which returns 0 for contracts in
369         // construction, since the code is only stored at the end of the
370         // constructor execution.
371 
372         uint256 size;
373         // solhint-disable-next-line no-inline-assembly
374         assembly { size := extcodesize(account) }
375         return size > 0;
376     }
377 
378     /**
379      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
380      * `recipient`, forwarding all available gas and reverting on errors.
381      *
382      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
383      * of certain opcodes, possibly making contracts go over the 2300 gas limit
384      * imposed by `transfer`, making them unable to receive funds via
385      * `transfer`. {sendValue} removes this limitation.
386      *
387      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
388      *
389      * IMPORTANT: because control is transferred to `recipient`, care must be
390      * taken to not create reentrancy vulnerabilities. Consider using
391      * {ReentrancyGuard} or the
392      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
393      */
394     function sendValue(address payable recipient, uint256 amount) internal {
395         require(address(this).balance >= amount, "Address: insufficient balance");
396 
397         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
398         (bool success, ) = recipient.call{ value: amount }("");
399         require(success, "Address: unable to send value, recipient may have reverted");
400     }
401 
402     /**
403      * @dev Performs a Solidity function call using a low level `call`. A
404      * plain`call` is an unsafe replacement for a function call: use this
405      * function instead.
406      *
407      * If `target` reverts with a revert reason, it is bubbled up by this
408      * function (like regular Solidity function calls).
409      *
410      * Returns the raw returned data. To convert to the expected return value,
411      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
412      *
413      * Requirements:
414      *
415      * - `target` must be a contract.
416      * - calling `target` with `data` must not revert.
417      *
418      * _Available since v3.1._
419      */
420     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
421       return functionCall(target, data, "Address: low-level call failed");
422     }
423 
424     /**
425      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
426      * `errorMessage` as a fallback revert reason when `target` reverts.
427      *
428      * _Available since v3.1._
429      */
430     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
431         return _functionCallWithValue(target, data, 0, errorMessage);
432     }
433 
434     /**
435      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
436      * but also transferring `value` wei to `target`.
437      *
438      * Requirements:
439      *
440      * - the calling contract must have an ETH balance of at least `value`.
441      * - the called Solidity function must be `payable`.
442      *
443      * _Available since v3.1._
444      */
445     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
446         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
447     }
448 
449     /**
450      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
451      * with `errorMessage` as a fallback revert reason when `target` reverts.
452      *
453      * _Available since v3.1._
454      */
455     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
456         require(address(this).balance >= value, "Address: insufficient balance for call");
457         return _functionCallWithValue(target, data, value, errorMessage);
458     }
459 
460     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
461         require(isContract(target), "Address: call to non-contract");
462 
463         // solhint-disable-next-line avoid-low-level-calls
464         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
465         if (success) {
466             return returndata;
467         } else {
468             // Look for revert reason and bubble it up if present
469             if (returndata.length > 0) {
470                 // The easiest way to bubble the revert reason is using memory via assembly
471 
472                 // solhint-disable-next-line no-inline-assembly
473                 assembly {
474                     let returndata_size := mload(returndata)
475                     revert(add(32, returndata), returndata_size)
476                 }
477             } else {
478                 revert(errorMessage);
479             }
480         }
481     }
482 }
483 
484 // File: contracts/TramsToken.sol
485 
486 
487 
488 pragma solidity 0.6.12;
489 
490 
491 
492 
493 
494 
495 // TramsToken with Governance.
496 contract TramsToken is Context, IERC20, Ownable {
497     using SafeMath for uint256;
498     using Address for address;
499 
500     mapping (address => uint256) private _balances;
501 
502     mapping (address => mapping (address => uint256)) private _allowances;
503 
504     uint256 private _totalSupply;
505 
506     string private _name = "TramsToken";
507     string private _symbol = "TRAMS";
508     uint8 private _decimals = 18;
509 
510     /**
511      * @dev Returns the name of the token.
512      */
513     function name() public view returns (string memory) {
514         return _name;
515     }
516 
517     /**
518      * @dev Returns the symbol of the token, usually a shorter version of the
519      * name.
520      */
521     function symbol() public view returns (string memory) {
522         return _symbol;
523     }
524 
525     /**
526      * @dev Returns the number of decimals used to get its user representation.
527      * For example, if `decimals` equals `2`, a balance of `505` tokens should
528      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
529      *
530      * Tokens usually opt for a value of 18, imitating the relationship between
531      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
532      * called.
533      *
534      * NOTE: This information is only used for _display_ purposes: it in
535      * no way affects any of the arithmetic of the contract, including
536      * {IERC20-balanceOf} and {IERC20-transfer}.
537      */
538     function decimals() public view returns (uint8) {
539         return _decimals;
540     }
541 
542     /**
543      * @dev See {IERC20-totalSupply}.
544      */
545     function totalSupply() public view override returns (uint256) {
546         return _totalSupply;
547     }
548 
549     /**
550      * @dev See {IERC20-balanceOf}.
551      */
552     function balanceOf(address account) public view override returns (uint256) {
553         return _balances[account];
554     }
555 
556     /**
557      * @dev See {IERC20-transfer}.
558      *
559      * Requirements:
560      *
561      * - `recipient` cannot be the zero address.
562      * - the caller must have a balance of at least `amount`.
563      */
564     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
565         _transfer(_msgSender(), recipient, amount);
566         return true;
567     }
568 
569     /**
570      * @dev See {IERC20-allowance}.
571      */
572     function allowance(address owner, address spender) public view virtual override returns (uint256) {
573         return _allowances[owner][spender];
574     }
575 
576     /**
577      * @dev See {IERC20-approve}.
578      *
579      * Requirements:
580      *
581      * - `spender` cannot be the zero address.
582      */
583     function approve(address spender, uint256 amount) public virtual override returns (bool) {
584         _approve(_msgSender(), spender, amount);
585         return true;
586     }
587 
588     /**
589      * @dev See {IERC20-transferFrom}.
590      *
591      * Emits an {Approval} event indicating the updated allowance. This is not
592      * required by the EIP. See the note at the beginning of {ERC20};
593      *
594      * Requirements:
595      * - `sender` and `recipient` cannot be the zero address.
596      * - `sender` must have a balance of at least `amount`.
597      * - the caller must have allowance for ``sender``'s tokens of at least
598      * `amount`.
599      */
600     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
601         _transfer(sender, recipient, amount);
602         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
603         return true;
604     }
605 
606     /**
607      * @dev Atomically increases the allowance granted to `spender` by the caller.
608      *
609      * This is an alternative to {approve} that can be used as a mitigation for
610      * problems described in {IERC20-approve}.
611      *
612      * Emits an {Approval} event indicating the updated allowance.
613      *
614      * Requirements:
615      *
616      * - `spender` cannot be the zero address.
617      */
618     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
619         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
620         return true;
621     }
622 
623     /**
624      * @dev Atomically decreases the allowance granted to `spender` by the caller.
625      *
626      * This is an alternative to {approve} that can be used as a mitigation for
627      * problems described in {IERC20-approve}.
628      *
629      * Emits an {Approval} event indicating the updated allowance.
630      *
631      * Requirements:
632      *
633      * - `spender` cannot be the zero address.
634      * - `spender` must have allowance for the caller of at least
635      * `subtractedValue`.
636      */
637     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
638         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
639         return true;
640     }
641 
642     /**
643      * @dev Moves tokens `amount` from `sender` to `recipient`.
644      *
645      * This is internal function is equivalent to {transfer}, and can be used to
646      * e.g. implement automatic token fees, slashing mechanisms, etc.
647      *
648      * Emits a {Transfer} event.
649      *
650      * Requirements:
651      *
652      * - `sender` cannot be the zero address.
653      * - `recipient` cannot be the zero address.
654      * - `sender` must have a balance of at least `amount`.
655      */
656     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
657         require(sender != address(0), "ERC20: transfer from the zero address");
658         require(recipient != address(0), "ERC20: transfer to the zero address");
659 
660         _beforeTokenTransfer(sender, recipient, amount);
661 
662         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
663         _balances[recipient] = _balances[recipient].add(amount);
664         emit Transfer(sender, recipient, amount);
665 
666         _moveDelegates(_delegates[sender], _delegates[recipient], amount);
667     }
668 
669     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
670      * the total supply.
671      *
672      * Emits a {Transfer} event with `from` set to the zero address.
673      *
674      * Requirements
675      *
676      * - `to` cannot be the zero address.
677      */
678     function _mint(address account, uint256 amount) internal virtual {
679         require(account != address(0), "ERC20: mint to the zero address");
680 
681         _beforeTokenTransfer(address(0), account, amount);
682 
683         _totalSupply = _totalSupply.add(amount);
684         _balances[account] = _balances[account].add(amount);
685         emit Transfer(address(0), account, amount);
686     }
687 
688     /**
689      * @dev Destroys `amount` tokens from `account`, reducing the
690      * total supply.
691      *
692      * Emits a {Transfer} event with `to` set to the zero address.
693      *
694      * Requirements
695      *
696      * - `account` cannot be the zero address.
697      * - `account` must have at least `amount` tokens.
698      */
699     function _burn(address account, uint256 amount) internal virtual {
700         require(account != address(0), "ERC20: burn from the zero address");
701 
702         _beforeTokenTransfer(account, address(0), amount);
703 
704         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
705         _totalSupply = _totalSupply.sub(amount);
706         emit Transfer(account, address(0), amount);
707     }
708 
709     /**
710      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
711      *
712      * This is internal function is equivalent to `approve`, and can be used to
713      * e.g. set automatic allowances for certain subsystems, etc.
714      *
715      * Emits an {Approval} event.
716      *
717      * Requirements:
718      *
719      * - `owner` cannot be the zero address.
720      * - `spender` cannot be the zero address.
721      */
722     function _approve(address owner, address spender, uint256 amount) internal virtual {
723         require(owner != address(0), "ERC20: approve from the zero address");
724         require(spender != address(0), "ERC20: approve to the zero address");
725 
726         _allowances[owner][spender] = amount;
727         emit Approval(owner, spender, amount);
728     }
729 
730     /**
731      * @dev Sets {decimals} to a value other than the default one of 18.
732      *
733      * WARNING: This function should only be called from the constructor. Most
734      * applications that interact with token contracts will not expect
735      * {decimals} to ever change, and may work incorrectly if it does.
736      */
737     function _setupDecimals(uint8 decimals_) internal {
738         _decimals = decimals_;
739     }
740 
741     /**
742      * @dev Hook that is called before any transfer of tokens. This includes
743      * minting and burning.
744      *
745      * Calling conditions:
746      *
747      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
748      * will be to transferred to `to`.
749      * - when `from` is zero, `amount` tokens will be minted for `to`.
750      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
751      * - `from` and `to` are never both zero.
752      *
753      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
754      */
755     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
756 
757     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (TramsMaster).
758     function mint(address _to, uint256 _amount) public onlyOwner {
759         _mint(_to, _amount);
760         _moveDelegates(address(0), _delegates[_to], _amount);
761     }
762 
763     // Copied and modified from YAM code:
764     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
765     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
766     // Which is copied and modified from COMPOUND:
767     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
768 
769     /// @dev A record of each accounts delegate
770     mapping (address => address) internal _delegates;
771 
772     /// @notice A checkpoint for marking number of votes from a given block
773     struct Checkpoint {
774         uint32 fromBlock;
775         uint256 votes;
776     }
777 
778     /// @notice A record of votes checkpoints for each account, by index
779     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
780 
781     /// @notice The number of checkpoints for each account
782     mapping (address => uint32) public numCheckpoints;
783 
784     /// @notice The EIP-712 typehash for the contract's domain
785     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
786 
787     /// @notice The EIP-712 typehash for the delegation struct used by the contract
788     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
789 
790     /// @notice A record of states for signing / validating signatures
791     mapping (address => uint) public nonces;
792 
793     /// @notice An event thats emitted when an account changes its delegate
794     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
795 
796     /// @notice An event thats emitted when a delegate account's vote balance changes
797     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
798 
799     /**
800      * @notice Delegate votes from `msg.sender` to `delegatee`
801      * @param delegator The address to get delegatee for
802      */
803     function delegates(address delegator)
804         external
805         view
806         returns (address)
807     {
808         return _delegates[delegator];
809     }
810 
811    /**
812     * @notice Delegate votes from `msg.sender` to `delegatee`
813     * @param delegatee The address to delegate votes to
814     */
815     function delegate(address delegatee) external {
816         return _delegate(msg.sender, delegatee);
817     }
818 
819     /**
820      * @notice Delegates votes from signatory to `delegatee`
821      * @param delegatee The address to delegate votes to
822      * @param nonce The contract state required to match the signature
823      * @param expiry The time at which to expire the signature
824      * @param v The recovery byte of the signature
825      * @param r Half of the ECDSA signature pair
826      * @param s Half of the ECDSA signature pair
827      */
828     function delegateBySig(
829         address delegatee,
830         uint nonce,
831         uint expiry,
832         uint8 v,
833         bytes32 r,
834         bytes32 s
835     )
836         external
837     {
838         bytes32 domainSeparator = keccak256(
839             abi.encode(
840                 DOMAIN_TYPEHASH,
841                 keccak256(bytes(name())),
842                 getChainId(),
843                 address(this)
844             )
845         );
846 
847         bytes32 structHash = keccak256(
848             abi.encode(
849                 DELEGATION_TYPEHASH,
850                 delegatee,
851                 nonce,
852                 expiry
853             )
854         );
855 
856         bytes32 digest = keccak256(
857             abi.encodePacked(
858                 "\x19\x01",
859                 domainSeparator,
860                 structHash
861             )
862         );
863 
864         address signatory = ecrecover(digest, v, r, s);
865         require(signatory != address(0), "TRAMS::delegateBySig: invalid signature");
866         require(nonce == nonces[signatory]++, "TRAMS::delegateBySig: invalid nonce");
867         require(now <= expiry, "TRAMS::delegateBySig: signature expired");
868         return _delegate(signatory, delegatee);
869     }
870 
871     /**
872      * @notice Gets the current votes balance for `account`
873      * @param account The address to get votes balance
874      * @return The number of current votes for `account`
875      */
876     function getCurrentVotes(address account)
877         external
878         view
879         returns (uint256)
880     {
881         uint32 nCheckpoints = numCheckpoints[account];
882         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
883     }
884 
885     /**
886      * @notice Determine the prior number of votes for an account as of a block number
887      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
888      * @param account The address of the account to check
889      * @param blockNumber The block number to get the vote balance at
890      * @return The number of votes the account had as of the given block
891      */
892     function getPriorVotes(address account, uint blockNumber)
893         external
894         view
895         returns (uint256)
896     {
897         require(blockNumber < block.number, "TRAMS::getPriorVotes: not yet determined");
898 
899         uint32 nCheckpoints = numCheckpoints[account];
900         if (nCheckpoints == 0) {
901             return 0;
902         }
903 
904         // First check most recent balance
905         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
906             return checkpoints[account][nCheckpoints - 1].votes;
907         }
908 
909         // Next check implicit zero balance
910         if (checkpoints[account][0].fromBlock > blockNumber) {
911             return 0;
912         }
913 
914         uint32 lower = 0;
915         uint32 upper = nCheckpoints - 1;
916         while (upper > lower) {
917             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
918             Checkpoint memory cp = checkpoints[account][center];
919             if (cp.fromBlock == blockNumber) {
920                 return cp.votes;
921             } else if (cp.fromBlock < blockNumber) {
922                 lower = center;
923             } else {
924                 upper = center - 1;
925             }
926         }
927         return checkpoints[account][lower].votes;
928     }
929 
930     function _delegate(address delegator, address delegatee)
931         internal
932     {
933         address currentDelegate = _delegates[delegator];
934         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying TRAMS (not scaled);
935         _delegates[delegator] = delegatee;
936 
937         emit DelegateChanged(delegator, currentDelegate, delegatee);
938 
939         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
940     }
941 
942     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
943         if (srcRep != dstRep && amount > 0) {
944             if (srcRep != address(0)) {
945                 // decrease old representative
946                 uint32 srcRepNum = numCheckpoints[srcRep];
947                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
948                 uint256 srcRepNew = srcRepOld.sub(amount);
949                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
950             }
951 
952             if (dstRep != address(0)) {
953                 // increase new representative
954                 uint32 dstRepNum = numCheckpoints[dstRep];
955                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
956                 uint256 dstRepNew = dstRepOld.add(amount);
957                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
958             }
959         }
960     }
961 
962     function _writeCheckpoint(
963         address delegatee,
964         uint32 nCheckpoints,
965         uint256 oldVotes,
966         uint256 newVotes
967     )
968         internal
969     {
970         uint32 blockNumber = safe32(block.number, "TRAMS::_writeCheckpoint: block number exceeds 32 bits");
971 
972         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
973             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
974         } else {
975             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
976             numCheckpoints[delegatee] = nCheckpoints + 1;
977         }
978 
979         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
980     }
981 
982     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
983         require(n < 2**32, errorMessage);
984         return uint32(n);
985     }
986 
987     function getChainId() internal pure returns (uint) {
988         uint256 chainId;
989         assembly { chainId := chainid() }
990         return chainId;
991     }
992 }