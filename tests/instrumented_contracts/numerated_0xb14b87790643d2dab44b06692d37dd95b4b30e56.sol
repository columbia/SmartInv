1 // SPDX-License-Identifier: NONE
2 
3 pragma solidity 0.6.12;
4 
5 
6 
7 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Address
8 
9 /**
10  * @dev Collection of functions related to the address type
11  */
12 library Address {
13     /**
14      * @dev Returns true if `account` is a contract.
15      *
16      * [IMPORTANT]
17      * ====
18      * It is unsafe to assume that an address for which this function returns
19      * false is an externally-owned account (EOA) and not a contract.
20      *
21      * Among others, `isContract` will return false for the following
22      * types of addresses:
23      *
24      *  - an externally-owned account
25      *  - a contract in construction
26      *  - an address where a contract will be created
27      *  - an address where a contract lived, but was destroyed
28      * ====
29      */
30     function isContract(address account) internal view returns (bool) {
31         // This method relies in extcodesize, which returns 0 for contracts in
32         // construction, since the code is only stored at the end of the
33         // constructor execution.
34 
35         uint256 size;
36         // solhint-disable-next-line no-inline-assembly
37         assembly { size := extcodesize(account) }
38         return size > 0;
39     }
40 
41     /**
42      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
43      * `recipient`, forwarding all available gas and reverting on errors.
44      *
45      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
46      * of certain opcodes, possibly making contracts go over the 2300 gas limit
47      * imposed by `transfer`, making them unable to receive funds via
48      * `transfer`. {sendValue} removes this limitation.
49      *
50      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
51      *
52      * IMPORTANT: because control is transferred to `recipient`, care must be
53      * taken to not create reentrancy vulnerabilities. Consider using
54      * {ReentrancyGuard} or the
55      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
56      */
57     function sendValue(address payable recipient, uint256 amount) internal {
58         require(address(this).balance >= amount, "Address: insufficient balance");
59 
60         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
61         (bool success, ) = recipient.call{ value: amount }("");
62         require(success, "Address: unable to send value, recipient may have reverted");
63     }
64 
65     /**
66      * @dev Performs a Solidity function call using a low level `call`. A
67      * plain`call` is an unsafe replacement for a function call: use this
68      * function instead.
69      *
70      * If `target` reverts with a revert reason, it is bubbled up by this
71      * function (like regular Solidity function calls).
72      *
73      * Returns the raw returned data. To convert to the expected return value,
74      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
75      *
76      * Requirements:
77      *
78      * - `target` must be a contract.
79      * - calling `target` with `data` must not revert.
80      *
81      * _Available since v3.1._
82      */
83     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
84       return functionCall(target, data, "Address: low-level call failed");
85     }
86 
87     /**
88      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
89      * `errorMessage` as a fallback revert reason when `target` reverts.
90      *
91      * _Available since v3.1._
92      */
93     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
94         return _functionCallWithValue(target, data, 0, errorMessage);
95     }
96 
97     /**
98      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
99      * but also transferring `value` wei to `target`.
100      *
101      * Requirements:
102      *
103      * - the calling contract must have an ETH balance of at least `value`.
104      * - the called Solidity function must be `payable`.
105      *
106      * _Available since v3.1._
107      */
108     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
109         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
110     }
111 
112     /**
113      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
114      * with `errorMessage` as a fallback revert reason when `target` reverts.
115      *
116      * _Available since v3.1._
117      */
118     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
119         require(address(this).balance >= value, "Address: insufficient balance for call");
120         return _functionCallWithValue(target, data, value, errorMessage);
121     }
122 
123     function _functionCallWithValue(address target, bytes memory data, uint256 weiValue, string memory errorMessage) private returns (bytes memory) {
124         require(isContract(target), "Address: call to non-contract");
125 
126         // solhint-disable-next-line avoid-low-level-calls
127         (bool success, bytes memory returndata) = target.call{ value: weiValue }(data);
128         if (success) {
129             return returndata;
130         } else {
131             // Look for revert reason and bubble it up if present
132             if (returndata.length > 0) {
133                 // The easiest way to bubble the revert reason is using memory via assembly
134 
135                 // solhint-disable-next-line no-inline-assembly
136                 assembly {
137                     let returndata_size := mload(returndata)
138                     revert(add(32, returndata), returndata_size)
139                 }
140             } else {
141                 revert(errorMessage);
142             }
143         }
144     }
145 }
146 
147 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Context
148 
149 /*
150  * @dev Provides information about the current execution context, including the
151  * sender of the transaction and its data. While these are generally available
152  * via msg.sender and msg.data, they should not be accessed in such a direct
153  * manner, since when dealing with GSN meta-transactions the account sending and
154  * paying for execution may not be the actual sender (as far as an application
155  * is concerned).
156  *
157  * This contract is only required for intermediate, library-like contracts.
158  */
159 abstract contract Context {
160     function _msgSender() internal view virtual returns (address payable) {
161         return msg.sender;
162     }
163 
164     function _msgData() internal view virtual returns (bytes memory) {
165         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
166         return msg.data;
167     }
168 }
169 
170 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC165
171 
172 /**
173  * @dev Interface of the ERC165 standard, as defined in the
174  * https://eips.ethereum.org/EIPS/eip-165[EIP].
175  *
176  * Implementers can declare support of contract interfaces, which can then be
177  * queried by others ({ERC165Checker}).
178  *
179  * For an implementation, see {ERC165}.
180  */
181 interface IERC165 {
182     /**
183      * @dev Returns true if this contract implements the interface defined by
184      * `interfaceId`. See the corresponding
185      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
186      * to learn more about how these ids are created.
187      *
188      * This function call must use less than 30 000 gas.
189      */
190     function supportsInterface(bytes4 interfaceId) external view returns (bool);
191 }
192 
193 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC20
194 
195 /**
196  * @dev Interface of the ERC20 standard as defined in the EIP.
197  */
198 interface IERC20 {
199     /**
200      * @dev Returns the amount of tokens in existence.
201      */
202     function totalSupply() external view returns (uint256);
203 
204     /**
205      * @dev Returns the amount of tokens owned by `account`.
206      */
207     function balanceOf(address account) external view returns (uint256);
208 
209     /**
210      * @dev Moves `amount` tokens from the caller's account to `recipient`.
211      *
212      * Returns a boolean value indicating whether the operation succeeded.
213      *
214      * Emits a {Transfer} event.
215      */
216     function transfer(address recipient, uint256 amount) external returns (bool);
217 
218     /**
219      * @dev Returns the remaining number of tokens that `spender` will be
220      * allowed to spend on behalf of `owner` through {transferFrom}. This is
221      * zero by default.
222      *
223      * This value changes when {approve} or {transferFrom} are called.
224      */
225     function allowance(address owner, address spender) external view returns (uint256);
226 
227     /**
228      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
229      *
230      * Returns a boolean value indicating whether the operation succeeded.
231      *
232      * IMPORTANT: Beware that changing an allowance with this method brings the risk
233      * that someone may use both the old and the new allowance by unfortunate
234      * transaction ordering. One possible solution to mitigate this race
235      * condition is to first reduce the spender's allowance to 0 and set the
236      * desired value afterwards:
237      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
238      *
239      * Emits an {Approval} event.
240      */
241     function approve(address spender, uint256 amount) external returns (bool);
242 
243     /**
244      * @dev Moves `amount` tokens from `sender` to `recipient` using the
245      * allowance mechanism. `amount` is then deducted from the caller's
246      * allowance.
247      *
248      * Returns a boolean value indicating whether the operation succeeded.
249      *
250      * Emits a {Transfer} event.
251      */
252     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
253 
254     /**
255      * @dev Emitted when `value` tokens are moved from one account (`from`) to
256      * another (`to`).
257      *
258      * Note that `value` may be zero.
259      */
260     event Transfer(address indexed from, address indexed to, uint256 value);
261 
262     /**
263      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
264      * a call to {approve}. `value` is the new allowance.
265      */
266     event Approval(address indexed owner, address indexed spender, uint256 value);
267 }
268 
269 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/SafeMath
270 
271 /**
272  * @dev Wrappers over Solidity's arithmetic operations with added overflow
273  * checks.
274  *
275  * Arithmetic operations in Solidity wrap on overflow. This can easily result
276  * in bugs, because programmers usually assume that an overflow raises an
277  * error, which is the standard behavior in high level programming languages.
278  * `SafeMath` restores this intuition by reverting the transaction when an
279  * operation overflows.
280  *
281  * Using this library instead of the unchecked operations eliminates an entire
282  * class of bugs, so it's recommended to use it always.
283  */
284 library SafeMath {
285     /**
286      * @dev Returns the addition of two unsigned integers, reverting on
287      * overflow.
288      *
289      * Counterpart to Solidity's `+` operator.
290      *
291      * Requirements:
292      *
293      * - Addition cannot overflow.
294      */
295     function add(uint256 a, uint256 b) internal pure returns (uint256) {
296         uint256 c = a + b;
297         require(c >= a, "SafeMath: addition overflow");
298 
299         return c;
300     }
301 
302     /**
303      * @dev Returns the subtraction of two unsigned integers, reverting on
304      * overflow (when the result is negative).
305      *
306      * Counterpart to Solidity's `-` operator.
307      *
308      * Requirements:
309      *
310      * - Subtraction cannot overflow.
311      */
312     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
313         return sub(a, b, "SafeMath: subtraction overflow");
314     }
315 
316     /**
317      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
318      * overflow (when the result is negative).
319      *
320      * Counterpart to Solidity's `-` operator.
321      *
322      * Requirements:
323      *
324      * - Subtraction cannot overflow.
325      */
326     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
327         require(b <= a, errorMessage);
328         uint256 c = a - b;
329 
330         return c;
331     }
332 
333     /**
334      * @dev Returns the multiplication of two unsigned integers, reverting on
335      * overflow.
336      *
337      * Counterpart to Solidity's `*` operator.
338      *
339      * Requirements:
340      *
341      * - Multiplication cannot overflow.
342      */
343     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
344         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
345         // benefit is lost if 'b' is also tested.
346         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
347         if (a == 0) {
348             return 0;
349         }
350 
351         uint256 c = a * b;
352         require(c / a == b, "SafeMath: multiplication overflow");
353 
354         return c;
355     }
356 
357     /**
358      * @dev Returns the integer division of two unsigned integers. Reverts on
359      * division by zero. The result is rounded towards zero.
360      *
361      * Counterpart to Solidity's `/` operator. Note: this function uses a
362      * `revert` opcode (which leaves remaining gas untouched) while Solidity
363      * uses an invalid opcode to revert (consuming all remaining gas).
364      *
365      * Requirements:
366      *
367      * - The divisor cannot be zero.
368      */
369     function div(uint256 a, uint256 b) internal pure returns (uint256) {
370         return div(a, b, "SafeMath: division by zero");
371     }
372 
373     /**
374      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
375      * division by zero. The result is rounded towards zero.
376      *
377      * Counterpart to Solidity's `/` operator. Note: this function uses a
378      * `revert` opcode (which leaves remaining gas untouched) while Solidity
379      * uses an invalid opcode to revert (consuming all remaining gas).
380      *
381      * Requirements:
382      *
383      * - The divisor cannot be zero.
384      */
385     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
386         require(b > 0, errorMessage);
387         uint256 c = a / b;
388         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
389 
390         return c;
391     }
392 
393     /**
394      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
395      * Reverts when dividing by zero.
396      *
397      * Counterpart to Solidity's `%` operator. This function uses a `revert`
398      * opcode (which leaves remaining gas untouched) while Solidity uses an
399      * invalid opcode to revert (consuming all remaining gas).
400      *
401      * Requirements:
402      *
403      * - The divisor cannot be zero.
404      */
405     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
406         return mod(a, b, "SafeMath: modulo by zero");
407     }
408 
409     /**
410      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
411      * Reverts with custom message when dividing by zero.
412      *
413      * Counterpart to Solidity's `%` operator. This function uses a `revert`
414      * opcode (which leaves remaining gas untouched) while Solidity uses an
415      * invalid opcode to revert (consuming all remaining gas).
416      *
417      * Requirements:
418      *
419      * - The divisor cannot be zero.
420      */
421     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
422         require(b != 0, errorMessage);
423         return a % b;
424     }
425 }
426 
427 // Part: IBanana
428 
429 // import "./YieldNFT.sol";
430 // import "./YieldToken.sol";
431 
432 interface IBanana is IERC20 {
433 	function getTotalClaimable(address _user) external view returns(uint256);
434 }
435 
436 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/ERC20
437 
438 /**
439  * @dev Implementation of the {IERC20} interface.
440  *
441  * This implementation is agnostic to the way tokens are created. This means
442  * that a supply mechanism has to be added in a derived contract using {_mint}.
443  * For a generic mechanism see {ERC20PresetMinterPauser}.
444  *
445  * TIP: For a detailed writeup see our guide
446  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
447  * to implement supply mechanisms].
448  *
449  * We have followed general OpenZeppelin guidelines: functions revert instead
450  * of returning `false` on failure. This behavior is nonetheless conventional
451  * and does not conflict with the expectations of ERC20 applications.
452  *
453  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
454  * This allows applications to reconstruct the allowance for all accounts just
455  * by listening to said events. Other implementations of the EIP may not emit
456  * these events, as it isn't required by the specification.
457  *
458  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
459  * functions have been added to mitigate the well-known issues around setting
460  * allowances. See {IERC20-approve}.
461  */
462 contract ERC20 is Context, IERC20 {
463     using SafeMath for uint256;
464     using Address for address;
465 
466     mapping (address => uint256) private _balances;
467 
468     mapping (address => mapping (address => uint256)) private _allowances;
469 
470     uint256 private _totalSupply;
471 
472     string private _name;
473     string private _symbol;
474     uint8 private _decimals;
475 
476     /**
477      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
478      * a default value of 18.
479      *
480      * To select a different value for {decimals}, use {_setupDecimals}.
481      *
482      * All three of these values are immutable: they can only be set once during
483      * construction.
484      */
485     constructor (string memory name, string memory symbol) public {
486         _name = name;
487         _symbol = symbol;
488         _decimals = 18;
489     }
490 
491     /**
492      * @dev Returns the name of the token.
493      */
494     function name() public view returns (string memory) {
495         return _name;
496     }
497 
498     /**
499      * @dev Returns the symbol of the token, usually a shorter version of the
500      * name.
501      */
502     function symbol() public view returns (string memory) {
503         return _symbol;
504     }
505 
506     /**
507      * @dev Returns the number of decimals used to get its user representation.
508      * For example, if `decimals` equals `2`, a balance of `505` tokens should
509      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
510      *
511      * Tokens usually opt for a value of 18, imitating the relationship between
512      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
513      * called.
514      *
515      * NOTE: This information is only used for _display_ purposes: it in
516      * no way affects any of the arithmetic of the contract, including
517      * {IERC20-balanceOf} and {IERC20-transfer}.
518      */
519     function decimals() public view returns (uint8) {
520         return _decimals;
521     }
522 
523     /**
524      * @dev See {IERC20-totalSupply}.
525      */
526     function totalSupply() public view override returns (uint256) {
527         return _totalSupply;
528     }
529 
530     /**
531      * @dev See {IERC20-balanceOf}.
532      */
533     function balanceOf(address account) public view override returns (uint256) {
534         return _balances[account];
535     }
536 
537     /**
538      * @dev See {IERC20-transfer}.
539      *
540      * Requirements:
541      *
542      * - `recipient` cannot be the zero address.
543      * - the caller must have a balance of at least `amount`.
544      */
545     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
546         _transfer(_msgSender(), recipient, amount);
547         return true;
548     }
549 
550     /**
551      * @dev See {IERC20-allowance}.
552      */
553     function allowance(address owner, address spender) public view virtual override returns (uint256) {
554         return _allowances[owner][spender];
555     }
556 
557     /**
558      * @dev See {IERC20-approve}.
559      *
560      * Requirements:
561      *
562      * - `spender` cannot be the zero address.
563      */
564     function approve(address spender, uint256 amount) public virtual override returns (bool) {
565         _approve(_msgSender(), spender, amount);
566         return true;
567     }
568 
569     /**
570      * @dev See {IERC20-transferFrom}.
571      *
572      * Emits an {Approval} event indicating the updated allowance. This is not
573      * required by the EIP. See the note at the beginning of {ERC20};
574      *
575      * Requirements:
576      * - `sender` and `recipient` cannot be the zero address.
577      * - `sender` must have a balance of at least `amount`.
578      * - the caller must have allowance for ``sender``'s tokens of at least
579      * `amount`.
580      */
581     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
582         _transfer(sender, recipient, amount);
583         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
584         return true;
585     }
586 
587     /**
588      * @dev Atomically increases the allowance granted to `spender` by the caller.
589      *
590      * This is an alternative to {approve} that can be used as a mitigation for
591      * problems described in {IERC20-approve}.
592      *
593      * Emits an {Approval} event indicating the updated allowance.
594      *
595      * Requirements:
596      *
597      * - `spender` cannot be the zero address.
598      */
599     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
600         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
601         return true;
602     }
603 
604     /**
605      * @dev Atomically decreases the allowance granted to `spender` by the caller.
606      *
607      * This is an alternative to {approve} that can be used as a mitigation for
608      * problems described in {IERC20-approve}.
609      *
610      * Emits an {Approval} event indicating the updated allowance.
611      *
612      * Requirements:
613      *
614      * - `spender` cannot be the zero address.
615      * - `spender` must have allowance for the caller of at least
616      * `subtractedValue`.
617      */
618     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
619         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
620         return true;
621     }
622 
623     /**
624      * @dev Moves tokens `amount` from `sender` to `recipient`.
625      *
626      * This is internal function is equivalent to {transfer}, and can be used to
627      * e.g. implement automatic token fees, slashing mechanisms, etc.
628      *
629      * Emits a {Transfer} event.
630      *
631      * Requirements:
632      *
633      * - `sender` cannot be the zero address.
634      * - `recipient` cannot be the zero address.
635      * - `sender` must have a balance of at least `amount`.
636      */
637     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
638         require(sender != address(0), "ERC20: transfer from the zero address");
639         require(recipient != address(0), "ERC20: transfer to the zero address");
640 
641         _beforeTokenTransfer(sender, recipient, amount);
642 
643         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
644         _balances[recipient] = _balances[recipient].add(amount);
645         emit Transfer(sender, recipient, amount);
646     }
647 
648     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
649      * the total supply.
650      *
651      * Emits a {Transfer} event with `from` set to the zero address.
652      *
653      * Requirements
654      *
655      * - `to` cannot be the zero address.
656      */
657     function _mint(address account, uint256 amount) internal virtual {
658         require(account != address(0), "ERC20: mint to the zero address");
659 
660         _beforeTokenTransfer(address(0), account, amount);
661 
662         _totalSupply = _totalSupply.add(amount);
663         _balances[account] = _balances[account].add(amount);
664         emit Transfer(address(0), account, amount);
665     }
666 
667     /**
668      * @dev Destroys `amount` tokens from `account`, reducing the
669      * total supply.
670      *
671      * Emits a {Transfer} event with `to` set to the zero address.
672      *
673      * Requirements
674      *
675      * - `account` cannot be the zero address.
676      * - `account` must have at least `amount` tokens.
677      */
678     function _burn(address account, uint256 amount) internal virtual {
679         require(account != address(0), "ERC20: burn from the zero address");
680 
681         _beforeTokenTransfer(account, address(0), amount);
682 
683         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
684         _totalSupply = _totalSupply.sub(amount);
685         emit Transfer(account, address(0), amount);
686     }
687 
688     /**
689      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
690      *
691      * This internal function is equivalent to `approve`, and can be used to
692      * e.g. set automatic allowances for certain subsystems, etc.
693      *
694      * Emits an {Approval} event.
695      *
696      * Requirements:
697      *
698      * - `owner` cannot be the zero address.
699      * - `spender` cannot be the zero address.
700      */
701     function _approve(address owner, address spender, uint256 amount) internal virtual {
702         require(owner != address(0), "ERC20: approve from the zero address");
703         require(spender != address(0), "ERC20: approve to the zero address");
704 
705         _allowances[owner][spender] = amount;
706         emit Approval(owner, spender, amount);
707     }
708 
709     /**
710      * @dev Sets {decimals} to a value other than the default one of 18.
711      *
712      * WARNING: This function should only be called from the constructor. Most
713      * applications that interact with token contracts will not expect
714      * {decimals} to ever change, and may work incorrectly if it does.
715      */
716     function _setupDecimals(uint8 decimals_) internal {
717         _decimals = decimals_;
718     }
719 
720     /**
721      * @dev Hook that is called before any transfer of tokens. This includes
722      * minting and burning.
723      *
724      * Calling conditions:
725      *
726      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
727      * will be to transferred to `to`.
728      * - when `from` is zero, `amount` tokens will be minted for `to`.
729      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
730      * - `from` and `to` are never both zero.
731      *
732      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
733      */
734     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
735 }
736 
737 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/IERC721
738 
739 /**
740  * @dev Required interface of an ERC721 compliant contract.
741  */
742 interface IERC721 is IERC165 {
743     /**
744      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
745      */
746     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
747 
748     /**
749      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
750      */
751     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
752 
753     /**
754      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
755      */
756     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
757 
758     /**
759      * @dev Returns the number of tokens in ``owner``'s account.
760      */
761     function balanceOf(address owner) external view returns (uint256 balance);
762 
763     /**
764      * @dev Returns the owner of the `tokenId` token.
765      *
766      * Requirements:
767      *
768      * - `tokenId` must exist.
769      */
770     function ownerOf(uint256 tokenId) external view returns (address owner);
771 
772     /**
773      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
774      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
775      *
776      * Requirements:
777      *
778      * - `from` cannot be the zero address.
779      * - `to` cannot be the zero address.
780      * - `tokenId` token must exist and be owned by `from`.
781      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
782      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
783      *
784      * Emits a {Transfer} event.
785      */
786     function safeTransferFrom(address from, address to, uint256 tokenId) external;
787 
788     /**
789      * @dev Transfers `tokenId` token from `from` to `to`.
790      *
791      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
792      *
793      * Requirements:
794      *
795      * - `from` cannot be the zero address.
796      * - `to` cannot be the zero address.
797      * - `tokenId` token must be owned by `from`.
798      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
799      *
800      * Emits a {Transfer} event.
801      */
802     function transferFrom(address from, address to, uint256 tokenId) external;
803 
804     /**
805      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
806      * The approval is cleared when the token is transferred.
807      *
808      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
809      *
810      * Requirements:
811      *
812      * - The caller must own the token or be an approved operator.
813      * - `tokenId` must exist.
814      *
815      * Emits an {Approval} event.
816      */
817     function approve(address to, uint256 tokenId) external;
818 
819     /**
820      * @dev Returns the account approved for `tokenId` token.
821      *
822      * Requirements:
823      *
824      * - `tokenId` must exist.
825      */
826     function getApproved(uint256 tokenId) external view returns (address operator);
827 
828     /**
829      * @dev Approve or remove `operator` as an operator for the caller.
830      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
831      *
832      * Requirements:
833      *
834      * - The `operator` cannot be the caller.
835      *
836      * Emits an {ApprovalForAll} event.
837      */
838     function setApprovalForAll(address operator, bool _approved) external;
839 
840     /**
841      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
842      *
843      * See {setApprovalForAll}
844      */
845     function isApprovedForAll(address owner, address operator) external view returns (bool);
846 
847     /**
848       * @dev Safely transfers `tokenId` token from `from` to `to`.
849       *
850       * Requirements:
851       *
852      * - `from` cannot be the zero address.
853      * - `to` cannot be the zero address.
854       * - `tokenId` token must exist and be owned by `from`.
855       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
856       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
857       *
858       * Emits a {Transfer} event.
859       */
860     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
861 }
862 
863 // Part: OpenZeppelin/openzeppelin-contracts@3.2.0/Ownable
864 
865 /**
866  * @dev Contract module which provides a basic access control mechanism, where
867  * there is an account (an owner) that can be granted exclusive access to
868  * specific functions.
869  *
870  * By default, the owner account will be the one that deploys the contract. This
871  * can later be changed with {transferOwnership}.
872  *
873  * This module is used through inheritance. It will make available the modifier
874  * `onlyOwner`, which can be applied to your functions to restrict their use to
875  * the owner.
876  */
877 contract Ownable is Context {
878     address private _owner;
879 
880     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
881 
882     /**
883      * @dev Initializes the contract setting the deployer as the initial owner.
884      */
885     constructor () internal {
886         address msgSender = _msgSender();
887         _owner = msgSender;
888         emit OwnershipTransferred(address(0), msgSender);
889     }
890 
891     /**
892      * @dev Returns the address of the current owner.
893      */
894     function owner() public view returns (address) {
895         return _owner;
896     }
897 
898     /**
899      * @dev Throws if called by any account other than the owner.
900      */
901     modifier onlyOwner() {
902         require(_owner == _msgSender(), "Ownable: caller is not the owner");
903         _;
904     }
905 
906     /**
907      * @dev Leaves the contract without owner. It will not be possible to call
908      * `onlyOwner` functions anymore. Can only be called by the current owner.
909      *
910      * NOTE: Renouncing ownership will leave the contract without an owner,
911      * thereby removing any functionality that is only available to the owner.
912      */
913     function renounceOwnership() public virtual onlyOwner {
914         emit OwnershipTransferred(_owner, address(0));
915         _owner = address(0);
916     }
917 
918     /**
919      * @dev Transfers ownership of the contract to a new account (`newOwner`).
920      * Can only be called by the current owner.
921      */
922     function transferOwnership(address newOwner) public virtual onlyOwner {
923         require(newOwner != address(0), "Ownable: new owner is the zero address");
924         emit OwnershipTransferred(_owner, newOwner);
925         _owner = newOwner;
926     }
927 }
928 
929 // Part: IKongz
930 
931 interface IKongz is IERC721 {
932 	function getReward() external;
933 }
934 
935 // File: WrappedKongz.sol
936 
937 contract WrappedKongz is ERC20("Wrapped Genesis Kongz", "WGK"), Ownable {
938 	using SafeMath for uint256;
939 
940 	IKongz constant public KONGZ = IKongz(0x57a204AA1042f6E66DD7730813f4024114d74f37);
941 	IBanana constant public BANANA = IBanana(0xE2311ae37502105b442bBef831E9b53c5d2e9B3b);
942 	uint256 constant public END = 1931622407;
943 
944 	address public mainLpAddress;
945 
946 	uint256[] public genIds;
947 
948 	uint256 public globalScore;
949 	uint256 public globalLastUpdate;
950 	uint256 public globalClaimed;
951 
952 	mapping(address => uint256) public holderScores;
953 	mapping(address => uint256) public holderLastUpdate;
954 	mapping(address => uint256) public holderClaimed;
955 
956 	event KongzWrapped(uint256 kongId);
957 	event KongzUnwrapped(uint256 kongId);
958 	event NanasClaimed(address indexed holder, uint256 amount);
959 
960 	modifier syncScore(address _from, address _to) {
961 		uint256 time = min(block.timestamp, END);
962 		uint256 lastUpdateFrom = holderLastUpdate[_from];
963 		if (lastUpdateFrom > 0) {
964 			uint256 interval = time.sub(lastUpdateFrom);
965 			holderScores[_from] = holderScores[_from].add(balanceOf(_from).mul(interval));
966 		}
967 		if (lastUpdateFrom != END)
968 			holderLastUpdate[_from] = time;
969 		if (_to != address(0)) {
970 			uint256 lastUpdateTo = holderLastUpdate[_to];
971 			if (lastUpdateTo > 0) {
972 				uint256 interval = time.sub(lastUpdateTo);
973 				holderScores[_to] = holderScores[_to].add(balanceOf(_to).mul(interval));
974 			}
975 			if (lastUpdateTo != END)
976 				holderLastUpdate[_to] = time;
977 		}
978 		_;
979 	}
980 
981 	modifier syncGlobalScore() {
982 		uint256 time = min(block.timestamp, END);
983 		uint256 lastUpdate = globalLastUpdate;
984 		if (lastUpdate > 0) {
985 			uint256 interval = time.sub(lastUpdate);
986 			globalScore = globalScore.add(totalSupply().mul(interval));
987 		}
988 		if (lastUpdate != END)
989 			globalLastUpdate = time;
990 		_;
991 	}
992 
993 	function min(uint256 a, uint256 b) internal pure returns (uint256) {
994 		return a < b ? a : b;
995 	}
996 
997 	function _getSeed(uint256 _seed, address _sender) internal view returns (uint256) {
998 		if (_seed == 0)
999 			return uint256(keccak256(abi.encodePacked(block.timestamp, block.difficulty, _sender)));
1000 		else
1001 			return uint256(keccak256(abi.encodePacked(_seed)));
1002 	}
1003 
1004 	function _isContract(address _addr) internal view returns (bool) {
1005 		uint32 _size;
1006 		assembly {
1007 			_size:= extcodesize(_addr)
1008 		}
1009 		return (_size > 0);
1010 	}
1011 
1012 	function setLpAddress(address _lpAddress) external onlyOwner {
1013 		require(_isContract(_lpAddress));
1014 		mainLpAddress = _lpAddress;
1015 	}
1016 
1017 	function claimLpNanas() external syncScore(mainLpAddress, address(0)) syncGlobalScore() {
1018 		require(mainLpAddress != address(0), "WrappedKongz: LP address not set");
1019 		_claimNanas(mainLpAddress, owner());
1020 	}
1021 
1022 	function claimNanas() external syncScore(msg.sender, address(0)) syncGlobalScore() {
1023 		_claimNanas(msg.sender, msg.sender);
1024 	}
1025 
1026 	function _claimNanas(address _holder, address _to) internal {
1027 		uint256 totalFarmed = globalClaimed + BANANA.getTotalClaimable(address(this));
1028 		// share = (total * holder_score / total_score)
1029 		uint256 userShare = totalFarmed.mul(holderScores[_holder]).div(globalScore);
1030 		uint256 toSend = userShare.sub(holderClaimed[_holder]);
1031 		holderClaimed[_holder] = userShare;
1032 		if (BANANA.balanceOf(address(this)) < toSend) {
1033 			uint256 before = BANANA.balanceOf(address(this));
1034 			KONGZ.getReward();
1035 			uint256 post = BANANA.balanceOf(address(this));
1036 			globalClaimed = globalClaimed.add(post.sub(before));
1037 		}
1038 		BANANA.transfer(_to, toSend);
1039 		emit NanasClaimed(_holder, toSend);
1040 	}
1041 
1042 	function wrap(uint256[] calldata _kongzIdsToWrap) external syncScore(msg.sender, address(0)) syncGlobalScore() {
1043 		for (uint256 i = 0; i < _kongzIdsToWrap.length; i++) {
1044 			require(_kongzIdsToWrap[i] <= 1000, "WrappedKongz: Kongz is not genesis");
1045 			genIds.push(_kongzIdsToWrap[i]);
1046 			KONGZ.safeTransferFrom(msg.sender, address(this), _kongzIdsToWrap[i]);
1047 			emit KongzWrapped(_kongzIdsToWrap[i]);
1048 		}
1049 		_mint(msg.sender, _kongzIdsToWrap.length * 100 * (1e18));
1050 	}
1051 
1052 	function unwrap(uint256 _amount) external {
1053 		unwrapFor(_amount, msg.sender);
1054 	}
1055 
1056 	function unwrapFor(uint256 _amount, address _recipient) public syncScore(msg.sender, address(0)) syncGlobalScore() {
1057 		require(_recipient != address(0), "WrappedKongz: Cannot send to void address.");
1058 
1059 		_burn(msg.sender, _amount * 100 * (1e18));
1060 		uint256 _seed = 0;
1061 		for (uint256 i = 0; i < _amount; i++) {
1062 			_seed = _getSeed(_seed, msg.sender);
1063 			uint256 _index = _seed % genIds.length;
1064 			uint256 _tokenId = genIds[_index];
1065 
1066 			genIds[_index] = genIds[genIds.length - 1];
1067 			genIds.pop();
1068 			KONGZ.safeTransferFrom(address(this), _recipient, _tokenId);
1069 			emit KongzUnwrapped(_tokenId);
1070 		}
1071 	}
1072 
1073 	function transfer(address _to, uint256 _amount) public override syncScore(msg.sender, _to) returns (bool) {
1074 		return ERC20.transfer(_to, _amount);
1075 	}
1076 
1077 	function transferFrom(address _from, address _to, uint256 _amount) public override syncScore(_from, _to) returns (bool) {
1078 		return ERC20.transferFrom(_from, _to, _amount);
1079 	}
1080 
1081 	function getClaimableNanas(address _holder) external view returns(uint256) {
1082 		uint256 time = min(block.timestamp, END);
1083 
1084 		uint256 gInterval = time.sub(globalLastUpdate);
1085 		uint256 uInterval = time.sub(holderLastUpdate[_holder]);
1086 
1087 		uint256 _globalScore = globalScore.add(totalSupply().mul(gInterval));
1088 		uint256 userScore = holderScores[_holder].add(balanceOf(_holder).mul(uInterval));
1089 
1090 		uint256 totalFarmed = globalClaimed + BANANA.getTotalClaimable(address(this));
1091 		uint256 userShare = totalFarmed.mul(userScore).div(_globalScore);
1092 		uint256 claimable = userShare.sub(holderClaimed[_holder]);
1093 		return claimable;
1094 	}
1095 
1096 	function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4) {
1097 		return WrappedKongz.onERC721Received.selector;
1098 	}
1099 
1100 }
