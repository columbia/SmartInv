1 /*
2 
3                                                                                                                                                       
4                                                                                                                                                       
5  -dddddddy`        sdddddh               -ddddh:     .dddddddd`              .ddddddy .ohddddy+`                hddddddddd+dddddddddd-`+yddddho``dddh 
6  /MMMMMMMMh       yMMMMMMM               /MMMMMM/    -MMMMMMMM.              :MMMMMMN/MMMMMMMMMm.               NMMMMMMMMMhMMMMMMMMMM+mMMMMMMMMN/MMMM`
7  /MMMMMMMMMy     sMMMMMMMM               /MMMMMMMo   -MMMMMMMM.              :MMMMMMNhMMMMMMMMMM+               NMMMMMMMMMhMMMMMMMMMMhMMMMMMMMMMhMMMM`
8   :/hMMMMMMMo   oMMMMMMo/-  -+oooooooo/. `:/hMMMMMs  -MMMMMs/++oooo/` -oooooo.:/sMMMNdMMMMMMMMMM+ `/oooooooo+-  -/oMMMMMMMhMMMMMMMh/:/MMMMMMMMMMhMMMM`
9     /MMMMMMMM+ +MMMMMMM   .dMMMMMMMMMMMMs   /MMMMMMy -MMMMM-hMMMMMMMN+sMMMMMM+  :MMMNdMMMMMMMMMM/sMMMMMMMMMMMMm.   NMMMMMMhMMMMMMM/  :MMMMMMMMMMhMMMM`
10     /MMMMMMMMMsMMMMMMMM   yMMMMMMMMMMMMMM:  /MMMMMMMh:MMMMMyMMMMMMMMMMyMMMMdd:  :MMMNmMMMMMMMMNo-MMMMMMMMMMMMMMy   NMMMMMMhMMMMMMM/  :MMMMMMMMMMdMMMM`
11     /MMmMMMMMMMMMMmMMMM   hMMMMMMMMMMMMMM/  /MMdMMMMMm+/yMMhMMMMMMMMMMhMMMo     :MMMMy/////oM/  :MMMMMMMMMMMMMMh   NMMMm+/.//yMMMM/  :MMMMy////+dMMMM`
12   ..sMM-NMMMMMMMMsoMMMM/.`hMMMMMMMMMMMMMM/..yMM`yMMMMMm.-MMhMMMMMMMMMMhMMMy.. `.+MMMM:     .MN/.:MMMMMMMMMMMMMMh`.:MMMMs     .MMMMy...NMMMNho/-`/NNNm 
13  :MMMMM`:MMMMMMMh oMMMMMMNhMMMMNmmmmNMMMMyMMMMM  oMMMMMN+MMhMMMMNmmmmNdMMMMMMyMMMMMMMNmmmmmNMMMMyMMMMNmmmmmMMMMhNMMMMMMNmmmmmNMMMMMMM/.odNMMMMMMmh+.  
14  /MMMMM` +MMMMMm` oMMMMMMMhMMMh     .MMMMhMMMMM   /NMMMMMMMhMMMm     `NMMMMMMhMMMMMMM/--yMMMMMMMhMMMM.     sMMMyNMMMMMMy-----:MMMMMMMossss-:+sdNMMMMo 
15  /MMMMM:``yMMMN-`.hMMMMMMMhMMMd.````:MMMMhMMMMM-`` -mMMMMMMhMMMm.````-NMMMMMMhMMMMMMM+`  oMMMMMMhMMMM/``````... NMMMMMMh.` ``/MMMMMMMhMMMM+````-MMMMN 
16  /MMMMMMMMyhMMoMMMMMMMMMMMsMMMMMMMMMMMMMMsMMMMMMMN  .dMMMMMsMMMMMMMMMNoMMMMMMhMMMMMMMMMhmMMMMMMMsMMMMMMMMMMMMMMyNMMMMMMMMMyMMMMMMMMMMsMMMMMMMMMMMMMMm 
17  :MMMMMMMMy`mo.MMMMMMMMMMN`oNMMMMMMMMMMd:/MMMMMMMN   `yMMMM.+mMMMMMMh- +mMMMMhMMMMMMMMMdmMMMMMMM+:dMMMMMMMMMMNy`NMMMMMMMMMhMMMMMMMMMM//dMMMMMMMMMMNh. 
18   --------` .  ----------.   .--------`   -------.     ----   .----`     .--- ---------`.-------   `--------.   .---------`.---------   `---------`   
19 
20 Monarchs (2021)
21 Eric Hu
22 in collaboration with Roy Tatum.
23 
24 Roll Call:
25 RT NS SL JF NS SL HR DMR EM MJ
26 May the homies prosper
27 
28 Once upon a time, I dreamt I was a butterfly, fluttering hither and thither, to all intents and purposes a butterfly. 
29 I was conscious only of my happiness as a butterfly, unaware that I was myself. 
30 Soon I awaked, and there I was, a man once again. 
31 
32 But now, I do not know whether I was then a man dreaming I was a butterfly, 
33 or whether I am now a butterfly, dreaming I am a man.
34 
35 —Zhuangzi (莊子), 3rd century BC
36 
37 
38 
39 */
40 
41 // SPDX-License-Identifier: MIT
42  
43 // File: @openzeppelin/contracts/utils/Context.sol
44 
45 pragma solidity >=0.6.0 <0.8.0;
46 
47 /*
48  * @dev Provides information about the current execution context, including the
49  * sender of the transaction and its data. While these are generally available
50  * via msg.sender and msg.data, they should not be accessed in such a direct
51  * manner, since when dealing with GSN meta-transactions the account sending and
52  * paying for execution may not be the actual sender (as far as an application
53  * is concerned).
54  *
55  * This contract is only required for intermediate, library-like contracts.
56  */
57 abstract contract Context {
58     function _msgSender() internal view virtual returns (address payable) {
59         return msg.sender;
60     }
61 
62     function _msgData() internal view virtual returns (bytes memory) {
63         this; // silence state mutability warning without generating bytecode - see https://github.com/ethereum/solidity/issues/2691
64         return msg.data;
65     }
66 }
67 
68 // File: @openzeppelin/contracts/introspection/IERC165.sol
69 
70 
71 
72 pragma solidity >=0.6.0 <0.8.0;
73 
74 /**
75  * @dev Interface of the ERC165 standard, as defined in the
76  * https://eips.ethereum.org/EIPS/eip-165[EIP].
77  *
78  * Implementers can declare support of contract interfaces, which can then be
79  * queried by others ({ERC165Checker}).
80  *
81  * For an implementation, see {ERC165}.
82  */
83 interface IERC165 {
84     /**
85      * @dev Returns true if this contract implements the interface defined by
86      * `interfaceId`. See the corresponding
87      * https://eips.ethereum.org/EIPS/eip-165#how-interfaces-are-identified[EIP section]
88      * to learn more about how these ids are created.
89      *
90      * This function call must use less than 30 000 gas.
91      */
92     function supportsInterface(bytes4 interfaceId) external view returns (bool);
93 }
94 
95 // File: @openzeppelin/contracts/token/ERC721/IERC721.sol
96 
97 
98 
99 pragma solidity >=0.6.2 <0.8.0;
100 
101 
102 /**
103  * @dev Required interface of an ERC721 compliant contract.
104  */
105 interface IERC721 is IERC165 {
106     /**
107      * @dev Emitted when `tokenId` token is transferred from `from` to `to`.
108      */
109     event Transfer(address indexed from, address indexed to, uint256 indexed tokenId);
110 
111     /**
112      * @dev Emitted when `owner` enables `approved` to manage the `tokenId` token.
113      */
114     event Approval(address indexed owner, address indexed approved, uint256 indexed tokenId);
115 
116     /**
117      * @dev Emitted when `owner` enables or disables (`approved`) `operator` to manage all of its assets.
118      */
119     event ApprovalForAll(address indexed owner, address indexed operator, bool approved);
120 
121     /**
122      * @dev Returns the number of tokens in ``owner``'s account.
123      */
124     function balanceOf(address owner) external view returns (uint256 balance);
125 
126     /**
127      * @dev Returns the owner of the `tokenId` token.
128      *
129      * Requirements:
130      *
131      * - `tokenId` must exist.
132      */
133     function ownerOf(uint256 tokenId) external view returns (address owner);
134 
135     /**
136      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
137      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
138      *
139      * Requirements:
140      *
141      * - `from` cannot be the zero address.
142      * - `to` cannot be the zero address.
143      * - `tokenId` token must exist and be owned by `from`.
144      * - If the caller is not `from`, it must be have been allowed to move this token by either {approve} or {setApprovalForAll}.
145      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
146      *
147      * Emits a {Transfer} event.
148      */
149     function safeTransferFrom(address from, address to, uint256 tokenId) external;
150 
151     /**
152      * @dev Transfers `tokenId` token from `from` to `to`.
153      *
154      * WARNING: Usage of this method is discouraged, use {safeTransferFrom} whenever possible.
155      *
156      * Requirements:
157      *
158      * - `from` cannot be the zero address.
159      * - `to` cannot be the zero address.
160      * - `tokenId` token must be owned by `from`.
161      * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
162      *
163      * Emits a {Transfer} event.
164      */
165     function transferFrom(address from, address to, uint256 tokenId) external;
166 
167     /**
168      * @dev Gives permission to `to` to transfer `tokenId` token to another account.
169      * The approval is cleared when the token is transferred.
170      *
171      * Only a single account can be approved at a time, so approving the zero address clears previous approvals.
172      *
173      * Requirements:
174      *
175      * - The caller must own the token or be an approved operator.
176      * - `tokenId` must exist.
177      *
178      * Emits an {Approval} event.
179      */
180     function approve(address to, uint256 tokenId) external;
181 
182     /**
183      * @dev Returns the account approved for `tokenId` token.
184      *
185      * Requirements:
186      *
187      * - `tokenId` must exist.
188      */
189     function getApproved(uint256 tokenId) external view returns (address operator);
190 
191     /**
192      * @dev Approve or remove `operator` as an operator for the caller.
193      * Operators can call {transferFrom} or {safeTransferFrom} for any token owned by the caller.
194      *
195      * Requirements:
196      *
197      * - The `operator` cannot be the caller.
198      *
199      * Emits an {ApprovalForAll} event.
200      */
201     function setApprovalForAll(address operator, bool _approved) external;
202 
203     /**
204      * @dev Returns if the `operator` is allowed to manage all of the assets of `owner`.
205      *
206      * See {setApprovalForAll}
207      */
208     function isApprovedForAll(address owner, address operator) external view returns (bool);
209 
210     /**
211       * @dev Safely transfers `tokenId` token from `from` to `to`.
212       *
213       * Requirements:
214       *
215       * - `from` cannot be the zero address.
216       * - `to` cannot be the zero address.
217       * - `tokenId` token must exist and be owned by `from`.
218       * - If the caller is not `from`, it must be approved to move this token by either {approve} or {setApprovalForAll}.
219       * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
220       *
221       * Emits a {Transfer} event.
222       */
223     function safeTransferFrom(address from, address to, uint256 tokenId, bytes calldata data) external;
224 }
225 
226 // File: @openzeppelin/contracts/token/ERC721/IERC721Metadata.sol
227 
228 
229 
230 pragma solidity >=0.6.2 <0.8.0;
231 
232 
233 /**
234  * @title ERC-721 Non-Fungible Token Standard, optional metadata extension
235  * @dev See https://eips.ethereum.org/EIPS/eip-721
236  */
237 interface IERC721Metadata is IERC721 {
238 
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
257 
258 
259 pragma solidity >=0.6.2 <0.8.0;
260 
261 
262 /**
263  * @title ERC-721 Non-Fungible Token Standard, optional enumeration extension
264  * @dev See https://eips.ethereum.org/EIPS/eip-721
265  */
266 interface IERC721Enumerable is IERC721 {
267 
268     /**
269      * @dev Returns the total amount of tokens stored by the contract.
270      */
271     function totalSupply() external view returns (uint256);
272 
273     /**
274      * @dev Returns a token ID owned by `owner` at a given `index` of its token list.
275      * Use along with {balanceOf} to enumerate all of ``owner``'s tokens.
276      */
277     function tokenOfOwnerByIndex(address owner, uint256 index) external view returns (uint256 tokenId);
278 
279     /**
280      * @dev Returns a token ID at a given `index` of all the tokens stored by the contract.
281      * Use along with {totalSupply} to enumerate all tokens.
282      */
283     function tokenByIndex(uint256 index) external view returns (uint256);
284 }
285 
286 // File: @openzeppelin/contracts/token/ERC721/IERC721Receiver.sol
287 
288 
289 
290 pragma solidity >=0.6.0 <0.8.0;
291 
292 /**
293  * @title ERC721 token receiver interface
294  * @dev Interface for any contract that wants to support safeTransfers
295  * from ERC721 asset contracts.
296  */
297 interface IERC721Receiver {
298     /**
299      * @dev Whenever an {IERC721} `tokenId` token is transferred to this contract via {IERC721-safeTransferFrom}
300      * by `operator` from `from`, this function is called.
301      *
302      * It must return its Solidity selector to confirm the token transfer.
303      * If any other value is returned or the interface is not implemented by the recipient, the transfer will be reverted.
304      *
305      * The selector can be obtained in Solidity with `IERC721.onERC721Received.selector`.
306      */
307     function onERC721Received(address operator, address from, uint256 tokenId, bytes calldata data) external returns (bytes4);
308 }
309 
310 // File: @openzeppelin/contracts/introspection/ERC165.sol
311 
312 
313 
314 pragma solidity >=0.6.0 <0.8.0;
315 
316 
317 /**
318  * @dev Implementation of the {IERC165} interface.
319  *
320  * Contracts may inherit from this and call {_registerInterface} to declare
321  * their support of an interface.
322  */
323 abstract contract ERC165 is IERC165 {
324     /*
325      * bytes4(keccak256('supportsInterface(bytes4)')) == 0x01ffc9a7
326      */
327     bytes4 private constant _INTERFACE_ID_ERC165 = 0x01ffc9a7;
328 
329     /**
330      * @dev Mapping of interface ids to whether or not it's supported.
331      */
332     mapping(bytes4 => bool) private _supportedInterfaces;
333 
334     constructor () internal {
335         // Derived contracts need only register support for their own interfaces,
336         // we register support for ERC165 itself here
337         _registerInterface(_INTERFACE_ID_ERC165);
338     }
339 
340     /**
341      * @dev See {IERC165-supportsInterface}.
342      *
343      * Time complexity O(1), guaranteed to always use less than 30 000 gas.
344      */
345     function supportsInterface(bytes4 interfaceId) public view virtual override returns (bool) {
346         return _supportedInterfaces[interfaceId];
347     }
348 
349     /**
350      * @dev Registers the contract as an implementer of the interface defined by
351      * `interfaceId`. Support of the actual ERC165 interface is automatic and
352      * registering its interface id is not required.
353      *
354      * See {IERC165-supportsInterface}.
355      *
356      * Requirements:
357      *
358      * - `interfaceId` cannot be the ERC165 invalid interface (`0xffffffff`).
359      */
360     function _registerInterface(bytes4 interfaceId) internal virtual {
361         require(interfaceId != 0xffffffff, "ERC165: invalid interface id");
362         _supportedInterfaces[interfaceId] = true;
363     }
364 }
365 
366 // File: @openzeppelin/contracts/math/SafeMath.sol
367 
368 
369 
370 pragma solidity >=0.6.0 <0.8.0;
371 
372 /**
373  * @dev Wrappers over Solidity's arithmetic operations with added overflow
374  * checks.
375  *
376  * Arithmetic operations in Solidity wrap on overflow. This can easily result
377  * in bugs, because programmers usually assume that an overflow raises an
378  * error, which is the standard behavior in high level programming languages.
379  * `SafeMath` restores this intuition by reverting the transaction when an
380  * operation overflows.
381  *
382  * Using this library instead of the unchecked operations eliminates an entire
383  * class of bugs, so it's recommended to use it always.
384  */
385 library SafeMath {
386     /**
387      * @dev Returns the addition of two unsigned integers, with an overflow flag.
388      *
389      * _Available since v3.4._
390      */
391     function tryAdd(uint256 a, uint256 b) internal pure returns (bool, uint256) {
392         uint256 c = a + b;
393         if (c < a) return (false, 0);
394         return (true, c);
395     }
396 
397     /**
398      * @dev Returns the substraction of two unsigned integers, with an overflow flag.
399      *
400      * _Available since v3.4._
401      */
402     function trySub(uint256 a, uint256 b) internal pure returns (bool, uint256) {
403         if (b > a) return (false, 0);
404         return (true, a - b);
405     }
406 
407     /**
408      * @dev Returns the multiplication of two unsigned integers, with an overflow flag.
409      *
410      * _Available since v3.4._
411      */
412     function tryMul(uint256 a, uint256 b) internal pure returns (bool, uint256) {
413         // Gas optimization: this is cheaper than requiring 'a' not being zero, but the
414         // benefit is lost if 'b' is also tested.
415         // See: https://github.com/OpenZeppelin/openzeppelin-contracts/pull/522
416         if (a == 0) return (true, 0);
417         uint256 c = a * b;
418         if (c / a != b) return (false, 0);
419         return (true, c);
420     }
421 
422     /**
423      * @dev Returns the division of two unsigned integers, with a division by zero flag.
424      *
425      * _Available since v3.4._
426      */
427     function tryDiv(uint256 a, uint256 b) internal pure returns (bool, uint256) {
428         if (b == 0) return (false, 0);
429         return (true, a / b);
430     }
431 
432     /**
433      * @dev Returns the remainder of dividing two unsigned integers, with a division by zero flag.
434      *
435      * _Available since v3.4._
436      */
437     function tryMod(uint256 a, uint256 b) internal pure returns (bool, uint256) {
438         if (b == 0) return (false, 0);
439         return (true, a % b);
440     }
441 
442     /**
443      * @dev Returns the addition of two unsigned integers, reverting on
444      * overflow.
445      *
446      * Counterpart to Solidity's `+` operator.
447      *
448      * Requirements:
449      *
450      * - Addition cannot overflow.
451      */
452     function add(uint256 a, uint256 b) internal pure returns (uint256) {
453         uint256 c = a + b;
454         require(c >= a, "SafeMath: addition overflow");
455         return c;
456     }
457 
458     /**
459      * @dev Returns the subtraction of two unsigned integers, reverting on
460      * overflow (when the result is negative).
461      *
462      * Counterpart to Solidity's `-` operator.
463      *
464      * Requirements:
465      *
466      * - Subtraction cannot overflow.
467      */
468     function sub(uint256 a, uint256 b) internal pure returns (uint256) {
469         require(b <= a, "SafeMath: subtraction overflow");
470         return a - b;
471     }
472 
473     /**
474      * @dev Returns the multiplication of two unsigned integers, reverting on
475      * overflow.
476      *
477      * Counterpart to Solidity's `*` operator.
478      *
479      * Requirements:
480      *
481      * - Multiplication cannot overflow.
482      */
483     function mul(uint256 a, uint256 b) internal pure returns (uint256) {
484         if (a == 0) return 0;
485         uint256 c = a * b;
486         require(c / a == b, "SafeMath: multiplication overflow");
487         return c;
488     }
489 
490     /**
491      * @dev Returns the integer division of two unsigned integers, reverting on
492      * division by zero. The result is rounded towards zero.
493      *
494      * Counterpart to Solidity's `/` operator. Note: this function uses a
495      * `revert` opcode (which leaves remaining gas untouched) while Solidity
496      * uses an invalid opcode to revert (consuming all remaining gas).
497      *
498      * Requirements:
499      *
500      * - The divisor cannot be zero.
501      */
502     function div(uint256 a, uint256 b) internal pure returns (uint256) {
503         require(b > 0, "SafeMath: division by zero");
504         return a / b;
505     }
506 
507     /**
508      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
509      * reverting when dividing by zero.
510      *
511      * Counterpart to Solidity's `%` operator. This function uses a `revert`
512      * opcode (which leaves remaining gas untouched) while Solidity uses an
513      * invalid opcode to revert (consuming all remaining gas).
514      *
515      * Requirements:
516      *
517      * - The divisor cannot be zero.
518      */
519     function mod(uint256 a, uint256 b) internal pure returns (uint256) {
520         require(b > 0, "SafeMath: modulo by zero");
521         return a % b;
522     }
523 
524     /**
525      * @dev Returns the subtraction of two unsigned integers, reverting with custom message on
526      * overflow (when the result is negative).
527      *
528      * CAUTION: This function is deprecated because it requires allocating memory for the error
529      * message unnecessarily. For custom revert reasons use {trySub}.
530      *
531      * Counterpart to Solidity's `-` operator.
532      *
533      * Requirements:
534      *
535      * - Subtraction cannot overflow.
536      */
537     function sub(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
538         require(b <= a, errorMessage);
539         return a - b;
540     }
541 
542     /**
543      * @dev Returns the integer division of two unsigned integers, reverting with custom message on
544      * division by zero. The result is rounded towards zero.
545      *
546      * CAUTION: This function is deprecated because it requires allocating memory for the error
547      * message unnecessarily. For custom revert reasons use {tryDiv}.
548      *
549      * Counterpart to Solidity's `/` operator. Note: this function uses a
550      * `revert` opcode (which leaves remaining gas untouched) while Solidity
551      * uses an invalid opcode to revert (consuming all remaining gas).
552      *
553      * Requirements:
554      *
555      * - The divisor cannot be zero.
556      */
557     function div(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
558         require(b > 0, errorMessage);
559         return a / b;
560     }
561 
562     /**
563      * @dev Returns the remainder of dividing two unsigned integers. (unsigned integer modulo),
564      * reverting with custom message when dividing by zero.
565      *
566      * CAUTION: This function is deprecated because it requires allocating memory for the error
567      * message unnecessarily. For custom revert reasons use {tryMod}.
568      *
569      * Counterpart to Solidity's `%` operator. This function uses a `revert`
570      * opcode (which leaves remaining gas untouched) while Solidity uses an
571      * invalid opcode to revert (consuming all remaining gas).
572      *
573      * Requirements:
574      *
575      * - The divisor cannot be zero.
576      */
577     function mod(uint256 a, uint256 b, string memory errorMessage) internal pure returns (uint256) {
578         require(b > 0, errorMessage);
579         return a % b;
580     }
581 }
582 
583 // File: @openzeppelin/contracts/utils/Address.sol
584 
585 
586 
587 pragma solidity >=0.6.2 <0.8.0;
588 
589 /**
590  * @dev Collection of functions related to the address type
591  */
592 library Address {
593     /**
594      * @dev Returns true if `account` is a contract.
595      *
596      * [IMPORTANT]
597      * ====
598      * It is unsafe to assume that an address for which this function returns
599      * false is an externally-owned account (EOA) and not a contract.
600      *
601      * Among others, `isContract` will return false for the following
602      * types of addresses:
603      *
604      *  - an externally-owned account
605      *  - a contract in construction
606      *  - an address where a contract will be created
607      *  - an address where a contract lived, but was destroyed
608      * ====
609      */
610     function isContract(address account) internal view returns (bool) {
611         // This method relies on extcodesize, which returns 0 for contracts in
612         // construction, since the code is only stored at the end of the
613         // constructor execution.
614 
615         uint256 size;
616         // solhint-disable-next-line no-inline-assembly
617         assembly { size := extcodesize(account) }
618         return size > 0;
619     }
620 
621     /**
622      * @dev Replacement for Solidity's `transfer`: sends `amount` wei to
623      * `recipient`, forwarding all available gas and reverting on errors.
624      *
625      * https://eips.ethereum.org/EIPS/eip-1884[EIP1884] increases the gas cost
626      * of certain opcodes, possibly making contracts go over the 2300 gas limit
627      * imposed by `transfer`, making them unable to receive funds via
628      * `transfer`. {sendValue} removes this limitation.
629      *
630      * https://diligence.consensys.net/posts/2019/09/stop-using-soliditys-transfer-now/[Learn more].
631      *
632      * IMPORTANT: because control is transferred to `recipient`, care must be
633      * taken to not create reentrancy vulnerabilities. Consider using
634      * {ReentrancyGuard} or the
635      * https://solidity.readthedocs.io/en/v0.5.11/security-considerations.html#use-the-checks-effects-interactions-pattern[checks-effects-interactions pattern].
636      */
637     function sendValue(address payable recipient, uint256 amount) internal {
638         require(address(this).balance >= amount, "Address: insufficient balance");
639 
640         // solhint-disable-next-line avoid-low-level-calls, avoid-call-value
641         (bool success, ) = recipient.call{ value: amount }("");
642         require(success, "Address: unable to send value, recipient may have reverted");
643     }
644 
645     /**
646      * @dev Performs a Solidity function call using a low level `call`. A
647      * plain`call` is an unsafe replacement for a function call: use this
648      * function instead.
649      *
650      * If `target` reverts with a revert reason, it is bubbled up by this
651      * function (like regular Solidity function calls).
652      *
653      * Returns the raw returned data. To convert to the expected return value,
654      * use https://solidity.readthedocs.io/en/latest/units-and-global-variables.html?highlight=abi.decode#abi-encoding-and-decoding-functions[`abi.decode`].
655      *
656      * Requirements:
657      *
658      * - `target` must be a contract.
659      * - calling `target` with `data` must not revert.
660      *
661      * _Available since v3.1._
662      */
663     function functionCall(address target, bytes memory data) internal returns (bytes memory) {
664       return functionCall(target, data, "Address: low-level call failed");
665     }
666 
667     /**
668      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`], but with
669      * `errorMessage` as a fallback revert reason when `target` reverts.
670      *
671      * _Available since v3.1._
672      */
673     function functionCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
674         return functionCallWithValue(target, data, 0, errorMessage);
675     }
676 
677     /**
678      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
679      * but also transferring `value` wei to `target`.
680      *
681      * Requirements:
682      *
683      * - the calling contract must have an ETH balance of at least `value`.
684      * - the called Solidity function must be `payable`.
685      *
686      * _Available since v3.1._
687      */
688     function functionCallWithValue(address target, bytes memory data, uint256 value) internal returns (bytes memory) {
689         return functionCallWithValue(target, data, value, "Address: low-level call with value failed");
690     }
691 
692     /**
693      * @dev Same as {xref-Address-functionCallWithValue-address-bytes-uint256-}[`functionCallWithValue`], but
694      * with `errorMessage` as a fallback revert reason when `target` reverts.
695      *
696      * _Available since v3.1._
697      */
698     function functionCallWithValue(address target, bytes memory data, uint256 value, string memory errorMessage) internal returns (bytes memory) {
699         require(address(this).balance >= value, "Address: insufficient balance for call");
700         require(isContract(target), "Address: call to non-contract");
701 
702         // solhint-disable-next-line avoid-low-level-calls
703         (bool success, bytes memory returndata) = target.call{ value: value }(data);
704         return _verifyCallResult(success, returndata, errorMessage);
705     }
706 
707     /**
708      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
709      * but performing a static call.
710      *
711      * _Available since v3.3._
712      */
713     function functionStaticCall(address target, bytes memory data) internal view returns (bytes memory) {
714         return functionStaticCall(target, data, "Address: low-level static call failed");
715     }
716 
717     /**
718      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
719      * but performing a static call.
720      *
721      * _Available since v3.3._
722      */
723     function functionStaticCall(address target, bytes memory data, string memory errorMessage) internal view returns (bytes memory) {
724         require(isContract(target), "Address: static call to non-contract");
725 
726         // solhint-disable-next-line avoid-low-level-calls
727         (bool success, bytes memory returndata) = target.staticcall(data);
728         return _verifyCallResult(success, returndata, errorMessage);
729     }
730 
731     /**
732      * @dev Same as {xref-Address-functionCall-address-bytes-}[`functionCall`],
733      * but performing a delegate call.
734      *
735      * _Available since v3.4._
736      */
737     function functionDelegateCall(address target, bytes memory data) internal returns (bytes memory) {
738         return functionDelegateCall(target, data, "Address: low-level delegate call failed");
739     }
740 
741     /**
742      * @dev Same as {xref-Address-functionCall-address-bytes-string-}[`functionCall`],
743      * but performing a delegate call.
744      *
745      * _Available since v3.4._
746      */
747     function functionDelegateCall(address target, bytes memory data, string memory errorMessage) internal returns (bytes memory) {
748         require(isContract(target), "Address: delegate call to non-contract");
749 
750         // solhint-disable-next-line avoid-low-level-calls
751         (bool success, bytes memory returndata) = target.delegatecall(data);
752         return _verifyCallResult(success, returndata, errorMessage);
753     }
754 
755     function _verifyCallResult(bool success, bytes memory returndata, string memory errorMessage) private pure returns(bytes memory) {
756         if (success) {
757             return returndata;
758         } else {
759             // Look for revert reason and bubble it up if present
760             if (returndata.length > 0) {
761                 // The easiest way to bubble the revert reason is using memory via assembly
762 
763                 // solhint-disable-next-line no-inline-assembly
764                 assembly {
765                     let returndata_size := mload(returndata)
766                     revert(add(32, returndata), returndata_size)
767                 }
768             } else {
769                 revert(errorMessage);
770             }
771         }
772     }
773 }
774 
775 // File: @openzeppelin/contracts/utils/EnumerableSet.sol
776 
777 
778 
779 pragma solidity >=0.6.0 <0.8.0;
780 
781 /**
782  * @dev Library for managing
783  * https://en.wikipedia.org/wiki/Set_(abstract_data_type)[sets] of primitive
784  * types.
785  *
786  * Sets have the following properties:
787  *
788  * - Elements are added, removed, and checked for existence in constant time
789  * (O(1)).
790  * - Elements are enumerated in O(n). No guarantees are made on the ordering.
791  *
792  * ```
793  * contract Example {
794  *     // Add the library methods
795  *     using EnumerableSet for EnumerableSet.AddressSet;
796  *
797  *     // Declare a set state variable
798  *     EnumerableSet.AddressSet private mySet;
799  * }
800  * ```
801  *
802  * As of v3.3.0, sets of type `bytes32` (`Bytes32Set`), `address` (`AddressSet`)
803  * and `uint256` (`UintSet`) are supported.
804  */
805 library EnumerableSet {
806     // To implement this library for multiple types with as little code
807     // repetition as possible, we write it in terms of a generic Set type with
808     // bytes32 values.
809     // The Set implementation uses private functions, and user-facing
810     // implementations (such as AddressSet) are just wrappers around the
811     // underlying Set.
812     // This means that we can only create new EnumerableSets for types that fit
813     // in bytes32.
814 
815     struct Set {
816         // Storage of set values
817         bytes32[] _values;
818 
819         // Position of the value in the `values` array, plus 1 because index 0
820         // means a value is not in the set.
821         mapping (bytes32 => uint256) _indexes;
822     }
823 
824     /**
825      * @dev Add a value to a set. O(1).
826      *
827      * Returns true if the value was added to the set, that is if it was not
828      * already present.
829      */
830     function _add(Set storage set, bytes32 value) private returns (bool) {
831         if (!_contains(set, value)) {
832             set._values.push(value);
833             // The value is stored at length-1, but we add 1 to all indexes
834             // and use 0 as a sentinel value
835             set._indexes[value] = set._values.length;
836             return true;
837         } else {
838             return false;
839         }
840     }
841 
842     /**
843      * @dev Removes a value from a set. O(1).
844      *
845      * Returns true if the value was removed from the set, that is if it was
846      * present.
847      */
848     function _remove(Set storage set, bytes32 value) private returns (bool) {
849         // We read and store the value's index to prevent multiple reads from the same storage slot
850         uint256 valueIndex = set._indexes[value];
851 
852         if (valueIndex != 0) { // Equivalent to contains(set, value)
853             // To delete an element from the _values array in O(1), we swap the element to delete with the last one in
854             // the array, and then remove the last element (sometimes called as 'swap and pop').
855             // This modifies the order of the array, as noted in {at}.
856 
857             uint256 toDeleteIndex = valueIndex - 1;
858             uint256 lastIndex = set._values.length - 1;
859 
860             // When the value to delete is the last one, the swap operation is unnecessary. However, since this occurs
861             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
862 
863             bytes32 lastvalue = set._values[lastIndex];
864 
865             // Move the last value to the index where the value to delete is
866             set._values[toDeleteIndex] = lastvalue;
867             // Update the index for the moved value
868             set._indexes[lastvalue] = toDeleteIndex + 1; // All indexes are 1-based
869 
870             // Delete the slot where the moved value was stored
871             set._values.pop();
872 
873             // Delete the index for the deleted slot
874             delete set._indexes[value];
875 
876             return true;
877         } else {
878             return false;
879         }
880     }
881 
882     /**
883      * @dev Returns true if the value is in the set. O(1).
884      */
885     function _contains(Set storage set, bytes32 value) private view returns (bool) {
886         return set._indexes[value] != 0;
887     }
888 
889     /**
890      * @dev Returns the number of values on the set. O(1).
891      */
892     function _length(Set storage set) private view returns (uint256) {
893         return set._values.length;
894     }
895 
896    /**
897     * @dev Returns the value stored at position `index` in the set. O(1).
898     *
899     * Note that there are no guarantees on the ordering of values inside the
900     * array, and it may change when more values are added or removed.
901     *
902     * Requirements:
903     *
904     * - `index` must be strictly less than {length}.
905     */
906     function _at(Set storage set, uint256 index) private view returns (bytes32) {
907         require(set._values.length > index, "EnumerableSet: index out of bounds");
908         return set._values[index];
909     }
910 
911     // Bytes32Set
912 
913     struct Bytes32Set {
914         Set _inner;
915     }
916 
917     /**
918      * @dev Add a value to a set. O(1).
919      *
920      * Returns true if the value was added to the set, that is if it was not
921      * already present.
922      */
923     function add(Bytes32Set storage set, bytes32 value) internal returns (bool) {
924         return _add(set._inner, value);
925     }
926 
927     /**
928      * @dev Removes a value from a set. O(1).
929      *
930      * Returns true if the value was removed from the set, that is if it was
931      * present.
932      */
933     function remove(Bytes32Set storage set, bytes32 value) internal returns (bool) {
934         return _remove(set._inner, value);
935     }
936 
937     /**
938      * @dev Returns true if the value is in the set. O(1).
939      */
940     function contains(Bytes32Set storage set, bytes32 value) internal view returns (bool) {
941         return _contains(set._inner, value);
942     }
943 
944     /**
945      * @dev Returns the number of values in the set. O(1).
946      */
947     function length(Bytes32Set storage set) internal view returns (uint256) {
948         return _length(set._inner);
949     }
950 
951    /**
952     * @dev Returns the value stored at position `index` in the set. O(1).
953     *
954     * Note that there are no guarantees on the ordering of values inside the
955     * array, and it may change when more values are added or removed.
956     *
957     * Requirements:
958     *
959     * - `index` must be strictly less than {length}.
960     */
961     function at(Bytes32Set storage set, uint256 index) internal view returns (bytes32) {
962         return _at(set._inner, index);
963     }
964 
965     // AddressSet
966 
967     struct AddressSet {
968         Set _inner;
969     }
970 
971     /**
972      * @dev Add a value to a set. O(1).
973      *
974      * Returns true if the value was added to the set, that is if it was not
975      * already present.
976      */
977     function add(AddressSet storage set, address value) internal returns (bool) {
978         return _add(set._inner, bytes32(uint256(uint160(value))));
979     }
980 
981     /**
982      * @dev Removes a value from a set. O(1).
983      *
984      * Returns true if the value was removed from the set, that is if it was
985      * present.
986      */
987     function remove(AddressSet storage set, address value) internal returns (bool) {
988         return _remove(set._inner, bytes32(uint256(uint160(value))));
989     }
990 
991     /**
992      * @dev Returns true if the value is in the set. O(1).
993      */
994     function contains(AddressSet storage set, address value) internal view returns (bool) {
995         return _contains(set._inner, bytes32(uint256(uint160(value))));
996     }
997 
998     /**
999      * @dev Returns the number of values in the set. O(1).
1000      */
1001     function length(AddressSet storage set) internal view returns (uint256) {
1002         return _length(set._inner);
1003     }
1004 
1005    /**
1006     * @dev Returns the value stored at position `index` in the set. O(1).
1007     *
1008     * Note that there are no guarantees on the ordering of values inside the
1009     * array, and it may change when more values are added or removed.
1010     *
1011     * Requirements:
1012     *
1013     * - `index` must be strictly less than {length}.
1014     */
1015     function at(AddressSet storage set, uint256 index) internal view returns (address) {
1016         return address(uint160(uint256(_at(set._inner, index))));
1017     }
1018 
1019 
1020     // UintSet
1021 
1022     struct UintSet {
1023         Set _inner;
1024     }
1025 
1026     /**
1027      * @dev Add a value to a set. O(1).
1028      *
1029      * Returns true if the value was added to the set, that is if it was not
1030      * already present.
1031      */
1032     function add(UintSet storage set, uint256 value) internal returns (bool) {
1033         return _add(set._inner, bytes32(value));
1034     }
1035 
1036     /**
1037      * @dev Removes a value from a set. O(1).
1038      *
1039      * Returns true if the value was removed from the set, that is if it was
1040      * present.
1041      */
1042     function remove(UintSet storage set, uint256 value) internal returns (bool) {
1043         return _remove(set._inner, bytes32(value));
1044     }
1045 
1046     /**
1047      * @dev Returns true if the value is in the set. O(1).
1048      */
1049     function contains(UintSet storage set, uint256 value) internal view returns (bool) {
1050         return _contains(set._inner, bytes32(value));
1051     }
1052 
1053     /**
1054      * @dev Returns the number of values on the set. O(1).
1055      */
1056     function length(UintSet storage set) internal view returns (uint256) {
1057         return _length(set._inner);
1058     }
1059 
1060    /**
1061     * @dev Returns the value stored at position `index` in the set. O(1).
1062     *
1063     * Note that there are no guarantees on the ordering of values inside the
1064     * array, and it may change when more values are added or removed.
1065     *
1066     * Requirements:
1067     *
1068     * - `index` must be strictly less than {length}.
1069     */
1070     function at(UintSet storage set, uint256 index) internal view returns (uint256) {
1071         return uint256(_at(set._inner, index));
1072     }
1073 }
1074 
1075 // File: @openzeppelin/contracts/utils/EnumerableMap.sol
1076 
1077 
1078 
1079 pragma solidity >=0.6.0 <0.8.0;
1080 
1081 /**
1082  * @dev Library for managing an enumerable variant of Solidity's
1083  * https://solidity.readthedocs.io/en/latest/types.html#mapping-types[`mapping`]
1084  * type.
1085  *
1086  * Maps have the following properties:
1087  *
1088  * - Entries are added, removed, and checked for existence in constant time
1089  * (O(1)).
1090  * - Entries are enumerated in O(n). No guarantees are made on the ordering.
1091  *
1092  * ```
1093  * contract Example {
1094  *     // Add the library methods
1095  *     using EnumerableMap for EnumerableMap.UintToAddressMap;
1096  *
1097  *     // Declare a set state variable
1098  *     EnumerableMap.UintToAddressMap private myMap;
1099  * }
1100  * ```
1101  *
1102  * As of v3.0.0, only maps of type `uint256 -> address` (`UintToAddressMap`) are
1103  * supported.
1104  */
1105 library EnumerableMap {
1106     // To implement this library for multiple types with as little code
1107     // repetition as possible, we write it in terms of a generic Map type with
1108     // bytes32 keys and values.
1109     // The Map implementation uses private functions, and user-facing
1110     // implementations (such as Uint256ToAddressMap) are just wrappers around
1111     // the underlying Map.
1112     // This means that we can only create new EnumerableMaps for types that fit
1113     // in bytes32.
1114 
1115     struct MapEntry {
1116         bytes32 _key;
1117         bytes32 _value;
1118     }
1119 
1120     struct Map {
1121         // Storage of map keys and values
1122         MapEntry[] _entries;
1123 
1124         // Position of the entry defined by a key in the `entries` array, plus 1
1125         // because index 0 means a key is not in the map.
1126         mapping (bytes32 => uint256) _indexes;
1127     }
1128 
1129     /**
1130      * @dev Adds a key-value pair to a map, or updates the value for an existing
1131      * key. O(1).
1132      *
1133      * Returns true if the key was added to the map, that is if it was not
1134      * already present.
1135      */
1136     function _set(Map storage map, bytes32 key, bytes32 value) private returns (bool) {
1137         // We read and store the key's index to prevent multiple reads from the same storage slot
1138         uint256 keyIndex = map._indexes[key];
1139 
1140         if (keyIndex == 0) { // Equivalent to !contains(map, key)
1141             map._entries.push(MapEntry({ _key: key, _value: value }));
1142             // The entry is stored at length-1, but we add 1 to all indexes
1143             // and use 0 as a sentinel value
1144             map._indexes[key] = map._entries.length;
1145             return true;
1146         } else {
1147             map._entries[keyIndex - 1]._value = value;
1148             return false;
1149         }
1150     }
1151 
1152     /**
1153      * @dev Removes a key-value pair from a map. O(1).
1154      *
1155      * Returns true if the key was removed from the map, that is if it was present.
1156      */
1157     function _remove(Map storage map, bytes32 key) private returns (bool) {
1158         // We read and store the key's index to prevent multiple reads from the same storage slot
1159         uint256 keyIndex = map._indexes[key];
1160 
1161         if (keyIndex != 0) { // Equivalent to contains(map, key)
1162             // To delete a key-value pair from the _entries array in O(1), we swap the entry to delete with the last one
1163             // in the array, and then remove the last entry (sometimes called as 'swap and pop').
1164             // This modifies the order of the array, as noted in {at}.
1165 
1166             uint256 toDeleteIndex = keyIndex - 1;
1167             uint256 lastIndex = map._entries.length - 1;
1168 
1169             // When the entry to delete is the last one, the swap operation is unnecessary. However, since this occurs
1170             // so rarely, we still do the swap anyway to avoid the gas cost of adding an 'if' statement.
1171 
1172             MapEntry storage lastEntry = map._entries[lastIndex];
1173 
1174             // Move the last entry to the index where the entry to delete is
1175             map._entries[toDeleteIndex] = lastEntry;
1176             // Update the index for the moved entry
1177             map._indexes[lastEntry._key] = toDeleteIndex + 1; // All indexes are 1-based
1178 
1179             // Delete the slot where the moved entry was stored
1180             map._entries.pop();
1181 
1182             // Delete the index for the deleted slot
1183             delete map._indexes[key];
1184 
1185             return true;
1186         } else {
1187             return false;
1188         }
1189     }
1190 
1191     /**
1192      * @dev Returns true if the key is in the map. O(1).
1193      */
1194     function _contains(Map storage map, bytes32 key) private view returns (bool) {
1195         return map._indexes[key] != 0;
1196     }
1197 
1198     /**
1199      * @dev Returns the number of key-value pairs in the map. O(1).
1200      */
1201     function _length(Map storage map) private view returns (uint256) {
1202         return map._entries.length;
1203     }
1204 
1205    /**
1206     * @dev Returns the key-value pair stored at position `index` in the map. O(1).
1207     *
1208     * Note that there are no guarantees on the ordering of entries inside the
1209     * array, and it may change when more entries are added or removed.
1210     *
1211     * Requirements:
1212     *
1213     * - `index` must be strictly less than {length}.
1214     */
1215     function _at(Map storage map, uint256 index) private view returns (bytes32, bytes32) {
1216         require(map._entries.length > index, "EnumerableMap: index out of bounds");
1217 
1218         MapEntry storage entry = map._entries[index];
1219         return (entry._key, entry._value);
1220     }
1221 
1222     /**
1223      * @dev Tries to returns the value associated with `key`.  O(1).
1224      * Does not revert if `key` is not in the map.
1225      */
1226     function _tryGet(Map storage map, bytes32 key) private view returns (bool, bytes32) {
1227         uint256 keyIndex = map._indexes[key];
1228         if (keyIndex == 0) return (false, 0); // Equivalent to contains(map, key)
1229         return (true, map._entries[keyIndex - 1]._value); // All indexes are 1-based
1230     }
1231 
1232     /**
1233      * @dev Returns the value associated with `key`.  O(1).
1234      *
1235      * Requirements:
1236      *
1237      * - `key` must be in the map.
1238      */
1239     function _get(Map storage map, bytes32 key) private view returns (bytes32) {
1240         uint256 keyIndex = map._indexes[key];
1241         require(keyIndex != 0, "EnumerableMap: nonexistent key"); // Equivalent to contains(map, key)
1242         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1243     }
1244 
1245     /**
1246      * @dev Same as {_get}, with a custom error message when `key` is not in the map.
1247      *
1248      * CAUTION: This function is deprecated because it requires allocating memory for the error
1249      * message unnecessarily. For custom revert reasons use {_tryGet}.
1250      */
1251     function _get(Map storage map, bytes32 key, string memory errorMessage) private view returns (bytes32) {
1252         uint256 keyIndex = map._indexes[key];
1253         require(keyIndex != 0, errorMessage); // Equivalent to contains(map, key)
1254         return map._entries[keyIndex - 1]._value; // All indexes are 1-based
1255     }
1256 
1257     // UintToAddressMap
1258 
1259     struct UintToAddressMap {
1260         Map _inner;
1261     }
1262 
1263     /**
1264      * @dev Adds a key-value pair to a map, or updates the value for an existing
1265      * key. O(1).
1266      *
1267      * Returns true if the key was added to the map, that is if it was not
1268      * already present.
1269      */
1270     function set(UintToAddressMap storage map, uint256 key, address value) internal returns (bool) {
1271         return _set(map._inner, bytes32(key), bytes32(uint256(uint160(value))));
1272     }
1273 
1274     /**
1275      * @dev Removes a value from a set. O(1).
1276      *
1277      * Returns true if the key was removed from the map, that is if it was present.
1278      */
1279     function remove(UintToAddressMap storage map, uint256 key) internal returns (bool) {
1280         return _remove(map._inner, bytes32(key));
1281     }
1282 
1283     /**
1284      * @dev Returns true if the key is in the map. O(1).
1285      */
1286     function contains(UintToAddressMap storage map, uint256 key) internal view returns (bool) {
1287         return _contains(map._inner, bytes32(key));
1288     }
1289 
1290     /**
1291      * @dev Returns the number of elements in the map. O(1).
1292      */
1293     function length(UintToAddressMap storage map) internal view returns (uint256) {
1294         return _length(map._inner);
1295     }
1296 
1297    /**
1298     * @dev Returns the element stored at position `index` in the set. O(1).
1299     * Note that there are no guarantees on the ordering of values inside the
1300     * array, and it may change when more values are added or removed.
1301     *
1302     * Requirements:
1303     *
1304     * - `index` must be strictly less than {length}.
1305     */
1306     function at(UintToAddressMap storage map, uint256 index) internal view returns (uint256, address) {
1307         (bytes32 key, bytes32 value) = _at(map._inner, index);
1308         return (uint256(key), address(uint160(uint256(value))));
1309     }
1310 
1311     /**
1312      * @dev Tries to returns the value associated with `key`.  O(1).
1313      * Does not revert if `key` is not in the map.
1314      *
1315      * _Available since v3.4._
1316      */
1317     function tryGet(UintToAddressMap storage map, uint256 key) internal view returns (bool, address) {
1318         (bool success, bytes32 value) = _tryGet(map._inner, bytes32(key));
1319         return (success, address(uint160(uint256(value))));
1320     }
1321 
1322     /**
1323      * @dev Returns the value associated with `key`.  O(1).
1324      *
1325      * Requirements:
1326      *
1327      * - `key` must be in the map.
1328      */
1329     function get(UintToAddressMap storage map, uint256 key) internal view returns (address) {
1330         return address(uint160(uint256(_get(map._inner, bytes32(key)))));
1331     }
1332 
1333     /**
1334      * @dev Same as {get}, with a custom error message when `key` is not in the map.
1335      *
1336      * CAUTION: This function is deprecated because it requires allocating memory for the error
1337      * message unnecessarily. For custom revert reasons use {tryGet}.
1338      */
1339     function get(UintToAddressMap storage map, uint256 key, string memory errorMessage) internal view returns (address) {
1340         return address(uint160(uint256(_get(map._inner, bytes32(key), errorMessage))));
1341     }
1342 }
1343 
1344 // File: @openzeppelin/contracts/utils/Strings.sol
1345 
1346 
1347 
1348 pragma solidity >=0.6.0 <0.8.0;
1349 
1350 /**
1351  * @dev String operations.
1352  */
1353 library Strings {
1354     /**
1355      * @dev Converts a `uint256` to its ASCII `string` representation.
1356      */
1357     function toString(uint256 value) internal pure returns (string memory) {
1358         // Inspired by OraclizeAPI's implementation - MIT licence
1359         // https://github.com/oraclize/ethereum-api/blob/b42146b063c7d6ee1358846c198246239e9360e8/oraclizeAPI_0.4.25.sol
1360 
1361         if (value == 0) {
1362             return "0";
1363         }
1364         uint256 temp = value;
1365         uint256 digits;
1366         while (temp != 0) {
1367             digits++;
1368             temp /= 10;
1369         }
1370         bytes memory buffer = new bytes(digits);
1371         uint256 index = digits - 1;
1372         temp = value;
1373         while (temp != 0) {
1374             buffer[index--] = bytes1(uint8(48 + temp % 10));
1375             temp /= 10;
1376         }
1377         return string(buffer);
1378     }
1379 }
1380 
1381 // File: @openzeppelin/contracts/token/ERC721/ERC721.sol
1382 
1383 
1384 
1385 pragma solidity >=0.6.0 <0.8.0;
1386 
1387 /**
1388  * @title ERC721 Non-Fungible Token Standard basic implementation
1389  * @dev see https://eips.ethereum.org/EIPS/eip-721
1390  */
1391  
1392 contract ERC721 is Context, ERC165, IERC721, IERC721Metadata, IERC721Enumerable {
1393     using SafeMath for uint256;
1394     using Address for address;
1395     using EnumerableSet for EnumerableSet.UintSet;
1396     using EnumerableMap for EnumerableMap.UintToAddressMap;
1397     using Strings for uint256;
1398 
1399     // Equals to `bytes4(keccak256("onERC721Received(address,address,uint256,bytes)"))`
1400     // which can be also obtained as `IERC721Receiver(0).onERC721Received.selector`
1401     bytes4 private constant _ERC721_RECEIVED = 0x150b7a02;
1402 
1403     // Mapping from holder address to their (enumerable) set of owned tokens
1404     mapping (address => EnumerableSet.UintSet) private _holderTokens;
1405 
1406     // Enumerable mapping from token ids to their owners
1407     EnumerableMap.UintToAddressMap private _tokenOwners;
1408 
1409     // Mapping from token ID to approved address
1410     mapping (uint256 => address) private _tokenApprovals;
1411 
1412     // Mapping from owner to operator approvals
1413     mapping (address => mapping (address => bool)) private _operatorApprovals;
1414 
1415     // Token name
1416     string private _name;
1417 
1418     // Token symbol
1419     string private _symbol;
1420 
1421     // Optional mapping for token URIs
1422     mapping (uint256 => string) private _tokenURIs;
1423 
1424     // Base URI
1425     string private _baseURI;
1426 
1427     /*
1428      *     bytes4(keccak256('balanceOf(address)')) == 0x70a08231
1429      *     bytes4(keccak256('ownerOf(uint256)')) == 0x6352211e
1430      *     bytes4(keccak256('approve(address,uint256)')) == 0x095ea7b3
1431      *     bytes4(keccak256('getApproved(uint256)')) == 0x081812fc
1432      *     bytes4(keccak256('setApprovalForAll(address,bool)')) == 0xa22cb465
1433      *     bytes4(keccak256('isApprovedForAll(address,address)')) == 0xe985e9c5
1434      *     bytes4(keccak256('transferFrom(address,address,uint256)')) == 0x23b872dd
1435      *     bytes4(keccak256('safeTransferFrom(address,address,uint256)')) == 0x42842e0e
1436      *     bytes4(keccak256('safeTransferFrom(address,address,uint256,bytes)')) == 0xb88d4fde
1437      *
1438      *     => 0x70a08231 ^ 0x6352211e ^ 0x095ea7b3 ^ 0x081812fc ^
1439      *        0xa22cb465 ^ 0xe985e9c5 ^ 0x23b872dd ^ 0x42842e0e ^ 0xb88d4fde == 0x80ac58cd
1440      */
1441     bytes4 private constant _INTERFACE_ID_ERC721 = 0x80ac58cd;
1442 
1443     /*
1444      *     bytes4(keccak256('name()')) == 0x06fdde03
1445      *     bytes4(keccak256('symbol()')) == 0x95d89b41
1446      *     bytes4(keccak256('tokenURI(uint256)')) == 0xc87b56dd
1447      *
1448      *     => 0x06fdde03 ^ 0x95d89b41 ^ 0xc87b56dd == 0x5b5e139f
1449      */
1450     bytes4 private constant _INTERFACE_ID_ERC721_METADATA = 0x5b5e139f;
1451 
1452     /*
1453      *     bytes4(keccak256('totalSupply()')) == 0x18160ddd
1454      *     bytes4(keccak256('tokenOfOwnerByIndex(address,uint256)')) == 0x2f745c59
1455      *     bytes4(keccak256('tokenByIndex(uint256)')) == 0x4f6ccce7
1456      *
1457      *     => 0x18160ddd ^ 0x2f745c59 ^ 0x4f6ccce7 == 0x780e9d63
1458      */
1459     bytes4 private constant _INTERFACE_ID_ERC721_ENUMERABLE = 0x780e9d63;
1460 
1461     /**
1462      * @dev Initializes the contract by setting a `name` and a `symbol` to the token collection.
1463      */
1464     constructor (string memory name_, string memory symbol_) public {
1465         _name = name_;
1466         _symbol = symbol_;
1467 
1468         // register the supported interfaces to conform to ERC721 via ERC165
1469         _registerInterface(_INTERFACE_ID_ERC721);
1470         _registerInterface(_INTERFACE_ID_ERC721_METADATA);
1471         _registerInterface(_INTERFACE_ID_ERC721_ENUMERABLE);
1472     }
1473 
1474     /**
1475      * @dev See {IERC721-balanceOf}.
1476      */
1477     function balanceOf(address owner) public view virtual override returns (uint256) {
1478         require(owner != address(0), "ERC721: balance query for the zero address");
1479         return _holderTokens[owner].length();
1480     }
1481 
1482     /**
1483      * @dev See {IERC721-ownerOf}.
1484      */
1485     function ownerOf(uint256 tokenId) public view virtual override returns (address) {
1486         return _tokenOwners.get(tokenId, "ERC721: owner query for nonexistent token");
1487     }
1488 
1489     /**
1490      * @dev See {IERC721Metadata-name}.
1491      */
1492     function name() public view virtual override returns (string memory) {
1493         return _name;
1494     }
1495 
1496     /**
1497      * @dev See {IERC721Metadata-symbol}.
1498      */
1499     function symbol() public view virtual override returns (string memory) {
1500         return _symbol;
1501     }
1502 
1503     /**
1504      * @dev See {IERC721Metadata-tokenURI}.
1505      */
1506     function tokenURI(uint256 tokenId) public view virtual override returns (string memory) {
1507         require(_exists(tokenId), "ERC721Metadata: URI query for nonexistent token");
1508 
1509         string memory _tokenURI = _tokenURIs[tokenId];
1510         string memory base = baseURI();
1511 
1512         // If there is no base URI, return the token URI.
1513         if (bytes(base).length == 0) {
1514             return _tokenURI;
1515         }
1516         // If both are set, concatenate the baseURI and tokenURI (via abi.encodePacked).
1517         if (bytes(_tokenURI).length > 0) {
1518             return string(abi.encodePacked(base, _tokenURI));
1519         }
1520         // If there is a baseURI but no tokenURI, concatenate the tokenID to the baseURI.
1521         return string(abi.encodePacked(base, tokenId.toString()));
1522     }
1523 
1524     /**
1525     * @dev Returns the base URI set via {_setBaseURI}. This will be
1526     * automatically added as a prefix in {tokenURI} to each token's URI, or
1527     * to the token ID if no specific URI is set for that token ID.
1528     */
1529     function baseURI() public view virtual returns (string memory) {
1530         return _baseURI;
1531     }
1532 
1533     /**
1534      * @dev See {IERC721Enumerable-tokenOfOwnerByIndex}.
1535      */
1536     function tokenOfOwnerByIndex(address owner, uint256 index) public view virtual override returns (uint256) {
1537         return _holderTokens[owner].at(index);
1538     }
1539 
1540     /**
1541      * @dev See {IERC721Enumerable-totalSupply}.
1542      */
1543     function totalSupply() public view virtual override returns (uint256) {
1544         // _tokenOwners are indexed by tokenIds, so .length() returns the number of tokenIds
1545         return _tokenOwners.length();
1546     }
1547 
1548     /**
1549      * @dev See {IERC721Enumerable-tokenByIndex}.
1550      */
1551     function tokenByIndex(uint256 index) public view virtual override returns (uint256) {
1552         (uint256 tokenId, ) = _tokenOwners.at(index);
1553         return tokenId;
1554     }
1555 
1556     /**
1557      * @dev See {IERC721-approve}.
1558      */
1559     function approve(address to, uint256 tokenId) public virtual override {
1560         address owner = ERC721.ownerOf(tokenId);
1561         require(to != owner, "ERC721: approval to current owner");
1562 
1563         require(_msgSender() == owner || ERC721.isApprovedForAll(owner, _msgSender()),
1564             "ERC721: approve caller is not owner nor approved for all"
1565         );
1566 
1567         _approve(to, tokenId);
1568     }
1569 
1570     /**
1571      * @dev See {IERC721-getApproved}.
1572      */
1573     function getApproved(uint256 tokenId) public view virtual override returns (address) {
1574         require(_exists(tokenId), "ERC721: approved query for nonexistent token");
1575 
1576         return _tokenApprovals[tokenId];
1577     }
1578 
1579     /**
1580      * @dev See {IERC721-setApprovalForAll}.
1581      */
1582     function setApprovalForAll(address operator, bool approved) public virtual override {
1583         require(operator != _msgSender(), "ERC721: approve to caller");
1584 
1585         _operatorApprovals[_msgSender()][operator] = approved;
1586         emit ApprovalForAll(_msgSender(), operator, approved);
1587     }
1588 
1589     /**
1590      * @dev See {IERC721-isApprovedForAll}.
1591      */
1592     function isApprovedForAll(address owner, address operator) public view virtual override returns (bool) {
1593         return _operatorApprovals[owner][operator];
1594     }
1595 
1596     /**
1597      * @dev See {IERC721-transferFrom}.
1598      */
1599     function transferFrom(address from, address to, uint256 tokenId) public virtual override {
1600         //solhint-disable-next-line max-line-length
1601         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1602 
1603         _transfer(from, to, tokenId);
1604     }
1605 
1606     /**
1607      * @dev See {IERC721-safeTransferFrom}.
1608      */
1609     function safeTransferFrom(address from, address to, uint256 tokenId) public virtual override {
1610         safeTransferFrom(from, to, tokenId, "");
1611     }
1612 
1613     /**
1614      * @dev See {IERC721-safeTransferFrom}.
1615      */
1616     function safeTransferFrom(address from, address to, uint256 tokenId, bytes memory _data) public virtual override {
1617         require(_isApprovedOrOwner(_msgSender(), tokenId), "ERC721: transfer caller is not owner nor approved");
1618         _safeTransfer(from, to, tokenId, _data);
1619     }
1620 
1621     /**
1622      * @dev Safely transfers `tokenId` token from `from` to `to`, checking first that contract recipients
1623      * are aware of the ERC721 protocol to prevent tokens from being forever locked.
1624      *
1625      * `_data` is additional data, it has no specified format and it is sent in call to `to`.
1626      *
1627      * This internal function is equivalent to {safeTransferFrom}, and can be used to e.g.
1628      * implement alternative mechanisms to perform token transfer, such as signature-based.
1629      *
1630      * Requirements:
1631      *
1632      * - `from` cannot be the zero address.
1633      * - `to` cannot be the zero address.
1634      * - `tokenId` token must exist and be owned by `from`.
1635      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1636      *
1637      * Emits a {Transfer} event.
1638      */
1639     function _safeTransfer(address from, address to, uint256 tokenId, bytes memory _data) internal virtual {
1640         _transfer(from, to, tokenId);
1641         require(_checkOnERC721Received(from, to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1642     }
1643 
1644     /**
1645      * @dev Returns whether `tokenId` exists.
1646      *
1647      * Tokens can be managed by their owner or approved accounts via {approve} or {setApprovalForAll}.
1648      *
1649      * Tokens start existing when they are minted (`_mint`),
1650      * and stop existing when they are burned (`_burn`).
1651      */
1652     function _exists(uint256 tokenId) internal view virtual returns (bool) {
1653         return _tokenOwners.contains(tokenId);
1654     }
1655 
1656     /**
1657      * @dev Returns whether `spender` is allowed to manage `tokenId`.
1658      *
1659      * Requirements:
1660      *
1661      * - `tokenId` must exist.
1662      */
1663     function _isApprovedOrOwner(address spender, uint256 tokenId) internal view virtual returns (bool) {
1664         require(_exists(tokenId), "ERC721: operator query for nonexistent token");
1665         address owner = ERC721.ownerOf(tokenId);
1666         return (spender == owner || getApproved(tokenId) == spender || ERC721.isApprovedForAll(owner, spender));
1667     }
1668 
1669     /**
1670      * @dev Safely mints `tokenId` and transfers it to `to`.
1671      *
1672      * Requirements:
1673      d*
1674      * - `tokenId` must not exist.
1675      * - If `to` refers to a smart contract, it must implement {IERC721Receiver-onERC721Received}, which is called upon a safe transfer.
1676      *
1677      * Emits a {Transfer} event.
1678      */
1679     function _safeMint(address to, uint256 tokenId) internal virtual {
1680         _safeMint(to, tokenId, "");
1681     }
1682 
1683     /**
1684      * @dev Same as {xref-ERC721-_safeMint-address-uint256-}[`_safeMint`], with an additional `data` parameter which is
1685      * forwarded in {IERC721Receiver-onERC721Received} to contract recipients.
1686      */
1687     function _safeMint(address to, uint256 tokenId, bytes memory _data) internal virtual {
1688         _mint(to, tokenId);
1689         require(_checkOnERC721Received(address(0), to, tokenId, _data), "ERC721: transfer to non ERC721Receiver implementer");
1690     }
1691 
1692     /**
1693      * @dev Mints `tokenId` and transfers it to `to`.
1694      *
1695      * WARNING: Usage of this method is discouraged, use {_safeMint} whenever possible
1696      *
1697      * Requirements:
1698      *
1699      * - `tokenId` must not exist.
1700      * - `to` cannot be the zero address.
1701      *
1702      * Emits a {Transfer} event.
1703      */
1704     function _mint(address to, uint256 tokenId) internal virtual {
1705         require(to != address(0), "ERC721: mint to the zero address");
1706         require(!_exists(tokenId), "ERC721: token already minted");
1707 
1708         _beforeTokenTransfer(address(0), to, tokenId);
1709 
1710         _holderTokens[to].add(tokenId);
1711 
1712         _tokenOwners.set(tokenId, to);
1713 
1714         emit Transfer(address(0), to, tokenId);
1715     }
1716 
1717     /**
1718      * @dev Destroys `tokenId`.
1719      * The approval is cleared when the token is burned.
1720      *
1721      * Requirements:
1722      *
1723      * - `tokenId` must exist.
1724      *
1725      * Emits a {Transfer} event.
1726      */
1727     function _burn(uint256 tokenId) internal virtual {
1728         address owner = ERC721.ownerOf(tokenId); // internal owner
1729 
1730         _beforeTokenTransfer(owner, address(0), tokenId);
1731 
1732         // Clear approvals
1733         _approve(address(0), tokenId);
1734 
1735         // Clear metadata (if any)
1736         if (bytes(_tokenURIs[tokenId]).length != 0) {
1737             delete _tokenURIs[tokenId];
1738         }
1739 
1740         _holderTokens[owner].remove(tokenId);
1741 
1742         _tokenOwners.remove(tokenId);
1743 
1744         emit Transfer(owner, address(0), tokenId);
1745     }
1746 
1747     /**
1748      * @dev Transfers `tokenId` from `from` to `to`.
1749      *  As opposed to {transferFrom}, this imposes no restrictions on msg.sender.
1750      *
1751      * Requirements:
1752      *
1753      * - `to` cannot be the zero address.
1754      * - `tokenId` token must be owned by `from`.
1755      *
1756      * Emits a {Transfer} event.
1757      */
1758     function _transfer(address from, address to, uint256 tokenId) internal virtual {
1759         require(ERC721.ownerOf(tokenId) == from, "ERC721: transfer of token that is not own"); // internal owner
1760         require(to != address(0), "ERC721: transfer to the zero address");
1761 
1762         _beforeTokenTransfer(from, to, tokenId);
1763 
1764         // Clear approvals from the previous owner
1765         _approve(address(0), tokenId);
1766 
1767         _holderTokens[from].remove(tokenId);
1768         _holderTokens[to].add(tokenId);
1769 
1770         _tokenOwners.set(tokenId, to);
1771 
1772         emit Transfer(from, to, tokenId);
1773     }
1774 
1775     /**
1776      * @dev Sets `_tokenURI` as the tokenURI of `tokenId`.
1777      *
1778      * Requirements:
1779      *
1780      * - `tokenId` must exist.
1781      */
1782     function _setTokenURI(uint256 tokenId, string memory _tokenURI) internal virtual {
1783         require(_exists(tokenId), "ERC721Metadata: URI set of nonexistent token");
1784         _tokenURIs[tokenId] = _tokenURI;
1785     }
1786 
1787     /**
1788      * @dev Internal function to set the base URI for all token IDs. It is
1789      * automatically added as a prefix to the value returned in {tokenURI},
1790      * or to the token ID if {tokenURI} is empty.
1791      */
1792     function _setBaseURI(string memory baseURI_) internal virtual {
1793         _baseURI = baseURI_;
1794     }
1795 
1796     /**
1797      * @dev Internal function to invoke {IERC721Receiver-onERC721Received} on a target address.
1798      * The call is not executed if the target address is not a contract.
1799      *
1800      * @param from address representing the previous owner of the given token ID
1801      * @param to target address that will receive the tokens
1802      * @param tokenId uint256 ID of the token to be transferred
1803      * @param _data bytes optional data to send along with the call
1804      * @return bool whether the call correctly returned the expected magic value
1805      */
1806     function _checkOnERC721Received(address from, address to, uint256 tokenId, bytes memory _data)
1807         private returns (bool)
1808     {
1809         if (!to.isContract()) {
1810             return true;
1811         }
1812         bytes memory returndata = to.functionCall(abi.encodeWithSelector(
1813             IERC721Receiver(to).onERC721Received.selector,
1814             _msgSender(),
1815             from,
1816             tokenId,
1817             _data
1818         ), "ERC721: transfer to non ERC721Receiver implementer");
1819         bytes4 retval = abi.decode(returndata, (bytes4));
1820         return (retval == _ERC721_RECEIVED);
1821     }
1822 
1823     /**
1824      * @dev Approve `to` to operate on `tokenId`
1825      *
1826      * Emits an {Approval} event.
1827      */
1828     function _approve(address to, uint256 tokenId) internal virtual {
1829         _tokenApprovals[tokenId] = to;
1830         emit Approval(ERC721.ownerOf(tokenId), to, tokenId); // internal owner
1831     }
1832 
1833     /**
1834      * @dev Hook that is called before any token transfer. This includes minting
1835      * and burning.
1836      *
1837      * Calling conditions:
1838      *
1839      * - When `from` and `to` are both non-zero, ``from``'s `tokenId` will be
1840      * transferred to `to`.
1841      * - When `from` is zero, `tokenId` will be minted for `to`.
1842      * - When `to` is zero, ``from``'s `tokenId` will be burned.
1843      * - `from` cannot be the zero address.
1844      * - `to` cannot be the zero address.
1845      *
1846      * To learn more about hooks, head to xref:ROOT:extending-contracts.adoc#using-hooks[Using Hooks].
1847      */
1848     function _beforeTokenTransfer(address from, address to, uint256 tokenId) internal virtual { }
1849 }
1850 
1851 // File: @openzeppelin/contracts/access/Ownable.sol
1852 
1853 
1854 
1855 pragma solidity >=0.6.0 <0.8.0;
1856 
1857 /**
1858  * @dev Contract module which provides a basic access control mechanism, where
1859  * there is an account (an owner) that can be granted exclusive access to
1860  * specific functions.
1861  *
1862  * By default, the owner account will be the one that deploys the contract. This
1863  * can later be changed with {transferOwnership}.
1864  *
1865  * This module is used through inheritance. It will make available the modifier
1866  * `onlyOwner`, which can be applied to your functions to restrict their use to
1867  * the owner.
1868  */
1869 abstract contract Ownable is Context {
1870     address private _owner;
1871 
1872     event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);
1873 
1874     /**
1875      * @dev Initializes the contract setting the deployer as the initial owner.
1876      */
1877     constructor () internal {
1878         address msgSender = _msgSender();
1879         _owner = msgSender;
1880         emit OwnershipTransferred(address(0), msgSender);
1881     }
1882 
1883     /**
1884      * @dev Returns the address of the current owner.
1885      */
1886     function owner() public view virtual returns (address) {
1887         return _owner;
1888     }
1889 
1890     /**
1891      * @dev Throws if called by any account other than the owner.
1892      */
1893     modifier onlyOwner() {
1894         require(owner() == _msgSender(), "Ownable: caller is not the owner");
1895         _;
1896     }
1897 
1898     /**
1899      * @dev Leaves the contract without owner. It will not be possible to call
1900      * `onlyOwner` functions anymore. Can only be called by the current owner.
1901      *
1902      * NOTE: Renouncing ownership will leave the contract without an owner,
1903      * thereby removing any functionality that is only available to the owner.
1904      */
1905     function renounceOwnership() public virtual onlyOwner {
1906         emit OwnershipTransferred(_owner, address(0));
1907         _owner = address(0);
1908     }
1909 
1910     /**
1911      * @dev Transfers ownership of the contract to a new account (`newOwner`).
1912      * Can only be called by the current owner.
1913      */
1914     function transferOwnership(address newOwner) public virtual onlyOwner {
1915         require(newOwner != address(0), "Ownable: new owner is the zero address");
1916         emit OwnershipTransferred(_owner, newOwner);
1917         _owner = newOwner;
1918     }
1919 }
1920 
1921 pragma solidity ^0.7.0;
1922 abstract contract ReentrancyGuard {
1923     // Booleans are more expensive than uint256 or any type that takes up a full
1924     // word because each write operation emits an extra SLOAD to first read the
1925     // slot's contents, replace the bits taken up by the boolean, and then write
1926     // back. This is the compiler's defense against contract upgrades and
1927     // pointer aliasing, and it cannot be disabled.
1928 
1929     // The values being non-zero value makes deployment a bit more expensive,
1930     // but in exchange the refund on every call to nonReentrant will be lower in
1931     // amount. Since refunds are capped to a percentage of the total
1932     // transaction's gas, it is best to keep them low in cases like this one, to
1933     // increase the likelihood of the full refund coming into effect.
1934     uint256 private constant _NOT_ENTERED = 1;
1935     uint256 private constant _ENTERED = 2;
1936 
1937     uint256 private _status;
1938 
1939     constructor() {
1940         _status = _NOT_ENTERED;
1941     }
1942 
1943     /**
1944      * @dev Prevents a contract from calling itself, directly or indirectly.
1945      * Calling a `nonReentrant` function from another `nonReentrant`
1946      * function is not supported. It is possible to prevent this from happening
1947      * by making the `nonReentrant` function external, and making it call a
1948      * `private` function that does the actual work.
1949      */
1950     modifier nonReentrant() {
1951         // On the first call to nonReentrant, _notEntered will be true
1952         require(_status != _ENTERED, "ReentrancyGuard: reentrant call");
1953 
1954         // Any calls to nonReentrant after this point will fail
1955         _status = _ENTERED;
1956 
1957         _;
1958 
1959         // By storing the original value once again, a refund is triggered (see
1960         // https://eips.ethereum.org/EIPS/eip-2200)
1961         _status = _NOT_ENTERED;
1962     }
1963 }
1964 
1965 pragma solidity ^0.7.0;
1966 pragma experimental ABIEncoderV2;
1967 
1968 contract Monarchs is ERC721, ReentrancyGuard, Ownable{
1969     
1970     using SafeMath for uint256;
1971 
1972     string public MONARCH_PROVENANCE = ""; // IPFS URL WILL BE ADDED WHEN MONARCHS ARE ALL SOLD OUT
1973     
1974     string public LICENSE_TEXT = ""; // IT IS WHAT IT SAYS
1975     
1976     uint public constant maxMonarchPurchase = 10;
1977     uint public monarchReserve = 35;
1978     
1979     uint256 public monarchPerAddressLimit = 1;
1980     uint256 public monarchPrice = 800000000000000000; // 0.8 ETH
1981     uint256 public constant MAX_MONARCHS = 888;
1982     uint256 public constant MAX_PRESALE = 444;
1983 
1984     bool provenanceLocked = false; // TEAM CAN'T EDIT THE LICENSE AFTER THIS GETS TRUE
1985     bool public saleIsActive = false;
1986     bool public limitPerOrder = false;
1987     bool public onlyWhitelisted = true;
1988     
1989     // set withdrawal address 
1990     
1991     address payable public withdrawalAddress;
1992     address[] public whitelistedAddresses;
1993     mapping(address => uint256) public addressMintedBalance;
1994 
1995     mapping(uint => string) public monarchNames;
1996     mapping(address => bool) isWhitelisted;
1997     
1998     // event monarchNameChange(address _by, uint _tokenId, string _name);
1999     
2000     event provenanceisLocked(string _monarchProvenance);
2001 
2002     constructor(
2003         address payable givenWithdrawalAddress
2004     ) ERC721("Monarchs", "MONARCH") {
2005         withdrawalAddress = givenWithdrawalAddress;
2006      }
2007     
2008     function withdraw() public onlyOwner {
2009         uint balance = address(this).balance;
2010         (bool success, ) = withdrawalAddress.call{value:balance}("");
2011         require(success, "Transfer failed.");
2012     }
2013 
2014     function setMonarchPerAddressLimit (uint256 _limit) public onlyOwner {
2015         monarchPerAddressLimit = _limit;
2016     }
2017     
2018     function reserveMonarchs(address _to, uint256 _reserveAmount) public onlyOwner {        
2019         uint supply = totalSupply();
2020         require(_reserveAmount > 0 && _reserveAmount <= monarchReserve, "Not enough reserve left for team");
2021         for (uint i = 0; i < _reserveAmount; i++) {
2022             _safeMint(_to, supply + i);
2023         }
2024         monarchReserve = monarchReserve.sub(_reserveAmount);
2025     }
2026 
2027 
2028 
2029     function setProvenanceHash(string memory provenanceHash) public onlyOwner {
2030         MONARCH_PROVENANCE = provenanceHash;
2031     }
2032 
2033     function setLimitPerOrder(bool _state) public onlyOwner {
2034         limitPerOrder = _state;
2035     }
2036 
2037     function lockProvenance() public onlyOwner {
2038         provenanceLocked =  true;
2039         emit provenanceisLocked(MONARCH_PROVENANCE);
2040     }
2041     
2042     function setBaseURI(string memory baseURI) public onlyOwner {
2043         _setBaseURI(baseURI);
2044     }
2045 
2046 
2047     function setSaleStates(bool _onlyWhitelisted, bool _limitPerOrder, bool _saleIsActive) public onlyOwner { 
2048         onlyWhitelisted = _onlyWhitelisted;
2049         limitPerOrder = _limitPerOrder;
2050         saleIsActive = _saleIsActive; 
2051 
2052         }
2053 
2054      function setWithdrawalAddress(address payable givenWithdrawalAddress) public onlyOwner {
2055         withdrawalAddress = givenWithdrawalAddress;
2056     }
2057 
2058     
2059     function tokensOfOwner(address _owner) external view returns(uint256[] memory ) {
2060         uint256 tokenCount = balanceOf(_owner);
2061         if (tokenCount == 0) {
2062             // Return an empty array
2063             return new uint256[](0);
2064         } else {
2065             uint256[] memory result = new uint256[](tokenCount);
2066             uint256 index;
2067             for (index = 0; index < tokenCount; index++) {
2068                 result[index] = tokenOfOwnerByIndex(_owner, index);
2069             }
2070             return result;
2071         }
2072     }
2073     
2074     function mintMonarch(uint numberOfTokens) public payable nonReentrant {
2075         require(saleIsActive, "Sale must be active to mint Monarchs");
2076         require(numberOfTokens > 0 && numberOfTokens <= maxMonarchPurchase, "Can only mint 10 tokens at a time");
2077         uint256 ownerMintedCount = addressMintedBalance[msg.sender];
2078           
2079         if (limitPerOrder == true) {
2080             require(ownerMintedCount + numberOfTokens <= monarchPerAddressLimit, "Max NFT per address exceeded");
2081         }
2082  
2083         if(onlyWhitelisted == true) {
2084             require(isWhitelisted[msg.sender], "not on whitelist");
2085         
2086 
2087             require(totalSupply().add(numberOfTokens) <= MAX_PRESALE, "Purchase would exceed max supply of Presale Monarchs");
2088         } else {
2089              require(totalSupply().add(numberOfTokens) <= MAX_MONARCHS, "Purchase would exceed max supply of Monarchs");
2090         }
2091 
2092         if (numberOfTokens == 10) {
2093             monarchPrice = 600000000000000000; // 0.6 ETH
2094             require(monarchPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
2095         } else if (numberOfTokens >= 5) {
2096             monarchPrice = 700000000000000000; // 0.7 ETH
2097             require(monarchPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
2098         } else if (numberOfTokens >= 3) {
2099             monarchPrice = 750000000000000000; // 0.75 ETH
2100             require(monarchPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
2101         } else {
2102             monarchPrice = 800000000000000000; // 0.8 ETH
2103             require(monarchPrice.mul(numberOfTokens) <= msg.value, "Ether value sent is not correct");
2104         }
2105 
2106         
2107         for(uint i = 1; i <= numberOfTokens; i++) {
2108             uint mintIndex = totalSupply();
2109             if (totalSupply() < MAX_MONARCHS) {
2110                 addressMintedBalance[msg.sender]++;
2111                 _safeMint(msg.sender, mintIndex);
2112             }
2113         }
2114 
2115     }
2116     
2117     
2118     // GET ALL MONARCHS OF A WALLET AS AN ARRAY OF STRINGS. WOULD BE BETTER MAYBE IF IT RETURNED A STRUCT WITH ID-NAME MATCH
2119     function monarchNamesOfOwner(address _owner) external view returns(string[] memory ) {
2120         uint256 tokenCount = balanceOf(_owner);
2121         if (tokenCount == 0) {
2122             // Return an empty array
2123             return new string[](0);
2124         } else {
2125             string[] memory result = new string[](tokenCount);
2126             uint256 index;
2127             for (index = 0; index < tokenCount; index++) {
2128                 result[index] = monarchNames[ tokenOfOwnerByIndex(_owner, index) ] ;
2129             }
2130             return result;
2131         }
2132     }
2133 
2134 function setOnlyWhitelisted(bool _state) public onlyOwner {
2135     onlyWhitelisted = _state;
2136 }
2137  
2138  function setWhitelistStatus(address[] calldata newAddresses, bool _state) public onlyOwner {
2139     for (uint256 atAddress = 0; atAddress < newAddresses.length; atAddress++) {
2140       isWhitelisted[newAddresses[atAddress]] = _state;
2141     }
2142   }
2143 
2144     
2145 }