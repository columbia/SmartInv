1 // Verified using https://dapp.tools
2 
3 // hevm: flattened sources of src/LVMH.sol
4 // SPDX-License-Identifier: MIT
5 pragma solidity =0.8.10 >=0.8.0 <0.9.0;
6 pragma experimental ABIEncoderV2;
7 
8 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
9 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
10 
11 /* pragma solidity ^0.8.0; */
12 
13 /**
14  * @dev Provides information about the current execution context, including the
15  * sender of the transaction and its data. While these are generally available
16  * via msg.sender and msg.data, they should not be accessed in such a direct
17  * manner, since when dealing with meta-transactions the account sending and
18  * paying for execution may not be the actual sender (as far as an application
19  * is concerned).
20  *
21  * This contract is only required for intermediate, library-like contracts.
22  */
23 abstract contract Context {
24     function _msgSender() internal view virtual returns (address) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes calldata) {
29         return msg.data;
30     }
31 }
32 
33 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
34 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
35 
36 /* pragma solidity ^0.8.0; */
37 
38 /* import "../utils/Context.sol"; */
39 
40 /**
41  * @dev Contract module which provides a basic access control mechanism, where
42  * there is an account (an owner) that can be granted exclusive access to
43  * specific functions.
44  *
45  * By default, the owner account will be the one that deploys the contract. This
46  * can later be changed with {transferOwnership}.
47  *
48  * This module is used through inheritance. It will make available the modifier
49  * `onlyOwner`, which can be applied to your functions to restrict their use to
50  * the owner.
51  */
52 abstract contract Ownable is Context {
53     address private _owner;
54 
55     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
56 
57     /**
58      * @dev Initializes the contract setting the deployer as the initial owner.
59      */
60     constructor() {
61         _transferOwnership(_msgSender());
62     }
63 
64     /**
65      * @dev Returns the address of the current owner.
66      */
67     function owner() public view virtual returns (address) {
68         return _owner;
69     }
70 
71     /**
72      * @dev Throws if called by any account other than the owner.
73      */
74     modifier onlyOwner() {
75         require(owner() == _msgSender(), "Ownable: caller is not the owner");
76         _;
77     }
78 
79     /**
80      * @dev Leaves the contract without owner. It will not be possible to call
81      * `onlyOwner` functions anymore. Can only be called by the current owner.
82      *
83      * NOTE: Renouncing ownership will leave the contract without an owner,
84      * thereby removing any functionality that is only available to the owner.
85      */
86     function renounceOwnership() public virtual onlyOwner {
87         _transferOwnership(address(0));
88     }
89 
90     /**
91      * @dev Transfers ownership of the contract to a new account (`newOwner`).
92      * Can only be called by the current owner.
93      */
94     function transferOwnership(address newOwner) public virtual onlyOwner {
95         require(newOwner != address(0), "Ownable: new owner is the zero address");
96         _transferOwnership(newOwner);
97     }
98 
99     /**
100      * @dev Transfers ownership of the contract to a new account (`newOwner`).
101      * Internal function without access restriction.
102      */
103     function _transferOwnership(address newOwner) internal virtual {
104         address oldOwner = _owner;
105         _owner = newOwner;
106         emit OwnershipTransferred(oldOwner, newOwner);
107     }
108 }
109 
110 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
111 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
112 
113 /* pragma solidity ^0.8.0; */
114 
115 /**
116  * @dev Interface of the ERC20 standard as defined in the EIP.
117  */
118 interface IERC20 {
119     /**
120      * @dev Returns the amount of tokens in existence.
121      */
122     function totalSupply() external view returns (uint256);
123 
124     /**
125      * @dev Returns the amount of tokens owned by `account`.
126      */
127     function balanceOf(address account) external view returns (uint256);
128 
129     /**
130      * @dev Moves `amount` tokens from the caller's account to `recipient`.
131      *
132      * Returns a boolean value indicating whether the operation succeeded.
133      *
134      * Emits a {Transfer} event.
135      */
136     function transfer(address recipient, uint256 amount) external returns (bool);
137 
138     /**
139      * @dev Returns the remaining number of tokens that `spender` will be
140      * allowed to spend on behalf of `owner` through {transferFrom}. This is
141      * zero by default.
142      *
143      * This value changes when {approve} or {transferFrom} are called.
144      */
145     function allowance(address owner, address spender) external view returns (uint256);
146 
147     /**
148      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
149      *
150      * Returns a boolean value indicating whether the operation succeeded.
151      *
152      * IMPORTANT: Beware that changing an allowance with this method brings the risk
153      * that someone may use both the old and the new allowance by unfortunate
154      * transaction ordering. One possible solution to mitigate this race
155      * condition is to first reduce the spender's allowance to 0 and set the
156      * desired value afterwards:
157      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
158      *
159      * Emits an {Approval} event.
160      */
161     function approve(address spender, uint256 amount) external returns (bool);
162 
163     /**
164      * @dev Moves `amount` tokens from `sender` to `recipient` using the
165      * allowance mechanism. `amount` is then deducted from the caller's
166      * allowance.
167      *
168      * Returns a boolean value indicating whether the operation succeeded.
169      *
170      * Emits a {Transfer} event.
171      */
172     function transferFrom(
173         address sender,
174         address recipient,
175         uint256 amount
176     ) external returns (bool);
177 
178     /**
179      * @dev Emitted when `value` tokens are moved from one account (`from`) to
180      * another (`to`).
181      *
182      * Note that `value` may be zero.
183      */
184     event Transfer(address indexed from, address indexed to, uint256 value);
185 
186     /**
187      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
188      * a call to {approve}. `value` is the new allowance.
189      */
190     event Approval(address indexed owner, address indexed spender, uint256 value);
191 }
192 
193 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
194 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
195 
196 /* pragma solidity ^0.8.0; */
197 
198 /* import "../IERC20.sol"; */
199 
200 /**
201  * @dev Interface for the optional metadata functions from the ERC20 standard.
202  *
203  * _Available since v4.1._
204  */
205 interface IERC20Metadata is IERC20 {
206     /**
207      * @dev Returns the name of the token.
208      */
209     function name() external view returns (string memory);
210 
211     /**
212      * @dev Returns the symbol of the token.
213      */
214     function symbol() external view returns (string memory);
215 
216     /**
217      * @dev Returns the decimals places of the token.
218      */
219     function decimals() external view returns (uint8);
220 }
221 
222 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
223 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
224 
225 /* pragma solidity ^0.8.0; */
226 
227 /* import "./IERC20.sol"; */
228 /* import "./extensions/IERC20Metadata.sol"; */
229 /* import "../../utils/Context.sol"; */
230 
231 /**
232  * @dev Implementation of the {IERC20} interface.
233  *
234  * This implementation is agnostic to the way tokens are created. This means
235  * that a supply mechanism has to be added in a derived contract using {_mint}.
236  * For a generic mechanism see {ERC20PresetMinterPauser}.
237  *
238  * TIP: For a detailed writeup see our guide
239  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
240  * to implement supply mechanisms].
241  *
242  * We have followed general OpenZeppelin Contracts guidelines: functions revert
243  * instead returning `false` on failure. This behavior is nonetheless
244  * conventional and does not conflict with the expectations of ERC20
245  * applications.
246  *
247  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
248  * This allows applications to reconstruct the allowance for all accounts just
249  * by listening to said events. Other implementations of the EIP may not emit
250  * these events, as it isn't required by the specification.
251  *
252  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
253  * functions have been added to mitigate the well-known issues around setting
254  * allowances. See {IERC20-approve}.
255  */
256 contract ERC20 is Context, IERC20, IERC20Metadata {
257     mapping(address => uint256) private _balances;
258 
259     mapping(address => mapping(address => uint256)) private _allowances;
260 
261     uint256 private _totalSupply;
262 
263     string private _name;
264     string private _symbol;
265 
266     /**
267      * @dev Sets the values for {name} and {symbol}.
268      *
269      * The default value of {decimals} is 18. To select a different value for
270      * {decimals} you should overload it.
271      *
272      * All two of these values are immutable: they can only be set once during
273      * construction.
274      */
275     constructor(string memory name_, string memory symbol_) {
276         _name = name_;
277         _symbol = symbol_;
278     }
279 
280     /**
281      * @dev Returns the name of the token.
282      */
283     function name() public view virtual override returns (string memory) {
284         return _name;
285     }
286 
287     /**
288      * @dev Returns the symbol of the token, usually a shorter version of the
289      * name.
290      */
291     function symbol() public view virtual override returns (string memory) {
292         return _symbol;
293     }
294 
295     /**
296      * @dev Returns the number of decimals used to get its user representation.
297      * For example, if `decimals` equals `2`, a balance of `505` tokens should
298      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
299      *
300      * Tokens usually opt for a value of 18, imitating the relationship between
301      * Ether and Wei. This is the value {ERC20} uses, unless this function is
302      * overridden;
303      *
304      * NOTE: This information is only used for _display_ purposes: it in
305      * no way affects any of the arithmetic of the contract, including
306      * {IERC20-balanceOf} and {IERC20-transfer}.
307      */
308     function decimals() public view virtual override returns (uint8) {
309         return 18;
310     }
311 
312     /**
313      * @dev See {IERC20-totalSupply}.
314      */
315     function totalSupply() public view virtual override returns (uint256) {
316         return _totalSupply;
317     }
318 
319     /**
320      * @dev See {IERC20-balanceOf}.
321      */
322     function balanceOf(address account) public view virtual override returns (uint256) {
323         return _balances[account];
324     }
325 
326     /**
327      * @dev See {IERC20-transfer}.
328      *
329      * Requirements:
330      *
331      * - `recipient` cannot be the zero address.
332      * - the caller must have a balance of at least `amount`.
333      */
334     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
335         _transfer(_msgSender(), recipient, amount);
336         return true;
337     }
338 
339     /**
340      * @dev See {IERC20-allowance}.
341      */
342     function allowance(address owner, address spender) public view virtual override returns (uint256) {
343         return _allowances[owner][spender];
344     }
345 
346     /**
347      * @dev See {IERC20-approve}.
348      *
349      * Requirements:
350      *
351      * - `spender` cannot be the zero address.
352      */
353     function approve(address spender, uint256 amount) public virtual override returns (bool) {
354         _approve(_msgSender(), spender, amount);
355         return true;
356     }
357 
358     /**
359      * @dev See {IERC20-transferFrom}.
360      *
361      * Emits an {Approval} event indicating the updated allowance. This is not
362      * required by the EIP. See the note at the beginning of {ERC20}.
363      *
364      * Requirements:
365      *
366      * - `sender` and `recipient` cannot be the zero address.
367      * - `sender` must have a balance of at least `amount`.
368      * - the caller must have allowance for ``sender``'s tokens of at least
369      * `amount`.
370      */
371     function transferFrom(
372         address sender,
373         address recipient,
374         uint256 amount
375     ) public virtual override returns (bool) {
376         _transfer(sender, recipient, amount);
377 
378         uint256 currentAllowance = _allowances[sender][_msgSender()];
379         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
380         unchecked {
381             _approve(sender, _msgSender(), currentAllowance - amount);
382         }
383 
384         return true;
385     }
386 
387     /**
388      * @dev Atomically increases the allowance granted to `spender` by the caller.
389      *
390      * This is an alternative to {approve} that can be used as a mitigation for
391      * problems described in {IERC20-approve}.
392      *
393      * Emits an {Approval} event indicating the updated allowance.
394      *
395      * Requirements:
396      *
397      * - `spender` cannot be the zero address.
398      */
399     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
400         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
401         return true;
402     }
403 
404     /**
405      * @dev Atomically decreases the allowance granted to `spender` by the caller.
406      *
407      * This is an alternative to {approve} that can be used as a mitigation for
408      * problems described in {IERC20-approve}.
409      *
410      * Emits an {Approval} event indicating the updated allowance.
411      *
412      * Requirements:
413      *
414      * - `spender` cannot be the zero address.
415      * - `spender` must have allowance for the caller of at least
416      * `subtractedValue`.
417      */
418     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
419         uint256 currentAllowance = _allowances[_msgSender()][spender];
420         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
421         unchecked {
422             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
423         }
424 
425         return true;
426     }
427 
428     /**
429      * @dev Moves `amount` of tokens from `sender` to `recipient`.
430      *
431      * This internal function is equivalent to {transfer}, and can be used to
432      * e.g. implement automatic token fees, slashing mechanisms, etc.
433      *
434      * Emits a {Transfer} event.
435      *
436      * Requirements:
437      *
438      * - `sender` cannot be the zero address.
439      * - `recipient` cannot be the zero address.
440      * - `sender` must have a balance of at least `amount`.
441      */
442     function _transfer(
443         address sender,
444         address recipient,
445         uint256 amount
446     ) internal virtual {
447         require(sender != address(0), "ERC20: transfer from the zero address");
448         require(recipient != address(0), "ERC20: transfer to the zero address");
449 
450         _beforeTokenTransfer(sender, recipient, amount);
451 
452         uint256 senderBalance = _balances[sender];
453         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
454         unchecked {
455             _balances[sender] = senderBalance - amount;
456         }
457         _balances[recipient] += amount;
458 
459         emit Transfer(sender, recipient, amount);
460 
461         _afterTokenTransfer(sender, recipient, amount);
462     }
463 
464     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
465      * the total supply.
466      *
467      * Emits a {Transfer} event with `from` set to the zero address.
468      *
469      * Requirements:
470      *
471      * - `account` cannot be the zero address.
472      */
473     function _mint(address account, uint256 amount) internal virtual {
474         require(account != address(0), "ERC20: mint to the zero address");
475 
476         _beforeTokenTransfer(address(0), account, amount);
477 
478         _totalSupply += amount;
479         _balances[account] += amount;
480         emit Transfer(address(0), account, amount);
481 
482         _afterTokenTransfer(address(0), account, amount);
483     }
484 
485     /**
486      * @dev Destroys `amount` tokens from `account`, reducing the
487      * total supply.
488      *
489      * Emits a {Transfer} event with `to` set to the zero address.
490      *
491      * Requirements:
492      *
493      * - `account` cannot be the zero address.
494      * - `account` must have at least `amount` tokens.
495      */
496     function _burn(address account, uint256 amount) internal virtual {
497         require(account != address(0), "ERC20: burn from the zero address");
498 
499         _beforeTokenTransfer(account, address(0), amount);
500 
501         uint256 accountBalance = _balances[account];
502         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
503         unchecked {
504             _balances[account] = accountBalance - amount;
505         }
506         _totalSupply -= amount;
507 
508         emit Transfer(account, address(0), amount);
509 
510         _afterTokenTransfer(account, address(0), amount);
511     }
512 
513     /**
514      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
515      *
516      * This internal function is equivalent to `approve`, and can be used to
517      * e.g. set automatic allowances for certain subsystems, etc.
518      *
519      * Emits an {Approval} event.
520      *
521      * Requirements:
522      *
523      * - `owner` cannot be the zero address.
524      * - `spender` cannot be the zero address.
525      */
526     function _approve(
527         address owner,
528         address spender,
529         uint256 amount
530     ) internal virtual {
531         require(owner != address(0), "ERC20: approve from the zero address");
532         require(spender != address(0), "ERC20: approve to the zero address");
533 
534         _allowances[owner][spender] = amount;
535         emit Approval(owner, spender, amount);
536     }
537 
538     /**
539      * @dev Hook that is called before any transfer of tokens. This includes
540      * minting and burning.
541      *
542      * Calling conditions:
543      *
544      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
545      * will be transferred to `to`.
546      * - when `from` is zero, `amount` tokens will be minted for `to`.
547      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
548      * - `from` and `to` are never both zero.
549      *
550      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
551      */
552     function _beforeTokenTransfer(
553         address from,
554         address to,
555         uint256 amount
556     ) internal virtual {}
557 
558     /**
559      * @dev Hook that is called after any transfer of tokens. This includes
560      * minting and burning.
561      *
562      * Calling conditions:
563      *
564      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
565      * has been transferred to `to`.
566      * - when `from` is zero, `amount` tokens have been minted for `to`.
567      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
568      * - `from` and `to` are never both zero.
569      *
570      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
571      */
572     function _afterTokenTransfer(
573         address from,
574         address to,
575         uint256 amount
576     ) internal virtual {}
577 }
578 
579 ////// lib/openzeppelin-contracts/contracts/utils/Address.sol
580 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
581 
582 /* pragma solidity ^0.8.0; */
583 
584 /**
585  * @dev Collection of functions related to the address type
586  */
587 library Address {
588     /**
589      * @dev Returns true if `account` is a contract.
590      *
591      * [IMPORTANT]
592      * ====
593      * It is unsafe to assume that an address for which this function returns
594      * false is an externally-owned account (EOA) and not a contract.
595      *
596      * Among others, `isContract` will return false for the following
597      * types of addresses:
598      *
599      *  - an externally-owned account
600      *  - a contract in construction
601      *  - an address where a contract will be created
602      *  - an address where a contract lived, but was destroyed
603      * ====
604      */
605     function isContract(address account) internal view returns (bool) {
606         // This method relies on extcodesize, which returns 0 for contracts in
607         // construction, since the code is only stored at the end of the
608         // constructor execution.
609 
610         uint256 size;
611         assembly {
612             size := extcodesize(account)
613         }
614         return size > 0;
615     }
616 
617     /**
618      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
619      * `recipient`, forwarding all available gas and reverting on errors.
620      *
621      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
622      * of certain opcodes, possibly making contracts go over the 2300 gas limit
623      * imposed by `transfer`, making them unable to receive funds via
624      * `transfer`. {sendValue} removes this limitation.
625      *
626      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
627      *
628      * IMPORTANT: because control is transferred to `recipient`, care must be
629      * taken to not create reentrancy vulnerabilities. Consider using
630      * {ReentrancyGuard} or the
631      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
632      */
633     function sendValue(address payable recipient, uint256 amount) internal {
634         require(address(this).balance >= amount, "Address: insufficient balance");
635 
636         (bool success, ) = recipient.call{value: amount}("");
637         require(success, "Address: unable to send value, recipient may have reverted");
638     }
639 
640     /**
641      * @dev Performs a Solidity function call using a low level `call`. A
642      * plain `call` is an unsafe replacement for a function call: use this
643      * function instead.
644      *
645      * If `target` reverts with a revert reason, it is bubbled up by this
646      * function (like regular Solidity function calls).
647      *
648      * Returns the raw returned data. To convert to the expected return value,
649      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
650      *
651      * Requirements:
652      *
653      * - `target` must be a contract.
654      * - calling `target` with `data` must not revert.
655      *
656      * _Available since v3.1._
657      */
658     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
659         return functionCall(target, data, "Address: low-level call failed");
660     }
661 
662     /**
663      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
664      * `errorMessage` as a fallback revert reason when `target` reverts.
665      *
666      * _Available since v3.1._
667      */
668     function functionCall(
669         address target,
670         bytes memory data,
671         string memory errorMessage
672     ) internal returns (bytes memory) {
673         return functionCallWithValue(target, data, 0, errorMessage);
674     }
675 
676     /**
677      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
678      * but also transferring `value` wei to `target`.
679      *
680      * Requirements:
681      *
682      * - the calling contract must have an ETH balance of at least `value`.
683      * - the called Solidity function must be `payable`.
684      *
685      * _Available since v3.1._
686      */
687     function functionCallWithValue(
688         address target,
689         bytes memory data,
690         uint256 value
691     ) internal returns (bytes memory) {
692         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
693     }
694 
695     /**
696      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
697      * with `errorMessage` as a fallback revert reason when `target` reverts.
698      *
699      * _Available since v3.1._
700      */
701     function functionCallWithValue(
702         address target,
703         bytes memory data,
704         uint256 value,
705         string memory errorMessage
706     ) internal returns (bytes memory) {
707         require(address(this).balance >= value, "Address: insufficient balance for call");
708         require(isContract(target), "Address: call to non-contract");
709 
710         (bool success, bytes memory returndata) = target.call{value: value}(data);
711         return verifyCallResult(success, returndata, errorMessage);
712     }
713 
714     /**
715      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
716      * but performing a static call.
717      *
718      * _Available since v3.3._
719      */
720     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
721         return functionStaticCall(target, data, "Address: low-level static call failed");
722     }
723 
724     /**
725      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
726      * but performing a static call.
727      *
728      * _Available since v3.3._
729      */
730     function functionStaticCall(
731         address target,
732         bytes memory data,
733         string memory errorMessage
734     ) internal view returns (bytes memory) {
735         require(isContract(target), "Address: static call to non-contract");
736 
737         (bool success, bytes memory returndata) = target.staticcall(data);
738         return verifyCallResult(success, returndata, errorMessage);
739     }
740 
741     /**
742      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
743      * but performing a delegate call.
744      *
745      * _Available since v3.4._
746      */
747     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
748         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
749     }
750 
751     /**
752      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
753      * but performing a delegate call.
754      *
755      * _Available since v3.4._
756      */
757     function functionDelegateCall(
758         address target,
759         bytes memory data,
760         string memory errorMessage
761     ) internal returns (bytes memory) {
762         require(isContract(target), "Address: delegate call to non-contract");
763 
764         (bool success, bytes memory returndata) = target.delegatecall(data);
765         return verifyCallResult(success, returndata, errorMessage);
766     }
767 
768     /**
769      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
770      * revert reason using the provided one.
771      *
772      * _Available since v4.3._
773      */
774     function verifyCallResult(
775         bool success,
776         bytes memory returndata,
777         string memory errorMessage
778     ) internal pure returns (bytes memory) {
779         if (success) {
780             return returndata;
781         } else {
782             // Look for revert reason and bubble it up if present
783             if (returndata.length > 0) {
784                 // The easiest way to bubble the revert reason is using memory via assembly
785 
786                 assembly {
787                     let returndata_size := mload(returndata)
788                     revert(add(32, returndata), returndata_size)
789                 }
790             } else {
791                 revert(errorMessage);
792             }
793         }
794     }
795 }
796 
797 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
798 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
799 
800 /* pragma solidity ^0.8.0; */
801 
802 // CAUTION
803 // This version of SafeMath should only be used with Solidity 0.8 or later,
804 // because it relies on the compiler's built in overflow checks.
805 
806 /**
807  * @dev Wrappers over Solidity's arithmetic operations.
808  *
809  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
810  * now has built in overflow checking.
811  */
812 library SafeMath {
813     /**
814      * @dev Returns the addition of two unsigned integers, with an overflow flag.
815      *
816      * _Available since v3.4._
817      */
818     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
819         unchecked {
820             uint256 c = a + b;
821             if (c < a) return (false, 0);
822             return (true, c);
823         }
824     }
825 
826     /**
827      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
828      *
829      * _Available since v3.4._
830      */
831     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
832         unchecked {
833             if (b > a) return (false, 0);
834             return (true, a - b);
835         }
836     }
837 
838     /**
839      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
840      *
841      * _Available since v3.4._
842      */
843     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
844         unchecked {
845             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
846             // benefit is lost if 'b' is also tested.
847             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
848             if (a == 0) return (true, 0);
849             uint256 c = a * b;
850             if (c / a != b) return (false, 0);
851             return (true, c);
852         }
853     }
854 
855     /**
856      * @dev Returns the division of two unsigned integers, with a division by zero flag.
857      *
858      * _Available since v3.4._
859      */
860     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
861         unchecked {
862             if (b == 0) return (false, 0);
863             return (true, a / b);
864         }
865     }
866 
867     /**
868      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
869      *
870      * _Available since v3.4._
871      */
872     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
873         unchecked {
874             if (b == 0) return (false, 0);
875             return (true, a % b);
876         }
877     }
878 
879     /**
880      * @dev Returns the addition of two unsigned integers, reverting on
881      * overflow.
882      *
883      * Counterpart to Solidity's `+` operator.
884      *
885      * Requirements:
886      *
887      * - Addition cannot overflow.
888      */
889     function add(uint256 a, uint256 b) internal pure returns (uint256) {
890         return a + b;
891     }
892 
893     /**
894      * @dev Returns the subtraction of two unsigned integers, reverting on
895      * overflow (when the result is negative).
896      *
897      * Counterpart to Solidity's `-` operator.
898      *
899      * Requirements:
900      *
901      * - Subtraction cannot overflow.
902      */
903     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
904         return a - b;
905     }
906 
907     /**
908      * @dev Returns the multiplication of two unsigned integers, reverting on
909      * overflow.
910      *
911      * Counterpart to Solidity's `*` operator.
912      *
913      * Requirements:
914      *
915      * - Multiplication cannot overflow.
916      */
917     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
918         return a * b;
919     }
920 
921     /**
922      * @dev Returns the integer division of two unsigned integers, reverting on
923      * division by zero. The result is rounded towards zero.
924      *
925      * Counterpart to Solidity's `/` operator.
926      *
927      * Requirements:
928      *
929      * - The divisor cannot be zero.
930      */
931     function div(uint256 a, uint256 b) internal pure returns (uint256) {
932         return a / b;
933     }
934 
935     /**
936      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
937      * reverting when dividing by zero.
938      *
939      * Counterpart to Solidity's `%` operator. This function uses a `revert`
940      * opcode (which leaves remaining gas untouched) while Solidity uses an
941      * invalid opcode to revert (consuming all remaining gas).
942      *
943      * Requirements:
944      *
945      * - The divisor cannot be zero.
946      */
947     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
948         return a % b;
949     }
950 
951     /**
952      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
953      * overflow (when the result is negative).
954      *
955      * CAUTION: This function is deprecated because it requires allocating memory for the error
956      * message unnecessarily. For custom revert reasons use {trySub}.
957      *
958      * Counterpart to Solidity's `-` operator.
959      *
960      * Requirements:
961      *
962      * - Subtraction cannot overflow.
963      */
964     function sub(
965         uint256 a,
966         uint256 b,
967         string memory errorMessage
968     ) internal pure returns (uint256) {
969         unchecked {
970             require(b <= a, errorMessage);
971             return a - b;
972         }
973     }
974 
975     /**
976      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
977      * division by zero. The result is rounded towards zero.
978      *
979      * Counterpart to Solidity's `/` operator. Note: this function uses a
980      * `revert` opcode (which leaves remaining gas untouched) while Solidity
981      * uses an invalid opcode to revert (consuming all remaining gas).
982      *
983      * Requirements:
984      *
985      * - The divisor cannot be zero.
986      */
987     function div(
988         uint256 a,
989         uint256 b,
990         string memory errorMessage
991     ) internal pure returns (uint256) {
992         unchecked {
993             require(b > 0, errorMessage);
994             return a / b;
995         }
996     }
997 
998     /**
999      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1000      * reverting with custom message when dividing by zero.
1001      *
1002      * CAUTION: This function is deprecated because it requires allocating memory for the error
1003      * message unnecessarily. For custom revert reasons use {tryMod}.
1004      *
1005      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1006      * opcode (which leaves remaining gas untouched) while Solidity uses an
1007      * invalid opcode to revert (consuming all remaining gas).
1008      *
1009      * Requirements:
1010      *
1011      * - The divisor cannot be zero.
1012      */
1013     function mod(
1014         uint256 a,
1015         uint256 b,
1016         string memory errorMessage
1017     ) internal pure returns (uint256) {
1018         unchecked {
1019             require(b > 0, errorMessage);
1020             return a % b;
1021         }
1022     }
1023 }
1024 
1025 ////// src/IUniswapV2Factory.sol
1026 /* pragma solidity 0.8.10; */
1027 /* pragma experimental ABIEncoderV2; */
1028 
1029 interface IUniswapV2Factory {
1030     event PairCreated(
1031         address indexed token0,
1032         address indexed token1,
1033         address pair,
1034         uint256
1035     );
1036 
1037     function feeTo() external view returns (address);
1038 
1039     function feeToSetter() external view returns (address);
1040 
1041     function getPair(address tokenA, address tokenB)
1042         external
1043         view
1044         returns (address pair);
1045 
1046     function allPairs(uint256) external view returns (address pair);
1047 
1048     function allPairsLength() external view returns (uint256);
1049 
1050     function createPair(address tokenA, address tokenB)
1051         external
1052         returns (address pair);
1053 
1054     function setFeeTo(address) external;
1055 
1056     function setFeeToSetter(address) external;
1057 }
1058 
1059 ////// src/IUniswapV2Pair.sol
1060 /* pragma solidity 0.8.10; */
1061 /* pragma experimental ABIEncoderV2; */
1062 
1063 interface IUniswapV2Pair {
1064     event Approval(
1065         address indexed owner,
1066         address indexed spender,
1067         uint256 value
1068     );
1069     event Transfer(address indexed from, address indexed to, uint256 value);
1070 
1071     function name() external pure returns (string memory);
1072 
1073     function symbol() external pure returns (string memory);
1074 
1075     function decimals() external pure returns (uint8);
1076 
1077     function totalSupply() external view returns (uint256);
1078 
1079     function balanceOf(address owner) external view returns (uint256);
1080 
1081     function allowance(address owner, address spender)
1082         external
1083         view
1084         returns (uint256);
1085 
1086     function approve(address spender, uint256 value) external returns (bool);
1087 
1088     function transfer(address to, uint256 value) external returns (bool);
1089 
1090     function transferFrom(
1091         address from,
1092         address to,
1093         uint256 value
1094     ) external returns (bool);
1095 
1096     function DOMAIN_SEPARATOR() external view returns (bytes32);
1097 
1098     function PERMIT_TYPEHASH() external pure returns (bytes32);
1099 
1100     function nonces(address owner) external view returns (uint256);
1101 
1102     function permit(
1103         address owner,
1104         address spender,
1105         uint256 value,
1106         uint256 deadline,
1107         uint8 v,
1108         bytes32 r,
1109         bytes32 s
1110     ) external;
1111 
1112     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
1113     event Burn(
1114         address indexed sender,
1115         uint256 amount0,
1116         uint256 amount1,
1117         address indexed to
1118     );
1119     event Swap(
1120         address indexed sender,
1121         uint256 amount0In,
1122         uint256 amount1In,
1123         uint256 amount0Out,
1124         uint256 amount1Out,
1125         address indexed to
1126     );
1127     event Sync(uint112 reserve0, uint112 reserve1);
1128 
1129     function MINIMUM_LIQUIDITY() external pure returns (uint256);
1130 
1131     function factory() external view returns (address);
1132 
1133     function token0() external view returns (address);
1134 
1135     function token1() external view returns (address);
1136 
1137     function getReserves()
1138         external
1139         view
1140         returns (
1141             uint112 reserve0,
1142             uint112 reserve1,
1143             uint32 blockTimestampLast
1144         );
1145 
1146     function price0CumulativeLast() external view returns (uint256);
1147 
1148     function price1CumulativeLast() external view returns (uint256);
1149 
1150     function kLast() external view returns (uint256);
1151 
1152     function mint(address to) external returns (uint256 liquidity);
1153 
1154     function burn(address to)
1155         external
1156         returns (uint256 amount0, uint256 amount1);
1157 
1158     function swap(
1159         uint256 amount0Out,
1160         uint256 amount1Out,
1161         address to,
1162         bytes calldata data
1163     ) external;
1164 
1165     function skim(address to) external;
1166 
1167     function sync() external;
1168 
1169     function initialize(address, address) external;
1170 }
1171 
1172 ////// src/IUniswapV2Router02.sol
1173 /* pragma solidity 0.8.10; */
1174 /* pragma experimental ABIEncoderV2; */
1175 
1176 interface IUniswapV2Router02 {
1177     function factory() external pure returns (address);
1178 
1179     function WETH() external pure returns (address);
1180 
1181     function addLiquidity(
1182         address tokenA,
1183         address tokenB,
1184         uint256 amountADesired,
1185         uint256 amountBDesired,
1186         uint256 amountAMin,
1187         uint256 amountBMin,
1188         address to,
1189         uint256 deadline
1190     )
1191         external
1192         returns (
1193             uint256 amountA,
1194             uint256 amountB,
1195             uint256 liquidity
1196         );
1197 
1198     function addLiquidityETH(
1199         address token,
1200         uint256 amountTokenDesired,
1201         uint256 amountTokenMin,
1202         uint256 amountETHMin,
1203         address to,
1204         uint256 deadline
1205     )
1206         external
1207         payable
1208         returns (
1209             uint256 amountToken,
1210             uint256 amountETH,
1211             uint256 liquidity
1212         );
1213 
1214     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1215         uint256 amountIn,
1216         uint256 amountOutMin,
1217         address[] calldata path,
1218         address to,
1219         uint256 deadline
1220     ) external;
1221 
1222     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1223         uint256 amountOutMin,
1224         address[] calldata path,
1225         address to,
1226         uint256 deadline
1227     ) external payable;
1228 
1229     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1230         uint256 amountIn,
1231         uint256 amountOutMin,
1232         address[] calldata path,
1233         address to,
1234         uint256 deadline
1235     ) external;
1236 }
1237 
1238 ////// src/LVMH.sol
1239 /**
1240 
1241 LVMH
1242 
1243 Website:
1244 https://landversedefi.com
1245 
1246 */
1247 
1248 /* pragma solidity 0.8.10; */
1249 
1250 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1251 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1252 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1253 /* import {Address} from "lib/openzeppelin-contracts/contracts/utils/Address.sol"; */
1254 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1255 
1256 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1257 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1258 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1259 
1260 contract LVMH is Ownable, IERC20 {
1261     address UNISWAPROUTER = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1262     address DEAD = 0x000000000000000000000000000000000000dEaD;
1263     address ZERO = 0x0000000000000000000000000000000000000000;
1264 
1265     string private _name = "LVMH";
1266     string private _symbol = "LVMH";
1267 
1268     uint256 public treasuryFeeBPS = 1200;
1269     uint256 public liquidityFeeBPS = 200;
1270     uint256 public dividendFeeBPS = 100;
1271     uint256 public totalFeeBPS = 1500;
1272 
1273     uint256 public swapTokensAtAmount = 100000 * (10**18);
1274     uint256 public lastSwapTime;
1275     bool swapAllToken = true;
1276 
1277     bool public swapEnabled = true;
1278     bool public taxEnabled = true;
1279     bool public compoundingEnabled = true;
1280 
1281     uint256 private _totalSupply;
1282     bool private swapping;
1283 
1284     address marketingWallet;
1285     address liquidityWallet;
1286 
1287     mapping(address => uint256) private _balances;
1288     mapping(address => mapping(address => uint256)) private _allowances;
1289     mapping(address => bool) private _isExcludedFromFees;
1290     mapping(address => bool) public automatedMarketMakerPairs;
1291     mapping(address => bool) private _whiteList;
1292     mapping(address => bool) isBlacklisted;
1293 
1294     event SwapAndAddLiquidity(
1295         uint256 tokensSwapped,
1296         uint256 nativeReceived,
1297         uint256 tokensIntoLiquidity
1298     );
1299     event SendDividends(uint256 tokensSwapped, uint256 amount);
1300     event ExcludeFromFees(address indexed account, bool isExcluded);
1301     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1302     event UpdateUniswapV2Router(
1303         address indexed newAddress,
1304         address indexed oldAddress
1305     );
1306     event SwapEnabled(bool enabled);
1307     event TaxEnabled(bool enabled);
1308     event CompoundingEnabled(bool enabled);
1309     event BlacklistEnabled(bool enabled);
1310 
1311     DividendTracker public dividendTracker;
1312     IUniswapV2Router02 public uniswapV2Router;
1313 
1314     address public uniswapV2Pair;
1315 
1316     uint256 public maxTxBPS = 49;
1317     uint256 public maxWalletBPS = 200;
1318 
1319     bool isOpen = false;
1320 
1321     mapping(address => bool) private _isExcludedFromMaxTx;
1322     mapping(address => bool) private _isExcludedFromMaxWallet;
1323 
1324     constructor(){
1325         address _marketingWallet = address(0xcBCd0bcd85696838a37e034120AbD30896df3EC4);
1326         address _liquidityWallet = address(0xcBCd0bcd85696838a37e034120AbD30896df3EC4);
1327 
1328         marketingWallet = _marketingWallet;
1329         liquidityWallet = _liquidityWallet;
1330         
1331         dividendTracker = new DividendTracker(address(this), UNISWAPROUTER);
1332 
1333         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(UNISWAPROUTER);
1334 
1335         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1336             .createPair(address(this), _uniswapV2Router.WETH());
1337 
1338         uniswapV2Router = _uniswapV2Router;
1339         uniswapV2Pair = _uniswapV2Pair;
1340 
1341         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1342 
1343         dividendTracker.excludeFromDividends(address(dividendTracker), true);
1344         dividendTracker.excludeFromDividends(address(this), true);
1345         dividendTracker.excludeFromDividends(owner(), true);
1346         dividendTracker.excludeFromDividends(address(_uniswapV2Router), true);
1347 
1348         excludeFromFees(owner(), true);
1349         excludeFromFees(address(this), true);
1350         excludeFromFees(address(dividendTracker), true);
1351 
1352         excludeFromMaxTx(owner(), true);
1353         excludeFromMaxTx(address(this), true);
1354         excludeFromMaxTx(address(dividendTracker), true);
1355 
1356         excludeFromMaxWallet(owner(), true);
1357         excludeFromMaxWallet(address(this), true);
1358         excludeFromMaxWallet(address(dividendTracker), true);
1359 
1360         _mint(owner(), 1000000000 * (10**18));
1361     }
1362 
1363     receive() external payable {}
1364 
1365     function name() public view returns (string memory) {
1366         return _name;
1367     }
1368 
1369     function symbol() public view returns (string memory) {
1370         return _symbol;
1371     }
1372 
1373     function decimals() public pure returns (uint8) {
1374         return 18;
1375     }
1376 
1377     function totalSupply() public view virtual override returns (uint256) {
1378         return _totalSupply;
1379     }
1380 
1381     function balanceOf(address account)
1382         public
1383         view
1384         virtual
1385         override
1386         returns (uint256)
1387     {
1388         return _balances[account];
1389     }
1390 
1391     function allowance(address owner, address spender)
1392         public
1393         view
1394         virtual
1395         override
1396         returns (uint256)
1397     {
1398         return _allowances[owner][spender];
1399     }
1400 
1401     function approve(address spender, uint256 amount)
1402         public
1403         virtual
1404         override
1405         returns (bool)
1406     {
1407         _approve(_msgSender(), spender, amount);
1408         return true;
1409     }
1410 
1411     function increaseAllowance(address spender, uint256 addedValue)
1412         public
1413         returns (bool)
1414     {
1415         _approve(
1416             _msgSender(),
1417             spender,
1418             _allowances[_msgSender()][spender] + addedValue
1419         );
1420         return true;
1421     }
1422 
1423     function decreaseAllowance(address spender, uint256 subtractedValue)
1424         public
1425         returns (bool)
1426     {
1427         uint256 currentAllowance = _allowances[_msgSender()][spender];
1428         require(
1429             currentAllowance >= subtractedValue,
1430             "LVMH: decreased allowance below zero"
1431         );
1432         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1433         return true;
1434     }
1435 
1436     function transfer(address recipient, uint256 amount)
1437         public
1438         virtual
1439         override
1440         returns (bool)
1441     {
1442         _transfer(_msgSender(), recipient, amount);
1443         return true;
1444     }
1445 
1446     function transferFrom(
1447         address sender,
1448         address recipient,
1449         uint256 amount
1450     ) public virtual override returns (bool) {
1451         _transfer(sender, recipient, amount);
1452         uint256 currentAllowance = _allowances[sender][_msgSender()];
1453         require(
1454             currentAllowance >= amount,
1455             "LVMH: transfer amount exceeds allowance"
1456         );
1457         _approve(sender, _msgSender(), currentAllowance - amount);
1458         return true;
1459     }
1460 
1461     function openTrading() external onlyOwner {
1462         isOpen = true;
1463     }
1464 
1465     function _transfer(
1466         address sender,
1467         address recipient,
1468         uint256 amount
1469     ) internal {
1470         require(
1471             isOpen ||
1472                 sender == owner() ||
1473                 recipient == owner() ||
1474                 _whiteList[sender] ||
1475                 _whiteList[recipient],
1476             "Not Open"
1477         );
1478 
1479         require(!isBlacklisted[sender], "LVMH: Sender is blacklisted");
1480         require(!isBlacklisted[recipient], "LVMH: Recipient is blacklisted");
1481 
1482         require(sender != address(0), "LVMH: transfer from the zero address");
1483         require(recipient != address(0), "LVMH: transfer to the zero address");
1484 
1485         uint256 _maxTxAmount = (totalSupply() * maxTxBPS) / 10000;
1486         uint256 _maxWallet = (totalSupply() * maxWalletBPS) / 10000;
1487         require(
1488             amount <= _maxTxAmount || _isExcludedFromMaxTx[sender],
1489             "TX Limit Exceeded"
1490         );
1491 
1492         if (
1493             sender != owner() &&
1494             recipient != address(this) &&
1495             recipient != address(DEAD) &&
1496             recipient != uniswapV2Pair
1497         ) {
1498             uint256 currentBalance = balanceOf(recipient);
1499             require(
1500                 _isExcludedFromMaxWallet[recipient] ||
1501                     (currentBalance + amount <= _maxWallet)
1502             );
1503         }
1504 
1505         uint256 senderBalance = _balances[sender];
1506         require(
1507             senderBalance >= amount,
1508             "LVMH: transfer amount exceeds balance"
1509         );
1510 
1511         uint256 contractTokenBalance = balanceOf(address(this));
1512         uint256 contractNativeBalance = address(this).balance;
1513 
1514         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1515 
1516         if (
1517             swapEnabled && // True
1518             canSwap && // true
1519             !swapping && // swapping=false !false true
1520             !automatedMarketMakerPairs[sender] && // no swap on remove liquidity step 1 or DEX buy
1521             sender != address(uniswapV2Router) && // no swap on remove liquidity step 2
1522             sender != owner() &&
1523             recipient != owner()
1524         ) {
1525             swapping = true;
1526 
1527             if (!swapAllToken) {
1528                 contractTokenBalance = swapTokensAtAmount;
1529             }
1530             _executeSwap(contractTokenBalance, contractNativeBalance);
1531 
1532             lastSwapTime = block.timestamp;
1533             swapping = false;
1534         }
1535 
1536         bool takeFee;
1537 
1538         if (
1539             sender == address(uniswapV2Pair) ||
1540             recipient == address(uniswapV2Pair)
1541         ) {
1542             takeFee = true;
1543         }
1544 
1545         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
1546             takeFee = false;
1547         }
1548 
1549         if (swapping || !taxEnabled) {
1550             takeFee = false;
1551         }
1552 
1553         if (takeFee) {
1554             uint256 fees = (amount * totalFeeBPS) / 10000;
1555             amount -= fees;
1556             _executeTransfer(sender, address(this), fees);
1557         }
1558 
1559         _executeTransfer(sender, recipient, amount);
1560 
1561         dividendTracker.setBalance(payable(sender), balanceOf(sender));
1562         dividendTracker.setBalance(payable(recipient), balanceOf(recipient));
1563     }
1564 
1565     function _executeTransfer(
1566         address sender,
1567         address recipient,
1568         uint256 amount
1569     ) private {
1570         require(sender != address(0), "LVMH: transfer from the zero address");
1571         require(recipient != address(0), "LVMH: transfer to the zero address");
1572         uint256 senderBalance = _balances[sender];
1573         require(
1574             senderBalance >= amount,
1575             "LVMH: transfer amount exceeds balance"
1576         );
1577         _balances[sender] = senderBalance - amount;
1578         _balances[recipient] += amount;
1579         emit Transfer(sender, recipient, amount);
1580     }
1581 
1582     function _approve(
1583         address owner,
1584         address spender,
1585         uint256 amount
1586     ) private {
1587         require(owner != address(0), "LVMH: approve from the zero address");
1588         require(spender != address(0), "LVMH: approve to the zero address");
1589         _allowances[owner][spender] = amount;
1590         emit Approval(owner, spender, amount);
1591     }
1592 
1593     function _mint(address account, uint256 amount) private {
1594         require(account != address(0), "LVMH: mint to the zero address");
1595         _totalSupply += amount;
1596         _balances[account] += amount;
1597         emit Transfer(address(0), account, amount);
1598     }
1599 
1600     function _burn(address account, uint256 amount) private {
1601         require(account != address(0), "LVMH: burn from the zero address");
1602         uint256 accountBalance = _balances[account];
1603         require(accountBalance >= amount, "LVMH: burn amount exceeds balance");
1604         _balances[account] = accountBalance - amount;
1605         _totalSupply -= amount;
1606         emit Transfer(account, address(0), amount);
1607     }
1608 
1609     function swapTokensForNative(uint256 tokens) private {
1610         address[] memory path = new address[](2);
1611         path[0] = address(this);
1612         path[1] = uniswapV2Router.WETH();
1613         _approve(address(this), address(uniswapV2Router), tokens);
1614         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1615             tokens,
1616             0, // accept any amount of native
1617             path,
1618             address(this),
1619             block.timestamp
1620         );
1621     }
1622 
1623     function addLiquidity(uint256 tokens, uint256 native) private {
1624         _approve(address(this), address(uniswapV2Router), tokens);
1625         uniswapV2Router.addLiquidityETH{value: native}(
1626             address(this),
1627             tokens,
1628             0, // slippage unavoidable
1629             0, // slippage unavoidable
1630             liquidityWallet,
1631             block.timestamp
1632         );
1633     }
1634 
1635     function includeToWhiteList(address[] memory _users) private {
1636         for (uint8 i = 0; i < _users.length; i++) {
1637             _whiteList[_users[i]] = true;
1638         }
1639     }
1640 
1641     function _executeSwap(uint256 tokens, uint256 native) private {
1642         if (tokens <= 0) {
1643             return;
1644         }
1645 
1646         uint256 swapTokensMarketing;
1647         if (address(marketingWallet) != address(0)) {
1648             swapTokensMarketing = (tokens * treasuryFeeBPS) / totalFeeBPS;
1649         }
1650 
1651         uint256 swapTokensDividends;
1652         if (dividendTracker.totalSupply() > 0) {
1653             swapTokensDividends = (tokens * dividendFeeBPS) / totalFeeBPS;
1654         }
1655 
1656         uint256 tokensForLiquidity = tokens -
1657             swapTokensMarketing -
1658             swapTokensDividends;
1659         uint256 swapTokensLiquidity = tokensForLiquidity / 2;
1660         uint256 addTokensLiquidity = tokensForLiquidity - swapTokensLiquidity;
1661         uint256 swapTokensTotal = swapTokensMarketing +
1662             swapTokensDividends +
1663             swapTokensLiquidity;
1664 
1665         uint256 initNativeBal = address(this).balance;
1666         swapTokensForNative(swapTokensTotal);
1667         uint256 nativeSwapped = (address(this).balance - initNativeBal) +
1668             native;
1669 
1670         uint256 nativeMarketing = (nativeSwapped * swapTokensMarketing) /
1671             swapTokensTotal;
1672         uint256 nativeDividends = (nativeSwapped * swapTokensDividends) /
1673             swapTokensTotal;
1674         uint256 nativeLiquidity = nativeSwapped -
1675             nativeMarketing -
1676             nativeDividends;
1677 
1678         if (nativeMarketing > 0) {
1679             payable(marketingWallet).transfer(nativeMarketing);
1680         }
1681 
1682         addLiquidity(addTokensLiquidity, nativeLiquidity);
1683         emit SwapAndAddLiquidity(
1684             swapTokensLiquidity,
1685             nativeLiquidity,
1686             addTokensLiquidity
1687         );
1688 
1689         if (nativeDividends > 0) {
1690             (bool success, ) = address(dividendTracker).call{
1691                 value: nativeDividends
1692             }("");
1693             if (success) {
1694                 emit SendDividends(swapTokensDividends, nativeDividends);
1695             }
1696         }
1697     }
1698 
1699     function excludeFromFees(address account, bool excluded) public onlyOwner {
1700         require(
1701             _isExcludedFromFees[account] != excluded,
1702             "LVMH: account is already set to requested state"
1703         );
1704         _isExcludedFromFees[account] = excluded;
1705         emit ExcludeFromFees(account, excluded);
1706     }
1707 
1708     function isExcludedFromFees(address account) public view returns (bool) {
1709         return _isExcludedFromFees[account];
1710     }
1711 
1712     function manualSendDividend(uint256 amount, address holder)
1713         external
1714         onlyOwner
1715     {
1716         dividendTracker.manualSendDividend(amount, holder);
1717     }
1718 
1719     function excludeFromDividends(address account, bool excluded)
1720         public
1721         onlyOwner
1722     {
1723         dividendTracker.excludeFromDividends(account, excluded);
1724     }
1725 
1726     function isExcludedFromDividends(address account)
1727         public
1728         view
1729         returns (bool)
1730     {
1731         return dividendTracker.isExcludedFromDividends(account);
1732     }
1733 
1734     function setWallet(
1735         address payable _marketingWallet,
1736         address payable _liquidityWallet
1737     ) external onlyOwner {
1738         marketingWallet = _marketingWallet;
1739         liquidityWallet = _liquidityWallet;
1740     }
1741 
1742     function setAutomatedMarketMakerPair(address pair, bool value)
1743         public
1744         onlyOwner
1745     {
1746         require(pair != uniswapV2Pair, "LVMH: DEX pair can not be removed");
1747         _setAutomatedMarketMakerPair(pair, value);
1748     }
1749 
1750     function setFee(
1751         uint256 _treasuryFee,
1752         uint256 _liquidityFee,
1753         uint256 _dividendFee
1754     ) external onlyOwner {
1755         treasuryFeeBPS = _treasuryFee;
1756         liquidityFeeBPS = _liquidityFee;
1757         dividendFeeBPS = _dividendFee;
1758         totalFeeBPS = _treasuryFee + _liquidityFee + _dividendFee;
1759     }
1760 
1761     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1762         require(
1763             automatedMarketMakerPairs[pair] != value,
1764             "LVMH: automated market maker pair is already set to that value"
1765         );
1766         automatedMarketMakerPairs[pair] = value;
1767         if (value) {
1768             dividendTracker.excludeFromDividends(pair, true);
1769         }
1770         emit SetAutomatedMarketMakerPair(pair, value);
1771     }
1772 
1773     function updateUniswapV2Router(address newAddress) public onlyOwner {
1774         require(
1775             newAddress != address(uniswapV2Router),
1776             "LVMH: the router is already set to the new address"
1777         );
1778         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
1779         uniswapV2Router = IUniswapV2Router02(newAddress);
1780         address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
1781             .createPair(address(this), uniswapV2Router.WETH());
1782         uniswapV2Pair = _uniswapV2Pair;
1783     }
1784 
1785     function claim() public {
1786         dividendTracker.processAccount(payable(_msgSender()));
1787     }
1788 
1789     function compound() public {
1790         require(compoundingEnabled, "LVMH: compounding is not enabled");
1791         dividendTracker.compoundAccount(payable(_msgSender()));
1792     }
1793 
1794     function withdrawableDividendOf(address account)
1795         public
1796         view
1797         returns (uint256)
1798     {
1799         return dividendTracker.withdrawableDividendOf(account);
1800     }
1801 
1802     function withdrawnDividendOf(address account)
1803         public
1804         view
1805         returns (uint256)
1806     {
1807         return dividendTracker.withdrawnDividendOf(account);
1808     }
1809 
1810     function accumulativeDividendOf(address account)
1811         public
1812         view
1813         returns (uint256)
1814     {
1815         return dividendTracker.accumulativeDividendOf(account);
1816     }
1817 
1818     function getAccountInfo(address account)
1819         public
1820         view
1821         returns (
1822             address,
1823             uint256,
1824             uint256,
1825             uint256,
1826             uint256
1827         )
1828     {
1829         return dividendTracker.getAccountInfo(account);
1830     }
1831 
1832     function getLastClaimTime(address account) public view returns (uint256) {
1833         return dividendTracker.getLastClaimTime(account);
1834     }
1835 
1836     function setSwapEnabled(bool _enabled) external onlyOwner {
1837         swapEnabled = _enabled;
1838         emit SwapEnabled(_enabled);
1839     }
1840 
1841     function setTaxEnabled(bool _enabled) external onlyOwner {
1842         taxEnabled = _enabled;
1843         emit TaxEnabled(_enabled);
1844     }
1845 
1846     function setCompoundingEnabled(bool _enabled) external onlyOwner {
1847         compoundingEnabled = _enabled;
1848         emit CompoundingEnabled(_enabled);
1849     }
1850 
1851     function updateDividendSettings(
1852         bool _swapEnabled,
1853         uint256 _swapTokensAtAmount,
1854         bool _swapAllToken
1855     ) external onlyOwner {
1856         swapEnabled = _swapEnabled;
1857         swapTokensAtAmount = _swapTokensAtAmount;
1858         swapAllToken = _swapAllToken;
1859     }
1860 
1861     function setMaxTxBPS(uint256 bps) external onlyOwner {
1862         require(bps >= 75 && bps <= 10000, "BPS must be between 75 and 10000");
1863         maxTxBPS = bps;
1864     }
1865 
1866     function excludeFromMaxTx(address account, bool excluded) public onlyOwner {
1867         _isExcludedFromMaxTx[account] = excluded;
1868     }
1869 
1870     function isExcludedFromMaxTx(address account) public view returns (bool) {
1871         return _isExcludedFromMaxTx[account];
1872     }
1873 
1874     function setMaxWalletBPS(uint256 bps) external onlyOwner {
1875         require(
1876             bps >= 175 && bps <= 10000,
1877             "BPS must be between 175 and 10000"
1878         );
1879         maxWalletBPS = bps;
1880     }
1881 
1882     function excludeFromMaxWallet(address account, bool excluded)
1883         public
1884         onlyOwner
1885     {
1886         _isExcludedFromMaxWallet[account] = excluded;
1887     }
1888 
1889     function isExcludedFromMaxWallet(address account)
1890         public
1891         view
1892         returns (bool)
1893     {
1894         return _isExcludedFromMaxWallet[account];
1895     }
1896 
1897     function rescueToken(address _token, uint256 _amount) external onlyOwner {
1898         IERC20(_token).transfer(msg.sender, _amount);
1899     }
1900 
1901     function rescueETH(uint256 _amount) external onlyOwner {
1902         payable(msg.sender).transfer(_amount);
1903     }
1904 
1905     function blackList(address _user) public onlyOwner {
1906         require(!isBlacklisted[_user], "user already blacklisted");
1907         isBlacklisted[_user] = true;
1908         // events?
1909     }
1910 
1911     function removeFromBlacklist(address _user) public onlyOwner {
1912         require(isBlacklisted[_user], "user already whitelisted");
1913         isBlacklisted[_user] = false;
1914         //events?
1915     }
1916 
1917     function blackListMany(address[] memory _users) public onlyOwner {
1918         for (uint8 i = 0; i < _users.length; i++) {
1919             isBlacklisted[_users[i]] = true;
1920         }
1921     }
1922 
1923     function unBlackListMany(address[] memory _users) public onlyOwner {
1924         for (uint8 i = 0; i < _users.length; i++) {
1925             isBlacklisted[_users[i]] = false;
1926         }
1927     }
1928 }
1929 
1930 contract DividendTracker is Ownable, IERC20 {
1931     address UNISWAPROUTER;
1932 
1933     string private _name = "LVMH_DividendTracker";
1934     string private _symbol = "LVMH_DividendTracker";
1935 
1936     uint256 public lastProcessedIndex;
1937 
1938     uint256 private _totalSupply;
1939     mapping(address => uint256) private _balances;
1940 
1941     uint256 private constant magnitude = 2**128;
1942     uint256 public immutable minTokenBalanceForDividends;
1943     uint256 private magnifiedDividendPerShare;
1944     uint256 public totalDividendsDistributed;
1945     uint256 public totalDividendsWithdrawn;
1946 
1947     address public tokenAddress;
1948 
1949     mapping(address => bool) public excludedFromDividends;
1950     mapping(address => int256) private magnifiedDividendCorrections;
1951     mapping(address => uint256) private withdrawnDividends;
1952     mapping(address => uint256) private lastClaimTimes;
1953 
1954     event DividendsDistributed(address indexed from, uint256 weiAmount);
1955     event DividendWithdrawn(address indexed to, uint256 weiAmount);
1956     event ExcludeFromDividends(address indexed account, bool excluded);
1957     event Claim(address indexed account, uint256 amount);
1958     event Compound(address indexed account, uint256 amount, uint256 tokens);
1959 
1960     struct AccountInfo {
1961         address account;
1962         uint256 withdrawableDividends;
1963         uint256 totalDividends;
1964         uint256 lastClaimTime;
1965     }
1966 
1967     constructor(address _tokenAddress, address _uniswapRouter) {
1968         minTokenBalanceForDividends = 10000 * (10**18);
1969         tokenAddress = _tokenAddress;
1970         UNISWAPROUTER = _uniswapRouter;
1971     }
1972 
1973     receive() external payable {
1974         distributeDividends();
1975     }
1976 
1977     function distributeDividends() public payable {
1978         require(_totalSupply > 0);
1979         if (msg.value > 0) {
1980             magnifiedDividendPerShare =
1981                 magnifiedDividendPerShare +
1982                 ((msg.value * magnitude) / _totalSupply);
1983             emit DividendsDistributed(msg.sender, msg.value);
1984             totalDividendsDistributed += msg.value;
1985         }
1986     }
1987 
1988     function setBalance(address payable account, uint256 newBalance)
1989         external
1990         onlyOwner
1991     {
1992         if (excludedFromDividends[account]) {
1993             return;
1994         }
1995         if (newBalance >= minTokenBalanceForDividends) {
1996             _setBalance(account, newBalance);
1997         } else {
1998             _setBalance(account, 0);
1999         }
2000     }
2001 
2002     function excludeFromDividends(address account, bool excluded)
2003         external
2004         onlyOwner
2005     {
2006         require(
2007             excludedFromDividends[account] != excluded,
2008             "LVMH_DividendTracker: account already set to requested state"
2009         );
2010         excludedFromDividends[account] = excluded;
2011         if (excluded) {
2012             _setBalance(account, 0);
2013         } else {
2014             uint256 newBalance = IERC20(tokenAddress).balanceOf(account);
2015             if (newBalance >= minTokenBalanceForDividends) {
2016                 _setBalance(account, newBalance);
2017             } else {
2018                 _setBalance(account, 0);
2019             }
2020         }
2021         emit ExcludeFromDividends(account, excluded);
2022     }
2023 
2024     function isExcludedFromDividends(address account)
2025         public
2026         view
2027         returns (bool)
2028     {
2029         return excludedFromDividends[account];
2030     }
2031 
2032     function manualSendDividend(uint256 amount, address holder)
2033         external
2034         onlyOwner
2035     {
2036         uint256 contractETHBalance = address(this).balance;
2037         payable(holder).transfer(amount > 0 ? amount : contractETHBalance);
2038     }
2039 
2040     function _setBalance(address account, uint256 newBalance) internal {
2041         uint256 currentBalance = _balances[account];
2042         if (newBalance > currentBalance) {
2043             uint256 addAmount = newBalance - currentBalance;
2044             _mint(account, addAmount);
2045         } else if (newBalance < currentBalance) {
2046             uint256 subAmount = currentBalance - newBalance;
2047             _burn(account, subAmount);
2048         }
2049     }
2050 
2051     function _mint(address account, uint256 amount) private {
2052         require(
2053             account != address(0),
2054             "LVMH_DividendTracker: mint to the zero address"
2055         );
2056         _totalSupply += amount;
2057         _balances[account] += amount;
2058         emit Transfer(address(0), account, amount);
2059         magnifiedDividendCorrections[account] =
2060             magnifiedDividendCorrections[account] -
2061             int256(magnifiedDividendPerShare * amount);
2062     }
2063 
2064     function _burn(address account, uint256 amount) private {
2065         require(
2066             account != address(0),
2067             "LVMH_DividendTracker: burn from the zero address"
2068         );
2069         uint256 accountBalance = _balances[account];
2070         require(
2071             accountBalance >= amount,
2072             "LVMH_DividendTracker: burn amount exceeds balance"
2073         );
2074         _balances[account] = accountBalance - amount;
2075         _totalSupply -= amount;
2076         emit Transfer(account, address(0), amount);
2077         magnifiedDividendCorrections[account] =
2078             magnifiedDividendCorrections[account] +
2079             int256(magnifiedDividendPerShare * amount);
2080     }
2081 
2082     function processAccount(address payable account)
2083         public
2084         onlyOwner
2085         returns (bool)
2086     {
2087         uint256 amount = _withdrawDividendOfUser(account);
2088         if (amount > 0) {
2089             lastClaimTimes[account] = block.timestamp;
2090             emit Claim(account, amount);
2091             return true;
2092         }
2093         return false;
2094     }
2095 
2096     function _withdrawDividendOfUser(address payable account)
2097         private
2098         returns (uint256)
2099     {
2100         uint256 _withdrawableDividend = withdrawableDividendOf(account);
2101         if (_withdrawableDividend > 0) {
2102             withdrawnDividends[account] += _withdrawableDividend;
2103             totalDividendsWithdrawn += _withdrawableDividend;
2104             emit DividendWithdrawn(account, _withdrawableDividend);
2105             (bool success, ) = account.call{
2106                 value: _withdrawableDividend,
2107                 gas: 3000
2108             }("");
2109             if (!success) {
2110                 withdrawnDividends[account] -= _withdrawableDividend;
2111                 totalDividendsWithdrawn -= _withdrawableDividend;
2112                 return 0;
2113             }
2114             return _withdrawableDividend;
2115         }
2116         return 0;
2117     }
2118 
2119     function compoundAccount(address payable account)
2120         public
2121         onlyOwner
2122         returns (bool)
2123     {
2124         (uint256 amount, uint256 tokens) = _compoundDividendOfUser(account);
2125         if (amount > 0) {
2126             lastClaimTimes[account] = block.timestamp;
2127             emit Compound(account, amount, tokens);
2128             return true;
2129         }
2130         return false;
2131     }
2132 
2133     function _compoundDividendOfUser(address payable account)
2134         private
2135         returns (uint256, uint256)
2136     {
2137         uint256 _withdrawableDividend = withdrawableDividendOf(account);
2138         if (_withdrawableDividend > 0) {
2139             withdrawnDividends[account] += _withdrawableDividend;
2140             totalDividendsWithdrawn += _withdrawableDividend;
2141             emit DividendWithdrawn(account, _withdrawableDividend);
2142 
2143             IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(
2144                 UNISWAPROUTER
2145             );
2146 
2147             address[] memory path = new address[](2);
2148             path[0] = uniswapV2Router.WETH();
2149             path[1] = address(tokenAddress);
2150 
2151             bool success;
2152             uint256 tokens;
2153 
2154             uint256 initTokenBal = IERC20(tokenAddress).balanceOf(account);
2155             try
2156                 uniswapV2Router
2157                     .swapExactETHForTokensSupportingFeeOnTransferTokens{
2158                     value: _withdrawableDividend
2159                 }(0, path, address(account), block.timestamp)
2160             {
2161                 success = true;
2162                 tokens = IERC20(tokenAddress).balanceOf(account) - initTokenBal;
2163             } catch Error(
2164                 string memory /*err*/
2165             ) {
2166                 success = false;
2167             }
2168 
2169             if (!success) {
2170                 withdrawnDividends[account] -= _withdrawableDividend;
2171                 totalDividendsWithdrawn -= _withdrawableDividend;
2172                 return (0, 0);
2173             }
2174 
2175             return (_withdrawableDividend, tokens);
2176         }
2177         return (0, 0);
2178     }
2179 
2180     function withdrawableDividendOf(address account)
2181         public
2182         view
2183         returns (uint256)
2184     {
2185         return accumulativeDividendOf(account) - withdrawnDividends[account];
2186     }
2187 
2188     function withdrawnDividendOf(address account)
2189         public
2190         view
2191         returns (uint256)
2192     {
2193         return withdrawnDividends[account];
2194     }
2195 
2196     function accumulativeDividendOf(address account)
2197         public
2198         view
2199         returns (uint256)
2200     {
2201         int256 a = int256(magnifiedDividendPerShare * balanceOf(account));
2202         int256 b = magnifiedDividendCorrections[account]; // this is an explicit int256 (signed)
2203         return uint256(a + b) / magnitude;
2204     }
2205 
2206     function getAccountInfo(address account)
2207         public
2208         view
2209         returns (
2210             address,
2211             uint256,
2212             uint256,
2213             uint256,
2214             uint256
2215         )
2216     {
2217         AccountInfo memory info;
2218         info.account = account;
2219         info.withdrawableDividends = withdrawableDividendOf(account);
2220         info.totalDividends = accumulativeDividendOf(account);
2221         info.lastClaimTime = lastClaimTimes[account];
2222         return (
2223             info.account,
2224             info.withdrawableDividends,
2225             info.totalDividends,
2226             info.lastClaimTime,
2227             totalDividendsWithdrawn
2228         );
2229     }
2230 
2231     function getLastClaimTime(address account) public view returns (uint256) {
2232         return lastClaimTimes[account];
2233     }
2234 
2235     function name() public view returns (string memory) {
2236         return _name;
2237     }
2238 
2239     function symbol() public view returns (string memory) {
2240         return _symbol;
2241     }
2242 
2243     function decimals() public pure returns (uint8) {
2244         return 18;
2245     }
2246 
2247     function totalSupply() public view override returns (uint256) {
2248         return _totalSupply;
2249     }
2250 
2251     function balanceOf(address account) public view override returns (uint256) {
2252         return _balances[account];
2253     }
2254 
2255     function transfer(address, uint256) public pure override returns (bool) {
2256         revert("LVMH_DividendTracker: method not implemented");
2257     }
2258 
2259     function allowance(address, address)
2260         public
2261         pure
2262         override
2263         returns (uint256)
2264     {
2265         revert("LVMH_DividendTracker: method not implemented");
2266     }
2267 
2268     function approve(address, uint256) public pure override returns (bool) {
2269         revert("LVMH_DividendTracker: method not implemented");
2270     }
2271 
2272     function transferFrom(
2273         address,
2274         address,
2275         uint256
2276     ) public pure override returns (bool) {
2277         revert("LVMH_DividendTracker: method not implemented");
2278     }
2279 }