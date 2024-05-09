1 // SPDX-License-Identifier: MIT
2 // File: solady/src/utils/SafeTransferLib.sol
3 
4 
5 pragma solidity ^0.8.4;
6 
7 /// @notice Safe ETH and ERC20 transfer library that gracefully handles missing return values.
8 /// @author Solady (https://github.com/vectorized/solady/blob/main/src/utils/SafeTransferLib.sol)
9 /// @author Modified from Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/SafeTransferLib.sol)
10 /// @dev Caution! This library won't check that a token has code, responsibility is delegated to the caller.
11 library SafeTransferLib {
12     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
13     /*                       CUSTOM ERRORS                        */
14     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
15 
16     /// @dev The ETH transfer has failed.
17     error ETHTransferFailed();
18 
19     /// @dev The ERC20 `transferFrom` has failed.
20     error TransferFromFailed();
21 
22     /// @dev The ERC20 `transfer` has failed.
23     error TransferFailed();
24 
25     /// @dev The ERC20 `approve` has failed.
26     error ApproveFailed();
27 
28     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
29     /*                         CONSTANTS                          */
30     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
31 
32     /// @dev Suggested gas stipend for contract receiving ETH
33     /// that disallows any storage writes.
34     uint256 internal constant _GAS_STIPEND_NO_STORAGE_WRITES = 2300;
35 
36     /// @dev Suggested gas stipend for contract receiving ETH to perform a few
37     /// storage reads and writes, but low enough to prevent griefing.
38     /// Multiply by a small constant (e.g. 2), if needed.
39     uint256 internal constant _GAS_STIPEND_NO_GRIEF = 100000;
40 
41     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
42     /*                       ETH OPERATIONS                       */
43     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
44 
45     /// @dev Sends `amount` (in wei) ETH to `to`.
46     /// Reverts upon failure.
47     function safeTransferETH(address to, uint256 amount) internal {
48         /// @solidity memory-safe-assembly
49         assembly {
50             // Transfer the ETH and check if it succeeded or not.
51             if iszero(call(gas(), to, amount, 0, 0, 0, 0)) {
52                 // Store the function selector of `ETHTransferFailed()`.
53                 mstore(0x00, 0xb12d13eb)
54                 // Revert with (offset, size).
55                 revert(0x1c, 0x04)
56             }
57         }
58     }
59 
60     /// @dev Force sends `amount` (in wei) ETH to `to`, with a `gasStipend`.
61     /// The `gasStipend` can be set to a low enough value to prevent
62     /// storage writes or gas griefing.
63     ///
64     /// If sending via the normal procedure fails, force sends the ETH by
65     /// creating a temporary contract which uses `SELFDESTRUCT` to force send the ETH.
66     ///
67     /// Reverts if the current contract has insufficient balance.
68     function forceSafeTransferETH(address to, uint256 amount, uint256 gasStipend) internal {
69         /// @solidity memory-safe-assembly
70         assembly {
71             // If insufficient balance, revert.
72             if lt(selfbalance(), amount) {
73                 // Store the function selector of `ETHTransferFailed()`.
74                 mstore(0x00, 0xb12d13eb)
75                 // Revert with (offset, size).
76                 revert(0x1c, 0x04)
77             }
78             // Transfer the ETH and check if it succeeded or not.
79             if iszero(call(gasStipend, to, amount, 0, 0, 0, 0)) {
80                 mstore(0x00, to) // Store the address in scratch space.
81                 mstore8(0x0b, 0x73) // Opcode `PUSH20`.
82                 mstore8(0x20, 0xff) // Opcode `SELFDESTRUCT`.
83                 // We can directly use `SELFDESTRUCT` in the contract creation.
84                 // We don't check and revert upon failure here, just in case
85                 // `SELFDESTRUCT`'s behavior is changed some day in the future.
86                 // (If that ever happens, we will riot, and port the code to use WETH).
87                 pop(create(amount, 0x0b, 0x16))
88             }
89         }
90     }
91 
92     /// @dev Force sends `amount` (in wei) ETH to `to`, with a gas stipend
93     /// equal to `_GAS_STIPEND_NO_GRIEF`. This gas stipend is a reasonable default
94     /// for 99% of cases and can be overriden with the three-argument version of this
95     /// function if necessary.
96     ///
97     /// If sending via the normal procedure fails, force sends the ETH by
98     /// creating a temporary contract which uses `SELFDESTRUCT` to force send the ETH.
99     ///
100     /// Reverts if the current contract has insufficient balance.
101     function forceSafeTransferETH(address to, uint256 amount) internal {
102         // Manually inlined because the compiler doesn't inline functions with branches.
103         /// @solidity memory-safe-assembly
104         assembly {
105             // If insufficient balance, revert.
106             if lt(selfbalance(), amount) {
107                 // Store the function selector of `ETHTransferFailed()`.
108                 mstore(0x00, 0xb12d13eb)
109                 // Revert with (offset, size).
110                 revert(0x1c, 0x04)
111             }
112             // Transfer the ETH and check if it succeeded or not.
113             if iszero(call(_GAS_STIPEND_NO_GRIEF, to, amount, 0, 0, 0, 0)) {
114                 mstore(0x00, to) // Store the address in scratch space.
115                 mstore8(0x0b, 0x73) // Opcode `PUSH20`.
116                 mstore8(0x20, 0xff) // Opcode `SELFDESTRUCT`.
117                 // We can directly use `SELFDESTRUCT` in the contract creation.
118                 // We don't check and revert upon failure here, just in case
119                 // `SELFDESTRUCT`'s behavior is changed some day in the future.
120                 // (If that ever happens, we will riot, and port the code to use WETH).
121                 pop(create(amount, 0x0b, 0x16))
122             }
123         }
124     }
125 
126     /// @dev Sends `amount` (in wei) ETH to `to`, with a `gasStipend`.
127     /// The `gasStipend` can be set to a low enough value to prevent
128     /// storage writes or gas griefing.
129     ///
130     /// Simply use `gasleft()` for `gasStipend` if you don't need a gas stipend.
131     ///
132     /// Note: Does NOT revert upon failure.
133     /// Returns whether the transfer of ETH is successful instead.
134     function trySafeTransferETH(address to, uint256 amount, uint256 gasStipend)
135         internal
136         returns (bool success)
137     {
138         /// @solidity memory-safe-assembly
139         assembly {
140             // Transfer the ETH and check if it succeeded or not.
141             success := call(gasStipend, to, amount, 0, 0, 0, 0)
142         }
143     }
144 
145     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
146     /*                      ERC20 OPERATIONS                      */
147     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
148 
149     /// @dev Sends `amount` of ERC20 `token` from `from` to `to`.
150     /// Reverts upon failure.
151     ///
152     /// The `from` account must have at least `amount` approved for
153     /// the current contract to manage.
154     function safeTransferFrom(address token, address from, address to, uint256 amount) internal {
155         /// @solidity memory-safe-assembly
156         assembly {
157             // We'll write our calldata to this slot below, but restore it later.
158             let memPointer := mload(0x40)
159 
160             // Write the abi-encoded calldata into memory, beginning with the function selector.
161             mstore(0x00, 0x23b872dd)
162             mstore(0x20, from) // Append the "from" argument.
163             mstore(0x40, to) // Append the "to" argument.
164             mstore(0x60, amount) // Append the "amount" argument.
165 
166             if iszero(
167                 and(
168                     // Set success to whether the call reverted, if not we check it either
169                     // returned exactly 1 (can't just be non-zero data), or had no return data.
170                     or(eq(mload(0x00), 1), iszero(returndatasize())),
171                     // We use 0x64 because that's the total length of our calldata (0x04 + 0x20 * 3)
172                     // Counterintuitively, this call() must be positioned after the or() in the
173                     // surrounding and() because and() evaluates its arguments from right to left.
174                     call(gas(), token, 0, 0x1c, 0x64, 0x00, 0x20)
175                 )
176             ) {
177                 // Store the function selector of `TransferFromFailed()`.
178                 mstore(0x00, 0x7939f424)
179                 // Revert with (offset, size).
180                 revert(0x1c, 0x04)
181             }
182 
183             mstore(0x60, 0) // Restore the zero slot to zero.
184             mstore(0x40, memPointer) // Restore the memPointer.
185         }
186     }
187 
188     /// @dev Sends `amount` of ERC20 `token` from the current contract to `to`.
189     /// Reverts upon failure.
190     function safeTransfer(address token, address to, uint256 amount) internal {
191         /// @solidity memory-safe-assembly
192         assembly {
193             // We'll write our calldata to this slot below, but restore it later.
194             let memPointer := mload(0x40)
195 
196             // Write the abi-encoded calldata into memory, beginning with the function selector.
197             mstore(0x00, 0xa9059cbb)
198             mstore(0x20, to) // Append the "to" argument.
199             mstore(0x40, amount) // Append the "amount" argument.
200 
201             if iszero(
202                 and(
203                     // Set success to whether the call reverted, if not we check it either
204                     // returned exactly 1 (can't just be non-zero data), or had no return data.
205                     or(eq(mload(0x00), 1), iszero(returndatasize())),
206                     // We use 0x44 because that's the total length of our calldata (0x04 + 0x20 * 2)
207                     // Counterintuitively, this call() must be positioned after the or() in the
208                     // surrounding and() because and() evaluates its arguments from right to left.
209                     call(gas(), token, 0, 0x1c, 0x44, 0x00, 0x20)
210                 )
211             ) {
212                 // Store the function selector of `TransferFailed()`.
213                 mstore(0x00, 0x90b8ec18)
214                 // Revert with (offset, size).
215                 revert(0x1c, 0x04)
216             }
217 
218             mstore(0x40, memPointer) // Restore the memPointer.
219         }
220     }
221 
222     /// @dev Sets `amount` of ERC20 `token` for `to` to manage on behalf of the current contract.
223     /// Reverts upon failure.
224     function safeApprove(address token, address to, uint256 amount) internal {
225         /// @solidity memory-safe-assembly
226         assembly {
227             // We'll write our calldata to this slot below, but restore it later.
228             let memPointer := mload(0x40)
229 
230             // Write the abi-encoded calldata into memory, beginning with the function selector.
231             mstore(0x00, 0x095ea7b3)
232             mstore(0x20, to) // Append the "to" argument.
233             mstore(0x40, amount) // Append the "amount" argument.
234 
235             if iszero(
236                 and(
237                     // Set success to whether the call reverted, if not we check it either
238                     // returned exactly 1 (can't just be non-zero data), or had no return data.
239                     or(eq(mload(0x00), 1), iszero(returndatasize())),
240                     // We use 0x44 because that's the total length of our calldata (0x04 + 0x20 * 2)
241                     // Counterintuitively, this call() must be positioned after the or() in the
242                     // surrounding and() because and() evaluates its arguments from right to left.
243                     call(gas(), token, 0, 0x1c, 0x44, 0x00, 0x20)
244                 )
245             ) {
246                 // Store the function selector of `ApproveFailed()`.
247                 mstore(0x00, 0x3e3f8f73)
248                 // Revert with (offset, size).
249                 revert(0x1c, 0x04)
250             }
251 
252             mstore(0x40, memPointer) // Restore the memPointer.
253         }
254     }
255 }
256 
257 // File: solady/src/utils/LibString.sol
258 
259 
260 pragma solidity ^0.8.4;
261 
262 /// @notice Library for converting numbers into strings and other string operations.
263 /// @author Solady (https://github.com/vectorized/solady/blob/main/src/utils/LibString.sol)
264 /// @author Modified from Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/LibString.sol)
265 library LibString {
266     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
267     /*                        CUSTOM ERRORS                       */
268     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
269 
270     /// @dev The `length` of the output is too small to contain all the hex digits.
271     error HexLengthInsufficient();
272 
273     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
274     /*                         CONSTANTS                          */
275     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
276 
277     /// @dev The constant returned when the `search` is not found in the string.
278     uint256 internal constant NOT_FOUND = type(uint256).max;
279 
280     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
281     /*                     DECIMAL OPERATIONS                     */
282     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
283 
284     /// @dev Returns the base 10 decimal representation of `value`.
285     function toString(uint256 value) internal pure returns (string memory str) {
286         /// @solidity memory-safe-assembly
287         assembly {
288             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
289             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
290             // We will need 1 word for the trailing zeros padding, 1 word for the length,
291             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
292             let m := add(mload(0x40), 0xa0)
293             // Update the free memory pointer to allocate.
294             mstore(0x40, m)
295             // Assign the `str` to the end.
296             str := sub(m, 0x20)
297             // Zeroize the slot after the string.
298             mstore(str, 0)
299 
300             // Cache the end of the memory to calculate the length later.
301             let end := str
302 
303             // We write the string from rightmost digit to leftmost digit.
304             // The following is essentially a do-while loop that also handles the zero case.
305             for { let temp := value } 1 {} {
306                 str := sub(str, 1)
307                 // Write the character to the pointer.
308                 // The ASCII index of the '0' character is 48.
309                 mstore8(str, add(48, mod(temp, 10)))
310                 // Keep dividing `temp` until zero.
311                 temp := div(temp, 10)
312                 if iszero(temp) { break }
313             }
314 
315             let length := sub(end, str)
316             // Move the pointer 32 bytes leftwards to make room for the length.
317             str := sub(str, 0x20)
318             // Store the length.
319             mstore(str, length)
320         }
321     }
322 
323     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
324     /*                   HEXADECIMAL OPERATIONS                   */
325     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
326 
327     /// @dev Returns the hexadecimal representation of `value`,
328     /// left-padded to an input length of `length` bytes.
329     /// The output is prefixed with "0x" encoded using 2 hexadecimal digits per byte,
330     /// giving a total length of `length * 2 + 2` bytes.
331     /// Reverts if `length` is too small for the output to contain all the digits.
332     function toHexString(uint256 value, uint256 length) internal pure returns (string memory str) {
333         str = toHexStringNoPrefix(value, length);
334         /// @solidity memory-safe-assembly
335         assembly {
336             let strLength := add(mload(str), 2) // Compute the length.
337             mstore(str, 0x3078) // Write the "0x" prefix.
338             str := sub(str, 2) // Move the pointer.
339             mstore(str, strLength) // Write the length.
340         }
341     }
342 
343     /// @dev Returns the hexadecimal representation of `value`,
344     /// left-padded to an input length of `length` bytes.
345     /// The output is prefixed with "0x" encoded using 2 hexadecimal digits per byte,
346     /// giving a total length of `length * 2` bytes.
347     /// Reverts if `length` is too small for the output to contain all the digits.
348     function toHexStringNoPrefix(uint256 value, uint256 length)
349         internal
350         pure
351         returns (string memory str)
352     {
353         /// @solidity memory-safe-assembly
354         assembly {
355             let start := mload(0x40)
356             // We need 0x20 bytes for the trailing zeros padding, `length * 2` bytes
357             // for the digits, 0x02 bytes for the prefix, and 0x20 bytes for the length.
358             // We add 0x20 to the total and round down to a multiple of 0x20.
359             // (0x20 + 0x20 + 0x02 + 0x20) = 0x62.
360             let m := add(start, and(add(shl(1, length), 0x62), not(0x1f)))
361             // Allocate the memory.
362             mstore(0x40, m)
363             // Assign the `str` to the end.
364             str := sub(m, 0x20)
365             // Zeroize the slot after the string.
366             mstore(str, 0)
367 
368             // Cache the end to calculate the length later.
369             let end := str
370             // Store "0123456789abcdef" in scratch space.
371             mstore(0x0f, 0x30313233343536373839616263646566)
372 
373             let temp := value
374             // We write the string from rightmost digit to leftmost digit.
375             // The following is essentially a do-while loop that also handles the zero case.
376             for {} 1 {} {
377                 str := sub(str, 2)
378                 mstore8(add(str, 1), mload(and(temp, 15)))
379                 mstore8(str, mload(and(shr(4, temp), 15)))
380                 temp := shr(8, temp)
381                 length := sub(length, 1)
382                 if iszero(length) { break }
383             }
384 
385             if temp {
386                 // Store the function selector of `HexLengthInsufficient()`.
387                 mstore(0x00, 0x2194895a)
388                 // Revert with (offset, size).
389                 revert(0x1c, 0x04)
390             }
391 
392             // Compute the string's length.
393             let strLength := sub(end, str)
394             // Move the pointer and write the length.
395             str := sub(str, 0x20)
396             mstore(str, strLength)
397         }
398     }
399 
400     /// @dev Returns the hexadecimal representation of `value`.
401     /// The output is prefixed with "0x" and encoded using 2 hexadecimal digits per byte.
402     /// As address are 20 bytes long, the output will left-padded to have
403     /// a length of `20 * 2 + 2` bytes.
404     function toHexString(uint256 value) internal pure returns (string memory str) {
405         str = toHexStringNoPrefix(value);
406         /// @solidity memory-safe-assembly
407         assembly {
408             let strLength := add(mload(str), 2) // Compute the length.
409             mstore(str, 0x3078) // Write the "0x" prefix.
410             str := sub(str, 2) // Move the pointer.
411             mstore(str, strLength) // Write the length.
412         }
413     }
414 
415     /// @dev Returns the hexadecimal representation of `value`.
416     /// The output is encoded using 2 hexadecimal digits per byte.
417     /// As address are 20 bytes long, the output will left-padded to have
418     /// a length of `20 * 2` bytes.
419     function toHexStringNoPrefix(uint256 value) internal pure returns (string memory str) {
420         /// @solidity memory-safe-assembly
421         assembly {
422             let start := mload(0x40)
423             // We need 0x20 bytes for the trailing zeros padding, 0x20 bytes for the length,
424             // 0x02 bytes for the prefix, and 0x40 bytes for the digits.
425             // The next multiple of 0x20 above (0x20 + 0x20 + 0x02 + 0x40) is 0xa0.
426             let m := add(start, 0xa0)
427             // Allocate the memory.
428             mstore(0x40, m)
429             // Assign the `str` to the end.
430             str := sub(m, 0x20)
431             // Zeroize the slot after the string.
432             mstore(str, 0)
433 
434             // Cache the end to calculate the length later.
435             let end := str
436             // Store "0123456789abcdef" in scratch space.
437             mstore(0x0f, 0x30313233343536373839616263646566)
438 
439             // We write the string from rightmost digit to leftmost digit.
440             // The following is essentially a do-while loop that also handles the zero case.
441             for { let temp := value } 1 {} {
442                 str := sub(str, 2)
443                 mstore8(add(str, 1), mload(and(temp, 15)))
444                 mstore8(str, mload(and(shr(4, temp), 15)))
445                 temp := shr(8, temp)
446                 if iszero(temp) { break }
447             }
448 
449             // Compute the string's length.
450             let strLength := sub(end, str)
451             // Move the pointer and write the length.
452             str := sub(str, 0x20)
453             mstore(str, strLength)
454         }
455     }
456 
457     /// @dev Returns the hexadecimal representation of `value`.
458     /// The output is prefixed with "0x", encoded using 2 hexadecimal digits per byte,
459     /// and the alphabets are capitalized conditionally according to
460     /// https://eips.ethereum.org/EIPS/eip-55
461     function toHexStringChecksumed(address value) internal pure returns (string memory str) {
462         str = toHexString(value);
463         /// @solidity memory-safe-assembly
464         assembly {
465             let mask := shl(6, div(not(0), 255)) // `0b010000000100000000 ...`
466             let o := add(str, 0x22)
467             let hashed := and(keccak256(o, 40), mul(34, mask)) // `0b10001000 ... `
468             let t := shl(240, 136) // `0b10001000 << 240`
469             for { let i := 0 } 1 {} {
470                 mstore(add(i, i), mul(t, byte(i, hashed)))
471                 i := add(i, 1)
472                 if eq(i, 20) { break }
473             }
474             mstore(o, xor(mload(o), shr(1, and(mload(0x00), and(mload(o), mask)))))
475             o := add(o, 0x20)
476             mstore(o, xor(mload(o), shr(1, and(mload(0x20), and(mload(o), mask)))))
477         }
478     }
479 
480     /// @dev Returns the hexadecimal representation of `value`.
481     /// The output is prefixed with "0x" and encoded using 2 hexadecimal digits per byte.
482     function toHexString(address value) internal pure returns (string memory str) {
483         str = toHexStringNoPrefix(value);
484         /// @solidity memory-safe-assembly
485         assembly {
486             let strLength := add(mload(str), 2) // Compute the length.
487             mstore(str, 0x3078) // Write the "0x" prefix.
488             str := sub(str, 2) // Move the pointer.
489             mstore(str, strLength) // Write the length.
490         }
491     }
492 
493     /// @dev Returns the hexadecimal representation of `value`.
494     /// The output is encoded using 2 hexadecimal digits per byte.
495     function toHexStringNoPrefix(address value) internal pure returns (string memory str) {
496         /// @solidity memory-safe-assembly
497         assembly {
498             str := mload(0x40)
499 
500             // Allocate the memory.
501             // We need 0x20 bytes for the trailing zeros padding, 0x20 bytes for the length,
502             // 0x02 bytes for the prefix, and 0x28 bytes for the digits.
503             // The next multiple of 0x20 above (0x20 + 0x20 + 0x02 + 0x28) is 0x80.
504             mstore(0x40, add(str, 0x80))
505 
506             // Store "0123456789abcdef" in scratch space.
507             mstore(0x0f, 0x30313233343536373839616263646566)
508 
509             str := add(str, 2)
510             mstore(str, 40)
511 
512             let o := add(str, 0x20)
513             mstore(add(o, 40), 0)
514 
515             value := shl(96, value)
516 
517             // We write the string from rightmost digit to leftmost digit.
518             // The following is essentially a do-while loop that also handles the zero case.
519             for { let i := 0 } 1 {} {
520                 let p := add(o, add(i, i))
521                 let temp := byte(i, value)
522                 mstore8(add(p, 1), mload(and(temp, 15)))
523                 mstore8(p, mload(shr(4, temp)))
524                 i := add(i, 1)
525                 if eq(i, 20) { break }
526             }
527         }
528     }
529 
530     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
531     /*                   RUNE STRING OPERATIONS                   */
532     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
533 
534     /// @dev Returns the number of UTF characters in the string.
535     function runeCount(string memory s) internal pure returns (uint256 result) {
536         /// @solidity memory-safe-assembly
537         assembly {
538             if mload(s) {
539                 mstore(0x00, div(not(0), 255))
540                 mstore(0x20, 0x0202020202020202020202020202020202020202020202020303030304040506)
541                 let o := add(s, 0x20)
542                 let end := add(o, mload(s))
543                 for { result := 1 } 1 { result := add(result, 1) } {
544                     o := add(o, byte(0, mload(shr(250, mload(o)))))
545                     if iszero(lt(o, end)) { break }
546                 }
547             }
548         }
549     }
550 
551     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
552     /*                   BYTE STRING OPERATIONS                   */
553     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
554 
555     // For performance and bytecode compactness, all indices of the following operations
556     // are byte (ASCII) offsets, not UTF character offsets.
557 
558     /// @dev Returns `subject` all occurrences of `search` replaced with `replacement`.
559     function replace(string memory subject, string memory search, string memory replacement)
560         internal
561         pure
562         returns (string memory result)
563     {
564         /// @solidity memory-safe-assembly
565         assembly {
566             let subjectLength := mload(subject)
567             let searchLength := mload(search)
568             let replacementLength := mload(replacement)
569 
570             subject := add(subject, 0x20)
571             search := add(search, 0x20)
572             replacement := add(replacement, 0x20)
573             result := add(mload(0x40), 0x20)
574 
575             let subjectEnd := add(subject, subjectLength)
576             if iszero(gt(searchLength, subjectLength)) {
577                 let subjectSearchEnd := add(sub(subjectEnd, searchLength), 1)
578                 let h := 0
579                 if iszero(lt(searchLength, 32)) { h := keccak256(search, searchLength) }
580                 let m := shl(3, sub(32, and(searchLength, 31)))
581                 let s := mload(search)
582                 for {} 1 {} {
583                     let t := mload(subject)
584                     // Whether the first `searchLength % 32` bytes of
585                     // `subject` and `search` matches.
586                     if iszero(shr(m, xor(t, s))) {
587                         if h {
588                             if iszero(eq(keccak256(subject, searchLength), h)) {
589                                 mstore(result, t)
590                                 result := add(result, 1)
591                                 subject := add(subject, 1)
592                                 if iszero(lt(subject, subjectSearchEnd)) { break }
593                                 continue
594                             }
595                         }
596                         // Copy the `replacement` one word at a time.
597                         for { let o := 0 } 1 {} {
598                             mstore(add(result, o), mload(add(replacement, o)))
599                             o := add(o, 0x20)
600                             if iszero(lt(o, replacementLength)) { break }
601                         }
602                         result := add(result, replacementLength)
603                         subject := add(subject, searchLength)
604                         if searchLength {
605                             if iszero(lt(subject, subjectSearchEnd)) { break }
606                             continue
607                         }
608                     }
609                     mstore(result, t)
610                     result := add(result, 1)
611                     subject := add(subject, 1)
612                     if iszero(lt(subject, subjectSearchEnd)) { break }
613                 }
614             }
615 
616             let resultRemainder := result
617             result := add(mload(0x40), 0x20)
618             let k := add(sub(resultRemainder, result), sub(subjectEnd, subject))
619             // Copy the rest of the string one word at a time.
620             for {} lt(subject, subjectEnd) {} {
621                 mstore(resultRemainder, mload(subject))
622                 resultRemainder := add(resultRemainder, 0x20)
623                 subject := add(subject, 0x20)
624             }
625             result := sub(result, 0x20)
626             // Zeroize the slot after the string.
627             let last := add(add(result, 0x20), k)
628             mstore(last, 0)
629             // Allocate memory for the length and the bytes,
630             // rounded up to a multiple of 32.
631             mstore(0x40, and(add(last, 31), not(31)))
632             // Store the length of the result.
633             mstore(result, k)
634         }
635     }
636 
637     /// @dev Returns the byte index of the first location of `search` in `subject`,
638     /// searching from left to right, starting from `from`.
639     /// Returns `NOT_FOUND` (i.e. `type(uint256).max`) if the `search` is not found.
640     function indexOf(string memory subject, string memory search, uint256 from)
641         internal
642         pure
643         returns (uint256 result)
644     {
645         /// @solidity memory-safe-assembly
646         assembly {
647             for { let subjectLength := mload(subject) } 1 {} {
648                 if iszero(mload(search)) {
649                     // `result = min(from, subjectLength)`.
650                     result := xor(from, mul(xor(from, subjectLength), lt(subjectLength, from)))
651                     break
652                 }
653                 let searchLength := mload(search)
654                 let subjectStart := add(subject, 0x20)
655 
656                 result := not(0) // Initialize to `NOT_FOUND`.
657 
658                 subject := add(subjectStart, from)
659                 let subjectSearchEnd := add(sub(add(subjectStart, subjectLength), searchLength), 1)
660 
661                 let m := shl(3, sub(32, and(searchLength, 31)))
662                 let s := mload(add(search, 0x20))
663 
664                 if iszero(lt(subject, subjectSearchEnd)) { break }
665 
666                 if iszero(lt(searchLength, 32)) {
667                     for { let h := keccak256(add(search, 0x20), searchLength) } 1 {} {
668                         if iszero(shr(m, xor(mload(subject), s))) {
669                             if eq(keccak256(subject, searchLength), h) {
670                                 result := sub(subject, subjectStart)
671                                 break
672                             }
673                         }
674                         subject := add(subject, 1)
675                         if iszero(lt(subject, subjectSearchEnd)) { break }
676                     }
677                     break
678                 }
679                 for {} 1 {} {
680                     if iszero(shr(m, xor(mload(subject), s))) {
681                         result := sub(subject, subjectStart)
682                         break
683                     }
684                     subject := add(subject, 1)
685                     if iszero(lt(subject, subjectSearchEnd)) { break }
686                 }
687                 break
688             }
689         }
690     }
691 
692     /// @dev Returns the byte index of the first location of `search` in `subject`,
693     /// searching from left to right.
694     /// Returns `NOT_FOUND` (i.e. `type(uint256).max`) if the `search` is not found.
695     function indexOf(string memory subject, string memory search)
696         internal
697         pure
698         returns (uint256 result)
699     {
700         result = indexOf(subject, search, 0);
701     }
702 
703     /// @dev Returns the byte index of the first location of `search` in `subject`,
704     /// searching from right to left, starting from `from`.
705     /// Returns `NOT_FOUND` (i.e. `type(uint256).max`) if the `search` is not found.
706     function lastIndexOf(string memory subject, string memory search, uint256 from)
707         internal
708         pure
709         returns (uint256 result)
710     {
711         /// @solidity memory-safe-assembly
712         assembly {
713             for {} 1 {} {
714                 let searchLength := mload(search)
715                 let fromMax := sub(mload(subject), searchLength)
716                 if iszero(gt(fromMax, from)) { from := fromMax }
717                 if iszero(mload(search)) {
718                     result := from
719                     break
720                 }
721                 result := not(0) // Initialize to `NOT_FOUND`.
722 
723                 let subjectSearchEnd := sub(add(subject, 0x20), 1)
724 
725                 subject := add(add(subject, 0x20), from)
726                 if iszero(gt(subject, subjectSearchEnd)) { break }
727                 // As this function is not too often used,
728                 // we shall simply use keccak256 for smaller bytecode size.
729                 for { let h := keccak256(add(search, 0x20), searchLength) } 1 {} {
730                     if eq(keccak256(subject, searchLength), h) {
731                         result := sub(subject, add(subjectSearchEnd, 1))
732                         break
733                     }
734                     subject := sub(subject, 1)
735                     if iszero(gt(subject, subjectSearchEnd)) { break }
736                 }
737                 break
738             }
739         }
740     }
741 
742     /// @dev Returns the byte index of the first location of `search` in `subject`,
743     /// searching from right to left.
744     /// Returns `NOT_FOUND` (i.e. `type(uint256).max`) if the `search` is not found.
745     function lastIndexOf(string memory subject, string memory search)
746         internal
747         pure
748         returns (uint256 result)
749     {
750         result = lastIndexOf(subject, search, uint256(int256(-1)));
751     }
752 
753     /// @dev Returns whether `subject` starts with `search`.
754     function startsWith(string memory subject, string memory search)
755         internal
756         pure
757         returns (bool result)
758     {
759         /// @solidity memory-safe-assembly
760         assembly {
761             let searchLength := mload(search)
762             // Just using keccak256 directly is actually cheaper.
763             // forgefmt: disable-next-item
764             result := and(
765                 iszero(gt(searchLength, mload(subject))),
766                 eq(
767                     keccak256(add(subject, 0x20), searchLength),
768                     keccak256(add(search, 0x20), searchLength)
769                 )
770             )
771         }
772     }
773 
774     /// @dev Returns whether `subject` ends with `search`.
775     function endsWith(string memory subject, string memory search)
776         internal
777         pure
778         returns (bool result)
779     {
780         /// @solidity memory-safe-assembly
781         assembly {
782             let searchLength := mload(search)
783             let subjectLength := mload(subject)
784             // Whether `search` is not longer than `subject`.
785             let withinRange := iszero(gt(searchLength, subjectLength))
786             // Just using keccak256 directly is actually cheaper.
787             // forgefmt: disable-next-item
788             result := and(
789                 withinRange,
790                 eq(
791                     keccak256(
792                         // `subject + 0x20 + max(subjectLength - searchLength, 0)`.
793                         add(add(subject, 0x20), mul(withinRange, sub(subjectLength, searchLength))),
794                         searchLength
795                     ),
796                     keccak256(add(search, 0x20), searchLength)
797                 )
798             )
799         }
800     }
801 
802     /// @dev Returns `subject` repeated `times`.
803     function repeat(string memory subject, uint256 times)
804         internal
805         pure
806         returns (string memory result)
807     {
808         /// @solidity memory-safe-assembly
809         assembly {
810             let subjectLength := mload(subject)
811             if iszero(or(iszero(times), iszero(subjectLength))) {
812                 subject := add(subject, 0x20)
813                 result := mload(0x40)
814                 let output := add(result, 0x20)
815                 for {} 1 {} {
816                     // Copy the `subject` one word at a time.
817                     for { let o := 0 } 1 {} {
818                         mstore(add(output, o), mload(add(subject, o)))
819                         o := add(o, 0x20)
820                         if iszero(lt(o, subjectLength)) { break }
821                     }
822                     output := add(output, subjectLength)
823                     times := sub(times, 1)
824                     if iszero(times) { break }
825                 }
826                 // Zeroize the slot after the string.
827                 mstore(output, 0)
828                 // Store the length.
829                 let resultLength := sub(output, add(result, 0x20))
830                 mstore(result, resultLength)
831                 // Allocate memory for the length and the bytes,
832                 // rounded up to a multiple of 32.
833                 mstore(0x40, add(result, and(add(resultLength, 63), not(31))))
834             }
835         }
836     }
837 
838     /// @dev Returns a copy of `subject` sliced from `start` to `end` (exclusive).
839     /// `start` and `end` are byte offsets.
840     function slice(string memory subject, uint256 start, uint256 end)
841         internal
842         pure
843         returns (string memory result)
844     {
845         /// @solidity memory-safe-assembly
846         assembly {
847             let subjectLength := mload(subject)
848             if iszero(gt(subjectLength, end)) { end := subjectLength }
849             if iszero(gt(subjectLength, start)) { start := subjectLength }
850             if lt(start, end) {
851                 result := mload(0x40)
852                 let resultLength := sub(end, start)
853                 mstore(result, resultLength)
854                 subject := add(subject, start)
855                 let w := not(31)
856                 // Copy the `subject` one word at a time, backwards.
857                 for { let o := and(add(resultLength, 31), w) } 1 {} {
858                     mstore(add(result, o), mload(add(subject, o)))
859                     o := add(o, w) // `sub(o, 0x20)`.
860                     if iszero(o) { break }
861                 }
862                 // Zeroize the slot after the string.
863                 mstore(add(add(result, 0x20), resultLength), 0)
864                 // Allocate memory for the length and the bytes,
865                 // rounded up to a multiple of 32.
866                 mstore(0x40, add(result, and(add(resultLength, 63), w)))
867             }
868         }
869     }
870 
871     /// @dev Returns a copy of `subject` sliced from `start` to the end of the string.
872     /// `start` is a byte offset.
873     function slice(string memory subject, uint256 start)
874         internal
875         pure
876         returns (string memory result)
877     {
878         result = slice(subject, start, uint256(int256(-1)));
879     }
880 
881     /// @dev Returns all the indices of `search` in `subject`.
882     /// The indices are byte offsets.
883     function indicesOf(string memory subject, string memory search)
884         internal
885         pure
886         returns (uint256[] memory result)
887     {
888         /// @solidity memory-safe-assembly
889         assembly {
890             let subjectLength := mload(subject)
891             let searchLength := mload(search)
892 
893             if iszero(gt(searchLength, subjectLength)) {
894                 subject := add(subject, 0x20)
895                 search := add(search, 0x20)
896                 result := add(mload(0x40), 0x20)
897 
898                 let subjectStart := subject
899                 let subjectSearchEnd := add(sub(add(subject, subjectLength), searchLength), 1)
900                 let h := 0
901                 if iszero(lt(searchLength, 32)) { h := keccak256(search, searchLength) }
902                 let m := shl(3, sub(32, and(searchLength, 31)))
903                 let s := mload(search)
904                 for {} 1 {} {
905                     let t := mload(subject)
906                     // Whether the first `searchLength % 32` bytes of
907                     // `subject` and `search` matches.
908                     if iszero(shr(m, xor(t, s))) {
909                         if h {
910                             if iszero(eq(keccak256(subject, searchLength), h)) {
911                                 subject := add(subject, 1)
912                                 if iszero(lt(subject, subjectSearchEnd)) { break }
913                                 continue
914                             }
915                         }
916                         // Append to `result`.
917                         mstore(result, sub(subject, subjectStart))
918                         result := add(result, 0x20)
919                         // Advance `subject` by `searchLength`.
920                         subject := add(subject, searchLength)
921                         if searchLength {
922                             if iszero(lt(subject, subjectSearchEnd)) { break }
923                             continue
924                         }
925                     }
926                     subject := add(subject, 1)
927                     if iszero(lt(subject, subjectSearchEnd)) { break }
928                 }
929                 let resultEnd := result
930                 // Assign `result` to the free memory pointer.
931                 result := mload(0x40)
932                 // Store the length of `result`.
933                 mstore(result, shr(5, sub(resultEnd, add(result, 0x20))))
934                 // Allocate memory for result.
935                 // We allocate one more word, so this array can be recycled for {split}.
936                 mstore(0x40, add(resultEnd, 0x20))
937             }
938         }
939     }
940 
941     /// @dev Returns a arrays of strings based on the `delimiter` inside of the `subject` string.
942     function split(string memory subject, string memory delimiter)
943         internal
944         pure
945         returns (string[] memory result)
946     {
947         uint256[] memory indices = indicesOf(subject, delimiter);
948         /// @solidity memory-safe-assembly
949         assembly {
950             let w := not(31)
951             let indexPtr := add(indices, 0x20)
952             let indicesEnd := add(indexPtr, shl(5, add(mload(indices), 1)))
953             mstore(add(indicesEnd, w), mload(subject))
954             mstore(indices, add(mload(indices), 1))
955             let prevIndex := 0
956             for {} 1 {} {
957                 let index := mload(indexPtr)
958                 mstore(indexPtr, 0x60)
959                 if iszero(eq(index, prevIndex)) {
960                     let element := mload(0x40)
961                     let elementLength := sub(index, prevIndex)
962                     mstore(element, elementLength)
963                     // Copy the `subject` one word at a time, backwards.
964                     for { let o := and(add(elementLength, 31), w) } 1 {} {
965                         mstore(add(element, o), mload(add(add(subject, prevIndex), o)))
966                         o := add(o, w) // `sub(o, 0x20)`.
967                         if iszero(o) { break }
968                     }
969                     // Zeroize the slot after the string.
970                     mstore(add(add(element, 0x20), elementLength), 0)
971                     // Allocate memory for the length and the bytes,
972                     // rounded up to a multiple of 32.
973                     mstore(0x40, add(element, and(add(elementLength, 63), w)))
974                     // Store the `element` into the array.
975                     mstore(indexPtr, element)
976                 }
977                 prevIndex := add(index, mload(delimiter))
978                 indexPtr := add(indexPtr, 0x20)
979                 if iszero(lt(indexPtr, indicesEnd)) { break }
980             }
981             result := indices
982             if iszero(mload(delimiter)) {
983                 result := add(indices, 0x20)
984                 mstore(result, sub(mload(indices), 2))
985             }
986         }
987     }
988 
989     /// @dev Returns a concatenated string of `a` and `b`.
990     /// Cheaper than `string.concat()` and does not de-align the free memory pointer.
991     function concat(string memory a, string memory b)
992         internal
993         pure
994         returns (string memory result)
995     {
996         /// @solidity memory-safe-assembly
997         assembly {
998             let w := not(31)
999             result := mload(0x40)
1000             let aLength := mload(a)
1001             // Copy `a` one word at a time, backwards.
1002             for { let o := and(add(mload(a), 32), w) } 1 {} {
1003                 mstore(add(result, o), mload(add(a, o)))
1004                 o := add(o, w) // `sub(o, 0x20)`.
1005                 if iszero(o) { break }
1006             }
1007             let bLength := mload(b)
1008             let output := add(result, mload(a))
1009             // Copy `b` one word at a time, backwards.
1010             for { let o := and(add(bLength, 32), w) } 1 {} {
1011                 mstore(add(output, o), mload(add(b, o)))
1012                 o := add(o, w) // `sub(o, 0x20)`.
1013                 if iszero(o) { break }
1014             }
1015             let totalLength := add(aLength, bLength)
1016             let last := add(add(result, 0x20), totalLength)
1017             // Zeroize the slot after the string.
1018             mstore(last, 0)
1019             // Stores the length.
1020             mstore(result, totalLength)
1021             // Allocate memory for the length and the bytes,
1022             // rounded up to a multiple of 32.
1023             mstore(0x40, and(add(last, 31), w))
1024         }
1025     }
1026 
1027     /// @dev Returns a copy of the string in either lowercase or UPPERCASE.
1028     function toCase(string memory subject, bool toUpper)
1029         internal
1030         pure
1031         returns (string memory result)
1032     {
1033         /// @solidity memory-safe-assembly
1034         assembly {
1035             let length := mload(subject)
1036             if length {
1037                 result := add(mload(0x40), 0x20)
1038                 subject := add(subject, 1)
1039                 let flags := shl(add(70, shl(5, toUpper)), 67108863)
1040                 let w := not(0)
1041                 for { let o := length } 1 {} {
1042                     o := add(o, w)
1043                     let b := and(0xff, mload(add(subject, o)))
1044                     mstore8(add(result, o), xor(b, and(shr(b, flags), 0x20)))
1045                     if iszero(o) { break }
1046                 }
1047                 // Restore the result.
1048                 result := mload(0x40)
1049                 // Stores the string length.
1050                 mstore(result, length)
1051                 // Zeroize the slot after the string.
1052                 let last := add(add(result, 0x20), length)
1053                 mstore(last, 0)
1054                 // Allocate memory for the length and the bytes,
1055                 // rounded up to a multiple of 32.
1056                 mstore(0x40, and(add(last, 31), not(31)))
1057             }
1058         }
1059     }
1060 
1061     /// @dev Returns a lowercased copy of the string.
1062     function lower(string memory subject) internal pure returns (string memory result) {
1063         result = toCase(subject, false);
1064     }
1065 
1066     /// @dev Returns an UPPERCASED copy of the string.
1067     function upper(string memory subject) internal pure returns (string memory result) {
1068         result = toCase(subject, true);
1069     }
1070 
1071     /// @dev Escapes the string to be used within HTML tags.
1072     function escapeHTML(string memory s) internal pure returns (string memory result) {
1073         /// @solidity memory-safe-assembly
1074         assembly {
1075             for {
1076                 let end := add(s, mload(s))
1077                 result := add(mload(0x40), 0x20)
1078                 // Store the bytes of the packed offsets and strides into the scratch space.
1079                 // `packed = (stride << 5) | offset`. Max offset is 20. Max stride is 6.
1080                 mstore(0x1f, 0x900094)
1081                 mstore(0x08, 0xc0000000a6ab)
1082                 // Store "&quot;&amp;&#39;&lt;&gt;" into the scratch space.
1083                 mstore(0x00, shl(64, 0x2671756f743b26616d703b262333393b266c743b2667743b))
1084             } iszero(eq(s, end)) {} {
1085                 s := add(s, 1)
1086                 let c := and(mload(s), 0xff)
1087                 // Not in `["\"","'","&","<",">"]`.
1088                 if iszero(and(shl(c, 1), 0x500000c400000000)) {
1089                     mstore8(result, c)
1090                     result := add(result, 1)
1091                     continue
1092                 }
1093                 let t := shr(248, mload(c))
1094                 mstore(result, mload(and(t, 31)))
1095                 result := add(result, shr(5, t))
1096             }
1097             let last := result
1098             // Zeroize the slot after the string.
1099             mstore(last, 0)
1100             // Restore the result to the start of the free memory.
1101             result := mload(0x40)
1102             // Store the length of the result.
1103             mstore(result, sub(last, add(result, 0x20)))
1104             // Allocate memory for the length and the bytes,
1105             // rounded up to a multiple of 32.
1106             mstore(0x40, and(add(last, 31), not(31)))
1107         }
1108     }
1109 
1110     /// @dev Escapes the string to be used within double-quotes in a JSON.
1111     function escapeJSON(string memory s) internal pure returns (string memory result) {
1112         /// @solidity memory-safe-assembly
1113         assembly {
1114             for {
1115                 let end := add(s, mload(s))
1116                 result := add(mload(0x40), 0x20)
1117                 // Store "\\u0000" in scratch space.
1118                 // Store "0123456789abcdef" in scratch space.
1119                 // Also, store `{0x08:"b", 0x09:"t", 0x0a:"n", 0x0c:"f", 0x0d:"r"}`.
1120                 // into the scratch space.
1121                 mstore(0x15, 0x5c75303030303031323334353637383961626364656662746e006672)
1122                 // Bitmask for detecting `["\"","\\"]`.
1123                 let e := or(shl(0x22, 1), shl(0x5c, 1))
1124             } iszero(eq(s, end)) {} {
1125                 s := add(s, 1)
1126                 let c := and(mload(s), 0xff)
1127                 if iszero(lt(c, 0x20)) {
1128                     if iszero(and(shl(c, 1), e)) {
1129                         // Not in `["\"","\\"]`.
1130                         mstore8(result, c)
1131                         result := add(result, 1)
1132                         continue
1133                     }
1134                     mstore8(result, 0x5c) // "\\".
1135                     mstore8(add(result, 1), c)
1136                     result := add(result, 2)
1137                     continue
1138                 }
1139                 if iszero(and(shl(c, 1), 0x3700)) {
1140                     // Not in `["\b","\t","\n","\f","\d"]`.
1141                     mstore8(0x1d, mload(shr(4, c))) // Hex value.
1142                     mstore8(0x1e, mload(and(c, 15))) // Hex value.
1143                     mstore(result, mload(0x19)) // "\\u00XX".
1144                     result := add(result, 6)
1145                     continue
1146                 }
1147                 mstore8(result, 0x5c) // "\\".
1148                 mstore8(add(result, 1), mload(add(c, 8)))
1149                 result := add(result, 2)
1150             }
1151             let last := result
1152             // Zeroize the slot after the string.
1153             mstore(last, 0)
1154             // Restore the result to the start of the free memory.
1155             result := mload(0x40)
1156             // Store the length of the result.
1157             mstore(result, sub(last, add(result, 0x20)))
1158             // Allocate memory for the length and the bytes,
1159             // rounded up to a multiple of 32.
1160             mstore(0x40, and(add(last, 31), not(31)))
1161         }
1162     }
1163 
1164     /// @dev Returns whether `a` equals `b`.
1165     function eq(string memory a, string memory b) internal pure returns (bool result) {
1166         assembly {
1167             result := eq(keccak256(add(a, 0x20), mload(a)), keccak256(add(b, 0x20), mload(b)))
1168         }
1169     }
1170 
1171     /// @dev Packs a single string with its length into a single word.
1172     /// Returns `bytes32(0)` if the length is zero or greater than 31.
1173     function packOne(string memory a) internal pure returns (bytes32 result) {
1174         /// @solidity memory-safe-assembly
1175         assembly {
1176             // We don't need to zero right pad the string,
1177             // since this is our own custom non-standard packing scheme.
1178             result :=
1179                 mul(
1180                     // Load the length and the bytes.
1181                     mload(add(a, 0x1f)),
1182                     // `length != 0 && length < 32`. Abuses underflow.
1183                     // Assumes that the length is valid and within the block gas limit.
1184                     lt(sub(mload(a), 1), 0x1f)
1185                 )
1186         }
1187     }
1188 
1189     /// @dev Unpacks a string packed using {packOne}.
1190     /// Returns the empty string if `packed` is `bytes32(0)`.
1191     /// If `packed` is not an output of {packOne}, the output behaviour is undefined.
1192     function unpackOne(bytes32 packed) internal pure returns (string memory result) {
1193         /// @solidity memory-safe-assembly
1194         assembly {
1195             // Grab the free memory pointer.
1196             result := mload(0x40)
1197             // Allocate 2 words (1 for the length, 1 for the bytes).
1198             mstore(0x40, add(result, 0x40))
1199             // Zeroize the length slot.
1200             mstore(result, 0)
1201             // Store the length and bytes.
1202             mstore(add(result, 0x1f), packed)
1203             // Right pad with zeroes.
1204             mstore(add(add(result, 0x20), mload(result)), 0)
1205         }
1206     }
1207 
1208     /// @dev Packs two strings with their lengths into a single word.
1209     /// Returns `bytes32(0)` if combined length is zero or greater than 30.
1210     function packTwo(string memory a, string memory b) internal pure returns (bytes32 result) {
1211         /// @solidity memory-safe-assembly
1212         assembly {
1213             let aLength := mload(a)
1214             // We don't need to zero right pad the strings,
1215             // since this is our own custom non-standard packing scheme.
1216             result :=
1217                 mul(
1218                     // Load the length and the bytes of `a` and `b`.
1219                     or(
1220                         shl(shl(3, sub(0x1f, aLength)), mload(add(a, aLength))),
1221                         mload(sub(add(b, 0x1e), aLength))
1222                     ),
1223                     // `totalLength != 0 && totalLength < 31`. Abuses underflow.
1224                     // Assumes that the lengths are valid and within the block gas limit.
1225                     lt(sub(add(aLength, mload(b)), 1), 0x1e)
1226                 )
1227         }
1228     }
1229 
1230     /// @dev Unpacks strings packed using {packTwo}.
1231     /// Returns the empty strings if `packed` is `bytes32(0)`.
1232     /// If `packed` is not an output of {packTwo}, the output behaviour is undefined.
1233     function unpackTwo(bytes32 packed)
1234         internal
1235         pure
1236         returns (string memory resultA, string memory resultB)
1237     {
1238         /// @solidity memory-safe-assembly
1239         assembly {
1240             // Grab the free memory pointer.
1241             resultA := mload(0x40)
1242             resultB := add(resultA, 0x40)
1243             // Allocate 2 words for each string (1 for the length, 1 for the byte). Total 4 words.
1244             mstore(0x40, add(resultB, 0x40))
1245             // Zeroize the length slots.
1246             mstore(resultA, 0)
1247             mstore(resultB, 0)
1248             // Store the lengths and bytes.
1249             mstore(add(resultA, 0x1f), packed)
1250             mstore(add(resultB, 0x1f), mload(add(add(resultA, 0x20), mload(resultA))))
1251             // Right pad with zeroes.
1252             mstore(add(add(resultA, 0x20), mload(resultA)), 0)
1253             mstore(add(add(resultB, 0x20), mload(resultB)), 0)
1254         }
1255     }
1256 
1257     /// @dev Directly returns `a` without copying.
1258     function directReturn(string memory a) internal pure {
1259         assembly {
1260             // Assumes that the string does not start from the scratch space.
1261             let retStart := sub(a, 0x20)
1262             let retSize := add(mload(a), 0x40)
1263             // Right pad with zeroes. Just in case the string is produced
1264             // by a method that doesn't zero right pad.
1265             mstore(add(retStart, retSize), 0)
1266             // Store the return offset.
1267             mstore(retStart, 0x20)
1268             // End the transaction, returning the string.
1269             return(retStart, retSize)
1270         }
1271     }
1272 }
1273 
1274 // File: solady/src/utils/ECDSA.sol
1275 
1276 
1277 pragma solidity ^0.8.4;
1278 
1279 /// @notice Gas optimized ECDSA wrapper.
1280 /// @author Solady (https://github.com/vectorized/solady/blob/main/src/utils/ECDSA.sol)
1281 /// @author Modified from Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/ECDSA.sol)
1282 /// @author Modified from OpenZeppelin (https://github.com/OpenZeppelin/openzeppelin-contracts/blob/master/contracts/utils/cryptography/ECDSA.sol)
1283 library ECDSA {
1284     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
1285     /*                         CONSTANTS                          */
1286     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
1287 
1288     /// @dev The number which `s` must not exceed in order for
1289     /// the signature to be non-malleable.
1290     bytes32 private constant _MALLEABILITY_THRESHOLD =
1291         0x7fffffffffffffffffffffffffffffff5d576e7357a4501ddfe92f46681b20a0;
1292 
1293     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
1294     /*                    RECOVERY OPERATIONS                     */
1295     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
1296 
1297     /// @dev Recovers the signer's address from a message digest `hash`,
1298     /// and the `signature`.
1299     ///
1300     /// This function does NOT accept EIP-2098 short form signatures.
1301     /// Use `recover(bytes32 hash, bytes32 r, bytes32 vs)` for EIP-2098
1302     /// short form signatures instead.
1303     ///
1304     /// WARNING!
1305     /// The `result` will be the zero address upon recovery failure.
1306     /// As such, it is extremely important to ensure that the address which
1307     /// the `result` is compared against is never zero.
1308     function recover(bytes32 hash, bytes calldata signature)
1309         internal
1310         view
1311         returns (address result)
1312     {
1313         /// @solidity memory-safe-assembly
1314         assembly {
1315             if eq(signature.length, 65) {
1316                 // Copy the free memory pointer so that we can restore it later.
1317                 let m := mload(0x40)
1318                 // Directly copy `r` and `s` from the calldata.
1319                 calldatacopy(0x40, signature.offset, 0x40)
1320 
1321                 // If `s` in lower half order, such that the signature is not malleable.
1322                 if iszero(gt(mload(0x60), _MALLEABILITY_THRESHOLD)) {
1323                     mstore(0x00, hash)
1324                     // Compute `v` and store it in the scratch space.
1325                     mstore(0x20, byte(0, calldataload(add(signature.offset, 0x40))))
1326                     pop(
1327                         staticcall(
1328                             gas(), // Amount of gas left for the transaction.
1329                             0x01, // Address of `ecrecover`.
1330                             0x00, // Start of input.
1331                             0x80, // Size of input.
1332                             0x40, // Start of output.
1333                             0x20 // Size of output.
1334                         )
1335                     )
1336                     // Restore the zero slot.
1337                     mstore(0x60, 0)
1338                     // `returndatasize()` will be `0x20` upon success, and `0x00` otherwise.
1339                     result := mload(sub(0x60, returndatasize()))
1340                 }
1341                 // Restore the free memory pointer.
1342                 mstore(0x40, m)
1343             }
1344         }
1345     }
1346 
1347     /// @dev Recovers the signer's address from a message digest `hash`,
1348     /// and the EIP-2098 short form signature defined by `r` and `vs`.
1349     ///
1350     /// This function only accepts EIP-2098 short form signatures.
1351     /// See: https://eips.ethereum.org/EIPS/eip-2098
1352     ///
1353     /// To be honest, I do not recommend using EIP-2098 signatures
1354     /// for simplicity, performance, and security reasons. Most if not
1355     /// all clients support traditional non EIP-2098 signatures by default.
1356     /// As such, this method is intentionally not fully inlined.
1357     /// It is merely included for completeness.
1358     ///
1359     /// WARNING!
1360     /// The `result` will be the zero address upon recovery failure.
1361     /// As such, it is extremely important to ensure that the address which
1362     /// the `result` is compared against is never zero.
1363     function recover(bytes32 hash, bytes32 r, bytes32 vs) internal view returns (address result) {
1364         uint8 v;
1365         bytes32 s;
1366         /// @solidity memory-safe-assembly
1367         assembly {
1368             s := shr(1, shl(1, vs))
1369             v := add(shr(255, vs), 27)
1370         }
1371         result = recover(hash, v, r, s);
1372     }
1373 
1374     /// @dev Recovers the signer's address from a message digest `hash`,
1375     /// and the signature defined by `v`, `r`, `s`.
1376     ///
1377     /// WARNING!
1378     /// The `result` will be the zero address upon recovery failure.
1379     /// As such, it is extremely important to ensure that the address which
1380     /// the `result` is compared against is never zero.
1381     function recover(bytes32 hash, uint8 v, bytes32 r, bytes32 s)
1382         internal
1383         view
1384         returns (address result)
1385     {
1386         /// @solidity memory-safe-assembly
1387         assembly {
1388             // Copy the free memory pointer so that we can restore it later.
1389             let m := mload(0x40)
1390 
1391             // If `s` in lower half order, such that the signature is not malleable.
1392             if iszero(gt(s, _MALLEABILITY_THRESHOLD)) {
1393                 mstore(0x00, hash)
1394                 mstore(0x20, v)
1395                 mstore(0x40, r)
1396                 mstore(0x60, s)
1397                 pop(
1398                     staticcall(
1399                         gas(), // Amount of gas left for the transaction.
1400                         0x01, // Address of `ecrecover`.
1401                         0x00, // Start of input.
1402                         0x80, // Size of input.
1403                         0x40, // Start of output.
1404                         0x20 // Size of output.
1405                     )
1406                 )
1407                 // Restore the zero slot.
1408                 mstore(0x60, 0)
1409                 // `returndatasize()` will be `0x20` upon success, and `0x00` otherwise.
1410                 result := mload(sub(0x60, returndatasize()))
1411             }
1412             // Restore the free memory pointer.
1413             mstore(0x40, m)
1414         }
1415     }
1416 
1417     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
1418     /*                     HASHING OPERATIONS                     */
1419     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
1420 
1421     /// @dev Returns an Ethereum Signed Message, created from a `hash`.
1422     /// This produces a hash corresponding to the one signed with the
1423     /// [`eth_sign`](https://eth.wiki/json-rpc/API#eth_sign)
1424     /// JSON-RPC method as part of EIP-191.
1425     function toEthSignedMessageHash(bytes32 hash) internal pure returns (bytes32 result) {
1426         /// @solidity memory-safe-assembly
1427         assembly {
1428             // Store into scratch space for keccak256.
1429             mstore(0x20, hash)
1430             mstore(0x00, "\x00\x00\x00\x00\x19Ethereum Signed Message:\n32")
1431             // 0x40 - 0x04 = 0x3c
1432             result := keccak256(0x04, 0x3c)
1433         }
1434     }
1435 
1436     /// @dev Returns an Ethereum Signed Message, created from `s`.
1437     /// This produces a hash corresponding to the one signed with the
1438     /// [`eth_sign`](https://eth.wiki/json-rpc/API#eth_sign)
1439     /// JSON-RPC method as part of EIP-191.
1440     function toEthSignedMessageHash(bytes memory s) internal pure returns (bytes32 result) {
1441         assembly {
1442             // We need at most 128 bytes for Ethereum signed message header.
1443             // The max length of the ASCII reprenstation of a uint256 is 78 bytes.
1444             // The length of "\x19Ethereum Signed Message:\n" is 26 bytes (i.e. 0x1a).
1445             // The next multiple of 32 above 78 + 26 is 128 (i.e. 0x80).
1446 
1447             // Instead of allocating, we temporarily copy the 128 bytes before the
1448             // start of `s` data to some variables.
1449             let m3 := mload(sub(s, 0x60))
1450             let m2 := mload(sub(s, 0x40))
1451             let m1 := mload(sub(s, 0x20))
1452             // The length of `s` is in bytes.
1453             let sLength := mload(s)
1454 
1455             let ptr := add(s, 0x20)
1456 
1457             // `end` marks the end of the memory which we will compute the keccak256 of.
1458             let end := add(ptr, sLength)
1459 
1460             // Convert the length of the bytes to ASCII decimal representation
1461             // and store it into the memory.
1462             for { let temp := sLength } 1 {} {
1463                 ptr := sub(ptr, 1)
1464                 mstore8(ptr, add(48, mod(temp, 10)))
1465                 temp := div(temp, 10)
1466                 if iszero(temp) { break }
1467             }
1468 
1469             // Copy the header over to the memory.
1470             mstore(sub(ptr, 0x20), "\x00\x00\x00\x00\x00\x00\x19Ethereum Signed Message:\n")
1471             // Compute the keccak256 of the memory.
1472             result := keccak256(sub(ptr, 0x1a), sub(end, sub(ptr, 0x1a)))
1473 
1474             // Restore the previous memory.
1475             mstore(s, sLength)
1476             mstore(sub(s, 0x20), m1)
1477             mstore(sub(s, 0x40), m2)
1478             mstore(sub(s, 0x60), m3)
1479         }
1480     }
1481 }
1482 
1483 // File: erc721a/contracts/IERC721A.sol
1484 
1485 
1486 // ERC721A Contracts v4.2.3
1487 // Creator: Chiru Labs
1488 
1489 pragma solidity ^0.8.4;
1490 
1491 /**
1492  * @dev Interface of ERC721A.
1493  */
1494 interface IERC721A {
1495     /**
1496      * The caller must own the token or be an approved operator.
1497      */
1498     error ApprovalCallerNotOwnerNorApproved();
1499 
1500     /**
1501      * The token does not exist.
1502      */
1503     error ApprovalQueryForNonexistentToken();
1504 
1505     /**
1506      * Cannot query the balance for the zero address.
1507      */
1508     error BalanceQueryForZeroAddress();
1509 
1510     /**
1511      * Cannot mint to the zero address.
1512      */
1513     error MintToZeroAddress();
1514 
1515     /**
1516      * The quantity of tokens minted must be more than zero.
1517      */
1518     error MintZeroQuantity();
1519 
1520     /**
1521      * The token does not exist.
1522      */
1523     error OwnerQueryForNonexistentToken();
1524 
1525     /**
1526      * The caller must own the token or be an approved operator.
1527      */
1528     error TransferCallerNotOwnerNorApproved();
1529 
1530     /**
1531      * The token must be owned by `from`.
1532      */
1533     error TransferFromIncorrectOwner();
1534 
1535     /**
1536      * Cannot safely transfer to a contract that does not implement the
1537      * ERC721Receiver interface.
1538      */
1539     error TransferToNonERC721ReceiverImplementer();
1540 
1541     /**
1542      * Cannot transfer to the zero address.
1543      */
1544     error TransferToZeroAddress();
1545 
1546     /**
1547      * The token does not exist.
1548      */
1549     error URIQueryForNonexistentToken();
1550 
1551     /**
1552      * The `quantity` minted with ERC2309 exceeds the safety limit.
1553      */
1554     error MintERC2309QuantityExceedsLimit();
1555 
1556     /**
1557      * The `extraData` cannot be set on an unintialized ownership slot.
1558      */
1559     error OwnershipNotInitializedForExtraData();
1560 
1561     // =============================================================
1562     //                            STRUCTS
1563     // =============================================================
1564 
1565     struct TokenOwnership {
1566         // The address of the owner.
1567         address addr;
1568         // Stores the start time of ownership with minimal overhead for tokenomics.
1569         uint64 startTimestamp;
1570         // Whether the token has been burned.
1571         bool burned;
1572         // Arbitrary data similar to `startTimestamp` that can be set via {_extraData}.
1573         uint24 extraData;
1574     }
1575 
1576     // =============================================================
1577     //                         TOKEN COUNTERS
1578     // =============================================================
1579 
1580     /**
1581      * @dev Returns the total number of tokens in existence.
1582      * Burned tokens will reduce the count.
1583      * To get the total number of tokens minted, please see {_totalMinted}.
1584      */
1585     function totalSupply() external view returns (uint256);
1586 
1587     // =============================================================
1588     //                            IERC165
1589     // =============================================================
1590 
1591     /**
1592      * @dev Returns true if this contract implements the interface defined by
1593      * `interfaceId`. See the corresponding
1594      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
1595      * to learn more about how these ids are created.
1596      *
1597      * This function call must use less than 30000 gas.
1598      */
1599     function supportsInterface(bytes4 interfaceId) external view returns (bool);
1600 
1601     // =============================================================
1602     //                            IERC721
1603     // =============================================================
1604 
1605     /**
1606      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
1607      */
1608     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
1609 
1610     /**
1611      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
1612      */
1613     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
1614 
1615     /**
1616      * @dev Emitted when `owner` enables or disables
1617      * (`approved`) `operator` to manage all of its assets.
1618      */
1619     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1620 
1621     /**
1622      * @dev Returns the number of tokens in `owner`'s account.
1623      */
1624     function balanceOf(address owner) external view returns (uint256 balance);
1625 
1626     /**
1627      * @dev Returns the owner of the `tokenId` token.
1628      *
1629      * Requirements:
1630      *
1631      * - `tokenId` must exist.
1632      */
1633     function ownerOf(uint256 tokenId) external view returns (address owner);
1634 
1635     /**
1636      * @dev Safely transfers `tokenId` token from `from` to `to`,
1637      * checking first that contract recipients are aware of the ERC721 protocol
1638      * to prevent tokens from being forever locked.
1639      *
1640      * Requirements:
1641      *
1642      * - `from` cannot be the zero address.
1643      * - `to` cannot be the zero address.
1644      * - `tokenId` token must exist and be owned by `from`.
1645      * - If the caller is not `from`, it must be have been allowed to move
1646      * this token by either {approve} or {setApprovalForAll}.
1647      * - If `to` refers to a smart contract, it must implement
1648      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1649      *
1650      * Emits a {Transfer} event.
1651      */
1652     function safeTransferFrom(
1653         address from,
1654         address to,
1655         uint256 tokenId,
1656         bytes calldata data
1657     ) external payable;
1658 
1659     /**
1660      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
1661      */
1662     function safeTransferFrom(
1663         address from,
1664         address to,
1665         uint256 tokenId
1666     ) external payable;
1667 
1668     /**
1669      * @dev Transfers `tokenId` from `from` to `to`.
1670      *
1671      * WARNING: Usage of this method is discouraged, use {safeTransferFrom}
1672      * whenever possible.
1673      *
1674      * Requirements:
1675      *
1676      * - `from` cannot be the zero address.
1677      * - `to` cannot be the zero address.
1678      * - `tokenId` token must be owned by `from`.
1679      * - If the caller is not `from`, it must be approved to move this token
1680      * by either {approve} or {setApprovalForAll}.
1681      *
1682      * Emits a {Transfer} event.
1683      */
1684     function transferFrom(
1685         address from,
1686         address to,
1687         uint256 tokenId
1688     ) external payable;
1689 
1690     /**
1691      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
1692      * The approval is cleared when the token is transferred.
1693      *
1694      * Only a single account can be approved at a time, so approving the
1695      * zero address clears previous approvals.
1696      *
1697      * Requirements:
1698      *
1699      * - The caller must own the token or be an approved operator.
1700      * - `tokenId` must exist.
1701      *
1702      * Emits an {Approval} event.
1703      */
1704     function approve(address to, uint256 tokenId) external payable;
1705 
1706     /**
1707      * @dev Approve or remove `operator` as an operator for the caller.
1708      * Operators can call {transferFrom} or {safeTransferFrom}
1709      * for any token owned by the caller.
1710      *
1711      * Requirements:
1712      *
1713      * - The `operator` cannot be the caller.
1714      *
1715      * Emits an {ApprovalForAll} event.
1716      */
1717     function setApprovalForAll(address operator, bool _approved) external;
1718 
1719     /**
1720      * @dev Returns the account approved for `tokenId` token.
1721      *
1722      * Requirements:
1723      *
1724      * - `tokenId` must exist.
1725      */
1726     function getApproved(uint256 tokenId) external view returns (address operator);
1727 
1728     /**
1729      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
1730      *
1731      * See {setApprovalForAll}.
1732      */
1733     function isApprovedForAll(address owner, address operator) external view returns (bool);
1734 
1735     // =============================================================
1736     //                        IERC721Metadata
1737     // =============================================================
1738 
1739     /**
1740      * @dev Returns the token collection name.
1741      */
1742     function name() external view returns (string memory);
1743 
1744     /**
1745      * @dev Returns the token collection symbol.
1746      */
1747     function symbol() external view returns (string memory);
1748 
1749     /**
1750      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
1751      */
1752     function tokenURI(uint256 tokenId) external view returns (string memory);
1753 
1754     // =============================================================
1755     //                           IERC2309
1756     // =============================================================
1757 
1758     /**
1759      * @dev Emitted when tokens in `fromTokenId` to `toTokenId`
1760      * (inclusive) is transferred from `from` to `to`, as defined in the
1761      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309) standard.
1762      *
1763      * See {_mintERC2309} for more details.
1764      */
1765     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
1766 }
1767 
1768 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1769 
1770 
1771 // ERC721A Contracts v4.2.3
1772 // Creator: Chiru Labs
1773 
1774 pragma solidity ^0.8.4;
1775 
1776 
1777 /**
1778  * @dev Interface of ERC721AQueryable.
1779  */
1780 interface IERC721AQueryable is IERC721A {
1781     /**
1782      * Invalid query range (`start` >= `stop`).
1783      */
1784     error InvalidQueryRange();
1785 
1786     /**
1787      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1788      *
1789      * If the `tokenId` is out of bounds:
1790      *
1791      * - `addr = address(0)`
1792      * - `startTimestamp = 0`
1793      * - `burned = false`
1794      * - `extraData = 0`
1795      *
1796      * If the `tokenId` is burned:
1797      *
1798      * - `addr = <Address of owner before token was burned>`
1799      * - `startTimestamp = <Timestamp when token was burned>`
1800      * - `burned = true`
1801      * - `extraData = <Extra data when token was burned>`
1802      *
1803      * Otherwise:
1804      *
1805      * - `addr = <Address of owner>`
1806      * - `startTimestamp = <Timestamp of start of ownership>`
1807      * - `burned = false`
1808      * - `extraData = <Extra data at start of ownership>`
1809      */
1810     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1811 
1812     /**
1813      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1814      * See {ERC721AQueryable-explicitOwnershipOf}
1815      */
1816     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1817 
1818     /**
1819      * @dev Returns an array of token IDs owned by `owner`,
1820      * in the range [`start`, `stop`)
1821      * (i.e. `start <= tokenId < stop`).
1822      *
1823      * This function allows for tokens to be queried if the collection
1824      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1825      *
1826      * Requirements:
1827      *
1828      * - `start < stop`
1829      */
1830     function tokensOfOwnerIn(
1831         address owner,
1832         uint256 start,
1833         uint256 stop
1834     ) external view returns (uint256[] memory);
1835 
1836     /**
1837      * @dev Returns an array of token IDs owned by `owner`.
1838      *
1839      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
1840      * It is meant to be called off-chain.
1841      *
1842      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1843      * multiple smaller scans if the collection is large enough to cause
1844      * an out-of-gas error (10K collections should be fine).
1845      */
1846     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1847 }
1848 
1849 // File: erc721a/contracts/ERC721A.sol
1850 
1851 
1852 // ERC721A Contracts v4.2.3
1853 // Creator: Chiru Labs
1854 
1855 pragma solidity ^0.8.4;
1856 
1857 
1858 /**
1859  * @dev Interface of ERC721 token receiver.
1860  */
1861 interface ERC721A__IERC721Receiver {
1862     function onERC721Received(
1863         address operator,
1864         address from,
1865         uint256 tokenId,
1866         bytes calldata data
1867     ) external returns (bytes4);
1868 }
1869 
1870 /**
1871  * @title ERC721A
1872  *
1873  * @dev Implementation of the [ERC721](https://eips.ethereum.org/EIPS/eip-721)
1874  * Non-Fungible Token Standard, including the Metadata extension.
1875  * Optimized for lower gas during batch mints.
1876  *
1877  * Token IDs are minted in sequential order (e.g. 0, 1, 2, 3, ...)
1878  * starting from `_startTokenId()`.
1879  *
1880  * Assumptions:
1881  *
1882  * - An owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
1883  * - The maximum token ID cannot exceed 2**256 - 1 (max value of uint256).
1884  */
1885 contract ERC721A is IERC721A {
1886     // Bypass for a `--via-ir` bug (https://github.com/chiru-labs/ERC721A/pull/364).
1887     struct TokenApprovalRef {
1888         address value;
1889     }
1890 
1891     // =============================================================
1892     //                           CONSTANTS
1893     // =============================================================
1894 
1895     // Mask of an entry in packed address data.
1896     uint256 private constant _BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
1897 
1898     // The bit position of `numberMinted` in packed address data.
1899     uint256 private constant _BITPOS_NUMBER_MINTED = 64;
1900 
1901     // The bit position of `numberBurned` in packed address data.
1902     uint256 private constant _BITPOS_NUMBER_BURNED = 128;
1903 
1904     // The bit position of `aux` in packed address data.
1905     uint256 private constant _BITPOS_AUX = 192;
1906 
1907     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
1908     uint256 private constant _BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
1909 
1910     // The bit position of `startTimestamp` in packed ownership.
1911     uint256 private constant _BITPOS_START_TIMESTAMP = 160;
1912 
1913     // The bit mask of the `burned` bit in packed ownership.
1914     uint256 private constant _BITMASK_BURNED = 1 << 224;
1915 
1916     // The bit position of the `nextInitialized` bit in packed ownership.
1917     uint256 private constant _BITPOS_NEXT_INITIALIZED = 225;
1918 
1919     // The bit mask of the `nextInitialized` bit in packed ownership.
1920     uint256 private constant _BITMASK_NEXT_INITIALIZED = 1 << 225;
1921 
1922     // The bit position of `extraData` in packed ownership.
1923     uint256 private constant _BITPOS_EXTRA_DATA = 232;
1924 
1925     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
1926     uint256 private constant _BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
1927 
1928     // The mask of the lower 160 bits for addresses.
1929     uint256 private constant _BITMASK_ADDRESS = (1 << 160) - 1;
1930 
1931     // The maximum `quantity` that can be minted with {_mintERC2309}.
1932     // This limit is to prevent overflows on the address data entries.
1933     // For a limit of 5000, a total of 3.689e15 calls to {_mintERC2309}
1934     // is required to cause an overflow, which is unrealistic.
1935     uint256 private constant _MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
1936 
1937     // The `Transfer` event signature is given by:
1938     // `keccak256(bytes("Transfer(address,address,uint256)"))`.
1939     bytes32 private constant _TRANSFER_EVENT_SIGNATURE =
1940         0xddf252ad1be2c89b69c2b068fc378daa952ba7f163c4a11628f55a4df523b3ef;
1941 
1942     // =============================================================
1943     //                            STORAGE
1944     // =============================================================
1945 
1946     // The next token ID to be minted.
1947     uint256 private _currentIndex;
1948 
1949     // The number of tokens burned.
1950     uint256 private _burnCounter;
1951 
1952     // Token name
1953     string private _name;
1954 
1955     // Token symbol
1956     string private _symbol;
1957 
1958     // Mapping from token ID to ownership details
1959     // An empty struct value does not necessarily mean the token is unowned.
1960     // See {_packedOwnershipOf} implementation for details.
1961     //
1962     // Bits Layout:
1963     // - [0..159]   `addr`
1964     // - [160..223] `startTimestamp`
1965     // - [224]      `burned`
1966     // - [225]      `nextInitialized`
1967     // - [232..255] `extraData`
1968     mapping(uint256 => uint256) private _packedOwnerships;
1969 
1970     // Mapping owner address to address data.
1971     //
1972     // Bits Layout:
1973     // - [0..63]    `balance`
1974     // - [64..127]  `numberMinted`
1975     // - [128..191] `numberBurned`
1976     // - [192..255] `aux`
1977     mapping(address => uint256) private _packedAddressData;
1978 
1979     // Mapping from token ID to approved address.
1980     mapping(uint256 => TokenApprovalRef) private _tokenApprovals;
1981 
1982     // Mapping from owner to operator approvals
1983     mapping(address => mapping(address => bool)) private _operatorApprovals;
1984 
1985     // =============================================================
1986     //                          CONSTRUCTOR
1987     // =============================================================
1988 
1989     constructor(string memory name_, string memory symbol_) {
1990         _name = name_;
1991         _symbol = symbol_;
1992         _currentIndex = _startTokenId();
1993     }
1994 
1995     // =============================================================
1996     //                   TOKEN COUNTING OPERATIONS
1997     // =============================================================
1998 
1999     /**
2000      * @dev Returns the starting token ID.
2001      * To change the starting token ID, please override this function.
2002      */
2003     function _startTokenId() internal view virtual returns (uint256) {
2004         return 0;
2005     }
2006 
2007     /**
2008      * @dev Returns the next token ID to be minted.
2009      */
2010     function _nextTokenId() internal view virtual returns (uint256) {
2011         return _currentIndex;
2012     }
2013 
2014     /**
2015      * @dev Returns the total number of tokens in existence.
2016      * Burned tokens will reduce the count.
2017      * To get the total number of tokens minted, please see {_totalMinted}.
2018      */
2019     function totalSupply() public view virtual override returns (uint256) {
2020         // Counter underflow is impossible as _burnCounter cannot be incremented
2021         // more than `_currentIndex - _startTokenId()` times.
2022         unchecked {
2023             return _currentIndex - _burnCounter - _startTokenId();
2024         }
2025     }
2026 
2027     /**
2028      * @dev Returns the total amount of tokens minted in the contract.
2029      */
2030     function _totalMinted() internal view virtual returns (uint256) {
2031         // Counter underflow is impossible as `_currentIndex` does not decrement,
2032         // and it is initialized to `_startTokenId()`.
2033         unchecked {
2034             return _currentIndex - _startTokenId();
2035         }
2036     }
2037 
2038     /**
2039      * @dev Returns the total number of tokens burned.
2040      */
2041     function _totalBurned() internal view virtual returns (uint256) {
2042         return _burnCounter;
2043     }
2044 
2045     // =============================================================
2046     //                    ADDRESS DATA OPERATIONS
2047     // =============================================================
2048 
2049     /**
2050      * @dev Returns the number of tokens in `owner`'s account.
2051      */
2052     function balanceOf(address owner) public view virtual override returns (uint256) {
2053         if (owner == address(0)) revert BalanceQueryForZeroAddress();
2054         return _packedAddressData[owner] & _BITMASK_ADDRESS_DATA_ENTRY;
2055     }
2056 
2057     /**
2058      * Returns the number of tokens minted by `owner`.
2059      */
2060     function _numberMinted(address owner) internal view returns (uint256) {
2061         return (_packedAddressData[owner] >> _BITPOS_NUMBER_MINTED) & _BITMASK_ADDRESS_DATA_ENTRY;
2062     }
2063 
2064     /**
2065      * Returns the number of tokens burned by or on behalf of `owner`.
2066      */
2067     function _numberBurned(address owner) internal view returns (uint256) {
2068         return (_packedAddressData[owner] >> _BITPOS_NUMBER_BURNED) & _BITMASK_ADDRESS_DATA_ENTRY;
2069     }
2070 
2071     /**
2072      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
2073      */
2074     function _getAux(address owner) internal view returns (uint64) {
2075         return uint64(_packedAddressData[owner] >> _BITPOS_AUX);
2076     }
2077 
2078     /**
2079      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
2080      * If there are multiple variables, please pack them into a uint64.
2081      */
2082     function _setAux(address owner, uint64 aux) internal virtual {
2083         uint256 packed = _packedAddressData[owner];
2084         uint256 auxCasted;
2085         // Cast `aux` with assembly to avoid redundant masking.
2086         assembly {
2087             auxCasted := aux
2088         }
2089         packed = (packed & _BITMASK_AUX_COMPLEMENT) | (auxCasted << _BITPOS_AUX);
2090         _packedAddressData[owner] = packed;
2091     }
2092 
2093     // =============================================================
2094     //                            IERC165
2095     // =============================================================
2096 
2097     /**
2098      * @dev Returns true if this contract implements the interface defined by
2099      * `interfaceId`. See the corresponding
2100      * [EIP section](https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified)
2101      * to learn more about how these ids are created.
2102      *
2103      * This function call must use less than 30000 gas.
2104      */
2105     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
2106         // The interface IDs are constants representing the first 4 bytes
2107         // of the XOR of all function selectors in the interface.
2108         // See: [ERC165](https://eips.ethereum.org/EIPS/eip-165)
2109         // (e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`)
2110         return
2111             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
2112             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
2113             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
2114     }
2115 
2116     // =============================================================
2117     //                        IERC721Metadata
2118     // =============================================================
2119 
2120     /**
2121      * @dev Returns the token collection name.
2122      */
2123     function name() public view virtual override returns (string memory) {
2124         return _name;
2125     }
2126 
2127     /**
2128      * @dev Returns the token collection symbol.
2129      */
2130     function symbol() public view virtual override returns (string memory) {
2131         return _symbol;
2132     }
2133 
2134     /**
2135      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
2136      */
2137     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
2138         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
2139 
2140         string memory baseURI = _baseURI();
2141         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
2142     }
2143 
2144     /**
2145      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
2146      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
2147      * by default, it can be overridden in child contracts.
2148      */
2149     function _baseURI() internal view virtual returns (string memory) {
2150         return '';
2151     }
2152 
2153     // =============================================================
2154     //                     OWNERSHIPS OPERATIONS
2155     // =============================================================
2156 
2157     /**
2158      * @dev Returns the owner of the `tokenId` token.
2159      *
2160      * Requirements:
2161      *
2162      * - `tokenId` must exist.
2163      */
2164     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
2165         return address(uint160(_packedOwnershipOf(tokenId)));
2166     }
2167 
2168     /**
2169      * @dev Gas spent here starts off proportional to the maximum mint batch size.
2170      * It gradually moves to O(1) as tokens get transferred around over time.
2171      */
2172     function _ownershipOf(uint256 tokenId) internal view virtual returns (TokenOwnership memory) {
2173         return _unpackedOwnership(_packedOwnershipOf(tokenId));
2174     }
2175 
2176     /**
2177      * @dev Returns the unpacked `TokenOwnership` struct at `index`.
2178      */
2179     function _ownershipAt(uint256 index) internal view virtual returns (TokenOwnership memory) {
2180         return _unpackedOwnership(_packedOwnerships[index]);
2181     }
2182 
2183     /**
2184      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
2185      */
2186     function _initializeOwnershipAt(uint256 index) internal virtual {
2187         if (_packedOwnerships[index] == 0) {
2188             _packedOwnerships[index] = _packedOwnershipOf(index);
2189         }
2190     }
2191 
2192     /**
2193      * Returns the packed ownership data of `tokenId`.
2194      */
2195     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
2196         uint256 curr = tokenId;
2197 
2198         unchecked {
2199             if (_startTokenId() <= curr)
2200                 if (curr < _currentIndex) {
2201                     uint256 packed = _packedOwnerships[curr];
2202                     // If not burned.
2203                     if (packed & _BITMASK_BURNED == 0) {
2204                         // Invariant:
2205                         // There will always be an initialized ownership slot
2206                         // (i.e. `ownership.addr != address(0) && ownership.burned == false`)
2207                         // before an unintialized ownership slot
2208                         // (i.e. `ownership.addr == address(0) && ownership.burned == false`)
2209                         // Hence, `curr` will not underflow.
2210                         //
2211                         // We can directly compare the packed value.
2212                         // If the address is zero, packed will be zero.
2213                         while (packed == 0) {
2214                             packed = _packedOwnerships[--curr];
2215                         }
2216                         return packed;
2217                     }
2218                 }
2219         }
2220         revert OwnerQueryForNonexistentToken();
2221     }
2222 
2223     /**
2224      * @dev Returns the unpacked `TokenOwnership` struct from `packed`.
2225      */
2226     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
2227         ownership.addr = address(uint160(packed));
2228         ownership.startTimestamp = uint64(packed >> _BITPOS_START_TIMESTAMP);
2229         ownership.burned = packed & _BITMASK_BURNED != 0;
2230         ownership.extraData = uint24(packed >> _BITPOS_EXTRA_DATA);
2231     }
2232 
2233     /**
2234      * @dev Packs ownership data into a single uint256.
2235      */
2236     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
2237         assembly {
2238             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2239             owner := and(owner, _BITMASK_ADDRESS)
2240             // `owner | (block.timestamp << _BITPOS_START_TIMESTAMP) | flags`.
2241             result := or(owner, or(shl(_BITPOS_START_TIMESTAMP, timestamp()), flags))
2242         }
2243     }
2244 
2245     /**
2246      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
2247      */
2248     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
2249         // For branchless setting of the `nextInitialized` flag.
2250         assembly {
2251             // `(quantity == 1) << _BITPOS_NEXT_INITIALIZED`.
2252             result := shl(_BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
2253         }
2254     }
2255 
2256     // =============================================================
2257     //                      APPROVAL OPERATIONS
2258     // =============================================================
2259 
2260     /**
2261      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
2262      * The approval is cleared when the token is transferred.
2263      *
2264      * Only a single account can be approved at a time, so approving the
2265      * zero address clears previous approvals.
2266      *
2267      * Requirements:
2268      *
2269      * - The caller must own the token or be an approved operator.
2270      * - `tokenId` must exist.
2271      *
2272      * Emits an {Approval} event.
2273      */
2274     function approve(address to, uint256 tokenId) public payable virtual override {
2275         address owner = ownerOf(tokenId);
2276 
2277         if (_msgSenderERC721A() != owner)
2278             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
2279                 revert ApprovalCallerNotOwnerNorApproved();
2280             }
2281 
2282         _tokenApprovals[tokenId].value = to;
2283         emit Approval(owner, to, tokenId);
2284     }
2285 
2286     /**
2287      * @dev Returns the account approved for `tokenId` token.
2288      *
2289      * Requirements:
2290      *
2291      * - `tokenId` must exist.
2292      */
2293     function getApproved(uint256 tokenId) public view virtual override returns (address) {
2294         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
2295 
2296         return _tokenApprovals[tokenId].value;
2297     }
2298 
2299     /**
2300      * @dev Approve or remove `operator` as an operator for the caller.
2301      * Operators can call {transferFrom} or {safeTransferFrom}
2302      * for any token owned by the caller.
2303      *
2304      * Requirements:
2305      *
2306      * - The `operator` cannot be the caller.
2307      *
2308      * Emits an {ApprovalForAll} event.
2309      */
2310     function setApprovalForAll(address operator, bool approved) public virtual override {
2311         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
2312         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
2313     }
2314 
2315     /**
2316      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
2317      *
2318      * See {setApprovalForAll}.
2319      */
2320     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
2321         return _operatorApprovals[owner][operator];
2322     }
2323 
2324     /**
2325      * @dev Returns whether `tokenId` exists.
2326      *
2327      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
2328      *
2329      * Tokens start existing when they are minted. See {_mint}.
2330      */
2331     function _exists(uint256 tokenId) internal view virtual returns (bool) {
2332         return
2333             _startTokenId() <= tokenId &&
2334             tokenId < _currentIndex && // If within bounds,
2335             _packedOwnerships[tokenId] & _BITMASK_BURNED == 0; // and not burned.
2336     }
2337 
2338     /**
2339      * @dev Returns whether `msgSender` is equal to `approvedAddress` or `owner`.
2340      */
2341     function _isSenderApprovedOrOwner(
2342         address approvedAddress,
2343         address owner,
2344         address msgSender
2345     ) private pure returns (bool result) {
2346         assembly {
2347             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
2348             owner := and(owner, _BITMASK_ADDRESS)
2349             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
2350             msgSender := and(msgSender, _BITMASK_ADDRESS)
2351             // `msgSender == owner || msgSender == approvedAddress`.
2352             result := or(eq(msgSender, owner), eq(msgSender, approvedAddress))
2353         }
2354     }
2355 
2356     /**
2357      * @dev Returns the storage slot and value for the approved address of `tokenId`.
2358      */
2359     function _getApprovedSlotAndAddress(uint256 tokenId)
2360         private
2361         view
2362         returns (uint256 approvedAddressSlot, address approvedAddress)
2363     {
2364         TokenApprovalRef storage tokenApproval = _tokenApprovals[tokenId];
2365         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId].value`.
2366         assembly {
2367             approvedAddressSlot := tokenApproval.slot
2368             approvedAddress := sload(approvedAddressSlot)
2369         }
2370     }
2371 
2372     // =============================================================
2373     //                      TRANSFER OPERATIONS
2374     // =============================================================
2375 
2376     /**
2377      * @dev Transfers `tokenId` from `from` to `to`.
2378      *
2379      * Requirements:
2380      *
2381      * - `from` cannot be the zero address.
2382      * - `to` cannot be the zero address.
2383      * - `tokenId` token must be owned by `from`.
2384      * - If the caller is not `from`, it must be approved to move this token
2385      * by either {approve} or {setApprovalForAll}.
2386      *
2387      * Emits a {Transfer} event.
2388      */
2389     function transferFrom(
2390         address from,
2391         address to,
2392         uint256 tokenId
2393     ) public payable virtual override {
2394         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2395 
2396         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
2397 
2398         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2399 
2400         // The nested ifs save around 20+ gas over a compound boolean condition.
2401         if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2402             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2403 
2404         if (to == address(0)) revert TransferToZeroAddress();
2405 
2406         _beforeTokenTransfers(from, to, tokenId, 1);
2407 
2408         // Clear approvals from the previous owner.
2409         assembly {
2410             if approvedAddress {
2411                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2412                 sstore(approvedAddressSlot, 0)
2413             }
2414         }
2415 
2416         // Underflow of the sender's balance is impossible because we check for
2417         // ownership above and the recipient's balance can't realistically overflow.
2418         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2419         unchecked {
2420             // We can directly increment and decrement the balances.
2421             --_packedAddressData[from]; // Updates: `balance -= 1`.
2422             ++_packedAddressData[to]; // Updates: `balance += 1`.
2423 
2424             // Updates:
2425             // - `address` to the next owner.
2426             // - `startTimestamp` to the timestamp of transfering.
2427             // - `burned` to `false`.
2428             // - `nextInitialized` to `true`.
2429             _packedOwnerships[tokenId] = _packOwnershipData(
2430                 to,
2431                 _BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
2432             );
2433 
2434             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2435             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2436                 uint256 nextTokenId = tokenId + 1;
2437                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2438                 if (_packedOwnerships[nextTokenId] == 0) {
2439                     // If the next slot is within bounds.
2440                     if (nextTokenId != _currentIndex) {
2441                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2442                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2443                     }
2444                 }
2445             }
2446         }
2447 
2448         emit Transfer(from, to, tokenId);
2449         _afterTokenTransfers(from, to, tokenId, 1);
2450     }
2451 
2452     /**
2453      * @dev Equivalent to `safeTransferFrom(from, to, tokenId, '')`.
2454      */
2455     function safeTransferFrom(
2456         address from,
2457         address to,
2458         uint256 tokenId
2459     ) public payable virtual override {
2460         safeTransferFrom(from, to, tokenId, '');
2461     }
2462 
2463     /**
2464      * @dev Safely transfers `tokenId` token from `from` to `to`.
2465      *
2466      * Requirements:
2467      *
2468      * - `from` cannot be the zero address.
2469      * - `to` cannot be the zero address.
2470      * - `tokenId` token must exist and be owned by `from`.
2471      * - If the caller is not `from`, it must be approved to move this token
2472      * by either {approve} or {setApprovalForAll}.
2473      * - If `to` refers to a smart contract, it must implement
2474      * {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
2475      *
2476      * Emits a {Transfer} event.
2477      */
2478     function safeTransferFrom(
2479         address from,
2480         address to,
2481         uint256 tokenId,
2482         bytes memory _data
2483     ) public payable virtual override {
2484         transferFrom(from, to, tokenId);
2485         if (to.code.length != 0)
2486             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
2487                 revert TransferToNonERC721ReceiverImplementer();
2488             }
2489     }
2490 
2491     /**
2492      * @dev Hook that is called before a set of serially-ordered token IDs
2493      * are about to be transferred. This includes minting.
2494      * And also called before burning one token.
2495      *
2496      * `startTokenId` - the first token ID to be transferred.
2497      * `quantity` - the amount to be transferred.
2498      *
2499      * Calling conditions:
2500      *
2501      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2502      * transferred to `to`.
2503      * - When `from` is zero, `tokenId` will be minted for `to`.
2504      * - When `to` is zero, `tokenId` will be burned by `from`.
2505      * - `from` and `to` are never both zero.
2506      */
2507     function _beforeTokenTransfers(
2508         address from,
2509         address to,
2510         uint256 startTokenId,
2511         uint256 quantity
2512     ) internal virtual {}
2513 
2514     /**
2515      * @dev Hook that is called after a set of serially-ordered token IDs
2516      * have been transferred. This includes minting.
2517      * And also called after one token has been burned.
2518      *
2519      * `startTokenId` - the first token ID to be transferred.
2520      * `quantity` - the amount to be transferred.
2521      *
2522      * Calling conditions:
2523      *
2524      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
2525      * transferred to `to`.
2526      * - When `from` is zero, `tokenId` has been minted for `to`.
2527      * - When `to` is zero, `tokenId` has been burned by `from`.
2528      * - `from` and `to` are never both zero.
2529      */
2530     function _afterTokenTransfers(
2531         address from,
2532         address to,
2533         uint256 startTokenId,
2534         uint256 quantity
2535     ) internal virtual {}
2536 
2537     /**
2538      * @dev Private function to invoke {IERC721Receiver-onERC721Received} on a target contract.
2539      *
2540      * `from` - Previous owner of the given token ID.
2541      * `to` - Target address that will receive the token.
2542      * `tokenId` - Token ID to be transferred.
2543      * `_data` - Optional data to send along with the call.
2544      *
2545      * Returns whether the call correctly returned the expected magic value.
2546      */
2547     function _checkContractOnERC721Received(
2548         address from,
2549         address to,
2550         uint256 tokenId,
2551         bytes memory _data
2552     ) private returns (bool) {
2553         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
2554             bytes4 retval
2555         ) {
2556             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
2557         } catch (bytes memory reason) {
2558             if (reason.length == 0) {
2559                 revert TransferToNonERC721ReceiverImplementer();
2560             } else {
2561                 assembly {
2562                     revert(add(32, reason), mload(reason))
2563                 }
2564             }
2565         }
2566     }
2567 
2568     // =============================================================
2569     //                        MINT OPERATIONS
2570     // =============================================================
2571 
2572     /**
2573      * @dev Mints `quantity` tokens and transfers them to `to`.
2574      *
2575      * Requirements:
2576      *
2577      * - `to` cannot be the zero address.
2578      * - `quantity` must be greater than 0.
2579      *
2580      * Emits a {Transfer} event for each mint.
2581      */
2582     function _mint(address to, uint256 quantity) internal virtual {
2583         uint256 startTokenId = _currentIndex;
2584         if (quantity == 0) revert MintZeroQuantity();
2585 
2586         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2587 
2588         // Overflows are incredibly unrealistic.
2589         // `balance` and `numberMinted` have a maximum limit of 2**64.
2590         // `tokenId` has a maximum limit of 2**256.
2591         unchecked {
2592             // Updates:
2593             // - `balance += quantity`.
2594             // - `numberMinted += quantity`.
2595             //
2596             // We can directly add to the `balance` and `numberMinted`.
2597             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2598 
2599             // Updates:
2600             // - `address` to the owner.
2601             // - `startTimestamp` to the timestamp of minting.
2602             // - `burned` to `false`.
2603             // - `nextInitialized` to `quantity == 1`.
2604             _packedOwnerships[startTokenId] = _packOwnershipData(
2605                 to,
2606                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2607             );
2608 
2609             uint256 toMasked;
2610             uint256 end = startTokenId + quantity;
2611 
2612             // Use assembly to loop and emit the `Transfer` event for gas savings.
2613             // The duplicated `log4` removes an extra check and reduces stack juggling.
2614             // The assembly, together with the surrounding Solidity code, have been
2615             // delicately arranged to nudge the compiler into producing optimized opcodes.
2616             assembly {
2617                 // Mask `to` to the lower 160 bits, in case the upper bits somehow aren't clean.
2618                 toMasked := and(to, _BITMASK_ADDRESS)
2619                 // Emit the `Transfer` event.
2620                 log4(
2621                     0, // Start of data (0, since no data).
2622                     0, // End of data (0, since no data).
2623                     _TRANSFER_EVENT_SIGNATURE, // Signature.
2624                     0, // `address(0)`.
2625                     toMasked, // `to`.
2626                     startTokenId // `tokenId`.
2627                 )
2628 
2629                 // The `iszero(eq(,))` check ensures that large values of `quantity`
2630                 // that overflows uint256 will make the loop run out of gas.
2631                 // The compiler will optimize the `iszero` away for performance.
2632                 for {
2633                     let tokenId := add(startTokenId, 1)
2634                 } iszero(eq(tokenId, end)) {
2635                     tokenId := add(tokenId, 1)
2636                 } {
2637                     // Emit the `Transfer` event. Similar to above.
2638                     log4(0, 0, _TRANSFER_EVENT_SIGNATURE, 0, toMasked, tokenId)
2639                 }
2640             }
2641             if (toMasked == 0) revert MintToZeroAddress();
2642 
2643             _currentIndex = end;
2644         }
2645         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2646     }
2647 
2648     /**
2649      * @dev Mints `quantity` tokens and transfers them to `to`.
2650      *
2651      * This function is intended for efficient minting only during contract creation.
2652      *
2653      * It emits only one {ConsecutiveTransfer} as defined in
2654      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
2655      * instead of a sequence of {Transfer} event(s).
2656      *
2657      * Calling this function outside of contract creation WILL make your contract
2658      * non-compliant with the ERC721 standard.
2659      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
2660      * {ConsecutiveTransfer} event is only permissible during contract creation.
2661      *
2662      * Requirements:
2663      *
2664      * - `to` cannot be the zero address.
2665      * - `quantity` must be greater than 0.
2666      *
2667      * Emits a {ConsecutiveTransfer} event.
2668      */
2669     function _mintERC2309(address to, uint256 quantity) internal virtual {
2670         uint256 startTokenId = _currentIndex;
2671         if (to == address(0)) revert MintToZeroAddress();
2672         if (quantity == 0) revert MintZeroQuantity();
2673         if (quantity > _MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
2674 
2675         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
2676 
2677         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
2678         unchecked {
2679             // Updates:
2680             // - `balance += quantity`.
2681             // - `numberMinted += quantity`.
2682             //
2683             // We can directly add to the `balance` and `numberMinted`.
2684             _packedAddressData[to] += quantity * ((1 << _BITPOS_NUMBER_MINTED) | 1);
2685 
2686             // Updates:
2687             // - `address` to the owner.
2688             // - `startTimestamp` to the timestamp of minting.
2689             // - `burned` to `false`.
2690             // - `nextInitialized` to `quantity == 1`.
2691             _packedOwnerships[startTokenId] = _packOwnershipData(
2692                 to,
2693                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
2694             );
2695 
2696             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
2697 
2698             _currentIndex = startTokenId + quantity;
2699         }
2700         _afterTokenTransfers(address(0), to, startTokenId, quantity);
2701     }
2702 
2703     /**
2704      * @dev Safely mints `quantity` tokens and transfers them to `to`.
2705      *
2706      * Requirements:
2707      *
2708      * - If `to` refers to a smart contract, it must implement
2709      * {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
2710      * - `quantity` must be greater than 0.
2711      *
2712      * See {_mint}.
2713      *
2714      * Emits a {Transfer} event for each mint.
2715      */
2716     function _safeMint(
2717         address to,
2718         uint256 quantity,
2719         bytes memory _data
2720     ) internal virtual {
2721         _mint(to, quantity);
2722 
2723         unchecked {
2724             if (to.code.length != 0) {
2725                 uint256 end = _currentIndex;
2726                 uint256 index = end - quantity;
2727                 do {
2728                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
2729                         revert TransferToNonERC721ReceiverImplementer();
2730                     }
2731                 } while (index < end);
2732                 // Reentrancy protection.
2733                 if (_currentIndex != end) revert();
2734             }
2735         }
2736     }
2737 
2738     /**
2739      * @dev Equivalent to `_safeMint(to, quantity, '')`.
2740      */
2741     function _safeMint(address to, uint256 quantity) internal virtual {
2742         _safeMint(to, quantity, '');
2743     }
2744 
2745     // =============================================================
2746     //                        BURN OPERATIONS
2747     // =============================================================
2748 
2749     /**
2750      * @dev Equivalent to `_burn(tokenId, false)`.
2751      */
2752     function _burn(uint256 tokenId) internal virtual {
2753         _burn(tokenId, false);
2754     }
2755 
2756     /**
2757      * @dev Destroys `tokenId`.
2758      * The approval is cleared when the token is burned.
2759      *
2760      * Requirements:
2761      *
2762      * - `tokenId` must exist.
2763      *
2764      * Emits a {Transfer} event.
2765      */
2766     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
2767         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
2768 
2769         address from = address(uint160(prevOwnershipPacked));
2770 
2771         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedSlotAndAddress(tokenId);
2772 
2773         if (approvalCheck) {
2774             // The nested ifs save around 20+ gas over a compound boolean condition.
2775             if (!_isSenderApprovedOrOwner(approvedAddress, from, _msgSenderERC721A()))
2776                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
2777         }
2778 
2779         _beforeTokenTransfers(from, address(0), tokenId, 1);
2780 
2781         // Clear approvals from the previous owner.
2782         assembly {
2783             if approvedAddress {
2784                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
2785                 sstore(approvedAddressSlot, 0)
2786             }
2787         }
2788 
2789         // Underflow of the sender's balance is impossible because we check for
2790         // ownership above and the recipient's balance can't realistically overflow.
2791         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
2792         unchecked {
2793             // Updates:
2794             // - `balance -= 1`.
2795             // - `numberBurned += 1`.
2796             //
2797             // We can directly decrement the balance, and increment the number burned.
2798             // This is equivalent to `packed -= 1; packed += 1 << _BITPOS_NUMBER_BURNED;`.
2799             _packedAddressData[from] += (1 << _BITPOS_NUMBER_BURNED) - 1;
2800 
2801             // Updates:
2802             // - `address` to the last owner.
2803             // - `startTimestamp` to the timestamp of burning.
2804             // - `burned` to `true`.
2805             // - `nextInitialized` to `true`.
2806             _packedOwnerships[tokenId] = _packOwnershipData(
2807                 from,
2808                 (_BITMASK_BURNED | _BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
2809             );
2810 
2811             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
2812             if (prevOwnershipPacked & _BITMASK_NEXT_INITIALIZED == 0) {
2813                 uint256 nextTokenId = tokenId + 1;
2814                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
2815                 if (_packedOwnerships[nextTokenId] == 0) {
2816                     // If the next slot is within bounds.
2817                     if (nextTokenId != _currentIndex) {
2818                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
2819                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
2820                     }
2821                 }
2822             }
2823         }
2824 
2825         emit Transfer(from, address(0), tokenId);
2826         _afterTokenTransfers(from, address(0), tokenId, 1);
2827 
2828         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
2829         unchecked {
2830             _burnCounter++;
2831         }
2832     }
2833 
2834     // =============================================================
2835     //                     EXTRA DATA OPERATIONS
2836     // =============================================================
2837 
2838     /**
2839      * @dev Directly sets the extra data for the ownership data `index`.
2840      */
2841     function _setExtraDataAt(uint256 index, uint24 extraData) internal virtual {
2842         uint256 packed = _packedOwnerships[index];
2843         if (packed == 0) revert OwnershipNotInitializedForExtraData();
2844         uint256 extraDataCasted;
2845         // Cast `extraData` with assembly to avoid redundant masking.
2846         assembly {
2847             extraDataCasted := extraData
2848         }
2849         packed = (packed & _BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << _BITPOS_EXTRA_DATA);
2850         _packedOwnerships[index] = packed;
2851     }
2852 
2853     /**
2854      * @dev Called during each token transfer to set the 24bit `extraData` field.
2855      * Intended to be overridden by the cosumer contract.
2856      *
2857      * `previousExtraData` - the value of `extraData` before transfer.
2858      *
2859      * Calling conditions:
2860      *
2861      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
2862      * transferred to `to`.
2863      * - When `from` is zero, `tokenId` will be minted for `to`.
2864      * - When `to` is zero, `tokenId` will be burned by `from`.
2865      * - `from` and `to` are never both zero.
2866      */
2867     function _extraData(
2868         address from,
2869         address to,
2870         uint24 previousExtraData
2871     ) internal view virtual returns (uint24) {}
2872 
2873     /**
2874      * @dev Returns the next extra data for the packed ownership data.
2875      * The returned result is shifted into position.
2876      */
2877     function _nextExtraData(
2878         address from,
2879         address to,
2880         uint256 prevOwnershipPacked
2881     ) private view returns (uint256) {
2882         uint24 extraData = uint24(prevOwnershipPacked >> _BITPOS_EXTRA_DATA);
2883         return uint256(_extraData(from, to, extraData)) << _BITPOS_EXTRA_DATA;
2884     }
2885 
2886     // =============================================================
2887     //                       OTHER OPERATIONS
2888     // =============================================================
2889 
2890     /**
2891      * @dev Returns the message sender (defaults to `msg.sender`).
2892      *
2893      * If you are writing GSN compatible contracts, you need to override this function.
2894      */
2895     function _msgSenderERC721A() internal view virtual returns (address) {
2896         return msg.sender;
2897     }
2898 
2899     /**
2900      * @dev Converts a uint256 to its ASCII string decimal representation.
2901      */
2902     function _toString(uint256 value) internal pure virtual returns (string memory str) {
2903         assembly {
2904             // The maximum value of a uint256 contains 78 digits (1 byte per digit), but
2905             // we allocate 0xa0 bytes to keep the free memory pointer 32-byte word aligned.
2906             // We will need 1 word for the trailing zeros padding, 1 word for the length,
2907             // and 3 words for a maximum of 78 digits. Total: 5 * 0x20 = 0xa0.
2908             let m := add(mload(0x40), 0xa0)
2909             // Update the free memory pointer to allocate.
2910             mstore(0x40, m)
2911             // Assign the `str` to the end.
2912             str := sub(m, 0x20)
2913             // Zeroize the slot after the string.
2914             mstore(str, 0)
2915 
2916             // Cache the end of the memory to calculate the length later.
2917             let end := str
2918 
2919             // We write the string from rightmost digit to leftmost digit.
2920             // The following is essentially a do-while loop that also handles the zero case.
2921             // prettier-ignore
2922             for { let temp := value } 1 {} {
2923                 str := sub(str, 1)
2924                 // Write the character to the pointer.
2925                 // The ASCII index of the '0' character is 48.
2926                 mstore8(str, add(48, mod(temp, 10)))
2927                 // Keep dividing `temp` until zero.
2928                 temp := div(temp, 10)
2929                 // prettier-ignore
2930                 if iszero(temp) { break }
2931             }
2932 
2933             let length := sub(end, str)
2934             // Move the pointer 32 bytes leftwards to make room for the length.
2935             str := sub(str, 0x20)
2936             // Store the length.
2937             mstore(str, length)
2938         }
2939     }
2940 }
2941 
2942 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
2943 
2944 
2945 // ERC721A Contracts v4.2.3
2946 // Creator: Chiru Labs
2947 
2948 pragma solidity ^0.8.4;
2949 
2950 
2951 
2952 /**
2953  * @title ERC721AQueryable.
2954  *
2955  * @dev ERC721A subclass with convenience query functions.
2956  */
2957 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
2958     /**
2959      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
2960      *
2961      * If the `tokenId` is out of bounds:
2962      *
2963      * - `addr = address(0)`
2964      * - `startTimestamp = 0`
2965      * - `burned = false`
2966      * - `extraData = 0`
2967      *
2968      * If the `tokenId` is burned:
2969      *
2970      * - `addr = <Address of owner before token was burned>`
2971      * - `startTimestamp = <Timestamp when token was burned>`
2972      * - `burned = true`
2973      * - `extraData = <Extra data when token was burned>`
2974      *
2975      * Otherwise:
2976      *
2977      * - `addr = <Address of owner>`
2978      * - `startTimestamp = <Timestamp of start of ownership>`
2979      * - `burned = false`
2980      * - `extraData = <Extra data at start of ownership>`
2981      */
2982     function explicitOwnershipOf(uint256 tokenId) public view virtual override returns (TokenOwnership memory) {
2983         TokenOwnership memory ownership;
2984         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
2985             return ownership;
2986         }
2987         ownership = _ownershipAt(tokenId);
2988         if (ownership.burned) {
2989             return ownership;
2990         }
2991         return _ownershipOf(tokenId);
2992     }
2993 
2994     /**
2995      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
2996      * See {ERC721AQueryable-explicitOwnershipOf}
2997      */
2998     function explicitOwnershipsOf(uint256[] calldata tokenIds)
2999         external
3000         view
3001         virtual
3002         override
3003         returns (TokenOwnership[] memory)
3004     {
3005         unchecked {
3006             uint256 tokenIdsLength = tokenIds.length;
3007             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
3008             for (uint256 i; i != tokenIdsLength; ++i) {
3009                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
3010             }
3011             return ownerships;
3012         }
3013     }
3014 
3015     /**
3016      * @dev Returns an array of token IDs owned by `owner`,
3017      * in the range [`start`, `stop`)
3018      * (i.e. `start <= tokenId < stop`).
3019      *
3020      * This function allows for tokens to be queried if the collection
3021      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
3022      *
3023      * Requirements:
3024      *
3025      * - `start < stop`
3026      */
3027     function tokensOfOwnerIn(
3028         address owner,
3029         uint256 start,
3030         uint256 stop
3031     ) external view virtual override returns (uint256[] memory) {
3032         unchecked {
3033             if (start >= stop) revert InvalidQueryRange();
3034             uint256 tokenIdsIdx;
3035             uint256 stopLimit = _nextTokenId();
3036             // Set `start = max(start, _startTokenId())`.
3037             if (start < _startTokenId()) {
3038                 start = _startTokenId();
3039             }
3040             // Set `stop = min(stop, stopLimit)`.
3041             if (stop > stopLimit) {
3042                 stop = stopLimit;
3043             }
3044             uint256 tokenIdsMaxLength = balanceOf(owner);
3045             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
3046             // to cater for cases where `balanceOf(owner)` is too big.
3047             if (start < stop) {
3048                 uint256 rangeLength = stop - start;
3049                 if (rangeLength < tokenIdsMaxLength) {
3050                     tokenIdsMaxLength = rangeLength;
3051                 }
3052             } else {
3053                 tokenIdsMaxLength = 0;
3054             }
3055             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
3056             if (tokenIdsMaxLength == 0) {
3057                 return tokenIds;
3058             }
3059             // We need to call `explicitOwnershipOf(start)`,
3060             // because the slot at `start` may not be initialized.
3061             TokenOwnership memory ownership = explicitOwnershipOf(start);
3062             address currOwnershipAddr;
3063             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
3064             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
3065             if (!ownership.burned) {
3066                 currOwnershipAddr = ownership.addr;
3067             }
3068             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
3069                 ownership = _ownershipAt(i);
3070                 if (ownership.burned) {
3071                     continue;
3072                 }
3073                 if (ownership.addr != address(0)) {
3074                     currOwnershipAddr = ownership.addr;
3075                 }
3076                 if (currOwnershipAddr == owner) {
3077                     tokenIds[tokenIdsIdx++] = i;
3078                 }
3079             }
3080             // Downsize the array to fit.
3081             assembly {
3082                 mstore(tokenIds, tokenIdsIdx)
3083             }
3084             return tokenIds;
3085         }
3086     }
3087 
3088     /**
3089      * @dev Returns an array of token IDs owned by `owner`.
3090      *
3091      * This function scans the ownership mapping and is O(`totalSupply`) in complexity.
3092      * It is meant to be called off-chain.
3093      *
3094      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
3095      * multiple smaller scans if the collection is large enough to cause
3096      * an out-of-gas error (10K collections should be fine).
3097      */
3098     function tokensOfOwner(address owner) external view virtual override returns (uint256[] memory) {
3099         unchecked {
3100             uint256 tokenIdsIdx;
3101             address currOwnershipAddr;
3102             uint256 tokenIdsLength = balanceOf(owner);
3103             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
3104             TokenOwnership memory ownership;
3105             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
3106                 ownership = _ownershipAt(i);
3107                 if (ownership.burned) {
3108                     continue;
3109                 }
3110                 if (ownership.addr != address(0)) {
3111                     currOwnershipAddr = ownership.addr;
3112                 }
3113                 if (currOwnershipAddr == owner) {
3114                     tokenIds[tokenIdsIdx++] = i;
3115                 }
3116             }
3117             return tokenIds;
3118         }
3119     }
3120 }
3121 
3122 // File: @openzeppelin/contracts/utils/Context.sol
3123 
3124 
3125 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
3126 
3127 pragma solidity ^0.8.0;
3128 
3129 /**
3130  * @dev Provides information about the current execution context, including the
3131  * sender of the transaction and its data. While these are generally available
3132  * via msg.sender and msg.data, they should not be accessed in such a direct
3133  * manner, since when dealing with meta-transactions the account sending and
3134  * paying for execution may not be the actual sender (as far as an application
3135  * is concerned).
3136  *
3137  * This contract is only required for intermediate, library-like contracts.
3138  */
3139 abstract contract Context {
3140     function _msgSender() internal view virtual returns (address) {
3141         return msg.sender;
3142     }
3143 
3144     function _msgData() internal view virtual returns (bytes calldata) {
3145         return msg.data;
3146     }
3147 }
3148 
3149 // File: @openzeppelin/contracts/access/Ownable.sol
3150 
3151 
3152 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
3153 
3154 pragma solidity ^0.8.0;
3155 
3156 
3157 /**
3158  * @dev Contract module which provides a basic access control mechanism, where
3159  * there is an account (an owner) that can be granted exclusive access to
3160  * specific functions.
3161  *
3162  * By default, the owner account will be the one that deploys the contract. This
3163  * can later be changed with {transferOwnership}.
3164  *
3165  * This module is used through inheritance. It will make available the modifier
3166  * `onlyOwner`, which can be applied to your functions to restrict their use to
3167  * the owner.
3168  */
3169 abstract contract Ownable is Context {
3170     address private _owner;
3171 
3172     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
3173 
3174     /**
3175      * @dev Initializes the contract setting the deployer as the initial owner.
3176      */
3177     constructor() {
3178         _transferOwnership(_msgSender());
3179     }
3180 
3181     /**
3182      * @dev Throws if called by any account other than the owner.
3183      */
3184     modifier onlyOwner() {
3185         _checkOwner();
3186         _;
3187     }
3188 
3189     /**
3190      * @dev Returns the address of the current owner.
3191      */
3192     function owner() public view virtual returns (address) {
3193         return _owner;
3194     }
3195 
3196     /**
3197      * @dev Throws if the sender is not the owner.
3198      */
3199     function _checkOwner() internal view virtual {
3200         require(owner() == _msgSender(), "Ownable: caller is not the owner");
3201     }
3202 
3203     /**
3204      * @dev Leaves the contract without owner. It will not be possible to call
3205      * `onlyOwner` functions anymore. Can only be called by the current owner.
3206      *
3207      * NOTE: Renouncing ownership will leave the contract without an owner,
3208      * thereby removing any functionality that is only available to the owner.
3209      */
3210     function renounceOwnership() public virtual onlyOwner {
3211         _transferOwnership(address(0));
3212     }
3213 
3214     /**
3215      * @dev Transfers ownership of the contract to a new account (`newOwner`).
3216      * Can only be called by the current owner.
3217      */
3218     function transferOwnership(address newOwner) public virtual onlyOwner {
3219         require(newOwner != address(0), "Ownable: new owner is the zero address");
3220         _transferOwnership(newOwner);
3221     }
3222 
3223     /**
3224      * @dev Transfers ownership of the contract to a new account (`newOwner`).
3225      * Internal function without access restriction.
3226      */
3227     function _transferOwnership(address newOwner) internal virtual {
3228         address oldOwner = _owner;
3229         _owner = newOwner;
3230         emit OwnershipTransferred(oldOwner, newOwner);
3231     }
3232 }
3233 
3234 // File: rareparadise.sol
3235 
3236 
3237 pragma solidity ^0.8.15;
3238 
3239 
3240 
3241 
3242 
3243 
3244 
3245 /// @title My NFT XXX
3246 /// @author Optimizoor (https://github.com/Vectorized)
3247 contract RareParadise is ERC721A, ERC721AQueryable, Ownable {
3248     using ECDSA for bytes32;
3249 
3250     uint256 public constant PRICE_UNIT = 0.001 ether;
3251 
3252     string private _tokenURI;
3253 
3254     address public signer;
3255 
3256     uint8 public maxPerWallet = 4;
3257     uint8 public maxPerTransaction = 4;
3258     uint16 public maxSupply = 9999;
3259     uint16 private _whitelistPriceUnits = _toPriceUnits(0.009 ether);
3260     uint16 private _publicPriceUnits = _toPriceUnits(0.009 ether);
3261 
3262     bool public paused = true;
3263     bool public mintLocked;
3264     bool public maxSupplyLocked;
3265     bool public tokenURILocked;
3266 
3267     constructor() ERC721A("RareParadise", "RareParadise") {}
3268 
3269     function _startTokenId() internal view virtual override returns (uint256) {
3270         return 1;
3271     }
3272 
3273     function tokenURI(uint256 tokenId) public view override(ERC721A, IERC721A) returns (string memory) {
3274         return LibString.replace(_tokenURI, "{id}", _toString(tokenId));
3275     }
3276 
3277     function publicPrice() external view returns (uint256) {
3278         return _toPrice(_publicPriceUnits);
3279     }
3280 
3281     function whitelistPrice() external view returns (uint256) {
3282         return _toPrice(_whitelistPriceUnits);
3283     }
3284 
3285     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
3286     /*                     MINTING FUNCTIONS                      */
3287     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
3288 
3289     function publicMint(uint256 quantity)
3290         external
3291         payable
3292         mintNotPaused
3293         requireMintable(quantity)
3294         requireUserMintable(quantity)
3295         requireExactPayment(_publicPriceUnits, quantity)
3296     {
3297         _mint(msg.sender, quantity);
3298     }
3299 
3300     function whitelistMint(uint256 quantity, bytes calldata signature)
3301         external
3302         payable
3303         mintNotPaused
3304         requireMintable(quantity)
3305         requireUserMintable(quantity)
3306         requireSignature(signature)
3307         requireExactPayment(_whitelistPriceUnits, quantity)
3308     {
3309         _mint(msg.sender, quantity);
3310     }
3311 
3312     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
3313     /*                          HELPERS                           */
3314     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
3315 
3316     function _toPriceUnits(uint256 price) private pure returns (uint16) {
3317         unchecked {
3318             require(price % PRICE_UNIT == 0, "Price must be a multiple of PRICE_UNIT.");
3319             require((price /= PRICE_UNIT) <= type(uint16).max, "Overflow.");
3320             return uint16(price);
3321         }
3322     }
3323 
3324     function _toPrice(uint16 priceUnits) private pure returns (uint256) {
3325         return uint256(priceUnits) * PRICE_UNIT;
3326     }
3327 
3328     modifier requireUserMintable(uint256 quantity) {
3329         unchecked {
3330             require(quantity <= maxPerTransaction, "Max per transaction reached.");
3331             require(_numberMinted(msg.sender) + quantity <= maxPerWallet, "Max number minted reached.");
3332         }
3333         _;
3334     }
3335 
3336     modifier requireMintable(uint256 quantity) {
3337         unchecked {
3338             require(mintLocked == false, "Locked.");
3339             require(_totalMinted() + quantity <= maxSupply, "Out of stock!");
3340         }
3341         _;
3342     }
3343 
3344     modifier requireExactPayment(uint16 priceUnits, uint256 quantity) {
3345         unchecked {
3346             require(quantity <= 100, "Quantity too high.");
3347             require(msg.value == _toPrice(priceUnits) * quantity, "Wrong Ether value.");
3348         }
3349         _;
3350     }
3351 
3352     modifier requireSignature(bytes calldata signature) {
3353         require(
3354             keccak256(abi.encode(msg.sender)).toEthSignedMessageHash().recover(signature) == signer,
3355             "Invalid signature."
3356         );
3357         _;
3358     }
3359 
3360     modifier mintNotPaused() {
3361         require(paused == false, "Paused.");
3362         _;
3363     }
3364 
3365     /*´:°•.°+.*•´.*:˚.°*.˚•´.°:°•.°•.*•´.*:˚.°*.˚•´.°:°•.°+.*•´.*:*/
3366     /*                      ADMIN FUNCTIONS                       */
3367     /*.•°:°.´+˚.*°.˚:*.´•*.+°.•°:´*.´•*.•°.•°:°.´:•˚°.*°.˚:*.´+°.•*/
3368 
3369     function airdrop(address[] calldata to, uint256 quantity) external onlyOwner requireMintable(quantity * to.length) {
3370         unchecked {
3371             for (uint256 i; i != to.length; ++i) {
3372                 _mint(to[i], quantity);
3373             }
3374         }
3375     }
3376 
3377     function setTokenURI(string calldata value) external onlyOwner {
3378         require(tokenURILocked == false, "Locked.");
3379 
3380         _tokenURI = value;
3381     }
3382 
3383     function setMaxSupply(uint16 value) external onlyOwner {
3384         require(maxSupplyLocked == false, "Locked.");
3385 
3386         maxSupply = value;
3387     }
3388 
3389     function setMaxPerWallet(uint8 value) external onlyOwner {
3390         maxPerWallet = value;
3391     }
3392 
3393     function setMaxPerTransaction(uint8 value) external onlyOwner {
3394         maxPerTransaction = value;
3395     }
3396 
3397     function setPaused(bool value) external onlyOwner {
3398         if (value == false) {
3399             require(maxSupply != 0, "Max supply not set.");
3400             require(signer != address(0), "Signer not set.");
3401         }
3402         paused = value;
3403     }
3404 
3405     function setSigner(address value) external onlyOwner {
3406         require(value != address(0), "Signer must not be the zero address.");
3407 
3408         signer = value;
3409     }
3410 
3411     function lockMint() external onlyOwner {
3412         mintLocked = true;
3413     }
3414 
3415     function lockMaxSupply() external onlyOwner {
3416         maxSupplyLocked = true;
3417     }
3418 
3419     function lockTokenURI() external onlyOwner {
3420         tokenURILocked = true;
3421     }
3422 
3423     function setWhitelistPrice(uint256 value) external onlyOwner {
3424         _whitelistPriceUnits = _toPriceUnits(value);
3425     }
3426 
3427     function setPublicPrice(uint256 value) external onlyOwner {
3428         _publicPriceUnits = _toPriceUnits(value);
3429     }
3430 
3431     function withdraw() external payable onlyOwner {
3432         SafeTransferLib.safeTransferETH(msg.sender, address(this).balance);
3433     }
3434 }