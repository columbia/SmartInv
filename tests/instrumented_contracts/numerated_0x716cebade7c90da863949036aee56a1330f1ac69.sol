1 /**
2  *Submitted for verification at Etherscan.io on 2021-12-27
3 */
4 
5 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
6 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
7 
8 /* pragma solidity ^0.8.0; */
9 
10 /**
11  * @dev Provides information about the current execution context, including the
12  * sender of the transaction and its data. While these are generally available
13  * via msg.sender and msg.data, they should not be accessed in such a direct
14  * manner, since when dealing with meta-transactions the account sending and
15  * paying for execution may not be the actual sender (as far as an application
16  * is concerned).
17  *
18  * This contract is only required for intermediate, library-like contracts.
19  */
20 abstract contract Context {
21     function _msgSender() internal view virtual returns (address) {
22         return msg.sender;
23     }
24 
25     function _msgData() internal view virtual returns (bytes calldata) {
26         return msg.data;
27     }
28 }
29 
30 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
31 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
32 
33 /* pragma solidity ^0.8.0; */
34 
35 /* import "../utils/Context.sol"; */
36 
37 /**
38  * @dev Contract module which provides a basic access control mechanism, where
39  * there is an account (an owner) that can be granted exclusive access to
40  * specific functions.
41  *
42  * By default, the owner account will be the one that deploys the contract. This
43  * can later be changed with {transferOwnership}.
44  *
45  * This module is used through inheritance. It will make available the modifier
46  * `onlyOwner`, which can be applied to your functions to restrict their use to
47  * the owner.
48  */
49 abstract contract Ownable is Context {
50     address private _owner;
51 
52     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
53 
54     /**
55      * @dev Initializes the contract setting the deployer as the initial owner.
56      */
57     constructor() {
58         _transferOwnership(_msgSender());
59     }
60 
61     /**
62      * @dev Returns the address of the current owner.
63      */
64     function owner() public view virtual returns (address) {
65         return _owner;
66     }
67 
68     /**
69      * @dev Throws if called by any account other than the owner.
70      */
71     modifier onlyOwner() {
72         require(owner() == _msgSender(), "Ownable: caller is not the owner");
73         _;
74     }
75 
76     /**
77      * @dev Leaves the contract without owner. It will not be possible to call
78      * `onlyOwner` functions anymore. Can only be called by the current owner.
79      *
80      * NOTE: Renouncing ownership will leave the contract without an owner,
81      * thereby removing any functionality that is only available to the owner.
82      */
83     function renounceOwnership() public virtual onlyOwner {
84         _transferOwnership(address(0));
85     }
86 
87     /**
88      * @dev Transfers ownership of the contract to a new account (`newOwner`).
89      * Can only be called by the current owner.
90      */
91     function transferOwnership(address newOwner) public virtual onlyOwner {
92         require(newOwner != address(0), "Ownable: new owner is the zero address");
93         _transferOwnership(newOwner);
94     }
95 
96     /**
97      * @dev Transfers ownership of the contract to a new account (`newOwner`).
98      * Internal function without access restriction.
99      */
100     function _transferOwnership(address newOwner) internal virtual {
101         address oldOwner = _owner;
102         _owner = newOwner;
103         emit OwnershipTransferred(oldOwner, newOwner);
104     }
105 }
106 
107 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
108 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
109 
110 /* pragma solidity ^0.8.0; */
111 
112 /**
113  * @dev Interface of the ERC20 standard as defined in the EIP.
114  */
115 interface IERC20 {
116     /**
117      * @dev Returns the amount of tokens in existence.
118      */
119     function totalSupply() external view returns (uint256);
120 
121     /**
122      * @dev Returns the amount of tokens owned by `account`.
123      */
124     function balanceOf(address account) external view returns (uint256);
125 
126     /**
127      * @dev Moves `amount` tokens from the caller's account to `recipient`.
128      *
129      * Returns a boolean value indicating whether the operation succeeded.
130      *
131      * Emits a {Transfer} event.
132      */
133     function transfer(address recipient, uint256 amount) external returns (bool);
134 
135     /**
136      * @dev Returns the remaining number of tokens that `spender` will be
137      * allowed to spend on behalf of `owner` through {transferFrom}. This is
138      * zero by default.
139      *
140      * This value changes when {approve} or {transferFrom} are called.
141      */
142     function allowance(address owner, address spender) external view returns (uint256);
143 
144     /**
145      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
146      *
147      * Returns a boolean value indicating whether the operation succeeded.
148      *
149      * IMPORTANT: Beware that changing an allowance with this method brings the risk
150      * that someone may use both the old and the new allowance by unfortunate
151      * transaction ordering. One possible solution to mitigate this race
152      * condition is to first reduce the spender's allowance to 0 and set the
153      * desired value afterwards:
154      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
155      *
156      * Emits an {Approval} event.
157      */
158     function approve(address spender, uint256 amount) external returns (bool);
159 
160     /**
161      * @dev Moves `amount` tokens from `sender` to `recipient` using the
162      * allowance mechanism. `amount` is then deducted from the caller's
163      * allowance.
164      *
165      * Returns a boolean value indicating whether the operation succeeded.
166      *
167      * Emits a {Transfer} event.
168      */
169     function transferFrom(
170         address sender,
171         address recipient,
172         uint256 amount
173     ) external returns (bool);
174 
175     /**
176      * @dev Emitted when `value` tokens are moved from one account (`from`) to
177      * another (`to`).
178      *
179      * Note that `value` may be zero.
180      */
181     event Transfer(address indexed from, address indexed to, uint256 value);
182 
183     /**
184      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
185      * a call to {approve}. `value` is the new allowance.
186      */
187     event Approval(address indexed owner, address indexed spender, uint256 value);
188 }
189 
190 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
191 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
192 
193 /* pragma solidity ^0.8.0; */
194 
195 /* import "../IERC20.sol"; */
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
219 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
220 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
221 
222 /* pragma solidity ^0.8.0; */
223 
224 /* import "./IERC20.sol"; */
225 /* import "./extensions/IERC20Metadata.sol"; */
226 /* import "../../utils/Context.sol"; */
227 
228 /**
229  * @dev Implementation of the {IERC20} interface.
230  *
231  * This implementation is agnostic to the way tokens are created. This means
232  * that a supply mechanism has to be added in a derived contract using {_mint}.
233  * For a generic mechanism see {ERC20PresetMinterPauser}.
234  *
235  * TIP: For a detailed writeup see our guide
236  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
237  * to implement supply mechanisms].
238  *
239  * We have followed general OpenZeppelin Contracts guidelines: functions revert
240  * instead returning `false` on failure. This behavior is nonetheless
241  * conventional and does not conflict with the expectations of ERC20
242  * applications.
243  *
244  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
245  * This allows applications to reconstruct the allowance for all accounts just
246  * by listening to said events. Other implementations of the EIP may not emit
247  * these events, as it isn't required by the specification.
248  *
249  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
250  * functions have been added to mitigate the well-known issues around setting
251  * allowances. See {IERC20-approve}.
252  */
253 contract ERC20 is Context, IERC20, IERC20Metadata {
254     mapping(address => uint256) private _balances;
255 
256     mapping(address => mapping(address => uint256)) private _allowances;
257 
258     uint256 private _totalSupply;
259 
260     string private _name;
261     string private _symbol;
262 
263     /**
264      * @dev Sets the values for {name} and {symbol}.
265      *
266      * The default value of {decimals} is 18. To select a different value for
267      * {decimals} you should overload it.
268      *
269      * All two of these values are immutable: they can only be set once during
270      * construction.
271      */
272     constructor(string memory name_, string memory symbol_) {
273         _name = name_;
274         _symbol = symbol_;
275     }
276 
277     /**
278      * @dev Returns the name of the token.
279      */
280     function name() public view virtual override returns (string memory) {
281         return _name;
282     }
283 
284     /**
285      * @dev Returns the symbol of the token, usually a shorter version of the
286      * name.
287      */
288     function symbol() public view virtual override returns (string memory) {
289         return _symbol;
290     }
291 
292     /**
293      * @dev Returns the number of decimals used to get its user representation.
294      * For example, if `decimals` equals `2`, a balance of `505` tokens should
295      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
296      *
297      * Tokens usually opt for a value of 18, imitating the relationship between
298      * Ether and Wei. This is the value {ERC20} uses, unless this function is
299      * overridden;
300      *
301      * NOTE: This information is only used for _display_ purposes: it in
302      * no way affects any of the arithmetic of the contract, including
303      * {IERC20-balanceOf} and {IERC20-transfer}.
304      */
305     function decimals() public view virtual override returns (uint8) {
306         return 18;
307     }
308 
309     /**
310      * @dev See {IERC20-totalSupply}.
311      */
312     function totalSupply() public view virtual override returns (uint256) {
313         return _totalSupply;
314     }
315 
316     /**
317      * @dev See {IERC20-balanceOf}.
318      */
319     function balanceOf(address account) public view virtual override returns (uint256) {
320         return _balances[account];
321     }
322 
323     /**
324      * @dev See {IERC20-transfer}.
325      *
326      * Requirements:
327      *
328      * - `recipient` cannot be the zero address.
329      * - the caller must have a balance of at least `amount`.
330      */
331     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
332         _transfer(_msgSender(), recipient, amount);
333         return true;
334     }
335 
336     /**
337      * @dev See {IERC20-allowance}.
338      */
339     function allowance(address owner, address spender) public view virtual override returns (uint256) {
340         return _allowances[owner][spender];
341     }
342 
343     /**
344      * @dev See {IERC20-approve}.
345      *
346      * Requirements:
347      *
348      * - `spender` cannot be the zero address.
349      */
350     function approve(address spender, uint256 amount) public virtual override returns (bool) {
351         _approve(_msgSender(), spender, amount);
352         return true;
353     }
354 
355     /**
356      * @dev See {IERC20-transferFrom}.
357      *
358      * Emits an {Approval} event indicating the updated allowance. This is not
359      * required by the EIP. See the note at the beginning of {ERC20}.
360      *
361      * Requirements:
362      *
363      * - `sender` and `recipient` cannot be the zero address.
364      * - `sender` must have a balance of at least `amount`.
365      * - the caller must have allowance for ``sender``'s tokens of at least
366      * `amount`.
367      */
368     function transferFrom(
369         address sender,
370         address recipient,
371         uint256 amount
372     ) public virtual override returns (bool) {
373         _transfer(sender, recipient, amount);
374 
375         uint256 currentAllowance = _allowances[sender][_msgSender()];
376         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
377         unchecked {
378             _approve(sender, _msgSender(), currentAllowance - amount);
379         }
380 
381         return true;
382     }
383 
384     /**
385      * @dev Atomically increases the allowance granted to `spender` by the caller.
386      *
387      * This is an alternative to {approve} that can be used as a mitigation for
388      * problems described in {IERC20-approve}.
389      *
390      * Emits an {Approval} event indicating the updated allowance.
391      *
392      * Requirements:
393      *
394      * - `spender` cannot be the zero address.
395      */
396     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
397         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
398         return true;
399     }
400 
401     /**
402      * @dev Atomically decreases the allowance granted to `spender` by the caller.
403      *
404      * This is an alternative to {approve} that can be used as a mitigation for
405      * problems described in {IERC20-approve}.
406      *
407      * Emits an {Approval} event indicating the updated allowance.
408      *
409      * Requirements:
410      *
411      * - `spender` cannot be the zero address.
412      * - `spender` must have allowance for the caller of at least
413      * `subtractedValue`.
414      */
415     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
416         uint256 currentAllowance = _allowances[_msgSender()][spender];
417         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
418         unchecked {
419             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
420         }
421 
422         return true;
423     }
424 
425     /**
426      * @dev Moves `amount` of tokens from `sender` to `recipient`.
427      *
428      * This internal function is equivalent to {transfer}, and can be used to
429      * e.g. implement automatic token fees, slashing mechanisms, etc.
430      *
431      * Emits a {Transfer} event.
432      *
433      * Requirements:
434      *
435      * - `sender` cannot be the zero address.
436      * - `recipient` cannot be the zero address.
437      * - `sender` must have a balance of at least `amount`.
438      */
439     function _transfer(
440         address sender,
441         address recipient,
442         uint256 amount
443     ) internal virtual {
444         require(sender != address(0), "ERC20: transfer from the zero address");
445         require(recipient != address(0), "ERC20: transfer to the zero address");
446 
447         _beforeTokenTransfer(sender, recipient, amount);
448 
449         uint256 senderBalance = _balances[sender];
450         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
451         unchecked {
452             _balances[sender] = senderBalance - amount;
453         }
454         _balances[recipient] += amount;
455 
456         emit Transfer(sender, recipient, amount);
457 
458         _afterTokenTransfer(sender, recipient, amount);
459     }
460 
461     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
462      * the total supply.
463      *
464      * Emits a {Transfer} event with `from` set to the zero address.
465      *
466      * Requirements:
467      *
468      * - `account` cannot be the zero address.
469      */
470     function _mint(address account, uint256 amount) internal virtual {
471         require(account != address(0), "ERC20: mint to the zero address");
472 
473         _beforeTokenTransfer(address(0), account, amount);
474 
475         _totalSupply += amount;
476         _balances[account] += amount;
477         emit Transfer(address(0), account, amount);
478 
479         _afterTokenTransfer(address(0), account, amount);
480     }
481 
482     /**
483      * @dev Destroys `amount` tokens from `account`, reducing the
484      * total supply.
485      *
486      * Emits a {Transfer} event with `to` set to the zero address.
487      *
488      * Requirements:
489      *
490      * - `account` cannot be the zero address.
491      * - `account` must have at least `amount` tokens.
492      */
493     function _burn(address account, uint256 amount) internal virtual {
494         require(account != address(0), "ERC20: burn from the zero address");
495 
496         _beforeTokenTransfer(account, address(0), amount);
497 
498         uint256 accountBalance = _balances[account];
499         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
500         unchecked {
501             _balances[account] = accountBalance - amount;
502         }
503         _totalSupply -= amount;
504 
505         emit Transfer(account, address(0), amount);
506 
507         _afterTokenTransfer(account, address(0), amount);
508     }
509 
510     /**
511      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
512      *
513      * This internal function is equivalent to `approve`, and can be used to
514      * e.g. set automatic allowances for certain subsystems, etc.
515      *
516      * Emits an {Approval} event.
517      *
518      * Requirements:
519      *
520      * - `owner` cannot be the zero address.
521      * - `spender` cannot be the zero address.
522      */
523     function _approve(
524         address owner,
525         address spender,
526         uint256 amount
527     ) internal virtual {
528         require(owner != address(0), "ERC20: approve from the zero address");
529         require(spender != address(0), "ERC20: approve to the zero address");
530 
531         _allowances[owner][spender] = amount;
532         emit Approval(owner, spender, amount);
533     }
534 
535     /**
536      * @dev Hook that is called before any transfer of tokens. This includes
537      * minting and burning.
538      *
539      * Calling conditions:
540      *
541      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
542      * will be transferred to `to`.
543      * - when `from` is zero, `amount` tokens will be minted for `to`.
544      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
545      * - `from` and `to` are never both zero.
546      *
547      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
548      */
549     function _beforeTokenTransfer(
550         address from,
551         address to,
552         uint256 amount
553     ) internal virtual {}
554 
555     /**
556      * @dev Hook that is called after any transfer of tokens. This includes
557      * minting and burning.
558      *
559      * Calling conditions:
560      *
561      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
562      * has been transferred to `to`.
563      * - when `from` is zero, `amount` tokens have been minted for `to`.
564      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
565      * - `from` and `to` are never both zero.
566      *
567      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
568      */
569     function _afterTokenTransfer(
570         address from,
571         address to,
572         uint256 amount
573     ) internal virtual {}
574 }
575 
576 ////// lib/openzeppelin-contracts/contracts/utils/Address.sol
577 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
578 
579 /* pragma solidity ^0.8.0; */
580 
581 /**
582  * @dev Collection of functions related to the address type
583  */
584 library Address {
585     /**
586      * @dev Returns true if `account` is a contract.
587      *
588      * [IMPORTANT]
589      * ====
590      * It is unsafe to assume that an address for which this function returns
591      * false is an externally-owned account (EOA) and not a contract.
592      *
593      * Among others, `isContract` will return false for the following
594      * types of addresses:
595      *
596      *  - an externally-owned account
597      *  - a contract in construction
598      *  - an address where a contract will be created
599      *  - an address where a contract lived, but was destroyed
600      * ====
601      */
602     function isContract(address account) internal view returns (bool) {
603         // This method relies on extcodesize, which returns 0 for contracts in
604         // construction, since the code is only stored at the end of the
605         // constructor execution.
606 
607         uint256 size;
608         assembly {
609             size := extcodesize(account)
610         }
611         return size > 0;
612     }
613 
614     /**
615      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
616      * `recipient`, forwarding all available gas and reverting on errors.
617      *
618      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
619      * of certain opcodes, possibly making contracts go over the 2300 gas limit
620      * imposed by `transfer`, making them unable to receive funds via
621      * `transfer`. {sendValue} removes this limitation.
622      *
623      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
624      *
625      * IMPORTANT: because control is transferred to `recipient`, care must be
626      * taken to not create reentrancy vulnerabilities. Consider using
627      * {ReentrancyGuard} or the
628      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
629      */
630     function sendValue(address payable recipient, uint256 amount) internal {
631         require(address(this).balance >= amount, "Address: insufficient balance");
632 
633         (bool success, ) = recipient.call{value: amount}("");
634         require(success, "Address: unable to send value, recipient may have reverted");
635     }
636 
637     /**
638      * @dev Performs a Solidity function call using a low level `call`. A
639      * plain `call` is an unsafe replacement for a function call: use this
640      * function instead.
641      *
642      * If `target` reverts with a revert reason, it is bubbled up by this
643      * function (like regular Solidity function calls).
644      *
645      * Returns the raw returned data. To convert to the expected return value,
646      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
647      *
648      * Requirements:
649      *
650      * - `target` must be a contract.
651      * - calling `target` with `data` must not revert.
652      *
653      * _Available since v3.1._
654      */
655     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
656         return functionCall(target, data, "Address: low-level call failed");
657     }
658 
659     /**
660      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
661      * `errorMessage` as a fallback revert reason when `target` reverts.
662      *
663      * _Available since v3.1._
664      */
665     function functionCall(
666         address target,
667         bytes memory data,
668         string memory errorMessage
669     ) internal returns (bytes memory) {
670         return functionCallWithValue(target, data, 0, errorMessage);
671     }
672 
673     /**
674      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
675      * but also transferring `value` wei to `target`.
676      *
677      * Requirements:
678      *
679      * - the calling contract must have an ETH balance of at least `value`.
680      * - the called Solidity function must be `payable`.
681      *
682      * _Available since v3.1._
683      */
684     function functionCallWithValue(
685         address target,
686         bytes memory data,
687         uint256 value
688     ) internal returns (bytes memory) {
689         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
690     }
691 
692     /**
693      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
694      * with `errorMessage` as a fallback revert reason when `target` reverts.
695      *
696      * _Available since v3.1._
697      */
698     function functionCallWithValue(
699         address target,
700         bytes memory data,
701         uint256 value,
702         string memory errorMessage
703     ) internal returns (bytes memory) {
704         require(address(this).balance >= value, "Address: insufficient balance for call");
705         require(isContract(target), "Address: call to non-contract");
706 
707         (bool success, bytes memory returndata) = target.call{value: value}(data);
708         return verifyCallResult(success, returndata, errorMessage);
709     }
710 
711     /**
712      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
713      * but performing a static call.
714      *
715      * _Available since v3.3._
716      */
717     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
718         return functionStaticCall(target, data, "Address: low-level static call failed");
719     }
720 
721     /**
722      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
723      * but performing a static call.
724      *
725      * _Available since v3.3._
726      */
727     function functionStaticCall(
728         address target,
729         bytes memory data,
730         string memory errorMessage
731     ) internal view returns (bytes memory) {
732         require(isContract(target), "Address: static call to non-contract");
733 
734         (bool success, bytes memory returndata) = target.staticcall(data);
735         return verifyCallResult(success, returndata, errorMessage);
736     }
737 
738     /**
739      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
740      * but performing a delegate call.
741      *
742      * _Available since v3.4._
743      */
744     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
745         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
746     }
747 
748     /**
749      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
750      * but performing a delegate call.
751      *
752      * _Available since v3.4._
753      */
754     function functionDelegateCall(
755         address target,
756         bytes memory data,
757         string memory errorMessage
758     ) internal returns (bytes memory) {
759         require(isContract(target), "Address: delegate call to non-contract");
760 
761         (bool success, bytes memory returndata) = target.delegatecall(data);
762         return verifyCallResult(success, returndata, errorMessage);
763     }
764 
765     /**
766      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
767      * revert reason using the provided one.
768      *
769      * _Available since v4.3._
770      */
771     function verifyCallResult(
772         bool success,
773         bytes memory returndata,
774         string memory errorMessage
775     ) internal pure returns (bytes memory) {
776         if (success) {
777             return returndata;
778         } else {
779             // Look for revert reason and bubble it up if present
780             if (returndata.length > 0) {
781                 // The easiest way to bubble the revert reason is using memory via assembly
782 
783                 assembly {
784                     let returndata_size := mload(returndata)
785                     revert(add(32, returndata), returndata_size)
786                 }
787             } else {
788                 revert(errorMessage);
789             }
790         }
791     }
792 }
793 
794 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
795 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
796 
797 /* pragma solidity ^0.8.0; */
798 
799 // CAUTION
800 // This version of SafeMath should only be used with Solidity 0.8 or later,
801 // because it relies on the compiler's built in overflow checks.
802 
803 /**
804  * @dev Wrappers over Solidity's arithmetic operations.
805  *
806  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
807  * now has built in overflow checking.
808  */
809 library SafeMath {
810     /**
811      * @dev Returns the addition of two unsigned integers, with an overflow flag.
812      *
813      * _Available since v3.4._
814      */
815     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
816         unchecked {
817             uint256 c = a + b;
818             if (c < a) return (false, 0);
819             return (true, c);
820         }
821     }
822 
823     /**
824      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
825      *
826      * _Available since v3.4._
827      */
828     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
829         unchecked {
830             if (b > a) return (false, 0);
831             return (true, a - b);
832         }
833     }
834 
835     /**
836      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
837      *
838      * _Available since v3.4._
839      */
840     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
841         unchecked {
842             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
843             // benefit is lost if 'b' is also tested.
844             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
845             if (a == 0) return (true, 0);
846             uint256 c = a * b;
847             if (c / a != b) return (false, 0);
848             return (true, c);
849         }
850     }
851 
852     /**
853      * @dev Returns the division of two unsigned integers, with a division by zero flag.
854      *
855      * _Available since v3.4._
856      */
857     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
858         unchecked {
859             if (b == 0) return (false, 0);
860             return (true, a / b);
861         }
862     }
863 
864     /**
865      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
866      *
867      * _Available since v3.4._
868      */
869     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
870         unchecked {
871             if (b == 0) return (false, 0);
872             return (true, a % b);
873         }
874     }
875 
876     /**
877      * @dev Returns the addition of two unsigned integers, reverting on
878      * overflow.
879      *
880      * Counterpart to Solidity's `+` operator.
881      *
882      * Requirements:
883      *
884      * - Addition cannot overflow.
885      */
886     function add(uint256 a, uint256 b) internal pure returns (uint256) {
887         return a + b;
888     }
889 
890     /**
891      * @dev Returns the subtraction of two unsigned integers, reverting on
892      * overflow (when the result is negative).
893      *
894      * Counterpart to Solidity's `-` operator.
895      *
896      * Requirements:
897      *
898      * - Subtraction cannot overflow.
899      */
900     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
901         return a - b;
902     }
903 
904     /**
905      * @dev Returns the multiplication of two unsigned integers, reverting on
906      * overflow.
907      *
908      * Counterpart to Solidity's `*` operator.
909      *
910      * Requirements:
911      *
912      * - Multiplication cannot overflow.
913      */
914     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
915         return a * b;
916     }
917 
918     /**
919      * @dev Returns the integer division of two unsigned integers, reverting on
920      * division by zero. The result is rounded towards zero.
921      *
922      * Counterpart to Solidity's `/` operator.
923      *
924      * Requirements:
925      *
926      * - The divisor cannot be zero.
927      */
928     function div(uint256 a, uint256 b) internal pure returns (uint256) {
929         return a / b;
930     }
931 
932     /**
933      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
934      * reverting when dividing by zero.
935      *
936      * Counterpart to Solidity's `%` operator. This function uses a `revert`
937      * opcode (which leaves remaining gas untouched) while Solidity uses an
938      * invalid opcode to revert (consuming all remaining gas).
939      *
940      * Requirements:
941      *
942      * - The divisor cannot be zero.
943      */
944     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
945         return a % b;
946     }
947 
948     /**
949      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
950      * overflow (when the result is negative).
951      *
952      * CAUTION: This function is deprecated because it requires allocating memory for the error
953      * message unnecessarily. For custom revert reasons use {trySub}.
954      *
955      * Counterpart to Solidity's `-` operator.
956      *
957      * Requirements:
958      *
959      * - Subtraction cannot overflow.
960      */
961     function sub(
962         uint256 a,
963         uint256 b,
964         string memory errorMessage
965     ) internal pure returns (uint256) {
966         unchecked {
967             require(b <= a, errorMessage);
968             return a - b;
969         }
970     }
971 
972     /**
973      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
974      * division by zero. The result is rounded towards zero.
975      *
976      * Counterpart to Solidity's `/` operator. Note: this function uses a
977      * `revert` opcode (which leaves remaining gas untouched) while Solidity
978      * uses an invalid opcode to revert (consuming all remaining gas).
979      *
980      * Requirements:
981      *
982      * - The divisor cannot be zero.
983      */
984     function div(
985         uint256 a,
986         uint256 b,
987         string memory errorMessage
988     ) internal pure returns (uint256) {
989         unchecked {
990             require(b > 0, errorMessage);
991             return a / b;
992         }
993     }
994 
995     /**
996      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
997      * reverting with custom message when dividing by zero.
998      *
999      * CAUTION: This function is deprecated because it requires allocating memory for the error
1000      * message unnecessarily. For custom revert reasons use {tryMod}.
1001      *
1002      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1003      * opcode (which leaves remaining gas untouched) while Solidity uses an
1004      * invalid opcode to revert (consuming all remaining gas).
1005      *
1006      * Requirements:
1007      *
1008      * - The divisor cannot be zero.
1009      */
1010     function mod(
1011         uint256 a,
1012         uint256 b,
1013         string memory errorMessage
1014     ) internal pure returns (uint256) {
1015         unchecked {
1016             require(b > 0, errorMessage);
1017             return a % b;
1018         }
1019     }
1020 }
1021 
1022 ////// src/IUniswapV2Factory.sol
1023 /* pragma solidity 0.8.10; */
1024 /* pragma experimental ABIEncoderV2; */
1025 
1026 interface IUniswapV2Factory {
1027     event PairCreated(
1028         address indexed token0,
1029         address indexed token1,
1030         address pair,
1031         uint256
1032     );
1033 
1034     function feeTo() external view returns (address);
1035 
1036     function feeToSetter() external view returns (address);
1037 
1038     function getPair(address tokenA, address tokenB)
1039         external
1040         view
1041         returns (address pair);
1042 
1043     function allPairs(uint256) external view returns (address pair);
1044 
1045     function allPairsLength() external view returns (uint256);
1046 
1047     function createPair(address tokenA, address tokenB)
1048         external
1049         returns (address pair);
1050 
1051     function setFeeTo(address) external;
1052 
1053     function setFeeToSetter(address) external;
1054 }
1055 
1056 ////// src/IUniswapV2Pair.sol
1057 /* pragma solidity 0.8.10; */
1058 /* pragma experimental ABIEncoderV2; */
1059 
1060 interface IUniswapV2Pair {
1061     event Approval(
1062         address indexed owner,
1063         address indexed spender,
1064         uint256 value
1065     );
1066     event Transfer(address indexed from, address indexed to, uint256 value);
1067 
1068     function name() external pure returns (string memory);
1069 
1070     function symbol() external pure returns (string memory);
1071 
1072     function decimals() external pure returns (uint8);
1073 
1074     function totalSupply() external view returns (uint256);
1075 
1076     function balanceOf(address owner) external view returns (uint256);
1077 
1078     function allowance(address owner, address spender)
1079         external
1080         view
1081         returns (uint256);
1082 
1083     function approve(address spender, uint256 value) external returns (bool);
1084 
1085     function transfer(address to, uint256 value) external returns (bool);
1086 
1087     function transferFrom(
1088         address from,
1089         address to,
1090         uint256 value
1091     ) external returns (bool);
1092 
1093     function DOMAIN_SEPARATOR() external view returns (bytes32);
1094 
1095     function PERMIT_TYPEHASH() external pure returns (bytes32);
1096 
1097     function nonces(address owner) external view returns (uint256);
1098 
1099     function permit(
1100         address owner,
1101         address spender,
1102         uint256 value,
1103         uint256 deadline,
1104         uint8 v,
1105         bytes32 r,
1106         bytes32 s
1107     ) external;
1108 
1109     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
1110     event Burn(
1111         address indexed sender,
1112         uint256 amount0,
1113         uint256 amount1,
1114         address indexed to
1115     );
1116     event Swap(
1117         address indexed sender,
1118         uint256 amount0In,
1119         uint256 amount1In,
1120         uint256 amount0Out,
1121         uint256 amount1Out,
1122         address indexed to
1123     );
1124     event Sync(uint112 reserve0, uint112 reserve1);
1125 
1126     function MINIMUM_LIQUIDITY() external pure returns (uint256);
1127 
1128     function factory() external view returns (address);
1129 
1130     function token0() external view returns (address);
1131 
1132     function token1() external view returns (address);
1133 
1134     function getReserves()
1135         external
1136         view
1137         returns (
1138             uint112 reserve0,
1139             uint112 reserve1,
1140             uint32 blockTimestampLast
1141         );
1142 
1143     function price0CumulativeLast() external view returns (uint256);
1144 
1145     function price1CumulativeLast() external view returns (uint256);
1146 
1147     function kLast() external view returns (uint256);
1148 
1149     function mint(address to) external returns (uint256 liquidity);
1150 
1151     function burn(address to)
1152         external
1153         returns (uint256 amount0, uint256 amount1);
1154 
1155     function swap(
1156         uint256 amount0Out,
1157         uint256 amount1Out,
1158         address to,
1159         bytes calldata data
1160     ) external;
1161 
1162     function skim(address to) external;
1163 
1164     function sync() external;
1165 
1166     function initialize(address, address) external;
1167 }
1168 
1169 ////// src/IUniswapV2Router02.sol
1170 /* pragma solidity 0.8.10; */
1171 /* pragma experimental ABIEncoderV2; */
1172 
1173 interface IUniswapV2Router02 {
1174     function factory() external pure returns (address);
1175 
1176     function WETH() external pure returns (address);
1177 
1178     function addLiquidity(
1179         address tokenA,
1180         address tokenB,
1181         uint256 amountADesired,
1182         uint256 amountBDesired,
1183         uint256 amountAMin,
1184         uint256 amountBMin,
1185         address to,
1186         uint256 deadline
1187     )
1188         external
1189         returns (
1190             uint256 amountA,
1191             uint256 amountB,
1192             uint256 liquidity
1193         );
1194 
1195     function addLiquidityETH(
1196         address token,
1197         uint256 amountTokenDesired,
1198         uint256 amountTokenMin,
1199         uint256 amountETHMin,
1200         address to,
1201         uint256 deadline
1202     )
1203         external
1204         payable
1205         returns (
1206             uint256 amountToken,
1207             uint256 amountETH,
1208             uint256 liquidity
1209         );
1210 
1211     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1212         uint256 amountIn,
1213         uint256 amountOutMin,
1214         address[] calldata path,
1215         address to,
1216         uint256 deadline
1217     ) external;
1218 
1219     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1220         uint256 amountOutMin,
1221         address[] calldata path,
1222         address to,
1223         uint256 deadline
1224     ) external payable;
1225 
1226     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1227         uint256 amountIn,
1228         uint256 amountOutMin,
1229         address[] calldata path,
1230         address to,
1231         uint256 deadline
1232     ) external;
1233 }
1234 
1235 ////// src/BunnyInu.sol
1236 
1237 /* pragma solidity ^0.8.10; */
1238 
1239 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1240 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1241 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1242 /* import {Address} from "lib/openzeppelin-contracts/contracts/utils/Address.sol"; */
1243 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1244 
1245 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1246 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1247 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1248 
1249 contract BunnyInu is Ownable, IERC20 {
1250     using SafeMath for uint256;
1251 
1252     mapping(address => uint256) private _balances;
1253     mapping(address => mapping(address => uint256)) private _allowances;
1254 
1255     string public constant name_ = "BunnyInu";
1256     string public constant symbol_ = "BUNNY";
1257     uint8 public constant decimals_ = 18;
1258     uint256 public totalSupply_ = 0;
1259     address public owner_;
1260 
1261     address public constant UNISWAP_ROUTER = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1262     address public constant DEAD = 0x000000000000000000000000000000000000dEaD;
1263     address public constant ZERO = 0x0000000000000000000000000000000000000000;
1264     IUniswapV2Router02 public uniswapV2Router;
1265     address public uniswapV2Pair;
1266     bool public mintingDisabled = false;
1267     bool public antibot = true;
1268     bool public sellCooldown = false;
1269     uint public sellCooldownSeconds;
1270     mapping(address => bool) public blacklist;
1271     mapping(address => uint256) private _txCounter;
1272     mapping(address => bool) public automatedMarketMakerPairs;
1273     mapping(address => bool) private _isExcludedFromFees;
1274     mapping(address => uint256) private _lastBuyTimestamp;
1275     address payable public developerWallet;
1276     address payable public marketingWallet;
1277     address payable public liquidityWallet;
1278     uint256 public buyTaxDevelopment;
1279     uint256 public buyTaxMarketing;
1280     uint256 public buyTaxLiquidity;
1281     uint256 public sellTaxDevelopment;
1282     uint256 public sellTaxMarketing;
1283     uint256 public sellTaxLiquidity;
1284     uint256 public maxTransactions;
1285     uint256 public maxWallet;
1286     uint256 public swapTokensAtAmount = 100000 * (10**18);
1287     uint256 public lastSwapTime;
1288     bool private swapping;
1289 
1290     constructor (
1291         address payable _developerWallet,
1292         address payable _marketingWallet,
1293         address payable _liquidityWallet,
1294         uint256 _buyTaxDevelopment,
1295         uint256 _buyTaxMarketing,
1296         uint256 _buyTaxLiquidity,
1297         uint256 _sellTaxDevelopment,
1298         uint256 _sellTaxMarketing,
1299         uint256 _sellTaxLiquidity,
1300         uint256 _maxTransactions,
1301         uint256 _maxWallet,
1302         uint256 _sellCooldownSeconds
1303     ) {
1304         developerWallet = _developerWallet;
1305         marketingWallet = _marketingWallet;
1306         liquidityWallet = _liquidityWallet;
1307         buyTaxDevelopment = _buyTaxDevelopment;
1308         buyTaxMarketing = _buyTaxMarketing;
1309         buyTaxLiquidity = _buyTaxLiquidity;
1310         sellTaxDevelopment = _sellTaxDevelopment;
1311         sellTaxMarketing = _sellTaxMarketing;
1312         sellTaxLiquidity = _sellTaxLiquidity;
1313         maxTransactions = _maxTransactions;
1314         maxWallet = _maxWallet;
1315         sellCooldownSeconds = _sellCooldownSeconds;
1316 
1317         owner_ = msg.sender;
1318 
1319         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(UNISWAP_ROUTER);
1320 
1321         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory()).createPair(address(this), _uniswapV2Router.WETH());
1322 
1323         uniswapV2Router = _uniswapV2Router;
1324         uniswapV2Pair = _uniswapV2Pair;
1325 
1326         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1327 
1328         _mint(owner_, 1000000000 * 10**18);
1329         mintingDisabled = true;
1330     }
1331 
1332     function name() public view virtual returns (string memory) {
1333         return name_;
1334     }
1335 
1336     function symbol() public view virtual returns (string memory) {
1337         return symbol_;
1338     }
1339 
1340     function decimals() public view virtual returns (uint8) {
1341         return decimals_;
1342     }
1343 
1344     function totalSupply() public view virtual override returns (uint256) {
1345         return totalSupply_;
1346     }
1347 
1348     function owner() public view virtual override returns (address) {
1349         return owner_;
1350     }
1351 
1352     function balanceOf(
1353         address account
1354     ) public view virtual override returns (uint256) {
1355         return _balances[account];
1356     }
1357 
1358     function transfer(
1359         address recipient,
1360         uint256 amount
1361     ) public virtual override returns (bool) {
1362         _transfer(_msgSender(), recipient, amount);
1363         return true;
1364     }
1365 
1366     function allowance(
1367         address _owner,
1368         address spender
1369     ) public view virtual override returns (uint256) {
1370         return _allowances[_owner][spender];
1371     }
1372 
1373     function approve(
1374         address spender,
1375         uint256 amount
1376     ) public virtual override returns (bool) {
1377         _approve(_msgSender(), spender, amount);
1378         return true;
1379     }
1380 
1381     function transferFrom(
1382         address sender,
1383         address recipient,
1384         uint256 amount
1385     ) public virtual override returns (bool) {
1386         _transfer(sender, recipient, amount);
1387 
1388         uint256 currentAllowance = _allowances[sender][_msgSender()];
1389         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
1390         _approve(sender, _msgSender(), currentAllowance - amount);
1391 
1392         return true;
1393     }
1394 
1395     function increaseAllowance(
1396         address spender,
1397         uint256 addedValue
1398     ) public virtual returns (bool) {
1399         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
1400         return true;
1401     }
1402 
1403     function decreaseAllowance(
1404         address spender,
1405         uint256 subtractedValue
1406     ) public virtual returns (bool) {
1407         uint256 currentAllowance = _allowances[_msgSender()][spender];
1408         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
1409         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1410 
1411         return true;
1412     }
1413 
1414     function _transfer(
1415         address sender,
1416         address recipient,
1417         uint256 amount
1418     ) internal virtual {
1419         require(sender != address(0), "ERC20: transfer from the zero address");
1420         require(recipient != address(0), "ERC20: transfer to the zero address");
1421         require(blacklist[sender] != true, "This sender is blacklisted");
1422         require(blacklist[recipient] != true, "This recipient is blacklisted");
1423         require(_txCounter[sender] < maxTransactions, "This address is at the max TX limit");
1424         require(recipient == owner() || recipient == uniswapV2Pair || recipient == address(uniswapV2Router) || recipient == developerWallet || recipient == marketingWallet || recipient == liquidityWallet || (_balances[recipient] + amount < totalSupply_ * maxWallet), "This address is at the max wallet limit"); // todo do we really need to check the router
1425         require(antibot == false || sender == owner_ || recipient == owner_, "Antibot is currently enabled");
1426 
1427         uint256 _maxTxAmount = (totalSupply_ * maxTransactions) / 10000;
1428         uint256 _maxWallet = (totalSupply_ * maxWallet) / 10000;
1429         require(
1430             sender == owner() || sender == uniswapV2Pair || amount <= _maxTxAmount,
1431             "TX Limit Exceeded"
1432         );
1433 
1434         if (sender != owner() && recipient != owner() && recipient != address(this) && recipient != address(0) && recipient != uniswapV2Pair) {
1435             uint256 currentBalance = balanceOf(recipient);
1436             require(currentBalance + amount <= _maxWallet, "ERC20: transfer puts recipient above max wallet");
1437         }
1438 
1439         uint256 senderBalance = _balances[sender];
1440         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1441 
1442         // todo ensure the following two blocks work as intended
1443         if (sender == uniswapV2Pair && sellCooldown) {
1444             require(_lastBuyTimestamp[recipient] > block.timestamp - sellCooldownSeconds || recipient == owner_, "Sell cooldown enabled");
1445         }
1446 
1447         if (sender != uniswapV2Pair) {
1448             _lastBuyTimestamp[recipient] = block.timestamp;
1449         }
1450 
1451         _beforeTokenTransfer(sender, recipient, amount);
1452 
1453         uint256 contractTokenBalance = balanceOf(address(this));
1454         uint256 contractNativeBalance = address(this).balance;
1455 
1456         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1457 
1458         if (canSwap && !swapping && !automatedMarketMakerPairs[sender] && sender != address(uniswapV2Router) && sender != owner_ && recipient != owner_) {
1459             swapping = true;
1460 
1461             bool isBuy = true;
1462 
1463             if (sender == uniswapV2Pair || sender == address(uniswapV2Router) || sender == address(this)) {
1464                 isBuy = false; // todo - test to ensure this works
1465             }
1466 
1467             _executeSwap(contractTokenBalance, contractNativeBalance, isBuy);
1468 
1469             lastSwapTime = block.timestamp;
1470             swapping = false;
1471         }
1472 
1473         bool takeFee = true;
1474 
1475         if (sender == uniswapV2Pair || recipient == uniswapV2Pair) {
1476             takeFee = true;
1477         }
1478 
1479         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
1480             takeFee = false;
1481         }
1482 
1483         if (swapping) {
1484             takeFee = false;
1485         }
1486 
1487         if (sender == owner()) {
1488             takeFee = false;
1489         }
1490 
1491         uint totalFee = buyTaxDevelopment + buyTaxMarketing + buyTaxLiquidity;
1492 
1493         if (sender == uniswapV2Pair) {
1494             totalFee = sellTaxDevelopment + sellTaxMarketing + sellTaxLiquidity;
1495         }
1496 
1497         _txCounter[sender]++;
1498 
1499         if (takeFee) {
1500             uint256 fees = (amount * totalFee) / 10000;
1501             amount -= fees;
1502             _executeTransfer(sender, address(this), fees);
1503         }
1504 
1505         _executeTransfer(sender, recipient, amount);
1506     }
1507 
1508     function _executeTransfer(
1509         address sender,
1510         address recipient,
1511         uint256 amount
1512     ) private {
1513         require(sender != address(0), "ERC20: transfer from the zero address");
1514         require(recipient != address(0), "ERC20: transfer to the zero address");
1515         uint256 senderBalance = _balances[sender];
1516         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
1517         _balances[sender] = senderBalance - amount;
1518         _balances[recipient] += amount;
1519         emit Transfer(sender, recipient, amount);
1520     }
1521 
1522     function _mint(
1523         address account,
1524         uint256 amount
1525     ) internal virtual {
1526         require(!mintingDisabled, "No more tokens can be minted.");
1527         require(account != address(0), "ERC20: mint to the zero address");
1528 
1529         _beforeTokenTransfer(address(0), account, amount);
1530 
1531         totalSupply_ += amount;
1532         _balances[account] += amount;
1533         emit Transfer(address(0), account, amount);
1534     }
1535 
1536     function _burn(
1537         address account,
1538         uint256 amount
1539     ) internal virtual {
1540         require(account != address(0), "ERC20: burn from the zero address");
1541 
1542         _beforeTokenTransfer(account, address(0), amount);
1543 
1544         uint256 accountBalance = _balances[account];
1545         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
1546         _balances[account] = accountBalance - amount;
1547         totalSupply_ -= amount;
1548 
1549         emit Transfer(account, address(0), amount);
1550     }
1551 
1552     function _approve(
1553         address holder,
1554         address spender,
1555         uint256 amount
1556     ) internal virtual {
1557         require(holder != address(0), "ERC20: approve from the zero address");
1558         require(spender != address(0), "ERC20: approve to the zero address");
1559 
1560         _allowances[holder][spender] = amount;
1561         emit Approval(holder, spender, amount);
1562     }
1563 
1564     function swapTokensForNative(uint256 tokens) private {
1565         address[] memory path = new address[](2);
1566         path[0] = address(this);
1567         path[1] = uniswapV2Router.WETH();
1568         _approve(address(this), address(uniswapV2Router), tokens);
1569         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1570             tokens,
1571             0, // accept any amount of native
1572             path,
1573             address(this),
1574             block.timestamp
1575         );
1576     }
1577 
1578     function addLiquidity(uint256 tokens, uint256 native) private {
1579         _approve(address(this), address(uniswapV2Router), tokens);
1580         uniswapV2Router.addLiquidityETH{value: native}(
1581             address(this),
1582             tokens,
1583             0,
1584             0,
1585             liquidityWallet,
1586             block.timestamp
1587         );
1588     }
1589 
1590     function _executeSwap(
1591         uint256 tokens,
1592         uint256 native,
1593         bool isBuy
1594     ) private {
1595         if (tokens <= 0) {
1596             return;
1597         }
1598 
1599         uint totalFee = buyTaxDevelopment + buyTaxMarketing + buyTaxLiquidity;
1600 
1601         if (!isBuy) {
1602             totalFee = sellTaxDevelopment + sellTaxMarketing + sellTaxLiquidity;
1603         }
1604 
1605         uint swapTokensDevelopment = (tokens * buyTaxDevelopment) / totalFee;
1606         uint swapTokensMarketing = (tokens * buyTaxMarketing) / totalFee;
1607         uint tokensForLiquidity = (tokens * buyTaxLiquidity) / totalFee;
1608 
1609         if (!isBuy) {
1610             swapTokensDevelopment = (tokens * sellTaxDevelopment) / totalFee;
1611             swapTokensMarketing = (tokens * sellTaxMarketing) / totalFee;
1612             tokensForLiquidity = (tokens * sellTaxLiquidity) / totalFee;
1613         }
1614 
1615         uint256 swapTokensLiquidity = tokensForLiquidity / 2;
1616         uint256 addTokensLiquidity = tokensForLiquidity - swapTokensLiquidity;
1617 
1618         uint256 swapTokensTotal = swapTokensDevelopment + swapTokensMarketing + swapTokensLiquidity;
1619 
1620         uint256 initNativeBal = address(this).balance;
1621         swapTokensForNative(swapTokensTotal);
1622         uint256 nativeSwapped = (address(this).balance - initNativeBal) + native;
1623 
1624         uint256 nativeDevelopment = (nativeSwapped * swapTokensDevelopment) / swapTokensTotal;
1625         uint256 nativeMarketing = (nativeSwapped * swapTokensMarketing) / swapTokensTotal;
1626         uint256 nativeLiquidity =  nativeSwapped - nativeDevelopment - nativeMarketing;
1627 
1628         if (nativeDevelopment > 0) {
1629             payable(developerWallet).transfer(nativeDevelopment);
1630         }
1631 
1632         if (nativeMarketing > 0) {
1633             payable(marketingWallet).transfer(nativeMarketing);
1634         }
1635 
1636         if (nativeLiquidity > 0) { // ? is this conditional necessary
1637             addLiquidity(addTokensLiquidity, nativeLiquidity);
1638         }
1639     }
1640 
1641     // Function to receive Ether. msg.data must be empty
1642     receive() external payable {}
1643 
1644     // Fallback function is called when msg.data is not empty
1645     fallback() external payable {}
1646 
1647     function _beforeTokenTransfer(
1648         address from,
1649         address to,
1650         uint256 amount
1651     ) internal virtual {}
1652 
1653     function setAutomatedMarketMakerPair(
1654         address pair,
1655         bool value
1656     ) public onlyOwner {
1657         require(pair != uniswapV2Pair, "AMM pair can not be removed");
1658         _setAutomatedMarketMakerPair(pair, value);
1659     }
1660 
1661     function _setAutomatedMarketMakerPair(
1662         address pair,
1663         bool value
1664     ) private {
1665         require(automatedMarketMakerPairs[pair] != value, "AMM pair must be set to a new value");
1666         automatedMarketMakerPairs[pair] = value;
1667     }
1668 
1669     /* Deployer Functions */
1670 
1671     function toggleAntibot(
1672         bool _antibot
1673     ) external onlyOwner {
1674         antibot = !_antibot;
1675     }
1676 
1677     function toggleSellCooldown(
1678         bool _sellCooldown
1679     ) external onlyOwner {
1680         sellCooldown = !_sellCooldown;
1681     }
1682 
1683     function adjustSellCooldownSeconds(
1684         uint256 _sellCooldownSeconds
1685     ) external onlyOwner {
1686         sellCooldownSeconds = _sellCooldownSeconds;
1687     }
1688 
1689     function blacklistAddress(
1690         address toBlacklist
1691     ) external onlyOwner {
1692         blacklist[toBlacklist] = true;
1693     }
1694 
1695     function whitelistAddress(
1696         address toWhitelist
1697     ) external onlyOwner {
1698         blacklist[toWhitelist] = false;
1699     }
1700 
1701     function adjustDeveloperWallet(
1702         address payable _developerWallet
1703     ) external onlyOwner {
1704         developerWallet = _developerWallet;
1705     }
1706 
1707     function adjustMarketingWallet(
1708         address payable _marketingWallet
1709     ) external onlyOwner {
1710         marketingWallet = _marketingWallet;
1711     }
1712 
1713     function adjustLiquidityWallet(
1714         address payable _liquidityWallet
1715     ) external onlyOwner {
1716         liquidityWallet = _liquidityWallet;
1717     }
1718 
1719     function adjustBuyTaxDevelopment(
1720         uint256 _buyTaxDevelopment
1721     ) external onlyOwner {
1722         require(_buyTaxDevelopment <= 3333);
1723         buyTaxDevelopment = _buyTaxDevelopment;
1724     }
1725 
1726     function adjustBuyTaxMarketing(
1727         uint256 _buyTaxMarketing
1728     ) external onlyOwner {
1729         require(_buyTaxMarketing <= 3333);
1730         buyTaxMarketing = _buyTaxMarketing;
1731     }
1732 
1733     function adjustBuyTaxLiquidity(
1734         uint256 _buyTaxLiquidity
1735     ) external onlyOwner {
1736         require(_buyTaxLiquidity <= 3333);
1737         buyTaxLiquidity = _buyTaxLiquidity;
1738     }
1739 
1740     function adjustSellTaxDevelopment(
1741         uint256 _sellTaxDevelopment
1742     ) external onlyOwner {
1743         require(_sellTaxDevelopment <= 3333);
1744         sellTaxDevelopment = _sellTaxDevelopment;
1745     }
1746 
1747     function adjustSellTaxMarketing(
1748         uint256 _sellTaxMarketing
1749     ) external onlyOwner {
1750         require(_sellTaxMarketing <= 3333);
1751         sellTaxMarketing = _sellTaxMarketing;
1752     }
1753 
1754     function adjustSellTaxLiquidity(
1755         uint256 _sellTaxLiquidity
1756     ) external onlyOwner {
1757         require(_sellTaxLiquidity <= 3333);
1758         sellTaxLiquidity = _sellTaxLiquidity;
1759     }
1760     function adjustMaxTransactions(
1761         uint256 _maxTransactions
1762     ) external onlyOwner {
1763         maxTransactions = _maxTransactions;
1764     }
1765 
1766     function adjustMaxWallet(
1767         uint256 _maxWallet
1768     ) external onlyOwner {
1769         require(_maxWallet <= 10000);
1770         maxWallet = _maxWallet;
1771     }
1772 
1773     function adjustUniswapV2Router(
1774         address _newAddress
1775     ) external onlyOwner {
1776         require(_newAddress != address(uniswapV2Router), "The address must point to a new and different router");
1777         uniswapV2Router = IUniswapV2Router02(_newAddress);
1778         address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(address(this), uniswapV2Router.WETH());
1779         uniswapV2Pair = _uniswapV2Pair;
1780     }
1781 
1782     function transferOwnership(
1783         address _newOwner
1784     ) public override onlyOwner {
1785         require(_newOwner != address(0));
1786         emit OwnershipTransferred(owner_, _newOwner);
1787         owner_ = _newOwner;
1788     }
1789 
1790     function renounceOwnership() public override onlyOwner {
1791         emit OwnershipTransferred(owner_, address(0));
1792         owner_ = address(0);
1793     }
1794 
1795     function getAntibot() public view returns(bool) {
1796         return antibot;
1797     }
1798 
1799     function getSellCooldown() public view returns(bool) {
1800         return sellCooldown;
1801     }
1802 
1803     function getSellCooldownSeconds() public view returns(uint) {
1804         return sellCooldownSeconds;
1805     }
1806 
1807     function isBlacklist(
1808         address _query
1809     ) public view returns(bool) {
1810         return blacklist[_query];
1811     }
1812 
1813     function getDeveloperWallet() public view returns(address) {
1814         return developerWallet;
1815     }
1816 
1817     function getMarketingWallet() public view returns(address) {
1818         return marketingWallet;
1819     }
1820 
1821     function getLiquidityWallet() public view returns(address) {
1822         return liquidityWallet;
1823     }
1824 
1825     function getBuyTaxDevelopment() public view returns(uint) {
1826         return buyTaxDevelopment;
1827     }
1828 
1829     function getBuyTaxMarketing() public view returns(uint) {
1830         return buyTaxMarketing;
1831     }
1832 
1833     function getBuyTaxLiquidity() public view returns(uint) {
1834         return buyTaxLiquidity;
1835     }
1836 
1837     function getSellTaxDevelopment() public view returns(uint) {
1838         return sellTaxDevelopment;
1839     }
1840 
1841     function getSellTaxMarketing() public view returns(uint) {
1842         return sellTaxMarketing;
1843     }
1844 
1845     function getSellTaxLiquidity() public view returns(uint) {
1846         return sellTaxLiquidity;
1847     }
1848 
1849     function getMaxTransactions() public view returns(uint) {
1850         return maxTransactions;
1851     }
1852 
1853     function getMaxWallet() public view returns(uint) {
1854         return maxWallet;
1855     }
1856 
1857     function getUniswapV2Router() public view returns(IUniswapV2Router02) {
1858         return uniswapV2Router;
1859     }
1860 
1861     function getUniswapV2Pair() public view returns(address) {
1862         return uniswapV2Pair;
1863     }
1864 
1865     function getOwner() public view returns(address) {
1866         return owner_;
1867     }
1868 
1869     function isRenounced() public view returns(bool) {
1870         if  (owner_ == address(0)) {
1871             return true;
1872         } else {
1873             return false;
1874         }
1875     }
1876 
1877 }