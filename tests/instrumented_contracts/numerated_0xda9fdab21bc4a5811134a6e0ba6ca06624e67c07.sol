1 // Sources flattened with hardhat v2.6.4 https://hardhat.org
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
302 // File @animoca/ethereum-contracts-core-1.1.2/contracts/introspection/IERC165.sol@v1.1.2
303 
304 pragma solidity >=0.7.6 <0.8.0;
305 
306 /**
307  * @dev Interface of the ERC165 standard, as defined in the
308  * https://eips.ethereum.org/EIPS/eip-165.
309  */
310 interface IERC165 {
311     /**
312      * @dev Returns true if this contract implements the interface defined by
313      * `interfaceId`. See the corresponding
314      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
315      * to learn more about how these ids are created.
316      *
317      * This function call must use less than 30 000 gas.
318      */
319     function supportsInterface(bytes4 interfaceId) external view returns (bool);
320 }
321 
322 
323 // File @animoca/ethereum-contracts-assets-1.1.5/contracts/token/ERC20/IERC20.sol@v1.1.5
324 
325 pragma solidity >=0.7.6 <0.8.0;
326 
327 /**
328  * @title ERC20 Token Standard, basic interface
329  * @dev See https://eips.ethereum.org/EIPS/eip-20
330  * Note: The ERC-165 identifier for this interface is 0x36372b07.
331  */
332 interface IERC20 {
333     /**
334      * @dev Emitted when tokens are transferred, including zero value transfers.
335      * @param _from The account where the transferred tokens are withdrawn from.
336      * @param _to The account where the transferred tokens are deposited to.
337      * @param _value The amount of tokens being transferred.
338      */
339     event Transfer(address indexed _from, address indexed _to, uint256 _value);
340 
341     /**
342      * @dev Emitted when a successful call to {IERC20-approve(address,uint256)} is made.
343      * @param _owner The account granting an allowance to `_spender`.
344      * @param _spender The account being granted an allowance from `_owner`.
345      * @param _value The allowance amount being granted.
346      */
347     event Approval(address indexed _owner, address indexed _spender, uint256 _value);
348 
349     /**
350      * @notice Returns the total token supply.
351      * @return The total token supply.
352      */
353     function totalSupply() external view returns (uint256);
354 
355     /**
356      * @notice Returns the account balance of another account with address `owner`.
357      * @param owner The account whose balance will be returned.
358      * @return The account balance of another account with address `owner`.
359      */
360     function balanceOf(address owner) external view returns (uint256);
361 
362     /**
363      * Transfers `value` amount of tokens to address `to`.
364      * @dev Reverts if `to` is the zero address.
365      * @dev Reverts if the sender does not have enough balance.
366      * @dev Emits an {IERC20-Transfer} event.
367      * @dev Transfers of 0 values are treated as normal transfers and fire the {IERC20-Transfer} event.
368      * @param to The receiver account.
369      * @param value The amount of tokens to transfer.
370      * @return True if the transfer succeeds, false otherwise.
371      */
372     function transfer(address to, uint256 value) external returns (bool);
373 
374     /**
375      * @notice Transfers `value` amount of tokens from address `from` to address `to` via the approval mechanism.
376      * @dev Reverts if `to` is the zero address.
377      * @dev Reverts if the sender is not `from` and has not been approved by `from` for at least `value`.
378      * @dev Reverts if `from` does not have at least `value` of balance.
379      * @dev Emits an {IERC20-Transfer} event.
380      * @dev Transfers of 0 values are treated as normal transfers and fire the {IERC20-Transfer} event.
381      * @param from The emitter account.
382      * @param to The receiver account.
383      * @param value The amount of tokens to transfer.
384      * @return True if the transfer succeeds, false otherwise.
385      */
386     function transferFrom(
387         address from,
388         address to,
389         uint256 value
390     ) external returns (bool);
391 
392     /**
393      * Sets `value` as the allowance from the caller to `spender`.
394      *  IMPORTANT: Beware that changing an allowance with this method brings the risk
395      *  that someone may use both the old and the new allowance by unfortunate
396      *  transaction ordering. One possible solution to mitigate this race
397      *  condition is to first reduce the spender's allowance to 0 and set the
398      *  desired value afterwards: https://github.com/ethereum/EIPs/issues/20#issuecomment-263524729
399      * @dev Reverts if `spender` is the zero address.
400      * @dev Emits the {IERC20-Approval} event.
401      * @param spender The account being granted the allowance by the message caller.
402      * @param value The allowance amount to grant.
403      * @return True if the approval succeeds, false otherwise.
404      */
405     function approve(address spender, uint256 value) external returns (bool);
406 
407     /**
408      * Returns the amount which `spender` is allowed to spend on behalf of `owner`.
409      * @param owner The account that has granted an allowance to `spender`.
410      * @param spender The account that was granted an allowance by `owner`.
411      * @return The amount which `spender` is allowed to spend on behalf of `owner`.
412      */
413     function allowance(address owner, address spender) external view returns (uint256);
414 }
415 
416 
417 // File @animoca/ethereum-contracts-assets-1.1.5/contracts/token/ERC20/IERC20Detailed.sol@v1.1.5
418 
419 pragma solidity >=0.7.6 <0.8.0;
420 
421 /**
422  * @title ERC20 Token Standard, optional extension: Detailed
423  * See https://eips.ethereum.org/EIPS/eip-20
424  * Note: the ERC-165 identifier for this interface is 0xa219a025.
425  */
426 interface IERC20Detailed {
427     /**
428      * Returns the name of the token. E.g. "My Token".
429      * @return The name of the token.
430      */
431     function name() external view returns (string memory);
432 
433     /**
434      * Returns the symbol of the token. E.g. "HIX".
435      * @return The symbol of the token.
436      */
437     function symbol() external view returns (string memory);
438 
439     /**
440      * Returns the number of decimals used to display the balances.
441      * For example, if `decimals` equals `2`, a balance of `505` tokens should
442      * be displayed to a user as `5,05` (`505 / 10 ** 2`).
443      *
444      * Tokens usually opt for a value of 18, imitating the relationship between Ether and Wei.
445      *
446      * NOTE: This information is only used for _display_ purposes: it does  not impact the arithmetic of the contract.
447      * @return The number of decimals used to display the balances.
448      */
449     function decimals() external view returns (uint8);
450 }
451 
452 
453 // File @animoca/ethereum-contracts-assets-1.1.5/contracts/token/ERC20/IERC20Allowance.sol@v1.1.5
454 
455 pragma solidity >=0.7.6 <0.8.0;
456 
457 /**
458  * @title ERC20 Token Standard, optional extension: Allowance
459  * See https://eips.ethereum.org/EIPS/eip-20
460  * Note: the ERC-165 identifier for this interface is 0xd5b86388.
461  */
462 interface IERC20Allowance {
463     /**
464      * Increases the allowance granted by the sender to `spender` by `value`.
465      *  This is an alternative to {approve} that can be used as a mitigation for
466      *  problems described in {IERC20-approve}.
467      * @dev Reverts if `spender` is the zero address.
468      * @dev Reverts if `spender`'s allowance overflows.
469      * @dev Emits an {IERC20-Approval} event with an updated allowance for `spender`.
470      * @param spender The account whose allowance is being increased by the message caller.
471      * @param value The allowance amount increase.
472      * @return True if the allowance increase succeeds, false otherwise.
473      */
474     function increaseAllowance(address spender, uint256 value) external returns (bool);
475 
476     /**
477      * Decreases the allowance granted by the sender to `spender` by `value`.
478      *  This is an alternative to {approve} that can be used as a mitigation for
479      *  problems described in {IERC20-approve}.
480      * @dev Reverts if `spender` is the zero address.
481      * @dev Reverts if `spender` has an allowance with the message caller for less than `value`.
482      * @dev Emits an {IERC20-Approval} event with an updated allowance for `spender`.
483      * @param spender The account whose allowance is being decreased by the message caller.
484      * @param value The allowance amount decrease.
485      * @return True if the allowance decrease succeeds, false otherwise.
486      */
487     function decreaseAllowance(address spender, uint256 value) external returns (bool);
488 }
489 
490 
491 // File @animoca/ethereum-contracts-assets-1.1.5/contracts/token/ERC20/IERC20SafeTransfers.sol@v1.1.5
492 
493 pragma solidity >=0.7.6 <0.8.0;
494 
495 /**
496  * @title ERC20 Token Standard, optional extension: Safe Transfers
497  * Note: the ERC-165 identifier for this interface is 0x53f41a97.
498  */
499 interface IERC20SafeTransfers {
500     /**
501      * Transfers tokens from the caller to `to`. If this address is a contract, then calls `onERC20Received(address,address,uint256,bytes)` on it.
502      * @dev Reverts if `to` is the zero address.
503      * @dev Reverts if `value` is greater than the sender's balance.
504      * @dev Reverts if `to` is a contract which does not implement `onERC20Received(address,address,uint256,bytes)`.
505      * @dev Reverts if `to` is a contract and the call to `onERC20Received(address,address,uint256,bytes)` returns a wrong value.
506      * @dev Emits an {IERC20-Transfer} event.
507      * @param to The address for the tokens to be transferred to.
508      * @param amount The amount of tokens to be transferred.
509      * @param data Optional additional data with no specified format, to be passed to the receiver contract.
510      * @return true.
511      */
512     function safeTransfer(
513         address to,
514         uint256 amount,
515         bytes calldata data
516     ) external returns (bool);
517 
518     /**
519      * Transfers tokens from `from` to another address, using the allowance mechanism.
520      *  If this address is a contract, then calls `onERC20Received(address,address,uint256,bytes)` on it.
521      * @dev Reverts if `to` is the zero address.
522      * @dev Reverts if `value` is greater than `from`'s balance.
523      * @dev Reverts if the sender does not have at least `value` allowance by `from`.
524      * @dev Reverts if `to` is a contract which does not implement `onERC20Received(address,address,uint256,bytes)`.
525      * @dev Reverts if `to` is a contract and the call to `onERC20Received(address,address,uint256,bytes)` returns a wrong value.
526      * @dev Emits an {IERC20-Transfer} event.
527      * @param from The address which owns the tokens to be transferred.
528      * @param to The address for the tokens to be transferred to.
529      * @param amount The amount of tokens to be transferred.
530      * @param data Optional additional data with no specified format, to be passed to the receiver contract.
531      * @return true.
532      */
533     function safeTransferFrom(
534         address from,
535         address to,
536         uint256 amount,
537         bytes calldata data
538     ) external returns (bool);
539 }
540 
541 
542 // File @animoca/ethereum-contracts-assets-1.1.5/contracts/token/ERC20/IERC20BatchTransfers.sol@v1.1.5
543 
544 pragma solidity >=0.7.6 <0.8.0;
545 
546 /**
547  * @title ERC20 Token Standard, optional extension: Multi Transfers
548  * Note: the ERC-165 identifier for this interface is 0xd5b86388.
549  */
550 interface IERC20BatchTransfers {
551     /**
552      * Moves multiple `amounts` tokens from the caller's account to each of `recipients`.
553      * @dev Reverts if `recipients` and `amounts` have different lengths.
554      * @dev Reverts if one of `recipients` is the zero address.
555      * @dev Reverts if the caller has an insufficient balance.
556      * @dev Emits an {IERC20-Transfer} event for each individual transfer.
557      * @param recipients the list of recipients to transfer the tokens to.
558      * @param amounts the amounts of tokens to transfer to each of `recipients`.
559      * @return a boolean value indicating whether the operation succeeded.
560      */
561     function batchTransfer(address[] calldata recipients, uint256[] calldata amounts) external returns (bool);
562 
563     /**
564      * Moves multiple `amounts` tokens from an account to each of `recipients`, using the approval mechanism.
565      * @dev Reverts if `recipients` and `amounts` have different lengths.
566      * @dev Reverts if one of `recipients` is the zero address.
567      * @dev Reverts if `from` has an insufficient balance.
568      * @dev Reverts if the sender does not have at least the sum of all `amounts` as allowance by `from`.
569      * @dev Emits an {IERC20-Transfer} event for each individual transfer.
570      * @dev Emits an {IERC20-Approval} event.
571      * @param from The address which owns the tokens to be transferred.
572      * @param recipients the list of recipients to transfer the tokens to.
573      * @param amounts the amounts of tokens to transfer to each of `recipients`.
574      * @return a boolean value indicating whether the operation succeeded.
575      */
576     function batchTransferFrom(
577         address from,
578         address[] calldata recipients,
579         uint256[] calldata amounts
580     ) external returns (bool);
581 }
582 
583 
584 // File @animoca/ethereum-contracts-assets-1.1.5/contracts/token/ERC20/IERC20Metadata.sol@v1.1.5
585 
586 pragma solidity >=0.7.6 <0.8.0;
587 
588 /**
589  * @title ERC20 Token Standard, ERC1046 optional extension: Metadata
590  * See https://eips.ethereum.org/EIPS/eip-1046
591  * Note: the ERC-165 identifier for this interface is 0x3c130d90.
592  */
593 interface IERC20Metadata {
594     /**
595      * Returns a distinct Uniform Resource Identifier (URI) for the token metadata.
596      * @return a distinct Uniform Resource Identifier (URI) for the token metadata.
597      */
598     function tokenURI() external view returns (string memory);
599 }
600 
601 
602 // File @animoca/ethereum-contracts-assets-1.1.5/contracts/token/ERC20/IERC20Permit.sol@v1.1.5
603 
604 pragma solidity >=0.7.6 <0.8.0;
605 
606 /**
607  * @title ERC20 Token Standard, ERC2612 optional extension: permit – 712-signed approvals
608  * @dev Interface for allowing ERC20 approvals to be made via ECDSA `secp256k1` signatures.
609  * See https://eips.ethereum.org/EIPS/eip-2612
610  * Note: the ERC-165 identifier for this interface is 0x9d8ff7da.
611  */
612 interface IERC20Permit {
613     /**
614      * Sets `value` as the allowance of `spender` over the tokens of `owner`, given `owner` account's signed permit.
615      * @dev WARNING: The standard ERC-20 race condition for approvals applies to `permit()` as well: https://swcregistry.io/docs/SWC-114
616      * @dev Reverts if `owner` is the zero address.
617      * @dev Reverts if the current blocktime is > `deadline`.
618      * @dev Reverts if `r`, `s`, and `v` is not a valid `secp256k1` signature from `owner`.
619      * @dev Emits an {IERC20-Approval} event.
620      * @param owner The token owner granting the allowance to `spender`.
621      * @param spender The token spender being granted the allowance by `owner`.
622      * @param value The token amount of the allowance.
623      * @param deadline The deadline from which the permit signature is no longer valid.
624      * @param v Permit signature v parameter
625      * @param r Permit signature r parameter.
626      * @param s Permis signature s parameter.
627      */
628     function permit(
629         address owner,
630         address spender,
631         uint256 value,
632         uint256 deadline,
633         uint8 v,
634         bytes32 r,
635         bytes32 s
636     ) external;
637 
638     /**
639      * Returns the current permit nonce of `owner`.
640      * @param owner the address to check the nonce of.
641      * @return the current permit nonce of `owner`.
642      */
643     function nonces(address owner) external view returns (uint256);
644 
645     /**
646      * Returns the EIP-712 encoded hash struct of the domain-specific information for permits.
647      *
648      * @dev A common ERC-20 permit implementation choice for the `DOMAIN_SEPARATOR` is:
649      *
650      *  keccak256(
651      *      abi.encode(
652      *          keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
653      *          keccak256(bytes(name)),
654      *          keccak256(bytes(version)),
655      *          chainId,
656      *          address(this)))
657      *
658      *  where
659      *   - `name` (string) is the ERC-20 token name.
660      *   - `version` (string) refers to the ERC-20 token contract version.
661      *   - `chainId` (uint256) is the chain ID to which the ERC-20 token contract is deployed to.
662      *   - `verifyingContract` (address) is the ERC-20 token contract address.
663      *
664      * @return the EIP-712 encoded hash struct of the domain-specific information for permits.
665      */
666     // solhint-disable-next-line func-name-mixedcase
667     function DOMAIN_SEPARATOR() external view returns (bytes32);
668 }
669 
670 
671 // File @animoca/ethereum-contracts-assets-1.1.5/contracts/token/ERC20/IERC20Receiver.sol@v1.1.5
672 
673 pragma solidity >=0.7.6 <0.8.0;
674 
675 /**
676  * @title ERC20 Token Standard, Receiver
677  * See https://eips.ethereum.org/EIPS/eip-20
678  * Note: the ERC-165 identifier for this interface is 0x4fc35859.
679  */
680 interface IERC20Receiver {
681     /**
682      * Handles the receipt of ERC20 tokens.
683      * @param sender The initiator of the transfer.
684      * @param from The address which transferred the tokens.
685      * @param value The amount of tokens transferred.
686      * @param data Optional additional data with no specified format.
687      * @return bytes4 `bytes4(keccak256("onERC20Received(address,address,uint256,bytes)"))`
688      */
689     function onERC20Received(
690         address sender,
691         address from,
692         uint256 value,
693         bytes calldata data
694     ) external returns (bytes4);
695 }
696 
697 
698 // File @animoca/ethereum-contracts-assets-1.1.5/contracts/token/ERC20/ERC20.sol@v1.1.5
699 
700 pragma solidity >=0.7.6 <0.8.0;
701 
702 
703 
704 
705 
706 
707 
708 
709 
710 
711 
712 /**
713  * @title ERC20 Fungible Token Contract.
714  */
715 abstract contract ERC20 is
716     ManagedIdentity,
717     IERC165,
718     IERC20,
719     IERC20Detailed,
720     IERC20Metadata,
721     IERC20Allowance,
722     IERC20BatchTransfers,
723     IERC20SafeTransfers,
724     IERC20Permit
725 {
726     using AddressIsContract for address;
727 
728     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)")
729     bytes32 internal constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
730 
731     uint256 public immutable deploymentChainId;
732 
733     // solhint-disable-next-line var-name-mixedcase
734     bytes32 internal immutable _DOMAIN_SEPARATOR;
735 
736     mapping(address => uint256) public override nonces;
737 
738     string internal _name;
739     string internal _symbol;
740     uint8 internal immutable _decimals;
741     string internal _tokenURI;
742 
743     mapping(address => uint256) internal _balances;
744     mapping(address => mapping(address => uint256)) internal _allowances;
745     uint256 internal _totalSupply;
746 
747     constructor(
748         string memory name_,
749         string memory symbol_,
750         uint8 decimals_,
751         string memory tokenURI_
752     ) {
753         _name = name_;
754         _symbol = symbol_;
755         _decimals = decimals_;
756         _tokenURI = tokenURI_;
757 
758         uint256 chainId;
759         assembly {
760             chainId := chainid()
761         }
762         deploymentChainId = chainId;
763         _DOMAIN_SEPARATOR = _calculateDomainSeparator(chainId, bytes(name_));
764     }
765 
766     // solhint-disable-next-line func-name-mixedcase
767     function DOMAIN_SEPARATOR() public view override returns (bytes32) {
768         uint256 chainId;
769         assembly {
770             chainId := chainid()
771         }
772         // recompute the domain separator in case of fork and chainid update
773         return chainId == deploymentChainId ? _DOMAIN_SEPARATOR : _calculateDomainSeparator(chainId, bytes(_name));
774     }
775 
776     function _calculateDomainSeparator(uint256 chainId, bytes memory name_) private view returns (bytes32) {
777         return
778             keccak256(
779                 abi.encode(
780                     keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
781                     keccak256(name_),
782                     keccak256("1"),
783                     chainId,
784                     address(this)
785                 )
786             );
787     }
788 
789     /////////////////////////////////////////// ERC165 ///////////////////////////////////////
790 
791     /// @dev See {IERC165-supportsInterface}.
792     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
793         return
794             interfaceId == type(IERC165).interfaceId ||
795             interfaceId == type(IERC20).interfaceId ||
796             interfaceId == type(IERC20Detailed).interfaceId ||
797             interfaceId == type(IERC20Metadata).interfaceId ||
798             interfaceId == type(IERC20Allowance).interfaceId ||
799             interfaceId == type(IERC20BatchTransfers).interfaceId ||
800             interfaceId == type(IERC20SafeTransfers).interfaceId ||
801             interfaceId == type(IERC20Permit).interfaceId;
802     }
803 
804     /////////////////////////////////////////// ERC20Detailed ///////////////////////////////////////
805 
806     /// @dev See {IERC20Detailed-name}.
807     function name() external view override returns (string memory) {
808         return _name;
809     }
810 
811     /// @dev See {IERC20Detailed-symbol}.
812     function symbol() external view override returns (string memory) {
813         return _symbol;
814     }
815 
816     /// @dev See {IERC20Detailed-decimals}.
817     function decimals() external view override returns (uint8) {
818         return _decimals;
819     }
820 
821     /////////////////////////////////////////// ERC20Metadata ///////////////////////////////////////
822 
823     /// @dev See {IERC20Metadata-tokenURI}.
824     function tokenURI() external view override returns (string memory) {
825         return _tokenURI;
826     }
827 
828     /////////////////////////////////////////// ERC20 ///////////////////////////////////////
829 
830     /// @dev See {IERC20-totalSupply}.
831     function totalSupply() external view override returns (uint256) {
832         return _totalSupply;
833     }
834 
835     /// @dev See {IERC20-balanceOf}.
836     function balanceOf(address account) external view override returns (uint256) {
837         return _balances[account];
838     }
839 
840     /// @dev See {IERC20-allowance}.
841     function allowance(address owner, address spender) public view virtual override returns (uint256) {
842         return _allowances[owner][spender];
843     }
844 
845     /// @dev See {IERC20-approve}.
846     function approve(address spender, uint256 value) external virtual override returns (bool) {
847         _approve(_msgSender(), spender, value);
848         return true;
849     }
850 
851     /////////////////////////////////////////// ERC20 Allowance ///////////////////////////////////////
852 
853     /// @dev See {IERC20Allowance-increaseAllowance}.
854     function increaseAllowance(address spender, uint256 addedValue) external virtual override returns (bool) {
855         require(spender != address(0), "ERC20: zero address spender");
856         address owner = _msgSender();
857         uint256 allowance_ = _allowances[owner][spender];
858         if (addedValue != 0) {
859             uint256 newAllowance = allowance_ + addedValue;
860             require(newAllowance > allowance_, "ERC20: allowance overflow");
861             _allowances[owner][spender] = newAllowance;
862             allowance_ = newAllowance;
863         }
864         emit Approval(owner, spender, allowance_);
865 
866         return true;
867     }
868 
869     /// @dev See {IERC20Allowance-decreaseAllowance}.
870     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual override returns (bool) {
871         require(spender != address(0), "ERC20: zero address spender");
872         _decreaseAllowance(_msgSender(), spender, subtractedValue);
873         return true;
874     }
875 
876     /// @dev See {IERC20-transfer}.
877     function transfer(address to, uint256 value) external virtual override returns (bool) {
878         _transfer(_msgSender(), to, value);
879         return true;
880     }
881 
882     /// @dev See {IERC20-transferFrom}.
883     function transferFrom(
884         address from,
885         address to,
886         uint256 value
887     ) external virtual override returns (bool) {
888         _transferFrom(_msgSender(), from, to, value);
889         return true;
890     }
891 
892     /////////////////////////////////////////// ERC20MultiTransfer ///////////////////////////////////////
893 
894     /// @dev See {IERC20MultiTransfer-multiTransfer(address[],uint256[])}.
895     function batchTransfer(address[] calldata recipients, uint256[] calldata values) external virtual override returns (bool) {
896         uint256 length = recipients.length;
897         require(length == values.length, "ERC20: inconsistent arrays");
898         address sender = _msgSender();
899         uint256 balance = _balances[sender];
900 
901         uint256 totalValue;
902         uint256 selfTransferTotalValue;
903         for (uint256 i; i != length; ++i) {
904             address to = recipients[i];
905             require(to != address(0), "ERC20: to zero address");
906 
907             uint256 value = values[i];
908             if (value != 0) {
909                 uint256 newTotalValue = totalValue + value;
910                 require(newTotalValue > totalValue, "ERC20: values overflow");
911                 totalValue = newTotalValue;
912                 if (sender != to) {
913                     _balances[to] += value;
914                 } else {
915                     require(value <= balance, "ERC20: insufficient balance");
916                     selfTransferTotalValue += value; // cannot overflow as 'selfTransferTotalValue <= totalValue' is always true
917                 }
918             }
919             emit Transfer(sender, to, value);
920         }
921 
922         if (totalValue != 0 && totalValue != selfTransferTotalValue) {
923             uint256 newBalance = balance - totalValue;
924             require(newBalance < balance, "ERC20: insufficient balance"); // balance must be sufficient, including self-transfers
925             _balances[sender] = newBalance + selfTransferTotalValue; // do not deduct self-transfers from the sender balance
926         }
927         return true;
928     }
929 
930     /// @dev See {IERC20MultiTransfer-multiTransferFrom(address,address[],uint256[])}.
931     function batchTransferFrom(
932         address from,
933         address[] calldata recipients,
934         uint256[] calldata values
935     ) external virtual override returns (bool) {
936         uint256 length = recipients.length;
937         require(length == values.length, "ERC20: inconsistent arrays");
938 
939         uint256 balance = _balances[from];
940 
941         uint256 totalValue;
942         uint256 selfTransferTotalValue;
943         for (uint256 i; i != length; ++i) {
944             address to = recipients[i];
945             require(to != address(0), "ERC20: to zero address");
946 
947             uint256 value = values[i];
948 
949             if (value != 0) {
950                 uint256 newTotalValue = totalValue + value;
951                 require(newTotalValue > totalValue, "ERC20: values overflow");
952                 totalValue = newTotalValue;
953                 if (from != to) {
954                     _balances[to] += value;
955                 } else {
956                     require(value <= balance, "ERC20: insufficient balance");
957                     selfTransferTotalValue += value; // cannot overflow as 'selfTransferTotalValue <= totalValue' is always true
958                 }
959             }
960 
961             emit Transfer(from, to, value);
962         }
963 
964         if (totalValue != 0 && totalValue != selfTransferTotalValue) {
965             uint256 newBalance = balance - totalValue;
966             require(newBalance < balance, "ERC20: insufficient balance"); // balance must be sufficient, including self-transfers
967             _balances[from] = newBalance + selfTransferTotalValue; // do not deduct self-transfers from the sender balance
968         }
969 
970         address sender = _msgSender();
971         if (from != sender) {
972             _decreaseAllowance(from, sender, totalValue);
973         }
974 
975         return true;
976     }
977 
978     /////////////////////////////////////////// ERC20SafeTransfers ///////////////////////////////////////
979 
980     /// @dev See {IERC20Safe-safeTransfer(address,uint256,bytes)}.
981     function safeTransfer(
982         address to,
983         uint256 amount,
984         bytes calldata data
985     ) external virtual override returns (bool) {
986         address sender = _msgSender();
987         _transfer(sender, to, amount);
988         if (to.isContract()) {
989             require(IERC20Receiver(to).onERC20Received(sender, sender, amount, data) == type(IERC20Receiver).interfaceId, "ERC20: transfer refused");
990         }
991         return true;
992     }
993 
994     /// @dev See {IERC20Safe-safeTransferFrom(address,address,uint256,bytes)}.
995     function safeTransferFrom(
996         address from,
997         address to,
998         uint256 amount,
999         bytes calldata data
1000     ) external virtual override returns (bool) {
1001         address sender = _msgSender();
1002         _transferFrom(sender, from, to, amount);
1003         if (to.isContract()) {
1004             require(IERC20Receiver(to).onERC20Received(sender, from, amount, data) == type(IERC20Receiver).interfaceId, "ERC20: transfer refused");
1005         }
1006         return true;
1007     }
1008 
1009     /////////////////////////////////////////// ERC20Permit ///////////////////////////////////////
1010 
1011     /// @dev See {IERC2612-permit(address,address,uint256,uint256,uint8,bytes32,bytes32)}.
1012     function permit(
1013         address owner,
1014         address spender,
1015         uint256 value,
1016         uint256 deadline,
1017         uint8 v,
1018         bytes32 r,
1019         bytes32 s
1020     ) external virtual override {
1021         require(owner != address(0), "ERC20: zero address owner");
1022         require(block.timestamp <= deadline, "ERC20: expired permit");
1023         bytes32 hashStruct = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline));
1024         bytes32 hash = keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR(), hashStruct));
1025         address signer = ecrecover(hash, v, r, s);
1026         require(signer == owner, "ERC20: invalid permit");
1027         _approve(owner, spender, value);
1028     }
1029 
1030     /////////////////////////////////////////// Internal Functions ///////////////////////////////////////
1031 
1032     function _approve(
1033         address owner,
1034         address spender,
1035         uint256 value
1036     ) internal {
1037         require(spender != address(0), "ERC20: zero address spender");
1038         _allowances[owner][spender] = value;
1039         emit Approval(owner, spender, value);
1040     }
1041 
1042     function _decreaseAllowance(
1043         address owner,
1044         address spender,
1045         uint256 subtractedValue
1046     ) internal {
1047         uint256 allowance_ = _allowances[owner][spender];
1048 
1049         if (allowance_ != type(uint256).max && subtractedValue != 0) {
1050             // save gas when allowance is maximal by not reducing it (see https://github.com/ethereum/EIPs/issues/717)
1051             uint256 newAllowance = allowance_ - subtractedValue;
1052             require(newAllowance < allowance_, "ERC20: insufficient allowance");
1053             _allowances[owner][spender] = newAllowance;
1054             allowance_ = newAllowance;
1055         }
1056         emit Approval(owner, spender, allowance_);
1057     }
1058 
1059     function _transfer(
1060         address from,
1061         address to,
1062         uint256 value
1063     ) internal virtual {
1064         require(to != address(0), "ERC20: to zero address");
1065 
1066         if (value != 0) {
1067             uint256 balance = _balances[from];
1068             uint256 newBalance = balance - value;
1069             require(newBalance < balance, "ERC20: insufficient balance");
1070             if (from != to) {
1071                 _balances[from] = newBalance;
1072                 _balances[to] += value;
1073             }
1074         }
1075 
1076         emit Transfer(from, to, value);
1077     }
1078 
1079     function _transferFrom(
1080         address sender,
1081         address from,
1082         address to,
1083         uint256 value
1084     ) internal {
1085         _transfer(from, to, value);
1086         if (from != sender) {
1087             _decreaseAllowance(from, sender, value);
1088         }
1089     }
1090 
1091     function _mint(address to, uint256 value) internal virtual {
1092         require(to != address(0), "ERC20: zero address");
1093         uint256 supply = _totalSupply;
1094         if (value != 0) {
1095             uint256 newSupply = supply + value;
1096             require(newSupply > supply, "ERC20: supply overflow");
1097             _totalSupply = newSupply;
1098             _balances[to] += value; // balance cannot overflow if supply does not
1099         }
1100         emit Transfer(address(0), to, value);
1101     }
1102 
1103     function _batchMint(address[] memory recipients, uint256[] memory values) internal virtual {
1104         uint256 length = recipients.length;
1105         require(length == values.length, "ERC20: inconsistent arrays");
1106 
1107         uint256 totalValue;
1108         for (uint256 i; i != length; ++i) {
1109             address to = recipients[i];
1110             require(to != address(0), "ERC20: zero address");
1111 
1112             uint256 value = values[i];
1113             if (value != 0) {
1114                 uint256 newTotalValue = totalValue + value;
1115                 require(newTotalValue > totalValue, "ERC20: values overflow");
1116                 totalValue = newTotalValue;
1117                 _balances[to] += value; // balance cannot overflow if supply does not
1118             }
1119             emit Transfer(address(0), to, value);
1120         }
1121 
1122         if (totalValue != 0) {
1123             uint256 supply = _totalSupply;
1124             uint256 newSupply = supply + totalValue;
1125             require(newSupply > supply, "ERC20: supply overflow");
1126             _totalSupply = newSupply;
1127         }
1128     }
1129 
1130     function _burn(address from, uint256 value) internal virtual {
1131         if (value != 0) {
1132             uint256 balance = _balances[from];
1133             uint256 newBalance = balance - value;
1134             require(newBalance < balance, "ERC20: insufficient balance");
1135             _balances[from] = newBalance;
1136             _totalSupply -= value; // will not underflow if balance does not
1137         }
1138         emit Transfer(from, address(0), value);
1139     }
1140 
1141     function _burnFrom(address from, uint256 value) internal virtual {
1142         _burn(from, value);
1143         address sender = _msgSender();
1144         if (from != sender) {
1145             _decreaseAllowance(from, sender, value);
1146         }
1147     }
1148 
1149     function _batchBurnFrom(address[] memory owners, uint256[] memory values) internal virtual {
1150         uint256 length = owners.length;
1151         require(length == values.length, "ERC20: inconsistent arrays");
1152 
1153         address sender = _msgSender();
1154 
1155         uint256 totalValue;
1156         for (uint256 i; i != length; ++i) {
1157             address from = owners[i];
1158             uint256 value = values[i];
1159             if (value != 0) {
1160                 uint256 balance = _balances[from];
1161                 uint256 newBalance = balance - value;
1162                 require(newBalance < balance, "ERC20: insufficient balance");
1163                 _balances[from] = newBalance;
1164                 totalValue += value; // totalValue cannot overflow if the individual balances do not underflow
1165             }
1166             emit Transfer(from, address(0), value);
1167 
1168             if (from != sender) {
1169                 _decreaseAllowance(from, sender, value);
1170             }
1171         }
1172 
1173         if (totalValue != 0) {
1174             _totalSupply -= totalValue; // _totalSupply cannot underfow as balances do not underflow
1175         }
1176     }
1177 }
1178 
1179 
1180 // File ethereum-universal-forwarder/src/solc_0.7/ERC2771/UsingAppendedCallData.sol@v0.1.4
1181 pragma solidity ^0.7.0;
1182 
1183 abstract contract UsingAppendedCallData {
1184     function _lastAppendedDataAsSender() internal pure virtual returns (address payable sender) {
1185         // Copied from openzeppelin : https://github.com/OpenZeppelin/openzeppelin-contracts/blob/9d5f77db9da0604ce0b25148898a94ae2c20d70f/contracts/metatx/ERC2771Context.sol1
1186         // The assembly code is more direct than the Solidity version using `abi.decode`.
1187         // solhint-disable-next-line no-inline-assembly
1188         assembly {
1189             sender := shr(96, calldataload(sub(calldatasize(), 20)))
1190         }
1191     }
1192 
1193     function _msgDataAssuming20BytesAppendedData() internal pure virtual returns (bytes calldata) {
1194         return msg.data[:msg.data.length - 20];
1195     }
1196 }
1197 
1198 
1199 // File ethereum-universal-forwarder/src/solc_0.7/ERC2771/IERC2771.sol@v0.1.4
1200 pragma solidity ^0.7.0;
1201 
1202 interface IERC2771 {
1203     function isTrustedForwarder(address forwarder) external view returns (bool);
1204 }
1205 
1206 
1207 // File ethereum-universal-forwarder/src/solc_0.7/ERC2771/IForwarderRegistry.sol@v0.1.4
1208 pragma solidity ^0.7.0;
1209 
1210 interface IForwarderRegistry {
1211     function isForwarderFor(address, address) external view returns (bool);
1212 }
1213 
1214 
1215 // File ethereum-universal-forwarder/src/solc_0.7/ERC2771/UsingUniversalForwarding.sol@v0.1.4
1216 pragma solidity ^0.7.0;
1217 
1218 
1219 
1220 abstract contract UsingUniversalForwarding is UsingAppendedCallData, IERC2771 {
1221     IForwarderRegistry internal immutable _forwarderRegistry;
1222     address internal immutable _universalForwarder;
1223 
1224     constructor(IForwarderRegistry forwarderRegistry, address universalForwarder) {
1225         _universalForwarder = universalForwarder;
1226         _forwarderRegistry = forwarderRegistry;
1227     }
1228 
1229     function isTrustedForwarder(address forwarder) external view virtual override returns (bool) {
1230         return forwarder == _universalForwarder || forwarder == address(_forwarderRegistry);
1231     }
1232 
1233     function _msgSender() internal view virtual returns (address payable) {
1234         address payable msgSender = msg.sender;
1235         address payable sender = _lastAppendedDataAsSender();
1236         if (msgSender == address(_forwarderRegistry) || msgSender == _universalForwarder) {
1237             // if forwarder use appended data
1238             return sender;
1239         }
1240 
1241         // if msg.sender is neither the registry nor the universal forwarder,
1242         // we have to check the last 20bytes of the call data intepreted as an address
1243         // and check if the msg.sender was registered as forewarder for that address
1244         // we check tx.origin to save gas in case where msg.sender == tx.origin
1245         // solhint-disable-next-line avoid-tx-origin
1246         if (msgSender != tx.origin && _forwarderRegistry.isForwarderFor(sender, msgSender)) {
1247             return sender;
1248         }
1249 
1250         return msgSender;
1251     }
1252 
1253     function _msgData() internal view virtual returns (bytes calldata) {
1254         address payable msgSender = msg.sender;
1255         if (msgSender == address(_forwarderRegistry) || msgSender == _universalForwarder) {
1256             // if forwarder use appended data
1257             return _msgDataAssuming20BytesAppendedData();
1258         }
1259 
1260         // we check tx.origin to save gas in case where msg.sender == tx.origin
1261         // solhint-disable-next-line avoid-tx-origin
1262         if (msgSender != tx.origin && _forwarderRegistry.isForwarderFor(_lastAppendedDataAsSender(), msgSender)) {
1263             return _msgDataAssuming20BytesAppendedData();
1264         }
1265         return msg.data;
1266     }
1267 }
1268 
1269 
1270 // File contracts/token/ERC20/QUIDD.sol
1271 
1272 pragma solidity >=0.7.6 <0.8.0;
1273 
1274 
1275 
1276 /**
1277  * @title QUIDD.
1278  * QUIDD is an ERC20 token with a constant pre-minted supply.
1279  */
1280 contract QUIDD is ERC20, UsingUniversalForwarding, Recoverable {
1281     /**
1282      * Constructor.
1283      * @dev Reverts if `values` and `recipients` have different lengths.
1284      * @dev Reverts if one of `recipients` is the zero address.
1285      * @dev Emits an {IERC20-Transfer} event for each transfer with `from` set to the zero address.
1286      * @param recipients the accounts to deliver the tokens to.
1287      * @param values the amounts of tokens to mint to each of `recipients`.
1288      * @param forwarderRegistry Registry of approved meta-transaction forwarders.
1289      * @param universalForwarder Universal meta-transaction forwarder.
1290      */
1291     constructor(
1292         address[] memory recipients,
1293         uint256[] memory values,
1294         IForwarderRegistry forwarderRegistry,
1295         address universalForwarder
1296     ) ERC20("QUIDD", "QUIDD", 18, "") UsingUniversalForwarding(forwarderRegistry, universalForwarder) Ownable(msg.sender) {
1297         _batchMint(recipients, values);
1298     }
1299 
1300     /**
1301      * Updates the URI of the token.
1302      * @dev Reverts if the sender is not the contract owner.
1303      * @param tokenURI_ the updated URI.
1304      */
1305     function setTokenURI(string calldata tokenURI_) external {
1306         _requireOwnership(_msgSender());
1307         _tokenURI = tokenURI_;
1308     }
1309 
1310     function _msgSender() internal view virtual override(ManagedIdentity, UsingUniversalForwarding) returns (address payable) {
1311         return UsingUniversalForwarding._msgSender();
1312     }
1313 
1314     function _msgData() internal view virtual override(ManagedIdentity, UsingUniversalForwarding) returns (bytes memory ret) {
1315         return UsingUniversalForwarding._msgData();
1316     }
1317 }