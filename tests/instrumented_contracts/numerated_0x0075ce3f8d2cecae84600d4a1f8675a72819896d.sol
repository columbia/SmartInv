1 // File: contracts/library/IERC20.sol
2 
3 
4 // OpenZeppelin Contracts v4.4.1 (token/ERC20/IERC20.sol)
5 
6 pragma solidity ^0.8.0;
7 
8 /**
9  * @dev Interface of the ERC20 standard as defined in the EIP.
10  */
11 interface IERC20 {
12     /**
13      * @dev Returns the amount of tokens in existence.
14      */
15     function totalSupply() external view returns (uint256);
16 
17     /**
18      * @dev Returns the amount of tokens owned by `account`.
19      */
20     function balanceOf(address account) external view returns (uint256);
21 
22     /**
23      * @dev Moves `amount` tokens from the caller's account to `recipient`.
24      *
25      * Returns a boolean value indicating whether the operation succeeded.
26      *
27      * Emits a {Transfer} event.
28      */
29     function transfer(address recipient, uint256 amount) external returns (bool);
30 
31     /**
32      * @dev Returns the remaining number of tokens that `spender` will be
33      * allowed to spend on behalf of `owner` through {transferFrom}. This is
34      * zero by default.
35      *
36      * This value changes when {approve} or {transferFrom} are called.
37      */
38     function allowance(address owner, address spender) external view returns (uint256);
39 
40     /**
41      * @dev Sets `amount` as the allowance of `spender` over the caller's tokens.
42      *
43      * Returns a boolean value indicating whether the operation succeeded.
44      *
45      * IMPORTANT: Beware that changing an allowance with this method brings the risk
46      * that someone may use both the old and the new allowance by unfortunate
47      * transaction ordering. One possible solution to mitigate this race
48      * condition is to first reduce the spender's allowance to 0 and set the
49      * desired value afterwards:
50      * https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
51      *
52      * Emits an {Approval} event.
53      */
54     function approve(address spender, uint256 amount) external returns (bool);
55 
56     /**
57      * @dev Moves `amount` tokens from `sender` to `recipient` using the
58      * allowance mechanism. `amount` is then deducted from the caller's
59      * allowance.
60      *
61      * Returns a boolean value indicating whether the operation succeeded.
62      *
63      * Emits a {Transfer} event.
64      */
65     function transferFrom(
66         address sender,
67         address recipient,
68         uint256 amount
69     ) external returns (bool);
70 
71     /**
72      * @dev Emitted when `value` tokens are moved from one account (`from`) to
73      * another (`to`).
74      *
75      * Note that `value` may be zero.
76      */
77     event Transfer(address indexed from, address indexed to, uint256 value);
78 
79     /**
80      * @dev Emitted when the allowance of a `spender` for an `owner` is set by
81      * a call to {approve}. `value` is the new allowance.
82      */
83     event Approval(address indexed owner, address indexed spender, uint256 value);
84 }
85 // File: contracts/library/IERC20Metadata.sol
86 
87 
88 // OpenZeppelin Contracts v4.4.1 (token/ERC20/extensions/IERC20Metadata.sol)
89 
90 pragma solidity ^0.8.0;
91 
92 
93 /**
94  * @dev Interface for the optional metadata functions from the ERC20 standard.
95  *
96  * _Available since v4.1._
97  */
98 interface IERC20Metadata is IERC20 {
99     /**
100      * @dev Returns the name of the token.
101      */
102     function name() external view returns (string memory);
103 
104     /**
105      * @dev Returns the symbol of the token.
106      */
107     function symbol() external view returns (string memory);
108 
109     /**
110      * @dev Returns the decimals places of the token.
111      */
112     function decimals() external view returns (uint8);
113 }
114 // File: contracts/library/IERC721Receiver.sol
115 
116 
117 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
118 
119 
120 
121 pragma solidity ^0.8.0;
122 
123 /**
124  * @title ERC721 token receiver interface
125  * @dev Interface for any contract that wants to support safeTransfers
126  * from ERC721 asset contracts.
127  */
128 interface IERC721Receiver {
129     /**
130      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
131      * by `operator` from `from`, this function is called.
132      *
133      * It must return its Solidity selector to confirm the token transfer.
134      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
135      *
136      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
137      */
138     function onERC721Received(
139         address operator,
140         address from,
141         uint256 tokenId,
142         bytes calldata data
143     ) external returns (bytes4);
144 }
145 
146 // File: contracts/library/Strings.sol
147 
148 
149 
150 pragma solidity ^0.8.0;
151 
152 /**
153  * @dev String operations.
154  */
155 library Strings {
156     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
157 
158     /**
159      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
160      */
161     function toString(uint256 value) internal pure returns (string memory) {
162         // Inspired by OraclizeAPI's implementation - MIT licence
163         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
164 
165         if (value == 0) {
166             return "0";
167         }
168         uint256 temp = value;
169         uint256 digits;
170         while (temp != 0) {
171             digits++;
172             temp /= 10;
173         }
174         bytes memory buffer = new bytes(digits);
175         while (value != 0) {
176             digits -= 1;
177             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
178             value /= 10;
179         }
180         return string(buffer);
181     }
182 
183     /**
184      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
185      */
186     function toHexString(uint256 value) internal pure returns (string memory) {
187         if (value == 0) {
188             return "0x00";
189         }
190         uint256 temp = value;
191         uint256 length = 0;
192         while (temp != 0) {
193             length++;
194             temp >>= 8;
195         }
196         return toHexString(value, length);
197     }
198 
199     /**
200      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
201      */
202     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
203         bytes memory buffer = new bytes(2 * length + 2);
204         buffer[0] = "0";
205         buffer[1] = "x";
206         for (uint256 i = 2 * length + 1; i > 1; --i) {
207             buffer[i] = _HEX_SYMBOLS[value & 0xf];
208             value >>= 4;
209         }
210         require(value == 0, "Strings: hex length insufficient");
211         return string(buffer);
212     }
213 }
214 // File: contracts/library/IERC165.sol
215 
216 
217 
218 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
219 
220 
221 
222 pragma solidity ^0.8.0;
223 
224 /**
225  * @dev Interface of the ERC165 standard, as defined in the
226  * https://eips.ethereum.org/EIPS/eip-165[EIP].
227  *
228  * Implementers can declare support of contract interfaces, which can then be
229  * queried by others ({ERC165Checker}).
230  *
231  * For an implementation, see {ERC165}.
232  */
233 interface IERC165 {
234     /**
235      * @dev Returns true if this contract implements the interface defined by
236      * `interfaceId`. See the corresponding
237      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
238      * to learn more about how these ids are created.
239      *
240      * This function call must use less than 30 000 gas.
241      */
242     function supportsInterface(bytes4 interfaceId) external view returns (bool);
243 }
244 // File: contracts/library/IERC721.sol
245 
246 
247 
248 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
249 
250 
251 
252 pragma solidity ^0.8.0;
253 
254 
255 /**
256  * @dev Required interface of an ERC721 compliant contract.
257  */
258 interface IERC721 is IERC165 {
259     /**
260      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
261      */
262     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
263 
264     /**
265      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
266      */
267     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
268 
269     /**
270      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
271      */
272     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
273 
274     /**
275      * @dev Returns the number of tokens in ``owner``'s account.
276      */
277     function balanceOf(address owner) external view returns (uint256 balance);
278 
279     /**
280      * @dev Returns the owner of the `tokenId` token.
281      *
282      * Requirements:
283      *
284      * - `tokenId` must exist.
285      */
286     function ownerOf(uint256 tokenId) external view returns (address owner);
287 
288     /**
289      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
290      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
291      *
292      * Requirements:
293      *
294      * - `from` cannot be the zero address.
295      * - `to` cannot be the zero address.
296      * - `tokenId` token must exist and be owned by `from`.
297      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
298      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
299      *
300      * Emits a {Transfer} event.
301      */
302     function safeTransferFrom(
303         address from,
304         address to,
305         uint256 tokenId
306     ) external;
307 
308     /**
309      * @dev Transfers `tokenId` token from `from` to `to`.
310      *
311      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
312      *
313      * Requirements:
314      *
315      * - `from` cannot be the zero address.
316      * - `to` cannot be the zero address.
317      * - `tokenId` token must be owned by `from`.
318      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
319      *
320      * Emits a {Transfer} event.
321      */
322     function transferFrom(
323         address from,
324         address to,
325         uint256 tokenId
326     ) external;
327 
328     /**
329      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
330      * The approval is cleared when the token is transferred.
331      *
332      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
333      *
334      * Requirements:
335      *
336      * - The caller must own the token or be an approved operator.
337      * - `tokenId` must exist.
338      *
339      * Emits an {Approval} event.
340      */
341     function approve(address to, uint256 tokenId) external;
342 
343     /**
344      * @dev Returns the account approved for `tokenId` token.
345      *
346      * Requirements:
347      *
348      * - `tokenId` must exist.
349      */
350     function getApproved(uint256 tokenId) external view returns (address operator);
351 
352     /**
353      * @dev Approve or remove `operator` as an operator for the caller.
354      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
355      *
356      * Requirements:
357      *
358      * - The `operator` cannot be the caller.
359      *
360      * Emits an {ApprovalForAll} event.
361      */
362     function setApprovalForAll(address operator, bool _approved) external;
363 
364     /**
365      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
366      *
367      * See {setApprovalForAll}
368      */
369     function isApprovedForAll(address owner, address operator) external view returns (bool);
370 
371     /**
372      * @dev Safely transfers `tokenId` token from `from` to `to`.
373      *
374      * Requirements:
375      *
376      * - `from` cannot be the zero address.
377      * - `to` cannot be the zero address.
378      * - `tokenId` token must exist and be owned by `from`.
379      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
380      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
381      *
382      * Emits a {Transfer} event.
383      */
384     function safeTransferFrom(
385         address from,
386         address to,
387         uint256 tokenId,
388         bytes calldata data
389     ) external;
390 }
391 // File: contracts/library/IERC721Enumerable.sol
392 
393 
394 
395 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Enumerable.sol
396 
397 
398 
399 pragma solidity ^0.8.0;
400 
401 
402 /**
403  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
404  * @dev See https://eips.ethereum.org/EIPS/eip-721
405  */
406 interface IERC721Enumerable is IERC721 {
407     /**
408      * @dev Returns the total amount of tokens stored by the contract.
409      */
410     function totalSupply() external view returns (uint256);
411 
412     /**
413      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
414      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
415      */
416     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
417 
418     /**
419      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
420      * Use along with {totalSupply} to enumerate all tokens.
421      */
422     function tokenByIndex(uint256 index) external view returns (uint256);
423 }
424 // File: contracts/library/IERC721Metadata.sol
425 
426 
427 
428 // File: @openzeppelin/contracts/token/ERC721/extensions/IERC721Metadata.sol
429 
430 
431 
432 pragma solidity ^0.8.0;
433 
434 
435 /**
436  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
437  * @dev See https://eips.ethereum.org/EIPS/eip-721
438  */
439 interface IERC721Metadata is IERC721 {
440     /**
441      * @dev Returns the token collection name.
442      */
443     function name() external view returns (string memory);
444 
445     /**
446      * @dev Returns the token collection symbol.
447      */
448     function symbol() external view returns (string memory);
449 
450     /**
451      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
452      */
453     function tokenURI(uint256 tokenId) external view returns (string memory);
454 }
455 // File: contracts/library/ERC165.sol
456 
457 
458 
459 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
460 
461 
462 
463 pragma solidity ^0.8.0;
464 
465 
466 /**
467  * @dev Implementation of the {IERC165} interface.
468  *
469  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
470  * for the additional interface id that will be supported. For example:
471  *
472  * ```solidity
473  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
474  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
475  * }
476  * ```
477  *
478  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
479  */
480 abstract contract ERC165 is IERC165 {
481     /**
482      * @dev See {IERC165-supportsInterface}.
483      */
484     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
485         return interfaceId == type(IERC165).interfaceId;
486     }
487 }
488 // File: contracts/library/Context.sol
489 
490 
491 
492 // File: @openzeppelin/contracts/utils/Context.sol
493 
494 
495 
496 pragma solidity ^0.8.0;
497 
498 /**
499  * @dev Provides information about the current execution context, including the
500  * sender of the transaction and its data. While these are generally available
501  * via msg.sender and msg.data, they should not be accessed in such a direct
502  * manner, since when dealing with meta-transactions the account sending and
503  * paying for execution may not be the actual sender (as far as an application
504  * is concerned).
505  *
506  * This contract is only required for intermediate, library-like contracts.
507  */
508 abstract contract Context {
509     function _msgSender() internal view virtual returns (address) {
510         return msg.sender;
511     }
512 
513     function _msgData() internal view virtual returns (bytes calldata) {
514         return msg.data;
515     }
516 }
517 // File: contracts/library/ERC20.sol
518 
519 
520 // OpenZeppelin Contracts v4.4.1 (token/ERC20/ERC20.sol)
521 
522 pragma solidity ^0.8.0;
523 
524 
525 
526 
527 /**
528  * @dev Implementation of the {IERC20} interface.
529  *
530  * This implementation is agnostic to the way tokens are created. This means
531  * that a supply mechanism has to be added in a derived contract using {_mint}.
532  * For a generic mechanism see {ERC20PresetMinterPauser}.
533  *
534  * TIP: For a detailed writeup see our guide
535  * https://forum.zeppelin.solutions/t/how-to-implement-erc20-supply-mechanisms/226[How
536  * to implement supply mechanisms].
537  *
538  * We have followed general OpenZeppelin Contracts guidelines: functions revert
539  * instead returning `false` on failure. This behavior is nonetheless
540  * conventional and does not conflict with the expectations of ERC20
541  * applications.
542  *
543  * Additionally, an {Approval} event is emitted on calls to {transferFrom}.
544  * This allows applications to reconstruct the allowance for all accounts just
545  * by listening to said events. Other implementations of the EIP may not emit
546  * these events, as it isn't required by the specification.
547  *
548  * Finally, the non-standard {decreaseAllowance} and {increaseAllowance}
549  * functions have been added to mitigate the well-known issues around setting
550  * allowances. See {IERC20-approve}.
551  */
552 contract ERC20 is Context, IERC20, IERC20Metadata {
553     mapping(address => uint256) private _balances;
554 
555     mapping(address => mapping(address => uint256)) private _allowances;
556 
557     uint256 private _totalSupply;
558 
559     string private _name;
560     string private _symbol;
561 
562     /**
563      * @dev Sets the values for {name} and {symbol}.
564      *
565      * The default value of {decimals} is 18. To select a different value for
566      * {decimals} you should overload it.
567      *
568      * All two of these values are immutable: they can only be set once during
569      * construction.
570      */
571     constructor(string memory name_, string memory symbol_) {
572         _name = name_;
573         _symbol = symbol_;
574     }
575 
576     /**
577      * @dev Returns the name of the token.
578      */
579     function name() public view virtual override returns (string memory) {
580         return _name;
581     }
582 
583     /**
584      * @dev Returns the symbol of the token, usually a shorter version of the
585      * name.
586      */
587     function symbol() public view virtual override returns (string memory) {
588         return _symbol;
589     }
590 
591     /**
592      * @dev Returns the number of decimals used to get its user representation.
593      * For example, if `decimals` equals `2`, a balance of `505` tokens should
594      * be displayed to a user as `5.05` (`505 / 10 ** 2`).
595      *
596      * Tokens usually opt for a value of 18, imitating the relationship between
597      * Ether and Wei. This is the value {ERC20} uses, unless this function is
598      * overridden;
599      *
600      * NOTE: This information is only used for _display_ purposes: it in
601      * no way affects any of the arithmetic of the contract, including
602      * {IERC20-balanceOf} and {IERC20-transfer}.
603      */
604     function decimals() public view virtual override returns (uint8) {
605         return 18;
606     }
607 
608     /**
609      * @dev See {IERC20-totalSupply}.
610      */
611     function totalSupply() public view virtual override returns (uint256) {
612         return _totalSupply;
613     }
614 
615     /**
616      * @dev See {IERC20-balanceOf}.
617      */
618     function balanceOf(address account) public view virtual override returns (uint256) {
619         return _balances[account];
620     }
621 
622     /**
623      * @dev See {IERC20-transfer}.
624      *
625      * Requirements:
626      *
627      * - `recipient` cannot be the zero address.
628      * - the caller must have a balance of at least `amount`.
629      */
630     function transfer(address recipient, uint256 amount) public virtual override returns (bool) {
631         _transfer(_msgSender(), recipient, amount);
632         return true;
633     }
634 
635     /**
636      * @dev See {IERC20-allowance}.
637      */
638     function allowance(address owner, address spender) public view virtual override returns (uint256) {
639         return _allowances[owner][spender];
640     }
641 
642     /**
643      * @dev See {IERC20-approve}.
644      *
645      * NOTE: If `amount` is the maximum `uint256`, the allowance is not updated on
646      * `transferFrom`. This is semantically equivalent to an infinite approval.
647      *
648      * Requirements:
649      *
650      * - `spender` cannot be the zero address.
651      */
652     function approve(address spender, uint256 amount) public virtual override returns (bool) {
653         _approve(_msgSender(), spender, amount);
654         return true;
655     }
656 
657     /**
658      * @dev See {IERC20-transferFrom}.
659      *
660      * Emits an {Approval} event indicating the updated allowance. This is not
661      * required by the EIP. See the note at the beginning of {ERC20}.
662      *
663      * NOTE: Does not update the allowance if the current allowance
664      * is the maximum `uint256`.
665      *
666      * Requirements:
667      *
668      * - `sender` and `recipient` cannot be the zero address.
669      * - `sender` must have a balance of at least `amount`.
670      * - the caller must have allowance for ``sender``'s tokens of at least
671      * `amount`.
672      */
673     function transferFrom(
674         address sender,
675         address recipient,
676         uint256 amount
677     ) public virtual override returns (bool) {
678         uint256 currentAllowance = _allowances[sender][_msgSender()];
679         if (currentAllowance != type(uint256).max) {
680             require(currentAllowance >= amount, "ERC20: transfer amount exceeds allowance");
681             unchecked {
682                 _approve(sender, _msgSender(), currentAllowance - amount);
683             }
684         }
685 
686         _transfer(sender, recipient, amount);
687 
688         return true;
689     }
690 
691     /**
692      * @dev Atomically increases the allowance granted to `spender` by the caller.
693      *
694      * This is an alternative to {approve} that can be used as a mitigation for
695      * problems described in {IERC20-approve}.
696      *
697      * Emits an {Approval} event indicating the updated allowance.
698      *
699      * Requirements:
700      *
701      * - `spender` cannot be the zero address.
702      */
703     function increaseAllowance(address spender, uint256 addedValue) public virtual returns (bool) {
704         _approve(_msgSender(), spender, _allowances[_msgSender()][spender] + addedValue);
705         return true;
706     }
707 
708     /**
709      * @dev Atomically decreases the allowance granted to `spender` by the caller.
710      *
711      * This is an alternative to {approve} that can be used as a mitigation for
712      * problems described in {IERC20-approve}.
713      *
714      * Emits an {Approval} event indicating the updated allowance.
715      *
716      * Requirements:
717      *
718      * - `spender` cannot be the zero address.
719      * - `spender` must have allowance for the caller of at least
720      * `subtractedValue`.
721      */
722     function decreaseAllowance(address spender, uint256 subtractedValue) public virtual returns (bool) {
723         uint256 currentAllowance = _allowances[_msgSender()][spender];
724         require(currentAllowance >= subtractedValue, "ERC20: decreased allowance below zero");
725         unchecked {
726             _approve(_msgSender(), spender, currentAllowance - subtractedValue);
727         }
728 
729         return true;
730     }
731 
732     /**
733      * @dev Moves `amount` of tokens from `sender` to `recipient`.
734      *
735      * This internal function is equivalent to {transfer}, and can be used to
736      * e.g. implement automatic token fees, slashing mechanisms, etc.
737      *
738      * Emits a {Transfer} event.
739      *
740      * Requirements:
741      *
742      * - `sender` cannot be the zero address.
743      * - `recipient` cannot be the zero address.
744      * - `sender` must have a balance of at least `amount`.
745      */
746     function _transfer(
747         address sender,
748         address recipient,
749         uint256 amount
750     ) internal virtual {
751         require(sender != address(0), "ERC20: transfer from the zero address");
752         require(recipient != address(0), "ERC20: transfer to the zero address");
753 
754         _beforeTokenTransfer(sender, recipient, amount);
755 
756         uint256 senderBalance = _balances[sender];
757         require(senderBalance >= amount, "ERC20: transfer amount exceeds balance");
758         unchecked {
759             _balances[sender] = senderBalance - amount;
760         }
761         _balances[recipient] += amount;
762 
763         emit Transfer(sender, recipient, amount);
764 
765         _afterTokenTransfer(sender, recipient, amount);
766     }
767 
768     /** @dev Creates `amount` tokens and assigns them to `account`, increasing
769      * the total supply.
770      *
771      * Emits a {Transfer} event with `from` set to the zero address.
772      *
773      * Requirements:
774      *
775      * - `account` cannot be the zero address.
776      */
777     function _mint(address account, uint256 amount) internal virtual {
778         require(account != address(0), "ERC20: mint to the zero address");
779 
780         _beforeTokenTransfer(address(0), account, amount);
781 
782         _totalSupply += amount;
783         _balances[account] += amount;
784         emit Transfer(address(0), account, amount);
785 
786         _afterTokenTransfer(address(0), account, amount);
787     }
788 
789     /**
790      * @dev Destroys `amount` tokens from `account`, reducing the
791      * total supply.
792      *
793      * Emits a {Transfer} event with `to` set to the zero address.
794      *
795      * Requirements:
796      *
797      * - `account` cannot be the zero address.
798      * - `account` must have at least `amount` tokens.
799      */
800     function _burn(address account, uint256 amount) internal virtual {
801         require(account != address(0), "ERC20: burn from the zero address");
802 
803         _beforeTokenTransfer(account, address(0), amount);
804 
805         uint256 accountBalance = _balances[account];
806         require(accountBalance >= amount, "ERC20: burn amount exceeds balance");
807         unchecked {
808             _balances[account] = accountBalance - amount;
809         }
810         _totalSupply -= amount;
811 
812         emit Transfer(account, address(0), amount);
813 
814         _afterTokenTransfer(account, address(0), amount);
815     }
816 
817     /**
818      * @dev Sets `amount` as the allowance of `spender` over the `owner` s tokens.
819      *
820      * This internal function is equivalent to `approve`, and can be used to
821      * e.g. set automatic allowances for certain subsystems, etc.
822      *
823      * Emits an {Approval} event.
824      *
825      * Requirements:
826      *
827      * - `owner` cannot be the zero address.
828      * - `spender` cannot be the zero address.
829      */
830     function _approve(
831         address owner,
832         address spender,
833         uint256 amount
834     ) internal virtual {
835         require(owner != address(0), "ERC20: approve from the zero address");
836         require(spender != address(0), "ERC20: approve to the zero address");
837 
838         _allowances[owner][spender] = amount;
839         emit Approval(owner, spender, amount);
840     }
841 
842     /**
843      * @dev Hook that is called before any transfer of tokens. This includes
844      * minting and burning.
845      *
846      * Calling conditions:
847      *
848      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
849      * will be transferred to `to`.
850      * - when `from` is zero, `amount` tokens will be minted for `to`.
851      * - when `to` is zero, `amount` of ``from``'s tokens will be burned.
852      * - `from` and `to` are never both zero.
853      *
854      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
855      */
856     function _beforeTokenTransfer(
857         address from,
858         address to,
859         uint256 amount
860     ) internal virtual {}
861 
862     /**
863      * @dev Hook that is called after any transfer of tokens. This includes
864      * minting and burning.
865      *
866      * Calling conditions:
867      *
868      * - when `from` and `to` are both non-zero, `amount` of ``from``'s tokens
869      * has been transferred to `to`.
870      * - when `from` is zero, `amount` tokens have been minted for `to`.
871      * - when `to` is zero, `amount` of ``from``'s tokens have been burned.
872      * - `from` and `to` are never both zero.
873      *
874      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
875      */
876     function _afterTokenTransfer(
877         address from,
878         address to,
879         uint256 amount
880     ) internal virtual {}
881 }
882 // File: contracts/library/Ownable.sol
883 
884 
885 
886 // File: @openzeppelin/contracts/access/Ownable.sol
887 
888 
889 
890 pragma solidity ^0.8.0;
891 
892 
893 /**
894  * @dev Contract module which provides a basic access control mechanism, where
895  * there is an account (an owner) that can be granted exclusive access to
896  * specific functions.
897  *
898  * By default, the owner account will be the one that deploys the contract. This
899  * can later be changed with {transferOwnership}.
900  *
901  * This module is used through inheritance. It will make available the modifier
902  * `onlyOwner`, which can be applied to your functions to restrict their use to
903  * the owner.
904  */
905 abstract contract Ownable is Context {
906     address private _owner;
907 
908     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
909 
910     /**
911      * @dev Initializes the contract setting the deployer as the initial owner.
912      */
913     constructor() {
914         _setOwner(_msgSender());
915     }
916 
917     /**
918      * @dev Returns the address of the current owner.
919      */
920     function owner() public view virtual returns (address) {
921         return _owner;
922     }
923 
924     /**
925      * @dev Throws if called by any account other than the owner.
926      */
927     modifier onlyOwner() {
928         require(owner() == _msgSender(), "Ownable: caller is not the owner");
929         _;
930     }
931 
932     /**
933      * @dev Leaves the contract without owner. It will not be possible to call
934      * `onlyOwner` functions anymore. Can only be called by the current owner.
935      *
936      * NOTE: Renouncing ownership will leave the contract without an owner,
937      * thereby removing any functionality that is only available to the owner.
938      */
939     function renounceOwnership() public virtual onlyOwner {
940         _setOwner(address(0));
941     }
942 
943     /**
944      * @dev Transfers ownership of the contract to a new account (`newOwner`).
945      * Can only be called by the current owner.
946      */
947     function transferOwnership(address newOwner) public virtual onlyOwner {
948         require(newOwner != address(0), "Ownable: new owner is the zero address");
949         _setOwner(newOwner);
950     }
951 
952     function _setOwner(address newOwner) private {
953         address oldOwner = _owner;
954         _owner = newOwner;
955         emit OwnershipTransferred(oldOwner, newOwner);
956     }
957 }
958 // File: contracts/library/Address.sol
959 
960 
961 
962 // File: @openzeppelin/contracts/utils/Address.sol
963 
964 
965 
966 pragma solidity ^0.8.0;
967 
968 /**
969  * @dev Collection of functions related to the address type
970  */
971 library Address {
972     /**
973      * @dev Returns true if `account` is a contract.
974      *
975      * [IMPORTANT]
976      * ====
977      * It is unsafe to assume that an address for which this function returns
978      * false is an externally-owned account (EOA) and not a contract.
979      *
980      * Among others, `isContract` will return false for the following
981      * types of addresses:
982      *
983      *  - an externally-owned account
984      *  - a contract in construction
985      *  - an address where a contract will be created
986      *  - an address where a contract lived, but was destroyed
987      * ====
988      */
989     function isContract(address account) internal view returns (bool) {
990         // This method relies on extcodesize, which returns 0 for contracts in
991         // construction, since the code is only stored at the end of the
992         // constructor execution.
993 
994         uint256 size;
995         assembly {
996             size := extcodesize(account)
997         }
998         return size > 0;
999     }
1000 
1001     /**
1002      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1003      * `recipient`, forwarding all available gas and reverting on errors.
1004      *
1005      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1006      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1007      * imposed by `transfer`, making them unable to receive funds via
1008      * `transfer`. {sendValue} removes this limitation.
1009      *
1010      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1011      *
1012      * IMPORTANT: because control is transferred to `recipient`, care must be
1013      * taken to not create reentrancy vulnerabilities. Consider using
1014      * {ReentrancyGuard} or the
1015      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1016      */
1017     function sendValue(address payable recipient, uint256 amount) internal {
1018         require(address(this).balance >= amount, "Address: insufficient balance");
1019 
1020         (bool success, ) = recipient.call{value: amount}("");
1021         require(success, "Address: unable to send value, recipient may have reverted");
1022     }
1023 
1024     /**
1025      * @dev Performs a Solidity function call using a low level `call`. A
1026      * plain `call` is an unsafe replacement for a function call: use this
1027      * function instead.
1028      *
1029      * If `target` reverts with a revert reason, it is bubbled up by this
1030      * function (like regular Solidity function calls).
1031      *
1032      * Returns the raw returned data. To convert to the expected return value,
1033      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1034      *
1035      * Requirements:
1036      *
1037      * - `target` must be a contract.
1038      * - calling `target` with `data` must not revert.
1039      *
1040      * _Available since v3.1._
1041      */
1042     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1043         return functionCall(target, data, "Address: low-level call failed");
1044     }
1045 
1046     /**
1047      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1048      * `errorMessage` as a fallback revert reason when `target` reverts.
1049      *
1050      * _Available since v3.1._
1051      */
1052     function functionCall(
1053         address target,
1054         bytes memory data,
1055         string memory errorMessage
1056     ) internal returns (bytes memory) {
1057         return functionCallWithValue(target, data, 0, errorMessage);
1058     }
1059 
1060     /**
1061      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1062      * but also transferring `value` wei to `target`.
1063      *
1064      * Requirements:
1065      *
1066      * - the calling contract must have an ETH balance of at least `value`.
1067      * - the called Solidity function must be `payable`.
1068      *
1069      * _Available since v3.1._
1070      */
1071     function functionCallWithValue(
1072         address target,
1073         bytes memory data,
1074         uint256 value
1075     ) internal returns (bytes memory) {
1076         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1077     }
1078 
1079     /**
1080      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1081      * with `errorMessage` as a fallback revert reason when `target` reverts.
1082      *
1083      * _Available since v3.1._
1084      */
1085     function functionCallWithValue(
1086         address target,
1087         bytes memory data,
1088         uint256 value,
1089         string memory errorMessage
1090     ) internal returns (bytes memory) {
1091         require(address(this).balance >= value, "Address: insufficient balance for call");
1092         require(isContract(target), "Address: call to non-contract");
1093 
1094         (bool success, bytes memory returndata) = target.call{value: value}(data);
1095         return verifyCallResult(success, returndata, errorMessage);
1096     }
1097 
1098     /**
1099      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1100      * but performing a static call.
1101      *
1102      * _Available since v3.3._
1103      */
1104     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1105         return functionStaticCall(target, data, "Address: low-level static call failed");
1106     }
1107 
1108     /**
1109      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1110      * but performing a static call.
1111      *
1112      * _Available since v3.3._
1113      */
1114     function functionStaticCall(
1115         address target,
1116         bytes memory data,
1117         string memory errorMessage
1118     ) internal view returns (bytes memory) {
1119         require(isContract(target), "Address: static call to non-contract");
1120 
1121         (bool success, bytes memory returndata) = target.staticcall(data);
1122         return verifyCallResult(success, returndata, errorMessage);
1123     }
1124 
1125     /**
1126      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1127      * but performing a delegate call.
1128      *
1129      * _Available since v3.4._
1130      */
1131     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1132         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1133     }
1134 
1135     /**
1136      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1137      * but performing a delegate call.
1138      *
1139      * _Available since v3.4._
1140      */
1141     function functionDelegateCall(
1142         address target,
1143         bytes memory data,
1144         string memory errorMessage
1145     ) internal returns (bytes memory) {
1146         require(isContract(target), "Address: delegate call to non-contract");
1147 
1148         (bool success, bytes memory returndata) = target.delegatecall(data);
1149         return verifyCallResult(success, returndata, errorMessage);
1150     }
1151 
1152     /**
1153      * @dev Tool to verifies that a low level call was successful, and revert if it wasn't, either by bubbling the
1154      * revert reason using the provided one.
1155      *
1156      * _Available since v4.3._
1157      */
1158     function verifyCallResult(
1159         bool success,
1160         bytes memory returndata,
1161         string memory errorMessage
1162     ) internal pure returns (bytes memory) {
1163         if (success) {
1164             return returndata;
1165         } else {
1166             // Look for revert reason and bubble it up if present
1167             if (returndata.length > 0) {
1168                 // The easiest way to bubble the revert reason is using memory via assembly
1169 
1170                 assembly {
1171                     let returndata_size := mload(returndata)
1172                     revert(add(32, returndata), returndata_size)
1173                 }
1174             } else {
1175                 revert(errorMessage);
1176             }
1177         }
1178     }
1179 }
1180 
1181 // File: contracts/library/ERC721.sol
1182 
1183 
1184 
1185 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1186 
1187 
1188 
1189 pragma solidity ^0.8.0;
1190 
1191 
1192 
1193 
1194 
1195 
1196 
1197 
1198 
1199 
1200 
1201 /**
1202  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard, including
1203  * the Metadata extension, but not including the Enumerable extension, which is available separately as
1204  * {ERC721Enumerable}.
1205  */
1206 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata {
1207     using Address for address;
1208     using Strings for uint256;
1209 
1210     // Token name
1211     string private _name;
1212 
1213     // Token symbol
1214     string private _symbol;
1215 
1216     // Mapping from token ID to owner address
1217     mapping(uint256 => address) private _owners;
1218 
1219     // Mapping owner address to token count
1220     mapping(address => uint256) private _balances;
1221 
1222     // Mapping from token ID to approved address
1223     mapping(uint256 => address) private _tokenApprovals;
1224 
1225     // Mapping from owner to operator approvals
1226     mapping(address => mapping(address => bool)) private _operatorApprovals;
1227 
1228     /**
1229      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1230      */
1231     constructor(string memory name_, string memory symbol_) {
1232         _name = name_;
1233         _symbol = symbol_;
1234     }
1235 
1236     /**
1237      * @dev See {IERC165-supportsInterface}.
1238      */
1239     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
1240         return
1241             interfaceId == type(IERC721).interfaceId ||
1242             interfaceId == type(IERC721Metadata).interfaceId ||
1243             super.supportsInterface(interfaceId);
1244     }
1245 
1246     /**
1247      * @dev See {IERC721-balanceOf}.
1248      */
1249     function balanceOf(address owner) public view virtual override returns (uint256) {
1250         require(owner != address(0), "ERC721: balance query for the zero address");
1251         return _balances[owner];
1252     }
1253 
1254     /**
1255      * @dev See {IERC721-ownerOf}.
1256      */
1257     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1258         address owner = _owners[tokenId];
1259         require(owner != address(0), "ERC721: owner query for nonexistent token");
1260         return owner;
1261     }
1262 
1263     /**
1264      * @dev See {IERC721Metadata-name}.
1265      */
1266     function name() public view virtual override returns (string memory) {
1267         return _name;
1268     }
1269 
1270     /**
1271      * @dev See {IERC721Metadata-symbol}.
1272      */
1273     function symbol() public view virtual override returns (string memory) {
1274         return _symbol;
1275     }
1276 
1277     /**
1278      * @dev See {IERC721Metadata-tokenURI}.
1279      */
1280     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1281         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1282 
1283         string memory baseURI = _baseURI();
1284         return bytes(baseURI).length > 0 ? string(abi.encodePacked(baseURI, tokenId.toString())) : "";
1285     }
1286 
1287     /**
1288      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1289      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1290      * by default, can be overriden in child contracts.
1291      */
1292     function _baseURI() internal view virtual returns (string memory) {
1293         return "";
1294     }
1295 
1296     /**
1297      * @dev See {IERC721-approve}.
1298      */
1299     function approve(address to, uint256 tokenId) public virtual override {
1300         address owner = ERC721.ownerOf(tokenId);
1301         require(to != owner, "ERC721: approval to current owner");
1302 
1303         require(
1304             _msgSender() == owner || isApprovedForAll(owner, _msgSender()),
1305             "ERC721: approve caller is not owner nor approved for all"
1306         );
1307 
1308         _approve(to, tokenId);
1309     }
1310 
1311     /**
1312      * @dev See {IERC721-getApproved}.
1313      */
1314     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1315         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1316 
1317         return _tokenApprovals[tokenId];
1318     }
1319 
1320     /**
1321      * @dev See {IERC721-setApprovalForAll}.
1322      */
1323     function setApprovalForAll(address operator, bool approved) public virtual override {
1324         require(operator != _msgSender(), "ERC721: approve to caller");
1325 
1326         _operatorApprovals[_msgSender()][operator] = approved;
1327         emit ApprovalForAll(_msgSender(), operator, approved);
1328     }
1329 
1330     /**
1331      * @dev See {IERC721-isApprovedForAll}.
1332      */
1333     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1334         return _operatorApprovals[owner][operator];
1335     }
1336 
1337     /**
1338      * @dev See {IERC721-transferFrom}.
1339      */
1340     function transferFrom(
1341         address from,
1342         address to,
1343         uint256 tokenId
1344     ) public virtual override {
1345         //solhint-disable-next-line max-line-length
1346         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1347 
1348         _transfer(from, to, tokenId);
1349     }
1350 
1351     /**
1352      * @dev See {IERC721-safeTransferFrom}.
1353      */
1354     function safeTransferFrom(
1355         address from,
1356         address to,
1357         uint256 tokenId
1358     ) public virtual override {
1359         safeTransferFrom(from, to, tokenId, "");
1360     }
1361 
1362     /**
1363      * @dev See {IERC721-safeTransferFrom}.
1364      */
1365     function safeTransferFrom(
1366         address from,
1367         address to,
1368         uint256 tokenId,
1369         bytes memory _data
1370     ) public virtual override {
1371         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1372         _safeTransfer(from, to, tokenId, _data);
1373     }
1374 
1375     /**
1376      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1377      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1378      *
1379      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1380      *
1381      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1382      * implement alternative mechanisms to perform token transfer, such as signature-based.
1383      *
1384      * Requirements:
1385      *
1386      * - `from` cannot be the zero address.
1387      * - `to` cannot be the zero address.
1388      * - `tokenId` token must exist and be owned by `from`.
1389      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1390      *
1391      * Emits a {Transfer} event.
1392      */
1393     function _safeTransfer(
1394         address from,
1395         address to,
1396         uint256 tokenId,
1397         bytes memory _data
1398     ) internal virtual {
1399         _transfer(from, to, tokenId);
1400         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1401     }
1402 
1403     /**
1404      * @dev Returns whether `tokenId` exists.
1405      *
1406      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1407      *
1408      * Tokens start existing when they are minted (`_mint`),
1409      * and stop existing when they are burned (`_burn`).
1410      */
1411     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1412         return _owners[tokenId] != address(0);
1413     }
1414 
1415     /**
1416      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1417      *
1418      * Requirements:
1419      *
1420      * - `tokenId` must exist.
1421      */
1422     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1423         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1424         address owner = ERC721.ownerOf(tokenId);
1425         return (spender == owner || getApproved(tokenId) == spender || isApprovedForAll(owner, spender));
1426     }
1427 
1428     /**
1429      * @dev Safely mints `tokenId` and transfers it to `to`.
1430      *
1431      * Requirements:
1432      *
1433      * - `tokenId` must not exist.
1434      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1435      *
1436      * Emits a {Transfer} event.
1437      */
1438     function _safeMint(address to, uint256 tokenId) internal virtual {
1439         _safeMint(to, tokenId, "");
1440     }
1441 
1442     /**
1443      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1444      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1445      */
1446     function _safeMint(
1447         address to,
1448         uint256 tokenId,
1449         bytes memory _data
1450     ) internal virtual {
1451         _mint(to, tokenId);
1452         require(
1453             _checkOnERC721Received(address(0), to, tokenId, _data),
1454             "ERC721: transfer to non ERC721Receiver implementer"
1455         );
1456     }
1457 
1458     /**
1459      * @dev Mints `tokenId` and transfers it to `to`.
1460      *
1461      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1462      *
1463      * Requirements:
1464      *
1465      * - `tokenId` must not exist.
1466      * - `to` cannot be the zero address.
1467      *
1468      * Emits a {Transfer} event.
1469      */
1470     function _mint(address to, uint256 tokenId) internal virtual {
1471         require(to != address(0), "ERC721: mint to the zero address");
1472         require(!_exists(tokenId), "ERC721: token already minted");
1473 
1474         _beforeTokenTransfer(address(0), to, tokenId);
1475 
1476         _balances[to] += 1;
1477         _owners[tokenId] = to;
1478 
1479         emit Transfer(address(0), to, tokenId);
1480     }
1481 
1482     /**
1483      * @dev Destroys `tokenId`.
1484      * The approval is cleared when the token is burned.
1485      *
1486      * Requirements:
1487      *
1488      * - `tokenId` must exist.
1489      *
1490      * Emits a {Transfer} event.
1491      */
1492     function _burn(uint256 tokenId) internal virtual {
1493         address owner = ERC721.ownerOf(tokenId);
1494 
1495         _beforeTokenTransfer(owner, address(0), tokenId);
1496 
1497         // Clear approvals
1498         _approve(address(0), tokenId);
1499 
1500         _balances[owner] -= 1;
1501         delete _owners[tokenId];
1502 
1503         emit Transfer(owner, address(0), tokenId);
1504     }
1505 
1506     /**
1507      * @dev Transfers `tokenId` from `from` to `to`.
1508      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1509      *
1510      * Requirements:
1511      *
1512      * - `to` cannot be the zero address.
1513      * - `tokenId` token must be owned by `from`.
1514      *
1515      * Emits a {Transfer} event.
1516      */
1517     function _transfer(
1518         address from,
1519         address to,
1520         uint256 tokenId
1521     ) internal virtual {
1522         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own");
1523         require(to != address(0), "ERC721: transfer to the zero address");
1524 
1525         _beforeTokenTransfer(from, to, tokenId);
1526 
1527         // Clear approvals from the previous owner
1528         _approve(address(0), tokenId);
1529 
1530         _balances[from] -= 1;
1531         _balances[to] += 1;
1532         _owners[tokenId] = to;
1533 
1534         emit Transfer(from, to, tokenId);
1535     }
1536 
1537     /**
1538      * @dev Approve `to` to operate on `tokenId`
1539      *
1540      * Emits a {Approval} event.
1541      */
1542     function _approve(address to, uint256 tokenId) internal virtual {
1543         _tokenApprovals[tokenId] = to;
1544         emit Approval(ERC721.ownerOf(tokenId), to, tokenId);
1545     }
1546 
1547     /**
1548      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1549      * The call is not executed if the target address is not a contract.
1550      *
1551      * @param from address representing the previous owner of the given token ID
1552      * @param to target address that will receive the tokens
1553      * @param tokenId uint256 ID of the token to be transferred
1554      * @param _data bytes optional data to send along with the call
1555      * @return bool whether the call correctly returned the expected magic value
1556      */
1557     function _checkOnERC721Received(
1558         address from,
1559         address to,
1560         uint256 tokenId,
1561         bytes memory _data
1562     ) private returns (bool) {
1563         if (to.isContract()) {
1564             try IERC721Receiver(to).onERC721Received(_msgSender(), from, tokenId, _data) returns (bytes4 retval) {
1565                 return retval == IERC721Receiver.onERC721Received.selector;
1566             } catch (bytes memory reason) {
1567                 if (reason.length == 0) {
1568                     revert("ERC721: transfer to non ERC721Receiver implementer");
1569                 } else {
1570                     assembly {
1571                         revert(add(32, reason), mload(reason))
1572                     }
1573                 }
1574             }
1575         } else {
1576             return true;
1577         }
1578     }
1579 
1580     /**
1581      * @dev Hook that is called before any token transfer. This includes minting
1582      * and burning.
1583      *
1584      * Calling conditions:
1585      *
1586      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1587      * transferred to `to`.
1588      * - When `from` is zero, `tokenId` will be minted for `to`.
1589      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1590      * - `from` and `to` are never both zero.
1591      *
1592      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1593      */
1594     function _beforeTokenTransfer(
1595         address from,
1596         address to,
1597         uint256 tokenId
1598     ) internal virtual {}
1599 }
1600 // File: contracts/library/ERC721Enumerable.sol
1601 
1602 
1603 
1604 // File: @openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol
1605 
1606 
1607 
1608 pragma solidity ^0.8.0;
1609 
1610 
1611 
1612 /**
1613  * @dev This implements an optional extension of {ERC721} defined in the EIP that adds
1614  * enumerability of all the token ids in the contract as well as all token ids owned by each
1615  * account.
1616  */
1617 abstract contract ERC721Enumerable is ERC721, IERC721Enumerable {
1618     // Mapping from owner to list of owned token IDs
1619     mapping(address => mapping(uint256 => uint256)) private _ownedTokens;
1620 
1621     // Mapping from token ID to index of the owner tokens list
1622     mapping(uint256 => uint256) private _ownedTokensIndex;
1623 
1624     // Array with all token ids, used for enumeration
1625     uint256[] private _allTokens;
1626 
1627     // Mapping from token id to position in the allTokens array
1628     mapping(uint256 => uint256) private _allTokensIndex;
1629 
1630     /**
1631      * @dev See {IERC165-supportsInterface}.
1632      */
1633     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC721) returns (bool) {
1634         return interfaceId == type(IERC721Enumerable).interfaceId || super.supportsInterface(interfaceId);
1635     }
1636 
1637     /**
1638      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1639      */
1640     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1641         require(index < ERC721.balanceOf(owner), "ERC721Enumerable: owner index out of bounds");
1642         return _ownedTokens[owner][index];
1643     }
1644 
1645     /**
1646      * @dev See {IERC721Enumerable-totalSupply}.
1647      */
1648     function totalSupply() public view virtual override returns (uint256) {
1649         return _allTokens.length;
1650     }
1651 
1652     /**
1653      * @dev See {IERC721Enumerable-tokenByIndex}.
1654      */
1655     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1656         require(index < ERC721Enumerable.totalSupply(), "ERC721Enumerable: global index out of bounds");
1657         return _allTokens[index];
1658     }
1659 
1660     /**
1661      * @dev Hook that is called before any token transfer. This includes minting
1662      * and burning.
1663      *
1664      * Calling conditions:
1665      *
1666      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1667      * transferred to `to`.
1668      * - When `from` is zero, `tokenId` will be minted for `to`.
1669      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1670      * - `from` cannot be the zero address.
1671      * - `to` cannot be the zero address.
1672      *
1673      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1674      */
1675     function _beforeTokenTransfer(
1676         address from,
1677         address to,
1678         uint256 tokenId
1679     ) internal virtual override {
1680         super._beforeTokenTransfer(from, to, tokenId);
1681 
1682         if (from == address(0)) {
1683             _addTokenToAllTokensEnumeration(tokenId);
1684         } else if (from != to) {
1685             _removeTokenFromOwnerEnumeration(from, tokenId);
1686         }
1687         if (to == address(0)) {
1688             _removeTokenFromAllTokensEnumeration(tokenId);
1689         } else if (to != from) {
1690             _addTokenToOwnerEnumeration(to, tokenId);
1691         }
1692     }
1693 
1694     /**
1695      * @dev Private function to add a token to this extension's ownership-tracking data structures.
1696      * @param to address representing the new owner of the given token ID
1697      * @param tokenId uint256 ID of the token to be added to the tokens list of the given address
1698      */
1699     function _addTokenToOwnerEnumeration(address to, uint256 tokenId) private {
1700         uint256 length = ERC721.balanceOf(to);
1701         _ownedTokens[to][length] = tokenId;
1702         _ownedTokensIndex[tokenId] = length;
1703     }
1704 
1705     /**
1706      * @dev Private function to add a token to this extension's token tracking data structures.
1707      * @param tokenId uint256 ID of the token to be added to the tokens list
1708      */
1709     function _addTokenToAllTokensEnumeration(uint256 tokenId) private {
1710         _allTokensIndex[tokenId] = _allTokens.length;
1711         _allTokens.push(tokenId);
1712     }
1713 
1714     /**
1715      * @dev Private function to remove a token from this extension's ownership-tracking data structures. Note that
1716      * while the token is not assigned a new owner, the `_ownedTokensIndex` mapping is _not_ updated: this allows for
1717      * gas optimizations e.g. when performing a transfer operation (avoiding double writes).
1718      * This has O(1) time complexity, but alters the order of the _ownedTokens array.
1719      * @param from address representing the previous owner of the given token ID
1720      * @param tokenId uint256 ID of the token to be removed from the tokens list of the given address
1721      */
1722     function _removeTokenFromOwnerEnumeration(address from, uint256 tokenId) private {
1723         // To prevent a gap in from's tokens array, we store the last token in the index of the token to delete, and
1724         // then delete the last slot (swap and pop).
1725 
1726         uint256 lastTokenIndex = ERC721.balanceOf(from) - 1;
1727         uint256 tokenIndex = _ownedTokensIndex[tokenId];
1728 
1729         // When the token to delete is the last token, the swap operation is unnecessary
1730         if (tokenIndex != lastTokenIndex) {
1731             uint256 lastTokenId = _ownedTokens[from][lastTokenIndex];
1732 
1733             _ownedTokens[from][tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1734             _ownedTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1735         }
1736 
1737         // This also deletes the contents at the last position of the array
1738         delete _ownedTokensIndex[tokenId];
1739         delete _ownedTokens[from][lastTokenIndex];
1740     }
1741 
1742     /**
1743      * @dev Private function to remove a token from this extension's token tracking data structures.
1744      * This has O(1) time complexity, but alters the order of the _allTokens array.
1745      * @param tokenId uint256 ID of the token to be removed from the tokens list
1746      */
1747     function _removeTokenFromAllTokensEnumeration(uint256 tokenId) private {
1748         // To prevent a gap in the tokens array, we store the last token in the index of the token to delete, and
1749         // then delete the last slot (swap and pop).
1750 
1751         uint256 lastTokenIndex = _allTokens.length - 1;
1752         uint256 tokenIndex = _allTokensIndex[tokenId];
1753 
1754         // When the token to delete is the last token, the swap operation is unnecessary. However, since this occurs so
1755         // rarely (when the last minted token is burnt) that we still do the swap here to avoid the gas cost of adding
1756         // an 'if' statement (like in _removeTokenFromOwnerEnumeration)
1757         uint256 lastTokenId = _allTokens[lastTokenIndex];
1758 
1759         _allTokens[tokenIndex] = lastTokenId; // Move the last token to the slot of the to-delete token
1760         _allTokensIndex[lastTokenId] = tokenIndex; // Update the moved token's index
1761 
1762         // This also deletes the contents at the last position of the array
1763         delete _allTokensIndex[tokenId];
1764         _allTokens.pop();
1765     }
1766 }
1767 
1768 // File: contracts/AlphaBytes.sol
1769 
1770 
1771 
1772 
1773 
1774 /*
1775 
1776 
1777                                                                                                                
1778 ,--------.,--.                  ,---.  ,--.       ,--.             ,-----.,--.   ,--.,--------.,------.        
1779 '--.  .--'|  ,---.  ,---.      /  O  \ |  | ,---. |  ,---.  ,--,--.|  |) /_\  `.'  / '--.  .--'|  .---' ,---.  
1780    |  |   |  .-.  || .-. :    |  .-.  ||  || .-. ||  .-.  |' ,-.  ||  .-.  \'.    /     |  |   |  `--, (  .-'  
1781    |  |   |  | |  |\   --.    |  | |  ||  || '-' '|  | |  |\ '-'  ||  '--' /  |  |      |  |   |  `---..-'  `) 
1782    `--'   `--' `--' `----'    `--' `--'`--'|  |-' `--' `--' `--`--'`------'   `--'      `--'   `------'`----'  
1783                                            `--'                                                                
1784 ,--.                 ,---.                   ,--.  ,--.                                                        
1785 |  |-.,--. ,--.     /  O  \ ,--,--,--.,--.--.`--',-'  '-. ,--,--.                                              
1786 | .-. '\  '  /     |  .-.  ||        ||  .--',--.'-.  .-'' ,-.  |                                              
1787 | `-' | \   '      |  | |  ||  |  |  ||  |   |  |  |  |  \ '-'  |                                              
1788  `---'.-'  /       `--' `--'`--`--`--'`--'   `--'  `--'   `--`--'                                              
1789       `---'                                                                                                    
1790 
1791 PopElon
1792 WWW..THEALPHABYTES.COM
1793 https://discord.gg/pSBMtAttbJ
1794 www.twitter.com/artbyamrita
1795 
1796 
1797 */
1798 
1799 
1800 
1801 // File: contracts/AlphaBytes.sol
1802 
1803 
1804 pragma solidity >=0.7.0 <0.9.0;
1805 
1806 
1807 
1808 
1809 
1810 
1811 
1812 
1813 
1814 
1815 
1816 
1817 
1818 
1819 
1820 contract AlphaBytes is ERC721Enumerable, Ownable {
1821   using Strings for uint256;
1822 
1823   string public baseURI;
1824   string public baseExtension = ".json";
1825   string public notRevealedUri;
1826   uint256 public whitelistCost = 0.8 ether; 
1827   uint256 public cost = 1.0 ether;
1828   uint256 public maxSupply = 145;
1829   uint256 public maxMintAmount = 3;
1830   uint256 public nftPerAddressLimit = 145;
1831   bool public paused = false;
1832   bool public revealed = false;
1833   bool public onlyWhitelisted = true;
1834   mapping(address => bool) public whitelistedAddresses;
1835   mapping(address => uint256) public addressMintedBalance;
1836   mapping(uint256 => bool) public claimed;
1837   mapping(uint256 => bool) public minted;
1838   uint256 public totalsupply = 0;
1839 
1840   event Claimed(uint256 tokenId, address indexed account);
1841 
1842   constructor(
1843     string memory _name,
1844     string memory _symbol,
1845     string memory _initBaseURI,
1846     string memory _initNotRevealedUri
1847   ) ERC721(_name, _symbol) {
1848     setBaseURI(_initBaseURI);
1849     setNotRevealedURI(_initNotRevealedUri);
1850   }
1851 
1852   // internal
1853   function _baseURI() internal view virtual override returns (string memory) {
1854     return baseURI;
1855   }
1856 
1857   // public
1858   function mint(uint256 _mintAmount) public payable {
1859     require(!paused, "the contract is paused");
1860     uint256 supply = totalSupply();
1861     require(_mintAmount > 0, "need to mint at least 1 NFT");
1862     require(_mintAmount <= maxMintAmount, "max mint amount per session exceeded");
1863     require(supply + _mintAmount <= maxSupply, "max NFT limit exceeded");
1864 
1865     if (msg.sender != owner()) {
1866         if(onlyWhitelisted == true) {
1867             require(isWhitelisted(msg.sender), "user is not whitelisted");
1868             uint256 ownerMintedCount = addressMintedBalance[msg.sender];
1869             require(ownerMintedCount + _mintAmount <= nftPerAddressLimit, "max NFT per address exceeded");
1870             require(msg.value >= whitelistCost * _mintAmount, "insufficient funds");
1871         }else {
1872           require(msg.value >= cost * _mintAmount, "insufficient funds");
1873         }
1874     }
1875     
1876     for (uint256 i = 1; i <= _mintAmount; i++) {
1877       totalsupply++;
1878       while ( minted[totalsupply] == true)
1879       {
1880         totalsupply++;
1881       }
1882       addressMintedBalance[msg.sender]++;
1883       
1884       minted[totalsupply] = true;
1885       _safeMint(msg.sender, totalsupply);
1886       
1887     }
1888   }
1889   
1890   function gift(uint256[] calldata _tokenIds, address _to) public onlyOwner {
1891     require(!paused, "the contract is paused");
1892     require(_to != address(0), "invalid address");
1893     for(uint i=0;i<_tokenIds.length;i++){
1894       uint256 supply = totalSupply();
1895       require(supply + 1 <= maxSupply, "max NFT limit exceeded");
1896 
1897       require(minted[_tokenIds[i]] == false, "NFT already minted");
1898       addressMintedBalance[_to]++;
1899       minted[_tokenIds[i]] = true;
1900       _safeMint(_to, _tokenIds[i]);
1901     }
1902   }
1903 
1904   function isWhitelisted(address _user) public view returns (bool) {
1905     return  whitelistedAddresses[_user];
1906   }
1907 
1908   function claim(uint256 _tokenId) public {
1909     require(ownerOf(_tokenId) == msg.sender, "only owner can claim");
1910     claimed[_tokenId] = true;
1911 
1912     emit Claimed(_tokenId, msg.sender);
1913   }
1914 
1915   function walletOfOwner(address _owner)
1916     public
1917     view
1918     returns (uint256[] memory)
1919   {
1920     uint256 ownerTokenCount = balanceOf(_owner);
1921     uint256[] memory tokenIds = new uint256[](ownerTokenCount);
1922     for (uint256 i; i < ownerTokenCount; i++) {
1923       tokenIds[i] = tokenOfOwnerByIndex(_owner, i);
1924     }
1925     return tokenIds;
1926   }
1927 
1928   function tokenURI(uint256 tokenId)
1929     public
1930     view
1931     virtual
1932     override
1933     returns (string memory)
1934   {
1935     require(
1936       _exists(tokenId),
1937       "ERC721Metadata: URI query for nonexistent token"
1938     );
1939     
1940     if(revealed == false) {
1941         return notRevealedUri;
1942     }
1943 
1944     string memory currentBaseURI = _baseURI();
1945     return bytes(currentBaseURI).length > 0
1946         ? string(abi.encodePacked(currentBaseURI, tokenId.toString(), baseExtension))
1947         : "";
1948   }
1949 
1950   //only owner
1951   function reveal() public onlyOwner {
1952       revealed = true;
1953   }
1954   
1955   function setNftPerAddressLimit(uint256 _limit) public onlyOwner {
1956     nftPerAddressLimit = _limit;
1957   }
1958 
1959   function changeOwner(address newOwner) public onlyOwner {
1960     transferOwnership(newOwner);
1961   }
1962 
1963   function setCost(uint256 _newCost) public onlyOwner {
1964     cost = _newCost;
1965   }
1966 
1967   function setWhitelistCost(uint256 _newCost) public onlyOwner {
1968     whitelistCost = _newCost;
1969   }
1970 //   function setmaxMintAmount(uint256 _newmaxMintAmount) public onlyOwner {
1971 //     maxMintAmount = _newmaxMintAmount;
1972 //   }
1973 
1974   function setBaseURI(string memory _newBaseURI) public onlyOwner {
1975     baseURI = _newBaseURI;
1976   }
1977 
1978   function setBaseExtension(string memory _newBaseExtension) public onlyOwner {
1979     baseExtension = _newBaseExtension;
1980   }
1981   
1982   function setNotRevealedURI(string memory _notRevealedURI) public onlyOwner {
1983     notRevealedUri = _notRevealedURI;
1984   }
1985 
1986   function pause(bool _state) public onlyOwner {
1987     paused = _state;
1988   }
1989   
1990   function setOnlyWhitelisted(bool _state) public onlyOwner {
1991     onlyWhitelisted = _state;
1992   }
1993   
1994   function whitelistUsers(address[] calldata _users) public onlyOwner {
1995     for(uint i=0;i<_users.length;i++){
1996         whitelistedAddresses[_users[i]]=true;
1997     }
1998   }
1999  function whitelistUser(address _user) public onlyOwner {
2000         whitelistedAddresses[_user]=true;    
2001   }
2002   function withdraw() public payable onlyOwner {
2003 
2004     (bool os, ) = payable(owner()).call{value: address(this).balance}("");
2005     require(os);
2006 
2007   }
2008 }