1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 enum MessengerProtocol {
5     None,
6     Allbridge,
7     Wormhole,
8     LayerZero
9 }
10 
11 interface IBridge {
12     function receiveTokens(
13         uint256 amount,
14         bytes32 recipient,
15         uint8 destinationChainId,
16         bytes32 receiveToken,
17         uint256 nonce,
18         MessengerProtocol messenger
19     ) external;
20 }
21 
22 /**
23  * @dev Provides information about the current execution context, including the
24  * sender of the transaction and its data. While these are generally available
25  * via msg.sender and msg.data, they should not be accessed in such a direct
26  * manner, since when dealing with meta-transactions the account sending and
27  * paying for execution may not be the actual sender (as far as an application
28  * is concerned).
29  *
30  * This contract is only required for intermediate, library-like contracts.
31  */
32 abstract contract Context {
33     function _msgSender() internal view virtual returns (address) {
34         return msg.sender;
35     }
36 
37     function _msgData() internal view virtual returns (bytes calldata) {
38         return msg.data;
39     }
40 }
41 
42 /**
43  * @dev Contract module which provides a basic access control mechanism, where
44  * there is an account (an owner) that can be granted exclusive access to
45  * specific functions.
46  *
47  * By default, the owner account will be the one that deploys the contract. This
48  * can later be changed with {transferOwnership}.
49  *
50  * This module is used through inheritance. It will make available the modifier
51  * `onlyOwner`, which can be applied to your functions to restrict their use to
52  * the owner.
53  */
54 abstract contract Ownable is Context {
55     address private _owner;
56 
57     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
58 
59     /**
60      * @dev Initializes the contract setting the deployer as the initial owner.
61      */
62     constructor() {
63         _transferOwnership(_msgSender());
64     }
65 
66     /**
67      * @dev Throws if called by any account other than the owner.
68      */
69     modifier onlyOwner() {
70         _checkOwner();
71         _;
72     }
73 
74     /**
75      * @dev Returns the address of the current owner.
76      */
77     function owner() public view virtual returns (address) {
78         return _owner;
79     }
80 
81     /**
82      * @dev Throws if the sender is not the owner.
83      */
84     function _checkOwner() internal view virtual {
85         require(owner() == _msgSender(), "Ownable: caller is not the owner");
86     }
87 
88     /**
89      * @dev Leaves the contract without owner. It will not be possible to call
90      * `onlyOwner` functions anymore. Can only be called by the current owner.
91      *
92      * NOTE: Renouncing ownership will leave the contract without an owner,
93      * thereby removing any functionality that is only available to the owner.
94      */
95     function renounceOwnership() public virtual onlyOwner {
96         _transferOwnership(address(0));
97     }
98 
99     /**
100      * @dev Transfers ownership of the contract to a new account (`newOwner`).
101      * Can only be called by the current owner.
102      */
103     function transferOwnership(address newOwner) public virtual onlyOwner {
104         require(newOwner != address(0), "Ownable: new owner is the zero address");
105         _transferOwnership(newOwner);
106     }
107 
108     /**
109      * @dev Transfers ownership of the contract to a new account (`newOwner`).
110      * Internal function without access restriction.
111      */
112     function _transferOwnership(address newOwner) internal virtual {
113         address oldOwner = _owner;
114         _owner = newOwner;
115         emit OwnershipTransferred(oldOwner, newOwner);
116     }
117 }
118 
119 /**
120  * @dev Interface of the ERC20 standard as defined in the EIP.
121  */
122 interface IERC20 {
123     /**
124      * @dev Emitted when `value` tokens are moved from one account (`from`) to
125      * another (`to`).
126      *
127      * Note that `value` may be zero.
128      */
129     event Transfer(address indexed from, address indexed to, uint256 value);
130 
131     /**
132      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
133      * a call to {approve}. `value` is the new allowance.
134      */
135     event Approval(address indexed owner, address indexed spender, uint256 value);
136 
137     /**
138      * @dev Returns the amount of tokens in existence.
139      */
140     function totalSupply() external view returns (uint256);
141 
142     /**
143      * @dev Returns the amount of tokens owned by `account`.
144      */
145     function balanceOf(address account) external view returns (uint256);
146 
147     /**
148      * @dev Moves `amount` tokens from the caller's account to `to`.
149      *
150      * Returns a boolean value indicating whether the operation succeeded.
151      *
152      * Emits a {Transfer} event.
153      */
154     function transfer(address to, uint256 amount) external returns (bool);
155 
156     /**
157      * @dev Returns the remaining number of tokens that `spender` will be
158      * allowed to spend on behalf of `owner` through {transferFrom}. This is
159      * zero by default.
160      *
161      * This value changes when {approve} or {transferFrom} are called.
162      */
163     function allowance(address owner, address spender) external view returns (uint256);
164 
165     /**
166      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
167      *
168      * Returns a boolean value indicating whether the operation succeeded.
169      *
170      * IMPORTANT: Beware that changing an allowance with this method brings the risk
171      * that someone may use both the old and the new allowance by unfortunate
172      * transaction ordering. One possible solution to mitigate this race
173      * condition is to first reduce the spender's allowance to 0 and set the
174      * desired value afterwards:
175      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
176      *
177      * Emits an {Approval} event.
178      */
179     function approve(address spender, uint256 amount) external returns (bool);
180 
181     /**
182      * @dev Moves `amount` tokens from `from` to `to` using the
183      * allowance mechanism. `amount` is then deducted from the caller's
184      * allowance.
185      *
186      * Returns a boolean value indicating whether the operation succeeded.
187      *
188      * Emits a {Transfer} event.
189      */
190     function transferFrom(
191         address from,
192         address to,
193         uint256 amount
194     ) external returns (bool);
195 }
196 
197 /**
198  * @dev Interface for the optional metadata functions from the ERC20 standard.
199  *
200  * _Available since v4.1._
201  */
202 interface IERC20Metadata is IERC20 {
203     /**
204      * @dev Returns the name of the token.
205      */
206     function name() external view returns (string memory);
207 
208     /**
209      * @dev Returns the symbol of the token.
210      */
211     function symbol() external view returns (string memory);
212 
213     /**
214      * @dev Returns the decimals places of the token.
215      */
216     function decimals() external view returns (uint8);
217 }
218 
219 /**
220  * @dev Implementation of the {IERC20} interface.
221  *
222  * This implementation is agnostic to the way tokens are created. This means
223  * that a supply mechanism has to be added in a derived contract using {_mint}.
224  * For a generic mechanism see {ERC20PresetMinterPauser}.
225  *
226  * TIP: For a detailed writeup see our guide
227  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
228  * to implement supply mechanisms].
229  *
230  * We have followed general OpenZeppelin Contracts guidelines: functions revert
231  * instead returning `false` on failure. This behavior is nonetheless
232  * conventional and does not conflict with the expectations of ERC20
233  * applications.
234  *
235  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
236  * This allows applications to reconstruct the allowance for all accounts just
237  * by listening to said events. Other implementations of the EIP may not emit
238  * these events, as it isn't required by the specification.
239  *
240  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
241  * functions have been added to mitigate the well-known issues around setting
242  * allowances. See {IERC20-approve}.
243  */
244 contract ERC20 is Context, IERC20, IERC20Metadata {
245     mapping(address => uint256) private _balances;
246 
247     mapping(address => mapping(address => uint256)) private _allowances;
248 
249     uint256 private _totalSupply;
250 
251     string private _name;
252     string private _symbol;
253 
254     /**
255      * @dev Sets the values for {name} and {symbol}.
256      *
257      * The default value of {decimals} is 18. To select a different value for
258      * {decimals} you should overload it.
259      *
260      * All two of these values are immutable: they can only be set once during
261      * construction.
262      */
263     constructor(string memory name_, string memory symbol_) {
264         _name = name_;
265         _symbol = symbol_;
266     }
267 
268     /**
269      * @dev Returns the name of the token.
270      */
271     function name() public view virtual override returns (string memory) {
272         return _name;
273     }
274 
275     /**
276      * @dev Returns the symbol of the token, usually a shorter version of the
277      * name.
278      */
279     function symbol() public view virtual override returns (string memory) {
280         return _symbol;
281     }
282 
283     /**
284      * @dev Returns the number of decimals used to get its user representation.
285      * For example, if `decimals` equals `2`, a balance of `505` tokens should
286      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
287      *
288      * Tokens usually opt for a value of 18, imitating the relationship between
289      * Ether and Wei. This is the value {ERC20} uses, unless this function is
290      * overridden;
291      *
292      * NOTE: This information is only used for _display_ purposes: it in
293      * no way affects any of the arithmetic of the contract, including
294      * {IERC20-balanceOf} and {IERC20-transfer}.
295      */
296     function decimals() public view virtual override returns (uint8) {
297         return 18;
298     }
299 
300     /**
301      * @dev See {IERC20-totalSupply}.
302      */
303     function totalSupply() public view virtual override returns (uint256) {
304         return _totalSupply;
305     }
306 
307     /**
308      * @dev See {IERC20-balanceOf}.
309      */
310     function balanceOf(address account) public view virtual override returns (uint256) {
311         return _balances[account];
312     }
313 
314     /**
315      * @dev See {IERC20-transfer}.
316      *
317      * Requirements:
318      *
319      * - `to` cannot be the zero address.
320      * - the caller must have a balance of at least `amount`.
321      */
322     function transfer(address to, uint256 amount) public virtual override returns (bool) {
323         address owner = _msgSender();
324         _transfer(owner, to, amount);
325         return true;
326     }
327 
328     /**
329      * @dev See {IERC20-allowance}.
330      */
331     function allowance(address owner, address spender) public view virtual override returns (uint256) {
332         return _allowances[owner][spender];
333     }
334 
335     /**
336      * @dev See {IERC20-approve}.
337      *
338      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
339      * `transferFrom`. This is semantically equivalent to an infinite approval.
340      *
341      * Requirements:
342      *
343      * - `spender` cannot be the zero address.
344      */
345     function approve(address spender, uint256 amount) public virtual override returns (bool) {
346         address owner = _msgSender();
347         _approve(owner, spender, amount);
348         return true;
349     }
350 
351     /**
352      * @dev See {IERC20-transferFrom}.
353      *
354      * Emits an {Approval} event indicating the updated allowance. This is not
355      * required by the EIP. See the note at the beginning of {ERC20}.
356      *
357      * NOTE: Does not update the allowance if the current allowance
358      * is the maximum `uint256`.
359      *
360      * Requirements:
361      *
362      * - `from` and `to` cannot be the zero address.
363      * - `from` must have a balance of at least `amount`.
364      * - the caller must have allowance for ``from``'s tokens of at least
365      * `amount`.
366      */
367     function transferFrom(
368         address from,
369         address to,
370         uint256 amount
371     ) public virtual override returns (bool) {
372         address spender = _msgSender();
373         _spendAllowance(from, spender, amount);
374         _transfer(from, to, amount);
375         return true;
376     }
377 
378     /**
379      * @dev Atomically increases the allowance granted to `spender` by the caller.
380      *
381      * This is an alternative to {approve} that can be used as a mitigation for
382      * problems described in {IERC20-approve}.
383      *
384      * Emits an {Approval} event indicating the updated allowance.
385      *
386      * Requirements:
387      *
388      * - `spender` cannot be the zero address.
389      */
390     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
391         address owner = _msgSender();
392         _approve(owner, spender, allowance(owner, spender) + addedValue);
393         return true;
394     }
395 
396     /**
397      * @dev Atomically decreases the allowance granted to `spender` by the caller.
398      *
399      * This is an alternative to {approve} that can be used as a mitigation for
400      * problems described in {IERC20-approve}.
401      *
402      * Emits an {Approval} event indicating the updated allowance.
403      *
404      * Requirements:
405      *
406      * - `spender` cannot be the zero address.
407      * - `spender` must have allowance for the caller of at least
408      * `subtractedValue`.
409      */
410     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
411         address owner = _msgSender();
412         uint256 currentAllowance = allowance(owner, spender);
413         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
414         unchecked {
415             _approve(owner, spender, currentAllowance - subtractedValue);
416         }
417 
418         return true;
419     }
420 
421     /**
422      * @dev Moves `amount` of tokens from `from` to `to`.
423      *
424      * This internal function is equivalent to {transfer}, and can be used to
425      * e.g. implement automatic token fees, slashing mechanisms, etc.
426      *
427      * Emits a {Transfer} event.
428      *
429      * Requirements:
430      *
431      * - `from` cannot be the zero address.
432      * - `to` cannot be the zero address.
433      * - `from` must have a balance of at least `amount`.
434      */
435     function _transfer(
436         address from,
437         address to,
438         uint256 amount
439     ) internal virtual {
440         require(from != address(0), "ERC20: transfer from the zero address");
441         require(to != address(0), "ERC20: transfer to the zero address");
442 
443         _beforeTokenTransfer(from, to, amount);
444 
445         uint256 fromBalance = _balances[from];
446         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
447         unchecked {
448             _balances[from] = fromBalance - amount;
449         }
450         _balances[to] += amount;
451 
452         emit Transfer(from, to, amount);
453 
454         _afterTokenTransfer(from, to, amount);
455     }
456 
457     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
458      * the total supply.
459      *
460      * Emits a {Transfer} event with `from` set to the zero address.
461      *
462      * Requirements:
463      *
464      * - `account` cannot be the zero address.
465      */
466     function _mint(address account, uint256 amount) internal virtual {
467         require(account != address(0), "ERC20: mint to the zero address");
468 
469         _beforeTokenTransfer(address(0), account, amount);
470 
471         _totalSupply += amount;
472         _balances[account] += amount;
473         emit Transfer(address(0), account, amount);
474 
475         _afterTokenTransfer(address(0), account, amount);
476     }
477 
478     /**
479      * @dev Destroys `amount` tokens from `account`, reducing the
480      * total supply.
481      *
482      * Emits a {Transfer} event with `to` set to the zero address.
483      *
484      * Requirements:
485      *
486      * - `account` cannot be the zero address.
487      * - `account` must have at least `amount` tokens.
488      */
489     function _burn(address account, uint256 amount) internal virtual {
490         require(account != address(0), "ERC20: burn from the zero address");
491 
492         _beforeTokenTransfer(account, address(0), amount);
493 
494         uint256 accountBalance = _balances[account];
495         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
496         unchecked {
497             _balances[account] = accountBalance - amount;
498         }
499         _totalSupply -= amount;
500 
501         emit Transfer(account, address(0), amount);
502 
503         _afterTokenTransfer(account, address(0), amount);
504     }
505 
506     /**
507      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
508      *
509      * This internal function is equivalent to `approve`, and can be used to
510      * e.g. set automatic allowances for certain subsystems, etc.
511      *
512      * Emits an {Approval} event.
513      *
514      * Requirements:
515      *
516      * - `owner` cannot be the zero address.
517      * - `spender` cannot be the zero address.
518      */
519     function _approve(
520         address owner,
521         address spender,
522         uint256 amount
523     ) internal virtual {
524         require(owner != address(0), "ERC20: approve from the zero address");
525         require(spender != address(0), "ERC20: approve to the zero address");
526 
527         _allowances[owner][spender] = amount;
528         emit Approval(owner, spender, amount);
529     }
530 
531     /**
532      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
533      *
534      * Does not update the allowance amount in case of infinite allowance.
535      * Revert if not enough allowance is available.
536      *
537      * Might emit an {Approval} event.
538      */
539     function _spendAllowance(
540         address owner,
541         address spender,
542         uint256 amount
543     ) internal virtual {
544         uint256 currentAllowance = allowance(owner, spender);
545         if (currentAllowance != type(uint256).max) {
546             require(currentAllowance >= amount, "ERC20: insufficient allowance");
547             unchecked {
548                 _approve(owner, spender, currentAllowance - amount);
549             }
550         }
551     }
552 
553     /**
554      * @dev Hook that is called before any transfer of tokens. This includes
555      * minting and burning.
556      *
557      * Calling conditions:
558      *
559      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
560      * will be transferred to `to`.
561      * - when `from` is zero, `amount` tokens will be minted for `to`.
562      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
563      * - `from` and `to` are never both zero.
564      *
565      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
566      */
567     function _beforeTokenTransfer(
568         address from,
569         address to,
570         uint256 amount
571     ) internal virtual {}
572 
573     /**
574      * @dev Hook that is called after any transfer of tokens. This includes
575      * minting and burning.
576      *
577      * Calling conditions:
578      *
579      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
580      * has been transferred to `to`.
581      * - when `from` is zero, `amount` tokens have been minted for `to`.
582      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
583      * - `from` and `to` are never both zero.
584      *
585      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
586      */
587     function _afterTokenTransfer(
588         address from,
589         address to,
590         uint256 amount
591     ) internal virtual {}
592 }
593 
594 /**
595  * @dev Interface of the ERC20 Permit extension allowing approvals to be made via signatures, as defined in
596  * https://eips.ethereum.org/EIPS/eip-2612[EIP-2612].
597  *
598  * Adds the {permit} method, which can be used to change an account's ERC20 allowance (see {IERC20-allowance}) by
599  * presenting a message signed by the account. By not relying on {IERC20-approve}, the token holder account doesn't
600  * need to send a transaction, and thus is not required to hold Ether at all.
601  */
602 interface IERC20Permit {
603     /**
604      * @dev Sets `value` as the allowance of `spender` over ``owner``'s tokens,
605      * given ``owner``'s signed approval.
606      *
607      * IMPORTANT: The same issues {IERC20-approve} has related to transaction
608      * ordering also apply here.
609      *
610      * Emits an {Approval} event.
611      *
612      * Requirements:
613      *
614      * - `spender` cannot be the zero address.
615      * - `deadline` must be a timestamp in the future.
616      * - `v`, `r` and `s` must be a valid `secp256k1` signature from `owner`
617      * over the EIP712-formatted function arguments.
618      * - the signature must use ``owner``'s current nonce (see {nonces}).
619      *
620      * For more information on the signature format, see the
621      * https://eips.ethereum.org/EIPS/eip-2612#specification[relevant EIP
622      * section].
623      */
624     function permit(
625         address owner,
626         address spender,
627         uint256 value,
628         uint256 deadline,
629         uint8 v,
630         bytes32 r,
631         bytes32 s
632     ) external;
633 
634     /**
635      * @dev Returns the current nonce for `owner`. This value must be
636      * included whenever a signature is generated for {permit}.
637      *
638      * Every successful call to {permit} increases ``owner``'s nonce by one. This
639      * prevents a signature from being used multiple times.
640      */
641     function nonces(address owner) external view returns (uint256);
642 
643     /**
644      * @dev Returns the domain separator used in the encoding of the signature for {permit}, as defined by {EIP712}.
645      */
646     // solhint-disable-next-line func-name-mixedcase
647     function DOMAIN_SEPARATOR() external view returns (bytes32);
648 }
649 
650 /**
651  * @dev Collection of functions related to the address type
652  */
653 library Address {
654     /**
655      * @dev Returns true if `account` is a contract.
656      *
657      * [IMPORTANT]
658      * ====
659      * It is unsafe to assume that an address for which this function returns
660      * false is an externally-owned account (EOA) and not a contract.
661      *
662      * Among others, `isContract` will return false for the following
663      * types of addresses:
664      *
665      *  - an externally-owned account
666      *  - a contract in construction
667      *  - an address where a contract will be created
668      *  - an address where a contract lived, but was destroyed
669      * ====
670      *
671      * [IMPORTANT]
672      * ====
673      * You shouldn't rely on `isContract` to protect against flash loan attacks!
674      *
675      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
676      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
677      * constructor.
678      * ====
679      */
680     function isContract(address account) internal view returns (bool) {
681         // This method relies on extcodesize/address.code.length, which returns 0
682         // for contracts in construction, since the code is only stored at the end
683         // of the constructor execution.
684 
685         return account.code.length > 0;
686     }
687 
688     /**
689      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
690      * `recipient`, forwarding all available gas and reverting on errors.
691      *
692      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
693      * of certain opcodes, possibly making contracts go over the 2300 gas limit
694      * imposed by `transfer`, making them unable to receive funds via
695      * `transfer`. {sendValue} removes this limitation.
696      *
697      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
698      *
699      * IMPORTANT: because control is transferred to `recipient`, care must be
700      * taken to not create reentrancy vulnerabilities. Consider using
701      * {ReentrancyGuard} or the
702      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
703      */
704     function sendValue(address payable recipient, uint256 amount) internal {
705         require(address(this).balance >= amount, "Address: insufficient balance");
706 
707         (bool success, ) = recipient.call{value: amount}("");
708         require(success, "Address: unable to send value, recipient may have reverted");
709     }
710 
711     /**
712      * @dev Performs a Solidity function call using a low level `call`. A
713      * plain `call` is an unsafe replacement for a function call: use this
714      * function instead.
715      *
716      * If `target` reverts with a revert reason, it is bubbled up by this
717      * function (like regular Solidity function calls).
718      *
719      * Returns the raw returned data. To convert to the expected return value,
720      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
721      *
722      * Requirements:
723      *
724      * - `target` must be a contract.
725      * - calling `target` with `data` must not revert.
726      *
727      * _Available since v3.1._
728      */
729     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
730         return functionCall(target, data, "Address: low-level call failed");
731     }
732 
733     /**
734      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
735      * `errorMessage` as a fallback revert reason when `target` reverts.
736      *
737      * _Available since v3.1._
738      */
739     function functionCall(
740         address target,
741         bytes memory data,
742         string memory errorMessage
743     ) internal returns (bytes memory) {
744         return functionCallWithValue(target, data, 0, errorMessage);
745     }
746 
747     /**
748      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
749      * but also transferring `value` wei to `target`.
750      *
751      * Requirements:
752      *
753      * - the calling contract must have an ETH balance of at least `value`.
754      * - the called Solidity function must be `payable`.
755      *
756      * _Available since v3.1._
757      */
758     function functionCallWithValue(
759         address target,
760         bytes memory data,
761         uint256 value
762     ) internal returns (bytes memory) {
763         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
764     }
765 
766     /**
767      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
768      * with `errorMessage` as a fallback revert reason when `target` reverts.
769      *
770      * _Available since v3.1._
771      */
772     function functionCallWithValue(
773         address target,
774         bytes memory data,
775         uint256 value,
776         string memory errorMessage
777     ) internal returns (bytes memory) {
778         require(address(this).balance >= value, "Address: insufficient balance for call");
779         require(isContract(target), "Address: call to non-contract");
780 
781         (bool success, bytes memory returndata) = target.call{value: value}(data);
782         return verifyCallResult(success, returndata, errorMessage);
783     }
784 
785     /**
786      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
787      * but performing a static call.
788      *
789      * _Available since v3.3._
790      */
791     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
792         return functionStaticCall(target, data, "Address: low-level static call failed");
793     }
794 
795     /**
796      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
797      * but performing a static call.
798      *
799      * _Available since v3.3._
800      */
801     function functionStaticCall(
802         address target,
803         bytes memory data,
804         string memory errorMessage
805     ) internal view returns (bytes memory) {
806         require(isContract(target), "Address: static call to non-contract");
807 
808         (bool success, bytes memory returndata) = target.staticcall(data);
809         return verifyCallResult(success, returndata, errorMessage);
810     }
811 
812     /**
813      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
814      * but performing a delegate call.
815      *
816      * _Available since v3.4._
817      */
818     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
819         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
820     }
821 
822     /**
823      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
824      * but performing a delegate call.
825      *
826      * _Available since v3.4._
827      */
828     function functionDelegateCall(
829         address target,
830         bytes memory data,
831         string memory errorMessage
832     ) internal returns (bytes memory) {
833         require(isContract(target), "Address: delegate call to non-contract");
834 
835         (bool success, bytes memory returndata) = target.delegatecall(data);
836         return verifyCallResult(success, returndata, errorMessage);
837     }
838 
839     /**
840      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
841      * revert reason using the provided one.
842      *
843      * _Available since v4.3._
844      */
845     function verifyCallResult(
846         bool success,
847         bytes memory returndata,
848         string memory errorMessage
849     ) internal pure returns (bytes memory) {
850         if (success) {
851             return returndata;
852         } else {
853             // Look for revert reason and bubble it up if present
854             if (returndata.length > 0) {
855                 // The easiest way to bubble the revert reason is using memory via assembly
856                 /// @solidity memory-safe-assembly
857                 assembly {
858                     let returndata_size := mload(returndata)
859                     revert(add(32, returndata), returndata_size)
860                 }
861             } else {
862                 revert(errorMessage);
863             }
864         }
865     }
866 }
867 
868 /**
869  * @title SafeERC20
870  * @dev Wrappers around ERC20 operations that throw on failure (when the token
871  * contract returns false). Tokens that return no value (and instead revert or
872  * throw on failure) are also supported, non-reverting calls are assumed to be
873  * successful.
874  * To use this library you can add a `using SafeERC20 for IERC20;` statement to your contract,
875  * which allows you to call the safe operations as `token.safeTransfer(...)`, etc.
876  */
877 library SafeERC20 {
878     using Address for address;
879 
880     function safeTransfer(
881         IERC20 token,
882         address to,
883         uint256 value
884     ) internal {
885         _callOptionalReturn(token, abi.encodeWithSelector(token.transfer.selector, to, value));
886     }
887 
888     function safeTransferFrom(
889         IERC20 token,
890         address from,
891         address to,
892         uint256 value
893     ) internal {
894         _callOptionalReturn(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
895     }
896 
897     /**
898      * @dev Deprecated. This function has issues similar to the ones found in
899      * {IERC20-approve}, and its usage is discouraged.
900      *
901      * Whenever possible, use {safeIncreaseAllowance} and
902      * {safeDecreaseAllowance} instead.
903      */
904     function safeApprove(
905         IERC20 token,
906         address spender,
907         uint256 value
908     ) internal {
909         // safeApprove should only be called when setting an initial allowance,
910         // or when resetting it to zero. To increase and decrease it, use
911         // 'safeIncreaseAllowance' and 'safeDecreaseAllowance'
912         require(
913             (value == 0) || (token.allowance(address(this), spender) == 0),
914             "SafeERC20: approve from non-zero to non-zero allowance"
915         );
916         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, value));
917     }
918 
919     function safeIncreaseAllowance(
920         IERC20 token,
921         address spender,
922         uint256 value
923     ) internal {
924         uint256 newAllowance = token.allowance(address(this), spender) + value;
925         _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
926     }
927 
928     function safeDecreaseAllowance(
929         IERC20 token,
930         address spender,
931         uint256 value
932     ) internal {
933         unchecked {
934             uint256 oldAllowance = token.allowance(address(this), spender);
935             require(oldAllowance >= value, "SafeERC20: decreased allowance below zero");
936             uint256 newAllowance = oldAllowance - value;
937             _callOptionalReturn(token, abi.encodeWithSelector(token.approve.selector, spender, newAllowance));
938         }
939     }
940 
941     function safePermit(
942         IERC20Permit token,
943         address owner,
944         address spender,
945         uint256 value,
946         uint256 deadline,
947         uint8 v,
948         bytes32 r,
949         bytes32 s
950     ) internal {
951         uint256 nonceBefore = token.nonces(owner);
952         token.permit(owner, spender, value, deadline, v, r, s);
953         uint256 nonceAfter = token.nonces(owner);
954         require(nonceAfter == nonceBefore + 1, "SafeERC20: permit did not succeed");
955     }
956 
957     /**
958      * @dev Imitates a Solidity high-level call (i.e. a regular function call to a contract), relaxing the requirement
959      * on the return value: the return value is optional (but if data is returned, it must not be false).
960      * @param token The token targeted by the call.
961      * @param data The call data (encoded using abi.encode or one of its variants).
962      */
963     function _callOptionalReturn(IERC20 token, bytes memory data) private {
964         // We need to perform a low level call here, to bypass Solidity's return data size checking mechanism, since
965         // we're implementing it ourselves. We use {Address.functionCall} to perform this call, which verifies that
966         // the target address contains contract code and also asserts for success in the low-level call.
967 
968         bytes memory returndata = address(token).functionCall(data, "SafeERC20: low-level call failed");
969         if (returndata.length > 0) {
970             // Return data is optional
971             require(abi.decode(returndata, (bool)), "SafeERC20: ERC20 operation did not succeed");
972         }
973     }
974 }
975 
976 /**
977  * @dev Standard math utilities missing in the Solidity language.
978  */
979 library Math {
980     enum Rounding {
981         Down, // Toward negative infinity
982         Up, // Toward infinity
983         Zero // Toward zero
984     }
985 
986     /**
987      * @dev Returns the largest of two numbers.
988      */
989     function max(uint256 a, uint256 b) internal pure returns (uint256) {
990         return a >= b ? a : b;
991     }
992 
993     /**
994      * @dev Returns the smallest of two numbers.
995      */
996     function min(uint256 a, uint256 b) internal pure returns (uint256) {
997         return a < b ? a : b;
998     }
999 
1000     /**
1001      * @dev Returns the average of two numbers. The result is rounded towards
1002      * zero.
1003      */
1004     function average(uint256 a, uint256 b) internal pure returns (uint256) {
1005         // (a + b) / 2 can overflow.
1006         return (a & b) + (a ^ b) / 2;
1007     }
1008 
1009     /**
1010      * @dev Returns the ceiling of the division of two numbers.
1011      *
1012      * This differs from standard division with `/` in that it rounds up instead
1013      * of rounding down.
1014      */
1015     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
1016         // (a + b - 1) / b can overflow on addition, so we distribute.
1017         return a == 0 ? 0 : (a - 1) / b + 1;
1018     }
1019 
1020     /**
1021      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
1022      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
1023      * with further edits by Uniswap Labs also under MIT license.
1024      */
1025     function mulDiv(
1026         uint256 x,
1027         uint256 y,
1028         uint256 denominator
1029     ) internal pure returns (uint256 result) {
1030         unchecked {
1031             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
1032             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
1033             // variables such that product = prod1 * 2^256 + prod0.
1034             uint256 prod0; // Least significant 256 bits of the product
1035             uint256 prod1; // Most significant 256 bits of the product
1036             assembly {
1037                 let mm := mulmod(x, y, not(0))
1038                 prod0 := mul(x, y)
1039                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
1040             }
1041 
1042             // Handle non-overflow cases, 256 by 256 division.
1043             if (prod1 == 0) {
1044                 return prod0 / denominator;
1045             }
1046 
1047             // Make sure the result is less than 2^256. Also prevents denominator == 0.
1048             require(denominator > prod1);
1049 
1050             ///////////////////////////////////////////////
1051             // 512 by 256 division.
1052             ///////////////////////////////////////////////
1053 
1054             // Make division exact by subtracting the remainder from [prod1 prod0].
1055             uint256 remainder;
1056             assembly {
1057                 // Compute remainder using mulmod.
1058                 remainder := mulmod(x, y, denominator)
1059 
1060                 // Subtract 256 bit number from 512 bit number.
1061                 prod1 := sub(prod1, gt(remainder, prod0))
1062                 prod0 := sub(prod0, remainder)
1063             }
1064 
1065             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
1066             // See https://cs.stackexchange.com/q/138556/92363.
1067 
1068             // Does not overflow because the denominator cannot be zero at this stage in the function.
1069             uint256 twos = denominator & (~denominator + 1);
1070             assembly {
1071                 // Divide denominator by twos.
1072                 denominator := div(denominator, twos)
1073 
1074                 // Divide [prod1 prod0] by twos.
1075                 prod0 := div(prod0, twos)
1076 
1077                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
1078                 twos := add(div(sub(0, twos), twos), 1)
1079             }
1080 
1081             // Shift in bits from prod1 into prod0.
1082             prod0 |= prod1 * twos;
1083 
1084             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
1085             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
1086             // four bits. That is, denominator * inv = 1 mod 2^4.
1087             uint256 inverse = (3 * denominator) ^ 2;
1088 
1089             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
1090             // in modular arithmetic, doubling the correct bits in each step.
1091             inverse *= 2 - denominator * inverse; // inverse mod 2^8
1092             inverse *= 2 - denominator * inverse; // inverse mod 2^16
1093             inverse *= 2 - denominator * inverse; // inverse mod 2^32
1094             inverse *= 2 - denominator * inverse; // inverse mod 2^64
1095             inverse *= 2 - denominator * inverse; // inverse mod 2^128
1096             inverse *= 2 - denominator * inverse; // inverse mod 2^256
1097 
1098             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
1099             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
1100             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
1101             // is no longer required.
1102             result = prod0 * inverse;
1103             return result;
1104         }
1105     }
1106 
1107     /**
1108      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
1109      */
1110     function mulDiv(
1111         uint256 x,
1112         uint256 y,
1113         uint256 denominator,
1114         Rounding rounding
1115     ) internal pure returns (uint256) {
1116         uint256 result = mulDiv(x, y, denominator);
1117         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
1118             result += 1;
1119         }
1120         return result;
1121     }
1122 
1123     /**
1124      * @dev Returns the square root of a number. It the number is not a perfect square, the value is rounded down.
1125      *
1126      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
1127      */
1128     function sqrt(uint256 a) internal pure returns (uint256) {
1129         if (a == 0) {
1130             return 0;
1131         }
1132 
1133         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
1134         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
1135         // `msb(a) <= a < 2*msb(a)`.
1136         // We also know that `k`, the position of the most significant bit, is such that `msb(a) = 2**k`.
1137         // This gives `2**k < a <= 2**(k+1)` → `2**(k/2) <= sqrt(a) < 2 ** (k/2+1)`.
1138         // Using an algorithm similar to the msb conmputation, we are able to compute `result = 2**(k/2)` which is a
1139         // good first aproximation of `sqrt(a)` with at least 1 correct bit.
1140         uint256 result = 1;
1141         uint256 x = a;
1142         if (x >> 128 > 0) {
1143             x >>= 128;
1144             result <<= 64;
1145         }
1146         if (x >> 64 > 0) {
1147             x >>= 64;
1148             result <<= 32;
1149         }
1150         if (x >> 32 > 0) {
1151             x >>= 32;
1152             result <<= 16;
1153         }
1154         if (x >> 16 > 0) {
1155             x >>= 16;
1156             result <<= 8;
1157         }
1158         if (x >> 8 > 0) {
1159             x >>= 8;
1160             result <<= 4;
1161         }
1162         if (x >> 4 > 0) {
1163             x >>= 4;
1164             result <<= 2;
1165         }
1166         if (x >> 2 > 0) {
1167             result <<= 1;
1168         }
1169 
1170         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
1171         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
1172         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
1173         // into the expected uint128 result.
1174         unchecked {
1175             result = (result + a / result) >> 1;
1176             result = (result + a / result) >> 1;
1177             result = (result + a / result) >> 1;
1178             result = (result + a / result) >> 1;
1179             result = (result + a / result) >> 1;
1180             result = (result + a / result) >> 1;
1181             result = (result + a / result) >> 1;
1182             return min(result, a / result);
1183         }
1184     }
1185 
1186     /**
1187      * @notice Calculates sqrt(a), following the selected rounding direction.
1188      */
1189     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
1190         uint256 result = sqrt(a);
1191         if (rounding == Rounding.Up && result * result < a) {
1192             result += 1;
1193         }
1194         return result;
1195     }
1196 }
1197 
1198 /**
1199  * @dev Wrappers over Solidity's uintXX/intXX casting operators with added overflow
1200  * checks.
1201  *
1202  * Downcasting from uint256/int256 in Solidity does not revert on overflow. This can
1203  * easily result in undesired exploitation or bugs, since developers usually
1204  * assume that overflows raise errors. `SafeCast` restores this intuition by
1205  * reverting the transaction when such an operation overflows.
1206  *
1207  * Using this library instead of the unchecked operations eliminates an entire
1208  * class of bugs, so it's recommended to use it always.
1209  *
1210  * Can be combined with {SafeMath} and {SignedSafeMath} to extend it to smaller types, by performing
1211  * all math on `uint256` and `int256` and then downcasting.
1212  */
1213 library SafeCast {
1214     /**
1215      * @dev Returns the downcasted uint248 from uint256, reverting on
1216      * overflow (when the input is greater than largest uint248).
1217      *
1218      * Counterpart to Solidity's `uint248` operator.
1219      *
1220      * Requirements:
1221      *
1222      * - input must fit into 248 bits
1223      *
1224      * _Available since v4.7._
1225      */
1226     function toUint248(uint256 value) internal pure returns (uint248) {
1227         require(value <= type(uint248).max, "SafeCast: value doesn't fit in 248 bits");
1228         return uint248(value);
1229     }
1230 
1231     /**
1232      * @dev Returns the downcasted uint240 from uint256, reverting on
1233      * overflow (when the input is greater than largest uint240).
1234      *
1235      * Counterpart to Solidity's `uint240` operator.
1236      *
1237      * Requirements:
1238      *
1239      * - input must fit into 240 bits
1240      *
1241      * _Available since v4.7._
1242      */
1243     function toUint240(uint256 value) internal pure returns (uint240) {
1244         require(value <= type(uint240).max, "SafeCast: value doesn't fit in 240 bits");
1245         return uint240(value);
1246     }
1247 
1248     /**
1249      * @dev Returns the downcasted uint232 from uint256, reverting on
1250      * overflow (when the input is greater than largest uint232).
1251      *
1252      * Counterpart to Solidity's `uint232` operator.
1253      *
1254      * Requirements:
1255      *
1256      * - input must fit into 232 bits
1257      *
1258      * _Available since v4.7._
1259      */
1260     function toUint232(uint256 value) internal pure returns (uint232) {
1261         require(value <= type(uint232).max, "SafeCast: value doesn't fit in 232 bits");
1262         return uint232(value);
1263     }
1264 
1265     /**
1266      * @dev Returns the downcasted uint224 from uint256, reverting on
1267      * overflow (when the input is greater than largest uint224).
1268      *
1269      * Counterpart to Solidity's `uint224` operator.
1270      *
1271      * Requirements:
1272      *
1273      * - input must fit into 224 bits
1274      *
1275      * _Available since v4.2._
1276      */
1277     function toUint224(uint256 value) internal pure returns (uint224) {
1278         require(value <= type(uint224).max, "SafeCast: value doesn't fit in 224 bits");
1279         return uint224(value);
1280     }
1281 
1282     /**
1283      * @dev Returns the downcasted uint216 from uint256, reverting on
1284      * overflow (when the input is greater than largest uint216).
1285      *
1286      * Counterpart to Solidity's `uint216` operator.
1287      *
1288      * Requirements:
1289      *
1290      * - input must fit into 216 bits
1291      *
1292      * _Available since v4.7._
1293      */
1294     function toUint216(uint256 value) internal pure returns (uint216) {
1295         require(value <= type(uint216).max, "SafeCast: value doesn't fit in 216 bits");
1296         return uint216(value);
1297     }
1298 
1299     /**
1300      * @dev Returns the downcasted uint208 from uint256, reverting on
1301      * overflow (when the input is greater than largest uint208).
1302      *
1303      * Counterpart to Solidity's `uint208` operator.
1304      *
1305      * Requirements:
1306      *
1307      * - input must fit into 208 bits
1308      *
1309      * _Available since v4.7._
1310      */
1311     function toUint208(uint256 value) internal pure returns (uint208) {
1312         require(value <= type(uint208).max, "SafeCast: value doesn't fit in 208 bits");
1313         return uint208(value);
1314     }
1315 
1316     /**
1317      * @dev Returns the downcasted uint200 from uint256, reverting on
1318      * overflow (when the input is greater than largest uint200).
1319      *
1320      * Counterpart to Solidity's `uint200` operator.
1321      *
1322      * Requirements:
1323      *
1324      * - input must fit into 200 bits
1325      *
1326      * _Available since v4.7._
1327      */
1328     function toUint200(uint256 value) internal pure returns (uint200) {
1329         require(value <= type(uint200).max, "SafeCast: value doesn't fit in 200 bits");
1330         return uint200(value);
1331     }
1332 
1333     /**
1334      * @dev Returns the downcasted uint192 from uint256, reverting on
1335      * overflow (when the input is greater than largest uint192).
1336      *
1337      * Counterpart to Solidity's `uint192` operator.
1338      *
1339      * Requirements:
1340      *
1341      * - input must fit into 192 bits
1342      *
1343      * _Available since v4.7._
1344      */
1345     function toUint192(uint256 value) internal pure returns (uint192) {
1346         require(value <= type(uint192).max, "SafeCast: value doesn't fit in 192 bits");
1347         return uint192(value);
1348     }
1349 
1350     /**
1351      * @dev Returns the downcasted uint184 from uint256, reverting on
1352      * overflow (when the input is greater than largest uint184).
1353      *
1354      * Counterpart to Solidity's `uint184` operator.
1355      *
1356      * Requirements:
1357      *
1358      * - input must fit into 184 bits
1359      *
1360      * _Available since v4.7._
1361      */
1362     function toUint184(uint256 value) internal pure returns (uint184) {
1363         require(value <= type(uint184).max, "SafeCast: value doesn't fit in 184 bits");
1364         return uint184(value);
1365     }
1366 
1367     /**
1368      * @dev Returns the downcasted uint176 from uint256, reverting on
1369      * overflow (when the input is greater than largest uint176).
1370      *
1371      * Counterpart to Solidity's `uint176` operator.
1372      *
1373      * Requirements:
1374      *
1375      * - input must fit into 176 bits
1376      *
1377      * _Available since v4.7._
1378      */
1379     function toUint176(uint256 value) internal pure returns (uint176) {
1380         require(value <= type(uint176).max, "SafeCast: value doesn't fit in 176 bits");
1381         return uint176(value);
1382     }
1383 
1384     /**
1385      * @dev Returns the downcasted uint168 from uint256, reverting on
1386      * overflow (when the input is greater than largest uint168).
1387      *
1388      * Counterpart to Solidity's `uint168` operator.
1389      *
1390      * Requirements:
1391      *
1392      * - input must fit into 168 bits
1393      *
1394      * _Available since v4.7._
1395      */
1396     function toUint168(uint256 value) internal pure returns (uint168) {
1397         require(value <= type(uint168).max, "SafeCast: value doesn't fit in 168 bits");
1398         return uint168(value);
1399     }
1400 
1401     /**
1402      * @dev Returns the downcasted uint160 from uint256, reverting on
1403      * overflow (when the input is greater than largest uint160).
1404      *
1405      * Counterpart to Solidity's `uint160` operator.
1406      *
1407      * Requirements:
1408      *
1409      * - input must fit into 160 bits
1410      *
1411      * _Available since v4.7._
1412      */
1413     function toUint160(uint256 value) internal pure returns (uint160) {
1414         require(value <= type(uint160).max, "SafeCast: value doesn't fit in 160 bits");
1415         return uint160(value);
1416     }
1417 
1418     /**
1419      * @dev Returns the downcasted uint152 from uint256, reverting on
1420      * overflow (when the input is greater than largest uint152).
1421      *
1422      * Counterpart to Solidity's `uint152` operator.
1423      *
1424      * Requirements:
1425      *
1426      * - input must fit into 152 bits
1427      *
1428      * _Available since v4.7._
1429      */
1430     function toUint152(uint256 value) internal pure returns (uint152) {
1431         require(value <= type(uint152).max, "SafeCast: value doesn't fit in 152 bits");
1432         return uint152(value);
1433     }
1434 
1435     /**
1436      * @dev Returns the downcasted uint144 from uint256, reverting on
1437      * overflow (when the input is greater than largest uint144).
1438      *
1439      * Counterpart to Solidity's `uint144` operator.
1440      *
1441      * Requirements:
1442      *
1443      * - input must fit into 144 bits
1444      *
1445      * _Available since v4.7._
1446      */
1447     function toUint144(uint256 value) internal pure returns (uint144) {
1448         require(value <= type(uint144).max, "SafeCast: value doesn't fit in 144 bits");
1449         return uint144(value);
1450     }
1451 
1452     /**
1453      * @dev Returns the downcasted uint136 from uint256, reverting on
1454      * overflow (when the input is greater than largest uint136).
1455      *
1456      * Counterpart to Solidity's `uint136` operator.
1457      *
1458      * Requirements:
1459      *
1460      * - input must fit into 136 bits
1461      *
1462      * _Available since v4.7._
1463      */
1464     function toUint136(uint256 value) internal pure returns (uint136) {
1465         require(value <= type(uint136).max, "SafeCast: value doesn't fit in 136 bits");
1466         return uint136(value);
1467     }
1468 
1469     /**
1470      * @dev Returns the downcasted uint128 from uint256, reverting on
1471      * overflow (when the input is greater than largest uint128).
1472      *
1473      * Counterpart to Solidity's `uint128` operator.
1474      *
1475      * Requirements:
1476      *
1477      * - input must fit into 128 bits
1478      *
1479      * _Available since v2.5._
1480      */
1481     function toUint128(uint256 value) internal pure returns (uint128) {
1482         require(value <= type(uint128).max, "SafeCast: value doesn't fit in 128 bits");
1483         return uint128(value);
1484     }
1485 
1486     /**
1487      * @dev Returns the downcasted uint120 from uint256, reverting on
1488      * overflow (when the input is greater than largest uint120).
1489      *
1490      * Counterpart to Solidity's `uint120` operator.
1491      *
1492      * Requirements:
1493      *
1494      * - input must fit into 120 bits
1495      *
1496      * _Available since v4.7._
1497      */
1498     function toUint120(uint256 value) internal pure returns (uint120) {
1499         require(value <= type(uint120).max, "SafeCast: value doesn't fit in 120 bits");
1500         return uint120(value);
1501     }
1502 
1503     /**
1504      * @dev Returns the downcasted uint112 from uint256, reverting on
1505      * overflow (when the input is greater than largest uint112).
1506      *
1507      * Counterpart to Solidity's `uint112` operator.
1508      *
1509      * Requirements:
1510      *
1511      * - input must fit into 112 bits
1512      *
1513      * _Available since v4.7._
1514      */
1515     function toUint112(uint256 value) internal pure returns (uint112) {
1516         require(value <= type(uint112).max, "SafeCast: value doesn't fit in 112 bits");
1517         return uint112(value);
1518     }
1519 
1520     /**
1521      * @dev Returns the downcasted uint104 from uint256, reverting on
1522      * overflow (when the input is greater than largest uint104).
1523      *
1524      * Counterpart to Solidity's `uint104` operator.
1525      *
1526      * Requirements:
1527      *
1528      * - input must fit into 104 bits
1529      *
1530      * _Available since v4.7._
1531      */
1532     function toUint104(uint256 value) internal pure returns (uint104) {
1533         require(value <= type(uint104).max, "SafeCast: value doesn't fit in 104 bits");
1534         return uint104(value);
1535     }
1536 
1537     /**
1538      * @dev Returns the downcasted uint96 from uint256, reverting on
1539      * overflow (when the input is greater than largest uint96).
1540      *
1541      * Counterpart to Solidity's `uint96` operator.
1542      *
1543      * Requirements:
1544      *
1545      * - input must fit into 96 bits
1546      *
1547      * _Available since v4.2._
1548      */
1549     function toUint96(uint256 value) internal pure returns (uint96) {
1550         require(value <= type(uint96).max, "SafeCast: value doesn't fit in 96 bits");
1551         return uint96(value);
1552     }
1553 
1554     /**
1555      * @dev Returns the downcasted uint88 from uint256, reverting on
1556      * overflow (when the input is greater than largest uint88).
1557      *
1558      * Counterpart to Solidity's `uint88` operator.
1559      *
1560      * Requirements:
1561      *
1562      * - input must fit into 88 bits
1563      *
1564      * _Available since v4.7._
1565      */
1566     function toUint88(uint256 value) internal pure returns (uint88) {
1567         require(value <= type(uint88).max, "SafeCast: value doesn't fit in 88 bits");
1568         return uint88(value);
1569     }
1570 
1571     /**
1572      * @dev Returns the downcasted uint80 from uint256, reverting on
1573      * overflow (when the input is greater than largest uint80).
1574      *
1575      * Counterpart to Solidity's `uint80` operator.
1576      *
1577      * Requirements:
1578      *
1579      * - input must fit into 80 bits
1580      *
1581      * _Available since v4.7._
1582      */
1583     function toUint80(uint256 value) internal pure returns (uint80) {
1584         require(value <= type(uint80).max, "SafeCast: value doesn't fit in 80 bits");
1585         return uint80(value);
1586     }
1587 
1588     /**
1589      * @dev Returns the downcasted uint72 from uint256, reverting on
1590      * overflow (when the input is greater than largest uint72).
1591      *
1592      * Counterpart to Solidity's `uint72` operator.
1593      *
1594      * Requirements:
1595      *
1596      * - input must fit into 72 bits
1597      *
1598      * _Available since v4.7._
1599      */
1600     function toUint72(uint256 value) internal pure returns (uint72) {
1601         require(value <= type(uint72).max, "SafeCast: value doesn't fit in 72 bits");
1602         return uint72(value);
1603     }
1604 
1605     /**
1606      * @dev Returns the downcasted uint64 from uint256, reverting on
1607      * overflow (when the input is greater than largest uint64).
1608      *
1609      * Counterpart to Solidity's `uint64` operator.
1610      *
1611      * Requirements:
1612      *
1613      * - input must fit into 64 bits
1614      *
1615      * _Available since v2.5._
1616      */
1617     function toUint64(uint256 value) internal pure returns (uint64) {
1618         require(value <= type(uint64).max, "SafeCast: value doesn't fit in 64 bits");
1619         return uint64(value);
1620     }
1621 
1622     /**
1623      * @dev Returns the downcasted uint56 from uint256, reverting on
1624      * overflow (when the input is greater than largest uint56).
1625      *
1626      * Counterpart to Solidity's `uint56` operator.
1627      *
1628      * Requirements:
1629      *
1630      * - input must fit into 56 bits
1631      *
1632      * _Available since v4.7._
1633      */
1634     function toUint56(uint256 value) internal pure returns (uint56) {
1635         require(value <= type(uint56).max, "SafeCast: value doesn't fit in 56 bits");
1636         return uint56(value);
1637     }
1638 
1639     /**
1640      * @dev Returns the downcasted uint48 from uint256, reverting on
1641      * overflow (when the input is greater than largest uint48).
1642      *
1643      * Counterpart to Solidity's `uint48` operator.
1644      *
1645      * Requirements:
1646      *
1647      * - input must fit into 48 bits
1648      *
1649      * _Available since v4.7._
1650      */
1651     function toUint48(uint256 value) internal pure returns (uint48) {
1652         require(value <= type(uint48).max, "SafeCast: value doesn't fit in 48 bits");
1653         return uint48(value);
1654     }
1655 
1656     /**
1657      * @dev Returns the downcasted uint40 from uint256, reverting on
1658      * overflow (when the input is greater than largest uint40).
1659      *
1660      * Counterpart to Solidity's `uint40` operator.
1661      *
1662      * Requirements:
1663      *
1664      * - input must fit into 40 bits
1665      *
1666      * _Available since v4.7._
1667      */
1668     function toUint40(uint256 value) internal pure returns (uint40) {
1669         require(value <= type(uint40).max, "SafeCast: value doesn't fit in 40 bits");
1670         return uint40(value);
1671     }
1672 
1673     /**
1674      * @dev Returns the downcasted uint32 from uint256, reverting on
1675      * overflow (when the input is greater than largest uint32).
1676      *
1677      * Counterpart to Solidity's `uint32` operator.
1678      *
1679      * Requirements:
1680      *
1681      * - input must fit into 32 bits
1682      *
1683      * _Available since v2.5._
1684      */
1685     function toUint32(uint256 value) internal pure returns (uint32) {
1686         require(value <= type(uint32).max, "SafeCast: value doesn't fit in 32 bits");
1687         return uint32(value);
1688     }
1689 
1690     /**
1691      * @dev Returns the downcasted uint24 from uint256, reverting on
1692      * overflow (when the input is greater than largest uint24).
1693      *
1694      * Counterpart to Solidity's `uint24` operator.
1695      *
1696      * Requirements:
1697      *
1698      * - input must fit into 24 bits
1699      *
1700      * _Available since v4.7._
1701      */
1702     function toUint24(uint256 value) internal pure returns (uint24) {
1703         require(value <= type(uint24).max, "SafeCast: value doesn't fit in 24 bits");
1704         return uint24(value);
1705     }
1706 
1707     /**
1708      * @dev Returns the downcasted uint16 from uint256, reverting on
1709      * overflow (when the input is greater than largest uint16).
1710      *
1711      * Counterpart to Solidity's `uint16` operator.
1712      *
1713      * Requirements:
1714      *
1715      * - input must fit into 16 bits
1716      *
1717      * _Available since v2.5._
1718      */
1719     function toUint16(uint256 value) internal pure returns (uint16) {
1720         require(value <= type(uint16).max, "SafeCast: value doesn't fit in 16 bits");
1721         return uint16(value);
1722     }
1723 
1724     /**
1725      * @dev Returns the downcasted uint8 from uint256, reverting on
1726      * overflow (when the input is greater than largest uint8).
1727      *
1728      * Counterpart to Solidity's `uint8` operator.
1729      *
1730      * Requirements:
1731      *
1732      * - input must fit into 8 bits
1733      *
1734      * _Available since v2.5._
1735      */
1736     function toUint8(uint256 value) internal pure returns (uint8) {
1737         require(value <= type(uint8).max, "SafeCast: value doesn't fit in 8 bits");
1738         return uint8(value);
1739     }
1740 
1741     /**
1742      * @dev Converts a signed int256 into an unsigned uint256.
1743      *
1744      * Requirements:
1745      *
1746      * - input must be greater than or equal to 0.
1747      *
1748      * _Available since v3.0._
1749      */
1750     function toUint256(int256 value) internal pure returns (uint256) {
1751         require(value >= 0, "SafeCast: value must be positive");
1752         return uint256(value);
1753     }
1754 
1755     /**
1756      * @dev Returns the downcasted int248 from int256, reverting on
1757      * overflow (when the input is less than smallest int248 or
1758      * greater than largest int248).
1759      *
1760      * Counterpart to Solidity's `int248` operator.
1761      *
1762      * Requirements:
1763      *
1764      * - input must fit into 248 bits
1765      *
1766      * _Available since v4.7._
1767      */
1768     function toInt248(int256 value) internal pure returns (int248) {
1769         require(value >= type(int248).min && value <= type(int248).max, "SafeCast: value doesn't fit in 248 bits");
1770         return int248(value);
1771     }
1772 
1773     /**
1774      * @dev Returns the downcasted int240 from int256, reverting on
1775      * overflow (when the input is less than smallest int240 or
1776      * greater than largest int240).
1777      *
1778      * Counterpart to Solidity's `int240` operator.
1779      *
1780      * Requirements:
1781      *
1782      * - input must fit into 240 bits
1783      *
1784      * _Available since v4.7._
1785      */
1786     function toInt240(int256 value) internal pure returns (int240) {
1787         require(value >= type(int240).min && value <= type(int240).max, "SafeCast: value doesn't fit in 240 bits");
1788         return int240(value);
1789     }
1790 
1791     /**
1792      * @dev Returns the downcasted int232 from int256, reverting on
1793      * overflow (when the input is less than smallest int232 or
1794      * greater than largest int232).
1795      *
1796      * Counterpart to Solidity's `int232` operator.
1797      *
1798      * Requirements:
1799      *
1800      * - input must fit into 232 bits
1801      *
1802      * _Available since v4.7._
1803      */
1804     function toInt232(int256 value) internal pure returns (int232) {
1805         require(value >= type(int232).min && value <= type(int232).max, "SafeCast: value doesn't fit in 232 bits");
1806         return int232(value);
1807     }
1808 
1809     /**
1810      * @dev Returns the downcasted int224 from int256, reverting on
1811      * overflow (when the input is less than smallest int224 or
1812      * greater than largest int224).
1813      *
1814      * Counterpart to Solidity's `int224` operator.
1815      *
1816      * Requirements:
1817      *
1818      * - input must fit into 224 bits
1819      *
1820      * _Available since v4.7._
1821      */
1822     function toInt224(int256 value) internal pure returns (int224) {
1823         require(value >= type(int224).min && value <= type(int224).max, "SafeCast: value doesn't fit in 224 bits");
1824         return int224(value);
1825     }
1826 
1827     /**
1828      * @dev Returns the downcasted int216 from int256, reverting on
1829      * overflow (when the input is less than smallest int216 or
1830      * greater than largest int216).
1831      *
1832      * Counterpart to Solidity's `int216` operator.
1833      *
1834      * Requirements:
1835      *
1836      * - input must fit into 216 bits
1837      *
1838      * _Available since v4.7._
1839      */
1840     function toInt216(int256 value) internal pure returns (int216) {
1841         require(value >= type(int216).min && value <= type(int216).max, "SafeCast: value doesn't fit in 216 bits");
1842         return int216(value);
1843     }
1844 
1845     /**
1846      * @dev Returns the downcasted int208 from int256, reverting on
1847      * overflow (when the input is less than smallest int208 or
1848      * greater than largest int208).
1849      *
1850      * Counterpart to Solidity's `int208` operator.
1851      *
1852      * Requirements:
1853      *
1854      * - input must fit into 208 bits
1855      *
1856      * _Available since v4.7._
1857      */
1858     function toInt208(int256 value) internal pure returns (int208) {
1859         require(value >= type(int208).min && value <= type(int208).max, "SafeCast: value doesn't fit in 208 bits");
1860         return int208(value);
1861     }
1862 
1863     /**
1864      * @dev Returns the downcasted int200 from int256, reverting on
1865      * overflow (when the input is less than smallest int200 or
1866      * greater than largest int200).
1867      *
1868      * Counterpart to Solidity's `int200` operator.
1869      *
1870      * Requirements:
1871      *
1872      * - input must fit into 200 bits
1873      *
1874      * _Available since v4.7._
1875      */
1876     function toInt200(int256 value) internal pure returns (int200) {
1877         require(value >= type(int200).min && value <= type(int200).max, "SafeCast: value doesn't fit in 200 bits");
1878         return int200(value);
1879     }
1880 
1881     /**
1882      * @dev Returns the downcasted int192 from int256, reverting on
1883      * overflow (when the input is less than smallest int192 or
1884      * greater than largest int192).
1885      *
1886      * Counterpart to Solidity's `int192` operator.
1887      *
1888      * Requirements:
1889      *
1890      * - input must fit into 192 bits
1891      *
1892      * _Available since v4.7._
1893      */
1894     function toInt192(int256 value) internal pure returns (int192) {
1895         require(value >= type(int192).min && value <= type(int192).max, "SafeCast: value doesn't fit in 192 bits");
1896         return int192(value);
1897     }
1898 
1899     /**
1900      * @dev Returns the downcasted int184 from int256, reverting on
1901      * overflow (when the input is less than smallest int184 or
1902      * greater than largest int184).
1903      *
1904      * Counterpart to Solidity's `int184` operator.
1905      *
1906      * Requirements:
1907      *
1908      * - input must fit into 184 bits
1909      *
1910      * _Available since v4.7._
1911      */
1912     function toInt184(int256 value) internal pure returns (int184) {
1913         require(value >= type(int184).min && value <= type(int184).max, "SafeCast: value doesn't fit in 184 bits");
1914         return int184(value);
1915     }
1916 
1917     /**
1918      * @dev Returns the downcasted int176 from int256, reverting on
1919      * overflow (when the input is less than smallest int176 or
1920      * greater than largest int176).
1921      *
1922      * Counterpart to Solidity's `int176` operator.
1923      *
1924      * Requirements:
1925      *
1926      * - input must fit into 176 bits
1927      *
1928      * _Available since v4.7._
1929      */
1930     function toInt176(int256 value) internal pure returns (int176) {
1931         require(value >= type(int176).min && value <= type(int176).max, "SafeCast: value doesn't fit in 176 bits");
1932         return int176(value);
1933     }
1934 
1935     /**
1936      * @dev Returns the downcasted int168 from int256, reverting on
1937      * overflow (when the input is less than smallest int168 or
1938      * greater than largest int168).
1939      *
1940      * Counterpart to Solidity's `int168` operator.
1941      *
1942      * Requirements:
1943      *
1944      * - input must fit into 168 bits
1945      *
1946      * _Available since v4.7._
1947      */
1948     function toInt168(int256 value) internal pure returns (int168) {
1949         require(value >= type(int168).min && value <= type(int168).max, "SafeCast: value doesn't fit in 168 bits");
1950         return int168(value);
1951     }
1952 
1953     /**
1954      * @dev Returns the downcasted int160 from int256, reverting on
1955      * overflow (when the input is less than smallest int160 or
1956      * greater than largest int160).
1957      *
1958      * Counterpart to Solidity's `int160` operator.
1959      *
1960      * Requirements:
1961      *
1962      * - input must fit into 160 bits
1963      *
1964      * _Available since v4.7._
1965      */
1966     function toInt160(int256 value) internal pure returns (int160) {
1967         require(value >= type(int160).min && value <= type(int160).max, "SafeCast: value doesn't fit in 160 bits");
1968         return int160(value);
1969     }
1970 
1971     /**
1972      * @dev Returns the downcasted int152 from int256, reverting on
1973      * overflow (when the input is less than smallest int152 or
1974      * greater than largest int152).
1975      *
1976      * Counterpart to Solidity's `int152` operator.
1977      *
1978      * Requirements:
1979      *
1980      * - input must fit into 152 bits
1981      *
1982      * _Available since v4.7._
1983      */
1984     function toInt152(int256 value) internal pure returns (int152) {
1985         require(value >= type(int152).min && value <= type(int152).max, "SafeCast: value doesn't fit in 152 bits");
1986         return int152(value);
1987     }
1988 
1989     /**
1990      * @dev Returns the downcasted int144 from int256, reverting on
1991      * overflow (when the input is less than smallest int144 or
1992      * greater than largest int144).
1993      *
1994      * Counterpart to Solidity's `int144` operator.
1995      *
1996      * Requirements:
1997      *
1998      * - input must fit into 144 bits
1999      *
2000      * _Available since v4.7._
2001      */
2002     function toInt144(int256 value) internal pure returns (int144) {
2003         require(value >= type(int144).min && value <= type(int144).max, "SafeCast: value doesn't fit in 144 bits");
2004         return int144(value);
2005     }
2006 
2007     /**
2008      * @dev Returns the downcasted int136 from int256, reverting on
2009      * overflow (when the input is less than smallest int136 or
2010      * greater than largest int136).
2011      *
2012      * Counterpart to Solidity's `int136` operator.
2013      *
2014      * Requirements:
2015      *
2016      * - input must fit into 136 bits
2017      *
2018      * _Available since v4.7._
2019      */
2020     function toInt136(int256 value) internal pure returns (int136) {
2021         require(value >= type(int136).min && value <= type(int136).max, "SafeCast: value doesn't fit in 136 bits");
2022         return int136(value);
2023     }
2024 
2025     /**
2026      * @dev Returns the downcasted int128 from int256, reverting on
2027      * overflow (when the input is less than smallest int128 or
2028      * greater than largest int128).
2029      *
2030      * Counterpart to Solidity's `int128` operator.
2031      *
2032      * Requirements:
2033      *
2034      * - input must fit into 128 bits
2035      *
2036      * _Available since v3.1._
2037      */
2038     function toInt128(int256 value) internal pure returns (int128) {
2039         require(value >= type(int128).min && value <= type(int128).max, "SafeCast: value doesn't fit in 128 bits");
2040         return int128(value);
2041     }
2042 
2043     /**
2044      * @dev Returns the downcasted int120 from int256, reverting on
2045      * overflow (when the input is less than smallest int120 or
2046      * greater than largest int120).
2047      *
2048      * Counterpart to Solidity's `int120` operator.
2049      *
2050      * Requirements:
2051      *
2052      * - input must fit into 120 bits
2053      *
2054      * _Available since v4.7._
2055      */
2056     function toInt120(int256 value) internal pure returns (int120) {
2057         require(value >= type(int120).min && value <= type(int120).max, "SafeCast: value doesn't fit in 120 bits");
2058         return int120(value);
2059     }
2060 
2061     /**
2062      * @dev Returns the downcasted int112 from int256, reverting on
2063      * overflow (when the input is less than smallest int112 or
2064      * greater than largest int112).
2065      *
2066      * Counterpart to Solidity's `int112` operator.
2067      *
2068      * Requirements:
2069      *
2070      * - input must fit into 112 bits
2071      *
2072      * _Available since v4.7._
2073      */
2074     function toInt112(int256 value) internal pure returns (int112) {
2075         require(value >= type(int112).min && value <= type(int112).max, "SafeCast: value doesn't fit in 112 bits");
2076         return int112(value);
2077     }
2078 
2079     /**
2080      * @dev Returns the downcasted int104 from int256, reverting on
2081      * overflow (when the input is less than smallest int104 or
2082      * greater than largest int104).
2083      *
2084      * Counterpart to Solidity's `int104` operator.
2085      *
2086      * Requirements:
2087      *
2088      * - input must fit into 104 bits
2089      *
2090      * _Available since v4.7._
2091      */
2092     function toInt104(int256 value) internal pure returns (int104) {
2093         require(value >= type(int104).min && value <= type(int104).max, "SafeCast: value doesn't fit in 104 bits");
2094         return int104(value);
2095     }
2096 
2097     /**
2098      * @dev Returns the downcasted int96 from int256, reverting on
2099      * overflow (when the input is less than smallest int96 or
2100      * greater than largest int96).
2101      *
2102      * Counterpart to Solidity's `int96` operator.
2103      *
2104      * Requirements:
2105      *
2106      * - input must fit into 96 bits
2107      *
2108      * _Available since v4.7._
2109      */
2110     function toInt96(int256 value) internal pure returns (int96) {
2111         require(value >= type(int96).min && value <= type(int96).max, "SafeCast: value doesn't fit in 96 bits");
2112         return int96(value);
2113     }
2114 
2115     /**
2116      * @dev Returns the downcasted int88 from int256, reverting on
2117      * overflow (when the input is less than smallest int88 or
2118      * greater than largest int88).
2119      *
2120      * Counterpart to Solidity's `int88` operator.
2121      *
2122      * Requirements:
2123      *
2124      * - input must fit into 88 bits
2125      *
2126      * _Available since v4.7._
2127      */
2128     function toInt88(int256 value) internal pure returns (int88) {
2129         require(value >= type(int88).min && value <= type(int88).max, "SafeCast: value doesn't fit in 88 bits");
2130         return int88(value);
2131     }
2132 
2133     /**
2134      * @dev Returns the downcasted int80 from int256, reverting on
2135      * overflow (when the input is less than smallest int80 or
2136      * greater than largest int80).
2137      *
2138      * Counterpart to Solidity's `int80` operator.
2139      *
2140      * Requirements:
2141      *
2142      * - input must fit into 80 bits
2143      *
2144      * _Available since v4.7._
2145      */
2146     function toInt80(int256 value) internal pure returns (int80) {
2147         require(value >= type(int80).min && value <= type(int80).max, "SafeCast: value doesn't fit in 80 bits");
2148         return int80(value);
2149     }
2150 
2151     /**
2152      * @dev Returns the downcasted int72 from int256, reverting on
2153      * overflow (when the input is less than smallest int72 or
2154      * greater than largest int72).
2155      *
2156      * Counterpart to Solidity's `int72` operator.
2157      *
2158      * Requirements:
2159      *
2160      * - input must fit into 72 bits
2161      *
2162      * _Available since v4.7._
2163      */
2164     function toInt72(int256 value) internal pure returns (int72) {
2165         require(value >= type(int72).min && value <= type(int72).max, "SafeCast: value doesn't fit in 72 bits");
2166         return int72(value);
2167     }
2168 
2169     /**
2170      * @dev Returns the downcasted int64 from int256, reverting on
2171      * overflow (when the input is less than smallest int64 or
2172      * greater than largest int64).
2173      *
2174      * Counterpart to Solidity's `int64` operator.
2175      *
2176      * Requirements:
2177      *
2178      * - input must fit into 64 bits
2179      *
2180      * _Available since v3.1._
2181      */
2182     function toInt64(int256 value) internal pure returns (int64) {
2183         require(value >= type(int64).min && value <= type(int64).max, "SafeCast: value doesn't fit in 64 bits");
2184         return int64(value);
2185     }
2186 
2187     /**
2188      * @dev Returns the downcasted int56 from int256, reverting on
2189      * overflow (when the input is less than smallest int56 or
2190      * greater than largest int56).
2191      *
2192      * Counterpart to Solidity's `int56` operator.
2193      *
2194      * Requirements:
2195      *
2196      * - input must fit into 56 bits
2197      *
2198      * _Available since v4.7._
2199      */
2200     function toInt56(int256 value) internal pure returns (int56) {
2201         require(value >= type(int56).min && value <= type(int56).max, "SafeCast: value doesn't fit in 56 bits");
2202         return int56(value);
2203     }
2204 
2205     /**
2206      * @dev Returns the downcasted int48 from int256, reverting on
2207      * overflow (when the input is less than smallest int48 or
2208      * greater than largest int48).
2209      *
2210      * Counterpart to Solidity's `int48` operator.
2211      *
2212      * Requirements:
2213      *
2214      * - input must fit into 48 bits
2215      *
2216      * _Available since v4.7._
2217      */
2218     function toInt48(int256 value) internal pure returns (int48) {
2219         require(value >= type(int48).min && value <= type(int48).max, "SafeCast: value doesn't fit in 48 bits");
2220         return int48(value);
2221     }
2222 
2223     /**
2224      * @dev Returns the downcasted int40 from int256, reverting on
2225      * overflow (when the input is less than smallest int40 or
2226      * greater than largest int40).
2227      *
2228      * Counterpart to Solidity's `int40` operator.
2229      *
2230      * Requirements:
2231      *
2232      * - input must fit into 40 bits
2233      *
2234      * _Available since v4.7._
2235      */
2236     function toInt40(int256 value) internal pure returns (int40) {
2237         require(value >= type(int40).min && value <= type(int40).max, "SafeCast: value doesn't fit in 40 bits");
2238         return int40(value);
2239     }
2240 
2241     /**
2242      * @dev Returns the downcasted int32 from int256, reverting on
2243      * overflow (when the input is less than smallest int32 or
2244      * greater than largest int32).
2245      *
2246      * Counterpart to Solidity's `int32` operator.
2247      *
2248      * Requirements:
2249      *
2250      * - input must fit into 32 bits
2251      *
2252      * _Available since v3.1._
2253      */
2254     function toInt32(int256 value) internal pure returns (int32) {
2255         require(value >= type(int32).min && value <= type(int32).max, "SafeCast: value doesn't fit in 32 bits");
2256         return int32(value);
2257     }
2258 
2259     /**
2260      * @dev Returns the downcasted int24 from int256, reverting on
2261      * overflow (when the input is less than smallest int24 or
2262      * greater than largest int24).
2263      *
2264      * Counterpart to Solidity's `int24` operator.
2265      *
2266      * Requirements:
2267      *
2268      * - input must fit into 24 bits
2269      *
2270      * _Available since v4.7._
2271      */
2272     function toInt24(int256 value) internal pure returns (int24) {
2273         require(value >= type(int24).min && value <= type(int24).max, "SafeCast: value doesn't fit in 24 bits");
2274         return int24(value);
2275     }
2276 
2277     /**
2278      * @dev Returns the downcasted int16 from int256, reverting on
2279      * overflow (when the input is less than smallest int16 or
2280      * greater than largest int16).
2281      *
2282      * Counterpart to Solidity's `int16` operator.
2283      *
2284      * Requirements:
2285      *
2286      * - input must fit into 16 bits
2287      *
2288      * _Available since v3.1._
2289      */
2290     function toInt16(int256 value) internal pure returns (int16) {
2291         require(value >= type(int16).min && value <= type(int16).max, "SafeCast: value doesn't fit in 16 bits");
2292         return int16(value);
2293     }
2294 
2295     /**
2296      * @dev Returns the downcasted int8 from int256, reverting on
2297      * overflow (when the input is less than smallest int8 or
2298      * greater than largest int8).
2299      *
2300      * Counterpart to Solidity's `int8` operator.
2301      *
2302      * Requirements:
2303      *
2304      * - input must fit into 8 bits
2305      *
2306      * _Available since v3.1._
2307      */
2308     function toInt8(int256 value) internal pure returns (int8) {
2309         require(value >= type(int8).min && value <= type(int8).max, "SafeCast: value doesn't fit in 8 bits");
2310         return int8(value);
2311     }
2312 
2313     /**
2314      * @dev Converts an unsigned uint256 into a signed int256.
2315      *
2316      * Requirements:
2317      *
2318      * - input must be less than or equal to maxInt256.
2319      *
2320      * _Available since v3.0._
2321      */
2322     function toInt256(uint256 value) internal pure returns (int256) {
2323         // Note: Unsafe cast below is okay because `type(int256).max` is guaranteed to be positive
2324         require(value <= uint256(type(int256).max), "SafeCast: value doesn't fit in an int256");
2325         return int256(value);
2326     }
2327 }
2328 
2329 contract RewardManager is Ownable {
2330     using SafeERC20 for ERC20;
2331     uint256 private constant P = 52;
2332     uint256 private constant BP = 1e4;
2333     // Info of each user.
2334     struct UserInfo {
2335         // How many LP tokens the user has provided.
2336         uint256 lpAmount;
2337         // Reward debt.
2338         uint256 rewardDebt;
2339     }
2340     // Total virtual LP token amount
2341     uint256 public totalLpAmount;
2342     // Accumulated rewards per share, shifted left by P bits
2343     uint256 public accRewardPerShareP;
2344 
2345     // Reward token
2346     ERC20 public token;
2347     // Info of each user that stakes virtual LP tokens
2348     mapping(address => UserInfo) public userInfo;
2349 
2350     // Armin fee share (in BP)
2351     uint256 public adminFeeShareBP;
2352     // Unclaimed admin fee amount
2353     uint256 public adminFeeAmount;
2354 
2355     event Deposit(address indexed user, uint256 amount);
2356     event Withdraw(address indexed user, uint256 amount);
2357     event RewardsClaimed(address indexed user, uint256 amount);
2358 
2359     constructor(ERC20 token_) {
2360         token = token_;
2361         // Default admin fee is 20%
2362         adminFeeShareBP = BP / 5;
2363     }
2364 
2365     function setAdminFeeShare(uint256 _adminFeeShareBP) external onlyOwner {
2366         require(_adminFeeShareBP <= BP, "RewardManager: too high");
2367         adminFeeShareBP = _adminFeeShareBP;
2368     }
2369 
2370     // Add revard to the pool, split admin fee share and update accumulated rewards per share
2371     function _addRewards(uint256 rewardAmount_) internal {
2372         if (totalLpAmount > 0) {
2373             uint256 adminFeeRewards = rewardAmount_ * adminFeeShareBP / BP;
2374             unchecked {
2375                 rewardAmount_ -= adminFeeRewards;
2376             }
2377             accRewardPerShareP += (rewardAmount_ << P) / totalLpAmount;
2378             adminFeeAmount += adminFeeRewards;
2379         }
2380     }
2381 
2382     function claimAdminFee() external onlyOwner {
2383         if (adminFeeAmount > 0) {
2384             token.safeTransfer(msg.sender, adminFeeAmount);
2385             adminFeeAmount = 0;
2386         }
2387     }
2388 
2389     // Returns pending rewards for the address
2390     function pendingReward(address user_) external view returns (uint256)
2391     {
2392         UserInfo memory user = userInfo[user_];
2393         return ((user.lpAmount * accRewardPerShareP) >> P) - user.rewardDebt;
2394     }
2395 }
2396 // 4AD - D = 4A(x + y) - (D³ / 4xy)
2397 // X - is value of real stable token
2398 // Y - is value of virtual usd
2399 
2400 contract Pool is RewardManager {
2401     using SafeERC20 for ERC20;
2402     uint256 public a;
2403     int256 constant public PP = 1e4; // Price Precision
2404     uint256 private constant BP = 10000; // Basis Points
2405     uint256 private constant MAX_TOKEN_BALANCE = 2 ** 40; // Max possible token balance
2406     uint256 public feeShareBP;
2407 
2408     address public router;
2409     uint256 public tokenBalance;
2410     uint256 public vUsdBalance;
2411     uint256 public d;
2412 
2413     uint256 private tokenAmountReduce;
2414     uint256 private tokenAmountIncrease;
2415 
2416     event SwappedToVUsd(address sender, address token, uint256 amount, uint256 vUsdAmount, uint256 fee);
2417     event SwappedFromVUsd(address recipient, address token, uint256 vUsdAmount, uint256 amount, uint256 fee);
2418 
2419     constructor(address router_,
2420         uint256 a_,
2421         ERC20 token_,
2422         uint256 feeShareBP_) RewardManager(token_) {
2423         a = a_;
2424         router = router_;
2425         feeShareBP = feeShareBP_;
2426 
2427         uint8 decimals = token_.decimals();
2428         if (decimals > 3) {
2429             tokenAmountReduce = 10 ** (decimals - 3);
2430         }
2431         if (decimals < 3) {
2432             tokenAmountIncrease = 10 ** (3 - decimals);
2433         }
2434     }
2435 
2436     modifier onlyRouter() {
2437         require(router == msg.sender, "Pool: caller is not router");
2438         _;
2439     }
2440 
2441     function toSystemPrecision(uint256 amount) internal view returns (uint256) {
2442         if (tokenAmountReduce > 0) {
2443             return amount / tokenAmountReduce;
2444         } else if (tokenAmountIncrease > 0) {
2445             return amount * tokenAmountIncrease;
2446         }
2447         return amount;
2448     }
2449 
2450     function fromSystemPrecision(uint256 amount) internal view returns (uint256) {
2451         if (tokenAmountReduce > 0) {
2452             return amount * tokenAmountReduce;
2453         } else if (tokenAmountIncrease > 0) {
2454             return amount / tokenAmountIncrease;
2455         }
2456         return amount;
2457     }
2458 
2459     // Transfer amount from the user to the bridge, calculate new Y according to new X, and return the difference between old and new value
2460     function swapToVUsd(address user, uint256 amount) external onlyRouter returns (uint256) {
2461         uint256 result; // 0 by default
2462         uint256 fee;
2463         if (amount > 0) {
2464             fee = amount * feeShareBP / BP;
2465             uint256 amountIn = toSystemPrecision(amount - fee);
2466             // Incorporate rounding dust into the fee
2467             fee = amount - fromSystemPrecision(amountIn);
2468 
2469             tokenBalance += amountIn;
2470             uint256 vUsdNewAmount = this.getY(tokenBalance);
2471             if (vUsdBalance > vUsdNewAmount) {
2472                 result = vUsdBalance - vUsdNewAmount;
2473             }
2474             vUsdBalance = vUsdNewAmount;
2475             token.safeTransferFrom(user, address(this), amount);
2476             _addRewards(fee);
2477         }
2478 
2479         emit SwappedToVUsd(user, address(token), amount, result, fee);
2480         return result;
2481     }
2482 
2483     // Calculate new X according to new Y, Transfer calculated amount from the bridge to the user, and return the amount
2484     function swapFromVUsd(address user, uint256 amount) external onlyRouter returns (uint256) {
2485         uint256 result; // 0 by default
2486         uint256 fee;
2487         if (amount > 0) {
2488             vUsdBalance += amount;
2489             uint256 newAmount = this.getY(vUsdBalance);
2490             if (tokenBalance > newAmount) {
2491                 result = fromSystemPrecision(tokenBalance - newAmount);
2492             } // Otherwise result stays 0
2493             fee = result * feeShareBP / BP;
2494             // We can use unchecked here because feeShareBP <= BP
2495             unchecked {
2496                 result -= fee;
2497             }
2498             tokenBalance = newAmount;
2499             token.safeTransfer(user, result);
2500             _addRewards(fee);
2501         }
2502         emit SwappedFromVUsd(user, address(token), amount, result, fee);
2503         return result;
2504     }
2505 
2506     // y = (sqrt(x(4AD³ + x (4A(D - x) - D )²)) + x (4A(D - x) - D ))/8Ax
2507     function getY(uint256 x) external view returns (uint256) {
2508         uint256 d_ = d; // Gas optimization
2509         uint256 a4_ = a << 2;
2510         uint256 a8_ = a4_ << 1;
2511         // 4A(D - x) - D
2512         int256 part1 = int256(a4_) * (int256(d_) - int256(x)) - int256(d_);
2513         // x * (4AD³ + x(part1²))
2514         uint256 part2 = x * (a4_ * d_ * d_ * d_ + x * uint256(part1 * part1));
2515         // (sqrt(part2) + x(part1)) / 8Ax)
2516         return SafeCast.toUint256(int256(sqrt(part2)) + int256(x) * part1) / (a8_ * x) + 1;// +1 to offset rounding errors
2517     }
2518 
2519     //     price = (1/2) * ((D³ + 8ADx² - 8Ax³ - 2Dx²) / (4x * sqrt(x(4AD³ + x (4A(D - x) - D )²))))
2520     function getPrice() external view returns (uint256) {
2521         uint256 x = tokenBalance;
2522         uint256 a8_ = a << 3;
2523         uint256 d_cube_ = d * d * d;
2524 
2525         // 4A(D - x) - D
2526         int256 p1 = int256(a << 2) * (int256(d) - int256(x)) - int256(d);
2527         // x * 4AD³ + x(p1²)
2528         uint256 p2 = x * ((a << 2) * d_cube_ + x * uint256(p1 * p1));
2529         // D³ + 8ADx² - 8Ax³ - 2Dx²
2530         int256 p3 = int256(d_cube_) + int256((a << 3) * d * x * x)
2531             - int256(a8_ * x * x * x) - int256((d << 1) * x * x);
2532         // 1/2 * p3 / (4x * sqrt(p2))
2533         return SafeCast.toUint256((PP >> 1) + (PP * p3 / int256((x << 2) * sqrt(p2))));
2534     }
2535 
2536     function sqrt(uint256 n) internal pure returns (uint256) {unchecked {
2537         if (n > 0) {
2538             uint256 x = (n >> 1) + 1;
2539             uint256 y = (x + n / x) >> 1;
2540             while (x > y) {
2541                 x = y;
2542                 y = (x + n / x) >> 1;
2543             }
2544             return x;
2545         }
2546         return 0;
2547     }}
2548 
2549     function cbrt(uint256 n) internal pure returns (uint256) {unchecked {
2550         uint256 x = 0;
2551         for (uint256 y = 1 << 255; y > 0; y >>= 3) {
2552             x <<= 1;
2553             uint256 z = 3 * x * (x + 1) + 1;
2554             if (n / y >= z) {
2555                 n -= y * z;
2556                 x += 1;
2557             }
2558         }
2559         return x;
2560     }}
2561 
2562     function setFeeShare(uint256 _feeShareBP) external onlyOwner {
2563         require(_feeShareBP <= BP, "Pool: Too large");
2564         feeShareBP = _feeShareBP;
2565     }
2566 
2567     fallback() external payable {
2568         revert("Unsupported");
2569     }
2570 
2571     receive() external payable {
2572         revert("Unsupported");
2573     }
2574 
2575     //temp method
2576     function setRouter(address _router) external onlyOwner {
2577         router = _router;
2578     }
2579 }
2580 
2581 interface IRouter {
2582     function swapAndBridge(
2583         bytes32 tokenAddress,
2584         uint256 amount,
2585         bytes32 recipient,
2586         uint8 destinationChainId,
2587         bytes32 receiveTokenAddress,
2588         uint256 nonce,
2589         MessengerProtocol messenger) external payable;
2590 }
2591 
2592 abstract contract Router is Ownable, IRouter {
2593     // tokenId -> Pool
2594     mapping(bytes32 => Pool) public pools;
2595 
2596     function sendTokens(
2597         uint256 amount,
2598         bytes32 recipient,
2599         uint8 destinationChainId,
2600         bytes32 receiveToken,
2601         uint256 nonce,
2602         MessengerProtocol messenger
2603     ) virtual internal;
2604 
2605     function addPool(Pool pool, bytes32 token) external onlyOwner {
2606         pools[token] = pool;
2607     }
2608 
2609     function swapAndBridge(
2610         bytes32 token,
2611         uint256 amount,
2612         bytes32 recipient,
2613         uint8 destinationChainId,
2614         bytes32 receiveToken,
2615         uint256 nonce,
2616         MessengerProtocol messenger) external payable override
2617     {
2618         Pool tokenPool = pools[token];
2619         require(address(tokenPool) != address(0), "Router: no pool");
2620         uint256 vUsdAmount = tokenPool.swapToVUsd(msg.sender, amount);
2621         sendTokens(vUsdAmount, recipient, destinationChainId, receiveToken, nonce, messenger);
2622     }
2623 
2624     function receiveAndSwap(uint256 vUsdAmount, bytes32 token, address recipient) internal {
2625         Pool tokenPool = pools[token];
2626         require(address(tokenPool) != address(0), "Router: no pool");
2627         tokenPool.swapFromVUsd(recipient, vUsdAmount);
2628     }
2629 
2630     function swap(uint256 amount, bytes32 token, bytes32 receiveToken, address recipient) external {
2631         Pool tokenPool = pools[token];
2632         Pool receiveTokenPool = pools[receiveToken];
2633         require(address(tokenPool) != address(0), "Router: no pool");
2634         require(address(receiveTokenPool) != address(0), "Router: no pool");
2635 
2636         uint256 vUsdAmount = tokenPool.swapToVUsd(msg.sender, amount);
2637         receiveTokenPool.swapFromVUsd(recipient, vUsdAmount);
2638     }
2639 }
2640 
2641 interface Structs {
2642     struct Provider {
2643         uint16 chainId;
2644         uint16 governanceChainId;
2645         bytes32 governanceContract;
2646     }
2647 
2648     struct GuardianSet {
2649         address[] keys;
2650         uint32 expirationTime;
2651     }
2652 
2653     struct Signature {
2654         bytes32 r;
2655         bytes32 s;
2656         uint8 v;
2657         uint8 guardianIndex;
2658     }
2659 
2660     struct VM {
2661         uint8 version;
2662         uint32 timestamp;
2663         uint32 nonce;
2664         uint16 emitterChainId;
2665         bytes32 emitterAddress;
2666         uint64 sequence;
2667         uint8 consistencyLevel;
2668         bytes payload;
2669         uint32 guardianSetIndex;
2670         Signature[] signatures;
2671         bytes32 hash;
2672     }
2673 }
2674 
2675 interface IWormhole is Structs {
2676     event LogMessagePublished(
2677         address indexed sender,
2678         uint64 sequence,
2679         uint32 nonce,
2680         bytes payload,
2681         uint8 consistencyLevel
2682     );
2683 
2684     function publishMessage(
2685         uint32 nonce,
2686         bytes memory payload,
2687         uint8 consistencyLevel
2688     ) external payable returns (uint64 sequence);
2689 
2690     function parseAndVerifyVM(bytes calldata encodedVM)
2691         external
2692         view
2693         returns (
2694             Structs.VM memory vm,
2695             bool valid,
2696             string memory reason
2697         );
2698 
2699     function verifyVM(Structs.VM memory vm)
2700         external
2701         view
2702         returns (bool valid, string memory reason);
2703 
2704     function verifySignatures(
2705         bytes32 hash,
2706         Structs.Signature[] memory signatures,
2707         Structs.GuardianSet memory guardianSet
2708     ) external pure returns (bool valid, string memory reason);
2709 
2710     function parseVM(bytes memory encodedVM)
2711         external
2712         pure
2713         returns (Structs.VM memory vm);
2714 
2715     function getGuardianSet(uint32 index)
2716         external
2717         view
2718         returns (Structs.GuardianSet memory);
2719 
2720     function getCurrentGuardianSetIndex() external view returns (uint32);
2721 
2722     function getGuardianSetExpiry() external view returns (uint32);
2723 
2724     function governanceActionIsConsumed(bytes32 hash)
2725         external
2726         view
2727         returns (bool);
2728 
2729     function isInitialized(address impl) external view returns (bool);
2730 
2731     function chainId() external view returns (uint16);
2732 
2733     function governanceChainId() external view returns (uint16);
2734 
2735     function governanceContract() external view returns (bytes32);
2736 
2737     function messageFee() external view returns (uint256);
2738 }
2739 
2740 interface IGasOracle {
2741     function prices(uint8 chainId) external view returns (uint256);
2742 
2743     function setPrice(uint8 chainId, uint256 price) external;
2744 }
2745 
2746 interface IMessenger {
2747     function sentMessagesBlock(bytes32 message) external view returns (uint256);
2748 
2749     function receivedMessages(bytes32 message) external view returns (bool);
2750 
2751     function sendMessage(bytes32 message) external payable;
2752 
2753     function receiveMessage(
2754         bytes32 message,
2755         uint256 v1v2,
2756         bytes32 r1,
2757         bytes32 s1,
2758         bytes32 r2,
2759         bytes32 s2
2760     ) external;
2761 }
2762 
2763 contract GasUsage is Ownable {
2764     IGasOracle private gasOracle;
2765     mapping(uint8 => uint256) public gasUsage;
2766 
2767     constructor(
2768         IGasOracle gasOracle_
2769     ) {
2770         gasOracle = gasOracle_;
2771     }
2772 
2773     function getTransactionCost(uint8 chainId_) external view returns (uint256) {
2774         unchecked {
2775             return gasOracle.prices(chainId_) * gasUsage[chainId_];
2776         }
2777     }
2778 
2779     function setGasUsage(uint8 chainId_, uint256 gasUsage_) external onlyOwner {
2780         gasUsage[chainId_] = gasUsage_;
2781     }
2782 
2783     //temp functions
2784     function setGasOracle(IGasOracle gasOracle_) external onlyOwner {
2785         gasOracle = gasOracle_;
2786     }
2787 }
2788 
2789 contract GasOracle is Ownable, IGasOracle {
2790     mapping(uint8 => uint256) public override prices;
2791 
2792     function setPrice(uint8 chainId, uint256 price) external override onlyOwner {
2793         prices[chainId] = price;
2794     }
2795 
2796     fallback() external payable {
2797         revert("Unsupported");
2798     }
2799 
2800     receive() external payable {
2801         revert("Unsupported");
2802     }
2803 }
2804 
2805 library HashUtils {
2806 
2807     function replaceChainBytes(bytes32 data, uint8 sourceChainId, uint8 destinationChainId) internal pure returns (bytes32 result) {
2808         assembly {
2809             mstore(0x00, data)
2810             mstore8(0x00, sourceChainId)
2811             mstore8(0x01, destinationChainId)
2812             result := mload(0x0)
2813         }
2814     }
2815 
2816     function hashWithSender(bytes32 message, bytes32 sender) internal pure returns (bytes32 result) {
2817         assembly {
2818             mstore(0x00, message)
2819             mstore(0x20, sender)
2820             result := or(
2821                 and(
2822                     message,
2823                     0xffff000000000000000000000000000000000000000000000000000000000000 // First 2 bytes
2824                 ),
2825                 and(
2826                     keccak256(0x00, 0x40),
2827                     0x0000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff // Last 30 bytes
2828                 )
2829             )
2830         }
2831     }
2832 
2833     function hashWithSenderAddress(bytes32 message, address sender) internal pure returns (bytes32 result) {
2834         assembly {
2835             mstore(0x00, message)
2836             mstore(0x20, sender)
2837             result := or(
2838                 and(
2839                     message,
2840                     0xffff000000000000000000000000000000000000000000000000000000000000 // First 2 bytes
2841                 ),
2842                 and(
2843                     keccak256(0x00, 0x40),
2844                     0x0000ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff // Last 30 bytes
2845                 )
2846             )
2847         }
2848     }
2849 
2850     function hashed(bytes32 message) internal pure returns (bytes32 result) {
2851         assembly {
2852             mstore(0x00, message)
2853             result := keccak256(0x00, 0x20)
2854         }
2855     }
2856 }
2857 
2858 contract WormholeMessenger is Ownable, GasUsage {
2859     using HashUtils for bytes32;
2860 
2861     IWormhole public wormhole;
2862     uint8 public chainId;
2863     bytes32 public otherChainIds;
2864 
2865     uint32 private nonce;
2866     uint8 private commitmentLevel;
2867 
2868     mapping(uint16 => bytes32) public otherWormholeMessengers;
2869 
2870     mapping(bytes32 => bool) public receivedMessages;
2871     mapping(bytes32 => bool) public sentMessages;
2872 
2873     event MessageSent(bytes32 indexed message, uint64 sequence);
2874     event MessageReceived(bytes32 indexed message, uint64 sequence);
2875     event Received(address, uint256);
2876 
2877     constructor(uint8 chainId_, bytes32 otherChainIds_, IWormhole wormhole_, uint8 commitmentLevel_, IGasOracle gasOracle_) GasUsage(gasOracle_) {
2878         chainId = chainId_;
2879         otherChainIds = otherChainIds_;
2880         wormhole = wormhole_;
2881         commitmentLevel = commitmentLevel_;
2882     }
2883 
2884     function sendMessage(bytes32 message) external payable {
2885         require(uint8(message[0]) == chainId, "WormholeMessenger: wrong chainId");
2886         require(otherChainIds[uint8(message[1])] != 0, "Messenger: wrong destination");
2887         bytes32 messageWithSender = message.hashWithSenderAddress(msg.sender);
2888 
2889         uint32 nonce_ = nonce;
2890 
2891         uint64 sequence = wormhole.publishMessage(
2892             nonce_,
2893             abi.encodePacked(messageWithSender),
2894             commitmentLevel
2895         );
2896 
2897         unchecked {
2898             nonce = nonce_ + 1;
2899         }
2900 
2901         require(!sentMessages[messageWithSender], "WormholeMessenger: has message");
2902         sentMessages[messageWithSender] = true;
2903 
2904         emit MessageSent(messageWithSender, sequence);
2905     }
2906 
2907     function receiveMessage(bytes memory encodedMsg) external {
2908         (IWormhole.VM memory vm, bool valid, string memory reason) = wormhole
2909             .parseAndVerifyVM(encodedMsg);
2910         
2911         require(valid, reason);
2912         require(
2913             vm.payload.length == 32,
2914             "WormholeMessenger: wrong length"
2915         );
2916 
2917         bytes32 messageWithSender = bytes32(vm.payload);
2918         require(uint8(messageWithSender[1]) == chainId, "WormholeMessenger: wrong chainId");
2919         
2920         require(
2921             otherWormholeMessengers[vm.emitterChainId] == vm.emitterAddress, 
2922             "WormholeMessenger: wrong emitter"
2923         );
2924 
2925         receivedMessages[messageWithSender] = true;
2926 
2927         emit MessageReceived(messageWithSender, vm.sequence);
2928     }
2929 
2930     function setCommitmentLevel(uint8 value) external onlyOwner {
2931         commitmentLevel = value;
2932     }
2933 
2934     function setOtherChainIds(bytes32 value) external onlyOwner {
2935         otherChainIds = value;
2936     }
2937 
2938     function registerWormholeMessenger(uint16 chainId_, bytes32 address_) external onlyOwner {
2939         otherWormholeMessengers[chainId_] = address_;
2940     }
2941 
2942     function withdrawGasTokens(uint256 amount) external onlyOwner {
2943         payable(msg.sender).transfer(amount);
2944     }
2945 
2946     fallback() external payable {
2947         revert("Unsupported");
2948     }
2949 
2950     receive() external payable {
2951         emit Received(msg.sender, msg.value);
2952     }
2953 }
2954 
2955 contract Messenger is Ownable, GasUsage, IMessenger {
2956     using HashUtils for bytes32;
2957     uint8 public chainId;
2958     bytes32 public otherChainIds;
2959 
2960     address private primaryValidator;
2961 
2962     //message -> blockNumber
2963     mapping(bytes32 => uint256) public override sentMessagesBlock;
2964     mapping(bytes32 => bool) public override receivedMessages;
2965     mapping(address => bool) public secondaryValidators;
2966 
2967     event MessageSent(bytes32 indexed message);
2968     event MessageReceived(bytes32 indexed message);
2969     event Received(address, uint256);
2970 
2971     constructor(
2972         uint8 chainId_,
2973         bytes32 otherChainIds_,
2974         IGasOracle gasOracle_,
2975         address primaryValidator_,
2976         address[] memory validators_
2977     ) GasUsage(gasOracle_) {
2978         chainId = chainId_;
2979         otherChainIds = otherChainIds_;
2980         primaryValidator = primaryValidator_;
2981 
2982         uint256 length = validators_.length;
2983         for (uint256 index; index < length; ) {
2984             secondaryValidators[validators_[index]] = true;
2985             unchecked {
2986                 index++;
2987             }
2988         }
2989     }
2990 
2991     function sendMessage(bytes32 message) external payable override {
2992         require(uint8(message[0]) == chainId, 'Messenger: wrong chainId');
2993         require(
2994             otherChainIds[uint8(message[1])] != 0,
2995             'Messenger: wrong destination'
2996         );
2997 
2998         bytes32 messageWithSender = message.hashWithSenderAddress(msg.sender);
2999 
3000         uint256 existingMessageBlock;
3001         assembly {
3002             mstore(0x00, messageWithSender)
3003             mstore(0x20, sentMessagesBlock.slot)
3004             let key := keccak256(0, 0x40)
3005             existingMessageBlock := sload(key)
3006             sstore(key, number())
3007         }
3008 
3009         require(existingMessageBlock == 0, 'Messenger: has message');
3010         require(
3011             msg.value >= this.getTransactionCost(uint8(message[1])),
3012             'Messenger: not enough fee'
3013         );
3014 
3015         emit MessageSent(messageWithSender);
3016     }
3017 
3018     function receiveMessage(
3019         bytes32 message,
3020         uint256 v1v2,
3021         bytes32 r1,
3022         bytes32 s1,
3023         bytes32 r2,
3024         bytes32 s2
3025     ) external override {
3026         bytes32 hashedMessage = message.hashed();
3027         require(
3028             ecrecover(hashedMessage, uint8(v1v2 >> 8), r1, s1) ==
3029                 primaryValidator,
3030             'Messenger: invalid primary'
3031         );
3032         require(
3033             secondaryValidators[ecrecover(hashedMessage, uint8(v1v2), r2, s2)],
3034             'Messenger: invalid secondary'
3035         );
3036 
3037         require(uint8(message[1]) == chainId, 'Messenger: wrong chainId');
3038 
3039         receivedMessages[message] = true;
3040 
3041         emit MessageReceived(message);
3042     }
3043 
3044     function withdrawGasTokens(uint256 amount) external onlyOwner {
3045         payable(msg.sender).transfer(amount);
3046     }
3047 
3048     function setPrimaryValidator(address value) external onlyOwner {
3049         primaryValidator = value;
3050     }
3051 
3052     function setSecondaryValidators(
3053         address[] memory oldValidators_,
3054         address[] memory newValidators_
3055     ) external onlyOwner {
3056         uint256 length = oldValidators_.length;
3057         uint256 index;
3058         for (; index < length; ) {
3059             secondaryValidators[oldValidators_[index]] = false;
3060             unchecked {
3061                 index++;
3062             }
3063         }
3064         length = newValidators_.length;
3065         index = 0;
3066         for (; index < length; ) {
3067             secondaryValidators[newValidators_[index]] = true;
3068             unchecked {
3069                 index++;
3070             }
3071         }
3072     }
3073 
3074     function setOtherChainIds(bytes32 value) external onlyOwner {
3075         otherChainIds = value;
3076     }
3077 
3078     fallback() external payable {
3079         revert('Unsupported');
3080     }
3081 
3082     receive() external payable {
3083         emit Received(msg.sender, msg.value);
3084     }
3085 }
3086 
3087 contract MessengerGateway is Ownable {
3088     Messenger public allbridgeMessenger;
3089     WormholeMessenger public wormholeMessenger;
3090 
3091     constructor(
3092         Messenger _allbridgeMessenger,
3093         WormholeMessenger _wormholeMessenger
3094     ) {
3095         allbridgeMessenger = _allbridgeMessenger;
3096         wormholeMessenger = _wormholeMessenger;
3097     }
3098 
3099     function sendMessage(bytes32 message, MessengerProtocol protocol)
3100     internal
3101     returns (uint256 messageCost)
3102     {
3103         if (protocol == MessengerProtocol.Allbridge) {
3104             messageCost = allbridgeMessenger.getTransactionCost(uint8(message[1]));
3105             require(
3106                 messageCost <= msg.value,
3107                 "MessengerGateway: not enough fee"
3108             );
3109             allbridgeMessenger.sendMessage{value : messageCost}(message);
3110         } else if (protocol == MessengerProtocol.Wormhole) {
3111             messageCost = wormholeMessenger.getTransactionCost(uint8(message[1]));
3112             require(
3113                 messageCost <= msg.value,
3114                 "MessengerGateway: not enough fee"
3115             );
3116 
3117             wormholeMessenger.sendMessage{value : messageCost}(message);
3118         } else {
3119             revert("Not implemented");
3120         }
3121     }
3122 
3123     function hasReceivedMessage(bytes32 message, MessengerProtocol protocol) external view returns (bool)
3124     {
3125         if (protocol == MessengerProtocol.Allbridge) {
3126             return allbridgeMessenger.receivedMessages(message);
3127         } else if (protocol == MessengerProtocol.Wormhole) {
3128             return wormholeMessenger.receivedMessages(message);
3129         } else {
3130             revert("Not implemented");
3131         }
3132     }
3133 
3134     function getMessageCost(uint8 chainId, MessengerProtocol protocol)
3135     external
3136     view
3137     returns (uint256)
3138     {
3139         if (protocol == MessengerProtocol.Allbridge) {
3140             return allbridgeMessenger.getTransactionCost(chainId);
3141         } else if (protocol == MessengerProtocol.Wormhole) {
3142             return wormholeMessenger.getTransactionCost(chainId);
3143         }
3144         return 0;
3145     }
3146 
3147     function hasSentMessage(bytes32 message) external view returns (bool) {
3148         //TODO: try to check all possible protocols
3149         return allbridgeMessenger.sentMessagesBlock(message) != 0 ||
3150         wormholeMessenger.sentMessages(message);
3151     }
3152 
3153     //temp functions
3154     function setAllbridgeMessenger(Messenger _allbridgeMessenger) external onlyOwner {
3155         allbridgeMessenger = _allbridgeMessenger;
3156     }
3157 
3158     function setWormholeMessenger(WormholeMessenger _wormholeMessenger) external onlyOwner {
3159         wormholeMessenger = _wormholeMessenger;
3160     }
3161 }
3162 
3163 contract Bridge is GasUsage, Router, MessengerGateway, IBridge {
3164     using HashUtils for bytes32;
3165 
3166     uint8 public chainId;
3167     mapping(bytes32 => bool) public processedMessages;
3168     mapping(bytes32 => bool) public sentMessages;
3169     // Info about bridges and tokens on other chains
3170     mapping(uint8 => bytes32) public otherBridges;
3171     mapping(uint8 => mapping(bytes32 => bool)) public otherBridgeTokens;
3172 
3173     event TokensSent(
3174         uint256 amount,
3175         bytes32 recipient,
3176         uint8 destinationChainId,
3177         bytes32 receiveToken,
3178         uint256 nonce,
3179         MessengerProtocol messenger
3180     );
3181     event Received(address, uint256);
3182 
3183     constructor(
3184         uint8 _chainId,
3185         Messenger _allbridgeMessenger,
3186         WormholeMessenger _wormholeMessenger,
3187         IGasOracle _gasOracle
3188     )
3189         MessengerGateway(_allbridgeMessenger, _wormholeMessenger)
3190         GasUsage(_gasOracle)
3191     {
3192         chainId = _chainId;
3193     }
3194 
3195     function hashMessage(
3196         uint256 amount,
3197         bytes32 recipient,
3198         uint8 sourceChainId,
3199         uint8 destinationChainId,
3200         bytes32 receiveToken,
3201         uint256 nonce,
3202         MessengerProtocol messenger
3203     ) external pure returns (bytes32) {
3204         return keccak256(
3205             abi.encodePacked(
3206                 amount,
3207                 recipient,
3208                 sourceChainId,
3209                 receiveToken,
3210                 nonce,
3211                 messenger
3212             )
3213         ).replaceChainBytes(sourceChainId, destinationChainId);
3214     }
3215 
3216     function sendTokens(
3217         uint256 amount,
3218         bytes32 recipient,
3219         uint8 destinationChainId,
3220         bytes32 receiveToken,
3221         uint256 nonce,
3222         MessengerProtocol messenger
3223     ) internal override {
3224         uint8 sourceChainId = chainId; // Gas optimization
3225         require(
3226             destinationChainId != sourceChainId,
3227             "Bridge: wrong destination chain"
3228         );
3229         require(
3230             otherBridgeTokens[destinationChainId][receiveToken],
3231             "Bridge: unknown chain or token"
3232         );
3233         bytes32 message = this.hashMessage(
3234             amount,
3235             recipient,
3236             sourceChainId,
3237             destinationChainId,
3238             receiveToken,
3239             nonce,
3240             messenger
3241         );
3242 
3243         bool wasMessageSent;
3244         assembly {
3245             mstore(0x00, message)
3246             mstore(0x20, sentMessages.slot)
3247             let key := keccak256(0, 0x40)
3248             wasMessageSent := sload(key)
3249             sstore(key, true)
3250         } 
3251         require(!wasMessageSent, "Bridge: tokens already sent");
3252         
3253         uint256 bridgeTransactionCost = this.getTransactionCost(destinationChainId);
3254         uint256 messageTransactionCost = sendMessage(message, messenger);
3255         unchecked {
3256             require(
3257                 msg.value >= bridgeTransactionCost + messageTransactionCost,
3258                 "Bridge: not enough fee"
3259             );
3260         }
3261         emit TokensSent(
3262             amount,
3263             recipient,
3264             destinationChainId,
3265             receiveToken,
3266             nonce,
3267             messenger
3268         );
3269     }
3270 
3271     function receiveTokens(
3272         uint256 amount,
3273         bytes32 recipient,
3274         uint8 sourceChainId,
3275         bytes32 receiveToken,
3276         uint256 nonce,
3277         MessengerProtocol messenger
3278     ) external override {
3279         require(otherBridges[sourceChainId] != bytes32(0), "Bridge: source not registered");
3280         bytes32 messageWithSender = this.hashMessage(
3281             amount,
3282             recipient,
3283             sourceChainId,
3284             chainId,
3285             receiveToken,
3286             nonce,
3287             messenger
3288         ).hashWithSender(otherBridges[sourceChainId]);
3289 
3290         bool wasMessageProcessed;
3291         assembly {
3292             mstore(0x00, messageWithSender)
3293             mstore(0x20, processedMessages.slot)
3294             let key := keccak256(0, 0x40)
3295             wasMessageProcessed := sload(key)
3296             sstore(key, true)
3297         } 
3298         require(!wasMessageProcessed, "Bridge: message processed");
3299 
3300         require(this.hasReceivedMessage(messageWithSender, messenger), "Bridge: no message");
3301 
3302         receiveAndSwap(
3303             amount,
3304             receiveToken,
3305             address(uint160(uint256(recipient)))
3306         );
3307     }
3308 
3309     function withdrawGasTokens(uint256 amount) external onlyOwner {
3310         payable(msg.sender).transfer(amount);
3311     }
3312 
3313     function registerBridge(uint8 chainId_, bytes32 bridgeAddress_) external onlyOwner {
3314         otherBridges[chainId_] = bridgeAddress_;
3315     }
3316 
3317     function addBridgeToken(uint8 chainId_, bytes32 tokenAddress_) external onlyOwner {
3318         otherBridgeTokens[chainId_][tokenAddress_] = true;
3319     }
3320 
3321     function removeBridgeToken(uint8 chainId_, bytes32 tokenAddress_) external onlyOwner {
3322         otherBridgeTokens[chainId_][tokenAddress_] = false;
3323     }
3324 
3325     fallback() external payable {
3326         revert("Unsupported");
3327     }
3328 
3329     receive() external payable {
3330         emit Received(msg.sender, msg.value);
3331     }
3332 }