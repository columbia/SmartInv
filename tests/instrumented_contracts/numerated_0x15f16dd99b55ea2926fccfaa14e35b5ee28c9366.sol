1 // SPDX-License-Identifier: MIT
2 
3 // File: @openzeppelin/contracts/utils/Context.sol
4 
5 
6 pragma solidity ^0.8.0;
7 
8 /*
9  * @dev Provides information about the current execution context, including the
10  * sender of the transaction and its data. While these are generally available
11  * via msg.sender and msg.data, they should not be accessed in such a direct
12  * manner, since when dealing with meta-transactions the account sending and
13  * paying for execution may not be the actual sender (as far as an application
14  * is concerned).
15  *
16  * This contract is only required for intermediate, library-like contracts.
17  */
18 abstract contract Context {
19     function _msgSender() internal view virtual returns (address) {
20         return msg.sender;
21     }
22 
23     function _msgData() internal view virtual returns (bytes calldata) {
24         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
25         return msg.data;
26     }
27 }
28 
29 // File: @openzeppelin/contracts/utils/introspection/IERC165.sol
30 
31 
32 pragma solidity ^0.8.0;
33 
34 /**
35  * @dev Interface of the ERC165 standard, as defined in the
36  * https://eips.ethereum.org/EIPS/eip-165[EIP].
37  *
38  * Implementers can declare support of contract interfaces, which can then be
39  * queried by others ({ERC165Checker}).
40  *
41  * For an implementation, see {ERC165}.
42  */
43 interface IERC165 {
44     /**
45      * @dev Returns true if this contract implements the interface defined by
46      * `interfaceId`. See the corresponding
47      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
48      * to learn more about how these ids are created.
49      *
50      * This function call must use less than 30 000 gas.
51      */
52     function supportsInterface(bytes4 interfaceId) external view returns (bool);
53 }
54 
55 // File: @openzeppelin/contracts/utils/introspection/ERC165.sol
56 
57 
58 pragma solidity ^0.8.0;
59 
60 
61 /**
62  * @dev Implementation of the {IERC165} interface.
63  *
64  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
65  * for the additional interface id that will be supported. For example:
66  *
67  * ```solidity
68  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
69  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
70  * }
71  * ```
72  *
73  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
74  */
75 abstract contract ERC165 is IERC165 {
76     /**
77      * @dev See {IERC165-supportsInterface}.
78      */
79     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
80         return interfaceId == type(IERC165).interfaceId;
81     }
82 }
83 
84 // File: @openzeppelin/contracts/token/ERC1155/IERC1155.sol
85 
86 
87 pragma solidity ^0.8.0;
88 
89 
90 /**
91  * @dev Required interface of an ERC1155 compliant contract, as defined in the
92  * https://eips.ethereum.org/EIPS/eip-1155[EIP].
93  *
94  * _Available since v3.1._
95  */
96 interface IERC1155 is IERC165 {
97     /**
98      * @dev Emitted when `value` tokens of token type `id` are transferred from `from` to `to` by `operator`.
99      */
100     event TransferSingle(address indexed operator, address indexed from, address indexed to, uint256 id, uint256 value);
101 
102     /**
103      * @dev Equivalent to multiple {TransferSingle} events, where `operator`, `from` and `to` are the same for all
104      * transfers.
105      */
106     event TransferBatch(address indexed operator, address indexed from, address indexed to, uint256[] ids, uint256[] values);
107 
108     /**
109      * @dev Emitted when `account` grants or revokes permission to `operator` to transfer their tokens, according to
110      * `approved`.
111      */
112     event ApprovalForAll(address indexed account, address indexed operator, bool approved);
113 
114     /**
115      * @dev Emitted when the URI for token type `id` changes to `value`, if it is a non-programmatic URI.
116      *
117      * If an {URI} event was emitted for `id`, the standard
118      * https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[guarantees] that `value` will equal the value
119      * returned by {IERC1155MetadataURI-uri}.
120      */
121     event URI(string value, uint256 indexed id);
122 
123     /**
124      * @dev Returns the amount of tokens of token type `id` owned by `account`.
125      *
126      * Requirements:
127      *
128      * - `account` cannot be the zero address.
129      */
130     function balanceOf(address account, uint256 id) external view returns (uint256);
131 
132     /**
133      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {balanceOf}.
134      *
135      * Requirements:
136      *
137      * - `accounts` and `ids` must have the same length.
138      */
139     function balanceOfBatch(address[] calldata accounts, uint256[] calldata ids) external view returns (uint256[] memory);
140 
141     /**
142      * @dev Grants or revokes permission to `operator` to transfer the caller's tokens, according to `approved`,
143      *
144      * Emits an {ApprovalForAll} event.
145      *
146      * Requirements:
147      *
148      * - `operator` cannot be the caller.
149      */
150     function setApprovalForAll(address operator, bool approved) external;
151 
152     /**
153      * @dev Returns true if `operator` is approved to transfer ``account``'s tokens.
154      *
155      * See {setApprovalForAll}.
156      */
157     function isApprovedForAll(address account, address operator) external view returns (bool);
158 
159     /**
160      * @dev Transfers `amount` tokens of token type `id` from `from` to `to`.
161      *
162      * Emits a {TransferSingle} event.
163      *
164      * Requirements:
165      *
166      * - `to` cannot be the zero address.
167      * - If the caller is not `from`, it must be have been approved to spend ``from``'s tokens via {setApprovalForAll}.
168      * - `from` must have a balance of tokens of type `id` of at least `amount`.
169      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
170      * acceptance magic value.
171      */
172     function safeTransferFrom(address from, address to, uint256 id, uint256 amount, bytes calldata data) external;
173 
174     /**
175      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {safeTransferFrom}.
176      *
177      * Emits a {TransferBatch} event.
178      *
179      * Requirements:
180      *
181      * - `ids` and `amounts` must have the same length.
182      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
183      * acceptance magic value.
184      */
185     function safeBatchTransferFrom(address from, address to, uint256[] calldata ids, uint256[] calldata amounts, bytes calldata data) external;
186 }
187 
188 // File: @openzeppelin/contracts/token/ERC1155/extensions/IERC1155MetadataURI.sol
189 
190 
191 pragma solidity ^0.8.0;
192 
193 
194 /**
195  * @dev Interface of the optional ERC1155MetadataExtension interface, as defined
196  * in the https://eips.ethereum.org/EIPS/eip-1155#metadata-extensions[EIP].
197  *
198  * _Available since v3.1._
199  */
200 interface IERC1155MetadataURI is IERC1155 {
201     /**
202      * @dev Returns the URI for token type `id`.
203      *
204      * If the `\{id\}` substring is present in the URI, it must be replaced by
205      * clients with the actual token type ID.
206      */
207     function uri(uint256 id) external view returns (string memory);
208 }
209 
210 // File: @openzeppelin/contracts/token/ERC1155/ERC1155.sol
211 
212 
213 pragma solidity ^0.8.0;
214 
215 
216 
217 
218 
219 
220 
221 /**
222  *
223  * @dev Implementation of the basic standard multi-token.
224  * See https://eips.ethereum.org/EIPS/eip-1155
225  * Originally based on code by Enjin: https://github.com/enjin/erc-1155
226  *
227  * _Available since v3.1._
228  */
229 contract ERC1155 is Context, ERC165, IERC1155, IERC1155MetadataURI {
230     using Address for address;
231 
232     // Mapping from token ID to account balances
233     mapping (uint256 => mapping(address => uint256)) private _balances;
234 
235     // Mapping from account to operator approvals
236     mapping (address => mapping(address => bool)) private _operatorApprovals;
237 
238     // Used as the URI for all token types by relying on ID substitution, e.g. https://token-cdn-domain/{id}.json
239     string private _uri;
240 
241     /**
242      * @dev See {_setURI}.
243      */
244     constructor (string memory uri_) {
245         _setURI(uri_);
246     }
247 
248     /**
249      * @dev See {IERC165-supportsInterface}.
250      */
251     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC165, IERC165) returns (bool) {
252         return interfaceId == type(IERC1155).interfaceId
253             || interfaceId == type(IERC1155MetadataURI).interfaceId
254             || super.supportsInterface(interfaceId);
255     }
256 
257     /**
258      * @dev See {IERC1155MetadataURI-uri}.
259      *
260      * This implementation returns the same URI for *all* token types. It relies
261      * on the token type ID substitution mechanism
262      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
263      *
264      * Clients calling this function must replace the `\{id\}` substring with the
265      * actual token type ID.
266      */
267     function uri(uint256) public view virtual override returns (string memory) {
268         return _uri;
269     }
270 
271     /**
272      * @dev See {IERC1155-balanceOf}.
273      *
274      * Requirements:
275      *
276      * - `account` cannot be the zero address.
277      */
278     function balanceOf(address account, uint256 id) public view virtual override returns (uint256) {
279         require(account != address(0), "ERC1155: balance query for the zero address");
280         return _balances[id][account];
281     }
282 
283     /**
284      * @dev See {IERC1155-balanceOfBatch}.
285      *
286      * Requirements:
287      *
288      * - `accounts` and `ids` must have the same length.
289      */
290     function balanceOfBatch(
291         address[] memory accounts,
292         uint256[] memory ids
293     )
294         public
295         view
296         virtual
297         override
298         returns (uint256[] memory)
299     {
300         require(accounts.length == ids.length, "ERC1155: accounts and ids length mismatch");
301 
302         uint256[] memory batchBalances = new uint256[](accounts.length);
303 
304         for (uint256 i = 0; i < accounts.length; ++i) {
305             batchBalances[i] = balanceOf(accounts[i], ids[i]);
306         }
307 
308         return batchBalances;
309     }
310 
311     /**
312      * @dev See {IERC1155-setApprovalForAll}.
313      */
314     function setApprovalForAll(address operator, bool approved) public virtual override {
315         require(_msgSender() != operator, "ERC1155: setting approval status for self");
316 
317         _operatorApprovals[_msgSender()][operator] = approved;
318         emit ApprovalForAll(_msgSender(), operator, approved);
319     }
320 
321     /**
322      * @dev See {IERC1155-isApprovedForAll}.
323      */
324     function isApprovedForAll(address account, address operator) public view virtual override returns (bool) {
325         return _operatorApprovals[account][operator];
326     }
327 
328     /**
329      * @dev See {IERC1155-safeTransferFrom}.
330      */
331     function safeTransferFrom(
332         address from,
333         address to,
334         uint256 id,
335         uint256 amount,
336         bytes memory data
337     )
338         public
339         virtual
340         override
341     {
342         require(to != address(0), "ERC1155: transfer to the zero address");
343         require(
344             from == _msgSender() || isApprovedForAll(from, _msgSender()),
345             "ERC1155: caller is not owner nor approved"
346         );
347 
348         address operator = _msgSender();
349 
350         _beforeTokenTransfer(operator, from, to, _asSingletonArray(id), _asSingletonArray(amount), data);
351 
352         uint256 fromBalance = _balances[id][from];
353         require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
354         _balances[id][from] = fromBalance - amount;
355         _balances[id][to] += amount;
356 
357         emit TransferSingle(operator, from, to, id, amount);
358 
359         _doSafeTransferAcceptanceCheck(operator, from, to, id, amount, data);
360     }
361 
362     /**
363      * @dev See {IERC1155-safeBatchTransferFrom}.
364      */
365     function safeBatchTransferFrom(
366         address from,
367         address to,
368         uint256[] memory ids,
369         uint256[] memory amounts,
370         bytes memory data
371     )
372         public
373         virtual
374         override
375     {
376         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
377         require(to != address(0), "ERC1155: transfer to the zero address");
378         require(
379             from == _msgSender() || isApprovedForAll(from, _msgSender()),
380             "ERC1155: transfer caller is not owner nor approved"
381         );
382 
383         address operator = _msgSender();
384 
385         _beforeTokenTransfer(operator, from, to, ids, amounts, data);
386 
387         for (uint256 i = 0; i < ids.length; ++i) {
388             uint256 id = ids[i];
389             uint256 amount = amounts[i];
390 
391             uint256 fromBalance = _balances[id][from];
392             require(fromBalance >= amount, "ERC1155: insufficient balance for transfer");
393             _balances[id][from] = fromBalance - amount;
394             _balances[id][to] += amount;
395         }
396 
397         emit TransferBatch(operator, from, to, ids, amounts);
398 
399         _doSafeBatchTransferAcceptanceCheck(operator, from, to, ids, amounts, data);
400     }
401 
402     /**
403      * @dev Sets a new URI for all token types, by relying on the token type ID
404      * substitution mechanism
405      * https://eips.ethereum.org/EIPS/eip-1155#metadata[defined in the EIP].
406      *
407      * By this mechanism, any occurrence of the `\{id\}` substring in either the
408      * URI or any of the amounts in the JSON file at said URI will be replaced by
409      * clients with the token type ID.
410      *
411      * For example, the `https://token-cdn-domain/\{id\}.json` URI would be
412      * interpreted by clients as
413      * `https://token-cdn-domain/000000000000000000000000000000000000000000000000000000000004cce0.json`
414      * for token type ID 0x4cce0.
415      *
416      * See {uri}.
417      *
418      * Because these URIs cannot be meaningfully represented by the {URI} event,
419      * this function emits no events.
420      */
421     function _setURI(string memory newuri) internal virtual {
422         _uri = newuri;
423     }
424 
425     /**
426      * @dev Creates `amount` tokens of token type `id`, and assigns them to `account`.
427      *
428      * Emits a {TransferSingle} event.
429      *
430      * Requirements:
431      *
432      * - `account` cannot be the zero address.
433      * - If `account` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155Received} and return the
434      * acceptance magic value.
435      */
436     function _mint(address account, uint256 id, uint256 amount, bytes memory data) internal virtual {
437         require(account != address(0), "ERC1155: mint to the zero address");
438 
439         address operator = _msgSender();
440 
441         _beforeTokenTransfer(operator, address(0), account, _asSingletonArray(id), _asSingletonArray(amount), data);
442 
443         _balances[id][account] += amount;
444         emit TransferSingle(operator, address(0), account, id, amount);
445 
446         _doSafeTransferAcceptanceCheck(operator, address(0), account, id, amount, data);
447     }
448 
449     /**
450      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_mint}.
451      *
452      * Requirements:
453      *
454      * - `ids` and `amounts` must have the same length.
455      * - If `to` refers to a smart contract, it must implement {IERC1155Receiver-onERC1155BatchReceived} and return the
456      * acceptance magic value.
457      */
458     function _mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) internal virtual {
459         require(to != address(0), "ERC1155: mint to the zero address");
460         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
461 
462         address operator = _msgSender();
463 
464         _beforeTokenTransfer(operator, address(0), to, ids, amounts, data);
465 
466         for (uint i = 0; i < ids.length; i++) {
467             _balances[ids[i]][to] += amounts[i];
468         }
469 
470         emit TransferBatch(operator, address(0), to, ids, amounts);
471 
472         _doSafeBatchTransferAcceptanceCheck(operator, address(0), to, ids, amounts, data);
473     }
474 
475     /**
476      * @dev Destroys `amount` tokens of token type `id` from `account`
477      *
478      * Requirements:
479      *
480      * - `account` cannot be the zero address.
481      * - `account` must have at least `amount` tokens of token type `id`.
482      */
483     function _burn(address account, uint256 id, uint256 amount) internal virtual {
484         require(account != address(0), "ERC1155: burn from the zero address");
485 
486         address operator = _msgSender();
487 
488         _beforeTokenTransfer(operator, account, address(0), _asSingletonArray(id), _asSingletonArray(amount), "");
489 
490         uint256 accountBalance = _balances[id][account];
491         require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
492         _balances[id][account] = accountBalance - amount;
493 
494         emit TransferSingle(operator, account, address(0), id, amount);
495     }
496 
497     /**
498      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] version of {_burn}.
499      *
500      * Requirements:
501      *
502      * - `ids` and `amounts` must have the same length.
503      */
504     function _burnBatch(address account, uint256[] memory ids, uint256[] memory amounts) internal virtual {
505         require(account != address(0), "ERC1155: burn from the zero address");
506         require(ids.length == amounts.length, "ERC1155: ids and amounts length mismatch");
507 
508         address operator = _msgSender();
509 
510         _beforeTokenTransfer(operator, account, address(0), ids, amounts, "");
511 
512         for (uint i = 0; i < ids.length; i++) {
513             uint256 id = ids[i];
514             uint256 amount = amounts[i];
515 
516             uint256 accountBalance = _balances[id][account];
517             require(accountBalance >= amount, "ERC1155: burn amount exceeds balance");
518             _balances[id][account] = accountBalance - amount;
519         }
520 
521         emit TransferBatch(operator, account, address(0), ids, amounts);
522     }
523 
524     /**
525      * @dev Hook that is called before any token transfer. This includes minting
526      * and burning, as well as batched variants.
527      *
528      * The same hook is called on both single and batched variants. For single
529      * transfers, the length of the `id` and `amount` arrays will be 1.
530      *
531      * Calling conditions (for each `id` and `amount` pair):
532      *
533      * - When `from` and `to` are both non-zero, `amount` of ``from``'s tokens
534      * of token type `id` will be  transferred to `to`.
535      * - When `from` is zero, `amount` tokens of token type `id` will be minted
536      * for `to`.
537      * - when `to` is zero, `amount` of ``from``'s tokens of token type `id`
538      * will be burned.
539      * - `from` and `to` are never both zero.
540      * - `ids` and `amounts` have the same, non-zero length.
541      *
542      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
543      */
544     function _beforeTokenTransfer(
545         address operator,
546         address from,
547         address to,
548         uint256[] memory ids,
549         uint256[] memory amounts,
550         bytes memory data
551     )
552         internal
553         virtual
554     { }
555 
556     function _doSafeTransferAcceptanceCheck(
557         address operator,
558         address from,
559         address to,
560         uint256 id,
561         uint256 amount,
562         bytes memory data
563     )
564         private
565     {
566         if (to.isContract()) {
567             try IERC1155Receiver(to).onERC1155Received(operator, from, id, amount, data) returns (bytes4 response) {
568                 if (response != IERC1155Receiver(to).onERC1155Received.selector) {
569                     revert("ERC1155: ERC1155Receiver rejected tokens");
570                 }
571             } catch Error(string memory reason) {
572                 revert(reason);
573             } catch {
574                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
575             }
576         }
577     }
578 
579     function _doSafeBatchTransferAcceptanceCheck(
580         address operator,
581         address from,
582         address to,
583         uint256[] memory ids,
584         uint256[] memory amounts,
585         bytes memory data
586     )
587         private
588     {
589         if (to.isContract()) {
590             try IERC1155Receiver(to).onERC1155BatchReceived(operator, from, ids, amounts, data) returns (bytes4 response) {
591                 if (response != IERC1155Receiver(to).onERC1155BatchReceived.selector) {
592                     revert("ERC1155: ERC1155Receiver rejected tokens");
593                 }
594             } catch Error(string memory reason) {
595                 revert(reason);
596             } catch {
597                 revert("ERC1155: transfer to non ERC1155Receiver implementer");
598             }
599         }
600     }
601 
602     function _asSingletonArray(uint256 element) private pure returns (uint256[] memory) {
603         uint256[] memory array = new uint256[](1);
604         array[0] = element;
605 
606         return array;
607     }
608 }
609 
610 // File: @openzeppelin/contracts/access/AccessControl.sol
611 
612 
613 pragma solidity ^0.8.0;
614 
615 
616 
617 /**
618  * @dev External interface of AccessControl declared to support ERC165 detection.
619  */
620 interface IAccessControl {
621     function hasRole(bytes32 role, address account) external view returns (bool);
622     function getRoleAdmin(bytes32 role) external view returns (bytes32);
623     function grantRole(bytes32 role, address account) external;
624     function revokeRole(bytes32 role, address account) external;
625     function renounceRole(bytes32 role, address account) external;
626 }
627 
628 /**
629  * @dev Contract module that allows children to implement role-based access
630  * control mechanisms. This is a lightweight version that doesn't allow enumerating role
631  * members except through off-chain means by accessing the contract event logs. Some
632  * applications may benefit from on-chain enumerability, for those cases see
633  * {AccessControlEnumerable}.
634  *
635  * Roles are referred to by their `bytes32` identifier. These should be exposed
636  * in the external API and be unique. The best way to achieve this is by
637  * using `public constant` hash digests:
638  *
639  * ```
640  * bytes32 public constant MY_ROLE = keccak256("MY_ROLE");
641  * ```
642  *
643  * Roles can be used to represent a set of permissions. To restrict access to a
644  * function call, use {hasRole}:
645  *
646  * ```
647  * function foo() public {
648  *     require(hasRole(MY_ROLE, msg.sender));
649  *     ...
650  * }
651  * ```
652  *
653  * Roles can be granted and revoked dynamically via the {grantRole} and
654  * {revokeRole} functions. Each role has an associated admin role, and only
655  * accounts that have a role's admin role can call {grantRole} and {revokeRole}.
656  *
657  * By default, the admin role for all roles is `DEFAULT_ADMIN_ROLE`, which means
658  * that only accounts with this role will be able to grant or revoke other
659  * roles. More complex role relationships can be created by using
660  * {_setRoleAdmin}.
661  *
662  * WARNING: The `DEFAULT_ADMIN_ROLE` is also its own admin: it has permission to
663  * grant and revoke this role. Extra precautions should be taken to secure
664  * accounts that have been granted it.
665  */
666 abstract contract AccessControl is Context, IAccessControl, ERC165 {
667     struct RoleData {
668         mapping (address => bool) members;
669         bytes32 adminRole;
670     }
671 
672     mapping (bytes32 => RoleData) private _roles;
673 
674     bytes32 public constant DEFAULT_ADMIN_ROLE = 0x00;
675 
676     /**
677      * @dev Emitted when `newAdminRole` is set as ``role``'s admin role, replacing `previousAdminRole`
678      *
679      * `DEFAULT_ADMIN_ROLE` is the starting admin for all roles, despite
680      * {RoleAdminChanged} not being emitted signaling this.
681      *
682      * _Available since v3.1._
683      */
684     event RoleAdminChanged(bytes32 indexed role, bytes32 indexed previousAdminRole, bytes32 indexed newAdminRole);
685 
686     /**
687      * @dev Emitted when `account` is granted `role`.
688      *
689      * `sender` is the account that originated the contract call, an admin role
690      * bearer except when using {_setupRole}.
691      */
692     event RoleGranted(bytes32 indexed role, address indexed account, address indexed sender);
693 
694     /**
695      * @dev Emitted when `account` is revoked `role`.
696      *
697      * `sender` is the account that originated the contract call:
698      *   - if using `revokeRole`, it is the admin role bearer
699      *   - if using `renounceRole`, it is the role bearer (i.e. `account`)
700      */
701     event RoleRevoked(bytes32 indexed role, address indexed account, address indexed sender);
702 
703     /**
704      * @dev See {IERC165-supportsInterface}.
705      */
706     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
707         return interfaceId == type(IAccessControl).interfaceId
708             || super.supportsInterface(interfaceId);
709     }
710 
711     /**
712      * @dev Returns `true` if `account` has been granted `role`.
713      */
714     function hasRole(bytes32 role, address account) public view override returns (bool) {
715         return _roles[role].members[account];
716     }
717 
718     /**
719      * @dev Returns the admin role that controls `role`. See {grantRole} and
720      * {revokeRole}.
721      *
722      * To change a role's admin, use {_setRoleAdmin}.
723      */
724     function getRoleAdmin(bytes32 role) public view override returns (bytes32) {
725         return _roles[role].adminRole;
726     }
727 
728     /**
729      * @dev Grants `role` to `account`.
730      *
731      * If `account` had not been already granted `role`, emits a {RoleGranted}
732      * event.
733      *
734      * Requirements:
735      *
736      * - the caller must have ``role``'s admin role.
737      */
738     function grantRole(bytes32 role, address account) public virtual override {
739         require(hasRole(getRoleAdmin(role), _msgSender()), "AccessControl: sender must be an admin to grant");
740 
741         _grantRole(role, account);
742     }
743 
744     /**
745      * @dev Revokes `role` from `account`.
746      *
747      * If `account` had been granted `role`, emits a {RoleRevoked} event.
748      *
749      * Requirements:
750      *
751      * - the caller must have ``role``'s admin role.
752      */
753     function revokeRole(bytes32 role, address account) public virtual override {
754         require(hasRole(getRoleAdmin(role), _msgSender()), "AccessControl: sender must be an admin to revoke");
755 
756         _revokeRole(role, account);
757     }
758 
759     /**
760      * @dev Revokes `role` from the calling account.
761      *
762      * Roles are often managed via {grantRole} and {revokeRole}: this function's
763      * purpose is to provide a mechanism for accounts to lose their privileges
764      * if they are compromised (such as when a trusted device is misplaced).
765      *
766      * If the calling account had been granted `role`, emits a {RoleRevoked}
767      * event.
768      *
769      * Requirements:
770      *
771      * - the caller must be `account`.
772      */
773     function renounceRole(bytes32 role, address account) public virtual override {
774         require(account == _msgSender(), "AccessControl: can only renounce roles for self");
775 
776         _revokeRole(role, account);
777     }
778 
779     /**
780      * @dev Grants `role` to `account`.
781      *
782      * If `account` had not been already granted `role`, emits a {RoleGranted}
783      * event. Note that unlike {grantRole}, this function doesn't perform any
784      * checks on the calling account.
785      *
786      * [WARNING]
787      * ====
788      * This function should only be called from the constructor when setting
789      * up the initial roles for the system.
790      *
791      * Using this function in any other way is effectively circumventing the admin
792      * system imposed by {AccessControl}.
793      * ====
794      */
795     function _setupRole(bytes32 role, address account) internal virtual {
796         _grantRole(role, account);
797     }
798 
799     /**
800      * @dev Sets `adminRole` as ``role``'s admin role.
801      *
802      * Emits a {RoleAdminChanged} event.
803      */
804     function _setRoleAdmin(bytes32 role, bytes32 adminRole) internal virtual {
805         emit RoleAdminChanged(role, getRoleAdmin(role), adminRole);
806         _roles[role].adminRole = adminRole;
807     }
808 
809     function _grantRole(bytes32 role, address account) private {
810         if (!hasRole(role, account)) {
811             _roles[role].members[account] = true;
812             emit RoleGranted(role, account, _msgSender());
813         }
814     }
815 
816     function _revokeRole(bytes32 role, address account) private {
817         if (hasRole(role, account)) {
818             _roles[role].members[account] = false;
819             emit RoleRevoked(role, account, _msgSender());
820         }
821     }
822 }
823 
824 // File: @openzeppelin/contracts/access/AccessControlEnumerable.sol
825 
826 
827 pragma solidity ^0.8.0;
828 
829 
830 
831 /**
832  * @dev External interface of AccessControlEnumerable declared to support ERC165 detection.
833  */
834 interface IAccessControlEnumerable {
835     function getRoleMember(bytes32 role, uint256 index) external view returns (address);
836     function getRoleMemberCount(bytes32 role) external view returns (uint256);
837 }
838 
839 /**
840  * @dev Extension of {AccessControl} that allows enumerating the members of each role.
841  */
842 abstract contract AccessControlEnumerable is IAccessControlEnumerable, AccessControl {
843     using EnumerableSet for EnumerableSet.AddressSet;
844 
845     mapping (bytes32 => EnumerableSet.AddressSet) private _roleMembers;
846 
847     /**
848      * @dev See {IERC165-supportsInterface}.
849      */
850     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
851         return interfaceId == type(IAccessControlEnumerable).interfaceId
852             || super.supportsInterface(interfaceId);
853     }
854 
855     /**
856      * @dev Returns one of the accounts that have `role`. `index` must be a
857      * value between 0 and {getRoleMemberCount}, non-inclusive.
858      *
859      * Role bearers are not sorted in any particular way, and their ordering may
860      * change at any point.
861      *
862      * WARNING: When using {getRoleMember} and {getRoleMemberCount}, make sure
863      * you perform all queries on the same block. See the following
864      * https://forum.openzeppelin.com/t/iterating-over-elements-on-enumerableset-in-openzeppelin-contracts/2296[forum post]
865      * for more information.
866      */
867     function getRoleMember(bytes32 role, uint256 index) public view override returns (address) {
868         return _roleMembers[role].at(index);
869     }
870 
871     /**
872      * @dev Returns the number of accounts that have `role`. Can be used
873      * together with {getRoleMember} to enumerate all bearers of a role.
874      */
875     function getRoleMemberCount(bytes32 role) public view override returns (uint256) {
876         return _roleMembers[role].length();
877     }
878 
879     /**
880      * @dev Overload {grantRole} to track enumerable memberships
881      */
882     function grantRole(bytes32 role, address account) public virtual override {
883         super.grantRole(role, account);
884         _roleMembers[role].add(account);
885     }
886 
887     /**
888      * @dev Overload {revokeRole} to track enumerable memberships
889      */
890     function revokeRole(bytes32 role, address account) public virtual override {
891         super.revokeRole(role, account);
892         _roleMembers[role].remove(account);
893     }
894 
895     /**
896      * @dev Overload {renounceRole} to track enumerable memberships
897      */
898     function renounceRole(bytes32 role, address account) public virtual override {
899         super.renounceRole(role, account);
900         _roleMembers[role].remove(account);
901     }
902 
903     /**
904      * @dev Overload {_setupRole} to track enumerable memberships
905      */
906     function _setupRole(bytes32 role, address account) internal virtual override {
907         super._setupRole(role, account);
908         _roleMembers[role].add(account);
909     }
910 }
911 
912 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Burnable.sol
913 
914 
915 pragma solidity ^0.8.0;
916 
917 
918 /**
919  * @dev Extension of {ERC1155} that allows token holders to destroy both their
920  * own tokens and those that they have been approved to use.
921  *
922  * _Available since v3.1._
923  */
924 abstract contract ERC1155Burnable is ERC1155 {
925     function burn(address account, uint256 id, uint256 value) public virtual {
926         require(
927             account == _msgSender() || isApprovedForAll(account, _msgSender()),
928             "ERC1155: caller is not owner nor approved"
929         );
930 
931         _burn(account, id, value);
932     }
933 
934     function burnBatch(address account, uint256[] memory ids, uint256[] memory values) public virtual {
935         require(
936             account == _msgSender() || isApprovedForAll(account, _msgSender()),
937             "ERC1155: caller is not owner nor approved"
938         );
939 
940         _burnBatch(account, ids, values);
941     }
942 }
943 
944 // File: @openzeppelin/contracts/security/Pausable.sol
945 
946 
947 pragma solidity ^0.8.0;
948 
949 
950 /**
951  * @dev Contract module which allows children to implement an emergency stop
952  * mechanism that can be triggered by an authorized account.
953  *
954  * This module is used through inheritance. It will make available the
955  * modifiers `whenNotPaused` and `whenPaused`, which can be applied to
956  * the functions of your contract. Note that they will not be pausable by
957  * simply including this module, only once the modifiers are put in place.
958  */
959 abstract contract Pausable is Context {
960     /**
961      * @dev Emitted when the pause is triggered by `account`.
962      */
963     event Paused(address account);
964 
965     /**
966      * @dev Emitted when the pause is lifted by `account`.
967      */
968     event Unpaused(address account);
969 
970     bool private _paused;
971 
972     /**
973      * @dev Initializes the contract in unpaused state.
974      */
975     constructor () {
976         _paused = false;
977     }
978 
979     /**
980      * @dev Returns true if the contract is paused, and false otherwise.
981      */
982     function paused() public view virtual returns (bool) {
983         return _paused;
984     }
985 
986     /**
987      * @dev Modifier to make a function callable only when the contract is not paused.
988      *
989      * Requirements:
990      *
991      * - The contract must not be paused.
992      */
993     modifier whenNotPaused() {
994         require(!paused(), "Pausable: paused");
995         _;
996     }
997 
998     /**
999      * @dev Modifier to make a function callable only when the contract is paused.
1000      *
1001      * Requirements:
1002      *
1003      * - The contract must be paused.
1004      */
1005     modifier whenPaused() {
1006         require(paused(), "Pausable: not paused");
1007         _;
1008     }
1009 
1010     /**
1011      * @dev Triggers stopped state.
1012      *
1013      * Requirements:
1014      *
1015      * - The contract must not be paused.
1016      */
1017     function _pause() internal virtual whenNotPaused {
1018         _paused = true;
1019         emit Paused(_msgSender());
1020     }
1021 
1022     /**
1023      * @dev Returns to normal state.
1024      *
1025      * Requirements:
1026      *
1027      * - The contract must be paused.
1028      */
1029     function _unpause() internal virtual whenPaused {
1030         _paused = false;
1031         emit Unpaused(_msgSender());
1032     }
1033 }
1034 
1035 // File: @openzeppelin/contracts/token/ERC1155/extensions/ERC1155Pausable.sol
1036 
1037 
1038 pragma solidity ^0.8.0;
1039 
1040 
1041 
1042 /**
1043  * @dev ERC1155 token with pausable token transfers, minting and burning.
1044  *
1045  * Useful for scenarios such as preventing trades until the end of an evaluation
1046  * period, or having an emergency switch for freezing all token transfers in the
1047  * event of a large bug.
1048  *
1049  * _Available since v3.1._
1050  */
1051 abstract contract ERC1155Pausable is ERC1155, Pausable {
1052     /**
1053      * @dev See {ERC1155-_beforeTokenTransfer}.
1054      *
1055      * Requirements:
1056      *
1057      * - the contract must not be paused.
1058      */
1059     function _beforeTokenTransfer(
1060         address operator,
1061         address from,
1062         address to,
1063         uint256[] memory ids,
1064         uint256[] memory amounts,
1065         bytes memory data
1066     )
1067         internal
1068         virtual
1069         override
1070     {
1071         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1072 
1073         require(!paused(), "ERC1155Pausable: token transfer while paused");
1074     }
1075 }
1076 
1077 // File: @openzeppelin/contracts/token/ERC1155/presets/ERC1155PresetMinterPauser.sol
1078 
1079 
1080 pragma solidity ^0.8.0;
1081 
1082 
1083 
1084 
1085 
1086 
1087 /**
1088  * @dev {ERC1155} token, including:
1089  *
1090  *  - ability for holders to burn (destroy) their tokens
1091  *  - a minter role that allows for token minting (creation)
1092  *  - a pauser role that allows to stop all token transfers
1093  *
1094  * This contract uses {AccessControl} to lock permissioned functions using the
1095  * different roles - head to its documentation for details.
1096  *
1097  * The account that deploys the contract will be granted the minter and pauser
1098  * roles, as well as the default admin role, which will let it grant both minter
1099  * and pauser roles to other accounts.
1100  */
1101 contract ERC1155PresetMinterPauser is Context, AccessControlEnumerable, ERC1155Burnable, ERC1155Pausable {
1102     bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
1103     bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");
1104 
1105     /**
1106      * @dev Grants `DEFAULT_ADMIN_ROLE`, `MINTER_ROLE`, and `PAUSER_ROLE` to the account that
1107      * deploys the contract.
1108      */
1109     constructor(string memory uri) ERC1155(uri) {
1110         _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
1111 
1112         _setupRole(MINTER_ROLE, _msgSender());
1113         _setupRole(PAUSER_ROLE, _msgSender());
1114     }
1115 
1116     /**
1117      * @dev Creates `amount` new tokens for `to`, of token type `id`.
1118      *
1119      * See {ERC1155-_mint}.
1120      *
1121      * Requirements:
1122      *
1123      * - the caller must have the `MINTER_ROLE`.
1124      */
1125     function mint(address to, uint256 id, uint256 amount, bytes memory data) public virtual {
1126         require(hasRole(MINTER_ROLE, _msgSender()), "ERC1155PresetMinterPauser: must have minter role to mint");
1127 
1128         _mint(to, id, amount, data);
1129     }
1130 
1131     /**
1132      * @dev xref:ROOT:erc1155.adoc#batch-operations[Batched] variant of {mint}.
1133      */
1134     function mintBatch(address to, uint256[] memory ids, uint256[] memory amounts, bytes memory data) public virtual {
1135         require(hasRole(MINTER_ROLE, _msgSender()), "ERC1155PresetMinterPauser: must have minter role to mint");
1136 
1137         _mintBatch(to, ids, amounts, data);
1138     }
1139 
1140     /**
1141      * @dev Pauses all token transfers.
1142      *
1143      * See {ERC1155Pausable} and {Pausable-_pause}.
1144      *
1145      * Requirements:
1146      *
1147      * - the caller must have the `PAUSER_ROLE`.
1148      */
1149     function pause() public virtual {
1150         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC1155PresetMinterPauser: must have pauser role to pause");
1151         _pause();
1152     }
1153 
1154     /**
1155      * @dev Unpauses all token transfers.
1156      *
1157      * See {ERC1155Pausable} and {Pausable-_unpause}.
1158      *
1159      * Requirements:
1160      *
1161      * - the caller must have the `PAUSER_ROLE`.
1162      */
1163     function unpause() public virtual {
1164         require(hasRole(PAUSER_ROLE, _msgSender()), "ERC1155PresetMinterPauser: must have pauser role to unpause");
1165         _unpause();
1166     }
1167 
1168     /**
1169      * @dev See {IERC165-supportsInterface}.
1170      */
1171     function supportsInterface(bytes4 interfaceId) public view virtual override(AccessControlEnumerable, ERC1155) returns (bool) {
1172         return super.supportsInterface(interfaceId);
1173     }
1174 
1175     function _beforeTokenTransfer(
1176         address operator,
1177         address from,
1178         address to,
1179         uint256[] memory ids,
1180         uint256[] memory amounts,
1181         bytes memory data
1182     )
1183         internal virtual override(ERC1155, ERC1155Pausable)
1184     {
1185         super._beforeTokenTransfer(operator, from, to, ids, amounts, data);
1186     }
1187 }
1188 // File: @openzeppelin/contracts/access/Ownable.sol
1189 
1190 
1191 pragma solidity ^0.8.0;
1192 
1193 /**
1194  * @dev Contract module which provides a basic access control mechanism, where
1195  * there is an account (an owner) that can be granted exclusive access to
1196  * specific functions.
1197  *
1198  * By default, the owner account will be the one that deploys the contract. This
1199  * can later be changed with {transferOwnership}.
1200  *
1201  * This module is used through inheritance. It will make available the modifier
1202  * `onlyOwner`, which can be applied to your functions to restrict their use to
1203  * the owner.
1204  */
1205 abstract contract Ownable is Context {
1206     address private _owner;
1207 
1208     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1209 
1210     /**
1211      * @dev Initializes the contract setting the deployer as the initial owner.
1212      */
1213     constructor () {
1214         address msgSender = _msgSender();
1215         _owner = msgSender;
1216         emit OwnershipTransferred(address(0), msgSender);
1217     }
1218 
1219     /**
1220      * @dev Returns the address of the current owner.
1221      */
1222     function owner() public view virtual returns (address) {
1223         return _owner;
1224     }
1225 
1226     /**
1227      * @dev Throws if called by any account other than the owner.
1228      */
1229     modifier onlyOwner() {
1230         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1231         _;
1232     }
1233 
1234     /**
1235      * @dev Leaves the contract without owner. It will not be possible to call
1236      * `onlyOwner` functions anymore. Can only be called by the current owner.
1237      *
1238      * NOTE: Renouncing ownership will leave the contract without an owner,
1239      * thereby removing any functionality that is only available to the owner.
1240      */
1241     function renounceOwnership() public virtual onlyOwner {
1242         emit OwnershipTransferred(_owner, address(0));
1243         _owner = address(0);
1244     }
1245 
1246     /**
1247      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1248      * Can only be called by the current owner.
1249      */
1250     function transferOwnership(address newOwner) public virtual onlyOwner {
1251         require(newOwner != address(0), "Ownable: new owner is the zero address");
1252         emit OwnershipTransferred(_owner, newOwner);
1253         _owner = newOwner;
1254     }
1255 }
1256 
1257 // File: contracts/simplified/MetisDAC.sol
1258 
1259 pragma solidity ^0.8.0;
1260 pragma experimental ABIEncoderV2;
1261 
1262 
1263 
1264 
1265 
1266 contract MetisDAC is ERC1155PresetMinterPauser, Ownable {
1267     using SafeMath for uint256;
1268     using EnumerableSet for EnumerableSet.UintSet;
1269     
1270     event Claim(address indexed reciever, uint256 id, uint256 code, uint256 claimed);
1271 
1272     constructor() ERC1155PresetMinterPauser("https://nft-static.metisdao.org/jsons/metis_dac/{id}.json") {}
1273     
1274     struct DACInfo {
1275         address originalOwner;
1276         // NFT id
1277         uint256 id;
1278         // Tribe code
1279         uint256 code;
1280         // Tribe power
1281         uint256 power;
1282     }
1283     
1284     // Detect if the user address has claimed
1285     mapping(address => bool) public isClaimedUser;
1286     mapping(uint256 => DACInfo) public originalDacInfoOfId;
1287     // The number of claimed user
1288     uint256 public claimed = 0;
1289     
1290     function claim(
1291         address to, 
1292         uint256 code,
1293         uint256 power
1294     ) external returns(bool) {
1295         require(hasRole(MINTER_ROLE, _msgSender()), "MetisDAC: must have minter role to claim");
1296         require(!isClaimedUser[to], "MetisDAC: can't claim twice");
1297         DACInfo memory dac = DACInfo(
1298             to,
1299             claimed + 257,
1300             code,
1301             power
1302         );
1303         originalDacInfoOfId[claimed + 257] = dac;
1304         claimed += 1;
1305         isClaimedUser[to] = true;
1306         emit Claim(to, dac.id, dac.code, claimed);
1307         mint(to, dac.id, 1, '');
1308         return true;
1309     }
1310 }
1311 
1312 
1313 // File: @openzeppelin/contracts/utils/math/SafeMath.sol
1314 
1315 
1316 pragma solidity ^0.8.0;
1317 
1318 // CAUTION
1319 // This version of SafeMath should only be used with Solidity 0.8 or later,
1320 // because it relies on the compiler's built in overflow checks.
1321 
1322 /**
1323  * @dev Wrappers over Solidity's arithmetic operations.
1324  *
1325  * NOTE: `SafeMath` is no longer needed starting with Solidity 0.8. The compiler
1326  * now has built in overflow checking.
1327  */
1328 library SafeMath {
1329     /**
1330      * @dev Returns the addition of two unsigned integers, with an overflow flag.
1331      *
1332      * _Available since v3.4._
1333      */
1334     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1335         unchecked {
1336             uint256 c = a + b;
1337             if (c < a) return (false, 0);
1338             return (true, c);
1339         }
1340     }
1341 
1342     /**
1343      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
1344      *
1345      * _Available since v3.4._
1346      */
1347     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1348         unchecked {
1349             if (b > a) return (false, 0);
1350             return (true, a - b);
1351         }
1352     }
1353 
1354     /**
1355      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
1356      *
1357      * _Available since v3.4._
1358      */
1359     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1360         unchecked {
1361             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1362             // benefit is lost if 'b' is also tested.
1363             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1364             if (a == 0) return (true, 0);
1365             uint256 c = a * b;
1366             if (c / a != b) return (false, 0);
1367             return (true, c);
1368         }
1369     }
1370 
1371     /**
1372      * @dev Returns the division of two unsigned integers, with a division by zero flag.
1373      *
1374      * _Available since v3.4._
1375      */
1376     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1377         unchecked {
1378             if (b == 0) return (false, 0);
1379             return (true, a / b);
1380         }
1381     }
1382 
1383     /**
1384      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
1385      *
1386      * _Available since v3.4._
1387      */
1388     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
1389         unchecked {
1390             if (b == 0) return (false, 0);
1391             return (true, a % b);
1392         }
1393     }
1394 
1395     /**
1396      * @dev Returns the addition of two unsigned integers, reverting on
1397      * overflow.
1398      *
1399      * Counterpart to Solidity's `+` operator.
1400      *
1401      * Requirements:
1402      *
1403      * - Addition cannot overflow.
1404      */
1405     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1406         return a + b;
1407     }
1408 
1409     /**
1410      * @dev Returns the subtraction of two unsigned integers, reverting on
1411      * overflow (when the result is negative).
1412      *
1413      * Counterpart to Solidity's `-` operator.
1414      *
1415      * Requirements:
1416      *
1417      * - Subtraction cannot overflow.
1418      */
1419     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1420         return a - b;
1421     }
1422 
1423     /**
1424      * @dev Returns the multiplication of two unsigned integers, reverting on
1425      * overflow.
1426      *
1427      * Counterpart to Solidity's `*` operator.
1428      *
1429      * Requirements:
1430      *
1431      * - Multiplication cannot overflow.
1432      */
1433     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1434         return a * b;
1435     }
1436 
1437     /**
1438      * @dev Returns the integer division of two unsigned integers, reverting on
1439      * division by zero. The result is rounded towards zero.
1440      *
1441      * Counterpart to Solidity's `/` operator.
1442      *
1443      * Requirements:
1444      *
1445      * - The divisor cannot be zero.
1446      */
1447     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1448         return a / b;
1449     }
1450 
1451     /**
1452      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1453      * reverting when dividing by zero.
1454      *
1455      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1456      * opcode (which leaves remaining gas untouched) while Solidity uses an
1457      * invalid opcode to revert (consuming all remaining gas).
1458      *
1459      * Requirements:
1460      *
1461      * - The divisor cannot be zero.
1462      */
1463     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1464         return a % b;
1465     }
1466 
1467     /**
1468      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1469      * overflow (when the result is negative).
1470      *
1471      * CAUTION: This function is deprecated because it requires allocating memory for the error
1472      * message unnecessarily. For custom revert reasons use {trySub}.
1473      *
1474      * Counterpart to Solidity's `-` operator.
1475      *
1476      * Requirements:
1477      *
1478      * - Subtraction cannot overflow.
1479      */
1480     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1481         unchecked {
1482             require(b <= a, errorMessage);
1483             return a - b;
1484         }
1485     }
1486 
1487     /**
1488      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
1489      * division by zero. The result is rounded towards zero.
1490      *
1491      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1492      * opcode (which leaves remaining gas untouched) while Solidity uses an
1493      * invalid opcode to revert (consuming all remaining gas).
1494      *
1495      * Counterpart to Solidity's `/` operator. Note: this function uses a
1496      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1497      * uses an invalid opcode to revert (consuming all remaining gas).
1498      *
1499      * Requirements:
1500      *
1501      * - The divisor cannot be zero.
1502      */
1503     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1504         unchecked {
1505             require(b > 0, errorMessage);
1506             return a / b;
1507         }
1508     }
1509 
1510     /**
1511      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1512      * reverting with custom message when dividing by zero.
1513      *
1514      * CAUTION: This function is deprecated because it requires allocating memory for the error
1515      * message unnecessarily. For custom revert reasons use {tryMod}.
1516      *
1517      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1518      * opcode (which leaves remaining gas untouched) while Solidity uses an
1519      * invalid opcode to revert (consuming all remaining gas).
1520      *
1521      * Requirements:
1522      *
1523      * - The divisor cannot be zero.
1524      */
1525     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1526         unchecked {
1527             require(b > 0, errorMessage);
1528             return a % b;
1529         }
1530     }
1531 }
1532 
1533 // File: @openzeppelin/contracts/utils/structs/EnumerableSet.sol
1534 
1535 
1536 pragma solidity ^0.8.0;
1537 
1538 /**
1539  * @dev Library for managing
1540  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
1541  * types.
1542  *
1543  * Sets have the following properties:
1544  *
1545  * - Elements are added, removed, and checked for existence in constant time
1546  * (O(1)).
1547  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
1548  *
1549  * ```
1550  * contract Example {
1551  *     // Add the library methods
1552  *     using EnumerableSet for EnumerableSet.AddressSet;
1553  *
1554  *     // Declare a set state variable
1555  *     EnumerableSet.AddressSet private mySet;
1556  * }
1557  * ```
1558  *
1559  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
1560  * and `uint256` (`UintSet`) are supported.
1561  */
1562 library EnumerableSet {
1563     // To implement this library for multiple types with as little code
1564     // repetition as possible, we write it in terms of a generic Set type with
1565     // bytes32 values.
1566     // The Set implementation uses private functions, and user-facing
1567     // implementations (such as AddressSet) are just wrappers around the
1568     // underlying Set.
1569     // This means that we can only create new EnumerableSets for types that fit
1570     // in bytes32.
1571 
1572     struct Set {
1573         // Storage of set values
1574         bytes32[] _values;
1575 
1576         // Position of the value in the `values` array, plus 1 because index 0
1577         // means a value is not in the set.
1578         mapping (bytes32 => uint256) _indexes;
1579     }
1580 
1581     /**
1582      * @dev Add a value to a set. O(1).
1583      *
1584      * Returns true if the value was added to the set, that is if it was not
1585      * already present.
1586      */
1587     function _add(Set storage set, bytes32 value) private returns (bool) {
1588         if (!_contains(set, value)) {
1589             set._values.push(value);
1590             // The value is stored at length-1, but we add 1 to all indexes
1591             // and use 0 as a sentinel value
1592             set._indexes[value] = set._values.length;
1593             return true;
1594         } else {
1595             return false;
1596         }
1597     }
1598 
1599     /**
1600      * @dev Removes a value from a set. O(1).
1601      *
1602      * Returns true if the value was removed from the set, that is if it was
1603      * present.
1604      */
1605     function _remove(Set storage set, bytes32 value) private returns (bool) {
1606         // We read and store the value's index to prevent multiple reads from the same storage slot
1607         uint256 valueIndex = set._indexes[value];
1608 
1609         if (valueIndex != 0) { // Equivalent to contains(set, value)
1610             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
1611             // the array, and then remove the last element (sometimes called as 'swap and pop').
1612             // This modifies the order of the array, as noted in {at}.
1613 
1614             uint256 toDeleteIndex = valueIndex - 1;
1615             uint256 lastIndex = set._values.length - 1;
1616 
1617             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
1618             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1619 
1620             bytes32 lastvalue = set._values[lastIndex];
1621 
1622             // Move the last value to the index where the value to delete is
1623             set._values[toDeleteIndex] = lastvalue;
1624             // Update the index for the moved value
1625             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
1626 
1627             // Delete the slot where the moved value was stored
1628             set._values.pop();
1629 
1630             // Delete the index for the deleted slot
1631             delete set._indexes[value];
1632 
1633             return true;
1634         } else {
1635             return false;
1636         }
1637     }
1638 
1639     /**
1640      * @dev Returns true if the value is in the set. O(1).
1641      */
1642     function _contains(Set storage set, bytes32 value) private view returns (bool) {
1643         return set._indexes[value] != 0;
1644     }
1645 
1646     /**
1647      * @dev Returns the number of values on the set. O(1).
1648      */
1649     function _length(Set storage set) private view returns (uint256) {
1650         return set._values.length;
1651     }
1652 
1653    /**
1654     * @dev Returns the value stored at position `index` in the set. O(1).
1655     *
1656     * Note that there are no guarantees on the ordering of values inside the
1657     * array, and it may change when more values are added or removed.
1658     *
1659     * Requirements:
1660     *
1661     * - `index` must be strictly less than {length}.
1662     */
1663     function _at(Set storage set, uint256 index) private view returns (bytes32) {
1664         require(set._values.length > index, "EnumerableSet: index out of bounds");
1665         return set._values[index];
1666     }
1667 
1668     // Bytes32Set
1669 
1670     struct Bytes32Set {
1671         Set _inner;
1672     }
1673 
1674     /**
1675      * @dev Add a value to a set. O(1).
1676      *
1677      * Returns true if the value was added to the set, that is if it was not
1678      * already present.
1679      */
1680     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1681         return _add(set._inner, value);
1682     }
1683 
1684     /**
1685      * @dev Removes a value from a set. O(1).
1686      *
1687      * Returns true if the value was removed from the set, that is if it was
1688      * present.
1689      */
1690     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
1691         return _remove(set._inner, value);
1692     }
1693 
1694     /**
1695      * @dev Returns true if the value is in the set. O(1).
1696      */
1697     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
1698         return _contains(set._inner, value);
1699     }
1700 
1701     /**
1702      * @dev Returns the number of values in the set. O(1).
1703      */
1704     function length(Bytes32Set storage set) internal view returns (uint256) {
1705         return _length(set._inner);
1706     }
1707 
1708    /**
1709     * @dev Returns the value stored at position `index` in the set. O(1).
1710     *
1711     * Note that there are no guarantees on the ordering of values inside the
1712     * array, and it may change when more values are added or removed.
1713     *
1714     * Requirements:
1715     *
1716     * - `index` must be strictly less than {length}.
1717     */
1718     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
1719         return _at(set._inner, index);
1720     }
1721 
1722     // AddressSet
1723 
1724     struct AddressSet {
1725         Set _inner;
1726     }
1727 
1728     /**
1729      * @dev Add a value to a set. O(1).
1730      *
1731      * Returns true if the value was added to the set, that is if it was not
1732      * already present.
1733      */
1734     function add(AddressSet storage set, address value) internal returns (bool) {
1735         return _add(set._inner, bytes32(uint256(uint160(value))));
1736     }
1737 
1738     /**
1739      * @dev Removes a value from a set. O(1).
1740      *
1741      * Returns true if the value was removed from the set, that is if it was
1742      * present.
1743      */
1744     function remove(AddressSet storage set, address value) internal returns (bool) {
1745         return _remove(set._inner, bytes32(uint256(uint160(value))));
1746     }
1747 
1748     /**
1749      * @dev Returns true if the value is in the set. O(1).
1750      */
1751     function contains(AddressSet storage set, address value) internal view returns (bool) {
1752         return _contains(set._inner, bytes32(uint256(uint160(value))));
1753     }
1754 
1755     /**
1756      * @dev Returns the number of values in the set. O(1).
1757      */
1758     function length(AddressSet storage set) internal view returns (uint256) {
1759         return _length(set._inner);
1760     }
1761 
1762    /**
1763     * @dev Returns the value stored at position `index` in the set. O(1).
1764     *
1765     * Note that there are no guarantees on the ordering of values inside the
1766     * array, and it may change when more values are added or removed.
1767     *
1768     * Requirements:
1769     *
1770     * - `index` must be strictly less than {length}.
1771     */
1772     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1773         return address(uint160(uint256(_at(set._inner, index))));
1774     }
1775 
1776 
1777     // UintSet
1778 
1779     struct UintSet {
1780         Set _inner;
1781     }
1782 
1783     /**
1784      * @dev Add a value to a set. O(1).
1785      *
1786      * Returns true if the value was added to the set, that is if it was not
1787      * already present.
1788      */
1789     function add(UintSet storage set, uint256 value) internal returns (bool) {
1790         return _add(set._inner, bytes32(value));
1791     }
1792 
1793     /**
1794      * @dev Removes a value from a set. O(1).
1795      *
1796      * Returns true if the value was removed from the set, that is if it was
1797      * present.
1798      */
1799     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1800         return _remove(set._inner, bytes32(value));
1801     }
1802 
1803     /**
1804      * @dev Returns true if the value is in the set. O(1).
1805      */
1806     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1807         return _contains(set._inner, bytes32(value));
1808     }
1809 
1810     /**
1811      * @dev Returns the number of values on the set. O(1).
1812      */
1813     function length(UintSet storage set) internal view returns (uint256) {
1814         return _length(set._inner);
1815     }
1816 
1817    /**
1818     * @dev Returns the value stored at position `index` in the set. O(1).
1819     *
1820     * Note that there are no guarantees on the ordering of values inside the
1821     * array, and it may change when more values are added or removed.
1822     *
1823     * Requirements:
1824     *
1825     * - `index` must be strictly less than {length}.
1826     */
1827     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1828         return uint256(_at(set._inner, index));
1829     }
1830 }
1831 
1832 // File: @openzeppelin/contracts/utils/Address.sol
1833 
1834 
1835 pragma solidity ^0.8.0;
1836 
1837 /**
1838  * @dev Collection of functions related to the address type
1839  */
1840 library Address {
1841     /**
1842      * @dev Returns true if `account` is a contract.
1843      *
1844      * [IMPORTANT]
1845      * ====
1846      * It is unsafe to assume that an address for which this function returns
1847      * false is an externally-owned account (EOA) and not a contract.
1848      *
1849      * Among others, `isContract` will return false for the following
1850      * types of addresses:
1851      *
1852      *  - an externally-owned account
1853      *  - a contract in construction
1854      *  - an address where a contract will be created
1855      *  - an address where a contract lived, but was destroyed
1856      * ====
1857      */
1858     function isContract(address account) internal view returns (bool) {
1859         // This method relies on extcodesize, which returns 0 for contracts in
1860         // construction, since the code is only stored at the end of the
1861         // constructor execution.
1862 
1863         uint256 size;
1864         // solhint-disable-next-line no-inline-assembly
1865         assembly { size := extcodesize(account) }
1866         return size > 0;
1867     }
1868 
1869     /**
1870      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
1871      * `recipient`, forwarding all available gas and reverting on errors.
1872      *
1873      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
1874      * of certain opcodes, possibly making contracts go over the 2300 gas limit
1875      * imposed by `transfer`, making them unable to receive funds via
1876      * `transfer`. {sendValue} removes this limitation.
1877      *
1878      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
1879      *
1880      * IMPORTANT: because control is transferred to `recipient`, care must be
1881      * taken to not create reentrancy vulnerabilities. Consider using
1882      * {ReentrancyGuard} or the
1883      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
1884      */
1885     function sendValue(address payable recipient, uint256 amount) internal {
1886         require(address(this).balance >= amount, "Address: insufficient balance");
1887 
1888         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
1889         (bool success, ) = recipient.call{ value: amount }("");
1890         require(success, "Address: unable to send value, recipient may have reverted");
1891     }
1892 
1893     /**
1894      * @dev Performs a Solidity function call using a low level `call`. A
1895      * plain`call` is an unsafe replacement for a function call: use this
1896      * function instead.
1897      *
1898      * If `target` reverts with a revert reason, it is bubbled up by this
1899      * function (like regular Solidity function calls).
1900      *
1901      * Returns the raw returned data. To convert to the expected return value,
1902      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
1903      *
1904      * Requirements:
1905      *
1906      * - `target` must be a contract.
1907      * - calling `target` with `data` must not revert.
1908      *
1909      * _Available since v3.1._
1910      */
1911     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
1912       return functionCall(target, data, "Address: low-level call failed");
1913     }
1914 
1915     /**
1916      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
1917      * `errorMessage` as a fallback revert reason when `target` reverts.
1918      *
1919      * _Available since v3.1._
1920      */
1921     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1922         return functionCallWithValue(target, data, 0, errorMessage);
1923     }
1924 
1925     /**
1926      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1927      * but also transferring `value` wei to `target`.
1928      *
1929      * Requirements:
1930      *
1931      * - the calling contract must have an ETH balance of at least `value`.
1932      * - the called Solidity function must be `payable`.
1933      *
1934      * _Available since v3.1._
1935      */
1936     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
1937         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
1938     }
1939 
1940     /**
1941      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
1942      * with `errorMessage` as a fallback revert reason when `target` reverts.
1943      *
1944      * _Available since v3.1._
1945      */
1946     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
1947         require(address(this).balance >= value, "Address: insufficient balance for call");
1948         require(isContract(target), "Address: call to non-contract");
1949 
1950         // solhint-disable-next-line avoid-low-level-calls
1951         (bool success, bytes memory returndata) = target.call{ value: value }(data);
1952         return _verifyCallResult(success, returndata, errorMessage);
1953     }
1954 
1955     /**
1956      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1957      * but performing a static call.
1958      *
1959      * _Available since v3.3._
1960      */
1961     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
1962         return functionStaticCall(target, data, "Address: low-level static call failed");
1963     }
1964 
1965     /**
1966      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1967      * but performing a static call.
1968      *
1969      * _Available since v3.3._
1970      */
1971     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
1972         require(isContract(target), "Address: static call to non-contract");
1973 
1974         // solhint-disable-next-line avoid-low-level-calls
1975         (bool success, bytes memory returndata) = target.staticcall(data);
1976         return _verifyCallResult(success, returndata, errorMessage);
1977     }
1978 
1979     /**
1980      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
1981      * but performing a delegate call.
1982      *
1983      * _Available since v3.4._
1984      */
1985     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
1986         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
1987     }
1988 
1989     /**
1990      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
1991      * but performing a delegate call.
1992      *
1993      * _Available since v3.4._
1994      */
1995     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
1996         require(isContract(target), "Address: delegate call to non-contract");
1997 
1998         // solhint-disable-next-line avoid-low-level-calls
1999         (bool success, bytes memory returndata) = target.delegatecall(data);
2000         return _verifyCallResult(success, returndata, errorMessage);
2001     }
2002 
2003     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
2004         if (success) {
2005             return returndata;
2006         } else {
2007             // Look for revert reason and bubble it up if present
2008             if (returndata.length > 0) {
2009                 // The easiest way to bubble the revert reason is using memory via assembly
2010 
2011                 // solhint-disable-next-line no-inline-assembly
2012                 assembly {
2013                     let returndata_size := mload(returndata)
2014                     revert(add(32, returndata), returndata_size)
2015                 }
2016             } else {
2017                 revert(errorMessage);
2018             }
2019         }
2020     }
2021 }
2022 
2023 // File: @openzeppelin/contracts/token/ERC1155/IERC1155Receiver.sol
2024 
2025 
2026 pragma solidity ^0.8.0;
2027 
2028 
2029 /**
2030  * _Available since v3.1._
2031  */
2032 interface IERC1155Receiver is IERC165 {
2033 
2034     /**
2035         @dev Handles the receipt of a single ERC1155 token type. This function is
2036         called at the end of a `safeTransferFrom` after the balance has been updated.
2037         To accept the transfer, this must return
2038         `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
2039         (i.e. 0xf23a6e61, or its own function selector).
2040         @param operator The address which initiated the transfer (i.e. msg.sender)
2041         @param from The address which previously owned the token
2042         @param id The ID of the token being transferred
2043         @param value The amount of tokens being transferred
2044         @param data Additional data with no specified format
2045         @return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))` if transfer is allowed
2046     */
2047     function onERC1155Received(
2048         address operator,
2049         address from,
2050         uint256 id,
2051         uint256 value,
2052         bytes calldata data
2053     )
2054         external
2055         returns(bytes4);
2056 
2057     /**
2058         @dev Handles the receipt of a multiple ERC1155 token types. This function
2059         is called at the end of a `safeBatchTransferFrom` after the balances have
2060         been updated. To accept the transfer(s), this must return
2061         `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
2062         (i.e. 0xbc197c81, or its own function selector).
2063         @param operator The address which initiated the batch transfer (i.e. msg.sender)
2064         @param from The address which previously owned the token
2065         @param ids An array containing ids of each token being transferred (order and length must match values array)
2066         @param values An array containing amounts of each token being transferred (order and length must match ids array)
2067         @param data Additional data with no specified format
2068         @return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))` if transfer is allowed
2069     */
2070     function onERC1155BatchReceived(
2071         address operator,
2072         address from,
2073         uint256[] calldata ids,
2074         uint256[] calldata values,
2075         bytes calldata data
2076     )
2077         external
2078         returns(bytes4);
2079 }
2080 
2081 // File: contracts/simplified/BabelTowerDAC.sol
2082 
2083 pragma solidity ^0.8.0;
2084 
2085 
2086 
2087 
2088 contract BabelTowerDAC is ERC1155PresetMinterPauser, Ownable {
2089     using SafeMath for uint256;
2090     
2091     event Claim(address indexed reciever, uint256 id, uint256 code, uint256 claimed);
2092     event FinalNFTMinted(address indexed reciever, uint256 id, uint256 claimed);
2093     event FinalNFTNameChanged(address indexed sender, uint256 id, string name);
2094     
2095     enum SYNTHETIC_STATUS { INACTIVE, ACTIVE }
2096     
2097     struct BabelTowerPuzzlePiece {
2098         address originalOwner;
2099         // NFT id
2100         uint256 id;
2101         // Tribe code
2102         uint256 code;
2103         // Tribe power
2104         uint256 power;
2105     }
2106     
2107     address payable private DEV_ADDR;
2108     // The status of final NFT
2109     SYNTHETIC_STATUS public FINAL_NFT_STATUS = SYNTHETIC_STATUS.INACTIVE;
2110     uint256 private FINAL_ID = 0;
2111     // The required number of pieces
2112     uint256 public REQUIRED_PIECES = 256;
2113     // The number of claimed user
2114     uint256 public claimed = 0;
2115     string public PUZZLE_NAME_OF_FINAL_NFT = "Rebuilding The Tower Of Babel";
2116     mapping(uint256 => BabelTowerPuzzlePiece) public originalPieceInfoOfId;
2117     // Detect if the user address has claimed
2118     mapping(address => bool) public isClaimedUser;
2119     
2120     constructor(address _devAddr) ERC1155PresetMinterPauser("https://nft-static.metisdao.org/jsons/babel_tower/{id}.json") {
2121         DEV_ADDR = payable(_devAddr);
2122     }
2123     
2124     function claim(
2125         address to, 
2126         uint256 code,
2127         uint256 power
2128     ) external returns(bool) {
2129         require(FINAL_NFT_STATUS == SYNTHETIC_STATUS.INACTIVE, "BabelTowerDAC: can't claim after synthetic");
2130         require(hasRole(MINTER_ROLE, _msgSender()), "BabelTowerDAC: must have minter role to claim");
2131         require(!isClaimedUser[to], "BabelTowerDAC: can't claim twice");
2132         require((claimed + 1) <= REQUIRED_PIECES, "BabelTowerDAC: over required pieces");
2133         BabelTowerPuzzlePiece memory piece = BabelTowerPuzzlePiece(
2134             to,
2135             claimed + 1,
2136             code,
2137             power
2138         );
2139         originalPieceInfoOfId[claimed + 1] = piece;
2140         claimed += 1;
2141         isClaimedUser[to] = true;
2142         emit Claim(to, piece.id, piece.code, claimed);
2143         mint(to, piece.id, 1, '');
2144         return true;
2145     }
2146     
2147     // ====== OWNER METHODS ====== //
2148     
2149     function generateFinalNFT() external onlyOwner {
2150         require(claimed == REQUIRED_PIECES, "BabelTowerDAC: Wait to reach required pieces number");
2151         mint(DEV_ADDR, FINAL_ID, 1, '');
2152         FINAL_NFT_STATUS = SYNTHETIC_STATUS.ACTIVE;
2153         emit FinalNFTMinted(DEV_ADDR, FINAL_ID, claimed);
2154     }
2155     
2156     function setRequiredPieces(uint256 number) external onlyOwner {
2157         require(FINAL_NFT_STATUS == SYNTHETIC_STATUS.INACTIVE, "BabelTowerDAC: can't set after synthetic");
2158         require(number >= claimed, "BabelTowerDAC: number can't less than claimed number");
2159         REQUIRED_PIECES = number;
2160     }
2161     
2162     function setPuzzleName(string memory name) external onlyOwner {
2163         require(FINAL_NFT_STATUS == SYNTHETIC_STATUS.INACTIVE, "BabelTowerDAC: can't set after synthetic");
2164         PUZZLE_NAME_OF_FINAL_NFT = name;
2165         emit FinalNFTNameChanged(msg.sender, FINAL_ID, name);
2166     }
2167 
2168 }
2169 // File: contracts/interfaces/INFTDistributor.sol
2170 
2171 pragma solidity ^0.8.0;
2172 
2173 // Allows anyone to claim a token if they exist in a merkle root.
2174 interface INFTDistributor {
2175     // Returns the merkle root of the merkle tree containing account balances available to claim.
2176     function merkleRoot() external view returns (bytes32);
2177     // Returns true if the index has been marked claimed.
2178     function isClaimed(uint256 index) external view returns (bool);
2179 
2180     // This event is triggered whenever a call to #claim succeeds.
2181     event Claimed(uint256 index, address account, uint256 code);
2182 }
2183 // File: contracts/libs/MerkleProof.sol
2184 
2185 
2186 pragma solidity ^0.8.0;
2187 
2188 /**
2189  * @dev These functions deal with verification of Merkle Trees proofs.
2190  *
2191  * The proofs can be generated using the JavaScript library
2192  * https://github.com/miguelmota/merkletreejs[merkletreejs].
2193  * Note: the hashing algorithm should be keccak256 and pair sorting should be enabled.
2194  *
2195  * See `test/utils/cryptography/MerkleProof.test.js` for some examples.
2196  */
2197 library MerkleProof {
2198     /**
2199      * @dev Returns true if a `leaf` can be proved to be a part of a Merkle tree
2200      * defined by `root`. For this, a `proof` must be provided, containing
2201      * sibling hashes on the branch from the leaf to the root of the tree. Each
2202      * pair of leaves and each pair of pre-images are assumed to be sorted.
2203      */
2204     function verify(bytes32[] memory proof, bytes32 root, bytes32 leaf) internal pure returns (bool) {
2205         bytes32 computedHash = leaf;
2206 
2207         for (uint256 i = 0; i < proof.length; i++) {
2208             bytes32 proofElement = proof[i];
2209 
2210             if (computedHash <= proofElement) {
2211                 // Hash(current computed hash + current element of the proof)
2212                 computedHash = keccak256(abi.encodePacked(computedHash, proofElement));
2213             } else {
2214                 // Hash(current element of the proof + current computed hash)
2215                 computedHash = keccak256(abi.encodePacked(proofElement, computedHash));
2216             }
2217         }
2218 
2219         // Check if the computed hash (root) is equal to the provided root
2220         return computedHash == root;
2221     }
2222 }
2223 // File: contracts/simplified/NFTDistributor.sol
2224 
2225 pragma solidity ^0.8.0;
2226 
2227 
2228 
2229 
2230 
2231 interface DAC {
2232     function claim(
2233         address to, 
2234         uint256 code, 
2235         uint256 power
2236     ) external returns (bool);
2237 }
2238 
2239 contract NFTDistributor is INFTDistributor, Ownable {
2240     address public immutable babelTowerDAC;
2241     address public immutable metisDAC;
2242     bytes32 public immutable override merkleRoot;
2243     uint256 public claimedNumber;
2244     
2245     // This is a packed array of booleans.
2246     mapping(uint256 => uint256) private claimedBitMap;
2247 
2248     constructor(bytes32 merkleRoot_) {
2249         babelTowerDAC = address(new BabelTowerDAC(msg.sender));
2250         metisDAC = address(new MetisDAC());
2251         merkleRoot = merkleRoot_;
2252     }
2253     
2254     function presetRoles() public onlyOwner {
2255         BabelTowerDAC(babelTowerDAC).transferOwnership(msg.sender);
2256         MetisDAC(metisDAC).transferOwnership(msg.sender);
2257         BabelTowerDAC(babelTowerDAC).grantRole(keccak256("MINTER_ROLE"), msg.sender);
2258         BabelTowerDAC(babelTowerDAC).grantRole(keccak256("MINTER_ROLE"), address(this));
2259         MetisDAC(metisDAC).grantRole(keccak256("MINTER_ROLE"), address(this));
2260         BabelTowerDAC(babelTowerDAC).grantRole(bytes32(0x00), msg.sender);
2261         MetisDAC(metisDAC).grantRole(bytes32(0x00), msg.sender);
2262     }
2263 
2264     function isClaimed(uint256 index) public view override returns (bool) {
2265         uint256 claimedWordIndex = index / 256;
2266         uint256 claimedBitIndex = index % 256;
2267         uint256 claimedWord = claimedBitMap[claimedWordIndex];
2268         uint256 mask = (1 << claimedBitIndex);
2269         return claimedWord & mask == mask;
2270     }
2271 
2272     function _setClaimed(uint256 index) private {
2273         uint256 claimedWordIndex = index / 256;
2274         uint256 claimedBitIndex = index % 256;
2275         claimedBitMap[claimedWordIndex] = claimedBitMap[claimedWordIndex] | (1 << claimedBitIndex);
2276     }
2277 
2278     function claim(
2279         address account, 
2280         uint256 index, 
2281         uint256 code, 
2282         uint256 power, 
2283         bytes32[] calldata merkleProof
2284     ) external {
2285         require(!isClaimed(index), 'NFTDistributor: Drop already claimed.');
2286 
2287         // Verify the merkle proof.
2288         bytes32 node = keccak256(abi.encodePacked(index, account, code, power));
2289         require(MerkleProof.verify(merkleProof, merkleRoot, node), 'NFTDistributor: Invalid proof.');
2290 
2291         // Mark it claimed and send the token.
2292         _setClaimed(index);
2293         claimedNumber++;
2294         if (claimedNumber <= 256) {
2295             require(DAC(babelTowerDAC).claim(account, code, power), 'NFTDistributor: Transfer BabelTowerDAC failed.');
2296         } else {
2297             require(DAC(metisDAC).claim(account, code, power), 'NFTDistributor: Transfer MetisDAC failed.');
2298         }
2299 
2300         emit Claimed(index, account, code);
2301     }
2302 }