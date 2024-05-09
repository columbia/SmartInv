1 // Sources flattened with hardhat v2.6.4 https://hardhat.org
2 
3 // File @animoca/ethereum-contracts-core/contracts/metatx/ManagedIdentity.sol@v1.1.3
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
26 // File @animoca/ethereum-contracts-core/contracts/access/IERC173.sol@v1.1.3
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
58 // File @animoca/ethereum-contracts-core/contracts/access/Ownable.sol@v1.1.3
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
115 // File @animoca/ethereum-contracts-core/contracts/utils/types/AddressIsContract.sol@v1.1.3
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
157 // File @animoca/ethereum-contracts-core/contracts/utils/ERC20Wrapper.sol@v1.1.3
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
232 // File @animoca/ethereum-contracts-core/contracts/utils/Recoverable.sol@v1.1.3
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
302 // File @animoca/ethereum-contracts-core/contracts/introspection/IERC165.sol@v1.1.3
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
323 // File @animoca/ethereum-contracts-assets/contracts/token/ERC20/interfaces/IERC20.sol@v3.0.1
324 
325 pragma solidity >=0.7.6 <0.8.0;
326 
327 /**
328  * @title ERC20 Token Standard, basic interface.
329  * @dev See https://eips.ethereum.org/EIPS/eip-20
330  * @dev Note: The ERC-165 identifier for this interface is 0x36372b07.
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
375      * @notice Transfers `value` amount of tokens from address `from` to address `to`.
376      * @dev Reverts if `to` is the zero address.
377      * @dev Reverts if `from` does not have at least `value` of balance.
378      * @dev Reverts if the sender is not `from` and has not been approved by `from` for at least `value`.
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
417 // File @animoca/ethereum-contracts-assets/contracts/token/ERC20/interfaces/IERC20Detailed.sol@v3.0.1
418 
419 pragma solidity >=0.7.6 <0.8.0;
420 
421 /**
422  * @title ERC20 Token Standard, optional extension: Detailed.
423  * @dev See https://eips.ethereum.org/EIPS/eip-20
424  * @dev Note: the ERC-165 identifier for this interface is 0xa219a025.
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
446      * @dev Note: This information is only used for _display_ purposes: it does  not impact the arithmetic of the contract.
447      * @return The number of decimals used to display the balances.
448      */
449     function decimals() external view returns (uint8);
450 }
451 
452 
453 // File @animoca/ethereum-contracts-assets/contracts/token/ERC20/interfaces/IERC20Allowance.sol@v3.0.1
454 
455 pragma solidity >=0.7.6 <0.8.0;
456 
457 /**
458  * @title ERC20 Token Standard, optional extension: Allowance.
459  * @dev See https://eips.ethereum.org/EIPS/eip-20
460  * @dev Note: the ERC-165 identifier for this interface is 0x9d075186.
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
491 // File @animoca/ethereum-contracts-assets/contracts/token/ERC20/interfaces/IERC20SafeTransfers.sol@v3.0.1
492 
493 pragma solidity >=0.7.6 <0.8.0;
494 
495 /**
496  * @title ERC20 Token Standard, optional extension: Safe Transfers.
497  * @dev See https://eips.ethereum.org/EIPS/eip-20
498  * @dev Note: the ERC-165 identifier for this interface is 0x53f41a97.
499  */
500 interface IERC20SafeTransfers {
501     /**
502      * Transfers tokens from the caller to `to`. If this address is a contract, then calls `onERC20Received(address,address,uint256,bytes)` on it.
503      * @dev Reverts if `to` is the zero address.
504      * @dev Reverts if `value` is greater than the sender's balance.
505      * @dev Reverts if `to` is a contract which does not implement `onERC20Received(address,address,uint256,bytes)`.
506      * @dev Reverts if `to` is a contract and the call to `onERC20Received(address,address,uint256,bytes)` returns a wrong value.
507      * @dev Emits an {IERC20-Transfer} event.
508      * @param to The address for the tokens to be transferred to.
509      * @param amount The amount of tokens to be transferred.
510      * @param data Optional additional data with no specified format, to be passed to the receiver contract.
511      * @return true.
512      */
513     function safeTransfer(
514         address to,
515         uint256 amount,
516         bytes calldata data
517     ) external returns (bool);
518 
519     /**
520      * Transfers tokens from `from` to another address, using the allowance mechanism.
521      *  If this address is a contract, then calls `onERC20Received(address,address,uint256,bytes)` on it.
522      * @dev Reverts if `to` is the zero address.
523      * @dev Reverts if `value` is greater than `from`'s balance.
524      * @dev Reverts if the sender does not have at least `value` allowance by `from`.
525      * @dev Reverts if `to` is a contract which does not implement `onERC20Received(address,address,uint256,bytes)`.
526      * @dev Reverts if `to` is a contract and the call to `onERC20Received(address,address,uint256,bytes)` returns a wrong value.
527      * @dev Emits an {IERC20-Transfer} event.
528      * @param from The address which owns the tokens to be transferred.
529      * @param to The address for the tokens to be transferred to.
530      * @param amount The amount of tokens to be transferred.
531      * @param data Optional additional data with no specified format, to be passed to the receiver contract.
532      * @return true.
533      */
534     function safeTransferFrom(
535         address from,
536         address to,
537         uint256 amount,
538         bytes calldata data
539     ) external returns (bool);
540 }
541 
542 
543 // File @animoca/ethereum-contracts-assets/contracts/token/ERC20/interfaces/IERC20BatchTransfers.sol@v3.0.1
544 
545 pragma solidity >=0.7.6 <0.8.0;
546 
547 /**
548  * @title ERC20 Token Standard, optional extension: Batch Transfers.
549  * @dev See https://eips.ethereum.org/EIPS/eip-20
550  * @dev Note: the ERC-165 identifier for this interface is 0xc05327e6.
551  */
552 interface IERC20BatchTransfers {
553     /**
554      * Moves multiple `amounts` tokens from the caller's account to each of `recipients`.
555      * @dev Reverts if `recipients` and `amounts` have different lengths.
556      * @dev Reverts if one of `recipients` is the zero address.
557      * @dev Reverts if the caller has an insufficient balance.
558      * @dev Emits an {IERC20-Transfer} event for each individual transfer.
559      * @param recipients the list of recipients to transfer the tokens to.
560      * @param amounts the amounts of tokens to transfer to each of `recipients`.
561      * @return a boolean value indicating whether the operation succeeded.
562      */
563     function batchTransfer(address[] calldata recipients, uint256[] calldata amounts) external returns (bool);
564 
565     /**
566      * Moves multiple `amounts` tokens from an account to each of `recipients`.
567      * @dev Reverts if `recipients` and `amounts` have different lengths.
568      * @dev Reverts if one of `recipients` is the zero address.
569      * @dev Reverts if `from` has an insufficient balance.
570      * @dev Reverts if the sender is not `from` and has an insufficient allowance.
571      * @dev Emits an {IERC20-Transfer} event for each individual transfer.
572      * @dev Emits an {IERC20-Approval} event.
573      * @param from The address which owns the tokens to be transferred.
574      * @param recipients the list of recipients to transfer the tokens to.
575      * @param amounts the amounts of tokens to transfer to each of `recipients`.
576      * @return a boolean value indicating whether the operation succeeded.
577      */
578     function batchTransferFrom(
579         address from,
580         address[] calldata recipients,
581         uint256[] calldata amounts
582     ) external returns (bool);
583 }
584 
585 
586 // File @animoca/ethereum-contracts-assets/contracts/token/ERC20/interfaces/IERC20Metadata.sol@v3.0.1
587 
588 pragma solidity >=0.7.6 <0.8.0;
589 
590 /**
591  * @title ERC20 Token Standard, ERC1046 optional extension: Metadata.
592  * @dev See https://eips.ethereum.org/EIPS/eip-1046
593  * @dev Note: the ERC-165 identifier for this interface is 0x3c130d90.
594  */
595 interface IERC20Metadata {
596     /**
597      * Returns a distinct Uniform Resource Identifier (URI) for the token metadata.
598      * @return a distinct Uniform Resource Identifier (URI) for the token metadata.
599      */
600     function tokenURI() external view returns (string memory);
601 }
602 
603 
604 // File @animoca/ethereum-contracts-assets/contracts/token/ERC20/interfaces/IERC20Permit.sol@v3.0.1
605 
606 pragma solidity >=0.7.6 <0.8.0;
607 
608 /**
609  * @title ERC20 Token Standard, ERC2612 optional extension: permit – 712-signed approvals
610  * Interface for allowing ERC20 approvals to be made via ECDSA `secp256k1` signatures.
611  * @dev See https://eips.ethereum.org/EIPS/eip-2612
612  * @dev Note: the ERC-165 identifier for this interface is 0x9d8ff7da.
613  */
614 interface IERC20Permit {
615     /**
616      * Sets `value` as the allowance of `spender` over the tokens of `owner`, given `owner` account's signed permit.
617      * @dev WARNING: The standard ERC-20 race condition for approvals applies to `permit()` as well: https://swcregistry.io/docs/SWC-114
618      * @dev Reverts if `owner` is the zero address.
619      * @dev Reverts if the current blocktime is > `deadline`.
620      * @dev Reverts if `r`, `s`, and `v` is not a valid `secp256k1` signature from `owner`.
621      * @dev Emits an {IERC20-Approval} event.
622      * @param owner The token owner granting the allowance to `spender`.
623      * @param spender The token spender being granted the allowance by `owner`.
624      * @param value The token amount of the allowance.
625      * @param deadline The deadline from which the permit signature is no longer valid.
626      * @param v Permit signature v parameter
627      * @param r Permit signature r parameter.
628      * @param s Permis signature s parameter.
629      */
630     function permit(
631         address owner,
632         address spender,
633         uint256 value,
634         uint256 deadline,
635         uint8 v,
636         bytes32 r,
637         bytes32 s
638     ) external;
639 
640     /**
641      * Returns the current permit nonce of `owner`.
642      * @param owner the address to check the nonce of.
643      * @return the current permit nonce of `owner`.
644      */
645     function nonces(address owner) external view returns (uint256);
646 
647     /**
648      * Returns the EIP-712 encoded hash struct of the domain-specific information for permits.
649      *
650      * @dev A common ERC-20 permit implementation choice for the `DOMAIN_SEPARATOR` is:
651      *
652      *  keccak256(
653      *      abi.encode(
654      *          keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
655      *          keccak256(bytes(name)),
656      *          keccak256(bytes(version)),
657      *          chainId,
658      *          address(this)))
659      *
660      *  where
661      *   - `name` (string) is the ERC-20 token name.
662      *   - `version` (string) refers to the ERC-20 token contract version.
663      *   - `chainId` (uint256) is the chain ID to which the ERC-20 token contract is deployed to.
664      *   - `verifyingContract` (address) is the ERC-20 token contract address.
665      *
666      * @return the EIP-712 encoded hash struct of the domain-specific information for permits.
667      */
668     // solhint-disable-next-line func-name-mixedcase
669     function DOMAIN_SEPARATOR() external view returns (bytes32);
670 }
671 
672 
673 // File @animoca/ethereum-contracts-assets/contracts/token/ERC20/interfaces/IERC20Receiver.sol@v3.0.1
674 
675 pragma solidity >=0.7.6 <0.8.0;
676 
677 /**
678  * @title ERC20 Token Standard, Tokens Receiver.
679  * Interface for any contract that wants to support safeTransfers from ERC20 contracts with Safe Transfers extension.
680  * @dev See https://eips.ethereum.org/EIPS/eip-20
681  * @dev Note: the ERC-165 identifier for this interface is 0x4fc35859.
682  */
683 interface IERC20Receiver {
684     /**
685      * Handles the receipt of ERC20 tokens.
686      * @param sender The initiator of the transfer.
687      * @param from The address which transferred the tokens.
688      * @param value The amount of tokens transferred.
689      * @param data Optional additional data with no specified format.
690      * @return bytes4 `bytes4(keccak256("onERC20Received(address,address,uint256,bytes)"))`
691      */
692     function onERC20Received(
693         address sender,
694         address from,
695         uint256 value,
696         bytes calldata data
697     ) external returns (bytes4);
698 }
699 
700 
701 // File @animoca/ethereum-contracts-assets/contracts/token/ERC20/ERC20.sol@v3.0.1
702 
703 pragma solidity >=0.7.6 <0.8.0;
704 
705 
706 
707 
708 
709 
710 
711 
712 
713 
714 
715 /**
716  * @title ERC20 Fungible Token Contract.
717  */
718 contract ERC20 is
719     ManagedIdentity,
720     IERC165,
721     IERC20,
722     IERC20Detailed,
723     IERC20Metadata,
724     IERC20Allowance,
725     IERC20BatchTransfers,
726     IERC20SafeTransfers,
727     IERC20Permit
728 {
729     using AddressIsContract for address;
730 
731     // keccak256("Permit(address owner,address spender,uint256 value,uint256 nonce,uint256 deadline)")
732     bytes32 internal constant PERMIT_TYPEHASH = 0x6e71edae12b1b97f4d1f60370fef10105fa2faae0126114a169c64845d6126c9;
733 
734     uint256 public immutable deploymentChainId;
735 
736     // solhint-disable-next-line var-name-mixedcase
737     bytes32 internal immutable _DOMAIN_SEPARATOR;
738 
739     /// @inheritdoc IERC20Permit
740     mapping(address => uint256) public override nonces;
741 
742     string internal _name;
743     string internal _symbol;
744     uint8 internal immutable _decimals;
745     string internal _tokenURI;
746 
747     mapping(address => uint256) internal _balances;
748     mapping(address => mapping(address => uint256)) internal _allowances;
749     uint256 internal _totalSupply;
750 
751     constructor(
752         string memory name_,
753         string memory symbol_,
754         uint8 decimals_
755     ) {
756         _name = name_;
757         _symbol = symbol_;
758         _decimals = decimals_;
759 
760         uint256 chainId;
761         assembly {
762             chainId := chainid()
763         }
764         deploymentChainId = chainId;
765         _DOMAIN_SEPARATOR = _calculateDomainSeparator(chainId, bytes(name_));
766     }
767 
768     //======================================================= ERC165 ========================================================//
769 
770     /// @inheritdoc IERC165
771     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
772         return
773             interfaceId == type(IERC165).interfaceId ||
774             interfaceId == type(IERC20).interfaceId ||
775             interfaceId == type(IERC20Detailed).interfaceId ||
776             interfaceId == type(IERC20Metadata).interfaceId ||
777             interfaceId == type(IERC20Allowance).interfaceId ||
778             interfaceId == type(IERC20BatchTransfers).interfaceId ||
779             interfaceId == type(IERC20SafeTransfers).interfaceId ||
780             interfaceId == type(IERC20Permit).interfaceId;
781     }
782 
783     //======================================================== ERC20 ========================================================//
784 
785     /// @inheritdoc IERC20
786     function totalSupply() external view override returns (uint256) {
787         return _totalSupply;
788     }
789 
790     /// @inheritdoc IERC20
791     function balanceOf(address account) external view override returns (uint256) {
792         return _balances[account];
793     }
794 
795     /// @inheritdoc IERC20
796     function allowance(address owner, address spender) public view virtual override returns (uint256) {
797         return _allowances[owner][spender];
798     }
799 
800     /// @inheritdoc IERC20
801     function approve(address spender, uint256 value) external virtual override returns (bool) {
802         _approve(_msgSender(), spender, value);
803         return true;
804     }
805 
806     /// @inheritdoc IERC20
807     function transfer(address to, uint256 value) external virtual override returns (bool) {
808         _transfer(_msgSender(), to, value);
809         return true;
810     }
811 
812     /// @inheritdoc IERC20
813     function transferFrom(
814         address from,
815         address to,
816         uint256 value
817     ) external virtual override returns (bool) {
818         _transferFrom(_msgSender(), from, to, value);
819         return true;
820     }
821 
822     //==================================================== ERC20Detailed ====================================================//
823 
824     /// @inheritdoc IERC20Detailed
825     function name() external view override returns (string memory) {
826         return _name;
827     }
828 
829     /// @inheritdoc IERC20Detailed
830     function symbol() external view override returns (string memory) {
831         return _symbol;
832     }
833 
834     /// @inheritdoc IERC20Detailed
835     function decimals() external view override returns (uint8) {
836         return _decimals;
837     }
838 
839     //==================================================== ERC20Metadata ====================================================//
840 
841     /// @inheritdoc IERC20Metadata
842     function tokenURI() external view override returns (string memory) {
843         return _tokenURI;
844     }
845 
846     //=================================================== ERC20Allowance ====================================================//
847 
848     /// @inheritdoc IERC20Allowance
849     function increaseAllowance(address spender, uint256 addedValue) external virtual override returns (bool) {
850         require(spender != address(0), "ERC20: zero address spender");
851         address owner = _msgSender();
852         uint256 allowance_ = _allowances[owner][spender];
853         if (addedValue != 0) {
854             uint256 newAllowance = allowance_ + addedValue;
855             require(newAllowance > allowance_, "ERC20: allowance overflow");
856             _allowances[owner][spender] = newAllowance;
857             allowance_ = newAllowance;
858         }
859         emit Approval(owner, spender, allowance_);
860 
861         return true;
862     }
863 
864     /// @inheritdoc IERC20Allowance
865     function decreaseAllowance(address spender, uint256 subtractedValue) external virtual override returns (bool) {
866         require(spender != address(0), "ERC20: zero address spender");
867         _decreaseAllowance(_msgSender(), spender, subtractedValue);
868         return true;
869     }
870 
871     //================================================= ERC20BatchTransfers =================================================//
872 
873     /// @inheritdoc IERC20BatchTransfers
874     function batchTransfer(address[] calldata recipients, uint256[] calldata values) external virtual override returns (bool) {
875         uint256 length = recipients.length;
876         require(length == values.length, "ERC20: inconsistent arrays");
877         address sender = _msgSender();
878         uint256 balance = _balances[sender];
879 
880         uint256 totalValue;
881         uint256 selfTransferTotalValue;
882         for (uint256 i; i != length; ++i) {
883             address to = recipients[i];
884             require(to != address(0), "ERC20: to zero address");
885 
886             uint256 value = values[i];
887             if (value != 0) {
888                 uint256 newTotalValue = totalValue + value;
889                 require(newTotalValue > totalValue, "ERC20: values overflow");
890                 totalValue = newTotalValue;
891                 if (sender != to) {
892                     _balances[to] += value;
893                 } else {
894                     require(value <= balance, "ERC20: insufficient balance");
895                     selfTransferTotalValue += value; // cannot overflow as 'selfTransferTotalValue <= totalValue' is always true
896                 }
897             }
898             emit Transfer(sender, to, value);
899         }
900 
901         if (totalValue != 0 && totalValue != selfTransferTotalValue) {
902             uint256 newBalance = balance - totalValue;
903             require(newBalance < balance, "ERC20: insufficient balance"); // balance must be sufficient, including self-transfers
904             _balances[sender] = newBalance + selfTransferTotalValue; // do not deduct self-transfers from the sender balance
905         }
906         return true;
907     }
908 
909     /// @inheritdoc IERC20BatchTransfers
910     function batchTransferFrom(
911         address from,
912         address[] calldata recipients,
913         uint256[] calldata values
914     ) external virtual override returns (bool) {
915         uint256 length = recipients.length;
916         require(length == values.length, "ERC20: inconsistent arrays");
917 
918         uint256 balance = _balances[from];
919 
920         uint256 totalValue;
921         uint256 selfTransferTotalValue;
922         for (uint256 i; i != length; ++i) {
923             address to = recipients[i];
924             require(to != address(0), "ERC20: to zero address");
925 
926             uint256 value = values[i];
927 
928             if (value != 0) {
929                 uint256 newTotalValue = totalValue + value;
930                 require(newTotalValue > totalValue, "ERC20: values overflow");
931                 totalValue = newTotalValue;
932                 if (from != to) {
933                     _balances[to] += value;
934                 } else {
935                     require(value <= balance, "ERC20: insufficient balance");
936                     selfTransferTotalValue += value; // cannot overflow as 'selfTransferTotalValue <= totalValue' is always true
937                 }
938             }
939 
940             emit Transfer(from, to, value);
941         }
942 
943         if (totalValue != 0 && totalValue != selfTransferTotalValue) {
944             uint256 newBalance = balance - totalValue;
945             require(newBalance < balance, "ERC20: insufficient balance"); // balance must be sufficient, including self-transfers
946             _balances[from] = newBalance + selfTransferTotalValue; // do not deduct self-transfers from the sender balance
947         }
948 
949         address sender = _msgSender();
950         if (from != sender) {
951             _decreaseAllowance(from, sender, totalValue);
952         }
953 
954         return true;
955     }
956 
957     //================================================= ERC20SafeTransfers ==================================================//
958 
959     /// @inheritdoc IERC20SafeTransfers
960     function safeTransfer(
961         address to,
962         uint256 amount,
963         bytes calldata data
964     ) external virtual override returns (bool) {
965         address sender = _msgSender();
966         _transfer(sender, to, amount);
967         if (to.isContract()) {
968             require(IERC20Receiver(to).onERC20Received(sender, sender, amount, data) == type(IERC20Receiver).interfaceId, "ERC20: transfer refused");
969         }
970         return true;
971     }
972 
973     /// @inheritdoc IERC20SafeTransfers
974     function safeTransferFrom(
975         address from,
976         address to,
977         uint256 amount,
978         bytes calldata data
979     ) external virtual override returns (bool) {
980         address sender = _msgSender();
981         _transferFrom(sender, from, to, amount);
982         if (to.isContract()) {
983             require(IERC20Receiver(to).onERC20Received(sender, from, amount, data) == type(IERC20Receiver).interfaceId, "ERC20: transfer refused");
984         }
985         return true;
986     }
987 
988     //===================================================== ERC20Permit =====================================================//
989 
990     /// @inheritdoc IERC20Permit
991     // solhint-disable-next-line func-name-mixedcase
992     function DOMAIN_SEPARATOR() public view override returns (bytes32) {
993         uint256 chainId;
994         assembly {
995             chainId := chainid()
996         }
997         // recompute the domain separator in case of fork and chainid update
998         return chainId == deploymentChainId ? _DOMAIN_SEPARATOR : _calculateDomainSeparator(chainId, bytes(_name));
999     }
1000 
1001     /// @inheritdoc IERC20Permit
1002     function permit(
1003         address owner,
1004         address spender,
1005         uint256 value,
1006         uint256 deadline,
1007         uint8 v,
1008         bytes32 r,
1009         bytes32 s
1010     ) external virtual override {
1011         require(owner != address(0), "ERC20: zero address owner");
1012         require(block.timestamp <= deadline, "ERC20: expired permit");
1013         bytes32 hashStruct = keccak256(abi.encode(PERMIT_TYPEHASH, owner, spender, value, nonces[owner]++, deadline));
1014         bytes32 hash = keccak256(abi.encodePacked("\x19\x01", DOMAIN_SEPARATOR(), hashStruct));
1015         address signer = ecrecover(hash, v, r, s);
1016         require(signer == owner, "ERC20: invalid permit");
1017         _approve(owner, spender, value);
1018     }
1019 
1020     //============================================ High-level Internal Functions ============================================//
1021 
1022     function _approve(
1023         address owner,
1024         address spender,
1025         uint256 value
1026     ) internal {
1027         require(spender != address(0), "ERC20: zero address spender");
1028         _allowances[owner][spender] = value;
1029         emit Approval(owner, spender, value);
1030     }
1031 
1032     function _decreaseAllowance(
1033         address owner,
1034         address spender,
1035         uint256 subtractedValue
1036     ) internal {
1037         uint256 allowance_ = _allowances[owner][spender];
1038 
1039         if (allowance_ != type(uint256).max && subtractedValue != 0) {
1040             // save gas when allowance is maximal by not reducing it (see https://github.com/ethereum/EIPs/issues/717)
1041             uint256 newAllowance = allowance_ - subtractedValue;
1042             require(newAllowance < allowance_, "ERC20: insufficient allowance");
1043             _allowances[owner][spender] = newAllowance;
1044             allowance_ = newAllowance;
1045         }
1046         emit Approval(owner, spender, allowance_);
1047     }
1048 
1049     function _transfer(
1050         address from,
1051         address to,
1052         uint256 value
1053     ) internal virtual {
1054         require(to != address(0), "ERC20: to zero address");
1055 
1056         if (value != 0) {
1057             uint256 balance = _balances[from];
1058             uint256 newBalance = balance - value;
1059             require(newBalance < balance, "ERC20: insufficient balance");
1060             if (from != to) {
1061                 _balances[from] = newBalance;
1062                 _balances[to] += value;
1063             }
1064         }
1065 
1066         emit Transfer(from, to, value);
1067     }
1068 
1069     function _transferFrom(
1070         address sender,
1071         address from,
1072         address to,
1073         uint256 value
1074     ) internal {
1075         _transfer(from, to, value);
1076         if (from != sender) {
1077             _decreaseAllowance(from, sender, value);
1078         }
1079     }
1080 
1081     function _mint(address to, uint256 value) internal virtual {
1082         require(to != address(0), "ERC20: zero address");
1083         uint256 supply = _totalSupply;
1084         if (value != 0) {
1085             uint256 newSupply = supply + value;
1086             require(newSupply > supply, "ERC20: supply overflow");
1087             _totalSupply = newSupply;
1088             _balances[to] += value; // balance cannot overflow if supply does not
1089         }
1090         emit Transfer(address(0), to, value);
1091     }
1092 
1093     function _batchMint(address[] memory recipients, uint256[] memory values) internal virtual {
1094         uint256 length = recipients.length;
1095         require(length == values.length, "ERC20: inconsistent arrays");
1096 
1097         uint256 totalValue;
1098         for (uint256 i; i != length; ++i) {
1099             address to = recipients[i];
1100             require(to != address(0), "ERC20: zero address");
1101 
1102             uint256 value = values[i];
1103             if (value != 0) {
1104                 uint256 newTotalValue = totalValue + value;
1105                 require(newTotalValue > totalValue, "ERC20: values overflow");
1106                 totalValue = newTotalValue;
1107                 _balances[to] += value; // balance cannot overflow if supply does not
1108             }
1109             emit Transfer(address(0), to, value);
1110         }
1111 
1112         if (totalValue != 0) {
1113             uint256 supply = _totalSupply;
1114             uint256 newSupply = supply + totalValue;
1115             require(newSupply > supply, "ERC20: supply overflow");
1116             _totalSupply = newSupply;
1117         }
1118     }
1119 
1120     function _burn(address from, uint256 value) internal virtual {
1121         if (value != 0) {
1122             uint256 balance = _balances[from];
1123             uint256 newBalance = balance - value;
1124             require(newBalance < balance, "ERC20: insufficient balance");
1125             _balances[from] = newBalance;
1126             _totalSupply -= value; // will not underflow if balance does not
1127         }
1128         emit Transfer(from, address(0), value);
1129     }
1130 
1131     function _burnFrom(address from, uint256 value) internal virtual {
1132         _burn(from, value);
1133         address sender = _msgSender();
1134         if (from != sender) {
1135             _decreaseAllowance(from, sender, value);
1136         }
1137     }
1138 
1139     function _batchBurnFrom(address[] memory owners, uint256[] memory values) internal virtual {
1140         uint256 length = owners.length;
1141         require(length == values.length, "ERC20: inconsistent arrays");
1142 
1143         address sender = _msgSender();
1144 
1145         uint256 totalValue;
1146         for (uint256 i; i != length; ++i) {
1147             address from = owners[i];
1148             uint256 value = values[i];
1149             if (value != 0) {
1150                 uint256 balance = _balances[from];
1151                 uint256 newBalance = balance - value;
1152                 require(newBalance < balance, "ERC20: insufficient balance");
1153                 _balances[from] = newBalance;
1154                 totalValue += value; // totalValue cannot overflow if the individual balances do not underflow
1155             }
1156             emit Transfer(from, address(0), value);
1157 
1158             if (from != sender) {
1159                 _decreaseAllowance(from, sender, value);
1160             }
1161         }
1162 
1163         if (totalValue != 0) {
1164             _totalSupply -= totalValue; // _totalSupply cannot underfow as balances do not underflow
1165         }
1166     }
1167 
1168     //============================================== Helper Internal Functions ==============================================//
1169 
1170     function _calculateDomainSeparator(uint256 chainId, bytes memory name_) private view returns (bytes32) {
1171         return
1172             keccak256(
1173                 abi.encode(
1174                     keccak256("EIP712Domain(string name,string version,uint256 chainId,address verifyingContract)"),
1175                     keccak256(name_),
1176                     keccak256("1"),
1177                     chainId,
1178                     address(this)
1179                 )
1180             );
1181     }
1182 }
1183 
1184 
1185 // File ethereum-universal-forwarder/src/solc_0.7/ERC2771/UsingAppendedCallData.sol@v0.1.4
1186 pragma solidity ^0.7.0;
1187 
1188 abstract contract UsingAppendedCallData {
1189     function _lastAppendedDataAsSender() internal pure virtual returns (address payable sender) {
1190         // Copied from openzeppelin : https://github.com/OpenZeppelin/openzeppelin-contracts/blob/9d5f77db9da0604ce0b25148898a94ae2c20d70f/contracts/metatx/ERC2771Context.sol1
1191         // The assembly code is more direct than the Solidity version using `abi.decode`.
1192         // solhint-disable-next-line no-inline-assembly
1193         assembly {
1194             sender := shr(96, calldataload(sub(calldatasize(), 20)))
1195         }
1196     }
1197 
1198     function _msgDataAssuming20BytesAppendedData() internal pure virtual returns (bytes calldata) {
1199         return msg.data[:msg.data.length - 20];
1200     }
1201 }
1202 
1203 
1204 // File ethereum-universal-forwarder/src/solc_0.7/ERC2771/IERC2771.sol@v0.1.4
1205 pragma solidity ^0.7.0;
1206 
1207 interface IERC2771 {
1208     function isTrustedForwarder(address forwarder) external view returns (bool);
1209 }
1210 
1211 
1212 // File ethereum-universal-forwarder/src/solc_0.7/ERC2771/IForwarderRegistry.sol@v0.1.4
1213 pragma solidity ^0.7.0;
1214 
1215 interface IForwarderRegistry {
1216     function isForwarderFor(address, address) external view returns (bool);
1217 }
1218 
1219 
1220 // File ethereum-universal-forwarder/src/solc_0.7/ERC2771/UsingUniversalForwarding.sol@v0.1.4
1221 pragma solidity ^0.7.0;
1222 
1223 
1224 
1225 abstract contract UsingUniversalForwarding is UsingAppendedCallData, IERC2771 {
1226     IForwarderRegistry internal immutable _forwarderRegistry;
1227     address internal immutable _universalForwarder;
1228 
1229     constructor(IForwarderRegistry forwarderRegistry, address universalForwarder) {
1230         _universalForwarder = universalForwarder;
1231         _forwarderRegistry = forwarderRegistry;
1232     }
1233 
1234     function isTrustedForwarder(address forwarder) external view virtual override returns (bool) {
1235         return forwarder == _universalForwarder || forwarder == address(_forwarderRegistry);
1236     }
1237 
1238     function _msgSender() internal view virtual returns (address payable) {
1239         address payable msgSender = msg.sender;
1240         address payable sender = _lastAppendedDataAsSender();
1241         if (msgSender == address(_forwarderRegistry) || msgSender == _universalForwarder) {
1242             // if forwarder use appended data
1243             return sender;
1244         }
1245 
1246         // if msg.sender is neither the registry nor the universal forwarder,
1247         // we have to check the last 20bytes of the call data intepreted as an address
1248         // and check if the msg.sender was registered as forewarder for that address
1249         // we check tx.origin to save gas in case where msg.sender == tx.origin
1250         // solhint-disable-next-line avoid-tx-origin
1251         if (msgSender != tx.origin && _forwarderRegistry.isForwarderFor(sender, msgSender)) {
1252             return sender;
1253         }
1254 
1255         return msgSender;
1256     }
1257 
1258     function _msgData() internal view virtual returns (bytes calldata) {
1259         address payable msgSender = msg.sender;
1260         if (msgSender == address(_forwarderRegistry) || msgSender == _universalForwarder) {
1261             // if forwarder use appended data
1262             return _msgDataAssuming20BytesAppendedData();
1263         }
1264 
1265         // we check tx.origin to save gas in case where msg.sender == tx.origin
1266         // solhint-disable-next-line avoid-tx-origin
1267         if (msgSender != tx.origin && _forwarderRegistry.isForwarderFor(_lastAppendedDataAsSender(), msgSender)) {
1268             return _msgDataAssuming20BytesAppendedData();
1269         }
1270         return msg.data;
1271     }
1272 }
1273 
1274 
1275 // File contracts/token/erc20/PrimateCoin.sol
1276 
1277 pragma solidity >=0.7.6 <0.8.0;
1278 
1279 
1280 
1281 /**
1282  * @title PrimateCoin
1283  */
1284 contract PrimateCoin is ERC20, UsingUniversalForwarding, Recoverable {
1285     string public constant NAME = "PRIMATE";
1286     string public constant SYMBOL = "PRIMATE";
1287     uint8 public constant DECIMALS = 18;
1288 
1289     /**
1290      * Constructor.
1291      * @dev Reverts if `values` and `recipients` have different lengths.
1292      * @dev Reverts if one of `recipients` is the zero address.
1293      * @dev Emits an {IERC20-Transfer} event for each transfer with `from` set to the zero address.
1294      * @param recipients the accounts to deliver the tokens to.
1295      * @param values the amounts of tokens to mint to each of `recipients`.
1296      * @param forwarderRegistry Registry of approved meta-transaction forwarders.
1297      * @param universalForwarder Universal meta-transaction forwarder.
1298      */
1299     constructor(
1300         address[] memory recipients,
1301         uint256[] memory values,
1302         IForwarderRegistry forwarderRegistry,
1303         address universalForwarder
1304     ) ERC20(NAME, SYMBOL, DECIMALS) UsingUniversalForwarding(forwarderRegistry, universalForwarder) Ownable(msg.sender) {
1305         _batchMint(recipients, values);
1306     }
1307 
1308     /**
1309      * Updates the URI of the token.
1310      * @dev Reverts if the sender is not the contract owner.
1311      * @param tokenURI_ the updated URI.
1312      */
1313     function setTokenURI(string calldata tokenURI_) external {
1314         _requireOwnership(_msgSender());
1315         _tokenURI = tokenURI_;
1316     }
1317 
1318     function _msgSender() internal view virtual override(ManagedIdentity, UsingUniversalForwarding) returns (address payable) {
1319         return UsingUniversalForwarding._msgSender();
1320     }
1321 
1322     function _msgData() internal view virtual override(ManagedIdentity, UsingUniversalForwarding) returns (bytes memory ret) {
1323         return UsingUniversalForwarding._msgData();
1324     }
1325 }