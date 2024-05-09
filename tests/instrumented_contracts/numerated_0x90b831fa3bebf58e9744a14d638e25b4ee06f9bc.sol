1 // SPDX-License-Identifier: MIT
2 
3 pragma experimental ABIEncoderV2;
4 pragma solidity 0.6.12;
5 
6 
7 // 
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
29 // 
30 /**
31  * @dev Interface of the ERC20 standard as defined in the EIP.
32  */
33 interface IERC20 {
34     /**
35      * @dev Returns the amount of tokens in existence.
36      */
37     function totalSupply() external view returns (uint256);
38 
39     /**
40      * @dev Returns the amount of tokens owned by `account`.
41      */
42     function balanceOf(address account) external view returns (uint256);
43 
44     /**
45      * @dev Moves `amount` tokens from the caller's account to `recipient`.
46      *
47      * Returns a boolean value indicating whether the operation succeeded.
48      *
49      * Emits a {Transfer} event.
50      */
51     function transfer(address recipient, uint256 amount) external returns (bool);
52 
53     /**
54      * @dev Returns the remaining number of tokens that `spender` will be
55      * allowed to spend on behalf of `owner` through {transferFrom}. This is
56      * zero by default.
57      *
58      * This value changes when {approve} or {transferFrom} are called.
59      */
60     function allowance(address owner, address spender) external view returns (uint256);
61 
62     /**
63      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
64      *
65      * Returns a boolean value indicating whether the operation succeeded.
66      *
67      * IMPORTANT: Beware that changing an allowance with this method brings the risk
68      * that someone may use both the old and the new allowance by unfortunate
69      * transaction ordering. One possible solution to mitigate this race
70      * condition is to first reduce the spender's allowance to 0 and set the
71      * desired value afterwards:
72      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
73      *
74      * Emits an {Approval} event.
75      */
76     function approve(address spender, uint256 amount) external returns (bool);
77 
78     /**
79      * @dev Moves `amount` tokens from `sender` to `recipient` using the
80      * allowance mechanism. `amount` is then deducted from the caller's
81      * allowance.
82      *
83      * Returns a boolean value indicating whether the operation succeeded.
84      *
85      * Emits a {Transfer} event.
86      */
87     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
88 
89     /**
90      * @dev Emitted when `value` tokens are moved from one account (`from`) to
91      * another (`to`).
92      *
93      * Note that `value` may be zero.
94      */
95     event Transfer(address indexed from, address indexed to, uint256 value);
96 
97     /**
98      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
99      * a call to {approve}. `value` is the new allowance.
100      */
101     event Approval(address indexed owner, address indexed spender, uint256 value);
102 }
103 
104 // 
105 /**
106  * @dev Wrappers over Solidity's arithmetic operations with added overflow
107  * checks.
108  *
109  * Arithmetic operations in Solidity wrap on overflow. This can easily result
110  * in bugs, because programmers usually assume that an overflow raises an
111  * error, which is the standard behavior in high level programming languages.
112  * `SafeMath` restores this intuition by reverting the transaction when an
113  * operation overflows.
114  *
115  * Using this library instead of the unchecked operations eliminates an entire
116  * class of bugs, so it's recommended to use it always.
117  */
118 library SafeMath {
119     /**
120      * @dev Returns the addition of two unsigned integers, reverting on
121      * overflow.
122      *
123      * Counterpart to Solidity's `+` operator.
124      *
125      * Requirements:
126      *
127      * - Addition cannot overflow.
128      */
129     function add(uint256 a, uint256 b) internal pure returns (uint256) {
130         uint256 c = a + b;
131         require(c >= a, "SafeMath: addition overflow");
132 
133         return c;
134     }
135 
136     /**
137      * @dev Returns the subtraction of two unsigned integers, reverting on
138      * overflow (when the result is negative).
139      *
140      * Counterpart to Solidity's `-` operator.
141      *
142      * Requirements:
143      *
144      * - Subtraction cannot overflow.
145      */
146     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
147         return sub(a, b, "SafeMath: subtraction overflow");
148     }
149 
150     /**
151      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
152      * overflow (when the result is negative).
153      *
154      * Counterpart to Solidity's `-` operator.
155      *
156      * Requirements:
157      *
158      * - Subtraction cannot overflow.
159      */
160     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
161         require(b <= a, errorMessage);
162         uint256 c = a - b;
163 
164         return c;
165     }
166 
167     /**
168      * @dev Returns the multiplication of two unsigned integers, reverting on
169      * overflow.
170      *
171      * Counterpart to Solidity's `*` operator.
172      *
173      * Requirements:
174      *
175      * - Multiplication cannot overflow.
176      */
177     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
178         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
179         // benefit is lost if 'b' is also tested.
180         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
181         if (a == 0) {
182             return 0;
183         }
184 
185         uint256 c = a * b;
186         require(c / a == b, "SafeMath: multiplication overflow");
187 
188         return c;
189     }
190 
191     /**
192      * @dev Returns the integer division of two unsigned integers. Reverts on
193      * division by zero. The result is rounded towards zero.
194      *
195      * Counterpart to Solidity's `/` operator. Note: this function uses a
196      * `revert` opcode (which leaves remaining gas untouched) while Solidity
197      * uses an invalid opcode to revert (consuming all remaining gas).
198      *
199      * Requirements:
200      *
201      * - The divisor cannot be zero.
202      */
203     function div(uint256 a, uint256 b) internal pure returns (uint256) {
204         return div(a, b, "SafeMath: division by zero");
205     }
206 
207     /**
208      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
209      * division by zero. The result is rounded towards zero.
210      *
211      * Counterpart to Solidity's `/` operator. Note: this function uses a
212      * `revert` opcode (which leaves remaining gas untouched) while Solidity
213      * uses an invalid opcode to revert (consuming all remaining gas).
214      *
215      * Requirements:
216      *
217      * - The divisor cannot be zero.
218      */
219     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
220         require(b > 0, errorMessage);
221         uint256 c = a / b;
222         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
223 
224         return c;
225     }
226 
227     /**
228      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
229      * Reverts when dividing by zero.
230      *
231      * Counterpart to Solidity's `%` operator. This function uses a `revert`
232      * opcode (which leaves remaining gas untouched) while Solidity uses an
233      * invalid opcode to revert (consuming all remaining gas).
234      *
235      * Requirements:
236      *
237      * - The divisor cannot be zero.
238      */
239     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
240         return mod(a, b, "SafeMath: modulo by zero");
241     }
242 
243     /**
244      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
245      * Reverts with custom message when dividing by zero.
246      *
247      * Counterpart to Solidity's `%` operator. This function uses a `revert`
248      * opcode (which leaves remaining gas untouched) while Solidity uses an
249      * invalid opcode to revert (consuming all remaining gas).
250      *
251      * Requirements:
252      *
253      * - The divisor cannot be zero.
254      */
255     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
256         require(b != 0, errorMessage);
257         return a % b;
258     }
259 }
260 
261 // 
262 /**
263  * @dev Collection of functions related to the address type
264  */
265 library Address {
266     /**
267      * @dev Returns true if `account` is a contract.
268      *
269      * [IMPORTANT]
270      * ====
271      * It is unsafe to assume that an address for which this function returns
272      * false is an externally-owned account (EOA) and not a contract.
273      *
274      * Among others, `isContract` will return false for the following
275      * types of addresses:
276      *
277      *  - an externally-owned account
278      *  - a contract in construction
279      *  - an address where a contract will be created
280      *  - an address where a contract lived, but was destroyed
281      * ====
282      */
283     function isContract(address account) internal view returns (bool) {
284         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
285         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
286         // for accounts without code, i.e. `keccak256('')`
287         bytes32 codehash;
288         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
289         // solhint-disable-next-line no-inline-assembly
290         assembly { codehash := extcodehash(account) }
291         return (codehash != accountHash && codehash != 0x0);
292     }
293 
294     /**
295      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
296      * `recipient`, forwarding all available gas and reverting on errors.
297      *
298      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
299      * of certain opcodes, possibly making contracts go over the 2300 gas limit
300      * imposed by `transfer`, making them unable to receive funds via
301      * `transfer`. {sendValue} removes this limitation.
302      *
303      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
304      *
305      * IMPORTANT: because control is transferred to `recipient`, care must be
306      * taken to not create reentrancy vulnerabilities. Consider using
307      * {ReentrancyGuard} or the
308      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
309      */
310     function sendValue(address payable recipient, uint256 amount) internal {
311         require(address(this).balance >= amount, "Address: insufficient balance");
312 
313         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
314         (bool success, ) = recipient.call{ value: amount }("");
315         require(success, "Address: unable to send value, recipient may have reverted");
316     }
317 
318     /**
319      * @dev Performs a Solidity function call using a low level `call`. A
320      * plain`call` is an unsafe replacement for a function call: use this
321      * function instead.
322      *
323      * If `target` reverts with a revert reason, it is bubbled up by this
324      * function (like regular Solidity function calls).
325      *
326      * Returns the raw returned data. To convert to the expected return value,
327      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
328      *
329      * Requirements:
330      *
331      * - `target` must be a contract.
332      * - calling `target` with `data` must not revert.
333      *
334      * _Available since v3.1._
335      */
336     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
337       return functionCall(target, data, "Address: low-level call failed");
338     }
339 
340     /**
341      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
342      * `errorMessage` as a fallback revert reason when `target` reverts.
343      *
344      * _Available since v3.1._
345      */
346     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
347         return _functionCallWithValue(target, data, 0, errorMessage);
348     }
349 
350     /**
351      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
352      * but also transferring `value` wei to `target`.
353      *
354      * Requirements:
355      *
356      * - the calling contract must have an ETH balance of at least `value`.
357      * - the called Solidity function must be `payable`.
358      *
359      * _Available since v3.1._
360      */
361     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
362         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
363     }
364 
365     /**
366      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
367      * with `errorMessage` as a fallback revert reason when `target` reverts.
368      *
369      * _Available since v3.1._
370      */
371     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
372         require(address(this).balance >= value, "Address: insufficient balance for call");
373         return _functionCallWithValue(target, data, value, errorMessage);
374     }
375 
376     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
377         require(isContract(target), "Address: call to non-contract");
378 
379         // solhint-disable-next-line avoid-low-level-calls
380         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
381         if (success) {
382             return returndata;
383         } else {
384             // Look for revert reason and bubble it up if present
385             if (returndata.length > 0) {
386                 // The easiest way to bubble the revert reason is using memory via assembly
387 
388                 // solhint-disable-next-line no-inline-assembly
389                 assembly {
390                     let returndata_size := mload(returndata)
391                     revert(add(32, returndata), returndata_size)
392                 }
393             } else {
394                 revert(errorMessage);
395             }
396         }
397     }
398 }
399 
400 // 
401 /**
402  * @dev Implementation of the {IERC20} interface.
403  *
404  * This implementation is agnostic to the way tokens are created. This means
405  * that a supply mechanism has to be added in a derived contract using {_mint}.
406  * For a generic mechanism see {ERC20PresetMinterPauser}.
407  *
408  * TIP: For a detailed writeup see our guide
409  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
410  * to implement supply mechanisms].
411  *
412  * We have followed general OpenZeppelin guidelines: functions revert instead
413  * of returning `false` on failure. This behavior is nonetheless conventional
414  * and does not conflict with the expectations of ERC20 applications.
415  *
416  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
417  * This allows applications to reconstruct the allowance for all accounts just
418  * by listening to said events. Other implementations of the EIP may not emit
419  * these events, as it isn't required by the specification.
420  *
421  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
422  * functions have been added to mitigate the well-known issues around setting
423  * allowances. See {IERC20-approve}.
424  */
425 contract ERC20 is Context, IERC20 {
426     using SafeMath for uint256;
427     using Address for address;
428 
429     mapping (address => uint256) private _balances;
430 
431     mapping (address => mapping (address => uint256)) private _allowances;
432 
433     uint256 private _totalSupply;
434 
435     string private _name;
436     string private _symbol;
437     uint8 private _decimals;
438 
439     /**
440      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
441      * a default value of 18.
442      *
443      * To select a different value for {decimals}, use {_setupDecimals}.
444      *
445      * All three of these values are immutable: they can only be set once during
446      * construction.
447      */
448     constructor (string memory name, string memory symbol) public {
449         _name = name;
450         _symbol = symbol;
451         _decimals = 18;
452     }
453 
454     /**
455      * @dev Returns the name of the token.
456      */
457     function name() public view returns (string memory) {
458         return _name;
459     }
460 
461     /**
462      * @dev Returns the symbol of the token, usually a shorter version of the
463      * name.
464      */
465     function symbol() public view returns (string memory) {
466         return _symbol;
467     }
468 
469     /**
470      * @dev Returns the number of decimals used to get its user representation.
471      * For example, if `decimals` equals `2`, a balance of `505` tokens should
472      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
473      *
474      * Tokens usually opt for a value of 18, imitating the relationship between
475      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
476      * called.
477      *
478      * NOTE: This information is only used for _display_ purposes: it in
479      * no way affects any of the arithmetic of the contract, including
480      * {IERC20-balanceOf} and {IERC20-transfer}.
481      */
482     function decimals() public view returns (uint8) {
483         return _decimals;
484     }
485 
486     /**
487      * @dev See {IERC20-totalSupply}.
488      */
489     function totalSupply() public view override returns (uint256) {
490         return _totalSupply;
491     }
492 
493     /**
494      * @dev See {IERC20-balanceOf}.
495      */
496     function balanceOf(address account) public view override returns (uint256) {
497         return _balances[account];
498     }
499 
500     /**
501      * @dev See {IERC20-transfer}.
502      *
503      * Requirements:
504      *
505      * - `recipient` cannot be the zero address.
506      * - the caller must have a balance of at least `amount`.
507      */
508     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
509         _transfer(_msgSender(), recipient, amount);
510         return true;
511     }
512 
513     /**
514      * @dev See {IERC20-allowance}.
515      */
516     function allowance(address owner, address spender) public view virtual override returns (uint256) {
517         return _allowances[owner][spender];
518     }
519 
520     /**
521      * @dev See {IERC20-approve}.
522      *
523      * Requirements:
524      *
525      * - `spender` cannot be the zero address.
526      */
527     function approve(address spender, uint256 amount) public virtual override returns (bool) {
528         _approve(_msgSender(), spender, amount);
529         return true;
530     }
531 
532     /**
533      * @dev See {IERC20-transferFrom}.
534      *
535      * Emits an {Approval} event indicating the updated allowance. This is not
536      * required by the EIP. See the note at the beginning of {ERC20};
537      *
538      * Requirements:
539      * - `sender` and `recipient` cannot be the zero address.
540      * - `sender` must have a balance of at least `amount`.
541      * - the caller must have allowance for ``sender``'s tokens of at least
542      * `amount`.
543      */
544     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
545         _transfer(sender, recipient, amount);
546         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
547         return true;
548     }
549 
550     /**
551      * @dev Atomically increases the allowance granted to `spender` by the caller.
552      *
553      * This is an alternative to {approve} that can be used as a mitigation for
554      * problems described in {IERC20-approve}.
555      *
556      * Emits an {Approval} event indicating the updated allowance.
557      *
558      * Requirements:
559      *
560      * - `spender` cannot be the zero address.
561      */
562     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
563         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
564         return true;
565     }
566 
567     /**
568      * @dev Atomically decreases the allowance granted to `spender` by the caller.
569      *
570      * This is an alternative to {approve} that can be used as a mitigation for
571      * problems described in {IERC20-approve}.
572      *
573      * Emits an {Approval} event indicating the updated allowance.
574      *
575      * Requirements:
576      *
577      * - `spender` cannot be the zero address.
578      * - `spender` must have allowance for the caller of at least
579      * `subtractedValue`.
580      */
581     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
582         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
583         return true;
584     }
585 
586     /**
587      * @dev Moves tokens `amount` from `sender` to `recipient`.
588      *
589      * This is internal function is equivalent to {transfer}, and can be used to
590      * e.g. implement automatic token fees, slashing mechanisms, etc.
591      *
592      * Emits a {Transfer} event.
593      *
594      * Requirements:
595      *
596      * - `sender` cannot be the zero address.
597      * - `recipient` cannot be the zero address.
598      * - `sender` must have a balance of at least `amount`.
599      */
600     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
601         require(sender != address(0), "ERC20: transfer from the zero address");
602         require(recipient != address(0), "ERC20: transfer to the zero address");
603 
604         _beforeTokenTransfer(sender, recipient, amount);
605 
606         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
607         _balances[recipient] = _balances[recipient].add(amount);
608         emit Transfer(sender, recipient, amount);
609     }
610 
611     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
612      * the total supply.
613      *
614      * Emits a {Transfer} event with `from` set to the zero address.
615      *
616      * Requirements
617      *
618      * - `to` cannot be the zero address.
619      */
620     function _mint(address account, uint256 amount) internal virtual {
621         require(account != address(0), "ERC20: mint to the zero address");
622 
623         _beforeTokenTransfer(address(0), account, amount);
624 
625         _totalSupply = _totalSupply.add(amount);
626         _balances[account] = _balances[account].add(amount);
627         emit Transfer(address(0), account, amount);
628     }
629 
630     /**
631      * @dev Destroys `amount` tokens from `account`, reducing the
632      * total supply.
633      *
634      * Emits a {Transfer} event with `to` set to the zero address.
635      *
636      * Requirements
637      *
638      * - `account` cannot be the zero address.
639      * - `account` must have at least `amount` tokens.
640      */
641     function _burn(address account, uint256 amount) internal virtual {
642         require(account != address(0), "ERC20: burn from the zero address");
643 
644         _beforeTokenTransfer(account, address(0), amount);
645 
646         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
647         _totalSupply = _totalSupply.sub(amount);
648         emit Transfer(account, address(0), amount);
649     }
650 
651     /**
652      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
653      *
654      * This is internal function is equivalent to `approve`, and can be used to
655      * e.g. set automatic allowances for certain subsystems, etc.
656      *
657      * Emits an {Approval} event.
658      *
659      * Requirements:
660      *
661      * - `owner` cannot be the zero address.
662      * - `spender` cannot be the zero address.
663      */
664     function _approve(address owner, address spender, uint256 amount) internal virtual {
665         require(owner != address(0), "ERC20: approve from the zero address");
666         require(spender != address(0), "ERC20: approve to the zero address");
667 
668         _allowances[owner][spender] = amount;
669         emit Approval(owner, spender, amount);
670     }
671 
672     /**
673      * @dev Sets {decimals} to a value other than the default one of 18.
674      *
675      * WARNING: This function should only be called from the constructor. Most
676      * applications that interact with token contracts will not expect
677      * {decimals} to ever change, and may work incorrectly if it does.
678      */
679     function _setupDecimals(uint8 decimals_) internal {
680         _decimals = decimals_;
681     }
682 
683     /**
684      * @dev Hook that is called before any transfer of tokens. This includes
685      * minting and burning.
686      *
687      * Calling conditions:
688      *
689      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
690      * will be to transferred to `to`.
691      * - when `from` is zero, `amount` tokens will be minted for `to`.
692      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
693      * - `from` and `to` are never both zero.
694      *
695      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
696      */
697     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
698 }
699 
700 // 
701 interface IGovernorAlpha {
702     /// @notice Possible states that a proposal may be in
703     enum ProposalState {
704         Active,
705         Canceled,
706         Defeated,
707         Succeeded,
708         Queued,
709         Expired,
710         Executed
711     }
712 
713     struct Proposal {
714         // Unique id for looking up a proposal
715         uint256 id;
716 
717         // Creator of the proposal
718         address proposer;
719 
720         // The timestamp that the proposal will be available for execution, set once the vote succeeds
721         uint256 eta;
722 
723         // the ordered list of target addresses for calls to be made
724         address[] targets;
725 
726         // The ordered list of values (i.e. msg.value) to be passed to the calls to be made
727         uint256[] values;
728 
729         // The ordered list of function signatures to be called
730         string[] signatures;
731 
732         // The ordered list of calldata to be passed to each call
733         bytes[] calldatas;
734 
735         // The timestamp at which voting begins: holders must delegate their votes prior to this timestamp
736         uint256 startTime;
737 
738         // The timestamp at which voting ends: votes must be cast prior to this timestamp
739         uint endTime;
740 
741         // Current number of votes in favor of this proposal
742         uint256 forVotes;
743 
744         // Current number of votes in opposition to this proposal
745         uint256 againstVotes;
746 
747         // Flag marking whether the proposal has been canceled
748         bool canceled;
749 
750         // Flag marking whether the proposal has been executed
751         bool executed;
752 
753         // Receipts of ballots for the entire set of voters
754         mapping (address => Receipt) receipts;
755     }
756 
757     /// @notice Ballot receipt record for a voter
758     struct Receipt {
759         // Whether or not a vote has been cast
760         bool hasVoted;
761 
762         // Whether or not the voter supports the proposal
763         bool support;
764 
765         // The number of votes the voter had, which were cast
766         uint votes;
767     }
768 
769     /// @notice An event emitted when a new proposal is created
770     event ProposalCreated(uint256 id, address proposer, address[] targets, uint256[] values, string[] signatures, bytes[] calldatas, uint startTime, uint endTime, string description);
771 
772     /// @notice An event emitted when a vote has been cast on a proposal
773     event VoteCast(address voter, uint256 proposalId, bool support, uint256 votes);
774 
775     /// @notice An event emitted when a proposal has been canceled
776     event ProposalCanceled(uint256 id);
777 
778     /// @notice An event emitted when a proposal has been queued in the Timelock
779     event ProposalQueued(uint256 id, uint256 eta);
780 
781     /// @notice An event emitted when a proposal has been executed in the Timelock
782     event ProposalExecuted(uint256 id);
783 
784     function propose(address[] memory targets, uint256[] memory values, string[] memory signatures, bytes[] memory calldatas, string memory description, uint256 endTime) external returns (uint);
785 
786     function queue(uint256 proposalId) external;
787 
788     function execute(uint256 proposalId) external payable;
789 
790     function cancel(uint256 proposalId) external;
791 
792     function castVote(uint256 proposalId, bool support) external;
793 
794     function getActions(uint256 proposalId) external view returns (address[] memory targets, uint256[] memory values, string[] memory signatures, bytes[] memory calldatas);
795 
796     function getReceipt(uint256 proposalId, address voter) external view returns (Receipt memory);
797 
798     function state(uint proposalId) external view returns (ProposalState);
799 
800     function quorumVotes() external view returns (uint256);
801 
802     function proposalThreshold() external view returns (uint256);
803 }
804 
805 // 
806 interface ITimelock {
807   event NewAdmin(address indexed newAdmin);
808   event NewPendingAdmin(address indexed newPendingAdmin);
809   event NewDelay(uint256 indexed newDelay);
810   event CancelTransaction(
811     bytes32 indexed txHash,
812     address indexed target,
813     uint256 value,
814     string signature,
815     bytes data,
816     uint256 eta
817   );
818   event ExecuteTransaction(
819     bytes32 indexed txHash,
820     address indexed target,
821     uint256 value,
822     string signature,
823     bytes data,
824     uint256 eta
825   );
826   event QueueTransaction(
827     bytes32 indexed txHash,
828     address indexed target,
829     uint256 value,
830     string signature,
831     bytes data,
832     uint256 eta
833   );
834 
835   function acceptAdmin() external;
836 
837   function queueTransaction(
838     address target,
839     uint256 value,
840     string calldata signature,
841     bytes calldata data,
842     uint256 eta
843   ) external returns (bytes32);
844 
845   function cancelTransaction(
846     address target,
847     uint256 value,
848     string calldata signature,
849     bytes calldata data,
850     uint256 eta
851   ) external;
852 
853   function executeTransaction(
854     address target,
855     uint256 value,
856     string calldata signature,
857     bytes calldata data,
858     uint256 eta
859   ) external payable returns (bytes memory);
860 
861   function delay() external view returns (uint256);
862 
863   function GRACE_PERIOD() external view returns (uint256);
864 
865   function queuedTransactions(bytes32 hash) external view returns (bool);
866 }
867 
868 // 
869 interface IVotingEscrow {
870   enum LockAction { CREATE_LOCK, INCREASE_LOCK_AMOUNT, INCREASE_LOCK_TIME }
871 
872   struct LockedBalance {
873     uint256 amount;
874     uint256 end;
875   }
876 
877   /** Shared Events */
878   event Deposit(address indexed provider, uint256 value, uint256 locktime, LockAction indexed action, uint256 ts);
879   event Withdraw(address indexed provider, uint256 value, uint256 ts);
880   event Expired();
881 
882   function createLock(uint256 _value, uint256 _unlockTime) external;
883 
884   function increaseLockAmount(uint256 _value) external;
885 
886   function increaseLockLength(uint256 _unlockTime) external;
887 
888   function withdraw() external;
889 
890   function expireContract() external;
891 
892   function name() external view returns (string memory);
893 
894   function symbol() external view returns (string memory);
895 
896   function decimals() external view returns (uint256);
897 
898   function balanceOf(address _owner) external view returns (uint256);
899 
900   function balanceOfAt(address _owner, uint256 _blockTime) external view returns (uint256);
901 
902   function stakingToken() external view returns (IERC20);
903 }
904 
905 // 
906 interface IAccessController {
907   event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
908   event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
909   event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
910 
911   function grantRole(bytes32 role, address account) external;
912 
913   function revokeRole(bytes32 role, address account) external;
914 
915   function renounceRole(bytes32 role, address account) external;
916 
917   function MANAGER_ROLE() external view returns (bytes32);
918 
919   function MINTER_ROLE() external view returns (bytes32);
920 
921   function hasRole(bytes32 role, address account) external view returns (bool);
922 
923   function getRoleMemberCount(bytes32 role) external view returns (uint256);
924 
925   function getRoleMember(bytes32 role, uint256 index) external view returns (address);
926 
927   function getRoleAdmin(bytes32 role) external view returns (bytes32);
928 }
929 
930 // 
931 interface ISTABLEX is IERC20 {
932   function mint(address account, uint256 amount) external;
933 
934   function burn(address account, uint256 amount) external;
935 
936   function a() external view returns (IAddressProvider);
937 }
938 
939 // 
940 interface AggregatorV3Interface {
941   function decimals() external view returns (uint8);
942 
943   function description() external view returns (string memory);
944 
945   function version() external view returns (uint256);
946 
947   function getRoundData(uint80 _roundId)
948     external
949     view
950     returns (
951       uint80 roundId,
952       int256 answer,
953       uint256 startedAt,
954       uint256 updatedAt,
955       uint80 answeredInRound
956     );
957 
958   function latestRoundData()
959     external
960     view
961     returns (
962       uint80 roundId,
963       int256 answer,
964       uint256 startedAt,
965       uint256 updatedAt,
966       uint80 answeredInRound
967     );
968 }
969 
970 // 
971 interface IPriceFeed {
972   event OracleUpdated(address indexed asset, address oracle, address sender);
973   event EurOracleUpdated(address oracle, address sender);
974 
975   function setAssetOracle(address _asset, address _oracle) external;
976 
977   function setEurOracle(address _oracle) external;
978 
979   function a() external view returns (IAddressProvider);
980 
981   function assetOracles(address _asset) external view returns (AggregatorV3Interface);
982 
983   function eurOracle() external view returns (AggregatorV3Interface);
984 
985   function getAssetPrice(address _asset) external view returns (uint256);
986 
987   function convertFrom(address _asset, uint256 _amount) external view returns (uint256);
988 
989   function convertTo(address _asset, uint256 _amount) external view returns (uint256);
990 }
991 
992 // 
993 interface IRatesManager {
994   function a() external view returns (IAddressProvider);
995 
996   //current annualized borrow rate
997   function annualizedBorrowRate(uint256 _currentBorrowRate) external pure returns (uint256);
998 
999   //uses current cumulative rate to calculate totalDebt based on baseDebt at time T0
1000   function calculateDebt(uint256 _baseDebt, uint256 _cumulativeRate) external pure returns (uint256);
1001 
1002   //uses current cumulative rate to calculate baseDebt at time T0
1003   function calculateBaseDebt(uint256 _debt, uint256 _cumulativeRate) external pure returns (uint256);
1004 
1005   //calculate a new cumulative rate
1006   function calculateCumulativeRate(
1007     uint256 _borrowRate,
1008     uint256 _cumulativeRate,
1009     uint256 _timeElapsed
1010   ) external view returns (uint256);
1011 }
1012 
1013 // 
1014 interface ILiquidationManager {
1015   function a() external view returns (IAddressProvider);
1016 
1017   function calculateHealthFactor(
1018     uint256 _collateralValue,
1019     uint256 _vaultDebt,
1020     uint256 _minRatio
1021   ) external view returns (uint256 healthFactor);
1022 
1023   function liquidationBonus(address _collateralType, uint256 _amount) external view returns (uint256 bonus);
1024 
1025   function applyLiquidationDiscount(address _collateralType, uint256 _amount)
1026     external
1027     view
1028     returns (uint256 discountedAmount);
1029 
1030   function isHealthy(
1031     uint256 _collateralValue,
1032     uint256 _vaultDebt,
1033     uint256 _minRatio
1034   ) external view returns (bool);
1035 }
1036 
1037 // 
1038 interface IVaultsDataProvider {
1039   struct Vault {
1040     // borrowedType support USDX / PAR
1041     address collateralType;
1042     address owner;
1043     uint256 collateralBalance;
1044     uint256 baseDebt;
1045     uint256 createdAt;
1046   }
1047 
1048   //Write
1049   function createVault(address _collateralType, address _owner) external returns (uint256);
1050 
1051   function setCollateralBalance(uint256 _id, uint256 _balance) external;
1052 
1053   function setBaseDebt(uint256 _id, uint256 _newBaseDebt) external;
1054 
1055   // Read
1056   function a() external view returns (IAddressProvider);
1057 
1058   function baseDebt(address _collateralType) external view returns (uint256);
1059 
1060   function vaultCount() external view returns (uint256);
1061 
1062   function vaults(uint256 _id) external view returns (Vault memory);
1063 
1064   function vaultOwner(uint256 _id) external view returns (address);
1065 
1066   function vaultCollateralType(uint256 _id) external view returns (address);
1067 
1068   function vaultCollateralBalance(uint256 _id) external view returns (uint256);
1069 
1070   function vaultBaseDebt(uint256 _id) external view returns (uint256);
1071 
1072   function vaultId(address _collateralType, address _owner) external view returns (uint256);
1073 
1074   function vaultExists(uint256 _id) external view returns (bool);
1075 
1076   function vaultDebt(uint256 _vaultId) external view returns (uint256);
1077 
1078   function debt() external view returns (uint256);
1079 
1080   function collateralDebt(address _collateralType) external view returns (uint256);
1081 }
1082 
1083 // 
1084 interface IFeeDistributor {
1085   event PayeeAdded(address indexed account, uint256 shares);
1086   event FeeReleased(uint256 income, uint256 releasedAt);
1087 
1088   function release() external;
1089 
1090   function changePayees(address[] memory _payees, uint256[] memory _shares) external;
1091 
1092   function a() external view returns (IAddressProvider);
1093 
1094   function lastReleasedAt() external view returns (uint256);
1095 
1096   function getPayees() external view returns (address[] memory);
1097 
1098   function totalShares() external view returns (uint256);
1099 
1100   function shares(address payee) external view returns (uint256);
1101 }
1102 
1103 // 
1104 interface IAddressProvider {
1105   function setAccessController(IAccessController _controller) external;
1106 
1107   function setConfigProvider(IConfigProvider _config) external;
1108 
1109   function setVaultsCore(IVaultsCore _core) external;
1110 
1111   function setStableX(ISTABLEX _stablex) external;
1112 
1113   function setRatesManager(IRatesManager _ratesManager) external;
1114 
1115   function setPriceFeed(IPriceFeed _priceFeed) external;
1116 
1117   function setLiquidationManager(ILiquidationManager _liquidationManager) external;
1118 
1119   function setVaultsDataProvider(IVaultsDataProvider _vaultsData) external;
1120 
1121   function setFeeDistributor(IFeeDistributor _feeDistributor) external;
1122 
1123   function controller() external view returns (IAccessController);
1124 
1125   function config() external view returns (IConfigProvider);
1126 
1127   function core() external view returns (IVaultsCore);
1128 
1129   function stablex() external view returns (ISTABLEX);
1130 
1131   function ratesManager() external view returns (IRatesManager);
1132 
1133   function priceFeed() external view returns (IPriceFeed);
1134 
1135   function liquidationManager() external view returns (ILiquidationManager);
1136 
1137   function vaultsData() external view returns (IVaultsDataProvider);
1138 
1139   function feeDistributor() external view returns (IFeeDistributor);
1140 }
1141 
1142 // 
1143 interface IConfigProviderV1 {
1144   struct CollateralConfig {
1145     address collateralType;
1146     uint256 debtLimit;
1147     uint256 minCollateralRatio;
1148     uint256 borrowRate;
1149     uint256 originationFee;
1150   }
1151 
1152   event CollateralUpdated(
1153     address indexed collateralType,
1154     uint256 debtLimit,
1155     uint256 minCollateralRatio,
1156     uint256 borrowRate,
1157     uint256 originationFee
1158   );
1159   event CollateralRemoved(address indexed collateralType);
1160 
1161   function setCollateralConfig(
1162     address _collateralType,
1163     uint256 _debtLimit,
1164     uint256 _minCollateralRatio,
1165     uint256 _borrowRate,
1166     uint256 _originationFee
1167   ) external;
1168 
1169   function removeCollateral(address _collateralType) external;
1170 
1171   function setCollateralDebtLimit(address _collateralType, uint256 _debtLimit) external;
1172 
1173   function setCollateralMinCollateralRatio(address _collateralType, uint256 _minCollateralRatio) external;
1174 
1175   function setCollateralBorrowRate(address _collateralType, uint256 _borrowRate) external;
1176 
1177   function setCollateralOriginationFee(address _collateralType, uint256 _originationFee) external;
1178 
1179   function setLiquidationBonus(uint256 _bonus) external;
1180 
1181   function a() external view returns (IAddressProviderV1);
1182 
1183   function collateralConfigs(uint256 _id) external view returns (CollateralConfig memory);
1184 
1185   function collateralIds(address _collateralType) external view returns (uint256);
1186 
1187   function numCollateralConfigs() external view returns (uint256);
1188 
1189   function liquidationBonus() external view returns (uint256);
1190 
1191   function collateralDebtLimit(address _collateralType) external view returns (uint256);
1192 
1193   function collateralMinCollateralRatio(address _collateralType) external view returns (uint256);
1194 
1195   function collateralBorrowRate(address _collateralType) external view returns (uint256);
1196 
1197   function collateralOriginationFee(address _collateralType) external view returns (uint256);
1198 }
1199 
1200 // 
1201 interface ILiquidationManagerV1 {
1202   function a() external view returns (IAddressProviderV1);
1203 
1204   function calculateHealthFactor(
1205     address _collateralType,
1206     uint256 _collateralValue,
1207     uint256 _vaultDebt
1208   ) external view returns (uint256 healthFactor);
1209 
1210   function liquidationBonus(uint256 _amount) external view returns (uint256 bonus);
1211 
1212   function applyLiquidationDiscount(uint256 _amount) external view returns (uint256 discountedAmount);
1213 
1214   function isHealthy(
1215     address _collateralType,
1216     uint256 _collateralValue,
1217     uint256 _vaultDebt
1218   ) external view returns (bool);
1219 }
1220 
1221 // 
1222 interface IVaultsCoreV1 {
1223   event Opened(uint256 indexed vaultId, address indexed collateralType, address indexed owner);
1224   event Deposited(uint256 indexed vaultId, uint256 amount, address indexed sender);
1225   event Withdrawn(uint256 indexed vaultId, uint256 amount, address indexed sender);
1226   event Borrowed(uint256 indexed vaultId, uint256 amount, address indexed sender);
1227   event Repaid(uint256 indexed vaultId, uint256 amount, address indexed sender);
1228   event Liquidated(
1229     uint256 indexed vaultId,
1230     uint256 debtRepaid,
1231     uint256 collateralLiquidated,
1232     address indexed owner,
1233     address indexed sender
1234   );
1235 
1236   event CumulativeRateUpdated(address indexed collateralType, uint256 elapsedTime, uint256 newCumulativeRate); //cumulative interest rate from deployment time T0
1237 
1238   event InsurancePaid(uint256 indexed vaultId, uint256 insuranceAmount, address indexed sender);
1239 
1240   function deposit(address _collateralType, uint256 _amount) external;
1241 
1242   function withdraw(uint256 _vaultId, uint256 _amount) external;
1243 
1244   function withdrawAll(uint256 _vaultId) external;
1245 
1246   function borrow(uint256 _vaultId, uint256 _amount) external;
1247 
1248   function repayAll(uint256 _vaultId) external;
1249 
1250   function repay(uint256 _vaultId, uint256 _amount) external;
1251 
1252   function liquidate(uint256 _vaultId) external;
1253 
1254   //Refresh
1255   function initializeRates(address _collateralType) external;
1256 
1257   function refresh() external;
1258 
1259   function refreshCollateral(address collateralType) external;
1260 
1261   //upgrade
1262   function upgrade(address _newVaultsCore) external;
1263 
1264   //Read only
1265 
1266   function a() external view returns (IAddressProviderV1);
1267 
1268   function availableIncome() external view returns (uint256);
1269 
1270   function cumulativeRates(address _collateralType) external view returns (uint256);
1271 
1272   function lastRefresh(address _collateralType) external view returns (uint256);
1273 }
1274 
1275 // 
1276 interface IWETH {
1277   function deposit() external payable;
1278 
1279   function transfer(address to, uint256 value) external returns (bool);
1280 
1281   function withdraw(uint256 wad) external;
1282 }
1283 
1284 // 
1285 interface IMIMO is IERC20 {
1286 
1287   function burn(address account, uint256 amount) external;
1288   
1289   function mint(address account, uint256 amount) external;
1290 
1291 }
1292 
1293 // 
1294 interface ISupplyMiner {
1295 
1296   function baseDebtChanged(address user, uint256 newBaseDebt) external;
1297 }
1298 
1299 // 
1300 interface IDebtNotifier {
1301 
1302   function debtChanged(uint256 _vaultId) external;
1303 
1304   function setCollateralSupplyMiner(address collateral, ISupplyMiner supplyMiner) external;
1305 
1306   function a() external view returns (IGovernanceAddressProvider);
1307 
1308 	function collateralSupplyMinerMapping(address collateral) external view returns (ISupplyMiner);
1309 }
1310 
1311 // 
1312 interface IGovernanceAddressProvider {
1313   function setParallelAddressProvider(IAddressProvider _parallel) external;
1314 
1315   function setMIMO(IMIMO _mimo) external;
1316 
1317   function setDebtNotifier(IDebtNotifier _debtNotifier) external;
1318 
1319   function setGovernorAlpha(IGovernorAlpha _governorAlpha) external;
1320 
1321   function setTimelock(ITimelock _timelock) external;
1322 
1323   function setVotingEscrow(IVotingEscrow _votingEscrow) external;
1324 
1325   function controller() external view returns (IAccessController);
1326 
1327   function parallel() external view returns (IAddressProvider);
1328 
1329   function mimo() external view returns (IMIMO);
1330 
1331   function debtNotifier() external view returns (IDebtNotifier);
1332 
1333   function governorAlpha() external view returns (IGovernorAlpha);
1334 
1335   function timelock() external view returns (ITimelock);
1336 
1337   function votingEscrow() external view returns (IVotingEscrow);
1338 }
1339 
1340 // 
1341 interface IVaultsCore {
1342   event Opened(uint256 indexed vaultId, address indexed collateralType, address indexed owner);
1343   event Deposited(uint256 indexed vaultId, uint256 amount, address indexed sender);
1344   event Withdrawn(uint256 indexed vaultId, uint256 amount, address indexed sender);
1345   event Borrowed(uint256 indexed vaultId, uint256 amount, address indexed sender);
1346   event Repaid(uint256 indexed vaultId, uint256 amount, address indexed sender);
1347   event Liquidated(
1348     uint256 indexed vaultId,
1349     uint256 debtRepaid,
1350     uint256 collateralLiquidated,
1351     address indexed owner,
1352     address indexed sender
1353   );
1354 
1355   event InsurancePaid(uint256 indexed vaultId, uint256 insuranceAmount, address indexed sender);
1356 
1357   function deposit(address _collateralType, uint256 _amount) external;
1358 
1359   function depositETH() external payable;
1360 
1361   function depositByVaultId(uint256 _vaultId, uint256 _amount) external;
1362 
1363   function depositETHByVaultId(uint256 _vaultId) external payable;
1364 
1365   function depositAndBorrow(
1366     address _collateralType,
1367     uint256 _depositAmount,
1368     uint256 _borrowAmount
1369   ) external;
1370 
1371   function depositETHAndBorrow(uint256 _borrowAmount) external payable;
1372 
1373   function withdraw(uint256 _vaultId, uint256 _amount) external;
1374 
1375   function withdrawETH(uint256 _vaultId, uint256 _amount) external;
1376 
1377   function borrow(uint256 _vaultId, uint256 _amount) external;
1378 
1379   function repayAll(uint256 _vaultId) external;
1380 
1381   function repay(uint256 _vaultId, uint256 _amount) external;
1382 
1383   function liquidate(uint256 _vaultId) external;
1384 
1385   function liquidatePartial(uint256 _vaultId, uint256 _amount) external;
1386 
1387   function upgrade(address payable _newVaultsCore) external;
1388 
1389   function acceptUpgrade(address payable _oldVaultsCore) external;
1390 
1391   function setDebtNotifier(IDebtNotifier _debtNotifier) external;
1392 
1393   //Read only
1394   function a() external view returns (IAddressProvider);
1395 
1396   function WETH() external view returns (IWETH);
1397 
1398   function debtNotifier() external view returns (IDebtNotifier);
1399 
1400   function state() external view returns (IVaultsCoreState);
1401 
1402   function cumulativeRates(address _collateralType) external view returns (uint256);
1403 }
1404 
1405 // 
1406 interface IAddressProviderV1 {
1407   function setAccessController(IAccessController _controller) external;
1408 
1409   function setConfigProvider(IConfigProviderV1 _config) external;
1410 
1411   function setVaultsCore(IVaultsCoreV1 _core) external;
1412 
1413   function setStableX(ISTABLEX _stablex) external;
1414 
1415   function setRatesManager(IRatesManager _ratesManager) external;
1416 
1417   function setPriceFeed(IPriceFeed _priceFeed) external;
1418 
1419   function setLiquidationManager(ILiquidationManagerV1 _liquidationManager) external;
1420 
1421   function setVaultsDataProvider(IVaultsDataProvider _vaultsData) external;
1422 
1423   function setFeeDistributor(IFeeDistributor _feeDistributor) external;
1424 
1425   function controller() external view returns (IAccessController);
1426 
1427   function config() external view returns (IConfigProviderV1);
1428 
1429   function core() external view returns (IVaultsCoreV1);
1430 
1431   function stablex() external view returns (ISTABLEX);
1432 
1433   function ratesManager() external view returns (IRatesManager);
1434 
1435   function priceFeed() external view returns (IPriceFeed);
1436 
1437   function liquidationManager() external view returns (ILiquidationManagerV1);
1438 
1439   function vaultsData() external view returns (IVaultsDataProvider);
1440 
1441   function feeDistributor() external view returns (IFeeDistributor);
1442 }
1443 
1444 // 
1445 interface IVaultsCoreState {
1446   event CumulativeRateUpdated(address indexed collateralType, uint256 elapsedTime, uint256 newCumulativeRate); //cumulative interest rate from deployment time T0
1447 
1448   function initializeRates(address _collateralType) external;
1449 
1450   function refresh() external;
1451 
1452   function refreshCollateral(address collateralType) external;
1453 
1454   function syncState(IVaultsCoreState _stateAddress) external;
1455 
1456   function syncStateFromV1(IVaultsCoreV1 _core) external;
1457 
1458   //Read only
1459   function a() external view returns (IAddressProvider);
1460 
1461   function availableIncome() external view returns (uint256);
1462 
1463   function cumulativeRates(address _collateralType) external view returns (uint256);
1464 
1465   function lastRefresh(address _collateralType) external view returns (uint256);
1466 
1467   function synced() external view returns (bool);
1468 }
1469 
1470 // 
1471 interface IConfigProvider {
1472   struct CollateralConfig {
1473     address collateralType;
1474     uint256 debtLimit;
1475     uint256 liquidationRatio;
1476     uint256 minCollateralRatio;
1477     uint256 borrowRate;
1478     uint256 originationFee;
1479     uint256 liquidationBonus;
1480     uint256 liquidationFee;
1481   }
1482 
1483   event CollateralUpdated(
1484     address indexed collateralType,
1485     uint256 debtLimit,
1486     uint256 liquidationRatio,
1487     uint256 minCollateralRatio,
1488     uint256 borrowRate,
1489     uint256 originationFee,
1490     uint256 liquidationBonus,
1491     uint256 liquidationFee
1492   );
1493   event CollateralRemoved(address indexed collateralType);
1494 
1495   function setCollateralConfig(
1496     address _collateralType,
1497     uint256 _debtLimit,
1498     uint256 _liquidationRatio,
1499     uint256 _minCollateralRatio,
1500     uint256 _borrowRate,
1501     uint256 _originationFee,
1502     uint256 _liquidationBonus,
1503     uint256 _liquidationFee
1504   ) external;
1505 
1506   function removeCollateral(address _collateralType) external;
1507 
1508   function setCollateralDebtLimit(address _collateralType, uint256 _debtLimit) external;
1509 
1510   function setCollateralLiquidationRatio(address _collateralType, uint256 _liquidationRatio) external;
1511 
1512   function setCollateralMinCollateralRatio(address _collateralType, uint256 _minCollateralRatio) external;
1513 
1514   function setCollateralBorrowRate(address _collateralType, uint256 _borrowRate) external;
1515 
1516   function setCollateralOriginationFee(address _collateralType, uint256 _originationFee) external;
1517 
1518   function setCollateralLiquidationBonus(address _collateralType, uint256 _liquidationBonus) external;
1519 
1520   function setCollateralLiquidationFee(address _collateralType, uint256 _liquidationFee) external;
1521 
1522   function setMinVotingPeriod(uint256 _minVotingPeriod) external;
1523 
1524   function setMaxVotingPeriod(uint256 _maxVotingPeriod) external;
1525 
1526   function setVotingQuorum(uint256 _votingQuorum) external;
1527 
1528   function setProposalThreshold(uint256 _proposalThreshold) external;
1529 
1530   function a() external view returns (IAddressProvider);
1531 
1532   function collateralConfigs(uint256 _id) external view returns (CollateralConfig memory);
1533 
1534   function collateralIds(address _collateralType) external view returns (uint256);
1535 
1536   function numCollateralConfigs() external view returns (uint256);
1537 
1538   function minVotingPeriod() external view returns (uint256);
1539 
1540   function maxVotingPeriod() external view returns (uint256);
1541 
1542   function votingQuorum() external view returns (uint256);
1543 
1544   function proposalThreshold() external view returns (uint256);
1545 
1546   function collateralDebtLimit(address _collateralType) external view returns (uint256);
1547 
1548   function collateralLiquidationRatio(address _collateralType) external view returns (uint256);
1549 
1550   function collateralMinCollateralRatio(address _collateralType) external view returns (uint256);
1551 
1552   function collateralBorrowRate(address _collateralType) external view returns (uint256);
1553 
1554   function collateralOriginationFee(address _collateralType) external view returns (uint256);
1555 
1556   function collateralLiquidationBonus(address _collateralType) external view returns (uint256);
1557 
1558   function collateralLiquidationFee(address _collateralType) external view returns (uint256);
1559 }
1560 
1561 // solium-disable security/no-block-members
1562 // 
1563 /**
1564  * @title  MIMO
1565  * @notice  MIMO Governance token
1566  */
1567 contract MIMO is ERC20("MIMO Parallel Governance Token", "MIMO") {
1568   IGovernanceAddressProvider public a;
1569 
1570   bytes32 public constant MIMO_MINTER_ROLE = keccak256("MIMO_MINTER_ROLE");
1571 
1572   constructor(IGovernanceAddressProvider _a) public {
1573     require(address(_a) != address(0));
1574 
1575     a = _a;
1576   }
1577 
1578   modifier onlyMIMOMinter() {
1579     require(a.controller().hasRole(MIMO_MINTER_ROLE, msg.sender), "Caller is not MIMO Minter");
1580     _;
1581   }
1582 
1583   function mint(address account, uint256 amount) public onlyMIMOMinter {
1584     _mint(account, amount);
1585   }
1586 
1587   function burn(address account, uint256 amount) public onlyMIMOMinter {
1588     _burn(account, amount);
1589   }
1590 }