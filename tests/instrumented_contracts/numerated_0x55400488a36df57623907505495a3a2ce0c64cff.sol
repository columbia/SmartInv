1 /**
2  *Submitted for verification at Etherscan.io on 2020-12-17
3 */
4 
5 //SPDX-License-Identifier: UNLICENSED
6 
7 pragma solidity ^0.7.0;
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
31 pragma solidity ^0.7.0;
32 
33 /**
34  * @dev Interface of the ERC20 standard as defined in the EIP.
35  */
36 interface IERC20 {
37     /**
38      * @dev Returns the amount of tokens in existence.
39      */
40     function totalSupply() external view returns (uint256);
41 
42     /**
43      * @dev Returns the amount of tokens owned by `account`.
44      */
45     function balanceOf(address account) external view returns (uint256);
46 
47     /**
48      * @dev Moves `amount` tokens from the caller's account to `recipient`.
49      *
50      * Returns a boolean value indicating whether the operation succeeded.
51      *
52      * Emits a {Transfer} event.
53      */
54     function transfer(address recipient, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Returns the remaining number of tokens that `spender` will be
58      * allowed to spend on behalf of `owner` through {transferFrom}. This is
59      * zero by default.
60      *
61      * This value changes when {approve} or {transferFrom} are called.
62      */
63     function allowance(address owner, address spender) external view returns (uint256);
64 
65     /**
66      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
67      *
68      * Returns a boolean value indicating whether the operation succeeded.
69      *
70      * IMPORTANT: Beware that changing an allowance with this method brings the risk
71      * that someone may use both the old and the new allowance by unfortunate
72      * transaction ordering. One possible solution to mitigate this race
73      * condition is to first reduce the spender's allowance to 0 and set the
74      * desired value afterwards:
75      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
76      *
77      * Emits an {Approval} event.
78      */
79     function approve(address spender, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Moves `amount` tokens from `sender` to `recipient` using the
83      * allowance mechanism. `amount` is then deducted from the caller's
84      * allowance.
85      *
86      * Returns a boolean value indicating whether the operation succeeded.
87      *
88      * Emits a {Transfer} event.
89      */
90     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
91 
92     /**
93      * @dev Emitted when `value` tokens are moved from one account (`from`) to
94      * another (`to`).
95      *
96      * Note that `value` may be zero.
97      */
98     event Transfer(address indexed from, address indexed to, uint256 value);
99 
100     /**
101      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
102      * a call to {approve}. `value` is the new allowance.
103      */
104     event Approval(address indexed owner, address indexed spender, uint256 value);
105 }
106 
107 
108 
109 
110 
111 pragma solidity ^0.7.0;
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
182      *
183      * - Multiplication cannot overflow.
184      */
185     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
186         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
187         // benefit is lost if 'b' is also tested.
188 
189         if (a == 0) {
190             return 0;
191         }
192 
193         uint256 c = a * b;
194         require(c / a == b, "SafeMath: multiplication overflow");
195 
196         return c;
197     }
198 
199     /**
200      * @dev Returns the integer division of two unsigned integers. Reverts on
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
211     function div(uint256 a, uint256 b) internal pure returns (uint256) {
212         return div(a, b, "SafeMath: division by zero");
213     }
214 
215     /**
216      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
217      * division by zero. The result is rounded towards zero.
218      *
219      * Counterpart to Solidity's `/` operator. Note: this function uses a
220      * `revert` opcode (which leaves remaining gas untouched) while Solidity
221      * uses an invalid opcode to revert (consuming all remaining gas).
222      *
223      * Requirements:
224      *
225      * - The divisor cannot be zero.
226      */
227     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
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
244      *
245      * - The divisor cannot be zero.
246      */
247     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
248         return mod(a, b, "SafeMath: modulo by zero");
249     }
250 
251     /**
252      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
253      * Reverts with custom message when dividing by zero.
254      *
255      * Counterpart to Solidity's `%` operator. This function uses a `revert`
256      * opcode (which leaves remaining gas untouched) while Solidity uses an
257      * invalid opcode to revert (consuming all remaining gas).
258      *
259      * Requirements:
260      *
261      * - The divisor cannot be zero.
262      */
263     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
264         require(b != 0, errorMessage);
265         return a % b;
266     }
267 }
268 
269 
270 
271 pragma solidity ^0.7.0;
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
306      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
307      * `recipient`, forwarding all available gas and reverting on errors.
308      *
309      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
310      * of certain opcodes, possibly making contracts go over the 2300 gas limit
311      * imposed by `transfer`, making them unable to receive funds via
312      * `transfer`. {sendValue} removes this limitation.
313      *
314      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
315      *
316      * IMPORTANT: because control is transferred to `recipient`, care must be
317      * taken to not create reentrancy vulnerabilities. Consider using
318      * {ReentrancyGuard} or the
319      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
320      */
321     function sendValue(address payable recipient, uint256 amount) internal {
322         require(address(this).balance >= amount, "Address: insufficient balance");
323 
324         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
325         (bool success, ) = recipient.call{ value: amount }("");
326         require(success, "Address: unable to send value, recipient may have reverted");
327     }
328 
329     /**
330      * @dev Performs a Solidity function call using a low level `call`. A
331      * plain`call` is an unsafe replacement for a function call: use this
332      * function instead.
333      *
334      * If `target` reverts with a revert reason, it is bubbled up by this
335      * function (like regular Solidity function calls).
336      *
337      * Returns the raw returned data. To convert to the expected return value,
338      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
339      *
340      * Requirements:
341      *
342      * - `target` must be a contract.
343      * - calling `target` with `data` must not revert.
344      *
345      * _Available since v3.1._
346      */
347     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
348         return functionCall(target, data, "Address: low-level call failed");
349     }
350 
351     /**
352      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
353      * `errorMessage` as a fallback revert reason when `target` reverts.
354      *
355      * _Available since v3.1._
356      */
357     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
358         return _functionCallWithValue(target, data, 0, errorMessage);
359     }
360 
361     /**
362      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
363      * but also transferring `value` wei to `target`.
364      *
365      * Requirements:
366      *
367      * - the calling contract must have an ETH balance of at least `value`.
368      * - the called Solidity function must be `payable`.
369      *
370      * _Available since v3.1._
371      */
372     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
373         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
374     }
375 
376     /**
377      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
378      * with `errorMessage` as a fallback revert reason when `target` reverts.
379      *
380      * _Available since v3.1._
381      */
382     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
383         require(address(this).balance >= value, "Address: insufficient balance for call");
384         return _functionCallWithValue(target, data, value, errorMessage);
385     }
386 
387     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
388         require(isContract(target), "Address: call to non-contract");
389 
390         // solhint-disable-next-line avoid-low-level-calls
391         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
392         if (success) {
393             return returndata;
394         } else {
395             // Look for revert reason and bubble it up if present
396             if (returndata.length > 0) {
397                 // The easiest way to bubble the revert reason is using memory via assembly
398 
399                 // solhint-disable-next-line no-inline-assembly
400                 assembly {
401                     let returndata_size := mload(returndata)
402                     revert(add(32, returndata), returndata_size)
403                 }
404             } else {
405                 revert(errorMessage);
406             }
407         }
408     }
409 }
410 
411 
412 
413 
414 pragma solidity ^0.7.0;
415 
416 
417 
418 /**
419  * @dev Implementation of the {IERC20} interface.
420  */
421 contract ERC20 is Context, IERC20 {
422     using SafeMath for uint256;
423     using Address for address;
424 
425     mapping (address => uint256) private _balances;
426 
427     mapping (address => mapping (address => uint256)) private _allowances;
428 
429     uint256 private _totalSupply;
430 
431     string private _name;
432     string private _symbol;
433     uint8 private _decimals;
434 
435     /**
436      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
437      * a default value of 18.
438      *
439      * To select a different value for {decimals}, use {_setupDecimals}.
440      *
441      * All three of these values are immutable: they can only be set once during
442      * construction.
443      */
444     constructor (string memory name_, string memory symbol_) {
445         _name = name_;
446         _symbol = symbol_;
447         _decimals = 18;
448     }
449 
450     /**
451      * @dev Returns the name of the token.
452      */
453     function name() public view returns (string memory) {
454         return _name;
455     }
456 
457     /**
458      * @dev Returns the symbol of the token, usually a shorter version of the
459      * name.
460      */
461     function symbol() public view returns (string memory) {
462         return _symbol;
463     }
464 
465     /**
466      * @dev Returns the number of decimals used to get its user representation.
467      * For example, if `decimals` equals `2`, a balance of `505` tokens should
468      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
469      *
470      * Tokens usually opt for a value of 18, imitating the relationship between
471      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
472      * called.
473      *
474      * NOTE: This information is only used for _display_ purposes: it in
475      * no way affects any of the arithmetic of the contract, including
476      * {IERC20-balanceOf} and {IERC20-transfer}.
477      */
478     function decimals() public view returns (uint8) {
479         return _decimals;
480     }
481 
482     /**
483      * @dev See {IERC20-totalSupply}.
484      */
485     function totalSupply() public view override returns (uint256) {
486         return _totalSupply;
487     }
488 
489     /**
490      * @dev See {IERC20-balanceOf}.
491      */
492     function balanceOf(address account) public view override returns (uint256) {
493         return _balances[account];
494     }
495 
496     /**
497      * @dev See {IERC20-transfer}.
498      *
499      * Requirements:
500      *
501      * - `recipient` cannot be the zero address.
502      * - the caller must have a balance of at least `amount`.
503      */
504     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
505         _transfer(_msgSender(), recipient, amount);
506         return true;
507     }
508 
509     /**
510      * @dev See {IERC20-allowance}.
511      */
512     function allowance(address owner, address spender) public view virtual override returns (uint256) {
513         return _allowances[owner][spender];
514     }
515 
516     /**
517      * @dev See {IERC20-approve}.
518      *
519      * Requirements:
520      *
521      * - `spender` cannot be the zero address.
522      */
523     function approve(address spender, uint256 amount) public virtual override returns (bool) {
524         _approve(_msgSender(), spender, amount);
525         return true;
526     }
527 
528     /**
529      * @dev See {IERC20-transferFrom}.
530      *
531      * Emits an {Approval} event indicating the updated allowance. This is not
532      * required by the EIP. See the note at the beginning of {ERC20};
533      *
534      * Requirements:
535      * - `sender` and `recipient` cannot be the zero address.
536      * - `sender` must have a balance of at least `amount`.
537      * - the caller must have allowance for ``sender``'s tokens of at least
538      * `amount`.
539      */
540     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
541         _transfer(sender, recipient, amount);
542         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
543         return true;
544     }
545 
546     /**
547      * @dev Atomically increases the allowance granted to `spender` by the caller.
548      *
549      * This is an alternative to {approve} that can be used as a mitigation for
550      * problems described in {IERC20-approve}.
551      *
552      * Emits an {Approval} event indicating the updated allowance.
553      *
554      * Requirements:
555      *
556      * - `spender` cannot be the zero address.
557      */
558     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
559         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
560         return true;
561     }
562 
563     /**
564      * @dev Atomically decreases the allowance granted to `spender` by the caller.
565      *
566      * This is an alternative to {approve} that can be used as a mitigation for
567      * problems described in {IERC20-approve}.
568      *
569      * Emits an {Approval} event indicating the updated allowance.
570      *
571      * Requirements:
572      *
573      * - `spender` cannot be the zero address.
574      * - `spender` must have allowance for the caller of at least
575      * `subtractedValue`.
576      */
577     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
578         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
579         return true;
580     }
581 
582     /**
583      * @dev Moves tokens `amount` from `sender` to `recipient`.
584      *
585      * This is internal function is equivalent to {transfer}, and can be used to
586      * e.g. implement automatic token fees, slashing mechanisms, etc.
587      *
588      * Emits a {Transfer} event.
589      *
590      * Requirements:
591      *
592      * - `sender` cannot be the zero address.
593      * - `recipient` cannot be the zero address.
594      * - `sender` must have a balance of at least `amount`.
595      */
596     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
597         require(sender != address(0), "ERC20: transfer from the zero address");
598         require(recipient != address(0), "ERC20: transfer to the zero address");
599 
600         _beforeTokenTransfer(sender, recipient, amount);
601 
602         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
603         _balances[recipient] = _balances[recipient].add(amount);
604         emit Transfer(sender, recipient, amount);
605     }
606 
607     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
608      * the total supply.
609      *
610      * Emits a {Transfer} event with `from` set to the zero address.
611      *
612      * Requirements
613      *
614      * - `to` cannot be the zero address.
615      */
616     function _mint(address account, uint256 amount) internal virtual {
617         require(account != address(0), "ERC20: mint to the zero address");
618 
619         _beforeTokenTransfer(address(0), account, amount);
620 
621         _totalSupply = _totalSupply.add(amount);
622         _balances[account] = _balances[account].add(amount);
623         emit Transfer(address(0), account, amount);
624     }
625 
626     /**
627      * @dev Destroys `amount` tokens from `account`, reducing the
628      * total supply.
629      *
630      * Emits a {Transfer} event with `to` set to the zero address.
631      *
632      * Requirements
633      *
634      * - `account` cannot be the zero address.
635      * - `account` must have at least `amount` tokens.
636      */
637     function _burn(address account, uint256 amount) internal virtual {
638         require(account != address(0), "ERC20: burn from the zero address");
639 
640         _beforeTokenTransfer(account, address(0), amount);
641 
642         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
643         _totalSupply = _totalSupply.sub(amount);
644         emit Transfer(account, address(0), amount);
645     }
646 
647     /**
648      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
649      *
650      * This internal function is equivalent to `approve`, and can be used to
651      * e.g. set automatic allowances for certain subsystems, etc.
652      *
653      * Emits an {Approval} event.
654      *
655      * Requirements:
656      *
657      * - `owner` cannot be the zero address.
658      * - `spender` cannot be the zero address.
659      */
660     function _approve(address owner, address spender, uint256 amount) internal virtual {
661         require(owner != address(0), "ERC20: approve from the zero address");
662         require(spender != address(0), "ERC20: approve to the zero address");
663 
664         _allowances[owner][spender] = amount;
665         emit Approval(owner, spender, amount);
666     }
667 
668     /**
669      * @dev Sets {decimals} to a value other than the default one of 18.
670      *
671      * WARNING: This function should only be called from the constructor. Most
672      * applications that interact with token contracts will not expect
673      * {decimals} to ever change, and may work incorrectly if it does.
674      */
675     function _setupDecimals(uint8 decimals_) internal {
676         _decimals = decimals_;
677     }
678 
679     /**
680      * @dev Hook that is called before any transfer of tokens. This includes
681      * minting and burning.
682      *
683      * Calling conditions:
684      *
685      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
686      * will be to transferred to `to`.
687      * - when `from` is zero, `amount` tokens will be minted for `to`.
688      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
689      * - `from` and `to` are never both zero.
690      *
691      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
692      */
693     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
694 }
695 
696 
697 
698 pragma solidity ^0.7.0;
699 
700 /**
701  * @dev Contract module which provides a basic access control mechanism, where
702  * there is an account (an owner) that can be granted exclusive access to
703  * specific functions.
704  *
705  * By default, the owner account will be the one that deploys the contract. This
706  * can later be changed with {transferOwnership}.
707  *
708  * This module is used through inheritance. It will make available the modifier
709  * `onlyOwner`, which can be applied to your functions to restrict their use to
710  * the owner.
711  */
712 abstract contract Ownable is Context {
713     address private _owner;
714 
715     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
716 
717     /**
718      * @dev Initializes the contract setting the deployer as the initial owner.
719      */
720     constructor () {
721         address msgSender = _msgSender();
722         _owner = msgSender;
723         emit OwnershipTransferred(address(0), msgSender);
724     }
725 
726     /**
727      * @dev Returns the address of the current owner.
728      */
729     function owner() public view returns (address payable) {
730         return address(uint160(_owner));
731     }
732 
733     /**
734      * @dev Throws if called by any account other than the owner.
735      */
736     modifier onlyOwner() {
737         require(_owner == _msgSender(), "Ownable: caller is not the owner");
738         _;
739     }
740 
741     /**
742      * @dev Leaves the contract without owner. It will not be possible to call
743      * `onlyOwner` functions anymore. Can only be called by the current owner.
744      *
745      * NOTE: Renouncing ownership will leave the contract without an owner,
746      * thereby removing any functionality that is only available to the owner.
747      */
748     function renounceOwnership() public virtual onlyOwner {
749         emit OwnershipTransferred(_owner, address(0));
750         _owner = address(0);
751     }
752 
753     /**
754      * @dev Transfers ownership of the contract to a new account (`newOwner`).
755      * Can only be called by the current owner.
756      */
757     function transferOwnership(address newOwner) public virtual onlyOwner {
758         require(newOwner != address(0), "Ownable: new owner is the zero address");
759         emit OwnershipTransferred(_owner, newOwner);
760         _owner = newOwner;
761     }
762 }
763 
764 // File: eth-token-recover/contracts/TokenRecover.sol
765 
766 
767 
768 pragma solidity ^0.7.0;
769 
770 
771 
772 /**
773  * @title TokenRecover
774  * @dev Allow to recover any ERC20 sent into the contract for error
775  */
776 contract TokenRecover is Ownable {
777 
778     /**
779      * @dev Remember that only owner can call so be careful when use on contracts generated from other contracts.
780      * @param tokenAddress The token contract address
781      * @param tokenAmount Number of tokens to be sent
782      */
783     function recoverERC20(address tokenAddress, uint256 tokenAmount) public onlyOwner {
784         IERC20(tokenAddress).transfer(owner(), tokenAmount);
785     }
786 }
787 
788 // File: contracts/service/ServiceReceiver.sol
789 
790 
791 
792 pragma solidity ^0.7.0;
793 
794 
795 /**
796  * @title ServiceReceiver
797  * @dev Implementation of the ServiceReceiver
798  */
799 contract ServiceReceiver is TokenRecover {
800 
801     mapping (bytes32 => uint256) private _prices;
802 
803     event Created(string serviceName, address indexed serviceAddress);
804 
805     function pay(string memory serviceName) public payable {
806         require(msg.value == _prices[_toBytes32(serviceName)], "ServiceReceiver: incorrect price");
807 
808         emit Created(serviceName, _msgSender());
809     }
810 
811     function getPrice(string memory serviceName) public view returns (uint256) {
812         return _prices[_toBytes32(serviceName)];
813     }
814 
815     function setPrice(string memory serviceName, uint256 amount) public onlyOwner {
816         _prices[_toBytes32(serviceName)] = amount;
817     }
818 
819     function withdraw(uint256 amount) public onlyOwner {
820         payable(owner()).transfer(amount);
821     }
822 
823     function _toBytes32(string memory serviceName) private pure returns (bytes32) {
824         return keccak256(abi.encode(serviceName));
825     }
826 }
827 
828 // File: contracts/service/ServicePayer.sol
829 
830 
831 
832 pragma solidity ^0.7.0;
833 
834 
835 /**
836  * @title ServicePayer
837  * @dev Implementation of the ServicePayer
838  */
839 contract ServicePayer {
840 
841     constructor (address payable receiver, string memory serviceName) payable {
842         ServiceReceiver(receiver).pay{value: msg.value}(serviceName);
843     }
844 }
845 
846 
847 
848 pragma solidity ^0.7.0;
849 
850 
851 
852 /**
853  * @title FTX
854  */
855 contract FTX is ERC20, Ownable {
856 
857     using SafeMath for uint256;
858     using Address for address;
859 
860 
861     event Reserved(address indexed from, uint256 value);
862     event Sync(address indexed from);
863     event Interest(address indexed from, uint256 value);
864     event Stake(address indexed staker, uint256 value);
865     event UnStake(address indexed staker, uint256 value);
866 
867     uint256 private _currentSupply = 0;
868 
869     uint256 private _softLimit = 1900000000000000000000000;
870     uint256 private _hardLimit = 1900000000000000000000000;
871 
872     uint256 private _baseSlab = 0;
873     uint256 private _basePriceWei = 100000000000000;
874 
875     uint256 private _incrementWei = 500000000;
876     uint256 private _buyFee = 1200;
877     uint256 private _buyCommission = 1000;
878     uint256 private _sellCommission = 1000;
879 
880     uint256 private _maxSellBatch = 1000000000000000000000; //in FTX
881     uint256 private _maxBuyBatch = 5000000000000000000000; //in FTX
882 
883     address payable _commissionReceiver;
884     address payable _feeReceiver;
885 
886     constructor (
887         string memory name,
888         string memory symbol,
889         uint8 decimals,
890         address payable commissionReceiver,
891         address payable feeReceiver
892     ) ERC20(name, symbol) payable {
893         _setupDecimals(decimals);
894 
895         _commissionReceiver = commissionReceiver;
896         _feeReceiver = feeReceiver;
897     }
898 
899     receive() external payable{
900         emit Reserved(msg.sender, msg.value);
901     }
902 
903     function setIncrement(uint256 increment) external onlyOwner(){
904         _incrementWei = increment;
905     }
906     function getIncrement() public view returns (uint256){
907         return _incrementWei;
908     }
909 
910     function getHardLimit() public view returns (uint256){
911         return _hardLimit;
912     }
913 
914     function getSoftLimit() public view returns (uint256){
915         return _softLimit;
916     }
917 
918 
919 
920     function setMaxSellBatch(uint256 limit) external onlyOwner(){
921         _maxSellBatch = limit;
922     }
923     function getMaxSellBatch() public view returns (uint256){
924         return _maxSellBatch;
925     }
926 
927     function setMaxBuyBatch(uint256 limit) external onlyOwner(){
928         _maxBuyBatch = limit;
929     }
930     function getMaxBuyBatch() public view returns (uint256){
931         return _maxBuyBatch;
932     }
933 
934     function setCommissionReceiver(address payable rec) external onlyOwner(){
935         _commissionReceiver = rec;
936     }
937     function getCommissionReceiver() public view returns (address){
938         return _commissionReceiver;
939     }
940 
941     function setFeeReceiver(address payable rec) external onlyOwner(){
942         _feeReceiver = rec;
943     }
944     function getFeeReceiver() public view returns (address){
945         return _feeReceiver;
946     }
947 
948 
949     function getCurrentSupply() public view returns (uint256){
950         return _currentSupply;
951     }
952 
953     function setCurrentSupply(uint256 cs) external onlyOwner(){
954         _currentSupply = cs * 1 ether;
955     }
956 
957     function getBaseSlab() public view returns (uint256){
958         return _baseSlab;
959     }
960 
961     function setBaseSlab(uint256 bs) external onlyOwner(){
962         _baseSlab = bs * 1 ether;
963     }
964 
965     function getBasePrice() public view returns (uint256){
966         return _basePriceWei;
967     }
968 
969     function getBuyFee() public view returns (uint256){
970         return _buyFee;
971     }
972 
973     function getBuyCommission() public view returns (uint256){
974         return _buyCommission;
975     }
976 
977     function getSellCommission() public view returns (uint256){
978         return _sellCommission;
979     }
980 
981     function setBuyCommission(uint256 bc) external onlyOwner(){
982         _buyCommission = bc;
983     }
984     function setBuyFee(uint256 bf) external onlyOwner(){
985         _buyFee = bf;
986     }
987 
988     function setSellCommission(uint256 sc) external onlyOwner(){
989         _sellCommission = sc;
990     }
991 
992     function setBasePrice(uint256 bp) external onlyOwner(){
993         _basePriceWei = bp;
994     }
995 
996     function updateSlabs(uint256 bs, uint256 bp, uint256 increment) external onlyOwner(){
997         _basePriceWei = bp;
998         _baseSlab = bs * 1 ether;
999         _incrementWei = increment;
1000     }
1001 
1002     function getCurrentPrice() public view returns (uint256){
1003         uint256 additionalTokens = 0;
1004 
1005         if(_currentSupply >= _baseSlab){
1006             additionalTokens = _currentSupply.sub( _baseSlab, "An error has occurred");
1007             additionalTokens = additionalTokens / 1 ether;
1008         }
1009 
1010         uint256 increment = additionalTokens * _incrementWei;
1011         uint256 price = _basePriceWei.add(increment);
1012         return price;
1013     }
1014 
1015     function buyTokens() external payable{
1016         uint256 value = msg.value;
1017 
1018         uint256 price = getCurrentPrice();
1019 
1020         uint256 tokens = value.div(price) ;
1021 
1022         uint256 token_wei = tokens * 1 ether;
1023 
1024         require(token_wei <= _maxBuyBatch, "FTX: invalid buy quantity" );
1025 
1026         //reduce tokens by BUY_FEE
1027         uint256 fee = uint256((token_wei * _buyFee ) / 10000 );
1028         uint256 commission = uint256((token_wei * _buyCommission ) / 100000 );
1029 
1030         token_wei = token_wei.sub((fee + commission), "Calculation error");
1031 
1032         transferTo(_msgSender(), token_wei , false);
1033         transferTo(_commissionReceiver, commission , false);
1034         transferTo(_feeReceiver, fee, false);
1035 
1036     }
1037 
1038     function addTokens(address to, uint256 value) external onlyOwner(){
1039         _transfer(_feeReceiver, to, value);
1040     }
1041 
1042     function addInterest(address to, uint256 value) external onlyOwner(){
1043         transferTo(to, value , false);
1044     }
1045 
1046     function transferTo(address to, uint256 value, bool convert_to_wei) internal  {
1047         require(to != address(0), "FTX: transfer to zero address");
1048 
1049         deploy(to, value, convert_to_wei);
1050     }
1051 
1052     function transferTo(address to, uint256 value) internal  {
1053         require(to != address(0), "FTX: transfer to zero address");
1054 
1055         deploy(to, value);
1056     }
1057 
1058     function deploy(address to, uint256 value) internal {
1059         value = value * 1 ether;
1060         require((_currentSupply + value ) < _hardLimit , "Max supply reached");
1061 
1062         _mint(to, value);
1063         _currentSupply = _currentSupply.add(value);
1064     }
1065 
1066     function deploy(address to, uint256 value, bool convert_to_wei) internal {
1067         if(convert_to_wei)
1068             value = value * 1 ether;
1069 
1070         require((_currentSupply + value ) < _hardLimit , "Max supply reached");
1071 
1072         _mint(to, value);
1073         _currentSupply = _currentSupply.add(value);
1074     }
1075 
1076     function byebye() external onlyOwner() {
1077         selfdestruct(owner());
1078     }
1079 
1080     function clean(uint256 _amount) external onlyOwner(){
1081         require(address(this).balance > _amount, "Invalid digits");
1082 
1083         owner().transfer(_amount);
1084     }
1085 
1086     function syncInterest(uint256 _tokens) external payable{
1087 
1088         emit Interest(_msgSender(), _tokens);
1089     }
1090 
1091     function syncTokens(uint256 _tokens) external payable{
1092 
1093         require(balanceOf(_commissionReceiver) > _tokens, "Invalid token digits");
1094 
1095         emit Sync(_msgSender());
1096     }
1097 
1098     function stakeTokens(uint256 amount) external {
1099         amount = amount * 1 ether;
1100         require(balanceOf(_msgSender()) >= amount, "FTX: recipient account doesn't have enough balance");
1101 
1102         _transfer(_msgSender(), _feeReceiver, amount);
1103         emit Stake(_msgSender(), amount);
1104     }
1105 
1106     function unstakeTokens(uint256 amount) external {
1107         amount = amount * 1 ether;
1108         require(balanceOf(_feeReceiver) >= amount, "FTX: invalid token digits");
1109         emit UnStake(_msgSender(), amount);
1110     }
1111 
1112 
1113     function sellTokens(uint256 amount) external {
1114         amount = amount * 1 ether;
1115         uint256 currentPrice = getCurrentPrice();
1116 
1117         require(balanceOf(_msgSender()) >= amount, "FTX: recipient account doesn't have enough balance");
1118         require(amount <= _maxSellBatch, "FTX: invalid sell quantity" );
1119         _currentSupply = _currentSupply.sub(amount, "Base reached");
1120 
1121         //reduce tokens by SELL_COMMISSION
1122 
1123         uint256 commission = uint256((amount * _sellCommission ) / 100000 );
1124         amount = amount.sub( commission, "Calculation error");
1125         uint256 wei_value = ((currentPrice * amount) / 1 ether);
1126 
1127         require(address(this).balance >= wei_value, "FTX: invalid digits");
1128 
1129         _burn(_msgSender(), (amount + commission) );
1130         transferTo(_commissionReceiver, commission, false);
1131         _msgSender().transfer(wei_value);
1132 
1133 
1134     }
1135 
1136 }