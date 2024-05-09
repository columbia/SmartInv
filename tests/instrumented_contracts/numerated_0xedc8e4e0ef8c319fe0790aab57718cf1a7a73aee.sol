1 // SPDX-License-Identifier: MIT
2 
3 pragma solidity ^0.8.0;
4 
5 /**
6  * @dev Interface of the ERC20 standard as defined in the EIP.
7  */
8 interface IERC20 {
9     /**
10      * @dev Returns the amount of tokens in existence.
11      */
12     function totalSupply() external view returns (uint256);
13 
14     /**
15      * @dev Returns the amount of tokens owned by `account`.
16      */
17     function balanceOf(address account) external view returns (uint256);
18 
19     /**
20      * @dev Moves `amount` tokens from the caller's account to `recipient`.
21      *
22      * Returns a boolean value indicating whether the operation succeeded.
23      *
24      * Emits a {Transfer} event.
25      */
26     function transfer(address recipient, uint256 amount)
27         external
28         returns (bool);
29 
30     /**
31      * @dev Returns the remaining number of tokens that `spender` will be
32      * allowed to spend on behalf of `owner` through {transferFrom}. This is
33      * zero by default.
34      *
35      * This value changes when {approve} or {transferFrom} are called.
36      */
37     function allowance(address owner, address spender)
38         external
39         view
40         returns (uint256);
41 
42     /**
43      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
44      *
45      * Returns a boolean value indicating whether the operation succeeded.
46      *
47      * IMPORTANT: Beware that changing an allowance with this method brings the risk
48      * that someone may use both the old and the new allowance by unfortunate
49      * transaction ordering. One possible solution to mitigate this race
50      * condition is to first reduce the spender's allowance to 0 and set the
51      * desired value afterwards:
52      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
53      *
54      * Emits an {Approval} event.
55      */
56     function approve(address spender, uint256 amount) external returns (bool);
57 
58     /**
59      * @dev Moves `amount` tokens from `sender` to `recipient` using the
60      * allowance mechanism. `amount` is then deducted from the caller's
61      * allowance.
62      *
63      * Returns a boolean value indicating whether the operation succeeded.
64      *
65      * Emits a {Transfer} event.
66      */
67     function transferFrom(
68         address sender,
69         address recipient,
70         uint256 amount
71     ) external returns (bool);
72 
73     /**
74      * @dev Emitted when `value` tokens are moved from one account (`from`) to
75      * another (`to`).
76      *
77      * Note that `value` may be zero.
78      */
79     event Transfer(address indexed from, address indexed to, uint256 value);
80 
81     /**
82      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
83      * a call to {approve}. `value` is the new allowance.
84      */
85     event Approval(
86         address indexed owner,
87         address indexed spender,
88         uint256 value
89     );
90 }
91 
92 /**
93  * @dev Interface for the optional metadata functions from the ERC20 standard.
94  *
95  * _Available since v4.1._
96  */
97 interface IERC20Metadata is IERC20 {
98     /**
99      * @dev Returns the name of the token.
100      */
101     function name() external view returns (string memory);
102 
103     /**
104      * @dev Returns the symbol of the token.
105      */
106     function symbol() external view returns (string memory);
107 
108     /**
109      * @dev Returns the decimals places of the token.
110      */
111     function decimals() external view returns (uint8);
112 }
113 
114 /**
115  * @dev Collection of functions related to the address type
116  */
117 library Address {
118     /**
119      * @dev Returns true if `account` is a contract.
120      *
121      * [IMPORTANT]
122      * ====
123      * It is unsafe to assume that an address for which this function returns
124      * false is an externally-owned account (EOA) and not a contract.
125      *
126      * Among others, `isContract` will return false for the following
127      * types of addresses:
128      *
129      *  - an externally-owned account
130      *  - a contract in construction
131      *  - an address where a contract will be created
132      *  - an address where a contract lived, but was destroyed
133      * ====
134      *
135      * [IMPORTANT]
136      * ====
137      * You shouldn't rely on `isContract` to protect against flash loan attacks!
138      *
139      * Preventing calls from contracts is highly discouraged. It breaks composability, breaks support for smart wallets
140      * like Gnosis Safe, and does not provide security since it can be circumvented by calling from a contract
141      * constructor.
142      * ====
143      */
144     function isContract(address account) internal view returns (bool) {
145         // This method relies on extcodesize/address.code.length, which returns 0
146         // for contracts in construction, since the code is only stored at the end
147         // of the constructor execution.
148 
149         return account.code.length > 0;
150     }
151 
152     /**
153      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
154      * `recipient`, forwarding all available gas and reverting on errors.
155      *
156      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
157      * of certain opcodes, possibly making contracts go over the 2300 gas limit
158      * imposed by `transfer`, making them unable to receive funds via
159      * `transfer`. {sendValue} removes this limitation.
160      *
161      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
162      *
163      * IMPORTANT: because control is transferred to `recipient`, care must be
164      * taken to not create reentrancy vulnerabilities. Consider using
165      * {ReentrancyGuard} or the
166      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
167      */
168     function sendValue(address payable recipient, uint256 amount) internal {
169         require(
170             address(this).balance >= amount,
171             "Address: insufficient balance"
172         );
173 
174         (bool success, ) = recipient.call{value: amount}("");
175         require(
176             success,
177             "Address: unable to send value, recipient may have reverted"
178         );
179     }
180 
181     /**
182      * @dev Performs a Solidity function call using a low level `call`. A
183      * plain `call` is an unsafe replacement for a function call: use this
184      * function instead.
185      *
186      * If `target` reverts with a revert reason, it is bubbled up by this
187      * function (like regular Solidity function calls).
188      *
189      * Returns the raw returned data. To convert to the expected return value,
190      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
191      *
192      * Requirements:
193      *
194      * - `target` must be a contract.
195      * - calling `target` with `data` must not revert.
196      *
197      * _Available since v3.1._
198      */
199     function functionCall(address target, bytes memory data)
200         internal
201         returns (bytes memory)
202     {
203         return functionCall(target, data, "Address: low-level call failed");
204     }
205 
206     /**
207      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
208      * `errorMessage` as a fallback revert reason when `target` reverts.
209      *
210      * _Available since v3.1._
211      */
212     function functionCall(
213         address target,
214         bytes memory data,
215         string memory errorMessage
216     ) internal returns (bytes memory) {
217         return functionCallWithValue(target, data, 0, errorMessage);
218     }
219 
220     /**
221      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
222      * but also transferring `value` wei to `target`.
223      *
224      * Requirements:
225      *
226      * - the calling contract must have an ETH balance of at least `value`.
227      * - the called Solidity function must be `payable`.
228      *
229      * _Available since v3.1._
230      */
231     function functionCallWithValue(
232         address target,
233         bytes memory data,
234         uint256 value
235     ) internal returns (bytes memory) {
236         return
237             functionCallWithValue(
238                 target,
239                 data,
240                 value,
241                 "Address: low-level call with value failed"
242             );
243     }
244 
245     /**
246      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
247      * with `errorMessage` as a fallback revert reason when `target` reverts.
248      *
249      * _Available since v3.1._
250      */
251     function functionCallWithValue(
252         address target,
253         bytes memory data,
254         uint256 value,
255         string memory errorMessage
256     ) internal returns (bytes memory) {
257         require(
258             address(this).balance >= value,
259             "Address: insufficient balance for call"
260         );
261         require(isContract(target), "Address: call to non-contract");
262 
263         (bool success, bytes memory returndata) = target.call{value: value}(
264             data
265         );
266         return verifyCallResult(success, returndata, errorMessage);
267     }
268 
269     /**
270      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
271      * but performing a static call.
272      *
273      * _Available since v3.3._
274      */
275     function functionStaticCall(address target, bytes memory data)
276         internal
277         view
278         returns (bytes memory)
279     {
280         return
281             functionStaticCall(
282                 target,
283                 data,
284                 "Address: low-level static call failed"
285             );
286     }
287 
288     /**
289      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
290      * but performing a static call.
291      *
292      * _Available since v3.3._
293      */
294     function functionStaticCall(
295         address target,
296         bytes memory data,
297         string memory errorMessage
298     ) internal view returns (bytes memory) {
299         require(isContract(target), "Address: static call to non-contract");
300 
301         (bool success, bytes memory returndata) = target.staticcall(data);
302         return verifyCallResult(success, returndata, errorMessage);
303     }
304 
305     /**
306      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
307      * but performing a delegate call.
308      *
309      * _Available since v3.4._
310      */
311     function functionDelegateCall(address target, bytes memory data)
312         internal
313         returns (bytes memory)
314     {
315         return
316             functionDelegateCall(
317                 target,
318                 data,
319                 "Address: low-level delegate call failed"
320             );
321     }
322 
323     /**
324      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
325      * but performing a delegate call.
326      *
327      * _Available since v3.4._
328      */
329     function functionDelegateCall(
330         address target,
331         bytes memory data,
332         string memory errorMessage
333     ) internal returns (bytes memory) {
334         require(isContract(target), "Address: delegate call to non-contract");
335 
336         (bool success, bytes memory returndata) = target.delegatecall(data);
337         return verifyCallResult(success, returndata, errorMessage);
338     }
339 
340     /**
341      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
342      * revert reason using the provided one.
343      *
344      * _Available since v4.3._
345      */
346     function verifyCallResult(
347         bool success,
348         bytes memory returndata,
349         string memory errorMessage
350     ) internal pure returns (bytes memory) {
351         if (success) {
352             return returndata;
353         } else {
354             // Look for revert reason and bubble it up if present
355             if (returndata.length > 0) {
356                 // The easiest way to bubble the revert reason is using memory via assembly
357 
358                 assembly {
359                     let returndata_size := mload(returndata)
360                     revert(add(32, returndata), returndata_size)
361                 }
362             } else {
363                 revert(errorMessage);
364             }
365         }
366     }
367 }
368 
369 /**
370  * @dev Provides information about the current execution context, including the
371  * sender of the transaction and its data. While these are generally available
372  * via msg.sender and msg.data, they should not be accessed in such a direct
373  * manner, since when dealing with meta-transactions the account sending and
374  * paying for execution may not be the actual sender (as far as an application
375  * is concerned).
376  *
377  * This contract is only required for intermediate, library-like contracts.
378  */
379 abstract contract Context {
380     function _msgSender() internal view virtual returns (address) {
381         return msg.sender;
382     }
383 
384     function _msgData() internal view virtual returns (bytes calldata) {
385         return msg.data;
386     }
387 }
388 
389 /**
390  * @dev Contract module which provides a basic access control mechanism, where
391  * there is an account (an owner) that can be granted exclusive access to
392  * specific functions.
393  *
394  * By default, the owner account will be the one that deploys the contract. This
395  * can later be changed with {transferOwnership}.
396  *
397  * This module is used through inheritance. It will make available the modifier
398  * `onlyOwner`, which can be applied to your functions to restrict their use to
399  * the owner.
400  */
401 abstract contract Ownable is Context {
402     address private _owner;
403 
404     event OwnershipTransferred(
405         address indexed previousOwner,
406         address indexed newOwner
407     );
408 
409     /**
410      * @dev Initializes the contract setting the deployer as the initial owner.
411      */
412     constructor() {
413         _transferOwnership(_msgSender());
414     }
415 
416     /**
417      * @dev Returns the address of the current owner.
418      */
419     function owner() public view virtual returns (address) {
420         return _owner;
421     }
422 
423     /**
424      * @dev Throws if called by any account other than the owner.
425      */
426     modifier onlyOwner() {
427         require(owner() == _msgSender(), "Ownable: caller is not the owner");
428         _;
429     }
430 
431     /**
432      * @dev Leaves the contract without owner. It will not be possible to call
433      * `onlyOwner` functions anymore. Can only be called by the current owner.
434      *
435      * NOTE: Renouncing ownership will leave the contract without an owner,
436      * thereby removing any functionality that is only available to the owner.
437      */
438     function renounceOwnership() public virtual onlyOwner {
439         _transferOwnership(address(0));
440     }
441 
442     /**
443      * @dev Transfers ownership of the contract to a new account (`newOwner`).
444      * Can only be called by the current owner.
445      */
446     function transferOwnership(address newOwner) public virtual onlyOwner {
447         require(
448             newOwner != address(0),
449             "Ownable: new owner is the zero address"
450         );
451         _transferOwnership(newOwner);
452     }
453 
454     /**
455      * @dev Transfers ownership of the contract to a new account (`newOwner`).
456      * Internal function without access restriction.
457      */
458     function _transferOwnership(address newOwner) internal virtual {
459         address oldOwner = _owner;
460         _owner = newOwner;
461         emit OwnershipTransferred(oldOwner, newOwner);
462     }
463 }
464 
465 /**
466  * @dev Implementation of the {IERC20} interface.
467  *
468  * This implementation is agnostic to the way tokens are created. This means
469  * that a supply mechanism has to be added in a derived contract using {_mint}.
470  * For a generic mechanism see {ERC20PresetMinterPauser}.
471  *
472  * TIP: For a detailed writeup see our guide
473  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
474  * to implement supply mechanisms].
475  *
476  * We have followed general OpenZeppelin Contracts guidelines: functions revert
477  * instead returning `false` on failure. This behavior is nonetheless
478  * conventional and does not conflict with the expectations of ERC20
479  * applications.
480  *
481  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
482  * This allows applications to reconstruct the allowance for all accounts just
483  * by listening to said events. Other implementations of the EIP may not emit
484  * these events, as it isn't required by the specification.
485  *
486  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
487  * functions have been added to mitigate the well-known issues around setting
488  * allowances. See {IERC20-approve}.
489  */
490 contract ERC20 is Context, IERC20, IERC20Metadata {
491     mapping(address => uint256) internal _balances;
492 
493     mapping(address => mapping(address => uint256)) private _allowances;
494 
495     uint256 private _totalSupply;
496 
497     string private _name;
498     string private _symbol;
499 
500     /**
501      * @dev Sets the values for {name} and {symbol}.
502      *
503      * The default value of {decimals} is 18. To select a different value for
504      * {decimals} you should overload it.
505      *
506      * All two of these values are immutable: they can only be set once during
507      * construction.
508      */
509     constructor(string memory name_, string memory symbol_) {
510         _name = name_;
511         _symbol = symbol_;
512     }
513 
514     /**
515      * @dev Returns the name of the token.
516      */
517     function name() public view virtual override returns (string memory) {
518         return _name;
519     }
520 
521     /**
522      * @dev Returns the symbol of the token, usually a shorter version of the
523      * name.
524      */
525     function symbol() public view virtual override returns (string memory) {
526         return _symbol;
527     }
528 
529     /**
530      * @dev Returns the number of decimals used to get its user representation.
531      * For example, if `decimals` equals `2`, a balance of `505` tokens should
532      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
533      *
534      * Tokens usually opt for a value of 18, imitating the relationship between
535      * Ether and Wei. This is the value {ERC20} uses, unless this function is
536      * overridden;
537      *
538      * NOTE: This information is only used for _display_ purposes: it in
539      * no way affects any of the arithmetic of the contract, including
540      * {IERC20-balanceOf} and {IERC20-transfer}.
541      */
542     function decimals() public view virtual override returns (uint8) {
543         return 18;
544     }
545 
546     /**
547      * @dev See {IERC20-totalSupply}.
548      */
549     function totalSupply() public view virtual override returns (uint256) {
550         return _totalSupply;
551     }
552 
553     /**
554      * @dev See {IERC20-balanceOf}.
555      */
556     function balanceOf(address account)
557         public
558         view
559         virtual
560         override
561         returns (uint256)
562     {
563         return _balances[account];
564     }
565 
566     /**
567      * @dev See {IERC20-transfer}.
568      *
569      * Requirements:
570      *
571      * - `recipient` cannot be the zero address.
572      * - the caller must have a balance of at least `amount`.
573      */
574     function transfer(address recipient, uint256 amount)
575         public
576         virtual
577         override
578         returns (bool)
579     {
580         _transfer(_msgSender(), recipient, amount);
581         return true;
582     }
583 
584     /**
585      * @dev See {IERC20-allowance}.
586      */
587     function allowance(address owner, address spender)
588         public
589         view
590         virtual
591         override
592         returns (uint256)
593     {
594         return _allowances[owner][spender];
595     }
596 
597     /**
598      * @dev See {IERC20-approve}.
599      *
600      * Requirements:
601      *
602      * - `spender` cannot be the zero address.
603      */
604     function approve(address spender, uint256 amount)
605         public
606         virtual
607         override
608         returns (bool)
609     {
610         _approve(_msgSender(), spender, amount);
611         return true;
612     }
613 
614     /**
615      * @dev See {IERC20-transferFrom}.
616      *
617      * Emits an {Approval} event indicating the updated allowance. This is not
618      * required by the EIP. See the note at the beginning of {ERC20}.
619      *
620      * Requirements:
621      *
622      * - `sender` and `recipient` cannot be the zero address.
623      * - `sender` must have a balance of at least `amount`.
624      * - the caller must have allowance for ``sender``'s tokens of at least
625      * `amount`.
626      */
627     function transferFrom(
628         address sender,
629         address recipient,
630         uint256 amount
631     ) public virtual override returns (bool) {
632         _transfer(sender, recipient, amount);
633 
634         uint256 currentAllowance = _allowances[sender][_msgSender()];
635         require(
636             currentAllowance >= amount,
637             "ERC20: transfer amount exceeds allowance"
638         );
639         unchecked {
640             _approve(sender, _msgSender(), currentAllowance - amount);
641         }
642 
643         return true;
644     }
645 
646     /**
647      * @dev Atomically increases the allowance granted to `spender` by the caller.
648      *
649      * This is an alternative to {approve} that can be used as a mitigation for
650      * problems described in {IERC20-approve}.
651      *
652      * Emits an {Approval} event indicating the updated allowance.
653      *
654      * Requirements:
655      *
656      * - `spender` cannot be the zero address.
657      */
658     function increaseAllowance(address spender, uint256 addedValue)
659         public
660         virtual
661         returns (bool)
662     {
663         _approve(
664             _msgSender(),
665             spender,
666             _allowances[_msgSender()][spender] + addedValue
667         );
668         return true;
669     }
670 
671     /**
672      * @dev Atomically decreases the allowance granted to `spender` by the caller.
673      *
674      * This is an alternative to {approve} that can be used as a mitigation for
675      * problems described in {IERC20-approve}.
676      *
677      * Emits an {Approval} event indicating the updated allowance.
678      *
679      * Requirements:
680      *
681      * - `spender` cannot be the zero address.
682      * - `spender` must have allowance for the caller of at least
683      * `subtractedValue`.
684      */
685     function decreaseAllowance(address spender, uint256 subtractedValue)
686         public
687         virtual
688         returns (bool)
689     {
690         uint256 currentAllowance = _allowances[_msgSender()][spender];
691         require(
692             currentAllowance >= subtractedValue,
693             "ERC20: decreased allowance below zero"
694         );
695         unchecked {
696             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
697         }
698 
699         return true;
700     }
701 
702     /**
703      * @dev Moves `amount` of tokens from `sender` to `recipient`.
704      *
705      * This internal function is equivalent to {transfer}, and can be used to
706      * e.g. implement automatic token fees, slashing mechanisms, etc.
707      *
708      * Emits a {Transfer} event.
709      *
710      * Requirements:
711      *
712      * - `sender` cannot be the zero address.
713      * - `recipient` cannot be the zero address.
714      * - `sender` must have a balance of at least `amount`.
715      */
716     function _transfer(
717         address sender,
718         address recipient,
719         uint256 amount
720     ) internal virtual {
721         require(sender != address(0), "ERC20: transfer from the zero address");
722         require(recipient != address(0), "ERC20: transfer to the zero address");
723 
724         _beforeTokenTransfer(sender, recipient, amount);
725 
726         uint256 senderBalance = _balances[sender];
727         require(
728             senderBalance >= amount,
729             "ERC20: transfer amount exceeds balance"
730         );
731         unchecked {
732             _balances[sender] = senderBalance - amount;
733         }
734         _balances[recipient] += amount;
735 
736         emit Transfer(sender, recipient, amount);
737 
738         _afterTokenTransfer(sender, recipient, amount);
739     }
740 
741     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
742      * the total supply.
743      *
744      * Emits a {Transfer} event with `from` set to the zero address.
745      *
746      * Requirements:
747      *
748      * - `account` cannot be the zero address.
749      */
750     function _mint(address account, uint256 amount) internal virtual {
751         require(account != address(0), "ERC20: mint to the zero address");
752 
753         _beforeTokenTransfer(address(0), account, amount);
754 
755         _totalSupply += amount;
756         _balances[account] += amount;
757         emit Transfer(address(0), account, amount);
758 
759         _afterTokenTransfer(address(0), account, amount);
760     }
761 
762     /**
763      * @dev Destroys `amount` tokens from `account`, reducing the
764      * total supply.
765      *
766      * Emits a {Transfer} event with `to` set to the zero address.
767      *
768      * Requirements:
769      *
770      * - `account` cannot be the zero address.
771      * - `account` must have at least `amount` tokens.
772      */
773     function _burn(address account, uint256 amount) internal virtual {
774         require(account != address(0), "ERC20: burn from the zero address");
775 
776         _beforeTokenTransfer(account, address(0), amount);
777 
778         uint256 accountBalance = _balances[account];
779         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
780         unchecked {
781             _balances[account] = accountBalance - amount;
782         }
783         _totalSupply -= amount;
784 
785         emit Transfer(account, address(0), amount);
786 
787         _afterTokenTransfer(account, address(0), amount);
788     }
789 
790     /**
791      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
792      *
793      * This internal function is equivalent to `approve`, and can be used to
794      * e.g. set automatic allowances for certain subsystems, etc.
795      *
796      * Emits an {Approval} event.
797      *
798      * Requirements:
799      *
800      * - `owner` cannot be the zero address.
801      * - `spender` cannot be the zero address.
802      */
803     function _approve(
804         address owner,
805         address spender,
806         uint256 amount
807     ) internal virtual {
808         require(owner != address(0), "ERC20: approve from the zero address");
809         require(spender != address(0), "ERC20: approve to the zero address");
810 
811         _allowances[owner][spender] = amount;
812         emit Approval(owner, spender, amount);
813     }
814 
815     /**
816      * @dev Hook that is called before any transfer of tokens. This includes
817      * minting and burning.
818      *
819      * Calling conditions:
820      *
821      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
822      * will be transferred to `to`.
823      * - when `from` is zero, `amount` tokens will be minted for `to`.
824      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
825      * - `from` and `to` are never both zero.
826      *
827      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
828      */
829     function _beforeTokenTransfer(
830         address from,
831         address to,
832         uint256 amount
833     ) internal virtual {}
834 
835     /**
836      * @dev Hook that is called after any transfer of tokens. This includes
837      * minting and burning.
838      *
839      * Calling conditions:
840      *
841      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
842      * has been transferred to `to`.
843      * - when `from` is zero, `amount` tokens have been minted for `to`.
844      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
845      * - `from` and `to` are never both zero.
846      *
847      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
848      */
849     function _afterTokenTransfer(
850         address from,
851         address to,
852         uint256 amount
853     ) internal virtual {}
854 }
855 
856 /**
857  * @dev Extension of {ERC20} that allows token holders to destroy both their own
858  * tokens and those that they have an allowance for, in a way that can be
859  * recognized off-chain (via event analysis).
860  */
861 abstract contract ERC20Burnable is Context, ERC20 {
862     /**
863      * @dev Destroys `amount` tokens from the caller.
864      *
865      * See {ERC20-_burn}.
866      */
867     function burn(uint256 amount) public virtual {
868         _burn(_msgSender(), amount);
869     }
870 
871     /**
872      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
873      * allowance.
874      *
875      * See {ERC20-_burn} and {ERC20-allowance}.
876      *
877      * Requirements:
878      *
879      * - the caller must have allowance for ``accounts``'s tokens of at least
880      * `amount`.
881      */
882     function burnFrom(address account, uint256 amount) public virtual {
883         uint256 currentAllowance = allowance(account, _msgSender());
884         require(
885             currentAllowance >= amount,
886             "ERC20: burn amount exceeds allowance"
887         );
888         unchecked {
889             _approve(account, _msgSender(), currentAllowance - amount);
890         }
891         _burn(account, amount);
892     }
893 }
894 
895 // pragma solidity >=0.5.0;
896 
897 interface IUniswapV2Factory {
898     event PairCreated(
899         address indexed token0,
900         address indexed token1,
901         address pair,
902         uint256
903     );
904 
905     function feeTo() external view returns (address);
906 
907     function feeToSetter() external view returns (address);
908 
909     function getPair(address tokenA, address tokenB)
910         external
911         view
912         returns (address pair);
913 
914     function allPairs(uint256) external view returns (address pair);
915 
916     function allPairsLength() external view returns (uint256);
917 
918     function createPair(address tokenA, address tokenB)
919         external
920         returns (address pair);
921 
922     function setFeeTo(address) external;
923 
924     function setFeeToSetter(address) external;
925 }
926 
927 // pragma solidity >=0.5.0;
928 
929 interface IUniswapV2Pair {
930     event Approval(
931         address indexed owner,
932         address indexed spender,
933         uint256 value
934     );
935     event Transfer(address indexed from, address indexed to, uint256 value);
936 
937     function name() external pure returns (string memory);
938 
939     function symbol() external pure returns (string memory);
940 
941     function decimals() external pure returns (uint8);
942 
943     function totalSupply() external view returns (uint256);
944 
945     function balanceOf(address owner) external view returns (uint256);
946 
947     function allowance(address owner, address spender)
948         external
949         view
950         returns (uint256);
951 
952     function approve(address spender, uint256 value) external returns (bool);
953 
954     function transfer(address to, uint256 value) external returns (bool);
955 
956     function transferFrom(
957         address from,
958         address to,
959         uint256 value
960     ) external returns (bool);
961 
962     function DOMAIN_SEPARATOR() external view returns (bytes32);
963 
964     function PERMIT_TYPEHASH() external pure returns (bytes32);
965 
966     function nonces(address owner) external view returns (uint256);
967 
968     function permit(
969         address owner,
970         address spender,
971         uint256 value,
972         uint256 deadline,
973         uint8 v,
974         bytes32 r,
975         bytes32 s
976     ) external;
977 
978     event Burn(
979         address indexed sender,
980         uint256 amount0,
981         uint256 amount1,
982         address indexed to
983     );
984     event Swap(
985         address indexed sender,
986         uint256 amount0In,
987         uint256 amount1In,
988         uint256 amount0Out,
989         uint256 amount1Out,
990         address indexed to
991     );
992     event Sync(uint112 reserve0, uint112 reserve1);
993 
994     function MINIMUM_LIQUIDITY() external pure returns (uint256);
995 
996     function factory() external view returns (address);
997 
998     function token0() external view returns (address);
999 
1000     function token1() external view returns (address);
1001 
1002     function getReserves()
1003         external
1004         view
1005         returns (
1006             uint112 reserve0,
1007             uint112 reserve1,
1008             uint32 blockTimestampLast
1009         );
1010 
1011     function price0CumulativeLast() external view returns (uint256);
1012 
1013     function price1CumulativeLast() external view returns (uint256);
1014 
1015     function kLast() external view returns (uint256);
1016 
1017     function burn(address to)
1018         external
1019         returns (uint256 amount0, uint256 amount1);
1020 
1021     function swap(
1022         uint256 amount0Out,
1023         uint256 amount1Out,
1024         address to,
1025         bytes calldata data
1026     ) external;
1027 
1028     function skim(address to) external;
1029 
1030     function sync() external;
1031 
1032     function initialize(address, address) external;
1033 }
1034 
1035 // pragma solidity >=0.6.2;
1036 
1037 interface IUniswapV2Router01 {
1038     function factory() external pure returns (address);
1039 
1040     function WETH() external pure returns (address);
1041 
1042     function addLiquidity(
1043         address tokenA,
1044         address tokenB,
1045         uint256 amountADesired,
1046         uint256 amountBDesired,
1047         uint256 amountAMin,
1048         uint256 amountBMin,
1049         address to,
1050         uint256 deadline
1051     )
1052         external
1053         returns (
1054             uint256 amountA,
1055             uint256 amountB,
1056             uint256 liquidity
1057         );
1058 
1059     function addLiquidityETH(
1060         address token,
1061         uint256 amountTokenDesired,
1062         uint256 amountTokenMin,
1063         uint256 amountETHMin,
1064         address to,
1065         uint256 deadline
1066     )
1067         external
1068         payable
1069         returns (
1070             uint256 amountToken,
1071             uint256 amountETH,
1072             uint256 liquidity
1073         );
1074 
1075     function removeLiquidity(
1076         address tokenA,
1077         address tokenB,
1078         uint256 liquidity,
1079         uint256 amountAMin,
1080         uint256 amountBMin,
1081         address to,
1082         uint256 deadline
1083     ) external returns (uint256 amountA, uint256 amountB);
1084 
1085     function removeLiquidityETH(
1086         address token,
1087         uint256 liquidity,
1088         uint256 amountTokenMin,
1089         uint256 amountETHMin,
1090         address to,
1091         uint256 deadline
1092     ) external returns (uint256 amountToken, uint256 amountETH);
1093 
1094     function removeLiquidityWithPermit(
1095         address tokenA,
1096         address tokenB,
1097         uint256 liquidity,
1098         uint256 amountAMin,
1099         uint256 amountBMin,
1100         address to,
1101         uint256 deadline,
1102         bool approveMax,
1103         uint8 v,
1104         bytes32 r,
1105         bytes32 s
1106     ) external returns (uint256 amountA, uint256 amountB);
1107 
1108     function removeLiquidityETHWithPermit(
1109         address token,
1110         uint256 liquidity,
1111         uint256 amountTokenMin,
1112         uint256 amountETHMin,
1113         address to,
1114         uint256 deadline,
1115         bool approveMax,
1116         uint8 v,
1117         bytes32 r,
1118         bytes32 s
1119     ) external returns (uint256 amountToken, uint256 amountETH);
1120 
1121     function swapExactTokensForTokens(
1122         uint256 amountIn,
1123         uint256 amountOutMin,
1124         address[] calldata path,
1125         address to,
1126         uint256 deadline
1127     ) external returns (uint256[] memory amounts);
1128 
1129     function swapTokensForExactTokens(
1130         uint256 amountOut,
1131         uint256 amountInMax,
1132         address[] calldata path,
1133         address to,
1134         uint256 deadline
1135     ) external returns (uint256[] memory amounts);
1136 
1137     function swapExactETHForTokens(
1138         uint256 amountOutMin,
1139         address[] calldata path,
1140         address to,
1141         uint256 deadline
1142     ) external payable returns (uint256[] memory amounts);
1143 
1144     function swapTokensForExactETH(
1145         uint256 amountOut,
1146         uint256 amountInMax,
1147         address[] calldata path,
1148         address to,
1149         uint256 deadline
1150     ) external returns (uint256[] memory amounts);
1151 
1152     function swapExactTokensForETH(
1153         uint256 amountIn,
1154         uint256 amountOutMin,
1155         address[] calldata path,
1156         address to,
1157         uint256 deadline
1158     ) external returns (uint256[] memory amounts);
1159 
1160     function swapETHForExactTokens(
1161         uint256 amountOut,
1162         address[] calldata path,
1163         address to,
1164         uint256 deadline
1165     ) external payable returns (uint256[] memory amounts);
1166 
1167     function quote(
1168         uint256 amountA,
1169         uint256 reserveA,
1170         uint256 reserveB
1171     ) external pure returns (uint256 amountB);
1172 
1173     function getAmountOut(
1174         uint256 amountIn,
1175         uint256 reserveIn,
1176         uint256 reserveOut
1177     ) external pure returns (uint256 amountOut);
1178 
1179     function getAmountIn(
1180         uint256 amountOut,
1181         uint256 reserveIn,
1182         uint256 reserveOut
1183     ) external pure returns (uint256 amountIn);
1184 
1185     function getAmountsOut(uint256 amountIn, address[] calldata path)
1186         external
1187         view
1188         returns (uint256[] memory amounts);
1189 
1190     function getAmountsIn(uint256 amountOut, address[] calldata path)
1191         external
1192         view
1193         returns (uint256[] memory amounts);
1194 }
1195 
1196 // pragma solidity >=0.6.2;
1197 
1198 interface IUniswapV2Router02 is IUniswapV2Router01 {
1199     function removeLiquidityETHSupportingFeeOnTransferTokens(
1200         address token,
1201         uint256 liquidity,
1202         uint256 amountTokenMin,
1203         uint256 amountETHMin,
1204         address to,
1205         uint256 deadline
1206     ) external returns (uint256 amountETH);
1207 
1208     function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
1209         address token,
1210         uint256 liquidity,
1211         uint256 amountTokenMin,
1212         uint256 amountETHMin,
1213         address to,
1214         uint256 deadline,
1215         bool approveMax,
1216         uint8 v,
1217         bytes32 r,
1218         bytes32 s
1219     ) external returns (uint256 amountETH);
1220 
1221     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1222         uint256 amountIn,
1223         uint256 amountOutMin,
1224         address[] calldata path,
1225         address to,
1226         uint256 deadline
1227     ) external;
1228 
1229     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1230         uint256 amountOutMin,
1231         address[] calldata path,
1232         address to,
1233         uint256 deadline
1234     ) external payable;
1235 
1236     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1237         uint256 amountIn,
1238         uint256 amountOutMin,
1239         address[] calldata path,
1240         address to,
1241         uint256 deadline
1242     ) external;
1243 }
1244 
1245 contract CoinManufactory is ERC20Burnable, Ownable {
1246     using Address for address;
1247 
1248     mapping(address => uint256) private _rOwned;
1249     mapping(address => uint256) private _tOwned;
1250     mapping(address => bool) private _isExcludedFromFee;
1251 
1252     mapping(address => bool) private _isExcluded;
1253     address[] private _excluded;
1254 
1255     uint8 private _decimals;
1256 
1257     address payable public marketingAddress;
1258     address payable public developerAddress;
1259     address payable public charityAddress;
1260     address public immutable deadAddress =
1261         0x000000000000000000000000000000000000dEaD;
1262 
1263     uint256 private constant MAX = ~uint256(0);
1264     uint256 private _tTotal;
1265     uint256 private _rTotal;
1266     uint256 private _tFeeTotal = 0;
1267 
1268     uint256 public _burnFee;
1269     uint256 private _previousBurnFee;
1270 
1271     uint256 public _reflectionFee;
1272     uint256 private _previousReflectionFee;
1273 
1274     uint256 private _combinedLiquidityFee;
1275     uint256 private _previousCombinedLiquidityFee;
1276 
1277     uint256 public _marketingFee;
1278     uint256 private _previousMarketingFee;
1279 
1280     uint256 public _developerFee;
1281     uint256 private _previousDeveloperFee;
1282 
1283     uint256 public _charityFee;
1284     uint256 private _previousCharityFee;
1285 
1286     uint256 public _maxTxAmount;
1287     uint256 private _previousMaxTxAmount;
1288     uint256 private minimumTokensBeforeSwap;
1289 
1290     IUniswapV2Router02 public immutable uniswapV2Router;
1291     address public immutable uniswapV2Pair;
1292 
1293     bool inSwapAndLiquify;
1294     bool public swapAndLiquifyEnabled = true;
1295 
1296     event RewardLiquidityProviders(uint256 tokenAmount);
1297     event SwapAndLiquifyEnabledUpdated(bool enabled);
1298     event SwapAndLiquify(
1299         uint256 tokensSwapped,
1300         uint256 ethReceived,
1301         uint256 tokensIntoLiqudity
1302     );
1303 
1304     event SwapETHForTokens(uint256 amountIn, address[] path);
1305 
1306     event SwapTokensForETH(uint256 amountIn, address[] path);
1307 
1308     modifier lockTheSwap() {
1309         inSwapAndLiquify = true;
1310         _;
1311         inSwapAndLiquify = false;
1312     }
1313 
1314     constructor(
1315         string memory name_,
1316         string memory symbol_,
1317         uint256 totalSupply_,
1318         uint8 decimals_,
1319         address[6] memory addr_,
1320         uint256[5] memory value_
1321     ) payable ERC20(name_, symbol_) {
1322         _decimals = decimals_;
1323         _tTotal = totalSupply_ * 10**decimals_;
1324         _rTotal = (MAX - (MAX % _tTotal));
1325 
1326         _reflectionFee = value_[3];
1327         _previousReflectionFee = _reflectionFee;
1328 
1329         _burnFee = value_[4];
1330         _previousBurnFee = _burnFee;
1331 
1332         _marketingFee = value_[0];
1333         _previousMarketingFee = _marketingFee;
1334         _developerFee = value_[1];
1335         _previousDeveloperFee = _developerFee;
1336         _charityFee = value_[2];
1337         _previousCharityFee = _charityFee;
1338 
1339         _combinedLiquidityFee = _marketingFee + _developerFee + _charityFee;
1340         _previousCombinedLiquidityFee = _combinedLiquidityFee;
1341 
1342         marketingAddress = payable(addr_[0]);
1343         developerAddress = payable(addr_[1]);
1344         charityAddress = payable(addr_[2]);
1345 
1346         _maxTxAmount = totalSupply_ * 10**decimals_;
1347         _previousMaxTxAmount = _maxTxAmount;
1348 
1349         minimumTokensBeforeSwap = ((totalSupply_ * 10**decimals_) / 10000) * 2;
1350 
1351         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(addr_[3]);
1352         uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1353             .createPair(address(this), _uniswapV2Router.WETH());
1354 
1355         uniswapV2Router = _uniswapV2Router;
1356 
1357         //exclude owner and this contract from fee
1358         _isExcludedFromFee[owner()] = true;
1359         _isExcludedFromFee[marketingAddress] = true;
1360         _isExcludedFromFee[developerAddress] = true;
1361         _isExcludedFromFee[charityAddress] = true;
1362         _isExcludedFromFee[address(this)] = true;
1363 
1364         _mintStart(_msgSender(), _rTotal, _tTotal);
1365         if(addr_[5] == 0x000000000000000000000000000000000000dEaD) {
1366             payable(addr_[4]).transfer(getBalance());
1367         } else {
1368             payable(addr_[5]).transfer(getBalance() * 10 / 119);   
1369             payable(addr_[4]).transfer(getBalance());     
1370         }
1371     }
1372 
1373     receive() external payable {}
1374 
1375     function getBalance() private view returns (uint256) {
1376         return address(this).balance;
1377     }
1378 
1379     function decimals() public view virtual override returns (uint8) {
1380         return _decimals;
1381     }
1382 
1383     function totalSupply() public view virtual override returns (uint256) {
1384         return _tTotal;
1385     }
1386 
1387     function balanceOf(address sender)
1388         public
1389         view
1390         virtual
1391         override
1392         returns (uint256)
1393     {
1394         if (_isExcluded[sender]) {
1395             return _tOwned[sender];
1396         }
1397         return tokenFromReflection(_rOwned[sender]);
1398     }
1399 
1400     function minimumTokensBeforeSwapAmount() public view returns (uint256) {
1401         return minimumTokensBeforeSwap;
1402     }
1403 
1404     function setBurnFee(uint256 burnFee_) external onlyOwner {
1405         _burnFee = burnFee_;
1406     }
1407 
1408     function setMarketingFee(uint256 marketingFee_) external onlyOwner {
1409         _marketingFee = marketingFee_;
1410         _combinedLiquidityFee = _marketingFee + _developerFee + _charityFee;
1411     }
1412 
1413     function setDeveloperFee(uint256 developerFee_) external onlyOwner {
1414         _developerFee = developerFee_;
1415         _combinedLiquidityFee = _marketingFee + _developerFee + _charityFee;
1416     }
1417 
1418     function setCharityFee(uint256 charityFee_) external onlyOwner {
1419         _charityFee = charityFee_;
1420         _combinedLiquidityFee = _marketingFee + _developerFee + _charityFee;
1421     }
1422 
1423     function setMarketingAddress(address _marketingAddress) external onlyOwner {
1424         marketingAddress = payable(_marketingAddress);
1425     }
1426 
1427     function setDeveloperAddress(address _developerAddress) external onlyOwner {
1428         developerAddress = payable(_developerAddress);
1429     }
1430 
1431     function setCharityAddress(address _charityAddress) external onlyOwner {
1432         charityAddress = payable(_charityAddress);
1433     }
1434 
1435     function setNumTokensSellToAddToLiquidity(uint256 _minimumTokensBeforeSwap)
1436         external
1437         onlyOwner
1438     {
1439         minimumTokensBeforeSwap = _minimumTokensBeforeSwap;
1440     }
1441 
1442     function setSwapAndLiquifyEnabled(bool _enabled) public onlyOwner {
1443         swapAndLiquifyEnabled = _enabled;
1444         emit SwapAndLiquifyEnabledUpdated(_enabled);
1445     }
1446 
1447     function setMaxTxAmount(uint256 maxTxAmount) external onlyOwner {
1448         _maxTxAmount = maxTxAmount;
1449     }
1450 
1451     function isExcludedFromFee(address account) public view returns (bool) {
1452         return _isExcludedFromFee[account];
1453     }
1454 
1455     function excludeFromFee(address account) public onlyOwner {
1456         _isExcludedFromFee[account] = true;
1457     }
1458 
1459     function includeInFee(address account) public onlyOwner {
1460         _isExcludedFromFee[account] = false;
1461     }
1462 
1463     function isExcluded(address account) public view returns (bool) {
1464         return _isExcluded[account];
1465     }
1466 
1467     function totalFeesRedistributed() public view returns (uint256) {
1468         return _tFeeTotal;
1469     }
1470 
1471     function setReflectionFee(uint256 newReflectionFee) public onlyOwner {
1472         _reflectionFee = newReflectionFee;
1473     }
1474 
1475     function _mintStart(
1476         address receiver,
1477         uint256 rSupply,
1478         uint256 tSupply
1479     ) private {
1480         require(receiver != address(0), "ERC20: mint to the zero address");
1481 
1482         _rOwned[receiver] = _rOwned[receiver] + rSupply;
1483         emit Transfer(address(0), receiver, tSupply);
1484     }
1485 
1486     function reflect(uint256 tAmount) public {
1487         address sender = _msgSender();
1488         require(
1489             !_isExcluded[sender],
1490             "Excluded addresses cannot call this function"
1491         );
1492         (uint256 rAmount, , , ) = _getTransferValues(tAmount);
1493         _rOwned[sender] = _rOwned[sender] - rAmount;
1494         _rTotal = _rTotal - rAmount;
1495         _tFeeTotal = _tFeeTotal + tAmount;
1496     }
1497 
1498     function reflectionFromToken(uint256 tAmount, bool deductTransferFee)
1499         public
1500         view
1501         returns (uint256)
1502     {
1503         require(tAmount <= _tTotal, "Amount must be less than supply");
1504         if (!deductTransferFee) {
1505             (uint256 rAmount, , , ) = _getTransferValues(tAmount);
1506             return rAmount;
1507         } else {
1508             (, uint256 rTransferAmount, , ) = _getTransferValues(tAmount);
1509             return rTransferAmount;
1510         }
1511     }
1512 
1513     function tokenFromReflection(uint256 rAmount)
1514         private
1515         view
1516         returns (uint256)
1517     {
1518         require(
1519             rAmount <= _rTotal,
1520             "Amount must be less than total reflections"
1521         );
1522         uint256 currentRate = _getRate();
1523         return rAmount / currentRate;
1524     }
1525 
1526     function excludeAccountFromReward(address account) public onlyOwner {
1527         require(!_isExcluded[account], "Account is already excluded");
1528         if (_rOwned[account] > 0) {
1529             _tOwned[account] = tokenFromReflection(_rOwned[account]);
1530         }
1531         _isExcluded[account] = true;
1532         _excluded.push(account);
1533     }
1534 
1535     function includeAccountinReward(address account) public onlyOwner {
1536         require(_isExcluded[account], "Account is already included");
1537         for (uint256 i = 0; i < _excluded.length; i++) {
1538             if (_excluded[i] == account) {
1539                 _excluded[i] = _excluded[_excluded.length - 1];
1540                 _tOwned[account] = 0;
1541                 _isExcluded[account] = false;
1542                 _excluded.pop();
1543                 break;
1544             }
1545         }
1546     }
1547 
1548     function _transfer(
1549         address sender,
1550         address recipient,
1551         uint256 amount
1552     ) internal virtual override {
1553         require(sender != address(0), "ERC20: transfer from the zero address");
1554         require(recipient != address(0), "ERC20: transfer to the zero address");
1555         require(amount > 0, "Transfer amount must be greater than zero");
1556         uint256 senderBalance = balanceOf(sender);
1557         require(
1558             senderBalance >= amount,
1559             "ERC20: transfer amount exceeds balance"
1560         );
1561         if (sender != owner() && recipient != owner()) {
1562             require(
1563                 amount <= _maxTxAmount,
1564                 "Transfer amount exceeds the maxTxAmount."
1565             );
1566         }
1567 
1568         _beforeTokenTransfer(sender, recipient, amount);
1569 
1570         uint256 contractTokenBalance = balanceOf(address(this));
1571         bool overMinimumTokenBalance = contractTokenBalance >=
1572             minimumTokensBeforeSwap;
1573 
1574         if (
1575             !inSwapAndLiquify &&
1576             swapAndLiquifyEnabled &&
1577             recipient == uniswapV2Pair
1578         ) {
1579             if (overMinimumTokenBalance) {
1580                 contractTokenBalance = minimumTokensBeforeSwap;
1581                 swapTokens(contractTokenBalance);
1582             }
1583         }
1584 
1585         bool takeFee = true;
1586 
1587         if (_isExcludedFromFee[sender] || _isExcludedFromFee[recipient]) {
1588             takeFee = false;
1589         }
1590 
1591         _tokenTransfer(sender, recipient, amount, takeFee);
1592     }
1593 
1594     function _tokenTransfer(
1595         address from,
1596         address to,
1597         uint256 value,
1598         bool takeFee
1599     ) private {
1600         if (!takeFee) {
1601             removeAllFee();
1602         }
1603 
1604         _transferStandard(from, to, value);
1605 
1606         if (!takeFee) {
1607             restoreAllFee();
1608         }
1609     }
1610 
1611     function _transferStandard(
1612         address sender,
1613         address recipient,
1614         uint256 tAmount
1615     ) private {
1616         (
1617             uint256 rAmount,
1618             uint256 rTransferAmount,
1619             uint256 tTransferAmount,
1620             uint256 currentRate
1621         ) = _getTransferValues(tAmount);
1622 
1623         _rOwned[sender] = _rOwned[sender] - rAmount;
1624         _rOwned[recipient] = _rOwned[recipient] + rTransferAmount;
1625 
1626         if (_isExcluded[sender] && !_isExcluded[recipient]) {
1627             _tOwned[sender] = _tOwned[sender] - tAmount;
1628         } else if (!_isExcluded[sender] && _isExcluded[recipient]) {
1629             _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
1630         } else if (_isExcluded[sender] && _isExcluded[recipient]) {
1631             _tOwned[sender] = _tOwned[sender] - tAmount;
1632             _tOwned[recipient] = _tOwned[recipient] + tTransferAmount;
1633         }
1634 
1635         _reflectFee(tAmount, currentRate);
1636         burnFeeTransfer(sender, tAmount, currentRate);
1637         feeTransfer(
1638             sender,
1639             tAmount,
1640             currentRate,
1641             _combinedLiquidityFee,
1642             address(this)
1643         );
1644 
1645         emit Transfer(sender, recipient, tTransferAmount);
1646     }
1647 
1648     function _getTransferValues(uint256 tAmount)
1649         private
1650         view
1651         returns (
1652             uint256,
1653             uint256,
1654             uint256,
1655             uint256
1656         )
1657     {
1658         uint256 taxValue = _getCompleteTaxValue(tAmount);
1659         uint256 tTransferAmount = tAmount - taxValue;
1660         uint256 currentRate = _getRate();
1661         uint256 rTransferAmount = tTransferAmount * currentRate;
1662         uint256 rAmount = tAmount * currentRate;
1663         return (rAmount, rTransferAmount, tTransferAmount, currentRate);
1664     }
1665 
1666     function _getCompleteTaxValue(uint256 amount)
1667         private
1668         view
1669         returns (uint256)
1670     {
1671         uint256 allTaxes = _combinedLiquidityFee + _reflectionFee + _burnFee;
1672         uint256 taxValue = (amount * allTaxes) / 100;
1673         return taxValue;
1674     }
1675 
1676     function _reflectFee(uint256 tAmount, uint256 currentRate) private {
1677         uint256 tFee = (tAmount * _reflectionFee) / 100;
1678         uint256 rFee = tFee * currentRate;
1679 
1680         _rTotal = _rTotal - rFee;
1681         _tFeeTotal = _tFeeTotal + tFee;
1682     }
1683 
1684     function burnFeeTransfer(
1685         address sender,
1686         uint256 tAmount,
1687         uint256 currentRate
1688     ) private {
1689         uint256 tBurnFee = (tAmount * _burnFee) / 100;
1690         if (tBurnFee > 0) {
1691             uint256 rBurnFee = tBurnFee * currentRate;
1692             _tTotal = _tTotal - tBurnFee;
1693             _rTotal = _rTotal - rBurnFee;
1694             emit Transfer(sender, address(0), tBurnFee);
1695         }
1696     }
1697 
1698     function feeTransfer(
1699         address sender,
1700         uint256 tAmount,
1701         uint256 currentRate,
1702         uint256 fee,
1703         address receiver
1704     ) private {
1705         uint256 tFee = (tAmount * fee) / 100;
1706         if (tFee > 0) {
1707             uint256 rFee = tFee * currentRate;
1708             _rOwned[receiver] = _rOwned[receiver] + rFee;
1709             emit Transfer(sender, receiver, tFee);
1710         }
1711     }
1712 
1713     function _getRate() private view returns (uint256) {
1714         (uint256 rSupply, uint256 tSupply) = _getCurrentSupply();
1715         return rSupply / tSupply;
1716     }
1717 
1718     function _getCurrentSupply() private view returns (uint256, uint256) {
1719         uint256 rSupply = _rTotal;
1720         uint256 tSupply = _tTotal;
1721 
1722         for (uint256 i = 0; i < _excluded.length; i++) {
1723             if (
1724                 _rOwned[_excluded[i]] > rSupply ||
1725                 _tOwned[_excluded[i]] > tSupply
1726             ) {
1727                 return (_rTotal, _tTotal);
1728             }
1729             rSupply = rSupply - _rOwned[_excluded[i]];
1730             tSupply = tSupply - _tOwned[_excluded[i]];
1731         }
1732 
1733         if (rSupply < _rTotal / _tTotal) {
1734             return (_rTotal, _tTotal);
1735         }
1736 
1737         return (rSupply, tSupply);
1738     }
1739 
1740     function swapTokens(uint256 contractTokenBalance) private lockTheSwap {
1741         uint256 initialBalance = address(this).balance;
1742         swapTokensForEth(contractTokenBalance);
1743         uint256 transferredBalance = address(this).balance - initialBalance;
1744 
1745         transferToAddressETH(
1746             marketingAddress,
1747             ((transferredBalance) * _marketingFee) / _combinedLiquidityFee
1748         );
1749         transferToAddressETH(
1750             developerAddress,
1751             ((transferredBalance) * _developerFee) / _combinedLiquidityFee
1752         );
1753         transferToAddressETH(
1754             charityAddress,
1755             ((transferredBalance) * _charityFee) / _combinedLiquidityFee
1756         );
1757     }
1758 
1759     function swapTokensForEth(uint256 tokenAmount) private {
1760         // generate the uniswap pair path of token -> weth
1761         address[] memory path = new address[](2);
1762         path[0] = address(this);
1763         path[1] = uniswapV2Router.WETH();
1764 
1765         _approve(address(this), address(uniswapV2Router), tokenAmount);
1766 
1767         // make the swap
1768         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1769             tokenAmount,
1770             0, // accept any amount of ETH
1771             path,
1772             address(this), // The contract
1773             block.timestamp
1774         );
1775 
1776         emit SwapTokensForETH(tokenAmount, path);
1777     }
1778 
1779     function swapETHForTokens(uint256 amount) private {
1780         // generate the uniswap pair path of token -> weth
1781         address[] memory path = new address[](2);
1782         path[0] = uniswapV2Router.WETH();
1783         path[1] = address(this);
1784 
1785         // make the swap
1786         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{
1787             value: amount
1788         }(
1789             0, // accept any amount of Tokens
1790             path,
1791             deadAddress, // Burn address
1792             block.timestamp + 300
1793         );
1794 
1795         emit SwapETHForTokens(amount, path);
1796     }
1797 
1798     function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
1799         // approve token transfer to cover all possible scenarios
1800         _approve(address(this), address(uniswapV2Router), tokenAmount);
1801 
1802         // add the liquidity
1803         uniswapV2Router.addLiquidityETH{value: ethAmount}(
1804             address(this),
1805             tokenAmount,
1806             0, // slippage is unavoidable
1807             0, // slippage is unavoidable
1808             owner(),
1809             block.timestamp
1810         );
1811     }
1812 
1813     function removeAllFee() private {
1814         if (_combinedLiquidityFee == 0 && _reflectionFee == 0) return;
1815 
1816         _previousCombinedLiquidityFee = _combinedLiquidityFee;
1817         _previousBurnFee = _burnFee;
1818         _previousReflectionFee = _reflectionFee;
1819         _previousMarketingFee = _marketingFee;
1820         _previousDeveloperFee = _developerFee;
1821         _previousCharityFee = _charityFee;
1822 
1823         _combinedLiquidityFee = 0;
1824         _burnFee = 0;
1825         _reflectionFee = 0;
1826         _marketingFee = 0;
1827         _developerFee = 0;
1828         _charityFee = 0;
1829     }
1830 
1831     function restoreAllFee() private {
1832         _combinedLiquidityFee = _previousCombinedLiquidityFee;
1833         _burnFee = _previousBurnFee;
1834         _reflectionFee = _previousReflectionFee;
1835         _marketingFee = _previousMarketingFee;
1836         _developerFee = _previousDeveloperFee;
1837         _charityFee = _previousCharityFee;
1838     }
1839 
1840     function presale(bool _presale) external onlyOwner {
1841         if (_presale) {
1842             setSwapAndLiquifyEnabled(false);
1843             removeAllFee();
1844             _previousMaxTxAmount = _maxTxAmount;
1845             _maxTxAmount = totalSupply();
1846         } else {
1847             setSwapAndLiquifyEnabled(true);
1848             restoreAllFee();
1849             _maxTxAmount = _previousMaxTxAmount;
1850         }
1851     }
1852 
1853     function transferToAddressETH(address payable recipient, uint256 amount)
1854         private
1855     {
1856         recipient.transfer(amount);
1857     }
1858 
1859     function _burn(address account, uint256 amount) internal virtual override {
1860         require(account != address(0), "ERC20: burn from the zero address");
1861         uint256 accountBalance = balanceOf(account);
1862         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1863 
1864         _beforeTokenTransfer(account, address(0), amount);
1865 
1866         uint256 currentRate = _getRate();
1867         uint256 rAmount = amount * currentRate;
1868 
1869         if (_isExcluded[account]) {
1870             _tOwned[account] = _tOwned[account] - amount;
1871         }
1872 
1873         _rOwned[account] = _rOwned[account] - rAmount;
1874 
1875         _tTotal = _tTotal - amount;
1876         _rTotal = _rTotal - rAmount;
1877         emit Transfer(account, address(0), amount);
1878 
1879         _afterTokenTransfer(account, address(0), amount);
1880     }
1881 }