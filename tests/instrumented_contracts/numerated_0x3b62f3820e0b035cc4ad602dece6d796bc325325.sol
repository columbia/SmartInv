1 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/math/SafeMath.sol
2 
3 
4 pragma solidity ^0.6.0;
5 
6 /**
7  * @dev Wrappers over Solidity's arithmetic operations with added overflow
8  * checks.
9  *
10  * Arithmetic operations in Solidity wrap on overflow. This can easily result
11  * in bugs, because programmers usually assume that an overflow raises an
12  * error, which is the standard behavior in high level programming languages.
13  * `SafeMath` restores this intuition by reverting the transaction when an
14  * operation overflows.
15  *
16  * Using this library instead of the unchecked operations eliminates an entire
17  * class of bugs, so it's recommended to use it always.
18  */
19 library SafeMath {
20     /**
21      * @dev Returns the addition of two unsigned integers, reverting on
22      * overflow.
23      *
24      * Counterpart to Solidity's `+` operator.
25      *
26      * Requirements:
27      *
28      * - Addition cannot overflow.
29      */
30     function add(uint256 a, uint256 b) internal pure returns (uint256) {
31         uint256 c = a + b;
32         require(c >= a, "SafeMath: addition overflow");
33 
34         return c;
35     }
36 
37     /**
38      * @dev Returns the subtraction of two unsigned integers, reverting on
39      * overflow (when the result is negative).
40      *
41      * Counterpart to Solidity's `-` operator.
42      *
43      * Requirements:
44      *
45      * - Subtraction cannot overflow.
46      */
47     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
48         return sub(a, b, "SafeMath: subtraction overflow");
49     }
50 
51     /**
52      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
53      * overflow (when the result is negative).
54      *
55      * Counterpart to Solidity's `-` operator.
56      *
57      * Requirements:
58      *
59      * - Subtraction cannot overflow.
60      */
61     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
62         require(b <= a, errorMessage);
63         uint256 c = a - b;
64 
65         return c;
66     }
67 
68     /**
69      * @dev Returns the multiplication of two unsigned integers, reverting on
70      * overflow.
71      *
72      * Counterpart to Solidity's `*` operator.
73      *
74      * Requirements:
75      *
76      * - Multiplication cannot overflow.
77      */
78     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
79         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
80         // benefit is lost if 'b' is also tested.
81         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
82         if (a == 0) {
83             return 0;
84         }
85 
86         uint256 c = a * b;
87         require(c / a == b, "SafeMath: multiplication overflow");
88 
89         return c;
90     }
91 
92     /**
93      * @dev Returns the integer division of two unsigned integers. Reverts on
94      * division by zero. The result is rounded towards zero.
95      *
96      * Counterpart to Solidity's `/` operator. Note: this function uses a
97      * `revert` opcode (which leaves remaining gas untouched) while Solidity
98      * uses an invalid opcode to revert (consuming all remaining gas).
99      *
100      * Requirements:
101      *
102      * - The divisor cannot be zero.
103      */
104     function div(uint256 a, uint256 b) internal pure returns (uint256) {
105         return div(a, b, "SafeMath: division by zero");
106     }
107 
108     /**
109      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
110      * division by zero. The result is rounded towards zero.
111      *
112      * Counterpart to Solidity's `/` operator. Note: this function uses a
113      * `revert` opcode (which leaves remaining gas untouched) while Solidity
114      * uses an invalid opcode to revert (consuming all remaining gas).
115      *
116      * Requirements:
117      *
118      * - The divisor cannot be zero.
119      */
120     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
121         require(b > 0, errorMessage);
122         uint256 c = a / b;
123         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
124 
125         return c;
126     }
127 
128     /**
129      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
130      * Reverts when dividing by zero.
131      *
132      * Counterpart to Solidity's `%` operator. This function uses a `revert`
133      * opcode (which leaves remaining gas untouched) while Solidity uses an
134      * invalid opcode to revert (consuming all remaining gas).
135      *
136      * Requirements:
137      *
138      * - The divisor cannot be zero.
139      */
140     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
141         return mod(a, b, "SafeMath: modulo by zero");
142     }
143 
144     /**
145      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
146      * Reverts with custom message when dividing by zero.
147      *
148      * Counterpart to Solidity's `%` operator. This function uses a `revert`
149      * opcode (which leaves remaining gas untouched) while Solidity uses an
150      * invalid opcode to revert (consuming all remaining gas).
151      *
152      * Requirements:
153      *
154      * - The divisor cannot be zero.
155      */
156     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
157         require(b != 0, errorMessage);
158         return a % b;
159     }
160 }
161 
162 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/IERC20.sol
163 
164 
165 pragma solidity ^0.6.0;
166 
167 /**
168  * @dev Interface of the ERC20 standard as defined in the EIP.
169  */
170 interface IERC20 {
171     /**
172      * @dev Returns the amount of tokens in existence.
173      */
174     function totalSupply() external view returns (uint256);
175 
176     /**
177      * @dev Returns the amount of tokens owned by `account`.
178      */
179     function balanceOf(address account) external view returns (uint256);
180 
181     /**
182      * @dev Moves `amount` tokens from the caller's account to `recipient`.
183      *
184      * Returns a boolean value indicating whether the operation succeeded.
185      *
186      * Emits a {Transfer} event.
187      */
188     function transfer(address recipient, uint256 amount) external returns (bool);
189 
190     /**
191      * @dev Returns the remaining number of tokens that `spender` will be
192      * allowed to spend on behalf of `owner` through {transferFrom}. This is
193      * zero by default.
194      *
195      * This value changes when {approve} or {transferFrom} are called.
196      */
197     function allowance(address owner, address spender) external view returns (uint256);
198 
199     /**
200      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
201      *
202      * Returns a boolean value indicating whether the operation succeeded.
203      *
204      * IMPORTANT: Beware that changing an allowance with this method brings the risk
205      * that someone may use both the old and the new allowance by unfortunate
206      * transaction ordering. One possible solution to mitigate this race
207      * condition is to first reduce the spender's allowance to 0 and set the
208      * desired value afterwards:
209      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
210      *
211      * Emits an {Approval} event.
212      */
213     function approve(address spender, uint256 amount) external returns (bool);
214 
215     /**
216      * @dev Moves `amount` tokens from `sender` to `recipient` using the
217      * allowance mechanism. `amount` is then deducted from the caller's
218      * allowance.
219      *
220      * Returns a boolean value indicating whether the operation succeeded.
221      *
222      * Emits a {Transfer} event.
223      */
224     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
225 
226     /**
227      * @dev Emitted when `value` tokens are moved from one account (`from`) to
228      * another (`to`).
229      *
230      * Note that `value` may be zero.
231      */
232     event Transfer(address indexed from, address indexed to, uint256 value);
233 
234     /**
235      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
236      * a call to {approve}. `value` is the new allowance.
237      */
238     event Approval(address indexed owner, address indexed spender, uint256 value);
239 }
240 
241 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/token/ERC20/ERC20.sol
242 
243 
244 pragma solidity ^0.6.0;
245 
246 
247 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/GSN/Context.sol
248 
249 
250 pragma solidity ^0.6.0;
251 
252 /*
253  * @dev Provides information about the current execution context, including the
254  * sender of the transaction and its data. While these are generally available
255  * via msg.sender and msg.data, they should not be accessed in such a direct
256  * manner, since when dealing with GSN meta-transactions the account sending and
257  * paying for execution may not be the actual sender (as far as an application
258  * is concerned).
259  *
260  * This contract is only required for intermediate, library-like contracts.
261  */
262 abstract contract Context {
263     function _msgSender() internal view virtual returns (address payable) {
264         return msg.sender;
265     }
266 
267     function _msgData() internal view virtual returns (bytes memory) {
268         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
269         return msg.data;
270     }
271 }
272 
273 
274 /**
275  * @dev Implementation of the {IERC20} interface.
276  *
277  * This implementation is agnostic to the way tokens are created. This means
278  * that a supply mechanism has to be added in a derived contract using {_mint}.
279  * For a generic mechanism see {ERC20PresetMinterPauser}.
280  *
281  * TIP: For a detailed writeup see our guide
282  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
283  * to implement supply mechanisms].
284  *
285  * We have followed general OpenZeppelin guidelines: functions revert instead
286  * of returning `false` on failure. This behavior is nonetheless conventional
287  * and does not conflict with the expectations of ERC20 applications.
288  *
289  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
290  * This allows applications to reconstruct the allowance for all accounts just
291  * by listening to said events. Other implementations of the EIP may not emit
292  * these events, as it isn't required by the specification.
293  *
294  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
295  * functions have been added to mitigate the well-known issues around setting
296  * allowances. See {IERC20-approve}.
297  */
298 contract ERC20 is Context, IERC20 {
299     using SafeMath for uint256;
300     using Address for address;
301 
302     mapping (address => uint256) private _balances;
303 
304     mapping (address => mapping (address => uint256)) private _allowances;
305 
306     uint256 private _totalSupply;
307 
308     string private _name;
309     string private _symbol;
310     uint8 private _decimals;
311 
312     /**
313      * @dev Sets the values for {name} and {symbol}, initializes {decimals} with
314      * a default value of 18.
315      *
316      * To select a different value for {decimals}, use {_setupDecimals}.
317      *
318      * All three of these values are immutable: they can only be set once during
319      * construction.
320      */
321     constructor (string memory name, string memory symbol) public {
322         _name = name;
323         _symbol = symbol;
324         _decimals = 18;
325     }
326 
327     /**
328      * @dev Returns the name of the token.
329      */
330     function name() public view returns (string memory) {
331         return _name;
332     }
333 
334     /**
335      * @dev Returns the symbol of the token, usually a shorter version of the
336      * name.
337      */
338     function symbol() public view returns (string memory) {
339         return _symbol;
340     }
341 
342     /**
343      * @dev Returns the number of decimals used to get its user representation.
344      * For example, if `decimals` equals `2`, a balance of `505` tokens should
345      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
346      *
347      * Tokens usually opt for a value of 18, imitating the relationship between
348      * Ether and Wei. This is the value {ERC20} uses, unless {_setupDecimals} is
349      * called.
350      *
351      * NOTE: This information is only used for _display_ purposes: it in
352      * no way affects any of the arithmetic of the contract, including
353      * {IERC20-balanceOf} and {IERC20-transfer}.
354      */
355     function decimals() public view returns (uint8) {
356         return _decimals;
357     }
358 
359     /**
360      * @dev See {IERC20-totalSupply}.
361      */
362     function totalSupply() public view override returns (uint256) {
363         return _totalSupply;
364     }
365 
366     /**
367      * @dev See {IERC20-balanceOf}.
368      */
369     function balanceOf(address account) public view override returns (uint256) {
370         return _balances[account];
371     }
372 
373     /**
374      * @dev See {IERC20-transfer}.
375      *
376      * Requirements:
377      *
378      * - `recipient` cannot be the zero address.
379      * - the caller must have a balance of at least `amount`.
380      */
381     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
382         _transfer(_msgSender(), recipient, amount);
383         return true;
384     }
385 
386     /**
387      * @dev See {IERC20-allowance}.
388      */
389     function allowance(address owner, address spender) public view virtual override returns (uint256) {
390         return _allowances[owner][spender];
391     }
392 
393     /**
394      * @dev See {IERC20-approve}.
395      *
396      * Requirements:
397      *
398      * - `spender` cannot be the zero address.
399      */
400     function approve(address spender, uint256 amount) public virtual override returns (bool) {
401         _approve(_msgSender(), spender, amount);
402         return true;
403     }
404 
405     /**
406      * @dev See {IERC20-transferFrom}.
407      *
408      * Emits an {Approval} event indicating the updated allowance. This is not
409      * required by the EIP. See the note at the beginning of {ERC20};
410      *
411      * Requirements:
412      * - `sender` and `recipient` cannot be the zero address.
413      * - `sender` must have a balance of at least `amount`.
414      * - the caller must have allowance for ``sender``'s tokens of at least
415      * `amount`.
416      */
417     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
418         _transfer(sender, recipient, amount);
419         _approve(sender, _msgSender(), _allowances[sender][_msgSender()].sub(amount, "ERC20: transfer amount exceeds allowance"));
420         return true;
421     }
422 
423     /**
424      * @dev Atomically increases the allowance granted to `spender` by the caller.
425      *
426      * This is an alternative to {approve} that can be used as a mitigation for
427      * problems described in {IERC20-approve}.
428      *
429      * Emits an {Approval} event indicating the updated allowance.
430      *
431      * Requirements:
432      *
433      * - `spender` cannot be the zero address.
434      */
435     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
436         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].add(addedValue));
437         return true;
438     }
439 
440     /**
441      * @dev Atomically decreases the allowance granted to `spender` by the caller.
442      *
443      * This is an alternative to {approve} that can be used as a mitigation for
444      * problems described in {IERC20-approve}.
445      *
446      * Emits an {Approval} event indicating the updated allowance.
447      *
448      * Requirements:
449      *
450      * - `spender` cannot be the zero address.
451      * - `spender` must have allowance for the caller of at least
452      * `subtractedValue`.
453      */
454     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
455         _approve(_msgSender(), spender, _allowances[_msgSender()][spender].sub(subtractedValue, "ERC20: decreased allowance below zero"));
456         return true;
457     }
458 
459     /**
460      * @dev Moves tokens `amount` from `sender` to `recipient`.
461      *
462      * This is internal function is equivalent to {transfer}, and can be used to
463      * e.g. implement automatic token fees, slashing mechanisms, etc.
464      *
465      * Emits a {Transfer} event.
466      *
467      * Requirements:
468      *
469      * - `sender` cannot be the zero address.
470      * - `recipient` cannot be the zero address.
471      * - `sender` must have a balance of at least `amount`.
472      */
473     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
474         require(sender != address(0), "ERC20: transfer from the zero address");
475         require(recipient != address(0), "ERC20: transfer to the zero address");
476 
477         _beforeTokenTransfer(sender, recipient, amount);
478 
479         _balances[sender] = _balances[sender].sub(amount, "ERC20: transfer amount exceeds balance");
480         _balances[recipient] = _balances[recipient].add(amount);
481         emit Transfer(sender, recipient, amount);
482     }
483 
484     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
485      * the total supply.
486      *
487      * Emits a {Transfer} event with `from` set to the zero address.
488      *
489      * Requirements
490      *
491      * - `to` cannot be the zero address.
492      */
493     function _mint(address account, uint256 amount) internal virtual {
494         require(account != address(0), "ERC20: mint to the zero address");
495 
496         _beforeTokenTransfer(address(0), account, amount);
497 
498         _totalSupply = _totalSupply.add(amount);
499         _balances[account] = _balances[account].add(amount);
500         emit Transfer(address(0), account, amount);
501     }
502 
503     /**
504      * @dev Destroys `amount` tokens from `account`, reducing the
505      * total supply.
506      *
507      * Emits a {Transfer} event with `to` set to the zero address.
508      *
509      * Requirements
510      *
511      * - `account` cannot be the zero address.
512      * - `account` must have at least `amount` tokens.
513      */
514     function _burn(address account, uint256 amount) internal virtual {
515         require(account != address(0), "ERC20: burn from the zero address");
516 
517         _beforeTokenTransfer(account, address(0), amount);
518 
519         _balances[account] = _balances[account].sub(amount, "ERC20: burn amount exceeds balance");
520         _totalSupply = _totalSupply.sub(amount);
521         emit Transfer(account, address(0), amount);
522     }
523 
524     /**
525      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
526      *
527      * This internal function is equivalent to `approve`, and can be used to
528      * e.g. set automatic allowances for certain subsystems, etc.
529      *
530      * Emits an {Approval} event.
531      *
532      * Requirements:
533      *
534      * - `owner` cannot be the zero address.
535      * - `spender` cannot be the zero address.
536      */
537     function _approve(address owner, address spender, uint256 amount) internal virtual {
538         require(owner != address(0), "ERC20: approve from the zero address");
539         require(spender != address(0), "ERC20: approve to the zero address");
540 
541         _allowances[owner][spender] = amount;
542         emit Approval(owner, spender, amount);
543     }
544 
545     /**
546      * @dev Sets {decimals} to a value other than the default one of 18.
547      *
548      * WARNING: This function should only be called from the constructor. Most
549      * applications that interact with token contracts will not expect
550      * {decimals} to ever change, and may work incorrectly if it does.
551      */
552     function _setupDecimals(uint8 decimals_) internal {
553         _decimals = decimals_;
554     }
555 
556     /**
557      * @dev Hook that is called before any transfer of tokens. This includes
558      * minting and burning.
559      *
560      * Calling conditions:
561      *
562      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
563      * will be to transferred to `to`.
564      * - when `from` is zero, `amount` tokens will be minted for `to`.
565      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
566      * - `from` and `to` are never both zero.
567      *
568      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
569      */
570     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
571 }
572 
573 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/Address.sol
574 
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
600         // This method relies on extcodesize, which returns 0 for contracts in
601         // construction, since the code is only stored at the end of the
602         // constructor execution.
603 
604         uint256 size;
605         // solhint-disable-next-line no-inline-assembly
606         assembly { size := extcodesize(account) }
607         return size > 0;
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
716 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/EnumerableSet.sol
717 
718 
719 pragma solidity ^0.6.0;
720 
721 /**
722  * @dev Library for managing
723  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
724  * types.
725  *
726  * Sets have the following properties:
727  *
728  * - Elements are added, removed, and checked for existence in constant time
729  * (O(1)).
730  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
731  *
732  * ```
733  * contract Example {
734  *     // Add the library methods
735  *     using EnumerableSet for EnumerableSet.AddressSet;
736  *
737  *     // Declare a set state variable
738  *     EnumerableSet.AddressSet private mySet;
739  * }
740  * ```
741  *
742  * As of v3.0.0, only sets of type `address` (`AddressSet`) and `uint256`
743  * (`UintSet`) are supported.
744  */
745 library EnumerableSet {
746     // To implement this library for multiple types with as little code
747     // repetition as possible, we write it in terms of a generic Set type with
748     // bytes32 values.
749     // The Set implementation uses private functions, and user-facing
750     // implementations (such as AddressSet) are just wrappers around the
751     // underlying Set.
752     // This means that we can only create new EnumerableSets for types that fit
753     // in bytes32.
754 
755     struct Set {
756         // Storage of set values
757         bytes32[] _values;
758 
759         // Position of the value in the `values` array, plus 1 because index 0
760         // means a value is not in the set.
761         mapping (bytes32 => uint256) _indexes;
762     }
763 
764     /**
765      * @dev Add a value to a set. O(1).
766      *
767      * Returns true if the value was added to the set, that is if it was not
768      * already present.
769      */
770     function _add(Set storage set, bytes32 value) private returns (bool) {
771         if (!_contains(set, value)) {
772             set._values.push(value);
773             // The value is stored at length-1, but we add 1 to all indexes
774             // and use 0 as a sentinel value
775             set._indexes[value] = set._values.length;
776             return true;
777         } else {
778             return false;
779         }
780     }
781 
782     /**
783      * @dev Removes a value from a set. O(1).
784      *
785      * Returns true if the value was removed from the set, that is if it was
786      * present.
787      */
788     function _remove(Set storage set, bytes32 value) private returns (bool) {
789         // We read and store the value's index to prevent multiple reads from the same storage slot
790         uint256 valueIndex = set._indexes[value];
791 
792         if (valueIndex != 0) { // Equivalent to contains(set, value)
793             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
794             // the array, and then remove the last element (sometimes called as 'swap and pop').
795             // This modifies the order of the array, as noted in {at}.
796 
797             uint256 toDeleteIndex = valueIndex - 1;
798             uint256 lastIndex = set._values.length - 1;
799 
800             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
801             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
802 
803             bytes32 lastvalue = set._values[lastIndex];
804 
805             // Move the last value to the index where the value to delete is
806             set._values[toDeleteIndex] = lastvalue;
807             // Update the index for the moved value
808             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
809 
810             // Delete the slot where the moved value was stored
811             set._values.pop();
812 
813             // Delete the index for the deleted slot
814             delete set._indexes[value];
815 
816             return true;
817         } else {
818             return false;
819         }
820     }
821 
822     /**
823      * @dev Returns true if the value is in the set. O(1).
824      */
825     function _contains(Set storage set, bytes32 value) private view returns (bool) {
826         return set._indexes[value] != 0;
827     }
828 
829     /**
830      * @dev Returns the number of values on the set. O(1).
831      */
832     function _length(Set storage set) private view returns (uint256) {
833         return set._values.length;
834     }
835 
836    /**
837     * @dev Returns the value stored at position `index` in the set. O(1).
838     *
839     * Note that there are no guarantees on the ordering of values inside the
840     * array, and it may change when more values are added or removed.
841     *
842     * Requirements:
843     *
844     * - `index` must be strictly less than {length}.
845     */
846     function _at(Set storage set, uint256 index) private view returns (bytes32) {
847         require(set._values.length > index, "EnumerableSet: index out of bounds");
848         return set._values[index];
849     }
850 
851     // AddressSet
852 
853     struct AddressSet {
854         Set _inner;
855     }
856 
857     /**
858      * @dev Add a value to a set. O(1).
859      *
860      * Returns true if the value was added to the set, that is if it was not
861      * already present.
862      */
863     function add(AddressSet storage set, address value) internal returns (bool) {
864         return _add(set._inner, bytes32(uint256(value)));
865     }
866 
867     /**
868      * @dev Removes a value from a set. O(1).
869      *
870      * Returns true if the value was removed from the set, that is if it was
871      * present.
872      */
873     function remove(AddressSet storage set, address value) internal returns (bool) {
874         return _remove(set._inner, bytes32(uint256(value)));
875     }
876 
877     /**
878      * @dev Returns true if the value is in the set. O(1).
879      */
880     function contains(AddressSet storage set, address value) internal view returns (bool) {
881         return _contains(set._inner, bytes32(uint256(value)));
882     }
883 
884     /**
885      * @dev Returns the number of values in the set. O(1).
886      */
887     function length(AddressSet storage set) internal view returns (uint256) {
888         return _length(set._inner);
889     }
890 
891    /**
892     * @dev Returns the value stored at position `index` in the set. O(1).
893     *
894     * Note that there are no guarantees on the ordering of values inside the
895     * array, and it may change when more values are added or removed.
896     *
897     * Requirements:
898     *
899     * - `index` must be strictly less than {length}.
900     */
901     function at(AddressSet storage set, uint256 index) internal view returns (address) {
902         return address(uint256(_at(set._inner, index)));
903     }
904 
905 
906     // UintSet
907 
908     struct UintSet {
909         Set _inner;
910     }
911 
912     /**
913      * @dev Add a value to a set. O(1).
914      *
915      * Returns true if the value was added to the set, that is if it was not
916      * already present.
917      */
918     function add(UintSet storage set, uint256 value) internal returns (bool) {
919         return _add(set._inner, bytes32(value));
920     }
921 
922     /**
923      * @dev Removes a value from a set. O(1).
924      *
925      * Returns true if the value was removed from the set, that is if it was
926      * present.
927      */
928     function remove(UintSet storage set, uint256 value) internal returns (bool) {
929         return _remove(set._inner, bytes32(value));
930     }
931 
932     /**
933      * @dev Returns true if the value is in the set. O(1).
934      */
935     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
936         return _contains(set._inner, bytes32(value));
937     }
938 
939     /**
940      * @dev Returns the number of values on the set. O(1).
941      */
942     function length(UintSet storage set) internal view returns (uint256) {
943         return _length(set._inner);
944     }
945 
946    /**
947     * @dev Returns the value stored at position `index` in the set. O(1).
948     *
949     * Note that there are no guarantees on the ordering of values inside the
950     * array, and it may change when more values are added or removed.
951     *
952     * Requirements:
953     *
954     * - `index` must be strictly less than {length}.
955     */
956     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
957         return uint256(_at(set._inner, index));
958     }
959 }
960 
961 // File: https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/access/AccessControl.sol
962 
963 
964 pragma solidity ^0.6.0;
965 
966 
967 
968 
969 /**
970  * @dev Contract module that allows children to implement role-based access
971  * control mechanisms.
972  *
973  * Roles are referred to by their `bytes32` identifier. These should be exposed
974  * in the external API and be unique. The best way to achieve this is by
975  * using `public constant` hash digests:
976  *
977  * ```
978  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
979  * ```
980  *
981  * Roles can be used to represent a set of permissions. To restrict access to a
982  * function call, use {hasRole}:
983  *
984  * ```
985  * function foo() public {
986  *     require(hasRole(MY_ROLE, msg.sender));
987  *     ...
988  * }
989  * ```
990  *
991  * Roles can be granted and revoked dynamically via the {grantRole} and
992  * {revokeRole} functions. Each role has an associated admin role, and only
993  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
994  *
995  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
996  * that only accounts with this role will be able to grant or revoke other
997  * roles. More complex role relationships can be created by using
998  * {_setRoleAdmin}.
999  *
1000  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
1001  * grant and revoke this role. Extra precautions should be taken to secure
1002  * accounts that have been granted it.
1003  */
1004 abstract contract AccessControl is Context {
1005     using EnumerableSet for EnumerableSet.AddressSet;
1006     using Address for address;
1007 
1008     struct RoleData {
1009         EnumerableSet.AddressSet members;
1010         bytes32 adminRole;
1011     }
1012 
1013     mapping (bytes32 => RoleData) private _roles;
1014 
1015     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
1016 
1017     /**
1018      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
1019      *
1020      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
1021      * {RoleAdminChanged} not being emitted signaling this.
1022      *
1023      * _Available since v3.1._
1024      */
1025     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
1026 
1027     /**
1028      * @dev Emitted when `account` is granted `role`.
1029      *
1030      * `sender` is the account that originated the contract call, an admin role
1031      * bearer except when using {_setupRole}.
1032      */
1033     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
1034 
1035     /**
1036      * @dev Emitted when `account` is revoked `role`.
1037      *
1038      * `sender` is the account that originated the contract call:
1039      *   - if using `revokeRole`, it is the admin role bearer
1040      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
1041      */
1042     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
1043 
1044     /**
1045      * @dev Returns `true` if `account` has been granted `role`.
1046      */
1047     function hasRole(bytes32 role, address account) public view returns (bool) {
1048         return _roles[role].members.contains(account);
1049     }
1050 
1051     /**
1052      * @dev Returns the number of accounts that have `role`. Can be used
1053      * together with {getRoleMember} to enumerate all bearers of a role.
1054      */
1055     function getRoleMemberCount(bytes32 role) public view returns (uint256) {
1056         return _roles[role].members.length();
1057     }
1058 
1059     /**
1060      * @dev Returns one of the accounts that have `role`. `index` must be a
1061      * value between 0 and {getRoleMemberCount}, non-inclusive.
1062      *
1063      * Role bearers are not sorted in any particular way, and their ordering may
1064      * change at any point.
1065      *
1066      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
1067      * you perform all queries on the same block. See the following
1068      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
1069      * for more information.
1070      */
1071     function getRoleMember(bytes32 role, uint256 index) public view returns (address) {
1072         return _roles[role].members.at(index);
1073     }
1074 
1075     /**
1076      * @dev Returns the admin role that controls `role`. See {grantRole} and
1077      * {revokeRole}.
1078      *
1079      * To change a role's admin, use {_setRoleAdmin}.
1080      */
1081     function getRoleAdmin(bytes32 role) public view returns (bytes32) {
1082         return _roles[role].adminRole;
1083     }
1084 
1085     /**
1086      * @dev Grants `role` to `account`.
1087      *
1088      * If `account` had not been already granted `role`, emits a {RoleGranted}
1089      * event.
1090      *
1091      * Requirements:
1092      *
1093      * - the caller must have ``role``'s admin role.
1094      */
1095     function grantRole(bytes32 role, address account) public virtual {
1096         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to grant");
1097 
1098         _grantRole(role, account);
1099     }
1100 
1101     /**
1102      * @dev Revokes `role` from `account`.
1103      *
1104      * If `account` had been granted `role`, emits a {RoleRevoked} event.
1105      *
1106      * Requirements:
1107      *
1108      * - the caller must have ``role``'s admin role.
1109      */
1110     function revokeRole(bytes32 role, address account) public virtual {
1111         require(hasRole(_roles[role].adminRole, _msgSender()), "AccessControl: sender must be an admin to revoke");
1112 
1113         _revokeRole(role, account);
1114     }
1115 
1116     /**
1117      * @dev Revokes `role` from the calling account.
1118      *
1119      * Roles are often managed via {grantRole} and {revokeRole}: this function's
1120      * purpose is to provide a mechanism for accounts to lose their privileges
1121      * if they are compromised (such as when a trusted device is misplaced).
1122      *
1123      * If the calling account had been granted `role`, emits a {RoleRevoked}
1124      * event.
1125      *
1126      * Requirements:
1127      *
1128      * - the caller must be `account`.
1129      */
1130     function renounceRole(bytes32 role, address account) public virtual {
1131         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
1132 
1133         _revokeRole(role, account);
1134     }
1135 
1136     /**
1137      * @dev Grants `role` to `account`.
1138      *
1139      * If `account` had not been already granted `role`, emits a {RoleGranted}
1140      * event. Note that unlike {grantRole}, this function doesn't perform any
1141      * checks on the calling account.
1142      *
1143      * [WARNING]
1144      * ====
1145      * This function should only be called from the constructor when setting
1146      * up the initial roles for the system.
1147      *
1148      * Using this function in any other way is effectively circumventing the admin
1149      * system imposed by {AccessControl}.
1150      * ====
1151      */
1152     function _setupRole(bytes32 role, address account) internal virtual {
1153         _grantRole(role, account);
1154     }
1155 
1156     /**
1157      * @dev Sets `adminRole` as ``role``'s admin role.
1158      *
1159      * Emits a {RoleAdminChanged} event.
1160      */
1161     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
1162         emit RoleAdminChanged(role, _roles[role].adminRole, adminRole);
1163         _roles[role].adminRole = adminRole;
1164     }
1165 
1166     function _grantRole(bytes32 role, address account) private {
1167         if (_roles[role].members.add(account)) {
1168             emit RoleGranted(role, account, _msgSender());
1169         }
1170     }
1171 
1172     function _revokeRole(bytes32 role, address account) private {
1173         if (_roles[role].members.remove(account)) {
1174             emit RoleRevoked(role, account, _msgSender());
1175         }
1176     }
1177 }
1178 
1179 // File: browser/DEUXToken.sol
1180 
1181 //Be name khoda
1182 
1183 //SPDX-License-Identifier: MIT
1184 
1185 pragma solidity ^0.6.12;
1186 
1187 
1188 
1189 contract DEUSToken is ERC20, AccessControl{
1190 
1191 	uint256 public currentPointIndex = 0;
1192 
1193 	bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1194 	bytes32 public constant BURNER_ROLE = keccak256("BURNER_ROLE");
1195 	bytes32 public constant CURRENT_POINT_INDEX_SETTER_ROLE = keccak256("CURRENT_POINT_INDEX_SETTER_ROLE");
1196 
1197 	constructor() public ERC20("DEUS", "DEUS") {
1198 		_setupRole(DEFAULT_ADMIN_ROLE, msg.sender);	
1199 	}
1200 
1201 	function mint(address to, uint256 amount) public {
1202         // Check that the calling account has the minter role
1203         require(hasRole(MINTER_ROLE, msg.sender), "Caller is not a minter");
1204         _mint(to, amount);
1205     }
1206 
1207 	function burn(address from, uint256 amount) public {
1208         require(hasRole(BURNER_ROLE, msg.sender), "Caller is not a burner");
1209         _burn(from, amount);
1210     }
1211 
1212 	function setCurrentPointIndex(uint256 _currentPointIndex) public {
1213 		require(hasRole(CURRENT_POINT_INDEX_SETTER_ROLE, msg.sender), "Caller is not a currentPointIndex setter");
1214 		currentPointIndex = _currentPointIndex;
1215 	}
1216 
1217 }
1218 //Dar panah khoda