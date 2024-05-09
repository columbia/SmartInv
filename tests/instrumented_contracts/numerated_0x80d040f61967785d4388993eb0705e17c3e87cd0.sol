1 pragma solidity =0.8.7 >=0.8.0 <0.9.0;
2 pragma experimental ABIEncoderV2;
3 
4 ////// lib/openzeppelin-contracts/contracts/utils/Context.sol
5 // OpenZeppelin Contracts v4.4.0 (utils/Context.sol)
6 
7 /* pragma solidity ^0.8.0; */
8 
9 /**
10  * @dev Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner, since when dealing with meta-transactions the account sending and
14  * paying for execution may not be the actual sender (as far as an application
15  * is concerned).
16  *
17  * This contract is only required for intermediate, library-like contracts.
18  */
19 abstract contract Context {
20     function _msgSender() internal view virtual returns (address) {
21         return msg.sender;
22     }
23 
24     function _msgData() internal view virtual returns (bytes calldata) {
25         return msg.data;
26     }
27 }
28 
29 ////// lib/openzeppelin-contracts/contracts/access/Ownable.sol
30 // OpenZeppelin Contracts v4.4.0 (access/Ownable.sol)
31 
32 /* pragma solidity ^0.8.0; */
33 
34 /* import "../utils/Context.sol"; */
35 
36 /**
37  * @dev Contract module which provides a basic access control mechanism, where
38  * there is an account (an owner) that can be granted exclusive access to
39  * specific functions.
40  *
41  * By default, the owner account will be the one that deploys the contract. This
42  * can later be changed with {transferOwnership}.
43  *
44  * This module is used through inheritance. It will make available the modifier
45  * `onlyOwner`, which can be applied to your functions to restrict their use to
46  * the owner.
47  */
48 abstract contract Ownable is Context {
49     address private _owner;
50 
51     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
52 
53     /**
54      * @dev Initializes the contract setting the deployer as the initial owner.
55      */
56     constructor() {
57         _transferOwnership(_msgSender());
58     }
59 
60     /**
61      * @dev Returns the address of the current owner.
62      */
63     function owner() public view virtual returns (address) {
64         return _owner;
65     }
66 
67     /**
68      * @dev Throws if called by any account other than the owner.
69      */
70     modifier onlyOwner() {
71         require(owner() == _msgSender(), "Ownable: caller is not the owner");
72         _;
73     }
74 
75     /**
76      * @dev Leaves the contract without owner. It will not be possible to call
77      * `onlyOwner` functions anymore. Can only be called by the current owner.
78      *
79      * NOTE: Renouncing ownership will leave the contract without an owner,
80      * thereby removing any functionality that is only available to the owner.
81      */
82     function renounceOwnership() public virtual onlyOwner {
83         _transferOwnership(address(0));
84     }
85 
86     /**
87      * @dev Transfers ownership of the contract to a new account (`newOwner`).
88      * Can only be called by the current owner.
89      */
90     function transferOwnership(address newOwner) public virtual onlyOwner {
91         require(newOwner != address(0), "Ownable: new owner is the zero address");
92         _transferOwnership(newOwner);
93     }
94 
95     /**
96      * @dev Transfers ownership of the contract to a new account (`newOwner`).
97      * Internal function without access restriction.
98      */
99     function _transferOwnership(address newOwner) internal virtual {
100         address oldOwner = _owner;
101         _owner = newOwner;
102         emit OwnershipTransferred(oldOwner, newOwner);
103     }
104 }
105 
106 ////// lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol
107 // OpenZeppelin Contracts v4.4.0 (token/ERC20/IERC20.sol)
108 
109 /* pragma solidity ^0.8.0; */
110 
111 /**
112  * @dev Interface of the ERC20 standard as defined in the EIP.
113  */
114 interface IERC20 {
115     /**
116      * @dev Returns the amount of tokens in existence.
117      */
118     function totalSupply() external view returns (uint256);
119 
120     /**
121      * @dev Returns the amount of tokens owned by `account`.
122      */
123     function balanceOf(address account) external view returns (uint256);
124 
125     /**
126      * @dev Moves `amount` tokens from the caller's account to `recipient`.
127      *
128      * Returns a boolean value indicating whether the operation succeeded.
129      *
130      * Emits a {Transfer} event.
131      */
132     function transfer(address recipient, uint256 amount) external returns (bool);
133 
134     /**
135      * @dev Returns the remaining number of tokens that `spender` will be
136      * allowed to spend on behalf of `owner` through {transferFrom}. This is
137      * zero by default.
138      *
139      * This value changes when {approve} or {transferFrom} are called.
140      */
141     function allowance(address owner, address spender) external view returns (uint256);
142 
143     /**
144      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
145      *
146      * Returns a boolean value indicating whether the operation succeeded.
147      *
148      * IMPORTANT: Beware that changing an allowance with this method brings the risk
149      * that someone may use both the old and the new allowance by unfortunate
150      * transaction ordering. One possible solution to mitigate this race
151      * condition is to first reduce the spender's allowance to 0 and set the
152      * desired value afterwards:
153      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
154      *
155      * Emits an {Approval} event.
156      */
157     function approve(address spender, uint256 amount) external returns (bool);
158 
159     /**
160      * @dev Moves `amount` tokens from `sender` to `recipient` using the
161      * allowance mechanism. `amount` is then deducted from the caller's
162      * allowance.
163      *
164      * Returns a boolean value indicating whether the operation succeeded.
165      *
166      * Emits a {Transfer} event.
167      */
168     function transferFrom(
169         address sender,
170         address recipient,
171         uint256 amount
172     ) external returns (bool);
173 
174     /**
175      * @dev Emitted when `value` tokens are moved from one account (`from`) to
176      * another (`to`).
177      *
178      * Note that `value` may be zero.
179      */
180     event Transfer(address indexed from, address indexed to, uint256 value);
181 
182     /**
183      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
184      * a call to {approve}. `value` is the new allowance.
185      */
186     event Approval(address indexed owner, address indexed spender, uint256 value);
187 }
188 
189 ////// lib/openzeppelin-contracts/contracts/token/ERC20/extensions/IERC20Metadata.sol
190 // OpenZeppelin Contracts v4.4.0 (token/ERC20/extensions/IERC20Metadata.sol)
191 
192 /* pragma solidity ^0.8.0; */
193 
194 /* import "../IERC20.sol"; */
195 
196 /**
197  * @dev Interface for the optional metadata functions from the ERC20 standard.
198  *
199  * _Available since v4.1._
200  */
201 interface IERC20Metadata is IERC20 {
202     /**
203      * @dev Returns the name of the token.
204      */
205     function name() external view returns (string memory);
206 
207     /**
208      * @dev Returns the symbol of the token.
209      */
210     function symbol() external view returns (string memory);
211 
212     /**
213      * @dev Returns the decimals places of the token.
214      */
215     function decimals() external view returns (uint8);
216 }
217 
218 ////// lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol
219 // OpenZeppelin Contracts v4.4.0 (token/ERC20/ERC20.sol)
220 
221 /* pragma solidity ^0.8.0; */
222 
223 /* import "./IERC20.sol"; */
224 /* import "./extensions/IERC20Metadata.sol"; */
225 /* import "../../utils/Context.sol"; */
226 
227 /**
228  * @dev Implementation of the {IERC20} interface.
229  *
230  * This implementation is agnostic to the way tokens are created. This means
231  * that a supply mechanism has to be added in a derived contract using {_mint}.
232  * For a generic mechanism see {ERC20PresetMinterPauser}.
233  *
234  * TIP: For a detailed writeup see our guide
235  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
236  * to implement supply mechanisms].
237  *
238  * We have followed general OpenZeppelin Contracts guidelines: functions revert
239  * instead returning `false` on failure. This behavior is nonetheless
240  * conventional and does not conflict with the expectations of ERC20
241  * applications.
242  *
243  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
244  * This allows applications to reconstruct the allowance for all accounts just
245  * by listening to said events. Other implementations of the EIP may not emit
246  * these events, as it isn't required by the specification.
247  *
248  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
249  * functions have been added to mitigate the well-known issues around setting
250  * allowances. See {IERC20-approve}.
251  */
252 contract ERC20 is Context, IERC20, IERC20Metadata {
253     mapping(address => uint256) private _balances;
254 
255     mapping(address => mapping(address => uint256)) private _allowances;
256 
257     uint256 private _totalSupply;
258 
259     string private _name;
260     string private _symbol;
261 
262     /**
263      * @dev Sets the values for {name} and {symbol}.
264      *
265      * The default value of {decimals} is 18. To select a different value for
266      * {decimals} you should overload it.
267      *
268      * All two of these values are immutable: they can only be set once during
269      * construction.
270      */
271     constructor(string memory name_, string memory symbol_) {
272         _name = name_;
273         _symbol = symbol_;
274     }
275 
276     /**
277      * @dev Returns the name of the token.
278      */
279     function name() public view virtual override returns (string memory) {
280         return _name;
281     }
282 
283     /**
284      * @dev Returns the symbol of the token, usually a shorter version of the
285      * name.
286      */
287     function symbol() public view virtual override returns (string memory) {
288         return _symbol;
289     }
290 
291     /**
292      * @dev Returns the number of decimals used to get its user representation.
293      * For example, if `decimals` equals `2`, a balance of `505` tokens should
294      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
295      *
296      * Tokens usually opt for a value of 18, imitating the relationship between
297      * Ether and Wei. This is the value {ERC20} uses, unless this function is
298      * overridden;
299      *
300      * NOTE: This information is only used for _display_ purposes: it in
301      * no way affects any of the arithmetic of the contract, including
302      * {IERC20-balanceOf} and {IERC20-transfer}.
303      */
304     function decimals() public view virtual override returns (uint8) {
305         return 18;
306     }
307 
308     /**
309      * @dev See {IERC20-totalSupply}.
310      */
311     function totalSupply() public view virtual override returns (uint256) {
312         return _totalSupply;
313     }
314 
315     /**
316      * @dev See {IERC20-balanceOf}.
317      */
318     function balanceOf(address account) public view virtual override returns (uint256) {
319         return _balances[account];
320     }
321 
322     /**
323      * @dev See {IERC20-transfer}.
324      *
325      * Requirements:
326      *
327      * - `recipient` cannot be the zero address.
328      * - the caller must have a balance of at least `amount`.
329      */
330     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
331         _transfer(_msgSender(), recipient, amount);
332         return true;
333     }
334 
335     /**
336      * @dev See {IERC20-allowance}.
337      */
338     function allowance(address owner, address spender) public view virtual override returns (uint256) {
339         return _allowances[owner][spender];
340     }
341 
342     /**
343      * @dev See {IERC20-approve}.
344      *
345      * Requirements:
346      *
347      * - `spender` cannot be the zero address.
348      */
349     function approve(address spender, uint256 amount) public virtual override returns (bool) {
350         _approve(_msgSender(), spender, amount);
351         return true;
352     }
353 
354     /**
355      * @dev See {IERC20-transferFrom}.
356      *
357      * Emits an {Approval} event indicating the updated allowance. This is not
358      * required by the EIP. See the note at the beginning of {ERC20}.
359      *
360      * Requirements:
361      *
362      * - `sender` and `recipient` cannot be the zero address.
363      * - `sender` must have a balance of at least `amount`.
364      * - the caller must have allowance for ``sender``'s tokens of at least
365      * `amount`.
366      */
367     function transferFrom(
368         address sender,
369         address recipient,
370         uint256 amount
371     ) public virtual override returns (bool) {
372         _transfer(sender, recipient, amount);
373 
374         uint256 currentAllowance = _allowances[sender][_msgSender()];
375         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
376         unchecked {
377             _approve(sender, _msgSender(), currentAllowance - amount);
378         }
379 
380         return true;
381     }
382 
383     /**
384      * @dev Atomically increases the allowance granted to `spender` by the caller.
385      *
386      * This is an alternative to {approve} that can be used as a mitigation for
387      * problems described in {IERC20-approve}.
388      *
389      * Emits an {Approval} event indicating the updated allowance.
390      *
391      * Requirements:
392      *
393      * - `spender` cannot be the zero address.
394      */
395     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
396         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
397         return true;
398     }
399 
400     /**
401      * @dev Atomically decreases the allowance granted to `spender` by the caller.
402      *
403      * This is an alternative to {approve} that can be used as a mitigation for
404      * problems described in {IERC20-approve}.
405      *
406      * Emits an {Approval} event indicating the updated allowance.
407      *
408      * Requirements:
409      *
410      * - `spender` cannot be the zero address.
411      * - `spender` must have allowance for the caller of at least
412      * `subtractedValue`.
413      */
414     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
415         uint256 currentAllowance = _allowances[_msgSender()][spender];
416         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
417         unchecked {
418             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
419         }
420 
421         return true;
422     }
423 
424     /**
425      * @dev Moves `amount` of tokens from `sender` to `recipient`.
426      *
427      * This internal function is equivalent to {transfer}, and can be used to
428      * e.g. implement automatic token fees, slashing mechanisms, etc.
429      *
430      * Emits a {Transfer} event.
431      *
432      * Requirements:
433      *
434      * - `sender` cannot be the zero address.
435      * - `recipient` cannot be the zero address.
436      * - `sender` must have a balance of at least `amount`.
437      */
438     function _transfer(
439         address sender,
440         address recipient,
441         uint256 amount
442     ) internal virtual {
443         require(sender != address(0), "ERC20: transfer from the zero address");
444         require(recipient != address(0), "ERC20: transfer to the zero address");
445 
446         _beforeTokenTransfer(sender, recipient, amount);
447 
448         uint256 senderBalance = _balances[sender];
449         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
450         unchecked {
451             _balances[sender] = senderBalance - amount;
452         }
453         _balances[recipient] += amount;
454 
455         emit Transfer(sender, recipient, amount);
456 
457         _afterTokenTransfer(sender, recipient, amount);
458     }
459 
460     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
461      * the total supply.
462      *
463      * Emits a {Transfer} event with `from` set to the zero address.
464      *
465      * Requirements:
466      *
467      * - `account` cannot be the zero address.
468      */
469     function _mint(address account, uint256 amount) internal virtual {
470         require(account != address(0), "ERC20: mint to the zero address");
471 
472         _beforeTokenTransfer(address(0), account, amount);
473 
474         _totalSupply += amount;
475         _balances[account] += amount;
476         emit Transfer(address(0), account, amount);
477 
478         _afterTokenTransfer(address(0), account, amount);
479     }
480 
481     /**
482      * @dev Destroys `amount` tokens from `account`, reducing the
483      * total supply.
484      *
485      * Emits a {Transfer} event with `to` set to the zero address.
486      *
487      * Requirements:
488      *
489      * - `account` cannot be the zero address.
490      * - `account` must have at least `amount` tokens.
491      */
492     function _burn(address account, uint256 amount) internal virtual {
493         require(account != address(0), "ERC20: burn from the zero address");
494 
495         _beforeTokenTransfer(account, address(0), amount);
496 
497         uint256 accountBalance = _balances[account];
498         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
499         unchecked {
500             _balances[account] = accountBalance - amount;
501         }
502         _totalSupply -= amount;
503 
504         emit Transfer(account, address(0), amount);
505 
506         _afterTokenTransfer(account, address(0), amount);
507     }
508 
509     /**
510      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
511      *
512      * This internal function is equivalent to `approve`, and can be used to
513      * e.g. set automatic allowances for certain subsystems, etc.
514      *
515      * Emits an {Approval} event.
516      *
517      * Requirements:
518      *
519      * - `owner` cannot be the zero address.
520      * - `spender` cannot be the zero address.
521      */
522     function _approve(
523         address owner,
524         address spender,
525         uint256 amount
526     ) internal virtual {
527         require(owner != address(0), "ERC20: approve from the zero address");
528         require(spender != address(0), "ERC20: approve to the zero address");
529 
530         _allowances[owner][spender] = amount;
531         emit Approval(owner, spender, amount);
532     }
533 
534     /**
535      * @dev Hook that is called before any transfer of tokens. This includes
536      * minting and burning.
537      *
538      * Calling conditions:
539      *
540      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
541      * will be transferred to `to`.
542      * - when `from` is zero, `amount` tokens will be minted for `to`.
543      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
544      * - `from` and `to` are never both zero.
545      *
546      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
547      */
548     function _beforeTokenTransfer(
549         address from,
550         address to,
551         uint256 amount
552     ) internal virtual {}
553 
554     /**
555      * @dev Hook that is called after any transfer of tokens. This includes
556      * minting and burning.
557      *
558      * Calling conditions:
559      *
560      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
561      * has been transferred to `to`.
562      * - when `from` is zero, `amount` tokens have been minted for `to`.
563      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
564      * - `from` and `to` are never both zero.
565      *
566      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
567      */
568     function _afterTokenTransfer(
569         address from,
570         address to,
571         uint256 amount
572     ) internal virtual {}
573 }
574 
575 ////// lib/openzeppelin-contracts/contracts/utils/Address.sol
576 // OpenZeppelin Contracts v4.4.0 (utils/Address.sol)
577 
578 /* pragma solidity ^0.8.0; */
579 
580 /**
581  * @dev Collection of functions related to the address type
582  */
583 library Address {
584     /**
585      * @dev Returns true if `account` is a contract.
586      *
587      * [IMPORTANT]
588      * ====
589      * It is unsafe to assume that an address for which this function returns
590      * false is an externally-owned account (EOA) and not a contract.
591      *
592      * Among others, `isContract` will return false for the following
593      * types of addresses:
594      *
595      *  - an externally-owned account
596      *  - a contract in construction
597      *  - an address where a contract will be created
598      *  - an address where a contract lived, but was destroyed
599      * ====
600      */
601     function isContract(address account) internal view returns (bool) {
602         // This method relies on extcodesize, which returns 0 for contracts in
603         // construction, since the code is only stored at the end of the
604         // constructor execution.
605 
606         uint256 size;
607         assembly {
608             size := extcodesize(account)
609         }
610         return size > 0;
611     }
612 
613     /**
614      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
615      * `recipient`, forwarding all available gas and reverting on errors.
616      *
617      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
618      * of certain opcodes, possibly making contracts go over the 2300 gas limit
619      * imposed by `transfer`, making them unable to receive funds via
620      * `transfer`. {sendValue} removes this limitation.
621      *
622      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
623      *
624      * IMPORTANT: because control is transferred to `recipient`, care must be
625      * taken to not create reentrancy vulnerabilities. Consider using
626      * {ReentrancyGuard} or the
627      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
628      */
629     function sendValue(address payable recipient, uint256 amount) internal {
630         require(address(this).balance >= amount, "Address: insufficient balance");
631 
632         (bool success, ) = recipient.call{value: amount}("");
633         require(success, "Address: unable to send value, recipient may have reverted");
634     }
635 
636     /**
637      * @dev Performs a Solidity function call using a low level `call`. A
638      * plain `call` is an unsafe replacement for a function call: use this
639      * function instead.
640      *
641      * If `target` reverts with a revert reason, it is bubbled up by this
642      * function (like regular Solidity function calls).
643      *
644      * Returns the raw returned data. To convert to the expected return value,
645      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
646      *
647      * Requirements:
648      *
649      * - `target` must be a contract.
650      * - calling `target` with `data` must not revert.
651      *
652      * _Available since v3.1._
653      */
654     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
655         return functionCall(target, data, "Address: low-level call failed");
656     }
657 
658     /**
659      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
660      * `errorMessage` as a fallback revert reason when `target` reverts.
661      *
662      * _Available since v3.1._
663      */
664     function functionCall(
665         address target,
666         bytes memory data,
667         string memory errorMessage
668     ) internal returns (bytes memory) {
669         return functionCallWithValue(target, data, 0, errorMessage);
670     }
671 
672     /**
673      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
674      * but also transferring `value` wei to `target`.
675      *
676      * Requirements:
677      *
678      * - the calling contract must have an ETH balance of at least `value`.
679      * - the called Solidity function must be `payable`.
680      *
681      * _Available since v3.1._
682      */
683     function functionCallWithValue(
684         address target,
685         bytes memory data,
686         uint256 value
687     ) internal returns (bytes memory) {
688         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
689     }
690 
691     /**
692      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
693      * with `errorMessage` as a fallback revert reason when `target` reverts.
694      *
695      * _Available since v3.1._
696      */
697     function functionCallWithValue(
698         address target,
699         bytes memory data,
700         uint256 value,
701         string memory errorMessage
702     ) internal returns (bytes memory) {
703         require(address(this).balance >= value, "Address: insufficient balance for call");
704         require(isContract(target), "Address: call to non-contract");
705 
706         (bool success, bytes memory returndata) = target.call{value: value}(data);
707         return verifyCallResult(success, returndata, errorMessage);
708     }
709 
710     /**
711      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
712      * but performing a static call.
713      *
714      * _Available since v3.3._
715      */
716     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
717         return functionStaticCall(target, data, "Address: low-level static call failed");
718     }
719 
720     /**
721      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
722      * but performing a static call.
723      *
724      * _Available since v3.3._
725      */
726     function functionStaticCall(
727         address target,
728         bytes memory data,
729         string memory errorMessage
730     ) internal view returns (bytes memory) {
731         require(isContract(target), "Address: static call to non-contract");
732 
733         (bool success, bytes memory returndata) = target.staticcall(data);
734         return verifyCallResult(success, returndata, errorMessage);
735     }
736 
737     /**
738      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
739      * but performing a delegate call.
740      *
741      * _Available since v3.4._
742      */
743     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
744         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
745     }
746 
747     /**
748      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
749      * but performing a delegate call.
750      *
751      * _Available since v3.4._
752      */
753     function functionDelegateCall(
754         address target,
755         bytes memory data,
756         string memory errorMessage
757     ) internal returns (bytes memory) {
758         require(isContract(target), "Address: delegate call to non-contract");
759 
760         (bool success, bytes memory returndata) = target.delegatecall(data);
761         return verifyCallResult(success, returndata, errorMessage);
762     }
763 
764     /**
765      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
766      * revert reason using the provided one.
767      *
768      * _Available since v4.3._
769      */
770     function verifyCallResult(
771         bool success,
772         bytes memory returndata,
773         string memory errorMessage
774     ) internal pure returns (bytes memory) {
775         if (success) {
776             return returndata;
777         } else {
778             // Look for revert reason and bubble it up if present
779             if (returndata.length > 0) {
780                 // The easiest way to bubble the revert reason is using memory via assembly
781 
782                 assembly {
783                     let returndata_size := mload(returndata)
784                     revert(add(32, returndata), returndata_size)
785                 }
786             } else {
787                 revert(errorMessage);
788             }
789         }
790     }
791 }
792 
793 ////// lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol
794 // OpenZeppelin Contracts v4.4.0 (utils/math/SafeMath.sol)
795 
796 /* pragma solidity ^0.8.0; */
797 
798 // CAUTION
799 // This version of SafeMath should only be used with Solidity 0.8 or later,
800 // because it relies on the compiler's built in overflow checks.
801 
802 /**
803  * @dev Wrappers over Solidity's arithmetic operations.
804  *
805  * NOTE: `SafeMath` is generally not needed starting with Solidity 0.8, since the compiler
806  * now has built in overflow checking.
807  */
808 library SafeMath {
809     /**
810      * @dev Returns the addition of two unsigned integers, with an overflow flag.
811      *
812      * _Available since v3.4._
813      */
814     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
815         unchecked {
816             uint256 c = a + b;
817             if (c < a) return (false, 0);
818             return (true, c);
819         }
820     }
821 
822     /**
823      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
824      *
825      * _Available since v3.4._
826      */
827     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
828         unchecked {
829             if (b > a) return (false, 0);
830             return (true, a - b);
831         }
832     }
833 
834     /**
835      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
836      *
837      * _Available since v3.4._
838      */
839     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
840         unchecked {
841             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
842             // benefit is lost if 'b' is also tested.
843             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
844             if (a == 0) return (true, 0);
845             uint256 c = a * b;
846             if (c / a != b) return (false, 0);
847             return (true, c);
848         }
849     }
850 
851     /**
852      * @dev Returns the division of two unsigned integers, with a division by zero flag.
853      *
854      * _Available since v3.4._
855      */
856     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
857         unchecked {
858             if (b == 0) return (false, 0);
859             return (true, a / b);
860         }
861     }
862 
863     /**
864      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
865      *
866      * _Available since v3.4._
867      */
868     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
869         unchecked {
870             if (b == 0) return (false, 0);
871             return (true, a % b);
872         }
873     }
874 
875     /**
876      * @dev Returns the addition of two unsigned integers, reverting on
877      * overflow.
878      *
879      * Counterpart to Solidity's `+` operator.
880      *
881      * Requirements:
882      *
883      * - Addition cannot overflow.
884      */
885     function add(uint256 a, uint256 b) internal pure returns (uint256) {
886         return a + b;
887     }
888 
889     /**
890      * @dev Returns the subtraction of two unsigned integers, reverting on
891      * overflow (when the result is negative).
892      *
893      * Counterpart to Solidity's `-` operator.
894      *
895      * Requirements:
896      *
897      * - Subtraction cannot overflow.
898      */
899     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
900         return a - b;
901     }
902 
903     /**
904      * @dev Returns the multiplication of two unsigned integers, reverting on
905      * overflow.
906      *
907      * Counterpart to Solidity's `*` operator.
908      *
909      * Requirements:
910      *
911      * - Multiplication cannot overflow.
912      */
913     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
914         return a * b;
915     }
916 
917     /**
918      * @dev Returns the integer division of two unsigned integers, reverting on
919      * division by zero. The result is rounded towards zero.
920      *
921      * Counterpart to Solidity's `/` operator.
922      *
923      * Requirements:
924      *
925      * - The divisor cannot be zero.
926      */
927     function div(uint256 a, uint256 b) internal pure returns (uint256) {
928         return a / b;
929     }
930 
931     /**
932      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
933      * reverting when dividing by zero.
934      *
935      * Counterpart to Solidity's `%` operator. This function uses a `revert`
936      * opcode (which leaves remaining gas untouched) while Solidity uses an
937      * invalid opcode to revert (consuming all remaining gas).
938      *
939      * Requirements:
940      *
941      * - The divisor cannot be zero.
942      */
943     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
944         return a % b;
945     }
946 
947     /**
948      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
949      * overflow (when the result is negative).
950      *
951      * CAUTION: This function is deprecated because it requires allocating memory for the error
952      * message unnecessarily. For custom revert reasons use {trySub}.
953      *
954      * Counterpart to Solidity's `-` operator.
955      *
956      * Requirements:
957      *
958      * - Subtraction cannot overflow.
959      */
960     function sub(
961         uint256 a,
962         uint256 b,
963         string memory errorMessage
964     ) internal pure returns (uint256) {
965         unchecked {
966             require(b <= a, errorMessage);
967             return a - b;
968         }
969     }
970 
971     /**
972      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
973      * division by zero. The result is rounded towards zero.
974      *
975      * Counterpart to Solidity's `/` operator. Note: this function uses a
976      * `revert` opcode (which leaves remaining gas untouched) while Solidity
977      * uses an invalid opcode to revert (consuming all remaining gas).
978      *
979      * Requirements:
980      *
981      * - The divisor cannot be zero.
982      */
983     function div(
984         uint256 a,
985         uint256 b,
986         string memory errorMessage
987     ) internal pure returns (uint256) {
988         unchecked {
989             require(b > 0, errorMessage);
990             return a / b;
991         }
992     }
993 
994     /**
995      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
996      * reverting with custom message when dividing by zero.
997      *
998      * CAUTION: This function is deprecated because it requires allocating memory for the error
999      * message unnecessarily. For custom revert reasons use {tryMod}.
1000      *
1001      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1002      * opcode (which leaves remaining gas untouched) while Solidity uses an
1003      * invalid opcode to revert (consuming all remaining gas).
1004      *
1005      * Requirements:
1006      *
1007      * - The divisor cannot be zero.
1008      */
1009     function mod(
1010         uint256 a,
1011         uint256 b,
1012         string memory errorMessage
1013     ) internal pure returns (uint256) {
1014         unchecked {
1015             require(b > 0, errorMessage);
1016             return a % b;
1017         }
1018     }
1019 }
1020 
1021 ////// src/IUniswapV2Factory.sol
1022 /* pragma solidity 0.8.10; */
1023 /* pragma experimental ABIEncoderV2; */
1024 
1025 interface IUniswapV2Factory {
1026     event PairCreated(
1027         address indexed token0,
1028         address indexed token1,
1029         address pair,
1030         uint256
1031     );
1032 
1033     function feeTo() external view returns (address);
1034 
1035     function feeToSetter() external view returns (address);
1036 
1037     function getPair(address tokenA, address tokenB)
1038         external
1039         view
1040         returns (address pair);
1041 
1042     function allPairs(uint256) external view returns (address pair);
1043 
1044     function allPairsLength() external view returns (uint256);
1045 
1046     function createPair(address tokenA, address tokenB)
1047         external
1048         returns (address pair);
1049 
1050     function setFeeTo(address) external;
1051 
1052     function setFeeToSetter(address) external;
1053 }
1054 
1055 ////// src/IUniswapV2Pair.sol
1056 /* pragma solidity 0.8.10; */
1057 /* pragma experimental ABIEncoderV2; */
1058 
1059 interface IUniswapV2Pair {
1060     event Approval(
1061         address indexed owner,
1062         address indexed spender,
1063         uint256 value
1064     );
1065     event Transfer(address indexed from, address indexed to, uint256 value);
1066 
1067     function name() external pure returns (string memory);
1068 
1069     function symbol() external pure returns (string memory);
1070 
1071     function decimals() external pure returns (uint8);
1072 
1073     function totalSupply() external view returns (uint256);
1074 
1075     function balanceOf(address owner) external view returns (uint256);
1076 
1077     function allowance(address owner, address spender)
1078         external
1079         view
1080         returns (uint256);
1081 
1082     function approve(address spender, uint256 value) external returns (bool);
1083 
1084     function transfer(address to, uint256 value) external returns (bool);
1085 
1086     function transferFrom(
1087         address from,
1088         address to,
1089         uint256 value
1090     ) external returns (bool);
1091 
1092     function DOMAIN_SEPARATOR() external view returns (bytes32);
1093 
1094     function PERMIT_TYPEHASH() external pure returns (bytes32);
1095 
1096     function nonces(address owner) external view returns (uint256);
1097 
1098     function permit(
1099         address owner,
1100         address spender,
1101         uint256 value,
1102         uint256 deadline,
1103         uint8 v,
1104         bytes32 r,
1105         bytes32 s
1106     ) external;
1107 
1108     event Mint(address indexed sender, uint256 amount0, uint256 amount1);
1109     event Burn(
1110         address indexed sender,
1111         uint256 amount0,
1112         uint256 amount1,
1113         address indexed to
1114     );
1115     event Swap(
1116         address indexed sender,
1117         uint256 amount0In,
1118         uint256 amount1In,
1119         uint256 amount0Out,
1120         uint256 amount1Out,
1121         address indexed to
1122     );
1123     event Sync(uint112 reserve0, uint112 reserve1);
1124 
1125     function MINIMUM_LIQUIDITY() external pure returns (uint256);
1126 
1127     function factory() external view returns (address);
1128 
1129     function token0() external view returns (address);
1130 
1131     function token1() external view returns (address);
1132 
1133     function getReserves()
1134         external
1135         view
1136         returns (
1137             uint112 reserve0,
1138             uint112 reserve1,
1139             uint32 blockTimestampLast
1140         );
1141 
1142     function price0CumulativeLast() external view returns (uint256);
1143 
1144     function price1CumulativeLast() external view returns (uint256);
1145 
1146     function kLast() external view returns (uint256);
1147 
1148     function mint(address to) external returns (uint256 liquidity);
1149 
1150     function burn(address to)
1151         external
1152         returns (uint256 amount0, uint256 amount1);
1153 
1154     function swap(
1155         uint256 amount0Out,
1156         uint256 amount1Out,
1157         address to,
1158         bytes calldata data
1159     ) external;
1160 
1161     function skim(address to) external;
1162 
1163     function sync() external;
1164 
1165     function initialize(address, address) external;
1166 }
1167 
1168 ////// src/IUniswapV2Router02.sol
1169 /* pragma solidity 0.8.10; */
1170 /* pragma experimental ABIEncoderV2; */
1171 
1172 interface IUniswapV2Router02 {
1173     function factory() external pure returns (address);
1174 
1175     function WETH() external pure returns (address);
1176 
1177     function addLiquidity(
1178         address tokenA,
1179         address tokenB,
1180         uint256 amountADesired,
1181         uint256 amountBDesired,
1182         uint256 amountAMin,
1183         uint256 amountBMin,
1184         address to,
1185         uint256 deadline
1186     )
1187         external
1188         returns (
1189             uint256 amountA,
1190             uint256 amountB,
1191             uint256 liquidity
1192         );
1193 
1194     function addLiquidityETH(
1195         address token,
1196         uint256 amountTokenDesired,
1197         uint256 amountTokenMin,
1198         uint256 amountETHMin,
1199         address to,
1200         uint256 deadline
1201     )
1202         external
1203         payable
1204         returns (
1205             uint256 amountToken,
1206             uint256 amountETH,
1207             uint256 liquidity
1208         );
1209 
1210     function swapExactTokensForTokensSupportingFeeOnTransferTokens(
1211         uint256 amountIn,
1212         uint256 amountOutMin,
1213         address[] calldata path,
1214         address to,
1215         uint256 deadline
1216     ) external;
1217 
1218     function swapExactETHForTokensSupportingFeeOnTransferTokens(
1219         uint256 amountOutMin,
1220         address[] calldata path,
1221         address to,
1222         uint256 deadline
1223     ) external payable;
1224 
1225     function swapExactTokensForETHSupportingFeeOnTransferTokens(
1226         uint256 amountIn,
1227         uint256 amountOutMin,
1228         address[] calldata path,
1229         address to,
1230         uint256 deadline
1231     ) external;
1232 }
1233 
1234 ////// src/ChadFi.sol
1235 /**
1236 
1237 Chad Finance
1238 
1239 u'all are not ready for this
1240 
1241 Tax for Buying/Selling: 12%
1242     - 2% of each transaction sent to holders as ETH transactions
1243     - 5% of each transaction sent to Treasury Wallet
1244     - 5% of each transaction sent to the Liquidity Pool
1245 
1246 Earning Dashboard:
1247 https:/chadfi.xyz
1248 
1249 */
1250 
1251 /* pragma solidity 0.8.10; */
1252 
1253 /* import {ERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/ERC20.sol"; */
1254 /* import {IERC20} from "lib/openzeppelin-contracts/contracts/token/ERC20/IERC20.sol"; */
1255 /* import {Ownable} from "lib/openzeppelin-contracts/contracts/access/Ownable.sol"; */
1256 /* import {Address} from "lib/openzeppelin-contracts/contracts/utils/Address.sol"; */
1257 /* import {SafeMath} from "lib/openzeppelin-contracts/contracts/utils/math/SafeMath.sol"; */
1258 
1259 /* import {IUniswapV2Router02} from "./IUniswapV2Router02.sol"; */
1260 /* import {IUniswapV2Factory} from "./IUniswapV2Factory.sol"; */
1261 /* import {IUniswapV2Pair} from "./IUniswapV2Pair.sol"; */
1262 
1263 contract PiggyBank is Ownable, IERC20 {
1264     address UNISWAPROUTER = address(0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D);
1265     address DEAD = 0x000000000000000000000000000000000000dEaD;
1266     address ZERO = 0x0000000000000000000000000000000000000000;
1267 
1268     string private _name = "Piggy Bank";
1269     string private _symbol = "PIGGY";
1270 
1271     uint256 public treasuryFeeBPS = 200;
1272     uint256 public liquidityFeeBPS = 500;
1273     uint256 public dividendFeeBPS = 700;
1274     uint256 public totalFeeBPS = 1400;
1275 
1276     uint256 public swapTokensAtAmount = 100000 * (10**18);
1277     uint256 public lastSwapTime;
1278     bool swapAllToken = true;
1279 
1280     bool public swapEnabled = true;
1281     bool public taxEnabled = true;
1282     bool public compoundingEnabled = true;
1283 
1284     uint256 private _totalSupply;
1285     bool private swapping;
1286 
1287     address marketingWallet;
1288     address liquidityWallet;
1289 
1290     mapping(address => uint256) private _balances;
1291     mapping(address => mapping(address => uint256)) private _allowances;
1292     mapping(address => bool) private _isExcludedFromFees;
1293     mapping(address => bool) public automatedMarketMakerPairs;
1294     mapping(address => bool) private _whiteList;
1295     mapping(address => bool) isBlacklisted;
1296 
1297     event SwapAndAddLiquidity(
1298         uint256 tokensSwapped,
1299         uint256 nativeReceived,
1300         uint256 tokensIntoLiquidity
1301     );
1302     event SendDividends(uint256 tokensSwapped, uint256 amount);
1303     event ExcludeFromFees(address indexed account, bool isExcluded);
1304     event SetAutomatedMarketMakerPair(address indexed pair, bool indexed value);
1305     event UpdateUniswapV2Router(
1306         address indexed newAddress,
1307         address indexed oldAddress
1308     );
1309     event SwapEnabled(bool enabled);
1310     event TaxEnabled(bool enabled);
1311     event CompoundingEnabled(bool enabled);
1312     event BlacklistEnabled(bool enabled);
1313 
1314     DividendTracker public dividendTracker;
1315     IUniswapV2Router02 public uniswapV2Router;
1316 
1317     address public uniswapV2Pair;
1318 
1319     uint256 public maxTxBPS = 46;
1320     uint256 public maxWalletBPS = 200;
1321 
1322     bool isOpen = false;
1323 
1324     mapping(address => bool) private _isExcludedFromMaxTx;
1325     mapping(address => bool) private _isExcludedFromMaxWallet;
1326 
1327     constructor(
1328         address _marketingWallet,
1329         address _liquidityWallet,
1330         address[] memory whitelistAddress
1331     ) {
1332         marketingWallet = _marketingWallet;
1333         liquidityWallet = _liquidityWallet;
1334         includeToWhiteList(whitelistAddress);
1335 
1336         dividendTracker = new DividendTracker(address(this), UNISWAPROUTER);
1337 
1338         IUniswapV2Router02 _uniswapV2Router = IUniswapV2Router02(UNISWAPROUTER);
1339 
1340         address _uniswapV2Pair = IUniswapV2Factory(_uniswapV2Router.factory())
1341             .createPair(address(this), _uniswapV2Router.WETH());
1342 
1343         uniswapV2Router = _uniswapV2Router;
1344         uniswapV2Pair = _uniswapV2Pair;
1345 
1346         _setAutomatedMarketMakerPair(_uniswapV2Pair, true);
1347 
1348         dividendTracker.excludeFromDividends(address(dividendTracker), true);
1349         dividendTracker.excludeFromDividends(address(this), true);
1350         dividendTracker.excludeFromDividends(owner(), true);
1351         dividendTracker.excludeFromDividends(address(_uniswapV2Router), true);
1352 
1353         excludeFromFees(owner(), true);
1354         excludeFromFees(address(this), true);
1355         excludeFromFees(address(dividendTracker), true);
1356 
1357         excludeFromMaxTx(owner(), true);
1358         excludeFromMaxTx(address(this), true);
1359         excludeFromMaxTx(address(dividendTracker), true);
1360 
1361         excludeFromMaxWallet(owner(), true);
1362         excludeFromMaxWallet(address(this), true);
1363         excludeFromMaxWallet(address(dividendTracker), true);
1364 
1365         _mint(owner(), 1000000000 * (10**18));
1366     }
1367 
1368     receive() external payable {}
1369 
1370     function name() public view returns (string memory) {
1371         return _name;
1372     }
1373 
1374     function symbol() public view returns (string memory) {
1375         return _symbol;
1376     }
1377 
1378     function decimals() public pure returns (uint8) {
1379         return 18;
1380     }
1381 
1382     function totalSupply() public view virtual override returns (uint256) {
1383         return _totalSupply;
1384     }
1385 
1386     function balanceOf(address account)
1387         public
1388         view
1389         virtual
1390         override
1391         returns (uint256)
1392     {
1393         return _balances[account];
1394     }
1395 
1396     function allowance(address owner, address spender)
1397         public
1398         view
1399         virtual
1400         override
1401         returns (uint256)
1402     {
1403         return _allowances[owner][spender];
1404     }
1405 
1406     function approve(address spender, uint256 amount)
1407         public
1408         virtual
1409         override
1410         returns (bool)
1411     {
1412         _approve(_msgSender(), spender, amount);
1413         return true;
1414     }
1415 
1416     function increaseAllowance(address spender, uint256 addedValue)
1417         public
1418         returns (bool)
1419     {
1420         _approve(
1421             _msgSender(),
1422             spender,
1423             _allowances[_msgSender()][spender] + addedValue
1424         );
1425         return true;
1426     }
1427 
1428     function decreaseAllowance(address spender, uint256 subtractedValue)
1429         public
1430         returns (bool)
1431     {
1432         uint256 currentAllowance = _allowances[_msgSender()][spender];
1433         require(
1434             currentAllowance >= subtractedValue,
1435             "EnhancedLiquidityKonstrukt: decreased allowance below zero"
1436         );
1437         _approve(_msgSender(), spender, currentAllowance - subtractedValue);
1438         return true;
1439     }
1440 
1441     function transfer(address recipient, uint256 amount)
1442         public
1443         virtual
1444         override
1445         returns (bool)
1446     {
1447         _transfer(_msgSender(), recipient, amount);
1448         return true;
1449     }
1450 
1451     function transferFrom(
1452         address sender,
1453         address recipient,
1454         uint256 amount
1455     ) public virtual override returns (bool) {
1456         _transfer(sender, recipient, amount);
1457         uint256 currentAllowance = _allowances[sender][_msgSender()];
1458         require(
1459             currentAllowance >= amount,
1460             "EnhancedLiquidityKonstrukt: transfer amount exceeds allowance"
1461         );
1462         _approve(sender, _msgSender(), currentAllowance - amount);
1463         return true;
1464     }
1465 
1466     function openTrading() external onlyOwner {
1467         isOpen = true;
1468     }
1469 
1470     function _transfer(
1471         address sender,
1472         address recipient,
1473         uint256 amount
1474     ) internal {
1475         require(
1476             isOpen ||
1477                 sender == owner() ||
1478                 recipient == owner() ||
1479                 _whiteList[sender] ||
1480                 _whiteList[recipient],
1481             "Not Open"
1482         );
1483 
1484         require(!isBlacklisted[sender], "EnhancedLiquidityKonstrukt: Sender is blacklisted");
1485         require(!isBlacklisted[recipient], "EnhancedLiquidityKonstrukt: Recipient is blacklisted");
1486 
1487         require(sender != address(0), "EnhancedLiquidityKonstrukt: transfer from the zero address");
1488         require(recipient != address(0), "EnhancedLiquidityKonstrukt: transfer to the zero address");
1489 
1490         uint256 _maxTxAmount = (totalSupply() * maxTxBPS) / 10000;
1491         uint256 _maxWallet = (totalSupply() * maxWalletBPS) / 10000;
1492         require(
1493             amount <= _maxTxAmount || _isExcludedFromMaxTx[sender],
1494             "TX Limit Exceeded"
1495         );
1496 
1497         if (
1498             sender != owner() &&
1499             recipient != address(this) &&
1500             recipient != address(DEAD) &&
1501             recipient != uniswapV2Pair
1502         ) {
1503             uint256 currentBalance = balanceOf(recipient);
1504             require(
1505                 _isExcludedFromMaxWallet[recipient] ||
1506                     (currentBalance + amount <= _maxWallet)
1507             );
1508         }
1509 
1510         uint256 senderBalance = _balances[sender];
1511         require(
1512             senderBalance >= amount,
1513             "EnhancedLiquidityKonstrukt: transfer amount exceeds balance"
1514         );
1515 
1516         uint256 contractTokenBalance = balanceOf(address(this));
1517         uint256 contractNativeBalance = address(this).balance;
1518 
1519         bool canSwap = contractTokenBalance >= swapTokensAtAmount;
1520 
1521         if (
1522             swapEnabled && // True
1523             canSwap && // true
1524             !swapping && // swapping=false !false true
1525             !automatedMarketMakerPairs[sender] && // no swap on remove liquidity step 1 or DEX buy
1526             sender != address(uniswapV2Router) && // no swap on remove liquidity step 2
1527             sender != owner() &&
1528             recipient != owner()
1529         ) {
1530             swapping = true;
1531 
1532             if (!swapAllToken) {
1533                 contractTokenBalance = swapTokensAtAmount;
1534             }
1535             _executeSwap(contractTokenBalance, contractNativeBalance);
1536 
1537             lastSwapTime = block.timestamp;
1538             swapping = false;
1539         }
1540 
1541         bool takeFee;
1542 
1543         if (
1544             sender == address(uniswapV2Pair) ||
1545             recipient == address(uniswapV2Pair)
1546         ) {
1547             takeFee = true;
1548         }
1549 
1550         if (_isExcludedFromFees[sender] || _isExcludedFromFees[recipient]) {
1551             takeFee = false;
1552         }
1553 
1554         if (swapping || !taxEnabled) {
1555             takeFee = false;
1556         }
1557 
1558         if (takeFee) {
1559             uint256 fees = (amount * totalFeeBPS) / 10000;
1560             amount -= fees;
1561             _executeTransfer(sender, address(this), fees);
1562         }
1563 
1564         _executeTransfer(sender, recipient, amount);
1565 
1566         dividendTracker.setBalance(payable(sender), balanceOf(sender));
1567         dividendTracker.setBalance(payable(recipient), balanceOf(recipient));
1568     }
1569 
1570     function _executeTransfer(
1571         address sender,
1572         address recipient,
1573         uint256 amount
1574     ) private {
1575         require(sender != address(0), "EnhancedLiquidityKonstrukt: transfer from the zero address");
1576         require(recipient != address(0), "EnhancedLiquidityKonstrukt: transfer to the zero address");
1577         uint256 senderBalance = _balances[sender];
1578         require(
1579             senderBalance >= amount,
1580             "EnhancedLiquidityKonstrukt: transfer amount exceeds balance"
1581         );
1582         _balances[sender] = senderBalance - amount;
1583         _balances[recipient] += amount;
1584         emit Transfer(sender, recipient, amount);
1585     }
1586 
1587     function _approve(
1588         address owner,
1589         address spender,
1590         uint256 amount
1591     ) private {
1592         require(owner != address(0), "EnhancedLiquidityKonstrukt: approve from the zero address");
1593         require(spender != address(0), "EnhancedLiquidityKonstrukt: approve to the zero address");
1594         _allowances[owner][spender] = amount;
1595         emit Approval(owner, spender, amount);
1596     }
1597 
1598     function _mint(address account, uint256 amount) private {
1599         require(account != address(0), "EnhancedLiquidityKonstrukt: mint to the zero address");
1600         _totalSupply += amount;
1601         _balances[account] += amount;
1602         emit Transfer(address(0), account, amount);
1603     }
1604 
1605     function _burn(address account, uint256 amount) private {
1606         require(account != address(0), "EnhancedLiquidityKonstrukt: burn from the zero address");
1607         uint256 accountBalance = _balances[account];
1608         require(accountBalance >= amount, "EnhancedLiquidityKonstrukt: burn amount exceeds balance");
1609         _balances[account] = accountBalance - amount;
1610         _totalSupply -= amount;
1611         emit Transfer(account, address(0), amount);
1612     }
1613 
1614     function swapTokensForNative(uint256 tokens) private {
1615         address[] memory path = new address[](2);
1616         path[0] = address(this);
1617         path[1] = uniswapV2Router.WETH();
1618         _approve(address(this), address(uniswapV2Router), tokens);
1619         uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
1620             tokens,
1621             0, // accept any amount of native
1622             path,
1623             address(this),
1624             block.timestamp
1625         );
1626     }
1627 
1628     function addLiquidity(uint256 tokens, uint256 native) private {
1629         _approve(address(this), address(uniswapV2Router), tokens);
1630         uniswapV2Router.addLiquidityETH{value: native}(
1631             address(this),
1632             tokens,
1633             0, // slippage unavoidable
1634             0, // slippage unavoidable
1635             liquidityWallet,
1636             block.timestamp
1637         );
1638     }
1639 
1640     function includeToWhiteList(address[] memory _users) private {
1641         for (uint8 i = 0; i < _users.length; i++) {
1642             _whiteList[_users[i]] = true;
1643         }
1644     }
1645 
1646     function _executeSwap(uint256 tokens, uint256 native) private {
1647         if (tokens <= 0) {
1648             return;
1649         }
1650 
1651         uint256 swapTokensMarketing;
1652         if (address(marketingWallet) != address(0)) {
1653             swapTokensMarketing = (tokens * treasuryFeeBPS) / totalFeeBPS;
1654         }
1655 
1656         uint256 swapTokensDividends;
1657         if (dividendTracker.totalSupply() > 0) {
1658             swapTokensDividends = (tokens * dividendFeeBPS) / totalFeeBPS;
1659         }
1660 
1661         uint256 tokensForLiquidity = tokens -
1662             swapTokensMarketing -
1663             swapTokensDividends;
1664         uint256 swapTokensLiquidity = tokensForLiquidity / 2;
1665         uint256 addTokensLiquidity = tokensForLiquidity - swapTokensLiquidity;
1666         uint256 swapTokensTotal = swapTokensMarketing +
1667             swapTokensDividends +
1668             swapTokensLiquidity;
1669 
1670         uint256 initNativeBal = address(this).balance;
1671         swapTokensForNative(swapTokensTotal);
1672         uint256 nativeSwapped = (address(this).balance - initNativeBal) +
1673             native;
1674 
1675         uint256 nativeMarketing = (nativeSwapped * swapTokensMarketing) /
1676             swapTokensTotal;
1677         uint256 nativeDividends = (nativeSwapped * swapTokensDividends) /
1678             swapTokensTotal;
1679         uint256 nativeLiquidity = nativeSwapped -
1680             nativeMarketing -
1681             nativeDividends;
1682 
1683         if (nativeMarketing > 0) {
1684             payable(marketingWallet).transfer(nativeMarketing);
1685         }
1686 
1687         addLiquidity(addTokensLiquidity, nativeLiquidity);
1688         emit SwapAndAddLiquidity(
1689             swapTokensLiquidity,
1690             nativeLiquidity,
1691             addTokensLiquidity
1692         );
1693 
1694         if (nativeDividends > 0) {
1695             (bool success, ) = address(dividendTracker).call{
1696                 value: nativeDividends
1697             }("");
1698             if (success) {
1699                 emit SendDividends(swapTokensDividends, nativeDividends);
1700             }
1701         }
1702     }
1703 
1704     function excludeFromFees(address account, bool excluded) public onlyOwner {
1705         require(
1706             _isExcludedFromFees[account] != excluded,
1707             "EnhancedLiquidityKonstrukt: account is already set to requested state"
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
1741         address payable _liquidityWallet
1742     ) external onlyOwner {
1743         marketingWallet = _marketingWallet;
1744         liquidityWallet = _liquidityWallet;
1745     }
1746 
1747     function setAutomatedMarketMakerPair(address pair, bool value)
1748         public
1749         onlyOwner
1750     {
1751         require(pair != uniswapV2Pair, "EnhancedLiquidityKonstrukt: DEX pair can not be removed");
1752         _setAutomatedMarketMakerPair(pair, value);
1753     }
1754 
1755     function setFee(
1756         uint256 _treasuryFee,
1757         uint256 _liquidityFee,
1758         uint256 _dividendFee
1759     ) external onlyOwner {
1760         treasuryFeeBPS = _treasuryFee;
1761         liquidityFeeBPS = _liquidityFee;
1762         dividendFeeBPS = _dividendFee;
1763         totalFeeBPS = _treasuryFee + _liquidityFee + _dividendFee;
1764     }
1765 
1766     function _setAutomatedMarketMakerPair(address pair, bool value) private {
1767         require(
1768             automatedMarketMakerPairs[pair] != value,
1769             "EnhancedLiquidityKonstrukt: automated market maker pair is already set to that value"
1770         );
1771         automatedMarketMakerPairs[pair] = value;
1772         if (value) {
1773             dividendTracker.excludeFromDividends(pair, true);
1774         }
1775         emit SetAutomatedMarketMakerPair(pair, value);
1776     }
1777 
1778     function updateUniswapV2Router(address newAddress) public onlyOwner {
1779         require(
1780             newAddress != address(uniswapV2Router),
1781             "EnhancedLiquidityKonstrukt: the router is already set to the new address"
1782         );
1783         emit UpdateUniswapV2Router(newAddress, address(uniswapV2Router));
1784         uniswapV2Router = IUniswapV2Router02(newAddress);
1785         address _uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory())
1786             .createPair(address(this), uniswapV2Router.WETH());
1787         uniswapV2Pair = _uniswapV2Pair;
1788     }
1789 
1790     function claim() public {
1791         dividendTracker.processAccount(payable(_msgSender()));
1792     }
1793 
1794     function compound() public {
1795         require(compoundingEnabled, "EnhancedLiquidityKonstrukt: compounding is not enabled");
1796         dividendTracker.compoundAccount(payable(_msgSender()));
1797     }
1798 
1799     function withdrawableDividendOf(address account)
1800         public
1801         view
1802         returns (uint256)
1803     {
1804         return dividendTracker.withdrawableDividendOf(account);
1805     }
1806 
1807     function withdrawnDividendOf(address account)
1808         public
1809         view
1810         returns (uint256)
1811     {
1812         return dividendTracker.withdrawnDividendOf(account);
1813     }
1814 
1815     function accumulativeDividendOf(address account)
1816         public
1817         view
1818         returns (uint256)
1819     {
1820         return dividendTracker.accumulativeDividendOf(account);
1821     }
1822 
1823     function getAccountInfo(address account)
1824         public
1825         view
1826         returns (
1827             address,
1828             uint256,
1829             uint256,
1830             uint256,
1831             uint256
1832         )
1833     {
1834         return dividendTracker.getAccountInfo(account);
1835     }
1836 
1837     function getLastClaimTime(address account) public view returns (uint256) {
1838         return dividendTracker.getLastClaimTime(account);
1839     }
1840 
1841     function setSwapEnabled(bool _enabled) external onlyOwner {
1842         swapEnabled = _enabled;
1843         emit SwapEnabled(_enabled);
1844     }
1845 
1846     function setTaxEnabled(bool _enabled) external onlyOwner {
1847         taxEnabled = _enabled;
1848         emit TaxEnabled(_enabled);
1849     }
1850 
1851     function setCompoundingEnabled(bool _enabled) external onlyOwner {
1852         compoundingEnabled = _enabled;
1853         emit CompoundingEnabled(_enabled);
1854     }
1855 
1856     function updateDividendSettings(
1857         bool _swapEnabled,
1858         uint256 _swapTokensAtAmount,
1859         bool _swapAllToken
1860     ) external onlyOwner {
1861         swapEnabled = _swapEnabled;
1862         swapTokensAtAmount = _swapTokensAtAmount;
1863         swapAllToken = _swapAllToken;
1864     }
1865 
1866     function setMaxTxBPS(uint256 bps) external onlyOwner {
1867         require(bps >= 75 && bps <= 10000, "BPS must be between 75 and 10000");
1868         maxTxBPS = bps;
1869     }
1870 
1871     function excludeFromMaxTx(address account, bool excluded) public onlyOwner {
1872         _isExcludedFromMaxTx[account] = excluded;
1873     }
1874 
1875     function isExcludedFromMaxTx(address account) public view returns (bool) {
1876         return _isExcludedFromMaxTx[account];
1877     }
1878 
1879     function setMaxWalletBPS(uint256 bps) external onlyOwner {
1880         require(
1881             bps >= 175 && bps <= 10000,
1882             "BPS must be between 175 and 10000"
1883         );
1884         maxWalletBPS = bps;
1885     }
1886 
1887     function excludeFromMaxWallet(address account, bool excluded)
1888         public
1889         onlyOwner
1890     {
1891         _isExcludedFromMaxWallet[account] = excluded;
1892     }
1893 
1894     function isExcludedFromMaxWallet(address account)
1895         public
1896         view
1897         returns (bool)
1898     {
1899         return _isExcludedFromMaxWallet[account];
1900     }
1901 
1902     function rescueToken(address _token, uint256 _amount) external onlyOwner {
1903         IERC20(_token).transfer(msg.sender, _amount);
1904     }
1905 
1906     function rescueETH(uint256 _amount) external onlyOwner {
1907         payable(msg.sender).transfer(_amount);
1908     }
1909 
1910     function blackList(address _user) public onlyOwner {
1911         require(!isBlacklisted[_user], "user already blacklisted");
1912         isBlacklisted[_user] = true;
1913         // events?
1914     }
1915 
1916     function removeFromBlacklist(address _user) public onlyOwner {
1917         require(isBlacklisted[_user], "user already whitelisted");
1918         isBlacklisted[_user] = false;
1919         //events?
1920     }
1921 
1922     function blackListMany(address[] memory _users) public onlyOwner {
1923         for (uint8 i = 0; i < _users.length; i++) {
1924             isBlacklisted[_users[i]] = true;
1925         }
1926     }
1927 
1928     function unBlackListMany(address[] memory _users) public onlyOwner {
1929         for (uint8 i = 0; i < _users.length; i++) {
1930             isBlacklisted[_users[i]] = false;
1931         }
1932     }
1933 }
1934 
1935 contract DividendTracker is Ownable, IERC20 {
1936     address UNISWAPROUTER;
1937 
1938     string private _name = "PiggyBank_DividendTracker";
1939     string private _symbol = "PiggyBank_DividendTracker";
1940 
1941     uint256 public lastProcessedIndex;
1942 
1943     uint256 private _totalSupply;
1944     mapping(address => uint256) private _balances;
1945 
1946     uint256 private constant magnitude = 2**128;
1947     uint256 public immutable minTokenBalanceForDividends;
1948     uint256 private magnifiedDividendPerShare;
1949     uint256 public totalDividendsDistributed;
1950     uint256 public totalDividendsWithdrawn;
1951 
1952     address public tokenAddress;
1953 
1954     mapping(address => bool) public excludedFromDividends;
1955     mapping(address => int256) private magnifiedDividendCorrections;
1956     mapping(address => uint256) private withdrawnDividends;
1957     mapping(address => uint256) private lastClaimTimes;
1958 
1959     event DividendsDistributed(address indexed from, uint256 weiAmount);
1960     event DividendWithdrawn(address indexed to, uint256 weiAmount);
1961     event ExcludeFromDividends(address indexed account, bool excluded);
1962     event Claim(address indexed account, uint256 amount);
1963     event Compound(address indexed account, uint256 amount, uint256 tokens);
1964 
1965     struct AccountInfo {
1966         address account;
1967         uint256 withdrawableDividends;
1968         uint256 totalDividends;
1969         uint256 lastClaimTime;
1970     }
1971 
1972     constructor(address _tokenAddress, address _uniswapRouter) {
1973         minTokenBalanceForDividends = 10000 * (10**18);
1974         tokenAddress = _tokenAddress;
1975         UNISWAPROUTER = _uniswapRouter;
1976     }
1977 
1978     receive() external payable {
1979         distributeDividends();
1980     }
1981 
1982     function distributeDividends() public payable {
1983         require(_totalSupply > 0);
1984         if (msg.value > 0) {
1985             magnifiedDividendPerShare =
1986                 magnifiedDividendPerShare +
1987                 ((msg.value * magnitude) / _totalSupply);
1988             emit DividendsDistributed(msg.sender, msg.value);
1989             totalDividendsDistributed += msg.value;
1990         }
1991     }
1992 
1993     function setBalance(address payable account, uint256 newBalance)
1994         external
1995         onlyOwner
1996     {
1997         if (excludedFromDividends[account]) {
1998             return;
1999         }
2000         if (newBalance >= minTokenBalanceForDividends) {
2001             _setBalance(account, newBalance);
2002         } else {
2003             _setBalance(account, 0);
2004         }
2005     }
2006 
2007     function excludeFromDividends(address account, bool excluded)
2008         external
2009         onlyOwner
2010     {
2011         require(
2012             excludedFromDividends[account] != excluded,
2013             "PiggyBank_DividendTracker: account already set to requested state"
2014         );
2015         excludedFromDividends[account] = excluded;
2016         if (excluded) {
2017             _setBalance(account, 0);
2018         } else {
2019             uint256 newBalance = IERC20(tokenAddress).balanceOf(account);
2020             if (newBalance >= minTokenBalanceForDividends) {
2021                 _setBalance(account, newBalance);
2022             } else {
2023                 _setBalance(account, 0);
2024             }
2025         }
2026         emit ExcludeFromDividends(account, excluded);
2027     }
2028 
2029     function isExcludedFromDividends(address account)
2030         public
2031         view
2032         returns (bool)
2033     {
2034         return excludedFromDividends[account];
2035     }
2036 
2037     function manualSendDividend(uint256 amount, address holder)
2038         external
2039         onlyOwner
2040     {
2041         uint256 contractETHBalance = address(this).balance;
2042         payable(holder).transfer(amount > 0 ? amount : contractETHBalance);
2043     }
2044 
2045     function _setBalance(address account, uint256 newBalance) internal {
2046         uint256 currentBalance = _balances[account];
2047         if (newBalance > currentBalance) {
2048             uint256 addAmount = newBalance - currentBalance;
2049             _mint(account, addAmount);
2050         } else if (newBalance < currentBalance) {
2051             uint256 subAmount = currentBalance - newBalance;
2052             _burn(account, subAmount);
2053         }
2054     }
2055 
2056     function _mint(address account, uint256 amount) private {
2057         require(
2058             account != address(0),
2059             "PiggyBank_DividendTracker: mint to the zero address"
2060         );
2061         _totalSupply += amount;
2062         _balances[account] += amount;
2063         emit Transfer(address(0), account, amount);
2064         magnifiedDividendCorrections[account] =
2065             magnifiedDividendCorrections[account] -
2066             int256(magnifiedDividendPerShare * amount);
2067     }
2068 
2069     function _burn(address account, uint256 amount) private {
2070         require(
2071             account != address(0),
2072             "PiggyBank_DividendTracker: burn from the zero address"
2073         );
2074         uint256 accountBalance = _balances[account];
2075         require(
2076             accountBalance >= amount,
2077             "PiggyBank_DividendTracker: burn amount exceeds balance"
2078         );
2079         _balances[account] = accountBalance - amount;
2080         _totalSupply -= amount;
2081         emit Transfer(account, address(0), amount);
2082         magnifiedDividendCorrections[account] =
2083             magnifiedDividendCorrections[account] +
2084             int256(magnifiedDividendPerShare * amount);
2085     }
2086 
2087     function processAccount(address payable account)
2088         public
2089         onlyOwner
2090         returns (bool)
2091     {
2092         uint256 amount = _withdrawDividendOfUser(account);
2093         if (amount > 0) {
2094             lastClaimTimes[account] = block.timestamp;
2095             emit Claim(account, amount);
2096             return true;
2097         }
2098         return false;
2099     }
2100 
2101     function _withdrawDividendOfUser(address payable account)
2102         private
2103         returns (uint256)
2104     {
2105         uint256 _withdrawableDividend = withdrawableDividendOf(account);
2106         if (_withdrawableDividend > 0) {
2107             withdrawnDividends[account] += _withdrawableDividend;
2108             totalDividendsWithdrawn += _withdrawableDividend;
2109             emit DividendWithdrawn(account, _withdrawableDividend);
2110             (bool success, ) = account.call{
2111                 value: _withdrawableDividend,
2112                 gas: 3000
2113             }("");
2114             if (!success) {
2115                 withdrawnDividends[account] -= _withdrawableDividend;
2116                 totalDividendsWithdrawn -= _withdrawableDividend;
2117                 return 0;
2118             }
2119             return _withdrawableDividend;
2120         }
2121         return 0;
2122     }
2123 
2124     function compoundAccount(address payable account)
2125         public
2126         onlyOwner
2127         returns (bool)
2128     {
2129         (uint256 amount, uint256 tokens) = _compoundDividendOfUser(account);
2130         if (amount > 0) {
2131             lastClaimTimes[account] = block.timestamp;
2132             emit Compound(account, amount, tokens);
2133             return true;
2134         }
2135         return false;
2136     }
2137 
2138     function _compoundDividendOfUser(address payable account)
2139         private
2140         returns (uint256, uint256)
2141     {
2142         uint256 _withdrawableDividend = withdrawableDividendOf(account);
2143         if (_withdrawableDividend > 0) {
2144             withdrawnDividends[account] += _withdrawableDividend;
2145             totalDividendsWithdrawn += _withdrawableDividend;
2146             emit DividendWithdrawn(account, _withdrawableDividend);
2147 
2148             IUniswapV2Router02 uniswapV2Router = IUniswapV2Router02(
2149                 UNISWAPROUTER
2150             );
2151 
2152             address[] memory path = new address[](2);
2153             path[0] = uniswapV2Router.WETH();
2154             path[1] = address(tokenAddress);
2155 
2156             bool success;
2157             uint256 tokens;
2158 
2159             uint256 initTokenBal = IERC20(tokenAddress).balanceOf(account);
2160             try
2161                 uniswapV2Router
2162                     .swapExactETHForTokensSupportingFeeOnTransferTokens{
2163                     value: _withdrawableDividend
2164                 }(0, path, address(account), block.timestamp)
2165             {
2166                 success = true;
2167                 tokens = IERC20(tokenAddress).balanceOf(account) - initTokenBal;
2168             } catch Error(
2169                 string memory /*err*/
2170             ) {
2171                 success = false;
2172             }
2173 
2174             if (!success) {
2175                 withdrawnDividends[account] -= _withdrawableDividend;
2176                 totalDividendsWithdrawn -= _withdrawableDividend;
2177                 return (0, 0);
2178             }
2179 
2180             return (_withdrawableDividend, tokens);
2181         }
2182         return (0, 0);
2183     }
2184 
2185     function withdrawableDividendOf(address account)
2186         public
2187         view
2188         returns (uint256)
2189     {
2190         return accumulativeDividendOf(account) - withdrawnDividends[account];
2191     }
2192 
2193     function withdrawnDividendOf(address account)
2194         public
2195         view
2196         returns (uint256)
2197     {
2198         return withdrawnDividends[account];
2199     }
2200 
2201     function accumulativeDividendOf(address account)
2202         public
2203         view
2204         returns (uint256)
2205     {
2206         int256 a = int256(magnifiedDividendPerShare * balanceOf(account));
2207         int256 b = magnifiedDividendCorrections[account]; // this is an explicit int256 (signed)
2208         return uint256(a + b) / magnitude;
2209     }
2210 
2211     function getAccountInfo(address account)
2212         public
2213         view
2214         returns (
2215             address,
2216             uint256,
2217             uint256,
2218             uint256,
2219             uint256
2220         )
2221     {
2222         AccountInfo memory info;
2223         info.account = account;
2224         info.withdrawableDividends = withdrawableDividendOf(account);
2225         info.totalDividends = accumulativeDividendOf(account);
2226         info.lastClaimTime = lastClaimTimes[account];
2227         return (
2228             info.account,
2229             info.withdrawableDividends,
2230             info.totalDividends,
2231             info.lastClaimTime,
2232             totalDividendsWithdrawn
2233         );
2234     }
2235 
2236     function getLastClaimTime(address account) public view returns (uint256) {
2237         return lastClaimTimes[account];
2238     }
2239 
2240     function name() public view returns (string memory) {
2241         return _name;
2242     }
2243 
2244     function symbol() public view returns (string memory) {
2245         return _symbol;
2246     }
2247 
2248     function decimals() public pure returns (uint8) {
2249         return 18;
2250     }
2251 
2252     function totalSupply() public view override returns (uint256) {
2253         return _totalSupply;
2254     }
2255 
2256     function balanceOf(address account) public view override returns (uint256) {
2257         return _balances[account];
2258     }
2259 
2260     function transfer(address, uint256) public pure override returns (bool) {
2261         revert("PiggyBank_DividendTracker: method not implemented");
2262     }
2263 
2264     function allowance(address, address)
2265         public
2266         pure
2267         override
2268         returns (uint256)
2269     {
2270         revert("PiggyBank_DividendTracker: method not implemented");
2271     }
2272 
2273     function approve(address, uint256) public pure override returns (bool) {
2274         revert("PiggyBank_DividendTracker: method not implemented");
2275     }
2276 
2277     function transferFrom(
2278         address,
2279         address,
2280         uint256
2281     ) public pure override returns (bool) {
2282         revert("PiggyBank_DividendTracker: method not implemented");
2283     }
2284 }