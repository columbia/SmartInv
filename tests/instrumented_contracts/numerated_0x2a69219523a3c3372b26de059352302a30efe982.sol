1 //SPDX-License-Identifier: Unlicensed
2 pragma solidity ^0.8.0;
3 
4 /**
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
20         return msg.data;
21     }
22 }
23 
24 /**
25  * @dev Contract module which provides a basic access control mechanism, where
26  * there is an account (an owner) that can be granted exclusive access to
27  * specific functions.
28  *
29  * By default, the owner account will be the one that deploys the contract. This
30  * can later be changed with {transferOwnership}.
31  *
32  * This module is used through inheritance. It will make available the modifier
33  * `onlyOwner`, which can be applied to your functions to restrict their use to
34  * the owner.
35  */
36 abstract contract Ownable is Context {
37     address private _owner;
38 
39     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
40 
41     /**
42      * @dev Initializes the contract setting the deployer as the initial owner.
43      */
44     constructor() {
45         _transferOwnership(_msgSender());
46     }
47 
48     /**
49      * @dev Returns the address of the current owner.
50      */
51     function owner() public view virtual returns (address) {
52         return _owner;
53     }
54 
55     /**
56      * @dev Throws if called by any account other than the owner.
57      */
58     modifier onlyOwner() {
59         require(owner() == _msgSender(), "Ownable: caller is not the owner");
60         _;
61     }
62 
63     /**
64      * @dev Leaves the contract without owner. It will not be possible to call
65      * `onlyOwner` functions anymore. Can only be called by the current owner.
66      *
67      * NOTE: Renouncing ownership will leave the contract without an owner,
68      * thereby removing any functionality that is only available to the owner.
69      */
70     function renounceOwnership() public virtual onlyOwner {
71         _transferOwnership(address(0));
72     }
73 
74     /**
75      * @dev Transfers ownership of the contract to a new account (`newOwner`).
76      * Can only be called by the current owner.
77      */
78     function transferOwnership(address newOwner) public virtual onlyOwner {
79         require(newOwner != address(0), "Ownable: new owner is the zero address");
80         _transferOwnership(newOwner);
81     }
82 
83     /**
84      * @dev Transfers ownership of the contract to a new account (`newOwner`).
85      * Internal function without access restriction.
86      */
87     function _transferOwnership(address newOwner) internal virtual {
88         address oldOwner = _owner;
89         _owner = newOwner;
90         emit OwnershipTransferred(oldOwner, newOwner);
91     }
92 }
93 
94 
95 /**
96  * @dev Interface of the ERC20 standard as defined in the EIP.
97  */
98 interface IERC20 {
99     /**
100      * @dev Emitted when `value` tokens are moved from one account (`from`) to
101      * another (`to`).
102      *
103      * Note that `value` may be zero.
104      */
105     event Transfer(address indexed from, address indexed to, uint256 value);
106 
107     /**
108      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
109      * a call to {approve}. `value` is the new allowance.
110      */
111     event Approval(address indexed owner, address indexed spender, uint256 value);
112 
113     /**
114      * @dev Returns the amount of tokens in existence.
115      */
116     function totalSupply() external view returns (uint256);
117 
118     /**
119      * @dev Returns the amount of tokens owned by `account`.
120      */
121     function balanceOf(address account) external view returns (uint256);
122 
123     /**
124      * @dev Moves `amount` tokens from the caller's account to `to`.
125      *
126      * Returns a boolean value indicating whether the operation succeeded.
127      *
128      * Emits a {Transfer} event.
129      */
130     function transfer(address to, uint256 amount) external returns (bool);
131 
132     /**
133      * @dev Returns the remaining number of tokens that `spender` will be
134      * allowed to spend on behalf of `owner` through {transferFrom}. This is
135      * zero by default.
136      *
137      * This value changes when {approve} or {transferFrom} are called.
138      */
139     function allowance(address owner, address spender) external view returns (uint256);
140 
141     /**
142      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
143      *
144      * Returns a boolean value indicating whether the operation succeeded.
145      *
146      * IMPORTANT: Beware that changing an allowance with this method brings the risk
147      * that someone may use both the old and the new allowance by unfortunate
148      * transaction ordering. One possible solution to mitigate this race
149      * condition is to first reduce the spender's allowance to 0 and set the
150      * desired value afterwards:
151      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
152      *
153      * Emits an {Approval} event.
154      */
155     function approve(address spender, uint256 amount) external returns (bool);
156 
157     /**
158      * @dev Moves `amount` tokens from `from` to `to` using the
159      * allowance mechanism. `amount` is then deducted from the caller's
160      * allowance.
161      *
162      * Returns a boolean value indicating whether the operation succeeded.
163      *
164      * Emits a {Transfer} event.
165      */
166     function transferFrom(
167         address from,
168         address to,
169         uint256 amount
170     ) external returns (bool);
171 }
172 
173 /**
174  * @dev Interface for the optional metadata functions from the ERC20 standard.
175  *
176  * _Available since v4.1._
177  */
178 interface IERC20Metadata is IERC20 {
179     /**
180      * @dev Returns the name of the token.
181      */
182     function name() external view returns (string memory);
183 
184     /**
185      * @dev Returns the symbol of the token.
186      */
187     function symbol() external view returns (string memory);
188 
189     /**
190      * @dev Returns the decimals places of the token.
191      */
192     function decimals() external view returns (uint8);
193 }
194 
195 /**
196  * @dev Implementation of the {IERC20} interface.
197  *
198  * This implementation is agnostic to the way tokens are created. This means
199  * that a supply mechanism has to be added in a derived contract using {_mint}.
200  * For a generic mechanism see {ERC20PresetMinterPauser}.
201  *
202  * TIP: For a detailed writeup see our guide
203  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
204  * to implement supply mechanisms].
205  *
206  * We have followed general OpenZeppelin Contracts guidelines: functions revert
207  * instead returning `false` on failure. This behavior is nonetheless
208  * conventional and does not conflict with the expectations of ERC20
209  * applications.
210  *
211  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
212  * This allows applications to reconstruct the allowance for all accounts just
213  * by listening to said events. Other implementations of the EIP may not emit
214  * these events, as it isn't required by the specification.
215  *
216  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
217  * functions have been added to mitigate the well-known issues around setting
218  * allowances. See {IERC20-approve}.
219  */
220 contract ERC20 is Context, IERC20, IERC20Metadata {
221     mapping(address => uint256) private _balances;
222 
223     mapping(address => mapping(address => uint256)) private _allowances;
224 
225     uint256 private _totalSupply;
226 
227     string private _name;
228     string private _symbol;
229 
230     /**
231      * @dev Sets the values for {name} and {symbol}.
232      *
233      * The default value of {decimals} is 18. To select a different value for
234      * {decimals} you should overload it.
235      *
236      * All two of these values are immutable: they can only be set once during
237      * construction.
238      */
239     constructor(string memory name_, string memory symbol_) {
240         _name = name_;
241         _symbol = symbol_;
242     }
243 
244     /**
245      * @dev Returns the name of the token.
246      */
247     function name() public view virtual override returns (string memory) {
248         return _name;
249     }
250 
251     /**
252      * @dev Returns the symbol of the token, usually a shorter version of the
253      * name.
254      */
255     function symbol() public view virtual override returns (string memory) {
256         return _symbol;
257     }
258 
259     /**
260      * @dev Returns the number of decimals used to get its user representation.
261      * For example, if `decimals` equals `2`, a balance of `505` tokens should
262      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
263      *
264      * Tokens usually opt for a value of 18, imitating the relationship between
265      * Ether and Wei. This is the value {ERC20} uses, unless this function is
266      * overridden;
267      *
268      * NOTE: This information is only used for _display_ purposes: it in
269      * no way affects any of the arithmetic of the contract, including
270      * {IERC20-balanceOf} and {IERC20-transfer}.
271      */
272     function decimals() public view virtual override returns (uint8) {
273         return 18;
274     }
275 
276     /**
277      * @dev See {IERC20-totalSupply}.
278      */
279     function totalSupply() public view virtual override returns (uint256) {
280         return _totalSupply;
281     }
282 
283     /**
284      * @dev See {IERC20-balanceOf}.
285      */
286     function balanceOf(address account) public view virtual override returns (uint256) {
287         return _balances[account];
288     }
289 
290     /**
291      * @dev See {IERC20-transfer}.
292      *
293      * Requirements:
294      *
295      * - `to` cannot be the zero address.
296      * - the caller must have a balance of at least `amount`.
297      */
298     function transfer(address to, uint256 amount) public virtual override returns (bool) {
299         address owner = _msgSender();
300         _transfer(owner, to, amount);
301         return true;
302     }
303 
304     /**
305      * @dev See {IERC20-allowance}.
306      */
307     function allowance(address owner, address spender) public view virtual override returns (uint256) {
308         return _allowances[owner][spender];
309     }
310 
311     /**
312      * @dev See {IERC20-approve}.
313      *
314      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
315      * `transferFrom`. This is semantically equivalent to an infinite approval.
316      *
317      * Requirements:
318      *
319      * - `spender` cannot be the zero address.
320      */
321     function approve(address spender, uint256 amount) public virtual override returns (bool) {
322         address owner = _msgSender();
323         _approve(owner, spender, amount);
324         return true;
325     }
326 
327     /**
328      * @dev See {IERC20-transferFrom}.
329      *
330      * Emits an {Approval} event indicating the updated allowance. This is not
331      * required by the EIP. See the note at the beginning of {ERC20}.
332      *
333      * NOTE: Does not update the allowance if the current allowance
334      * is the maximum `uint256`.
335      *
336      * Requirements:
337      *
338      * - `from` and `to` cannot be the zero address.
339      * - `from` must have a balance of at least `amount`.
340      * - the caller must have allowance for ``from``'s tokens of at least
341      * `amount`.
342      */
343     function transferFrom(
344         address from,
345         address to,
346         uint256 amount
347     ) public virtual override returns (bool) {
348         address spender = _msgSender();
349         _spendAllowance(from, spender, amount);
350         _transfer(from, to, amount);
351         return true;
352     }
353 
354     /**
355      * @dev Atomically increases the allowance granted to `spender` by the caller.
356      *
357      * This is an alternative to {approve} that can be used as a mitigation for
358      * problems described in {IERC20-approve}.
359      *
360      * Emits an {Approval} event indicating the updated allowance.
361      *
362      * Requirements:
363      *
364      * - `spender` cannot be the zero address.
365      */
366     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
367         address owner = _msgSender();
368         _approve(owner, spender, allowance(owner, spender) + addedValue);
369         return true;
370     }
371 
372     /**
373      * @dev Atomically decreases the allowance granted to `spender` by the caller.
374      *
375      * This is an alternative to {approve} that can be used as a mitigation for
376      * problems described in {IERC20-approve}.
377      *
378      * Emits an {Approval} event indicating the updated allowance.
379      *
380      * Requirements:
381      *
382      * - `spender` cannot be the zero address.
383      * - `spender` must have allowance for the caller of at least
384      * `subtractedValue`.
385      */
386     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
387         address owner = _msgSender();
388         uint256 currentAllowance = allowance(owner, spender);
389         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
390         unchecked {
391             _approve(owner, spender, currentAllowance - subtractedValue);
392         }
393 
394         return true;
395     }
396 
397     /**
398      * @dev Moves `amount` of tokens from `sender` to `recipient`.
399      *
400      * This internal function is equivalent to {transfer}, and can be used to
401      * e.g. implement automatic token fees, slashing mechanisms, etc.
402      *
403      * Emits a {Transfer} event.
404      *
405      * Requirements:
406      *
407      * - `from` cannot be the zero address.
408      * - `to` cannot be the zero address.
409      * - `from` must have a balance of at least `amount`.
410      */
411     function _transfer(
412         address from,
413         address to,
414         uint256 amount
415     ) internal virtual {
416         require(from != address(0), "ERC20: transfer from the zero address");
417         require(to != address(0), "ERC20: transfer to the zero address");
418 
419         _beforeTokenTransfer(from, to, amount);
420 
421         uint256 fromBalance = _balances[from];
422         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
423         unchecked {
424             _balances[from] = fromBalance - amount;
425         }
426         _balances[to] += amount;
427 
428         emit Transfer(from, to, amount);
429 
430         _afterTokenTransfer(from, to, amount);
431     }
432 
433     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
434      * the total supply.
435      *
436      * Emits a {Transfer} event with `from` set to the zero address.
437      *
438      * Requirements:
439      *
440      * - `account` cannot be the zero address.
441      */
442     function _mint(address account, uint256 amount) internal virtual {
443         require(account != address(0), "ERC20: mint to the zero address");
444 
445         _beforeTokenTransfer(address(0), account, amount);
446 
447         _totalSupply += amount;
448         _balances[account] += amount;
449         emit Transfer(address(0), account, amount);
450 
451         _afterTokenTransfer(address(0), account, amount);
452     }
453 
454     /**
455      * @dev Destroys `amount` tokens from `account`, reducing the
456      * total supply.
457      *
458      * Emits a {Transfer} event with `to` set to the zero address.
459      *
460      * Requirements:
461      *
462      * - `account` cannot be the zero address.
463      * - `account` must have at least `amount` tokens.
464      */
465     function _burn(address account, uint256 amount) internal virtual {
466         require(account != address(0), "ERC20: burn from the zero address");
467 
468         _beforeTokenTransfer(account, address(0), amount);
469 
470         uint256 accountBalance = _balances[account];
471         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
472         unchecked {
473             _balances[account] = accountBalance - amount;
474         }
475         _totalSupply -= amount;
476 
477         emit Transfer(account, address(0), amount);
478 
479         _afterTokenTransfer(account, address(0), amount);
480     }
481 
482     /**
483      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
484      *
485      * This internal function is equivalent to `approve`, and can be used to
486      * e.g. set automatic allowances for certain subsystems, etc.
487      *
488      * Emits an {Approval} event.
489      *
490      * Requirements:
491      *
492      * - `owner` cannot be the zero address.
493      * - `spender` cannot be the zero address.
494      */
495     function _approve(
496         address owner,
497         address spender,
498         uint256 amount
499     ) internal virtual {
500         require(owner != address(0), "ERC20: approve from the zero address");
501         require(spender != address(0), "ERC20: approve to the zero address");
502 
503         _allowances[owner][spender] = amount;
504         emit Approval(owner, spender, amount);
505     }
506 
507     /**
508      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
509      *
510      * Does not update the allowance amount in case of infinite allowance.
511      * Revert if not enough allowance is available.
512      *
513      * Might emit an {Approval} event.
514      */
515     function _spendAllowance(
516         address owner,
517         address spender,
518         uint256 amount
519     ) internal virtual {
520         uint256 currentAllowance = allowance(owner, spender);
521         if (currentAllowance != type(uint256).max) {
522             require(currentAllowance >= amount, "ERC20: insufficient allowance");
523             unchecked {
524                 _approve(owner, spender, currentAllowance - amount);
525             }
526         }
527     }
528 
529     /**
530      * @dev Hook that is called before any transfer of tokens. This includes
531      * minting and burning.
532      *
533      * Calling conditions:
534      *
535      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
536      * will be transferred to `to`.
537      * - when `from` is zero, `amount` tokens will be minted for `to`.
538      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
539      * - `from` and `to` are never both zero.
540      *
541      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
542      */
543     function _beforeTokenTransfer(
544         address from,
545         address to,
546         uint256 amount
547     ) internal virtual {}
548 
549     /**
550      * @dev Hook that is called after any transfer of tokens. This includes
551      * minting and burning.
552      *
553      * Calling conditions:
554      *
555      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
556      * has been transferred to `to`.
557      * - when `from` is zero, `amount` tokens have been minted for `to`.
558      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
559      * - `from` and `to` are never both zero.
560      *
561      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
562      */
563     function _afterTokenTransfer(
564         address from,
565         address to,
566         uint256 amount
567     ) internal virtual {}
568 }
569 
570 /**
571  * @dev Collection of functions related to the address type
572  */
573 library Address {
574     /**
575      * @dev Returns true if `account` is a contract.
576      *
577      * [IMPORTANT]
578      * ====
579      * It is unsafe to assume that an address for which this function returns
580      * false is an externally-owned account (EOA) and not a contract.
581      *
582      * Among others, `isContract` will return false for the following
583      * types of addresses:
584      *
585      *  - an externally-owned account
586      *  - a contract in construction
587      *  - an address where a contract will be created
588      *  - an address where a contract lived, but was destroyed
589      * ====
590      *
591      * [IMPORTANT]
592      * ====
593      * You shouldn't rely on `isContract` to protect against flash loan attacks!
594      *
595      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
596      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
597      * constructor.
598      * ====
599      */
600     function isContract(address account) internal view returns (bool) {
601         // This method relies on extcodesize/address.code.length, which returns 0
602         // for contracts in construction, since the code is only stored at the end
603         // of the constructor execution.
604 
605         return account.code.length > 0;
606     }
607 
608     /**
609      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
610      * `recipient`, forwarding all available gas and reverting on errors.
611      *
612      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
613      * of certain opcodes, possibly making contracts go over the 2300 gas limit
614      * imposed by `transfer`, making them unable to receive funds via
615      * `transfer`. {sendValue} removes this limitation.
616      *
617      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
618      *
619      * IMPORTANT: because control is transferred to `recipient`, care must be
620      * taken to not create reentrancy vulnerabilities. Consider using
621      * {ReentrancyGuard} or the
622      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
623      */
624     function sendValue(address payable recipient, uint256 amount) internal {
625         require(address(this).balance >= amount, "Address: insufficient balance");
626 
627         (bool success, ) = recipient.call{value: amount}("");
628         require(success, "Address: unable to send value, recipient may have reverted");
629     }
630 
631     /**
632      * @dev Performs a Solidity function call using a low level `call`. A
633      * plain `call` is an unsafe replacement for a function call: use this
634      * function instead.
635      *
636      * If `target` reverts with a revert reason, it is bubbled up by this
637      * function (like regular Solidity function calls).
638      *
639      * Returns the raw returned data. To convert to the expected return value,
640      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
641      *
642      * Requirements:
643      *
644      * - `target` must be a contract.
645      * - calling `target` with `data` must not revert.
646      *
647      * _Available since v3.1._
648      */
649     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
650         return functionCall(target, data, "Address: low-level call failed");
651     }
652 
653     /**
654      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
655      * `errorMessage` as a fallback revert reason when `target` reverts.
656      *
657      * _Available since v3.1._
658      */
659     function functionCall(
660         address target,
661         bytes memory data,
662         string memory errorMessage
663     ) internal returns (bytes memory) {
664         return functionCallWithValue(target, data, 0, errorMessage);
665     }
666 
667     /**
668      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
669      * but also transferring `value` wei to `target`.
670      *
671      * Requirements:
672      *
673      * - the calling contract must have an ETH balance of at least `value`.
674      * - the called Solidity function must be `payable`.
675      *
676      * _Available since v3.1._
677      */
678     function functionCallWithValue(
679         address target,
680         bytes memory data,
681         uint256 value
682     ) internal returns (bytes memory) {
683         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
684     }
685 
686     /**
687      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
688      * with `errorMessage` as a fallback revert reason when `target` reverts.
689      *
690      * _Available since v3.1._
691      */
692     function functionCallWithValue(
693         address target,
694         bytes memory data,
695         uint256 value,
696         string memory errorMessage
697     ) internal returns (bytes memory) {
698         require(address(this).balance >= value, "Address: insufficient balance for call");
699         require(isContract(target), "Address: call to non-contract");
700 
701         (bool success, bytes memory returndata) = target.call{value: value}(data);
702         return verifyCallResult(success, returndata, errorMessage);
703     }
704 
705     /**
706      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
707      * but performing a static call.
708      *
709      * _Available since v3.3._
710      */
711     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
712         return functionStaticCall(target, data, "Address: low-level static call failed");
713     }
714 
715     /**
716      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
717      * but performing a static call.
718      *
719      * _Available since v3.3._
720      */
721     function functionStaticCall(
722         address target,
723         bytes memory data,
724         string memory errorMessage
725     ) internal view returns (bytes memory) {
726         require(isContract(target), "Address: static call to non-contract");
727 
728         (bool success, bytes memory returndata) = target.staticcall(data);
729         return verifyCallResult(success, returndata, errorMessage);
730     }
731 
732     /**
733      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
734      * but performing a delegate call.
735      *
736      * _Available since v3.4._
737      */
738     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
739         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
740     }
741 
742     /**
743      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
744      * but performing a delegate call.
745      *
746      * _Available since v3.4._
747      */
748     function functionDelegateCall(
749         address target,
750         bytes memory data,
751         string memory errorMessage
752     ) internal returns (bytes memory) {
753         require(isContract(target), "Address: delegate call to non-contract");
754 
755         (bool success, bytes memory returndata) = target.delegatecall(data);
756         return verifyCallResult(success, returndata, errorMessage);
757     }
758 
759     /**
760      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
761      * revert reason using the provided one.
762      *
763      * _Available since v4.3._
764      */
765     function verifyCallResult(
766         bool success,
767         bytes memory returndata,
768         string memory errorMessage
769     ) internal pure returns (bytes memory) {
770         if (success) {
771             return returndata;
772         } else {
773             // Look for revert reason and bubble it up if present
774             if (returndata.length > 0) {
775                 // The easiest way to bubble the revert reason is using memory via assembly
776 
777                 assembly {
778                     let returndata_size := mload(returndata)
779                     revert(add(32, returndata), returndata_size)
780                 }
781             } else {
782                 revert(errorMessage);
783             }
784         }
785     }
786 }
787 
788 /**
789  * @dev Wrappers over Solidity's arithmetic operations.
790  *
791  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
792  * now has built in overflow checking.
793  */
794 library SafeMath {
795     /**
796      * @dev Returns the addition of two unsigned integers, with an overflow flag.
797      *
798      * _Available since v3.4._
799      */
800     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
801         unchecked {
802             uint256 c = a + b;
803             if (c < a) return (false, 0);
804             return (true, c);
805         }
806     }
807 
808     /**
809      * @dev Returns the subtraction of two unsigned integers, with an overflow flag.
810      *
811      * _Available since v3.4._
812      */
813     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
814         unchecked {
815             if (b > a) return (false, 0);
816             return (true, a - b);
817         }
818     }
819 
820     /**
821      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
822      *
823      * _Available since v3.4._
824      */
825     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
826         unchecked {
827             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
828             // benefit is lost if 'b' is also tested.
829             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
830             if (a == 0) return (true, 0);
831             uint256 c = a * b;
832             if (c / a != b) return (false, 0);
833             return (true, c);
834         }
835     }
836 
837     /**
838      * @dev Returns the division of two unsigned integers, with a division by zero flag.
839      *
840      * _Available since v3.4._
841      */
842     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
843         unchecked {
844             if (b == 0) return (false, 0);
845             return (true, a / b);
846         }
847     }
848 
849     /**
850      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
851      *
852      * _Available since v3.4._
853      */
854     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
855         unchecked {
856             if (b == 0) return (false, 0);
857             return (true, a % b);
858         }
859     }
860 
861     /**
862      * @dev Returns the addition of two unsigned integers, reverting on
863      * overflow.
864      *
865      * Counterpart to Solidity's `+` operator.
866      *
867      * Requirements:
868      *
869      * - Addition cannot overflow.
870      */
871     function add(uint256 a, uint256 b) internal pure returns (uint256) {
872         return a + b;
873     }
874 
875     /**
876      * @dev Returns the subtraction of two unsigned integers, reverting on
877      * overflow (when the result is negative).
878      *
879      * Counterpart to Solidity's `-` operator.
880      *
881      * Requirements:
882      *
883      * - Subtraction cannot overflow.
884      */
885     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
886         return a - b;
887     }
888 
889     /**
890      * @dev Returns the multiplication of two unsigned integers, reverting on
891      * overflow.
892      *
893      * Counterpart to Solidity's `*` operator.
894      *
895      * Requirements:
896      *
897      * - Multiplication cannot overflow.
898      */
899     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
900         return a * b;
901     }
902 
903     /**
904      * @dev Returns the integer division of two unsigned integers, reverting on
905      * division by zero. The result is rounded towards zero.
906      *
907      * Counterpart to Solidity's `/` operator.
908      *
909      * Requirements:
910      *
911      * - The divisor cannot be zero.
912      */
913     function div(uint256 a, uint256 b) internal pure returns (uint256) {
914         return a / b;
915     }
916 
917     /**
918      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
919      * reverting when dividing by zero.
920      *
921      * Counterpart to Solidity's `%` operator. This function uses a `revert`
922      * opcode (which leaves remaining gas untouched) while Solidity uses an
923      * invalid opcode to revert (consuming all remaining gas).
924      *
925      * Requirements:
926      *
927      * - The divisor cannot be zero.
928      */
929     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
930         return a % b;
931     }
932 
933     /**
934      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
935      * overflow (when the result is negative).
936      *
937      * CAUTION: This function is deprecated because it requires allocating memory for the error
938      * message unnecessarily. For custom revert reasons use {trySub}.
939      *
940      * Counterpart to Solidity's `-` operator.
941      *
942      * Requirements:
943      *
944      * - Subtraction cannot overflow.
945      */
946     function sub(
947         uint256 a,
948         uint256 b,
949         string memory errorMessage
950     ) internal pure returns (uint256) {
951         unchecked {
952             require(b <= a, errorMessage);
953             return a - b;
954         }
955     }
956 
957     /**
958      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
959      * division by zero. The result is rounded towards zero.
960      *
961      * Counterpart to Solidity's `/` operator. Note: this function uses a
962      * `revert` opcode (which leaves remaining gas untouched) while Solidity
963      * uses an invalid opcode to revert (consuming all remaining gas).
964      *
965      * Requirements:
966      *
967      * - The divisor cannot be zero.
968      */
969     function div(
970         uint256 a,
971         uint256 b,
972         string memory errorMessage
973     ) internal pure returns (uint256) {
974         unchecked {
975             require(b > 0, errorMessage);
976             return a / b;
977         }
978     }
979 
980     /**
981      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
982      * reverting with custom message when dividing by zero.
983      *
984      * CAUTION: This function is deprecated because it requires allocating memory for the error
985      * message unnecessarily. For custom revert reasons use {tryMod}.
986      *
987      * Counterpart to Solidity's `%` operator. This function uses a `revert`
988      * opcode (which leaves remaining gas untouched) while Solidity uses an
989      * invalid opcode to revert (consuming all remaining gas).
990      *
991      * Requirements:
992      *
993      * - The divisor cannot be zero.
994      */
995     function mod(
996         uint256 a,
997         uint256 b,
998         string memory errorMessage
999     ) internal pure returns (uint256) {
1000         unchecked {
1001             require(b > 0, errorMessage);
1002             return a % b;
1003         }
1004     }
1005 }
1006 
1007 library SafeMathInt {
1008     function mul(int256 a, int256 b) internal pure returns (int256) {
1009         // Prevent overflow when multiplying INT256_MIN with -1
1010         // https://github.com/RequestNetwork/requestNetwork/issues/43
1011         require(!(a == - 2**255 && b == -1) && !(b == - 2**255 && a == -1));
1012 
1013         int256 c = a * b;
1014         require((b == 0) || (c / b == a));
1015         return c;
1016     }
1017 
1018     function div(int256 a, int256 b) internal pure returns (int256) {
1019         // Prevent overflow when dividing INT256_MIN by -1
1020         // https://github.com/RequestNetwork/requestNetwork/issues/43
1021         require(!(a == - 2**255 && b == -1) && (b > 0));
1022 
1023         return a / b;
1024     }
1025 
1026     function sub(int256 a, int256 b) internal pure returns (int256) {
1027         require((b >= 0 && a - b <= a) || (b < 0 && a - b > a));
1028 
1029         return a - b;
1030     }
1031 
1032     function add(int256 a, int256 b) internal pure returns (int256) {
1033         int256 c = a + b;
1034         require((b >= 0 && c >= a) || (b < 0 && c < a));
1035         return c;
1036     }
1037 
1038     function toUint256Safe(int256 a) internal pure returns (uint256) {
1039         require(a >= 0);
1040         return uint256(a);
1041     }
1042 }
1043 
1044 interface IPancakeFactory {
1045     event PairCreated(address indexed token0, address indexed token1, address pair, uint);
1046 
1047     function feeTo() external view returns (address);
1048     function feeToSetter() external view returns (address);
1049 
1050     function getPair(address tokenA, address tokenB) external view returns (address pair);
1051     function allPairs(uint) external view returns (address pair);
1052     function allPairsLength() external view returns (uint);
1053 
1054     function createPair(address tokenA, address tokenB) external returns (address pair);
1055 
1056     function setFeeTo(address) external;
1057     function setFeeToSetter(address) external;
1058 }
1059 
1060 interface IPancakePair {
1061     event Approval(address indexed owner, address indexed spender, uint value);
1062     event Transfer(address indexed from, address indexed to, uint value);
1063 
1064     function name() external pure returns (string memory);
1065     function symbol() external pure returns (string memory);
1066     function decimals() external pure returns (uint256);
1067     function totalSupply() external view returns (uint);
1068     function balanceOf(address owner) external view returns (uint);
1069     function allowance(address owner, address spender) external view returns (uint);
1070 
1071     function approve(address spender, uint value) external returns (bool);
1072     function transfer(address to, uint value) external returns (bool);
1073     function transferFrom(address from, address to, uint value) external returns (bool);
1074 
1075     function DOMAIN_SEPARATOR() external view returns (bytes32);
1076     function PERMIT_TYPEHASH() external pure returns (bytes32);
1077     function nonces(address owner) external view returns (uint);
1078 
1079     function permit(address owner, address spender, uint value, uint deadline, uint8 v, bytes32 r, bytes32 s) external;
1080 
1081     event Mint(address indexed sender, uint amount0, uint amount1);
1082     event Burn(address indexed sender, uint amount0, uint amount1, address indexed to);
1083     event Swap(
1084         address indexed sender,
1085         uint amount0In,
1086         uint amount1In,
1087         uint amount0Out,
1088         uint amount1Out,
1089         address indexed to
1090     );
1091     event Sync(uint112 reserve0, uint112 reserve1);
1092 
1093     function MINIMUM_LIQUIDITY() external pure returns (uint);
1094     function factory() external view returns (address);
1095     function token0() external view returns (address);
1096     function token1() external view returns (address);
1097     function getReserves() external view returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);
1098     function price0CumulativeLast() external view returns (uint);
1099     function price1CumulativeLast() external view returns (uint);
1100     function kLast() external view returns (uint);
1101 
1102     function mint(address to) external returns (uint liquidity);
1103     function burn(address to) external returns (uint amount0, uint amount1);
1104     function swap(uint amount0Out, uint amount1Out, address to, bytes calldata data) external;
1105     function skim(address to) external;
1106     function sync() external;
1107 
1108     function initialize(address, address) external;
1109 }
1110 
1111 interface IPancakeRouter01 {
1112     function factory() external pure returns (address);
1113     function WETH() external pure returns (address);
1114 
1115     function addLiquidity(
1116         address tokenA,
1117         address tokenB,
1118         uint amountADesired,
1119         uint amountBDesired,
1120         uint amountAMin,
1121         uint amountBMin,
1122         address to,
1123         uint deadline
1124     ) external returns (uint amountA, uint amountB, uint liquidity);
1125     function addLiquidityETH(
1126         address token,
1127         uint amountTokenDesired,
1128         uint amountTokenMin,
1129         uint amountETHMin,
1130         address to,
1131         uint deadline
1132     ) external payable returns (uint amountToken, uint amountETH, uint liquidity);
1133     function removeLiquidity(
1134         address tokenA,
1135         address tokenB,
1136         uint liquidity,
1137         uint amountAMin,
1138         uint amountBMin,
1139         address to,
1140         uint deadline
1141     ) external returns (uint amountA, uint amountB);
1142     function removeLiquidityETH(
1143         address token,
1144         uint liquidity,
1145         uint amountTokenMin,
1146         uint amountETHMin,
1147         address to,
1148         uint deadline
1149     ) external returns (uint amountToken, uint amountETH);
1150     function removeLiquidityWithPermit(
1151         address tokenA,
1152         address tokenB,
1153         uint liquidity,
1154         uint amountAMin,
1155         uint amountBMin,
1156         address to,
1157         uint deadline,
1158         bool approveMax, uint8 v, bytes32 r, bytes32 s
1159     ) external returns (uint amountA, uint amountB);
1160     function removeLiquidityETHWithPermit(
1161         address token,
1162         uint liquidity,
1163         uint amountTokenMin,
1164         uint amountETHMin,
1165         address to,
1166         uint deadline,
1167         bool approveMax, uint8 v, bytes32 r, bytes32 s
1168     ) external returns (uint amountToken, uint amountETH);
1169     function swapExactTokensForTokens(
1170         uint amountIn,
1171         uint amountOutMin,
1172         address[] calldata path,
1173         address to,
1174         uint deadline
1175     ) external returns (uint[] memory amounts);
1176     function swapTokensForExactTokens(
1177         uint amountOut,
1178         uint amountInMax,
1179         address[] calldata path,
1180         address to,
1181         uint deadline
1182     ) external returns (uint[] memory amounts);
1183     function swapExactETHForTokens(uint amountOutMin, address[] calldata path, address to, uint deadline)
1184     external
1185     payable
1186     returns (uint[] memory amounts);
1187     function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
1188     external
1189     returns (uint[] memory amounts);
1190     function swapExactTokensForETH(uint amountIn, uint amountOutMin, address[] calldata path, address to, uint deadline)
1191     external
1192     returns (uint[] memory amounts);
1193     function swapETHForExactTokens(uint amountOut, address[] calldata path, address to, uint deadline)
1194     external
1195     payable
1196     returns (uint[] memory amounts);
1197 
1198     function quote(uint amountA, uint reserveA, uint reserveB) external pure returns (uint amountB);
1199     function getAmountOut(uint amountIn, uint reserveIn, uint reserveOut) external pure returns (uint amountOut);
1200     function getAmountIn(uint amountOut, uint reserveIn, uint reserveOut) external pure returns (uint amountIn);
1201     function getAmountsOut(uint amountIn, address[] calldata path) external view returns (uint[] memory amounts);
1202     function getAmountsIn(uint amountOut, address[] calldata path) external view returns (uint[] memory amounts);
1203 }
1204 
1205 interface IPancakeRouter02 is IPancakeRouter01 {
1206     function removeLiquidityETHSupportingFeeOnTransferTokens(
1207         address token,
1208         uint liquidity,
1209         uint amountTokenMin,
1210         uint amountETHMin,
1211         address to,
1212         uint deadline
1213     ) external returns (uint amountETH);
1214     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1215         address token,
1216         uint liquidity,
1217         uint amountTokenMin,
1218         uint amountETHMin,
1219         address to,
1220         uint deadline,
1221         bool approveMax, uint8 v, bytes32 r, bytes32 s
1222     ) external returns (uint amountETH);
1223 
1224     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1225         uint amountIn,
1226         uint amountOutMin,
1227         address[] calldata path,
1228         address to,
1229         uint deadline
1230     ) external;
1231     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1232         uint amountOutMin,
1233         address[] calldata path,
1234         address to,
1235         uint deadline
1236     ) external payable;
1237     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1238         uint amountIn,
1239         uint amountOutMin,
1240         address[] calldata path,
1241         address to,
1242         uint deadline
1243     ) external;
1244 }
1245 
1246 interface IFundDistribute {
1247    function notifyReward(address account, uint256 amount) external;
1248 }
1249 
1250 contract EtxToken is ERC20, Ownable {
1251     using SafeMath for uint256;
1252     using Address for address;
1253 
1254     IPancakeRouter02 public pancakeRouter;
1255     address public pancakePair;
1256 
1257     address[] internal fundsAddress;
1258     address public buyBackAddress;
1259 
1260 
1261     uint256 internal fee = 20;
1262     uint256 buyBackFee = 500;
1263     uint256 fundFee = 500;
1264 
1265     uint256 public swapTokensAtAmount = 280 * 10 ** 18;
1266 
1267      /****************/
1268     bool public tradingEnabled = true;   
1269     bool public swappingEnabled = true;  
1270     bool private swapping;
1271 
1272     // exlcude from fees and max transaction amount
1273     mapping (address => bool) private _isExcludedFromFees;
1274 
1275     event UpdateTradingStatus(bool status);
1276     event UpdateSwappingStatus(bool status);
1277     event SetSwapTokensAtAmount(uint256 OldAmount, uint256 NewAmount);
1278     event UpdatePancakeRouter(address indexed newAddress, address indexed oldAddress);
1279     event ExcludeMultipleAccountsFromFees(address[] accounts, bool isExcluded);
1280     event StartSwapTokensForEth(uint256 tokenAmountToBeSwapped);
1281     event FinishSwapTokensForEth(uint256 ethAmountSwapped);
1282 
1283     constructor( 
1284         address _managerAddress
1285     ) ERC20("Ethereum Dex", "ETX") {
1286         updatePancakeRouter(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);  // geoli
1287         
1288 
1289         _isExcludedFromFees[owner()] = true;
1290         _isExcludedFromFees[_managerAddress] = true;
1291         _isExcludedFromFees[address(this)] = true;    
1292 
1293         _mint(_managerAddress, 21000000 * 10 ** 18);
1294     }
1295 
1296     function updatePancakeRouter(address newAddress) public onlyOwner {
1297         require(newAddress != address(pancakeRouter), "ETXToken: The router already has that address");
1298         emit UpdatePancakeRouter(newAddress, address(pancakeRouter));
1299         pancakeRouter = IPancakeRouter02(newAddress);
1300         address _pancakePair = IPancakeFactory(pancakeRouter.factory())
1301         .createPair(address(this), pancakeRouter.WETH());
1302         pancakePair = _pancakePair;
1303 
1304         _isExcludedFromFees[newAddress] = true;
1305     }
1306 
1307     function setFee(uint _fee, uint _buyBackFee, uint _fundFee) external onlyOwner {
1308         fee = _fee;
1309         buyBackFee = _buyBackFee;
1310         fundFee = _fundFee;
1311     }
1312 
1313     function setFundAddress(address[] memory _fundsAddress) external onlyOwner {
1314         fundsAddress = _fundsAddress;
1315     }
1316 
1317     function setBuyBackAddress(address _buyBackAddress) external onlyOwner {
1318         buyBackAddress = _buyBackAddress;
1319     }
1320 
1321     function excludeMultipleAccountsFromFees(address[] calldata accounts, bool excluded) public onlyOwner {
1322         for(uint256 i = 0; i < accounts.length; i++) {
1323             _isExcludedFromFees[accounts[i]] = excluded;
1324         }
1325         emit ExcludeMultipleAccountsFromFees(accounts, excluded);
1326     }
1327 
1328     function setSwapTokensAtAmount(uint256 amount) external onlyOwner {
1329         emit SetSwapTokensAtAmount(swapTokensAtAmount, amount);
1330         swapTokensAtAmount = amount;
1331     }
1332 
1333     function setTradingIsEnabled(bool status) external onlyOwner {
1334         tradingEnabled = status;
1335         emit UpdateTradingStatus(status);
1336     }
1337 
1338     function setSwapIsEnabled(bool status) external onlyOwner {
1339         swappingEnabled = status;
1340         emit UpdateSwappingStatus(status);
1341     }
1342 
1343     function isExcludedFromFees(address account) public view returns(bool) {
1344         return _isExcludedFromFees[account];
1345     }
1346 
1347     function _transfer(
1348         address from,
1349         address to,
1350         uint256 amount
1351     ) internal override {
1352         require(from != address(0), "ERC20: transfer from the zero address");
1353         require(to != address(0), "ERC20: transfer to the zero address");
1354 
1355         if(amount == 0) {
1356             super._transfer(from, to, 0);
1357             return;
1358         }
1359 
1360         bool canSwap =  balanceOf(address(this)) >= swapTokensAtAmount;
1361         if(
1362             tradingEnabled &&
1363             canSwap &&
1364             !swapping &&
1365             swappingEnabled &&
1366             to == pancakePair
1367         ) {
1368             swapping = true;
1369             swapAndDistribute(swapTokensAtAmount);
1370             swapping = false;
1371         }
1372 
1373         bool takeFee = false;
1374         if(!_isExcludedFromFees[from] && !_isExcludedFromFees[to]) {
1375             takeFee = true;
1376         }
1377         if(takeFee && (to == pancakePair || from == pancakePair)) {
1378              uint256 totalFees = amount.mul(fee).div(1000);
1379             amount = amount.sub(totalFees);
1380             super._transfer(from, address(this), totalFees);
1381         }
1382         super._transfer(from, to, amount);
1383     }
1384 
1385     function swapAndDistribute(uint256 amount) private {
1386         uint256 buyBackfundAmount = amount.mul(fundFee).div(1000);
1387         uint256 fundAmount = amount.sub(buyBackfundAmount);
1388         swapTokensForEth(buyBackfundAmount,buyBackAddress);
1389 
1390         uint256 fundsCount = fundsAddress.length;
1391         uint256 perMarketAmount = fundAmount.div(fundsCount);
1392        
1393         for(uint8 i = 0; i < fundsCount; i++) {
1394             if(fundsAddress[i] != address(0) && perMarketAmount > 0) {
1395                 super._transfer(address(this), fundsAddress[i], perMarketAmount);
1396             }
1397         }        
1398     }
1399 
1400     function swapTokensForEth(uint256 tokenAmount, address receiveAddress) private {
1401         emit StartSwapTokensForEth(tokenAmount);
1402         // generate the pancake pair path of token -> weth
1403         address[] memory path = new address[](2);
1404         path[0] = address(this);
1405         path[1] = pancakeRouter.WETH();
1406 
1407         _approve(address(this), address(pancakeRouter), tokenAmount);
1408 
1409         // make the swap
1410         pancakeRouter.swapExactTokensForETHSupportingFeeOnTransferTokens(
1411             tokenAmount,
1412             0, // accept any amount of ETH
1413             path,
1414             receiveAddress,
1415             block.timestamp
1416         );
1417         emit FinishSwapTokensForEth(address(this).balance);
1418     }
1419 
1420 }