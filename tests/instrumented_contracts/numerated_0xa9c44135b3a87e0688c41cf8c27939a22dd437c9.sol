1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.6.2;
4 
5 
6 // 
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
28 // 
29 /**
30  * @dev Interface of the ERC20 standard as defined in the EIP.
31  */
32 interface IERC20 {
33     /**
34      * @dev Returns the amount of tokens in existence.
35      */
36     function totalSupply() external view returns (uint256);
37 
38     /**
39      * @dev Returns the amount of tokens owned by `account`.
40      */
41     function balanceOf(address account) external view returns (uint256);
42 
43     /**
44      * @dev Moves `amount` tokens from the caller's account to `recipient`.
45      *
46      * Returns a boolean value indicating whether the operation succeeded.
47      *
48      * Emits a {Transfer} event.
49      */
50     function transfer(address recipient, uint256 amount) external returns (bool);
51 
52     /**
53      * @dev Returns the remaining number of tokens that `spender` will be
54      * allowed to spend on behalf of `owner` through {transferFrom}. This is
55      * zero by default.
56      *
57      * This value changes when {approve} or {transferFrom} are called.
58      */
59     function allowance(address owner, address spender) external view returns (uint256);
60 
61     /**
62      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
63      *
64      * Returns a boolean value indicating whether the operation succeeded.
65      *
66      * IMPORTANT: Beware that changing an allowance with this method brings the risk
67      * that someone may use both the old and the new allowance by unfortunate
68      * transaction ordering. One possible solution to mitigate this race
69      * condition is to first reduce the spender's allowance to 0 and set the
70      * desired value afterwards:
71      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
72      *
73      * Emits an {Approval} event.
74      */
75     function approve(address spender, uint256 amount) external returns (bool);
76 
77     /**
78      * @dev Moves `amount` tokens from `sender` to `recipient` using the
79      * allowance mechanism. `amount` is then deducted from the caller's
80      * allowance.
81      *
82      * Returns a boolean value indicating whether the operation succeeded.
83      *
84      * Emits a {Transfer} event.
85      */
86     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
87 
88     /**
89      * @dev Emitted when `value` tokens are moved from one account (`from`) to
90      * another (`to`).
91      *
92      * Note that `value` may be zero.
93      */
94     event Transfer(address indexed from, address indexed to, uint256 value);
95 
96     /**
97      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
98      * a call to {approve}. `value` is the new allowance.
99      */
100     event Approval(address indexed owner, address indexed spender, uint256 value);
101 }
102 
103 // 
104 /**
105  * @dev Wrappers over Solidity's arithmetic operations with added overflow
106  * checks.
107  *
108  * Arithmetic operations in Solidity wrap on overflow. This can easily result
109  * in bugs, because programmers usually assume that an overflow raises an
110  * error, which is the standard behavior in high level programming languages.
111  * `SafeMath` restores this intuition by reverting the transaction when an
112  * operation overflows.
113  *
114  * Using this library instead of the unchecked operations eliminates an entire
115  * class of bugs, so it's recommended to use it always.
116  */
117 library SafeMath {
118     /**
119      * @dev Returns the addition of two unsigned integers, reverting on
120      * overflow.
121      *
122      * Counterpart to Solidity's `+` operator.
123      *
124      * Requirements:
125      *
126      * - Addition cannot overflow.
127      */
128     function add(uint256 a, uint256 b) internal pure returns (uint256) {
129         uint256 c = a + b;
130         require(c >= a, "SafeMath: addition overflow");
131 
132         return c;
133     }
134 
135     /**
136      * @dev Returns the subtraction of two unsigned integers, reverting on
137      * overflow (when the result is negative).
138      *
139      * Counterpart to Solidity's `-` operator.
140      *
141      * Requirements:
142      *
143      * - Subtraction cannot overflow.
144      */
145     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
146         return sub(a, b, "SafeMath: subtraction overflow");
147     }
148 
149     /**
150      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
151      * overflow (when the result is negative).
152      *
153      * Counterpart to Solidity's `-` operator.
154      *
155      * Requirements:
156      *
157      * - Subtraction cannot overflow.
158      */
159     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
160         require(b <= a, errorMessage);
161         uint256 c = a - b;
162 
163         return c;
164     }
165 
166     /**
167      * @dev Returns the multiplication of two unsigned integers, reverting on
168      * overflow.
169      *
170      * Counterpart to Solidity's `*` operator.
171      *
172      * Requirements:
173      *
174      * - Multiplication cannot overflow.
175      */
176     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
177         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
178         // benefit is lost if 'b' is also tested.
179         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
180         if (a == 0) {
181             return 0;
182         }
183 
184         uint256 c = a * b;
185         require(c / a == b, "SafeMath: multiplication overflow");
186 
187         return c;
188     }
189 
190     /**
191      * @dev Returns the integer division of two unsigned integers. Reverts on
192      * division by zero. The result is rounded towards zero.
193      *
194      * Counterpart to Solidity's `/` operator. Note: this function uses a
195      * `revert` opcode (which leaves remaining gas untouched) while Solidity
196      * uses an invalid opcode to revert (consuming all remaining gas).
197      *
198      * Requirements:
199      *
200      * - The divisor cannot be zero.
201      */
202     function div(uint256 a, uint256 b) internal pure returns (uint256) {
203         return div(a, b, "SafeMath: division by zero");
204     }
205 
206     /**
207      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
208      * division by zero. The result is rounded towards zero.
209      *
210      * Counterpart to Solidity's `/` operator. Note: this function uses a
211      * `revert` opcode (which leaves remaining gas untouched) while Solidity
212      * uses an invalid opcode to revert (consuming all remaining gas).
213      *
214      * Requirements:
215      *
216      * - The divisor cannot be zero.
217      */
218     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
219         require(b > 0, errorMessage);
220         uint256 c = a / b;
221         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
222 
223         return c;
224     }
225 
226     /**
227      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
228      * Reverts when dividing by zero.
229      *
230      * Counterpart to Solidity's `%` operator. This function uses a `revert`
231      * opcode (which leaves remaining gas untouched) while Solidity uses an
232      * invalid opcode to revert (consuming all remaining gas).
233      *
234      * Requirements:
235      *
236      * - The divisor cannot be zero.
237      */
238     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
239         return mod(a, b, "SafeMath: modulo by zero");
240     }
241 
242     /**
243      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
244      * Reverts with custom message when dividing by zero.
245      *
246      * Counterpart to Solidity's `%` operator. This function uses a `revert`
247      * opcode (which leaves remaining gas untouched) while Solidity uses an
248      * invalid opcode to revert (consuming all remaining gas).
249      *
250      * Requirements:
251      *
252      * - The divisor cannot be zero.
253      */
254     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
255         require(b != 0, errorMessage);
256         return a % b;
257     }
258 }
259 
260 // 
261 /**
262  * @dev Collection of functions related to the address type
263  */
264 library Address {
265     /**
266      * @dev Returns true if `account` is a contract.
267      *
268      * [IMPORTANT]
269      * ====
270      * It is unsafe to assume that an address for which this function returns
271      * false is an externally-owned account (EOA) and not a contract.
272      *
273      * Among others, `isContract` will return false for the following
274      * types of addresses:
275      *
276      *  - an externally-owned account
277      *  - a contract in construction
278      *  - an address where a contract will be created
279      *  - an address where a contract lived, but was destroyed
280      * ====
281      */
282     function isContract(address account) internal view returns (bool) {
283         // This method relies in extcodesize, which returns 0 for contracts in
284         // construction, since the code is only stored at the end of the
285         // constructor execution.
286 
287         uint256 size;
288         // solhint-disable-next-line no-inline-assembly
289         assembly { size := extcodesize(account) }
290         return size > 0;
291     }
292 
293     /**
294      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
295      * `recipient`, forwarding all available gas and reverting on errors.
296      *
297      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
298      * of certain opcodes, possibly making contracts go over the 2300 gas limit
299      * imposed by `transfer`, making them unable to receive funds via
300      * `transfer`. {sendValue} removes this limitation.
301      *
302      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
303      *
304      * IMPORTANT: because control is transferred to `recipient`, care must be
305      * taken to not create reentrancy vulnerabilities. Consider using
306      * {ReentrancyGuard} or the
307      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
308      */
309     function sendValue(address payable recipient, uint256 amount) internal {
310         require(address(this).balance >= amount, "Address: insufficient balance");
311 
312         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
313         (bool success, ) = recipient.call{ value: amount }("");
314         require(success, "Address: unable to send value, recipient may have reverted");
315     }
316 
317     /**
318      * @dev Performs a Solidity function call using a low level `call`. A
319      * plain`call` is an unsafe replacement for a function call: use this
320      * function instead.
321      *
322      * If `target` reverts with a revert reason, it is bubbled up by this
323      * function (like regular Solidity function calls).
324      *
325      * Returns the raw returned data. To convert to the expected return value,
326      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
327      *
328      * Requirements:
329      *
330      * - `target` must be a contract.
331      * - calling `target` with `data` must not revert.
332      *
333      * _Available since v3.1._
334      */
335     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
336       return functionCall(target, data, "Address: low-level call failed");
337     }
338 
339     /**
340      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
341      * `errorMessage` as a fallback revert reason when `target` reverts.
342      *
343      * _Available since v3.1._
344      */
345     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
346         return _functionCallWithValue(target, data, 0, errorMessage);
347     }
348 
349     /**
350      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
351      * but also transferring `value` wei to `target`.
352      *
353      * Requirements:
354      *
355      * - the calling contract must have an ETH balance of at least `value`.
356      * - the called Solidity function must be `payable`.
357      *
358      * _Available since v3.1._
359      */
360     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
361         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
362     }
363 
364     /**
365      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
366      * with `errorMessage` as a fallback revert reason when `target` reverts.
367      *
368      * _Available since v3.1._
369      */
370     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
371         require(address(this).balance >= value, "Address: insufficient balance for call");
372         return _functionCallWithValue(target, data, value, errorMessage);
373     }
374 
375     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
376         require(isContract(target), "Address: call to non-contract");
377 
378         // solhint-disable-next-line avoid-low-level-calls
379         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
380         if (success) {
381             return returndata;
382         } else {
383             // Look for revert reason and bubble it up if present
384             if (returndata.length > 0) {
385                 // The easiest way to bubble the revert reason is using memory via assembly
386 
387                 // solhint-disable-next-line no-inline-assembly
388                 assembly {
389                     let returndata_size := mload(returndata)
390                     revert(add(32, returndata), returndata_size)
391                 }
392             } else {
393                 revert(errorMessage);
394             }
395         }
396     }
397 }
398 
399 // 
400 /**
401  * @dev Implementation of the {IERC20} interface.
402  *
403  * This implementation is agnostic to the way tokens are created. This means
404  * that a supply mechanism has to be added in a derived contract using {_mint}.
405  * For a generic mechanism see {ERC20PresetMinterPauser}.
406  *
407  * TIP: For a detailed writeup see our guide
408  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
409  * to implement supply mechanisms].
410  *
411  * We have followed general OpenZeppelin guidelines: functions revert instead
412  * of returning `false` on failure. This behavior is nonetheless conventional
413  * and does not conflict with the expectations of ERC20 applications.
414  *
415  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
416  * This allows applications to reconstruct the allowance for all accounts just
417  * by listening to said events. Other implementations of the EIP may not emit
418  * these events, as it isn't required by the specification.
419  *
420  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
421  * functions have been added to mitigate the well-known issues around setting
422  * allowances. See {IERC20-approve}.
423  */
424 contract ERC20 is Context, IERC20 {
425     using SafeMath for uint256;
426     using Address for address;
427 
428     mapping (address => uint256) private _balances;
429 
430     mapping (address => mapping (address => uint256)) private _allowances;
431 
432     uint256 private _totalSupply;
433 
434     string private _name;
435     string private _symbol;
436     uint8 private _decimals;
437 
438     /**
439      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
440      * a default value of 18.
441      *
442      * To select a different value for {decimals}, use {_setupDecimals}.
443      *
444      * All three of these values are immutable: they can only be set once during
445      * construction.
446      */
447     constructor (string memory name, string memory symbol) public {
448         _name = name;
449         _symbol = symbol;
450         _decimals = 18;
451     }
452 
453     /**
454      * @dev Returns the name of the token.
455      */
456     function name() public view returns (string memory) {
457         return _name;
458     }
459 
460     /**
461      * @dev Returns the symbol of the token, usually a shorter version of the
462      * name.
463      */
464     function symbol() public view returns (string memory) {
465         return _symbol;
466     }
467 
468     /**
469      * @dev Returns the number of decimals used to get its user representation.
470      * For example, if `decimals` equals `2`, a balance of `505` tokens should
471      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
472      *
473      * Tokens usually opt for a value of 18, imitating the relationship between
474      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
475      * called.
476      *
477      * NOTE: This information is only used for _display_ purposes: it in
478      * no way affects any of the arithmetic of the contract, including
479      * {IERC20-balanceOf} and {IERC20-transfer}.
480      */
481     function decimals() public view returns (uint8) {
482         return _decimals;
483     }
484 
485     /**
486      * @dev See {IERC20-totalSupply}.
487      */
488     function totalSupply() public view override returns (uint256) {
489         return _totalSupply;
490     }
491 
492     /**
493      * @dev See {IERC20-balanceOf}.
494      */
495     function balanceOf(address account) public view override returns (uint256) {
496         return _balances[account];
497     }
498 
499     /**
500      * @dev See {IERC20-transfer}.
501      *
502      * Requirements:
503      *
504      * - `recipient` cannot be the zero address.
505      * - the caller must have a balance of at least `amount`.
506      */
507     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
508         _transfer(_msgSender(), recipient, amount);
509         return true;
510     }
511 
512     /**
513      * @dev See {IERC20-allowance}.
514      */
515     function allowance(address owner, address spender) public view virtual override returns (uint256) {
516         return _allowances[owner][spender];
517     }
518 
519     /**
520      * @dev See {IERC20-approve}.
521      *
522      * Requirements:
523      *
524      * - `spender` cannot be the zero address.
525      */
526     function approve(address spender, uint256 amount) public virtual override returns (bool) {
527         _approve(_msgSender(), spender, amount);
528         return true;
529     }
530 
531     /**
532      * @dev See {IERC20-transferFrom}.
533      *
534      * Emits an {Approval} event indicating the updated allowance. This is not
535      * required by the EIP. See the note at the beginning of {ERC20};
536      *
537      * Requirements:
538      * - `sender` and `recipient` cannot be the zero address.
539      * - `sender` must have a balance of at least `amount`.
540      * - the caller must have allowance for ``sender``'s tokens of at least
541      * `amount`.
542      */
543     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
544         _transfer(sender, recipient, amount);
545         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
546         return true;
547     }
548 
549     /**
550      * @dev Atomically increases the allowance granted to `spender` by the caller.
551      *
552      * This is an alternative to {approve} that can be used as a mitigation for
553      * problems described in {IERC20-approve}.
554      *
555      * Emits an {Approval} event indicating the updated allowance.
556      *
557      * Requirements:
558      *
559      * - `spender` cannot be the zero address.
560      */
561     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
562         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
563         return true;
564     }
565 
566     /**
567      * @dev Atomically decreases the allowance granted to `spender` by the caller.
568      *
569      * This is an alternative to {approve} that can be used as a mitigation for
570      * problems described in {IERC20-approve}.
571      *
572      * Emits an {Approval} event indicating the updated allowance.
573      *
574      * Requirements:
575      *
576      * - `spender` cannot be the zero address.
577      * - `spender` must have allowance for the caller of at least
578      * `subtractedValue`.
579      */
580     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
581         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
582         return true;
583     }
584 
585     /**
586      * @dev Moves tokens `amount` from `sender` to `recipient`.
587      *
588      * This is internal function is equivalent to {transfer}, and can be used to
589      * e.g. implement automatic token fees, slashing mechanisms, etc.
590      *
591      * Emits a {Transfer} event.
592      *
593      * Requirements:
594      *
595      * - `sender` cannot be the zero address.
596      * - `recipient` cannot be the zero address.
597      * - `sender` must have a balance of at least `amount`.
598      */
599     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
600         require(sender != address(0), "ERC20: transfer from the zero address");
601         require(recipient != address(0), "ERC20: transfer to the zero address");
602 
603         _beforeTokenTransfer(sender, recipient, amount);
604 
605         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
606         _balances[recipient] = _balances[recipient].add(amount);
607         emit Transfer(sender, recipient, amount);
608     }
609 
610     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
611      * the total supply.
612      *
613      * Emits a {Transfer} event with `from` set to the zero address.
614      *
615      * Requirements
616      *
617      * - `to` cannot be the zero address.
618      */
619     function _mint(address account, uint256 amount) internal virtual {
620         require(account != address(0), "ERC20: mint to the zero address");
621 
622         _beforeTokenTransfer(address(0), account, amount);
623 
624         _totalSupply = _totalSupply.add(amount);
625         _balances[account] = _balances[account].add(amount);
626         emit Transfer(address(0), account, amount);
627     }
628 
629     /**
630      * @dev Destroys `amount` tokens from `account`, reducing the
631      * total supply.
632      *
633      * Emits a {Transfer} event with `to` set to the zero address.
634      *
635      * Requirements
636      *
637      * - `account` cannot be the zero address.
638      * - `account` must have at least `amount` tokens.
639      */
640     function _burn(address account, uint256 amount) internal virtual {
641         require(account != address(0), "ERC20: burn from the zero address");
642 
643         _beforeTokenTransfer(account, address(0), amount);
644 
645         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
646         _totalSupply = _totalSupply.sub(amount);
647         emit Transfer(account, address(0), amount);
648     }
649 
650     /**
651      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
652      *
653      * This internal function is equivalent to `approve`, and can be used to
654      * e.g. set automatic allowances for certain subsystems, etc.
655      *
656      * Emits an {Approval} event.
657      *
658      * Requirements:
659      *
660      * - `owner` cannot be the zero address.
661      * - `spender` cannot be the zero address.
662      */
663     function _approve(address owner, address spender, uint256 amount) internal virtual {
664         require(owner != address(0), "ERC20: approve from the zero address");
665         require(spender != address(0), "ERC20: approve to the zero address");
666 
667         _allowances[owner][spender] = amount;
668         emit Approval(owner, spender, amount);
669     }
670 
671     /**
672      * @dev Sets {decimals} to a value other than the default one of 18.
673      *
674      * WARNING: This function should only be called from the constructor. Most
675      * applications that interact with token contracts will not expect
676      * {decimals} to ever change, and may work incorrectly if it does.
677      */
678     function _setupDecimals(uint8 decimals_) internal {
679         _decimals = decimals_;
680     }
681 
682     /**
683      * @dev Hook that is called before any transfer of tokens. This includes
684      * minting and burning.
685      *
686      * Calling conditions:
687      *
688      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
689      * will be to transferred to `to`.
690      * - when `from` is zero, `amount` tokens will be minted for `to`.
691      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
692      * - `from` and `to` are never both zero.
693      *
694      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
695      */
696     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
697 }
698 
699 // 
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
712 contract Ownable is Context {
713     address private _owner;
714 
715     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
716 
717     /**
718      * @dev Initializes the contract setting the deployer as the initial owner.
719      */
720     constructor () internal {
721         address msgSender = _msgSender();
722         _owner = msgSender;
723         emit OwnershipTransferred(address(0), msgSender);
724     }
725 
726     /**
727      * @dev Returns the address of the current owner.
728      */
729     function owner() public view returns (address) {
730         return _owner;
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
764 // 
765 contract Ectoplasma is ERC20("Ectoplasma", "ECTO"), Ownable {
766     using SafeMath for uint256;
767     address public devaddr;
768 
769     // the amount of burn to ecto during every transfer, i.e. 100 = 1%, 50 = 2%, 40 = 2.5%, 255 being the lowest burn
770     uint8 public burnDivisor;
771 
772     constructor(uint8 _burnDivisor, address _devaddr) public {
773         require(_burnDivisor > 0, "Ecto: burnDivisor must be bigger than 0");
774         burnDivisor = _burnDivisor;
775         devaddr = _devaddr;
776     }
777     // mints new ecto tokens, can only be called by BooBank
778     // contract during burns, no users or dev can call this
779     function mint(address _to, uint256 _amount) public onlyOwner {
780         _mint(_to, _amount);
781     }
782 
783     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
784         // ecto amount is adjustable
785         uint256 burnAmount = amount.div(burnDivisor);
786 
787         _burn(msg.sender, burnAmount);
788         // 1%
789         _mint(devaddr, amount.div(100));
790 
791         // sender transfers 99% of the ecto
792         return super.transfer(recipient, amount.sub(burnAmount));
793     }
794 
795     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
796         // ecto amount is 1%
797         uint256 burnAmount = amount.div(burnDivisor);
798         // recipient receives 1% ecto tokens
799 
800         // sender loses the 1% of the ecto
801         _burn(sender, burnAmount);
802         _mint(devaddr, amount.div(100));
803         // sender transfers 99% of the ecto
804         return super.transferFrom(sender, recipient, amount.sub(burnDivisor));
805     }
806 
807     function setDevAddr(address _devaddr) public onlyOwner {
808         devaddr = _devaddr;
809     }
810 
811     function setBurnRate(uint8 _burnDivisor) public onlyOwner {
812         require(_burnDivisor > 0, "Boo: burnDivisor must be bigger than 0");
813         burnDivisor = _burnDivisor;
814     }
815 }
816 
817 // 
818 // Boo with Governance.
819 contract BooBank is ERC20("BooBank", "BOOB"), Ownable {
820     // START OF BOO BANK SPECIFIC CODE
821     // BooBank is an exact copy of sushi except for the
822     // following code, which implements a burn every transfer
823     // https://etherscan.io/token/0x6b3595068778dd592e39a122f4f5a5cf09c90fe2
824     // the Boo burn a variable quantity of the transfer amount, and gives the
825     // recipient the equivalent Ecto token
826     using SafeMath for uint256;
827     address public devaddr;
828     // the ecto token that gets generated when transfers occur
829     Ectoplasma public ecto;
830     // the amount of burn to ecto during every transfer, i.e. 255 = 0.4%, 100 = 1%, 50 = 2%, 40 = 2.5%
831     uint8 public burnDivisor;
832     // Pause until block x (to prevent at lp init bots from taking large chunks of coins for cheap)
833     uint256 public pauseUntilBlock = 0;
834 
835     constructor(uint8 _burnDivisor, Ectoplasma _ecto, address _devaddr) public {
836         require(_burnDivisor > 0, "Boo: burnDivisor must be bigger than 0");
837         ecto = _ecto;
838         burnDivisor = _burnDivisor;
839         devaddr = _devaddr;
840     }
841     
842     function transfer(address recipient, uint256 amount) public checkRunning virtual override returns (bool) {
843         // ecto amount is 1%
844         uint256 ectoAmount = amount.div(burnDivisor);
845         uint256 onePct = amount.div(100);
846         // sender receives the burnDivisor - 1% ecto tokens
847         ecto.mint(msg.sender, ectoAmount > onePct ? ectoAmount.sub(onePct) : ectoAmount);
848         // sender loses the 1% of the BOOB
849         _burn(msg.sender, ectoAmount);
850         // 1%
851         _mint(devaddr, amount.div(100));
852         // sender transfers 99% of the BOOB
853         return super.transfer(recipient, amount.sub(ectoAmount));
854     }
855 
856     function transferFrom(address sender, address recipient, uint256 amount) public checkRunning virtual override returns (bool) {
857         // ecto amount from burn
858         uint256 ectoAmount = amount.div(burnDivisor);
859         uint256 onePct = amount.div(100);
860         // recipient receives the burnDivisor - 1% ecto tokens
861         ecto.mint(sender, ectoAmount > onePct ? ectoAmount.sub(onePct) : ectoAmount);
862         // sender loses the 1% of the BOOB
863         _burn(sender, ectoAmount);
864         // 1%
865         _mint(devaddr, amount.div(100));
866         // sender transfers 99% of the BOOB
867         return super.transferFrom(sender, recipient, amount.sub(ectoAmount));
868     }
869 
870     function setBurnRate(uint8 _burnDivisor) public onlyOwner {
871         require(_burnDivisor > 0, "Boo: burnDivisor must be bigger than 0");
872         burnDivisor = _burnDivisor;
873         ecto.setBurnRate(_burnDivisor);
874     }
875 
876     /// @notice Creates `_amount` token to `_to`. Must only be called by the owner (MrBanker).
877     function mint(address _to, uint256 _amount) public onlyOwner {
878         _mint(_to, _amount);
879         _moveDelegates(address(0), _delegates[_to], _amount);
880     }
881 
882     function setDevAddr(address _devAddr) public onlyOwner {
883         devaddr = _devAddr;
884         ecto.setDevAddr(devaddr);
885     }
886 
887     function setPauseBlock(uint256 _pauseUntilBlock) public onlyOwner {
888         pauseUntilBlock = _pauseUntilBlock;
889     }
890 
891     modifier checkRunning(){
892         require(block.number > pauseUntilBlock, "Go away bot");
893         _;
894     }
895 
896     // Copied and modified from YAM code:
897     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernanceStorage.sol
898     // https://github.com/yam-finance/yam-protocol/blob/master/contracts/token/YAMGovernance.sol
899     // Which is copied and modified from COMPOUND:
900     // https://github.com/compound-finance/compound-protocol/blob/master/contracts/Governance/Comp.sol
901 
902     /// @notice A record of each accounts delegate
903     mapping (address => address) internal _delegates;
904 
905     /// @notice A checkpoint for marking number of votes from a given block
906     struct Checkpoint {
907         uint32 fromBlock;
908         uint256 votes;
909     }
910 
911     /// @notice A record of votes checkpoints for each account, by index
912     mapping (address => mapping (uint32 => Checkpoint)) public checkpoints;
913 
914     /// @notice The number of checkpoints for each account
915     mapping (address => uint32) public numCheckpoints;
916 
917     /// @notice The EIP-712 typehash for the contract's domain
918     bytes32 public constant DOMAIN_TYPEHASH = keccak256("EIP712Domain(string name,uint256 chainId,address verifyingContract)");
919 
920     /// @notice The EIP-712 typehash for the delegation struct used by the contract
921     bytes32 public constant DELEGATION_TYPEHASH = keccak256("Delegation(address delegatee,uint256 nonce,uint256 expiry)");
922 
923     /// @notice A record of states for signing / validating signatures
924     mapping (address => uint) public nonces;
925 
926       /// @notice An event thats emitted when an account changes its delegate
927     event DelegateChanged(address indexed delegator, address indexed fromDelegate, address indexed toDelegate);
928 
929     /// @notice An event thats emitted when a delegate account's vote balance changes
930     event DelegateVotesChanged(address indexed delegate, uint previousBalance, uint newBalance);
931 
932     /**
933      * @notice Delegate votes from `msg.sender` to `delegatee`
934      * @param delegator The address to get delegatee for
935      */
936     function delegates(address delegator)
937         external
938         view
939         returns (address)
940     {
941         return _delegates[delegator];
942     }
943 
944    /**
945     * @notice Delegate votes from `msg.sender` to `delegatee`
946     * @param delegatee The address to delegate votes to
947     */
948     function delegate(address delegatee) external {
949         return _delegate(msg.sender, delegatee);
950     }
951 
952     /**
953      * @notice Delegates votes from signatory to `delegatee`
954      * @param delegatee The address to delegate votes to
955      * @param nonce The contract state required to match the signature
956      * @param expiry The time at which to expire the signature
957      * @param v The recovery byte of the signature
958      * @param r Half of the ECDSA signature pair
959      * @param s Half of the ECDSA signature pair
960      */
961     function delegateBySig(
962         address delegatee,
963         uint nonce,
964         uint expiry,
965         uint8 v,
966         bytes32 r,
967         bytes32 s
968     )
969         external
970     {
971         bytes32 domainSeparator = keccak256(
972             abi.encode(
973                 DOMAIN_TYPEHASH,
974                 keccak256(bytes(name())),
975                 getChainId(),
976                 address(this)
977             )
978         );
979 
980         bytes32 structHash = keccak256(
981             abi.encode(
982                 DELEGATION_TYPEHASH,
983                 delegatee,
984                 nonce,
985                 expiry
986             )
987         );
988 
989         bytes32 digest = keccak256(
990             abi.encodePacked(
991                 "\x19\x01",
992                 domainSeparator,
993                 structHash
994             )
995         );
996 
997         address signatory = ecrecover(digest, v, r, s);
998         require(signatory != address(0), "BOOB::delegateBySig: invalid signature");
999         require(nonce == nonces[signatory]++, "BOOB::delegateBySig: invalid nonce");
1000         require(now <= expiry, "BOOB::delegateBySig: signature expired");
1001         return _delegate(signatory, delegatee);
1002     }
1003 
1004     /**
1005      * @notice Gets the current votes balance for `account`
1006      * @param account The address to get votes balance
1007      * @return The number of current votes for `account`
1008      */
1009     function getCurrentVotes(address account)
1010         external
1011         view
1012         returns (uint256)
1013     {
1014         uint32 nCheckpoints = numCheckpoints[account];
1015         return nCheckpoints > 0 ? checkpoints[account][nCheckpoints - 1].votes : 0;
1016     }
1017 
1018     /**
1019      * @notice Determine the prior number of votes for an account as of a block number
1020      * @dev Block number must be a finalized block or else this function will revert to prevent misinformation.
1021      * @param account The address of the account to check
1022      * @param blockNumber The block number to get the vote balance at
1023      * @return The number of votes the account had as of the given block
1024      */
1025     function getPriorVotes(address account, uint blockNumber)
1026         external
1027         view
1028         returns (uint256)
1029     {
1030         require(blockNumber < block.number, "BOOB::getPriorVotes: not yet determined");
1031 
1032         uint32 nCheckpoints = numCheckpoints[account];
1033         if (nCheckpoints == 0) {
1034             return 0;
1035         }
1036 
1037         // First check most recent balance
1038         if (checkpoints[account][nCheckpoints - 1].fromBlock <= blockNumber) {
1039             return checkpoints[account][nCheckpoints - 1].votes;
1040         }
1041 
1042         // Next check implicit zero balance
1043         if (checkpoints[account][0].fromBlock > blockNumber) {
1044             return 0;
1045         }
1046 
1047         uint32 lower = 0;
1048         uint32 upper = nCheckpoints - 1;
1049         while (upper > lower) {
1050             uint32 center = upper - (upper - lower) / 2; // ceil, avoiding overflow
1051             Checkpoint memory cp = checkpoints[account][center];
1052             if (cp.fromBlock == blockNumber) {
1053                 return cp.votes;
1054             } else if (cp.fromBlock < blockNumber) {
1055                 lower = center;
1056             } else {
1057                 upper = center - 1;
1058             }
1059         }
1060         return checkpoints[account][lower].votes;
1061     }
1062 
1063     function _delegate(address delegator, address delegatee)
1064         internal
1065     {
1066         address currentDelegate = _delegates[delegator];
1067         uint256 delegatorBalance = balanceOf(delegator); // balance of underlying BOOBs (not scaled);
1068         _delegates[delegator] = delegatee;
1069 
1070         emit DelegateChanged(delegator, currentDelegate, delegatee);
1071 
1072         _moveDelegates(currentDelegate, delegatee, delegatorBalance);
1073     }
1074 
1075     function _moveDelegates(address srcRep, address dstRep, uint256 amount) internal {
1076         if (srcRep != dstRep && amount > 0) {
1077             if (srcRep != address(0)) {
1078                 // decrease old representative
1079                 uint32 srcRepNum = numCheckpoints[srcRep];
1080                 uint256 srcRepOld = srcRepNum > 0 ? checkpoints[srcRep][srcRepNum - 1].votes : 0;
1081                 uint256 srcRepNew = srcRepOld.sub(amount);
1082                 _writeCheckpoint(srcRep, srcRepNum, srcRepOld, srcRepNew);
1083             }
1084 
1085             if (dstRep != address(0)) {
1086                 // increase new representative
1087                 uint32 dstRepNum = numCheckpoints[dstRep];
1088                 uint256 dstRepOld = dstRepNum > 0 ? checkpoints[dstRep][dstRepNum - 1].votes : 0;
1089                 uint256 dstRepNew = dstRepOld.add(amount);
1090                 _writeCheckpoint(dstRep, dstRepNum, dstRepOld, dstRepNew);
1091             }
1092         }
1093     }
1094 
1095     function _writeCheckpoint(
1096         address delegatee,
1097         uint32 nCheckpoints,
1098         uint256 oldVotes,
1099         uint256 newVotes
1100     )
1101         internal
1102     {
1103         uint32 blockNumber = safe32(block.number, "BOOB::_writeCheckpoint: block number exceeds 32 bits");
1104 
1105         if (nCheckpoints > 0 && checkpoints[delegatee][nCheckpoints - 1].fromBlock == blockNumber) {
1106             checkpoints[delegatee][nCheckpoints - 1].votes = newVotes;
1107         } else {
1108             checkpoints[delegatee][nCheckpoints] = Checkpoint(blockNumber, newVotes);
1109             numCheckpoints[delegatee] = nCheckpoints + 1;
1110         }
1111 
1112         emit DelegateVotesChanged(delegatee, oldVotes, newVotes);
1113     }
1114 
1115     function safe32(uint n, string memory errorMessage) internal pure returns (uint32) {
1116         require(n < 2**32, errorMessage);
1117         return uint32(n);
1118     }
1119 
1120     function getChainId() internal pure returns (uint) {
1121         uint256 chainId;
1122         assembly { chainId := chainid() }
1123         return chainId;
1124     }
1125 }