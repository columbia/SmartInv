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
174 // File: @openzeppelin/contracts/utils/Context.sol
175 
176 
177 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 /**
182  * @dev Provides information about the current execution context, including the
183  * sender of the transaction and its data. While these are generally available
184  * via msg.sender and msg.data, they should not be accessed in such a direct
185  * manner, since when dealing with meta-transactions the account sending and
186  * paying for execution may not be the actual sender (as far as an application
187  * is concerned).
188  *
189  * This contract is only required for intermediate, library-like contracts.
190  */
191 abstract contract Context {
192     function _msgSender() internal view virtual returns (address) {
193         return msg.sender;
194     }
195 
196     function _msgData() internal view virtual returns (bytes calldata) {
197         return msg.data;
198     }
199 }
200 
201 // File: @openzeppelin/contracts/access/Ownable.sol
202 
203 
204 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
205 
206 pragma solidity ^0.8.0;
207 
208 
209 /**
210  * @dev Contract module which provides a basic access control mechanism, where
211  * there is an account (an owner) that can be granted exclusive access to
212  * specific functions.
213  *
214  * By default, the owner account will be the one that deploys the contract. This
215  * can later be changed with {transferOwnership}.
216  *
217  * This module is used through inheritance. It will make available the modifier
218  * `onlyOwner`, which can be applied to your functions to restrict their use to
219  * the owner.
220  */
221 abstract contract Ownable is Context {
222     address private _owner;
223 
224     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
225 
226     /**
227      * @dev Initializes the contract setting the deployer as the initial owner.
228      */
229     constructor() {
230         _transferOwnership(_msgSender());
231     }
232 
233     /**
234      * @dev Returns the address of the current owner.
235      */
236     function owner() public view virtual returns (address) {
237         return _owner;
238     }
239 
240     /**
241      * @dev Throws if called by any account other than the owner.
242      */
243     modifier onlyOwner() {
244         require(owner() == _msgSender(), "Ownable: caller is not the owner");
245         _;
246     }
247 
248     /**
249      * @dev Leaves the contract without owner. It will not be possible to call
250      * `onlyOwner` functions anymore. Can only be called by the current owner.
251      *
252      * NOTE: Renouncing ownership will leave the contract without an owner,
253      * thereby removing any functionality that is only available to the owner.
254      */
255     function renounceOwnership() public virtual onlyOwner {
256         _transferOwnership(address(0));
257     }
258 
259     /**
260      * @dev Transfers ownership of the contract to a new account (`newOwner`).
261      * Can only be called by the current owner.
262      */
263     function transferOwnership(address newOwner) public virtual onlyOwner {
264         require(newOwner != address(0), "Ownable: new owner is the zero address");
265         _transferOwnership(newOwner);
266     }
267 
268     /**
269      * @dev Transfers ownership of the contract to a new account (`newOwner`).
270      * Internal function without access restriction.
271      */
272     function _transferOwnership(address newOwner) internal virtual {
273         address oldOwner = _owner;
274         _owner = newOwner;
275         emit OwnershipTransferred(oldOwner, newOwner);
276     }
277 }
278 
279 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
280 
281 
282 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
283 
284 pragma solidity ^0.8.0;
285 
286 /**
287  * @dev Interface of the ERC20 standard as defined in the EIP.
288  */
289 interface IERC20 {
290     /**
291      * @dev Returns the amount of tokens in existence.
292      */
293     function totalSupply() external view returns (uint256);
294 
295     /**
296      * @dev Returns the amount of tokens owned by `account`.
297      */
298     function balanceOf(address account) external view returns (uint256);
299 
300     /**
301      * @dev Moves `amount` tokens from the caller's account to `recipient`.
302      *
303      * Returns a boolean value indicating whether the operation succeeded.
304      *
305      * Emits a {Transfer} event.
306      */
307     function transfer(address recipient, uint256 amount) external returns (bool);
308 
309     /**
310      * @dev Returns the remaining number of tokens that `spender` will be
311      * allowed to spend on behalf of `owner` through {transferFrom}. This is
312      * zero by default.
313      *
314      * This value changes when {approve} or {transferFrom} are called.
315      */
316     function allowance(address owner, address spender) external view returns (uint256);
317 
318     /**
319      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
320      *
321      * Returns a boolean value indicating whether the operation succeeded.
322      *
323      * IMPORTANT: Beware that changing an allowance with this method brings the risk
324      * that someone may use both the old and the new allowance by unfortunate
325      * transaction ordering. One possible solution to mitigate this race
326      * condition is to first reduce the spender's allowance to 0 and set the
327      * desired value afterwards:
328      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
329      *
330      * Emits an {Approval} event.
331      */
332     function approve(address spender, uint256 amount) external returns (bool);
333 
334     /**
335      * @dev Moves `amount` tokens from `sender` to `recipient` using the
336      * allowance mechanism. `amount` is then deducted from the caller's
337      * allowance.
338      *
339      * Returns a boolean value indicating whether the operation succeeded.
340      *
341      * Emits a {Transfer} event.
342      */
343     function transferFrom(
344         address sender,
345         address recipient,
346         uint256 amount
347     ) external returns (bool);
348 
349     /**
350      * @dev Emitted when `value` tokens are moved from one account (`from`) to
351      * another (`to`).
352      *
353      * Note that `value` may be zero.
354      */
355     event Transfer(address indexed from, address indexed to, uint256 value);
356 
357     /**
358      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
359      * a call to {approve}. `value` is the new allowance.
360      */
361     event Approval(address indexed owner, address indexed spender, uint256 value);
362 }
363 
364 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
365 
366 
367 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
368 
369 pragma solidity ^0.8.0;
370 
371 
372 /**
373  * @dev Interface for the optional metadata functions from the ERC20 standard.
374  *
375  * _Available since v4.1._
376  */
377 interface IERC20Metadata is IERC20 {
378     /**
379      * @dev Returns the name of the token.
380      */
381     function name() external view returns (string memory);
382 
383     /**
384      * @dev Returns the symbol of the token.
385      */
386     function symbol() external view returns (string memory);
387 
388     /**
389      * @dev Returns the decimals places of the token.
390      */
391     function decimals() external view returns (uint8);
392 }
393 
394 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
395 
396 
397 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
398 
399 pragma solidity ^0.8.0;
400 
401 
402 
403 
404 /**
405  * @dev Implementation of the {IERC20} interface.
406  *
407  * This implementation is agnostic to the way tokens are created. This means
408  * that a supply mechanism has to be added in a derived contract using {_mint}.
409  * For a generic mechanism see {ERC20PresetMinterPauser}.
410  *
411  * TIP: For a detailed writeup see our guide
412  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
413  * to implement supply mechanisms].
414  *
415  * We have followed general OpenZeppelin Contracts guidelines: functions revert
416  * instead returning `false` on failure. This behavior is nonetheless
417  * conventional and does not conflict with the expectations of ERC20
418  * applications.
419  *
420  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
421  * This allows applications to reconstruct the allowance for all accounts just
422  * by listening to said events. Other implementations of the EIP may not emit
423  * these events, as it isn't required by the specification.
424  *
425  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
426  * functions have been added to mitigate the well-known issues around setting
427  * allowances. See {IERC20-approve}.
428  */
429 contract ERC20 is Context, IERC20, IERC20Metadata {
430     mapping(address => uint256) private _balances;
431 
432     mapping(address => mapping(address => uint256)) private _allowances;
433 
434     uint256 private _totalSupply;
435 
436     string private _name;
437     string private _symbol;
438 
439     /**
440      * @dev Sets the values for {name} and {symbol}.
441      *
442      * The default value of {decimals} is 18. To select a different value for
443      * {decimals} you should overload it.
444      *
445      * All two of these values are immutable: they can only be set once during
446      * construction.
447      */
448     constructor(string memory name_, string memory symbol_) {
449         _name = name_;
450         _symbol = symbol_;
451     }
452 
453     /**
454      * @dev Returns the name of the token.
455      */
456     function name() public view virtual override returns (string memory) {
457         return _name;
458     }
459 
460     /**
461      * @dev Returns the symbol of the token, usually a shorter version of the
462      * name.
463      */
464     function symbol() public view virtual override returns (string memory) {
465         return _symbol;
466     }
467 
468     /**
469      * @dev Returns the number of decimals used to get its user representation.
470      * For example, if `decimals` equals `2`, a balance of `505` tokens should
471      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
472      *
473      * Tokens usually opt for a value of 18, imitating the relationship between
474      * Ether and Wei. This is the value {ERC20} uses, unless this function is
475      * overridden;
476      *
477      * NOTE: This information is only used for _display_ purposes: it in
478      * no way affects any of the arithmetic of the contract, including
479      * {IERC20-balanceOf} and {IERC20-transfer}.
480      */
481     function decimals() public view virtual override returns (uint8) {
482         return 18;
483     }
484 
485     /**
486      * @dev See {IERC20-totalSupply}.
487      */
488     function totalSupply() public view virtual override returns (uint256) {
489         return _totalSupply;
490     }
491 
492     /**
493      * @dev See {IERC20-balanceOf}.
494      */
495     function balanceOf(address account) public view virtual override returns (uint256) {
496         return _balances[account];
497     }
498 
499     /**
500      * @dev See {IERC20-transfer}.
501      *
502      * Requirements:
503      *
504      * - `recipient` cannot be the zero address.
505      * - the caller must have a balance of at least `amount`.
506      */
507     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
508         _transfer(_msgSender(), recipient, amount);
509         return true;
510     }
511 
512     /**
513      * @dev See {IERC20-allowance}.
514      */
515     function allowance(address owner, address spender) public view virtual override returns (uint256) {
516         return _allowances[owner][spender];
517     }
518 
519     /**
520      * @dev See {IERC20-approve}.
521      *
522      * Requirements:
523      *
524      * - `spender` cannot be the zero address.
525      */
526     function approve(address spender, uint256 amount) public virtual override returns (bool) {
527         _approve(_msgSender(), spender, amount);
528         return true;
529     }
530 
531     /**
532      * @dev See {IERC20-transferFrom}.
533      *
534      * Emits an {Approval} event indicating the updated allowance. This is not
535      * required by the EIP. See the note at the beginning of {ERC20}.
536      *
537      * Requirements:
538      *
539      * - `sender` and `recipient` cannot be the zero address.
540      * - `sender` must have a balance of at least `amount`.
541      * - the caller must have allowance for ``sender``'s tokens of at least
542      * `amount`.
543      */
544     function transferFrom(
545         address sender,
546         address recipient,
547         uint256 amount
548     ) public virtual override returns (bool) {
549         _transfer(sender, recipient, amount);
550 
551         uint256 currentAllowance = _allowances[sender][_msgSender()];
552         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
553         unchecked {
554             _approve(sender, _msgSender(), currentAllowance - amount);
555         }
556 
557         return true;
558     }
559 
560     /**
561      * @dev Atomically increases the allowance granted to `spender` by the caller.
562      *
563      * This is an alternative to {approve} that can be used as a mitigation for
564      * problems described in {IERC20-approve}.
565      *
566      * Emits an {Approval} event indicating the updated allowance.
567      *
568      * Requirements:
569      *
570      * - `spender` cannot be the zero address.
571      */
572     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
573         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
574         return true;
575     }
576 
577     /**
578      * @dev Atomically decreases the allowance granted to `spender` by the caller.
579      *
580      * This is an alternative to {approve} that can be used as a mitigation for
581      * problems described in {IERC20-approve}.
582      *
583      * Emits an {Approval} event indicating the updated allowance.
584      *
585      * Requirements:
586      *
587      * - `spender` cannot be the zero address.
588      * - `spender` must have allowance for the caller of at least
589      * `subtractedValue`.
590      */
591     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
592         uint256 currentAllowance = _allowances[_msgSender()][spender];
593         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
594         unchecked {
595             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
596         }
597 
598         return true;
599     }
600 
601     /**
602      * @dev Moves `amount` of tokens from `sender` to `recipient`.
603      *
604      * This internal function is equivalent to {transfer}, and can be used to
605      * e.g. implement automatic token fees, slashing mechanisms, etc.
606      *
607      * Emits a {Transfer} event.
608      *
609      * Requirements:
610      *
611      * - `sender` cannot be the zero address.
612      * - `recipient` cannot be the zero address.
613      * - `sender` must have a balance of at least `amount`.
614      */
615     function _transfer(
616         address sender,
617         address recipient,
618         uint256 amount
619     ) internal virtual {
620         require(sender != address(0), "ERC20: transfer from the zero address");
621         require(recipient != address(0), "ERC20: transfer to the zero address");
622 
623         _beforeTokenTransfer(sender, recipient, amount);
624 
625         uint256 senderBalance = _balances[sender];
626         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
627         unchecked {
628             _balances[sender] = senderBalance - amount;
629         }
630         _balances[recipient] += amount;
631 
632         emit Transfer(sender, recipient, amount);
633 
634         _afterTokenTransfer(sender, recipient, amount);
635     }
636 
637     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
638      * the total supply.
639      *
640      * Emits a {Transfer} event with `from` set to the zero address.
641      *
642      * Requirements:
643      *
644      * - `account` cannot be the zero address.
645      */
646     function _mint(address account, uint256 amount) internal virtual {
647         require(account != address(0), "ERC20: mint to the zero address");
648 
649         _beforeTokenTransfer(address(0), account, amount);
650 
651         _totalSupply += amount;
652         _balances[account] += amount;
653         emit Transfer(address(0), account, amount);
654 
655         _afterTokenTransfer(address(0), account, amount);
656     }
657 
658     /**
659      * @dev Destroys `amount` tokens from `account`, reducing the
660      * total supply.
661      *
662      * Emits a {Transfer} event with `to` set to the zero address.
663      *
664      * Requirements:
665      *
666      * - `account` cannot be the zero address.
667      * - `account` must have at least `amount` tokens.
668      */
669     function _burn(address account, uint256 amount) internal virtual {
670         require(account != address(0), "ERC20: burn from the zero address");
671 
672         _beforeTokenTransfer(account, address(0), amount);
673 
674         uint256 accountBalance = _balances[account];
675         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
676         unchecked {
677             _balances[account] = accountBalance - amount;
678         }
679         _totalSupply -= amount;
680 
681         emit Transfer(account, address(0), amount);
682 
683         _afterTokenTransfer(account, address(0), amount);
684     }
685 
686     /**
687      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
688      *
689      * This internal function is equivalent to `approve`, and can be used to
690      * e.g. set automatic allowances for certain subsystems, etc.
691      *
692      * Emits an {Approval} event.
693      *
694      * Requirements:
695      *
696      * - `owner` cannot be the zero address.
697      * - `spender` cannot be the zero address.
698      */
699     function _approve(
700         address owner,
701         address spender,
702         uint256 amount
703     ) internal virtual {
704         require(owner != address(0), "ERC20: approve from the zero address");
705         require(spender != address(0), "ERC20: approve to the zero address");
706 
707         _allowances[owner][spender] = amount;
708         emit Approval(owner, spender, amount);
709     }
710 
711     /**
712      * @dev Hook that is called before any transfer of tokens. This includes
713      * minting and burning.
714      *
715      * Calling conditions:
716      *
717      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
718      * will be transferred to `to`.
719      * - when `from` is zero, `amount` tokens will be minted for `to`.
720      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
721      * - `from` and `to` are never both zero.
722      *
723      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
724      */
725     function _beforeTokenTransfer(
726         address from,
727         address to,
728         uint256 amount
729     ) internal virtual {}
730 
731     /**
732      * @dev Hook that is called after any transfer of tokens. This includes
733      * minting and burning.
734      *
735      * Calling conditions:
736      *
737      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
738      * has been transferred to `to`.
739      * - when `from` is zero, `amount` tokens have been minted for `to`.
740      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
741      * - `from` and `to` are never both zero.
742      *
743      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
744      */
745     function _afterTokenTransfer(
746         address from,
747         address to,
748         uint256 amount
749     ) internal virtual {}
750 }
751 
752 // File: @openzeppelin/contracts/utils/Strings.sol
753 
754 
755 // OpenZeppelin Contracts v4.4.1 (utils/Strings.sol)
756 
757 pragma solidity ^0.8.0;
758 
759 /**
760  * @dev String operations.
761  */
762 library Strings {
763     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
764 
765     /**
766      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
767      */
768     function toString(uint256 value) internal pure returns (string memory) {
769         // Inspired by OraclizeAPI's implementation - MIT licence
770         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
771 
772         if (value == 0) {
773             return "0";
774         }
775         uint256 temp = value;
776         uint256 digits;
777         while (temp != 0) {
778             digits++;
779             temp /= 10;
780         }
781         bytes memory buffer = new bytes(digits);
782         while (value != 0) {
783             digits -= 1;
784             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
785             value /= 10;
786         }
787         return string(buffer);
788     }
789 
790     /**
791      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
792      */
793     function toHexString(uint256 value) internal pure returns (string memory) {
794         if (value == 0) {
795             return "0x00";
796         }
797         uint256 temp = value;
798         uint256 length = 0;
799         while (temp != 0) {
800             length++;
801             temp >>= 8;
802         }
803         return toHexString(value, length);
804     }
805 
806     /**
807      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
808      */
809     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
810         bytes memory buffer = new bytes(2 * length + 2);
811         buffer[0] = "0";
812         buffer[1] = "x";
813         for (uint256 i = 2 * length + 1; i > 1; --i) {
814             buffer[i] = _HEX_SYMBOLS[value & 0xf];
815             value >>= 4;
816         }
817         require(value == 0, "Strings: hex length insufficient");
818         return string(buffer);
819     }
820 }
821 
822 // File: @openzeppelin/contracts/utils/cryptography/ECDSA.sol
823 
824 
825 // OpenZeppelin Contracts (last updated v4.5.0) (utils/cryptography/ECDSA.sol)
826 
827 pragma solidity ^0.8.0;
828 
829 
830 /**
831  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
832  *
833  * These functions can be used to verify that a message was signed by the holder
834  * of the private keys of a given address.
835  */
836 library ECDSA {
837     enum RecoverError {
838         NoError,
839         InvalidSignature,
840         InvalidSignatureLength,
841         InvalidSignatureS,
842         InvalidSignatureV
843     }
844 
845     function _throwError(RecoverError error) private pure {
846         if (error == RecoverError.NoError) {
847             return; // no error: do nothing
848         } else if (error == RecoverError.InvalidSignature) {
849             revert("ECDSA: invalid signature");
850         } else if (error == RecoverError.InvalidSignatureLength) {
851             revert("ECDSA: invalid signature length");
852         } else if (error == RecoverError.InvalidSignatureS) {
853             revert("ECDSA: invalid signature 's' value");
854         } else if (error == RecoverError.InvalidSignatureV) {
855             revert("ECDSA: invalid signature 'v' value");
856         }
857     }
858 
859     /**
860      * @dev Returns the address that signed a hashed message (`hash`) with
861      * `signature` or error string. This address can then be used for verification purposes.
862      *
863      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
864      * this function rejects them by requiring the `s` value to be in the lower
865      * half order, and the `v` value to be either 27 or 28.
866      *
867      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
868      * verification to be secure: it is possible to craft signatures that
869      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
870      * this is by receiving a hash of the original message (which may otherwise
871      * be too long), and then calling {toEthSignedMessageHash} on it.
872      *
873      * Documentation for signature generation:
874      * - with https://web3js.readthedocs.io/en/v1.3.4/web3-eth-accounts.html#sign[Web3.js]
875      * - with https://docs.ethers.io/v5/api/signer/#Signer-signMessage[ethers]
876      *
877      * _Available since v4.3._
878      */
879     function tryRecover(bytes32 hash, bytes memory signature) internal pure returns (address, RecoverError) {
880         // Check the signature length
881         // - case 65: r,s,v signature (standard)
882         // - case 64: r,vs signature (cf https://eips.ethereum.org/EIPS/eip-2098) _Available since v4.1._
883         if (signature.length == 65) {
884             bytes32 r;
885             bytes32 s;
886             uint8 v;
887             // ecrecover takes the signature parameters, and the only way to get them
888             // currently is to use assembly.
889             assembly {
890                 r := mload(add(signature, 0x20))
891                 s := mload(add(signature, 0x40))
892                 v := byte(0, mload(add(signature, 0x60)))
893             }
894             return tryRecover(hash, v, r, s);
895         } else if (signature.length == 64) {
896             bytes32 r;
897             bytes32 vs;
898             // ecrecover takes the signature parameters, and the only way to get them
899             // currently is to use assembly.
900             assembly {
901                 r := mload(add(signature, 0x20))
902                 vs := mload(add(signature, 0x40))
903             }
904             return tryRecover(hash, r, vs);
905         } else {
906             return (address(0), RecoverError.InvalidSignatureLength);
907         }
908     }
909 
910     /**
911      * @dev Returns the address that signed a hashed message (`hash`) with
912      * `signature`. This address can then be used for verification purposes.
913      *
914      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
915      * this function rejects them by requiring the `s` value to be in the lower
916      * half order, and the `v` value to be either 27 or 28.
917      *
918      * IMPORTANT: `hash` _must_ be the result of a hash operation for the
919      * verification to be secure: it is possible to craft signatures that
920      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
921      * this is by receiving a hash of the original message (which may otherwise
922      * be too long), and then calling {toEthSignedMessageHash} on it.
923      */
924     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
925         (address recovered, RecoverError error) = tryRecover(hash, signature);
926         _throwError(error);
927         return recovered;
928     }
929 
930     /**
931      * @dev Overload of {ECDSA-tryRecover} that receives the `r` and `vs` short-signature fields separately.
932      *
933      * See https://eips.ethereum.org/EIPS/eip-2098[EIP-2098 short signatures]
934      *
935      * _Available since v4.3._
936      */
937     function tryRecover(
938         bytes32 hash,
939         bytes32 r,
940         bytes32 vs
941     ) internal pure returns (address, RecoverError) {
942         bytes32 s = vs & bytes32(0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff);
943         uint8 v = uint8((uint256(vs) >> 255) + 27);
944         return tryRecover(hash, v, r, s);
945     }
946 
947     /**
948      * @dev Overload of {ECDSA-recover} that receives the `r and `vs` short-signature fields separately.
949      *
950      * _Available since v4.2._
951      */
952     function recover(
953         bytes32 hash,
954         bytes32 r,
955         bytes32 vs
956     ) internal pure returns (address) {
957         (address recovered, RecoverError error) = tryRecover(hash, r, vs);
958         _throwError(error);
959         return recovered;
960     }
961 
962     /**
963      * @dev Overload of {ECDSA-tryRecover} that receives the `v`,
964      * `r` and `s` signature fields separately.
965      *
966      * _Available since v4.3._
967      */
968     function tryRecover(
969         bytes32 hash,
970         uint8 v,
971         bytes32 r,
972         bytes32 s
973     ) internal pure returns (address, RecoverError) {
974         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
975         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
976         // the valid range for s in (301): 0 < s < secp256k1n ÷ 2 + 1, and for v in (302): v ∈ {27, 28}. Most
977         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
978         //
979         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
980         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
981         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
982         // these malleable signatures as well.
983         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
984             return (address(0), RecoverError.InvalidSignatureS);
985         }
986         if (v != 27 && v != 28) {
987             return (address(0), RecoverError.InvalidSignatureV);
988         }
989 
990         // If the signature is valid (and not malleable), return the signer address
991         address signer = ecrecover(hash, v, r, s);
992         if (signer == address(0)) {
993             return (address(0), RecoverError.InvalidSignature);
994         }
995 
996         return (signer, RecoverError.NoError);
997     }
998 
999     /**
1000      * @dev Overload of {ECDSA-recover} that receives the `v`,
1001      * `r` and `s` signature fields separately.
1002      */
1003     function recover(
1004         bytes32 hash,
1005         uint8 v,
1006         bytes32 r,
1007         bytes32 s
1008     ) internal pure returns (address) {
1009         (address recovered, RecoverError error) = tryRecover(hash, v, r, s);
1010         _throwError(error);
1011         return recovered;
1012     }
1013 
1014     /**
1015      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1016      * produces hash corresponding to the one signed with the
1017      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1018      * JSON-RPC method as part of EIP-191.
1019      *
1020      * See {recover}.
1021      */
1022     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1023         // 32 is the length in bytes of hash,
1024         // enforced by the type signature above
1025         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1026     }
1027 
1028     /**
1029      * @dev Returns an Ethereum Signed Message, created from `s`. This
1030      * produces hash corresponding to the one signed with the
1031      * https://eth.wiki/json-rpc/API#eth_sign[`eth_sign`]
1032      * JSON-RPC method as part of EIP-191.
1033      *
1034      * See {recover}.
1035      */
1036     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32) {
1037         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n", Strings.toString(s.length), s));
1038     }
1039 
1040     /**
1041      * @dev Returns an Ethereum Signed Typed Data, created from a
1042      * `domainSeparator` and a `structHash`. This produces hash corresponding
1043      * to the one signed with the
1044      * https://eips.ethereum.org/EIPS/eip-712[`eth_signTypedData`]
1045      * JSON-RPC method as part of EIP-712.
1046      *
1047      * See {recover}.
1048      */
1049     function toTypedDataHash(bytes32 domainSeparator, bytes32 structHash) internal pure returns (bytes32) {
1050         return keccak256(abi.encodePacked("\x19\x01", domainSeparator, structHash));
1051     }
1052 }
1053 
1054 // File: contracts/EDOToken.sol
1055 
1056 
1057 // .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------.  .----------------. 
1058 // | .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. || .--------------. |
1059 // | | ____   ____  | || |    _______   | || |      __      | || | ____    ____ | || | _____  _____ | || |  _______     | || |      __      | || |     _____    | |
1060 // | ||_  _| |_  _| | || |   /  ___  |  | || |     /  \     | || ||_   \  /   _|| || ||_   _||_   _|| || | |_   __ \    | || |     /  \     | || |    |_   _|   | |
1061 // | |  \ \   / /   | || |  |  (__ \_|  | || |    / /\ \    | || |  |   \/   |  | || |  | |    | |  | || |   | |__) |   | || |    / /\ \    | || |      | |     | |
1062 // | |   \ \ / /    | || |   '.___`-.   | || |   / ____ \   | || |  | |\  /| |  | || |  | '    ' |  | || |   |  __ /    | || |   / ____ \   | || |      | |     | |
1063 // | |    \ ' /     | || |  |`\____) |  | || | _/ /    \ \_ | || | _| |_\/_| |_ | || |   \ `--' /   | || |  _| |  \ \_  | || | _/ /    \ \_ | || |     _| |_    | |
1064 // | |     \_/      | || |  |_______.'  | || ||____|  |____|| || ||_____||_____|| || |    `.__.'    | || | |____| |___| | || ||____|  |____|| || |    |_____|   | |
1065 // | |              | || |              | || |              | || |              | || |              | || |              | || |              | || |              | |
1066 // | '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' || '--------------' |
1067 // '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------'  '----------------' |
1068 // Website: https://vsamurai.io
1069 // Developers: https://buildingideas.io
1070 pragma solidity ^0.8.11;
1071 
1072 
1073 
1074 
1075 
1076 contract EDOToken is ERC20, Ownable {
1077   using ECDSA for bytes32;
1078 
1079   struct Rate {
1080     uint64 common;
1081     uint64 rare;
1082     uint64 legendary;
1083     uint64 god;
1084   }
1085 
1086   // Yield rates for each rarity
1087   Rate public tokenRates;
1088   
1089   // TokenID -> Rarity ID (1,2,3,4)
1090   mapping (uint256 => uint256) public rarities;
1091 
1092   // Rewards per NFT ID per Address
1093 	mapping(address => mapping (uint256 => uint256)) public rewards;
1094 	mapping(address => mapping (uint256 => uint256)) public lastUpdate;
1095 
1096 	IERC721 public vSamuraiContract;
1097 
1098 	address public signingKey = address(0);
1099 	bytes32 public DOMAIN_SEPARATOR;
1100 
1101 	uint256 constant public INITIAL_ISSUANCE = 75 ether;
1102 
1103 	bytes32 public constant SIGNUP_FOR_REWARDS_TYPEHASH = keccak256("Rewards(address wallet,uint256 tokenId,uint256 rarityId)");
1104 
1105   uint256 public MAX_SUPPLY = 200000000 ether;
1106   uint256 public TOTAL_MINTED = 0 ether;
1107 
1108 	constructor(address _vsamurai, address _newOwner, address _signingKey) ERC20("EDO", "EDO") {
1109 		signingKey = _signingKey;
1110 		DOMAIN_SEPARATOR = keccak256(
1111 		abi.encode(
1112 			keccak256(
1113 			"EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"
1114 			),
1115 			keccak256(bytes("RegisterForRewards")),
1116 			keccak256(bytes("1")),
1117 			block.chainid,
1118 			address(this)
1119 		)
1120 		);
1121 		tokenRates.common = 2 ether;
1122 		tokenRates.rare = 4 ether;
1123 		tokenRates.legendary = 7 ether;
1124 		tokenRates.god = 10 ether;
1125 		vSamuraiContract = IERC721(_vsamurai);
1126 		_transferOwnership(_newOwner);
1127     _mint(_newOwner, 7500000 ether);
1128     TOTAL_MINTED += 7500000 ether;
1129 	}
1130 
1131   function setTokenRates(uint64 _common, uint64 _rare, uint64 _legendary, uint64 _god) public onlyOwner {
1132     tokenRates.common = _common;
1133     tokenRates.rare = _rare;
1134     tokenRates.legendary = _legendary;
1135     tokenRates.god = _god;
1136   }
1137 
1138   function getTokenRates(uint256 tokenId) public view returns(uint64) {
1139     if(rarities[tokenId] == 1) {
1140       return tokenRates.common;
1141     } else if(rarities[tokenId] == 2) {
1142       return tokenRates.rare;
1143     } else if(rarities[tokenId] == 3) {
1144       return tokenRates.legendary;
1145     } else if(rarities[tokenId] == 4) {
1146       return tokenRates.god;
1147     } else {
1148       return 0;
1149     }
1150   }
1151 
1152   function setSigningAddress(address newSigningKey) public onlyOwner {
1153     signingKey = newSigningKey;
1154   }
1155 
1156   modifier isAllowed() {
1157     require(_msgSender() == address(vSamuraiContract), "Caller not authorized");
1158     _;
1159   }
1160 
1161   function setNFTContract(address _vsamurai) external onlyOwner {
1162     vSamuraiContract = IERC721(_vsamurai);
1163   }
1164 
1165 	function updateReward(address _from, address _to, uint256 _tokenId) external isAllowed {
1166     _updateRewards(_from, _to, _tokenId);
1167 	}
1168 
1169   function _updateRewards(address _from, address _to, uint256 _tokenId) internal {
1170     uint256 tokenRate = getTokenRates(_tokenId);
1171     uint256 time = block.timestamp;
1172     uint256 timerFrom = lastUpdate[_from][_tokenId];
1173 
1174     if (timerFrom > 0) {
1175       rewards[_from][_tokenId] += tokenRate * (time - timerFrom) / 86400;
1176     }
1177 
1178     lastUpdate[_from][_tokenId] = time;
1179 
1180     if (_to != address(0)) {
1181       lastUpdate[_to][_tokenId] = time;
1182     }
1183   }
1184 
1185   event RewardClaimed(address indexed user, uint256 reward);
1186 
1187   function claimRewards(uint256 _nftId) external {
1188     require(address(vSamuraiContract) != address(0), 'NFT contract not set');
1189     require(vSamuraiContract.ownerOf(_nftId) == _msgSender(), 'You are not the nft owner');
1190     _updateRewards(_msgSender(), address(0), _nftId);
1191     _mintRewards(_msgSender(), _nftId);
1192 	}
1193 
1194   function min(uint256 a, uint256 b) internal pure returns (uint256) {
1195     return a <= b ? a : b;
1196   }
1197 
1198 	function _mintRewards(address _from, uint256 _tokenId) internal {
1199 		uint256 reward = rewards[_from][_tokenId];
1200 		if (reward > 0) {
1201       require(MAX_SUPPLY > TOTAL_MINTED, "Exceeds max supply");
1202 			rewards[_from][_tokenId] = 0;
1203       uint256 amounToMint = min(MAX_SUPPLY - TOTAL_MINTED, reward);
1204       _mint(_from, amounToMint);
1205       TOTAL_MINTED += amounToMint;
1206       emit RewardClaimed(_from, amounToMint);
1207 		}
1208 	}
1209 
1210 	function burn(address _from, uint256 _amount) external isAllowed {
1211 		_burn(_from, _amount);
1212 	}
1213 
1214 	function getTotalClaimable(address _from, uint256 _tokenId) external view returns(uint256) {
1215     uint256 tokenRate = getTokenRates(_tokenId);
1216 		uint256 time = block.timestamp;
1217     if (vSamuraiContract.ownerOf(_tokenId) == _from) {
1218 		  uint256 pending = tokenRate * (time - lastUpdate[_from][_tokenId]) / 86400;
1219 		  return rewards[_from][_tokenId] + pending;
1220     }
1221     return rewards[_from][_tokenId];
1222 	}
1223 
1224   modifier withValidSignature(bytes calldata signature, uint256 _tokenId, uint256 _rarity) {
1225     require(signingKey != address(0), "rewards not enabled");
1226     // Verify EIP-712 signature by recreating the data structure
1227     // that we signed on the client side, and then using that to recover
1228     // the address that signed the signature for this data.
1229     bytes32 digest = keccak256(
1230         abi.encodePacked(
1231             "\x19\x01",
1232             DOMAIN_SEPARATOR,
1233             keccak256(
1234               abi.encode(
1235                 SIGNUP_FOR_REWARDS_TYPEHASH, 
1236                 _msgSender(),
1237                 _tokenId,
1238                 _rarity
1239               )
1240             )
1241         )
1242     );
1243     // Use the recover method to see what address was used to create
1244     // the signature on this data.
1245     // Note that if the digest doesn't exactly match what was signed we'll
1246     // get a random recovered address.
1247     address recoveredAddress = digest.recover(signature);
1248     require(recoveredAddress == signingKey, "Invalid Signature");
1249     _;
1250   }
1251 
1252   function registerForRewards(bytes calldata signature, uint256 _tokenId, uint256 _rarity) public withValidSignature(signature, _tokenId, _rarity) {
1253     require(rarities[_tokenId] == 0, 'Token cannot be registered for rewards more than once');
1254     require(vSamuraiContract.ownerOf(_tokenId) == _msgSender(), 'You are not the nft owner');
1255     rarities[_tokenId] = _rarity;
1256     rewards[_msgSender()][_tokenId] = rewards[_msgSender()][_tokenId] + INITIAL_ISSUANCE;
1257 		lastUpdate[_msgSender()][_tokenId] = block.timestamp;
1258   }
1259 
1260   function adminRarityRegistration(uint256 _tokenId, uint256 _rarity, address _tokenOwner) public onlyOwner {
1261     rarities[_tokenId] = _rarity;
1262     rewards[_tokenOwner][_tokenId] = rewards[_tokenOwner][_tokenId] + INITIAL_ISSUANCE;
1263     lastUpdate[_tokenOwner][_tokenId] = block.timestamp;
1264   }
1265 
1266   function changeMaxSupply(uint256 _newMaxSupply) public onlyOwner {
1267     require(_newMaxSupply > TOTAL_MINTED, "The new max supply must be greater than the total tokens minted");
1268     MAX_SUPPLY = _newMaxSupply;
1269   }
1270 }