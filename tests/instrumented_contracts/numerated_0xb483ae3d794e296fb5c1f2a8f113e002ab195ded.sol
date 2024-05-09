1 // Sources flattened with hardhat v2.2.1 https://hardhat.org
2 
3 // File contracts/token/ERC20/IERC20.sol
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity ^0.8.0;
8 
9 /**
10  * @dev Interface of the ERC20 standard as defined in the EIP.
11  */
12 interface IERC20 {
13     /**
14      * @dev Returns the amount of tokens in existence.
15      */
16     function totalSupply() external view returns (uint256);
17 
18     /**
19      * @dev Returns the amount of tokens owned by `account`.
20      */
21     function balanceOf(address account) external view returns (uint256);
22 
23     /**
24      * @dev Moves `amount` tokens from the caller's account to `recipient`.
25      *
26      * Returns a boolean value indicating whether the operation succeeded.
27      *
28      * Emits a {Transfer} event.
29      */
30     function transfer(address recipient, uint256 amount) external returns (bool);
31 
32     /**
33      * @dev Returns the remaining number of tokens that `spender` will be
34      * allowed to spend on behalf of `owner` through {transferFrom}. This is
35      * zero by default.
36      *
37      * This value changes when {approve} or {transferFrom} are called.
38      */
39     function allowance(address owner, address spender) external view returns (uint256);
40 
41     /**
42      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
43      *
44      * Returns a boolean value indicating whether the operation succeeded.
45      *
46      * IMPORTANT: Beware that changing an allowance with this method brings the risk
47      * that someone may use both the old and the new allowance by unfortunate
48      * transaction ordering. One possible solution to mitigate this race
49      * condition is to first reduce the spender's allowance to 0 and set the
50      * desired value afterwards:
51      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
52      *
53      * Emits an {Approval} event.
54      */
55     function approve(address spender, uint256 amount) external returns (bool);
56 
57     /**
58      * @dev Moves `amount` tokens from `sender` to `recipient` using the
59      * allowance mechanism. `amount` is then deducted from the caller's
60      * allowance.
61      *
62      * Returns a boolean value indicating whether the operation succeeded.
63      *
64      * Emits a {Transfer} event.
65      */
66     function transferFrom(address sender, address recipient, uint256 amount) external returns (bool);
67 
68     /**
69      * @dev Emitted when `value` tokens are moved from one account (`from`) to
70      * another (`to`).
71      *
72      * Note that `value` may be zero.
73      */
74     event Transfer(address indexed from, address indexed to, uint256 value);
75 
76     /**
77      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
78      * a call to {approve}. `value` is the new allowance.
79      */
80     event Approval(address indexed owner, address indexed spender, uint256 value);
81 }
82 
83 
84 // File contracts/token/ERC20/extensions/IERC20Metadata.sol
85 
86 
87 
88 
89 
90 /**
91  * @dev Interface for the optional metadata functions from the ERC20 standard.
92  */
93 interface IERC20Metadata is IERC20 {
94     /**
95      * @dev Returns the name of the token.
96      */
97     function name() external view returns (string memory);
98 
99     /**
100      * @dev Returns the symbol of the token.
101      */
102     function symbol() external view returns (string memory);
103 
104     /**
105      * @dev Returns the decimals places of the token.
106      */
107     function decimals() external view returns (uint8);
108 }
109 
110 
111 // File contracts/utils/Context.sol
112 
113 
114 
115 
116 
117 /*
118  * @dev Provides information about the current execution context, including the
119  * sender of the transaction and its data. While these are generally available
120  * via msg.sender and msg.data, they should not be accessed in such a direct
121  * manner, since when dealing with meta-transactions the account sending and
122  * paying for execution may not be the actual sender (as far as an application
123  * is concerned).
124  *
125  * This contract is only required for intermediate, library-like contracts.
126  */
127 abstract contract Context {
128     function _msgSender() internal view virtual returns (address) {
129         return msg.sender;
130     }
131 
132     function _msgData() internal view virtual returns (bytes calldata) {
133         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
134         return msg.data;
135     }
136 }
137 
138 
139 // File contracts/token/ERC20/ERC20.sol
140 
141 
142 
143 
144 
145 
146 
147 /**
148  * @dev Implementation of the {IERC20} interface.
149  *
150  * This implementation is agnostic to the way tokens are created. This means
151  * that a supply mechanism has to be added in a derived contract using {_mint}.
152  * For a generic mechanism see {ERC20PresetMinterPauser}.
153  *
154  * TIP: For a detailed writeup see our guide
155  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
156  * to implement supply mechanisms].
157  *
158  * We have followed general OpenZeppelin guidelines: functions revert instead
159  * of returning `false` on failure. This behavior is nonetheless conventional
160  * and does not conflict with the expectations of ERC20 applications.
161  *
162  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
163  * This allows applications to reconstruct the allowance for all accounts just
164  * by listening to said events. Other implementations of the EIP may not emit
165  * these events, as it isn't required by the specification.
166  *
167  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
168  * functions have been added to mitigate the well-known issues around setting
169  * allowances. See {IERC20-approve}.
170  */
171 contract ERC20 is Context, IERC20, IERC20Metadata {
172     mapping (address => uint256) private _balances;
173 
174     mapping (address => mapping (address => uint256)) private _allowances;
175 
176     uint256 private _totalSupply;
177 
178     string private _name;
179     string private _symbol;
180 
181     /**
182      * @dev Sets the values for {name} and {symbol}.
183      *
184      * The defaut value of {decimals} is 18. To select a different value for
185      * {decimals} you should overload it.
186      *
187      * All two of these values are immutable: they can only be set once during
188      * construction.
189      */
190     constructor (string memory name_, string memory symbol_) {
191         _name = name_;
192         _symbol = symbol_;
193     }
194 
195     /**
196      * @dev Returns the name of the token.
197      */
198     function name() public view virtual override returns (string memory) {
199         return _name;
200     }
201 
202     /**
203      * @dev Returns the symbol of the token, usually a shorter version of the
204      * name.
205      */
206     function symbol() public view virtual override returns (string memory) {
207         return _symbol;
208     }
209 
210     /**
211      * @dev Returns the number of decimals used to get its user representation.
212      * For example, if `decimals` equals `2`, a balance of `505` tokens should
213      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
214      *
215      * Tokens usually opt for a value of 18, imitating the relationship between
216      * Ether and Wei. This is the value {ERC20} uses, unless this function is
217      * overridden;
218      *
219      * NOTE: This information is only used for _display_ purposes: it in
220      * no way affects any of the arithmetic of the contract, including
221      * {IERC20-balanceOf} and {IERC20-transfer}.
222      */
223     function decimals() public view virtual override returns (uint8) {
224         return 18;
225     }
226 
227     /**
228      * @dev See {IERC20-totalSupply}.
229      */
230     function totalSupply() public view virtual override returns (uint256) {
231         return _totalSupply;
232     }
233 
234     /**
235      * @dev See {IERC20-balanceOf}.
236      */
237     function balanceOf(address account) public view virtual override returns (uint256) {
238         return _balances[account];
239     }
240 
241     /**
242      * @dev See {IERC20-transfer}.
243      *
244      * Requirements:
245      *
246      * - `recipient` cannot be the zero address.
247      * - the caller must have a balance of at least `amount`.
248      */
249     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
250         _transfer(_msgSender(), recipient, amount);
251         return true;
252     }
253 
254     /**
255      * @dev See {IERC20-allowance}.
256      */
257     function allowance(address owner, address spender) public view virtual override returns (uint256) {
258         return _allowances[owner][spender];
259     }
260 
261     /**
262      * @dev See {IERC20-approve}.
263      *
264      * Requirements:
265      *
266      * - `spender` cannot be the zero address.
267      */
268     function approve(address spender, uint256 amount) public virtual override returns (bool) {
269         _approve(_msgSender(), spender, amount);
270         return true;
271     }
272 
273     /**
274      * @dev See {IERC20-transferFrom}.
275      *
276      * Emits an {Approval} event indicating the updated allowance. This is not
277      * required by the EIP. See the note at the beginning of {ERC20}.
278      *
279      * Requirements:
280      *
281      * - `sender` and `recipient` cannot be the zero address.
282      * - `sender` must have a balance of at least `amount`.
283      * - the caller must have allowance for ``sender``'s tokens of at least
284      * `amount`.
285      */
286     function transferFrom(address sender, address recipient, uint256 amount) public virtual override returns (bool) {
287         _transfer(sender, recipient, amount);
288 
289         uint256 currentAllowance = _allowances[sender][_msgSender()];
290         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
291         _approve(sender, _msgSender(), currentAllowance - amount);
292 
293         return true;
294     }
295 
296     /**
297      * @dev Atomically increases the allowance granted to `spender` by the caller.
298      *
299      * This is an alternative to {approve} that can be used as a mitigation for
300      * problems described in {IERC20-approve}.
301      *
302      * Emits an {Approval} event indicating the updated allowance.
303      *
304      * Requirements:
305      *
306      * - `spender` cannot be the zero address.
307      */
308     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
309         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
310         return true;
311     }
312 
313     /**
314      * @dev Atomically decreases the allowance granted to `spender` by the caller.
315      *
316      * This is an alternative to {approve} that can be used as a mitigation for
317      * problems described in {IERC20-approve}.
318      *
319      * Emits an {Approval} event indicating the updated allowance.
320      *
321      * Requirements:
322      *
323      * - `spender` cannot be the zero address.
324      * - `spender` must have allowance for the caller of at least
325      * `subtractedValue`.
326      */
327     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
328         uint256 currentAllowance = _allowances[_msgSender()][spender];
329         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
330         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
331 
332         return true;
333     }
334 
335     /**
336      * @dev Moves tokens `amount` from `sender` to `recipient`.
337      *
338      * This is internal function is equivalent to {transfer}, and can be used to
339      * e.g. implement automatic token fees, slashing mechanisms, etc.
340      *
341      * Emits a {Transfer} event.
342      *
343      * Requirements:
344      *
345      * - `sender` cannot be the zero address.
346      * - `recipient` cannot be the zero address.
347      * - `sender` must have a balance of at least `amount`.
348      */
349     function _transfer(address sender, address recipient, uint256 amount) internal virtual {
350         require(sender != address(0), "ERC20: transfer from the zero address");
351         require(recipient != address(0), "ERC20: transfer to the zero address");
352 
353         _beforeTokenTransfer(sender, recipient, amount);
354 
355         uint256 senderBalance = _balances[sender];
356         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
357         _balances[sender] = senderBalance - amount;
358         _balances[recipient] += amount;
359 
360         emit Transfer(sender, recipient, amount);
361     }
362 
363     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
364      * the total supply.
365      *
366      * Emits a {Transfer} event with `from` set to the zero address.
367      *
368      * Requirements:
369      *
370      * - `to` cannot be the zero address.
371      */
372     function _mint(address account, uint256 amount) internal virtual {
373         require(account != address(0), "ERC20: mint to the zero address");
374 
375         _beforeTokenTransfer(address(0), account, amount);
376 
377         _totalSupply += amount;
378         _balances[account] += amount;
379         emit Transfer(address(0), account, amount);
380     }
381 
382     /**
383      * @dev Destroys `amount` tokens from `account`, reducing the
384      * total supply.
385      *
386      * Emits a {Transfer} event with `to` set to the zero address.
387      *
388      * Requirements:
389      *
390      * - `account` cannot be the zero address.
391      * - `account` must have at least `amount` tokens.
392      */
393     function _burn(address account, uint256 amount) internal virtual {
394         require(account != address(0), "ERC20: burn from the zero address");
395 
396         _beforeTokenTransfer(account, address(0), amount);
397 
398         uint256 accountBalance = _balances[account];
399         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
400         _balances[account] = accountBalance - amount;
401         _totalSupply -= amount;
402 
403         emit Transfer(account, address(0), amount);
404     }
405 
406     /**
407      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
408      *
409      * This internal function is equivalent to `approve`, and can be used to
410      * e.g. set automatic allowances for certain subsystems, etc.
411      *
412      * Emits an {Approval} event.
413      *
414      * Requirements:
415      *
416      * - `owner` cannot be the zero address.
417      * - `spender` cannot be the zero address.
418      */
419     function _approve(address owner, address spender, uint256 amount) internal virtual {
420         require(owner != address(0), "ERC20: approve from the zero address");
421         require(spender != address(0), "ERC20: approve to the zero address");
422 
423         _allowances[owner][spender] = amount;
424         emit Approval(owner, spender, amount);
425     }
426 
427     /**
428      * @dev Hook that is called before any transfer of tokens. This includes
429      * minting and burning.
430      *
431      * Calling conditions:
432      *
433      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
434      * will be to transferred to `to`.
435      * - when `from` is zero, `amount` tokens will be minted for `to`.
436      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
437      * - `from` and `to` are never both zero.
438      *
439      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
440      */
441     function _beforeTokenTransfer(address from, address to, uint256 amount) internal virtual { }
442 }
443 
444 
445 // File contracts/access/Ownable.sol
446 
447 
448 
449 
450 
451 /**
452  * @dev Contract module which provides a basic access control mechanism, where
453  * there is an account (an owner) that can be granted exclusive access to
454  * specific functions.
455  *
456  * By default, the owner account will be the one that deploys the contract. This
457  * can later be changed with {transferOwnership}.
458  *
459  * This module is used through inheritance. It will make available the modifier
460  * `onlyOwner`, which can be applied to your functions to restrict their use to
461  * the owner.
462  */
463 abstract contract Ownable is Context {
464     address private _owner;
465 
466     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
467 
468     /**
469      * @dev Initializes the contract setting the deployer as the initial owner.
470      */
471     constructor () {
472         address msgSender = _msgSender();
473         _owner = msgSender;
474         emit OwnershipTransferred(address(0), msgSender);
475     }
476 
477     /**
478      * @dev Returns the address of the current owner.
479      */
480     function owner() public view virtual returns (address) {
481         return _owner;
482     }
483 
484     /**
485      * @dev Throws if called by any account other than the owner.
486      */
487     modifier onlyOwner() {
488         require(owner() == _msgSender(), "Ownable: caller is not the owner");
489         _;
490     }
491 
492     /**
493      * @dev Leaves the contract without owner. It will not be possible to call
494      * `onlyOwner` functions anymore. Can only be called by the current owner.
495      *
496      * NOTE: Renouncing ownership will leave the contract without an owner,
497      * thereby removing any functionality that is only available to the owner.
498      */
499     function renounceOwnership() public virtual onlyOwner {
500         emit OwnershipTransferred(_owner, address(0));
501         _owner = address(0);
502     }
503 
504     /**
505      * @dev Transfers ownership of the contract to a new account (`newOwner`).
506      * Can only be called by the current owner.
507      */
508     function transferOwnership(address newOwner) public virtual onlyOwner {
509         require(newOwner != address(0), "Ownable: new owner is the zero address");
510         emit OwnershipTransferred(_owner, newOwner);
511         _owner = newOwner;
512     }
513 }
514 
515 
516 // File contracts/mulan/WhitelistForSelf.sol
517 
518 
519 
520 
521 
522 abstract contract WhitelistForSelf is Ownable {
523     //      caller
524     mapping(address => bool) public canBeModified;
525 
526     function addRelationByOwner(address caller) external virtual onlyOwner {
527         canBeModified[caller] = true;
528     }
529 
530     modifier allowModification() {
531         require(canBeModified[msg.sender], "modification not allowed");
532         _;
533     }
534 }
535 
536 
537 // File contracts/mulan/mulanV2.sol
538 
539 
540 
541 
542 
543 
544 contract mulanV2 is ERC20, WhitelistForSelf {
545 
546     constructor() ERC20("Mulan.Finance V2", "$MULAN2") {}
547 
548     function mintByWhitelist(address _to, uint256 _amount ) external allowModification {
549         _mint(_to, _amount);
550     }
551 
552     function mint(address _to, uint256 _amount ) external onlyOwner {
553         _mint(_to, _amount);
554     }
555 }
556 
557 
558 // File contracts/utils/Address.sol
559 
560 
561 
562 
563 
564 /**
565  * @dev Collection of functions related to the address type
566  */
567 library Address {
568     /**
569      * @dev Returns true if `account` is a contract.
570      *
571      * [IMPORTANT]
572      * ====
573      * It is unsafe to assume that an address for which this function returns
574      * false is an externally-owned account (EOA) and not a contract.
575      *
576      * Among others, `isContract` will return false for the following
577      * types of addresses:
578      *
579      *  - an externally-owned account
580      *  - a contract in construction
581      *  - an address where a contract will be created
582      *  - an address where a contract lived, but was destroyed
583      * ====
584      */
585     function isContract(address account) internal view returns (bool) {
586         // This method relies on extcodesize, which returns 0 for contracts in
587         // construction, since the code is only stored at the end of the
588         // constructor execution.
589 
590         uint256 size;
591         // solhint-disable-next-line no-inline-assembly
592         assembly { size := extcodesize(account) }
593         return size > 0;
594     }
595 
596     /**
597      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
598      * `recipient`, forwarding all available gas and reverting on errors.
599      *
600      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
601      * of certain opcodes, possibly making contracts go over the 2300 gas limit
602      * imposed by `transfer`, making them unable to receive funds via
603      * `transfer`. {sendValue} removes this limitation.
604      *
605      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
606      *
607      * IMPORTANT: because control is transferred to `recipient`, care must be
608      * taken to not create reentrancy vulnerabilities. Consider using
609      * {ReentrancyGuard} or the
610      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
611      */
612     function sendValue(address payable recipient, uint256 amount) internal {
613         require(address(this).balance >= amount, "Address: insufficient balance");
614 
615         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
616         (bool success, ) = recipient.call{ value: amount }("");
617         require(success, "Address: unable to send value, recipient may have reverted");
618     }
619 
620     /**
621      * @dev Performs a Solidity function call using a low level `call`. A
622      * plain`call` is an unsafe replacement for a function call: use this
623      * function instead.
624      *
625      * If `target` reverts with a revert reason, it is bubbled up by this
626      * function (like regular Solidity function calls).
627      *
628      * Returns the raw returned data. To convert to the expected return value,
629      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
630      *
631      * Requirements:
632      *
633      * - `target` must be a contract.
634      * - calling `target` with `data` must not revert.
635      *
636      * _Available since v3.1._
637      */
638     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
639       return functionCall(target, data, "Address: low-level call failed");
640     }
641 
642     /**
643      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
644      * `errorMessage` as a fallback revert reason when `target` reverts.
645      *
646      * _Available since v3.1._
647      */
648     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
649         return functionCallWithValue(target, data, 0, errorMessage);
650     }
651 
652     /**
653      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
654      * but also transferring `value` wei to `target`.
655      *
656      * Requirements:
657      *
658      * - the calling contract must have an ETH balance of at least `value`.
659      * - the called Solidity function must be `payable`.
660      *
661      * _Available since v3.1._
662      */
663     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
664         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
665     }
666 
667     /**
668      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
669      * with `errorMessage` as a fallback revert reason when `target` reverts.
670      *
671      * _Available since v3.1._
672      */
673     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
674         require(address(this).balance >= value, "Address: insufficient balance for call");
675         require(isContract(target), "Address: call to non-contract");
676 
677         // solhint-disable-next-line avoid-low-level-calls
678         (bool success, bytes memory returndata) = target.call{ value: value }(data);
679         return _verifyCallResult(success, returndata, errorMessage);
680     }
681 
682     /**
683      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
684      * but performing a static call.
685      *
686      * _Available since v3.3._
687      */
688     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
689         return functionStaticCall(target, data, "Address: low-level static call failed");
690     }
691 
692     /**
693      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
694      * but performing a static call.
695      *
696      * _Available since v3.3._
697      */
698     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
699         require(isContract(target), "Address: static call to non-contract");
700 
701         // solhint-disable-next-line avoid-low-level-calls
702         (bool success, bytes memory returndata) = target.staticcall(data);
703         return _verifyCallResult(success, returndata, errorMessage);
704     }
705 
706     /**
707      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
708      * but performing a delegate call.
709      *
710      * _Available since v3.4._
711      */
712     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
713         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
714     }
715 
716     /**
717      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
718      * but performing a delegate call.
719      *
720      * _Available since v3.4._
721      */
722     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
723         require(isContract(target), "Address: delegate call to non-contract");
724 
725         // solhint-disable-next-line avoid-low-level-calls
726         (bool success, bytes memory returndata) = target.delegatecall(data);
727         return _verifyCallResult(success, returndata, errorMessage);
728     }
729 
730     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
731         if (success) {
732             return returndata;
733         } else {
734             // Look for revert reason and bubble it up if present
735             if (returndata.length > 0) {
736                 // The easiest way to bubble the revert reason is using memory via assembly
737 
738                 // solhint-disable-next-line no-inline-assembly
739                 assembly {
740                     let returndata_size := mload(returndata)
741                     revert(add(32, returndata), returndata_size)
742                 }
743             } else {
744                 revert(errorMessage);
745             }
746         }
747     }
748 }
749 
750 
751 // File contracts/token/ERC20/utils/SafeERC20.sol
752 
753 
754 
755 
756 
757 
758 /**
759  * @title SafeERC20
760  * @dev Wrappers around ERC20 operations that throw on failure (when the token
761  * contract returns false). Tokens that return no value (and instead revert or
762  * throw on failure) are also supported, non-reverting calls are assumed to be
763  * successful.
764  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
765  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
766  */
767 library SafeERC20 {
768     using Address for address;
769 
770     function safeTransfer(IERC20 token, address to, uint256 value) internal {
771         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
772     }
773 
774     function safeTransferFrom(IERC20 token, address from, address to, uint256 value) internal {
775         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
776     }
777 
778     /**
779      * @dev Deprecated. This function has issues similar to the ones found in
780      * {IERC20-approve}, and its usage is discouraged.
781      *
782      * Whenever possible, use {safeIncreaseAllowance} and
783      * {safeDecreaseAllowance} instead.
784      */
785     function safeApprove(IERC20 token, address spender, uint256 value) internal {
786         // safeApprove should only be called when setting an initial allowance,
787         // or when resetting it to zero. To increase and decrease it, use
788         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
789         // solhint-disable-next-line max-line-length
790         require((value == 0) || (token.allowance(address(this), spender) == 0),
791             "SafeERC20: approve from non-zero to non-zero allowance"
792         );
793         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
794     }
795 
796     function safeIncreaseAllowance(IERC20 token, address spender, uint256 value) internal {
797         uint256 newAllowance = token.allowance(address(this), spender) + value;
798         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
799     }
800 
801     function safeDecreaseAllowance(IERC20 token, address spender, uint256 value) internal {
802         unchecked {
803             uint256 oldAllowance = token.allowance(address(this), spender);
804             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
805             uint256 newAllowance = oldAllowance - value;
806             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
807         }
808     }
809 
810     /**
811      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
812      * on the return value: the return value is optional (but if data is returned, it must not be false).
813      * @param token The token targeted by the call.
814      * @param data The call data (encoded using abi.encode or one of its variants).
815      */
816     function _callOptionalReturn(IERC20 token, bytes memory data) private {
817         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
818         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
819         // the target address contains contract code and also asserts for success in the low-level call.
820 
821         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
822         if (returndata.length > 0) { // Return data is optional
823             // solhint-disable-next-line max-line-length
824             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
825         }
826     }
827 }
828 
829 
830 // File contracts/mulan/timelock.sol
831 
832 
833 
834 
835 
836 
837 contract timelocks is WhitelistForSelf {
838     using SafeERC20 for IERC20;
839 
840     IERC20 private immutable _token;
841 
842     event LockCreated(
843         address indexed user,
844         uint256 indexed lockNumber,
845         uint256 value,
846         uint256 reward,
847         uint256 startTime,
848         uint256 releaseTime
849     );
850     event Released(
851         address indexed user,
852         uint256 indexed lockNumber,
853         uint256 actualReleaseTime
854     );
855 
856     uint256 public lockedTotal;
857     uint256 public rewardTotal;
858 
859     constructor(IERC20 token_) {
860         _token = token_;
861     }
862 
863     struct LockDetail {
864         uint256 value;  //locked mulan value
865         uint256 reward; //reward mulanV2 value
866         uint256 releaseTime;
867         bool released;
868     }
869 
870     mapping(address => LockDetail[]) public userLocks;
871 
872     function getTotalLocksOf(address _user) public view returns (uint256) {
873         return userLocks[_user].length;
874     }
875 
876     function getDetailOf(address _user, uint256 _lockNumber)
877         public
878         view
879         returns (
880             uint256 value,
881             uint256 reward,
882             uint256 releaseTime,
883             bool released
884         )
885     {
886         LockDetail memory detail = userLocks[_user][_lockNumber];
887         return (
888             detail.value,
889             detail.reward,
890             detail.releaseTime,
891             detail.released
892         );
893     }
894 
895     ///@dev it's caller's responsibility to transfer _value token to this contract
896     function lockByWhitelist(
897         address _user,
898         uint256 _value,
899         uint256 _reward,
900         uint256 _releaseTime
901     ) external virtual allowModification returns (bool) {
902         require(
903             _releaseTime >= block.timestamp,
904             "lock time should be after current time"
905         );
906         require(_value > 0, "value should be above 0");
907         uint256 lockNumber = userLocks[_user].length;
908         userLocks[_user].push(LockDetail(_value, _reward, _releaseTime, false));
909         lockedTotal += _value;
910         rewardTotal += _reward;
911         emit LockCreated(
912             _user,
913             lockNumber,
914             _value,
915             _reward,
916             block.timestamp,
917             _releaseTime
918         );
919         return true;
920     }
921 
922     function canRelease(address _user, uint256 _lockNumber)
923         public
924         view
925         virtual
926         returns (bool)
927     {
928         return
929             userLocks[_user][_lockNumber].releaseTime <= block.timestamp &&
930             !userLocks[_user][_lockNumber].released;
931     }
932 
933     function releaseByWhitelist(address _user, uint256 _lockNumber)
934         public
935         virtual
936         allowModification
937         returns (bool)
938     {
939         require(
940             canRelease(_user, _lockNumber),
941             "still locked or already released"
942         );
943         LockDetail memory detail = userLocks[_user][_lockNumber];
944         _token.safeTransfer(_user, detail.value);
945         userLocks[_user][_lockNumber].released = true;
946         emit Released(_user, _lockNumber, block.timestamp);
947         return true;
948     }
949 
950 }
951 
952 
953 // File contracts/mulan/stake.sol
954 
955 
956 
957 
958 
959 
960 
961 ///@dev this contract do not hold asset
962 contract MulanStake is Ownable {
963     using SafeERC20 for IERC20;
964 
965     uint256 private immutable _base = 10000;
966     uint256 private immutable _year = 365;
967 
968     IERC20 public mulan;
969     mulanV2 public mulan2;
970     timelocks public lock;
971 
972     constructor(
973         address mulan_,
974         address mulan2_,
975         address timelock_
976     ) {
977         mulan = IERC20(mulan_);
978         mulan2 = mulanV2(mulan2_);
979         lock = timelocks(timelock_);
980     }
981 
982     struct product {
983         string prodName;
984         uint256 lockDays;
985         uint256 basedAPY; // base 10000. e.g. 1000 => 1000/10000 = 10%
986         bool onSale;
987     }
988 
989     struct productSales{
990         uint256 lockedTotal;
991         uint256 rewardTotal;
992     }
993 
994     product[] public products;
995     mapping(uint256 => productSales) public sales;
996 
997     function getProductCount() public view returns (uint256) {
998         return products.length;
999     }
1000 
1001     function addProduct(
1002         string memory _name,
1003         uint256 _lockDays,
1004         uint256 _basedAPY
1005     ) external virtual onlyOwner {
1006         products.push(product(_name, _lockDays, _basedAPY, true));
1007     }
1008 
1009     function changeAPY(uint256 _productId, uint256 _APY) external virtual onlyOwner {
1010         products[_productId].basedAPY = _APY;
1011     }
1012 
1013     function offTheShelf(uint256 _productId) external virtual onlyOwner {
1014         products[_productId].onSale = false;
1015     }
1016 
1017     function deposit(uint256 _productId, uint256 _amount)
1018         external
1019         virtual
1020         returns (bool)
1021     {
1022         product memory prod = products[_productId];
1023         require(prod.onSale, "product is not vaild");
1024         mulan.safeTransferFrom(msg.sender, address(lock), _amount);
1025         uint256 releaseTime = prod.lockDays * 1 days + block.timestamp;
1026         uint256 reward = _amount * prod.basedAPY / _base * prod.lockDays / _year;
1027 
1028         sales[_productId].lockedTotal += _amount;
1029         sales[_productId].rewardTotal += reward;
1030         return lock.lockByWhitelist(msg.sender, _amount, reward, releaseTime);
1031     }
1032 
1033     function withdraw(uint256 _lockNumber) external virtual returns (bool) {
1034         (, uint256 reward, , ) =
1035             lock.getDetailOf(msg.sender, _lockNumber);
1036         lock.releaseByWhitelist(msg.sender, _lockNumber);
1037         mulan2.mintByWhitelist(msg.sender, reward);
1038         return true;
1039     }
1040 }