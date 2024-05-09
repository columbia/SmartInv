1 // SPDX-License-Identifier: MIT
2 /**
3  * Created on 2020-10-13 10:50
4  * @summary: Token with Voting capabilities
5  * @authors: Fabio Pacchioni, Ayush Tiwari
6  */
7 pragma solidity ^0.6.12;
8 
9 /*
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with GSN meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address payable) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes memory) {
25         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
26         return msg.data;
27     }
28 }
29 
30 
31 /**
32  * @dev Contract module which provides a basic access control mechanism, where
33  * there is an account (an owner) that can be granted exclusive access to
34  * specific functions.
35  *
36  * By default, the owner account will be the one that deploys the contract. This
37  * can later be changed with {transferOwnership}.
38  *
39  * This module is used through inheritance. It will make available the modifier
40  * `onlyOwner`, which can be applied to your functions to restrict their use to
41  * the owner.
42  */
43 contract Ownable is Context {
44     address private _owner;
45 
46     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
47 
48     /**
49      * @dev Initializes the contract setting the deployer as the initial owner.
50      */
51     constructor () internal {
52         address msgSender = _msgSender();
53         _owner = msgSender;
54         emit OwnershipTransferred(address(0), msgSender);
55     }
56 
57     /**
58      * @dev Returns the address of the current owner.
59      */
60     function owner() public view returns (address) {
61         return _owner;
62     }
63 
64     /**
65      * @dev Throws if called by any account other than the owner.
66      */
67     modifier onlyOwner() {
68         require(_owner == _msgSender(), "Ownable: caller is not the owner");
69         _;
70     }
71 
72     /**
73      * @dev Leaves the contract without owner. It will not be possible to call
74      * `onlyOwner` functions anymore. Can only be called by the current owner.
75      *
76      * NOTE: Renouncing ownership will leave the contract without an owner,
77      * thereby removing any functionality that is only available to the owner.
78      */
79     function renounceOwnership() public virtual onlyOwner {
80         emit OwnershipTransferred(_owner, address(0));
81         _owner = address(0);
82     }
83 
84     /**
85      * @dev Transfers ownership of the contract to a new account (`newOwner`).
86      * Can only be called by the current owner.
87      */
88     function transferOwnership(address newOwner) public virtual onlyOwner {
89         require(newOwner != address(0), "Ownable: new owner is the zero address");
90         emit OwnershipTransferred(_owner, newOwner);
91         _owner = newOwner;
92     }
93 }
94 
95 
96 contract Blacklist is Ownable {
97 
98     mapping (address => bool) public isBlackListed;
99 
100     event AddedBlackList(address _user);
101     event RemovedBlackList(address _user);
102 
103     function getBlackListStatus(address _maker) external view returns (bool) {
104         return isBlackListed[_maker];
105     }
106 
107     function addBlackList (address _evilUser) public onlyOwner {
108         isBlackListed[_evilUser] = true;
109         AddedBlackList(_evilUser);
110     }
111 
112     function removeBlackList (address _clearedUser) public onlyOwner {
113         isBlackListed[_clearedUser] = false;
114         RemovedBlackList(_clearedUser);
115     }
116 
117 }
118 
119 
120 /**
121  * @dev Contract module which allows children to implement an emergency stop
122  * mechanism that can be triggered by an authorized account.
123  *
124  * This module is used through inheritance. It will make available the
125  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
126  * the functions of your contract. Note that they will not be pausable by
127  * simply including this module, only once the modifiers are put in place.
128  */
129 contract Pausable is Context {
130     /**
131      * @dev Emitted when the pause is triggered by `account`.
132      */
133     event Paused(address account);
134 
135     /**
136      * @dev Emitted when the pause is lifted by `account`.
137      */
138     event Unpaused(address account);
139 
140     bool private _paused;
141 
142     /**
143      * @dev Initializes the contract in unpaused state.
144      */
145     constructor () internal {
146         _paused = false;
147     }
148 
149     /**
150      * @dev Returns true if the contract is paused, and false otherwise.
151      */
152     function paused() public view returns (bool) {
153         return _paused;
154     }
155 
156     /**
157      * @dev Modifier to make a function callable only when the contract is not paused.
158      *
159      * Requirements:
160      *
161      * - The contract must not be paused.
162      */
163     modifier whenNotPaused() {
164         require(!_paused, "Pausable: paused");
165         _;
166     }
167 
168     /**
169      * @dev Modifier to make a function callable only when the contract is paused.
170      *
171      * Requirements:
172      *
173      * - The contract must be paused.
174      */
175     modifier whenPaused() {
176         require(_paused, "Pausable: not paused");
177         _;
178     }
179 
180     /**
181      * @dev Triggers stopped state.
182      *
183      * Requirements:
184      *
185      * - The contract must not be paused.
186      */
187     function _pause() internal virtual whenNotPaused {
188         _paused = true;
189         emit Paused(_msgSender());
190     }
191 
192     /**
193      * @dev Returns to normal state.
194      *
195      * Requirements:
196      *
197      * - The contract must be paused.
198      */
199     function _unpause() internal virtual whenPaused {
200         _paused = false;
201         emit Unpaused(_msgSender());
202     }
203 }
204 
205 
206 /**
207  * @dev Interface of the ERC20 standard as defined in the EIP.
208  */
209 interface IERC20 {
210     /**
211      * @dev Returns the amount of tokens in existence.
212      */
213     function totalSupply() external view returns (uint256);
214 
215     /**
216      * @dev Returns the amount of tokens owned by `account`.
217      */
218     function balanceOf(address account) external view returns (uint256);
219 
220     /**
221      * @dev Moves `amount` tokens from the caller's account to `recipient`.
222      *
223      * Returns a boolean value indicating whether the operation succeeded.
224      *
225      * Emits a {Transfer} event.
226      */
227     function transfer(address recipient, uint256 amount) external returns (bool);
228 
229     /**
230      * @dev Returns the remaining number of tokens that `spender` will be
231      * allowed to spend on behalf of `owner` through {transferFrom}. This is
232      * zero by default.
233      *
234      * This value changes when {approve} or {transferFrom} are called.
235      */
236     function allowance(address owner, address spender) external view returns (uint256);
237 
238     /**
239      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
240      *
241      * Returns a boolean value indicating whether the operation succeeded.
242      *
243      * IMPORTANT: Beware that changing an allowance with this method brings the risk
244      * that someone may use both the old and the new allowance by unfortunate
245      * transaction ordering. One possible solution to mitigate this race
246      * condition is to first reduce the spender's allowance to 0 and set the
247      * desired value afterwards:
248      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
249      *
250      * Emits an {Approval} event.
251      */
252     function approve(address spender, uint256 amount) external returns (bool);
253 
254     /**
255      * @dev Moves `amount` tokens from `sender` to `recipient` using the
256      * allowance mechanism. `amount` is then deducted from the caller's
257      * allowance.
258      *
259      * Returns a boolean value indicating whether the operation succeeded.
260      *
261      * Emits a {Transfer} event.
262      */
263     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
264 
265     /**
266      * @dev Emitted when `value` tokens are moved from one account (`from`) to
267      * another (`to`).
268      *
269      * Note that `value` may be zero.
270      */
271     event Transfer(address indexed from, address indexed to, uint256 value);
272 
273     /**
274      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
275      * a call to {approve}. `value` is the new allowance.
276      */
277     event Approval(address indexed owner, address indexed spender, uint256 value);
278 }
279 
280 
281 /**
282  * @dev Wrappers over Solidity's arithmetic operations with added overflow
283  * checks.
284  *
285  * Arithmetic operations in Solidity wrap on overflow. This can easily result
286  * in bugs, because programmers usually assume that an overflow raises an
287  * error, which is the standard behavior in high level programming languages.
288  * `SafeMath` restores this intuition by reverting the transaction when an
289  * operation overflows.
290  *
291  * Using this library instead of the unchecked operations eliminates an entire
292  * class of bugs, so it's recommended to use it always.
293  */
294 library SafeMath {
295     /**
296      * @dev Returns the addition of two unsigned integers, reverting on
297      * overflow.
298      *
299      * Counterpart to Solidity's `+` operator.
300      *
301      * Requirements:
302      *
303      * - Addition cannot overflow.
304      */
305     function add(uint256 a, uint256 b) internal pure returns (uint256) {
306         uint256 c = a + b;
307         require(c >= a, "SafeMath: addition overflow");
308 
309         return c;
310     }
311 
312     /**
313      * @dev Returns the subtraction of two unsigned integers, reverting on
314      * overflow (when the result is negative).
315      *
316      * Counterpart to Solidity's `-` operator.
317      *
318      * Requirements:
319      *
320      * - Subtraction cannot overflow.
321      */
322     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
323         return sub(a, b, "SafeMath: subtraction overflow");
324     }
325 
326     /**
327      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
328      * overflow (when the result is negative).
329      *
330      * Counterpart to Solidity's `-` operator.
331      *
332      * Requirements:
333      *
334      * - Subtraction cannot overflow.
335      */
336     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
337         require(b <= a, errorMessage);
338         uint256 c = a - b;
339 
340         return c;
341     }
342 
343     /**
344      * @dev Returns the multiplication of two unsigned integers, reverting on
345      * overflow.
346      *
347      * Counterpart to Solidity's `*` operator.
348      *
349      * Requirements:
350      *
351      * - Multiplication cannot overflow.
352      */
353     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
354         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
355         // benefit is lost if 'b' is also tested.
356         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
357         if (a == 0) {
358             return 0;
359         }
360 
361         uint256 c = a * b;
362         require(c / a == b, "SafeMath: multiplication overflow");
363 
364         return c;
365     }
366 
367     /**
368      * @dev Returns the integer division of two unsigned integers. Reverts on
369      * division by zero. The result is rounded towards zero.
370      *
371      * Counterpart to Solidity's `/` operator. Note: this function uses a
372      * `revert` opcode (which leaves remaining gas untouched) while Solidity
373      * uses an invalid opcode to revert (consuming all remaining gas).
374      *
375      * Requirements:
376      *
377      * - The divisor cannot be zero.
378      */
379     function div(uint256 a, uint256 b) internal pure returns (uint256) {
380         return div(a, b, "SafeMath: division by zero");
381     }
382 
383     /**
384      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
385      * division by zero. The result is rounded towards zero.
386      *
387      * Counterpart to Solidity's `/` operator. Note: this function uses a
388      * `revert` opcode (which leaves remaining gas untouched) while Solidity
389      * uses an invalid opcode to revert (consuming all remaining gas).
390      *
391      * Requirements:
392      *
393      * - The divisor cannot be zero.
394      */
395     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
396         require(b > 0, errorMessage);
397         uint256 c = a / b;
398         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
399 
400         return c;
401     }
402 
403     /**
404      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
405      * Reverts when dividing by zero.
406      *
407      * Counterpart to Solidity's `%` operator. This function uses a `revert`
408      * opcode (which leaves remaining gas untouched) while Solidity uses an
409      * invalid opcode to revert (consuming all remaining gas).
410      *
411      * Requirements:
412      *
413      * - The divisor cannot be zero.
414      */
415     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
416         return mod(a, b, "SafeMath: modulo by zero");
417     }
418 
419     /**
420      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
421      * Reverts with custom message when dividing by zero.
422      *
423      * Counterpart to Solidity's `%` operator. This function uses a `revert`
424      * opcode (which leaves remaining gas untouched) while Solidity uses an
425      * invalid opcode to revert (consuming all remaining gas).
426      *
427      * Requirements:
428      *
429      * - The divisor cannot be zero.
430      */
431     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
432         require(b != 0, errorMessage);
433         return a % b;
434     }
435 }
436 
437 
438 /**
439  * @dev Collection of functions related to the address type
440  */
441 library Address {
442     /**
443      * @dev Returns true if `account` is a contract.
444      *
445      * [IMPORTANT]
446      * ====
447      * It is unsafe to assume that an address for which this function returns
448      * false is an externally-owned account (EOA) and not a contract.
449      *
450      * Among others, `isContract` will return false for the following
451      * types of addresses:
452      *
453      *  - an externally-owned account
454      *  - a contract in construction
455      *  - an address where a contract will be created
456      *  - an address where a contract lived, but was destroyed
457      * ====
458      */
459     function isContract(address account) internal view returns (bool) {
460         // This method relies in extcodesize, which returns 0 for contracts in
461         // construction, since the code is only stored at the end of the
462         // constructor execution.
463 
464         uint256 size;
465         // solhint-disable-next-line no-inline-assembly
466         assembly { size := extcodesize(account) }
467         return size > 0;
468     }
469 
470     /**
471      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
472      * `recipient`, forwarding all available gas and reverting on errors.
473      *
474      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
475      * of certain opcodes, possibly making contracts go over the 2300 gas limit
476      * imposed by `transfer`, making them unable to receive funds via
477      * `transfer`. {sendValue} removes this limitation.
478      *
479      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
480      *
481      * IMPORTANT: because control is transferred to `recipient`, care must be
482      * taken to not create reentrancy vulnerabilities. Consider using
483      * {ReentrancyGuard} or the
484      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
485      */
486     function sendValue(address payable recipient, uint256 amount) internal {
487         require(address(this).balance >= amount, "Address: insufficient balance");
488 
489         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
490         (bool success, ) = recipient.call{ value: amount }("");
491         require(success, "Address: unable to send value, recipient may have reverted");
492     }
493 
494     /**
495      * @dev Performs a Solidity function call using a low level `call`. A
496      * plain`call` is an unsafe replacement for a function call: use this
497      * function instead.
498      *
499      * If `target` reverts with a revert reason, it is bubbled up by this
500      * function (like regular Solidity function calls).
501      *
502      * Returns the raw returned data. To convert to the expected return value,
503      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
504      *
505      * Requirements:
506      *
507      * - `target` must be a contract.
508      * - calling `target` with `data` must not revert.
509      *
510      * _Available since v3.1._
511      */
512     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
513       return functionCall(target, data, "Address: low-level call failed");
514     }
515 
516     /**
517      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
518      * `errorMessage` as a fallback revert reason when `target` reverts.
519      *
520      * _Available since v3.1._
521      */
522     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
523         return _functionCallWithValue(target, data, 0, errorMessage);
524     }
525 
526     /**
527      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
528      * but also transferring `value` wei to `target`.
529      *
530      * Requirements:
531      *
532      * - the calling contract must have an ETH balance of at least `value`.
533      * - the called Solidity function must be `payable`.
534      *
535      * _Available since v3.1._
536      */
537     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
538         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
539     }
540 
541     /**
542      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
543      * with `errorMessage` as a fallback revert reason when `target` reverts.
544      *
545      * _Available since v3.1._
546      */
547     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
548         require(address(this).balance >= value, "Address: insufficient balance for call");
549         return _functionCallWithValue(target, data, value, errorMessage);
550     }
551 
552     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
553         require(isContract(target), "Address: call to non-contract");
554 
555         // solhint-disable-next-line avoid-low-level-calls
556         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
557         if (success) {
558             return returndata;
559         } else {
560             // Look for revert reason and bubble it up if present
561             if (returndata.length > 0) {
562                 // The easiest way to bubble the revert reason is using memory via assembly
563 
564                 // solhint-disable-next-line no-inline-assembly
565                 assembly {
566                     let returndata_size := mload(returndata)
567                     revert(add(32, returndata), returndata_size)
568                 }
569             } else {
570                 revert(errorMessage);
571             }
572         }
573     }
574 }
575 
576 
577 /**
578  * @dev Implementation of the {IERC20} interface.
579  *
580  * This implementation is agnostic to the way tokens are created. This means
581  * that a supply mechanism has to be added in a derived contract using {_mint}.
582  * For a generic mechanism see {ERC20PresetMinterPauser}.
583  *
584  * TIP: For a detailed writeup see our guide
585  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
586  * to implement supply mechanisms].
587  *
588  * We have followed general OpenZeppelin guidelines: functions revert instead
589  * of returning `false` on failure. This behavior is nonetheless conventional
590  * and does not conflict with the expectations of ERC20 applications.
591  *
592  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
593  * This allows applications to reconstruct the allowance for all accounts just
594  * by listening to said events. Other implementations of the EIP may not emit
595  * these events, as it isn't required by the specification.
596  *
597  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
598  * functions have been added to mitigate the well-known issues around setting
599  * allowances. See {IERC20-approve}.
600  */
601 contract ERC20 is Context, IERC20 {
602     using SafeMath for uint256;
603     using Address for address;
604 
605     mapping (address => uint256) private _balances;
606 
607     mapping (address => mapping (address => uint256)) private _allowances;
608 
609     uint256 private _totalSupply;
610 
611     string private _name;
612     string private _symbol;
613     uint8 private _decimals;
614 
615     /**
616      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
617      * a default value of 18.
618      *
619      * To select a different value for {decimals}, use {_setupDecimals}.
620      *
621      * All three of these values are immutable: they can only be set once during
622      * construction.
623      */
624     constructor (string memory name, string memory symbol) public {
625         _name = name;
626         _symbol = symbol;
627         _decimals = 18;
628     }
629 
630     /**
631      * @dev Returns the name of the token.
632      */
633     function name() public view returns (string memory) {
634         return _name;
635     }
636 
637     /**
638      * @dev Returns the symbol of the token, usually a shorter version of the
639      * name.
640      */
641     function symbol() public view returns (string memory) {
642         return _symbol;
643     }
644 
645     /**
646      * @dev Returns the number of decimals used to get its user representation.
647      * For example, if `decimals` equals `2`, a balance of `505` tokens should
648      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
649      *
650      * Tokens usually opt for a value of 18, imitating the relationship between
651      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
652      * called.
653      *
654      * NOTE: This information is only used for _display_ purposes: it in
655      * no way affects any of the arithmetic of the contract, including
656      * {IERC20-balanceOf} and {IERC20-transfer}.
657      */
658     function decimals() public view returns (uint8) {
659         return _decimals;
660     }
661 
662     /**
663      * @dev See {IERC20-totalSupply}.
664      */
665     function totalSupply() public view override returns (uint256) {
666         return _totalSupply;
667     }
668 
669     /**
670      * @dev See {IERC20-balanceOf}.
671      */
672     function balanceOf(address account) public view override returns (uint256) {
673         return _balances[account];
674     }
675 
676     /**
677      * @dev See {IERC20-transfer}.
678      *
679      * Requirements:
680      *
681      * - `recipient` cannot be the zero address.
682      * - the caller must have a balance of at least `amount`.
683      */
684     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
685         _transfer(_msgSender(), recipient, amount);
686         return true;
687     }
688 
689     /**
690      * @dev See {IERC20-allowance}.
691      */
692     function allowance(address owner, address spender) public view virtual override returns (uint256) {
693         return _allowances[owner][spender];
694     }
695 
696     /**
697      * @dev See {IERC20-approve}.
698      *
699      * Requirements:
700      *
701      * - `spender` cannot be the zero address.
702      */
703     function approve(address spender, uint256 amount) public virtual override returns (bool) {
704         _approve(_msgSender(), spender, amount);
705         return true;
706     }
707 
708     /**
709      * @dev See {IERC20-transferFrom}.
710      *
711      * Emits an {Approval} event indicating the updated allowance. This is not
712      * required by the EIP. See the note at the beginning of {ERC20};
713      *
714      * Requirements:
715      * - `sender` and `recipient` cannot be the zero address.
716      * - `sender` must have a balance of at least `amount`.
717      * - the caller must have allowance for ``sender``'s tokens of at least
718      * `amount`.
719      */
720     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
721         _transfer(sender, recipient, amount);
722         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
723         return true;
724     }
725 
726     /**
727      * @dev Atomically increases the allowance granted to `spender` by the caller.
728      *
729      * This is an alternative to {approve} that can be used as a mitigation for
730      * problems described in {IERC20-approve}.
731      *
732      * Emits an {Approval} event indicating the updated allowance.
733      *
734      * Requirements:
735      *
736      * - `spender` cannot be the zero address.
737      */
738     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
739         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
740         return true;
741     }
742 
743     /**
744      * @dev Atomically decreases the allowance granted to `spender` by the caller.
745      *
746      * This is an alternative to {approve} that can be used as a mitigation for
747      * problems described in {IERC20-approve}.
748      *
749      * Emits an {Approval} event indicating the updated allowance.
750      *
751      * Requirements:
752      *
753      * - `spender` cannot be the zero address.
754      * - `spender` must have allowance for the caller of at least
755      * `subtractedValue`.
756      */
757     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
758         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
759         return true;
760     }
761 
762     /**
763      * @dev Moves tokens `amount` from `sender` to `recipient`.
764      *
765      * This is internal function is equivalent to {transfer}, and can be used to
766      * e.g. implement automatic token fees, slashing mechanisms, etc.
767      *
768      * Emits a {Transfer} event.
769      *
770      * Requirements:
771      *
772      * - `sender` cannot be the zero address.
773      * - `recipient` cannot be the zero address.
774      * - `sender` must have a balance of at least `amount`.
775      */
776     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
777         require(sender != address(0), "ERC20: transfer from the zero address");
778         require(recipient != address(0), "ERC20: transfer to the zero address");
779 
780         _beforeTokenTransfer(sender, recipient, amount);
781 
782         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
783         _balances[recipient] = _balances[recipient].add(amount);
784         emit Transfer(sender, recipient, amount);
785     }
786 
787     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
788      * the total supply.
789      *
790      * Emits a {Transfer} event with `from` set to the zero address.
791      *
792      * Requirements
793      *
794      * - `to` cannot be the zero address.
795      */
796     function _mint(address account, uint256 amount) internal virtual {
797         require(account != address(0), "ERC20: mint to the zero address");
798 
799         _beforeTokenTransfer(address(0), account, amount);
800 
801         _totalSupply = _totalSupply.add(amount);
802         _balances[account] = _balances[account].add(amount);
803         emit Transfer(address(0), account, amount);
804     }
805 
806     /**
807      * @dev Destroys `amount` tokens from `account`, reducing the
808      * total supply.
809      *
810      * Emits a {Transfer} event with `to` set to the zero address.
811      *
812      * Requirements
813      *
814      * - `account` cannot be the zero address.
815      * - `account` must have at least `amount` tokens.
816      */
817     function _burn(address account, uint256 amount) internal virtual {
818         require(account != address(0), "ERC20: burn from the zero address");
819 
820         _beforeTokenTransfer(account, address(0), amount);
821 
822         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
823         _totalSupply = _totalSupply.sub(amount);
824         emit Transfer(account, address(0), amount);
825     }
826 
827     /**
828      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
829      *
830      * This internal function is equivalent to `approve`, and can be used to
831      * e.g. set automatic allowances for certain subsystems, etc.
832      *
833      * Emits an {Approval} event.
834      *
835      * Requirements:
836      *
837      * - `owner` cannot be the zero address.
838      * - `spender` cannot be the zero address.
839      */
840     function _approve(address owner, address spender, uint256 amount) internal virtual {
841         require(owner != address(0), "ERC20: approve from the zero address");
842         require(spender != address(0), "ERC20: approve to the zero address");
843 
844         _allowances[owner][spender] = amount;
845         emit Approval(owner, spender, amount);
846     }
847 
848     /**
849      * @dev Sets {decimals} to a value other than the default one of 18.
850      *
851      * WARNING: This function should only be called from the constructor. Most
852      * applications that interact with token contracts will not expect
853      * {decimals} to ever change, and may work incorrectly if it does.
854      */
855     function _setupDecimals(uint8 decimals_) internal {
856         _decimals = decimals_;
857     }
858 
859     /**
860      * @dev Hook that is called before any transfer of tokens. This includes
861      * minting and burning.
862      *
863      * Calling conditions:
864      *
865      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
866      * will be to transferred to `to`.
867      * - when `from` is zero, `amount` tokens will be minted for `to`.
868      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
869      * - `from` and `to` are never both zero.
870      *
871      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
872      */
873     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
874 }
875 
876 
877 /**
878  * @title Token Contract
879  */
880 contract Token is ERC20, Ownable, Pausable, Blacklist {
881     using SafeMath for uint256;
882 
883     /// @dev A record of each accounts delegate
884     mapping(address => address) internal _delegates;
885 
886     /// @dev A checkpoint for marking number of votes from a given block
887     struct Checkpoint {
888         uint256 fromBlock;
889         uint256 votes;
890     }
891 
892     /// @dev A record of votes checkpoints for each account, by index
893     mapping(address => mapping(uint32 => Checkpoint)) public checkpoints;
894 
895     /// @dev The number of checkpoints for each account
896     mapping(address => uint32) public numCheckpoints;
897 
898     /// @dev The EIP-712 typehash for the contract's domain
899     bytes32 public constant DOMAIN_TYPEHASH = keccak256(
900         "EIP712Domain(string name,uint256 chainId,address verifyingContract)"
901     );
902 
903     /// @dev The EIP-712 typehash for the delegation struct used by the contract
904     bytes32 public constant DELEGATION_TYPEHASH = keccak256(
905         "Delegation(address delegatee,uint256 nonce,uint256 expiry)"
906     );
907 
908     /// @dev A record of states for signing / validating signatures
909     mapping(address => uint256) public nonces;
910 
911     /// @notice The timestamp after which minting may occur
912     uint public mintingAllowedAfter;
913 
914     /// @notice Minimum time between mints
915     uint32 public constant minimumTimeBetweenMints = 1 days * 365;
916 
917     /// @notice Cap on the percentage of totalSupply that can be minted at each mint
918     uint8 public constant mintCap = 2;
919 
920     /// @dev An event thats emitted when an account changes its delegate
921     event DelegateChanged(
922         address indexed delegator,
923         address indexed fromDelegate,
924         address indexed toDelegate
925     );
926 
927     /// @dev An event thats emitted when a delegate account's vote balance changes
928     event DelegateVotesChanged(
929         address indexed delegate,
930         uint256 previousBalance,
931         uint256 newBalance
932     );
933 
934     constructor(string memory _name, string memory _symbol, uint256 _initialSupply, uint256 mintingAllowedAfter_)
935         public
936         ERC20(_name, _symbol)
937     {
938         _mint(msg.sender, _initialSupply.mul(10**18));
939         mintingAllowedAfter = mintingAllowedAfter_;
940     }
941 
942     /**
943      * @dev Fix for the ERC20 short address attack.
944      */
945     modifier onlyPayloadSize(uint256 size) {
946         require(msg.data.length >= size + 4, "Address type not allowed!");
947         _;
948     }
949 
950     /**
951      * @dev Mint new tokens (only owner)
952      * @param recipient recipient address
953      * @param _mintVal amount to mint
954      */
955     function mint(address recipient, uint256 _mintVal)
956         public
957         onlyOwner
958         whenNotPaused
959     {
960         require(recipient != address(0), "Token::mint: cannot transfer to the zero address");
961         require(!isBlackListed[recipient], "Mint - Recipient is blacklisted");
962         require(block.timestamp >= mintingAllowedAfter, "Token::mint: minting not allowed yet");
963         // record the mint
964         mintingAllowedAfter = SafeMath.add(block.timestamp, minimumTimeBetweenMints);
965         // mint the amount
966         require(_mintVal <= SafeMath.div(SafeMath.mul(totalSupply(), mintCap), 100), "Token::mint: exceeded mint cap");
967         _mint(recipient, _mintVal);
968         // move delegates
969         _moveDelegates(address(0), _delegates[recipient], _mintVal);
970     }
971 
972     /**
973      * @dev burns tokens
974      * @param _burnVal amount to burn
975      */
976     function burn(uint256 _burnVal) public whenNotPaused {
977         require(!isBlackListed[msg.sender], "Burn - Sender is blacklisted");
978         _burn(msg.sender, _burnVal);
979     }
980 
981     /**
982      * @dev Transfer tokens from one address to another
983      * @param _to address The address which you want to transfer to
984      * @param _value uint the amount of tokens to be transferred
985      * @return true if success
986      */
987     function transfer(address _to, uint256 _value)
988         public
989         override
990         onlyPayloadSize(2 * 32)
991         whenNotPaused
992         returns (bool)
993     {
994         require(!isBlackListed[msg.sender], "Transfer - Sender is blacklisted");
995         require(!isBlackListed[_to], "Transfer - Recipient is blacklisted");
996         super.transfer(_to, _value);
997         _moveDelegates(_delegates[msg.sender], _delegates[_to], _value);
998         return true;
999     }
1000 
1001     /**
1002      * @dev Transfer tokens from one address to another
1003      * @param _from address The address which you want to send tokens from
1004      * @param _to address The address which you want to transfer to
1005      * @param _value uint the amount of tokens to be transferred
1006      * @return true if success
1007      */
1008     function transferFrom(
1009         address _from,
1010         address _to,
1011         uint256 _value
1012     ) public override onlyPayloadSize(3 * 32) whenNotPaused returns (bool) {
1013         require(!isBlackListed[_from], "TransferFrom - Sender is blacklisted");
1014         require(!isBlackListed[_to], "TransferFrom - Recipient is blacklisted");
1015         super.transferFrom(_from, _to, _value);
1016         _moveDelegates(_delegates[_from], _delegates[_to], _value);
1017         return true;
1018     }
1019 
1020     /**
1021      * @dev Pause token
1022      */
1023     function setPause() external whenNotPaused onlyOwner {
1024         _pause();
1025     }
1026 
1027     /**
1028      * @dev Unpause token
1029      */
1030     function setUnpause() external whenPaused onlyOwner {
1031         _unpause();
1032     }
1033 
1034     //////////////////////////////////////////////////////////////////////////////////////
1035     /**
1036      * @notice Delegate votes from `msg.sender` to `delegatee`
1037      * @param delegator The address to get delegatee for
1038      */
1039     function delegates(address delegator) external view returns (address) {
1040         return _delegates[delegator];
1041     }
1042 
1043     /**
1044      * @dev Delegate votes from `msg.sender` to `delegatee`
1045      * @param delegatee The address to delegate votes to
1046      */
1047     function delegate(address delegatee) public {
1048         return _delegate(msg.sender, delegatee);
1049     }
1050 
1051     /**
1052      * @dev Delegates votes from signatory to `delegatee`
1053      * @param delegatee The address to delegate votes to
1054      * @param nonce The contract state required to match the signature
1055      * @param expiry The time at which to expire the signature
1056      * @param v The recovery byte of the signature
1057      * @param r Half of the ECDSA signature pair
1058      * @param s Half of the ECDSA signature pair
1059      */
1060     function delegateBySig(
1061         address delegatee,
1062         uint256 nonce,
1063         uint256 expiry,
1064         uint8 v,
1065         bytes32 r,
1066         bytes32 s
1067     ) public {
1068         bytes32 domainSeparator = keccak256(
1069             abi.encode(
1070                 DOMAIN_TYPEHASH,
1071                 keccak256(bytes(string(name()))),
1072                 getChainId(),
1073                 address(this)
1074             )
1075         );
1076         bytes32 structHash = keccak256(
1077             abi.encode(DELEGATION_TYPEHASH, delegatee, nonce, expiry)
1078         );
1079         bytes32 digest = keccak256(
1080             abi.encodePacked("\x19\x01", domainSeparator, structHash)
1081         );
1082         address signatory = ecrecover(digest, v, r, s);
1083         require(
1084             signatory != address(0),
1085             "Token::delegateBySig: invalid signature"
1086         );
1087         require(
1088             nonce == nonces[signatory]++,
1089             "Token::delegateBySig: invalid nonce"
1090         );
1091         require(now <= expiry, "Token::delegateBySig: signature expired");
1092         return _delegate(signatory, delegatee);
1093     }
1094 
1095     /**
1096      * @dev Gets the current votes balance for `account`
1097      * @param account The address to get votes balance
1098      * @return The number of current votes for `account`
1099      */
1100     function getCurrentVotes(address account) external view returns (uint256) {
1101         uint32 nCheckpoints = numCheckpoints[account];
1102         return
1103             nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1104     }
1105 
1106     /**
1107      * @dev Determine the prior number of votes for an account as of a block number
1108      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1109      * @param account The address of the account to check
1110      * @param blockNumber The block number to get the vote balance at
1111      * @return The number of votes the account had as of the given block
1112      */
1113     function getPriorVotes(address account, uint256 blockNumber)
1114         public
1115         view
1116         returns (uint256)
1117     {
1118         require(
1119             blockNumber < block.number,
1120             "Token::getPriorVotes: not yet determined"
1121         );
1122 
1123         uint32 nCheckpoints = numCheckpoints[account];
1124         if (nCheckpoints == 0) {
1125             return 0;
1126         }
1127 
1128         // First check most recent balance
1129         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1130             return checkpoints[account][nCheckpoints - 1].votes;
1131         }
1132 
1133         // Next check implicit zero balance
1134         if (checkpoints[account][0].fromBlock > blockNumber) {
1135             return 0;
1136         }
1137 
1138         uint32 lower = 0;
1139         uint32 upper = nCheckpoints - 1;
1140         while (upper > lower) {
1141             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1142             Checkpoint memory cp = checkpoints[account][center];
1143             if (cp.fromBlock == blockNumber) {
1144                 return cp.votes;
1145             } else if (cp.fromBlock < blockNumber) {
1146                 lower = center;
1147             } else {
1148                 upper = center - 1;
1149             }
1150         }
1151         return checkpoints[account][lower].votes;
1152     }
1153 
1154     function _delegate(address delegator, address delegatee) internal {
1155         address currentDelegate = _delegates[delegator];
1156         uint256 delegatorBalance = balanceOf(delegator);
1157         _delegates[delegator] = delegatee;
1158 
1159         emit DelegateChanged(delegator, currentDelegate, delegatee);
1160 
1161         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1162     }
1163 
1164     function _moveDelegates(
1165         address srcRep,
1166         address dstRep,
1167         uint256 amount
1168     ) internal {
1169         if (srcRep != dstRep && amount > 0) {
1170             if (srcRep != address(0)) {
1171                 uint32 srcRepNum = numCheckpoints[srcRep];
1172                 uint256 srcRepOld = srcRepNum > 0
1173                     ? checkpoints[srcRep][srcRepNum - 1].votes
1174                     : 0;
1175                 uint256 srcRepNew = srcRepOld.sub(amount);
1176                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1177             }
1178 
1179             if (dstRep != address(0)) {
1180                 uint32 dstRepNum = numCheckpoints[dstRep];
1181                 uint256 dstRepOld = dstRepNum > 0
1182                     ? checkpoints[dstRep][dstRepNum - 1].votes
1183                     : 0;
1184                 uint256 dstRepNew = dstRepOld.add(amount);
1185                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1186             }
1187         }
1188     }
1189 
1190     function _writeCheckpoint(
1191         address delegatee,
1192         uint32 nCheckpoints,
1193         uint256 oldVotes,
1194         uint256 newVotes
1195     ) internal {
1196         uint256 blockNumber = block.number;
1197 
1198         if (
1199             nCheckpoints > 0 &&
1200             checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber
1201         ) {
1202             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1203         } else {
1204             checkpoints[delegatee][nCheckpoints] = Checkpoint(
1205                 blockNumber,
1206                 newVotes
1207             );
1208             numCheckpoints[delegatee] = nCheckpoints + 1;
1209         }
1210 
1211         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1212     }
1213 
1214     function getChainId() internal pure returns (uint256) {
1215         uint256 chainId;
1216         assembly {
1217             chainId := chainid()
1218         }
1219         return chainId;
1220     }
1221 }