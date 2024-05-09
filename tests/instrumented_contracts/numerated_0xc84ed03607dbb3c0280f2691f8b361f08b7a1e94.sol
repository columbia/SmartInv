1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.7.0;
3 
4 
5 /**
6  * @dev Collection of functions related to the address type
7  */
8 library Address {
9     /**
10      * @dev Returns true if `account` is a contract.
11      *
12      * [IMPORTANT]
13      * ====
14      * It is unsafe to assume that an address for which this function returns
15      * false is an externally-owned account (EOA) and not a contract.
16      *
17      * Among others, `isContract` will return false for the following
18      * types of addresses:
19      *
20      *  - an externally-owned account
21      *  - a contract in construction
22      *  - an address where a contract will be created
23      *  - an address where a contract lived, but was destroyed
24      * ====
25      */
26     function isContract(address account) internal view returns (bool) {
27         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
28         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
29         // for accounts without code, i.e. `keccak256('')`
30         bytes32 codehash;
31         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
32         // solhint-disable-next-line no-inline-assembly
33         assembly { codehash := extcodehash(account) }
34         return (codehash != accountHash && codehash != 0x0);
35     }
36 
37     /**
38      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
39      * `recipient`, forwarding all available gas and reverting on errors.
40      *
41      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
42      * of certain opcodes, possibly making contracts go over the 2300 gas limit
43      * imposed by `transfer`, making them unable to receive funds via
44      * `transfer`. {sendValue} removes this limitation.
45      *
46      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
47      *
48      * IMPORTANT: because control is transferred to `recipient`, care must be
49      * taken to not create reentrancy vulnerabilities. Consider using
50      * {ReentrancyGuard} or the
51      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
52      */
53     function sendValue(address payable recipient, uint256 amount) internal {
54         require(address(this).balance >= amount, "Address: insufficient balance");
55 
56         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
57         (bool success, ) = recipient.call{ value: amount }("");
58         require(success, "Address: unable to send value, recipient may have reverted");
59     }
60 
61     /**
62      * @dev Performs a Solidity function call using a low level `call`. A
63      * plain`call` is an unsafe replacement for a function call: use this
64      * function instead.
65      *
66      * If `target` reverts with a revert reason, it is bubbled up by this
67      * function (like regular Solidity function calls).
68      *
69      * Returns the raw returned data. To convert to the expected return value,
70      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
71      *
72      * Requirements:
73      *
74      * - `target` must be a contract.
75      * - calling `target` with `data` must not revert.
76      *
77      * _Available since v3.1._
78      */
79     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
80       return functionCall(target, data, "Address: low-level call failed");
81     }
82 
83     /**
84      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
85      * `errorMessage` as a fallback revert reason when `target` reverts.
86      *
87      * _Available since v3.1._
88      */
89     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
90         return _functionCallWithValue(target, data, 0, errorMessage);
91     }
92 
93     /**
94      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
95      * but also transferring `value` wei to `target`.
96      *
97      * Requirements:
98      *
99      * - the calling contract must have an ETH balance of at least `value`.
100      * - the called Solidity function must be `payable`.
101      *
102      * _Available since v3.1._
103      */
104     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
105         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
106     }
107 
108     /**
109      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
110      * with `errorMessage` as a fallback revert reason when `target` reverts.
111      *
112      * _Available since v3.1._
113      */
114     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
115         require(address(this).balance >= value, "Address: insufficient balance for call");
116         return _functionCallWithValue(target, data, value, errorMessage);
117     }
118 
119     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
120         require(isContract(target), "Address: call to non-contract");
121 
122         // solhint-disable-next-line avoid-low-level-calls
123         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
124         if (success) {
125             return returndata;
126         } else {
127             // Look for revert reason and bubble it up if present
128             if (returndata.length > 0) {
129                 // The easiest way to bubble the revert reason is using memory via assembly
130 
131                 // solhint-disable-next-line no-inline-assembly
132                 assembly {
133                     let returndata_size := mload(returndata)
134                     revert(add(32, returndata), returndata_size)
135                 }
136             } else {
137                 revert(errorMessage);
138             }
139         }
140     }
141 }
142 
143 
144 abstract contract Context {
145     function _msgSender() internal view virtual returns (address payable) {
146         return msg.sender;
147     }
148 
149     function _msgData() internal view virtual returns (bytes memory) {
150         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
151         return msg.data;
152     }
153 }
154 
155 
156 /**
157  * @dev Contract module which provides a basic access control mechanism, where
158  * there is an account (an owner) that can be granted exclusive access to
159  * specific functions.
160  *
161  * By default, the owner account will be the one that deploys the contract. This
162  * can later be changed with {transferOwnership}.
163  *
164  * This module is used through inheritance. It will make available the modifier
165  * `onlyOwner`, which can be applied to your functions to restrict their use to
166  * the owner.
167  */
168 abstract contract Ownable is Context {
169     address private _owner;
170 
171     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
172 
173     /**
174      * @dev Initializes the contract setting the deployer as the initial owner.
175      */
176     constructor () {
177         address msgSender = _msgSender();
178         _owner = msgSender;
179         emit OwnershipTransferred(address(0), msgSender);
180     }
181 
182     /**
183      * @dev Returns the address of the current owner.
184      */
185     function owner() public view returns (address) {
186         return _owner;
187     }
188 
189     /**
190      * @dev Throws if called by any account other than the owner.
191      */
192     modifier onlyOwner() {
193         require(_owner == _msgSender(), "Ownable: caller is not the owner");
194         _;
195     }
196 
197     /**
198      * @dev Leaves the contract without owner. It will not be possible to call
199      * `onlyOwner` functions anymore. Can only be called by the current owner.
200      *
201      * NOTE: Renouncing ownership will leave the contract without an owner,
202      * thereby removing any functionality that is only available to the owner.
203      */
204     function renounceOwnership() public virtual onlyOwner {
205         emit OwnershipTransferred(_owner, address(0));
206         _owner = address(0);
207     }
208 
209     /**
210      * @dev Transfers ownership of the contract to a new account (`newOwner`).
211      * Can only be called by the current owner.
212      */
213     function transferOwnership(address newOwner) public virtual onlyOwner {
214         require(newOwner != address(0), "Ownable: new owner is the zero address");
215         emit OwnershipTransferred(_owner, newOwner);
216         _owner = newOwner;
217     }
218 }
219 
220 
221 /**
222  * @dev Wrappers over Solidity's arithmetic operations with added overflow
223  * checks.
224  *
225  * Arithmetic operations in Solidity wrap on overflow. This can easily result
226  * in bugs, because programmers usually assume that an overflow raises an
227  * error, which is the standard behavior in high level programming languages.
228  * `SafeMath` restores this intuition by reverting the transaction when an
229  * operation overflows.
230  *
231  * Using this library instead of the unchecked operations eliminates an entire
232  * class of bugs, so it's recommended to use it always.
233  */
234 library SafeMath {
235     /**
236      * @dev Returns the addition of two unsigned integers, reverting on
237      * overflow.
238      *
239      * Counterpart to Solidity's `+` operator.
240      *
241      * Requirements:
242      *
243      * - Addition cannot overflow.
244      */
245     function add(uint256 a, uint256 b) internal pure returns (uint256) {
246         uint256 c = a + b;
247         require(c >= a, "SafeMath: addition overflow");
248 
249         return c;
250     }
251 
252     /**
253      * @dev Returns the subtraction of two unsigned integers, reverting on
254      * overflow (when the result is negative).
255      *
256      * Counterpart to Solidity's `-` operator.
257      *
258      * Requirements:
259      *
260      * - Subtraction cannot overflow.
261      */
262     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
263         return sub(a, b, "SafeMath: subtraction overflow");
264     }
265 
266     /**
267      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
268      * overflow (when the result is negative).
269      *
270      * Counterpart to Solidity's `-` operator.
271      *
272      * Requirements:
273      *
274      * - Subtraction cannot overflow.
275      */
276     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
277         require(b <= a, errorMessage);
278         uint256 c = a - b;
279 
280         return c;
281     }
282 
283     /**
284      * @dev Returns the multiplication of two unsigned integers, reverting on
285      * overflow.
286      *
287      * Counterpart to Solidity's `*` operator.
288      *
289      * Requirements:
290      *
291      * - Multiplication cannot overflow.
292      */
293     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
294         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
295         // benefit is lost if 'b' is also tested.
296         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
297         if (a == 0) {
298             return 0;
299         }
300 
301         uint256 c = a * b;
302         require(c / a == b, "SafeMath: multiplication overflow");
303 
304         return c;
305     }
306 
307     /**
308      * @dev Returns the integer division of two unsigned integers. Reverts on
309      * division by zero. The result is rounded towards zero.
310      *
311      * Counterpart to Solidity's `/` operator. Note: this function uses a
312      * `revert` opcode (which leaves remaining gas untouched) while Solidity
313      * uses an invalid opcode to revert (consuming all remaining gas).
314      *
315      * Requirements:
316      *
317      * - The divisor cannot be zero.
318      */
319     function div(uint256 a, uint256 b) internal pure returns (uint256) {
320         return div(a, b, "SafeMath: division by zero");
321     }
322 
323     /**
324      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
325      * division by zero. The result is rounded towards zero.
326      *
327      * Counterpart to Solidity's `/` operator. Note: this function uses a
328      * `revert` opcode (which leaves remaining gas untouched) while Solidity
329      * uses an invalid opcode to revert (consuming all remaining gas).
330      *
331      * Requirements:
332      *
333      * - The divisor cannot be zero.
334      */
335     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
336         require(b > 0, errorMessage);
337         uint256 c = a / b;
338         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
339 
340         return c;
341     }
342 
343     /**
344      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
345      * Reverts when dividing by zero.
346      *
347      * Counterpart to Solidity's `%` operator. This function uses a `revert`
348      * opcode (which leaves remaining gas untouched) while Solidity uses an
349      * invalid opcode to revert (consuming all remaining gas).
350      *
351      * Requirements:
352      *
353      * - The divisor cannot be zero.
354      */
355     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
356         return mod(a, b, "SafeMath: modulo by zero");
357     }
358 
359     /**
360      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
361      * Reverts with custom message when dividing by zero.
362      *
363      * Counterpart to Solidity's `%` operator. This function uses a `revert`
364      * opcode (which leaves remaining gas untouched) while Solidity uses an
365      * invalid opcode to revert (consuming all remaining gas).
366      *
367      * Requirements:
368      *
369      * - The divisor cannot be zero.
370      */
371     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
372         require(b != 0, errorMessage);
373         return a % b;
374     }
375 }
376 
377 
378 interface IERC20 {
379     /**
380      * @dev Returns the amount of tokens in existence.
381      */
382     function totalSupply() external view returns (uint256);
383 
384     /**
385      * @dev Returns the amount of tokens owned by `account`.
386      */
387     function balanceOf(address account) external view returns (uint256);
388 
389     /**
390      * @dev Moves `amount` tokens from the caller's account to `recipient`.
391      *
392      * Returns a boolean value indicating whether the operation succeeded.
393      *
394      * Emits a {Transfer} event.
395      */
396     function transfer(address recipient, uint256 amount) external returns (bool);
397 
398     /**
399      * @dev Returns the remaining number of tokens that `spender` will be
400      * allowed to spend on behalf of `owner` through {transferFrom}. This is
401      * zero by default.
402      *
403      * This value changes when {approve} or {transferFrom} are called.
404      */
405     function allowance(address owner, address spender) external view returns (uint256);
406 
407     /**
408      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
409      *
410      * Returns a boolean value indicating whether the operation succeeded.
411      *
412      * IMPORTANT: Beware that changing an allowance with this method brings the risk
413      * that someone may use both the old and the new allowance by unfortunate
414      * transaction ordering. One possible solution to mitigate this race
415      * condition is to first reduce the spender's allowance to 0 and set the
416      * desired value afterwards:
417      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
418      *
419      * Emits an {Approval} event.
420      */
421     function approve(address spender, uint256 amount) external returns (bool);
422 
423     /**
424      * @dev Moves `amount` tokens from `sender` to `recipient` using the
425      * allowance mechanism. `amount` is then deducted from the caller's
426      * allowance.
427      *
428      * Returns a boolean value indicating whether the operation succeeded.
429      *
430      * Emits a {Transfer} event.
431      */
432     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
433 
434     /**
435      * @dev Emitted when `value` tokens are moved from one account (`from`) to
436      * another (`to`).
437      *
438      * Note that `value` may be zero.
439      */
440     event Transfer(address indexed from, address indexed to, uint256 value);
441 
442     /**
443      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
444      * a call to {approve}. `value` is the new allowance.
445      */
446     event Approval(address indexed owner, address indexed spender, uint256 value);
447 }
448 
449 
450 
451 /**
452  * @dev Implementation of the {IERC20} interface.
453  *
454  * This implementation is agnostic to the way tokens are created. This means
455  * that a supply mechanism has to be added in a derived contract using {_mint}.
456  * For a generic mechanism see {ERC20PresetMinterPauser}.
457  *
458  * TIP: For a detailed writeup see our guide
459  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
460  * to implement supply mechanisms].
461  *
462  * We have followed general OpenZeppelin guidelines: functions revert instead
463  * of returning `false` on failure. This behavior is nonetheless conventional
464  * and does not conflict with the expectations of ERC20 applications.
465  *
466  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
467  * This allows applications to reconstruct the allowance for all accounts just
468  * by listening to said events. Other implementations of the EIP may not emit
469  * these events, as it isn't required by the specification.
470  *
471  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
472  * functions have been added to mitigate the well-known issues around setting
473  * allowances. See {IERC20-approve}.
474  */
475 contract ERC20 is Context, IERC20 {
476     using SafeMath for uint256;
477     using Address for address;
478 
479     mapping (address => uint256) private _balances;
480 
481     mapping (address => mapping (address => uint256)) private _allowances;
482 
483     uint256 private _totalSupply;
484 
485     string private _name;
486     string private _symbol;
487     uint8 private _decimals;
488 
489     /**
490      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
491      * a default value of 18.
492      *
493      * To select a different value for {decimals}, use {_setupDecimals}.
494      *
495      * All three of these values are immutable: they can only be set once during
496      * construction.
497      */
498     constructor (string memory name_, string memory symbol_) {
499         _name = name_;
500         _symbol = symbol_;
501         _decimals = 18;
502     }
503 
504     /**
505      * @dev Returns the name of the token.
506      */
507     function name() public view returns (string memory) {
508         return _name;
509     }
510 
511     /**
512      * @dev Returns the symbol of the token, usually a shorter version of the
513      * name.
514      */
515     function symbol() public view returns (string memory) {
516         return _symbol;
517     }
518 
519     /**
520      * @dev Returns the number of decimals used to get its user representation.
521      * For example, if `decimals` equals `2`, a balance of `505` tokens should
522      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
523      *
524      * Tokens usually opt for a value of 18, imitating the relationship between
525      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
526      * called.
527      *
528      * NOTE: This information is only used for _display_ purposes: it in
529      * no way affects any of the arithmetic of the contract, including
530      * {IERC20-balanceOf} and {IERC20-transfer}.
531      */
532     function decimals() public view returns (uint8) {
533         return _decimals;
534     }
535 
536     /**
537      * @dev See {IERC20-totalSupply}.
538      */
539     function totalSupply() public view override returns (uint256) {
540         return _totalSupply;
541     }
542 
543     /**
544      * @dev See {IERC20-balanceOf}.
545      */
546     function balanceOf(address account) public view override returns (uint256) {
547         return _balances[account];
548     }
549 
550     /**
551      * @dev See {IERC20-transfer}.
552      *
553      * Requirements:
554      *
555      * - `recipient` cannot be the zero address.
556      * - the caller must have a balance of at least `amount`.
557      */
558     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
559         _transfer(_msgSender(), recipient, amount);
560         return true;
561     }
562 
563     /**
564      * @dev See {IERC20-allowance}.
565      */
566     function allowance(address owner, address spender) public view virtual override returns (uint256) {
567         return _allowances[owner][spender];
568     }
569 
570     /**
571      * @dev See {IERC20-approve}.
572      *
573      * Requirements:
574      *
575      * - `spender` cannot be the zero address.
576      */
577     function approve(address spender, uint256 amount) public virtual override returns (bool) {
578         _approve(_msgSender(), spender, amount);
579         return true;
580     }
581 
582     /**
583      * @dev See {IERC20-transferFrom}.
584      *
585      * Emits an {Approval} event indicating the updated allowance. This is not
586      * required by the EIP. See the note at the beginning of {ERC20};
587      *
588      * Requirements:
589      * - `sender` and `recipient` cannot be the zero address.
590      * - `sender` must have a balance of at least `amount`.
591      * - the caller must have allowance for ``sender``'s tokens of at least
592      * `amount`.
593      */
594     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
595         _transfer(sender, recipient, amount);
596         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
597         return true;
598     }
599 
600     /**
601      * @dev Atomically increases the allowance granted to `spender` by the caller.
602      *
603      * This is an alternative to {approve} that can be used as a mitigation for
604      * problems described in {IERC20-approve}.
605      *
606      * Emits an {Approval} event indicating the updated allowance.
607      *
608      * Requirements:
609      *
610      * - `spender` cannot be the zero address.
611      */
612     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
613         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
614         return true;
615     }
616 
617     /**
618      * @dev Atomically decreases the allowance granted to `spender` by the caller.
619      *
620      * This is an alternative to {approve} that can be used as a mitigation for
621      * problems described in {IERC20-approve}.
622      *
623      * Emits an {Approval} event indicating the updated allowance.
624      *
625      * Requirements:
626      *
627      * - `spender` cannot be the zero address.
628      * - `spender` must have allowance for the caller of at least
629      * `subtractedValue`.
630      */
631     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
632         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
633         return true;
634     }
635 
636     /**
637      * @dev Moves tokens `amount` from `sender` to `recipient`.
638      *
639      * This is internal function is equivalent to {transfer}, and can be used to
640      * e.g. implement automatic token fees, slashing mechanisms, etc.
641      *
642      * Emits a {Transfer} event.
643      *
644      * Requirements:
645      *
646      * - `sender` cannot be the zero address.
647      * - `recipient` cannot be the zero address.
648      * - `sender` must have a balance of at least `amount`.
649      */
650     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
651         require(sender != address(0), "ERC20: transfer from the zero address");
652         require(recipient != address(0), "ERC20: transfer to the zero address");
653 
654         _beforeTokenTransfer(sender, recipient, amount);
655 
656         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
657         _balances[recipient] = _balances[recipient].add(amount);
658         emit Transfer(sender, recipient, amount);
659     }
660 
661     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
662      * the total supply.
663      *
664      * Emits a {Transfer} event with `from` set to the zero address.
665      *
666      * Requirements
667      *
668      * - `to` cannot be the zero address.
669      */
670     function _mint(address account, uint256 amount) internal virtual {
671         require(account != address(0), "ERC20: mint to the zero address");
672 
673         _beforeTokenTransfer(address(0), account, amount);
674 
675         _totalSupply = _totalSupply.add(amount);
676         _balances[account] = _balances[account].add(amount);
677         emit Transfer(address(0), account, amount);
678     }
679 
680     /**
681      * @dev Destroys `amount` tokens from `account`, reducing the
682      * total supply.
683      *
684      * Emits a {Transfer} event with `to` set to the zero address.
685      *
686      * Requirements
687      *
688      * - `account` cannot be the zero address.
689      * - `account` must have at least `amount` tokens.
690      */
691     function _burn(address account, uint256 amount) internal virtual {
692         require(account != address(0), "ERC20: burn from the zero address");
693 
694         _beforeTokenTransfer(account, address(0), amount);
695 
696         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
697         _totalSupply = _totalSupply.sub(amount);
698         emit Transfer(account, address(0), amount);
699     }
700 
701     /**
702      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
703      *
704      * This internal function is equivalent to `approve`, and can be used to
705      * e.g. set automatic allowances for certain subsystems, etc.
706      *
707      * Emits an {Approval} event.
708      *
709      * Requirements:
710      *
711      * - `owner` cannot be the zero address.
712      * - `spender` cannot be the zero address.
713      */
714     function _approve(address owner, address spender, uint256 amount) internal virtual {
715         require(owner != address(0), "ERC20: approve from the zero address");
716         require(spender != address(0), "ERC20: approve to the zero address");
717 
718         _allowances[owner][spender] = amount;
719         emit Approval(owner, spender, amount);
720     }
721 
722     /**
723      * @dev Sets {decimals} to a value other than the default one of 18.
724      *
725      * WARNING: This function should only be called from the constructor. Most
726      * applications that interact with token contracts will not expect
727      * {decimals} to ever change, and may work incorrectly if it does.
728      */
729     function _setupDecimals(uint8 decimals_) internal {
730         _decimals = decimals_;
731     }
732 
733     /**
734      * @dev Hook that is called before any transfer of tokens. This includes
735      * minting and burning.
736      *
737      * Calling conditions:
738      *
739      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
740      * will be to transferred to `to`.
741      * - when `from` is zero, `amount` tokens will be minted for `to`.
742      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
743      * - `from` and `to` are never both zero.
744      *
745      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
746      */
747     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
748 }
749 
750 
751 /// @title DIV token rewards buyers from specific addresses (AMMs such as uniswap) by minting purchase rewards immediately, and burns a percentage of all on chain transactions.
752 /// @author KrippTorofu @ RiotOfTheBlock in collaboration with CommunityToken.io
753 ///   NOTES: For flexibility to onboard to new AMMs, no specific checks regarding uniswap router registration or tax limits have been added to this token.
754 ///   Until the Ownership is rescinded, owner can modify the parameters of the contract (tax, interest, whitelisted addresses).
755 ///   Minting is disabled, except for the interest.
756 contract DIVToken is ERC20, Ownable {
757     using SafeMath for uint256;
758 
759     uint32 internal _burnRatePerTransferThousandth = 10;    // default of 1%, can go as low as 0.1%, or set to 0 to disable
760     uint32 internal _interestRatePerBuyThousandth = 20;         // default of 2%, can go as low as 0.1%, or set to 0 to disable
761     
762     mapping(address => bool) internal _burnWhitelistTo;
763     mapping(address => bool) internal _burnWhitelistFrom;
764     mapping(address => bool) internal _UniswapAddresses;
765     
766     /// @notice Transfers from IUniswapV2Pair at address `addr` now will mint an extra `_interestRatePerBuyThousandth`/1000 DIV tokens per 1 Token for the recipient.
767     /// @param addr Address of an IUniswapV2Pair Contract
768     event UniswapAddressAdded(address addr);
769     /// @notice IUniswapV2Pair at address `addr` now will stop minting
770     event UniswapAddressRemoved(address addr);
771     /// @notice The address `addr` is now whitelisted, any funds sent to it will not incur a burn. 
772     /// @param addr Address of Contract / EOA to whitelist
773     event AddedToWhitelistTo(address addr);
774     /// @notice The address `addr` is removed from whitelist, any funds sent to it will now incur a burn of `_burnRatePerTransferThousandth`/1000 DIV tokens as normal. 
775     /// @param addr Address of Contract / EOA to whitelist
776     event RemovedFromWhitelistTo(address addr);
777     /// @notice The address `addr` is now whitelisted, any funds sent FROM this address will not incur a burn. 
778     /// @param addr Address of Contract / EOA to whitelist
779     event AddedToWhitelistFrom(address addr);
780     /// @notice The address `addr` is removed from whitelist, any funds sent FROM this address will now incur a burn of `_burnRatePerTransferThousandth`/1000 DIV tokens as normal. 
781     /// @param addr Address of Contract / EOA to whitelist
782     event RemovedFromWhitelistFrom(address addr);
783     /// @notice The Burn rate has been changed to `newRate`/1000 per 1 DIV token on every transaction 
784     event BurnRateChanged(uint32 newRate);
785     /// @notice The Buy Interest rate has been changed to `newRate`/1000 per 1 DIV token on every transaction
786     event InterestRateChanged(uint32 newRate);
787     
788     constructor(address tokenOwnerWallet) ERC20("Dividend Token", "DIV") {
789         _mint(tokenOwnerWallet, 500000000000000000000000);
790     }
791     
792     /**
793         @notice ERC20 transfer function overridden to add `_burnRatePerTransferThousandth`/1000 burn on transfers as well as `_interestRatePerBuyThousandth`/1000 interest for AMM purchases. 
794         @param amount amount in wei
795         
796         Burn rate is applied independently of the interest
797      */
798     function _transfer(address sender, address recipient, uint256 amount) internal virtual override {
799         if(_UniswapAddresses[sender] && _interestRatePerBuyThousandth>0) {
800             super._mint(recipient, amount.mul(_interestRatePerBuyThousandth).div(1000));
801             // no need to adjust amount
802         }
803 
804         if(!_burnWhitelistTo[recipient] && !_burnWhitelistFrom[sender] && _burnRatePerTransferThousandth>0) {
805             uint256 burnAmount = amount.mul(_burnRatePerTransferThousandth).div(1000);
806             super._burn(sender, burnAmount);
807             amount = amount.sub(burnAmount);
808         }
809         
810         // Send the modified amount to recipient
811         super._transfer(sender, recipient, amount);
812     }
813     
814     /// @notice Changes the burn rate on transfers in thousandths
815     /// @param value Set this value in thousandths i.e. 10 = 1%, 1 = 0.1%, 0 = burns are disabled.
816     function setBurnRatePerThousandth(uint32 value) external onlyOwner {
817         _burnRatePerTransferThousandth = value;
818         emit BurnRateChanged(value);
819     }
820 
821     /// @notice Returns the burn rate on transfers in thousandths
822     function getBurnRatePerThousandth() external view returns (uint32) {  
823        return _burnRatePerTransferThousandth;
824     }
825 
826     /// @notice Changes the interest rate for purchases in thousandths
827     /// @param value Set this value in thousandths i.e. 10 = 1%, 1 = 0.1%, 0 = interest is disabled.
828     function setInterestRate(uint32 value) external onlyOwner {
829         _interestRatePerBuyThousandth = value;
830         emit InterestRateChanged(value);
831     }
832 
833     /// @notice Returns the interest rate for purchases in thousandths
834     function getInterestRate() external view returns (uint32) {  
835        return _interestRatePerBuyThousandth;
836     }
837     
838     /// @notice Address `addr` will no longer incur the `_burnRatePerTransferThousandth`/1000 burn on Transfers
839     /// @param addr Address to whitelist / dewhitelist 
840     /// @param whitelisted True to add to whitelist, false to remove.
841     function setBurnWhitelistToAddress (address addr, bool whitelisted) external {
842         if(whitelisted) {
843             _burnWhitelistTo[addr] = whitelisted;
844             emit AddedToWhitelistTo(addr);
845         } else {
846             delete _burnWhitelistTo[addr];
847             emit RemovedFromWhitelistTo(addr);
848         }
849     }
850     
851     /// @notice If true, Address `addr` will not incur `_burnRatePerTransferThousandth`/1000 burn for any Transfers to it.
852     /// @param addr Address to check
853     /// @dev it is not trivial to return a mapping without incurring further storage costs
854     function isAddressWhitelistedTo(address addr) external view returns (bool) {
855         return _burnWhitelistTo[addr];
856     }
857     
858     /// @notice Address `addr` will no longer incur the `_burnRatePerTransferThousandth`/1000 burn on Transfers from it.
859     /// @param addr Address to whitelist / dewhitelist 
860     /// @param whitelisted True to add to whitelist, false to remove.
861     function setBurnWhitelistFromAddress (address addr, bool whitelisted) external {
862         if(whitelisted) {
863             _burnWhitelistFrom[addr] = whitelisted;
864             emit AddedToWhitelistFrom(addr);
865         } else {
866             delete _burnWhitelistFrom[addr];
867             emit RemovedFromWhitelistFrom(addr);
868         }
869     }
870     
871     /// @notice If true, Address `addr` will not incur `_burnRatePerTransferThousandth`/1000 burn for any Transfers from it.
872     /// @param addr Address to check
873     /// @dev it is not trivial to return a mapping without incurring further storage costs
874     function isAddressWhitelistedFrom(address addr) external view returns (bool) {
875         return _burnWhitelistFrom[addr];
876     }
877     
878     /// @notice Transfers from IUniswapV2Pair at address `addr` now will mint an extra `_interestRatePerBuyThousandth`/1000 DIV tokens per 1 Token for the recipient.
879     /// @param addr Address to generate interest rates
880     /// @param isUniswapAddress True to begin generating interest, false to remove.  Router Registration check omitted for flexibility.
881     function setUniswapAddress (address addr, bool isUniswapAddress) external {
882         if(isUniswapAddress) {
883             _UniswapAddresses[addr] = isUniswapAddress;
884             emit UniswapAddressAdded(addr);
885         } else {
886             delete _UniswapAddresses[addr];
887             emit UniswapAddressRemoved(addr);
888         }
889     }
890     
891     /// @notice If true, transfers from IUniswapV2Pair at address `addr` will mint an extra `_interestRatePerBuyThousandth`/1000 DIV tokens per 1 Token for the recipient.
892     /// @param addr Address to check
893     /// @dev it is not trivial to return a mapping without incurring further storage costs
894     function isAddressUniswapAddress(address addr) external view returns (bool) {
895         return _UniswapAddresses[addr];
896     }
897     
898     /// @notice This function can be used by Contract Owner to disperse tokens bypassing incurring penalties or interest.  The tokens will be sent from the Owner Address Balance.
899     /// @param dests Array of recipients
900     /// @param values Array of values. Ensure the values are in wei. i.e. you must multiply the amount of DIV tokens to be sent by 10**18.
901     function airdrop(address[] calldata dests, uint256[] calldata values) external onlyOwner returns (uint256) {
902         uint256 i = 0;
903         while (i < dests.length) {
904             ERC20._transfer(_msgSender(), dests[i], values[i]);
905             i += 1;
906         }
907         return(i);
908     }
909 }