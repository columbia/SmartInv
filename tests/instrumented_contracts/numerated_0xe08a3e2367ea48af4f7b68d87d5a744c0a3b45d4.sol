1 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC165 standard, as defined in the
10  * https://eips.ethereum.org/EIPS/eip-165[EIP].
11  *
12  * Implementers can declare support of contract interfaces, which can then be
13  * queried by others ({ERC165Checker}).
14  *
15  * For an implementation, see {ERC165}.
16  */
17 interface IERC165 {
18     /**
19      * @dev Returns true if this contract implements the interface defined by
20      * `interfaceId`. See the corresponding
21      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
22      * to learn more about how these ids are created.
23      *
24      * This function call must use less than 30 000 gas.
25      */
26     function supportsInterface(bytes4 interfaceId) external view returns (bool);
27 }
28 
29 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
30 
31 
32 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
33 
34 pragma solidity ^0.8.0;
35 
36 
37 /**
38  * @dev Required interface of an ERC721 compliant contract.
39  */
40 interface IERC721 is IERC165 {
41     /**
42      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
43      */
44     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
45 
46     /**
47      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
48      */
49     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
50 
51     /**
52      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
53      */
54     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
55 
56     /**
57      * @dev Returns the number of tokens in ``owner``'s account.
58      */
59     function balanceOf(address owner) external view returns (uint256 balance);
60 
61     /**
62      * @dev Returns the owner of the `tokenId` token.
63      *
64      * Requirements:
65      *
66      * - `tokenId` must exist.
67      */
68     function ownerOf(uint256 tokenId) external view returns (address owner);
69 
70     /**
71      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
72      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
73      *
74      * Requirements:
75      *
76      * - `from` cannot be the zero address.
77      * - `to` cannot be the zero address.
78      * - `tokenId` token must exist and be owned by `from`.
79      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
80      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
81      *
82      * Emits a {Transfer} event.
83      */
84     function safeTransferFrom(
85         address from,
86         address to,
87         uint256 tokenId
88     ) external;
89 
90     /**
91      * @dev Transfers `tokenId` token from `from` to `to`.
92      *
93      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
94      *
95      * Requirements:
96      *
97      * - `from` cannot be the zero address.
98      * - `to` cannot be the zero address.
99      * - `tokenId` token must be owned by `from`.
100      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
101      *
102      * Emits a {Transfer} event.
103      */
104     function transferFrom(
105         address from,
106         address to,
107         uint256 tokenId
108     ) external;
109 
110     /**
111      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
112      * The approval is cleared when the token is transferred.
113      *
114      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
115      *
116      * Requirements:
117      *
118      * - The caller must own the token or be an approved operator.
119      * - `tokenId` must exist.
120      *
121      * Emits an {Approval} event.
122      */
123     function approve(address to, uint256 tokenId) external;
124 
125     /**
126      * @dev Returns the account approved for `tokenId` token.
127      *
128      * Requirements:
129      *
130      * - `tokenId` must exist.
131      */
132     function getApproved(uint256 tokenId) external view returns (address operator);
133 
134     /**
135      * @dev Approve or remove `operator` as an operator for the caller.
136      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
137      *
138      * Requirements:
139      *
140      * - The `operator` cannot be the caller.
141      *
142      * Emits an {ApprovalForAll} event.
143      */
144     function setApprovalForAll(address operator, bool _approved) external;
145 
146     /**
147      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
148      *
149      * See {setApprovalForAll}
150      */
151     function isApprovedForAll(address owner, address operator) external view returns (bool);
152 
153     /**
154      * @dev Safely transfers `tokenId` token from `from` to `to`.
155      *
156      * Requirements:
157      *
158      * - `from` cannot be the zero address.
159      * - `to` cannot be the zero address.
160      * - `tokenId` token must exist and be owned by `from`.
161      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
162      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
163      *
164      * Emits a {Transfer} event.
165      */
166     function safeTransferFrom(
167         address from,
168         address to,
169         uint256 tokenId,
170         bytes calldata data
171     ) external;
172 }
173 
174 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
175 
176 
177 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC721/extensions/IERC721Enumerable.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 
182 /**
183  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
184  * @dev See https://eips.ethereum.org/EIPS/eip-721
185  */
186 interface IERC721Enumerable is IERC721 {
187     /**
188      * @dev Returns the total amount of tokens stored by the contract.
189      */
190     function totalSupply() external view returns (uint256);
191 
192     /**
193      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
194      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
195      */
196     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256);
197 
198     /**
199      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
200      * Use along with {totalSupply} to enumerate all tokens.
201      */
202     function tokenByIndex(uint256 index) external view returns (uint256);
203 }
204 
205 // File: @openzeppelin/contracts/utils/Context.sol
206 
207 
208 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
209 
210 pragma solidity ^0.8.0;
211 
212 /**
213  * @dev Provides information about the current execution context, including the
214  * sender of the transaction and its data. While these are generally available
215  * via msg.sender and msg.data, they should not be accessed in such a direct
216  * manner, since when dealing with meta-transactions the account sending and
217  * paying for execution may not be the actual sender (as far as an application
218  * is concerned).
219  *
220  * This contract is only required for intermediate, library-like contracts.
221  */
222 abstract contract Context {
223     function _msgSender() internal view virtual returns (address) {
224         return msg.sender;
225     }
226 
227     function _msgData() internal view virtual returns (bytes calldata) {
228         return msg.data;
229     }
230 }
231 
232 // File: @openzeppelin/contracts/access/Ownable.sol
233 
234 
235 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
236 
237 pragma solidity ^0.8.0;
238 
239 
240 /**
241  * @dev Contract module which provides a basic access control mechanism, where
242  * there is an account (an owner) that can be granted exclusive access to
243  * specific functions.
244  *
245  * By default, the owner account will be the one that deploys the contract. This
246  * can later be changed with {transferOwnership}.
247  *
248  * This module is used through inheritance. It will make available the modifier
249  * `onlyOwner`, which can be applied to your functions to restrict their use to
250  * the owner.
251  */
252 abstract contract Ownable is Context {
253     address private _owner;
254 
255     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
256 
257     /**
258      * @dev Initializes the contract setting the deployer as the initial owner.
259      */
260     constructor() {
261         _transferOwnership(_msgSender());
262     }
263 
264     /**
265      * @dev Returns the address of the current owner.
266      */
267     function owner() public view virtual returns (address) {
268         return _owner;
269     }
270 
271     /**
272      * @dev Throws if called by any account other than the owner.
273      */
274     modifier onlyOwner() {
275         require(owner() == _msgSender(), "Ownable: caller is not the owner");
276         _;
277     }
278 
279     /**
280      * @dev Leaves the contract without owner. It will not be possible to call
281      * `onlyOwner` functions anymore. Can only be called by the current owner.
282      *
283      * NOTE: Renouncing ownership will leave the contract without an owner,
284      * thereby removing any functionality that is only available to the owner.
285      */
286     function renounceOwnership() public virtual onlyOwner {
287         _transferOwnership(address(0));
288     }
289 
290     /**
291      * @dev Transfers ownership of the contract to a new account (`newOwner`).
292      * Can only be called by the current owner.
293      */
294     function transferOwnership(address newOwner) public virtual onlyOwner {
295         require(newOwner != address(0), "Ownable: new owner is the zero address");
296         _transferOwnership(newOwner);
297     }
298 
299     /**
300      * @dev Transfers ownership of the contract to a new account (`newOwner`).
301      * Internal function without access restriction.
302      */
303     function _transferOwnership(address newOwner) internal virtual {
304         address oldOwner = _owner;
305         _owner = newOwner;
306         emit OwnershipTransferred(oldOwner, newOwner);
307     }
308 }
309 
310 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
311 
312 
313 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
314 
315 pragma solidity ^0.8.0;
316 
317 /**
318  * @dev Interface of the ERC20 standard as defined in the EIP.
319  */
320 interface IERC20 {
321     /**
322      * @dev Returns the amount of tokens in existence.
323      */
324     function totalSupply() external view returns (uint256);
325 
326     /**
327      * @dev Returns the amount of tokens owned by `account`.
328      */
329     function balanceOf(address account) external view returns (uint256);
330 
331     /**
332      * @dev Moves `amount` tokens from the caller's account to `to`.
333      *
334      * Returns a boolean value indicating whether the operation succeeded.
335      *
336      * Emits a {Transfer} event.
337      */
338     function transfer(address to, uint256 amount) external returns (bool);
339 
340     /**
341      * @dev Returns the remaining number of tokens that `spender` will be
342      * allowed to spend on behalf of `owner` through {transferFrom}. This is
343      * zero by default.
344      *
345      * This value changes when {approve} or {transferFrom} are called.
346      */
347     function allowance(address owner, address spender) external view returns (uint256);
348 
349     /**
350      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
351      *
352      * Returns a boolean value indicating whether the operation succeeded.
353      *
354      * IMPORTANT: Beware that changing an allowance with this method brings the risk
355      * that someone may use both the old and the new allowance by unfortunate
356      * transaction ordering. One possible solution to mitigate this race
357      * condition is to first reduce the spender's allowance to 0 and set the
358      * desired value afterwards:
359      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
360      *
361      * Emits an {Approval} event.
362      */
363     function approve(address spender, uint256 amount) external returns (bool);
364 
365     /**
366      * @dev Moves `amount` tokens from `from` to `to` using the
367      * allowance mechanism. `amount` is then deducted from the caller's
368      * allowance.
369      *
370      * Returns a boolean value indicating whether the operation succeeded.
371      *
372      * Emits a {Transfer} event.
373      */
374     function transferFrom(
375         address from,
376         address to,
377         uint256 amount
378     ) external returns (bool);
379 
380     /**
381      * @dev Emitted when `value` tokens are moved from one account (`from`) to
382      * another (`to`).
383      *
384      * Note that `value` may be zero.
385      */
386     event Transfer(address indexed from, address indexed to, uint256 value);
387 
388     /**
389      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
390      * a call to {approve}. `value` is the new allowance.
391      */
392     event Approval(address indexed owner, address indexed spender, uint256 value);
393 }
394 
395 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
396 
397 
398 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
399 
400 pragma solidity ^0.8.0;
401 
402 
403 /**
404  * @dev Interface for the optional metadata functions from the ERC20 standard.
405  *
406  * _Available since v4.1._
407  */
408 interface IERC20Metadata is IERC20 {
409     /**
410      * @dev Returns the name of the token.
411      */
412     function name() external view returns (string memory);
413 
414     /**
415      * @dev Returns the symbol of the token.
416      */
417     function symbol() external view returns (string memory);
418 
419     /**
420      * @dev Returns the decimals places of the token.
421      */
422     function decimals() external view returns (uint8);
423 }
424 
425 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
426 
427 
428 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
429 
430 pragma solidity ^0.8.0;
431 
432 
433 
434 
435 /**
436  * @dev Implementation of the {IERC20} interface.
437  *
438  * This implementation is agnostic to the way tokens are created. This means
439  * that a supply mechanism has to be added in a derived contract using {_mint}.
440  * For a generic mechanism see {ERC20PresetMinterPauser}.
441  *
442  * TIP: For a detailed writeup see our guide
443  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
444  * to implement supply mechanisms].
445  *
446  * We have followed general OpenZeppelin Contracts guidelines: functions revert
447  * instead returning `false` on failure. This behavior is nonetheless
448  * conventional and does not conflict with the expectations of ERC20
449  * applications.
450  *
451  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
452  * This allows applications to reconstruct the allowance for all accounts just
453  * by listening to said events. Other implementations of the EIP may not emit
454  * these events, as it isn't required by the specification.
455  *
456  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
457  * functions have been added to mitigate the well-known issues around setting
458  * allowances. See {IERC20-approve}.
459  */
460 contract ERC20 is Context, IERC20, IERC20Metadata {
461     mapping(address => uint256) private _balances;
462 
463     mapping(address => mapping(address => uint256)) private _allowances;
464 
465     uint256 private _totalSupply;
466 
467     string private _name;
468     string private _symbol;
469 
470     /**
471      * @dev Sets the values for {name} and {symbol}.
472      *
473      * The default value of {decimals} is 18. To select a different value for
474      * {decimals} you should overload it.
475      *
476      * All two of these values are immutable: they can only be set once during
477      * construction.
478      */
479     constructor(string memory name_, string memory symbol_) {
480         _name = name_;
481         _symbol = symbol_;
482     }
483 
484     /**
485      * @dev Returns the name of the token.
486      */
487     function name() public view virtual override returns (string memory) {
488         return _name;
489     }
490 
491     /**
492      * @dev Returns the symbol of the token, usually a shorter version of the
493      * name.
494      */
495     function symbol() public view virtual override returns (string memory) {
496         return _symbol;
497     }
498 
499     /**
500      * @dev Returns the number of decimals used to get its user representation.
501      * For example, if `decimals` equals `2`, a balance of `505` tokens should
502      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
503      *
504      * Tokens usually opt for a value of 18, imitating the relationship between
505      * Ether and Wei. This is the value {ERC20} uses, unless this function is
506      * overridden;
507      *
508      * NOTE: This information is only used for _display_ purposes: it in
509      * no way affects any of the arithmetic of the contract, including
510      * {IERC20-balanceOf} and {IERC20-transfer}.
511      */
512     function decimals() public view virtual override returns (uint8) {
513         return 18;
514     }
515 
516     /**
517      * @dev See {IERC20-totalSupply}.
518      */
519     function totalSupply() public view virtual override returns (uint256) {
520         return _totalSupply;
521     }
522 
523     /**
524      * @dev See {IERC20-balanceOf}.
525      */
526     function balanceOf(address account) public view virtual override returns (uint256) {
527         return _balances[account];
528     }
529 
530     /**
531      * @dev See {IERC20-transfer}.
532      *
533      * Requirements:
534      *
535      * - `to` cannot be the zero address.
536      * - the caller must have a balance of at least `amount`.
537      */
538     function transfer(address to, uint256 amount) public virtual override returns (bool) {
539         address owner = _msgSender();
540         _transfer(owner, to, amount);
541         return true;
542     }
543 
544     /**
545      * @dev See {IERC20-allowance}.
546      */
547     function allowance(address owner, address spender) public view virtual override returns (uint256) {
548         return _allowances[owner][spender];
549     }
550 
551     /**
552      * @dev See {IERC20-approve}.
553      *
554      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
555      * `transferFrom`. This is semantically equivalent to an infinite approval.
556      *
557      * Requirements:
558      *
559      * - `spender` cannot be the zero address.
560      */
561     function approve(address spender, uint256 amount) public virtual override returns (bool) {
562         address owner = _msgSender();
563         _approve(owner, spender, amount);
564         return true;
565     }
566 
567     /**
568      * @dev See {IERC20-transferFrom}.
569      *
570      * Emits an {Approval} event indicating the updated allowance. This is not
571      * required by the EIP. See the note at the beginning of {ERC20}.
572      *
573      * NOTE: Does not update the allowance if the current allowance
574      * is the maximum `uint256`.
575      *
576      * Requirements:
577      *
578      * - `from` and `to` cannot be the zero address.
579      * - `from` must have a balance of at least `amount`.
580      * - the caller must have allowance for ``from``'s tokens of at least
581      * `amount`.
582      */
583     function transferFrom(
584         address from,
585         address to,
586         uint256 amount
587     ) public virtual override returns (bool) {
588         address spender = _msgSender();
589         _spendAllowance(from, spender, amount);
590         _transfer(from, to, amount);
591         return true;
592     }
593 
594     /**
595      * @dev Atomically increases the allowance granted to `spender` by the caller.
596      *
597      * This is an alternative to {approve} that can be used as a mitigation for
598      * problems described in {IERC20-approve}.
599      *
600      * Emits an {Approval} event indicating the updated allowance.
601      *
602      * Requirements:
603      *
604      * - `spender` cannot be the zero address.
605      */
606     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
607         address owner = _msgSender();
608         _approve(owner, spender, _allowances[owner][spender] + addedValue);
609         return true;
610     }
611 
612     /**
613      * @dev Atomically decreases the allowance granted to `spender` by the caller.
614      *
615      * This is an alternative to {approve} that can be used as a mitigation for
616      * problems described in {IERC20-approve}.
617      *
618      * Emits an {Approval} event indicating the updated allowance.
619      *
620      * Requirements:
621      *
622      * - `spender` cannot be the zero address.
623      * - `spender` must have allowance for the caller of at least
624      * `subtractedValue`.
625      */
626     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
627         address owner = _msgSender();
628         uint256 currentAllowance = _allowances[owner][spender];
629         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
630         unchecked {
631             _approve(owner, spender, currentAllowance - subtractedValue);
632         }
633 
634         return true;
635     }
636 
637     /**
638      * @dev Moves `amount` of tokens from `sender` to `recipient`.
639      *
640      * This internal function is equivalent to {transfer}, and can be used to
641      * e.g. implement automatic token fees, slashing mechanisms, etc.
642      *
643      * Emits a {Transfer} event.
644      *
645      * Requirements:
646      *
647      * - `from` cannot be the zero address.
648      * - `to` cannot be the zero address.
649      * - `from` must have a balance of at least `amount`.
650      */
651     function _transfer(
652         address from,
653         address to,
654         uint256 amount
655     ) internal virtual {
656         require(from != address(0), "ERC20: transfer from the zero address");
657         require(to != address(0), "ERC20: transfer to the zero address");
658 
659         _beforeTokenTransfer(from, to, amount);
660 
661         uint256 fromBalance = _balances[from];
662         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
663         unchecked {
664             _balances[from] = fromBalance - amount;
665         }
666         _balances[to] += amount;
667 
668         emit Transfer(from, to, amount);
669 
670         _afterTokenTransfer(from, to, amount);
671     }
672 
673     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
674      * the total supply.
675      *
676      * Emits a {Transfer} event with `from` set to the zero address.
677      *
678      * Requirements:
679      *
680      * - `account` cannot be the zero address.
681      */
682     function _mint(address account, uint256 amount) internal virtual {
683         require(account != address(0), "ERC20: mint to the zero address");
684 
685         _beforeTokenTransfer(address(0), account, amount);
686 
687         _totalSupply += amount;
688         _balances[account] += amount;
689         emit Transfer(address(0), account, amount);
690 
691         _afterTokenTransfer(address(0), account, amount);
692     }
693 
694     /**
695      * @dev Destroys `amount` tokens from `account`, reducing the
696      * total supply.
697      *
698      * Emits a {Transfer} event with `to` set to the zero address.
699      *
700      * Requirements:
701      *
702      * - `account` cannot be the zero address.
703      * - `account` must have at least `amount` tokens.
704      */
705     function _burn(address account, uint256 amount) internal virtual {
706         require(account != address(0), "ERC20: burn from the zero address");
707 
708         _beforeTokenTransfer(account, address(0), amount);
709 
710         uint256 accountBalance = _balances[account];
711         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
712         unchecked {
713             _balances[account] = accountBalance - amount;
714         }
715         _totalSupply -= amount;
716 
717         emit Transfer(account, address(0), amount);
718 
719         _afterTokenTransfer(account, address(0), amount);
720     }
721 
722     /**
723      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
724      *
725      * This internal function is equivalent to `approve`, and can be used to
726      * e.g. set automatic allowances for certain subsystems, etc.
727      *
728      * Emits an {Approval} event.
729      *
730      * Requirements:
731      *
732      * - `owner` cannot be the zero address.
733      * - `spender` cannot be the zero address.
734      */
735     function _approve(
736         address owner,
737         address spender,
738         uint256 amount
739     ) internal virtual {
740         require(owner != address(0), "ERC20: approve from the zero address");
741         require(spender != address(0), "ERC20: approve to the zero address");
742 
743         _allowances[owner][spender] = amount;
744         emit Approval(owner, spender, amount);
745     }
746 
747     /**
748      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
749      *
750      * Does not update the allowance amount in case of infinite allowance.
751      * Revert if not enough allowance is available.
752      *
753      * Might emit an {Approval} event.
754      */
755     function _spendAllowance(
756         address owner,
757         address spender,
758         uint256 amount
759     ) internal virtual {
760         uint256 currentAllowance = allowance(owner, spender);
761         if (currentAllowance != type(uint256).max) {
762             require(currentAllowance >= amount, "ERC20: insufficient allowance");
763             unchecked {
764                 _approve(owner, spender, currentAllowance - amount);
765             }
766         }
767     }
768 
769     /**
770      * @dev Hook that is called before any transfer of tokens. This includes
771      * minting and burning.
772      *
773      * Calling conditions:
774      *
775      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
776      * will be transferred to `to`.
777      * - when `from` is zero, `amount` tokens will be minted for `to`.
778      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
779      * - `from` and `to` are never both zero.
780      *
781      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
782      */
783     function _beforeTokenTransfer(
784         address from,
785         address to,
786         uint256 amount
787     ) internal virtual {}
788 
789     /**
790      * @dev Hook that is called after any transfer of tokens. This includes
791      * minting and burning.
792      *
793      * Calling conditions:
794      *
795      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
796      * has been transferred to `to`.
797      * - when `from` is zero, `amount` tokens have been minted for `to`.
798      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
799      * - `from` and `to` are never both zero.
800      *
801      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
802      */
803     function _afterTokenTransfer(
804         address from,
805         address to,
806         uint256 amount
807     ) internal virtual {}
808 }
809 
810 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
811 
812 
813 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
814 
815 pragma solidity ^0.8.0;
816 
817 
818 
819 /**
820  * @dev Extension of {ERC20} that allows token holders to destroy both their own
821  * tokens and those that they have an allowance for, in a way that can be
822  * recognized off-chain (via event analysis).
823  */
824 abstract contract ERC20Burnable is Context, ERC20 {
825     /**
826      * @dev Destroys `amount` tokens from the caller.
827      *
828      * See {ERC20-_burn}.
829      */
830     function burn(uint256 amount) public virtual {
831         _burn(_msgSender(), amount);
832     }
833 
834     /**
835      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
836      * allowance.
837      *
838      * See {ERC20-_burn} and {ERC20-allowance}.
839      *
840      * Requirements:
841      *
842      * - the caller must have allowance for ``accounts``'s tokens of at least
843      * `amount`.
844      */
845     function burnFrom(address account, uint256 amount) public virtual {
846         _spendAllowance(account, _msgSender(), amount);
847         _burn(account, amount);
848     }
849 }
850 
851 // File: contracts/WCAToken.sol
852 
853 //SPDX-License-Identifier: MIT
854 pragma solidity ^0.8.13;
855 
856 
857 
858 
859 contract WorldCupApesToken is ERC20Burnable, Ownable {
860     uint256 public constant maxWalletStaked = 30;
861     uint256 public constant emissionRate = 462962962962960; // 11574074074074 * 40
862     uint256 public endTimestamp = 1659312000;
863     uint256 public startUnstakeTimestamp = 1654041600;
864     address public WCAAddress;
865     bool private _stakingLive = false;
866 
867     mapping(uint256 => uint256) internal tokenIdTimeStaked;
868     mapping(uint256 => address) internal tokenIdToStaker;
869     mapping(address => uint256[]) internal stakerToTokenIds;
870     
871     IERC721Enumerable private WCAIERC721;
872 
873     constructor(address _WCAAddress) ERC20("World Cup Apes", "WCA") {
874         _mint(msg.sender, 100000000*10**18);
875         WCAAddress = _WCAAddress;
876         WCAIERC721 = IERC721Enumerable(WCAAddress);
877     }
878 
879     modifier stakingEnabled {
880         require(_stakingLive && block.timestamp < endTimestamp, "Staking not live");
881         _;
882     }
883 
884     function setEndTimestamp(uint256 timestamp) external onlyOwner {
885         endTimestamp = timestamp;
886     }
887 
888     function setStartUnstakeTimestamp(uint256 timestamp) external onlyOwner {
889         startUnstakeTimestamp = timestamp;
890     }
891 
892     function getStaked(address staker) public view returns (uint256[] memory) {
893         return stakerToTokenIds[staker];
894     }
895     
896     function getStakedCount(address staker) public view returns (uint256) {
897         return stakerToTokenIds[staker].length;
898     }
899 
900     function removeTokenIdFromArray(uint256[] storage array, uint256 tokenId) internal {
901         uint256 length = array.length;
902         for (uint256 i = 0; i < length; i++) {
903             if (array[i] == tokenId) {
904                 length--;
905                 if (i < length) {
906                     array[i] = array[length];
907                 }
908                 array.pop();
909                 break;
910             }
911         }
912     }
913 
914     function stakeByIds(uint256[] memory tokenIds) public stakingEnabled {
915         require(getStakedCount(msg.sender) + tokenIds.length <= maxWalletStaked, "You have reached the maximum number of NFTs in stake");
916 
917         for (uint256 i = 0; i < tokenIds.length; i++) {
918             uint256 id = tokenIds[i];
919             require(WCAIERC721.ownerOf(id) == msg.sender && tokenIdToStaker[id] == address(0), "NFT is not yours");
920             WCAIERC721.transferFrom(msg.sender, address(this), id);
921 
922             stakerToTokenIds[msg.sender].push(id);
923             tokenIdTimeStaked[id] = block.timestamp;
924             tokenIdToStaker[id] = msg.sender;
925         }
926     }
927 
928     function unstakeAll() public {
929         require(getStakedCount(msg.sender) > 0, "No NFTs in stake");
930         require(block.timestamp >= startUnstakeTimestamp, "You can't already unstake NFTs");
931         uint256 totalRewards = 0;
932 
933         for (uint256 i = stakerToTokenIds[msg.sender].length; i > 0; i--) {
934             uint256 tokenId = stakerToTokenIds[msg.sender][i - 1];
935 
936             WCAIERC721.transferFrom(address(this), msg.sender, tokenId);
937 
938             uint256 timestamp = block.timestamp;
939             if(timestamp > endTimestamp){
940                 timestamp = endTimestamp;
941             }
942             totalRewards += ((timestamp - tokenIdTimeStaked[tokenId]) * emissionRate);
943             stakerToTokenIds[msg.sender].pop();
944             tokenIdToStaker[tokenId] = address(0);
945         }
946 
947         _transfer(owner(), msg.sender, totalRewards);
948     }
949 
950     function unstakeByIds(uint256[] memory tokenIds) public {
951         require(block.timestamp >= startUnstakeTimestamp, "You can't already unstake NFTs");
952         uint256 totalRewards = 0;
953         
954         for (uint256 i = 0; i < tokenIds.length; i++) {
955             uint256 id = tokenIds[i];
956             require(tokenIdToStaker[id] == msg.sender, "Not in stake");
957 
958             WCAIERC721.transferFrom(address(this), msg.sender, id);
959             uint256 timestamp = block.timestamp;
960             if(timestamp > endTimestamp){
961                 timestamp = endTimestamp;
962             }
963             totalRewards += ((timestamp - tokenIdTimeStaked[id]) * emissionRate);
964 
965             removeTokenIdFromArray(stakerToTokenIds[msg.sender], id);
966             tokenIdToStaker[id] = address(0);
967         }
968 
969         _transfer(owner(), msg.sender, totalRewards);
970     }
971 
972     function claimByTokenId(uint256 tokenId) public {
973         require(tokenIdToStaker[tokenId] == msg.sender, "Not staked by you");
974         require(block.timestamp >= startUnstakeTimestamp, "You can't already claim your rewards");
975         uint256 timestamp = block.timestamp;
976         if(timestamp > endTimestamp){
977             timestamp = endTimestamp;
978         }
979         uint256 totalRewards = ((timestamp - tokenIdTimeStaked[tokenId]) * emissionRate);
980         tokenIdTimeStaked[tokenId] = timestamp;
981         _transfer(owner(), msg.sender, totalRewards);
982     }
983 
984     function claimAll() public {
985         require(block.timestamp >= startUnstakeTimestamp, "You can't already claim your rewards");
986         uint256 totalRewards = 0;
987 
988         uint256[] memory tokenIds = stakerToTokenIds[msg.sender];
989         for (uint256 i = 0; i < tokenIds.length; i++) {
990             uint256 id = tokenIds[i];
991             require(tokenIdToStaker[id] == msg.sender, "Not staked by you");
992             uint256 timestamp = block.timestamp;
993             if(timestamp > endTimestamp){
994                 timestamp = endTimestamp;
995             }
996             totalRewards += ((timestamp - tokenIdTimeStaked[id]) * emissionRate);
997             tokenIdTimeStaked[id] = timestamp;
998         }
999 
1000         _transfer(owner(), msg.sender, totalRewards);
1001     }
1002 
1003     function getAllRewards(address staker) public view returns (uint256) {
1004         uint256 totalRewards = 0;
1005 
1006         uint256[] memory tokenIds = stakerToTokenIds[staker];
1007         for (uint256 i = 0; i < tokenIds.length; i++) {
1008             uint256 timestamp = block.timestamp;
1009             if(timestamp > endTimestamp){
1010                 timestamp = endTimestamp;
1011             }
1012             totalRewards += ((timestamp - tokenIdTimeStaked[tokenIds[i]]) * emissionRate);
1013         }
1014 
1015         return totalRewards;
1016     }
1017 
1018     function getRewardsByTokenId(uint256 tokenId) public view returns (uint256) {
1019         require(tokenIdToStaker[tokenId] != address(0), "NFT is not in stake");
1020 
1021         uint256 timestamp = block.timestamp;
1022         if(timestamp > endTimestamp){
1023             timestamp = endTimestamp;
1024         }
1025         uint256 secondsStaked = timestamp - tokenIdTimeStaked[tokenId];
1026         return secondsStaked * emissionRate;
1027     }
1028 
1029     function getStaker(uint256 tokenId) public view returns (address) {
1030         return tokenIdToStaker[tokenId];
1031     }
1032 
1033     function toggleStakingLive() external onlyOwner {
1034         _stakingLive = !_stakingLive;
1035     }
1036 
1037     function stakingLive() public view returns (bool){
1038         return _stakingLive && block.timestamp < endTimestamp;
1039     }
1040 }