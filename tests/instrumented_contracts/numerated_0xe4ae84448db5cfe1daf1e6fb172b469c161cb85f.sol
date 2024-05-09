1 // SPDX-License-Identifier: MIT
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
15 abstract contract Context {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
22         return msg.data;
23     }
24 }
25 
26 
27 pragma solidity ^0.6.2;
28 
29 /**
30  * @dev Collection of functions related to the address type
31  */
32 library Address {
33     /**
34      * @dev Returns true if `account` is a contract.
35      *
36      * [IMPORTANT]
37      * ====
38      * It is unsafe to assume that an address for which this function returns
39      * false is an externally-owned account (EOA) and not a contract.
40      *
41      * Among others, `isContract` will return false for the following
42      * types of addresses:
43      *
44      *  - an externally-owned account
45      *  - a contract in construction
46      *  - an address where a contract will be created
47      *  - an address where a contract lived, but was destroyed
48      * ====
49      */
50     function isContract(address account) internal view returns (bool) {
51         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
52         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
53         // for accounts without code, i.e. `keccak256('')`
54         bytes32 codehash;
55         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
56         // solhint-disable-next-line no-inline-assembly
57         assembly { codehash := extcodehash(account) }
58         return (codehash != accountHash && codehash != 0x0);
59     }
60 
61     /**
62      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
63      * `recipient`, forwarding all available gas and reverting on errors.
64      *
65      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
66      * of certain opcodes, possibly making contracts go over the 2300 gas limit
67      * imposed by `transfer`, making them unable to receive funds via
68      * `transfer`. {sendValue} removes this limitation.
69      *
70      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
71      *
72      * IMPORTANT: because control is transferred to `recipient`, care must be
73      * taken to not create reentrancy vulnerabilities. Consider using
74      * {ReentrancyGuard} or the
75      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
76      */
77     function sendValue(address payable recipient, uint256 amount) internal {
78         require(address(this).balance >= amount, "Address: insufficient balance");
79 
80         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
81         (bool success, ) = recipient.call{ value: amount }("");
82         require(success, "Address: unable to send value, recipient may have reverted");
83     }
84 
85     /**
86      * @dev Performs a Solidity function call using a low level `call`. A
87      * plain`call` is an unsafe replacement for a function call: use this
88      * function instead.
89      *
90      * If `target` reverts with a revert reason, it is bubbled up by this
91      * function (like regular Solidity function calls).
92      *
93      * Returns the raw returned data. To convert to the expected return value,
94      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
95      *
96      * Requirements:
97      *
98      * - `target` must be a contract.
99      * - calling `target` with `data` must not revert.
100      *
101      * _Available since v3.1._
102      */
103     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
104       return functionCall(target, data, "Address: low-level call failed");
105     }
106 
107     /**
108      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
109      * `errorMessage` as a fallback revert reason when `target` reverts.
110      *
111      * _Available since v3.1._
112      */
113     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
114         return _functionCallWithValue(target, data, 0, errorMessage);
115     }
116 
117     /**
118      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
119      * but also transferring `value` wei to `target`.
120      *
121      * Requirements:
122      *
123      * - the calling contract must have an ETH balance of at least `value`.
124      * - the called Solidity function must be `payable`.
125      *
126      * _Available since v3.1._
127      */
128     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
129         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
130     }
131 
132     /**
133      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
134      * with `errorMessage` as a fallback revert reason when `target` reverts.
135      *
136      * _Available since v3.1._
137      */
138     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
139         require(address(this).balance >= value, "Address: insufficient balance for call");
140         return _functionCallWithValue(target, data, value, errorMessage);
141     }
142 
143     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
144         require(isContract(target), "Address: call to non-contract");
145 
146         // solhint-disable-next-line avoid-low-level-calls
147         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
148         if (success) {
149             return returndata;
150         } else {
151             // Look for revert reason and bubble it up if present
152             if (returndata.length > 0) {
153                 // The easiest way to bubble the revert reason is using memory via assembly
154 
155                 // solhint-disable-next-line no-inline-assembly
156                 assembly {
157                     let returndata_size := mload(returndata)
158                     revert(add(32, returndata), returndata_size)
159                 }
160             } else {
161                 revert(errorMessage);
162             }
163         }
164     }
165 }
166 
167 pragma solidity ^0.6.2;
168 
169 /**
170  * @dev Wrappers over Solidity's arithmetic operations with added overflow
171  * checks.
172  *
173  * Arithmetic operations in Solidity wrap on overflow. This can easily result
174  * in bugs, because programmers usually assume that an overflow raises an
175  * error, which is the standard behavior in high level programming languages.
176  * `SafeMath` restores this intuition by reverting the transaction when an
177  * operation overflows.
178  *
179  * Using this library instead of the unchecked operations eliminates an entire
180  * class of bugs, so it's recommended to use it always.
181  */
182 library SafeMath {
183     /**
184      * @dev Returns the addition of two unsigned integers, reverting on
185      * overflow.
186      *
187      * Counterpart to Solidity's `+` operator.
188      *
189      * Requirements:
190      *
191      * - Addition cannot overflow.
192      */
193     function add(uint256 a, uint256 b) internal pure returns (uint256) {
194         uint256 c = a + b;
195         require(c >= a, "SafeMath: addition overflow");
196 
197         return c;
198     }
199 
200     /**
201      * @dev Returns the subtraction of two unsigned integers, reverting on
202      * overflow (when the result is negative).
203      *
204      * Counterpart to Solidity's `-` operator.
205      *
206      * Requirements:
207      *
208      * - Subtraction cannot overflow.
209      */
210     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
211         return sub(a, b, "SafeMath: subtraction overflow");
212     }
213 
214     /**
215      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
216      * overflow (when the result is negative).
217      *
218      * Counterpart to Solidity's `-` operator.
219      *
220      * Requirements:
221      *
222      * - Subtraction cannot overflow.
223      */
224     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
225         require(b <= a, errorMessage);
226         uint256 c = a - b;
227 
228         return c;
229     }
230 
231     /**
232      * @dev Returns the multiplication of two unsigned integers, reverting on
233      * overflow.
234      *
235      * Counterpart to Solidity's `*` operator.
236      *
237      * Requirements:
238      *
239      * - Multiplication cannot overflow.
240      */
241     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
242         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
243         // benefit is lost if 'b' is also tested.
244         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
245         if (a == 0) {
246             return 0;
247         }
248 
249         uint256 c = a * b;
250         require(c / a == b, "SafeMath: multiplication overflow");
251 
252         return c;
253     }
254 
255     /**
256      * @dev Returns the integer division of two unsigned integers. Reverts on
257      * division by zero. The result is rounded towards zero.
258      *
259      * Counterpart to Solidity's `/` operator. Note: this function uses a
260      * `revert` opcode (which leaves remaining gas untouched) while Solidity
261      * uses an invalid opcode to revert (consuming all remaining gas).
262      *
263      * Requirements:
264      *
265      * - The divisor cannot be zero.
266      */
267     function div(uint256 a, uint256 b) internal pure returns (uint256) {
268         return div(a, b, "SafeMath: division by zero");
269     }
270 
271     /**
272      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
273      * division by zero. The result is rounded towards zero.
274      *
275      * Counterpart to Solidity's `/` operator. Note: this function uses a
276      * `revert` opcode (which leaves remaining gas untouched) while Solidity
277      * uses an invalid opcode to revert (consuming all remaining gas).
278      *
279      * Requirements:
280      *
281      * - The divisor cannot be zero.
282      */
283     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
284         require(b > 0, errorMessage);
285         uint256 c = a / b;
286         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
287 
288         return c;
289     }
290 
291     /**
292      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
293      * Reverts when dividing by zero.
294      *
295      * Counterpart to Solidity's `%` operator. This function uses a `revert`
296      * opcode (which leaves remaining gas untouched) while Solidity uses an
297      * invalid opcode to revert (consuming all remaining gas).
298      *
299      * Requirements:
300      *
301      * - The divisor cannot be zero.
302      */
303     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
304         return mod(a, b, "SafeMath: modulo by zero");
305     }
306 
307     /**
308      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
309      * Reverts with custom message when dividing by zero.
310      *
311      * Counterpart to Solidity's `%` operator. This function uses a `revert`
312      * opcode (which leaves remaining gas untouched) while Solidity uses an
313      * invalid opcode to revert (consuming all remaining gas).
314      *
315      * Requirements:
316      *
317      * - The divisor cannot be zero.
318      */
319     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
320         require(b != 0, errorMessage);
321         return a % b;
322     }
323 }
324 
325 pragma solidity ^0.6.2;
326 
327 /**
328  * @dev Interface of the ERC20 standard as defined in the EIP.
329  */
330 interface IERC20 {
331     /**
332      * @dev Returns the amount of tokens in existence.
333      */
334     function totalSupply() external view returns (uint256);
335 
336     /**
337      * @dev Returns the amount of tokens owned by `account`.
338      */
339     function balanceOf(address account) external view returns (uint256);
340 
341     /**
342      * @dev Moves `amount` tokens from the caller's account to `recipient`.
343      *
344      * Returns a boolean value indicating whether the operation succeeded.
345      *
346      * Emits a {Transfer} event.
347      */
348     function transfer(address recipient, uint256 amount) external returns (bool);
349 
350     /**
351      * @dev Returns the remaining number of tokens that `spender` will be
352      * allowed to spend on behalf of `owner` through {transferFrom}. This is
353      * zero by default.
354      *
355      * This value changes when {approve} or {transferFrom} are called.
356      */
357     function allowance(address owner, address spender) external view returns (uint256);
358 
359     /**
360      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
361      *
362      * Returns a boolean value indicating whether the operation succeeded.
363      *
364      * IMPORTANT: Beware that changing an allowance with this method brings the risk
365      * that someone may use both the old and the new allowance by unfortunate
366      * transaction ordering. One possible solution to mitigate this race
367      * condition is to first reduce the spender's allowance to 0 and set the
368      * desired value afterwards:
369      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
370      *
371      * Emits an {Approval} event.
372      */
373     function approve(address spender, uint256 amount) external returns (bool);
374 
375     /**
376      * @dev Moves `amount` tokens from `sender` to `recipient` using the
377      * allowance mechanism. `amount` is then deducted from the caller's
378      * allowance.
379      *
380      * Returns a boolean value indicating whether the operation succeeded.
381      *
382      * Emits a {Transfer} event.
383      */
384     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
385 
386     /**
387      * @dev Emitted when `value` tokens are moved from one account (`from`) to
388      * another (`to`).
389      *
390      * Note that `value` may be zero.
391      */
392     event Transfer(address indexed from, address indexed to, uint256 value);
393 
394     /**
395      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
396      * a call to {approve}. `value` is the new allowance.
397      */
398     event Approval(address indexed owner, address indexed spender, uint256 value);
399 }
400 
401 pragma solidity ^0.6.2;
402 
403 /**
404  * @dev Contract module which provides a basic access control mechanism, where
405  * there is an account (an owner) that can be granted exclusive access to
406  * specific functions.
407  *
408  * By default, the owner account will be the one that deploys the contract. This
409  * can later be changed with {transferOwnership}.
410  *
411  * This module is used through inheritance. It will make available the modifier
412  * `onlyOwner`, which can be applied to your functions to restrict their use to
413  * the owner.
414  */
415 contract Ownable is Context {
416     address private _owner;
417 
418     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
419 
420     /**
421      * @dev Initializes the contract setting the deployer as the initial owner.
422      */
423     constructor () internal {
424         address msgSender = _msgSender();
425         _owner = msgSender;
426         emit OwnershipTransferred(address(0), msgSender);
427     }
428 
429     /**
430      * @dev Returns the address of the current owner.
431      */
432     function owner() public view returns (address) {
433         return _owner;
434     }
435 
436     /**
437      * @dev Throws if called by any account other than the owner.
438      */
439     modifier onlyOwner() {
440         require(_owner == _msgSender(), "Ownable: caller is not the owner");
441         _;
442     }
443 
444     /**
445      * @dev Leaves the contract without owner. It will not be possible to call
446      * `onlyOwner` functions anymore. Can only be called by the current owner.
447      *
448      * NOTE: Renouncing ownership will leave the contract without an owner,
449      * thereby removing any functionality that is only available to the owner.
450      */
451     function renounceOwnership() public virtual onlyOwner {
452         emit OwnershipTransferred(_owner, address(0));
453         _owner = address(0);
454     }
455 
456     /**
457      * @dev Transfers ownership of the contract to a new account (`newOwner`).
458      * Can only be called by the current owner.
459      */
460     function transferOwnership(address newOwner) public virtual onlyOwner {
461         require(newOwner != address(0), "Ownable: new owner is the zero address");
462         emit OwnershipTransferred(_owner, newOwner);
463         _owner = newOwner;
464     }
465 }
466 
467 pragma solidity ^0.6.2;
468 
469 /**
470  * @dev Implementation of the {IERC20} interface.
471  *
472  * This implementation is agnostic to the way tokens are created. This means
473  * that a supply mechanism has to be added in a derived contract using {_mint}.
474  * For a generic mechanism see {ERC20PresetMinterPauser}.
475  *
476  * TIP: For a detailed writeup see our guide
477  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
478  * to implement supply mechanisms].
479  *
480  * We have followed general OpenZeppelin guidelines: functions revert instead
481  * of returning `false` on failure. This behavior is nonetheless conventional
482  * and does not conflict with the expectations of ERC20 applications.
483  *
484  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
485  * This allows applications to reconstruct the allowance for all accounts just
486  * by listening to said events. Other implementations of the EIP may not emit
487  * these events, as it isn't required by the specification.
488  *
489  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
490  * functions have been added to mitigate the well-known issues around setting
491  * allowances. See {IERC20-approve}.
492  */
493 contract ERC20 is Context, IERC20 {
494     using SafeMath for uint256;
495     using Address for address;
496 
497     mapping (address => uint256) internal _balances;
498 
499     mapping (address => mapping (address => uint256)) private _allowances;
500 
501     uint256 internal _totalSupply;
502 
503     string private _name;
504     string private _symbol;
505     uint8 private _decimals;
506 
507     /**
508      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
509      * a default value of 18.
510      *
511      * To select a different value for {decimals}, use {_setupDecimals}.
512      *
513      * All three of these values are immutable: they can only be set once during
514      * construction.
515      */
516     constructor (string memory name, string memory symbol, uint8 decimals) public {
517         _name = name;
518         _symbol = symbol;
519         _decimals = decimals;
520     }
521     
522 
523     /**
524      * @dev Returns the name of the token.
525      */
526     function name() public view returns (string memory) {
527         return _name;
528     }
529 
530     /**
531      * @dev Returns the symbol of the token, usually a shorter version of the
532      * name.
533      */
534     function symbol() public view returns (string memory) {
535         return _symbol;
536     }
537 
538     /**
539      * @dev Returns the number of decimals used to get its user representation.
540      * For example, if `decimals` equals `2`, a balance of `505` tokens should
541      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
542      *
543      * Tokens usually opt for a value of 18, imitating the relationship between
544      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
545      * called.
546      *
547      * NOTE: This information is only used for _display_ purposes: it in
548      * no way affects any of the arithmetic of the contract, including
549      * {IERC20-balanceOf} and {IERC20-transfer}.
550      */
551     function decimals() public view returns (uint8) {
552         return _decimals;
553     }
554 
555     /**
556      * @dev See {IERC20-totalSupply}.
557      */
558     function totalSupply() public view override returns (uint256) {
559         return _totalSupply;
560     }
561 
562     /**
563      * @dev See {IERC20-balanceOf}.
564      */
565     function balanceOf(address account) public view override returns (uint256) {
566         return _balances[account];
567     }
568 
569     /**
570      * @dev See {IERC20-transfer}.
571      *
572      * Requirements:
573      *
574      * - `recipient` cannot be the zero address.
575      * - the caller must have a balance of at least `amount`.
576      */
577     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
578         _transfer(_msgSender(), recipient, amount);
579         return true;
580     }
581 
582     /**
583      * @dev See {IERC20-allowance}.
584      */
585     function allowance(address owner, address spender) public view virtual override returns (uint256) {
586         return _allowances[owner][spender];
587     }
588 
589     /**
590      * @dev See {IERC20-approve}.
591      *
592      * Requirements:
593      *
594      * - `spender` cannot be the zero address.
595      */
596     function approve(address spender, uint256 amount) public virtual override returns (bool) {
597         _approve(_msgSender(), spender, amount);
598         return true;
599     }
600 
601     /**
602      * @dev See {IERC20-transferFrom}.
603      *
604      * Emits an {Approval} event indicating the updated allowance. This is not
605      * required by the EIP. See the note at the beginning of {ERC20};
606      *
607      * Requirements:
608      * - `sender` and `recipient` cannot be the zero address.
609      * - `sender` must have a balance of at least `amount`.
610      * - the caller must have allowance for ``sender``'s tokens of at least
611      * `amount`.
612      */
613     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
614         _transfer(sender, recipient, amount);
615         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
616         return true;
617     }
618 
619     /**
620      * @dev Atomically increases the allowance granted to `spender` by the caller.
621      *
622      * This is an alternative to {approve} that can be used as a mitigation for
623      * problems described in {IERC20-approve}.
624      *
625      * Emits an {Approval} event indicating the updated allowance.
626      *
627      * Requirements:
628      *
629      * - `spender` cannot be the zero address.
630      */
631     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
632         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
633         return true;
634     }
635 
636     /**
637      * @dev Atomically decreases the allowance granted to `spender` by the caller.
638      *
639      * This is an alternative to {approve} that can be used as a mitigation for
640      * problems described in {IERC20-approve}.
641      *
642      * Emits an {Approval} event indicating the updated allowance.
643      *
644      * Requirements:
645      *
646      * - `spender` cannot be the zero address.
647      * - `spender` must have allowance for the caller of at least
648      * `subtractedValue`.
649      */
650     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
651         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
652         return true;
653     }
654     
655     /**
656      * @dev Moves tokens `amount` from `sender` to `recipient`.
657      *
658      * This is internal function is equivalent to {transfer}, and can be used to
659      * e.g. implement automatic token fees, slashing mechanisms, etc.
660      *
661      * Emits a {Transfer} event.
662      *
663      * Requirements:
664      *
665      * - `sender` cannot be the zero address.
666      * - `recipient` cannot be the zero address.
667      * - `sender` must have a balance of at least `amount`.
668      */
669     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
670         require(sender != address(0), "ERC20: transfer from the zero address");
671         require(recipient != address(0), "ERC20: transfer to the zero address");
672 
673         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
674         _balances[recipient] = _balances[recipient].add(amount);
675         emit Transfer(sender, recipient, amount);
676     }
677 
678     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
679      * the total supply.
680      *
681      * Emits a {Transfer} event with `from` set to the zero address.
682      *
683      * Requirements
684      *
685      * - `to` cannot be the zero address.
686      */
687     function _mint(address account, uint256 amount) internal virtual {}
688 
689     /**
690      * @dev Destroys `amount` tokens from `account`, reducing the
691      * total supply.
692      *
693      * Emits a {Transfer} event with `to` set to the zero address.
694      *
695      * Requirements
696      *
697      * - `account` cannot be the zero address.
698      * - `account` must have at least `amount` tokens.
699      */
700     function _burn(address account, uint256 amount) internal virtual {
701         require(account != address(0), "ERC20: burn from the zero address");
702 
703         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
704         _totalSupply = _totalSupply.sub(amount);
705         emit Transfer(account, address(0), amount);
706     }
707 
708     /**
709      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
710      *
711      * This is internal function is equivalent to `approve`, and can be used to
712      * e.g. set automatic allowances for certain subsystems, etc.
713      *
714      * Emits an {Approval} event.
715      *
716      * Requirements:
717      *
718      * - `owner` cannot be the zero address.
719      * - `spender` cannot be the zero address.
720      */
721     function _approve(address owner, address spender, uint256 amount) internal virtual {
722         require(owner != address(0), "ERC20: approve from the zero address");
723         require(spender != address(0), "ERC20: approve to the zero address");
724 
725         _allowances[owner][spender] = amount;
726         emit Approval(owner, spender, amount);
727     }
728 
729     /**
730      * @dev Sets {decimals} to a value other than the default one of 18.
731      *
732      * WARNING: This function should only be called from the constructor. Most
733      * applications that interact with token contracts will not expect
734      * {decimals} to ever change, and may work incorrectly if it does.
735      */
736     function _setupDecimals(uint8 decimals_) internal {
737         _decimals = decimals_;
738     }
739 
740 }
741 
742 pragma solidity ^0.6.0;
743 
744 /**
745  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
746  *
747  * These functions can be used to verify that a message was signed by the holder
748  * of the private keys of a given address.
749  */
750 library ECDSA {
751     /**
752      * @dev Returns the address that signed a hashed message (`hash`) with
753      * `signature`. This address can then be used for verification purposes.
754      *
755      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
756      * this function rejects them by requiring the `s` value to be in the lower
757      * half order, and the `v` value to be either 27 or 28.
758      *
759      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
760      * verification to be secure: it is possible to craft signatures that
761      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
762      * this is by receiving a hash of the original message (which may otherwise
763      * be too long), and then calling {toEthSignedMessageHash} on it.
764      */
765     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
766         // Check the signature length
767         if (signature.length != 65) {
768             revert("ECDSA: invalid signature length");
769         }
770 
771         // Divide the signature in r, s and v variables
772         bytes32 r;
773         bytes32 s;
774         uint8 v;
775 
776         // ecrecover takes the signature parameters, and the only way to get them
777         // currently is to use assembly.
778         // solhint-disable-next-line no-inline-assembly
779         assembly {
780             r := mload(add(signature, 0x20))
781             s := mload(add(signature, 0x40))
782             v := byte(0, mload(add(signature, 0x60)))
783         }
784 
785         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
786         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
787         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
788         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
789         //
790         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
791         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
792         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
793         // these malleable signatures as well.
794         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
795             revert("ECDSA: invalid signature 's' value");
796         }
797 
798         if (v != 27 && v != 28) {
799             revert("ECDSA: invalid signature 'v' value");
800         }
801 
802         // If the signature is valid (and not malleable), return the signer address
803         address signer = ecrecover(hash, v, r, s);
804         require(signer != address(0), "ECDSA: invalid signature");
805 
806         return signer;
807     }
808 
809     /**
810      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
811      * replicates the behavior of the
812      * https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign[`eth_sign`]
813      * JSON-RPC method.
814      *
815      * See {recover}.
816      */
817     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
818         // 32 is the length in bytes of hash,
819         // enforced by the type signature above
820         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
821     }
822 }
823 
824 contract UOP is ERC20, Ownable {
825     
826     using ECDSA for bytes32;
827     
828     constructor()  ERC20("Utopia Open Platform", "UOP", 18) public 
829     {
830         _operatorApproved[msg.sender] = true;
831         _mint(0x08Ca29489282DF3daE9e6654A567daAfe2EF93a1, 100000000000000000000000000);
832         transferOwnership(0x08Ca29489282DF3daE9e6654A567daAfe2EF93a1);
833     }
834     
835     uint256 private _maxTotalSupply = 100000000000000000000000000;
836     uint256 constant chainId = 1;
837     address verifyingContract = address(this);
838   
839     string private constant EIP712_DOMAIN  = "EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)";
840     string private constant FORWARD_DATA_TYPE = "ForwardData(address from,address to,uint256 value,uint256 nonce)";
841   
842     bytes32 private constant EIP712_DOMAIN_TYPEHASH = keccak256(abi.encodePacked(EIP712_DOMAIN));
843     bytes32 private constant FORWARD_DATA_TYPEHASH = keccak256(abi.encodePacked(FORWARD_DATA_TYPE));
844 
845     bytes32 private DOMAIN_SEPARATOR = keccak256(abi.encode(
846         EIP712_DOMAIN_TYPEHASH,
847         keccak256("UOP token"),
848         keccak256("1"),
849         chainId,
850         verifyingContract
851     ));
852     
853     struct ForwardData {
854         address from;
855         address to;
856         uint256 value;
857         uint256 nonce;
858     }
859     
860     // Nonces of senders, used to prevent replay attacks
861     mapping(address => uint256) private nonces;
862     
863     mapping (address => bool) private _operatorApproved;
864     
865     modifier onlyOperator() {
866         require(_operatorApproved[msg.sender], "Operator: not allowed");
867         _;
868     }
869     
870     function getNonce(address from) public view returns (uint256) {
871         return nonces[from];
872     }
873 
874     function _verifyNonce(address account, uint256 nonce) internal view {
875         require(nonces[account] == nonce, "nonce mismatch");
876     }
877 
878     function _verifySig(ForwardData memory data, bytes memory sig) internal view {
879         bytes32 digest = hashForwardData(data);
880         require(digest.recover(sig) == data.from, "UOP: signature mismatch");
881     }
882 
883     function _updateNonce(address account) internal {
884         nonces[account]++;
885     }
886     
887     function hashForwardData(ForwardData memory data) private view returns(bytes32) {
888     return keccak256(abi.encodePacked(
889         "\x19\x01",
890         DOMAIN_SEPARATOR,
891         keccak256(abi.encode(
892             FORWARD_DATA_TYPEHASH,
893             data.from,
894             data.to,
895             data.value,
896             data.nonce
897         ))
898     ));
899     }
900     
901     function getMaxTotalSupply() external view returns (uint256) {
902         return _maxTotalSupply;
903     }
904     
905     function approveOperator(address _operator) external onlyOwner {
906         _operatorApproved[_operator] = true;
907     }
908     
909     function disableOperator(address _operator) external onlyOwner {
910         _operatorApproved[_operator] = false;
911     }
912     
913     function isOperator(address _operator) external view returns (bool) {
914         return _operatorApproved[_operator];
915     }
916     
917 
918     function mint(address account, uint256 amount) external onlyOwner {
919         _mint(account, amount);
920     }
921     
922     function mintForBridge(address account, uint256 amount, uint commission, uint userNonce) external onlyOperator {
923         _verifyNonce(account, userNonce);
924         _updateNonce(account);
925         _mint(account, amount);
926         _mint(msg.sender, commission);
927     }
928     function burnForBridge(address account, uint256 amount) external onlyOperator {
929         _burn(account, amount);
930     }
931     
932     function burn(address account, uint256 amount) external onlyOwner {
933         _burn(account, amount);
934     }
935     
936     function transferNoFee(address _from, address _to, uint256 _value, uint256 _nonce, uint256 fee, bytes calldata sig) external returns (bool) {
937         ForwardData memory data = ForwardData(_from, _to, _value, _nonce);
938         _verifyNonce(data.from, data.nonce);
939         _verifySig(data, sig);
940         _updateNonce(data.from);
941         require(data.to != address(0));
942 
943         _balances[data.from] = _balances[data.from].sub(data.value, "ERC20: transfer amount exceeds balance");
944         _balances[data.to] = _balances[data.to].add(data.value);
945 
946         _balances[data.from] = _balances[data.from].sub(fee, "ERC20: transfer amount exceeds balance");
947         _balances[msg.sender] = _balances[msg.sender].add(fee);
948         emit Transfer(data.from, data.to, data.value);
949         return true;
950     }
951     
952     function _mint(address account, uint256 amount) internal override {
953         require(account != address(0), "ERC20: mint to the zero address");
954         require(_totalSupply.add(amount) <= _maxTotalSupply, "ERC20: minting more then MaxTotalSupply");
955         
956         _totalSupply = _totalSupply.add(amount);
957         _balances[account] = _balances[account].add(amount);
958         emit Transfer(address(0), account, amount);
959     }
960 }