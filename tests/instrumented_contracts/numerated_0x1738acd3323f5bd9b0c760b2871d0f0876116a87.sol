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
174 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
175 
176 
177 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/IERC20.sol)
178 
179 pragma solidity ^0.8.0;
180 
181 /**
182  * @dev Interface of the ERC20 standard as defined in the EIP.
183  */
184 interface IERC20 {
185     /**
186      * @dev Returns the amount of tokens in existence.
187      */
188     function totalSupply() external view returns (uint256);
189 
190     /**
191      * @dev Returns the amount of tokens owned by `account`.
192      */
193     function balanceOf(address account) external view returns (uint256);
194 
195     /**
196      * @dev Moves `amount` tokens from the caller's account to `to`.
197      *
198      * Returns a boolean value indicating whether the operation succeeded.
199      *
200      * Emits a {Transfer} event.
201      */
202     function transfer(address to, uint256 amount) external returns (bool);
203 
204     /**
205      * @dev Returns the remaining number of tokens that `spender` will be
206      * allowed to spend on behalf of `owner` through {transferFrom}. This is
207      * zero by default.
208      *
209      * This value changes when {approve} or {transferFrom} are called.
210      */
211     function allowance(address owner, address spender) external view returns (uint256);
212 
213     /**
214      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
215      *
216      * Returns a boolean value indicating whether the operation succeeded.
217      *
218      * IMPORTANT: Beware that changing an allowance with this method brings the risk
219      * that someone may use both the old and the new allowance by unfortunate
220      * transaction ordering. One possible solution to mitigate this race
221      * condition is to first reduce the spender's allowance to 0 and set the
222      * desired value afterwards:
223      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
224      *
225      * Emits an {Approval} event.
226      */
227     function approve(address spender, uint256 amount) external returns (bool);
228 
229     /**
230      * @dev Moves `amount` tokens from `from` to `to` using the
231      * allowance mechanism. `amount` is then deducted from the caller's
232      * allowance.
233      *
234      * Returns a boolean value indicating whether the operation succeeded.
235      *
236      * Emits a {Transfer} event.
237      */
238     function transferFrom(
239         address from,
240         address to,
241         uint256 amount
242     ) external returns (bool);
243 
244     /**
245      * @dev Emitted when `value` tokens are moved from one account (`from`) to
246      * another (`to`).
247      *
248      * Note that `value` may be zero.
249      */
250     event Transfer(address indexed from, address indexed to, uint256 value);
251 
252     /**
253      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
254      * a call to {approve}. `value` is the new allowance.
255      */
256     event Approval(address indexed owner, address indexed spender, uint256 value);
257 }
258 
259 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
260 
261 
262 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
263 
264 pragma solidity ^0.8.0;
265 
266 
267 /**
268  * @dev Interface for the optional metadata functions from the ERC20 standard.
269  *
270  * _Available since v4.1._
271  */
272 interface IERC20Metadata is IERC20 {
273     /**
274      * @dev Returns the name of the token.
275      */
276     function name() external view returns (string memory);
277 
278     /**
279      * @dev Returns the symbol of the token.
280      */
281     function symbol() external view returns (string memory);
282 
283     /**
284      * @dev Returns the decimals places of the token.
285      */
286     function decimals() external view returns (uint8);
287 }
288 
289 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
290 
291 
292 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
293 
294 pragma solidity ^0.8.0;
295 
296 /**
297  * @dev Contract module that helps prevent reentrant calls to a function.
298  *
299  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
300  * available, which can be applied to functions to make sure there are no nested
301  * (reentrant) calls to them.
302  *
303  * Note that because there is a single `nonReentrant` guard, functions marked as
304  * `nonReentrant` may not call one another. This can be worked around by making
305  * those functions `private`, and then adding `external` `nonReentrant` entry
306  * points to them.
307  *
308  * TIP: If you would like to learn more about reentrancy and alternative ways
309  * to protect against it, check out our blog post
310  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
311  */
312 abstract contract ReentrancyGuard {
313     // Booleans are more expensive than uint256 or any type that takes up a full
314     // word because each write operation emits an extra SLOAD to first read the
315     // slot's contents, replace the bits taken up by the boolean, and then write
316     // back. This is the compiler's defense against contract upgrades and
317     // pointer aliasing, and it cannot be disabled.
318 
319     // The values being non-zero value makes deployment a bit more expensive,
320     // but in exchange the refund on every call to nonReentrant will be lower in
321     // amount. Since refunds are capped to a percentage of the total
322     // transaction's gas, it is best to keep them low in cases like this one, to
323     // increase the likelihood of the full refund coming into effect.
324     uint256 private constant _NOT_ENTERED = 1;
325     uint256 private constant _ENTERED = 2;
326 
327     uint256 private _status;
328 
329     constructor() {
330         _status = _NOT_ENTERED;
331     }
332 
333     /**
334      * @dev Prevents a contract from calling itself, directly or indirectly.
335      * Calling a `nonReentrant` function from another `nonReentrant`
336      * function is not supported. It is possible to prevent this from happening
337      * by making the `nonReentrant` function external, and making it call a
338      * `private` function that does the actual work.
339      */
340     modifier nonReentrant() {
341         // On the first call to nonReentrant, _notEntered will be true
342         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
343 
344         // Any calls to nonReentrant after this point will fail
345         _status = _ENTERED;
346 
347         _;
348 
349         // By storing the original value once again, a refund is triggered (see
350         // https://eips.ethereum.org/EIPS/eip-2200)
351         _status = _NOT_ENTERED;
352     }
353 }
354 
355 // File: @openzeppelin/contracts/utils/Context.sol
356 
357 
358 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
359 
360 pragma solidity ^0.8.0;
361 
362 /**
363  * @dev Provides information about the current execution context, including the
364  * sender of the transaction and its data. While these are generally available
365  * via msg.sender and msg.data, they should not be accessed in such a direct
366  * manner, since when dealing with meta-transactions the account sending and
367  * paying for execution may not be the actual sender (as far as an application
368  * is concerned).
369  *
370  * This contract is only required for intermediate, library-like contracts.
371  */
372 abstract contract Context {
373     function _msgSender() internal view virtual returns (address) {
374         return msg.sender;
375     }
376 
377     function _msgData() internal view virtual returns (bytes calldata) {
378         return msg.data;
379     }
380 }
381 
382 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
383 
384 
385 // OpenZeppelin Contracts (last updated v4.5.0) (token/ERC20/ERC20.sol)
386 
387 pragma solidity ^0.8.0;
388 
389 
390 
391 
392 /**
393  * @dev Implementation of the {IERC20} interface.
394  *
395  * This implementation is agnostic to the way tokens are created. This means
396  * that a supply mechanism has to be added in a derived contract using {_mint}.
397  * For a generic mechanism see {ERC20PresetMinterPauser}.
398  *
399  * TIP: For a detailed writeup see our guide
400  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
401  * to implement supply mechanisms].
402  *
403  * We have followed general OpenZeppelin Contracts guidelines: functions revert
404  * instead returning `false` on failure. This behavior is nonetheless
405  * conventional and does not conflict with the expectations of ERC20
406  * applications.
407  *
408  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
409  * This allows applications to reconstruct the allowance for all accounts just
410  * by listening to said events. Other implementations of the EIP may not emit
411  * these events, as it isn't required by the specification.
412  *
413  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
414  * functions have been added to mitigate the well-known issues around setting
415  * allowances. See {IERC20-approve}.
416  */
417 contract ERC20 is Context, IERC20, IERC20Metadata {
418     mapping(address => uint256) private _balances;
419 
420     mapping(address => mapping(address => uint256)) private _allowances;
421 
422     uint256 private _totalSupply;
423 
424     string private _name;
425     string private _symbol;
426 
427     /**
428      * @dev Sets the values for {name} and {symbol}.
429      *
430      * The default value of {decimals} is 18. To select a different value for
431      * {decimals} you should overload it.
432      *
433      * All two of these values are immutable: they can only be set once during
434      * construction.
435      */
436     constructor(string memory name_, string memory symbol_) {
437         _name = name_;
438         _symbol = symbol_;
439     }
440 
441     /**
442      * @dev Returns the name of the token.
443      */
444     function name() public view virtual override returns (string memory) {
445         return _name;
446     }
447 
448     /**
449      * @dev Returns the symbol of the token, usually a shorter version of the
450      * name.
451      */
452     function symbol() public view virtual override returns (string memory) {
453         return _symbol;
454     }
455 
456     /**
457      * @dev Returns the number of decimals used to get its user representation.
458      * For example, if `decimals` equals `2`, a balance of `505` tokens should
459      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
460      *
461      * Tokens usually opt for a value of 18, imitating the relationship between
462      * Ether and Wei. This is the value {ERC20} uses, unless this function is
463      * overridden;
464      *
465      * NOTE: This information is only used for _display_ purposes: it in
466      * no way affects any of the arithmetic of the contract, including
467      * {IERC20-balanceOf} and {IERC20-transfer}.
468      */
469     function decimals() public view virtual override returns (uint8) {
470         return 18;
471     }
472 
473     /**
474      * @dev See {IERC20-totalSupply}.
475      */
476     function totalSupply() public view virtual override returns (uint256) {
477         return _totalSupply;
478     }
479 
480     /**
481      * @dev See {IERC20-balanceOf}.
482      */
483     function balanceOf(address account) public view virtual override returns (uint256) {
484         return _balances[account];
485     }
486 
487     /**
488      * @dev See {IERC20-transfer}.
489      *
490      * Requirements:
491      *
492      * - `to` cannot be the zero address.
493      * - the caller must have a balance of at least `amount`.
494      */
495     function transfer(address to, uint256 amount) public virtual override returns (bool) {
496         address owner = _msgSender();
497         _transfer(owner, to, amount);
498         return true;
499     }
500 
501     /**
502      * @dev See {IERC20-allowance}.
503      */
504     function allowance(address owner, address spender) public view virtual override returns (uint256) {
505         return _allowances[owner][spender];
506     }
507 
508     /**
509      * @dev See {IERC20-approve}.
510      *
511      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
512      * `transferFrom`. This is semantically equivalent to an infinite approval.
513      *
514      * Requirements:
515      *
516      * - `spender` cannot be the zero address.
517      */
518     function approve(address spender, uint256 amount) public virtual override returns (bool) {
519         address owner = _msgSender();
520         _approve(owner, spender, amount);
521         return true;
522     }
523 
524     /**
525      * @dev See {IERC20-transferFrom}.
526      *
527      * Emits an {Approval} event indicating the updated allowance. This is not
528      * required by the EIP. See the note at the beginning of {ERC20}.
529      *
530      * NOTE: Does not update the allowance if the current allowance
531      * is the maximum `uint256`.
532      *
533      * Requirements:
534      *
535      * - `from` and `to` cannot be the zero address.
536      * - `from` must have a balance of at least `amount`.
537      * - the caller must have allowance for ``from``'s tokens of at least
538      * `amount`.
539      */
540     function transferFrom(
541         address from,
542         address to,
543         uint256 amount
544     ) public virtual override returns (bool) {
545         address spender = _msgSender();
546         _spendAllowance(from, spender, amount);
547         _transfer(from, to, amount);
548         return true;
549     }
550 
551     /**
552      * @dev Atomically increases the allowance granted to `spender` by the caller.
553      *
554      * This is an alternative to {approve} that can be used as a mitigation for
555      * problems described in {IERC20-approve}.
556      *
557      * Emits an {Approval} event indicating the updated allowance.
558      *
559      * Requirements:
560      *
561      * - `spender` cannot be the zero address.
562      */
563     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
564         address owner = _msgSender();
565         _approve(owner, spender, _allowances[owner][spender] + addedValue);
566         return true;
567     }
568 
569     /**
570      * @dev Atomically decreases the allowance granted to `spender` by the caller.
571      *
572      * This is an alternative to {approve} that can be used as a mitigation for
573      * problems described in {IERC20-approve}.
574      *
575      * Emits an {Approval} event indicating the updated allowance.
576      *
577      * Requirements:
578      *
579      * - `spender` cannot be the zero address.
580      * - `spender` must have allowance for the caller of at least
581      * `subtractedValue`.
582      */
583     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
584         address owner = _msgSender();
585         uint256 currentAllowance = _allowances[owner][spender];
586         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
587         unchecked {
588             _approve(owner, spender, currentAllowance - subtractedValue);
589         }
590 
591         return true;
592     }
593 
594     /**
595      * @dev Moves `amount` of tokens from `sender` to `recipient`.
596      *
597      * This internal function is equivalent to {transfer}, and can be used to
598      * e.g. implement automatic token fees, slashing mechanisms, etc.
599      *
600      * Emits a {Transfer} event.
601      *
602      * Requirements:
603      *
604      * - `from` cannot be the zero address.
605      * - `to` cannot be the zero address.
606      * - `from` must have a balance of at least `amount`.
607      */
608     function _transfer(
609         address from,
610         address to,
611         uint256 amount
612     ) internal virtual {
613         require(from != address(0), "ERC20: transfer from the zero address");
614         require(to != address(0), "ERC20: transfer to the zero address");
615 
616         _beforeTokenTransfer(from, to, amount);
617 
618         uint256 fromBalance = _balances[from];
619         require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
620         unchecked {
621             _balances[from] = fromBalance - amount;
622         }
623         _balances[to] += amount;
624 
625         emit Transfer(from, to, amount);
626 
627         _afterTokenTransfer(from, to, amount);
628     }
629 
630     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
631      * the total supply.
632      *
633      * Emits a {Transfer} event with `from` set to the zero address.
634      *
635      * Requirements:
636      *
637      * - `account` cannot be the zero address.
638      */
639     function _mint(address account, uint256 amount) internal virtual {
640         require(account != address(0), "ERC20: mint to the zero address");
641 
642         _beforeTokenTransfer(address(0), account, amount);
643 
644         _totalSupply += amount;
645         _balances[account] += amount;
646         emit Transfer(address(0), account, amount);
647 
648         _afterTokenTransfer(address(0), account, amount);
649     }
650 
651     /**
652      * @dev Destroys `amount` tokens from `account`, reducing the
653      * total supply.
654      *
655      * Emits a {Transfer} event with `to` set to the zero address.
656      *
657      * Requirements:
658      *
659      * - `account` cannot be the zero address.
660      * - `account` must have at least `amount` tokens.
661      */
662     function _burn(address account, uint256 amount) internal virtual {
663         require(account != address(0), "ERC20: burn from the zero address");
664 
665         _beforeTokenTransfer(account, address(0), amount);
666 
667         uint256 accountBalance = _balances[account];
668         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
669         unchecked {
670             _balances[account] = accountBalance - amount;
671         }
672         _totalSupply -= amount;
673 
674         emit Transfer(account, address(0), amount);
675 
676         _afterTokenTransfer(account, address(0), amount);
677     }
678 
679     /**
680      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
681      *
682      * This internal function is equivalent to `approve`, and can be used to
683      * e.g. set automatic allowances for certain subsystems, etc.
684      *
685      * Emits an {Approval} event.
686      *
687      * Requirements:
688      *
689      * - `owner` cannot be the zero address.
690      * - `spender` cannot be the zero address.
691      */
692     function _approve(
693         address owner,
694         address spender,
695         uint256 amount
696     ) internal virtual {
697         require(owner != address(0), "ERC20: approve from the zero address");
698         require(spender != address(0), "ERC20: approve to the zero address");
699 
700         _allowances[owner][spender] = amount;
701         emit Approval(owner, spender, amount);
702     }
703 
704     /**
705      * @dev Spend `amount` form the allowance of `owner` toward `spender`.
706      *
707      * Does not update the allowance amount in case of infinite allowance.
708      * Revert if not enough allowance is available.
709      *
710      * Might emit an {Approval} event.
711      */
712     function _spendAllowance(
713         address owner,
714         address spender,
715         uint256 amount
716     ) internal virtual {
717         uint256 currentAllowance = allowance(owner, spender);
718         if (currentAllowance != type(uint256).max) {
719             require(currentAllowance >= amount, "ERC20: insufficient allowance");
720             unchecked {
721                 _approve(owner, spender, currentAllowance - amount);
722             }
723         }
724     }
725 
726     /**
727      * @dev Hook that is called before any transfer of tokens. This includes
728      * minting and burning.
729      *
730      * Calling conditions:
731      *
732      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
733      * will be transferred to `to`.
734      * - when `from` is zero, `amount` tokens will be minted for `to`.
735      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
736      * - `from` and `to` are never both zero.
737      *
738      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
739      */
740     function _beforeTokenTransfer(
741         address from,
742         address to,
743         uint256 amount
744     ) internal virtual {}
745 
746     /**
747      * @dev Hook that is called after any transfer of tokens. This includes
748      * minting and burning.
749      *
750      * Calling conditions:
751      *
752      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
753      * has been transferred to `to`.
754      * - when `from` is zero, `amount` tokens have been minted for `to`.
755      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
756      * - `from` and `to` are never both zero.
757      *
758      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
759      */
760     function _afterTokenTransfer(
761         address from,
762         address to,
763         uint256 amount
764     ) internal virtual {}
765 }
766 
767 // File: @openzeppelin/contracts/access/Ownable.sol
768 
769 
770 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
771 
772 pragma solidity ^0.8.0;
773 
774 
775 /**
776  * @dev Contract module which provides a basic access control mechanism, where
777  * there is an account (an owner) that can be granted exclusive access to
778  * specific functions.
779  *
780  * By default, the owner account will be the one that deploys the contract. This
781  * can later be changed with {transferOwnership}.
782  *
783  * This module is used through inheritance. It will make available the modifier
784  * `onlyOwner`, which can be applied to your functions to restrict their use to
785  * the owner.
786  */
787 abstract contract Ownable is Context {
788     address private _owner;
789 
790     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
791 
792     /**
793      * @dev Initializes the contract setting the deployer as the initial owner.
794      */
795     constructor() {
796         _transferOwnership(_msgSender());
797     }
798 
799     /**
800      * @dev Returns the address of the current owner.
801      */
802     function owner() public view virtual returns (address) {
803         return _owner;
804     }
805 
806     /**
807      * @dev Throws if called by any account other than the owner.
808      */
809     modifier onlyOwner() {
810         require(owner() == _msgSender(), "Ownable: caller is not the owner");
811         _;
812     }
813 
814     /**
815      * @dev Leaves the contract without owner. It will not be possible to call
816      * `onlyOwner` functions anymore. Can only be called by the current owner.
817      *
818      * NOTE: Renouncing ownership will leave the contract without an owner,
819      * thereby removing any functionality that is only available to the owner.
820      */
821     function renounceOwnership() public virtual onlyOwner {
822         _transferOwnership(address(0));
823     }
824 
825     /**
826      * @dev Transfers ownership of the contract to a new account (`newOwner`).
827      * Can only be called by the current owner.
828      */
829     function transferOwnership(address newOwner) public virtual onlyOwner {
830         require(newOwner != address(0), "Ownable: new owner is the zero address");
831         _transferOwnership(newOwner);
832     }
833 
834     /**
835      * @dev Transfers ownership of the contract to a new account (`newOwner`).
836      * Internal function without access restriction.
837      */
838     function _transferOwnership(address newOwner) internal virtual {
839         address oldOwner = _owner;
840         _owner = newOwner;
841         emit OwnershipTransferred(oldOwner, newOwner);
842     }
843 }
844 
845 // File: Toeken.sol
846 
847 
848 pragma solidity ^0.8.12;
849 
850 
851 
852 
853 
854 contract Toeken is ERC20, Ownable, ReentrancyGuard {
855     IERC721 public TiptoePunks;
856     IERC721 public FootPunks;
857 
858     uint256 internal reserved;
859     uint256 public startTime;
860 
861     mapping(address => uint256) public rewards;
862     mapping(address => uint256) public lastUpdate;
863     mapping(address => bool) public allowed;
864 
865     uint256 public constant TIPTOE_BASE_RATE = 5 ether;
866     uint256 public constant FOOT_BASE_RATE = 75 ether;
867     uint256 public constant MAX_RESERVED_AMOUNT = 100_000 ether;
868 
869     constructor(address tiptoePunks, address footPunks) ERC20("Toeken", "TOEKEN") {
870         setTiptoePunks(tiptoePunks);
871         setFootPunks(footPunks);
872     }
873 
874     modifier onlyAllowed() {
875         require(allowed[msg.sender], "Caller not allowed");
876         _;
877     }
878 
879     function setTiptoePunks(address tiptoePunks) public onlyOwner {
880         TiptoePunks = IERC721(tiptoePunks);
881         allowed[tiptoePunks] = true;
882     }
883 
884     function setFootPunks(address footPunks) public onlyOwner {
885         FootPunks = IERC721(footPunks);
886         allowed[footPunks] = true;
887     }
888 
889     function startRewards(uint256 timestamp) public onlyOwner {
890         startTime = timestamp;
891     }
892 
893     function stopRewards() public onlyOwner {
894         startTime = 0;
895     }
896 
897     function setAllowed(address account, bool isAllowed) public onlyOwner {
898         allowed[account] = isAllowed;
899     }
900 
901     function reserve(uint256 amount) external onlyOwner {
902         require(reserved + amount <= MAX_RESERVED_AMOUNT, "Would exceed max reserved amount");
903         _mint(msg.sender, amount);
904         reserved += amount;
905     }
906 
907     function burn(uint256 amount) external onlyOwner {
908         _burn(msg.sender, amount);
909     }
910 
911     function getClaimable(address account) external view returns (uint256) {
912         return rewards[account] + getPending(account);
913     }
914 
915     function getPending(address account) internal view returns (uint256) {
916         if (startTime == 0) {
917             return 0;
918         }
919 
920         uint256 timeMultiplier = (block.timestamp -
921             (lastUpdate[account] > startTime ? lastUpdate[account] : startTime));
922         uint256 pendingFromTiptoe = (TiptoePunks.balanceOf(account) * TIPTOE_BASE_RATE * timeMultiplier) / 1 days;
923         uint256 pendingFromFoot = (FootPunks.balanceOf(account) * FOOT_BASE_RATE * timeMultiplier) / 1 days;
924 
925         return pendingFromTiptoe + pendingFromFoot;
926     }
927 
928     function update(address from, address to) external onlyAllowed {
929         if (from != address(0)) {
930             rewards[from] += getPending(from);
931             lastUpdate[from] = block.timestamp;
932         }
933         if (to != address(0)) {
934             rewards[to] += getPending(to);
935             lastUpdate[to] = block.timestamp;
936         }
937     }
938 
939     function claim(address account) external nonReentrant {
940         require(msg.sender == account || allowed[msg.sender], "Caller not allowed");
941         _mint(account, rewards[account] + getPending(account));
942         rewards[account] = 0;
943         lastUpdate[account] = block.timestamp;
944     }
945 }