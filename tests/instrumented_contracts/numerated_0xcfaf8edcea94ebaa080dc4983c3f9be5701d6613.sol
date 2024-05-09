1 /**
2  *Submitted for verification at Etherscan.io on 2021-12-11
3 */
4 
5 // Verified using https://dapp.tools
6 
7 // hevm: flattened sources of src/EXPO.sol
8 // SPDX-License-Identifier: MIT
9 pragma solidity =0.8.10 >=0.8.0 <0.9.0;
10 pragma experimental ABIEncoderV2;
11 
12 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
13 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
14 
15 /* pragma solidity ^0.8.0; */
16 
17 /**
18  * @dev Provides information about the current execution context, including the
19  * sender of the transaction and its data. While these are generally available
20  * via msg.sender and msg.data, they should not be accessed in such a direct
21  * manner, since when dealing with meta-transactions the account sending and
22  * paying for execution may not be the actual sender (as far as an application
23  * is concerned).
24  *
25  * This contract is only required for intermediate, library-like contracts.
26  */
27 abstract contract Context {
28     function _msgSender() internal view virtual returns (address) {
29         return msg.sender;
30     }
31 
32     function _msgData() internal view virtual returns (bytes calldata) {
33         return msg.data;
34     }
35 }
36 
37 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
38 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
39 
40 /* pragma solidity ^0.8.0; */
41 
42 /* import "../utils/Context.sol"; */
43 
44 /**
45  * @dev Contract module which provides a basic access control mechanism, where
46  * there is an account (an owner) that can be granted exclusive access to
47  * specific functions.
48  *
49  * By default, the owner account will be the one that deploys the contract. This
50  * can later be changed with {transferOwnership}.
51  *
52  * This module is used through inheritance. It will make available the modifier
53  * `onlyOwner`, which can be applied to your functions to restrict their use to
54  * the owner.
55  */
56 abstract contract Ownable is Context {
57     address private _owner;
58 
59     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
60 
61     /**
62      * @dev Initializes the contract setting the deployer as the initial owner.
63      */
64     constructor() {
65         _transferOwnership(_msgSender());
66     }
67 
68     /**
69      * @dev Returns the address of the current owner.
70      */
71     function owner() public view virtual returns (address) {
72         return _owner;
73     }
74 
75     /**
76      * @dev Throws if called by any account other than the owner.
77      */
78     modifier onlyOwner() {
79         require(owner() == _msgSender(), "Ownable: caller is not the owner");
80         _;
81     }
82 
83     /**
84      * @dev Leaves the contract without owner. It will not be possible to call
85      * `onlyOwner` functions anymore. Can only be called by the current owner.
86      *
87      * NOTE: Renouncing ownership will leave the contract without an owner,
88      * thereby removing any functionality that is only available to the owner.
89      */
90     function renounceOwnership() public virtual onlyOwner {
91         _transferOwnership(address(0));
92     }
93 
94     /**
95      * @dev Transfers ownership of the contract to a new account (`newOwner`).
96      * Can only be called by the current owner.
97      */
98     function transferOwnership(address newOwner) public virtual onlyOwner {
99         require(newOwner != address(0), "Ownable: new owner is the zero address");
100         _transferOwnership(newOwner);
101     }
102 
103     /**
104      * @dev Transfers ownership of the contract to a new account (`newOwner`).
105      * Internal function without access restriction.
106      */
107     function _transferOwnership(address newOwner) internal virtual {
108         address oldOwner = _owner;
109         _owner = newOwner;
110         emit OwnershipTransferred(oldOwner, newOwner);
111     }
112 }
113 
114 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
115 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
116 
117 /* pragma solidity ^0.8.0; */
118 
119 /**
120  * @dev Interface of the ERC20 standard as defined in the EIP.
121  */
122 interface IERC20 {
123     /**
124      * @dev Returns the amount of tokens in existence.
125      */
126     function totalSupply() external view returns (uint256);
127 
128     /**
129      * @dev Returns the amount of tokens owned by `account`.
130      */
131     function balanceOf(address account) external view returns (uint256);
132 
133     /**
134      * @dev Moves `amount` tokens from the caller's account to `recipient`.
135      *
136      * Returns a boolean value indicating whether the operation succeeded.
137      *
138      * Emits a {Transfer} event.
139      */
140     function transfer(address recipient, uint256 amount) external returns (bool);
141 
142     /**
143      * @dev Returns the remaining number of tokens that `spender` will be
144      * allowed to spend on behalf of `owner` through {transferFrom}. This is
145      * zero by default.
146      *
147      * This value changes when {approve} or {transferFrom} are called.
148      */
149     function allowance(address owner, address spender) external view returns (uint256);
150 
151     /**
152      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
153      *
154      * Returns a boolean value indicating whether the operation succeeded.
155      *
156      * IMPORTANT: Beware that changing an allowance with this method brings the risk
157      * that someone may use both the old and the new allowance by unfortunate
158      * transaction ordering. One possible solution to mitigate this race
159      * condition is to first reduce the spender's allowance to 0 and set the
160      * desired value afterwards:
161      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
162      *
163      * Emits an {Approval} event.
164      */
165     function approve(address spender, uint256 amount) external returns (bool);
166 
167     /**
168      * @dev Moves `amount` tokens from `sender` to `recipient` using the
169      * allowance mechanism. `amount` is then deducted from the caller's
170      * allowance.
171      *
172      * Returns a boolean value indicating whether the operation succeeded.
173      *
174      * Emits a {Transfer} event.
175      */
176     function transferFrom(
177         address sender,
178         address recipient,
179         uint256 amount
180     ) external returns (bool);
181 
182     /**
183      * @dev Emitted when `value` tokens are moved from one account (`from`) to
184      * another (`to`).
185      *
186      * Note that `value` may be zero.
187      */
188     event Transfer(address indexed from, address indexed to, uint256 value);
189 
190     /**
191      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
192      * a call to {approve}. `value` is the new allowance.
193      */
194     event Approval(address indexed owner, address indexed spender, uint256 value);
195 }
196 
197 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
198 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
199 
200 /* pragma solidity ^0.8.0; */
201 
202 /* import "../IERC20.sol"; */
203 
204 /**
205  * @dev Interface for the optional metadata functions from the ERC20 standard.
206  *
207  * _Available since v4.1._
208  */
209 interface IERC20Metadata is IERC20 {
210     /**
211      * @dev Returns the name of the token.
212      */
213     function name() external view returns (string memory);
214 
215     /**
216      * @dev Returns the symbol of the token.
217      */
218     function symbol() external view returns (string memory);
219 
220     /**
221      * @dev Returns the decimals places of the token.
222      */
223     function decimals() external view returns (uint8);
224 }
225 
226 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
227 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
228 
229 /* pragma solidity ^0.8.0; */
230 
231 /* import "./IERC20.sol"; */
232 /* import "./extensions/IERC20Metadata.sol"; */
233 /* import "../../utils/Context.sol"; */
234 
235 /**
236  * @dev Implementation of the {IERC20} interface.
237  *
238  * This implementation is agnostic to the way tokens are created. This means
239  * that a supply mechanism has to be added in a derived contract using {_mint}.
240  * For a generic mechanism see {ERC20PresetMinterPauser}.
241  *
242  * TIP: For a detailed writeup see our guide
243  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
244  * to implement supply mechanisms].
245  *
246  * We have followed general OpenZeppelin Contracts guidelines: functions revert
247  * instead returning `false` on failure. This behavior is nonetheless
248  * conventional and does not conflict with the expectations of ERC20
249  * applications.
250  *
251  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
252  * This allows applications to reconstruct the allowance for all accounts just
253  * by listening to said events. Other implementations of the EIP may not emit
254  * these events, as it isn't required by the specification.
255  *
256  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
257  * functions have been added to mitigate the well-known issues around setting
258  * allowances. See {IERC20-approve}.
259  */
260 contract ERC20 is Context, IERC20, IERC20Metadata {
261     mapping(address => uint256) private _balances;
262 
263     mapping(address => mapping(address => uint256)) private _allowances;
264 
265     uint256 private _totalSupply;
266 
267     string private _name;
268     string private _symbol;
269 
270     /**
271      * @dev Sets the values for {name} and {symbol}.
272      *
273      * The default value of {decimals} is 18. To select a different value for
274      * {decimals} you should overload it.
275      *
276      * All two of these values are immutable: they can only be set once during
277      * construction.
278      */
279     constructor(string memory name_, string memory symbol_) {
280         _name = name_;
281         _symbol = symbol_;
282     }
283 
284     /**
285      * @dev Returns the name of the token.
286      */
287     function name() public view virtual override returns (string memory) {
288         return _name;
289     }
290 
291     /**
292      * @dev Returns the symbol of the token, usually a shorter version of the
293      * name.
294      */
295     function symbol() public view virtual override returns (string memory) {
296         return _symbol;
297     }
298 
299     /**
300      * @dev Returns the number of decimals used to get its user representation.
301      * For example, if `decimals` equals `2`, a balance of `505` tokens should
302      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
303      *
304      * Tokens usually opt for a value of 18, imitating the relationship between
305      * Ether and Wei. This is the value {ERC20} uses, unless this function is
306      * overridden;
307      *
308      * NOTE: This information is only used for _display_ purposes: it in
309      * no way affects any of the arithmetic of the contract, including
310      * {IERC20-balanceOf} and {IERC20-transfer}.
311      */
312     function decimals() public view virtual override returns (uint8) {
313         return 18;
314     }
315 
316     /**
317      * @dev See {IERC20-totalSupply}.
318      */
319     function totalSupply() public view virtual override returns (uint256) {
320         return _totalSupply;
321     }
322 
323     /**
324      * @dev See {IERC20-balanceOf}.
325      */
326     function balanceOf(address account) public view virtual override returns (uint256) {
327         return _balances[account];
328     }
329 
330     /**
331      * @dev See {IERC20-transfer}.
332      *
333      * Requirements:
334      *
335      * - `recipient` cannot be the zero address.
336      * - the caller must have a balance of at least `amount`.
337      */
338     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
339         _transfer(_msgSender(), recipient, amount);
340         return true;
341     }
342 
343     /**
344      * @dev See {IERC20-allowance}.
345      */
346     function allowance(address owner, address spender) public view virtual override returns (uint256) {
347         return _allowances[owner][spender];
348     }
349 
350     /**
351      * @dev See {IERC20-approve}.
352      *
353      * Requirements:
354      *
355      * - `spender` cannot be the zero address.
356      */
357     function approve(address spender, uint256 amount) public virtual override returns (bool) {
358         _approve(_msgSender(), spender, amount);
359         return true;
360     }
361 
362     /**
363      * @dev See {IERC20-transferFrom}.
364      *
365      * Emits an {Approval} event indicating the updated allowance. This is not
366      * required by the EIP. See the note at the beginning of {ERC20}.
367      *
368      * Requirements:
369      *
370      * - `sender` and `recipient` cannot be the zero address.
371      * - `sender` must have a balance of at least `amount`.
372      * - the caller must have allowance for ``sender``'s tokens of at least
373      * `amount`.
374      */
375     function transferFrom(
376         address sender,
377         address recipient,
378         uint256 amount
379     ) public virtual override returns (bool) {
380         _transfer(sender, recipient, amount);
381 
382         uint256 currentAllowance = _allowances[sender][_msgSender()];
383         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
384         unchecked {
385             _approve(sender, _msgSender(), currentAllowance - amount);
386         }
387 
388         return true;
389     }
390 
391     /**
392      * @dev Atomically increases the allowance granted to `spender` by the caller.
393      *
394      * This is an alternative to {approve} that can be used as a mitigation for
395      * problems described in {IERC20-approve}.
396      *
397      * Emits an {Approval} event indicating the updated allowance.
398      *
399      * Requirements:
400      *
401      * - `spender` cannot be the zero address.
402      */
403     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
404         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
405         return true;
406     }
407 
408     /**
409      * @dev Atomically decreases the allowance granted to `spender` by the caller.
410      *
411      * This is an alternative to {approve} that can be used as a mitigation for
412      * problems described in {IERC20-approve}.
413      *
414      * Emits an {Approval} event indicating the updated allowance.
415      *
416      * Requirements:
417      *
418      * - `spender` cannot be the zero address.
419      * - `spender` must have allowance for the caller of at least
420      * `subtractedValue`.
421      */
422     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
423         uint256 currentAllowance = _allowances[_msgSender()][spender];
424         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
425         unchecked {
426             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
427         }
428 
429         return true;
430     }
431 
432     /**
433      * @dev Moves `amount` of tokens from `sender` to `recipient`.
434      *
435      * This internal function is equivalent to {transfer}, and can be used to
436      * e.g. implement automatic token fees, slashing mechanisms, etc.
437      *
438      * Emits a {Transfer} event.
439      *
440      * Requirements:
441      *
442      * - `sender` cannot be the zero address.
443      * - `recipient` cannot be the zero address.
444      * - `sender` must have a balance of at least `amount`.
445      */
446     function _transfer(
447         address sender,
448         address recipient,
449         uint256 amount
450     ) internal virtual {
451         require(sender != address(0), "ERC20: transfer from the zero address");
452         require(recipient != address(0), "ERC20: transfer to the zero address");
453 
454         _beforeTokenTransfer(sender, recipient, amount);
455 
456         uint256 senderBalance = _balances[sender];
457         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
458         unchecked {
459             _balances[sender] = senderBalance - amount;
460         }
461         _balances[recipient] += amount;
462 
463         emit Transfer(sender, recipient, amount);
464 
465         _afterTokenTransfer(sender, recipient, amount);
466     }
467 
468     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
469      * the total supply.
470      *
471      * Emits a {Transfer} event with `from` set to the zero address.
472      *
473      * Requirements:
474      *
475      * - `account` cannot be the zero address.
476      */
477     function _mint(address account, uint256 amount) internal virtual {
478         require(account != address(0), "ERC20: mint to the zero address");
479 
480         _beforeTokenTransfer(address(0), account, amount);
481 
482         _totalSupply += amount;
483         _balances[account] += amount;
484         emit Transfer(address(0), account, amount);
485 
486         _afterTokenTransfer(address(0), account, amount);
487     }
488 
489     /**
490      * @dev Destroys `amount` tokens from `account`, reducing the
491      * total supply.
492      *
493      * Emits a {Transfer} event with `to` set to the zero address.
494      *
495      * Requirements:
496      *
497      * - `account` cannot be the zero address.
498      * - `account` must have at least `amount` tokens.
499      */
500     function _burn(address account, uint256 amount) internal virtual {
501         require(account != address(0), "ERC20: burn from the zero address");
502 
503         _beforeTokenTransfer(account, address(0), amount);
504 
505         uint256 accountBalance = _balances[account];
506         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
507         unchecked {
508             _balances[account] = accountBalance - amount;
509         }
510         _totalSupply -= amount;
511 
512         emit Transfer(account, address(0), amount);
513 
514         _afterTokenTransfer(account, address(0), amount);
515     }
516 
517     /**
518      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
519      *
520      * This internal function is equivalent to `approve`, and can be used to
521      * e.g. set automatic allowances for certain subsystems, etc.
522      *
523      * Emits an {Approval} event.
524      *
525      * Requirements:
526      *
527      * - `owner` cannot be the zero address.
528      * - `spender` cannot be the zero address.
529      */
530     function _approve(
531         address owner,
532         address spender,
533         uint256 amount
534     ) internal virtual {
535         require(owner != address(0), "ERC20: approve from the zero address");
536         require(spender != address(0), "ERC20: approve to the zero address");
537 
538         _allowances[owner][spender] = amount;
539         emit Approval(owner, spender, amount);
540     }
541 
542     /**
543      * @dev Hook that is called before any transfer of tokens. This includes
544      * minting and burning.
545      *
546      * Calling conditions:
547      *
548      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
549      * will be transferred to `to`.
550      * - when `from` is zero, `amount` tokens will be minted for `to`.
551      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
552      * - `from` and `to` are never both zero.
553      *
554      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
555      */
556     function _beforeTokenTransfer(
557         address from,
558         address to,
559         uint256 amount
560     ) internal virtual {}
561 
562     /**
563      * @dev Hook that is called after any transfer of tokens. This includes
564      * minting and burning.
565      *
566      * Calling conditions:
567      *
568      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
569      * has been transferred to `to`.
570      * - when `from` is zero, `amount` tokens have been minted for `to`.
571      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
572      * - `from` and `to` are never both zero.
573      *
574      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
575      */
576     function _afterTokenTransfer(
577         address from,
578         address to,
579         uint256 amount
580     ) internal virtual {}
581 }
582 
583 ////// lib/openzeppelin-contracts/contracts/utils/Address.sol
584 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
585 
586 /* pragma solidity ^0.8.0; */
587 
588 /**
589  * @dev Collection of functions related to the address type
590  */
591 library Address {
592     /**
593      * @dev Returns true if `account` is a contract.
594      *
595      * [IMPORTANT]
596      * ====
597      * It is unsafe to assume that an address for which this function returns
598      * false is an externally-owned account (EOA) and not a contract.
599      *
600      * Among others, `isContract` will return false for the following
601      * types of addresses:
602      *
603      *  - an externally-owned account
604      *  - a contract in construction
605      *  - an address where a contract will be created
606      *  - an address where a contract lived, but was destroyed
607      * ====
608      */
609     function isContract(address account) internal view returns (bool) {
610         // This method relies on extcodesize, which returns 0 for contracts in
611         // construction, since the code is only stored at the end of the
612         // constructor execution.
613 
614         uint256 size;
615         assembly {
616             size := extcodesize(account)
617         }
618         return size > 0;
619     }
620 
621     /**
622      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
623      * `recipient`, forwarding all available gas and reverting on errors.
624      *
625      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
626      * of certain opcodes, possibly making contracts go over the 2300 gas limit
627      * imposed by `transfer`, making them unable to receive funds via
628      * `transfer`. {sendValue} removes this limitation.
629      *
630      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
631      *
632      * IMPORTANT: because control is transferred to `recipient`, care must be
633      * taken to not create reentrancy vulnerabilities. Consider using
634      * {ReentrancyGuard} or the
635      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
636      */
637     function sendValue(address payable recipient, uint256 amount) internal {
638         require(address(this).balance >= amount, "Address: insufficient balance");
639 
640         (bool success, ) = recipient.call{value: amount}("");
641         require(success, "Address: unable to send value, recipient may have reverted");
642     }
643 
644     /**
645      * @dev Performs a Solidity function call using a low level `call`. A
646      * plain `call` is an unsafe replacement for a function call: use this
647      * function instead.
648      *
649      * If `target` reverts with a revert reason, it is bubbled up by this
650      * function (like regular Solidity function calls).
651      *
652      * Returns the raw returned data. To convert to the expected return value,
653      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
654      *
655      * Requirements:
656      *
657      * - `target` must be a contract.
658      * - calling `target` with `data` must not revert.
659      *
660      * _Available since v3.1._
661      */
662     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
663         return functionCall(target, data, "Address: low-level call failed");
664     }
665 
666     /**
667      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
668      * `errorMessage` as a fallback revert reason when `target` reverts.
669      *
670      * _Available since v3.1._
671      */
672     function functionCall(
673         address target,
674         bytes memory data,
675         string memory errorMessage
676     ) internal returns (bytes memory) {
677         return functionCallWithValue(target, data, 0, errorMessage);
678     }
679 
680     /**
681      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
682      * but also transferring `value` wei to `target`.
683      *
684      * Requirements:
685      *
686      * - the calling contract must have an ETH balance of at least `value`.
687      * - the called Solidity function must be `payable`.
688      *
689      * _Available since v3.1._
690      */
691     function functionCallWithValue(
692         address target,
693         bytes memory data,
694         uint256 value
695     ) internal returns (bytes memory) {
696         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
697     }
698 
699     /**
700      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
701      * with `errorMessage` as a fallback revert reason when `target` reverts.
702      *
703      * _Available since v3.1._
704      */
705     function functionCallWithValue(
706         address target,
707         bytes memory data,
708         uint256 value,
709         string memory errorMessage
710     ) internal returns (bytes memory) {
711         require(address(this).balance >= value, "Address: insufficient balance for call");
712         require(isContract(target), "Address: call to non-contract");
713 
714         (bool success, bytes memory returndata) = target.call{value: value}(data);
715         return verifyCallResult(success, returndata, errorMessage);
716     }
717 
718     /**
719      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
720      * but performing a static call.
721      *
722      * _Available since v3.3._
723      */
724     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
725         return functionStaticCall(target, data, "Address: low-level static call failed");
726     }
727 
728     /**
729      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
730      * but performing a static call.
731      *
732      * _Available since v3.3._
733      */
734     function functionStaticCall(
735         address target,
736         bytes memory data,
737         string memory errorMessage
738     ) internal view returns (bytes memory) {
739         require(isContract(target), "Address: static call to non-contract");
740 
741         (bool success, bytes memory returndata) = target.staticcall(data);
742         return verifyCallResult(success, returndata, errorMessage);
743     }
744 
745     /**
746      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
747      * but performing a delegate call.
748      *
749      * _Available since v3.4._
750      */
751     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
752         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
753     }
754 
755     /**
756      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
757      * but performing a delegate call.
758      *
759      * _Available since v3.4._
760      */
761     function functionDelegateCall(
762         address target,
763         bytes memory data,
764         string memory errorMessage
765     ) internal returns (bytes memory) {
766         require(isContract(target), "Address: delegate call to non-contract");
767 
768         (bool success, bytes memory returndata) = target.delegatecall(data);
769         return verifyCallResult(success, returndata, errorMessage);
770     }
771 
772     /**
773      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
774      * revert reason using the provided one.
775      *
776      * _Available since v4.3._
777      */
778     function verifyCallResult(
779         bool success,
780         bytes memory returndata,
781         string memory errorMessage
782     ) internal pure returns (bytes memory) {
783         if (success) {
784             return returndata;
785         } else {
786             // Look for revert reason and bubble it up if present
787             if (returndata.length > 0) {
788                 // The easiest way to bubble the revert reason is using memory via assembly
789 
790                 assembly {
791                     let returndata_size := mload(returndata)
792                     revert(add(32, returndata), returndata_size)
793                 }
794             } else {
795                 revert(errorMessage);
796             }
797         }
798     }
799 }
800 
801 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
802 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
803 
804 /* pragma solidity ^0.8.0; */
805 
806 // CAUTION
807 // This version of SafeMath should only be used with Solidity 0.8 or later,
808 // because it relies on the compiler's built in overflow checks.
809 
810 /**
811  * @dev Wrappers over Solidity's arithmetic operations.
812  *
813  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
814  * now has built in overflow checking.
815  */
816 library SafeMath {
817     /**
818      * @dev Returns the addition of two unsigned integers, with an overflow flag.
819      *
820      * _Available since v3.4._
821      */
822     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
823         unchecked {
824             uint256 c = a + b;
825             if (c < a) return (false, 0);
826             return (true, c);
827         }
828     }
829 
830     /**
831      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
832      *
833      * _Available since v3.4._
834      */
835     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
836         unchecked {
837             if (b > a) return (false, 0);
838             return (true, a - b);
839         }
840     }
841 
842     /**
843      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
844      *
845      * _Available since v3.4._
846      */
847     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
848         unchecked {
849             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
850             // benefit is lost if 'b' is also tested.
851             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
852             if (a == 0) return (true, 0);
853             uint256 c = a * b;
854             if (c / a != b) return (false, 0);
855             return (true, c);
856         }
857     }
858 
859     /**
860      * @dev Returns the division of two unsigned integers, with a division by zero flag.
861      *
862      * _Available since v3.4._
863      */
864     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
865         unchecked {
866             if (b == 0) return (false, 0);
867             return (true, a / b);
868         }
869     }
870 
871     /**
872      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
873      *
874      * _Available since v3.4._
875      */
876     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
877         unchecked {
878             if (b == 0) return (false, 0);
879             return (true, a % b);
880         }
881     }
882 
883     /**
884      * @dev Returns the addition of two unsigned integers, reverting on
885      * overflow.
886      *
887      * Counterpart to Solidity's `+` operator.
888      *
889      * Requirements:
890      *
891      * - Addition cannot overflow.
892      */
893     function add(uint256 a, uint256 b) internal pure returns (uint256) {
894         return a + b;
895     }
896 
897     /**
898      * @dev Returns the subtraction of two unsigned integers, reverting on
899      * overflow (when the result is negative).
900      *
901      * Counterpart to Solidity's `-` operator.
902      *
903      * Requirements:
904      *
905      * - Subtraction cannot overflow.
906      */
907     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
908         return a - b;
909     }
910 
911     /**
912      * @dev Returns the multiplication of two unsigned integers, reverting on
913      * overflow.
914      *
915      * Counterpart to Solidity's `*` operator.
916      *
917      * Requirements:
918      *
919      * - Multiplication cannot overflow.
920      */
921     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
922         return a * b;
923     }
924 
925     /**
926      * @dev Returns the integer division of two unsigned integers, reverting on
927      * division by zero. The result is rounded towards zero.
928      *
929      * Counterpart to Solidity's `/` operator.
930      *
931      * Requirements:
932      *
933      * - The divisor cannot be zero.
934      */
935     function div(uint256 a, uint256 b) internal pure returns (uint256) {
936         return a / b;
937     }
938 
939     /**
940      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
941      * reverting when dividing by zero.
942      *
943      * Counterpart to Solidity's `%` operator. This function uses a `revert`
944      * opcode (which leaves remaining gas untouched) while Solidity uses an
945      * invalid opcode to revert (consuming all remaining gas).
946      *
947      * Requirements:
948      *
949      * - The divisor cannot be zero.
950      */
951     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
952         return a % b;
953     }
954 
955     /**
956      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
957      * overflow (when the result is negative).
958      *
959      * CAUTION: This function is deprecated because it requires allocating memory for the error
960      * message unnecessarily. For custom revert reasons use {trySub}.
961      *
962      * Counterpart to Solidity's `-` operator.
963      *
964      * Requirements:
965      *
966      * - Subtraction cannot overflow.
967      */
968     function sub(
969         uint256 a,
970         uint256 b,
971         string memory errorMessage
972     ) internal pure returns (uint256) {
973         unchecked {
974             require(b <= a, errorMessage);
975             return a - b;
976         }
977     }
978 
979     /**
980      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
981      * division by zero. The result is rounded towards zero.
982      *
983      * Counterpart to Solidity's `/` operator. Note: this function uses a
984      * `revert` opcode (which leaves remaining gas untouched) while Solidity
985      * uses an invalid opcode to revert (consuming all remaining gas).
986      *
987      * Requirements:
988      *
989      * - The divisor cannot be zero.
990      */
991     function div(
992         uint256 a,
993         uint256 b,
994         string memory errorMessage
995     ) internal pure returns (uint256) {
996         unchecked {
997             require(b > 0, errorMessage);
998             return a / b;
999         }
1000     }
1001 
1002     /**
1003      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1004      * reverting with custom message when dividing by zero.
1005      *
1006      * CAUTION: This function is deprecated because it requires allocating memory for the error
1007      * message unnecessarily. For custom revert reasons use {tryMod}.
1008      *
1009      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1010      * opcode (which leaves remaining gas untouched) while Solidity uses an
1011      * invalid opcode to revert (consuming all remaining gas).
1012      *
1013      * Requirements:
1014      *
1015      * - The divisor cannot be zero.
1016      */
1017     function mod(
1018         uint256 a,
1019         uint256 b,
1020         string memory errorMessage
1021     ) internal pure returns (uint256) {
1022         unchecked {
1023             require(b > 0, errorMessage);
1024             return a % b;
1025         }
1026     }
1027 }
1028 
1029 ////// src/IUniswapV2Factory.sol
1030 /* pragma solidity 0.8.10; */
1031 /* pragma experimental ABIEncoderV2; */
1032 
1033 interface IUniswapV2Factory {
1034     event PairCreated(
1035         address indexed token0,
1036         address indexed token1,
1037         address pair,
1038         uint256
1039     );
1040 
1041     function feeTo() external view returns (address);
1042 
1043     function feeToSetter() external view returns (address);
1044 
1045     function getPair(address tokenA, address tokenB)
1046         external
1047         view
1048         returns (address pair);
1049 
1050     function allPairs(uint256) external view returns (address pair);
1051 
1052     function allPairsLength() external view returns (uint256);
1053 
1054     function createPair(address tokenA, address tokenB)
1055         external
1056         returns (address pair);
1057 
1058     function setFeeTo(address) external;
1059 
1060     function setFeeToSetter(address) external;
1061 }
1062 
1063 ////// src/IUniswapV2Pair.sol
1064 /* pragma solidity 0.8.10; */
1065 /* pragma experimental ABIEncoderV2; */
1066 
1067 interface IUniswapV2Pair {
1068     event Approval(
1069         address indexed owner,
1070         address indexed spender,
1071         uint256 value
1072     );
1073     event Transfer(address indexed from, address indexed to, uint256 value);
1074 
1075     function name() external pure returns (string memory);
1076 
1077     function symbol() external pure returns (string memory);
1078 
1079     function decimals() external pure returns (uint8);
1080 
1081     function totalSupply() external view returns (uint256);
1082 
1083     function balanceOf(address owner) external view returns (uint256);
1084 
1085     function allowance(address owner, address spender)
1086         external
1087         view
1088         returns (uint256);
1089 
1090     function approve(address spender, uint256 value) external returns (bool);
1091 
1092     function transfer(address to, uint256 value) external returns (bool);
1093 
1094     function transferFrom(
1095         address from,
1096         address to,
1097         uint256 value
1098     ) external returns (bool);
1099 
1100     function DOMAIN_SEPARATOR() external view returns (bytes32);
1101 
1102     function PERMIT_TYPEHASH() external pure returns (bytes32);
1103 
1104     function nonces(address owner) external view returns (uint256);
1105 
1106     function permit(
1107         address owner,
1108         address spender,
1109         uint256 value,
1110         uint256 deadline,
1111         uint8 v,
1112         bytes32 r,
1113         bytes32 s
1114     ) external;
1115 
1116     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
1117     event Burn(
1118         address indexed sender,
1119         uint256 amount0,
1120         uint256 amount1,
1121         address indexed to
1122     );
1123     event Swap(
1124         address indexed sender,
1125         uint256 amount0In,
1126         uint256 amount1In,
1127         uint256 amount0Out,
1128         uint256 amount1Out,
1129         address indexed to
1130     );
1131     event Sync(uint112 reserve0, uint112 reserve1);
1132 
1133     function MINIMUM_LIQUIDITY() external pure returns (uint256);
1134 
1135     function factory() external view returns (address);
1136 
1137     function token0() external view returns (address);
1138 
1139     function token1() external view returns (address);
1140 
1141     function getReserves()
1142         external
1143         view
1144         returns (
1145             uint112 reserve0,
1146             uint112 reserve1,
1147             uint32 blockTimestampLast
1148         );
1149 
1150     function price0CumulativeLast() external view returns (uint256);
1151 
1152     function price1CumulativeLast() external view returns (uint256);
1153 
1154     function kLast() external view returns (uint256);
1155 
1156     function mint(address to) external returns (uint256 liquidity);
1157 
1158     function burn(address to)
1159         external
1160         returns (uint256 amount0, uint256 amount1);
1161 
1162     function swap(
1163         uint256 amount0Out,
1164         uint256 amount1Out,
1165         address to,
1166         bytes calldata data
1167     ) external;
1168 
1169     function skim(address to) external;
1170 
1171     function sync() external;
1172 
1173     function initialize(address, address) external;
1174 }
1175 
1176 ////// src/IUniswapV2Router02.sol
1177 /* pragma solidity 0.8.10; */
1178 /* pragma experimental ABIEncoderV2; */
1179 
1180 interface IUniswapV2Router02 {
1181     function factory() external pure returns (address);
1182 
1183     function WETH() external pure returns (address);
1184 
1185     function addLiquidity(
1186         address tokenA,
1187         address tokenB,
1188         uint256 amountADesired,
1189         uint256 amountBDesired,
1190         uint256 amountAMin,
1191         uint256 amountBMin,
1192         address to,
1193         uint256 deadline
1194     )
1195         external
1196         returns (
1197             uint256 amountA,
1198             uint256 amountB,
1199             uint256 liquidity
1200         );
1201 
1202     function addLiquidityETH(
1203         address token,
1204         uint256 amountTokenDesired,
1205         uint256 amountTokenMin,
1206         uint256 amountETHMin,
1207         address to,
1208         uint256 deadline
1209     )
1210         external
1211         payable
1212         returns (
1213             uint256 amountToken,
1214             uint256 amountETH,
1215             uint256 liquidity
1216         );
1217 
1218     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1219         uint256 amountIn,
1220         uint256 amountOutMin,
1221         address[] calldata path,
1222         address to,
1223         uint256 deadline
1224     ) external;
1225 
1226     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1227         uint256 amountOutMin,
1228         address[] calldata path,
1229         address to,
1230         uint256 deadline
1231     ) external payable;
1232 
1233     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1234         uint256 amountIn,
1235         uint256 amountOutMin,
1236         address[] calldata path,
1237         address to,
1238         uint256 deadline
1239     ) external;
1240 }
1241 
1242 ////// src/EXPO.sol
1243 /**
1244 
1245 Exponential Capital
1246 
1247 Earning Dashboard:
1248 https://www.exponentialcapital.finance/portfolio
1249 
1250 */
1251 
1252 /* pragma solidity 0.8.10; */
1253 
1254 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1255 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1256 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1257 /* import {Address} from "lib/openzeppelin-contracts/contracts/utils/Address.sol"; */
1258 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1259 
1260 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1261 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1262 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1263 
1264 contract EXPO is Ownable, IERC20 {
1265     address UNISWAPROUTER = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1266     address DEAD = 0x000000000000000000000000000000000000dEaD;
1267     address ZERO = 0x0000000000000000000000000000000000000000;
1268 
1269     string private _name = "Exponential Capital";
1270     string private _symbol = "EXPO";
1271 
1272     uint256 public treasuryFeeBPS = 900;
1273     uint256 public liquidityFeeBPS = 100;
1274     uint256 public dividendFeeBPS = 500;
1275     uint256 public totalFeeBPS = 1500;
1276 
1277     uint256 public swapTokensAtAmount = 100000000 * (10**18);
1278     uint256 public lastSwapTime;
1279     bool swapAllToken = true;
1280 
1281     bool public swapEnabled = true;
1282     bool public taxEnabled = true;
1283     bool public compoundingEnabled = true;
1284 
1285     uint256 private _totalSupply;
1286     bool private swapping;
1287 
1288     address marketingWallet;
1289     address liquidityWallet;
1290 
1291     mapping(address => uint256) private _balances;
1292     mapping(address => mapping(address => uint256)) private _allowances;
1293     mapping(address => bool) private _isExcludedFromFees;
1294     mapping(address => bool) public automatedMarketMakerPairs;
1295     mapping(address => bool) private _whiteList;
1296     mapping(address => bool) isBlacklisted;
1297 
1298     event SwapAndAddLiquidity(
1299         uint256 tokensSwapped,
1300         uint256 nativeReceived,
1301         uint256 tokensIntoLiquidity
1302     );
1303     event SendDividends(uint256 tokensSwapped, uint256 amount);
1304     event ExcludeFromFees(address indexed account, bool isExcluded);
1305     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1306     event UpdateUniswapV2Router(
1307         address indexed newAddress,
1308         address indexed oldAddress
1309     );
1310     event SwapEnabled(bool enabled);
1311     event TaxEnabled(bool enabled);
1312     event CompoundingEnabled(bool enabled);
1313     event BlacklistEnabled(bool enabled);
1314 
1315     DividendTracker public dividendTracker;
1316     IUniswapV2Router02 public uniswapV2Router;
1317 
1318     address public uniswapV2Pair;
1319 
1320     uint256 public maxTxBPS = 100;
1321     uint256 public maxWalletBPS = 200;
1322 
1323     bool isOpen = false;
1324 
1325     mapping(address => bool) private _isExcludedFromMaxTx;
1326     mapping(address => bool) private _isExcludedFromMaxWallet;
1327 
1328     constructor(
1329         address _marketingWallet,
1330         address _liquidityWallet,
1331         address[] memory whitelistAddress
1332     ) {
1333         marketingWallet = _marketingWallet;
1334         liquidityWallet = _liquidityWallet;
1335         includeToWhiteList(whitelistAddress);
1336 
1337         dividendTracker = new DividendTracker(address(this), UNISWAPROUTER);
1338 
1339         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(UNISWAPROUTER);
1340 
1341         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1342             .createPair(address(this), _uniswapV2Router.WETH());
1343 
1344         uniswapV2Router = _uniswapV2Router;
1345         uniswapV2Pair = _uniswapV2Pair;
1346 
1347         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1348 
1349         dividendTracker.excludeFromDividends(address(dividendTracker), true);
1350         dividendTracker.excludeFromDividends(address(this), true);
1351         dividendTracker.excludeFromDividends(owner(), true);
1352         dividendTracker.excludeFromDividends(address(_uniswapV2Router), true);
1353 
1354         excludeFromFees(owner(), true);
1355         excludeFromFees(address(this), true);
1356         excludeFromFees(address(dividendTracker), true);
1357 
1358         excludeFromMaxTx(owner(), true);
1359         excludeFromMaxTx(address(this), true);
1360         excludeFromMaxTx(address(dividendTracker), true);
1361 
1362         excludeFromMaxWallet(owner(), true);
1363         excludeFromMaxWallet(address(this), true);
1364         excludeFromMaxWallet(address(dividendTracker), true);
1365 
1366         _mint(owner(), 816722973503 * (10**18));
1367     }
1368 
1369     receive() external payable {}
1370 
1371     function name() public view returns (string memory) {
1372         return _name;
1373     }
1374 
1375     function symbol() public view returns (string memory) {
1376         return _symbol;
1377     }
1378 
1379     function decimals() public pure returns (uint8) {
1380         return 18;
1381     }
1382 
1383     function totalSupply() public view virtual override returns (uint256) {
1384         return _totalSupply;
1385     }
1386 
1387     function balanceOf(address account)
1388         public
1389         view
1390         virtual
1391         override
1392         returns (uint256)
1393     {
1394         return _balances[account];
1395     }
1396 
1397     function allowance(address owner, address spender)
1398         public
1399         view
1400         virtual
1401         override
1402         returns (uint256)
1403     {
1404         return _allowances[owner][spender];
1405     }
1406 
1407     function approve(address spender, uint256 amount)
1408         public
1409         virtual
1410         override
1411         returns (bool)
1412     {
1413         _approve(_msgSender(), spender, amount);
1414         return true;
1415     }
1416 
1417     function increaseAllowance(address spender, uint256 addedValue)
1418         public
1419         returns (bool)
1420     {
1421         _approve(
1422             _msgSender(),
1423             spender,
1424             _allowances[_msgSender()][spender] + addedValue
1425         );
1426         return true;
1427     }
1428 
1429     function decreaseAllowance(address spender, uint256 subtractedValue)
1430         public
1431         returns (bool)
1432     {
1433         uint256 currentAllowance = _allowances[_msgSender()][spender];
1434         require(
1435             currentAllowance >= subtractedValue,
1436             "EXPO: decreased allowance below zero"
1437         );
1438         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1439         return true;
1440     }
1441 
1442     function transfer(address recipient, uint256 amount)
1443         public
1444         virtual
1445         override
1446         returns (bool)
1447     {
1448         _transfer(_msgSender(), recipient, amount);
1449         return true;
1450     }
1451 
1452     function transferFrom(
1453         address sender,
1454         address recipient,
1455         uint256 amount
1456     ) public virtual override returns (bool) {
1457         _transfer(sender, recipient, amount);
1458         uint256 currentAllowance = _allowances[sender][_msgSender()];
1459         require(
1460             currentAllowance >= amount,
1461             "EXPO: transfer amount exceeds allowance"
1462         );
1463         _approve(sender, _msgSender(), currentAllowance - amount);
1464         return true;
1465     }
1466 
1467     function openTrading() external onlyOwner {
1468         isOpen = true;
1469     }
1470 
1471     function _transfer(
1472         address sender,
1473         address recipient,
1474         uint256 amount
1475     ) internal {
1476         require(
1477             isOpen ||
1478                 sender == owner() ||
1479                 recipient == owner() ||
1480                 _whiteList[sender] ||
1481                 _whiteList[recipient],
1482             "Not Open"
1483         );
1484 
1485         require(!isBlacklisted[sender], "EXPO: Sender is blacklisted");
1486         require(!isBlacklisted[recipient], "EXPO: Recipient is blacklisted");
1487 
1488         require(sender != address(0), "EXPO: transfer from the zero address");
1489         require(recipient != address(0), "EXPO: transfer to the zero address");
1490 
1491         uint256 _maxTxAmount = (totalSupply() * maxTxBPS) / 10000;
1492         uint256 _maxWallet = (totalSupply() * maxWalletBPS) / 10000;
1493         require(
1494             amount <= _maxTxAmount || _isExcludedFromMaxTx[sender],
1495             "TX Limit Exceeded"
1496         );
1497 
1498         if (
1499             sender != owner() &&
1500             recipient != address(this) &&
1501             recipient != address(DEAD) &&
1502             recipient != uniswapV2Pair
1503         ) {
1504             uint256 currentBalance = balanceOf(recipient);
1505             require(
1506                 _isExcludedFromMaxWallet[recipient] ||
1507                     (currentBalance + amount <= _maxWallet)
1508             );
1509         }
1510 
1511         uint256 senderBalance = _balances[sender];
1512         require(
1513             senderBalance >= amount,
1514             "EXPO: transfer amount exceeds balance"
1515         );
1516 
1517         uint256 contractTokenBalance = balanceOf(address(this));
1518         uint256 contractNativeBalance = address(this).balance;
1519 
1520         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1521 
1522         if (
1523             swapEnabled && // True
1524             canSwap && // true
1525             !swapping && // swapping=false !false true
1526             !automatedMarketMakerPairs[sender] && // no swap on remove liquidity step 1 or DEX buy
1527             sender != address(uniswapV2Router) && // no swap on remove liquidity step 2
1528             sender != owner() &&
1529             recipient != owner()
1530         ) {
1531             swapping = true;
1532 
1533             if (!swapAllToken) {
1534                 contractTokenBalance = swapTokensAtAmount;
1535             }
1536             _executeSwap(contractTokenBalance, contractNativeBalance);
1537 
1538             lastSwapTime = block.timestamp;
1539             swapping = false;
1540         }
1541 
1542         bool takeFee;
1543 
1544         if (
1545             sender == address(uniswapV2Pair) ||
1546             recipient == address(uniswapV2Pair)
1547         ) {
1548             takeFee = true;
1549         }
1550 
1551         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
1552             takeFee = false;
1553         }
1554 
1555         if (swapping || !taxEnabled) {
1556             takeFee = false;
1557         }
1558 
1559         if (takeFee) {
1560             uint256 fees = (amount * totalFeeBPS) / 10000;
1561             amount -= fees;
1562             _executeTransfer(sender, address(this), fees);
1563         }
1564 
1565         _executeTransfer(sender, recipient, amount);
1566 
1567         dividendTracker.setBalance(payable(sender), balanceOf(sender));
1568         dividendTracker.setBalance(payable(recipient), balanceOf(recipient));
1569     }
1570 
1571     function _executeTransfer(
1572         address sender,
1573         address recipient,
1574         uint256 amount
1575     ) private {
1576         require(sender != address(0), "EXPO: transfer from the zero address");
1577         require(recipient != address(0), "EXPO: transfer to the zero address");
1578         uint256 senderBalance = _balances[sender];
1579         require(
1580             senderBalance >= amount,
1581             "EXPO: transfer amount exceeds balance"
1582         );
1583         _balances[sender] = senderBalance - amount;
1584         _balances[recipient] += amount;
1585         emit Transfer(sender, recipient, amount);
1586     }
1587 
1588     function _approve(
1589         address owner,
1590         address spender,
1591         uint256 amount
1592     ) private {
1593         require(owner != address(0), "EXPO: approve from the zero address");
1594         require(spender != address(0), "EXPO: approve to the zero address");
1595         _allowances[owner][spender] = amount;
1596         emit Approval(owner, spender, amount);
1597     }
1598 
1599     function _mint(address account, uint256 amount) private {
1600         require(account != address(0), "EXPO: mint to the zero address");
1601         _totalSupply += amount;
1602         _balances[account] += amount;
1603         emit Transfer(address(0), account, amount);
1604     }
1605 
1606     function _burn(address account, uint256 amount) private {
1607         require(account != address(0), "EXPO: burn from the zero address");
1608         uint256 accountBalance = _balances[account];
1609         require(accountBalance >= amount, "EXPO: burn amount exceeds balance");
1610         _balances[account] = accountBalance - amount;
1611         _totalSupply -= amount;
1612         emit Transfer(account, address(0), amount);
1613     }
1614 
1615     function swapTokensForNative(uint256 tokens) private {
1616         address[] memory path = new address[](2);
1617         path[0] = address(this);
1618         path[1] = uniswapV2Router.WETH();
1619         _approve(address(this), address(uniswapV2Router), tokens);
1620         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1621             tokens,
1622             0, // accept any amount of native
1623             path,
1624             address(this),
1625             block.timestamp
1626         );
1627     }
1628 
1629     function addLiquidity(uint256 tokens, uint256 native) private {
1630         _approve(address(this), address(uniswapV2Router), tokens);
1631         uniswapV2Router.addLiquidityETH{value: native}(
1632             address(this),
1633             tokens,
1634             0, // slippage unavoidable
1635             0, // slippage unavoidable
1636             liquidityWallet,
1637             block.timestamp
1638         );
1639     }
1640 
1641     function includeToWhiteList(address[] memory _users) private {
1642         for (uint8 i = 0; i < _users.length; i++) {
1643             _whiteList[_users[i]] = true;
1644         }
1645     }
1646 
1647     function _executeSwap(uint256 tokens, uint256 native) private {
1648         if (tokens <= 0) {
1649             return;
1650         }
1651 
1652         uint256 swapTokensMarketing;
1653         if (address(marketingWallet) != address(0)) {
1654             swapTokensMarketing = (tokens * treasuryFeeBPS) / totalFeeBPS;
1655         }
1656 
1657         uint256 swapTokensDividends;
1658         if (dividendTracker.totalSupply() > 0) {
1659             swapTokensDividends = (tokens * dividendFeeBPS) / totalFeeBPS;
1660         }
1661 
1662         uint256 tokensForLiquidity = tokens -
1663             swapTokensMarketing -
1664             swapTokensDividends;
1665         uint256 swapTokensLiquidity = tokensForLiquidity / 2;
1666         uint256 addTokensLiquidity = tokensForLiquidity - swapTokensLiquidity;
1667         uint256 swapTokensTotal = swapTokensMarketing +
1668             swapTokensDividends +
1669             swapTokensLiquidity;
1670 
1671         uint256 initNativeBal = address(this).balance;
1672         swapTokensForNative(swapTokensTotal);
1673         uint256 nativeSwapped = (address(this).balance - initNativeBal) +
1674             native;
1675 
1676         uint256 nativeMarketing = (nativeSwapped * swapTokensMarketing) /
1677             swapTokensTotal;
1678         uint256 nativeDividends = (nativeSwapped * swapTokensDividends) /
1679             swapTokensTotal;
1680         uint256 nativeLiquidity = nativeSwapped -
1681             nativeMarketing -
1682             nativeDividends;
1683 
1684         if (nativeMarketing > 0) {
1685             payable(marketingWallet).transfer(nativeMarketing);
1686         }
1687 
1688         addLiquidity(addTokensLiquidity, nativeLiquidity);
1689         emit SwapAndAddLiquidity(
1690             swapTokensLiquidity,
1691             nativeLiquidity,
1692             addTokensLiquidity
1693         );
1694 
1695         if (nativeDividends > 0) {
1696             (bool success, ) = address(dividendTracker).call{
1697                 value: nativeDividends
1698             }("");
1699             if (success) {
1700                 emit SendDividends(swapTokensDividends, nativeDividends);
1701             }
1702         }
1703     }
1704 
1705     function excludeFromFees(address account, bool excluded) public onlyOwner {
1706         require(
1707             _isExcludedFromFees[account] != excluded,
1708             "EXPO: account is already set to requested state"
1709         );
1710         _isExcludedFromFees[account] = excluded;
1711         emit ExcludeFromFees(account, excluded);
1712     }
1713 
1714     function isExcludedFromFees(address account) public view returns (bool) {
1715         return _isExcludedFromFees[account];
1716     }
1717 
1718     function manualSendDividend(uint256 amount, address holder)
1719         external
1720         onlyOwner
1721     {
1722         dividendTracker.manualSendDividend(amount, holder);
1723     }
1724 
1725     function excludeFromDividends(address account, bool excluded)
1726         public
1727         onlyOwner
1728     {
1729         dividendTracker.excludeFromDividends(account, excluded);
1730     }
1731 
1732     function isExcludedFromDividends(address account)
1733         public
1734         view
1735         returns (bool)
1736     {
1737         return dividendTracker.isExcludedFromDividends(account);
1738     }
1739 
1740     function setWallet(
1741         address payable _marketingWallet,
1742         address payable _liquidityWallet
1743     ) external onlyOwner {
1744         marketingWallet = _marketingWallet;
1745         liquidityWallet = _liquidityWallet;
1746     }
1747 
1748     function setAutomatedMarketMakerPair(address pair, bool value)
1749         public
1750         onlyOwner
1751     {
1752         require(pair != uniswapV2Pair, "EXPO: DEX pair can not be removed");
1753         _setAutomatedMarketMakerPair(pair, value);
1754     }
1755 
1756     function setFee(
1757         uint256 _treasuryFee,
1758         uint256 _liquidityFee,
1759         uint256 _dividendFee
1760     ) external onlyOwner {
1761         treasuryFeeBPS = _treasuryFee;
1762         liquidityFeeBPS = _liquidityFee;
1763         dividendFeeBPS = _dividendFee;
1764         totalFeeBPS = _treasuryFee + _liquidityFee + _dividendFee;
1765     }
1766 
1767     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1768         require(
1769             automatedMarketMakerPairs[pair] != value,
1770             "EXPO: automated market maker pair is already set to that value"
1771         );
1772         automatedMarketMakerPairs[pair] = value;
1773         if (value) {
1774             dividendTracker.excludeFromDividends(pair, true);
1775         }
1776         emit SetAutomatedMarketMakerPair(pair, value);
1777     }
1778 
1779     function updateUniswapV2Router(address newAddress) public onlyOwner {
1780         require(
1781             newAddress != address(uniswapV2Router),
1782             "EXPO: the router is already set to the new address"
1783         );
1784         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
1785         uniswapV2Router = IUniswapV2Router02(newAddress);
1786         address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
1787             .createPair(address(this), uniswapV2Router.WETH());
1788         uniswapV2Pair = _uniswapV2Pair;
1789     }
1790 
1791     function claim() public {
1792         dividendTracker.processAccount(payable(_msgSender()));
1793     }
1794 
1795     function compound() public {
1796         require(compoundingEnabled, "EXPO: compounding is not enabled");
1797         dividendTracker.compoundAccount(payable(_msgSender()));
1798     }
1799 
1800     function withdrawableDividendOf(address account)
1801         public
1802         view
1803         returns (uint256)
1804     {
1805         return dividendTracker.withdrawableDividendOf(account);
1806     }
1807 
1808     function withdrawnDividendOf(address account)
1809         public
1810         view
1811         returns (uint256)
1812     {
1813         return dividendTracker.withdrawnDividendOf(account);
1814     }
1815 
1816     function accumulativeDividendOf(address account)
1817         public
1818         view
1819         returns (uint256)
1820     {
1821         return dividendTracker.accumulativeDividendOf(account);
1822     }
1823 
1824     function getAccountInfo(address account)
1825         public
1826         view
1827         returns (
1828             address,
1829             uint256,
1830             uint256,
1831             uint256,
1832             uint256
1833         )
1834     {
1835         return dividendTracker.getAccountInfo(account);
1836     }
1837 
1838     function getLastClaimTime(address account) public view returns (uint256) {
1839         return dividendTracker.getLastClaimTime(account);
1840     }
1841 
1842     function setSwapEnabled(bool _enabled) external onlyOwner {
1843         swapEnabled = _enabled;
1844         emit SwapEnabled(_enabled);
1845     }
1846 
1847     function setTaxEnabled(bool _enabled) external onlyOwner {
1848         taxEnabled = _enabled;
1849         emit TaxEnabled(_enabled);
1850     }
1851 
1852     function setCompoundingEnabled(bool _enabled) external onlyOwner {
1853         compoundingEnabled = _enabled;
1854         emit CompoundingEnabled(_enabled);
1855     }
1856 
1857     function updateDividendSettings(
1858         bool _swapEnabled,
1859         uint256 _swapTokensAtAmount,
1860         bool _swapAllToken
1861     ) external onlyOwner {
1862         swapEnabled = _swapEnabled;
1863         swapTokensAtAmount = _swapTokensAtAmount;
1864         swapAllToken = _swapAllToken;
1865     }
1866 
1867     function setMaxTxBPS(uint256 bps) external onlyOwner {
1868         require(bps >= 75 && bps <= 10000, "BPS must be between 75 and 10000");
1869         maxTxBPS = bps;
1870     }
1871 
1872     function excludeFromMaxTx(address account, bool excluded) public onlyOwner {
1873         _isExcludedFromMaxTx[account] = excluded;
1874     }
1875 
1876     function isExcludedFromMaxTx(address account) public view returns (bool) {
1877         return _isExcludedFromMaxTx[account];
1878     }
1879 
1880     function setMaxWalletBPS(uint256 bps) external onlyOwner {
1881         require(
1882             bps >= 175 && bps <= 10000,
1883             "BPS must be between 175 and 10000"
1884         );
1885         maxWalletBPS = bps;
1886     }
1887 
1888     function excludeFromMaxWallet(address account, bool excluded)
1889         public
1890         onlyOwner
1891     {
1892         _isExcludedFromMaxWallet[account] = excluded;
1893     }
1894 
1895     function isExcludedFromMaxWallet(address account)
1896         public
1897         view
1898         returns (bool)
1899     {
1900         return _isExcludedFromMaxWallet[account];
1901     }
1902 
1903     function rescueToken(address _token, uint256 _amount) external onlyOwner {
1904         IERC20(_token).transfer(msg.sender, _amount);
1905     }
1906 
1907     function rescueETH(uint256 _amount) external onlyOwner {
1908         payable(msg.sender).transfer(_amount);
1909     }
1910 
1911     function blackList(address _user) public onlyOwner {
1912         require(!isBlacklisted[_user], "user already blacklisted");
1913         isBlacklisted[_user] = true;
1914         // events?
1915     }
1916 
1917     function removeFromBlacklist(address _user) public onlyOwner {
1918         require(isBlacklisted[_user], "user already whitelisted");
1919         isBlacklisted[_user] = false;
1920         //events?
1921     }
1922 
1923     function blackListMany(address[] memory _users) public onlyOwner {
1924         for (uint8 i = 0; i < _users.length; i++) {
1925             isBlacklisted[_users[i]] = true;
1926         }
1927     }
1928 
1929     function unBlackListMany(address[] memory _users) public onlyOwner {
1930         for (uint8 i = 0; i < _users.length; i++) {
1931             isBlacklisted[_users[i]] = false;
1932         }
1933     }
1934 }
1935 
1936 contract DividendTracker is Ownable, IERC20 {
1937     address UNISWAPROUTER;
1938 
1939     string private _name = "EXPO_DividendTracker";
1940     string private _symbol = "EXPO_DividendTracker";
1941 
1942     uint256 public lastProcessedIndex;
1943 
1944     uint256 private _totalSupply;
1945     mapping(address => uint256) private _balances;
1946 
1947     uint256 private constant magnitude = 2**128;
1948     uint256 public immutable minTokenBalanceForDividends;
1949     uint256 private magnifiedDividendPerShare;
1950     uint256 public totalDividendsDistributed;
1951     uint256 public totalDividendsWithdrawn;
1952 
1953     address public tokenAddress;
1954 
1955     mapping(address => bool) public excludedFromDividends;
1956     mapping(address => int256) private magnifiedDividendCorrections;
1957     mapping(address => uint256) private withdrawnDividends;
1958     mapping(address => uint256) private lastClaimTimes;
1959 
1960     event DividendsDistributed(address indexed from, uint256 weiAmount);
1961     event DividendWithdrawn(address indexed to, uint256 weiAmount);
1962     event ExcludeFromDividends(address indexed account, bool excluded);
1963     event Claim(address indexed account, uint256 amount);
1964     event Compound(address indexed account, uint256 amount, uint256 tokens);
1965 
1966     struct AccountInfo {
1967         address account;
1968         uint256 withdrawableDividends;
1969         uint256 totalDividends;
1970         uint256 lastClaimTime;
1971     }
1972 
1973     constructor(address _tokenAddress, address _uniswapRouter) {
1974         minTokenBalanceForDividends = 10000 * (10**18);
1975         tokenAddress = _tokenAddress;
1976         UNISWAPROUTER = _uniswapRouter;
1977     }
1978 
1979     receive() external payable {
1980         distributeDividends();
1981     }
1982 
1983     function distributeDividends() public payable {
1984         require(_totalSupply > 0);
1985         if (msg.value > 0) {
1986             magnifiedDividendPerShare =
1987                 magnifiedDividendPerShare +
1988                 ((msg.value * magnitude) / _totalSupply);
1989             emit DividendsDistributed(msg.sender, msg.value);
1990             totalDividendsDistributed += msg.value;
1991         }
1992     }
1993 
1994     function setBalance(address payable account, uint256 newBalance)
1995         external
1996         onlyOwner
1997     {
1998         if (excludedFromDividends[account]) {
1999             return;
2000         }
2001         if (newBalance >= minTokenBalanceForDividends) {
2002             _setBalance(account, newBalance);
2003         } else {
2004             _setBalance(account, 0);
2005         }
2006     }
2007 
2008     function excludeFromDividends(address account, bool excluded)
2009         external
2010         onlyOwner
2011     {
2012         require(
2013             excludedFromDividends[account] != excluded,
2014             "EXPO_DividendTracker: account already set to requested state"
2015         );
2016         excludedFromDividends[account] = excluded;
2017         if (excluded) {
2018             _setBalance(account, 0);
2019         } else {
2020             uint256 newBalance = IERC20(tokenAddress).balanceOf(account);
2021             if (newBalance >= minTokenBalanceForDividends) {
2022                 _setBalance(account, newBalance);
2023             } else {
2024                 _setBalance(account, 0);
2025             }
2026         }
2027         emit ExcludeFromDividends(account, excluded);
2028     }
2029 
2030     function isExcludedFromDividends(address account)
2031         public
2032         view
2033         returns (bool)
2034     {
2035         return excludedFromDividends[account];
2036     }
2037 
2038     function manualSendDividend(uint256 amount, address holder)
2039         external
2040         onlyOwner
2041     {
2042         uint256 contractETHBalance = address(this).balance;
2043         payable(holder).transfer(amount > 0 ? amount : contractETHBalance);
2044     }
2045 
2046     function _setBalance(address account, uint256 newBalance) internal {
2047         uint256 currentBalance = _balances[account];
2048         if (newBalance > currentBalance) {
2049             uint256 addAmount = newBalance - currentBalance;
2050             _mint(account, addAmount);
2051         } else if (newBalance < currentBalance) {
2052             uint256 subAmount = currentBalance - newBalance;
2053             _burn(account, subAmount);
2054         }
2055     }
2056 
2057     function _mint(address account, uint256 amount) private {
2058         require(
2059             account != address(0),
2060             "EXPO_DividendTracker: mint to the zero address"
2061         );
2062         _totalSupply += amount;
2063         _balances[account] += amount;
2064         emit Transfer(address(0), account, amount);
2065         magnifiedDividendCorrections[account] =
2066             magnifiedDividendCorrections[account] -
2067             int256(magnifiedDividendPerShare * amount);
2068     }
2069 
2070     function _burn(address account, uint256 amount) private {
2071         require(
2072             account != address(0),
2073             "EXPO_DividendTracker: burn from the zero address"
2074         );
2075         uint256 accountBalance = _balances[account];
2076         require(
2077             accountBalance >= amount,
2078             "EXPO_DividendTracker: burn amount exceeds balance"
2079         );
2080         _balances[account] = accountBalance - amount;
2081         _totalSupply -= amount;
2082         emit Transfer(account, address(0), amount);
2083         magnifiedDividendCorrections[account] =
2084             magnifiedDividendCorrections[account] +
2085             int256(magnifiedDividendPerShare * amount);
2086     }
2087 
2088     function processAccount(address payable account)
2089         public
2090         onlyOwner
2091         returns (bool)
2092     {
2093         uint256 amount = _withdrawDividendOfUser(account);
2094         if (amount > 0) {
2095             lastClaimTimes[account] = block.timestamp;
2096             emit Claim(account, amount);
2097             return true;
2098         }
2099         return false;
2100     }
2101 
2102     function _withdrawDividendOfUser(address payable account)
2103         private
2104         returns (uint256)
2105     {
2106         uint256 _withdrawableDividend = withdrawableDividendOf(account);
2107         if (_withdrawableDividend > 0) {
2108             withdrawnDividends[account] += _withdrawableDividend;
2109             totalDividendsWithdrawn += _withdrawableDividend;
2110             emit DividendWithdrawn(account, _withdrawableDividend);
2111             (bool success, ) = account.call{
2112                 value: _withdrawableDividend,
2113                 gas: 3000
2114             }("");
2115             if (!success) {
2116                 withdrawnDividends[account] -= _withdrawableDividend;
2117                 totalDividendsWithdrawn -= _withdrawableDividend;
2118                 return 0;
2119             }
2120             return _withdrawableDividend;
2121         }
2122         return 0;
2123     }
2124 
2125     function compoundAccount(address payable account)
2126         public
2127         onlyOwner
2128         returns (bool)
2129     {
2130         (uint256 amount, uint256 tokens) = _compoundDividendOfUser(account);
2131         if (amount > 0) {
2132             lastClaimTimes[account] = block.timestamp;
2133             emit Compound(account, amount, tokens);
2134             return true;
2135         }
2136         return false;
2137     }
2138 
2139     function _compoundDividendOfUser(address payable account)
2140         private
2141         returns (uint256, uint256)
2142     {
2143         uint256 _withdrawableDividend = withdrawableDividendOf(account);
2144         if (_withdrawableDividend > 0) {
2145             withdrawnDividends[account] += _withdrawableDividend;
2146             totalDividendsWithdrawn += _withdrawableDividend;
2147             emit DividendWithdrawn(account, _withdrawableDividend);
2148 
2149             IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(
2150                 UNISWAPROUTER
2151             );
2152 
2153             address[] memory path = new address[](2);
2154             path[0] = uniswapV2Router.WETH();
2155             path[1] = address(tokenAddress);
2156 
2157             bool success;
2158             uint256 tokens;
2159 
2160             uint256 initTokenBal = IERC20(tokenAddress).balanceOf(account);
2161             try
2162                 uniswapV2Router
2163                     .swapExactETHForTokensSupportingFeeOnTransferTokens{
2164                     value: _withdrawableDividend
2165                 }(0, path, address(account), block.timestamp)
2166             {
2167                 success = true;
2168                 tokens = IERC20(tokenAddress).balanceOf(account) - initTokenBal;
2169             } catch Error(
2170                 string memory /*err*/
2171             ) {
2172                 success = false;
2173             }
2174 
2175             if (!success) {
2176                 withdrawnDividends[account] -= _withdrawableDividend;
2177                 totalDividendsWithdrawn -= _withdrawableDividend;
2178                 return (0, 0);
2179             }
2180 
2181             return (_withdrawableDividend, tokens);
2182         }
2183         return (0, 0);
2184     }
2185 
2186     function withdrawableDividendOf(address account)
2187         public
2188         view
2189         returns (uint256)
2190     {
2191         return accumulativeDividendOf(account) - withdrawnDividends[account];
2192     }
2193 
2194     function withdrawnDividendOf(address account)
2195         public
2196         view
2197         returns (uint256)
2198     {
2199         return withdrawnDividends[account];
2200     }
2201 
2202     function accumulativeDividendOf(address account)
2203         public
2204         view
2205         returns (uint256)
2206     {
2207         int256 a = int256(magnifiedDividendPerShare * balanceOf(account));
2208         int256 b = magnifiedDividendCorrections[account]; // this is an explicit int256 (signed)
2209         return uint256(a + b) / magnitude;
2210     }
2211 
2212     function getAccountInfo(address account)
2213         public
2214         view
2215         returns (
2216             address,
2217             uint256,
2218             uint256,
2219             uint256,
2220             uint256
2221         )
2222     {
2223         AccountInfo memory info;
2224         info.account = account;
2225         info.withdrawableDividends = withdrawableDividendOf(account);
2226         info.totalDividends = accumulativeDividendOf(account);
2227         info.lastClaimTime = lastClaimTimes[account];
2228         return (
2229             info.account,
2230             info.withdrawableDividends,
2231             info.totalDividends,
2232             info.lastClaimTime,
2233             totalDividendsWithdrawn
2234         );
2235     }
2236 
2237     function getLastClaimTime(address account) public view returns (uint256) {
2238         return lastClaimTimes[account];
2239     }
2240 
2241     function name() public view returns (string memory) {
2242         return _name;
2243     }
2244 
2245     function symbol() public view returns (string memory) {
2246         return _symbol;
2247     }
2248 
2249     function decimals() public pure returns (uint8) {
2250         return 18;
2251     }
2252 
2253     function totalSupply() public view override returns (uint256) {
2254         return _totalSupply;
2255     }
2256 
2257     function balanceOf(address account) public view override returns (uint256) {
2258         return _balances[account];
2259     }
2260 
2261     function transfer(address, uint256) public pure override returns (bool) {
2262         revert("EXPO_DividendTracker: method not implemented");
2263     }
2264 
2265     function allowance(address, address)
2266         public
2267         pure
2268         override
2269         returns (uint256)
2270     {
2271         revert("EXPO_DividendTracker: method not implemented");
2272     }
2273 
2274     function approve(address, uint256) public pure override returns (bool) {
2275         revert("EXPO_DividendTracker: method not implemented");
2276     }
2277 
2278     function transferFrom(
2279         address,
2280         address,
2281         uint256
2282     ) public pure override returns (bool) {
2283         revert("EXPO_DividendTracker: method not implemented");
2284     }
2285 }