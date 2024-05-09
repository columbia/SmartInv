1 // File: @openzeppelin/contracts/utils/cryptography/MerkleProof.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (utils/cryptography/MerkleProof.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev These functions deal with verification of Merkle Trees proofs.
10  *
11  * The proofs can be generated using the JavaScript library
12  * https://github.com/miguelmota/merkletreejs[merkletreejs].
13  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
14  *
15  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
16  */
17 library MerkleProof {
18     /**
19      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
20      * defined by `root`. For this, a `proof` must be provided, containing
21      * sibling hashes on the branch from the leaf to the root of the tree. Each
22      * pair of leaves and each pair of pre-images are assumed to be sorted.
23      */
24     function verify(
25         bytes32[] memory proof,
26         bytes32 root,
27         bytes32 leaf
28     ) internal pure returns (bool) {
29         return processProof(proof, leaf) == root;
30     }
31 
32     /**
33      * @dev Returns the rebuilt hash obtained by traversing a Merklee tree up
34      * from `leaf` using `proof`. A `proof` is valid if and only if the rebuilt
35      * hash matches the root of the tree. When processing the proof, the pairs
36      * of leafs & pre-images are assumed to be sorted.
37      *
38      * _Available since v4.4._
39      */
40     function processProof(bytes32[] memory proof, bytes32 leaf) internal pure returns (bytes32) {
41         bytes32 computedHash = leaf;
42         for (uint256 i = 0; i < proof.length; i++) {
43             bytes32 proofElement = proof[i];
44             if (computedHash <= proofElement) {
45                 // Hash(current computed hash + current element of the proof)
46                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
47             } else {
48                 // Hash(current element of the proof + current computed hash)
49                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
50             }
51         }
52         return computedHash;
53     }
54 }
55 
56 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
57 
58 
59 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
60 
61 pragma solidity ^0.8.0;
62 
63 /**
64  * @dev Interface of the ERC165 standard, as defined in the
65  * https://eips.ethereum.org/EIPS/eip-165[EIP].
66  *
67  * Implementers can declare support of contract interfaces, which can then be
68  * queried by others ({ERC165Checker}).
69  *
70  * For an implementation, see {ERC165}.
71  */
72 interface IERC165 {
73     /**
74      * @dev Returns true if this contract implements the interface defined by
75      * `interfaceId`. See the corresponding
76      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
77      * to learn more about how these ids are created.
78      *
79      * This function call must use less than 30 000 gas.
80      */
81     function supportsInterface(bytes4 interfaceId) external view returns (bool);
82 }
83 
84 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
85 
86 
87 // OpenZeppelin Contracts v4.4.1 (token/ERC721/IERC721.sol)
88 
89 pragma solidity ^0.8.0;
90 
91 
92 /**
93  * @dev Required interface of an ERC721 compliant contract.
94  */
95 interface IERC721 is IERC165 {
96     /**
97      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
98      */
99     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
100 
101     /**
102      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
103      */
104     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
105 
106     /**
107      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
108      */
109     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
110 
111     /**
112      * @dev Returns the number of tokens in ``owner``'s account.
113      */
114     function balanceOf(address owner) external view returns (uint256 balance);
115 
116     /**
117      * @dev Returns the owner of the `tokenId` token.
118      *
119      * Requirements:
120      *
121      * - `tokenId` must exist.
122      */
123     function ownerOf(uint256 tokenId) external view returns (address owner);
124 
125     /**
126      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
127      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
128      *
129      * Requirements:
130      *
131      * - `from` cannot be the zero address.
132      * - `to` cannot be the zero address.
133      * - `tokenId` token must exist and be owned by `from`.
134      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
135      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
136      *
137      * Emits a {Transfer} event.
138      */
139     function safeTransferFrom(
140         address from,
141         address to,
142         uint256 tokenId
143     ) external;
144 
145     /**
146      * @dev Transfers `tokenId` token from `from` to `to`.
147      *
148      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
149      *
150      * Requirements:
151      *
152      * - `from` cannot be the zero address.
153      * - `to` cannot be the zero address.
154      * - `tokenId` token must be owned by `from`.
155      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
156      *
157      * Emits a {Transfer} event.
158      */
159     function transferFrom(
160         address from,
161         address to,
162         uint256 tokenId
163     ) external;
164 
165     /**
166      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
167      * The approval is cleared when the token is transferred.
168      *
169      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
170      *
171      * Requirements:
172      *
173      * - The caller must own the token or be an approved operator.
174      * - `tokenId` must exist.
175      *
176      * Emits an {Approval} event.
177      */
178     function approve(address to, uint256 tokenId) external;
179 
180     /**
181      * @dev Returns the account approved for `tokenId` token.
182      *
183      * Requirements:
184      *
185      * - `tokenId` must exist.
186      */
187     function getApproved(uint256 tokenId) external view returns (address operator);
188 
189     /**
190      * @dev Approve or remove `operator` as an operator for the caller.
191      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
192      *
193      * Requirements:
194      *
195      * - The `operator` cannot be the caller.
196      *
197      * Emits an {ApprovalForAll} event.
198      */
199     function setApprovalForAll(address operator, bool _approved) external;
200 
201     /**
202      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
203      *
204      * See {setApprovalForAll}
205      */
206     function isApprovedForAll(address owner, address operator) external view returns (bool);
207 
208     /**
209      * @dev Safely transfers `tokenId` token from `from` to `to`.
210      *
211      * Requirements:
212      *
213      * - `from` cannot be the zero address.
214      * - `to` cannot be the zero address.
215      * - `tokenId` token must exist and be owned by `from`.
216      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
217      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
218      *
219      * Emits a {Transfer} event.
220      */
221     function safeTransferFrom(
222         address from,
223         address to,
224         uint256 tokenId,
225         bytes calldata data
226     ) external;
227 }
228 
229 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
230 
231 
232 // OpenZeppelin Contracts v4.4.1 (token/ERC721/extensions/IERC721Enumerable.sol)
233 
234 pragma solidity ^0.8.0;
235 
236 
237 /**
238  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
239  * @dev See https://eips.ethereum.org/EIPS/eip-721
240  */
241 interface IERC721Enumerable is IERC721 {
242     /**
243      * @dev Returns the total amount of tokens stored by the contract.
244      */
245     function totalSupply() external view returns (uint256);
246 
247     /**
248      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
249      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
250      */
251     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
252 
253     /**
254      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
255      * Use along with {totalSupply} to enumerate all tokens.
256      */
257     function tokenByIndex(uint256 index) external view returns (uint256);
258 }
259 
260 // File: @openzeppelin/contracts/token/ERC20/IERC20.sol
261 
262 
263 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
264 
265 pragma solidity ^0.8.0;
266 
267 /**
268  * @dev Interface of the ERC20 standard as defined in the EIP.
269  */
270 interface IERC20 {
271     /**
272      * @dev Returns the amount of tokens in existence.
273      */
274     function totalSupply() external view returns (uint256);
275 
276     /**
277      * @dev Returns the amount of tokens owned by `account`.
278      */
279     function balanceOf(address account) external view returns (uint256);
280 
281     /**
282      * @dev Moves `amount` tokens from the caller's account to `recipient`.
283      *
284      * Returns a boolean value indicating whether the operation succeeded.
285      *
286      * Emits a {Transfer} event.
287      */
288     function transfer(address recipient, uint256 amount) external returns (bool);
289 
290     /**
291      * @dev Returns the remaining number of tokens that `spender` will be
292      * allowed to spend on behalf of `owner` through {transferFrom}. This is
293      * zero by default.
294      *
295      * This value changes when {approve} or {transferFrom} are called.
296      */
297     function allowance(address owner, address spender) external view returns (uint256);
298 
299     /**
300      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
301      *
302      * Returns a boolean value indicating whether the operation succeeded.
303      *
304      * IMPORTANT: Beware that changing an allowance with this method brings the risk
305      * that someone may use both the old and the new allowance by unfortunate
306      * transaction ordering. One possible solution to mitigate this race
307      * condition is to first reduce the spender's allowance to 0 and set the
308      * desired value afterwards:
309      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
310      *
311      * Emits an {Approval} event.
312      */
313     function approve(address spender, uint256 amount) external returns (bool);
314 
315     /**
316      * @dev Moves `amount` tokens from `sender` to `recipient` using the
317      * allowance mechanism. `amount` is then deducted from the caller's
318      * allowance.
319      *
320      * Returns a boolean value indicating whether the operation succeeded.
321      *
322      * Emits a {Transfer} event.
323      */
324     function transferFrom(
325         address sender,
326         address recipient,
327         uint256 amount
328     ) external returns (bool);
329 
330     /**
331      * @dev Emitted when `value` tokens are moved from one account (`from`) to
332      * another (`to`).
333      *
334      * Note that `value` may be zero.
335      */
336     event Transfer(address indexed from, address indexed to, uint256 value);
337 
338     /**
339      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
340      * a call to {approve}. `value` is the new allowance.
341      */
342     event Approval(address indexed owner, address indexed spender, uint256 value);
343 }
344 
345 // File: @openzeppelin/contracts/token/ERC20/extensions/IERC20Metadata.sol
346 
347 
348 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
349 
350 pragma solidity ^0.8.0;
351 
352 
353 /**
354  * @dev Interface for the optional metadata functions from the ERC20 standard.
355  *
356  * _Available since v4.1._
357  */
358 interface IERC20Metadata is IERC20 {
359     /**
360      * @dev Returns the name of the token.
361      */
362     function name() external view returns (string memory);
363 
364     /**
365      * @dev Returns the symbol of the token.
366      */
367     function symbol() external view returns (string memory);
368 
369     /**
370      * @dev Returns the decimals places of the token.
371      */
372     function decimals() external view returns (uint8);
373 }
374 
375 // File: @openzeppelin/contracts/utils/Context.sol
376 
377 
378 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
379 
380 pragma solidity ^0.8.0;
381 
382 /**
383  * @dev Provides information about the current execution context, including the
384  * sender of the transaction and its data. While these are generally available
385  * via msg.sender and msg.data, they should not be accessed in such a direct
386  * manner, since when dealing with meta-transactions the account sending and
387  * paying for execution may not be the actual sender (as far as an application
388  * is concerned).
389  *
390  * This contract is only required for intermediate, library-like contracts.
391  */
392 abstract contract Context {
393     function _msgSender() internal view virtual returns (address) {
394         return msg.sender;
395     }
396 
397     function _msgData() internal view virtual returns (bytes calldata) {
398         return msg.data;
399     }
400 }
401 
402 // File: @openzeppelin/contracts/token/ERC20/ERC20.sol
403 
404 
405 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
406 
407 pragma solidity ^0.8.0;
408 
409 
410 
411 
412 /**
413  * @dev Implementation of the {IERC20} interface.
414  *
415  * This implementation is agnostic to the way tokens are created. This means
416  * that a supply mechanism has to be added in a derived contract using {_mint}.
417  * For a generic mechanism see {ERC20PresetMinterPauser}.
418  *
419  * TIP: For a detailed writeup see our guide
420  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
421  * to implement supply mechanisms].
422  *
423  * We have followed general OpenZeppelin Contracts guidelines: functions revert
424  * instead returning `false` on failure. This behavior is nonetheless
425  * conventional and does not conflict with the expectations of ERC20
426  * applications.
427  *
428  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
429  * This allows applications to reconstruct the allowance for all accounts just
430  * by listening to said events. Other implementations of the EIP may not emit
431  * these events, as it isn't required by the specification.
432  *
433  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
434  * functions have been added to mitigate the well-known issues around setting
435  * allowances. See {IERC20-approve}.
436  */
437 contract ERC20 is Context, IERC20, IERC20Metadata {
438     mapping(address => uint256) private _balances;
439 
440     mapping(address => mapping(address => uint256)) private _allowances;
441 
442     uint256 private _totalSupply;
443 
444     string private _name;
445     string private _symbol;
446 
447     /**
448      * @dev Sets the values for {name} and {symbol}.
449      *
450      * The default value of {decimals} is 18. To select a different value for
451      * {decimals} you should overload it.
452      *
453      * All two of these values are immutable: they can only be set once during
454      * construction.
455      */
456     constructor(string memory name_, string memory symbol_) {
457         _name = name_;
458         _symbol = symbol_;
459     }
460 
461     /**
462      * @dev Returns the name of the token.
463      */
464     function name() public view virtual override returns (string memory) {
465         return _name;
466     }
467 
468     /**
469      * @dev Returns the symbol of the token, usually a shorter version of the
470      * name.
471      */
472     function symbol() public view virtual override returns (string memory) {
473         return _symbol;
474     }
475 
476     /**
477      * @dev Returns the number of decimals used to get its user representation.
478      * For example, if `decimals` equals `2`, a balance of `505` tokens should
479      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
480      *
481      * Tokens usually opt for a value of 18, imitating the relationship between
482      * Ether and Wei. This is the value {ERC20} uses, unless this function is
483      * overridden;
484      *
485      * NOTE: This information is only used for _display_ purposes: it in
486      * no way affects any of the arithmetic of the contract, including
487      * {IERC20-balanceOf} and {IERC20-transfer}.
488      */
489     function decimals() public view virtual override returns (uint8) {
490         return 18;
491     }
492 
493     /**
494      * @dev See {IERC20-totalSupply}.
495      */
496     function totalSupply() public view virtual override returns (uint256) {
497         return _totalSupply;
498     }
499 
500     /**
501      * @dev See {IERC20-balanceOf}.
502      */
503     function balanceOf(address account) public view virtual override returns (uint256) {
504         return _balances[account];
505     }
506 
507     /**
508      * @dev See {IERC20-transfer}.
509      *
510      * Requirements:
511      *
512      * - `recipient` cannot be the zero address.
513      * - the caller must have a balance of at least `amount`.
514      */
515     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
516         _transfer(_msgSender(), recipient, amount);
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
530      * Requirements:
531      *
532      * - `spender` cannot be the zero address.
533      */
534     function approve(address spender, uint256 amount) public virtual override returns (bool) {
535         _approve(_msgSender(), spender, amount);
536         return true;
537     }
538 
539     /**
540      * @dev See {IERC20-transferFrom}.
541      *
542      * Emits an {Approval} event indicating the updated allowance. This is not
543      * required by the EIP. See the note at the beginning of {ERC20}.
544      *
545      * Requirements:
546      *
547      * - `sender` and `recipient` cannot be the zero address.
548      * - `sender` must have a balance of at least `amount`.
549      * - the caller must have allowance for ``sender``'s tokens of at least
550      * `amount`.
551      */
552     function transferFrom(
553         address sender,
554         address recipient,
555         uint256 amount
556     ) public virtual override returns (bool) {
557         _transfer(sender, recipient, amount);
558 
559         uint256 currentAllowance = _allowances[sender][_msgSender()];
560         require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
561         unchecked {
562             _approve(sender, _msgSender(), currentAllowance - amount);
563         }
564 
565         return true;
566     }
567 
568     /**
569      * @dev Atomically increases the allowance granted to `spender` by the caller.
570      *
571      * This is an alternative to {approve} that can be used as a mitigation for
572      * problems described in {IERC20-approve}.
573      *
574      * Emits an {Approval} event indicating the updated allowance.
575      *
576      * Requirements:
577      *
578      * - `spender` cannot be the zero address.
579      */
580     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
581         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
582         return true;
583     }
584 
585     /**
586      * @dev Atomically decreases the allowance granted to `spender` by the caller.
587      *
588      * This is an alternative to {approve} that can be used as a mitigation for
589      * problems described in {IERC20-approve}.
590      *
591      * Emits an {Approval} event indicating the updated allowance.
592      *
593      * Requirements:
594      *
595      * - `spender` cannot be the zero address.
596      * - `spender` must have allowance for the caller of at least
597      * `subtractedValue`.
598      */
599     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
600         uint256 currentAllowance = _allowances[_msgSender()][spender];
601         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
602         unchecked {
603             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
604         }
605 
606         return true;
607     }
608 
609     /**
610      * @dev Moves `amount` of tokens from `sender` to `recipient`.
611      *
612      * This internal function is equivalent to {transfer}, and can be used to
613      * e.g. implement automatic token fees, slashing mechanisms, etc.
614      *
615      * Emits a {Transfer} event.
616      *
617      * Requirements:
618      *
619      * - `sender` cannot be the zero address.
620      * - `recipient` cannot be the zero address.
621      * - `sender` must have a balance of at least `amount`.
622      */
623     function _transfer(
624         address sender,
625         address recipient,
626         uint256 amount
627     ) internal virtual {
628         require(sender != address(0), "ERC20: transfer from the zero address");
629         require(recipient != address(0), "ERC20: transfer to the zero address");
630 
631         _beforeTokenTransfer(sender, recipient, amount);
632 
633         uint256 senderBalance = _balances[sender];
634         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
635         unchecked {
636             _balances[sender] = senderBalance - amount;
637         }
638         _balances[recipient] += amount;
639 
640         emit Transfer(sender, recipient, amount);
641 
642         _afterTokenTransfer(sender, recipient, amount);
643     }
644 
645     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
646      * the total supply.
647      *
648      * Emits a {Transfer} event with `from` set to the zero address.
649      *
650      * Requirements:
651      *
652      * - `account` cannot be the zero address.
653      */
654     function _mint(address account, uint256 amount) internal virtual {
655         require(account != address(0), "ERC20: mint to the zero address");
656 
657         _beforeTokenTransfer(address(0), account, amount);
658 
659         _totalSupply += amount;
660         _balances[account] += amount;
661         emit Transfer(address(0), account, amount);
662 
663         _afterTokenTransfer(address(0), account, amount);
664     }
665 
666     /**
667      * @dev Destroys `amount` tokens from `account`, reducing the
668      * total supply.
669      *
670      * Emits a {Transfer} event with `to` set to the zero address.
671      *
672      * Requirements:
673      *
674      * - `account` cannot be the zero address.
675      * - `account` must have at least `amount` tokens.
676      */
677     function _burn(address account, uint256 amount) internal virtual {
678         require(account != address(0), "ERC20: burn from the zero address");
679 
680         _beforeTokenTransfer(account, address(0), amount);
681 
682         uint256 accountBalance = _balances[account];
683         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
684         unchecked {
685             _balances[account] = accountBalance - amount;
686         }
687         _totalSupply -= amount;
688 
689         emit Transfer(account, address(0), amount);
690 
691         _afterTokenTransfer(account, address(0), amount);
692     }
693 
694     /**
695      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
696      *
697      * This internal function is equivalent to `approve`, and can be used to
698      * e.g. set automatic allowances for certain subsystems, etc.
699      *
700      * Emits an {Approval} event.
701      *
702      * Requirements:
703      *
704      * - `owner` cannot be the zero address.
705      * - `spender` cannot be the zero address.
706      */
707     function _approve(
708         address owner,
709         address spender,
710         uint256 amount
711     ) internal virtual {
712         require(owner != address(0), "ERC20: approve from the zero address");
713         require(spender != address(0), "ERC20: approve to the zero address");
714 
715         _allowances[owner][spender] = amount;
716         emit Approval(owner, spender, amount);
717     }
718 
719     /**
720      * @dev Hook that is called before any transfer of tokens. This includes
721      * minting and burning.
722      *
723      * Calling conditions:
724      *
725      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
726      * will be transferred to `to`.
727      * - when `from` is zero, `amount` tokens will be minted for `to`.
728      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
729      * - `from` and `to` are never both zero.
730      *
731      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
732      */
733     function _beforeTokenTransfer(
734         address from,
735         address to,
736         uint256 amount
737     ) internal virtual {}
738 
739     /**
740      * @dev Hook that is called after any transfer of tokens. This includes
741      * minting and burning.
742      *
743      * Calling conditions:
744      *
745      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
746      * has been transferred to `to`.
747      * - when `from` is zero, `amount` tokens have been minted for `to`.
748      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
749      * - `from` and `to` are never both zero.
750      *
751      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
752      */
753     function _afterTokenTransfer(
754         address from,
755         address to,
756         uint256 amount
757     ) internal virtual {}
758 }
759 
760 // File: @openzeppelin/contracts/security/Pausable.sol
761 
762 
763 // OpenZeppelin Contracts v4.4.1 (security/Pausable.sol)
764 
765 pragma solidity ^0.8.0;
766 
767 
768 /**
769  * @dev Contract module which allows children to implement an emergency stop
770  * mechanism that can be triggered by an authorized account.
771  *
772  * This module is used through inheritance. It will make available the
773  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
774  * the functions of your contract. Note that they will not be pausable by
775  * simply including this module, only once the modifiers are put in place.
776  */
777 abstract contract Pausable is Context {
778     /**
779      * @dev Emitted when the pause is triggered by `account`.
780      */
781     event Paused(address account);
782 
783     /**
784      * @dev Emitted when the pause is lifted by `account`.
785      */
786     event Unpaused(address account);
787 
788     bool private _paused;
789 
790     /**
791      * @dev Initializes the contract in unpaused state.
792      */
793     constructor() {
794         _paused = false;
795     }
796 
797     /**
798      * @dev Returns true if the contract is paused, and false otherwise.
799      */
800     function paused() public view virtual returns (bool) {
801         return _paused;
802     }
803 
804     /**
805      * @dev Modifier to make a function callable only when the contract is not paused.
806      *
807      * Requirements:
808      *
809      * - The contract must not be paused.
810      */
811     modifier whenNotPaused() {
812         require(!paused(), "Pausable: paused");
813         _;
814     }
815 
816     /**
817      * @dev Modifier to make a function callable only when the contract is paused.
818      *
819      * Requirements:
820      *
821      * - The contract must be paused.
822      */
823     modifier whenPaused() {
824         require(paused(), "Pausable: not paused");
825         _;
826     }
827 
828     /**
829      * @dev Triggers stopped state.
830      *
831      * Requirements:
832      *
833      * - The contract must not be paused.
834      */
835     function _pause() internal virtual whenNotPaused {
836         _paused = true;
837         emit Paused(_msgSender());
838     }
839 
840     /**
841      * @dev Returns to normal state.
842      *
843      * Requirements:
844      *
845      * - The contract must be paused.
846      */
847     function _unpause() internal virtual whenPaused {
848         _paused = false;
849         emit Unpaused(_msgSender());
850     }
851 }
852 
853 // File: @openzeppelin/contracts/access/Ownable.sol
854 
855 
856 // OpenZeppelin Contracts v4.4.1 (access/Ownable.sol)
857 
858 pragma solidity ^0.8.0;
859 
860 
861 /**
862  * @dev Contract module which provides a basic access control mechanism, where
863  * there is an account (an owner) that can be granted exclusive access to
864  * specific functions.
865  *
866  * By default, the owner account will be the one that deploys the contract. This
867  * can later be changed with {transferOwnership}.
868  *
869  * This module is used through inheritance. It will make available the modifier
870  * `onlyOwner`, which can be applied to your functions to restrict their use to
871  * the owner.
872  */
873 abstract contract Ownable is Context {
874     address private _owner;
875 
876     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
877 
878     /**
879      * @dev Initializes the contract setting the deployer as the initial owner.
880      */
881     constructor() {
882         _transferOwnership(_msgSender());
883     }
884 
885     /**
886      * @dev Returns the address of the current owner.
887      */
888     function owner() public view virtual returns (address) {
889         return _owner;
890     }
891 
892     /**
893      * @dev Throws if called by any account other than the owner.
894      */
895     modifier onlyOwner() {
896         require(owner() == _msgSender(), "Ownable: caller is not the owner");
897         _;
898     }
899 
900     /**
901      * @dev Leaves the contract without owner. It will not be possible to call
902      * `onlyOwner` functions anymore. Can only be called by the current owner.
903      *
904      * NOTE: Renouncing ownership will leave the contract without an owner,
905      * thereby removing any functionality that is only available to the owner.
906      */
907     function renounceOwnership() public virtual onlyOwner {
908         _transferOwnership(address(0));
909     }
910 
911     /**
912      * @dev Transfers ownership of the contract to a new account (`newOwner`).
913      * Can only be called by the current owner.
914      */
915     function transferOwnership(address newOwner) public virtual onlyOwner {
916         require(newOwner != address(0), "Ownable: new owner is the zero address");
917         _transferOwnership(newOwner);
918     }
919 
920     /**
921      * @dev Transfers ownership of the contract to a new account (`newOwner`).
922      * Internal function without access restriction.
923      */
924     function _transferOwnership(address newOwner) internal virtual {
925         address oldOwner = _owner;
926         _owner = newOwner;
927         emit OwnershipTransferred(oldOwner, newOwner);
928     }
929 }
930 
931 // File: contracts/RentToken.sol
932 
933 
934 pragma solidity ^0.8.0;
935 
936 
937 
938 
939 
940 
941 contract RentToken is ERC20, Ownable, Pausable {
942     using MerkleProof for bytes32[];
943 
944     uint256 constant public MAX_SUPPLY = 132407400 ether; 
945 	uint256 constant public INTERVAL = 86400; 
946 
947     bytes32 public merkleOne; // merkle tree roots to prove tier information
948     bytes32 public merkleTwo;
949     bytes32 public merkleThree;
950     bool public stateLocked = false;
951 
952 	mapping(address => uint256) private lastUpdate; // record when user interacts with contract
953     mapping(uint256 => uint256) private NFTReward; // maps token id to daily reward
954 
955 	IERC721Enumerable public NFTContract;  
956 
957 	event RewardPaid(address indexed user, uint256 reward); 
958  
959     constructor(address NFTContractAddress) ERC20("TheLandDAO Rent", "RENT") {
960 
961         setNFTContractAddress(NFTContractAddress);
962         setMerkleRoots(
963             0x20601687dba511bb55c7117c2eaf5da3f978ff2092794b653fcd503928548dd8,
964             0x62eabcc3369785536a90efb26ad0f463cd7d14a92b1ea53d6bfbe502cbf0097f,
965             0xd4efe9e8d38c0bd881d7788a174a1e0b0c1e38bd4c0b6960299d8a7fe46e70e7
966         );
967         pause();
968     }
969 
970     /* * * * * * * * * * * * * * * OWNER ONLY FUNCTIONS * * * * * * * * * * * * * * */
971 
972     // prevents vital data from being altered
973     function lockState() public onlyOwner {
974         require(address(NFTContract) != address(0));
975         require(merkleOne != 0 && merkleTwo != 0 && merkleThree != 0);
976 
977         stateLocked = true;
978     }
979 
980     // stop users from interacting with the contract
981     function pause() public onlyOwner { 
982 
983         _pause(); 
984     }
985  
986     // Set the address for the NFT contract
987     function setNFTContractAddress(address _NFTContract) public onlyOwner {
988         require(!stateLocked, "Contract can no longer be changed");
989 
990         NFTContract = IERC721Enumerable(_NFTContract);
991     }
992 
993     // record the root hashes of merkle trees storing tier reward information
994     function setMerkleRoots(bytes32 _tierOne, bytes32 _tierTwo, bytes32 _tierThree) public onlyOwner {
995         require(!stateLocked, "Contract can no longer be changed");
996 
997         merkleOne = _tierOne;
998         merkleTwo = _tierTwo;
999         merkleThree = _tierThree;
1000     }
1001 
1002     // allow users to interact with contract
1003     function unpause() public onlyOwner { 
1004         require(address(NFTContract) != address(0));
1005         require(merkleOne != 0 && merkleTwo != 0 && merkleThree != 0);
1006 
1007         _unpause(); 
1008     } 
1009 
1010     /* * * * * * * * * * * * * * * GASLESS GET FUNCTIONS * * * * * * * * * * * * * * */
1011 
1012     // return the tier based reward of a token ID
1013     // can only be called after token reward has been recorded onchain (call startEarningRent or proveTier)
1014     function getDailyReward(uint256 tokenId) external view returns(uint256) {
1015         require(isProved(tokenId), "Tier has not yet been proved.");
1016 
1017         return NFTReward[tokenId];
1018     }
1019 
1020     // returns the last timestamp user interacted with the contract
1021     // needs to be non zero in order to claimReward (call startEarningRent)
1022     function getLastUpdate(address user) external view returns(uint256) {
1023         
1024         return lastUpdate[user];
1025     }
1026 
1027     // return the number of LandDao NFTs user owns
1028     function getNFTBalance(address user) public view returns (uint256) {
1029 
1030         return NFTContract.balanceOf(user);
1031     }
1032 
1033     // returns the LandDao NFT token IDs user owns
1034     function getNFTIds(address user) public view returns (uint256[] memory _tokensOfOwner) {
1035         _tokensOfOwner = new uint256[](getNFTBalance(user));
1036 
1037         for (uint256 i = 0; i < getNFTBalance(user); i++) { 
1038             _tokensOfOwner[i] = NFTContract.tokenOfOwnerByIndex(user, i);
1039         }
1040     }
1041 
1042     // return true if NFT at token ID has been recorded onchain
1043     // user token ID's need to be proved before claimReward (call startEarningRent or proveTier)
1044     function isProved(uint256 tokenId) public view returns (bool proved) {
1045         
1046         if (NFTReward[tokenId] > 0) {
1047             proved = true;
1048         } else {
1049             proved = false;
1050         }
1051 
1052         return proved;
1053     }
1054     
1055     // return the rewards user could claim at current timestamp
1056     // can only be called after lastUpdate[user] > 0, and NFT token IDs have been proved (call startEarningRent)
1057     function getPendingReward(address user) public view returns(uint256) { 
1058         uint256 dailyReward = 0;
1059         uint256[] memory NFTIds = getNFTIds(user);
1060         
1061         // sum each daily NFT reward owned by user
1062         for (uint256 i = 0; i < getNFTBalance(user); i++) { 
1063             require(isProved(NFTIds[i]), "Make sure your NFTs have been initalized by calling isProved(ID)");
1064 
1065             dailyReward = dailyReward + (NFTReward[NFTIds[i]]); 
1066         }
1067 
1068         // (block.timestamp - lastUpdate[user]) / INTERVAL = number of days
1069         // dailyReward = sum of each NFT daily reward
1070         // 1 ether = 1000000000000000000
1071         return (dailyReward * 1 ether * (block.timestamp - lastUpdate[user])) / INTERVAL;
1072     }
1073 
1074     /* * * * * * * * * * * * * * * USER GAS FUNCTIONS * * * * * * * * * * * * * * */
1075 
1076     // Pay out the holder
1077     // can only be called after lastUpdate[user] > 0, and NFT token IDs have been proved (call startEarningRent)
1078     function claimReward() external whenNotPaused { 
1079         require(totalSupply() < MAX_SUPPLY, "RENT collection is over"); // RENT earned will not be claimable after max RENT has been minted
1080         require(lastUpdate[msg.sender] != 0, "If you have a LAND token, call startEarningRent"); 
1081  
1082         uint256 currentReward = getPendingReward(msg.sender);
1083 
1084         pay(msg.sender, currentReward);
1085 
1086         lastUpdate[msg.sender] = block.timestamp; 
1087     }
1088 
1089     // check each merkle tree for NFT id, and record result onchain
1090     // user calls this when they have already startEarningRent, but have a new NFT so that isProved(NFT) = false
1091     function proveTier(bytes32[] calldata _merkleProof, bytes32 tokenHash, uint256 tokenId) public whenNotPaused {
1092         require(tokenId <= 8888, "Invalid token ID.");
1093         require(msg.sender == NFTContract.ownerOf(tokenId) || msg.sender == address(this)); // make sure this function is only called by owner of token ID
1094 
1095         if (tokenId <= 1500) { // is genesis
1096             NFTReward[tokenId] = 10;
1097         } else if (MerkleProof.verify(_merkleProof, merkleOne, tokenHash)) { // is tier 1
1098             NFTReward[tokenId] = 4;
1099         } else if (MerkleProof.verify(_merkleProof, merkleTwo, tokenHash)) { // is tier 2
1100             NFTReward[tokenId] = 3;
1101         } else if (MerkleProof.verify(_merkleProof, merkleThree, tokenHash)) { // is tier 3
1102             NFTReward[tokenId] = 2;
1103         } else {
1104             revert();
1105         }
1106     }
1107 
1108     // user is added to lastUpdate before rewards can be calculated 
1109     // prove and record nft tier information
1110     // merkle proofs sent from frontend 
1111     function startEarningRent(
1112         bytes32[][] calldata _merkleProofs, // array of proofs (each proof is array)
1113         bytes32[] calldata _tokenHashes 
1114     ) external whenNotPaused {
1115         require(getNFTBalance(msg.sender) > 0, "Buy a LandDao NFT to start earning RENT");
1116 
1117         uint256[] memory tokenIds = getNFTIds(msg.sender);
1118         
1119         // prove tiers, mint airdrop to users who prove tiers
1120         for (uint256 i = 0; i < tokenIds.length; i++) {
1121             if (!isProved(tokenIds[i])) {
1122                 proveTier(_merkleProofs[i], _tokenHashes[i], tokenIds[i]);
1123                 mintAirdrop(msg.sender, tokenIds[i]);
1124             }
1125         }
1126 
1127         lastUpdate[msg.sender] = block.timestamp;
1128     }
1129 
1130     /* * * * * * * * * * * * * * * INTERNAL HELPER FUNCTIONS * * * * * * * * * * * * * * */
1131 
1132     // when a token is proved during startEarningRent, payout airdrop to holder
1133     function mintAirdrop(address user, uint256 tokenId) internal whenNotPaused {
1134         require(totalSupply() < MAX_SUPPLY, "RENT collection is over"); // RENT earned will not be claimable after max RENT has been minted.
1135  
1136         uint256 startBlock;
1137         if (tokenId <= 1500) { 
1138             startBlock = 1640995200; // jan 1 2022
1139         } else {
1140             startBlock = 1642291200; // jan 16 2022
1141         }
1142         uint256 currentReward = (NFTReward[tokenId] * 1 ether * (block.timestamp - startBlock)) / INTERVAL;
1143 
1144         pay(user, currentReward);
1145     }
1146     
1147     // mints the user appropriate amount of tokens
1148     function pay(address user, uint256 reward) internal whenNotPaused {
1149 
1150         if (totalSupply() + reward <= MAX_SUPPLY) { // make sure claim does not exceed total supply
1151 
1152             _mint(user, reward); // erc20 mint updates totalSupply
1153 
1154         } else { // supply + rewards > max supply, so give claimer less rewards 
1155             reward = MAX_SUPPLY - totalSupply();
1156             _mint(user, reward);
1157         }
1158 
1159         emit RewardPaid(user, reward);
1160     }
1161 }