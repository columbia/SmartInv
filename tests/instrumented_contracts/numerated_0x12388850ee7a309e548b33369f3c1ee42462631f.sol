1 pragma solidity ^0.5.0;
2 
3 
4 contract IRelayRecipient {
5 
6     /**
7      * return the relayHub of this contract.
8      */
9     function getHubAddr() public view returns (address);
10 
11     /**
12      * return the contract's balance on the RelayHub.
13      * can be used to determine if the contract can pay for incoming calls,
14      * before making any.
15      */
16     function getRecipientBalance() public view returns (uint256);
17 
18     /*
19      * Called by Relay (and RelayHub), to validate if this recipient accepts this call.
20      * Note: Accepting this call means paying for the tx whether the relayed call reverted or not.
21      *
22      *  @return "0" if the the contract is willing to accept the charges from this sender, for this function call.
23      *      any other value is a failure. actual value is for diagnostics only.
24      *      ** Note: values below 10 are reserved by canRelay
25 
26      *  @param relay the relay that attempts to relay this function call.
27      *          the contract may restrict some encoded functions to specific known relays.
28      *  @param from the sender (signer) of this function call.
29      *  @param encodedFunction the encoded function call (without any ethereum signature).
30      *          the contract may check the method-id for valid methods
31      *  @param gasPrice - the gas price for this transaction
32      *  @param transactionFee - the relay compensation (in %) for this transaction
33      *  @param signature - sender's signature over all parameters except approvalData
34      *  @param approvalData - extra dapp-specific data (e.g. signature from trusted party)
35      */
36      function acceptRelayedCall(
37         address relay,
38         address from,
39         bytes calldata encodedFunction,
40         uint256 transactionFee,
41         uint256 gasPrice,
42         uint256 gasLimit,
43         uint256 nonce,
44         bytes calldata approvalData,
45         uint256 maxPossibleCharge
46     )
47     external
48     view
49     returns (uint256, bytes memory);
50 
51     /*
52      * modifier to be used by recipients as access control protection for preRelayedCall & postRelayedCall
53      */
54     modifier relayHubOnly() {
55         require(msg.sender == getHubAddr(),"Function can only be called by RelayHub");
56         _;
57     }
58 
59     /** this method is called before the actual relayed function call.
60      * It may be used to charge the caller before (in conjuction with refunding him later in postRelayedCall for example).
61      * the method is given all parameters of acceptRelayedCall and actual used gas.
62      *
63      *
64      *** NOTICE: if this method modifies the contract's state, it must be protected with access control i.e. require msg.sender == getHubAddr()
65      *
66      *
67      * Revert in this functions causes a revert of the client's relayed call but not in the entire transaction
68      * (that is, the relay will still get compensated)
69      */
70     function preRelayedCall(bytes calldata context) external returns (bytes32);
71 
72     /** this method is called after the actual relayed function call.
73      * It may be used to record the transaction (e.g. charge the caller by some contract logic) for this call.
74      * the method is given all parameters of acceptRelayedCall, and also the success/failure status and actual used gas.
75      *
76      *
77      *** NOTICE: if this method modifies the contract's state, it must be protected with access control i.e. require msg.sender == getHubAddr()
78      *
79      *
80      * @param success - true if the relayed call succeeded, false if it reverted
81      * @param actualCharge - estimation of how much the recipient will be charged. This information may be used to perform local booking and
82      *   charge the sender for this call (e.g. in tokens).
83      * @param preRetVal - preRelayedCall() return value passed back to the recipient
84      *
85      * Revert in this functions causes a revert of the client's relayed call but not in the entire transaction
86      * (that is, the relay will still get compensated)
87      */
88     function postRelayedCall(bytes calldata context, bool success, uint actualCharge, bytes32 preRetVal) external;
89 
90 }
91 
92 contract IRelayHub {
93     // Relay management
94 
95     // Add stake to a relay and sets its unstakeDelay.
96     // If the relay does not exist, it is created, and the caller
97     // of this function becomes its owner. If the relay already exists, only the owner can call this function. A relay
98     // cannot be its own owner.
99     // All Ether in this function call will be added to the relay's stake.
100     // Its unstake delay will be assigned to unstakeDelay, but the new value must be greater or equal to the current one.
101     // Emits a Staked event.
102     function stake(address relayaddr, uint256 unstakeDelay) external payable;
103 
104     // Emited when a relay's stake or unstakeDelay are increased
105     event Staked(address indexed relay, uint256 stake, uint256 unstakeDelay);
106 
107     // Registers the caller as a relay.
108     // The relay must be staked for, and not be a contract (i.e. this function must be called directly from an EOA).
109     // Emits a RelayAdded event.
110     // This function can be called multiple times, emitting new RelayAdded events. Note that the received transactionFee
111     // is not enforced by relayCall.
112     function registerRelay(uint256 transactionFee, string memory url) public;
113 
114     // Emitted when a relay is registered or re-registerd. Looking at these events (and filtering out RelayRemoved
115     // events) lets a client discover the list of available relays.
116     event RelayAdded(address indexed relay, address indexed owner, uint256 transactionFee, uint256 stake, uint256 unstakeDelay, string url);
117 
118     // Removes (deregisters) a relay. Unregistered (but staked for) relays can also be removed. Can only be called by
119     // the owner of the relay. After the relay's unstakeDelay has elapsed, unstake will be callable.
120     // Emits a RelayRemoved event.
121     function removeRelayByOwner(address relay) public;
122 
123     // Emitted when a relay is removed (deregistered). unstakeTime is the time when unstake will be callable.
124     event RelayRemoved(address indexed relay, uint256 unstakeTime);
125 
126     // Deletes the relay from the system, and gives back its stake to the owner. Can only be called by the relay owner,
127     // after unstakeDelay has elapsed since removeRelayByOwner was called.
128     // Emits an Unstaked event.
129     function unstake(address relay) public;
130 
131     // Emitted when a relay is unstaked for, including the returned stake.
132     event Unstaked(address indexed relay, uint256 stake);
133 
134     // States a relay can be in
135     enum RelayState {
136         Unknown, // The relay is unknown to the system: it has never been staked for
137         Staked, // The relay has been staked for, but it is not yet active
138         Registered, // The relay has registered itself, and is active (can relay calls)
139         Removed    // The relay has been removed by its owner and can no longer relay calls. It must wait for its unstakeDelay to elapse before it can unstake
140     }
141 
142     // Returns a relay's status. Note that relays can be deleted when unstaked or penalized.
143     function getRelay(address relay) external view returns (uint256 totalStake, uint256 unstakeDelay, uint256 unstakeTime, address payable owner, RelayState state);
144 
145     // Balance management
146 
147     // Deposits ether for a contract, so that it can receive (and pay for) relayed transactions. Unused balance can only
148     // be withdrawn by the contract itself, by callingn withdraw.
149     // Emits a Deposited event.
150     function depositFor(address target) public payable;
151 
152     // Emitted when depositFor is called, including the amount and account that was funded.
153     event Deposited(address indexed recipient, address indexed from, uint256 amount);
154 
155     // Returns an account's deposits. These can be either a contnract's funds, or a relay owner's revenue.
156     function balanceOf(address target) external view returns (uint256);
157 
158     // Withdraws from an account's balance, sending it back to it. Relay owners call this to retrieve their revenue, and
159     // contracts can also use it to reduce their funding.
160     // Emits a Withdrawn event.
161     function withdraw(uint256 amount, address payable dest) public;
162 
163     // Emitted when an account withdraws funds from RelayHub.
164     event Withdrawn(address indexed account, address indexed dest, uint256 amount);
165 
166     // Relaying
167 
168     // Check if the RelayHub will accept a relayed operation. Multiple things must be true for this to happen:
169     //  - all arguments must be signed for by the sender (from)
170     //  - the sender's nonce must be the current one
171     //  - the recipient must accept this transaction (via acceptRelayedCall)
172     // Returns a PreconditionCheck value (OK when the transaction can be relayed), or a recipient-specific error code if
173     // it returns one in acceptRelayedCall.
174     function canRelay(
175         address relay,
176         address from,
177         address to,
178         bytes memory encodedFunction,
179         uint256 transactionFee,
180         uint256 gasPrice,
181         uint256 gasLimit,
182         uint256 nonce,
183         bytes memory signature,
184         bytes memory approvalData
185     ) public view returns (uint256 status, bytes memory recipientContext);
186 
187     // Preconditions for relaying, checked by canRelay and returned as the corresponding numeric values.
188     enum PreconditionCheck {
189         OK,                         // All checks passed, the call can be relayed
190         WrongSignature,             // The transaction to relay is not signed by requested sender
191         WrongNonce,                 // The provided nonce has already been used by the sender
192         AcceptRelayedCallReverted,  // The recipient rejected this call via acceptRelayedCall
193         InvalidRecipientStatusCode  // The recipient returned an invalid (reserved) status code
194     }
195 
196     // Relays a transaction. For this to suceed, multiple conditions must be met:
197     //  - canRelay must return PreconditionCheck.OK
198     //  - the sender must be a registered relay
199     //  - the transaction's gas price must be larger or equal to the one that was requested by the sender
200     //  - the transaction must have enough gas to not run out of gas if all internal transactions (calls to the
201     // recipient) use all gas available to them
202     //  - the recipient must have enough balance to pay the relay for the worst-case scenario (i.e. when all gas is
203     // spent)
204     //
205     // If all conditions are met, the call will be relayed and the recipient charged. preRelayedCall, the encoded
206     // function and postRelayedCall will be called in order.
207     //
208     // Arguments:
209     //  - from: the client originating the request
210     //  - recipient: the target IRelayRecipient contract
211     //  - encodedFunction: the function call to relay, including data
212     //  - transactionFee: fee (%) the relay takes over actual gas cost
213     //  - gasPrice: gas price the client is willing to pay
214     //  - gasLimit: gas to forward when calling the encoded function
215     //  - nonce: client's nonce
216     //  - signature: client's signature over all previous params, plus the relay and RelayHub addresses
217     //  - approvalData: dapp-specific data forwared to acceptRelayedCall. This value is *not* verified by the Hub, but
218     //    it still can be used for e.g. a signature.
219     //
220     // Emits a TransactionRelayed event.
221     function relayCall(
222         address from,
223         address to,
224         bytes memory encodedFunction,
225         uint256 transactionFee,
226         uint256 gasPrice,
227         uint256 gasLimit,
228         uint256 nonce,
229         bytes memory signature,
230         bytes memory approvalData
231     ) public;
232 
233     // Emitted when an attempt to relay a call failed. This can happen due to incorrect relayCall arguments, or the
234     // recipient not accepting the relayed call. The actual relayed call was not executed, and the recipient not charged.
235     // The reason field contains an error code: values 1-10 correspond to PreconditionCheck entries, and values over 10
236     // are custom recipient error codes returned from acceptRelayedCall.
237     event CanRelayFailed(address indexed relay, address indexed from, address indexed to, bytes4 selector, uint256 reason);
238 
239     // Emitted when a transaction is relayed. Note that the actual encoded function might be reverted: this will be
240     // indicated in the status field.
241     // Useful when monitoring a relay's operation and relayed calls to a contract.
242     // Charge is the ether value deducted from the recipient's balance, paid to the relay's owner.
243     event TransactionRelayed(address indexed relay, address indexed from, address indexed to, bytes4 selector, RelayCallStatus status, uint256 charge);
244 
245     // Reason error codes for the TransactionRelayed event
246     enum RelayCallStatus {
247         OK,                      // The transaction was successfully relayed and execution successful - never included in the event
248         RelayedCallFailed,       // The transaction was relayed, but the relayed call failed
249         PreRelayedFailed,        // The transaction was not relayed due to preRelatedCall reverting
250         PostRelayedFailed,       // The transaction was relayed and reverted due to postRelatedCall reverting
251         RecipientBalanceChanged  // The transaction was relayed and reverted due to the recipient's balance changing
252     }
253 
254     // Returns how much gas should be forwarded to a call to relayCall, in order to relay a transaction that will spend
255     // up to relayedCallStipend gas.
256     function requiredGas(uint256 relayedCallStipend) public view returns (uint256);
257 
258     // Returns the maximum recipient charge, given the amount of gas forwarded, gas price and relay fee.
259     function maxPossibleCharge(uint256 relayedCallStipend, uint256 gasPrice, uint256 transactionFee) public view returns (uint256);
260 
261     // Relay penalization. Any account can penalize relays, removing them from the system immediately, and rewarding the
262     // reporter with half of the relay's stake. The other half is burned so that, even if the relay penalizes itself, it
263     // still loses half of its stake.
264 
265     // Penalize a relay that signed two transactions using the same nonce (making only the first one valid) and
266     // different data (gas price, gas limit, etc. may be different). The (unsigned) transaction data and signature for
267     // both transactions must be provided.
268     function penalizeRepeatedNonce(bytes memory unsignedTx1, bytes memory signature1, bytes memory unsignedTx2, bytes memory signature2) public;
269 
270     // Penalize a relay that sent a transaction that didn't target RelayHub's registerRelay or relayCall.
271     function penalizeIllegalTransaction(bytes memory unsignedTx, bytes memory signature) public;
272 
273     event Penalized(address indexed relay, address sender, uint256 amount);
274 
275     function getNonce(address from) view external returns (uint256);
276 }
277 
278 /*
279 
280   Copyright 2018 ZeroEx Intl.
281 
282   Licensed under the Apache License, Version 2.0 (the "License");
283   you may not use this file except in compliance with the License.
284   You may obtain a copy of the License at
285 
286     http://www.apache.org/licenses/LICENSE-2.0
287 
288   Unless required by applicable law or agreed to in writing, software
289   distributed under the License is distributed on an "AS IS" BASIS,
290   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
291   See the License for the specific language governing permissions and
292   limitations under the License.
293 
294 */
295 library LibBytes {
296 
297     using LibBytes for bytes;
298 
299     /// @dev Gets the memory address for a byte array.
300     /// @param input Byte array to lookup.
301     /// @return memoryAddress Memory address of byte array. This
302     ///         points to the header of the byte array which contains
303     ///         the length.
304     function rawAddress(bytes memory input)
305         internal
306         pure
307         returns (uint256 memoryAddress)
308     {
309         assembly {
310             memoryAddress := input
311         }
312         return memoryAddress;
313     }
314     
315     /// @dev Gets the memory address for the contents of a byte array.
316     /// @param input Byte array to lookup.
317     /// @return memoryAddress Memory address of the contents of the byte array.
318     function contentAddress(bytes memory input)
319         internal
320         pure
321         returns (uint256 memoryAddress)
322     {
323         assembly {
324             memoryAddress := add(input, 32)
325         }
326         return memoryAddress;
327     }
328 
329     /// @dev Copies `length` bytes from memory location `source` to `dest`.
330     /// @param dest memory address to copy bytes to.
331     /// @param source memory address to copy bytes from.
332     /// @param length number of bytes to copy.
333     function memCopy(
334         uint256 dest,
335         uint256 source,
336         uint256 length
337     )
338         internal
339         pure
340     {
341         if (length < 32) {
342             // Handle a partial word by reading destination and masking
343             // off the bits we are interested in.
344             // This correctly handles overlap, zero lengths and source == dest
345             assembly {
346                 let mask := sub(exp(256, sub(32, length)), 1)
347                 let s := and(mload(source), not(mask))
348                 let d := and(mload(dest), mask)
349                 mstore(dest, or(s, d))
350             }
351         } else {
352             // Skip the O(length) loop when source == dest.
353             if (source == dest) {
354                 return;
355             }
356 
357             // For large copies we copy whole words at a time. The final
358             // word is aligned to the end of the range (instead of after the
359             // previous) to handle partial words. So a copy will look like this:
360             //
361             //  ####
362             //      ####
363             //          ####
364             //            ####
365             //
366             // We handle overlap in the source and destination range by
367             // changing the copying direction. This prevents us from
368             // overwriting parts of source that we still need to copy.
369             //
370             // This correctly handles source == dest
371             //
372             if (source > dest) {
373                 assembly {
374                     // We subtract 32 from `sEnd` and `dEnd` because it
375                     // is easier to compare with in the loop, and these
376                     // are also the addresses we need for copying the
377                     // last bytes.
378                     length := sub(length, 32)
379                     let sEnd := add(source, length)
380                     let dEnd := add(dest, length)
381 
382                     // Remember the last 32 bytes of source
383                     // This needs to be done here and not after the loop
384                     // because we may have overwritten the last bytes in
385                     // source already due to overlap.
386                     let last := mload(sEnd)
387 
388                     // Copy whole words front to back
389                     // Note: the first check is always true,
390                     // this could have been a do-while loop.
391                     // solhint-disable-next-line no-empty-blocks
392                     for {} lt(source, sEnd) {} {
393                         mstore(dest, mload(source))
394                         source := add(source, 32)
395                         dest := add(dest, 32)
396                     }
397                     
398                     // Write the last 32 bytes
399                     mstore(dEnd, last)
400                 }
401             } else {
402                 assembly {
403                     // We subtract 32 from `sEnd` and `dEnd` because those
404                     // are the starting points when copying a word at the end.
405                     length := sub(length, 32)
406                     let sEnd := add(source, length)
407                     let dEnd := add(dest, length)
408 
409                     // Remember the first 32 bytes of source
410                     // This needs to be done here and not after the loop
411                     // because we may have overwritten the first bytes in
412                     // source already due to overlap.
413                     let first := mload(source)
414 
415                     // Copy whole words back to front
416                     // We use a signed comparisson here to allow dEnd to become
417                     // negative (happens when source and dest < 32). Valid
418                     // addresses in local memory will never be larger than
419                     // 2**255, so they can be safely re-interpreted as signed.
420                     // Note: the first check is always true,
421                     // this could have been a do-while loop.
422                     // solhint-disable-next-line no-empty-blocks
423                     for {} slt(dest, dEnd) {} {
424                         mstore(dEnd, mload(sEnd))
425                         sEnd := sub(sEnd, 32)
426                         dEnd := sub(dEnd, 32)
427                     }
428                     
429                     // Write the first 32 bytes
430                     mstore(dest, first)
431                 }
432             }
433         }
434     }
435 
436     /// @dev Returns a slices from a byte array.
437     /// @param b The byte array to take a slice from.
438     /// @param from The starting index for the slice (inclusive).
439     /// @param to The final index for the slice (exclusive).
440     /// @return result The slice containing bytes at indices [from, to)
441     function slice(
442         bytes memory b,
443         uint256 from,
444         uint256 to
445     )
446         internal
447         pure
448         returns (bytes memory result)
449     {
450         require(
451             from <= to,
452             "FROM_LESS_THAN_TO_REQUIRED"
453         );
454         require(
455             to <= b.length,
456             "TO_LESS_THAN_LENGTH_REQUIRED"
457         );
458         
459         // Create a new bytes structure and copy contents
460         result = new bytes(to - from);
461         memCopy(
462             result.contentAddress(),
463             b.contentAddress() + from,
464             result.length
465         );
466         return result;
467     }
468     
469     /// @dev Returns a slice from a byte array without preserving the input.
470     /// @param b The byte array to take a slice from. Will be destroyed in the process.
471     /// @param from The starting index for the slice (inclusive).
472     /// @param to The final index for the slice (exclusive).
473     /// @return result The slice containing bytes at indices [from, to)
474     /// @dev When `from == 0`, the original array will match the slice. In other cases its state will be corrupted.
475     function sliceDestructive(
476         bytes memory b,
477         uint256 from,
478         uint256 to
479     )
480         internal
481         pure
482         returns (bytes memory result)
483     {
484         require(
485             from <= to,
486             "FROM_LESS_THAN_TO_REQUIRED"
487         );
488         require(
489             to <= b.length,
490             "TO_LESS_THAN_LENGTH_REQUIRED"
491         );
492         
493         // Create a new bytes structure around [from, to) in-place.
494         assembly {
495             result := add(b, from)
496             mstore(result, sub(to, from))
497         }
498         return result;
499     }
500 
501     /// @dev Pops the last byte off of a byte array by modifying its length.
502     /// @param b Byte array that will be modified.
503     /// @return The byte that was popped off.
504     function popLastByte(bytes memory b)
505         internal
506         pure
507         returns (bytes1 result)
508     {
509         require(
510             b.length > 0,
511             "GREATER_THAN_ZERO_LENGTH_REQUIRED"
512         );
513 
514         // Store last byte.
515         result = b[b.length - 1];
516 
517         assembly {
518             // Decrement length of byte array.
519             let newLen := sub(mload(b), 1)
520             mstore(b, newLen)
521         }
522         return result;
523     }
524 
525     /// @dev Pops the last 20 bytes off of a byte array by modifying its length.
526     /// @param b Byte array that will be modified.
527     /// @return The 20 byte address that was popped off.
528     function popLast20Bytes(bytes memory b)
529         internal
530         pure
531         returns (address result)
532     {
533         require(
534             b.length >= 20,
535             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
536         );
537 
538         // Store last 20 bytes.
539         result = readAddress(b, b.length - 20);
540 
541         assembly {
542             // Subtract 20 from byte array length.
543             let newLen := sub(mload(b), 20)
544             mstore(b, newLen)
545         }
546         return result;
547     }
548 
549     /// @dev Tests equality of two byte arrays.
550     /// @param lhs First byte array to compare.
551     /// @param rhs Second byte array to compare.
552     /// @return True if arrays are the same. False otherwise.
553     function equals(
554         bytes memory lhs,
555         bytes memory rhs
556     )
557         internal
558         pure
559         returns (bool equal)
560     {
561         // Keccak gas cost is 30 + numWords * 6. This is a cheap way to compare.
562         // We early exit on unequal lengths, but keccak would also correctly
563         // handle this.
564         return lhs.length == rhs.length && keccak256(lhs) == keccak256(rhs);
565     }
566 
567     /// @dev Reads an address from a position in a byte array.
568     /// @param b Byte array containing an address.
569     /// @param index Index in byte array of address.
570     /// @return address from byte array.
571     function readAddress(
572         bytes memory b,
573         uint256 index
574     )
575         internal
576         pure
577         returns (address result)
578     {
579         require(
580             b.length >= index + 20,  // 20 is length of address
581             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
582         );
583 
584         // Add offset to index:
585         // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
586         // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
587         index += 20;
588 
589         // Read address from array memory
590         assembly {
591             // 1. Add index to address of bytes array
592             // 2. Load 32-byte word from memory
593             // 3. Apply 20-byte mask to obtain address
594             result := and(mload(add(b, index)), 0xffffffffffffffffffffffffffffffffffffffff)
595         }
596         return result;
597     }
598 
599     /// @dev Writes an address into a specific position in a byte array.
600     /// @param b Byte array to insert address into.
601     /// @param index Index in byte array of address.
602     /// @param input Address to put into byte array.
603     function writeAddress(
604         bytes memory b,
605         uint256 index,
606         address input
607     )
608         internal
609         pure
610     {
611         require(
612             b.length >= index + 20,  // 20 is length of address
613             "GREATER_OR_EQUAL_TO_20_LENGTH_REQUIRED"
614         );
615 
616         // Add offset to index:
617         // 1. Arrays are prefixed by 32-byte length parameter (add 32 to index)
618         // 2. Account for size difference between address length and 32-byte storage word (subtract 12 from index)
619         index += 20;
620 
621         // Store address into array memory
622         assembly {
623             // The address occupies 20 bytes and mstore stores 32 bytes.
624             // First fetch the 32-byte word where we'll be storing the address, then
625             // apply a mask so we have only the bytes in the word that the address will not occupy.
626             // Then combine these bytes with the address and store the 32 bytes back to memory with mstore.
627 
628             // 1. Add index to address of bytes array
629             // 2. Load 32-byte word from memory
630             // 3. Apply 12-byte mask to obtain extra bytes occupying word of memory where we'll store the address
631             let neighbors := and(
632                 mload(add(b, index)),
633                 0xffffffffffffffffffffffff0000000000000000000000000000000000000000
634             )
635             
636             // Make sure input address is clean.
637             // (Solidity does not guarantee this)
638             input := and(input, 0xffffffffffffffffffffffffffffffffffffffff)
639 
640             // Store the neighbors and address into memory
641             mstore(add(b, index), xor(input, neighbors))
642         }
643     }
644 
645     /// @dev Reads a bytes32 value from a position in a byte array.
646     /// @param b Byte array containing a bytes32 value.
647     /// @param index Index in byte array of bytes32 value.
648     /// @return bytes32 value from byte array.
649     function readBytes32(
650         bytes memory b,
651         uint256 index
652     )
653         internal
654         pure
655         returns (bytes32 result)
656     {
657         require(
658             b.length >= index + 32,
659             "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
660         );
661 
662         // Arrays are prefixed by a 256 bit length parameter
663         index += 32;
664 
665         // Read the bytes32 from array memory
666         assembly {
667             result := mload(add(b, index))
668         }
669         return result;
670     }
671 
672     /// @dev Writes a bytes32 into a specific position in a byte array.
673     /// @param b Byte array to insert <input> into.
674     /// @param index Index in byte array of <input>.
675     /// @param input bytes32 to put into byte array.
676     function writeBytes32(
677         bytes memory b,
678         uint256 index,
679         bytes32 input
680     )
681         internal
682         pure
683     {
684         require(
685             b.length >= index + 32,
686             "GREATER_OR_EQUAL_TO_32_LENGTH_REQUIRED"
687         );
688 
689         // Arrays are prefixed by a 256 bit length parameter
690         index += 32;
691 
692         // Read the bytes32 from array memory
693         assembly {
694             mstore(add(b, index), input)
695         }
696     }
697 
698     /// @dev Reads a uint256 value from a position in a byte array.
699     /// @param b Byte array containing a uint256 value.
700     /// @param index Index in byte array of uint256 value.
701     /// @return uint256 value from byte array.
702     function readUint256(
703         bytes memory b,
704         uint256 index
705     )
706         internal
707         pure
708         returns (uint256 result)
709     {
710         result = uint256(readBytes32(b, index));
711         return result;
712     }
713 
714     /// @dev Writes a uint256 into a specific position in a byte array.
715     /// @param b Byte array to insert <input> into.
716     /// @param index Index in byte array of <input>.
717     /// @param input uint256 to put into byte array.
718     function writeUint256(
719         bytes memory b,
720         uint256 index,
721         uint256 input
722     )
723         internal
724         pure
725     {
726         writeBytes32(b, index, bytes32(input));
727     }
728 
729     /// @dev Reads an unpadded bytes4 value from a position in a byte array.
730     /// @param b Byte array containing a bytes4 value.
731     /// @param index Index in byte array of bytes4 value.
732     /// @return bytes4 value from byte array.
733     function readBytes4(
734         bytes memory b,
735         uint256 index
736     )
737         internal
738         pure
739         returns (bytes4 result)
740     {
741         require(
742             b.length >= index + 4,
743             "GREATER_OR_EQUAL_TO_4_LENGTH_REQUIRED"
744         );
745 
746         // Arrays are prefixed by a 32 byte length field
747         index += 32;
748 
749         // Read the bytes4 from array memory
750         assembly {
751             result := mload(add(b, index))
752             // Solidity does not require us to clean the trailing bytes.
753             // We do it anyway
754             result := and(result, 0xFFFFFFFF00000000000000000000000000000000000000000000000000000000)
755         }
756         return result;
757     }
758 
759     /// @dev Reads nested bytes from a specific position.
760     /// @dev NOTE: the returned value overlaps with the input value.
761     ///            Both should be treated as immutable.
762     /// @param b Byte array containing nested bytes.
763     /// @param index Index of nested bytes.
764     /// @return result Nested bytes.
765     function readBytesWithLength(
766         bytes memory b,
767         uint256 index
768     )
769         internal
770         pure
771         returns (bytes memory result)
772     {
773         // Read length of nested bytes
774         uint256 nestedBytesLength = readUint256(b, index);
775         index += 32;
776 
777         // Assert length of <b> is valid, given
778         // length of nested bytes
779         require(
780             b.length >= index + nestedBytesLength,
781             "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"
782         );
783         
784         // Return a pointer to the byte array as it exists inside `b`
785         assembly {
786             result := add(b, index)
787         }
788         return result;
789     }
790 
791     /// @dev Inserts bytes at a specific position in a byte array.
792     /// @param b Byte array to insert <input> into.
793     /// @param index Index in byte array of <input>.
794     /// @param input bytes to insert.
795     function writeBytesWithLength(
796         bytes memory b,
797         uint256 index,
798         bytes memory input
799     )
800         internal
801         pure
802     {
803         // Assert length of <b> is valid, given
804         // length of input
805         require(
806             b.length >= index + 32 + input.length,  // 32 bytes to store length
807             "GREATER_OR_EQUAL_TO_NESTED_BYTES_LENGTH_REQUIRED"
808         );
809 
810         // Copy <input> into <b>
811         memCopy(
812             b.contentAddress() + index,
813             input.rawAddress(), // includes length of <input>
814             input.length + 32   // +32 bytes to store <input> length
815         );
816     }
817 
818     /// @dev Performs a deep copy of a byte array onto another byte array of greater than or equal length.
819     /// @param dest Byte array that will be overwritten with source bytes.
820     /// @param source Byte array to copy onto dest bytes.
821     function deepCopyBytes(
822         bytes memory dest,
823         bytes memory source
824     )
825         internal
826         pure
827     {
828         uint256 sourceLen = source.length;
829         // Dest length must be >= source length, or some bytes would not be copied.
830         require(
831             dest.length >= sourceLen,
832             "GREATER_OR_EQUAL_TO_SOURCE_BYTES_LENGTH_REQUIRED"
833         );
834         memCopy(
835             dest.contentAddress(),
836             source.contentAddress(),
837             sourceLen
838         );
839     }
840 }
841 
842 // Contract that implements the relay recipient protocol.  Inherited by Gatekeeper, or any other relay recipient.
843 //
844 // The recipient contract is responsible to:
845 // * pass a trusted IRelayHub singleton to the constructor.
846 // * Implement acceptRelayedCall, which acts as a whitelist/blacklist of senders.  It is advised that the recipient's owner will be able to update that list to remove abusers.
847 // * In every function that cares about the sender, use "address sender = getSender()" instead of msg.sender.  It'll return msg.sender for non-relayed transactions, or the real sender in case of relayed transactions.
848 contract RelayRecipient is IRelayRecipient {
849 
850     IRelayHub private relayHub; // The IRelayHub singleton which is allowed to call us
851 
852     function getHubAddr() public view returns (address) {
853         return address(relayHub);
854     }
855 
856     /**
857      * Initialize the RelayHub of this contract.
858      * Must be called at least once (e.g. from the constructor), so that the contract can accept relayed calls.
859      * For ownable contracts, there should be a method to update the RelayHub, in case a new hub is deployed (since
860      * the RelayHub itself is not upgradeable)
861      * Otherwise, the contract might be locked on a dead hub, with no relays.
862      */
863     function setRelayHub(IRelayHub _rhub) internal {
864         relayHub = _rhub;
865     }
866 
867     function getRelayHub() internal view returns (IRelayHub) {
868         return relayHub;
869     }
870 
871     /**
872      * return the balance of this contract.
873      * Note that this method will revert on configuration error (invalid relay address)
874      */
875     function getRecipientBalance() public view returns (uint) {
876         return getRelayHub().balanceOf(address(this));
877     }
878 
879     function getSenderFromData(address origSender, bytes memory msgData) public view returns (address) {
880         address sender = origSender;
881         if (origSender == getHubAddr()) {
882             // At this point we know that the sender is a trusted IRelayHub, so we trust that the last bytes of msg.data are the verified sender address.
883             // extract sender address from the end of msg.data
884             sender = LibBytes.readAddress(msgData, msgData.length - 20);
885         }
886         return sender;
887     }
888 
889     /**
890      * return the sender of this call.
891      * if the call came through the valid RelayHub, return the original sender.
892      * otherwise, return `msg.sender`
893      * should be used in the contract anywhere instead of msg.sender
894      */
895     function getSender() public view returns (address) {
896         return getSenderFromData(msg.sender, msg.data);
897     }
898 
899     function getMessageData() public view returns (bytes memory) {
900         bytes memory origMsgData = msg.data;
901         if (msg.sender == getHubAddr()) {
902             // At this point we know that the sender is a trusted IRelayHub, so we trust that the last bytes of msg.data are the verified sender address.
903             // extract original message data from the start of msg.data
904             origMsgData = new bytes(msg.data.length - 20);
905             for (uint256 i = 0; i < origMsgData.length; i++)
906             {
907                 origMsgData[i] = msg.data[i];
908             }
909         }
910         return origMsgData;
911     }
912 }
913 
914 //SPDX-License-Identifier: MIT License
915 // import "./RelayRecipient.sol";
916 // imports needed for artifact generation:
917 // import "@openeth/gsn/contracts/RelayHub.sol";
918 // import "./RelayHub.sol";
919 // import "./IRelayHub.sol";
920 contract Etheradz is RelayRecipient {
921         using SafeMath for *;
922 
923         address public owner;
924         address public masterAccount;
925         uint256 private houseFee = 4;
926         uint256 private poolTime = 24 hours;
927         uint256 private dailyWinPool = 5;
928         uint256 private whalepoolPercentage = 25;
929         uint256 private incomeTimes = 30;
930         uint256 private incomeDivide = 10;
931         uint256 public total_withdraw;
932         uint256 public roundID;
933         uint256 public currUserID;
934         uint256[4] private awardPercentage;
935 
936         struct Leaderboard {
937             uint256 amt;
938             address addr;
939         }
940 
941         Leaderboard[4] public topSponsors;
942 
943         Leaderboard[4] public lastTopSponsors;
944         uint256[4] public lastTopSponsorsWinningAmount;
945 
946         address[] public etherwhales;
947 
948 
949         mapping (uint => uint) public CYCLE_LIMIT;
950         mapping (address => bool) public isEtherWhale;
951         mapping (uint => address) public userList;
952         mapping (uint256 => DataStructs.DailyRound) public round;
953         mapping (address => DataStructs.User) public player;
954         mapping (address => uint256) public playerTotEarnings;
955         mapping (address => mapping (uint256 => DataStructs.PlayerDailyRounds)) public plyrRnds_;
956 
957         /****************************  EVENTS   *****************************************/
958 
959         event registerUserEvent(address indexed _playerAddress, address indexed _referrer);
960         event investmentEvent(address indexed _playerAddress, uint256 indexed _amount);
961         event premiumInvestmentEvent(address indexed _playerAddress, uint256 indexed _amount, uint256 _investedAmount);
962         event referralCommissionEvent(address indexed _playerAddress, address indexed _referrer, uint256 indexed amount, uint256 _type);
963         event withdrawEvent(address indexed _playerAddress, uint256 indexed amount, uint256 indexed timeStamp);
964         event roundAwardsEvent(address indexed _playerAddress, uint256 indexed _amount);
965         event etherWhaleAwardEvent(address indexed _playerAddress, uint256 indexed amount, uint256 indexed timeStamp);
966         event premiumReferralCommissionEvent(address indexed _playerAddress, address indexed _referrer, uint256 indexed amount, uint256 timeStamp);
967 
968 
969         constructor (
970           address _owner,
971           address _masterAccount,
972           IRelayHub _gsnRelayHub
973         )
974         public {
975              owner = _owner;
976              masterAccount = _masterAccount;
977              setRelayHub(_gsnRelayHub);
978              roundID = 1;
979              round[1].startTime = now;
980              round[1].endTime = now + poolTime;
981              awardPercentage[0] = 40;
982              awardPercentage[1] = 30;
983              awardPercentage[2] = 20;
984              awardPercentage[3] = 10;
985              currUserID = 0;
986 
987              CYCLE_LIMIT[1]=10 ether;
988              CYCLE_LIMIT[2]=25 ether;
989              CYCLE_LIMIT[3]=100 ether;
990              CYCLE_LIMIT[4]=250 ether;
991 
992              currUserID++;
993              player[masterAccount].id = currUserID;
994              userList[currUserID] = masterAccount;
995 
996         }
997 
998         function changeHub(IRelayHub _hubAddr)
999         public
1000         onlyOwner {
1001             setRelayHub(_hubAddr);
1002         }
1003 
1004         function acceptRelayedCall(
1005             address relay,
1006             address from,
1007             bytes calldata encodedFunction,
1008             uint256 transactionFee,
1009             uint256 gasPrice,
1010             uint256 gasLimit,
1011             uint256 nonce,
1012             bytes calldata approvalData,
1013             uint256 maxPossibleCharge
1014         )
1015         external
1016         view
1017         returns (uint256, bytes memory) {
1018           if ( isUser(from) ) return (0, '');
1019 
1020           return (10, '');
1021         }
1022 
1023         //nothing to be done post-call. still, we must implement this method.
1024         function preRelayedCall(bytes calldata context) external returns (bytes32){
1025     		return '';
1026         }
1027 
1028         function postRelayedCall(bytes calldata context, bool success, uint actualCharge, bytes32 preRetVal) external {
1029         }
1030 
1031         function isUser(address _addr)
1032         public view returns (bool) {
1033             return player[_addr].id > 0;
1034         }
1035 
1036         /****************************  MODIFIERS    *****************************************/
1037 
1038 
1039         /**
1040          * @dev sets boundaries for incoming tx
1041          */
1042         modifier isMinimumAmount(uint256 _eth) {
1043             require(_eth >= 100000000000000000, "Minimum contribution amount is 0.1 ETH");
1044             _;
1045         }
1046 
1047         /**
1048          * @dev sets permissible values for incoming tx
1049          */
1050         modifier isallowedValue(uint256 _eth) {
1051             require(_eth % 100000000000000000 == 0, "multiples of 0.1 ETH please");
1052             _;
1053         }
1054 
1055         /**
1056          * @dev allows only the user to run the function
1057          */
1058         modifier onlyOwner() {
1059             require(getSender() == owner, "only Owner");
1060             _;
1061         }
1062 
1063         modifier requireUser() { require(isUser(getSender())); _; }
1064 
1065 
1066         /****************************  MAIN LOGIC    *****************************************/
1067 
1068         //function to maintain the business logic
1069         function registerUser(uint256 _referrerID)
1070         public
1071         isMinimumAmount(msg.value)
1072         isallowedValue(msg.value)
1073         payable {
1074 
1075             require(_referrerID > 0 && _referrerID <= currUserID, "Incorrect Referrer ID");
1076             address _referrer = userList[_referrerID];
1077 
1078             uint256 amount = msg.value;
1079             if (player[getSender()].id <= 0) { //if player is a new joinee
1080             require(amount <= CYCLE_LIMIT[1], "Can't send more than the limit");
1081 
1082                 currUserID++;
1083                 player[getSender()].id = currUserID;
1084                 player[getSender()].depositTime = now;
1085                 player[getSender()].currInvestment = amount;
1086                 player[getSender()].incomeLimitLeft = amount.mul(incomeTimes).div(incomeDivide);
1087                 player[getSender()].totalInvestment = amount;
1088                 player[getSender()].referrer = _referrer;
1089                 player[getSender()].cycle = 1;
1090                 userList[currUserID] = getSender();
1091 
1092                 player[_referrer].referralCount = player[_referrer].referralCount.add(1);
1093 
1094                 plyrRnds_[_referrer][roundID].ethVolume = plyrRnds_[_referrer][roundID].ethVolume.add(amount);
1095                 addSponsorToPool(_referrer);
1096                 directsReferralBonus(getSender(), amount);
1097 
1098 
1099                   emit registerUserEvent(getSender(), _referrer);
1100             }
1101                 //if the user is old
1102             else {
1103 
1104                 player[getSender()].cycle = player[getSender()].cycle.add(1);
1105 
1106                 require(player[getSender()].incomeLimitLeft == 0, "limit is still remaining");
1107 
1108                 require(amount >= (player[getSender()].currInvestment.mul(2) >= 250 ether ? 250 ether : player[getSender()].currInvestment.mul(2)));
1109                 require(amount <= CYCLE_LIMIT[player[getSender()].cycle > 4 ? 4 : player[getSender()].cycle], "Please send correct amount");
1110 
1111                 _referrer = player[getSender()].referrer;
1112 
1113                 if(amount == 250 ether) {
1114                     if(isEtherWhale[getSender()] == false){
1115                         isEtherWhale[getSender()] == true;
1116                         etherwhales.push(getSender());
1117                     }
1118                     player[getSender()].incomeLimitLeft = amount.mul(20).div(incomeDivide);
1119                 }
1120                 else {
1121                     player[getSender()].incomeLimitLeft = amount.mul(incomeTimes).div(incomeDivide);
1122                 }
1123 
1124                 player[getSender()].depositTime = now;
1125                 player[getSender()].dailyIncome = 0;
1126                 player[getSender()].currInvestment = amount;
1127                 player[getSender()].totalInvestment = player[getSender()].totalInvestment.add(amount);
1128 
1129                 plyrRnds_[_referrer][roundID].ethVolume = plyrRnds_[_referrer][roundID].ethVolume.add(amount);
1130                 addSponsorToPool(_referrer);
1131                 directsReferralBonus(getSender(), amount);
1132 
1133             }
1134 
1135                 round[roundID].pool = round[roundID].pool.add(amount.mul(dailyWinPool).div(100));
1136                 round[roundID].whalepool = round[roundID].whalepool.add(amount.mul(whalepoolPercentage).div(incomeDivide).div(100));
1137 
1138                 address payable ownerAddr = address(uint160(owner));
1139                 ownerAddr.transfer(amount.mul(houseFee).div(100));
1140 
1141                 if (now > round[roundID].endTime && round[roundID].ended == false) {
1142                     startNextRound();
1143                 }
1144 
1145                 emit investmentEvent (getSender(), amount);
1146         }
1147 
1148 
1149         function directsReferralBonus(address _playerAddress, uint256 amount)
1150         private
1151         {
1152             address _nextReferrer = player[_playerAddress].referrer;
1153             uint i;
1154 
1155             for(i=0; i < 5; i++) {
1156 
1157                 if (_nextReferrer != address(0x0)) {
1158                     //referral commission to level 1
1159                     if(i == 0) {
1160                             player[_nextReferrer].directsIncome = player[_nextReferrer].directsIncome.add(amount.mul(10).div(100));
1161                             emit referralCommissionEvent(_playerAddress,  _nextReferrer, amount.mul(10).div(100), 1);
1162                         }
1163                     else if(i == 1 ) {
1164                         if(player[_nextReferrer].referralCount >= 2) {
1165                             player[_nextReferrer].directsIncome = player[_nextReferrer].directsIncome.add(amount.mul(2).div(100));
1166                             emit referralCommissionEvent(_playerAddress,  _nextReferrer, amount.mul(2).div(100), 1);
1167                         }
1168                     }
1169                     //referral commission from level 3-5
1170                     else {
1171                         if(player[_nextReferrer].referralCount >= i+1) {
1172                            player[_nextReferrer].directsIncome = player[_nextReferrer].directsIncome.add(amount.mul(1).div(100));
1173                            emit referralCommissionEvent(_playerAddress,  _nextReferrer, amount.mul(1).div(100), 1);
1174                         }
1175                     }
1176                 }
1177                 else {
1178                     break;
1179                 }
1180                 _nextReferrer = player[_nextReferrer].referrer;
1181             }
1182         }
1183 
1184 
1185         //function to manage the referral commission from the daily ROI
1186         function roiReferralBonus(address _playerAddress, uint256 amount)
1187         private
1188         {
1189             address _nextReferrer = player[_playerAddress].referrer;
1190             uint i;
1191 
1192             for(i=0; i < 20; i++) {
1193 
1194                 if (_nextReferrer != address(0x0)) {
1195                     if(i == 0) {
1196                        player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(amount.mul(30).div(100));
1197                        emit referralCommissionEvent(_playerAddress,  _nextReferrer, amount.mul(30).div(100), 2);
1198                     }
1199                     //for user 2-5
1200                     else if(i > 0 && i < 5) {
1201                         if(player[_nextReferrer].referralCount >= i+1) {
1202                             player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(amount.mul(10).div(100));
1203                             emit referralCommissionEvent(_playerAddress,  _nextReferrer, amount.mul(10).div(100), 2);
1204                         }
1205                     }
1206                     //for users 6-10
1207                     else if(i > 4 && i < 10) {
1208                         if(player[_nextReferrer].referralCount >= i+1) {
1209                             player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(amount.mul(8).div(100));
1210                             emit referralCommissionEvent(_playerAddress,  _nextReferrer, amount.mul(8).div(100), 2);
1211                         }
1212                     }
1213                     //for user 11-15
1214                     else if(i > 9 && i < 15) {
1215                         if(player[_nextReferrer].referralCount >= i+1) {
1216                             player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(amount.mul(5).div(100));
1217                             emit referralCommissionEvent(_playerAddress,  _nextReferrer, amount.mul(5).div(100), 2);
1218                         }
1219                     }
1220                     else { // for users 16-20
1221                         if(player[_nextReferrer].referralCount >= i+1) {
1222                             player[_nextReferrer].roiReferralIncome = player[_nextReferrer].roiReferralIncome.add(amount.mul(1).div(100));
1223                             emit referralCommissionEvent(_playerAddress,  _nextReferrer, amount.mul(1).div(100), 2);
1224                         }
1225                     }
1226                 }
1227                 else {
1228                         break;
1229                     }
1230                 _nextReferrer = player[_nextReferrer].referrer;
1231             }
1232         }
1233 
1234 
1235 
1236         //function to allow users to withdraw their earnings
1237         function withdrawEarnings()
1238         requireUser
1239         public {
1240             (uint256 to_payout) = this.payoutOf(getSender());
1241 
1242             require(player[getSender()].incomeLimitLeft > 0, "Limit not available");
1243 
1244             // Deposit payout
1245             if(to_payout > 0) {
1246                 if(to_payout > player[getSender()].incomeLimitLeft) {
1247                     to_payout = player[getSender()].incomeLimitLeft;
1248                 }
1249 
1250                 player[getSender()].dailyIncome += to_payout;
1251                 player[getSender()].incomeLimitLeft -= to_payout;
1252 
1253                 roiReferralBonus(getSender(), to_payout);
1254             }
1255 
1256             // Direct sponsor bonus
1257             if(player[getSender()].incomeLimitLeft > 0 && player[getSender()].directsIncome > 0) {
1258                 uint256 direct_bonus = player[getSender()].directsIncome;
1259 
1260                 if(direct_bonus > player[getSender()].incomeLimitLeft) {
1261                     direct_bonus = player[getSender()].incomeLimitLeft;
1262                 }
1263 
1264                 player[getSender()].directsIncome -= direct_bonus;
1265                 player[getSender()].incomeLimitLeft -= direct_bonus;
1266                 to_payout += direct_bonus;
1267             }
1268 
1269             // // Pool payout
1270             if(player[getSender()].incomeLimitLeft > 0 && player[getSender()].sponsorPoolIncome > 0) {
1271                 uint256 pool_bonus = player[getSender()].sponsorPoolIncome;
1272 
1273                 if(pool_bonus > player[getSender()].incomeLimitLeft) {
1274                     pool_bonus = player[getSender()].incomeLimitLeft;
1275                 }
1276 
1277                 player[getSender()].sponsorPoolIncome -= pool_bonus;
1278                 player[getSender()].incomeLimitLeft -= pool_bonus;
1279                 to_payout += pool_bonus;
1280             }
1281 
1282             // Match payout
1283             if(player[getSender()].incomeLimitLeft > 0  && player[getSender()].roiReferralIncome > 0) {
1284                 uint256 match_bonus = player[getSender()].roiReferralIncome;
1285 
1286                 if(match_bonus > player[getSender()].incomeLimitLeft) {
1287                     match_bonus = player[getSender()].incomeLimitLeft;
1288                 }
1289 
1290                 player[getSender()].roiReferralIncome -= match_bonus;
1291                 player[getSender()].incomeLimitLeft -= match_bonus;
1292                 to_payout += match_bonus;
1293             }
1294 
1295             //Whale pool Payout
1296             if(player[getSender()].incomeLimitLeft > 0  && player[getSender()].whalepoolAward > 0) {
1297                 uint256 whale_bonus = player[getSender()].whalepoolAward;
1298 
1299                 if(whale_bonus > player[getSender()].incomeLimitLeft) {
1300                     whale_bonus = player[getSender()].incomeLimitLeft;
1301                 }
1302 
1303                 player[getSender()].whalepoolAward -= whale_bonus;
1304                 player[getSender()].incomeLimitLeft -= whale_bonus;
1305                 to_payout += whale_bonus;
1306             }
1307 
1308             //Premium Adz Referral incomeLimitLeft
1309             if(player[getSender()].incomeLimitLeft > 0  && player[getSender()].premiumReferralIncome > 0) {
1310                 uint256 premium_bonus = player[getSender()].premiumReferralIncome;
1311 
1312                 if(premium_bonus > player[getSender()].incomeLimitLeft) {
1313                     premium_bonus = player[getSender()].incomeLimitLeft;
1314                 }
1315 
1316                 player[getSender()].premiumReferralIncome -= premium_bonus;
1317                 player[getSender()].incomeLimitLeft -= premium_bonus;
1318                 to_payout += premium_bonus;
1319             }
1320 
1321             require(to_payout > 0, "Zero payout");
1322 
1323             playerTotEarnings[getSender()] += to_payout;
1324             total_withdraw += to_payout;
1325 
1326             address payable senderAddr = address(uint160(getSender()));
1327             senderAddr.transfer(to_payout);
1328 
1329              emit withdrawEvent(getSender(), to_payout, now);
1330 
1331         }
1332 
1333         function payoutOf(address _addr) view external returns(uint256 payout) {
1334             uint256  earningsLimitLeft = player[_addr].incomeLimitLeft;
1335 
1336             if(player[_addr].incomeLimitLeft > 0 ) {
1337                 payout = (player[_addr].currInvestment * ((block.timestamp - player[_addr].depositTime) / 1 days) / 100) - player[_addr].dailyIncome;
1338 
1339                 if(player[_addr].dailyIncome + payout > earningsLimitLeft) {
1340                     payout = earningsLimitLeft;
1341                 }
1342             }
1343         }
1344 
1345 
1346         //To start the new round for daily pool
1347         function startNextRound()
1348         private
1349          {
1350 
1351             uint256 _roundID = roundID;
1352 
1353             uint256 _poolAmount = round[roundID].pool;
1354 
1355                 if (_poolAmount >= 10 ether) {
1356                     round[_roundID].ended = true;
1357                     uint256 distributedSponsorAwards = awardTopPromoters();
1358                     
1359 
1360                     if(etherwhales.length > 0)
1361                         awardEtherwhales();
1362                         
1363                     uint256 _whalePoolAmount = round[roundID].whalepool;
1364 
1365                     _roundID++;
1366                     roundID++;
1367                     round[_roundID].startTime = now;
1368                     round[_roundID].endTime = now.add(poolTime);
1369                     round[_roundID].pool = _poolAmount.sub(distributedSponsorAwards);
1370                     round[_roundID].whalepool = _whalePoolAmount;
1371                 }
1372                 else {
1373                     round[_roundID].startTime = now;
1374                     round[_roundID].endTime = now.add(poolTime);
1375                     round[_roundID].pool = _poolAmount;
1376                 }
1377         }
1378 
1379 
1380         function addSponsorToPool(address _add)
1381             private
1382             returns (bool)
1383         {
1384             if (_add == address(0x0)){
1385                 return false;
1386             }
1387 
1388             uint256 _amt = plyrRnds_[_add][roundID].ethVolume;
1389             // if the amount is less than the last on the leaderboard pool, reject
1390             if (topSponsors[3].amt >= _amt){
1391                 return false;
1392             }
1393 
1394             address firstAddr = topSponsors[0].addr;
1395             uint256 firstAmt = topSponsors[0].amt;
1396 
1397             address secondAddr = topSponsors[1].addr;
1398             uint256 secondAmt = topSponsors[1].amt;
1399 
1400             address thirdAddr = topSponsors[2].addr;
1401             uint256 thirdAmt = topSponsors[2].amt;
1402 
1403 
1404 
1405             // if the user should be at the top
1406             if (_amt > topSponsors[0].amt){
1407 
1408                 if (topSponsors[0].addr == _add){
1409                     topSponsors[0].amt = _amt;
1410                     return true;
1411                 }
1412                 //if user is at the second position already and will come on first
1413                 else if (topSponsors[1].addr == _add){
1414 
1415                     topSponsors[0].addr = _add;
1416                     topSponsors[0].amt = _amt;
1417                     topSponsors[1].addr = firstAddr;
1418                     topSponsors[1].amt = firstAmt;
1419                     return true;
1420                 }
1421                 //if user is at the third position and will come on first
1422                 else if (topSponsors[2].addr == _add) {
1423                     topSponsors[0].addr = _add;
1424                     topSponsors[0].amt = _amt;
1425                     topSponsors[1].addr = firstAddr;
1426                     topSponsors[1].amt = firstAmt;
1427                     topSponsors[2].addr = secondAddr;
1428                     topSponsors[2].amt = secondAmt;
1429                     return true;
1430                 }
1431                 else{
1432 
1433                     topSponsors[0].addr = _add;
1434                     topSponsors[0].amt = _amt;
1435                     topSponsors[1].addr = firstAddr;
1436                     topSponsors[1].amt = firstAmt;
1437                     topSponsors[2].addr = secondAddr;
1438                     topSponsors[2].amt = secondAmt;
1439                     topSponsors[3].addr = thirdAddr;
1440                     topSponsors[3].amt = thirdAmt;
1441                     return true;
1442                 }
1443             }
1444             // if the user should be at the second position
1445             else if (_amt > topSponsors[1].amt){
1446 
1447                 if (topSponsors[1].addr == _add){
1448                     topSponsors[1].amt = _amt;
1449                     return true;
1450                 }
1451                 //if user is at the third position, move it to second
1452                 else if(topSponsors[2].addr == _add) {
1453                     topSponsors[1].addr = _add;
1454                     topSponsors[1].amt = _amt;
1455                     topSponsors[2].addr = secondAddr;
1456                     topSponsors[2].amt = secondAmt;
1457                     return true;
1458                 }
1459                 else{
1460                     topSponsors[1].addr = _add;
1461                     topSponsors[1].amt = _amt;
1462                     topSponsors[2].addr = secondAddr;
1463                     topSponsors[2].amt = secondAmt;
1464                     topSponsors[3].addr = thirdAddr;
1465                     topSponsors[3].amt = thirdAmt;
1466                     return true;
1467                 }
1468             }
1469             //if the user should be at third position
1470             else if(_amt > topSponsors[2].amt){
1471                 if(topSponsors[2].addr == _add) {
1472                     topSponsors[2].amt = _amt;
1473                     return true;
1474                 }
1475                 else {
1476                     topSponsors[2].addr = _add;
1477                     topSponsors[2].amt = _amt;
1478                     topSponsors[3].addr = thirdAddr;
1479                     topSponsors[3].amt = thirdAmt;
1480                 }
1481             }
1482             // if the user should be at the fourth position
1483             else if (_amt > topSponsors[3].amt){
1484 
1485                  if (topSponsors[3].addr == _add){
1486                     topSponsors[3].amt = _amt;
1487                     return true;
1488                 }
1489 
1490                 else{
1491                     topSponsors[3].addr = _add;
1492                     topSponsors[3].amt = _amt;
1493                     return true;
1494                 }
1495             }
1496         }
1497 
1498         function awardTopPromoters()
1499             private
1500             returns (uint256)
1501             {
1502                 uint256 totAmt = round[roundID].pool.mul(10).div(100);
1503                 uint256 distributedAmount;
1504                 uint256 i;
1505 
1506 
1507                 for (i = 0; i< 4; i++) {
1508                     if (topSponsors[i].addr != address(0x0)) {
1509                         player[topSponsors[i].addr].sponsorPoolIncome = player[topSponsors[i].addr].sponsorPoolIncome.add(totAmt.mul(awardPercentage[i]).div(100));
1510                         distributedAmount = distributedAmount.add(totAmt.mul(awardPercentage[i]).div(100));
1511                         emit roundAwardsEvent(topSponsors[i].addr, totAmt.mul(awardPercentage[i]).div(100));
1512 
1513                         lastTopSponsors[i].addr = topSponsors[i].addr;
1514                         lastTopSponsors[i].amt = topSponsors[i].amt;
1515                         lastTopSponsorsWinningAmount[i] = totAmt.mul(awardPercentage[i]).div(100);
1516                         topSponsors[i].addr = address(0x0);
1517                         topSponsors[i].amt = 0;
1518                     }
1519                     else {
1520                         break;
1521                     }
1522                 }
1523 
1524                 return distributedAmount;
1525             }
1526 
1527         function awardEtherwhales()
1528         private
1529         {
1530             uint256 totalWhales = etherwhales.length;
1531 
1532             uint256 toPayout = round[roundID].whalepool.div(totalWhales);
1533             for(uint256 i = 0; i < totalWhales; i++) {
1534                 player[etherwhales[i]].whalepoolAward = player[etherwhales[i]].whalepoolAward.add(toPayout);
1535                 emit etherWhaleAwardEvent(etherwhales[i], toPayout, now);
1536             }
1537             round[roundID].whalepool = 0;
1538         }
1539 
1540         function premiumInvestment()
1541         public
1542         payable {
1543 
1544             uint256 amount = msg.value;
1545 
1546             premiumReferralIncomeDistribution(getSender(), amount);
1547 
1548             address payable ownerAddr = address(uint160(owner));
1549             ownerAddr.transfer(amount.mul(5).div(100));
1550             emit premiumInvestmentEvent(getSender(), amount, player[getSender()].currInvestment);
1551         }
1552 
1553         function premiumReferralIncomeDistribution(address _playerAddress, uint256 amount)
1554         private {
1555             address _nextReferrer = player[_playerAddress].referrer;
1556             uint i;
1557 
1558             for(i=0; i < 5; i++) {
1559 
1560                 if (_nextReferrer != address(0x0)) {
1561                     //referral commission to level 1
1562                     if(i == 0) {
1563                         player[_nextReferrer].premiumReferralIncome = player[_nextReferrer].premiumReferralIncome.add(amount.mul(20).div(100));
1564                         emit premiumReferralCommissionEvent(_playerAddress, _nextReferrer, amount.mul(20).div(100), now);
1565                     }
1566 
1567                     else if(i == 1 ) {
1568                         if(player[_nextReferrer].referralCount >= 2) {
1569                             player[_nextReferrer].premiumReferralIncome = player[_nextReferrer].premiumReferralIncome.add(amount.mul(10).div(100));
1570                             emit premiumReferralCommissionEvent(_playerAddress, _nextReferrer, amount.mul(10).div(100), now);
1571                         }
1572                     }
1573 
1574                     //referral commission from level 3-5
1575                     else {
1576                         if(player[_nextReferrer].referralCount >= i+1) {
1577                             player[_nextReferrer].premiumReferralIncome = player[_nextReferrer].premiumReferralIncome.add(amount.mul(5).div(100));
1578                             emit premiumReferralCommissionEvent(_playerAddress, _nextReferrer, amount.mul(5).div(100), now);
1579                         }
1580                     }
1581                 }
1582                 else {
1583                     break;
1584                 }
1585                 _nextReferrer = player[_nextReferrer].referrer;
1586             }
1587         }
1588 
1589 
1590         function drawPool() external onlyOwner {
1591             startNextRound();
1592         }
1593 }
1594 
1595 library SafeMath {
1596         /**
1597          * @dev Returns the addition of two unsigned integers, reverting on
1598          * overflow.
1599          *
1600          * Counterpart to Solidity's `+` operator.
1601          *
1602          * Requirements:
1603          * - Addition cannot overflow.
1604          */
1605         function add(uint256 a, uint256 b) internal pure returns (uint256) {
1606             uint256 c = a + b;
1607             require(c >= a, "SafeMath: addition overflow");
1608 
1609             return c;
1610         }
1611 
1612         /**
1613          * @dev Returns the subtraction of two unsigned integers, reverting on
1614          * overflow (when the result is negative).
1615          *
1616          * Counterpart to Solidity's `-` operator.
1617          *
1618          * Requirements:
1619          * - Subtraction cannot overflow.
1620          */
1621         function sub(uint256 a, uint256 b) internal pure returns (uint256) {
1622             return sub(a, b, "SafeMath: subtraction overflow");
1623         }
1624 
1625         /**
1626          * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
1627          * overflow (when the result is negative).
1628          *
1629          * Counterpart to Solidity's `-` operator.
1630          *
1631          * Requirements:
1632          * - Subtraction cannot overflow.
1633          *
1634          * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
1635          * @dev Get it via `npm install @openzeppelin/contracts@next`.
1636          */
1637         function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1638             require(b <= a, errorMessage);
1639             uint256 c = a - b;
1640 
1641             return c;
1642         }
1643 
1644         /**
1645          * @dev Returns the multiplication of two unsigned integers, reverting on
1646          * overflow.
1647          *
1648          * Counterpart to Solidity's `*` operator.
1649          *
1650          * Requirements:
1651          * - Multiplication cannot overflow.
1652          */
1653         function mul(uint256 a, uint256 b) internal pure returns (uint256) {
1654             // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
1655             // benefit is lost if 'b' is also tested.
1656             // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
1657             if (a == 0) {
1658                 return 0;
1659             }
1660 
1661             uint256 c = a * b;
1662             require(c / a == b, "SafeMath: multiplication overflow");
1663 
1664             return c;
1665         }
1666 
1667         /**
1668          * @dev Returns the integer division of two unsigned integers. Reverts on
1669          * division by zero. The result is rounded towards zero.
1670          *
1671          * Counterpart to Solidity's `/` operator. Note: this function uses a
1672          * `revert` opcode (which leaves remaining gas untouched) while Solidity
1673          * uses an invalid opcode to revert (consuming all remaining gas).
1674          *
1675          * Requirements:
1676          * - The divisor cannot be zero.
1677          */
1678         function div(uint256 a, uint256 b) internal pure returns (uint256) {
1679             return div(a, b, "SafeMath: division by zero");
1680         }
1681 
1682         /**
1683          * @dev Returns the integer division of two unsigned integers. Reverts with custom message on
1684          * division by zero. The result is rounded towards zero.
1685          *
1686          * Counterpart to Solidity's `/` operator. Note: this function uses a
1687          * `revert` opcode (which leaves remaining gas untouched) while Solidity
1688          * uses an invalid opcode to revert (consuming all remaining gas).
1689          *
1690          * Requirements:
1691          * - The divisor cannot be zero.
1692          * NOTE: This is a feature of the next version of OpenZeppelin Contracts.
1693          * @dev Get it via `npm install @openzeppelin/contracts@next`.
1694          */
1695         function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
1696             // Solidity only automatically asserts when dividing by 0
1697             require(b > 0, errorMessage);
1698             uint256 c = a / b;
1699             // assert(a == b * c + a % b); // There is no case in which this doesn't hold
1700 
1701             return c;
1702         }
1703     }
1704 
1705 library DataStructs {
1706 
1707             struct DailyRound {
1708                 uint256 startTime;
1709                 uint256 endTime;
1710                 bool ended; //has daily round ended
1711                 uint256 pool; //amount in the pool
1712                 uint256 whalepool; //deposits for whalepool
1713             }
1714 
1715             struct User {
1716                 uint256 id;
1717                 uint256 totalInvestment;
1718                 uint256 directsIncome;
1719                 uint256 roiReferralIncome;
1720                 uint256 currInvestment;
1721                 uint256 dailyIncome;
1722                 uint256 depositTime;
1723                 uint256 incomeLimitLeft;
1724                 uint256 sponsorPoolIncome;
1725                 uint256 referralCount;
1726                 address referrer;
1727                 uint256 cycle;
1728                 uint256 whalepoolAward;
1729                 uint256 premiumReferralIncome;
1730             }
1731 
1732             struct PlayerDailyRounds {
1733                 uint256 ethVolume;
1734             }
1735     }