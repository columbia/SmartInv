1 // SPDX-License-Identifier: https://github.com/lendroidproject/protocol.2.0/blob/master/LICENSE.md
2 
3 
4 // File: @openzeppelin/contracts/GSN/Context.sol
5 
6 pragma solidity ^0.7.0;
7 
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with GSN meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address payable) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes memory) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 // File: @openzeppelin/contracts/access/Ownable.sol
30 
31 pragma solidity ^0.7.0;
32 
33 /**
34  * @dev Contract module which provides a basic access control mechanism, where
35  * there is an account (an owner) that can be granted exclusive access to
36  * specific functions.
37  *
38  * By default, the owner account will be the one that deploys the contract. This
39  * can later be changed with {transferOwnership}.
40  *
41  * This module is used through inheritance. It will make available the modifier
42  * `onlyOwner`, which can be applied to your functions to restrict their use to
43  * the owner.
44  */
45 contract Ownable is Context {
46     address private _owner;
47 
48     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
49 
50     /**
51      * @dev Initializes the contract setting the deployer as the initial owner.
52      */
53     constructor () {
54         address msgSender = _msgSender();
55         _owner = msgSender;
56         emit OwnershipTransferred(address(0), msgSender);
57     }
58 
59     /**
60      * @dev Returns the address of the current owner.
61      */
62     function owner() public view returns (address) {
63         return _owner;
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         require(_owner == _msgSender(), "Ownable: caller is not the owner");
71         _;
72     }
73 
74     /**
75      * @dev Leaves the contract without owner. It will not be possible to call
76      * `onlyOwner` functions anymore. Can only be called by the current owner.
77      *
78      * NOTE: Renouncing ownership will leave the contract without an owner,
79      * thereby removing any functionality that is only available to the owner.
80      */
81     function renounceOwnership() public virtual onlyOwner {
82         emit OwnershipTransferred(_owner, address(0));
83         _owner = address(0);
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         emit OwnershipTransferred(_owner, newOwner);
93         _owner = newOwner;
94     }
95 }
96 
97 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
98 
99 pragma solidity ^0.7.0;
100 
101 /**
102  * @dev Interface of the ERC20 standard as defined in the EIP.
103  */
104 interface IERC20 {
105     /**
106      * @dev Returns the amount of tokens in existence.
107      */
108     function totalSupply() external view returns (uint256);
109 
110     /**
111      * @dev Returns the amount of tokens owned by `account`.
112      */
113     function balanceOf(address account) external view returns (uint256);
114 
115     /**
116      * @dev Moves `amount` tokens from the caller's account to `recipient`.
117      *
118      * Returns a boolean value indicating whether the operation succeeded.
119      *
120      * Emits a {Transfer} event.
121      */
122     function transfer(address recipient, uint256 amount) external returns (bool);
123 
124     /**
125      * @dev Returns the remaining number of tokens that `spender` will be
126      * allowed to spend on behalf of `owner` through {transferFrom}. This is
127      * zero by default.
128      *
129      * This value changes when {approve} or {transferFrom} are called.
130      */
131     function allowance(address owner, address spender) external view returns (uint256);
132 
133     /**
134      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
135      *
136      * Returns a boolean value indicating whether the operation succeeded.
137      *
138      * IMPORTANT: Beware that changing an allowance with this method brings the risk
139      * that someone may use both the old and the new allowance by unfortunate
140      * transaction ordering. One possible solution to mitigate this race
141      * condition is to first reduce the spender's allowance to 0 and set the
142      * desired value afterwards:
143      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
144      *
145      * Emits an {Approval} event.
146      */
147     function approve(address spender, uint256 amount) external returns (bool);
148 
149     /**
150      * @dev Moves `amount` tokens from `sender` to `recipient` using the
151      * allowance mechanism. `amount` is then deducted from the caller's
152      * allowance.
153      *
154      * Returns a boolean value indicating whether the operation succeeded.
155      *
156      * Emits a {Transfer} event.
157      */
158     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
159 
160     /**
161      * @dev Emitted when `value` tokens are moved from one account (`from`) to
162      * another (`to`).
163      *
164      * Note that `value` may be zero.
165      */
166     event Transfer(address indexed from, address indexed to, uint256 value);
167 
168     /**
169      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
170      * a call to {approve}. `value` is the new allowance.
171      */
172     event Approval(address indexed owner, address indexed spender, uint256 value);
173 }
174 
175 // File: @openzeppelin/contracts/math/SafeMath.sol
176 
177 pragma solidity ^0.7.0;
178 
179 /**
180  * @dev Wrappers over Solidity's arithmetic operations with added overflow
181  * checks.
182  *
183  * Arithmetic operations in Solidity wrap on overflow. This can easily result
184  * in bugs, because programmers usually assume that an overflow raises an
185  * error, which is the standard behavior in high level programming languages.
186  * `SafeMath` restores this intuition by reverting the transaction when an
187  * operation overflows.
188  *
189  * Using this library instead of the unchecked operations eliminates an entire
190  * class of bugs, so it's recommended to use it always.
191  */
192 library SafeMath {
193     /**
194      * @dev Returns the addition of two unsigned integers, reverting on
195      * overflow.
196      *
197      * Counterpart to Solidity's `+` operator.
198      *
199      * Requirements:
200      *
201      * - Addition cannot overflow.
202      */
203     function add(uint256 a, uint256 b) internal pure returns (uint256) {
204         uint256 c = a + b;
205         require(c >= a, "SafeMath: addition overflow");
206 
207         return c;
208     }
209 
210     /**
211      * @dev Returns the subtraction of two unsigned integers, reverting on
212      * overflow (when the result is negative).
213      *
214      * Counterpart to Solidity's `-` operator.
215      *
216      * Requirements:
217      *
218      * - Subtraction cannot overflow.
219      */
220     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
221         return sub(a, b, "SafeMath: subtraction overflow");
222     }
223 
224     /**
225      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
226      * overflow (when the result is negative).
227      *
228      * Counterpart to Solidity's `-` operator.
229      *
230      * Requirements:
231      *
232      * - Subtraction cannot overflow.
233      */
234     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
235         require(b <= a, errorMessage);
236         uint256 c = a - b;
237 
238         return c;
239     }
240 
241     /**
242      * @dev Returns the multiplication of two unsigned integers, reverting on
243      * overflow.
244      *
245      * Counterpart to Solidity's `*` operator.
246      *
247      * Requirements:
248      *
249      * - Multiplication cannot overflow.
250      */
251     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
252         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
253         // benefit is lost if 'b' is also tested.
254         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
255         if (a == 0) {
256             return 0;
257         }
258 
259         uint256 c = a * b;
260         require(c / a == b, "SafeMath: multiplication overflow");
261 
262         return c;
263     }
264 
265     /**
266      * @dev Returns the integer division of two unsigned integers. Reverts on
267      * division by zero. The result is rounded towards zero.
268      *
269      * Counterpart to Solidity's `/` operator. Note: this function uses a
270      * `revert` opcode (which leaves remaining gas untouched) while Solidity
271      * uses an invalid opcode to revert (consuming all remaining gas).
272      *
273      * Requirements:
274      *
275      * - The divisor cannot be zero.
276      */
277     function div(uint256 a, uint256 b) internal pure returns (uint256) {
278         return div(a, b, "SafeMath: division by zero");
279     }
280 
281     /**
282      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
283      * division by zero. The result is rounded towards zero.
284      *
285      * Counterpart to Solidity's `/` operator. Note: this function uses a
286      * `revert` opcode (which leaves remaining gas untouched) while Solidity
287      * uses an invalid opcode to revert (consuming all remaining gas).
288      *
289      * Requirements:
290      *
291      * - The divisor cannot be zero.
292      */
293     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
294         require(b > 0, errorMessage);
295         uint256 c = a / b;
296         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
297 
298         return c;
299     }
300 
301     /**
302      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
303      * Reverts when dividing by zero.
304      *
305      * Counterpart to Solidity's `%` operator. This function uses a `revert`
306      * opcode (which leaves remaining gas untouched) while Solidity uses an
307      * invalid opcode to revert (consuming all remaining gas).
308      *
309      * Requirements:
310      *
311      * - The divisor cannot be zero.
312      */
313     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
314         return mod(a, b, "SafeMath: modulo by zero");
315     }
316 
317     /**
318      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
319      * Reverts with custom message when dividing by zero.
320      *
321      * Counterpart to Solidity's `%` operator. This function uses a `revert`
322      * opcode (which leaves remaining gas untouched) while Solidity uses an
323      * invalid opcode to revert (consuming all remaining gas).
324      *
325      * Requirements:
326      *
327      * - The divisor cannot be zero.
328      */
329     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
330         require(b != 0, errorMessage);
331         return a % b;
332     }
333 }
334 
335 // File: @openzeppelin/contracts/utils/Address.sol
336 
337 pragma solidity ^0.7.0;
338 
339 /**
340  * @dev Collection of functions related to the address type
341  */
342 library Address {
343     /**
344      * @dev Returns true if `account` is a contract.
345      *
346      * [IMPORTANT]
347      * ====
348      * It is unsafe to assume that an address for which this function returns
349      * false is an externally-owned account (EOA) and not a contract.
350      *
351      * Among others, `isContract` will return false for the following
352      * types of addresses:
353      *
354      *  - an externally-owned account
355      *  - a contract in construction
356      *  - an address where a contract will be created
357      *  - an address where a contract lived, but was destroyed
358      * ====
359      */
360     function isContract(address account) internal view returns (bool) {
361         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
362         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
363         // for accounts without code, i.e. `keccak256('')`
364         bytes32 codehash;
365         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
366         // solhint-disable-next-line no-inline-assembly
367         assembly { codehash := extcodehash(account) }
368         return (codehash != accountHash && codehash != 0x0);
369     }
370 
371     /**
372      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
373      * `recipient`, forwarding all available gas and reverting on errors.
374      *
375      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
376      * of certain opcodes, possibly making contracts go over the 2300 gas limit
377      * imposed by `transfer`, making them unable to receive funds via
378      * `transfer`. {sendValue} removes this limitation.
379      *
380      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
381      *
382      * IMPORTANT: because control is transferred to `recipient`, care must be
383      * taken to not create reentrancy vulnerabilities. Consider using
384      * {ReentrancyGuard} or the
385      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
386      */
387     function sendValue(address payable recipient, uint256 amount) internal {
388         require(address(this).balance >= amount, "Address: insufficient balance");
389 
390         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
391         (bool success, ) = recipient.call{ value: amount }("");
392         require(success, "Address: unable to send value, recipient may have reverted");
393     }
394 
395     /**
396      * @dev Performs a Solidity function call using a low level `call`. A
397      * plain`call` is an unsafe replacement for a function call: use this
398      * function instead.
399      *
400      * If `target` reverts with a revert reason, it is bubbled up by this
401      * function (like regular Solidity function calls).
402      *
403      * Returns the raw returned data. To convert to the expected return value,
404      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
405      *
406      * Requirements:
407      *
408      * - `target` must be a contract.
409      * - calling `target` with `data` must not revert.
410      *
411      * _Available since v3.1._
412      */
413     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
414       return functionCall(target, data, "Address: low-level call failed");
415     }
416 
417     /**
418      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
419      * `errorMessage` as a fallback revert reason when `target` reverts.
420      *
421      * _Available since v3.1._
422      */
423     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
424         return _functionCallWithValue(target, data, 0, errorMessage);
425     }
426 
427     /**
428      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
429      * but also transferring `value` wei to `target`.
430      *
431      * Requirements:
432      *
433      * - the calling contract must have an ETH balance of at least `value`.
434      * - the called Solidity function must be `payable`.
435      *
436      * _Available since v3.1._
437      */
438     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
439         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
440     }
441 
442     /**
443      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
444      * with `errorMessage` as a fallback revert reason when `target` reverts.
445      *
446      * _Available since v3.1._
447      */
448     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
449         require(address(this).balance >= value, "Address: insufficient balance for call");
450         return _functionCallWithValue(target, data, value, errorMessage);
451     }
452 
453     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
454         require(isContract(target), "Address: call to non-contract");
455 
456         // solhint-disable-next-line avoid-low-level-calls
457         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
458         if (success) {
459             return returndata;
460         } else {
461             // Look for revert reason and bubble it up if present
462             if (returndata.length > 0) {
463                 // The easiest way to bubble the revert reason is using memory via assembly
464 
465                 // solhint-disable-next-line no-inline-assembly
466                 assembly {
467                     let returndata_size := mload(returndata)
468                     revert(add(32, returndata), returndata_size)
469                 }
470             } else {
471                 revert(errorMessage);
472             }
473         }
474     }
475 }
476 
477 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
478 
479 pragma solidity ^0.7.0;
480 
481 
482 
483 
484 
485 /**
486  * @dev Implementation of the {IERC20} interface.
487  *
488  * This implementation is agnostic to the way tokens are created. This means
489  * that a supply mechanism has to be added in a derived contract using {_mint}.
490  * For a generic mechanism see {ERC20PresetMinterPauser}.
491  *
492  * TIP: For a detailed writeup see our guide
493  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
494  * to implement supply mechanisms].
495  *
496  * We have followed general OpenZeppelin guidelines: functions revert instead
497  * of returning `false` on failure. This behavior is nonetheless conventional
498  * and does not conflict with the expectations of ERC20 applications.
499  *
500  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
501  * This allows applications to reconstruct the allowance for all accounts just
502  * by listening to said events. Other implementations of the EIP may not emit
503  * these events, as it isn't required by the specification.
504  *
505  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
506  * functions have been added to mitigate the well-known issues around setting
507  * allowances. See {IERC20-approve}.
508  */
509 contract ERC20 is Context, IERC20 {
510     using SafeMath for uint256;
511     using Address for address;
512 
513     mapping (address => uint256) private _balances;
514 
515     mapping (address => mapping (address => uint256)) private _allowances;
516 
517     uint256 private _totalSupply;
518 
519     string private _name;
520     string private _symbol;
521     uint8 private _decimals;
522 
523     /**
524      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
525      * a default value of 18.
526      *
527      * To select a different value for {decimals}, use {_setupDecimals}.
528      *
529      * All three of these values are immutable: they can only be set once during
530      * construction.
531      */
532     constructor (string memory name, string memory symbol) {
533         _name = name;
534         _symbol = symbol;
535         _decimals = 18;
536     }
537 
538     /**
539      * @dev Returns the name of the token.
540      */
541     function name() public view returns (string memory) {
542         return _name;
543     }
544 
545     /**
546      * @dev Returns the symbol of the token, usually a shorter version of the
547      * name.
548      */
549     function symbol() public view returns (string memory) {
550         return _symbol;
551     }
552 
553     /**
554      * @dev Returns the number of decimals used to get its user representation.
555      * For example, if `decimals` equals `2`, a balance of `505` tokens should
556      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
557      *
558      * Tokens usually opt for a value of 18, imitating the relationship between
559      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
560      * called.
561      *
562      * NOTE: This information is only used for _display_ purposes: it in
563      * no way affects any of the arithmetic of the contract, including
564      * {IERC20-balanceOf} and {IERC20-transfer}.
565      */
566     function decimals() public view returns (uint8) {
567         return _decimals;
568     }
569 
570     /**
571      * @dev See {IERC20-totalSupply}.
572      */
573     function totalSupply() public view override returns (uint256) {
574         return _totalSupply;
575     }
576 
577     /**
578      * @dev See {IERC20-balanceOf}.
579      */
580     function balanceOf(address account) public view override returns (uint256) {
581         return _balances[account];
582     }
583 
584     /**
585      * @dev See {IERC20-transfer}.
586      *
587      * Requirements:
588      *
589      * - `recipient` cannot be the zero address.
590      * - the caller must have a balance of at least `amount`.
591      */
592     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
593         _transfer(_msgSender(), recipient, amount);
594         return true;
595     }
596 
597     /**
598      * @dev See {IERC20-allowance}.
599      */
600     function allowance(address owner, address spender) public view virtual override returns (uint256) {
601         return _allowances[owner][spender];
602     }
603 
604     /**
605      * @dev See {IERC20-approve}.
606      *
607      * Requirements:
608      *
609      * - `spender` cannot be the zero address.
610      */
611     function approve(address spender, uint256 amount) public virtual override returns (bool) {
612         _approve(_msgSender(), spender, amount);
613         return true;
614     }
615 
616     /**
617      * @dev See {IERC20-transferFrom}.
618      *
619      * Emits an {Approval} event indicating the updated allowance. This is not
620      * required by the EIP. See the note at the beginning of {ERC20};
621      *
622      * Requirements:
623      * - `sender` and `recipient` cannot be the zero address.
624      * - `sender` must have a balance of at least `amount`.
625      * - the caller must have allowance for ``sender``'s tokens of at least
626      * `amount`.
627      */
628     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
629         _transfer(sender, recipient, amount);
630         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
631         return true;
632     }
633 
634     /**
635      * @dev Atomically increases the allowance granted to `spender` by the caller.
636      *
637      * This is an alternative to {approve} that can be used as a mitigation for
638      * problems described in {IERC20-approve}.
639      *
640      * Emits an {Approval} event indicating the updated allowance.
641      *
642      * Requirements:
643      *
644      * - `spender` cannot be the zero address.
645      */
646     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
647         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
648         return true;
649     }
650 
651     /**
652      * @dev Atomically decreases the allowance granted to `spender` by the caller.
653      *
654      * This is an alternative to {approve} that can be used as a mitigation for
655      * problems described in {IERC20-approve}.
656      *
657      * Emits an {Approval} event indicating the updated allowance.
658      *
659      * Requirements:
660      *
661      * - `spender` cannot be the zero address.
662      * - `spender` must have allowance for the caller of at least
663      * `subtractedValue`.
664      */
665     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
666         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
667         return true;
668     }
669 
670     /**
671      * @dev Moves tokens `amount` from `sender` to `recipient`.
672      *
673      * This is internal function is equivalent to {transfer}, and can be used to
674      * e.g. implement automatic token fees, slashing mechanisms, etc.
675      *
676      * Emits a {Transfer} event.
677      *
678      * Requirements:
679      *
680      * - `sender` cannot be the zero address.
681      * - `recipient` cannot be the zero address.
682      * - `sender` must have a balance of at least `amount`.
683      */
684     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
685         require(sender != address(0), "ERC20: transfer from the zero address");
686         require(recipient != address(0), "ERC20: transfer to the zero address");
687 
688         _beforeTokenTransfer(sender, recipient, amount);
689 
690         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
691         _balances[recipient] = _balances[recipient].add(amount);
692         emit Transfer(sender, recipient, amount);
693     }
694 
695     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
696      * the total supply.
697      *
698      * Emits a {Transfer} event with `from` set to the zero address.
699      *
700      * Requirements
701      *
702      * - `to` cannot be the zero address.
703      */
704     function _mint(address account, uint256 amount) internal virtual {
705         require(account != address(0), "ERC20: mint to the zero address");
706 
707         _beforeTokenTransfer(address(0), account, amount);
708 
709         _totalSupply = _totalSupply.add(amount);
710         _balances[account] = _balances[account].add(amount);
711         emit Transfer(address(0), account, amount);
712     }
713 
714     /**
715      * @dev Destroys `amount` tokens from `account`, reducing the
716      * total supply.
717      *
718      * Emits a {Transfer} event with `to` set to the zero address.
719      *
720      * Requirements
721      *
722      * - `account` cannot be the zero address.
723      * - `account` must have at least `amount` tokens.
724      */
725     function _burn(address account, uint256 amount) internal virtual {
726         require(account != address(0), "ERC20: burn from the zero address");
727 
728         _beforeTokenTransfer(account, address(0), amount);
729 
730         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
731         _totalSupply = _totalSupply.sub(amount);
732         emit Transfer(account, address(0), amount);
733     }
734 
735     /**
736      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
737      *
738      * This internal function is equivalent to `approve`, and can be used to
739      * e.g. set automatic allowances for certain subsystems, etc.
740      *
741      * Emits an {Approval} event.
742      *
743      * Requirements:
744      *
745      * - `owner` cannot be the zero address.
746      * - `spender` cannot be the zero address.
747      */
748     function _approve(address owner, address spender, uint256 amount) internal virtual {
749         require(owner != address(0), "ERC20: approve from the zero address");
750         require(spender != address(0), "ERC20: approve to the zero address");
751 
752         _allowances[owner][spender] = amount;
753         emit Approval(owner, spender, amount);
754     }
755 
756     /**
757      * @dev Sets {decimals} to a value other than the default one of 18.
758      *
759      * WARNING: This function should only be called from the constructor. Most
760      * applications that interact with token contracts will not expect
761      * {decimals} to ever change, and may work incorrectly if it does.
762      */
763     function _setupDecimals(uint8 decimals_) internal {
764         _decimals = decimals_;
765     }
766 
767     /**
768      * @dev Hook that is called before any transfer of tokens. This includes
769      * minting and burning.
770      *
771      * Calling conditions:
772      *
773      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
774      * will be to transferred to `to`.
775      * - when `from` is zero, `amount` tokens will be minted for `to`.
776      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
777      * - `from` and `to` are never both zero.
778      *
779      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
780      */
781     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
782 }
783 
784 // File: contracts/mocks/MockERC20.sol
785 
786 pragma solidity 0.7.5;
787 
788 
789 
790 
791 contract MockERC20 is ERC20, Ownable {
792     // solhint-disable-next-line func-visibility
793     constructor (string memory name, string memory symbol) ERC20(name, symbol) {}// solhint-disable-line no-empty-blocks
794 
795     function mint(address account, uint256 amount) external onlyOwner {
796         _mint(account, amount);
797     }
798 }
799 
800 // File: contracts/mocks/$HRIMP.sol
801 
802 pragma solidity 0.7.5;
803 
804 
805 contract $HRIMP is MockERC20 {
806     // solhint-disable-next-line func-visibility
807     constructor () MockERC20("WhaleStreet $hrimp Token", "$HRIMP") {}// solhint-disable-line no-empty-blocks
808 }