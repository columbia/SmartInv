1 // hevm: flattened sources of src/stackt.sol
2 // SPDX-License-Identifier: MIT
3 pragma solidity =0.8.10 >=0.8.0 <0.9.0;
4 pragma experimental ABIEncoderV2;
5 
6 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
7 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
8 
9 /* pragma solidity ^0.8.0; */
10 
11 /**
12  * @dev Provides information about the current execution context, including the
13  * sender of the transaction and its data. While these are generally available
14  * via msg.sender and msg.data, they should not be accessed in such a direct
15  * manner, since when dealing with meta-transactions the account sending and
16  * paying for execution may not be the actual sender (as far as an application
17  * is concerned).
18  *
19  * This contract is only required for intermediate, library-like contracts.
20  */
21 abstract contract Context {
22     function _msgSender() internal view virtual returns (address) {
23         return msg.sender;
24     }
25 
26     function _msgData() internal view virtual returns (bytes calldata) {
27         return msg.data;
28     }
29 }
30 
31 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
32 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
33 
34 /* pragma solidity ^0.8.0; */
35 
36 /* import "../utils/Context.sol"; */
37 
38 /**
39  * @dev Contract module which provides a basic access control mechanism, where
40  * there is an account (an owner) that can be granted exclusive access to
41  * specific functions.
42  *
43  * By default, the owner account will be the one that deploys the contract. This
44  * can later be changed with {transferOwnership}.
45  *
46  * This module is used through inheritance. It will make available the modifier
47  * `onlyOwner`, which can be applied to your functions to restrict their use to
48  * the owner.
49  */
50 abstract contract Ownable is Context {
51     address private _owner;
52 
53     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
54 
55     /**
56      * @dev Initializes the contract setting the deployer as the initial owner.
57      */
58     constructor() {
59         _transferOwnership(_msgSender());
60     }
61 
62     /**
63      * @dev Returns the address of the current owner.
64      */
65     function owner() public view virtual returns (address) {
66         return _owner;
67     }
68 
69     /**
70      * @dev Throws if called by any account other than the owner.
71      */
72     modifier onlyOwner() {
73         require(owner() == _msgSender(), "Ownable: caller is not the owner");
74         _;
75     }
76 
77     /**
78      * @dev Leaves the contract without owner. It will not be possible to call
79      * `onlyOwner` functions anymore. Can only be called by the current owner.
80      *
81      * NOTE: Renouncing ownership will leave the contract without an owner,
82      * thereby removing any functionality that is only available to the owner.
83      */
84     function renounceOwnership() public virtual onlyOwner {
85         _transferOwnership(address(0));
86     }
87 
88     /**
89      * @dev Transfers ownership of the contract to a new account (`newOwner`).
90      * Can only be called by the current owner.
91      */
92     function transferOwnership(address newOwner) public virtual onlyOwner {
93         require(newOwner != address(0), "Ownable: new owner is the zero address");
94         _transferOwnership(newOwner);
95     }
96 
97     /**
98      * @dev Transfers ownership of the contract to a new account (`newOwner`).
99      * Internal function without access restriction.
100      */
101     function _transferOwnership(address newOwner) internal virtual {
102         address oldOwner = _owner;
103         _owner = newOwner;
104         emit OwnershipTransferred(oldOwner, newOwner);
105     }
106 }
107 
108 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
109 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
110 
111 /* pragma solidity ^0.8.0; */
112 
113 /**
114  * @dev Interface of the ERC20 standard as defined in the EIP.
115  */
116 interface IERC20 {
117     /**
118      * @dev Returns the amount of tokens in existence.
119      */
120     function totalSupply() external view returns (uint256);
121 
122     /**
123      * @dev Returns the amount of tokens owned by `account`.
124      */
125     function balanceOf(address account) external view returns (uint256);
126 
127     /**
128      * @dev Moves `amount` tokens from the caller's account to `recipient`.
129      *
130      * Returns a boolean value indicating whether the operation succeeded.
131      *
132      * Emits a {Transfer} event.
133      */
134     function transfer(address recipient, uint256 amount) external returns (bool);
135 
136     /**
137      * @dev Returns the remaining number of tokens that `spender` will be
138      * allowed to spend on behalf of `owner` through {transferFrom}. This is
139      * zero by default.
140      *
141      * This value changes when {approve} or {transferFrom} are called.
142      */
143     function allowance(address owner, address spender) external view returns (uint256);
144 
145     /**
146      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
147      *
148      * Returns a boolean value indicating whether the operation succeeded.
149      *
150      * IMPORTANT: Beware that changing an allowance with this method brings the risk
151      * that someone may use both the old and the new allowance by unfortunate
152      * transaction ordering. One possible solution to mitigate this race
153      * condition is to first reduce the spender's allowance to 0 and set the
154      * desired value afterwards:
155      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
156      *
157      * Emits an {Approval} event.
158      */
159     function approve(address spender, uint256 amount) external returns (bool);
160 
161     /**
162      * @dev Moves `amount` tokens from `sender` to `recipient` using the
163      * allowance mechanism. `amount` is then deducted from the caller's
164      * allowance.
165      *
166      * Returns a boolean value indicating whether the operation succeeded.
167      *
168      * Emits a {Transfer} event.
169      */
170     function transferFrom(
171         address sender,
172         address recipient,
173         uint256 amount
174     ) external returns (bool);
175 
176     /**
177      * @dev Emitted when `value` tokens are moved from one account (`from`) to
178      * another (`to`).
179      *
180      * Note that `value` may be zero.
181      */
182     event Transfer(address indexed from, address indexed to, uint256 value);
183 
184     /**
185      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
186      * a call to {approve}. `value` is the new allowance.
187      */
188     event Approval(address indexed owner, address indexed spender, uint256 value);
189 }
190 
191 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
192 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
193 
194 /* pragma solidity ^0.8.0; */
195 
196 /* import "../IERC20.sol"; */
197 
198 /**
199  * @dev Interface for the optional metadata functions from the ERC20 standard.
200  *
201  * _Available since v4.1._
202  */
203 interface IERC20Metadata is IERC20 {
204     /**
205      * @dev Returns the name of the token.
206      */
207     function name() external view returns (string memory);
208 
209     /**
210      * @dev Returns the symbol of the token.
211      */
212     function symbol() external view returns (string memory);
213 
214     /**
215      * @dev Returns the decimals places of the token.
216      */
217     function decimals() external view returns (uint8);
218 }
219 
220 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
221 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
222 
223 /* pragma solidity ^0.8.0; */
224 
225 /* import "./IERC20.sol"; */
226 /* import "./extensions/IERC20Metadata.sol"; */
227 /* import "../../utils/Context.sol"; */
228 
229 /**
230  * @dev Implementation of the {IERC20} interface.
231  *
232  * This implementation is agnostic to the way tokens are created. This means
233  * that a supply mechanism has to be added in a derived contract using {_mint}.
234  * For a generic mechanism see {ERC20PresetMinterPauser}.
235  *
236  * TIP: For a detailed writeup see our guide
237  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
238  * to implement supply mechanisms].
239  *
240  * We have followed general OpenZeppelin Contracts guidelines: functions revert
241  * instead returning `false` on failure. This behavior is nonetheless
242  * conventional and does not conflict with the expectations of ERC20
243  * applications.
244  *
245  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
246  * This allows applications to reconstruct the allowance for all accounts just
247  * by listening to said events. Other implementations of the EIP may not emit
248  * these events, as it isn't required by the specification.
249  *
250  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
251  * functions have been added to mitigate the well-known issues around setting
252  * allowances. See {IERC20-approve}.
253  */
254 contract ERC20 is Context, IERC20, IERC20Metadata {
255     mapping(address => uint256) private _balances;
256 
257     mapping(address => mapping(address => uint256)) private _allowances;
258 
259     uint256 private _totalSupply;
260 
261     string private _name;
262     string private _symbol;
263 
264     /**
265      * @dev Sets the values for {name} and {symbol}.
266      *
267      * The default value of {decimals} is 18. To select a different value for
268      * {decimals} you should overload it.
269      *
270      * All two of these values are immutable: they can only be set once during
271      * construction.
272      */
273     constructor(string memory name_, string memory symbol_) {
274         _name = name_;
275         _symbol = symbol_;
276     }
277 
278     /**
279      * @dev Returns the name of the token.
280      */
281     function name() public view virtual override returns (string memory) {
282         return _name;
283     }
284 
285     /**
286      * @dev Returns the symbol of the token, usually a shorter version of the
287      * name.
288      */
289     function symbol() public view virtual override returns (string memory) {
290         return _symbol;
291     }
292 
293     /**
294      * @dev Returns the number of decimals used to get its user representation.
295      * For example, if `decimals` equals `2`, a balance of `505` tokens should
296      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
297      *
298      * Tokens usually opt for a value of 18, imitating the relationship between
299      * Ether and Wei. This is the value {ERC20} uses, unless this function is
300      * overridden;
301      *
302      * NOTE: This information is only used for _display_ purposes: it in
303      * no way affects any of the arithmetic of the contract, including
304      * {IERC20-balanceOf} and {IERC20-transfer}.
305      */
306     function decimals() public view virtual override returns (uint8) {
307         return 18;
308     }
309 
310     /**
311      * @dev See {IERC20-totalSupply}.
312      */
313     function totalSupply() public view virtual override returns (uint256) {
314         return _totalSupply;
315     }
316 
317     /**
318      * @dev See {IERC20-balanceOf}.
319      */
320     function balanceOf(address account) public view virtual override returns (uint256) {
321         return _balances[account];
322     }
323 
324     /**
325      * @dev See {IERC20-transfer}.
326      *
327      * Requirements:
328      *
329      * - `recipient` cannot be the zero address.
330      * - the caller must have a balance of at least `amount`.
331      */
332     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
333         _transfer(_msgSender(), recipient, amount);
334         return true;
335     }
336 
337     /**
338      * @dev See {IERC20-allowance}.
339      */
340     function allowance(address owner, address spender) public view virtual override returns (uint256) {
341         return _allowances[owner][spender];
342     }
343 
344     /**
345      * @dev See {IERC20-approve}.
346      *
347      * Requirements:
348      *
349      * - `spender` cannot be the zero address.
350      */
351     function approve(address spender, uint256 amount) public virtual override returns (bool) {
352         _approve(_msgSender(), spender, amount);
353         return true;
354     }
355 
356     /**
357      * @dev See {IERC20-transferFrom}.
358      *
359      * Emits an {Approval} event indicating the updated allowance. This is not
360      * required by the EIP. See the note at the beginning of {ERC20}.
361      *
362      * Requirements:
363      *
364      * - `sender` and `recipient` cannot be the zero address.
365      * - `sender` must have a balance of at least `amount`.
366      * - the caller must have allowance for ``sender``'s tokens of at least
367      * `amount`.
368      */
369     function transferFrom(
370         address sender,
371         address recipient,
372         uint256 amount
373     ) public virtual override returns (bool) {
374         _transfer(sender, recipient, amount);
375 
376         uint256 currentAllowance = _allowances[sender][_msgSender()];
377         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
378         unchecked {
379             _approve(sender, _msgSender(), currentAllowance - amount);
380         }
381 
382         return true;
383     }
384 
385     /**
386      * @dev Atomically increases the allowance granted to `spender` by the caller.
387      *
388      * This is an alternative to {approve} that can be used as a mitigation for
389      * problems described in {IERC20-approve}.
390      *
391      * Emits an {Approval} event indicating the updated allowance.
392      *
393      * Requirements:
394      *
395      * - `spender` cannot be the zero address.
396      */
397     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
398         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
399         return true;
400     }
401 
402     /**
403      * @dev Atomically decreases the allowance granted to `spender` by the caller.
404      *
405      * This is an alternative to {approve} that can be used as a mitigation for
406      * problems described in {IERC20-approve}.
407      *
408      * Emits an {Approval} event indicating the updated allowance.
409      *
410      * Requirements:
411      *
412      * - `spender` cannot be the zero address.
413      * - `spender` must have allowance for the caller of at least
414      * `subtractedValue`.
415      */
416     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
417         uint256 currentAllowance = _allowances[_msgSender()][spender];
418         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
419         unchecked {
420             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
421         }
422 
423         return true;
424     }
425 
426     /**
427      * @dev Moves `amount` of tokens from `sender` to `recipient`.
428      *
429      * This internal function is equivalent to {transfer}, and can be used to
430      * e.g. implement automatic token fees, slashing mechanisms, etc.
431      *
432      * Emits a {Transfer} event.
433      *
434      * Requirements:
435      *
436      * - `sender` cannot be the zero address.
437      * - `recipient` cannot be the zero address.
438      * - `sender` must have a balance of at least `amount`.
439      */
440     function _transfer(
441         address sender,
442         address recipient,
443         uint256 amount
444     ) internal virtual {
445         require(sender != address(0), "ERC20: transfer from the zero address");
446         require(recipient != address(0), "ERC20: transfer to the zero address");
447 
448         _beforeTokenTransfer(sender, recipient, amount);
449 
450         uint256 senderBalance = _balances[sender];
451         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
452         unchecked {
453             _balances[sender] = senderBalance - amount;
454         }
455         _balances[recipient] += amount;
456 
457         emit Transfer(sender, recipient, amount);
458 
459         _afterTokenTransfer(sender, recipient, amount);
460     }
461 
462     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
463      * the total supply.
464      *
465      * Emits a {Transfer} event with `from` set to the zero address.
466      *
467      * Requirements:
468      *
469      * - `account` cannot be the zero address.
470      */
471     function _mint(address account, uint256 amount) internal virtual {
472         require(account != address(0), "ERC20: mint to the zero address");
473 
474         _beforeTokenTransfer(address(0), account, amount);
475 
476         _totalSupply += amount;
477         _balances[account] += amount;
478         emit Transfer(address(0), account, amount);
479 
480         _afterTokenTransfer(address(0), account, amount);
481     }
482 
483     /**
484      * @dev Destroys `amount` tokens from `account`, reducing the
485      * total supply.
486      *
487      * Emits a {Transfer} event with `to` set to the zero address.
488      *
489      * Requirements:
490      *
491      * - `account` cannot be the zero address.
492      * - `account` must have at least `amount` tokens.
493      */
494     function _burn(address account, uint256 amount) internal virtual {
495         require(account != address(0), "ERC20: burn from the zero address");
496 
497         _beforeTokenTransfer(account, address(0), amount);
498 
499         uint256 accountBalance = _balances[account];
500         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
501         unchecked {
502             _balances[account] = accountBalance - amount;
503         }
504         _totalSupply -= amount;
505 
506         emit Transfer(account, address(0), amount);
507 
508         _afterTokenTransfer(account, address(0), amount);
509     }
510 
511     /**
512      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
513      *
514      * This internal function is equivalent to `approve`, and can be used to
515      * e.g. set automatic allowances for certain subsystems, etc.
516      *
517      * Emits an {Approval} event.
518      *
519      * Requirements:
520      *
521      * - `owner` cannot be the zero address.
522      * - `spender` cannot be the zero address.
523      */
524     function _approve(
525         address owner,
526         address spender,
527         uint256 amount
528     ) internal virtual {
529         require(owner != address(0), "ERC20: approve from the zero address");
530         require(spender != address(0), "ERC20: approve to the zero address");
531 
532         _allowances[owner][spender] = amount;
533         emit Approval(owner, spender, amount);
534     }
535 
536     /**
537      * @dev Hook that is called before any transfer of tokens. This includes
538      * minting and burning.
539      *
540      * Calling conditions:
541      *
542      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
543      * will be transferred to `to`.
544      * - when `from` is zero, `amount` tokens will be minted for `to`.
545      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
546      * - `from` and `to` are never both zero.
547      *
548      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
549      */
550     function _beforeTokenTransfer(
551         address from,
552         address to,
553         uint256 amount
554     ) internal virtual {}
555 
556     /**
557      * @dev Hook that is called after any transfer of tokens. This includes
558      * minting and burning.
559      *
560      * Calling conditions:
561      *
562      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
563      * has been transferred to `to`.
564      * - when `from` is zero, `amount` tokens have been minted for `to`.
565      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
566      * - `from` and `to` are never both zero.
567      *
568      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
569      */
570     function _afterTokenTransfer(
571         address from,
572         address to,
573         uint256 amount
574     ) internal virtual {}
575 }
576 
577 ////// lib/openzeppelin-contracts/contracts/utils/Address.sol
578 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
579 
580 /* pragma solidity ^0.8.0; */
581 
582 /**
583  * @dev Collection of functions related to the address type
584  */
585 library Address {
586     /**
587      * @dev Returns true if `account` is a contract.
588      *
589      * [IMPORTANT]
590      * ====
591      * It is unsafe to assume that an address for which this function returns
592      * false is an externally-owned account (EOA) and not a contract.
593      *
594      * Among others, `isContract` will return false for the following
595      * types of addresses:
596      *
597      *  - an externally-owned account
598      *  - a contract in construction
599      *  - an address where a contract will be created
600      *  - an address where a contract lived, but was destroyed
601      * ====
602      */
603     function isContract(address account) internal view returns (bool) {
604         // This method relies on extcodesize, which returns 0 for contracts in
605         // construction, since the code is only stored at the end of the
606         // constructor execution.
607 
608         uint256 size;
609         assembly {
610             size := extcodesize(account)
611         }
612         return size > 0;
613     }
614 
615     /**
616      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
617      * `recipient`, forwarding all available gas and reverting on errors.
618      *
619      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
620      * of certain opcodes, possibly making contracts go over the 2300 gas limit
621      * imposed by `transfer`, making them unable to receive funds via
622      * `transfer`. {sendValue} removes this limitation.
623      *
624      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
625      *
626      * IMPORTANT: because control is transferred to `recipient`, care must be
627      * taken to not create reentrancy vulnerabilities. Consider using
628      * {ReentrancyGuard} or the
629      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
630      */
631     function sendValue(address payable recipient, uint256 amount) internal {
632         require(address(this).balance >= amount, "Address: insufficient balance");
633 
634         (bool success, ) = recipient.call{value: amount}("");
635         require(success, "Address: unable to send value, recipient may have reverted");
636     }
637 
638     /**
639      * @dev Performs a Solidity function call using a low level `call`. A
640      * plain `call` is an unsafe replacement for a function call: use this
641      * function instead.
642      *
643      * If `target` reverts with a revert reason, it is bubbled up by this
644      * function (like regular Solidity function calls).
645      *
646      * Returns the raw returned data. To convert to the expected return value,
647      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
648      *
649      * Requirements:
650      *
651      * - `target` must be a contract.
652      * - calling `target` with `data` must not revert.
653      *
654      * _Available since v3.1._
655      */
656     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
657         return functionCall(target, data, "Address: low-level call failed");
658     }
659 
660     /**
661      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
662      * `errorMessage` as a fallback revert reason when `target` reverts.
663      *
664      * _Available since v3.1._
665      */
666     function functionCall(
667         address target,
668         bytes memory data,
669         string memory errorMessage
670     ) internal returns (bytes memory) {
671         return functionCallWithValue(target, data, 0, errorMessage);
672     }
673 
674     /**
675      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
676      * but also transferring `value` wei to `target`.
677      *
678      * Requirements:
679      *
680      * - the calling contract must have an ETH balance of at least `value`.
681      * - the called Solidity function must be `payable`.
682      *
683      * _Available since v3.1._
684      */
685     function functionCallWithValue(
686         address target,
687         bytes memory data,
688         uint256 value
689     ) internal returns (bytes memory) {
690         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
691     }
692 
693     /**
694      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
695      * with `errorMessage` as a fallback revert reason when `target` reverts.
696      *
697      * _Available since v3.1._
698      */
699     function functionCallWithValue(
700         address target,
701         bytes memory data,
702         uint256 value,
703         string memory errorMessage
704     ) internal returns (bytes memory) {
705         require(address(this).balance >= value, "Address: insufficient balance for call");
706         require(isContract(target), "Address: call to non-contract");
707 
708         (bool success, bytes memory returndata) = target.call{value: value}(data);
709         return verifyCallResult(success, returndata, errorMessage);
710     }
711 
712     /**
713      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
714      * but performing a static call.
715      *
716      * _Available since v3.3._
717      */
718     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
719         return functionStaticCall(target, data, "Address: low-level static call failed");
720     }
721 
722     /**
723      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
724      * but performing a static call.
725      *
726      * _Available since v3.3._
727      */
728     function functionStaticCall(
729         address target,
730         bytes memory data,
731         string memory errorMessage
732     ) internal view returns (bytes memory) {
733         require(isContract(target), "Address: static call to non-contract");
734 
735         (bool success, bytes memory returndata) = target.staticcall(data);
736         return verifyCallResult(success, returndata, errorMessage);
737     }
738 
739     /**
740      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
741      * but performing a delegate call.
742      *
743      * _Available since v3.4._
744      */
745     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
746         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
747     }
748 
749     /**
750      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
751      * but performing a delegate call.
752      *
753      * _Available since v3.4._
754      */
755     function functionDelegateCall(
756         address target,
757         bytes memory data,
758         string memory errorMessage
759     ) internal returns (bytes memory) {
760         require(isContract(target), "Address: delegate call to non-contract");
761 
762         (bool success, bytes memory returndata) = target.delegatecall(data);
763         return verifyCallResult(success, returndata, errorMessage);
764     }
765 
766     /**
767      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
768      * revert reason using the provided one.
769      *
770      * _Available since v4.3._
771      */
772     function verifyCallResult(
773         bool success,
774         bytes memory returndata,
775         string memory errorMessage
776     ) internal pure returns (bytes memory) {
777         if (success) {
778             return returndata;
779         } else {
780             // Look for revert reason and bubble it up if present
781             if (returndata.length > 0) {
782                 // The easiest way to bubble the revert reason is using memory via assembly
783 
784                 assembly {
785                     let returndata_size := mload(returndata)
786                     revert(add(32, returndata), returndata_size)
787                 }
788             } else {
789                 revert(errorMessage);
790             }
791         }
792     }
793 }
794 
795 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
796 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
797 
798 /* pragma solidity ^0.8.0; */
799 
800 // CAUTION
801 // This version of SafeMath should only be used with Solidity 0.8 or later,
802 // because it relies on the compiler's built in overflow checks.
803 
804 /**
805  * @dev Wrappers over Solidity's arithmetic operations.
806  *
807  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
808  * now has built in overflow checking.
809  */
810 library SafeMath {
811     /**
812      * @dev Returns the addition of two unsigned integers, with an overflow flag.
813      *
814      * _Available since v3.4._
815      */
816     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
817         unchecked {
818             uint256 c = a + b;
819             if (c < a) return (false, 0);
820             return (true, c);
821         }
822     }
823 
824     /**
825      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
826      *
827      * _Available since v3.4._
828      */
829     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
830         unchecked {
831             if (b > a) return (false, 0);
832             return (true, a - b);
833         }
834     }
835 
836     /**
837      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
838      *
839      * _Available since v3.4._
840      */
841     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
842         unchecked {
843             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
844             // benefit is lost if 'b' is also tested.
845             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
846             if (a == 0) return (true, 0);
847             uint256 c = a * b;
848             if (c / a != b) return (false, 0);
849             return (true, c);
850         }
851     }
852 
853     /**
854      * @dev Returns the division of two unsigned integers, with a division by zero flag.
855      *
856      * _Available since v3.4._
857      */
858     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
859         unchecked {
860             if (b == 0) return (false, 0);
861             return (true, a / b);
862         }
863     }
864 
865     /**
866      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
867      *
868      * _Available since v3.4._
869      */
870     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
871         unchecked {
872             if (b == 0) return (false, 0);
873             return (true, a % b);
874         }
875     }
876 
877     /**
878      * @dev Returns the addition of two unsigned integers, reverting on
879      * overflow.
880      *
881      * Counterpart to Solidity's `+` operator.
882      *
883      * Requirements:
884      *
885      * - Addition cannot overflow.
886      */
887     function add(uint256 a, uint256 b) internal pure returns (uint256) {
888         return a + b;
889     }
890 
891     /**
892      * @dev Returns the subtraction of two unsigned integers, reverting on
893      * overflow (when the result is negative).
894      *
895      * Counterpart to Solidity's `-` operator.
896      *
897      * Requirements:
898      *
899      * - Subtraction cannot overflow.
900      */
901     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
902         return a - b;
903     }
904 
905     /**
906      * @dev Returns the multiplication of two unsigned integers, reverting on
907      * overflow.
908      *
909      * Counterpart to Solidity's `*` operator.
910      *
911      * Requirements:
912      *
913      * - Multiplication cannot overflow.
914      */
915     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
916         return a * b;
917     }
918 
919     /**
920      * @dev Returns the integer division of two unsigned integers, reverting on
921      * division by zero. The result is rounded towards zero.
922      *
923      * Counterpart to Solidity's `/` operator.
924      *
925      * Requirements:
926      *
927      * - The divisor cannot be zero.
928      */
929     function div(uint256 a, uint256 b) internal pure returns (uint256) {
930         return a / b;
931     }
932 
933     /**
934      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
935      * reverting when dividing by zero.
936      *
937      * Counterpart to Solidity's `%` operator. This function uses a `revert`
938      * opcode (which leaves remaining gas untouched) while Solidity uses an
939      * invalid opcode to revert (consuming all remaining gas).
940      *
941      * Requirements:
942      *
943      * - The divisor cannot be zero.
944      */
945     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
946         return a % b;
947     }
948 
949     /**
950      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
951      * overflow (when the result is negative).
952      *
953      * CAUTION: This function is deprecated because it requires allocating memory for the error
954      * message unnecessarily. For custom revert reasons use {trySub}.
955      *
956      * Counterpart to Solidity's `-` operator.
957      *
958      * Requirements:
959      *
960      * - Subtraction cannot overflow.
961      */
962     function sub(
963         uint256 a,
964         uint256 b,
965         string memory errorMessage
966     ) internal pure returns (uint256) {
967         unchecked {
968             require(b <= a, errorMessage);
969             return a - b;
970         }
971     }
972 
973     /**
974      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
975      * division by zero. The result is rounded towards zero.
976      *
977      * Counterpart to Solidity's `/` operator. Note: this function uses a
978      * `revert` opcode (which leaves remaining gas untouched) while Solidity
979      * uses an invalid opcode to revert (consuming all remaining gas).
980      *
981      * Requirements:
982      *
983      * - The divisor cannot be zero.
984      */
985     function div(
986         uint256 a,
987         uint256 b,
988         string memory errorMessage
989     ) internal pure returns (uint256) {
990         unchecked {
991             require(b > 0, errorMessage);
992             return a / b;
993         }
994     }
995 
996     /**
997      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
998      * reverting with custom message when dividing by zero.
999      *
1000      * CAUTION: This function is deprecated because it requires allocating memory for the error
1001      * message unnecessarily. For custom revert reasons use {tryMod}.
1002      *
1003      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1004      * opcode (which leaves remaining gas untouched) while Solidity uses an
1005      * invalid opcode to revert (consuming all remaining gas).
1006      *
1007      * Requirements:
1008      *
1009      * - The divisor cannot be zero.
1010      */
1011     function mod(
1012         uint256 a,
1013         uint256 b,
1014         string memory errorMessage
1015     ) internal pure returns (uint256) {
1016         unchecked {
1017             require(b > 0, errorMessage);
1018             return a % b;
1019         }
1020     }
1021 }
1022 
1023 ////// src/IUniswapV2Factory.sol
1024 /* pragma solidity 0.8.10; */
1025 /* pragma experimental ABIEncoderV2; */
1026 
1027 interface IUniswapV2Factory {
1028     event PairCreated(
1029         address indexed token0,
1030         address indexed token1,
1031         address pair,
1032         uint256
1033     );
1034 
1035     function feeTo() external view returns (address);
1036 
1037     function feeToSetter() external view returns (address);
1038 
1039     function getPair(address tokenA, address tokenB)
1040         external
1041         view
1042         returns (address pair);
1043 
1044     function allPairs(uint256) external view returns (address pair);
1045 
1046     function allPairsLength() external view returns (uint256);
1047 
1048     function createPair(address tokenA, address tokenB)
1049         external
1050         returns (address pair);
1051 
1052     function setFeeTo(address) external;
1053 
1054     function setFeeToSetter(address) external;
1055 }
1056 
1057 ////// src/IUniswapV2Pair.sol
1058 /* pragma solidity 0.8.10; */
1059 /* pragma experimental ABIEncoderV2; */
1060 
1061 interface IUniswapV2Pair {
1062     event Approval(
1063         address indexed owner,
1064         address indexed spender,
1065         uint256 value
1066     );
1067     event Transfer(address indexed from, address indexed to, uint256 value);
1068 
1069     function name() external pure returns (string memory);
1070 
1071     function symbol() external pure returns (string memory);
1072 
1073     function decimals() external pure returns (uint8);
1074 
1075     function totalSupply() external view returns (uint256);
1076 
1077     function balanceOf(address owner) external view returns (uint256);
1078 
1079     function allowance(address owner, address spender)
1080         external
1081         view
1082         returns (uint256);
1083 
1084     function approve(address spender, uint256 value) external returns (bool);
1085 
1086     function transfer(address to, uint256 value) external returns (bool);
1087 
1088     function transferFrom(
1089         address from,
1090         address to,
1091         uint256 value
1092     ) external returns (bool);
1093 
1094     function DOMAIN_SEPARATOR() external view returns (bytes32);
1095 
1096     function PERMIT_TYPEHASH() external pure returns (bytes32);
1097 
1098     function nonces(address owner) external view returns (uint256);
1099 
1100     function permit(
1101         address owner,
1102         address spender,
1103         uint256 value,
1104         uint256 deadline,
1105         uint8 v,
1106         bytes32 r,
1107         bytes32 s
1108     ) external;
1109 
1110     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
1111     event Burn(
1112         address indexed sender,
1113         uint256 amount0,
1114         uint256 amount1,
1115         address indexed to
1116     );
1117     event Swap(
1118         address indexed sender,
1119         uint256 amount0In,
1120         uint256 amount1In,
1121         uint256 amount0Out,
1122         uint256 amount1Out,
1123         address indexed to
1124     );
1125     event Sync(uint112 reserve0, uint112 reserve1);
1126 
1127     function MINIMUM_LIQUIDITY() external pure returns (uint256);
1128 
1129     function factory() external view returns (address);
1130 
1131     function token0() external view returns (address);
1132 
1133     function token1() external view returns (address);
1134 
1135     function getReserves()
1136         external
1137         view
1138         returns (
1139             uint112 reserve0,
1140             uint112 reserve1,
1141             uint32 blockTimestampLast
1142         );
1143 
1144     function price0CumulativeLast() external view returns (uint256);
1145 
1146     function price1CumulativeLast() external view returns (uint256);
1147 
1148     function kLast() external view returns (uint256);
1149 
1150     function mint(address to) external returns (uint256 liquidity);
1151 
1152     function burn(address to)
1153         external
1154         returns (uint256 amount0, uint256 amount1);
1155 
1156     function swap(
1157         uint256 amount0Out,
1158         uint256 amount1Out,
1159         address to,
1160         bytes calldata data
1161     ) external;
1162 
1163     function skim(address to) external;
1164 
1165     function sync() external;
1166 
1167     function initialize(address, address) external;
1168 }
1169 
1170 ////// src/IUniswapV2Router02.sol
1171 /* pragma solidity 0.8.10; */
1172 /* pragma experimental ABIEncoderV2; */
1173 
1174 interface IUniswapV2Router02 {
1175     function factory() external pure returns (address);
1176 
1177     function WETH() external pure returns (address);
1178 
1179     function addLiquidity(
1180         address tokenA,
1181         address tokenB,
1182         uint256 amountADesired,
1183         uint256 amountBDesired,
1184         uint256 amountAMin,
1185         uint256 amountBMin,
1186         address to,
1187         uint256 deadline
1188     )
1189         external
1190         returns (
1191             uint256 amountA,
1192             uint256 amountB,
1193             uint256 liquidity
1194         );
1195 
1196     function addLiquidityETH(
1197         address token,
1198         uint256 amountTokenDesired,
1199         uint256 amountTokenMin,
1200         uint256 amountETHMin,
1201         address to,
1202         uint256 deadline
1203     )
1204         external
1205         payable
1206         returns (
1207             uint256 amountToken,
1208             uint256 amountETH,
1209             uint256 liquidity
1210         );
1211 
1212     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1213         uint256 amountIn,
1214         uint256 amountOutMin,
1215         address[] calldata path,
1216         address to,
1217         uint256 deadline
1218     ) external;
1219 
1220     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1221         uint256 amountOutMin,
1222         address[] calldata path,
1223         address to,
1224         uint256 deadline
1225     ) external payable;
1226 
1227     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1228         uint256 amountIn,
1229         uint256 amountOutMin,
1230         address[] calldata path,
1231         address to,
1232         uint256 deadline
1233     ) external;
1234 }
1235 
1236 ////// stackt.sol
1237 /**
1238 
1239 Stack Treasury
1240 A revolutionary take on DeFi.
1241 
1242 When you hold $STACKT, we invest it across multiple 
1243 chains using our farming strategies.
1244 
1245 All the profits go back to the holders.
1246 
1247 Tax for Buying/Selling: 10%
1248     - 3% of each transaction sent to holders as ETH transactions
1249     - 4% of each transaction sent to Treasury Wallet
1250     - 3% of each transaction sent to the Liquidity Pool
1251 
1252 Earning Dashboard:
1253 https://stacktreasury.com
1254 
1255 */
1256 
1257 /* pragma solidity 0.8.10; */
1258 
1259 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1260 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1261 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1262 /* import {Address} from "lib/openzeppelin-contracts/contracts/utils/Address.sol"; */
1263 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1264 
1265 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1266 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1267 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1268 
1269 contract StackT is Ownable, IERC20 {
1270     address UNISWAPROUTER = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1271     address DEAD = 0x000000000000000000000000000000000000dEaD;
1272     address ZERO = 0x0000000000000000000000000000000000000000;
1273 
1274     string private _name = "Stack Treasury";
1275     string private _symbol = "STACKT";
1276 
1277     uint256 public treasuryFeeBPS = 400;
1278     uint256 public liquidityFeeBPS = 300;
1279     uint256 public dividendFeeBPS = 300;
1280     uint256 public totalFeeBPS = 1000;
1281 
1282     uint256 public swapTokensAtAmount = 100000 * (10**18);
1283     uint256 public lastSwapTime;
1284     bool swapAllToken = true;
1285 
1286     bool public swapEnabled = true;
1287     bool public taxEnabled = true;
1288     bool public compoundingEnabled = true;
1289 
1290     uint256 private _totalSupply;
1291     bool private swapping;
1292 
1293     address marketingWallet;
1294     address liquidityWallet;
1295 
1296     mapping(address => uint256) private _balances;
1297     mapping(address => mapping(address => uint256)) private _allowances;
1298     mapping(address => bool) private _isExcludedFromFees;
1299     mapping(address => bool) public automatedMarketMakerPairs;
1300     mapping(address => bool) private _whiteList;
1301     mapping(address => bool) isBlacklisted;
1302 
1303     event SwapAndAddLiquidity(
1304         uint256 tokensSwapped,
1305         uint256 nativeReceived,
1306         uint256 tokensIntoLiquidity
1307     );
1308     event SendDividends(uint256 tokensSwapped, uint256 amount);
1309     event ExcludeFromFees(address indexed account, bool isExcluded);
1310     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1311     event UpdateUniswapV2Router(
1312         address indexed newAddress,
1313         address indexed oldAddress
1314     );
1315     event SwapEnabled(bool enabled);
1316     event TaxEnabled(bool enabled);
1317     event CompoundingEnabled(bool enabled);
1318     event BlacklistEnabled(bool enabled);
1319 
1320     DividendTracker public dividendTracker;
1321     IUniswapV2Router02 public uniswapV2Router;
1322 
1323     address public uniswapV2Pair;
1324 
1325     uint256 public maxTxBPS = 49;
1326     uint256 public maxWalletBPS = 200;
1327 
1328     bool isOpen = false;
1329 
1330     mapping(address => bool) private _isExcludedFromMaxTx;
1331     mapping(address => bool) private _isExcludedFromMaxWallet;
1332 
1333     constructor(
1334         address _marketingWallet,
1335         address _liquidityWallet,
1336         address[] memory whitelistAddress
1337     ) {
1338         marketingWallet = _marketingWallet;
1339         liquidityWallet = _liquidityWallet;
1340         includeToWhiteList(whitelistAddress);
1341 
1342         dividendTracker = new DividendTracker(address(this), UNISWAPROUTER);
1343 
1344         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(UNISWAPROUTER);
1345 
1346         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1347             .createPair(address(this), _uniswapV2Router.WETH());
1348 
1349         uniswapV2Router = _uniswapV2Router;
1350         uniswapV2Pair = _uniswapV2Pair;
1351 
1352         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1353 
1354         dividendTracker.excludeFromDividends(address(dividendTracker), true);
1355         dividendTracker.excludeFromDividends(address(this), true);
1356         dividendTracker.excludeFromDividends(owner(), true);
1357         dividendTracker.excludeFromDividends(address(_uniswapV2Router), true);
1358 
1359         excludeFromFees(owner(), true);
1360         excludeFromFees(address(this), true);
1361         excludeFromFees(address(dividendTracker), true);
1362 
1363         excludeFromMaxTx(owner(), true);
1364         excludeFromMaxTx(address(this), true);
1365         excludeFromMaxTx(address(dividendTracker), true);
1366 
1367         excludeFromMaxWallet(owner(), true);
1368         excludeFromMaxWallet(address(this), true);
1369         excludeFromMaxWallet(address(dividendTracker), true);
1370 
1371         _mint(owner(), 1000000000 * (10**18));
1372     }
1373 
1374     receive() external payable {}
1375 
1376     function name() public view returns (string memory) {
1377         return _name;
1378     }
1379 
1380     function symbol() public view returns (string memory) {
1381         return _symbol;
1382     }
1383 
1384     function decimals() public pure returns (uint8) {
1385         return 18;
1386     }
1387 
1388     function totalSupply() public view virtual override returns (uint256) {
1389         return _totalSupply;
1390     }
1391 
1392     function balanceOf(address account)
1393         public
1394         view
1395         virtual
1396         override
1397         returns (uint256)
1398     {
1399         return _balances[account];
1400     }
1401 
1402     function allowance(address owner, address spender)
1403         public
1404         view
1405         virtual
1406         override
1407         returns (uint256)
1408     {
1409         return _allowances[owner][spender];
1410     }
1411 
1412     function approve(address spender, uint256 amount)
1413         public
1414         virtual
1415         override
1416         returns (bool)
1417     {
1418         _approve(_msgSender(), spender, amount);
1419         return true;
1420     }
1421 
1422     function increaseAllowance(address spender, uint256 addedValue)
1423         public
1424         returns (bool)
1425     {
1426         _approve(
1427             _msgSender(),
1428             spender,
1429             _allowances[_msgSender()][spender] + addedValue
1430         );
1431         return true;
1432     }
1433 
1434     function decreaseAllowance(address spender, uint256 subtractedValue)
1435         public
1436         returns (bool)
1437     {
1438         uint256 currentAllowance = _allowances[_msgSender()][spender];
1439         require(
1440             currentAllowance >= subtractedValue,
1441             "StackT: decreased allowance below zero"
1442         );
1443         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1444         return true;
1445     }
1446 
1447     function transfer(address recipient, uint256 amount)
1448         public
1449         virtual
1450         override
1451         returns (bool)
1452     {
1453         _transfer(_msgSender(), recipient, amount);
1454         return true;
1455     }
1456 
1457     function transferFrom(
1458         address sender,
1459         address recipient,
1460         uint256 amount
1461     ) public virtual override returns (bool) {
1462         _transfer(sender, recipient, amount);
1463         uint256 currentAllowance = _allowances[sender][_msgSender()];
1464         require(
1465             currentAllowance >= amount,
1466             "StackT: transfer amount exceeds allowance"
1467         );
1468         _approve(sender, _msgSender(), currentAllowance - amount);
1469         return true;
1470     }
1471 
1472     function openTrading() external onlyOwner {
1473         isOpen = true;
1474     }
1475 
1476     function _transfer(
1477         address sender,
1478         address recipient,
1479         uint256 amount
1480     ) internal {
1481         require(
1482             isOpen ||
1483                 sender == owner() ||
1484                 recipient == owner() ||
1485                 _whiteList[sender] ||
1486                 _whiteList[recipient],
1487             "Not Open"
1488         );
1489 
1490         require(!isBlacklisted[sender], "StackT: Sender is blacklisted");
1491         require(!isBlacklisted[recipient], "StackT: Recipient is blacklisted");
1492 
1493         require(sender != address(0), "StackT: transfer from the zero address");
1494         require(recipient != address(0), "StackT: transfer to the zero address");
1495 
1496         uint256 _maxTxAmount = (totalSupply() * maxTxBPS) / 10000;
1497         uint256 _maxWallet = (totalSupply() * maxWalletBPS) / 10000;
1498         require(
1499             amount <= _maxTxAmount || _isExcludedFromMaxTx[sender],
1500             "TX Limit Exceeded"
1501         );
1502 
1503         if (
1504             sender != owner() &&
1505             recipient != address(this) &&
1506             recipient != address(DEAD) &&
1507             recipient != uniswapV2Pair
1508         ) {
1509             uint256 currentBalance = balanceOf(recipient);
1510             require(
1511                 _isExcludedFromMaxWallet[recipient] ||
1512                     (currentBalance + amount <= _maxWallet)
1513             );
1514         }
1515 
1516         uint256 senderBalance = _balances[sender];
1517         require(
1518             senderBalance >= amount,
1519             "StackT: transfer amount exceeds balance"
1520         );
1521 
1522         uint256 contractTokenBalance = balanceOf(address(this));
1523         uint256 contractNativeBalance = address(this).balance;
1524 
1525         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1526 
1527         if (
1528             swapEnabled && // True
1529             canSwap && // true
1530             !swapping && // swapping=false !false true
1531             !automatedMarketMakerPairs[sender] && // no swap on remove liquidity step 1 or DEX buy
1532             sender != address(uniswapV2Router) && // no swap on remove liquidity step 2
1533             sender != owner() &&
1534             recipient != owner()
1535         ) {
1536             swapping = true;
1537 
1538             if (!swapAllToken) {
1539                 contractTokenBalance = swapTokensAtAmount;
1540             }
1541             _executeSwap(contractTokenBalance, contractNativeBalance);
1542 
1543             lastSwapTime = block.timestamp;
1544             swapping = false;
1545         }
1546 
1547         bool takeFee;
1548 
1549         if (
1550             sender == address(uniswapV2Pair) ||
1551             recipient == address(uniswapV2Pair)
1552         ) {
1553             takeFee = true;
1554         }
1555 
1556         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
1557             takeFee = false;
1558         }
1559 
1560         if (swapping || !taxEnabled) {
1561             takeFee = false;
1562         }
1563 
1564         if (takeFee) {
1565             uint256 fees = (amount * totalFeeBPS) / 10000;
1566             amount -= fees;
1567             _executeTransfer(sender, address(this), fees);
1568         }
1569 
1570         _executeTransfer(sender, recipient, amount);
1571 
1572         dividendTracker.setBalance(payable(sender), balanceOf(sender));
1573         dividendTracker.setBalance(payable(recipient), balanceOf(recipient));
1574     }
1575 
1576     function _executeTransfer(
1577         address sender,
1578         address recipient,
1579         uint256 amount
1580     ) private {
1581         require(sender != address(0), "StackT: transfer from the zero address");
1582         require(recipient != address(0), "StackT: transfer to the zero address");
1583         uint256 senderBalance = _balances[sender];
1584         require(
1585             senderBalance >= amount,
1586             "StackT: transfer amount exceeds balance"
1587         );
1588         _balances[sender] = senderBalance - amount;
1589         _balances[recipient] += amount;
1590         emit Transfer(sender, recipient, amount);
1591     }
1592 
1593     function _approve(
1594         address owner,
1595         address spender,
1596         uint256 amount
1597     ) private {
1598         require(owner != address(0), "StackT: approve from the zero address");
1599         require(spender != address(0), "StackT: approve to the zero address");
1600         _allowances[owner][spender] = amount;
1601         emit Approval(owner, spender, amount);
1602     }
1603 
1604     function _mint(address account, uint256 amount) private {
1605         require(account != address(0), "StackT: mint to the zero address");
1606         _totalSupply += amount;
1607         _balances[account] += amount;
1608         emit Transfer(address(0), account, amount);
1609     }
1610 
1611     function _burn(address account, uint256 amount) private {
1612         require(account != address(0), "StackT: burn from the zero address");
1613         uint256 accountBalance = _balances[account];
1614         require(accountBalance >= amount, "StackT: burn amount exceeds balance");
1615         _balances[account] = accountBalance - amount;
1616         _totalSupply -= amount;
1617         emit Transfer(account, address(0), amount);
1618     }
1619 
1620     function swapTokensForNative(uint256 tokens) private {
1621         address[] memory path = new address[](2);
1622         path[0] = address(this);
1623         path[1] = uniswapV2Router.WETH();
1624         _approve(address(this), address(uniswapV2Router), tokens);
1625         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1626             tokens,
1627             0, // accept any amount of native
1628             path,
1629             address(this),
1630             block.timestamp
1631         );
1632     }
1633 
1634     function addLiquidity(uint256 tokens, uint256 native) private {
1635         _approve(address(this), address(uniswapV2Router), tokens);
1636         uniswapV2Router.addLiquidityETH{value: native}(
1637             address(this),
1638             tokens,
1639             0, // slippage unavoidable
1640             0, // slippage unavoidable
1641             liquidityWallet,
1642             block.timestamp
1643         );
1644     }
1645 
1646     function includeToWhiteList(address[] memory _users) private {
1647         for (uint8 i = 0; i < _users.length; i++) {
1648             _whiteList[_users[i]] = true;
1649         }
1650     }
1651 
1652     function _executeSwap(uint256 tokens, uint256 native) private {
1653         if (tokens <= 0) {
1654             return;
1655         }
1656 
1657         uint256 swapTokensMarketing;
1658         if (address(marketingWallet) != address(0)) {
1659             swapTokensMarketing = (tokens * treasuryFeeBPS) / totalFeeBPS;
1660         }
1661 
1662         uint256 swapTokensDividends;
1663         if (dividendTracker.totalSupply() > 0) {
1664             swapTokensDividends = (tokens * dividendFeeBPS) / totalFeeBPS;
1665         }
1666 
1667         uint256 tokensForLiquidity = tokens -
1668             swapTokensMarketing -
1669             swapTokensDividends;
1670         uint256 swapTokensLiquidity = tokensForLiquidity / 2;
1671         uint256 addTokensLiquidity = tokensForLiquidity - swapTokensLiquidity;
1672         uint256 swapTokensTotal = swapTokensMarketing +
1673             swapTokensDividends +
1674             swapTokensLiquidity;
1675 
1676         uint256 initNativeBal = address(this).balance;
1677         swapTokensForNative(swapTokensTotal);
1678         uint256 nativeSwapped = (address(this).balance - initNativeBal) +
1679             native;
1680 
1681         uint256 nativeMarketing = (nativeSwapped * swapTokensMarketing) /
1682             swapTokensTotal;
1683         uint256 nativeDividends = (nativeSwapped * swapTokensDividends) /
1684             swapTokensTotal;
1685         uint256 nativeLiquidity = nativeSwapped -
1686             nativeMarketing -
1687             nativeDividends;
1688 
1689         if (nativeMarketing > 0) {
1690             payable(marketingWallet).transfer(nativeMarketing);
1691         }
1692 
1693         addLiquidity(addTokensLiquidity, nativeLiquidity);
1694         emit SwapAndAddLiquidity(
1695             swapTokensLiquidity,
1696             nativeLiquidity,
1697             addTokensLiquidity
1698         );
1699 
1700         if (nativeDividends > 0) {
1701             (bool success, ) = address(dividendTracker).call{
1702                 value: nativeDividends
1703             }("");
1704             if (success) {
1705                 emit SendDividends(swapTokensDividends, nativeDividends);
1706             }
1707         }
1708     }
1709 
1710     function excludeFromFees(address account, bool excluded) public onlyOwner {
1711         require(
1712             _isExcludedFromFees[account] != excluded,
1713             "StackT: account is already set to requested state"
1714         );
1715         _isExcludedFromFees[account] = excluded;
1716         emit ExcludeFromFees(account, excluded);
1717     }
1718 
1719     function isExcludedFromFees(address account) public view returns (bool) {
1720         return _isExcludedFromFees[account];
1721     }
1722 
1723     function manualSendDividend(uint256 amount, address holder)
1724         external
1725         onlyOwner
1726     {
1727         dividendTracker.manualSendDividend(amount, holder);
1728     }
1729 
1730     function excludeFromDividends(address account, bool excluded)
1731         public
1732         onlyOwner
1733     {
1734         dividendTracker.excludeFromDividends(account, excluded);
1735     }
1736 
1737     function isExcludedFromDividends(address account)
1738         public
1739         view
1740         returns (bool)
1741     {
1742         return dividendTracker.isExcludedFromDividends(account);
1743     }
1744 
1745     function setWallet(
1746         address payable _marketingWallet,
1747         address payable _liquidityWallet
1748     ) external onlyOwner {
1749         marketingWallet = _marketingWallet;
1750         liquidityWallet = _liquidityWallet;
1751     }
1752 
1753     function setAutomatedMarketMakerPair(address pair, bool value)
1754         public
1755         onlyOwner
1756     {
1757         require(pair != uniswapV2Pair, "StackT: DEX pair can not be removed");
1758         _setAutomatedMarketMakerPair(pair, value);
1759     }
1760 
1761     function setFee(
1762         uint256 _treasuryFee,
1763         uint256 _liquidityFee,
1764         uint256 _dividendFee
1765     ) external onlyOwner {
1766         treasuryFeeBPS = _treasuryFee;
1767         liquidityFeeBPS = _liquidityFee;
1768         dividendFeeBPS = _dividendFee;
1769         totalFeeBPS = _treasuryFee + _liquidityFee + _dividendFee;
1770     }
1771 
1772     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1773         require(
1774             automatedMarketMakerPairs[pair] != value,
1775             "StackT: automated market maker pair is already set to that value"
1776         );
1777         automatedMarketMakerPairs[pair] = value;
1778         if (value) {
1779             dividendTracker.excludeFromDividends(pair, true);
1780         }
1781         emit SetAutomatedMarketMakerPair(pair, value);
1782     }
1783 
1784     function updateUniswapV2Router(address newAddress) public onlyOwner {
1785         require(
1786             newAddress != address(uniswapV2Router),
1787             "StackT: the router is already set to the new address"
1788         );
1789         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
1790         uniswapV2Router = IUniswapV2Router02(newAddress);
1791         address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
1792             .createPair(address(this), uniswapV2Router.WETH());
1793         uniswapV2Pair = _uniswapV2Pair;
1794     }
1795 
1796     function claim() public {
1797         dividendTracker.processAccount(payable(_msgSender()));
1798     }
1799 
1800     function compound() public {
1801         require(compoundingEnabled, "StackT: compounding is not enabled");
1802         dividendTracker.compoundAccount(payable(_msgSender()));
1803     }
1804 
1805     function withdrawableDividendOf(address account)
1806         public
1807         view
1808         returns (uint256)
1809     {
1810         return dividendTracker.withdrawableDividendOf(account);
1811     }
1812 
1813     function withdrawnDividendOf(address account)
1814         public
1815         view
1816         returns (uint256)
1817     {
1818         return dividendTracker.withdrawnDividendOf(account);
1819     }
1820 
1821     function accumulativeDividendOf(address account)
1822         public
1823         view
1824         returns (uint256)
1825     {
1826         return dividendTracker.accumulativeDividendOf(account);
1827     }
1828 
1829     function getAccountInfo(address account)
1830         public
1831         view
1832         returns (
1833             address,
1834             uint256,
1835             uint256,
1836             uint256,
1837             uint256
1838         )
1839     {
1840         return dividendTracker.getAccountInfo(account);
1841     }
1842 
1843     function getLastClaimTime(address account) public view returns (uint256) {
1844         return dividendTracker.getLastClaimTime(account);
1845     }
1846 
1847     function setSwapEnabled(bool _enabled) external onlyOwner {
1848         swapEnabled = _enabled;
1849         emit SwapEnabled(_enabled);
1850     }
1851 
1852     function setTaxEnabled(bool _enabled) external onlyOwner {
1853         taxEnabled = _enabled;
1854         emit TaxEnabled(_enabled);
1855     }
1856 
1857     function setCompoundingEnabled(bool _enabled) external onlyOwner {
1858         compoundingEnabled = _enabled;
1859         emit CompoundingEnabled(_enabled);
1860     }
1861 
1862     function updateDividendSettings(
1863         bool _swapEnabled,
1864         uint256 _swapTokensAtAmount,
1865         bool _swapAllToken
1866     ) external onlyOwner {
1867         swapEnabled = _swapEnabled;
1868         swapTokensAtAmount = _swapTokensAtAmount;
1869         swapAllToken = _swapAllToken;
1870     }
1871 
1872     function setMaxTxBPS(uint256 bps) external onlyOwner {
1873         require(bps >= 75 && bps <= 10000, "BPS must be between 75 and 10000");
1874         maxTxBPS = bps;
1875     }
1876 
1877     function excludeFromMaxTx(address account, bool excluded) public onlyOwner {
1878         _isExcludedFromMaxTx[account] = excluded;
1879     }
1880 
1881     function isExcludedFromMaxTx(address account) public view returns (bool) {
1882         return _isExcludedFromMaxTx[account];
1883     }
1884 
1885     function setMaxWalletBPS(uint256 bps) external onlyOwner {
1886         require(
1887             bps >= 175 && bps <= 10000,
1888             "BPS must be between 175 and 10000"
1889         );
1890         maxWalletBPS = bps;
1891     }
1892 
1893     function excludeFromMaxWallet(address account, bool excluded)
1894         public
1895         onlyOwner
1896     {
1897         _isExcludedFromMaxWallet[account] = excluded;
1898     }
1899 
1900     function isExcludedFromMaxWallet(address account)
1901         public
1902         view
1903         returns (bool)
1904     {
1905         return _isExcludedFromMaxWallet[account];
1906     }
1907 
1908     function rescueToken(address _token, uint256 _amount) external onlyOwner {
1909         IERC20(_token).transfer(msg.sender, _amount);
1910     }
1911 
1912     function rescueETH(uint256 _amount) external onlyOwner {
1913         payable(msg.sender).transfer(_amount);
1914     }
1915 
1916     function blackList(address _user) public onlyOwner {
1917         require(!isBlacklisted[_user], "user already blacklisted");
1918         isBlacklisted[_user] = true;
1919         // events?
1920     }
1921 
1922     function removeFromBlacklist(address _user) public onlyOwner {
1923         require(isBlacklisted[_user], "user already whitelisted");
1924         isBlacklisted[_user] = false;
1925         //events?
1926     }
1927 
1928     function blackListMany(address[] memory _users) public onlyOwner {
1929         for (uint8 i = 0; i < _users.length; i++) {
1930             isBlacklisted[_users[i]] = true;
1931         }
1932     }
1933 
1934     function unBlackListMany(address[] memory _users) public onlyOwner {
1935         for (uint8 i = 0; i < _users.length; i++) {
1936             isBlacklisted[_users[i]] = false;
1937         }
1938     }
1939 }
1940 
1941 contract DividendTracker is Ownable, IERC20 {
1942     address UNISWAPROUTER;
1943 
1944     string private _name = "StackT_DividendTracker";
1945     string private _symbol = "StackT_DividendTracker";
1946 
1947     uint256 public lastProcessedIndex;
1948 
1949     uint256 private _totalSupply;
1950     mapping(address => uint256) private _balances;
1951 
1952     uint256 private constant magnitude = 2**128;
1953     uint256 public immutable minTokenBalanceForDividends;
1954     uint256 private magnifiedDividendPerShare;
1955     uint256 public totalDividendsDistributed;
1956     uint256 public totalDividendsWithdrawn;
1957 
1958     address public tokenAddress;
1959 
1960     mapping(address => bool) public excludedFromDividends;
1961     mapping(address => int256) private magnifiedDividendCorrections;
1962     mapping(address => uint256) private withdrawnDividends;
1963     mapping(address => uint256) private lastClaimTimes;
1964 
1965     event DividendsDistributed(address indexed from, uint256 weiAmount);
1966     event DividendWithdrawn(address indexed to, uint256 weiAmount);
1967     event ExcludeFromDividends(address indexed account, bool excluded);
1968     event Claim(address indexed account, uint256 amount);
1969     event Compound(address indexed account, uint256 amount, uint256 tokens);
1970 
1971     struct AccountInfo {
1972         address account;
1973         uint256 withdrawableDividends;
1974         uint256 totalDividends;
1975         uint256 lastClaimTime;
1976     }
1977 
1978     constructor(address _tokenAddress, address _uniswapRouter) {
1979         minTokenBalanceForDividends = 10000 * (10**18);
1980         tokenAddress = _tokenAddress;
1981         UNISWAPROUTER = _uniswapRouter;
1982     }
1983 
1984     receive() external payable {
1985         distributeDividends();
1986     }
1987 
1988     function distributeDividends() public payable {
1989         require(_totalSupply > 0);
1990         if (msg.value > 0) {
1991             magnifiedDividendPerShare =
1992                 magnifiedDividendPerShare +
1993                 ((msg.value * magnitude) / _totalSupply);
1994             emit DividendsDistributed(msg.sender, msg.value);
1995             totalDividendsDistributed += msg.value;
1996         }
1997     }
1998 
1999     function setBalance(address payable account, uint256 newBalance)
2000         external
2001         onlyOwner
2002     {
2003         if (excludedFromDividends[account]) {
2004             return;
2005         }
2006         if (newBalance >= minTokenBalanceForDividends) {
2007             _setBalance(account, newBalance);
2008         } else {
2009             _setBalance(account, 0);
2010         }
2011     }
2012 
2013     function excludeFromDividends(address account, bool excluded)
2014         external
2015         onlyOwner
2016     {
2017         require(
2018             excludedFromDividends[account] != excluded,
2019             "StackT_DividendTracker: account already set to requested state"
2020         );
2021         excludedFromDividends[account] = excluded;
2022         if (excluded) {
2023             _setBalance(account, 0);
2024         } else {
2025             uint256 newBalance = IERC20(tokenAddress).balanceOf(account);
2026             if (newBalance >= minTokenBalanceForDividends) {
2027                 _setBalance(account, newBalance);
2028             } else {
2029                 _setBalance(account, 0);
2030             }
2031         }
2032         emit ExcludeFromDividends(account, excluded);
2033     }
2034 
2035     function isExcludedFromDividends(address account)
2036         public
2037         view
2038         returns (bool)
2039     {
2040         return excludedFromDividends[account];
2041     }
2042 
2043     function manualSendDividend(uint256 amount, address holder)
2044         external
2045         onlyOwner
2046     {
2047         uint256 contractETHBalance = address(this).balance;
2048         payable(holder).transfer(amount > 0 ? amount : contractETHBalance);
2049     }
2050 
2051     function _setBalance(address account, uint256 newBalance) internal {
2052         uint256 currentBalance = _balances[account];
2053         if (newBalance > currentBalance) {
2054             uint256 addAmount = newBalance - currentBalance;
2055             _mint(account, addAmount);
2056         } else if (newBalance < currentBalance) {
2057             uint256 subAmount = currentBalance - newBalance;
2058             _burn(account, subAmount);
2059         }
2060     }
2061 
2062     function _mint(address account, uint256 amount) private {
2063         require(
2064             account != address(0),
2065             "StackT_DividendTracker: mint to the zero address"
2066         );
2067         _totalSupply += amount;
2068         _balances[account] += amount;
2069         emit Transfer(address(0), account, amount);
2070         magnifiedDividendCorrections[account] =
2071             magnifiedDividendCorrections[account] -
2072             int256(magnifiedDividendPerShare * amount);
2073     }
2074 
2075     function _burn(address account, uint256 amount) private {
2076         require(
2077             account != address(0),
2078             "StackT_DividendTracker: burn from the zero address"
2079         );
2080         uint256 accountBalance = _balances[account];
2081         require(
2082             accountBalance >= amount,
2083             "StackT_DividendTracker: burn amount exceeds balance"
2084         );
2085         _balances[account] = accountBalance - amount;
2086         _totalSupply -= amount;
2087         emit Transfer(account, address(0), amount);
2088         magnifiedDividendCorrections[account] =
2089             magnifiedDividendCorrections[account] +
2090             int256(magnifiedDividendPerShare * amount);
2091     }
2092 
2093     function processAccount(address payable account)
2094         public
2095         onlyOwner
2096         returns (bool)
2097     {
2098         uint256 amount = _withdrawDividendOfUser(account);
2099         if (amount > 0) {
2100             lastClaimTimes[account] = block.timestamp;
2101             emit Claim(account, amount);
2102             return true;
2103         }
2104         return false;
2105     }
2106 
2107     function _withdrawDividendOfUser(address payable account)
2108         private
2109         returns (uint256)
2110     {
2111         uint256 _withdrawableDividend = withdrawableDividendOf(account);
2112         if (_withdrawableDividend > 0) {
2113             withdrawnDividends[account] += _withdrawableDividend;
2114             totalDividendsWithdrawn += _withdrawableDividend;
2115             emit DividendWithdrawn(account, _withdrawableDividend);
2116             (bool success, ) = account.call{
2117                 value: _withdrawableDividend,
2118                 gas: 3000
2119             }("");
2120             if (!success) {
2121                 withdrawnDividends[account] -= _withdrawableDividend;
2122                 totalDividendsWithdrawn -= _withdrawableDividend;
2123                 return 0;
2124             }
2125             return _withdrawableDividend;
2126         }
2127         return 0;
2128     }
2129 
2130     function compoundAccount(address payable account)
2131         public
2132         onlyOwner
2133         returns (bool)
2134     {
2135         (uint256 amount, uint256 tokens) = _compoundDividendOfUser(account);
2136         if (amount > 0) {
2137             lastClaimTimes[account] = block.timestamp;
2138             emit Compound(account, amount, tokens);
2139             return true;
2140         }
2141         return false;
2142     }
2143 
2144     function _compoundDividendOfUser(address payable account)
2145         private
2146         returns (uint256, uint256)
2147     {
2148         uint256 _withdrawableDividend = withdrawableDividendOf(account);
2149         if (_withdrawableDividend > 0) {
2150             withdrawnDividends[account] += _withdrawableDividend;
2151             totalDividendsWithdrawn += _withdrawableDividend;
2152             emit DividendWithdrawn(account, _withdrawableDividend);
2153 
2154             IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(
2155                 UNISWAPROUTER
2156             );
2157 
2158             address[] memory path = new address[](2);
2159             path[0] = uniswapV2Router.WETH();
2160             path[1] = address(tokenAddress);
2161 
2162             bool success;
2163             uint256 tokens;
2164 
2165             uint256 initTokenBal = IERC20(tokenAddress).balanceOf(account);
2166             try
2167                 uniswapV2Router
2168                     .swapExactETHForTokensSupportingFeeOnTransferTokens{
2169                     value: _withdrawableDividend
2170                 }(0, path, address(account), block.timestamp)
2171             {
2172                 success = true;
2173                 tokens = IERC20(tokenAddress).balanceOf(account) - initTokenBal;
2174             } catch Error(
2175                 string memory /*err*/
2176             ) {
2177                 success = false;
2178             }
2179 
2180             if (!success) {
2181                 withdrawnDividends[account] -= _withdrawableDividend;
2182                 totalDividendsWithdrawn -= _withdrawableDividend;
2183                 return (0, 0);
2184             }
2185 
2186             return (_withdrawableDividend, tokens);
2187         }
2188         return (0, 0);
2189     }
2190 
2191     function withdrawableDividendOf(address account)
2192         public
2193         view
2194         returns (uint256)
2195     {
2196         return accumulativeDividendOf(account) - withdrawnDividends[account];
2197     }
2198 
2199     function withdrawnDividendOf(address account)
2200         public
2201         view
2202         returns (uint256)
2203     {
2204         return withdrawnDividends[account];
2205     }
2206 
2207     function accumulativeDividendOf(address account)
2208         public
2209         view
2210         returns (uint256)
2211     {
2212         int256 a = int256(magnifiedDividendPerShare * balanceOf(account));
2213         int256 b = magnifiedDividendCorrections[account]; // this is an explicit int256 (signed)
2214         return uint256(a + b) / magnitude;
2215     }
2216 
2217     function getAccountInfo(address account)
2218         public
2219         view
2220         returns (
2221             address,
2222             uint256,
2223             uint256,
2224             uint256,
2225             uint256
2226         )
2227     {
2228         AccountInfo memory info;
2229         info.account = account;
2230         info.withdrawableDividends = withdrawableDividendOf(account);
2231         info.totalDividends = accumulativeDividendOf(account);
2232         info.lastClaimTime = lastClaimTimes[account];
2233         return (
2234             info.account,
2235             info.withdrawableDividends,
2236             info.totalDividends,
2237             info.lastClaimTime,
2238             totalDividendsWithdrawn
2239         );
2240     }
2241 
2242     function getLastClaimTime(address account) public view returns (uint256) {
2243         return lastClaimTimes[account];
2244     }
2245 
2246     function name() public view returns (string memory) {
2247         return _name;
2248     }
2249 
2250     function symbol() public view returns (string memory) {
2251         return _symbol;
2252     }
2253 
2254     function decimals() public pure returns (uint8) {
2255         return 18;
2256     }
2257 
2258     function totalSupply() public view override returns (uint256) {
2259         return _totalSupply;
2260     }
2261 
2262     function balanceOf(address account) public view override returns (uint256) {
2263         return _balances[account];
2264     }
2265 
2266     function transfer(address, uint256) public pure override returns (bool) {
2267         revert("StackT_DividendTracker: method not implemented");
2268     }
2269 
2270     function allowance(address, address)
2271         public
2272         pure
2273         override
2274         returns (uint256)
2275     {
2276         revert("StackT_DividendTracker: method not implemented");
2277     }
2278 
2279     function approve(address, uint256) public pure override returns (bool) {
2280         revert("StackT_DividendTracker: method not implemented");
2281     }
2282 
2283     function transferFrom(
2284         address,
2285         address,
2286         uint256
2287     ) public pure override returns (bool) {
2288         revert("StackT_DividendTracker: method not implemented");
2289     }
2290 }