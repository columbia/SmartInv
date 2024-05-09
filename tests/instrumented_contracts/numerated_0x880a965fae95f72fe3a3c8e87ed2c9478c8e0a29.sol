1 // SPDX-License-Identifier: MIT
2 
3 // File: solady/src/utils/SafeTransferLib.sol
4 
5 
6 pragma solidity ^0.8.4;
7 
8 /// @notice Safe ETH and ERC20 transfer library that gracefully handles missing return values.
9 /// @author Solady (https://github.com/vectorized/solady/blob/main/src/utils/SafeTransferLib.sol)
10 /// @author Modified from Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/SafeTransferLib.sol)
11 /// @dev Caution! This library won't check that a token has code, responsibility is delegated to the caller.
12 library SafeTransferLib {
13     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
14     /*                       CUSTOM ERRORS                        */
15     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
16 
17     error ETHTransferFailed();
18 
19     error TransferFromFailed();
20 
21     error TransferFailed();
22 
23     error ApproveFailed();
24 
25     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
26     /*                       ETH OPERATIONS                       */
27     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
28 
29     function safeTransferETH(address to, uint256 amount) internal {
30         assembly {
31             // Transfer the ETH and check if it succeeded or not.
32             if iszero(call(gas(), to, amount, 0, 0, 0, 0)) {
33                 // Store the function selector of `ETHTransferFailed()`.
34                 mstore(0x00, 0xb12d13eb)
35                 // Revert with (offset, size).
36                 revert(0x1c, 0x04)
37             }
38         }
39     }
40 
41     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
42     /*                      ERC20 OPERATIONS                      */
43     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
44 
45     function safeTransferFrom(
46         address token,
47         address from,
48         address to,
49         uint256 amount
50     ) internal {
51         assembly {
52             // We'll write our calldata to this slot below, but restore it later.
53             let memPointer := mload(0x40)
54 
55             // Write the abi-encoded calldata into memory, beginning with the function selector.
56             mstore(0x00, 0x23b872dd)
57             mstore(0x20, from) // Append the "from" argument.
58             mstore(0x40, to) // Append the "to" argument.
59             mstore(0x60, amount) // Append the "amount" argument.
60 
61             if iszero(
62                 and(
63                     // Set success to whether the call reverted, if not we check it either
64                     // returned exactly 1 (can't just be non-zero data), or had no return data.
65                     or(eq(mload(0x00), 1), iszero(returndatasize())),
66                     // We use 0x64 because that's the total length of our calldata (0x04 + 0x20 * 3)
67                     // Counterintuitively, this call() must be positioned after the or() in the
68                     // surrounding and() because and() evaluates its arguments from right to left.
69                     call(gas(), token, 0, 0x1c, 0x64, 0x00, 0x20)
70                 )
71             ) {
72                 // Store the function selector of `TransferFromFailed()`.
73                 mstore(0x00, 0x7939f424)
74                 // Revert with (offset, size).
75                 revert(0x1c, 0x04)
76             }
77 
78             mstore(0x60, 0) // Restore the zero slot to zero.
79             mstore(0x40, memPointer) // Restore the memPointer.
80         }
81     }
82 
83     function safeTransfer(
84         address token,
85         address to,
86         uint256 amount
87     ) internal {
88         assembly {
89             // We'll write our calldata to this slot below, but restore it later.
90             let memPointer := mload(0x40)
91 
92             // Write the abi-encoded calldata into memory, beginning with the function selector.
93             mstore(0x00, 0xa9059cbb)
94             mstore(0x20, to) // Append the "to" argument.
95             mstore(0x40, amount) // Append the "amount" argument.
96 
97             if iszero(
98                 and(
99                     // Set success to whether the call reverted, if not we check it either
100                     // returned exactly 1 (can't just be non-zero data), or had no return data.
101                     or(eq(mload(0x00), 1), iszero(returndatasize())),
102                     // We use 0x44 because that's the total length of our calldata (0x04 + 0x20 * 2)
103                     // Counterintuitively, this call() must be positioned after the or() in the
104                     // surrounding and() because and() evaluates its arguments from right to left.
105                     call(gas(), token, 0, 0x1c, 0x44, 0x00, 0x20)
106                 )
107             ) {
108                 // Store the function selector of `TransferFailed()`.
109                 mstore(0x00, 0x90b8ec18)
110                 // Revert with (offset, size).
111                 revert(0x1c, 0x04)
112             }
113 
114             mstore(0x40, memPointer) // Restore the memPointer.
115         }
116     }
117 
118     function safeApprove(
119         address token,
120         address to,
121         uint256 amount
122     ) internal {
123         assembly {
124             // We'll write our calldata to this slot below, but restore it later.
125             let memPointer := mload(0x40)
126 
127             // Write the abi-encoded calldata into memory, beginning with the function selector.
128             mstore(0x00, 0x095ea7b3)
129             mstore(0x20, to) // Append the "to" argument.
130             mstore(0x40, amount) // Append the "amount" argument.
131 
132             if iszero(
133                 and(
134                     // Set success to whether the call reverted, if not we check it either
135                     // returned exactly 1 (can't just be non-zero data), or had no return data.
136                     or(eq(mload(0x00), 1), iszero(returndatasize())),
137                     // We use 0x44 because that's the total length of our calldata (0x04 + 0x20 * 2)
138                     // Counterintuitively, this call() must be positioned after the or() in the
139                     // surrounding and() because and() evaluates its arguments from right to left.
140                     call(gas(), token, 0, 0x1c, 0x44, 0x00, 0x20)
141                 )
142             ) {
143                 // Store the function selector of `ApproveFailed()`.
144                 mstore(0x00, 0x3e3f8f73)
145                 // Revert with (offset, size).
146                 revert(0x1c, 0x04)
147             }
148 
149             mstore(0x40, memPointer) // Restore the memPointer.
150         }
151     }
152 }
153 
154 // File: solady/src/utils/LibString.sol
155 
156 
157 pragma solidity ^0.8.4;
158 
159 /// @notice Library for converting numbers into strings and other string operations.
160 /// @author Solady (https://github.com/vectorized/solady/blob/main/src/utils/LibString.sol)
161 /// @author Modified from Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/LibString.sol)
162 library LibString {
163     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
164     /*                        CUSTOM ERRORS                       */
165     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
166 
167     error HexLengthInsufficient();
168 
169     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
170     /*                     DECIMAL OPERATIONS                     */
171     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
172 
173     function toString(uint256 value) internal pure returns (string memory str) {
174         assembly {
175             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
176             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
177             // We will need 1 32-byte word to store the length,
178             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
179             str := add(mload(0x40), 0x80)
180             // Update the free memory pointer to allocate.
181             mstore(0x40, str)
182 
183             // Cache the end of the memory to calculate the length later.
184             let end := str
185 
186             // We write the string from rightmost digit to leftmost digit.
187             // The following is essentially a do-while loop that also handles the zero case.
188             // prettier-ignore
189             for { let temp := value } 1 {} {
190                 str := sub(str, 1)
191                 // Write the character to the pointer.
192                 // The ASCII index of the '0' character is 48.
193                 mstore8(str, add(48, mod(temp, 10)))
194                 // Keep dividing `temp` until zero.
195                 temp := div(temp, 10)
196                 // prettier-ignore
197                 if iszero(temp) { break }
198             }
199 
200             let length := sub(end, str)
201             // Move the pointer 32 bytes leftwards to make room for the length.
202             str := sub(str, 0x20)
203             // Store the length.
204             mstore(str, length)
205         }
206     }
207 
208     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
209     /*                   HEXADECIMAL OPERATIONS                   */
210     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
211 
212     function toHexString(uint256 value, uint256 length) internal pure returns (string memory str) {
213         assembly {
214             let start := mload(0x40)
215             // We need length * 2 bytes for the digits, 2 bytes for the prefix,
216             // and 32 bytes for the length. We add 32 to the total and round down
217             // to a multiple of 32. (32 + 2 + 32) = 66.
218             str := add(start, and(add(shl(1, length), 66), not(31)))
219 
220             // Cache the end to calculate the length later.
221             let end := str
222 
223             // Allocate the memory.
224             mstore(0x40, str)
225             // Store "0123456789abcdef" in scratch space.
226             mstore(0x0f, 0x30313233343536373839616263646566)
227 
228             let temp := value
229             // We write the string from rightmost digit to leftmost digit.
230             // The following is essentially a do-while loop that also handles the zero case.
231             // prettier-ignore
232             for {} 1 {} {
233                 str := sub(str, 2)
234                 mstore8(add(str, 1), mload(and(temp, 15)))
235                 mstore8(str, mload(and(shr(4, temp), 15)))
236                 temp := shr(8, temp)
237                 length := sub(length, 1)
238                 // prettier-ignore
239                 if iszero(length) { break }
240             }
241 
242             if temp {
243                 // Store the function selector of `HexLengthInsufficient()`.
244                 mstore(0x00, 0x2194895a)
245                 // Revert with (offset, size).
246                 revert(0x1c, 0x04)
247             }
248 
249             // Compute the string's length.
250             let strLength := add(sub(end, str), 2)
251             // Move the pointer and write the "0x" prefix.
252             str := sub(str, 0x20)
253             mstore(str, 0x3078)
254             // Move the pointer and write the length.
255             str := sub(str, 2)
256             mstore(str, strLength)
257         }
258     }
259 
260     function toHexString(uint256 value) internal pure returns (string memory str) {
261         assembly {
262             let start := mload(0x40)
263             // We need 0x20 bytes for the length, 0x02 bytes for the prefix,
264             // and 0x40 bytes for the digits.
265             // The next multiple of 0x20 above (0x20 + 2 + 0x40) is 0x80.
266             str := add(start, 0x80)
267 
268             // Cache the end to calculate the length later.
269             let end := str
270 
271             // Allocate the memory.
272             mstore(0x40, str)
273             // Store "0123456789abcdef" in scratch space.
274             mstore(0x0f, 0x30313233343536373839616263646566)
275 
276             // We write the string from rightmost digit to leftmost digit.
277             // The following is essentially a do-while loop that also handles the zero case.
278             // prettier-ignore
279             for { let temp := value } 1 {} {
280                 str := sub(str, 2)
281                 mstore8(add(str, 1), mload(and(temp, 15)))
282                 mstore8(str, mload(and(shr(4, temp), 15)))
283                 temp := shr(8, temp)
284                 // prettier-ignore
285                 if iszero(temp) { break }
286             }
287 
288             // Compute the string's length.
289             let strLength := add(sub(end, str), 2)
290             // Move the pointer and write the "0x" prefix.
291             str := sub(str, 0x20)
292             mstore(str, 0x3078)
293             // Move the pointer and write the length.
294             str := sub(str, 2)
295             mstore(str, strLength)
296         }
297     }
298 
299     function toHexString(address value) internal pure returns (string memory str) {
300         assembly {
301             let start := mload(0x40)
302             // We need 32 bytes for the length, 2 bytes for the prefix,
303             // and 40 bytes for the digits.
304             // The next multiple of 32 above (32 + 2 + 40) is 96.
305             str := add(start, 96)
306 
307             // Allocate the memory.
308             mstore(0x40, str)
309             // Store "0123456789abcdef" in scratch space.
310             mstore(0x0f, 0x30313233343536373839616263646566)
311 
312             let length := 20
313             // We write the string from rightmost digit to leftmost digit.
314             // The following is essentially a do-while loop that also handles the zero case.
315             // prettier-ignore
316             for { let temp := value } 1 {} {
317                 str := sub(str, 2)
318                 mstore8(add(str, 1), mload(and(temp, 15)))
319                 mstore8(str, mload(and(shr(4, temp), 15)))
320                 temp := shr(8, temp)
321                 length := sub(length, 1)
322                 // prettier-ignore
323                 if iszero(length) { break }
324             }
325 
326             // Move the pointer and write the "0x" prefix.
327             str := sub(str, 32)
328             mstore(str, 0x3078)
329             // Move the pointer and write the length.
330             str := sub(str, 2)
331             mstore(str, 42)
332         }
333     }
334 
335     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
336     /*                   OTHER STRING OPERATIONS                  */
337     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
338 
339     function replace(
340         string memory subject,
341         string memory search,
342         string memory replacement
343     ) internal pure returns (string memory result) {
344         assembly {
345             let subjectLength := mload(subject)
346             let searchLength := mload(search)
347             let replacementLength := mload(replacement)
348 
349             subject := add(subject, 0x20)
350             search := add(search, 0x20)
351             replacement := add(replacement, 0x20)
352             result := add(mload(0x40), 0x20)
353 
354             let subjectEnd := add(subject, subjectLength)
355             if iszero(gt(searchLength, subjectLength)) {
356                 let subjectSearchEnd := add(sub(subjectEnd, searchLength), 1)
357                 let h := 0
358                 if iszero(lt(searchLength, 32)) {
359                     h := keccak256(search, searchLength)
360                 }
361                 let m := shl(3, sub(32, and(searchLength, 31)))
362                 let s := mload(search)
363                 // prettier-ignore
364                 for {} 1 {} {
365                     let t := mload(subject)
366                     // Whether the first `searchLength % 32` bytes of 
367                     // `subject` and `search` matches.
368                     if iszero(shr(m, xor(t, s))) {
369                         if h {
370                             if iszero(eq(keccak256(subject, searchLength), h)) {
371                                 mstore(result, t)
372                                 result := add(result, 1)
373                                 subject := add(subject, 1)
374                                 // prettier-ignore
375                                 if iszero(lt(subject, subjectSearchEnd)) { break }
376                                 continue
377                             }
378                         }
379                         // Copy the `replacement` one word at a time.
380                         // prettier-ignore
381                         for { let o := 0 } 1 {} {
382                             mstore(add(result, o), mload(add(replacement, o)))
383                             o := add(o, 0x20)
384                             // prettier-ignore
385                             if iszero(lt(o, replacementLength)) { break }
386                         }
387                         result := add(result, replacementLength)
388                         subject := add(subject, searchLength)    
389                         if iszero(searchLength) {
390                             mstore(result, t)
391                             result := add(result, 1)
392                             subject := add(subject, 1)
393                         }
394                         // prettier-ignore
395                         if iszero(lt(subject, subjectSearchEnd)) { break }
396                         continue
397                     }
398                     mstore(result, t)
399                     result := add(result, 1)
400                     subject := add(subject, 1)
401                     // prettier-ignore
402                     if iszero(lt(subject, subjectSearchEnd)) { break }
403                 }
404             }
405 
406             let resultRemainder := result
407             result := add(mload(0x40), 0x20)
408             let k := add(sub(resultRemainder, result), sub(subjectEnd, subject))
409             // Copy the rest of the string one word at a time.
410             // prettier-ignore
411             for {} lt(subject, subjectEnd) {} {
412                 mstore(resultRemainder, mload(subject))
413                 resultRemainder := add(resultRemainder, 0x20)
414                 subject := add(subject, 0x20)
415             }
416             // Allocate memory for the length and the bytes,
417             // rounded up to a multiple of 32.
418             mstore(0x40, add(result, and(add(k, 0x40), not(0x1f))))
419             result := sub(result, 0x20)
420             mstore(result, k)
421         }
422     }
423 }
424 
425 // File: solady/src/utils/ECDSA.sol
426 
427 
428 pragma solidity ^0.8.4;
429 
430 /// @notice Gas optimized ECDSA wrapper.
431 /// @author Solady (https://github.com/vectorized/solady/blob/main/src/utils/ECDSA.sol)
432 /// @author Modified from Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/ECDSA.sol)
433 /// @author Modified from OpenZeppelin (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/ECDSA.sol)
434 library ECDSA {
435     function recover(bytes32 hash, bytes calldata signature) internal view returns (address result) {
436         assembly {
437             // Copy the free memory pointer so that we can restore it later.
438             let m := mload(0x40)
439             // Directly load `s` from the calldata.
440             let s := calldataload(add(signature.offset, 0x20))
441 
442             switch signature.length
443             case 64 {
444                 // Here, `s` is actually `vs` that needs to be recovered into `v` and `s`.
445                 // Compute `v` and store it in the scratch space.
446                 mstore(0x20, add(shr(255, s), 27))
447                 // prettier-ignore
448                 s := and(s, 0x7fffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff)
449             }
450             case 65 {
451                 // Compute `v` and store it in the scratch space.
452                 mstore(0x20, byte(0, calldataload(add(signature.offset, 0x40))))
453             }
454 
455             // If `s` in lower half order, such that the signature is not malleable.
456             // prettier-ignore
457             if iszero(gt(s, 0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0)) {
458                 mstore(0x00, hash)
459                 calldatacopy(0x40, signature.offset, 0x20) // Directly copy `r` over.
460                 mstore(0x60, s)
461                 pop(
462                     staticcall(
463                         gas(), // Amount of gas left for the transaction.
464                         0x01, // Address of `ecrecover`.
465                         0x00, // Start of input.
466                         0x80, // Size of input.
467                         0x40, // Start of output.
468                         0x20 // Size of output.
469                     )
470                 )
471                 // Restore the zero slot.
472                 mstore(0x60, 0)
473                 // `returndatasize()` will be `0x20` upon success, and `0x00` otherwise.
474                 result := mload(sub(0x60, returndatasize()))
475             }
476             // Restore the free memory pointer.
477             mstore(0x40, m)
478         }
479     }
480 
481     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32 result) {
482         assembly {
483             // Store into scratch space for keccak256.
484             mstore(0x20, hash)
485             mstore(0x00, "\x00\x00\x00\x00\x19Ethereum Signed Message:\n32")
486             // 0x40 - 0x04 = 0x3c
487             result := keccak256(0x04, 0x3c)
488         }
489     }
490 
491     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32 result) {
492         assembly {
493             // We need at most 128 bytes for Ethereum signed message header.
494             // The max length of the ASCII reprenstation of a uint256 is 78 bytes.
495             // The length of "\x19Ethereum Signed Message:\n" is 26 bytes (i.e. 0x1a).
496             // The next multiple of 32 above 78 + 26 is 128 (i.e. 0x80).
497 
498             // Instead of allocating, we temporarily copy the 128 bytes before the
499             // start of `s` data to some variables.
500             let m3 := mload(sub(s, 0x60))
501             let m2 := mload(sub(s, 0x40))
502             let m1 := mload(sub(s, 0x20))
503             // The length of `s` is in bytes.
504             let sLength := mload(s)
505 
506             let ptr := add(s, 0x20)
507 
508             // `end` marks the end of the memory which we will compute the keccak256 of.
509             let end := add(ptr, sLength)
510 
511             // Convert the length of the bytes to ASCII decimal representation
512             // and store it into the memory.
513             // prettier-ignore
514             for { let temp := sLength } 1 {} {
515                 ptr := sub(ptr, 1)
516                 mstore8(ptr, add(48, mod(temp, 10)))
517                 temp := div(temp, 10)
518                 // prettier-ignore
519                 if iszero(temp) { break }
520             }
521 
522             // Copy the header over to the memory.
523             mstore(sub(ptr, 0x20), "\x00\x00\x00\x00\x00\x00\x19Ethereum Signed Message:\n")
524             // Compute the keccak256 of the memory.
525             result := keccak256(sub(ptr, 0x1a), sub(end, sub(ptr, 0x1a)))
526 
527             // Restore the previous memory.
528             mstore(s, sLength)
529             mstore(sub(s, 0x20), m1)
530             mstore(sub(s, 0x40), m2)
531             mstore(sub(s, 0x60), m3)
532         }
533     }
534 }
535 
536 // File: solady/src/Milady.sol
537 
538 
539 pragma solidity ^0.8.4;
540 
541 /*
542 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
543 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
544 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
545 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
546 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⣿⣷⣶⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
547 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠿⣿⣿⣿⣿⣿⣿⣶⣤⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
548 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣀⣠⣤⣴⣶⣾⣿⣷⣆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠙⠻⢿⣿⣿⣿⣿⣷⣦⣄⡀⠀⠀⠀⠀⠀⠀⠀⠀
549 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⠏⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⢿⣿⣿⣿⣿⣦⡀⠀⠀⠀⠀⠀⠀
550 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣾⣿⣿⣿⣿⣿⡿⠿⠟⠛⠉⠉⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠻⣿⣿⣿⣆⠀⠀⠀⠀⠀
551 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⡿⠟⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⣿⣿⣧⠀⠀⠀⠀
552 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣿⣇⠀⠀⠀
553 ⠀⠀⠀⠀⠀⠀⠀⣠⣾⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣀⣴⣶⣿⣿⣿⣿⣿⣿⣿⣶⣤⡀⠀⠙⠋⠀⠀⠀
554 ⠀⠀⠀⠀⠀⣠⣾⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣤⣾⠟⢋⣥⣤⠀⣶⣶⣶⣦⣤⣌⣉⠛⠀⠀⠀⠀⠀⠀
555 ⠀⠀⠀⠀⣴⣿⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠋⢁⣴⣿⣿⡿⠀⣿⣿⣿⣿⣿⣿⣿⣷⡄⠀⠀⠀⠀⠀
556 ⠀⠀⠀⣼⣿⠟⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣠⣤⣤⣶⣶⣾⣿⣿⣿⣿⣷⣶⡆⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣠⣿⣿⣿⠁⠀⠀⢹⣿⣿⣿⣿⣿⣿⢻⣿⡄⠀⠀⠀⠀
557 ⠀⠀⠀⠛⠋⠀⠀⠀⠀⠀⠀⠀⢀⣤⣾⣿⠿⠛⣛⣉⣉⣀⣀⡀⠀⠀⠀⠀⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⣿⣿⣿⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⢸⣿⣿⡄⠀⠀⠀
558 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣾⡿⢋⣩⣶⣾⣿⣿⣿⣿⣿⣿⣿⣿⣶⣦⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢠⣿⣿⣿⣿⣿⣦⣀⣀⣴⣿⣿⣿⣿⣿⡿⢸⣿⢿⣷⡀⠀⠀
559 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣡⣄⠀⠋⠁⠀⠈⠹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣷⣄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣸⣿⡟⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡇⢸⡿⠀⠛⠃⠀⠀
560 ⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⣧⡀⠀⠀⠀⠀⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣦⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠛⠛⠃⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⠈⠁⠀⠀⠀⠀⠀
561 ⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⣿⢿⣿⣿⣿⣷⣦⣤⣾⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⣶⣶⠀⠈⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡟⠀⣿⠇⠀⠀⠀⠀⠀
562 ⠀⠀⠀⠀⠀⢠⣿⣿⣿⠟⠉⠀⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢿⣿⠀⠀⢹⣿⣿⣿⣿⣿⣿⣿⣿⣿⠁⢸⣿⠀⠀⠀⠀⠀⠀
563 ⠀⠀⠀⠀⠀⣼⣿⡟⠁⣠⣦⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⠉⣿⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢸⣿⡆⠀⠀⢻⣿⣿⣿⣿⣿⣿⣿⠏⠀⣸⡏⠀⠀⠀⠀⠀⠀
564 ⠀⠀⠀⠀⠀⣿⡏⠀⠀⣿⣿⡀⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠀⢹⣿⣧⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⣿⣇⠀⠀⠀⠙⢿⣿⣿⡿⠟⠁⠀⣸⡿⠁⠀⠀⠀⠀⠀⠀
565 ⠀⠀⠀⠀⢸⣿⠁⠀⠀⢸⣿⣇⠀⠀⠘⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⢀⣀⡀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣦⡀⠀⠀⠀⠈⠉⠀⠀⠀⣼⡿⠁⠀⠀⠀⠀⠀⠀⠀
566 ⠀⠀⠀⠀⠈⠁⠀⠀⠀⠀⢿⣿⡄⠀⠀⠈⢿⣿⣿⣿⣿⣿⣿⣿⣿⣿⡿⠁⠀⠀⣼⣿⡇⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠙⢿⣷⣦⣄⣀⠀⠀⢀⡈⠙⠁⠀⠀⠀⠀⠀⠀⠀⠀
567 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⢻⣿⣆⠀⠀⠀⠉⠛⠿⢿⣿⣿⠿⠛⠁⠀⠀⠀⣠⣿⣿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⠿⣿⣿⣷⣿⣯⣤⣶⠄⠀⠀⠀⠀⠀⠀⠀
568 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠹⣿⣷⣀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⣴⣿⣿⠃⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠉⠉⠙⠛⠋⠁⠀⠀⠀⠀⠀⠀⠀
569 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠙⢿⣷⣤⣀⠀⠀⠀⠀⠀⠀⠀⠺⣿⣿⡿⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
570 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠈⠛⢻⣿⣶⣤⣤⣤⣶⣷⣤⠈⠁⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
571 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⢿⣿⣿⣿⣿⡿⠿⠛⠋⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
572 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠉⠉⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
573 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
574 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⢀⡄⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
575 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠘⠶⢤⣄⣀⣀⣤⠶⠋⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
576 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
577 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
578 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
579 ⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀⠀
580 */
581 
582 library Milady {
583     string public constant WEBSITE = "https://miladymaker.net";
584 
585     address public constant CONTRACT = 0x5Af0D9827E0c53E4799BB226655A1de152A425a5;
586 }
587 
588 // File: erc721a/contracts/IERC721A.sol
589 
590 
591 // ERC721A Contracts v4.2.2
592 // Creator: Chiru Labs
593 
594 pragma solidity ^0.8.4;
595 
596 /**
597  * @dev Interface of ERC721A.
598  */
599 interface IERC721A {
600     /**
601      * The caller must own the token or be an approved operator.
602      */
603     error ApprovalCallerNotOwnerNorApproved();
604 
605     /**
606      * The token does not exist.
607      */
608     error ApprovalQueryForNonexistentToken();
609 
610     /**
611      * The caller cannot approve to their own address.
612      */
613     error ApproveToCaller();
614 
615     /**
616      * Cannot query the balance for the zero address.
617      */
618     error BalanceQueryForZeroAddress();
619 
620     /**
621      * Cannot mint to the zero address.
622      */
623     error MintToZeroAddress();
624 
625     /**
626      * The quantity of tokens minted must be more than zero.
627      */
628     error MintZeroQuantity();
629 
630     /**
631      * The token does not exist.
632      */
633     error OwnerQueryForNonexistentToken();
634 
635     /**
636      * The caller must own the token or be an approved operator.
637      */
638     error TransferCallerNotOwnerNorApproved();
639 
640     /**
641      * The token must be owned by `from`.
642      */
643     error TransferFromIncorrectOwner();
644 
645     /**
646      * Cannot safely transfer to a contract that does not implement the
647      * ERC721Receiver interface.
648      */
649     error TransferToNonERC721ReceiverImplementer();
650 
651     /**
652      * Cannot transfer to the zero address.
653      */
654     error TransferToZeroAddress();
655 
656     /**
657      * The token does not exist.
658      */
659     error URIQueryForNonexistentToken();
660 
661     /**
662      * The `quantity` minted with ERC2309 exceeds the safety limit.
663      */
664     error MintERC2309QuantityExceedsLimit();
665 
666     /**
667      * The `extraData` cannot be set on an unintialized ownership slot.
668      */
669     error OwnershipNotInitializedForExtraData();
670 
671     // =============================================================
672     //                            STRUCTS
673     // =============================================================
674 
675     struct TokenOwnership {
676         // The address of the owner.
677         address addr;
678         // Stores the start time of ownership with minimal overhead for tokenomics.
679         uint64 startTimestamp;
680         // Whether the token has been burned.
681         bool burned;
682         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
683         uint24 extraData;
684     }
685 
686     // =============================================================
687     //                         TOKEN COUNTERS
688     // =============================================================
689 
690     /**
691      * @dev Returns the total number of tokens in existence.
692      * Burned tokens will reduce the count.
693      * To get the total number of tokens minted, please see {_totalMinted}.
694      */
695     function totalSupply() external view returns (uint256);
696 
697     // =============================================================
698     //                            IERC165
699     // =============================================================
700 
701     /**
702      * @dev Returns true if this contract implements the interface defined by
703      * `interfaceId`. See the corresponding
704      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
705      * to learn more about how these ids are created.
706      *
707      * This function call must use less than 30000 gas.
708      */
709     function supportsInterface(bytes4 interfaceId) external view returns (bool);
710 
711     // =============================================================
712     //                            IERC721
713     // =============================================================
714 
715     /**
716      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
717      */
718     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
719 
720     /**
721      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
722      */
723     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
724 
725     /**
726      * @dev Emitted when `owner` enables or disables
727      * (`approved`) `operator` to manage all of its assets.
728      */
729     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
730 
731     /**
732      * @dev Returns the number of tokens in `owner`'s account.
733      */
734     function balanceOf(address owner) external view returns (uint256 balance);
735 
736     /**
737      * @dev Returns the owner of the `tokenId` token.
738      *
739      * Requirements:
740      *
741      * - `tokenId` must exist.
742      */
743     function ownerOf(uint256 tokenId) external view returns (address owner);
744 
745     /**
746      * @dev Safely transfers `tokenId` token from `from` to `to`,
747      * checking first that contract recipients are aware of the ERC721 protocol
748      * to prevent tokens from being forever locked.
749      *
750      * Requirements:
751      *
752      * - `from` cannot be the zero address.
753      * - `to` cannot be the zero address.
754      * - `tokenId` token must exist and be owned by `from`.
755      * - If the caller is not `from`, it must be have been allowed to move
756      * this token by either {approve} or {setApprovalForAll}.
757      * - If `to` refers to a smart contract, it must implement
758      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
759      *
760      * Emits a {Transfer} event.
761      */
762     function safeTransferFrom(
763         address from,
764         address to,
765         uint256 tokenId,
766         bytes calldata data
767     ) external;
768 
769     /**
770      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
771      */
772     function safeTransferFrom(
773         address from,
774         address to,
775         uint256 tokenId
776     ) external;
777 
778     /**
779      * @dev Transfers `tokenId` from `from` to `to`.
780      *
781      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
782      * whenever possible.
783      *
784      * Requirements:
785      *
786      * - `from` cannot be the zero address.
787      * - `to` cannot be the zero address.
788      * - `tokenId` token must be owned by `from`.
789      * - If the caller is not `from`, it must be approved to move this token
790      * by either {approve} or {setApprovalForAll}.
791      *
792      * Emits a {Transfer} event.
793      */
794     function transferFrom(
795         address from,
796         address to,
797         uint256 tokenId
798     ) external;
799 
800     /**
801      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
802      * The approval is cleared when the token is transferred.
803      *
804      * Only a single account can be approved at a time, so approving the
805      * zero address clears previous approvals.
806      *
807      * Requirements:
808      *
809      * - The caller must own the token or be an approved operator.
810      * - `tokenId` must exist.
811      *
812      * Emits an {Approval} event.
813      */
814     function approve(address to, uint256 tokenId) external;
815 
816     /**
817      * @dev Approve or remove `operator` as an operator for the caller.
818      * Operators can call {transferFrom} or {safeTransferFrom}
819      * for any token owned by the caller.
820      *
821      * Requirements:
822      *
823      * - The `operator` cannot be the caller.
824      *
825      * Emits an {ApprovalForAll} event.
826      */
827     function setApprovalForAll(address operator, bool _approved) external;
828 
829     /**
830      * @dev Returns the account approved for `tokenId` token.
831      *
832      * Requirements:
833      *
834      * - `tokenId` must exist.
835      */
836     function getApproved(uint256 tokenId) external view returns (address operator);
837 
838     /**
839      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
840      *
841      * See {setApprovalForAll}.
842      */
843     function isApprovedForAll(address owner, address operator) external view returns (bool);
844 
845     // =============================================================
846     //                        IERC721Metadata
847     // =============================================================
848 
849     /**
850      * @dev Returns the token collection name.
851      */
852     function name() external view returns (string memory);
853 
854     /**
855      * @dev Returns the token collection symbol.
856      */
857     function symbol() external view returns (string memory);
858 
859     /**
860      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
861      */
862     function tokenURI(uint256 tokenId) external view returns (string memory);
863 
864     // =============================================================
865     //                           IERC2309
866     // =============================================================
867 
868     /**
869      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
870      * (inclusive) is transferred from `from` to `to`, as defined in the
871      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
872      *
873      * See {_mintERC2309} for more details.
874      */
875     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
876 }
877 
878 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
879 
880 
881 // ERC721A Contracts v4.2.2
882 // Creator: Chiru Labs
883 
884 pragma solidity ^0.8.4;
885 
886 
887 /**
888  * @dev Interface of ERC721AQueryable.
889  */
890 interface IERC721AQueryable is IERC721A {
891     /**
892      * Invalid query range (`start` >= `stop`).
893      */
894     error InvalidQueryRange();
895 
896     /**
897      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
898      *
899      * If the `tokenId` is out of bounds:
900      *
901      * - `addr = address(0)`
902      * - `startTimestamp = 0`
903      * - `burned = false`
904      * - `extraData = 0`
905      *
906      * If the `tokenId` is burned:
907      *
908      * - `addr = <Address of owner before token was burned>`
909      * - `startTimestamp = <Timestamp when token was burned>`
910      * - `burned = true`
911      * - `extraData = <Extra data when token was burned>`
912      *
913      * Otherwise:
914      *
915      * - `addr = <Address of owner>`
916      * - `startTimestamp = <Timestamp of start of ownership>`
917      * - `burned = false`
918      * - `extraData = <Extra data at start of ownership>`
919      */
920     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
921 
922     /**
923      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
924      * See {ERC721AQueryable-explicitOwnershipOf}
925      */
926     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
927 
928     /**
929      * @dev Returns an array of token IDs owned by `owner`,
930      * in the range [`start`, `stop`)
931      * (i.e. `start <= tokenId < stop`).
932      *
933      * This function allows for tokens to be queried if the collection
934      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
935      *
936      * Requirements:
937      *
938      * - `start < stop`
939      */
940     function tokensOfOwnerIn(
941         address owner,
942         uint256 start,
943         uint256 stop
944     ) external view returns (uint256[] memory);
945 
946     /**
947      * @dev Returns an array of token IDs owned by `owner`.
948      *
949      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
950      * It is meant to be called off-chain.
951      *
952      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
953      * multiple smaller scans if the collection is large enough to cause
954      * an out-of-gas error (10K collections should be fine).
955      */
956     function tokensOfOwner(address owner) external view returns (uint256[] memory);
957 }
958 
959 // File: erc721a/contracts/ERC721A.sol
960 
961 
962 // ERC721A Contracts v4.2.2
963 // Creator: Chiru Labs
964 
965 pragma solidity ^0.8.4;
966 
967 
968 /**
969  * @dev Interface of ERC721 token receiver.
970  */
971 interface ERC721A__IERC721Receiver {
972     function onERC721Received(
973         address operator,
974         address from,
975         uint256 tokenId,
976         bytes calldata data
977     ) external returns (bytes4);
978 }
979 
980 /**
981  * @title ERC721A
982  *
983  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
984  * Non-Fungible Token Standard, including the Metadata extension.
985  * Optimized for lower gas during batch mints.
986  *
987  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
988  * starting from `_startTokenId()`.
989  *
990  * Assumptions:
991  *
992  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
993  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
994  */
995 contract ERC721A is IERC721A {
996     // Reference type for token approval.
997     struct TokenApprovalRef {
998         address value;
999     }
1000 
1001     // =============================================================
1002     //                           CONSTANTS
1003     // =============================================================
1004 
1005     // Mask of an entry in packed address data.
1006     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1007 
1008     // The bit position of `numberMinted` in packed address data.
1009     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1010 
1011     // The bit position of `numberBurned` in packed address data.
1012     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1013 
1014     // The bit position of `aux` in packed address data.
1015     uint256 private constant _BITPOS_AUX = 192;
1016 
1017     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1018     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1019 
1020     // The bit position of `startTimestamp` in packed ownership.
1021     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1022 
1023     // The bit mask of the `burned` bit in packed ownership.
1024     uint256 private constant _BITMASK_BURNED = 1 << 224;
1025 
1026     // The bit position of the `nextInitialized` bit in packed ownership.
1027     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1028 
1029     // The bit mask of the `nextInitialized` bit in packed ownership.
1030     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1031 
1032     // The bit position of `extraData` in packed ownership.
1033     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1034 
1035     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1036     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1037 
1038     // The mask of the lower 160 bits for addresses.
1039     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1040 
1041     // The maximum `quantity` that can be minted with {_mintERC2309}.
1042     // This limit is to prevent overflows on the address data entries.
1043     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1044     // is required to cause an overflow, which is unrealistic.
1045     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1046 
1047     // The `Transfer` event signature is given by:
1048     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1049     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1050         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1051 
1052     // =============================================================
1053     //                            STORAGE
1054     // =============================================================
1055 
1056     // The next token ID to be minted.
1057     uint256 private _currentIndex;
1058 
1059     // The number of tokens burned.
1060     uint256 private _burnCounter;
1061 
1062     // Token name
1063     string private _name;
1064 
1065     // Token symbol
1066     string private _symbol;
1067 
1068     // Mapping from token ID to ownership details
1069     // An empty struct value does not necessarily mean the token is unowned.
1070     // See {_packedOwnershipOf} implementation for details.
1071     //
1072     // Bits Layout:
1073     // - [0..159]   `addr`
1074     // - [160..223] `startTimestamp`
1075     // - [224]      `burned`
1076     // - [225]      `nextInitialized`
1077     // - [232..255] `extraData`
1078     mapping(uint256 => uint256) private _packedOwnerships;
1079 
1080     // Mapping owner address to address data.
1081     //
1082     // Bits Layout:
1083     // - [0..63]    `balance`
1084     // - [64..127]  `numberMinted`
1085     // - [128..191] `numberBurned`
1086     // - [192..255] `aux`
1087     mapping(address => uint256) private _packedAddressData;
1088 
1089     // Mapping from token ID to approved address.
1090     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1091 
1092     // Mapping from owner to operator approvals
1093     mapping(address => mapping(address => bool)) private _operatorApprovals;
1094 
1095     // =============================================================
1096     //                          CONSTRUCTOR
1097     // =============================================================
1098 
1099     constructor(string memory name_, string memory symbol_) {
1100         _name = name_;
1101         _symbol = symbol_;
1102         _currentIndex = _startTokenId();
1103     }
1104 
1105     // =============================================================
1106     //                   TOKEN COUNTING OPERATIONS
1107     // =============================================================
1108 
1109     /**
1110      * @dev Returns the starting token ID.
1111      * To change the starting token ID, please override this function.
1112      */
1113     function _startTokenId() internal view virtual returns (uint256) {
1114         return 0;
1115     }
1116 
1117     /**
1118      * @dev Returns the next token ID to be minted.
1119      */
1120     function _nextTokenId() internal view virtual returns (uint256) {
1121         return _currentIndex;
1122     }
1123 
1124     /**
1125      * @dev Returns the total number of tokens in existence.
1126      * Burned tokens will reduce the count.
1127      * To get the total number of tokens minted, please see {_totalMinted}.
1128      */
1129     function totalSupply() public view virtual override returns (uint256) {
1130         // Counter underflow is impossible as _burnCounter cannot be incremented
1131         // more than `_currentIndex - _startTokenId()` times.
1132         unchecked {
1133             return _currentIndex - _burnCounter - _startTokenId();
1134         }
1135     }
1136 
1137     /**
1138      * @dev Returns the total amount of tokens minted in the contract.
1139      */
1140     function _totalMinted() internal view virtual returns (uint256) {
1141         // Counter underflow is impossible as `_currentIndex` does not decrement,
1142         // and it is initialized to `_startTokenId()`.
1143         unchecked {
1144             return _currentIndex - _startTokenId();
1145         }
1146     }
1147 
1148     /**
1149      * @dev Returns the total number of tokens burned.
1150      */
1151     function _totalBurned() internal view virtual returns (uint256) {
1152         return _burnCounter;
1153     }
1154 
1155     // =============================================================
1156     //                    ADDRESS DATA OPERATIONS
1157     // =============================================================
1158 
1159     /**
1160      * @dev Returns the number of tokens in `owner`'s account.
1161      */
1162     function balanceOf(address owner) public view virtual override returns (uint256) {
1163         if (owner == address(0)) revert BalanceQueryForZeroAddress();
1164         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
1165     }
1166 
1167     /**
1168      * Returns the number of tokens minted by `owner`.
1169      */
1170     function _numberMinted(address owner) internal view returns (uint256) {
1171         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
1172     }
1173 
1174     /**
1175      * Returns the number of tokens burned by or on behalf of `owner`.
1176      */
1177     function _numberBurned(address owner) internal view returns (uint256) {
1178         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
1179     }
1180 
1181     /**
1182      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1183      */
1184     function _getAux(address owner) internal view returns (uint64) {
1185         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
1186     }
1187 
1188     /**
1189      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
1190      * If there are multiple variables, please pack them into a uint64.
1191      */
1192     function _setAux(address owner, uint64 aux) internal virtual {
1193         uint256 packed = _packedAddressData[owner];
1194         uint256 auxCasted;
1195         // Cast `aux` with assembly to avoid redundant masking.
1196         assembly {
1197             auxCasted := aux
1198         }
1199         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
1200         _packedAddressData[owner] = packed;
1201     }
1202 
1203     // =============================================================
1204     //                            IERC165
1205     // =============================================================
1206 
1207     /**
1208      * @dev Returns true if this contract implements the interface defined by
1209      * `interfaceId`. See the corresponding
1210      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1211      * to learn more about how these ids are created.
1212      *
1213      * This function call must use less than 30000 gas.
1214      */
1215     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
1216         // The interface IDs are constants representing the first 4 bytes
1217         // of the XOR of all function selectors in the interface.
1218         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
1219         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
1220         return
1221             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
1222             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
1223             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
1224     }
1225 
1226     // =============================================================
1227     //                        IERC721Metadata
1228     // =============================================================
1229 
1230     /**
1231      * @dev Returns the token collection name.
1232      */
1233     function name() public view virtual override returns (string memory) {
1234         return _name;
1235     }
1236 
1237     /**
1238      * @dev Returns the token collection symbol.
1239      */
1240     function symbol() public view virtual override returns (string memory) {
1241         return _symbol;
1242     }
1243 
1244     /**
1245      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1246      */
1247     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1248         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
1249 
1250         string memory baseURI = _baseURI();
1251         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
1252     }
1253 
1254     /**
1255      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
1256      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
1257      * by default, it can be overridden in child contracts.
1258      */
1259     function _baseURI() internal view virtual returns (string memory) {
1260         return '';
1261     }
1262 
1263     // =============================================================
1264     //                     OWNERSHIPS OPERATIONS
1265     // =============================================================
1266 
1267     /**
1268      * @dev Returns the owner of the `tokenId` token.
1269      *
1270      * Requirements:
1271      *
1272      * - `tokenId` must exist.
1273      */
1274     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1275         return address(uint160(_packedOwnershipOf(tokenId)));
1276     }
1277 
1278     /**
1279      * @dev Gas spent here starts off proportional to the maximum mint batch size.
1280      * It gradually moves to O(1) as tokens get transferred around over time.
1281      */
1282     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
1283         return _unpackedOwnership(_packedOwnershipOf(tokenId));
1284     }
1285 
1286     /**
1287      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
1288      */
1289     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
1290         return _unpackedOwnership(_packedOwnerships[index]);
1291     }
1292 
1293     /**
1294      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
1295      */
1296     function _initializeOwnershipAt(uint256 index) internal virtual {
1297         if (_packedOwnerships[index] == 0) {
1298             _packedOwnerships[index] = _packedOwnershipOf(index);
1299         }
1300     }
1301 
1302     /**
1303      * Returns the packed ownership data of `tokenId`.
1304      */
1305     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
1306         uint256 curr = tokenId;
1307 
1308         unchecked {
1309             if (_startTokenId() <= curr)
1310                 if (curr < _currentIndex) {
1311                     uint256 packed = _packedOwnerships[curr];
1312                     // If not burned.
1313                     if (packed & _BITMASK_BURNED == 0) {
1314                         // Invariant:
1315                         // There will always be an initialized ownership slot
1316                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
1317                         // before an unintialized ownership slot
1318                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
1319                         // Hence, `curr` will not underflow.
1320                         //
1321                         // We can directly compare the packed value.
1322                         // If the address is zero, packed will be zero.
1323                         while (packed == 0) {
1324                             packed = _packedOwnerships[--curr];
1325                         }
1326                         return packed;
1327                     }
1328                 }
1329         }
1330         revert OwnerQueryForNonexistentToken();
1331     }
1332 
1333     /**
1334      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
1335      */
1336     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
1337         ownership.addr = address(uint160(packed));
1338         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
1339         ownership.burned = packed & _BITMASK_BURNED != 0;
1340         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
1341     }
1342 
1343     /**
1344      * @dev Packs ownership data into a single uint256.
1345      */
1346     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
1347         assembly {
1348             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1349             owner := and(owner, _BITMASK_ADDRESS)
1350             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
1351             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
1352         }
1353     }
1354 
1355     /**
1356      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
1357      */
1358     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
1359         // For branchless setting of the `nextInitialized` flag.
1360         assembly {
1361             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
1362             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
1363         }
1364     }
1365 
1366     // =============================================================
1367     //                      APPROVAL OPERATIONS
1368     // =============================================================
1369 
1370     /**
1371      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1372      * The approval is cleared when the token is transferred.
1373      *
1374      * Only a single account can be approved at a time, so approving the
1375      * zero address clears previous approvals.
1376      *
1377      * Requirements:
1378      *
1379      * - The caller must own the token or be an approved operator.
1380      * - `tokenId` must exist.
1381      *
1382      * Emits an {Approval} event.
1383      */
1384     function approve(address to, uint256 tokenId) public virtual override {
1385         address owner = ownerOf(tokenId);
1386 
1387         if (_msgSenderERC721A() != owner)
1388             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
1389                 revert ApprovalCallerNotOwnerNorApproved();
1390             }
1391 
1392         _tokenApprovals[tokenId].value = to;
1393         emit Approval(owner, to, tokenId);
1394     }
1395 
1396     /**
1397      * @dev Returns the account approved for `tokenId` token.
1398      *
1399      * Requirements:
1400      *
1401      * - `tokenId` must exist.
1402      */
1403     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1404         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
1405 
1406         return _tokenApprovals[tokenId].value;
1407     }
1408 
1409     /**
1410      * @dev Approve or remove `operator` as an operator for the caller.
1411      * Operators can call {transferFrom} or {safeTransferFrom}
1412      * for any token owned by the caller.
1413      *
1414      * Requirements:
1415      *
1416      * - The `operator` cannot be the caller.
1417      *
1418      * Emits an {ApprovalForAll} event.
1419      */
1420     function setApprovalForAll(address operator, bool approved) public virtual override {
1421         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
1422 
1423         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
1424         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
1425     }
1426 
1427     /**
1428      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1429      *
1430      * See {setApprovalForAll}.
1431      */
1432     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1433         return _operatorApprovals[owner][operator];
1434     }
1435 
1436     /**
1437      * @dev Returns whether `tokenId` exists.
1438      *
1439      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1440      *
1441      * Tokens start existing when they are minted. See {_mint}.
1442      */
1443     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1444         return
1445             _startTokenId() <= tokenId &&
1446             tokenId < _currentIndex && // If within bounds,
1447             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
1448     }
1449 
1450     /**
1451      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
1452      */
1453     function _isSenderApprovedOrOwner(
1454         address approvedAddress,
1455         address owner,
1456         address msgSender
1457     ) private pure returns (bool result) {
1458         assembly {
1459             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
1460             owner := and(owner, _BITMASK_ADDRESS)
1461             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1462             msgSender := and(msgSender, _BITMASK_ADDRESS)
1463             // `msgSender == owner || msgSender == approvedAddress`.
1464             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
1465         }
1466     }
1467 
1468     /**
1469      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1470      */
1471     function _getApprovedSlotAndAddress(uint256 tokenId)
1472         private
1473         view
1474         returns (uint256 approvedAddressSlot, address approvedAddress)
1475     {
1476         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
1477         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1478         assembly {
1479             approvedAddressSlot := tokenApproval.slot
1480             approvedAddress := sload(approvedAddressSlot)
1481         }
1482     }
1483 
1484     // =============================================================
1485     //                      TRANSFER OPERATIONS
1486     // =============================================================
1487 
1488     /**
1489      * @dev Transfers `tokenId` from `from` to `to`.
1490      *
1491      * Requirements:
1492      *
1493      * - `from` cannot be the zero address.
1494      * - `to` cannot be the zero address.
1495      * - `tokenId` token must be owned by `from`.
1496      * - If the caller is not `from`, it must be approved to move this token
1497      * by either {approve} or {setApprovalForAll}.
1498      *
1499      * Emits a {Transfer} event.
1500      */
1501     function transferFrom(
1502         address from,
1503         address to,
1504         uint256 tokenId
1505     ) public virtual override {
1506         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1507 
1508         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1509 
1510         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1511 
1512         // The nested ifs save around 20+ gas over a compound boolean condition.
1513         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1514             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1515 
1516         if (to == address(0)) revert TransferToZeroAddress();
1517 
1518         _beforeTokenTransfers(from, to, tokenId, 1);
1519 
1520         // Clear approvals from the previous owner.
1521         assembly {
1522             if approvedAddress {
1523                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1524                 sstore(approvedAddressSlot, 0)
1525             }
1526         }
1527 
1528         // Underflow of the sender's balance is impossible because we check for
1529         // ownership above and the recipient's balance can't realistically overflow.
1530         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1531         unchecked {
1532             // We can directly increment and decrement the balances.
1533             --_packedAddressData[from]; // Updates: `balance -= 1`.
1534             ++_packedAddressData[to]; // Updates: `balance += 1`.
1535 
1536             // Updates:
1537             // - `address` to the next owner.
1538             // - `startTimestamp` to the timestamp of transfering.
1539             // - `burned` to `false`.
1540             // - `nextInitialized` to `true`.
1541             _packedOwnerships[tokenId] = _packOwnershipData(
1542                 to,
1543                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1544             );
1545 
1546             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1547             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1548                 uint256 nextTokenId = tokenId + 1;
1549                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1550                 if (_packedOwnerships[nextTokenId] == 0) {
1551                     // If the next slot is within bounds.
1552                     if (nextTokenId != _currentIndex) {
1553                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1554                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1555                     }
1556                 }
1557             }
1558         }
1559 
1560         emit Transfer(from, to, tokenId);
1561         _afterTokenTransfers(from, to, tokenId, 1);
1562     }
1563 
1564     /**
1565      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1566      */
1567     function safeTransferFrom(
1568         address from,
1569         address to,
1570         uint256 tokenId
1571     ) public virtual override {
1572         safeTransferFrom(from, to, tokenId, '');
1573     }
1574 
1575     /**
1576      * @dev Safely transfers `tokenId` token from `from` to `to`.
1577      *
1578      * Requirements:
1579      *
1580      * - `from` cannot be the zero address.
1581      * - `to` cannot be the zero address.
1582      * - `tokenId` token must exist and be owned by `from`.
1583      * - If the caller is not `from`, it must be approved to move this token
1584      * by either {approve} or {setApprovalForAll}.
1585      * - If `to` refers to a smart contract, it must implement
1586      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1587      *
1588      * Emits a {Transfer} event.
1589      */
1590     function safeTransferFrom(
1591         address from,
1592         address to,
1593         uint256 tokenId,
1594         bytes memory _data
1595     ) public virtual override {
1596         transferFrom(from, to, tokenId);
1597         if (to.code.length != 0)
1598             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
1599                 revert TransferToNonERC721ReceiverImplementer();
1600             }
1601     }
1602 
1603     /**
1604      * @dev Hook that is called before a set of serially-ordered token IDs
1605      * are about to be transferred. This includes minting.
1606      * And also called before burning one token.
1607      *
1608      * `startTokenId` - the first token ID to be transferred.
1609      * `quantity` - the amount to be transferred.
1610      *
1611      * Calling conditions:
1612      *
1613      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1614      * transferred to `to`.
1615      * - When `from` is zero, `tokenId` will be minted for `to`.
1616      * - When `to` is zero, `tokenId` will be burned by `from`.
1617      * - `from` and `to` are never both zero.
1618      */
1619     function _beforeTokenTransfers(
1620         address from,
1621         address to,
1622         uint256 startTokenId,
1623         uint256 quantity
1624     ) internal virtual {}
1625 
1626     /**
1627      * @dev Hook that is called after a set of serially-ordered token IDs
1628      * have been transferred. This includes minting.
1629      * And also called after one token has been burned.
1630      *
1631      * `startTokenId` - the first token ID to be transferred.
1632      * `quantity` - the amount to be transferred.
1633      *
1634      * Calling conditions:
1635      *
1636      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1637      * transferred to `to`.
1638      * - When `from` is zero, `tokenId` has been minted for `to`.
1639      * - When `to` is zero, `tokenId` has been burned by `from`.
1640      * - `from` and `to` are never both zero.
1641      */
1642     function _afterTokenTransfers(
1643         address from,
1644         address to,
1645         uint256 startTokenId,
1646         uint256 quantity
1647     ) internal virtual {}
1648 
1649     /**
1650      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1651      *
1652      * `from` - Previous owner of the given token ID.
1653      * `to` - Target address that will receive the token.
1654      * `tokenId` - Token ID to be transferred.
1655      * `_data` - Optional data to send along with the call.
1656      *
1657      * Returns whether the call correctly returned the expected magic value.
1658      */
1659     function _checkContractOnERC721Received(
1660         address from,
1661         address to,
1662         uint256 tokenId,
1663         bytes memory _data
1664     ) private returns (bool) {
1665         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1666             bytes4 retval
1667         ) {
1668             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1669         } catch (bytes memory reason) {
1670             if (reason.length == 0) {
1671                 revert TransferToNonERC721ReceiverImplementer();
1672             } else {
1673                 assembly {
1674                     revert(add(32, reason), mload(reason))
1675                 }
1676             }
1677         }
1678     }
1679 
1680     // =============================================================
1681     //                        MINT OPERATIONS
1682     // =============================================================
1683 
1684     /**
1685      * @dev Mints `quantity` tokens and transfers them to `to`.
1686      *
1687      * Requirements:
1688      *
1689      * - `to` cannot be the zero address.
1690      * - `quantity` must be greater than 0.
1691      *
1692      * Emits a {Transfer} event for each mint.
1693      */
1694     function _mint(address to, uint256 quantity) internal virtual {
1695         uint256 startTokenId = _currentIndex;
1696         if (quantity == 0) revert MintZeroQuantity();
1697 
1698         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1699 
1700         // Overflows are incredibly unrealistic.
1701         // `balance` and `numberMinted` have a maximum limit of 2**64.
1702         // `tokenId` has a maximum limit of 2**256.
1703         unchecked {
1704             // Updates:
1705             // - `balance += quantity`.
1706             // - `numberMinted += quantity`.
1707             //
1708             // We can directly add to the `balance` and `numberMinted`.
1709             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1710 
1711             // Updates:
1712             // - `address` to the owner.
1713             // - `startTimestamp` to the timestamp of minting.
1714             // - `burned` to `false`.
1715             // - `nextInitialized` to `quantity == 1`.
1716             _packedOwnerships[startTokenId] = _packOwnershipData(
1717                 to,
1718                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1719             );
1720 
1721             uint256 toMasked;
1722             uint256 end = startTokenId + quantity;
1723 
1724             // Use assembly to loop and emit the `Transfer` event for gas savings.
1725             assembly {
1726                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
1727                 toMasked := and(to, _BITMASK_ADDRESS)
1728                 // Emit the `Transfer` event.
1729                 log4(
1730                     0, // Start of data (0, since no data).
1731                     0, // End of data (0, since no data).
1732                     _TRANSFER_EVENT_SIGNATURE, // Signature.
1733                     0, // `address(0)`.
1734                     toMasked, // `to`.
1735                     startTokenId // `tokenId`.
1736                 )
1737 
1738                 for {
1739                     let tokenId := add(startTokenId, 1)
1740                 } iszero(eq(tokenId, end)) {
1741                     tokenId := add(tokenId, 1)
1742                 } {
1743                     // Emit the `Transfer` event. Similar to above.
1744                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
1745                 }
1746             }
1747             if (toMasked == 0) revert MintToZeroAddress();
1748 
1749             _currentIndex = end;
1750         }
1751         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1752     }
1753 
1754     /**
1755      * @dev Mints `quantity` tokens and transfers them to `to`.
1756      *
1757      * This function is intended for efficient minting only during contract creation.
1758      *
1759      * It emits only one {ConsecutiveTransfer} as defined in
1760      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1761      * instead of a sequence of {Transfer} event(s).
1762      *
1763      * Calling this function outside of contract creation WILL make your contract
1764      * non-compliant with the ERC721 standard.
1765      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1766      * {ConsecutiveTransfer} event is only permissible during contract creation.
1767      *
1768      * Requirements:
1769      *
1770      * - `to` cannot be the zero address.
1771      * - `quantity` must be greater than 0.
1772      *
1773      * Emits a {ConsecutiveTransfer} event.
1774      */
1775     function _mintERC2309(address to, uint256 quantity) internal virtual {
1776         uint256 startTokenId = _currentIndex;
1777         if (to == address(0)) revert MintToZeroAddress();
1778         if (quantity == 0) revert MintZeroQuantity();
1779         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1780 
1781         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1782 
1783         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1784         unchecked {
1785             // Updates:
1786             // - `balance += quantity`.
1787             // - `numberMinted += quantity`.
1788             //
1789             // We can directly add to the `balance` and `numberMinted`.
1790             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
1791 
1792             // Updates:
1793             // - `address` to the owner.
1794             // - `startTimestamp` to the timestamp of minting.
1795             // - `burned` to `false`.
1796             // - `nextInitialized` to `quantity == 1`.
1797             _packedOwnerships[startTokenId] = _packOwnershipData(
1798                 to,
1799                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1800             );
1801 
1802             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1803 
1804             _currentIndex = startTokenId + quantity;
1805         }
1806         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1807     }
1808 
1809     /**
1810      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1811      *
1812      * Requirements:
1813      *
1814      * - If `to` refers to a smart contract, it must implement
1815      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1816      * - `quantity` must be greater than 0.
1817      *
1818      * See {_mint}.
1819      *
1820      * Emits a {Transfer} event for each mint.
1821      */
1822     function _safeMint(
1823         address to,
1824         uint256 quantity,
1825         bytes memory _data
1826     ) internal virtual {
1827         _mint(to, quantity);
1828 
1829         unchecked {
1830             if (to.code.length != 0) {
1831                 uint256 end = _currentIndex;
1832                 uint256 index = end - quantity;
1833                 do {
1834                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1835                         revert TransferToNonERC721ReceiverImplementer();
1836                     }
1837                 } while (index < end);
1838                 // Reentrancy protection.
1839                 if (_currentIndex != end) revert();
1840             }
1841         }
1842     }
1843 
1844     /**
1845      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1846      */
1847     function _safeMint(address to, uint256 quantity) internal virtual {
1848         _safeMint(to, quantity, '');
1849     }
1850 
1851     // =============================================================
1852     //                        BURN OPERATIONS
1853     // =============================================================
1854 
1855     /**
1856      * @dev Equivalent to `_burn(tokenId, false)`.
1857      */
1858     function _burn(uint256 tokenId) internal virtual {
1859         _burn(tokenId, false);
1860     }
1861 
1862     /**
1863      * @dev Destroys `tokenId`.
1864      * The approval is cleared when the token is burned.
1865      *
1866      * Requirements:
1867      *
1868      * - `tokenId` must exist.
1869      *
1870      * Emits a {Transfer} event.
1871      */
1872     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1873         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1874 
1875         address from = address(uint160(prevOwnershipPacked));
1876 
1877         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
1878 
1879         if (approvalCheck) {
1880             // The nested ifs save around 20+ gas over a compound boolean condition.
1881             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
1882                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1883         }
1884 
1885         _beforeTokenTransfers(from, address(0), tokenId, 1);
1886 
1887         // Clear approvals from the previous owner.
1888         assembly {
1889             if approvedAddress {
1890                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1891                 sstore(approvedAddressSlot, 0)
1892             }
1893         }
1894 
1895         // Underflow of the sender's balance is impossible because we check for
1896         // ownership above and the recipient's balance can't realistically overflow.
1897         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1898         unchecked {
1899             // Updates:
1900             // - `balance -= 1`.
1901             // - `numberBurned += 1`.
1902             //
1903             // We can directly decrement the balance, and increment the number burned.
1904             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
1905             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
1906 
1907             // Updates:
1908             // - `address` to the last owner.
1909             // - `startTimestamp` to the timestamp of burning.
1910             // - `burned` to `true`.
1911             // - `nextInitialized` to `true`.
1912             _packedOwnerships[tokenId] = _packOwnershipData(
1913                 from,
1914                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1915             );
1916 
1917             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1918             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
1919                 uint256 nextTokenId = tokenId + 1;
1920                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1921                 if (_packedOwnerships[nextTokenId] == 0) {
1922                     // If the next slot is within bounds.
1923                     if (nextTokenId != _currentIndex) {
1924                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1925                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1926                     }
1927                 }
1928             }
1929         }
1930 
1931         emit Transfer(from, address(0), tokenId);
1932         _afterTokenTransfers(from, address(0), tokenId, 1);
1933 
1934         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1935         unchecked {
1936             _burnCounter++;
1937         }
1938     }
1939 
1940     // =============================================================
1941     //                     EXTRA DATA OPERATIONS
1942     // =============================================================
1943 
1944     /**
1945      * @dev Directly sets the extra data for the ownership data `index`.
1946      */
1947     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
1948         uint256 packed = _packedOwnerships[index];
1949         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1950         uint256 extraDataCasted;
1951         // Cast `extraData` with assembly to avoid redundant masking.
1952         assembly {
1953             extraDataCasted := extraData
1954         }
1955         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
1956         _packedOwnerships[index] = packed;
1957     }
1958 
1959     /**
1960      * @dev Called during each token transfer to set the 24bit `extraData` field.
1961      * Intended to be overridden by the cosumer contract.
1962      *
1963      * `previousExtraData` - the value of `extraData` before transfer.
1964      *
1965      * Calling conditions:
1966      *
1967      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1968      * transferred to `to`.
1969      * - When `from` is zero, `tokenId` will be minted for `to`.
1970      * - When `to` is zero, `tokenId` will be burned by `from`.
1971      * - `from` and `to` are never both zero.
1972      */
1973     function _extraData(
1974         address from,
1975         address to,
1976         uint24 previousExtraData
1977     ) internal view virtual returns (uint24) {}
1978 
1979     /**
1980      * @dev Returns the next extra data for the packed ownership data.
1981      * The returned result is shifted into position.
1982      */
1983     function _nextExtraData(
1984         address from,
1985         address to,
1986         uint256 prevOwnershipPacked
1987     ) private view returns (uint256) {
1988         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
1989         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
1990     }
1991 
1992     // =============================================================
1993     //                       OTHER OPERATIONS
1994     // =============================================================
1995 
1996     /**
1997      * @dev Returns the message sender (defaults to `msg.sender`).
1998      *
1999      * If you are writing GSN compatible contracts, you need to override this function.
2000      */
2001     function _msgSenderERC721A() internal view virtual returns (address) {
2002         return msg.sender;
2003     }
2004 
2005     /**
2006      * @dev Converts a uint256 to its ASCII string decimal representation.
2007      */
2008     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2009         assembly {
2010             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
2011             // but we allocate 0x80 bytes to keep the free memory pointer 32-byte word aliged.
2012             // We will need 1 32-byte word to store the length,
2013             // and 3 32-byte words to store a maximum of 78 digits. Total: 0x20 + 3 * 0x20 = 0x80.
2014             str := add(mload(0x40), 0x80)
2015             // Update the free memory pointer to allocate.
2016             mstore(0x40, str)
2017 
2018             // Cache the end of the memory to calculate the length later.
2019             let end := str
2020 
2021             // We write the string from rightmost digit to leftmost digit.
2022             // The following is essentially a do-while loop that also handles the zero case.
2023             // prettier-ignore
2024             for { let temp := value } 1 {} {
2025                 str := sub(str, 1)
2026                 // Write the character to the pointer.
2027                 // The ASCII index of the '0' character is 48.
2028                 mstore8(str, add(48, mod(temp, 10)))
2029                 // Keep dividing `temp` until zero.
2030                 temp := div(temp, 10)
2031                 // prettier-ignore
2032                 if iszero(temp) { break }
2033             }
2034 
2035             let length := sub(end, str)
2036             // Move the pointer 32 bytes leftwards to make room for the length.
2037             str := sub(str, 0x20)
2038             // Store the length.
2039             mstore(str, length)
2040         }
2041     }
2042 }
2043 
2044 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
2045 
2046 
2047 // ERC721A Contracts v4.2.2
2048 // Creator: Chiru Labs
2049 
2050 pragma solidity ^0.8.4;
2051 
2052 
2053 
2054 /**
2055  * @title ERC721AQueryable.
2056  *
2057  * @dev ERC721A subclass with convenience query functions.
2058  */
2059 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
2060     /**
2061      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2062      *
2063      * If the `tokenId` is out of bounds:
2064      *
2065      * - `addr = address(0)`
2066      * - `startTimestamp = 0`
2067      * - `burned = false`
2068      * - `extraData = 0`
2069      *
2070      * If the `tokenId` is burned:
2071      *
2072      * - `addr = <Address of owner before token was burned>`
2073      * - `startTimestamp = <Timestamp when token was burned>`
2074      * - `burned = true`
2075      * - `extraData = <Extra data when token was burned>`
2076      *
2077      * Otherwise:
2078      *
2079      * - `addr = <Address of owner>`
2080      * - `startTimestamp = <Timestamp of start of ownership>`
2081      * - `burned = false`
2082      * - `extraData = <Extra data at start of ownership>`
2083      */
2084     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
2085         TokenOwnership memory ownership;
2086         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
2087             return ownership;
2088         }
2089         ownership = _ownershipAt(tokenId);
2090         if (ownership.burned) {
2091             return ownership;
2092         }
2093         return _ownershipOf(tokenId);
2094     }
2095 
2096     /**
2097      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2098      * See {ERC721AQueryable-explicitOwnershipOf}
2099      */
2100     function explicitOwnershipsOf(uint256[] calldata tokenIds)
2101         external
2102         view
2103         virtual
2104         override
2105         returns (TokenOwnership[] memory)
2106     {
2107         unchecked {
2108             uint256 tokenIdsLength = tokenIds.length;
2109             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
2110             for (uint256 i; i != tokenIdsLength; ++i) {
2111                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
2112             }
2113             return ownerships;
2114         }
2115     }
2116 
2117     /**
2118      * @dev Returns an array of token IDs owned by `owner`,
2119      * in the range [`start`, `stop`)
2120      * (i.e. `start <= tokenId < stop`).
2121      *
2122      * This function allows for tokens to be queried if the collection
2123      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
2124      *
2125      * Requirements:
2126      *
2127      * - `start < stop`
2128      */
2129     function tokensOfOwnerIn(
2130         address owner,
2131         uint256 start,
2132         uint256 stop
2133     ) external view virtual override returns (uint256[] memory) {
2134         unchecked {
2135             if (start >= stop) revert InvalidQueryRange();
2136             uint256 tokenIdsIdx;
2137             uint256 stopLimit = _nextTokenId();
2138             // Set `start = max(start, _startTokenId())`.
2139             if (start < _startTokenId()) {
2140                 start = _startTokenId();
2141             }
2142             // Set `stop = min(stop, stopLimit)`.
2143             if (stop > stopLimit) {
2144                 stop = stopLimit;
2145             }
2146             uint256 tokenIdsMaxLength = balanceOf(owner);
2147             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
2148             // to cater for cases where `balanceOf(owner)` is too big.
2149             if (start < stop) {
2150                 uint256 rangeLength = stop - start;
2151                 if (rangeLength < tokenIdsMaxLength) {
2152                     tokenIdsMaxLength = rangeLength;
2153                 }
2154             } else {
2155                 tokenIdsMaxLength = 0;
2156             }
2157             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
2158             if (tokenIdsMaxLength == 0) {
2159                 return tokenIds;
2160             }
2161             // We need to call `explicitOwnershipOf(start)`,
2162             // because the slot at `start` may not be initialized.
2163             TokenOwnership memory ownership = explicitOwnershipOf(start);
2164             address currOwnershipAddr;
2165             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
2166             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
2167             if (!ownership.burned) {
2168                 currOwnershipAddr = ownership.addr;
2169             }
2170             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
2171                 ownership = _ownershipAt(i);
2172                 if (ownership.burned) {
2173                     continue;
2174                 }
2175                 if (ownership.addr != address(0)) {
2176                     currOwnershipAddr = ownership.addr;
2177                 }
2178                 if (currOwnershipAddr == owner) {
2179                     tokenIds[tokenIdsIdx++] = i;
2180                 }
2181             }
2182             // Downsize the array to fit.
2183             assembly {
2184                 mstore(tokenIds, tokenIdsIdx)
2185             }
2186             return tokenIds;
2187         }
2188     }
2189 
2190     /**
2191      * @dev Returns an array of token IDs owned by `owner`.
2192      *
2193      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
2194      * It is meant to be called off-chain.
2195      *
2196      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
2197      * multiple smaller scans if the collection is large enough to cause
2198      * an out-of-gas error (10K collections should be fine).
2199      */
2200     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
2201         unchecked {
2202             uint256 tokenIdsIdx;
2203             address currOwnershipAddr;
2204             uint256 tokenIdsLength = balanceOf(owner);
2205             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
2206             TokenOwnership memory ownership;
2207             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
2208                 ownership = _ownershipAt(i);
2209                 if (ownership.burned) {
2210                     continue;
2211                 }
2212                 if (ownership.addr != address(0)) {
2213                     currOwnershipAddr = ownership.addr;
2214                 }
2215                 if (currOwnershipAddr == owner) {
2216                     tokenIds[tokenIdsIdx++] = i;
2217                 }
2218             }
2219             return tokenIds;
2220         }
2221     }
2222 }
2223 
2224 // File: @openzeppelin/contracts/utils/Context.sol
2225 
2226 
2227 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
2228 
2229 pragma solidity ^0.8.0;
2230 
2231 /**
2232  * @dev Provides information about the current execution context, including the
2233  * sender of the transaction and its data. While these are generally available
2234  * via msg.sender and msg.data, they should not be accessed in such a direct
2235  * manner, since when dealing with meta-transactions the account sending and
2236  * paying for execution may not be the actual sender (as far as an application
2237  * is concerned).
2238  *
2239  * This contract is only required for intermediate, library-like contracts.
2240  */
2241 abstract contract Context {
2242     function _msgSender() internal view virtual returns (address) {
2243         return msg.sender;
2244     }
2245 
2246     function _msgData() internal view virtual returns (bytes calldata) {
2247         return msg.data;
2248     }
2249 }
2250 
2251 // File: @openzeppelin/contracts/access/Ownable.sol
2252 
2253 
2254 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
2255 
2256 pragma solidity ^0.8.0;
2257 
2258 
2259 /**
2260  * @dev Contract module which provides a basic access control mechanism, where
2261  * there is an account (an owner) that can be granted exclusive access to
2262  * specific functions.
2263  *
2264  * By default, the owner account will be the one that deploys the contract. This
2265  * can later be changed with {transferOwnership}.
2266  *
2267  * This module is used through inheritance. It will make available the modifier
2268  * `onlyOwner`, which can be applied to your functions to restrict their use to
2269  * the owner.
2270  */
2271 abstract contract Ownable is Context {
2272     address private _owner;
2273 
2274     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
2275 
2276     /**
2277      * @dev Initializes the contract setting the deployer as the initial owner.
2278      */
2279     constructor() {
2280         _transferOwnership(_msgSender());
2281     }
2282 
2283     /**
2284      * @dev Throws if called by any account other than the owner.
2285      */
2286     modifier onlyOwner() {
2287         _checkOwner();
2288         _;
2289     }
2290 
2291     /**
2292      * @dev Returns the address of the current owner.
2293      */
2294     function owner() public view virtual returns (address) {
2295         return _owner;
2296     }
2297 
2298     /**
2299      * @dev Throws if the sender is not the owner.
2300      */
2301     function _checkOwner() internal view virtual {
2302         require(owner() == _msgSender(), "Ownable: caller is not the owner");
2303     }
2304 
2305     /**
2306      * @dev Leaves the contract without owner. It will not be possible to call
2307      * `onlyOwner` functions anymore. Can only be called by the current owner.
2308      *
2309      * NOTE: Renouncing ownership will leave the contract without an owner,
2310      * thereby removing any functionality that is only available to the owner.
2311      */
2312     function renounceOwnership() public virtual onlyOwner {
2313         _transferOwnership(address(0));
2314     }
2315 
2316     /**
2317      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2318      * Can only be called by the current owner.
2319      */
2320     function transferOwnership(address newOwner) public virtual onlyOwner {
2321         require(newOwner != address(0), "Ownable: new owner is the zero address");
2322         _transferOwnership(newOwner);
2323     }
2324 
2325     /**
2326      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2327      * Internal function without access restriction.
2328      */
2329     function _transferOwnership(address newOwner) internal virtual {
2330         address oldOwner = _owner;
2331         _owner = newOwner;
2332         emit OwnershipTransferred(oldOwner, newOwner);
2333     }
2334 }
2335 
2336 // File: MiladyRave.sol
2337 
2338 
2339 pragma solidity ^0.8.4;
2340 
2341 
2342 
2343 
2344 
2345 
2346 
2347 
2348 contract MiladyRaveMaker is ERC721A, ERC721AQueryable, Ownable {
2349     using ECDSA for bytes32;
2350 
2351     uint256 public constant PRICE_UNIT = 0.001 ether;
2352 
2353     string private _tokenURI;
2354 
2355     address public signer;
2356 
2357     uint16 public maxSupply;
2358 
2359     uint16 private _miladyPriceUnits;
2360 
2361     uint16 private _publicPriceUnits;
2362 
2363     bool public paused;
2364 
2365     bool public mintLocked;
2366 
2367     bool public maxSupplyLocked;
2368 
2369     bool public tokenURILocked;
2370 
2371     constructor() ERC721A("MiladyRave", "MIR") {
2372         maxSupply = 5000;
2373         _miladyPriceUnits = _toPriceUnits(0.03 ether);
2374         _publicPriceUnits = _toPriceUnits(0.06 ether);
2375         paused = true; // Must be initialized to true.
2376     }
2377 
2378     function _startTokenId() internal view virtual override returns (uint256) {
2379         return 1;
2380     }
2381 
2382     function tokenURI(uint256 tokenId) public view override returns (string memory) {
2383         return LibString.replace(_tokenURI, "{id}", _toString(tokenId));
2384     }
2385 
2386     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
2387     /*                     MINTING FUNCTIONS                      */
2388     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
2389 
2390     function publicMint(uint256 quantity)
2391         external
2392         payable
2393         mintNotPaused
2394         requireMintable(quantity)
2395         requireExactPayment(_publicPriceUnits, quantity)
2396     {
2397         _mint(msg.sender, quantity);
2398     }
2399 
2400     function miladyMint(uint256 quantity, bytes calldata signature)
2401         external
2402         payable
2403         mintNotPaused
2404         requireMintable(quantity)
2405         requireSignature(signature)
2406         requireExactPayment(_miladyPriceUnits, quantity)
2407     {
2408         _mint(msg.sender, quantity);
2409     }
2410 
2411     function claimGiveaway(bytes calldata signature)
2412         external
2413         payable
2414         mintNotPaused
2415         requireMintable(1)
2416         requireSignature(signature)
2417     {
2418         require(_getAux(msg.sender) == 0, "Already claimed.");
2419         _setAux(msg.sender, 1);
2420 
2421         _mint(msg.sender, 1);
2422     }
2423 
2424     function hasClaimedGiveaway(address claimer) external view returns (bool) {
2425         return _getAux(claimer) != 0;
2426     }
2427 
2428     function miladyPrice() external view returns (uint256) {
2429         return _toPrice(_miladyPriceUnits);
2430     }
2431 
2432     function publicPrice() external view returns (uint256) {
2433         return _toPrice(_publicPriceUnits);
2434     }
2435 
2436     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
2437     /*                          HELPERS                           */
2438     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
2439 
2440     function _toPriceUnits(uint256 price) private pure returns (uint16) {
2441         unchecked {
2442             require(price % PRICE_UNIT == 0, "Price must be a multiple of PRICE_UNIT.");
2443             require((price /= PRICE_UNIT) <= type(uint16).max, "Overflow.");
2444             return uint16(price);
2445         }
2446     }
2447 
2448     function _toPrice(uint16 priceUnits) private pure returns (uint256) {
2449         return uint256(priceUnits) * PRICE_UNIT;
2450     }
2451 
2452     modifier requireMintable(uint256 quantity) {
2453         unchecked {
2454             require(mintLocked == false, "Locked.");
2455             require(_totalMinted() + quantity <= maxSupply, "Out of stock!");
2456         }
2457         _;
2458     }
2459 
2460     modifier requireExactPayment(uint16 priceUnits, uint256 quantity) {
2461         unchecked {
2462             require(quantity <= 100, "Quantity too high.");
2463             require(msg.value == _toPrice(priceUnits) * quantity, "Wrong Ether value.");
2464         }
2465         _;
2466     }
2467 
2468     modifier requireSignature(bytes calldata signature) {
2469         require(
2470             keccak256(abi.encode(msg.sender)).toEthSignedMessageHash().recover(signature) == signer,
2471             "Invalid signature."
2472         );
2473         _;
2474     }
2475 
2476     modifier mintNotPaused() {
2477         require(paused == false, "Paused.");
2478         _;
2479     }
2480 
2481     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
2482     /*                      ADMIN FUNCTIONS                       */
2483     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
2484 
2485     function forceMint(address[] calldata to, uint256 quantity)
2486         external
2487         onlyOwner
2488         requireMintable(quantity * to.length)
2489     {
2490         unchecked {
2491             for (uint256 i; i != to.length; ++i) {
2492                 _mint(to[i], quantity);
2493             }
2494         }
2495     }
2496 
2497     function selfMint(uint256 quantity) external onlyOwner requireMintable(quantity) {
2498         unchecked {
2499             uint256 miniBatchSize = 8;
2500             uint256 i = quantity % miniBatchSize;
2501             _mint(msg.sender, i);
2502             while (i != quantity) {
2503                 _mint(msg.sender, miniBatchSize);
2504                 i += miniBatchSize;
2505             }
2506         }
2507     }
2508 
2509     function setTokenURI(string calldata value) external onlyOwner {
2510         require(tokenURILocked == false, "Locked.");
2511         _tokenURI = value;
2512     }
2513 
2514     function setMaxSupply(uint16 value) external onlyOwner {
2515         require(maxSupplyLocked == false, "Locked.");
2516         maxSupply = value;
2517     }
2518 
2519     function setPaused(bool value) external onlyOwner {
2520         if (value == false) {
2521             require(maxSupply != 0, "Max supply not set.");
2522             require(signer != address(0), "Signer not set.");
2523         }
2524         paused = value;
2525     }
2526 
2527     function setSigner(address value) external onlyOwner {
2528         require(value != address(0), "Signer must not be the zero address.");
2529         signer = value;
2530     }
2531 
2532     function lockMint() external onlyOwner {
2533         mintLocked = true;
2534     }
2535 
2536     function lockMaxSupply() external onlyOwner {
2537         maxSupplyLocked = true;
2538     }
2539 
2540     function lockTokenURI() external onlyOwner {
2541         tokenURILocked = true;
2542     }
2543 
2544     function setMiladyPrice(uint256 value) external onlyOwner {
2545         _miladyPriceUnits = _toPriceUnits(value);
2546     }
2547 
2548     function setPublicPrice(uint256 value) external onlyOwner {
2549         _publicPriceUnits = _toPriceUnits(value);
2550     }
2551 
2552     function withdraw() external payable onlyOwner {
2553         SafeTransferLib.safeTransferETH(msg.sender, address(this).balance);
2554     }
2555 }