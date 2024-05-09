1 // SPDX-License-Identifier: MIT
2 pragma solidity 0.6.12;
3 
4 /**
5  * @dev Interface of the ERC20 standard as defined in the EIP.
6  */
7 interface IERC20 {
8     /**
9      * @dev Returns the amount of tokens in existence.
10      */
11     function totalSupply() external view returns (uint256);
12 
13     /**
14      * @dev Returns the amount of tokens owned by `account`.
15      */
16     function balanceOf(address account) external view returns (uint256);
17 
18     /**
19      * @dev Moves `amount` tokens from the caller's account to `recipient`.
20      *
21      * Returns a boolean value indicating whether the operation succeeded.
22      *
23      * Emits a {Transfer} event.
24      */
25     function transfer(address recipient, uint256 amount) external returns (bool);
26 
27     /**
28      * @dev Returns the remaining number of tokens that `spender` will be
29      * allowed to spend on behalf of `owner` through {transferFrom}. This is
30      * zero by default.
31      *
32      * This value changes when {approve} or {transferFrom} are called.
33      */
34     function allowance(address owner, address spender) external view returns (uint256);
35 
36     /**
37      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
38      *
39      * Returns a boolean value indicating whether the operation succeeded.
40      *
41      * IMPORTANT: Beware that changing an allowance with this method brings the risk
42      * that someone may use both the old and the new allowance by unfortunate
43      * transaction ordering. One possible solution to mitigate this race
44      * condition is to first reduce the spender's allowance to 0 and set the
45      * desired value afterwards:
46      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
47      *
48      * Emits an {Approval} event.
49      */
50     function approve(address spender, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Moves `amount` tokens from `sender` to `recipient` using the
54      * allowance mechanism. `amount` is then deducted from the caller's
55      * allowance.
56      *
57      * Returns a boolean value indicating whether the operation succeeded.
58      *
59      * Emits a {Transfer} event.
60      */
61     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
62 
63     /**
64      * @dev Emitted when `value` tokens are moved from one account (`from`) to
65      * another (`to`).
66      *
67      * Note that `value` may be zero.
68      */
69     event Transfer(address indexed from, address indexed to, uint256 value);
70 
71     /**
72      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
73      * a call to {approve}. `value` is the new allowance.
74      */
75     event Approval(address indexed owner, address indexed spender, uint256 value);
76 }
77 
78 /**
79  * @dev Wrappers over Solidity's arithmetic operations with added overflow
80  * checks.
81  *
82  * Arithmetic operations in Solidity wrap on overflow. This can easily result
83  * in bugs, because programmers usually assume that an overflow raises an
84  * error, which is the standard behavior in high level programming languages.
85  * `SafeMath` restores this intuition by reverting the transaction when an
86  * operation overflows.
87  *
88  * Using this library instead of the unchecked operations eliminates an entire
89  * class of bugs, so it's recommended to use it always.
90  */
91 library SafeMath {
92     /**
93      * @dev Returns the addition of two unsigned integers, reverting on
94      * overflow.
95      *
96      * Counterpart to Solidity's `+` operator.
97      *
98      * Requirements:
99      *
100      * - Addition cannot overflow.
101      */
102     function add(uint256 a, uint256 b) internal pure returns (uint256) {
103         uint256 c = a + b;
104         require(c >= a, "SafeMath: addition overflow");
105 
106         return c;
107     }
108 
109     /**
110      * @dev Returns the subtraction of two unsigned integers, reverting on
111      * overflow (when the result is negative).
112      *
113      * Counterpart to Solidity's `-` operator.
114      *
115      * Requirements:
116      *
117      * - Subtraction cannot overflow.
118      */
119     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
120         return sub(a, b, "SafeMath: subtraction overflow");
121     }
122 
123     /**
124      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
125      * overflow (when the result is negative).
126      *
127      * Counterpart to Solidity's `-` operator.
128      *
129      * Requirements:
130      *
131      * - Subtraction cannot overflow.
132      */
133     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
134         require(b <= a, errorMessage);
135         uint256 c = a - b;
136 
137         return c;
138     }
139 
140     /**
141      * @dev Returns the multiplication of two unsigned integers, reverting on
142      * overflow.
143      *
144      * Counterpart to Solidity's `*` operator.
145      *
146      * Requirements:
147      *
148      * - Multiplication cannot overflow.
149      */
150     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
151         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
152         // benefit is lost if 'b' is also tested.
153         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
154         if (a == 0) {
155             return 0;
156         }
157 
158         uint256 c = a * b;
159         require(c / a == b, "SafeMath: multiplication overflow");
160 
161         return c;
162     }
163 
164     /**
165      * @dev Returns the integer division of two unsigned integers. Reverts on
166      * division by zero. The result is rounded towards zero.
167      *
168      * Counterpart to Solidity's `/` operator. Note: this function uses a
169      * `revert` opcode (which leaves remaining gas untouched) while Solidity
170      * uses an invalid opcode to revert (consuming all remaining gas).
171      *
172      * Requirements:
173      *
174      * - The divisor cannot be zero.
175      */
176     function div(uint256 a, uint256 b) internal pure returns (uint256) {
177         return div(a, b, "SafeMath: division by zero");
178     }
179 
180     /**
181      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
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
192     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
193         require(b > 0, errorMessage);
194         uint256 c = a / b;
195         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
202      * Reverts when dividing by zero.
203      *
204      * Counterpart to Solidity's `%` operator. This function uses a `revert`
205      * opcode (which leaves remaining gas untouched) while Solidity uses an
206      * invalid opcode to revert (consuming all remaining gas).
207      *
208      * Requirements:
209      *
210      * - The divisor cannot be zero.
211      */
212     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
213         return mod(a, b, "SafeMath: modulo by zero");
214     }
215 
216     /**
217      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
218      * Reverts with custom message when dividing by zero.
219      *
220      * Counterpart to Solidity's `%` operator. This function uses a `revert`
221      * opcode (which leaves remaining gas untouched) while Solidity uses an
222      * invalid opcode to revert (consuming all remaining gas).
223      *
224      * Requirements:
225      *
226      * - The divisor cannot be zero.
227      */
228     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
229         require(b != 0, errorMessage);
230         return a % b;
231     }
232 }
233 
234 /*
235  * @dev Provides information about the current execution context, including the
236  * sender of the transaction and its data. While these are generally available
237  * via msg.sender and msg.data, they should not be accessed in such a direct
238  * manner, since when dealing with GSN meta-transactions the account sending and
239  * paying for execution may not be the actual sender (as far as an application
240  * is concerned).
241  *
242  * This contract is only required for intermediate, library-like contracts.
243  */
244 abstract contract Context {
245     function _msgSender() internal view virtual returns (address payable) {
246         return msg.sender;
247     }
248 
249     function _msgData() internal view virtual returns (bytes memory) {
250         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
251         return msg.data;
252     }
253 }
254 
255 /**
256  * @dev Contract module which provides a basic access control mechanism, where
257  * there is an account (an owner) that can be granted exclusive access to
258  * specific functions.
259  *
260  * By default, the owner account will be the one that deploys the contract. This
261  * can later be changed with {transferOwnership}.
262  *
263  * This module is used through inheritance. It will make available the modifier
264  * `onlyOwner`, which can be applied to your functions to restrict their use to
265  * the owner.
266  */
267 contract Ownable is Context {
268     address private _owner;
269 
270     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
271 
272     /**
273      * @dev Initializes the contract setting the deployer as the initial owner.
274      */
275     constructor () internal {
276         address msgSender = _msgSender();
277         _owner = msgSender;
278         emit OwnershipTransferred(address(0), msgSender);
279     }
280 
281     /**
282      * @dev Returns the address of the current owner.
283      */
284     function owner() public view returns (address) {
285         return _owner;
286     }
287 
288     /**
289      * @dev Throws if called by any account other than the owner.
290      */
291     modifier onlyOwner() {
292         require(_owner == _msgSender(), "Ownable: caller is not the owner");
293         _;
294     }
295 
296     /**
297      * @dev Leaves the contract without owner. It will not be possible to call
298      * `onlyOwner` functions anymore. Can only be called by the current owner.
299      *
300      * NOTE: Renouncing ownership will leave the contract without an owner,
301      * thereby removing any functionality that is only available to the owner.
302      */
303     function renounceOwnership() public virtual onlyOwner {
304         emit OwnershipTransferred(_owner, address(0));
305         _owner = address(0);
306     }
307 
308     /**
309      * @dev Transfers ownership of the contract to a new account (`newOwner`).
310      * Can only be called by the current owner.
311      */
312     function transferOwnership(address newOwner) public virtual onlyOwner {
313         require(newOwner != address(0), "Ownable: new owner is the zero address");
314         emit OwnershipTransferred(_owner, newOwner);
315         _owner = newOwner;
316     }
317 }
318 
319 /**
320  * @dev Collection of functions related to the address type
321  */
322 library Address {
323     /**
324      * @dev Returns true if `account` is a contract.
325      *
326      * [IMPORTANT]
327      * ====
328      * It is unsafe to assume that an address for which this function returns
329      * false is an externally-owned account (EOA) and not a contract.
330      *
331      * Among others, `isContract` will return false for the following
332      * types of addresses:
333      *
334      *  - an externally-owned account
335      *  - a contract in construction
336      *  - an address where a contract will be created
337      *  - an address where a contract lived, but was destroyed
338      * ====
339      */
340     function isContract(address account) internal view returns (bool) {
341         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
342         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
343         // for accounts without code, i.e. `keccak256('')`
344         bytes32 codehash;
345         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
346         // solhint-disable-next-line no-inline-assembly
347         assembly { codehash := extcodehash(account) }
348         return (codehash != accountHash && codehash != 0x0);
349     }
350 
351     /**
352      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
353      * `recipient`, forwarding all available gas and reverting on errors.
354      *
355      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
356      * of certain opcodes, possibly making contracts go over the 2300 gas limit
357      * imposed by `transfer`, making them unable to receive funds via
358      * `transfer`. {sendValue} removes this limitation.
359      *
360      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
361      *
362      * IMPORTANT: because control is transferred to `recipient`, care must be
363      * taken to not create reentrancy vulnerabilities. Consider using
364      * {ReentrancyGuard} or the
365      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
366      */
367     function sendValue(address payable recipient, uint256 amount) internal {
368         require(address(this).balance >= amount, "Address: insufficient balance");
369 
370         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
371         (bool success, ) = recipient.call{ value: amount }("");
372         require(success, "Address: unable to send value, recipient may have reverted");
373     }
374 
375     /**
376      * @dev Performs a Solidity function call using a low level `call`. A
377      * plain`call` is an unsafe replacement for a function call: use this
378      * function instead.
379      *
380      * If `target` reverts with a revert reason, it is bubbled up by this
381      * function (like regular Solidity function calls).
382      *
383      * Returns the raw returned data. To convert to the expected return value,
384      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
385      *
386      * Requirements:
387      *
388      * - `target` must be a contract.
389      * - calling `target` with `data` must not revert.
390      *
391      * _Available since v3.1._
392      */
393     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
394       return functionCall(target, data, "Address: low-level call failed");
395     }
396 
397     /**
398      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
399      * `errorMessage` as a fallback revert reason when `target` reverts.
400      *
401      * _Available since v3.1._
402      */
403     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
404         return _functionCallWithValue(target, data, 0, errorMessage);
405     }
406 
407     /**
408      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
409      * but also transferring `value` wei to `target`.
410      *
411      * Requirements:
412      *
413      * - the calling contract must have an ETH balance of at least `value`.
414      * - the called Solidity function must be `payable`.
415      *
416      * _Available since v3.1._
417      */
418     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
419         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
420     }
421 
422     /**
423      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
424      * with `errorMessage` as a fallback revert reason when `target` reverts.
425      *
426      * _Available since v3.1._
427      */
428     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
429         require(address(this).balance >= value, "Address: insufficient balance for call");
430         return _functionCallWithValue(target, data, value, errorMessage);
431     }
432 
433     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
434         require(isContract(target), "Address: call to non-contract");
435 
436         // solhint-disable-next-line avoid-low-level-calls
437         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
438         if (success) {
439             return returndata;
440         } else {
441             // Look for revert reason and bubble it up if present
442             if (returndata.length > 0) {
443                 // The easiest way to bubble the revert reason is using memory via assembly
444 
445                 // solhint-disable-next-line no-inline-assembly
446                 assembly {
447                     let returndata_size := mload(returndata)
448                     revert(add(32, returndata), returndata_size)
449                 }
450             } else {
451                 revert(errorMessage);
452             }
453         }
454     }
455 }
456 
457 /**
458  * @dev Implementation of the {IERC20} interface.
459  *
460  * This implementation is agnostic to the way tokens are created. This means
461  * that a supply mechanism has to be added in a derived contract using {_mint}.
462  * For a generic mechanism see {ERC20PresetMinterPauser}.
463  *
464  * TIP: For a detailed writeup see our guide
465  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
466  * to implement supply mechanisms].
467  *
468  * We have followed general OpenZeppelin guidelines: functions revert instead
469  * of returning `false` on failure. This behavior is nonetheless conventional
470  * and does not conflict with the expectations of ERC20 applications.
471  *
472  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
473  * This allows applications to reconstruct the allowance for all accounts just
474  * by listening to said events. Other implementations of the EIP may not emit
475  * these events, as it isn't required by the specification.
476  *
477  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
478  * functions have been added to mitigate the well-known issues around setting
479  * allowances. See {IERC20-approve}.
480  */
481 contract ERC20 is Context, IERC20 {
482     using SafeMath for uint256;
483     using Address for address;
484 
485     mapping (address => uint256) private _balances;
486 
487     mapping (address => mapping (address => uint256)) private _allowances;
488 
489     uint256 private _totalSupply;
490 
491     string private _name;
492     string private _symbol;
493     uint8 private _decimals;
494 
495     /**
496      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
497      * a default value of 18.
498      *
499      * To select a different value for {decimals}, use {_setupDecimals}.
500      *
501      * All three of these values are immutable: they can only be set once during
502      * construction.
503      */
504     constructor (string memory name, string memory symbol) public {
505         _name = name;
506         _symbol = symbol;
507         _decimals = 18;
508     }
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
665     }
666 
667     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
668      * the total supply.
669      *
670      * Emits a {Transfer} event with `from` set to the zero address.
671      *
672      * Requirements
673      *
674      * - `to` cannot be the zero address.
675      */
676     function _mint(address account, uint256 amount) internal virtual {
677         require(account != address(0), "ERC20: mint to the zero address");
678 
679         _beforeTokenTransfer(address(0), account, amount);
680 
681         _totalSupply = _totalSupply.add(amount);
682         _balances[account] = _balances[account].add(amount);
683         emit Transfer(address(0), account, amount);
684     }
685 
686     /**
687      * @dev Destroys `amount` tokens from `account`, reducing the
688      * total supply.
689      *
690      * Emits a {Transfer} event with `to` set to the zero address.
691      *
692      * Requirements
693      *
694      * - `account` cannot be the zero address.
695      * - `account` must have at least `amount` tokens.
696      */
697     function _burn(address account, uint256 amount) internal virtual {
698         require(account != address(0), "ERC20: burn from the zero address");
699 
700         _beforeTokenTransfer(account, address(0), amount);
701 
702         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
703         _totalSupply = _totalSupply.sub(amount);
704         emit Transfer(account, address(0), amount);
705     }
706 
707     /**
708      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
709      *
710      * This is internal function is equivalent to `approve`, and can be used to
711      * e.g. set automatic allowances for certain subsystems, etc.
712      *
713      * Emits an {Approval} event.
714      *
715      * Requirements:
716      *
717      * - `owner` cannot be the zero address.
718      * - `spender` cannot be the zero address.
719      */
720     function _approve(address owner, address spender, uint256 amount) internal virtual {
721         require(owner != address(0), "ERC20: approve from the zero address");
722         require(spender != address(0), "ERC20: approve to the zero address");
723 
724         _allowances[owner][spender] = amount;
725         emit Approval(owner, spender, amount);
726     }
727 
728     /**
729      * @dev Sets {decimals} to a value other than the default one of 18.
730      *
731      * WARNING: This function should only be called from the constructor. Most
732      * applications that interact with token contracts will not expect
733      * {decimals} to ever change, and may work incorrectly if it does.
734      */
735     function _setupDecimals(uint8 decimals_) internal {
736         _decimals = decimals_;
737     }
738 
739     /**
740      * @dev Hook that is called before any transfer of tokens. This includes
741      * minting and burning.
742      *
743      * Calling conditions:
744      *
745      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
746      * will be to transferred to `to`.
747      * - when `from` is zero, `amount` tokens will be minted for `to`.
748      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
749      * - `from` and `to` are never both zero.
750      *
751      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
752      */
753     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
754 }
755 
756 /**
757  * @dev Extension of {ERC20} that allows token holders to destroy both their own
758  * tokens and those that they have an allowance for, in a way that can be
759  * recognized off-chain (via event analysis).
760  */
761 abstract contract ERC20Burnable is Context, ERC20 {
762     /**
763      * @dev Destroys `amount` tokens from the caller.
764      *
765      * See {ERC20-_burn}.
766      */
767     function burn(uint256 amount) public virtual {
768         _burn(_msgSender(), amount);
769     }
770 
771     /**
772      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
773      * allowance.
774      *
775      * See {ERC20-_burn} and {ERC20-allowance}.
776      *
777      * Requirements:
778      *
779      * - the caller must have allowance for ``accounts``'s tokens of at least
780      * `amount`.
781      */
782     function burnFrom(address account, uint256 amount) public virtual {
783         uint256 decreasedAllowance = allowance(account, _msgSender()).sub(amount, "ERC20: burn amount exceeds allowance");
784 
785         _approve(account, _msgSender(), decreasedAllowance);
786         _burn(account, amount);
787     }
788 }
789 
790 /**
791  * @dev Contract module which allows children to implement an emergency stop
792  * mechanism that can be triggered by an authorized account.
793  *
794  * This module is used through inheritance. It will make available the
795  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
796  * the functions of your contract. Note that they will not be pausable by
797  * simply including this module, only once the modifiers are put in place.
798  */
799 contract Pausable is Context {
800     /**
801      * @dev Emitted when the pause is triggered by `account`.
802      */
803     event Paused(address account);
804 
805     /**
806      * @dev Emitted when the pause is lifted by `account`.
807      */
808     event Unpaused(address account);
809 
810     bool private _paused;
811 
812     /**
813      * @dev Initializes the contract in unpaused state.
814      */
815     constructor () internal {
816         _paused = false;
817     }
818 
819     /**
820      * @dev Returns true if the contract is paused, and false otherwise.
821      */
822     function paused() public view returns (bool) {
823         return _paused;
824     }
825 
826     /**
827      * @dev Modifier to make a function callable only when the contract is not paused.
828      *
829      * Requirements:
830      *
831      * - The contract must not be paused.
832      */
833     modifier whenNotPaused() {
834         require(!_paused, "Pausable: paused");
835         _;
836     }
837 
838     /**
839      * @dev Modifier to make a function callable only when the contract is paused.
840      *
841      * Requirements:
842      *
843      * - The contract must be paused.
844      */
845     modifier whenPaused() {
846         require(_paused, "Pausable: not paused");
847         _;
848     }
849 
850     /**
851      * @dev Triggers stopped state.
852      *
853      * Requirements:
854      *
855      * - The contract must not be paused.
856      */
857     function _pause() internal virtual whenNotPaused {
858         _paused = true;
859         emit Paused(_msgSender());
860     }
861 
862     /**
863      * @dev Returns to normal state.
864      *
865      * Requirements:
866      *
867      * - The contract must be paused.
868      */
869     function _unpause() internal virtual whenPaused {
870         _paused = false;
871         emit Unpaused(_msgSender());
872     }
873 }
874 
875 /**
876  * @dev ERC20 token with pausable token transfers, minting and burning.
877  *
878  * Useful for scenarios such as preventing trades until the end of an evaluation
879  * period, or having an emergency switch for freezing all token transfers in the
880  * event of a large bug.
881  */
882 abstract contract ERC20Pausable is ERC20, Pausable {
883     /**
884      * @dev See {ERC20-_beforeTokenTransfer}.
885      *
886      * Requirements:
887      *
888      * - the contract must not be paused.
889      */
890     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual override {
891         super._beforeTokenTransfer(from, to, amount);
892 
893         require(!paused(), "ERC20Pausable: token transfer while paused");
894     }
895 }
896 
897 
898 /*
899 @@@@@@@@@@@@@@@@@@@@@@@@@#,@@@@@@@@@@@@@@@@@@@@@@@@@(             
900 @@@@@@@@@@@@@@@@@@@@@^,,,^,,,,,&@@@@@@@@@@@@@@@@@@@@(             
901 @@@@@@@@@@@@@@@@@,,,,,,,^/,,^^^^^^^^@@@@@@@@@@@@@@@@(             
902 @@@@@@@@@@@@%,,,,,,,,,,,//^^^^^^^^^^^^^^@@@@@@@@@@@@(             
903 @@@@@@@@,,,,,,,,,,,,,,,///^^^^^^^^^^^^^^^^^^#@@@@@@@(             
904 @@@@,,,,,,,,,,,,,,,,^^////^^^^^^^^^^^^^^^^^^^^///@@@(             
905 ,,,,,,,,,,,,,,,,,,^^^/////^^^^^^^^^^^^^^^^^^/////////             
906 ,,,,,,,,,,,,,,,^^^^^^/@@@@^^^^^^^^^^^^^^^///////@@@@(             
907 ,,,,,,,,,,,,,^^^^#@@@@@@@@^^^^^^^^^^^^^////#@@@@@@@@(             
908 ,,,,,,,,,,,^^@@@@@@@@@@@@@^^^^^^^^^^///@@@@@@@@@@@@@(             
909 ,,,,,,,,^@@@@@@@@@@@@@@@@@^^^^^^^//@@@@@@@@@@@@@@@@@(             
910 ,,,,%@@@@@@@@@@@@@@@@@@@@@^^^^%@@@@@@@@@@@@@@@@@@@@@(             
911 @@@@@@@@@@@@@@@@@@@@@@@@@^@@@@@@@@@@@@@@@@@@@@@@@@@#,             
912 @@@@@@@@@@@@@@@@@@@@@^^^^^@@@@@@@@@@@@@@@@@@@@@/////,             
913 @@@@@@@@@@@@@@@@%^^^^^^^//@@@@@@@@@@@@@@@@@///////((,             
914 @@@@@@@@@@@@#^^^^^^^^/////@@@@@@@@@@@@@/////////((((,             
915 @@@@@@@@^^^^^^^^^^^///////@@@@@@@@///////////(((((((,             
916 @@@@^^^^^^^^^^^^//////////@@@@##///////////(((((((((,             
917 (^^^^^^^^^^^^/////////////#####/////////((((((((((((^             
918 @@@@&^^^^^^///////////////####////////((((((((((@@@@(             
919 @@@@@@@@@/////////////////###(/////(((((((((@@@@@@@@(             
920 @@@@@@@@@@@@@#////////////###////((((((@@@@@@@@@@@@@(             
921 @@@@@@@@@@@@@@@@@@////////##//(((((@@@@@@@@@@@@@@@@@(             
922 @@@@@@@@@@@@@@@@@@@@@@(///#/(((@@@@@@@@@@@@@@@@@@@@@(
923 */
924 
925 contract Coinverter is ERC20, Ownable, Pausable {
926   using SafeMath for uint256;
927 
928     constructor(uint256 initialSupply)
929     public
930     Ownable()
931     Pausable()
932     ERC20("Coinverter.info", "COIN")
933     {
934         _mint(msg.sender, initialSupply);
935     }
936 }