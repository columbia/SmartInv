1 /**
2 
3     https://t.me/ShivaETH
4 
5 */
6 
7 // SPDX-License-Identifier: MIT
8 pragma solidity =0.8.17 >=0.8.0 <0.9.0;
9 pragma experimental ABIEncoderV2;
10 
11 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
12 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
13 
14 /* pragma solidity ^0.8.0; */
15 
16 /**
17  * @dev Provides information about the current execution context, including the
18  * sender of the transaction and its data. While these are generally available
19  * via msg.sender and msg.data, they should not be accessed in such a direct
20  * manner, since when dealing with meta-transactions the account sending and
21  * paying for execution may not be the actual sender (as far as an application
22  * is concerned).
23  *
24  * This contract is only required for intermediate, library-like contracts.
25  */
26 abstract contract Context {
27     function _msgSender() internal view virtual returns (address) {
28         return msg.sender;
29     }
30 
31     function _msgData() internal view virtual returns (bytes calldata) {
32         return msg.data;
33     }
34 }
35 
36 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
37 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
38 
39 /* pragma solidity ^0.8.0; */
40 
41 /* import "../utils/Context.sol"; */
42 
43 /**
44  * @dev Contract module which provides a basic access control mechanism, where
45  * there is an account (an owner) that can be granted exclusive access to
46  * specific functions.
47  *
48  * By default, the owner account will be the one that deploys the contract. This
49  * can later be changed with {transferOwnership}.
50  *
51  * This module is used through inheritance. It will make available the modifier
52  * `onlyOwner`, which can be applied to your functions to restrict their use to
53  * the owner.
54  */
55 abstract contract Ownable is Context {
56     address private _owner;
57 
58     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
59 
60     /**
61      * @dev Initializes the contract setting the deployer as the initial owner.
62      */
63     constructor() {
64         _transferOwnership(_msgSender());
65     }
66 
67     /**
68      * @dev Returns the address of the current owner.
69      */
70     function owner() public view virtual returns (address) {
71         return _owner;
72     }
73 
74     /**
75      * @dev Throws if called by any account other than the owner.
76      */
77     modifier onlyOwner() {
78         require(owner() == _msgSender(), "Ownable: caller is not the owner");
79         _;
80     }
81 
82     /**
83      * @dev Leaves the contract without owner. It will not be possible to call
84      * `onlyOwner` functions anymore. Can only be called by the current owner.
85      *
86      * NOTE: Renouncing ownership will leave the contract without an owner,
87      * thereby removing any functionality that is only available to the owner.
88      */
89     function renounceOwnership() public virtual onlyOwner {
90         _transferOwnership(address(0));
91     }
92 
93     /**
94      * @dev Transfers ownership of the contract to a new account (`newOwner`).
95      * Can only be called by the current owner.
96      */
97     function transferOwnership(address newOwner) public virtual onlyOwner {
98         require(newOwner != address(0), "Ownable: new owner is the zero address");
99         _transferOwnership(newOwner);
100     }
101 
102     /**
103      * @dev Transfers ownership of the contract to a new account (`newOwner`).
104      * Internal function without access restriction.
105      */
106     function _transferOwnership(address newOwner) internal virtual {
107         address oldOwner = _owner;
108         _owner = newOwner;
109         emit OwnershipTransferred(oldOwner, newOwner);
110     }
111 }
112 
113 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
114 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
115 
116 /* pragma solidity ^0.8.0; */
117 
118 /**
119  * @dev Interface of the ERC20 standard as defined in the EIP.
120  */
121 interface IERC20 {
122     /**
123      * @dev Returns the amount of tokens in existence.
124      */
125     function totalSupply() external view returns (uint256);
126 
127     /**
128      * @dev Returns the amount of tokens owned by `account`.
129      */
130     function balanceOf(address account) external view returns (uint256);
131 
132     /**
133      * @dev Moves `amount` tokens from the caller's account to `recipient`.
134      *
135      * Returns a boolean value indicating whether the operation succeeded.
136      *
137      * Emits a {Transfer} event.
138      */
139     function transfer(address recipient, uint256 amount) external returns (bool);
140 
141     /**
142      * @dev Returns the remaining number of tokens that `spender` will be
143      * allowed to spend on behalf of `owner` through {transferFrom}. This is
144      * zero by default.
145      *
146      * This value changes when {approve} or {transferFrom} are called.
147      */
148     function allowance(address owner, address spender) external view returns (uint256);
149 
150     /**
151      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
152      *
153      * Returns a boolean value indicating whether the operation succeeded.
154      *
155      * IMPORTANT: Beware that changing an allowance with this method brings the risk
156      * that someone may use both the old and the new allowance by unfortunate
157      * transaction ordering. One possible solution to mitigate this race
158      * condition is to first reduce the spender's allowance to 0 and set the
159      * desired value afterwards:
160      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
161      *
162      * Emits an {Approval} event.
163      */
164     function approve(address spender, uint256 amount) external returns (bool);
165 
166     /**
167      * @dev Moves `amount` tokens from `sender` to `recipient` using the
168      * allowance mechanism. `amount` is then deducted from the caller's
169      * allowance.
170      *
171      * Returns a boolean value indicating whether the operation succeeded.
172      *
173      * Emits a {Transfer} event.
174      */
175     function transferFrom(
176         address sender,
177         address recipient,
178         uint256 amount
179     ) external returns (bool);
180 
181     /**
182      * @dev Emitted when `value` tokens are moved from one account (`from`) to
183      * another (`to`).
184      *
185      * Note that `value` may be zero.
186      */
187     event Transfer(address indexed from, address indexed to, uint256 value);
188 
189     /**
190      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
191      * a call to {approve}. `value` is the new allowance.
192      */
193     event Approval(address indexed owner, address indexed spender, uint256 value);
194 }
195 
196 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
197 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
198 
199 /* pragma solidity ^0.8.0; */
200 
201 /* import "../IERC20.sol"; */
202 
203 /**
204  * @dev Interface for the optional metadata functions from the ERC20 standard.
205  *
206  * _Available since v4.1._
207  */
208 interface IERC20Metadata is IERC20 {
209     /**
210      * @dev Returns the name of the token.
211      */
212     function name() external view returns (string memory);
213 
214     /**
215      * @dev Returns the symbol of the token.
216      */
217     function symbol() external view returns (string memory);
218 
219     /**
220      * @dev Returns the decimals places of the token.
221      */
222     function decimals() external view returns (uint8);
223 }
224 
225 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
226 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
227 
228 /* pragma solidity ^0.8.0; */
229 
230 /* import "./IERC20.sol"; */
231 /* import "./extensions/IERC20Metadata.sol"; */
232 /* import "../../utils/Context.sol"; */
233 
234 /**
235  * @dev Implementation of the {IERC20} interface.
236  *
237  * This implementation is agnostic to the way tokens are created. This means
238  * that a supply mechanism has to be added in a derived contract using {_mint}.
239  * For a generic mechanism see {ERC20PresetMinterPauser}.
240  *
241  * TIP: For a detailed writeup see our guide
242  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
243  * to implement supply mechanisms].
244  *
245  * We have followed general OpenZeppelin Contracts guidelines: functions revert
246  * instead returning `false` on failure. This behavior is nonetheless
247  * conventional and does not conflict with the expectations of ERC20
248  * applications.
249  *
250  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
251  * This allows applications to reconstruct the allowance for all accounts just
252  * by listening to said events. Other implementations of the EIP may not emit
253  * these events, as it isn't required by the specification.
254  *
255  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
256  * functions have been added to mitigate the well-known issues around setting
257  * allowances. See {IERC20-approve}.
258  */
259 contract ERC20 is Context, IERC20, IERC20Metadata {
260     mapping(address => uint256) private _balances;
261 
262     mapping(address => mapping(address => uint256)) private _allowances;
263 
264     uint256 private _totalSupply;
265 
266     string private _name;
267     string private _symbol;
268 
269     /**
270      * @dev Sets the values for {name} and {symbol}.
271      *
272      * The default value of {decimals} is 18. To select a different value for
273      * {decimals} you should overload it.
274      *
275      * All two of these values are immutable: they can only be set once during
276      * construction.
277      */
278     constructor(string memory name_, string memory symbol_) {
279         _name = name_;
280         _symbol = symbol_;
281     }
282 
283     /**
284      * @dev Returns the name of the token.
285      */
286     function name() public view virtual override returns (string memory) {
287         return _name;
288     }
289 
290     /**
291      * @dev Returns the symbol of the token, usually a shorter version of the
292      * name.
293      */
294     function symbol() public view virtual override returns (string memory) {
295         return _symbol;
296     }
297 
298     /**
299      * @dev Returns the number of decimals used to get its user representation.
300      * For example, if `decimals` equals `2`, a balance of `505` tokens should
301      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
302      *
303      * Tokens usually opt for a value of 18, imitating the relationship between
304      * Ether and Wei. This is the value {ERC20} uses, unless this function is
305      * overridden;
306      *
307      * NOTE: This information is only used for _display_ purposes: it in
308      * no way affects any of the arithmetic of the contract, including
309      * {IERC20-balanceOf} and {IERC20-transfer}.
310      */
311     function decimals() public view virtual override returns (uint8) {
312         return 18;
313     }
314 
315     /**
316      * @dev See {IERC20-totalSupply}.
317      */
318     function totalSupply() public view virtual override returns (uint256) {
319         return _totalSupply;
320     }
321 
322     /**
323      * @dev See {IERC20-balanceOf}.
324      */
325     function balanceOf(address account) public view virtual override returns (uint256) {
326         return _balances[account];
327     }
328 
329     /**
330      * @dev See {IERC20-transfer}.
331      *
332      * Requirements:
333      *
334      * - `recipient` cannot be the zero address.
335      * - the caller must have a balance of at least `amount`.
336      */
337     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
338         _transfer(_msgSender(), recipient, amount);
339         return true;
340     }
341 
342     /**
343      * @dev See {IERC20-allowance}.
344      */
345     function allowance(address owner, address spender) public view virtual override returns (uint256) {
346         return _allowances[owner][spender];
347     }
348 
349     /**
350      * @dev See {IERC20-approve}.
351      *
352      * Requirements:
353      *
354      * - `spender` cannot be the zero address.
355      */
356     function approve(address spender, uint256 amount) public virtual override returns (bool) {
357         _approve(_msgSender(), spender, amount);
358         return true;
359     }
360 
361     /**
362      * @dev See {IERC20-transferFrom}.
363      *
364      * Emits an {Approval} event indicating the updated allowance. This is not
365      * required by the EIP. See the note at the beginning of {ERC20}.
366      *
367      * Requirements:
368      *
369      * - `sender` and `recipient` cannot be the zero address.
370      * - `sender` must have a balance of at least `amount`.
371      * - the caller must have allowance for ``sender``'s tokens of at least
372      * `amount`.
373      */
374     function transferFrom(
375         address sender,
376         address recipient,
377         uint256 amount
378     ) public virtual override returns (bool) {
379         _transfer(sender, recipient, amount);
380 
381         uint256 currentAllowance = _allowances[sender][_msgSender()];
382         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
383         unchecked {
384             _approve(sender, _msgSender(), currentAllowance - amount);
385         }
386 
387         return true;
388     }
389 
390     /**
391      * @dev Atomically increases the allowance granted to `spender` by the caller.
392      *
393      * This is an alternative to {approve} that can be used as a mitigation for
394      * problems described in {IERC20-approve}.
395      *
396      * Emits an {Approval} event indicating the updated allowance.
397      *
398      * Requirements:
399      *
400      * - `spender` cannot be the zero address.
401      */
402     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
403         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
404         return true;
405     }
406 
407     /**
408      * @dev Atomically decreases the allowance granted to `spender` by the caller.
409      *
410      * This is an alternative to {approve} that can be used as a mitigation for
411      * problems described in {IERC20-approve}.
412      *
413      * Emits an {Approval} event indicating the updated allowance.
414      *
415      * Requirements:
416      *
417      * - `spender` cannot be the zero address.
418      * - `spender` must have allowance for the caller of at least
419      * `subtractedValue`.
420      */
421     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
422         uint256 currentAllowance = _allowances[_msgSender()][spender];
423         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
424         unchecked {
425             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
426         }
427 
428         return true;
429     }
430 
431     /**
432      * @dev Moves `amount` of tokens from `sender` to `recipient`.
433      *
434      * This internal function is equivalent to {transfer}, and can be used to
435      * e.g. implement automatic token fees, slashing mechanisms, etc.
436      *
437      * Emits a {Transfer} event.
438      *
439      * Requirements:
440      *
441      * - `sender` cannot be the zero address.
442      * - `recipient` cannot be the zero address.
443      * - `sender` must have a balance of at least `amount`.
444      */
445     function _transfer(
446         address sender,
447         address recipient,
448         uint256 amount
449     ) internal virtual {
450         require(sender != address(0), "ERC20: transfer from the zero address");
451         require(recipient != address(0), "ERC20: transfer to the zero address");
452 
453         _beforeTokenTransfer(sender, recipient, amount);
454 
455         uint256 senderBalance = _balances[sender];
456         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
457         unchecked {
458             _balances[sender] = senderBalance - amount;
459         }
460         _balances[recipient] += amount;
461 
462         emit Transfer(sender, recipient, amount);
463 
464         _afterTokenTransfer(sender, recipient, amount);
465     }
466 
467     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
468      * the total supply.
469      *
470      * Emits a {Transfer} event with `from` set to the zero address.
471      *
472      * Requirements:
473      *
474      * - `account` cannot be the zero address.
475      */
476     function _mint(address account, uint256 amount) internal virtual {
477         require(account != address(0), "ERC20: mint to the zero address");
478 
479         _beforeTokenTransfer(address(0), account, amount);
480 
481         _totalSupply += amount;
482         _balances[account] += amount;
483         emit Transfer(address(0), account, amount);
484 
485         _afterTokenTransfer(address(0), account, amount);
486     }
487 
488     /**
489      * @dev Destroys `amount` tokens from `account`, reducing the
490      * total supply.
491      *
492      * Emits a {Transfer} event with `to` set to the zero address.
493      *
494      * Requirements:
495      *
496      * - `account` cannot be the zero address.
497      * - `account` must have at least `amount` tokens.
498      */
499     function _burn(address account, uint256 amount) internal virtual {
500         require(account != address(0), "ERC20: burn from the zero address");
501 
502         _beforeTokenTransfer(account, address(0), amount);
503 
504         uint256 accountBalance = _balances[account];
505         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
506         unchecked {
507             _balances[account] = accountBalance - amount;
508         }
509         _totalSupply -= amount;
510 
511         emit Transfer(account, address(0), amount);
512 
513         _afterTokenTransfer(account, address(0), amount);
514     }
515 
516     /**
517      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
518      *
519      * This internal function is equivalent to `approve`, and can be used to
520      * e.g. set automatic allowances for certain subsystems, etc.
521      *
522      * Emits an {Approval} event.
523      *
524      * Requirements:
525      *
526      * - `owner` cannot be the zero address.
527      * - `spender` cannot be the zero address.
528      */
529     function _approve(
530         address owner,
531         address spender,
532         uint256 amount
533     ) internal virtual {
534         require(owner != address(0), "ERC20: approve from the zero address");
535         require(spender != address(0), "ERC20: approve to the zero address");
536 
537         _allowances[owner][spender] = amount;
538         emit Approval(owner, spender, amount);
539     }
540 
541     /**
542      * @dev Hook that is called before any transfer of tokens. This includes
543      * minting and burning.
544      *
545      * Calling conditions:
546      *
547      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
548      * will be transferred to `to`.
549      * - when `from` is zero, `amount` tokens will be minted for `to`.
550      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
551      * - `from` and `to` are never both zero.
552      *
553      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
554      */
555     function _beforeTokenTransfer(
556         address from,
557         address to,
558         uint256 amount
559     ) internal virtual {}
560 
561     /**
562      * @dev Hook that is called after any transfer of tokens. This includes
563      * minting and burning.
564      *
565      * Calling conditions:
566      *
567      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
568      * has been transferred to `to`.
569      * - when `from` is zero, `amount` tokens have been minted for `to`.
570      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
571      * - `from` and `to` are never both zero.
572      *
573      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
574      */
575     function _afterTokenTransfer(
576         address from,
577         address to,
578         uint256 amount
579     ) internal virtual {}
580 }
581 
582 ////// lib/openzeppelin-contracts/contracts/utils/Address.sol
583 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
584 
585 /* pragma solidity ^0.8.0; */
586 
587 /**
588  * @dev Collection of functions related to the address type
589  */
590 library Address {
591     /**
592      * @dev Returns true if `account` is a contract.
593      *
594      * [IMPORTANT]
595      * ====
596      * It is unsafe to assume that an address for which this function returns
597      * false is an externally-owned account (EOA) and not a contract.
598      *
599      * Among others, `isContract` will return false for the following
600      * types of addresses:
601      *
602      *  - an externally-owned account
603      *  - a contract in construction
604      *  - an address where a contract will be created
605      *  - an address where a contract lived, but was destroyed
606      * ====
607      */
608     function isContract(address account) internal view returns (bool) {
609         // This method relies on extcodesize, which returns 0 for contracts in
610         // construction, since the code is only stored at the end of the
611         // constructor execution.
612 
613         uint256 size;
614         assembly {
615             size := extcodesize(account)
616         }
617         return size > 0;
618     }
619 
620     /**
621      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
622      * `recipient`, forwarding all available gas and reverting on errors.
623      *
624      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
625      * of certain opcodes, possibly making contracts go over the 2300 gas limit
626      * imposed by `transfer`, making them unable to receive funds via
627      * `transfer`. {sendValue} removes this limitation.
628      *
629      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
630      *
631      * IMPORTANT: because control is transferred to `recipient`, care must be
632      * taken to not create reentrancy vulnerabilities. Consider using
633      * {ReentrancyGuard} or the
634      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
635      */
636     function sendValue(address payable recipient, uint256 amount) internal {
637         require(address(this).balance >= amount, "Address: insufficient balance");
638 
639         (bool success, ) = recipient.call{value: amount}("");
640         require(success, "Address: unable to send value, recipient may have reverted");
641     }
642 
643     /**
644      * @dev Performs a Solidity function call using a low level `call`. A
645      * plain `call` is an unsafe replacement for a function call: use this
646      * function instead.
647      *
648      * If `target` reverts with a revert reason, it is bubbled up by this
649      * function (like regular Solidity function calls).
650      *
651      * Returns the raw returned data. To convert to the expected return value,
652      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
653      *
654      * Requirements:
655      *
656      * - `target` must be a contract.
657      * - calling `target` with `data` must not revert.
658      *
659      * _Available since v3.1._
660      */
661     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
662         return functionCall(target, data, "Address: low-level call failed");
663     }
664 
665     /**
666      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
667      * `errorMessage` as a fallback revert reason when `target` reverts.
668      *
669      * _Available since v3.1._
670      */
671     function functionCall(
672         address target,
673         bytes memory data,
674         string memory errorMessage
675     ) internal returns (bytes memory) {
676         return functionCallWithValue(target, data, 0, errorMessage);
677     }
678 
679     /**
680      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
681      * but also transferring `value` wei to `target`.
682      *
683      * Requirements:
684      *
685      * - the calling contract must have an ETH balance of at least `value`.
686      * - the called Solidity function must be `payable`.
687      *
688      * _Available since v3.1._
689      */
690     function functionCallWithValue(
691         address target,
692         bytes memory data,
693         uint256 value
694     ) internal returns (bytes memory) {
695         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
696     }
697 
698     /**
699      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
700      * with `errorMessage` as a fallback revert reason when `target` reverts.
701      *
702      * _Available since v3.1._
703      */
704     function functionCallWithValue(
705         address target,
706         bytes memory data,
707         uint256 value,
708         string memory errorMessage
709     ) internal returns (bytes memory) {
710         require(address(this).balance >= value, "Address: insufficient balance for call");
711         require(isContract(target), "Address: call to non-contract");
712 
713         (bool success, bytes memory returndata) = target.call{value: value}(data);
714         return verifyCallResult(success, returndata, errorMessage);
715     }
716 
717     /**
718      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
719      * but performing a static call.
720      *
721      * _Available since v3.3._
722      */
723     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
724         return functionStaticCall(target, data, "Address: low-level static call failed");
725     }
726 
727     /**
728      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
729      * but performing a static call.
730      *
731      * _Available since v3.3._
732      */
733     function functionStaticCall(
734         address target,
735         bytes memory data,
736         string memory errorMessage
737     ) internal view returns (bytes memory) {
738         require(isContract(target), "Address: static call to non-contract");
739 
740         (bool success, bytes memory returndata) = target.staticcall(data);
741         return verifyCallResult(success, returndata, errorMessage);
742     }
743 
744     /**
745      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
746      * but performing a delegate call.
747      *
748      * _Available since v3.4._
749      */
750     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
751         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
752     }
753 
754     /**
755      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
756      * but performing a delegate call.
757      *
758      * _Available since v3.4._
759      */
760     function functionDelegateCall(
761         address target,
762         bytes memory data,
763         string memory errorMessage
764     ) internal returns (bytes memory) {
765         require(isContract(target), "Address: delegate call to non-contract");
766 
767         (bool success, bytes memory returndata) = target.delegatecall(data);
768         return verifyCallResult(success, returndata, errorMessage);
769     }
770 
771     /**
772      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
773      * revert reason using the provided one.
774      *
775      * _Available since v4.3._
776      */
777     function verifyCallResult(
778         bool success,
779         bytes memory returndata,
780         string memory errorMessage
781     ) internal pure returns (bytes memory) {
782         if (success) {
783             return returndata;
784         } else {
785             // Look for revert reason and bubble it up if present
786             if (returndata.length > 0) {
787                 // The easiest way to bubble the revert reason is using memory via assembly
788 
789                 assembly {
790                     let returndata_size := mload(returndata)
791                     revert(add(32, returndata), returndata_size)
792                 }
793             } else {
794                 revert(errorMessage);
795             }
796         }
797     }
798 }
799 
800 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
801 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
802 
803 /* pragma solidity ^0.8.0; */
804 
805 // CAUTION
806 // This version of SafeMath should only be used with Solidity 0.8 or later,
807 // because it relies on the compiler's built in overflow checks.
808 
809 /**
810  * @dev Wrappers over Solidity's arithmetic operations.
811  *
812  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
813  * now has built in overflow checking.
814  */
815 library SafeMath {
816     /**
817      * @dev Returns the addition of two unsigned integers, with an overflow flag.
818      *
819      * _Available since v3.4._
820      */
821     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
822         unchecked {
823             uint256 c = a + b;
824             if (c < a) return (false, 0);
825             return (true, c);
826         }
827     }
828 
829     /**
830      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
831      *
832      * _Available since v3.4._
833      */
834     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
835         unchecked {
836             if (b > a) return (false, 0);
837             return (true, a - b);
838         }
839     }
840 
841     /**
842      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
843      *
844      * _Available since v3.4._
845      */
846     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
847         unchecked {
848             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
849             // benefit is lost if 'b' is also tested.
850             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
851             if (a == 0) return (true, 0);
852             uint256 c = a * b;
853             if (c / a != b) return (false, 0);
854             return (true, c);
855         }
856     }
857 
858     /**
859      * @dev Returns the division of two unsigned integers, with a division by zero flag.
860      *
861      * _Available since v3.4._
862      */
863     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
864         unchecked {
865             if (b == 0) return (false, 0);
866             return (true, a / b);
867         }
868     }
869 
870     /**
871      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
872      *
873      * _Available since v3.4._
874      */
875     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
876         unchecked {
877             if (b == 0) return (false, 0);
878             return (true, a % b);
879         }
880     }
881 
882     /**
883      * @dev Returns the addition of two unsigned integers, reverting on
884      * overflow.
885      *
886      * Counterpart to Solidity's `+` operator.
887      *
888      * Requirements:
889      *
890      * - Addition cannot overflow.
891      */
892     function add(uint256 a, uint256 b) internal pure returns (uint256) {
893         return a + b;
894     }
895 
896     /**
897      * @dev Returns the subtraction of two unsigned integers, reverting on
898      * overflow (when the result is negative).
899      *
900      * Counterpart to Solidity's `-` operator.
901      *
902      * Requirements:
903      *
904      * - Subtraction cannot overflow.
905      */
906     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
907         return a - b;
908     }
909 
910     /**
911      * @dev Returns the multiplication of two unsigned integers, reverting on
912      * overflow.
913      *
914      * Counterpart to Solidity's `*` operator.
915      *
916      * Requirements:
917      *
918      * - Multiplication cannot overflow.
919      */
920     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
921         return a * b;
922     }
923 
924     /**
925      * @dev Returns the integer division of two unsigned integers, reverting on
926      * division by zero. The result is rounded towards zero.
927      *
928      * Counterpart to Solidity's `/` operator.
929      *
930      * Requirements:
931      *
932      * - The divisor cannot be zero.
933      */
934     function div(uint256 a, uint256 b) internal pure returns (uint256) {
935         return a / b;
936     }
937 
938     /**
939      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
940      * reverting when dividing by zero.
941      *
942      * Counterpart to Solidity's `%` operator. This function uses a `revert`
943      * opcode (which leaves remaining gas untouched) while Solidity uses an
944      * invalid opcode to revert (consuming all remaining gas).
945      *
946      * Requirements:
947      *
948      * - The divisor cannot be zero.
949      */
950     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
951         return a % b;
952     }
953 
954     /**
955      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
956      * overflow (when the result is negative).
957      *
958      * CAUTION: This function is deprecated because it requires allocating memory for the error
959      * message unnecessarily. For custom revert reasons use {trySub}.
960      *
961      * Counterpart to Solidity's `-` operator.
962      *
963      * Requirements:
964      *
965      * - Subtraction cannot overflow.
966      */
967     function sub(
968         uint256 a,
969         uint256 b,
970         string memory errorMessage
971     ) internal pure returns (uint256) {
972         unchecked {
973             require(b <= a, errorMessage);
974             return a - b;
975         }
976     }
977 
978     /**
979      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
980      * division by zero. The result is rounded towards zero.
981      *
982      * Counterpart to Solidity's `/` operator. Note: this function uses a
983      * `revert` opcode (which leaves remaining gas untouched) while Solidity
984      * uses an invalid opcode to revert (consuming all remaining gas).
985      *
986      * Requirements:
987      *
988      * - The divisor cannot be zero.
989      */
990     function div(
991         uint256 a,
992         uint256 b,
993         string memory errorMessage
994     ) internal pure returns (uint256) {
995         unchecked {
996             require(b > 0, errorMessage);
997             return a / b;
998         }
999     }
1000 
1001     /**
1002      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1003      * reverting with custom message when dividing by zero.
1004      *
1005      * CAUTION: This function is deprecated because it requires allocating memory for the error
1006      * message unnecessarily. For custom revert reasons use {tryMod}.
1007      *
1008      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1009      * opcode (which leaves remaining gas untouched) while Solidity uses an
1010      * invalid opcode to revert (consuming all remaining gas).
1011      *
1012      * Requirements:
1013      *
1014      * - The divisor cannot be zero.
1015      */
1016     function mod(
1017         uint256 a,
1018         uint256 b,
1019         string memory errorMessage
1020     ) internal pure returns (uint256) {
1021         unchecked {
1022             require(b > 0, errorMessage);
1023             return a % b;
1024         }
1025     }
1026 }
1027 
1028 ////// src/IUniswapV2Factory.sol
1029 /* pragma solidity 0.8.10; */
1030 /* pragma experimental ABIEncoderV2; */
1031 
1032 interface IUniswapV2Factory {
1033     event PairCreated(
1034         address indexed token0,
1035         address indexed token1,
1036         address pair,
1037         uint256
1038     );
1039 
1040     function feeTo() external view returns (address);
1041 
1042     function feeToSetter() external view returns (address);
1043 
1044     function getPair(address tokenA, address tokenB)
1045         external
1046         view
1047         returns (address pair);
1048 
1049     function allPairs(uint256) external view returns (address pair);
1050 
1051     function allPairsLength() external view returns (uint256);
1052 
1053     function createPair(address tokenA, address tokenB)
1054         external
1055         returns (address pair);
1056 
1057     function setFeeTo(address) external;
1058 
1059     function setFeeToSetter(address) external;
1060 }
1061 
1062 ////// src/IUniswapV2Pair.sol
1063 /* pragma solidity 0.8.10; */
1064 /* pragma experimental ABIEncoderV2; */
1065 
1066 interface IUniswapV2Pair {
1067     event Approval(
1068         address indexed owner,
1069         address indexed spender,
1070         uint256 value
1071     );
1072     event Transfer(address indexed from, address indexed to, uint256 value);
1073 
1074     function name() external pure returns (string memory);
1075 
1076     function symbol() external pure returns (string memory);
1077 
1078     function decimals() external pure returns (uint8);
1079 
1080     function totalSupply() external view returns (uint256);
1081 
1082     function balanceOf(address owner) external view returns (uint256);
1083 
1084     function allowance(address owner, address spender)
1085         external
1086         view
1087         returns (uint256);
1088 
1089     function approve(address spender, uint256 value) external returns (bool);
1090 
1091     function transfer(address to, uint256 value) external returns (bool);
1092 
1093     function transferFrom(
1094         address from,
1095         address to,
1096         uint256 value
1097     ) external returns (bool);
1098 
1099     function DOMAIN_SEPARATOR() external view returns (bytes32);
1100 
1101     function PERMIT_TYPEHASH() external pure returns (bytes32);
1102 
1103     function nonces(address owner) external view returns (uint256);
1104 
1105     function permit(
1106         address owner,
1107         address spender,
1108         uint256 value,
1109         uint256 deadline,
1110         uint8 v,
1111         bytes32 r,
1112         bytes32 s
1113     ) external;
1114 
1115     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
1116     event Burn(
1117         address indexed sender,
1118         uint256 amount0,
1119         uint256 amount1,
1120         address indexed to
1121     );
1122     event Swap(
1123         address indexed sender,
1124         uint256 amount0In,
1125         uint256 amount1In,
1126         uint256 amount0Out,
1127         uint256 amount1Out,
1128         address indexed to
1129     );
1130     event Sync(uint112 reserve0, uint112 reserve1);
1131 
1132     function MINIMUM_LIQUIDITY() external pure returns (uint256);
1133 
1134     function factory() external view returns (address);
1135 
1136     function token0() external view returns (address);
1137 
1138     function token1() external view returns (address);
1139 
1140     function getReserves()
1141         external
1142         view
1143         returns (
1144             uint112 reserve0,
1145             uint112 reserve1,
1146             uint32 blockTimestampLast
1147         );
1148 
1149     function price0CumulativeLast() external view returns (uint256);
1150 
1151     function price1CumulativeLast() external view returns (uint256);
1152 
1153     function kLast() external view returns (uint256);
1154 
1155     function mint(address to) external returns (uint256 liquidity);
1156 
1157     function burn(address to)
1158         external
1159         returns (uint256 amount0, uint256 amount1);
1160 
1161     function swap(
1162         uint256 amount0Out,
1163         uint256 amount1Out,
1164         address to,
1165         bytes calldata data
1166     ) external;
1167 
1168     function skim(address to) external;
1169 
1170     function sync() external;
1171 
1172     function initialize(address, address) external;
1173 }
1174 
1175 ////// src/IUniswapV2Router02.sol
1176 /* pragma solidity 0.8.10; */
1177 /* pragma experimental ABIEncoderV2; */
1178 
1179 interface IUniswapV2Router02 {
1180     function factory() external pure returns (address);
1181 
1182     function WETH() external pure returns (address);
1183 
1184     function addLiquidity(
1185         address tokenA,
1186         address tokenB,
1187         uint256 amountADesired,
1188         uint256 amountBDesired,
1189         uint256 amountAMin,
1190         uint256 amountBMin,
1191         address to,
1192         uint256 deadline
1193     )
1194         external
1195         returns (
1196             uint256 amountA,
1197             uint256 amountB,
1198             uint256 liquidity
1199         );
1200 
1201     function addLiquidityETH(
1202         address token,
1203         uint256 amountTokenDesired,
1204         uint256 amountTokenMin,
1205         uint256 amountETHMin,
1206         address to,
1207         uint256 deadline
1208     )
1209         external
1210         payable
1211         returns (
1212             uint256 amountToken,
1213             uint256 amountETH,
1214             uint256 liquidity
1215         );
1216 
1217     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1218         uint256 amountIn,
1219         uint256 amountOutMin,
1220         address[] calldata path,
1221         address to,
1222         uint256 deadline
1223     ) external;
1224 
1225     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1226         uint256 amountOutMin,
1227         address[] calldata path,
1228         address to,
1229         uint256 deadline
1230     ) external payable;
1231 
1232     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1233         uint256 amountIn,
1234         uint256 amountOutMin,
1235         address[] calldata path,
1236         address to,
1237         uint256 deadline
1238     ) external;
1239 }
1240 
1241 contract SHIVA is Ownable, IERC20 {
1242     address UNISWAPROUTER = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1243     address DEAD = 0x000000000000000000000000000000000000dEaD;
1244     address ZERO = 0x0000000000000000000000000000000000000000;
1245 
1246     string private _name = "Shiba Validator";
1247     string private _symbol = "SHIVA";
1248 
1249     uint256 public treasuryFeeBPS = 1000;
1250     uint256 public liquidityFeeBPS = 1000;
1251     uint256 public boneFeeBPS = 1000;
1252     uint256 public totalFeeBPS = 3000;
1253 
1254     uint256 public treasurySellFeeBPS = 1000;
1255     uint256 public liquiditySellFeeBPS = 1000;
1256     uint256 public boneSellFeeBPS = 1000;
1257     uint256 public totalSellFeeBPS = 3000;
1258 
1259 
1260     uint256 public swapTokensAtAmount = 100000 * (10**18);
1261     uint256 public lastSwapTime;
1262     bool swapAllToken = true;
1263 
1264     bool public swapEnabled = true;
1265     bool public taxEnabled = true;
1266     bool public compoundingEnabled = true;
1267 
1268     uint256 private _totalSupply;
1269     bool private swapping;
1270 
1271     address public marketingWallet;
1272     address public boneWallet;
1273     address public liquidityWallet;
1274     address public boneTokenAddress;
1275 
1276     mapping(address => uint256) private _balances;
1277     mapping(address => mapping(address => uint256)) private _allowances;
1278     mapping(address => bool) private _isExcludedFromFees;
1279     mapping(address => bool) public automatedMarketMakerPairs;
1280     mapping(address => bool) private _whiteList;
1281     mapping(address => bool) isBlacklisted;
1282 
1283     event SwapAndAddLiquidity(
1284         uint256 tokensSwapped,
1285         uint256 nativeReceived,
1286         uint256 tokensIntoLiquidity
1287     );
1288     event SendDividends(uint256 tokensSwapped, uint256 amount);
1289     event ExcludeFromFees(address indexed account, bool isExcluded);
1290     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1291     event UpdateUniswapV2Router(
1292         address indexed newAddress,
1293         address indexed oldAddress
1294     );
1295     event SwapEnabled(bool enabled);
1296     event TaxEnabled(bool enabled);
1297     event CompoundingEnabled(bool enabled);
1298     event BlacklistEnabled(bool enabled);
1299 
1300     DividendTracker public dividendTracker;
1301     IUniswapV2Router02 public uniswapV2Router;
1302 
1303     address public uniswapV2Pair;
1304 
1305     uint256 public maxTxBPS = 51;
1306     uint256 public maxWalletBPS = 200;
1307 
1308     bool isOpen = false;
1309 
1310     mapping(address => bool) private _isExcludedFromMaxTx;
1311     mapping(address => bool) private _isExcludedFromMaxWallet;
1312 
1313     constructor(
1314         address _marketingWallet,
1315         address _liquidityWallet,
1316         address _boneWallet
1317     ) {
1318         marketingWallet = _marketingWallet;
1319         liquidityWallet = _liquidityWallet;
1320         boneWallet = _boneWallet;
1321 
1322         dividendTracker = new DividendTracker(address(this), UNISWAPROUTER);
1323 
1324         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(UNISWAPROUTER);
1325 
1326         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1327             .createPair(address(this), _uniswapV2Router.WETH());
1328 
1329         uniswapV2Router = _uniswapV2Router;
1330         uniswapV2Pair = _uniswapV2Pair;
1331 
1332         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1333 
1334         dividendTracker.excludeFromDividends(address(dividendTracker), true);
1335         dividendTracker.excludeFromDividends(address(this), true);
1336         dividendTracker.excludeFromDividends(owner(), true);
1337         dividendTracker.excludeFromDividends(address(_uniswapV2Router), true);
1338 
1339         excludeFromFees(owner(), true);
1340         excludeFromFees(address(this), true);
1341         excludeFromFees(address(dividendTracker), true);
1342 
1343         excludeFromMaxTx(owner(), true);
1344         excludeFromMaxTx(address(this), true);
1345         excludeFromMaxTx(address(dividendTracker), true);
1346 
1347         excludeFromMaxWallet(owner(), true);
1348         excludeFromMaxWallet(address(this), true);
1349         excludeFromMaxWallet(address(dividendTracker), true);
1350         boneTokenAddress = address(0x9813037ee2218799597d83D4a5B6F3b6778218d9); //mainnet
1351 
1352         _mint(marketingWallet, 400_000_000 * (10**18));
1353         _mint(owner(), 600_000_000 * (10**18));
1354     }
1355 
1356     receive() external payable {}
1357 
1358     function name() public view returns (string memory) {
1359         return _name;
1360     }
1361 
1362     function symbol() public view returns (string memory) {
1363         return _symbol;
1364     }
1365 
1366     function decimals() public pure returns (uint8) {
1367         return 18;
1368     }
1369 
1370     function totalSupply() public view virtual override returns (uint256) {
1371         return _totalSupply;
1372     }
1373 
1374     function balanceOf(address account)
1375         public
1376         view
1377         virtual
1378         override
1379         returns (uint256)
1380     {
1381         return _balances[account];
1382     }
1383 
1384     function allowance(address owner, address spender)
1385         public
1386         view
1387         virtual
1388         override
1389         returns (uint256)
1390     {
1391         return _allowances[owner][spender];
1392     }
1393 
1394     function approve(address spender, uint256 amount)
1395         public
1396         virtual
1397         override
1398         returns (bool)
1399     {
1400         _approve(_msgSender(), spender, amount);
1401         return true;
1402     }
1403 
1404     function increaseAllowance(address spender, uint256 addedValue)
1405         public
1406         returns (bool)
1407     {
1408         _approve(
1409             _msgSender(),
1410             spender,
1411             _allowances[_msgSender()][spender] + addedValue
1412         );
1413         return true;
1414     }
1415 
1416     function decreaseAllowance(address spender, uint256 subtractedValue)
1417         public
1418         returns (bool)
1419     {
1420         uint256 currentAllowance = _allowances[_msgSender()][spender];
1421         require(
1422             currentAllowance >= subtractedValue,
1423             "SHIVA: decreased allowance below zero"
1424         );
1425         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1426         return true;
1427     }
1428 
1429     function transfer(address recipient, uint256 amount)
1430         public
1431         virtual
1432         override
1433         returns (bool)
1434     {
1435         _transfer(_msgSender(), recipient, amount);
1436         return true;
1437     }
1438 
1439     function transferFrom(
1440         address sender,
1441         address recipient,
1442         uint256 amount
1443     ) public virtual override returns (bool) {
1444         _transfer(sender, recipient, amount);
1445         uint256 currentAllowance = _allowances[sender][_msgSender()];
1446         require(
1447             currentAllowance >= amount,
1448             "SHIVA: transfer amount exceeds allowance"
1449         );
1450         _approve(sender, _msgSender(), currentAllowance - amount);
1451         return true;
1452     }
1453 
1454     function openTrading() external onlyOwner {
1455         isOpen = true;
1456     }
1457 
1458     function _transfer(
1459         address sender,
1460         address recipient,
1461         uint256 amount
1462     ) internal {
1463         require(
1464             isOpen ||
1465                 sender == owner() ||
1466                 recipient == owner() ||
1467                 _whiteList[sender] ||
1468                 _whiteList[recipient],
1469             "Not Open"
1470         );
1471 
1472         require(!isBlacklisted[sender], "SHIVA: Sender is blacklisted");
1473         require(!isBlacklisted[recipient], "SHIVA: Recipient is blacklisted");
1474 
1475         require(sender != address(0), "SHIVA: transfer from the zero address");
1476         require(recipient != address(0), "SHIVA: transfer to the zero address");
1477 
1478         uint256 _maxTxAmount = (totalSupply() * maxTxBPS) / 10000;
1479         uint256 _maxWallet = (totalSupply() * maxWalletBPS) / 10000;
1480         require(
1481             amount <= _maxTxAmount || _isExcludedFromMaxTx[sender],
1482             "TX Limit Exceeded"
1483         );
1484 
1485         if (
1486             sender != owner() &&
1487             recipient != address(this) &&
1488             recipient != address(DEAD) &&
1489             recipient != uniswapV2Pair
1490         ) {
1491             uint256 currentBalance = balanceOf(recipient);
1492             require(
1493                 _isExcludedFromMaxWallet[recipient] ||
1494                     (currentBalance + amount <= _maxWallet)
1495             );
1496         }
1497 
1498         uint256 senderBalance = _balances[sender];
1499         require(
1500             senderBalance >= amount,
1501             "SHIVA: transfer amount exceeds balance"
1502         );
1503 
1504         uint256 contractTokenBalance = balanceOf(address(this));
1505         uint256 contractNativeBalance = address(this).balance;
1506 
1507         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1508 
1509         if (
1510             swapEnabled && // True
1511             canSwap && // true
1512             !swapping && // swapping=false !false true
1513             !automatedMarketMakerPairs[sender] && // no swap on remove liquidity step 1 or DEX buy
1514             sender != address(uniswapV2Router) && // no swap on remove liquidity step 2
1515             sender != owner() &&
1516             recipient != owner()
1517         ) {
1518             swapping = true;
1519 
1520             if (!swapAllToken) {
1521                 contractTokenBalance = swapTokensAtAmount;
1522             }
1523             _executeSwap(contractTokenBalance, contractNativeBalance);
1524 
1525             lastSwapTime = block.timestamp;
1526             swapping = false;
1527         }
1528 
1529         bool takeFee;
1530 
1531         if (
1532             sender == address(uniswapV2Pair) ||
1533             recipient == address(uniswapV2Pair)
1534         ) {
1535             takeFee = true;
1536         }
1537 
1538         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
1539             takeFee = false;
1540         }
1541 
1542         if (swapping || !taxEnabled) {
1543             takeFee = false;
1544         }
1545        
1546         // buy
1547         if (takeFee && sender == address(uniswapV2Pair)) {
1548             uint256 fees = (amount * totalFeeBPS) / 10000;
1549             amount -= fees;
1550             _executeTransfer(sender, address(this), fees);
1551         }
1552        
1553         // sell 
1554         if (takeFee && recipient == address(uniswapV2Pair)) {
1555             uint256 fees = (amount * totalSellFeeBPS) / 10000;
1556             amount -= fees;
1557             _executeTransfer(sender, address(this), fees);
1558         }
1559 
1560         _executeTransfer(sender, recipient, amount);
1561 
1562         dividendTracker.setBalance(payable(sender), balanceOf(sender));
1563         dividendTracker.setBalance(payable(recipient), balanceOf(recipient));
1564     }
1565 
1566     function _executeTransfer(
1567         address sender,
1568         address recipient,
1569         uint256 amount
1570     ) private {
1571         require(sender != address(0), "SHIVA: transfer from the zero address");
1572         require(recipient != address(0), "SHIVA: transfer to the zero address");
1573         uint256 senderBalance = _balances[sender];
1574         require(
1575             senderBalance >= amount,
1576             "SHIVA: transfer amount exceeds balance"
1577         );
1578         _balances[sender] = senderBalance - amount;
1579         _balances[recipient] += amount;
1580         emit Transfer(sender, recipient, amount);
1581     }
1582 
1583     function _approve(
1584         address owner,
1585         address spender,
1586         uint256 amount
1587     ) private {
1588         require(owner != address(0), "SHIVA: approve from the zero address");
1589         require(spender != address(0), "SHIVA: approve to the zero address");
1590         _allowances[owner][spender] = amount;
1591         emit Approval(owner, spender, amount);
1592     }
1593 
1594     function _mint(address account, uint256 amount) private {
1595         require(account != address(0), "SHIVA: mint to the zero address");
1596         _totalSupply += amount;
1597         _balances[account] += amount;
1598         emit Transfer(address(0), account, amount);
1599     }
1600 
1601     function _burn(address account, uint256 amount) private {
1602         require(account != address(0), "SHIVA: burn from the zero address");
1603         uint256 accountBalance = _balances[account];
1604         require(accountBalance >= amount, "SHIVA: burn amount exceeds balance");
1605         _balances[account] = accountBalance - amount;
1606         _totalSupply -= amount;
1607         emit Transfer(account, address(0), amount);
1608     }
1609 
1610     function swapTokensForNative(uint256 tokens) private {
1611         address[] memory path = new address[](2);
1612         path[0] = address(this);
1613         path[1] = uniswapV2Router.WETH();
1614         _approve(address(this), address(uniswapV2Router), tokens);
1615         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1616             tokens,
1617             0, // accept any amount of native
1618             path,
1619             address(this),
1620             block.timestamp
1621         );
1622     }
1623 
1624     function addLiquidity(uint256 tokens, uint256 native) private {
1625         _approve(address(this), address(uniswapV2Router), tokens);
1626         uniswapV2Router.addLiquidityETH{value: native}(
1627             address(this),
1628             tokens,
1629             0, // slippage unavoidable
1630             0, // slippage unavoidable
1631             liquidityWallet,
1632             block.timestamp
1633         );
1634     }
1635 
1636       function shivaBlast(uint256 ethAmountInWei, address BoneToken) internal {
1637         // generate the uniswap pair path of weth -> eth
1638         address[] memory path = new address[](2);
1639         path[0] = uniswapV2Router.WETH();
1640         path[1] = BoneToken;
1641 
1642         // make the swap
1643         uniswapV2Router.swapExactETHForTokensSupportingFeeOnTransferTokens{value: ethAmountInWei}(
1644             0, // accept any amount of Ethereum
1645             path,
1646             boneWallet,
1647             block.timestamp
1648         );
1649     }
1650 
1651     function _executeSwap(uint256 tokens, uint256 native) private {
1652         if (tokens <= 0) {
1653             return;
1654         }
1655 
1656         uint256 swapTokensMarketing;
1657         if (address(marketingWallet) != address(0) ) {
1658             swapTokensMarketing = (tokens * treasuryFeeBPS) / totalFeeBPS;
1659         }
1660 
1661         uint256 swapTokensBone;
1662         if (address(boneWallet) != address(0)) {
1663             swapTokensBone = (tokens * boneFeeBPS) / totalFeeBPS;
1664         }
1665 
1666         uint256 tokensForLiquidity = tokens -
1667             swapTokensMarketing -
1668             swapTokensBone;
1669         uint256 swapTokensLiquidity = tokensForLiquidity / 2;
1670         uint256 addTokensLiquidity = tokensForLiquidity - swapTokensLiquidity;
1671         uint256 swapTokensTotal = swapTokensMarketing + swapTokensLiquidity + swapTokensBone;
1672 
1673         uint256 initNativeBal = address(this).balance;
1674         swapTokensForNative(swapTokensTotal);
1675         uint256 nativeSwapped = (address(this).balance - initNativeBal) +
1676             native;
1677 
1678         uint256 nativeMarketing = (nativeSwapped * swapTokensMarketing) /
1679             swapTokensTotal;
1680         uint256 nativeBone = (nativeSwapped * swapTokensBone) /
1681             swapTokensTotal;
1682         uint256 nativeLiquidity = nativeSwapped -
1683             nativeMarketing -
1684             nativeBone;
1685 
1686         if (nativeMarketing > 0) {
1687             payable(marketingWallet).transfer(nativeMarketing);
1688         }
1689 
1690         if (nativeLiquidity > 0) {
1691           addLiquidity(addTokensLiquidity, nativeLiquidity);
1692          emit SwapAndAddLiquidity(
1693              swapTokensLiquidity,
1694              nativeLiquidity,
1695              addTokensLiquidity
1696          );
1697         }
1698 
1699         if (nativeBone > 0) {
1700             shivaBlast(nativeBone,boneTokenAddress);
1701         }
1702     }
1703 
1704     function excludeFromFees(address account, bool excluded) public onlyOwner {
1705         require(
1706             _isExcludedFromFees[account] != excluded,
1707             "SHIVA: account is already set to requested state"
1708         );
1709         _isExcludedFromFees[account] = excluded;
1710         emit ExcludeFromFees(account, excluded);
1711     }
1712 
1713     function isExcludedFromFees(address account) public view returns (bool) {
1714         return _isExcludedFromFees[account];
1715     }
1716 
1717     function manualSendDividend(uint256 amount, address holder)
1718         external
1719         onlyOwner
1720     {
1721         dividendTracker.manualSendDividend(amount, holder);
1722     }
1723 
1724     function excludeFromDividends(address account, bool excluded)
1725         public
1726         onlyOwner
1727     {
1728         dividendTracker.excludeFromDividends(account, excluded);
1729     }
1730 
1731     function isExcludedFromDividends(address account)
1732         public
1733         view
1734         returns (bool)
1735     {
1736         return dividendTracker.isExcludedFromDividends(account);
1737     }
1738 
1739     function setWallet(
1740         address payable _marketingWallet,
1741         address payable _liquidityWallet,
1742         address payable _boneWallet
1743     ) external onlyOwner {
1744         marketingWallet = _marketingWallet;
1745         liquidityWallet = _liquidityWallet;
1746         boneWallet = _boneWallet;
1747     }
1748 
1749     function setAutomatedMarketMakerPair(address pair, bool value)
1750         public
1751         onlyOwner
1752     {
1753         require(pair != uniswapV2Pair, "SHIVA: DEX pair can not be removed");
1754         _setAutomatedMarketMakerPair(pair, value);
1755     }
1756 
1757     function setFee(
1758         uint256 _treasuryFee,
1759         uint256 _liquidityFee,
1760         uint256 _boneFee,
1761         uint256 _sellTreasuryFee,
1762         uint256 _sellLiquidityFee,
1763         uint256 _sellBoneFee
1764     ) external onlyOwner {
1765         treasuryFeeBPS = _treasuryFee;
1766         liquidityFeeBPS = _liquidityFee;
1767         boneFeeBPS = _boneFee;
1768         totalFeeBPS = _treasuryFee + _liquidityFee + _boneFee;
1769 
1770         treasurySellFeeBPS = _sellTreasuryFee;
1771         liquiditySellFeeBPS = _sellLiquidityFee;
1772         boneSellFeeBPS = _sellBoneFee;
1773         totalSellFeeBPS = _sellTreasuryFee + _sellLiquidityFee + _sellBoneFee;
1774     }
1775 
1776     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1777         require(
1778             automatedMarketMakerPairs[pair] != value,
1779             "SHIVA: automated market maker pair is already set to that value"
1780         );
1781         automatedMarketMakerPairs[pair] = value;
1782         if (value) {
1783             dividendTracker.excludeFromDividends(pair, true);
1784         }
1785         emit SetAutomatedMarketMakerPair(pair, value);
1786     }
1787 
1788     function updateUniswapV2Router(address newAddress) public onlyOwner {
1789         require(
1790             newAddress != address(uniswapV2Router),
1791             "SHIVA: the router is already set to the new address"
1792         );
1793         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
1794         uniswapV2Router = IUniswapV2Router02(newAddress);
1795         address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
1796             .createPair(address(this), uniswapV2Router.WETH());
1797         uniswapV2Pair = _uniswapV2Pair;
1798     }
1799 
1800     function claim() public {
1801         dividendTracker.processAccount(payable(_msgSender()));
1802     }
1803 
1804     function compound() public {
1805         require(compoundingEnabled, "SHIVA: compounding is not enabled");
1806         dividendTracker.compoundAccount(payable(_msgSender()));
1807     }
1808 
1809     function withdrawableDividendOf(address account)
1810         public
1811         view
1812         returns (uint256)
1813     {
1814         return dividendTracker.withdrawableDividendOf(account);
1815     }
1816 
1817     function withdrawnDividendOf(address account)
1818         public
1819         view
1820         returns (uint256)
1821     {
1822         return dividendTracker.withdrawnDividendOf(account);
1823     }
1824 
1825     function accumulativeDividendOf(address account)
1826         public
1827         view
1828         returns (uint256)
1829     {
1830         return dividendTracker.accumulativeDividendOf(account);
1831     }
1832 
1833     function getAccountInfo(address account)
1834         public
1835         view
1836         returns (
1837             address,
1838             uint256,
1839             uint256,
1840             uint256,
1841             uint256
1842         )
1843     {
1844         return dividendTracker.getAccountInfo(account);
1845     }
1846 
1847     function getLastClaimTime(address account) public view returns (uint256) {
1848         return dividendTracker.getLastClaimTime(account);
1849     }
1850 
1851     function setSwapEnabled(bool _enabled) external onlyOwner {
1852         swapEnabled = _enabled;
1853         emit SwapEnabled(_enabled);
1854     }
1855 
1856     function setTaxEnabled(bool _enabled) external onlyOwner {
1857         taxEnabled = _enabled;
1858         emit TaxEnabled(_enabled);
1859     }
1860 
1861     function setCompoundingEnabled(bool _enabled) external onlyOwner {
1862         compoundingEnabled = _enabled;
1863         emit CompoundingEnabled(_enabled);
1864     }
1865 
1866     function updateDividendSettings(
1867         bool _swapEnabled,
1868         uint256 _swapTokensAtAmount,
1869         bool _swapAllToken
1870     ) external onlyOwner {
1871         swapEnabled = _swapEnabled;
1872         swapTokensAtAmount = _swapTokensAtAmount;
1873         swapAllToken = _swapAllToken;
1874     }
1875 
1876     function setMaxTxBPS(uint256 bps) external onlyOwner {
1877         require(bps >= 75 && bps <= 10000, "BPS must be between 75 and 10000");
1878         maxTxBPS = bps;
1879     }
1880 
1881     function excludeFromMaxTx(address account, bool excluded) public onlyOwner {
1882         _isExcludedFromMaxTx[account] = excluded;
1883     }
1884 
1885     function isExcludedFromMaxTx(address account) public view returns (bool) {
1886         return _isExcludedFromMaxTx[account];
1887     }
1888 
1889     function setMaxWalletBPS(uint256 bps) external onlyOwner {
1890         require(
1891             bps >= 175 && bps <= 10000,
1892             "BPS must be between 175 and 10000"
1893         );
1894         maxWalletBPS = bps;
1895     }
1896 
1897     function excludeFromMaxWallet(address account, bool excluded)
1898         public
1899         onlyOwner
1900     {
1901         _isExcludedFromMaxWallet[account] = excluded;
1902     }
1903 
1904     function isExcludedFromMaxWallet(address account)
1905         public
1906         view
1907         returns (bool)
1908     {
1909         return _isExcludedFromMaxWallet[account];
1910     }
1911 
1912     function returnToken(address _token, uint256 _amount) external onlyOwner {
1913         IERC20(_token).transfer(msg.sender, _amount);
1914     }
1915 
1916     function returnETH(uint256 _amount) external onlyOwner {
1917         payable(msg.sender).transfer(_amount);
1918     }
1919 
1920     function blackList(address _user) public onlyOwner {
1921         require(!isBlacklisted[_user], "user already blacklisted");
1922         isBlacklisted[_user] = true;
1923         // events?
1924     }
1925 
1926     function removeFromBlacklist(address _user) public onlyOwner {
1927         require(isBlacklisted[_user], "user already whitelisted");
1928         isBlacklisted[_user] = false;
1929         //events?
1930     }
1931 
1932     function blackListMany(address[] memory _users) public onlyOwner {
1933         for (uint8 i = 0; i < _users.length; i++) {
1934             isBlacklisted[_users[i]] = true;
1935         }
1936     }
1937 
1938     function unBlackListMany(address[] memory _users) public onlyOwner {
1939         for (uint8 i = 0; i < _users.length; i++) {
1940             isBlacklisted[_users[i]] = false;
1941         }
1942     }
1943 
1944   function setBoneTokenAddress(address _boneTokenAddress) external onlyOwner {
1945         require(_boneTokenAddress != address(0), "address cannot be 0");
1946         boneTokenAddress = _boneTokenAddress;
1947     }
1948 }
1949 
1950 contract DividendTracker is Ownable, IERC20 {
1951     address UNISWAPROUTER;
1952 
1953     string private _name = "SHIVA_Dividends";
1954     string private _symbol = "SHIVAD";
1955 
1956     uint256 public lastProcessedIndex;
1957 
1958     uint256 private _totalSupply;
1959     mapping(address => uint256) private _balances;
1960 
1961     uint256 private constant magnitude = 2**128;
1962     uint256 public immutable minTokenBalanceForDividends;
1963     uint256 private magnifiedDividendPerShare;
1964     uint256 public totalDividendsDistributed;
1965     uint256 public totalDividendsWithdrawn;
1966 
1967     address public tokenAddress;
1968 
1969     mapping(address => bool) public excludedFromDividends;
1970     mapping(address => int256) private magnifiedDividendCorrections;
1971     mapping(address => uint256) private withdrawnDividends;
1972     mapping(address => uint256) private lastClaimTimes;
1973 
1974     event DividendsDistributed(address indexed from, uint256 weiAmount);
1975     event DividendWithdrawn(address indexed to, uint256 weiAmount);
1976     event ExcludeFromDividends(address indexed account, bool excluded);
1977     event Claim(address indexed account, uint256 amount);
1978     event Compound(address indexed account, uint256 amount, uint256 tokens);
1979 
1980     struct AccountInfo {
1981         address account;
1982         uint256 withdrawableDividends;
1983         uint256 totalDividends;
1984         uint256 lastClaimTime;
1985     }
1986 
1987     constructor(address _tokenAddress, address _uniswapRouter) {
1988         minTokenBalanceForDividends = 10000 * (10**18);
1989         tokenAddress = _tokenAddress;
1990         UNISWAPROUTER = _uniswapRouter;
1991     }
1992 
1993     receive() external payable {
1994         distributeDividends();
1995     }
1996 
1997     function distributeDividends() public payable {
1998         require(_totalSupply > 0);
1999         if (msg.value > 0) {
2000             magnifiedDividendPerShare =
2001                 magnifiedDividendPerShare +
2002                 ((msg.value * magnitude) / _totalSupply);
2003             emit DividendsDistributed(msg.sender, msg.value);
2004             totalDividendsDistributed += msg.value;
2005         }
2006     }
2007 
2008     function setBalance(address payable account, uint256 newBalance)
2009         external
2010         onlyOwner
2011     {
2012         if (excludedFromDividends[account]) {
2013             return;
2014         }
2015         if (newBalance >= minTokenBalanceForDividends) {
2016             _setBalance(account, newBalance);
2017         } else {
2018             _setBalance(account, 0);
2019         }
2020     }
2021 
2022     function excludeFromDividends(address account, bool excluded)
2023         external
2024         onlyOwner
2025     {
2026         require(
2027             excludedFromDividends[account] != excluded,
2028             "SHIVA_DividendTracker: account already set to requested state"
2029         );
2030         excludedFromDividends[account] = excluded;
2031         if (excluded) {
2032             _setBalance(account, 0);
2033         } else {
2034             uint256 newBalance = IERC20(tokenAddress).balanceOf(account);
2035             if (newBalance >= minTokenBalanceForDividends) {
2036                 _setBalance(account, newBalance);
2037             } else {
2038                 _setBalance(account, 0);
2039             }
2040         }
2041         emit ExcludeFromDividends(account, excluded);
2042     }
2043 
2044     function isExcludedFromDividends(address account)
2045         public
2046         view
2047         returns (bool)
2048     {
2049         return excludedFromDividends[account];
2050     }
2051 
2052     function manualSendDividend(uint256 amount, address holder)
2053         external
2054         onlyOwner
2055     {
2056         uint256 contractETHBalance = address(this).balance;
2057         payable(holder).transfer(amount > 0 ? amount : contractETHBalance);
2058     }
2059 
2060     function _setBalance(address account, uint256 newBalance) internal {
2061         uint256 currentBalance = _balances[account];
2062         if (newBalance > currentBalance) {
2063             uint256 addAmount = newBalance - currentBalance;
2064             _mint(account, addAmount);
2065         } else if (newBalance < currentBalance) {
2066             uint256 subAmount = currentBalance - newBalance;
2067             _burn(account, subAmount);
2068         }
2069     }
2070 
2071     function _mint(address account, uint256 amount) private {
2072         require(
2073             account != address(0),
2074             "SHIVA_DividendTracker: mint to the zero address"
2075         );
2076         _totalSupply += amount;
2077         _balances[account] += amount;
2078         emit Transfer(address(0), account, amount);
2079         magnifiedDividendCorrections[account] =
2080             magnifiedDividendCorrections[account] -
2081             int256(magnifiedDividendPerShare * amount);
2082     }
2083 
2084     function _burn(address account, uint256 amount) private {
2085         require(
2086             account != address(0),
2087             "SHIVA_DividendTracker: burn from the zero address"
2088         );
2089         uint256 accountBalance = _balances[account];
2090         require(
2091             accountBalance >= amount,
2092             "SHIVA_DividendTracker: burn amount exceeds balance"
2093         );
2094         _balances[account] = accountBalance - amount;
2095         _totalSupply -= amount;
2096         emit Transfer(account, address(0), amount);
2097         magnifiedDividendCorrections[account] =
2098             magnifiedDividendCorrections[account] +
2099             int256(magnifiedDividendPerShare * amount);
2100     }
2101 
2102     function processAccount(address payable account)
2103         public
2104         onlyOwner
2105         returns (bool)
2106     {
2107         uint256 amount = _withdrawDividendOfUser(account);
2108         if (amount > 0) {
2109             lastClaimTimes[account] = block.timestamp;
2110             emit Claim(account, amount);
2111             return true;
2112         }
2113         return false;
2114     }
2115 
2116     function _withdrawDividendOfUser(address payable account)
2117         private
2118         returns (uint256)
2119     {
2120         uint256 _withdrawableDividend = withdrawableDividendOf(account);
2121         if (_withdrawableDividend > 0) {
2122             withdrawnDividends[account] += _withdrawableDividend;
2123             totalDividendsWithdrawn += _withdrawableDividend;
2124             emit DividendWithdrawn(account, _withdrawableDividend);
2125             (bool success, ) = account.call{
2126                 value: _withdrawableDividend,
2127                 gas: 3000
2128             }("");
2129             if (!success) {
2130                 withdrawnDividends[account] -= _withdrawableDividend;
2131                 totalDividendsWithdrawn -= _withdrawableDividend;
2132                 return 0;
2133             }
2134             return _withdrawableDividend;
2135         }
2136         return 0;
2137     }
2138 
2139     function compoundAccount(address payable account)
2140         public
2141         onlyOwner
2142         returns (bool)
2143     {
2144         (uint256 amount, uint256 tokens) = _compoundDividendOfUser(account);
2145         if (amount > 0) {
2146             lastClaimTimes[account] = block.timestamp;
2147             emit Compound(account, amount, tokens);
2148             return true;
2149         }
2150         return false;
2151     }
2152 
2153     function _compoundDividendOfUser(address payable account)
2154         private
2155         returns (uint256, uint256)
2156     {
2157         uint256 _withdrawableDividend = withdrawableDividendOf(account);
2158         if (_withdrawableDividend > 0) {
2159             withdrawnDividends[account] += _withdrawableDividend;
2160             totalDividendsWithdrawn += _withdrawableDividend;
2161             emit DividendWithdrawn(account, _withdrawableDividend);
2162 
2163             IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(
2164                 UNISWAPROUTER
2165             );
2166 
2167             address[] memory path = new address[](2);
2168             path[0] = uniswapV2Router.WETH();
2169             path[1] = address(tokenAddress);
2170 
2171             bool success;
2172             uint256 tokens;
2173 
2174             uint256 initTokenBal = IERC20(tokenAddress).balanceOf(account);
2175             try
2176                 uniswapV2Router
2177                     .swapExactETHForTokensSupportingFeeOnTransferTokens{
2178                     value: _withdrawableDividend
2179                 }(0, path, address(account), block.timestamp)
2180             {
2181                 success = true;
2182                 tokens = IERC20(tokenAddress).balanceOf(account) - initTokenBal;
2183             } catch Error(
2184                 string memory /*err*/
2185             ) {
2186                 success = false;
2187             }
2188 
2189             if (!success) {
2190                 withdrawnDividends[account] -= _withdrawableDividend;
2191                 totalDividendsWithdrawn -= _withdrawableDividend;
2192                 return (0, 0);
2193             }
2194 
2195             return (_withdrawableDividend, tokens);
2196         }
2197         return (0, 0);
2198     }
2199 
2200     function withdrawableDividendOf(address account)
2201         public
2202         view
2203         returns (uint256)
2204     {
2205         return accumulativeDividendOf(account) - withdrawnDividends[account];
2206     }
2207 
2208     function withdrawnDividendOf(address account)
2209         public
2210         view
2211         returns (uint256)
2212     {
2213         return withdrawnDividends[account];
2214     }
2215 
2216     function accumulativeDividendOf(address account)
2217         public
2218         view
2219         returns (uint256)
2220     {
2221         int256 a = int256(magnifiedDividendPerShare * balanceOf(account));
2222         int256 b = magnifiedDividendCorrections[account]; // this is an explicit int256 (signed)
2223         return uint256(a + b) / magnitude;
2224     }
2225 
2226     function getAccountInfo(address account)
2227         public
2228         view
2229         returns (
2230             address,
2231             uint256,
2232             uint256,
2233             uint256,
2234             uint256
2235         )
2236     {
2237         AccountInfo memory info;
2238         info.account = account;
2239         info.withdrawableDividends = withdrawableDividendOf(account);
2240         info.totalDividends = accumulativeDividendOf(account);
2241         info.lastClaimTime = lastClaimTimes[account];
2242         return (
2243             info.account,
2244             info.withdrawableDividends,
2245             info.totalDividends,
2246             info.lastClaimTime,
2247             totalDividendsWithdrawn
2248         );
2249     }
2250 
2251     function getLastClaimTime(address account) public view returns (uint256) {
2252         return lastClaimTimes[account];
2253     }
2254 
2255     function name() public view returns (string memory) {
2256         return _name;
2257     }
2258 
2259     function symbol() public view returns (string memory) {
2260         return _symbol;
2261     }
2262 
2263     function decimals() public pure returns (uint8) {
2264         return 18;
2265     }
2266 
2267     function totalSupply() public view override returns (uint256) {
2268         return _totalSupply;
2269     }
2270 
2271     function balanceOf(address account) public view override returns (uint256) {
2272         return _balances[account];
2273     }
2274 
2275     function transfer(address, uint256) public pure override returns (bool) {
2276         revert("SHIVA_DividendTracker: method not implemented");
2277     }
2278 
2279     function allowance(address, address)
2280         public
2281         pure
2282         override
2283         returns (uint256)
2284     {
2285         revert("SHIVA_DividendTracker: method not implemented");
2286     }
2287 
2288     function approve(address, uint256) public pure override returns (bool) {
2289         revert("SHIVA_DividendTracker: method not implemented");
2290     }
2291 
2292     function transferFrom(
2293         address,
2294         address,
2295         uint256
2296     ) public pure override returns (bool) {
2297         revert("SHIVA_DividendTracker: method not implemented");
2298     }
2299 
2300 }