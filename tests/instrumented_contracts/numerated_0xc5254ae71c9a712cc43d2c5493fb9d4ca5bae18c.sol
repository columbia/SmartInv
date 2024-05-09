1 // SPDX-License-Identifier: MIT
2 pragma solidity ^0.8.0;
3 
4 /**************************************************************************************/
5 // Address.sol
6 // File: @openzeppelin/contracts/utils/Address.sol
7 
8 /**
9  * @dev Collection of functions related to the address type
10  */
11 library Address {
12     /**
13      * @dev Returns true if `account` is a contract.
14      *
15      * [IMPORTANT]
16      * ====
17      * It is unsafe to assume that an address for which this function returns
18      * false is an externally-owned account (EOA) and not a contract.
19      *
20      * Among others, `isContract` will return false for the following
21      * types of addresses:
22      *
23      *  - an externally-owned account
24      *  - a contract in construction
25      *  - an address where a contract will be created
26      *  - an address where a contract lived, but was destroyed
27      * ====
28      */
29     function isContract(address account) internal view returns (bool) {
30         // This method relies on extcodesize, which returns 0 for contracts in
31         // construction, since the code is only stored at the end of the
32         // constructor execution.
33 
34         uint256 size;
35         assembly {
36             size := extcodesize(account)
37         }
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
60         (bool success, ) = recipient.call{value: amount}("");
61         require(success, "Address: unable to send value, recipient may have reverted");
62     }
63 
64     /**
65      * @dev Performs a Solidity function call using a low level `call`. A
66      * plain `call` is an unsafe replacement for a function call: use this
67      * function instead.
68      *
69      * If `target` reverts with a revert reason, it is bubbled up by this
70      * function (like regular Solidity function calls).
71      *
72      * Returns the raw returned data. To convert to the expected return value,
73      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
74      *
75      * Requirements:
76      *
77      * - `target` must be a contract.
78      * - calling `target` with `data` must not revert.
79      *
80      * _Available since v3.1._
81      */
82     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
83         return functionCall(target, data, "Address: low-level call failed");
84     }
85 
86     /**
87      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
88      * `errorMessage` as a fallback revert reason when `target` reverts.
89      *
90      * _Available since v3.1._
91      */
92     function functionCall(
93         address target,
94         bytes memory data,
95         string memory errorMessage
96     ) internal returns (bytes memory) {
97         return functionCallWithValue(target, data, 0, errorMessage);
98     }
99 
100     /**
101      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
102      * but also transferring `value` wei to `target`.
103      *
104      * Requirements:
105      *
106      * - the calling contract must have an ETH balance of at least `value`.
107      * - the called Solidity function must be `payable`.
108      *
109      * _Available since v3.1._
110      */
111     function functionCallWithValue(
112         address target,
113         bytes memory data,
114         uint256 value
115     ) internal returns (bytes memory) {
116         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
117     }
118 
119     /**
120      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
121      * with `errorMessage` as a fallback revert reason when `target` reverts.
122      *
123      * _Available since v3.1._
124      */
125     function functionCallWithValue(
126         address target,
127         bytes memory data,
128         uint256 value,
129         string memory errorMessage
130     ) internal returns (bytes memory) {
131         require(address(this).balance >= value, "Address: insufficient balance for call");
132         require(isContract(target), "Address: call to non-contract");
133 
134         (bool success, bytes memory returndata) = target.call{value: value}(data);
135         return verifyCallResult(success, returndata, errorMessage);
136     }
137 
138     /**
139      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
140      * but performing a static call.
141      *
142      * _Available since v3.3._
143      */
144     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
145         return functionStaticCall(target, data, "Address: low-level static call failed");
146     }
147 
148     /**
149      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
150      * but performing a static call.
151      *
152      * _Available since v3.3._
153      */
154     function functionStaticCall(
155         address target,
156         bytes memory data,
157         string memory errorMessage
158     ) internal view returns (bytes memory) {
159         require(isContract(target), "Address: static call to non-contract");
160 
161         (bool success, bytes memory returndata) = target.staticcall(data);
162         return verifyCallResult(success, returndata, errorMessage);
163     }
164 
165     /**
166      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
167      * but performing a delegate call.
168      *
169      * _Available since v3.4._
170      */
171     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
172         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
173     }
174 
175     /**
176      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
177      * but performing a delegate call.
178      *
179      * _Available since v3.4._
180      */
181     function functionDelegateCall(
182         address target,
183         bytes memory data,
184         string memory errorMessage
185     ) internal returns (bytes memory) {
186         require(isContract(target), "Address: delegate call to non-contract");
187 
188         (bool success, bytes memory returndata) = target.delegatecall(data);
189         return verifyCallResult(success, returndata, errorMessage);
190     }
191 
192     /**
193      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
194      * revert reason using the provided one.
195      *
196      * _Available since v4.3._
197      */
198     function verifyCallResult(
199         bool success,
200         bytes memory returndata,
201         string memory errorMessage
202     ) internal pure returns (bytes memory) {
203         if (success) {
204             return returndata;
205         } else {
206             // Look for revert reason and bubble it up if present
207             if (returndata.length > 0) {
208                 // The easiest way to bubble the revert reason is using memory via assembly
209 
210                 assembly {
211                     let returndata_size := mload(returndata)
212                     revert(add(32, returndata), returndata_size)
213                 }
214             } else {
215                 revert(errorMessage);
216             }
217         }
218     }
219 }
220 
221 
222 /**************************************************************************************/
223 // Context.sol
224 // File: @openzeppelin/contracts/utils/Context.sol
225 
226 /**
227  * @dev Provides information about the current execution context, including the
228  * sender of the transaction and its data. While these are generally available
229  * via msg.sender and msg.data, they should not be accessed in such a direct
230  * manner, since when dealing with meta-transactions the account sending and
231  * paying for execution may not be the actual sender (as far as an application
232  * is concerned).
233  *
234  * This contract is only required for intermediate, library-like contracts.
235  */
236 abstract contract Context {
237     function _msgSender() internal view virtual returns (address) {
238         return msg.sender;
239     }
240 
241     function _msgData() internal view virtual returns (bytes calldata) {
242         return msg.data;
243     }
244 }
245 
246 
247 /**************************************************************************************/
248 // IERC20.sol
249 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
250 
251 /**
252  * @dev Interface of the ERC20 standard as defined in the EIP.
253  */
254 interface IERC20 {
255     /**
256      * @dev Returns the amount of tokens in existence.
257      */
258     function totalSupply() external view returns (uint256);
259 
260     /**
261      * @dev Returns the amount of tokens owned by `account`.
262      */
263     function balanceOf(address account) external view returns (uint256);
264 
265     /**
266      * @dev Moves `amount` tokens from the caller's account to `recipient`.
267      *
268      * Returns a boolean value indicating whether the operation succeeded.
269      *
270      * Emits a {Transfer} event.
271      */
272     function transfer(address recipient, uint256 amount) external returns (bool);
273 
274     /**
275      * @dev Returns the remaining number of tokens that `spender` will be
276      * allowed to spend on behalf of `owner` through {transferFrom}. This is
277      * zero by default.
278      *
279      * This value changes when {approve} or {transferFrom} are called.
280      */
281     function allowance(address owner, address spender) external view returns (uint256);
282 
283     /**
284      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
285      *
286      * Returns a boolean value indicating whether the operation succeeded.
287      *
288      * IMPORTANT: Beware that changing an allowance with this method brings the risk
289      * that someone may use both the old and the new allowance by unfortunate
290      * transaction ordering. One possible solution to mitigate this race
291      * condition is to first reduce the spender's allowance to 0 and set the
292      * desired value afterwards:
293      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
294      *
295      * Emits an {Approval} event.
296      */
297     function approve(address spender, uint256 amount) external returns (bool);
298 
299     /**
300      * @dev Moves `amount` tokens from `sender` to `recipient` using the
301      * allowance mechanism. `amount` is then deducted from the caller's
302      * allowance.
303      *
304      * Returns a boolean value indicating whether the operation succeeded.
305      *
306      * Emits a {Transfer} event.
307      */
308     function transferFrom(
309         address sender,
310         address recipient,
311         uint256 amount
312     ) external returns (bool);
313 
314     /**
315      * @dev Emitted when `value` tokens are moved from one account (`from`) to
316      * another (`to`).
317      *
318      * Note that `value` may be zero.
319      */
320     event Transfer(address indexed from, address indexed to, uint256 value);
321 
322     /**
323      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
324      * a call to {approve}. `value` is the new allowance.
325      */
326     event Approval(address indexed owner, address indexed spender, uint256 value);
327 }
328 
329 
330 /**************************************************************************************/
331 // IERC20Metadata.sol
332 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
333 
334 /**
335  * @dev Interface for the optional metadata functions from the ERC20 standard.
336  *
337  * _Available since v4.1._
338  */
339 interface IERC20Metadata is IERC20 {
340     /**
341      * @dev Returns the name of the token.
342      */
343     function name() external view returns (string memory);
344 
345     /**
346      * @dev Returns the symbol of the token.
347      */
348     function symbol() external view returns (string memory);
349 
350     /**
351      * @dev Returns the decimals places of the token.
352      */
353     function decimals() external view returns (uint8);
354 }
355 
356 
357 /**************************************************************************************/
358 // ERC20.sol
359 // File:  @openzeppelin/contracts/token/ERC20/ERC20.sol
360 
361 /**
362  * @dev Implementation of the {IERC20} interface.
363  *
364  * This implementation is agnostic to the way tokens are created. This means
365  * that a supply mechanism has to be added in a derived contract using {_mint}.
366  * For a generic mechanism see {ERC20PresetMinterPauser}.
367  *
368  * TIP: For a detailed writeup see our guide
369  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
370  * to implement supply mechanisms].
371  *
372  * We have followed general OpenZeppelin Contracts guidelines: functions revert
373  * instead returning `false` on failure. This behavior is nonetheless
374  * conventional and does not conflict with the expectations of ERC20
375  * applications.
376  *
377  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
378  * This allows applications to reconstruct the allowance for all accounts just
379  * by listening to said events. Other implementations of the EIP may not emit
380  * these events, as it isn't required by the specification.
381  *
382  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
383  * functions have been added to mitigate the well-known issues around setting
384  * allowances. See {IERC20-approve}.
385  */
386 contract ERC20 is Context, IERC20, IERC20Metadata {
387     mapping(address => uint256) private _balances;
388 
389     mapping(address => mapping(address => uint256)) private _allowances;
390 
391     uint256 private _totalSupply;
392 
393     string private _name;
394     string private _symbol;
395 
396     /**
397      * @dev Sets the values for {name} and {symbol}.
398      *
399      * The default value of {decimals} is 18. To select a different value for
400      * {decimals} you should overload it.
401      *
402      * All two of these values are immutable: they can only be set once during
403      * construction.
404      */
405     constructor(string memory name_, string memory symbol_) {
406         _name = name_;
407         _symbol = symbol_;
408     }
409 
410     /**
411      * @dev Returns the name of the token.
412      */
413     function name() public view virtual override returns (string memory) {
414         return _name;
415     }
416 
417     /**
418      * @dev Returns the symbol of the token, usually a shorter version of the
419      * name.
420      */
421     function symbol() public view virtual override returns (string memory) {
422         return _symbol;
423     }
424 
425     /**
426      * @dev Returns the number of decimals used to get its user representation.
427      * For example, if `decimals` equals `2`, a balance of `505` tokens should
428      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
429      *
430      * Tokens usually opt for a value of 18, imitating the relationship between
431      * Ether and Wei. This is the value {ERC20} uses, unless this function is
432      * overridden;
433      *
434      * NOTE: This information is only used for _display_ purposes: it in
435      * no way affects any of the arithmetic of the contract, including
436      * {IERC20-balanceOf} and {IERC20-transfer}.
437      */
438     function decimals() public view virtual override returns (uint8) {
439         return 18;
440     }
441 
442     /**
443      * @dev See {IERC20-totalSupply}.
444      */
445     function totalSupply() public view virtual override returns (uint256) {
446         return _totalSupply;
447     }
448 
449     /**
450      * @dev See {IERC20-balanceOf}.
451      */
452     function balanceOf(address account) public view virtual override returns (uint256) {
453         return _balances[account];
454     }
455 
456     /**
457      * @dev See {IERC20-transfer}.
458      *
459      * Requirements:
460      *
461      * - `recipient` cannot be the zero address.
462      * - the caller must have a balance of at least `amount`.
463      */
464     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
465         _transfer(_msgSender(), recipient, amount);
466         return true;
467     }
468 
469     /**
470      * @dev See {IERC20-allowance}.
471      */
472     function allowance(address owner, address spender) public view virtual override returns (uint256) {
473         return _allowances[owner][spender];
474     }
475 
476     /**
477      * @dev See {IERC20-approve}.
478      *
479      * Requirements:
480      *
481      * - `spender` cannot be the zero address.
482      */
483     function approve(address spender, uint256 amount) public virtual override returns (bool) {
484         _approve(_msgSender(), spender, amount);
485         return true;
486     }
487 
488     /**
489      * @dev See {IERC20-transferFrom}.
490      *
491      * Emits an {Approval} event indicating the updated allowance. This is not
492      * required by the EIP. See the note at the beginning of {ERC20}.
493      *
494      * Requirements:
495      *
496      * - `sender` and `recipient` cannot be the zero address.
497      * - `sender` must have a balance of at least `amount`.
498      * - the caller must have allowance for ``sender``'s tokens of at least
499      * `amount`.
500      */
501     function transferFrom(
502         address sender,
503         address recipient,
504         uint256 amount
505     ) public virtual override returns (bool) {
506         _transfer(sender, recipient, amount);
507 
508         uint256 currentAllowance = _allowances[sender][_msgSender()];
509         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
510         unchecked {
511             _approve(sender, _msgSender(), currentAllowance - amount);
512         }
513 
514         return true;
515     }
516 
517     /**
518      * @dev Atomically increases the allowance granted to `spender` by the caller.
519      *
520      * This is an alternative to {approve} that can be used as a mitigation for
521      * problems described in {IERC20-approve}.
522      *
523      * Emits an {Approval} event indicating the updated allowance.
524      *
525      * Requirements:
526      *
527      * - `spender` cannot be the zero address.
528      */
529     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
530         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
531         return true;
532     }
533 
534     /**
535      * @dev Atomically decreases the allowance granted to `spender` by the caller.
536      *
537      * This is an alternative to {approve} that can be used as a mitigation for
538      * problems described in {IERC20-approve}.
539      *
540      * Emits an {Approval} event indicating the updated allowance.
541      *
542      * Requirements:
543      *
544      * - `spender` cannot be the zero address.
545      * - `spender` must have allowance for the caller of at least
546      * `subtractedValue`.
547      */
548     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
549         uint256 currentAllowance = _allowances[_msgSender()][spender];
550         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
551         unchecked {
552             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
553         }
554 
555         return true;
556     }
557 
558     /**
559      * @dev Moves `amount` of tokens from `sender` to `recipient`.
560      *
561      * This internal function is equivalent to {transfer}, and can be used to
562      * e.g. implement automatic token fees, slashing mechanisms, etc.
563      *
564      * Emits a {Transfer} event.
565      *
566      * Requirements:
567      *
568      * - `sender` cannot be the zero address.
569      * - `recipient` cannot be the zero address.
570      * - `sender` must have a balance of at least `amount`.
571      */
572     function _transfer(
573         address sender,
574         address recipient,
575         uint256 amount
576     ) internal virtual {
577         require(sender != address(0), "ERC20: transfer from the zero address");
578         require(recipient != address(0), "ERC20: transfer to the zero address");
579 
580         _beforeTokenTransfer(sender, recipient, amount);
581 
582         uint256 senderBalance = _balances[sender];
583         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
584         unchecked {
585             _balances[sender] = senderBalance - amount;
586         }
587         _balances[recipient] += amount;
588 
589         emit Transfer(sender, recipient, amount);
590 
591         _afterTokenTransfer(sender, recipient, amount);
592     }
593 
594     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
595      * the total supply.
596      *
597      * Emits a {Transfer} event with `from` set to the zero address.
598      *
599      * Requirements:
600      *
601      * - `account` cannot be the zero address.
602      */
603     function _mint(address account, uint256 amount) internal virtual {
604         require(account != address(0), "ERC20: mint to the zero address");
605 
606         _beforeTokenTransfer(address(0), account, amount);
607 
608         _totalSupply += amount;
609         _balances[account] += amount;
610         emit Transfer(address(0), account, amount);
611 
612         _afterTokenTransfer(address(0), account, amount);
613     }
614 
615     /**
616      * @dev Destroys `amount` tokens from `account`, reducing the
617      * total supply.
618      *
619      * Emits a {Transfer} event with `to` set to the zero address.
620      *
621      * Requirements:
622      *
623      * - `account` cannot be the zero address.
624      * - `account` must have at least `amount` tokens.
625      */
626     function _burn(address account, uint256 amount) internal virtual {
627         require(account != address(0), "ERC20: burn from the zero address");
628 
629         _beforeTokenTransfer(account, address(0), amount);
630 
631         uint256 accountBalance = _balances[account];
632         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
633         unchecked {
634             _balances[account] = accountBalance - amount;
635         }
636         _totalSupply -= amount;
637 
638         emit Transfer(account, address(0), amount);
639 
640         _afterTokenTransfer(account, address(0), amount);
641     }
642 
643     /**
644      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
645      *
646      * This internal function is equivalent to `approve`, and can be used to
647      * e.g. set automatic allowances for certain subsystems, etc.
648      *
649      * Emits an {Approval} event.
650      *
651      * Requirements:
652      *
653      * - `owner` cannot be the zero address.
654      * - `spender` cannot be the zero address.
655      */
656     function _approve(
657         address owner,
658         address spender,
659         uint256 amount
660     ) internal virtual {
661         require(owner != address(0), "ERC20: approve from the zero address");
662         require(spender != address(0), "ERC20: approve to the zero address");
663 
664         _allowances[owner][spender] = amount;
665         emit Approval(owner, spender, amount);
666     }
667 
668     /**
669      * @dev Hook that is called before any transfer of tokens. This includes
670      * minting and burning.
671      *
672      * Calling conditions:
673      *
674      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
675      * will be transferred to `to`.
676      * - when `from` is zero, `amount` tokens will be minted for `to`.
677      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
678      * - `from` and `to` are never both zero.
679      *
680      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
681      */
682     function _beforeTokenTransfer(
683         address from,
684         address to,
685         uint256 amount
686     ) internal virtual {}
687 
688     /**
689      * @dev Hook that is called after any transfer of tokens. This includes
690      * minting and burning.
691      *
692      * Calling conditions:
693      *
694      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
695      * has been transferred to `to`.
696      * - when `from` is zero, `amount` tokens have been minted for `to`.
697      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
698      * - `from` and `to` are never both zero.
699      *
700      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
701      */
702     function _afterTokenTransfer(
703         address from,
704         address to,
705         uint256 amount
706     ) internal virtual {}
707 }
708 
709 
710 /**************************************************************************************/
711 // Migrations.sol
712 
713 contract Migrations {
714   address public owner = msg.sender;
715   uint public last_completed_migration;
716 
717   modifier restricted() {
718     require(
719       msg.sender == owner,
720       "This function is restricted to the contract's owner"
721     );
722     _;
723   }
724 
725   function setCompleted(uint completed) public restricted {
726     last_completed_migration = completed;
727   }
728 }
729 
730 /**************************************************************************************/
731 // Ownable.sol
732 // File: @openzeppelin/contracts/access/Ownable.sol
733 
734 /**
735  * @dev Contract module which provides a basic access control mechanism, where
736  * there is an account (an owner) that can be granted exclusive access to
737  * specific functions.
738  *
739  * By default, the owner account will be the one that deploys the contract. This
740  * can later be changed with {transferOwnership}.
741  *
742  * This module is used through inheritance. It will make available the modifier
743  * `onlyOwner`, which can be applied to your functions to restrict their use to
744  * the owner.
745  */
746 abstract contract Ownable is Context {
747     address private _owner;
748 
749     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
750 
751     /**
752      * @dev Initializes the contract setting the deployer as the initial owner.
753      */
754     constructor() {
755         _setOwner(_msgSender());
756     }
757 
758     /**
759      * @dev Returns the address of the current owner.
760      */
761     function owner() public view virtual returns (address) {
762         return _owner;
763     }
764 
765     /**
766      * @dev Throws if called by any account other than the owner.
767      */
768     modifier onlyOwner() {
769         require(owner() == _msgSender(), "Ownable: caller is not the owner");
770         _;
771     }
772 
773     /**
774      * @dev Leaves the contract without owner. It will not be possible to call
775      * `onlyOwner` functions anymore. Can only be called by the current owner.
776      *
777      * NOTE: Renouncing ownership will leave the contract without an owner,
778      * thereby removing any functionality that is only available to the owner.
779      */
780     function renounceOwnership() public virtual onlyOwner {
781         _setOwner(address(0));
782     }
783 
784     /**
785      * @dev Transfers ownership of the contract to a new account (`newOwner`).
786      * Can only be called by the current owner.
787      */
788     function transferOwnership(address newOwner) public virtual onlyOwner {
789         require(newOwner != address(0), "Ownable: new owner is the zero address");
790         _setOwner(newOwner);
791     }
792 
793     function _setOwner(address newOwner) private {
794         address oldOwner = _owner;
795         _owner = newOwner;
796         emit OwnershipTransferred(oldOwner, newOwner);
797     }
798 }
799 
800 /**************************************************************************************/
801 // SafeMath.sol
802 // File @openzeppelin/contracts/utils/math/SafeMath.sol
803 
804 library SafeMath {
805     /**
806      * @dev Returns the addition of two unsigned integers, with an overflow flag.
807      *
808      * _Available since v3.4._
809      */
810     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
811         unchecked {
812             uint256 c = a + b;
813             if (c < a) return (false, 0);
814             return (true, c);
815         }
816     }
817 
818     /**
819      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
820      *
821      * _Available since v3.4._
822      */
823     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
824         unchecked {
825             if (b > a) return (false, 0);
826             return (true, a - b);
827         }
828     }
829 
830     /**
831      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
832      *
833      * _Available since v3.4._
834      */
835     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
836         unchecked {
837             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
838             // benefit is lost if 'b' is also tested.
839             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
840             if (a == 0) return (true, 0);
841             uint256 c = a * b;
842             if (c / a != b) return (false, 0);
843             return (true, c);
844         }
845     }
846 
847     /**
848      * @dev Returns the division of two unsigned integers, with a division by zero flag.
849      *
850      * _Available since v3.4._
851      */
852     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
853         unchecked {
854             if (b == 0) return (false, 0);
855             return (true, a / b);
856         }
857     }
858 
859     /**
860      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
861      *
862      * _Available since v3.4._
863      */
864     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
865         unchecked {
866             if (b == 0) return (false, 0);
867             return (true, a % b);
868         }
869     }
870 
871     /**
872      * @dev Returns the addition of two unsigned integers, reverting on
873      * overflow.
874      *
875      * Counterpart to Solidity's `+` operator.
876      *
877      * Requirements:
878      *
879      * - Addition cannot overflow.
880      */
881     function add(uint256 a, uint256 b) internal pure returns (uint256) {
882         return a + b;
883     }
884 
885     /**
886      * @dev Returns the subtraction of two unsigned integers, reverting on
887      * overflow (when the result is negative).
888      *
889      * Counterpart to Solidity's `-` operator.
890      *
891      * Requirements:
892      *
893      * - Subtraction cannot overflow.
894      */
895     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
896         return a - b;
897     }
898 
899     /**
900      * @dev Returns the multiplication of two unsigned integers, reverting on
901      * overflow.
902      *
903      * Counterpart to Solidity's `*` operator.
904      *
905      * Requirements:
906      *
907      * - Multiplication cannot overflow.
908      */
909     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
910         return a * b;
911     }
912 
913     /**
914      * @dev Returns the integer division of two unsigned integers, reverting on
915      * division by zero. The result is rounded towards zero.
916      *
917      * Counterpart to Solidity's `/` operator.
918      *
919      * Requirements:
920      *
921      * - The divisor cannot be zero.
922      */
923     function div(uint256 a, uint256 b) internal pure returns (uint256) {
924         return a / b;
925     }
926 
927     /**
928      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
929      * reverting when dividing by zero.
930      *
931      * Counterpart to Solidity's `%` operator. This function uses a `revert`
932      * opcode (which leaves remaining gas untouched) while Solidity uses an
933      * invalid opcode to revert (consuming all remaining gas).
934      *
935      * Requirements:
936      *
937      * - The divisor cannot be zero.
938      */
939     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
940         return a % b;
941     }
942 
943     /**
944      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
945      * overflow (when the result is negative).
946      *
947      * CAUTION: This function is deprecated because it requires allocating memory for the error
948      * message unnecessarily. For custom revert reasons use {trySub}.
949      *
950      * Counterpart to Solidity's `-` operator.
951      *
952      * Requirements:
953      *
954      * - Subtraction cannot overflow.
955      */
956     function sub(
957         uint256 a,
958         uint256 b,
959         string memory errorMessage
960     ) internal pure returns (uint256) {
961         unchecked {
962             require(b <= a, errorMessage);
963             return a - b;
964         }
965     }
966 
967     /**
968      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
969      * division by zero. The result is rounded towards zero.
970      *
971      * Counterpart to Solidity's `/` operator. Note: this function uses a
972      * `revert` opcode (which leaves remaining gas untouched) while Solidity
973      * uses an invalid opcode to revert (consuming all remaining gas).
974      *
975      * Requirements:
976      *
977      * - The divisor cannot be zero.
978      */
979     function div(
980         uint256 a,
981         uint256 b,
982         string memory errorMessage
983     ) internal pure returns (uint256) {
984         unchecked {
985             require(b > 0, errorMessage);
986             return a / b;
987         }
988     }
989 
990     /**
991      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
992      * reverting with custom message when dividing by zero.
993      *
994      * CAUTION: This function is deprecated because it requires allocating memory for the error
995      * message unnecessarily. For custom revert reasons use {tryMod}.
996      *
997      * Counterpart to Solidity's `%` operator. This function uses a `revert`
998      * opcode (which leaves remaining gas untouched) while Solidity uses an
999      * invalid opcode to revert (consuming all remaining gas).
1000      *
1001      * Requirements:
1002      *
1003      * - The divisor cannot be zero.
1004      */
1005     function mod(
1006         uint256 a,
1007         uint256 b,
1008         string memory errorMessage
1009     ) internal pure returns (uint256) {
1010         unchecked {
1011             require(b > 0, errorMessage);
1012             return a % b;
1013         }
1014     }
1015 }
1016 
1017 
1018 /**************************************************************************************/
1019 // Presale.sol
1020 
1021 contract Presale is ERC20, Ownable {
1022     using SafeMath for uint256;
1023     using Address for address;
1024 
1025     uint256 ETHER_DECIMALS = 1000000000000000000;
1026 
1027     uint256 public _price;
1028     uint256 public _purchaseLimit;
1029     bool public _isOpen = false;
1030     mapping(address => bool) public _whitelisted;
1031     mapping(address => uint256) public _mintCount;
1032 
1033     event Whitelisted(address account);
1034     event Delisted(address account);
1035     event Price(uint256 price);
1036     event PurchaseLimit(uint256 limit);
1037     event Open(bool isOpen);
1038     event Create(uint256 amount);
1039     event Destroy(uint256 amount);
1040 
1041     constructor(
1042         string memory name,
1043         string memory symbol,
1044         uint256 price,
1045         uint256 purchaseLimit
1046     ) ERC20(name, symbol) {
1047         _price = price;
1048         _purchaseLimit = purchaseLimit;
1049     }
1050 
1051     modifier onlyOpened() {
1052         require(_isOpen, "sale not open");
1053         _;
1054     }
1055 
1056     modifier onlyWhitelisted() {
1057         require(_whitelisted[msg.sender], "only whitelisted");
1058         _;
1059     }
1060 
1061     function addWhitelist(address[] memory accounts) external onlyOwner {
1062         for (uint i = 0; i < accounts.length; i++) {
1063             _whitelisted[accounts[i]] = true;
1064             emit Whitelisted(accounts[i]);
1065         }
1066     }
1067 
1068     function removeWhitelist(address[] memory accounts) external onlyOwner {
1069         for (uint i = 0; i < accounts.length; i++) {
1070             _whitelisted[accounts[i]] = false;
1071             emit Delisted(accounts[i]);
1072         }
1073     }
1074 
1075     function changePrice(uint256 price) external onlyOwner {
1076         _price = price;
1077         emit Price(price);
1078     }
1079 
1080     function changePurchaseLimit(uint256 purchaseLimit) external onlyOwner {
1081         _purchaseLimit = purchaseLimit;
1082         emit PurchaseLimit(purchaseLimit);
1083     }
1084 
1085     function emptyETHBalance() external onlyOwner {
1086         payable(owner()).transfer(address(this).balance);
1087     }
1088 
1089     function open() external onlyOwner {
1090         _isOpen = !_isOpen;
1091         emit Open(_isOpen);
1092     }
1093 
1094     function create(uint256 amount) external payable onlyOpened onlyWhitelisted {
1095         require(msg.value == _price.mul(amount), 'incorrect amount sent');
1096         require(_purchaseLimit >= _mintCount[msg.sender] + amount,
1097             'account already has created the maximum amount of allowed tokens');
1098 
1099         // mint new token
1100         _mint(msg.sender, amount.mul(ETHER_DECIMALS));
1101         _mintCount[msg.sender] = _mintCount[msg.sender] + amount;
1102         emit Create(amount);
1103 
1104         // forward ETH to owner
1105         payable(owner()).transfer(address(this).balance);
1106     }
1107 
1108     function destroy(uint256 amount) external onlyOwner {
1109         _burn(msg.sender, amount);
1110         emit Destroy(amount);
1111     }
1112 }
1113 
1114 /**************************************************************************************/