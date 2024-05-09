1 // SPDX-License-Identifier: MIT
2 // 
3 pragma solidity ^0.6.0;
4 
5 /**
6  * @dev Implementation of the {IERC20} interface.
7  *
8  * This implementation is agnostic to the way tokens are created. This means
9  * that a supply mechanism has to be added in a derived contract using {_mint}.
10  * For a generic mechanism see {ERC20PresetMinterPauser}.
11  *
12  * TIP: For a detailed writeup see our guide
13  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
14  * to implement supply mechanisms].
15  *
16  * We have followed general OpenZeppelin guidelines: functions revert instead
17  * of returning `false` on failure. This behavior is nonetheless conventional
18  * and does not conflict with the expectations of ERC20 applications.
19  *
20  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
21  * This allows applications to reconstruct the allowance for all accounts just
22  * by listening to said events. Other implementations of the EIP may not emit
23  * these events, as it isn't required by the specification.
24  *
25  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
26  * functions have been added to mitigate the well-known issues around setting
27  * allowances. See {IERC20-approve}.
28  */
29 
30 
31 
32 // File: @openzeppelin/contracts/GSN/Context.sol
33 
34 /*
35  * @dev Provides information about the current execution context, including the
36  * sender of the transaction and its data. While these are generally available
37  * via msg.sender and msg.data, they should not be accessed in such a direct
38  * manner, since when dealing with GSN meta-transactions the account sending and
39  * paying for execution may not be the actual sender (as far as an application
40  * is concerned).
41  *
42  * This contract is only required for intermediate, library-like contracts.
43  */
44 abstract contract Context {
45     function _msgSender() internal view virtual returns (address payable) {
46         return msg.sender;
47     }
48 
49     function _msgData() internal view virtual returns (bytes memory) {
50         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
51         return msg.data;
52     }
53 }
54 
55 
56 pragma solidity ^0.6.0;
57 
58 /**
59  * @dev Interface of the ERC20 standard as defined in the EIP.
60  */
61 interface IERC20 {
62     /**
63      * @dev Returns the amount of tokens in existence.
64      */
65     function totalSupply() external view returns (uint256);
66 
67     /**
68      * @dev Returns the amount of tokens owned by `account`.
69      */
70     function balanceOf(address account) external view returns (uint256);
71 
72     /**
73      * @dev Moves `amount` tokens from the caller's account to `recipient`.
74      *
75      * Returns a boolean value indicating whether the operation succeeded.
76      *
77      * Emits a {Transfer} event.
78      */
79     function transfer(address recipient, uint256 amount) external returns (bool);
80 
81     /**
82      * @dev Returns the remaining number of tokens that `spender` will be
83      * allowed to spend on behalf of `owner` through {transferFrom}. This is
84      * zero by default.
85      *
86      * This value changes when {approve} or {transferFrom} are called.
87      */
88     function allowance(address owner, address spender) external view returns (uint256);
89 
90     /**
91      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
92      *
93      * Returns a boolean value indicating whether the operation succeeded.
94      *
95      * IMPORTANT: Beware that changing an allowance with this method brings the risk
96      * that someone may use both the old and the new allowance by unfortunate
97      * transaction ordering. One possible solution to mitigate this race
98      * condition is to first reduce the spender's allowance to 0 and set the
99      * desired value afterwards:
100      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
101      *
102      * Emits an {Approval} event.
103      */
104     function approve(address spender, uint256 amount) external returns (bool);
105 
106     /**
107      * @dev Moves `amount` tokens from `sender` to `recipient` using the
108      * allowance mechanism. `amount` is then deducted from the caller's
109      * allowance.
110      *
111      * Returns a boolean value indicating whether the operation succeeded.
112      *
113      * Emits a {Transfer} event.
114      */
115     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
116 
117     /**
118      * @dev Emitted when `value` tokens are moved from one account (`from`) to
119      * another (`to`).
120      *
121      * Note that `value` may be zero.
122      */
123     event Transfer(address indexed from, address indexed to, uint256 value);
124 
125     /**
126      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
127      * a call to {approve}. `value` is the new allowance.
128      */
129     event Approval(address indexed owner, address indexed spender, uint256 value);
130 }
131 
132 
133 
134 contract ERC20 is Context, IERC20 {
135     using SafeMath for uint256;
136     using Address for address;
137 
138     mapping (address => uint256) private _balances;
139 
140     mapping (address => mapping (address => uint256)) private _allowances;
141 
142     uint256 private _totalSupply;
143 
144     string private _name;
145     string private _symbol;
146     uint8 private _decimals;
147 
148     /**
149      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
150      * a default value of 18.
151      *
152      * To select a different value for {decimals}, use {_setupDecimals}.
153      *
154      * All three of these values are immutable: they can only be set once during
155      * construction.
156      */
157     constructor (string memory name, string memory symbol) public {
158         _name = name;
159         _symbol = symbol;
160         _decimals = 18;
161     }
162 
163     /**
164      * @dev Returns the name of the token.
165      */
166     function name() public view returns (string memory) {
167         return _name;
168     }
169 
170     /**
171      * @dev Returns the symbol of the token, usually a shorter version of the
172      * name.
173      */
174     function symbol() public view returns (string memory) {
175         return _symbol;
176     }
177 
178     /**
179      * @dev Returns the number of decimals used to get its user representation.
180      * For example, if `decimals` equals `2`, a balance of `505` tokens should
181      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
182      *
183      * Tokens usually opt for a value of 18, imitating the relationship between
184      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
185      * called.
186      *
187      * NOTE: This information is only used for _display_ purposes: it in
188      * no way affects any of the arithmetic of the contract, including
189      * {IERC20-balanceOf} and {IERC20-transfer}.
190      */
191     function decimals() public view returns (uint8) {
192         return _decimals;
193     }
194 
195     /**
196      * @dev See {IERC20-totalSupply}.
197      */
198     function totalSupply() public view override returns (uint256) {
199         return _totalSupply;
200     }
201 
202     /**
203      * @dev See {IERC20-balanceOf}.
204      */
205     function balanceOf(address account) public view override returns (uint256) {
206         return _balances[account];
207     }
208 
209     /**
210      * @dev See {IERC20-transfer}.
211      *
212      * Requirements:
213      *
214      * - `recipient` cannot be the zero address.
215      * - the caller must have a balance of at least `amount`.
216      */
217     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
218         _transfer(_msgSender(), recipient, amount);
219         return true;
220     }
221 
222     /**
223      * @dev See {IERC20-allowance}.
224      */
225     function allowance(address owner, address spender) public view virtual override returns (uint256) {
226         return _allowances[owner][spender];
227     }
228 
229     /**
230      * @dev See {IERC20-approve}.
231      *
232      * Requirements:
233      *
234      * - `spender` cannot be the zero address.
235      */
236     function approve(address spender, uint256 amount) public virtual override returns (bool) {
237         _approve(_msgSender(), spender, amount);
238         return true;
239     }
240 
241     /**
242      * @dev See {IERC20-transferFrom}.
243      *
244      * Emits an {Approval} event indicating the updated allowance. This is not
245      * required by the EIP. See the note at the beginning of {ERC20};
246      *
247      * Requirements:
248      * - `sender` and `recipient` cannot be the zero address.
249      * - `sender` must have a balance of at least `amount`.
250      * - the caller must have allowance for ``sender``'s tokens of at least
251      * `amount`.
252      */
253     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
254         _transfer(sender, recipient, amount);
255         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
256         return true;
257     }
258 
259     /**
260      * @dev Atomically increases the allowance granted to `spender` by the caller.
261      *
262      * This is an alternative to {approve} that can be used as a mitigation for
263      * problems described in {IERC20-approve}.
264      *
265      * Emits an {Approval} event indicating the updated allowance.
266      *
267      * Requirements:
268      *
269      * - `spender` cannot be the zero address.
270      */
271     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
272         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
273         return true;
274     }
275 
276     /**
277      * @dev Atomically decreases the allowance granted to `spender` by the caller.
278      *
279      * This is an alternative to {approve} that can be used as a mitigation for
280      * problems described in {IERC20-approve}.
281      *
282      * Emits an {Approval} event indicating the updated allowance.
283      *
284      * Requirements:
285      *
286      * - `spender` cannot be the zero address.
287      * - `spender` must have allowance for the caller of at least
288      * `subtractedValue`.
289      */
290     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
291         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
292         return true;
293     }
294 
295     /**
296      * @dev Moves tokens `amount` from `sender` to `recipient`.
297      *
298      * This is internal function is equivalent to {transfer}, and can be used to
299      * e.g. implement automatic token fees, slashing mechanisms, etc.
300      *
301      * Emits a {Transfer} event.
302      *
303      * Requirements:
304      *
305      * - `sender` cannot be the zero address.
306      * - `recipient` cannot be the zero address.
307      * - `sender` must have a balance of at least `amount`.
308      */
309     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
310         require(sender != address(0), "ERC20: transfer from the zero address");
311         require(recipient != address(0), "ERC20: transfer to the zero address");
312 
313         _beforeTokenTransfer(sender, recipient, amount);
314 
315         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
316         _balances[recipient] = _balances[recipient].add(amount);
317         emit Transfer(sender, recipient, amount);
318     }
319 
320     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
321      * the total supply.
322      *
323      * Emits a {Transfer} event with `from` set to the zero address.
324      *
325      * Requirements
326      *
327      * - `to` cannot be the zero address.
328      */
329     function _mint(address account, uint256 amount) internal virtual {
330         require(account != address(0), "ERC20: mint to the zero address");
331 
332         _beforeTokenTransfer(address(0), account, amount);
333 
334         _totalSupply = _totalSupply.add(amount);
335         _balances[account] = _balances[account].add(amount);
336         emit Transfer(address(0), account, amount);
337     }
338 
339     /**
340      * @dev Destroys `amount` tokens from `account`, reducing the
341      * total supply.
342      *
343      * Emits a {Transfer} event with `to` set to the zero address.
344      *
345      * Requirements
346      *
347      * - `account` cannot be the zero address.
348      * - `account` must have at least `amount` tokens.
349      */
350     function _burn(address account, uint256 amount) internal virtual {
351         require(account != address(0), "ERC20: burn from the zero address");
352 
353         _beforeTokenTransfer(account, address(0), amount);
354 
355         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
356         _totalSupply = _totalSupply.sub(amount);
357         emit Transfer(account, address(0), amount);
358     }
359 
360     /**
361      * @dev Sets `amount` as the allowance of `spender` over the `owner`s tokens.
362      *
363      * This is internal function is equivalent to `approve`, and can be used to
364      * e.g. set automatic allowances for certain subsystems, etc.
365      *
366      * Emits an {Approval} event.
367      *
368      * Requirements:
369      *
370      * - `owner` cannot be the zero address.
371      * - `spender` cannot be the zero address.
372      */
373     function _approve(address owner, address spender, uint256 amount) internal virtual {
374         require(owner != address(0), "ERC20: approve from the zero address");
375         require(spender != address(0), "ERC20: approve to the zero address");
376 
377         _allowances[owner][spender] = amount;
378         emit Approval(owner, spender, amount);
379     }
380 
381     /**
382      * @dev Sets {decimals} to a value other than the default one of 18.
383      *
384      * WARNING: This function should only be called from the constructor. Most
385      * applications that interact with token contracts will not expect
386      * {decimals} to ever change, and may work incorrectly if it does.
387      */
388     function _setupDecimals(uint8 decimals_) internal {
389         _decimals = decimals_;
390     }
391 
392     /**
393      * @dev Hook that is called before any transfer of tokens. This includes
394      * minting and burning.
395      *
396      * Calling conditions:
397      *
398      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
399      * will be to transferred to `to`.
400      * - when `from` is zero, `amount` tokens will be minted for `to`.
401      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
402      * - `from` and `to` are never both zero.
403      *
404      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
405      */
406     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
407 }
408 
409 
410 
411 
412 
413 
414 // 
415 
416 pragma solidity ^0.6.0;
417 
418 /**
419  * @dev Wrappers over Solidity's arithmetic operations with added overflow
420  * checks.
421  *
422  * Arithmetic operations in Solidity wrap on overflow. This can easily result
423  * in bugs, because programmers usually assume that an overflow raises an
424  * error, which is the standard behavior in high level programming languages.
425  * `SafeMath` restores this intuition by reverting the transaction when an
426  * operation overflows.
427  *
428  * Using this library instead of the unchecked operations eliminates an entire
429  * class of bugs, so it's recommended to use it always.
430  */
431 library SafeMath {
432     /**
433      * @dev Returns the addition of two unsigned integers, reverting on
434      * overflow.
435      *
436      * Counterpart to Solidity's `+` operator.
437      *
438      * Requirements:
439      *
440      * - Addition cannot overflow.
441      */
442     function add(uint256 a, uint256 b) internal pure returns (uint256) {
443         uint256 c = a + b;
444         require(c >= a, "SafeMath: addition overflow");
445 
446         return c;
447     }
448 
449     /**
450      * @dev Returns the subtraction of two unsigned integers, reverting on
451      * overflow (when the result is negative).
452      *
453      * Counterpart to Solidity's `-` operator.
454      *
455      * Requirements:
456      *
457      * - Subtraction cannot overflow.
458      */
459     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
460         return sub(a, b, "SafeMath: subtraction overflow");
461     }
462 
463     /**
464      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
465      * overflow (when the result is negative).
466      *
467      * Counterpart to Solidity's `-` operator.
468      *
469      * Requirements:
470      *
471      * - Subtraction cannot overflow.
472      */
473     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
474         require(b <= a, errorMessage);
475         uint256 c = a - b;
476 
477         return c;
478     }
479 
480     /**
481      * @dev Returns the multiplication of two unsigned integers, reverting on
482      * overflow.
483      *
484      * Counterpart to Solidity's `*` operator.
485      *
486      * Requirements:
487      *
488      * - Multiplication cannot overflow.
489      */
490     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
491         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
492         // benefit is lost if 'b' is also tested.
493         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
494         if (a == 0) {
495             return 0;
496         }
497 
498         uint256 c = a * b;
499         require(c / a == b, "SafeMath: multiplication overflow");
500 
501         return c;
502     }
503 
504     /**
505      * @dev Returns the integer division of two unsigned integers. Reverts on
506      * division by zero. The result is rounded towards zero.
507      *
508      * Counterpart to Solidity's `/` operator. Note: this function uses a
509      * `revert` opcode (which leaves remaining gas untouched) while Solidity
510      * uses an invalid opcode to revert (consuming all remaining gas).
511      *
512      * Requirements:
513      *
514      * - The divisor cannot be zero.
515      */
516     function div(uint256 a, uint256 b) internal pure returns (uint256) {
517         return div(a, b, "SafeMath: division by zero");
518     }
519 
520     /**
521      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
522      * division by zero. The result is rounded towards zero.
523      *
524      * Counterpart to Solidity's `/` operator. Note: this function uses a
525      * `revert` opcode (which leaves remaining gas untouched) while Solidity
526      * uses an invalid opcode to revert (consuming all remaining gas).
527      *
528      * Requirements:
529      *
530      * - The divisor cannot be zero.
531      */
532     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
533         require(b > 0, errorMessage);
534         uint256 c = a / b;
535         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
536 
537         return c;
538     }
539 
540     /**
541      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
542      * Reverts when dividing by zero.
543      *
544      * Counterpart to Solidity's `%` operator. This function uses a `revert`
545      * opcode (which leaves remaining gas untouched) while Solidity uses an
546      * invalid opcode to revert (consuming all remaining gas).
547      *
548      * Requirements:
549      *
550      * - The divisor cannot be zero.
551      */
552     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
553         return mod(a, b, "SafeMath: modulo by zero");
554     }
555 
556     /**
557      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
558      * Reverts with custom message when dividing by zero.
559      *
560      * Counterpart to Solidity's `%` operator. This function uses a `revert`
561      * opcode (which leaves remaining gas untouched) while Solidity uses an
562      * invalid opcode to revert (consuming all remaining gas).
563      *
564      * Requirements:
565      *
566      * - The divisor cannot be zero.
567      */
568     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
569         require(b != 0, errorMessage);
570         return a % b;
571     }
572 }
573 
574 // 
575 
576 pragma solidity ^0.6.2;
577 
578 /**
579  * @dev Collection of functions related to the address type
580  */
581 library Address {
582     /**
583      * @dev Returns true if `account` is a contract.
584      *
585      * [IMPORTANT]
586      * ====
587      * It is unsafe to assume that an address for which this function returns
588      * false is an externally-owned account (EOA) and not a contract.
589      *
590      * Among others, `isContract` will return false for the following
591      * types of addresses:
592      *
593      *  - an externally-owned account
594      *  - a contract in construction
595      *  - an address where a contract will be created
596      *  - an address where a contract lived, but was destroyed
597      * ====
598      */
599     function isContract(address account) internal view returns (bool) {
600         // According to EIP-1052, 0x0 is the value returned for not-yet created accounts
601         // and 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470 is returned
602         // for accounts without code, i.e. `keccak256('')`
603         bytes32 codehash;
604         bytes32 accountHash = 0xc5d2460186f7233c927e7db2dcc703c0e500b653ca82273b7bfad8045d85a470;
605         // solhint-disable-next-line no-inline-assembly
606         assembly { codehash := extcodehash(account) }
607         return (codehash != accountHash && codehash != 0x0);
608     }
609 
610     /**
611      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
612      * `recipient`, forwarding all available gas and reverting on errors.
613      *
614      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
615      * of certain opcodes, possibly making contracts go over the 2300 gas limit
616      * imposed by `transfer`, making them unable to receive funds via
617      * `transfer`. {sendValue} removes this limitation.
618      *
619      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
620      *
621      * IMPORTANT: because control is transferred to `recipient`, care must be
622      * taken to not create reentrancy vulnerabilities. Consider using
623      * {ReentrancyGuard} or the
624      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
625      */
626     function sendValue(address payable recipient, uint256 amount) internal {
627         require(address(this).balance >= amount, "Address: insufficient balance");
628 
629         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
630         (bool success, ) = recipient.call{ value: amount }("");
631         require(success, "Address: unable to send value, recipient may have reverted");
632     }
633 
634     /**
635      * @dev Performs a Solidity function call using a low level `call`. A
636      * plain`call` is an unsafe replacement for a function call: use this
637      * function instead.
638      *
639      * If `target` reverts with a revert reason, it is bubbled up by this
640      * function (like regular Solidity function calls).
641      *
642      * Returns the raw returned data. To convert to the expected return value,
643      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
644      *
645      * Requirements:
646      *
647      * - `target` must be a contract.
648      * - calling `target` with `data` must not revert.
649      *
650      * _Available since v3.1._
651      */
652     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
653       return functionCall(target, data, "Address: low-level call failed");
654     }
655 
656     /**
657      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
658      * `errorMessage` as a fallback revert reason when `target` reverts.
659      *
660      * _Available since v3.1._
661      */
662     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
663         return _functionCallWithValue(target, data, 0, errorMessage);
664     }
665 
666     /**
667      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
668      * but also transferring `value` wei to `target`.
669      *
670      * Requirements:
671      *
672      * - the calling contract must have an ETH balance of at least `value`.
673      * - the called Solidity function must be `payable`.
674      *
675      * _Available since v3.1._
676      */
677     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
678         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
679     }
680 
681     /**
682      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
683      * with `errorMessage` as a fallback revert reason when `target` reverts.
684      *
685      * _Available since v3.1._
686      */
687     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
688         require(address(this).balance >= value, "Address: insufficient balance for call");
689         return _functionCallWithValue(target, data, value, errorMessage);
690     }
691 
692     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
693         require(isContract(target), "Address: call to non-contract");
694 
695         // solhint-disable-next-line avoid-low-level-calls
696         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
697         if (success) {
698             return returndata;
699         } else {
700             // Look for revert reason and bubble it up if present
701             if (returndata.length > 0) {
702                 // The easiest way to bubble the revert reason is using memory via assembly
703 
704                 // solhint-disable-next-line no-inline-assembly
705                 assembly {
706                     let returndata_size := mload(returndata)
707                     revert(add(32, returndata), returndata_size)
708                 }
709             } else {
710                 revert(errorMessage);
711             }
712         }
713     }
714 }
715 
716 
717 pragma solidity >=0.4.22 <0.8.0;
718 
719 contract YFRBToken is ERC20 {
720 address private owner;
721 uint8 public  DECIMALS = 18;
722 string public NAME = "yfrb.Finance";
723 string public SYMBOL="YFRB";
724     constructor() public ERC20(NAME, SYMBOL) {
725 
726         _mint(msg.sender, 40000 *(10 ** uint256(DECIMALS)));
727         owner = msg.sender;
728     }
729 }