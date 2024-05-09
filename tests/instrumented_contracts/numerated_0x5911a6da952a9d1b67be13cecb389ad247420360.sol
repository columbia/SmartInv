1 // Sources flattened with hardhat v2.6.4 https://hardhat.org
2 
3 // File contracts/token/erc1155/BenjiBananasMembershipPassNFT.sol
4 
5 /**
6  *Submitted for verification at Etherscan.io on 2021-10-12
7  */
8 
9 // Sources flattened with hardhat v2.6.5 https://hardhat.org
10 
11 // File @animoca/ethereum-contracts-core-1.1.2/contracts/metatx/ManagedIdentity.sol@v1.1.2
12 
13 // SPDX-License-Identifier: MIT
14 
15 pragma solidity >=0.7.6 <0.8.0;
16 
17 /*
18  * Provides information about the current execution context, including the
19  * sender of the transaction and its data. While these are generally available
20  * via msg.sender and msg.data, they should not be accessed in such a direct
21  * manner.
22  */
23 abstract contract ManagedIdentity {
24     function _msgSender() internal view virtual returns (address payable) {
25         return msg.sender;
26     }
27 
28     function _msgData() internal view virtual returns (bytes memory) {
29         return msg.data;
30     }
31 }
32 
33 // File @animoca/ethereum-contracts-core-1.1.2/contracts/access/IERC173.sol@v1.1.2
34 
35 pragma solidity >=0.7.6 <0.8.0;
36 
37 /**
38  * @title ERC-173 Contract Ownership Standard
39  * Note: the ERC-165 identifier for this interface is 0x7f5828d0
40  */
41 interface IERC173 {
42     /**
43      * Event emited when ownership of a contract changes.
44      * @param previousOwner the previous owner.
45      * @param newOwner the new owner.
46      */
47     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
48 
49     /**
50      * Get the address of the owner
51      * @return The address of the owner.
52      */
53     function owner() external view returns (address);
54 
55     /**
56      * Set the address of the new owner of the contract
57      * Set newOwner to address(0) to renounce any ownership.
58      * @dev Emits an {OwnershipTransferred} event.
59      * @param newOwner The address of the new owner of the contract. Using the zero address means renouncing ownership.
60      */
61     function transferOwnership(address newOwner) external;
62 }
63 
64 // File @animoca/ethereum-contracts-core-1.1.2/contracts/access/Ownable.sol@v1.1.2
65 
66 pragma solidity >=0.7.6 <0.8.0;
67 
68 /**
69  * @dev Contract module which provides a basic access control mechanism, where
70  * there is an account (an owner) that can be granted exclusive access to
71  * specific functions.
72  *
73  * By default, the owner account will be the one that deploys the contract. This
74  * can later be changed with {transferOwnership}.
75  *
76  * This module is used through inheritance. It will make available the modifier
77  * `onlyOwner`, which can be applied to your functions to restrict their use to
78  * the owner.
79  */
80 abstract contract Ownable is ManagedIdentity, IERC173 {
81     address internal _owner;
82 
83     /**
84      * Initializes the contract, setting the deployer as the initial owner.
85      * @dev Emits an {IERC173-OwnershipTransferred(address,address)} event.
86      */
87     constructor(address owner_) {
88         _owner = owner_;
89         emit OwnershipTransferred(address(0), owner_);
90     }
91 
92     /**
93      * Gets the address of the current contract owner.
94      */
95     function owner() public view virtual override returns (address) {
96         return _owner;
97     }
98 
99     /**
100      * See {IERC173-transferOwnership(address)}
101      * @dev Reverts if the sender is not the current contract owner.
102      * @param newOwner the address of the new owner. Use the zero address to renounce the ownership.
103      */
104     function transferOwnership(address newOwner) public virtual override {
105         _requireOwnership(_msgSender());
106         _owner = newOwner;
107         emit OwnershipTransferred(_owner, newOwner);
108     }
109 
110     /**
111      * @dev Reverts if `account` is not the contract owner.
112      * @param account the account to test.
113      */
114     function _requireOwnership(address account) internal virtual {
115         require(account == this.owner(), "Ownable: not the owner");
116     }
117 }
118 
119 // File @animoca/ethereum-contracts-core-1.1.2/contracts/utils/types/AddressIsContract.sol@v1.1.2
120 
121 // Partially derived from OpenZeppelin:
122 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/406c83649bd6169fc1b578e08506d78f0873b276/contracts/utils/Address.sol
123 
124 pragma solidity >=0.7.6 <0.8.0;
125 
126 /**
127  * @dev Upgrades the address type to check if it is a contract.
128  */
129 library AddressIsContract {
130     /**
131      * @dev Returns true if `account` is a contract.
132      *
133      * [IMPORTANT]
134      * ====
135      * It is unsafe to assume that an address for which this function returns
136      * false is an externally-owned account (EOA) and not a contract.
137      *
138      * Among others, `isContract` will return false for the following
139      * types of addresses:
140      *
141      *  - an externally-owned account
142      *  - a contract in construction
143      *  - an address where a contract will be created
144      *  - an address where a contract lived, but was destroyed
145      * ====
146      */
147     function isContract(address account) internal view returns (bool) {
148         // This method relies on extcodesize, which returns 0 for contracts in
149         // construction, since the code is only stored at the end of the
150         // constructor execution.
151 
152         uint256 size;
153         assembly {
154             size := extcodesize(account)
155         }
156         return size > 0;
157     }
158 }
159 
160 // File @animoca/ethereum-contracts-core-1.1.2/contracts/utils/ERC20Wrapper.sol@v1.1.2
161 
162 pragma solidity >=0.7.6 <0.8.0;
163 
164 /**
165  * @title ERC20Wrapper
166  * Wraps ERC20 functions to support non-standard implementations which do not return a bool value.
167  * Calls to the wrapped functions revert only if they throw or if they return false.
168  */
169 library ERC20Wrapper {
170     using AddressIsContract for address;
171 
172     function wrappedTransfer(
173         IWrappedERC20 token,
174         address to,
175         uint256 value
176     ) internal {
177         _callWithOptionalReturnData(token, abi.encodeWithSelector(token.transfer.selector, to, value));
178     }
179 
180     function wrappedTransferFrom(
181         IWrappedERC20 token,
182         address from,
183         address to,
184         uint256 value
185     ) internal {
186         _callWithOptionalReturnData(token, abi.encodeWithSelector(token.transferFrom.selector, from, to, value));
187     }
188 
189     function wrappedApprove(
190         IWrappedERC20 token,
191         address spender,
192         uint256 value
193     ) internal {
194         _callWithOptionalReturnData(token, abi.encodeWithSelector(token.approve.selector, spender, value));
195     }
196 
197     function _callWithOptionalReturnData(IWrappedERC20 token, bytes memory callData) internal {
198         address target = address(token);
199         require(target.isContract(), "ERC20Wrapper: non-contract");
200 
201         // solhint-disable-next-line avoid-low-level-calls
202         (bool success, bytes memory data) = target.call(callData);
203         if (success) {
204             if (data.length != 0) {
205                 require(abi.decode(data, (bool)), "ERC20Wrapper: operation failed");
206             }
207         } else {
208             // revert using a standard revert message
209             if (data.length == 0) {
210                 revert("ERC20Wrapper: operation failed");
211             }
212 
213             // revert using the revert message coming from the call
214             assembly {
215                 let size := mload(data)
216                 revert(add(32, data), size)
217             }
218         }
219     }
220 }
221 
222 interface IWrappedERC20 {
223     function transfer(address to, uint256 value) external returns (bool);
224 
225     function transferFrom(
226         address from,
227         address to,
228         uint256 value
229     ) external returns (bool);
230 
231     function approve(address spender, uint256 value) external returns (bool);
232 }
233 
234 // File @animoca/ethereum-contracts-core-1.1.2/contracts/utils/Recoverable.sol@v1.1.2
235 
236 pragma solidity >=0.7.6 <0.8.0;
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
301 // File ethereum-universal-forwarder-1.0.0/src/solc_0.7/ERC2771/UsingAppendedCallData.sol@v1.0.0
302 pragma solidity ^0.7.0;
303 
304 abstract contract UsingAppendedCallData {
305     function _lastAppendedDataAsSender() internal pure virtual returns (address payable sender) {
306         // Copied from openzeppelin : https://github.com/OpenZeppelin/openzeppelin-contracts/blob/9d5f77db9da0604ce0b25148898a94ae2c20d70f/contracts/metatx/ERC2771Context.sol1
307         // The assembly code is more direct than the Solidity version using `abi.decode`.
308         // solhint-disable-next-line no-inline-assembly
309         assembly {
310             sender := shr(96, calldataload(sub(calldatasize(), 20)))
311         }
312     }
313 
314     function _msgDataAssuming20BytesAppendedData() internal pure virtual returns (bytes calldata) {
315         return msg.data[:msg.data.length - 20];
316     }
317 }
318 
319 // File ethereum-universal-forwarder-1.0.0/src/solc_0.7/ERC2771/IERC2771.sol@v1.0.0
320 pragma solidity ^0.7.0;
321 
322 interface IERC2771 {
323     function isTrustedForwarder(address forwarder) external view returns (bool);
324 }
325 
326 // File ethereum-universal-forwarder-1.0.0/src/solc_0.7/ERC2771/IForwarderRegistry.sol@v1.0.0
327 pragma solidity ^0.7.0;
328 
329 interface IForwarderRegistry {
330     function isForwarderFor(address, address) external view returns (bool);
331 }
332 
333 // File ethereum-universal-forwarder-1.0.0/src/solc_0.7/ERC2771/UsingUniversalForwarding.sol@v1.0.0
334 pragma solidity ^0.7.0;
335 
336 abstract contract UsingUniversalForwarding is UsingAppendedCallData, IERC2771 {
337     IForwarderRegistry internal immutable _forwarderRegistry;
338     address internal immutable _universalForwarder;
339 
340     constructor(IForwarderRegistry forwarderRegistry, address universalForwarder) {
341         _universalForwarder = universalForwarder;
342         _forwarderRegistry = forwarderRegistry;
343     }
344 
345     function isTrustedForwarder(address forwarder) external view virtual override returns (bool) {
346         return forwarder == _universalForwarder || forwarder == address(_forwarderRegistry);
347     }
348 
349     function _msgSender() internal view virtual returns (address payable) {
350         address payable msgSender = msg.sender;
351         address payable sender = _lastAppendedDataAsSender();
352         if (msgSender == address(_forwarderRegistry) || msgSender == _universalForwarder) {
353             // if forwarder use appended data
354             return sender;
355         }
356 
357         // if msg.sender is neither the registry nor the universal forwarder,
358         // we have to check the last 20bytes of the call data intepreted as an address
359         // and check if the msg.sender was registered as forewarder for that address
360         // we check tx.origin to save gas in case where msg.sender == tx.origin
361         // solhint-disable-next-line avoid-tx-origin
362         if (msgSender != tx.origin && _forwarderRegistry.isForwarderFor(sender, msgSender)) {
363             return sender;
364         }
365 
366         return msgSender;
367     }
368 
369     function _msgData() internal view virtual returns (bytes calldata) {
370         address payable msgSender = msg.sender;
371         if (msgSender == address(_forwarderRegistry) || msgSender == _universalForwarder) {
372             // if forwarder use appended data
373             return _msgDataAssuming20BytesAppendedData();
374         }
375 
376         // we check tx.origin to save gas in case where msg.sender == tx.origin
377         // solhint-disable-next-line avoid-tx-origin
378         if (msgSender != tx.origin && _forwarderRegistry.isForwarderFor(_lastAppendedDataAsSender(), msgSender)) {
379             return _msgDataAssuming20BytesAppendedData();
380         }
381         return msg.data;
382     }
383 }
384 
385 // File @animoca/ethereum-contracts-assets-2.0.0/contracts/token/ERC1155/IERC1155InventoryBurnable.sol@v2.0.0
386 
387 pragma solidity >=0.7.6 <0.8.0;
388 
389 /**
390  * @title ERC1155 Inventory. optional extension: Burnable.
391  * @dev See https://eips.ethereum.org/EIPS/eip-1155
392  * @dev Note: The ERC-165 identifier for this interface is 0x921ed8d1.
393  */
394 interface IERC1155InventoryBurnable {
395     /**
396      * Burns some token.
397      * @dev Reverts if the sender is not approved.
398      * @dev Reverts if `id` does not represent a token.
399      * @dev Reverts if `id` represents a Fungible Token and `value` is 0.
400      * @dev Reverts if `id` represents a Fungible Token and `value` is higher than `from`'s balance.
401      * @dev Reverts if `id` represents a Non-Fungible Token and `value` is not 1.
402      * @dev Reverts if `id` represents a Non-Fungible Token which is not owned by `from`.
403      * @dev Emits an {IERC1155-TransferSingle} event.
404      * @param from Address of the current token owner.
405      * @param id Identifier of the token to burn.
406      * @param value Amount of token to burn.
407      */
408     function burnFrom(
409         address from,
410         uint256 id,
411         uint256 value
412     ) external;
413 
414     /**
415      * Burns multiple tokens.
416      * @dev Reverts if `ids` and `values` have different lengths.
417      * @dev Reverts if the sender is not approved.
418      * @dev Reverts if one of `ids` does not represent a token.
419      * @dev Reverts if one of `ids` represents a Fungible Token and `value` is 0.
420      * @dev Reverts if one of `ids` represents a Fungible Token and `value` is higher than `from`'s balance.
421      * @dev Reverts if one of `ids` represents a Non-Fungible Token and `value` is not 1.
422      * @dev Reverts if one of `ids` represents a Non-Fungible Token which is not owned by `from`.
423      * @dev Emits an {IERC1155-TransferBatch} event.
424      * @param from Address of the current tokens owner.
425      * @param ids Identifiers of the tokens to burn.
426      * @param values Amounts of tokens to burn.
427      */
428     function batchBurnFrom(
429         address from,
430         uint256[] calldata ids,
431         uint256[] calldata values
432     ) external;
433 }
434 
435 // File @animoca/ethereum-contracts-assets-2.0.0/contracts/token/ERC1155/ERC1155InventoryIdentifiersLib.sol@v2.0.0
436 
437 pragma solidity >=0.7.6 <0.8.0;
438 
439 /**
440  * @title ERC1155InventoryIdentifiersLib, a library to introspect inventory identifiers.
441  * @dev With N=32, representing the Non-Fungible Collection mask length, identifiers are represented as follow:
442  * (a) a Fungible Token:
443  *     - most significant bit == 0
444  * (b) a Non-Fungible Collection:
445  *     - most significant bit == 1
446  *     - (256-N) least significant bits == 0
447  * (c) a Non-Fungible Token:
448  *     - most significant bit == 1
449  *     - (256-N) least significant bits != 0
450  */
451 library ERC1155InventoryIdentifiersLib {
452     // Non-Fungible bit. If an id has this bit set, it is a Non-Fungible (either Collection or Token)
453     uint256 internal constant _NF_BIT = 1 << 255;
454 
455     // Mask for Non-Fungible Collection (including the nf bit)
456     uint256 internal constant _NF_COLLECTION_MASK = uint256(type(uint32).max) << 224;
457     uint256 internal constant _NF_TOKEN_MASK = ~_NF_COLLECTION_MASK;
458 
459     function isFungibleToken(uint256 id) internal pure returns (bool) {
460         return id & _NF_BIT == 0;
461     }
462 
463     function isNonFungibleToken(uint256 id) internal pure returns (bool) {
464         return id & _NF_BIT != 0 && id & _NF_TOKEN_MASK != 0;
465     }
466 
467     function getNonFungibleCollection(uint256 nftId) internal pure returns (uint256) {
468         return nftId & _NF_COLLECTION_MASK;
469     }
470 }
471 
472 // File @animoca/ethereum-contracts-core-1.1.2/contracts/introspection/IERC165.sol@v1.1.2
473 
474 pragma solidity >=0.7.6 <0.8.0;
475 
476 /**
477  * @dev Interface of the ERC165 standard, as defined in the
478  * https://eips.ethereum.org/EIPS/eip-165.
479  */
480 interface IERC165 {
481     /**
482      * @dev Returns true if this contract implements the interface defined by
483      * `interfaceId`. See the corresponding
484      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
485      * to learn more about how these ids are created.
486      *
487      * This function call must use less than 30 000 gas.
488      */
489     function supportsInterface(bytes4 interfaceId) external view returns (bool);
490 }
491 
492 // File @animoca/ethereum-contracts-assets-2.0.0/contracts/token/ERC1155/IERC1155.sol@v2.0.0
493 
494 pragma solidity >=0.7.6 <0.8.0;
495 
496 /**
497  * @title ERC1155 Multi Token Standard, basic interface.
498  * @dev See https://eips.ethereum.org/EIPS/eip-1155
499  * @dev Note: The ERC-165 identifier for this interface is 0xd9b67a26.
500  */
501 interface IERC1155 {
502     event TransferSingle(address indexed _operator, address indexed _from, address indexed _to, uint256 _id, uint256 _value);
503 
504     event TransferBatch(address indexed _operator, address indexed _from, address indexed _to, uint256[] _ids, uint256[] _values);
505 
506     event ApprovalForAll(address indexed _owner, address indexed _operator, bool _approved);
507 
508     event URI(string _value, uint256 indexed _id);
509 
510     /**
511      * Safely transfers some token.
512      * @dev Reverts if `to` is the zero address.
513      * @dev Reverts if the sender is not approved.
514      * @dev Reverts if `from` has an insufficient balance.
515      * @dev Reverts if `to` is a contract and the call to {IERC1155TokenReceiver-onERC1155received} fails or is refused.
516      * @dev Emits a `TransferSingle` event.
517      * @param from Current token owner.
518      * @param to Address of the new token owner.
519      * @param id Identifier of the token to transfer.
520      * @param value Amount of token to transfer.
521      * @param data Optional data to send along to a receiver contract.
522      */
523     function safeTransferFrom(
524         address from,
525         address to,
526         uint256 id,
527         uint256 value,
528         bytes calldata data
529     ) external;
530 
531     /**
532      * Safely transfers a batch of tokens.
533      * @dev Reverts if `to` is the zero address.
534      * @dev Reverts if `ids` and `values` have different lengths.
535      * @dev Reverts if the sender is not approved.
536      * @dev Reverts if `from` has an insufficient balance for any of `ids`.
537      * @dev Reverts if `to` is a contract and the call to {IERC1155TokenReceiver-onERC1155batchReceived} fails or is refused.
538      * @dev Emits a `TransferBatch` event.
539      * @param from Current token owner.
540      * @param to Address of the new token owner.
541      * @param ids Identifiers of the tokens to transfer.
542      * @param values Amounts of tokens to transfer.
543      * @param data Optional data to send along to a receiver contract.
544      */
545     function safeBatchTransferFrom(
546         address from,
547         address to,
548         uint256[] calldata ids,
549         uint256[] calldata values,
550         bytes calldata data
551     ) external;
552 
553     /**
554      * Retrieves the balance of `id` owned by account `owner`.
555      * @param owner The account to retrieve the balance of.
556      * @param id The identifier to retrieve the balance of.
557      * @return The balance of `id` owned by account `owner`.
558      */
559     function balanceOf(address owner, uint256 id) external view returns (uint256);
560 
561     /**
562      * Retrieves the balances of `ids` owned by accounts `owners`. For each pair:
563      * @dev Reverts if `owners` and `ids` have different lengths.
564      * @param owners The addresses of the token holders
565      * @param ids The identifiers to retrieve the balance of.
566      * @return The balances of `ids` owned by accounts `owners`.
567      */
568     function balanceOfBatch(address[] calldata owners, uint256[] calldata ids) external view returns (uint256[] memory);
569 
570     /**
571      * Enables or disables an operator's approval.
572      * @dev Emits an `ApprovalForAll` event.
573      * @param operator Address of the operator.
574      * @param approved True to approve the operator, false to revoke an approval.
575      */
576     function setApprovalForAll(address operator, bool approved) external;
577 
578     /**
579      * Retrieves the approval status of an operator for a given owner.
580      * @param owner Address of the authorisation giver.
581      * @param operator Address of the operator.
582      * @return True if the operator is approved, false if not.
583      */
584     function isApprovedForAll(address owner, address operator) external view returns (bool);
585 }
586 
587 // File @animoca/ethereum-contracts-assets-2.0.0/contracts/token/ERC1155/IERC1155InventoryFunctions.sol@v2.0.0
588 
589 pragma solidity >=0.7.6 <0.8.0;
590 
591 /**
592  * @title ERC1155 Multi Token Standard, optional extension: Inventory.
593  * Interface for Fungible/Non-Fungible Tokens management on an ERC1155 contract.
594  * @dev See https://eips.ethereum.org/EIPS/eip-xxxx
595  * @dev Note: The ERC-165 identifier for this interface is 0x09ce5c46.
596  */
597 interface IERC1155InventoryFunctions {
598     function ownerOf(uint256 nftId) external view returns (address);
599 
600     function isFungible(uint256 id) external view returns (bool);
601 
602     function collectionOf(uint256 nftId) external view returns (uint256);
603 }
604 
605 // File @animoca/ethereum-contracts-assets-2.0.0/contracts/token/ERC1155/IERC1155Inventory.sol@v2.0.0
606 
607 pragma solidity >=0.7.6 <0.8.0;
608 
609 /**
610  * @title ERC1155 Multi Token Standard, optional extension: Inventory.
611  * Interface for Fungible/Non-Fungible Tokens management on an ERC1155 contract.
612  *
613  * This interface rationalizes the co-existence of Fungible and Non-Fungible Tokens
614  * within the same contract. As several kinds of Fungible Tokens can be managed under
615  * the Multi-Token standard, we consider that Non-Fungible Tokens can be classified
616  * under their own specific type. We introduce the concept of Non-Fungible Collection
617  * and consider the usage of 3 types of identifiers:
618  * (a) Fungible Token identifiers, each representing a set of Fungible Tokens,
619  * (b) Non-Fungible Collection identifiers, each representing a set of Non-Fungible Tokens (this is not a token),
620  * (c) Non-Fungible Token identifiers.
621  *
622  * Identifiers nature
623  * |       Type                | isFungible  | isCollection | isToken |
624  * |  Fungible Token           |   true      |     true     |  true   |
625  * |  Non-Fungible Collection  |   false     |     true     |  false  |
626  * |  Non-Fungible Token       |   false     |     false    |  true   |
627  *
628  * Identifiers compatibilities
629  * |       Type                |  transfer  |   balance    |   supply    |  owner  |
630  * |  Fungible Token           |    OK      |     OK       |     OK      |   NOK   |
631  * |  Non-Fungible Collection  |    NOK     |     OK       |     OK      |   NOK   |
632  * |  Non-Fungible Token       |    OK      |   0 or 1     |   0 or 1    |   OK    |
633  *
634  * @dev See https://eips.ethereum.org/EIPS/eip-xxxx
635  * @dev Note: The ERC-165 identifier for this interface is 0x09ce5c46.
636  */
637 interface IERC1155Inventory is IERC1155, IERC1155InventoryFunctions {
638     //================================================== ERC1155Inventory ===================================================//
639     /**
640      * Optional event emitted when a collection (Fungible Token or Non-Fungible Collection) is created.
641      *  This event can be used by a client application to determine which identifiers are meaningful
642      *  to track through the functions `balanceOf`, `balanceOfBatch` and `totalSupply`.
643      * @dev This event MUST NOT be emitted twice for the same `collectionId`.
644      */
645     event CollectionCreated(uint256 indexed collectionId, bool indexed fungible);
646 
647     /**
648      * Retrieves the owner of a Non-Fungible Token (ERC721-compatible).
649      * @dev Reverts if `nftId` is owned by the zero address.
650      * @param nftId Identifier of the token to query.
651      * @return Address of the current owner of the token.
652      */
653     function ownerOf(uint256 nftId) external view override returns (address);
654 
655     /**
656      * Introspects whether or not `id` represents a Fungible Token.
657      *  This function MUST return true even for a Fungible Token which is not-yet created.
658      * @param id The identifier to query.
659      * @return bool True if `id` represents aFungible Token, false otherwise.
660      */
661     function isFungible(uint256 id) external view override returns (bool);
662 
663     /**
664      * Introspects the Non-Fungible Collection to which `nftId` belongs.
665      * @dev This function MUST return a value representing a Non-Fungible Collection.
666      * @dev This function MUST return a value for a non-existing token, and SHOULD NOT be used to check the existence of a Non-Fungible Token.
667      * @dev Reverts if `nftId` does not represent a Non-Fungible Token.
668      * @param nftId The token identifier to query the collection of.
669      * @return The Non-Fungible Collection identifier to which `nftId` belongs.
670      */
671     function collectionOf(uint256 nftId) external view override returns (uint256);
672 
673     //======================================================= ERC1155 =======================================================//
674 
675     /**
676      * Retrieves the balance of `id` owned by account `owner`.
677      * @param owner The account to retrieve the balance of.
678      * @param id The identifier to retrieve the balance of.
679      * @return
680      *  If `id` represents a collection (Fungible Token or Non-Fungible Collection), the balance for this collection.
681      *  If `id` represents a Non-Fungible Token, 1 if the token is owned by `owner`, else 0.
682      */
683     function balanceOf(address owner, uint256 id) external view override returns (uint256);
684 
685     /**
686      * Retrieves the balances of `ids` owned by accounts `owners`.
687      * @dev Reverts if `owners` and `ids` have different lengths.
688      * @param owners The accounts to retrieve the balances of.
689      * @param ids The identifiers to retrieve the balances of.
690      * @return An array of elements such as for each pair `id`/`owner`:
691      *  If `id` represents a collection (Fungible Token or Non-Fungible Collection), the balance for this collection.
692      *  If `id` represents a Non-Fungible Token, 1 if the token is owned by `owner`, else 0.
693      */
694     function balanceOfBatch(address[] calldata owners, uint256[] calldata ids) external view override returns (uint256[] memory);
695 
696     /**
697      * Safely transfers some token.
698      * @dev Reverts if `to` is the zero address.
699      * @dev Reverts if the sender is not approved.
700      * @dev Reverts if `id` does not represent a token.
701      * @dev Reverts if `id` represents a Non-Fungible Token and `value` is not 1.
702      * @dev Reverts if `id` represents a Non-Fungible Token and is not owned by `from`.
703      * @dev Reverts if `id` represents a Fungible Token and `value` is 0.
704      * @dev Reverts if `id` represents a Fungible Token and `from` has an insufficient balance.
705      * @dev Reverts if `to` is a contract and the call to {IERC1155TokenReceiver-onERC1155received} fails or is refused.
706      * @dev Emits an {IERC1155-TransferSingle} event.
707      * @param from Current token owner.
708      * @param to Address of the new token owner.
709      * @param id Identifier of the token to transfer.
710      * @param value Amount of token to transfer.
711      * @param data Optional data to pass to the receiver contract.
712      */
713     function safeTransferFrom(
714         address from,
715         address to,
716         uint256 id,
717         uint256 value,
718         bytes calldata data
719     ) external override;
720 
721     /**
722      * @notice this documentation overrides its {IERC1155-safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)}.
723      * Safely transfers a batch of tokens.
724      * @dev Reverts if `to` is the zero address.
725      * @dev Reverts if the sender is not approved.
726      * @dev Reverts if one of `ids` does not represent a token.
727      * @dev Reverts if one of `ids` represents a Non-Fungible Token and `value` is not 1.
728      * @dev Reverts if one of `ids` represents a Non-Fungible Token and is not owned by `from`.
729      * @dev Reverts if one of `ids` represents a Fungible Token and `value` is 0.
730      * @dev Reverts if one of `ids` represents a Fungible Token and `from` has an insufficient balance.
731      * @dev Reverts if one of `to` is a contract and the call to {IERC1155TokenReceiver-onERC1155batchReceived} fails or is refused.
732      * @dev Emits an {IERC1155-TransferBatch} event.
733      * @param from Current tokens owner.
734      * @param to Address of the new tokens owner.
735      * @param ids Identifiers of the tokens to transfer.
736      * @param values Amounts of tokens to transfer.
737      * @param data Optional data to pass to the receiver contract.
738      */
739     function safeBatchTransferFrom(
740         address from,
741         address to,
742         uint256[] calldata ids,
743         uint256[] calldata values,
744         bytes calldata data
745     ) external override;
746 }
747 
748 // File @animoca/ethereum-contracts-assets-2.0.0/contracts/token/ERC1155/IERC1155MetadataURI.sol@v2.0.0
749 
750 pragma solidity >=0.7.6 <0.8.0;
751 
752 /**
753  * @title ERC1155 Multi Token Standard, optional extension: Metadata URI.
754  * @dev See https://eips.ethereum.org/EIPS/eip-1155
755  * @dev Note: The ERC-165 identifier for this interface is 0x0e89341c.
756  */
757 interface IERC1155MetadataURI {
758     /**
759      * @notice A distinct Uniform Resource Identifier (URI) for a given token.
760      * @dev URIs are defined in RFC 3986.
761      * @dev The URI MUST point to a JSON file that conforms to the "ERC1155 Metadata URI JSON Schema".
762      * @dev The uri function SHOULD be used to retrieve values if no event was emitted.
763      * @dev The uri function MUST return the same value as the latest event for an _id if it was emitted.
764      * @dev The uri function MUST NOT be used to check for the existence of a token as it is possible for
765      *  an implementation to return a valid string even if the token does not exist.
766      * @return URI string
767      */
768     function uri(uint256 id) external view returns (string memory);
769 }
770 
771 // File @animoca/ethereum-contracts-assets-2.0.0/contracts/token/ERC1155/IERC1155InventoryTotalSupply.sol@v2.0.0
772 
773 pragma solidity >=0.7.6 <0.8.0;
774 
775 /**
776  * @title ERC1155 Inventory, optional extension: Total Supply.
777  * @dev See https://eips.ethereum.org/EIPS/eip-xxxx
778  * @dev Note: The ERC-165 identifier for this interface is 0xbd85b039.
779  */
780 interface IERC1155InventoryTotalSupply {
781     /**
782      * Retrieves the total supply of `id`.
783      * @param id The identifier for which to retrieve the supply of.
784      * @return
785      *  If `id` represents a collection (Fungible Token or Non-Fungible Collection), the total supply for this collection.
786      *  If `id` represents a Non-Fungible Token, 1 if the token exists, else 0.
787      */
788     function totalSupply(uint256 id) external view returns (uint256);
789 }
790 
791 // File @animoca/ethereum-contracts-assets-2.0.0/contracts/token/ERC1155/IERC1155TokenReceiver.sol@v2.0.0
792 
793 pragma solidity >=0.7.6 <0.8.0;
794 
795 /**
796  * @title ERC1155 Multi Token Standard, Tokens Receiver.
797  * Interface for any contract that wants to support transfers from ERC1155 asset contracts.
798  * @dev See https://eips.ethereum.org/EIPS/eip-1155
799  * @dev Note: The ERC-165 identifier for this interface is 0x4e2312e0.
800  */
801 interface IERC1155TokenReceiver {
802     /**
803      * @notice Handle the receipt of a single ERC1155 token type.
804      * An ERC1155 contract MUST call this function on a recipient contract, at the end of a `safeTransferFrom` after the balance update.
805      * This function MUST return `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
806      *  (i.e. 0xf23a6e61) to accept the transfer.
807      * Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
808      * @param operator  The address which initiated the transfer (i.e. msg.sender)
809      * @param from      The address which previously owned the token
810      * @param id        The ID of the token being transferred
811      * @param value     The amount of tokens being transferred
812      * @param data      Additional data with no specified format
813      * @return bytes4   `bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))`
814      */
815     function onERC1155Received(
816         address operator,
817         address from,
818         uint256 id,
819         uint256 value,
820         bytes calldata data
821     ) external returns (bytes4);
822 
823     /**
824      * @notice Handle the receipt of multiple ERC1155 token types.
825      * An ERC1155 contract MUST call this function on a recipient contract, at the end of a `safeBatchTransferFrom` after the balance updates.
826      * This function MUST return `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
827      *  (i.e. 0xbc197c81) if to accept the transfer(s).
828      * Return of any other value than the prescribed keccak256 generated value MUST result in the transaction being reverted by the caller.
829      * @param operator  The address which initiated the batch transfer (i.e. msg.sender)
830      * @param from      The address which previously owned the token
831      * @param ids       An array containing ids of each token being transferred (order and length must match _values array)
832      * @param values    An array containing amounts of each token being transferred (order and length must match _ids array)
833      * @param data      Additional data with no specified format
834      * @return          `bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))`
835      */
836     function onERC1155BatchReceived(
837         address operator,
838         address from,
839         uint256[] calldata ids,
840         uint256[] calldata values,
841         bytes calldata data
842     ) external returns (bytes4);
843 }
844 
845 // File @animoca/ethereum-contracts-assets-2.0.0/contracts/token/ERC1155/ERC1155InventoryBase.sol@v2.0.0
846 
847 pragma solidity >=0.7.6 <0.8.0;
848 
849 /**
850  * @title ERC1155 Inventory Base.
851  * @dev The functions `safeTransferFrom(address,address,uint256,uint256,bytes)`
852  *  and `safeBatchTransferFrom(address,address,uint256[],uint256[],bytes)` need to be implemented by a child contract.
853  * @dev The function `uri(uint256)` needs to be implemented by a child contract, for example with the help of `BaseMetadataURI`.
854  */
855 abstract contract ERC1155InventoryBase is ManagedIdentity, IERC165, IERC1155Inventory, IERC1155MetadataURI, IERC1155InventoryTotalSupply {
856     using ERC1155InventoryIdentifiersLib for uint256;
857 
858     // bytes4(keccak256("onERC1155Received(address,address,uint256,uint256,bytes)"))
859     bytes4 internal constant _ERC1155_RECEIVED = 0xf23a6e61;
860 
861     // bytes4(keccak256("onERC1155BatchReceived(address,address,uint256[],uint256[],bytes)"))
862     bytes4 internal constant _ERC1155_BATCH_RECEIVED = 0xbc197c81;
863 
864     // Burnt Non-Fungible Token owner's magic value
865     uint256 internal constant _BURNT_NFT_OWNER = 0xdead000000000000000000000000000000000000000000000000000000000000;
866 
867     /* owner => operator => approved */
868     mapping(address => mapping(address => bool)) internal _operators;
869 
870     /* collection ID => owner => balance */
871     mapping(uint256 => mapping(address => uint256)) internal _balances;
872 
873     /* collection ID => supply */
874     mapping(uint256 => uint256) internal _supplies;
875 
876     /* NFT ID => owner */
877     mapping(uint256 => uint256) internal _owners;
878 
879     /* collection ID => creator */
880     mapping(uint256 => address) internal _creators;
881 
882     //======================================================= ERC165 ========================================================//
883 
884     /// @inheritdoc IERC165
885     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
886         return
887             interfaceId == type(IERC165).interfaceId ||
888             interfaceId == type(IERC1155).interfaceId ||
889             interfaceId == type(IERC1155MetadataURI).interfaceId ||
890             interfaceId == type(IERC1155InventoryFunctions).interfaceId ||
891             interfaceId == type(IERC1155InventoryTotalSupply).interfaceId;
892     }
893 
894     //======================================================= ERC1155 =======================================================//
895 
896     /// @inheritdoc IERC1155Inventory
897     function balanceOf(address owner, uint256 id) public view virtual override returns (uint256) {
898         require(owner != address(0), "Inventory: zero address");
899 
900         if (id.isNonFungibleToken()) {
901             return address(uint160(_owners[id])) == owner ? 1 : 0;
902         }
903 
904         return _balances[id][owner];
905     }
906 
907     /// @inheritdoc IERC1155Inventory
908     function balanceOfBatch(address[] calldata owners, uint256[] calldata ids) external view virtual override returns (uint256[] memory) {
909         require(owners.length == ids.length, "Inventory: inconsistent arrays");
910 
911         uint256[] memory balances = new uint256[](owners.length);
912 
913         for (uint256 i = 0; i != owners.length; ++i) {
914             balances[i] = balanceOf(owners[i], ids[i]);
915         }
916 
917         return balances;
918     }
919 
920     /// @inheritdoc IERC1155
921     function setApprovalForAll(address operator, bool approved) public virtual override {
922         address sender = _msgSender();
923         require(operator != sender, "Inventory: self-approval");
924         _operators[sender][operator] = approved;
925         emit ApprovalForAll(sender, operator, approved);
926     }
927 
928     /// @inheritdoc IERC1155
929     function isApprovedForAll(address tokenOwner, address operator) public view virtual override returns (bool) {
930         return _operators[tokenOwner][operator];
931     }
932 
933     //================================================== ERC1155Inventory ===================================================//
934 
935     /// @inheritdoc IERC1155Inventory
936     function isFungible(uint256 id) external pure virtual override returns (bool) {
937         return id.isFungibleToken();
938     }
939 
940     /// @inheritdoc IERC1155Inventory
941     function collectionOf(uint256 nftId) external pure virtual override returns (uint256) {
942         require(nftId.isNonFungibleToken(), "Inventory: not an NFT");
943         return nftId.getNonFungibleCollection();
944     }
945 
946     /// @inheritdoc IERC1155Inventory
947     function ownerOf(uint256 nftId) public view virtual override returns (address) {
948         address owner = address(uint160(_owners[nftId]));
949         require(owner != address(0), "Inventory: non-existing NFT");
950         return owner;
951     }
952 
953     //============================================= ERC1155InventoryTotalSupply =============================================//
954 
955     /// @inheritdoc IERC1155InventoryTotalSupply
956     function totalSupply(uint256 id) external view virtual override returns (uint256) {
957         if (id.isNonFungibleToken()) {
958             return address(uint160(_owners[id])) == address(0) ? 0 : 1;
959         } else {
960             return _supplies[id];
961         }
962     }
963 
964     //============================================ High-level Internal Functions ============================================//
965 
966     /**
967      * Creates a collection (optional).
968      * @dev Reverts if `collectionId` does not represent a collection.
969      * @dev Reverts if `collectionId` has already been created.
970      * @dev Emits a {IERC1155Inventory-CollectionCreated} event.
971      * @param collectionId Identifier of the collection.
972      */
973     function _createCollection(uint256 collectionId) internal virtual {
974         require(!collectionId.isNonFungibleToken(), "Inventory: not a collection");
975         require(_creators[collectionId] == address(0), "Inventory: existing collection");
976         _creators[collectionId] = _msgSender();
977         emit CollectionCreated(collectionId, collectionId.isFungibleToken());
978     }
979 
980     function _creator(uint256 collectionId) internal view virtual returns (address) {
981         require(!collectionId.isNonFungibleToken(), "Inventory: not a collection");
982         return _creators[collectionId];
983     }
984 
985     //============================================== Helper Internal Functions ==============================================//
986 
987     /**
988      * Returns whether `sender` is authorised to make a transfer on behalf of `from`.
989      * @param from The address to check operatibility upon.
990      * @param sender The sender address.
991      * @return True if sender is `from` or an operator for `from`, false otherwise.
992      */
993     function _isOperatable(address from, address sender) internal view virtual returns (bool) {
994         return (from == sender) || _operators[from][sender];
995     }
996 
997     /**
998      * Calls {IERC1155TokenReceiver-onERC1155Received} on a target contract.
999      * @dev Reverts if `to` is not a contract.
1000      * @dev Reverts if the call to the target fails or is refused.
1001      * @param from Previous token owner.
1002      * @param to New token owner.
1003      * @param id Identifier of the token transferred.
1004      * @param value Amount of token transferred.
1005      * @param data Optional data to send along with the receiver contract call.
1006      */
1007     function _callOnERC1155Received(
1008         address from,
1009         address to,
1010         uint256 id,
1011         uint256 value,
1012         bytes memory data
1013     ) internal {
1014         require(IERC1155TokenReceiver(to).onERC1155Received(_msgSender(), from, id, value, data) == _ERC1155_RECEIVED, "Inventory: transfer refused");
1015     }
1016 
1017     /**
1018      * Calls {IERC1155TokenReceiver-onERC1155batchReceived} on a target contract.
1019      * @dev Reverts if `to` is not a contract.
1020      * @dev Reverts if the call to the target fails or is refused.
1021      * @param from Previous tokens owner.
1022      * @param to New tokens owner.
1023      * @param ids Identifiers of the tokens to transfer.
1024      * @param values Amounts of tokens to transfer.
1025      * @param data Optional data to send along with the receiver contract call.
1026      */
1027     function _callOnERC1155BatchReceived(
1028         address from,
1029         address to,
1030         uint256[] memory ids,
1031         uint256[] memory values,
1032         bytes memory data
1033     ) internal {
1034         require(
1035             IERC1155TokenReceiver(to).onERC1155BatchReceived(_msgSender(), from, ids, values, data) == _ERC1155_BATCH_RECEIVED,
1036             "Inventory: transfer refused"
1037         );
1038     }
1039 }
1040 
1041 // File @animoca/ethereum-contracts-assets-2.0.0/contracts/token/ERC1155/ERC1155Inventory.sol@v2.0.0
1042 
1043 pragma solidity >=0.7.6 <0.8.0;
1044 
1045 // solhint-disable-next-line max-line-length
1046 
1047 /**
1048  * @title ERC1155Inventory, a contract which manages up to multiple Collections of Fungible and Non-Fungible Tokens.
1049  * @dev The function `uri(uint256)` needs to be implemented by a child contract, for example with the help of `BaseMetadataURI`.
1050  */
1051 abstract contract ERC1155Inventory is ERC1155InventoryBase {
1052     using AddressIsContract for address;
1053     using ERC1155InventoryIdentifiersLib for uint256;
1054 
1055     //======================================================= ERC1155 =======================================================//
1056 
1057     /// @inheritdoc IERC1155Inventory
1058     function safeTransferFrom(
1059         address from,
1060         address to,
1061         uint256 id,
1062         uint256 value,
1063         bytes memory data
1064     ) public virtual override {
1065         address sender = _msgSender();
1066         require(to != address(0), "Inventory: transfer to zero");
1067         require(_isOperatable(from, sender), "Inventory: non-approved sender");
1068 
1069         if (id.isFungibleToken()) {
1070             _transferFungible(from, to, id, value);
1071         } else if (id.isNonFungibleToken()) {
1072             _transferNFT(from, to, id, value, false);
1073         } else {
1074             revert("Inventory: not a token id");
1075         }
1076 
1077         emit TransferSingle(sender, from, to, id, value);
1078         if (to.isContract()) {
1079             _callOnERC1155Received(from, to, id, value, data);
1080         }
1081     }
1082 
1083     /// @inheritdoc IERC1155Inventory
1084     function safeBatchTransferFrom(
1085         address from,
1086         address to,
1087         uint256[] memory ids,
1088         uint256[] memory values,
1089         bytes memory data
1090     ) public virtual override {
1091         // internal function to avoid stack too deep error
1092         _safeBatchTransferFrom(from, to, ids, values, data);
1093     }
1094 
1095     //============================================ High-level Internal Functions ============================================//
1096 
1097     function _safeBatchTransferFrom(
1098         address from,
1099         address to,
1100         uint256[] memory ids,
1101         uint256[] memory values,
1102         bytes memory data
1103     ) internal {
1104         require(to != address(0), "Inventory: transfer to zero");
1105         uint256 length = ids.length;
1106         require(length == values.length, "Inventory: inconsistent arrays");
1107         address sender = _msgSender();
1108         require(_isOperatable(from, sender), "Inventory: non-approved sender");
1109 
1110         uint256 nfCollectionId;
1111         uint256 nfCollectionCount;
1112         for (uint256 i; i != length; ++i) {
1113             uint256 id = ids[i];
1114             uint256 value = values[i];
1115             if (id.isFungibleToken()) {
1116                 _transferFungible(from, to, id, value);
1117             } else if (id.isNonFungibleToken()) {
1118                 _transferNFT(from, to, id, value, true);
1119                 uint256 nextCollectionId = id.getNonFungibleCollection();
1120                 if (nfCollectionId == 0) {
1121                     nfCollectionId = nextCollectionId;
1122                     nfCollectionCount = 1;
1123                 } else {
1124                     if (nextCollectionId != nfCollectionId) {
1125                         _transferNFTUpdateCollection(from, to, nfCollectionId, nfCollectionCount);
1126                         nfCollectionId = nextCollectionId;
1127                         nfCollectionCount = 1;
1128                     } else {
1129                         ++nfCollectionCount;
1130                     }
1131                 }
1132             } else {
1133                 revert("Inventory: not a token id");
1134             }
1135         }
1136 
1137         if (nfCollectionId != 0) {
1138             _transferNFTUpdateCollection(from, to, nfCollectionId, nfCollectionCount);
1139         }
1140 
1141         emit TransferBatch(sender, from, to, ids, values);
1142         if (to.isContract()) {
1143             _callOnERC1155BatchReceived(from, to, ids, values, data);
1144         }
1145     }
1146 
1147     function _safeMint(
1148         address to,
1149         uint256 id,
1150         uint256 value,
1151         bytes memory data
1152     ) internal {
1153         require(to != address(0), "Inventory: mint to zero");
1154 
1155         if (id.isFungibleToken()) {
1156             _mintFungible(to, id, value);
1157         } else if (id.isNonFungibleToken()) {
1158             _mintNFT(to, id, value, false);
1159         } else {
1160             revert("Inventory: not a token id");
1161         }
1162 
1163         emit TransferSingle(_msgSender(), address(0), to, id, value);
1164         if (to.isContract()) {
1165             _callOnERC1155Received(address(0), to, id, value, data);
1166         }
1167     }
1168 
1169     function _safeBatchMint(
1170         address to,
1171         uint256[] memory ids,
1172         uint256[] memory values,
1173         bytes memory data
1174     ) internal virtual {
1175         require(to != address(0), "Inventory: mint to zero");
1176         uint256 length = ids.length;
1177         require(length == values.length, "Inventory: inconsistent arrays");
1178 
1179         uint256 nfCollectionId;
1180         uint256 nfCollectionCount;
1181         for (uint256 i; i != length; ++i) {
1182             uint256 id = ids[i];
1183             uint256 value = values[i];
1184             if (id.isFungibleToken()) {
1185                 _mintFungible(to, id, value);
1186             } else if (id.isNonFungibleToken()) {
1187                 _mintNFT(to, id, value, true);
1188                 uint256 nextCollectionId = id.getNonFungibleCollection();
1189                 if (nfCollectionId == 0) {
1190                     nfCollectionId = nextCollectionId;
1191                     nfCollectionCount = 1;
1192                 } else {
1193                     if (nextCollectionId != nfCollectionId) {
1194                         _balances[nfCollectionId][to] += nfCollectionCount;
1195                         _supplies[nfCollectionId] += nfCollectionCount;
1196                         nfCollectionId = nextCollectionId;
1197                         nfCollectionCount = 1;
1198                     } else {
1199                         ++nfCollectionCount;
1200                     }
1201                 }
1202             } else {
1203                 revert("Inventory: not a token id");
1204             }
1205         }
1206 
1207         if (nfCollectionId != 0) {
1208             _balances[nfCollectionId][to] += nfCollectionCount;
1209             _supplies[nfCollectionId] += nfCollectionCount;
1210         }
1211 
1212         emit TransferBatch(_msgSender(), address(0), to, ids, values);
1213         if (to.isContract()) {
1214             _callOnERC1155BatchReceived(address(0), to, ids, values, data);
1215         }
1216     }
1217 
1218     //============================================== Helper Internal Functions ==============================================//
1219 
1220     function _mintFungible(
1221         address to,
1222         uint256 id,
1223         uint256 value
1224     ) internal {
1225         require(value != 0, "Inventory: zero value");
1226         uint256 supply = _supplies[id];
1227         uint256 newSupply = supply + value;
1228         require(newSupply > supply, "Inventory: supply overflow");
1229         _supplies[id] = newSupply;
1230         // cannot overflow as any balance is bounded up by the supply which cannot overflow
1231         _balances[id][to] += value;
1232     }
1233 
1234     function _mintNFT(
1235         address to,
1236         uint256 id,
1237         uint256 value,
1238         bool isBatch
1239     ) internal {
1240         require(value == 1, "Inventory: wrong NFT value");
1241         require(_owners[id] == 0, "Inventory: existing/burnt NFT");
1242 
1243         _owners[id] = uint256(uint160(to));
1244 
1245         if (!isBatch) {
1246             uint256 collectionId = id.getNonFungibleCollection();
1247             // it is virtually impossible that a Non-Fungible Collection supply
1248             // overflows due to the cost of minting individual tokens
1249             ++_supplies[collectionId];
1250             // cannot overflow as supply cannot overflow
1251             ++_balances[collectionId][to];
1252         }
1253     }
1254 
1255     function _transferFungible(
1256         address from,
1257         address to,
1258         uint256 id,
1259         uint256 value
1260     ) internal {
1261         require(value != 0, "Inventory: zero value");
1262         uint256 balance = _balances[id][from];
1263         require(balance >= value, "Inventory: not enough balance");
1264         if (from != to) {
1265             _balances[id][from] = balance - value;
1266             // cannot overflow as supply cannot overflow
1267             _balances[id][to] += value;
1268         }
1269     }
1270 
1271     function _transferNFT(
1272         address from,
1273         address to,
1274         uint256 id,
1275         uint256 value,
1276         bool isBatch
1277     ) internal {
1278         require(value == 1, "Inventory: wrong NFT value");
1279         require(from == address(uint160(_owners[id])), "Inventory: non-owned NFT");
1280         _owners[id] = uint256(uint160(to));
1281         if (!isBatch) {
1282             uint256 collectionId = id.getNonFungibleCollection();
1283             // cannot underflow as balance is verified through ownership
1284             _balances[collectionId][from] -= 1;
1285             // cannot overflow as supply cannot overflow
1286             _balances[collectionId][to] += 1;
1287         }
1288     }
1289 
1290     function _transferNFTUpdateCollection(
1291         address from,
1292         address to,
1293         uint256 collectionId,
1294         uint256 amount
1295     ) internal virtual {
1296         if (from != to) {
1297             // cannot underflow as balance is verified through ownership
1298             _balances[collectionId][from] -= amount;
1299             // cannot overflow as supply cannot overflow
1300             _balances[collectionId][to] += amount;
1301         }
1302     }
1303 }
1304 
1305 // File @animoca/ethereum-contracts-assets-2.0.0/contracts/token/ERC1155/ERC1155InventoryBurnable.sol@v2.0.0
1306 
1307 pragma solidity >=0.7.6 <0.8.0;
1308 
1309 /**
1310  * @title ERC1155Inventory, burnable version.
1311  * @dev The function `uri(uint256)` needs to be implemented by a child contract, for example with the help of `BaseMetadataURI`.
1312  */
1313 abstract contract ERC1155InventoryBurnable is IERC1155InventoryBurnable, ERC1155Inventory {
1314     using ERC1155InventoryIdentifiersLib for uint256;
1315 
1316     //======================================================= ERC165 ========================================================//
1317 
1318     /// @inheritdoc IERC165
1319     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1320         return interfaceId == type(IERC1155InventoryBurnable).interfaceId || super.supportsInterface(interfaceId);
1321     }
1322 
1323     //============================================== ERC1155InventoryBurnable ===============================================//
1324 
1325     /// @inheritdoc IERC1155InventoryBurnable
1326     function burnFrom(
1327         address from,
1328         uint256 id,
1329         uint256 value
1330     ) public virtual override {
1331         address sender = _msgSender();
1332         require(_isOperatable(from, sender), "Inventory: non-approved sender");
1333 
1334         if (id.isFungibleToken()) {
1335             _burnFungible(from, id, value);
1336         } else if (id.isNonFungibleToken()) {
1337             _burnNFT(from, id, value, false);
1338         } else {
1339             revert("Inventory: not a token id");
1340         }
1341 
1342         emit TransferSingle(sender, from, address(0), id, value);
1343     }
1344 
1345     /// @inheritdoc IERC1155InventoryBurnable
1346     function batchBurnFrom(
1347         address from,
1348         uint256[] memory ids,
1349         uint256[] memory values
1350     ) public virtual override {
1351         uint256 length = ids.length;
1352         require(length == values.length, "Inventory: inconsistent arrays");
1353 
1354         address sender = _msgSender();
1355         require(_isOperatable(from, sender), "Inventory: non-approved sender");
1356 
1357         uint256 nfCollectionId;
1358         uint256 nfCollectionCount;
1359         for (uint256 i; i != length; ++i) {
1360             uint256 id = ids[i];
1361             uint256 value = values[i];
1362             if (id.isFungibleToken()) {
1363                 _burnFungible(from, id, value);
1364             } else if (id.isNonFungibleToken()) {
1365                 _burnNFT(from, id, value, true);
1366                 uint256 nextCollectionId = id.getNonFungibleCollection();
1367                 if (nfCollectionId == 0) {
1368                     nfCollectionId = nextCollectionId;
1369                     nfCollectionCount = 1;
1370                 } else {
1371                     if (nextCollectionId != nfCollectionId) {
1372                         _balances[nfCollectionId][from] -= nfCollectionCount;
1373                         _supplies[nfCollectionId] -= nfCollectionCount;
1374                         nfCollectionId = nextCollectionId;
1375                         nfCollectionCount = 1;
1376                     } else {
1377                         ++nfCollectionCount;
1378                     }
1379                 }
1380             } else {
1381                 revert("Inventory: not a token id");
1382             }
1383         }
1384 
1385         if (nfCollectionId != 0) {
1386             _balances[nfCollectionId][from] -= nfCollectionCount;
1387             _supplies[nfCollectionId] -= nfCollectionCount;
1388         }
1389 
1390         emit TransferBatch(sender, from, address(0), ids, values);
1391     }
1392 
1393     //============================================== Helper Internal Functions ==============================================//
1394 
1395     function _burnFungible(
1396         address from,
1397         uint256 id,
1398         uint256 value
1399     ) internal {
1400         require(value != 0, "Inventory: zero value");
1401         uint256 balance = _balances[id][from];
1402         require(balance >= value, "Inventory: not enough balance");
1403         _balances[id][from] = balance - value;
1404         // Cannot underflow
1405         _supplies[id] -= value;
1406     }
1407 
1408     function _burnNFT(
1409         address from,
1410         uint256 id,
1411         uint256 value,
1412         bool isBatch
1413     ) internal {
1414         require(value == 1, "Inventory: wrong NFT value");
1415         require(from == address(uint160(_owners[id])), "Inventory: non-owned NFT");
1416         _owners[id] = _BURNT_NFT_OWNER;
1417 
1418         if (!isBatch) {
1419             uint256 collectionId = id.getNonFungibleCollection();
1420             // cannot underflow as balance is confirmed through ownership
1421             --_balances[collectionId][from];
1422             // Cannot underflow
1423             --_supplies[collectionId];
1424         }
1425     }
1426 }
1427 
1428 // File @animoca/ethereum-contracts-assets-2.0.0/contracts/token/ERC1155/IERC1155InventoryMintable.sol@v2.0.0
1429 
1430 pragma solidity >=0.7.6 <0.8.0;
1431 
1432 /**
1433  * @title ERC1155 Inventory, optional extension: Mintable.
1434  * @dev See https://eips.ethereum.org/EIPS/eip-1155
1435  */
1436 interface IERC1155InventoryMintable {
1437     /**
1438      * Safely mints some token.
1439      * @dev Reverts if `to` is the zero address.
1440      * @dev Reverts if `id` is not a token.
1441      * @dev Reverts if `id` represents a Non-Fungible Token and `value` is not 1.
1442      * @dev Reverts if `id` represents a Non-Fungible Token which has already been minted.
1443      * @dev Reverts if `id` represents a Fungible Token and `value` is 0.
1444      * @dev Reverts if `id` represents a Fungible Token and there is an overflow of supply.
1445      * @dev Reverts if `to` is a contract and the call to {IERC1155TokenReceiver-onERC1155Received} fails or is refused.
1446      * @dev Emits an {IERC1155-TransferSingle} event.
1447      * @param to Address of the new token owner.
1448      * @param id Identifier of the token to mint.
1449      * @param value Amount of token to mint.
1450      * @param data Optional data to send along to a receiver contract.
1451      */
1452     function safeMint(
1453         address to,
1454         uint256 id,
1455         uint256 value,
1456         bytes calldata data
1457     ) external;
1458 
1459     /**
1460      * Safely mints a batch of tokens.
1461      * @dev Reverts if `ids` and `values` have different lengths.
1462      * @dev Reverts if `to` is the zero address.
1463      * @dev Reverts if one of `ids` is not a token.
1464      * @dev Reverts if one of `ids` represents a Non-Fungible Token and its paired value is not 1.
1465      * @dev Reverts if one of `ids` represents a Non-Fungible Token which has already been minted.
1466      * @dev Reverts if one of `ids` represents a Fungible Token and its paired value is 0.
1467      * @dev Reverts if one of `ids` represents a Fungible Token and there is an overflow of supply.
1468      * @dev Reverts if `to` is a contract and the call to {IERC1155TokenReceiver-onERC1155batchReceived} fails or is refused.
1469      * @dev Emits an {IERC1155-TransferBatch} event.
1470      * @param to Address of the new tokens owner.
1471      * @param ids Identifiers of the tokens to mint.
1472      * @param values Amounts of tokens to mint.
1473      * @param data Optional data to send along to a receiver contract.
1474      */
1475     function safeBatchMint(
1476         address to,
1477         uint256[] calldata ids,
1478         uint256[] calldata values,
1479         bytes calldata data
1480     ) external;
1481 }
1482 
1483 // File @animoca/ethereum-contracts-assets-2.0.0/contracts/token/ERC1155/IERC1155InventoryCreator.sol@v2.0.0
1484 
1485 pragma solidity >=0.7.6 <0.8.0;
1486 
1487 /**
1488  * @title ERC1155 Inventory, optional extension: Creator.
1489  * @dev See https://eips.ethereum.org/EIPS/eip-1155
1490  * @dev Note: The ERC-165 identifier for this interface is 0x510b5158.
1491  */
1492 interface IERC1155InventoryCreator {
1493     /**
1494      * Returns the creator of a collection, or the zero address if the collection has not been created.
1495      * @dev Reverts if `collectionId` does not represent a collection.
1496      * @param collectionId Identifier of the collection.
1497      * @return The creator of a collection, or the zero address if the collection has not been created.
1498      */
1499     function creator(uint256 collectionId) external view returns (address);
1500 }
1501 
1502 // File @animoca/ethereum-contracts-core-1.1.2/contracts/utils/types/UInt256ToDecimalString.sol@v1.1.2
1503 
1504 // Partially derived from OpenZeppelin:
1505 // https://github.com/OpenZeppelin/openzeppelin-contracts/blob/8b10cb38d8fedf34f2d89b0ed604f2dceb76d6a9/contracts/utils/Strings.sol
1506 
1507 pragma solidity >=0.7.6 <0.8.0;
1508 
1509 library UInt256ToDecimalString {
1510     function toDecimalString(uint256 value) internal pure returns (string memory) {
1511         if (value == 0) {
1512             return "0";
1513         }
1514         uint256 temp = value;
1515         uint256 digits;
1516         while (temp != 0) {
1517             digits++;
1518             temp /= 10;
1519         }
1520         bytes memory buffer = new bytes(digits);
1521         uint256 index = digits - 1;
1522         temp = value;
1523         while (temp != 0) {
1524             buffer[index--] = bytes1(uint8(48 + (temp % 10)));
1525             temp /= 10;
1526         }
1527         return string(buffer);
1528     }
1529 }
1530 
1531 // File @animoca/ethereum-contracts-assets-2.0.0/contracts/metadata/BaseMetadataURI.sol@v2.0.0
1532 
1533 pragma solidity >=0.7.6 <0.8.0;
1534 
1535 abstract contract BaseMetadataURI is ManagedIdentity, Ownable {
1536     using UInt256ToDecimalString for uint256;
1537 
1538     event BaseMetadataURISet(string baseMetadataURI);
1539 
1540     string public baseMetadataURI;
1541 
1542     function setBaseMetadataURI(string calldata baseMetadataURI_) external {
1543         _requireOwnership(_msgSender());
1544         baseMetadataURI = baseMetadataURI_;
1545         emit BaseMetadataURISet(baseMetadataURI_);
1546     }
1547 
1548     function _uri(uint256 id) internal view virtual returns (string memory) {
1549         return string(abi.encodePacked(baseMetadataURI, id.toDecimalString()));
1550     }
1551 }
1552 
1553 // File @animoca/ethereum-contracts-core-1.1.2/contracts/access/MinterRole.sol@v1.1.2
1554 
1555 pragma solidity >=0.7.6 <0.8.0;
1556 
1557 /**
1558  * Contract which allows derived contracts access control over token minting operations.
1559  */
1560 contract MinterRole is Ownable {
1561     event MinterAdded(address indexed account);
1562     event MinterRemoved(address indexed account);
1563 
1564     mapping(address => bool) public isMinter;
1565 
1566     /**
1567      * Constructor.
1568      */
1569     constructor(address owner_) Ownable(owner_) {
1570         _addMinter(owner_);
1571     }
1572 
1573     /**
1574      * Grants the minter role to a non-minter.
1575      * @dev reverts if the sender is not the contract owner.
1576      * @param account The account to grant the minter role to.
1577      */
1578     function addMinter(address account) public {
1579         _requireOwnership(_msgSender());
1580         _addMinter(account);
1581     }
1582 
1583     /**
1584      * Renounces the granted minter role.
1585      * @dev reverts if the sender is not a minter.
1586      */
1587     function renounceMinter() public {
1588         address account = _msgSender();
1589         _requireMinter(account);
1590         isMinter[account] = false;
1591         emit MinterRemoved(account);
1592     }
1593 
1594     function _requireMinter(address account) internal view {
1595         require(isMinter[account], "MinterRole: not a Minter");
1596     }
1597 
1598     function _addMinter(address account) internal {
1599         isMinter[account] = true;
1600         emit MinterAdded(account);
1601     }
1602 }
1603 
1604 // File contracts/token/ERC1155/BenjiBananasMembershipPassNFT.sol
1605 
1606 pragma solidity >=0.7.6 <0.8.0;
1607 
1608 // solhint-disable-next-line max-line-length
1609 
1610 /**
1611  * @title BenjiBananasMembershipPassNFT
1612  */
1613 contract BenjiBananasMembershipPassNFT is
1614     Recoverable,
1615     UsingUniversalForwarding,
1616     ERC1155InventoryBurnable,
1617     IERC1155InventoryMintable,
1618     IERC1155InventoryCreator,
1619     BaseMetadataURI,
1620     MinterRole
1621 {
1622     constructor(IForwarderRegistry forwarderRegistry, address universalForwarder)
1623         UsingUniversalForwarding(forwarderRegistry, universalForwarder)
1624         MinterRole(msg.sender)
1625     {}
1626 
1627     //======================================================= ERC165 ========================================================//
1628 
1629     /// @inheritdoc IERC165
1630     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1631         return interfaceId == type(IERC1155InventoryCreator).interfaceId || super.supportsInterface(interfaceId);
1632     }
1633 
1634     //================================================= ERC1155MetadataURI ==================================================//
1635 
1636     /// @inheritdoc IERC1155MetadataURI
1637     function uri(uint256 id) external view virtual override returns (string memory) {
1638         return _uri(id);
1639     }
1640 
1641     //=============================================== ERC1155InventoryCreator ===============================================//
1642 
1643     /// @inheritdoc IERC1155InventoryCreator
1644     function creator(uint256 collectionId) external view override returns (address) {
1645         return _creator(collectionId);
1646     }
1647 
1648     //=========================================== ERC1155InventoryCreator (admin) ===========================================//
1649 
1650     /**
1651      * Creates a collection.
1652      * @dev Reverts if the sender is not the contract owner.
1653      * @dev Reverts if `collectionId` does not represent a collection.
1654      * @dev Reverts if `collectionId` has already been created.
1655      * @dev Emits a {IERC1155Inventory-CollectionCreated} event.
1656      * @param collectionId Identifier of the collection.
1657      */
1658     function createCollection(uint256 collectionId) external {
1659         _requireOwnership(_msgSender());
1660         _createCollection(collectionId);
1661     }
1662 
1663     //============================================== ERC1155InventoryMintable ===============================================//
1664 
1665     /// @inheritdoc IERC1155InventoryMintable
1666     /// @dev Reverts if the sender is not a minter.
1667     function safeMint(
1668         address to,
1669         uint256 id,
1670         uint256 value,
1671         bytes memory data
1672     ) public virtual override {
1673         _requireMinter(_msgSender());
1674         _safeMint(to, id, value, data);
1675     }
1676 
1677     /// @inheritdoc IERC1155InventoryMintable
1678     /// @dev Reverts if the sender is not a minter.
1679     function safeBatchMint(
1680         address to,
1681         uint256[] memory ids,
1682         uint256[] memory values,
1683         bytes memory data
1684     ) public virtual override {
1685         _requireMinter(_msgSender());
1686         _safeBatchMint(to, ids, values, data);
1687     }
1688 
1689     //======================================== Meta Transactions Internal Functions =========================================//
1690 
1691     function _msgSender() internal view virtual override(ManagedIdentity, UsingUniversalForwarding) returns (address payable) {
1692         return UsingUniversalForwarding._msgSender();
1693     }
1694 
1695     function _msgData() internal view virtual override(ManagedIdentity, UsingUniversalForwarding) returns (bytes memory ret) {
1696         return UsingUniversalForwarding._msgData();
1697     }
1698 }