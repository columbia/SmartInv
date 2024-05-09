1 // Sources flattened with hardhat v2.6.5 https://hardhat.org
2 
3 // File @animoca/ethereum-contracts-core-1.1.2/contracts/metatx/ManagedIdentity.sol@v1.1.2
4 
5 // SPDX-License-Identifier: MIT
6 
7 pragma solidity >=0.7.6 <0.8.0;
8 
9 /*
10  * Provides information about the current execution context, including the
11  * sender of the transaction and its data. While these are generally available
12  * via msg.sender and msg.data, they should not be accessed in such a direct
13  * manner.
14  */
15 abstract contract ManagedIdentity {
16     function _msgSender() internal view virtual returns (address payable) {
17         return msg.sender;
18     }
19 
20     function _msgData() internal view virtual returns (bytes memory) {
21         return msg.data;
22     }
23 }
24 
25 
26 // File @animoca/ethereum-contracts-core-1.1.2/contracts/access/IERC173.sol@v1.1.2
27 
28 pragma solidity >=0.7.6 <0.8.0;
29 
30 /**
31  * @title ERC-173 Contract Ownership Standard
32  * Note: the ERC-165 identifier for this interface is 0x7f5828d0
33  */
34 interface IERC173 {
35     /**
36      * Event emited when ownership of a contract changes.
37      * @param previousOwner the previous owner.
38      * @param newOwner the new owner.
39      */
40     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
41 
42     /**
43      * Get the address of the owner
44      * @return The address of the owner.
45      */
46     function owner() external view returns (address);
47 
48     /**
49      * Set the address of the new owner of the contract
50      * Set newOwner to address(0) to renounce any ownership.
51      * @dev Emits an {OwnershipTransferred} event.
52      * @param newOwner The address of the new owner of the contract. Using the zero address means renouncing ownership.
53      */
54     function transferOwnership(address newOwner) external;
55 }
56 
57 
58 // File @animoca/ethereum-contracts-core-1.1.2/contracts/access/Ownable.sol@v1.1.2
59 
60 pragma solidity >=0.7.6 <0.8.0;
61 
62 
63 /**
64  * @dev Contract module which provides a basic access control mechanism, where
65  * there is an account (an owner) that can be granted exclusive access to
66  * specific functions.
67  *
68  * By default, the owner account will be the one that deploys the contract. This
69  * can later be changed with {transferOwnership}.
70  *
71  * This module is used through inheritance. It will make available the modifier
72  * `onlyOwner`, which can be applied to your functions to restrict their use to
73  * the owner.
74  */
75 abstract contract Ownable is ManagedIdentity, IERC173 {
76     address internal _owner;
77 
78     /**
79      * Initializes the contract, setting the deployer as the initial owner.
80      * @dev Emits an {IERC173-OwnershipTransferred(address,address)} event.
81      */
82     constructor(address owner_) {
83         _owner = owner_;
84         emit OwnershipTransferred(address(0), owner_);
85     }
86 
87     /**
88      * Gets the address of the current contract owner.
89      */
90     function owner() public view virtual override returns (address) {
91         return _owner;
92     }
93 
94     /**
95      * See {IERC173-transferOwnership(address)}
96      * @dev Reverts if the sender is not the current contract owner.
97      * @param newOwner the address of the new owner. Use the zero address to renounce the ownership.
98      */
99     function transferOwnership(address newOwner) public virtual override {
100         _requireOwnership(_msgSender());
101         _owner = newOwner;
102         emit OwnershipTransferred(_owner, newOwner);
103     }
104 
105     /**
106      * @dev Reverts if `account` is not the contract owner.
107      * @param account the account to test.
108      */
109     function _requireOwnership(address account) internal virtual {
110         require(account == this.owner(), "Ownable: not the owner");
111     }
112 }
113 
114 
115 // File @animoca/ethereum-contracts-core-1.1.2/contracts/utils/types/AddressIsContract.sol@v1.1.2
116 
117 // Partially derived from OpenZeppelin:
118 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/406c83649bd6169fc1b578e08506d78f0873b276/contracts/utils/Address.sol
119 
120 pragma solidity >=0.7.6 <0.8.0;
121 
122 /**
123  * @dev Upgrades the address type to check if it is a contract.
124  */
125 library AddressIsContract {
126     /**
127      * @dev Returns true if `account` is a contract.
128      *
129      * [IMPORTANT]
130      * ====
131      * It is unsafe to assume that an address for which this function returns
132      * false is an externally-owned account (EOA) and not a contract.
133      *
134      * Among others, `isContract` will return false for the following
135      * types of addresses:
136      *
137      *  - an externally-owned account
138      *  - a contract in construction
139      *  - an address where a contract will be created
140      *  - an address where a contract lived, but was destroyed
141      * ====
142      */
143     function isContract(address account) internal view returns (bool) {
144         // This method relies on extcodesize, which returns 0 for contracts in
145         // construction, since the code is only stored at the end of the
146         // constructor execution.
147 
148         uint256 size;
149         assembly {
150             size := extcodesize(account)
151         }
152         return size > 0;
153     }
154 }
155 
156 
157 // File @animoca/ethereum-contracts-core-1.1.2/contracts/utils/ERC20Wrapper.sol@v1.1.2
158 
159 pragma solidity >=0.7.6 <0.8.0;
160 
161 /**
162  * @title ERC20Wrapper
163  * Wraps ERC20 functions to support non-standard implementations which do not return a bool value.
164  * Calls to the wrapped functions revert only if they throw or if they return false.
165  */
166 library ERC20Wrapper {
167     using AddressIsContract for address;
168 
169     function wrappedTransfer(
170         IWrappedERC20 token,
171         address to,
172         uint256 value
173     ) internal {
174         _callWithOptionalReturnData(token, abi.encodeWithSelector(token.transfer.selector, to, value));
175     }
176 
177     function wrappedTransferFrom(
178         IWrappedERC20 token,
179         address from,
180         address to,
181         uint256 value
182     ) internal {
183         _callWithOptionalReturnData(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
184     }
185 
186     function wrappedApprove(
187         IWrappedERC20 token,
188         address spender,
189         uint256 value
190     ) internal {
191         _callWithOptionalReturnData(token, abi.encodeWithSelector(token.approve.selector, spender, value));
192     }
193 
194     function _callWithOptionalReturnData(IWrappedERC20 token, bytes memory callData) internal {
195         address target = address(token);
196         require(target.isContract(), "ERC20Wrapper: non-contract");
197 
198         // solhint-disable-next-line avoid-low-level-calls
199         (bool success, bytes memory data) = target.call(callData);
200         if (success) {
201             if (data.length != 0) {
202                 require(abi.decode(data, (bool)), "ERC20Wrapper: operation failed");
203             }
204         } else {
205             // revert using a standard revert message
206             if (data.length == 0) {
207                 revert("ERC20Wrapper: operation failed");
208             }
209 
210             // revert using the revert message coming from the call
211             assembly {
212                 let size := mload(data)
213                 revert(add(32, data), size)
214             }
215         }
216     }
217 }
218 
219 interface IWrappedERC20 {
220     function transfer(address to, uint256 value) external returns (bool);
221 
222     function transferFrom(
223         address from,
224         address to,
225         uint256 value
226     ) external returns (bool);
227 
228     function approve(address spender, uint256 value) external returns (bool);
229 }
230 
231 
232 // File @animoca/ethereum-contracts-core-1.1.2/contracts/utils/Recoverable.sol@v1.1.2
233 
234 pragma solidity >=0.7.6 <0.8.0;
235 
236 
237 
238 abstract contract Recoverable is ManagedIdentity, Ownable {
239     using ERC20Wrapper for IWrappedERC20;
240 
241     /**
242      * Extract ERC20 tokens which were accidentally sent to the contract to a list of accounts.
243      * Warning: this function should be overriden for contracts which are supposed to hold ERC20 tokens
244      * so that the extraction is limited to only amounts sent accidentally.
245      * @dev Reverts if the sender is not the contract owner.
246      * @dev Reverts if `accounts`, `tokens` and `amounts` do not have the same length.
247      * @dev Reverts if one of `tokens` is does not implement the ERC20 transfer function.
248      * @dev Reverts if one of the ERC20 transfers fail for any reason.
249      * @param accounts the list of accounts to transfer the tokens to.
250      * @param tokens the list of ERC20 token addresses.
251      * @param amounts the list of token amounts to transfer.
252      */
253     function recoverERC20s(
254         address[] calldata accounts,
255         address[] calldata tokens,
256         uint256[] calldata amounts
257     ) external virtual {
258         _requireOwnership(_msgSender());
259         uint256 length = accounts.length;
260         require(length == tokens.length && length == amounts.length, "Recov: inconsistent arrays");
261         for (uint256 i = 0; i != length; ++i) {
262             IWrappedERC20(tokens[i]).wrappedTransfer(accounts[i], amounts[i]);
263         }
264     }
265 
266     /**
267      * Extract ERC721 tokens which were accidentally sent to the contract to a list of accounts.
268      * Warning: this function should be overriden for contracts which are supposed to hold ERC721 tokens
269      * so that the extraction is limited to only tokens sent accidentally.
270      * @dev Reverts if the sender is not the contract owner.
271      * @dev Reverts if `accounts`, `contracts` and `amounts` do not have the same length.
272      * @dev Reverts if one of `contracts` is does not implement the ERC721 transferFrom function.
273      * @dev Reverts if one of the ERC721 transfers fail for any reason.
274      * @param accounts the list of accounts to transfer the tokens to.
275      * @param contracts the list of ERC721 contract addresses.
276      * @param tokenIds the list of token ids to transfer.
277      */
278     function recoverERC721s(
279         address[] calldata accounts,
280         address[] calldata contracts,
281         uint256[] calldata tokenIds
282     ) external virtual {
283         _requireOwnership(_msgSender());
284         uint256 length = accounts.length;
285         require(length == contracts.length && length == tokenIds.length, "Recov: inconsistent arrays");
286         for (uint256 i = 0; i != length; ++i) {
287             IRecoverableERC721(contracts[i]).transferFrom(address(this), accounts[i], tokenIds[i]);
288         }
289     }
290 }
291 
292 interface IRecoverableERC721 {
293     /// See {IERC721-transferFrom(address,address,uint256)}
294     function transferFrom(
295         address from,
296         address to,
297         uint256 tokenId
298     ) external;
299 }
300 
301 
302 // File ethereum-universal-forwarder-1.0.0/src/solc_0.7/ERC2771/UsingAppendedCallData.sol@v1.0.0
303 pragma solidity ^0.7.0;
304 
305 abstract contract UsingAppendedCallData {
306     function _lastAppendedDataAsSender() internal pure virtual returns (address payable sender) {
307         // Copied from openzeppelin : https://github.com/OpenZeppelin/openzeppelin-contracts/blob/9d5f77db9da0604ce0b25148898a94ae2c20d70f/contracts/metatx/ERC2771Context.sol1
308         // The assembly code is more direct than the Solidity version using `abi.decode`.
309         // solhint-disable-next-line no-inline-assembly
310         assembly {
311             sender := shr(96, calldataload(sub(calldatasize(), 20)))
312         }
313     }
314 
315     function _msgDataAssuming20BytesAppendedData() internal pure virtual returns (bytes calldata) {
316         return msg.data[:msg.data.length - 20];
317     }
318 }
319 
320 
321 // File ethereum-universal-forwarder-1.0.0/src/solc_0.7/ERC2771/IERC2771.sol@v1.0.0
322 pragma solidity ^0.7.0;
323 
324 interface IERC2771 {
325     function isTrustedForwarder(address forwarder) external view returns (bool);
326 }
327 
328 
329 // File ethereum-universal-forwarder-1.0.0/src/solc_0.7/ERC2771/IForwarderRegistry.sol@v1.0.0
330 pragma solidity ^0.7.0;
331 
332 interface IForwarderRegistry {
333     function isForwarderFor(address, address) external view returns (bool);
334 }
335 
336 
337 // File ethereum-universal-forwarder-1.0.0/src/solc_0.7/ERC2771/UsingUniversalForwarding.sol@v1.0.0
338 pragma solidity ^0.7.0;
339 
340 
341 
342 abstract contract UsingUniversalForwarding is UsingAppendedCallData, IERC2771 {
343     IForwarderRegistry internal immutable _forwarderRegistry;
344     address internal immutable _universalForwarder;
345 
346     constructor(IForwarderRegistry forwarderRegistry, address universalForwarder) {
347         _universalForwarder = universalForwarder;
348         _forwarderRegistry = forwarderRegistry;
349     }
350 
351     function isTrustedForwarder(address forwarder) external view virtual override returns (bool) {
352         return forwarder == _universalForwarder || forwarder == address(_forwarderRegistry);
353     }
354 
355     function _msgSender() internal view virtual returns (address payable) {
356         address payable msgSender = msg.sender;
357         address payable sender = _lastAppendedDataAsSender();
358         if (msgSender == address(_forwarderRegistry) || msgSender == _universalForwarder) {
359             // if forwarder use appended data
360             return sender;
361         }
362 
363         // if msg.sender is neither the registry nor the universal forwarder,
364         // we have to check the last 20bytes of the call data intepreted as an address
365         // and check if the msg.sender was registered as forewarder for that address
366         // we check tx.origin to save gas in case where msg.sender == tx.origin
367         // solhint-disable-next-line avoid-tx-origin
368         if (msgSender != tx.origin && _forwarderRegistry.isForwarderFor(sender, msgSender)) {
369             return sender;
370         }
371 
372         return msgSender;
373     }
374 
375     function _msgData() internal view virtual returns (bytes calldata) {
376         address payable msgSender = msg.sender;
377         if (msgSender == address(_forwarderRegistry) || msgSender == _universalForwarder) {
378             // if forwarder use appended data
379             return _msgDataAssuming20BytesAppendedData();
380         }
381 
382         // we check tx.origin to save gas in case where msg.sender == tx.origin
383         // solhint-disable-next-line avoid-tx-origin
384         if (msgSender != tx.origin && _forwarderRegistry.isForwarderFor(_lastAppendedDataAsSender(), msgSender)) {
385             return _msgDataAssuming20BytesAppendedData();
386         }
387         return msg.data;
388     }
389 }
390 
391 
392 // File @animoca/ethereum-contracts-assets-2.0.0/contracts/token/ERC1155/IERC1155InventoryBurnable.sol@v2.0.0
393 
394 pragma solidity >=0.7.6 <0.8.0;
395 
396 /**
397  * @title ERC1155 Inventory. optional extension: Burnable.
398  * @dev See https://eips.ethereum.org/EIPS/eip-1155
399  * @dev Note: The ERC-165 identifier for this interface is 0x921ed8d1.
400  */
401 interface IERC1155InventoryBurnable {
402     /**
403      * Burns some token.
404      * @dev Reverts if the sender is not approved.
405      * @dev Reverts if `id` does not represent a token.
406      * @dev Reverts if `id` represents a Fungible Token and `value` is 0.
407      * @dev Reverts if `id` represents a Fungible Token and `value` is higher than `from`'s balance.
408      * @dev Reverts if `id` represents a Non-Fungible Token and `value` is not 1.
409      * @dev Reverts if `id` represents a Non-Fungible Token which is not owned by `from`.
410      * @dev Emits an {IERC1155-TransferSingle} event.
411      * @param from Address of the current token owner.
412      * @param id Identifier of the token to burn.
413      * @param value Amount of token to burn.
414      */
415     function burnFrom(
416         address from,
417         uint256 id,
418         uint256 value
419     ) external;
420 
421     /**
422      * Burns multiple tokens.
423      * @dev Reverts if `ids` and `values` have different lengths.
424      * @dev Reverts if the sender is not approved.
425      * @dev Reverts if one of `ids` does not represent a token.
426      * @dev Reverts if one of `ids` represents a Fungible Token and `value` is 0.
427      * @dev Reverts if one of `ids` represents a Fungible Token and `value` is higher than `from`'s balance.
428      * @dev Reverts if one of `ids` represents a Non-Fungible Token and `value` is not 1.
429      * @dev Reverts if one of `ids` represents a Non-Fungible Token which is not owned by `from`.
430      * @dev Emits an {IERC1155-TransferBatch} event.
431      * @param from Address of the current tokens owner.
432      * @param ids Identifiers of the tokens to burn.
433      * @param values Amounts of tokens to burn.
434      */
435     function batchBurnFrom(
436         address from,
437         uint256[] calldata ids,
438         uint256[] calldata values
439     ) external;
440 }
441 
442 
443 // File @animoca/ethereum-contracts-assets-2.0.0/contracts/token/ERC1155/ERC1155InventoryIdentifiersLib.sol@v2.0.0
444 
445 pragma solidity >=0.7.6 <0.8.0;
446 
447 /**
448  * @title ERC1155InventoryIdentifiersLib, a library to introspect inventory identifiers.
449  * @dev With N=32, representing the Non-Fungible Collection mask length, identifiers are represented as follow:
450  * (a) a Fungible Token:
451  *     - most significant bit == 0
452  * (b) a Non-Fungible Collection:
453  *     - most significant bit == 1
454  *     - (256-N) least significant bits == 0
455  * (c) a Non-Fungible Token:
456  *     - most significant bit == 1
457  *     - (256-N) least significant bits != 0
458  */
459 library ERC1155InventoryIdentifiersLib {
460     // Non-Fungible bit. If an id has this bit set, it is a Non-Fungible (either Collection or Token)
461     uint256 internal constant _NF_BIT = 1 << 255;
462 
463     // Mask for Non-Fungible Collection (including the nf bit)
464     uint256 internal constant _NF_COLLECTION_MASK = uint256(type(uint32).max) << 224;
465     uint256 internal constant _NF_TOKEN_MASK = ~_NF_COLLECTION_MASK;
466 
467     function isFungibleToken(uint256 id) internal pure returns (bool) {
468         return id & _NF_BIT == 0;
469     }
470 
471     function isNonFungibleToken(uint256 id) internal pure returns (bool) {
472         return id & _NF_BIT != 0 && id & _NF_TOKEN_MASK != 0;
473     }
474 
475     function getNonFungibleCollection(uint256 nftId) internal pure returns (uint256) {
476         return nftId & _NF_COLLECTION_MASK;
477     }
478 }
479 
480 
481 // File @animoca/ethereum-contracts-core-1.1.2/contracts/introspection/IERC165.sol@v1.1.2
482 
483 pragma solidity >=0.7.6 <0.8.0;
484 
485 /**
486  * @dev Interface of the ERC165 standard, as defined in the
487  * https://eips.ethereum.org/EIPS/eip-165.
488  */
489 interface IERC165 {
490     /**
491      * @dev Returns true if this contract implements the interface defined by
492      * `interfaceId`. See the corresponding
493      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
494      * to learn more about how these ids are created.
495      *
496      * This function call must use less than 30 000 gas.
497      */
498     function supportsInterface(bytes4 interfaceId) external view returns (bool);
499 }
500 
501 
502 // File @animoca/ethereum-contracts-assets-2.0.0/contracts/token/ERC1155/IERC1155.sol@v2.0.0
503 
504 pragma solidity >=0.7.6 <0.8.0;
505 
506 /**
507  * @title ERC1155 Multi Token Standard, basic interface.
508  * @dev See https://eips.ethereum.org/EIPS/eip-1155
509  * @dev Note: The ERC-165 identifier for this interface is 0xd9b67a26.
510  */
511 interface IERC1155 {
512     event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _value);
513 
514     event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _values);
515 
516     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
517 
518     event URI(string _value, uint256 indexed _id);
519 
520     /**
521      * Safely transfers some token.
522      * @dev Reverts if `to` is the zero address.
523      * @dev Reverts if the sender is not approved.
524      * @dev Reverts if `from` has an insufficient balance.
525      * @dev Reverts if `to` is a contract and the call to {IERC1155TokenReceiver-onERC1155received} fails or is refused.
526      * @dev Emits a `TransferSingle` event.
527      * @param from Current token owner.
528      * @param to Address of the new token owner.
529      * @param id Identifier of the token to transfer.
530      * @param value Amount of token to transfer.
531      * @param data Optional data to send along to a receiver contract.
532      */
533     function safeTransferFrom(
534         address from,
535         address to,
536         uint256 id,
537         uint256 value,
538         bytes calldata data
539     ) external;
540 
541     /**
542      * Safely transfers a batch of tokens.
543      * @dev Reverts if `to` is the zero address.
544      * @dev Reverts if `ids` and `values` have different lengths.
545      * @dev Reverts if the sender is not approved.
546      * @dev Reverts if `from` has an insufficient balance for any of `ids`.
547      * @dev Reverts if `to` is a contract and the call to {IERC1155TokenReceiver-onERC1155batchReceived} fails or is refused.
548      * @dev Emits a `TransferBatch` event.
549      * @param from Current token owner.
550      * @param to Address of the new token owner.
551      * @param ids Identifiers of the tokens to transfer.
552      * @param values Amounts of tokens to transfer.
553      * @param data Optional data to send along to a receiver contract.
554      */
555     function safeBatchTransferFrom(
556         address from,
557         address to,
558         uint256[] calldata ids,
559         uint256[] calldata values,
560         bytes calldata data
561     ) external;
562 
563     /**
564      * Retrieves the balance of `id` owned by account `owner`.
565      * @param owner The account to retrieve the balance of.
566      * @param id The identifier to retrieve the balance of.
567      * @return The balance of `id` owned by account `owner`.
568      */
569     function balanceOf(address owner, uint256 id) external view returns (uint256);
570 
571     /**
572      * Retrieves the balances of `ids` owned by accounts `owners`. For each pair:
573      * @dev Reverts if `owners` and `ids` have different lengths.
574      * @param owners The addresses of the token holders
575      * @param ids The identifiers to retrieve the balance of.
576      * @return The balances of `ids` owned by accounts `owners`.
577      */
578     function balanceOfBatch(address[] calldata owners, uint256[] calldata ids) external view returns (uint256[] memory);
579 
580     /**
581      * Enables or disables an operator's approval.
582      * @dev Emits an `ApprovalForAll` event.
583      * @param operator Address of the operator.
584      * @param approved True to approve the operator, false to revoke an approval.
585      */
586     function setApprovalForAll(address operator, bool approved) external;
587 
588     /**
589      * Retrieves the approval status of an operator for a given owner.
590      * @param owner Address of the authorisation giver.
591      * @param operator Address of the operator.
592      * @return True if the operator is approved, false if not.
593      */
594     function isApprovedForAll(address owner, address operator) external view returns (bool);
595 }
596 
597 
598 // File @animoca/ethereum-contracts-assets-2.0.0/contracts/token/ERC1155/IERC1155InventoryFunctions.sol@v2.0.0
599 
600 pragma solidity >=0.7.6 <0.8.0;
601 
602 /**
603  * @title ERC1155 Multi Token Standard, optional extension: Inventory.
604  * Interface for Fungible/Non-Fungible Tokens management on an ERC1155 contract.
605  * @dev See https://eips.ethereum.org/EIPS/eip-xxxx
606  * @dev Note: The ERC-165 identifier for this interface is 0x09ce5c46.
607  */
608 interface IERC1155InventoryFunctions {
609     function ownerOf(uint256 nftId) external view returns (address);
610 
611     function isFungible(uint256 id) external view returns (bool);
612 
613     function collectionOf(uint256 nftId) external view returns (uint256);
614 }
615 
616 
617 // File @animoca/ethereum-contracts-assets-2.0.0/contracts/token/ERC1155/IERC1155Inventory.sol@v2.0.0
618 
619 pragma solidity >=0.7.6 <0.8.0;
620 
621 
622 /**
623  * @title ERC1155 Multi Token Standard, optional extension: Inventory.
624  * Interface for Fungible/Non-Fungible Tokens management on an ERC1155 contract.
625  *
626  * This interface rationalizes the co-existence of Fungible and Non-Fungible Tokens
627  * within the same contract. As several kinds of Fungible Tokens can be managed under
628  * the Multi-Token standard, we consider that Non-Fungible Tokens can be classified
629  * under their own specific type. We introduce the concept of Non-Fungible Collection
630  * and consider the usage of 3 types of identifiers:
631  * (a) Fungible Token identifiers, each representing a set of Fungible Tokens,
632  * (b) Non-Fungible Collection identifiers, each representing a set of Non-Fungible Tokens (this is not a token),
633  * (c) Non-Fungible Token identifiers.
634  *
635  * Identifiers nature
636  * |       Type                | isFungible  | isCollection | isToken |
637  * |  Fungible Token           |   true      |     true     |  true   |
638  * |  Non-Fungible Collection  |   false     |     true     |  false  |
639  * |  Non-Fungible Token       |   false     |     false    |  true   |
640  *
641  * Identifiers compatibilities
642  * |       Type                |  transfer  |   balance    |   supply    |  owner  |
643  * |  Fungible Token           |    OK      |     OK       |     OK      |   NOK   |
644  * |  Non-Fungible Collection  |    NOK     |     OK       |     OK      |   NOK   |
645  * |  Non-Fungible Token       |    OK      |   0 or 1     |   0 or 1    |   OK    |
646  *
647  * @dev See https://eips.ethereum.org/EIPS/eip-xxxx
648  * @dev Note: The ERC-165 identifier for this interface is 0x09ce5c46.
649  */
650 interface IERC1155Inventory is IERC1155, IERC1155InventoryFunctions {
651     //================================================== ERC1155Inventory ===================================================//
652     /**
653      * Optional event emitted when a collection (Fungible Token or Non-Fungible Collection) is created.
654      *  This event can be used by a client application to determine which identifiers are meaningful
655      *  to track through the functions `balanceOf`, `balanceOfBatch` and `totalSupply`.
656      * @dev This event MUST NOT be emitted twice for the same `collectionId`.
657      */
658     event CollectionCreated(uint256 indexed collectionId, bool indexed fungible);
659 
660     /**
661      * Retrieves the owner of a Non-Fungible Token (ERC721-compatible).
662      * @dev Reverts if `nftId` is owned by the zero address.
663      * @param nftId Identifier of the token to query.
664      * @return Address of the current owner of the token.
665      */
666     function ownerOf(uint256 nftId) external view override returns (address);
667 
668     /**
669      * Introspects whether or not `id` represents a Fungible Token.
670      *  This function MUST return true even for a Fungible Token which is not-yet created.
671      * @param id The identifier to query.
672      * @return bool True if `id` represents aFungible Token, false otherwise.
673      */
674     function isFungible(uint256 id) external view override returns (bool);
675 
676     /**
677      * Introspects the Non-Fungible Collection to which `nftId` belongs.
678      * @dev This function MUST return a value representing a Non-Fungible Collection.
679      * @dev This function MUST return a value for a non-existing token, and SHOULD NOT be used to check the existence of a Non-Fungible Token.
680      * @dev Reverts if `nftId` does not represent a Non-Fungible Token.
681      * @param nftId The token identifier to query the collection of.
682      * @return The Non-Fungible Collection identifier to which `nftId` belongs.
683      */
684     function collectionOf(uint256 nftId) external view override returns (uint256);
685 
686     //======================================================= ERC1155 =======================================================//
687 
688     /**
689      * Retrieves the balance of `id` owned by account `owner`.
690      * @param owner The account to retrieve the balance of.
691      * @param id The identifier to retrieve the balance of.
692      * @return
693      *  If `id` represents a collection (Fungible Token or Non-Fungible Collection), the balance for this collection.
694      *  If `id` represents a Non-Fungible Token, 1 if the token is owned by `owner`, else 0.
695      */
696     function balanceOf(address owner, uint256 id) external view override returns (uint256);
697 
698     /**
699      * Retrieves the balances of `ids` owned by accounts `owners`.
700      * @dev Reverts if `owners` and `ids` have different lengths.
701      * @param owners The accounts to retrieve the balances of.
702      * @param ids The identifiers to retrieve the balances of.
703      * @return An array of elements such as for each pair `id`/`owner`:
704      *  If `id` represents a collection (Fungible Token or Non-Fungible Collection), the balance for this collection.
705      *  If `id` represents a Non-Fungible Token, 1 if the token is owned by `owner`, else 0.
706      */
707     function balanceOfBatch(address[] calldata owners, uint256[] calldata ids) external view override returns (uint256[] memory);
708 
709     /**
710      * Safely transfers some token.
711      * @dev Reverts if `to` is the zero address.
712      * @dev Reverts if the sender is not approved.
713      * @dev Reverts if `id` does not represent a token.
714      * @dev Reverts if `id` represents a Non-Fungible Token and `value` is not 1.
715      * @dev Reverts if `id` represents a Non-Fungible Token and is not owned by `from`.
716      * @dev Reverts if `id` represents a Fungible Token and `value` is 0.
717      * @dev Reverts if `id` represents a Fungible Token and `from` has an insufficient balance.
718      * @dev Reverts if `to` is a contract and the call to {IERC1155TokenReceiver-onERC1155received} fails or is refused.
719      * @dev Emits an {IERC1155-TransferSingle} event.
720      * @param from Current token owner.
721      * @param to Address of the new token owner.
722      * @param id Identifier of the token to transfer.
723      * @param value Amount of token to transfer.
724      * @param data Optional data to pass to the receiver contract.
725      */
726     function safeTransferFrom(
727         address from,
728         address to,
729         uint256 id,
730         uint256 value,
731         bytes calldata data
732     ) external override;
733 
734     /**
735      * @notice this documentation overrides its {IERC1155-safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)}.
736      * Safely transfers a batch of tokens.
737      * @dev Reverts if `to` is the zero address.
738      * @dev Reverts if the sender is not approved.
739      * @dev Reverts if one of `ids` does not represent a token.
740      * @dev Reverts if one of `ids` represents a Non-Fungible Token and `value` is not 1.
741      * @dev Reverts if one of `ids` represents a Non-Fungible Token and is not owned by `from`.
742      * @dev Reverts if one of `ids` represents a Fungible Token and `value` is 0.
743      * @dev Reverts if one of `ids` represents a Fungible Token and `from` has an insufficient balance.
744      * @dev Reverts if one of `to` is a contract and the call to {IERC1155TokenReceiver-onERC1155batchReceived} fails or is refused.
745      * @dev Emits an {IERC1155-TransferBatch} event.
746      * @param from Current tokens owner.
747      * @param to Address of the new tokens owner.
748      * @param ids Identifiers of the tokens to transfer.
749      * @param values Amounts of tokens to transfer.
750      * @param data Optional data to pass to the receiver contract.
751      */
752     function safeBatchTransferFrom(
753         address from,
754         address to,
755         uint256[] calldata ids,
756         uint256[] calldata values,
757         bytes calldata data
758     ) external override;
759 }
760 
761 
762 // File @animoca/ethereum-contracts-assets-2.0.0/contracts/token/ERC1155/IERC1155MetadataURI.sol@v2.0.0
763 
764 pragma solidity >=0.7.6 <0.8.0;
765 
766 /**
767  * @title ERC1155 Multi Token Standard, optional extension: Metadata URI.
768  * @dev See https://eips.ethereum.org/EIPS/eip-1155
769  * @dev Note: The ERC-165 identifier for this interface is 0x0e89341c.
770  */
771 interface IERC1155MetadataURI {
772     /**
773      * @notice A distinct Uniform Resource Identifier (URI) for a given token.
774      * @dev URIs are defined in RFC 3986.
775      * @dev The URI MUST point to a JSON file that conforms to the "ERC1155 Metadata URI JSON Schema".
776      * @dev The uri function SHOULD be used to retrieve values if no event was emitted.
777      * @dev The uri function MUST return the same value as the latest event for an _id if it was emitted.
778      * @dev The uri function MUST NOT be used to check for the existence of a token as it is possible for
779      *  an implementation to return a valid string even if the token does not exist.
780      * @return URI string
781      */
782     function uri(uint256 id) external view returns (string memory);
783 }
784 
785 
786 // File @animoca/ethereum-contracts-assets-2.0.0/contracts/token/ERC1155/IERC1155InventoryTotalSupply.sol@v2.0.0
787 
788 pragma solidity >=0.7.6 <0.8.0;
789 
790 /**
791  * @title ERC1155 Inventory, optional extension: Total Supply.
792  * @dev See https://eips.ethereum.org/EIPS/eip-xxxx
793  * @dev Note: The ERC-165 identifier for this interface is 0xbd85b039.
794  */
795 interface IERC1155InventoryTotalSupply {
796     /**
797      * Retrieves the total supply of `id`.
798      * @param id The identifier for which to retrieve the supply of.
799      * @return
800      *  If `id` represents a collection (Fungible Token or Non-Fungible Collection), the total supply for this collection.
801      *  If `id` represents a Non-Fungible Token, 1 if the token exists, else 0.
802      */
803     function totalSupply(uint256 id) external view returns (uint256);
804 }
805 
806 
807 // File @animoca/ethereum-contracts-assets-2.0.0/contracts/token/ERC1155/IERC1155TokenReceiver.sol@v2.0.0
808 
809 pragma solidity >=0.7.6 <0.8.0;
810 
811 /**
812  * @title ERC1155 Multi Token Standard, Tokens Receiver.
813  * Interface for any contract that wants to support transfers from ERC1155 asset contracts.
814  * @dev See https://eips.ethereum.org/EIPS/eip-1155
815  * @dev Note: The ERC-165 identifier for this interface is 0x4e2312e0.
816  */
817 interface IERC1155TokenReceiver {
818     /**
819      * @notice Handle the receipt of a single ERC1155 token type.
820      * An ERC1155 contract MUST call this function on a recipient contract, at the end of a `safeTransferFrom` after the balance update.
821      * This function MUST return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
822      *  (i.e. 0xf23a6e61) to accept the transfer.
823      * Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
824      * @param operator  The address which initiated the transfer (i.e. msg.sender)
825      * @param from      The address which previously owned the token
826      * @param id        The ID of the token being transferred
827      * @param value     The amount of tokens being transferred
828      * @param data      Additional data with no specified format
829      * @return bytes4   `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
830      */
831     function onERC1155Received(
832         address operator,
833         address from,
834         uint256 id,
835         uint256 value,
836         bytes calldata data
837     ) external returns (bytes4);
838 
839     /**
840      * @notice Handle the receipt of multiple ERC1155 token types.
841      * An ERC1155 contract MUST call this function on a recipient contract, at the end of a `safeBatchTransferFrom` after the balance updates.
842      * This function MUST return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
843      *  (i.e. 0xbc197c81) if to accept the transfer(s).
844      * Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
845      * @param operator  The address which initiated the batch transfer (i.e. msg.sender)
846      * @param from      The address which previously owned the token
847      * @param ids       An array containing ids of each token being transferred (order and length must match _values array)
848      * @param values    An array containing amounts of each token being transferred (order and length must match _ids array)
849      * @param data      Additional data with no specified format
850      * @return          `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
851      */
852     function onERC1155BatchReceived(
853         address operator,
854         address from,
855         uint256[] calldata ids,
856         uint256[] calldata values,
857         bytes calldata data
858     ) external returns (bytes4);
859 }
860 
861 
862 // File @animoca/ethereum-contracts-assets-2.0.0/contracts/token/ERC1155/ERC1155InventoryBase.sol@v2.0.0
863 
864 pragma solidity >=0.7.6 <0.8.0;
865 
866 
867 
868 
869 
870 
871 
872 /**
873  * @title ERC1155 Inventory Base.
874  * @dev The functions `safeTransferFrom(address,address,uint256,uint256,bytes)`
875  *  and `safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)` need to be implemented by a child contract.
876  * @dev The function `uri(uint256)` needs to be implemented by a child contract, for example with the help of `BaseMetadataURI`.
877  */
878 abstract contract ERC1155InventoryBase is ManagedIdentity, IERC165, IERC1155Inventory, IERC1155MetadataURI, IERC1155InventoryTotalSupply {
879     using ERC1155InventoryIdentifiersLib for uint256;
880 
881     // bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))
882     bytes4 internal constant _ERC1155_RECEIVED = 0xf23a6e61;
883 
884     // bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))
885     bytes4 internal constant _ERC1155_BATCH_RECEIVED = 0xbc197c81;
886 
887     // Burnt Non-Fungible Token owner's magic value
888     uint256 internal constant _BURNT_NFT_OWNER = 0xdead000000000000000000000000000000000000000000000000000000000000;
889 
890     /* owner => operator => approved */
891     mapping(address => mapping(address => bool)) internal _operators;
892 
893     /* collection ID => owner => balance */
894     mapping(uint256 => mapping(address => uint256)) internal _balances;
895 
896     /* collection ID => supply */
897     mapping(uint256 => uint256) internal _supplies;
898 
899     /* NFT ID => owner */
900     mapping(uint256 => uint256) internal _owners;
901 
902     /* collection ID => creator */
903     mapping(uint256 => address) internal _creators;
904 
905     //======================================================= ERC165 ========================================================//
906 
907     /// @inheritdoc IERC165
908     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
909         return
910             interfaceId == type(IERC165).interfaceId ||
911             interfaceId == type(IERC1155).interfaceId ||
912             interfaceId == type(IERC1155MetadataURI).interfaceId ||
913             interfaceId == type(IERC1155InventoryFunctions).interfaceId ||
914             interfaceId == type(IERC1155InventoryTotalSupply).interfaceId;
915     }
916 
917     //======================================================= ERC1155 =======================================================//
918 
919     /// @inheritdoc IERC1155Inventory
920     function balanceOf(address owner, uint256 id) public view virtual override returns (uint256) {
921         require(owner != address(0), "Inventory: zero address");
922 
923         if (id.isNonFungibleToken()) {
924             return address(uint160(_owners[id])) == owner ? 1 : 0;
925         }
926 
927         return _balances[id][owner];
928     }
929 
930     /// @inheritdoc IERC1155Inventory
931     function balanceOfBatch(address[] calldata owners, uint256[] calldata ids) external view virtual override returns (uint256[] memory) {
932         require(owners.length == ids.length, "Inventory: inconsistent arrays");
933 
934         uint256[] memory balances = new uint256[](owners.length);
935 
936         for (uint256 i = 0; i != owners.length; ++i) {
937             balances[i] = balanceOf(owners[i], ids[i]);
938         }
939 
940         return balances;
941     }
942 
943     /// @inheritdoc IERC1155
944     function setApprovalForAll(address operator, bool approved) public virtual override {
945         address sender = _msgSender();
946         require(operator != sender, "Inventory: self-approval");
947         _operators[sender][operator] = approved;
948         emit ApprovalForAll(sender, operator, approved);
949     }
950 
951     /// @inheritdoc IERC1155
952     function isApprovedForAll(address tokenOwner, address operator) public view virtual override returns (bool) {
953         return _operators[tokenOwner][operator];
954     }
955 
956     //================================================== ERC1155Inventory ===================================================//
957 
958     /// @inheritdoc IERC1155Inventory
959     function isFungible(uint256 id) external pure virtual override returns (bool) {
960         return id.isFungibleToken();
961     }
962 
963     /// @inheritdoc IERC1155Inventory
964     function collectionOf(uint256 nftId) external pure virtual override returns (uint256) {
965         require(nftId.isNonFungibleToken(), "Inventory: not an NFT");
966         return nftId.getNonFungibleCollection();
967     }
968 
969     /// @inheritdoc IERC1155Inventory
970     function ownerOf(uint256 nftId) public view virtual override returns (address) {
971         address owner = address(uint160(_owners[nftId]));
972         require(owner != address(0), "Inventory: non-existing NFT");
973         return owner;
974     }
975 
976     //============================================= ERC1155InventoryTotalSupply =============================================//
977 
978     /// @inheritdoc IERC1155InventoryTotalSupply
979     function totalSupply(uint256 id) external view virtual override returns (uint256) {
980         if (id.isNonFungibleToken()) {
981             return address(uint160(_owners[id])) == address(0) ? 0 : 1;
982         } else {
983             return _supplies[id];
984         }
985     }
986 
987     //============================================ High-level Internal Functions ============================================//
988 
989     /**
990      * Creates a collection (optional).
991      * @dev Reverts if `collectionId` does not represent a collection.
992      * @dev Reverts if `collectionId` has already been created.
993      * @dev Emits a {IERC1155Inventory-CollectionCreated} event.
994      * @param collectionId Identifier of the collection.
995      */
996     function _createCollection(uint256 collectionId) internal virtual {
997         require(!collectionId.isNonFungibleToken(), "Inventory: not a collection");
998         require(_creators[collectionId] == address(0), "Inventory: existing collection");
999         _creators[collectionId] = _msgSender();
1000         emit CollectionCreated(collectionId, collectionId.isFungibleToken());
1001     }
1002 
1003     function _creator(uint256 collectionId) internal view virtual returns (address) {
1004         require(!collectionId.isNonFungibleToken(), "Inventory: not a collection");
1005         return _creators[collectionId];
1006     }
1007 
1008     //============================================== Helper Internal Functions ==============================================//
1009 
1010     /**
1011      * Returns whether `sender` is authorised to make a transfer on behalf of `from`.
1012      * @param from The address to check operatibility upon.
1013      * @param sender The sender address.
1014      * @return True if sender is `from` or an operator for `from`, false otherwise.
1015      */
1016     function _isOperatable(address from, address sender) internal view virtual returns (bool) {
1017         return (from == sender) || _operators[from][sender];
1018     }
1019 
1020     /**
1021      * Calls {IERC1155TokenReceiver-onERC1155Received} on a target contract.
1022      * @dev Reverts if `to` is not a contract.
1023      * @dev Reverts if the call to the target fails or is refused.
1024      * @param from Previous token owner.
1025      * @param to New token owner.
1026      * @param id Identifier of the token transferred.
1027      * @param value Amount of token transferred.
1028      * @param data Optional data to send along with the receiver contract call.
1029      */
1030     function _callOnERC1155Received(
1031         address from,
1032         address to,
1033         uint256 id,
1034         uint256 value,
1035         bytes memory data
1036     ) internal {
1037         require(IERC1155TokenReceiver(to).onERC1155Received(_msgSender(), from, id, value, data) == _ERC1155_RECEIVED, "Inventory: transfer refused");
1038     }
1039 
1040     /**
1041      * Calls {IERC1155TokenReceiver-onERC1155batchReceived} on a target contract.
1042      * @dev Reverts if `to` is not a contract.
1043      * @dev Reverts if the call to the target fails or is refused.
1044      * @param from Previous tokens owner.
1045      * @param to New tokens owner.
1046      * @param ids Identifiers of the tokens to transfer.
1047      * @param values Amounts of tokens to transfer.
1048      * @param data Optional data to send along with the receiver contract call.
1049      */
1050     function _callOnERC1155BatchReceived(
1051         address from,
1052         address to,
1053         uint256[] memory ids,
1054         uint256[] memory values,
1055         bytes memory data
1056     ) internal {
1057         require(
1058             IERC1155TokenReceiver(to).onERC1155BatchReceived(_msgSender(), from, ids, values, data) == _ERC1155_BATCH_RECEIVED,
1059             "Inventory: transfer refused"
1060         );
1061     }
1062 }
1063 
1064 
1065 // File @animoca/ethereum-contracts-assets-2.0.0/contracts/token/ERC1155/ERC1155Inventory.sol@v2.0.0
1066 
1067 pragma solidity >=0.7.6 <0.8.0;
1068 
1069 // solhint-disable-next-line max-line-length
1070 
1071 /**
1072  * @title ERC1155Inventory, a contract which manages up to multiple Collections of Fungible and Non-Fungible Tokens.
1073  * @dev The function `uri(uint256)` needs to be implemented by a child contract, for example with the help of `BaseMetadataURI`.
1074  */
1075 abstract contract ERC1155Inventory is ERC1155InventoryBase {
1076     using AddressIsContract for address;
1077     using ERC1155InventoryIdentifiersLib for uint256;
1078 
1079     //======================================================= ERC1155 =======================================================//
1080 
1081     /// @inheritdoc IERC1155Inventory
1082     function safeTransferFrom(
1083         address from,
1084         address to,
1085         uint256 id,
1086         uint256 value,
1087         bytes memory data
1088     ) public virtual override {
1089         address sender = _msgSender();
1090         require(to != address(0), "Inventory: transfer to zero");
1091         require(_isOperatable(from, sender), "Inventory: non-approved sender");
1092 
1093         if (id.isFungibleToken()) {
1094             _transferFungible(from, to, id, value);
1095         } else if (id.isNonFungibleToken()) {
1096             _transferNFT(from, to, id, value, false);
1097         } else {
1098             revert("Inventory: not a token id");
1099         }
1100 
1101         emit TransferSingle(sender, from, to, id, value);
1102         if (to.isContract()) {
1103             _callOnERC1155Received(from, to, id, value, data);
1104         }
1105     }
1106 
1107     /// @inheritdoc IERC1155Inventory
1108     function safeBatchTransferFrom(
1109         address from,
1110         address to,
1111         uint256[] memory ids,
1112         uint256[] memory values,
1113         bytes memory data
1114     ) public virtual override {
1115         // internal function to avoid stack too deep error
1116         _safeBatchTransferFrom(from, to, ids, values, data);
1117     }
1118 
1119     //============================================ High-level Internal Functions ============================================//
1120 
1121     function _safeBatchTransferFrom(
1122         address from,
1123         address to,
1124         uint256[] memory ids,
1125         uint256[] memory values,
1126         bytes memory data
1127     ) internal {
1128         require(to != address(0), "Inventory: transfer to zero");
1129         uint256 length = ids.length;
1130         require(length == values.length, "Inventory: inconsistent arrays");
1131         address sender = _msgSender();
1132         require(_isOperatable(from, sender), "Inventory: non-approved sender");
1133 
1134         uint256 nfCollectionId;
1135         uint256 nfCollectionCount;
1136         for (uint256 i; i != length; ++i) {
1137             uint256 id = ids[i];
1138             uint256 value = values[i];
1139             if (id.isFungibleToken()) {
1140                 _transferFungible(from, to, id, value);
1141             } else if (id.isNonFungibleToken()) {
1142                 _transferNFT(from, to, id, value, true);
1143                 uint256 nextCollectionId = id.getNonFungibleCollection();
1144                 if (nfCollectionId == 0) {
1145                     nfCollectionId = nextCollectionId;
1146                     nfCollectionCount = 1;
1147                 } else {
1148                     if (nextCollectionId != nfCollectionId) {
1149                         _transferNFTUpdateCollection(from, to, nfCollectionId, nfCollectionCount);
1150                         nfCollectionId = nextCollectionId;
1151                         nfCollectionCount = 1;
1152                     } else {
1153                         ++nfCollectionCount;
1154                     }
1155                 }
1156             } else {
1157                 revert("Inventory: not a token id");
1158             }
1159         }
1160 
1161         if (nfCollectionId != 0) {
1162             _transferNFTUpdateCollection(from, to, nfCollectionId, nfCollectionCount);
1163         }
1164 
1165         emit TransferBatch(sender, from, to, ids, values);
1166         if (to.isContract()) {
1167             _callOnERC1155BatchReceived(from, to, ids, values, data);
1168         }
1169     }
1170 
1171     function _safeMint(
1172         address to,
1173         uint256 id,
1174         uint256 value,
1175         bytes memory data
1176     ) internal {
1177         require(to != address(0), "Inventory: mint to zero");
1178 
1179         if (id.isFungibleToken()) {
1180             _mintFungible(to, id, value);
1181         } else if (id.isNonFungibleToken()) {
1182             _mintNFT(to, id, value, false);
1183         } else {
1184             revert("Inventory: not a token id");
1185         }
1186 
1187         emit TransferSingle(_msgSender(), address(0), to, id, value);
1188         if (to.isContract()) {
1189             _callOnERC1155Received(address(0), to, id, value, data);
1190         }
1191     }
1192 
1193     function _safeBatchMint(
1194         address to,
1195         uint256[] memory ids,
1196         uint256[] memory values,
1197         bytes memory data
1198     ) internal virtual {
1199         require(to != address(0), "Inventory: mint to zero");
1200         uint256 length = ids.length;
1201         require(length == values.length, "Inventory: inconsistent arrays");
1202 
1203         uint256 nfCollectionId;
1204         uint256 nfCollectionCount;
1205         for (uint256 i; i != length; ++i) {
1206             uint256 id = ids[i];
1207             uint256 value = values[i];
1208             if (id.isFungibleToken()) {
1209                 _mintFungible(to, id, value);
1210             } else if (id.isNonFungibleToken()) {
1211                 _mintNFT(to, id, value, true);
1212                 uint256 nextCollectionId = id.getNonFungibleCollection();
1213                 if (nfCollectionId == 0) {
1214                     nfCollectionId = nextCollectionId;
1215                     nfCollectionCount = 1;
1216                 } else {
1217                     if (nextCollectionId != nfCollectionId) {
1218                         _balances[nfCollectionId][to] += nfCollectionCount;
1219                         _supplies[nfCollectionId] += nfCollectionCount;
1220                         nfCollectionId = nextCollectionId;
1221                         nfCollectionCount = 1;
1222                     } else {
1223                         ++nfCollectionCount;
1224                     }
1225                 }
1226             } else {
1227                 revert("Inventory: not a token id");
1228             }
1229         }
1230 
1231         if (nfCollectionId != 0) {
1232             _balances[nfCollectionId][to] += nfCollectionCount;
1233             _supplies[nfCollectionId] += nfCollectionCount;
1234         }
1235 
1236         emit TransferBatch(_msgSender(), address(0), to, ids, values);
1237         if (to.isContract()) {
1238             _callOnERC1155BatchReceived(address(0), to, ids, values, data);
1239         }
1240     }
1241 
1242     //============================================== Helper Internal Functions ==============================================//
1243 
1244     function _mintFungible(
1245         address to,
1246         uint256 id,
1247         uint256 value
1248     ) internal {
1249         require(value != 0, "Inventory: zero value");
1250         uint256 supply = _supplies[id];
1251         uint256 newSupply = supply + value;
1252         require(newSupply > supply, "Inventory: supply overflow");
1253         _supplies[id] = newSupply;
1254         // cannot overflow as any balance is bounded up by the supply which cannot overflow
1255         _balances[id][to] += value;
1256     }
1257 
1258     function _mintNFT(
1259         address to,
1260         uint256 id,
1261         uint256 value,
1262         bool isBatch
1263     ) internal {
1264         require(value == 1, "Inventory: wrong NFT value");
1265         require(_owners[id] == 0, "Inventory: existing/burnt NFT");
1266 
1267         _owners[id] = uint256(uint160(to));
1268 
1269         if (!isBatch) {
1270             uint256 collectionId = id.getNonFungibleCollection();
1271             // it is virtually impossible that a Non-Fungible Collection supply
1272             // overflows due to the cost of minting individual tokens
1273             ++_supplies[collectionId];
1274             // cannot overflow as supply cannot overflow
1275             ++_balances[collectionId][to];
1276         }
1277     }
1278 
1279     function _transferFungible(
1280         address from,
1281         address to,
1282         uint256 id,
1283         uint256 value
1284     ) internal {
1285         require(value != 0, "Inventory: zero value");
1286         uint256 balance = _balances[id][from];
1287         require(balance >= value, "Inventory: not enough balance");
1288         if (from != to) {
1289             _balances[id][from] = balance - value;
1290             // cannot overflow as supply cannot overflow
1291             _balances[id][to] += value;
1292         }
1293     }
1294 
1295     function _transferNFT(
1296         address from,
1297         address to,
1298         uint256 id,
1299         uint256 value,
1300         bool isBatch
1301     ) internal {
1302         require(value == 1, "Inventory: wrong NFT value");
1303         require(from == address(uint160(_owners[id])), "Inventory: non-owned NFT");
1304         _owners[id] = uint256(uint160(to));
1305         if (!isBatch) {
1306             uint256 collectionId = id.getNonFungibleCollection();
1307             // cannot underflow as balance is verified through ownership
1308             _balances[collectionId][from] -= 1;
1309             // cannot overflow as supply cannot overflow
1310             _balances[collectionId][to] += 1;
1311         }
1312     }
1313 
1314     function _transferNFTUpdateCollection(
1315         address from,
1316         address to,
1317         uint256 collectionId,
1318         uint256 amount
1319     ) internal virtual {
1320         if (from != to) {
1321             // cannot underflow as balance is verified through ownership
1322             _balances[collectionId][from] -= amount;
1323             // cannot overflow as supply cannot overflow
1324             _balances[collectionId][to] += amount;
1325         }
1326     }
1327 }
1328 
1329 
1330 // File @animoca/ethereum-contracts-assets-2.0.0/contracts/token/ERC1155/ERC1155InventoryBurnable.sol@v2.0.0
1331 
1332 pragma solidity >=0.7.6 <0.8.0;
1333 
1334 
1335 /**
1336  * @title ERC1155Inventory, burnable version.
1337  * @dev The function `uri(uint256)` needs to be implemented by a child contract, for example with the help of `BaseMetadataURI`.
1338  */
1339 abstract contract ERC1155InventoryBurnable is IERC1155InventoryBurnable, ERC1155Inventory {
1340     using ERC1155InventoryIdentifiersLib for uint256;
1341 
1342     //======================================================= ERC165 ========================================================//
1343 
1344     /// @inheritdoc IERC165
1345     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1346         return interfaceId == type(IERC1155InventoryBurnable).interfaceId || super.supportsInterface(interfaceId);
1347     }
1348 
1349     //============================================== ERC1155InventoryBurnable ===============================================//
1350 
1351     /// @inheritdoc IERC1155InventoryBurnable
1352     function burnFrom(
1353         address from,
1354         uint256 id,
1355         uint256 value
1356     ) public virtual override {
1357         address sender = _msgSender();
1358         require(_isOperatable(from, sender), "Inventory: non-approved sender");
1359 
1360         if (id.isFungibleToken()) {
1361             _burnFungible(from, id, value);
1362         } else if (id.isNonFungibleToken()) {
1363             _burnNFT(from, id, value, false);
1364         } else {
1365             revert("Inventory: not a token id");
1366         }
1367 
1368         emit TransferSingle(sender, from, address(0), id, value);
1369     }
1370 
1371     /// @inheritdoc IERC1155InventoryBurnable
1372     function batchBurnFrom(
1373         address from,
1374         uint256[] memory ids,
1375         uint256[] memory values
1376     ) public virtual override {
1377         uint256 length = ids.length;
1378         require(length == values.length, "Inventory: inconsistent arrays");
1379 
1380         address sender = _msgSender();
1381         require(_isOperatable(from, sender), "Inventory: non-approved sender");
1382 
1383         uint256 nfCollectionId;
1384         uint256 nfCollectionCount;
1385         for (uint256 i; i != length; ++i) {
1386             uint256 id = ids[i];
1387             uint256 value = values[i];
1388             if (id.isFungibleToken()) {
1389                 _burnFungible(from, id, value);
1390             } else if (id.isNonFungibleToken()) {
1391                 _burnNFT(from, id, value, true);
1392                 uint256 nextCollectionId = id.getNonFungibleCollection();
1393                 if (nfCollectionId == 0) {
1394                     nfCollectionId = nextCollectionId;
1395                     nfCollectionCount = 1;
1396                 } else {
1397                     if (nextCollectionId != nfCollectionId) {
1398                         _balances[nfCollectionId][from] -= nfCollectionCount;
1399                         _supplies[nfCollectionId] -= nfCollectionCount;
1400                         nfCollectionId = nextCollectionId;
1401                         nfCollectionCount = 1;
1402                     } else {
1403                         ++nfCollectionCount;
1404                     }
1405                 }
1406             } else {
1407                 revert("Inventory: not a token id");
1408             }
1409         }
1410 
1411         if (nfCollectionId != 0) {
1412             _balances[nfCollectionId][from] -= nfCollectionCount;
1413             _supplies[nfCollectionId] -= nfCollectionCount;
1414         }
1415 
1416         emit TransferBatch(sender, from, address(0), ids, values);
1417     }
1418 
1419     //============================================== Helper Internal Functions ==============================================//
1420 
1421     function _burnFungible(
1422         address from,
1423         uint256 id,
1424         uint256 value
1425     ) internal {
1426         require(value != 0, "Inventory: zero value");
1427         uint256 balance = _balances[id][from];
1428         require(balance >= value, "Inventory: not enough balance");
1429         _balances[id][from] = balance - value;
1430         // Cannot underflow
1431         _supplies[id] -= value;
1432     }
1433 
1434     function _burnNFT(
1435         address from,
1436         uint256 id,
1437         uint256 value,
1438         bool isBatch
1439     ) internal {
1440         require(value == 1, "Inventory: wrong NFT value");
1441         require(from == address(uint160(_owners[id])), "Inventory: non-owned NFT");
1442         _owners[id] = _BURNT_NFT_OWNER;
1443 
1444         if (!isBatch) {
1445             uint256 collectionId = id.getNonFungibleCollection();
1446             // cannot underflow as balance is confirmed through ownership
1447             --_balances[collectionId][from];
1448             // Cannot underflow
1449             --_supplies[collectionId];
1450         }
1451     }
1452 }
1453 
1454 
1455 // File @animoca/ethereum-contracts-assets-2.0.0/contracts/token/ERC1155/IERC1155InventoryMintable.sol@v2.0.0
1456 
1457 pragma solidity >=0.7.6 <0.8.0;
1458 
1459 /**
1460  * @title ERC1155 Inventory, optional extension: Mintable.
1461  * @dev See https://eips.ethereum.org/EIPS/eip-1155
1462  */
1463 interface IERC1155InventoryMintable {
1464     /**
1465      * Safely mints some token.
1466      * @dev Reverts if `to` is the zero address.
1467      * @dev Reverts if `id` is not a token.
1468      * @dev Reverts if `id` represents a Non-Fungible Token and `value` is not 1.
1469      * @dev Reverts if `id` represents a Non-Fungible Token which has already been minted.
1470      * @dev Reverts if `id` represents a Fungible Token and `value` is 0.
1471      * @dev Reverts if `id` represents a Fungible Token and there is an overflow of supply.
1472      * @dev Reverts if `to` is a contract and the call to {IERC1155TokenReceiver-onERC1155Received} fails or is refused.
1473      * @dev Emits an {IERC1155-TransferSingle} event.
1474      * @param to Address of the new token owner.
1475      * @param id Identifier of the token to mint.
1476      * @param value Amount of token to mint.
1477      * @param data Optional data to send along to a receiver contract.
1478      */
1479     function safeMint(
1480         address to,
1481         uint256 id,
1482         uint256 value,
1483         bytes calldata data
1484     ) external;
1485 
1486     /**
1487      * Safely mints a batch of tokens.
1488      * @dev Reverts if `ids` and `values` have different lengths.
1489      * @dev Reverts if `to` is the zero address.
1490      * @dev Reverts if one of `ids` is not a token.
1491      * @dev Reverts if one of `ids` represents a Non-Fungible Token and its paired value is not 1.
1492      * @dev Reverts if one of `ids` represents a Non-Fungible Token which has already been minted.
1493      * @dev Reverts if one of `ids` represents a Fungible Token and its paired value is 0.
1494      * @dev Reverts if one of `ids` represents a Fungible Token and there is an overflow of supply.
1495      * @dev Reverts if `to` is a contract and the call to {IERC1155TokenReceiver-onERC1155batchReceived} fails or is refused.
1496      * @dev Emits an {IERC1155-TransferBatch} event.
1497      * @param to Address of the new tokens owner.
1498      * @param ids Identifiers of the tokens to mint.
1499      * @param values Amounts of tokens to mint.
1500      * @param data Optional data to send along to a receiver contract.
1501      */
1502     function safeBatchMint(
1503         address to,
1504         uint256[] calldata ids,
1505         uint256[] calldata values,
1506         bytes calldata data
1507     ) external;
1508 }
1509 
1510 
1511 // File @animoca/ethereum-contracts-assets-2.0.0/contracts/token/ERC1155/IERC1155InventoryCreator.sol@v2.0.0
1512 
1513 pragma solidity >=0.7.6 <0.8.0;
1514 
1515 /**
1516  * @title ERC1155 Inventory, optional extension: Creator.
1517  * @dev See https://eips.ethereum.org/EIPS/eip-1155
1518  * @dev Note: The ERC-165 identifier for this interface is 0x510b5158.
1519  */
1520 interface IERC1155InventoryCreator {
1521     /**
1522      * Returns the creator of a collection, or the zero address if the collection has not been created.
1523      * @dev Reverts if `collectionId` does not represent a collection.
1524      * @param collectionId Identifier of the collection.
1525      * @return The creator of a collection, or the zero address if the collection has not been created.
1526      */
1527     function creator(uint256 collectionId) external view returns (address);
1528 }
1529 
1530 
1531 // File @animoca/ethereum-contracts-core-1.1.2/contracts/utils/types/UInt256ToDecimalString.sol@v1.1.2
1532 
1533 // Partially derived from OpenZeppelin:
1534 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/8b10cb38d8fedf34f2d89b0ed604f2dceb76d6a9/contracts/utils/Strings.sol
1535 
1536 pragma solidity >=0.7.6 <0.8.0;
1537 
1538 library UInt256ToDecimalString {
1539     function toDecimalString(uint256 value) internal pure returns (string memory) {
1540         if (value == 0) {
1541             return "0";
1542         }
1543         uint256 temp = value;
1544         uint256 digits;
1545         while (temp != 0) {
1546             digits++;
1547             temp /= 10;
1548         }
1549         bytes memory buffer = new bytes(digits);
1550         uint256 index = digits - 1;
1551         temp = value;
1552         while (temp != 0) {
1553             buffer[index--] = bytes1(uint8(48 + (temp % 10)));
1554             temp /= 10;
1555         }
1556         return string(buffer);
1557     }
1558 }
1559 
1560 
1561 // File @animoca/ethereum-contracts-assets-2.0.0/contracts/metadata/BaseMetadataURI.sol@v2.0.0
1562 
1563 pragma solidity >=0.7.6 <0.8.0;
1564 
1565 
1566 abstract contract BaseMetadataURI is ManagedIdentity, Ownable {
1567     using UInt256ToDecimalString for uint256;
1568 
1569     event BaseMetadataURISet(string baseMetadataURI);
1570 
1571     string public baseMetadataURI;
1572 
1573     function setBaseMetadataURI(string calldata baseMetadataURI_) external {
1574         _requireOwnership(_msgSender());
1575         baseMetadataURI = baseMetadataURI_;
1576         emit BaseMetadataURISet(baseMetadataURI_);
1577     }
1578 
1579     function _uri(uint256 id) internal view virtual returns (string memory) {
1580         return string(abi.encodePacked(baseMetadataURI, id.toDecimalString()));
1581     }
1582 }
1583 
1584 
1585 // File @animoca/ethereum-contracts-core-1.1.2/contracts/access/MinterRole.sol@v1.1.2
1586 
1587 pragma solidity >=0.7.6 <0.8.0;
1588 
1589 /**
1590  * Contract which allows derived contracts access control over token minting operations.
1591  */
1592 contract MinterRole is Ownable {
1593     event MinterAdded(address indexed account);
1594     event MinterRemoved(address indexed account);
1595 
1596     mapping(address => bool) public isMinter;
1597 
1598     /**
1599      * Constructor.
1600      */
1601     constructor(address owner_) Ownable(owner_) {
1602         _addMinter(owner_);
1603     }
1604 
1605     /**
1606      * Grants the minter role to a non-minter.
1607      * @dev reverts if the sender is not the contract owner.
1608      * @param account The account to grant the minter role to.
1609      */
1610     function addMinter(address account) public {
1611         _requireOwnership(_msgSender());
1612         _addMinter(account);
1613     }
1614 
1615     /**
1616      * Renounces the granted minter role.
1617      * @dev reverts if the sender is not a minter.
1618      */
1619     function renounceMinter() public {
1620         address account = _msgSender();
1621         _requireMinter(account);
1622         isMinter[account] = false;
1623         emit MinterRemoved(account);
1624     }
1625 
1626     function _requireMinter(address account) internal view {
1627         require(isMinter[account], "MinterRole: not a Minter");
1628     }
1629 
1630     function _addMinter(address account) internal {
1631         isMinter[account] = true;
1632         emit MinterAdded(account);
1633     }
1634 }
1635 
1636 
1637 // File contracts/token/ERC1155/TokenLaunchpadVouchers.sol
1638 
1639 pragma solidity >=0.7.6 <0.8.0;
1640 
1641 
1642 // solhint-disable-next-line max-line-length
1643 
1644 
1645 
1646 
1647 
1648 /**
1649  * @title TokenLaunchpadVouchers
1650  */
1651 contract TokenLaunchpadVouchers is
1652     Recoverable,
1653     UsingUniversalForwarding,
1654     ERC1155InventoryBurnable,
1655     IERC1155InventoryMintable,
1656     IERC1155InventoryCreator,
1657     BaseMetadataURI,
1658     MinterRole
1659 {
1660     constructor(IForwarderRegistry forwarderRegistry, address universalForwarder)
1661         UsingUniversalForwarding(forwarderRegistry, universalForwarder)
1662         MinterRole(msg.sender)
1663     {}
1664 
1665     //======================================================= ERC165 ========================================================//
1666 
1667     /// @inheritdoc IERC165
1668     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1669         return interfaceId == type(IERC1155InventoryCreator).interfaceId || super.supportsInterface(interfaceId);
1670     }
1671 
1672     //================================================= ERC1155MetadataURI ==================================================//
1673 
1674     /// @inheritdoc IERC1155MetadataURI
1675     function uri(uint256 id) external view virtual override returns (string memory) {
1676         return _uri(id);
1677     }
1678 
1679     //=============================================== ERC1155InventoryCreator ===============================================//
1680 
1681     /// @inheritdoc IERC1155InventoryCreator
1682     function creator(uint256 collectionId) external view override returns (address) {
1683         return _creator(collectionId);
1684     }
1685 
1686     //=========================================== ERC1155InventoryCreator (admin) ===========================================//
1687 
1688     /**
1689      * Creates a collection.
1690      * @dev Reverts if the sender is not the contract owner.
1691      * @dev Reverts if `collectionId` does not represent a collection.
1692      * @dev Reverts if `collectionId` has already been created.
1693      * @dev Emits a {IERC1155Inventory-CollectionCreated} event.
1694      * @param collectionId Identifier of the collection.
1695      */
1696     function createCollection(uint256 collectionId) external {
1697         _requireOwnership(_msgSender());
1698         _createCollection(collectionId);
1699     }
1700 
1701     //============================================== ERC1155InventoryMintable ===============================================//
1702 
1703     /// @inheritdoc IERC1155InventoryMintable
1704     /// @dev Reverts if the sender is not a minter.
1705     function safeMint(
1706         address to,
1707         uint256 id,
1708         uint256 value,
1709         bytes memory data
1710     ) public virtual override {
1711         _requireMinter(_msgSender());
1712         _safeMint(to, id, value, data);
1713     }
1714 
1715     /// @inheritdoc IERC1155InventoryMintable
1716     /// @dev Reverts if the sender is not a minter.
1717     function safeBatchMint(
1718         address to,
1719         uint256[] memory ids,
1720         uint256[] memory values,
1721         bytes memory data
1722     ) public virtual override {
1723         _requireMinter(_msgSender());
1724         _safeBatchMint(to, ids, values, data);
1725     }
1726 
1727     //======================================== Meta Transactions Internal Functions =========================================//
1728 
1729     function _msgSender() internal view virtual override(ManagedIdentity, UsingUniversalForwarding) returns (address payable) {
1730         return UsingUniversalForwarding._msgSender();
1731     }
1732 
1733     function _msgData() internal view virtual override(ManagedIdentity, UsingUniversalForwarding) returns (bytes memory ret) {
1734         return UsingUniversalForwarding._msgData();
1735     }
1736 }