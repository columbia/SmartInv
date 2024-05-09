1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity =0.6.12;
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
764 interface IUniswapV2Router01 {
765     function factory() external pure returns (address);
766     function WETH() external pure returns (address);
767 
768     function addLiquidity(
769         address tokenA,
770         address tokenB,
771         uint amountADesired,
772         uint amountBDesired,
773         uint amountAMin,
774         uint amountBMin,
775         address to,
776         uint deadline
777     ) external returns (uint amountA, uint amountB, uint liquidity);
778     function addLiquidityETH(
779         address token,
780         uint amountTokenDesired,
781         uint amountTokenMin,
782         uint amountETHMin,
783         address to,
784         uint deadline
785     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
786     function removeLiquidity(
787         address tokenA,
788         address tokenB,
789         uint liquidity,
790         uint amountAMin,
791         uint amountBMin,
792         address to,
793         uint deadline
794     ) external returns (uint amountA, uint amountB);
795     function removeLiquidityETH(
796         address token,
797         uint liquidity,
798         uint amountTokenMin,
799         uint amountETHMin,
800         address to,
801         uint deadline
802     ) external returns (uint amountToken, uint amountETH);
803     function removeLiquidityWithPermit(
804         address tokenA,
805         address tokenB,
806         uint liquidity,
807         uint amountAMin,
808         uint amountBMin,
809         address to,
810         uint deadline,
811         bool approveMax, uint8 v, bytes32 r, bytes32 s
812     ) external returns (uint amountA, uint amountB);
813     function removeLiquidityETHWithPermit(
814         address token,
815         uint liquidity,
816         uint amountTokenMin,
817         uint amountETHMin,
818         address to,
819         uint deadline,
820         bool approveMax, uint8 v, bytes32 r, bytes32 s
821     ) external returns (uint amountToken, uint amountETH);
822     function swapExactTokensForTokens(
823         uint amountIn,
824         uint amountOutMin,
825         address[] calldata path,
826         address to,
827         uint deadline
828     ) external returns (uint[] memory amounts);
829     function swapTokensForExactTokens(
830         uint amountOut,
831         uint amountInMax,
832         address[] calldata path,
833         address to,
834         uint deadline
835     ) external returns (uint[] memory amounts);
836     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
837         external
838         payable
839         returns (uint[] memory amounts);
840     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
841         external
842         returns (uint[] memory amounts);
843     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
844         external
845         returns (uint[] memory amounts);
846     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
847         external
848         payable
849         returns (uint[] memory amounts);
850 
851     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
852     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
853     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
854     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
855     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
856 }
857 
858 interface IUniswapV2Router02 is IUniswapV2Router01 {
859     function removeLiquidityETHSupportingFeeOnTransferTokens(
860         address token,
861         uint liquidity,
862         uint amountTokenMin,
863         uint amountETHMin,
864         address to,
865         uint deadline
866     ) external returns (uint amountETH);
867     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
868         address token,
869         uint liquidity,
870         uint amountTokenMin,
871         uint amountETHMin,
872         address to,
873         uint deadline,
874         bool approveMax, uint8 v, bytes32 r, bytes32 s
875     ) external returns (uint amountETH);
876 
877     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
878         uint amountIn,
879         uint amountOutMin,
880         address[] calldata path,
881         address to,
882         uint deadline
883     ) external;
884     function swapExactETHForTokensSupportingFeeOnTransferTokens(
885         uint amountOutMin,
886         address[] calldata path,
887         address to,
888         uint deadline
889     ) external payable;
890     function swapExactTokensForETHSupportingFeeOnTransferTokens(
891         uint amountIn,
892         uint amountOutMin,
893         address[] calldata path,
894         address to,
895         uint deadline
896     ) external;
897 }
898 
899 interface IUniswapV2Factory {
900     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
901 
902     function feeTo() external view returns (address);
903     function feeToSetter() external view returns (address);
904 
905     function getPair(address tokenA, address tokenB) external view returns (address pair);
906     function allPairs(uint) external view returns (address pair);
907     function allPairsLength() external view returns (uint);
908 
909     function createPair(address tokenA, address tokenB) external returns (address pair);
910 
911     function setFeeTo(address) external;
912     function setFeeToSetter(address) external;
913 }
914 
915 // 
916 /**
917  * @dev Contract module which provides a basic access control mechanism, where
918  * there is an account (an admin) that can be granted exclusive access to
919  * specific functions.
920  *
921  * By default, the admin account will be the one that deploys the contract. This
922  * can later be changed with {transferAdmin}.
923  *
924  * This module is used through inheritance. It will make available the modifier
925  * `onlyAdmin`, which can be applied to your functions to restrict their use to
926  * the owner.
927  */
928 contract Administrable is Context {
929     address private _admin;
930 
931     event AdminTransferred(address indexed previousAdmin, address indexed newAdmin);
932 
933     /**
934      * @dev Initializes the contract setting the deployer as the initial admin.
935      */
936     constructor () internal {
937         address msgSender = _msgSender();
938         _admin = msgSender;
939         emit AdminTransferred(address(0), msgSender);
940     }
941 
942     /**
943      * @dev Returns the address of the current admin.
944      */
945     function admin() public view returns (address) {
946         return _admin;
947     }
948 
949     /**
950      * @dev Throws if called by any account other than the admin.
951      */
952     modifier onlyAdmin() {
953         require(_admin == _msgSender(), "Administrable: caller is not the admin");
954         _;
955     }
956 
957     /**
958      * @dev Leaves the contract without admin. It will not be possible to call
959      * `onlyAdmin` functions anymore. Can only be called by the current admin.
960      *
961      * NOTE: Renouncing admin will leave the contract without an admin,
962      * thereby removing any functionality that is only available to the admin.
963      */
964     function renounceAdmin() public virtual onlyAdmin {
965         emit AdminTransferred(_admin, address(0));
966         _admin = address(0);
967     }
968 
969     /**
970      * @dev Transfers admin of the contract to a new account (`newAdmin`).
971      * Can only be called by the current ad,om.
972      */
973     function transferAdmin(address newAdmin) public virtual onlyAdmin {
974         require(newAdmin != address(0), "Administrable: new admin is the zero address");
975         emit AdminTransferred(_admin, newAdmin);
976         _admin = newAdmin;
977     }
978 }
979 
980 // 
981 abstract contract ERC20Payable {
982 
983     event Received(address indexed sender, uint256 amount);
984 
985     receive() external payable {
986         emit Received(msg.sender, msg.value);
987     }
988 }
989 
990 // 
991 interface IProtocolAdapter {
992     // Gets adapted burn divisor
993     function getBurnDivisor(address _user, uint256 _currentBurnDivisor) external view returns (uint256);
994 
995     // Gets adapted farm rewards multiplier
996     function getRewardsMultiplier(address _user, uint256 _currentRewardsMultiplier) external view returns (uint256);
997 }
998 
999 // 
1000 /**
1001  * @dev Extension of {ERC20} that allows token holders to destroy both their own
1002  * tokens and those that they have an allowance for, in a way that can be
1003  * recognized off-chain (via event analysis).
1004  */
1005 abstract contract ERC20Burnable is Context, ERC20 {
1006     /**
1007      * @dev Destroys `amount` tokens from the caller. CANNOT BE USED TO BURN OTHER PEOPLES TOKENS
1008      * ONLY BBRA AND ONLY FROM THE PERSON CALLING THE FUNCTION
1009      *
1010      * See {ERC20-_burn}.
1011      */
1012     function burn(uint256 amount) public virtual {
1013         _burn(_msgSender(), amount);
1014     }
1015 }
1016 
1017 // 
1018 // Boo with Governance.
1019 // Ownership given to Farming contract and Adminship can be given to DAO contract
1020 contract Gr1m is ERC20("Gr1m", "GR1M"), ERC20Burnable, Ownable, Administrable, ERC20Payable {
1021     using SafeMath for uint256;
1022 
1023     // uniswap info
1024     address public uniswapV2Router;
1025     address public uniswapV2Pair;
1026     address public uniswapV2Factory;
1027 
1028     // the amount burned tokens every transfer, i.e. 255 = 0.4%, 100 = 1%, 50 = 2%, 40 = 2.5%
1029     uint256 public burnDivisor;
1030     // the amount tokens saved for liquidity lock every transfer, i.e. 255 = 0.4%, 100 = 1%, 50 = 2%, 40 = 2.5%
1031     uint256 public liquidityDivisor;
1032 
1033     // Dynamic burn regulator (less burn with a certain number of nfts etc)
1034     IProtocolAdapter public protocolAdapter;
1035 
1036     // Timestamp of last liquidity lock call
1037     uint256 public lastLiquidityLock;
1038 
1039     // 1% of all transfers are sent to dev fund
1040     address public _devaddr;
1041 
1042     // 1% of all transfers are sent to marketing fund
1043     address public _marketingaddr;
1044 
1045     constructor() public {
1046         burnDivisor = 50;
1047         liquidityDivisor = 50;
1048         _marketingaddr = msg.sender;
1049         _devaddr = 0x29807F6f06ec2a7AD56ed1a6dB3C3648D4d88634;
1050 //        _mint(msg.sender, 1e23);
1051         // uniswapV2Factory = 0x5C69bEe701ef814a2B6a3EDD4B1652CB9cc5aA6f
1052         // uniswapV2Router = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D
1053     }
1054 
1055     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
1056         uint256 onePct = amount.div(100);
1057         uint256 liquidityAmount = amount.div(liquidityDivisor);
1058         // Use dynamic burn divisor if Adapter contract is set
1059         uint256 burnAmount = amount.div(
1060             ( address(protocolAdapter) != address(0)
1061                 ? protocolAdapter.getBurnDivisor(pickHuman(sender, recipient), burnDivisor)
1062                 : burnDivisor
1063             )
1064         );
1065 
1066         _burn(sender, burnAmount);
1067 
1068 
1069         if (_devaddr != address(0)) {
1070             super.transferFrom(sender, _devaddr, onePct);
1071         }
1072 
1073         super.transferFrom(sender, _marketingaddr, onePct);
1074         super.transferFrom(sender, address(this), liquidityAmount);
1075         return super.transferFrom(sender, recipient, amount.sub(burnAmount).sub(liquidityAmount).sub(onePct).sub(onePct));
1076     }
1077 
1078     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
1079         uint256 onePct = amount.div(100);
1080         uint256 liquidityAmount = amount.div(liquidityDivisor);
1081         // Use dynamic burn divisor if Adapter contract is set
1082         uint256 burnAmount = amount.div(
1083             ( address(protocolAdapter) != address(0)
1084                 ? protocolAdapter.getBurnDivisor(pickHuman(msg.sender, recipient), burnDivisor)
1085                 : burnDivisor
1086             )
1087         );
1088 
1089         // do nft adapter
1090         _burn(msg.sender, burnAmount);
1091 
1092         if (_devaddr != address(0)) {
1093             super.transfer(_devaddr, onePct);
1094         }
1095         super.transfer(_marketingaddr, onePct);
1096         super.transfer(address(this), liquidityAmount);
1097         return super.transfer(recipient, amount.sub(burnAmount).sub(liquidityAmount).sub(onePct).sub(onePct));
1098     }
1099 
1100     // Check if _from is human when calculating ProtocolAdapter settings (like burn)
1101     // so that if you're buying from Uniswap the adjusted burn still works
1102     function pickHuman(address _from, address _to) public view returns (address) {
1103         uint256 _codeLength;
1104         assembly {_codeLength := extcodesize(_from)}
1105         return _codeLength == 0 ? _from : _to;
1106     }
1107 
1108     /**
1109      * @dev Throws if called by any account other than the admin or owner.
1110      */
1111     modifier onlyAdminOrOwner() {
1112         require(admin() == _msgSender() || owner() == _msgSender(), "Ownable: caller is not the admin");
1113         _;
1114     }
1115 
1116     /**
1117      * @dev Throws if called by any account other than the admin or owner.
1118      */
1119     modifier onlyDev() {
1120         require(_devaddr == _msgSender(), "Ownable: caller is not the admin");
1121         _;
1122     }
1123 
1124 
1125     /**
1126      * @dev prevents contracts from interacting with functions that have this modifier
1127      */
1128     modifier isHuman() {
1129         address _addr = msg.sender;
1130         uint256 _codeLength;
1131 
1132         assembly {_codeLength := extcodesize(_addr)}
1133 
1134 //        if (_codeLength == 0) {
1135 //            // use assert to consume all of the bots gas, kek
1136 //            assert(true == false, 'oh boy - bots get rekt');
1137 //        }
1138         require(_codeLength == 0, "sorry humans only");
1139         _;
1140     }
1141 
1142     // Sell half of burned tokens, provides liquidity and locks it away forever
1143     // can only be called when balance is > 1 and last lock is more than 2 hours ago
1144     function lockLiquidity() public isHuman() {
1145         // bbra balance
1146         uint256 _bal = balanceOf(address(this));
1147         require(uniswapV2Pair != address(0), "UniswapV2Pair not set in contract yet");
1148         require(uniswapV2Router != address(0), "UniswapV2Router not set in contract yet");
1149         require(_bal >= 1e18, "Minimum of 1 GR1M before we can lock liquidity");
1150 
1151         // caller rewards
1152         uint256 _callerReward = 0;
1153 
1154         // subtract caller fee - 2% always
1155         _callerReward = _bal.div(50);
1156         _bal = _bal.sub(_callerReward);
1157 
1158 
1159         // calculate ratios of bbra-eth for lp
1160         uint256 bbraToEth = _bal.div(2);
1161         uint256 brraForLiq = _bal.sub(bbraToEth);
1162 
1163         // Eth Balance before swap
1164         uint256 startingBalance = address(this).balance;
1165         swapTokensForWeth(bbraToEth);
1166 
1167         // due to price movements after selling it is likely that less than the amount of
1168         // eth received will be used for locking
1169         // instead of making the left over eth locked away forever we can call buyAndBurn() to buy back Bbra with leftover Eth
1170         uint256 ethFromBbra = address(this).balance.sub(startingBalance);
1171         addLiquidity(brraForLiq, ethFromBbra);
1172 
1173         // only reward caller after trade to prevent any possible reentrancy
1174         // check balance is still available
1175         if (_callerReward != 0) {
1176             // in case LP takes more tokens than we are expecting reward _callerReward or balanceOf(this) - whichever is smallest
1177             if(balanceOf(address(this)) >= _callerReward) {
1178                 super.transferFrom(address(this), msg.sender, _callerReward);
1179             } else {
1180                 super.transferFrom(address(this), msg.sender, balanceOf(address(this)));
1181             }
1182         }
1183 
1184         lastLiquidityLock = block.timestamp;
1185     }
1186 
1187     // swaps bra for eth - only called by liquidity lock function
1188     function swapTokensForWeth(uint256 tokenAmount) internal {
1189         address[] memory uniswapPairPath = new address[](2);
1190         uniswapPairPath[0] = address(this);
1191         uniswapPairPath[1] = IUniswapV2Router02(uniswapV2Router).WETH();
1192 
1193         _approve(address(this), uniswapV2Router, tokenAmount);
1194 
1195         IUniswapV2Router02(uniswapV2Router)
1196         .swapExactTokensForETHSupportingFeeOnTransferTokens(
1197             tokenAmount,
1198             0,
1199             uniswapPairPath,
1200             address(this),
1201             block.timestamp
1202         );
1203     }
1204 
1205     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) internal {
1206         // approve uniswapV2Router to transfer Brra
1207         _approve(address(this), uniswapV2Router, tokenAmount);
1208 
1209         // provide liquidity
1210         IUniswapV2Router02(uniswapV2Router)
1211         .addLiquidityETH{
1212             value: ethAmount
1213         }(
1214             address(this),
1215             tokenAmount,
1216             0,
1217             0,
1218             address(this),
1219             block.timestamp
1220         );
1221 
1222         // check LP balance
1223         uint256 _lpBalance = IERC20(uniswapV2Pair).balanceOf(address(this));
1224         if (_lpBalance != 0) {
1225             // transfer LP to burn address (aka locked forever)
1226             IERC20(uniswapV2Pair).transfer(address(0), _lpBalance);
1227             // any left over eth is sent to marketing for buy backs - will be a very minimal amount
1228             payable(_marketingaddr).transfer(address(this).balance);
1229         }
1230     }
1231 
1232     // returns amount of LP locked permanently
1233     function lockedLpAmount() public view returns(uint256) {
1234         if (uniswapV2Pair == address(0)) {
1235             return 0;
1236         }
1237 
1238         return IERC20(uniswapV2Pair).balanceOf(address(0));
1239     }
1240 
1241     // Sets contract that regulates dynamic burn rates (changeable by DAO)
1242     function setProtocolAdapter(IProtocolAdapter _contract) public onlyAdminOrOwner {
1243         // setting to 0x0 disabled dynamic burn and is defaulted to regular burn
1244         protocolAdapter = _contract;
1245     }
1246 
1247     // self explanatory
1248     function setBurnRate(uint256 _burnDivisor) public onlyAdminOrOwner {
1249         require(_burnDivisor != 0, "Boo: burnDivisor must be bigger than 0");
1250         burnDivisor = _burnDivisor;
1251     }
1252 
1253     // self explanatory
1254     function setLiquidityDivisor(uint256 _liquidityDivisor) public onlyAdminOrOwner {
1255         require(_liquidityDivisor != 0, "Boo: _liquidityDivisor must be bigger than 0");
1256         liquidityDivisor = _liquidityDivisor;
1257     }
1258 
1259     /// @dev Creates `_amount` token to `_to`. Must only be called by the owner (MrBanker), used to mint farming rewards
1260     // and nothing else
1261     function mint(address _to, uint256 _amount) public onlyOwner {
1262         _mint(_to, _amount);
1263     }
1264 
1265     // removes dev fee of 1% (irreversible)
1266     function unsetDevAddr() public onlyDev {
1267         _devaddr = address(0);
1268     }
1269 
1270     // Sets marketing address (where 1% is deposited)
1271     // Only owner can modify this (MrBanker)
1272     function setMarketingAddr(address _mark) public onlyAdminOrOwner {
1273         _marketingaddr = _mark;
1274     }
1275 
1276     // sets uniswap router and LP pair addresses (needed for buy-back/sell and liquidity lock)
1277     function setUniswapAddresses(address _uniswapV2Factory, address _uniswapV2Router) public onlyAdminOrOwner {
1278         require(_uniswapV2Factory != address(0) && _uniswapV2Router != address(0), 'Uniswap addresses cannot be empty');
1279         uniswapV2Factory = _uniswapV2Factory;
1280         uniswapV2Router = _uniswapV2Router;
1281 
1282         if (uniswapV2Pair == address(0)) {
1283             createUniswapPair();
1284         }
1285     }
1286 
1287     // create LP pair if one hasn't been created
1288     // can be public, doesn't matter who calls it
1289     function createUniswapPair() public {
1290         require(uniswapV2Pair == address(0), "Pair has already been created");
1291         require(uniswapV2Factory != address(0) && uniswapV2Router != address(0), "Uniswap addresses have not been set");
1292 
1293         uniswapV2Pair = IUniswapV2Factory(uniswapV2Factory).createPair(
1294                 IUniswapV2Router02(uniswapV2Router).WETH(),
1295                 address(this)
1296         );
1297     }
1298 }