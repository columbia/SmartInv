1 // Verified using https://dapp.tools
2 
3 // hevm: flattened sources of src/ReFi.sol
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
1238 ////// src/ReFi.sol
1239 /**
1240 
1241 Reimagined Decentralized Finance
1242 
1243 u'all are not ready for this
1244 
1245 Tax for Buying/Selling: 10%
1246     - 3% of each transaction sent to holders as ETH transactions
1247     - 4% of each transaction sent to Treasury Wallet
1248     - 3% of each transaction sent to the Liquidity Pool
1249 
1250 Earning Dashboard:
1251 https://reimagined.fi
1252 
1253 */
1254 
1255 /* pragma solidity 0.8.10; */
1256 
1257 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1258 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1259 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1260 /* import {Address} from "lib/openzeppelin-contracts/contracts/utils/Address.sol"; */
1261 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1262 
1263 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1264 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1265 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1266 
1267 contract ReFi is Ownable, IERC20 {
1268     address UNISWAPROUTER = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1269     address DEAD = 0x000000000000000000000000000000000000dEaD;
1270     address ZERO = 0x0000000000000000000000000000000000000000;
1271 
1272     string private _name = "ReFi";
1273     string private _symbol = "REFI";
1274 
1275     uint256 public treasuryFeeBPS = 400;
1276     uint256 public liquidityFeeBPS = 300;
1277     uint256 public dividendFeeBPS = 300;
1278     uint256 public totalFeeBPS = 1000;
1279 
1280     uint256 public swapTokensAtAmount = 100000 * (10**18);
1281     uint256 public lastSwapTime;
1282     bool swapAllToken = true;
1283 
1284     bool public swapEnabled = true;
1285     bool public taxEnabled = true;
1286     bool public compoundingEnabled = true;
1287 
1288     uint256 private _totalSupply;
1289     bool private swapping;
1290 
1291     address marketingWallet;
1292     address liquidityWallet;
1293 
1294     mapping(address => uint256) private _balances;
1295     mapping(address => mapping(address => uint256)) private _allowances;
1296     mapping(address => bool) private _isExcludedFromFees;
1297     mapping(address => bool) public automatedMarketMakerPairs;
1298     mapping(address => bool) private _whiteList;
1299     mapping(address => bool) isBlacklisted;
1300 
1301     event SwapAndAddLiquidity(
1302         uint256 tokensSwapped,
1303         uint256 nativeReceived,
1304         uint256 tokensIntoLiquidity
1305     );
1306     event SendDividends(uint256 tokensSwapped, uint256 amount);
1307     event ExcludeFromFees(address indexed account, bool isExcluded);
1308     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1309     event UpdateUniswapV2Router(
1310         address indexed newAddress,
1311         address indexed oldAddress
1312     );
1313     event SwapEnabled(bool enabled);
1314     event TaxEnabled(bool enabled);
1315     event CompoundingEnabled(bool enabled);
1316     event BlacklistEnabled(bool enabled);
1317 
1318     DividendTracker public dividendTracker;
1319     IUniswapV2Router02 public uniswapV2Router;
1320 
1321     address public uniswapV2Pair;
1322 
1323     uint256 public maxTxBPS = 49;
1324     uint256 public maxWalletBPS = 200;
1325 
1326     bool isOpen = false;
1327 
1328     mapping(address => bool) private _isExcludedFromMaxTx;
1329     mapping(address => bool) private _isExcludedFromMaxWallet;
1330 
1331     constructor(
1332         address _marketingWallet,
1333         address _liquidityWallet,
1334         address[] memory whitelistAddress
1335     ) {
1336         marketingWallet = _marketingWallet;
1337         liquidityWallet = _liquidityWallet;
1338         includeToWhiteList(whitelistAddress);
1339 
1340         dividendTracker = new DividendTracker(address(this), UNISWAPROUTER);
1341 
1342         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(UNISWAPROUTER);
1343 
1344         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1345             .createPair(address(this), _uniswapV2Router.WETH());
1346 
1347         uniswapV2Router = _uniswapV2Router;
1348         uniswapV2Pair = _uniswapV2Pair;
1349 
1350         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1351 
1352         dividendTracker.excludeFromDividends(address(dividendTracker), true);
1353         dividendTracker.excludeFromDividends(address(this), true);
1354         dividendTracker.excludeFromDividends(owner(), true);
1355         dividendTracker.excludeFromDividends(address(_uniswapV2Router), true);
1356 
1357         excludeFromFees(owner(), true);
1358         excludeFromFees(address(this), true);
1359         excludeFromFees(address(dividendTracker), true);
1360 
1361         excludeFromMaxTx(owner(), true);
1362         excludeFromMaxTx(address(this), true);
1363         excludeFromMaxTx(address(dividendTracker), true);
1364 
1365         excludeFromMaxWallet(owner(), true);
1366         excludeFromMaxWallet(address(this), true);
1367         excludeFromMaxWallet(address(dividendTracker), true);
1368 
1369         _mint(owner(), 1000000000 * (10**18));
1370     }
1371 
1372     receive() external payable {}
1373 
1374     function name() public view returns (string memory) {
1375         return _name;
1376     }
1377 
1378     function symbol() public view returns (string memory) {
1379         return _symbol;
1380     }
1381 
1382     function decimals() public pure returns (uint8) {
1383         return 18;
1384     }
1385 
1386     function totalSupply() public view virtual override returns (uint256) {
1387         return _totalSupply;
1388     }
1389 
1390     function balanceOf(address account)
1391         public
1392         view
1393         virtual
1394         override
1395         returns (uint256)
1396     {
1397         return _balances[account];
1398     }
1399 
1400     function allowance(address owner, address spender)
1401         public
1402         view
1403         virtual
1404         override
1405         returns (uint256)
1406     {
1407         return _allowances[owner][spender];
1408     }
1409 
1410     function approve(address spender, uint256 amount)
1411         public
1412         virtual
1413         override
1414         returns (bool)
1415     {
1416         _approve(_msgSender(), spender, amount);
1417         return true;
1418     }
1419 
1420     function increaseAllowance(address spender, uint256 addedValue)
1421         public
1422         returns (bool)
1423     {
1424         _approve(
1425             _msgSender(),
1426             spender,
1427             _allowances[_msgSender()][spender] + addedValue
1428         );
1429         return true;
1430     }
1431 
1432     function decreaseAllowance(address spender, uint256 subtractedValue)
1433         public
1434         returns (bool)
1435     {
1436         uint256 currentAllowance = _allowances[_msgSender()][spender];
1437         require(
1438             currentAllowance >= subtractedValue,
1439             "ReFi: decreased allowance below zero"
1440         );
1441         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1442         return true;
1443     }
1444 
1445     function transfer(address recipient, uint256 amount)
1446         public
1447         virtual
1448         override
1449         returns (bool)
1450     {
1451         _transfer(_msgSender(), recipient, amount);
1452         return true;
1453     }
1454 
1455     function transferFrom(
1456         address sender,
1457         address recipient,
1458         uint256 amount
1459     ) public virtual override returns (bool) {
1460         _transfer(sender, recipient, amount);
1461         uint256 currentAllowance = _allowances[sender][_msgSender()];
1462         require(
1463             currentAllowance >= amount,
1464             "ReFi: transfer amount exceeds allowance"
1465         );
1466         _approve(sender, _msgSender(), currentAllowance - amount);
1467         return true;
1468     }
1469 
1470     function openTrading() external onlyOwner {
1471         isOpen = true;
1472     }
1473 
1474     function _transfer(
1475         address sender,
1476         address recipient,
1477         uint256 amount
1478     ) internal {
1479         require(
1480             isOpen ||
1481                 sender == owner() ||
1482                 recipient == owner() ||
1483                 _whiteList[sender] ||
1484                 _whiteList[recipient],
1485             "Not Open"
1486         );
1487 
1488         require(!isBlacklisted[sender], "ReFi: Sender is blacklisted");
1489         require(!isBlacklisted[recipient], "ReFi: Recipient is blacklisted");
1490 
1491         require(sender != address(0), "ReFi: transfer from the zero address");
1492         require(recipient != address(0), "ReFi: transfer to the zero address");
1493 
1494         uint256 _maxTxAmount = (totalSupply() * maxTxBPS) / 10000;
1495         uint256 _maxWallet = (totalSupply() * maxWalletBPS) / 10000;
1496         require(
1497             amount <= _maxTxAmount || _isExcludedFromMaxTx[sender],
1498             "TX Limit Exceeded"
1499         );
1500 
1501         if (
1502             sender != owner() &&
1503             recipient != address(this) &&
1504             recipient != address(DEAD) &&
1505             recipient != uniswapV2Pair
1506         ) {
1507             uint256 currentBalance = balanceOf(recipient);
1508             require(
1509                 _isExcludedFromMaxWallet[recipient] ||
1510                     (currentBalance + amount <= _maxWallet)
1511             );
1512         }
1513 
1514         uint256 senderBalance = _balances[sender];
1515         require(
1516             senderBalance >= amount,
1517             "ReFi: transfer amount exceeds balance"
1518         );
1519 
1520         uint256 contractTokenBalance = balanceOf(address(this));
1521         uint256 contractNativeBalance = address(this).balance;
1522 
1523         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1524 
1525         if (
1526             swapEnabled && // True
1527             canSwap && // true
1528             !swapping && // swapping=false !false true
1529             !automatedMarketMakerPairs[sender] && // no swap on remove liquidity step 1 or DEX buy
1530             sender != address(uniswapV2Router) && // no swap on remove liquidity step 2
1531             sender != owner() &&
1532             recipient != owner()
1533         ) {
1534             swapping = true;
1535 
1536             if (!swapAllToken) {
1537                 contractTokenBalance = swapTokensAtAmount;
1538             }
1539             _executeSwap(contractTokenBalance, contractNativeBalance);
1540 
1541             lastSwapTime = block.timestamp;
1542             swapping = false;
1543         }
1544 
1545         bool takeFee;
1546 
1547         if (
1548             sender == address(uniswapV2Pair) ||
1549             recipient == address(uniswapV2Pair)
1550         ) {
1551             takeFee = true;
1552         }
1553 
1554         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
1555             takeFee = false;
1556         }
1557 
1558         if (swapping || !taxEnabled) {
1559             takeFee = false;
1560         }
1561 
1562         if (takeFee) {
1563             uint256 fees = (amount * totalFeeBPS) / 10000;
1564             amount -= fees;
1565             _executeTransfer(sender, address(this), fees);
1566         }
1567 
1568         _executeTransfer(sender, recipient, amount);
1569 
1570         dividendTracker.setBalance(payable(sender), balanceOf(sender));
1571         dividendTracker.setBalance(payable(recipient), balanceOf(recipient));
1572     }
1573 
1574     function _executeTransfer(
1575         address sender,
1576         address recipient,
1577         uint256 amount
1578     ) private {
1579         require(sender != address(0), "ReFi: transfer from the zero address");
1580         require(recipient != address(0), "ReFi: transfer to the zero address");
1581         uint256 senderBalance = _balances[sender];
1582         require(
1583             senderBalance >= amount,
1584             "ReFi: transfer amount exceeds balance"
1585         );
1586         _balances[sender] = senderBalance - amount;
1587         _balances[recipient] += amount;
1588         emit Transfer(sender, recipient, amount);
1589     }
1590 
1591     function _approve(
1592         address owner,
1593         address spender,
1594         uint256 amount
1595     ) private {
1596         require(owner != address(0), "ReFi: approve from the zero address");
1597         require(spender != address(0), "ReFi: approve to the zero address");
1598         _allowances[owner][spender] = amount;
1599         emit Approval(owner, spender, amount);
1600     }
1601 
1602     function _mint(address account, uint256 amount) private {
1603         require(account != address(0), "ReFi: mint to the zero address");
1604         _totalSupply += amount;
1605         _balances[account] += amount;
1606         emit Transfer(address(0), account, amount);
1607     }
1608 
1609     function _burn(address account, uint256 amount) private {
1610         require(account != address(0), "ReFi: burn from the zero address");
1611         uint256 accountBalance = _balances[account];
1612         require(accountBalance >= amount, "ReFi: burn amount exceeds balance");
1613         _balances[account] = accountBalance - amount;
1614         _totalSupply -= amount;
1615         emit Transfer(account, address(0), amount);
1616     }
1617 
1618     function swapTokensForNative(uint256 tokens) private {
1619         address[] memory path = new address[](2);
1620         path[0] = address(this);
1621         path[1] = uniswapV2Router.WETH();
1622         _approve(address(this), address(uniswapV2Router), tokens);
1623         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1624             tokens,
1625             0, // accept any amount of native
1626             path,
1627             address(this),
1628             block.timestamp
1629         );
1630     }
1631 
1632     function addLiquidity(uint256 tokens, uint256 native) private {
1633         _approve(address(this), address(uniswapV2Router), tokens);
1634         uniswapV2Router.addLiquidityETH{value: native}(
1635             address(this),
1636             tokens,
1637             0, // slippage unavoidable
1638             0, // slippage unavoidable
1639             liquidityWallet,
1640             block.timestamp
1641         );
1642     }
1643 
1644     function includeToWhiteList(address[] memory _users) private {
1645         for (uint8 i = 0; i < _users.length; i++) {
1646             _whiteList[_users[i]] = true;
1647         }
1648     }
1649 
1650     function _executeSwap(uint256 tokens, uint256 native) private {
1651         if (tokens <= 0) {
1652             return;
1653         }
1654 
1655         uint256 swapTokensMarketing;
1656         if (address(marketingWallet) != address(0)) {
1657             swapTokensMarketing = (tokens * treasuryFeeBPS) / totalFeeBPS;
1658         }
1659 
1660         uint256 swapTokensDividends;
1661         if (dividendTracker.totalSupply() > 0) {
1662             swapTokensDividends = (tokens * dividendFeeBPS) / totalFeeBPS;
1663         }
1664 
1665         uint256 tokensForLiquidity = tokens -
1666             swapTokensMarketing -
1667             swapTokensDividends;
1668         uint256 swapTokensLiquidity = tokensForLiquidity / 2;
1669         uint256 addTokensLiquidity = tokensForLiquidity - swapTokensLiquidity;
1670         uint256 swapTokensTotal = swapTokensMarketing +
1671             swapTokensDividends +
1672             swapTokensLiquidity;
1673 
1674         uint256 initNativeBal = address(this).balance;
1675         swapTokensForNative(swapTokensTotal);
1676         uint256 nativeSwapped = (address(this).balance - initNativeBal) +
1677             native;
1678 
1679         uint256 nativeMarketing = (nativeSwapped * swapTokensMarketing) /
1680             swapTokensTotal;
1681         uint256 nativeDividends = (nativeSwapped * swapTokensDividends) /
1682             swapTokensTotal;
1683         uint256 nativeLiquidity = nativeSwapped -
1684             nativeMarketing -
1685             nativeDividends;
1686 
1687         if (nativeMarketing > 0) {
1688             payable(marketingWallet).transfer(nativeMarketing);
1689         }
1690 
1691         addLiquidity(addTokensLiquidity, nativeLiquidity);
1692         emit SwapAndAddLiquidity(
1693             swapTokensLiquidity,
1694             nativeLiquidity,
1695             addTokensLiquidity
1696         );
1697 
1698         if (nativeDividends > 0) {
1699             (bool success, ) = address(dividendTracker).call{
1700                 value: nativeDividends
1701             }("");
1702             if (success) {
1703                 emit SendDividends(swapTokensDividends, nativeDividends);
1704             }
1705         }
1706     }
1707 
1708     function excludeFromFees(address account, bool excluded) public onlyOwner {
1709         require(
1710             _isExcludedFromFees[account] != excluded,
1711             "ReFi: account is already set to requested state"
1712         );
1713         _isExcludedFromFees[account] = excluded;
1714         emit ExcludeFromFees(account, excluded);
1715     }
1716 
1717     function isExcludedFromFees(address account) public view returns (bool) {
1718         return _isExcludedFromFees[account];
1719     }
1720 
1721     function manualSendDividend(uint256 amount, address holder)
1722         external
1723         onlyOwner
1724     {
1725         dividendTracker.manualSendDividend(amount, holder);
1726     }
1727 
1728     function excludeFromDividends(address account, bool excluded)
1729         public
1730         onlyOwner
1731     {
1732         dividendTracker.excludeFromDividends(account, excluded);
1733     }
1734 
1735     function isExcludedFromDividends(address account)
1736         public
1737         view
1738         returns (bool)
1739     {
1740         return dividendTracker.isExcludedFromDividends(account);
1741     }
1742 
1743     function setWallet(
1744         address payable _marketingWallet,
1745         address payable _liquidityWallet
1746     ) external onlyOwner {
1747         marketingWallet = _marketingWallet;
1748         liquidityWallet = _liquidityWallet;
1749     }
1750 
1751     function setAutomatedMarketMakerPair(address pair, bool value)
1752         public
1753         onlyOwner
1754     {
1755         require(pair != uniswapV2Pair, "ReFi: DEX pair can not be removed");
1756         _setAutomatedMarketMakerPair(pair, value);
1757     }
1758 
1759     function setFee(
1760         uint256 _treasuryFee,
1761         uint256 _liquidityFee,
1762         uint256 _dividendFee
1763     ) external onlyOwner {
1764         treasuryFeeBPS = _treasuryFee;
1765         liquidityFeeBPS = _liquidityFee;
1766         dividendFeeBPS = _dividendFee;
1767         totalFeeBPS = _treasuryFee + _liquidityFee + _dividendFee;
1768     }
1769 
1770     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1771         require(
1772             automatedMarketMakerPairs[pair] != value,
1773             "ReFi: automated market maker pair is already set to that value"
1774         );
1775         automatedMarketMakerPairs[pair] = value;
1776         if (value) {
1777             dividendTracker.excludeFromDividends(pair, true);
1778         }
1779         emit SetAutomatedMarketMakerPair(pair, value);
1780     }
1781 
1782     function updateUniswapV2Router(address newAddress) public onlyOwner {
1783         require(
1784             newAddress != address(uniswapV2Router),
1785             "ReFi: the router is already set to the new address"
1786         );
1787         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
1788         uniswapV2Router = IUniswapV2Router02(newAddress);
1789         address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
1790             .createPair(address(this), uniswapV2Router.WETH());
1791         uniswapV2Pair = _uniswapV2Pair;
1792     }
1793 
1794     function claim() public {
1795         dividendTracker.processAccount(payable(_msgSender()));
1796     }
1797 
1798     function compound() public {
1799         require(compoundingEnabled, "ReFi: compounding is not enabled");
1800         dividendTracker.compoundAccount(payable(_msgSender()));
1801     }
1802 
1803     function withdrawableDividendOf(address account)
1804         public
1805         view
1806         returns (uint256)
1807     {
1808         return dividendTracker.withdrawableDividendOf(account);
1809     }
1810 
1811     function withdrawnDividendOf(address account)
1812         public
1813         view
1814         returns (uint256)
1815     {
1816         return dividendTracker.withdrawnDividendOf(account);
1817     }
1818 
1819     function accumulativeDividendOf(address account)
1820         public
1821         view
1822         returns (uint256)
1823     {
1824         return dividendTracker.accumulativeDividendOf(account);
1825     }
1826 
1827     function getAccountInfo(address account)
1828         public
1829         view
1830         returns (
1831             address,
1832             uint256,
1833             uint256,
1834             uint256,
1835             uint256
1836         )
1837     {
1838         return dividendTracker.getAccountInfo(account);
1839     }
1840 
1841     function getLastClaimTime(address account) public view returns (uint256) {
1842         return dividendTracker.getLastClaimTime(account);
1843     }
1844 
1845     function setSwapEnabled(bool _enabled) external onlyOwner {
1846         swapEnabled = _enabled;
1847         emit SwapEnabled(_enabled);
1848     }
1849 
1850     function setTaxEnabled(bool _enabled) external onlyOwner {
1851         taxEnabled = _enabled;
1852         emit TaxEnabled(_enabled);
1853     }
1854 
1855     function setCompoundingEnabled(bool _enabled) external onlyOwner {
1856         compoundingEnabled = _enabled;
1857         emit CompoundingEnabled(_enabled);
1858     }
1859 
1860     function updateDividendSettings(
1861         bool _swapEnabled,
1862         uint256 _swapTokensAtAmount,
1863         bool _swapAllToken
1864     ) external onlyOwner {
1865         swapEnabled = _swapEnabled;
1866         swapTokensAtAmount = _swapTokensAtAmount;
1867         swapAllToken = _swapAllToken;
1868     }
1869 
1870     function setMaxTxBPS(uint256 bps) external onlyOwner {
1871         require(bps >= 75 && bps <= 10000, "BPS must be between 75 and 10000");
1872         maxTxBPS = bps;
1873     }
1874 
1875     function excludeFromMaxTx(address account, bool excluded) public onlyOwner {
1876         _isExcludedFromMaxTx[account] = excluded;
1877     }
1878 
1879     function isExcludedFromMaxTx(address account) public view returns (bool) {
1880         return _isExcludedFromMaxTx[account];
1881     }
1882 
1883     function setMaxWalletBPS(uint256 bps) external onlyOwner {
1884         require(
1885             bps >= 175 && bps <= 10000,
1886             "BPS must be between 175 and 10000"
1887         );
1888         maxWalletBPS = bps;
1889     }
1890 
1891     function excludeFromMaxWallet(address account, bool excluded)
1892         public
1893         onlyOwner
1894     {
1895         _isExcludedFromMaxWallet[account] = excluded;
1896     }
1897 
1898     function isExcludedFromMaxWallet(address account)
1899         public
1900         view
1901         returns (bool)
1902     {
1903         return _isExcludedFromMaxWallet[account];
1904     }
1905 
1906     function rescueToken(address _token, uint256 _amount) external onlyOwner {
1907         IERC20(_token).transfer(msg.sender, _amount);
1908     }
1909 
1910     function rescueETH(uint256 _amount) external onlyOwner {
1911         payable(msg.sender).transfer(_amount);
1912     }
1913 
1914     function blackList(address _user) public onlyOwner {
1915         require(!isBlacklisted[_user], "user already blacklisted");
1916         isBlacklisted[_user] = true;
1917         // events?
1918     }
1919 
1920     function removeFromBlacklist(address _user) public onlyOwner {
1921         require(isBlacklisted[_user], "user already whitelisted");
1922         isBlacklisted[_user] = false;
1923         //events?
1924     }
1925 
1926     function blackListMany(address[] memory _users) public onlyOwner {
1927         for (uint8 i = 0; i < _users.length; i++) {
1928             isBlacklisted[_users[i]] = true;
1929         }
1930     }
1931 
1932     function unBlackListMany(address[] memory _users) public onlyOwner {
1933         for (uint8 i = 0; i < _users.length; i++) {
1934             isBlacklisted[_users[i]] = false;
1935         }
1936     }
1937 }
1938 
1939 contract DividendTracker is Ownable, IERC20 {
1940     address UNISWAPROUTER;
1941 
1942     string private _name = "ReFi_DividendTracker";
1943     string private _symbol = "ReFi_DividendTracker";
1944 
1945     uint256 public lastProcessedIndex;
1946 
1947     uint256 private _totalSupply;
1948     mapping(address => uint256) private _balances;
1949 
1950     uint256 private constant magnitude = 2**128;
1951     uint256 public immutable minTokenBalanceForDividends;
1952     uint256 private magnifiedDividendPerShare;
1953     uint256 public totalDividendsDistributed;
1954     uint256 public totalDividendsWithdrawn;
1955 
1956     address public tokenAddress;
1957 
1958     mapping(address => bool) public excludedFromDividends;
1959     mapping(address => int256) private magnifiedDividendCorrections;
1960     mapping(address => uint256) private withdrawnDividends;
1961     mapping(address => uint256) private lastClaimTimes;
1962 
1963     event DividendsDistributed(address indexed from, uint256 weiAmount);
1964     event DividendWithdrawn(address indexed to, uint256 weiAmount);
1965     event ExcludeFromDividends(address indexed account, bool excluded);
1966     event Claim(address indexed account, uint256 amount);
1967     event Compound(address indexed account, uint256 amount, uint256 tokens);
1968 
1969     struct AccountInfo {
1970         address account;
1971         uint256 withdrawableDividends;
1972         uint256 totalDividends;
1973         uint256 lastClaimTime;
1974     }
1975 
1976     constructor(address _tokenAddress, address _uniswapRouter) {
1977         minTokenBalanceForDividends = 10000 * (10**18);
1978         tokenAddress = _tokenAddress;
1979         UNISWAPROUTER = _uniswapRouter;
1980     }
1981 
1982     receive() external payable {
1983         distributeDividends();
1984     }
1985 
1986     function distributeDividends() public payable {
1987         require(_totalSupply > 0);
1988         if (msg.value > 0) {
1989             magnifiedDividendPerShare =
1990                 magnifiedDividendPerShare +
1991                 ((msg.value * magnitude) / _totalSupply);
1992             emit DividendsDistributed(msg.sender, msg.value);
1993             totalDividendsDistributed += msg.value;
1994         }
1995     }
1996 
1997     function setBalance(address payable account, uint256 newBalance)
1998         external
1999         onlyOwner
2000     {
2001         if (excludedFromDividends[account]) {
2002             return;
2003         }
2004         if (newBalance >= minTokenBalanceForDividends) {
2005             _setBalance(account, newBalance);
2006         } else {
2007             _setBalance(account, 0);
2008         }
2009     }
2010 
2011     function excludeFromDividends(address account, bool excluded)
2012         external
2013         onlyOwner
2014     {
2015         require(
2016             excludedFromDividends[account] != excluded,
2017             "ReFi_DividendTracker: account already set to requested state"
2018         );
2019         excludedFromDividends[account] = excluded;
2020         if (excluded) {
2021             _setBalance(account, 0);
2022         } else {
2023             uint256 newBalance = IERC20(tokenAddress).balanceOf(account);
2024             if (newBalance >= minTokenBalanceForDividends) {
2025                 _setBalance(account, newBalance);
2026             } else {
2027                 _setBalance(account, 0);
2028             }
2029         }
2030         emit ExcludeFromDividends(account, excluded);
2031     }
2032 
2033     function isExcludedFromDividends(address account)
2034         public
2035         view
2036         returns (bool)
2037     {
2038         return excludedFromDividends[account];
2039     }
2040 
2041     function manualSendDividend(uint256 amount, address holder)
2042         external
2043         onlyOwner
2044     {
2045         uint256 contractETHBalance = address(this).balance;
2046         payable(holder).transfer(amount > 0 ? amount : contractETHBalance);
2047     }
2048 
2049     function _setBalance(address account, uint256 newBalance) internal {
2050         uint256 currentBalance = _balances[account];
2051         if (newBalance > currentBalance) {
2052             uint256 addAmount = newBalance - currentBalance;
2053             _mint(account, addAmount);
2054         } else if (newBalance < currentBalance) {
2055             uint256 subAmount = currentBalance - newBalance;
2056             _burn(account, subAmount);
2057         }
2058     }
2059 
2060     function _mint(address account, uint256 amount) private {
2061         require(
2062             account != address(0),
2063             "ReFi_DividendTracker: mint to the zero address"
2064         );
2065         _totalSupply += amount;
2066         _balances[account] += amount;
2067         emit Transfer(address(0), account, amount);
2068         magnifiedDividendCorrections[account] =
2069             magnifiedDividendCorrections[account] -
2070             int256(magnifiedDividendPerShare * amount);
2071     }
2072 
2073     function _burn(address account, uint256 amount) private {
2074         require(
2075             account != address(0),
2076             "ReFi_DividendTracker: burn from the zero address"
2077         );
2078         uint256 accountBalance = _balances[account];
2079         require(
2080             accountBalance >= amount,
2081             "ReFi_DividendTracker: burn amount exceeds balance"
2082         );
2083         _balances[account] = accountBalance - amount;
2084         _totalSupply -= amount;
2085         emit Transfer(account, address(0), amount);
2086         magnifiedDividendCorrections[account] =
2087             magnifiedDividendCorrections[account] +
2088             int256(magnifiedDividendPerShare * amount);
2089     }
2090 
2091     function processAccount(address payable account)
2092         public
2093         onlyOwner
2094         returns (bool)
2095     {
2096         uint256 amount = _withdrawDividendOfUser(account);
2097         if (amount > 0) {
2098             lastClaimTimes[account] = block.timestamp;
2099             emit Claim(account, amount);
2100             return true;
2101         }
2102         return false;
2103     }
2104 
2105     function _withdrawDividendOfUser(address payable account)
2106         private
2107         returns (uint256)
2108     {
2109         uint256 _withdrawableDividend = withdrawableDividendOf(account);
2110         if (_withdrawableDividend > 0) {
2111             withdrawnDividends[account] += _withdrawableDividend;
2112             totalDividendsWithdrawn += _withdrawableDividend;
2113             emit DividendWithdrawn(account, _withdrawableDividend);
2114             (bool success, ) = account.call{
2115                 value: _withdrawableDividend,
2116                 gas: 3000
2117             }("");
2118             if (!success) {
2119                 withdrawnDividends[account] -= _withdrawableDividend;
2120                 totalDividendsWithdrawn -= _withdrawableDividend;
2121                 return 0;
2122             }
2123             return _withdrawableDividend;
2124         }
2125         return 0;
2126     }
2127 
2128     function compoundAccount(address payable account)
2129         public
2130         onlyOwner
2131         returns (bool)
2132     {
2133         (uint256 amount, uint256 tokens) = _compoundDividendOfUser(account);
2134         if (amount > 0) {
2135             lastClaimTimes[account] = block.timestamp;
2136             emit Compound(account, amount, tokens);
2137             return true;
2138         }
2139         return false;
2140     }
2141 
2142     function _compoundDividendOfUser(address payable account)
2143         private
2144         returns (uint256, uint256)
2145     {
2146         uint256 _withdrawableDividend = withdrawableDividendOf(account);
2147         if (_withdrawableDividend > 0) {
2148             withdrawnDividends[account] += _withdrawableDividend;
2149             totalDividendsWithdrawn += _withdrawableDividend;
2150             emit DividendWithdrawn(account, _withdrawableDividend);
2151 
2152             IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(
2153                 UNISWAPROUTER
2154             );
2155 
2156             address[] memory path = new address[](2);
2157             path[0] = uniswapV2Router.WETH();
2158             path[1] = address(tokenAddress);
2159 
2160             bool success;
2161             uint256 tokens;
2162 
2163             uint256 initTokenBal = IERC20(tokenAddress).balanceOf(account);
2164             try
2165                 uniswapV2Router
2166                     .swapExactETHForTokensSupportingFeeOnTransferTokens{
2167                     value: _withdrawableDividend
2168                 }(0, path, address(account), block.timestamp)
2169             {
2170                 success = true;
2171                 tokens = IERC20(tokenAddress).balanceOf(account) - initTokenBal;
2172             } catch Error(
2173                 string memory /*err*/
2174             ) {
2175                 success = false;
2176             }
2177 
2178             if (!success) {
2179                 withdrawnDividends[account] -= _withdrawableDividend;
2180                 totalDividendsWithdrawn -= _withdrawableDividend;
2181                 return (0, 0);
2182             }
2183 
2184             return (_withdrawableDividend, tokens);
2185         }
2186         return (0, 0);
2187     }
2188 
2189     function withdrawableDividendOf(address account)
2190         public
2191         view
2192         returns (uint256)
2193     {
2194         return accumulativeDividendOf(account) - withdrawnDividends[account];
2195     }
2196 
2197     function withdrawnDividendOf(address account)
2198         public
2199         view
2200         returns (uint256)
2201     {
2202         return withdrawnDividends[account];
2203     }
2204 
2205     function accumulativeDividendOf(address account)
2206         public
2207         view
2208         returns (uint256)
2209     {
2210         int256 a = int256(magnifiedDividendPerShare * balanceOf(account));
2211         int256 b = magnifiedDividendCorrections[account]; // this is an explicit int256 (signed)
2212         return uint256(a + b) / magnitude;
2213     }
2214 
2215     function getAccountInfo(address account)
2216         public
2217         view
2218         returns (
2219             address,
2220             uint256,
2221             uint256,
2222             uint256,
2223             uint256
2224         )
2225     {
2226         AccountInfo memory info;
2227         info.account = account;
2228         info.withdrawableDividends = withdrawableDividendOf(account);
2229         info.totalDividends = accumulativeDividendOf(account);
2230         info.lastClaimTime = lastClaimTimes[account];
2231         return (
2232             info.account,
2233             info.withdrawableDividends,
2234             info.totalDividends,
2235             info.lastClaimTime,
2236             totalDividendsWithdrawn
2237         );
2238     }
2239 
2240     function getLastClaimTime(address account) public view returns (uint256) {
2241         return lastClaimTimes[account];
2242     }
2243 
2244     function name() public view returns (string memory) {
2245         return _name;
2246     }
2247 
2248     function symbol() public view returns (string memory) {
2249         return _symbol;
2250     }
2251 
2252     function decimals() public pure returns (uint8) {
2253         return 18;
2254     }
2255 
2256     function totalSupply() public view override returns (uint256) {
2257         return _totalSupply;
2258     }
2259 
2260     function balanceOf(address account) public view override returns (uint256) {
2261         return _balances[account];
2262     }
2263 
2264     function transfer(address, uint256) public pure override returns (bool) {
2265         revert("ReFi_DividendTracker: method not implemented");
2266     }
2267 
2268     function allowance(address, address)
2269         public
2270         pure
2271         override
2272         returns (uint256)
2273     {
2274         revert("ReFi_DividendTracker: method not implemented");
2275     }
2276 
2277     function approve(address, uint256) public pure override returns (bool) {
2278         revert("ReFi_DividendTracker: method not implemented");
2279     }
2280 
2281     function transferFrom(
2282         address,
2283         address,
2284         uint256
2285     ) public pure override returns (bool) {
2286         revert("ReFi_DividendTracker: method not implemented");
2287     }
2288 }
