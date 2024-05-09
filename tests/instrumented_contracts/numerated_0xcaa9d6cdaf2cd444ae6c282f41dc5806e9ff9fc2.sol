1 // File: .deps/MultiAuction 6/libs/SafeTransferLib.sol
2 
3 
4 pragma solidity >=0.8.4;
5 
6 /// @notice Safe ETH and ERC20 transfer library that gracefully handles missing return values.
7 /// @author Solady (https://github.com/vectorized/solady/blob/main/src/utils/SafeTransferLib.sol)
8 /// @author Modified from Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/SafeTransferLib.sol)
9 ///
10 /// @dev Note:
11 /// - For ETH transfers, please use `forceSafeTransferETH` for gas griefing protection.
12 /// - For ERC20s, this implementation won't check that a token has code,
13 /// responsibility is delegated to the caller.
14 library SafeTransferLib {
15     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
16     /*                       CUSTOM ERRORS                        */
17     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
18 
19     /// @dev The ETH transfer has failed.
20     error ETHTransferFailed();
21 
22     /// @dev The ERC20 `transferFrom` has failed.
23     error TransferFromFailed();
24 
25     /// @dev The ERC20 `transfer` has failed.
26     error TransferFailed();
27 
28     /// @dev The ERC20 `approve` has failed.
29     error ApproveFailed();
30 
31     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
32     /*                         CONSTANTS                          */
33     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
34 
35     /// @dev Suggested gas stipend for contract receiving ETH
36     /// that disallows any storage writes.
37     uint256 internal constant _GAS_STIPEND_NO_STORAGE_WRITES = 2300;
38 
39     /// @dev Suggested gas stipend for contract receiving ETH to perform a few
40     /// storage reads and writes, but low enough to prevent griefing.
41     /// Multiply by a small constant (e.g. 2), if needed.
42     uint256 internal constant _GAS_STIPEND_NO_GRIEF = 100000;
43 
44     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
45     /*                       ETH OPERATIONS                       */
46     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
47 
48     /// @dev Sends `amount` (in wei) ETH to `to`.
49     /// Reverts upon failure.
50     ///
51     /// Note: This implementation does NOT protect against gas griefing.
52     /// Please use `forceSafeTransferETH` for gas griefing protection.
53     function safeTransferETH(address to, uint256 amount) internal {
54         /// @solidity memory-safe-assembly
55         assembly {
56             // Transfer the ETH and check if it succeeded or not.
57             if iszero(call(gas(), to, amount, 0, 0, 0, 0)) {
58                 // Store the function selector of `ETHTransferFailed()`.
59                 mstore(0x00, 0xb12d13eb)
60                 // Revert with (offset, size).
61                 revert(0x1c, 0x04)
62             }
63         }
64     }
65 
66     /// @dev Force sends `amount` (in wei) ETH to `to`, with a `gasStipend`.
67     /// The `gasStipend` can be set to a low enough value to prevent
68     /// storage writes or gas griefing.
69     ///
70     /// If sending via the normal procedure fails, force sends the ETH by
71     /// creating a temporary contract which uses `SELFDESTRUCT` to force send the ETH.
72     ///
73     /// Reverts if the current contract has insufficient balance.
74     function forceSafeTransferETH(address to, uint256 amount, uint256 gasStipend) internal {
75         /// @solidity memory-safe-assembly
76         assembly {
77             // If insufficient balance, revert.
78             if lt(selfbalance(), amount) {
79                 // Store the function selector of `ETHTransferFailed()`.
80                 mstore(0x00, 0xb12d13eb)
81                 // Revert with (offset, size).
82                 revert(0x1c, 0x04)
83             }
84             // Transfer the ETH and check if it succeeded or not.
85             if iszero(call(gasStipend, to, amount, 0, 0, 0, 0)) {
86                 mstore(0x00, to) // Store the address in scratch space.
87                 mstore8(0x0b, 0x73) // Opcode `PUSH20`.
88                 mstore8(0x20, 0xff) // Opcode `SELFDESTRUCT`.
89                 // We can directly use `SELFDESTRUCT` in the contract creation.
90                 // Compatible with `SENDALL`: https://eips.ethereum.org/EIPS/eip-4758
91                 if iszero(create(amount, 0x0b, 0x16)) {
92                     // To coerce gas estimation to provide enough gas for the `create` above.
93                     if iszero(gt(gas(), 1000000)) { revert(0, 0) }
94                 }
95             }
96         }
97     }
98 
99     /// @dev Force sends `amount` (in wei) ETH to `to`, with a gas stipend
100     /// equal to `_GAS_STIPEND_NO_GRIEF`. This gas stipend is a reasonable default
101     /// for 99% of cases and can be overridden with the three-argument version of this
102     /// function if necessary.
103     ///
104     /// If sending via the normal procedure fails, force sends the ETH by
105     /// creating a temporary contract which uses `SELFDESTRUCT` to force send the ETH.
106     ///
107     /// Reverts if the current contract has insufficient balance.
108     function forceSafeTransferETH(address to, uint256 amount) internal {
109         // Manually inlined because the compiler doesn't inline functions with branches.
110         /// @solidity memory-safe-assembly
111         assembly {
112             // If insufficient balance, revert.
113             if lt(selfbalance(), amount) {
114                 // Store the function selector of `ETHTransferFailed()`.
115                 mstore(0x00, 0xb12d13eb)
116                 // Revert with (offset, size).
117                 revert(0x1c, 0x04)
118             }
119             // Transfer the ETH and check if it succeeded or not.
120             if iszero(call(_GAS_STIPEND_NO_GRIEF, to, amount, 0, 0, 0, 0)) {
121                 mstore(0x00, to) // Store the address in scratch space.
122                 mstore8(0x0b, 0x73) // Opcode `PUSH20`.
123                 mstore8(0x20, 0xff) // Opcode `SELFDESTRUCT`.
124                 // We can directly use `SELFDESTRUCT` in the contract creation.
125                 // Compatible with `SENDALL`: https://eips.ethereum.org/EIPS/eip-4758
126                 if iszero(create(amount, 0x0b, 0x16)) {
127                     // To coerce gas estimation to provide enough gas for the `create` above.
128                     if iszero(gt(gas(), 1000000)) { revert(0, 0) }
129                 }
130             }
131         }
132     }
133 
134     /// @dev Sends `amount` (in wei) ETH to `to`, with a `gasStipend`.
135     /// The `gasStipend` can be set to a low enough value to prevent
136     /// storage writes or gas griefing.
137     ///
138     /// Simply use `gasleft()` for `gasStipend` if you don't need a gas stipend.
139     ///
140     /// Note: Does NOT revert upon failure.
141     /// Returns whether the transfer of ETH is successful instead.
142     function trySafeTransferETH(address to, uint256 amount, uint256 gasStipend)
143         internal
144         returns (bool success)
145     {
146         /// @solidity memory-safe-assembly
147         assembly {
148             // Transfer the ETH and check if it succeeded or not.
149             success := call(gasStipend, to, amount, 0, 0, 0, 0)
150         }
151     }
152 
153     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
154     /*                      ERC20 OPERATIONS                      */
155     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
156 
157     /// @dev Sends `amount` of ERC20 `token` from `from` to `to`.
158     /// Reverts upon failure.
159     ///
160     /// The `from` account must have at least `amount` approved for
161     /// the current contract to manage.
162     function safeTransferFrom(address token, address from, address to, uint256 amount) internal {
163         /// @solidity memory-safe-assembly
164         assembly {
165             let m := mload(0x40) // Cache the free memory pointer.
166 
167             mstore(0x60, amount) // Store the `amount` argument.
168             mstore(0x40, to) // Store the `to` argument.
169             mstore(0x2c, shl(96, from)) // Store the `from` argument.
170             // Store the function selector of `transferFrom(address,address,uint256)`.
171             mstore(0x0c, 0x23b872dd000000000000000000000000)
172 
173             if iszero(
174                 and( // The arguments of `and` are evaluated from right to left.
175                     // Set success to whether the call reverted, if not we check it either
176                     // returned exactly 1 (can't just be non-zero data), or had no return data.
177                     or(eq(mload(0x00), 1), iszero(returndatasize())),
178                     call(gas(), token, 0, 0x1c, 0x64, 0x00, 0x20)
179                 )
180             ) {
181                 // Store the function selector of `TransferFromFailed()`.
182                 mstore(0x00, 0x7939f424)
183                 // Revert with (offset, size).
184                 revert(0x1c, 0x04)
185             }
186 
187             mstore(0x60, 0) // Restore the zero slot to zero.
188             mstore(0x40, m) // Restore the free memory pointer.
189         }
190     }
191 
192     /// @dev Sends all of ERC20 `token` from `from` to `to`.
193     /// Reverts upon failure.
194     ///
195     /// The `from` account must have their entire balance approved for
196     /// the current contract to manage.
197     function safeTransferAllFrom(address token, address from, address to)
198         internal
199         returns (uint256 amount)
200     {
201         /// @solidity memory-safe-assembly
202         assembly {
203             let m := mload(0x40) // Cache the free memory pointer.
204 
205             mstore(0x40, to) // Store the `to` argument.
206             mstore(0x2c, shl(96, from)) // Store the `from` argument.
207             // Store the function selector of `balanceOf(address)`.
208             mstore(0x0c, 0x70a08231000000000000000000000000)
209             if iszero(
210                 and( // The arguments of `and` are evaluated from right to left.
211                     gt(returndatasize(), 0x1f), // At least 32 bytes returned.
212                     staticcall(gas(), token, 0x1c, 0x24, 0x60, 0x20)
213                 )
214             ) {
215                 // Store the function selector of `TransferFromFailed()`.
216                 mstore(0x00, 0x7939f424)
217                 // Revert with (offset, size).
218                 revert(0x1c, 0x04)
219             }
220 
221             // Store the function selector of `transferFrom(address,address,uint256)`.
222             mstore(0x00, 0x23b872dd)
223             // The `amount` argument is already written to the memory word at 0x60.
224             amount := mload(0x60)
225 
226             if iszero(
227                 and( // The arguments of `and` are evaluated from right to left.
228                     // Set success to whether the call reverted, if not we check it either
229                     // returned exactly 1 (can't just be non-zero data), or had no return data.
230                     or(eq(mload(0x00), 1), iszero(returndatasize())),
231                     call(gas(), token, 0, 0x1c, 0x64, 0x00, 0x20)
232                 )
233             ) {
234                 // Store the function selector of `TransferFromFailed()`.
235                 mstore(0x00, 0x7939f424)
236                 // Revert with (offset, size).
237                 revert(0x1c, 0x04)
238             }
239 
240             mstore(0x60, 0) // Restore the zero slot to zero.
241             mstore(0x40, m) // Restore the free memory pointer.
242         }
243     }
244 
245     /// @dev Sends `amount` of ERC20 `token` from the current contract to `to`.
246     /// Reverts upon failure.
247     function safeTransfer(address token, address to, uint256 amount) internal {
248         /// @solidity memory-safe-assembly
249         assembly {
250             mstore(0x14, to) // Store the `to` argument.
251             mstore(0x34, amount) // Store the `amount` argument.
252             // Store the function selector of `transfer(address,uint256)`.
253             mstore(0x00, 0xa9059cbb000000000000000000000000)
254 
255             if iszero(
256                 and( // The arguments of `and` are evaluated from right to left.
257                     // Set success to whether the call reverted, if not we check it either
258                     // returned exactly 1 (can't just be non-zero data), or had no return data.
259                     or(eq(mload(0x00), 1), iszero(returndatasize())),
260                     call(gas(), token, 0, 0x10, 0x44, 0x00, 0x20)
261                 )
262             ) {
263                 // Store the function selector of `TransferFailed()`.
264                 mstore(0x00, 0x90b8ec18)
265                 // Revert with (offset, size).
266                 revert(0x1c, 0x04)
267             }
268             // Restore the part of the free memory pointer that was overwritten.
269             mstore(0x34, 0)
270         }
271     }
272 
273     /// @dev Sends all of ERC20 `token` from the current contract to `to`.
274     /// Reverts upon failure.
275     function safeTransferAll(address token, address to) internal returns (uint256 amount) {
276         /// @solidity memory-safe-assembly
277         assembly {
278             mstore(0x00, 0x70a08231) // Store the function selector of `balanceOf(address)`.
279             mstore(0x20, address()) // Store the address of the current contract.
280             if iszero(
281                 and( // The arguments of `and` are evaluated from right to left.
282                     gt(returndatasize(), 0x1f), // At least 32 bytes returned.
283                     staticcall(gas(), token, 0x1c, 0x24, 0x34, 0x20)
284                 )
285             ) {
286                 // Store the function selector of `TransferFailed()`.
287                 mstore(0x00, 0x90b8ec18)
288                 // Revert with (offset, size).
289                 revert(0x1c, 0x04)
290             }
291 
292             mstore(0x14, to) // Store the `to` argument.
293             // The `amount` argument is already written to the memory word at 0x34.
294             amount := mload(0x34)
295             // Store the function selector of `transfer(address,uint256)`.
296             mstore(0x00, 0xa9059cbb000000000000000000000000)
297 
298             if iszero(
299                 and( // The arguments of `and` are evaluated from right to left.
300                     // Set success to whether the call reverted, if not we check it either
301                     // returned exactly 1 (can't just be non-zero data), or had no return data.
302                     or(eq(mload(0x00), 1), iszero(returndatasize())),
303                     call(gas(), token, 0, 0x10, 0x44, 0x00, 0x20)
304                 )
305             ) {
306                 // Store the function selector of `TransferFailed()`.
307                 mstore(0x00, 0x90b8ec18)
308                 // Revert with (offset, size).
309                 revert(0x1c, 0x04)
310             }
311             // Restore the part of the free memory pointer that was overwritten.
312             mstore(0x34, 0)
313         }
314     }
315 
316     /// @dev Sets `amount` of ERC20 `token` for `to` to manage on behalf of the current contract.
317     /// Reverts upon failure.
318     function safeApprove(address token, address to, uint256 amount) internal {
319         /// @solidity memory-safe-assembly
320         assembly {
321             mstore(0x14, to) // Store the `to` argument.
322             mstore(0x34, amount) // Store the `amount` argument.
323             // Store the function selector of `approve(address,uint256)`.
324             mstore(0x00, 0x095ea7b3000000000000000000000000)
325 
326             if iszero(
327                 and( // The arguments of `and` are evaluated from right to left.
328                     // Set success to whether the call reverted, if not we check it either
329                     // returned exactly 1 (can't just be non-zero data), or had no return data.
330                     or(eq(mload(0x00), 1), iszero(returndatasize())),
331                     call(gas(), token, 0, 0x10, 0x44, 0x00, 0x20)
332                 )
333             ) {
334                 // Store the function selector of `ApproveFailed()`.
335                 mstore(0x00, 0x3e3f8f73)
336                 // Revert with (offset, size).
337                 revert(0x1c, 0x04)
338             }
339             // Restore the part of the free memory pointer that was overwritten.
340             mstore(0x34, 0)
341         }
342     }
343 
344     /// @dev Returns the amount of ERC20 `token` owned by `account`.
345     /// Returns zero if the `token` does not exist.
346     function balanceOf(address token, address account) internal view returns (uint256 amount) {
347         /// @solidity memory-safe-assembly
348         assembly {
349             mstore(0x14, account) // Store the `account` argument.
350             // Store the function selector of `balanceOf(address)`.
351             mstore(0x00, 0x70a08231000000000000000000000000)
352             amount :=
353                 mul(
354                     mload(0x20),
355                     and( // The arguments of `and` are evaluated from right to left.
356                         gt(returndatasize(), 0x1f), // At least 32 bytes returned.
357                         staticcall(gas(), token, 0x10, 0x24, 0x20, 0x20)
358                     )
359                 )
360         }
361     }
362 }
363 // File: .deps/MultiAuction 6/libs/MerkleProofLib.sol
364 
365 
366 pragma solidity >=0.8.0;
367 
368 /// @notice Gas optimized merkle proof verification library.
369 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/MerkleProofLib.sol)
370 /// @author Modified from Solady (https://github.com/Vectorized/solady/blob/main/src/utils/MerkleProofLib.sol)
371 library MerkleProofLib {
372     function verify(
373         bytes32[] calldata proof,
374         bytes32 root,
375         bytes32 leaf
376     ) internal pure returns (bool isValid) {
377         /// @solidity memory-safe-assembly
378         assembly {
379             if proof.length {
380                 // Left shifting by 5 is like multiplying by 32.
381                 let end := add(proof.offset, shl(5, proof.length))
382 
383                 // Initialize offset to the offset of the proof in calldata.
384                 let offset := proof.offset
385 
386                 // Iterate over proof elements to compute root hash.
387                 // prettier-ignore
388                 for {} 1 {} {
389                     // Slot where the leaf should be put in scratch space. If
390                     // leaf > calldataload(offset): slot 32, otherwise: slot 0.
391                     let leafSlot := shl(5, gt(leaf, calldataload(offset)))
392 
393                     // Store elements to hash contiguously in scratch space.
394                     // The xor puts calldataload(offset) in whichever slot leaf
395                     // is not occupying, so 0 if leafSlot is 32, and 32 otherwise.
396                     mstore(leafSlot, leaf)
397                     mstore(xor(leafSlot, 32), calldataload(offset))
398 
399                     // Reuse leaf to store the hash to reduce stack operations.
400                     leaf := keccak256(0, 64) // Hash both slots of scratch space.
401 
402                     offset := add(offset, 32) // Shift 1 word per cycle.
403 
404                     // prettier-ignore
405                     if iszero(lt(offset, end)) { break }
406                 }
407             }
408 
409             isValid := eq(leaf, root) // The proof is valid if the roots match.
410         }
411     }
412 }
413 // File: .deps/MultiAuction 6/interfaces/IDelegationRegistry.sol
414 
415 
416 pragma solidity ^0.8.17;
417 
418 /**
419  * @title An immutable registry contract to be deployed as a standalone primitive
420  * @dev See EIP-5639, new project launches can read previous cold wallet -> hot wallet delegations
421  * from here and integrate those permissions into their flow
422  */
423 interface IDelegationRegistry {
424     /// @notice Delegation type
425     enum DelegationType {
426         NONE,
427         ALL,
428         CONTRACT,
429         TOKEN
430     }
431 
432     /// @notice Info about a single delegation, used for onchain enumeration
433     struct DelegationInfo {
434         DelegationType type_;
435         address vault;
436         address delegate;
437         address contract_;
438         uint256 tokenId;
439     }
440 
441     /// @notice Info about a single contract-level delegation
442     struct ContractDelegation {
443         address contract_;
444         address delegate;
445     }
446 
447     /// @notice Info about a single token-level delegation
448     struct TokenDelegation {
449         address contract_;
450         uint256 tokenId;
451         address delegate;
452     }
453 
454     /// @notice Emitted when a user delegates their entire wallet
455     event DelegateForAll(address vault, address delegate, bool value);
456 
457     /// @notice Emitted when a user delegates a specific contract
458     event DelegateForContract(address vault, address delegate, address contract_, bool value);
459 
460     /// @notice Emitted when a user delegates a specific token
461     event DelegateForToken(address vault, address delegate, address contract_, uint256 tokenId, bool value);
462 
463     /// @notice Emitted when a user revokes all delegations
464     event RevokeAllDelegates(address vault);
465 
466     /// @notice Emitted when a user revoes all delegations for a given delegate
467     event RevokeDelegate(address vault, address delegate);
468 
469     /**
470      * -----------  WRITE -----------
471      */
472 
473     /**
474      * @notice Allow the delegate to act on your behalf for all contracts
475      * @param delegate The hotwallet to act on your behalf
476      * @param value Whether to enable or disable delegation for this address, true for setting and false for revoking
477      */
478     function delegateForAll(address delegate, bool value) external;
479 
480     /**
481      * @notice Allow the delegate to act on your behalf for a specific contract
482      * @param delegate The hotwallet to act on your behalf
483      * @param contract_ The address for the contract you're delegating
484      * @param value Whether to enable or disable delegation for this address, true for setting and false for revoking
485      */
486     function delegateForContract(address delegate, address contract_, bool value) external;
487 
488     /**
489      * @notice Allow the delegate to act on your behalf for a specific token
490      * @param delegate The hotwallet to act on your behalf
491      * @param contract_ The address for the contract you're delegating
492      * @param tokenId The token id for the token you're delegating
493      * @param value Whether to enable or disable delegation for this address, true for setting and false for revoking
494      */
495     function delegateForToken(address delegate, address contract_, uint256 tokenId, bool value) external;
496 
497     /**
498      * @notice Revoke all delegates
499      */
500     function revokeAllDelegates() external;
501 
502     /**
503      * @notice Revoke a specific delegate for all their permissions
504      * @param delegate The hotwallet to revoke
505      */
506     function revokeDelegate(address delegate) external;
507 
508     /**
509      * @notice Remove yourself as a delegate for a specific vault
510      * @param vault The vault which delegated to the msg.sender, and should be removed
511      */
512     function revokeSelf(address vault) external;
513 
514     /**
515      * -----------  READ -----------
516      */
517 
518     /**
519      * @notice Returns all active delegations a given delegate is able to claim on behalf of
520      * @param delegate The delegate that you would like to retrieve delegations for
521      * @return info Array of DelegationInfo structs
522      */
523     function getDelegationsByDelegate(address delegate) external view returns (DelegationInfo[] memory);
524 
525     /**
526      * @notice Returns an array of wallet-level delegates for a given vault
527      * @param vault The cold wallet who issued the delegation
528      * @return addresses Array of wallet-level delegates for a given vault
529      */
530     function getDelegatesForAll(address vault) external view returns (address[] memory);
531 
532     /**
533      * @notice Returns an array of contract-level delegates for a given vault and contract
534      * @param vault The cold wallet who issued the delegation
535      * @param contract_ The address for the contract you're delegating
536      * @return addresses Array of contract-level delegates for a given vault and contract
537      */
538     function getDelegatesForContract(address vault, address contract_) external view returns (address[] memory);
539 
540     /**
541      * @notice Returns an array of contract-level delegates for a given vault's token
542      * @param vault The cold wallet who issued the delegation
543      * @param contract_ The address for the contract holding the token
544      * @param tokenId The token id for the token you're delegating
545      * @return addresses Array of contract-level delegates for a given vault's token
546      */
547     function getDelegatesForToken(address vault, address contract_, uint256 tokenId)
548         external
549         view
550         returns (address[] memory);
551 
552     /**
553      * @notice Returns all contract-level delegations for a given vault
554      * @param vault The cold wallet who issued the delegations
555      * @return delegations Array of ContractDelegation structs
556      */
557     function getContractLevelDelegations(address vault)
558         external
559         view
560         returns (ContractDelegation[] memory delegations);
561 
562     /**
563      * @notice Returns all token-level delegations for a given vault
564      * @param vault The cold wallet who issued the delegations
565      * @return delegations Array of TokenDelegation structs
566      */
567     function getTokenLevelDelegations(address vault) external view returns (TokenDelegation[] memory delegations);
568 
569     /**
570      * @notice Returns true if the address is delegated to act on the entire vault
571      * @param delegate The hotwallet to act on your behalf
572      * @param vault The cold wallet who issued the delegation
573      */
574     function checkDelegateForAll(address delegate, address vault) external view returns (bool);
575 
576     /**
577      * @notice Returns true if the address is delegated to act on your behalf for a token contract or an entire vault
578      * @param delegate The hotwallet to act on your behalf
579      * @param contract_ The address for the contract you're delegating
580      * @param vault The cold wallet who issued the delegation
581      */
582     function checkDelegateForContract(address delegate, address vault, address contract_)
583         external
584         view
585         returns (bool);
586 
587     /**
588      * @notice Returns true if the address is delegated to act on your behalf for a specific token, the token's contract or an entire vault
589      * @param delegate The hotwallet to act on your behalf
590      * @param contract_ The address for the contract you're delegating
591      * @param tokenId The token id for the token you're delegating
592      * @param vault The cold wallet who issued the delegation
593      */
594     function checkDelegateForToken(address delegate, address vault, address contract_, uint256 tokenId)
595         external
596         view
597         returns (bool);
598 }
599 // File: .deps/MultiAuction 6/MultiAuction.sol
600 
601 
602 
603 pragma solidity ^0.8.17;
604 
605 
606 
607 
608 contract MultiAuction {
609   uint256 private constant BPS = 10_000;
610   address private constant DELEGATION_REGISTRY = 0x00000000000076A84feF008CDAbe6409d2FE638B;
611   address private constant FPP = 0xA8A425864dB32fCBB459Bf527BdBb8128e6abF21;
612   uint256 private constant FPP_PROJECT_ID = 3;
613   uint256 private constant MIN_BID = 0.01 ether;
614   uint256 private constant MIN_BID_INCREASE = 1_000;
615   uint256 private constant MINT_PASS_REBATE = 1_500;
616   uint256 private constant SAFE_GAS_LIMIT = 30_000;
617   IBaseContract public immutable BASE_CONTRACT;
618   uint256 public immutable MAX_SUPPLY;
619 
620 
621   uint256 public auctionStartTime;
622   address public beneficiary1;
623   address public beneficiary2;
624   bool public paused;
625   bytes32 public settlementRoot;
626 
627   struct Auction {
628     uint24 offsetFromEnd;
629     uint72 amount;
630     address bidder;
631   }
632 
633   mapping(uint256 => Auction) public tokenIdToAuction;
634 
635   event BidMade(uint256 indexed tokenId, address bidder, uint256 amount, uint256 timestamp);
636   event Settled(uint256 indexed tokenId, uint256 timestamp);
637 
638   constructor(
639     address baseContract,
640     uint256 startTime,
641     uint256 maxSupply
642   ) {
643     BASE_CONTRACT = IBaseContract(baseContract);
644     auctionStartTime = startTime;
645     MAX_SUPPLY = maxSupply;
646     beneficiary1 = msg.sender;
647     beneficiary2 = msg.sender;
648   }
649 
650   function bid(
651     uint256 tokenId
652   ) external payable {
653     require(!paused, 'Bidding is paused');
654     require(isAuctionActive(tokenId), 'Auction Inactive');
655     require(0 < tokenId && tokenId <= MAX_SUPPLY, 'Invalid tokenId');
656 
657     Auction memory highestBid = tokenIdToAuction[tokenId];
658 
659     require(
660       msg.value >= (highestBid.amount * (BPS + MIN_BID_INCREASE) / BPS)
661       && msg.value >= MIN_BID,
662       'Bid not high enough'
663     );
664 
665     uint256 refundAmount;
666     address refundBidder;
667     uint256 offset = highestBid.offsetFromEnd;
668     uint256 endTime = auctionEndTime(tokenId);
669 
670     if (highestBid.amount > 0) {
671       refundAmount = highestBid.amount;
672       refundBidder = highestBid.bidder;
673     }
674 
675     if (endTime - block.timestamp < 15 minutes) {
676       offset += block.timestamp + 15 minutes - endTime;
677     }
678 
679     tokenIdToAuction[tokenId] = Auction(uint24(offset), uint72(msg.value), msg.sender);
680 
681     emit BidMade(tokenId, msg.sender, msg.value, block.timestamp);
682 
683     if (refundAmount > 0) {
684       SafeTransferLib.forceSafeTransferETH(refundBidder, refundAmount, SAFE_GAS_LIMIT);
685     }
686   }
687 
688   function bidOnFavs(
689     uint256[] calldata favorites,
690     uint256[] calldata expectedPrices
691   ) external payable {
692     require(!paused, 'Bidding is paused');
693     require(favorites.length == expectedPrices.length);
694 
695     uint256 totalFailed; uint256 expectedTotal;
696     for(uint256 i; i < favorites.length; ++i) {
697       uint256 tokenId = favorites[i];
698       uint256 expectedPrice = expectedPrices[i];
699       expectedTotal += expectedPrice;
700       require(0 < tokenId && tokenId <= MAX_SUPPLY, 'Invalid tokenId');
701       if(!isAuctionActive(tokenId)) {
702         totalFailed += expectedPrice;
703         break;
704       }
705 
706       Auction memory highestBid = tokenIdToAuction[tokenId];
707       if (
708         expectedPrice >= (highestBid.amount * (BPS + MIN_BID_INCREASE) / BPS)
709         && expectedPrice >= MIN_BID
710       ) {
711         uint256 refundAmount;
712         address refundBidder;
713         uint256 offset = highestBid.offsetFromEnd;
714         uint256 endTime = auctionEndTime(tokenId);
715 
716         if (highestBid.amount > 0) {
717           refundAmount = highestBid.amount;
718           refundBidder = highestBid.bidder;
719         }
720 
721         if (endTime - block.timestamp < 15 minutes) {
722           offset += block.timestamp + 15 minutes - endTime;
723         }
724 
725         tokenIdToAuction[tokenId] = Auction(uint24(offset), uint72(expectedPrice), msg.sender);
726 
727         emit BidMade(tokenId, msg.sender, expectedPrice, block.timestamp);
728 
729         if (refundAmount > 0) {
730           SafeTransferLib.forceSafeTransferETH(refundBidder, refundAmount, SAFE_GAS_LIMIT);
731         }
732       } else{
733         totalFailed += expectedPrice;
734       }
735     }
736 
737     require(msg.value >= expectedTotal);
738     if (totalFailed > 0) {
739       SafeTransferLib.forceSafeTransferETH(msg.sender, totalFailed, SAFE_GAS_LIMIT);
740     }
741   }
742 
743   function settleAuction(
744     uint256 tokenId,
745     uint256 mintPassId,
746     bytes32[] calldata proof
747   ) external payable {
748     require(settlementRoot != bytes32(0));
749     Auction memory highestBid = tokenIdToAuction[tokenId];
750     require(highestBid.bidder == msg.sender || owner() == msg.sender);
751     require(0 < tokenId && tokenId <= MAX_SUPPLY, 'Invalid tokenId');
752     require(isAuctionOver(tokenId), 'Auction for this tokenId is still active');
753 
754     uint256 amountToPay = highestBid.amount;
755     if (amountToPay > 0) {
756       BASE_CONTRACT.mint(highestBid.bidder, tokenId);
757     } else {
758       require(msg.sender == owner(), 'Ownable: caller is not the owner');
759       require(msg.value >= MIN_BID, 'Bid not high enough');
760       amountToPay = msg.value;
761 
762       BASE_CONTRACT.mint(msg.sender, tokenId);
763     }
764 
765     uint256 totalRebate = 0;
766     bool mintPassValid;
767     if (mintPassId < 1_000) {
768       address passHolder = IFPP(FPP).ownerOf(mintPassId);
769       mintPassValid = mintPassId < 1_000 && IFPP(FPP).passUses(mintPassId, FPP_PROJECT_ID) < 1 && (
770         passHolder == highestBid.bidder ||
771         IDelegationRegistry(DELEGATION_REGISTRY).checkDelegateForToken(
772           highestBid.bidder,
773           passHolder,
774           FPP,
775           mintPassId
776         )
777       ) && (
778         MerkleProofLib.verify(proof, settlementRoot, keccak256(abi.encodePacked(passHolder, mintPassId)))
779       );
780     }
781 
782     if (mintPassValid) {
783       IFPP(FPP).logPassUse(mintPassId, FPP_PROJECT_ID);
784       totalRebate = amountToPay * (MINT_PASS_REBATE) / BPS;
785     }
786 
787     tokenIdToAuction[tokenId].bidder = address(0);
788     emit Settled(tokenId, block.timestamp);
789 
790     if (totalRebate > 0) {
791       SafeTransferLib.forceSafeTransferETH(highestBid.bidder, totalRebate, SAFE_GAS_LIMIT);
792       SafeTransferLib.forceSafeTransferETH(beneficiary2, amountToPay - totalRebate, SAFE_GAS_LIMIT);
793     } else {
794       SafeTransferLib.forceSafeTransferETH(beneficiary1, amountToPay, SAFE_GAS_LIMIT);
795     }
796   }
797 
798   function settleAll(
799     uint256 startId,
800     uint256 endId,
801     bytes calldata passData
802   ) external payable onlyOwner {
803     require(settlementRoot == bytes32(0), 'settleAll not active');
804     require(passData.length == 2 * (endId - startId + 1), 'Invalid passData length');
805     require(0 < startId && endId <= MAX_SUPPLY, 'Invalid tokenId');
806 
807     uint256 unclaimedCost; uint256 amountForBene1; uint256 amountForBene2;
808     for (uint256 tokenId = startId; tokenId <= endId; ++tokenId) {
809       Auction memory highestBid = tokenIdToAuction[tokenId];
810       require(isAuctionOver(tokenId), 'Auction for this tokenId is still active');
811 
812       uint256 amountToPay = highestBid.amount;
813       if (amountToPay > 0) {
814         BASE_CONTRACT.mint(highestBid.bidder, tokenId);
815       } else {
816         amountToPay = MIN_BID;
817         unclaimedCost += MIN_BID;
818         BASE_CONTRACT.mint(msg.sender, tokenId);
819       }
820 
821       uint256 totalRebate = 0;
822       uint256 mintPassId = uint16(bytes2(passData[(tokenId - 1) * 2: tokenId * 2]));
823       bool mintPassValid;
824       if (mintPassId < 1_000) {
825         address passHolder = IFPP(FPP).ownerOf(mintPassId);
826         mintPassValid = mintPassId < 1_000 && IFPP(FPP).passUses(mintPassId, FPP_PROJECT_ID) < 1 && (
827           passHolder == highestBid.bidder ||
828           IDelegationRegistry(DELEGATION_REGISTRY).checkDelegateForToken(
829             highestBid.bidder,
830             passHolder,
831             FPP,
832             mintPassId
833           )
834         );
835       }
836   
837       if (mintPassValid) {
838         IFPP(FPP).logPassUse(mintPassId, FPP_PROJECT_ID);
839         totalRebate = amountToPay * (MINT_PASS_REBATE) / BPS;
840       }
841   
842       tokenIdToAuction[tokenId].bidder = address(0);
843       emit Settled(tokenId, block.timestamp);
844   
845       if (totalRebate > 0) {
846         SafeTransferLib.forceSafeTransferETH(highestBid.bidder, totalRebate, SAFE_GAS_LIMIT);
847         amountForBene2 += amountToPay - totalRebate;
848       } else {
849         amountForBene1 += amountToPay;
850       }
851     }
852 
853     require(msg.value >= unclaimedCost, "Insufficient funds sent for unclaimed");
854     SafeTransferLib.forceSafeTransferETH(beneficiary1, amountForBene1, SAFE_GAS_LIMIT);
855     SafeTransferLib.forceSafeTransferETH(beneficiary2, amountForBene2, SAFE_GAS_LIMIT);
856   }
857 
858   function owner() public view returns (address) {
859     return BASE_CONTRACT.owner();
860   }
861 
862   modifier onlyOwner {
863     require(msg.sender == owner(), 'Ownable: caller is not the owner');
864     _;
865   }
866 
867   function emergencyWithdraw() external onlyOwner {
868     require(block.timestamp > auctionStartTime + 48 hours);
869     (bool success,) = msg.sender.call{value: address(this).balance}("");
870     require(success);
871   }
872 
873   function enableSelfSettlement(
874     bytes32 root
875   ) external onlyOwner {
876     settlementRoot = root;
877   }
878 
879   function rescheduele(
880     uint256 newStartTime
881   ) external onlyOwner {
882     require(auctionStartTime > block.timestamp);
883     auctionStartTime = newStartTime;
884   }
885 
886   function setBeneficiary(
887     address _beneficiary1,
888     address _beneficiary2
889   ) external onlyOwner {
890     beneficiary1 = _beneficiary1;
891     beneficiary2 = _beneficiary2;
892   }
893 
894   function setPaused(
895     bool _paused
896   ) external onlyOwner {
897     paused = _paused;
898   }
899 
900   function auctionEndTime(
901     uint256 tokenId
902   ) public view returns (uint256) {
903     return auctionStartTime + 24 hours + tokenIdToAuction[tokenId].offsetFromEnd;
904   }
905 
906   function isAuctionActive(
907     uint256 tokenId
908   ) public view returns (bool) {
909     uint256 endTime = auctionEndTime(tokenId);
910     return (block.timestamp >= auctionStartTime && block.timestamp < endTime);
911   }
912 
913   function isAuctionOver(
914     uint256 tokenId
915   ) public view returns (bool) {
916     uint256 endTime = auctionEndTime(tokenId);
917     return (block.timestamp >= endTime);
918   }
919 }
920 
921 interface IFPP {
922   function logPassUse(uint256 tokenId, uint256 projectId) external;
923   function ownerOf(uint256 tokenId) external returns (address);
924   function passUses(uint256 tokenId, uint256 projectId) external returns (uint256);
925 }
926 
927 interface IBaseContract {
928   function mint(address to, uint256 tokenId) external;
929   function owner() external view returns (address);
930 }