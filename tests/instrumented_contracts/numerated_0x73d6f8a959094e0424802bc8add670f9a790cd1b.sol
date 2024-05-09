1 // SPDX-License-Identifier: MIT
2 
3 /////////////////////////////////////////////////////////////////////////////
4 //                                      .-'''-.        .-'''-.             //
5 //                                     '   _    \     '   _    \           //
6 //  _________   _...._               /   /` '.   \  /   /` '.   \          //
7 //  \        |.'      '-.           .   |     \  ' .   |     \  '   _.._   //
8 //   \        .'```'.    '. .-,.--. |   '      |  '|   '      |  '.' .._|  //
9 //    \      |       \     \|  .-. |\    \     / / \    \     / / | '      //
10 //     |     |        |    || |  | | `.   ` ..' /   `.   ` ..' /__| |__    //
11 //     |      \      /    . | |  | |    '-...-'`       '-...-'`|__   __|   //
12 //     |     |\`'-.-'   .'  | |  '-                               | |      //
13 //     |     | '-....-'`    | |                                   | |      //
14 //    .'     '.   .-'''-.   | |                                   | |      //
15 //  '-----------''   _    \ |_|                                   | |      //
16 //             /   /` '.   \                                      |_|      //
17 //            .   |     \  '   _.._                                        //
18 //            |   '      |  '.' .._|                                       //
19 //            \    \     / / | '                                           //
20 //             `.   ` ..' /__| |__                                         //
21 //                '-...-'`|__   __|                                        //
22 //                           | |                                           //
23 //                _..._      | |        .           __.....__              //
24 //              .'     '.    | |      .'|       .-''         '.            //
25 //             .   .-.   .   | |    .'  |      /     .-''"'-.  `.          //
26 //             |  '   '  |   |_|   <    |     /     /________\   \         //
27 //         _   |  |   |  | .:--.'.  |   | ____|                  |         //
28 //       .' |  |  |   |  |/ |   \ | |   | \ .'\    .-------------'         //
29 //      .   | /|  |   |  |`" __ | | |   |/  .  \    '-.____...---.         //
30 //    .'.'| |//|  |   |  | .'.''| | |    /\  \  `.             .'          //
31 //  .'.'.-'  / |  |   |  |/ /   | |_|   |  \  \   `''-...... -'            //
32 //  .'   \_.'  |  |   |  |\ \._,\ '/'    \  \  \                           //
33 //             '--'   '--' `--'  `"'------'  '---'                         //
34 /////////////////////////////////////////////////////////////////////////////
35 //~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
36 //*.++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++.
37 /*|                                                                         |                                                                        |
38 /*|                          Welcome to MySnakes!                           |                                   |
39 /*|                                                                         |
40 /*|  Will you stick around to shed your awk phase and make it to snakebook? |
41 /*|                                                                         |
42 /*|                      ♥ PEACE, LOVE, and MYSNAKES ♥                      |
43 /*|                          https://MySnakes.xyz                           |
44 /*|                                                                         |
45 /*|   Huge shoutout to @boringbananasco for open-sourcing their project.    |
46 /*| If you have't heard of them, check it out, we hear snakes like bananas! |
47 /*|    Snakes on a Chain is not just proof of work, its proof of Snake.     |
48 /*|                                                                         |
49 //`========================================================================='
50 ////////////////////////////////////////////////////////////////////////////
51 //@cyberspace69
52 //@jenfteach
53 */
54 // File: @openzeppelin/contracts/utils/Context.sol
55 
56 pragma solidity >=0.6.0 <0.8.0;
57 
58 /*
59  * @dev Provides information about the current execution context, including the
60  * sender of the transaction and its data. While these are generally available
61  * via msg.sender and msg.data, they should not be accessed in such a direct
62  * manner, since when dealing with GSN meta-transactions the account sending and
63  * paying for execution may not be the actual sender (as far as an application
64  * is concerned).
65  *
66  * This contract is only required for intermediate, library-like contracts.
67  */
68 abstract contract Context {
69     function _msgSender() internal view virtual returns (address payable) {
70         return msg.sender;
71     }
72 
73     function _msgData() internal view virtual returns (bytes memory) {
74         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
75         return msg.data;
76     }
77 }
78 
79 // File: @openzeppelin/contracts/introspection/IERC165.sol
80 
81 
82 
83 pragma solidity >=0.6.0 <0.8.0;
84 
85 /**
86  * @dev Interface of the ERC165 standard, as defined in the
87  * https://eips.ethereum.org/EIPS/eip-165[EIP].
88  *
89  * Implementers can declare support of contract interfaces, which can then be
90  * queried by others ({ERC165Checker}).
91  *
92  * For an implementation, see {ERC165}.
93  */
94 interface IERC165 {
95     /**
96      * @dev Returns true if this contract implements the interface defined by
97      * `interfaceId`. See the corresponding
98      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
99      * to learn more about how these ids are created.
100      *
101      * This function call must use less than 30 000 gas.
102      */
103     function supportsInterface(bytes4 interfaceId) external view returns (bool);
104 }
105 
106 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
107 
108 
109 
110 pragma solidity >=0.6.2 <0.8.0;
111 
112 
113 /**
114  * @dev Required interface of an ERC721 compliant contract.
115  */
116 interface IERC721 is IERC165 {
117     /**
118      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
119      */
120     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
121 
122     /**
123      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
124      */
125     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
126 
127     /**
128      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
129      */
130     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
131 
132     /**
133      * @dev Returns the number of tokens in ``owner``'s account.
134      */
135     function balanceOf(address owner) external view returns (uint256 balance);
136 
137     /**
138      * @dev Returns the owner of the `tokenId` token.
139      *
140      * Requirements:
141      *
142      * - `tokenId` must exist.
143      */
144     function ownerOf(uint256 tokenId) external view returns (address owner);
145 
146     /**
147      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
148      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
149      *
150      * Requirements:
151      *
152      * - `from` cannot be the zero address.
153      * - `to` cannot be the zero address.
154      * - `tokenId` token must exist and be owned by `from`.
155      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
156      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
157      *
158      * Emits a {Transfer} event.
159      */
160     function safeTransferFrom(address from, address to, uint256 tokenId) external;
161 
162     /**
163      * @dev Transfers `tokenId` token from `from` to `to`.
164      *
165      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
166      *
167      * Requirements:
168      *
169      * - `from` cannot be the zero address.
170      * - `to` cannot be the zero address.
171      * - `tokenId` token must be owned by `from`.
172      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
173      *
174      * Emits a {Transfer} event.
175      */
176     function transferFrom(address from, address to, uint256 tokenId) external;
177 
178     /**
179      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
180      * The approval is cleared when the token is transferred.
181      *
182      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
183      *
184      * Requirements:
185      *
186      * - The caller must own the token or be an approved operator.
187      * - `tokenId` must exist.
188      *
189      * Emits an {Approval} event.
190      */
191     function approve(address to, uint256 tokenId) external;
192 
193     /**
194      * @dev Returns the account approved for `tokenId` token.
195      *
196      * Requirements:
197      *
198      * - `tokenId` must exist.
199      */
200     function getApproved(uint256 tokenId) external view returns (address operator);
201 
202     /**
203      * @dev Approve or remove `operator` as an operator for the caller.
204      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
205      *
206      * Requirements:
207      *
208      * - The `operator` cannot be the caller.
209      *
210      * Emits an {ApprovalForAll} event.
211      */
212     function setApprovalForAll(address operator, bool _approved) external;
213 
214     /**
215      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
216      *
217      * See {setApprovalForAll}
218      */
219     function isApprovedForAll(address owner, address operator) external view returns (bool);
220 
221     /**
222       * @dev Safely transfers `tokenId` token from `from` to `to`.
223       *
224       * Requirements:
225       *
226       * - `from` cannot be the zero address.
227       * - `to` cannot be the zero address.
228       * - `tokenId` token must exist and be owned by `from`.
229       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
230       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
231       *
232       * Emits a {Transfer} event.
233       */
234     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
235 }
236 
237 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
238 
239 
240 
241 pragma solidity >=0.6.2 <0.8.0;
242 
243 
244 /**
245  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
246  * @dev See https://eips.ethereum.org/EIPS/eip-721
247  */
248 interface IERC721Metadata is IERC721 {
249 
250     /**
251      * @dev Returns the token collection name.
252      */
253     function name() external view returns (string memory);
254 
255     /**
256      * @dev Returns the token collection symbol.
257      */
258     function symbol() external view returns (string memory);
259 
260     /**
261      * @dev Returns the Uniform Resource Identifier (URI) for `tokenId` token.
262      */
263     function tokenURI(uint256 tokenId) external view returns (string memory);
264 }
265 
266 // File: @openzeppelin/contracts/token/ERC721/IERC721Enumerable.sol
267 
268 
269 
270 pragma solidity >=0.6.2 <0.8.0;
271 
272 
273 /**
274  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
275  * @dev See https://eips.ethereum.org/EIPS/eip-721
276  */
277 interface IERC721Enumerable is IERC721 {
278 
279     /**
280      * @dev Returns the total amount of tokens stored by the contract.
281      */
282     function totalSupply() external view returns (uint256);
283 
284     /**
285      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
286      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
287      */
288     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
289 
290     /**
291      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
292      * Use along with {totalSupply} to enumerate all tokens.
293      */
294     function tokenByIndex(uint256 index) external view returns (uint256);
295 }
296 
297 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
298 
299 
300 
301 pragma solidity >=0.6.0 <0.8.0;
302 
303 /**
304  * @title ERC721 token receiver interface
305  * @dev Interface for any contract that wants to support safeTransfers
306  * from ERC721 asset contracts.
307  */
308 interface IERC721Receiver {
309     /**
310      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
311      * by `operator` from `from`, this function is called.
312      *
313      * It must return its Solidity selector to confirm the token transfer.
314      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
315      *
316      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
317      */
318     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
319 }
320 
321 // File: @openzeppelin/contracts/introspection/ERC165.sol
322 
323 
324 
325 pragma solidity >=0.6.0 <0.8.0;
326 
327 
328 /**
329  * @dev Implementation of the {IERC165} interface.
330  *
331  * Contracts may inherit from this and call {_registerInterface} to declare
332  * their support of an interface.
333  */
334 abstract contract ERC165 is IERC165 {
335     /*
336      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
337      */
338     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
339 
340     /**
341      * @dev Mapping of interface ids to whether or not it's supported.
342      */
343     mapping(bytes4 => bool) private _supportedInterfaces;
344 
345     constructor () internal {
346         // Derived contracts need only register support for their own interfaces,
347         // we register support for ERC165 itself here
348         _registerInterface(_INTERFACE_ID_ERC165);
349     }
350 
351     /**
352      * @dev See {IERC165-supportsInterface}.
353      *
354      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
355      */
356     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
357         return _supportedInterfaces[interfaceId];
358     }
359 
360     /**
361      * @dev Registers the contract as an implementer of the interface defined by
362      * `interfaceId`. Support of the actual ERC165 interface is automatic and
363      * registering its interface id is not required.
364      *
365      * See {IERC165-supportsInterface}.
366      *
367      * Requirements:
368      *
369      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
370      */
371     function _registerInterface(bytes4 interfaceId) internal virtual {
372         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
373         _supportedInterfaces[interfaceId] = true;
374     }
375 }
376 
377 // File: @openzeppelin/contracts/math/SafeMath.sol
378 
379 
380 
381 pragma solidity >=0.6.0 <0.8.0;
382 
383 /**
384  * @dev Wrappers over Solidity's arithmetic operations with added overflow
385  * checks.
386  *
387  * Arithmetic operations in Solidity wrap on overflow. This can easily result
388  * in bugs, because programmers usually assume that an overflow raises an
389  * error, which is the standard behavior in high level programming languages.
390  * `SafeMath` restores this intuition by reverting the transaction when an
391  * operation overflows.
392  *
393  * Using this library instead of the unchecked operations eliminates an entire
394  * class of bugs, so it's recommended to use it always.
395  */
396 library SafeMath {
397     /**
398      * @dev Returns the addition of two unsigned integers, with an overflow flag.
399      *
400      * _Available since v3.4._
401      */
402     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
403         uint256 c = a + b;
404         if (c < a) return (false, 0);
405         return (true, c);
406     }
407 
408     /**
409      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
410      *
411      * _Available since v3.4._
412      */
413     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
414         if (b > a) return (false, 0);
415         return (true, a - b);
416     }
417 
418     /**
419      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
420      *
421      * _Available since v3.4._
422      */
423     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
424         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
425         // benefit is lost if 'b' is also tested.
426         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
427         if (a == 0) return (true, 0);
428         uint256 c = a * b;
429         if (c / a != b) return (false, 0);
430         return (true, c);
431     }
432 
433     /**
434      * @dev Returns the division of two unsigned integers, with a division by zero flag.
435      *
436      * _Available since v3.4._
437      */
438     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
439         if (b == 0) return (false, 0);
440         return (true, a / b);
441     }
442 
443     /**
444      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
445      *
446      * _Available since v3.4._
447      */
448     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
449         if (b == 0) return (false, 0);
450         return (true, a % b);
451     }
452 
453     /**
454      * @dev Returns the addition of two unsigned integers, reverting on
455      * overflow.
456      *
457      * Counterpart to Solidity's `+` operator.
458      *
459      * Requirements:
460      *
461      * - Addition cannot overflow.
462      */
463     function add(uint256 a, uint256 b) internal pure returns (uint256) {
464         uint256 c = a + b;
465         require(c >= a, "SafeMath: addition overflow");
466         return c;
467     }
468 
469     /**
470      * @dev Returns the subtraction of two unsigned integers, reverting on
471      * overflow (when the result is negative).
472      *
473      * Counterpart to Solidity's `-` operator.
474      *
475      * Requirements:
476      *
477      * - Subtraction cannot overflow.
478      */
479     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
480         require(b <= a, "SafeMath: subtraction overflow");
481         return a - b;
482     }
483 
484     /**
485      * @dev Returns the multiplication of two unsigned integers, reverting on
486      * overflow.
487      *
488      * Counterpart to Solidity's `*` operator.
489      *
490      * Requirements:
491      *
492      * - Multiplication cannot overflow.
493      */
494     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
495         if (a == 0) return 0;
496         uint256 c = a * b;
497         require(c / a == b, "SafeMath: multiplication overflow");
498         return c;
499     }
500 
501     /**
502      * @dev Returns the integer division of two unsigned integers, reverting on
503      * division by zero. The result is rounded towards zero.
504      *
505      * Counterpart to Solidity's `/` operator. Note: this function uses a
506      * `revert` opcode (which leaves remaining gas untouched) while Solidity
507      * uses an invalid opcode to revert (consuming all remaining gas).
508      *
509      * Requirements:
510      *
511      * - The divisor cannot be zero.
512      */
513     function div(uint256 a, uint256 b) internal pure returns (uint256) {
514         require(b > 0, "SafeMath: division by zero");
515         return a / b;
516     }
517 
518     /**
519      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
520      * reverting when dividing by zero.
521      *
522      * Counterpart to Solidity's `%` operator. This function uses a `revert`
523      * opcode (which leaves remaining gas untouched) while Solidity uses an
524      * invalid opcode to revert (consuming all remaining gas).
525      *
526      * Requirements:
527      *
528      * - The divisor cannot be zero.
529      */
530     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
531         require(b > 0, "SafeMath: modulo by zero");
532         return a % b;
533     }
534 
535     /**
536      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
537      * overflow (when the result is negative).
538      *
539      * CAUTION: This function is deprecated because it requires allocating memory for the error
540      * message unnecessarily. For custom revert reasons use {trySub}.
541      *
542      * Counterpart to Solidity's `-` operator.
543      *
544      * Requirements:
545      *
546      * - Subtraction cannot overflow.
547      */
548     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
549         require(b <= a, errorMessage);
550         return a - b;
551     }
552 
553     /**
554      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
555      * division by zero. The result is rounded towards zero.
556      *
557      * CAUTION: This function is deprecated because it requires allocating memory for the error
558      * message unnecessarily. For custom revert reasons use {tryDiv}.
559      *
560      * Counterpart to Solidity's `/` operator. Note: this function uses a
561      * `revert` opcode (which leaves remaining gas untouched) while Solidity
562      * uses an invalid opcode to revert (consuming all remaining gas).
563      *
564      * Requirements:
565      *
566      * - The divisor cannot be zero.
567      */
568     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
569         require(b > 0, errorMessage);
570         return a / b;
571     }
572 
573     /**
574      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
575      * reverting with custom message when dividing by zero.
576      *
577      * CAUTION: This function is deprecated because it requires allocating memory for the error
578      * message unnecessarily. For custom revert reasons use {tryMod}.
579      *
580      * Counterpart to Solidity's `%` operator. This function uses a `revert`
581      * opcode (which leaves remaining gas untouched) while Solidity uses an
582      * invalid opcode to revert (consuming all remaining gas).
583      *
584      * Requirements:
585      *
586      * - The divisor cannot be zero.
587      */
588     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
589         require(b > 0, errorMessage);
590         return a % b;
591     }
592 }
593 
594 // File: @openzeppelin/contracts/utils/Address.sol
595 
596 
597 
598 pragma solidity >=0.6.2 <0.8.0;
599 
600 /**
601  * @dev Collection of functions related to the address type
602  */
603 library Address {
604     /**
605      * @dev Returns true if `account` is a contract.
606      *
607      * [IMPORTANT]
608      * ====
609      * It is unsafe to assume that an address for which this function returns
610      * false is an externally-owned account (EOA) and not a contract.
611      *
612      * Among others, `isContract` will return false for the following
613      * types of addresses:
614      *
615      *  - an externally-owned account
616      *  - a contract in construction
617      *  - an address where a contract will be created
618      *  - an address where a contract lived, but was destroyed
619      * ====
620      */
621     function isContract(address account) internal view returns (bool) {
622         // This method relies on extcodesize, which returns 0 for contracts in
623         // construction, since the code is only stored at the end of the
624         // constructor execution.
625 
626         uint256 size;
627         // solhint-disable-next-line no-inline-assembly
628         assembly { size := extcodesize(account) }
629         return size > 0;
630     }
631 
632     /**
633      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
634      * `recipient`, forwarding all available gas and reverting on errors.
635      *
636      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
637      * of certain opcodes, possibly making contracts go over the 2300 gas limit
638      * imposed by `transfer`, making them unable to receive funds via
639      * `transfer`. {sendValue} removes this limitation.
640      *
641      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
642      *
643      * IMPORTANT: because control is transferred to `recipient`, care must be
644      * taken to not create reentrancy vulnerabilities. Consider using
645      * {ReentrancyGuard} or the
646      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
647      */
648     function sendValue(address payable recipient, uint256 amount) internal {
649         require(address(this).balance >= amount, "Address: insufficient balance");
650 
651         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
652         (bool success, ) = recipient.call{ value: amount }("");
653         require(success, "Address: unable to send value, recipient may have reverted");
654     }
655 
656     /**
657      * @dev Performs a Solidity function call using a low level `call`. A
658      * plain`call` is an unsafe replacement for a function call: use this
659      * function instead.
660      *
661      * If `target` reverts with a revert reason, it is bubbled up by this
662      * function (like regular Solidity function calls).
663      *
664      * Returns the raw returned data. To convert to the expected return value,
665      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
666      *
667      * Requirements:
668      *
669      * - `target` must be a contract.
670      * - calling `target` with `data` must not revert.
671      *
672      * _Available since v3.1._
673      */
674     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
675       return functionCall(target, data, "Address: low-level call failed");
676     }
677 
678     /**
679      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
680      * `errorMessage` as a fallback revert reason when `target` reverts.
681      *
682      * _Available since v3.1._
683      */
684     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
685         return functionCallWithValue(target, data, 0, errorMessage);
686     }
687 
688     /**
689      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
690      * but also transferring `value` wei to `target`.
691      *
692      * Requirements:
693      *
694      * - the calling contract must have an ETH balance of at least `value`.
695      * - the called Solidity function must be `payable`.
696      *
697      * _Available since v3.1._
698      */
699     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
700         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
701     }
702 
703     /**
704      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
705      * with `errorMessage` as a fallback revert reason when `target` reverts.
706      *
707      * _Available since v3.1._
708      */
709     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
710         require(address(this).balance >= value, "Address: insufficient balance for call");
711         require(isContract(target), "Address: call to non-contract");
712 
713         // solhint-disable-next-line avoid-low-level-calls
714         (bool success, bytes memory returndata) = target.call{ value: value }(data);
715         return _verifyCallResult(success, returndata, errorMessage);
716     }
717 
718     /**
719      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
720      * but performing a static call.
721      *
722      * _Available since v3.3._
723      */
724     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
725         return functionStaticCall(target, data, "Address: low-level static call failed");
726     }
727 
728     /**
729      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
730      * but performing a static call.
731      *
732      * _Available since v3.3._
733      */
734     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
735         require(isContract(target), "Address: static call to non-contract");
736 
737         // solhint-disable-next-line avoid-low-level-calls
738         (bool success, bytes memory returndata) = target.staticcall(data);
739         return _verifyCallResult(success, returndata, errorMessage);
740     }
741 
742     /**
743      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
744      * but performing a delegate call.
745      *
746      * _Available since v3.4._
747      */
748     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
749         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
750     }
751 
752     /**
753      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
754      * but performing a delegate call.
755      *
756      * _Available since v3.4._
757      */
758     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
759         require(isContract(target), "Address: delegate call to non-contract");
760 
761         // solhint-disable-next-line avoid-low-level-calls
762         (bool success, bytes memory returndata) = target.delegatecall(data);
763         return _verifyCallResult(success, returndata, errorMessage);
764     }
765 
766     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
767         if (success) {
768             return returndata;
769         } else {
770             // Look for revert reason and bubble it up if present
771             if (returndata.length > 0) {
772                 // The easiest way to bubble the revert reason is using memory via assembly
773 
774                 // solhint-disable-next-line no-inline-assembly
775                 assembly {
776                     let returndata_size := mload(returndata)
777                     revert(add(32, returndata), returndata_size)
778                 }
779             } else {
780                 revert(errorMessage);
781             }
782         }
783     }
784 }
785 
786 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
787 
788 
789 
790 pragma solidity >=0.6.0 <0.8.0;
791 
792 /**
793  * @dev Library for managing
794  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
795  * types.
796  *
797  * Sets have the following properties:
798  *
799  * - Elements are added, removed, and checked for existence in constant time
800  * (O(1)).
801  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
802  *
803  * ```
804  * contract Example {
805  *     // Add the library methods
806  *     using EnumerableSet for EnumerableSet.AddressSet;
807  *
808  *     // Declare a set state variable
809  *     EnumerableSet.AddressSet private mySet;
810  * }
811  * ```
812  *
813  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
814  * and `uint256` (`UintSet`) are supported.
815  */
816 library EnumerableSet {
817     // To implement this library for multiple types with as little code
818     // repetition as possible, we write it in terms of a generic Set type with
819     // bytes32 values.
820     // The Set implementation uses private functions, and user-facing
821     // implementations (such as AddressSet) are just wrappers around the
822     // underlying Set.
823     // This means that we can only create new EnumerableSets for types that fit
824     // in bytes32.
825 
826     struct Set {
827         // Storage of set values
828         bytes32[] _values;
829 
830         // Position of the value in the `values` array, plus 1 because index 0
831         // means a value is not in the set.
832         mapping (bytes32 => uint256) _indexes;
833     }
834 
835     /**
836      * @dev Add a value to a set. O(1).
837      *
838      * Returns true if the value was added to the set, that is if it was not
839      * already present.
840      */
841     function _add(Set storage set, bytes32 value) private returns (bool) {
842         if (!_contains(set, value)) {
843             set._values.push(value);
844             // The value is stored at length-1, but we add 1 to all indexes
845             // and use 0 as a sentinel value
846             set._indexes[value] = set._values.length;
847             return true;
848         } else {
849             return false;
850         }
851     }
852 
853     /**
854      * @dev Removes a value from a set. O(1).
855      *
856      * Returns true if the value was removed from the set, that is if it was
857      * present.
858      */
859     function _remove(Set storage set, bytes32 value) private returns (bool) {
860         // We read and store the value's index to prevent multiple reads from the same storage slot
861         uint256 valueIndex = set._indexes[value];
862 
863         if (valueIndex != 0) { // Equivalent to contains(set, value)
864             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
865             // the array, and then remove the last element (sometimes called as 'swap and pop').
866             // This modifies the order of the array, as noted in {at}.
867 
868             uint256 toDeleteIndex = valueIndex - 1;
869             uint256 lastIndex = set._values.length - 1;
870 
871             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
872             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
873 
874             bytes32 lastvalue = set._values[lastIndex];
875 
876             // Move the last value to the index where the value to delete is
877             set._values[toDeleteIndex] = lastvalue;
878             // Update the index for the moved value
879             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
880 
881             // Delete the slot where the moved value was stored
882             set._values.pop();
883 
884             // Delete the index for the deleted slot
885             delete set._indexes[value];
886 
887             return true;
888         } else {
889             return false;
890         }
891     }
892 
893     /**
894      * @dev Returns true if the value is in the set. O(1).
895      */
896     function _contains(Set storage set, bytes32 value) private view returns (bool) {
897         return set._indexes[value] != 0;
898     }
899 
900     /**
901      * @dev Returns the number of values on the set. O(1).
902      */
903     function _length(Set storage set) private view returns (uint256) {
904         return set._values.length;
905     }
906 
907    /**
908     * @dev Returns the value stored at position `index` in the set. O(1).
909     *
910     * Note that there are no guarantees on the ordering of values inside the
911     * array, and it may change when more values are added or removed.
912     *
913     * Requirements:
914     *
915     * - `index` must be strictly less than {length}.
916     */
917     function _at(Set storage set, uint256 index) private view returns (bytes32) {
918         require(set._values.length > index, "EnumerableSet: index out of bounds");
919         return set._values[index];
920     }
921 
922     // Bytes32Set
923 
924     struct Bytes32Set {
925         Set _inner;
926     }
927 
928     /**
929      * @dev Add a value to a set. O(1).
930      *
931      * Returns true if the value was added to the set, that is if it was not
932      * already present.
933      */
934     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
935         return _add(set._inner, value);
936     }
937 
938     /**
939      * @dev Removes a value from a set. O(1).
940      *
941      * Returns true if the value was removed from the set, that is if it was
942      * present.
943      */
944     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
945         return _remove(set._inner, value);
946     }
947 
948     /**
949      * @dev Returns true if the value is in the set. O(1).
950      */
951     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
952         return _contains(set._inner, value);
953     }
954 
955     /**
956      * @dev Returns the number of values in the set. O(1).
957      */
958     function length(Bytes32Set storage set) internal view returns (uint256) {
959         return _length(set._inner);
960     }
961 
962    /**
963     * @dev Returns the value stored at position `index` in the set. O(1).
964     *
965     * Note that there are no guarantees on the ordering of values inside the
966     * array, and it may change when more values are added or removed.
967     *
968     * Requirements:
969     *
970     * - `index` must be strictly less than {length}.
971     */
972     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
973         return _at(set._inner, index);
974     }
975 
976     // AddressSet
977 
978     struct AddressSet {
979         Set _inner;
980     }
981 
982     /**
983      * @dev Add a value to a set. O(1).
984      *
985      * Returns true if the value was added to the set, that is if it was not
986      * already present.
987      */
988     function add(AddressSet storage set, address value) internal returns (bool) {
989         return _add(set._inner, bytes32(uint256(uint160(value))));
990     }
991 
992     /**
993      * @dev Removes a value from a set. O(1).
994      *
995      * Returns true if the value was removed from the set, that is if it was
996      * present.
997      */
998     function remove(AddressSet storage set, address value) internal returns (bool) {
999         return _remove(set._inner, bytes32(uint256(uint160(value))));
1000     }
1001 
1002     /**
1003      * @dev Returns true if the value is in the set. O(1).
1004      */
1005     function contains(AddressSet storage set, address value) internal view returns (bool) {
1006         return _contains(set._inner, bytes32(uint256(uint160(value))));
1007     }
1008 
1009     /**
1010      * @dev Returns the number of values in the set. O(1).
1011      */
1012     function length(AddressSet storage set) internal view returns (uint256) {
1013         return _length(set._inner);
1014     }
1015 
1016    /**
1017     * @dev Returns the value stored at position `index` in the set. O(1).
1018     *
1019     * Note that there are no guarantees on the ordering of values inside the
1020     * array, and it may change when more values are added or removed.
1021     *
1022     * Requirements:
1023     *
1024     * - `index` must be strictly less than {length}.
1025     */
1026     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1027         return address(uint160(uint256(_at(set._inner, index))));
1028     }
1029 
1030 
1031     // UintSet
1032 
1033     struct UintSet {
1034         Set _inner;
1035     }
1036 
1037     /**
1038      * @dev Add a value to a set. O(1).
1039      *
1040      * Returns true if the value was added to the set, that is if it was not
1041      * already present.
1042      */
1043     function add(UintSet storage set, uint256 value) internal returns (bool) {
1044         return _add(set._inner, bytes32(value));
1045     }
1046 
1047     /**
1048      * @dev Removes a value from a set. O(1).
1049      *
1050      * Returns true if the value was removed from the set, that is if it was
1051      * present.
1052      */
1053     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1054         return _remove(set._inner, bytes32(value));
1055     }
1056 
1057     /**
1058      * @dev Returns true if the value is in the set. O(1).
1059      */
1060     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1061         return _contains(set._inner, bytes32(value));
1062     }
1063 
1064     /**
1065      * @dev Returns the number of values on the set. O(1).
1066      */
1067     function length(UintSet storage set) internal view returns (uint256) {
1068         return _length(set._inner);
1069     }
1070 
1071    /**
1072     * @dev Returns the value stored at position `index` in the set. O(1).
1073     *
1074     * Note that there are no guarantees on the ordering of values inside the
1075     * array, and it may change when more values are added or removed.
1076     *
1077     * Requirements:
1078     *
1079     * - `index` must be strictly less than {length}.
1080     */
1081     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1082         return uint256(_at(set._inner, index));
1083     }
1084 }
1085 
1086 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1087 
1088 
1089 
1090 pragma solidity >=0.6.0 <0.8.0;
1091 
1092 /**
1093  * @dev Library for managing an enumerable variant of Solidity's
1094  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1095  * type.
1096  *
1097  * Maps have the following properties:
1098  *
1099  * - Entries are added, removed, and checked for existence in constant time
1100  * (O(1)).
1101  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1102  *
1103  * ```
1104  * contract Example {
1105  *     // Add the library methods
1106  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1107  *
1108  *     // Declare a set state variable
1109  *     EnumerableMap.UintToAddressMap private myMap;
1110  * }
1111  * ```
1112  *
1113  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1114  * supported.
1115  */
1116 library EnumerableMap {
1117     // To implement this library for multiple types with as little code
1118     // repetition as possible, we write it in terms of a generic Map type with
1119     // bytes32 keys and values.
1120     // The Map implementation uses private functions, and user-facing
1121     // implementations (such as Uint256ToAddressMap) are just wrappers around
1122     // the underlying Map.
1123     // This means that we can only create new EnumerableMaps for types that fit
1124     // in bytes32.
1125 
1126     struct MapEntry {
1127         bytes32 _key;
1128         bytes32 _value;
1129     }
1130 
1131     struct Map {
1132         // Storage of map keys and values
1133         MapEntry[] _entries;
1134 
1135         // Position of the entry defined by a key in the `entries` array, plus 1
1136         // because index 0 means a key is not in the map.
1137         mapping (bytes32 => uint256) _indexes;
1138     }
1139 
1140     /**
1141      * @dev Adds a key-value pair to a map, or updates the value for an existing
1142      * key. O(1).
1143      *
1144      * Returns true if the key was added to the map, that is if it was not
1145      * already present.
1146      */
1147     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1148         // We read and store the key's index to prevent multiple reads from the same storage slot
1149         uint256 keyIndex = map._indexes[key];
1150 
1151         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1152             map._entries.push(MapEntry({ _key: key, _value: value }));
1153             // The entry is stored at length-1, but we add 1 to all indexes
1154             // and use 0 as a sentinel value
1155             map._indexes[key] = map._entries.length;
1156             return true;
1157         } else {
1158             map._entries[keyIndex - 1]._value = value;
1159             return false;
1160         }
1161     }
1162 
1163     /**
1164      * @dev Removes a key-value pair from a map. O(1).
1165      *
1166      * Returns true if the key was removed from the map, that is if it was present.
1167      */
1168     function _remove(Map storage map, bytes32 key) private returns (bool) {
1169         // We read and store the key's index to prevent multiple reads from the same storage slot
1170         uint256 keyIndex = map._indexes[key];
1171 
1172         if (keyIndex != 0) { // Equivalent to contains(map, key)
1173             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1174             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1175             // This modifies the order of the array, as noted in {at}.
1176 
1177             uint256 toDeleteIndex = keyIndex - 1;
1178             uint256 lastIndex = map._entries.length - 1;
1179 
1180             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1181             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1182 
1183             MapEntry storage lastEntry = map._entries[lastIndex];
1184 
1185             // Move the last entry to the index where the entry to delete is
1186             map._entries[toDeleteIndex] = lastEntry;
1187             // Update the index for the moved entry
1188             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1189 
1190             // Delete the slot where the moved entry was stored
1191             map._entries.pop();
1192 
1193             // Delete the index for the deleted slot
1194             delete map._indexes[key];
1195 
1196             return true;
1197         } else {
1198             return false;
1199         }
1200     }
1201 
1202     /**
1203      * @dev Returns true if the key is in the map. O(1).
1204      */
1205     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1206         return map._indexes[key] != 0;
1207     }
1208 
1209     /**
1210      * @dev Returns the number of key-value pairs in the map. O(1).
1211      */
1212     function _length(Map storage map) private view returns (uint256) {
1213         return map._entries.length;
1214     }
1215 
1216    /**
1217     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1218     *
1219     * Note that there are no guarantees on the ordering of entries inside the
1220     * array, and it may change when more entries are added or removed.
1221     *
1222     * Requirements:
1223     *
1224     * - `index` must be strictly less than {length}.
1225     */
1226     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1227         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1228 
1229         MapEntry storage entry = map._entries[index];
1230         return (entry._key, entry._value);
1231     }
1232 
1233     /**
1234      * @dev Tries to returns the value associated with `key`.  O(1).
1235      * Does not revert if `key` is not in the map.
1236      */
1237     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1238         uint256 keyIndex = map._indexes[key];
1239         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1240         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1241     }
1242 
1243     /**
1244      * @dev Returns the value associated with `key`.  O(1).
1245      *
1246      * Requirements:
1247      *
1248      * - `key` must be in the map.
1249      */
1250     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1251         uint256 keyIndex = map._indexes[key];
1252         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1253         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1254     }
1255 
1256     /**
1257      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1258      *
1259      * CAUTION: This function is deprecated because it requires allocating memory for the error
1260      * message unnecessarily. For custom revert reasons use {_tryGet}.
1261      */
1262     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1263         uint256 keyIndex = map._indexes[key];
1264         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1265         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1266     }
1267 
1268     // UintToAddressMap
1269 
1270     struct UintToAddressMap {
1271         Map _inner;
1272     }
1273 
1274     /**
1275      * @dev Adds a key-value pair to a map, or updates the value for an existing
1276      * key. O(1).
1277      *
1278      * Returns true if the key was added to the map, that is if it was not
1279      * already present.
1280      */
1281     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1282         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1283     }
1284 
1285     /**
1286      * @dev Removes a value from a set. O(1).
1287      *
1288      * Returns true if the key was removed from the map, that is if it was present.
1289      */
1290     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1291         return _remove(map._inner, bytes32(key));
1292     }
1293 
1294     /**
1295      * @dev Returns true if the key is in the map. O(1).
1296      */
1297     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1298         return _contains(map._inner, bytes32(key));
1299     }
1300 
1301     /**
1302      * @dev Returns the number of elements in the map. O(1).
1303      */
1304     function length(UintToAddressMap storage map) internal view returns (uint256) {
1305         return _length(map._inner);
1306     }
1307 
1308    /**
1309     * @dev Returns the element stored at position `index` in the set. O(1).
1310     * Note that there are no guarantees on the ordering of values inside the
1311     * array, and it may change when more values are added or removed.
1312     *
1313     * Requirements:
1314     *
1315     * - `index` must be strictly less than {length}.
1316     */
1317     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1318         (bytes32 key, bytes32 value) = _at(map._inner, index);
1319         return (uint256(key), address(uint160(uint256(value))));
1320     }
1321 
1322     /**
1323      * @dev Tries to returns the value associated with `key`.  O(1).
1324      * Does not revert if `key` is not in the map.
1325      *
1326      * _Available since v3.4._
1327      */
1328     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1329         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1330         return (success, address(uint160(uint256(value))));
1331     }
1332 
1333     /**
1334      * @dev Returns the value associated with `key`.  O(1).
1335      *
1336      * Requirements:
1337      *
1338      * - `key` must be in the map.
1339      */
1340     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1341         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1342     }
1343 
1344     /**
1345      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1346      *
1347      * CAUTION: This function is deprecated because it requires allocating memory for the error
1348      * message unnecessarily. For custom revert reasons use {tryGet}.
1349      */
1350     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1351         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1352     }
1353 }
1354 
1355 // File: @openzeppelin/contracts/utils/Strings.sol
1356 
1357 
1358 
1359 pragma solidity >=0.6.0 <0.8.0;
1360 
1361 /**
1362  * @dev String operations.
1363  */
1364 library Strings {
1365     /**
1366      * @dev Converts a `uint256` to its ASCII `string` representation.
1367      */
1368     function toString(uint256 value) internal pure returns (string memory) {
1369         // Inspired by OraclizeAPI's implementation - MIT licence
1370         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1371 
1372         if (value == 0) {
1373             return "0";
1374         }
1375         uint256 temp = value;
1376         uint256 digits;
1377         while (temp != 0) {
1378             digits++;
1379             temp /= 10;
1380         }
1381         bytes memory buffer = new bytes(digits);
1382         uint256 index = digits - 1;
1383         temp = value;
1384         while (temp != 0) {
1385             buffer[index--] = bytes1(uint8(48 + temp % 10));
1386             temp /= 10;
1387         }
1388         return string(buffer);
1389     }
1390 }
1391 
1392 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1393 
1394 
1395 
1396 pragma solidity >=0.6.0 <0.8.0;
1397 
1398 /**
1399  * @title ERC721 Non-Fungible Token Standard basic implementation
1400  * @dev see https://eips.ethereum.org/EIPS/eip-721
1401  */
1402 
1403 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1404     using SafeMath for uint256;
1405     using Address for address;
1406     using EnumerableSet for EnumerableSet.UintSet;
1407     using EnumerableMap for EnumerableMap.UintToAddressMap;
1408     using Strings for uint256;
1409 
1410     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1411     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1412     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1413 
1414     // Mapping from holder address to their (enumerable) set of owned tokens
1415     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1416 
1417     // Enumerable mapping from token ids to their owners
1418     EnumerableMap.UintToAddressMap private _tokenOwners;
1419 
1420     // Mapping from token ID to approved address
1421     mapping (uint256 => address) private _tokenApprovals;
1422 
1423     // Mapping from owner to operator approvals
1424     mapping (address => mapping (address => bool)) private _operatorApprovals;
1425 
1426     // Token name
1427     string private _name;
1428 
1429     // Token symbol
1430     string private _symbol;
1431 
1432     // Optional mapping for token URIs
1433     mapping (uint256 => string) private _tokenURIs;
1434 
1435     // Base URI
1436     string private _baseURI;
1437 
1438     /*
1439      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1440      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1441      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1442      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1443      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1444      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1445      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1446      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1447      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1448      *
1449      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1450      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1451      */
1452     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1453 
1454     /*
1455      *     bytes4(keccak256('name()')) == 0x06fdde03
1456      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1457      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1458      *
1459      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1460      */
1461     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1462 
1463     /*
1464      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1465      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1466      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1467      *
1468      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1469      */
1470     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1471 
1472     /**
1473      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1474      */
1475     constructor (string memory name_, string memory symbol_) public {
1476         _name = name_;
1477         _symbol = symbol_;
1478 
1479         // register the supported interfaces to conform to ERC721 via ERC165
1480         _registerInterface(_INTERFACE_ID_ERC721);
1481         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1482         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1483     }
1484 
1485     /**
1486      * @dev See {IERC721-balanceOf}.
1487      */
1488     function balanceOf(address owner) public view virtual override returns (uint256) {
1489         require(owner != address(0), "ERC721: balance query for the zero address");
1490         return _holderTokens[owner].length();
1491     }
1492 
1493     /**
1494      * @dev See {IERC721-ownerOf}.
1495      */
1496     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1497         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1498     }
1499 
1500     /**
1501      * @dev See {IERC721Metadata-name}.
1502      */
1503     function name() public view virtual override returns (string memory) {
1504         return _name;
1505     }
1506 
1507     /**
1508      * @dev See {IERC721Metadata-symbol}.
1509      */
1510     function symbol() public view virtual override returns (string memory) {
1511         return _symbol;
1512     }
1513 
1514     /**
1515      * @dev See {IERC721Metadata-tokenURI}.
1516      */
1517     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1518         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1519 
1520         string memory _tokenURI = _tokenURIs[tokenId];
1521         string memory base = baseURI();
1522 
1523         // If there is no base URI, return the token URI.
1524         if (bytes(base).length == 0) {
1525             return _tokenURI;
1526         }
1527         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1528         if (bytes(_tokenURI).length > 0) {
1529             return string(abi.encodePacked(base, _tokenURI));
1530         }
1531         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1532         return string(abi.encodePacked(base, tokenId.toString()));
1533     }
1534 
1535     /**
1536     * @dev Returns the base URI set via {_setBaseURI}. This will be
1537     * automatically added as a prefix in {tokenURI} to each token's URI, or
1538     * to the token ID if no specific URI is set for that token ID.
1539     */
1540     function baseURI() public view virtual returns (string memory) {
1541         return _baseURI;
1542     }
1543 
1544     /**
1545      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1546      */
1547     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1548         return _holderTokens[owner].at(index);
1549     }
1550 
1551     /**
1552      * @dev See {IERC721Enumerable-totalSupply}.
1553      */
1554     function totalSupply() public view virtual override returns (uint256) {
1555         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1556         return _tokenOwners.length();
1557     }
1558 
1559     /**
1560      * @dev See {IERC721Enumerable-tokenByIndex}.
1561      */
1562     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1563         (uint256 tokenId, ) = _tokenOwners.at(index);
1564         return tokenId;
1565     }
1566 
1567     /**
1568      * @dev See {IERC721-approve}.
1569      */
1570     function approve(address to, uint256 tokenId) public virtual override {
1571         address owner = ERC721.ownerOf(tokenId);
1572         require(to != owner, "ERC721: approval to current owner");
1573 
1574         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1575             "ERC721: approve caller is not owner nor approved for all"
1576         );
1577 
1578         _approve(to, tokenId);
1579     }
1580 
1581     /**
1582      * @dev See {IERC721-getApproved}.
1583      */
1584     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1585         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1586 
1587         return _tokenApprovals[tokenId];
1588     }
1589 
1590     /**
1591      * @dev See {IERC721-setApprovalForAll}.
1592      */
1593     function setApprovalForAll(address operator, bool approved) public virtual override {
1594         require(operator != _msgSender(), "ERC721: approve to caller");
1595 
1596         _operatorApprovals[_msgSender()][operator] = approved;
1597         emit ApprovalForAll(_msgSender(), operator, approved);
1598     }
1599 
1600     /**
1601      * @dev See {IERC721-isApprovedForAll}.
1602      */
1603     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1604         return _operatorApprovals[owner][operator];
1605     }
1606 
1607     /**
1608      * @dev See {IERC721-transferFrom}.
1609      */
1610     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1611         //solhint-disable-next-line max-line-length
1612         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1613 
1614         _transfer(from, to, tokenId);
1615     }
1616 
1617     /**
1618      * @dev See {IERC721-safeTransferFrom}.
1619      */
1620     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1621         safeTransferFrom(from, to, tokenId, "");
1622     }
1623 
1624     /**
1625      * @dev See {IERC721-safeTransferFrom}.
1626      */
1627     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1628         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1629         _safeTransfer(from, to, tokenId, _data);
1630     }
1631 
1632     /**
1633      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1634      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1635      *
1636      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1637      *
1638      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1639      * implement alternative mechanisms to perform token transfer, such as signature-based.
1640      *
1641      * Requirements:
1642      *
1643      * - `from` cannot be the zero address.
1644      * - `to` cannot be the zero address.
1645      * - `tokenId` token must exist and be owned by `from`.
1646      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1647      *
1648      * Emits a {Transfer} event.
1649      */
1650     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1651         _transfer(from, to, tokenId);
1652         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1653     }
1654 
1655     /**
1656      * @dev Returns whether `tokenId` exists.
1657      *
1658      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1659      *
1660      * Tokens start existing when they are minted (`_mint`),
1661      * and stop existing when they are burned (`_burn`).
1662      */
1663     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1664         return _tokenOwners.contains(tokenId);
1665     }
1666 
1667     /**
1668      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1669      *
1670      * Requirements:
1671      *
1672      * - `tokenId` must exist.
1673      */
1674     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1675         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1676         address owner = ERC721.ownerOf(tokenId);
1677         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1678     }
1679 
1680     /**
1681      * @dev Safely mints `tokenId` and transfers it to `to`.
1682      *
1683      * Requirements:
1684      d*
1685      * - `tokenId` must not exist.
1686      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1687      *
1688      * Emits a {Transfer} event.
1689      */
1690     function _safeMint(address to, uint256 tokenId) internal virtual {
1691         _safeMint(to, tokenId, "");
1692     }
1693 
1694     /**
1695      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1696      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1697      */
1698     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1699         _mint(to, tokenId);
1700         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1701     }
1702 
1703     /**
1704      * @dev Mints `tokenId` and transfers it to `to`.
1705      *
1706      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1707      *
1708      * Requirements:
1709      *
1710      * - `tokenId` must not exist.
1711      * - `to` cannot be the zero address.
1712      *
1713      * Emits a {Transfer} event.
1714      */
1715     function _mint(address to, uint256 tokenId) internal virtual {
1716         require(to != address(0), "ERC721: mint to the zero address");
1717         require(!_exists(tokenId), "ERC721: token already minted");
1718 
1719         _beforeTokenTransfer(address(0), to, tokenId);
1720 
1721         _holderTokens[to].add(tokenId);
1722 
1723         _tokenOwners.set(tokenId, to);
1724 
1725         emit Transfer(address(0), to, tokenId);
1726     }
1727 
1728     /**
1729      * @dev Destroys `tokenId`.
1730      * The approval is cleared when the token is burned.
1731      *
1732      * Requirements:
1733      *
1734      * - `tokenId` must exist.
1735      *
1736      * Emits a {Transfer} event.
1737      */
1738     function _burn(uint256 tokenId) internal virtual {
1739         address owner = ERC721.ownerOf(tokenId); // internal owner
1740 
1741         _beforeTokenTransfer(owner, address(0), tokenId);
1742 
1743         // Clear approvals
1744         _approve(address(0), tokenId);
1745 
1746         // Clear metadata (if any)
1747         if (bytes(_tokenURIs[tokenId]).length != 0) {
1748             delete _tokenURIs[tokenId];
1749         }
1750 
1751         _holderTokens[owner].remove(tokenId);
1752 
1753         _tokenOwners.remove(tokenId);
1754 
1755         emit Transfer(owner, address(0), tokenId);
1756     }
1757 
1758     /**
1759      * @dev Transfers `tokenId` from `from` to `to`.
1760      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1761      *
1762      * Requirements:
1763      *
1764      * - `to` cannot be the zero address.
1765      * - `tokenId` token must be owned by `from`.
1766      *
1767      * Emits a {Transfer} event.
1768      */
1769     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1770         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1771         require(to != address(0), "ERC721: transfer to the zero address");
1772 
1773         _beforeTokenTransfer(from, to, tokenId);
1774 
1775         // Clear approvals from the previous owner
1776         _approve(address(0), tokenId);
1777 
1778         _holderTokens[from].remove(tokenId);
1779         _holderTokens[to].add(tokenId);
1780 
1781         _tokenOwners.set(tokenId, to);
1782 
1783         emit Transfer(from, to, tokenId);
1784     }
1785 
1786     /**
1787      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1788      *
1789      * Requirements:
1790      *
1791      * - `tokenId` must exist.
1792      */
1793     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1794         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1795         _tokenURIs[tokenId] = _tokenURI;
1796     }
1797 
1798     /**
1799      * @dev Internal function to set the base URI for all token IDs. It is
1800      * automatically added as a prefix to the value returned in {tokenURI},
1801      * or to the token ID if {tokenURI} is empty.
1802      */
1803     function _setBaseURI(string memory baseURI_) internal virtual {
1804         _baseURI = baseURI_;
1805     }
1806 
1807     /**
1808      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1809      * The call is not executed if the target address is not a contract.
1810      *
1811      * @param from address representing the previous owner of the given token ID
1812      * @param to target address that will receive the tokens
1813      * @param tokenId uint256 ID of the token to be transferred
1814      * @param _data bytes optional data to send along with the call
1815      * @return bool whether the call correctly returned the expected magic value
1816      */
1817     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1818         private returns (bool)
1819     {
1820         if (!to.isContract()) {
1821             return true;
1822         }
1823         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1824             IERC721Receiver(to).onERC721Received.selector,
1825             _msgSender(),
1826             from,
1827             tokenId,
1828             _data
1829         ), "ERC721: transfer to non ERC721Receiver implementer");
1830         bytes4 retval = abi.decode(returndata, (bytes4));
1831         return (retval == _ERC721_RECEIVED);
1832     }
1833 
1834     /**
1835      * @dev Approve `to` to operate on `tokenId`
1836      *
1837      * Emits an {Approval} event.
1838      */
1839     function _approve(address to, uint256 tokenId) internal virtual {
1840         _tokenApprovals[tokenId] = to;
1841         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1842     }
1843 
1844     /**
1845      * @dev Hook that is called before any token transfer. This includes minting
1846      * and burning.
1847      *
1848      * Calling conditions:
1849      *
1850      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1851      * transferred to `to`.
1852      * - When `from` is zero, `tokenId` will be minted for `to`.
1853      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1854      * - `from` cannot be the zero address.
1855      * - `to` cannot be the zero address.
1856      *
1857      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1858      */
1859     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1860 }
1861 
1862 // File: @openzeppelin/contracts/access/Ownable.sol
1863 
1864 pragma solidity >=0.6.0 <0.8.0;
1865 
1866 /**
1867  * @dev Contract module which provides a basic access control mechanism, where
1868  * there is an account (an owner) that can be granted exclusive access to
1869  * specific functions.
1870  *
1871  * By default, the owner account will be the one that deploys the contract. This
1872  * can later be changed with {transferOwnership}.
1873  *
1874  * This module is used through inheritance. It will make available the modifier
1875  * `onlyOwner`, which can be applied to your functions to restrict their use to
1876  * the owner.
1877  */
1878 abstract contract Ownable is Context {
1879     address private _owner;
1880 
1881     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1882 
1883     /**
1884      * @dev Initializes the contract setting the deployer as the initial owner.
1885      */
1886     constructor () internal {
1887         address msgSender = _msgSender();
1888         _owner = msgSender;
1889         emit OwnershipTransferred(address(0), msgSender);
1890     }
1891 
1892     /**
1893      * @dev Returns the address of the current owner.
1894      */
1895     function owner() public view virtual returns (address) {
1896         return _owner;
1897     }
1898 
1899     /**
1900      * @dev Throws if called by any account other than the owner.
1901      */
1902     modifier onlyOwner() {
1903         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1904         _;
1905     }
1906 
1907     /**
1908      * @dev Leaves the contract without owner. It will not be possible to call
1909      * `onlyOwner` functions anymore. Can only be called by the current owner.
1910      *
1911      * NOTE: Renouncing ownership will leave the contract without an owner,
1912      * thereby removing any functionality that is only available to the owner.
1913      */
1914     function renounceOwnership() public virtual onlyOwner {
1915         emit OwnershipTransferred(_owner, address(0));
1916         _owner = address(0);
1917     }
1918 
1919     /**
1920      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1921      * Can only be called by the current owner.
1922      */
1923     function transferOwnership(address newOwner) public virtual onlyOwner {
1924         require(newOwner != address(0), "Ownable: new owner is the zero address");
1925         emit OwnershipTransferred(_owner, newOwner);
1926         _owner = newOwner;
1927     }
1928 }
1929 
1930 /*
1931 Thanks again, BoringBananasCo!
1932 */
1933 
1934 pragma solidity ^0.7.0;
1935 pragma abicoder v2;
1936 
1937 contract SnakeCon is ERC721, Ownable {
1938 
1939     using SafeMath for uint256;
1940 
1941     string public SNAKE_PROVENANCE = ""; // IPFS URL WILL BE ADDED WHEN SNAKES ARE ALL SOLD OUT
1942 
1943     string public LICENSE_TEXT = ""; // IT IS WHAT IT SAYS
1944 
1945     bool licenseLocked = false; // TEAM CAN'T EDIT THE LICENSE AFTER THIS GETS TRUE
1946 
1947     uint256 public constant snakePrice = 20000000000000000; // 0.025 ETH
1948 
1949     uint public constant maxSnakePurchase = 20;
1950 
1951     uint256 public constant MAX_SNAKE = 3690;
1952 
1953     bool public saleIsActive = false;
1954 
1955     mapping(uint => string) public snakeNames;
1956 
1957     // Reserve 125 Snake for team - Giveaways/Prizes etc
1958     uint public snakeReserve = 125;
1959 
1960     event snakeNameChange(address _by, uint _tokenId, string _name);
1961 
1962     event licenseisLocked(string _licenseText);
1963 
1964     constructor() ERC721("Snakes On A Chain", "MYSNAKES") { }
1965 
1966     function withdraw() public onlyOwner {
1967         uint balance = address(this).balance;
1968         msg.sender.transfer(balance);
1969     }
1970 
1971     function reserveSnake(address _to, uint256 _reserveAmount) public onlyOwner {
1972         uint supply = totalSupply();
1973         require(_reserveAmount > 0 && _reserveAmount <= snakeReserve, "Not enough reserve left for team");
1974         for (uint i = 0; i < _reserveAmount; i++) {
1975             _safeMint(_to, supply + i);
1976         }
1977         snakeReserve = snakeReserve.sub(_reserveAmount);
1978     }
1979 
1980     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
1981         SNAKE_PROVENANCE = provenanceHash;
1982     }
1983 
1984     function setBaseURI(string memory baseURI) public onlyOwner {
1985         _setBaseURI(baseURI);
1986     }
1987 
1988     function flipSaleState() public onlyOwner {
1989         saleIsActive = !saleIsActive;
1990     }
1991 
1992     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
1993         uint256 tokenCount = balanceOf(_owner);
1994         if (tokenCount == 0) {
1995             // Return an empty array
1996             return new uint256[](0);
1997         } else {
1998             uint256[] memory result = new uint256[](tokenCount);
1999             uint256 index;
2000             for (index = 0; index < tokenCount; index++) {
2001                 result[index] = tokenOfOwnerByIndex(_owner, index);
2002             }
2003             return result;
2004         }
2005     }
2006 
2007     // Returns the license for tokens
2008     function tokenLicense(uint _id) public view returns(string memory) {
2009         require(_id < totalSupply(), "CHOOSE A SNAKE WITHIN RANGE");
2010         return LICENSE_TEXT;
2011     }
2012 
2013     // Locks the license to prevent further changes
2014     function lockLicense() public onlyOwner {
2015         licenseLocked =  true;
2016         emit licenseisLocked(LICENSE_TEXT);
2017     }
2018 
2019     // Change the license
2020     function changeLicense(string memory _license) public onlyOwner {
2021         require(licenseLocked == false, "License already locked");
2022         LICENSE_TEXT = _license;
2023     }
2024 
2025     function mintSnake(uint numberOfTokens) public payable {
2026         require(saleIsActive, "Sale must be active to mint Snake");
2027         require(numberOfTokens > 0 && numberOfTokens <= maxSnakePurchase, "Can only mint 20 tokens at a time");
2028         require(totalSupply().add(numberOfTokens) <= MAX_SNAKE, "Purchase would exceed max supply of Snake");
2029         require(msg.value >= snakePrice.mul(numberOfTokens), "Ether value sent is not correct");
2030 
2031         for(uint i = 0; i < numberOfTokens; i++) {
2032             uint mintIndex = totalSupply();
2033             if (totalSupply() < MAX_SNAKE) {
2034                 _safeMint(msg.sender, mintIndex);
2035             }
2036         }
2037 
2038     }
2039 
2040     function changeSnakeName(uint _tokenId, string memory _name) public {
2041         require(ownerOf(_tokenId) == msg.sender, "Hey, your wallet doesn't own this snake!");
2042         require(sha256(bytes(_name)) != sha256(bytes(snakeNames[_tokenId])), "New name is same as the current one");
2043         snakeNames[_tokenId] = _name;
2044 
2045         emit snakeNameChange(msg.sender, _tokenId, _name);
2046 
2047     }
2048 
2049     function viewSnakeName(uint _tokenId) public view returns( string memory ){
2050         require( _tokenId < totalSupply(), "Choose a snake within range" );
2051         return snakeNames[_tokenId];
2052     }
2053 
2054     // GET ALL SNAKES OF A WALLET AS AN ARRAY OF STRINGS. WOULD BE BETTER MAYBE IF IT RETURNED A STRUCT WITH ID-NAME MATCH
2055     function snakeNamesOfOwner(address _owner) external view returns(string[] memory ) {
2056         uint256 tokenCount = balanceOf(_owner);
2057         if (tokenCount == 0) {
2058             // Return an empty array
2059             return new string[](0);
2060         } else {
2061             string[] memory result = new string[](tokenCount);
2062             uint256 index;
2063             for (index = 0; index < tokenCount; index++) {
2064                 result[index] = snakeNames[ tokenOfOwnerByIndex(_owner, index) ] ;
2065             }
2066             return result;
2067         }
2068     }
2069 
2070 }