1 // File: contracts/IRelayHub.sol
2 
3 pragma solidity ^0.5.5;
4 
5 contract IRelayHub {
6     // Relay management
7 
8     // Add stake to a relay and sets its unstakeDelay.
9     // If the relay does not exist, it is created, and the caller
10     // of this function becomes its owner. If the relay already exists, only the owner can call this function. A relay
11     // cannot be its own owner.
12     // All Ether in this function call will be added to the relay's stake.
13     // Its unstake delay will be assigned to unstakeDelay, but the new value must be greater or equal to the current one.
14     // Emits a Staked event.
15     function stake(address relayaddr, uint256 unstakeDelay) external payable;
16 
17     // Emited when a relay's stake or unstakeDelay are increased
18     event Staked(address indexed relay, uint256 stake, uint256 unstakeDelay);
19 
20     // Registers the caller as a relay.
21     // The relay must be staked for, and not be a contract (i.e. this function must be called directly from an EOA).
22     // Emits a RelayAdded event.
23     // This function can be called multiple times, emitting new RelayAdded events. Note that the received transactionFee
24     // is not enforced by relayCall.
25     function registerRelay(uint256 transactionFee, string memory url) public;
26 
27     // Emitted when a relay is registered or re-registerd. Looking at these events (and filtering out RelayRemoved
28     // events) lets a client discover the list of available relays.
29     event RelayAdded(address indexed relay, address indexed owner, uint256 transactionFee, uint256 stake, uint256 unstakeDelay, string url);
30 
31     // Removes (deregisters) a relay. Unregistered (but staked for) relays can also be removed. Can only be called by
32     // the owner of the relay. After the relay's unstakeDelay has elapsed, unstake will be callable.
33     // Emits a RelayRemoved event.
34     function removeRelayByOwner(address relay) public;
35 
36     // Emitted when a relay is removed (deregistered). unstakeTime is the time when unstake will be callable.
37     event RelayRemoved(address indexed relay, uint256 unstakeTime);
38 
39     // Deletes the relay from the system, and gives back its stake to the owner. Can only be called by the relay owner,
40     // after unstakeDelay has elapsed since removeRelayByOwner was called.
41     // Emits an Unstaked event.
42     function unstake(address relay) public;
43 
44     // Emitted when a relay is unstaked for, including the returned stake.
45     event Unstaked(address indexed relay, uint256 stake);
46 
47     // States a relay can be in
48     enum RelayState {
49         Unknown, // The relay is unknown to the system: it has never been staked for
50         Staked, // The relay has been staked for, but it is not yet active
51         Registered, // The relay has registered itself, and is active (can relay calls)
52         Removed    // The relay has been removed by its owner and can no longer relay calls. It must wait for its unstakeDelay to elapse before it can unstake
53     }
54 
55     // Returns a relay's status. Note that relays can be deleted when unstaked or penalized.
56     function getRelay(address relay) external view returns (uint256 totalStake, uint256 unstakeDelay, uint256 unstakeTime, address payable owner, RelayState state);
57 
58     // Balance management
59 
60     // Deposits ether for a contract, so that it can receive (and pay for) relayed transactions. Unused balance can only
61     // be withdrawn by the contract itself, by callingn withdraw.
62     // Emits a Deposited event.
63     function depositFor(address target) public payable;
64 
65     // Emitted when depositFor is called, including the amount and account that was funded.
66     event Deposited(address indexed recipient, address indexed from, uint256 amount);
67 
68     // Returns an account's deposits. These can be either a contnract's funds, or a relay owner's revenue.
69     function balanceOf(address target) external view returns (uint256);
70 
71     // Withdraws from an account's balance, sending it back to it. Relay owners call this to retrieve their revenue, and
72     // contracts can also use it to reduce their funding.
73     // Emits a Withdrawn event.
74     function withdraw(uint256 amount, address payable dest) public;
75 
76     // Emitted when an account withdraws funds from RelayHub.
77     event Withdrawn(address indexed account, address indexed dest, uint256 amount);
78 
79     // Relaying
80 
81     // Check if the RelayHub will accept a relayed operation. Multiple things must be true for this to happen:
82     //  - all arguments must be signed for by the sender (from)
83     //  - the sender's nonce must be the current one
84     //  - the recipient must accept this transaction (via acceptRelayedCall)
85     // Returns a PreconditionCheck value (OK when the transaction can be relayed), or a recipient-specific error code if
86     // it returns one in acceptRelayedCall.
87     function canRelay(
88         address relay,
89         address from,
90         address to,
91         bytes memory encodedFunction,
92         uint256 transactionFee,
93         uint256 gasPrice,
94         uint256 gasLimit,
95         uint256 nonce,
96         bytes memory signature,
97         bytes memory approvalData
98     ) public view returns (uint256 status, bytes memory recipientContext);
99 
100     // Preconditions for relaying, checked by canRelay and returned as the corresponding numeric values.
101     enum PreconditionCheck {
102         OK,                         // All checks passed, the call can be relayed
103         WrongSignature,             // The transaction to relay is not signed by requested sender
104         WrongNonce,                 // The provided nonce has already been used by the sender
105         AcceptRelayedCallReverted,  // The recipient rejected this call via acceptRelayedCall
106         InvalidRecipientStatusCode  // The recipient returned an invalid (reserved) status code
107     }
108 
109     // Relays a transaction. For this to suceed, multiple conditions must be met:
110     //  - canRelay must return PreconditionCheck.OK
111     //  - the sender must be a registered relay
112     //  - the transaction's gas price must be larger or equal to the one that was requested by the sender
113     //  - the transaction must have enough gas to not run out of gas if all internal transactions (calls to the
114     // recipient) use all gas available to them
115     //  - the recipient must have enough balance to pay the relay for the worst-case scenario (i.e. when all gas is
116     // spent)
117     //
118     // If all conditions are met, the call will be relayed and the recipient charged. preRelayedCall, the encoded
119     // function and postRelayedCall will be called in order.
120     //
121     // Arguments:
122     //  - from: the client originating the request
123     //  - recipient: the target IRelayRecipient contract
124     //  - encodedFunction: the function call to relay, including data
125     //  - transactionFee: fee (%) the relay takes over actual gas cost
126     //  - gasPrice: gas price the client is willing to pay
127     //  - gasLimit: gas to forward when calling the encoded function
128     //  - nonce: client's nonce
129     //  - signature: client's signature over all previous params, plus the relay and RelayHub addresses
130     //  - approvalData: dapp-specific data forwared to acceptRelayedCall. This value is *not* verified by the Hub, but
131     //    it still can be used for e.g. a signature.
132     //
133     // Emits a TransactionRelayed event.
134     function relayCall(
135         address from,
136         address to,
137         bytes memory encodedFunction,
138         uint256 transactionFee,
139         uint256 gasPrice,
140         uint256 gasLimit,
141         uint256 nonce,
142         bytes memory signature,
143         bytes memory approvalData
144     ) public;
145 
146     // Emitted when an attempt to relay a call failed. This can happen due to incorrect relayCall arguments, or the
147     // recipient not accepting the relayed call. The actual relayed call was not executed, and the recipient not charged.
148     // The reason field contains an error code: values 1-10 correspond to PreconditionCheck entries, and values over 10
149     // are custom recipient error codes returned from acceptRelayedCall.
150     event CanRelayFailed(address indexed relay, address indexed from, address indexed to, bytes4 selector, uint256 reason);
151 
152     // Emitted when a transaction is relayed. Note that the actual encoded function might be reverted: this will be
153     // indicated in the status field.
154     // Useful when monitoring a relay's operation and relayed calls to a contract.
155     // Charge is the ether value deducted from the recipient's balance, paid to the relay's owner.
156     event TransactionRelayed(address indexed relay, address indexed from, address indexed to, bytes4 selector, RelayCallStatus status, uint256 charge);
157 
158     // Reason error codes for the TransactionRelayed event
159     enum RelayCallStatus {
160         OK,                      // The transaction was successfully relayed and execution successful - never included in the event
161         RelayedCallFailed,       // The transaction was relayed, but the relayed call failed
162         PreRelayedFailed,        // The transaction was not relayed due to preRelatedCall reverting
163         PostRelayedFailed,       // The transaction was relayed and reverted due to postRelatedCall reverting
164         RecipientBalanceChanged  // The transaction was relayed and reverted due to the recipient's balance changing
165     }
166 
167     // Returns how much gas should be forwarded to a call to relayCall, in order to relay a transaction that will spend
168     // up to relayedCallStipend gas.
169     function requiredGas(uint256 relayedCallStipend) public view returns (uint256);
170 
171     // Returns the maximum recipient charge, given the amount of gas forwarded, gas price and relay fee.
172     function maxPossibleCharge(uint256 relayedCallStipend, uint256 gasPrice, uint256 transactionFee) public view returns (uint256);
173 
174     // Relay penalization. Any account can penalize relays, removing them from the system immediately, and rewarding the
175     // reporter with half of the relay's stake. The other half is burned so that, even if the relay penalizes itself, it
176     // still loses half of its stake.
177 
178     // Penalize a relay that signed two transactions using the same nonce (making only the first one valid) and
179     // different data (gas price, gas limit, etc. may be different). The (unsigned) transaction data and signature for
180     // both transactions must be provided.
181     function penalizeRepeatedNonce(bytes memory unsignedTx1, bytes memory signature1, bytes memory unsignedTx2, bytes memory signature2) public;
182 
183     // Penalize a relay that sent a transaction that didn't target RelayHub's registerRelay or relayCall.
184     function penalizeIllegalTransaction(bytes memory unsignedTx, bytes memory signature) public;
185 
186     event Penalized(address indexed relay, address sender, uint256 amount);
187 
188     function getNonce(address from) view external returns (uint256);
189 }
190 
191 // File: contracts/IRelayRecipient.sol
192 
193 pragma solidity ^0.5.5;
194 
195 contract IRelayRecipient {
196 
197     /**
198      * return the relayHub of this contract.
199      */
200     function getHubAddr() public view returns (address);
201 
202     /**
203      * return the contract's balance on the RelayHub.
204      * can be used to determine if the contract can pay for incoming calls,
205      * before making any.
206      */
207     function getRecipientBalance() public view returns (uint);
208 
209     /*
210      * Called by Relay (and RelayHub), to validate if this recipient accepts this call.
211      * Note: Accepting this call means paying for the tx whether the relayed call reverted or not.
212      *
213      *  @return "0" if the the contract is willing to accept the charges from this sender, for this function call.
214      *      any other value is a failure. actual value is for diagnostics only.
215      *      ** Note: values below 10 are reserved by canRelay
216 
217      *  @param relay the relay that attempts to relay this function call.
218      *          the contract may restrict some encoded functions to specific known relays.
219      *  @param from the sender (signer) of this function call.
220      *  @param encodedFunction the encoded function call (without any ethereum signature).
221      *          the contract may check the method-id for valid methods
222      *  @param gasPrice - the gas price for this transaction
223      *  @param transactionFee - the relay compensation (in %) for this transaction
224      *  @param signature - sender's signature over all parameters except approvalData
225      *  @param approvalData - extra dapp-specific data (e.g. signature from trusted party)
226      */
227      function acceptRelayedCall(
228         address relay,
229         address from,
230         bytes calldata encodedFunction,
231         uint256 transactionFee,
232         uint256 gasPrice,
233         uint256 gasLimit,
234         uint256 nonce,
235         bytes calldata approvalData,
236         uint256 maxPossibleCharge
237     )
238     external
239     view
240     returns (uint256, bytes memory);
241 
242     /*
243      * modifier to be used by recipients as access control protection for preRelayedCall & postRelayedCall
244      */
245     modifier relayHubOnly() {
246         require(msg.sender == getHubAddr(),"Function can only be called by RelayHub");
247         _;
248     }
249 
250     /** this method is called before the actual relayed function call.
251      * It may be used to charge the caller before (in conjuction with refunding him later in postRelayedCall for example).
252      * the method is given all parameters of acceptRelayedCall and actual used gas.
253      *
254      *
255      *** NOTICE: if this method modifies the contract's state, it must be protected with access control i.e. require msg.sender == getHubAddr()
256      *
257      *
258      * Revert in this functions causes a revert of the client's relayed call but not in the entire transaction
259      * (that is, the relay will still get compensated)
260      */
261     function preRelayedCall(bytes calldata context) external returns (bytes32);
262 
263     /** this method is called after the actual relayed function call.
264      * It may be used to record the transaction (e.g. charge the caller by some contract logic) for this call.
265      * the method is given all parameters of acceptRelayedCall, and also the success/failure status and actual used gas.
266      *
267      *
268      *** NOTICE: if this method modifies the contract's state, it must be protected with access control i.e. require msg.sender == getHubAddr()
269      *
270      *
271      * @param success - true if the relayed call succeeded, false if it reverted
272      * @param actualCharge - estimation of how much the recipient will be charged. This information may be used to perform local booking and
273      *   charge the sender for this call (e.g. in tokens).
274      * @param preRetVal - preRelayedCall() return value passed back to the recipient
275      *
276      * Revert in this functions causes a revert of the client's relayed call but not in the entire transaction
277      * (that is, the relay will still get compensated)
278      */
279     function postRelayedCall(bytes calldata context, bool success, uint actualCharge, bytes32 preRetVal) external;
280 
281 }
282 
283 // File: @0x/contracts-utils/contracts/src/LibBytes.sol
284 
285 /*
286 
287   Copyright 2018 ZeroEx Intl.
288 
289   Licensed under the Apache License, Version 2.0 (the "License");
290   you may not use this file except in compliance with the License.
291   You may obtain a copy of the License at
292 
293     http://www.apache.org/licenses/LICENSE-2.0
294 
295   Unless required by applicable law or agreed to in writing, software
296   distributed under the License is distributed on an "AS IS" BASIS,
297   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
298   See the License for the specific language governing permissions and
299   limitations under the License.
300 
301 */
302 
303 pragma solidity ^0.5.5;
304 
305 
306 library LibBytes {
307 
308     using LibBytes for bytes;
309 
310     /// @dev Gets the memory address for a byte array.
311     /// @param input Byte array to lookup.
312     /// @return memoryAddress Memory address of byte array. This
313     ///         points to the header of the byte array which contains
314     ///         the length.
315     function rawAddress(bytes memory input)
316         internal
317         pure
318         returns (uint256 memoryAddress)
319     {
320         assembly {
321             memoryAddress := input
322         }
323         return memoryAddress;
324     }
325     
326     /// @dev Gets the memory address for the contents of a byte array.
327     /// @param input Byte array to lookup.
328     /// @return memoryAddress Memory address of the contents of the byte array.
329     function contentAddress(bytes memory input)
330         internal
331         pure
332         returns (uint256 memoryAddress)
333     {
334         assembly {
335             memoryAddress := add(input, 32)
336         }
337         return memoryAddress;
338     }
339 
340     /// @dev Copies `length` bytes from memory location `source` to `dest`.
341     /// @param dest memory address to copy bytes to.
342     /// @param source memory address to copy bytes from.
343     /// @param length number of bytes to copy.
344     function memCopy(
345         uint256 dest,
346         uint256 source,
347         uint256 length
348     )
349         internal
350         pure
351     {
352         if (length < 32) {
353             // Handle a partial word by reading destination and masking
354             // off the bits we are interested in.
355             // This correctly handles overlap, zero lengths and source == dest
356             assembly {
357                 let mask := sub(exp(256, sub(32, length)), 1)
358                 let s := and(mload(source), not(mask))
359                 let d := and(mload(dest), mask)
360                 mstore(dest, or(s, d))
361             }
362         } else {
363             // Skip the O(length) loop when source == dest.
364             if (source == dest) {
365                 return;
366             }
367 
368             // For large copies we copy whole words at a time. The final
369             // word is aligned to the end of the range (instead of after the
370             // previous) to handle partial words. So a copy will look like this:
371             //
372             //  ####
373             //      ####
374             //          ####
375             //            ####
376             //
377             // We handle overlap in the source and destination range by
378             // changing the copying direction. This prevents us from
379             // overwriting parts of source that we still need to copy.
380             //
381             // This correctly handles source == dest
382             //
383             if (source > dest) {
384                 assembly {
385                     // We subtract 32 from `sEnd` and `dEnd` because it
386                     // is easier to compare with in the loop, and these
387                     // are also the addresses we need for copying the
388                     // last bytes.
389                     length := sub(length, 32)
390                     let sEnd := add(source, length)
391                     let dEnd := add(dest, length)
392 
393                     // Remember the last 32 bytes of source
394                     // This needs to be done here and not after the loop
395                     // because we may have overwritten the last bytes in
396                     // source already due to overlap.
397                     let last := mload(sEnd)
398 
399                     // Copy whole words front to back
400                     // Note: the first check is always true,
401                     // this could have been a do-while loop.
402                     // solhint-disable-next-line no-empty-blocks
403                     for {} lt(source, sEnd) {} {
404                         mstore(dest, mload(source))
405                         source := add(source, 32)
406                         dest := add(dest, 32)
407                     }
408                     
409                     // Write the last 32 bytes
410                     mstore(dEnd, last)
411                 }
412             } else {
413                 assembly {
414                     // We subtract 32 from `sEnd` and `dEnd` because those
415                     // are the starting points when copying a word at the end.
416                     length := sub(length, 32)
417                     let sEnd := add(source, length)
418                     let dEnd := add(dest, length)
419 
420                     // Remember the first 32 bytes of source
421                     // This needs to be done here and not after the loop
422                     // because we may have overwritten the first bytes in
423                     // source already due to overlap.
424                     let first := mload(source)
425 
426                     // Copy whole words back to front
427                     // We use a signed comparisson here to allow dEnd to become
428                     // negative (happens when source and dest < 32). Valid
429                     // addresses in local memory will never be larger than
430                     // 2**255, so they can be safely re-interpreted as signed.
431                     // Note: the first check is always true,
432                     // this could have been a do-while loop.
433                     // solhint-disable-next-line no-empty-blocks
434                     for {} slt(dest, dEnd) {} {
435                         mstore(dEnd, mload(sEnd))
436                         sEnd := sub(sEnd, 32)
437                         dEnd := sub(dEnd, 32)
438                     }
439                     
440                     // Write the first 32 bytes
441                     mstore(dest, first)
442                 }
443             }
444         }
445     }
446 
447     /// @dev Returns a slices from a byte array.
448     /// @param b The byte array to take a slice from.
449     /// @param from The starting index for the slice (inclusive).
450     /// @param to The final index for the slice (exclusive).
451     /// @return result The slice containing bytes at indices [from, to)
452     function slice(
453         bytes memory b,
454         uint256 from,
455         uint256 to
456     )
457         internal
458         pure
459         returns (bytes memory result)
460     {
461         require(
462             from <= to,
463             "FROM_LESS_THAN_TO_REQUIRED"
464         );
465         require(
466             to <= b.length,
467             "TO_LESS_THAN_LENGTH_REQUIRED"
468         );
469         
470         // Create a new bytes structure and copy contents
471         result = new bytes(to - from);
472         memCopy(
473             result.contentAddress(),
474             b.contentAddress() + from,
475             result.length
476         );
477         return result;
478     }
479     
480     /// @dev Returns a slice from a byte array without preserving the input.
481     /// @param b The byte array to take a slice from. Will be destroyed in the process.
482     /// @param from The starting index for the slice (inclusive).
483     /// @param to The final index for the slice (exclusive).
484     /// @return result The slice containing bytes at indices [from, to)
485     /// @dev When `from == 0`, the original array will match the slice. In other cases its state will be corrupted.
486     function sliceDestructive(
487         bytes memory b,
488         uint256 from,
489         uint256 to
490     )
491         internal
492         pure
493         returns (bytes memory result)
494     {
495         require(
496             from <= to,
497             "FROM_LESS_THAN_TO_REQUIRED"
498         );
499         require(
500             to <= b.length,
501             "TO_LESS_THAN_LENGTH_REQUIRED"
502         );
503         
504         // Create a new bytes structure around [from, to) in-place.
505         assembly {
506             result := add(b, from)
507             mstore(result, sub(to, from))
508         }
509         return result;
510     }
511 
512     /// @dev Pops the last byte off of a byte array by modifying its length.
513     /// @param b Byte array that will be modified.
514     /// @return The byte that was popped off.
515     function popLastByte(bytes memory b)
516         internal
517         pure
518         returns (bytes1 result)
519     {
520         require(
521             b.length > 0,
522             "GREATER_THAN_ZERO_LENGTH_REQUIRED"
523         );
524 
525         // Store last byte.
526         result = b[b.length - 1];
527 
528         assembly {
529             // Decrement length of byte array.
530             let newLen := sub(mload(b), 1)
531             mstore(b, newLen)
532         }
533         return result;
534     }
535 
536     /// @dev Pops the last 20 bytes off of a byte array by modifying its length.
537     /// @param b Byte array that will be modified.
538     /// @return The 20 byte address that was popped off.
539     function popLast20Bytes(bytes memory b)
540         internal
541         pure
542         returns (address result)
543     {
544         require(
545             b.length >= 20,
546             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
547         );
548 
549         // Store last 20 bytes.
550         result = readAddress(b, b.length - 20);
551 
552         assembly {
553             // Subtract 20 from byte array length.
554             let newLen := sub(mload(b), 20)
555             mstore(b, newLen)
556         }
557         return result;
558     }
559 
560     /// @dev Tests equality of two byte arrays.
561     /// @param lhs First byte array to compare.
562     /// @param rhs Second byte array to compare.
563     /// @return True if arrays are the same. False otherwise.
564     function equals(
565         bytes memory lhs,
566         bytes memory rhs
567     )
568         internal
569         pure
570         returns (bool equal)
571     {
572         // Keccak gas cost is 30 + numWords * 6. This is a cheap way to compare.
573         // We early exit on unequal lengths, but keccak would also correctly
574         // handle this.
575         return lhs.length == rhs.length && keccak256(lhs) == keccak256(rhs);
576     }
577 
578     /// @dev Reads an address from a position in a byte array.
579     /// @param b Byte array containing an address.
580     /// @param index Index in byte array of address.
581     /// @return address from byte array.
582     function readAddress(
583         bytes memory b,
584         uint256 index
585     )
586         internal
587         pure
588         returns (address result)
589     {
590         require(
591             b.length >= index + 20,  // 20 is length of address
592             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
593         );
594 
595         // Add offset to index:
596         // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
597         // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
598         index += 20;
599 
600         // Read address from array memory
601         assembly {
602             // 1. Add index to address of bytes array
603             // 2. Load 32-byte word from memory
604             // 3. Apply 20-byte mask to obtain address
605             result := and(mload(add(b, index)), 0xffffffffffffffffffffffffffffffffffffffff)
606         }
607         return result;
608     }
609 
610     /// @dev Writes an address into a specific position in a byte array.
611     /// @param b Byte array to insert address into.
612     /// @param index Index in byte array of address.
613     /// @param input Address to put into byte array.
614     function writeAddress(
615         bytes memory b,
616         uint256 index,
617         address input
618     )
619         internal
620         pure
621     {
622         require(
623             b.length >= index + 20,  // 20 is length of address
624             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
625         );
626 
627         // Add offset to index:
628         // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
629         // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
630         index += 20;
631 
632         // Store address into array memory
633         assembly {
634             // The address occupies 20 bytes and mstore stores 32 bytes.
635             // First fetch the 32-byte word where we'll be storing the address, then
636             // apply a mask so we have only the bytes in the word that the address will not occupy.
637             // Then combine these bytes with the address and store the 32 bytes back to memory with mstore.
638 
639             // 1. Add index to address of bytes array
640             // 2. Load 32-byte word from memory
641             // 3. Apply 12-byte mask to obtain extra bytes occupying word of memory where we'll store the address
642             let neighbors := and(
643                 mload(add(b, index)),
644                 0xffffffffffffffffffffffff0000000000000000000000000000000000000000
645             )
646             
647             // Make sure input address is clean.
648             // (Solidity does not guarantee this)
649             input := and(input, 0xffffffffffffffffffffffffffffffffffffffff)
650 
651             // Store the neighbors and address into memory
652             mstore(add(b, index), xor(input, neighbors))
653         }
654     }
655 
656     /// @dev Reads a bytes32 value from a position in a byte array.
657     /// @param b Byte array containing a bytes32 value.
658     /// @param index Index in byte array of bytes32 value.
659     /// @return bytes32 value from byte array.
660     function readBytes32(
661         bytes memory b,
662         uint256 index
663     )
664         internal
665         pure
666         returns (bytes32 result)
667     {
668         require(
669             b.length >= index + 32,
670             "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
671         );
672 
673         // Arrays are prefixed by a 256 bit length parameter
674         index += 32;
675 
676         // Read the bytes32 from array memory
677         assembly {
678             result := mload(add(b, index))
679         }
680         return result;
681     }
682 
683     /// @dev Writes a bytes32 into a specific position in a byte array.
684     /// @param b Byte array to insert <input> into.
685     /// @param index Index in byte array of <input>.
686     /// @param input bytes32 to put into byte array.
687     function writeBytes32(
688         bytes memory b,
689         uint256 index,
690         bytes32 input
691     )
692         internal
693         pure
694     {
695         require(
696             b.length >= index + 32,
697             "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
698         );
699 
700         // Arrays are prefixed by a 256 bit length parameter
701         index += 32;
702 
703         // Read the bytes32 from array memory
704         assembly {
705             mstore(add(b, index), input)
706         }
707     }
708 
709     /// @dev Reads a uint256 value from a position in a byte array.
710     /// @param b Byte array containing a uint256 value.
711     /// @param index Index in byte array of uint256 value.
712     /// @return uint256 value from byte array.
713     function readUint256(
714         bytes memory b,
715         uint256 index
716     )
717         internal
718         pure
719         returns (uint256 result)
720     {
721         result = uint256(readBytes32(b, index));
722         return result;
723     }
724 
725     /// @dev Writes a uint256 into a specific position in a byte array.
726     /// @param b Byte array to insert <input> into.
727     /// @param index Index in byte array of <input>.
728     /// @param input uint256 to put into byte array.
729     function writeUint256(
730         bytes memory b,
731         uint256 index,
732         uint256 input
733     )
734         internal
735         pure
736     {
737         writeBytes32(b, index, bytes32(input));
738     }
739 
740     /// @dev Reads an unpadded bytes4 value from a position in a byte array.
741     /// @param b Byte array containing a bytes4 value.
742     /// @param index Index in byte array of bytes4 value.
743     /// @return bytes4 value from byte array.
744     function readBytes4(
745         bytes memory b,
746         uint256 index
747     )
748         internal
749         pure
750         returns (bytes4 result)
751     {
752         require(
753             b.length >= index + 4,
754             "GREATER_OR_EQUAL_TO_4_LENGTH_REQUIRED"
755         );
756 
757         // Arrays are prefixed by a 32 byte length field
758         index += 32;
759 
760         // Read the bytes4 from array memory
761         assembly {
762             result := mload(add(b, index))
763             // Solidity does not require us to clean the trailing bytes.
764             // We do it anyway
765             result := and(result, 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000)
766         }
767         return result;
768     }
769 
770     /// @dev Reads nested bytes from a specific position.
771     /// @dev NOTE: the returned value overlaps with the input value.
772     ///            Both should be treated as immutable.
773     /// @param b Byte array containing nested bytes.
774     /// @param index Index of nested bytes.
775     /// @return result Nested bytes.
776     function readBytesWithLength(
777         bytes memory b,
778         uint256 index
779     )
780         internal
781         pure
782         returns (bytes memory result)
783     {
784         // Read length of nested bytes
785         uint256 nestedBytesLength = readUint256(b, index);
786         index += 32;
787 
788         // Assert length of <b> is valid, given
789         // length of nested bytes
790         require(
791             b.length >= index + nestedBytesLength,
792             "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"
793         );
794         
795         // Return a pointer to the byte array as it exists inside `b`
796         assembly {
797             result := add(b, index)
798         }
799         return result;
800     }
801 
802     /// @dev Inserts bytes at a specific position in a byte array.
803     /// @param b Byte array to insert <input> into.
804     /// @param index Index in byte array of <input>.
805     /// @param input bytes to insert.
806     function writeBytesWithLength(
807         bytes memory b,
808         uint256 index,
809         bytes memory input
810     )
811         internal
812         pure
813     {
814         // Assert length of <b> is valid, given
815         // length of input
816         require(
817             b.length >= index + 32 + input.length,  // 32 bytes to store length
818             "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"
819         );
820 
821         // Copy <input> into <b>
822         memCopy(
823             b.contentAddress() + index,
824             input.rawAddress(), // includes length of <input>
825             input.length + 32   // +32 bytes to store <input> length
826         );
827     }
828 
829     /// @dev Performs a deep copy of a byte array onto another byte array of greater than or equal length.
830     /// @param dest Byte array that will be overwritten with source bytes.
831     /// @param source Byte array to copy onto dest bytes.
832     function deepCopyBytes(
833         bytes memory dest,
834         bytes memory source
835     )
836         internal
837         pure
838     {
839         uint256 sourceLen = source.length;
840         // Dest length must be >= source length, or some bytes would not be copied.
841         require(
842             dest.length >= sourceLen,
843             "GREATER_OR_EQUAL_TO_SOURCE_BYTES_LENGTH_REQUIRED"
844         );
845         memCopy(
846             dest.contentAddress(),
847             source.contentAddress(),
848             sourceLen
849         );
850     }
851 }
852 
853 // File: contracts/GsnUtils.sol
854 
855 pragma solidity ^0.5.5;
856 
857 
858 library GsnUtils {
859 
860     /**
861      * extract method sig from encoded function call
862      */
863     function getMethodSig(bytes memory msgData) internal pure returns (bytes4) {
864         return bytes4(bytes32(LibBytes.readUint256(msgData, 0)));
865     }
866 
867     /**
868      * extract parameter from encoded-function block.
869      * see: https://solidity.readthedocs.io/en/develop/abi-spec.html#formal-specification-of-the-encoding
870      * note that the type of the parameter must be static.
871      * the return value should be casted to the right type.
872      */
873     function getParam(bytes memory msgData, uint index) internal pure returns (uint) {
874         return LibBytes.readUint256(msgData, 4 + index * 32);
875     }
876 
877     /**
878      * extract dynamic-sized (string/bytes) parameter.
879      * we assume that there ARE dynamic parameters, hence getParam(0) is the offset to the first
880      * dynamic param
881      * https://solidity.readthedocs.io/en/develop/abi-spec.html#use-of-dynamic-types
882      */
883     function getBytesParam(bytes memory msgData, uint index) internal pure returns (bytes memory ret)  {
884         uint ofs = getParam(msgData,index)+4;
885         uint len = LibBytes.readUint256(msgData, ofs);
886         ret = LibBytes.slice(msgData, ofs+32, ofs+32+len);
887     }
888 
889     function getStringParam(bytes memory msgData, uint index) internal pure returns (string memory) {
890         return string(getBytesParam(msgData,index));
891     }
892 
893     function checkSig(address signer, bytes32 hash, bytes memory sig) pure internal returns (bool) {
894         // Check if @v,@r,@s are a valid signature of @signer for @hash
895         uint8 v = uint8(sig[0]);
896         bytes32 r = LibBytes.readBytes32(sig,1);
897         bytes32 s = LibBytes.readBytes32(sig,33);
898         return signer == ecrecover(hash, v, r, s);
899     }
900 }
901 
902 // File: contracts/RLPReader.sol
903 
904 /*
905 * Taken from https://github.com/hamdiallam/Solidity-RLP
906 */
907 
908 pragma solidity ^0.5.5;
909 
910 library RLPReader {
911 
912     uint8 constant STRING_SHORT_START = 0x80;
913     uint8 constant STRING_LONG_START = 0xb8;
914     uint8 constant LIST_SHORT_START = 0xc0;
915     uint8 constant LIST_LONG_START = 0xf8;
916     uint8 constant WORD_SIZE = 32;
917 
918     struct RLPItem {
919         uint len;
920         uint memPtr;
921     }
922 
923     using RLPReader for bytes;
924     using RLPReader for uint;
925     using RLPReader for RLPReader.RLPItem;
926 
927     // helper function to decode rlp encoded  ethereum transaction
928     /*
929     * @param rawTransaction RLP encoded ethereum transaction
930     * @return tuple (nonce,gasPrice,gasLimit,to,value,data)
931     */
932 
933     function decodeTransaction(bytes memory rawTransaction) internal pure returns (uint, uint, uint, address, uint, bytes memory){
934         RLPReader.RLPItem[] memory values = rawTransaction.toRlpItem().toList(); // must convert to an rlpItem first!
935         return (values[0].toUint(), values[1].toUint(), values[2].toUint(), values[3].toAddress(), values[4].toUint(), values[5].toBytes());
936     }
937 
938     /*
939     * @param item RLP encoded bytes
940     */
941     function toRlpItem(bytes memory item) internal pure returns (RLPItem memory) {
942         if (item.length == 0)
943             return RLPItem(0, 0);
944         uint memPtr;
945         assembly {
946             memPtr := add(item, 0x20)
947         }
948         return RLPItem(item.length, memPtr);
949     }
950     /*
951     * @param item RLP encoded list in bytes
952     */
953     function toList(RLPItem memory item) internal pure returns (RLPItem[] memory result) {
954         require(isList(item), "isList failed");
955         uint items = numItems(item);
956         result = new RLPItem[](items);
957         uint memPtr = item.memPtr + _payloadOffset(item.memPtr);
958         uint dataLen;
959         for (uint i = 0; i < items; i++) {
960             dataLen = _itemLength(memPtr);
961             result[i] = RLPItem(dataLen, memPtr);
962             memPtr = memPtr + dataLen;
963         }
964     }
965     /*
966     * Helpers
967     */
968     // @return indicator whether encoded payload is a list. negate this function call for isData.
969     function isList(RLPItem memory item) internal pure returns (bool) {
970         uint8 byte0;
971         uint memPtr = item.memPtr;
972         assembly {
973             byte0 := byte(0, mload(memPtr))
974         }
975         if (byte0 < LIST_SHORT_START)
976             return false;
977         return true;
978     }
979     // @return number of payload items inside an encoded list.
980     function numItems(RLPItem memory item) internal pure returns (uint) {
981         uint count = 0;
982         uint currPtr = item.memPtr + _payloadOffset(item.memPtr);
983         uint endPtr = item.memPtr + item.len;
984         while (currPtr < endPtr) {
985             currPtr = currPtr + _itemLength(currPtr);
986             // skip over an item
987             count++;
988         }
989         return count;
990     }
991     // @return entire rlp item byte length
992     function _itemLength(uint memPtr) internal pure returns (uint len) {
993         uint byte0;
994         assembly {
995             byte0 := byte(0, mload(memPtr))
996         }
997         if (byte0 < STRING_SHORT_START)
998             return 1;
999         else if (byte0 < STRING_LONG_START)
1000             return byte0 - STRING_SHORT_START + 1;
1001         else if (byte0 < LIST_SHORT_START) {
1002             assembly {
1003                 let byteLen := sub(byte0, 0xb7) // # of bytes the actual length is
1004                 memPtr := add(memPtr, 1) // skip over the first byte
1005             /* 32 byte word size */
1006                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to get the len
1007                 len := add(dataLen, add(byteLen, 1))
1008             }
1009         }
1010         else if (byte0 < LIST_LONG_START) {
1011             return byte0 - LIST_SHORT_START + 1;
1012         }
1013         else {
1014             assembly {
1015                 let byteLen := sub(byte0, 0xf7)
1016                 memPtr := add(memPtr, 1)
1017                 let dataLen := div(mload(memPtr), exp(256, sub(32, byteLen))) // right shifting to the correct length
1018                 len := add(dataLen, add(byteLen, 1))
1019             }
1020         }
1021     }
1022     // @return number of bytes until the data
1023     function _payloadOffset(uint memPtr) internal pure returns (uint) {
1024         uint byte0;
1025         assembly {
1026             byte0 := byte(0, mload(memPtr))
1027         }
1028         if (byte0 < STRING_SHORT_START)
1029             return 0;
1030         else if (byte0 < STRING_LONG_START || (byte0 >= LIST_SHORT_START && byte0 < LIST_LONG_START))
1031             return 1;
1032         else if (byte0 < LIST_SHORT_START)  // being explicit
1033             return byte0 - (STRING_LONG_START - 1) + 1;
1034         else
1035             return byte0 - (LIST_LONG_START - 1) + 1;
1036     }
1037     /** RLPItem conversions into data types **/
1038     // @returns raw rlp encoding in bytes
1039     function toRlpBytes(RLPItem memory item) internal pure returns (bytes memory) {
1040         bytes memory result = new bytes(item.len);
1041         uint ptr;
1042         assembly {
1043             ptr := add(0x20, result)
1044         }
1045         copy(item.memPtr, ptr, item.len);
1046         return result;
1047     }
1048 
1049     function toBoolean(RLPItem memory item) internal pure returns (bool) {
1050         require(item.len == 1, "Invalid RLPItem. Booleans are encoded in 1 byte");
1051         uint result;
1052         uint memPtr = item.memPtr;
1053         assembly {
1054             result := byte(0, mload(memPtr))
1055         }
1056         return result == 0 ? false : true;
1057     }
1058 
1059     function toAddress(RLPItem memory item) internal pure returns (address) {
1060         // 1 byte for the length prefix according to RLP spec
1061         require(item.len <= 21, "Invalid RLPItem. Addresses are encoded in 20 bytes or less");
1062         return address(toUint(item));
1063     }
1064 
1065     function toUint(RLPItem memory item) internal pure returns (uint) {
1066         uint offset = _payloadOffset(item.memPtr);
1067         uint len = item.len - offset;
1068         uint memPtr = item.memPtr + offset;
1069         uint result;
1070         assembly {
1071             result := div(mload(memPtr), exp(256, sub(32, len))) // shift to the correct location
1072         }
1073         return result;
1074     }
1075 
1076     function toBytes(RLPItem memory item) internal pure returns (bytes memory) {
1077         uint offset = _payloadOffset(item.memPtr);
1078         uint len = item.len - offset;
1079         // data length
1080         bytes memory result = new bytes(len);
1081         uint destPtr;
1082         assembly {
1083             destPtr := add(0x20, result)
1084         }
1085         copy(item.memPtr + offset, destPtr, len);
1086         return result;
1087     }
1088     /*
1089     * @param src Pointer to source
1090     * @param dest Pointer to destination
1091     * @param len Amount of memory to copy from the source
1092     */
1093     function copy(uint src, uint dest, uint len) internal pure {
1094         // copy as many word sizes as possible
1095         for (; len >= WORD_SIZE; len -= WORD_SIZE) {
1096             assembly {
1097                 mstore(dest, mload(src))
1098             }
1099             src += WORD_SIZE;
1100             dest += WORD_SIZE;
1101         }
1102         // left over bytes. Mask is used to remove unwanted bytes from the word
1103         uint mask = 256 ** (WORD_SIZE - len) - 1;
1104         assembly {
1105             let srcpart := and(mload(src), not(mask)) // zero out src
1106             let destpart := and(mload(dest), mask) // retrieve the bytes
1107             mstore(dest, or(destpart, srcpart))
1108         }
1109     }
1110 }
1111 
1112 // File: openzeppelin-solidity/contracts/math/SafeMath.sol
1113 
1114 pragma solidity ^0.5.0;
1115 
1116 /**
1117  * @dev Wrappers over Solidity's arithmetic operations with added overflow
1118  * checks.
1119  *
1120  * Arithmetic operations in Solidity wrap on overflow. This can easily result
1121  * in bugs, because programmers usually assume that an overflow raises an
1122  * error, which is the standard behavior in high level programming languages.
1123  * `SafeMath` restores this intuition by reverting the transaction when an
1124  * operation overflows.
1125  *
1126  * Using this library instead of the unchecked operations eliminates an entire
1127  * class of bugs, so it's recommended to use it always.
1128  */
1129 library SafeMath {
1130     /**
1131      * @dev Returns the addition of two unsigned integers, reverting on
1132      * overflow.
1133      *
1134      * Counterpart to Solidity's `+` operator.
1135      *
1136      * Requirements:
1137      * - Addition cannot overflow.
1138      */
1139     function add(uint256 a, uint256 b) internal pure returns (uint256) {
1140         uint256 c = a + b;
1141         require(c >= a, "SafeMath: addition overflow");
1142 
1143         return c;
1144     }
1145 
1146     /**
1147      * @dev Returns the subtraction of two unsigned integers, reverting on
1148      * overflow (when the result is negative).
1149      *
1150      * Counterpart to Solidity's `-` operator.
1151      *
1152      * Requirements:
1153      * - Subtraction cannot overflow.
1154      */
1155     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1156         require(b <= a, "SafeMath: subtraction overflow");
1157         uint256 c = a - b;
1158 
1159         return c;
1160     }
1161 
1162     /**
1163      * @dev Returns the multiplication of two unsigned integers, reverting on
1164      * overflow.
1165      *
1166      * Counterpart to Solidity's `*` operator.
1167      *
1168      * Requirements:
1169      * - Multiplication cannot overflow.
1170      */
1171     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1172         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1173         // benefit is lost if 'b' is also tested.
1174         // See: https://github.com/OpenZeppelin/openzeppelin-solidity/pull/522
1175         if (a == 0) {
1176             return 0;
1177         }
1178 
1179         uint256 c = a * b;
1180         require(c / a == b, "SafeMath: multiplication overflow");
1181 
1182         return c;
1183     }
1184 
1185     /**
1186      * @dev Returns the integer division of two unsigned integers. Reverts on
1187      * division by zero. The result is rounded towards zero.
1188      *
1189      * Counterpart to Solidity's `/` operator. Note: this function uses a
1190      * `revert` opcode (which leaves remaining gas untouched) while Solidity
1191      * uses an invalid opcode to revert (consuming all remaining gas).
1192      *
1193      * Requirements:
1194      * - The divisor cannot be zero.
1195      */
1196     function div(uint256 a, uint256 b) internal pure returns (uint256) {
1197         // Solidity only automatically asserts when dividing by 0
1198         require(b > 0, "SafeMath: division by zero");
1199         uint256 c = a / b;
1200         // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1201 
1202         return c;
1203     }
1204 
1205     /**
1206      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
1207      * Reverts when dividing by zero.
1208      *
1209      * Counterpart to Solidity's `%` operator. This function uses a `revert`
1210      * opcode (which leaves remaining gas untouched) while Solidity uses an
1211      * invalid opcode to revert (consuming all remaining gas).
1212      *
1213      * Requirements:
1214      * - The divisor cannot be zero.
1215      */
1216     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
1217         require(b != 0, "SafeMath: modulo by zero");
1218         return a % b;
1219     }
1220 }
1221 
1222 // File: openzeppelin-solidity/contracts/cryptography/ECDSA.sol
1223 
1224 pragma solidity ^0.5.0;
1225 
1226 /**
1227  * @dev Elliptic Curve Digital Signature Algorithm (ECDSA) operations.
1228  *
1229  * These functions can be used to verify that a message was signed by the holder
1230  * of the private keys of a given address.
1231  */
1232 library ECDSA {
1233     /**
1234      * @dev Returns the address that signed a hashed message (`hash`) with
1235      * `signature`. This address can then be used for verification purposes.
1236      *
1237      * The `ecrecover` EVM opcode allows for malleable (non-unique) signatures:
1238      * this function rejects them by requiring the `s` value to be in the lower
1239      * half order, and the `v` value to be either 27 or 28.
1240      *
1241      * (.note) This call _does not revert_ if the signature is invalid, or
1242      * if the signer is otherwise unable to be retrieved. In those scenarios,
1243      * the zero address is returned.
1244      *
1245      * (.warning) `hash` _must_ be the result of a hash operation for the
1246      * verification to be secure: it is possible to craft signatures that
1247      * recover to arbitrary addresses for non-hashed data. A safe way to ensure
1248      * this is by receiving a hash of the original message (which may otherwise)
1249      * be too long), and then calling `toEthSignedMessageHash` on it.
1250      */
1251     function recover(bytes32 hash, bytes memory signature) internal pure returns (address) {
1252         // Check the signature length
1253         if (signature.length != 65) {
1254             return (address(0));
1255         }
1256 
1257         // Divide the signature in r, s and v variables
1258         bytes32 r;
1259         bytes32 s;
1260         uint8 v;
1261 
1262         // ecrecover takes the signature parameters, and the only way to get them
1263         // currently is to use assembly.
1264         // solhint-disable-next-line no-inline-assembly
1265         assembly {
1266             r := mload(add(signature, 0x20))
1267             s := mload(add(signature, 0x40))
1268             v := byte(0, mload(add(signature, 0x60)))
1269         }
1270 
1271         // EIP-2 still allows signature malleability for ecrecover(). Remove this possibility and make the signature
1272         // unique. Appendix F in the Ethereum Yellow paper (https://ethereum.github.io/yellowpaper/paper.pdf), defines
1273         // the valid range for s in (281): 0 < s < secp256k1n ÷ 2 + 1, and for v in (282): v ∈ {27, 28}. Most
1274         // signatures from current libraries generate a unique signature with an s-value in the lower half order.
1275         //
1276         // If your library generates malleable signatures, such as s-values in the upper range, calculate a new s-value
1277         // with 0xFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFFEBAAEDCE6AF48A03BBFD25E8CD0364141 - s1 and flip v from 27 to 28 or
1278         // vice versa. If your library also generates signatures with 0/1 for v instead 27/28, add 27 to v to accept
1279         // these malleable signatures as well.
1280         if (uint256(s) > 0x7FFFFFFFFFFFFFFFFFFFFFFFFFFFFFFF5D576E7357A4501DDFE92F46681B20A0) {
1281             return address(0);
1282         }
1283 
1284         if (v != 27 && v != 28) {
1285             return address(0);
1286         }
1287 
1288         // If the signature is valid (and not malleable), return the signer address
1289         return ecrecover(hash, v, r, s);
1290     }
1291 
1292     /**
1293      * @dev Returns an Ethereum Signed Message, created from a `hash`. This
1294      * replicates the behavior of the
1295      * [`eth_sign`](https://github.com/ethereum/wiki/wiki/JSON-RPC#eth_sign)
1296      * JSON-RPC method.
1297      *
1298      * See `recover`.
1299      */
1300     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32) {
1301         // 32 is the length in bytes of hash,
1302         // enforced by the type signature above
1303         return keccak256(abi.encodePacked("\x19Ethereum Signed Message:\n32", hash));
1304     }
1305 }
1306 
1307 // File: contracts/RelayHub.sol
1308 
1309 pragma solidity ^0.5.5;
1310 
1311 
1312 
1313 
1314 
1315 
1316 
1317 
1318 contract RelayHub is IRelayHub {
1319 
1320     string constant commitId = "$Id: 5a82a94cecb1c32344dd239889272d1845035ef0 $";
1321 
1322     using ECDSA for bytes32;
1323 
1324     // Minimum stake a relay can have. An attack to the network will never cost less than half this value.
1325     uint256 constant private minimumStake = 1 ether;
1326 
1327     // Minimum unstake delay. A relay needs to wait for this time to elapse after deregistering to retrieve its stake.
1328     uint256 constant private minimumUnstakeDelay = 1 weeks;
1329     // Maximum unstake delay. Prevents relays from locking their funds into the RelayHub for too long.
1330     uint256 constant private maximumUnstakeDelay = 12 weeks;
1331 
1332     // Minimum balance required for a relay to register or re-register. Prevents user error in registering a relay that
1333     // will not be able to immediatly start serving requests.
1334     uint256 constant private minimumRelayBalance = 0.1 ether;
1335 
1336     // Maximum funds that can be deposited at once. Prevents user error by disallowing large deposits.
1337     uint256 constant private maximumRecipientDeposit = 2 ether;
1338 
1339     /**
1340     * the total gas overhead of relayCall(), before the first gasleft() and after the last gasleft().
1341     * Assume that relay has non-zero balance (costs 15'000 more otherwise).
1342     */
1343 
1344     // Gas cost of all relayCall() instructions before first gasleft() and after last gasleft()
1345     uint256 constant private gasOverhead = 48204;
1346 
1347     // Gas cost of all relayCall() instructions after first gasleft() and before last gasleft()
1348     uint256 constant private gasReserve = 100000;
1349 
1350     // Approximation of how much calling recipientCallsAtomic costs
1351     uint256 constant private recipientCallsAtomicOverhead = 5000;
1352 
1353     // Gas stipends for acceptRelayedCall, preRelayedCall and postRelayedCall
1354     uint256 constant private acceptRelayedCallMaxGas = 50000;
1355     uint256 constant private preRelayedCallMaxGas = 100000;
1356     uint256 constant private postRelayedCallMaxGas = 100000;
1357 
1358     // Nonces of senders, used to prevent replay attacks
1359     mapping(address => uint256) private nonces;
1360 
1361     enum AtomicRecipientCallsStatus {OK, CanRelayFailed, RelayedCallFailed, PreRelayedFailed, PostRelayedFailed}
1362 
1363     struct Relay {
1364         uint256 stake;          // Ether staked for this relay
1365         uint256 unstakeDelay;   // Time that must elapse before the owner can retrieve the stake after calling remove
1366         uint256 unstakeTime;    // Time when unstake will be callable. A value of zero indicates the relay has not been removed.
1367         address payable owner;  // Relay's owner, will receive revenue and manage it (call stake, remove and unstake).
1368         RelayState state;
1369     }
1370 
1371     mapping(address => Relay) private relays;
1372     mapping(address => uint256) private balances;
1373 
1374     string public version = "1.0.0";
1375 
1376     function stake(address relay, uint256 unstakeDelay) external payable {
1377         if (relays[relay].state == RelayState.Unknown) {
1378             require(msg.sender != relay, "relay cannot stake for itself");
1379             relays[relay].owner = msg.sender;
1380             relays[relay].state = RelayState.Staked;
1381 
1382         } else if ((relays[relay].state == RelayState.Staked) || (relays[relay].state == RelayState.Registered)) {
1383             require(relays[relay].owner == msg.sender, "not owner");
1384 
1385         } else {
1386             revert('wrong state for stake');
1387         }
1388 
1389         // Increase the stake
1390 
1391         uint256 addedStake = msg.value;
1392         relays[relay].stake += addedStake;
1393 
1394         // The added stake may be e.g. zero when only the unstake delay is being updated
1395         require(relays[relay].stake >= minimumStake, "stake lower than minimum");
1396 
1397         // Increase the unstake delay
1398 
1399         require(unstakeDelay >= minimumUnstakeDelay, "delay lower than minimum");
1400         require(unstakeDelay <= maximumUnstakeDelay, "delay higher than maximum");
1401 
1402         require(unstakeDelay >= relays[relay].unstakeDelay, "unstakeDelay cannot be decreased");
1403         relays[relay].unstakeDelay = unstakeDelay;
1404 
1405         emit Staked(relay, relays[relay].stake, relays[relay].unstakeDelay);
1406     }
1407 
1408     function registerRelay(uint256 transactionFee, string memory url) public {
1409         address relay = msg.sender;
1410 
1411         require(relay == tx.origin, "Contracts cannot register as relays");
1412         require(relays[relay].state == RelayState.Staked || relays[relay].state == RelayState.Registered, "wrong state for stake");
1413         require(relay.balance >= minimumRelayBalance, "balance lower than minimum");
1414 
1415         if (relays[relay].state != RelayState.Registered) {
1416             relays[relay].state = RelayState.Registered;
1417         }
1418 
1419         emit RelayAdded(relay, relays[relay].owner, transactionFee, relays[relay].stake, relays[relay].unstakeDelay, url);
1420     }
1421 
1422     function removeRelayByOwner(address relay) public {
1423         require(relays[relay].owner == msg.sender, "not owner");
1424         require((relays[relay].state == RelayState.Staked) || (relays[relay].state == RelayState.Registered), "already removed");
1425 
1426         // Start the unstake counter
1427         relays[relay].unstakeTime = relays[relay].unstakeDelay + now;
1428         relays[relay].state = RelayState.Removed;
1429 
1430         emit RelayRemoved(relay, relays[relay].unstakeTime);
1431     }
1432 
1433     function unstake(address relay) public {
1434         require(canUnstake(relay), "canUnstake failed");
1435         require(relays[relay].owner == msg.sender, "not owner");
1436 
1437         address payable owner = msg.sender;
1438         uint256 amount = relays[relay].stake;
1439 
1440         delete relays[relay];
1441 
1442         owner.transfer(amount);
1443         emit Unstaked(relay, amount);
1444     }
1445 
1446     function getRelay(address relay) external view returns (uint256 totalStake, uint256 unstakeDelay, uint256 unstakeTime, address payable owner, RelayState state) {
1447         totalStake = relays[relay].stake;
1448         unstakeDelay = relays[relay].unstakeDelay;
1449         unstakeTime = relays[relay].unstakeTime;
1450         owner = relays[relay].owner;
1451         state = relays[relay].state;
1452     }
1453 
1454     /**
1455      * deposit ether for a contract.
1456      * This ether will be used to repay relay calls into this contract.
1457      * Contract owner should monitor the balance of his contract, and make sure
1458      * to deposit more, otherwise the contract won't be able to receive relayed calls.
1459      * Unused deposited can be withdrawn with `withdraw()`
1460      */
1461     function depositFor(address target) public payable {
1462         uint256 amount = msg.value;
1463         require(amount <= maximumRecipientDeposit, "deposit too big");
1464 
1465         balances[target] = SafeMath.add(balances[target], amount);
1466 
1467         emit Deposited(target, msg.sender, amount);
1468     }
1469 
1470     //check the deposit balance of a contract.
1471     function balanceOf(address target) external view returns (uint256) {
1472         return balances[target];
1473     }
1474 
1475     /**
1476      * withdraw funds.
1477      * caller is either a relay owner, withdrawing collected transaction fees.
1478      * or a IRelayRecipient contract, withdrawing its deposit.
1479      * note that while everyone can `depositFor()` a contract, only
1480      * the contract itself can withdraw its funds.
1481      */
1482     function withdraw(uint256 amount, address payable dest) public {
1483         address payable account = msg.sender;
1484         require(balances[account] >= amount, "insufficient funds");
1485 
1486         balances[account] -= amount;
1487         dest.transfer(amount);
1488 
1489         emit Withdrawn(account, dest, amount);
1490     }
1491 
1492     function getNonce(address from) view external returns (uint256) {
1493         return nonces[from];
1494     }
1495 
1496     function canUnstake(address relay) public view returns (bool) {
1497         return relays[relay].unstakeTime > 0 && relays[relay].unstakeTime <= now;
1498         // Finished the unstaking delay period?
1499     }
1500 
1501     function canRelay(
1502         address relay,
1503         address from,
1504         address to,
1505         bytes memory encodedFunction,
1506         uint256 transactionFee,
1507         uint256 gasPrice,
1508         uint256 gasLimit,
1509         uint256 nonce,
1510         bytes memory signature,
1511         bytes memory approvalData
1512     )
1513     public view returns (uint256 status, bytes memory recipientContext)
1514     {
1515         // Verify the sender's signature on the transaction - note that approvalData is *not* signed
1516         {
1517             bytes memory packed = abi.encodePacked("rlx:", from, to, encodedFunction, transactionFee, gasPrice, gasLimit, nonce, address(this));
1518             bytes32 hashedMessage = keccak256(abi.encodePacked(packed, relay));
1519 
1520             if (hashedMessage.toEthSignedMessageHash().recover(signature) != from) {
1521                 return (uint256(PreconditionCheck.WrongSignature), "");
1522             }
1523         }
1524 
1525         // Verify the transaction is not being replayed
1526         if (nonces[from] != nonce) {
1527             return (uint256(PreconditionCheck.WrongNonce), "");
1528         }
1529 
1530         uint256 maxCharge = maxPossibleCharge(gasLimit, gasPrice, transactionFee);
1531         bytes memory encodedTx = abi.encodeWithSelector(IRelayRecipient(to).acceptRelayedCall.selector,
1532             relay, from, encodedFunction, transactionFee, gasPrice, gasLimit, nonce, approvalData, maxCharge
1533         );
1534 
1535         (bool success, bytes memory returndata) = to.staticcall.gas(acceptRelayedCallMaxGas)(encodedTx);
1536 
1537         if (!success) {
1538             return (uint256(PreconditionCheck.AcceptRelayedCallReverted), "");
1539         } else {
1540             (status, recipientContext) = abi.decode(returndata, (uint256, bytes));
1541 
1542             // This can be either PreconditionCheck.OK or a custom error code
1543             if ((status == 0) || (status > 10)) {
1544                 return (status, recipientContext);
1545             } else {
1546                 // Error codes [1-10] are reserved to RelayHub
1547                 return (uint256(PreconditionCheck.InvalidRecipientStatusCode), "");
1548             }
1549         }
1550     }
1551 
1552     /**
1553      * @notice Relay a transaction.
1554      *
1555      * @param from the client originating the request.
1556      * @param recipient the target IRelayRecipient contract.
1557      * @param encodedFunction the function call to relay.
1558      * @param transactionFee fee (%) the relay takes over actual gas cost.
1559      * @param gasPrice gas price the client is willing to pay
1560      * @param gasLimit limit the client want to put on its transaction
1561      * @param transactionFee fee (%) the relay takes over actual gas cost.
1562      * @param nonce sender's nonce (in nonces[])
1563      * @param signature client's signature over all params except approvalData
1564      * @param approvalData dapp-specific data
1565      */
1566     function relayCall(
1567         address from,
1568         address recipient,
1569         bytes memory encodedFunction,
1570         uint256 transactionFee,
1571         uint256 gasPrice,
1572         uint256 gasLimit,
1573         uint256 nonce,
1574         bytes memory signature,
1575         bytes memory approvalData
1576     )
1577     public
1578     {
1579         uint256 initialGas = gasleft();
1580 
1581         // Initial soundness checks - the relay must make sure these pass, or it will pay for a reverted transaction.
1582 
1583         // The relay must be registered
1584         require(relays[msg.sender].state == RelayState.Registered, "Unknown relay");
1585 
1586         // A relay may use a higher gas price than the one requested by the signer (to e.g. get the transaction in a
1587         // block faster), but it must not be lower. The recipient will be charged for the requested gas price, not the
1588         // one used in the transaction.
1589         require(gasPrice <= tx.gasprice, "Invalid gas price");
1590 
1591         // This transaction must have enough gas to forward the call to the recipient with the requested amount, and not
1592         // run out of gas later in this function.
1593         require(initialGas >= SafeMath.sub(requiredGas(gasLimit), gasOverhead), "Not enough gasleft()");
1594 
1595         // We don't yet know how much gas will be used by the recipient, so we make sure there are enough funds to pay
1596         // for the maximum possible charge.
1597         require(maxPossibleCharge(gasLimit, gasPrice, transactionFee) <= balances[recipient], "Recipient balance too low");
1598 
1599         bytes4 functionSelector = LibBytes.readBytes4(encodedFunction, 0);
1600 
1601         bytes memory recipientContext;
1602         {
1603             // We now verify the legitimacy of the transaction (it must be signed by the sender, and not be replayed),
1604             // and that the recpient will accept to be charged by it.
1605             uint256 preconditionCheck;
1606             (preconditionCheck, recipientContext) = canRelay(msg.sender, from, recipient, encodedFunction, transactionFee, gasPrice, gasLimit, nonce, signature, approvalData);
1607 
1608             if (preconditionCheck != uint256(PreconditionCheck.OK)) {
1609                 emit CanRelayFailed(msg.sender, from, recipient, functionSelector, preconditionCheck);
1610                 return;
1611             }
1612         }
1613 
1614         // From this point on, this transaction will not revert nor run out of gas, and the recipient will be charged
1615         // for the gas spent.
1616 
1617         // The sender's nonce is advanced to prevent transaction replays.
1618         nonces[from]++;
1619 
1620         // Calls to the recipient are performed atomically inside an inner transaction which may revert in case of
1621         // errors in the recipient. In either case (revert or regular execution) the return data encodes the
1622         // RelayCallStatus value.
1623         RelayCallStatus status;
1624         {
1625             uint256 preChecksGas = initialGas - gasleft();
1626             bytes memory encodedFunctionWithFrom = abi.encodePacked(encodedFunction, from);
1627             bytes memory data = abi.encodeWithSelector(this.recipientCallsAtomic.selector, recipient, encodedFunctionWithFrom, transactionFee, gasPrice, gasLimit, preChecksGas, recipientContext);
1628             (, bytes memory relayCallStatus) = address(this).call(data);
1629             status = abi.decode(relayCallStatus, (RelayCallStatus));
1630         }
1631 
1632         // We now perform the actual charge calculation, based on the measured gas used
1633         uint256 charge = calculateCharge(
1634             getChargeableGas(initialGas - gasleft(), false),
1635             gasPrice,
1636             transactionFee
1637         );
1638 
1639         // We've already checked that the recipient has enough balance to pay for the relayed transaction, this is only
1640         // a sanity check to prevent overflows in case of bugs.
1641         require(balances[recipient] >= charge, "Should not get here");
1642         balances[recipient] -= charge;
1643         balances[relays[msg.sender].owner] += charge;
1644 
1645         emit TransactionRelayed(msg.sender, from, recipient, functionSelector, status, charge);
1646     }
1647 
1648     struct AtomicData {
1649         uint256 atomicInitialGas;
1650         uint256 balanceBefore;
1651         bytes32 preReturnValue;
1652         bool relayedCallSuccess;
1653     }
1654 
1655     function recipientCallsAtomic(
1656         address recipient,
1657         bytes calldata encodedFunctionWithFrom,
1658         uint256 transactionFee,
1659         uint256 gasPrice,
1660         uint256 gasLimit,
1661         uint256 preChecksGas,
1662         bytes calldata recipientContext
1663     )
1664     external
1665     returns (RelayCallStatus)
1666     {
1667         AtomicData memory atomicData;
1668         atomicData.atomicInitialGas = gasleft(); // A new gas measurement is performed inside recipientCallsAtomic, since
1669         // due to EIP150 available gas amounts cannot be directly compared across external calls
1670 
1671         // This external function can only be called by RelayHub itself, creating an internal transaction. Calls to the
1672         // recipient (preRelayedCall, the relayedCall, and postRelayedCall) are called from inside this transaction.
1673         require(msg.sender == address(this), "Only RelayHub should call this function");
1674 
1675         // If either pre or post reverts, the whole internal transaction will be reverted, reverting all side effects on
1676         // the recipient. The recipient will still be charged for the used gas by the relay.
1677 
1678         // The recipient is no allowed to withdraw balance from RelayHub during a relayed transaction. We check pre and
1679         // post state to ensure this doesn't happen.
1680         atomicData.balanceBefore = balances[recipient];
1681 
1682         // First preRelayedCall is executed.
1683         {
1684             // Note: we open a new block to avoid growing the stack too much.
1685             bytes memory data = abi.encodeWithSelector(
1686                 IRelayRecipient(recipient).preRelayedCall.selector, recipientContext
1687             );
1688 
1689             // preRelayedCall may revert, but the recipient will still be charged: it should ensure in
1690             // acceptRelayedCall that this will not happen.
1691             (bool success, bytes memory retData) = recipient.call.gas(preRelayedCallMaxGas)(data);
1692 
1693             if (!success) {
1694                 revertWithStatus(RelayCallStatus.PreRelayedFailed);
1695             }
1696 
1697             atomicData.preReturnValue = abi.decode(retData, (bytes32));
1698         }
1699 
1700         // The actual relayed call is now executed. The sender's address is appended at the end of the transaction data
1701         (atomicData.relayedCallSuccess,) = recipient.call.gas(gasLimit)(encodedFunctionWithFrom);
1702 
1703         // Finally, postRelayedCall is executed, with the relayedCall execution's status and a charge estimate
1704         {
1705             bytes memory data;
1706             {
1707                 // We now determine how much the recipient will be charged, to pass this value to postRelayedCall for accurate
1708                 // accounting.
1709                 uint256 estimatedCharge = calculateCharge(
1710                     getChargeableGas(preChecksGas + atomicData.atomicInitialGas - gasleft(), true), // postRelayedCall is included in the charge
1711                     gasPrice,
1712                     transactionFee
1713                 );
1714 
1715                 data = abi.encodeWithSelector(
1716                     IRelayRecipient(recipient).postRelayedCall.selector,
1717                     recipientContext, atomicData.relayedCallSuccess, estimatedCharge, atomicData.preReturnValue
1718                 );
1719             }
1720 
1721             (bool successPost,) = recipient.call.gas(postRelayedCallMaxGas)(data);
1722 
1723             if (!successPost) {
1724                 revertWithStatus(RelayCallStatus.PostRelayedFailed);
1725             }
1726         }
1727 
1728         if (balances[recipient] < atomicData.balanceBefore) {
1729             revertWithStatus(RelayCallStatus.RecipientBalanceChanged);
1730         }
1731 
1732         return atomicData.relayedCallSuccess ? RelayCallStatus.OK : RelayCallStatus.RelayedCallFailed;
1733     }
1734 
1735     /**
1736      * @dev Reverts the transaction with returndata set to the ABI encoding of the status argument.
1737      */
1738     function revertWithStatus(RelayCallStatus status) private pure {
1739         bytes memory data = abi.encode(status);
1740 
1741         assembly {
1742             let dataSize := mload(data)
1743             let dataPtr := add(data, 32)
1744 
1745             revert(dataPtr, dataSize)
1746         }
1747     }
1748 
1749     function requiredGas(uint256 relayedCallStipend) public view returns (uint256) {
1750         return gasOverhead + gasReserve + acceptRelayedCallMaxGas + preRelayedCallMaxGas + postRelayedCallMaxGas + relayedCallStipend;
1751     }
1752 
1753     function maxPossibleCharge(uint256 relayedCallStipend, uint256 gasPrice, uint256 transactionFee) public view returns (uint256) {
1754         return calculateCharge(requiredGas(relayedCallStipend), gasPrice, transactionFee);
1755     }
1756 
1757     function calculateCharge(uint256 gas, uint256 gasPrice, uint256 fee) private pure returns (uint256) {
1758         // The fee is expressed as a percentage. E.g. a value of 40 stands for a 40% fee, so the recipient will be
1759         // charged for 1.4 times the spent amount.
1760         return (gas * gasPrice * (100 + fee)) / 100;
1761     }
1762 
1763     function getChargeableGas(uint256 gasUsed, bool postRelayedCallEstimation) private pure returns (uint256) {
1764         return gasOverhead + gasUsed + (postRelayedCallEstimation ? (postRelayedCallMaxGas + recipientCallsAtomicOverhead) : 0);
1765     }
1766 
1767     struct Transaction {
1768         uint256 nonce;
1769         uint256 gasPrice;
1770         uint256 gasLimit;
1771         address to;
1772         uint256 value;
1773         bytes data;
1774     }
1775 
1776     function decodeTransaction(bytes memory rawTransaction) private pure returns (Transaction memory transaction) {
1777         (transaction.nonce, transaction.gasPrice, transaction.gasLimit, transaction.to, transaction.value, transaction.data) = RLPReader.decodeTransaction(rawTransaction);
1778         return transaction;
1779 
1780     }
1781 
1782     function penalizeRepeatedNonce(bytes memory unsignedTx1, bytes memory signature1, bytes memory unsignedTx2, bytes memory signature2) public {
1783         // Can be called by anyone.
1784         // If a relay attacked the system by signing multiple transactions with the same nonce (so only one is accepted), anyone can grab both transactions from the blockchain and submit them here.
1785         // Check whether unsignedTx1 != unsignedTx2, that both are signed by the same address, and that unsignedTx1.nonce == unsignedTx2.nonce.  If all conditions are met, relay is considered an "offending relay".
1786         // The offending relay will be unregistered immediately, its stake will be forfeited and given to the address who reported it (msg.sender), thus incentivizing anyone to report offending relays.
1787         // If reported via a relay, the forfeited stake is split between msg.sender (the relay used for reporting) and the address that reported it.
1788 
1789         address addr1 = keccak256(abi.encodePacked(unsignedTx1)).recover(signature1);
1790         address addr2 = keccak256(abi.encodePacked(unsignedTx2)).recover(signature2);
1791 
1792         require(addr1 == addr2, "Different signer");
1793 
1794         Transaction memory decodedTx1 = decodeTransaction(unsignedTx1);
1795         Transaction memory decodedTx2 = decodeTransaction(unsignedTx2);
1796 
1797         //checking that the same nonce is used in both transaction, with both signed by the same address and the actual data is different
1798         // note: we compare the hash of the tx to save gas over iterating both byte arrays
1799         require(decodedTx1.nonce == decodedTx2.nonce, "Different nonce");
1800 
1801         bytes memory dataToCheck1 = abi.encodePacked(decodedTx1.data, decodedTx1.gasLimit, decodedTx1.to, decodedTx1.value);
1802         bytes memory dataToCheck2 = abi.encodePacked(decodedTx2.data, decodedTx2.gasLimit, decodedTx2.to, decodedTx2.value);
1803         require(keccak256(dataToCheck1) != keccak256(dataToCheck2), "tx is equal");
1804 
1805         penalize(addr1);
1806     }
1807 
1808     function penalizeIllegalTransaction(bytes memory unsignedTx, bytes memory signature) public {
1809         Transaction memory decodedTx = decodeTransaction(unsignedTx);
1810         if (decodedTx.to == address(this)) {
1811             bytes4 selector = GsnUtils.getMethodSig(decodedTx.data);
1812             // Note: If RelayHub's relay API is extended, the selectors must be added to the ones listed here
1813             require(selector != this.relayCall.selector && selector != this.registerRelay.selector, "Legal relay transaction");
1814         }
1815 
1816         address relay = keccak256(abi.encodePacked(unsignedTx)).recover(signature);
1817 
1818         penalize(relay);
1819     }
1820 
1821     function penalize(address relay) private {
1822         require((relays[relay].state == RelayState.Staked) ||
1823         (relays[relay].state == RelayState.Registered) ||
1824             (relays[relay].state == RelayState.Removed), "Unstaked relay");
1825 
1826         // Half of the stake will be burned (sent to address 0)
1827         uint256 totalStake = relays[relay].stake;
1828         uint256 toBurn = SafeMath.div(totalStake, 2);
1829         uint256 reward = SafeMath.sub(totalStake, toBurn);
1830 
1831         if (relays[relay].state == RelayState.Registered) {
1832             emit RelayRemoved(relay, now);
1833         }
1834 
1835         // The relay is deleted
1836         delete relays[relay];
1837 
1838         // Ether is burned and transferred
1839         address(0).transfer(toBurn);
1840         address payable reporter = msg.sender;
1841         reporter.transfer(reward);
1842 
1843         emit Penalized(relay, reporter, reward);
1844     }
1845 }