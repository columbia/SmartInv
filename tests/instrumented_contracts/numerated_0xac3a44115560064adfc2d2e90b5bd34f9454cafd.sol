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
177 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
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
196     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
197 
198     /**
199      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
200      * Use along with {totalSupply} to enumerate all tokens.
201      */
202     function tokenByIndex(uint256 index) external view returns (uint256);
203 }
204 
205 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
206 
207 
208 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
209 
210 pragma solidity ^0.8.0;
211 
212 /**
213  * @dev Interface of the ERC20 standard as defined in the EIP.
214  */
215 interface IERC20 {
216     /**
217      * @dev Returns the amount of tokens in existence.
218      */
219     function totalSupply() external view returns (uint256);
220 
221     /**
222      * @dev Returns the amount of tokens owned by `account`.
223      */
224     function balanceOf(address account) external view returns (uint256);
225 
226     /**
227      * @dev Moves `amount` tokens from the caller's account to `recipient`.
228      *
229      * Returns a boolean value indicating whether the operation succeeded.
230      *
231      * Emits a {Transfer} event.
232      */
233     function transfer(address recipient, uint256 amount) external returns (bool);
234 
235     /**
236      * @dev Returns the remaining number of tokens that `spender` will be
237      * allowed to spend on behalf of `owner` through {transferFrom}. This is
238      * zero by default.
239      *
240      * This value changes when {approve} or {transferFrom} are called.
241      */
242     function allowance(address owner, address spender) external view returns (uint256);
243 
244     /**
245      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
246      *
247      * Returns a boolean value indicating whether the operation succeeded.
248      *
249      * IMPORTANT: Beware that changing an allowance with this method brings the risk
250      * that someone may use both the old and the new allowance by unfortunate
251      * transaction ordering. One possible solution to mitigate this race
252      * condition is to first reduce the spender's allowance to 0 and set the
253      * desired value afterwards:
254      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
255      *
256      * Emits an {Approval} event.
257      */
258     function approve(address spender, uint256 amount) external returns (bool);
259 
260     /**
261      * @dev Moves `amount` tokens from `sender` to `recipient` using the
262      * allowance mechanism. `amount` is then deducted from the caller's
263      * allowance.
264      *
265      * Returns a boolean value indicating whether the operation succeeded.
266      *
267      * Emits a {Transfer} event.
268      */
269     function transferFrom(
270         address sender,
271         address recipient,
272         uint256 amount
273     ) external returns (bool);
274 
275     /**
276      * @dev Emitted when `value` tokens are moved from one account (`from`) to
277      * another (`to`).
278      *
279      * Note that `value` may be zero.
280      */
281     event Transfer(address indexed from, address indexed to, uint256 value);
282 
283     /**
284      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
285      * a call to {approve}. `value` is the new allowance.
286      */
287     event Approval(address indexed owner, address indexed spender, uint256 value);
288 }
289 
290 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
291 
292 
293 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
294 
295 pragma solidity ^0.8.0;
296 
297 
298 /**
299  * @dev Interface for the optional metadata functions from the ERC20 standard.
300  *
301  * _Available since v4.1._
302  */
303 interface IERC20Metadata is IERC20 {
304     /**
305      * @dev Returns the name of the token.
306      */
307     function name() external view returns (string memory);
308 
309     /**
310      * @dev Returns the symbol of the token.
311      */
312     function symbol() external view returns (string memory);
313 
314     /**
315      * @dev Returns the decimals places of the token.
316      */
317     function decimals() external view returns (uint8);
318 }
319 
320 // File: @openzeppelin/contracts/utils/Context.sol
321 
322 
323 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
324 
325 pragma solidity ^0.8.0;
326 
327 /**
328  * @dev Provides information about the current execution context, including the
329  * sender of the transaction and its data. While these are generally available
330  * via msg.sender and msg.data, they should not be accessed in such a direct
331  * manner, since when dealing with meta-transactions the account sending and
332  * paying for execution may not be the actual sender (as far as an application
333  * is concerned).
334  *
335  * This contract is only required for intermediate, library-like contracts.
336  */
337 abstract contract Context {
338     function _msgSender() internal view virtual returns (address) {
339         return msg.sender;
340     }
341 
342     function _msgData() internal view virtual returns (bytes calldata) {
343         return msg.data;
344     }
345 }
346 
347 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
348 
349 
350 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
351 
352 pragma solidity ^0.8.0;
353 
354 
355 
356 
357 /**
358  * @dev Implementation of the {IERC20} interface.
359  *
360  * This implementation is agnostic to the way tokens are created. This means
361  * that a supply mechanism has to be added in a derived contract using {_mint}.
362  * For a generic mechanism see {ERC20PresetMinterPauser}.
363  *
364  * TIP: For a detailed writeup see our guide
365  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
366  * to implement supply mechanisms].
367  *
368  * We have followed general OpenZeppelin Contracts guidelines: functions revert
369  * instead returning `false` on failure. This behavior is nonetheless
370  * conventional and does not conflict with the expectations of ERC20
371  * applications.
372  *
373  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
374  * This allows applications to reconstruct the allowance for all accounts just
375  * by listening to said events. Other implementations of the EIP may not emit
376  * these events, as it isn't required by the specification.
377  *
378  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
379  * functions have been added to mitigate the well-known issues around setting
380  * allowances. See {IERC20-approve}.
381  */
382 contract ERC20 is Context, IERC20, IERC20Metadata {
383     mapping(address => uint256) private _balances;
384 
385     mapping(address => mapping(address => uint256)) private _allowances;
386 
387     uint256 private _totalSupply;
388 
389     string private _name;
390     string private _symbol;
391 
392     /**
393      * @dev Sets the values for {name} and {symbol}.
394      *
395      * The default value of {decimals} is 18. To select a different value for
396      * {decimals} you should overload it.
397      *
398      * All two of these values are immutable: they can only be set once during
399      * construction.
400      */
401     constructor(string memory name_, string memory symbol_) {
402         _name = name_;
403         _symbol = symbol_;
404     }
405 
406     /**
407      * @dev Returns the name of the token.
408      */
409     function name() public view virtual override returns (string memory) {
410         return _name;
411     }
412 
413     /**
414      * @dev Returns the symbol of the token, usually a shorter version of the
415      * name.
416      */
417     function symbol() public view virtual override returns (string memory) {
418         return _symbol;
419     }
420 
421     /**
422      * @dev Returns the number of decimals used to get its user representation.
423      * For example, if `decimals` equals `2`, a balance of `505` tokens should
424      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
425      *
426      * Tokens usually opt for a value of 18, imitating the relationship between
427      * Ether and Wei. This is the value {ERC20} uses, unless this function is
428      * overridden;
429      *
430      * NOTE: This information is only used for _display_ purposes: it in
431      * no way affects any of the arithmetic of the contract, including
432      * {IERC20-balanceOf} and {IERC20-transfer}.
433      */
434     function decimals() public view virtual override returns (uint8) {
435         return 18;
436     }
437 
438     /**
439      * @dev See {IERC20-totalSupply}.
440      */
441     function totalSupply() public view virtual override returns (uint256) {
442         return _totalSupply;
443     }
444 
445     /**
446      * @dev See {IERC20-balanceOf}.
447      */
448     function balanceOf(address account) public view virtual override returns (uint256) {
449         return _balances[account];
450     }
451 
452     /**
453      * @dev See {IERC20-transfer}.
454      *
455      * Requirements:
456      *
457      * - `recipient` cannot be the zero address.
458      * - the caller must have a balance of at least `amount`.
459      */
460     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
461         _transfer(_msgSender(), recipient, amount);
462         return true;
463     }
464 
465     /**
466      * @dev See {IERC20-allowance}.
467      */
468     function allowance(address owner, address spender) public view virtual override returns (uint256) {
469         return _allowances[owner][spender];
470     }
471 
472     /**
473      * @dev See {IERC20-approve}.
474      *
475      * Requirements:
476      *
477      * - `spender` cannot be the zero address.
478      */
479     function approve(address spender, uint256 amount) public virtual override returns (bool) {
480         _approve(_msgSender(), spender, amount);
481         return true;
482     }
483 
484     /**
485      * @dev See {IERC20-transferFrom}.
486      *
487      * Emits an {Approval} event indicating the updated allowance. This is not
488      * required by the EIP. See the note at the beginning of {ERC20}.
489      *
490      * Requirements:
491      *
492      * - `sender` and `recipient` cannot be the zero address.
493      * - `sender` must have a balance of at least `amount`.
494      * - the caller must have allowance for ``sender``'s tokens of at least
495      * `amount`.
496      */
497     function transferFrom(
498         address sender,
499         address recipient,
500         uint256 amount
501     ) public virtual override returns (bool) {
502         _transfer(sender, recipient, amount);
503 
504         uint256 currentAllowance = _allowances[sender][_msgSender()];
505         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
506         unchecked {
507             _approve(sender, _msgSender(), currentAllowance - amount);
508         }
509 
510         return true;
511     }
512 
513     /**
514      * @dev Atomically increases the allowance granted to `spender` by the caller.
515      *
516      * This is an alternative to {approve} that can be used as a mitigation for
517      * problems described in {IERC20-approve}.
518      *
519      * Emits an {Approval} event indicating the updated allowance.
520      *
521      * Requirements:
522      *
523      * - `spender` cannot be the zero address.
524      */
525     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
526         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
527         return true;
528     }
529 
530     /**
531      * @dev Atomically decreases the allowance granted to `spender` by the caller.
532      *
533      * This is an alternative to {approve} that can be used as a mitigation for
534      * problems described in {IERC20-approve}.
535      *
536      * Emits an {Approval} event indicating the updated allowance.
537      *
538      * Requirements:
539      *
540      * - `spender` cannot be the zero address.
541      * - `spender` must have allowance for the caller of at least
542      * `subtractedValue`.
543      */
544     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
545         uint256 currentAllowance = _allowances[_msgSender()][spender];
546         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
547         unchecked {
548             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
549         }
550 
551         return true;
552     }
553 
554     /**
555      * @dev Moves `amount` of tokens from `sender` to `recipient`.
556      *
557      * This internal function is equivalent to {transfer}, and can be used to
558      * e.g. implement automatic token fees, slashing mechanisms, etc.
559      *
560      * Emits a {Transfer} event.
561      *
562      * Requirements:
563      *
564      * - `sender` cannot be the zero address.
565      * - `recipient` cannot be the zero address.
566      * - `sender` must have a balance of at least `amount`.
567      */
568     function _transfer(
569         address sender,
570         address recipient,
571         uint256 amount
572     ) internal virtual {
573         require(sender != address(0), "ERC20: transfer from the zero address");
574         require(recipient != address(0), "ERC20: transfer to the zero address");
575 
576         _beforeTokenTransfer(sender, recipient, amount);
577 
578         uint256 senderBalance = _balances[sender];
579         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
580         unchecked {
581             _balances[sender] = senderBalance - amount;
582         }
583         _balances[recipient] += amount;
584 
585         emit Transfer(sender, recipient, amount);
586 
587         _afterTokenTransfer(sender, recipient, amount);
588     }
589 
590     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
591      * the total supply.
592      *
593      * Emits a {Transfer} event with `from` set to the zero address.
594      *
595      * Requirements:
596      *
597      * - `account` cannot be the zero address.
598      */
599     function _mint(address account, uint256 amount) internal virtual {
600         require(account != address(0), "ERC20: mint to the zero address");
601 
602         _beforeTokenTransfer(address(0), account, amount);
603 
604         _totalSupply += amount;
605         _balances[account] += amount;
606         emit Transfer(address(0), account, amount);
607 
608         _afterTokenTransfer(address(0), account, amount);
609     }
610 
611     /**
612      * @dev Destroys `amount` tokens from `account`, reducing the
613      * total supply.
614      *
615      * Emits a {Transfer} event with `to` set to the zero address.
616      *
617      * Requirements:
618      *
619      * - `account` cannot be the zero address.
620      * - `account` must have at least `amount` tokens.
621      */
622     function _burn(address account, uint256 amount) internal virtual {
623         require(account != address(0), "ERC20: burn from the zero address");
624 
625         _beforeTokenTransfer(account, address(0), amount);
626 
627         uint256 accountBalance = _balances[account];
628         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
629         unchecked {
630             _balances[account] = accountBalance - amount;
631         }
632         _totalSupply -= amount;
633 
634         emit Transfer(account, address(0), amount);
635 
636         _afterTokenTransfer(account, address(0), amount);
637     }
638 
639     /**
640      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
641      *
642      * This internal function is equivalent to `approve`, and can be used to
643      * e.g. set automatic allowances for certain subsystems, etc.
644      *
645      * Emits an {Approval} event.
646      *
647      * Requirements:
648      *
649      * - `owner` cannot be the zero address.
650      * - `spender` cannot be the zero address.
651      */
652     function _approve(
653         address owner,
654         address spender,
655         uint256 amount
656     ) internal virtual {
657         require(owner != address(0), "ERC20: approve from the zero address");
658         require(spender != address(0), "ERC20: approve to the zero address");
659 
660         _allowances[owner][spender] = amount;
661         emit Approval(owner, spender, amount);
662     }
663 
664     /**
665      * @dev Hook that is called before any transfer of tokens. This includes
666      * minting and burning.
667      *
668      * Calling conditions:
669      *
670      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
671      * will be transferred to `to`.
672      * - when `from` is zero, `amount` tokens will be minted for `to`.
673      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
674      * - `from` and `to` are never both zero.
675      *
676      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
677      */
678     function _beforeTokenTransfer(
679         address from,
680         address to,
681         uint256 amount
682     ) internal virtual {}
683 
684     /**
685      * @dev Hook that is called after any transfer of tokens. This includes
686      * minting and burning.
687      *
688      * Calling conditions:
689      *
690      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
691      * has been transferred to `to`.
692      * - when `from` is zero, `amount` tokens have been minted for `to`.
693      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
694      * - `from` and `to` are never both zero.
695      *
696      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
697      */
698     function _afterTokenTransfer(
699         address from,
700         address to,
701         uint256 amount
702     ) internal virtual {}
703 }
704 
705 // File: @openzeppelin/contracts/access/Ownable.sol
706 
707 
708 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
709 
710 pragma solidity ^0.8.0;
711 
712 
713 /**
714  * @dev Contract module which provides a basic access control mechanism, where
715  * there is an account (an owner) that can be granted exclusive access to
716  * specific functions.
717  *
718  * By default, the owner account will be the one that deploys the contract. This
719  * can later be changed with {transferOwnership}.
720  *
721  * This module is used through inheritance. It will make available the modifier
722  * `onlyOwner`, which can be applied to your functions to restrict their use to
723  * the owner.
724  */
725 abstract contract Ownable is Context {
726     address private _owner;
727 
728     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
729 
730     /**
731      * @dev Initializes the contract setting the deployer as the initial owner.
732      */
733     constructor() {
734         _transferOwnership(_msgSender());
735     }
736 
737     /**
738      * @dev Returns the address of the current owner.
739      */
740     function owner() public view virtual returns (address) {
741         return _owner;
742     }
743 
744     /**
745      * @dev Throws if called by any account other than the owner.
746      */
747     modifier onlyOwner() {
748         require(owner() == _msgSender(), "Ownable: caller is not the owner");
749         _;
750     }
751 
752     /**
753      * @dev Leaves the contract without owner. It will not be possible to call
754      * `onlyOwner` functions anymore. Can only be called by the current owner.
755      *
756      * NOTE: Renouncing ownership will leave the contract without an owner,
757      * thereby removing any functionality that is only available to the owner.
758      */
759     function renounceOwnership() public virtual onlyOwner {
760         _transferOwnership(address(0));
761     }
762 
763     /**
764      * @dev Transfers ownership of the contract to a new account (`newOwner`).
765      * Can only be called by the current owner.
766      */
767     function transferOwnership(address newOwner) public virtual onlyOwner {
768         require(newOwner != address(0), "Ownable: new owner is the zero address");
769         _transferOwnership(newOwner);
770     }
771 
772     /**
773      * @dev Transfers ownership of the contract to a new account (`newOwner`).
774      * Internal function without access restriction.
775      */
776     function _transferOwnership(address newOwner) internal virtual {
777         address oldOwner = _owner;
778         _owner = newOwner;
779         emit OwnershipTransferred(oldOwner, newOwner);
780     }
781 }
782 
783 // File: bobl.sol
784 
785 
786 pragma solidity ^0.8.0;
787 
788 
789 
790 
791 contract BOBLToken is ERC20, Ownable {
792     IERC721Enumerable public immutable ROO_CONTRACT;
793     uint256 public immutable BOBL_PER_SECOND_PER_ROWDY_ROO = 11574 gwei;
794     uint256 public immutable BOBL_PER_SECOND_PER_RAGING_ROO = 34722 gwei;
795     uint256 public immutable BOBL_PER_SECOND_PER_ROYAL_ROO = 69444 gwei;
796     uint32 public immutable GENESIS = 1641852000;
797     uint32 public immutable ENDDATE;
798 
799     uint32[9999] private last;
800     uint8[9999] private rank;
801 
802     constructor(address roo_contract) ERC20("BOBL", "BOBL") {
803         ROO_CONTRACT = IERC721Enumerable(roo_contract);
804         ENDDATE = GENESIS + 315576000;
805         _mint(msg.sender, 2500000 ether);
806     }
807 
808     function getAccumulatedForUser(address user) external view returns (uint256) {
809         uint256 total = ROO_CONTRACT.balanceOf(user);
810         uint256 totalOwed = 0;
811         for (uint256 i = 0; i < total; i++) {
812             uint256 id = ROO_CONTRACT.tokenOfOwnerByIndex(user, i);
813             uint32 last_claimed = lastClaim(id);
814             uint32 can_claim = 0;
815             if(block.timestamp > ENDDATE) {
816                 can_claim = ENDDATE - last_claimed;
817             } else {
818                 can_claim = uint32(block.timestamp) - last_claimed;
819             }
820             uint8 roo_rank = rank[id-1];
821             if(roo_rank == 0) {
822                 totalOwed += (can_claim * BOBL_PER_SECOND_PER_ROWDY_ROO);
823             } else if(roo_rank == 1) {
824                 totalOwed += (can_claim * BOBL_PER_SECOND_PER_RAGING_ROO);
825             }else if(roo_rank == 2) {
826                 totalOwed += (can_claim * BOBL_PER_SECOND_PER_ROYAL_ROO);
827             }
828         }
829         return totalOwed;
830     }
831 
832     function getAccumulatedForIds(uint16[] calldata ids) external view returns (uint256) {
833         uint256 totalOwed = 0;
834         for (uint256 i = 0; i < ids.length; i++) {
835             uint16 id = ids[i];
836             uint32 last_claimed = lastClaim(id);
837             uint32 can_claim = 0;
838             if(block.timestamp > ENDDATE) {
839                 can_claim = ENDDATE - last_claimed;
840             } else {
841                 can_claim = uint32(block.timestamp) - last_claimed;
842             }
843             uint256 owed = 0;
844             uint8 roo_rank = rank[id-1];
845             if(roo_rank == 0) {
846                 owed = can_claim * BOBL_PER_SECOND_PER_ROWDY_ROO;
847             } else if (roo_rank == 1) {
848                 owed = can_claim * BOBL_PER_SECOND_PER_RAGING_ROO;
849             } else if (roo_rank == 2) {
850                 owed = can_claim * BOBL_PER_SECOND_PER_ROYAL_ROO;
851             }
852             totalOwed += owed;
853         }
854         return totalOwed;
855     }
856 
857     function mintForUser(address user) external {
858         uint256 total = ROO_CONTRACT.balanceOf(user);
859         require(total > 0, "User does not own any rowdy roos");
860         uint256 totalOwed = 0;
861         uint256 id;
862         for (uint16 i = 0; i < total; i++) {
863             id = ROO_CONTRACT.tokenOfOwnerByIndex(user, i);
864             uint32 last_claimed = lastClaim(id);
865             uint32 can_claim = 0;
866             if(block.timestamp > ENDDATE) {
867                 can_claim = ENDDATE - last_claimed;
868             } else {
869                 can_claim = uint32(block.timestamp) - last_claimed;
870             }
871             uint8 roo_rank = rank[id-1];
872             if(roo_rank == 0) {
873                 totalOwed += (can_claim * BOBL_PER_SECOND_PER_ROWDY_ROO);
874             } else if(roo_rank == 1) {
875                 totalOwed += (can_claim * BOBL_PER_SECOND_PER_RAGING_ROO);
876             }else if(roo_rank == 2) {
877                 totalOwed += (can_claim * BOBL_PER_SECOND_PER_ROYAL_ROO);
878             }
879             last[id-1] = uint32(block.timestamp);
880         }
881         _mint(user, totalOwed);
882     }
883 
884     function mintForIds(uint16[] calldata ids) external {
885         for (uint16 i = 0; i < ids.length; i++) {
886             uint16 id = ids[i];
887             require(id > 0 && id < 10000, "Token id is out of range");
888             address owner = ROO_CONTRACT.ownerOf(id);
889             uint32 last_claimed = lastClaim(id);
890             uint32 can_claim = 0;
891             if(block.timestamp > ENDDATE) {
892                 can_claim = ENDDATE - last_claimed;
893             } else {
894                 can_claim = uint32(block.timestamp) - last_claimed;
895             }
896             uint256 owed = 0;
897             uint8 roo_rank = rank[id-1];
898             if(roo_rank == 0) {
899                 owed = can_claim * BOBL_PER_SECOND_PER_ROWDY_ROO;
900             } else if (roo_rank == 1) {
901                 owed = can_claim * BOBL_PER_SECOND_PER_RAGING_ROO;
902             } else if (roo_rank == 2) {
903                 owed = can_claim * BOBL_PER_SECOND_PER_ROYAL_ROO;
904             }
905             last[id-1] = uint32(block.timestamp);
906             _mint(owner, owed);
907         }
908     }
909 
910     function setRowdyIds(uint16[] calldata tokenIds) external onlyOwner {
911         for (uint16 i = 0; i < tokenIds.length; i++) {
912             rank[tokenIds[i]-1] = 0;
913         }
914     }
915 
916     function setRagingIds(uint16[] calldata tokenIds) external onlyOwner {
917         for (uint16 i = 0; i < tokenIds.length; i++) {
918             rank[tokenIds[i]-1] = 1;
919         }
920     }
921 
922     function setRoyalIds(uint16[] calldata tokenIds) external onlyOwner {
923         for (uint16 i = 0; i < tokenIds.length; i++) {
924             rank[tokenIds[i]-1] = 2;
925         }
926     }
927 
928     function lastClaim(uint256 id) public view returns (uint32) {
929         require(id > 0 && id < 10000, "Token id is out of range");
930         if (last[id-1] > GENESIS) {
931             return last[id-1];
932         } else {
933             return GENESIS;
934         }
935     }
936 
937     function getRank(uint256 id) external view returns (uint256) {
938         require(id > 0 && id < 10000, "Token id is out of range");
939         return rank[id-1];
940     }
941 }