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
32 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC721/IERC721.sol)
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
71      * @dev Safely transfers `tokenId` token from `from` to `to`.
72      *
73      * Requirements:
74      *
75      * - `from` cannot be the zero address.
76      * - `to` cannot be the zero address.
77      * - `tokenId` token must exist and be owned by `from`.
78      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
79      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
80      *
81      * Emits a {Transfer} event.
82      */
83     function safeTransferFrom(
84         address from,
85         address to,
86         uint256 tokenId,
87         bytes calldata data
88     ) external;
89 
90     /**
91      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
92      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
93      *
94      * Requirements:
95      *
96      * - `from` cannot be the zero address.
97      * - `to` cannot be the zero address.
98      * - `tokenId` token must exist and be owned by `from`.
99      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
100      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
101      *
102      * Emits a {Transfer} event.
103      */
104     function safeTransferFrom(
105         address from,
106         address to,
107         uint256 tokenId
108     ) external;
109 
110     /**
111      * @dev Transfers `tokenId` token from `from` to `to`.
112      *
113      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
114      *
115      * Requirements:
116      *
117      * - `from` cannot be the zero address.
118      * - `to` cannot be the zero address.
119      * - `tokenId` token must be owned by `from`.
120      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
121      *
122      * Emits a {Transfer} event.
123      */
124     function transferFrom(
125         address from,
126         address to,
127         uint256 tokenId
128     ) external;
129 
130     /**
131      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
132      * The approval is cleared when the token is transferred.
133      *
134      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
135      *
136      * Requirements:
137      *
138      * - The caller must own the token or be an approved operator.
139      * - `tokenId` must exist.
140      *
141      * Emits an {Approval} event.
142      */
143     function approve(address to, uint256 tokenId) external;
144 
145     /**
146      * @dev Approve or remove `operator` as an operator for the caller.
147      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
148      *
149      * Requirements:
150      *
151      * - The `operator` cannot be the caller.
152      *
153      * Emits an {ApprovalForAll} event.
154      */
155     function setApprovalForAll(address operator, bool _approved) external;
156 
157     /**
158      * @dev Returns the account approved for `tokenId` token.
159      *
160      * Requirements:
161      *
162      * - `tokenId` must exist.
163      */
164     function getApproved(uint256 tokenId) external view returns (address operator);
165 
166     /**
167      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
168      *
169      * See {setApprovalForAll}
170      */
171     function isApprovedForAll(address owner, address operator) external view returns (bool);
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
204 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
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
234      * @dev Throws if called by any account other than the owner.
235      */
236     modifier onlyOwner() {
237         _checkOwner();
238         _;
239     }
240 
241     /**
242      * @dev Returns the address of the current owner.
243      */
244     function owner() public view virtual returns (address) {
245         return _owner;
246     }
247 
248     /**
249      * @dev Throws if the sender is not the owner.
250      */
251     function _checkOwner() internal view virtual {
252         require(owner() == _msgSender(), "Ownable: caller is not the owner");
253     }
254 
255     /**
256      * @dev Leaves the contract without owner. It will not be possible to call
257      * `onlyOwner` functions anymore. Can only be called by the current owner.
258      *
259      * NOTE: Renouncing ownership will leave the contract without an owner,
260      * thereby removing any functionality that is only available to the owner.
261      */
262     function renounceOwnership() public virtual onlyOwner {
263         _transferOwnership(address(0));
264     }
265 
266     /**
267      * @dev Transfers ownership of the contract to a new account (`newOwner`).
268      * Can only be called by the current owner.
269      */
270     function transferOwnership(address newOwner) public virtual onlyOwner {
271         require(newOwner != address(0), "Ownable: new owner is the zero address");
272         _transferOwnership(newOwner);
273     }
274 
275     /**
276      * @dev Transfers ownership of the contract to a new account (`newOwner`).
277      * Internal function without access restriction.
278      */
279     function _transferOwnership(address newOwner) internal virtual {
280         address oldOwner = _owner;
281         _owner = newOwner;
282         emit OwnershipTransferred(oldOwner, newOwner);
283     }
284 }
285 
286 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
287 
288 
289 // OpenZeppelin Contracts (last updated v4.6.0) (token/ERC20/IERC20.sol)
290 
291 pragma solidity ^0.8.0;
292 
293 /**
294  * @dev Interface of the ERC20 standard as defined in the EIP.
295  */
296 interface IERC20 {
297     /**
298      * @dev Emitted when `value` tokens are moved from one account (`from`) to
299      * another (`to`).
300      *
301      * Note that `value` may be zero.
302      */
303     event Transfer(address indexed from, address indexed to, uint256 value);
304 
305     /**
306      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
307      * a call to {approve}. `value` is the new allowance.
308      */
309     event Approval(address indexed owner, address indexed spender, uint256 value);
310 
311     /**
312      * @dev Returns the amount of tokens in existence.
313      */
314     function totalSupply() external view returns (uint256);
315 
316     /**
317      * @dev Returns the amount of tokens owned by `account`.
318      */
319     function balanceOf(address account) external view returns (uint256);
320 
321     /**
322      * @dev Moves `amount` tokens from the caller's account to `to`.
323      *
324      * Returns a boolean value indicating whether the operation succeeded.
325      *
326      * Emits a {Transfer} event.
327      */
328     function transfer(address to, uint256 amount) external returns (bool);
329 
330     /**
331      * @dev Returns the remaining number of tokens that `spender` will be
332      * allowed to spend on behalf of `owner` through {transferFrom}. This is
333      * zero by default.
334      *
335      * This value changes when {approve} or {transferFrom} are called.
336      */
337     function allowance(address owner, address spender) external view returns (uint256);
338 
339     /**
340      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
341      *
342      * Returns a boolean value indicating whether the operation succeeded.
343      *
344      * IMPORTANT: Beware that changing an allowance with this method brings the risk
345      * that someone may use both the old and the new allowance by unfortunate
346      * transaction ordering. One possible solution to mitigate this race
347      * condition is to first reduce the spender's allowance to 0 and set the
348      * desired value afterwards:
349      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
350      *
351      * Emits an {Approval} event.
352      */
353     function approve(address spender, uint256 amount) external returns (bool);
354 
355     /**
356      * @dev Moves `amount` tokens from `from` to `to` using the
357      * allowance mechanism. `amount` is then deducted from the caller's
358      * allowance.
359      *
360      * Returns a boolean value indicating whether the operation succeeded.
361      *
362      * Emits a {Transfer} event.
363      */
364     function transferFrom(
365         address from,
366         address to,
367         uint256 amount
368     ) external returns (bool);
369 }
370 
371 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
372 
373 
374 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
375 
376 pragma solidity ^0.8.0;
377 
378 
379 /**
380  * @dev Interface for the optional metadata functions from the ERC20 standard.
381  *
382  * _Available since v4.1._
383  */
384 interface IERC20Metadata is IERC20 {
385     /**
386      * @dev Returns the name of the token.
387      */
388     function name() external view returns (string memory);
389 
390     /**
391      * @dev Returns the symbol of the token.
392      */
393     function symbol() external view returns (string memory);
394 
395     /**
396      * @dev Returns the decimals places of the token.
397      */
398     function decimals() external view returns (uint8);
399 }
400 
401 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
402 
403 
404 // OpenZeppelin Contracts (last updated v4.7.0) (token/ERC20/ERC20.sol)
405 
406 pragma solidity ^0.8.0;
407 
408 
409 
410 
411 /**
412  * @dev Implementation of the {IERC20} interface.
413  *
414  * This implementation is agnostic to the way tokens are created. This means
415  * that a supply mechanism has to be added in a derived contract using {_mint}.
416  * For a generic mechanism see {ERC20PresetMinterPauser}.
417  *
418  * TIP: For a detailed writeup see our guide
419  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
420  * to implement supply mechanisms].
421  *
422  * We have followed general OpenZeppelin Contracts guidelines: functions revert
423  * instead returning `false` on failure. This behavior is nonetheless
424  * conventional and does not conflict with the expectations of ERC20
425  * applications.
426  *
427  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
428  * This allows applications to reconstruct the allowance for all accounts just
429  * by listening to said events. Other implementations of the EIP may not emit
430  * these events, as it isn't required by the specification.
431  *
432  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
433  * functions have been added to mitigate the well-known issues around setting
434  * allowances. See {IERC20-approve}.
435  */
436 contract ERC20 is Context, IERC20, IERC20Metadata {
437     mapping(address => uint256) private _balances;
438 
439     mapping(address => mapping(address => uint256)) private _allowances;
440 
441     uint256 private _totalSupply;
442 
443     string private _name;
444     string private _symbol;
445 
446     /**
447      * @dev Sets the values for {name} and {symbol}.
448      *
449      * The default value of {decimals} is 18. To select a different value for
450      * {decimals} you should overload it.
451      *
452      * All two of these values are immutable: they can only be set once during
453      * construction.
454      */
455     constructor(string memory name_, string memory symbol_) {
456         _name = name_;
457         _symbol = symbol_;
458     }
459 
460     /**
461      * @dev Returns the name of the token.
462      */
463     function name() public view virtual override returns (string memory) {
464         return _name;
465     }
466 
467     /**
468      * @dev Returns the symbol of the token, usually a shorter version of the
469      * name.
470      */
471     function symbol() public view virtual override returns (string memory) {
472         return _symbol;
473     }
474 
475     /**
476      * @dev Returns the number of decimals used to get its user representation.
477      * For example, if `decimals` equals `2`, a balance of `505` tokens should
478      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
479      *
480      * Tokens usually opt for a value of 18, imitating the relationship between
481      * Ether and Wei. This is the value {ERC20} uses, unless this function is
482      * overridden;
483      *
484      * NOTE: This information is only used for _display_ purposes: it in
485      * no way affects any of the arithmetic of the contract, including
486      * {IERC20-balanceOf} and {IERC20-transfer}.
487      */
488     function decimals() public view virtual override returns (uint8) {
489         return 18;
490     }
491 
492     /**
493      * @dev See {IERC20-totalSupply}.
494      */
495     function totalSupply() public view virtual override returns (uint256) {
496         return _totalSupply;
497     }
498 
499     /**
500      * @dev See {IERC20-balanceOf}.
501      */
502     function balanceOf(address account) public view virtual override returns (uint256) {
503         return _balances[account];
504     }
505 
506     /**
507      * @dev See {IERC20-transfer}.
508      *
509      * Requirements:
510      *
511      * - `to` cannot be the zero address.
512      * - the caller must have a balance of at least `amount`.
513      */
514     function transfer(address to, uint256 amount) public virtual override returns (bool) {
515         address owner = _msgSender();
516         _transfer(owner, to, amount);
517         return true;
518     }
519 
520     /**
521      * @dev See {IERC20-allowance}.
522      */
523     function allowance(address owner, address spender) public view virtual override returns (uint256) {
524         return _allowances[owner][spender];
525     }
526 
527     /**
528      * @dev See {IERC20-approve}.
529      *
530      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
531      * `transferFrom`. This is semantically equivalent to an infinite approval.
532      *
533      * Requirements:
534      *
535      * - `spender` cannot be the zero address.
536      */
537     function approve(address spender, uint256 amount) public virtual override returns (bool) {
538         address owner = _msgSender();
539         _approve(owner, spender, amount);
540         return true;
541     }
542 
543     /**
544      * @dev See {IERC20-transferFrom}.
545      *
546      * Emits an {Approval} event indicating the updated allowance. This is not
547      * required by the EIP. See the note at the beginning of {ERC20}.
548      *
549      * NOTE: Does not update the allowance if the current allowance
550      * is the maximum `uint256`.
551      *
552      * Requirements:
553      *
554      * - `from` and `to` cannot be the zero address.
555      * - `from` must have a balance of at least `amount`.
556      * - the caller must have allowance for ``from``'s tokens of at least
557      * `amount`.
558      */
559     function transferFrom(
560         address from,
561         address to,
562         uint256 amount
563     ) public virtual override returns (bool) {
564         address spender = _msgSender();
565         _spendAllowance(from, spender, amount);
566         _transfer(from, to, amount);
567         return true;
568     }
569 
570     /**
571      * @dev Atomically increases the allowance granted to `spender` by the caller.
572      *
573      * This is an alternative to {approve} that can be used as a mitigation for
574      * problems described in {IERC20-approve}.
575      *
576      * Emits an {Approval} event indicating the updated allowance.
577      *
578      * Requirements:
579      *
580      * - `spender` cannot be the zero address.
581      */
582     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
583         address owner = _msgSender();
584         _approve(owner, spender, allowance(owner, spender) + addedValue);
585         return true;
586     }
587 
588     /**
589      * @dev Atomically decreases the allowance granted to `spender` by the caller.
590      *
591      * This is an alternative to {approve} that can be used as a mitigation for
592      * problems described in {IERC20-approve}.
593      *
594      * Emits an {Approval} event indicating the updated allowance.
595      *
596      * Requirements:
597      *
598      * - `spender` cannot be the zero address.
599      * - `spender` must have allowance for the caller of at least
600      * `subtractedValue`.
601      */
602     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
603         address owner = _msgSender();
604         uint256 currentAllowance = allowance(owner, spender);
605         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
606         unchecked {
607             _approve(owner, spender, currentAllowance - subtractedValue);
608         }
609 
610         return true;
611     }
612 
613     /**
614      * @dev Moves `amount` of tokens from `from` to `to`.
615      *
616      * This internal function is equivalent to {transfer}, and can be used to
617      * e.g. implement automatic token fees, slashing mechanisms, etc.
618      *
619      * Emits a {Transfer} event.
620      *
621      * Requirements:
622      *
623      * - `from` cannot be the zero address.
624      * - `to` cannot be the zero address.
625      * - `from` must have a balance of at least `amount`.
626      */
627     function _transfer(
628         address from,
629         address to,
630         uint256 amount
631     ) internal virtual {
632         require(from != address(0), "ERC20: transfer from the zero address");
633         require(to != address(0), "ERC20: transfer to the zero address");
634 
635         _beforeTokenTransfer(from, to, amount);
636 
637         uint256 fromBalance = _balances[from];
638         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
639         unchecked {
640             _balances[from] = fromBalance - amount;
641         }
642         _balances[to] += amount;
643 
644         emit Transfer(from, to, amount);
645 
646         _afterTokenTransfer(from, to, amount);
647     }
648 
649     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
650      * the total supply.
651      *
652      * Emits a {Transfer} event with `from` set to the zero address.
653      *
654      * Requirements:
655      *
656      * - `account` cannot be the zero address.
657      */
658     function _mint(address account, uint256 amount) internal virtual {
659         require(account != address(0), "ERC20: mint to the zero address");
660 
661         _beforeTokenTransfer(address(0), account, amount);
662 
663         _totalSupply += amount;
664         _balances[account] += amount;
665         emit Transfer(address(0), account, amount);
666 
667         _afterTokenTransfer(address(0), account, amount);
668     }
669 
670     /**
671      * @dev Destroys `amount` tokens from `account`, reducing the
672      * total supply.
673      *
674      * Emits a {Transfer} event with `to` set to the zero address.
675      *
676      * Requirements:
677      *
678      * - `account` cannot be the zero address.
679      * - `account` must have at least `amount` tokens.
680      */
681     function _burn(address account, uint256 amount) internal virtual {
682         require(account != address(0), "ERC20: burn from the zero address");
683 
684         _beforeTokenTransfer(account, address(0), amount);
685 
686         uint256 accountBalance = _balances[account];
687         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
688         unchecked {
689             _balances[account] = accountBalance - amount;
690         }
691         _totalSupply -= amount;
692 
693         emit Transfer(account, address(0), amount);
694 
695         _afterTokenTransfer(account, address(0), amount);
696     }
697 
698     /**
699      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
700      *
701      * This internal function is equivalent to `approve`, and can be used to
702      * e.g. set automatic allowances for certain subsystems, etc.
703      *
704      * Emits an {Approval} event.
705      *
706      * Requirements:
707      *
708      * - `owner` cannot be the zero address.
709      * - `spender` cannot be the zero address.
710      */
711     function _approve(
712         address owner,
713         address spender,
714         uint256 amount
715     ) internal virtual {
716         require(owner != address(0), "ERC20: approve from the zero address");
717         require(spender != address(0), "ERC20: approve to the zero address");
718 
719         _allowances[owner][spender] = amount;
720         emit Approval(owner, spender, amount);
721     }
722 
723     /**
724      * @dev Updates `owner` s allowance for `spender` based on spent `amount`.
725      *
726      * Does not update the allowance amount in case of infinite allowance.
727      * Revert if not enough allowance is available.
728      *
729      * Might emit an {Approval} event.
730      */
731     function _spendAllowance(
732         address owner,
733         address spender,
734         uint256 amount
735     ) internal virtual {
736         uint256 currentAllowance = allowance(owner, spender);
737         if (currentAllowance != type(uint256).max) {
738             require(currentAllowance >= amount, "ERC20: insufficient allowance");
739             unchecked {
740                 _approve(owner, spender, currentAllowance - amount);
741             }
742         }
743     }
744 
745     /**
746      * @dev Hook that is called before any transfer of tokens. This includes
747      * minting and burning.
748      *
749      * Calling conditions:
750      *
751      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
752      * will be transferred to `to`.
753      * - when `from` is zero, `amount` tokens will be minted for `to`.
754      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
755      * - `from` and `to` are never both zero.
756      *
757      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
758      */
759     function _beforeTokenTransfer(
760         address from,
761         address to,
762         uint256 amount
763     ) internal virtual {}
764 
765     /**
766      * @dev Hook that is called after any transfer of tokens. This includes
767      * minting and burning.
768      *
769      * Calling conditions:
770      *
771      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
772      * has been transferred to `to`.
773      * - when `from` is zero, `amount` tokens have been minted for `to`.
774      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
775      * - `from` and `to` are never both zero.
776      *
777      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
778      */
779     function _afterTokenTransfer(
780         address from,
781         address to,
782         uint256 amount
783     ) internal virtual {}
784 }
785 
786 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol
787 
788 
789 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/ERC20Capped.sol)
790 
791 pragma solidity ^0.8.0;
792 
793 
794 /**
795  * @dev Extension of {ERC20} that adds a cap to the supply of tokens.
796  */
797 abstract contract ERC20Capped is ERC20 {
798     uint256 private immutable _cap;
799 
800     /**
801      * @dev Sets the value of the `cap`. This value is immutable, it can only be
802      * set once during construction.
803      */
804     constructor(uint256 cap_) {
805         require(cap_ > 0, "ERC20Capped: cap is 0");
806         _cap = cap_;
807     }
808 
809     /**
810      * @dev Returns the cap on the token's total supply.
811      */
812     function cap() public view virtual returns (uint256) {
813         return _cap;
814     }
815 
816     /**
817      * @dev See {ERC20-_mint}.
818      */
819     function _mint(address account, uint256 amount) internal virtual override {
820         require(ERC20.totalSupply() + amount <= cap(), "ERC20Capped: cap exceeded");
821         super._mint(account, amount);
822     }
823 }
824 
825 // File: @openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol
826 
827 
828 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/extensions/ERC20Burnable.sol)
829 
830 pragma solidity ^0.8.0;
831 
832 
833 
834 /**
835  * @dev Extension of {ERC20} that allows token holders to destroy both their own
836  * tokens and those that they have an allowance for, in a way that can be
837  * recognized off-chain (via event analysis).
838  */
839 abstract contract ERC20Burnable is Context, ERC20 {
840     /**
841      * @dev Destroys `amount` tokens from the caller.
842      *
843      * See {ERC20-_burn}.
844      */
845     function burn(uint256 amount) public virtual {
846         _burn(_msgSender(), amount);
847     }
848 
849     /**
850      * @dev Destroys `amount` tokens from `account`, deducting from the caller's
851      * allowance.
852      *
853      * See {ERC20-_burn} and {ERC20-allowance}.
854      *
855      * Requirements:
856      *
857      * - the caller must have allowance for ``accounts``'s tokens of at least
858      * `amount`.
859      */
860     function burnFrom(address account, uint256 amount) public virtual {
861         _spendAllowance(account, _msgSender(), amount);
862         _burn(account, amount);
863     }
864 }
865 
866 // File: PB_BurnToken.sol
867 
868 
869 pragma solidity >=0.8.4;
870 
871 
872 
873 
874 
875 
876 /// @title PB_BurnToken
877 /// @author Hifi
878 /// @notice Manages the mint and distribution of BURN tokens in exchange for burned BOTS.
879 contract PB_BurnToken is ERC20Burnable, ERC20Capped, Ownable {
880     IERC721 public bots;
881 
882     constructor() ERC20("Pawn Bots Burn Token", "BURN") ERC20Capped(8888 * 10**decimals()) {
883         bots = IERC721(0x28F0521c77923F107E29a5502a5a1152517F9000);
884     }
885 
886     function _mint(address account, uint256 amount) internal override(ERC20, ERC20Capped) {
887         ERC20Capped._mint(account, amount);
888     }
889 
890     function adminMint(address recipient, uint256 amount) external onlyOwner {
891         _mint(recipient, amount);
892     }
893 
894     function updateBots(address newBots) external onlyOwner {
895         bots = IERC721(newBots);
896     }
897 
898     function mint(uint256[] memory botIds) external {
899         for (uint256 i; i < botIds.length; ) {
900             bots.transferFrom(msg.sender, 0x000000000000000000000000000000000000dEaD, botIds[i]);
901             unchecked {
902                 i++;
903             }
904         }
905         _mint(msg.sender, botIds.length * 10**decimals());
906     }
907 }