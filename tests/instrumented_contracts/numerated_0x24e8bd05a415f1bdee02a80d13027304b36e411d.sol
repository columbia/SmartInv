1 // SPDX-License-Identifier: MIT
2 // File: @openzeppelin/contracts/security/ReentrancyGuard.sol
3 
4 /**
5                                        ..           ..                                              
6                                       .,.            ,'                                             
7                                      .c:             .l'                                            
8                                      :d.              cd.                                           
9                                     ,Ol               .kd.                                          
10                                  ...xO'           .   .lKc...                                       
11                                 .'.lXd. ... .. ..... . '00'.'.                                      
12                                'c',0K;..................dNd.::.                                     
13                            .. .dl.dWk'..................:XX:'dc....                                 
14                          .....dk':XWo...................,OWk'cO:......                              
15                       .......lKl.xWXc........''..........xWXc'kO,........                           
16                     ........:Kk';KM0;........cl'..'......oNMk.cKx'........                          
17                   .........,OXl.dWMO,.'..''.,xO;.'''''''.lXMK:'kXo..........                        
18                  ..........dNO',OMWx''''',,'cKXo',,,'''''cKMWd.cXK:..........                       
19                 ..........:KNo.cXMWd'',,,,,;xWWO;,;;,,,,'cKMMO',OWk'..........                      
20                ..........'kW0;.dWMNd,,,,,;;lKWWXo;::;;;;,c0MMK:.oNXl...........                     
21               ...........cXWx',OMMNd,,;;;:ckWMMWOc:::;:;;c0MMNo.:KWO,...........                    
22               ..........,kMXl.:0WMNd;;;::cdXMNNMNxclc:::;c0WMWx',kWNl...........                    
23               ..........cXM0:.cKWWWk::::clOWNKKNWKxdlccc:dXWWWk,'oNMO,...........                   
24              ..........'xWWk,',oKWWNOocccxXNXNNXNNXOolllkXWWNkc''cKMXc...........                   
25              ..........:KMWKc'',:xXWWXxlo0NXNMMNXNMXxod0WWN0l;'',xNMWx'..........                   
26               .........oNWWNo'',,;lONWN0OXKXWMMMNKKNKOXWWKd:,,,';OWWM0;..........                   
27              .........'kWWNx,''',;;:dKWWWKXWMMMMMX0KNWWNkl;;,,''.cKWWNl..........                   
28               ........;0WWk,'ldlc:;;;lONKKWMMMWMWWWKKNKd:;;;:cod:.lXWWx..........                   
29               ........:XM0;.oNMWXK0Okxdkk0WMMWWMMWWKkOxxkk0KXNWW0;.dNWk'........                    
30                .......lNXc.lXMMWWWWWWMWNXOKWMMWWMX0OKNNWWWWWWWMMWO,'xW0,.......                     
31                .......dNd.:KMMKoodxkOO00KOkXWWWMW0kO0000OkxxdlxXMWx',0K;......                      
32                 ......xk''OWMXl.'''',lkkxOkONMMW0k0Okkkd:,'''.,kWMNo.cOc......                      
33                  .....l;.dNMWk'...':kNWWWNOdKMWNxx0XWWWW0o;'...cXWWK;.l:.....                       
34                    .....:XWWXc...:xXWW0oc:lOWMWWXdc:clkNWN0l'..'xWWWk'.....                         
35                     ...,OWWWk'.;xXWWXd,..cKWWWWWWNXd'.'c0WWN0l'.:XWWNo....                          
36                      . ;KWWXc.,OWWWO:...'kWWWWWWWWMXc...'oXWMNo..xWWWx. .                           
37                        .oNM0, .kWWXc....'kWWWWWWWWMK:....'kMMNc..lNMK;                              
38                         'kWK: .oNMNl.....,dXWWWWNOd:.....'OWW0, .xWNl.                              
39                          ,0Wd. ,0MWd.......'oO0x:....... ;KMWd. ;KNo.                               
40                           ;KK: .dWMk. .................. :XMK; .xNx.                                
41                            :Kk. ;KM0'    .     .  ..    .lWWx. cKk.                                 
42                             :0o..dWX;         W         .xMK; ,Ox.                                  
43                              ;kc '0No         E         'ONo .xd.                                   
44                               'l, :Xk.        B         :Xk..cc.                                    
45                                .'..o0;        3        .dO' ''                                      
46                                    .oo.    spyders     ,x;                                          
47                                     .c'               .:;                                           
48  By Arachnyx                        .'.              .' 
49 */
50 
51 // OpenZeppelin Contracts v4.4.1 (security/ReentrancyGuard.sol)
52 
53 pragma solidity ^0.8.0;
54 
55 /**
56  * @dev Contract module that helps prevent reentrant calls to a function.
57  *
58  * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
59  * available, which can be applied to functions to make sure there are no nested
60  * (reentrant) calls to them.
61  *
62  * Note that because there is a single `nonReentrant` guard, functions marked as
63  * `nonReentrant` may not call one another. This can be worked around by making
64  * those functions `private`, and then adding `external` `nonReentrant` entry
65  * points to them.
66  *
67  * TIP: If you would like to learn more about reentrancy and alternative ways
68  * to protect against it, check out our blog post
69  * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
70  */
71 abstract contract ReentrancyGuard {
72     // Booleans are more expensive than uint256 or any type that takes up a full
73     // word because each write operation emits an extra SLOAD to first read the
74     // slot's contents, replace the bits taken up by the boolean, and then write
75     // back. This is the compiler's defense against contract upgrades and
76     // pointer aliasing, and it cannot be disabled.
77 
78     // The values being non-zero value makes deployment a bit more expensive,
79     // but in exchange the refund on every call to nonReentrant will be lower in
80     // amount. Since refunds are capped to a percentage of the total
81     // transaction's gas, it is best to keep them low in cases like this one, to
82     // increase the likelihood of the full refund coming into effect.
83     uint256 private constant _NOT_ENTERED = 1;
84     uint256 private constant _ENTERED = 2;
85 
86     uint256 private _status;
87 
88     constructor() {
89         _status = _NOT_ENTERED;
90     }
91 
92     /**
93      * @dev Prevents a contract from calling itself, directly or indirectly.
94      * Calling a `nonReentrant` function from another `nonReentrant`
95      * function is not supported. It is possible to prevent this from happening
96      * by making the `nonReentrant` function external, and making it call a
97      * `private` function that does the actual work.
98      */
99     modifier nonReentrant() {
100         // On the first call to nonReentrant, _notEntered will be true
101         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
102 
103         // Any calls to nonReentrant after this point will fail
104         _status = _ENTERED;
105 
106         _;
107 
108         // By storing the original value once again, a refund is triggered (see
109         // https://eips.ethereum.org/EIPS/eip-2200)
110         _status = _NOT_ENTERED;
111     }
112 }
113 
114 // File: @openzeppelin/contracts/utils/Strings.sol
115 
116 
117 // OpenZeppelin Contracts (last updated v4.7.0) (utils/Strings.sol)
118 
119 pragma solidity ^0.8.0;
120 
121 /**
122  * @dev String operations.
123  */
124 library Strings {
125     bytes16 private constant _HEX_SYMBOLS = "0123456789abcdef";
126     uint8 private constant _ADDRESS_LENGTH = 20;
127 
128     /**
129      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
130      */
131     function toString(uint256 value) internal pure returns (string memory) {
132         // Inspired by OraclizeAPI's implementation - MIT licence
133         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
134 
135         if (value == 0) {
136             return "0";
137         }
138         uint256 temp = value;
139         uint256 digits;
140         while (temp != 0) {
141             digits++;
142             temp /= 10;
143         }
144         bytes memory buffer = new bytes(digits);
145         while (value != 0) {
146             digits -= 1;
147             buffer[digits] = bytes1(uint8(48 + uint256(value % 10)));
148             value /= 10;
149         }
150         return string(buffer);
151     }
152 
153     /**
154      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation.
155      */
156     function toHexString(uint256 value) internal pure returns (string memory) {
157         if (value == 0) {
158             return "0x00";
159         }
160         uint256 temp = value;
161         uint256 length = 0;
162         while (temp != 0) {
163             length++;
164             temp >>= 8;
165         }
166         return toHexString(value, length);
167     }
168 
169     /**
170      * @dev Converts a `uint256` to its ASCII `string` hexadecimal representation with fixed length.
171      */
172     function toHexString(uint256 value, uint256 length) internal pure returns (string memory) {
173         bytes memory buffer = new bytes(2 * length + 2);
174         buffer[0] = "0";
175         buffer[1] = "x";
176         for (uint256 i = 2 * length + 1; i > 1; --i) {
177             buffer[i] = _HEX_SYMBOLS[value & 0xf];
178             value >>= 4;
179         }
180         require(value == 0, "Strings: hex length insufficient");
181         return string(buffer);
182     }
183 
184     /**
185      * @dev Converts an `address` with fixed length of 20 bytes to its not checksummed ASCII `string` hexadecimal representation.
186      */
187     function toHexString(address addr) internal pure returns (string memory) {
188         return toHexString(uint256(uint160(addr)), _ADDRESS_LENGTH);
189     }
190 }
191 
192 
193 // File: @openzeppelin/contracts/utils/Context.sol
194 
195 
196 // OpenZeppelin Contracts v4.4.1 (utils/Context.sol)
197 
198 pragma solidity ^0.8.0;
199 
200 /**
201  * @dev Provides information about the current execution context, including the
202  * sender of the transaction and its data. While these are generally available
203  * via msg.sender and msg.data, they should not be accessed in such a direct
204  * manner, since when dealing with meta-transactions the account sending and
205  * paying for execution may not be the actual sender (as far as an application
206  * is concerned).
207  *
208  * This contract is only required for intermediate, library-like contracts.
209  */
210 abstract contract Context {
211     function _msgSender() internal view virtual returns (address) {
212         return msg.sender;
213     }
214 
215     function _msgData() internal view virtual returns (bytes calldata) {
216         return msg.data;
217     }
218 }
219 
220 // File: @openzeppelin/contracts/access/Ownable.sol
221 
222 
223 // OpenZeppelin Contracts (last updated v4.7.0) (access/Ownable.sol)
224 
225 pragma solidity ^0.8.0;
226 
227 
228 /**
229  * @dev Contract module which provides a basic access control mechanism, where
230  * there is an account (an owner) that can be granted exclusive access to
231  * specific functions.
232  *
233  * By default, the owner account will be the one that deploys the contract. This
234  * can later be changed with {transferOwnership}.
235  *
236  * This module is used through inheritance. It will make available the modifier
237  * `onlyOwner`, which can be applied to your functions to restrict their use to
238  * the owner.
239  */
240 abstract contract Ownable is Context {
241     address private _owner;
242 
243     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
244 
245     /**
246      * @dev Initializes the contract setting the deployer as the initial owner.
247      */
248     constructor() {
249         _transferOwnership(_msgSender());
250     }
251 
252     /**
253      * @dev Throws if called by any account other than the owner.
254      */
255     modifier onlyOwner() {
256         _checkOwner();
257         _;
258     }
259 
260     /**
261      * @dev Returns the address of the current owner.
262      */
263     function owner() public view virtual returns (address) {
264         return _owner;
265     }
266 
267     /**
268      * @dev Throws if the sender is not the owner.
269      */
270     function _checkOwner() internal view virtual {
271         require(owner() == _msgSender(), "Ownable: caller is not the owner");
272     }
273 
274     /**
275      * @dev Leaves the contract without owner. It will not be possible to call
276      * `onlyOwner` functions anymore. Can only be called by the current owner.
277      *
278      * NOTE: Renouncing ownership will leave the contract without an owner,
279      * thereby removing any functionality that is only available to the owner.
280      */
281     function renounceOwnership() public virtual onlyOwner {
282         _transferOwnership(address(0));
283     }
284 
285     /**
286      * @dev Transfers ownership of the contract to a new account (`newOwner`).
287      * Can only be called by the current owner.
288      */
289     function transferOwnership(address newOwner) public virtual onlyOwner {
290         require(newOwner != address(0), "Ownable: new owner is the zero address");
291         _transferOwnership(newOwner);
292     }
293 
294     /**
295      * @dev Transfers ownership of the contract to a new account (`newOwner`).
296      * Internal function without access restriction.
297      */
298     function _transferOwnership(address newOwner) internal virtual {
299         address oldOwner = _owner;
300         _owner = newOwner;
301         emit OwnershipTransferred(oldOwner, newOwner);
302     }
303 }
304 
305 // File: erc721a/contracts/IERC721A.sol
306 
307 
308 // ERC721A Contracts v4.1.0
309 // Creator: Chiru Labs
310 
311 pragma solidity ^0.8.4;
312 
313 /**
314  * @dev Interface of an ERC721A compliant contract.
315  */
316 interface IERC721A {
317     /**
318      * The caller must own the token or be an approved operator.
319      */
320     error ApprovalCallerNotOwnerNorApproved();
321 
322     /**
323      * The token does not exist.
324      */
325     error ApprovalQueryForNonexistentToken();
326 
327     /**
328      * The caller cannot approve to their own address.
329      */
330     error ApproveToCaller();
331 
332     /**
333      * Cannot query the balance for the zero address.
334      */
335     error BalanceQueryForZeroAddress();
336 
337     /**
338      * Cannot mint to the zero address.
339      */
340     error MintToZeroAddress();
341 
342     /**
343      * The quantity of tokens minted must be more than zero.
344      */
345     error MintZeroQuantity();
346 
347     /**
348      * The token does not exist.
349      */
350     error OwnerQueryForNonexistentToken();
351 
352     /**
353      * The caller must own the token or be an approved operator.
354      */
355     error TransferCallerNotOwnerNorApproved();
356 
357     /**
358      * The token must be owned by `from`.
359      */
360     error TransferFromIncorrectOwner();
361 
362     /**
363      * Cannot safely transfer to a contract that does not implement the ERC721Receiver interface.
364      */
365     error TransferToNonERC721ReceiverImplementer();
366 
367     /**
368      * Cannot transfer to the zero address.
369      */
370     error TransferToZeroAddress();
371 
372     /**
373      * The token does not exist.
374      */
375     error URIQueryForNonexistentToken();
376 
377     /**
378      * The `quantity` minted with ERC2309 exceeds the safety limit.
379      */
380     error MintERC2309QuantityExceedsLimit();
381 
382     /**
383      * The `extraData` cannot be set on an unintialized ownership slot.
384      */
385     error OwnershipNotInitializedForExtraData();
386 
387     struct TokenOwnership {
388         // The address of the owner.
389         address addr;
390         // Keeps track of the start time of ownership with minimal overhead for tokenomics.
391         uint64 startTimestamp;
392         // Whether the token has been burned.
393         bool burned;
394         // Arbitrary data similar to `startTimestamp` that can be set through `_extraData`.
395         uint24 extraData;
396     }
397 
398     /**
399      * @dev Returns the total amount of tokens stored by the contract.
400      *
401      * Burned tokens are calculated here, use `_totalMinted()` if you want to count just minted tokens.
402      */
403     function totalSupply() external view returns (uint256);
404 
405     // ==============================
406     //            IERC165
407     // ==============================
408 
409     /**
410      * @dev Returns true if this contract implements the interface defined by
411      * `interfaceId`. See the corresponding
412      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
413      * to learn more about how these ids are created.
414      *
415      * This function call must use less than 30 000 gas.
416      */
417     function supportsInterface(bytes4 interfaceId) external view returns (bool);
418 
419     // ==============================
420     //            IERC721
421     // ==============================
422 
423     /**
424      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
425      */
426     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
427 
428     /**
429      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
430      */
431     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
432 
433     /**
434      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
435      */
436     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
437 
438     /**
439      * @dev Returns the number of tokens in ``owner``'s account.
440      */
441     function balanceOf(address owner) external view returns (uint256 balance);
442 
443     /**
444      * @dev Returns the owner of the `tokenId` token.
445      *
446      * Requirements:
447      *
448      * - `tokenId` must exist.
449      */
450     function ownerOf(uint256 tokenId) external view returns (address owner);
451 
452     /**
453      * @dev Safely transfers `tokenId` token from `from` to `to`.
454      *
455      * Requirements:
456      *
457      * - `from` cannot be the zero address.
458      * - `to` cannot be the zero address.
459      * - `tokenId` token must exist and be owned by `from`.
460      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
461      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
462      *
463      * Emits a {Transfer} event.
464      */
465     function safeTransferFrom(
466         address from,
467         address to,
468         uint256 tokenId,
469         bytes calldata data
470     ) external;
471 
472     /**
473      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
474      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
475      *
476      * Requirements:
477      *
478      * - `from` cannot be the zero address.
479      * - `to` cannot be the zero address.
480      * - `tokenId` token must exist and be owned by `from`.
481      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
482      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
483      *
484      * Emits a {Transfer} event.
485      */
486     function safeTransferFrom(
487         address from,
488         address to,
489         uint256 tokenId
490     ) external;
491 
492     /**
493      * @dev Transfers `tokenId` token from `from` to `to`.
494      *
495      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
496      *
497      * Requirements:
498      *
499      * - `from` cannot be the zero address.
500      * - `to` cannot be the zero address.
501      * - `tokenId` token must be owned by `from`.
502      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
503      *
504      * Emits a {Transfer} event.
505      */
506     function transferFrom(
507         address from,
508         address to,
509         uint256 tokenId
510     ) external;
511 
512     /**
513      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
514      * The approval is cleared when the token is transferred.
515      *
516      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
517      *
518      * Requirements:
519      *
520      * - The caller must own the token or be an approved operator.
521      * - `tokenId` must exist.
522      *
523      * Emits an {Approval} event.
524      */
525     function approve(address to, uint256 tokenId) external;
526 
527     /**
528      * @dev Approve or remove `operator` as an operator for the caller.
529      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
530      *
531      * Requirements:
532      *
533      * - The `operator` cannot be the caller.
534      *
535      * Emits an {ApprovalForAll} event.
536      */
537     function setApprovalForAll(address operator, bool _approved) external;
538 
539     /**
540      * @dev Returns the account approved for `tokenId` token.
541      *
542      * Requirements:
543      *
544      * - `tokenId` must exist.
545      */
546     function getApproved(uint256 tokenId) external view returns (address operator);
547 
548     /**
549      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
550      *
551      * See {setApprovalForAll}
552      */
553     function isApprovedForAll(address owner, address operator) external view returns (bool);
554 
555     // ==============================
556     //        IERC721Metadata
557     // ==============================
558 
559     /**
560      * @dev Returns the token collection name.
561      */
562     function name() external view returns (string memory);
563 
564     /**
565      * @dev Returns the token collection symbol.
566      */
567     function symbol() external view returns (string memory);
568 
569     /**
570      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
571      */
572     function tokenURI(uint256 tokenId) external view returns (string memory);
573 
574     // ==============================
575     //            IERC2309
576     // ==============================
577 
578     /**
579      * @dev Emitted when tokens in `fromTokenId` to `toTokenId` (inclusive) is transferred from `from` to `to`,
580      * as defined in the ERC2309 standard. See `_mintERC2309` for more details.
581      */
582     event ConsecutiveTransfer(uint256 indexed fromTokenId, uint256 toTokenId, address indexed from, address indexed to);
583 }
584 
585 // File: erc721a/contracts/ERC721A.sol
586 
587 
588 // ERC721A Contracts v4.1.0
589 // Creator: Chiru Labs
590 
591 pragma solidity ^0.8.4;
592 
593 
594 /**
595  * @dev ERC721 token receiver interface.
596  */
597 interface ERC721A__IERC721Receiver {
598     function onERC721Received(
599         address operator,
600         address from,
601         uint256 tokenId,
602         bytes calldata data
603     ) external returns (bytes4);
604 }
605 
606 /**
607  * @dev Implementation of https://eips.ethereum.org/EIPS/eip-721[ERC721] Non-Fungible Token Standard,
608  * including the Metadata extension. Built to optimize for lower gas during batch mints.
609  *
610  * Assumes serials are sequentially minted starting at `_startTokenId()`
611  * (defaults to 0, e.g. 0, 1, 2, 3..).
612  *
613  * Assumes that an owner cannot have more than 2**64 - 1 (max value of uint64) of supply.
614  *
615  * Assumes that the maximum token id cannot exceed 2**256 - 1 (max value of uint256).
616  */
617 contract ERC721A is IERC721A {
618     // Mask of an entry in packed address data.
619     uint256 private constant BITMASK_ADDRESS_DATA_ENTRY = (1 << 64) - 1;
620 
621     // The bit position of `numberMinted` in packed address data.
622     uint256 private constant BITPOS_NUMBER_MINTED = 64;
623 
624     // The bit position of `numberBurned` in packed address data.
625     uint256 private constant BITPOS_NUMBER_BURNED = 128;
626 
627     // The bit position of `aux` in packed address data.
628     uint256 private constant BITPOS_AUX = 192;
629 
630     // Mask of all 256 bits in packed address data except the 64 bits for `aux`.
631     uint256 private constant BITMASK_AUX_COMPLEMENT = (1 << 192) - 1;
632 
633     // The bit position of `startTimestamp` in packed ownership.
634     uint256 private constant BITPOS_START_TIMESTAMP = 160;
635 
636     // The bit mask of the `burned` bit in packed ownership.
637     uint256 private constant BITMASK_BURNED = 1 << 224;
638 
639     // The bit position of the `nextInitialized` bit in packed ownership.
640     uint256 private constant BITPOS_NEXT_INITIALIZED = 225;
641 
642     // The bit mask of the `nextInitialized` bit in packed ownership.
643     uint256 private constant BITMASK_NEXT_INITIALIZED = 1 << 225;
644 
645     // The bit position of `extraData` in packed ownership.
646     uint256 private constant BITPOS_EXTRA_DATA = 232;
647 
648     // Mask of all 256 bits in a packed ownership except the 24 bits for `extraData`.
649     uint256 private constant BITMASK_EXTRA_DATA_COMPLEMENT = (1 << 232) - 1;
650 
651     // The mask of the lower 160 bits for addresses.
652     uint256 private constant BITMASK_ADDRESS = (1 << 160) - 1;
653 
654     // The maximum `quantity` that can be minted with `_mintERC2309`.
655     // This limit is to prevent overflows on the address data entries.
656     // For a limit of 5000, a total of 3.689e15 calls to `_mintERC2309`
657     // is required to cause an overflow, which is unrealistic.
658     uint256 private constant MAX_MINT_ERC2309_QUANTITY_LIMIT = 5000;
659 
660     // The tokenId of the next token to be minted.
661     uint256 private _currentIndex;
662 
663     // The number of tokens burned.
664     uint256 private _burnCounter;
665 
666     // Token name
667     string private _name;
668 
669     // Token symbol
670     string private _symbol;
671 
672     // Mapping from token ID to ownership details
673     // An empty struct value does not necessarily mean the token is unowned.
674     // See `_packedOwnershipOf` implementation for details.
675     //
676     // Bits Layout:
677     // - [0..159]   `addr`
678     // - [160..223] `startTimestamp`
679     // - [224]      `burned`
680     // - [225]      `nextInitialized`
681     // - [232..255] `extraData`
682     mapping(uint256 => uint256) private _packedOwnerships;
683 
684     // Mapping owner address to address data.
685     //
686     // Bits Layout:
687     // - [0..63]    `balance`
688     // - [64..127]  `numberMinted`
689     // - [128..191] `numberBurned`
690     // - [192..255] `aux`
691     mapping(address => uint256) private _packedAddressData;
692 
693     // Mapping from token ID to approved address.
694     mapping(uint256 => address) private _tokenApprovals;
695 
696     // Mapping from owner to operator approvals
697     mapping(address => mapping(address => bool)) private _operatorApprovals;
698 
699     constructor(string memory name_, string memory symbol_) {
700         _name = name_;
701         _symbol = symbol_;
702         _currentIndex = _startTokenId();
703     }
704 
705     /**
706      * @dev Returns the starting token ID.
707      * To change the starting token ID, please override this function.
708      */
709     function _startTokenId() internal view virtual returns (uint256) {
710         return 0;
711     }
712 
713     /**
714      * @dev Returns the next token ID to be minted.
715      */
716     function _nextTokenId() internal view returns (uint256) {
717         return _currentIndex;
718     }
719 
720     /**
721      * @dev Returns the total number of tokens in existence.
722      * Burned tokens will reduce the count.
723      * To get the total number of tokens minted, please see `_totalMinted`.
724      */
725     function totalSupply() public view override returns (uint256) {
726         // Counter underflow is impossible as _burnCounter cannot be incremented
727         // more than `_currentIndex - _startTokenId()` times.
728         unchecked {
729             return _currentIndex - _burnCounter - _startTokenId();
730         }
731     }
732 
733     /**
734      * @dev Returns the total amount of tokens minted in the contract.
735      */
736     function _totalMinted() internal view returns (uint256) {
737         // Counter underflow is impossible as _currentIndex does not decrement,
738         // and it is initialized to `_startTokenId()`
739         unchecked {
740             return _currentIndex - _startTokenId();
741         }
742     }
743 
744     /**
745      * @dev Returns the total number of tokens burned.
746      */
747     function _totalBurned() internal view returns (uint256) {
748         return _burnCounter;
749     }
750 
751     /**
752      * @dev See {IERC165-supportsInterface}.
753      */
754     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
755         // The interface IDs are constants representing the first 4 bytes of the XOR of
756         // all function selectors in the interface. See: https://eips.ethereum.org/EIPS/eip-165
757         // e.g. `bytes4(i.functionA.selector ^ i.functionB.selector ^ ...)`
758         return
759             interfaceId == 0x01ffc9a7 || // ERC165 interface ID for ERC165.
760             interfaceId == 0x80ac58cd || // ERC165 interface ID for ERC721.
761             interfaceId == 0x5b5e139f; // ERC165 interface ID for ERC721Metadata.
762     }
763 
764     /**
765      * @dev See {IERC721-balanceOf}.
766      */
767     function balanceOf(address owner) public view override returns (uint256) {
768         if (owner == address(0)) revert BalanceQueryForZeroAddress();
769         return _packedAddressData[owner] & BITMASK_ADDRESS_DATA_ENTRY;
770     }
771 
772     /**
773      * Returns the number of tokens minted by `owner`.
774      */
775     function _numberMinted(address owner) internal view returns (uint256) {
776         return (_packedAddressData[owner] >> BITPOS_NUMBER_MINTED) & BITMASK_ADDRESS_DATA_ENTRY;
777     }
778 
779     /**
780      * Returns the number of tokens burned by or on behalf of `owner`.
781      */
782     function _numberBurned(address owner) internal view returns (uint256) {
783         return (_packedAddressData[owner] >> BITPOS_NUMBER_BURNED) & BITMASK_ADDRESS_DATA_ENTRY;
784     }
785 
786     /**
787      * Returns the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
788      */
789     function _getAux(address owner) internal view returns (uint64) {
790         return uint64(_packedAddressData[owner] >> BITPOS_AUX);
791     }
792 
793     /**
794      * Sets the auxiliary data for `owner`. (e.g. number of whitelist mint slots used).
795      * If there are multiple variables, please pack them into a uint64.
796      */
797     function _setAux(address owner, uint64 aux) internal {
798         uint256 packed = _packedAddressData[owner];
799         uint256 auxCasted;
800         // Cast `aux` with assembly to avoid redundant masking.
801         assembly {
802             auxCasted := aux
803         }
804         packed = (packed & BITMASK_AUX_COMPLEMENT) | (auxCasted << BITPOS_AUX);
805         _packedAddressData[owner] = packed;
806     }
807 
808     /**
809      * Returns the packed ownership data of `tokenId`.
810      */
811     function _packedOwnershipOf(uint256 tokenId) private view returns (uint256) {
812         uint256 curr = tokenId;
813 
814         unchecked {
815             if (_startTokenId() <= curr)
816                 if (curr < _currentIndex) {
817                     uint256 packed = _packedOwnerships[curr];
818                     // If not burned.
819                     if (packed & BITMASK_BURNED == 0) {
820                         // Invariant:
821                         // There will always be an ownership that has an address and is not burned
822                         // before an ownership that does not have an address and is not burned.
823                         // Hence, curr will not underflow.
824                         //
825                         // We can directly compare the packed value.
826                         // If the address is zero, packed is zero.
827                         while (packed == 0) {
828                             packed = _packedOwnerships[--curr];
829                         }
830                         return packed;
831                     }
832                 }
833         }
834         revert OwnerQueryForNonexistentToken();
835     }
836 
837     /**
838      * Returns the unpacked `TokenOwnership` struct from `packed`.
839      */
840     function _unpackedOwnership(uint256 packed) private pure returns (TokenOwnership memory ownership) {
841         ownership.addr = address(uint160(packed));
842         ownership.startTimestamp = uint64(packed >> BITPOS_START_TIMESTAMP);
843         ownership.burned = packed & BITMASK_BURNED != 0;
844         ownership.extraData = uint24(packed >> BITPOS_EXTRA_DATA);
845     }
846 
847     /**
848      * Returns the unpacked `TokenOwnership` struct at `index`.
849      */
850     function _ownershipAt(uint256 index) internal view returns (TokenOwnership memory) {
851         return _unpackedOwnership(_packedOwnerships[index]);
852     }
853 
854     /**
855      * @dev Initializes the ownership slot minted at `index` for efficiency purposes.
856      */
857     function _initializeOwnershipAt(uint256 index) internal {
858         if (_packedOwnerships[index] == 0) {
859             _packedOwnerships[index] = _packedOwnershipOf(index);
860         }
861     }
862 
863     /**
864      * Gas spent here starts off proportional to the maximum mint batch size.
865      * It gradually moves to O(1) as tokens get transferred around in the collection over time.
866      */
867     function _ownershipOf(uint256 tokenId) internal view returns (TokenOwnership memory) {
868         return _unpackedOwnership(_packedOwnershipOf(tokenId));
869     }
870 
871     /**
872      * @dev Packs ownership data into a single uint256.
873      */
874     function _packOwnershipData(address owner, uint256 flags) private view returns (uint256 result) {
875         assembly {
876             // Mask `owner` to the lower 160 bits, in case the upper bits somehow aren't clean.
877             owner := and(owner, BITMASK_ADDRESS)
878             // `owner | (block.timestamp << BITPOS_START_TIMESTAMP) | flags`.
879             result := or(owner, or(shl(BITPOS_START_TIMESTAMP, timestamp()), flags))
880         }
881     }
882 
883     /**
884      * @dev See {IERC721-ownerOf}.
885      */
886     function ownerOf(uint256 tokenId) public view override returns (address) {
887         return address(uint160(_packedOwnershipOf(tokenId)));
888     }
889 
890     /**
891      * @dev See {IERC721Metadata-name}.
892      */
893     function name() public view virtual override returns (string memory) {
894         return _name;
895     }
896 
897     /**
898      * @dev See {IERC721Metadata-symbol}.
899      */
900     function symbol() public view virtual override returns (string memory) {
901         return _symbol;
902     }
903 
904     /**
905      * @dev See {IERC721Metadata-tokenURI}.
906      */
907     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
908         if (!_exists(tokenId)) revert URIQueryForNonexistentToken();
909 
910         string memory baseURI = _baseURI();
911         return bytes(baseURI).length != 0 ? string(abi.encodePacked(baseURI, _toString(tokenId))) : '';
912     }
913 
914     /**
915      * @dev Base URI for computing {tokenURI}. If set, the resulting URI for each
916      * token will be the concatenation of the `baseURI` and the `tokenId`. Empty
917      * by default, it can be overridden in child contracts.
918      */
919     function _baseURI() internal view virtual returns (string memory) {
920         return '';
921     }
922 
923     /**
924      * @dev Returns the `nextInitialized` flag set if `quantity` equals 1.
925      */
926     function _nextInitializedFlag(uint256 quantity) private pure returns (uint256 result) {
927         // For branchless setting of the `nextInitialized` flag.
928         assembly {
929             // `(quantity == 1) << BITPOS_NEXT_INITIALIZED`.
930             result := shl(BITPOS_NEXT_INITIALIZED, eq(quantity, 1))
931         }
932     }
933 
934     /**
935      * @dev See {IERC721-approve}.
936      */
937     function approve(address to, uint256 tokenId) public override {
938         address owner = ownerOf(tokenId);
939 
940         if (_msgSenderERC721A() != owner)
941             if (!isApprovedForAll(owner, _msgSenderERC721A())) {
942                 revert ApprovalCallerNotOwnerNorApproved();
943             }
944 
945         _tokenApprovals[tokenId] = to;
946         emit Approval(owner, to, tokenId);
947     }
948 
949     /**
950      * @dev See {IERC721-getApproved}.
951      */
952     function getApproved(uint256 tokenId) public view override returns (address) {
953         if (!_exists(tokenId)) revert ApprovalQueryForNonexistentToken();
954 
955         return _tokenApprovals[tokenId];
956     }
957 
958     /**
959      * @dev See {IERC721-setApprovalForAll}.
960      */
961     function setApprovalForAll(address operator, bool approved) public virtual override {
962         if (operator == _msgSenderERC721A()) revert ApproveToCaller();
963 
964         _operatorApprovals[_msgSenderERC721A()][operator] = approved;
965         emit ApprovalForAll(_msgSenderERC721A(), operator, approved);
966     }
967 
968     /**
969      * @dev See {IERC721-isApprovedForAll}.
970      */
971     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
972         return _operatorApprovals[owner][operator];
973     }
974 
975     /**
976      * @dev See {IERC721-safeTransferFrom}.
977      */
978     function safeTransferFrom(
979         address from,
980         address to,
981         uint256 tokenId
982     ) public virtual override {
983         safeTransferFrom(from, to, tokenId, '');
984     }
985 
986     /**
987      * @dev See {IERC721-safeTransferFrom}.
988      */
989     function safeTransferFrom(
990         address from,
991         address to,
992         uint256 tokenId,
993         bytes memory _data
994     ) public virtual override {
995         transferFrom(from, to, tokenId);
996         if (to.code.length != 0)
997             if (!_checkContractOnERC721Received(from, to, tokenId, _data)) {
998                 revert TransferToNonERC721ReceiverImplementer();
999             }
1000     }
1001 
1002     /**
1003      * @dev Returns whether `tokenId` exists.
1004      *
1005      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1006      *
1007      * Tokens start existing when they are minted (`_mint`),
1008      */
1009     function _exists(uint256 tokenId) internal view returns (bool) {
1010         return
1011             _startTokenId() <= tokenId &&
1012             tokenId < _currentIndex && // If within bounds,
1013             _packedOwnerships[tokenId] & BITMASK_BURNED == 0; // and not burned.
1014     }
1015 
1016     /**
1017      * @dev Equivalent to `_safeMint(to, quantity, '')`.
1018      */
1019     function _safeMint(address to, uint256 quantity) internal {
1020         _safeMint(to, quantity, '');
1021     }
1022 
1023     /**
1024      * @dev Safely mints `quantity` tokens and transfers them to `to`.
1025      *
1026      * Requirements:
1027      *
1028      * - If `to` refers to a smart contract, it must implement
1029      *   {IERC721Receiver-onERC721Received}, which is called for each safe transfer.
1030      * - `quantity` must be greater than 0.
1031      *
1032      * See {_mint}.
1033      *
1034      * Emits a {Transfer} event for each mint.
1035      */
1036     function _safeMint(
1037         address to,
1038         uint256 quantity,
1039         bytes memory _data
1040     ) internal {
1041         _mint(to, quantity);
1042 
1043         unchecked {
1044             if (to.code.length != 0) {
1045                 uint256 end = _currentIndex;
1046                 uint256 index = end - quantity;
1047                 do {
1048                     if (!_checkContractOnERC721Received(address(0), to, index++, _data)) {
1049                         revert TransferToNonERC721ReceiverImplementer();
1050                     }
1051                 } while (index < end);
1052                 // Reentrancy protection.
1053                 if (_currentIndex != end) revert();
1054             }
1055         }
1056     }
1057 
1058     /**
1059      * @dev Mints `quantity` tokens and transfers them to `to`.
1060      *
1061      * Requirements:
1062      *
1063      * - `to` cannot be the zero address.
1064      * - `quantity` must be greater than 0.
1065      *
1066      * Emits a {Transfer} event for each mint.
1067      */
1068     function _mint(address to, uint256 quantity) internal {
1069         uint256 startTokenId = _currentIndex;
1070         if (to == address(0)) revert MintToZeroAddress();
1071         if (quantity == 0) revert MintZeroQuantity();
1072 
1073         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1074 
1075         // Overflows are incredibly unrealistic.
1076         // `balance` and `numberMinted` have a maximum limit of 2**64.
1077         // `tokenId` has a maximum limit of 2**256.
1078         unchecked {
1079             // Updates:
1080             // - `balance += quantity`.
1081             // - `numberMinted += quantity`.
1082             //
1083             // We can directly add to the `balance` and `numberMinted`.
1084             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1085 
1086             // Updates:
1087             // - `address` to the owner.
1088             // - `startTimestamp` to the timestamp of minting.
1089             // - `burned` to `false`.
1090             // - `nextInitialized` to `quantity == 1`.
1091             _packedOwnerships[startTokenId] = _packOwnershipData(
1092                 to,
1093                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1094             );
1095 
1096             uint256 tokenId = startTokenId;
1097             uint256 end = startTokenId + quantity;
1098             do {
1099                 emit Transfer(address(0), to, tokenId++);
1100             } while (tokenId < end);
1101 
1102             _currentIndex = end;
1103         }
1104         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1105     }
1106 
1107     /**
1108      * @dev Mints `quantity` tokens and transfers them to `to`.
1109      *
1110      * This function is intended for efficient minting only during contract creation.
1111      *
1112      * It emits only one {ConsecutiveTransfer} as defined in
1113      * [ERC2309](https://eips.ethereum.org/EIPS/eip-2309),
1114      * instead of a sequence of {Transfer} event(s).
1115      *
1116      * Calling this function outside of contract creation WILL make your contract
1117      * non-compliant with the ERC721 standard.
1118      * For full ERC721 compliance, substituting ERC721 {Transfer} event(s) with the ERC2309
1119      * {ConsecutiveTransfer} event is only permissible during contract creation.
1120      *
1121      * Requirements:
1122      *
1123      * - `to` cannot be the zero address.
1124      * - `quantity` must be greater than 0.
1125      *
1126      * Emits a {ConsecutiveTransfer} event.
1127      */
1128     function _mintERC2309(address to, uint256 quantity) internal {
1129         uint256 startTokenId = _currentIndex;
1130         if (to == address(0)) revert MintToZeroAddress();
1131         if (quantity == 0) revert MintZeroQuantity();
1132         if (quantity > MAX_MINT_ERC2309_QUANTITY_LIMIT) revert MintERC2309QuantityExceedsLimit();
1133 
1134         _beforeTokenTransfers(address(0), to, startTokenId, quantity);
1135 
1136         // Overflows are unrealistic due to the above check for `quantity` to be below the limit.
1137         unchecked {
1138             // Updates:
1139             // - `balance += quantity`.
1140             // - `numberMinted += quantity`.
1141             //
1142             // We can directly add to the `balance` and `numberMinted`.
1143             _packedAddressData[to] += quantity * ((1 << BITPOS_NUMBER_MINTED) | 1);
1144 
1145             // Updates:
1146             // - `address` to the owner.
1147             // - `startTimestamp` to the timestamp of minting.
1148             // - `burned` to `false`.
1149             // - `nextInitialized` to `quantity == 1`.
1150             _packedOwnerships[startTokenId] = _packOwnershipData(
1151                 to,
1152                 _nextInitializedFlag(quantity) | _nextExtraData(address(0), to, 0)
1153             );
1154 
1155             emit ConsecutiveTransfer(startTokenId, startTokenId + quantity - 1, address(0), to);
1156 
1157             _currentIndex = startTokenId + quantity;
1158         }
1159         _afterTokenTransfers(address(0), to, startTokenId, quantity);
1160     }
1161 
1162     /**
1163      * @dev Returns the storage slot and value for the approved address of `tokenId`.
1164      */
1165     function _getApprovedAddress(uint256 tokenId)
1166         private
1167         view
1168         returns (uint256 approvedAddressSlot, address approvedAddress)
1169     {
1170         mapping(uint256 => address) storage tokenApprovalsPtr = _tokenApprovals;
1171         // The following is equivalent to `approvedAddress = _tokenApprovals[tokenId]`.
1172         assembly {
1173             // Compute the slot.
1174             mstore(0x00, tokenId)
1175             mstore(0x20, tokenApprovalsPtr.slot)
1176             approvedAddressSlot := keccak256(0x00, 0x40)
1177             // Load the slot's value from storage.
1178             approvedAddress := sload(approvedAddressSlot)
1179         }
1180     }
1181 
1182     /**
1183      * @dev Returns whether the `approvedAddress` is equals to `from` or `msgSender`.
1184      */
1185     function _isOwnerOrApproved(
1186         address approvedAddress,
1187         address from,
1188         address msgSender
1189     ) private pure returns (bool result) {
1190         assembly {
1191             // Mask `from` to the lower 160 bits, in case the upper bits somehow aren't clean.
1192             from := and(from, BITMASK_ADDRESS)
1193             // Mask `msgSender` to the lower 160 bits, in case the upper bits somehow aren't clean.
1194             msgSender := and(msgSender, BITMASK_ADDRESS)
1195             // `msgSender == from || msgSender == approvedAddress`.
1196             result := or(eq(msgSender, from), eq(msgSender, approvedAddress))
1197         }
1198     }
1199 
1200     /**
1201      * @dev Transfers `tokenId` from `from` to `to`.
1202      *
1203      * Requirements:
1204      *
1205      * - `to` cannot be the zero address.
1206      * - `tokenId` token must be owned by `from`.
1207      *
1208      * Emits a {Transfer} event.
1209      */
1210     function transferFrom(
1211         address from,
1212         address to,
1213         uint256 tokenId
1214     ) public virtual override {
1215         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1216 
1217         if (address(uint160(prevOwnershipPacked)) != from) revert TransferFromIncorrectOwner();
1218 
1219         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1220 
1221         // The nested ifs save around 20+ gas over a compound boolean condition.
1222         if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1223             if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1224 
1225         if (to == address(0)) revert TransferToZeroAddress();
1226 
1227         _beforeTokenTransfers(from, to, tokenId, 1);
1228 
1229         // Clear approvals from the previous owner.
1230         assembly {
1231             if approvedAddress {
1232                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1233                 sstore(approvedAddressSlot, 0)
1234             }
1235         }
1236 
1237         // Underflow of the sender's balance is impossible because we check for
1238         // ownership above and the recipient's balance can't realistically overflow.
1239         // Counter overflow is incredibly unrealistic as tokenId would have to be 2**256.
1240         unchecked {
1241             // We can directly increment and decrement the balances.
1242             --_packedAddressData[from]; // Updates: `balance -= 1`.
1243             ++_packedAddressData[to]; // Updates: `balance += 1`.
1244 
1245             // Updates:
1246             // - `address` to the next owner.
1247             // - `startTimestamp` to the timestamp of transfering.
1248             // - `burned` to `false`.
1249             // - `nextInitialized` to `true`.
1250             _packedOwnerships[tokenId] = _packOwnershipData(
1251                 to,
1252                 BITMASK_NEXT_INITIALIZED | _nextExtraData(from, to, prevOwnershipPacked)
1253             );
1254 
1255             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1256             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1257                 uint256 nextTokenId = tokenId + 1;
1258                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1259                 if (_packedOwnerships[nextTokenId] == 0) {
1260                     // If the next slot is within bounds.
1261                     if (nextTokenId != _currentIndex) {
1262                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1263                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1264                     }
1265                 }
1266             }
1267         }
1268 
1269         emit Transfer(from, to, tokenId);
1270         _afterTokenTransfers(from, to, tokenId, 1);
1271     }
1272 
1273     /**
1274      * @dev Equivalent to `_burn(tokenId, false)`.
1275      */
1276     function _burn(uint256 tokenId) internal virtual {
1277         _burn(tokenId, false);
1278     }
1279 
1280     /**
1281      * @dev Destroys `tokenId`.
1282      * The approval is cleared when the token is burned.
1283      *
1284      * Requirements:
1285      *
1286      * - `tokenId` must exist.
1287      *
1288      * Emits a {Transfer} event.
1289      */
1290     function _burn(uint256 tokenId, bool approvalCheck) internal virtual {
1291         uint256 prevOwnershipPacked = _packedOwnershipOf(tokenId);
1292 
1293         address from = address(uint160(prevOwnershipPacked));
1294 
1295         (uint256 approvedAddressSlot, address approvedAddress) = _getApprovedAddress(tokenId);
1296 
1297         if (approvalCheck) {
1298             // The nested ifs save around 20+ gas over a compound boolean condition.
1299             if (!_isOwnerOrApproved(approvedAddress, from, _msgSenderERC721A()))
1300                 if (!isApprovedForAll(from, _msgSenderERC721A())) revert TransferCallerNotOwnerNorApproved();
1301         }
1302 
1303         _beforeTokenTransfers(from, address(0), tokenId, 1);
1304 
1305         // Clear approvals from the previous owner.
1306         assembly {
1307             if approvedAddress {
1308                 // This is equivalent to `delete _tokenApprovals[tokenId]`.
1309                 sstore(approvedAddressSlot, 0)
1310             }
1311         }
1312 
1313         // Underflow of the sender's balance is impossible because we check for
1314         // ownership above and the recipient's balance can't realistically overflow.
1315         // Counter overflow is incredibly unrealistic as `tokenId` would have to be 2**256.
1316         unchecked {
1317             // Updates:
1318             // - `balance -= 1`.
1319             // - `numberBurned += 1`.
1320             //
1321             // We can directly decrement the balance, and increment the number burned.
1322             // This is equivalent to `packed -= 1; packed += 1 << BITPOS_NUMBER_BURNED;`.
1323             _packedAddressData[from] += (1 << BITPOS_NUMBER_BURNED) - 1;
1324 
1325             // Updates:
1326             // - `address` to the last owner.
1327             // - `startTimestamp` to the timestamp of burning.
1328             // - `burned` to `true`.
1329             // - `nextInitialized` to `true`.
1330             _packedOwnerships[tokenId] = _packOwnershipData(
1331                 from,
1332                 (BITMASK_BURNED | BITMASK_NEXT_INITIALIZED) | _nextExtraData(from, address(0), prevOwnershipPacked)
1333             );
1334 
1335             // If the next slot may not have been initialized (i.e. `nextInitialized == false`) .
1336             if (prevOwnershipPacked & BITMASK_NEXT_INITIALIZED == 0) {
1337                 uint256 nextTokenId = tokenId + 1;
1338                 // If the next slot's address is zero and not burned (i.e. packed value is zero).
1339                 if (_packedOwnerships[nextTokenId] == 0) {
1340                     // If the next slot is within bounds.
1341                     if (nextTokenId != _currentIndex) {
1342                         // Initialize the next slot to maintain correctness for `ownerOf(tokenId + 1)`.
1343                         _packedOwnerships[nextTokenId] = prevOwnershipPacked;
1344                     }
1345                 }
1346             }
1347         }
1348 
1349         emit Transfer(from, address(0), tokenId);
1350         _afterTokenTransfers(from, address(0), tokenId, 1);
1351 
1352         // Overflow not possible, as _burnCounter cannot be exceed _currentIndex times.
1353         unchecked {
1354             _burnCounter++;
1355         }
1356     }
1357 
1358     /**
1359      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target contract.
1360      *
1361      * @param from address representing the previous owner of the given token ID
1362      * @param to target address that will receive the tokens
1363      * @param tokenId uint256 ID of the token to be transferred
1364      * @param _data bytes optional data to send along with the call
1365      * @return bool whether the call correctly returned the expected magic value
1366      */
1367     function _checkContractOnERC721Received(
1368         address from,
1369         address to,
1370         uint256 tokenId,
1371         bytes memory _data
1372     ) private returns (bool) {
1373         try ERC721A__IERC721Receiver(to).onERC721Received(_msgSenderERC721A(), from, tokenId, _data) returns (
1374             bytes4 retval
1375         ) {
1376             return retval == ERC721A__IERC721Receiver(to).onERC721Received.selector;
1377         } catch (bytes memory reason) {
1378             if (reason.length == 0) {
1379                 revert TransferToNonERC721ReceiverImplementer();
1380             } else {
1381                 assembly {
1382                     revert(add(32, reason), mload(reason))
1383                 }
1384             }
1385         }
1386     }
1387 
1388     /**
1389      * @dev Directly sets the extra data for the ownership data `index`.
1390      */
1391     function _setExtraDataAt(uint256 index, uint24 extraData) internal {
1392         uint256 packed = _packedOwnerships[index];
1393         if (packed == 0) revert OwnershipNotInitializedForExtraData();
1394         uint256 extraDataCasted;
1395         // Cast `extraData` with assembly to avoid redundant masking.
1396         assembly {
1397             extraDataCasted := extraData
1398         }
1399         packed = (packed & BITMASK_EXTRA_DATA_COMPLEMENT) | (extraDataCasted << BITPOS_EXTRA_DATA);
1400         _packedOwnerships[index] = packed;
1401     }
1402 
1403     /**
1404      * @dev Returns the next extra data for the packed ownership data.
1405      * The returned result is shifted into position.
1406      */
1407     function _nextExtraData(
1408         address from,
1409         address to,
1410         uint256 prevOwnershipPacked
1411     ) private view returns (uint256) {
1412         uint24 extraData = uint24(prevOwnershipPacked >> BITPOS_EXTRA_DATA);
1413         return uint256(_extraData(from, to, extraData)) << BITPOS_EXTRA_DATA;
1414     }
1415 
1416     /**
1417      * @dev Called during each token transfer to set the 24bit `extraData` field.
1418      * Intended to be overridden by the cosumer contract.
1419      *
1420      * `previousExtraData` - the value of `extraData` before transfer.
1421      *
1422      * Calling conditions:
1423      *
1424      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1425      * transferred to `to`.
1426      * - When `from` is zero, `tokenId` will be minted for `to`.
1427      * - When `to` is zero, `tokenId` will be burned by `from`.
1428      * - `from` and `to` are never both zero.
1429      */
1430     function _extraData(
1431         address from,
1432         address to,
1433         uint24 previousExtraData
1434     ) internal view virtual returns (uint24) {}
1435 
1436     /**
1437      * @dev Hook that is called before a set of serially-ordered token ids are about to be transferred.
1438      * This includes minting.
1439      * And also called before burning one token.
1440      *
1441      * startTokenId - the first token id to be transferred
1442      * quantity - the amount to be transferred
1443      *
1444      * Calling conditions:
1445      *
1446      * - When `from` and `to` are both non-zero, `from`'s `tokenId` will be
1447      * transferred to `to`.
1448      * - When `from` is zero, `tokenId` will be minted for `to`.
1449      * - When `to` is zero, `tokenId` will be burned by `from`.
1450      * - `from` and `to` are never both zero.
1451      */
1452     function _beforeTokenTransfers(
1453         address from,
1454         address to,
1455         uint256 startTokenId,
1456         uint256 quantity
1457     ) internal virtual {}
1458 
1459     /**
1460      * @dev Hook that is called after a set of serially-ordered token ids have been transferred.
1461      * This includes minting.
1462      * And also called after one token has been burned.
1463      *
1464      * startTokenId - the first token id to be transferred
1465      * quantity - the amount to be transferred
1466      *
1467      * Calling conditions:
1468      *
1469      * - When `from` and `to` are both non-zero, `from`'s `tokenId` has been
1470      * transferred to `to`.
1471      * - When `from` is zero, `tokenId` has been minted for `to`.
1472      * - When `to` is zero, `tokenId` has been burned by `from`.
1473      * - `from` and `to` are never both zero.
1474      */
1475     function _afterTokenTransfers(
1476         address from,
1477         address to,
1478         uint256 startTokenId,
1479         uint256 quantity
1480     ) internal virtual {}
1481 
1482     /**
1483      * @dev Returns the message sender (defaults to `msg.sender`).
1484      *
1485      * If you are writing GSN compatible contracts, you need to override this function.
1486      */
1487     function _msgSenderERC721A() internal view virtual returns (address) {
1488         return msg.sender;
1489     }
1490 
1491     /**
1492      * @dev Converts a `uint256` to its ASCII `string` decimal representation.
1493      */
1494     function _toString(uint256 value) internal pure returns (string memory ptr) {
1495         assembly {
1496             // The maximum value of a uint256 contains 78 digits (1 byte per digit),
1497             // but we allocate 128 bytes to keep the free memory pointer 32-byte word aliged.
1498             // We will need 1 32-byte word to store the length,
1499             // and 3 32-byte words to store a maximum of 78 digits. Total: 32 + 3 * 32 = 128.
1500             ptr := add(mload(0x40), 128)
1501             // Update the free memory pointer to allocate.
1502             mstore(0x40, ptr)
1503 
1504             // Cache the end of the memory to calculate the length later.
1505             let end := ptr
1506 
1507             // We write the string from the rightmost digit to the leftmost digit.
1508             // The following is essentially a do-while loop that also handles the zero case.
1509             // Costs a bit more than early returning for the zero case,
1510             // but cheaper in terms of deployment and overall runtime costs.
1511             for {
1512                 // Initialize and perform the first pass without check.
1513                 let temp := value
1514                 // Move the pointer 1 byte leftwards to point to an empty character slot.
1515                 ptr := sub(ptr, 1)
1516                 // Write the character to the pointer. 48 is the ASCII index of '0'.
1517                 mstore8(ptr, add(48, mod(temp, 10)))
1518                 temp := div(temp, 10)
1519             } temp {
1520                 // Keep dividing `temp` until zero.
1521                 temp := div(temp, 10)
1522             } {
1523                 // Body of the for loop.
1524                 ptr := sub(ptr, 1)
1525                 mstore8(ptr, add(48, mod(temp, 10)))
1526             }
1527 
1528             let length := sub(end, ptr)
1529             // Move the pointer 32 bytes leftwards to make room for the length.
1530             ptr := sub(ptr, 32)
1531             // Store the length.
1532             mstore(ptr, length)
1533         }
1534     }
1535 }
1536 
1537 // File: erc721a/contracts/extensions/IERC721AQueryable.sol
1538 
1539 
1540 // ERC721A Contracts v4.1.0
1541 // Creator: Chiru Labs
1542 
1543 pragma solidity ^0.8.4;
1544 
1545 
1546 /**
1547  * @dev Interface of an ERC721AQueryable compliant contract.
1548  */
1549 interface IERC721AQueryable is IERC721A {
1550     /**
1551      * Invalid query range (`start` >= `stop`).
1552      */
1553     error InvalidQueryRange();
1554 
1555     /**
1556      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1557      *
1558      * If the `tokenId` is out of bounds:
1559      *   - `addr` = `address(0)`
1560      *   - `startTimestamp` = `0`
1561      *   - `burned` = `false`
1562      *
1563      * If the `tokenId` is burned:
1564      *   - `addr` = `<Address of owner before token was burned>`
1565      *   - `startTimestamp` = `<Timestamp when token was burned>`
1566      *   - `burned = `true`
1567      *
1568      * Otherwise:
1569      *   - `addr` = `<Address of owner>`
1570      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1571      *   - `burned = `false`
1572      */
1573     function explicitOwnershipOf(uint256 tokenId) external view returns (TokenOwnership memory);
1574 
1575     /**
1576      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1577      * See {ERC721AQueryable-explicitOwnershipOf}
1578      */
1579     function explicitOwnershipsOf(uint256[] memory tokenIds) external view returns (TokenOwnership[] memory);
1580 
1581     /**
1582      * @dev Returns an array of token IDs owned by `owner`,
1583      * in the range [`start`, `stop`)
1584      * (i.e. `start <= tokenId < stop`).
1585      *
1586      * This function allows for tokens to be queried if the collection
1587      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1588      *
1589      * Requirements:
1590      *
1591      * - `start` < `stop`
1592      */
1593     function tokensOfOwnerIn(
1594         address owner,
1595         uint256 start,
1596         uint256 stop
1597     ) external view returns (uint256[] memory);
1598 
1599     /**
1600      * @dev Returns an array of token IDs owned by `owner`.
1601      *
1602      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1603      * It is meant to be called off-chain.
1604      *
1605      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1606      * multiple smaller scans if the collection is large enough to cause
1607      * an out-of-gas error (10K pfp collections should be fine).
1608      */
1609     function tokensOfOwner(address owner) external view returns (uint256[] memory);
1610 }
1611 
1612 // File: erc721a/contracts/extensions/ERC721AQueryable.sol
1613 
1614 
1615 // ERC721A Contracts v4.1.0
1616 // Creator: Chiru Labs
1617 
1618 pragma solidity ^0.8.4;
1619 
1620 
1621 
1622 /**
1623  * @title ERC721A Queryable
1624  * @dev ERC721A subclass with convenience query functions.
1625  */
1626 abstract contract ERC721AQueryable is ERC721A, IERC721AQueryable {
1627     /**
1628      * @dev Returns the `TokenOwnership` struct at `tokenId` without reverting.
1629      *
1630      * If the `tokenId` is out of bounds:
1631      *   - `addr` = `address(0)`
1632      *   - `startTimestamp` = `0`
1633      *   - `burned` = `false`
1634      *   - `extraData` = `0`
1635      *
1636      * If the `tokenId` is burned:
1637      *   - `addr` = `<Address of owner before token was burned>`
1638      *   - `startTimestamp` = `<Timestamp when token was burned>`
1639      *   - `burned = `true`
1640      *   - `extraData` = `<Extra data when token was burned>`
1641      *
1642      * Otherwise:
1643      *   - `addr` = `<Address of owner>`
1644      *   - `startTimestamp` = `<Timestamp of start of ownership>`
1645      *   - `burned = `false`
1646      *   - `extraData` = `<Extra data at start of ownership>`
1647      */
1648     function explicitOwnershipOf(uint256 tokenId) public view override returns (TokenOwnership memory) {
1649         TokenOwnership memory ownership;
1650         if (tokenId < _startTokenId() || tokenId >= _nextTokenId()) {
1651             return ownership;
1652         }
1653         ownership = _ownershipAt(tokenId);
1654         if (ownership.burned) {
1655             return ownership;
1656         }
1657         return _ownershipOf(tokenId);
1658     }
1659 
1660     /**
1661      * @dev Returns an array of `TokenOwnership` structs at `tokenIds` in order.
1662      * See {ERC721AQueryable-explicitOwnershipOf}
1663      */
1664     function explicitOwnershipsOf(uint256[] memory tokenIds) external view override returns (TokenOwnership[] memory) {
1665         unchecked {
1666             uint256 tokenIdsLength = tokenIds.length;
1667             TokenOwnership[] memory ownerships = new TokenOwnership[](tokenIdsLength);
1668             for (uint256 i; i != tokenIdsLength; ++i) {
1669                 ownerships[i] = explicitOwnershipOf(tokenIds[i]);
1670             }
1671             return ownerships;
1672         }
1673     }
1674 
1675     /**
1676      * @dev Returns an array of token IDs owned by `owner`,
1677      * in the range [`start`, `stop`)
1678      * (i.e. `start <= tokenId < stop`).
1679      *
1680      * This function allows for tokens to be queried if the collection
1681      * grows too big for a single call of {ERC721AQueryable-tokensOfOwner}.
1682      *
1683      * Requirements:
1684      *
1685      * - `start` < `stop`
1686      */
1687     function tokensOfOwnerIn(
1688         address owner,
1689         uint256 start,
1690         uint256 stop
1691     ) external view override returns (uint256[] memory) {
1692         unchecked {
1693             if (start >= stop) revert InvalidQueryRange();
1694             uint256 tokenIdsIdx;
1695             uint256 stopLimit = _nextTokenId();
1696             // Set `start = max(start, _startTokenId())`.
1697             if (start < _startTokenId()) {
1698                 start = _startTokenId();
1699             }
1700             // Set `stop = min(stop, stopLimit)`.
1701             if (stop > stopLimit) {
1702                 stop = stopLimit;
1703             }
1704             uint256 tokenIdsMaxLength = balanceOf(owner);
1705             // Set `tokenIdsMaxLength = min(balanceOf(owner), stop - start)`,
1706             // to cater for cases where `balanceOf(owner)` is too big.
1707             if (start < stop) {
1708                 uint256 rangeLength = stop - start;
1709                 if (rangeLength < tokenIdsMaxLength) {
1710                     tokenIdsMaxLength = rangeLength;
1711                 }
1712             } else {
1713                 tokenIdsMaxLength = 0;
1714             }
1715             uint256[] memory tokenIds = new uint256[](tokenIdsMaxLength);
1716             if (tokenIdsMaxLength == 0) {
1717                 return tokenIds;
1718             }
1719             // We need to call `explicitOwnershipOf(start)`,
1720             // because the slot at `start` may not be initialized.
1721             TokenOwnership memory ownership = explicitOwnershipOf(start);
1722             address currOwnershipAddr;
1723             // If the starting slot exists (i.e. not burned), initialize `currOwnershipAddr`.
1724             // `ownership.address` will not be zero, as `start` is clamped to the valid token ID range.
1725             if (!ownership.burned) {
1726                 currOwnershipAddr = ownership.addr;
1727             }
1728             for (uint256 i = start; i != stop && tokenIdsIdx != tokenIdsMaxLength; ++i) {
1729                 ownership = _ownershipAt(i);
1730                 if (ownership.burned) {
1731                     continue;
1732                 }
1733                 if (ownership.addr != address(0)) {
1734                     currOwnershipAddr = ownership.addr;
1735                 }
1736                 if (currOwnershipAddr == owner) {
1737                     tokenIds[tokenIdsIdx++] = i;
1738                 }
1739             }
1740             // Downsize the array to fit.
1741             assembly {
1742                 mstore(tokenIds, tokenIdsIdx)
1743             }
1744             return tokenIds;
1745         }
1746     }
1747 
1748     /**
1749      * @dev Returns an array of token IDs owned by `owner`.
1750      *
1751      * This function scans the ownership mapping and is O(totalSupply) in complexity.
1752      * It is meant to be called off-chain.
1753      *
1754      * See {ERC721AQueryable-tokensOfOwnerIn} for splitting the scan into
1755      * multiple smaller scans if the collection is large enough to cause
1756      * an out-of-gas error (10K pfp collections should be fine).
1757      */
1758     function tokensOfOwner(address owner) external view override returns (uint256[] memory) {
1759         unchecked {
1760             uint256 tokenIdsIdx;
1761             address currOwnershipAddr;
1762             uint256 tokenIdsLength = balanceOf(owner);
1763             uint256[] memory tokenIds = new uint256[](tokenIdsLength);
1764             TokenOwnership memory ownership;
1765             for (uint256 i = _startTokenId(); tokenIdsIdx != tokenIdsLength; ++i) {
1766                 ownership = _ownershipAt(i);
1767                 if (ownership.burned) {
1768                     continue;
1769                 }
1770                 if (ownership.addr != address(0)) {
1771                     currOwnershipAddr = ownership.addr;
1772                 }
1773                 if (currOwnershipAddr == owner) {
1774                     tokenIds[tokenIdsIdx++] = i;
1775                 }
1776             }
1777             return tokenIds;
1778         }
1779     }
1780 }
1781 
1782 pragma solidity >=0.8.9 <0.9.0;
1783 
1784 contract Web3Spyders is ERC721AQueryable, Ownable, ReentrancyGuard {
1785     using Strings for uint256;
1786     uint256 public immutable spyderSupply = 500;
1787 	uint256 private immutable arachnyxMint = 5;
1788     uint256 public immutable spyderPerAddress = 2;
1789     uint256 public spyderCost = 0.01 ether;
1790     bool public paused = true;
1791 	string public uriPrefix = '';
1792     string public uriSuffix = '.json';
1793     string public spyderStuff = '';
1794 	
1795   constructor(string memory baseURI) ERC721A("Web3 Spyders", "SPYDR") {
1796       setUriPrefix(baseURI); 
1797       _safeMint(_msgSender(), arachnyxMint);
1798 
1799    }
1800 
1801   modifier callerIsUser() {
1802         require(tx.origin == msg.sender, "The caller is another contract");
1803         _;
1804     }
1805 
1806   function spyderMinted(address owner) public view returns (uint256) {
1807         return _numberMinted(owner);
1808     }
1809 
1810   /// 0.01 is the price, 500 supply and 5 minted for dev. 
1811   function mintSpyder(uint256 _amount) public payable nonReentrant callerIsUser{
1812         require(!paused, 'The contract is paused!');
1813         require(spyderMinted(msg.sender) + _amount <= spyderPerAddress, 'Spyder Limit Reached');
1814         require(totalSupply() + _amount <= (spyderSupply), 'Max supply exceeded!');
1815         require(_amount > 0 && _amount <= spyderPerAddress, 'Invalid mint amount!');
1816         require(msg.value >= spyderCost, 'Insufficient funds!');
1817     _safeMint(_msgSender(), _amount);
1818   }
1819 
1820   function tokenURI(uint256 _tokenId) public view virtual override returns (string memory) {
1821     require(_exists(_tokenId), 'ERC721Metadata: URI query for nonexistent token');
1822     string memory currentBaseURI = _baseURI();
1823     return bytes(currentBaseURI).length > 0
1824         ? string(abi.encodePacked(currentBaseURI, _tokenId.toString(), uriSuffix))
1825         : '';
1826   }
1827 
1828   function setPaused() public onlyOwner {
1829     paused = !paused;
1830   }
1831 
1832   function setSpyderCost(uint256 _spyderCost) public onlyOwner {
1833     spyderCost = _spyderCost;
1834   }
1835 
1836   function setUriPrefix(string memory _uriPrefix) public onlyOwner {
1837     uriPrefix = _uriPrefix;
1838   }
1839 
1840   function setUriSuffix(string memory _uriSuffix) public onlyOwner {
1841     uriSuffix = _uriSuffix;
1842   }
1843 
1844   function withdraw() external nonReentrant onlyOwner{
1845     payable(msg.sender).transfer(address(this).balance);
1846   }
1847 
1848   function _startTokenId() internal view virtual override returns (uint256) {
1849     return 1;
1850   }
1851 
1852   function _baseURI() internal view virtual override returns (string memory) {
1853     return uriPrefix;
1854   }
1855 
1856   ///Only spyder owners can write spyder stuff. This is free speech but please be respectful. Tell a joke or say anything. No time limit.
1857   function writeStuff(string memory newstuff) public {
1858     require(balanceOf(msg.sender) >= 1, 'You dont own any spyders');
1859     spyderStuff = newstuff;
1860   }
1861 }