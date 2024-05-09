1 // File: solady/src/utils/ECDSA.sol
2 
3 
4 pragma solidity ^0.8.4;
5 
6 /// @notice Gas optimized ECDSA wrapper.
7 /// @author Solady (https://github.com/vectorized/solady/blob/main/src/utils/ECDSA.sol)
8 /// @author Modified from Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/ECDSA.sol)
9 /// @author Modified from OpenZeppelin (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/ECDSA.sol)
10 ///
11 /// @dev Note:
12 /// - The recovery functions use the ecrecover precompile (0x1).
13 ///
14 /// WARNING! Do NOT use signatures as unique identifiers.
15 /// Please use EIP712 with a nonce included in the digest to prevent replay attacks.
16 /// This implementation does NOT check if a signature is non-malleable.
17 library ECDSA {
18     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
19     /*                        CUSTOM ERRORS                       */
20     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
21 
22     /// @dev The signature is invalid.
23     error InvalidSignature();
24 
25     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
26     /*                    RECOVERY OPERATIONS                     */
27     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
28 
29     // Note: as of Solady version 0.0.68, these functions will
30     // revert upon recovery failure for more safety by default.
31 
32     /// @dev Recovers the signer's address from a message digest `hash`,
33     /// and the `signature`.
34     ///
35     /// This function does NOT accept EIP-2098 short form signatures.
36     /// Use `recover(bytes32 hash, bytes32 r, bytes32 vs)` for EIP-2098
37     /// short form signatures instead.
38     function recover(bytes32 hash, bytes memory signature) internal view returns (address result) {
39         /// @solidity memory-safe-assembly
40         assembly {
41             let m := mload(0x40) // Cache the free memory pointer.
42             let signatureLength := mload(signature)
43             mstore(0x00, hash)
44             mstore(0x20, byte(0, mload(add(signature, 0x60)))) // `v`.
45             mstore(0x40, mload(add(signature, 0x20))) // `r`.
46             mstore(0x60, mload(add(signature, 0x40))) // `s`.
47             result :=
48                 mload(
49                     staticcall(
50                         gas(), // Amount of gas left for the transaction.
51                         eq(signatureLength, 65), // Address of `ecrecover`.
52                         0x00, // Start of input.
53                         0x80, // Size of input.
54                         0x01, // Start of output.
55                         0x20 // Size of output.
56                     )
57                 )
58             // `returndatasize()` will be `0x20` upon success, and `0x00` otherwise.
59             if iszero(returndatasize()) {
60                 mstore(0x00, 0x8baa579f) // `InvalidSignature()`.
61                 revert(0x1c, 0x04)
62             }
63             mstore(0x60, 0) // Restore the zero slot.
64             mstore(0x40, m) // Restore the free memory pointer.
65         }
66     }
67 
68     /// @dev Recovers the signer's address from a message digest `hash`,
69     /// and the `signature`.
70     ///
71     /// This function does NOT accept EIP-2098 short form signatures.
72     /// Use `recover(bytes32 hash, bytes32 r, bytes32 vs)` for EIP-2098
73     /// short form signatures instead.
74     function recoverCalldata(bytes32 hash, bytes calldata signature)
75         internal
76         view
77         returns (address result)
78     {
79         /// @solidity memory-safe-assembly
80         assembly {
81             let m := mload(0x40) // Cache the free memory pointer.
82             mstore(0x00, hash)
83             mstore(0x20, byte(0, calldataload(add(signature.offset, 0x40)))) // `v`.
84             calldatacopy(0x40, signature.offset, 0x40) // Copy `r` and `s`.
85             result :=
86                 mload(
87                     staticcall(
88                         gas(), // Amount of gas left for the transaction.
89                         eq(signature.length, 65), // Address of `ecrecover`.
90                         0x00, // Start of input.
91                         0x80, // Size of input.
92                         0x01, // Start of output.
93                         0x20 // Size of output.
94                     )
95                 )
96             // `returndatasize()` will be `0x20` upon success, and `0x00` otherwise.
97             if iszero(returndatasize()) {
98                 mstore(0x00, 0x8baa579f) // `InvalidSignature()`.
99                 revert(0x1c, 0x04)
100             }
101             mstore(0x60, 0) // Restore the zero slot.
102             mstore(0x40, m) // Restore the free memory pointer.
103         }
104     }
105 
106     /// @dev Recovers the signer's address from a message digest `hash`,
107     /// and the EIP-2098 short form signature defined by `r` and `vs`.
108     ///
109     /// This function only accepts EIP-2098 short form signatures.
110     /// See: https://eips.ethereum.org/EIPS/eip-2098
111     function recover(bytes32 hash, bytes32 r, bytes32 vs) internal view returns (address result) {
112         /// @solidity memory-safe-assembly
113         assembly {
114             let m := mload(0x40) // Cache the free memory pointer.
115             mstore(0x00, hash)
116             mstore(0x20, add(shr(255, vs), 27)) // `v`.
117             mstore(0x40, r)
118             mstore(0x60, shr(1, shl(1, vs))) // `s`.
119             result :=
120                 mload(
121                     staticcall(
122                         gas(), // Amount of gas left for the transaction.
123                         1, // Address of `ecrecover`.
124                         0x00, // Start of input.
125                         0x80, // Size of input.
126                         0x01, // Start of output.
127                         0x20 // Size of output.
128                     )
129                 )
130             // `returndatasize()` will be `0x20` upon success, and `0x00` otherwise.
131             if iszero(returndatasize()) {
132                 mstore(0x00, 0x8baa579f) // `InvalidSignature()`.
133                 revert(0x1c, 0x04)
134             }
135             mstore(0x60, 0) // Restore the zero slot.
136             mstore(0x40, m) // Restore the free memory pointer.
137         }
138     }
139 
140     /// @dev Recovers the signer's address from a message digest `hash`,
141     /// and the signature defined by `v`, `r`, `s`.
142     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s)
143         internal
144         view
145         returns (address result)
146     {
147         /// @solidity memory-safe-assembly
148         assembly {
149             let m := mload(0x40) // Cache the free memory pointer.
150             mstore(0x00, hash)
151             mstore(0x20, and(v, 0xff))
152             mstore(0x40, r)
153             mstore(0x60, s)
154             result :=
155                 mload(
156                     staticcall(
157                         gas(), // Amount of gas left for the transaction.
158                         1, // Address of `ecrecover`.
159                         0x00, // Start of input.
160                         0x80, // Size of input.
161                         0x01, // Start of output.
162                         0x20 // Size of output.
163                     )
164                 )
165             // `returndatasize()` will be `0x20` upon success, and `0x00` otherwise.
166             if iszero(returndatasize()) {
167                 mstore(0x00, 0x8baa579f) // `InvalidSignature()`.
168                 revert(0x1c, 0x04)
169             }
170             mstore(0x60, 0) // Restore the zero slot.
171             mstore(0x40, m) // Restore the free memory pointer.
172         }
173     }
174 
175     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
176     /*                   TRY-RECOVER OPERATIONS                   */
177     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
178 
179     // WARNING!
180     // These functions will NOT revert upon recovery failure.
181     // Instead, they will return the zero address upon recovery failure.
182     // It is critical that the returned address is NEVER compared against
183     // a zero address (e.g. an uninitialized address variable).
184 
185     /// @dev Recovers the signer's address from a message digest `hash`,
186     /// and the `signature`.
187     ///
188     /// This function does NOT accept EIP-2098 short form signatures.
189     /// Use `recover(bytes32 hash, bytes32 r, bytes32 vs)` for EIP-2098
190     /// short form signatures instead.
191     function tryRecover(bytes32 hash, bytes memory signature)
192         internal
193         view
194         returns (address result)
195     {
196         /// @solidity memory-safe-assembly
197         assembly {
198             let m := mload(0x40) // Cache the free memory pointer.
199             let signatureLength := mload(signature)
200             mstore(0x00, hash)
201             mstore(0x20, byte(0, mload(add(signature, 0x60)))) // `v`.
202             mstore(0x40, mload(add(signature, 0x20))) // `r`.
203             mstore(0x60, mload(add(signature, 0x40))) // `s`.
204             pop(
205                 staticcall(
206                     gas(), // Amount of gas left for the transaction.
207                     eq(signatureLength, 65), // Address of `ecrecover`.
208                     0x00, // Start of input.
209                     0x80, // Size of input.
210                     0x40, // Start of output.
211                     0x20 // Size of output.
212                 )
213             )
214             mstore(0x60, 0) // Restore the zero slot.
215             // `returndatasize()` will be `0x20` upon success, and `0x00` otherwise.
216             result := mload(xor(0x60, returndatasize()))
217             mstore(0x40, m) // Restore the free memory pointer.
218         }
219     }
220 
221     /// @dev Recovers the signer's address from a message digest `hash`,
222     /// and the `signature`.
223     ///
224     /// This function does NOT accept EIP-2098 short form signatures.
225     /// Use `recover(bytes32 hash, bytes32 r, bytes32 vs)` for EIP-2098
226     /// short form signatures instead.
227     function tryRecoverCalldata(bytes32 hash, bytes calldata signature)
228         internal
229         view
230         returns (address result)
231     {
232         /// @solidity memory-safe-assembly
233         assembly {
234             let m := mload(0x40) // Cache the free memory pointer.
235             mstore(0x00, hash)
236             mstore(0x20, byte(0, calldataload(add(signature.offset, 0x40)))) // `v`.
237             calldatacopy(0x40, signature.offset, 0x40) // Copy `r` and `s`.
238             pop(
239                 staticcall(
240                     gas(), // Amount of gas left for the transaction.
241                     eq(signature.length, 65), // Address of `ecrecover`.
242                     0x00, // Start of input.
243                     0x80, // Size of input.
244                     0x40, // Start of output.
245                     0x20 // Size of output.
246                 )
247             )
248             mstore(0x60, 0) // Restore the zero slot.
249             // `returndatasize()` will be `0x20` upon success, and `0x00` otherwise.
250             result := mload(xor(0x60, returndatasize()))
251             mstore(0x40, m) // Restore the free memory pointer.
252         }
253     }
254 
255     /// @dev Recovers the signer's address from a message digest `hash`,
256     /// and the EIP-2098 short form signature defined by `r` and `vs`.
257     ///
258     /// This function only accepts EIP-2098 short form signatures.
259     /// See: https://eips.ethereum.org/EIPS/eip-2098
260     function tryRecover(bytes32 hash, bytes32 r, bytes32 vs)
261         internal
262         view
263         returns (address result)
264     {
265         /// @solidity memory-safe-assembly
266         assembly {
267             let m := mload(0x40) // Cache the free memory pointer.
268             mstore(0x00, hash)
269             mstore(0x20, add(shr(255, vs), 27)) // `v`.
270             mstore(0x40, r)
271             mstore(0x60, shr(1, shl(1, vs))) // `s`.
272             pop(
273                 staticcall(
274                     gas(), // Amount of gas left for the transaction.
275                     1, // Address of `ecrecover`.
276                     0x00, // Start of input.
277                     0x80, // Size of input.
278                     0x40, // Start of output.
279                     0x20 // Size of output.
280                 )
281             )
282             mstore(0x60, 0) // Restore the zero slot.
283             // `returndatasize()` will be `0x20` upon success, and `0x00` otherwise.
284             result := mload(xor(0x60, returndatasize()))
285             mstore(0x40, m) // Restore the free memory pointer.
286         }
287     }
288 
289     /// @dev Recovers the signer's address from a message digest `hash`,
290     /// and the signature defined by `v`, `r`, `s`.
291     function tryRecover(bytes32 hash, uint8 v, bytes32 r, bytes32 s)
292         internal
293         view
294         returns (address result)
295     {
296         /// @solidity memory-safe-assembly
297         assembly {
298             let m := mload(0x40) // Cache the free memory pointer.
299             mstore(0x00, hash)
300             mstore(0x20, and(v, 0xff))
301             mstore(0x40, r)
302             mstore(0x60, s)
303             pop(
304                 staticcall(
305                     gas(), // Amount of gas left for the transaction.
306                     1, // Address of `ecrecover`.
307                     0x00, // Start of input.
308                     0x80, // Size of input.
309                     0x40, // Start of output.
310                     0x20 // Size of output.
311                 )
312             )
313             mstore(0x60, 0) // Restore the zero slot.
314             // `returndatasize()` will be `0x20` upon success, and `0x00` otherwise.
315             result := mload(xor(0x60, returndatasize()))
316             mstore(0x40, m) // Restore the free memory pointer.
317         }
318     }
319 
320     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
321     /*                     HASHING OPERATIONS                     */
322     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
323 
324     /// @dev Returns an Ethereum Signed Message, created from a `hash`.
325     /// This produces a hash corresponding to the one signed with the
326     /// [`eth_sign`](https://eth.wiki/json-rpc/API#eth_sign)
327     /// JSON-RPC method as part of EIP-191.
328     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32 result) {
329         /// @solidity memory-safe-assembly
330         assembly {
331             mstore(0x20, hash) // Store into scratch space for keccak256.
332             mstore(0x00, "\x00\x00\x00\x00\x19Ethereum Signed Message:\n32") // 28 bytes.
333             result := keccak256(0x04, 0x3c) // `32 * 2 - (32 - 28) = 60 = 0x3c`.
334         }
335     }
336 
337     /// @dev Returns an Ethereum Signed Message, created from `s`.
338     /// This produces a hash corresponding to the one signed with the
339     /// [`eth_sign`](https://eth.wiki/json-rpc/API#eth_sign)
340     /// JSON-RPC method as part of EIP-191.
341     /// Note: Supports lengths of `s` up to 999999 bytes.
342     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32 result) {
343         /// @solidity memory-safe-assembly
344         assembly {
345             let sLength := mload(s)
346             let o := 0x20
347             mstore(o, "\x19Ethereum Signed Message:\n") // 26 bytes, zero-right-padded.
348             mstore(0x00, 0x00)
349             // Convert the `s.length` to ASCII decimal representation: `base10(s.length)`.
350             for { let temp := sLength } 1 {} {
351                 o := sub(o, 1)
352                 mstore8(o, add(48, mod(temp, 10)))
353                 temp := div(temp, 10)
354                 if iszero(temp) { break }
355             }
356             let n := sub(0x3a, o) // Header length: `26 + 32 - o`.
357             // Throw an out-of-offset error (consumes all gas) if the header exceeds 32 bytes.
358             returndatacopy(returndatasize(), returndatasize(), gt(n, 0x20))
359             mstore(s, or(mload(0x00), mload(n))) // Temporarily store the header.
360             result := keccak256(add(s, sub(0x20, n)), add(n, sLength))
361             mstore(s, sLength) // Restore the length.
362         }
363     }
364 
365     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
366     /*                   EMPTY CALLDATA HELPERS                   */
367     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
368 
369     /// @dev Returns an empty calldata bytes.
370     function emptySignature() internal pure returns (bytes calldata signature) {
371         /// @solidity memory-safe-assembly
372         assembly {
373             signature.length := 0
374         }
375     }
376 }
377 
378 // File: solady/src/auth/Ownable.sol
379 
380 
381 pragma solidity ^0.8.4;
382 
383 /// @notice Simple single owner authorization mixin.
384 /// @author Solady (https://github.com/vectorized/solady/blob/main/src/auth/Ownable.sol)
385 ///
386 /// @dev Note:
387 /// This implementation does NOT auto-initialize the owner to `msg.sender`.
388 /// You MUST call the `_initializeOwner` in the constructor / initializer.
389 ///
390 /// While the ownable portion follows
391 /// [EIP-173](https://eips.ethereum.org/EIPS/eip-173) for compatibility,
392 /// the nomenclature for the 2-step ownership handover may be unique to this codebase.
393 abstract contract Ownable {
394     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
395     /*                       CUSTOM ERRORS                        */
396     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
397 
398     /// @dev The caller is not authorized to call the function.
399     error Unauthorized();
400 
401     /// @dev The `newOwner` cannot be the zero address.
402     error NewOwnerIsZeroAddress();
403 
404     /// @dev The `pendingOwner` does not have a valid handover request.
405     error NoHandoverRequest();
406 
407     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
408     /*                           EVENTS                           */
409     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
410 
411     /// @dev The ownership is transferred from `oldOwner` to `newOwner`.
412     /// This event is intentionally kept the same as OpenZeppelin's Ownable to be
413     /// compatible with indexers and [EIP-173](https://eips.ethereum.org/EIPS/eip-173),
414     /// despite it not being as lightweight as a single argument event.
415     event OwnershipTransferred(address indexed oldOwner, address indexed newOwner);
416 
417     /// @dev An ownership handover to `pendingOwner` has been requested.
418     event OwnershipHandoverRequested(address indexed pendingOwner);
419 
420     /// @dev The ownership handover to `pendingOwner` has been canceled.
421     event OwnershipHandoverCanceled(address indexed pendingOwner);
422 
423     /// @dev `keccak256(bytes("OwnershipTransferred(address,address)"))`.
424     uint256 private constant _OWNERSHIP_TRANSFERRED_EVENT_SIGNATURE =
425         0x8be0079c531659141344cd1fd0a4f28419497f9722a3daafe3b4186f6b6457e0;
426 
427     /// @dev `keccak256(bytes("OwnershipHandoverRequested(address)"))`.
428     uint256 private constant _OWNERSHIP_HANDOVER_REQUESTED_EVENT_SIGNATURE =
429         0xdbf36a107da19e49527a7176a1babf963b4b0ff8cde35ee35d6cd8f1f9ac7e1d;
430 
431     /// @dev `keccak256(bytes("OwnershipHandoverCanceled(address)"))`.
432     uint256 private constant _OWNERSHIP_HANDOVER_CANCELED_EVENT_SIGNATURE =
433         0xfa7b8eab7da67f412cc9575ed43464468f9bfbae89d1675917346ca6d8fe3c92;
434 
435     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
436     /*                          STORAGE                           */
437     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
438 
439     /// @dev The owner slot is given by: `not(_OWNER_SLOT_NOT)`.
440     /// It is intentionally chosen to be a high value
441     /// to avoid collision with lower slots.
442     /// The choice of manual storage layout is to enable compatibility
443     /// with both regular and upgradeable contracts.
444     uint256 private constant _OWNER_SLOT_NOT = 0x8b78c6d8;
445 
446     /// The ownership handover slot of `newOwner` is given by:
447     /// ```
448     ///     mstore(0x00, or(shl(96, user), _HANDOVER_SLOT_SEED))
449     ///     let handoverSlot := keccak256(0x00, 0x20)
450     /// ```
451     /// It stores the expiry timestamp of the two-step ownership handover.
452     uint256 private constant _HANDOVER_SLOT_SEED = 0x389a75e1;
453 
454     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
455     /*                     INTERNAL FUNCTIONS                     */
456     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
457 
458     /// @dev Initializes the owner directly without authorization guard.
459     /// This function must be called upon initialization,
460     /// regardless of whether the contract is upgradeable or not.
461     /// This is to enable generalization to both regular and upgradeable contracts,
462     /// and to save gas in case the initial owner is not the caller.
463     /// For performance reasons, this function will not check if there
464     /// is an existing owner.
465     function _initializeOwner(address newOwner) internal virtual {
466         /// @solidity memory-safe-assembly
467         assembly {
468             // Clean the upper 96 bits.
469             newOwner := shr(96, shl(96, newOwner))
470             // Store the new value.
471             sstore(not(_OWNER_SLOT_NOT), newOwner)
472             // Emit the {OwnershipTransferred} event.
473             log3(0, 0, _OWNERSHIP_TRANSFERRED_EVENT_SIGNATURE, 0, newOwner)
474         }
475     }
476 
477     /// @dev Sets the owner directly without authorization guard.
478     function _setOwner(address newOwner) internal virtual {
479         /// @solidity memory-safe-assembly
480         assembly {
481             let ownerSlot := not(_OWNER_SLOT_NOT)
482             // Clean the upper 96 bits.
483             newOwner := shr(96, shl(96, newOwner))
484             // Emit the {OwnershipTransferred} event.
485             log3(0, 0, _OWNERSHIP_TRANSFERRED_EVENT_SIGNATURE, sload(ownerSlot), newOwner)
486             // Store the new value.
487             sstore(ownerSlot, newOwner)
488         }
489     }
490 
491     /// @dev Throws if the sender is not the owner.
492     function _checkOwner() internal view virtual {
493         /// @solidity memory-safe-assembly
494         assembly {
495             // If the caller is not the stored owner, revert.
496             if iszero(eq(caller(), sload(not(_OWNER_SLOT_NOT)))) {
497                 mstore(0x00, 0x82b42900) // `Unauthorized()`.
498                 revert(0x1c, 0x04)
499             }
500         }
501     }
502 
503     /// @dev Returns how long a two-step ownership handover is valid for in seconds.
504     /// Override to return a different value if needed.
505     /// Made internal to conserve bytecode. Wrap it in a public function if needed.
506     function _ownershipHandoverValidFor() internal view virtual returns (uint64) {
507         return 48 * 3600;
508     }
509 
510     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
511     /*                  PUBLIC UPDATE FUNCTIONS                   */
512     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
513 
514     /// @dev Allows the owner to transfer the ownership to `newOwner`.
515     function transferOwnership(address newOwner) public payable virtual onlyOwner {
516         /// @solidity memory-safe-assembly
517         assembly {
518             if iszero(shl(96, newOwner)) {
519                 mstore(0x00, 0x7448fbae) // `NewOwnerIsZeroAddress()`.
520                 revert(0x1c, 0x04)
521             }
522         }
523         _setOwner(newOwner);
524     }
525 
526     /// @dev Allows the owner to renounce their ownership.
527     function renounceOwnership() public payable virtual onlyOwner {
528         _setOwner(address(0));
529     }
530 
531     /// @dev Request a two-step ownership handover to the caller.
532     /// The request will automatically expire in 48 hours (172800 seconds) by default.
533     function requestOwnershipHandover() public payable virtual {
534         unchecked {
535             uint256 expires = block.timestamp + _ownershipHandoverValidFor();
536             /// @solidity memory-safe-assembly
537             assembly {
538                 // Compute and set the handover slot to `expires`.
539                 mstore(0x0c, _HANDOVER_SLOT_SEED)
540                 mstore(0x00, caller())
541                 sstore(keccak256(0x0c, 0x20), expires)
542                 // Emit the {OwnershipHandoverRequested} event.
543                 log2(0, 0, _OWNERSHIP_HANDOVER_REQUESTED_EVENT_SIGNATURE, caller())
544             }
545         }
546     }
547 
548     /// @dev Cancels the two-step ownership handover to the caller, if any.
549     function cancelOwnershipHandover() public payable virtual {
550         /// @solidity memory-safe-assembly
551         assembly {
552             // Compute and set the handover slot to 0.
553             mstore(0x0c, _HANDOVER_SLOT_SEED)
554             mstore(0x00, caller())
555             sstore(keccak256(0x0c, 0x20), 0)
556             // Emit the {OwnershipHandoverCanceled} event.
557             log2(0, 0, _OWNERSHIP_HANDOVER_CANCELED_EVENT_SIGNATURE, caller())
558         }
559     }
560 
561     /// @dev Allows the owner to complete the two-step ownership handover to `pendingOwner`.
562     /// Reverts if there is no existing ownership handover requested by `pendingOwner`.
563     function completeOwnershipHandover(address pendingOwner) public payable virtual onlyOwner {
564         /// @solidity memory-safe-assembly
565         assembly {
566             // Compute and set the handover slot to 0.
567             mstore(0x0c, _HANDOVER_SLOT_SEED)
568             mstore(0x00, pendingOwner)
569             let handoverSlot := keccak256(0x0c, 0x20)
570             // If the handover does not exist, or has expired.
571             if gt(timestamp(), sload(handoverSlot)) {
572                 mstore(0x00, 0x6f5e8818) // `NoHandoverRequest()`.
573                 revert(0x1c, 0x04)
574             }
575             // Set the handover slot to 0.
576             sstore(handoverSlot, 0)
577         }
578         _setOwner(pendingOwner);
579     }
580 
581     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
582     /*                   PUBLIC READ FUNCTIONS                    */
583     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
584 
585     /// @dev Returns the owner of the contract.
586     function owner() public view virtual returns (address result) {
587         /// @solidity memory-safe-assembly
588         assembly {
589             result := sload(not(_OWNER_SLOT_NOT))
590         }
591     }
592 
593     /// @dev Returns the expiry timestamp for the two-step ownership handover to `pendingOwner`.
594     function ownershipHandoverExpiresAt(address pendingOwner)
595         public
596         view
597         virtual
598         returns (uint256 result)
599     {
600         /// @solidity memory-safe-assembly
601         assembly {
602             // Compute the handover slot.
603             mstore(0x0c, _HANDOVER_SLOT_SEED)
604             mstore(0x00, pendingOwner)
605             // Load the handover slot.
606             result := sload(keccak256(0x0c, 0x20))
607         }
608     }
609 
610     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
611     /*                         MODIFIERS                          */
612     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
613 
614     /// @dev Marks a function as only callable by the owner.
615     modifier onlyOwner() virtual {
616         _checkOwner();
617         _;
618     }
619 }
620 
621 // File: erc721a/contracts/IERC721A.sol
622 
623 
624 // ERC721A Contracts v4.2.3
625 // Creator: Chiru Labs
626 
627 pragma solidity ^0.8.4;
628 
629 /**
630  * @dev Interface of ERC721A.
631  */
632 interface IERC721A {
633     /**
634      * The caller must own the token or be an approved operator.
635      */
636     error ApprovalCallerNotOwnerNorApproved();
637 
638     /**
639      * The token does not exist.
640      */
641     error ApprovalQueryForNonexistentToken();
642 
643     /**
644      * Cannot query the balance for the zero address.
645      */
646     error BalanceQueryForZeroAddress();
647 
648     /**
649      * Cannot mint to the zero address.
650      */
651     error MintToZeroAddress();
652 
653     /**
654      * The quantity of tokens minted must be more than zero.
655      */
656     error MintZeroQuantity();
657 
658     /**
659      * The token does not exist.
660      */
661     error OwnerQueryForNonexistentToken();
662 
663     /**
664      * The caller must own the token or be an approved operator.
665      */
666     error TransferCallerNotOwnerNorApproved();
667 
668     /**
669      * The token must be owned by `from`.
670      */
671     error TransferFromIncorrectOwner();
672 
673     /**
674      * Cannot safely transfer to a contract that does not implement the
675      * ERC721Receiver interface.
676      */
677     error TransferToNonERC721ReceiverImplementer();
678 
679     /**
680      * Cannot transfer to the zero address.
681      */
682     error TransferToZeroAddress();
683 
684     /**
685      * The token does not exist.
686      */
687     error URIQueryForNonexistentToken();
688 
689     /**
690      * The `quantity` minted with ERC2309 exceeds the safety limit.
691      */
692     error MintERC2309QuantityExceedsLimit();
693 
694     /**
695      * The `extraData` cannot be set on an unintialized ownership slot.
696      */
697     error OwnershipNotInitializedForExtraData();
698 
699     // =============================================================
700     //                            STRUCTS
701     // =============================================================
702 
703     struct TokenOwnership {
704         // The address of the owner.
705         address addr;
706         // Stores the start time of ownership with minimal overhead for tokenomics.
707         uint64 startTimestamp;
708         // Whether the token has been burned.
709         bool burned;
710         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
711         uint24 extraData;
712     }
713 
714     // =============================================================
715     //                         TOKEN COUNTERS
716     // =============================================================
717 
718     /**
719      * @dev Returns the total number of tokens in existence.
720      * Burned tokens will reduce the count.
721      * To get the total number of tokens minted, please see {_totalMinted}.
722      */
723     function totalSupply() external view returns (uint256);
724 
725     // =============================================================
726     //                            IERC165
727     // =============================================================
728 
729     /**
730      * @dev Returns true if this contract implements the interface defined by
731      * `interfaceId`. See the corresponding
732      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
733      * to learn more about how these ids are created.
734      *
735      * This function call must use less than 30000 gas.
736      */
737     function supportsInterface(bytes4 interfaceId) external view returns (bool);
738 
739     // =============================================================
740     //                            IERC721
741     // =============================================================
742 
743     /**
744      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
745      */
746     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
747 
748     /**
749      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
750      */
751     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
752 
753     /**
754      * @dev Emitted when `owner` enables or disables
755      * (`approved`) `operator` to manage all of its assets.
756      */
757     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
758 
759     /**
760      * @dev Returns the number of tokens in `owner`'s account.
761      */
762     function balanceOf(address owner) external view returns (uint256 balance);
763 
764     /**
765      * @dev Returns the owner of the `tokenId` token.
766      *
767      * Requirements:
768      *
769      * - `tokenId` must exist.
770      */
771     function ownerOf(uint256 tokenId) external view returns (address owner);
772 
773     /**
774      * @dev Safely transfers `tokenId` token from `from` to `to`,
775      * checking first that contract recipients are aware of the ERC721 protocol
776      * to prevent tokens from being forever locked.
777      *
778      * Requirements:
779      *
780      * - `from` cannot be the zero address.
781      * - `to` cannot be the zero address.
782      * - `tokenId` token must exist and be owned by `from`.
783      * - If the caller is not `from`, it must be have been allowed to move
784      * this token by either {approve} or {setApprovalForAll}.
785      * - If `to` refers to a smart contract, it must implement
786      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
787      *
788      * Emits a {Transfer} event.
789      */
790     function safeTransferFrom(
791         address from,
792         address to,
793         uint256 tokenId,
794         bytes calldata data
795     ) external payable;
796 
797     /**
798      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
799      */
800     function safeTransferFrom(
801         address from,
802         address to,
803         uint256 tokenId
804     ) external payable;
805 
806     /**
807      * @dev Transfers `tokenId` from `from` to `to`.
808      *
809      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
810      * whenever possible.
811      *
812      * Requirements:
813      *
814      * - `from` cannot be the zero address.
815      * - `to` cannot be the zero address.
816      * - `tokenId` token must be owned by `from`.
817      * - If the caller is not `from`, it must be approved to move this token
818      * by either {approve} or {setApprovalForAll}.
819      *
820      * Emits a {Transfer} event.
821      */
822     function transferFrom(
823         address from,
824         address to,
825         uint256 tokenId
826     ) external payable;
827 
828     /**
829      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
830      * The approval is cleared when the token is transferred.
831      *
832      * Only a single account can be approved at a time, so approving the
833      * zero address clears previous approvals.
834      *
835      * Requirements:
836      *
837      * - The caller must own the token or be an approved operator.
838      * - `tokenId` must exist.
839      *
840      * Emits an {Approval} event.
841      */
842     function approve(address to, uint256 tokenId) external payable;
843 
844     /**
845      * @dev Approve or remove `operator` as an operator for the caller.
846      * Operators can call {transferFrom} or {safeTransferFrom}
847      * for any token owned by the caller.
848      *
849      * Requirements:
850      *
851      * - The `operator` cannot be the caller.
852      *
853      * Emits an {ApprovalForAll} event.
854      */
855     function setApprovalForAll(address operator, bool _approved) external;
856 
857     /**
858      * @dev Returns the account approved for `tokenId` token.
859      *
860      * Requirements:
861      *
862      * - `tokenId` must exist.
863      */
864     function getApproved(uint256 tokenId) external view returns (address operator);
865 
866     /**
867      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
868      *
869      * See {setApprovalForAll}.
870      */
871     function isApprovedForAll(address owner, address operator) external view returns (bool);
872 
873     // =============================================================
874     //                        IERC721Metadata
875     // =============================================================
876 
877     /**
878      * @dev Returns the token collection name.
879      */
880     function name() external view returns (string memory);
881 
882     /**
883      * @dev Returns the token collection symbol.
884      */
885     function symbol() external view returns (string memory);
886 
887     /**
888      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
889      */
890     function tokenURI(uint256 tokenId) external view returns (string memory);
891 
892     // =============================================================
893     //                           IERC2309
894     // =============================================================
895 
896     /**
897      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
898      * (inclusive) is transferred from `from` to `to`, as defined in the
899      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
900      *
901      * See {_mintERC2309} for more details.
902      */
903     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
904 }
905 
906 // File: erc721a/contracts/ERC721A.sol
907 
908 
909 // ERC721A Contracts v4.2.3
910 // Creator: Chiru Labs
911 
912 pragma solidity ^0.8.4;
913 
914 
915 /**
916  * @dev Interface of ERC721 token receiver.
917  */
918 interface ERC721A__IERC721Receiver {
919     function onERC721Received(
920         address operator,
921         address from,
922         uint256 tokenId,
923         bytes calldata data
924     ) external returns (bytes4);
925 }
926 
927 /**
928  * @title ERC721A
929  *
930  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
931  * Non-Fungible Token Standard, including the Metadata extension.
932  * Optimized for lower gas during batch mints.
933  *
934  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
935  * starting from `_startTokenId()`.
936  *
937  * Assumptions:
938  *
939  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
940  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
941  */
942 contract ERC721A is IERC721A {
943     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
944     struct TokenApprovalRef {
945         address value;
946     }
947 
948     // =============================================================
949     //                           CONSTANTS
950     // =============================================================
951 
952     // Mask of an entry in packed address data.
953     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
954 
955     // The bit position of `numberMinted` in packed address data.
956     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
957 
958     // The bit position of `numberBurned` in packed address data.
959     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
960 
961     // The bit position of `aux` in packed address data.
962     uint256 private constant _BITPOS_AUX = 192;
963 
964     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
965     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
966 
967     // The bit position of `startTimestamp` in packed ownership.
968     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
969 
970     // The bit mask of the `burned` bit in packed ownership.
971     uint256 private constant _BITMASK_BURNED = 1 << 224;
972 
973     // The bit position of the `nextInitialized` bit in packed ownership.
974     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
975 
976     // The bit mask of the `nextInitialized` bit in packed ownership.
977     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
978 
979     // The bit position of `extraData` in packed ownership.
980     uint256 private constant _BITPOS_EXTRA_DATA = 232;
981 
982     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
983     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
984 
985     // The mask of the lower 160 bits for addresses.
986     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
987 
988     // The maximum `quantity` that can be minted with {_mintERC2309}.
989     // This limit is to prevent overflows on the address data entries.
990     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
991     // is required to cause an overflow, which is unrealistic.
992     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
993 
994     // The `Transfer` event signature is given by:
995     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
996     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
997         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
998 
999     // =============================================================
1000     //                            STORAGE
1001     // =============================================================
1002 
1003     // The next token ID to be minted.
1004     uint256 private _currentIndex;
1005 
1006     // The number of tokens burned.
1007     uint256 private _burnCounter;
1008 
1009     // Token name
1010     string private _name;
1011 
1012     // Token symbol
1013     string private _symbol;
1014 
1015     // Mapping from token ID to ownership details
1016     // An empty struct value does not necessarily mean the token is unowned.
1017     // See {_packedOwnershipOf} implementation for details.
1018     //
1019     // Bits Layout:
1020     // - [0..159]   `addr`
1021     // - [160..223] `startTimestamp`
1022     // - [224]      `burned`
1023     // - [225]      `nextInitialized`
1024     // - [232..255] `extraData`
1025     mapping(uint256 => uint256) private _packedOwnerships;
1026 
1027     // Mapping owner address to address data.
1028     //
1029     // Bits Layout:
1030     // - [0..63]    `balance`
1031     // - [64..127]  `numberMinted`
1032     // - [128..191] `numberBurned`
1033     // - [192..255] `aux`
1034     mapping(address => uint256) private _packedAddressData;
1035 
1036     // Mapping from token ID to approved address.
1037     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1038 
1039     // Mapping from owner to operator approvals
1040     mapping(address => mapping(address => bool)) private _operatorApprovals;
1041 
1042     // =============================================================
1043     //                          CONSTRUCTOR
1044     // =============================================================
1045 
1046     constructor(string memory name_, string memory symbol_) {
1047         _name = name_;
1048         _symbol = symbol_;
1049         _currentIndex = _startTokenId();
1050     }
1051 
1052     // =============================================================
1053     //                   TOKEN COUNTING OPERATIONS
1054     // =============================================================
1055 
1056     /**
1057      * @dev Returns the starting token ID.
1058      * To change the starting token ID, please override this function.
1059      */
1060     function _startTokenId() internal view virtual returns (uint256) {
1061         return 0;
1062     }
1063 
1064     /**
1065      * @dev Returns the next token ID to be minted.
1066      */
1067     function _nextTokenId() internal view virtual returns (uint256) {
1068         return _currentIndex;
1069     }
1070 
1071     /**
1072      * @dev Returns the total number of tokens in existence.
1073      * Burned tokens will reduce the count.
1074      * To get the total number of tokens minted, please see {_totalMinted}.
1075      */
1076     function totalSupply() public view virtual override returns (uint256) {
1077         // Counter underflow is impossible as _burnCounter cannot be incremented
1078         // more than `_currentIndex - _startTokenId()` times.
1079         unchecked {
1080             return _currentIndex - _burnCounter - _startTokenId();
1081         }
1082     }
1083 
1084     /**
1085      * @dev Returns the total amount of tokens minted in the contract.
1086      */
1087     function _totalMinted() internal view virtual returns (uint256) {
1088         // Counter underflow is impossible as `_currentIndex` does not decrement,
1089         // and it is initialized to `_startTokenId()`.
1090         unchecked {
1091             return _currentIndex - _startTokenId();
1092         }
1093     }
1094 
1095     /**
1096      * @dev Returns the total number of tokens burned.
1097      */
1098     function _totalBurned() internal view virtual returns (uint256) {
1099         return _burnCounter;
1100     }
1101 
1102     // =============================================================
1103     //                    ADDRESS DATA OPERATIONS
1104     // =============================================================
1105 
1106     /**
1107      * @dev Returns the number of tokens in `owner`'s account.
1108      */
1109     function balanceOf(address owner) public view virtual override returns (uint256) {
1110         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1111         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1112     }
1113 
1114     /**
1115      * Returns the number of tokens minted by `owner`.
1116      */
1117     function _numberMinted(address owner) internal view returns (uint256) {
1118         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1119     }
1120 
1121     /**
1122      * Returns the number of tokens burned by or on behalf of `owner`.
1123      */
1124     function _numberBurned(address owner) internal view returns (uint256) {
1125         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1126     }
1127 
1128     /**
1129      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1130      */
1131     function _getAux(address owner) internal view returns (uint64) {
1132         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1133     }
1134 
1135     /**
1136      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1137      * If there are multiple variables, please pack them into a uint64.
1138      */
1139     function _setAux(address owner, uint64 aux) internal virtual {
1140         uint256 packed = _packedAddressData[owner];
1141         uint256 auxCasted;
1142         // Cast `aux` with assembly to avoid redundant masking.
1143         assembly {
1144             auxCasted := aux
1145         }
1146         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1147         _packedAddressData[owner] = packed;
1148     }
1149 
1150     // =============================================================
1151     //                            IERC165
1152     // =============================================================
1153 
1154     /**
1155      * @dev Returns true if this contract implements the interface defined by
1156      * `interfaceId`. See the corresponding
1157      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1158      * to learn more about how these ids are created.
1159      *
1160      * This function call must use less than 30000 gas.
1161      */
1162     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1163         // The interface IDs are constants representing the first 4 bytes
1164         // of the XOR of all function selectors in the interface.
1165         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1166         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1167         return
1168             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1169             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1170             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1171     }
1172 
1173     // =============================================================
1174     //                        IERC721Metadata
1175     // =============================================================
1176 
1177     /**
1178      * @dev Returns the token collection name.
1179      */
1180     function name() public view virtual override returns (string memory) {
1181         return _name;
1182     }
1183 
1184     /**
1185      * @dev Returns the token collection symbol.
1186      */
1187     function symbol() public view virtual override returns (string memory) {
1188         return _symbol;
1189     }
1190 
1191     /**
1192      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1193      */
1194     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1195         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1196 
1197         string memory baseURI = _baseURI();
1198         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1199     }
1200 
1201     /**
1202      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1203      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1204      * by default, it can be overridden in child contracts.
1205      */
1206     function _baseURI() internal view virtual returns (string memory) {
1207         return '';
1208     }
1209 
1210     // =============================================================
1211     //                     OWNERSHIPS OPERATIONS
1212     // =============================================================
1213 
1214     /**
1215      * @dev Returns the owner of the `tokenId` token.
1216      *
1217      * Requirements:
1218      *
1219      * - `tokenId` must exist.
1220      */
1221     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1222         return address(uint160(_packedOwnershipOf(tokenId)));
1223     }
1224 
1225     /**
1226      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1227      * It gradually moves to O(1) as tokens get transferred around over time.
1228      */
1229     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1230         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1231     }
1232 
1233     /**
1234      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1235      */
1236     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1237         return _unpackedOwnership(_packedOwnerships[index]);
1238     }
1239 
1240     /**
1241      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1242      */
1243     function _initializeOwnershipAt(uint256 index) internal virtual {
1244         if (_packedOwnerships[index] == 0) {
1245             _packedOwnerships[index] = _packedOwnershipOf(index);
1246         }
1247     }
1248 
1249     /**
1250      * Returns the packed ownership data of `tokenId`.
1251      */
1252     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1253         uint256 curr = tokenId;
1254 
1255         unchecked {
1256             if (_startTokenId() <= curr)
1257                 if (curr < _currentIndex) {
1258                     uint256 packed = _packedOwnerships[curr];
1259                     // If not burned.
1260                     if (packed & _BITMASK_BURNED == 0) {
1261                         // Invariant:
1262                         // There will always be an initialized ownership slot
1263                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1264                         // before an unintialized ownership slot
1265                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1266                         // Hence, `curr` will not underflow.
1267                         //
1268                         // We can directly compare the packed value.
1269                         // If the address is zero, packed will be zero.
1270                         while (packed == 0) {
1271                             packed = _packedOwnerships[--curr];
1272                         }
1273                         return packed;
1274                     }
1275                 }
1276         }
1277         revert OwnerQueryForNonexistentToken();
1278     }
1279 
1280     /**
1281      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1282      */
1283     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1284         ownership.addr = address(uint160(packed));
1285         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1286         ownership.burned = packed & _BITMASK_BURNED != 0;
1287         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1288     }
1289 
1290     /**
1291      * @dev Packs ownership data into a single uint256.
1292      */
1293     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1294         assembly {
1295             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1296             owner := and(owner, _BITMASK_ADDRESS)
1297             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1298             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1299         }
1300     }
1301 
1302     /**
1303      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1304      */
1305     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1306         // For branchless setting of the `nextInitialized` flag.
1307         assembly {
1308             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1309             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1310         }
1311     }
1312 
1313     // =============================================================
1314     //                      APPROVAL OPERATIONS
1315     // =============================================================
1316 
1317     /**
1318      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1319      * The approval is cleared when the token is transferred.
1320      *
1321      * Only a single account can be approved at a time, so approving the
1322      * zero address clears previous approvals.
1323      *
1324      * Requirements:
1325      *
1326      * - The caller must own the token or be an approved operator.
1327      * - `tokenId` must exist.
1328      *
1329      * Emits an {Approval} event.
1330      */
1331     function approve(address to, uint256 tokenId) public payable virtual override {
1332         address owner = ownerOf(tokenId);
1333 
1334         if (_msgSenderERC721A() != owner)
1335             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1336                 revert ApprovalCallerNotOwnerNorApproved();
1337             }
1338 
1339         _tokenApprovals[tokenId].value = to;
1340         emit Approval(owner, to, tokenId);
1341     }
1342 
1343     /**
1344      * @dev Returns the account approved for `tokenId` token.
1345      *
1346      * Requirements:
1347      *
1348      * - `tokenId` must exist.
1349      */
1350     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1351         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1352 
1353         return _tokenApprovals[tokenId].value;
1354     }
1355 
1356     /**
1357      * @dev Approve or remove `operator` as an operator for the caller.
1358      * Operators can call {transferFrom} or {safeTransferFrom}
1359      * for any token owned by the caller.
1360      *
1361      * Requirements:
1362      *
1363      * - The `operator` cannot be the caller.
1364      *
1365      * Emits an {ApprovalForAll} event.
1366      */
1367     function setApprovalForAll(address operator, bool approved) public virtual override {
1368         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1369         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1370     }
1371 
1372     /**
1373      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1374      *
1375      * See {setApprovalForAll}.
1376      */
1377     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1378         return _operatorApprovals[owner][operator];
1379     }
1380 
1381     /**
1382      * @dev Returns whether `tokenId` exists.
1383      *
1384      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1385      *
1386      * Tokens start existing when they are minted. See {_mint}.
1387      */
1388     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1389         return
1390             _startTokenId() <= tokenId &&
1391             tokenId < _currentIndex && // If within bounds,
1392             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1393     }
1394 
1395     /**
1396      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1397      */
1398     function _isSenderApprovedOrOwner(
1399         address approvedAddress,
1400         address owner,
1401         address msgSender
1402     ) private pure returns (bool result) {
1403         assembly {
1404             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1405             owner := and(owner, _BITMASK_ADDRESS)
1406             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1407             msgSender := and(msgSender, _BITMASK_ADDRESS)
1408             // `msgSender == owner || msgSender == approvedAddress`.
1409             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1410         }
1411     }
1412 
1413     /**
1414      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1415      */
1416     function _getApprovedSlotAndAddress(uint256 tokenId)
1417         private
1418         view
1419         returns (uint256 approvedAddressSlot, address approvedAddress)
1420     {
1421         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1422         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
1423         assembly {
1424             approvedAddressSlot := tokenApproval.slot
1425             approvedAddress := sload(approvedAddressSlot)
1426         }
1427     }
1428 
1429     // =============================================================
1430     //                      TRANSFER OPERATIONS
1431     // =============================================================
1432 
1433     /**
1434      * @dev Transfers `tokenId` from `from` to `to`.
1435      *
1436      * Requirements:
1437      *
1438      * - `from` cannot be the zero address.
1439      * - `to` cannot be the zero address.
1440      * - `tokenId` token must be owned by `from`.
1441      * - If the caller is not `from`, it must be approved to move this token
1442      * by either {approve} or {setApprovalForAll}.
1443      *
1444      * Emits a {Transfer} event.
1445      */
1446     function transferFrom(
1447         address from,
1448         address to,
1449         uint256 tokenId
1450     ) public payable virtual override {
1451         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1452 
1453         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1454 
1455         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1456 
1457         // The nested ifs save around 20+ gas over a compound boolean condition.
1458         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1459             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1460 
1461         if (to == address(0)) revert TransferToZeroAddress();
1462 
1463         _beforeTokenTransfers(from, to, tokenId, 1);
1464 
1465         // Clear approvals from the previous owner.
1466         assembly {
1467             if approvedAddress {
1468                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1469                 sstore(approvedAddressSlot, 0)
1470             }
1471         }
1472 
1473         // Underflow of the sender's balance is impossible because we check for
1474         // ownership above and the recipient's balance can't realistically overflow.
1475         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1476         unchecked {
1477             // We can directly increment and decrement the balances.
1478             --_packedAddressData[from]; // Updates: `balance -= 1`.
1479             ++_packedAddressData[to]; // Updates: `balance += 1`.
1480 
1481             // Updates:
1482             // - `address` to the next owner.
1483             // - `startTimestamp` to the timestamp of transfering.
1484             // - `burned` to `false`.
1485             // - `nextInitialized` to `true`.
1486             _packedOwnerships[tokenId] = _packOwnershipData(
1487                 to,
1488                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1489             );
1490 
1491             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1492             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1493                 uint256 nextTokenId = tokenId + 1;
1494                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1495                 if (_packedOwnerships[nextTokenId] == 0) {
1496                     // If the next slot is within bounds.
1497                     if (nextTokenId != _currentIndex) {
1498                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1499                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1500                     }
1501                 }
1502             }
1503         }
1504 
1505         emit Transfer(from, to, tokenId);
1506         _afterTokenTransfers(from, to, tokenId, 1);
1507     }
1508 
1509     /**
1510      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1511      */
1512     function safeTransferFrom(
1513         address from,
1514         address to,
1515         uint256 tokenId
1516     ) public payable virtual override {
1517         safeTransferFrom(from, to, tokenId, '');
1518     }
1519 
1520     /**
1521      * @dev Safely transfers `tokenId` token from `from` to `to`.
1522      *
1523      * Requirements:
1524      *
1525      * - `from` cannot be the zero address.
1526      * - `to` cannot be the zero address.
1527      * - `tokenId` token must exist and be owned by `from`.
1528      * - If the caller is not `from`, it must be approved to move this token
1529      * by either {approve} or {setApprovalForAll}.
1530      * - If `to` refers to a smart contract, it must implement
1531      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1532      *
1533      * Emits a {Transfer} event.
1534      */
1535     function safeTransferFrom(
1536         address from,
1537         address to,
1538         uint256 tokenId,
1539         bytes memory _data
1540     ) public payable virtual override {
1541         transferFrom(from, to, tokenId);
1542         if (to.code.length != 0)
1543             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1544                 revert TransferToNonERC721ReceiverImplementer();
1545             }
1546     }
1547 
1548     /**
1549      * @dev Hook that is called before a set of serially-ordered token IDs
1550      * are about to be transferred. This includes minting.
1551      * And also called before burning one token.
1552      *
1553      * `startTokenId` - the first token ID to be transferred.
1554      * `quantity` - the amount to be transferred.
1555      *
1556      * Calling conditions:
1557      *
1558      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1559      * transferred to `to`.
1560      * - When `from` is zero, `tokenId` will be minted for `to`.
1561      * - When `to` is zero, `tokenId` will be burned by `from`.
1562      * - `from` and `to` are never both zero.
1563      */
1564     function _beforeTokenTransfers(
1565         address from,
1566         address to,
1567         uint256 startTokenId,
1568         uint256 quantity
1569     ) internal virtual {}
1570 
1571     /**
1572      * @dev Hook that is called after a set of serially-ordered token IDs
1573      * have been transferred. This includes minting.
1574      * And also called after one token has been burned.
1575      *
1576      * `startTokenId` - the first token ID to be transferred.
1577      * `quantity` - the amount to be transferred.
1578      *
1579      * Calling conditions:
1580      *
1581      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1582      * transferred to `to`.
1583      * - When `from` is zero, `tokenId` has been minted for `to`.
1584      * - When `to` is zero, `tokenId` has been burned by `from`.
1585      * - `from` and `to` are never both zero.
1586      */
1587     function _afterTokenTransfers(
1588         address from,
1589         address to,
1590         uint256 startTokenId,
1591         uint256 quantity
1592     ) internal virtual {}
1593 
1594     /**
1595      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1596      *
1597      * `from` - Previous owner of the given token ID.
1598      * `to` - Target address that will receive the token.
1599      * `tokenId` - Token ID to be transferred.
1600      * `_data` - Optional data to send along with the call.
1601      *
1602      * Returns whether the call correctly returned the expected magic value.
1603      */
1604     function _checkContractOnERC721Received(
1605         address from,
1606         address to,
1607         uint256 tokenId,
1608         bytes memory _data
1609     ) private returns (bool) {
1610         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1611             bytes4 retval
1612         ) {
1613             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1614         } catch (bytes memory reason) {
1615             if (reason.length == 0) {
1616                 revert TransferToNonERC721ReceiverImplementer();
1617             } else {
1618                 assembly {
1619                     revert(add(32, reason), mload(reason))
1620                 }
1621             }
1622         }
1623     }
1624 
1625     // =============================================================
1626     //                        MINT OPERATIONS
1627     // =============================================================
1628 
1629     /**
1630      * @dev Mints `quantity` tokens and transfers them to `to`.
1631      *
1632      * Requirements:
1633      *
1634      * - `to` cannot be the zero address.
1635      * - `quantity` must be greater than 0.
1636      *
1637      * Emits a {Transfer} event for each mint.
1638      */
1639     function _mint(address to, uint256 quantity) internal virtual {
1640         uint256 startTokenId = _currentIndex;
1641         if (quantity == 0) revert MintZeroQuantity();
1642 
1643         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1644 
1645         // Overflows are incredibly unrealistic.
1646         // `balance` and `numberMinted` have a maximum limit of 2**64.
1647         // `tokenId` has a maximum limit of 2**256.
1648         unchecked {
1649             // Updates:
1650             // - `balance += quantity`.
1651             // - `numberMinted += quantity`.
1652             //
1653             // We can directly add to the `balance` and `numberMinted`.
1654             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1655 
1656             // Updates:
1657             // - `address` to the owner.
1658             // - `startTimestamp` to the timestamp of minting.
1659             // - `burned` to `false`.
1660             // - `nextInitialized` to `quantity == 1`.
1661             _packedOwnerships[startTokenId] = _packOwnershipData(
1662                 to,
1663                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1664             );
1665 
1666             uint256 toMasked;
1667             uint256 end = startTokenId + quantity;
1668 
1669             // Use assembly to loop and emit the `Transfer` event for gas savings.
1670             // The duplicated `log4` removes an extra check and reduces stack juggling.
1671             // The assembly, together with the surrounding Solidity code, have been
1672             // delicately arranged to nudge the compiler into producing optimized opcodes.
1673             assembly {
1674                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1675                 toMasked := and(to, _BITMASK_ADDRESS)
1676                 // Emit the `Transfer` event.
1677                 log4(
1678                     0, // Start of data (0, since no data).
1679                     0, // End of data (0, since no data).
1680                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1681                     0, // `address(0)`.
1682                     toMasked, // `to`.
1683                     startTokenId // `tokenId`.
1684                 )
1685 
1686                 // The `iszero(eq(,))` check ensures that large values of `quantity`
1687                 // that overflows uint256 will make the loop run out of gas.
1688                 // The compiler will optimize the `iszero` away for performance.
1689                 for {
1690                     let tokenId := add(startTokenId, 1)
1691                 } iszero(eq(tokenId, end)) {
1692                     tokenId := add(tokenId, 1)
1693                 } {
1694                     // Emit the `Transfer` event. Similar to above.
1695                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1696                 }
1697             }
1698             if (toMasked == 0) revert MintToZeroAddress();
1699 
1700             _currentIndex = end;
1701         }
1702         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1703     }
1704 
1705     /**
1706      * @dev Mints `quantity` tokens and transfers them to `to`.
1707      *
1708      * This function is intended for efficient minting only during contract creation.
1709      *
1710      * It emits only one {ConsecutiveTransfer} as defined in
1711      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1712      * instead of a sequence of {Transfer} event(s).
1713      *
1714      * Calling this function outside of contract creation WILL make your contract
1715      * non-compliant with the ERC721 standard.
1716      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1717      * {ConsecutiveTransfer} event is only permissible during contract creation.
1718      *
1719      * Requirements:
1720      *
1721      * - `to` cannot be the zero address.
1722      * - `quantity` must be greater than 0.
1723      *
1724      * Emits a {ConsecutiveTransfer} event.
1725      */
1726     function _mintERC2309(address to, uint256 quantity) internal virtual {
1727         uint256 startTokenId = _currentIndex;
1728         if (to == address(0)) revert MintToZeroAddress();
1729         if (quantity == 0) revert MintZeroQuantity();
1730         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1731 
1732         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1733 
1734         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1735         unchecked {
1736             // Updates:
1737             // - `balance += quantity`.
1738             // - `numberMinted += quantity`.
1739             //
1740             // We can directly add to the `balance` and `numberMinted`.
1741             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1742 
1743             // Updates:
1744             // - `address` to the owner.
1745             // - `startTimestamp` to the timestamp of minting.
1746             // - `burned` to `false`.
1747             // - `nextInitialized` to `quantity == 1`.
1748             _packedOwnerships[startTokenId] = _packOwnershipData(
1749                 to,
1750                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1751             );
1752 
1753             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1754 
1755             _currentIndex = startTokenId + quantity;
1756         }
1757         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1758     }
1759 
1760     /**
1761      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1762      *
1763      * Requirements:
1764      *
1765      * - If `to` refers to a smart contract, it must implement
1766      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1767      * - `quantity` must be greater than 0.
1768      *
1769      * See {_mint}.
1770      *
1771      * Emits a {Transfer} event for each mint.
1772      */
1773     function _safeMint(
1774         address to,
1775         uint256 quantity,
1776         bytes memory _data
1777     ) internal virtual {
1778         _mint(to, quantity);
1779 
1780         unchecked {
1781             if (to.code.length != 0) {
1782                 uint256 end = _currentIndex;
1783                 uint256 index = end - quantity;
1784                 do {
1785                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1786                         revert TransferToNonERC721ReceiverImplementer();
1787                     }
1788                 } while (index < end);
1789                 // Reentrancy protection.
1790                 if (_currentIndex != end) revert();
1791             }
1792         }
1793     }
1794 
1795     /**
1796      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1797      */
1798     function _safeMint(address to, uint256 quantity) internal virtual {
1799         _safeMint(to, quantity, '');
1800     }
1801 
1802     // =============================================================
1803     //                        BURN OPERATIONS
1804     // =============================================================
1805 
1806     /**
1807      * @dev Equivalent to `_burn(tokenId, false)`.
1808      */
1809     function _burn(uint256 tokenId) internal virtual {
1810         _burn(tokenId, false);
1811     }
1812 
1813     /**
1814      * @dev Destroys `tokenId`.
1815      * The approval is cleared when the token is burned.
1816      *
1817      * Requirements:
1818      *
1819      * - `tokenId` must exist.
1820      *
1821      * Emits a {Transfer} event.
1822      */
1823     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1824         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1825 
1826         address from = address(uint160(prevOwnershipPacked));
1827 
1828         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1829 
1830         if (approvalCheck) {
1831             // The nested ifs save around 20+ gas over a compound boolean condition.
1832             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1833                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1834         }
1835 
1836         _beforeTokenTransfers(from, address(0), tokenId, 1);
1837 
1838         // Clear approvals from the previous owner.
1839         assembly {
1840             if approvedAddress {
1841                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1842                 sstore(approvedAddressSlot, 0)
1843             }
1844         }
1845 
1846         // Underflow of the sender's balance is impossible because we check for
1847         // ownership above and the recipient's balance can't realistically overflow.
1848         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1849         unchecked {
1850             // Updates:
1851             // - `balance -= 1`.
1852             // - `numberBurned += 1`.
1853             //
1854             // We can directly decrement the balance, and increment the number burned.
1855             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1856             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1857 
1858             // Updates:
1859             // - `address` to the last owner.
1860             // - `startTimestamp` to the timestamp of burning.
1861             // - `burned` to `true`.
1862             // - `nextInitialized` to `true`.
1863             _packedOwnerships[tokenId] = _packOwnershipData(
1864                 from,
1865                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1866             );
1867 
1868             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1869             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1870                 uint256 nextTokenId = tokenId + 1;
1871                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1872                 if (_packedOwnerships[nextTokenId] == 0) {
1873                     // If the next slot is within bounds.
1874                     if (nextTokenId != _currentIndex) {
1875                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1876                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1877                     }
1878                 }
1879             }
1880         }
1881 
1882         emit Transfer(from, address(0), tokenId);
1883         _afterTokenTransfers(from, address(0), tokenId, 1);
1884 
1885         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1886         unchecked {
1887             _burnCounter++;
1888         }
1889     }
1890 
1891     // =============================================================
1892     //                     EXTRA DATA OPERATIONS
1893     // =============================================================
1894 
1895     /**
1896      * @dev Directly sets the extra data for the ownership data `index`.
1897      */
1898     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1899         uint256 packed = _packedOwnerships[index];
1900         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1901         uint256 extraDataCasted;
1902         // Cast `extraData` with assembly to avoid redundant masking.
1903         assembly {
1904             extraDataCasted := extraData
1905         }
1906         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1907         _packedOwnerships[index] = packed;
1908     }
1909 
1910     /**
1911      * @dev Called during each token transfer to set the 24bit `extraData` field.
1912      * Intended to be overridden by the cosumer contract.
1913      *
1914      * `previousExtraData` - the value of `extraData` before transfer.
1915      *
1916      * Calling conditions:
1917      *
1918      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1919      * transferred to `to`.
1920      * - When `from` is zero, `tokenId` will be minted for `to`.
1921      * - When `to` is zero, `tokenId` will be burned by `from`.
1922      * - `from` and `to` are never both zero.
1923      */
1924     function _extraData(
1925         address from,
1926         address to,
1927         uint24 previousExtraData
1928     ) internal view virtual returns (uint24) {}
1929 
1930     /**
1931      * @dev Returns the next extra data for the packed ownership data.
1932      * The returned result is shifted into position.
1933      */
1934     function _nextExtraData(
1935         address from,
1936         address to,
1937         uint256 prevOwnershipPacked
1938     ) private view returns (uint256) {
1939         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1940         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1941     }
1942 
1943     // =============================================================
1944     //                       OTHER OPERATIONS
1945     // =============================================================
1946 
1947     /**
1948      * @dev Returns the message sender (defaults to `msg.sender`).
1949      *
1950      * If you are writing GSN compatible contracts, you need to override this function.
1951      */
1952     function _msgSenderERC721A() internal view virtual returns (address) {
1953         return msg.sender;
1954     }
1955 
1956     /**
1957      * @dev Converts a uint256 to its ASCII string decimal representation.
1958      */
1959     function _toString(uint256 value) internal pure virtual returns (string memory str) {
1960         assembly {
1961             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
1962             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
1963             // We will need 1 word for the trailing zeros padding, 1 word for the length,
1964             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
1965             let m := add(mload(0x40), 0xa0)
1966             // Update the free memory pointer to allocate.
1967             mstore(0x40, m)
1968             // Assign the `str` to the end.
1969             str := sub(m, 0x20)
1970             // Zeroize the slot after the string.
1971             mstore(str, 0)
1972 
1973             // Cache the end of the memory to calculate the length later.
1974             let end := str
1975 
1976             // We write the string from rightmost digit to leftmost digit.
1977             // The following is essentially a do-while loop that also handles the zero case.
1978             // prettier-ignore
1979             for { let temp := value } 1 {} {
1980                 str := sub(str, 1)
1981                 // Write the character to the pointer.
1982                 // The ASCII index of the '0' character is 48.
1983                 mstore8(str, add(48, mod(temp, 10)))
1984                 // Keep dividing `temp` until zero.
1985                 temp := div(temp, 10)
1986                 // prettier-ignore
1987                 if iszero(temp) { break }
1988             }
1989 
1990             let length := sub(end, str)
1991             // Move the pointer 32 bytes leftwards to make room for the length.
1992             str := sub(str, 0x20)
1993             // Store the length.
1994             mstore(str, length)
1995         }
1996     }
1997 }
1998 
1999 // File: Masquerade.sol
2000 
2001 
2002 pragma solidity ^0.8.20;
2003 
2004 
2005 
2006 
2007 contract Masquerade is ERC721A, Ownable {
2008     error InvalidValue();
2009     error MintIsNotLive();
2010     error AlreadyClaimed();
2011     error FreeClaimClosed();
2012     error FailedToSendETH();
2013     error FreeClaimSoldout();
2014     error InvalidFreeClaim();
2015     error InvalidWhitelistClaim();
2016     error WhitelistClaimSoldout();
2017     error RequestingInvalidAmount();
2018 
2019     uint256 public constant MAX_FREE_MINTS = 223;
2020     uint256 public constant MAX_HOLDER_MINTS = 665;
2021     uint256 public constant MAX_SUPPLY = 5555;
2022     uint256 public constant MAX_PUBLIC_SUPPLY = 4667;
2023     uint256 public constant MAX_PER_TXN = 6;
2024 
2025     uint256 public PUBLIC_PRICE = 0.02777 * 1 ether;
2026     uint256 public CLAIM_TIME = 3600;
2027     uint256 public START_TIME;
2028 
2029     uint256 public freeClaimed;
2030     uint256 public holdersClaimed;
2031 
2032     bool public IS_LIVE = false;
2033 
2034     string public baseURI = "https://masquerademaker.com/api/tokenURI/";
2035 
2036     mapping(address claimoor => uint flag) public claims;
2037 
2038     address claimSigner;
2039 
2040     constructor(address signer_) ERC721A("Masquerade Maker", "MASQMAKER") {
2041         _initializeOwner(msg.sender);
2042         claimSigner = signer_;
2043     }
2044 
2045     function freeClaim(bytes calldata signature) external {
2046         if (!IS_LIVE) {
2047             revert MintIsNotLive();
2048         }
2049 
2050         if (freeClaimClosed()) {
2051             revert FreeClaimClosed();
2052         }
2053 
2054         if (claims[msg.sender] != 0) {
2055             revert AlreadyClaimed();
2056         }
2057 
2058         if (freeClaimed + 1 > MAX_FREE_MINTS) {
2059             revert FreeClaimSoldout();
2060         }
2061 
2062         bytes32 message = keccak256(abi.encode(msg.sender, 2));
2063         if (
2064             ECDSA.recover(ECDSA.toEthSignedMessageHash(message), signature) !=
2065             claimSigner
2066         ) {
2067             revert InvalidFreeClaim();
2068         }
2069 
2070         freeClaimed++;
2071         claims[msg.sender]++;
2072         _mint(msg.sender, 1);
2073     }
2074 
2075     function holderClaim(bytes calldata signature) external {
2076         if (!IS_LIVE) {
2077             revert MintIsNotLive();
2078         }
2079 
2080         if (claims[msg.sender] != 0) {
2081             revert AlreadyClaimed();
2082         }
2083 
2084         if (holdersClaimed + 1 > MAX_HOLDER_MINTS) {
2085             revert WhitelistClaimSoldout();
2086         }
2087 
2088         bytes32 message = keccak256(abi.encode(msg.sender, 1));
2089         if (
2090             ECDSA.recover(ECDSA.toEthSignedMessageHash(message), signature) !=
2091             claimSigner
2092         ) {
2093             revert InvalidWhitelistClaim();
2094         }
2095 
2096         holdersClaimed++;
2097         claims[msg.sender]++;
2098         _mint(msg.sender, 1);
2099     }
2100 
2101     function publicMint(uint256 amount) external payable {
2102         if (!IS_LIVE) {
2103             revert MintIsNotLive();
2104         }
2105         if (amount == 0 || amount > MAX_PER_TXN) {
2106             revert RequestingInvalidAmount();
2107         }
2108         if (msg.value != (PUBLIC_PRICE * amount)) {
2109             revert InvalidValue();
2110         }
2111         if (totalSupply() + amount > getMaxPublicSupply()) {
2112             revert RequestingInvalidAmount();
2113         }
2114         _mint(msg.sender, amount);
2115     }
2116 
2117     function getMaxPublicSupply() public view returns (uint256) {
2118         if (freeClaimClosed()) {
2119             return (MAX_PUBLIC_SUPPLY) + (MAX_FREE_MINTS);
2120         }
2121         return MAX_PUBLIC_SUPPLY;
2122     }
2123 
2124     function freeClaimClosed() public view returns (bool) {
2125         return block.timestamp - START_TIME >= CLAIM_TIME; // Check if it's been more than 10 minutes
2126     }
2127 
2128     function _baseURI() internal view override returns (string memory) {
2129         return baseURI;
2130     }
2131 
2132     function setBaseURI(string calldata baseURI_) external onlyOwner {
2133         baseURI = baseURI_;
2134     }
2135 
2136     function goLive() external onlyOwner {
2137         IS_LIVE = true;
2138         START_TIME = block.timestamp;
2139     }
2140 
2141     function setSigner(address signer_) external onlyOwner {
2142         claimSigner = signer_;
2143     }
2144 
2145     function setClaimTime(uint256 seconds_) external onlyOwner {
2146         CLAIM_TIME = seconds_;
2147     }
2148 
2149     function setPrice(uint256 price_) external onlyOwner {
2150         PUBLIC_PRICE = price_;
2151     }
2152 
2153     function withdraw() external onlyOwner {
2154         (bool success, ) = address(owner()).call{value: address(this).balance}(
2155             ""
2156         );
2157         if (!success) {
2158             revert FailedToSendETH();
2159         }
2160     }
2161 
2162     function _startTokenId() internal pure override returns (uint256) {
2163         return 1;
2164     }
2165 }