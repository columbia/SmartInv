1 /**
2  ________  __    __  _______   ______   ______   __    __   ______          ______   __        _______   __    __   ______          ______  __      __  __       __         ______   __       __    __  _______  
3 |        \|  \  |  \|       \ |      \ /      \ |  \  |  \ /      \        /      \ |  \      |       \ |  \  |  \ /      \        /      \|  \    /  \|  \     /  \       /      \ |  \     |  \  |  \|       \ 
4 | $$$$$$$$| $$  | $$| $$$$$$$\ \$$$$$$|  $$$$$$\| $$  | $$|  $$$$$$\      |  $$$$$$\| $$      | $$$$$$$\| $$  | $$|  $$$$$$\      |  $$$$$$\\$$\  /  $$| $$\   /  $$      |  $$$$$$\| $$     | $$  | $$| $$$$$$$\
5 | $$__    | $$  | $$| $$__| $$  | $$  | $$  | $$| $$  | $$| $$___\$$      | $$__| $$| $$      | $$__/ $$| $$__| $$| $$__| $$      | $$ __\$$ \$$\/  $$ | $$$\ /  $$$      | $$   \$$| $$     | $$  | $$| $$__/ $$
6 | $$  \   | $$  | $$| $$    $$  | $$  | $$  | $$| $$  | $$ \$$    \       | $$    $$| $$      | $$    $$| $$    $$| $$    $$      | $$|    \  \$$  $$  | $$$$\  $$$$      | $$      | $$     | $$  | $$| $$    $$
7 | $$$$$   | $$  | $$| $$$$$$$\  | $$  | $$  | $$| $$  | $$ _\$$$$$$\      | $$$$$$$$| $$      | $$$$$$$ | $$$$$$$$| $$$$$$$$      | $$ \$$$$   \$$$$   | $$\$$ $$ $$      | $$   __ | $$     | $$  | $$| $$$$$$$\
8 | $$      | $$__/ $$| $$  | $$ _| $$_ | $$__/ $$| $$__/ $$|  \__| $$      | $$  | $$| $$_____ | $$      | $$  | $$| $$  | $$      | $$__| $$   | $$    | $$ \$$$| $$      | $$__/  \| $$_____| $$__/ $$| $$__/ $$
9 | $$       \$$    $$| $$  | $$|   $$ \ \$$    $$ \$$    $$ \$$    $$      | $$  | $$| $$     \| $$      | $$  | $$| $$  | $$       \$$    $$   | $$    | $$  \$ | $$       \$$    $$| $$     \\$$    $$| $$    $$
10  \$$        \$$$$$$  \$$   \$$ \$$$$$$  \$$$$$$   \$$$$$$   \$$$$$$        \$$   \$$ \$$$$$$$$ \$$       \$$   \$$ \$$   \$$        \$$$$$$     \$$     \$$      \$$        \$$$$$$  \$$$$$$$$ \$$$$$$  \$$$$$$$ 
11                                                                                                                                                                                                                  
12                                                                                                                                                                                                                                                                                                                                                                                                                                 
13 */
14 
15 /**
16  *Submitted for verification at Etherscan.io on 2021-09-15
17  */
18 
19 // File: @openzeppelin/contracts/utils/Context.sol
20 
21 // SPDX-License-Identifier: MIT
22 
23 pragma solidity >=0.6.0 <0.8.0;
24 
25 /*
26  * @dev Provides information about the current execution context, including the
27  * sender of the transaction and its data. While these are generally available
28  * via msg.sender and msg.data, they should not be accessed in such a direct
29  * manner, since when dealing with GSN meta-transactions the account sending and
30  * paying for execution may not be the actual sender (as far as an application
31  * is concerned).
32  *
33  * This contract is only required for intermediate, library-like contracts.
34  */
35 abstract contract Context {
36     function _msgSender() internal view virtual returns (address payable) {
37         return msg.sender;
38     }
39 
40     function _msgData() internal view virtual returns (bytes memory) {
41         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
42         return msg.data;
43     }
44 }
45 
46 // File: @openzeppelin/contracts/introspection/IERC165.sol
47 
48 pragma solidity >=0.6.0 <0.8.0;
49 
50 /**
51  * @dev Interface of the ERC165 standard, as defined in the
52  * https://eips.ethereum.org/EIPS/eip-165[EIP].
53  *
54  * Implementers can declare support of contract interfaces, which can then be
55  * queried by others ({ERC165Checker}).
56  *
57  * For an implementation, see {ERC165}.
58  */
59 interface IERC165 {
60     /**
61      * @dev Returns true if this contract implements the interface defined by
62      * `interfaceId`. See the corresponding
63      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
64      * to learn more about how these ids are created.
65      *
66      * This function call must use less than 30 000 gas.
67      */
68     function supportsInterface(bytes4 interfaceId) external view returns (bool);
69 }
70 
71 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
72 
73 pragma solidity >=0.6.2 <0.8.0;
74 
75 /**
76  * @dev Required interface of an ERC721 compliant contract.
77  */
78 interface IERC721 is IERC165 {
79     /**
80      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
81      */
82     event Transfer(
83         address indexed from,
84         address indexed to,
85         uint256 indexed tokenId
86     );
87 
88     /**
89      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
90      */
91     event Approval(
92         address indexed owner,
93         address indexed approved,
94         uint256 indexed tokenId
95     );
96 
97     /**
98      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
99      */
100     event ApprovalForAll(
101         address indexed owner,
102         address indexed operator,
103         bool approved
104     );
105 
106     /**
107      * @dev Returns the number of tokens in ``owner``'s account.
108      */
109     function balanceOf(address owner) external view returns (uint256 balance);
110 
111     /**
112      * @dev Returns the owner of the `tokenId` token.
113      *
114      * Requirements:
115      *
116      * - `tokenId` must exist.
117      */
118     function ownerOf(uint256 tokenId) external view returns (address owner);
119 
120     /**
121      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
122      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
123      *
124      * Requirements:
125      *
126      * - `from` cannot be the zero address.
127      * - `to` cannot be the zero address.
128      * - `tokenId` token must exist and be owned by `from`.
129      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
130      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
131      *
132      * Emits a {Transfer} event.
133      */
134     function safeTransferFrom(
135         address from,
136         address to,
137         uint256 tokenId
138     ) external;
139 
140     /**
141      * @dev Transfers `tokenId` token from `from` to `to`.
142      *
143      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
144      *
145      * Requirements:
146      *
147      * - `from` cannot be the zero address.
148      * - `to` cannot be the zero address.
149      * - `tokenId` token must be owned by `from`.
150      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
151      *
152      * Emits a {Transfer} event.
153      */
154     function transferFrom(
155         address from,
156         address to,
157         uint256 tokenId
158     ) external;
159 
160     /**
161      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
162      * The approval is cleared when the token is transferred.
163      *
164      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
165      *
166      * Requirements:
167      *
168      * - The caller must own the token or be an approved operator.
169      * - `tokenId` must exist.
170      *
171      * Emits an {Approval} event.
172      */
173     function approve(address to, uint256 tokenId) external;
174 
175     /**
176      * @dev Returns the account approved for `tokenId` token.
177      *
178      * Requirements:
179      *
180      * - `tokenId` must exist.
181      */
182     function getApproved(uint256 tokenId)
183         external
184         view
185         returns (address operator);
186 
187     /**
188      * @dev Approve or remove `operator` as an operator for the caller.
189      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
190      *
191      * Requirements:
192      *
193      * - The `operator` cannot be the caller.
194      *
195      * Emits an {ApprovalForAll} event.
196      */
197     function setApprovalForAll(address operator, bool _approved) external;
198 
199     /**
200      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
201      *
202      * See {setApprovalForAll}
203      */
204     function isApprovedForAll(address owner, address operator)
205         external
206         view
207         returns (bool);
208 
209     /**
210      * @dev Safely transfers `tokenId` token from `from` to `to`.
211      *
212      * Requirements:
213      *
214      * - `from` cannot be the zero address.
215      * - `to` cannot be the zero address.
216      * - `tokenId` token must exist and be owned by `from`.
217      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
218      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
219      *
220      * Emits a {Transfer} event.
221      */
222     function safeTransferFrom(
223         address from,
224         address to,
225         uint256 tokenId,
226         bytes calldata data
227     ) external;
228 }
229 
230 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
231 
232 pragma solidity >=0.6.2 <0.8.0;
233 
234 /**
235  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
236  * @dev See https://eips.ethereum.org/EIPS/eip-721
237  */
238 interface IERC721Metadata is IERC721 {
239     /**
240      * @dev Returns the token collection name.
241      */
242     function name() external view returns (string memory);
243 
244     /**
245      * @dev Returns the token collection symbol.
246      */
247     function symbol() external view returns (string memory);
248 
249     /**
250      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
251      */
252     function tokenURI(uint256 tokenId) external view returns (string memory);
253 }
254 
255 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
256 
257 pragma solidity >=0.6.2 <0.8.0;
258 
259 /**
260  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
261  * @dev See https://eips.ethereum.org/EIPS/eip-721
262  */
263 interface IERC721Enumerable is IERC721 {
264     /**
265      * @dev Returns the total amount of tokens stored by the contract.
266      */
267     function totalSupply() external view returns (uint256);
268 
269     /**
270      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
271      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
272      */
273     function tokenOfOwnerByIndex(address owner, uint256 index)
274         external
275         view
276         returns (uint256 tokenId);
277 
278     /**
279      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
280      * Use along with {totalSupply} to enumerate all tokens.
281      */
282     function tokenByIndex(uint256 index) external view returns (uint256);
283 }
284 
285 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
286 
287 pragma solidity >=0.6.0 <0.8.0;
288 
289 /**
290  * @title ERC721 token receiver interface
291  * @dev Interface for any contract that wants to support safeTransfers
292  * from ERC721 asset contracts.
293  */
294 interface IERC721Receiver {
295     /**
296      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
297      * by `operator` from `from`, this function is called.
298      *
299      * It must return its Solidity selector to confirm the token transfer.
300      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
301      *
302      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
303      */
304     function onERC721Received(
305         address operator,
306         address from,
307         uint256 tokenId,
308         bytes calldata data
309     ) external returns (bytes4);
310 }
311 
312 // File: @openzeppelin/contracts/introspection/ERC165.sol
313 
314 pragma solidity >=0.6.0 <0.8.0;
315 
316 /**
317  * @dev Implementation of the {IERC165} interface.
318  *
319  * Contracts may inherit from this and call {_registerInterface} to declare
320  * their support of an interface.
321  */
322 abstract contract ERC165 is IERC165 {
323     /*
324      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
325      */
326     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
327 
328     /**
329      * @dev Mapping of interface ids to whether or not it's supported.
330      */
331     mapping(bytes4 => bool) private _supportedInterfaces;
332 
333     constructor() internal {
334         // Derived contracts need only register support for their own interfaces,
335         // we register support for ERC165 itself here
336         _registerInterface(_INTERFACE_ID_ERC165);
337     }
338 
339     /**
340      * @dev See {IERC165-supportsInterface}.
341      *
342      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
343      */
344     function supportsInterface(bytes4 interfaceId)
345         public
346         view
347         virtual
348         override
349         returns (bool)
350     {
351         return _supportedInterfaces[interfaceId];
352     }
353 
354     /**
355      * @dev Registers the contract as an implementer of the interface defined by
356      * `interfaceId`. Support of the actual ERC165 interface is automatic and
357      * registering its interface id is not required.
358      *
359      * See {IERC165-supportsInterface}.
360      *
361      * Requirements:
362      *
363      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
364      */
365     function _registerInterface(bytes4 interfaceId) internal virtual {
366         require(interfaceId != 0xffffffff, 'ERC165: invalid interface id');
367         _supportedInterfaces[interfaceId] = true;
368     }
369 }
370 
371 // File: @openzeppelin/contracts/math/SafeMath.sol
372 
373 pragma solidity >=0.6.0 <0.8.0;
374 
375 /**
376  * @dev Wrappers over Solidity's arithmetic operations with added overflow
377  * checks.
378  *
379  * Arithmetic operations in Solidity wrap on overflow. This can easily result
380  * in bugs, because programmers usually assume that an overflow raises an
381  * error, which is the standard behavior in high level programming languages.
382  * `SafeMath` restores this intuition by reverting the transaction when an
383  * operation overflows.
384  *
385  * Using this library instead of the unchecked operations eliminates an entire
386  * class of bugs, so it's recommended to use it always.
387  */
388 library SafeMath {
389     /**
390      * @dev Returns the addition of two unsigned integers, with an overflow flag.
391      *
392      * _Available since v3.4._
393      */
394     function tryAdd(uint256 a, uint256 b)
395         internal
396         pure
397         returns (bool, uint256)
398     {
399         uint256 c = a + b;
400         if (c < a) return (false, 0);
401         return (true, c);
402     }
403 
404     /**
405      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
406      *
407      * _Available since v3.4._
408      */
409     function trySub(uint256 a, uint256 b)
410         internal
411         pure
412         returns (bool, uint256)
413     {
414         if (b > a) return (false, 0);
415         return (true, a - b);
416     }
417 
418     /**
419      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
420      *
421      * _Available since v3.4._
422      */
423     function tryMul(uint256 a, uint256 b)
424         internal
425         pure
426         returns (bool, uint256)
427     {
428         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
429         // benefit is lost if 'b' is also tested.
430         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
431         if (a == 0) return (true, 0);
432         uint256 c = a * b;
433         if (c / a != b) return (false, 0);
434         return (true, c);
435     }
436 
437     /**
438      * @dev Returns the division of two unsigned integers, with a division by zero flag.
439      *
440      * _Available since v3.4._
441      */
442     function tryDiv(uint256 a, uint256 b)
443         internal
444         pure
445         returns (bool, uint256)
446     {
447         if (b == 0) return (false, 0);
448         return (true, a / b);
449     }
450 
451     /**
452      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
453      *
454      * _Available since v3.4._
455      */
456     function tryMod(uint256 a, uint256 b)
457         internal
458         pure
459         returns (bool, uint256)
460     {
461         if (b == 0) return (false, 0);
462         return (true, a % b);
463     }
464 
465     /**
466      * @dev Returns the addition of two unsigned integers, reverting on
467      * overflow.
468      *
469      * Counterpart to Solidity's `+` operator.
470      *
471      * Requirements:
472      *
473      * - Addition cannot overflow.
474      */
475     function add(uint256 a, uint256 b) internal pure returns (uint256) {
476         uint256 c = a + b;
477         require(c >= a, 'SafeMath: addition overflow');
478         return c;
479     }
480 
481     /**
482      * @dev Returns the subtraction of two unsigned integers, reverting on
483      * overflow (when the result is negative).
484      *
485      * Counterpart to Solidity's `-` operator.
486      *
487      * Requirements:
488      *
489      * - Subtraction cannot overflow.
490      */
491     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
492         require(b <= a, 'SafeMath: subtraction overflow');
493         return a - b;
494     }
495 
496     /**
497      * @dev Returns the multiplication of two unsigned integers, reverting on
498      * overflow.
499      *
500      * Counterpart to Solidity's `*` operator.
501      *
502      * Requirements:
503      *
504      * - Multiplication cannot overflow.
505      */
506     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
507         if (a == 0) return 0;
508         uint256 c = a * b;
509         require(c / a == b, 'SafeMath: multiplication overflow');
510         return c;
511     }
512 
513     /**
514      * @dev Returns the integer division of two unsigned integers, reverting on
515      * division by zero. The result is rounded towards zero.
516      *
517      * Counterpart to Solidity's `/` operator. Note: this function uses a
518      * `revert` opcode (which leaves remaining gas untouched) while Solidity
519      * uses an invalid opcode to revert (consuming all remaining gas).
520      *
521      * Requirements:
522      *
523      * - The divisor cannot be zero.
524      */
525     function div(uint256 a, uint256 b) internal pure returns (uint256) {
526         require(b > 0, 'SafeMath: division by zero');
527         return a / b;
528     }
529 
530     /**
531      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
532      * reverting when dividing by zero.
533      *
534      * Counterpart to Solidity's `%` operator. This function uses a `revert`
535      * opcode (which leaves remaining gas untouched) while Solidity uses an
536      * invalid opcode to revert (consuming all remaining gas).
537      *
538      * Requirements:
539      *
540      * - The divisor cannot be zero.
541      */
542     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
543         require(b > 0, 'SafeMath: modulo by zero');
544         return a % b;
545     }
546 
547     /**
548      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
549      * overflow (when the result is negative).
550      *
551      * CAUTION: This function is deprecated because it requires allocating memory for the error
552      * message unnecessarily. For custom revert reasons use {trySub}.
553      *
554      * Counterpart to Solidity's `-` operator.
555      *
556      * Requirements:
557      *
558      * - Subtraction cannot overflow.
559      */
560     function sub(
561         uint256 a,
562         uint256 b,
563         string memory errorMessage
564     ) internal pure returns (uint256) {
565         require(b <= a, errorMessage);
566         return a - b;
567     }
568 
569     /**
570      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
571      * division by zero. The result is rounded towards zero.
572      *
573      * CAUTION: This function is deprecated because it requires allocating memory for the error
574      * message unnecessarily. For custom revert reasons use {tryDiv}.
575      *
576      * Counterpart to Solidity's `/` operator. Note: this function uses a
577      * `revert` opcode (which leaves remaining gas untouched) while Solidity
578      * uses an invalid opcode to revert (consuming all remaining gas).
579      *
580      * Requirements:
581      *
582      * - The divisor cannot be zero.
583      */
584     function div(
585         uint256 a,
586         uint256 b,
587         string memory errorMessage
588     ) internal pure returns (uint256) {
589         require(b > 0, errorMessage);
590         return a / b;
591     }
592 
593     /**
594      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
595      * reverting with custom message when dividing by zero.
596      *
597      * CAUTION: This function is deprecated because it requires allocating memory for the error
598      * message unnecessarily. For custom revert reasons use {tryMod}.
599      *
600      * Counterpart to Solidity's `%` operator. This function uses a `revert`
601      * opcode (which leaves remaining gas untouched) while Solidity uses an
602      * invalid opcode to revert (consuming all remaining gas).
603      *
604      * Requirements:
605      *
606      * - The divisor cannot be zero.
607      */
608     function mod(
609         uint256 a,
610         uint256 b,
611         string memory errorMessage
612     ) internal pure returns (uint256) {
613         require(b > 0, errorMessage);
614         return a % b;
615     }
616 }
617 
618 // File: @openzeppelin/contracts/utils/Address.sol
619 
620 pragma solidity >=0.6.2 <0.8.0;
621 
622 /**
623  * @dev Collection of functions related to the address type
624  */
625 library Address {
626     /**
627      * @dev Returns true if `account` is a contract.
628      *
629      * [IMPORTANT]
630      * ====
631      * It is unsafe to assume that an address for which this function returns
632      * false is an externally-owned account (EOA) and not a contract.
633      *
634      * Among others, `isContract` will return false for the following
635      * types of addresses:
636      *
637      *  - an externally-owned account
638      *  - a contract in construction
639      *  - an address where a contract will be created
640      *  - an address where a contract lived, but was destroyed
641      * ====
642      */
643     function isContract(address account) internal view returns (bool) {
644         // This method relies on extcodesize, which returns 0 for contracts in
645         // construction, since the code is only stored at the end of the
646         // constructor execution.
647 
648         uint256 size;
649         // solhint-disable-next-line no-inline-assembly
650         assembly {
651             size := extcodesize(account)
652         }
653         return size > 0;
654     }
655 
656     /**
657      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
658      * `recipient`, forwarding all available gas and reverting on errors.
659      *
660      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
661      * of certain opcodes, possibly making contracts go over the 2300 gas limit
662      * imposed by `transfer`, making them unable to receive funds via
663      * `transfer`. {sendValue} removes this limitation.
664      *
665      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
666      *
667      * IMPORTANT: because control is transferred to `recipient`, care must be
668      * taken to not create reentrancy vulnerabilities. Consider using
669      * {ReentrancyGuard} or the
670      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
671      */
672     function sendValue(address payable recipient, uint256 amount) internal {
673         require(
674             address(this).balance >= amount,
675             'Address: insufficient balance'
676         );
677 
678         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
679         (bool success, ) = recipient.call{value: amount}('');
680         require(
681             success,
682             'Address: unable to send value, recipient may have reverted'
683         );
684     }
685 
686     /**
687      * @dev Performs a Solidity function call using a low level `call`. A
688      * plain`call` is an unsafe replacement for a function call: use this
689      * function instead.
690      *
691      * If `target` reverts with a revert reason, it is bubbled up by this
692      * function (like regular Solidity function calls).
693      *
694      * Returns the raw returned data. To convert to the expected return value,
695      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
696      *
697      * Requirements:
698      *
699      * - `target` must be a contract.
700      * - calling `target` with `data` must not revert.
701      *
702      * _Available since v3.1._
703      */
704     function functionCall(address target, bytes memory data)
705         internal
706         returns (bytes memory)
707     {
708         return functionCall(target, data, 'Address: low-level call failed');
709     }
710 
711     /**
712      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
713      * `errorMessage` as a fallback revert reason when `target` reverts.
714      *
715      * _Available since v3.1._
716      */
717     function functionCall(
718         address target,
719         bytes memory data,
720         string memory errorMessage
721     ) internal returns (bytes memory) {
722         return functionCallWithValue(target, data, 0, errorMessage);
723     }
724 
725     /**
726      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
727      * but also transferring `value` wei to `target`.
728      *
729      * Requirements:
730      *
731      * - the calling contract must have an ETH balance of at least `value`.
732      * - the called Solidity function must be `payable`.
733      *
734      * _Available since v3.1._
735      */
736     function functionCallWithValue(
737         address target,
738         bytes memory data,
739         uint256 value
740     ) internal returns (bytes memory) {
741         return
742             functionCallWithValue(
743                 target,
744                 data,
745                 value,
746                 'Address: low-level call with value failed'
747             );
748     }
749 
750     /**
751      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
752      * with `errorMessage` as a fallback revert reason when `target` reverts.
753      *
754      * _Available since v3.1._
755      */
756     function functionCallWithValue(
757         address target,
758         bytes memory data,
759         uint256 value,
760         string memory errorMessage
761     ) internal returns (bytes memory) {
762         require(
763             address(this).balance >= value,
764             'Address: insufficient balance for call'
765         );
766         require(isContract(target), 'Address: call to non-contract');
767 
768         // solhint-disable-next-line avoid-low-level-calls
769         (bool success, bytes memory returndata) = target.call{value: value}(
770             data
771         );
772         return _verifyCallResult(success, returndata, errorMessage);
773     }
774 
775     /**
776      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
777      * but performing a static call.
778      *
779      * _Available since v3.3._
780      */
781     function functionStaticCall(address target, bytes memory data)
782         internal
783         view
784         returns (bytes memory)
785     {
786         return
787             functionStaticCall(
788                 target,
789                 data,
790                 'Address: low-level static call failed'
791             );
792     }
793 
794     /**
795      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
796      * but performing a static call.
797      *
798      * _Available since v3.3._
799      */
800     function functionStaticCall(
801         address target,
802         bytes memory data,
803         string memory errorMessage
804     ) internal view returns (bytes memory) {
805         require(isContract(target), 'Address: static call to non-contract');
806 
807         // solhint-disable-next-line avoid-low-level-calls
808         (bool success, bytes memory returndata) = target.staticcall(data);
809         return _verifyCallResult(success, returndata, errorMessage);
810     }
811 
812     /**
813      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
814      * but performing a delegate call.
815      *
816      * _Available since v3.4._
817      */
818     function functionDelegateCall(address target, bytes memory data)
819         internal
820         returns (bytes memory)
821     {
822         return
823             functionDelegateCall(
824                 target,
825                 data,
826                 'Address: low-level delegate call failed'
827             );
828     }
829 
830     /**
831      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
832      * but performing a delegate call.
833      *
834      * _Available since v3.4._
835      */
836     function functionDelegateCall(
837         address target,
838         bytes memory data,
839         string memory errorMessage
840     ) internal returns (bytes memory) {
841         require(isContract(target), 'Address: delegate call to non-contract');
842 
843         // solhint-disable-next-line avoid-low-level-calls
844         (bool success, bytes memory returndata) = target.delegatecall(data);
845         return _verifyCallResult(success, returndata, errorMessage);
846     }
847 
848     function _verifyCallResult(
849         bool success,
850         bytes memory returndata,
851         string memory errorMessage
852     ) private pure returns (bytes memory) {
853         if (success) {
854             return returndata;
855         } else {
856             // Look for revert reason and bubble it up if present
857             if (returndata.length > 0) {
858                 // The easiest way to bubble the revert reason is using memory via assembly
859 
860                 // solhint-disable-next-line no-inline-assembly
861                 assembly {
862                     let returndata_size := mload(returndata)
863                     revert(add(32, returndata), returndata_size)
864                 }
865             } else {
866                 revert(errorMessage);
867             }
868         }
869     }
870 }
871 
872 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
873 
874 pragma solidity >=0.6.0 <0.8.0;
875 
876 /**
877  * @dev Library for managing
878  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
879  * types.
880  *
881  * Sets have the following properties:
882  *
883  * - Elements are added, removed, and checked for existence in constant time
884  * (O(1)).
885  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
886  *
887  * ```
888  * contract Example {
889  *     // Add the library methods
890  *     using EnumerableSet for EnumerableSet.AddressSet;
891  *
892  *     // Declare a set state variable
893  *     EnumerableSet.AddressSet private mySet;
894  * }
895  * ```
896  *
897  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
898  * and `uint256` (`UintSet`) are supported.
899  */
900 library EnumerableSet {
901     // To implement this library for multiple types with as little code
902     // repetition as possible, we write it in terms of a generic Set type with
903     // bytes32 values.
904     // The Set implementation uses private functions, and user-facing
905     // implementations (such as AddressSet) are just wrappers around the
906     // underlying Set.
907     // This means that we can only create new EnumerableSets for types that fit
908     // in bytes32.
909 
910     struct Set {
911         // Storage of set values
912         bytes32[] _values;
913         // Position of the value in the `values` array, plus 1 because index 0
914         // means a value is not in the set.
915         mapping(bytes32 => uint256) _indexes;
916     }
917 
918     /**
919      * @dev Add a value to a set. O(1).
920      *
921      * Returns true if the value was added to the set, that is if it was not
922      * already present.
923      */
924     function _add(Set storage set, bytes32 value) private returns (bool) {
925         if (!_contains(set, value)) {
926             set._values.push(value);
927             // The value is stored at length-1, but we add 1 to all indexes
928             // and use 0 as a sentinel value
929             set._indexes[value] = set._values.length;
930             return true;
931         } else {
932             return false;
933         }
934     }
935 
936     /**
937      * @dev Removes a value from a set. O(1).
938      *
939      * Returns true if the value was removed from the set, that is if it was
940      * present.
941      */
942     function _remove(Set storage set, bytes32 value) private returns (bool) {
943         // We read and store the value's index to prevent multiple reads from the same storage slot
944         uint256 valueIndex = set._indexes[value];
945 
946         if (valueIndex != 0) {
947             // Equivalent to contains(set, value)
948             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
949             // the array, and then remove the last element (sometimes called as 'swap and pop').
950             // This modifies the order of the array, as noted in {at}.
951 
952             uint256 toDeleteIndex = valueIndex - 1;
953             uint256 lastIndex = set._values.length - 1;
954 
955             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
956             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
957 
958             bytes32 lastvalue = set._values[lastIndex];
959 
960             // Move the last value to the index where the value to delete is
961             set._values[toDeleteIndex] = lastvalue;
962             // Update the index for the moved value
963             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
964 
965             // Delete the slot where the moved value was stored
966             set._values.pop();
967 
968             // Delete the index for the deleted slot
969             delete set._indexes[value];
970 
971             return true;
972         } else {
973             return false;
974         }
975     }
976 
977     /**
978      * @dev Returns true if the value is in the set. O(1).
979      */
980     function _contains(Set storage set, bytes32 value)
981         private
982         view
983         returns (bool)
984     {
985         return set._indexes[value] != 0;
986     }
987 
988     /**
989      * @dev Returns the number of values on the set. O(1).
990      */
991     function _length(Set storage set) private view returns (uint256) {
992         return set._values.length;
993     }
994 
995     /**
996      * @dev Returns the value stored at position `index` in the set. O(1).
997      *
998      * Note that there are no guarantees on the ordering of values inside the
999      * array, and it may change when more values are added or removed.
1000      *
1001      * Requirements:
1002      *
1003      * - `index` must be strictly less than {length}.
1004      */
1005     function _at(Set storage set, uint256 index)
1006         private
1007         view
1008         returns (bytes32)
1009     {
1010         require(
1011             set._values.length > index,
1012             'EnumerableSet: index out of bounds'
1013         );
1014         return set._values[index];
1015     }
1016 
1017     // Bytes32Set
1018 
1019     struct Bytes32Set {
1020         Set _inner;
1021     }
1022 
1023     /**
1024      * @dev Add a value to a set. O(1).
1025      *
1026      * Returns true if the value was added to the set, that is if it was not
1027      * already present.
1028      */
1029     function add(Bytes32Set storage set, bytes32 value)
1030         internal
1031         returns (bool)
1032     {
1033         return _add(set._inner, value);
1034     }
1035 
1036     /**
1037      * @dev Removes a value from a set. O(1).
1038      *
1039      * Returns true if the value was removed from the set, that is if it was
1040      * present.
1041      */
1042     function remove(Bytes32Set storage set, bytes32 value)
1043         internal
1044         returns (bool)
1045     {
1046         return _remove(set._inner, value);
1047     }
1048 
1049     /**
1050      * @dev Returns true if the value is in the set. O(1).
1051      */
1052     function contains(Bytes32Set storage set, bytes32 value)
1053         internal
1054         view
1055         returns (bool)
1056     {
1057         return _contains(set._inner, value);
1058     }
1059 
1060     /**
1061      * @dev Returns the number of values in the set. O(1).
1062      */
1063     function length(Bytes32Set storage set) internal view returns (uint256) {
1064         return _length(set._inner);
1065     }
1066 
1067     /**
1068      * @dev Returns the value stored at position `index` in the set. O(1).
1069      *
1070      * Note that there are no guarantees on the ordering of values inside the
1071      * array, and it may change when more values are added or removed.
1072      *
1073      * Requirements:
1074      *
1075      * - `index` must be strictly less than {length}.
1076      */
1077     function at(Bytes32Set storage set, uint256 index)
1078         internal
1079         view
1080         returns (bytes32)
1081     {
1082         return _at(set._inner, index);
1083     }
1084 
1085     // AddressSet
1086 
1087     struct AddressSet {
1088         Set _inner;
1089     }
1090 
1091     /**
1092      * @dev Add a value to a set. O(1).
1093      *
1094      * Returns true if the value was added to the set, that is if it was not
1095      * already present.
1096      */
1097     function add(AddressSet storage set, address value)
1098         internal
1099         returns (bool)
1100     {
1101         return _add(set._inner, bytes32(uint256(uint160(value))));
1102     }
1103 
1104     /**
1105      * @dev Removes a value from a set. O(1).
1106      *
1107      * Returns true if the value was removed from the set, that is if it was
1108      * present.
1109      */
1110     function remove(AddressSet storage set, address value)
1111         internal
1112         returns (bool)
1113     {
1114         return _remove(set._inner, bytes32(uint256(uint160(value))));
1115     }
1116 
1117     /**
1118      * @dev Returns true if the value is in the set. O(1).
1119      */
1120     function contains(AddressSet storage set, address value)
1121         internal
1122         view
1123         returns (bool)
1124     {
1125         return _contains(set._inner, bytes32(uint256(uint160(value))));
1126     }
1127 
1128     /**
1129      * @dev Returns the number of values in the set. O(1).
1130      */
1131     function length(AddressSet storage set) internal view returns (uint256) {
1132         return _length(set._inner);
1133     }
1134 
1135     /**
1136      * @dev Returns the value stored at position `index` in the set. O(1).
1137      *
1138      * Note that there are no guarantees on the ordering of values inside the
1139      * array, and it may change when more values are added or removed.
1140      *
1141      * Requirements:
1142      *
1143      * - `index` must be strictly less than {length}.
1144      */
1145     function at(AddressSet storage set, uint256 index)
1146         internal
1147         view
1148         returns (address)
1149     {
1150         return address(uint160(uint256(_at(set._inner, index))));
1151     }
1152 
1153     // UintSet
1154 
1155     struct UintSet {
1156         Set _inner;
1157     }
1158 
1159     /**
1160      * @dev Add a value to a set. O(1).
1161      *
1162      * Returns true if the value was added to the set, that is if it was not
1163      * already present.
1164      */
1165     function add(UintSet storage set, uint256 value) internal returns (bool) {
1166         return _add(set._inner, bytes32(value));
1167     }
1168 
1169     /**
1170      * @dev Removes a value from a set. O(1).
1171      *
1172      * Returns true if the value was removed from the set, that is if it was
1173      * present.
1174      */
1175     function remove(UintSet storage set, uint256 value)
1176         internal
1177         returns (bool)
1178     {
1179         return _remove(set._inner, bytes32(value));
1180     }
1181 
1182     /**
1183      * @dev Returns true if the value is in the set. O(1).
1184      */
1185     function contains(UintSet storage set, uint256 value)
1186         internal
1187         view
1188         returns (bool)
1189     {
1190         return _contains(set._inner, bytes32(value));
1191     }
1192 
1193     /**
1194      * @dev Returns the number of values on the set. O(1).
1195      */
1196     function length(UintSet storage set) internal view returns (uint256) {
1197         return _length(set._inner);
1198     }
1199 
1200     /**
1201      * @dev Returns the value stored at position `index` in the set. O(1).
1202      *
1203      * Note that there are no guarantees on the ordering of values inside the
1204      * array, and it may change when more values are added or removed.
1205      *
1206      * Requirements:
1207      *
1208      * - `index` must be strictly less than {length}.
1209      */
1210     function at(UintSet storage set, uint256 index)
1211         internal
1212         view
1213         returns (uint256)
1214     {
1215         return uint256(_at(set._inner, index));
1216     }
1217 }
1218 
1219 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1220 
1221 pragma solidity >=0.6.0 <0.8.0;
1222 
1223 /**
1224  * @dev Library for managing an enumerable variant of Solidity's
1225  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1226  * type.
1227  *
1228  * Maps have the following properties:
1229  *
1230  * - Entries are added, removed, and checked for existence in constant time
1231  * (O(1)).
1232  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1233  *
1234  * ```
1235  * contract Example {
1236  *     // Add the library methods
1237  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1238  *
1239  *     // Declare a set state variable
1240  *     EnumerableMap.UintToAddressMap private myMap;
1241  * }
1242  * ```
1243  *
1244  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1245  * supported.
1246  */
1247 library EnumerableMap {
1248     // To implement this library for multiple types with as little code
1249     // repetition as possible, we write it in terms of a generic Map type with
1250     // bytes32 keys and values.
1251     // The Map implementation uses private functions, and user-facing
1252     // implementations (such as Uint256ToAddressMap) are just wrappers around
1253     // the underlying Map.
1254     // This means that we can only create new EnumerableMaps for types that fit
1255     // in bytes32.
1256 
1257     struct MapEntry {
1258         bytes32 _key;
1259         bytes32 _value;
1260     }
1261 
1262     struct Map {
1263         // Storage of map keys and values
1264         MapEntry[] _entries;
1265         // Position of the entry defined by a key in the `entries` array, plus 1
1266         // because index 0 means a key is not in the map.
1267         mapping(bytes32 => uint256) _indexes;
1268     }
1269 
1270     /**
1271      * @dev Adds a key-value pair to a map, or updates the value for an existing
1272      * key. O(1).
1273      *
1274      * Returns true if the key was added to the map, that is if it was not
1275      * already present.
1276      */
1277     function _set(
1278         Map storage map,
1279         bytes32 key,
1280         bytes32 value
1281     ) private returns (bool) {
1282         // We read and store the key's index to prevent multiple reads from the same storage slot
1283         uint256 keyIndex = map._indexes[key];
1284 
1285         if (keyIndex == 0) {
1286             // Equivalent to !contains(map, key)
1287             map._entries.push(MapEntry({_key: key, _value: value}));
1288             // The entry is stored at length-1, but we add 1 to all indexes
1289             // and use 0 as a sentinel value
1290             map._indexes[key] = map._entries.length;
1291             return true;
1292         } else {
1293             map._entries[keyIndex - 1]._value = value;
1294             return false;
1295         }
1296     }
1297 
1298     /**
1299      * @dev Removes a key-value pair from a map. O(1).
1300      *
1301      * Returns true if the key was removed from the map, that is if it was present.
1302      */
1303     function _remove(Map storage map, bytes32 key) private returns (bool) {
1304         // We read and store the key's index to prevent multiple reads from the same storage slot
1305         uint256 keyIndex = map._indexes[key];
1306 
1307         if (keyIndex != 0) {
1308             // Equivalent to contains(map, key)
1309             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1310             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1311             // This modifies the order of the array, as noted in {at}.
1312 
1313             uint256 toDeleteIndex = keyIndex - 1;
1314             uint256 lastIndex = map._entries.length - 1;
1315 
1316             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1317             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1318 
1319             MapEntry storage lastEntry = map._entries[lastIndex];
1320 
1321             // Move the last entry to the index where the entry to delete is
1322             map._entries[toDeleteIndex] = lastEntry;
1323             // Update the index for the moved entry
1324             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1325 
1326             // Delete the slot where the moved entry was stored
1327             map._entries.pop();
1328 
1329             // Delete the index for the deleted slot
1330             delete map._indexes[key];
1331 
1332             return true;
1333         } else {
1334             return false;
1335         }
1336     }
1337 
1338     /**
1339      * @dev Returns true if the key is in the map. O(1).
1340      */
1341     function _contains(Map storage map, bytes32 key)
1342         private
1343         view
1344         returns (bool)
1345     {
1346         return map._indexes[key] != 0;
1347     }
1348 
1349     /**
1350      * @dev Returns the number of key-value pairs in the map. O(1).
1351      */
1352     function _length(Map storage map) private view returns (uint256) {
1353         return map._entries.length;
1354     }
1355 
1356     /**
1357      * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1358      *
1359      * Note that there are no guarantees on the ordering of entries inside the
1360      * array, and it may change when more entries are added or removed.
1361      *
1362      * Requirements:
1363      *
1364      * - `index` must be strictly less than {length}.
1365      */
1366     function _at(Map storage map, uint256 index)
1367         private
1368         view
1369         returns (bytes32, bytes32)
1370     {
1371         require(
1372             map._entries.length > index,
1373             'EnumerableMap: index out of bounds'
1374         );
1375 
1376         MapEntry storage entry = map._entries[index];
1377         return (entry._key, entry._value);
1378     }
1379 
1380     /**
1381      * @dev Tries to returns the value associated with `key`.  O(1).
1382      * Does not revert if `key` is not in the map.
1383      */
1384     function _tryGet(Map storage map, bytes32 key)
1385         private
1386         view
1387         returns (bool, bytes32)
1388     {
1389         uint256 keyIndex = map._indexes[key];
1390         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1391         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1392     }
1393 
1394     /**
1395      * @dev Returns the value associated with `key`.  O(1).
1396      *
1397      * Requirements:
1398      *
1399      * - `key` must be in the map.
1400      */
1401     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1402         uint256 keyIndex = map._indexes[key];
1403         require(keyIndex != 0, 'EnumerableMap: nonexistent key'); // Equivalent to contains(map, key)
1404         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1405     }
1406 
1407     /**
1408      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1409      *
1410      * CAUTION: This function is deprecated because it requires allocating memory for the error
1411      * message unnecessarily. For custom revert reasons use {_tryGet}.
1412      */
1413     function _get(
1414         Map storage map,
1415         bytes32 key,
1416         string memory errorMessage
1417     ) private view returns (bytes32) {
1418         uint256 keyIndex = map._indexes[key];
1419         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1420         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1421     }
1422 
1423     // UintToAddressMap
1424 
1425     struct UintToAddressMap {
1426         Map _inner;
1427     }
1428 
1429     /**
1430      * @dev Adds a key-value pair to a map, or updates the value for an existing
1431      * key. O(1).
1432      *
1433      * Returns true if the key was added to the map, that is if it was not
1434      * already present.
1435      */
1436     function set(
1437         UintToAddressMap storage map,
1438         uint256 key,
1439         address value
1440     ) internal returns (bool) {
1441         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1442     }
1443 
1444     /**
1445      * @dev Removes a value from a set. O(1).
1446      *
1447      * Returns true if the key was removed from the map, that is if it was present.
1448      */
1449     function remove(UintToAddressMap storage map, uint256 key)
1450         internal
1451         returns (bool)
1452     {
1453         return _remove(map._inner, bytes32(key));
1454     }
1455 
1456     /**
1457      * @dev Returns true if the key is in the map. O(1).
1458      */
1459     function contains(UintToAddressMap storage map, uint256 key)
1460         internal
1461         view
1462         returns (bool)
1463     {
1464         return _contains(map._inner, bytes32(key));
1465     }
1466 
1467     /**
1468      * @dev Returns the number of elements in the map. O(1).
1469      */
1470     function length(UintToAddressMap storage map)
1471         internal
1472         view
1473         returns (uint256)
1474     {
1475         return _length(map._inner);
1476     }
1477 
1478     /**
1479      * @dev Returns the element stored at position `index` in the set. O(1).
1480      * Note that there are no guarantees on the ordering of values inside the
1481      * array, and it may change when more values are added or removed.
1482      *
1483      * Requirements:
1484      *
1485      * - `index` must be strictly less than {length}.
1486      */
1487     function at(UintToAddressMap storage map, uint256 index)
1488         internal
1489         view
1490         returns (uint256, address)
1491     {
1492         (bytes32 key, bytes32 value) = _at(map._inner, index);
1493         return (uint256(key), address(uint160(uint256(value))));
1494     }
1495 
1496     /**
1497      * @dev Tries to returns the value associated with `key`.  O(1).
1498      * Does not revert if `key` is not in the map.
1499      *
1500      * _Available since v3.4._
1501      */
1502     function tryGet(UintToAddressMap storage map, uint256 key)
1503         internal
1504         view
1505         returns (bool, address)
1506     {
1507         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1508         return (success, address(uint160(uint256(value))));
1509     }
1510 
1511     /**
1512      * @dev Returns the value associated with `key`.  O(1).
1513      *
1514      * Requirements:
1515      *
1516      * - `key` must be in the map.
1517      */
1518     function get(UintToAddressMap storage map, uint256 key)
1519         internal
1520         view
1521         returns (address)
1522     {
1523         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1524     }
1525 
1526     /**
1527      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1528      *
1529      * CAUTION: This function is deprecated because it requires allocating memory for the error
1530      * message unnecessarily. For custom revert reasons use {tryGet}.
1531      */
1532     function get(
1533         UintToAddressMap storage map,
1534         uint256 key,
1535         string memory errorMessage
1536     ) internal view returns (address) {
1537         return
1538             address(
1539                 uint160(uint256(_get(map._inner, bytes32(key), errorMessage)))
1540             );
1541     }
1542 }
1543 
1544 // File: @openzeppelin/contracts/utils/Strings.sol
1545 
1546 pragma solidity >=0.6.0 <0.8.0;
1547 
1548 /**
1549  * @dev String operations.
1550  */
1551 library Strings {
1552     /**
1553      * @dev Converts a `uint256` to its ASCII `string` representation.
1554      */
1555     function toString(uint256 value) internal pure returns (string memory) {
1556         // Inspired by OraclizeAPI's implementation - MIT licence
1557         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1558 
1559         if (value == 0) {
1560             return '0';
1561         }
1562         uint256 temp = value;
1563         uint256 digits;
1564         while (temp != 0) {
1565             digits++;
1566             temp /= 10;
1567         }
1568         bytes memory buffer = new bytes(digits);
1569         uint256 index = digits - 1;
1570         temp = value;
1571         while (temp != 0) {
1572             buffer[index--] = bytes1(uint8(48 + (temp % 10)));
1573             temp /= 10;
1574         }
1575         return string(buffer);
1576     }
1577 }
1578 
1579 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1580 
1581 pragma solidity >=0.6.0 <0.8.0;
1582 
1583 /**
1584  * @title ERC721 Non-Fungible Token Standard basic implementation
1585  * @dev see https://eips.ethereum.org/EIPS/eip-721
1586  */
1587 contract ERC721 is
1588     Context,
1589     ERC165,
1590     IERC721,
1591     IERC721Metadata,
1592     IERC721Enumerable
1593 {
1594     using SafeMath for uint256;
1595     using Address for address;
1596     using EnumerableSet for EnumerableSet.UintSet;
1597     using EnumerableMap for EnumerableMap.UintToAddressMap;
1598     using Strings for uint256;
1599 
1600     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1601     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1602     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1603 
1604     // Mapping from holder address to their (enumerable) set of owned tokens
1605     mapping(address => EnumerableSet.UintSet) private _holderTokens;
1606 
1607     // Enumerable mapping from token ids to their owners
1608     EnumerableMap.UintToAddressMap private _tokenOwners;
1609 
1610     // Mapping from token ID to approved address
1611     mapping(uint256 => address) private _tokenApprovals;
1612 
1613     // Mapping from owner to operator approvals
1614     mapping(address => mapping(address => bool)) private _operatorApprovals;
1615 
1616     // Token name
1617     string private _name;
1618 
1619     // Token symbol
1620     string private _symbol;
1621 
1622     // Optional mapping for token URIs
1623     mapping(uint256 => string) private _tokenURIs;
1624 
1625     // Base URI
1626     string private _baseURI = '';
1627 
1628     /*
1629      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1630      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1631      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1632      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1633      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1634      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1635      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1636      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1637      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1638      *
1639      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1640      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1641      */
1642     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1643 
1644     /*
1645      *     bytes4(keccak256('name()')) == 0x06fdde03
1646      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1647      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1648      *
1649      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1650      */
1651     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1652 
1653     /*
1654      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1655      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1656      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1657      *
1658      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1659      */
1660     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1661 
1662     /**
1663      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1664      */
1665     constructor(string memory name_, string memory symbol_) public {
1666         _name = name_;
1667         _symbol = symbol_;
1668 
1669         // register the supported interfaces to conform to ERC721 via ERC165
1670         _registerInterface(_INTERFACE_ID_ERC721);
1671         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1672         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1673     }
1674 
1675     /**
1676      * @dev See {IERC721-balanceOf}.
1677      */
1678     function balanceOf(address owner)
1679         public
1680         view
1681         virtual
1682         override
1683         returns (uint256)
1684     {
1685         require(
1686             owner != address(0),
1687             'ERC721: balance query for the zero address'
1688         );
1689         return _holderTokens[owner].length();
1690     }
1691 
1692     /**
1693      * @dev See {IERC721-ownerOf}.
1694      */
1695     function ownerOf(uint256 tokenId)
1696         public
1697         view
1698         virtual
1699         override
1700         returns (address)
1701     {
1702         return
1703             _tokenOwners.get(
1704                 tokenId,
1705                 'ERC721: owner query for nonexistent token'
1706             );
1707     }
1708 
1709     /**
1710      * @dev See {IERC721Metadata-name}.
1711      */
1712     function name() public view virtual override returns (string memory) {
1713         return _name;
1714     }
1715 
1716     /**
1717      * @dev See {IERC721Metadata-symbol}.
1718      */
1719     function symbol() public view virtual override returns (string memory) {
1720         return _symbol;
1721     }
1722 
1723     /**
1724      * @dev See {IERC721Metadata-tokenURI}.
1725      */
1726     function tokenURI(uint256 tokenId)
1727         public
1728         view
1729         virtual
1730         override
1731         returns (string memory)
1732     {
1733         require(
1734             _exists(tokenId),
1735             'ERC721Metadata: URI query for nonexistent token'
1736         );
1737 
1738         string memory _tokenURI = _tokenURIs[tokenId];
1739         string memory base = baseURI();
1740 
1741         // If there is no base URI, return the token URI.
1742         if (bytes(base).length == 0) {
1743             return _tokenURI;
1744         }
1745         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1746         if (bytes(_tokenURI).length > 0) {
1747             return string(abi.encodePacked(base, _tokenURI));
1748         }
1749         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1750         return string(abi.encodePacked(base, tokenId.toString()));
1751     }
1752 
1753     /**
1754      * @dev Returns the base URI. This will be
1755      * automatically added as a prefix in {tokenURI} to each token's URI, or
1756      * to the token ID if no specific URI is set for that token ID.
1757      */
1758     function baseURI() public view virtual returns (string memory) {
1759         return _baseURI;
1760     }
1761 
1762     /**
1763      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1764      */
1765     function tokenOfOwnerByIndex(address owner, uint256 index)
1766         public
1767         view
1768         virtual
1769         override
1770         returns (uint256)
1771     {
1772         return _holderTokens[owner].at(index);
1773     }
1774 
1775     /**
1776      * @dev See {IERC721Enumerable-totalSupply}.
1777      */
1778     function totalSupply() public view virtual override returns (uint256) {
1779         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1780         return _tokenOwners.length();
1781     }
1782 
1783     /**
1784      * @dev See {IERC721Enumerable-tokenByIndex}.
1785      */
1786     function tokenByIndex(uint256 index)
1787         public
1788         view
1789         virtual
1790         override
1791         returns (uint256)
1792     {
1793         (uint256 tokenId, ) = _tokenOwners.at(index);
1794         return tokenId;
1795     }
1796 
1797     /**
1798      * @dev See {IERC721-approve}.
1799      */
1800     function approve(address to, uint256 tokenId) public virtual override {
1801         address owner = ERC721.ownerOf(tokenId);
1802         require(to != owner, 'ERC721: approval to current owner');
1803 
1804         require(
1805             _msgSender() == owner ||
1806                 ERC721.isApprovedForAll(owner, _msgSender()),
1807             'ERC721: approve caller is not owner nor approved for all'
1808         );
1809 
1810         _approve(to, tokenId);
1811     }
1812 
1813     /**
1814      * @dev See {IERC721-getApproved}.
1815      */
1816     function getApproved(uint256 tokenId)
1817         public
1818         view
1819         virtual
1820         override
1821         returns (address)
1822     {
1823         require(
1824             _exists(tokenId),
1825             'ERC721: approved query for nonexistent token'
1826         );
1827 
1828         return _tokenApprovals[tokenId];
1829     }
1830 
1831     /**
1832      * @dev See {IERC721-setApprovalForAll}.
1833      */
1834     function setApprovalForAll(address operator, bool approved)
1835         public
1836         virtual
1837         override
1838     {
1839         require(operator != _msgSender(), 'ERC721: approve to caller');
1840 
1841         _operatorApprovals[_msgSender()][operator] = approved;
1842         emit ApprovalForAll(_msgSender(), operator, approved);
1843     }
1844 
1845     /**
1846      * @dev See {IERC721-isApprovedForAll}.
1847      */
1848     function isApprovedForAll(address owner, address operator)
1849         public
1850         view
1851         virtual
1852         override
1853         returns (bool)
1854     {
1855         return _operatorApprovals[owner][operator];
1856     }
1857 
1858     /**
1859      * @dev See {IERC721-transferFrom}.
1860      */
1861     function transferFrom(
1862         address from,
1863         address to,
1864         uint256 tokenId
1865     ) public virtual override {
1866         //solhint-disable-next-line max-line-length
1867         require(
1868             _isApprovedOrOwner(_msgSender(), tokenId),
1869             'ERC721: transfer caller is not owner nor approved'
1870         );
1871 
1872         _transfer(from, to, tokenId);
1873     }
1874 
1875     /**
1876      * @dev See {IERC721-safeTransferFrom}.
1877      */
1878     function safeTransferFrom(
1879         address from,
1880         address to,
1881         uint256 tokenId
1882     ) public virtual override {
1883         safeTransferFrom(from, to, tokenId, '');
1884     }
1885 
1886     /**
1887      * @dev See {IERC721-safeTransferFrom}.
1888      */
1889     function safeTransferFrom(
1890         address from,
1891         address to,
1892         uint256 tokenId,
1893         bytes memory _data
1894     ) public virtual override {
1895         require(
1896             _isApprovedOrOwner(_msgSender(), tokenId),
1897             'ERC721: transfer caller is not owner nor approved'
1898         );
1899         _safeTransfer(from, to, tokenId, _data);
1900     }
1901 
1902     /**
1903      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1904      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1905      *
1906      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1907      *
1908      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1909      * implement alternative mechanisms to perform token transfer, such as signature-based.
1910      *
1911      * Requirements:
1912      *
1913      * - `from` cannot be the zero address.
1914      * - `to` cannot be the zero address.
1915      * - `tokenId` token must exist and be owned by `from`.
1916      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1917      *
1918      * Emits a {Transfer} event.
1919      */
1920     function _safeTransfer(
1921         address from,
1922         address to,
1923         uint256 tokenId,
1924         bytes memory _data
1925     ) internal virtual {
1926         _transfer(from, to, tokenId);
1927         require(
1928             _checkOnERC721Received(from, to, tokenId, _data),
1929             'ERC721: transfer to non ERC721Receiver implementer'
1930         );
1931     }
1932 
1933     /**
1934      * @dev Returns whether `tokenId` exists.
1935      *
1936      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1937      *
1938      * Tokens start existing when they are minted (`_mint`),
1939      * and stop existing when they are burned (`_burn`).
1940      */
1941     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1942         return _tokenOwners.contains(tokenId);
1943     }
1944 
1945     /**
1946      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1947      *
1948      * Requirements:
1949      *
1950      * - `tokenId` must exist.
1951      */
1952     function _isApprovedOrOwner(address spender, uint256 tokenId)
1953         internal
1954         view
1955         virtual
1956         returns (bool)
1957     {
1958         require(
1959             _exists(tokenId),
1960             'ERC721: operator query for nonexistent token'
1961         );
1962         address owner = ERC721.ownerOf(tokenId);
1963         return (spender == owner ||
1964             getApproved(tokenId) == spender ||
1965             ERC721.isApprovedForAll(owner, spender));
1966     }
1967 
1968     /**
1969      * @dev Safely mints `tokenId` and transfers it to `to`.
1970      *
1971      * Requirements:
1972      d*
1973      * - `tokenId` must not exist.
1974      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1975      *
1976      * Emits a {Transfer} event.
1977      */
1978     function _safeMint(address to, uint256 tokenId) internal virtual {
1979         _safeMint(to, tokenId, '');
1980     }
1981 
1982     /**
1983      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1984      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1985      */
1986     function _safeMint(
1987         address to,
1988         uint256 tokenId,
1989         bytes memory _data
1990     ) internal virtual {
1991         _mint(to, tokenId);
1992         require(
1993             _checkOnERC721Received(address(0), to, tokenId, _data),
1994             'ERC721: transfer to non ERC721Receiver implementer'
1995         );
1996     }
1997 
1998     /**
1999      * @dev Mints `tokenId` and transfers it to `to`.
2000      *
2001      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
2002      *
2003      * Requirements:
2004      *
2005      * - `tokenId` must not exist.
2006      * - `to` cannot be the zero address.
2007      *
2008      * Emits a {Transfer} event.
2009      */
2010     function _mint(address to, uint256 tokenId) internal virtual {
2011         require(to != address(0), 'ERC721: mint to the zero address');
2012         require(!_exists(tokenId), 'ERC721: token already minted');
2013 
2014         _beforeTokenTransfer(address(0), to, tokenId);
2015 
2016         _holderTokens[to].add(tokenId);
2017 
2018         _tokenOwners.set(tokenId, to);
2019 
2020         emit Transfer(address(0), to, tokenId);
2021     }
2022 
2023     /**
2024      * @dev Destroys `tokenId`.
2025      * The approval is cleared when the token is burned.
2026      *
2027      * Requirements:
2028      *
2029      * - `tokenId` must exist.
2030      *
2031      * Emits a {Transfer} event.
2032      */
2033     function _burn(uint256 tokenId) internal virtual {
2034         address owner = ERC721.ownerOf(tokenId); // internal owner
2035 
2036         _beforeTokenTransfer(owner, address(0), tokenId);
2037 
2038         // Clear approvals
2039         _approve(address(0), tokenId);
2040 
2041         // Clear metadata (if any)
2042         if (bytes(_tokenURIs[tokenId]).length != 0) {
2043             delete _tokenURIs[tokenId];
2044         }
2045 
2046         _holderTokens[owner].remove(tokenId);
2047 
2048         _tokenOwners.remove(tokenId);
2049 
2050         emit Transfer(owner, address(0), tokenId);
2051     }
2052 
2053     /**
2054      * @dev Transfers `tokenId` from `from` to `to`.
2055      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
2056      *
2057      * Requirements:
2058      *
2059      * - `to` cannot be the zero address.
2060      * - `tokenId` token must be owned by `from`.
2061      *
2062      * Emits a {Transfer} event.
2063      */
2064     function _transfer(
2065         address from,
2066         address to,
2067         uint256 tokenId
2068     ) internal virtual {
2069         require(
2070             ERC721.ownerOf(tokenId) == from,
2071             'ERC721: transfer of token that is not own'
2072         ); // internal owner
2073         require(to != address(0), 'ERC721: transfer to the zero address');
2074 
2075         _beforeTokenTransfer(from, to, tokenId);
2076 
2077         // Clear approvals from the previous owner
2078         _approve(address(0), tokenId);
2079 
2080         _holderTokens[from].remove(tokenId);
2081         _holderTokens[to].add(tokenId);
2082 
2083         _tokenOwners.set(tokenId, to);
2084 
2085         emit Transfer(from, to, tokenId);
2086     }
2087 
2088     /**
2089      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
2090      *
2091      * Requirements:
2092      *
2093      * - `tokenId` must exist.
2094      */
2095     function _setTokenURI(uint256 tokenId, string memory _tokenURI)
2096         internal
2097         virtual
2098     {
2099         require(
2100             _exists(tokenId),
2101             'ERC721Metadata: URI set of nonexistent token'
2102         );
2103         _tokenURIs[tokenId] = _tokenURI;
2104     }
2105 
2106     /**
2107      * @dev Internal function to set the base URI for all token IDs. It is
2108      * automatically added as a prefix to the value returned in {tokenURI},
2109      * or to the token ID if {tokenURI} is empty.
2110      */
2111     function _setBaseURI(string memory baseURI_) internal virtual {
2112         _baseURI = baseURI_;
2113     }
2114 
2115     /**
2116      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
2117      * The call is not executed if the target address is not a contract.
2118      *
2119      * @param from address representing the previous owner of the given token ID
2120      * @param to target address that will receive the tokens
2121      * @param tokenId uint256 ID of the token to be transferred
2122      * @param _data bytes optional data to send along with the call
2123      * @return bool whether the call correctly returned the expected magic value
2124      */
2125     function _checkOnERC721Received(
2126         address from,
2127         address to,
2128         uint256 tokenId,
2129         bytes memory _data
2130     ) private returns (bool) {
2131         if (!to.isContract()) {
2132             return true;
2133         }
2134         bytes memory returndata = to.functionCall(
2135             abi.encodeWithSelector(
2136                 IERC721Receiver(to).onERC721Received.selector,
2137                 _msgSender(),
2138                 from,
2139                 tokenId,
2140                 _data
2141             ),
2142             'ERC721: transfer to non ERC721Receiver implementer'
2143         );
2144         bytes4 retval = abi.decode(returndata, (bytes4));
2145         return (retval == _ERC721_RECEIVED);
2146     }
2147 
2148     /**
2149      * @dev Approve `to` to operate on `tokenId`
2150      *
2151      * Emits an {Approval} event.
2152      */
2153     function _approve(address to, uint256 tokenId) internal virtual {
2154         _tokenApprovals[tokenId] = to;
2155         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
2156     }
2157 
2158     /**
2159      * @dev Hook that is called before any token transfer. This includes minting
2160      * and burning.
2161      *
2162      * Calling conditions:
2163      *
2164      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
2165      * transferred to `to`.
2166      * - When `from` is zero, `tokenId` will be minted for `to`.
2167      * - When `to` is zero, ``from``'s `tokenId` will be burned.
2168      * - `from` cannot be the zero address.
2169      * - `to` cannot be the zero address.
2170      *
2171      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
2172      */
2173     function _beforeTokenTransfer(
2174         address from,
2175         address to,
2176         uint256 tokenId
2177     ) internal virtual {}
2178 }
2179 
2180 // File: @openzeppelin/contracts/access/Ownable.sol
2181 
2182 pragma solidity >=0.6.0 <0.8.0;
2183 
2184 /**
2185  * @dev Contract module which provides a basic access control mechanism, where
2186  * there is an account (an owner) that can be granted exclusive access to
2187  * specific functions.
2188  *
2189  * By default, the owner account will be the one that deploys the contract. This
2190  * can later be changed with {transferOwnership}.
2191  *
2192  * This module is used through inheritance. It will make available the modifier
2193  * `onlyOwner`, which can be applied to your functions to restrict their use to
2194  * the owner.
2195  */
2196 abstract contract Ownable is Context {
2197     address private _owner;
2198 
2199     event OwnershipTransferred(
2200         address indexed previousOwner,
2201         address indexed newOwner
2202     );
2203 
2204     /**
2205      * @dev Initializes the contract setting the deployer as the initial owner.
2206      */
2207     constructor() internal {
2208         address msgSender = _msgSender();
2209         _owner = msgSender;
2210         emit OwnershipTransferred(address(0), msgSender);
2211     }
2212 
2213     /**
2214      * @dev Returns the address of the current owner.
2215      */
2216     function owner() public view virtual returns (address) {
2217         return _owner;
2218     }
2219 
2220     /**
2221      * @dev Throws if called by any account other than the owner.
2222      */
2223     modifier onlyOwner() {
2224         require(owner() == _msgSender(), 'Ownable: caller is not the owner');
2225         _;
2226     }
2227 
2228     /**
2229      * @dev Leaves the contract without owner. It will not be possible to call
2230      * `onlyOwner` functions anymore. Can only be called by the current owner.
2231      *
2232      * NOTE: Renouncing ownership will leave the contract without an owner,
2233      * thereby removing any functionality that is only available to the owner.
2234      */
2235     function renounceOwnership() public virtual onlyOwner {
2236         emit OwnershipTransferred(_owner, address(0));
2237         _owner = address(0);
2238     }
2239 
2240     /**
2241      * @dev Transfers ownership of the contract to a new account (`newOwner`).
2242      * Can only be called by the current owner.
2243      */
2244     function transferOwnership(address newOwner) public virtual onlyOwner {
2245         require(
2246             newOwner != address(0),
2247             'Ownable: new owner is the zero address'
2248         );
2249         emit OwnershipTransferred(_owner, newOwner);
2250         _owner = newOwner;
2251     }
2252 }
2253 
2254 // File: contracts/fagc.sol
2255 
2256 pragma solidity ^0.7.0;
2257 
2258 /**
2259  * @title Furious Alpha Gym Club contract
2260  * @dev Extends ERC721 Non-Fungible Token Standard basic implementation
2261  */
2262 contract FuriousAlphaGymClub is ERC721, Ownable {
2263     using SafeMath for uint256;
2264 
2265     // The base price is set here.
2266     uint256 public nftPrice = 78000000000000000; // 0.078 ETH
2267 
2268     // Only 10 furious alpha can be purchased per transaction.
2269     uint256 public constant maxNumPurchase = 10;
2270 
2271     // Only 10,000 total furious alpha will be generated
2272     // 100 will remain possible to create and mint for very big sponsorship.
2273     uint256 public constant MAX_TOKENS = 10000;
2274 
2275     // How many tokens an early access member is allowed to mint.
2276     uint256 public earlyAccessTokensPerUser = 3;
2277 
2278     uint256 public totalEarlyAccessTokensAllowed = 6000;
2279 
2280     uint256 public currentEarlyAccessTokensClaimed = 0;
2281 
2282     /**
2283      * The hash of the concatented hash string of all the images.
2284      */
2285     string public provenance = '';
2286 
2287     mapping(address => bool) private earlyAccessAllowList;
2288 
2289     mapping(address => uint256) private earlyAccessClaimedTokens;
2290 
2291     /**
2292      * The state of the sale:
2293      * 0 = closed
2294      * 1 = early access
2295      * 2 = open
2296      */
2297     uint256 public saleState = 0;
2298 
2299     constructor() ERC721('FuriousAlphaGymClub', 'FAGC') {
2300         _setBaseURI('ipfs://QmWokQaSi5MAXn5WwKVjxfPtkNXviEceNWCGSpoAHGMmQe/');
2301         _safeMint(msg.sender, totalSupply());
2302     }
2303 
2304     function withdraw() public onlyOwner {
2305         uint256 balance = address(this).balance;
2306         msg.sender.transfer(balance);
2307     }
2308 
2309     /**
2310      * Set some tokens aside.
2311      */
2312     function reserveTokens(uint256 number) public onlyOwner {
2313         require(
2314             totalSupply().add(number) <= MAX_TOKENS,
2315             'Reservation would exceed max supply'
2316         );
2317         uint256 supply = totalSupply();
2318         uint256 i;
2319         for (i = 0; i < number; i++) {
2320             _safeMint(msg.sender, supply + i);
2321         }
2322     }
2323 
2324     /**
2325      * Set the state of the sale.
2326      */
2327     function setSaleState(uint256 newState) public onlyOwner {
2328         require(newState >= 0 && newState <= 2, 'Invalid state');
2329         saleState = newState;
2330     }
2331 
2332     function setBaseURI(string memory baseURI) public onlyOwner {
2333         _setBaseURI(baseURI);
2334     }
2335 
2336     function setProvenanceHash(string memory hash) public onlyOwner {
2337         provenance = hash;
2338     }
2339 
2340     function setPrice(uint256 value) public onlyOwner {
2341         nftPrice = value;
2342     }
2343 
2344     function setEarlyAccessTokensPerUser(uint256 num) public onlyOwner {
2345         earlyAccessTokensPerUser = num;
2346     }
2347 
2348     function setTotalEarlyAccessTokensAllowed(uint256 num) public onlyOwner {
2349         totalEarlyAccessTokensAllowed = num;
2350     }
2351 
2352     function addEarlyAccessMembers(address[] memory addresses)
2353         public
2354         onlyOwner
2355     {
2356         for (uint256 i = 0; i < addresses.length; i++) {
2357             earlyAccessAllowList[addresses[i]] = true;
2358         }
2359     }
2360 
2361     function giveAwayTokens(address[] memory addresses) public onlyOwner {
2362         require(
2363             totalSupply().add(addresses.length) <= MAX_TOKENS,
2364             'Reservation would exceed max supply'
2365         );
2366         uint256 supply = totalSupply();
2367         uint256 i;
2368         for (i = 0; i < addresses.length; i++) {
2369             _safeMint(addresses[i], supply + i);
2370         }
2371     }
2372 
2373     function removeEarlyAccessMember()
2374         public
2375     {
2376         require(
2377             earlyAccessAllowList[msg.sender],
2378             'Sender is not on the early access list'
2379         );
2380         earlyAccessAllowList[msg.sender] = false;
2381     }
2382 
2383     function _checkRegularSale(uint256 numberOfTokens) internal pure {
2384         require(
2385             numberOfTokens <= maxNumPurchase,
2386             'Can only mint 10 tokens at a time'
2387         );
2388     }
2389 
2390     function _checkEarlyAccess(address sender, uint256 numberOfTokens)
2391         internal
2392         view
2393     {
2394         require(
2395             earlyAccessAllowList[sender],
2396             'Sender is not on the early access list'
2397         );
2398         require(
2399             currentEarlyAccessTokensClaimed < totalEarlyAccessTokensAllowed,
2400             'Minting would exceed total allowed for early access'
2401         );
2402         require(
2403             earlyAccessClaimedTokens[sender] < earlyAccessTokensPerUser,
2404             'Sender cannot claim any more early access fagc at this time'
2405         );
2406         require(
2407             numberOfTokens <= earlyAccessTokensPerUser,
2408             'Can only mint 3 tokens in the early access sale'
2409         );
2410     }
2411 
2412     function canClaimEarlyAccessToken(address addr) public view returns (bool) {
2413         return
2414             earlyAccessAllowList[addr] &&
2415             earlyAccessClaimedTokens[addr] < earlyAccessTokensPerUser &&
2416             currentEarlyAccessTokensClaimed < totalEarlyAccessTokensAllowed;
2417     }
2418 
2419     /**
2420      * Mints an NFT
2421      */
2422     function mintFAGC(uint256 numberOfTokens) public payable {
2423         require(
2424             saleState == 1 || saleState == 2,
2425             'Sale must be active to mint'
2426         );
2427         if (saleState == 1) {
2428             _checkEarlyAccess(msg.sender, numberOfTokens);
2429             earlyAccessClaimedTokens[msg.sender] = earlyAccessClaimedTokens[
2430                 msg.sender
2431             ].add(numberOfTokens);
2432             currentEarlyAccessTokensClaimed = currentEarlyAccessTokensClaimed
2433                 .add(numberOfTokens);
2434         } else if (saleState == 2) {
2435             _checkRegularSale(numberOfTokens);
2436         }
2437         require(
2438             totalSupply().add(numberOfTokens) <= MAX_TOKENS,
2439             'Purchase would exceed max supply'
2440         );
2441         require(
2442             nftPrice.mul(numberOfTokens) <= msg.value,
2443             'Ether value sent is not correct'
2444         );
2445 
2446         for (uint256 i = 0; i < numberOfTokens; i++) {
2447             uint256 mintIndex = totalSupply();
2448             _safeMint(msg.sender, mintIndex);
2449         }
2450     }
2451 }