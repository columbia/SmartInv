1 // SPDX-License-Identifier: VPL - VIRAL PUBLIC LICENSE
2 pragma solidity ^0.8.13;
3 
4 /*
5 
6 MMMMMMMM               MMMMMMMMEEEEEEEEEEEEEEEEEEEEEE               AAA         TTTTTTTTTTTTTTTTTTTTTTT     
7 M:::::::M             M:::::::ME::::::::::::::::::::E              A:::A        T:::::::::::::::::::::T     
8 M::::::::M           M::::::::ME::::::::::::::::::::E             A:::::A       T:::::::::::::::::::::T     
9 M:::::::::M         M:::::::::MEE::::::EEEEEEEEE::::E            A:::::::A      T:::::TT:::::::TT:::::T     
10 M::::::::::M       M::::::::::M  E:::::E       EEEEEE           A:::::::::A     TTTTTT  T:::::T  TTTTTT     
11 M:::::::::::M     M:::::::::::M  E:::::E                       A:::::A:::::A            T:::::T               
12 M:::::::M::::M   M::::M:::::::M  E::::::EEEEEEEEEE            A:::::A A:::::A           T:::::T               
13 M::::::M M::::M M::::M M::::::M  E:::::::::::::::E           A:::::A   A:::::A          T:::::T               
14 M::::::M  M::::M::::M  M::::::M  E:::::::::::::::E          A:::::A     A:::::A         T:::::T               
15 M::::::M   M:::::::M   M::::::M  E::::::EEEEEEEEEE         A:::::AAAAAAAAA:::::A        T:::::T               
16 M::::::M    M:::::M    M::::::M  E:::::E                  A:::::::::::::::::::::A       T:::::T               
17 M::::::M     MMMMM     M::::::M  E:::::E       EEEEEE    A:::::AAAAAAAAAAAAA:::::A      T:::::T             
18 M::::::M               M::::::MEE::::::EEEEEEEE:::::E   A:::::A             A:::::A   TT:::::::TT           
19 M::::::M               M::::::ME::::::::::::::::::::E  A:::::A               A:::::A  T:::::::::T           
20 M::::::M               M::::::ME::::::::::::::::::::E A:::::A                 A:::::A T:::::::::T           
21 MMMMMMMM               MMMMMMMMEEEEEEEEEEEEEEEEEEEEEEAAAAAAA                   AAAAAAATTTTTTTTTTT           
22                                                                                                                                                                                                           
23                KKKKKKKKK    KKKKKKKIIIIIIIIIITTTTTTTTTTTTTTTTTTTTTTTEEEEEEEEEEEEEEEEEEEEEE   SSSSSSSSSSSSSSS 
24               K:::::::K    K:::::KI::::::::IT:::::::::::::::::::::TE::::::::::::::::::::E SS:::::::::::::::S
25              K:::::::K    K:::::KI::::::::IT:::::::::::::::::::::TE::::::::::::::::::::ES:::::SSSSSS::::::S
26             K:::::::K   K::::::KII::::::IIT:::::TT:::::::TT:::::TEE::::::EEEEEEEEE::::ES:::::S     SSSSSSS
27            KK::::::K  K:::::KKK  I::::I  TTTTTT  T:::::T  TTTTTT  E:::::E       EEEEEES:::::S            
28             K:::::K K:::::K     I::::I          T:::::T          E:::::E             S:::::S            
29            K::::::K:::::K      I::::I          T:::::T          E::::::EEEEEEEEEE    S::::SSSS         
30           K:::::::::::K       I::::I          T:::::T          E:::::::::::::::E     SS::::::SSSSS    
31          K:::::::::::K       I::::I          T:::::T          E:::::::::::::::E       SSS::::::::SS  
32         K::::::K:::::K      I::::I          T:::::T          E::::::EEEEEEEEEE          SSSSSS::::S 
33        K:::::K K:::::K     I::::I          T:::::T          E:::::E                         S:::::S
34     KK::::::K  K:::::KKK  I::::I          T:::::T          E:::::E       EEEEEE            S:::::S
35    K:::::::K   K::::::KII::::::II      TT:::::::TT      EE::::::EEEEEEEE:::::ESSSSSSS     S:::::S
36   K:::::::K    K:::::KI::::::::I      T:::::::::T      E::::::::::::::::::::ES::::::SSSSSS:::::S
37  K:::::::K    K:::::KI::::::::I      T:::::::::T      E::::::::::::::::::::ES:::::::::::::::SS 
38 KKKKKKKKK    KKKKKKKIIIIIIIIII      TTTTTTTTTTT      EEEEEEEEEEEEEEEEEEEEEE SSSSSSSSSSSSSSS   
39 
40        meatkites.xyz | twitter.com/no_side666
41     
42        The most exotic pets generated entirely 'in-chain'.
43 
44                                                             
45                                                                               (copyleft) 2023 VPL no_side666
46 
47 */
48 
49 /// @notice Library to encode strings in Base64.
50 /// @author Solady (https://github.com/vectorized/solady/blob/main/src/utils/Base64.sol)
51 /// @author Modified from Solmate (https://github.com/transmissions11/solmate/blob/main/src/utils/Base64.sol)
52 /// @author Modified from (https://github.com/Brechtpd/base64/blob/main/base64.sol) by Brecht Devos - <brecht@loopring.org>.
53 library Base64 {
54     /// @dev Encodes `data` using the base64 encoding described in RFC 4648.
55     /// See: https://datatracker.ietf.org/doc/html/rfc4648
56     /// @param fileSafe  Whether to replace '+' with '-' and '/' with '_'.
57     /// @param noPadding Whether to strip away the padding.
58     function encode(bytes memory data, bool fileSafe, bool noPadding)
59         internal
60         pure
61         returns (string memory result)
62     {
63         /// @solidity memory-safe-assembly
64         assembly {
65             for { let dataLength := mload(data) } dataLength {} {
66                 // Multiply by 4/3 rounded up.
67                 // The `shl(2, ...)` is equivalent to multiplying by 4.
68                 let encodedLength := shl(2, div(add(dataLength, 2), 3))
69 
70                 // Set `result` to point to the start of the free memory.
71                 result := mload(0x40)
72 
73                 // Store the table into the scratch space.
74                 // Offsetted by -1 byte so that the `mload` will load the character.
75                 // We will rewrite the free memory pointer at `0x40` later with
76                 // the allocated size.
77                 // The magic constant 0x0230 will translate "-_" + "+/".
78                 mstore(0x1f, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdef")
79                 mstore(0x3f, sub("ghijklmnopqrstuvwxyz0123456789-_", mul(iszero(fileSafe), 0x0230)))
80 
81                 // Skip the first slot, which stores the length.
82                 let ptr := add(result, 0x20)
83                 let end := add(ptr, encodedLength)
84 
85                 // Run over the input, 3 bytes at a time.
86                 for {} 1 {} {
87                     data := add(data, 3) // Advance 3 bytes.
88                     let input := mload(data)
89 
90                     // Write 4 bytes. Optimized for fewer stack operations.
91                     mstore8(ptr, mload(and(shr(18, input), 0x3F)))
92                     mstore8(add(ptr, 1), mload(and(shr(12, input), 0x3F)))
93                     mstore8(add(ptr, 2), mload(and(shr(6, input), 0x3F)))
94                     mstore8(add(ptr, 3), mload(and(input, 0x3F)))
95 
96                     ptr := add(ptr, 4) // Advance 4 bytes.
97 
98                     if iszero(lt(ptr, end)) { break }
99                 }
100 
101                 // Allocate the memory for the string.
102                 // Add 31 and mask with `not(31)` to round the
103                 // free memory pointer up the next multiple of 32.
104                 mstore(0x40, and(add(end, 31), not(31)))
105 
106                 let r := mod(dataLength, 3)
107 
108                 if iszero(noPadding) {
109                     // Offset `ptr` and pad with '='. We can simply write over the end.
110                     mstore8(sub(ptr, iszero(iszero(r))), 0x3d) // Pad at `ptr - 1` if `r > 0`.
111                     mstore8(sub(ptr, shl(1, eq(r, 1))), 0x3d) // Pad at `ptr - 2` if `r == 1`.
112                     // Write the length of the string.
113                     mstore(result, encodedLength)
114                     break
115                 }
116                 // Write the length of the string.
117                 mstore(result, sub(encodedLength, add(iszero(iszero(r)), eq(r, 1))))
118                 break
119             }
120         }
121     }
122 
123     /// @dev Encodes `data` using the base64 encoding described in RFC 4648.
124     /// Equivalent to `encode(data, false, false)`.
125     function encode(bytes memory data) internal pure returns (string memory result) {
126         result = encode(data, false, false);
127     }
128 
129     /// @dev Encodes `data` using the base64 encoding described in RFC 4648.
130     /// Equivalent to `encode(data, fileSafe, false)`.
131     function encode(bytes memory data, bool fileSafe)
132         internal
133         pure
134         returns (string memory result)
135     {
136         result = encode(data, fileSafe, false);
137     }
138 
139     /// @dev Encodes base64 encoded `data`.
140     ///
141     /// Supports:
142     /// - RFC 4648 (both standard and file-safe mode).
143     /// - RFC 3501 (63: ',').
144     ///
145     /// Does not support:
146     /// - Line breaks.
147     ///
148     /// Note: For performance reasons,
149     /// this function will NOT revert on invalid `data` inputs.
150     /// Outputs for invalid inputs will simply be undefined behaviour.
151     /// It is the user's responsibility to ensure that the `data`
152     /// is a valid base64 encoded string.
153     function decode(string memory data) internal pure returns (bytes memory result) {
154         /// @solidity memory-safe-assembly
155         assembly {
156             let dataLength := mload(data)
157 
158             if dataLength {
159                 let end := add(data, dataLength)
160                 let decodedLength := mul(shr(2, dataLength), 3)
161 
162                 for {} 1 {} {
163                     // If padded.
164                     if iszero(and(dataLength, 3)) {
165                         let t := xor(mload(end), 0x3d3d)
166                         // forgefmt: disable-next-item
167                         decodedLength := sub(
168                             decodedLength,
169                             add(iszero(byte(30, t)), iszero(byte(31, t)))
170                         )
171                         break
172                     }
173                     // If non-padded.
174                     decodedLength := add(decodedLength, sub(and(dataLength, 3), 1))
175                     break
176                 }
177                 result := mload(0x40)
178 
179                 // Write the length of the string.
180                 mstore(result, decodedLength)
181 
182                 // Skip the first slot, which stores the length.
183                 let ptr := add(result, 0x20)
184 
185                 // Load the table into the scratch space.
186                 // Constants are optimized for smaller bytecode with zero gas overhead.
187                 // `m` also doubles as the mask of the upper 6 bits.
188                 let m := 0xfc000000fc00686c7074787c8084888c9094989ca0a4a8acb0b4b8bcc0c4c8cc
189                 mstore(0x5b, m)
190                 mstore(0x3b, 0x04080c1014181c2024282c3034383c4044484c5054585c6064)
191                 mstore(0x1a, 0xf8fcf800fcd0d4d8dce0e4e8ecf0f4)
192 
193                 for {} 1 {} {
194                     // Read 4 bytes.
195                     data := add(data, 4)
196                     let input := mload(data)
197 
198                     // Write 3 bytes.
199                     // forgefmt: disable-next-item
200                     mstore(ptr, or(
201                         and(m, mload(byte(28, input))),
202                         shr(6, or(
203                             and(m, mload(byte(29, input))),
204                             shr(6, or(
205                                 and(m, mload(byte(30, input))),
206                                 shr(6, mload(byte(31, input)))
207                             ))
208                         ))
209                     ))
210 
211                     ptr := add(ptr, 3)
212 
213                     if iszero(lt(data, end)) { break }
214                 }
215 
216                 // Allocate the memory for the string.
217                 // Add 32 + 31 and mask with `not(31)` to round the
218                 // free memory pointer up the next multiple of 32.
219                 mstore(0x40, and(add(add(result, decodedLength), 63), not(31)))
220 
221                 // Restore the zero slot.
222                 mstore(0x60, 0)
223             }
224         }
225     }
226 }
227 
228 // OpenZeppelin Contracts (last updated v4.8.0) (token/ERC721/IERC721.sol)
229 
230 // OpenZeppelin Contracts v4.4.1 (utils/introspection/IERC165.sol)
231 
232 /**
233  * @dev Interface of the ERC165 standard, as defined in the
234  * https://eips.ethereum.org/EIPS/eip-165[EIP].
235  *
236  * Implementers can declare support of contract interfaces, which can then be
237  * queried by others ({ERC165Checker}).
238  *
239  * For an implementation, see {ERC165}.
240  */
241 interface IERC165 {
242     /**
243      * @dev Returns true if this contract implements the interface defined by
244      * `interfaceId`. See the corresponding
245      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
246      * to learn more about how these ids are created.
247      *
248      * This function call must use less than 30 000 gas.
249      */
250     function supportsInterface(bytes4 interfaceId) external view returns (bool);
251 }
252 
253 /**
254  * @dev Required interface of an ERC721 compliant contract.
255  */
256 interface IERC721 is IERC165 {
257     /**
258      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
259      */
260     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
261 
262     /**
263      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
264      */
265     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
266 
267     /**
268      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
269      */
270     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
271 
272     /**
273      * @dev Returns the number of tokens in ``owner``'s account.
274      */
275     function balanceOf(address owner) external view returns (uint256 balance);
276 
277     /**
278      * @dev Returns the owner of the `tokenId` token.
279      *
280      * Requirements:
281      *
282      * - `tokenId` must exist.
283      */
284     function ownerOf(uint256 tokenId) external view returns (address owner);
285 
286     /**
287      * @dev Safely transfers `tokenId` token from `from` to `to`.
288      *
289      * Requirements:
290      *
291      * - `from` cannot be the zero address.
292      * - `to` cannot be the zero address.
293      * - `tokenId` token must exist and be owned by `from`.
294      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
295      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
296      *
297      * Emits a {Transfer} event.
298      */
299     function safeTransferFrom(
300         address from,
301         address to,
302         uint256 tokenId,
303         bytes calldata data
304     ) external;
305 
306     /**
307      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
308      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
309      *
310      * Requirements:
311      *
312      * - `from` cannot be the zero address.
313      * - `to` cannot be the zero address.
314      * - `tokenId` token must exist and be owned by `from`.
315      * - If the caller is not `from`, it must have been allowed to move this token by either {approve} or {setApprovalForAll}.
316      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
317      *
318      * Emits a {Transfer} event.
319      */
320     function safeTransferFrom(
321         address from,
322         address to,
323         uint256 tokenId
324     ) external;
325 
326     /**
327      * @dev Transfers `tokenId` token from `from` to `to`.
328      *
329      * WARNING: Note that the caller is responsible to confirm that the recipient is capable of receiving ERC721
330      * or else they may be permanently lost. Usage of {safeTransferFrom} prevents loss, though the caller must
331      * understand this adds an external call which potentially creates a reentrancy vulnerability.
332      *
333      * Requirements:
334      *
335      * - `from` cannot be the zero address.
336      * - `to` cannot be the zero address.
337      * - `tokenId` token must be owned by `from`.
338      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
339      *
340      * Emits a {Transfer} event.
341      */
342     function transferFrom(
343         address from,
344         address to,
345         uint256 tokenId
346     ) external;
347 
348     /**
349      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
350      * The approval is cleared when the token is transferred.
351      *
352      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
353      *
354      * Requirements:
355      *
356      * - The caller must own the token or be an approved operator.
357      * - `tokenId` must exist.
358      *
359      * Emits an {Approval} event.
360      */
361     function approve(address to, uint256 tokenId) external;
362 
363     /**
364      * @dev Approve or remove `operator` as an operator for the caller.
365      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
366      *
367      * Requirements:
368      *
369      * - The `operator` cannot be the caller.
370      *
371      * Emits an {ApprovalForAll} event.
372      */
373     function setApprovalForAll(address operator, bool _approved) external;
374 
375     /**
376      * @dev Returns the account approved for `tokenId` token.
377      *
378      * Requirements:
379      *
380      * - `tokenId` must exist.
381      */
382     function getApproved(uint256 tokenId) external view returns (address operator);
383 
384     /**
385      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
386      *
387      * See {setApprovalForAll}
388      */
389     function isApprovedForAll(address owner, address operator) external view returns (bool);
390 }
391 
392 /// @notice Read and write to persistent storage at a fraction of the cost.
393 /// @author Solmate (https://github.com/Rari-Capital/solmate/blob/main/src/utils/SSTORE2.sol)
394 /// @author Modified from 0xSequence (https://github.com/0xSequence/sstore2/blob/master/contracts/SSTORE2.sol)
395 library SSTORE2 {
396     error SSTORE2_DEPLOYMENT_FAILED();
397     error SSTORE2_READ_OUT_OF_BOUNDS();
398 
399     // We skip the first byte as it's a STOP opcode to ensure the contract can't be called.
400     uint256 internal constant DATA_OFFSET = 1;
401 
402     /*//////////////////////////////////////////////////////////////
403                                WRITE LOGIC
404     //////////////////////////////////////////////////////////////*/
405 
406     function write(bytes memory data) internal returns (address pointer) {
407         // Note: The assembly block below does not expand the memory.
408         assembly {
409             let originalDataLength := mload(data)
410 
411             // Add 1 to data size since we are prefixing it with a STOP opcode.
412             let dataSize := add(originalDataLength, 1)
413 
414             /**
415              * ------------------------------------------------------------------------------------+
416              *   Opcode  | Opcode + Arguments  | Description       | Stack View                    |
417              * ------------------------------------------------------------------------------------|
418              *   0x61    | 0x61XXXX            | PUSH2 codeSize    | codeSize                      |
419              *   0x80    | 0x80                | DUP1              | codeSize codeSize             |
420              *   0x60    | 0x600A              | PUSH1 10          | 10 codeSize codeSize          |
421              *   0x3D    | 0x3D                | RETURNDATASIZE    | 0 10 codeSize codeSize        |
422              *   0x39    | 0x39                | CODECOPY          | codeSize                      |
423              *   0x3D    | 0x3D                | RETURNDATASZIE    | 0 codeSize                    |
424              *   0xF3    | 0xF3                | RETURN            |                               |
425              *   0x00    | 0x00                | STOP              |                               |
426              * ------------------------------------------------------------------------------------+
427              * @dev Prefix the bytecode with a STOP opcode to ensure it cannot be called. Also PUSH2 is
428              * used since max contract size cap is 24,576 bytes which is less than 2 ** 16.
429              */
430             mstore(
431                 data,
432                 or(
433                     0x61000080600a3d393df300,
434                     shl(64, dataSize) // shift `dataSize` so that it lines up with the 0000 after PUSH2
435                 )
436             )
437 
438             // Deploy a new contract with the generated creation code.
439             pointer := create(0, add(data, 21), add(dataSize, 10))
440 
441             // Restore original length of the variable size `data`
442             mstore(data, originalDataLength)
443         }
444 
445         if (pointer == address(0)) {
446             revert SSTORE2_DEPLOYMENT_FAILED();
447         }
448     }
449 
450     /*//////////////////////////////////////////////////////////////
451                                READ LOGIC
452     //////////////////////////////////////////////////////////////*/
453 
454     function read(address pointer) internal view returns (bytes memory) {
455         return readBytecode(pointer, DATA_OFFSET, pointer.code.length - DATA_OFFSET);
456     }
457 
458     function read(address pointer, uint256 start) internal view returns (bytes memory) {
459         start += DATA_OFFSET;
460 
461         return readBytecode(pointer, start, pointer.code.length - start);
462     }
463 
464     function read(
465         address pointer,
466         uint256 start,
467         uint256 end
468     ) internal view returns (bytes memory) {
469         start += DATA_OFFSET;
470         end += DATA_OFFSET;
471 
472         if (pointer.code.length < end) {
473             revert SSTORE2_READ_OUT_OF_BOUNDS();
474         }
475 
476         return readBytecode(pointer, start, end - start);
477     }
478 
479     /*//////////////////////////////////////////////////////////////
480                           INTERNAL HELPER LOGIC
481     //////////////////////////////////////////////////////////////*/
482 
483     function readBytecode(
484         address pointer,
485         uint256 start,
486         uint256 size
487     ) private view returns (bytes memory data) {
488         assembly {
489             // Get a pointer to some free memory.
490             data := mload(0x40)
491 
492             // Update the free memory pointer to prevent overriding our data.
493             // We use and(x, not(31)) as a cheaper equivalent to sub(x, mod(x, 32)).
494             // Adding 63 (32 + 31) to size and running the result through the logic
495             // above ensures the memory pointer remains word-aligned, following
496             // the Solidity convention.
497             mstore(0x40, add(data, and(add(size, 63), not(31))))
498 
499             // Store the size of the data in the first 32 byte chunk of free memory.
500             mstore(data, size)
501 
502             // Copy the code into memory right after the 32 bytes we used to store the size.
503             extcodecopy(pointer, add(data, 32), start, size)
504         }
505     }
506 }
507 
508 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
509 
510 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
511 
512 /**
513  * @dev Provides information about the current execution context, including the
514  * sender of the transaction and its data. While these are generally available
515  * via msg.sender and msg.data, they should not be accessed in such a direct
516  * manner, since when dealing with meta-transactions the account sending and
517  * paying for execution may not be the actual sender (as far as an application
518  * is concerned).
519  *
520  * This contract is only required for intermediate, library-like contracts.
521  */
522 abstract contract Context {
523     function _msgSender() internal view virtual returns (address) {
524         return msg.sender;
525     }
526 
527     function _msgData() internal view virtual returns (bytes calldata) {
528         return msg.data;
529     }
530 }
531 
532 /**
533  * @dev Contract module which provides a basic access control mechanism, where
534  * there is an account (an owner) that can be granted exclusive access to
535  * specific functions.
536  *
537  * By default, the owner account will be the one that deploys the contract. This
538  * can later be changed with {transferOwnership}.
539  *
540  * This module is used through inheritance. It will make available the modifier
541  * `onlyOwner`, which can be applied to your functions to restrict their use to
542  * the owner.
543  */
544 abstract contract Ownable is Context {
545     address private _owner;
546 
547     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
548 
549     /**
550      * @dev Initializes the contract setting the deployer as the initial owner.
551      */
552     constructor() {
553         _transferOwnership(_msgSender());
554     }
555 
556     /**
557      * @dev Throws if called by any account other than the owner.
558      */
559     modifier onlyOwner() {
560         _checkOwner();
561         _;
562     }
563 
564     /**
565      * @dev Returns the address of the current owner.
566      */
567     function owner() public view virtual returns (address) {
568         return _owner;
569     }
570 
571     /**
572      * @dev Throws if the sender is not the owner.
573      */
574     function _checkOwner() internal view virtual {
575         require(owner() == _msgSender(), "Ownable: caller is not the owner");
576     }
577 
578     /**
579      * @dev Leaves the contract without owner. It will not be possible to call
580      * `onlyOwner` functions anymore. Can only be called by the current owner.
581      *
582      * NOTE: Renouncing ownership will leave the contract without an owner,
583      * thereby removing any functionality that is only available to the owner.
584      */
585     function renounceOwnership() public virtual onlyOwner {
586         _transferOwnership(address(0));
587     }
588 
589     /**
590      * @dev Transfers ownership of the contract to a new account (`newOwner`).
591      * Can only be called by the current owner.
592      */
593     function transferOwnership(address newOwner) public virtual onlyOwner {
594         require(newOwner != address(0), "Ownable: new owner is the zero address");
595         _transferOwnership(newOwner);
596     }
597 
598     /**
599      * @dev Transfers ownership of the contract to a new account (`newOwner`).
600      * Internal function without access restriction.
601      */
602     function _transferOwnership(address newOwner) internal virtual {
603         address oldOwner = _owner;
604         _owner = newOwner;
605         emit OwnershipTransferred(oldOwner, newOwner);
606     }
607 }
608 
609 // OpenZeppelin Contracts (last updated v4.7.0) (token/common/ERC2981.sol)
610 
611 // OpenZeppelin Contracts (last updated v4.6.0) (interfaces/IERC2981.sol)
612 
613 /**
614  * @dev Interface for the NFT Royalty Standard.
615  *
616  * A standardized way to retrieve royalty payment information for non-fungible tokens (NFTs) to enable universal
617  * support for royalty payments across all NFT marketplaces and ecosystem participants.
618  *
619  * _Available since v4.5._
620  */
621 interface IERC2981 is IERC165 {
622     /**
623      * @dev Returns how much royalty is owed and to whom, based on a sale price that may be denominated in any unit of
624      * exchange. The royalty amount is denominated and should be paid in that same unit of exchange.
625      */
626     function royaltyInfo(uint256 tokenId, uint256 salePrice)
627         external
628         view
629         returns (address receiver, uint256 royaltyAmount);
630 }
631 
632 // OpenZeppelin Contracts v4.4.1 (utils/introspection/ERC165.sol)
633 
634 /**
635  * @dev Implementation of the {IERC165} interface.
636  *
637  * Contracts that want to implement ERC165 should inherit from this contract and override {supportsInterface} to check
638  * for the additional interface id that will be supported. For example:
639  *
640  * ```solidity
641  * function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
642  *     return interfaceId == type(MyInterface).interfaceId || super.supportsInterface(interfaceId);
643  * }
644  * ```
645  *
646  * Alternatively, {ERC165Storage} provides an easier to use but more expensive implementation.
647  */
648 abstract contract ERC165 is IERC165 {
649     /**
650      * @dev See {IERC165-supportsInterface}.
651      */
652     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
653         return interfaceId == type(IERC165).interfaceId;
654     }
655 }
656 
657 /**
658  * @dev Implementation of the NFT Royalty Standard, a standardized way to retrieve royalty payment information.
659  *
660  * Royalty information can be specified globally for all token ids via {_setDefaultRoyalty}, and/or individually for
661  * specific token ids via {_setTokenRoyalty}. The latter takes precedence over the first.
662  *
663  * Royalty is specified as a fraction of sale price. {_feeDenominator} is overridable but defaults to 10000, meaning the
664  * fee is specified in basis points by default.
665  *
666  * IMPORTANT: ERC-2981 only specifies a way to signal royalty information and does not enforce its payment. See
667  * https://eips.ethereum.org/EIPS/eip-2981#optional-royalty-payments[Rationale] in the EIP. Marketplaces are expected to
668  * voluntarily pay royalties together with sales, but note that this standard is not yet widely supported.
669  *
670  * _Available since v4.5._
671  */
672 abstract contract ERC2981 is IERC2981, ERC165 {
673     struct RoyaltyInfo {
674         address receiver;
675         uint96 royaltyFraction;
676     }
677 
678     RoyaltyInfo private _defaultRoyaltyInfo;
679     mapping(uint256 => RoyaltyInfo) private _tokenRoyaltyInfo;
680 
681     /**
682      * @dev See {IERC165-supportsInterface}.
683      */
684     function supportsInterface(bytes4 interfaceId) public view virtual override(IERC165, ERC165) returns (bool) {
685         return interfaceId == type(IERC2981).interfaceId || super.supportsInterface(interfaceId);
686     }
687 
688     /**
689      * @inheritdoc IERC2981
690      */
691     function royaltyInfo(uint256 _tokenId, uint256 _salePrice) public view virtual override returns (address, uint256) {
692         RoyaltyInfo memory royalty = _tokenRoyaltyInfo[_tokenId];
693 
694         if (royalty.receiver == address(0)) {
695             royalty = _defaultRoyaltyInfo;
696         }
697 
698         uint256 royaltyAmount = (_salePrice * royalty.royaltyFraction) / _feeDenominator();
699 
700         return (royalty.receiver, royaltyAmount);
701     }
702 
703     /**
704      * @dev The denominator with which to interpret the fee set in {_setTokenRoyalty} and {_setDefaultRoyalty} as a
705      * fraction of the sale price. Defaults to 10000 so fees are expressed in basis points, but may be customized by an
706      * override.
707      */
708     function _feeDenominator() internal pure virtual returns (uint96) {
709         return 10000;
710     }
711 
712     /**
713      * @dev Sets the royalty information that all ids in this contract will default to.
714      *
715      * Requirements:
716      *
717      * - `receiver` cannot be the zero address.
718      * - `feeNumerator` cannot be greater than the fee denominator.
719      */
720     function _setDefaultRoyalty(address receiver, uint96 feeNumerator) internal virtual {
721         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
722         require(receiver != address(0), "ERC2981: invalid receiver");
723 
724         _defaultRoyaltyInfo = RoyaltyInfo(receiver, feeNumerator);
725     }
726 
727     /**
728      * @dev Removes default royalty information.
729      */
730     function _deleteDefaultRoyalty() internal virtual {
731         delete _defaultRoyaltyInfo;
732     }
733 
734     /**
735      * @dev Sets the royalty information for a specific token id, overriding the global default.
736      *
737      * Requirements:
738      *
739      * - `receiver` cannot be the zero address.
740      * - `feeNumerator` cannot be greater than the fee denominator.
741      */
742     function _setTokenRoyalty(
743         uint256 tokenId,
744         address receiver,
745         uint96 feeNumerator
746     ) internal virtual {
747         require(feeNumerator <= _feeDenominator(), "ERC2981: royalty fee will exceed salePrice");
748         require(receiver != address(0), "ERC2981: Invalid parameters");
749 
750         _tokenRoyaltyInfo[tokenId] = RoyaltyInfo(receiver, feeNumerator);
751     }
752 
753     /**
754      * @dev Resets royalty information for the token id back to the global default.
755      */
756     function _resetTokenRoyalty(uint256 tokenId) internal virtual {
757         delete _tokenRoyaltyInfo[tokenId];
758     }
759 }
760 
761 // OpenZeppelin Contracts (last updated v4.8.0) (utils/Strings.sol)
762 
763 // OpenZeppelin Contracts (last updated v4.8.0) (utils/math/Math.sol)
764 
765 /**
766  * @dev Standard math utilities missing in the Solidity language.
767  */
768 library Math {
769     enum Rounding {
770         Down, // Toward negative infinity
771         Up, // Toward infinity
772         Zero // Toward zero
773     }
774 
775     /**
776      * @dev Returns the largest of two numbers.
777      */
778     function max(uint256 a, uint256 b) internal pure returns (uint256) {
779         return a > b ? a : b;
780     }
781 
782     /**
783      * @dev Returns the smallest of two numbers.
784      */
785     function min(uint256 a, uint256 b) internal pure returns (uint256) {
786         return a < b ? a : b;
787     }
788 
789     /**
790      * @dev Returns the average of two numbers. The result is rounded towards
791      * zero.
792      */
793     function average(uint256 a, uint256 b) internal pure returns (uint256) {
794         // (a + b) / 2 can overflow.
795         return (a & b) + (a ^ b) / 2;
796     }
797 
798     /**
799      * @dev Returns the ceiling of the division of two numbers.
800      *
801      * This differs from standard division with `/` in that it rounds up instead
802      * of rounding down.
803      */
804     function ceilDiv(uint256 a, uint256 b) internal pure returns (uint256) {
805         // (a + b - 1) / b can overflow on addition, so we distribute.
806         return a == 0 ? 0 : (a - 1) / b + 1;
807     }
808 
809     /**
810      * @notice Calculates floor(x * y / denominator) with full precision. Throws if result overflows a uint256 or denominator == 0
811      * @dev Original credit to Remco Bloemen under MIT license (https://xn--2-umb.com/21/muldiv)
812      * with further edits by Uniswap Labs also under MIT license.
813      */
814     function mulDiv(
815         uint256 x,
816         uint256 y,
817         uint256 denominator
818     ) internal pure returns (uint256 result) {
819         unchecked {
820             // 512-bit multiply [prod1 prod0] = x * y. Compute the product mod 2^256 and mod 2^256 - 1, then use
821             // use the Chinese Remainder Theorem to reconstruct the 512 bit result. The result is stored in two 256
822             // variables such that product = prod1 * 2^256 + prod0.
823             uint256 prod0; // Least significant 256 bits of the product
824             uint256 prod1; // Most significant 256 bits of the product
825             assembly {
826                 let mm := mulmod(x, y, not(0))
827                 prod0 := mul(x, y)
828                 prod1 := sub(sub(mm, prod0), lt(mm, prod0))
829             }
830 
831             // Handle non-overflow cases, 256 by 256 division.
832             if (prod1 == 0) {
833                 return prod0 / denominator;
834             }
835 
836             // Make sure the result is less than 2^256. Also prevents denominator == 0.
837             require(denominator > prod1);
838 
839             ///////////////////////////////////////////////
840             // 512 by 256 division.
841             ///////////////////////////////////////////////
842 
843             // Make division exact by subtracting the remainder from [prod1 prod0].
844             uint256 remainder;
845             assembly {
846                 // Compute remainder using mulmod.
847                 remainder := mulmod(x, y, denominator)
848 
849                 // Subtract 256 bit number from 512 bit number.
850                 prod1 := sub(prod1, gt(remainder, prod0))
851                 prod0 := sub(prod0, remainder)
852             }
853 
854             // Factor powers of two out of denominator and compute largest power of two divisor of denominator. Always >= 1.
855             // See https://cs.stackexchange.com/q/138556/92363.
856 
857             // Does not overflow because the denominator cannot be zero at this stage in the function.
858             uint256 twos = denominator & (~denominator + 1);
859             assembly {
860                 // Divide denominator by twos.
861                 denominator := div(denominator, twos)
862 
863                 // Divide [prod1 prod0] by twos.
864                 prod0 := div(prod0, twos)
865 
866                 // Flip twos such that it is 2^256 / twos. If twos is zero, then it becomes one.
867                 twos := add(div(sub(0, twos), twos), 1)
868             }
869 
870             // Shift in bits from prod1 into prod0.
871             prod0 |= prod1 * twos;
872 
873             // Invert denominator mod 2^256. Now that denominator is an odd number, it has an inverse modulo 2^256 such
874             // that denominator * inv = 1 mod 2^256. Compute the inverse by starting with a seed that is correct for
875             // four bits. That is, denominator * inv = 1 mod 2^4.
876             uint256 inverse = (3 * denominator) ^ 2;
877 
878             // Use the Newton-Raphson iteration to improve the precision. Thanks to Hensel's lifting lemma, this also works
879             // in modular arithmetic, doubling the correct bits in each step.
880             inverse *= 2 - denominator * inverse; // inverse mod 2^8
881             inverse *= 2 - denominator * inverse; // inverse mod 2^16
882             inverse *= 2 - denominator * inverse; // inverse mod 2^32
883             inverse *= 2 - denominator * inverse; // inverse mod 2^64
884             inverse *= 2 - denominator * inverse; // inverse mod 2^128
885             inverse *= 2 - denominator * inverse; // inverse mod 2^256
886 
887             // Because the division is now exact we can divide by multiplying with the modular inverse of denominator.
888             // This will give us the correct result modulo 2^256. Since the preconditions guarantee that the outcome is
889             // less than 2^256, this is the final result. We don't need to compute the high bits of the result and prod1
890             // is no longer required.
891             result = prod0 * inverse;
892             return result;
893         }
894     }
895 
896     /**
897      * @notice Calculates x * y / denominator with full precision, following the selected rounding direction.
898      */
899     function mulDiv(
900         uint256 x,
901         uint256 y,
902         uint256 denominator,
903         Rounding rounding
904     ) internal pure returns (uint256) {
905         uint256 result = mulDiv(x, y, denominator);
906         if (rounding == Rounding.Up && mulmod(x, y, denominator) > 0) {
907             result += 1;
908         }
909         return result;
910     }
911 
912     /**
913      * @dev Returns the square root of a number. If the number is not a perfect square, the value is rounded down.
914      *
915      * Inspired by Henry S. Warren, Jr.'s "Hacker's Delight" (Chapter 11).
916      */
917     function sqrt(uint256 a) internal pure returns (uint256) {
918         if (a == 0) {
919             return 0;
920         }
921 
922         // For our first guess, we get the biggest power of 2 which is smaller than the square root of the target.
923         //
924         // We know that the "msb" (most significant bit) of our target number `a` is a power of 2 such that we have
925         // `msb(a) <= a < 2*msb(a)`. This value can be written `msb(a)=2**k` with `k=log2(a)`.
926         //
927         // This can be rewritten `2**log2(a) <= a < 2**(log2(a) + 1)`
928         // → `sqrt(2**k) <= sqrt(a) < sqrt(2**(k+1))`
929         // → `2**(k/2) <= sqrt(a) < 2**((k+1)/2) <= 2**(k/2 + 1)`
930         //
931         // Consequently, `2**(log2(a) / 2)` is a good first approximation of `sqrt(a)` with at least 1 correct bit.
932         uint256 result = 1 << (log2(a) >> 1);
933 
934         // At this point `result` is an estimation with one bit of precision. We know the true value is a uint128,
935         // since it is the square root of a uint256. Newton's method converges quadratically (precision doubles at
936         // every iteration). We thus need at most 7 iteration to turn our partial result with one bit of precision
937         // into the expected uint128 result.
938         unchecked {
939             result = (result + a / result) >> 1;
940             result = (result + a / result) >> 1;
941             result = (result + a / result) >> 1;
942             result = (result + a / result) >> 1;
943             result = (result + a / result) >> 1;
944             result = (result + a / result) >> 1;
945             result = (result + a / result) >> 1;
946             return min(result, a / result);
947         }
948     }
949 
950     /**
951      * @notice Calculates sqrt(a), following the selected rounding direction.
952      */
953     function sqrt(uint256 a, Rounding rounding) internal pure returns (uint256) {
954         unchecked {
955             uint256 result = sqrt(a);
956             return result + (rounding == Rounding.Up && result * result < a ? 1 : 0);
957         }
958     }
959 
960     /**
961      * @dev Return the log in base 2, rounded down, of a positive value.
962      * Returns 0 if given 0.
963      */
964     function log2(uint256 value) internal pure returns (uint256) {
965         uint256 result = 0;
966         unchecked {
967             if (value >> 128 > 0) {
968                 value >>= 128;
969                 result += 128;
970             }
971             if (value >> 64 > 0) {
972                 value >>= 64;
973                 result += 64;
974             }
975             if (value >> 32 > 0) {
976                 value >>= 32;
977                 result += 32;
978             }
979             if (value >> 16 > 0) {
980                 value >>= 16;
981                 result += 16;
982             }
983             if (value >> 8 > 0) {
984                 value >>= 8;
985                 result += 8;
986             }
987             if (value >> 4 > 0) {
988                 value >>= 4;
989                 result += 4;
990             }
991             if (value >> 2 > 0) {
992                 value >>= 2;
993                 result += 2;
994             }
995             if (value >> 1 > 0) {
996                 result += 1;
997             }
998         }
999         return result;
1000     }
1001 
1002     /**
1003      * @dev Return the log in base 2, following the selected rounding direction, of a positive value.
1004      * Returns 0 if given 0.
1005      */
1006     function log2(uint256 value, Rounding rounding) internal pure returns (uint256) {
1007         unchecked {
1008             uint256 result = log2(value);
1009             return result + (rounding == Rounding.Up && 1 << result < value ? 1 : 0);
1010         }
1011     }
1012 
1013     /**
1014      * @dev Return the log in base 10, rounded down, of a positive value.
1015      * Returns 0 if given 0.
1016      */
1017     function log10(uint256 value) internal pure returns (uint256) {
1018         uint256 result = 0;
1019         unchecked {
1020             if (value >= 10**64) {
1021                 value /= 10**64;
1022                 result += 64;
1023             }
1024             if (value >= 10**32) {
1025                 value /= 10**32;
1026                 result += 32;
1027             }
1028             if (value >= 10**16) {
1029                 value /= 10**16;
1030                 result += 16;
1031             }
1032             if (value >= 10**8) {
1033                 value /= 10**8;
1034                 result += 8;
1035             }
1036             if (value >= 10**4) {
1037                 value /= 10**4;
1038                 result += 4;
1039             }
1040             if (value >= 10**2) {
1041                 value /= 10**2;
1042                 result += 2;
1043             }
1044             if (value >= 10**1) {
1045                 result += 1;
1046             }
1047         }
1048         return result;
1049     }
1050 
1051     /**
1052      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1053      * Returns 0 if given 0.
1054      */
1055     function log10(uint256 value, Rounding rounding) internal pure returns (uint256) {
1056         unchecked {
1057             uint256 result = log10(value);
1058             return result + (rounding == Rounding.Up && 10**result < value ? 1 : 0);
1059         }
1060     }
1061 
1062     /**
1063      * @dev Return the log in base 256, rounded down, of a positive value.
1064      * Returns 0 if given 0.
1065      *
1066      * Adding one to the result gives the number of pairs of hex symbols needed to represent `value` as a hex string.
1067      */
1068     function log256(uint256 value) internal pure returns (uint256) {
1069         uint256 result = 0;
1070         unchecked {
1071             if (value >> 128 > 0) {
1072                 value >>= 128;
1073                 result += 16;
1074             }
1075             if (value >> 64 > 0) {
1076                 value >>= 64;
1077                 result += 8;
1078             }
1079             if (value >> 32 > 0) {
1080                 value >>= 32;
1081                 result += 4;
1082             }
1083             if (value >> 16 > 0) {
1084                 value >>= 16;
1085                 result += 2;
1086             }
1087             if (value >> 8 > 0) {
1088                 result += 1;
1089             }
1090         }
1091         return result;
1092     }
1093 
1094     /**
1095      * @dev Return the log in base 10, following the selected rounding direction, of a positive value.
1096      * Returns 0 if given 0.
1097      */
1098     function log256(uint256 value, Rounding rounding) internal pure returns (uint256) {
1099         unchecked {
1100             uint256 result = log256(value);
1101             return result + (rounding == Rounding.Up && 1 << (result * 8) < value ? 1 : 0);
1102         }
1103     }
1104 }
1105 
1106 /**
1107  * @dev String operations.
1108  */
1109 library Strings {
1110     bytes16 private constant _SYMBOLS = "0123456789abcdef";
1111     uint8 private constant _ADDRESS_LENGTH = 20;
1112 
1113     /**
1114      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1115      */
1116     function toString(uint256 value) internal pure returns (string memory) {
1117         unchecked {
1118             uint256 length = Math.log10(value) + 1;
1119             string memory buffer = new string(length);
1120             uint256 ptr;
1121             /// @solidity memory-safe-assembly
1122             assembly {
1123                 ptr := add(buffer, add(32, length))
1124             }
1125             while (true) {
1126                 ptr--;
1127                 /// @solidity memory-safe-assembly
1128                 assembly {
1129                     mstore8(ptr, byte(mod(value, 10), _SYMBOLS))
1130                 }
1131                 value /= 10;
1132                 if (value == 0) break;
1133             }
1134             return buffer;
1135         }
1136     }
1137 
1138     /**
1139      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
1140      */
1141     function toHexString(uint256 value) internal pure returns (string memory) {
1142         unchecked {
1143             return toHexString(value, Math.log256(value) + 1);
1144         }
1145     }
1146 
1147     /**
1148      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
1149      */
1150     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
1151         bytes memory buffer = new bytes(2 * length + 2);
1152         buffer[0] = "0";
1153         buffer[1] = "x";
1154         for (uint256 i = 2 * length + 1; i > 1; --i) {
1155             buffer[i] = _SYMBOLS[value & 0xf];
1156             value >>= 4;
1157         }
1158         require(value == 0, "Strings: hex length insufficient");
1159         return string(buffer);
1160     }
1161 
1162     /**
1163      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
1164      */
1165     function toHexString(address addr) internal pure returns (string memory) {
1166         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
1167     }
1168 }
1169 
1170 abstract contract MarketWares is ERC2981, Ownable {
1171 
1172     address immutable private _tokenImagePtr;
1173 
1174     address immutable private _royaltyReceiver;
1175 
1176     constructor(bytes memory bTokenImage) Ownable() {
1177         _royaltyReceiver = owner();
1178         _setDefaultRoyalty(_royaltyReceiver, 500); // ERC2981 5% royalty on secondary sales
1179         _tokenImagePtr = SSTORE2.write(bTokenImage);
1180     }
1181       
1182     // needed for opensea
1183     function contractURI() public view returns(string memory) {
1184         return string(abi.encodePacked(
1185                   "data:application/json;base64,", 
1186                   Base64.encode(abi.encodePacked("{\"name\": \"MeatKites\","
1187                        " \"description\": \"The most exotic pets generated entirely 'in-chain'. meatkites.xyz | twitter.com/no_side666\","
1188                        " \"image\": \"", 
1189                        "data:image/svg+xml;base64,",
1190                        Base64.encode(SSTORE2.read(_tokenImagePtr)), 
1191                        "\",",
1192                        " \"seller_fee_basis_points:\": \"500\","
1193                        " \"fee_recipient\": \"", Strings.toHexString(_royaltyReceiver) ,"\"}"))));
1194     }
1195 
1196     function sendETH() external {
1197         (bool success,) = owner().call{value: address(this).balance}("");
1198         require(success, "call failed.");
1199     }
1200 }
1201 
1202 /// @notice Modern, minimalist, and gas efficient ERC-721 implementation.
1203 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC721.sol)
1204 abstract contract ERC721 {
1205     /*//////////////////////////////////////////////////////////////
1206                                  EVENTS
1207     //////////////////////////////////////////////////////////////*/
1208 
1209     event Transfer(address indexed from, address indexed to, uint256 indexed id);
1210 
1211     event Approval(address indexed owner, address indexed spender, uint256 indexed id);
1212 
1213     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
1214 
1215     /*//////////////////////////////////////////////////////////////
1216                          METADATA STORAGE/LOGIC
1217     //////////////////////////////////////////////////////////////*/
1218 
1219     string public name;
1220 
1221     string public symbol;
1222 
1223     function tokenURI(uint256 id) public view virtual returns (string memory);
1224 
1225     /*//////////////////////////////////////////////////////////////
1226                       ERC721 BALANCE/OWNER STORAGE
1227     //////////////////////////////////////////////////////////////*/
1228 
1229     mapping(uint256 => address) internal _ownerOf;
1230 
1231     mapping(address => uint256) internal _balanceOf;
1232 
1233     function ownerOf(uint256 id) public view virtual returns (address owner) {
1234         require((owner = _ownerOf[id]) != address(0), "NOT_MINTED");
1235     }
1236 
1237     function balanceOf(address owner) public view virtual returns (uint256) {
1238         require(owner != address(0), "ZERO_ADDRESS");
1239 
1240         return _balanceOf[owner];
1241     }
1242 
1243     /*//////////////////////////////////////////////////////////////
1244                          ERC721 APPROVAL STORAGE
1245     //////////////////////////////////////////////////////////////*/
1246 
1247     mapping(uint256 => address) public getApproved;
1248 
1249     mapping(address => mapping(address => bool)) public isApprovedForAll;
1250 
1251     /*//////////////////////////////////////////////////////////////
1252                                CONSTRUCTOR
1253     //////////////////////////////////////////////////////////////*/
1254 
1255     constructor(string memory _name, string memory _symbol) {
1256         name = _name;
1257         symbol = _symbol;
1258     }
1259 
1260     /*//////////////////////////////////////////////////////////////
1261                               ERC721 LOGIC
1262     //////////////////////////////////////////////////////////////*/
1263 
1264     function approve(address spender, uint256 id) public virtual {
1265         address owner = _ownerOf[id];
1266 
1267         require(msg.sender == owner || isApprovedForAll[owner][msg.sender], "NOT_AUTHORIZED");
1268 
1269         getApproved[id] = spender;
1270 
1271         emit Approval(owner, spender, id);
1272     }
1273 
1274     function setApprovalForAll(address operator, bool approved) public virtual {
1275         isApprovedForAll[msg.sender][operator] = approved;
1276 
1277         emit ApprovalForAll(msg.sender, operator, approved);
1278     }
1279 
1280     function transferFrom(
1281         address from,
1282         address to,
1283         uint256 id
1284     ) public virtual {
1285         require(from == _ownerOf[id], "WRONG_FROM");
1286 
1287         require(to != address(0), "INVALID_RECIPIENT");
1288 
1289         require(
1290             msg.sender == from || isApprovedForAll[from][msg.sender] || msg.sender == getApproved[id],
1291             "NOT_AUTHORIZED"
1292         );
1293 
1294         // Underflow of the sender's balance is impossible because we check for
1295         // ownership above and the recipient's balance can't realistically overflow.
1296         unchecked {
1297             _balanceOf[from]--;
1298 
1299             _balanceOf[to]++;
1300         }
1301 
1302         _ownerOf[id] = to;
1303 
1304         delete getApproved[id];
1305 
1306         emit Transfer(from, to, id);
1307     }
1308 
1309     function safeTransferFrom(
1310         address from,
1311         address to,
1312         uint256 id
1313     ) public virtual {
1314         transferFrom(from, to, id);
1315 
1316         require(
1317             to.code.length == 0 ||
1318                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, "") ==
1319                 ERC721TokenReceiver.onERC721Received.selector,
1320             "UNSAFE_RECIPIENT"
1321         );
1322     }
1323 
1324     function safeTransferFrom(
1325         address from,
1326         address to,
1327         uint256 id,
1328         bytes calldata data
1329     ) public virtual {
1330         transferFrom(from, to, id);
1331 
1332         require(
1333             to.code.length == 0 ||
1334                 ERC721TokenReceiver(to).onERC721Received(msg.sender, from, id, data) ==
1335                 ERC721TokenReceiver.onERC721Received.selector,
1336             "UNSAFE_RECIPIENT"
1337         );
1338     }
1339 
1340     /*//////////////////////////////////////////////////////////////
1341                               ERC165 LOGIC
1342     //////////////////////////////////////////////////////////////*/
1343 
1344     function supportsInterface(bytes4 interfaceId) public view virtual returns (bool) {
1345         return
1346             interfaceId == 0x01ffc9a7 || // ERC165 Interface ID for ERC165
1347             interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
1348             interfaceId == 0x5b5e139f; // ERC165 Interface ID for ERC721Metadata
1349     }
1350 
1351     /*//////////////////////////////////////////////////////////////
1352                         INTERNAL MINT/BURN LOGIC
1353     //////////////////////////////////////////////////////////////*/
1354 
1355     function _mint(address to, uint256 id) internal virtual {
1356         require(to != address(0), "INVALID_RECIPIENT");
1357 
1358         require(_ownerOf[id] == address(0), "ALREADY_MINTED");
1359 
1360         // Counter overflow is incredibly unrealistic.
1361         unchecked {
1362             _balanceOf[to]++;
1363         }
1364 
1365         _ownerOf[id] = to;
1366 
1367         emit Transfer(address(0), to, id);
1368     }
1369 
1370     function _burn(uint256 id) internal virtual {
1371         address owner = _ownerOf[id];
1372 
1373         require(owner != address(0), "NOT_MINTED");
1374 
1375         // Ownership check above ensures no underflow.
1376         unchecked {
1377             _balanceOf[owner]--;
1378         }
1379 
1380         delete _ownerOf[id];
1381 
1382         delete getApproved[id];
1383 
1384         emit Transfer(owner, address(0), id);
1385     }
1386 
1387     /*//////////////////////////////////////////////////////////////
1388                         INTERNAL SAFE MINT LOGIC
1389     //////////////////////////////////////////////////////////////*/
1390 
1391     function _safeMint(address to, uint256 id) internal virtual {
1392         _mint(to, id);
1393 
1394         require(
1395             to.code.length == 0 ||
1396                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, "") ==
1397                 ERC721TokenReceiver.onERC721Received.selector,
1398             "UNSAFE_RECIPIENT"
1399         );
1400     }
1401 
1402     function _safeMint(
1403         address to,
1404         uint256 id,
1405         bytes memory data
1406     ) internal virtual {
1407         _mint(to, id);
1408 
1409         require(
1410             to.code.length == 0 ||
1411                 ERC721TokenReceiver(to).onERC721Received(msg.sender, address(0), id, data) ==
1412                 ERC721TokenReceiver.onERC721Received.selector,
1413             "UNSAFE_RECIPIENT"
1414         );
1415     }
1416 }
1417 
1418 /// @notice A generic interface for a contract which properly accepts ERC721 tokens.
1419 /// @author Solmate (https://github.com/transmissions11/solmate/blob/main/src/tokens/ERC721.sol)
1420 abstract contract ERC721TokenReceiver {
1421     function onERC721Received(
1422         address,
1423         address,
1424         uint256,
1425         bytes calldata
1426     ) external virtual returns (bytes4) {
1427         return ERC721TokenReceiver.onERC721Received.selector;
1428     }
1429 }
1430 
1431 interface IOperatorFilterRegistry {
1432     function isOperatorAllowed(address registrant, address operator) external view returns (bool);
1433     function register(address registrant) external;
1434     function registerAndSubscribe(address registrant, address subscription) external;
1435     function registerAndCopyEntries(address registrant, address registrantToCopy) external;
1436     function unregister(address addr) external;
1437     function updateOperator(address registrant, address operator, bool filtered) external;
1438     function updateOperators(address registrant, address[] calldata operators, bool filtered) external;
1439     function updateCodeHash(address registrant, bytes32 codehash, bool filtered) external;
1440     function updateCodeHashes(address registrant, bytes32[] calldata codeHashes, bool filtered) external;
1441     function subscribe(address registrant, address registrantToSubscribe) external;
1442     function unsubscribe(address registrant, bool copyExistingEntries) external;
1443     function subscriptionOf(address addr) external returns (address registrant);
1444     function subscribers(address registrant) external returns (address[] memory);
1445     function subscriberAt(address registrant, uint256 index) external returns (address);
1446     function copyEntriesOf(address registrant, address registrantToCopy) external;
1447     function isOperatorFiltered(address registrant, address operator) external returns (bool);
1448     function isCodeHashOfFiltered(address registrant, address operatorWithCode) external returns (bool);
1449     function isCodeHashFiltered(address registrant, bytes32 codeHash) external returns (bool);
1450     function filteredOperators(address addr) external returns (address[] memory);
1451     function filteredCodeHashes(address addr) external returns (bytes32[] memory);
1452     function filteredOperatorAt(address registrant, uint256 index) external returns (address);
1453     function filteredCodeHashAt(address registrant, uint256 index) external returns (bytes32);
1454     function isRegistered(address addr) external returns (bool);
1455     function codeHashOf(address addr) external returns (bytes32);
1456 }
1457 
1458 /**
1459  * @title  OperatorFilterer
1460  * @notice Abstract contract whose constructor automatically registers and optionally subscribes to or copies another
1461  *         registrant's entries in the OperatorFilterRegistry.
1462  * @dev    This smart contract is meant to be inherited by token contracts so they can use the following:
1463  *         - `onlyAllowedOperator` modifier for `transferFrom` and `safeTransferFrom` methods.
1464  *         - `onlyAllowedOperatorApproval` modifier for `approve` and `setApprovalForAll` methods.
1465  */
1466 abstract contract OperatorFilterer {
1467     error OperatorNotAllowed(address operator);
1468 
1469     IOperatorFilterRegistry public constant OPERATOR_FILTER_REGISTRY =
1470         IOperatorFilterRegistry(0x000000000000AAeB6D7670E522A718067333cd4E);
1471 
1472     constructor(address subscriptionOrRegistrantToCopy, bool subscribe) {
1473         // If an inheriting token contract is deployed to a network without the registry deployed, the modifier
1474         // will not revert, but the contract will need to be registered with the registry once it is deployed in
1475         // order for the modifier to filter addresses.
1476         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1477             if (subscribe) {
1478                 OPERATOR_FILTER_REGISTRY.registerAndSubscribe(address(this), subscriptionOrRegistrantToCopy);
1479             } else {
1480                 if (subscriptionOrRegistrantToCopy != address(0)) {
1481                     OPERATOR_FILTER_REGISTRY.registerAndCopyEntries(address(this), subscriptionOrRegistrantToCopy);
1482                 } else {
1483                     OPERATOR_FILTER_REGISTRY.register(address(this));
1484                 }
1485             }
1486         }
1487     }
1488 
1489     modifier onlyAllowedOperator(address from) virtual {
1490         // Allow spending tokens from addresses with balance
1491         // Note that this still allows listings and marketplaces with escrow to transfer tokens if transferred
1492         // from an EOA.
1493         if (from != msg.sender) {
1494             _checkFilterOperator(msg.sender);
1495         }
1496         _;
1497     }
1498 
1499     modifier onlyAllowedOperatorApproval(address operator) virtual {
1500         _checkFilterOperator(operator);
1501         _;
1502     }
1503 
1504     function _checkFilterOperator(address operator) internal view virtual {
1505         // Check registry code length to facilitate testing in environments without a deployed registry.
1506         if (address(OPERATOR_FILTER_REGISTRY).code.length > 0) {
1507             if (!OPERATOR_FILTER_REGISTRY.isOperatorAllowed(address(this), operator)) {
1508                 revert OperatorNotAllowed(operator);
1509             }
1510         }
1511     }
1512 }
1513 
1514 /**
1515  * @title  DefaultOperatorFilterer
1516  * @notice Inherits from OperatorFilterer and automatically subscribes to the default OpenSea subscription.
1517  */
1518 abstract contract DefaultOperatorFilterer is OperatorFilterer {
1519     address constant DEFAULT_SUBSCRIPTION = address(0x3cc6CddA760b79bAfa08dF41ECFA224f810dCeB6);
1520 
1521     constructor() OperatorFilterer(DEFAULT_SUBSCRIPTION, true) {}
1522 }
1523 
1524 abstract contract OperatorFilteredERC721 is ERC721, DefaultOperatorFilterer {
1525 
1526     constructor(
1527         string memory name_,
1528         string memory symbol_
1529     ) ERC721(name_, symbol_) {}
1530 
1531     // overrides for DefaultOperatorFilterer, which enables creator fees on opensea
1532 
1533     function setApprovalForAll(address operator, bool approved) public override onlyAllowedOperatorApproval(operator) {
1534         super.setApprovalForAll(operator, approved);
1535     }
1536 
1537     function approve(address operator, uint256 tokenId) public override onlyAllowedOperatorApproval(operator) {
1538         super.approve(operator, tokenId);
1539     }
1540 
1541     function transferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1542         super.transferFrom(from, to, tokenId);
1543     }
1544 
1545     function safeTransferFrom(address from, address to, uint256 tokenId) public override onlyAllowedOperator(from) {
1546         super.safeTransferFrom(from, to, tokenId);
1547     }
1548 
1549     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data)
1550         public
1551         override
1552         onlyAllowedOperator(from)
1553     {
1554         super.safeTransferFrom(from, to, tokenId, data);
1555     }
1556 }
1557 
1558 interface IRenderer {
1559     function renderAttributes(uint256 tokenId) external view returns(string memory);
1560     function renderSVG(uint256 tokenId) external view returns(string memory);
1561 }
1562 
1563 contract MeatKitesMaker is OperatorFilteredERC721, MarketWares {
1564     
1565     uint256 public totalSupply;
1566     // qty's
1567     uint256 constant public FREE_MINT = 100;
1568     uint256 constant public PEOPLE_PRICES_MINT = 300;
1569     uint256 constant public MAX_SUPPLY = 2222;
1570 
1571     // prices
1572     uint256 constant public PEOPLE_PRICE = 0.01 ether;
1573     uint256 constant public WANKER_PRICE = 0.1 ether;
1574 
1575     uint256 public publicMintDate;
1576 
1577     IRenderer internal _renderer;
1578 
1579     constructor(address renderer_, bytes memory bTokenImage) OperatorFilteredERC721("MKs", "MeatKites") MarketWares(bTokenImage) {
1580 
1581         _renderer = IRenderer(renderer_);
1582     }
1583 
1584     function mint(address to) external payable returns(uint256 lastTokenId) {
1585         return _mintTo({to: to, discounted: false});
1586     }
1587 
1588     function mintDiscounted(address to) external payable returns(uint256 lastTokenId) {
1589         return _mintTo({to: to, discounted: callerOwnsSweetNFTs()}); 
1590     }
1591 
1592     function publicMintActive() public view returns(bool) {
1593         uint256 _publicMintDate = publicMintDate;
1594         return (_publicMintDate != 0) && (block.timestamp > _publicMintDate);
1595     }
1596 
1597     function currentPrice() external view returns(uint256) {
1598         return _currentPrice({totalSupply_: totalSupply, discounted: false});
1599     }
1600 
1601     function currentDiscountedPrice() external view returns(uint256) {
1602         return _currentPrice({
1603                   totalSupply_: totalSupply, 
1604                   discounted: callerOwnsSweetNFTs()});
1605     }
1606 
1607     function callerOwnsSweetNFTs() public view returns(bool isCoolOwner) {
1608         IERC721[4] memory coolNFTs = [
1609             IERC721(address(0x5078981549A1CC18673eb76fb47468f546aAdc51)), // FEETPIX wtf 
1610             IERC721(address(0xeF1a89cbfAbE59397FfdA11Fc5DF293E9bC5Db90)), // BASED GHOULS
1611             IERC721(address(0x5Af0D9827E0c53E4799BB226655A1de152A425a5)), // MILADY MAKER 
1612             IERC721(address(0x5DcE0bB0778694Ef3Ba79Bb702b88CAC1879cc7D))]; // bonSAI NFT
1613         for (uint256 i; i < coolNFTs.length; ++i) {
1614             if ((coolNFTs[i]).balanceOf(msg.sender) > 0) {
1615                 isCoolOwner = true;
1616                 break;
1617             } 
1618         }        
1619     }
1620     
1621 
1622     function tokenURI(uint256 tokenId) public view override returns(string memory) {
1623 
1624         require(tokenId < totalSupply, "tokenId dne.");
1625         string memory attributes = _renderer.renderAttributes(tokenId);
1626         assembly { // delete last comma
1627             mstore(attributes, sub(mload(attributes), 1))
1628         }
1629 
1630         return string(abi.encodePacked(
1631           "data:application/json;base64,", 
1632           Base64.encode(abi.encodePacked(
1633             "{\"name\":\"MeatKites ", Strings.toString(tokenId),
1634             "\", \"description\":\"the most exotic in-chain pets",
1635             "\", \"attributes\":[", attributes,
1636             "], \"image\":\"data:image/svg+xml;base64,", 
1637             Base64.encode(bytes(_renderer.renderSVG(tokenId))),
1638             "\"}"
1639         ))));
1640     }
1641 
1642     function renderSVG(uint256 tokenId) external view virtual returns(string memory) {
1643         require(tokenId < totalSupply, "tokenId dne.");
1644         return string(Base64.encode(bytes(_renderer.renderSVG(tokenId))));
1645     }
1646 
1647     function supportsInterface(bytes4 interfaceId) public view virtual override(ERC721, ERC2981) returns (bool) {
1648         return interfaceId == type(IERC2981).interfaceId || 
1649                interfaceId == 0x80ac58cd || // ERC165 Interface ID for ERC721
1650                interfaceId == 0x5b5e139f || // ERC165 Interface ID for ERC721Metadata
1651                super.supportsInterface(interfaceId);
1652     }
1653 
1654     // priveledged fns
1655     
1656     function setPublicMintDate(uint256 publicMintDate_) external onlyOwner virtual {
1657         require(publicMintDate == 0, "can only set once.");
1658         publicMintDate = publicMintDate_;
1659     }
1660 
1661     // internal/private fns
1662     
1663     function _mintTo(address to, bool discounted) private returns(uint256 lastTokenId) {
1664         require(publicMintActive() || msg.sender == owner(), "!publicMintActive.");
1665         uint256 tokenId = totalSupply;
1666         uint256 currentPrice_ = _currentPrice({totalSupply_: tokenId, discounted: discounted});
1667         unchecked{
1668         uint256 qty = (currentPrice_ > 0) ? msg.value / currentPrice_ : 1;
1669         // means freeMint is qty=1 at a time
1670         _checkQty(qty, tokenId);
1671         for (uint256 i; i < qty; ++i) {
1672             _mint(to, tokenId++); 
1673         }
1674         lastTokenId = tokenId;
1675         totalSupply = lastTokenId;
1676         }//uc all math here safe
1677     }
1678 
1679     function _currentPrice(uint256 totalSupply_, bool discounted) private pure returns(uint256){
1680         unchecked{
1681         uint256 divisor = (discounted) ? 2 : 1;
1682         uint256[3] memory checkpoints = [FREE_MINT, PEOPLE_PRICES_MINT, MAX_SUPPLY];
1683         if (totalSupply_ < checkpoints[0]) {
1684             return 0; // free 
1685         } else if (totalSupply_ < checkpoints[1]) {
1686             return PEOPLE_PRICE / divisor;
1687         }
1688         return WANKER_PRICE / divisor;
1689         }//uc
1690     }
1691 
1692     function _checkQty(uint256 desiredQty, uint256 totalSupply_) private pure {
1693         require(desiredQty > 0, "msg.value must be n * currentPrice().");
1694         // this crosses over interval boundary thankfully
1695         unchecked{
1696         uint256 sum = desiredQty + totalSupply_; // won't overflow due to scarcity of eth and max supply
1697         require(sum <= MAX_SUPPLY, "all tokens minted.");
1698         if (desiredQty == 1) return; 
1699         uint256[3] memory checkpoints = [FREE_MINT, PEOPLE_PRICES_MINT, MAX_SUPPLY];
1700         bool inDifferentIntervals;
1701         for (uint256 i; i < checkpoints.length; ++i) {
1702             if ((totalSupply_ < checkpoints[i]) != (sum <= checkpoints[i])) {
1703                 inDifferentIntervals = true;
1704                 break;
1705             }
1706         }
1707         require(!inDifferentIntervals, "qty out of range.");
1708         }//uc
1709     }
1710 }