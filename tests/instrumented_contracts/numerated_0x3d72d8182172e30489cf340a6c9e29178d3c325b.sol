1 pragma solidity ^0.7.6;
2 
3 
4 /*
5  * @dev Provides information about the current execution context, including the
6  * sender of the transaction and its data. While these are generally available
7  * via msg.sender and msg.data, they should not be accessed in such a direct
8  * manner, since when dealing with meta-transactions the account sending and
9  * paying for execution may not be the actual sender (as far as an application
10  * is concerned).
11  *
12  * This contract is only required for intermediate, library-like contracts.
13  */
14 abstract contract Context {
15     function _msgSender() internal view virtual returns (address) {
16         return msg.sender;
17     }
18 
19     function _msgData() internal view virtual returns (bytes calldata) {
20         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
21         return msg.data;
22     }
23 }
24 
25 /**
26  * @dev Collection of functions related to the address type
27  */
28 library Address {
29     /**
30      * @dev Returns true if `account` is a contract.
31      *
32      * [IMPORTANT]
33      * ====
34      * It is unsafe to assume that an address for which this function returns
35      * false is an externally-owned account (EOA) and not a contract.
36      *
37      * Among others, `isContract` will return false for the following
38      * types of addresses:
39      *
40      *  - an externally-owned account
41      *  - a contract in construction
42      *  - an address where a contract will be created
43      *  - an address where a contract lived, but was destroyed
44      * ====
45      */
46     function isContract(address account) internal view returns (bool) {
47         // This method relies on extcodesize, which returns 0 for contracts in
48         // construction, since the code is only stored at the end of the
49         // constructor execution.
50 
51         uint256 size;
52         // solhint-disable-next-line no-inline-assembly
53         assembly { size := extcodesize(account) }
54         return size > 0;
55     }
56 
57     /**
58      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
59      * `recipient`, forwarding all available gas and reverting on errors.
60      *
61      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
62      * of certain opcodes, possibly making contracts go over the 2300 gas limit
63      * imposed by `transfer`, making them unable to receive funds via
64      * `transfer`. {sendValue} removes this limitation.
65      *
66      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
67      *
68      * IMPORTANT: because control is transferred to `recipient`, care must be
69      * taken to not create reentrancy vulnerabilities. Consider using
70      * {ReentrancyGuard} or the
71      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
72      */
73     function sendValue(address payable recipient, uint256 amount) internal {
74         require(address(this).balance >= amount, "Address: insufficient balance");
75 
76         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
77         (bool success, ) = recipient.call{ value: amount }("");
78         require(success, "Address: unable to send value, recipient may have reverted");
79     }
80 
81     /**
82      * @dev Performs a Solidity function call using a low level `call`. A
83      * plain`call` is an unsafe replacement for a function call: use this
84      * function instead.
85      *
86      * If `target` reverts with a revert reason, it is bubbled up by this
87      * function (like regular Solidity function calls).
88      *
89      * Returns the raw returned data. To convert to the expected return value,
90      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
91      *
92      * Requirements:
93      *
94      * - `target` must be a contract.
95      * - calling `target` with `data` must not revert.
96      *
97      * _Available since v3.1._
98      */
99     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
100       return functionCall(target, data, "Address: low-level call failed");
101     }
102 
103     /**
104      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
105      * `errorMessage` as a fallback revert reason when `target` reverts.
106      *
107      * _Available since v3.1._
108      */
109     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
110         return functionCallWithValue(target, data, 0, errorMessage);
111     }
112 
113     /**
114      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
115      * but also transferring `value` wei to `target`.
116      *
117      * Requirements:
118      *
119      * - the calling contract must have an ETH balance of at least `value`.
120      * - the called Solidity function must be `payable`.
121      *
122      * _Available since v3.1._
123      */
124     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
125         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
126     }
127 
128     /**
129      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
130      * with `errorMessage` as a fallback revert reason when `target` reverts.
131      *
132      * _Available since v3.1._
133      */
134     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
135         require(address(this).balance >= value, "Address: insufficient balance for call");
136         require(isContract(target), "Address: call to non-contract");
137 
138         // solhint-disable-next-line avoid-low-level-calls
139         (bool success, bytes memory returndata) = target.call{ value: value }(data);
140         return _verifyCallResult(success, returndata, errorMessage);
141     }
142 
143     /**
144      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
145      * but performing a static call.
146      *
147      * _Available since v3.3._
148      */
149     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
150         return functionStaticCall(target, data, "Address: low-level static call failed");
151     }
152 
153     /**
154      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
155      * but performing a static call.
156      *
157      * _Available since v3.3._
158      */
159     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
160         require(isContract(target), "Address: static call to non-contract");
161 
162         // solhint-disable-next-line avoid-low-level-calls
163         (bool success, bytes memory returndata) = target.staticcall(data);
164         return _verifyCallResult(success, returndata, errorMessage);
165     }
166 
167     /**
168      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
169      * but performing a delegate call.
170      *
171      * _Available since v3.4._
172      */
173     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
174         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
175     }
176 
177     /**
178      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
179      * but performing a delegate call.
180      *
181      * _Available since v3.4._
182      */
183     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
184         require(isContract(target), "Address: delegate call to non-contract");
185 
186         // solhint-disable-next-line avoid-low-level-calls
187         (bool success, bytes memory returndata) = target.delegatecall(data);
188         return _verifyCallResult(success, returndata, errorMessage);
189     }
190 
191     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
192         if (success) {
193             return returndata;
194         } else {
195             // Look for revert reason and bubble it up if present
196             if (returndata.length > 0) {
197                 // The easiest way to bubble the revert reason is using memory via assembly
198 
199                 // solhint-disable-next-line no-inline-assembly
200                 assembly {
201                     let returndata_size := mload(returndata)
202                     revert(add(32, returndata), returndata_size)
203                 }
204             } else {
205                 revert(errorMessage);
206             }
207         }
208     }
209 }
210 
211 
212 /**
213  * @dev Interface of the ERC20 standard as defined in the EIP.
214  */
215 interface IERC20 {
216     /**
217      * @dev Returns the amount of tokens in existence.
218      */
219     function totalSupply() external view returns (uint256);
220 
221     /**
222      * @dev Returns the amount of tokens owned by `account`.
223      */
224     function balanceOf(address account) external view returns (uint256);
225 
226     /**
227      * @dev Moves `amount` tokens from the caller's account to `recipient`.
228      *
229      * Returns a boolean value indicating whether the operation succeeded.
230      *
231      * Emits a {Transfer} event.
232      */
233     function transfer(address recipient, uint256 amount) external returns (bool);
234 
235     /**
236      * @dev Returns the remaining number of tokens that `spender` will be
237      * allowed to spend on behalf of `owner` through {transferFrom}. This is
238      * zero by default.
239      *
240      * This value changes when {approve} or {transferFrom} are called.
241      */
242     function allowance(address owner, address spender) external view returns (uint256);
243 
244     /**
245      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
246      *
247      * Returns a boolean value indicating whether the operation succeeded.
248      *
249      * IMPORTANT: Beware that changing an allowance with this method brings the risk
250      * that someone may use both the old and the new allowance by unfortunate
251      * transaction ordering. One possible solution to mitigate this race
252      * condition is to first reduce the spender's allowance to 0 and set the
253      * desired value afterwards:
254      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
255      *
256      * Emits an {Approval} event.
257      */
258     function approve(address spender, uint256 amount) external returns (bool);
259 
260     /**
261      * @dev Moves `amount` tokens from `sender` to `recipient` using the
262      * allowance mechanism. `amount` is then deducted from the caller's
263      * allowance.
264      *
265      * Returns a boolean value indicating whether the operation succeeded.
266      *
267      * Emits a {Transfer} event.
268      */
269     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
270 
271     /**
272      * @dev Emitted when `value` tokens are moved from one account (`from`) to
273      * another (`to`).
274      *
275      * Note that `value` may be zero.
276      */
277     event Transfer(address indexed from, address indexed to, uint256 value);
278 
279     /**
280      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
281      * a call to {approve}. `value` is the new allowance.
282      */
283     event Approval(address indexed owner, address indexed spender, uint256 value);
284 }
285 
286 /**
287  * @dev Interface for the optional metadata functions from the ERC20 standard.
288  */
289 interface IERC20Metadata is IERC20 {
290     /**
291      * @dev Returns the name of the token.
292      */
293     function name() external view returns (string memory);
294 
295     /**
296      * @dev Returns the symbol of the token.
297      */
298     function symbol() external view returns (string memory);
299 
300     /**
301      * @dev Returns the decimals places of the token.
302      */
303     function decimals() external view returns (uint8);
304 }
305 
306 /**
307  * @dev Implementation of the {IERC20} interface.
308  *
309  * This implementation is agnostic to the way tokens are created. This means
310  * that a supply mechanism has to be added in a derived contract using {_mint}.
311  * For a generic mechanism see {ERC20PresetMinterPauser}.
312  *
313  * TIP: For a detailed writeup see our guide
314  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
315  * to implement supply mechanisms].
316  *
317  * We have followed general OpenZeppelin guidelines: functions revert instead
318  * of returning `false` on failure. This behavior is nonetheless conventional
319  * and does not conflict with the expectations of ERC20 applications.
320  *
321  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
322  * This allows applications to reconstruct the allowance for all accounts just
323  * by listening to said events. Other implementations of the EIP may not emit
324  * these events, as it isn't required by the specification.
325  *
326  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
327  * functions have been added to mitigate the well-known issues around setting
328  * allowances. See {IERC20-approve}.
329  */
330 contract ERC20 is Context, IERC20, IERC20Metadata {
331     mapping (address => uint256) private _balances;
332 
333     mapping (address => mapping (address => uint256)) private _allowances;
334 
335     uint256 private _totalSupply;
336 
337     string private _name;
338     string private _symbol;
339 
340     /**
341      * @dev Sets the values for {name} and {symbol}.
342      *
343      * The defaut value of {decimals} is 18. To select a different value for
344      * {decimals} you should overload it.
345      *
346      * All two of these values are immutable: they can only be set once during
347      * construction.
348      */
349     constructor (string memory name_, string memory symbol_) {
350         _name = name_;
351         _symbol = symbol_;
352     }
353 
354     /**
355      * @dev Returns the name of the token.
356      */
357     function name() public view virtual override returns (string memory) {
358         return _name;
359     }
360 
361     /**
362      * @dev Returns the symbol of the token, usually a shorter version of the
363      * name.
364      */
365     function symbol() public view virtual override returns (string memory) {
366         return _symbol;
367     }
368 
369     /**
370      * @dev Returns the number of decimals used to get its user representation.
371      * For example, if `decimals` equals `2`, a balance of `505` tokens should
372      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
373      *
374      * Tokens usually opt for a value of 18, imitating the relationship between
375      * Ether and Wei. This is the value {ERC20} uses, unless this function is
376      * overridden;
377      *
378      * NOTE: This information is only used for _display_ purposes: it in
379      * no way affects any of the arithmetic of the contract, including
380      * {IERC20-balanceOf} and {IERC20-transfer}.
381      */
382     function decimals() public view virtual override returns (uint8) {
383         return 18;
384     }
385 
386     /**
387      * @dev See {IERC20-totalSupply}.
388      */
389     function totalSupply() public view virtual override returns (uint256) {
390         return _totalSupply;
391     }
392 
393     /**
394      * @dev See {IERC20-balanceOf}.
395      */
396     function balanceOf(address account) public view virtual override returns (uint256) {
397         return _balances[account];
398     }
399 
400     /**
401      * @dev See {IERC20-transfer}.
402      *
403      * Requirements:
404      *
405      * - `recipient` cannot be the zero address.
406      * - the caller must have a balance of at least `amount`.
407      */
408     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
409         _transfer(_msgSender(), recipient, amount);
410         return true;
411     }
412 
413     /**
414      * @dev See {IERC20-allowance}.
415      */
416     function allowance(address owner, address spender) public view virtual override returns (uint256) {
417         return _allowances[owner][spender];
418     }
419 
420     /**
421      * @dev See {IERC20-approve}.
422      *
423      * Requirements:
424      *
425      * - `spender` cannot be the zero address.
426      */
427     function approve(address spender, uint256 amount) public virtual override returns (bool) {
428         _approve(_msgSender(), spender, amount);
429         return true;
430     }
431 
432     /**
433      * @dev See {IERC20-transferFrom}.
434      *
435      * Emits an {Approval} event indicating the updated allowance. This is not
436      * required by the EIP. See the note at the beginning of {ERC20}.
437      *
438      * Requirements:
439      *
440      * - `sender` and `recipient` cannot be the zero address.
441      * - `sender` must have a balance of at least `amount`.
442      * - the caller must have allowance for ``sender``'s tokens of at least
443      * `amount`.
444      */
445     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
446         _transfer(sender, recipient, amount);
447 
448         uint256 currentAllowance = _allowances[sender][_msgSender()];
449         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
450         _approve(sender, _msgSender(), currentAllowance - amount);
451 
452         return true;
453     }
454 
455     /**
456      * @dev Atomically increases the allowance granted to `spender` by the caller.
457      *
458      * This is an alternative to {approve} that can be used as a mitigation for
459      * problems described in {IERC20-approve}.
460      *
461      * Emits an {Approval} event indicating the updated allowance.
462      *
463      * Requirements:
464      *
465      * - `spender` cannot be the zero address.
466      */
467     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
468         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
469         return true;
470     }
471 
472     /**
473      * @dev Atomically decreases the allowance granted to `spender` by the caller.
474      *
475      * This is an alternative to {approve} that can be used as a mitigation for
476      * problems described in {IERC20-approve}.
477      *
478      * Emits an {Approval} event indicating the updated allowance.
479      *
480      * Requirements:
481      *
482      * - `spender` cannot be the zero address.
483      * - `spender` must have allowance for the caller of at least
484      * `subtractedValue`.
485      */
486     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
487         uint256 currentAllowance = _allowances[_msgSender()][spender];
488         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
489         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
490 
491         return true;
492     }
493 
494     /**
495      * @dev Moves tokens `amount` from `sender` to `recipient`.
496      *
497      * This is internal function is equivalent to {transfer}, and can be used to
498      * e.g. implement automatic token fees, slashing mechanisms, etc.
499      *
500      * Emits a {Transfer} event.
501      *
502      * Requirements:
503      *
504      * - `sender` cannot be the zero address.
505      * - `recipient` cannot be the zero address.
506      * - `sender` must have a balance of at least `amount`.
507      */
508     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
509         require(sender != address(0), "ERC20: transfer from the zero address");
510         require(recipient != address(0), "ERC20: transfer to the zero address");
511 
512         _beforeTokenTransfer(sender, recipient, amount);
513 
514         uint256 senderBalance = _balances[sender];
515         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
516         _balances[sender] = senderBalance - amount;
517         _balances[recipient] += amount;
518 
519         emit Transfer(sender, recipient, amount);
520     }
521 
522     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
523      * the total supply.
524      *
525      * Emits a {Transfer} event with `from` set to the zero address.
526      *
527      * Requirements:
528      *
529      * - `to` cannot be the zero address.
530      */
531     function _mint(address account, uint256 amount) internal virtual {
532         require(account != address(0), "ERC20: mint to the zero address");
533 
534         _beforeTokenTransfer(address(0), account, amount);
535 
536         _totalSupply += amount;
537         _balances[account] += amount;
538         emit Transfer(address(0), account, amount);
539     }
540 
541     /**
542      * @dev Destroys `amount` tokens from `account`, reducing the
543      * total supply.
544      *
545      * Emits a {Transfer} event with `to` set to the zero address.
546      *
547      * Requirements:
548      *
549      * - `account` cannot be the zero address.
550      * - `account` must have at least `amount` tokens.
551      */
552     function _burn(address account, uint256 amount) internal virtual {
553         require(account != address(0), "ERC20: burn from the zero address");
554 
555         _beforeTokenTransfer(account, address(0), amount);
556 
557         uint256 accountBalance = _balances[account];
558         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
559         _balances[account] = accountBalance - amount;
560         _totalSupply -= amount;
561 
562         emit Transfer(account, address(0), amount);
563     }
564 
565     /**
566      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
567      *
568      * This internal function is equivalent to `approve`, and can be used to
569      * e.g. set automatic allowances for certain subsystems, etc.
570      *
571      * Emits an {Approval} event.
572      *
573      * Requirements:
574      *
575      * - `owner` cannot be the zero address.
576      * - `spender` cannot be the zero address.
577      */
578     function _approve(address owner, address spender, uint256 amount) internal virtual {
579         require(owner != address(0), "ERC20: approve from the zero address");
580         require(spender != address(0), "ERC20: approve to the zero address");
581 
582         _allowances[owner][spender] = amount;
583         emit Approval(owner, spender, amount);
584     }
585 
586     /**
587      * @dev Hook that is called before any transfer of tokens. This includes
588      * minting and burning.
589      *
590      * Calling conditions:
591      *
592      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
593      * will be to transferred to `to`.
594      * - when `from` is zero, `amount` tokens will be minted for `to`.
595      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
596      * - `from` and `to` are never both zero.
597      *
598      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
599      */
600     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
601 }
602 
603 
604 /**
605  * @dev Contract module which provides a basic access control mechanism, where
606  * there is an account (an owner) that can be granted exclusive access to
607  * specific functions.
608  *
609  * By default, the owner account will be the one that deploys the contract. This
610  * can later be changed with {transferOwnership}.
611  *
612  * This module is used through inheritance. It will make available the modifier
613  * `onlyOwner`, which can be applied to your functions to restrict their use to
614  * the owner.
615  */
616 abstract contract Ownable is Context {
617     address private _owner;
618 
619     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
620 
621     /**
622      * @dev Initializes the contract setting the deployer as the initial owner.
623      */
624     constructor () {
625         address msgSender = _msgSender();
626         _owner = msgSender;
627         emit OwnershipTransferred(address(0), msgSender);
628     }
629 
630     /**
631      * @dev Returns the address of the current owner.
632      */
633     function owner() public view virtual returns (address) {
634         return _owner;
635     }
636 
637     /**
638      * @dev Throws if called by any account other than the owner.
639      */
640     modifier onlyOwner() {
641         require(owner() == _msgSender(), "Ownable: caller is not the owner");
642         _;
643     }
644 
645     /**
646      * @dev Leaves the contract without owner. It will not be possible to call
647      * `onlyOwner` functions anymore. Can only be called by the current owner.
648      *
649      * NOTE: Renouncing ownership will leave the contract without an owner,
650      * thereby removing any functionality that is only available to the owner.
651      */
652     function renounceOwnership() public virtual onlyOwner {
653         emit OwnershipTransferred(_owner, address(0));
654         _owner = address(0);
655     }
656 
657     /**
658      * @dev Transfers ownership of the contract to a new account (`newOwner`).
659      * Can only be called by the current owner.
660      */
661     function transferOwnership(address newOwner) public virtual onlyOwner {
662         require(newOwner != address(0), "Ownable: new owner is the zero address");
663         emit OwnershipTransferred(_owner, newOwner);
664         _owner = newOwner;
665     }
666 }
667 
668 library SafeMath {
669     /**
670      * @dev Returns the addition of two unsigned integers, reverting on
671      * overflow.
672      *
673      * Counterpart to Solidity's `+` operator.
674      *
675      * Requirements:
676      *
677      * - Addition cannot overflow.
678      */
679     function add(uint256 a, uint256 b) internal pure returns (uint256) {
680         uint256 c = a + b;
681         require(c >= a, "SafeMath: addition overflow");
682 
683         return c;
684     }
685 
686     /**
687      * @dev Returns the subtraction of two unsigned integers, reverting on
688      * overflow (when the result is negative).
689      *
690      * Counterpart to Solidity's `-` operator.
691      *
692      * Requirements:
693      *
694      * - Subtraction cannot overflow.
695      */
696     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
697         return sub(a, b, "SafeMath: subtraction overflow");
698     }
699 
700     /**
701      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
702      * overflow (when the result is negative).
703      *
704      * Counterpart to Solidity's `-` operator.
705      *
706      * Requirements:
707      *
708      * - Subtraction cannot overflow.
709      */
710     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
711         require(b <= a, errorMessage);
712         uint256 c = a - b;
713 
714         return c;
715     }
716 
717     /**
718      * @dev Returns the multiplication of two unsigned integers, reverting on
719      * overflow.
720      *
721      * Counterpart to Solidity's `*` operator.
722      *
723      * Requirements:
724      *
725      * - Multiplication cannot overflow.
726      */
727     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
728         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
729         // benefit is lost if 'b' is also tested.
730         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
731         if (a == 0) {
732             return 0;
733         }
734 
735         uint256 c = a * b;
736         require(c / a == b, "SafeMath: multiplication overflow");
737 
738         return c;
739     }
740 
741     /**
742      * @dev Returns the integer division of two unsigned integers. Reverts on
743      * division by zero. The result is rounded towards zero.
744      *
745      * Counterpart to Solidity's `/` operator. Note: this function uses a
746      * `revert` opcode (which leaves remaining gas untouched) while Solidity
747      * uses an invalid opcode to revert (consuming all remaining gas).
748      *
749      * Requirements:
750      *
751      * - The divisor cannot be zero.
752      */
753     function div(uint256 a, uint256 b) internal pure returns (uint256) {
754         return div(a, b, "SafeMath: division by zero");
755     }
756 
757     /**
758      * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
759      * division by zero. The result is rounded towards zero.
760      *
761      * Counterpart to Solidity's `/` operator. Note: this function uses a
762      * `revert` opcode (which leaves remaining gas untouched) while Solidity
763      * uses an invalid opcode to revert (consuming all remaining gas).
764      *
765      * Requirements:
766      *
767      * - The divisor cannot be zero.
768      */
769     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
770         require(b > 0, errorMessage);
771         uint256 c = a / b;
772         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
773 
774         return c;
775     }
776 
777     /**
778      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
779      * Reverts when dividing by zero.
780      *
781      * Counterpart to Solidity's `%` operator. This function uses a `revert`
782      * opcode (which leaves remaining gas untouched) while Solidity uses an
783      * invalid opcode to revert (consuming all remaining gas).
784      *
785      * Requirements:
786      *
787      * - The divisor cannot be zero.
788      */
789     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
790         return mod(a, b, "SafeMath: modulo by zero");
791     }
792 
793     /**
794      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
795      * Reverts with custom message when dividing by zero.
796      *
797      * Counterpart to Solidity's `%` operator. This function uses a `revert`
798      * opcode (which leaves remaining gas untouched) while Solidity uses an
799      * invalid opcode to revert (consuming all remaining gas).
800      *
801      * Requirements:
802      *
803      * - The divisor cannot be zero.
804      */
805     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
806         require(b != 0, errorMessage);
807         return a % b;
808     }
809 }
810 
811 interface IChainbindersToken {
812     function mint(address to, uint amount) external;
813     function burn(uint256 amount) external;
814     function burnFrom(address, uint256) external;
815 }
816 
817 contract ChainbindersLGE is Ownable {
818     using SafeMath for uint256;
819     using Address for address;
820 
821     IChainbindersToken public chainbinders;
822     uint256 public startPrice = 2500000000000000; // 0.0025 ETH for 1 bnd
823     uint256 public currentPrice = 0;
824     uint256 public finalPrice = 7500000000000000; // 0.0075 ETH for 1 bnd
825     uint256 public priceWillIncrement = 0;
826 
827     uint256 public amountRaised = 0;
828     uint256 public nextRaiseTarget = 0;
829     uint256 public targetInterval = 2500000000000000000000; // 2500 ETH
830 
831     bool public isStarted = false;
832 
833     address payable public poolAccount;
834     address payable public buybackAccount;
835     address payable public account1;
836     address payable public account2;
837     address payable public account3;
838 
839     event BuyChainbindersSuccessfully(address indexed account, uint256 ethAmount, uint256 chainbindersAmount);
840     event Status(uint256 amountRaised, uint256 nextTarget, uint256 currentPrice, uint256 priceWillIncrement);
841     event Start(bool isStarted);
842     event Stop(bool isStarted);
843 
844     constructor(IChainbindersToken _chainbinders) {
845         chainbinders = _chainbinders;
846         currentPrice = startPrice;
847         priceWillIncrement = startPrice.mul(2).div(3);
848         nextRaiseTarget = amountRaised.add(targetInterval);
849         _setupAddress();
850     }
851 
852     function _setupAddress() private {
853         poolAccount = 0xc37Ff2634928a985ec437f6702641d7AD8210846;
854         buybackAccount = 0xc91ca8DC020F0135Df86c1D88d4CDC9caF9982Da;
855         account1 = 0xFd6a72D96813460157E0bD175E2668363cEe5383;
856         account2 = 0x5F956ca9a2eD963Bf955E9e4337E0A4F1d2Dd8e9;
857         account3 = 0x7b3da3e4E923eeC82774ED38Dc92eC28Dfd69b9D;
858     }
859 
860     function buyChainbinders() external payable needStart onlyHuman {
861         uint256 amountETH = msg.value;
862         uint256 bdnAmountCanBuy = amountETH.div(currentPrice).mul(1e18);
863         require(bdnAmountCanBuy != 0, "You can not buy 0 BND.");
864 
865         _transferToken(amountETH);
866         amountRaised = amountRaised.add(amountETH);
867         _updateStatus(amountRaised);
868         chainbinders.mint(msg.sender, bdnAmountCanBuy);
869         emit BuyChainbindersSuccessfully(msg.sender, amountETH, bdnAmountCanBuy);
870     }
871 
872     function start() external onlyOwner {
873         require(!isStarted, "Sale has been started");
874         isStarted = true;
875 
876         emit Start(isStarted);
877     }
878 
879     function stop() external onlyOwner {
880         require(isStarted, "Sale has been stoped");
881         isStarted = false;
882 
883         emit Stop(isStarted);
884     }
885 
886     function _transferToken(uint256 totalAmountETH) private {
887         // For pool account
888         uint256 forPoolAmount = totalAmountETH.mul(75).div(100);
889         poolAccount.transfer(forPoolAmount);
890 
891         // 10% for account1
892         uint256 forAccount1Amount = totalAmountETH.mul(10).div(100);
893         account1.transfer(forAccount1Amount);
894 
895         // 5% for account2
896         uint256 forAccount2Amount = totalAmountETH.mul(5).div(100);
897         account2.transfer(forAccount2Amount);
898 
899         // 5% for account3
900         uint256 forAccount3Amount = totalAmountETH.mul(5).div(100);
901         account3.transfer(forAccount3Amount);
902 
903         // For doki buyback
904         buybackAccount.transfer(address(this).balance);
905     }
906 
907     function _updateStatus(uint256 _amountRaised) private {
908         if (_amountRaised >= nextRaiseTarget && currentPrice < finalPrice && priceWillIncrement > 0) {
909             // update price
910             currentPrice = currentPrice.add(priceWillIncrement);
911             priceWillIncrement = priceWillIncrement.mul(2).div(3);
912             // upate next raise target
913             nextRaiseTarget = nextRaiseTarget.add(targetInterval);
914             emit Status(_amountRaised, nextRaiseTarget, currentPrice, priceWillIncrement);
915         }
916     }
917 
918     modifier needStart {
919         require(isStarted, "Please wait this seller to be started.");
920         _;
921     }
922 
923     modifier onlyHuman() {
924         require(tx.origin == msg.sender, "Only for human.");
925         _;
926     }
927 }